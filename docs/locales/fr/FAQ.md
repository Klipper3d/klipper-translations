# Foire Aux Questions

## Comment puis-je faire un don au projet ?

Merci de votre soutien. Voir la page [Sponsors](Sponsors.md) pour plus d'informations.

## Comment calculer le paramètre de configuration rotation_distance ?

Voir le [document sur la distance de rotation](Rotation_Distance.md).

## Où est mon port série ?

De manière générale, on exécute la commande `ls /dev/serial/by-id/*` à partir d'un terminal ssh sur la machine hôte pour trouver un port série USB. Cette commande produira sûrement un résultat similaire à celui-ci :

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Le nom retourné par la commande ci-dessus est constant, il est donc possible de l'utiliser dans le fichier de configuration et lors du flashage du microcontrôleur. Par exemple, une commande de flash peur ressembler à :

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

et la configuration mise à jour devrait ressembler à :

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Veillez à copier-coller le nom retourné par la commande "ls" que vous avez exécutée ci-avant, car le nom sera différent pour chaque imprimante.

Si vous utilisez plusieurs microcontrôleurs et qu'ils n'ont pas d'identifiant unique (fréquent avec les cartes utilisant une puce USB CH340), suivez les instructions ci-dessus en utilisant la commande `ls /dev/serial/by-path/*` à la place.

## Lorsque le microcontrôleur redémarre, le périphérique passe à /dev/ttyUSB1

Suivez les instructions de la section "[Où est mon port série ?](#wheres-my-serial-port)" pour éviter que cela ne se produise.

## La commande "make flash" ne fonctionne pas

Le code tente de flasher le dispositif en utilisant la méthode la plus courante pour chaque plateforme. Malheureusement, il y a beaucoup de variations dans les méthodes de flashage, donc la commande "make flash" peut ne pas fonctionner avec toutes les cartes.

