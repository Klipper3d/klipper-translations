# Contrôles de la configuration

Ce document fournit une liste des étapes permettant de vérifier les affectations des broches dans le fichier printer.cfg de Klipper. Il est conseillé d'exécuter ces étapes après avoir suivi les étapes du [document d'installation](Installation.md).

Pendant ce guide, il peut être nécessaire d'apporter des modifications au fichier de configuration de Klipper. Veillez à émettre une commande RESTART après chaque modification du fichier de configuration pour vous assurer que la modification prend effet (tapez "restart" dans l'onglet du terminal Octoprint et cliquez ensuite sur "Send"). C'est aussi une bonne idée d'envoyer une commande STATUS après chaque RESTART pour vérifier que le fichier de configuration a été chargé avec succès.

## Vérifier la température

Commencez par vérifier que les températures sont correctes. Accédez à la section du graphique de température de l'interface utilisateur. Vérifier que la température de la buse et du lit (le cas échéant) est affichée et n'augmente pas. Si elle augmente, éteignez l'imprimante. Si les températures ne sont pas exactes, consultez les paramètres "sensor_type" et "sensor_pin" pour la buse et/ou le lit.

## Vérifier M112

Dans la console du terminal, tapez une commande M112. Cette commande demande à Klipper de passer dans l'état 'arrêté'. Cela va provoquer l'affichage d'un erreur, qui peut être effacée avec une commande FIRMWARE_RESTART dans la console du terminal. Octoprint nécessitera également une reconnexion. Retournez ensuite vers les graphiques de température et vérifiez que les températures continuent de se mettre à jour et qu'elles n'augmentent pas. Si les températures augmentent, éteignez l'imprimante.

## Vérifier la cartouche chauffante

Accédez à la section du graphique de température et tapez 50, puis entrez dans la zone de température de l'extrudeuse/de l'outil. La température de l'extrudeuse indiquée sur le graphique devrait commencer à augmenter (dans un délai d'environ 30 secondes). Accédez ensuite à la liste déroulante de la température de l'extrudeuse et sélectionnez « Désactivé ». Après quelques minutes, la température devrait commencer à revenir à sa valeur initiale de température ambiante. Si la température n'augmente pas, vérifiez le paramètre "heater_pin" dans la configuration.

Si l'imprimante est équipée d'un plateau chauffant, effectuez à nouveau le test ci-dessus avec le plateau.

## Vérifier l'activation du moteur pas à pas

Vérifiez que tous les axes de l'imprimante peuvent se déplacer librement manuellement (les moteurs pas à pas sont désactivés). Sinon, émettez une commande M84 pour désactiver les moteurs. Si un des axes ne peut toujours pas se déplacer librement, vérifiez la configuration du "enable_pin" du moteur pas à pas pour l'axe concerné. Sur la plupart des pilotes de moteurs pas à pas de base, la broche d'activation du moteur est "active basse" et donc la broche d'activation devrait avoir un " !" avant la broche (par exemple, "enable_pin : !PA1").

## Vérifier les capteurs de fin de course

Déplacez manuellement tous les axes de l'imprimante pour qu'aucun d'entre eux ne soit en contact avec un capteur de fin de course. Envoyez une commande QUERY_ENDSTOPS via la console de commande. La réponse devrait indiquer l'état actuel de tous les fins de course configurés et ils devraient tous indiquer un état "ouvert". Pour chacun des fins de course, relancez la commande QUERY_ENDSTOPS en déclenchant manuellement le fin de course. La commande QUERY_ENDSTOPS devrait indiquer que le fin de course est "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!PA2"), or remove the "!" if there is already one present.

Si la fin de course ne change pas du tout, cela indique généralement que la fin de course est connectée à une autre broche. Cependant, cela peut également nécessiter une modification du paramètre de pullup de la broche (le '^' au début du nom endstop_pin - la plupart des imprimantes utilisent une résistance pullup et le '^' doit être présent).

## Vérifier les moteurs pas à pas

