# Référence des états

Ce document est une référence aux informations de status de l'imprimante dans Klipper [macros](Command_Templates.md), [display fields](Config_Reference.md#display), et via l'[API Server](API_Server.md).

Les champs de ce document sont susceptibles d'être modifiés - si vous utilisez un attribut, veillez à consulter le document [Modifications des configurations](Config_Changes.md) lors de la mise à jour du logiciel Klipper.

## angle

Les informations suivantes sont disponibles dans les objets [angle votre_nom](Config_Reference.md#angle) :

- `temperature` : la dernière lecture de température (en degrés Celsius) d'un capteur à effet Hall magnétique de type tle5012b. Cette valeur n'est disponible que si le capteur d'angle est une puce tle5012b et si des mesures sont en cours (sinon il signale `None`).

## bed_mesh

Les informations suivantes sont disponibles dans l'objet [cartographie du lit](Config_Reference.md#bed_mesh) :

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix` : informations sur la cartographie du lit actuellement active.
- `profiles` : l'ensemble des profils actuellement définis tels que configurés à l'aide de BED_MESH_PROFILE.

## bed_screws

Les informations suivantes sont disponibles dans l'objet `Config_Reference.md#bed_screws` :

- `is_active` : Renvoie True si le script de réglage des vis du lit est en cours.
- `state` : L'état du script de réglage des vis du lit. deux étaIl s'agit de l'une des chaînes suivantes : "adjust", "fine".
- `current_screw` : le numéro de la vis en cours de réglage.
- `accepted_screws` : nombre de vis qui ont été acceptées (ndt donc marquées comme réglées).

## fichier de configuration

Les informations suivantes sont disponibles dans l'objet `configfile` (cet objet est toujours disponible) :

- `settings.<section>.<option>` : Renvoie les paramétrages du fichier de configuration (ou la valeur par défaut) lors du dernier démarrage ou redémarrage du logiciel. (Tout paramètre modifié au moment de l'exécution ne sera pas reflété ici.)
- `config.<section>.<option>` : Renvoie le paramètre donné du fichier de configuration tel que lu par Klipper lors du dernier démarrage ou redémarrage du logiciel. (Tout paramètre modifié au moment de l'exécution ne sera pas reflété ici.) Toutes les valeurs sont renvoyées sous forme de chaînes.
- `save_config_pending` : renvoie vrai s'il existe des mises à jour en attente qu'une commande `SAVE_CONFIG` peut enregistrer sur le disque.
- `save_config_pending_items` : Contient les sections et les éléments qui ont été modifiées et qui peuvent être sauvegardées avec un `SAVE_CONFIG`.
- `warnings` : une liste d'avertissements concernant les options de configuration. Chaque entrée de la liste sera un dictionnaire contenant un champ `type` et `message` (les deux chaînes). Des champs supplémentaires peuvent être disponibles selon le type d'avertissement.

## display_status

Les informations suivantes sont disponibles dans l’objet `display_status` (cet objet est automatiquement disponible si une section de configuration [affichage](Config_Reference.md#display) est définie) :

- `progress` : la valeur de progression de la dernière commande G-Code `M73` (ou `virtual_sdcard.progress` si aucune commande `M73` récente n'a été reçue).
- `message` : Le message contenu dans la dernière commande G-Code `M117`.

## endstop_phase

Les informations suivantes sont disponibles dans l'objet [endstop_phase](Config_Reference.md#endstop_phase) :

- `last_home.<stepper name>.phase` : La phase du moteur pas à pas à la fin de la dernière tentative de retour à l'origine.
- `last_home.<stepper name>.phases` : Le nombre total de phases disponibles sur le moteur pas à pas.
- `last_home.<stepper name>.mcu_position` : La position (telle que suivie par le microcontrôleur) du moteur pas à pas à la fin de la dernière tentative de retour à l'origine. La position est le nombre total de pas effectués dans le sens avant moins le nombre total de pas effectués dans le sens inverse depuis le dernier redémarrage du microcontrôleur.

## exclude_object

Les informations suivantes sont disponibles dans l'objet [exclude_object](Exclude_Object.md) :


   - `objects` : Un tableau des objets connus tel que fourni par la commande `EXCLUDE_OBJECT_DEFINE`. Il s'agit des mêmes informations fournies par la commande `EXCLUDE_OBJECT VERBOSE=1`. Les champs `center` et `polygon` ne seront présents que s'ils sont fournis dans l'original `EXCLUDE_OBJECT_DEFINE`Voici un exemple JSON :

```
[
  {
    "polygon": [
      [ 156.25, 146.2511675 ],
      [ 156.25, 153.7488325 ],
      [ 163.75, 153.7488325 ],
      [ 163.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_2_COPY_0",
    "center": [ 160, 150 ]
  },
  {
    "polygon": [
      [ 146.25, 146.2511675 ],
      [ 146.25, 153.7488325 ],
      [ 153.75, 153.7488325 ],
      [ 153.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_1_COPY_0",
    "center": [ 150, 150 ]
  }
]
```

- `excluded_objects` : un tableau de chaînes répertoriant les noms des objets exclus.
- `current_object` : Le nom de l'objet en cours d'impression.

## extruder_stepper

Les informations suivantes sont disponibles pour les objets extruder_stepper (ainsi que les objets [extruder](Config_Reference.md#extruder)) :

- `pressure_advance` : la valeur actuelle de [pressure advance](Pressure_Advance.md).
- `smooth_time` : Le temps de lissage associé à la valeur de "pressure advance" courante.

## ventilateur

Les informations suivantes sont disponibles dans les objets [fan](Config_Reference.md#fan), [heater_fan nom_du_ventilateur](Config_Reference.md#heater_fan) et [controller_fan nom_du_ventilateur](Config_Reference.md#controller_fan) :

- `speed` : La vitesse du ventilateur nombre réel entre 0,0 et 1,0.
- `rpm` : La vitesse du ventilateur mesurée en rotations par minute si le ventilateur a un tachometer_pin défini (ndt : et si le ventilateur possède un tachymètre).

## filament_switch_sensor

Les informations suivantes sont disponibles dans les objets [filament_switch_sensor nom_du_détecteur](Config_Reference.md#filament_switch_sensor) :

- `enabled` : renvoie True si le détecteur de fin de filament est activé.
- `filament_detected` : renvoie True si le détecteur de fin de filament a détecté la présence d'un filament.

## filament_motion_sensor

Les informations suivantes sont disponibles dans les objets [filament_motion_sensor nom_du_detecteur](Config_Reference.md#filament_motion_sensor) :

- `enabled` : renvoie True si le détecteur de mouvement du filament est activé.
- `filament_detected` : renvoie True si le détecteur de fin de filament a détecté la présence d'un filament.

## firmware_retraction

Les informations suivantes sont disponibles dans l'objet [firmware_retraction](Config_Reference.md#firmware_retraction) :

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed` : sont les paramètres du module firmware_retraction. Ces paramètres peuvent différer du fichier de configuration si une commande `SET_RETRACTION` les modifie.

## gcode_macro

Les informations suivantes sont disponibles dans les objets [gcode_macro nom_de_la_macro](Config_Reference.md#gcode_macro) :

- `<variable>` : la valeur actuelle d'une [variable gcode_macro](Command_Templates.md#variables).

## gcode_move

Les informations suivantes sont disponibles dans l'objet `gcode_move` (cet objet est toujours disponible) :

- `gcode_position` : La position actuelle de la tête d'outil par rapport à l'origine actuelle du G-Code. C'est-à-dire des positions que l'on pourrait envoyer directement à une commande `G1`. Il est possible d'accéder aux composants x, y, z et e de cette position (par exemple, `gcode_position.x`).
- `position` : la dernière position commandée de la tête d'outil à l'aide du système de coordonnées spécifié dans le fichier de configuration. Il est possible d'accéder aux composantes x, y, z et e de cette position (par exemple, `position.x`).
- `homing_origin` : L'origine du système de coordonnées gcode (par rapport au système de coordonnées spécifié dans le fichier de configuration) à utiliser après une commande `G28`. La commande `SET_GCODE_OFFSET` peut modifier cette position. Il est possible d'accéder aux composantes x, y et z de cette position (par exemple, `homing_origin.x`).
- `vitesse` : La dernière vitesse définie dans une commande `G1` (en mm/s).
- `speed_factor` : Le « remplacement du facteur de vitesse » tel que défini par une commande `M220`. Il s'agit d'une valeur à virgule flottante. 1,0 signifie qu'il n'y a pas de dépassement et, par exemple, 2,0 double la vitesse demandée.
- `extrude_factor` : le "remplacement du facteur d'extrusion" tel que défini par une commande `M221`. Il s'agit d'une valeur à virgule flottante. 1,0 signifie qu'il n'y a pas de remplacement et, par exemple, 2,0 double le volume d'extrusion demandé.
- `absolute_coordinates` : Cela renvoie True si l'on est en mode de coordonnées absolues `G90` ou False si l'on est en mode relatif `G91`.
- `absolute_extrude` : Ceci renvoie True si l'on est en mode d'extrusion absolue `M82` ou False si l'on est en mode relatif `M83`.

## hall_filament_width_sensor

Les informations suivantes sont disponibles dans l'objet [hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor) :

- `is_active` : renvoie True si le capteur est actif.
- `Diameter` : La dernière lecture du capteur en mm.
- `Raw` : La dernière lecture brute du convertisseur AN du capteur.

## heater

Les informations suivantes sont disponibles pour les objets de type 'chauffage' tels que [extruder](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed) et [heater_generic](Config_Reference.md#heater_generic) :

- `temperature` : la dernière température indiquée (en degrés Celsius sous forme de nombre réel) pour l'élément chauffant donné.
- `target` : la température cible actuelle (en degrés Celsius sous forme de nombre réel) pour l'élément chauffant donné.
- `power` : le dernier réglage de la broche PWM (une valeur comprise entre 0,0 et 1,0) associée à l'élément chauffant.
- `can_extrude` : si l'extrudeuse est à la température minimum de fonctionnement (défini par `min_extrude_temp`), disponible uniquement pour [extruder](Config_Reference.md#extruder)

## heaters

Les informations suivantes sont disponibles dans l'objet `heaters` (cet objet est disponible si un élément chauffant est défini) :

- `available_heaters` : renvoie une liste de tous les éléments chauffants disponibles par leurs noms de section de configuration complets, par ex. `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `available_sensors` : renvoie une liste de tous les capteurs de température actuellement disponibles par leurs noms de section de configuration complets, par ex. `["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"]`.

## idle_timeout

Les informations suivantes sont disponibles dans l'objet [idle_timeout](Config_Reference.md#idle_timeout) (cet objet est toujours disponible) :

- `state` : L'état actuel de l'imprimante tel qu'il est suivi par le module idle_timeout. Il s'agit de l'une des chaînes suivantes : "Idle", "Printing", "Ready".
- `printing_time` : la durée (en secondes) pendant laquelle l'imprimante est restée dans l'état "Impression" (telle que suivie par le module idle_timeout).

## led

Les informations suivantes sont disponibles pour chaque sections `[led nom_des_leds]`, `[neopixel nom_des_leds]`, `[dotstar nom_des_leds]`, `[pca9533 nom_des_leds]` et `[pca9632 nom_des_leds]` définies dans printer.cfg :

- `color_data` : une liste de listes de couleurs contenant les valeurs RGBW pour une led de la chaîne. Chaque valeur est représentée par un réel de 0,0 à 1,0. Chaque liste de couleurs contient 4 éléments (rouge, vert, bleu, blanc) même si la LED sous-jacente prend en charge moins de canaux de couleur. Par exemple, la valeur bleue (3e élément de la liste des couleurs) du deuxième neopixel d'une chaîne peut être consultée sur `printer["neopixel <config_name>"].color_data[1][2]`.

## manual_probe

Les informations suivantes sont disponibles dans l'objet `manual_probe` :

- `is_active` : renvoie True si un script d'assistance de sondage manuel est actuellement actif.
- `z_position` : La hauteur actuelle de la buse (telle que l'imprimante la situe).
- `z_position_lower` : Valeur de la dernière tentative de détection mesurée juste en dessous de la hauteur actuelle.
- `z_position_upper` : Valeur de la dernière tentative de détection mesurée juste au dessus de la hauteur actuelle.

## mcu

Les informations suivantes sont disponibles dans les objets [mcu](Config_Reference.md#mcu) et [mcu nom_du_mcu](Config_Reference.md#mcu-my_extra_mcu) :

- `mcu_version` : la version du code Klipper remontée par le microcontrôleur.
- `mcu_build_versions` : informations sur les outils de construction utilisés pour générer le code du microcontrôleur (tel que remonté par le microcontrôleur).
- `mcu_constants.<constant_name>` : Compile les constantes de temps rapportées par le microcontrôleur. Les constantes disponibles peuvent différer entre les architectures de microcontrôleur et à chaque révision de code.
- `last_stats.<statistics_name>` : informations statistiques sur la connexion du microcontrôleur.

## motion_report

Les informations suivantes sont disponibles dans l'objet `motion_report` (cet objet est automatiquement disponible si une section de configuration 'stepper' est définie) :

- `live_position` : la position de la tête d'outil demandée interpolée à l'instant T.
- `live_velocity` : la vitesse de la tête d'outil demandée (en mm/s) à l'instant T.
- `live_extruder_velocity` : la vitesse d'extrusion demandée (en mm/s) à l'instant T.

## output_pin

Les informations suivantes sont disponibles dans les objets [output_pin nom_de_la_sortie](Config_Reference.md#output_pin) :

- `value` : la "valeur" de la broche, telle que définie par une commande `SET_PIN`.

## palette2

Les informations suivantes sont disponibles dans l'objet [palette2](Config_Reference.md#palette2) :

- `ping` : montant du dernier ping du "Palette 2" signalé en pourcentage.
- `remaining_load_length` : lors du démarrage d'une impression Palette 2, ce sera la quantité de filament à charger dans l'extrudeuse.
- `is_splicing` : Vrai lorsque la Palette 2 soude le filament.

## pause_resume

Les informations suivantes sont disponibles dans l'objet [pause_resume](Config_Reference.md#pause_resume) :

- `is_paused` : Renvoie true si une commande PAUSE a été exécutée sans RESUME correspondant.

## print_stats

Les informations suivantes sont disponibles dans l'objet `print_stats` (cet objet est automatiquement disponible si une section de configuration [virtual_sdcard](Config_Reference.md#virtual_sdcard) est définie) :

- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message` : informations estimées sur l'impression en cours lorsqu'une impression virtual_sdcard est active.
- `info.total_layer` : La valeur totale de la couche de la dernière commande `SET_PRINT_STATS_INFO TOTAL_LAYER=<value>` G-Code.
- `info.current_layer` : la valeur de la couche actuelle de la dernière commande G-Code `SET_PRINT_STATS_INFO CURRENT_LAYER=<valeur>`.

## probe

Les informations suivantes sont disponibles dans l'objet [probe](Config_Reference.md#probe) (cet objet est également disponible si une section de configuration [bltouch](Config_Reference.md#bltouch) est définie) :

- `last_query` : renvoie True si la sonde a été signalée comme "déclenchée" lors de la dernière commande QUERY_PROBE. Notez que si cela est utilisé dans une macro, en raison de l'ordre de développement du modèle, la commande QUERY_PROBE doit être exécutée avant la macro contenant cette demande.
- `last_z_result` : Renvoie la valeur du Z de la dernière commande PROBE. Notez que si cela est utilisé dans une macro, en raison de l'ordre d'expansion du modèle, la commande PROBE (ou similaire) doit être exécutée avant la macro contenant cette demande.

## quad_gantry_level

Les informations suivantes sont disponibles dans l'objet `quad_gantry_level` (cet objet est disponible si quad_gantry_level est défini) :

- `applied` : Vrai si le processus de nivellement 4 points du portique a été exécuté et terminé avec succès.

## query_endstops

Les informations suivantes sont disponibles dans l'objet `query_endstops` (cet objet est disponible si au moins une fin de course est définie) :

- `last_query["<endstop>"]` : renvoie True si l'endstop donné a été signalé comme "déclenché" (triggered) lors de la dernière commande QUERY_ENDSTOP. Notez que si cela est utilisé dans une macro, en raison de l'ordre de développement du modèle, la commande QUERY_ENDSTOP doit être exécutée avant la macro contenant cette demande.

## screws_tilt_adjust

Les informations suivantes sont disponibles dans l'objet `screws_tilt_adjust` :

- `error` : renvoie True si la commande `SCREWS_TILT_CALCULATE` la plus récente incluait le paramètre `MAX_DEVIATION` et que l'un des sondages au niveau des vis de lit dépassait la valeur `MAX_DEVIATION`.
- `résultats` : une liste des emplacements des vis de lit sondées. Chaque entrée de la liste est un dictionnaire contenant les clés suivantes :
   - `name` : le nom de la vis tel qu'il est spécifié dans le fichier de configuration.
   - `x` : la coordonnée X de la vis telle que spécifiée dans le fichier de configuration.
   - `y` : la coordonnée Y de la vis telle que spécifiée dans le fichier de configuration.
   - `z` : La hauteur Z mesurée à l'emplacement de la vis.
   - `sign` : Une chaîne spécifiant le sens de rotation à visser pour le réglage nécessaire. Soit "CW" pour le sens horaire ou "CCW" pour le sens antihoraire. La vis de base n'aura pas de clé `sign`.
   - `adjust` : le nombre de tours de vis pour ajuster la vis, donné au format "HH:MM", où "HH" est le nombre de tours de vis complets et "MM" est le nombre de "minutes d'un cadran d'horloge" représentant un tour de vis partiel. (Par exemple, "01:15" signifierait de tourner la vis d'un tour et quart.)

## servo

Les informations suivantes sont disponibles dans les objets [servo some_name](Config_Reference.md#servo) :

- `printer["servo <config_name>"].value` : le dernier réglage de la broche PWM (une valeur comprise entre 0,0 et 1,0) associée au servo.

## system_stats

Les informations suivantes sont disponibles dans l'objet `system_stats` (cet objet est toujours disponible) :

- `sysload`, `cputime`, `memavail` : informations sur le système d'exploitation hôte et la charge du processus.

## Capteurs de température

Les informations suivantes sont disponibles dans

objets [BME280 nom_du_capteur](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d nom_du_capteur](Config_Reference.md#htu21d-sensor), [lm75 nom_du_capteur](Config_Reference.md#lm75-temperature-sensor) et [temperature_host nom_du_capteur](Config_Reference.md#host-temperature-sensor) :

- `temperature` : La dernière température lue par le capteur.
- `humidité`, `pression`, `gaz` : les dernières valeurs lues par le capteur (uniquement sur les capteurs bme280, htu21d et lm75).

## temperature_fan

Les informations suivantes sont disponibles dans les objets [temperature_fan nom_du_ventilateur](Config_Reference.md#temperature_fan) :

- `temperature` : La dernière température lue par le capteur.
- `target` : La température cible pour le ventilateur.

## temperature_sensor

Les informations suivantes sont disponibles dans les objets [temperature_sensor nom_du_capteur](Config_Reference.md#temperature_sensor) :

- `temperature` : La dernière température lue par le capteur.
- `measured_min_temp`, `measured_max_temp` : la température la plus basse et la plus élevée observées par le capteur depuis le dernier redémarrage de Klipper.

## Pilotes TMC

Les informations suivantes sont disponibles dans les objets [pilote pas à pas TMC](Config_Reference.md#tmc-stepper-driver-configuration) (par exemple, `[tmc2208 stepper_x]`) :

- `mcu_phase_offset` : la position du moteur pas à pas du microcontrôleur correspondant à la phase "zéro" du pilote. Ce champ peut être nul si le déphasage n'est pas connu.
- `phase_offset_position` : La "position commandée" correspondant à la phase "zéro" du driver. Ce champ peut être nul si le déphasage n'est pas connu.
- `drv_status` : les résultats de la dernière requête d'état du pilote. (Seuls les champs non nuls sont signalés.) Ce champ sera nul si le pilote n'est pas activé (et n'est donc pas interrogé périodiquement).
- `run_current` : le courant de fonctionnement actuellement défini.
- `hold_current` : Le courant de maintien actuellement défini.

## toolhead

Les informations suivantes sont disponibles dans l'objet `toolhead` (cet objet est toujours disponible) :

- `position` : la dernière position commandée de la tête d'outil par rapport au système de coordonnées spécifié dans le fichier de configuration. Il est possible d'accéder aux composantes x, y, z et e de cette position (par exemple, `position.x`).
- `extruder` : le nom de l'extrudeur actuellement actif. Par exemple, dans une macro, on pourrait utiliser `printer[printer.toolhead.extruder].target` pour obtenir la température cible de l'extrudeuse actuelle.
- `homed_axes` : les axes considérés comme étant dans un état "à l'origine". Il s'agit d'une chaîne contenant un ou plusieurs "x", "y", "z".
- `axis_minimum`, `axis_maximum` : les limites de déplacement de l'axe (mm) après la mise à l'origine. Il est possible d'accéder aux composantes x, y, z de cette valeur limite (par exemple, `axis_minimum.x`, `axis_maximum.z`).
- Pour les imprimantes Delta, le `cone_start_z` est la hauteur z maximale au rayon maximal (`printer.toolhead.cone_start_z`).
- `max_velocity`, `max_accel`, `max_accel_to_decel`, `square_corner_velocity` : les limites d'impression actuelles en vigueur. Cela peut différer des paramètres du fichier de configuration si une commande `SET_VELOCITY_LIMIT` (ou `M204`) les a modifiées au moment de l'exécution.
- `stalls` : Le nombre total de fois (depuis le dernier redémarrage) où l'imprimante a dû être mise en pause parce que la tête d'outil s'est déplacée plus vite que les mouvements ne pouvaient être lus à partir de l'entrée G-Code.

## dual_carriage

Les informations suivantes sont disponibles dans [dual_carriage](Config_Reference.md#dual_carriage) sur une imprimante de type hybrid_corexy ou hybrid_corexz

- `mode` : Le mode actuel. Les valeurs possibles sont : "FULL_CONTROL"
- `active_carriage` : le chariot actif actuel. Les valeurs possibles sont : "CARRIAGE_0", "CARRIAGE_1"

## virtual_sdcard

Les informations suivantes sont disponibles dans l'objet [virtual_sdcard](Config_Reference.md#virtual_sdcard) :

- `is_active` : renvoie True si une impression à partir d'un fichier est actuellement active.
- `progress` : une estimation de la progression de l'impression actuelle (basée sur la taille et la position du fichier).
- `file_path` : un chemin d'accès complet au fichier actuellement chargé.
- `file_position` : la position actuelle (en octets) d'une impression active.
- `file_size` : taille (en octets) du fichier actuellement chargé.

## webhooks

Les informations suivantes sont disponibles dans l'objet `webhooks` (cet objet est toujours disponible) :

- `state` : renvoie une chaîne indiquant l'état actuel de Klipper. Les valeurs possibles sont : "ready", "startup", "shutdown", "error".
- `state_message` : une chaîne donnant un contexte supplémentaire sur l'état actuel de Klipper.

## z_thermal_adjust

Les informations suivantes sont disponibles dans l'objet `z_thermal_adjust` (cet objet est disponible si [z_thermal_adjust](Config_Reference.md#z_thermal_adjust) est défini).

- `enabled` : renvoie True si le réglage est activé.
- `température` : Température actuelle (lissée) du capteur défini. (en degrés Centigrades)
- `measured_min_temp` : température minimale mesurée. (en degrés Centigrades)
- `measured_max_temp` : température maximale mesurée. (En degrés Centigrades)
- `current_z_adjust` : dernier ajustement Z calculé (en mm).
- `z_adjust_ref_temperature` : Température de référence actuelle utilisée pour le calcul de Z `current_z_adjust` (En degrés Centigrades).

## z_tilt

Les informations suivantes sont disponibles dans l'objet `z_tilt` (cet objet est disponible si z_tilt est défini) :

- `applied` : Vrai si le processus de mise à niveau z-tilt a été exécuté et terminé avec succès.
