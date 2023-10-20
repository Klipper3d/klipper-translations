# Changements de configuration

Ce document couvre les modifications logicielles apportées au fichier de configuration qui ne sont pas rétro compatibles. Il est conseillé de consulter ce document lors de la mise à jour du logiciel Klipper.

Toutes les dates de ce document sont approximatives.

## Changements

20230826: If `safe_distance` is set or calculated to be 0 in `[dual_carriage]`, the carriages proximity checks will be disabled as per documentation. A user may wish to configure `safe_distance` explicitly to prevent accidental crashes of the carriages with each other. Additionally, the homing order of the primary and the dual carriage is changed in some configurations (certain configurations when both carriages home in the same direction, see [[dual_carriage] configuration reference](./Config_Reference.md#dual_carriage) for more details).

20230810: The flash-sdcard.sh script now supports both variants of the Bigtreetech SKR-3, STM32H743 and STM32H723. For this, the original tag of btt-skr-3 now has changed to be either btt-skr-3-h743 or btt-skr-3-h723.

20230729: The exported status for `dual_carriage` is changed. Instead of exporting `mode` and `active_carriage`, the individual modes for each carriage are exported as `printer.dual_carriage.carriage_0` and `printer.dual_carriage.carriage_1`.

20230619: The `relative_reference_index` option has been deprecated and superceded by the `zero_reference_position` option. Refer to the [Bed Mesh Documentation](./Bed_Mesh.md#the-deprecated-relative_reference_index) for details on how to update the configuration. With this deprecation the `RELATIVE_REFERENCE_INDEX` is no longer available as a parameter for the `BED_MESH_CALIBRATE` gcode command.

20230530: The default canbus frequency in "make menuconfig" is now 1000000. If using canbus and using canbus with some other frequency is required, then be sure to select "Enable extra low-level configuration options" and specify the desired "CAN bus speed" in "make menuconfig" when compiling and flashing the micro-controller.

20230525: `SHAPER_CALIBRATE` command immediately applies input shaper parameters if `[input_shaper]` was enabled already.

20230407: The `stalled_bytes` counter in the log and in the `printer.mcu.last_stats` field has been renamed to `upcoming_bytes`.

20230323: On tmc5160 drivers `multistep_filt` is now enabled by default. Set `driver_MULTISTEP_FILT: False` in the tmc5160 config for the previous behavior.

20230304 : La commande `SET_TMC_CURRENT` ajuste désormais correctement le registre globalscaler pour les pilotes qui l'ont. Cela supprime une limitation où sur tmc5160, les courants ne pouvaient pas être augmentés plus haut avec `SET_TMC_CURRENT` que la valeur `run_current` définie dans le fichier de configuration. Cependant, cela a un effet secondaire : après avoir exécuté `SET_TMC_CURRENT`, le moteur pas à pas doit être maintenu à l'arrêt pendant plus de 130 ms dans le cas où StealthChop2 est utilisé afin que l'étalonnage AT#1 soit exécuté par le pilote.

20230202 : Le format des informations d'état `printer.screws_tilt_adjust` a changé. Les informations sont maintenant stockées sous forme de dictionnaire de vis avec les mesures résultantes. Voir la [référence d'état](Status_Reference.md#screws_tilt_adjust) pour plus de détails.

20230201 : Le module `[bed_mesh]` ne charge plus le profil `default` au démarrage. Il est recommandé aux utilisateurs qui utilisent le profil `default` d'ajouter `BED_MESH_PROFILE LOAD=default` à leur macro `START_PRINT` (ou à la configuration "Start G-Code" de leur trancheur si applicable).

20230103 : Il est maintenant possible avec le script flash-sdcard.sh de flasher les deux variantes du Bigtreetech SKR-2, STM32F407 et STM32F429. Cela signifie que le tag originel de btt-skr2 a maintenant changé en btt-skr-2-f407 ou btt-skr-2-f429.

20221128 : Sortie de Klipper v0.11.0.

20221122 : Auparavant, avec safe_z_home, il était possible que le z_hop après la mise à l'origine g28 aille dans une direction z négative. Maintenant, un saut en z n'est effectué après g28 que s'il résulte en un saut positif, reflétant le comportement du saut en z se produisant avant la mise à l'origine g28.

20220616 : Il était auparavant possible de flasher un rp2040 en mode bootloader en exécutant `make flash FLASH_DEVICE=first`. La commande équivalente est maintenant `make flash FLASH_DEVICE=2e8a:0003`.

20220612 : Le micro-contrôleur rp2040 a maintenant une solution de contournement pour l'errata USB "rp2040-e5". Cela devrait rendre les premières connexions USB plus fiables. Cependant, cela peut entraîner un changement de comportement de la broche gpio15. Il est peu probable que le changement de comportement de la gpio15 soit perceptible.

20220407 : L'option de configuration `pid_integral_max` de temperature_fan a été supprimée (elle était obsolète depuis 20210612).

20220407 : L'ordre des couleurs par défaut pour les LEDs pca9632 est maintenant "RGBW". Ajoutez un paramètre explicite `color_order : RBGW` à la section pca9632 config pour obtenir le comportement précédent.

20220330 : Le format des informations d'état `printer.neopixel.color_data` des modules neopixel et dotstar a changé. L'information est maintenant stockée comme une liste de listes de couleurs (au lieu d'une liste de dictionnaires). Voir la [référence d'état](Status_Reference.md#led) pour plus de détails.

20220307 : `M73` ne mettra plus la progression de l'impression à 0 si `P` est absent.

20220304 : Il n'y a plus de valeur par défaut pour le paramètre `extruder` des sections de configuration [extruder_stepper](Config_Reference.md#extruder_stepper). Si vous le souhaitez, spécifiez explicitement `extruder : extruder` pour associer le moteur pas à pas à la file d'attente de mouvement "extruder" au démarrage.

20220210 : La commande `SYNC_STEPPER_TO_EXTRUDER` est obsolète ; la commande `SET_EXTRUDER_STEP_DISTANCE` est obsolète ; l'option de configuration `shared_heater` de l'[extrudeuse](Config_Reference.md#extruder) est obsolète. Ces fonctionnalités seront supprimées dans un futur proche. Remplacez `SET_EXTRUDER_STEP_DISTANCE` par `SET_EXTRUDER_ROTATION_DISTANCE`. Remplacez `SYNC_STEPPER_TO_EXTRUDER` par `SYNC_EXTRUDER_MOTION`. Remplacez les sections de configuration de l'extrudeuse utilisant `shared_heater` par les sections de configuration [extruder_stepper](Config_Reference.md#extruder_stepper) et mettez à jour toutes les macros d'activation pour utiliser [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion).

20220116 : Le code de calcul `run_current` des tmc2130, tmc2208, tmc2209, et tmc2660 a changé. Pour certains paramètres `run_current` les pilotes peuvent maintenant être configurés différemment. Cette nouvelle configuration devrait être plus précise, mais elle peut invalider les réglages précédents des pilotes tmc.

20211230 : Les scripts pour ajuster le façonneur d'entrée (`scripts/calibrate_shaper.py` et `scripts/graph_accelerometer.py`) ont été migrés pour utiliser Python3 par défaut. Par conséquent, les utilisateurs doivent installer les versions Python3 de certains paquets (par exemple, `sudo apt install python3-numpy python3-matplotlib`) pour continuer à utiliser ces scripts. Pour plus de détails, reportez-vous à [Installation du logiciel](Measuring_Resonances.md#software-installation). Alternativement, les utilisateurs peuvent temporairement forcer l'exécution de ces scripts sous Python 2 en appelant explicitement l'interpréteur Python2 dans la console : `python2 ~/klipper/scripts/calibrate_shaper.py ...`

20211110 : Le capteur de température "NTC 100K beta 3950" est déprécié. Ce capteur sera supprimé dans un avenir proche. La plupart des utilisateurs trouveront le capteur de température "Generic 3950" plus précis. Pour continuer à utiliser l'ancienne définition (généralement moins précise), définissez une [thermistance personnalisée ](Config_Reference.md#thermistor) avec `température1 : 25`, `résistance1 : 100000`, et `beta : 3950`.

20211104 : L'option "step pulse duration" dans "make menuconfig" a été supprimée. La durée d'impulsion par défaut pour les pilotes TMC configurés en mode UART ou SPI est maintenant de 100ns. Un nouveau paramètre `step_pulse_duration` dans la section [configuration des moteurs](Config_Reference.md#stepper) doit être défini pour tous les moteurs nécessitant une durée d'impulsion personnalisée.

20211102 : Plusieurs fonctionnalités obsolètes ont été supprimées. L'option `step_distance` du stepper a été supprimée (obsolète depuis 20201222). L'alias du capteur `rpi_temperature` a été supprimé (obsolète depuis 20210219). L'option mcu `pin_map` a été supprimée (obsolète depuis 20210325). L'option gcode_macro `default_parameter_<name>` et l'accès aux paramètres de commande par la macro autrement que par la pseudo-variable `params` ont été supprimés (obsolète depuis 20210503). L'option heater `pid_integral_max` a été supprimée (obsolète le 20210612).

20210929 : Sortie de Klipper v0.10.0.

20210903 : La valeur par défaut de [`smooth_time`](Config_Reference.md#extruder) pour les éléments chauffants est passée à 1 seconde (au lieu de 2 secondes). Pour la plupart des imprimantes, cela permettra un contrôle plus stable de la température.

20210830 : Le nom par défaut de adxl345 est maintenant "adxl345". Le paramètre CHIP par défaut pour les fonctions `ACCELEROMETER_MEASURE` et `ACCELEROMETER_QUERY` est maintenant aussi "adxl345".

20210830 : La commande adxl345 ACCELEROMETER_MEASURE ne prend plus en charge un paramètre RATE. Pour modifier le taux d'interrogation, mettez à jour le fichier printer.cfg et lancez une commande RESTART.

20210821 : Plusieurs paramètres de configuration dans `printer.configfile.settings` seront maintenant rapportés sous forme de listes au lieu de chaînes brutes. Si vous souhaitez obtenir une chaîne de caractères brute, utilisez `printer.configfile.config` à la place.

20210819 : Dans certains cas, un mouvement de retour à l'origine `G28` peut se terminer dans une position qui est nominalement en dehors de la plage de mouvement valide. Dans de rares situations, cela peut entraîner des erreurs déroutantes "Move out of range" après le retour à la position initiale. Si cela se produit, modifiez vos scripts de démarrage pour déplacer la tête d'outil vers une position valide immédiatement après le retour à la position initiale.

20210814 : Les pseudo-pins analogiques sur l'atmega168 et l'atmega328 ont été renommés de PE0/PE1 à PE2/PE3.

20210720 : Une section controller_fan surveille maintenant tous les moteurs pas à pas par défaut (pas seulement les moteurs pas à pas cinématiques). Si le comportement précédent est souhaité, voir l'option de configuration `stepper` dans la [référence de configuration](Config_Reference.md#controller_fan).

20210703 : Une section de configuration `samd_sercom` doit maintenant spécifier le bus sercom qu'elle configure via l'option `sercom`.

20210612 : l'option de configuration `pid_integral_max` dans les sections heater et temperature_fan est obsolète. Cette option sera supprimée dans les prochaines versions.

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430 : la commande SET_VELOCITY_LIMIT (et M204) peuvent maintenant définir une "velocity", "acceleration", et "square_corner_velocity" supérieurs aux valeurs spécifiées dans le fichier de configuration.

20210325 : La prise en charge de l'option de configuration `pin_map` est obsolète. Utilisez le fichier [sample-aliases.cfg](../config/sample-aliases.cfg) pour traduire les noms des broches réelles du microcontrôleur. L'option de configuration `pin_map` sera supprimée dans les prochaines version.

20210313 : La prise en charge de Klipper pour les microcontrôleurs CAN bus a été modifiée. Si vous utilisez CANBus, tous les microcontrôleurs doivent être reflashés et [le fichier de configuration de Klipper doit être mise à jour](CANBUS.md).

20210310 : la valeur par défaut de driver_SFILT pour les TMC2660 a été modifiée : passage de 1 à 0 par défaut.

20210227 : Les pilotes de moteur pas à pas TMC en mode UART ou SPI sont désormais interrogés une fois par seconde si ils sont activés - si le pilote ne peut pas être contacté ou si le pilote signale une erreur, alors Klipper passera à un état d'arrêt.

20210219 : Le module `rpi_temperature` a été renommé en `temperature_host`. Remplacez toutes les occurrences de `sensor_type : rpi_temperature` par `sensor_type : temperature_host`. Le chemin vers le fichier de température peut être spécifié dans la variable de configuration `sensor_path`. Le nom `rpi_temperature` est obsolète et sera supprimé dans les prochaines versions.

20210201: La commande `TEST_RESONANCES` va maintenant désactiver la mise en forme des entrées si elle était précédemment activée (et la réactiver après le test). Afin d'outrepasser ce comportement et de garder la mise en forme de l'entrée activée, on peut passer un paramètre supplémentaire `INPUT_SHAPING=1` à la commande.

20210201 : La commande `ACCELEROMETER_MEASURE` ajoutera désormais le nom de la puce accéléromètre au nom du fichier de sortie si un nom a été donné à la puce dans la section adxl345 correspondante du printer.cfg.

20201222 : Le paramètre `step_distance` dans les sections de configuration de moteur est obsolète. Il est conseillé de mettre à jour la configuration pour utiliser le paramètre [`rotation_distance`](Rotation_Distance.md). Le support de `step_distance` sera supprimé dans un futur proche.

20201218 : Le paramètre `endstop_phase` du module endstop_phase a été remplacé par `trigger_phase`. Si vous utilisez le module endstop phases, il sera nécessaire de convertir en [`rotation_distance`](Rotation_Distance.md) et de recalibrer les phases endstop en exécutant la commande ENDSTOP_PHASE_CALIBRATE.

20201218 : Les imprimantes rotatives delta et polaires doivent maintenant spécifier un `gear_ratio` pour leurs moteurs rotatifs, et elles ne peuvent plus spécifier un paramètre `step_distance`. Voir la [référence de configuration](Config_Reference.md#stepper) pour le format du nouveau paramètre gear_ratio.

20201213 : Il n'est pas valide de spécifier un Z "position_endstop" lors de l'utilisation de "probe:z_virtual_endstop". Une erreur sera maintenant soulevée si un Z "position_endstop" est spécifié avec "probe:z_virtual_endstop". Supprimez la définition de Z "position_endstop" pour corriger l'erreur.

20201120 : La section de configuration `[board_pins]` spécifie maintenant le nom du mcu dans un paramètre explicite `mcu:`. Si vous utilisez board_pins pour un mcu secondaire, alors la config doit être mise à jour pour spécifier ce nom. Voir la [référence config](Config_Reference.md#board_pins) pour plus de détails.

20201112 : La durée rapportée par `print_stats.print_duration` a changé. La durée précédant la première extrusion détectée est maintenant exclue.

20201029 : L'option de configuration neopixel `color_order_GRB` a été supprimée. Si nécessaire, mettez à jour la configuration pour définir la nouvelle option `color_order` sur RGB, GRB, RGBW, ou GRBW.

20201029 : L'option serial dans la section mcu config ne prend plus par défaut /dev/ttyS0. Dans la rare situation où /dev/ttyS0 est le port série désiré, il doit être indiqué explicitement.

20201020 : Sortie de Klipper v0.9.0.

20200902 : Le calcul de la résistance à la température des RTD des convertisseurs MAX31865 a été corrigé pour ne pas lire une valeur basse. Si vous utilisez un tel dispositif, vous devez recalibrer votre température d'impression et vos paramètres PID.

20200816 : L'objet macro gcode `printer.gcode` a été renommé en `printer.gcode_move`. Plusieurs variables non documentées dans `printer.toolhead` et `printer.gcode` ont été supprimées. Voir docs/Command_Templates.md pour une liste des variables de modèles disponibles.

20200816 : Le système de macro gcode "action_" a changé. Remplacez tout appel à `printer.gcode.action_emergency_stop()` par `action_emergency_stop()`, `printer.gcode.action_respond_info()` par `action_respond_info()`, et `printer.gcode.action_respond_error()` par `action_raise_error()`.

20200809 : Le système de menu a été réécrit. Si le menu a été personnalisé, il sera nécessaire de le mettre à jour avec la nouvelle configuration. Voir config/example-menu.cfg pour les détails de la configuration et voir klippy/extras/display/menu.cfg pour les exemples.

20200731 : Le comportement de l'attribut `progress` rapporté par l'objet imprimante `virtual_sdcard` a changé. La progression n'est plus remise à 0 lorsqu'une impression est mise en pause. La progression est maintenant toujours basée sur la position interne du fichier, ou 0 si aucun fichier n'est chargé.

20200725 : Le paramètre de configuration `enable` du servo et le paramètre SET_SERVO `ENABLE` ont été supprimés. Mettez à jour toutes les macros pour utiliser `SET_SERVO SERVO=my_servo WIDTH=0` pour désactiver un servo.

20200608 : Le support de l'affichage LCD a changé le nom de certains "glyphes" internes. Si une disposition d'affichage personnalisée a été implémentée, il peut être nécessaire d'actualiser avec les noms actuels de glyphes (voir klippy/extras/display/display.cfg pour une liste des glyphes disponibles).

20200606 : Les noms des broches sur linux mcu ont changé. Les broches ont maintenant des noms de la forme `gpiochip<chipid>/gpio<gpio>`. Pour gpiochip0 vous pouvez aussi utiliser un court `gpio<gpio>`. Par exemple, ce qui était précédemment appelé `P20` devient maintenant `gpio20` ou `gpiochip0/gpio20``.

20200603 : La disposition par défaut de l'écran LCD 16x4 n'affiche plus le temps estimé restant pour une impression. (Seul le temps écoulé sera affiché.) Si l'on souhaite conserver l'ancien comportement, on peut personnaliser l'affichage du menu avec cette information (voir la description de display_data dans config/example-extras.cfg pour plus de détails).

20200531 : L'id par défaut du vendeur/produit USB est maintenant 0x1d50/0x614e. Ces nouveaux identifiants sont réservés à Klipper (grâce au projet openmoko). Ce changement ne devrait pas nécessiter de modification de la configuration, mais les nouveaux identifiants peuvent apparaître dans les journaux système.

20200524 : La valeur par défaut du champ pwm_freq du tmc5160 est maintenant zéro (au lieu de un).

20200425 : La variable du modèle de commande gcode_macro `printer.heater` a été renommée en `printer.heaters`.

20200313 : La disposition par défaut de l'écran pour les imprimantes multi-extrudeurs avec un écran 16x4 a changé. La disposition de l'écran pour un seul extrudeur est maintenant la disposition par défaut et elle montrera l'extrudeur actuellement actif. Pour utiliser la disposition d'écran précédente, définissez "display_group : _multiextruder_16x4" dans la section [display] du fichier printer.cfg.

20200308 : L'élément de menu par défaut `__test` a été supprimé. Si le fichier de configuration a un menu personnalisé, assurez-vous de supprimer toutes les références à cet élément de menu `__test`.

20200308 : Les options "deck" et "card" du menu ont été supprimées. Pour personnaliser la disposition d'un écran lcd, utilisez les nouvelles sections de configuration display_data (voir config/example-extras.cfg pour les détails).

20200109 : Le module bed_mesh fait désormais référence à l'emplacement de la sonde pour la configuration du maillage. Ainsi, certaines options de configuration ont été renommées pour mieux refléter leur fonctionnalité. Pour les lits rectangulaires, `min_point` et `max_point` ont été renommés en `mesh_min` et `mesh_max` respectivement. Pour les lits ronds, `bed_radius` a été renommé en `mesh_radius`. Une nouvelle option `mesh_origin` a également été ajoutée pour les lits ronds. Notez que ces changements sont également incompatibles avec les profils de maillage précédemment enregistrés. Si un profil incompatible est détecté, il sera ignoré et sa suppression sera programmée. Le processus de suppression peut être achevé en lançant la commande SAVE_CONFIG. L'utilisateur devra recalibrer chaque profil.

20191218 : La section de configuration de l'affichage ne prend plus en charge "lcd_type : st7567". Utilisez le type d'affichage "uc1701" à la place - définissez "lcd_type : uc1701" et changez "rs_pin : some_pin" en "rst_pin : some_pin". Il peut également être nécessaire d'ajouter un paramètre de configuration "contrast : 60".

20191210 : Les commandes intégrées T0, T1, T2, ... ont été supprimées. Les options de configuration activate_gcode et deactivate_gcode de l'extrudeuse ont été supprimées. Si ces commandes (et scripts) sont nécessaires, définissez des macros individuelles de type [gcode_macro T0] qui appellent la commande ACTIVATE_EXTRUDER. Voir les fichiers config/sample-idex.cfg et sample-multi-extruder.cfg pour des exemples.

20191210 : La prise en charge de la commande M206 a été supprimée. Remplacer par des appels à SET_GCODE_OFFSET. Si le support de M206 est nécessaire, ajoutez une section de configuration [gcode_macro M206] qui appelle SET_GCODE_OFFSET. (Par exemple "SET_GCODE_OFFSET Z=-{params.Z}".)

20191202 : La prise en charge du paramètre non documenté "S" de la commande "G4" a été supprimée. Remplacez toutes les occurrences de S par le paramètre standard "P" (le délai spécifié en millisecondes).

20191126 : Les noms USB ont changé sur les micro-contrôleurs avec un support USB natif. Ils utilisent désormais un identifiant de puce unique par défaut (lorsqu'il est disponible). Si une section de configuration "mcu" utilise un paramètre "serial" qui commence par "/dev/serial/by-id/", il peut être nécessaire de mettre à jour la configuration. Exécutez "ls /dev/serial/by-id/*" dans un terminal ssh pour déterminer le nouvel identifiant.

20191121 : Le paramètre pressure_advance_lookahead_time a été supprimé. Voir example.cfg pour d'autres paramètres de configuration.

20191112 : La capacité d'activation virtuelle du pilote de pas à pas tmc est désormais automatiquement activée si le moteur pas à pas ne possède pas de broche d'activation dédiée. Supprimez les références à tmcXXXX:virtual_enable de la configuration. La possibilité de contrôler plusieurs broches dans la configuration enable_pin du moteur a été supprimée. Si plusieurs broches sont nécessaires, utilisez une section de configuration multi_pin.

20191107 : La section de configuration de l'extrudeur primaire doit être spécifiée comme "extruder" et ne peut plus être spécifiée comme "extruder0". Les modèles de commande Gcode qui interrogent le statut de l'extrudeur sont désormais accessibles via "{printer.extruder}".

20191021 : Sortie de Klipper v0.8.0

20191003 : L'option move_to_previous de [safe_z_homing] a désormais la valeur par défaut False. (Elle était effectivement False avant 20190918.)

20190918 : L'option zhop de [safe_z_homing] est toujours réappliquée après la fin du homing sur l'axe Z. Cela peut obliger les utilisateurs à mettre à jour les scripts personnalisés basés sur ce module.

20190806 : La commande SET_NEOPIXEL a été renommée SET_LED.

20190726 : Le code numérique-analogique du mcp4728 a été modifié. L'adresse i2c_address par défaut est maintenant 0x60 et la référence de tension est maintenant relative à la référence interne de 2,048 volts du mcp4728.

20190710 : L'option z_hop a été supprimée de la section de configuration [firmware_retract]. La prise en charge de z_hop était incomplète et pouvait provoquer un comportement incorrect avec plusieurs trancheurs courants.

20190710 : Les paramètres optionnels de la commande PROBE_ACCURACY ont été modifiés. Il peut être nécessaire de mettre à jour les macros ou les scripts qui utilisent cette commande.

20190628 : Toutes les options de configuration ont été supprimées de la section [skew_correction]. La configuration de la correction d'obliquité se fait désormais via le gcode SET_SKEW. Voir [Correction de l'obliquité](Skew_Correction.md) pour l'utilisation recommandée.

20190607 : Les paramètres "variable_X" de gcode_macro (ainsi que le paramètre VALUE de SET_GCODE_VARIABLE) sont maintenant analysés comme des littéraux Python. Si une valeur doit être assignée à une chaîne de caractères, mettez-la entre guillemets pour qu'elle soit évaluée comme une chaîne de caractères.

20190606 : Les options de configuration "samples", "samples_result" et "sample_retract_dist" ont été déplacées vers la section de configuration "probe". Ces options ne sont plus supportées dans les sections de configuration "delta_calibrate", "bed_tilt", "bed_mesh", "screws_tilt_adjust", "z_tilt", ou "quad_gantry_level".

20190528 : La variable magique "status" dans l'évaluation du modèle gcode_macro a été renommée en "printer".

20190520 : La commande SET_GCODE_OFFSET a été modifiée ; mettez à jour vos macros de code G en conséquence. La commande n'appliquera plus le décalage demandé à la prochaine commande G1. L'ancien comportement peut être approché en utilisant le nouveau paramètre "MOVE=1".

20190404 : Les paquets du logiciel hôte Python ont été mis à jour. Les utilisateurs devront réexécuter le script ~/klipper/scripts/install-octopi.sh (ou mettre à jour les dépendances python s'ils n'utilisent pas une installation OctoPi standard).

20190404 : Les paramètres i2c_bus et spi_bus (dans diverses sections de configuration) prennent désormais un nom de bus au lieu d'un numéro.

20190404 : Les paramètres de configuration du sx1509 ont changé. Le paramètre 'adresse' est maintenant 'i2c_address' et doit être spécifié comme un nombre décimal. Là où 0x3E était précédemment utilisé, spécifiez 62.

20190328 : La valeur min_speed dans la configuration [temperature_fan] sera désormais respectée et le ventilateur fonctionnera toujours à cette vitesse ou plus en mode PID.

20190322 : La valeur par défaut de "driver_HEND" dans les sections de configuration [tmc2660] a été modifiée de 6 à 3. Le champ "driver_VSENSE" a été supprimé (il est désormais calculé automatiquement à partir de run_current).

20190310 : La section de configuration [controller_fan] prend désormais toujours un nom (tel que [controller_fan my_controller_fan]).

20190308 : Le champ "driver_BLANK_TIME_SELECT" dans les sections de configuration [tmc2130] et [tmc2208] a été renommé "driver_TBL".

20190308 : La section config [tmc2660] a été modifiée. Un nouveau paramètre de configuration sense_resistor doit maintenant être fourni. La signification de plusieurs des paramètres driver_XXX a été modifiée.

20190228 : Les utilisateurs de SPI ou I2C sur les cartes SAMD21 doivent maintenant spécifier les broches du bus via une section de configuration [samd_sercom].

20190224 : L'option bed_shape a été supprimée de bed_mesh. L'option radius a été renommée bed_radius. Les utilisateurs avec des lits ronds doivent fournir les options bed_radius et round_probe_count.

20190107 : Le paramètre i2c_address de la section config du mcp4451 a été modifié. Il s'agit d'un paramètre courant sur les Smoothieboards. La nouvelle valeur est la moitié de l'ancienne valeur (88 doit être changé en 44, et 90 doit être changé en 45).

20181220 : Sortie de Klipper v0.7.0
