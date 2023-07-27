# CANBUS

Questo documento descrive il supporto del CAN bus di Klipper.

## Hardware del dispositivo

Klipper currently supports CAN on stm32, SAME5x, and rp2040 chips. In addition, the micro-controller chip must be on a board that has a CAN transceiver.

Per compilare per CAN, eseguire `make menuconfig` e selezionare "CAN bus" come interfaccia di comunicazione. Infine, compila il codice del microcontrollore e flashalo sulla scheda di destinazione.

## Hardware Host

In order to use a CAN bus, it is necessary to have a host adapter. It is recommended to use a "USB to CAN adapter". There are many different USB to CAN adapters available from different manufacturers. When choosing one, we recommend verifying that the firmware can be updated on it. (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.) Look for adapters that can run Klipper directly (in its "USB to CAN bridge mode") or that run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

È inoltre necessario configurare il sistema operativo host per utilizzare l'adattatore. Questo viene in genere fatto creando un nuovo file chiamato `/etc/network/interfaces.d/can0` con il seguente contenuto:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

## Resistori di terminazione

Un bus CAN dovrebbe avere due resistori da 120 ohm tra i cavi CANH e CANL. Idealmente, un resistore situato a ciascuna estremità del bus.

Note that some devices have a builtin 120 ohm resistor that can not be easily removed. Some devices do not include a resistor at all. Other devices have a mechanism to select the resistor (typically by connecting a "pin jumper"). Be sure to check the schematics of all devices on the CAN bus to verify that there are two and only two 120 Ohm resistors on the bus.

Per verificare che i resistori siano corretti, è possibile rimuovere l'alimentazione alla stampante e utilizzare un multimetro per controllare la resistenza tra i cavi CNH e CANL: dovrebbe riportare ~60 ohm su un bus CAN cablato correttamente.

## Trovare canbus_uuid per nuovi microcontrollori

A ogni microcontrollore sul bus CAN viene assegnato un ID univoco basato sull'identificatore del chip di fabbrica codificato in ciascun microcontrollore. Per trovare l'ID di ciascun dispositivo del microcontrollore, assicurati che l'hardware sia alimentato e cablato correttamente, quindi esegui:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Se vengono rilevati dispositivi CAN non inizializzati, il comando precedente riporterà righe come le seguenti:

```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

Ogni dispositivo avrà un identificatore univoco. Nell'esempio sopra, `11aa22bb33cc` è il "canbus_uuid" del microcontrollore.

Nota che lo strumento `canbus_query.py` riporterà solo i dispositivi non inizializzati - se Klipper (o uno strumento simile) configura il dispositivo, non apparirà più nell'elenco.

## Configurare Klipper

Aggiorna Klipper [configurazione mcu](Config_Reference.md#mcu) per utilizzare il bus CAN per comunicare con il dispositivo, ad esempio:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## Modalità bridge da USB a CAN bus

Some micro-controllers support selecting "USB to CAN bus bridge" mode during Klipper's "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if it was on this CAN bus - it can be identified via `canbus_query.py` and it must be configured like other CAN bus Klipper nodes.

Alcune note importanti quando si utilizza questa modalità:

* È necessario configurare l'interfaccia `can0` (o simile) in Linux per comunicare con il bus. Tuttavia, Klipper ignora la velocità del bus CAN di Linux e le opzioni di temporizzazione del bus CAN. Attualmente, la frequenza del bus CAN viene specificata durante "make menuconfig" e la velocità del bus specificata in Linux viene ignorata.
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
