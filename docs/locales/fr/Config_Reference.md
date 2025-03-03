# Référence de configuration

Ce document est la référence des options disponibles dans le fichier de configuration de Klipper.

Les descriptions de ce document sont formatées de manière à ce qu'il soit possible de les copier-coller dans un fichier de configuration d'imprimante. Consultez le [document d'installation](Installation.md) pour obtenir des informations sur la configuration de Klipper et le choix d'un fichier de configuration initial.

## Configuration du microcontrôleur

### Format du nom des broches du microcontrôleur

De nombreuses options de configuration nécessitent le nom d'une broche du micro-contrôleur. Klipper utilise les noms matériel pour ces broches - par exemple `PA4`.

Les noms des broches peuvent être précédés de `!` pour indiquer qu'une polarité inverse doit être utilisée (par exemple, déclencher sur le niveau bas au lieu du niveau haut).

Les broches d'entrée peuvent être précédées de `^` pour indiquer qu'une résistance pull-up matérielle doit être activée pour cette broche. Si le micro-contrôleur supporte les résistances pull-down, une broche d'entrée peut également être précédée de `~`.

Notez que certaines sections de configuration peuvent "créer" des broches supplémentaires. Lorsque cela se produit, la section de configuration définissant ces broches doit être répertoriée dans le fichier de configuration avant toute section utilisant celles-ci.

### [mcu|

Configuration du microcontrôleur primaire.

```
[mcu]
serial :
#    Le port série à connecter à l'unité MCU. Si vous n'êtes pas sûr (ou s'il
#    change) consultez la section "Où est mon port série ?" de la FAQ.
#    Ce paramètre doit être fourni lors de l'utilisation d'un port série.
#baud : 250000
#    Le débit en bauds à utiliser. La valeur par défaut est 250000.
#canbus_uuid :
#    Si vous utilisez un dispositif connecté à un bus CAN, ceci définit l'identifiant
#    unique de la puce à laquelle se connecter. Cette valeur doit être fournie lorsque l'on utilise
#    le bus CAN pour la communication.
#canbus_interface :
#    Si vous utilisez un dispositif connecté à un bus CAN, ceci définit l'interface réseau CAN
#    à utiliser. La valeur par défaut est 'can0'.
#restart_method :
#    Ceci contrôle le mécanisme que l'hôte utilisera pour réinitialiser le microcontrôleur.
#    Les choix sont 'arduino', 'cheetah', 'rpi_usb', et 'command'. La méthode 'arduino'
#    (basculer DTR) est courante sur les cartes et clones Arduino.
#    La méthode 'cheetah' est une méthode particulière nécessaire pour certaines cartes
#    Fysetc Cheetah. La méthode 'rpi_usb' est utile sur les cartes Raspberry Pi avec des
#    micro-contrôleurs alimentés par USB - elle désactive brièvement l'alimentation de tous
#    les ports USB pour effectuer une réinitialisation du microcontrôleur.
#    La méthode 'command' implique l'envoi d'une commande Klipper au microcontrôleur
#    afin qu'il puisse # se réinitialiser.
#    La valeur par défaut est 'arduino' si le micro-contrôleur communique via un port série,
#    'command' sinon.
```

### [mcu my_extra_mcu]

Microcontrôleurs supplémentaires (on peut définir un nombre quelconque de sections avec un préfixe "mcu"). Les microcontrôleurs supplémentaires introduisent des broches additionnelles pouvant être configurées comme des éléments de chauffage, des pilotes moteurs, des ventilateurs, etc. Par exemple, si une section "[mcu extra_mcu]" est ajoutée, des broches telles que "extra_mcu:ar9" pourront être utilisées ailleurs dans la configuration (où "ar9" est un nom de broche matérielle ou un nom d'alias sur le mcu donné).

```
[mcu my_extra_mcu]
#    Voir la section "mcu" pour les paramètres de configuration.
```

## Paramètres cinématiques courants

### [printer]

La section imprimante contrôle les paramètres de haut niveau de l'imprimante.

```
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid_corexy, hybrid_corexz, rotary_delta, delta,
#   deltesian, polar, winch, or none. This parameter must be specified.
max_velocity:
#   Maximum velocity (in mm/s) of the toolhead (relative to the
#   print). This parameter must be specified.
max_accel:
#   Maximum acceleration (in mm/s^2) of the toolhead (relative to the
#   print). Although this parameter is described as a "maximum"
#   acceleration, in practice most moves that accelerate or decelerate
#   will do so at the rate specified here. The value specified here
#   may be changed at runtime using the SET_VELOCITY_LIMIT command.
#   This parameter must be specified.
#minimum_cruise_ratio: 0.5
#   Most moves will accelerate to a cruising speed, travel at that
#   cruising speed, and then decelerate. However, some moves that
#   travel a short distance could nominally accelerate and then
#   immediately decelerate. This option reduces the top speed of these
#   moves to ensure there is always a minimum distance traveled at a
#   cruising speed. That is, it enforces a minimum distance traveled
#   at cruising speed relative to the total distance traveled. It is
#   intended to reduce the top speed of short zigzag moves (and thus
#   reduce printer vibration from these moves). For example, a
#   minimum_cruise_ratio of 0.5 would ensure that a standalone 1.5mm
#   move would have a minimum cruising distance of 0.75mm. Specify a
#   ratio of 0.0 to disable this feature (there would be no minimum
#   cruising distance enforced between acceleration and deceleration).
#   The value specified here may be changed at runtime using the
#   SET_VELOCITY_LIMIT command. The default is 0.5.
#square_corner_velocity: 5.0
#   The maximum velocity (in mm/s) that the toolhead may travel a 90
#   degree corner at. A non-zero value can reduce changes in extruder
#   flow rates by enabling instantaneous velocity changes of the
#   toolhead during cornering. This value configures the internal
#   centripetal velocity cornering algorithm; corners with angles
#   larger than 90 degrees will have a higher cornering velocity while
#   corners with angles less than 90 degrees will have a lower
#   cornering velocity. If this is set to zero then the toolhead will
#   decelerate to zero at each corner. The value specified here may be
#   changed at runtime using the SET_VELOCITY_LIMIT command. The
#   default is 5mm/s.
#max_accel_to_decel:
#   This parameter is deprecated and should no longer be used.
```

### [stepper]

Définitions des pilotes de moteurs pas à pas. Différents types d'imprimantes (comme spécifié par l'option "kinematics" dans la section [printer]) requièrent différents noms pour le moteur pas à pas (par exemple, `stepper_x` vs `stepper_a`). Ci-dessous, vous trouverez les définitions les plus courantes.

Voir le document [distance de rotation](Rotation_Distance.md) pour des informations sur le calcul du paramètre `rotation_distance`. Voir le document [Multi-MCU homing](Multi_MCU_Homing.md) pour des informations sur l'utilisation de plusieurs microcontrôleurs lors d'une mise à l'origine.

```
[stepper_x]
step_pin:
#    Broche GPIO du moteur (déclenchée à l'état haut). Ce paramètre doit être fourni.
dir_pin:
#    Broche GPIO de direction (le niveau haut indique une direction positive). Ce paramètre
#    doit être fourni.
enable_pin:
#    Broche d'activation (par défaut, enable est haut ; utilisez ! pour indiquer enable
#    bas). Si ce paramètre n'est pas fourni, le pilote du moteur pas à pas doit toujours
#    être activé.
rotation_distance:
#    Distance (en mm) parcourue par l'axe lors d'une rotation complète du moteur pas à pas
#    (ou de l'engrenage final si le rapport de vitesse est spécifié).
#    Ce paramètre doit être fourni.
microsteps:
#    Le nombre de micropas utilisés par le pilote du moteur pas à pas. Ce paramètre
#    doit être fourni.
#full_steps_per_rotation: 200
#    Nombre de pas complets pour une rotation complète du moteur pas à pas.
#    Réglez ce paramètre sur 200 pour un moteur pas à pas de 1,8 degré ou sur 400 pour
#    un moteur de 0,9 degré. La valeur par défaut est 200.
#gear_ratio:
#    Le rapport d'engrenage si le moteur pas à pas est relié à l'axe via une démultiplication.
#    Par exemple, on peut spécifier "5:1" si un réducteur de 5 pour 1 est utilisé.
#    Si l'axe a plusieurs démultiplications, on peut spécifier une liste de rapports séparés par
#    des virgules (par exemple, "57:11, 2:1"). Si un rapport de vitesse est spécifié, alors
#    rotation_distance spécifie la distance parcourue par l'axe pour une rotation complète
#    de l'engrenage final.
#    La valeur par défaut est de ne pas utiliser de rapport de vitesse.
#step_pulse_duration:
#    Le temps minimum entre le front du signal d'impulsion de pas et le front du signal "unstep" suivant.
#    Ceci est également utilisé pour définir le temps minimum entre une impulsion de pas et un signal
#    de changement de direction.
#    La valeur par défaut est 0,000000100 (100ns) pour les pilotes TMC configurés en mode UART ou SPI,
#    sinon la valeur par défaut est de 0,000002 (2us) pour tous les autres pilotes.
endstop_pin:
#    Broche de détection de l'interrupteur de fin de course. Si cette broche est sur un mcu différent de
#    celui du moteur pas à pas, cela active le "multi-mcu". Ce paramètre doit être fourni pour les moteurs
#    pas à pas X, Y, et Z sur les imprimantes de style cartésien.
#position_min: 0
#    Distance minimale valide (en mm) vers laquelle l'utilisateur peut commander le moteur pas à pas.
#    La valeur par défaut est 0mm.
position_endstop:
#    Emplacement de la butée (en mm). Ce paramètre doit être fourni pour les moteurs X, Y et Z
#    des imprimantes de style cartésien.
position_max:
#    Distance maximale valide (en mm) vers laquelle l'utilisateur peut ordonner au moteur de se déplacer.
#    Ce paramètre doit être fourni pour les moteurs X, Y, et Z des imprimantes de type cartésien.
#homing_speed: 5.0
#    Vitesse maximale (en mm/s) du moteur pas à pas lors de la mise à l'origine. La valeur par défaut
#    est de 5mm/s.
#homing_retract_dist: 5.0
#    Distance de recul (en mm) avant le retour au point d'origine une seconde fois.
#    Réglez cette valeur à zéro pour désactiver le second retour à l'origine. La valeur par défaut
#    est de 5 mm.
#homing_retract_speed:
#    Vitesse à utiliser pour le mouvement de recul après le retour à l'origine au cas où elle soit
#    différente de la vitesse de mise à l'origine qui est la valeur par défaut de ce paramètre.
#second_homing_speed:
#    Vitesse (en mm/s) du moteur pas à pas lors du second retour à l'origine.
#    La valeur par défaut est homing_speed/2.
#homing_positive_dir:
#    Si la valeur est vraie (true), le retour au point d'origine entraînera le déplacement de la commande pas
#    à pas dans une direction positive (en s'éloignant de zéro) ; si elle est fausse (false), le retour à l'origine
#    se fera vers zéro. Il est préférable d'utiliser la valeur par défaut que de spécifier ce paramètre. La valeur
#    par défaut est true si position_endstop est proche de position_max et false si elle est proche de
#    la position_min.
```

### Cinématique cartésienne

Voir [example-cartesian.cfg](../config/example-cartesian.cfg) pour un exemple de fichier de configuration de cinématique cartésienne.

Seuls les paramètres spécifiques aux imprimantes cartésiennes sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: cartesian
max_z_velocity:
#    Ceci définit la vitesse maximale (en mm/s) du mouvement le long de l'axe z
#    Ce paramètre peut être utilisé pour limiter la vitesse maximale du moteur pas à pas z.
#    La valeur par défaut est l'utilisation de max_velocity pour
#    max_z_velocity.
max_z_accel:
#    Ce paramètre définit l'accélération maximale (en mm/s^2) du mouvement sur l'axe z.
#    Cela limite l'accélération du moteur pas à pas z. La valeur par défaut est
#    d'utiliser max_accel pour max_z_accel.

#    La section stepper_x est utilisée pour décrire le moteur pas à pas contrôlant
#    l'axe X dans un robot cartésien.
[stepper_x]

#    La section stepper_y est utilisée pour décrire le moteur pas à pas contrôlant
#    l'axe Y d'un robot cartésien.
[stepper_y]

#    La section stepper_z est utilisée pour décrire le moteur pas à pas contrôlant
#    l'axe Z d'un robot cartésien.
[stepper_z]
```

### Cinématique Delta linéaire

Voir [example-delta.cfg](../config/example-delta.cfg) pour un exemple de fichier de configuration de cinématique delta linéaire. Voir le [guide de calibration delta](Delta_Calibrate.md) pour des informations sur la calibration.

Seuls les paramètres spécifiques aux imprimantes delta linéaires sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: delta
max_z_velocity:
#    Pour les imprimantes delta, cela limite la vitesse maximale (en mm/s) des
#    mouvements de l'axe z. Ce paramètre peut être utilisé pour réduire la
#    vitesse maximale des déplacements vers le haut/bas (nécessitent une vitesse
#    de pas plus élevée que les autres mouvements sur une imprimante delta). La
#    valeur par défaut est d'utiliser max_velocity pour max_z_velocity.
#max_z_accel:
#    Ceci définit l'accélération maximale (en mm/s^2) du mouvement le long de l'axe z.
#    Ce paramètre peut être utile si l'imprimante peut atteindre une plus grande
#    accélération sur les mouvements XY que sur les mouvements Z (par exemple, lors
#    de l'utilisation de la compensation de résonance).
#    La valeur par défaut est d'utiliser max_accel pour max_z_accel.
#minimum_z_position: 0
#    Position Z minimale à laquelle l'utilisateur peut ordonner à la tête de se déplacer.
#    La valeur par défaut est 0.
delta_radius:
#    Rayon (en mm) du cercle horizontal formé par les trois colonnes d'axe linéaire.
#    Ce paramètre peut également être calculé comme suit :
#        delta_radius = smooth_rod_offset - effector_offset - carriage_offset.
#    Ce paramètre doit être fourni.
#print_radius:
#    Le rayon (en mm) des coordonnées XY valides de la tête d'extrusion. On peut utiliser
#    ce paramètre pour personnaliser la vérification de la plage de mouvements de la tête.
#    Si une grande valeur est spécifiée ici, il peut être possible de faire entrer la tête en collision
#    avec une colonne. La valeur par défaut est d'utiliser delta_radius pour print_radius (ce qui
#    empêchera normalement une collision avec une colonne).

#    La section stepper_a décrit le moteur pas à pas contrôlant la colonne avant gauche (à 210
#    degrés). Cette section contrôle également les paramètres de la mise à l'origine
#    (homing_speed, homing_retract_dist) pour toutes les colonnes.
[stepper_a]
position_endstop:
#    Distance (en mm) entre la buse et le lit lorsque la buse se trouve au centre de la zone de
#    construction et que la fin de course se déclenche. Ce paramètre doit être fourni pour le
#    stepper_a ; pour les stepper_b et stepper_c, ce paramètre prend par défaut la valeur
#    spécifiée pour stepper_a.
arm_length:
#    Longueur (en mm) du bras reliant cette colonne à la tête d'impression.
#    Ce paramètre doit être fourni pour stepper_a ; pour stepper_b et stepper_c, ce paramètre
#    prend par défaut la valeur spécifiée pour stepper_a.
#angle:
#    Cette option spécifie l'angle (en degrés) où se trouve positionnée la colonne.
#    La valeur par défaut est 210 pour stepper_a, 330 pour stepper_b, et 90
#    pour stepper_c.

#    La section stepper_b décrit le moteur pas à pas contrôlant la colonne avant droite (à 330 degrés).
[stepper_b]

#    La section stepper_c décrit le moteur pas à pas contrôlant la colonne arrière droite (à 90 degrés).
[stepper_c]

#    La section delta_calibrate active une commande G-code étendue DELTA_CALIBRATE permettant
#    de calibrer la position des interrupteurs de fin de course ainsi que les angles des colonnes.
[delta_calibrate]
radius:
#    Rayon (en mm) de la zone palpable. Il s'agit du rayon des coordonnées de la buse à sonder ; si
#    vous utilisez un palpeur automatique avec un décalage XY, choisissez un rayon suffisamment
#    petit pour que la sonde reste toujours au-dessus du lit.
#    Ce paramètre doit être fourni.
#speed: 50
#    La vitesse (en mm/s) des mouvements sans palpage pendant l'étalonnage.
#    La valeur par défaut est 50.
#horizontal_move_z: 5
#    La hauteur (en mm) à laquelle la tête doit être relevée pour se déplacer
#    juste avant de lancer une opération de palpage. La valeur par défaut est 5.
```

### Cinématique deltesienne

Voir [example-deltesian.cfg](../config/example-deltesian.cfg) pour un exemple de fichier de configuration de cinématique deltesienne.

Seuls les paramètres spécifiques aux imprimantes deltesiennes sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: deltesian
max_z_velocity:
# Pour les imprimantes deltésiennes, cela limite la vitesse maximale (en mm/s) de
# déplacement avec le mouvement de l'axe z. Ce réglage peut être utilisé pour réduire la
# vitesse maximale des mouvements vers le haut/vers le bas (qui nécessitent un taux de pas plus élevé
# que les autres mouvements sur une imprimante deltésienne). La valeur par défaut est d'utiliser
# max_velocity pour max_z_velocity.
#max_z_accel:
# Ceci définit l'accélération maximale (en mm/s²) du mouvement le long
# l'axe z. Ce paramètre peut être utile si l'imprimante peut atteindre des
# accélération sur les mouvements XY par rapport aux mouvements Z (par exemple, lors de l'utilisation du shaper d'entrée).
# La valeur par défaut est d'utiliser max_accel pour max_z_accel.
#minimum_z_position: 0
# La position Z minimale que l'utilisateur peut commander à la tête de se déplacer
# pour. La valeur par défaut est 0.
#min_angle: 5
# Ceci représente l'angle minimum (en degrés) par rapport à l'horizontale
# que les bras deltésiens sont autorisés à atteindre. Ce paramètre est
# destiné à empêcher les bras de devenir complètement horizontaux,
# qui risquerait d'inverser accidentellement l'axe XZ. La valeur par défaut est 5.
#print_width:
# La distance (en mm) des coordonnées X valides de la tête d'outil. On peut utiliser
# ce paramètre pour personnaliser la vérification de la plage des mouvements de la tête d'outil. Si
# une grande valeur est spécifiée ici alors il peut être possible de commander
# la tête d'outil en collision avec une tour. Ce paramètre généralement
# correspond à la largeur du lit (en mm).
#slow_ratio: 3
# Le rapport utilisé pour limiter la vitesse et l'accélération lors des mouvements près de la
# extrêmes de l'axe X. Si distance verticale divisée par horizontale
# la distance dépasse la valeur de slow_ratio, puis la vitesse et
# les accélérations sont limitées à la moitié de leurs valeurs nominales. Si vertical
# la distance divisée par la distance horizontale dépasse le double de la valeur de
# le slow_ratio, puis la vitesse et l'accélération sont limitées à un
# quart de leurs valeurs nominales. La valeur par défaut est 3.

# La section stepper_left est utilisée pour décrire le stepper contrôlant
# la tour de gauche. Cette section contrôle également les paramètres de prise d'origine
# (homing_speed, homing_retract_dist) pour toutes les tours.
[stepper_left]
position_endstop:
# Distance (en mm) entre la buse et le lit lorsque la buse est
# au centre de la zone de construction et les butées sont déclenchées. Ce
# le paramètre doit être fourni pour stepper_left; stepper_right prend la valeur de stepper_left par défaut.
arm_length:
# Longueur (en mm) de la tige diagonale qui relie le chariot de la tour au
# la tête d'impression. Ce paramètre doit être fourni pour stepper_left; pour
# stepper_right, ce paramètre prend par défaut la valeur spécifiée pour
# stepper_left.
arm_x_length:
# Distance horizontale entre la tête d'impression et la tour lorsque l'imprimante est mise à l'origine. Ce paramètre doit être fourni pour stepper_left ;
# pour stepper_right, ce paramètre prend par défaut la valeur spécifiée pour stepper_left.

# La section stepper_right est utilisée pour décrire le stepper contrôlant le
# tour de droite.
[stepper_right]

# La section stepper_y est utilisée pour décrire le stepper contrôlant
# l'axe Y dans un robot deltésien.
[stepper_y]
```

### Cinématique CoreXY

Voir [example-corexy.cfg](../config/example-corexy.cfg) pour un exemple de fichier cinématique corexy (et h-bot).

Seuls les paramètres spécifiques aux imprimantes corexy sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics : corexy
max_z_velocity :
#    Ceci définit la vitesse maximale (en mm/s) du mouvement le long de l'axe z
#    Ce paramètre peut être utilisé pour limiter la vitesse maximale du moteur pas à pas z.
#    La valeur par défaut est l'utilisation de max_velocity pour max_z_velocity.
max_z_accel :
#    Ce paramètre définit l'accélération maximale (en mm/s^2) du mouvement sur l'axe z.
#    Cela limite l'accélération du moteur pas à pas z. La valeur par défaut est
#    d'utiliser max_accel pour max_z_accel.

#    La section stepper_x est utilisée pour décrire l'axe X ainsi que le moteur pas à pas
#    contrôlant le mouvement X+Y.
[stepper_x]

#    La section stepper_y est utilisée pour décrire l'axe Y ainsi que le moteur pas à pas
#    contrôlant le mouvement X-Y.
[stepper_y]

#    La section stepper_z est utilisée pour décrire le moteur pas à pas contrôlant l'axe Z.
[stepper_z]
```

### Cinématique CoreXZ

Voir [example-corexz.cfg](../config/example-corexz.cfg) pour un exemple de fichier de configuration de cinématique corexz.

Seuls les paramètres spécifiques aux imprimantes corexz sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: corexz
max_z_velocity:
#    Ceci définit la vitesse maximale (en mm/s) du mouvement le long de l'axe z.
#    La valeur par défaut est d'utiliser max_velocity pour max_z_velocity.
max_z_accel:
#    Ceci définit l'accélération maximale (en mm/s^2) du mouvement le long de l'axe z.
#    La valeur par défaut est d'utiliser max_accel pour max_z_accel.

#    La section stepper_x est utilisée pour décrire l'axe X ainsi que le moteur pas à pas
#    contrôlant le mouvement X+Z.
[stepper_x]

#    La section stepper_y est utilisée pour décrire le moteur pas à pas contrôlant l'axe Y.
[stepper_y]

#    La section stepper_z est utilisée pour décrire l'axe Z ainsi que le moteur pas à pas
#    contrôlant le mouvement X-Z.
[stepper_z]
```

### Cinématique Hybride-CoreXY

Voir [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg) pour un exemple de fichier de configuration de cinématique hybride corexy.

Cette cinématique est également connue sous le nom de cinématique Markforged.

Seuls les paramètres spécifiques aux imprimantes hybrides corexy sont décrits ici ; voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: hybrid_corexy
max_z_velocity:
#    Ceci définit la vitesse maximale (en mm/s) du mouvement le long de l'axe z
#    La valeur par défaut est d'utiliser max_velocity pour max_z_velocity.
max_z_acce :
#    Ceci définit l'accélération maximale (en mm/s^2) du mouvement le long de l'axe z.
#    La valeur par défaut est d'utiliser max_accel pour max_z_accel.

#    La section stepper_x est utilisée pour décrire l'axe X ainsi que le moteur pas à pas
#    contrôlant le mouvement X-Y.
[stepper_x]

#    La section stepper_y est utilisée pour décrire le moteur pas à pas contrôlant
#    l'axe Y.

[stepper_y]

#    La section stepper_z est utilisée pour décrire le moteur pas à pas contrôlant
#    l'axe Z.
[stepper_z]
```

### Cinématique Hybride-CoreXZ

Voir [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg) pour un exemple de fichier de configuration de cinématique hybride corexz.

Cette cinématique est également connue sous le nom de cinématique Markforged.

Seuls les paramètres spécifiques aux imprimantes hybrides corexy sont décrits ici ; voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: hybrid_corexz
max_z_velocity:
#    Ceci définit la vitesse maximale (en mm/s) du mouvement le long de l'axe z
#    La valeur par défaut est d'utiliser max_velocity pour max_z_velocity.
max_z_accel:
#    Ceci définit l'accélération maximale (en mm/s^2) du mouvement le long de
#    l'axe z. La valeur par défaut est d'utiliser max_accel pour max_z_accel.

#    La section stepper_x est utilisée pour décrire l'axe X ainsi que le moteur pas à pas
#    contrôlant le mouvement X-Z.
[stepper_x]

#    La section stepper_y est utilisée pour décrire le moteur pas à pas contrôlant
#    l'axe Y.
[stepper_y]

#    La section stepper_z est utilisée pour décrire le moteur pas à pas contrôlant
#    l'axe Z.
[stepper_z]
```

### Cinématique polaire

Voir [example-polar.cfg](../config/example-polar.cfg) pour un exemple de fichier de configuration de cinématique polaire.

Seuls les paramètres spécifiques aux imprimantes polaires sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

LA CINÉMATIQUE POLAIRE EST UN TRAVAIL EN COURS. Les déplacements autour de la position 0, 0 sont connus pour ne pas fonctionner correctement.

```
[printer]
kinematics: polar
max_z_velocity:
#    Ceci définit la vitesse maximale (en mm/s) du mouvement le long de l'axe z
#    Ce paramètre peut être utilisé pour limiter la vitesse maximale du moteur z.
#    La valeur par défaut est d'utiliser max_velocity pour max_z_velocity.
max_z_accel:
#    Ce paramètre définit l'accélération maximale (en mm/s^2) du mouvement sur l'axe z.
#    Cela limite l'accélération du moteur pas à pas z. La valeur par défaut est d'utiliser
#    max_accel pour max_z_accel.

#    La section stepper_bed est utilisée pour décrire le moteur pas à pas contrôlant
#    le lit.
[stepper_bed]
gear_ratio:
#    Un rapport de vitesse doit être spécifié et la distance de rotation ne peut pas être
#    spécifiée. Par exemple, si le lit est équipé d'une poulie à 80 dents entraînée par un
#    moteur dont l'axe est muni d'une poulie à 16 dents, il faut spécifier le rapport
#    d'engrenage de "80:16". Ce paramètre doit être fourni.

#    La section stepper_arm est utilisée pour décrire le moteur pas à pas contrôlant
#    le chariot sur le bras.
[stepper_arm]

#    La section stepper_z permet de décrire le moteur pas à pas contrôlant l'axe Z.
[stepper_z]
```

### Cinématique rotative delta

Voir [example-rotary-delta.cfg](../config/example-rotary-delta.cfg) pour un exemple de fichier de configuration de cinématique rotative delta.

Seuls les paramètres spécifiques aux imprimantes rotatives delta sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

LA CINÉMATIQUE ROTATIVE DELTA EST UN TRAVAIL EN COURS. Les mouvements d'orientation peuvent dépasser le temps imparti et certains contrôles de limites ne sont pas implémentés.

```
[printer]
kinematics: rotary_delta
max_z_velocity:
#    Pour les imprimantes delta, ceci limite la vitesse maximale (en mm/s) des déplacements avec
#    mouvement de l'axe z. Ce paramètre peut être utilisé pour réduire la vitesse maximale des
#    mouvements de montée/descente (nécessitant un taux de pas plus élevé que les autres mouvements
#    sur une imprimante delta). La valeur par défaut est d'utiliser max_velocity pour max_z_velocity.
#minimum_z_position: 0
#    La position Z minimale à laquelle l'utilisateur peut ordonner à la tête de se déplacer.
#    La valeur par défaut est 0.
shoulder_radius:
#    Rayon (en mm) du cercle horizontal formé par les trois articulations de l'effecteur, moins le rayon
#    du cercle formé par l'articulation de l'effecteur.
#    Ce paramètre peut également être calculé comme suit
#       shoulder_radius = (delta_f - delta_e) / sqrt(12)
#    Ce paramètre doit être fourni.
shoulder_height:
#    Distance (en mm) des joints de l'effecteur par rapport au lit, moins la hauteur de la tête de l'outil
#    sur l'effecteur. Ce paramètre doit être fourni.

#    La section stepper_a décrit le moteur pas à pas contrôlant le bras arrière droit (à 30 degrés).
#    Cette section contrôle également les paramètres de la mise à l'origine (homing_speed,
#    homing_retract_dist) pour tous les bras.
[stepper_a]
gear_ratio:
#    Un rapport de vitesse doit être spécifié et la rotation_distance ne peut pas être spécifiée.
#    Par exemple, si le bras a une poulie de 80 dents entraînée par une poulie de 16 dents, à son
#    tour reliée à une poulie de 60 dents entraînée par un moteur dont l'arbre est muni d'une poulie
#    à 16 dents, alors on spécifierait un rapport de vitesse de "80:16, 60:16".
#    Ce paramètre doit être fourni.
position_endstop:
#    Distance (en mm) entre la buse et le lit lorsque la buse se trouve au centre de la zone de construction
#    et que la butée se déclenche. Ce paramètre doit être fourni pour le stepper_a ; pour le stepper_b et
#    le stepper_c, ce paramètre prend par défaut la valeur spécifiée pour stepper_a.
upper_arm_length:
#    Longueur (en mm) du bras reliant l'"articulation de l'effecteur" à l'"articulation du coude".
#    Ce paramètre doit être fourni pour stepper_a ; pour stepper_b et stepper_c, ce paramètre prend par
#    défaut la valeur spécifiée pour stepper_a.
lower_arm_length:
#    Longueur (en mm) du bras reliant l'"articulation du coude" à l'"articulation de l'effecteur".
#    Ce paramètre doit être fourni pour stepper_a ; pour stepper_b et stepper_c, ce paramètre prend
#    par défaut la valeur spécifiée pour stepper_a.
#angle:
#    Cette option spécifie l'angle (en degrés) auquel se trouve le bras.
#    La valeur par défaut est 30 pour stepper_a, 150 pour stepper_b et 270 pour stepper_c.

#    La section stepper_b décrit le moteur pas à pas contrôlant le bras arrière gauche (à 150 degrés).
[stepper_b]

#    La section stepper_c décrit le moteur pas à pas contrôlant le bras avant (à 270 degrés).
[stepper_c]

#    La section delta_calibrate active une commande G-code étendue DELTA_CALIBRATE permettant
#    de calibrer les positions de la butée de l'effecteur.
[delta_calibrate]
radius:
#    Rayon (en mm) de la zone pouvant être palpée. Il s'agit du rayon des coordonnées de palpage
#    de la buse; si vous utilisez un palpeur automatique avec un décalage XY, choisissez un rayon
#    suffisamment petit pour que la sonde s'adapte toujours au lit. Ce paramètre doit être fourni.
#speed: 50
#    La vitesse (en mm/s) des mouvements sans palpage pendant l'étalonnage.
#    La valeur par défaut est 50.
#horizontal_move_z: 5
#    La hauteur (en mm) à laquelle la tête doit être remontée pour se déplacer juste avant de lancer
#    une opération de palpage. La valeur par défaut est 5.
```

### Cinématique du treuil à câble

Voir le fichier [example-winch.cfg](../config/example-winch.cfg) pour un exemple de fichier de configuration cinématique d'un treuil à câble.

Seuls les paramètres spécifiques aux imprimantes à treuil sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

LE SUPPORT DU TREUIL À CÂBLE EST EXPÉRIMENTAL. La mise à l'origine n'est pas implémentée dans la cinématique du treuil à câble. Pour ramener l'imprimante à l'origine, envoyez des commandes manuelles de mouvements jusqu'à ce que la tête de l'outil soit à 0, 0, 0, puis envoyez la commande `G28`.

```
[printer]
kinematics: winch

#    La section stepper_a décrit le moteur pas à pas connecté au premier treuil à câble.
#    Un minimum de 3 et un maximum de 26 treuils à câble peuvent être définis
#    (stepper_a à stepper_z) bien qu'il soit courant d'en définir 4.
[stepper_a]
rotation_distance:
#    La rotation_distance est la distance nominale (en mm) à laquelle la tête de l'outil
#    se déplace vers le treuil de câble pour chaque rotation complète du moteur pas
#    à pas. Ce paramètre doit être fourni.
anchor_x:
anchor_y:
anchor_z:
#    Les positions X, Y et Z du treuil à câble dans l'espace cartésien.
#    Ces paramètres doivent être fournis.
```

### Aucune cinématique

Il est possible de définir une cinématique particulière "aucune (none)" pour désactiver le support cinématique dans Klipper. Cela peut être utile pour contrôler des périphériques qui ne sont pas des imprimantes 3D typiques ou encore à des fins de débogage.

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#    Les paramètres max_velocity et max_accel doivent être définis. Les
#    valeurs par défaut ne sont pas utilisées pour la cinématique "none".
```

## Extrudeur commun et support du lit chauffant

### [extruder]

La section de l'extrudeuse est utilisée pour décrire les paramètres de chauffe de la buse ainsi que pour les commandes pas à pas de l'extrudeuse. Voir la [référence de commande](G-Codes.md#extruder) pour plus d'informations. Voir le [guide d'avance de pression](Pressure_Advance.md) pour des informations sur le réglage de l'avance de pression.

```
[extruder]
step_pin:
dir_pin:
enable_pin:
microsteps:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#   Voir la section "stepper" pour une description des paramètres ci-dessus.
#   Si aucun des paramètres ci-dessus n'est spécifié, alors aucun pilote ne
#   sera associé à la buse (bien qu'une commande SYNC_EXTRUDER_MOTION
#   puisse en associer un au moment de l'exécution).
nozzle_diameter:
#   Diamètre de l'orifice de la buse (en mm). Ce paramètre doit être
#   fourni.
filament_diameter:
#   Diamètre moyen du filament (en mm) lorsqu'il entre dans l'extrudeuse.
#   Ce paramètre doit être fourni.
#max_extrude_cross_section:
#   Surface maximale (en mm^2) d'une section transversale d'extrusion (ex:
#   largeur de l'extrusion multipliée par la hauteur de la couche). Ce paramètre
#   permet d'éviter d'extruder des quantités excessives durant de petits déplacements
#   XY. Si un déplacement demande une quantité d'extrusion supérieure à cette valeur,
#   une erreur sera renvoyée. La valeur par défaut est 4.0 *diamètre_buse^2
#instantaneous_corner_velocity: 1.000
#   La variation instantanée maximale de la vitesse (en mm/s) de l'extrudeuse
#   pendant la jonction de deux mouvements. La valeur par défaut est 1mm/s.
#max_extrude_only_distance: 50.0
#   Longueur maximale (en mm de filament) qu'un mouvement de rétraction ou d'extrusion
#   peut fournir. Si un mouvement de rétraction ou d'extrusion unique demande une
#   distance supérieure à cette valeur, une erreur sera renvoyée.
#   La valeur par défaut est 50mm.
#max_extrude_only_velocity:
#max_extrude_only_accel:
#   Vitesse maximale (en mm/s) et accélération (en mm/s^2) du moteur de l'extrudeuse
#   pour les rétractions et les mouvements d'extrusion seuls. Ces paramètres n'ont aucun
#   impact sur les mouvements d'impression normaux. S'ils ne sont pas spécifiés, ils sont
#   calculés pour correspondre à la limite d'un mouvement qu'une impression de
#   section transversale de 4.0*diamètre_buse^2 aurait.
#pressure_advance: 0.0
#   La quantité de filament à pousser dans l'extrudeuse durant l'accélération de celle-ci.
#   Une quantité égale de filament est rétractée durant la décélération. Elle est mesurée
#   en millimètre/seconde. La valeur par défaut est 0, ce qui désactive la fonctionnalité
#   d'avance de pression.
#pressure_advance_smooth_time: 0.040
#   Une durée (en secondes) à utiliser lors du calcul de la vitesse moyenne de l'extrudeuse
#   pour l'avance de pression. Une valeur plus grande donne lieu à des mouvements
#   d'extrusion plus lisses. Ce paramètre ne doit pas dépasser 200ms.
#   Ce paramètre ne s'applique que si pressure_advance est différent de zéro. La valeur
#   par défaut est 0.040 (40 millisecondes).
#
#   Les variables restantes décrivent la chauffe de l'extrudeuse.
heater_pin:
#   Broche de sortie PWM contrôlant le chauffage. Ce paramètre doit être
#   fourni.
#max_power: 1.0
#   La puissance maximale (exprimée sous la forme d'une valeur comprise entre 0,0 et 1,0)
#   de réglage du heater_pin . La valeur 1.0 permet à la broche d'être réglée comme toujours
#   activée durant des périodes prolongées, tandis qu'une valeur de 0,5 permet à la broche
#   de n'être activée durant au plus la moitié du temps.
#   Ce réglage peut être utilisé pour limiter la puissance totale de sortie (sur de longues
#   périodes) de l'élément de chauffe. La valeur par défaut est 1.0.
sensor_type:
#   Type de capteur - les thermistances courantes sont "EPCOS 100K B57560G104F",
#   "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Generic
#   3950", "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", et "TDK NTCG104LH104JT1". Voir la section "Capteurs de
#   température" pour d'autres capteurs.
#   Ce paramètre doit être fourni.
sensor_pin:
#   Broche d'entrée analogique connectée au capteur. Ce paramètre doit être
#   fourni.
#pullup_resistor: 4700
#   La résistance (en ohms) du pullup relié à la thermistance.
#   Ce paramètre n'est valable que si le capteur est une thermistance. La valeur par
#   défaut est 4700 ohms.
#smooth_time: 1.0
#   Une durée (en secondes) sur laquelle les mesures de température seront
#   lissées pour réduire l'impact du bruit de la mesure. La valeur par défaut
#   est de 1 seconde.
control:
#   Algorithme de contrôle (soit pid, soit watermark). Ce paramètre doit
#   être fourni.
pid_Kp:
pid_Ki:
pid_Kd:
#   Les paramètres proportionnels (pid_Kp), intégraux (pid_Ki) et dérivés (pid_Kd)
#   du système de contrôle de rétroaction PID. Klipper évalue les paramètres PID avec
#   la formule générale suivante :
#      heater_pwm = (Kp*erreur + Ki*intégrale(erreur) - Kd*dérivée(erreur)) / 255
#   Où "erreur" est le résultat de "requested_temperature - measured_temperature" et
#   "heater_pwm" est le taux de chauffage demandé, 0.0 étant complètement éteint et
#   1.0 étant complètement allumé. Pensez à utiliser la commande PID_CALIBRATE pour
#   obtenir ces paramètres.  Les paramètres pid_Kp, pid_Ki, et pid_Kd doivent être
#   fournis pour l'algorithme PID.
#max_delta: 2.0
#   Sur les éléments de chauffe contrôlés par watermark, il s'agit du nombre de degrés
#   en Celsius au-dessus de la température cible avant de désactiver le chauffage ainsi
#   que le nombre de degrés en dessous de la température cible avant la réactivation du
#   chauffage. La valeur par défaut est de 2 degrés Celsius.
#pwm_cycle_time: 0.100
#   Durée en secondes de chaque cycle PWM logiciel du chauffage. Il n'est
#   pas recommandé de définir cette valeur, sauf s'il existe une exigence
#   électrique pour commuter le chauffage plus rapidement que 10 fois par seconde.
#   La valeur par défaut est 0,100 seconde.
#min_extrude_temp: 170
#   La température minimale (Celsius) au-dessus de laquelle les commandes de
#   déplacement de l'extrudeuse peuvent être émises. La valeur par défaut est 170° C.
min_temp:
max_temp:
#   La plage maximale de températures valides (Celsius) dans laquelle l'élément de
#   chauffe doit rester. Ceci contrôle une fonction de sécurité implémentée dans le code
#   du micro-contrôleur - si la température mesurée sort de cette plage, le microcontrôleur
#   se met en état d'arrêt. Ce contrôle peut aider à détecter certaines défaillances matérielles
#   de l'élément chauffant et/ou du capteur. Définissez cette plage suffisamment large pour
#   que des températures raisonnables n'entraînent pas d'erreur.
#   Ces paramètres doivent être fournis.
```

### [heater_bed]

La section heater_bed concerne le lit chauffant. Elle utilise les mêmes paramètres de mise en chauffe que ceux décrits dans la section "extrudeuse".

```
[heater_bed]
heater_pin:
sensor_type:
sensor_pin:
control:
min_temp:
max_temp:
#    Voir la section "extruder" pour une description des paramètres ci-dessus.
```

## Support du nivelage du lit

### [bed_mesh]

Nivelage du maillage du lit. On peut définir une section de configuration bed_mesh pour activer les transformations de déplacement qui décalent l'axe z en fonction d'un maillage généré à partir de points palpés. Lorsqu'on utilise une sonde pour définir l'origine de l'axe z, il est recommandé de définir une section safe_z_home dans printer.cfg pour réaliser cette mise à l'origine au centre de la zone d'impression.

Consultez le [guide du maillage du lit](Bed_Mesh.md) et la [référence de la commande](G-Codes.md#bed_mesh) pour plus d'informations.

Exemples visuels :

```
 lit rectangulaire, probe_count = 3, 3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 lit circulaire, round_probe_count = 5, bed_radius = r:
                 x (0, r) fin
               /
             x---x---x
                       \
 (-r, 0) x---x---x---x---x (r, 0)
           \
             x---x---x
                   /
                 x  (0, -r) début
```

```
[bed_mesh]
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#mesh_radius:
#   Defines the radius of the mesh to probe for round beds. Note that
#   the radius is relative to the coordinate specified by the
#   mesh_origin option. This parameter must be provided for round beds
#   and omitted for rectangular beds.
#mesh_origin:
#   Defines the center X, Y coordinate of the mesh for round beds. This
#   coordinate is relative to the probe's location. It may be useful
#   to adjust the mesh_origin in an effort to maximize the size of the
#   mesh radius. Default is 0, 0. This parameter must be omitted for
#   rectangular beds.
#mesh_min:
#   Defines the minimum X, Y coordinate of the mesh for rectangular
#   beds. This coordinate is relative to the probe's location. This
#   will be the first point probed, nearest to the origin. This
#   parameter must be provided for rectangular beds.
#mesh_max:
#   Defines the maximum X, Y coordinate of the mesh for rectangular
#   beds. Adheres to the same principle as mesh_min, however this will
#   be the furthest point probed from the bed's origin. This parameter
#   must be provided for rectangular beds.
#probe_count: 3, 3
#   For rectangular beds, this is a comma separate pair of integer
#   values X, Y defining the number of points to probe along each
#   axis. A single value is also valid, in which case that value will
#   be applied to both axes. Default is 3, 3.
#round_probe_count: 5
#   For round beds, this integer value defines the maximum number of
#   points to probe along each axis. This value must be an odd number.
#   Default is 5.
#fade_start: 1.0
#   The gcode z position in which to start phasing out z-adjustment
#   when fade is enabled. Default is 1.0.
#fade_end: 0.0
#   The gcode z position in which phasing out completes. When set to a
#   value below fade_start, fade is disabled. It should be noted that
#   fade may add unwanted scaling along the z-axis of a print. If a
#   user wishes to enable fade, a value of 10.0 is recommended.
#   Default is 0.0, which disables fade.
#fade_target:
#   The z position in which fade should converge. When this value is
#   set to a non-zero value it must be within the range of z-values in
#   the mesh. Users that wish to converge to the z homing position
#   should set this to 0. Default is the average z value of the mesh.
#split_delta_z: .025
#   The amount of Z difference (in mm) along a move that will trigger
#   a split. Default is .025.
#move_check_distance: 5.0
#   The distance (in mm) along a move to check for split_delta_z.
#   This is also the minimum length that a move can be split. Default
#   is 5.0.
#mesh_pps: 2, 2
#   A comma separated pair of integers X, Y defining the number of
#   points per segment to interpolate in the mesh along each axis. A
#   "segment" can be defined as the space between each probed point.
#   The user may enter a single value which will be applied to both
#   axes. Default is 2, 2.
#algorithm: lagrange
#   The interpolation algorithm to use. May be either "lagrange" or
#   "bicubic". This option will not affect 3x3 grids, which are forced
#   to use lagrange sampling. Default is lagrange.
#bicubic_tension: .2
#   When using the bicubic algorithm the tension parameter above may
#   be applied to change the amount of slope interpolated. Larger
#   numbers will increase the amount of slope, which results in more
#   curvature in the mesh. Default is .2.
#zero_reference_position:
#   An optional X,Y coordinate that specifies the location on the bed
#   where Z = 0.  When this option is specified the mesh will be offset
#   so that zero Z adjustment occurs at this location.  The default is
#   no zero reference.
#faulty_region_1_min:
#faulty_region_1_max:
#   Optional points that define a faulty region.  See docs/Bed_Mesh.md
#   for details on faulty regions.  Up to 99 faulty regions may be added.
#   By default no faulty regions are set.
#adaptive_margin:
#   An optional margin (in mm) to be added around the bed area used by
#   the defined print objects when generating an adaptive mesh.
#scan_overshoot:
#  The maximum amount of travel (in mm) available outside of the mesh.
#  For rectangular beds this applies to travel on the X axis, and for round beds
#  it applies to the entire radius.  The tool must be able to travel the amount
#  specified outside of the mesh.  This value is used to optimize the travel
#  path when performing a "rapid scan".  The minimum value that may be specified
#  is 1.  The default is no overshoot.
```

### [bed_tilt]

Compensation de l'inclinaison du lit. On peut définir une section de configuration bed_tilt pour activer les transformations de déplacement tenant compte d'un lit incliné. Notez que bed_mesh et bed_tilt sont incompatibles ; les deux ne peuvent pas être définis en même temps.

Voir la [référence des commandes](G-Codes.md#bed_tilt) pour plus d'informations.

```
[bed_tilt]
#x_adjust : 0
#   Quantité à ajouter à la hauteur Z de chaque mouvement pour chaque mm sur l'axe X.
#   La valeur par défaut est 0.
#y_adjust : 0
#   Quantité à ajouter à la hauteur Z de chaque mouvement pour chaque mm sur l'axe Y.
#   La valeur par défaut est 0.
#z_adjust : 0
#   Quantité à ajouter à la hauteur Z lorsque la buse est nominalement à 0, 0.
#   La valeur par défaut est 0.
#   Les paramètres suivants contrôlent la commande g-code étendue BED_TILT_CALIBRATE
#   utilisée pour calibrer les paramètres de réglage x et y appropriés.
#points :
#   Une liste de coordonnées X, Y (une par ligne ; les lignes suivantes indentées) devant
#   être palpées pendant une commande BED_TILT_CALIBRATE
#   Spécifiez les coordonnées de la buse et assurez-vous que la sonde est au-dessus du lit
#   aux coordonnées données de la buse.
#   La valeur par défaut est de ne pas activer la commande.
#speed : 50
#   Vitesse (en mm/s) des mouvements de déplacements hors palpage pendant l'étalonnage.
#   La valeur par défaut est 50.
#horizontal_move_z : 5
#   Hauteur (en mm) à laquelle la tête doit être relevée lors du déplacement juste avant
#   de lancer une opération de palpage. La valeur par défaut est 5.
```

### [bed_screws]

Outil d'aide au réglage des vis de nivellement du lit. On peut définir une section de configuration [bed_screws] pour activer une commande g-code BED_SCREWS_ADJUST.

Consultez le [guide de nivelage](Manual_Level.md#adjusting-bed-leveling-screws) et la [référence des commandes](G-Codes.md#bed_screws) pour plus d'informations.

```
[bed_screws]
#screw1:
#   Coordonnées X, Y de la première vis de réglage du niveau du lit. Il s'agit
#   de la position vers laquelle déplacer la buse afin qu'elle soit placée au-
#   dessus de cette vis de réglage (ou aussi proche que possible tout en étant
#   au-dessus du lit). Ce paramètre doit être fourni.
#screw1_name:
#   Un nom arbitraire pour la vis donnée. Ce nom est affiché lors de
#   l'exécution du script d'aide. Par défaut, le nom utilisé est basé sur la
#   position XY de la vis.
#screw1_fine_adjust :
#   Coordonnées X, Y pour commander la buse afin de pouvoir affiner le
#   réglage de la vis de mise à niveau du lit. Par défaut, il n'y a pas de
#   réglage fin sur la vis de mise à niveau du lit.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#   Vis supplémentaires de mise à niveau du lit. Au moins trois vis doivent
#   être définies.
#horizontal_move_z: 5
#   Hauteur (en mm) à laquelle la tête doit être relevée pour se déplacer
#   lors du passage d'une vis à la suivante. La valeur par défaut est 5.
#probe_height: 0
#   Hauteur de la sonde (en mm) après ajustement dû à la dilatation
#   thermique du lit et de la buse. La valeur par défaut est zéro.
#speed: 50
#   Vitesse (en mm/s) des déplacements entre les palpages pendant
#   l'étalonnage. La valeur par défaut est 50.
#probe_speed: 5
#   Vitesse (en mm/s) lors du déplacement d'une position
#   horizontal_move_z à la position probe_height. La valeur par
#   défaut est 5.
```

### [screws_tilt_adjust]

Outil d'assistance au nivellement du lit avec les vis de réglage et l'aide du palpeur Z. On peut définir une section de configuration screws_tilt_adjust pour activer une commande g-code SCREWS_TILT_CALCULATE.

Voir le [guide de nivelage](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) et la [référence des commandes](G-Codes.md#screws_tilt_adjust) pour des informations supplémentaires.

```
[screws_tilt_adjust]
#screw1:
# La coordonnée (X, Y) de la première vis de nivellement du lit. pour que la sonde soit directement
# au-dessus de la vis du lit (ou le plus près possible tout en étant
# au-dessus du lit). C'est la vis de base utilisée dans les calculs. Ce
# paramètre doit être fourni.
#screw1_name:
# Un nom arbitraire pour la vis donnée. Ce nom s'affiche lorsque
# le script d'assistance s'exécute. La valeur par défaut est d'utiliser un nom basé sur
# l'emplacement XY de la vis.
#screw2:
#nom_vis2:
#...
# Vis supplémentaires de mise à niveau du lit. Au moins deux vis doivent être
# définies.
#speed: 50
# La vitesse (en mm/s) des mouvements sans palpage pendant l'étalonnage.
# La valeur par défaut est 50.
#horizontal_move_z: 5
# La hauteur (en mm) à laquelle la tête doit se déplacer
# juste avant de lancer une opération de détection. La valeur par défaut est 5.
#screw_thread: CW-M3
# Le type de vis utilisé pour le nivellement du lit, M3, M4 ou M5, et la
# sens de rotation du bouton qui sert à niveler le lit.
# Valeurs acceptées: CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
# La valeur par défaut est CW-M3 que la plupart des imprimantes utilisent. A dans le sens des aiguilles d'une montre
# la rotation du bouton diminue l'écart entre la buse et le
# lit. A l'inverse, une rotation dans le sens inverse des aiguilles d'une montre augmente l'écart.
```

### [z_tilt]

Réglage multiples de l'inclinaison de moteurs pas à pas de l'axe Z. Cette fonction permet d'ajuster de manière indépendante l'inclinaison de plusieurs moteurs Z (voir la section "stepper_z1"). Si cette section est présente, une [commande G-Code étendue Z_TILT_ADJUST](G-Codes.md#z_tilt) devient disponible.

```
[z_tilt]
#z_positions:
#    Une liste de coordonnées X, Y (une par ligne ; les lignes subséquentes
#    indentées) décrivant l'emplacement de chaque "point de pivot" du lit.
#    Le "point de pivot" est le point où le lit s'attache à l'élément Z
#    donné. Il est décrit à l'aide des coordonnées de la buse (la position X, Y
#    de la buse si elle pouvait se déplacer directement au-dessus du point). La
#    première entrée correspond à stepper_z, la deuxième à stepper_z1,
#    la troisième à stepper_z2, etc. Ce paramètre doit être fourni.
#points:
#    Une liste de coordonnées X, Y (une par ligne ; les lignes ultérieures
#    indentées) qui doivent être palpées pendant une commande Z_TILT_ADJUST.
#    Spécifiez les coordonnées de la buse et assurez-vous que le palpeur est
#    au-dessus du lit aux coordonnées données de la buse.
#    Ce paramètre doit être fourni.
#speed: 50
#    La vitesse (en mm/s) des mouvements de déplacements hors palpage
#    pendant l'étalonnage. La valeur par défaut est 50.
#horizontal_move_z: 5
#    Hauteur (en mm) à laquelle la tête doit être relevée pour se déplacer juste
#    avant de lancer une opération de palpage. La valeur par défaut est 5.
#retries: 0
#    Nombre de tentatives à effectuer si les points palpés ne sont pas dans la
#    tolérance.
#retry_tolerance: 0
#    Si les ré-essais sont activés, réessayer si les points sondés les plus grands et
#    les plus petits diffèrent plus que la tolérance retry_tolerance. Notez que la
#    plus petite unité de changement ici serait un seul pas. Cependant, si vous
#    sondez plus de points que de moteurs, il est probable que vous aurez une
#    valeur minimale fixe pour la plage de points sondés. Vous pouvez en
#    apprendre plus en observant la sortie de la commande.
```

### [quad_gantry_level]

Mise à niveau du portique mobile à l'aide de 4 moteurs Z contrôlés indépendamment. Corrige les effets de paraboles hyperboliques (chips de pommes de terre) sur un portique mobile qui est plus flexible. AVERTISSEMENT : l'utilisation de cette section sur un lit mobile peut conduire à des résultats indésirables. Si cette section est présente, une commande G-Code étendue QUAD_GANTRY_LEVEL devient disponible. Cette routine suppose la configuration suivante des moteurs Z :

```
 ----------------
 |Z1          Z2|
 |  ---------   |
 |  |       |   |
 |  |       |   |
 |  x--------   |
 |Z           Z3|
 ----------------
```

Où x est la position 0, 0 sur le lit

```
[quad_gantry_level]
#gantry_corners:
#    Une liste de coordonnées X, Y, séparées par des retours à la ligne, décrivant les deux
#    coins opposés du portique. La première entrée correspond à Z, la seconde à Z2.
#    Ce paramètre doit être fourni.
#points:
#    Une liste, séparée par des retours à la ligne, de quatre points X, Y devant être palpés
#    pendant une commande QUAD_GANTRY_LEVEL. L'ordre des emplacements est
#    important, il doit correspondre aux emplacements Z, Z1, Z2 et Z3 dans l'ordre.
#    Ce paramètre doit être fourni. Pour une précision maximale, assurez-vous que les
#    décalages de votre sonde sont configurés.
#speed: 50
#    La vitesse (en mm/s) des mouvements sans palpage pendant l'étalonnage.
#    La valeur par défaut est 50.
#horizontal_move_z: 5
#    La hauteur (en mm) à laquelle la tête doit être relevée pour se déplacer juste
#    avant de lancer une opération de palpage. La valeur par défaut est 5.
#max_adjust: 4
#    Limite de sécurité quand un ajustement supérieur à cette valeur est demandé.
#    quad_gantry_level abandonnera.
#retries: 0
#    Nombre de tentatives si les points palpés ne sont pas dans la tolérance.
#retry_tolerance: 0
#    Si les re-tentatives (retries) sont activées, réessayer si les points palpés les plus grands
#    et les plus petits diffèrent plus que la tolérance de re-tentative (retry_tolerance).
```

### [skew_correction]

Correction de l'inclinaison de l'imprimante. Il est possible de corriger l'inclinaison de l'imprimante logiciellement sur 3 plans, xy, xz, yz. Pour ce faire, on imprime un modèle d'étalonnage le long d'un plan et on mesure trois longueurs. En raison de la nature de la correction d'inclinaison, ces longueurs sont définies via le gcode. Voir [Correction d'inclinaison](Skew_Correction.md) et [Référence des commandes](G-Codes.md#skew_correction) pour plus de détails.

```
[skew_correction]
```

### [z_thermal_adjust]

Ajustement de la position Z de la tête d'impression en fonction de la température. Compenser le mouvement vertical de la tête d'impression causé par la dilatation thermique du châssis de l'imprimante en temps réel à l'aide d'un capteur de température (généralement couplé à une section verticale du châssis).

Voir aussi : [commandes de code G étendues](G-Codes.md#z_thermal_adjust).

```
[z_thermal_adjust]
#temp_coeff:
#    Le coefficient de dilatation thermique, en mm/°C. Par exemple, un
#    temp_coeff de 0,01 mm/°C déplacera l'axe Z vers le bas de 0,01 mm pour
#    chaque degré Celsius d'augmentation du capteur de température. La
#    valeur par défaut, 0,0 mm/°C, n'applique aucun ajustement.
#smooth_time:
#    Fenêtre de lissage appliquée au capteur de température, en secondes.
#    Peut réduire le bruit du moteur dû à de petites corrections excessives en
#    réponse au bruit du capteur. La valeur par défaut est de 2,0 secondes.
#z_adjust_off_above:
#    Désactive les ajustements au-dessus de cette hauteur Z [mm]. La dernière
#    correction calculée restera appliquée jusqu'à ce que la tête de l'outil passe
#    à nouveau en dessous de la hauteur Z spécifiée. La valeur par défaut est
#    99999999.0 mm (toujours actif).
#max_z_adjustment:
#    Ajustement absolu maximal pouvant être appliqué à l'axe Z [mm].
#    La valeur par défaut est 99999999.0 mm (illimité).
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#    Configuration du capteur de température.
#    Voir la section "extrudeuse" pour la définition des paramètres ci-dessus.
#gcode_id:
#    Voir la section "heater_generic" pour la définition de ce
#    paramètre.
```

## Mise à l'origine personnalisée

### [safe_z_home]

Mise à l'origine sûre de l'axe Z. On peut utiliser ce mécanisme pour centrer l'axe Z sur des coordonnées X, Y spécifiques. Ceci est utile si la tête de l'outil, par exemple, doit se déplacer vers le centre du lit avant que l'axe Z puisse être mis à l'origine.

```
[safe_z_home]
home_xy_position:
#    Une coordonnée X, Y (par exemple 100, 100) où la mise à l'origine Z
#    doit être effectuée. Ce paramètre doit être fourni.
#speed: 50.0
#    Vitesse à laquelle la tête de l'outil est déplacée vers la position de
#    référence Z sûre. La valeur par défaut est 50 mm/s
#z_hop:
#    Distance (en mm) pour lever l'axe Z avant le retour au point d'origine.
#    Cette valeur est appliquée à toute commande d'initialisation, même
#    si elle n'initialise pas l'axe Z. Si l'axe Z est déjà ramené à la position
#    de base et que la position Z actuelle est inférieure à z_hop, alors ceci
#    lèvera la tête à une hauteur de z_hop. Si l'axe Z n'est pas déjà centré,
#    la tête est relevée de z_hop.
#    La valeur par défaut est de ne pas implémenter le relevage en Z.
#z_hop_speed: 15.0
#    Vitesse (en mm/s) à laquelle l'axe Z est relevé avant le retour à la
#    position initiale. La valeur par défaut est de 15 mm/s.
#move_to_previous: False
#    Lorsqu'il a la valeur True, les axes X et Y sont réinitialisés à leurs
#    positions précédentes après retour à la position initiale de l'axe Z.
#    La valeur par défaut est False.
```

### [homing_override]

Homing override. On peut utiliser ce mécanisme pour exécuter une série de commandes g-code à la place d'un G28 trouvé dans l'entrée g-code normale. Cela peut être utile sur les imprimantes qui nécessitent une procédure spécifique du retour au point d'origine de la machine.

```
[homing_override]
gcode :
#    Une liste de commandes G-Code à exécuter à la place des commandes
#    G28 trouvées dans l'entrée g-code normale. Voir
#    docs/Command_Templates.md pour le format G-Code. Si un G28 est
#    contenu dans cette liste de commandes alors la procédure de mise à
#    l'origine de l'imprimante sera invoquée. Les commandes énumérées
#    ici doivent ramener tous les axes à la position initiale.
#    Ce paramètre doit être fourni.
#axes : xyz
#    Les axes à remplacer. Par exemple, si ce paramètre est défini sur "z",
#    alors le script d'annulation ne sera exécuté que lorsque l'axe z est mis
#    à l'origine (par ex. une commande "G28" ou "G28 Z"). Remarque :
#    le script de neutralisation doit toujours gérer tous les axes. La valeur
#    par défaut est "xyz" ce qui fait que le script de remplacement sera
#    exécuté à la place de toutes les commandes G28.
#set_position_x :
#set_position_y :
#set_position_z :
#    Si spécifié, l'imprimante supposera que l'axe est à la position indiquée
#    avant d'exécuter les commandes g-code ci-dessus. Le fait de définir
#    ceci désactive les contrôles d'orientation pour cet axe. Cela peut être
#    utile si la tête doit se déplacer avant d'invoquer le mécanisme G28
#    normal d'un axe. La valeur par défaut est de ne pas forcer une
#    position pour un axe.
```

### [endstop_phase]

Interrupteurs de fin de course ajustés à la phase du moteur pas à pas. Pour utiliser cette fonction, définissez une section de configuration avec un préfixe "endstop_phase" suivi du nom de la section de configuration du moteur pas à pas correspondante (par exemple, "[endstop_phase stepper_z]"). Cette fonctionnalité peut améliorer la précision des interrupteurs de fin de course. Ajoutez une déclaration nue "[endstop_phase]" pour activer la commande ENDSTOP_PHASE_CALIBRATE.

Voir le [guide de détecteurs de fin de course](Endstop_Phase.md) et la [référence des commandes](G-Codes.md#endstop_phase) pour plus d'informations.

```
[endstop_phase stepper_z]
#endstop_accuracy:
#   Définit la précision attendue (en mm) de la butée. Cela représente la
#   distance d'erreur maximale que la butée peut déclencher (par
#   exemple, si une butée peut occasionnellement se déclencher 100um
#   en avance ou jusqu'à 100um en retard alors réglez cette valeur sur
#   0.200 pour 200um). La valeur par défaut est
#   4*rotation_distance/full_steps_per_rotation.
#trigger_phase:
#   Spécifie la phase du pilote du moteur pas à pas à attendre lorsque
#   l'on atteint la butée. Composé de deux nombres séparés par une barre
#   oblique - la phase et le nombre total de phases (par exemple, "7/64").
#   Ne définissez cette valeur que si vous êtes sûr que le pilote du moteur
#   pas à pas est réinitialisé à chaque fois que le mcu est réinitialisé. Si
#   cette valeur n'est pas définie, alors la phase du moteur pas à pas sera
#   détectée à la première mise à l'origine et cette phase sera utilisée sur
#   toutes les origines suivantes.
#endstop_align_zero: False
#   Si vrai, la position_endstop de l'axe sera effectivement modifiée de
#   manière à ce que la position zéro de l'axe se produise sur un pas
#   complet du moteur pas à pas. (Si utilisé sur l'axe Z et que la hauteur
#   de la couche d'impression est un multiple de la distance parcourue
#   par un pas complet, alors chaque couche se produira sur un pas
#   complet). La valeur par défaut est False.
```

## Macros et événements G-Code

### [gcode_macro]

Macros G-Code (on peut définir un nombre quelconque de sections avec le préfixe "gcode_macro"). Voir le [guide des modèles de commande](Command_Templates.md) pour plus d'informations.

```
[gcode_macro my_cmd]
#gcode:
#    Une liste de commandes G-Code à exécuter à la place de "my_cmd".
#    Voir docs/Command_Templates.md pour le format G-Code. Ce paramètre
#    doit être fourni.
#variable_<name>:
#    On peut spécifier un nombre quelconque d'options avec le préfixe
#    "variable_". Le nom de variable donné se verra attribué la valeur donnée
#    (analysée en tant que littéral par Python) et sera disponible pendant
#    l'expansion de la macro. Par exemple, une configuration avec
#    "variable_fan_speed = 75" pourrait avoir des commandes gcode
#    contenant "M106 S{ fan_speed * 255 }". Ces variables peuvent alors être
#    modifiées au moment de l'exécution en utilisant la commande
#    SET_GCODE_VARIABLE (voir docs/Command_Templates.md pour plus
#    de détails). Les noms de variables peuvent ne pas utiliser de
#    caractères majuscules.
#rename_existing:
#    Cette option permet à la macro de remplacer une commande G-Code
#    existante et fournira la définition précédente de la commande via le
#    nom fourni ici. Ceci peut être utilisé pour remplacer les commandes
#    G-Code originelles. Il convient d'être prudent lorsque l'on remplace
#    des commandes, cela pouvant provoquer des résultats complexes et
#    inattendus. La valeur par défaut est de ne pas remplacer une
#    commande G-Code existante.
#description: Macro G-Code
#    Ceci ajoutera une courte description utilisée à la commande HELP
#    ou lors de l'utilisation de la fonction de complétion automatique.
#    Par défaut : "G-Code macro".
```

### [delayed_gcode]

Exécute un gcode sur un délai défini. Voir le [guide des modèles de commande](Command_Templates.md#delayed-gcodes) et la [référence des commandes](G-Codes.md#delayed_gcode) pour plus d'informations.

```
[delayed_gcode my_delayed_gcode]
gcode:
#   Une liste de commandes G-Code à exécuter lorsque la durée du délai
#   est écoulée. Les modèles G-Code sont supportés. Ce paramètre
#   doit être fourni.
#initial_duration: 0.0
#   Durée du délai initial (en secondes). Si elle est définie à une valeur non
#   nulle, le gcode différé s'exécutera le nombre de secondes spécifié après
#   que l'imprimante passe à l'état "prêt". Ceci peut être utile pour les
#   procédures d'initialisation ou lors d'une répétition de delayed_gcode.
#   Si la valeur est 0, le delayed_gcode ne sera pas exécuté au démarrage.
#   La valeur par défaut est 0.
```

### [save_variables]

Prise en charge de l'enregistrement des variables sur le disque afin qu'elles soient conservées lors des redémarrages. Voir [modèles de commande](Command_Templates.md#save-variables-to-disk) et [référence G-code](G-Codes.md#save_variables) pour plus d'informations.

```
[save_variables]
filename:
#    Obligatoire - fournir un nom de fichier utilisé pour enregistrer les variables
#    sur le disque, par exemple ~/variables.cfg.
```

### [idle_timeout]

Délai d'inactivité. Un délai d'inactivité est automatiquement activé - ajoutez une section de configuration idle_timeout explicite pour modifier les paramètres par défaut.

```
[idle_timeout]
#gcode:
#    Une liste de commandes G-Code à exécuter lors d'un délai d'inactivité. Voir
#    docs/Command_Templates.md pour le format G-Code. La valeur par défaut
#    est d'exécuter "TURN_OFF_HEATERS" et "M84".
#timeout: 600
#    Durée d'attente (en secondes) avant d'exécuter les commandes G-Code ci-dessus.
#    La valeur par défaut est de 600 secondes.
```

## Fonctionnalités optionnelles du G-code

### [virtual_sdcard]

Une carte SD virtuelle peut être utile si la machine hôte n'est pas assez rapide pour faire fonctionner OctoPrint correctement. Elle permet au logiciel hôte Klipper d'imprimer directement les fichiers gcode stockés dans un répertoire sur l'hôte en utilisant les commandes G-Code standard de la carte SD (par exemple, M24).

```
[virtual_sdcard]
path:
#   The path of the local directory on the host machine to look for
#   g-code files. This is a read-only directory (sdcard file writes
#   are not supported). One may point this to OctoPrint's upload
#   directory (generally ~/.octoprint/uploads/ ). This parameter must
#   be provided.
#on_error_gcode:
#   A list of G-Code commands to execute when an error is reported.
#   See docs/Command_Templates.md for G-Code format. The default is to
#   run TURN_OFF_HEATERS.
```

### [sdcard_loop]

Certaines imprimantes dotées de fonctions d'éjections des pièces imprimées, comme un éjecteur de pièces ou une imprimante à courroie, peuvent trouver une utilité dans la mise en boucle de sections du fichier de la carte SD (par exemple, pour imprimer la même pièce encore et encore, ou répéter une section d'une pièce pour une chaîne ou un autre motif répété).

Voir la [référence des commandes](G-Codes.md#sdcard_loop) pour les commandes prises en charge. Voir le fichier [sample-macros.cfg](../config/sample-macros.cfg) pour une macro G-Code compatible avec le M808 de Marlin.

```
[sdcard_loop]
```

### [force_move]

Support des déplacements manuels des moteurs pas à pas à des fins de diagnostic. Remarque : l'utilisation de cette fonction peut placer l'imprimante dans un état invalide - consultez la [référence de la commande](G-Codes.md#force_move) pour obtenir des détails importants.

```
[force_move]
#enable_force_move: False
#    Défini à true pour activer les commandes G-Code étendues FORCE_MOVE et
#    SET_KINEMATIC_POSITION
#    La valeur par défaut est false.
```

### [pause_resume]

Fonctionnalité Pause/Reprise avec prise en charge de la capture et de la restauration de position. Voir la [référence de la commande](G-Codes.md#pause_resume) pour plus d'informations.

```
[pause_resume]
#recover_velocity: 50.
#    Lorsque la capture/restauration est activée, la vitesse à laquelle retourner à
#    la position capturée (en mm/s). La valeur par défaut est 50,0 mm/s.
```

### [firmware_retraction]

Rétraction du filament par le firmware. Cela permet d'activer les commandes GCODE G10 (rétraction) et G11 (dé-rétraction) émises par de nombreux trancheurs. Les paramètres ci-dessous fournissent des valeurs par défaut au démarrage, ces valeurs peuvent être ajustées via la [commande SET_RETRACTION](G-Codes.md#firmware_retraction), ce qui permet des réglages par filament et des ajustements en cours d'impression.

```
[firmware_retraction]
#retract_length: 0
#    La longueur du filament (en mm) à rétracter lorsque G10 est activé, et à fournir
#    lorsque G11 est activé (voir unretract_extra_length ci-dessous).
#    La valeur par défaut est 0 mm.
#retract_speed: 20
#    La vitesse de rétraction, en mm/s. La valeur par défaut est 20 mm/s.
#unretract_extra_length: 0
#    Longueur (en mm) de filament *supplémentaire* à ajouter lors de la dé-rétraction.
#unretract_speed: 10
#    La vitesse de dé-rétraction, en mm/s. La valeur par défaut est 10 mm/s.
```

### [gcode_arcs]

Support des commandes gcode de courbes (arc) (G2/G3).

```
[gcode_arcs]
#resolution: 1.0
#    Un arc sera divisé en segments. La longueur de chaque segment sera égale à
#    la résolution en mm définie ci-dessus. Des valeurs plus faibles produiront un
#    arc plus fin, mais également plus de travail de votre machine. Les arcs plus
#    petits que la valeur configurée deviendront des lignes droites. La valeur par
#    défaut est 1 mm.
```

### [respond]

Active les [commandes étendues "M118" et "RESPOND"](G-Codes.md#respond).

```
[respond]
#default_type: echo
#    Définit le préfixe par défaut de la sortie "M118" et "RESPOND" à l'un des
#    éléments suivants :
#            echo: "echo : " (C'est la valeur par défaut)
#            command: "// "
#            error: " !! "
#default_prefix: echo:
#    Définit directement le préfixe par défaut. Si elle est présente, cette valeur
#    remplacera celle de "default_type".
```

### [exclude_object]

Permet de prendre en charge l'exclusion ou l'annulation d'objets individuels pendant le processus d'impression.

Voir le [guide des objets exclus](Exclude_Object.md) et la [référence des commandes](G-Codes.md#excludeobject) pour plus d'informations. Voir le fichier [sample-macros.cfg](../config/sample-macros.cfg) pour une macro G-Code M486 compatible avec Marlin/RepRapFirmware.

```
[exclude_object]
```

## Compensation de la résonance

### [input_shaper]

Active la [compensation de résonance](Resonance_Compensation.md). Voir également la [référence des commandes](G-Codes.md#input_shaper).

```
[input_shaper]
#shaper_freq_x: 0
#    Fréquence (en Hz) de la mise en forme de l'entrée pour l'axe X. Il s'agit généralement
#    d'une fréquence de résonance de l'axe X que la mise en forme de l'entrée doit supprimer.
#    Pour les mises en forme plus complexes, comme les mises en forme à 2 ou 3 bosses EI
#    (2hump/3hump), ce paramètre peut être défini à partir de différentes considérations.
#    La valeur par défaut est 0, ce qui désactive la mise en forme de l'entrée pour l'axe X.
#shaper_freq_y: 0
#    Fréquence (en Hz) de la mise en forme de l'entrée pour l'axe Y. Il s'agit généralement
#    d'une fréquence de résonance de l'axe Y que la mise en forme de l'entrée doit supprimer.
#    Pour les mises en forme plus complexes, comme les mises en forme à 2 ou 3 bosses EI
#    (2hump/3hump), ce paramètre peut être défini à partir de différentes considérations.
#    La valeur par défaut est 0, ce qui désactive la mise en forme de l'entrée pour l'axe Y.
#shaper_type: mzv
#    Le type de mise en forme de l'entrée à utiliser pour les axes X et Y. Les types supportés
#    sont zv, mzv, zvd, ei, 2hump_ei, et 3hump_ei.
#    La valeur par défaut est la compensation de résonance mzv.
#shaper_type_x:
#shaper_type_y:
#    Si shaper_type n'est pas défini, ces deux paramètres peuvent être utilisés pour configurer
#    des formes d'entrée différentes pour les axes X et Y. Les valeurs supportées sont les
#    mêmes que celles du paramètre shaper_type.
#damping_ratio_x: 0.1
#damping_ratio_y: 0.1
#    Taux d'amortissement des vibrations des axes X et Y utilisés par les dispositifs de mise
#    en forme de l'entrée afin d'améliorer la suppression des vibrations. La valeur par défaut est
#    0.1 ce qui est une bonne valeur générale pour la plupart des imprimantes. Dans la plupart
#    des cas, ce paramètre ne nécessite aucun réglage et ne doit pas être modifié.
```

### [adxl345]

Support des accéléromètres ADXL345. Ce support permet d'interroger les mesures de l'accéléromètre à partir du capteur. Cela active une commande ACCELEROMETER_MEASURE (voir [G-Codes](G-Codes.md#adxl345) pour plus d'informations). Le nom de la puce par défaut est "default", mais on peut spécifier un nom explicite (par exemple, [adxl345 my_chip_name]).

```
[adxl345]
cs_pin :
#   La broche d'activation SPI du capteur. Ce paramètre doit être fourni.
#spi_speed : 5000000
#   La vitesse SPI (en hz) à utiliser lors de la communication avec la puce.
#   La valeur par défaut est 5000000.
#spi_bus :
#spi_software_sclk_pin :
#spi_software_mosi_pin :
#spi_software_miso_pin :
#   Voir la section "paramètres SPI communs" pour une description des
#   paramètres ci-dessus.
#axes_map : x, y, z
#   L'axe de l'accéléromètre de chacun des axes X, Y et Z de l'imprimante.
#   Ceci peut être utile si l'accéléromètre est monté dans une orientation
#   qui ne correspond pas à celle de l'imprimante. Par exemple, on peut
#   régler cette option sur "y, x, z" pour permuter les axes X et Y.
#   Il est également possible d'inverser un axe si la direction de l'accéléromètre
#   est inversée (par exemple, "x, z, -y"). La valeur par défaut est "x, y, z".
#Rate : 3200
#   Débit de données de sortie pour ADXL345. ADXL345 prend en charge les débits
#   de données suivants : 3200, 1600, 800, 400, 200, 100, 50, et 25. Notez qu'il n'est
#   pas recommandé de changer ce débit par rapport au débit par défaut de 3200,
#   les débits inférieurs à 800 affecteront considérablement la qualité des mesures
#   de résonance.
```

### [lis2dw]

Support for LIS2DW accelerometers.

```
[lis2dw]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [lis3dh]

Support for LIS3DH accelerometers.

```
[lis3dh]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [mpu9250]

Prise en charge des accéléromètres MPU-9250, MPU-9255, MPU-6515, MPU-6050 et MPU-6500 (on peut définir un nombre quelconque de sections avec le préfixe "mpu9250").

```
[mpu9250 my_accelerometer]
#i2c_address:
#   Default is 104 (0x68). If AD0 is high, it would be 0x69 instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [resonance_tester]

Prise en charge du test de résonance et du calibrage automatique du façonneur d'entrée (input shaper). Pour utiliser la plupart des fonctionnalités de ce module, des dépendances logicielles supplémentaires doivent être installées ; reportez-vous à [Mesurer les résonances](Measuring_Resonances.md) et à la [référence de commande](G-Codes.md#resonance_tester) pour plus d'informations. Voir la section [Adoucissement Max](Measuring_Resonances.md#max-smoothing) du guide de mesure des résonances pour plus d'informations sur le paramètre `max_smoothing` et son utilisation.

```
[resonance_tester]
#probe_points:
#   A list of X, Y, Z coordinates of points (one point per line) to test
#   resonances at. At least one point is required. Make sure that all
#   points with some safety margin in XY plane (~a few centimeters)
#   are reachable by the toolhead.
#accel_chip:
#   A name of the accelerometer chip to use for measurements. If
#   adxl345 chip was defined without an explicit name, this parameter
#   can simply reference it as "accel_chip: adxl345", otherwise an
#   explicit name must be supplied as well, e.g. "accel_chip: adxl345
#   my_chip_name". Either this, or the next two parameters must be
#   set.
#accel_chip_x:
#accel_chip_y:
#   Names of the accelerometer chips to use for measurements for each
#   of the axis. Can be useful, for instance, on bed slinger printer,
#   if two separate accelerometers are mounted on the bed (for Y axis)
#   and on the toolhead (for X axis). These parameters have the same
#   format as 'accel_chip' parameter. Only 'accel_chip' or these two
#   parameters must be provided.
#max_smoothing:
#   Maximum input shaper smoothing to allow for each axis during shaper
#   auto-calibration (with 'SHAPER_CALIBRATE' command). By default no
#   maximum smoothing is specified. Refer to Measuring_Resonances guide
#   for more details on using this feature.
#move_speed: 50
#   The speed (in mm/s) to move the toolhead to and between test points
#   during the calibration. The default is 50.
#min_freq: 5
#   Minimum frequency to test for resonances. The default is 5 Hz.
#max_freq: 133.33
#   Maximum frequency to test for resonances. The default is 133.33 Hz.
#accel_per_hz: 60
#   This parameter is used to determine which acceleration to use to
#   test a specific frequency: accel = accel_per_hz * freq. Higher the
#   value, the higher is the energy of the oscillations. Can be set to
#   a lower than the default value if the resonances get too strong on
#   the printer. However, lower values make measurements of
#   high-frequency resonances less precise. The default value is 75
#   (mm/sec).
#hz_per_sec: 1
#   Determines the speed of the test. When testing all frequencies in
#   range [min_freq, max_freq], each second the frequency increases by
#   hz_per_sec. Small values make the test slow, and the large values
#   will decrease the precision of the test. The default value is 1.0
#   (Hz/sec == sec^-2).
#sweeping_accel: 400
#   An acceleration of slow sweeping moves. The default is 400 mm/sec^2.
#sweeping_period: 1.2
#   A period of slow sweeping moves. Setting this parameter to 0
#   disables slow sweeping moves. Avoid setting it to a too small
#   non-zero value in order to not poison the measurements.
#   The default is 1.2 sec which is a good all-round choice.
```

## Assistants de fichiers de configuration

### [board_pins]

Alias des broches de la carte (on peut définir un nombre quelconque de sections avec le préfixe "board_pins"). Utilisez ceci pour définir des alias de broches d'un micro-contrôleur.

```
[board_pins my_aliases]
mcu: mcu
#   Une liste de micro-contrôleurs séparés par des virgules pouvant utiliser les
#   alias. La valeur par défaut est d'appliquer les alias au "mcu" principal.
alias:
aliases_<nom>:
#   Une liste séparée par des virgules d'alias "nom=valeur" à créer pour le micro-
#   contrôleur donné. Par exemple, "EXP1_1=PE6" créera un alias "EXP1_1" pour la
#   broche "PE6". Cependant, si la "valeur" est incluse dans "<>", alors "nom" est créé
#   comme une broche réservée (par exemple, "EXP1_9=<GND>" réserverait "EXP1_9").
#   Un nombre quelconque d'options commençant par "alias_" peuvent être spécifiées.
```

### [include]

Prise en charge de l'inclusion de fichiers. On peut inclure des fichiers de configuration supplémentaires à partir du fichier de configuration principal de l'imprimante. Les caractères génériques peuvent également être utilisés (par exemple, "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

Cet outil permet de définir plusieurs fois une même broche de microcontrôleur dans un fichier de configuration sans vérification normale des erreurs. Ceci est destiné à des fins de diagnostic et de débogage. Cette section n'est pas nécessaire lorsque Klipper prend en charge l'utilisation de la même broche plusieurs fois, et l'utilisation de cette dérogation peut entraîner des résultats confus et inattendus.

```
[duplicate_pin_override]
pins:
#   Une liste de broches séparées par des virgules pouvant être utilisées plusieurs fois dans
#   un fichier de configuration sans contrôles d'erreurs normaux. Ce paramètre doit être
#   fourni.
```

## Matériel de nivelage du lit

### [probe]

Sonde de hauteur Z. On peut définir cette section pour activer le matériel de nivellement de l'axe Z. Lorsque cette section est activée, les commandes [g-code étendus](G-Codes.md#probe) PROBE et QUERY_PROBE deviennent disponibles. Consultez également le [guide d'étalonnage des sondes](Probe_Calibrate.md). La section probe crée également une broche virtuelle "probe:z_virtual_endstop". Il est possible de définir la broche du stepper_z, endstop_pin, sur cette broche virtuelle pour les imprimantes de style cartésien qui utilisent la sonde à la place d'un interrupteur de fin de course Z. Si vous utilisez "probe:z_virtual_endstop", ne définissez pas de position_endstop dans la configuration de la section stepper_z.

```
[probe]
pin:
#    Broche de détection de la sonde. Si la broche se trouve sur un microcontrôleur différent
#    de celui des moteurs de l'axe Z alors elle active le "multi-mcu homing". Ce paramètre
#    doit être fourni.
#deactivate_on_each_sample: True
#    Ceci détermine si Klipper doit exécuter le gcode de désactivation entre chaque tentative
#    de palpage lors d'une séquence de palpages multiples.
#    La valeur par défaut est True.
#x_offset: 0.0
#    La distance (en mm) entre la sonde et la buse le long de l'axe x.
#    La valeur par défaut est 0.
#y_offset: 0.0
#    La distance (en mm) entre la sonde et la buse le long de l'axe y.
#    La valeur par défaut est 0.
z_offset:
#    La distance (en mm) entre le lit et la buse lorsque la sonde se déclenche.
#    Ce paramètre doit être fourni.
#speed: 5.0
#    Vitesse (en mm/s) de l'axe Z lors du palpage. La valeur par défaut est 5mm/s.
#samples: 1
#    Le nombre de fois où il faut palper chaque point. Les valeurs z palpées seront
#    moyennées. La valeur par défaut est de palper 1 fois.
#sample_retract_dist: 2.0
#    Distance (en mm) à parcourir pour relever la tête de l'outil entre chaque palpage
#    (en cas d'échantillonnage multiple). La valeur par défaut est 2mm.
#lift_speed:
#    Vitesse (en mm/s) de l'axe Z lors du levage de la sonde entre les échantillons.
#    La valeur par défaut est la même que celle du paramètre 'speed'.
#samples_result: average
#    La méthode de calcul lorsque l'on échantillonne plusieurs fois - soit "médiane"
#    (median) ou "moyenne" (average). La valeur par défaut est "moyenne".
#samples_tolerance: 0.100
#    La distance Z maximale (en mm) à laquelle un échantillon peut différer des autres
#    échantillons. Si cette tolérance est dépassée, soit une erreur est signalée soit une
#    tentative de palpage est recommencée (cf. samples_tolerance_retries).
#    La valeur par défaut est 0.100mm.
#samples_tolerance_retries: 0
#    Le nombre de fois qu'il faut réessayer quand un palpage dépasse la tolérance des
#    échantillons. Lors d'une nouvelle tentative, tous les échantillons en cours sont rejetés
#    et une tentative de palpa est relancée. Si un ensemble valide d'échantillons n'est pas
#    obtenu dans le nombre de tentatives donné, une erreur est signalée. La valeur par défaut
#    est zéro, ce qui entraîne le signalement d'une erreur dès le premier échantillon dépassant
#    la tolérance de samples_tolerance.
#activate_gcode:
#    Une liste de commandes G-Code à exécuter avant chaque tentative de palpage.
#    Voir docs/Command_Templates.md pour le format G-Code. Cela peut être  utile si la sonde
#    doit être activée d'une manière particulière. Ne pas envoyer ici de commandes déplaçant
#    la tête de l'outil (par exemple, G1). La valeur par défaut est de ne pas exécuter de commandes
#    G-code spéciales lors de l'activation.
#deactivate_gcode:
#    Une liste de commandes G-Code à exécuter après la fin de chaque tentative de palpage
#    terminée. Voir docs/Command_Templates.md pour le format G-Code. Ne pas envoyer ici
#    de commandes déplaçant la tête de l'outil. La valeur par défaut est de ne pas exécuter de
#    commandes G-code spéciales lors de la désactivation.
```

### [bltouch]

Sonde BLTouch. On peut définir cette section (au lieu d'une section probe) pour activer une sonde BLTouch. Voir [Guide BL-Touch](BLTouch.md) et [Référence des commandes](G-Codes.md#bltouch) pour plus d'informations. Une broche virtuelle "probe:z_virtual_endstop" est également créée (voir la section "probe" pour les détails).

```
[bltouch]
sensor_pin:
#   Broche connectée à la broche du capteur (sensor) BLTouch. La plupart des BLTouch
#   exigent un pullup sur la broche du capteur (préfixez le nom de la broche par "^").
#   Ce paramètre doit être fourni.
control_pin:
#   Broche connectée à la broche de commande du BLTouch.
#   Ce paramètre doit être fourni.
#pin_move_time: 0.680
#   Durée d'attente (en secondes) pour que la broche BLTouch se déplace vers
#   le haut ou le bas. La valeur par défaut est de 0,680 seconde.
#stow_on_each_sample: True
#   Détermine si Klipper doit ordonner à la broche de se déplacer vers le haut entre
#   chaque palpage lors d'une séquence de palpages multiples.
#   Lisez les instructions dans docs/BLTouch.md avant de régler ce paramètre à False.
#   La valeur par défaut est True.
#probe_with_touch_mode: False
#   Si ce paramètre est défini sur True, Klipper palpera avec le périphérique en
#   "touch_mode". La valeur par défaut est False (palpage en mode "pin_down").
#pin_up_reports_not_triggered: True
#   Définit si le BLTouch rapporte systématiquement le palpeur dans un état "non
#   déclenché" après une commande "pin_up" réussie. Ceci devrait être True pour
#   tous les BLTouch authentiques. Lisez les instructions de docs/BLTouch.md avant
#   de régler cette valeur à False. La valeur par défaut est True.
#pin_up_touch_mode_reports_triggered: True
#   Définit si le BLTouch rapporte systématiquement un état "déclenché" après la
#   commande "pin_up_mode_reports_triggered". Ceci devrait être True pour tous les
#   BLTouch authentiques. Lisez les instructions de docs/BLTouch.md avant de régler
#   cette valeur à False. La valeur par défaut est True.
#set_output_mode:
#   Demande un mode de sortie particulier de la broche du capteur sur un BLTouch V3.0
#   (et ultérieurs). Ce paramètre ne doit pas être utilisé sur d'autres types de sondes.
#   Réglez sur "5V" pour demander une sortie de 5 Volts de la broche du capteur (à n'utiliser
#   que si la carte contrôleur nécessite le mode 5V et est tolérante à 5V sur sa ligne de signal
#   d'entrée). Réglez sur "OD" pour demander l'utilisation de la sortie de la broche du capteur
#   en mode drain ouvert. La valeur par défaut est de ne pas demander de mode de sortie.
#x_offset:
#y_offset:
#z_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   Voir la section "probe" pour des informations sur ces paramètres.
```

### [smart_effector]

Le "Smart Effector" de Duet3d implémente une sonde Z utilisant un capteur de force. On peut définir cette section à la place de `[probe]` pour activer les fonctionnalités spécifiques du Smart Effector. Cela permet également d'activer les [commandes d'exécution](G-Codes.md#smart_effector) afin d'ajuster les paramètres du Smart Effector au moment de son exécution.

```
[smart_effector]
pin:
#    Broche connectée à la broche de sortie de la sonde Z de Smart Effector (broche 5). Notez qu' une
#    résistance de tirage (pullup) sur la carte n'est généralement pas nécessaire. Cependant, si la broche
#    de sortie est connectée à la broche de la carte à l'aide d'une résistance de tirage, cette résistance doit
#    être de valeur élevée (par ex. 10K Ohm ou plus). Certaines cartes ont une résistance de tirage de faible
#    valeur sur l'entrée de la sonde Z, ce qui entraînera probablement un état de sonde toujours déclenché.
#    Dans ce cas, connectez le Smart Effector à une autre broche sur la carte. Ce paramètre est nécessaire.
#control_pin:
#    Broche connectée à la broche d'entrée de contrôle du Smart Effector (broche 7). Si elle est fournie,
#    les commandes de programmation de la sensibilité du Smart Effector deviennent disponibles.
#probe_accel:
#    Si elle est définie, limite l'accélération des mouvements de palpage (en mm/sec^2).
#    Une grande accélération soudaine au début du mouvement de palpage peut provoquer des
#    déclenchements intempestifs de la sonde, surtout si la tête de l'outil est lourde.
#    Pour éviter cela, il peut être nécessaire de réduire l'accélération des mouvements de palpage
#    via ce paramètre.
#recovery_time: 0.4
#    Délai entre les mouvements de déplacement et les mouvements de palpage en secondes. Un
#    déplacement rapide avant le palpage peut entraîner un déclenchement intempestif de celui-ci.
#    Cela peut provoquer des erreurs 'Probe triggered prior to movement' si aucun délai n'est défini.
#    La valeur 0 désactive le délai de récupération.
#    La valeur par défaut est 0,4.
#x_offset:
#y_offset:
#    Doivent être laissés non définis (ou définis à 0).
z_offset:
#    Hauteur de déclenchement de la sonde. Commencez avec -0,1 (mm), et ajustez plus tard en
#    utilisant la commande `PROBE_CALIBRATE`. Ce paramètre doit être fourni.
#speed:
#    Vitesse (en mm/s) de l'axe Z lors du palpage. Il est recommandé de commencer avec une
#    vitesse de palpage de 20 mm/s et d'ajuster si nécessaire pour améliorer la précision et la
#    répétabilité du déclenchement du palpeur.
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#deactivate_on_each_sample:
#    Voir la section "sonde" (probe) pour plus d'informations sur les paramètres ci-dessus.
```

### [probe_eddy_current]

Support for eddy current inductive probes. One may define this section (instead of a probe section) to enable this probe. See the [command reference](G-Codes.md#probe_eddy_current) for further information.

```
[probe_eddy_current my_eddy_probe]
sensor_type: ldc1612
#   The sensor chip used to perform eddy current measurements. This
#   parameter must be provided and must be set to ldc1612.
#intb_pin:
#   MCU gpio pin connected to the ldc1612 sensor's INTB pin (if
#   available). The default is to not use the INTB pin.
#z_offset:
#   The nominal distance (in mm) between the nozzle and bed that a
#   probing attempt should stop at. This parameter must be provided.
#i2c_address:
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   The i2c settings for the sensor chip. See the "common I2C
#   settings" section for a description of the above parameters.
#x_offset:
#y_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   See the "probe" section for information on these parameters.
```

### [axis_twist_compensation]

PROBE

```
[axis_twist_compensation]
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
calibrate_start_x: 20
#   Defines the minimum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the starting
#   calibration position.
calibrate_end_x: 200
#   Defines the maximum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the ending
#   calibration position.
calibrate_y: 112.5
#   Defines the Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle during the
#   calibration process. This parameter is recommended to
#   be near the center of the bed

# For Y-axis twist compensation, specify the following parameters:
calibrate_start_y: ...
#   Defines the minimum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the starting
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_end_y: ...
#   Defines the maximum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the ending
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_x: ...
#   Defines the X coordinate of the calibration for Y axis twist compensation
#   This should be the X coordinate that positions the nozzle during the
#   calibration process for Y axis twist compensation. This parameter must be
#   provided and is recommended to be near the center of the bed.
```

## Moteurs pas à  pas et extrudeurs additionnels

### [stepper_z1]

Axes à moteurs pas à pas multiples. Sur une imprimante de style cartésien, le pilote moteur contrôlant un axe donné peut avoir des blocs de configuration supplémentaires définissant les pilotes moteurs qui doivent être mis en marche de concert avec le pilote principal. On peut définir un nombre quelconque de sections avec un suffixe numérique commençant à 1 (par exemple, "stepper_z1", "stepper_z2", etc.).

```
[stepper_z1]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distanc :
#    Voir la section "stepper" pour la définition des paramètres ci-dessus.
#endstop_pin:
#    Si une endstop_pin est définie pour le moteur supplémentaire, alors le moteur
#    se déplacera à l'origine jusqu'à ce que la fin de course soit déclenchée. Sinon, le
#    moteur se déplacera jusqu'à ce que la fin de course du moteur principal de l'axe
#    soit déclenchée.
```

### [extruder1]

Dans une imprimante multi-extrudeurs, ajoutez une section d'extrudeur supplémentaire pour chaque extrudeur supplémentaire. Les sections d'extrudeur supplémentaires doivent être nommées "extruder1", "extruder2", "extruder3", et ainsi de suite. Voir la section "extruder" pour une description des paramètres disponibles.

Voir [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg) pour un exemple de configuration.

```
[extruder1]
#step_pin:
#dir_pin:
#...
#   Voir la section "extruder" pour les paramètres disponibles pour le pilote de moteur
#   pas à pas et l'élément de chauffe.
#shared_heater:
#   Cette option est obsolète et ne doit plus être utilisée.
```

### [dual_carriage]

Support for cartesian and hybrid_corexy/z printers with dual carriages on a single axis. The carriage mode can be set via the SET_DUAL_CARRIAGE extended g-code command. For example, "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation. Note that during G28 homing, typically the primary carriage is homed first followed by the carriage defined in the `[dual_carriage]` config section. However, the `[dual_carriage]` carriage will be homed first if both carriages home in a positive direction and the [dual_carriage] carriage has a `position_endstop` greater than the primary carriage, or if both carriages home in a negative direction and the `[dual_carriage]` carriage has a `position_endstop` less than the primary carriage.

En outre, on pourrait utiliser les commandes "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY" ou "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR" pour activer le mode copie ou miroir du double chariot, auquel cas il suivra le mouvement du chariot 0 en conséquence. Ces commandes peuvent être utilisées pour imprimer deux pièces simultanément - soit deux pièces identiques (en mode COPY) ou des pièces miroirs (en mode MIRROR). Notez que les modes COPY et MIRROR nécessitent également la configuration appropriée de l'extrudeur sur le double chariot, qui peut généralement être atteint avec "SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=exedual_carriage_extruderю" ou une commande similaire.

Voir [sample-idex.cfg](../config/sample-idex.cfg) pour un exemple de configuration.

```
[dual_carriage]
axis:
#   The axis this extra carriage is on (either x or y). This parameter
#   must be provided.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carraiges), the carriages proximity
#   checks will be disabled.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   See the "stepper" section for the definition of the above parameters.
```

### [extruder_stepper]

Support pour des moteurs supplémentaires synchronisés avec le mouvement d'une extrudeuse (on peut définir un nombre quelconque de sections avec un préfixe "extruder_stepper").

Voir la [référence des commandes](G-Codes.md#extruder) pour plus d'informations.

```
[extrudeur_stepper my_extra_stepper]
extruder:
#    L'extrudeur sur lequel ce pilote moteur est synchronisé. Si ce paramètre est
#    défini sur une chaîne vide, le pilote ne sera pas synchronisé avec un  extrudeur.
#    Ce paramètre doit être fourni.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#    Voir la section "stepper" pour la définition des paramètres
#    ci-dessus.
```

### [manual_stepper]

Pilotes de moteur manuels (on peut définir un nombre quelconque de sections avec le préfixe "manual_stepper"). Ce sont des pilotes de moteur contrôlés par la commande g-code MANUAL_STEPPER. Par exemple "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". Voir le fichier [G-Codes](G-Codes.md#manual_stepper) pour une description de la commande MANUAL_STEPPER. Les pilotes de moteur ne sont pas connectés à la cinématique normale de l'imprimante.

```
[manual_stepper my_stepper]
#step_pin :
#dir_pin :
#enable_pin :
#microsteps :
#rotation_distance :
#    Voir la section "stepper" pour une description de ces paramètres.
#velocity :
#    Définit la vitesse par défaut (en mm/s) pour le pilote moteur. Cette valeur
#    sera utilisée si une commande MANUAL_STEPPER ne spécifie pas de paramètre SPEED
#    La valeur par défaut est 5mm/s.
#accel
#    Définit l'accélération par défaut (en mm/s^2) pour le pilote moteur Une
#    accélération de zéro n'entraînera aucune accélération. Cette valeur
#    sera utilisée si une commande MANUAL_STEPPER ne spécifie pas de
#    paramètre ACCEL. La valeur par défaut est zéro.
#endstop_pin :
#    Broche de détection de l'interrupteur de fin de course. Si elle est spécifiée, on peut effectuer
#    des "mouvements de retour à l'origine" en ajoutant un paramètre STOP_ON_ENDSTOP aux
#    commandes de mouvement MANUAL_STEPPER.
```

## Éléments chauffants et capteurs personnalisés

### [verify_heater]

Vérification de l'élément chauffant et du capteur de température. La vérification des éléments de chauffage est automatiquement activée pour chaque matériel de chauffage configuré sur l'imprimante. Utilisez les sections verify_heater pour modifier les paramètres par défaut.

```
[verify_heater heater_config_name]
#max_error: 120
#    L'erreur de température cumulée maximale avant de déclencher une erreur.
#    Des valeurs plus petites entraînent une vérification plus stricte et des valeurs
#    plus grandes permettent un délai plus long avant qu'une erreur ne soit signalée.
#    Plus précisément, la température est inspectée une fois par seconde et si elle
#    est proche de la température cible, un "compteur d'erreurs" interne est remis
#    à zéro; sinon, si la température est inférieure à la plage cible, le compteur est
#    augmenté de la quantité de température rapportée différant de cette plage. Si
#    le compteur dépasse ce "max_error", une erreur est signalée. La valeur par
#    défaut est 120.
#check_gain_time:
#    Ceci contrôle la vérification du chauffage durant la chauffe initiale. Des valeurs
#    plus petites entraînent une vérification plus stricte et des valeurs plus grandes
#    autorisent un délai plus grand avant qu'une erreur ne soit signalée. Spécifiquement,
#    pendant la chauffe initiale, tant que la température de l'élément chauffant augmente
#    durant ce laps de temps (spécifié en secondes), le "compteur d'erreurs" interne est
#    remis à zéro. La valeur par défaut est de 20 secondes pour les extrudeuses et 60
#    secondes pour le lit chauffant.
#hysteresis: 5
#    La différence de température maximale (en Celsius) par rapport à une température
#    cible considérée comme située dans la plage de la cible. Ceci contrôle la vérification
#    de la plage du paramètre max_error. Il est rare de personnaliser cette valeur.
#   La valeur par défaut est 5.
#heating_gain: 2
#    La température minimale (en Celsius) pour laquelle le chauffage doit progresser
#    pendant la période de check_gain_time. Il est rare de personnaliser cette valeur.
#    La valeur par défaut est 2.
```

### [homing_heaters]

Outil de désactivation des éléments chauffants lors de la prise d'origine ou du palpage d'un axe.

```
[homing_heaters]
#steppers:
#    Une liste de pilotes moteurs séparés par des virgules qui devraient désactiver les chauffages.
#    La valeur par défaut est de désactiver les chauffages pour tout déplacement (mise à
#    l'origine / palpage).
#    Exemple typique : stepper_z
#heaters:
#    Une liste, séparée par des virgules, d'éléments chauffants à désactiver pendant les déplacements
#    (mise à l'origine / palpage). La valeur par défaut est de désactiver tous les éléments chauffants.
#    Exemple typique : extruder, heater_bed
```

### [thermistor]

Thermistances personnalisées (on peut définir un nombre quelconque de sections avec le préfixe "thermistor"). Une thermistance personnalisée peut être utilisée dans le champ sensor_type d'une section de configuration de chauffage. (Par exemple, si l'on définit une section "[thermistor my_thermistor]", on peut utiliser un "sensor_type: my_thermistor" lors de la définition d'un élément de chauffe). Veillez à placer la section thermistor dans le fichier de configuration avant sa première utilisation dans une section de chauffage.

```
[thermistor ma_thermistance]
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#temperature3:
#resistance3:
#    Trois mesures de résistance (en Ohms) aux températures données
#    (en Celsius). Ces trois mesures seront utilisées pour calculer les
#    coefficients de Steinhart-Hart pour la thermistance. Ces paramètres
#    doivent être fournis lors de l'utilisation de Steinhart-Hart pour définir la
#    thermistance.
#beta:
#    Alternativement, on peut définir température1, résistance1, et beta
#    pour définir les paramètres de la thermistance. Ce paramètre doit être
#    fourni lorsque l'on utilise "beta" pour définir la thermistance.
```

### [adc_temperature]

Capteurs de température ADC personnalisés (on peut définir un nombre quelconque de sections avec un préfixe "adc_temperature"). Cela permet de définir un capteur de température personnalisé mesurant une tension sur une broche de convertisseur analogique-numérique (ADC) et utilise une interpolation linéaire entre un ensemble de mesures configurées de température/tension (ou de température/résistance) pour déterminer la température. Le capteur résultant peut être utilisé comme un type de capteur dans une section de chauffage. (Par exemple, si l'on définit une section "[adc_temperature my_sensor]", on peut utiliser un "sensor_type : my_sensor" lors de la définition d'un élément chauffant). Veillez à placer la section du capteur dans le fichier de configuration avant sa première utilisation dans une section de chauffage.

```
[adc_temperature mon_capteur]
#temperature1 :
#voltage1 :
#temperature2 :
#voltage2 :
#...
#    Un ensemble de températures (en Celsius) et de tensions (en Volts) à utiliser comme
#    référence lors de la conversion d'une température. Une section de chauffage utilisant
#    ce capteur peut également spécifier les paramètres adc_voltage et voltage_offset
#    pour définir la tension ADC (voir la section "Amplificateurs communs de température"
#    pour plus de détails). Au moins deux mesures doivent être fournies.
#temperature1 :
#resistance1 :
#temperature2 :
#resistance2 :
#...
#    Alternativement, on peut indiquer un ensemble de températures (en Celsius)
#    et de résistance (en Ohms) à utiliser comme référence lors de la conversion d'une
#    température. Une section de chauffage utilisant ce capteur peut également spécifier un
#    paramètre pullup_resistor (voir la section "extrudeuse" pour plus de détails). Au
#    moins deux mesures doivent être fournies.
```

### [heater_generic]

Éléments de chauffe génériques (on peut définir un nombre quelconque de sections avec le préfixe "heater_generic"). Ces éléments de chauffe se comportent de la même manière que les éléments de chauffe standards (extrudeuses, lits chauffants). Utilisez la commande SET_HEATER_TEMPERATURE (voir [G-Codes](G-Codes.md#heaters) pour plus de détails) pour définir la température cible.

```
[heater_generic my_generic_heater]
#gcode_id:
#    L'identifiant à utiliser pour signaler la température dans la commande M105.
#    Ce paramètre doit être fourni.
#heater_pin:
#max_power:
#sensor_type:
#sensor_pin:
#smooth_time:
#control:
#pid_Kp:
#pid_Ki:
#pid_Kd:
#pwm_cycle_time:
#min_temp:
#max_temp:
#    Voir la section "extruder" pour la définition des paramètres
#    ci-dessus.
```

### [temperature_sensor]

Capteurs de température génériques. On peut définir un nombre quelconque de capteurs de température supplémentaires signalés par la commande M105.

```
[temperature_sensor my_sensor]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#    Voir la section "extrudeuse" pour la définition des paramètres
#   ci-dessus.
#gcode_id:
#    Voir la section "heater_generic" pour la définition de ce
#    paramètre.
```

### [temperature_probe]

Reports probe coil temperature. Includes optional thermal drift calibration for eddy current based probes. A `[temperature_probe]` section may be linked to a `[probe_eddy_current]` by using the same postfix for both sections.

```
[temperature_probe my_probe]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Temperature sensor configuration.
#   See the "extruder" section for the definition of the above
#   parameters.
#smooth_time:
#   A time value (in seconds) over which temperature measurements will
#   be smoothed to reduce the impact of measurement noise. The default
#   is 2.0 seconds.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
#speed:
#   The travel speed [mm/s] for xy moves during calibration.  Default
#   is the speed defined by the probe.
#horizontal_move_z:
#   The z distance [mm] from the bed at which xy moves will occur
#   during calibration. Default is 2mm.
#resting_z:
#   The z distance [mm] from the bed at which the tool will rest
#   to heat the probe coil during calibration.  Default is .4mm
#calibration_position:
#   The X, Y, Z position where the tool should be moved when
#   probe drift calibration initializes.  This is the location
#   where the first manual probe will occur.  If omitted, the
#   default behavior is not to move the tool prior to the first
#   manual probe.
#calibration_bed_temp:
#   The maximum safe bed temperature (in C) used to heat the probe
#   during probe drift calibration.  When set, the calibration
#   procedure will turn on the bed after the first sample is
#   taken.  When the calibration procedure is complete the bed
#   temperature will be set to zero.  When omitted the default
#   behavior is not to set the bed temperature.
#calibration_extruder_temp:
#   The extruder temperature (in C) set probe during drift calibration.
#   When this option is supplied the procedure will wait for until the
#   specified temperature is reached before requesting the first manual
#   probe.  When the calibration procedure is complete the extruder
#   temperature will be set to 0.  When omitted the default behavior is
#   not to set the extruder temperature.
#extruder_heating_z: 50.
#   The Z location where extruder heating will occur if the
#   "calibration_extruder_temp" option is set.  Its recommended to heat
#   the extruder some distance from the bed to minimize its impact on
#   the probe coil temperature.  The default is 50.
#max_validation_temp: 60.
#   The maximum temperature used to validate the calibration.  It is
#   recommended to set this to a value between 100 and 120 for enclosed
#   printers.  The default is 60.
```

## Capteurs de température

Klipper inclut les définitions de nombreux types de capteurs de température. Ces capteurs peuvent être utilisés dans n'importe quelle section de la configuration nécessitant un capteur de température (comme une section `[extruder]` ou `[heater_bed]`).

### Thermistances communes

Thermistances communes. Les paramètres suivants sont disponibles dans les sections de chauffage utilisant l'un de ces capteurs.

```
sensor_type:
#    Un parmi "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
#    "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
#    "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#    "SliceEngineering 450", ou "TDK NTCG104LH104JT1".
sensor_pin:
#    Broche d'entrée analogique connectée à la thermistance. Ce paramètre doit
#    être fourni.
#pullup_resistor: 4700
#    La résistance (en ohms) de tirage (pullup) reliée à la thermistance.
#    La valeur par défaut est 4700 ohms.
#inline_resistor: 0
#    La résistance (en ohms) d'une résistance supplémentaire (ne variant pas en fonction de
#    la chaleur) placée en ligne avec la thermistance. Il est rare de la définir.
#    La valeur par défaut est 0 ohms.
```

### Amplificateurs de température courants

Amplificateurs de température courants. Les paramètres suivants sont disponibles dans les sections de chauffage utilisant l'un de ces capteurs.

```
sensor_type:
#    Un parmi "PT100 INA826", "AD595", "AD597", "AD8494", "AD8495",
#    "AD8496", ou "AD8497".
sensor_pin:
#    Broche d'entrée analogique connectée au capteur. Ce paramètre doit être
#    fourni.
#adc_voltage: 5.0
#    La tension de comparaison ADC (en Volts). La valeur par défaut est de 5 volts.
#voltage_offset: 0
#    Décalage de la tension de l'ADC (en Volts). La valeur par défaut est 0.
```

### Capteur PT1000 directement connecté

Capteur PT1000 connecté en direct. Les paramètres suivants sont disponibles dans les sections chauffage utilisant ces capteurs.

```
sensor_type : PT1000
sensor_pin:
#    Broche d'entrée analogique connectée au capteur. Ce paramètre doit être
#    fourni.
#pullup_resistor: 4700
#    La résistance (en ohms) de tirage (pullup) reliée au capteur. La valeur par
#    défaut est 4700 ohms.
```

### Capteurs de température MAXxxxxx

Capteurs MAXxxxxx à interface périphérique série (SPI) basés sur la température. Les paramètres suivants sont disponibles dans les sections de chauffage qui utilisent l'un de ces types de capteurs.

```
sensor_type :
#    Un parmi les types suivants : "MAX6675", "MAX31855", "MAX31856" ou "MAX31865".
sensor_pin:
#    La broche de sélection de puce pour la puce du capteur. Ce paramètre doit être
#    fourni.
#spi_speed: 4000000
#    La vitesse SPI (en hz) à utiliser lors de la communication avec la puce.
#    La valeur par défaut est 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    Voir la section "paramètres SPI communs" pour une description des
#    paramètres ci-dessus.
#tc_type: K
#tc_use_50Hz_filter: False
#tc_averaging_count: 1
#    Les paramètres ci-dessus contrôlent les paramètres des capteurs des puces MAX31856
#    Les valeurs par défaut de chaque paramètre sont indiquées à côté du nom du paramètre
#    dans la liste ci-dessus.
#rtd_nominal_r: 100
#rtd_reference_r: 430
#rtd_num_of_wires: 2
#rtd_use_50Hz_filter: False
#    Les paramètres ci-dessus contrôlent les paramètres des capteurs des puces MAX31865
#    Les valeurs par défaut de chaque paramètre sont indiquées à côté du nom du paramètre
#    dans la liste ci-dessus.
```

### Capteur de température BMP180/BMP280/BME280/BMP388/BME680

BMP180/BMP280/BME280/BMP388/BME680 two wire interface (I2C) environmental sensors. Note that these sensors are not intended for use with extruders and heater beds, but rather for monitoring ambient temperature (C), pressure (hPa), relative humidity and in case of the BME680 gas level. See [sample-macros.cfg](../config/sample-macros.cfg) for a gcode_macro that may be used to report pressure and humidity in addition to temperature.

```
sensor_type: BME280
#i2c_address:
#   Default is 118 (0x76). The BMP180, BMP388 and some BME280 sensors
#   have an address of 119 (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### AHT10/AHT20/AHT21 capteur de température

AHT10/AHT20/AHT21 : capteurs environnementaux à deux fils (I2C). Notez que ces capteurs ne sont pas destinés à être utilisés avec des extrudeurs et des lits chauffants, mais plutôt pour surveiller la température ambiante (C) et l'humidité relative. Voir [sample-macros.cfg](../config/sample-macros.cfg) pour un gcode_macro qui peut être utilisé pour signaler l'humidité en plus de la température.

```
sensor_type: AHT10
#   Also use AHT10 for AHT20 and AHT21 sensors.
#i2c_address:
#   Default is 56 (0x38). Some AHT10 sensors give the option to use
#   57 (0x39) by moving a resistor.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#aht10_report_time:
#   Interval in seconds between readings. Default is 30, minimum is 5
```

### Capteur HTU21D

Capteur d'environnement de la famille HTU21D à interface à deux fils (I2C). Notez que ce capteur n'est pas destiné à être utilisé avec les extrudeuses et les lits chauffants, mais plutôt à surveiller la température ambiante (C) et l'humidité relative. Voir [sample-macros.cfg](../config/sample-macros.cfg) pour un gcode_macro utilisable permettant d'indiquer l'humidité en plus de la température.

```
sensor_type:
#   Must be "HTU21D" , "SI7013", "SI7020", "SI7021" or "SHT21"
#i2c_address:
#   Default is 64 (0x40).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#htu21d_hold_master:
#   If the sensor can hold the I2C buf while reading. If True no other
#   bus communication can be performed while reading is in progress.
#   Default is False.
#htu21d_resolution:
#   The resolution of temperature and humidity reading.
#   Valid values are:
#    'TEMP14_HUM12' -> 14bit for Temp and 12bit for humidity
#    'TEMP13_HUM10' -> 13bit for Temp and 10bit for humidity
#    'TEMP12_HUM08' -> 12bit for Temp and 08bit for humidity
#    'TEMP11_HUM11' -> 11bit for Temp and 11bit for humidity
#   Default is: "TEMP11_HUM11"
#htu21d_report_time:
#   Interval in seconds between readings. Default is 30
```

### SHT3X sensor

SHT3X family two wire interface (I2C) environmental sensor. These sensors have a range of -55~125 C, so are usable for e.g. chamber temperature monitoring. They can also function as simple fan/heater controllers.

```
sensor_type: SHT3X
#i2c_address:
#   Default is 68 (0x44).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### Capteur de température LM75

Capteurs de température LM75/LM75A connectés en deux fils (I2C). Ces capteurs ont une gamme de -55~125 °C, et sont donc utilisables par exemple pour la surveillance de la température d'une chambre. Ils peuvent aussi fonctionner comme de simples contrôleurs de ventilateurs/éléments chauffants.

```
sensor_type: LM75
#i2c_address:
#   Default is 72 (0x48). Normal range is 72-79 (0x48-0x4F) and the 3
#   low bits of the address are configured via pins on the chip
#   (usually with jumpers or hard wired).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#lm75_report_time:
#   Interval in seconds between readings. Default is 0.8, with minimum
#   0.5.
```

### Capteur de température intégré au microcontrôleur

Les micro-contrôleurs atsam, atsamd, et stm32 possèdent un capteur de température interne. On peut utiliser le capteur "temperature_mcu" pour surveiller ces températures.

```
sensor_type: temperature_mcu
#sensor_mcu: mcu
#    Le micro-contrôleur à lire. La valeur par défaut est "mcu".
#sensor_temperature1:
#sensor_adc1:
#    Spécifiez les deux paramètres ci-dessus (une température en Celsius et une valeur d' ADC sous
#    forme de flottant entre 0,0 et 1,0) pour calibrer la température du microcontrôleur. Cela peut
#    améliorer la précision de la température rapportée sur certaines puces. Une façon typique d'obtenir
#    ces informations d'étalonnage est de couper complètement l'alimentation de l'imprimante pendant
#    quelques heures (afin de s'assurer qu'elle est à la température ambiante), puis de la remettre sous
#    tension et d'utiliser la fonction QUERY_ADC pour obtenir une mesure ADC.
#    Utilisez un autre capteur de température sur l'imprimante pour trouver la température ambiante
#    correspondante. La valeur par défaut est d'utiliser les données d'étalonnage d'usine du microcontrôleur
#    (le cas échéant) ou les valeurs nominales de la spécification du microcontrôleur.
#sensor_temperature2:
#sensor_adc2:
#    Si sensor_temperature1/sensor_adc1 est spécifié, on peut également spécifier les données
#    d'étalonnage de sensor_temperature2/sensor_adc2. En procédant ainsi on peut fournir des
#    informations calibrées sur la "pente de température". La valeur par défaut est d'utiliser les données
#    d'étalonnage d'usine sur le microcontrôleur (le cas échéant) ou les valeurs nominales de la
#    spécification du microcontrôleur.
```

### Capteur de température de l'hôte

Température de la machine (par exemple Raspberry Pi) exécutant le logiciel hôte.

```
sensor_type: temperature_host
#sensor_path:
#    Le chemin d'accès au fichier système de température. La valeur par défaut est
#    " /sys/class/thermal/thermal_zone0/temp " qui est le fichier système de
#    température sur un ordinateur Raspberry Pi.
```

### Capteur de température DS18B20

Le DS18B20 est un capteur de température numérique à 1 fil (w1). Notez que ce capteur n'est pas destiné à être utilisé avec les extrudeurs et les lits chauffants, mais plutôt pour surveiller la température ambiante (C). Ces capteurs ont une portée allant jusqu'à 125 °C et sont donc utilisables pour la surveillance de la température d'un caisson par exemple. Ils peuvent également fonctionner comme de simples contrôleurs de ventilateurs/éléments chauffants. Les capteurs DS18B20 ne sont supportés que par un "mcu hôte", par exemple le Raspberry Pi. Le module w1-gpio du noyau Linux doit être installé.

```
sensor_type: DS18B20
serial_no:
#    Chaque dispositif à 1-wire possède un numéro de série unique utilisé pour l'identifier,
#    généralement au format 28-031674b175ff. Ce paramètre doit être fourni.
#    Les périphériques 1-wire connectés peuvent être listés à l'aide de la commande Linux suivante :
#        ls /sys/bus/w1/devices/
#ds18_report_time:
#    Intervalle en secondes entre les lectures. La valeur par défaut est de 3,0, avec un minimum de 1,0.
#sensor_mcu:
#    Le micro-contrôleur à lire. Doit être le host_mcu
```

### Capteur de température combiné

Le capteur de température combiné est un capteur virtuel basé sur plusieurs autres capteurs Ce capteur peut être utilisé avec des extrudeurs, des chauffages génériques et des plateaux chauffants.

```
sensor_type: temperature_combined
#sensor_list:
#   Must be provided. List of sensors to combine to new "virtual"
#   sensor.
#   E.g. 'temperature_sensor sensor1,extruder,heater_bed'
#combination_method:
#   Must be provided. Combination method used for the sensor.
#   Available options are 'max', 'min', 'mean'.
#maximum_deviation:
#   Must be provided. Maximum permissible deviation between the sensors
#   to combine (e.g. 5 degrees). To disable it, use a large value (e.g. 999.9)
```

## Ventilateurs

### [fan]

Ventilateur de refroidissement de la pièce.

```
[fan]
pin:
#   Broche de sortie contrôlant le ventilateur. Ce paramètre doit être fourni.
#max_power: 1.0
#    La puissance maximale (exprimée en tant que valeur comprise entre 0,0 et 1,0) à laquelle
#    régler la broche. La valeur 1.0 permet de régler la broche entièrement activée pendant de
#    longues périodes, tandis qu'une valeur de 0,5 permet à la broche de n'être activée que
#    durant la moitié du temps au maximum. Ce paramètre peut être utilisé pour limiter la
#    puissance totale de sortie (sur des périodes prolongées) du ventilateur.
#    Si cette valeur est inférieure à 1,0, les demandes de vitesse du ventilateur seront mises à
#    l'échelle entre zéro et max_power (par exemple, si la puissance maximale est de 0,9 et
#    qu'une vitesse de 80 % est demandée, la puissance du ventilateur sera réglée à 72 %.
#    La valeur par défaut est 1.0.
#shutdown_speed: 0
#    La vitesse souhaitée du ventilateur (exprimée comme une valeur de 0,0 à 1,0) si
#    le logiciel du microcontrôleur passe dans un état d'erreur. La valeur par défaut
#    est 0.
#cycle_time: 0.010
#    La durée (en secondes) de chaque cycle d'alimentation PWM du ventilateur. Il est
#    recommandé que cette durée soit de 10 millisecondes ou plus si vous utilisez un PWM logiciel.
#    La valeur par défaut est de 0,010 seconde.
#hardware_pwm: False
#    Activez ceci pour utiliser le PWM matériel au lieu du PWM logiciel. La plupart des ventilateurs
#    ne fonctionnent pas correctement avec le PWM matériel, il n'est donc pas recommandé
#    d'activer cette option à moins qu'il n'y ait une exigence électrique pour obtenir une très haute
#    vitesse. Lorsque vous utilisez le PWM matériel, le temps de cycle réel est contraint par la mise
#    en œuvre et peut être significativement différent du temps de cycle demandé.
#    La valeur par défaut est False.
#kick_start_time: 0.100
#    Durée (en secondes) de fonctionnement du ventilateur à pleine vitesse, soit lors de sa première
#    activation soit lors d'une augmentation de plus de 50% (pour faire tourner le ventilateur).
#    La valeur par défaut est de 0,100 seconde.
#off_below: 0.0
#    La vitesse d'entrée minimale qui alimentera le ventilateur (exprimée comme une valeur
#    comprise entre 0,0 et 1,0). Quand une vitesse inférieure à off_below est demandée le ventilateur
#    sera désactivé. Ce réglage peut être utilisé pour éviter que le ventilateur ne cale et pour
#    garantir que les démarrages sont efficaces.
#    La valeur par défaut est 0.0.
#
#    Ce paramètre doit être recalibré chaque fois que max_power est ajusté.
#    Pour calibrer ce paramètre, commencez avec off_below réglé sur 0.0 et ventilateur tournant. Diminuez
#    progressivement la vitesse du ventilateur afin de déterminer la vitesse d'entrée la plus faible entraînant
#    le ventilateur de manière fiable sans décrochage. Réglez off_below au rapport cyclique correspondant
#    à cette valeur (par exemple, 12% -> 0,12) ou légèrement plus.
#tachometer_pin:
#    Broche d'entrée tachymétrique de surveillance de la vitesse du ventilateur. Un pullup est généralement
#    nécessaire. Ce paramètre est facultatif.
#tachometer_ppr: 2
#    Lorsque tachometer_pin est spécifié, il s'agit du nombre d'impulsions par révolution du signal
#    tachymétrique. Pour un ventilateur BLDC, c'est normalement la moitié du nombre de pôles.
#    La valeur par défaut est 2.
#tachometer_poll_interval: 0.0015
#    Lorsque tachometer_pin est spécifié, il s'agit de la période d'interrogation de la broche tachymétrique,
#    en secondes. La valeur par défaut est 0.0015, ce qui est suffisamment rapide pour des ventilateurs de
#    moins de 10000 RPM à 2 PPR. Cette valeur doit être inférieure à 30/(tachometer_ppr*rpm), avec une
#    certaine marge, où rpm est la vitesse maximale (en RPM) du ventilateur.
#enable_pin:
#    Broche optionnelle pour d'activation de l'alimentation du ventilateur. Cela peut être utile pour les
#    ventilateurs avec des entrées PWM dédiées. Certains de ces ventilateurs restent allumés même à 0 %
#    de PWM. Dans ce cas, la broche PWM peut être utilisée normalement et, par exemple, un FET commuté
#    à la masse (broche de ventilateur standard) peut être utilisé pour contrôler l'alimentation du ventilateur.
```

### [heater_fan]

Ventilateurs de chauffage (on peut définir un nombre quelconque de sections avec le préfixe "heater_fan"). Un "ventilateur de chauffage" est un ventilateur activé lorsque le chauffage qui lui est associé est actif. Par défaut, un heater_fan a une vitesse d'arrêt égale à la puissance maximale.

```
[heater_fan heatbreak_cooling_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#   See the "fan" section for a description of the above parameters.
#heater: extruder
#   Name of the config section defining the heater that this fan is
#   associated with. If a comma separated list of heater names is
#   provided here, then the fan will be enabled when any of the given
#   heaters are enabled. The default is "extruder".
#heater_temp: 50.0
#   A temperature (in Celsius) that the heater must drop below before
#   the fan is disabled. The default is 50 Celsius.
#fan_speed: 1.0
#   The fan speed (expressed as a value from 0.0 to 1.0) that the fan
#   will be set to when its associated heater is enabled. The default
#   is 1.0
```

### [controller_fan]

Ventilateur de refroidissement du contrôleur (on peut définir un nombre quelconque de sections avec le préfixe "controller_fan"). Un "ventilateur de contrôleur" est un ventilateur activé chaque fois que l'élément chauffant ou le pilote pas à pas qui lui est associé est actif. Le ventilateur s'arrêtera chaque fois qu'un idle_timeout sera atteint afin de garantir qu'aucune surchauffe ne se produise après la désactivation d'un composant surveillé.

```
[controller_fan my_controller_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#   Voir la section "fan" pour une description des paramètres ci-dessus.
#fan_speed: 1.0
#   Vitesse du ventilateur (exprimée comme une valeur de 0,0 à 1,0) à laquelle celui-ci
#   sera réglé lorsqu'un chauffage ou un pilote pas à pas est actif.
#   La valeur par défaut est 1.0
#idle_timeout:
#   Durée (en secondes) après activité d'un pilote pas à pas ou d'un élément chauffant
#   pour laquelle le ventilateur doit continuer de fonctionner. La valeur par défaut
#   est de 30 secondes.
#idle_speed:
#   Vitesse du ventilateur (exprimée comme une valeur de 0,0 et 1,0) à laquelle le régler
#   lors de l'activité d'une chauffe ou d'un pilote pas à pas avant que le délai d'attente
#   idle_timeout ne soit atteint. La valeur par défaut est fan_speed.
#heater:
#stepper :
#   Nom de la section de configuration définissant l'élément chauffant/pilote auquel ce ventilateur
#   est associé. Si une liste séparée par des virgules de noms d'éléments chauffants/pilotes est
#   fournie ici, le ventilateur s'activera lorsque l'un des éléments chauffants/pilotes donnés est activé.
#   Le chauffage par défaut est "extruder", le pilote par défaut est tous.
```

### [temperature_fan]

Ventilateurs de refroidissement déclenchés en fonction de la température (on peut définir un nombre quelconque de sections avec le préfixe "temperature_fan"). Un "ventilateur de température" est un ventilateur activé lorsque le capteur qui lui est associé est au-dessus d'une température définie. Par défaut, un ventilateur de température a une vitesse d'arrêt égale à la puissance maximale.

Voir la [référence des commandes](G-Codes.md#temperature_fan) pour plus d'informations.

```
[temperature_fan my_temp_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#    Voir la section "ventilateur" pour une description des paramètres ci-dessus.
#sensor_type:
#sensor_pin:
#control:
#max_delta:
#min_temp:
#max_temp:
#    Voir la section "extrudeuse" pour une description des paramètres ci-dessus.
#pid_Kp:
#pid_Ki:
#pid_Kd:
#    Les paramètres proportionnels (pid_Kp), intégraux (pid_Ki), et dérivés (pid_Ki)
#    du système de contrôle par rétroaction PID. Klipper évalue les paramètres PID
#    avec la formule générale suivante :
#        fan_pwm = max_power - (Kp*e + Ki*integral(e) - Kd*derivative(e)) / 255
#    Où "e" est "température_cible - température_mesurée" et
#    "fan_pwm" est le débit du ventilateur demandé, 0,0 correspondant à un arrêt complet
#    et 1,0 correspond à un fonctionnement à plein régime. Les paramètres pid_Kp, pid_Ki,
#    et pid_Kd doivent être fournis lorsque l'algorithme de contrôle PID est activé.
#pid_deriv_time: 2.0
#    Une durée (en secondes) sur laquelle lisser les mesures de température lors de
#    l'utilisation de l'algorithme de contrôle PID. Cela peut réduire l'impact du bruit de
#    mesure. La valeur par défaut est de 2 secondes.
#target_temp: 40.0
#    Une température (en Celsius) qui sera la température cible.
#    La valeur par défaut est 40 degrés.
#max_speed: 1.0
#    La vitesse du ventilateur (exprimée comme une valeur de 0,0 à 1,0) à laquelle régler
#    le ventilateur lorsque la température du capteur dépassera la valeur définie.
#    La valeur par défaut est 1.0.
#min_speed: 0.3
#    Vitesse minimale du ventilateur (exprimée sous forme d'une valeur comprise entre 0,0
#    et 1,0) à laquelle régler le ventilateur pour les ventilateurs à température PID.
#    La valeur par défaut est 0,3.
#gcode_id:
#    S'il est défini, la température sera signalée dans les requêtes M105 en utilisant l'identifiant
#    d'id donné. La valeur par défaut est de ne pas rapporter la température via M105.
```

### [fan_generic]

Ventilateur commandé manuellement (on peut définir un nombre quelconque de sections avec le préfixe "fan_generic"). La vitesse d'un ventilateur commandé manuellement est réglée avec la commande SET_FAN_SPEED [commandes G-Code](G-Codes.md#fan_generic).

```
[fan_generic extruder_partfan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#   Voir la section "ventilateur" pour une description des paramètres ci-dessus.
```

## LEDs

### [led]

Prise en charge des LEDs (et des bandes de LEDs) contrôlées par les broches PWM du microcontrôleur (on peut définir un nombre quelconque de sections avec le préfixe "led"). Voir la [référence de la commande](G-Codes.md#led) pour plus d'informations.

```
[led my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
#    La broche contrôlant la couleur de la LED donnée. Au moins un des paramètres ci-dessus
#    doit être fourni.
#cycle_time: 0.010
#    Durée (en secondes) par cycle PWM. Il est recommandé
#    que ce soit 10 millisecondes ou plus lorsque l'on utilise un PWM logiciel.
#    La valeur par défaut est de 0,010 seconde.
#hardware_pwm: False
#    Activez ceci pour utiliser le PWM matériel au lieu du PWM logiciel. Lors de
#    l'utilisation du PWM matériel, le temps de cycle réel est contraint par
#    l'implémentation et peut être significativement différent du
#    cycle_time demandé. La valeur par défaut est False.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#    Définit la couleur initiale de la LED. Chaque valeur doit être comprise entre 0.0 et
#    1.0. La valeur par défaut pour chaque couleur est 0.
```

### [neopixel]

Prise en charge des LED neopixel (alias WS2812) (on peut définir un nombre quelconque de sections avec le préfixe "neopixel"). Voir la [référence de commande](G-Codes.md#led) pour plus d'informations.

Notez que l'implémentation du [mcu linux](RPi_microcontroller.md) ne supporte pas actuellement les neopixels directement connectés. La conception actuelle utilisant l'interface du noyau Linux ne permet pas ce scénario car l'interface GPIO du noyau n'est pas assez rapide pour fournir les taux d'impulsion requis.

```
[neopixel my_neopixel]
pin:
#    La broche connectée au neopixel. Ce paramètre doit être
#    fourni.
#chain_count:
#    Le nombre de puces Neopixel connectées en "chaîne" à la broche fournie.
#    La valeur par défaut est 1 (ce qui indique qu'un seul Neopixel est connecté à la broche).
#color_order:  GRB
#    Définit l'ordre des pixels requis par le matériel LED (en utilisant une chaîne
#    contenant les lettres R, G, B, W avec W en option). Alternativement, il peut s'agir d'une liste
#    d'ordres de pixels séparés par des virgules - un pour chaque LED de la chaîne.
#    La valeur par défaut est GRB.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#    Voir la section "led" pour des informations sur ces paramètres.
```

### [dotstar]

Prise en charge des LEDs Dotstar (alias APA102) (on peut définir un nombre quelconque de sections avec le préfixe "dotstar"). Voir la [référence de commande](G-Codes.md#led) pour plus d'informations.

```
[dotstar my_dotstar]
data_pin:
#    La broche connectée à la ligne de données du dotstar. Ce paramètre
#    doit être fourni.
clock_pin:
#   La broche connectée à la ligne d'horloge du dotstar. Ce paramètre
#   doit être fourni.
#chain_count:
#   Voir la section "neopixel" pour des informations sur ce paramètre.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#   Voir la section "led" pour des informations sur ces paramètres.
```

### [pca9533]

Support de la LED PCA9533. Le PCA9533 est utilisé sur la mightyboard.

```
[pca9533 my_pca9533]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. Use 98 for
#   the PCA9533/1, 99 for the PCA9533/2. The default is 98.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

### [pca9632]

Support des LEDs du PCA9632. Le PCA9632 est utilisé sur le FlashForge Dreamer.

```
[pca9632 my_pca9632]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. This may be
#   96, 97, 98, or 99.  The default is 98.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#scl_pin:
#sda_pin:
#   Alternatively, if the pca9632 is not connected to a hardware I2C
#   bus, then one may specify the "clock" (scl_pin) and "data"
#   (sda_pin) pins. The default is to use hardware I2C.
#color_order: RGBW
#   Set the pixel order of the LED (using a string containing the
#   letters R, G, B, W). The default is RGBW.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

## Servos supplémentaires, boutons et autres broches

### [servo]

Servos (on peut définir un nombre quelconque de sections avec le préfixe "servo"). Les servos peuvent être contrôlés en utilisant la commande SET_SERVO [g-code](G-Codes.md#servo). Par exemple : SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
pin:
#    Broche de sortie PWM contrôlant le servo. Ce paramètre doit être
#    fourni.
#maximum_servo_angle: 180
#    L'angle maximum (en degrés) auquel ce servo peut être réglé. La valeur
#    par défaut est de 180 degrés.
#minimum_pulse_width: 0.001
#    La durée minimale de la largeur d'impulsion (en secondes). Cela devrait correspondre
#    avec un angle de 0 degré. La valeur par défaut est de 0,001 seconde.
#maximum_pulse_width: 0.002
#    La durée maximale de la largeur d'impulsion (en secondes). Cela devrait correspondre
#    avec l'angle de maximum_servo_angle. La valeur par défaut est 0.002 secondes.
#initial_angle:
#    Angle initial (en degrés) sur lequel régler le servo. La valeur par défaut est de
#    ne pas envoyer de signal au démarrage.
#initial_pulse_width:
#    Durée initiale de la largeur d'impulsion (en secondes) à laquelle le servo doit être réglé. (Ceci
#    n'est valable que si initial_angle n'est pas défini). La valeur par défaut est de n'envoyer
#    aucun signal au démarrage.
```

### [gcode_button]

Exécute le gcode quand un bouton est pressé ou relâché (ou quand une broche change d'état). Vous pouvez vérifier l'état du bouton en utilisant `QUERY_BUTTON button=my_gcode_button`.

```
[gcode_button my_gcode_button]
pin:
#    La broche sur laquelle le bouton est connecté. Ce paramètre doit être
#    fourni.
#analog_range:
#    Deux résistances séparées par des virgules (en Ohms) spécifiant la plage de
#    résistance minimale et maximale de la résistance du bouton. Si le paramètre
#    analog_range est fourni, la broche doit être une broche à capacité analogique.
#    La valeur par défaut est d'utiliser un gpio numérique pour le bouton.
#analog_pullup_resistor:
#    La résistance d'excursion (en Ohms) lorsque la gamme analogique est spécifiée.
#    La valeur par défaut est 4700 ohms.
#press_gcode:
#    Une liste de commandes G-Code à exécuter lorsque le bouton est pressé.
#    Les modèles G-Code sont pris en charge. Ce paramètre doit être fourni.
#release_gcode:
#    Une liste de commandes G-code à exécuter lorsque le bouton est relâché.
#    Les modèles G-Code sont supportés. La valeur par défaut est de ne pas exécuter
#    de commandes lors du relâchement d'un bouton.
```

### [output_pin]

Broches de sortie configurables à l'exécution (on peut définir un nombre quelconque de sections avec un préfixe "output_pin"). Les broches configurées ici seront paramétrées comme des broches de sortie modifiables au moment de l'exécution en utilisant des [commandes g-code étendues](G-Codes.md#output_pin) de type "SET_PIN PIN=my_pin VALUE=.1"

```
[output_pin my_pin]
pin:
#   The pin to configure as an output. This parameter must be
#   provided.
#pwm: False
#   Set if the output pin should be capable of pulse-width-modulation.
#   If this is true, the value fields should be between 0 and 1; if it
#   is false the value fields should be either 0 or 1. The default is
#   False.
#value:
#   The value to initially set the pin to during MCU configuration.
#   The default is 0 (for low voltage).
#shutdown_value:
#   The value to set the pin to on an MCU shutdown event. The default
#   is 0 (for low voltage).
#cycle_time: 0.100
#   The amount of time (in seconds) per PWM cycle. It is recommended
#   this be 10 milliseconds or greater when using software based PWM.
#   The default is 0.100 seconds for pwm pins.
#hardware_pwm: False
#   Enable this to use hardware PWM instead of software PWM. When
#   using hardware PWM the actual cycle time is constrained by the
#   implementation and may be significantly different than the
#   requested cycle_time. The default is False.
#scale:
#   This parameter can be used to alter how the 'value' and
#   'shutdown_value' parameters are interpreted for pwm pins. If
#   provided, then the 'value' parameter should be between 0.0 and
#   'scale'. This may be useful when configuring a PWM pin that
#   controls a stepper voltage reference. The 'scale' can be set to
#   the equivalent stepper amperage if the PWM were fully enabled, and
#   then the 'value' parameter can be specified using the desired
#   amperage for the stepper. The default is to not scale the 'value'
#   parameter.
#maximum_mcu_duration:
#static_value:
#   These options are deprecated and should no longer be specified.
```

### [pwm_tool]

Pulse width modulation digital output pins capable of high speed updates (one may define any number of sections with an "output_pin" prefix). Pins configured here will be setup as output pins and one may modify them at run-time using "SET_PIN PIN=my_pin VALUE=.1" type extended [g-code commands](G-Codes.md#output_pin).

```
[pwm_tool my_tool]
pin:
#   The pin to configure as an output. This parameter must be provided.
#maximum_mcu_duration:
#   The maximum duration a non-shutdown value may be driven by the MCU
#   without an acknowledge from the host.
#   If host can not keep up with an update, the MCU will shutdown
#   and set all pins to their respective shutdown values.
#   Default: 0 (disabled)
#   Usual values are around 5 seconds.
#value:
#shutdown_value:
#cycle_time: 0.100
#hardware_pwm: False
#scale:
#   See the "output_pin" section for the definition of these parameters.
```

### [pwm_cycle_time]

Run-time configurable output pins with dynamic pwm cycle timing (one may define any number of sections with an "pwm_cycle_time" prefix). Pins configured here will be setup as output pins and one may modify them at run-time using "SET_PIN PIN=my_pin VALUE=.1 CYCLE_TIME=0.100" type extended [g-code commands](G-Codes.md#pwm_cycle_time).

```
[pwm_cycle_time my_pin]
pin:
#value:
#shutdown_value:
#cycle_time: 0.100
#scale:
#   See the "output_pin" section for information on these parameters.
```

### [static_digital_output]

Broches de sortie numérique configurées statiquement (on peut définir un nombre quelconque de sections avec un préfixe "static_digital_output"). Les broches configurées ici seront configurées comme une sortie GPIO pendant la configuration du MCU. Elles ne peuvent pas être modifiées en cours d'exécution.

```
[static_digital_output my_output_pins]
pins :
#    Une liste de broches séparées par des virgules à définir comme broches de sortie GPIO. La broche
#    sera définie à un niveau haut, sauf si le nom de la broche est précédé de " !".
#    Ce paramètre doit être fourni.
```

### [multi_pin]

Sorties à broches multiples (on peut définir un nombre quelconque de sections avec le préfixe "multi_pin"). Une sortie multi_pin crée un alias de broche interne pouvant modifier plusieurs broches de sortie chaque fois que la broche alias est définie. Par exemple, on peut définir un objet "[multi_pin my_fan]" contenant deux broches et ensuite définir "pin=multi_pin:my_fan" dans la section "[fan]" - à chaque changement du ventilateur, les deux broches de sortie seront mises à jour. Ces alias ne peuvent pas être utilisés avec des broches de moteur pas à pas.

```
[multi_pin my_multi_pin]
pins:
#    Une liste séparée par des virgules des broches associées à cet alias. Ce paramètre
#    doit être fourni.
```

## Configuration des pilotes pas à pas TMC

Configuration des pilotes de moteurs pas à pas Trinamic en mode UART/SPI. Des informations supplémentaires sont disponibles dans le [guide des pilotes TMC](TMC_Drivers.md) et dans la [référence des commandes](G-Codes.md#tmcxxxx).

### [tmc2130]

Configuration d' un pilote de moteur pas à pas TMC2130 via le bus SPI. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2130" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2130 stepper_x]").

```
[tmc2130 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2130 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 0
#driver_TBL: 1
#driver_TOFF: 4
#driver_HEND: 7
#driver_HSTRT: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 4
#driver_PWM_AMPL: 128
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#   Set the given register during the configuration of the TMC2130
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2130 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2130_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2208]

Configuration d'un pilote de moteur pas à pas TMC2208 (ou TMC2224) via un UART à fil unique. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2208" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2208 stepper_x]").

```
[tmc2208 stepper_x]
uart_pin:
#   The pin connected to the TMC2208 PDN_UART line. This parameter
#   must be provided.
#tx_pin:
#   If using separate receive and transmit lines to communicate with
#   the driver then set uart_pin to the receive pin and tx_pin to the
#   transmit pin. The default is to use uart_pin for both reading and
#   writing.
#select_pins:
#   A comma separated list of pins to set prior to accessing the
#   tmc2208 UART. This may be useful for configuring an analog mux for
#   UART communication. The default is to not configure any pins.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#   Set the given register during the configuration of the TMC2208
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
```

### [tmc2209]

Configuration d'un pilote de moteur pas à pas TMC2209 via un UART à fil unique. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2209" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2209 stepper_x]").

```
[tmc2209 stepper_x]
uart_pin:
#tx_pin:
#select_pins:
#interpolate: True
run_current:
#hold_current:
#sense_resistor: 0.110
#stealthchop_threshold: 0
#   See the "tmc2208" section for the definition of these parameters.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#uart_address:
#   The address of the TMC2209 chip for UART messages (an integer
#   between 0 and 3). This is typically used when multiple TMC2209
#   chips are connected to the same UART pin. The default is zero.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#driver_SGTHRS: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#   Set the given register during the configuration of the TMC2209
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag_pin:
#   The micro-controller pin attached to the DIAG line of the TMC2209
#   chip. The pin is normally prefaced with "^" to enable a pullup.
#   Setting this creates a "tmc2209_stepper_x:virtual_endstop" virtual
#   pin which may be used as the stepper's endstop_pin. Doing this
#   enables "sensorless homing". (Be sure to also set driver_SGTHRS to
#   an appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2660]

Configuration d'un pilote de moteur pas à pas TMC2660 via le bus SPI. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2660" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2660 stepper_x]").

```
[tmc2660 stepper_x]
cs_pin:
#    La broche correspondant à la ligne de sélection de la puce TMC2660. Cette
#    broche sera mise à l'état bas au début des messages SPI et passera à l'état
#    haut après la fin du transfert du message. Ce paramètre doit être fourni.
#spi_speed: 4000000
#    Fréquence du bus SPI utilisée pour communiquer avec le pilote de pas à pas
#    TMC2660. La valeur par défaut est 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    Voir la section "paramètres SPI communs" pour une description des
#    paramètres ci-dessus.
#interpolate: True
#    Si vrai, active l'interpolation par pas (le pilote fera un pas interne à un taux
#    de 256 micro-pas). Cela ne fonctionne que si les micro-pas sont fixés à 16.
#    L'interpolation introduit une petite déviation de position systémique - voir
#    TMC_Drivers.md pour plus de détails. La valeur par défaut est True.
run_current:
#    La quantité de courant (en ampères RMS) utilisée par le pilote pendant le
#    déplacement du moteur pas à pas. Ce paramètre doit être fourni.
#sense_resistor:
#    La résistance (en ohms) de la résistance de détection du moteur (Vréf). Ce
#    paramètre doit être fourni.
#idle_current_percent  100
#    Le pourcentage du courant de fonctionnement auquel le pilote pas à pas
#    sera abaissé quand le délai d'inactivité expirera (vous devez configurer le
#    délai à l'aide d'une section de configuration [idle_timeout]). Le courant sera
#    remonté dès que le moteur devra à nouveau se déplacer. Assurez-vous de
#    définir une valeur suffisamment élevée pour que les moteurs ne perdent pas
#    leur position. Il y a également un petit délai avant que le courant ne soit remis,
#    il faut donc en tenir compte lors de demandes de mouvements rapides alors
#    que le pilote est inactif. La valeur par défaut est 100 (aucune réduction).
#driver_TBL: 2
#driver_RNDTF: 0
#driver_HDEC: 0
#driver_CHM: 0
#driver_HEND: 3
#driver_HSTRT: 3
#driver_TOFF: 4
#driver_SEIMIN: 0
#driver_SEDN: 0
#driver_SEMAX: 0
#driver_SEUP: 0
#driver_SEMIN: 0
#driver_SFILT: 0
#driver_SGT: 0
#driver_SLPH: 0
#driver_SLPL: 0
#driver_DISS2G: 0
#driver_TS2G: 3
#    Définit les paramètres à utiliser pendant la configuration de la puce TMC2660.
#    Ceci peut être utilisé pour définir des paramètres de pilote personnalisés. Les
#    valeurs par défaut de chaque paramètre sont indiquées à côté du nom du paramètre
#    dans la liste ci-dessus. Consultez la fiche technique du TMC2660 pour connaître la
#    fonction de chaque paramètre ainsi que les restrictions sur les combinaisons de
#    paramètres. Soyez particulièrement attentif au registre CHOPCONF, où le fait de
#    régler CHM à soit zéro, soit un, entraîne des modifications de la disposition (le
#    premier bit de HDEC est interprété comme le MSB de HSTRT dans ce cas).
```

### [tmc2240]

Configure a TMC2240 stepper motor driver via SPI bus or UART. To use this feature, define a config section with a "tmc2240" prefix followed by the name of the corresponding stepper config section (for example, "[tmc2240 stepper_x]").

```
[tmc2240 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2240 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#uart_pin:
#   The pin connected to the TMC2240 DIAG1/SW line. If this parameter
#   is provided UART communication is used rather then SPI.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#rref: 12000
#   The resistance (in ohms) of the resistor between IREF and GND. The
#   default is 12000.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#driver_OFFSET_SIN90: 0
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#   Additionally, this driver also has the OFFSET_SIN90 field which can be used
#   to tune a motor with unbalanced coils. See the `Sine Wave Lookup Table`
#   section in the datasheet for information about this field and how to tune
#   it.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_IRUNDELAY: 4
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 29
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_SG4_ANGLE_OFFSET: 1
#driver_SLOPE_CONTROL: 0
#   Set the given register during the configuration of the TMC2240
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2240 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2240_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc5160]

Configuration d'un pilote de moteur pas à pas TMC5160 via le bus SPI. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc5160" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc5160 stepper_x]").

```
[tmc5160 stepper_x]
cs_pin:
#   The pin corresponding to the TMC5160 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.075
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.075 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 30
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_DRVSTRENGTH: 0
#driver_BBMCLKS: 4
#driver_BBMTIME: 0
#driver_FILT_ISENSE: 0
#   Set the given register during the configuration of the TMC5160
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC5160 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc5160_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

## Configuration du courant du moteur pas à pas en temps réel

### [ad5206]

Digipots AD5206 configurés statiquement et connectés via un bus SPI (on peut définir un nombre quelconque de sections avec un préfixe "ad5206").

```
[ad5206 my_digipot]
enable_pin :
#    La broche correspondant à la ligne de sélection de la puce AD5206. Cette broche
#    sera réglée à un niveau bas au début des messages SPI et sera relevée à un niveau élevé
#    après la fin du message. Ce paramètre doit être fourni.
#spi_speed :
#spi_bus :
#spi_software_sclk_pin :
#spi_software_mosi_pin :
#spi_software_miso_pin :
#    Voir la section "paramètres communs SPI" pour une description des paramètres ci-dessus.
#
#channel_1 :
#channel_2 :
#channel_3 :
#channel_4 :
#channel_5 :
#channel_6 :
#     La valeur pour définir statiquement le canal AD5206 donné. Cette valeur est
#     généralement définie sur un nombre compris entre 0,0 et 1,0. 1,0 étant la résistance
#     la plus élevée et 0,0 la résistance la plus faible. Cependant,  la plage peut être
#     modifiée à l'aide du paramètre 'scale' (voir ci-dessous).
#     Si un canal n'est pas spécifié, il n'est pas configuré.
# scale :
#    Ce paramètre peut être utilisé pour modifier l'interprétation des paramètres 'channel_x'.
#    S'il est fourni, alors les paramètres 'channel_x' doivent être compris entre 0.0 et 'scale'.
#    Cela peut être utile lorsque le AD5206 est utilisé pour définir des références de tension
#    pas à pas. L''échelle' peut être réglée sur l'intensité équivalente de la commande pas à pas
#    si l'AD5206 était à sa résistance la plus élevée, puis les paramètres 'channel_x' peuvent être
#    spécifiés en utilisant la valeur d'intensité désirée pour le pilote pas à pas. La configuration
#    par défaut est de ne pas mettre à l'échelle les paramètres 'channel_x'.
```

### [mcp4451]

Digipot MCP4451 configuré statiquement et connecté via le bus I2C (on peut définir un nombre quelconque de sections avec un préfixe "mcp4451").

```
[mcp4451 my_digipot]
i2c_address:
#   The i2c address that the chip is using on the i2c bus. This
#   parameter must be provided.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#wiper_0:
#wiper_1:
#wiper_2:
#wiper_3:
#   The value to statically set the given MCP4451 "wiper" to. This is
#   typically set to a number between 0.0 and 1.0 with 1.0 being the
#   highest resistance and 0.0 being the lowest resistance. However,
#   the range may be changed with the 'scale' parameter (see below).
#   If a wiper is not specified then it is left unconfigured.
#scale:
#   This parameter can be used to alter how the 'wiper_x' parameters
#   are interpreted. If provided, then the 'wiper_x' parameters should
#   be between 0.0 and 'scale'. This may be useful when the MCP4451 is
#   used to set stepper voltage references. The 'scale' can be set to
#   the equivalent stepper amperage if the MCP4451 were at its highest
#   resistance, and then the 'wiper_x' parameters can be specified
#   using the desired amperage value for the stepper. The default is
#   to not scale the 'wiper_x' parameters.
```

### [mcp4728]

Convertisseur numérique-analogique MCP4728 configuré statiquement et connecté via le bus I2C (on peut définir un nombre quelconque de sections avec un préfixe "mcp4728").

```
[mcp4728 my_dac]
#i2c_address: 96
#   The i2c address that the chip is using on the i2c bus. The default
#   is 96.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#channel_a:
#channel_b:
#channel_c:
#channel_d:
#   The value to statically set the given MCP4728 channel to. This is
#   typically set to a number between 0.0 and 1.0 with 1.0 being the
#   highest voltage (2.048V) and 0.0 being the lowest voltage.
#   However, the range may be changed with the 'scale' parameter (see
#   below). If a channel is not specified then it is left
#   unconfigured.
#scale:
#   This parameter can be used to alter how the 'channel_x' parameters
#   are interpreted. If provided, then the 'channel_x' parameters
#   should be between 0.0 and 'scale'. This may be useful when the
#   MCP4728 is used to set stepper voltage references. The 'scale' can
#   be set to the equivalent stepper amperage if the MCP4728 were at
#   its highest voltage (2.048V), and then the 'channel_x' parameters
#   can be specified using the desired amperage value for the
#   stepper. The default is to not scale the 'channel_x' parameters.
```

### [mcp4018]

Digipot MCP4018 configuré statiquement et connecté via deux broches gpio "bit banging" (on peut définir un nombre quelconque de sections avec un préfixe "mcp4018").

```
[mcp4018 my_digipot]
scl_pin:
#    La broche d'horloge SCL. Ce paramètre doit être fourni.
sda_pin:
#    La broche de "données" SDA. Ce paramètre doit être fourni.
wiper:
#    La valeur à laquelle définir statiquement le "wiper" MCP4018 donné. Ce paramètre est
#    généralement réglée sur un nombre compris entre 0,0 et 1,0, 1,0 étant la résistance
#    la plus élevée et 0.0 la résistance la plus faible. Cependant, la plage peut être modifiée à
#    l'aide du paramètre 'scale' (voir ci-dessous). Ce paramètre doit être fourni.
#scale:
#    Ce paramètre peut être utilisé pour modifier l'interprétation du paramètre 'wiper'.
#    S'il est fourni, le paramètre 'wiper' doit se situer entre 0,0 et 'scale'. Ceci peut être utile
#    lorsque le MCP4018 est utilisé pour définir des références de tension pas à pas.
#    L''échelle' peut être réglée sur l'intensité du pilote pas à pas équivalent si le MCP4018
#    est à sa plus grande# résistance la plus élevée, puis le paramètre 'wiper' peut être spécifié
#    en utilisant la valeur d'intensité désirée pour le pilote pas à pas. La valeur par défaut est
#    de ne pas mettre à l'échelle le paramètre 'wiper'.
```

## Prise en charge de l'affichage

### [display]

Prise en charge d'un écran relié au microcontrôleur.

```
[display]
lcd_type:
#   The type of LCD chip in use. This may be "hd44780", "hd44780_spi",
#   "aip31068_spi", "st7920", "emulated_st7920", "uc1701", "ssd1306", or
#   "sh1106".
#   See the display sections below for information on each type and
#   additional parameters they provide. This parameter must be
#   provided.
#display_group:
#   The name of the display_data group to show on the display. This
#   controls the content of the screen (see the "display_data" section
#   for more information). The default is _default_20x4 for hd44780 or
#   aip31068_spi displays and _default_16x4 for other displays.
#menu_timeout:
#   Timeout for menu. Being inactive this amount of seconds will
#   trigger menu exit or return to root menu when having autorun
#   enabled. The default is 0 seconds (disabled)
#menu_root:
#   Name of the main menu section to show when clicking the encoder
#   on the home screen. The defaults is __main, and this shows the
#   the default menus as defined in klippy/extras/display/menu.cfg
#menu_reverse_navigation:
#   When enabled it will reverse up and down directions for list
#   navigation. The default is False. This parameter is optional.
#encoder_pins:
#   The pins connected to encoder. 2 pins must be provided when using
#   encoder. This parameter must be provided when using menu.
#encoder_steps_per_detent:
#   How many steps the encoder emits per detent ("click"). If the
#   encoder takes two detents to move between entries or moves two
#   entries from one detent, try changing this. Allowed values are 2
#   (half-stepping) or 4 (full-stepping). The default is 4.
#click_pin:
#   The pin connected to 'enter' button or encoder 'click'. This
#   parameter must be provided when using menu. The presence of an
#   'analog_range_click_pin' config parameter turns this parameter
#   from digital to analog.
#back_pin:
#   The pin connected to 'back' button. This parameter is optional,
#   menu can be used without it. The presence of an
#   'analog_range_back_pin' config parameter turns this parameter from
#   digital to analog.
#up_pin:
#   The pin connected to 'up' button. This parameter must be provided
#   when using menu without encoder. The presence of an
#   'analog_range_up_pin' config parameter turns this parameter from
#   digital to analog.
#down_pin:
#   The pin connected to 'down' button. This parameter must be
#   provided when using menu without encoder. The presence of an
#   'analog_range_down_pin' config parameter turns this parameter from
#   digital to analog.
#kill_pin:
#   The pin connected to 'kill' button. This button will call
#   emergency stop. The presence of an 'analog_range_kill_pin' config
#   parameter turns this parameter from digital to analog.
#analog_pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the analog
#   button. The default is 4700 ohms.
#analog_range_click_pin:
#   The resistance range for a 'enter' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_back_pin:
#   The resistance range for a 'back' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_up_pin:
#   The resistance range for a 'up' button. Range minimum and maximum
#   comma-separated values must be provided when using analog button.
#analog_range_down_pin:
#   The resistance range for a 'down' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_kill_pin:
#   The resistance range for a 'kill' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
```

#### écran hd44780

Informations de configuration des écrans hd44780 (utilisés dans les écrans de type "RepRapDiscount 2004 Smart Controller").

```
[display]
lcd_type: hd44780
#   Définir à "hd44780" pour les écrans hd44780.
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#   Broches connectées à un lcd de type hd44780. Ces paramètres doivent
#   être fournis.
#hd44780_protocol_init: True
#   Effectuer l'initialisation du protocole 8-bit/4-bit sur un écran hd44780.
#   Ceci est nécessaire sur les vrais dispositifs hd44780. Cependant, on peut avoir besoin
#   de le désactiver avec certains périphériques "clones". La valeur par défaut est True.
#line_length:
#   Définit le nombre de caractères par ligne pour un lcd de type hd44780.
#   Les valeurs possibles sont 20 (par défaut) et 16. Le nombre de lignes est
#   fixé à 4.
...
```

#### écran hd44780_spi

Informations de configuration d'un écran hd44780_spi - un écran 20x04 contrôlé par un "registre à décalage (shift register)" matériel (utilisé dans les imprimantes basées sur mightyboard).

```
[display]
lcd_type: hd44780_spi
#   Définir à "hd44780_spi" pour les écrans hd44780_spi.
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   Broches connectées au registre à décalage contrôlant l'affichage.
#   La broche spi_software_miso_pin doit être définie sur une broche inutilisée
#   de la carte mère de l'imprimante, car le registre à décalage contrôlant l'affichage
#   n'a pas de broche MISO, mais l'implémentation logicielle de spi nécessite que
#   cette broche soit configurée.
#hd44780_protocol_init: True
#   Effectue l'initialisation du protocole 8-bit/4-bit sur un écran hd44780.
#   Ceci est nécessaire sur les vrais dispositifs hd44780. Cependant, on peut avoir besoin
#   de le désactiver avec certains périphériques "clones". La valeur par défaut est True.
#line_length:
#   Définit le nombre de caractères par ligne pour un lcd de type hd44780.
#   Les valeurs possibles sont 20 (par défaut) et 16. Le nombre de lignes est
#   fixé à 4.
...
```

#### aip31068_spi display

Information on configuring an aip31068_spi display - a very similar to hd44780_spi a 20x04 (20 symbols by 4 lines) display with slightly different internal protocol.

```
[display]
lcd_type: aip31068_spi
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   The pins connected to the shift register controlling the display.
#   The spi_software_miso_pin needs to be set to an unused pin of the
#   printer mainboard as the shift register does not have a MISO pin,
#   but the software spi implementation requires this pin to be
#   configured.
#line_length:
#   Set the number of characters per line for an hd44780 type lcd.
#   Possible values are 20 (default) and 16. The number of lines is
#   fixed to 4.
...
```

#### écran st7920

Informations de configuration des écrans st7920 (utilisés dans les écrans de type "RepRapDiscount 12864 Full Graphic Smart Controller").

```
[display]
lcd_type: st7920
#   Définir à "st7920" pour les écrans st7920.
cs_pin:
sclk_pin:
sid_pin:
#   Les broches connectées à un lcd de type st7920. Ces paramètres doivent être
#   fournis.
...
```

#### écran emulated_st7920

Informations de configuration d'un écran st7920 émulé - que l'on trouve dans certains "écrans tactiles de 2,4 pouces" et similaires.

```
[display]
lcd_type: emulated_st7920
#   Définir à "emulated_st7920" pour les écrans emulated_st7920.
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   Les broches connectées à un lcd de type emulated_st7920. L'en_pin
#   correspond à la cs_pin du lcd de type st7920,
#   spi_software_sclk_pin correspond à sclk_pin et
#   spi_software_mosi_pin correspond à sid_pin. La broche
#   spi_software_miso_pin doit être réglée sur une broche non utilisée de la carte
#   mère de l'imprimante car le st7920 n'a pas de broche MISO mais l'implémentation
#   logicielle spi nécessite que cette broche soit configurée.
...
```

#### écran uc1701

Informations de configuration des écrans uc1701 (utilisés dans les écrans de type "MKS Mini 12864").

```
[display]
lcd_type: uc1701
#   Définir à "uc1701" pour les écrans uc1701.
cs_pin:
a0_pin:
#   Les broches connectées à un lcd de type uc1701. Ces paramètres doivent être
#   fournis.
#rst_pin:
#   La broche connectée à la broche "rst" du lcd. Si elle n'est pas spécifiée,
#   le matériel doit avoir un pull-up sur la ligne lcd correspondante.
#contrast:
#   Le contraste à définir. La valeur peut aller de 0 à 63 , la valeur par
#   défaut est 40.
...
```

#### écrans ssd1306 et sh1106

Les informations de configuration des écrans ssd1306 et sh1106.

```
[display]
lcd_type:
#   Set to either "ssd1306" or "sh1106" for the given display type.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   Optional parameters available for displays connected via an i2c
#   bus. See the "common I2C settings" section for a description of
#   the above parameters.
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   The pins connected to the lcd when in "4-wire" spi mode. See the
#   "common SPI settings" section for a description of the parameters
#   that start with "spi_". The default is to use i2c mode for the
#   display.
#reset_pin:
#   A reset pin may be specified on the display. If it is not
#   specified then the hardware must have a pull-up on the
#   corresponding lcd line.
#contrast:
#   The contrast to set. The value may range from 0 to 256 and the
#   default is 239.
#vcomh: 0
#   Set the Vcomh value on the display. This value is associated with
#   a "smearing" effect on some OLED displays. The value may range
#   from 0 to 63. Default is 0.
#invert: False
#   TRUE inverts the pixels on certain OLED displays.  The default is
#   False.
#x_offset: 0
#   Set the horizontal offset value on SH1106 displays. The default is
#   0.
...
```

### [display_data]

Support pour l'affichage de données personnalisées sur un écran lcd. On peut créer un nombre quelconque de groupes d'affichage et un nombre quelconque d'éléments de données sous ces groupes. L'écran affichera tous les éléments de données d'un groupe donné si l'option display_group de la section [display] est définie sur le nom du groupe en question.

Un [ensemble par défaut de groupes d'affichage](../klippy/extras/display/display.cfg) est automatiquement créé. On peut remplacer ou étendre ces éléments display_data en remplaçant les valeurs par défaut dans le fichier de configuration principal printer.cfg.

```
[display_data my_group_name my_data_name]
position:
#   Ligne et colonne séparées par des virgules de la position de l'affichage à
#   utiliser pour afficher l'information. Ce paramètre doit être fourni.
text:
#   Le texte à afficher à la position donnée. Ce champ est évalué en utilisant les
#   modèles de commande (voir docs/Command_Templates.md).
#   Ce paramètre doit être fourni.
```

### [display_template]

Les "macros" de texte des données d'affichage (on peut définir un nombre quelconque de sections avec un préfixe display_template). Voir le document [modèles de commande](Command_Templates.md) pour des informations sur l'évaluation des modèles.

Cette fonctionnalité permet de réduire les définitions répétitives dans les sections display_data. On peut utiliser la fonction intégrée `render()` dans les sections display_data pour évaluer un modèle. Par exemple, si l'on définit "[display_template my_template]`", on peut alors utiliser "{ render('my_template') }` dans une section display_data.

Cette fonctionnalité peut également être utilisée pour des mises à jour continues des LEDs à l'aide de la commande [SET_LED_TEMPLATE](G-Codes.md#set_led_template).

```
[display_template my_template_name]
#param_<name>:
#   On peut spécifier un nombre quelconque d'options avec le préfixe "param_". Le nom
#   donné se verra attribuer la valeur donnée (analysée comme un littéral Python) et
#   sera disponible pendant l'expansion de la macro. Si le paramètre est passé dans
#   l'appel à render(), alors cette valeur sera utilisée pendant l'expansion de la macro.
#   Par exemple, une configuration avec "param_speed = 75" pourrait avoir un appelant
#   avec "render('my_template_name', param_speed=80)". Les noms de paramètres
#   peuvent ne pas utiliser de caractères majuscules.
text:
#   Le texte à renvoyer lors du rendu de ce modèle. Ce champ est évalué à l'aide de
#   modèles de commande (voir docs/Command_Templates.md).
#   Ce paramètre doit être fourni.
```

### [display_glyph]

Affiche un glyphe personnalisé sur les écrans le supportant. Le nom donné se verra attribué les données d'affichage, données qui pourront ensuite être référencées dans les modèles d'affichage par leur nom entouré de deux symboles "tilde", par exemple `~my_display_glyph~`

Voir [sample-glyphs.cfg](../config/sample-glyphs.cfg) pour quelques exemples.

```
[display_glyph my_display_glyph]
#data:
#   Les données d'affichage, stockées sous forme de 16 lignes composées de 16 bits (1 par
#   pixel) où '.' est un pixel vide et '*' est un pixel actif (par ex, "****************" pour afficher
#    une ligne horizontale pleine).
#   On peut également utiliser '0' pour un pixel vide et '1' pour un pixel actif.
#   Placez chaque ligne d'affichage sur une ligne de configuration distincte. Le glyphe doit être
#   composé d'exactement 16 lignes de 16 bits chacune. Ce paramètre est facultatif.
#hd44780_data:
#   Glyphe à utiliser sur les écrans 20x4 hd44780. Le glyphe doit être composé d'exactement
#   8 lignes de 5 bits chacune. Ce paramètre est facultatif.
#hd44780_slot:
#   L'index matériel hd44780 (0..7) pour stocker le glyphe. Si plusieurs images distinctes
#   utilisent le même slot, assurez-vous de n'utiliser qu'une seule de ces images dans un
#   écran donné. Ce paramètre est requis si hd44780_data est spécifié.
```

### [display my_extra_display]

Si une section principale [display] a été définie dans printer.cfg comme indiqué ci-dessus, il est possible de définir plusieurs affichages auxiliaires. Notez que les affichages auxiliaires ne supportent pas actuellement la fonctionnalité de menus, ils ne supportent donc pas les options "menu" ou la configuration de boutons.

```
[display my_extra_display]
# Voir la section "affichage" (display) pour les paramètres disponibles.
```

### [menu]

Menus de l'écran LCD personnalisables.

Un [ensemble de menus par défaut](../klippy/extras/display/menu.cfg) est automatiquement créé. On peut remplacer ou étendre le menu en remplaçant les valeurs par défaut dans le fichier de configuration principal printer.cfg.

Consultez le [document sur les modèles de commande](Command_Templates.md#menu-templates) pour obtenir des informations sur les attributs de menu disponibles lors du rendu du modèle.

```
# Paramètres communs disponibles pour toutes les sections de configuration de menu.
#[menu __some_list __some_name]
#type: disabled
#   Élément de menu désactivé de façon permanente, le seul attribut requis est 'type'.
#   Vous permet de désactiver/masquer facilement des éléments de menu existants.

#[menu some_name]
#type:
#   Un élément parmi command, input, list, text :
#       command - élément de menu de base avec divers déclencheurs de script.
#       input - même chose que 'command' mais avec des capacités de changement de valeur.
#                     Pressez pour démarrer/arrêter le mode d'édition.
#       list - permet de regrouper les éléments du menu dans une liste déroulante.
#                     Ajoutez à la liste en créant des configurations de menu en utilisant
#                    "some_list" comme préfixe - par exemple :
#                    [menu some_list some_item_in_the_list].
#       vsdlist - identique à 'list' mais ajoutera les fichiers de la carte SD virtuelle
#                     (sera supprimé dans le futur)
#name:
#   Nom de l'élément de menu - évalué comme un modèle.
#enable:
#   Modèle évalué à True ou False.
#index:
#   Position où l'élément doit être inséré dans la liste. Par défaut
#   l'élément est ajouté à la fin.

#[menu some_list]
#type: list
#name:
#enable:
#   Voir ci-dessus pour une description de ces paramètres.

#[menu some_list some_command]
#type: command
#name:
#enable:
#   Voir ci-dessus pour une description de ces paramètres.
#gcode:
#   Script à exécuter lors d'un clic sur un bouton ou un clic long. Évalué comme un
#   modèle.

#[menu some_list some_input]
#type: input
#name:
#enable:
#   Voir ci-dessus pour une description de ces paramètres.
#input:
#   Valeur initiale à utiliser lors de l'édition - évaluée comme un modèle.
#   Le résultat doit être de type flottant.
#input_min:
#   Valeur minimale de l''intervalle - évaluée comme un modèle. Par défaut -99999.
#input_max:
#   Valeur maximale de l'intervalle - évaluée comme un modèle. Par défaut 99999.
#input_step:
#   Pas d'édition - Doit être un nombre entier positif ou une valeur flottante. Possède
#   un pas de vitesse rapide interne. Lorsque "(input_max - input_min) / input_step > 100"
#   alors le pas de vitesse rapide est 10 * input_step sinon le pas de vitesse rapide
#   est le même que celui de l'input_step.
#realtime:
#   Cet attribut accepte une valeur booléenne statique. Lorsqu'il est activé, alors le script
#   gcode est exécuté après chaque changement de valeur. La valeur par défaut est False.
#gcode:
#   Script à exécuter lors d'un clic sur un bouton, d'un clic long ou d'un changement de valeur.
#   Évalué comme un modèle. Le clic sur le bouton déclenchera le début ou fin du mode d'édition.
```

## Capteurs de filaments

### [filament_switch_sensor]

Capteur de commutation de filament. Prise en charge de la détection de l'insertion et du déplacement du filament à l'aide d'un capteur de commutation, tel qu'un interrupteur de fin de course.

Voir la [référence des commandes](G-Codes.md#filament_switch_sensor) pour plus d'informations.

```
[filament_switch_sensor my_sensor]
#pause_on_runout: True
#    Lorsque défini sur True, une PAUSE sera exécutée immédiatement après qu'un runout
#    soit détecté. Notez que si pause_on_runout est False et que le runout_gcode est omis,
#    la détection du runout est désactivée. Par défaut, est True.
#runout_gcode:
#    Une liste de commandes G-Code à exécuter après la détection d'une fin de filament.
#    Voir docs/Command_Templates.md pour le format G-Code. Si pause_on_runout est
#    réglé sur True, ce G-code sera exécuté après la fin de la PAUSE. Par défaut, aucune
#    commande G-Code n'est exécutée.
#insert_gcode:
#    Une liste de commandes G-Code à exécuter après qu'une insertion de filament soit détectée.
#    Voir docs/Command_Templates.md pour le format G-Code. La valeur par défaut est de
#    n'exécuter aucune commande G-Code, ce qui désactive la détection de l'insertion.
#event_delay  3.0
#    La durée minimale en secondes à attendre entre les événements.
#    Des événements déclenchés durant cette période seront silencieusement ignorés.
#    La valeur par défaut est de 3 secondes.
#pause_delay: 0.5
#    Le délai, en secondes, entre l'envoi de la commande de pause et l'exécution du runout_gcode.
#    Il peut être utile d'augmenter ce délai si OctoPrint présente un comportement étrange lors de
#    la pause. La valeur par défaut est 0.5 secondes.
#switch_pin:
#    La broche sur laquelle l'interrupteur est connecté.
#    Ce paramètre doit être fourni.
```

### [filament_motion_sensor]

Capteur de mouvement de filament. Prise en charge de la détection de présence et déplacement du filament à l'aide d'un encodeur basculant la broche de sortie pendant le mouvement du filament dans le capteur.

Voir la [référence des commandes](G-Codes.md#filament_switch_sensor) pour plus d'informations.

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#   La longueur minimale du filament tiré à travers le capteur déclenchant
#   un changement d'état sur la broche de commutation.
#   La valeur par défaut est 7 mm.
extruder:
#   Le nom de la section de l'extrudeuse à laquelle ce capteur est associé.
#   Ce paramètre doit être fourni.
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   Voir la section "filament_switch_sensor" pour une description des
#   paramètres ci-dessus.
```

### [tsl1401cl_filament_width_sensor]

Capteur de largeur de filament basé sur le TSLl401CL. Voir ce [guide](TSL1401CL_Filament_Width_Sensor.md) pour plus d'informations.

```
[tsl1401cl_filament_width_sensor]
#pin:
#default_nominal_filament_diameter: 1.75 # (mm)
#    Différence maximale de diamètre de filament autorisée en mm.
#max_différence: 0.2
#    La distance entre le capteur et la chambre de fusion en mm.
#measurement_delay: 100
```

### [hall_filament_width_sensor]

Capteur Hall de largeur de filament (voir [Capteur Hall de largeur de filament](Hall_Filament_Width_Sensor.md)).

```
[hall_filament_width_sensor]
adc1:
adc2:
#    Broches d'entrée analogiques connectées au capteur. Ces paramètres doivent
#    être fournis.
#cal_dia1: 1.50
#cal_dia2: 2.00
#    Les valeurs d'étalonnage (en mm) pour les capteurs. La valeur par défaut est
#    1,50 pour cal_dia1 et 2,00 pour cal_dia2.
#raw_dia1: 9500
#raw_dia2: 10500
#    Les valeurs brutes d'étalonnage des capteurs. La valeur par défaut est 9500
#    pour raw_dia1 et 10500 pour raw_dia2.
#default_nominal_filament_diameter: 1.75
#    Le diamètre nominal du filament. Ce paramètre doit être fourni.
#max_difference: 0.200
#    Différence maximale autorisée de diamètre du filament en millimètres (mm).
#    Si la différence entre le diamètre nominal du filament et la sortie du capteur
#    est supérieure à +- max_difference, le multiplicateur d'extrusion est ramené à
#    à %100. La valeur par défaut est de 0,200.
#measurement_delay: 70
#    La distance entre le capteur et la chambre de fusion/la buse en
#    millimètres (mm). Le filament situé entre le capteur et la buse
#    sera traité comme le default_nominal_filament_diameter.
#    Ce module hôte fonctionne avec une logique FIFO. Il conserve chaque valeur
#    de capteur dans un tableau et les remet (POP) dans la bonne position. Ce
#    paramètre doit être fourni.
#enable: False
#    Capteur activé ou désactivé après la mise sous tension. La valeur par défaut est
#    désactivé.
#measurement_interval: 10
#    La distance approximative (en mm) entre les lectures du capteur. La valeur
#    par défaut est de 10mm.
#logging: False
#    Le diamètre de sortie vers le terminal et vers klipper.log peut être activé par
#    ce paramètre.
#min_diameter: 1.0
#    Diamètre minimal pour déclencher le capteur virtuel filament_switch_sensor.
#use_current_dia_while_delay: False
#    Utiliser le diamètre actuel au lieu du diamètre nominal pendant que le délai
#    de mesure n'est pas écoulé.
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#    Voir la section "filament_switch_sensor" pour une description des
#    paramètres ci-dessus.
```

## Cellules de charge

### [load_cell]

Load Cell. Uses an ADC sensor attached to a load cell to create a digital scale.

```
[load_cell]
sensor_type:
#   This must be one of the supported sensor types, see below.
```

#### HX711

This is a 24 bit low sample rate chip using "bit-bang" communications. It is suitable for filament scales.

```
[load_cell]
sensor_type: hx711
sclk_pin:
#   The pin connected to the HX711 clock line. This parameter must be provided.
dout_pin:
#   The pin connected to the HX711 data output line. This parameter must be
#   provided.
#gain: A-128
#   Valid values for gain are: A-128, A-64, B-32. The default is A-128.
#   'A' denotes the input channel and the number denotes the gain. Only the 3
#   listed combinations are supported by the chip. Note that changing the gain
#   setting also selects the channel being read.
#sample_rate: 80
#   Valid values for sample_rate are 80 or 10. The default value is 80.
#   This must match the wiring of the chip. The sample rate cannot be changed
#   in software.
```

#### HX717

This is the 4x higher sample rate version of the HX711, suitable for probing.

```
[load_cell]
sensor_type: hx717
sclk_pin:
#   The pin connected to the HX717 clock line. This parameter must be provided.
dout_pin:
#   The pin connected to the HX717 data output line. This parameter must be
#   provided.
#gain: A-128
#   Valid values for gain are A-128, B-64, A-64, B-8.
#   'A' denotes the input channel and the number denotes the gain setting.
#   Only the 4 listed combinations are supported by the chip. Note that
#   changing the gain setting also selects the channel being read.
#sample_rate: 320
#   Valid values for sample_rate are: 10, 20, 80, 320. The default is 320.
#   This must match the wiring of the chip. The sample rate cannot be changed
#   in software.
```

#### ADS1220

The ADS1220 is a 24 bit ADC supporting up to a 2Khz sample rate configurable in software.

```
[load_cell]
sensor_type: ads1220
cs_pin:
#   The pin connected to the ADS1220 chip select line. This parameter must
#   be provided.
#spi_speed: 512000
#   This chip supports 2 speeds: 256000 or 512000. The faster speed is only
#   enabled when one of the Turbo sample rates is used. The correct spi_speed
#   is selected based on the sample rate.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
data_ready_pin:
#   Pin connected to the ADS1220 data ready line. This parameter must be
#   provided.
#gain: 128
#   Valid gain values are 128, 64, 32, 16, 8, 4, 2, 1
#   The default is 128
#pga_bypass: False
#   Disable the internal Programmable Gain Amplifier. If
#   True the PGA will be disabled for gains 1, 2, and 4. The PGA is always
#   enabled for gain settings 8 to 128, regardless of the pga_bypass setting.
#   If AVSS is used as an input pga_bypass is forced to True.
#   The default is False.
#sample_rate: 660
#   This chip supports two ranges of sample rates, Normal and Turbo. In turbo
#   mode the chip's internal clock runs twice as fast and the SPI communication
#   speed is also doubled.
#   Normal sample rates: 20, 45, 90, 175, 330, 600, 1000
#   Turbo sample rates: 40, 90, 180, 350, 660, 1200, 2000
#   The default is 660
#input_mux:
#   Input multiplexer configuration, select a pair of pins to use. The first pin
#   is the positive, AINP, and the second pin is the negative, AINN. Valid
#   values are: 'AIN0_AIN1', 'AIN0_AIN2', 'AIN0_AIN3', 'AIN1_AIN2', 'AIN1_AIN3',
#   'AIN2_AIN3', 'AIN1_AIN0', 'AIN3_AIN2', 'AIN0_AVSS', 'AIN1_AVSS', 'AIN2_AVSS'
#   and 'AIN3_AVSS'. If AVSS is used the PGA is bypassed and the pga_bypass
#   setting will be forced to True.
#   The default is AIN0_AIN1.
#vref:
#   The selected voltage reference. Valid values are: 'internal', 'REF0', 'REF1'
#   and 'analog_supply'. Default is 'internal'.
```

## Support matériel spécifique à une carte

### [sx1509]

Configuration d'un expandeur SX1509 I2C vers GPIO. En raison du délai encouru par la communication I2C, vous ne devez PAS utiliser les broches du SX1509 comme activation du moteur pas à pas, pas ou direction ou toute autre broche nécessitant un changement de bit rapide. Il est préférable de les utiliser comme sorties numériques statiques ou contrôlées par gcode ou comme broches hardware-pwm pour des ventilateurs par exemple. On peut définir un nombre quelconque de sections avec un préfixe "sx1509". Chaque expandeur fournit un ensemble de 16 broches (sx1509_my_sx1509:PIN_0 à sx1509_my_sx1509:PIN_15) pouvant être utilisées dans la configuration de l'imprimante.

Voir le fichier [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg) pour un exemple.

```
[sx1509 my_sx1509]
i2c_address:
#   I2C address used by this expander. Depending on the hardware
#   jumpers this is one out of the following addresses: 62 63 112
#   113. This parameter must be provided.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### [samd_sercom]

Configuration de SAMD SERCOM pour indiquer les broches à utiliser sur un matériel SERCOM. On peut définir un nombre quelconque de sections avec le préfixe "samd_sercom". Chaque SERCOM doit être configuré avant de pouvoir être utilisé comme périphérique SPI ou I2C. Placez cette section de configuration au-dessus de toute autre section qui utilise les bus SPI ou I2C.

```
[samd_sercom my_sercom]
sercom:
#    Le nom du bus sercom à configurer dans le micro-contrôleur.
#    Les noms disponibles sont "sercom0", "sercom1", etc.
#    Ce paramètredoit être fourni.
tx_pin:
#    Broche MOSI pour la communication SPI, ou broche SDA (données) pour la communication I2C.
#    La broche doit avoir une configuration pinmux valide pour le périphérique SERCOM donné.
#    Ce paramètre doit être fourni.
#rx_pin:
#    Broche MISO pour la communication SPI. Cette broche n'est pas utilisée pour la communication I2C
#    (I2C utilise tx_pin pour l'envoi et la réception).
#    La broche doit avoir une configuration pinmux valide pour le périphérique SERCOM donné.
#    Ce paramètre est optionnel.
clk_pin:
#    La broche CLK pour la communication SPI, ou la broche SCL (horloge) pour la communication I2C.
#    La broche doit avoir une configuration pinmux valide pour le périphérique SERCOM donné.
#    Ce paramètre doit être fourni
```

### [adc_scaled]

Mise à l'échelle analogique du Duet2 Maestro par lectures vref et vssa. Définir une section adc_scaled permet d'activer des broches adc virtuelles (telles que "my_name:PB0") qui seront automatiquement ajustées par les broches de surveillance vref et vssa de la carte. Assurez-vous de définir cette section de configuration au-dessus de toute section de configuration utilisant l'une de ces broches virtuelles.

Voir le fichier [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg) pour un exemple.

```
[adc_scaled my_name]
vref_pin :
#    La broche ADC à utiliser pour le contrôle de VREF. Ce paramètre doit être
#    fourni.
vssa_pin :
#    La broche ADC à utiliser pour la surveillance VSSA. Ce paramètre doit être
#    fourni.
#smooth_time : 2.0
#    Une durée (en secondes) durant laquelle les mesures de vref et vssa
#    seront lissées pour réduire l'impact du bruit des mesures.
#    La valeur par défaut est de 2 secondes.
```

### [replicape]

Support de Replicape - voir le [guide beaglebone](Beaglebone.md) et le fichier [generic-replicape.cfg](../config/generic-replicape.cfg) pour un exemple.

```
#    La section de configuration "replicape" ajoute "replicape:stepper_x_enable" pour
#    l'activation de broches virtuelles de moteur (pour les moteurs X, Y, Z, E et H) et
#    "replicape:power_x" des broches de sortie PWM (pour les pilotes, e, h, fan0, fan1,
#    fan2, et fan3) utilisables ailleurs dans le fichier de configuration.
[replicape]
revision:
#    La révision du matériel replicape. Actuellement, seule la révision "B3" est
#    supportée. Ce paramètre doit être fourni.
#enable_pin: !gpio0_20
#    La broche d'activation globale de la replicape. La valeur par défaut est !gpio0_20
#    (aka P9_41).
host_mcu :
#    Le nom de la section de configuration mcu communiquant avec la section de
#    l'instance mcu du "processus linux" de Klipper. Ce paramètre doit être
#    fourni.
#standstill_power_down: False
#    Ce paramètre contrôle la ligne CFG6_ENN sur tous les moteurs pas à pas.
#    True règle les lignes d'activation sur "ouvert". La valeur par défaut est
#    False.
#stepper_x_microstep_mode:
#stepper_y_microstep_mode:
#stepper_z_microstep_mode:
#stepper_e_microstep_mode:
#stepper_h_microstep_mode:
#    Ce paramètre contrôle les broches CFG1 et CFG2 du pilote de moteur donné.
#    Les options disponibles sont : disable, 1, 2, spread2, 4, 16, spread4, spread16,
#    stealth4, et stealth16. La valeur par défaut est disable.
#stepper_x_current:
#stepper_y_current:
#stepper_z_current:
#stepper_e_current:
#stepper_h_current:
#    Le courant maximum configuré (en Ampères) du moteur pas à pas.
#    Ce paramètre doit être fourni si le moteur pas à pas n'est pas dans un
#    mode désactivé.
#stepper_x_chopper_off_time_high:
#stepper_y_chopper_off_time_high:
#stepper_z_chopper_off_time_high:
#stepper_e_chopper_off_time_high:
#stepper_h_chopper_off_time_high:
#    Ce paramètre contrôle la broche CFG0 du pilote du moteur pas à pas.
#    (True place CFG0 en haut, False le place en bas). La valeur par défaut est False.
#stepper_x_chopper_hysteresis_high:
#stepper_y_chopper_hysteresis_high:
#stepper_z_chopper_hysteresis_high:
#stepper_e_chopper_hysteresis_high:
#stepper_h_chopper_hysteresis_high:
#    Ce paramètre contrôle la broche CFG4 du pilote du moteur pas à pas.
#    (True place CFG4 en haut, False le place en bas). La valeur par défaut est False.
#stepper_x_chopper_blank_time_high:
#stepper_y_chopper_blank_time_high:
#stepper_z_chopper_blank_time_high:
#stepper_e_chopper_blank_time_high:
#stepper_h_chopper_blank_time_high:
#    Ce paramètre contrôle la broche CFG5 du pilote du moteur pas à pas.
#    (True place CFG5 en haut, False le place en bas). La valeur par défaut est True.
```

## Autres modules spécifiques

### [palette2]

Prise en charge des multimatériaux de la Palette 2 - assure une intégration plus étroite de la prise en charge des périphériques de la Palette 2 en mode connecté.

Ce module nécessite également `[virtual_sdcard]` et `[pause_resume]` pour une fonctionnalité complète.

Si vous utilisez ce module, n'utilisez pas le plugin Palette 2 pour Octoprint car ils entreront en conflit, et le module ne pourra pas s'initialiser correctement, ce qui fera échouer votre impression.

Si vous utilisez Octoprint et que vous diffusez du gcode sur le port série au lieu d'imprimer à partir de virtual_sd, alors supprimez **M1** et **M0** de *Commandes de pause* dans *Paramètres > Connexion série > Firmware & protocole* évitera d'avoir à lancer l'impression sur la Palette 2 et de devoir lever la pause dans Octoprint pour que l'impression commence.

```
[palette2]
serial:
# Le port série à connecter à la Palette 2.
#baud: 115200
# Le débit en bauds à utiliser. La valeur par défaut est 115200.
#feedrate_splice: 0.8
# La vitesse d'avance à utiliser lors de l'épissage, la valeur par défaut est 0,8
#feedrate_normal: 1.0
# La vitesse d'avance à utiliser après le raccordement, la valeur par défaut est 1.0
#auto_load_speed: 2
# Vitesse d'avance d'extrusion lors du chargement automatique, la valeur par défaut est 2 (mm/s)
#auto_cancel_variation: 0.1
# Annulation automatique de l'impression lorsque la variation du ping est supérieure à ce seuil
```

### [angle]

Magnetic hall angle sensor support for reading stepper motor angle shaft measurements using a1333, as5047d, mt6816, mt6826s, or tle5012b SPI chips. The measurements are available via the [API Server](API_Server.md) and [motion analysis tool](Debugging.md#motion-analysis-and-data-logging). See the [G-Code reference](G-Codes.md#angle) for available commands.

```
[angle my_angle_sensor]
sensor_type:
#   The type of the magnetic hall sensor chip. Available choices are
#   "a1333", "as5047d", "mt6816", "mt6826s", and "tle5012b". This parameter must be
#   specified.
#sample_period: 0.000400
#   The query period (in seconds) to use during measurements. The
#   default is 0.000400 (which is 2500 samples per second).
#stepper:
#   The name of the stepper that the angle sensor is attached to (eg,
#   "stepper_x"). Setting this value enables an angle calibration
#   tool. To use this feature, the Python "numpy" package must be
#   installed. The default is to not enable angle calibration for the
#   angle sensor.
cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
```

## Paramètres communs aux bus

### Paramètres SPI communs

Les paramètres suivants sont généralement disponibles pour les dispositifs utilisant un bus SPI.

```
#spi_speed:
#    La vitesse SPI (en hz) à utiliser lors de la communication avec le périphérique.
#    La valeur par défaut dépend du type de périphérique.
#spi_bus:
#    Si le micro-contrôleur supporte plusieurs bus SPI alors on peut spécifier le nom
#    du bus du micro-contrôleur ici. La valeur par défaut dépend du type de
#    micro-contrôleur.
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    Spécifiez les paramètres ci-dessus pour utiliser le "SPI logiciel". Ce mode ne
#    nécessite pas le support matériel du micro-contrôleur (typiquement n'importe
#    quelle broche d'usage général peut être utilisée). La valeur par défaut est de
#    ne pas utiliser le "spi logiciel".
```

### Paramètres I2C communs

Les paramètres suivants sont généralement disponibles pour les dispositifs utilisant un bus I2C.

La prise en charge actuelle du microcontrôleur de Klipper pour I2C n'est généralement pas tolérante au bruit de ligne. Des erreurs inattendues sur les fils I2C peuvent amener Klipper à générer une erreur d'exécution. La prise en charge de Klipper pour la récupération d'erreur varie selon chaque type de microcontrôleur. Il est généralement recommandé de n'utiliser que des appareils I2C qui se trouvent sur la même carte de circuit imprimé que le microcontrôleur.

Most Klipper micro-controller implementations only support an `i2c_speed` of 100000 (*standard mode*, 100kbit/s). The Klipper "Linux" micro-controller supports a 400000 speed (*fast mode*, 400kbit/s), but it must be [set in the operating system](RPi_microcontroller.md#optional-enabling-i2c) and the `i2c_speed` parameter is otherwise ignored. The Klipper "RP2040" micro-controller and ATmega AVR family and some STM32 (F0, G0, G4, L4, F7, H7) support a rate of 400000 via the `i2c_speed` parameter. All other Klipper micro-controllers use a 100000 rate and ignore the `i2c_speed` parameter.

```
#i2c_address:
#   The i2c address of the device. This must specified as a decimal
#   number (not in hex). The default depends on the type of device.
#i2c_mcu:
#   The name of the micro-controller that the chip is connected to.
#   The default is "mcu".
#i2c_bus:
#   If the micro-controller supports multiple I2C busses then one may
#   specify the micro-controller bus name here. The default depends on
#   the type of micro-controller.
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#   Specify these parameters to use micro-controller software based
#   I2C "bit-banging" support. The two parameters should the two pins
#   on the micro-controller to use for the scl and sda wires. The
#   default is to use hardware based I2C support as specified by the
#   i2c_bus parameter.
#i2c_speed:
#   The I2C speed (in Hz) to use when communicating with the device.
#   The Klipper implementation on most micro-controllers is hard-coded
#   to 100000 and changing this value has no effect. The default is
#   100000. Linux, RP2040 and ATmega support 400000.
```
