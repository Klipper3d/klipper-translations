# BUS CAN

Ce document décrit la prise en charge du CAN bus de Klipper.

## Matériel de l'appareil

Klipper supporte actuellement CAN sur les puces stm32, SAME5x et rp2040. Le microcontrôleur doit être sur une carte qui possède aussi un transpondeur CAN.

Pour compiler le firmware de votre matériel canbus, exécutez `make menuconfig` et sélectionnez « CAN bus » comme interface de communication. Enfin, compilez le code du microcontrôleur et flashez-le sur la carte cible.

## Matériel de l'hôte

Pour utiliser un bus CAN, il est nécessaire d'avoir un adaptateur hôte. Il est recommandé d'utiliser un adaptateur "USB to CAN". Il existe de nombreux adaptateurs USB différents pour CAN disponibles auprès de différents fabricants. Lors de votre choix, nous vous recommandons de vérifier que le micrologiciel peut être mis à jour. (Malheureusement, nous avons trouvé quelques adaptateurs USB avec un micrologiciel défectueux et non modifiable, donc vérifiez avant l'achat.) Recherchez des adaptateurs qui peuvent exécuter Klipper directement (dans son mode "USB to CAN bridge") ou qui exécutent [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

Il faut aussi configurer le système d'exploitation hôte pour utiliser l'adaptateur. Cela se fait généralement en créant un nouveau fichier nommé `/etc/network/interfaces.d/can0` avec le contenu suivant :

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

## Résistances de terminaison

Un bus CAN doit avoir deux résistances de 120 ohms entre les fils CANH et CANL. Idéalement, une résistance située à chaque extrémité du bus.

Certains appareils ont une résistance intégrée de 120 ohm qui ne peut pas être facilement supprimée, d'autres n'ont pas de résistance et d'autres ont un mécanisme pour sélectionner la résistance (généralement en connectant un "cavalier"). Assurez-vous de vérifier les schémas de tous les appareils du bus CAN pour vérifier qu'il y a deux et seulement deux résistances de 120 Ohm sur le bus .

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

Certains microcontrôleurs prennent en charge la sélection du mode "USB to CAN bus bridge" pendant la phase "make menuconfig" de Klipper". Ce mode peut permettre d'utiliser un microcontrôleur à la fois comme un adaptateur de bus USB vers CAN et comme nœud Klipper (mcu).

Lorsque Klipper utilise ce mode, le microcontrôleur apparaît comme un "USB CAN bus adapter" sous Linux. Le mcu "Klipper apparaîtra comme s'il était sur le bus CAN - il peut être identifié via `canbus_query.py` et il doit être configuré comme les autres noeuds Klipper de bus CAN.

Quelques remarques importantes lors de l'utilisation de ce mode :

* Il est nécessaire de configurer l'interface `can0` (ou similaire) sous Linux afin de communiquer avec le bus. Cependant, la vitesse du bus CAN Linux et les options de synchronisation des bits du bus CAN sont ignorées par Klipper. Actuellement, la fréquence du bus CAN est spécifiée lors de "make menuconfig" et la vitesse du bus spécifiée dans Linux est ignorée.
* Dès que le "bridge mcu" est réinitialisé, Linux désactivera l'interface correspondante `can0`. Pour assurer une bonne manipulation des commandes FIRMWARE_RESTART et RESTART, il est recommandé d'utiliser `allow-hotplug` dans le fichier `/etc/network/interfaces.d/can0`. Par exemple :

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

* Le « pont mcu » n'est pas en fait sur le bus CAN. Les messages entrant et sortant du bridge mcu ne seront pas vus par les autres adaptateurs présents sur le bus CAN.

   * La bande passante disponible pour tous les appareils du bus CAN (et du bridge mcu) est limitée par la fréquence de bus CAN. Par conséquent, il est recommandé d'utiliser une fréquence de bus CAN de 1000000 lors de l'utilisation du mode "USB to CAN bus bridge".Même à une fréquence de bus CAN de 1000000, il peut ne pas y avoir assez de bande passante pour exécuter un test `SHAPER_CALIBRATE` si les deux steppers XY et l'accéléromètre communiquent tous par une seule interface "USB to CAN bus".
* Une carte de pont USB à CAN n'apparaîtra pas en tant que périphérique série USB, elle ne s'affichera pas lors de l'execution de la commande `ls /dev/serial/by-id`, et elle ne peut pas être configurée dans le fichier Klipper avec un paramètre `serial:`. La carte pont apparaît comme un « adaptateur CAN USB » et est configuré dans le printer.cfg en tant que [Nœud CAN](#configuring-klipper).

## Conseils pour le dépannage

Voir le document [Dépannage du Bus CAN](CANBUS_Troubleshooting.md).
