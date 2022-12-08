# CANBUS

Ce document décrit la prise en charge du CAN bus de Klipper.

## Matériel de l'appareil

Klipper ne prend actuellement en charge CAN que sur les puces stm32, same5x et rp2040. De plus, la puce du microcontrôleur doit se trouver sur une carte dotée d'un émetteur-récepteur CAN.

Pour compiler le firmware de votre matériel canbus, exécutez `make menuconfig` et sélectionnez « CAN bus » comme interface de communication. Enfin, compilez le code du microcontrôleur et flashez-le sur la carte cible.

## Matériel de l'hôte

Pour utiliser un bus CAN, il est nécessaire d'avoir un adaptateur hôte. Il existe actuellement deux solutions :

1. Utilisez une [Carte fille Waveshare Raspberry Pi CAN](https://www.waveshare.com/rs485-can-hat.htm) ou l'un de ses nombreux clones.
1. Utilisez un adaptateur USB CAN (par exemple <https://hacker-gadgets.com/product/cantact-usb-can-adapter/>). Il existe de nombreux adaptateurs USB vers CAN différents - lorsque vous en choisissez un, nous vous recommandons de vérifier qu'il peut exécuter le [micrologiciel Candlelight](https://github.com/candle-usb/candleLight_fw). (Malheureusement, nous avons constaté que certains adaptateurs USB exécutent un micrologiciel défectueux et sont bloqués, vérifiez avant d'acheter.)

Il faut aussi configurer le système d'exploitation hôte pour utiliser l'adaptateur. Cela se fait généralement en créant un nouveau fichier nommé `/etc/network/interfaces.d/can0` avec le contenu suivant :

```
auto can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```

Notez que la "Carte Fille Raspberry Pi CAN hat" nécessite également [modifications de config.txt](https://www.waveshare.com/wiki/RS485_CAN_HAT).

## Résistances de terminaison

Un bus CAN doit avoir deux résistances de 120 ohms entre les fils CANH et CANL. Idéalement, une résistance située à chaque extrémité du bus.

Notez que certains appareils ont une résistance intégrée de 120 ohms (par exemple, le "Waveshare Raspberry Pi CAN hat" a une résistance soudée qui ne peut pas être facilement retirée). Certains appareils n'incluent pas de résistance du tout. D'autres appareils ont un mécanisme pour sélectionner la résistance (généralement en connectant un ou plusieurs "cavalier"). Vérifiez les schémas de tous les appareils sur le bus CAN pour vérifier qu'il y a deux et seulement deux résistances de 120 ohms sur le bus.

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

Certains microcontrôleurs prennent en charge la sélection du mode "pont USB vers bus CAN" pendant "make menuconfig". Ce mode peut permettre d'utiliser un microcontrôleur à la fois comme "adaptateur de bus USB vers CAN" et comme nœud Klipper.

Lorsque Klipper utilise ce mode, le microcontrôleur apparaît comme un "adaptateur de bus USB CAN" sous Linux. Le "Klipper bridge mcu" lui-même apparaîtra comme s'il se trouvait sur ce bus CAN - il peut être identifié via `canbus_query.py` et configuré comme les autres nœuds Klipper du bus CAN. Il apparaîtra à côté d'autres appareils qui sont en fait sur le bus CAN.

Quelques remarques importantes lors de l'utilisation de ce mode :

* Le "bridge mcu" n'est pas réellement sur le bus CAN. Les messages entrants et sortants ne consomment pas de bande passante sur le bus CAN. Le mcu ne peut pas être vu par les autres adaptateurs qui sont sur le bus CAN.
* Il est nécessaire de configurer l'interface `can0` (ou similaire) sous Linux afin de communiquer avec le bus. Cependant, la vitesse du bus CAN Linux et les options de synchronisation des bits du bus CAN sont ignorées par Klipper. Actuellement, la fréquence du bus CAN est spécifiée lors de "make menuconfig" et la vitesse du bus spécifiée dans Linux est ignorée.
* Chaque fois que le "bridge mcu" est réinitialisé, Linux désactive l'interface `can0` correspondante. Pour assurer une bonne gestion des commandes FIRMWARE_RESTART et RESTART, il est recommandé de remplacer `auto` par `allow-hotplug` dans le fichier `/etc/network/interfaces.d/can0` dossier. Par exemple :

```
allow-hotplug can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```
