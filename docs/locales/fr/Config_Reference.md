# Référence de configuration

Ce document est la référencedes options disponibles dans le fichier de configuration de Klipper.

Les descriptions de ce document sont formatées de manière à ce qu'il soit possible de les copier-coller dans un fichier de configuration d'imprimante. Consultez le [document d'installation](Installation.md) pour obtenir des informations sur la configuration de Klipper et le choix d'un fichier de configuration initial.

## Configuration du microcontrôleur

### Format du nom des broches du microcontrôleur

De nombreuses options de configuration nécessitent le nom d'une broche du micro-contrôleur. Klipper utilise les noms matériel pour ces broches - par exemple `PA4`.

Les noms des broches peuvent être précédés de `!` pour indiquer qu'une polarité inverse doit être utilisée (par exemple, déclencher sur le bas au lieu du haut).

Les broches d'entrée peuvent être précédées de `^` pour indiquer qu'une résistance pull-up matérielle doit être activée pour cette broche. Si le micro-contrôleur supporte les résistances pull-down, une broche d'entrée peut également être précédée de `~`.

Notez que certaines sections de configuration peuvent "créer" des broches supplémentaires. Lorsque cela se produit, la section de configuration définissant les broches doit être répertoriée dans le fichier de configuration avant toute section utilisant ces broches.

### [mcu|

Configuration du microcontrôleur primaire.

```
[mcu]
serial:
#   The serial port to connect to the MCU. If unsure (or if it
#   changes) see the "Where's my serial port?" section of the FAQ.
#   This parameter must be provided when using a serial port.
#baud: 250000
#   The baud rate to use. The default is 250000.
#canbus_uuid:
#   If using a device connected to a CAN bus then this sets the unique
#   chip identifier to connect to. This value must be provided when using
#   CAN bus for communication.
#canbus_interface:
#   If using a device connected to a CAN bus then this sets the CAN
#   network interface to use. The default is 'can0'.
#restart_method:
#   This controls the mechanism the host will use to reset the
#   micro-controller. The choices are 'arduino', 'cheetah', 'rpi_usb',
#   and 'command'. The 'arduino' method (toggle DTR) is common on
#   Arduino boards and clones. The 'cheetah' method is a special
#   method needed for some Fysetc Cheetah boards. The 'rpi_usb' method
#   is useful on Raspberry Pi boards with micro-controllers powered
#   over USB - it briefly disables power to all USB ports to
#   accomplish a micro-controller reset. The 'command' method involves
#   sending a Klipper command to the micro-controller so that it can
#   reset itself. The default is 'arduino' if the micro-controller
#   communicates over a serial port, 'command' otherwise.
```

### [mcu my_extra_mcu]

Microcontrôleurs supplémentaires (on peut définir un nombre quelconque de sections avec un préfixe "mcu"). Les microcontrôleurs supplémentaires introduisent des broches additionnelles pouvant être configurées comme des éléments chuaffant, des pilotes moteurs, des ventilateurs, etc. Par exemple, si une section "[mcu extra_mcu]" est ajoutée, des broches telles que "extra_mcu:ar9" pourront alors être utilisées ailleurs dans la configuration (où "ar9" est un nom de broche matérielle ou un nom d'alias sur le mcu donné).

```
[mcu my_extra_mcu]
# See the "mcu" section for configuration parameters.
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
#   print). This parameter must be specified.
#max_accel_to_decel:
#   A pseudo acceleration (in mm/s^2) controlling how fast the
#   toolhead may go from acceleration to deceleration. It is used to
#   reduce the top speed of short zig-zag moves (and thus reduce
#   printer vibration from these moves). The default is half of
#   max_accel.
#square_corner_velocity: 5.0
#   The maximum velocity (in mm/s) that the toolhead may travel a 90
#   degree corner at. A non-zero value can reduce changes in extruder
#   flow rates by enabling instantaneous velocity changes of the
#   toolhead during cornering. This value configures the internal
#   centripetal velocity cornering algorithm; corners with angles
#   larger than 90 degrees will have a higher cornering velocity while
#   corners with angles less than 90 degrees will have a lower
#   cornering velocity. If this is set to zero then the toolhead will
#   decelerate to zero at each corner. The default is 5mm/s.
```

### [stepper]

Définitions des pilotes de moteurs pas à pas. Différents types d'imprimantes (comme spécifié par l'option "kinematics" dans la section [printer]) requièrent différents noms pour le moteur pas à pas (par exemple, `stepper_x` vs `stepper_a`). Ci-dessous, vous trouverez les définitions les plus courantes.

See the [rotation distance document](Rotation_Distance.md) for information on calculating the `rotation_distance` parameter. See the [Multi-MCU homing](Multi_MCU_Homing.md) document for information on homing using multiple micro-controllers.

```
[stepper_x]
step_pin:
#   Step GPIO pin (triggered high). This parameter must be provided.
dir_pin:
#   Direction GPIO pin (high indicates positive direction). This
#   parameter must be provided.
enable_pin:
#   Enable pin (default is enable high; use ! to indicate enable
#   low). If this parameter is not provided then the stepper motor
#   driver must always be enabled.
rotation_distance:
#   Distance (in mm) that the axis travels with one full rotation of
#   the stepper motor (or final gear if gear_ratio is specified).
#   This parameter must be provided.
microsteps:
#   The number of microsteps the stepper motor driver uses. This
#   parameter must be provided.
#full_steps_per_rotation: 200
#   The number of full steps for one rotation of the stepper motor.
#   Set this to 200 for a 1.8 degree stepper motor or set to 400 for a
#   0.9 degree motor. The default is 200.
#gear_ratio:
#   The gear ratio if the stepper motor is connected to the axis via a
#   gearbox. For example, one may specify "5:1" if a 5 to 1 gearbox is
#   in use. If the axis has multiple gearboxes one may specify a comma
#   separated list of gear ratios (for example, "57:11, 2:1"). If a
#   gear_ratio is specified then rotation_distance specifies the
#   distance the axis travels for one full rotation of the final gear.
#   The default is to not use a gear ratio.
#step_pulse_duration:
#   The minimum time between the step pulse signal edge and the
#   following "unstep" signal edge. This is also used to set the
#   minimum time between a step pulse and a direction change signal.
#   The default is 0.000000100 (100ns) for TMC steppers that are
#   configured in UART or SPI mode, and the default is 0.000002 (which
#   is 2us) for all other steppers.
endstop_pin:
#   Endstop switch detection pin. If this endstop pin is on a
#   different mcu than the stepper motor then it enables "multi-mcu
#   homing". This parameter must be provided for the X, Y, and Z
#   steppers on cartesian style printers.
#position_min: 0
#   Minimum valid distance (in mm) the user may command the stepper to
#   move to.  The default is 0mm.
position_endstop:
#   Location of the endstop (in mm). This parameter must be provided
#   for the X, Y, and Z steppers on cartesian style printers.
position_max:
#   Maximum valid distance (in mm) the user may command the stepper to
#   move to. This parameter must be provided for the X, Y, and Z
#   steppers on cartesian style printers.
#homing_speed: 5.0
#   Maximum velocity (in mm/s) of the stepper when homing. The default
#   is 5mm/s.
#homing_retract_dist: 5.0
#   Distance to backoff (in mm) before homing a second time during
#   homing. Set this to zero to disable the second home. The default
#   is 5mm.
#homing_retract_speed:
#   Speed to use on the retract move after homing in case this should
#   be different from the homing speed, which is the default for this
#   parameter
#second_homing_speed:
#   Velocity (in mm/s) of the stepper when performing the second home.
#   The default is homing_speed/2.
#homing_positive_dir:
#   If true, homing will cause the stepper to move in a positive
#   direction (away from zero); if false, home towards zero. It is
#   better to use the default than to specify this parameter. The
#   default is true if position_endstop is near position_max and false
#   if near position_min.
```

### Cinématique cartésienne

Voir [example-cartesian.cfg](../config/example-cartesian.cfg) pour un exemple de fichier de configuration de cinématique cartésienne.

Seuls les paramètres spécifiques aux imprimantes cartésiennes sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: cartesian
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. This setting can be used to restrict the maximum speed of
#   the z stepper motor. The default is to use max_velocity for
#   max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. It limits the acceleration of the z stepper motor. The
#   default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the stepper controlling
# the X axis in a cartesian robot.
[stepper_x]

# The stepper_y section is used to describe the stepper controlling
# the Y axis in a cartesian robot.
[stepper_y]

# The stepper_z section is used to describe the stepper controlling
# the Z axis in a cartesian robot.
[stepper_z]
```

### Cinématique Delta linéaire

Voir [example-delta.cfg](../config/example-delta.cfg) pour un exemple de fichier de configuration de cinématique delta linéaire. Voir le [guide de calibrage delta](Delta_Calibrate.md) pour des informations sur le calibrage.

Seuls les paramètres spécifiques aux imprimantes delta linéaires sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: delta
max_z_velocity:
#   For delta printers this limits the maximum velocity (in mm/s) of
#   moves with z axis movement. This setting can be used to reduce the
#   maximum speed of up/down moves (which require a higher step rate
#   than other moves on a delta printer). The default is to use
#   max_velocity for max_z_velocity.
#max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. Setting this may be useful if the printer can reach higher
#   acceleration on XY moves than Z moves (eg, when using input shaper).
#   The default is to use max_accel for max_z_accel.
#minimum_z_position: 0
#   The minimum Z position that the user may command the head to move
#   to. The default is 0.
delta_radius:
#   Radius (in mm) of the horizontal circle formed by the three linear
#   axis towers. This parameter may also be calculated as:
#    delta_radius = smooth_rod_offset - effector_offset - carriage_offset
#   This parameter must be provided.
#print_radius:
#   The radius (in mm) of valid toolhead XY coordinates. One may use
#   this setting to customize the range checking of toolhead moves. If
#   a large value is specified here then it may be possible to command
#   the toolhead into a collision with a tower. The default is to use
#   delta_radius for print_radius (which would normally prevent a
#   tower collision).

# The stepper_a section describes the stepper controlling the front
# left tower (at 210 degrees). This section also controls the homing
# parameters (homing_speed, homing_retract_dist) for all towers.
[stepper_a]
position_endstop:
#   Distance (in mm) between the nozzle and the bed when the nozzle is
#   in the center of the build area and the endstop triggers. This
#   parameter must be provided for stepper_a; for stepper_b and
#   stepper_c this parameter defaults to the value specified for
#   stepper_a.
arm_length:
#   Length (in mm) of the diagonal rod that connects this tower to the
#   print head. This parameter must be provided for stepper_a; for
#   stepper_b and stepper_c this parameter defaults to the value
#   specified for stepper_a.
#angle:
#   This option specifies the angle (in degrees) that the tower is
#   at. The default is 210 for stepper_a, 330 for stepper_b, and 90
#   for stepper_c.

# The stepper_b section describes the stepper controlling the front
# right tower (at 330 degrees).
[stepper_b]

# The stepper_c section describes the stepper controlling the rear
# tower (at 90 degrees).
[stepper_c]

# The delta_calibrate section enables a DELTA_CALIBRATE extended
# g-code command that can calibrate the tower endstop positions and
# angles.
[delta_calibrate]
radius:
#   Radius (in mm) of the area that may be probed. This is the radius
#   of nozzle coordinates to be probed; if using an automatic probe
#   with an XY offset then choose a radius small enough so that the
#   probe always fits over the bed. This parameter must be provided.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### Cinématique deltesienne

See [example-deltesian.cfg](../config/example-deltesian.cfg) for an example deltesian kinematics config file.

Only parameters specific to deltesian printers are described here - see [common kinematic settings](#common-kinematic-settings) for available parameters.

```
[printer]
kinematics: deltesian
max_z_velocity:
#   For deltesian printers, this limits the maximum velocity (in mm/s) of
#   moves with z axis movement. This setting can be used to reduce the
#   maximum speed of up/down moves (which require a higher step rate
#   than other moves on a deltesian printer). The default is to use
#   max_velocity for max_z_velocity.
#max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. Setting this may be useful if the printer can reach higher
#   acceleration on XY moves than Z moves (eg, when using input shaper).
#   The default is to use max_accel for max_z_accel.
#minimum_z_position: 0
#   The minimum Z position that the user may command the head to move
#   to. The default is 0.
#min_angle: 5
#   This represents the minimum angle (in degrees) relative to horizontal
#   that the deltesian arms are allowed to achieve. This parameter is
#   intended to restrict the arms from becomming completely horizontal,
#   which would risk accidental inversion of the XZ axis. The default is 5.
#print_width:
#   The distance (in mm) of valid toolhead X coordinates. One may use
#   this setting to customize the range checking of toolhead moves. If
#   a large value is specified here then it may be possible to command
#   the toolhead into a collision with a tower. This setting usually
#   corresponds to bed width (in mm).
#slow_ratio: 3
#   The ratio used to limit velocity and acceleration on moves near the
#   extremes of the X axis. If vertical distance divided by horizontal
#   distance exceeds the value of slow_ratio, then velocity and
#   acceleration are limited to half their nominal values. If vertical
#   distance divided by horizontal distance exceeds twice the value of
#   the slow_ratio, then velocity and acceleration are limited to one
#   quarter of their nominal values. The default is 3.

# The stepper_left section is used to describe the stepper controlling
# the left tower. This section also controls the homing parameters
# (homing_speed, homing_retract_dist) for all towers.
[stepper_left]
position_endstop:
#   Distance (in mm) between the nozzle and the bed when the nozzle is
#   in the center of the build area and the endstops are triggered. This
#   parameter must be provided for stepper_left; for stepper_right this
#   parameter defaults to the value specified for stepper_left.
arm_length:
#   Length (in mm) of the diagonal rod that connects the tower carriage to
#   the print head. This parameter must be provided for stepper_left; for
#   stepper_right, this parameter defaults to the value specified for
#   stepper_left.
arm_x_length:
#   Horizontal distance between the print head and the tower when the
#   printers is homed. This parameter must be provided for stepper_left;
#   for stepper_right, this parameter defaults to the value specified for
#   stepper_left.

# The stepper_right section is used to desribe the stepper controlling the
# right tower.
[stepper_right]

# The stepper_y section is used to describe the stepper controlling
# the Y axis in a deltesian robot.
[stepper_y]
```

### Cinématique CoreXY

Voir [example-corexy.cfg](../config/example-corexy.cfg) pour un exemple de fichier cinématique corexy (et h-bot).

Seuls les paramètres spécifiques aux imprimantes corexy sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: corexy
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. This setting can be used to restrict the maximum speed of
#   the z stepper motor. The default is to use max_velocity for
#   max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. It limits the acceleration of the z stepper motor. The
#   default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the X axis as well as the
# stepper controlling the X+Y movement.
[stepper_x]

# The stepper_y section is used to describe the Y axis as well as the
# stepper controlling the X-Y movement.
[stepper_y]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
[stepper_z]
```

### Cinématique CoreXZ

Voir [example-corexz.cfg](../config/example-corexz.cfg) pour un exemple de fichier de configuration de cinématique corexz.

Seuls les paramètres spécifiques aux imprimantes corexz sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

```
[printer]
kinematics: corexz
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. The default is to use max_velocity for max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. The default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the X axis as well as the
# stepper controlling the X+Z movement.
[stepper_x]

# The stepper_y section is used to describe the stepper controlling
# the Y axis.
[stepper_y]

# The stepper_z section is used to describe the Z axis as well as the
# stepper controlling the X-Z movement.
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
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. The default is to use max_velocity for max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. The default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the X axis as well as the
# stepper controlling the X-Y movement.
[stepper_x]

# The stepper_y section is used to describe the stepper controlling
# the Y axis.
[stepper_y]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
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
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. The default is to use max_velocity for max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. The default is to use max_accel for max_z_accel.

# The stepper_x section is used to describe the X axis as well as the
# stepper controlling the X-Z movement.
[stepper_x]

# The stepper_y section is used to describe the stepper controlling
# the Y axis.
[stepper_y]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
[stepper_z]
```

### Cinématique polaire

Voir [example-polar.cfg](../config/example-polar.cfg) pour un exemple de fichier de configuration de cinématique polaire.

Seuls les paramètres spécifiques aux imprimantes polaires sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

POLAR KINEMATICS ARE A WORK IN PROGRESS. Moves around the 0, 0 position are known to not work properly.

```
[printer]
kinematics: polar
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. This setting can be used to restrict the maximum speed of
#   the z stepper motor. The default is to use max_velocity for
#   max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. It limits the acceleration of the z stepper motor. The
#   default is to use max_accel for max_z_accel.

# The stepper_bed section is used to describe the stepper controlling
# the bed.
[stepper_bed]
gear_ratio:
#   A gear_ratio must be specified and rotation_distance may not be
#   specified. For example, if the bed has an 80 toothed pulley driven
#   by a stepper with a 16 toothed pulley then one would specify a
#   gear ratio of "80:16". This parameter must be provided.

# The stepper_arm section is used to describe the stepper controlling
# the carriage on the arm.
[stepper_arm]

# The stepper_z section is used to describe the stepper controlling
# the Z axis.
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
#   For delta printers this limits the maximum velocity (in mm/s) of
#   moves with z axis movement. This setting can be used to reduce the
#   maximum speed of up/down moves (which require a higher step rate
#   than other moves on a delta printer). The default is to use
#   max_velocity for max_z_velocity.
#minimum_z_position: 0
#   The minimum Z position that the user may command the head to move
#   to.  The default is 0.
shoulder_radius:
#   Radius (in mm) of the horizontal circle formed by the three
#   shoulder joints, minus the radius of the circle formed by the
#   effector joints. This parameter may also be calculated as:
#     shoulder_radius = (delta_f - delta_e) / sqrt(12)
#   This parameter must be provided.
shoulder_height:
#   Distance (in mm) of the shoulder joints from the bed, minus the
#   effector toolhead height. This parameter must be provided.

# The stepper_a section describes the stepper controlling the rear
# right arm (at 30 degrees). This section also controls the homing
# parameters (homing_speed, homing_retract_dist) for all arms.
[stepper_a]
gear_ratio:
#   A gear_ratio must be specified and rotation_distance may not be
#   specified. For example, if the arm has an 80 toothed pulley driven
#   by a pulley with 16 teeth, which is in turn connected to a 60
#   toothed pulley driven by a stepper with a 16 toothed pulley, then
#   one would specify a gear ratio of "80:16, 60:16". This parameter
#   must be provided.
position_endstop:
#   Distance (in mm) between the nozzle and the bed when the nozzle is
#   in the center of the build area and the endstop triggers. This
#   parameter must be provided for stepper_a; for stepper_b and
#   stepper_c this parameter defaults to the value specified for
#   stepper_a.
upper_arm_length:
#   Length (in mm) of the arm connecting the "shoulder joint" to the
#   "elbow joint". This parameter must be provided for stepper_a; for
#   stepper_b and stepper_c this parameter defaults to the value
#   specified for stepper_a.
lower_arm_length:
#   Length (in mm) of the arm connecting the "elbow joint" to the
#   "effector joint". This parameter must be provided for stepper_a;
#   for stepper_b and stepper_c this parameter defaults to the value
#   specified for stepper_a.
#angle:
#   This option specifies the angle (in degrees) that the arm is at.
#   The default is 30 for stepper_a, 150 for stepper_b, and 270 for
#   stepper_c.

# The stepper_b section describes the stepper controlling the rear
# left arm (at 150 degrees).
[stepper_b]

# The stepper_c section describes the stepper controlling the front
# arm (at 270 degrees).
[stepper_c]

# The delta_calibrate section enables a DELTA_CALIBRATE extended
# g-code command that can calibrate the shoulder endstop positions.
[delta_calibrate]
radius:
#   Radius (in mm) of the area that may be probed. This is the radius
#   of nozzle coordinates to be probed; if using an automatic probe
#   with an XY offset then choose a radius small enough so that the
#   probe always fits over the bed. This parameter must be provided.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### Cinématique du treuil à câble

Voir le fichier [example-winch.cfg](../config/example-winch.cfg) pour un exemple de fichier de configuration cinématique d'un treuil à câble.

Seuls les paramètres spécifiques aux imprimantes à treuil sont décrits ici - voir [paramètres cinématiques communs](#common-kinematic-settings) pour les paramètres disponibles.

LE SUPPORT DU TREUIL À CÂBLE EST EXPÉRIMENTAL. L'orientation n'est pas implémentée dans la cinématique du treuil à câble. Pour ramener l'imprimante à l'origine, envoyez manuellement des commandes de mouvement jusqu'à ce que la tête de l'outil soit à 0, 0, 0, puis envoyez une commande `G28`.

```
[printer]
kinematics: winch

# The stepper_a section describes the stepper connected to the first
# cable winch. A minimum of 3 and a maximum of 26 cable winches may be
# defined (stepper_a to stepper_z) though it is common to define 4.
[stepper_a]
rotation_distance:
#   The rotation_distance is the nominal distance (in mm) the toolhead
#   moves towards the cable winch for each full rotation of the
#   stepper motor. This parameter must be provided.
anchor_x:
anchor_y:
anchor_z:
#   The X, Y, and Z position of the cable winch in cartesian space.
#   These parameters must be provided.
```

### Aucune cinématique

Il est possible de définir une cinématique spéciale "aucune (none)" pour désactiver le support cinématique dans Klipper. Cela peut être utile pour contrôler des périphériques qui ne sont pas des imprimantes 3D typiques ou à des fins de débogage.

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   The max_velocity and max_accel parameters must be defined. The
#   values are not used for "none" kinematics.
```

## Support d'extrudeur commun et support de lit chauffant

### [extruder]

The extruder section is used to describe the heater parameters for the nozzle hotend along with the stepper controlling the extruder. See the [command reference](G-Codes.md#extruder) for additional information. See the [pressure advance guide](Pressure_Advance.md) for information on tuning pressure advance.

```
[extruder]
step_pin:
dir_pin:
enable_pin:
microsteps:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#    Voir la section "stepper" pour une description des paramètres ci-dessus.
#    Si aucun des paramètres ci-dessus n'est spécifié, alors aucun pilote ne
#    sera associé à la buse (bien qu'une commande SYNC_EXTRUDER_MOTION
#    puisse en associer un au moment de l'exécution).
nozzle_diameter:
#    Diamètre de l'orifice de la buse (en mm). Ce paramètre doit être
#    fourni.
filament_diameter:
#    Diamètre moyen du filament (en mm) lorsqu'il entre dans l'extrudeuse.
#    Ce paramètre doit être fourni.
#max_extrude_cross_section:
#    Surface maximale (en mm^2) d'une section transversale d'extrusion (ex:
#    largeur de l'extrusion multipliée par la hauteur de la couche). Ce paramètre permet d'éviter
#    des quantités excessives d'extrusion pendant des déplacements XY relativement petits.
#    Si un déplacement demande une quantité d'extrusion supérieure à cette valeur,
#    une erreur sera renvoyée. La valeur par défaut est 4.0 *diamètre_buse^2
#instantaneous_corner_velocity: 1.000
#    La variation instantanée maximale de la vitesse (en mm/s) de l'extrudeuse
#     pendant la jonction de deux mouvements. La valeur par défaut est 1mm/s.
#max_extrude_only_distance: 50.0
#    Longueur maximale (en mm de filament) qu'un mouvement de rétraction ou d'extrusion
#    peut fournir. Si un mouvement de rétraction ou d'extrusion uniquement
#    demande une distance supérieure à cette valeur, une erreur sera renvoyée.
#    La valeur par défaut est 50mm.
#max_extrude_only_velocity:
#max_extrude_only_accel:
#    Vitesse maximale (en mm/s) et accélération (en mm/s^2) du moteur de l'extrudeuse
#    pour les rétractions et les mouvements d'extrusion seulement. Ces paramètres n'ont
#    aucun impact sur les mouvements d'impression normaux. S'ils ne sont pas
#    spécifiés, ils sont calculés pour correspondre à la limite d'un mouvement qu'une impression
#    avec une section transversale de 4.0*diamètre_buse^2 aurait.
#pressure_advance: 0.0
#    La quantité de filament à pousser dans l'extrudeuse durant l'accélération de celle-ci.
#    Une quantité égale de filament est rétractée pendant la décélération. Elle est mesurée
#    en millimètre/seconde. La valeur par défaut est 0, ce qui désactive cette fonctionnalité
#    (l'avnace de pression).
#pressure_advance_smooth_time: 0.040
#     Une durée (en secondes) à utiliser lors du calcul de la vitesse moyenne de l'extrudeuse.
#    pour l'avance de la pression. Une valeur plus grande donne lieu à des mouvements
#    d'extrusion plus lisses. Ce paramètre ne doit pas dépasser 200ms.
#    Ce paramètre ne s'applique que si pressure_advance est différent de zéro. La valeur
#    par défaut est 0.040 (40 millisecondes).
#
# Les variables restantes décrivent la chauffe de l'extrudeuse.
heater_pin:
#    Broche de sortie PWM contrôlant le chauffage. Ce paramètre doit être
#    fourni.
#max_power: 1.0
#    La puissance maximale (exprimée sous la forme d'une valeur comprise entre 0,0 et 1,0) à laquelle
#    régler le heater_pin . La valeur 1.0 permet à la broche d'être réglée comme toujours
#    activée durant des périodes prolongées, tandis qu'une valeur de 0,5
#    permet à la broche d'être activée durant au plus la moitié du temps. 
#    Ce réglage peut être utilisé pour limiter la puissance totale de sortie (sur de longues périodes) de
#    l'élément de chauffe. La valeur par défaut est 1.0.
sensor_type:
#    Type de capteur - les thermistances courantes sont "EPCOS 100K B57560G104F",
#    "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Générique
#    3950", "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#    "SliceEngineering 450", et "TDK NTCG104LH104JT1". Voir la section
#    "Capteurs de température" pour d'autres capteurs. Ce paramètre
#    doit être fourni.
sensor_pin:
#    Broche d'entrée analogique connectée au capteur. Ce paramètre doit être
#    fourni.
#pullup_resistor: 4700
#    La résistance (en ohms) du pullup relié à la thermistance.
#    Ce paramètre n'est valable que si le capteur est une thermistance. La valeur par
#    défaut est 4700 ohms.
#smooth_time: 1.0
#    Une durée (en secondes) sur laquelle les mesures de température seront
#    lissées pour réduire l'impact du bruit de la mesure. La valeur par défaut
#    est de 1 seconde.
control:
#    Algorithme de contrôle (soit pid, soit filigrane (watermark)). Ce paramètre doit
#    être fourni.
pid_Kp:
pid_Ki:
pid_Kd:
#    Les paramètres proportionnels (pid_Kp), intégraux (pid_Ki) et dérivés (pid_Kd) du système
#    de contrôle de rétroaction PID. Klipper évalue les paramètres PID avec la formule générale suivante :
#    heater_pwm = (Kp*erreur + Ki*intégrale(erreur) - Kd*dérivée(erreur)) / 255
#    Où "erreur" estle résultat de "requested_temperature - measured_temperature"
#    et "heater_pwm" est le taux de chauffage demandé,
#    0.0 étant complètement éteint et 1.0 étant complètement allumé. Pensez à utiliser la commande PID_CALIBRATE
#    pour obtenir ces paramètres. Les paramètres pid_Kp, pid_Ki, et pid_Kd
#    doivent être fournis pour les éléments de chauffe PID.
#max_delta: 2.0
#    Sur les éléments de chauffe contrôlés par un filigrane (watermark), il s'agit du nombre de degrés en
#    Celsius au-dessus de la température cible avant de désactiver le chauffage
#    ainsi que le nombre de degrés en dessous de la température cible avant la
#    réactivation du chauffage. La valeur par défaut est de 2 degrés Celsius.
#pwm_cycle_time: 0.100
#    Temps en secondes de chaque cycle PWM logiciel du chauffage. Il n'est
#    pas recommandé de définir cette valeur, sauf s'il existe une exigence
#    électrique pour commuter le chauffage plus rapidement que 10 fois par seconde.
#    La valeur par défaut est 0,100 seconde.
#min_extrude_temp: 170
#    La température minimale (en Celsius) au-dessus de laquelle les commandes de déplacement de
#    l'extrudeuse peuvent être émises. La valeur par défaut est 170 Celsius.
min_temp:
max_temp:
#    La plage maximale de températures valides (en Celsius) dans laquelle l'élément de chauffe doit rester.
#    Ceci contrôle une fonction de sécurité implémentée dans le code du micro-contrôleur - si la température
#    mesurée sort de cette plage, le microcontrôleur se met en état d'arrêt.
#    Ce contrôle peut aider à détecter certaines défaillances matérielles de l'élément chauffant et/ou du capteur.
#    Définissez cette plage suffisamment large pour que des températures raisonnables n'entraînent  pas d'erreur.
#    Ces paramètres doivent être fournis.
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

Nivelage du maillage du lit. On peut définir une section de configuration bed_mesh pour activer les transformations de déplacement qui décalent l'axe z en fonction d'un maillage généré à partir de points sondés. Lorsqu'on utilise une sonde pour définir l'origine de l'axe z, il est recommandé de définir une section safe_z_home dans printer.cfg pour réaliser cette mise à l'origine au centre de la zone d'impression.

See the [bed mesh guide](Bed_Mesh.md) and [command reference](G-Codes.md#bed_mesh) for additional information.

Exemples visuels :

```
 rectangular bed, probe_count = 3, 3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 round bed, round_probe_count = 5, bed_radius = r:
                 x (0, r) end
               /
             x---x---x
                       \
 (-r, 0) x---x---x---x---x (r, 0)
           \
             x---x---x
                   /
                 x  (0, -r) start
```

```
[bed_mesh]
#speed: 50
#     La vitesse (en mm/s) des mouvements entre les points de palpage
#     pendant l'étalonnage.
#     La valeur par défaut est 50.
#horizontal_move_z: 5
#     La hauteur (en mm) à laquelle la tête doit être relevée  juste avant de
#     lancer une opération de palpage. La valeur par défaut est 5.
#mesh_radius:
#     Définit le rayon de la maille à sonder pour les lits circulaires. Notez que
#     le rayon est relatif à la coordonnée spécifiée par l'option
#    mesh_origin. Ce paramètre doit être fourni pour les lits circulaires
#     et omis pour les lits rectangulaires.
#mesh_origin:
#     Définit les coordonnées X, Y du centre du maillage pour les lits circulaires. Cette
#     coordonnée est relative à l'emplacement de la sonde. Il peut être utile
#     d'ajuster l'origine du maillage afin de maximiser la taille du rayon du maillage.
#     La valeur par défaut est 0, 0. Ce paramètre doit être omis pour les lits rectangulaires.
#mesh_min:
#     Définit les coordonnées X, Y minimales du maillage pour les lits rectangulaires.
#     Ces coordonnées sont relatives à l'emplacement de la sonde. Cette position
#     sera le premier point sondé, le plus proche de l'origine. Ce paramètre
#    doit être fourni pour les lits rectangulaires.
#mesh_max:
#      Définit les coordonnées X, Y maximales du maillage pour les lits rectangulaires.
#      Le principe est le même que pour mesh_min, mais ce sera le point le plus éloigné
#      atteignable par rapport à l'origine du lit. Ce paramètre  doit être fourni pour 
#     les lits rectangulaires.
#probe_count: 3, 3
#     Pour les lits rectangulaires, il s'agit d'une paire d'entiers X, Y séparés par des virgules,
#     définissant le nombre de points à sonder le long de chaque axe.
#     Une seule valeur est également valide, auquel cas cette valeur sera appliquée aux
#     deux axes. La valeur par défaut est 3, 3.
#round_probe_count: 5
#      Pour les lits circulaires, cette valeur entière définit le nombre maximum de 
#      points à sonder le long de chaque axe. Cette valeur doit être un nombre impair.
#      La valeur par défaut est 5.
#fade_start: 1.0
#      La position z du gcode à partir de laquelle il faut commencer à supprimer
#      progressivement l'ajustement z lorsque le fondu est activé. La valeur par défaut est 1.0.
#fade_end: 0.0
#       La position z du gcode à partir de laquelle la compensation se termine. Lorsqu'elle est
#      définie à une valeur inférieure à fade_start, le fondu est désactivé. Il est à noter que
#      le fondu peut ajouter une mise à l'échelle indésirable le long de l'axe z d'une impression.
#      Si un utilisateur souhaite activer le fondu, une valeur de 10.0 est recommandée.
#       La valeur par défaut est 0.0, ce qui désactive le fondu.
#fade_target:
#       La position z vers laquelle le fondu doit converger. Lorsque cette valeur est
#      définie à une valeur non nulle, elle doit se situer dans la plage des valeurs z du maillage.
#      Les utilisateurs qui souhaitent converger vers la position de mise à l'origine du Z
#      doivent régler cette valeur à 0.
#      La valeur par défaut est la valeur z moyenne du maillage.
#split_delta_z: .025
#      Le delta de différence de Z (en mm) le long d'un mouvement qui déclenchera une séparation.
#      La valeur par défaut est de 0,025.
#move_check_distance: 5.0
#      La distance (en mm) le long d'un mouvement pour vérifier le split_delta_z.
#     C'est également la longueur minimale à laquelle un mouvement peut être divisé. 
#     La valeur par défaut est 5.0.
#mesh_pps: 2, 2
#     Une paire de nombres entiers X, Y séparés par des virgules, définissant le nombre de
#     points par segment à interpoler dans le maillage le long de chaque axe. Un  "segment" 
#     étant défini comme l'espace entre chaque point sondé.
#     L'utilisateur peut saisir une seule valeur qui sera appliquée aux deux axes.
#     La valeur par défaut est 2, 2.
#algorithme: lagrange
#     L'algorithme d'interpolation à utiliser. Soit "lagrange", soit "bicubique". Cette option
#     n'affecte pas les grilles 3x3, qui sont forcées d'utiliser l'échantillonnage de lagrange.
#     La valeur par défaut est lagrange.
#bicubic_tension: .2
#     Lors de l'utilisation de l'algorithme bicubique, le paramètre de tension ci-dessus peut
#     être appliqué pour modifier la quantité de pente interpolée.
#     Des nombres plus grands augmenteront la quantité de pente entraînant une plus grande
#     courbure du maillage. La valeur par défaut est 0,2.
#relative_reference_index:
#     Un index de point dans le maillage auquel référencer toutes les valeurs z. En activant
#     ce paramètre, on produit un maillage relatif à la position z sondée de l'indice fourni.
#faulty_region_1_min:
#faulty_region_1_max:
#      Points optionnels qui définissent une région défectueuse.  Voir docs/Bed_Mesh.md
#      pour plus de détails sur les régions défectueuses.  Jusqu'à 99 régions défectueuses 
#      peuvent être ajoutées.
#     Par défaut, aucune région défectueuse n'est définie.
```

### [bed_tilt]

Compensation de l'inclinaison du lit. On peut définir une section de configuration bed_tilt pour activer les transformations de déplacement qui tiennent compte d'un lit incliné. Notez que bed_mesh et bed_tilt sont incompatibles ; les deux ne peuvent pas être définis en même temps.

See the [command reference](G-Codes.md#bed_tilt) for additional information.

```
[bed_tilt]
#x_adjust: 0
#      Quantité à ajouter à la hauteur Z de chaque mouvement pour chaque mm sur l'axe X
#     La valeur par défaut est 0.
#y_adjust: 0
#     Quantité à ajouter à la hauteur Z de chaque mouvement pour chaque mm sur l'axe Y.
#     La valeur par défaut est 0.
#z_adjust: 0
#     Quantité à ajouter à la hauteur Z lorsque la buse est nominalement à 0, 0.
#     La valeur par défaut est 0.
#     Les paramètres restants contrôlent une commande g-code étendue BED_TILT_CALIBRATE utilisée
#     pour calibrer les paramètres de réglage x et y appropriés.
#points:
#      Une liste de coordonnées X, Y (une par ligne ; les lignes suivantes indentées) qui doivent
#      être sondées pendant une commande BED_TILT_CALIBRATE
#      Spécifiez les coordonnées de la buse et assurez-vous que la sonde est au-dessus du lit 
#      aux coordonnées données de la buse. 
#      La valeur par défaut est de ne pas activer la commande.
#speed: 50
#      Vitesse (en mm/s) des mouvements de déplacements hors palpage pendant l'étalonnage.
#      La valeur par défaut est 50.
#horizontal_move_z: 5
#     Hauteur (en mm) à laquelle la tête doit être relevée lors du déplacement
#     juste avant de lancer une opération de palpage. La valeur par défaut est 5.
```

### [bed_screws]

Outil d'aide au réglage des vis de mise à niveau du lit. On peut définir une section de configuration [bed_screws] pour activer une commande g-code BED_SCREWS_ADJUST.

See the [leveling guide](Manual_Level.md#adjusting-bed-leveling-screws) and [command reference](G-Codes.md#bed_screws) for additional information.

```
[bed_screws]
#screw1:
#       Coordonnées X, Y de la première vis de réglage du niveau du lit. Il s'agit d'une
#       position vers laquelle déplacer la buse afin qu'elle soit placée au-dessus de cette vis
#      de réglage (ou aussi proche que possible tout en étant au-dessus  du lit).
#       Ce paramètre doit être fourni.
#screw1_name:
#       Un nom arbitraire pour la vis donnée. Ce nom est affiché lors de
#       l'exécution du script d'aide. Par défaut, le nom utilisé est basé sur
#       la position XY de la vis.
#screw1_fine_adjust :
#       Coordonnées X, Y pour commander la buse afin de pouvoir affiner le réglage de la vis de mise 
#       à niveau du lit. Par défaut, il n'y a pas de réglage fin sur la vis de mise à niveau du lit.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#       Vis supplémentaires de mise à niveau du lit. Au moins trois vis doivent être
#      définies.
#horizontal_move_z: 5
#       Hauteur (en mm) à laquelle la tête doit être relevée pour se déplacer
#       lors du passage d'une vis à la suivante. La valeur par défaut est 5.
#probe_height: 0
#       Hauteur de la sonde (en mm) après ajustement pour la dilatation thermique du lit
#       et de la buse. La valeur par défaut est zéro.
#speed: 50
#      Vitesse (en mm/s) des déplacements entre les palpages pendant l'étalonnage.
#      La valeur par défaut est 50.
#probe_speed: 5
#      Vitesse (en mm/s) lors du déplacement d'une position horizontal_move_z
#      à la position probe_height. La valeur par défaut est 5.
```

### [screws_tilt_adjust]

Outil d'aide au réglage de l'inclinaison des vis du lit à l'aide du palpeur Z. On peut définir une section de configuration screws_tilt_adjust pour activer une commande g-code SCREWS_TILT_CALCULATE.

See the [leveling guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) and [command reference](G-Codes.md#screws_tilt_adjust) for additional information.

```
[screws_tilt_adjust]
#screw1:
#   The (X, Y) coordinate of the first bed leveling screw. This is a
#   position to command the nozzle to so that the probe is directly
#   above the bed screw (or as close as possible while still being
#   above the bed). This is the base screw used in calculations. This
#   parameter must be provided.
#screw1_name:
#   An arbitrary name for the given screw. This name is displayed when
#   the helper script runs. The default is to use a name based upon
#   the screw XY location.
#screw2:
#screw2_name:
#...
#   Additional bed leveling screws. At least two screws must be
#   defined.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#screw_thread: CW-M3
#   The type of screw used for bed level, M3, M4 or M5 and the
#   direction of the knob used to level the bed, clockwise decrease
#   counter-clockwise decrease.
#   Accepted values: CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
#   Default value is CW-M3, most printers use an M3 screw and
#   turning the knob clockwise decrease distance.
```

### [z_tilt]

Multiple Z stepper tilt adjustment. This feature enables independent adjustment of multiple z steppers (see the "stepper_z1" section) to adjust for tilt. If this section is present then a Z_TILT_ADJUST extended [G-Code command](G-Codes.md#z_tilt) becomes available.

```
[z_tilt]
#z_positions:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) describing the location of each bed "pivot point". The
#   "pivot point" is the point where the bed attaches to the given Z
#   stepper. It is described using nozzle coordinates (the X, Y position
#   of the nozzle if it could move directly above the point). The
#   first entry corresponds to stepper_z, the second to stepper_z1,
#   the third to stepper_z2, etc. This parameter must be provided.
#points:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) that should be probed during a Z_TILT_ADJUST command.
#   Specify coordinates of the nozzle and be sure the probe is above
#   the bed at the given nozzle coordinates. This parameter must be
#   provided.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#retries: 0
#   Number of times to retry if the probed points aren't within
#   tolerance.
#retry_tolerance: 0
#   If retries are enabled then retry if largest and smallest probed
#   points differ more than retry_tolerance. Note the smallest unit of
#   change here would be a single step. However if you are probing
#   more points than steppers then you will likely have a fixed
#   minimum value for the range of probed points which you can learn
#   by observing command output.
```

### [quad_gantry_level]

Mise à niveau du portique mobile à l'aide de 4 moteurs Z contrôlés indépendamment. Corrige les effets de paraboles hyperboliques (chips de pommes de terre) sur le portique mobile qui est plus flexible. AVERTISSEMENT : L'utilisation de cette section sur un lit mobile peut conduire à des résultats indésirables. Si cette section est présente, une commande G-Code étendue QUAD_GANTRY_LEVEL devient disponible. Cette routine suppose la configuration suivante du moteur Z :

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

Where x is the 0, 0 point on the bed

```
[quad_gantry_level]
#gantry_corners:
#   A newline separated list of X, Y coordinates describing the two
#   opposing corners of the gantry. The first entry corresponds to Z,
#   the second to Z2. This parameter must be provided.
#points:
#   A newline separated list of four X, Y points that should be probed
#   during a QUAD_GANTRY_LEVEL command. Order of the locations is
#   important, and should correspond to Z, Z1, Z2, and Z3 location in
#   order. This parameter must be provided. For maximum accuracy,
#   ensure your probe offsets are configured.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#max_adjust: 4
#   Safety limit if an adjustment greater than this value is requested
#   quad_gantry_level will abort.
#retries: 0
#   Number of times to retry if the probed points aren't within
#   tolerance.
#retry_tolerance: 0
#   If retries are enabled then retry if largest and smallest probed
#   points differ more than retry_tolerance.
```

### [skew_correction]

Printer Skew Correction. It is possible to use software to correct printer skew across 3 planes, xy, xz, yz. This is done by printing a calibration model along a plane and measuring three lengths. Due to the nature of skew correction these lengths are set via gcode. See [Skew Correction](Skew_Correction.md) and [Command Reference](G-Codes.md#skew_correction) for details.

```
[skew_correction]
```

### [z_thermal_adjust]

Temperature-dependant toolhead Z position adjustment. Compensate for vertical toolhead movement caused by thermal expansion of the printer's frame in real-time using a temperature sensor (typically coupled to a vertical section of frame).

See also: [extended g-code commands](G-Codes.md#z_thermal_adjust).

```
[z_thermal_adjust]
#temp_coeff:
#   The temperature coefficient of expansion, in mm/degC. For example, a
#   temp_coeff of 0.01 mm/degC will move the Z axis downwards by 0.01 mm for
#   every degree Celsius that the temperature sensor increases. Defaults to
#   0.0 mm/degC, which applies no adjustment.
#smooth_time:
#   Smoothing window applied to the temperature sensor, in seconds. Can reduce
#   motor noise from excessive small corrections in response to sensor noise.
#   The default is 2.0 seconds.
#z_adjust_off_above:
#   Disables adjustments above this Z height [mm]. The last computed correction
#   will remain applied until the toolhead moves below the specified Z height
#   again. The default is 99999999.0 mm (always on).
#max_z_adjustment:
#   Maximum absolute adjustment that can be applied to the Z axis [mm]. The
#   default is 99999999.0 mm (unlimited).
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Temperature sensor configuration.
#   See the "extruder" section for the definition of the above
#   parameters.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
```

## Mise à l'origine personnalisée

### [safe_z_home]

Safe Z homing. One may use this mechanism to home the Z axis at a specific X, Y coordinate. This is useful if the toolhead, for example has to move to the center of the bed before Z can be homed.

```
[safe_z_home]
home_xy_position:
#   A X, Y coordinate (e.g. 100, 100) where the Z homing should be
#   performed. This parameter must be provided.
#speed: 50.0
#   Speed at which the toolhead is moved to the safe Z home
#   coordinate. The default is 50 mm/s
#z_hop:
#   Distance (in mm) to lift the Z axis prior to homing. This is
#   applied to any homing command, even if it doesn't home the Z axis.
#   If the Z axis is already homed and the current Z position is less
#   than z_hop, then this will lift the head to a height of z_hop. If
#   the Z axis is not already homed the head is lifted by z_hop.
#   The default is to not implement Z hop.
#z_hop_speed: 15.0
#   Speed (in mm/s) at which the Z axis is lifted prior to homing. The
#   default is 15 mm/s.
#move_to_previous: False
#   When set to True, the X and Y axes are reset to their previous
#   positions after Z axis homing. The default is False.
```

### [homing_override]

Homing override. On peut utiliser ce mécanisme pour exécuter une série de commandes g-code à la place d'un G28 trouvé dans l'entrée g-code normale. Cela peut être utile sur les imprimantes qui nécessitent une procédure spécifique du retour au point d'origine de la machine.

```
[homing_override]
gcode:
#    Une liste de commandes G-Code à exécuter à la place des commandes G28
#    trouvées dans l'entrée g-code normale. Voir docs/Command_Templates.md
#    pour le format G-Code. Si un G28 est contenu dans cette liste de commandes
#    alors la procédure de retour à la normale de l'imprimante sera invoquée.
#    Les commandes énumérées ici doivent ramener tous les axes à la position initiale.
#    Ce paramètre doit être fourni.
#axes: xyz
#    Les axes à remplacer. Par exemple, si ce paramètre est défini sur "z", alors le script
#   d'annulation ne sera exécuté que lorsque l'axe z est mis à l'origine (par ex.
#    une commande "G28" ou "G28 Z"). Remarque : le script de neutralisation doit
#    toujours gérer tous les axes. La valeur par défaut est "xyz" ce qui fait que le script
#   de remplacement sera exécuté à la place de toutes les commandes G28.
#set_position_x:
#set_position_y:
#set_position_z:
#    Si spécifié, l'imprimante supposera que l'axe est à la position spécifiée avant
#    d'exécuter les commandes g-code ci-dessus. Le fait de définir ceci
#    désactive les contrôles d'orientation pour cet axe. Cela peut être utile si la
#    tête doit se déplacer avant d'invoquer le mécanisme G28 normal pour un axe.
#    La valeur par défaut est de ne pas forcer une position pour un axe.
```

### [endstop_phase]

Interrupteurs de fin de course ajustés à la phase du pilote de moteur pas à pas. Pour utiliser cette fonction, définissez une section de configuration avec un préfixe "endstop_phase" suivi du nom de la section de configuration du pilote de moteur pas à pas correspondante (par exemple, "[endstop_phase stepper_z]"). Cette fonctionnalité peut améliorer la précision des interrupteurs de fin de course. Ajouter une déclaration nue "[endstop_phase]" pour activer la commande ENDSTOP_PHASE_CALIBRATE.

See the [endstop phases guide](Endstop_Phase.md) and [command reference](G-Codes.md#endstop_phase) for additional information.

```
[endstop_phase stepper_z]
#endstop_accuracy:
#    Définit la précision attendue (en mm) de la butée. Cela représente
#    la distance d'erreur maximale que la butée peut déclencher 
#    (par exemple, si une butée peut occasionnellement se déclencher 100um en avance ou
#    jusqu'à 100um en retard alors réglez cette valeur sur 0.200 pour 200um). La valeur
#    par défaut est 4*rotation_distance/full_steps_per_rotation.
#trigger_phase:
#     Spécifie la phase du pilote du moteur pas à pas à attendre
#     lorsque l'on atteint la butée. Composé de deux nombres séparés
#     par une barre oblique - la phase et le nombre total de phases
#     (par exemple, "7/64"). Ne définissez cette valeur que si vous êtes sûr que le
#     pilote du moteur pas à pas est réinitialisé à chaque fois que le mcu est réinitialisé. 
#    Si cette valeur n'est pas définie, alors la phase du moteur pas à pas sera détectée à la
#    première mise à l'origine et cette phase sera utilisée sur toutes les origines suivantes.
#endstop_align_zero: False
#    Si vrai, la position_endstop de l'axe sera effectivement  modifiée de manière à ce que la
#    position zéro de l'axe se produise à un pas  complet du moteur pas à pas. (Si utilisé sur
#    l'axe Z et que la hauteur de la couche d'impression est un multiple de la distance parcourue
#    par un pas complet, alors chaque couche se produira sur un pas complet).
#    La valeur par défaut est False.
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
#    Le nom de variable donné se verra attribué la valeur donnée (analysée
#    comme un littéral Python) et sera disponible pendant l'expansion de la macro.
#    Par exemple, une configuration avec "variable_fan_speed = 75" pourrait avoir
#    des commandes gcode contenant "M106 S{ fan_speed * 255 }". Ces variables
#    peuvent être modifiées au moment de l'exécution en utilisant la commande SET_GCODE_VARIABLE
#    (voir docs/Command_Templates.md pour plus de détails). Les noms de variables peuvent
#    ne pas utiliser de caractères majuscules.
#rename_existing:
#    Cette option permet à la macro de remplacer une commande G-Code existante
#    existante et fournira la définition précédente de la commande via le nom
#    fourni ici. Ceci peut être utilisé pour remplacer les commandes G-Code originelles.
#    Il convient d'être prudent lorsque l'on remplace des commandes, car cela peut provoquer
#     des résultats complexes et inattendus. La valeur par défaut est de ne pas
#     remplacer une commande G-Code existante.
#description: Macro G-Code
#    Ceci ajoutera une courte description utilisée à la commande HELP ou lors de l'utilisation de la fonction de complétion automatique.
#    Par défaut : "G-Code macro".
```

### [delayed_gcode]

Exécute un gcode sur un délai défini. Voir le [guide des modèles de commande](Command_Templates.md#delayed-gcodes) et la [référence des commandes](G-Codes.md#delayed_gcode) pour plus d'informations.

```
[delayed_gcode my_delayed_gcode]
gcode:
#      Une liste de commandes G-Code à exécuter lorsque la durée du délai est écoulée.
#      Les modèles G-Code sont supportés. Ce paramètre doit être fourni.
#initial_duration: 0.0
#      Durée du délai initial (en secondes). Si elle est définie à une
#      valeur non nulle, le gcode différé s'exécutera le nombre de secondes spécifié
#     après que l'imprimante passe à l'état "prêt". Ceci peut être
#     utile pour les procédures d'initialisation ou lors d'une répétition de delayed_gcode.
#     Si la valeur est 0, le delayed_gcode ne sera pas exécuté au démarrage.
#     La valeur par défaut est 0.
```

### [save_variables]

Support saving variables to disk so that they are retained across restarts. See [command templates](Command_Templates.md#save-variables-to-disk) and [G-Code reference](G-Codes.md#save_variables) for further information.

```
[save_variables]
filename:
#   Required - provide a filename that would be used to save the
#   variables to disk e.g. ~/variables.cfg
```

### [idle_timeout]

Délai d'inactivité. Un délai d'inactivité est automatiquement activé - ajoutez une section de configuration idle_timeout explicite pour modifier les paramètres par défaut.

```
[idle_timeout]
#gcode:
#    Une liste de commandes G-Code à exécuter lors d'un délai d'inactivité. Voir
#    docs/Command_Templates.md pour le format G-Code. La valeur par défaut est d'exécuter
#    "TURN_OFF_HEATERS" et "M84".
#timeout: 600
#    Temps d'attente (en secondes) avant d'exécuter les commandes G-Code ci-dessus.
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
```

### [sdcard_loop]

Certaines imprimantes dotées de fonctions d'éjections des pièces imprimées, comme un éjecteur de pièces ou une imprimante à courroie, peuvent trouver une utilité dans la mise en boucle de sections du fichier de la carte SD (par exemple, pour imprimer la même pièce encore et encore, ou répéter une section d'une pièce pour une chaîne ou un autre motif répété).

See the [command reference](G-Codes.md#sdcard_loop) for supported commands. See the [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin compatible M808 G-Code macro.

```
[sdcard_loop]
```

### [force_move]

Support manually moving stepper motors for diagnostic purposes. Note, using this feature may place the printer in an invalid state - see the [command reference](G-Codes.md#force_move) for important details.

```
[force_move]
#enable_force_move: False
#    Défini à true pour activer les commandes G-Code étendues FORCE_MOVE et
#    SET_KINEMATIC_POSITION
#    La valeur par défaut est false.
```

### [pause_resume]

Pause/Resume functionality with support of position capture and restore. See the [command reference](G-Codes.md#pause_resume) for more information.

```
[pause_resume]
#recover_velocity: 50.
#   When capture/restore is enabled, the speed at which to return to
#   the captured position (in mm/s). Default is 50.0 mm/s.
```

### [firmware_retraction]

Rétraction du filament par le firmware. Cela permet d'activer les commandes GCODE G10 (rétraction) et G11 (dé-rétraction) émises par de nombreux trancheurs. Les paramètres ci-dessous fournissent des valeurs par défaut au démarrage, mais les valeurs peuvent être ajustées via la [commande SET_RETRACTION](G-Codes.md#firmware_retraction), ce qui permet des réglages par filament et des ajustements en cours d'exécution.

```
[firmware_retraction]
#retract_length: 0
#    La longueur du filament (en mm) à rétracter lorsque G10 est activé,
#    et à libérer lorsque G11 est activé (mais voir unretract_extra_length ci-dessous).
#    La valeur par défaut est 0 mm.
#retract_speed: 20
#    La vitesse de rétraction, en mm/s. La valeur par défaut est 20 mm/s.
#unretract_extra_length: 0
#    Longueur (en mm) de filament *supplémentaire* à ajouter lors de la rétraction.
#unretract_speed: 10
#    La vitesse de ré-rétraction, en mm/s. La valeur par défaut est 10 mm/s.
```

### [gcode_arcs]

Support des commandes gcode de courbes (arc) (G2/G3).

```
[gcode_arcs]
#resolution: 1.0
#    Un arc sera divisé en segments. La longueur de chaque segment sera
#    égale à la résolution en mm définie ci-dessus. Des valeurs plus faibles produiront un
#    un arc plus fin, mais aussi plus de travail pour votre machine. Les arcs plus petits que
#    la valeur configurée deviendront des lignes droites. La valeur par défaut est
#    1 mm.
```

### [respond]

Active les [commandes étendues "M118" et "RESPOND"](G-Codes.md#respond).

```
[respond]
#default_type: echo
#   Sets the default prefix of the "M118" and "RESPOND" output to one
#   of the following:
#       echo: "echo: " (This is the default)
#       command: "// "
#       error: "!! "
#default_prefix: echo:
#   Directly sets the default prefix. If present, this value will
#   override the "default_type".
```

### [exclude_object]

Permet de prendre en charge l'exclusion ou l'annulation d'objets individuels pendant le processus d'impression.

See the [exclude objects guide](Exclude_Object.md) and [command reference](G-Codes.md#excludeobject) for additional information. See the [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.

```
[exclude_object]
```

## Compensation de la résonance

### [input_shaper]

Active la [compensation de résonance](Resonance_Compensation.md). Voir également les [références de commandes](G-Codes.md#input_shaper).

```
[input_shaper]
#shaper_freq_x: 0
#    Fréquence (en Hz) de la mise en forme de l'entrée pour l'axe X. Il s'agit
#    généralement d'une fréquence de résonance de l'axe X que la mise en forme de l'entrée
#    doit supprimer. Pour les mises en forme plus complexes, comme les mises en forme à 2 ou 3 bosses EI
#    (2hump/3hump), ce paramètre peut être défini à partir de différentes considérations.
#    La valeur par défaut est 0, ce qui désactive la mise en forme de l'entrée pour l'axe X.
#shaper_freq_y: 0
#    Fréquence (en Hz) de la mise en forme de l'entrée pour l'axe Y. Il s'agit
#    généralement d'une fréquence de résonance de l'axe Y que la mise en forme de l'entrée
#    doit supprimer. Pour les mises en forme plus complexes, comme les mises en forme à 2 ou 3 bosses EI
#    (2hump/3hump), ce paramètre peut être défini à partir de différentes considérations.
#   La valeur par défaut est 0, ce qui désactive la mise en forme de l'entrée pour l'axe Y.
#shaper_type: mzv
#    Un type de mise en forme d'entrée à utiliser pour les axes X et Y. Les types supportés
#    sont zv, mzv, zvd, ei, 2hump_ei, et 3hump_ei. La valeur par défaut
#    est la compensation de résonance mzv.
#shaper_type_x:
#shaper_type_y:
#    Si shaper_type n'est pas défini, ces deux paramètres peuvent être utilisés pour
#    configurer des formes d'entrée différentes pour les axes X et Y. Les mêmes valeurs
#   sont supportées comme pour le paramètre shaper_type.
#damping_ratio_x: 0.1
#damping_ratio_y: 0.1
#    Rapports d'amortissement des vibrations des axes X et Y utilisés par les dispositifs de mise
#    en forme en entrée pour améliorer la suppression des vibrations. La valeur par défaut est
#    0.1 ce qui est une bonne valeur générale pour la plupart des imprimantes. Dans la plupart
#    des cas, ce paramètre ne nécessite aucun réglage et ne doit pas être modifié.
```

### [adxl345]

Support for ADXL345 accelerometers. This support allows one to query accelerometer measurements from the sensor. This enables an ACCELEROMETER_MEASURE command (see [G-Codes](G-Codes.md#adxl345) for more information). The default chip name is "default", but one may specify an explicit name (eg, [adxl345 my_chip_name]).

```
[adxl345]
cs_pin:
#     La broche d'activation SPI du capteur. Ce paramètre doit être fourni.
#spi_speed: 5000000
#     La vitesse SPI (en hz) à utiliser lors de la communication avec la puce.
#    La valeur par défaut est 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#     Voir la section "paramètres SPI communs" pour une description des
#     paramètres ci-dessus.
#axes_map : x, y, z
#     L'axe de l'accéléromètre de chacun des axes X, Y et Z de l'imprimante.
#     Ceci peut être utile si l'accéléromètre est monté dans une orientation 
#     qui ne correspond pas à celle de l'imprimante. Par exemple,
#     on peut régler cette option sur "y, x, z" pour permuter les axes X et Y.
#     Il est également possible d'annuler un axe si la direction de l'accéléromètre
#     est inversée (par exemple, "x, z, -y"). La valeur par défaut est "x, y, z".
#Rate: 3200
#     Taux de données de sortie pour ADXL345. ADXL345 supporte les taux de
#     de données suivants : 3200, 1600, 800, 400, 200, 100, 50, et 25. Notez qu'il n'est
#     pas recommandé de changer ce taux par rapport au taux par défaut de 3200, et
#     les taux inférieurs à 800 affecteront considérablement la qualité des mesures 
#     des mesures de résonance.
```

### [mpu9250]

Support for mpu9250 and mpu6050 accelerometers (one may define any number of sections with an "mpu9250" prefix).

```
[mpu9250 my_accelerometer]
#i2c_address:
#   Default is 104 (0x68).
#i2c_mcu:
#i2c_bus:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [resonance_tester]

Support for resonance testing and automatic input shaper calibration. In order to use most of the functionality of this module, additional software dependencies must be installed; refer to [Measuring Resonances](Measuring_Resonances.md) and the [command reference](G-Codes.md#resonance_tester) for more information. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) section of the measuring resonances guide for more information on `max_smoothing` parameter and its use.

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
#min_freq: 5
#   Minimum frequency to test for resonances. The default is 5 Hz.
#max_freq: 133.33
#   Maximum frequency to test for resonances. The default is 133.33 Hz.
#accel_per_hz: 75
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
```

## Aides pour les fichiers de configuration

### [board_pins]

Alias des broches de la carte (on peut définir un nombre quelconque de sections avec le préfixe "board_pins"). Utilisez ceci pour définir des alias pour les broches d'un micro-contrôleur.

```
[board_pins my_aliases]
mcu: mcu
#      Une liste de micro-contrôleurs séparés par des virgules qui peuvent utiliser les
#      alias. La valeur par défaut est d'appliquer les alias au "mcu" principal.
alias:
aliases_<nom>:
#      Une liste séparée par des virgules d'alias "nom=valeur" à créer pour le 
#      microcontrôleur donné. Par exemple, "EXP1_1=PE6" créera un alias "EXP1_1"
#      pour la broche "PE6". Cependant, si la "valeur" est incluse
#      dans "<>", alors "nom" est créé comme une broche réservée (par exemple,
#      "EXP1_9=<GND>" réserverait "EXP1_9"). Un nombre quelconque d'options
#      commençant par "alias_" peuvent être spécifiées.
```

### [include]

Prise en charge des fichiers d'inclusion. On peut inclure des fichiers de configuration supplémentaires à partir du fichier de configuration principal de l'imprimante. Des caractères génériques peuvent également être utilisés (par exemple, "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

This tool allows a single micro-controller pin to be defined multiple times in a config file without normal error checking. This is intended for diagnostic and debugging purposes. This section is not needed where Klipper supports using the same pin multiple times, and using this override may cause confusing and unexpected results.

```
[duplicate_pin_override]
pins:
#    Une liste de broches séparées par des virgules pouvant être utilisées plusieurs fois dans
#    un fichier de configuration sans contrôles d'erreurs normaux. Ce paramètre doit être
#    fourni.
```

## Matériel de nivelage du lit

### [probe]

Sonde de hauteur Z. On peut définir cette section pour activer le matériel de nivelage de l'axer Z. Lorsque cette section est activée, les commandes [g-code étendus](G-Codes.md#probe) PROBE et QUERY_PROBE deviennent disponibles. Consultez également le [guide d'étalonnage des sondes](Probe_Calibrate.md). La section probe crée également une broche virtuelle "probe:z_virtual_endstop". Il est possible de définir la broche du stepper_z, endstop_pin, sur cette broche virtuelle pour les imprimantes de style cartésien qui utilisent la sonde à la place d'un interrupteur de fin de course Z. Si vous utilisez "probe:z_virtual_endstop", ne définissez pas de position_endstop dans la configuration de la section stepper_z.

```
[probe]
pin:
#   Probe detection pin. If the pin is on a different microcontroller
#   than the Z steppers then it enables "multi-mcu homing". This
#   parameter must be provided.
#deactivate_on_each_sample: True
#   This determines if Klipper should execute deactivation gcode
#   between each probe attempt when performing a multiple probe
#   sequence. The default is True.
#x_offset: 0.0
#   The distance (in mm) between the probe and the nozzle along the
#   x-axis. The default is 0.
#y_offset: 0.0
#   The distance (in mm) between the probe and the nozzle along the
#   y-axis. The default is 0.
z_offset:
#   The distance (in mm) between the bed and the nozzle when the probe
#   triggers. This parameter must be provided.
#speed: 5.0
#   Speed (in mm/s) of the Z axis when probing. The default is 5mm/s.
#samples: 1
#   The number of times to probe each point. The probed z-values will
#   be averaged. The default is to probe 1 time.
#sample_retract_dist: 2.0
#   The distance (in mm) to lift the toolhead between each sample (if
#   sampling more than once). The default is 2mm.
#lift_speed:
#   Speed (in mm/s) of the Z axis when lifting the probe between
#   samples. The default is to use the same value as the 'speed'
#   parameter.
#samples_result: average
#   The calculation method when sampling more than once - either
#   "median" or "average". The default is average.
#samples_tolerance: 0.100
#   The maximum Z distance (in mm) that a sample may differ from other
#   samples. If this tolerance is exceeded then either an error is
#   reported or the attempt is restarted (see
#   samples_tolerance_retries). The default is 0.100mm.
#samples_tolerance_retries: 0
#   The number of times to retry if a sample is found that exceeds
#   samples_tolerance. On a retry, all current samples are discarded
#   and the probe attempt is restarted. If a valid set of samples are
#   not obtained in the given number of retries then an error is
#   reported. The default is zero which causes an error to be reported
#   on the first sample that exceeds samples_tolerance.
#activate_gcode:
#   A list of G-Code commands to execute prior to each probe attempt.
#   See docs/Command_Templates.md for G-Code format. This may be
#   useful if the probe needs to be activated in some way. Do not
#   issue any commands here that move the toolhead (eg, G1). The
#   default is to not run any special G-Code commands on activation.
#deactivate_gcode:
#   A list of G-Code commands to execute after each probe attempt
#   completes. See docs/Command_Templates.md for G-Code format. Do not
#   issue any commands here that move the toolhead. The default is to
#   not run any special G-Code commands on deactivation.
```

### [bltouch]

Sonde BLTouch. On peut définir cette section (au lieu d'une section probe) pour activer une sonde BLTouch. Voir [Guide BL-Touch](BLTouch.md) et [Référence de la commande](G-Codes.md#bltouch) pour plus d'informations. Une broche virtuelle "probe:z_virtual_endstop" est également créée (voir la section "probe" pour les détails).

```
[bltouch]
sensor_pin:
#      Broche connectée à la broche du capteur BLTouch. La plupart des dispositifs BLTouch
#      exigent un pullup sur la broche du capteur (préfixez le nom de la broche par "^").
#      Ce paramètre doit être fourni.
control_pin:
#      Broche connectée à la broche de commande du BLTouch.
#      Ce paramètre doit être fourni.
#pin_move_time: 0.680
#      Durée d'attente (en secondes) pour que la broche BLTouch se
#      se déplace vers le haut ou le bas. La valeur par défaut est de 0,680 seconde.
#stow_on_each_sample: True
#      Détermine si Klipper doit ordonner à la broche de se déplacer vers le haut 
#      entre chaque tentative de palpage lors d'une séquence de palpage multiple.
#      Lisez les instructions dans docs/BLTouch.md avant de mettre ce paramètre à False.
#      La valeur par défaut est True.
#probe_with_touch_mode: False
#       Si ce paramètre est défini sur True, Klipper sondera avec le périphérique en
#       "touch_mode". La valeur par défaut est False (palpage en mode "pin_down").
#pin_up_reports_not_triggered: True
#       Définit si le BLTouch rapporte systématiquement le palpeur dans un état "non
#       déclenché" après une commande "pin_up" réussie. Ceci devrait
#       être True pour tous les BLTouch authentiques. Lisez les instructions de
#      docs/BLTouch.md avant de mettre cette valeur à False. La valeur par défaut est True.
#pin_up_touch_mode_reports_triggered: True
#      Définit si la BLTouch rapporte systématiquement un état "déclenché" après 
#      la commande "pin_up_mode_reports_triggered". Ceci devrait être
#     True pour tous les BLTouch authentiques. Lisez les instructions de
#     docs/BLTouch.md avant de mettre cette valeur à False. La valeur par défaut est True.
#set_output_mode:
#      Demande un mode de sortie spécifique pour la broche du capteur sur le BLTouch V3.0 (et
#      ultérieurs). Ce paramètre ne doit pas être utilisé sur d'autres types de sondes.
#      Réglez sur "5V" pour demander une sortie de 5 Volts pour la broche du capteur (à n'utiliser que si
#      la carte contrôleur a besoin du mode 5V et est tolérante à 5V sur sa ligne de signal d'entrée).
#      Réglez sur "OD" pour demander l'utilisation de la sortie de la broche du capteur en
#      mode drain ouvert. La valeur par défaut est de ne pas demander de mode de sortie.
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
#     Voir la section "probe" pour des informations sur ces paramètres.
```

### [smart_effector]

The "Smart Effector" from Duet3d implements a Z probe using a force sensor. One may define this section instead of `[probe]` to enable the Smart Effector specific features. This also enables [runtime commands](G-Codes.md#smart_effector) to adjust the parameters of the Smart Effector at run time.

```
[smart_effector]
pin:
#   Pin connected to the Smart Effector Z Probe output pin (pin 5). Note that
#   pullup resistor on the board is generally not required. However, if the
#   output pin is connected to the board pin with a pullup resistor, that
#   resistor must be high value (e.g. 10K Ohm or more). Some boards have a low
#   value pullup resistor on the Z probe input, which will likely result in an
#   always-triggered probe state. In this case, connect the Smart Effector to
#   a different pin on the board. This parameter is required.
#control_pin:
#   Pin connected to the Smart Effector control input pin (pin 7). If provided,
#   Smart Effector sensitivity programming commands become available.
#probe_accel:
#   If set, limits the acceleration of the probing moves (in mm/sec^2).
#   A sudden large acceleration at the beginning of the probing move may
#   cause spurious probe triggering, especially if the hotend is heavy.
#   To prevent that, it may be necessary to reduce the acceleration of
#   the probing moves via this parameter.
#recovery_time: 0.4
#   A delay between the travel moves and the probing moves in seconds. A fast
#   travel move prior to probing may result in a spurious probe triggering.
#   This may cause 'Probe triggered prior to movement' errors if no delay
#   is set. Value 0 disables the recovery delay.
#   Default value is 0.4.
#x_offset:
#y_offset:
#   Should be left unset (or set to 0).
z_offset:
#   Trigger height of the probe. Start with -0.1 (mm), and adjust later using
#   `PROBE_CALIBRATE` command. This parameter must be provided.
#speed:
#   Speed (in mm/s) of the Z axis when probing. It is recommended to start
#   with the probing speed of 20 mm/s and adjust it as necessary to improve
#   the accuracy and repeatability of the probe triggering.
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#deactivate_on_each_sample:
#   See the "probe" section for more information on the parameters above.
```

## Moteurs pas à pas et extrudeurs additionnels

### [stepper_z1]

Axes à pilotes de moteurs pas à pas multiples. Sur une imprimante de style cartésien, le pilote moteur contrôlant un axe donné peut avoir des blocs de configuration supplémentaires définissant les pilotes moteurs qui doivent être mis en marche de concert avec le pilote principal. On peut définir un nombre quelconque de sections avec un suffixe numérique commençant à 1 (par exemple, "stepper_z1", "stepper_z2", etc.).

```
[stepper_z1]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   See the "stepper" section for the definition of the above parameters.
#endstop_pin:
#   If an endstop_pin is defined for the additional stepper then the
#   stepper will home until the endstop is triggered. Otherwise, the
#   stepper will home until the endstop on the primary stepper for the
#   axis is triggered.
```

### [extruder1]

Dans une imprimante multi-extrudeurs, ajoutez une section d'extrudeur supplémentaire pour chaque extrudeur supplémentaire. Les sections d'extrudeur supplémentaires doivent être nommées "extruder1", "extruder2", "extruder3", et ainsi de suite. Voir la section "extruder" pour une description des paramètres disponibles.

Voir [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg) pour un exemple de configuration.

```
[extruder1]
#step_pin:
#dir_pin:
#...
#    Voir la section "extruder" pour les paramètres disponibles pour le pilote de moteur
#   pas à pas et l'élément de chauffe.
#shared_heater:
#    Cette option est obsolète et ne doit plus être utilisée.
```

### [dual_carriage]

Support for cartesian printers with dual carriages on a single axis. The active carriage is set via the SET_DUAL_CARRIAGE extended g-code command. The "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation.

See [sample-idex.cfg](../config/sample-idex.cfg) for an example configuration.

```
[dual_carriage]
axis:
#    L'axe sur lequel se trouve ce chariot supplémentaire (soit x, soit y). Ce paramètre
#    doit être fourni.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#    Voir la section "stepper" pour la définition des paramètres ci-dessus.
```

### [extruder_stepper]

Support for additional steppers synchronized to the movement of an extruder (one may define any number of sections with an "extruder_stepper" prefix).

See the [command reference](G-Codes.md#extruder) for more information.

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

Vérification de l'élément chauffant et du capteur de température. La vérification des éléments de chauffage est automatiquement activée pour chaque élément de chauffage configuré sur l'imprimante. Utilisez les sections verify_heater pour modifier les paramètres par défaut.

```
[verify_heater heater_config_name]
#max_error: 120
#   The maximum "cumulative temperature error" before raising an
#   error. Smaller values result in stricter checking and larger
#   values allow for more time before an error is reported.
#   Specifically, the temperature is inspected once a second and if it
#   is close to the target temperature then an internal "error
#   counter" is reset; otherwise, if the temperature is below the
#   target range then the counter is increased by the amount the
#   reported temperature differs from that range. Should the counter
#   exceed this "max_error" then an error is raised. The default is
#   120.
#check_gain_time:
#   This controls heater verification during initial heating. Smaller
#   values result in stricter checking and larger values allow for
#   more time before an error is reported. Specifically, during
#   initial heating, as long as the heater increases in temperature
#   within this time frame (specified in seconds) then the internal
#   "error counter" is reset. The default is 20 seconds for extruders
#   and 60 seconds for heater_bed.
#hysteresis: 5
#   The maximum temperature difference (in Celsius) to a target
#   temperature that is considered in range of the target. This
#   controls the max_error range check. It is rare to customize this
#   value. The default is 5.
#heating_gain: 2
#   The minimum temperature (in Celsius) that the heater must increase
#   by during the check_gain_time check. It is rare to customize this
#   value. The default is 2.
```

### [homing_heaters]

Outil pour désactiver les éléments chauffants lors de la prise d'origine ou du palpage d'un axe.

```
[homing_heaters]
#steppers:
#    Une liste de pilotes moteurs séparés par des virgules qui devraient entraîner la désactivation des chauffages
#    La valeur par défaut est de désactiver les chauffages pour tout déplacement (mise à l'origine / palpage).
#    Exemple typique : stepper_z
#heaters:
#    Une liste, séparée par des virgules, d'éléments chauffants à désactiver pendant les déplacements (mise à
#   l'origine / palpage). La valeur par défaut est de désactiver tous les éléments chauffants.
#   Exemple typique : extruder, heater_bed
```

### [thermistor]

Thermistances personnalisées (on peut définir un nombre quelconque de sections avec le préfixe "thermistor"). Une thermistance personnalisée peut être utilisée dans le champ sensor_type d'une section de configuration de chauffage. (Par exemple, si l'on définit une section "[thermistor my_thermistor]", on peut utiliser un "sensor_type: my_thermistor" lors de la définition d'un élément de chauffe). Veillez à placer la section thermistor dans le fichier de configuration avant sa première utilisation dans une section de chauffage.

```
[thermistor my_thermistor]
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#temperature3:
#resistance3:
#   Three resistance measurements (in Ohms) at the given temperatures
#   (in Celsius). The three measurements will be used to calculate the
#   Steinhart-Hart coefficients for the thermistor. These parameters
#   must be provided when using Steinhart-Hart to define the
#   thermistor.
#beta:
#   Alternatively, one may define temperature1, resistance1, and beta
#   to define the thermistor parameters. This parameter must be
#   provided when using "beta" to define the thermistor.
```

### [adc_temperature]

Capteurs de température ADC personnalisés (on peut définir un nombre quelconque de sections avec un préfixe "adc_temperature"). Cela permet de définir un capteur de température personnalisé qui mesure une tension sur une broche de convertisseur analogique-numérique (ADC) et utilise une interpolation linéaire entre un ensemble de mesures configurées de température/tension (ou de température/résistance) pour déterminer la température. Le capteur résultant peut être utilisé comme un type de capteur dans une section de chauffage. (Par exemple, si l'on définit une section "[adc_temperature my_sensor]", on peut utiliser un "sensor_type : my_sensor" lors de la définition d'un élément chauffant). Veillez à placer la section du capteur dans le fichier de configuration avant sa première utilisation dans une section de chauffage.

```
[adc_temperature mon_capteur]
#temperature1 :
#voltage1 :
#temperature2 :
#voltage2 :
#...
#    Un ensemble de températures (en Celsius) et de tensions (en Volts) à utiliser
#    comme référence lors de la conversion d'une température. Une section de chauffage utilisant
#    ce capteur peut également spécifier les paramètres adc_voltage et voltage_offset
#    pour définir la tension ADC (voir la section "Amplificateurs communs de température"
#    pour plus de détails). Au moins deux mesures doivent être fournies.
#temperature1 :
#resistance1 :
#temperature2 :
#resistance2 :
#...
#    Alternativement, on peut spécifier un ensemble de températures (en Celsius)
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
#    paramètres ci-dessus.
```

### [temperature_sensor]

Capteurs de température génériques. On peut définir un nombre quelconque de capteurs de température supplémentaires qui sont remontés par la commande M105.

```
[temperature_sensor my_sensor]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   See the "extruder" section for the definition of the above
#   parameters.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
```

## Temperature sensors

Klipper inclut des définitions pour de nombreux types de capteurs de température. Ces capteurs peuvent être utilisés dans n'importe quelle section de la configuration nécessitant un capteur de température (comme une section `[extruder]` ou `[heater_bed]`).

### Thermistances courantes

Thermistances courantes. Les paramètres suivants sont disponibles dans les sections de chauffes qui utilisent l'un de ces capteurs.

```
sensor_type:
#   One of "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
#   "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
#   "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", or "TDK NTCG104LH104JT1"
sensor_pin:
#   Analog input pin connected to the thermistor. This parameter must
#   be provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the thermistor.
#   The default is 4700 ohms.
#inline_resistor: 0
#   The resistance (in ohms) of an extra (not heat varying) resistor
#   that is placed inline with the thermistor. It is rare to set this.
#   The default is 0 ohms.
```

### Amplificateurs de température courants

Amplificateurs de température courants. Les paramètres suivants sont disponibles dans les sections de chauffes qui utilisent l'un de ces capteurs.

```
sensor_type:
#   One of "PT100 INA826", "AD595", "AD597", "AD8494", "AD8495",
#   "AD8496", or "AD8497".
sensor_pin:
#   Analog input pin connected to the sensor. This parameter must be
#   provided.
#adc_voltage: 5.0
#   The ADC comparison voltage (in Volts). The default is 5 volts.
#voltage_offset: 0
#   The ADC voltage offset (in Volts). The default is 0.
```

### Capteur PT1000 directement connecté

Capteur PT1000 connecté en direct. Les paramètres suivants sont disponibles dans les sections chauffage utilisant ces capteurs.

```
sensor_type: PT1000
sensor_pin:
#   Analog input pin connected to the sensor. This parameter must be
#   provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the sensor. The
#   default is 4700 ohms.
```

### Sondes de température MAXxxxxx

Capteurs MAXxxxxx à interface périphérique série (SPI) basés sur la température. Les paramètres suivants sont disponibles dans les sections de chauffage qui utilisent l'un de ces types de capteurs.

```
sensor_type:
#   One of "MAX6675", "MAX31855", "MAX31856", or "MAX31865".
sensor_pin:
#   The chip select line for the sensor chip. This parameter must be
#   provided.
#spi_speed: 4000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#tc_type: K
#tc_use_50Hz_filter: False
#tc_averaging_count: 1
#   The above parameters control the sensor parameters of MAX31856
#   chips. The defaults for each parameter are next to the parameter
#   name in the above list.
#rtd_nominal_r: 100
#rtd_reference_r: 430
#rtd_num_of_wires: 2
#rtd_use_50Hz_filter: False
#   The above parameters control the sensor parameters of MAX31865
#   chips. The defaults for each parameter are next to the parameter
#   name in the above list.
```

### Sonde de température BMP280/BME280/BME680

Capteurs environnementaux BMP280/BME280/BME680 à interface à deux fils (I2C). Notez que ces capteurs ne sont pas destinés à être utilisés avec les extrudeurpours et les lits chauffants, mais plutôt pour surveiller la température ambiante (C), la pression (hPa), l'humidité relative et, dans le cas du BME680, le niveau de gaz. Voir [sample-macros.cfg](../config/sample-macros.cfg) pour un gcode_macro qui peut être utilisé pour signaler la pression et l'humidité en plus de la température.

```
sensor_type: BME280
#i2c_address:
#   Default is 118 (0x76). Some BME280 sensors have an address of 119
#   (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### Capteur HTU21D

Capteur d'environnement de la famille HTU21D à interface à deux fils (I2C). Notez que ce capteur n'est pas destiné à être utilisé avec les extrudeuses et les lits chauffants, mais plutôt à surveiller la température ambiante (C) et l'humidité relative. Voir [sample-macros.cfg](../config/sample-macros.cfg) pour un gcode_macro utilisable pour indiquer l'humidité en plus de la température.

```
sensor_type:
#   Must be "HTU21D" , "SI7013", "SI7020", "SI7021" or "SHT21"
#i2c_address:
#   Default is 64 (0x40).
#i2c_mcu:
#i2c_bus:
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
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#lm75_report_time:
#   Interval in seconds between readings. Default is 0.8, with minimum
#   0.5.
```

### Capteur de température intégré au microcontrôleur

The atsam, atsamd, and stm32 micro-controllers contain an internal temperature sensor. One can use the "temperature_mcu" sensor to monitor these temperatures.

```
sensor_type: temperature_mcu
#sensor_mcu: mcu
#   The micro-controller to read from. The default is "mcu".
#sensor_temperature1:
#sensor_adc1:
#   Specify the above two parameters (a temperature in Celsius and an
#   ADC value as a float between 0.0 and 1.0) to calibrate the
#   micro-controller temperature. This may improve the reported
#   temperature accuracy on some chips. A typical way to obtain this
#   calibration information is to completely remove power from the
#   printer for a few hours (to ensure it is at the ambient
#   temperature), then power it up and use the QUERY_ADC command to
#   obtain an ADC measurement. Use some other temperature sensor on
#   the printer to find the corresponding ambient temperature. The
#   default is to use the factory calibration data on the
#   micro-controller (if applicable) or the nominal values from the
#   micro-controller specification.
#sensor_temperature2:
#sensor_adc2:
#   If sensor_temperature1/sensor_adc1 is specified then one may also
#   specify sensor_temperature2/sensor_adc2 calibration data. Doing so
#   may provide calibrated "temperature slope" information. The
#   default is to use the factory calibration data on the
#   micro-controller (if applicable) or the nominal values from the
#   micro-controller specification.
```

### Capteur de température de l'hôte

Temperature from the machine (eg Raspberry Pi) running the host software.

```
sensor_type: temperature_host
#sensor_path:
#   The path to temperature system file. The default is
#   "/sys/class/thermal/thermal_zone0/temp" which is the temperature
#   system file on a Raspberry Pi computer.
```

### Sonde de température DS18B20

Le DS18B20 est un capteur de température numérique à 1 fil (w1). Notez que ce capteur n'est pas destiné à être utilisé avec les extrudeurs et les lits chauffants, mais plutôt pour surveiller la température ambiante (C). Ces capteurs ont une portée allant jusqu'à 125 °C, et sont donc utilisables pour la surveillance de la température du caisson par exemple. Ils peuvent également fonctionner comme de simples contrôleurs de ventilateurs/éléments chauffants. Les capteurs DS18B20 ne sont supportés que par un "mcu hôte", par exemple le Raspberry Pi. Le module w1-gpio du noyau Linux doit être installé.

```
sensor_type: DS18B20
serial_no:
#   Each 1-wire device has a unique serial number used to identify the device,
#   usually in the format 28-031674b175ff. This parameter must be provided.
#   Attached 1-wire devices can be listed using the following Linux command:
#   ls /sys/bus/w1/devices/
#ds18_report_time:
#   Interval in seconds between readings. Default is 3.0, with a minimum of 1.0
#sensor_mcu:
#   The micro-controller to read from. Must be the host_mcu
```

## Ventilateurs

### [fan]

Ventilateur de refroidissement de la pièce.

```
[fan]
pin:
#   Broche de sortie contrôlant le ventilateur. Ce paramètre doit être fourni.
#max_power: 1.0
#    La puissance maximale (exprimée en tant que valeur comprise entre 0,0 et 1,0) à laquelle la
#    broche peut être réglée. La valeur 1.0 permet de régler la broche entièrement
#    activée pendant de longues périodes, tandis qu'une valeur de 0,5 permet à la broche
#    de n'être activée que durant la moitié du temps au maximum.
#    Ce paramètre peut être utilisé pour limiter la puissance totale de sortie (sur des périodes prolongées) du ventilateur.
#    Si cette valeur est inférieure à 1,0, les demandes de vitesse du ventilateur
#    seront mises à l'échelle entre zéro et max_power (par exemple, si
#    la puissance maximale est de 0,9 et qu'une vitesse de 80 % est demandée, la puissance du ventilateur sera réglée à 72 %.
#    La valeur par défaut est 1.0.
#shutdown_speed: 0
#    La vitesse souhaitée du ventilateur (exprimée comme une valeur de 0,0 à 1,0) si
#    le logiciel du microcontrôleur entre dans un état d'erreur. La valeur par défaut
#    est 0.
#cycle_time: 0.010
#    La durée (en secondes) de chaque cycle d'alimentation PWM du ventilateur.
#    Il est recommandé que cette durée soit de 10 millisecondes ou plus si vous utilisez un PWM logiciel.
#    La valeur par défaut est de 0,010 seconde.
#hardware_pwm: False
#    Activez ceci pour utiliser le PWM matériel au lieu du PWM logiciel. La plupart des ventilateurs
#    ne fonctionnent pas bien avec le PWM matériel, il n'est donc pas recommandé
#    d'activer cette option à moins qu'il n'y ait une exigence électrique pour obtenir une
#    très haute vitesse. Lorsque vous utilisez le PWM matériel, le temps de cycle réel est
#    contraint par la mise en œuvre et peut être significativement différent du temps de cycle demandé.
#    La valeur par défaut est False.
#kick_start_time: 0.100
#    Durée (en secondes) de fonctionnement du ventilateur à pleine vitesse lorsque, soit lors de sa
#    première activation soit lors d'une augmentation de plus de 50% (pour faire tourner le ventilateur).
#    La valeur par défaut est de 0,100 seconde.
#off_below: 0.0
#    La vitesse d'entrée minimale qui alimentera le ventilateur (exprimée comme une 
#    valeur comprise entre 0,0 et 1,0). Quand une vitesse inférieure à off_below est demandée
#    le ventilateur sera désactivé. 
#    Ce réglage peut être utilisé pour éviter que le ventilateur ne cale et pour garantir que les démarrages sont efficaces.
#    La valeur par défaut est 0.0.
#
#    Ce paramètre doit être recalibré chaque fois que max_power est ajusté.
#    Pour calibrer ce paramètre, commencez avec off_below réglé sur 0.0 et 
#    le ventilateur tourne. Diminuez progressivement la vitesse du ventilateur afin de déterminer la
#    vitesse d'entrée la plus faible entraînant le ventilateur de manière fiable sans décrochage. Réglez
#    off_below au rapport cyclique correspondant à cette valeur (par exemple, 12% -> 0,12) ou légèrement plus.
#tachometer_pin:
#    Broche d'entrée tachymétrique de surveillance de la vitesse du ventilateur. Un pullup est généralement
#    nécessaire. Ce paramètre est facultatif.
#tachometer_ppr: 2
#    Lorsque tachometer_pin est spécifié, il s'agit du nombre d'impulsions par révolution du signal tachymétrique.
#    Pour un ventilateur BLDC, c'est normalement la moitié du nombre de pôles. La valeur par défaut est 2.
#tachometer_poll_interval: 0.0015
#    Lorsque tachometer_pin est spécifié, il s'agit de la période d'interrogation de la broche tachymétrique,
#    en secondes. La valeur par défaut est 0.0015, ce qui est  suffisamment rapide pour des ventilateurs de moins
#    de 10000 RPM à 2 PPR. Cette valeur doit être inférieure à 30/(tachometer_ppr*rpm), avec une certaine marge, 
#   où rpm est la vitesse maximale (en RPM) du ventilateur.
#enable_pin:
#    Broche optionnelle pour activer l'alimentation du ventilateur. Cela peut être utile pour les ventilateurs
#    avec des entrées PWM dédiées. Certains de ces ventilateurs restent allumés même à 0 % de PWM.
#    Dans ce cas, la broche PWM peut être utilisée normalement et, par exemple, un FET commuté à la masse
#   (broche de ventilateur standard) peut être utilisé pour contrôler l'alimentation du ventilateur.
```

### [heater_fan]

Ventilateurs de refroidissement du chauffage (on peut définir un nombre quelconque de sections avec le préfixe "heater_fan"). Un "ventilateur de chauffage" est un ventilateur qui sera activé lorsque le chauffage qui lui est associé est actif. Par défaut, un heater_fan a une vitesse d'arrêt égale à la puissance maximale.

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
#    Si une liste de noms d'éléments chauffants séparés par des virgules est fournie ici,
#    le ventilateur sera activé lorsque l'un des chauffages donnés est activé.
#    La valeur par défaut est "extruder".
#heater_temp: 50.0
#    Température (en Celsius) en dessous de laquelle l'élément chauffant doit descendre pour que le ventilateur soit désactivé.
#    La valeur par défaut est 50 °C.
#fan_speed: 1.0
#    La vitesse du ventilateur (exprimée sous la forme d'une valeur comprise entre 0,0 et 1,0) à laquelle le ventilateur
#    sera réglé lorsque l'élément chauffant qui lui est associé est activé.
#    La valeur par défaut est 1.0
```

### [controller_fan]

Ventilateur de refroidissement du contrôleur (on peut définir un nombre quelconque de sections avec le préfixe "controller_fan"). Un "ventilateur de contrôleur" est un ventilateur qui sera activé chaque fois que l'élément chauffant ou le pilote pas à pas qui lui est associé est actif. Le ventilateur s'arrêtera chaque fois qu'un idle_timeout sera atteint afin de garantir qu'aucune surchauffe ne se produira après la désactivation d'un composant surveillé.

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
#     Voir la section "fan" pour une description des paramètres ci-dessus.
#fan_speed: 1.0
#     Vitesse du ventilateur (exprimée comme une valeur de 0,0 à 1,0) à laquelle celui-ci
#     sera réglé lorsqu'un chauffage ou un pilote pas à pas est actif.
#     La valeur par défaut est 1.0
#idle_timeout:
#      Durée (en secondes) après qu'un pilote pas-à-pas ou un élément chauffant
#      a été actif pour que le ventilateur continue à fonctionner. La valeur par défaut
#      est de 30 secondes.
#idle_speed:
#      Vitesse du ventilateur (exprimée sous la forme d'une valeur comprise entre 0,0 et 1,0) à laquelle
#      le régler lorsqu'une chauffe ou un pilote pas à pas était actif et avant que le délai d'attente
#      idle_timeout ne soit atteint. La valeur par défaut est fan_speed.
#heater:
#stepper :
#      Nom de la section de configuration définissant l'élément chauffant/pilote auquel ce ventilateur
#      est associé. Si une liste séparée par des virgules de noms d'éléments chauffants/pilotes
#      est fournie ici, le ventilateur s'activera lorsque l'un des éléments chauffants/pilotes donnés est activé.
#      Le dispositif de chauffage par défaut est "extruder", le pilote par défaut est chacun d'eux.
```

### [temperature_fan]

Temperature-triggered cooling fans (one may define any number of sections with a "temperature_fan" prefix). A "temperature fan" is a fan that will be enabled whenever its associated sensor is above a set temperature. By default, a temperature_fan has a shutdown_speed equal to max_power.

See the [command reference](G-Codes.md#temperature_fan) for additional information.

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
#   See the "fan" section for a description of the above parameters.
#sensor_type:
#sensor_pin:
#control:
#max_delta:
#min_temp:
#max_temp:
#   See the "extruder" section for a description of the above parameters.
#pid_Kp:
#pid_Ki:
#pid_Kd:
#   The proportional (pid_Kp), integral (pid_Ki), and derivative
#   (pid_Kd) settings for the PID feedback control system. Klipper
#   evaluates the PID settings with the following general formula:
#     fan_pwm = max_power - (Kp*e + Ki*integral(e) - Kd*derivative(e)) / 255
#   Where "e" is "target_temperature - measured_temperature" and
#   "fan_pwm" is the requested fan rate with 0.0 being full off and
#   1.0 being full on. The pid_Kp, pid_Ki, and pid_Kd parameters must
#   be provided when the PID control algorithm is enabled.
#pid_deriv_time: 2.0
#   A time value (in seconds) over which temperature measurements will
#   be smoothed when using the PID control algorithm. This may reduce
#   the impact of measurement noise. The default is 2 seconds.
#target_temp: 40.0
#   A temperature (in Celsius) that will be the target temperature.
#   The default is 40 degrees.
#max_speed: 1.0
#   The fan speed (expressed as a value from 0.0 to 1.0) that the fan
#   will be set to when the sensor temperature exceeds the set value.
#   The default is 1.0.
#min_speed: 0.3
#   The minimum fan speed (expressed as a value from 0.0 to 1.0) that
#   the fan will be set to for PID temperature fans.
#   The default is 0.3.
#gcode_id:
#   If set, the temperature will be reported in M105 queries using the
#   given id. The default is to not report the temperature via M105.
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

Support for LEDs (and LED strips) controlled via micro-controller PWM pins (one may define any number of sections with an "led" prefix). See the [command reference](G-Codes.md#led) for more information.

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

Neopixel (aka WS2812) LED support (one may define any number of sections with a "neopixel" prefix). See the [command reference](G-Codes.md#led) for more information.

Note that the [linux mcu](RPi_microcontroller.md) implementation does not currently support directly connected neopixels. The current design using the Linux kernel interface does not allow this scenario because the kernel GPIO interface is not fast enough to provide the required pulse rates.

```
[neopixel my_neopixel]
pin:
#   The pin connected to the neopixel. This parameter must be
#   provided.
#chain_count:
#   The number of Neopixel chips that are "daisy chained" to the
#   provided pin. The default is 1 (which indicates only a single
#   Neopixel is connected to the pin).
#color_order: GRB
#   Set the pixel order required by the LED hardware (using a string
#   containing the letters R, G, B, W with W optional). Alternatively,
#   this may be a comma separated list of pixel orders - one for each
#   LED in the chain. The default is GRB.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

### [dotstar]

Prise en charge des LED Dotstar (alias APA102) (on peut définir un nombre quelconque de sections avec le préfixe "dotstar"). Voir la [référence de commande](G-Codes.md#led) pour plus d'informations.

```
[dotstar my_dotstar]
data_pin:
#    La broche connectée à la ligne de données du dotstar. Ce paramètre
#    doit être fourni.
clock_pin:
#    La broche connectée à la ligne d'horloge du dotstar. Ce paramètre
#    doit être fourni.
#chain_count:
#    Voir la section "neopixel" pour des informations sur ce paramètre.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#    Voir la section "led" pour des informations sur ces paramètres.
```

### [pca9533]

PCA9533 LED support. The PCA9533 is used on the mightyboard.

```
[pca9533 my_pca9533]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. Use 98 for
#   the PCA9533/1, 99 for the PCA9533/2. The default is 98.
#i2c_mcu:
#i2c_bus:
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

PCA9632 LED support. The PCA9632 is used on the FlashForge Dreamer.

```
[pca9632 my_pca9632]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. This may be
#   96, 97, 98, or 99.  The default is 98.
#i2c_mcu:
#i2c_bus:
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

Servos (one may define any number of sections with a "servo" prefix). The servos may be controlled using the SET_SERVO [g-code command](G-Codes.md#servo). For example: SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
pin:
#   PWM output pin controlling the servo. This parameter must be
#   provided.
#maximum_servo_angle: 180
#   The maximum angle (in degrees) that this servo can be set to. The
#   default is 180 degrees.
#minimum_pulse_width: 0.001
#   The minimum pulse width time (in seconds). This should correspond
#   with an angle of 0 degrees. The default is 0.001 seconds.
#maximum_pulse_width: 0.002
#   The maximum pulse width time (in seconds). This should correspond
#   with an angle of maximum_servo_angle. The default is 0.002
#   seconds.
#initial_angle:
#   Initial angle (in degrees) to set the servo to. The default is to
#   not send any signal at startup.
#initial_pulse_width:
#   Initial pulse width time (in seconds) to set the servo to. (This
#   is only valid if initial_angle is not set.) The default is to not
#   send any signal at startup.
```

### [gcode_button]

Exécute le gcode quand un bouton est pressé ou relâché (ou quand une broche change d'état). Vous pouvez vérifier l'état du bouton en utilisant `QUERY_BUTTON button=my_gcode_button`.

```
[gcode_button my_gcode_button]
pin:
#    La broche sur laquelle le bouton est connecté. Ce paramètre doit être
#    fourni.
#analog_range:
#    Deux résistances séparées par des virgules (en Ohms) spécifiant la plage de résistance minimale
#    et maximale de la résistance du bouton. Si le paramètre analog_range est
#    fourni, la broche doit être une broche à capacité analogique. La valeur par défaut
#    est d'utiliser un gpio numérique pour le bouton.
#analog_pullup_resistor:
#    La résistance d'excursion (en Ohms) lorsque la gamme analogique est spécifiée.
#    La valeur par défaut est 4700 ohms.
#press_gcode:
#    Une liste de commandes G-Code à exécuter lorsque le bouton est pressé.
#    Les modèles G-Code sont pris en charge. Ce paramètre doit être fourni.
#release_gcode:
#    Une liste de commandes G-code à exécuter lorsque le bouton est relâché.
#    Les modèles G-Code sont supportés. La valeur par défaut est de ne pas exécuter de
#    commandes lors du relâchement d'un bouton.
```

### [output_pin]

Run-time configurable output pins (one may define any number of sections with an "output_pin" prefix). Pins configured here will be setup as output pins and one may modify them at run-time using "SET_PIN PIN=my_pin VALUE=.1" type extended [g-code commands](G-Codes.md#output_pin).

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
#static_value:
#   If this is set, then the pin is assigned to this value at startup
#   and the pin can not be changed during runtime. A static pin uses
#   slightly less ram in the micro-controller. The default is to use
#   runtime configuration of pins.
#value:
#   The value to initially set the pin to during MCU configuration.
#   The default is 0 (for low voltage).
#shutdown_value:
#   The value to set the pin to on an MCU shutdown event. The default
#   is 0 (for low voltage).
#maximum_mcu_duration:
#   The maximum duration a non-shutdown value may be driven by the MCU
#   without an acknowledge from the host.
#   If host can not keep up with an update, the MCU will shutdown
#   and set all pins to their respective shutdown values.
#   Default: 0 (disabled)
#   Usual values are around 5 seconds.
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
```

### [static_digital_output]

Statically configured digital output pins (one may define any number of sections with a "static_digital_output" prefix). Pins configured here will be setup as a GPIO output during MCU configuration. They can not be changed at run-time.

```
[static_digital_output my_output_pins]
pins:
#   A comma separated list of pins to be set as GPIO output pins. The
#   pin will be set to a high level unless the pin name is prefaced
#   with "!". This parameter must be provided.
```

### [multi_pin]

Multiple pin outputs (one may define any number of sections with a "multi_pin" prefix). A multi_pin output creates an internal pin alias that can modify multiple output pins each time the alias pin is set. For example, one could define a "[multi_pin my_fan]" object containing two pins and then set "pin=multi_pin:my_fan" in the "[fan]" section - on each fan change both output pins would be updated. These aliases may not be used with stepper motor pins.

```
[multi_pin my_multi_pin]
pins:
#   A comma separated list of pins associated with this alias. This
#   parameter must be provided.
```

## TMC stepper driver configuration

Configuration des pilotes de moteurs pas à pas Trinamic en mode UART/SPI. Des informations supplémentaires sont disponibles dans le [guide des pilotes TMC](TMC_Drivers.md) et dans la [référence des commandes G-codes](G-Codes.md#tmcxxxx).

### [tmc2130]

Configurez un pilote de moteur pas à pas TMC2130 via le bus SPI. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2130" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2130 stepper_x]").

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

Configurez un pilote de moteur pas à pas TMC2208 (ou TMC2224) via un UART à fil unique. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2208" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2208 stepper_x]").

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

Configurez un pilote de moteur pas à pas TMC2209 via un UART à fil unique. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc2209" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2209 stepper_x]").

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
#uart_address:
#   The address of the TMC2209 chip for UART messages (an integer
#   between 0 and 3). This is typically used when multiple TMC2209
#   chips are connected to the same UART pin. The default is zero.
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

Configurer un pilote de moteur pas à pas TMC2660 via le bus SPI. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe tmc2660 suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc2660 stepper_x]").

```
[tmc2660 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2660 chip select line. This pin
#   will be set to low at the start of SPI messages and set to high
#   after the message transfer completes. This parameter must be
#   provided.
#spi_speed: 4000000
#   SPI bus frequency used to communicate with the TMC2660 stepper
#   driver. The default is 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This only works if microsteps
#   is set to 16. Interpolation does introduce a small systemic
#   positional deviation - see TMC_Drivers.md for details. The default
#   is True.
run_current:
#   The amount of current (in amps RMS) used by the driver during
#   stepper movement. This parameter must be provided.
#sense_resistor:
#   The resistance (in ohms) of the motor sense resistor. This
#   parameter must be provided.
#idle_current_percent: 100
#   The percentage of the run_current the stepper driver will be
#   lowered to when the idle timeout expires (you need to set up the
#   timeout using a [idle_timeout] config section). The current will
#   be raised again once the stepper has to move again. Make sure to
#   set this to a high enough value such that the steppers do not lose
#   their position. There is also small delay until the current is
#   raised again, so take this into account when commanding fast moves
#   while the stepper is idling. The default is 100 (no reduction).
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
#   Set the given parameter during the configuration of the TMC2660
#   chip. This may be used to set custom driver parameters. The
#   defaults for each parameter are next to the parameter name in the
#   list above. See the TMC2660 datasheet about what each parameter
#   does and what the restrictions on parameter combinations are. Be
#   especially aware of the CHOPCONF register, where setting CHM to
#   either zero or one will lead to layout changes (the first bit of
#   HDEC) is interpreted as the MSB of HSTRT in this case).
```

### [tmc5160]

Configurer un pilote de moteur pas à pas TMC5160 via le bus SPI. Pour utiliser cette fonctionnalité, définissez une section de configuration avec un préfixe "tmc5160" suivi du nom de la section de configuration du moteur pas à pas correspondant (par exemple, "[tmc5160 stepper_x]").

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

## Run-time stepper motor current configuration

### [ad5206]

Statically configured AD5206 digipots connected via SPI bus (one may define any number of sections with an "ad5206" prefix).

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
#     Ce paramètre peut être utilisé pour modifier l'interprétation des paramètres 'channel_x'.
#     S'il est fourni, alors les paramètres 'channel_x' doivent être compris entre 0.0 et 'scale'. 
#    Cela peut être utile lorsque le AD5206 est utilisé pour définir des références de tension
#    pas à pas. L''échelle' peut être réglée sur l'intensité équivalente de la commande pas à pas
#    si l'AD5206 était à sa résistance la plus élevée, puis les paramètres 'channel_x' peuvent être
#    spécifiés en utilisant la valeur d'intensité désirée pour le pilote pas à pas. La configuration
#    par défaut est de ne pas mettre à l'échelle les paramètres 'channel_x'.
```

### [mcp4451]

Statically configured MCP4451 digipot connected via I2C bus (one may define any number of sections with an "mcp4451" prefix).

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
#   Ceci peut être utile lorsque le MCP4451 est utilisé pour définir des références de tension
#   du pilote pas à pas.L''échelle' peut être réglée sur l'intensité du pilote pas à pas équivalent
#    si le MCP4451 était à sa résistance la plus élevée, puis les paramètres 'wiper_x' peuvent
#    être spécifiés en utilisant la valeur d'intensité désirée pour le pilote pas à pas. La valeur
#    par défaut est de ne pas mettre à l'échelle les paramètres 'wiper_x'.
```

### [mcp4728]

Statically configured MCP4728 digital-to-analog converter connected via I2C bus (one may define any number of sections with an "mcp4728" prefix).

```
[mcp4728 my_dac]
#i2c_address: 96
#   The i2c address that the chip is using on the i2c bus. The default
#   is 96.
#i2c_mcu:
#i2c_bus:
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

Statically configured MCP4018 digipot connected via two gpio "bit banging" pins (one may define any number of sections with an "mcp4018" prefix).

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

Support for a display attached to the micro-controller.

```
[display]
lcd_type:
#    Le type de puce LCD utilisé. Cela peut être "hd44780", "hd44780_spi",
#    "st7920", "emulated_st7920", "uc1701", "ssd1306", ou "sh1106".
#    Voir les sections d'affichage ci-dessous pour plus d'informations sur chaque type et
#    les paramètres supplémentaires qu'ils fournissent. Ce paramètre doit être
#    fourni.
#display_group:
#    Le nom du groupe de données à afficher sur l'écran. Cela
#    contrôle le contenu de l'écran (voir la section "display_data" pour
#    pour plus d'informations). La valeur par défaut est _default_20x4 pour les
#    écrans hd44780 et _default_16x4 pour les autres affichages.
#menu_timeout:
#    Délai d'attente pour le menu. Le fait d'être inactif pendant ce nombre de secondes
#    déclenchera la sortie du menu ou le retour au menu racine si l'autorun est activé.
#    La valeur par défaut est 0 seconde (désactivé)
#menu_root:
#    Nom de la section du menu principal à afficher lorsque vous cliquez sur l'encodeur
#    de l'écran d'accueil. La valeur par défaut est __main, et cela affiche les
#    les menus par défaut tels que définis dans klippy/extras/display/menu.cfg
#menu_reverse_navigation:
#    Lorsque activé, inverse les directions vers le haut et vers le bas de la liste
#     La valeur par défaut est False. Ce paramètre est optionnel.
#encoder_pins:
#    Les broches connectées à l'encodeur. 2 broches doivent être fournies lorsque vous utilisez
#   encoder. Ce paramètre doit être fourni lors de l'utilisation du menu.
#encoder_steps_per_detent:
#    Combien de pas l'encodeur émet par cran ("clic"). Si l'encodeur prend deux crans pour
#    se déplacer entre les entrées ou déplace deux entrées à partir d'un seul cran, essayez de
#   modifier cette valeur. Les valeurs autorisées sont 2 (demi-step) ou 4 (full-step).
#    La valeur par défaut est 4.
#click_pin:
#    La broche connectée au bouton 'enter' ou au 'click' de l'encodeur. Ce paramètre
#    doit être fourni lors de l'utilisation du menu. La présence d'un d'un paramètre de configuration
#    'analog_range_click_pin' fait passer ce paramètre  de numérique à analogique.
#back_pin:
#    La broche connectée au bouton 'back'. Ce paramètre est facultatif, le menu peut être utilisé
#   sans lui. La présence d'un paramètre de configuration 'analog_range_back_pin'  transforme 
#   ce paramètre de numérique à analogique.
#up_pin:
#    La broche connectée au bouton 'up'. Ce paramètre doit être fourni lorsque vous utilisez un
#    menu sans encodeur. La présence d'un paramètre de configuration 'analog_range_up_pin' 
#    transforme ce paramètre de numérique à analogique.
#down_pin:
#     La broche connectée au bouton 'down'. Ce paramètre doit être fourni lorsque vous utilisez un
#    menu sans encodeur. La présence d'un paramètre de configuration 'analog_range_down_pin' 
#    transforme ce paramètre de numérique à analogique.
#kill_pin:
#     La broche connectée au bouton 'kill'. Ce bouton appellera l'arrêt d'urgence. La présence d'un
#     paramètre 'analog_range_kill_pin'  fait passer ce paramètre de numérique à analogique.
#analog_pullup_resistor: 4700
#    La résistance (en ohms) du pullup attaché au bouton analogique.
#    La valeur par défaut est de 4700 ohms.
#analog_range_click_pin:
#    La plage de résistance du bouton 'entrée'. Les valeurs minimale et maximale de la plage
#    séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
#analog_range_back_pin:
#     La plage de résistance du bouton 'retour'. Les valeurs minimale et maximale de la plage
#    séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
#analog_range_up_pin:
#    La plage de résistance du bouton 'up'. Les valeurs minimale et maximale de la plage
#    séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
#analog_range_down_pin:
#    La plage de résistance du bouton 'down'. Les valeurs minimale et maximale de la plage
#    séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
#analog_range_kill_pin:
#    La plage de résistancedu bouton 'kill'. Les valeurs minimale et maximale de la plage
#    séparées par des virgules doivent être fournies lors de l'utilisation du bouton analogique.
```

#### écran hd44780

Informations sur la configuration des écrans hd44780 (utilisés dans les écrans de type "RepRapDiscount 2004 Smart Controller").

```
[display]
lcd_type: hd44780
#      Définir à "hd44780" pour les écrans hd44780.
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#      Broches connectées à un lcd de type hd44780. Ces paramètres doivent
#      être fournis.
#hd44780_protocol_init: True
#      Effectuer l'initialisation du protocole 8-bit/4-bit sur un écran hd44780.
#      Ceci est nécessaire sur les vrais dispositifs hd44780. Cependant, on peut avoir besoin
#      de désactiver ceci sur certains périphériques "clones". La valeur par défaut est True.
#line_length:
#      Définit le nombre de caractères par ligne pour un lcd de type hd44780.
#      Les valeurs possibles sont 20 (par défaut) et 16. Le nombre de lignes est
#      fixé à 4.
...
```

#### écran hd44780_spi

Informations sur la configuration d'un écran hd44780_spi - un écran 20x04 contrôlé par un "shift register" matériel (qui est utilisé dans les imprimantes basées sur mightyboard).

```
[display]
lcd_type: hd44780_spi
#      Définir à "hd44780_spi" pour les écrans hd44780_spi.
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#       Broches connectées au registre à décalage contrôlant l'affichage.
#       La broche spi_software_miso_pin doit être définie sur une broche inutilisée de la carte mère de l'imprimante, 
#       car le registre à décalage contrôlant l'affichage n'a pas de broche MISO, mais l'implémentation logicielle
#      de spi nécessite que cette broche soit configurée.
#hd44780_protocol_init: True
#      Effectue l'initialisation du protocole 8-bit/4-bit sur un écran hd44780.
#      Ceci est nécessaire sur les vrais dispositifs hd44780. Cependant, on peut avoir besoin
#      de désactiver ceci sur certains périphériques "clones". La valeur par défaut est True.
#line_length:
#       Définit le nombre de caractères par ligne pour un lcd de type hd44780.
#       Les valeurs possibles sont 20 (par défaut) et 16. Le nombre de lignes est
#       fixé à 4.
...
```

#### st7920 display

Informations sur la configuration des écrans st7920 (utilisés dans les écrans de type "RepRapDiscount 12864 Full Graphic Smart Controller").

```
[display]
lcd_type: st7920
#   Définir à "st7920" pour les écrans st7920.
cs_pin:
sclk_pin:
sid_pin:
#    Les broches connectées à un lcd de type st7920. Ces paramètres doivent être
#    fournis.
...
```

#### écran émulé_st7920

Informations sur la configuration d'un écran st7920 émulé - que l'on trouve dans certains "écrans tactiles de 2,4 pouces" et similaires.

```
[display]
lcd_type: emulated_st7920
#      Définir à "emulated_st7920" pour les écrans emulated_st7920.
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#       Les broches connectées à un lcd de type emulated_st7920. L'en_pin
#       correspond à la cs_pin du lcd de type st7920,
#       spi_software_sclk_pin correspond à sclk_pin et
#       spi_software_mosi_pin correspond à sid_pin. La broche
#       spi_software_miso_pin doit être réglée sur une broche non utilisée de la
#       carte mère de l'imprimante car le st7920 n'a pas de broche MISO mais l'implémentation
#       logicielle spi nécessite que cette broche soit configurée.
...
```

#### uc1701 display

Informations sur la configuration des écrans uc1701 (utilisés dans les écrans de type "MKS Mini 12864").

```
[display]
lcd_type: uc1701
#    Définir à "uc1701" pour les écrans uc1701.
cs_pin:
a0_pin:
#    Les broches connectées à un lcd de type uc1701. Ces paramètres doivent être
#    fournis.
#rst_pin:
#    La broche connectée à la broche "rst" du lcd. Si elle n'est pas
#    spécifiée, le matériel doit avoir un pull-up sur la ligne lcd correspondante.
#contrast:
#     Le contraste à définir. La valeur peut aller de 0 à 63 , la valeur par
#     par défaut est 40.
...
```

#### ssd1306 and sh1106 displays

Les informations sur la configuration des écrans ssd1306 et sh1106.

```
[display]
lcd_type:
#      Défini à "ssd1306" ou "sh1106" pour le type d'affichage donné.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#      Paramètres optionnels disponibles pour les écrans connectés via un bus i2c
#      Voir la section "Paramètres I2C communs" pour une description des
#      paramètres ci-dessus.
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#      Les broches connectées au lcd en mode spi "4-wire". Voir la
#      la section "paramètres SPI communs" pour une description des paramètres
#      qui commencent par "spi_". Le défaut est d'utiliser le mode i2c pour l'écran
#      d'affichage.
#reset_pin:
#      Une broche de réinitialisation peut être spécifiée sur l'affichage. Si elle n'est pas
#      spécifiée, le matériel doit avoir un pull-up sur la ligne
#      ligne lcd correspondante.
#contrast:
#      Le contraste à définir. La valeur peut aller de 0 à 256 , la valeur par
#      par défaut est 239.
#vcomh: 0
#      Définit la valeur Vcomh sur l'écran. Cette valeur est associée à
#      un effet de "smearing" sur certains écrans OLED. La valeur peut être comprise
#      de 0 à 63. La valeur par défaut est 0.
#invert: False
#      TRUE inverse les pixels sur certains écrans OLED.  La valeur par défaut est
#      False.
#x_offset: 0
#      Définit la valeur du décalage horizontal sur les écrans SH1106. La valeur par
#      défaut est 0.
...
```

### [display_data]

Support for displaying custom data on an lcd screen. One may create any number of display groups and any number of data items under those groups. The display will show all the data items for a given group if the display_group option in the [display] section is set to the given group name.

Un [ensemble par défaut de groupes d'affichage](../klippy/extras/display/display.cfg) est automatiquement créé. On peut remplacer ou étendre ces éléments de données d'affichage en remplaçant les valeurs par défaut dans le fichier de configuration principal printer.cfg.

```
[display_data my_group_name my_data_name]
position:
#      Ligne et colonne séparées par des virgules de la position de l'affichage à
#      utiliser pour afficher l'information. Ce paramètre doit être fourni.
text:
#      Le texte à afficher à la position donnée. Ce champ est évalué en utilisant les
#      modèles de commande (voir docs/Command_Templates.md).
#      Ce paramètre doit être fourni.
```

### [display_template]

Les "macros" de texte des données d'affichage (on peut définir un nombre quelconque de sections avec un préfixe display_template). Voir le document [modèles de commande](Command_Templates.md) pour des informations sur l'évaluation des modèles.

This feature allows one to reduce repetitive definitions in display_data sections. One may use the builtin `render()` function in display_data sections to evaluate a template. For example, if one were to define `[display_template my_template]` then one could use `{ render('my_template') }` in a display_data section.

This feature can also be used for continuous LED updates using the [SET_LED_TEMPLATE](G-Codes.md#set_led_template) command.

```
[display_template my_template_name]
#param_<name>:
#    On peut spécifier un nombre quelconque d'options avec le préfixe "param_". Le nom
#    donné se verra attribuer la valeur donnée (analysée comme un littéral Python)
#    et sera disponible pendant l'expansion de la macro. Si le paramètre
#    est passé dans l'appel à render(), alors cette valeur sera 
#    utilisée pendant l'expansion de la macro. Par exemple, une configuration avec
#    "param_speed = 75" pourrait avoir un appelant avec
#    "render('my_template_name', param_speed=80)". Les noms de paramètres peuvent
#     ne pas utiliser de caractères majuscules.
text:
#    Le texte à renvoyer lors du rendu de ce modèle. Ce champ
#    est évalué à l'aide de modèles de commande (voir
#    docs/Command_Templates.md). Ce paramètre doit être fourni.
```

### [display_glyph]

Affiche un glyphe personnalisé sur les écrans qui le supportent. Le nom donné se verra attribuer les données d'affichage, données qui pourront ensuite être référencées dans les modèles d'affichage par leur nom entouré de deux symboles "tilde", par exemple `~my_display_glyph~`.`

See [sample-glyphs.cfg](../config/sample-glyphs.cfg) for some examples.

```
[display_glyph my_display_glyph]
#data:
#      Les données d'affichage, stockées sous forme de 16 lignes composées de 16 bits (1 par 
#      pixel) où '.' est un pixel vide et '*' est un pixel actif (par ex,
#      "****************" pour afficher une ligne horizontale pleine).
#      On peut également utiliser '0' pour un pixel vide et '1' pour un pixel actif.
#      Placez chaque ligne d'affichage dans une ligne de configuration distincte. Le glyphe
#      doit être composé d'exactement 16 lignes de 16 bits chacune. Ce paramètre
#     est facultatif.
#hd44780_data:
#      Glyphe à utiliser sur les écrans 20x4 hd44780. Le glyphe doit être composé de
#      exactement 8 lignes de 5 bits chacune. Ce paramètre est facultatif.
#hd44780_slot:
#      L'index matériel hd44780 (0..7) pour stocker le glyphe. Si
#      plusieurs images distinctes utilisent le même slot, assurez-vous de n'utiliser
#      qu' une seule de ces images dans un écran donné. Ce paramètre est
#      requis si hd44780_data est spécifié.
```

### [display my_extra_display]

Si une section principale [display] a été définie dans printer.cfg comme indiqué ci-dessus, il est possible de définir plusieurs affichages auxiliaires. Notez que les affichages auxiliaires ne supportent pas actuellement la fonctionnalité de menu, ils ne supportent donc pas les options de "menu" ou la configuration des boutons.

```
[display my_extra_display]
# Voir la section "affichage" (display) pour les paramètres disponibles.
```

### [menu]

Menus de l'écran LCD personnalisables.

Un [ensemble de menus par défaut](../klippy/extras/display/menu.cfg) est automatiquement créé. On peut remplacer ou étendre le menu en remplaçant les valeurs par défaut dans le fichier de configuration principal printer.cfg.

See the [command template document](Command_Templates.md#menu-templates) for information on menu attributes available during template rendering.

```
# Paramètres communs disponibles pour toutes les sections de configuration de menu.
#[menu __some_list __some_name]
#type: disabled
#     Élément de menu désactivé de façon permanente, le seul attribut requis est 'type'.
#     Vous permet de désactiver/masquer facilement les éléments de menu existants.

#[menu some_name]
#type:
#     Un élément parmi commande, entrée, liste, texte :
#         command - élément de menu de base avec divers déclencheurs de script.
#         input - même chose que 'command' mais avec des capacités de changement de valeur.
#                     Pressez pour démarrer/arrêter le mode d'édition.
#         liste - permet de regrouper les éléments du menu dans une liste
#                     liste déroulante. 
#                     Ajoutez à la liste en créant des configurations de menu
#                     en utilisant "some_list" comme préfixe - par
#                     exemple : [menu some_list some_item_in_the_list].
#          vsdlist - identique à 'list' mais ajoutera les fichiers de la carte SD virtuelle
#                     (sera supprimé dans le futur)
#name:
#       Nom de l'élément de menu - évalué comme un modèle.
#enable:
#       Modèle évalué à True ou False.
#index:
#       Position où l'élément doit être inséré dans la liste. Par défaut
#       l'élément est ajouté à la fin.

#[menu some_list]
#type: list
#name:
#enable:
#       Voir ci-dessus pour une description de ces paramètres.

#[menu some_list some_command]
#type: command
#name:
#enable:
#       Voir ci-dessus pour une description de ces paramètres.
#gcode:
#      Script à exécuter lors d'un clic sur un bouton ou un clic long. Évalué comme un
#      modèle.

#[menu some_list some_input]
#type: input
#name:
#enable:
#        Voir ci-dessus pour une description de ces paramètres.
#input:
#       Valeur initiale à utiliser lors de l'édition - évaluée comme un modèle.
#      Le résultat doit être de type flottant.
#input_min:
#       Valeur minimale de la plage - évaluée comme un modèle. Par défaut -99999.
#input_max:
#       Valeur maximale de l'intervalle - évaluée comme un modèle. Par défaut 99999.
#input_step:
#       Pas d'édition - Doit être un nombre entier positif ou une valeur flottante. Il a
#       un pas de vitesse rapide interne. Lorsque "(input_max - input_min) /  input_step > 100"
#       alors le pas de vitesse rapide est 10 * input_step sinon le pas de vitesse rapide
#       est le même que celui de l'input_step.
#realtime:
#       Cet attribut accepte une valeur booléenne statique. Lorsqu'il est activé, alors
#       le script gcode est exécuté après chaque changement de valeur. La valeur par défaut est False.
#gcode:
#       Script à exécuter lors d'un clic sur un bouton, d'un clic long ou d'un changement de valeur.
#       Évalué comme un modèle. Le clic sur le bouton déclenchera le début ou fin du mode d'édition.
```

## Capteurs de filaments

### [filament_switch_sensor]

Capteur de commutation de filament. Prise en charge de la détection de l'insertion et du déplacement du filament à l'aide d'un capteur de commutation, tel qu'un interrupteur de fin de course.

See the [command reference](G-Codes.md#filament_switch_sensor) for more information.

```
[filament_switch_sensor my_sensor]
#pause_on_runout: True
#    Lorsqu'il est défini sur True, une PAUSE sera exécutée immédiatement après qu'un runout
#    est détecté. Notez que si pause_on_runout est False et que le  runout_gcode est omis.
#     la détection du runout est désactivée. Par défaut, est True.
#runout_gcode:
#    Une liste de commandes G-Code à exécuter après la détection d'une fin de filament.
#    Voir docs/Command_Templates.md pour le format G-Code. Si
#    pause_on_runout est réglé sur True, ce G-code sera exécuté après la fin de la
#    PAUSE. Par défaut, aucune commande G-Code n'est exécutée.
#insert_gcode:
#    Une liste de commandes G-Code à exécuter après qu'une insertion de filament soit détectée.
#    Voir docs/Command_Templates.md pour le format G-Code. La valeur par défaut est de n'exécuter
#    aucune commande G-Code, ce qui désactive la détection de l'insertion.
#event_delay  3.0
#    La durée minimale de temps en secondes à attendre entre les événements.
#    Les événements déclenchés pendant cette période seront ignorés silencieusement.
#    La valeur par défaut est de 3 secondes.
#pause_delay: 0.5
#    Le délai, en secondes, entre l'envoi de la commande de pause et l'exécution
#    du runout_gcode. Il peut être utile d'augmenter ce délai si OctoPrint présente un
#    comportement étrange lors de la pause.
#    La valeur par défaut est 0.5 secondes.
#switch_pin:
#    La broche sur laquelle l'interrupteur est connecté. Ce paramètre doit être
#    fourni.
```

### [filament_motion_sensor]

Capteur de mouvement de filament. Prise en charge de la détection de la présence et du déplacement du filament à l'aide d'un encodeur qui fait basculer la broche de sortie pendant le mouvement du filament dans le capteur.

See the [command reference](G-Codes.md#filament_switch_sensor) for more information.

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#    La longueur minimale du filament tiré à travers le capteur pour déclencher
#    un changement d'état sur la broche de commutation
#    La valeur par défaut est 7 mm.
extruder:
#    Le nom de la section de l'extrudeuse à laquelle ce capteur est associé.
#    Ce paramètre doit être fourni.
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#    Voir la section "filament_switch_sensor" pour une description des
#    paramètres ci-dessus.
```

### [tsl1401cl_filament_width_sensor]

TSLl401CL Based Filament Width Sensor. See the [guide](TSL1401CL_Filament_Width_Sensor.md) for more information.

```
[tsl1401cl_filament_width_sensor]
#pin:
#default_nominal_filament_diameter: 1.75 # (mm)
#   Maximum allowed filament diameter difference as mm.
#max_difference: 0.2
#   The distance from sensor to the melting chamber as mm.
#measurement_delay: 100
```

### [hall_filament_width_sensor]

Capteur de largeur de filament Hall (voir [Capteur de largeur de filament Hall](Hall_Filament_Width_Sensor.md)).

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
#     Le diamètre nominal du filament. Ce paramètre doit être fourni.
#max_difference: 0.200
#    Différence maximale autorisée de diamètre du filament en millimètres (mm).
#    Si la différence entre le diamètre nominal du filament et la sortie du capteur
#    est supérieure à +- max_différence, le multiplicateur d'extrusion est ramené à
#    à %100. La valeur par défaut est de 0,200.
#measurement_delay: 70
#    La distance entre le capteur et la chambre de fusion/la buse en
#    millimètres (mm). Le filament situé entre le capteur et la buse
#    sera traité comme le diamètre_nominal_du_filament_par défaut.
#    Ce module hôte fonctionne avec une logique FIFO. Il conserve chaque valeur de capteur
#    dans un tableau et les remet (POP) dans la bonne position. Ce paramètre
#    doit être fourni.
#enable: False
#    Capteur activé ou désactivé après la mise sous tension. La valeur par défaut est
#    désactivé.
#measurement_interval: 10
#    La distance approximative (en mm) entre les lectures du capteur. La valeur
#    par défaut est de 10mm.
#logging: False
#    Le diamètre de sortie vers le terminal et vers klipper.log peut être activé par la
#    commande.
#min_diameter: 1.0
#    Diamètre minimal pour déclencher le capteur virtuel filament_switch_sensor.
#use_current_dia_while_delay: False
#    Utiliser le diamètre actuel au lieu du diamètre nominal pendant que
#    le délai de mesure n'est pas écoulé.
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

Configurez un expandeur SX1509 I2C vers GPIO. En raison du délai encouru par la communication I2C, vous ne devez PAS utiliser les broches du SX1509 comme broches d'activation de pas, de pas ou de direction ou toute autre broche nécessitant un changement de bit rapide. Il est préférable de les utiliser comme sorties numériques statiques ou contrôlées par gcode ou comme broches hardware-pwm pour les ventilateurs par exemple. On peut définir un nombre quelconque de sections avec un préfixe "sx1509". Chaque expandeur fournit un ensemble de 16 broches (sx1509_my_sx1509:PIN_0 à sx1509_my_sx1509:PIN_15) qui peuvent être utilisées dans la configuration de l'imprimante.

See the [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg) file for an example.

```
[sx1509 my_sx1509]
i2c_address:
#   I2C address used by this expander. Depending on the hardware
#   jumpers this is one out of the following addresses: 62 63 112
#   113. This parameter must be provided.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#i2c_bus:
#   If the I2C implementation of your micro-controller supports
#   multiple I2C busses, you may specify the bus name here. The
#   default is to use the default micro-controller i2c bus.
```

### [samd_sercom]

SAMD SERCOM configuration to specify which pins to use on a given SERCOM. One may define any number of sections with a "samd_sercom" prefix. Each SERCOM must be configured prior to using it as SPI or I2C peripheral. Place this config section above any other section that makes use of SPI or I2C buses.

```
[samd_sercom my_sercom]
sercom:
#   The name of the sercom bus to configure in the micro-controller.
#   Available names are "sercom0", "sercom1", etc.. This parameter
#   must be provided.
tx_pin:
#   MOSI pin for SPI communication, or SDA (data) pin for I2C
#   communication. The pin must have a valid pinmux configuration
#   for the given SERCOM peripheral. This parameter must be provided.
#rx_pin:
#   MISO pin for SPI communication. This pin is not used for I2C
#   communication (I2C uses tx_pin for both sending and receiving).
#   The pin must have a valid pinmux configuration for the given
#   SERCOM peripheral. This parameter is optional.
clk_pin:
#   CLK pin for SPI communication, or SCL (clock) pin for I2C
#   communication. The pin must have a valid pinmux configuration
#   for the given SERCOM peripheral. This parameter must be provided.
```

### [adc_scaled]

Mise à l'échelle analogique du Duet2 Maestro par les lectures vref et vssa. Définir une section adc_scaled permet d'activer des broches adc virtuelles (telles que "my_name:PB0") qui seront automatiquement ajustées par les broches de surveillance vref et vssa de la carte. Assurez-vous de définir cette section de configuration au-dessus de toute section de configuration utilisant l'une de ces broches virtuelles.

See the [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg) file for an example.

```
[adc_scaled my_name]
vref_pin :
#    La broche ADC à utiliser pour le contrôle de VREF. Ce paramètre doit être
#    fourni.
vssa_pin :
#    La broche ADC à utiliser pour la surveillance VSSA. Ce paramètre doit être
#    fourni.
#smooth_time : 2.0
#    Une durée (en secondes) sur laquelle les mesures de vref et vssa
#    seront lissées pour réduire l'impact du bruit des mesures.
#    La valeur par défaut est de 2 secondes.
```

### [replicape]

Replicape support - see the [beaglebone guide](Beaglebone.md) and the [generic-replicape.cfg](../config/generic-replicape.cfg) file for an example.

```
# The "replicape" config section adds "replicape:stepper_x_enable"
# virtual stepper enable pins (for steppers X, Y, Z, E, and H) and
# "replicape:power_x" PWM output pins (for hotbed, e, h, fan0, fan1,
# fan2, and fan3) that may then be used elsewhere in the config file.
[replicape]
revision:
#   The replicape hardware revision. Currently only revision "B3" is
#   supported. This parameter must be provided.
#enable_pin: !gpio0_20
#   The replicape global enable pin. The default is !gpio0_20 (aka
#   P9_41).
host_mcu:
#   The name of the mcu config section that communicates with the
#   Klipper "linux process" mcu instance. This parameter must be
#   provided.
#standstill_power_down: False
#   This parameter controls the CFG6_ENN line on all stepper
#   motors. True sets the enable lines to "open". The default is
#   False.
#stepper_x_microstep_mode:
#stepper_y_microstep_mode:
#stepper_z_microstep_mode:
#stepper_e_microstep_mode:
#stepper_h_microstep_mode:
#   This parameter controls the CFG1 and CFG2 pins of the given
#   stepper motor driver. Available options are: disable, 1, 2,
#   spread2, 4, 16, spread4, spread16, stealth4, and stealth16. The
#   default is disable.
#stepper_x_current:
#stepper_y_current:
#stepper_z_current:
#stepper_e_current:
#stepper_h_current:
#   The configured maximum current (in Amps) of the stepper motor
#   driver. This parameter must be provided if the stepper is not in a
#   disable mode.
#stepper_x_chopper_off_time_high:
#stepper_y_chopper_off_time_high:
#stepper_z_chopper_off_time_high:
#stepper_e_chopper_off_time_high:
#stepper_h_chopper_off_time_high:
#   This parameter controls the CFG0 pin of the stepper motor driver
#   (True sets CFG0 high, False sets it low). The default is False.
#stepper_x_chopper_hysteresis_high:
#stepper_y_chopper_hysteresis_high:
#stepper_z_chopper_hysteresis_high:
#stepper_e_chopper_hysteresis_high:
#stepper_h_chopper_hysteresis_high:
#   This parameter controls the CFG4 pin of the stepper motor driver
#   (True sets CFG4 high, False sets it low). The default is False.
#stepper_x_chopper_blank_time_high:
#stepper_y_chopper_blank_time_high:
#stepper_z_chopper_blank_time_high:
#stepper_e_chopper_blank_time_high:
#stepper_h_chopper_blank_time_high:
#   This parameter controls the CFG5 pin of the stepper motor driver
#   (True sets CFG5 high, False sets it low). The default is True.
```

## Other Custom Modules

### [palette2]

Palette 2 multimaterial support - provides a tighter integration supporting Palette 2 devices in connected mode.

This modules also requires `[virtual_sdcard]` and `[pause_resume]` for full functionality.

Si vous utilisez ce module, n'utilisez pas le plugin Palette 2 pour Octoprint car ils entreront en conflit, et le module 1 ne pourra pas s'initialiser correctement, ce qui pourrait faire échouer votre impression.

Si vous utilisez Octoprint et que vous diffusez du gcode sur le port série au lieu d'imprimer à partir de virtual_sd, alors supprimez **M1** et **M0** de *Commandes de pause* dans *Paramètres > Connexion série > Firmware & protocole* pour éviter de devoir lancer l'impression sur la Palette 2 et de devoir lever la pause dans Octoprint pour que l'impression commence.

```
[palette2]
serial:
#   The serial port to connect to the Palette 2.
#baud: 115200
#   The baud rate to use. The default is 115200.
#feedrate_splice: 0.8
#   The feedrate to use when splicing, default is 0.8
#feedrate_normal: 1.0
#   The feedrate to use after splicing, default is 1.0
#auto_load_speed: 2
#   Extrude feedrate when autoloading, default is 2 (mm/s)
#auto_cancel_variation: 0.1
#   Auto cancel print when ping varation is above this threshold
```

### [angle]

Prise en charge du capteur d'angle Hall magnétique pour la lecture des mesures de l'angle de l'arbre du moteur pas à pas à l'aide des puces SPI a1333, as5047d ou tle5012b. Les mesures sont disponibles via le [serveur API](API_Server.md) et l'[outil d'analyse de mouvement](Debugging.md#motion-analysis-and-data-logging). Voir la [référence G-Code](G-Codes.md#angle) pour les commandes disponibles.

```
[angle my_angle_sensor]
sensor_type:
#     Le type de la puce du capteur magnétique à effet Hall. Les choix disponibles sont
#     "a1333", "as5047d" et "tle5012b". Ce paramètre doit être
#      spécifié.
#sample_period: 0.000400
#      La période d'interrogation (en secondes) à utiliser pendant les mesures. La valeur
#      par défaut est de 0.000400 (ce qui correspond à 2500 échantillons par seconde).
#stepper:
#      Le nom du pilote moteur pas à pas auquel le capteur d'angle est attaché (ex,
#     "stepper_x"). La définition de cette valeur active un étalonnage d'angle.
#      Pour utiliser cette fonction, le paquet Python "numpy" doit être installé.
#      Par défaut, l'étalonnage angulaire n'est pas activé pour le capteur angulaire.
cs_pin:
#     La broche d'activation SPI du capteur. Ce paramètre doit être fourni.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#     Voir la section "paramètres SPI communs" pour une description des
#     paramètres ci-dessus.
```

## Paramètres communs aux bus

### Paramètres SPI communs

The following parameters are generally available for devices using an SPI bus.

```
#spi_speed:
#   The SPI speed (in hz) to use when communicating with the device.
#   The default depends on the type of device.
#spi_bus:
#   If the micro-controller supports multiple SPI busses then one may
#   specify the micro-controller bus name here. The default depends on
#   the type of micro-controller.
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Specify the above parameters to use "software based SPI". This
#   mode does not require micro-controller hardware support (typically
#   any general purpose pins may be used). The default is to not use
#   "software spi".
```

### Paramètres I2C communs

The following parameters are generally available for devices using an I2C bus.

Note that Klipper's current micro-controller support for i2c is generally not tolerant to line noise. Unexpected errors on the i2c wires may result in Klipper raising a run-time error. Klipper's support for error recovery varies between each micro-controller type. It is generally recommended to only use i2c devices that are on the same printed circuit board as the micro-controller.

Most Klipper micro-controller implementations only support an `i2c_speed` of 100000. The Klipper "linux" micro-controller supports a 400000 speed, but it must be [set in the operating system](RPi_microcontroller.md#optional-enabling-i2c) and the `i2c_speed` parameter is otherwise ignored. The Klipper "rp2040" micro-controller supports a rate of 400000 via the `i2c_speed` parameter. All other Klipper micro-controllers use a 100000 rate and ignore the `i2c_speed` parameter.

```
#i2c_address:
#    L'adresse i2c du périphérique. Elle doit être spécifiée sous la forme d'un nombre décimal
#   (pas en hexadécimal). La valeur par défaut dépend du type de périphérique.
#i2c_mcu:
#    Le nom du micro-contrôleur auquel la puce est connectée.
#    La valeur par défaut est "mcu".
#i2c_bus:
#    Si le micro-contrôleur supporte plusieurs bus I2C, on peut spécifier le bus du micro-contrôleur.
#    La valeur par défaut dépend du type de micro-contrôleur.
#i2c_speed:
#    La vitesse I2C (en Hz) à utiliser lors de la communication avec le périphérique.
#    L'implémentation de Klipper sur la plupart des micro-contrôleurs est codée en dur à 100000.
#    et changer cette valeur n'a aucun effet. La valeur par défaut est 100000.
```
