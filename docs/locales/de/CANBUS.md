# CANBUS

Diese Dokumentation beschreibt die Kompatibilität zwischen Klipper und Can bus.

## Geräte-Hardware

Klipper currently supports CAN on stm32, SAME5x, and rp2040 chips. In addition, the micro-controller chip must be on a board that has a CAN transceiver.

Um für CAN zu kompilieren, führen Sie `make menuconfig` aus und wählen Sie "CAN bus" als Kommunikationsschnittstelle. Schließlich kompilieren Sie den Mikrocontroller-Code und flashen ihn auf die Zielplatine.

## Host Hardware

In order to use a CAN bus, it is necessary to have a host adapter. It is recommended to use a "USB to CAN adapter". There are many different USB to CAN adapters available from different manufacturers. When choosing one, we recommend verifying that the firmware can be updated on it. (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.) Look for adapters that can run Klipper directly (in its "USB to CAN bridge mode") or that run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

Es ist auch notwendig, das Host-Betriebssystem für die Verwendung des Adapters zu konfigurieren. Dazu wird normalerweise eine neue Datei mit dem Pfad `/etc/network/interfaces.d/can0` mit folgendem Inhalt erstellt:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

## Endwiderstände

Ein CAN-Bus sollte zwei 120-Ohm-Widerstände zwischen den CANH- und CANL-Leitungen haben. Idealerweise befindet sich jeweils ein Widerstand an jedem Enden des Busses.

Note that some devices have a builtin 120 ohm resistor that can not be easily removed. Some devices do not include a resistor at all. Other devices have a mechanism to select the resistor (typically by connecting a "pin jumper"). Be sure to check the schematics of all devices on the CAN bus to verify that there are two and only two 120 Ohm resistors on the bus.

Um zu prüfen, ob die Widerstände korrekt sind, kann man die Stromversorgung des Druckers unterbrechen und mit einem Multimeter den Widerstand zwischen den CANH- und CANL-Drähten messen - bei einem korrekt verdrahteten CAN-Bus sollte er ~60 Ohm anzeigen.

## Suche nach der canbus_uuid für neue Mikrocontroller

Jedem Mikrocontroller auf dem CAN-Bus wird eine eindeutige Kennung zugewiesen, die auf der werkseitigen Chip-Kennung basiert. Diese ist in jedem Mikrocontroller fest kodiert ist. Um die Geräte-ID jedes Mikrocontrollers zu finden, stellen Sie sicher, dass die Hardware mit Strom versorgt und korrekt verdrahtet ist, und starten Sie dann:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Wenn nicht initialisierte CAN-Geräte erkannt werden, meldet der obige Befehl Zeilen wie folgt:

```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

Jedes Gerät hat eine eindeutige Kennung. Im obigen Beispiel ist `11aa22bb33cc` die "canbus_uuid" des Mikrocontrollers.

Beachten Sie, dass das Werkzeug `canbus_query.py` nur uninitialisierte Geräte meldet - wenn Klipper (oder ein ähnliches Werkzeug) das Gerät konfiguriert, erscheint es nicht mehr in der Liste.

## Klipper einstellen

Aktualisieren Sie die Klipper [mcu configuration](Config_Reference.md#mcu), um den CAN-Bus zur Kommunikation mit dem Gerät zu verwenden - zum Beispiel:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB to CAN bus bridge mode

Some micro-controllers support selecting "USB to CAN bus bridge" mode during Klipper's "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if it was on this CAN bus - it can be identified via `canbus_query.py` and it must be configured like other CAN bus Klipper nodes.

Some important notes when using this mode:

* It is necessary to configure the `can0` (or similar) interface in Linux in order to communicate with the bus. However, Linux CAN bus speed and CAN bus bit-timing options are ignored by Klipper. Currently, the CAN bus frequency is specified during "make menuconfig" and the bus speed specified in Linux is ignored.
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
