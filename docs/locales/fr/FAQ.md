# Foire aux questions

1. [Comment puis-je faire un don?](#how-can-i-donate-to-the-project)
1. [Comment calculer le paramètre rotation_distance?](#how-do-i-calculate-the-rotation_distance-config-parameter)
1. [Où est mon port série?](#wheres-my-serial-port)
1. [Quand le microcontrôleur redémarre le port du périphérique change pour /dev/ttyUSB1](#when-the-micro-controller-restarts-the-device-changes-to-devttyusb1)
1. [La commande "make flash" ne fonctionne pas](#the-make-flash-command-doesnt-work)
1. [Comment changer le baud rate (taux bit/s) du port série?](#how-do-i-change-the-serial-baud-rate)
1. [Puis-je faire fonctionner Klipper sur quelque chose d'autre qu'un Raspberry Pi 3?](#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)
1. [Can I run multiple instances of Klipper on the same host machine?](#can-i-run-multiple-instances-of-klipper-on-the-same-host-machine)
1. [Suis-je obligé d'utiliser OctoPrint?](#do-i-have-to-use-octoprint)
1. [Pourquoi ne puis-je pas commander un déplacement avant de prendre l'origine?](#why-cant-i-move-the-stepper-before-homing-the-printer)
1. [Pourquoi le paramètre position_endstop Z est-il défini à 0.5 dans la configuration par défaut?](#why-is-the-z-position_endstop-set-to-05-in-the-default-configs)
1. [J'ai converti ma configuration à partir de Marlin et les axes X/Y fonctionnent correctement mais j'ai un bruit strident lors de la prise d'origine de l'axe Z](#i-converted-my-config-from-marlin-and-the-xy-axes-work-fine-but-i-just-get-a-screeching-noise-when-homing-the-z-axis)
1. [Mes pilotes de moteur TMC s'arrêtent en plein milieu d'une impression](#my-tmc-motor-driver-turns-off-in-the-middle-of-a-print)
1. [J'ai des erreurs aléatoires "Lost communication with MCU" (communication perdue avec le microcontrôleur)] (#i-keep-getting-random-lost-communication-with-mcu-errors)
1. [Mon Raspberry Pi redémarre pendant les impressions](#my-raspberry-pi-keeps-rebooting-during-prints)
1. [Lorsque je définis « restart_method=command » mon microcontrôleur AVR bloque pendant le redémarrage](#when-i-set-restart_methodcommand-my-avr-device-just-hangs-on-a-restart)
1. [Est-ce que les éléments chauffants restent allumés si le Raspberry Pi plante?](#will-the-heaters-be-left-on-if-the-raspberry-pi-crashes)
1. [Comment puis-je convertir des noms broches de Marlin à Klipper?](#how-do-i-convert-a-marlin-pin-number-to-a-klipper-pin-name)
1. [Dois-je connecter mon appareil à un type spécifique de broche de microcontrôleur?](#do-i-have-to-wire-my-device-to-a-specific-type-of-micro-controller-pin)
1. [Comment annuler une commande M109/M190 « attendre la température » ?](#how-do-i-cancel-an-m109m190-wait-for-temperature-request)
1. [Comment savoir si l'imprimante a perdu des pas?](#can-i-find-out-whether-the-printer-has-lost-steps)
1. [Pourquoi Klipper signale-t-il des erreurs? J’ai raté mon impression!](#why-does-klipper-report-errors-i-lost-my-print)
1. [Comment mettre à jour vers la dernière version du logiciel?](#how-do-i-upgrade-to-the-latest-software)
1. [Comment désinstaller klipper?](#how-do-i-uninstall-klipper)

## Comment puis-je faire un don au projet?

Thanks. Kevin has a Patreon page at: <https://www.patreon.com/koconnor>

## Comment calculer le paramètre de configuration rotation_distance?

Voir le [document sur la distance de rotation] (Rotation_Distance.md).

## Où est mon port série?

De manière générale, on exécute la commande `ls /dev/serial/by-id/*` à partir d'un terminal ssh sur la machine hôte pour trouver un port série USB. Cette commande produira sûrement un résultat similaire à celui-ci:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Le nom retourné par la commande ci-dessus est constant et il est possible de l'utiliser dans le fichier de configuration et lors du flashage du microcontrôleur. Par exemple, une commande de flash peur ressembler à:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Et la configuration mise à jour devrait ressembler à:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Veillez à copier-coller le nom retourné par la commande "ls" que vous avez exécutée ci-avant, car le nom sera différent pour chaque imprimante.

Si vous utilisez plusieurs microcontrôleurs et qu'ils n'ont pas d'identifiant unique (fréquent avec les cartes utilisant une puce USB CH340), suivez les instructions ci-dessus en utilisant la commande `ls /dev/serial/by-path/*` à la place.

## Lorsque le microcontrôleur redémarre, le périphérique passe à /dev/ttyUSB1

Suivez les instructions de la section "[Where's my serial port ?](#wheres-my-serial-port)" pour éviter que cela ne se produise.

## La commande "make flash" ne fonctionne pas

Le code tente de flasher le dispositif en utilisant la méthode la plus courante pour chaque plateforme. Malheureusement, il y a beaucoup de variations dans les méthodes de flashage, donc la commande "make flash" peut ne pas fonctionner sur toutes les cartes.

Si vous rencontrez une erreur intermittente ou si votre configuration est standard, vérifiez que Klipper est arrêté pendant le flashage (sudo service klipper stop), assurez-vous qu'OctoPrint n'essaye pas de se connecter directement à l'appareil (ouvrez l'onglet Connexion de la page web et cliquez sur Déconnecter si le port série de la carte est sélectionné), et assurez-vous que FLASH_DEVICE est correctement défini pour votre carte (voir la [question ci-dessus](#wheres-my-serial-port)).

Toutefois si "make flash" ne fonctionne pas pour votre carte, vous devrez flasher manuellement. Vérifiez s'il existe un fichier de configuration dans le [répertoire config](../config) avec des instructions spécifiques pour flasher la carte. Vérifiez également la documentation du fabricant de la carte pour voir si elle décrit comment la flasher. Enfin, il peut être possible de flasher manuellement la carte en utilisant des outils tels que "avrdude" ou "bossac" - voir le [document sur les booloaders](Bootloaders.md) pour plus d'informations.

## Comment changer le baud rate (taux bit/s) du port série?

Le baud rate (taux bit/s) recommandé pour Klipper est de 250000. Ce baud rate fonctionne bien sur toutes les cartes microcontrôleurs que Klipper prend en charge. Si vous avez trouvé un guide en ligne recommandant un baud rate différent, ignorez cette partie du guide et continuez avec la valeur par défaut de 250000.

Si vous voulez quand même changer le baud rate, le nouveau taux devra être configurée dans le microcontrôleur (pendant **make menuconfig**) et ce code mis à jour devra être compilé et flashé dans le microcontrôleur. Le fichier printer.cfg de Klipper devra également être mis à jour pour correspondre à ce baud rate (voir le document de [référence des configurations](Config_Reference.md#mcu) pour plus de détails). Par exemple :

```
[mcu]
baud: 250000
```

Le baud rate (taux bit/s) indiqué sur la page Web d'OctoPrint n'a aucun impact sur la vitesse de transmission du microcontrôleur interne de Klipper. Réglez toujours le taux de bit/s d'OctoPrint sur 250000 lorsque vous utilisez Klipper.

Le baud rate utilisé avec Klipper n'est pas liée au baud rate du bootloader du microcontrôleur. Voir le [document sur les bootloaders](Bootloaders.md) pour plus d'informations sur les bootloaders.

## Puis-je faire fonctionner Klipper sur quelque chose d'autre qu'un Raspberry Pi 3?

Le matériel recommandé est un Raspberry Pi 2, Raspberry Pi 3 ou Raspberry Pi 4.

Klipper fonctionne sur un Raspberry Pi 1 et sur le Raspberry Pi Zero, mais ces cartes n'ont pas assez de puissance de traitement pour faire fonctionner OctoPrint correctement. Il est fréquent que l'impression se fasse par à-coup avec ces machines plus lentes lorsqu'on imprime directement depuis OctoPrint. (L'imprimante peut chercher à imprimer plus rapidement que la vitesse à laquelle OctoPrint peut envoyer les commandes de mouvement.) Si vous souhaitez quand même utiliser une de ces cartes plus lentes, pensez à utiliser la fonctionnalité "virtual_sdcard" lors de l'impression (voir le document de [référence des configurations](Config_Reference.md#virtual_sdcard) pour plus de détails).

Pour l'utilisation sur le Beaglebone, consultez les [instructions d'installation spécifiques au Beaglebone](beaglebone.md).

Klipper has been run on other machines. The Klipper host software only requires Python running on a Linux (or similar) computer. However, if you wish to run it on a different machine you will need Linux admin knowledge to install the system prerequisites for that particular machine. See the [install-octopi.sh](../scripts/install-octopi.sh) script for further information on the necessary Linux admin steps.

If you are looking to run the Klipper host software on a low-end chip, then be aware that, at a minimum, a machine with "double precision floating point" hardware is required.

If you are looking to run the Klipper host software on a shared general-purpose desktop or server class machine, then note that Klipper has some real-time scheduling requirements. If, during a print, the host computer also performs an intensive general-purpose computing task (such as defragmenting a hard drive, 3d rendering, heavy swapping, etc.), then it may cause Klipper to report print errors.

Note: If you are not using an OctoPi image, be aware that several Linux distributions enable a "ModemManager" (or similar) package that can disrupt serial communication. (Which can cause Klipper to report seemingly random "Lost communication with MCU" errors.) If you install Klipper on one of these distributions you may need to disable that package.

## Can I run multiple instances of Klipper on the same host machine?

It is possible to run multiple instances of the Klipper host software, but doing so requires Linux admin knowledge. The Klipper installation scripts ultimately cause the following Unix command to be run:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

One can run multiple instances of the above command as long as each instance has its own printer config file, its own log file, and its own pseudo-tty. For example:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

If you choose to do this, you will need to implement the necessary start, stop, and installation scripts (if any). The [install-octopi.sh](../scripts/install-octopi.sh) script and the [klipper-start.sh](../scripts/klipper-start.sh) script may be useful as examples.

## Suis-je obligé d'utiliser Octoprint?

Le logiciel Klipper n'est pas dépendant d'OctoPrint. Il est possible d'utiliser un autre logiciel pour envoyer des commandes à Klipper, mais cela nécessite des connaissances en administration Linux.

Klipper creates a "virtual serial port" via the "/tmp/printer" file, and it emulates a classic 3d-printer serial interface via that file. In general, alternative software may work with Klipper as long as it can be configured to use "/tmp/printer" for the printer serial port.

## Pourquoi ne puis-je pas commander un déplacement avant de prendre l'origine?

Le code fait cela pour réduire le risque de déplacer accidentellement la tête dans le lit ou dans un mur. Une fois que la prise d'origine est effectuée, le logiciel vérifie que chaque mouvement se situe dans les limites de position_min/max définies dans le fichier de configuration. Si les moteurs sont désactivés (via une commande M84 ou M18), les moteurs devront reprendre l'origine avant tout mouvement.

Si vous souhaitez déplacer la tête après avoir annulé une impression via OctoPrint, pensez à modifier la séquence d'annulation d'OctoPrint pour qu'elle le fasse pour vous. Depuis un navigateur web, elle est configurée dans OctoPrint sous : Paramètres->Scripts GCODE

Si vous souhaitez déplacer la tête après la fin d'une impression, pensez à ajouter le mouvement souhaité à la section "G-Code personnalisé" de votre slicer.

If the printer requires some additional movement as part of the homing process itself (or fundamentally does not have a homing process) then consider using a safe_z_home or homing_override section in the config file. If you need to move a stepper for diagnostic or debugging purposes then consider adding a force_move section to the config file. See [config reference](Config_Reference.md#customized_homing) for further details on these options.

## Pourquoi le paramètre position_endstop Z est-il défini à 0.5 dans la configuration par défaut?

For cartesian style printers the Z position_endstop specifies how far the nozzle is from the bed when the endstop triggers. If possible, it is recommended to use a Z-max endstop and home away from the bed (as this reduces the potential for bed collisions). However, if one must home towards the bed then it is recommended to position the endstop so it triggers when the nozzle is still a small distance away from the bed. This way, when homing the axis, it will stop before the nozzle touches the bed. See the [bed level document](Bed_Level.md) for more information.

## I converted my config from Marlin and the X/Y axes work fine, but I just get a screeching noise when homing the Z axis

Short answer: First, make sure you have verified the stepper configuration as described in the [config check document](Config_checks.md). If the problem persists, try reducing the max_z_velocity setting in the printer config.

Long answer: In practice Marlin can typically only step at a rate of around 10000 steps per second. If it is requested to move at a speed that would require a higher step rate then Marlin will generally just step as fast as it can. Klipper is able to achieve much higher step rates, but the stepper motor may not have sufficient torque to move at a higher speed. So, for a Z axis with a high gearing ratio or high microsteps setting the actual obtainable max_z_velocity may be smaller than what is configured in Marlin.

## Mes pilotes de moteur TMC s'arrêtent en plein milieu d'une impression

Si vous utilisez le pilote TMC2208 (ou TMC2224) en "mode autonome", assurez-vous d'utiliser la [dernière version de Klipper](#how-do-i-upgrade-to-the-latest-software). Une solution de contournement pour un problème avec les pilotes TMC2208 "stealthchop" a été ajoutée à Klipper à la mi-mars 2020.

## J'ai des erreurs aléatoires "Lost communication with MCU" (communication perdue avec le microcontrôleur)

Ce problème est généralement causé par des erreurs matérielles sur la connexion USB entre la machine hôte et le microcontrôleur. Les choses à rechercher :

- Utilisez un câble USB de bonne qualité entre la machine hôte et le microcontrôleur. Assurez-vous que les fiches sont bien fixées.
- Si vous utilisez un Raspberry Pi, utilisez une [alimentation de bonne qualité] (https://www.raspberrypi.org/documentation/hardware/raspberrypi/power/README.md) pour le Raspberry Pi et utilisez un [câble USB de bonne qualité] (https://www.raspberrypi.org/forums/viewtopic.php?p=589877#p589877) pour connecter cette alimentation au Pi. Si OctoPrint vous avertit d'une sous-tension, cela est lié à l'alimentation électrique et doit être corrigé.
- Assurez-vous que l'alimentation électrique de l'imprimante n'est pas surchargée. (Les fluctuations d'alimentation de la puce USB du microcontrôleur peuvent entraîner une réinitialisation de cette puce).
- Verify stepper, heater, and other printer wires are not crimped or frayed. (Printer movement may place stress on a faulty wire causing it to lose contact, briefly short, or generate excessive noise.)
- There have been reports of high USB noise when both the printer's power supply and the host's 5V power supply are mixed. (If you find that the micro-controller powers on when either the printer's power supply is on or the USB cable is plugged in, then it indicates the 5V power supplies are being mixed.) It may help to configure the micro-controller to use power from only one source. (Alternatively, if the micro-controller board can not configure its power source, one may modify a USB cable so that it does not carry 5V power between the host and micro-controller.)

## Mon Raspberry Pi redémarre pendant les impressions

Cela est très probablement dû à des fluctuations de tension. Suivez les mêmes étapes de dépannage que pour une erreur [« Communication perdue avec le MCU »](#i-keep-getting-random-lost-communication-with-mcu-errors).

## Lorsque je définis « restart_method=command » mon microcontrôleur AVR bloque pendant le redémarrage

Certaines anciennes versions du bootloader AVR ont un bogue connu dans la gestion des événements de chien de garde. Cela se manifeste typiquement lorsque le paramètre restart_method est défini sur "command" dans le fichier printer.cfg. Lorsque le bogue se produit, le dispositif AVR ne répond pas jusqu'à ce que l'alimentation de la carte soit coupée puis remise (les DEL d'alimentation ou d'état peuvent également clignoter de manière répétée jusqu'à ce que l'alimentation soit retirée).

La solution est d'utiliser un restart_method autre que "command" ou de flasher un bootloader récent sur le dispositif AVR. Le flashage d'un nouveau bootloader est une étape particulière qui nécessite généralement un programmateur externe - voir [Bootloaders](Bootloaders.md) pour plus de détails.

## Est-ce que les éléments chauffants restent allumés si le Raspberry Pi plante?

Le logiciel a été conçu pour éviter cela. Une fois que l'hôte a activé un élément chauffant, le logiciel hôte doit confirmer cette activation toutes les 5 secondes. Si le microcontrôleur ne reçoit pas de confirmation toutes les 5 secondes, il passe dans un status "arrêté" conçu pour éteindre tous les éléments chauffants et les moteurs pas à pas.

Voir la commande "config_digital_out" dans le documentation des [commandes MCU](MCU_Commands.md) pour plus de détails.

En outre, le logiciel du microcontrôleur est configuré avec une plage de température minimale et maximale pour chaque élément chauffant au démarrage (voir les paramètres min_temp et max_temp dans le document de [références des configurations](Config_Reference.md#extruder) pour plus de détails). Si le microcontrôleur détecte que la température est en dehors de cette plage, il passe également au status "arrêté".

Séparément, le logiciel hôte implémente également un code pour vérifier que les éléments chauffants et les capteurs de température fonctionnent correctement. Voir le document de [référence des configurations](Config_Reference.md#verify_heater) pour plus de détails.

## Comment puis-je convertir des noms broches de Marlin à Klipper?

Réponse courte : un mappage est disponible dans le fichier [sample-aliases.cfg](../config/sample-aliases.cfg). Utilisez ce fichier comme guide pour trouver les noms des broches du microcontrôleur. (Il est également possible de copier la section de configuration [board_pins](Config_Reference.md#board_pins) correspondante dans votre fichier de configuration et d'utiliser les alias dans votre configuration, mais il est préférable de traduire et d'utiliser les noms réels des broches du microcontrôleur). Notez que le fichier sample-aliases.cfg utilise des noms de broches qui commencent par le préfixe "ar" au lieu de "D" (par exemple, la broche Arduino `D23` est l'alias Klipper `ar23`) et le préfixe "analog" au lieu de "A" (par exemple, la broche Arduino `A14` est l'alias Klipper `analog14`).

Réponse longue : Klipper utilise les noms de broches standard définis par le microcontrôleur. Sur les puces Atmega, ces broches matérielles ont des noms tels que `PA4`, `PC7`, ou `PD2`.

Il y a longtemps, le projet Arduino a décidé d'éviter d'utiliser les noms standards du matériel en faveur de leurs propres noms de broches basés sur des nombres incrémentés - ces noms Arduino ressemblent généralement à `D23` ou `A14`. Il s'agit d'un choix malheureux qui peut prêter à confusion. En particulier parce que les numéros de broches Arduino ne correspondent pas systématiquement aux mêmes noms matériels. Par exemple, `D21` correspond à `PD0` sur certaines cartes Arduino et à `PC7` sur d'autres.

Pour éviter cette confusion, le code source de Klipper utilise les noms de broches standard définis par le microcontrôleur.

## Dois-je connecter mon appareil à un type spécifique de broche de microcontrôleur?

Cela dépend du type d'appareil et du type de broche:

Broches ADC (ou broches analogiques) : pour les thermistances et autres capteurs "analogiques", l'élément doit être câblé à une broche "analogique" ou "ADC" du microcontrôleur. Si vous configurez Klipper pour utiliser une broche qui n'est pas capable de fonctionner en analogique, Klipper signalera une erreur "Not a valid ADC pin".

Broches PWM (ou broches de timer) : Klipper n'utilise pas de PWM matériel par défaut pour aucun élément. Donc on peut câbler des éléments chauffants, des ventilateurs et des dispositifs similaires à n'importe quelle broche d'E/S d'usage général. Cependant, les ventilateurs et les éléments paramétrés en output_pin peuvent être éventuellement configurés pour utiliser `hardware_pwm : True`, auquel cas le micro-contrôleur doit supporter le PWM matériel sur la broche (sinon, Klipper signalera une erreur "Not a valid PWM pin").

Broches IRQ (ou broches d'interruption) : Klipper n'utilise pas d'interruptions matérielles sur les broches d'E/S, il n'est donc jamais nécessaire de connecter un périphérique à l'une de ces broches du microcontrôleur.

Broches SPI : Lors de l'utilisation du SPI matériel, il est nécessaire de connecter l’élément aux broches SPI du micro-contrôleur. Toutefois, la plupart des éléments peuvent être configurés pour utiliser le "SPI logiciel", auquel cas n'importe quelle broche d'E/S d'usage général peut être utilisée.

Broches I2C : lors de l'utilisation d'I2C, il est nécessaire de câbler les broches aux broches compatibles I2C du microcontrôleur.

D’autres éléments peuvent être câblés à n’importe quelle broche d’E/S à usage général. Par exemple, les steppers, les éléments chauffants, les ventilateurs, les sondes Z, les servos, les LED, les écrans LCD hd44780 /st7920 courants, le câble de communication UART des pilotes Trinamic peut être raccordé à n’importe quelle broche d'E/S.

## Comment annuler une commande M109/M190 « attendre la température » ?

Allez dans l'onglet terminal d'OctoPrint et envoyez une commande M112 dans la console. La commande M112 fera entrer Klipper dans un état "d'arrêt" et déconnectera OctoPrint de Klipper. Dans le bloc de connexion d'OctoPrint, cliquez sur "Connecter" pour que OctoPrint se reconnecte. Revenez à l'onglet du terminal et lancez une commande FIRMWARE_RESTART pour effacer le status en erreur de Klipper. Après avoir effectué cette séquence, la demande de chauffage précédente sera annulée et une nouvelle impression pourra être lancée.

## Comment savoir si l'imprimante a perdu des pas?

D'une certaine manière, oui. Effectuez la prise d'origine (homing), lancez la commande `GET_POSITION`, démarrez votre impression, refaite la prise d'origine et lancez à nouveau la commande `GET_POSITION`. Comparez ensuite les valeurs de la ligne `mcu :`.

Cela peut être utile pour régler des paramètres tels que les courants, les accélérations et les vitesses des moteurs pas à pas sans avoir besoin d'imprimer quelque chose et de gaspiller du filament : il suffit d'exécuter quelques mouvements à grande vitesse entre des commandes `GET_POSITION`.

Notez que les interrupteurs de fin de course eux-mêmes ont tendance à se déclencher à des positions légèrement différentes, de sorte qu'une différence de quelques micro-pas est probablement causé par l'imprécision de la fin de course. Un moteur pas à pas ne peut perdre des pas que par incréments de 4 pas complets. (Ainsi, si l'on utilise 16 micropas, un pas réellement perdu par le moteur se traduirait par une différence multiple de 64 micropas avec le compteur de pas "mcu :")

## Pourquoi Klipper signale-t-il des erreurs? J’ai raté mon impression!

Réponse courte : Nous voulons savoir si nos imprimantes rencontre un problème afin qu'il puisse être résolu et que nous puissions obtenir des impressions de grande qualité. Nous ne voulons surtout pas que nos imprimantes produisent sans le signaler, des impressions de mauvaise qualité.

Réponse longue : Klipper a été conçu pour contourner automatiquement de nombreux problèmes passagers. Par exemple, il détecte automatiquement les erreurs de communication et retransmet les données ; il planifie les actions à l'avance et met en mémoire tampon les commandes à plusieurs niveaux pour permettre une synchronisation précise, même en cas d'interférences intermittentes. Toutefois, si le logiciel détecte une erreur dont il ne peut corriger, s'il reçoit l'ordre d'effectuer une action non valide ou s'il constate qu'il est désespérément incapable d'exécuter la tâche qui lui est demandée, Klipper signalera une erreur. Dans ces situations, le risque est grand de produire une impression de mauvaise qualité (ou pire). Nous espérons que le fait d'alerter l'utilisateur lui permettra de résoudre le problème sous-jacent et d'améliorer la qualité globale de ses impressions.

Il y a quelques questions connexes: Pourquoi Klipper ne met-il pas plutôt l'impression en pause? Ne signale-t-il pas plutôt un avertissement? Ne vérifie-t-il pas les erreurs avant l'impression? N'ignore-t-il pas les erreurs dans les commandes saisies par l'utilisateur? etc. Actuellement, Klipper lit les commandes en utilisant le protocole G-Code, et malheureusement le protocole de commande G-Code n'est pas assez flexible pour rendre ces alternatives praticables aujourd'hui. Il y a un intérêt certain à améliorer l'expérience utilisateur pour la gestion de ces évènements anormaux mais cela nécessite un travail notable sur l'infrastructure (incluant de détourner le G-Code).

## Comment mettre à jour vers la dernière version du logiciel?

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

Cependant, il arrive souvent que seul le logiciel hôte change. Dans ce cas, on peut mettre à jour et redémarrer uniquement le logiciel hôte avec :

```
cd ~/klipper
git pull
sudo service klipper restart
```

Si, après avoir utilisé ce raccourci, le logiciel vous avertit qu'il faut reflasher le microcontrôleur ou qu'une autre erreur inhabituelle se produit, suivez les étapes complètes de mise à jour décrites ci-dessus.

Si des erreurs persistent, vérifiez le document [modifications de configuration](Config_Changes.md), car vous devrez peut-être modifier la configuration de l’imprimante.

Notez que les commandes G-Code RESTART et FIRMWARE_RESTART ne rechargent pas le logiciel - les commandes "sudo service klipper restart" et "make flash" ci-dessus sont nécessaires pour que les modifications du logiciel prennent effet.

## Comment désinstaller Klipper?

Pour ce qui est du firmware, il n'y a rien de spécial à faire. Suivez simplement les instructions de flashage pour le nouveau firmware.

Du côté de Raspberry Pi, un script de désinstallation est disponible dans [scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh). Par exemple :

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