Si vous rencontrez une erreur intermittente ou si votre configuration est standard, vérifiez que Klipper est arrêté pendant le flashage (sudo service klipper stop), assurez-vous qu'OctoPrint n'essaye pas de se connecter directement à l'appareil (ouvrez l'onglet Connexion de la page web et cliquez sur Déconnecter si le port série de la carte est sélectionné), et assurez-vous que FLASH_DEVICE est correctement défini pour votre carte (voir la [question ci-dessus](#wheres-my-serial-port)).

Toutefois si "make flash" ne fonctionne pas pour votre carte, vous devrez flasher manuellement. Vérifiez s'il existe un fichier de configuration dans le [répertoire config](../config) avec des instructions spécifiques pour flasher la carte. Vérifiez également la documentation du fabricant de la carte pour voir si elle décrit comment la flasher. Enfin, il peut être possible de flasher manuellement la carte en utilisant des outils tels que "avrdude" ou "bossac" - voir le [document sur les booloaders](Bootloaders.md) pour plus d'informations.

## Comment changer la vitesse de communication(baud rate) du port série ?

Le baud rate (taux bit/s) recommandé pour Klipper est de 250000. Ce baud rate fonctionne bien sur toutes les cartes microcontrôleurs que Klipper prend en charge. Si vous avez trouvé un guide en ligne recommandant un baud rate différent, ignorez cette partie du guide et continuez avec la valeur par défaut de 250000.

Si vous voulez quand même changer le baud rate, le nouveau taux devra être configurée dans le microcontrôleur (pendant **make menuconfig**) et ce code mis à jour devra être compilé et flashé dans le microcontrôleur. Le fichier printer.cfg de Klipper devra également être mis à jour pour correspondre à ce baud rate (voir le document de [référence des configurations](Config_Reference.md#mcu) pour plus de détails). Par exemple :

```
[mcu]
baud: 250000
```

Le baud rate (taux bit/s) indiqué sur la page Web d'OctoPrint n'a aucun impact sur la vitesse de transmission du microcontrôleur interne de Klipper. Réglez toujours le taux de bit/s d'OctoPrint sur 250000 lorsque vous utilisez Klipper.

Le baud rate utilisé avec Klipper n'est pas liée au baud rate du bootloader du microcontrôleur. Voir le [document sur les bootloaders](Bootloaders.md) pour plus d'informations sur les bootloaders.

## Puis-je faire fonctionner Klipper sur autre chose qu'un Raspberry Pi 3 ?

Le matériel recommandé est un Raspberry Pi 2, Raspberry Pi 3 ou Raspberry Pi 4.

Klipper fonctionne sur un Raspberry Pi 1 et sur le Raspberry Pi Zero, mais ces cartes n'ont pas assez de puissance de traitement pour faire fonctionner OctoPrint correctement. Il est fréquent que l'impression se fasse par à-coup avec ces machines plus lentes lorsqu'on imprime directement depuis OctoPrint. (L'imprimante peut chercher à imprimer plus rapidement que la vitesse à laquelle OctoPrint peut envoyer les commandes de mouvement.) Si vous souhaitez quand même utiliser une de ces cartes plus lentes, pensez à utiliser la fonctionnalité "virtual_sdcard" lors de l'impression (voir le document de [référence des configurations](Config_Reference.md#virtual_sdcard) pour plus de détails).

Pour l'exécution sur le Beaglebone, voir les [instructions d'installation spécifiques au Beaglebone](Beaglebone.md).

Klipper a été exécuté sur d'autres machines. Le logiciel hôte de Klipper ne nécessite que l'exécution de Python sur un ordinateur Linux (ou similaire). Cependant, si vous souhaitez l'exécuter sur une autre machine, vous aurez besoin de connaissances d'administrateur Linux pour installer les prérequis du système pour cette machine particulière. Consultez le script [install-octopi.sh](../scripts/install-octopi.sh) pour plus d'informations sur les étapes nécessaires à l'administration de Linux.

Si vous souhaitez exécuter le logiciel hôte Klipper sur une puce bas de gamme, sachez qu'il faut au minimum une machine dotée d'un matériel à "double précision en virgule flottante".

Si vous souhaitez exécuter le logiciel hôte Klipper sur un ordinateur de bureau ou un serveur polyvalent partagé, notez que Klipper a des exigences en matière de programmation en temps réel. Si, au cours d'une impression, l'ordinateur hôte exécute également une tâche informatique intensive (comme la défragmentation d'un disque dur, un rendu 3D, une forte utilisation du fichier d'échange, etc.), Klipper pourrait signaler des erreurs d'impression.

Note : Si vous n'utilisez pas une image OctoPi, sachez que de nombreuses distributions Linux activent un paquet "ModemManager" (ou similaire) pouvant perturber la communication série. (Ce qui peut amener Klipper à rapporter des erreurs apparemment aléatoires "Lost communication with MCU"). Si vous installez Klipper sur une de ces distributions, vous devrez peut-être désactiver ce paquet.

## Puis-je exécuter plusieurs instances de Klipper sur la même machine hôte ?

Il est possible d'exécuter plusieurs instances du logiciel hôte Klipper, mais cela nécessite des connaissances en administration Linux. Les scripts d'installation de Klipper entraînent finalement l'exécution de la commande Unix suivante :

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

On peut exécuter plusieurs instances de la commande ci-dessus à condition que chaque instance ait son propre fichier de configuration d'imprimante, son propre fichier journal et son propre pseudo-tty. Par exemple :

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

Si vous choisissez de le faire, vous devrez implémenter les scripts de démarrage, d'arrêt et d'installation nécessaires (le cas échéant). Le script [install-octopi.sh](../scripts/install-octopi.sh) et le script [klipper-start.sh](../scripts/klipper-start.sh) peuvent être utiles comme exemples.

## Suis-je obligé d'utiliser Octoprint ?

Le logiciel Klipper n'est pas dépendant d'OctoPrint. Il est possible d'utiliser un autre logiciel pour envoyer des commandes à Klipper, mais cela nécessite des connaissances en administration Linux.

Klipper crée un "port série virtuel" via le fichier "/tmp/printer" qui émule une interface série classique d'imprimante 3d via ce fichier. En général, les logiciels alternatifs peuvent fonctionner avec Klipper tant qu'ils peuvent être configurés pour utiliser "/tmp/printer" pour le port série de l'imprimante.

## Pourquoi ne puis-je pas lancer un déplacement avant de prendre l'origine ?

Le code fait cela pour réduire le risque de déplacer accidentellement la tête dans le lit ou dans un mur. Une fois que la prise d'origine est effectuée, le logiciel vérifie que chaque mouvement se situe dans les limites de position_min/max définies dans le fichier de configuration. Si les moteurs sont désactivés (via une commande M84 ou M18), les moteurs devront reprendre l'origine avant tout mouvement.

Si vous souhaitez déplacer la tête après avoir annulé une impression via OctoPrint, pensez à modifier la séquence d'annulation d'OctoPrint pour qu'elle le fasse pour vous. Depuis un navigateur web, elle est configurée dans OctoPrint sous : Paramètres->Scripts GCODE

Si vous souhaitez déplacer la tête après la fin d'une impression, pensez à ajouter le mouvement souhaité à la section "G-Code personnalisé" de votre slicer.

Si l'imprimante nécessite un mouvement supplémentaire dans le cadre du processus de mise à l'origine (ou si elle n'a pas de processus de mise à l'origine), envisagez d'utiliser une section safe_z_home ou homing_override dans le fichier de configuration. Si vous devez déplacer un moteur à des fins de diagnostic ou de débogage, pensez à ajouter une section force_move dans le fichier de configuration. Voir [référence de configuration](Config_Reference.md#customized_homing) pour plus de détails sur ces options.

## Pourquoi le paramètre position_endstop de l'axe Z est-il défini à 0.5 dans les configurations par défaut ?

Pour les imprimantes de style cartésien, la position Z_endstop indique la distance entre la buse et le lit au moment du déclenchement de la fin de course. Si possible, il est recommandé d'utiliser une butée de fin de course Z-max et de s'éloigner du lit (car cela réduit le risque de collision avec le lit). Cependant, si l'on doit se rapprocher du lit, il est recommandé de positionner la butée de manière à ce qu'elle se déclenche lorsque la buse est encore à une petite distance du lit. De cette façon, lorsque l'axe se dirige vers le lit, il s'arrête avant que la buse ne touche le lit. Voir le document [niveau du lit](Bed_Level.md) pour plus d'informations.

## J'ai converti ma configuration depuis Marlin et les axes X/Y fonctionnent bien, mais j'obtiens un bruit strident lors de l'orientation de l'axe Z

Réponse courte : Tout d'abord, assurez-vous d'avoir vérifié la configuration du moteur comme décrit dans le [document de vérification de la configuration](Config_checks.md). Si le problème persiste, essayez de réduire le paramètre max_z_velocity dans la configuration de l'imprimante.

Réponse longue : En pratique, Marlin ne peut se déplacer qu'à une vitesse d'environ 10000 pas par seconde. Si on lui demande de se déplacer à une vitesse nécessitant un taux de pas plus élevé, Marlin se contentera généralement de faire des pas aussi rapides qu'il le peut. Klipper est capable d'atteindre des taux de pas beaucoup plus élevés, mais le moteur pas à pas peut ne pas avoir de couple suffisant pour se déplacer à une vitesse plus élevée. Ainsi, pour un axe Z avec un rapport d'engrenage élevé ou un réglage de micropas élevé, la vitesse max_z_obtenue peut être inférieure à ce qui est configuré dans Marlin.

## Mes pilotes de moteur TMC s'arrêtent en plein milieu d'une impression

Si vous utilisez le pilote TMC2208 (ou TMC2224) en "mode autonome", assurez-vous d'utiliser la [dernière version de Klipper](#how-do-i-upgrade-to-the-latest-software). Une solution de contournement pour un problème avec les pilotes TMC2208 "stealthchop" a été ajoutée à Klipper à la mi-mars 2020.

## J'ai des erreurs aléatoires "Lost communication with MCU" (communication perdue avec le microcontrôleur)

Ce problème est généralement causé par des erreurs matérielles sur la connexion USB entre la machine hôte et le microcontrôleur. Les choses à rechercher :

- Utilisez un câble USB de qualité entre la machine hôte et le microcontrôleur. Assurez-vous que les fiches sont bien fixées.
- Si vous utilisez un Raspberry Pi, utilisez une [alimentation de bonne qualité](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply) pour le Raspberry Pi et utilisez un [câble USB de bonne qualité](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877) pour connecter cette alimentation au Pi. Si OctoPrint vous avertit que vous êtes sous tension, cela est lié à l'alimentation électrique et doit être réparé.
- Assurez-vous que l'alimentation électrique de l'imprimante n'est pas surchargée. (Les fluctuations d'alimentation de la puce USB du microcontrôleur peuvent entraîner une réinitialisation de cette puce.)
- Vérifiez que les fils de l'imprimante (pastille, élément chauffant et autres) sont bien sertis et pas effilochés. (Le mouvement de l'imprimante peut exercer une contrainte sur un câblage défectueux entraînant une perte de contact, un court-circuit bref ou la production d'un bruit excessif.)
- Des signalements ont fait état d'un bruit USB élevé lorsque l'alimentation de l'imprimante et l'alimentation 5V de l'hôte sont mélangées. (Si vous constatez que le microcontrôleur s'allume lorsque l'alimentation de l'imprimante est sous tension ou que le câble USB est branché, cela indique que les alimentations 5V sont mélangées). Il peut être utile de configurer le micro-contrôleur pour qu'il utilise l'alimentation d'une seule source. (Alternativement, si la carte du micro-contrôleur ne peut pas configurer sa source d'alimentation, on peut modifier un câble USB pour qu'il ne transporte pas de tension de 5V entre l'hôte et le micro-contrôleur.)

