# G-Codes

Ce document décrit les commandes que Klipper supporte. Il s'agit de commandes que l'on peut saisir dans l'onglet du terminal OctoPrint.

## Commandes G-Code

Klipper prend en charge les commandes G-Code standard suivantes :

- Move (G0 ou G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- Temporisation : `G4 P<millisecondes>`
- Déplacement vers l'origine : `G28 [X] [Y] [Z] `
- Turn off motors: `M18` or `M84`
- Wait for current moves to finish: `M400`
- Use absolute/relative distances for extrusion: `M82`, `M83`
- Use absolute/relative coordinates: `G90`, `G91`
- Définir la position : `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] `
- Définir le pourcentage de neutralisation du facteur de vitesse : `M220 S<percent>`
- Définit le pourcentage d'annulation du facteur d'extrusion : `M221 S<percent>`
- Régler l'accélération : `M204 S<valeur>` OU `M204 P<valeur> T<valeur>`
   - Remarque : si S n'est pas spécifié et que P et T le sont, l'accélération sera réglée sur le minimum de P et T. Si un seul P ou T est donné, la commande n'aura aucun effet.
- Obtenir la température de l'extrudeur : `M105`
- Régler la température de l'extrudeur : `M104 [T<index>] [S<température>] `
- Régler la température de l'extrudeur et attendre : `M109 [T<index>] S<température> `
   - Note : M109 attendra toujours que la température se stabilise à la valeur demandée.
- Régler la température du bed : `M140 [S<temperature>]`
- Régler la température du bed et attendre : `M190 S<temperature>`
   - Note : M190 attendra toujours que la température se stabilise à la valeur demandée.
- Régler la vitesse du ventilateur : `M106 S<valeur>`
- Turn fan off: `M107`
- Arrêt d'urgence : `M112`
- Obtenir la position actuelle : `M114`
- Obtenir la version du firmware : `M115`

Pour plus de détails sur les commandes ci-dessus, voir la [documentation RepRap G-Code] (http://reprap.org/wiki/G-code).

L'objectif de Klipper est de prendre en charge les commandes G-Code produites par les logiciels tiers courants (par exemple, OctoPrint, Printrun, Slic3r, Cura, etc.) dans leurs configurations standard. L'objectif n'est pas de prendre en charge toutes les commandes G-Code possibles. A la place, Klipper préfère les ["commandes G-Code étendues"](#extended-g-code-commands) plus faciles à lire pour un humain.

Si vous avez besoin d'une commande G-Code moins courante, il est possible de l'implémenter avec une section de configuration [gcode_macro personnalisée](Config_Reference.md#gcode_macro). Par exemple, on peut utiliser ceci pour implémenter : `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1`, etc.

### Commandes G-Code pour carte SD

Klipper prend également en charge les commandes G-Code standard suivantes si la [section de configuration virtual_sdcard](Config_Reference.md#virtual_sdcard) est activée :

- Liste des cartes SD : `M20`
- Initialiser la carte SD : `M21`
- Sélectionnez le fichier SD : `M23 <nom du fichier> `
- Start/resume SD print: `M24`
- Suspendre l'impression depuis la SD : `M25`
- Définir la position SD : `M26 S<décalage> `
- Afficher l'état d'impression depuis la carte SD : `M27`

En outre, les commandes étendues suivantes sont disponibles lorsque la section de configuration « virtual_sdcard » est activée.

- Charger un fichier et lancer l'impression depuis la SD : `SDCARD_PRINT_FILE FILENAME=<filename>`
- Unload file and clear SD state: `SDCARD_RESET_FILE`

### Arcs de G-Code

The following standard G-Code commands are available if a [gcode_arcs config section](Config_Reference.md#gcode_arcs) is enabled:

- Controlled Arc Move (G2 or G3): `G2 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>`

### Rétraction du firmware G-Code

The following standard G-Code commands are available if a [firmware_retraction config section](Config_Reference.md#firmware_retraction) is enabled:

- Rétractation : `G10`
- Unretract: `G11`

### Commandes d’affichage G-Code

The following standard G-Code commands are available if a [display config section](Config_Reference.md#display) is enabled:

- Afficher un message : `M117 <message> `
- Définir le pourcentage de génération : `M73 P<pourcentage>`

### Autres commandes G-Code disponibles

The following standard G-Code commands are currently available, but using them is not recommended:

- Obtenir le statut Fin de course : `M119` (Utilisez QUERY_ENDSTOPS à la place.)

## Commandes G-Code étendues

Klipper utilise des commandes G-Code "étendues" pour la configuration générale et l'état. Ces commandes étendues suivent toutes un format similaire : elles commencent par le nom de la commande et peuvent être suivies d'un ou plusieurs paramètres. Par exemple : `SET_SERVO SERVO=myservo ANGLE=5.3 `. Dans ce document, les commandes et les paramètres sont indiqués en majuscules, mais ils ne sont pas sensibles à la casse. (Ainsi, "SET_SERVO" et "set_servo" exécuteront tous deux la même commande).

The following standard commands are supported:

- `QUERY_ENDSTOPS`: Teste les butées d'axe et indique si elles sont "déclenchées" ou dans un état "ouvert". Cette commande est généralement utilisée pour vérifier qu'un butoir de fin de course fonctionne correctement.
- `QUERY_ADC [NAME=<nom_de_la_configuration>] [PULLUP=<valeur>] ` : Rapporte la dernière valeur analogique reçue pour une broche analogique donnée. Si NAME n'est pas fourni, la liste des noms d'adc disponibles est retournée. Si PULLUP est fourni (comme une valeur en Ohms), la valeur analogique brute ainsi que la résistance équivalente relative à ce pullup est retournée.
- `GET_POSITION` : Retourne les informations sur la position actuelle de la tête.
- `SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]] ` : Définit un décalage positionnel à appliquer aux futures commandes G-Code. Ceci est généralement utilisé pour changer virtuellement le décalage Z du bed ou pour définir les décalages XY des buses lors du changement d'extrudeur. Par exemple, si "SET_GCODE_OFFSET Z=0.2" est donné, les prochains mouvements G-Code auront 0,2mm ajouté à leur hauteur Z. Si les paramètres de style X_ADJUST sont utilisés, l'ajustement sera ajouté à tout décalage existant (par exemple, "SET_GCODE_OFFSET Z=-0.2" suivi de "SET_GCODE_OFFSET Z_ADJUST=0.3" donnerait un décalage Z total de 0.1). Si "MOVE=1" est spécifié, un déplacement de la tête d'outil sera effectué pour appliquer le décalage donné (sinon le décalage prendra effet lors du prochain déplacement absolu en G-code qui spécifie l'axe donné). Si "MOVE_SPEED" est spécifié, le déplacement de la tête d'outil sera effectué avec la vitesse donnée (en mm/s) ; sinon, le déplacement de la tête d'outil utilisera la dernière vitesse G-Code spécifiée.
- `SAVE_GCODE_STATE [NAME=<nom_de_l'état>]` : Sauvegarde l'état actuel de l'analyse des coordonnées du g-code. La sauvegarde et le rétablissement de l'état du g-code sont utiles dans les scripts et les macros. Cette commande enregistre le mode actuel de coordonnées absolues en g-code (G90/G91), le mode d'extrusion absolue (M82/M83), l'origine (G92), le décalage (SET_GCODE_OFFSET), la priorité de vitesse (M220), la priorité d'extrusion (M221), la vitesse de déplacement, la position XYZ actuelle et la position relative de l'extrudeuse "E". Si NOM est fourni, cela permet de nommer l'état sauvegardé avec la chaîne de caractères donnée. Si le NOM n'est pas fourni, la valeur par défaut est "default".
- `RESTORE_GCODE_STATE [NAME=<nom_de_l'état>] [MOVE=1 [MOVE_SPEED=<speed>]]` : Restaure un état précédemment sauvegardé via SAVE_GCODE_STATE. Si "MOVE=1" est spécifié, un déplacement de la tête d'outil sera effectué pour revenir à la position XYZ précédente. Si "MOVE_SPEED" est spécifié, alors le déplacement de la tête d'outil sera effectué avec la vitesse donnée (en mm/s) ; sinon, le déplacement de la tête d'outil utilisera la vitesse du G-Code restauré.
- ` PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`: Effectuer un test d’étalonnage PID. Le chauffage demandé sera activé jusqu’à ce que la température définie soit atteinte, il s'éteindra et se rallumera durant plusieurs cycles. Si le paramètre WRITE_FILE est activé, le fichier /tmp/heattest.txt sera créé avec un journal de tous les échantillons de température mesurés pendant le test.
- `TURN_OFF_HEATERS`: Turn off all heaters.
- `TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Wait until the given temperature sensor is at or above the supplied MINIMUM and/or at or below the supplied MAXIMUM.
- `SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [ACCEL_TO_DECEL=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: Modify the printer's velocity limits.
- `SET_HEATER_TEMPERATURE HEATER=<nom_du_chauffeur> [TARGET=<température_cible>] ` : Définit la température cible d'un élément chauffant. Si une température cible n'est pas fournie, la cible est 0.
- `ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: Pour une imprimante avec plusieurs extrudeurs, cette commande permet de changer l'extrudeur actif.
- `SET_PRESSURE_ADVANCE [EXTRUDER=<nom_de_la_configuration>] [ADVANCE=<avance_de_pression>] [SMOOTH_TIME=<avance_de_pression_smooth_time>] ` : Définit les paramètres d'avance de pression. Si EXTRUDER n'est pas spécifié, il s'agit par défaut de l'extrudeur active.
- `SET_EXTRUDER_STEP_DISTANCE [EXTRUDER=<nom_config>] [DISTANCE=<distance>] ` : Définit une nouvelle valeur pour la "distance de pas" de l'extrudeur fourni. La "distance de pas" est `rotation_distance/(full_steps_per_rotation*microsteps)`. La valeur n'est pas conservée lors de la réinitialisation de Klipper. A utiliser avec précaution, de petites modifications peuvent entraîner une pression excessive entre l'extrudeur et l'extrémité chaude. Procédez avec des étapes de calibrage appropriées avec le filament avant de l'utiliser. Si la valeur 'DISTANCE' n'est pas incluse, la commande retournera la distance de pas courante.
- `SET_STEPPER_ENABLE STEPPER=<nom_de_la_configuration> ENABLE=[0|1] ` : Active ou désactive uniquement le stepper donné. Il s'agit d'un outil de diagnostic et de débogage qui doit donc être utilisé avec précaution. La désactivation d'un moteur d'axe ne réinitialise pas les informations d'orientation. Le déplacement manuel d'un moteur pas à pas désactivé peut amener la machine à faire fonctionner le moteur en dehors des limites de sécurité. Cela peut entraîner des dommages aux composants de l'axe, aux extrémités chaudes et à la surface d'impression.
- `STEPPER_BUZZ STEPPER=<config_name>`: Move the given stepper forward one mm and then backward one mm, repeated 10 times. This is a diagnostic tool to help verify stepper connectivity.
- `MANUAL_PROBE [SPEED=<speed>]`: Exécute un script d'aide servant à mesurer la hauteur de la buse à un point donné. Si SPEED est spécifié, il définit la vitesse des commandes TESTZ (la valeur par défaut est 5mm/s). Pendant un sondage manuel, les commandes supplémentaires suivantes sont disponibles :
   - `ACCEPT`: Cette commande valide la position Z actuelle et met fin au sondage manuel.
   - `ABORT`: Cette commande interrompt le sondage manuel.
   - `TESTZ Z=<value>`: This command moves the nozzle up or down by the amount specified in "value". For example, `TESTZ Z=-.1` would move the nozzle down .1mm while `TESTZ Z=.1` would move the nozzle up .1mm. The value may also be `+`, `-`, `++`, or `--` to move the nozzle up or down an amount relative to previous attempts.
- `Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: Run a helper script useful for calibrating a Z position_endstop config setting. See the MANUAL_PROBE command for details on the parameters and the additional commands available while the tool is active.
- `Z_OFFSET_APPLY_ENDSTOP`: Take the current Z Gcode offset (aka, babystepping), and subtract it from the stepper_z endstop_position. This acts to take a frequently used babystepping value, and "make it permanent". Requires a `SAVE_CONFIG` to take effect.
- `TUNING_TOWER COMMAND=<command> PARAMETER=<name> START=<value> [SKIP=<value>] [FACTOR=<value> [BAND=<value>]] | [STEP_DELTA=<value> STEP_HEIGHT=<value>]`: A tool for tuning a parameter on each Z height during a print. The tool will run the given `COMMAND` with the given `PARAMETER` assigned to a value that varies with `Z` according to a formula. Use `FACTOR` if you will use a ruler or calipers to measure the Z height of the optimum value, or `STEP_DELTA` and `STEP_HEIGHT` if the tuning tower model has bands of discrete values as is common with temperature towers. If `SKIP=<value>` is specified, the tuning process doesn't begin until Z height `<value>` is reached, and below that the value will be set to `START`; in this case, the `z_height` used in the formulas below is actually `max(z - skip, 0)`. There are three possible combinations of options:
   - `FACTOR`: The value changes at a rate of `factor` per millimeter. The formula used is `value = start + factor * z_height`. You can plug the optimum Z height directly into the formula to determine the optimum parameter value.
   - `FACTOR` and `BAND`: The value changes at an average rate of `factor` per millimeter, but in discrete bands where the adjustment will only be made every `BAND` millimeters of Z height. The formula used is `value = start + factor * ((floor(z_height / band) + .5) * band)`.
   - `STEP_DELTA` and `STEP_HEIGHT`: The value changes by `STEP_DELTA` every `STEP_HEIGHT` millimeters. The formula used is `value = start + step_delta * floor(z_height / step_height)`. You can simply count bands or read tuning tower labels to determine the optimum value.
- `SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group> ` : Définit le groupe d'affichage actif d'un écran LCD. Cela permet de définir plusieurs groupes de données d'affichage dans la configuration, par exemple `[display_data <group> <elementname>]` et de passer de l'un à l'autre en utilisant cette commande gcode étendue. Si DISPLAY n'est pas spécifié, la valeur par défaut est "display" (l'affichage principal).
- `SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]` : Permet à l'utilisateur de définir le délai d'inactivité (en secondes).
- `RESTART` : Cette commande permet au logiciel hôte de recharger sa configuration et d'effectuer une réinitialisation interne. Cette commande n'efface pas l'état d'erreur du micro-contrôleur (voir FIRMWARE_RESTART) et ne charge pas de nouveau logiciel (voir [la FAQ](FAQ.md#how-do-i-upgrade-to-the-latest-software)).
- `FIRMWARE_RESTART` : Cette commande est similaire à un RESTART, mais elle efface également tout état d'erreur du micro-contrôleur.
- `SAVE_CONFIG`: Cette commande écrase le fichier de configuration principal de l'imprimante et redémarre le logiciel hôte. Cette commande est utilisée conjointement avec d'autres commandes d'étalonnage pour enregistrer les résultats de ces tests.
- `STATUS`: Report the Klipper host software status.
- `HELP` : Affiche la liste des commandes G-Code étendues disponibles.

### Commandes de macro G-Code

The following command is available when a [gcode_macro config section](Config_Reference.md#gcode_macro) is enabled (also see the [command templates guide](Command_Templates.md)):

- `SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value> ` : Cette commande permet de changer la valeur d'une variable gcode_macro au moment de l'exécution. La valeur fournie est analysée comme un littéral Python.

### Commandes de broches personnalisées

The following command is available when an [output_pin config section](Config_Reference.md#output_pin) is enabled:

- `SET_PIN PIN=nom_de_configuration VALUE=<valeur> CYCLE_TIME=<temps_de_cycle> `

Remarque : Le matériel PWM ne prend pas encore en charge le paramètre CYCLE_TIME et utilisera donc le temps de cycle défini dans le config.

### Commandes des ventilateurs contrôlés manuellement

The following command is available when a [fan_generic config section](Config_Reference.md#fan_generic) is enabled:

- `SET_FAN_SPEED FAN=nom_du_config SPEED=<speed> ` Cette commande définit la vitesse d'un ventilateur. <speed> doit être comprise entre 0,0 et 1,0.

### Commandes Neopixel et Dotstar

The following command is available when a [neopixel config section](Config_Reference.md#neopixel) or [dotstar config section](Config_Reference.md#dotstar) is enabled:

- `SET_LED LED=<nom_de_la_configuration> ROUGE=<valeur> VERT=<valeur> BLEU=<valeur> BLANC=<valeur> [INDEX=<index>] [TRANSMIT=0] [SYNC=1] ` : Ceci définit la sortie de la LED. Chaque couleur `<valeur>` doit être comprise entre 0,0 et 1,0. L'option WHITE n'est valable que pour les LEDs RGBW. Si plusieurs puces LED sont chaînées en guirlande, on peut spécifier INDEX pour modifier la couleur de la seule puce donnée (1 pour la première puce, 2 pour la deuxième, etc.). Si INDEX n'est pas spécifié, alors toutes les LEDs de la chaîne seront réglées sur la couleur fournie. Si TRANSMIT=0 est spécifié, le changement de couleur ne sera effectué que lors de la prochaine commande SET_LED qui ne spécifie pas TRANSMIT=0 ; cela peut être utile en combinaison avec le paramètre INDEX pour effectuer des mises à jour multiples dans une chaîne. Par défaut, la commande SET_LED synchronisera ses changements avec les autres commandes gcode en cours. Cela peut conduire à un comportement indésirable si les LEDs sont réglées alors que l'imprimante n'imprime pas, car cela réinitialisera le délai d'inactivité. Si un timing précis n'est pas nécessaire, le paramètre optionnel SYNC=0 peut être spécifié pour appliquer les changements instantanément et ne pas réinitialiser le délai d'inactivité.

### Commandes de servo

The following commands are available when a [servo config section](Config_Reference.md#servo) is enabled:

- `SET_SERVO SERVO=nom_config [ANGLE=<degrés> | LARGEUR=<secondes>] ` : Définit la position du servo à l'angle (en degrés) ou à la largeur d'impulsion (en secondes) donnés. Utilisez `WIDTH=0` pour désactiver la sortie du servo.

### Commandes manuelles du stepper

The following command is available when a [manual_stepper config section](Config_Reference.md#manual_stepper) is enabled:

- `MANUAL_STEPPER STEPPER=nom_du_config [ENABLE=[0|1]]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]] ` : Cette commande modifie l'état du stepper. Utilisez le paramètre ENABLE pour activer/désactiver le stepper. Utilisez le paramètre SET_POSITION pour forcer le moteur pas à pas à penser qu'il se trouve à la position donnée. Utilisez le paramètre MOVE pour déplacer vers la position donnée. Si SPEED et/ou ACCEL sont spécifiés, les valeurs données seront utilisées à la place de celles par défaut issues du fichier de configuration. Si un ACCEL de zéro est spécifié, aucune accélération ne sera effectuée. Si STOP_ON_ENDSTOP=1 est spécifié, le déplacement se terminera prématurément si la fin de course est déclenchée (utilisez STOP_ON_ENDSTOP=2 pour terminer le déplacement sans erreur même si la fin de course n'est pas déclenchée, utilisez -1 ou -2 pour s'arrêter lorsque la fin de course n'est pas déclenchée). Normalement, les futures commandes G-Code seront programmées pour être exécutées après la fin du déplacement de la commande de pas, mais si un déplacement manuel de la commande de pas utilise SYNC=0, les futures commandes de déplacement G-Code peuvent être exécutées en parallèle avec le déplacement de la commande de pas.

### Commandes de l'extrudeur pas à pas

The following command is available when an [extruder_stepper config section](Config_Reference.md#extruder_stepper) is enabled:

- `SYNC_STEPPER_TO_EXTRUDER STEPPER=<extruder_stepper config_name> [EXTRUDER=<extruder config_name>]`: This command will cause the given STEPPER to become synchronized to the given EXTRUDER, overriding the extruder defined in the "extruder_stepper" config section.

### Palpeur

The following commands are available when a [probe config section](Config_Reference.md#probe) is enabled (also see the [probe calibrate guide](Probe_Calibrate.md)):

- `PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]` : Déplace la buse vers le bas jusqu'à ce que le palpeur se déclenche. Si l'un des paramètres facultatifs est fourni, il remplace son paramètre équivalent dans la section [configuration de la sonde](Config_Reference.md#probe).
- `QUERY_PROBE`: Retourne l'état actuel de la sonde ("triggered" ou "open").
- ` PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]` : Calculer le maximum, le minimum, la moyenne, la médiane et l’écart type des échantillons des multiples palpeurs. Par défaut, 10 ÉCHANTILLONS sont prélevés. Sinon, les paramètres optionnels peuvent être définis dans la section de configuration du palpeur.
- ` PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>]` : Exécute l'assistant servant à calibrer le z_offset du palpeur. Consultez la commande PROBE pour plus d’informations sur les paramètres optionnels du palpeur. Reportez-vous à la commande MANUAL_PROBE pour plus d’informations sur le paramètre SPEED et les commandes supplémentaires disponibles lorsque l'assistant est actif. Veuillez noter que la commande PROBE_CALIBRATE utilise la variable de vitesse pour se déplacer dans la direction XY ainsi que dans Z.
- `Z_OFFSET_APPLY_PROBE`: Take the current Z Gcode offset (aka, babystepping), and subtract if from the probe's z_offset. This acts to take a frequently used babystepping value, and "make it permanent". Requires a `SAVE_CONFIG` to take effect.

### BLTouch

The following command is available when a [bltouch config section](Config_Reference.md#bltouch) is enabled (also see the [BL-Touch guide](BLTouch.md)):


   - `BLTOUCH_DEBUG COMMAND=<command>` : Envoie une commande au BLTouch. Elle peut être utile pour le débogage. Les commandes disponibles sont : `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`, (*1) : `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store`*** Notez que les commandes marquées par (*1) sont uniquement supportées par un BL-Touch V3.0 ou V3.1(+).
- `BLTOUCH_STORE MODE=<output_mode>` : Stocke un mode de sortie dans l'EEPROM d'un BLTouch V3.1 Les modes de sortie disponibles sont : `5V`, `OD`

### Calibrage Delta

The following commands are available when the [delta_calibrate config section](Config_Reference.md#linear-delta-kinematics) is enabled (also see the [delta calibrate guide](Delta_Calibrate.md)):

- `DELTA_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>] ` : Cette commande teste sept points sur le lit et recommande des positions de butée, des angles de tour et des rayons mis à jour. Voir la commande PROBE pour plus de détails sur les paramètres de palpage optionnels. Si METHOD=manual est spécifié, l'outil de palpage manuel est activé - voir la commande MANUAL_PROBE ci-dessus pour plus de détails sur les commandes supplémentaires disponibles lorsque cet outil est actif.
- `DELTA_ANALYZE`: Cette commande est utilisée pendant l'étalonnage delta amélioré. Voir [Calibrage delta](Delta_Calibrate.md) pour plus de détails.

### Inclinaison du bed

The following commands are available when the [bed_tilt config section](Config_Reference.md#bed_tilt) is enabled:

- `BED_TILT_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>] ` : Cette commande teste les points spécifiés dans la configuration, puis recommande des ajustements d'inclinaison x et y mis à jour. Voir la commande PROBE pour plus de détails sur les paramètres de palpage optionnels. Si METHOD=manual est spécifié, l'outil de palpage manuel est activé - voir la commande MANUAL_PROBE ci-dessus pour plus de détails sur les commandes supplémentaires disponibles lorsque cet outil est actif.

### Nivellement du bed par maillage

The following commands are available when the [bed_mesh config section](Config_Reference.md#bed_mesh) is enabled (also see the [bed mesh guide](Bed_Mesh.md)):

- `BED_MESH_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>] [<mesh_parameter>=<value>]` : Cette commande palpe le bed en utilisant des points générés spécifiés par les paramètres de la config. Après le test, un maillage est généré et le déplacement de l'axe Z est ajusté en fonction de celui-ci. Référez-vous à la commande PROBE pour plus de détails sur les paramètres optionnels. Si METHOD=manual est spécifié, l'outil de palpage manuel est activé - voir la commande MANUAL_PROBE ci-dessus pour plus de détails sur les possibilités supplémentaires disponibles lorsque cet outil est utilisé.
- `BED_MESH_OUTPUT PGP=[<0:1>]`: Cette commande sort les valeurs z obtenues lors du palpage et les valeurs de maillage courantes sur le terminal. Si PGP=1 est spécifié, les coordonnées x,y générées par bed_mesh, ainsi que leurs indices associés, seront affichés sur le terminal.
- `BED_MESH_MAP` : Comme pour BED_MESH_OUTPUT, cette commande affiche l'état actuel du maillage sur le terminal. L'état sera retourné au format json. Cela permet aux plugins octoprint de récupérer facilement les données et de générer des cartes d'altitude au plus proche de la surface du bed.
- `BED_MESH_CLEAR`: Cette commande efface le maillage actuel et supprime les ajustements de l'axe z. Il est recommandé de mettre cette commande dans votre gcode de fin.
- `BED_MESH_PROFILE LOAD=<name> SAVE=<name> REMOVE=<name> ` : Cette commande fournit une gestion de profil pour l'état du maillage. LOAD restaurera le maillage à partir du profil <name>. SAVE sauvegarde l'état actuel du maillage dans un profil nommé selon <name>. REMOVE supprime de la mémoire persistante le profil <name>. A savoir qu'une fois les opérations SAVE ou REMOVE executées, le gcode SAVE_CONFIG doit être lancé pour enregistrer les changements dans la mémoire persistante.
- `BED_MESH_OFFSET [X=<value>] [Y=<value>] ` : Applique des décalages X et/ou Y pour l'évaluation du maillage. Ceci est utile pour les imprimantes avec extrudeurs indépendants, car un décalage est nécessaire pour obtenir un ajustement Z correct après un changement d'outil.

### Assistant pour les vis du bed

The following commands are available when the [bed_screws config section](Config_Reference.md#bed_screws) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws)):

- `BED_SCREWS_ADJUST`: Cette commande fait appel à l'outil de réglage des vis du bed. Elle commandera la buse à différents endroits (tels que définis dans le fichier de configuration) et permettra d'ajuster les vis du bed afin que celui-ci et la buse soient à distance constante.

### Assistant de réglage de l'inclinaison des vis du bed

The following commands are available when the [screws_tilt_adjust config section](Config_Reference.md#screws_tilt_adjust) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)):

- `SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [<paramètre_sonde>=<valeur>] ` : Cette commande appellera l'outil de réglage des vis du bed. Elle commandera la buse à différents endroits (tels que définis dans le fichier de configuration) en testant la hauteur z et calculera le nombre de tours de bouton pour ajuster le niveau du lit. Si DIRECTION est spécifié, les tours de bouton seront tous dans la même direction, dans le sens des aiguilles d'une montre (CW) ou dans le sens inverse (CCW). Voir la commande PROBE pour plus de détails sur les paramètres optionnels du palpeur. IMPORTANT : Vous DEVEZ toujours effectuer un G28 avant d'utiliser cette commande.

### Z Tilt

The following commands are available when the [z_tilt config section](Config_Reference.md#z_tilt) is enabled:

- `Z_TILT_ADJUST [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters.

### Chariots doubles

The following command is available when the [dual_carriage config section](Config_Reference.md#dual_carriage) is enabled:

- `SET_DUAL_CARRIAGE CARRIAGE=[0|1]`: Cette commande définit le chariot actif. Elle est généralement appelée à partir des champs activate_gcode et deactivate_gcode dans une configuration à extrudeurs multiples.

### TMC stepper drivers

The following commands are available when any of the [tmcXXXX config sections](Config_Reference.md#tmc-stepper-driver-configuration) are enabled:

- `DUMP_TMC STEPPER=<nom>` : Cette commande lit les registres du pilote TMC et renvoie leurs valeurs.
- `INIT_TMC STEPPER=<name>`: Cette commande va initialiser les registres du TMC. Nécessaire pour réactiver le pilote si l'alimentation de la puce est interrompue puis rétablie.
- `SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: This will adjust the run and hold currents of the TMC driver. (HOLDCURRENT is not applicable to tmc2660 drivers.)
- `SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value>`: This will alter the value of the specified register field of the TMC driver. This command is intended for low-level diagnostics and debugging only because changing the fields during run-time can lead to undesired and potentially dangerous behavior of your printer. Permanent changes should be made using the printer configuration file instead. No sanity checks are performed for the given values.

### Réglages des butées par phase pas à pas

The following commands are available when an [endstop_phase config section](Config_Reference.md#endstop_phase) is enabled (also see the [endstop phase guide](Endstop_Phase.md)):

- `ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]` : Si aucun paramètre STEPPER n'est fourni, cette commande rapporte des statistiques sur les phases d'arrêt du stepper pendant les précédentes opérations de recherche d'origine. Lorsqu'un paramètre STEPPER est fourni, elle fait en sorte que le paramètre de phase de fin de course donné soit écrit dans le fichier de configuration (en lien avec la commande SAVE_CONFIG).

### Forcer le déplacement

The following commands are available when the [force_move config section](Config_Reference.md#force_move) is enabled:

- `FORCE_MOVE STEPPER=<nom_de_la_configuration> DISTANCE=<valeur> VELOCITE=<valeur> [ACCEL=<valeur>] ` : Cette commande forcera le déplacement du stepper donné sur la distance donnée (en mm) à la vitesse constante donnée (en mm/s). Si ACCEL est spécifié et est supérieur à zéro, alors l'accélération donnée (en mm/s^2) sera utilisée ; sinon, aucune accélération n'est effectuée. Aucune vérification des limites n'est effectuée ; aucune mise à jour cinématique n'est faite ; les autres steppers parallèles sur un axe ne seront pas déplacés. Soyez prudent car une commande incorrecte pourrait endommager le matériel ! L'utilisation de cette commande placera presque certainement la cinématique de bas niveau dans un état incorrect ; émettez ensuite un G28 pour réinitialiser la cinématique. Cette commande est destinée aux diagnostics de bas niveau et au débogage.
- `SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] ` : Force le code cinématique de bas niveau à croire que la tête d'outil est à la position cartésienne donnée. Il s'agit d'une commande de diagnostic et de débogage ; utilisez SET_GCODE_OFFSET et/ou G92 pour des transformations d'axe régulières. Si un axe n'est pas spécifié, la position par défaut sera celle de la dernière commande de la tête. La définition d'une position incorrecte ou invalide peut entraîner des erreurs logicielles internes. Cette commande peut invalider les futures vérifications de limites ; émettez ensuite un G28 pour réinitialiser la cinématique.

### Boucle SDcard

When the [sdcard_loop config section](Config_Reference.md#sdcard_loop) is enabled, the following extended commands are available:

- `SDCARD_LOOP_BEGIN COUNT=<count>` : Démarre une boucle dans l'impression SD. Un compteur à 0 indique une boucle infinie.
- `SDCARD_LOOP_END`: Termine une section de boucle dans l'impression SD.
- `SDCARD_LOOP_DESIST`: Termine les boucles existantes sans autres itérations.

### Envoyer un message (répondre) à l’hôte

The following commands are availabe when the [respond config section](Config_Reference.md#respond) is enabled.

- `M118 <message>` : affiche le message précédé du préfixe par défaut configuré (ou `echo : ` si aucun préfixe n'est configuré).
- `RESPOND MSG="<message>"` : Affiche le message précédé du préfixe par défaut configuré (ou `echo : ` si aucun préfixe n'est configuré).
- `RESPOND TYPE=echo MSG="<message>" ` : affiche le message précédé par `echo : `.
- `RESPOND TYPE=commande MSG="<message>"` : affiche le message précédé par `// `. Octopint peut être configuré pour répondre à ces messages (par exemple `RESPOND TYPE=commande MSG=action:pause`).
- `RESPOND TYPE=error MSG="<message>" ` : affiche le message précédé par `!!!`.
- `RESPOND PREFIX=<prefix> MSG="<message>"` : renvoie le message précédé de `<prefix>`. (Le paramètre `PREFIX` est prioritaire sur le paramètre `TYPE`).

### Reprendre

The following commands are available when the [pause_resume config section](Config_Reference.md#pause_resume) is enabled:

- ` PAUSE` : suspend l’impression en cours. La position actuelle est enregistrée pour reprendre lorsque demandé.
- `RESUME [VELOCITY=<value>]` : Reprend l'impression à la suite d'une pause, en rétablissant d'abord la position capturée précédemment. Le paramètre VELOCITY détermine la vitesse à laquelle l'outil doit revenir à la position capturée d'origine.
- `CLEAR_PAUSE`: Supprime la mise en pause actuelle sans reprendre l'impression. Ceci est utile si l'on décide d'interrompre une impression après une PAUSE. Il est recommandé d'ajouter ceci à votre gcode de démarrage pour s'assurer que l'état de pause est réinitialisé pour chaque impression.
- `CANCEL_PRINT`: Annule l'impression en cours.

### Détecteur de filament

The following command is available when the [filament_switch_sensor or filament_motion_sensor config section](Config_Reference.md#filament_switch_sensor) is enabled.

- `QUERY_FILAMENT_SENSOR SENSOR=<nom_du_capteur> ` : Interroge l'état actuel du capteur de filament. Les données affichées sur le terminal dépendront du type de capteur défini dans la confguration.
- `SET_FILAMENT_SENSOR SENSOR=<nom_du_capteur> ENABLE=[0|1] ` : Active/désactive le détecteur de filament. Si ENABLE est réglé sur 0, le détecteur de filament est désactivé, s'il est réglé sur 1, il est activé.

### Rétraction du firmware

The following commands are available when the [firmware_retraction config section](Config_Reference.md#firmware_retraction) is enabled. These commands allow you to utilise the firmware retraction feature available in many slicers, to reduce stringing during non-extrusion moves from one part of the print to another. Appropriately configuring pressure advance reduces the length of retraction required.

- `SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>] ` : Ajuste les paramètres utilisés par la rétraction du micrologiciel. RETRACT_LENGTH détermine la longueur de filament à rétracter et à dérétracter. La vitesse de rétraction est ajustée via RETRACT_SPEED, et est généralement réglée relativement haut. La vitesse de déstratification est ajustée via UNRETRACT_SPEED, et n'est pas particulièrement critique, bien que souvent inférieure à RETRACT_SPEED. Dans certains cas, il est utile d'ajouter une petite quantité de longueur supplémentaire lors de la dérétraction, et ceci est réglé via UNRETRACT_EXTRA_LENGTH. SET_RETRACTION est généralement défini dans le cadre de la configuration du slicer par filament, car les différents filaments nécessitent des paramètres différents.
- `GET_RETRACTION`: Interroge les paramètres actuellement utilisés pour la rétraction du firmware et les affiche sur le terminal.
- `G10` : Rétracte l'extrudeur en utilisant les paramètres actuellement configurés.
- `G11` : Détache l'extrudeur en utilisant les paramètres actuellement configurés.

### Skew Correction

The following commands are available when the [skew_correction config section](Config_Reference.md#skew_correction) is enabled (also see the [skew correction guide](skew_correction.md)):

- `SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>] ` : Configure le module [skew_correction] avec des mesures (en mm) prises à partir d'une impression d'étalonnage. On peut entrer des mesures pour n'importe quelle combinaison de plans, les plans non entrés conserveront leur valeur actuelle. Si `CLEAR=1` est entré, toute correction d'inclinaison sera désactivée.
- `GET_CURRENT_SKEW`: Indique l'inclinaison actuelle de l'imprimante pour chaque plan en radians et en degrés. L'inclinaison est calculée en fonction des paramètres fournis par le gcode `SET_SKEW`.
- `CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>] ` : Calcule et renvoie l'inclinaison (en radians et en degrés) en fonction d'une impression mesurée. Cela peut être utile pour déterminer l'inclinaison actuelle de l'imprimante après l'application de la correction. Elle peut également être utile avant l'application de la correction pour déterminer si l'inclinaison en a besoin d'une. Voir skew_correction.md pour plus de détails sur les objets et les mesures de calibration de l'inclinaison.
- `SKEW_PROFILE [LOAD=<name>] [SAVE=<name>] [REMOVE=<name>]`: Profile management for skew_correction. LOAD will restore skew state from the profile matching the supplied name. SAVE will save the current skew state to a profile matching the supplied name. Remove will delete the profile matching the supplied name from persistent memory. Note that after SAVE or REMOVE operations have been run the SAVE_CONFIG gcode must be run to make the changes to peristent memory permanent.

### Code GC à retardement

The following command is enabled if a [delayed_gcode config section](Config_Reference.md#delayed_gcode) has been enabled (also see the [template guide](Command_Templates.md#delayed-gcodes)):

- `UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: Updates the delay duration for the identified [delayed_gcode] and starts the timer for gcode execution. A value of 0 will cancel a pending delayed gcode from executing.

### Enregistrer les variables

The following command is enabled if a [save_variables config section](Config_Reference.md#save_variables) has been enabled:

- `SAVE_VARIABLE VARIABLE=<nom> VALUE=<valeur> ` : Enregistre la variable sur le disque afin qu'elle puisse être utilisée lors des redémarrages. Toutes les variables enregistrées sont chargées dans le dict `printer.save_variables.variables` au démarrage et peuvent être utilisées dans des macros gcode. La VALEUR fournie est analysée comme un littéral Python.

### Compensation de la résonance

The following command is enabled if an [input_shaper config section](Config_Reference.md#input_shaper) has been enabled (also see the [resonance compensation guide](Resonance_Compensation.md)):

- `SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>] ` : Modifie les paramètres de mise en forme d'entrée. Notez que le paramètre SHAPER_TYPE réinitialise le shaper d'entrée pour les axes X et Y même si différents types de shaper ont été configurés dans la section [input_shaper]. SHAPER_TYPE ne peut pas être utilisé avec l'un des paramètres SHAPER_TYPE_X et SHAPER_TYPE_Y. Voir [config reference](Config_Reference.md#input_shaper) pour plus de détails sur chacun de ces paramètres.

### Temperature Fan Commands

The following command is available when a [temperature_fan config section](Config_Reference.md#temperature_fan) is enabled:

- `SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>]  [max_speed=<max_speed>]`: Sets the target temperature for a temperature_fan. If a target is not supplied, it is set to the specified temperature in the config file. If speeds are not supplied, no change is applied.

### Commandes pour l'accéléromètre Adxl345

The following commands are available when an [adxl345 config section](Config_Reference.md#adxl345) is enabled:

- `ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: Starts accelerometer measurements at the requested number of samples per second. If CHIP is not specified it defaults to "adxl345". The command works in a start-stop mode: when executed for the first time, it starts the measurements, next execution stops them. The results of measurements are written to a file named `/tmp/adxl345-<chip>-<name>.csv` where `<chip>` is the name of the accelerometer chip (`my_chip_name` from `[adxl345 my_chip_name]`) and `<name>` is the optional NAME parameter. If NAME is not specified it defaults to the current time in "YYYYMMDD_HHMMSS" format. If the accelerometer does not have a name in its config section (simply `[adxl345]`) then `<chip>` part of the name is not generated.
- `ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: queries accelerometer for the current value. If CHIP is not specified it defaults to "adxl345". If RATE is not specified, the default value is used. This command is useful to test the connection to the ADXL345 accelerometer: one of the returned values should be a free-fall acceleration (+/- some noise of the chip).
- `ADXL345_DEBUG_READ [CHIP=<config_name>] REG=<register>`: Interroge le registre <register> de l'ADXL345 (ex: 44 ou 0x2C). Peut-être utile pour déboguer.
- `ADXL345_DEBUG_WRITE [CHIP=<nom_de_la_configuration>] REG=<reg> VAL=<valeur>` : écrit la valeur brute <valeur> dans un registre <registre>. <valeur> et <registre> peuvent tous deux être un entier décimal ou hexadécimal. A utiliser avec précaution, et se référer à la fiche technique du ADXL345 pour la référence.

### Commandes de test de résonance

The following commands are available when a [resonance_tester config section](Config_Reference.md#resonance_tester) is enabled (also see the [measuring resonances guide](Measuring_Resonances.md)):

- `MEASURE_AXES_NOISE`: Mesure et affiche le bruit pour tous les axes de toutes les puces accélérométriques activées.
- `TEST_RESONANCES AXIS=<axis> OUTPUT=<resonances,raw_data> [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [INPUT_SHAPING=[<0:1>]]`: Runs the resonance test in all configured probe points for the requested <axis> and measures the acceleration using the accelerometer chips configured for the respective axis. <axis> can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. If `INPUT_SHAPING=0` or not set (default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.
- `SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [MAX_SMOOTHING=<max_smoothing>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command.

### Commandes de Palette 2

The following command is available when the [palette2 config section](Config_Reference.md#palette2) is enabled:

- `PALETTE_CONNECT`: Cette commande initie la connexion avec Palette 2.
- `PALETTE_DISCONNECT`: Cette commande permet de se déconnecter de Palette 2.
- `PALETTE_CLEAR`: Cette commande demande à Palette 2 de purger le filament de tous les chemins d'entrée et de sortie.
- `PALETTE_CUT` : Cette commande demande à Palette 2 de couper le filament actuellement chargé dans le noyau de jonction.
- ` PALETTE_SMART_LOAD` : cette commande initialise la séquence de chargement intelligente sur Palette 2. Le filament est chargé automatiquement en l’extrudant sur la distance calibrée sur l’appareil pour l’imprimante, et l'indique à Palette 2 une fois le chargement terminé. Cette commande revient à appuyer sur **Smart Load** directement sur l’écran Palette 2 une fois l'insertion du filament faite.

Les impressions avec Palette fonctionnent en intégrant des OCodes (Omega Codes) spéciaux dans le fichier GCode :

- `O1`...`O32`: Ces codes sont lus à partir du flux GCode, traités par ce module et transmis au dispositif Palette 2.
