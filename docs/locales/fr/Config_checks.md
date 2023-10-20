# Contrôles de la configuration

Ce document fournit une liste des étapes permettant de vérifier les affectations des broches dans le fichier printer.cfg de Klipper. Il est conseillé d'exécuter ces étapes après avoir suivi les étapes du [document d'installation](Installation.md).

Pendant ce guide, il peut être nécessaire d'apporter des modifications au fichier de configuration de Klipper. Veillez à émettre une commande RESTART après chaque modification du fichier de configuration pour vous assurer que la modification prend effet (tapez "restart" dans l'onglet du terminal Octoprint et cliquez ensuite sur "Send"). C'est aussi une bonne idée d'envoyer une commande STATUS après chaque RESTART pour vérifier que le fichier de configuration a été chargé avec succès.

## Vérifier la température

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Vérifier M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Vérifier la cartouche chauffante

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Si l'imprimante est équipée d'un plateau chauffant, effectuez à nouveau le test ci-dessus avec le plateau.

## Vérifier l'activation du moteur pas à pas

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Vérifier les capteurs de fin de course

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Si la fin de course ne change pas du tout, cela indique généralement que la fin de course est connectée à une autre broche. Cependant, cela peut également nécessiter une modification du paramètre de pullup de la broche (le '^' au début du nom endstop_pin - la plupart des imprimantes utilisent une résistance pullup et le '^' doit être présent).

## Vérifier les moteurs pas à pas

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Si le moteur pas à pas ne bouge pas du tout, vérifiez les réglages "enable_pin" et "step_pin" du moteur pas à pas. Si le moteur pas à pas se déplace mais ne revient pas à sa position initiale, vérifiez le réglage "dir_pin". Si le moteur pas à pas oscille dans une direction incorrecte, cela indique généralement que le paramètre "dir_pin" de l'axe doit être inversé. Pour ce faire, il suffit d'ajouter un " !" au paramètre "dir_pin" dans le fichier de configuration de l'imprimante (ou de le supprimer s'il y en a déjà un). Si le moteur se déplace de manière significativement supérieure ou inférieure à un millimètre, vérifiez le paramètre "rotation_distance".

Exécutez le test ci-dessus pour chaque moteur pas à pas défini dans le fichier de configuration. (Définissez le paramètre STEPPER de la commande STEPPER_BUZZ au nom de la section de la configuration qui doit être testée). S'il n'y a pas de filament dans l'extrudeur, on peut utiliser STEPPER_BUZZ pour vérifier la connectivité du moteur de l'extrudeur (utilisez STEPPER=extrudeur). Sinon, il est préférable de tester le moteur de l'extrudeur séparément (voir la section suivante).

Après avoir vérifié tous les arrêts et tous les moteurs pas à pas, le mécanisme d'auto-home doit être testé. Envoyez une commande G28 pour ramener tous les axes à leur position initiale. Coupez l'alimentation de l'imprimante si elle ne se positionne pas correctement. Répétez les étapes de vérification des fins de course et des moteurs pas à pas si nécessaire.

## Vérifier le moteur de l'extrudeur

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Calibrer les paramètres PID

Klipper prend en charge le [régulateur PID](https://fr.wikipedia.org/wiki/R%C3%A9gulateur_PID) pour l'extrudeuse et le chauffage du lit. Afin d'utiliser ce mécanisme de contrôle, il est nécessaire de calibrer les paramètres PID sur chaque imprimante (les paramètres PID trouvés dans d'autres micrologiciels ou dans les fichiers de configuration d'exemple fonctionnent souvent mal).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

A la fin du test de réglage, exécutez `SAVE_CONFIG` pour mettre à jour le fichier printer.cfg avec les nouveaux paramètres PID.

Si l'imprimante est équipée d'un lit chauffant et qu'elle peut être pilotée par PWM (Pulse Width Modulation), il est recommandé d'utiliser la commande PID pour le plateau (lorsque le chauffage du lit est contrôlé à l'aide de l'algorithme PID, il peut s'allumer et s'éteindre dix fois par seconde, ce qui peut ne pas convenir aux chauffages utilisant un interrupteur mécanique). Une commande typique de calibrage PID du plateau est : `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Prochaines étapes

Ce guide a pour but d'aider à la vérification de base des paramètres des broches dans le fichier de configuration de Klipper. Veillez à lire le guide [bed leveling](Bed_Level.md). Consultez également le document [Slicers](Slicers.md) pour obtenir des informations sur la configuration d'un trancheur avec Klipper.

Après avoir vérifié que l'impression de base fonctionne, il est bon d'envisager de calibrer [l'avance de pression](Pressure_Advance.md).

Il peut être nécessaire d'effectuer d'autres types de calibrage détaillé de l'imprimante - un certain nombre de guides sont disponibles en ligne pour vous aider (par exemple, faites une recherche sur le Web pour "3d printer calibration"). Par exemple, si vous rencontrez un effet appelé "ringing", vous pouvez essayer de suivre le guide de réglage de la [compensation de résonance](Resonance_Compensation.md).
