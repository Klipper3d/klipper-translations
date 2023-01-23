# Référence de configuration

Ce document est la référencedes options disponibles dans le fichier de configuration de Klipper.

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
serial:
#    Le port série à connecter à l'unité MCU. Si vous n'êtes pas sûr (ou s'il
#    change) consultez la section "Où est mon port série ?" de la FAQ.
#    Ce paramètre doit être fourni lors de l'utilisation d'un port série.
#baud: 250000
#    Le débit en bauds à utiliser. La valeur par défaut est 250000.
#canbus_uuid:
#    Si vous utilisez un dispositif connecté à un bus CAN, ceci définit l'identifiant
#    unique de la puce à laquelle se connecter. Cette valeur doit être fournie lorsque l'on utilise
#    le bus CAN pour la communication.
#canbus_interface:
#    Si vous utilisez un dispositif connecté à un bus CAN, ceci définit l'interface réseau CAN
#    à utiliser. La valeur par défaut est 'can0'.
#restart_method:
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
#    Le type d'imprimante utilisée. Cette option peut être l'une des suivantes : cartésienne,
#    corexy, corexz, hybrid_corexy, hybrid_corexz, rotary_delta, delta, deltesian, polar, winch,
#    ou none. Ce paramètre doit être spécifié.
max_velocity:
#    Vitesse maximale (en mm/s) de la tête d'outil (par rapport à l'impression).
#    Ce paramètre doit être spécifié.
max_accel:
#    Accélération maximale (en mm/s^2) de la tête de l'outil (par rapport à l'impression).
#    Ce paramètre doit être spécifié.
#max_accel_to_decel:
#    Une pseudo-accélération (en mm/s^2) contrôlant la vitesse à laquelle la tête de l'outil peut
#    passer de l'accélération à la décélération. Elle est utilisée pour réduire la vitesse maximale
#    des courts mouvements en zigzag (et donc réduire les vibrations de l'imprimante dues à ces
#    mouvements). La valeur par défaut est la moitié de max_accel.
#square_corner_velocity: 5.0
#    La vitesse maximale (en mm/s) à laquelle la tête d'outil peut parcourir un angle de 90 degrés.
#    Une valeur non nulle peut réduire les changements dans les débits de l'extrudeuse en
#    permettant des changements de vitesse instantanés de la tête d'outil pendant les virages.
#    Cette valeur configure l'algorithme interne de prise de virage à vitesse centripète ; les virages
#    dont l'angle est supérieur à 90 degrés auront une vitesse de prise de virage plus élevée tandis
#    que ceux d'angles inférieurs à 90 degrés auront une vitesse de virage plus faible.
#    Si ce paramètre est défini sur zéro, la tête d'outil décélérera jusqu'à zéro à chaque coin.
#    La valeur par défaut est 5mm/s.
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
#    Pour les imprimantes deltesiennes, ceci limite la vitesse maximale (en mm/s) des
#    déplacements avec un mouvement sur l'axe z. Ce paramètre peut être utilisé pour
#    réduire la vitesse maximale des déplacements vers le haut/bas (qui nécessitent un
#    taux de pas plus élevé que les autres mouvements sur une imprimante deltesienne).
#    La valeur par défaut est d'utiliser max_velocity pour max_z_velocity.
#max_z_accel:
#    Ceci définit l'accélération maximale (en mm/s^2) du mouvement le long de l'axe z.
#    Ce paramètre peut être utile si l'imprimante peut atteindre une plus grande
#    accélération sur les mouvements XY que sur les mouvements Z (par exemple, lors
#    de l'utilisation de la compensation de la résonance).
#    La valeur par défaut est d'utiliser max_accel pour max_z_accel.
#minimum_z_position : 0
#    Position Z minimale à laquelle l'utilisateur peut ordonner à la tête de se déplacer.
#    La valeur par défaut est 0.
#min_angle: 5
#    Ceci représente l'angle minimum (en degrés) par rapport à l'horizontale que les bras
#    deltesiens sont autorisés à atteindre. Ce paramètre est destiné à empêcher les bras de
#    devenir complètement horizontaux, ce qui risquerait de provoquer une inversion
#    accidentelle de l'axe XZ.
#    La valeur par défaut est 5.
#print_width:
#    La distance (en mm) des coordonnées X valides de la tête de l'outil. On peut utiliser ce
#    paramètre pour personnaliser la vérification de la plage des mouvements de la tête de
#    l'outil. Si une grande valeur est spécifiée ici, il peut être possible de faire entrer la tête
#    de l'outil en collision avec une colonne. Ce paramètre correspond généralement à la
#    largeur du banc (en mm).
#slow_ratio: 3
#    Rapport utilisé pour limiter la vitesse et l'accélération des mouvements proches des
#    extrêmes de l'axe X. Si la distance verticale divisée par la distance horizontale dépasse
#    la valeur de slow_ratio, la vitesse et l'accélération sont limitées à la moitié de leur valeur
#    nominale. Si la distance verticale divisée par la distance horizontale dépasse de deux fois
#    la valeur de slow_ratio, alors la vitesse et l'accélération sont limitées à un quart de leur
#    valeur nominale. La valeur par défaut est 3.

#    La section stepper_left est utilisée pour décrire le moteur pas à pas contrôlant la colonne
#    gauche. Cette section contrôle également les paramètres d'orientation (homing_speed,
#    homing_retract_dist) pour toutes les colonnes.
[stepper_left]
position_endstop:
#    Distance (en mm) entre la buse et le lit lorsque la buse se trouve au centre de la zone de
#    construction. Ce paramètre doit être fourni pour stepper_left ; pour le paramètre stepper_right
#    ce paramètre prend par défaut la valeur spécifiée pour stepper_left.
arm_length:
#    Longueur (en mm) de la tige diagonale reliant le chariot de la colonne à la tête d'impression.
#    Ce paramètre doit être fourni pour stepper_left. Pour le paramètre stepper_right, ce paramètre
#    prend par défaut la valeur spécifiée pour stepper_left.
arm_x_length:
#    Distance horizontale entre la tête d'impression et la colonne lorsque l'imprimante est mise à
#    l'origine. Ce paramètre doit être fourni pour stepper_left ; pour stepper_right, ce paramètre
#    prend par défaut la valeur spécifiée pour stepper_left.

#    La section stepper_right est utilisée pour décrire le moteur pas à pas contrôlant la colonne de droite.
[stepper_right]

#    La section stepper_y est utilisée pour décrire le moteur pas à pas contrôlant l'axe Y d'un robot deltesien.
[stepper_y]
```

### Cinématique CoreXY

Voir [example-corexy.cfg](../config/example-corexy.cfg) pour un exemple de fichier cinématique corexy (et h-bot).

Seuls les paramètres spécifiques aux imprimantes corexy sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: corexy
max_z_velocity:
#    Ceci définit la vitesse maximale (en mm/s) du mouvement le long de l'axe z
#    Ce paramètre peut être utilisé pour limiter la vitesse maximale du moteur pas à pas z.
#    La valeur par défaut est l'utilisation de max_velocity pour max_z_velocity.
max_z_accel:
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
#   Algorithme de contrôle (soit pid, soit filigrane (watermark)). Ce paramètre doit
#   être fourni.
pid_Kp:
pid_Ki:
pid_Kd:
#   Les paramètres proportionnels (pid_Kp), intégraux (pid_Ki) et dérivés (pid_Kd) du système de
#   contrôle de rétroaction PID. Klipper évalue les paramètres PID avec la formule générale suivante :
#      heater_pwm = (Kp*erreur + Ki*intégrale(erreur) - Kd*dérivée(erreur)) / 255
#   Où "erreur" est le résultat de "requested_temperature - measured_temperature" et
#  "heater_pwm" est le taux de chauffage demandé, 0.0 étant complètement éteint et 1.0 étant
#   complètement allumé. Pensez à utiliser la commande PID_CALIBRATE pour obtenir ces paramètres.
#    Les paramètres pid_Kp, pid_Ki, et pid_Kd doivent être fournis pour les éléments de chauffe PID.
#max_delta: 2.0
#   Sur les éléments de chauffe contrôlés par un filigrane (watermark), il s'agit du nombre de degrés en
#   Celsius au-dessus de la température cible avant de désactiver le chauffage ainsi que le nombre de
#   degrés en dessous de la température cible avant la réactivation du chauffage. La valeur par défaut
#   est de 2 degrés Celsius.
#pwm_cycle_time: 0.100
#   Durée en secondes de chaque cycle PWM logiciel du chauffage. Il n'est
#   pas recommandé de définir cette valeur, sauf s'il existe une exigence
#   électrique pour commuter le chauffage plus rapidement que 10 fois par seconde.
#   La valeur par défaut est 0,100 seconde.
#min_extrude_temp: 170
#   La température minimale (en Celsius) au-dessus de laquelle les commandes de déplacement de
#   l'extrudeuse peuvent être émises. La valeur par défaut est 170 Celsius.
min_temp:
max_temp:
#   La plage maximale de températures valides (en Celsius) dans laquelle l'élément de chauffe doit rester.
#   Ceci contrôle une fonction de sécurité implémentée dans le code du micro-contrôleur - si la température
#   mesurée sort de cette plage, le microcontrôleur se met en état d'arrêt.
#   Ce contrôle peut aider à détecter certaines défaillances matérielles de l'élément chauffant et/ou du capteur.
#   Définissez cette plage suffisamment large pour que des températures raisonnables n'entraînent pas d'erreur.
#   Ces paramètres doivent être fournis.
```

### [heater_bed]

