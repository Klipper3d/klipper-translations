# Dépannage du CANBUS

Ce document fournit des informations sur le dépannage des problèmes de communication lors de l'utilisation de [Bus CAN avec Klipper](CANBUS.md).

## Vérifier le câblage du bus CAN

La première étape pour résoudre les problèmes de communication est de vérifier le câblage du bus CAN.

Be sure there are exactly two 120 Ohm [terminating
resistors](CANBUS.md#terminating-resistors) on the CAN bus. If the resistors are not properly installed then messages may not be able to be sent at all or the connection may have sporadic instability.

Les câbles CANH et CANL doivent être torsadés. Les torsades ne doivent pas être espacées de plus de quelques centimètres. Évitez de torsader les câbles CANH et CANL avec les fils de puissance et assurez-vous que les fils de puissance placés à côté du bus can n'aient pas le même nombre de torsades.

Vérifier que toutes les fiches et sertissages sur le câblage CAN sont entièrement sécurisés. Le mouvement de la tête d'outil d'imprimante peut faire bouger le câblage de bus CAN et provoquer des faux contacts - source d'erreurs de communication aléatoires.

## Vérification de l'augmentation du compteur octets_invalide

Le fichier journal de Klipper affiche une ligne `Stats` une fois par seconde lorsque l'imprimante est active. Ces lignes "Stats" ont un compteur `bytes_invalid` pour chaque microcontrôleur. Ce compteur ne devrait pas augmenter au cours de l'utilisation normale de l'imprimante (il est normal que le compteur soit non nul après un RESTART et ce n'est pas une préoccupation si le compteur augmente une fois par mois). Si ce compteur augmente sur un microcontrôleur de bus CAN pendant un fonctionnement normal (s'il augmente toutes les heures ou plus fréquemment) alors c'est une indication d'un problème grave.

L'augmentation du compteur `bytes_invalid` sur une connexion de bus CAN est un symptôme de messages réémis sur le bus CAN. Il existe deux causes connues de réémission de messages :

1. Les anciennes versions du micrologiciel candlight ont un bug qui peut causer des réémissions de messages. Si vous utilisez un adaptateur USB CAN qui exécute ce micrologiciel, assurez-vous de mettre à jour le dernier micrologiciel si vous remarquez une incrémentation anormale du compteur `bytes_invalid`.
1. Certains noyaux Linux destinés à des périphériques embarqués sont connus pour réémettre les messages de bus CAN. Il peut être nécessaire d'utiliser un autre noyau Linux ou d'utiliser du matériel qui prend en charge les noyaux Linux courants qui ne présentent pas ce problème.

La réorganisation des messages est un problème grave qui doit être résolu. Cela entraînera un comportement instable et peut conduire à des erreurs déroutantes à n'importe quelle partie d'une impression.

## Obtenir les journaux 'candump'

Les messages de bus CAN envoyés au microcontrôleur sont gérés par le noyau Linux. Il est possible de capturer ces messages à des fins de débogage. Le journal de ces messages peut être utile lors des diagnostics.

L'outil Linux [can-utils](https ://github.com/linux-can/can-utils) fournit le logiciel de capture. Il peut être installé en exécutant :

```
sudo apt-get update && sudo apt-get install can-utils
```

Une fois installé, on peut obtenir une capture de tous les messages de bus CAN sur une interface avec la commande suivante :

```
candump -tz -Ddex can0,#FFFFFFFF > mycanlog
```

On peut lire le fichier journal résultant (`mycanlog` dans l'exemple ci-dessus) pour voir chaque message de bus CAN brut qui a été envoyé et reçu par Klipper. Comprendre le contenu de ces messages nécessite une connaissance de bas niveau de Klipper : [Protocole CANBUS](CANBUS_protocol.md) et [Commandes MCU](MCU_Commands.md).

### Analyser les messages Klipper dans un journal candump

Il est possible d'utiliser l'outil `parsecandump.py` pour analyser les messages microcontrôleur Klipper de bas niveau contenus dans un journal candump. L'utilisation de cet outil nécessite la connaissance de Klipper [MCU commands](MCU_Commands.md). Par exemple :

```
./scripts/parsecandump.py mycanlog 108 ./out/klipper.dict
```

This tool produces output similar to the [parsedump
tool](Debugging.md#translating-gcode-files-to-micro-controller-commands). See the documentation for that tool for information on generating the Klipper micro-controller data dictionary.

In the above example, `108` is the [CAN bus
id](CANBUS_protocol.md#micro-controller-id-assignment). It is a hexadecimal number. The id `108` is assigned by Klipper to the first micro-controller. If the CAN bus has multiple micro-controllers on it, then the second micro-controller would be `10a`, the third would be `10c`, and so on.

Le journal candump doit être généré avec les arguments de ligne de commande `-tz -Ddex` (par exemple : `candump -tz -Ddex can0,#FFFFFF`)) Afin de pouvoir être utilisé avec l'outil `parsecandump.py`.

## Utiliser un analyseur logique sur le câblage canbus

Le logiciel [Sigrok Pulseview](https://sigrok.org/wiki/PulseView) associé à un analyseur logique à bas coût [logic analysisr](https://en.wikipedia.org/wiki/Logic_analyzer) peut être utile pour le diagnostic de signal de bus CAN. C'est un sujet avancé qui n'intéressera probablement que les experts.

On peut trouver des « analyseurs logiques USB » pour moins de 15 $ (prix américain de 2023). Ces appareils sont souvent nommés « Saleae logic clone » ou « analyseur logique USB 24MHz 8 canaux ».

![pulseview-canbus](img/pulseview-canbus.png)

L'image ci-dessus a été prise en utilisant Pulseview avec un analyseur logique "Saleae clone". Le logiciel Sigrok et Pulseview ont été installés sur une machine de bureau (il faudra aussi installe le microligiciel "fx2lafw" si il est fourni séparément). La broche CH0 sur l'analyseur logique doit être connectée à la ligne CAN Rx, la broche CH1 à la ligne CAN Tx, GND doit être connecté avec GND. Pulseview doit être configuré pour n'afficher que les lignes D0 et D1 (icône rouge 'probe' au centre de la barre d'outils). Le nombre d'échantillons a été fixé à 5 millions (barre d'outils) et le taux d'échantillonnage à 24Mhz (barre d'outils). Le décodeur CAN a été ajouté (icône bulle jaune et verte sir la barre d'outils en haut à droite). Le canal D0 étiqueté comme RX et défini pour être déclenché sur un front descendant (cliquez sur l'étiquette D0 noire à gauche). Le canal D1 a été étiqueté comme TX (cliquez sur l'étiquette D1 brune à gauche). Le décodeur CAN a été configuré à une vitesse de 1Mbit (cliquez sur l'étiquette CAN verte à gauche). Le décodeur CAN a été déplacé en haut de l'écran (cliquez et faites glisser l'étiquette CAN verte). Enfin, la capture a été commencée (cliquez sur "Run" en haut à gauche) et un paquet a été transmis sur le bus CAN (`cansend cans0 123#121212121212`).

L'analyseur logique fournit un outil indépendant pour capturer les paquets et vérifier la chronologie.
