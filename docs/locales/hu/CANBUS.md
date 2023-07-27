# CANBUS

Ez a dokumentum a Klipper CAN busz támogatását írja le.

## Eszköz Hardver

Klipper currently supports CAN on stm32, SAME5x, and rp2040 chips. In addition, the micro-controller chip must be on a board that has a CAN transceiver.

A CAN-hez való fordításhoz futtasd a `make menuconfig` parancsot, és válaszd a "CAN busz" kommunikációs interfészt. Végül fordítsd le a mikrokontroller kódját, és égesd a céllapra.

## Gazdagép Hardver

In order to use a CAN bus, it is necessary to have a host adapter. It is recommended to use a "USB to CAN adapter". There are many different USB to CAN adapters available from different manufacturers. When choosing one, we recommend verifying that the firmware can be updated on it. (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.) Look for adapters that can run Klipper directly (in its "USB to CAN bridge mode") or that run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

Az adapter használatához a gazdagép operációs rendszert is konfigurálni kell. Ez általában úgy történik, hogy létrehozunk egy új `/etc/network/interfaces.d/can0` nevű fájlt a következő tartalommal:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

## Az ellenállások megszüntetése

A CAN-buszon két 120 ohmos ellenállásnak kell lennie a CANH és CANL vezetékek között. Ideális esetben egy-egy ellenállás a busz mindkét végén található.

Note that some devices have a builtin 120 ohm resistor that can not be easily removed. Some devices do not include a resistor at all. Other devices have a mechanism to select the resistor (typically by connecting a "pin jumper"). Be sure to check the schematics of all devices on the CAN bus to verify that there are two and only two 120 Ohm resistors on the bus.

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

Some micro-controllers support selecting "USB to CAN bus bridge" mode during Klipper's "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if it was on this CAN bus - it can be identified via `canbus_query.py` and it must be configured like other CAN bus Klipper nodes.

Néhány fontos megjegyzés ennek az üzemmódnak a használatához:

* A busszal való kommunikációhoz szükséges a `can0` (vagy hasonló) interfész konfigurálása Linuxban. A Linux CAN-busz sebességét és a CAN-busz bit-időzítési beállításait azonban a Klipper figyelmen kívül hagyja. Jelenleg a CAN-busz frekvenciáját a "make menuconfig" futtatása során kell megadni, és a Linuxban megadott buszsebességet figyelmen kívül hagyjuk.
* Whenever the "bridge mcu" is reset, Linux will disable the corresponding `can0` interface. To ensure proper handling of FIRMWARE_RESTART and RESTART commands, it is recommended to use `allow-hotplug` in the `/etc/network/interfaces.d/can0` file. For example:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

* The "bridge mcu" is not actually on the CAN bus. Messages to and from the bridge mcu will not be seen by other adapters that may be on the CAN bus.

   * The available bandwidth to both the "bridge mcu" itself and all devices on the CAN bus is effectively limited by the CAN bus frequency. As a result, it is recommended to use a CAN bus frequency of 1000000 when using "USB to CAN bus bridge mode".Even at a CAN bus frequency of 1000000, there may not be sufficient bandwidth to run a `SHAPER_CALIBRATE` test if both the XY steppers and the accelerometer all communicate via a single "USB to CAN bus" interface.
* A USB to CAN bridge board will not appear as a USB serial device, it will not show up when running `ls /dev/serial/by-id`, and it can not be configured in Klipper's printer.cfg file with a `serial:` parameter. The bridge board appears as a "USB CAN adapter" and it is configured in the printer.cfg as a [CAN node](#configuring-klipper).

## Tips for troubleshooting

See the [CAN bus troubleshooting](CANBUS_Troubleshooting.md) document.