La section heater_bed concerne le lit chauffant. Elle utilise les mêmes paramètres de chauffage que ceux décrits dans la section "extrudeuse".

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
#   La vitesse (en mm/s) des déplacements entre les points de palpage
#   durant l'étalonnage.
#   La valeur par défaut est 50.
#horizontal_move_z: 5
#   La hauteur (en mm) à laquelle la tête doit être relevée juste avant de
#   lancer une opération de palpage. La valeur par défaut est 5.
#mesh_radius:
#   Définit le rayon de la maille à palper pour les lits circulaires. Notez que
#   le rayon est relatif aux coordonnées spécifiées par l'option
#   mesh_origin. Ce paramètre doit être fourni pour des lits circulaires
#   et omis pour des lits rectangulaires.
#mesh_origin:
#   Définit les coordonnées X, Y du centre du maillage des lits circulaires. Ces
#   coordonnées sont relatives à l'emplacement de la sonde. Il peut être utile
#   d'ajuster l'origine du maillage afin de maximiser la taille du rayon du maillage.
#   La valeur par défaut est 0, 0. Ce paramètre doit être omis pour des lits rectangulaires.
#mesh_min:
#   Définit les coordonnées X, Y minimales du maillage pour les lits rectangulaires.
#   Ces coordonnées sont relatives à l'emplacement de la sonde. Cette position
#   sera le premier point sondé, le plus proche de l'origine. Ce paramètre doit
#   être fourni pour des lits rectangulaires.
#mesh_max:
#   Définit les coordonnées X, Y maximales du maillage pour les lits rectangulaires.
#   Le principe est le même que pour mesh_min, mais ce sera le point le plus éloigné
#   atteignable par rapport à l'origine du lit. Ce paramètre  doit être fourni pour
#   des lits rectangulaires.
#probe_count: 3, 3
#   Pour les lits rectangulaires, il s'agit d'une paire d'entiers X, Y séparés par des virgules,
#   définissant le nombre de points à palper le long de chaque axe.
#   Une valeur seule est également valide, auquel cas cette valeur sera appliquée aux
#   deux axes. La valeur par défaut est 3, 3.
#round_probe_count: 5
#   Pour les lits circulaires, cette valeur entière définit le nombre maximum de points
#   à palper le long de chaque axe. Cette valeur doit être un nombre impair.
#   La valeur par défaut est 5.
#fade_start: 1.0
#   La position z du gcode à partir de laquelle il faut commencer à éliminer progressivement
#   l'ajustement z lorsque la compensation est activée. La valeur par défaut est 1.0.
#fade_end: 0.0
#   La position z du gcode à partir de laquelle la compensation se termine. Lorsqu'elle est
#   définie à une valeur inférieure à fade_start, la compensation est désactivée. Notez que
#   la compensation peut ajouter une mise à l'échelle indésirable le long de l'axe z d'une impression.
#   Si un utilisateur souhaite activer la compensation, une valeur de 10.0 est recommandée.
#   La valeur par défaut est 0.0, ce qui désactive la compensation.
#fade_target:
#   La position z vers laquelle la compensation doit converger. Lorsque cette valeur est
#   définie à une valeur non nulle, elle doit se situer dans la plage des valeurs z du maillage.
#   Les utilisateurs qui souhaitent converger vers la position de mise à l'origine du Z
#   doivent régler cette valeur à 0.
#   La valeur par défaut est la valeur z moyenne du maillage.
#split_delta_z: .025
#   Le delta de différence de Z (en mm) le long d'un mouvement qui déclenchera une séparation.
#   La valeur par défaut est de 0,025.
#move_check_distance: 5.0
#   La distance (en mm) le long d'un mouvement pour vérifier le split_delta_z.
#   C'est également la longueur minimale pour laquelle un mouvement peut être divisé.
#   La valeur par défaut est 5.0.
#mesh_pps: 2, 2
#   Une paire de nombres entiers X, Y séparés par des virgules, définissant le nombre de
#   points par segment à interpoler dans le maillage le long de chaque axe. Un "segment"
#   étant défini comme l'espace entre chaque point palpé.
#   L'utilisateur peut saisir une seule valeur qui sera appliquée aux deux axes.
#   La valeur par défaut est 2, 2.
#algorithme: lagrange
#   L'algorithme d'interpolation à utiliser. Soit "lagrange", soit "bicubic". Cette option
#   n'affecte pas les grilles 3x3 forcées d'utiliser l'échantillonnage de lagrange.
#   La valeur par défaut est lagrange.
#bicubic_tension: .2
#   Lors de l'utilisation de l'algorithme bicubic, le paramètre de tension ci-dessus peut
#   être appliqué pour modifier la quantité de pente interpolée.
#   Des nombres plus grands augmenteront la quantité de pente entraînant une plus grande
#   courbure du maillage. La valeur par défaut est 0,2.
#relative_reference_index:
#   Un index de points dans le maillage auquel référencer toutes les valeurs z. En activant
#   ce paramètre, on produit un maillage relatif à la position z palpée de l'indice fourni.
#faulty_region_1_min:
#faulty_region_1_max:
#   Points optionnels définissant une région défectueuse.  Voir docs/Bed_Mesh.md pour
#   plus de détails sur les régions défectueuses. Jusqu'à 99 régions défectueuses peuvent
#   être ajoutées.
#   Par défaut, aucune région défectueuse n'est définie.
```

### [bed_tilt]

Compensation de l'inclinaison du lit. On peut définir une section de configuration bed_tilt pour activer les transformations de déplacement tenant compte d'un lit incliné. Notez que bed_mesh et bed_tilt sont incompatibles ; les deux ne peuvent pas être définis en même temps.

Voir la [référence des commandes](G-Codes.md#bed_tilt) pour plus d'informations.

```
[bed_tilt]
#x_adjust: 0
#   Quantité à ajouter à la hauteur Z de chaque mouvement pour chaque mm sur l'axe X.
#   La valeur par défaut est 0.
#y_adjust: 0
#   Quantité à ajouter à la hauteur Z de chaque mouvement pour chaque mm sur l'axe Y.
#   La valeur par défaut est 0.
#z_adjust: 0
#   Quantité à ajouter à la hauteur Z lorsque la buse est nominalement à 0, 0.
#   La valeur par défaut est 0.
#   Les paramètres suivants contrôlent la commande g-code étendue BED_TILT_CALIBRATE
#   utilisée pour calibrer les paramètres de réglage x et y appropriés.
#points:
#   Une liste de coordonnées X, Y (une par ligne ; les lignes suivantes indentées) devant
#   être palpées pendant une commande BED_TILT_CALIBRATE
#   Spécifiez les coordonnées de la buse et assurez-vous que la sonde est au-dessus du lit
#   aux coordonnées données de la buse. 
#   La valeur par défaut est de ne pas activer la commande.
#speed: 50
#   Vitesse (en mm/s) des mouvements de déplacements hors palpage pendant l'étalonnage.
#   La valeur par défaut est 50.
#horizontal_move_z: 5
#   Hauteur (en mm) à laquelle la tête doit être relevée lors du déplacement juste avant
#   de lancer une opération de palpage. La valeur par défaut est 5.
```

### [bed_screws]

Outil d'aide au réglage des vis de mise à niveau du lit. On peut définir une section de configuration [bed_screws] pour activer une commande g-code BED_SCREWS_ADJUST.

Consultez le [guide de nivelage](Manual_Level.md#adjusting-bed-leveling-screws) et la [référence des commandes](G-Codes.md#bed_screws) pour plus d'informations.

```
[bed_screws]
#screw1:
#   Coordonnées X, Y de la première vis de réglage du niveau du lit. Il s'agit de la
#   position vers laquelle déplacer la buse afin qu'elle soit placée au-dessus de cette
#   vis de réglage (ou aussi proche que possible tout en étant au-dessus du lit).
#   Ce paramètre doit être fourni.
#screw1_name:
#   Un nom arbitraire pour la vis donnée. Ce nom est affiché lors de
#   l'exécution du script d'aide. Par défaut, le nom utilisé est basé sur
#   la position XY de la vis.
#screw1_fine_adjust :
#   Coordonnées X, Y pour commander la buse afin de pouvoir affiner le réglage de la vis de mise
#   à niveau du lit. Par défaut, il n'y a pas de réglage fin sur la vis de mise à niveau du lit.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#   Vis supplémentaires de mise à niveau du lit. Au moins trois vis doivent être
#   définies.
#horizontal_move_z: 5
#   Hauteur (en mm) à laquelle la tête doit être relevée pour se déplacer
#   lors du passage d'une vis à la suivante. La valeur par défaut est 5.
#probe_height: 0
#   Hauteur de la sonde (en mm) après ajustement dû à la dilatation thermique
#   du lit et de la buse. La valeur par défaut est zéro.
#speed: 50
#   Vitesse (en mm/s) des déplacements entre les palpages pendant l'étalonnage.
#   La valeur par défaut est 50.
#probe_speed: 5
#   Vitesse (en mm/s) lors du déplacement d'une position horizontal_move_z
#   à la position probe_height. La valeur par défaut est 5.
```

### [screws_tilt_adjust]

Outil d'aide au réglage de l'inclinaison des vis du lit à l'aide du palpeur Z. On peut définir une section de configuration screws_tilt_adjust pour activer une commande g-code SCREWS_TILT_CALCULATE.

Voir le [guide de nivelage](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) et la [référence des commandes](G-Codes.md#screws_tilt_adjust) pour des informations supplémentaires.

```
[screws_tilt_adjust]
#screw1:
#    Les coordonnées (X, Y) de la première vis de mise à niveau du lit. Il s'agit d'une
#    position à laquelle déplacer la buse de manière à ce que la sonde soit directement
#    au-dessus de la vis de mise à niveau du lit (ou aussi près que possible tout en étant
#    encore au-dessus du lit). Il s'agit de la vis de base utilisée dans les calculs.
#    Ce paramètre doit être fourni.
#screw1_name:
#    Un nom arbitraire pour la vis donnée. Ce nom est affiché lorsque le script d'aide
#    s'exécute. Par défaut, le nom utilisé est basé sur la position XY de la vis.
#screw2:
#screw2_name:
#...
#    Vis supplémentaires de mise à niveau du lit. Au moins deux vis doivent être
#    définies.
#speed: 50
#    La vitesse (en mm/s) des déplacements sans palpage pendant l'étalonnage.
#    La valeur par défaut est 50.
#horizontal_move_z: 5
#    La hauteur (en mm) à laquelle la tête doit être levée pour se déplacer juste
#    avant de lancer une opération de palpage. La valeur par défaut est 5.
#screw_thread: CW-M3
#    Le type de vis utilisée pour le niveau du lit, M3, M4 ou M5 et la direction de la molette
#    utilisée pour le nivelage du lit, diminution dans le sens des aiguilles d'une montre,
#    augmentation dans le sens inverse des aiguilles d'une montre.
#    Valeurs acceptées : CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
#    La valeur par défaut est CW-M3. De nombreuses imprimantes utilisent une vis M3,
#    un tour de molette dans le sens des aiguilles d'une montre diminue la distance.
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
#    Spécifiez les coordonnées de la buse et assurez-vous que le palpeur est au-dessus
#    du lit aux coordonnées données de la buse. Ce paramètre doit être
#    fourni.
#speed: 50
#    La vitesse (en mm/s) des mouvements de déplacements hors palpage
#    pendant l'étalonnage. La valeur par défaut est 50.
#horizontal_move_z: 5
#    Hauteur (en mm) à laquelle la tête doit être relevée pour se déplacer juste avant
#    de lancer une opération de palpage. La valeur par défaut est 5.
#retries: 0
#    Nombre de tentatives à effectuer si les points palpés ne sont pas dans la tolérance.
#retry_tolerance: 0
#    Si les réessais sont activés, réessayer si les points sondés les plus grands et les plus petits
#    diffèrent plus que la tolérance retry_tolerance. Notez que la plus petite unité de
#    changement ici serait un seul pas. Cependant, si vous sondez plus de points que de steppers,
#    il est probable que vous aurez une valeur minimale fixe pour la plage de points sondés. Vous
#    pouvez en apprendre plus en observant la sortie de la commande.
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

