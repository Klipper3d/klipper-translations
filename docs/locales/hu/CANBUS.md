# CANBUS

Ez a dokumentum a Klipper CAN busz támogatását írja le.

## Eszköz Hardver

A Klipper jelenleg támogatja a CAN-t az stm32, SAME5x és rp2040 chipeken. Ezenkívül a mikrokontroller chipnek olyan lapkán kell lennie, amely CAN csatlakozással rendelkezik.

A CAN-hez való fordításhoz futtasd a `make menuconfig` parancsot, és válaszd a "CAN busz" kommunikációs interfészt. Végül fordítsd le a mikrokontroller kódját, és égesd a céllapra.

## Gazdagép Hardver

A CAN-busz használatához szükség van egy host-adapterre. Ajánlott egy "USB to CAN adapter" használata. Számos különböző USB-ről CAN-ra történő adapter áll rendelkezésre a különböző gyártóktól. Az egyik kiválasztásakor javasoljuk, hogy ellenőrizd, hogy a firmware frissíthető-e rajta. (Sajnos azt tapasztaltuk, hogy néhány USB-adapter hibás firmware-t futtat, és le van zárva, ezért vásárlás előtt ellenőrizd). Olyan adaptereket keress, amelyek közvetlenül futtatják a Klippert (az "USB to CAN bridge mode" módban), vagy amelyeken a [candlelight firmware](https://github.com/candle-usb/candleLight_fw) fut.

Az adapter használatához a gazdagép operációs rendszert is konfigurálni kell. Ez általában úgy történik, hogy létrehozunk egy új `/etc/network/interfaces.d/can0` nevű fájlt a következő tartalommal:

```
allow-hotplug can0
iface can0 can static
         bitrate 1000000
         up ifconfig $IFACE txqueuelen 128
```

## Az ellenállások megszüntetése

A CAN-buszon két 120 ohmos ellenállásnak kell lennie a CANH és CANL vezetékek között. Ideális esetben egy-egy ellenállás a busz mindkét végén található.

Vedd figyelembe, hogy egyes eszközök beépített 120 ohmos ellenállással rendelkeznek, amelyet nem lehet könnyen eltávolítani. Egyes eszközök egyáltalán nem tartalmaznak ellenállást. Más eszközök rendelkeznek az ellenállás kiválasztására szolgáló mechanizmussal (általában egy "pin jumper" csatlakoztatásával). Mindenképpen ellenőrizd a CAN-buszon lévő összes eszköz kapcsolási rajzát, hogy a buszon két és csakis két 120 Ohm-os ellenállás legyen.

Az ellenállások értékének teszteléséhez a nyomtatót áramtalaníthatod, és egy multiméterrel ellenőrizheted a CANH és CANL vezetékek közötti ellenállást. Egy helyesen bekötött CAN-buszon ~60 ohmot kell mérned.

## A canbus_uuid keresése új mikrovezérlőkhöz

A CAN-buszon lévő minden mikrovezérlőhöz egyedi azonosítót rendelnek a gyári chipazonosító alapján, amely minden mikrovezérlőbe kódolva van. Az egyes mikrokontrollerek eszközazonosítójának megtalálásához győződj meg arról, hogy a hardver megfelelően van bekapcsolva és bekötve, majd futtasd le:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Ha nem inicializált CAN-eszközöket észlelsz, a fenti parancs a következő sorokat fogja jelenteni:

```
Talált canbus_uuid=11aa22bb33cc, Alkalmazás: Klipper
```

Minden eszköz egyedi azonosítóval rendelkezik. A fenti példában `11aa22bb33cc` a mikrokontroller "canbus_uuid" azonosítója.

Vedd figyelembe, hogy a `canbus_query.py` eszköz csak az inicializálatlan eszközöket jelzi. Ha a Klipper (vagy egy hasonló eszköz) konfigurálja az eszközt, akkor az már nem jelenik meg a listában.

## A Klipper beállítása

Frissítsd a Klipper [mcu konfigurációt](Config_Reference.md#mcu), hogy a CAN-buszon keresztül kommunikáljon az eszközzel - például:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB és CAN-busz közötti híd üzemmód

Néhány mikrovezérlő támogatja az "USB to CAN bus bridge" üzemmód kiválasztását a Klipper "make menuconfig" alatt. Ez az üzemmód lehetővé teszi, hogy egy mikrokontrollert "USB to CAN busz adapterként" és Klipper csomópontként is használhassunk.

Amikor a Klipper ezt az üzemmódot használja, a mikrokontroller "USB CAN busz adapterként" jelenik meg Linux alatt. Maga a "Klipper bridge mcu" úgy jelenik meg, mintha ezen a CAN buszon lenne - a `canbus_query.py` segítségével azonosítható, és ugyanúgy kell konfigurálni, mint a többi CAN buszos Klipper csomópontot.

Néhány fontos megjegyzés ennek az üzemmódnak a használatához:

* A busszal való kommunikációhoz szükséges a `can0` (vagy hasonló) interfész konfigurálása Linuxban. A Linux CAN-busz sebességét és a CAN-busz bit-időzítési beállításait azonban a Klipper figyelmen kívül hagyja. Jelenleg a CAN-busz frekvenciáját a "make menuconfig" futtatása során kell megadni, és a Linuxban megadott buszsebességet figyelmen kívül hagyjuk.
* Amikor a "bridge mcu" visszaáll, a Linux letiltja a megfelelő "can0" interfészt. A FIRMWARE_RESTART és a RESTART parancsok megfelelő kezelése érdekében ajánlott az `/etc/network/interfaces.d/can0` fájlban az `allow-hotplug` opció használata. Például:

```
allow-hotplug can0
iface can0 can static
         bitrate 1000000
         up ifconfig $IFACE txqueuelen 128
```

* A "bridge mcu" valójában nem a CAN-buszon van. A híd mcu-nak küldött és onnan érkező üzeneteket a CAN-buszon lévő más adapterek nem látják.

   * A rendelkezésre álló sávszélességet mind a "híd mcu", mind a CAN-buszon lévő összes eszköz számára a CAN-busz frekvenciája korlátozza. Ennek eredményeképpen az "USB és CAN-busz közötti híd üzemmód" használatakor ajánlott 1000000-es CAN-busz frekvenciát használni.Még 1000000-es CAN-busz frekvencia esetén sem biztos, hogy elegendő sávszélesség áll rendelkezésre a `SHAPER_CALIBRATE` teszt futtatásához, ha mind az XY-léptetők, mind a gyorsulásmérő egyetlen "USB és CAN-busz" interfészen keresztül kommunikálnak.
* Az USB-CAN hídlap nem jelenik meg USB soros eszközként, nem jelenik meg az `ls /dev/serial/by-id` futtatásakor, és nem konfigurálható a Klipper printer.cfg fájljában a `serial:` paraméterrel. A hídlap "USB CAN adapter"-ként jelenik meg, és a printer.cfg fájlban [CAN node-ként](#configuring-klipper) van konfigurálva .

## Tippek a hibaelhárításhoz

Lásd a [CAN-busz hibaelhárítás](CANBUS_Troubleshooting.md) dokumentumot.
