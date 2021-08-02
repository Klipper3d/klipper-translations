# Configuration checks

Ce document fournit une liste d'étapes permettant de confirmer les paramètres des broches dans le fichier printer.cfg de Klipper. Il est conseillé d'exécuter ces étapes après avoir suivi les étapes du [document d'installation](Installation.md).

Pendant ce guide, il peut être nécessaire d'apporter des modifications au fichier de configuration de Klipper. Veillez à émettre une commande RESTART après chaque modification du fichier de configuration pour vous assurer que la modification prend effet (tapez "restart" dans l'onglet du terminal Octoprint et cliquez ensuite sur "Send"). C'est aussi une bonne idée d'envoyer une commande STATUS après chaque RESTART pour vérifier que le fichier de configuration a été chargé avec succès.

## Vérifier la température

Commencez par vérifier que les températures sont correctement rapportées. Naviguez vers l'onglet température d'Octoprint.

![temperature-octoprint](img/octoprint-temperature.png)

Vérifiez que la température de la buse et du plateau chauffant (le cas échéant) est présente et n'augmente pas. Si elle augmente, mettez l'imprimante hors tension. Si les températures ne sont pas précises, vérifiez les paramètres "sensor_type" et "sensor_pin" pour la buse et/ou le plateau chauffant.

## Vérifier M112

Naviguez vers l'onglet du terminal Octoprint et lancez une commande M112 dans la boîte du terminal. Cette commande demande à Klipper de se mettre dans un état "d'arrêt". Octoprint se déconnectera de Klipper - naviguez vers la zone de connexion et cliquez sur "Connecter" pour reconnecter Octoprint. Ensuite, naviguez vers l'onglet température d'Octoprint et vérifiez que les températures continuent à se mettre à jour et qu'elles n'augmentent pas. Si les températures augmentent, coupez l'alimentation de l'imprimante.

La commande M112 fait passer Klipper dans un état "d'arrêt". Pour effacer cet état, lancez la commande FIRMWARE_RESTART dans l'onglet du terminal Octoprint.

## Vérifier la cartouche chauffante

Naviguez jusqu'à l'onglet température d'Octoprint et tapez 50 suivi d'une entrée dans la boîte de température "Tool". La température de l'extrudeuse dans le graphique devrait commencer à augmenter (dans les 30 secondes environ). Ensuite, allez dans la boîte déroulante de la température de l'outil et sélectionnez "Off". Après plusieurs minutes, la température devrait commencer à revenir à sa valeur initiale de température ambiante. Si la température n'augmente pas, vérifiez le paramètre "heater_pin" dans la configuration.

Si l'imprimante est équipée d'un plateau chauffant, effectuez à nouveau le test ci-dessus avec le plateau.

## Vérifier l'activation du moteur pas à pas

Vérifiez que tous les axes de l'imprimante peuvent se déplacer librement manuellement (les moteurs pas à pas sont désactivés). Si ce n'est pas le cas, lancez une commande M84 pour désactiver les moteurs. Si l'un des axes ne peut toujours pas se déplacer librement, vérifiez la configuration de la "broche d'activation" du moteur pas à pas pour l'axe en question. Sur la plupart des pilotes de moteurs pas à pas, la broche d'activation du moteur est "active basse" et la broche d'activation doit donc être précédée d'un " !" (par exemple, "enable_pin : !ar38").

## Vérifier les capteurs de fin de course

Déplacez manuellement tous les axes de l'imprimante afin qu'aucun d'entre eux ne soit en contact avec une butée. Envoyez une commande QUERY_ENDSTOPS via l'onglet du terminal Octoprint. L'imprimante devrait répondre avec l'état actuel de toutes les butées configurées et elles devraient toutes rapporter un état "ouvert". Pour chacun des arrêts, réexécutez la commande QUERY_ENDSTOPS en déclenchant manuellement l'arrêt. La commande QUERY_ENDSTOPS doit indiquer que la fin de course est "TRIGGERED".

Si la fin de course semble inversée (elle signale qu'elle est "ouverte" lorsqu'elle est déclenchée et vice-versa), ajoutez un " !" à la définition de la broche (par exemple, "endstop_pin : ^!ar3"), ou supprimez le " !" s'il est déjà présent.

Si la fin de course ne change pas du tout, cela indique généralement que la fin de course est connectée à une autre broche. Cependant, cela peut également nécessiter une modification du paramètre de pullup de la broche (le '^' au début du nom endstop_pin - la plupart des imprimantes utilisent une résistance pullup et le '^' doit être présent).

## Vérifier les moteurs pas à pas