Réglage de la position Z de la tête d'impression en fonction de la température. Compenser le mouvement vertical de la tête d'impression causé par la dilatation thermique du châssis de l'imprimante en temps réel à l'aide d'un capteur de température (généralement couplé à une section verticale du châssis).

Voir aussi : [commandes de code G étendues](G-Codes.md#z_thermal_adjust).

```
[z_thermal_adjust]
#temp_coeff:
#    Le coefficient de dilatation thermique, en mm/degC. Par exemple, un
#    temp_coeff de 0,01 mm/degC déplacera l'axe Z vers le bas de 0,01 mm à
#    chaque degré Celsius d'augmentation du capteur de température. La valeur 
#   par défaut, 0,0 mm/degC, n'applique aucun ajustement.
#smooth_time:
#    Fenêtre de lissage appliquée au capteur de température, en secondes. Peut réduire
#    le bruit du moteur dû à de petites corrections excessives en réponse au bruit du capteur.
#    La valeur par défaut est de 2,0 secondes.
#z_adjust_off_above:
#    Désactive les ajustements au-dessus de cette hauteur Z [mm]. La dernière correction calculée
#    restera appliquée jusqu'à ce que la tête de l'outil passe à nouveau en dessous de la hauteur Z spécifiée.
#    La valeur par défaut est 99999999.0 mm (toujours actif).
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
#    Une coordonnée X, Y (par exemple 100, 100) où la mise à l'origine Z doit être
#    effectuée. Ce paramètre doit être fourni.
#speed: 50.0
#    Vitesse à laquelle la tête de l'outil est déplacée vers la position de référence Z sûre.
#    La valeur par défaut est 50 mm/s
#z_hop:
#    Distance (en mm) pour lever l'axe Z avant le retour au point d'origine. Cette valeur est
#    appliquée à toute commande d'initialisation, même si elle n'initialise pas l'axe Z.
#    Si l'axe Z est déjà ramené à la position de base et que la position Z actuelle est inférieure
#    à z_hop, alors ceci lèvera la tête à une hauteur de z_hop. Si l'axe Z n'est pas déjà centré,
#    la tête est relevée de z_hop.
#    La valeur par défaut est de ne pas implémenter le relevage en Z.
#z_hop_speed: 15.0
#    Vitesse (en mm/s) à laquelle l'axe Z est relevé avant le retour à la position initiale.
#    La valeur par défaut est de 15 mm/s.
#move_to_previous: False
#    Lorsqu'il a la valeur True, les axes X et Y sont réinitialisés à leurs positions précédentes après
#    retour à la position initiale de l'axe Z. La valeur par défaut est False.
```

### [homing_override]

Homing override. On peut utiliser ce mécanisme pour exécuter une série de commandes g-code à la place d'un G28 trouvé dans l'entrée g-code normale. Cela peut être utile sur les imprimantes qui nécessitent une procédure spécifique du retour au point d'origine de la machine.

```
[homing_override]
gcode:
#    Une liste de commandes G-Code à exécuter à la place des commandes G28
#    trouvées dans l'entrée g-code normale. Voir docs/Command_Templates.md
#    pour le format G-Code. Si un G28 est contenu dans cette liste de commandes
#    alors la procédure de mise à l'origine de l'imprimante sera invoquée.
#    Les commandes énumérées ici doivent ramener tous les axes à la position initiale.
#    Ce paramètre doit être fourni.
#axes: xyz
#    Les axes à remplacer. Par exemple, si ce paramètre est défini sur "z", alors le script
#    d'annulation ne sera exécuté que lorsque l'axe z est mis à l'origine (par ex.
#    une commande "G28" ou "G28 Z"). Remarque : le script de neutralisation doit
#    toujours gérer tous les axes. La valeur par défaut est "xyz" ce qui fait que le script
#    de remplacement sera exécuté à la place de toutes les commandes G28.
#set_position_x:
#set_position_y:
#set_position_z:
#    Si spécifié, l'imprimante supposera que l'axe est à la position spécifiée avant
#    d'exécuter les commandes g-code ci-dessus. Le fait de définir ceci désactive les
#    contrôles d'orientation pour cet axe. Cela peut être utile si la tête doit se déplacer
#    avant d'invoquer le mécanisme G28 normal d'un axe.
#    La valeur par défaut est de ne pas forcer une position pour un axe.
```

### [endstop_phase]

Interrupteurs de fin de course ajustés à la phase du moteur pas à pas. Pour utiliser cette fonction, définissez une section de configuration avec un préfixe "endstop_phase" suivi du nom de la section de configuration du moteur pas à pas correspondante (par exemple, "[endstop_phase stepper_z]"). Cette fonctionnalité peut améliorer la précision des interrupteurs de fin de course. Ajoutez une déclaration nue "[endstop_phase]" pour activer la commande ENDSTOP_PHASE_CALIBRATE.

Voir le [guide de détecteurs de fin de course](Endstop_Phase.md) et la [référence des commandes](G-Codes.md#endstop_phase) pour plus d'informations.

```
[endstop_phase stepper_z]
#endstop_accuracy:
#   Définit la précision attendue (en mm) de la butée. Cela représente la distance d'erreur
#   maximale que la butée peut déclencher (par exemple, si une butée peut occasionnellement
#   se déclencher 100um en avance ou jusqu'à 100um en retard alors réglez cette valeur
#   sur 0.200 pour 200um). La valeur par défaut est 4*rotation_distance/full_steps_per_rotation.
#trigger_phase:
#   Spécifie la phase du pilote du moteur pas à pas à attendre lorsque l'on atteint la butée.
#   Composé de deux nombres séparés par une barre oblique - la phase et le nombre total
#   de phases (par exemple, "7/64"). Ne définissez cette valeur que si vous êtes sûr que le
#   pilote du moteur pas à pas est réinitialisé à chaque fois que le mcu est réinitialisé. 
#   Si cette valeur n'est pas définie, alors la phase du moteur pas à pas sera détectée à la
#   première mise à l'origine et cette phase sera utilisée sur toutes les origines suivantes.
#endstop_align_zero: False
#   Si vrai, la position_endstop de l'axe sera effectivement modifiée de manière à ce que la
#   position zéro de l'axe se produise sur un pas  complet du moteur pas à pas. (Si utilisé sur
#   l'axe Z et que la hauteur de la couche d'impression est un multiple de la distance parcourue
#   par un pas complet, alors chaque couche se produira sur un pas complet).
#   La valeur par défaut est False.
```

## Macros et événements G-Code

### [gcode_macro]

Macros G-Code (on peut définir un nombre quelconque de sections avec le préfixe "gcode_macro"). Voir le [guide des modèles de commande](Command_Templates.md) pour plus d'informations.

```
[gcode_macro my_cmd]
#gcode:
#    Une liste de commandes G-Code à exécuter à la place de "my_cmd". Voir
#    docs/Command_Templates.md pour le format G-Code. Ce paramètre doit
#    être fourni.
#variable_<name>:
#    On peut spécifier un nombre quelconque d'options avec le préfixe "variable_".
#    Le nom de variable donné se verra attribué la valeur donnée (analysée en tant
#    que littéral par Python) et sera disponible pendant l'expansion de la macro.
#    Par exemple, une configuration avec "variable_fan_speed = 75" pourrait avoir
#    des commandes gcode contenant "M106 S{ fan_speed * 255 }". Ces variables
#    peuvent alors être modifiées au moment de l'exécution en utilisant la commande
#    SET_GCODE_VARIABLE (voir docs/Command_Templates.md pour plus de détails).
#    Les noms de variables peuvent ne pas utiliser de caractères majuscules.
#rename_existing:
#    Cette option permet à la macro de remplacer une commande G-Code existante
#    et fournira la définition précédente de la commande via le nom fourni ici. Ceci
#    peut être utilisé pour remplacer les commandes G-Code originelles. Il convient
#    d'être prudent lorsque l'on remplace des commandes, cela pouvant provoquer
#    des résultats complexes et inattendus. La valeur par défaut est de ne pas
#    remplacer une commande G-Code existante.
#description: Macro G-Code
#    Ceci ajoutera une courte description utilisée à la commande HELP ou lors de
#    l'utilisation de la fonction de complétion automatique.
#    Par défaut : "G-Code macro".
```

### [delayed_gcode]

Exécute un gcode sur un délai défini. Voir le [guide des modèles de commande](Command_Templates.md#delayed-gcodes) et la [référence des commandes](G-Codes.md#delayed_gcode) pour plus d'informations.

```
[delayed_gcode my_delayed_gcode]
gcode:
#   Une liste de commandes G-Code à exécuter lorsque la durée du délai est écoulée.
#   Les modèles G-Code sont supportés. Ce paramètre doit être fourni.
#initial_duration: 0.0
#   Durée du délai initial (en secondes). Si elle est définie à une valeur non nulle, le gcode
#   différé s'exécutera le nombre de secondes spécifié après que l'imprimante passe à
#   l'état "prêt". Ceci peut être utile pour les procédures d'initialisation ou lors d'une
#   répétition de delayed_gcode. Si la valeur est 0, le delayed_gcode ne sera pas exécuté
#   au démarrage.
#   La valeur par défaut est 0.
```

### [save_variables]

Prise en charge de l'enregistrement des variables sur le disque afin qu'elles soient conservées lors des redémarrages. Voir [modèles de commande](Command_Templates.md#save-variables-to-disk) et [référence au code G](G-Codes.md#save_variables) pour plus d'informations.

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
#    Le chemin d'accès au répertoire local sur la machine hôte de recherche
#    des fichiers g-code. Il s'agit d'un répertoire en lecture seule (les écritures de fichiers sdcard
#    ne sont pas supportées). On peut le faire pointer vers le répertoire de téléchargement
#    d'OctoPrint (généralement ~/.octoprint/uploads/ ). Ce paramètre doit
#    être fourni.
#on_error_gcode:
#    Une liste de commandes G-Code à exécuter lorsqu'une erreur est signalée.
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
cs_pin:
#   La broche d'activation SPI du capteur. Ce paramètre doit être fourni.
#spi_speed: 5000000
#   La vitesse SPI (en hz) à utiliser lors de la communication avec la puce.
#   La valeur par défaut est 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Voir la section "paramètres SPI communs" pour une description des
#   paramètres ci-dessus.
#axes_map : x, y, z
#   L'axe de l'accéléromètre de chacun des axes X, Y et Z de l'imprimante.
#   Ceci peut être utile si l'accéléromètre est monté dans une orientation 
#   qui ne correspond pas à celle de l'imprimante. Par exemple, on peut
#   régler cette option sur "y, x, z" pour permuter les axes X et Y.
#   Il est également possible d'inverser un axe si la direction de l'accéléromètre
#   est inversée (par exemple, "x, z, -y"). La valeur par défaut est "x, y, z".
#Rate: 3200
#   Débit de données de sortie pour ADXL345. ADXL345 prend en charge les débits
#   de données suivants : 3200, 1600, 800, 400, 200, 100, 50, et 25. Notez qu'il n'est
#   pas recommandé de changer ce débit par rapport au débit par défaut de 3200,
#   les débits inférieurs à 800 affecteront considérablement la qualité des mesures
#   de résonance.
```

### [mpu9250]

Prise en charge des accéléromètres MPU-9250, MPU-9255, MPU-6050 et MPU-6500 (on peut définir un nombre quelconque de sections avec le préfixe "mpu9250").

```
[mpu9250 my_accelerometer]
#i2c_address:
#    La valeur par défaut est 104 (0x68). Si AD0 est élevé, ce sera 0x69 à la place.
#i2c_mcu:
#i2c_bus:
#i2c_speed: 400000
#    Voir la section "paramètres I2C communs" pour une description des
#    paramètres ci-dessus. La valeur par défaut de "i2c_speed" est 400000.
#axes_map: x, y, z
#    Voir la section "adxl345" pour des informations sur ce paramètre.
```

### [resonance_tester]

Prise en charge du test de résonance et du calibrage automatique du façonneur d'entrée (input shaper). Pour utiliser la plupart des fonctionnalités de ce module, des dépendances logicielles supplémentaires doivent être installées ; reportez-vous à [Measuring Resonances](Measuring_Resonances.md) et à la [référence de commande](G-Codes.md#resonance_tester) pour plus d'informations. Voir la section [Adoucissement Max](Measuring_Resonances.md#max-smoothing) du guide de mesure des résonances pour plus d'informations sur le paramètre `max_smoothing` et son utilisation.

```
[resonance_tester]
#probe_points:
#    Une liste de coordonnées X, Y, Z de points (un point par ligne) à tester.
#    Au moins un point est requis. Assurez-vous que tous les points avec une certaine marge
#    de sécurité dans le plan XY (~ quelques centimètres) sont accessibles par la tête de l'outil.
#accel_chip:
#    Nom de la puce d'accéléromètre à utiliser pour les mesures. Si la puce adxl345 a été définie
#    sans un nom explicite, ce paramètre peut simplement la référencer en tant que
#    "accel_chip : adxl345", sinon un nom explicite doit être fourni, par exemple
#    "accel_chip : adxl345 my_chip_name". Soit ce paramètre seul, soit les deux paramètres
#    suivants doivent être définis.
#accel_chip_x:
#accel_chip_y:
#    Noms des puces d'accéléromètre à utiliser pour les mesures de chaque axe.
#    Peut être utile, par exemple, sur une imprimante de type "bed slinger", si deux accéléromètres
#    séparés sont montés, un sur le lit (pour l'axe Y), l'autre sur la tête de l'outil (pour l'axe X).
#    Ces paramètres ont le même format que le paramètre 'accel_chip'. Soit le paramètre
#    'accel_chip' soit ces deux paramètres doivent être fournis.
#max_smoothing:
#    Lissage maximal du façonneur (shaper) d'entrée à autoriser pour chaque axe pendant
#    l'auto-calibration (avec la commande 'SHAPER_CALIBRATE'). Par défaut, aucun lissage
#    maximal n'est spécifié. Reportez-vous au guide Measuring_Resonances pour plus de détails
#    sur l'utilisation de cette fonction.
#min_freq: 5
#    Fréquence minimale de test des résonances. La valeur par défaut est 5 Hz.
#max_freq: 133.33
#    Fréquence maximale de test des résonances. La valeur par défaut est 133,33 Hz.
#accel_per_hz: 75
#    Ce paramètre permet de déterminer l'accélération à utiliser pour tester une fréquence
#    spécifique: accel = accel_per_hz * freq. Plus haute est cette valeur, plus l'énergie des
#    oscillations est élevée. Peut être fixé à une valeur inférieure à celle par défaut si les
#    résonances deviennent trop fortes sur l'imprimante. Cependant, des valeurs plus faibles
#    rendent les mesures des résonances à haute fréquence moins précises. La valeur par
#    défaut est de 75 (mm/sec).
#hz_per_sec: 1
#    Détermine la vitesse de l'essai. Lors du test de toutes les fréquences dans la plage [min_freq,
#    max_freq], chaque seconde, la fréquence augmente de hz_per_sec.
#    De faibles valeurs rendent le test lent, de grandes valeurs diminueront la précision du test.
#    La valeur par défaut est 1.0 (Hz/sec == sec^-2).
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

Sonde de hauteur Z. On peut définir cette section pour activer le matériel de nivelage de l'axer Z. Lorsque cette section est activée, les commandes [g-code étendus](G-Codes.md#probe) PROBE et QUERY_PROBE deviennent disponibles. Consultez également le [guide d'étalonnage des sondes](Probe_Calibrate.md). La section probe crée également une broche virtuelle "probe:z_virtual_endstop". Il est possible de définir la broche du stepper_z, endstop_pin, sur cette broche virtuelle pour les imprimantes de style cartésien qui utilisent la sonde à la place d'un interrupteur de fin de course Z. Si vous utilisez "probe:z_virtual_endstop", ne définissez pas de position_endstop dans la configuration de la section stepper_z.

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

Le "Smart Effector" de Duet3d implémente une sonde Z utilisant un capteur de force. On peut définir cette section à la place de `[probe]` pour activer les fonctionnalités spécifiques du Smart Effector. Cela permet également d'activer les [commandes d'exécution](G-Codes.md#smart_effector) afin d'ajuster les paramètres du Smart Effector au moment de l'exécution.

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

## Moteurs pas à pas et extrudeurs additionnels

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

Prise en charge des imprimantes cartésiennes avec deux chariots sur un seul axe. Le chariot actif est défini par la commande g-code étendue SET_DUAL_CARRIAGE. La commande "SET_DUAL_CARRIAGE CARRIAGE=1" active le chariot défini dans cette section (CARRIAGE=0 ramène l'activation au chariot principal). Le support du double chariot est généralement combiné avec des extrudeuses supplémentaires - la commande SET_DUAL_CARRIAGE est souvent appelée en même temps que la commande ACTIVATE_EXTRUDER. Veillez à garer les chariots pendant la désactivation.

Voir [sample-idex.cfg](../config/sample-idex.cfg) pour un exemple de configuration.

```
[dual_carriage]
axis:
#    L'axe sur lequel se trouve ce chariot supplémentaire (soit x, soit y). Ce paramètre
#   doit être fourni.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   Voir la section "stepper" pour la définition des paramètres ci-dessus.
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
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#    Voir la section "stepper" pour une description de ces paramètres.
#velocity:
#    Définit la vitesse par défaut (en mm/s) pour le pilote moteur. Cette valeur
#    sera utilisée si une commande MANUAL_STEPPER ne spécifie pas de paramètre SPEED
#    La valeur par défaut est 5mm/s.
#accel 
#    Définit l'accélération par défaut (en mm/s^2) pour le pilote moteur Une
#    accélération de zéro n'entraînera aucune accélération. Cette valeur
#    sera utilisée si une commande MANUAL_STEPPER ne spécifie pas de
#    paramètre ACCEL. La valeur par défaut est zéro.
#endstop_pin:
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
#    L'erreur maximale de température cumulée avant de déclencher une erreur.
#    Des valeurs plus petites entraînent une vérification plus stricte et des valeurs plus grandes
#    permettent un délai plus long avant qu'une erreur ne soit signalée.
#    Plus précisément, la température est inspectée une fois par seconde et si elle
#    est proche de la température cible, un "compteur d'erreurs" interne est remis à zéro;
#    sinon, si la température est inférieure à la plage cible, le compteur est augmenté
#    de la quantité de température rapportée diffèrant de cette plage. Si le compteur
#    dépasse ce "max_error", une erreur est signalée. La valeur par défaut est 120.
#check_gain_time:
#    Ceci contrôle la vérification du chauffage durant la chauffe initiale. Des valeurs plus petites
#    entraînent une vérification plus stricte et des valeurs plus grandes autorisent un délai
#    plus grand avant qu'une erreur ne soit signalée. Spécifiquement, pendant la chauffe initiale,
#    tant que la température de l'élément chauffant augmente durant ce laps de temps (spécifié
#    en secondes), le "compteur d'erreurs" interne est remis à zéro.
#    La valeur par défaut est de 20 secondes pour les extrudeuses et 60 secondes pour le lit chauffant.
#hysteresis: 5
#    La différence de température maximale (en Celsius) par rapport à une température cible
#   considérée comme située dans la plage de la cible. Ceci contrôle la vérification de la plage
#   du paramètre max_error. Il est rare de personnaliser cette valeur.
#   La valeur par défaut est 5.
#heating_gain: 2
#    La température minimale (en Celsius) pour laquelle le chauffage doit progresser
#    pendant la période de check_gain_time. Il est rare de personnaliser cette valeur.
#    La valeur par défaut est 2.
```

### [homing_heaters]

Outil pour désactiver les éléments chauffants lors de la prise d'origine ou du palpage d'un axe.

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
[thermistor mon_thermistor]
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
#temperature1:
#voltage1:
#temperature2:
#voltage2:
#...
#    Un ensemble de températures (en Celsius) et de tensions (en Volts) à utiliser comme 
#    référence lors de la conversion d'une température. Une section de chauffage utilisant
#    ce capteur peut également spécifier les paramètres adc_voltage et voltage_offset
#    pour définir la tension ADC (voir la section "Amplificateurs communs de température"
#    pour plus de détails). Au moins deux mesures doivent être fournies.
#temperature1:
#resistance1:
#temperature2:
#resistance2:
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

### Capteurs de température BMP280/BME280/BME680

Capteurs environnementaux BMP280/BME280/BME680 à interface à deux fils (I2C). Notez que ces capteurs ne sont pas destinés à être utilisés avec des extrudeurs et des lits chauffants, mais plutôt pour surveiller la température ambiante (C), la pression (hPa), l'humidité relative et, dans le cas du BME680, le niveau de gaz. Voir [sample-macros.cfg](../config/sample-macros.cfg) pour un gcode_macro pouvant être utilisé pour signaler la pression et l'humidité en plus de la température.

```
sensor_type: BME280
#i2c_address:
#    La valeur par défaut est 118 (0x76). Certains capteurs BME280 ont une adresse de 119
#    (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#    Voir la section "paramètres I2C communs" pour une description des
#    paramètres ci-dessus.
```

### Capteur HTU21D

Capteur d'environnement de la famille HTU21D à interface à deux fils (I2C). Notez que ce capteur n'est pas destiné à être utilisé avec les extrudeuses et les lits chauffants, mais plutôt à surveiller la température ambiante (C) et l'humidité relative. Voir [sample-macros.cfg](../config/sample-macros.cfg) pour un gcode_macro utilisable permettant d'indiquer l'humidité en plus de la température.

```
sensor_type:
#    Doit être "HTU21D" , "SI7013", "SI7020", "SI7021" ou "SHT21".
#i2c_address:
#    La valeur par défaut est 64 (0x40).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#    Voir la section "paramètres I2C communs" pour une description des
#    paramètres ci-dessus.
#htu21d_hold_master:
#    Si le capteur peut maintenir le tampon I2C durant la lecture. Si True, aucune autre
#    communication par bus ne peut être effectuée durant la lecture en cours.
#    La valeur par défaut est False.
#htu21d_resolution:
#    La résolution de lecture de la température et de l'humidité.
#    Les valeurs valides sont :
#    'TEMP14_HUM12' -> 14 bits pour la température et 12 bits pour l'humidité.
#    'TEMP13_HUM10' -> 13 bits pour la température et 10 bits pour l'humidité.
#    'TEMP12_HUM08' -> 12 bits pour la température et 08 bits pour l'humidité
#    'TEMP11_HUM11' -> 11 bits pour la température et 11 bits pour l'humidité
#    La valeur par défaut est "TEMP11_HUM11"
#htu21d_report_time:
#    Intervalle en secondes entre les lectures. La valeur par défaut est 30
```

### Capteur de température LM75

Capteurs de température LM75/LM75A connectés en deux fils (I2C). Ces capteurs ont une gamme de -55~125 °C, et sont donc utilisables par exemple pour la surveillance de la température d'une chambre. Ils peuvent aussi fonctionner comme de simples contrôleurs de ventilateurs/éléments chauffants.

```
sensor_type: LM75
#i2c_address:
#    La valeur par défaut est 72 (0x48). La plage normale est 72-79 (0x48-0x4F), les 3
#    bits de poids faible de l'adresse sont configurés via des broches sur la puce
#    (généralement avec des cavaliers ou câblés).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#    Voir la section "paramètres I2C communs" pour une description des
#    paramètres ci-dessus.
#lm75_report_time:
#    Intervalle en secondes entre les lectures. La valeur par défaut est 0.8, avec un
#    minimum de 0.5.
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

Température de la machine (par exemple Raspberry Pi) qui exécute le logiciel hôte.

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
[heater_fan my_nozzle_fan]
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
#    Voir la section "fan" pour une description des paramètres ci-dessus.
#heater: extruder
#    Nom de la section de configuration définissant le chauffage auquel ce ventilateur est associé.
#    Si une liste de noms d'éléments chauffants séparés par des virgules est fournie ici, le
#    ventilateur sera activé lorsque l'un des chauffages donnés est activé.
#    La valeur par défaut est "extruder".
#heater_temp: 50.0
#    Température (en Celsius) en dessous de laquelle l'élément chauffant doit descendre pour que
#    le ventilateur soit désactivé. La valeur par défaut est 50 °C.
#fan_speed: 1.0
#    La vitesse du ventilateur (exprimée sous la forme d'une valeur comprise entre 0,0 et 1,0) à
#    laquelle le ventilateur sera réglé lorsque l'élément chauffant qui lui est associé est activé.
#    La valeur par défaut est 1.0
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

Ventilateurs de refroidissement déclenchés par la température (on peut définir un nombre quelconque de sections avec le préfixe "temperature_fan"). Un "ventilateur de température" est un ventilateur activé lorsque le capteur qui lui est associé est au-dessus d'une température définie. Par défaut, un ventilateur de température a une vitesse d'arrêt égale à la puissance maximale.

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
#    pour le système de contrôle par rétroaction PID. Klipper évalue les paramètres PID
#    avec la formule générale suivante :
#        fan_pwm = max_power - (Kp*e + Ki*integral(e) - Kd*derivative(e)) / 255
#    Où "e" est "température_cible - température_mesurée" et
#    "fan_pwm" est le débit du ventilateur demandé, 0,0 correspondant à un arrêt complet et
#    1,0 correspond à un fonctionnement à plein régime. Les paramètres pid_Kp, pid_Ki, et pid_Kd
#    doivent être fournis lorsque l'algorithme de contrôle PID est activé.
#pid_deriv_time: 2.0
#    Une durée (en secondes) sur laquelle les mesures de température seront lissées lors de
#    l'utilisation de l'algorithme de contrôle PID. Cela peut réduire l'impact du bruit de mesure.
#    La valeur par défaut est de 2 secondes.
#target_temp: 40.0
#    Une température (en Celsius) qui sera la température cible.
#    La valeur par défaut est 40 degrés.
#max_speed: 1.0
#    La vitesse du ventilateur (exprimée comme une valeur de 0,0 à 1,0) à laquelle le ventilateur
#    sera réglé lorsque la température du capteur dépassera la valeur définie.
#    La valeur par défaut est 1.0.
#min_speed: 0.3
#    Vitesse minimale du ventilateur (exprimée sous la forme d'une valeur comprise entre 0,0 et 1,0)
#    à laquelle le ventilateur sera réglé pour les ventilateurs à température PID.
#    La valeur par défaut est 0,3.
#gcode_id:
#    S'il est défini, la température sera signalée dans les requêtes M105 en utilisant l'identifiant
#    id donné. La valeur par défaut est de ne pas rapporter la température via M105.
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

Prise en charge des LEDs (et des bandes de LED) contrôlées par les broches PWM du microcontrôleur (on peut définir un nombre quelconque de sections avec le préfixe "led"). Voir la [référence de la commande](G-Codes.md#led) pour plus d'informations.

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
#i2c_address : 98
#    L'adresse i2c que la puce utilise sur le bus i2c. Utilisez 98 pour
#    le PCA9533/1, 99 pour le PCA9533/2. La valeur par défaut est 98.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#    Voir la section "paramètres I2C communs" pour une description des
#    paramètres ci-dessus.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#    Voir la section "led" pour des informations sur ces paramètres.
```

### [pca9632]

Support des LEDs du PCA9632. Le PCA9632 est utilisé sur le FlashForge Dreamer.

```
[pca9632 my_pca9632]
#i2c_address  98
#    L'adresse i2c que la puce utilise sur le bus i2c. Cela peut être
#    96, 97, 98, ou 99.  La valeur par défaut est 98.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#    Voir la section "paramètres I2C communs" pour une description des
#    paramètres ci-dessus.
#scl_pin:
#sda_pin:
#    Alternativement, si le pca9632 n'est pas connecté à un bus matériel I2C
#    il est possible de spécifier les broches "clock" (scl_pin) et "data" (sda_pin).
#    Le défaut est d'utiliser l'I2C matériel.
#color_order : RGBW
#    Définit l'ordre des pixels de la LED (en utilisant une chaîne contenant les lettres
#    R, G, B, W). La valeur par défaut est RGBW.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#    Voir la section "led" pour des informations sur ces paramètres.
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
#    La broche à configurer comme une sortie. Ce paramètre doit être
#    fourni.
#pwm: False
#    Définit si la broche de sortie doit être capable de modulation de largeur d'impulsion.
#    Si ce paramètre est vrai, les champs de valeur doivent être compris entre 0 et 1.
#    La valeur par défaut est False.
#static_value:
#    Si cette valeur est définie, la broche est affectée à cette valeur au démarrage et
#    la broche ne peut pas être modifiée pendant l'exécution. Une broche statique utilise
#    légèrement moins de RAM dans le micro-contrôleur. Le défaut est d'utiliser
#    la configuration des broches paramétrées lors du démarrage.
#value:
#    La valeur à donner initialement à la broche pendant la configuration du MCU.
#    La valeur par défaut est 0 (pour une tension basse).
#shutdown_value:
#    La valeur à donner à la broche lors d'un événement d'arrêt du MCU. La valeur par
#    défaut est 0 (pour une tension basse).
#maximum_mcu_duration:
#    La durée maximale pendant laquelle une valeur de non-arrêt peut être pilotée par
#    le MCUsans un accusé de réception de l'hôte.
#    Si l'hôte ne peut pas suivre une mise à jour, le MCU s'éteindra et mettra
#    toutes les broches à leurs valeurs d'arrêt respectives.
#    Défaut : 0 (désactivé)
#    Les valeurs habituelles sont d'environ 5 secondes.
#cycle_time: 0.100
#    La durée (en secondes) par cycle PWM. Il est recommandé que ce soit
#    10 millisecondes ou plus lorsque vous utilisez un PWM logiciel.
#    La valeur par défaut est de 0.100 secondes pour les broches PWM.
#hardware_pwm: False
#    Activez pour utiliser le PWM matériel au lieu du PWM logiciel. Lors de
#    l'utilisation d'un PWM matériel, le temps de cycle réel est limité par
#    l'implémentation et peut être significativement différent du
#    cycle_time demandé. La valeur par défaut est False.
#scale :
#    Ce paramètre peut être utilisé pour modifier la façon dont les paramètres 'value'
#    et 'shutdown_value' sont interprétés pour les broches pwm. Si fourni, alors
#    le paramètre 'value' doit être compris entre 0.0 et 'scale'. Cela peut être utile
#    lors de la configuration d'une broche PWM contrôlant une référence de tension
#    d'un moteur pas à pas. L''échelle' peut être définie sur l'intensité du moteur pas
#    à pas équivalent si le PWM était entièrement activé, et puis le paramètre 'value'
#    peut être spécifié en utilisant l'intensité souhaitée pour le moteur pas à pas. La
#    valeur par défaut est de ne pas mettre à l'échelle le paramètre 'value'.
```

### [static_digital_output]

Broches de sortie numérique configurées statiquement (on peut définir un nombre quelconque de sections avec un préfixe "static_digital_output"). Les broches configurées ici seront configurées comme une sortie GPIO pendant la configuration du MCU. Elles ne peuvent pas être modifiées en cours d'exécution.

```
[static_digital_output my_output_pins]
pins:
#    Une liste de broches séparées par des virgules à définir comme broches de sortie GPIO. La broche
#    sera définie à un niveau haut, sauf si le nom de la broche est précédé de "!". 
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
#    La broche correspondant à la ligne de sélection de la puce TMC2130. Cette broche
#    sera mise à l'état bas au début des messages SPI et remontée à l'état haut 
#    après la fin du message. Ce paramètre doit être fourni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    Voir la section "paramètres SPI communs" pour une description des
#    paramètres ci-dessus.
#chain_position:
#chain_length:
#    Ces paramètres configurent une guirlande SPI. Les deux paramètres
#    définissent la position du pilote dans la chaîne et la longueur totale de la chaîne.
#    La position 1 correspond au pilote qui se connecte au signal MOSI.
#    La valeur par défaut est de ne pas utiliser de guirlande SPI.
#interpolate: True
#    Si true, active l'interpolation des pas (le pilote va faire un pas interne à
#    un taux de 256 micro-pas). Cette interpolation introduit une petite déviation
#    systémique de la position - voir TMC_Drivers.md pour plus de détails.
#    La valeur par défaut est True.
run_current:
#    La quantité de courant (en ampères RMS) à configurer que le pilote utilise
#    pendant le mouvement pas à pas. Ce paramètre doit être fourni.
#hold_current:
#    La quantité de courant (en ampères RMS) à configurer que le pilote utilise
#    lorsque le moteur pas à pas n'est pas en mouvement. La définition d'un hold_current n'est pas
#    recommandé (voir TMC_Drivers.md pour plus de détails). La valeur par défaut est de
#    ne pas réduire le courant.
#sense_resistor: 0.110
#    La résistance (en ohms) de la résistance de détection du moteur (Vréf). La valeur par défaut
#    est de 0.110 ohms.
#stealthchop_threshold: 0
#    La vitesse (en mm/s) à laquelle le seuil "stealthChop" doit être fixé. Lorsque
#    défini, le mode "stealthChop" sera activé si la vitesse du moteur pas à pas
#    est inférieure à cette valeur. La valeur par défaut est 0, ce qui désactive
#    le mode "stealthChop".
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 0
#driver_TBL: 1
#driver_TOFF: 4
#driver_HEND: 7
#driver_HSTRT: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 4
#driver_PWM_AMPL: 128
#driver_SGT: 0
#    Définir le registre donné pendant la configuration de la puce TMC2130.
#    Ceci peut être utilisé pour définir les paramètres personnalisés du moteur. Les valeurs par défaut de
#    chaque paramètre sont indiquées à côté du nom du paramètre dans la liste ci-dessus.
#diag0_pin:
#diag1_pin:
#    La broche du microcontrôleur reliée à l'une des lignes DIAG de la puce
#    TMC2130. Une seule broche diag doit être spécifiée. La broche
#    est "active low" et est donc normalement précédée de "^ !". Ce réglage
#    crée une broche virtuelle "tmc2130_stepper_x:virtual_endstop".
#    pouvant être utilisée comme broche de fin de course du moteur. Cela permet d'activer le
#    "sensorless homing". (Assurez-vous de régler également driver_SGT à une
#    valeur de sensibilité appropriée). La valeur par défaut est de ne pas activer
#    la recherche d'origine sans capteur.
```

### [tmc2208]

Configuration d'un pilote de moteur pas à pas TMC2208 (ou TMC2224) via un UART à fil unique. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2208" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2208 stepper_x]").

```
[tmc2208 stepper_x]
uart_pin:
#    La broche connectée à la ligne PDN_UART de la TMC2208. Ce paramètre
#    doit être fourni.
#tx_pin:
#    Si vous utilisez des lignes de réception et de transmission séparées pour communiquer avec
#    le pilote, réglez uart_pin sur la broche de réception et tx_pin sur la broche d'émission.
#    La valeur par défaut est d'utiliser uart_pin pour la lecture et l'écriture.
#select_pins:
#    Une liste de broches, séparées par des virgules, à définir avant d'accéder à l'UART du
#    tmc2208. Ceci peut être utile pour configurer un mux analogique pour la
#    la communication UART. La valeur par défaut est de ne pas configurer de broches.
#interpolate: True
#    Si true, active l'interpolation de pas (le pilote fera un pas interne à un taux de 256 micro-pas).
#    Cette interpolation introduit une petite déviation systémique de la position - voir
#    TMC_Drivers.md pour plus de détails. La valeur par défaut est True.
run_current:
#    La quantité de courant (en ampères RMS) à configurer que le pilote utilise
#    pendant le mouvement du pas. Ce paramètre doit être fourni.
#hold_current:
#    La quantité de courant (en ampères RMS) à configurer que le pilote utilise 
#    lorsque le moteur pas à pas n'est pas en mouvement. La définition d'un hold_current n'est pas
#    recommandée (voir TMC_Drivers.md pour plus de détails). La valeur par défaut est de
#    ne pas réduire le courant.
#sense_resistor: 0.110
#    La résistance (en ohms) de la résistance de détection du moteur (Vréf). La valeur par défaut
#    est de 0.110 ohms.
#stealthchop_threshold: 0
#    La vitesse (en mm/s) à laquelle le seuil "stealthChop" doit être fixé. Lorsque
#    défini, le mode "stealthChop" sera activé si la vitesse du moteur pas à pas
#    est inférieure à cette valeur. La valeur par défaut est 0, ce qui désactive
#    le mode "stealthChop".
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
#    Définissez le registre donné pendant la configuration de la puce TMC2208.
#    Ceci peut être utilisé pour définir les paramètres personnalisés du moteur. Les valeurs par défaut de
#    chaque paramètre sont indiquées à côté du nom du paramètre dans la liste ci-dessus.
```

### [tmc2209]

Configuration d'un pilote de moteur pas à pas TMC2209 via un UART à fil unique. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2209" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2209 stepper_x]").

```
[tmc2209 stepper_x]
uart_pin:
#tx_pin 
#select_pins:
#interpolate: True
run_current:
#hold_current:
#sense_resistor: 0.110
#stealthchop_threshold: 0
#    Voir la section "tmc2208" pour la définition de ces paramètres.
#uart_address:
#    L'adresse de la puce TMC2209 pour les messages UART (un entier entre 0 et 3).
#    entre 0 et 3). Ce paramètre est généralement utilisé lorsque plusieurs puces TMC2209
#    sont connectées à la même broche UART. La valeur par défaut est zéro.
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
#    Définir le registre donné pendant la configuration de la puce TMC2209.
#    Ceci peut être utilisé pour définir les paramètres personnalisés du moteur. Les valeurs par défaut de
#    chaque paramètre sont indiquées à côté du nom du paramètre dans la liste ci-dessus.
#diag_pin:
#    La broche du microcontrôleur reliée à la ligne DIAG de la puce TMC2209.
#    La broche est normalement précédée de "^" pour activer un pullup.
#    Le paramétrage de cette broche crée une broche virtuelle "tmc2209_stepper_x:virtual_endstop"
#    pouvant être utilisée comme broche d'arrêt du stepper. Ainsi cela active le "sensorless homing".
#    (Assurez-vous de définir également driver_SGTHRS à une valeur de sensibilité appropriée).
#    La valeur par défaut est de ne pas activer la recherche d'origine sans capteur.
```

### [tmc2660]

Configuration d'un pilote de moteur pas à pas TMC2660 via le bus SPI. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2660" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2660 stepper_x]").

```
[tmc2660 stepper_x]
cs_pin:
#    La broche correspondant à la ligne de sélection de la puce TMC2660. Cette broche
#    sera mise à l'état bas au début des messages SPI et passera à l'état haut
#    après la fin du transfert du message. Ce paramètre doit être fourni.
#spi_speed: 4000000
#    Fréquence du bus SPI utilisée pour communiquer avec le pilote de pas à pas TMC2660.
#    La valeur par défaut est 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    Voir la section "paramètres SPI communs" pour une description des
#    paramètres ci-dessus.
#interpolate: True
#    Si vrai, active l'interpolation par pas (le pilote fera un pas interne à un taux de 256 micro-pas).
#    Cela ne fonctionne que si les micro-pas sont fixés à 16. L'interpolation introduit une petite
#    déviation systémique positionnelle - voir TMC_Drivers.md pour plus de détails.
#    La valeur par défaut est True.
run_current:
#    La quantité de courant (en ampères RMS) utilisée par le pilote pendant le déplacement du
#    moteur pas à pas. Ce paramètre doit être fourni.
#sense_resistor:
#    La résistance (en ohms) de la résistance de détection du moteur (Vréf). Ce paramètre
#    doit être fourni.
#idle_current_percent  100
#    Le pourcentage du courant de fonctionnement auquel le pilote pas à pas sera
#    abaissé lorsque le délai d'inactivité expirera (vous devez configurer le
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
#    Ceci peut être utilisé pour définir des paramètres de pilote personnalisés. Les valeurs par défaut de
#    chaque paramètre sont indiquées à côté du nom du paramètre dans la liste ci-dessus.
#    Consultez la fiche technique du TMC2660 pour connaître la fonction de chaque paramètre ainsi que
#   les restrictions sur les combinaisons de paramètres. Soyez particulièrement attentif au
#    registre CHOPCONF, où le fait de régler CHM à soit zéro, soit un, entraîne des modifications de
#   la disposition (le premier bit de HDEC est interprété comme le MSB de HSTRT dans ce cas).
```

### [tmc5160]

Configuration d'un pilote de moteur pas à pas TMC5160 via le bus SPI. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc5160" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc5160 stepper_x]").

```
[tmc5160 stepper_x]
cs_pin:
#    La broche correspondant à la ligne de sélection de la puce TMC5160. Cette broche
#    sera mise à l'état bas au début des messages SPI et remontée à l'état haut
#    après la fin du message. Ce paramètre doit être fourni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    Voir la section "paramètres SPI communs" pour une description des
#    paramètres ci-dessus.
#chain_position:
#chain_length:
#    Ces paramètres configurent une guirlande SPI. Les deux paramètres
#    définissent la position du pilote dans la chaîne et la longueur totale de la chaîne.
#    La position 1 correspond au pilote qui se connecte au signal MOSI.
#    La valeur par défaut est de ne pas utiliser de guirlande SPI.
# Interpolate: True
#    Si true, active l'interpolation de pas (le pilote va faire un pas interne à un taux
#    de 256 micro-pas). La valeur par défaut est True.
run_current:
#    La quantité de courant (en ampères RMS) pour configurer le pilote qu'il utilisera
#    pendant le mouvement du moteur pas à pas. Ce paramètre doit être fourni.
#hold_current:
#    La quantité de courant (en ampères RMS) à configurer que le pilote utilise
#    lorsque le moteur pas à pas n'est pas en mouvement. La définition d'un hold_current n'est pas
#    recommandée (voir TMC_Drivers.md pour plus de détails). La valeur par défaut est de
#    ne pas réduire le courant.
#sense_resistor: 0.075
#    La résistance (en ohms) de la résistance de détection du moteur (Vréf). La valeur par défaut
#    est de 0,075 ohms.
#stealthchop_threshold: 0
#    La vitesse (en mm/s) à laquelle le seuil de "stealthChop" doit être fixé. Lorsque
#    défini, le mode "stealthChop" sera activé si la vitesse du moteur pas à pas
#    est inférieure à cette valeur. La valeur par défaut est 0, ce qui désactive
#    le mode "stealthChop".
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
#    Définit les registres à régler pendant la configuration de la puce TMC5160
#    Ceci peut être utilisé pour définir les paramètres personnalisés du moteur.
#    Les valeurs par défaut de chaque paramètre sont à côté du nom du paramètre
#    dans la liste ci-dessus.
#diag0_pin:
#diag1_pin:
#    La broche du microcontrôleur reliée à l'une des lignes DIAG de la puce TMC5160.
#    Une seule broche diag doit être spécifiée. La broche est "active low" et est donc
#    normalement précédée de "^ !". Ce réglage crée une broche virtuelle
#    "tmc5160_stepper_x:virtual_endstop" pouvant être utilisée comme broche d'arrêt
#    du moteur. Cela permet d'activer le mode "sensorless homing". (Assurez-vous de
#    régler également driver_SGT à une valeur de sensibilité appropriée).
#    La valeur par défaut est de ne pas activer la recherche d'origine sans capteur.
```

## Configuration du courant du moteur pas à pas en temps réel

### [ad5206]

Digipots AD5206 configurés statiquement et connectés via un bus SPI (on peut définir un nombre quelconque de sections avec un préfixe "ad5206").

```
[ad5206 my_digipot]
enable_pin:
#    La broche correspondant à la ligne de sélection de la puce AD5206. Cette broche
#    sera réglée à un niveau bas au début des messages SPI et sera relevée à un niveau élevé
#    après la fin du message. Ce paramètre doit être fourni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    Voir la section "paramètres communs SPI" pour une description des paramètres ci-dessus.
#    
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
#     La valeur pour définir statiquement le canal AD5206 donné. Cette valeur est
#     généralement définie sur un nombre compris entre 0,0 et 1,0. 1,0 étant la résistance
#     la plus élevée et 0,0 la résistance la plus faible. Cependant,  la plage peut être
#     modifiée à l'aide du paramètre 'scale' (voir ci-dessous).
#     Si un canal n'est pas spécifié, il n'est pas configuré.
# scale:
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
[mcp4451 mon_digipot]
i2c_address:
#    L'adresse i2c que la puce utilise sur le bus i2c. Ce paramètre
#    doit être fourni.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#    Voir la section "paramètres I2C communs" pour une description des
#    paramètres ci-dessus.
#wiper_0:
#wiper_1:
#wiper_2:
#wiper_3:
#    La valeur pour définir statiquement le "wiper" MCP4451 donné. Cette valeur est
#    généralement réglée sur un nombre compris entre 0.0 et 1.0, 1.0 étant la résistance
#    la plus élevée et 0.0 la résistance la plus faible. Cependant, la plage peut être modifiée
#    à l'aide du paramètre 'scale' (voir ci-dessous). Si un wiper n'est pas spécifié, il n'est
#    pas configuré.
#scale:
#    Ce paramètre peut être utilisé pour modifier l'interprétation des paramètres 'wiper_x'.
#    S'il est fourni, alors les paramètres 'wiper_x' doivent être compris entre 0,0 et 'scale'.
#    Ceci peut être utile lorsque le MCP4451 est utilisé pour définir des références de tension
#    du pilote pas à pas.L''échelle' peut être réglée sur l'intensité du pilote pas à pas équivalent
#    si le MCP4451 était à sa résistance la plus élevée, puis les paramètres 'wiper_x' peuvent
#    être spécifiés en utilisant la valeur d'intensité désirée pour le pilote pas à pas. La valeur
#    par défaut est de ne pas mettre à l'échelle les paramètres 'wiper_x'.
```

### [mcp4728]

Convertisseur numérique-analogique MCP4728 configuré statiquement et connecté via le bus I2C (on peut définir un nombre quelconque de sections avec un préfixe "mcp4728").

```
[mcp4728 my_dac]
#i2c_address: 96
#    L'adresse i2c que la puce utilise sur le bus i2c. La valeur par défaut
#    est 96.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#    Voir la section "paramètres I2C communs" pour une description des
#    paramètres ci-dessus.
#channel_a:
#channel_b:
#channel_c:
#channel_d:
#    La valeur pour définir statiquement le canal MCP4728 donné. Ceci est
#    généralement définie par un nombre compris entre 0.0 et 1.0, 1.0 représentant
#    la tension la plus élevée (2.048V) et 0.0 la tension la plus basse.
#    Cependant, la plage peut être modifiée à l'aide du paramètre 'scale' (cf.
#    ci-dessous). Si un canal n'est pas spécifié, il n'est pas configuré.
#scale:
#    Ce paramètre peut être utilisé pour modifier l'interprétation des paramètres 'channel_x'.
#    S'il est fourni, le paramètre 'channel_x' doit être compris entre 0,0 et 'scale'.
#    Cela peut être utile lorsque le MCP4728 est utilisé pour définir des références de tension
#    de moteur pas à pas. L''échelle' peut être réglée sur l'intensité équivalente de la commande
#    de moteur pas à pas si le MCP4728 était à sa tension la plus élevée (2.048V), et ensuite les
#    paramètres 'channel_x' peuvent être spécifiés en utilisant l'intensité désirée pour le
#    moteur pas à pas. La valeur par défaut est de ne pas mettre à l'échelle les
#    paramètres 'channel_x'.
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
#   Le type de puce LCD utilisé. Cela peut être "hd44780", "hd44780_spi", "st7920",
#   "emulated_st7920", "uc1701", "ssd1306", ou "sh1106".
#   Voir les sections d'affichage ci-dessous pour plus d'informations sur chaque type
#   et les paramètres supplémentaires qu'ils fournissent. Ce paramètre doit être
#   fourni.
#display_group:
#   Le nom du groupe de données à afficher sur l'écran. Cela contrôle le contenu de
#   l'écran (voir la section "display_data" pour plus d'informations). La valeur par
#   défaut est _default_20x4 pour les écrans hd44780 et _default_16x4 pour les
#   autres affichages.
#menu_timeout:
#   Délai d'attente pour le menu. Le fait d'être inactif pendant ce nombre de secondes
#   déclenchera la sortie du menu ou le retour au menu racine si l'autorun est activé.
#   La valeur par défaut est 0 seconde (désactivé)
#menu_root:
#   Nom de la section du menu principal à afficher lorsque vous cliquez sur l'encodeur
#   de l'écran d'accueil. La valeur par défaut est __main, et cela affiche les menus par
#   défaut tels que définis dans klippy/extras/display/menu.cfg
#menu_reverse_navigation:
#   Lorsque activé, inverse les directions vers le haut et vers le bas de la liste.
#   La valeur par défaut est False. Ce paramètre est optionnel.
#encoder_pins:
#   Les broches connectées à l'encodeur. 2 broches doivent être fournies lorsque vous
#   utilisez l'encodeur. Ce paramètre doit être fourni lors de l'utilisation du menu.
#encoder_steps_per_detent:
#   Combien de pas l'encodeur émet par cran ("clic"). Si l'encodeur prend deux crans pour
#   se déplacer entre les entrées ou déplace deux entrées à partir d'un seul cran, essayez de
#   modifier cette valeur. Les valeurs autorisées sont 2 (demi-step) ou 4 (full-step).
#   La valeur par défaut est 4.
#click_pin:
#   La broche connectée au bouton 'entrée' ou au 'clic' de l'encodeur. Ce paramètre doit
#   être fourni lors de l'utilisation du menu. La présence d'un paramètre de configuration
#   'analog_range_click_pin' fait passer ce paramètre de numérique à analogique.
#back_pin:
#   La broche connectée au bouton 'retour'. Ce paramètre est facultatif, le menu peut être utilisé
#   sans lui. La présence d'un paramètre de configuration 'analog_range_back_pin'  transforme 
#   ce paramètre de numérique à analogique.
#up_pin:
#   La broche connectée au bouton 'haut'. Ce paramètre doit être fourni lorsque vous utilisez un
#   menu sans encodeur. La présence d'un paramètre de configuration 'analog_range_up_pin' 
#   transforme ce paramètre de numérique à analogique.
#down_pin:
#   La broche connectée au bouton 'bas'. Ce paramètre doit être fourni lorsque vous utilisez un
#   menu sans encodeur. La présence d'un paramètre de configuration 'analog_range_down_pin' 
#   transforme ce paramètre de numérique à analogique.
#kill_pin:
#   La broche connectée au bouton 'kill'. Ce bouton appellera l'arrêt d'urgence. La présence d'un
#   paramètre 'analog_range_kill_pin'  fait passer ce paramètre de numérique à analogique.
#analog_pullup_resistor: 4700
#   La résistance (en ohms) du pullup attaché au bouton analogique.
#   La valeur par défaut est de 4700 ohms.
#analog_range_click_pin:
#   La plage de résistances du bouton 'entrée'. Les valeurs minimale et maximale de la plage
#   séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
#analog_range_back_pin:
#   La plage de résistances du bouton 'retour'. Les valeurs minimale et maximale de la plage
#   séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
#analog_range_up_pin:
#   La plage de résistances du bouton 'haut'. Les valeurs minimale et maximale de la plage
#   séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
#analog_range_down_pin:
#   La plage de résistances du bouton 'bas'. Les valeurs minimale et maximale de la plage
#   séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
#analog_range_kill_pin:
#   La plage de résistances du bouton 'kill'. Les valeurs minimale et maximale de la plage
#   séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
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
#   Définir à "ssd1306" ou "sh1106" pour le type d'affichage donné.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   Paramètres optionnels disponibles pour des écrans connectés via un bus i2c.
#   Voir la section "Paramètres I2C communs" pour une description des
#   paramètres ci-dessus.
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Les broches connectées au lcd en mode spi "4-wire". Voir la section
#   "paramètres SPI communs" pour une description des paramètres
#   commençant par "spi_". Le défaut est d'utiliser le mode i2c pour l'écran
#   d'affichage.
#reset_pin:
#   Une broche de réinitialisation peut être spécifiée sur l'affichage. Si elle
#   n'est pas spécifiée, le matériel doit avoir un pull-up sur la ligne
#   lcd correspondante.
#contrast:
#   Le contraste à définir. La valeur peut aller de 0 à 256 , la valeur par
#   défaut est 239.
#vcomh: 0
#   Définit la valeur Vcomh sur l'écran. Cette valeur est associée à un effet
#   de "bavure" sur certains écrans OLED. La valeur peut être comprise
#   de 0 à 63. La valeur par défaut est 0.
#invert: False
#   TRUE inverse les pixels sur certains écrans OLED.  La valeur par défaut est
#   False.
#x_offset: 0
#   Définit la valeur du décalage horizontal sur les écrans SH1106. La valeur par
#   défaut est 0.
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

Cette fonctionnalité permet de réduire les définitions répétitives dans les sections display_data. On peut utiliser la fonction intégrée `render()` dans les sections display_data pour évaluer un modèle. Par exemple, si l'on définit "[display_template my_template]`", on peut utiliser "{ render('my_template') }` dans une section display_data.

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

Capteur de largeur de filament basé sur le TSLl401CL. Voir le [guide](TSL1401CL_Filament_Width_Sensor.md) pour plus d'informations.

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

## Support matériel spécifique à une carte

### [sx1509]

Configuration d'un expandeur SX1509 I2C vers GPIO. En raison du délai encouru par la communication I2C, vous ne devez PAS utiliser les broches du SX1509 comme activation du moteur pas à pas, pas ou direction ou toute autre broche nécessitant un changement de bit rapide. Il est préférable de les utiliser comme sorties numériques statiques ou contrôlées par gcode ou comme broches hardware-pwm pour des ventilateurs par exemple. On peut définir un nombre quelconque de sections avec un préfixe "sx1509". Chaque expandeur fournit un ensemble de 16 broches (sx1509_my_sx1509:PIN_0 à sx1509_my_sx1509:PIN_15) pouvant être utilisées dans la configuration de l'imprimante.

Voir le fichier [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg) pour un exemple.

```
[sx1509 my_sx1509]
i2c_address:
#    Adresse I2C utilisée par cet expandeur. Selon le matériel
#    il s'agit de l'une des adresses suivantes : 62 63 112
#    113. Ce paramètre doit être fourni.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#    Voir la section "paramètres I2C communs" pour une description des
#    paramètres ci-dessus.
#i2c_bus:
#    Si l'implémentation I2C de votre micro-contrôleur prend en charge plusieurs bus I2C,
#     vous pouvez spécifier le nom du bus ici. La valeur par
#    défaut est d'utiliser le bus i2c par défaut du micro-contrôleur.
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
#    La section de configuration "replicape" ajoute "replicape:stepper_x_enable".
#    des broches virtuelles d'activation de moteur pas à pas (pour les moteurs X, Y, Z, E et H) et
#    "replicape:power_x" des broches de sortie PWM (pour les pilotes, e, h, fan0, fan1,
#    fan2, et fan3) utilisables ailleurs dans le fichier de configuration.
[replicape]
revision:
#    La révision du matériel replicape. Actuellement, seule la révision "B3" est
#    supportée. Ce paramètre doit être fourni.
#enable_pin: !gpio0_20
#    La broche d'activation globale de la replicape. La valeur par défaut est !gpio0_20 (aka
#    P9_41).
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
#    Ce paramètre contrôle les broches CFG1 et CFG2 du # pilote de moteur pas à pas donné.
#    Les options disponibles sont : disable, 1, 2, spread2, 4, 16, spread4, spread16, stealth4,
#    et stealth16. La valeur par défaut est disable.
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
#    Le port série à connecter à la Palette 2.
#baud: 115200
#    Le débit en bauds à utiliser. La valeur par défaut est 115200.
#feedrate_splice: 0.8
#    Le taux d'avance à utiliser lors de l'épissage, la valeur par défaut est 0.8.
#feedrate_normal: 1.0
#    L'avance à utiliser après l'épissage, la valeur par défaut est 1.0.
#auto_load_speed: 2
#    Vitesse d'extrusion lors du chargement automatique, par défaut 2 (mm/s).
#auto_cancel_variation: 0.1
#    Annulation automatique de l'impression lorsque la variation du ping est supérieure à ce seuil.
```

### [angle]

Prise en charge du capteur d'angle Hall magnétique pour la lecture des mesures de l'angle de l'arbre du moteur pas à pas à l'aide des puces SPI a1333, as5047d ou tle5012b. Les mesures sont disponibles via le [serveur API](API_Server.md) et l'[outil d'analyse de mouvement](Debugging.md#motion-analysis-and-data-logging). Voir la [référence G-Code](G-Codes.md#angle) pour les commandes disponibles.

```
[angle my_angle_sensor]
sensor_type:
#   Le type de la puce du capteur magnétique à effet Hall. Les choix disponibles
#   sont "a1333", "as5047d" et "tle5012b". Ce paramètre doit être spécifié.
#sample_period: 0.000400
#   La période de requête (en secondes) à utiliser lors des mesures. La valeur par
#   défaut est de 0.000400 (ce qui correspond à 2500 échantillons par seconde).
#stepper:
#   Le nom du pilote moteur pas à pas auquel le capteur d'angle est attaché (ex,
#   "stepper_x"). La définition de cette valeur active un étalonnage d'angle.
#   Pour utiliser cette fonction, le paquet Python "numpy" doit être installé.
#   Par défaut, l'étalonnage d'angle n'est pas activé pour un capteur d'angle.
cs_pin:
#  La broche d'activation SPI du capteur. Ce paramètre doit être fourni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Voir la section "paramètres SPI communs" pour une description des
#   paramètres ci-dessus.
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

Notez que le support actuel des micro-contrôleurs de Klipper pour i2c n'est généralement pas tolérant au bruit sur la ligne. Des erreurs inattendues sur les fils i2c peuvent entraîner une erreur d'exécution de Klipper. Le support de Klipper de récupération des erreurs varie selon le type de micro-contrôleur. Il est généralement recommandé de n'utiliser que des dispositifs i2c se trouvant sur la même carte de circuit imprimé que le microcontrôleur.

La plupart des implémentations de micro-contrôleurs Klipper ne supportent qu'une `i2c_speed` de 100000. Le micro-contrôleur Klipper "linux" supporte une vitesse de 400000, mais elle doit être [définie dans le système d'exploitation](RPi_microcontroller.md#optional-enabling-i2c) sinon le paramètre `i2c_speed` est ignoré. Le micro-contrôleur Klipper "rp2040" supporte un taux de 400000 via le paramètre `i2c_speed`. Tous les autres micro-contrôleurs Klipper utilisent un taux de 100000 et ignorent le paramètre `i2c_speed`.

```
#i2c_address:
#    L'adresse i2c du périphérique. Elle doit être spécifiée sous la forme d'un nombre décimal
#    (pas en hexadécimal). La valeur par défaut dépend du type de périphérique.
#i2c_mcu:
#    Le nom du micro-contrôleur auquel la puce est connectée.
#    La valeur par défaut est "mcu".
#i2c_bus:
#    Si le micro-contrôleur supporte plusieurs bus I2C, on peut spécifier le bus du micro-contrôleur.
#    La valeur par défaut dépend du type de micro-contrôleur.
#i2c_speed:
#    La vitesse I2C (en Hz) à utiliser lors de la communication avec le périphérique.
#    L'implémentation de Klipper pour la plupart des micro-contrôleurs est codée en dur à 100000,
#    modifier cette valeur n'a aucun effet. La valeur par défaut est 100000.
```
