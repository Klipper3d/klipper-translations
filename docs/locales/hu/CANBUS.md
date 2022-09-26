# CANBUS

Ez a dokumentum a Klipper CAN busz támogatását írja le.

## Eszköz Hardver

A Klipper jelenleg támogatja a CAN-t az STM32 és RP2040 chipeken. Ezenkívül a mikrokontroller chipnek olyan lapkán kell lennie, amely rendelkezik CAN csatlakozóval.

A CAN-hez való fordításhoz futtassa a `make menuconfig` parancsot, és válassza a "CAN busz" kommunikációs interfészt. Végül fordítsa le a mikrokontroller kódját, és égesse a céllapra.

## Gazdagép Hardver

A CAN-busz használatához szükség van egy host-adapterre. Jelenleg két elterjedt lehetőség van:

1. Használjon egy [Waveshare Raspberry Pi CAN sapkát](https://www.waveshare.com/rs485-can-hat.htm) vagy annak számos klónja közül egyet.
1. Használjon USB CAN-adaptert (például <https://hacker-gadgets.com/product/cantact-usb-can-adapter/>). Számos különböző USB-CAN adapter áll rendelkezésre - az adapter kiválasztásakor javasoljuk, hogy ellenőrizze, hogy képes-e a [candlelight firmware](https://github.com/candle-usb/candleLight_fw) futtatására. (Sajnos azt tapasztaltuk, hogy néhány USB-adapter hibás firmware-t futtat, és le van zárva, ezért vásárlás előtt ellenőrizze.)

Az adapter használatához a gazdagép operációs rendszert is konfigurálni kell. Ez általában úgy történik, hogy létrehozunk egy új `/etc/network/interfaces.d/can0` nevű fájlt a következő tartalommal:

```
auto can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```

Ne feledd, hogy a "Raspberry Pi CAN sapka" is megköveteli a [config.txt módosítását](https://www.waveshare.com/wiki/RS485_CAN_HAT).

## Az ellenállások megszüntetése

A CAN-buszon két 120 ohmos ellenállásnak kell lennie a CANH és CANL vezetékek között. Ideális esetben egy-egy ellenállás a busz mindkét végén található.

Vedd figyelembe, hogy egyes eszközök beépített 120 ohmos ellenállással rendelkeznek (például a "Waveshare Raspberry Pi CAN sapka" egy beforrasztott ellenállással rendelkezik, amelyet nem lehet könnyen eltávolítani). Egyes eszközök egyáltalán nem tartalmaznak ellenállást. Más eszközök rendelkeznek egy mechanizmussal az ellenállás kiválasztására (általában egy "pin jumper" csatlakoztatásával). Mindenképpen ellenőrizze a CAN-buszon lévő összes eszköz kapcsolási rajzát, hogy a buszon két és csak két 120 Ohm-os ellenállás van-e.

Az ellenállások értékének teszteléséhez a nyomtatót áramtalaníthatja, és egy multi-méterrel ellenőrizheti a CANH és CANL vezetékek közötti ellenállást. Egy helyesen bekötött CAN-buszon ~60 ohmot kell mérnie.

## A canbus_uuid keresése új mikrovezérlőkhöz

A CAN-buszon lévő minden mikrovezérlőhöz egyedi azonosítót rendelnek a gyári chipazonosító alapján, amely minden mikrovezérlőbe kódolva van. Az egyes mikrokontrollerek eszközazonosítójának megtalálásához győződjön meg arról, hogy a hardver megfelelően van bekapcsolva és bekötve, majd futtassa le:

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

Frissítse a Klipper [mcu konfigurációt](Config_Reference.md#mcu), hogy a CAN-buszon keresztül kommunikáljon az eszközzel - például:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB és CAN-busz közötti híd üzemmód

Egyes mikrovezérlők támogatják az "USB to CAN bus bridge" üzemmód kiválasztását a "make menuconfig" során. Ez az üzemmód lehetővé teheti, hogy egy mikrokontrollert "USB CAN busz adapterként" és Klipper csomópontként is használjunk.

Amikor a Klipper ezt az üzemmódot használja, a mikrokontroller "USB CAN busz adapterként" jelenik meg Linux alatt. Maga a "Klipper bridge mcu" úgy jelenik meg, mintha ezen a CAN buszon lenne. A `canbus_query.py` segítségével azonosítható és konfigurálható, mint a többi CAN buszos Klipper csomópont. A többi, ténylegesen a CAN-buszon lévő eszköz mellett fog megjelenni.

Néhány fontos megjegyzés ennek az üzemmódnak a használatához:

* A "bridge mcu" valójában nem a CAN-buszon van. A hozzá érkező és tőle érkező üzenetek nem fogyasztanak sávszélességet a CAN-buszon. Az MCU-t nem láthatják más adapterek, amelyek esetleg a CAN-buszon vannak.
* A busszal való kommunikációhoz szükséges a `can0` (vagy hasonló) interfész konfigurálása Linuxban. A Linux CAN-busz sebességét és a CAN-busz bit-időzítési beállításait azonban a Klipper figyelmen kívül hagyja. Jelenleg a CAN-busz frekvenciáját a "make menuconfig" futtatása során kell megadni, és a Linuxban megadott buszsebességet figyelmen kívül hagyjuk.
* Amikor a "bridge mcu" visszaáll, a Linux letiltja a megfelelő `can0` interfészt. A FIRMWARE_RESTART és a RESTART parancsok megfelelő kezelése érdekében ajánlott az `/etc/network/interfaces.d/can0` fájlban az `auto` helyett az `allow-hotplug` parancsot használni. Például:

```
allow-hotplug can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```
