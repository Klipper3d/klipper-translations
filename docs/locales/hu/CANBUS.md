# CANBUS

Ez a dokumentum a Klipper CAN busz támogatását írja le.

## Eszköz Hardver

A Klipper jelenleg csak az STM32 chipeken támogatja a CAN-t. Ezenkívül a mikrokontroller chipnek támogatnia kell a CAN-t, és olyan lapon kell lennie, amely rendelkezik CAN adó-vevővel.

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

Ne feledje, hogy a "Raspberry Pi CAN sapka" is megköveteli a [config.txt módosítását](https://www.waveshare.com/wiki/RS485_CAN_HAT).

## Az ellenállások megszüntetése

A CAN-buszon két 120 ohmos ellenállásnak kell lennie a CANH és CANL vezetékek között. Ideális esetben egy-egy ellenállás a busz mindkét végén található.

Vegye figyelembe, hogy egyes eszközök beépített 120 ohmos ellenállással rendelkeznek (például a "Waveshare Raspberry Pi CAN sapka" egy beforrasztott ellenállással rendelkezik, amelyet nem lehet könnyen eltávolítani). Egyes eszközök egyáltalán nem tartalmaznak ellenállást. Más eszközök rendelkeznek egy mechanizmussal az ellenállás kiválasztására (általában egy "pin jumper" csatlakoztatásával). Mindenképpen ellenőrizze a CAN-buszon lévő összes eszköz kapcsolási rajzát, hogy a buszon két és csak két 120 Ohm-os ellenállás van-e.

Az ellenállások értékének teszteléséhez a nyomtatót áramtalaníthatja, és egy multi-méterrel ellenőrizheti a CANH és CANL vezetékek közötti ellenállást. Egy helyesen bekötött CAN-buszon ~60 ohmot kell mérnie.

## A canbus_uuid keresése új mikrovezérlőkhöz

A CAN-buszon lévő minden mikrovezérlőhöz egyedi azonosítót rendelnek a gyári chipazonosító alapján, amely minden mikrovezérlőbe kódolva van. Az egyes mikrokontrollerek eszközazonosítójának megtalálásához győződjön meg arról, hogy a hardver megfelelően van bekapcsolva és bekötve, majd futtassa le:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Ha nem inicializált CAN-eszközöket észlel, a fenti parancs a következő sorokat fogja jelenteni:

```
Talált canbus_uuid=11aa22bb33cc
```

Minden eszköz egyedi azonosítóval rendelkezik. A fenti példában `11aa22bb33cc` a mikrokontroller "canbus_uuid" azonosítója.

Vegye figyelembe, hogy a `canbus_query.py` eszköz csak az inicializálatlan eszközöket jelzi. Ha a Klipper (vagy egy hasonló eszköz) konfigurálja az eszközt, akkor az már nem jelenik meg a listában.

## A Klipper beállítása

Frissítse a Klipper [mcu konfigurációt](Config_Reference.md#mcu), hogy a CAN-buszon keresztül kommunikáljon az eszközzel - például:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB to CAN bus bridge mode

Some micro-controllers support selecting "USB to CAN bus bridge" mode during "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if was on this CAN bus - it can be identified via `canbus_query.py` and configured like other CAN bus Klipper nodes. It will appear alongside other devices that are actually on the CAN bus.

Some important notes when using this mode:

* The "bridge mcu" is not actually on the CAN bus. Messages to and from it do not consume bandwidth on the CAN bus. The mcu can not be seen by other adapters that may be on the CAN bus.
* It is necessary to configure the `can0` (or similar) interface in Linux in order to communicate with the bus. However, Linux CAN bus speed and CAN bus bit-timing options are ignored by Klipper. Currently, the CAN bus frequency is specified during "make menuconfig" and the bus speed specified in Linux is ignored.
* Whenever the "bridge mcu" is reset, Linux will disable the corresponding `can0` interface. Generally, this may require running commands such as "ip up" to restart the interface. Thus, Klipper FIRMWARE_RESTART commands (or regular RESTART after a config change) may require restarting the `can0` interface.