Utilisez la commande STEPPER_BUZZ pour vérifier la connectivité de chaque moteur pas à pas. Commencez par positionner manuellement l'axe donné à un point médian, puis exécutez la commande `STEPPER_BUZZ STEPPER=stepper_x`. La commande STEPPER_BUZZ fera en sorte que le moteur pas à pas donné se déplace d'un millimètre dans une direction positive, puis il reviendra à sa position de départ. (Si la fin de course est définie à position_endstop=0, alors au début de chaque mouvement, le stepper s'éloignera de la fin de course). Il effectuera cette oscillation dix fois.

Si le moteur pas à pas ne bouge pas du tout, vérifiez les réglages "enable_pin" et "step_pin" du moteur pas à pas. Si le moteur pas à pas se déplace mais ne revient pas à sa position initiale, vérifiez le réglage "dir_pin". Si le moteur pas à pas oscille dans une direction incorrecte, cela indique généralement que le paramètre "dir_pin" de l'axe doit être inversé. Pour ce faire, il suffit d'ajouter un " !" au paramètre "dir_pin" dans le fichier de configuration de l'imprimante (ou de le supprimer s'il y en a déjà un). Si le moteur se déplace de manière significativement supérieure ou inférieure à un millimètre, vérifiez le paramètre "rotation_distance".

Exécutez le test ci-dessus pour chaque moteur pas à pas défini dans le fichier de configuration. (Définissez le paramètre STEPPER de la commande STEPPER_BUZZ au nom de la section de la configuration qui doit être testée). S'il n'y a pas de filament dans l'extrudeur, on peut utiliser STEPPER_BUZZ pour vérifier la connectivité du moteur de l'extrudeur (utilisez STEPPER=extrudeur). Sinon, il est préférable de tester le moteur de l'extrudeur séparément (voir la section suivante).

Après avoir vérifié tous les arrêts et tous les moteurs pas à pas, le mécanisme d'auto-home doit être testé. Envoyez une commande G28 pour ramener tous les axes à leur position initiale. Coupez l'alimentation de l'imprimante si elle ne se positionne pas correctement. Répétez les étapes de vérification des fins de course et des moteurs pas à pas si nécessaire.

## Vérifier le moteur de l'extrudeur

Pour tester le moteur de l'extrudeur, il sera nécessaire de chauffer l'extrudeur à une température d'impression. Naviguez vers l'onglet température d'Octoprint et sélectionnez une température cible dans la boîte déroulante de température (ou entrez manuellement une température appropriée). Attendez que l'imprimante atteigne la température désirée. Naviguez ensuite vers l'onglet de contrôle Octoprint et cliquez sur le bouton "Extrude". Vérifiez que le moteur de l'extrudeur tourne dans la bonne direction. Si ce n'est pas le cas, consultez les conseils de dépannage de la section précédente pour confirmer les paramètres "enable_pin", "step_pin" et "dir_pin" de l'extrudeur.

## Calibrer les paramètres PID

Klipper prend en charge la [commande PID](https://en.wikipedia.org/wiki/PID_controller) pour l'extrudeuse et les dispositifs de chauffage du lit. Afin d'utiliser ce mécanisme de contrôle, il est nécessaire de calibrer les paramètres PID sur chaque imprimante. (Les paramètres PID trouvés dans d'autres firmwares ou dans les fichiers de configuration d'exemple fonctionnent souvent mal).

Pour calibrer l'extrudeur, naviguez dans l'onglet du terminal OctoPrint et exécutez la commande PID_CALIBRATE. Par exemple : `PID_CALIBRATE HEATER=extruder TARGET=170`

A la fin du test de réglage, exécutez `SAVE_CONFIG` pour mettre à jour le fichier printer.cfg avec les nouveaux paramètres PID.

Si l'imprimante est équipée d'un lit chauffant et qu'elle peut être pilotée par PWM (Pulse Width Modulation), il est recommandé d'utiliser la commande PID pour le plateau (lorsque le chauffage du lit est contrôlé à l'aide de l'algorithme PID, il peut s'allumer et s'éteindre dix fois par seconde, ce qui peut ne pas convenir aux chauffages utilisant un interrupteur mécanique). Une commande typique de calibrage PID du plateau est : `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Prochaines étapes

Ce guide a pour but d'aider à la vérification de base des paramètres des broches dans le fichier de configuration de Klipper. Veillez à lire le guide [bed leveling](Bed_Level.md). Consultez également le document [Slicers](Slicers.md) pour obtenir des informations sur la configuration d'un trancheur avec Klipper.

Après avoir vérifié que l'impression de base fonctionne, il est bon d'envisager de calibrer [l'avance de pression](Pressure_Advance.md).

Il peut être nécessaire d'effectuer d'autres types de calibrage détaillé de l'imprimante - un certain nombre de guides sont disponibles en ligne pour vous aider (par exemple, faites une recherche sur le Web pour "3d printer calibration"). Par exemple, si vous rencontrez un effet appelé "ringing", vous pouvez essayer de suivre le guide de réglage de la [compensation de résonance](Resonance_Compensation.md).