## Mon Raspberry Pi redémarre pendant les impressions

Cela est très probablement dû à des fluctuations de tension. Suivez les mêmes étapes de dépannage que pour une erreur [« Communication perdue avec le MCU »](#i-keep-getting-random-lost-communication-with-mcu-errors).

## Lorsque j'ai défini `restart_method=command`, mon appareil AVR se bloque lors d'un redémarrage

Certaines anciennes versions du bootloader AVR ont un bogue connu dans la gestion des événements de chien de garde. Cela se manifeste typiquement lorsque le paramètre restart_method est défini sur "command" dans le fichier printer.cfg. Lorsque le bogue se produit, le dispositif AVR ne répond pas jusqu'à ce que l'alimentation de la carte soit coupée puis remise (les DEL d'alimentation ou d'état peuvent également clignoter de manière répétée jusqu'à ce que l'alimentation soit retirée).

La solution est d'utiliser un restart_method autre que "command" ou de flasher un bootloader récent sur le dispositif AVR. Le flashage d'un nouveau bootloader est une étape particulière qui nécessite généralement un programmateur externe - voir [Bootloaders](Bootloaders.md) pour plus de détails.

## Est-ce que les éléments chauffants restent allumés si le Raspberry Pi plante ?

Le logiciel a été conçu pour éviter cela. Une fois que l'hôte a activé un élément chauffant, le logiciel hôte doit confirmer cette activation toutes les 5 secondes. Si le microcontrôleur ne reçoit pas de confirmation toutes les 5 secondes, il passe dans un status "arrêté" conçu pour éteindre tous les éléments chauffants et les moteurs pas à pas.

Voir la commande "config_digital_out" dans le documentation des [commandes MCU](MCU_Commands.md) pour plus de détails.

En outre, le logiciel du microcontrôleur est configuré avec une plage de température minimale et maximale pour chaque élément chauffant au démarrage (voir les paramètres min_temp et max_temp dans le document de [références des configurations](Config_Reference.md#extruder) pour plus de détails). Si le microcontrôleur détecte que la température est en dehors de cette plage, il passe également au status "arrêté".

Séparément, le logiciel hôte implémente également un code pour vérifier que les éléments chauffants et les capteurs de température fonctionnent correctement. Voir le document de [référence des configurations](Config_Reference.md#verify_heater) pour plus de détails.

## Comment puis-je convertir les noms de broches de Marlin à Klipper ?

Réponse courte : un mappage est disponible dans le fichier [sample-aliases.cfg](../config/sample-aliases.cfg). Utilisez ce fichier comme guide pour trouver les noms des broches du microcontrôleur. (Il est également possible de copier la section de configuration [board_pins](Config_Reference.md#board_pins) correspondante dans votre fichier de configuration et d'utiliser les alias dans votre configuration, mais il est préférable de traduire et d'utiliser les noms réels des broches du microcontrôleur). Notez que le fichier sample-aliases.cfg utilise des noms de broches qui commencent par le préfixe "ar" au lieu de "D" (par exemple, la broche Arduino `D23` est l'alias Klipper `ar23`) et le préfixe "analog" au lieu de "A" (par exemple, la broche Arduino `A14` est l'alias Klipper `analog14`).

Réponse longue : Klipper utilise les noms de broches standard définis par le microcontrôleur. Sur les puces Atmega, ces broches matérielles ont des noms tels que `PA4`, `PC7`, ou `PD2`.

Il y a longtemps, le projet Arduino a décidé d'éviter d'utiliser les noms standards du matériel en faveur de leurs propres noms de broches basés sur des nombres incrémentés - ces noms Arduino ressemblent généralement à `D23` ou `A14`. Il s'agit d'un choix malheureux qui peut prêter à confusion. En particulier parce que les numéros de broches Arduino ne correspondent pas systématiquement aux mêmes noms matériels. Par exemple, `D21` correspond à `PD0` sur certaines cartes Arduino et à `PC7` sur d'autres.

Pour éviter cette confusion, le code source de Klipper utilise les noms de broches standard définis par le microcontrôleur.

## Dois-je connecter mon appareil à un type spécifique de broche de microcontrôleur ?

Cela dépend du type d'appareil et du type de broche :

Broches ADC (ou broches analogiques) : pour les thermistances et autres capteurs "analogiques", l'élément doit être câblé à une broche "analogique" ou "ADC" du microcontrôleur. Si vous configurez Klipper pour utiliser une broche qui n'est pas capable de fonctionner en analogique, Klipper signalera une erreur "Not a valid ADC pin".

Broches PWM (ou broches de timer) : Klipper n'utilise pas de PWM matériel par défaut pour aucun élément. Donc on peut câbler des éléments chauffants, des ventilateurs et des dispositifs similaires à n'importe quelle broche d'E/S d'usage général. Cependant, les ventilateurs et les éléments paramétrés en output_pin peuvent être éventuellement configurés pour utiliser `hardware_pwm : True`, auquel cas le micro-contrôleur doit supporter le PWM matériel sur la broche (sinon, Klipper signalera une erreur "Not a valid PWM pin").

Broches IRQ (ou broches d'interruption) : Klipper n'utilise pas d'interruptions matérielles sur les broches d'E/S, il n'est donc jamais nécessaire de connecter un périphérique à l'une de ces broches du microcontrôleur.

Broches SPI : Lors de l'utilisation du SPI matériel, il est nécessaire de connecter l’élément aux broches SPI du micro-contrôleur. Toutefois, la plupart des éléments peuvent être configurés pour utiliser le "SPI logiciel", auquel cas n'importe quelle broche d'E/S d'usage général peut être utilisée.

Broches I2C : lors de l'utilisation d'I2C, il est nécessaire de câbler les broches aux broches compatibles I2C du microcontrôleur.

D’autres éléments peuvent être câblés à n’importe quelle broche d’E/S à usage général. Par exemple, les steppers, les éléments chauffants, les ventilateurs, les sondes Z, les servos, les LED, les écrans LCD hd44780 /st7920 courants, le câble de communication UART des pilotes Trinamic peut être raccordé à n’importe quelle broche d'E/S.

## Comment annuler une commande M109/M190 « attendre la température » ?

Allez dans l'onglet terminal d'OctoPrint et envoyez une commande M112 dans la console. La commande M112 fera entrer Klipper dans un état "d'arrêt" et déconnectera OctoPrint de Klipper. Dans le bloc de connexion d'OctoPrint, cliquez sur "Connecter" pour que OctoPrint se reconnecte. Revenez à l'onglet du terminal et lancez une commande FIRMWARE_RESTART pour effacer le status en erreur de Klipper. Après avoir effectué cette séquence, la demande de chauffage précédente sera annulée et une nouvelle impression pourra être lancée.

## Comment savoir si l'imprimante a perdu des pas ?

D'une certaine manière, oui. Effectuez la prise d'origine (homing), lancez la commande `GET_POSITION`, démarrez votre impression, refaite la prise d'origine et lancez à nouveau la commande `GET_POSITION`. Comparez ensuite les valeurs de la ligne `mcu :`.

Cela peut être utile pour régler des paramètres tels que les courants, les accélérations et les vitesses des moteurs pas à pas sans avoir besoin d'imprimer quelque chose et de gaspiller du filament : il suffit d'exécuter quelques mouvements à grande vitesse entre des commandes `GET_POSITION`.

Notez que les interrupteurs de fin de course eux-mêmes ont tendance à se déclencher à des positions légèrement différentes, de sorte qu'une différence de quelques micro-pas est probablement causé par l'imprécision de la fin de course. Un moteur pas à pas ne peut perdre des pas que par incréments de 4 pas complets. (Ainsi, si l'on utilise 16 micropas, un pas réellement perdu par le moteur se traduirait par une différence multiple de 64 micropas avec le compteur de pas "mcu :")

## Pourquoi Klipper signale-t-il des erreurs ? J’ai raté mon impression !

Réponse courte : Nous voulons savoir si nos imprimantes rencontre un problème afin qu'il puisse être résolu et que nous puissions obtenir des impressions de grande qualité. Nous ne voulons surtout pas que nos imprimantes produisent sans le signaler, des impressions de mauvaise qualité.

Réponse longue : Klipper a été conçu pour contourner automatiquement de nombreux problèmes passagers. Par exemple, il détecte automatiquement les erreurs de communication et retransmet les données ; il planifie les actions à l'avance et met en mémoire tampon les commandes à plusieurs niveaux pour permettre une synchronisation précise, même en cas d'interférences intermittentes. Toutefois, si le logiciel détecte une erreur dont il ne peut corriger, s'il reçoit l'ordre d'effectuer une action non valide ou s'il constate qu'il est désespérément incapable d'exécuter la tâche qui lui est demandée, Klipper signalera une erreur. Dans ces situations, le risque est grand de produire une impression de mauvaise qualité (ou pire). Nous espérons que le fait d'alerter l'utilisateur lui permettra de résoudre le problème sous-jacent et d'améliorer la qualité globale de ses impressions.

Il y a quelques questions connexes : Pourquoi Klipper ne met-il pas plutôt l'impression en pause ? Ne signale-t-il pas plutôt un avertissement ? Ne vérifie-t-il pas les erreurs avant l'impression ? N'ignore-t-il pas les erreurs dans les commandes saisies par l'utilisateur ? etc. Actuellement, Klipper lit les commandes en utilisant le protocole G-Code, et malheureusement le protocole de commande G-Code n'est pas assez flexible pour rendre ces alternatives praticables aujourd'hui. Il y a un intérêt certain à améliorer l'expérience utilisateur pour la gestion de ces évènements anormaux mais cela nécessite un travail notable sur l'infrastructure (incluant de détourner le G-Code).

## Comment mettre à jour vers la dernière version du logiciel ?

La première étape de la mise à jour du logiciel consiste à consulter le document le plus récent des [changements de configuration](Config_Changes.md). Il arrive que des modifications soient apportées au logiciel et que les utilisateurs doivent mettre à jour leurs paramètres dans le cadre d'une mise à niveau logicielle. Il est conseillé de consulter ce document avant de procéder à la mise à niveau.

Lorsque vous êtes prêt à mettre à jour, la méthode générale consiste à se connecter au Raspberry Pi et à exécuter :

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

On peut ensuite recompiler et flasher le code du microcontrôleur. Par exemple :

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

Cependant, il arrive parfois que seul le logiciel hôte change. Dans ce cas, on peut mettre à jour et redémarrer uniquement le logiciel hôte avec :

```
cd ~/klipper
git pull
sudo service klipper restart
```

Si, après avoir utilisé ce raccourci, le logiciel vous avertit qu'il faut reflasher le microcontrôleur ou qu'une autre erreur inhabituelle se produit, suivez les étapes complètes de mise à jour décrites ci-dessus.

Si des erreurs persistent, vérifiez le document [modifications de configuration](Config_Changes.md), car vous devrez peut-être modifier la configuration de l’imprimante.

Notez que les commandes G-Code RESTART et FIRMWARE_RESTART ne rechargent pas le logiciel - les commandes "sudo service klipper restart" et "make flash" ci-dessus sont nécessaires pour que les modifications du logiciel prennent effet.

## Comment désinstaller Klipper ?

Pour ce qui est du firmware, il n'y a rien de spécial à faire. Suivez simplement les instructions de flashage du nouveau firmware.

Du côté Raspberry Pi, un script de désinstallation est disponible dans [scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh). Par exemple :

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
