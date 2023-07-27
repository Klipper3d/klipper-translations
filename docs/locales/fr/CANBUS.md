# CANBUS

Ce document décrit la prise en charge du CAN bus de Klipper.

## Matériel de l'appareil

Klipper currently supports CAN on stm32, SAME5x, and rp2040 chips. In addition, the micro-controller chip must be on a board that has a CAN transceiver.

Pour compiler le firmware de votre matériel canbus, exécutez `make menuconfig` et sélectionnez « CAN bus » comme interface de communication. Enfin, compilez le code du microcontrôleur et flashez-le sur la carte cible.

## Matériel de l'hôte

In order to use a CAN bus, it is necessary to have a host adapter. It is recommended to use a "USB to CAN adapter". There are many different USB to CAN adapters available from different manufacturers. When choosing one, we recommend verifying that the firmware can be updated on it. (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.) Look for adapters that can run Klipper directly (in its "USB to CAN bridge mode") or that run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

Il faut aussi configurer le système d'exploitation hôte pour utiliser l'adaptateur. Cela se fait généralement en créant un nouveau fichier nommé `/etc/network/interfaces.d/can0` avec le contenu suivant :

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

## Résistances de terminaison

Un bus CAN doit avoir deux résistances de 120 ohms entre les fils CANH et CANL. Idéalement, une résistance située à chaque extrémité du bus.

Note that some devices have a builtin 120 ohm resistor that can not be easily removed. Some devices do not include a resistor at all. Other devices have a mechanism to select the resistor (typically by connecting a "pin jumper"). Be sure to check the schematics of all devices on the CAN bus to verify that there are two and only two 120 Ohm resistors on the bus.

Pour tester que les résistances sont correctes, on peut couper l'alimentation de l'imprimante et utiliser un multimètre pour vérifier la résistance entre les fils CANH et CANL - la résistance doit être d'environ 60 ohms sur un bus CAN correctement câblé.

## Trouver le canbus_uuid pour les nouveaux microcontrôleurs

Chaque microcontrôleur sur le bus CAN se voit attribuer un identifiant unique basé sur un identifiant de puce codé en usine dans chaque microcontrôleur. Pour trouver les identifiant canbus des microcontrôleurs, assurez-vous que le matériel est correctement alimenté et câblé, puis exécutez :

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Si des périphériques CAN non initialisés sont détectés, la commande ci-dessus remontera des lignes comme celles-ci :

```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

Chaque appareil aura un identifiant unique. Dans l'exemple ci-dessus, `11aa22bb33cc` est le "canbus_uuid" du microcontrôleur.

Notez que l'outil `canbus_query.py` ne signalera que les appareils non initialisés - si Klipper (ou un outil similaire) configure l'appareil, il n'apparaîtra plus dans la liste.

## Configuration de Klipper

Mettez à jour la configuration de Klipper [configuration mcu](Config_Reference.md#mcu) afin d'utiliser le bus CAN pour communiquer avec l'appareil - par exemple :

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## Mode pont USB vers bus CAN

Some micro-controllers support selecting "USB to CAN bus bridge" mode during Klipper's "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if it was on this CAN bus - it can be identified via `canbus_query.py` and it must be configured like other CAN bus Klipper nodes.

Quelques remarques importantes lors de l'utilisation de ce mode :

* Il est nécessaire de configurer l'interface `can0` (ou similaire) sous Linux afin de communiquer avec le bus. Cependant, la vitesse du bus CAN Linux et les options de synchronisation des bits du bus CAN sont ignorées par Klipper. Actuellement, la fréquence du bus CAN est spécifiée lors de "make menuconfig" et la vitesse du bus spécifiée dans Linux est ignorée.
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