Utilisez la commande STEPPER_BUZZ pour vérifier la connectivité de chaque moteur pas à pas. Commencez par positionner manuellement l'axe donné à mi-course, puis exécutez `STEPPER_BUZZ STEPPER=stepper_x` dans la console de commande. La commande STEPPER_BUZZ fera bouger le moteur pas à pas d'un millimètre dans une direction positive, puis il reviendra à sa position de départ. (Si le fin de course est défini à position_endstop=0, alors au début de chaque mouvement, le moteur pas à pas s'éloignera du fin de course.) Il effectuera cette oscillation dix fois.

Si le moteur pas à pas ne bouge pas du tout, vérifiez les réglages "enable_pin" et "step_pin" du moteur pas à pas. Si le moteur pas à pas se déplace mais ne revient pas à sa position initiale, vérifiez le réglage "dir_pin". Si le moteur pas à pas oscille dans une direction incorrecte, cela indique généralement que le paramètre "dir_pin" de l'axe doit être inversé. Pour ce faire, il suffit d'ajouter un " !" au paramètre "dir_pin" dans le fichier de configuration de l'imprimante (ou de le supprimer s'il y en a déjà un). Si le moteur se déplace de manière significativement supérieure ou inférieure à un millimètre, vérifiez le paramètre "rotation_distance".

Exécutez le test ci-dessus pour chaque moteur pas à pas défini dans le fichier de configuration. (Définissez le paramètre STEPPER de la commande STEPPER_BUZZ au nom de la section de la configuration qui doit être testée). S'il n'y a pas de filament dans l'extrudeur, on peut utiliser STEPPER_BUZZ pour vérifier la connectivité du moteur de l'extrudeur (utilisez STEPPER=extrudeur). Sinon, il est préférable de tester le moteur de l'extrudeur séparément (voir la section suivante).

Après avoir vérifié tous les arrêts et tous les moteurs pas à pas, le mécanisme d'auto-home doit être testé. Envoyez une commande G28 pour ramener tous les axes à leur position initiale. Coupez l'alimentation de l'imprimante si elle ne se positionne pas correctement. Répétez les étapes de vérification des fins de course et des moteurs pas à pas si nécessaire.

## Vérifier le moteur de l'extrudeur

Pour tester le moteur de l'extrudeur, il sera nécessaire de chauffer l'extrudeur à une température d'impression. Naviguez vers la section du graphique de température et sélectionnez une température cible dans le menu déroulant (ou entrez manuellement une température appropriée). Attendez que l'imprimante atteigne la température souhaitée. Ensuite, allez dans la console de commande et cliquez sur le bouton "Extrude". Vérifiez que le moteur de l'extrudeur tourne dans la bonne direction. Si ce n'est pas le cas, consultez les conseils de dépannage dans la section précédente pour confirmer les réglages des broches "enable_pin", "step_pin" et "dir_pin" de l'extrudeur.

## Calibrer les paramètres PID

Klipper prend en charge le [régulateur PID](https://fr.wikipedia.org/wiki/R%C3%A9gulateur_PID) pour l'extrudeuse et le chauffage du lit. Afin d'utiliser ce mécanisme de contrôle, il est nécessaire de calibrer les paramètres PID sur chaque imprimante (les paramètres PID trouvés dans d'autres micrologiciels ou dans les fichiers de configuration d'exemple fonctionnent souvent mal).

Pour calibrer l'extrudeur, allez dans la console de commande et exécutez la commande PID_CALIBRATE. Par exemple : `PID_CALIBRATE HEATER=extruder TARGET=170`

A la fin du test de réglage, exécutez `SAVE_CONFIG` pour mettre à jour le fichier printer.cfg avec les nouveaux paramètres PID.

Si l'imprimante est équipée d'un lit chauffant et qu'elle peut être pilotée par PWM (Pulse Width Modulation), il est recommandé d'utiliser la commande PID pour le plateau (lorsque le chauffage du lit est contrôlé à l'aide de l'algorithme PID, il peut s'allumer et s'éteindre dix fois par seconde, ce qui peut ne pas convenir aux chauffages utilisant un interrupteur mécanique). Une commande typique de calibrage PID du plateau est : `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Prochaines étapes

Ce guide a pour but d'aider à la vérification de base des paramètres des broches dans le fichier de configuration de Klipper. Veillez à lire le guide [bed leveling](Bed_Level.md). Consultez également le document [Slicers](Slicers.md) pour obtenir des informations sur la configuration d'un trancheur avec Klipper.

Après avoir vérifié que l'impression de base fonctionne, il est bon d'envisager de calibrer [l'avance de pression](Pressure_Advance.md).

Il peut être nécessaire d'effectuer d'autres types de calibrage détaillé de l'imprimante - un certain nombre de guides sont disponibles en ligne pour vous aider (par exemple, faites une recherche sur le Web pour "3d printer calibration"). Par exemple, si vous rencontrez un effet appelé "ringing", vous pouvez essayer de suivre le guide de réglage de la [compensation de résonance](Resonance_Compensation.md).
