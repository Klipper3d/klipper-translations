# CAN-bus

Dit document beschrijft Klipper's CAN-bus ondersteuning.

## Apparaat

Klipper ondersteunt momenteel CAN op stm32, SAME5x en rp2040 chips. De microcontroller-chip moet zich daarbij op een bord bevinden met CAN-zendontvanger.

Om te compileren voor CAN, draai `make menuconfig` en selecteer "CAN bus" als communicatie-interface. Compileer tenslotte de microcontroller-code en flash dit op het betreffende bord.

## Host

In order to use a CAN bus, it is necessary to have a host adapter. It is recommended to use a "USB to CAN adapter". There are many different USB to CAN adapters available from different manufacturers. When choosing one, we recommend verifying that the firmware can be updated on it. (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.) Look for adapters that can run Klipper directly (in its "USB to CAN bridge mode") or that run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

Het is ook cruciaal om de host OS te configureren om de adapter te gebruiken. Dit wordt normaal gesproken gedaan door een nieuw bestand aan te maken met de naam `/etc/network/interfaces.d/can0` en de volgende inhoud:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```

## Afsluitweerstanden

Een CAN-bus moet twee 120 Ohm weerstanden hebben tussen de CAN-H en CAN-L draden. Bij voorkeur een weerstand aan beide einden van de bus.

Note that some devices have a builtin 120 ohm resistor that can not be easily removed. Some devices do not include a resistor at all. Other devices have a mechanism to select the resistor (typically by connecting a "pin jumper"). Be sure to check the schematics of all devices on the CAN bus to verify that there are two and only two 120 Ohm resistors on the bus.

Om de weerstanden te testen kun je de stroom van de printer halen en een multimeter gebruiken om de weerstand tussen CAN-H en CAN-L te meten - het zou ~60 Ohm moeten zijn op een correct aangesloten CAN-bus.

## Zoeken naar de canbus_uuid voor nieuwe microcontrollers

Elke microcontroller op de CAN-bus heeft een uniek ID toegewezen, gebaseerd op de fabrieksinstelling, gecodeerd in elke microcontroller. Zorg ervoor dat de hardware correct is aangesloten en aanstaat om de ID te achterhalen. Draai dan:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

If uninitialized CAN devices are detected the above command will report lines like the following:

```
Gevonden: canbus_uuid=11aa22bb33cc, applicatie: Klipper
```

Each device will have a unique identifier. In the above example, `11aa22bb33cc` is the micro-controller's "canbus_uuid".

Note that the `canbus_query.py` tool will only report uninitialized devices - if Klipper (or a similar tool) configures the device then it will no longer appear in the list.

## Configureer Klipper

Update the Klipper [mcu configuration](Config_Reference.md#mcu) to use the CAN bus to communicate with the device - for example:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB naar CAN-bus bridge-modus

Some micro-controllers support selecting "USB to CAN bus bridge" mode during Klipper's "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if it was on this CAN bus - it can be identified via `canbus_query.py` and it must be configured like other CAN bus Klipper nodes.

Enkel belangrijke opmerkingen voor gebruik in deze modus:

* Het is noodzakelijk om `can0` (of een vergelijkbare) interface in Linux te configureren om te communiceren met de bus. Linux CAN-bus snelheid en CAN-bus bit-timing-opties worden genegeerd door Klipper. Momenteel wordt de CAN-bus-frequentie ingesteld in "make menuconfig" en de bus-snelheid ingesteld in Linux wordt genegeerd.
* Whenever the "bridge mcu" is reset, Linux will disable the corresponding `can0` interface. To ensure proper handling of FIRMWARE_RESTART and RESTART commands, it is recommended to use `allow-hotplug` in the `/etc/network/interfaces.d/can0` file. For example:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```

* The "bridge mcu" is not actually on the CAN bus. Messages to and from the bridge mcu will not be seen by other adapters that may be on the CAN bus.
* The available bandwidth to both the "bridge mcu" itself and all devices on the CAN bus is effectively limited by the CAN bus frequency. As a result, it is recommended to use a CAN bus frequency of 1000000 when using "USB to CAN bus bridge mode".
* It is only valid to use USB to CAN bridge mode if there is a functioning CAN bus with at least one other node available (in addition to the bridge node itself). Use a standard USB configuration if the goal is to communicate only with the single USB device. Using USB to CAN bridge mode without a fully functioning CAN bus (including terminating resistors and an additional node) may result in sporadic errors even when communicating with the bridge node.
* A USB to CAN bridge board will not appear as a USB serial device, it will not show up when running `ls /dev/serial/by-id`, and it can not be configured in Klipper's printer.cfg file with a `serial:` parameter. The bridge board appears as a "USB CAN adapter" and it is configured in the printer.cfg as a [CAN node](#configuring-klipper).

## Tips for troubleshooting

See the [CAN bus troubleshooting](CANBUS_Troubleshooting.md) document.
