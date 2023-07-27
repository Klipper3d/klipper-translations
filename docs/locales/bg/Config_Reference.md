# Справка за конфигурацията

This document is a reference for options available in the Klipper config file.

The descriptions in this document are formatted so that it is possible to cut-and-paste them into a printer config file. See the [installation document](Installation.md) for information on setting up Klipper and choosing an initial config file.

## Micro-controller configuration

### Формат на имената на пиновете на микроконтролера

Many config options require the name of a micro-controller pin. Klipper uses the hardware names for these pins - for example `PA4`.

Pin names may be preceded by `!` to indicate that a reverse polarity should be used (eg, trigger on low instead of high).

Входните пинове могат да бъдат предшествани от `^`, за да се укаже, че за пина трябва да се включи хардуерен издърпващ резистор. Ако микроконтролерът поддържа издърпващи резистори, тогава входният щифт може да бъде предшестван от `~`.

Note, some config sections may "create" additional pins. Where this occurs, the config section defining the pins must be listed in the config file before any sections using those pins.

### [mcu]

Конфигуриране на основния микроконтролер.

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

Допълнителни микроконтролери (могат да се дефинират произволен брой секции с префикс "mcu"). Допълнителните микроконтролери въвеждат допълнителни изводи, които могат да бъдат конфигурирани като нагреватели, стъпкови устройства, вентилатори и др. Например, ако е въведена секция "[mcu extra_mcu]", тогава изводи като "extra_mcu:ar9" могат да се използват на други места в конфигурацията (където "ar9" е хардуерно име на извод или псевдоним на дадения микроконтролер).

```
[mcu my_extra_mcu]
# See the "mcu" section for configuration parameters.
```

## Общи кинематични настройки

### [printer]

The printer section controls high level printer settings.

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

Stepper motor definitions. Different printer types (as specified by the "kinematics" option in the [printer] config section) require different names for the stepper (eg, `stepper_x` vs `stepper_a`). Below are common stepper definitions.

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

### Cartesian Kinematics

See [example-cartesian.cfg](../config/example-cartesian.cfg) for an example cartesian kinematics config file.

Only parameters specific to cartesian printers are described here - see [common kinematic settings](#common-kinematic-settings) for available parameters.

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

### Линейна делта кинематика

See [example-delta.cfg](../config/example-delta.cfg) for an example linear delta kinematics config file. See the [delta calibrate guide](Delta_Calibrate.md) for information on calibration.

Only parameters specific to linear delta printers are described here - see [common kinematic settings](#common-kinematic-settings) for available parameters.

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

### Deltesian Kinematics

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
#   intended to restrict the arms from becoming completely horizontal,
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

# The stepper_right section is used to describe the stepper controlling the
# right tower.
[stepper_right]

# The stepper_y section is used to describe the stepper controlling
# the Y axis in a deltesian robot.
[stepper_y]
```

### CoreXY Kinematics

See [example-corexy.cfg](../config/example-corexy.cfg) for an example corexy (and h-bot) kinematics file.

Only parameters specific to corexy printers are described here - see [common kinematic settings](#common-kinematic-settings) for available parameters.

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

### CoreXZ Kinematics

See [example-corexz.cfg](../config/example-corexz.cfg) for an example corexz kinematics config file.

Only parameters specific to corexz printers are described here - see [common kinematic settings](#common-kinematic-settings) for available parameters.

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

### Hybrid-CoreXY Kinematics

See [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg) for an example hybrid corexy kinematics config file.

This kinematic is also known as Markforged kinematic.

Only parameters specific to hybrid corexy printers are described here see [common kinematic settings](#common-kinematic-settings) for available parameters.

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

### Hybrid-CoreXZ Kinematics

See [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg) for an example hybrid corexz kinematics config file.

This kinematic is also known as Markforged kinematic.

Only parameters specific to hybrid corexy printers are described here see [common kinematic settings](#common-kinematic-settings) for available parameters.

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

### Polar Kinematics

See [example-polar.cfg](../config/example-polar.cfg) for an example polar kinematics config file.

Only parameters specific to polar printers are described here - see [common kinematic settings](#common-kinematic-settings) for available parameters.

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

### Rotary delta Kinematics

See [example-rotary-delta.cfg](../config/example-rotary-delta.cfg) for an example rotary delta kinematics config file.

Only parameters specific to rotary delta printers are described here - see [common kinematic settings](#common-kinematic-settings) for available parameters.

ROTARY DELTA KINEMATICS ARE A WORK IN PROGRESS. Homing moves may timeout and some boundary checks are not implemented.

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

### Кинематика на кабелната лебедка

See the [example-winch.cfg](../config/example-winch.cfg) for an example cable winch kinematics config file.

Only parameters specific to cable winch printers are described here - see [common kinematic settings](#common-kinematic-settings) for available parameters.

ОПОРАТА НА КАБЕЛНАТА ЛЕБЕДКА Е ЕКСПЕРИМЕНТАЛНА. Навигацията не е реализирана в кинематиката на кабелната лебедка. За да хомеографирате принтера, изпращайте ръчно команди за движение, докато главата на инструмента се намира на 0, 0, 0, и след това издайте команда `G28`.

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

### None Kinematics

Възможно е да се дефинира специална кинематика "няма", за да се деактивира кинематичната поддръжка в Klipper. Това може да е полезно за управление на устройства, които не са типични 3d-принтери, или за целите на отстраняване на грешки.

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   The max_velocity and max_accel parameters must be defined. The
#   values are not used for "none" kinematics.
```

## Обща поддръжка на екструдера и отопляемото легло

### [extruder]

The extruder section is used to describe the heater parameters for the nozzle hotend along with the stepper controlling the extruder. See the [command reference](G-Codes.md#extruder) for additional information. See the [pressure advance guide](Pressure_Advance.md) for information on tuning pressure advance.

```
[екструдер]
step_pin:
dir_pin:
enable_pin:
микросистеми:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
# Вижте раздела "стъпка" за описание на горното
# параметри. Ако нито един от горните параметри не е указан тогава няма
# стъпка ще бъде свързана с накрайника hotend (макар че
# SYNC_EXTRUDER_MOTION команда може да асоциира такава по време на изпълнение).
nozzle_diameter:
# Диаметър на дюзата orifice (в мм). Този параметър трябва да бъде
# при условие.
filament_diameter:
# Номиналният диаметър на суровата филамент (в мм), докато влиза в
# екструдер. Този параметър трябва да бъде предоставен.
#max_extrude_cross_section:
# Максимална площ (в mm^2) на екструдиращо напречно сечение (напр,
# екструзия ширина умножена по височина на слоя). Тази настройка предотвратява
# прекомерни количества екструзия по време на сравнително малки XY ходове.
# Ако даден ход поиска степен на екструзия, която би надхвърлила тази стойност
# тя ще доведе до грешка, за да бъдат върнати. По подразбиране е: 4,0 *
# nozzle_diameter^2
#instantaneous_corner_velocity: 1.000
# Максималната моментна промяна на скоростта (в mm/s) на
# екструдер по време на кръстовищата на два хода. По подразбиране е 1mm/s.
#max_extrude_only_distance: 50.0
# Максимална дължина (в мм сурова нишки), че прибиране или
# движение само с екструда може да има. Ако се движи само за прибиране или екструда
# иска разстояние, по-голямо от тази стойност тя ще предизвика грешка
# да бъдат върнати. По подразбиране е 50mm.
#max_extrude_only_velocity:
#max_extrude_only_accel:
# Максимална скорост (в mm/s) и ускорение (в mm/s^2) на
# екструдер мотор за прибирания и екструд-само ходове. Тези
# настройките нямат никакво влияние върху нормалните печатни ходове. Ако не
# посочени тогава те се изчисляват, за да съответстват на ограничението xY
# печат ход с напречно сечение от 4.0*nozzle_diameter^2 би
# има.
#pressure_advance: 0.0
# Количеството сурова филамент да прокара в екструдера по време на
# екструдерно ускорение. Прибрано е равно количество нажежа-
# по време на отрицателното ускорение. Измерва се в милиметри на
# милиметър / секунда. По подразбиране е 0, което забранява налягането
# аванс.
#pressure_advance_smooth_time: 0.040
# Времеви диапазон (в секунди), който да се използва при изчисляване на средната
# скорост на екструдера за предварително налягане. По-голяма стойност води до
# по-гладки екструдерни движения. Този параметър не може да надвишава 200ms.
# Тази настройка важи само ако pressure_advance не е нула. The
# по подразбиране е 0.040 (40 милисекунди).
#
# Останалите променливи описват екструдерния нагревател.
heater_pin:
# PWM изходен щифт, контролиращ нагревателя. Този параметър трябва да бъде
# при условие.
#max_power: 1.0
# Максималната мощност (изразена като стойност от 0,0 до 1,0), която
# heater_pin може да е настроен. Стойността 1.0 позволява щифтът да бъде зададен
# напълно активирана за удължени периоди, докато стойност 0,5 би
# позволи на щифта да бъде активиран за не повече от половината време. Този
# настройката може да се използва за ограничаване на общата мощност (над разширена
# периоди) до нагревателя. По подразбиране е 1.0.
sensor_type:
# Тип сензор - общи термисти са "EPCOS 100K B57560G104F",
# "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Генерични
# 3950","Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
# "SliceEngineering 450", и "TDK NTCG104LH104JT1". Вижте
# "Температурни сензори" раздел за други сензори. Този параметър
# трябва да се осигури.
sensor_pin:
# Аналогов входен щифт, свързан към сензора. Този параметър трябва да бъде
# при условие.
#pullup_resistor: 4700
# Съпротивлението (в омове) на придърпката, прикрепена към термистора.
# Този параметър е валиден само когато сензорът е термистор. The
# по подразбиране е 4700 ома.
#smooth_time: 1.0
# Стойност на времето (за секунди), над която измерванията на температурата ще
# бъдете изгладени, за да намалите въздействието на шума от измерването. По подразбиране
# е 1 секунди.
контролирам:
# Контролен алгоритъм (или pid или воден знак). Този параметър трябва да
# да бъдат предоставени.
pid_Kp:
pid_Ki:
pid_Kd:
# Пропорционалните (pid_Kp), интегралните (pid_Ki), и производните
# (pid_Kd) настройки за pid системата за контрол на обратната връзка. Клиппър
# оценява настройките на PID със следната обща формула:
# heater_pwm = (Kp*грешка + Ki*неразделна(грешка) - Kd *производно(грешка)) / 255
# Където "грешка" е "requested_temperature - measured_temperature"
# и "heater_pwm" е исканата скорост на отопление с 0.0 е пълна
# изключен и 1.0 е пълен на. Помислете дали да използвате PID_CALIBRATE
# команда, за да получите тези параметри. Pid_Kp, pid_Ki и pid_Kd
# параметри трябва да бъдат предвидени за PID нагреватели.
#max_delta: 2.0
# На 'воден знак' контролирани нагреватели това е броят на градусите в
# Целзий над целевата температура, преди да деактивирате нагревателя
# както и броя на градусите под целта преди
# повторно разрешаване на нагревателя. По подразбиране е 2 градуса по Целзий.
#pwm_cycle_time: 0.100
# Време за секунди за всеки софтуер PWM цикъл на нагревателя. То е
```

### [heater_bed]

The heater_bed section describes a heated bed. It uses the same heater settings described in the "extruder" section.

```
[heater_bed]
heater_pin:
sensor_type:
sensor_pin:
control:
min_temp:
max_temp:
#   See the "extruder" section for a description of the above parameters.
```

## Поддръжка на нивото на леглото

### [bed_mesh]

Mesh Bed Leveling. One may define a bed_mesh config section to enable move transformations that offset the z axis based on a mesh generated from probed points. When using a probe to home the z-axis, it is recommended to define a safe_z_home section in printer.cfg to home toward the center of the print area.

See the [bed mesh guide](Bed_Mesh.md) and [command reference](G-Codes.md#bed_mesh) for additional information.

Visual Examples:

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
#relative_reference_index:
#   **DEPRECATED, use the "zero_reference_position" option**
#   The legacy option superceded by the "zero reference position".
#   Rather than a coordinate this option takes an integer "index" that
#   refers to the location of one of the generated points. It is recommended
#   to use the "zero_reference_position" instead of this option for new
#   configurations. The default is no relative reference index.
#faulty_region_1_min:
#faulty_region_1_max:
#   Optional points that define a faulty region.  See docs/Bed_Mesh.md
#   for details on faulty regions.  Up to 99 faulty regions may be added.
#   By default no faulty regions are set.
```

### [bed_tilt]

Компенсация на наклона на леглото. Може да се дефинира конфигурационен раздел bed_tilt, за да се активират трансформациите на движенията, които отчитат наклоненото легло. Обърнете внимание, че bed_mesh и bed_tilt са несъвместими; и двете не могат да бъдат дефинирани.

See the [command reference](G-Codes.md#bed_tilt) for additional information.

```
[bed_tilt]
#x_adjust: 0
# Сумата, която се добавя към височината Z на всеки ход за всеки мм от X
# по оста. По подразбиране е 0.
#y_adjust: 0
# Сумата, която се добавя към височината Z на всеки ход за всеки мм по оста Y
# по оста Y. По подразбиране е 0.
#z_adjust: 0
# Сумата, която се добавя към височината Z, когато дюзата е номинално на
# 0, 0. По подразбиране е 0.
# Останалите параметри управляват разширената BED_TILT_CALIBRATE
# g-код команда, която може да се използва за калибриране на съответните x и y
# параметрите за регулиране.
#точки:
# Списък с координати X, Y (по една на ред; следващите редове
# с отстъп), които трябва да бъдат изследвани по време на BED_TILT_CALIBRATE
# команда. Посочете координатите на дюзата и се уверете, че сондата
# е над леглото при зададените координати на дюзата. По подразбиране е
# да не се активира командата.
#скорост: 50
# Скоростта (в мм/сек) на движенията, които не са свързани със сондиране, по време на калибрирането.
# По подразбиране е 50.
#horizontal_move_z: 5
# Височината (в мм), до която трябва да се командва главата да се премести
# непосредствено преди започване на работа със сондата. По подразбиране е 5.
```

### [винтове за легло]

Tool to help adjust bed leveling screws. One may define a [bed_screws] config section to enable a BED_SCREWS_ADJUST g-code command.

See the [leveling guide](Manual_Level.md#adjusting-bed-leveling-screws) and [command reference](G-Codes.md#bed_screws) for additional information.

```
[bed_screws]
#screw1:
# Координатите X, Y на първия винт за изравняване на леглото. Това е
# позиция, в която да се командва дюзата, която е директно над леглото
# винта (или възможно най-близо до него, като все още е над леглото).
# Този параметър трябва да се предостави.
#име на винта1:
# Произволно име за дадения винт. Това име се показва, когато
# помощният скрипт се изпълнява. По подразбиране се използва име, базирано на
# местоположението на винта по XY.
#screw1_fine_adjust:
# Координати X, Y, към които да се командва дюзата, за да може да се прецизира
# да се регулира винтът за изравняване на леглото. По подразбиране не се извършва фина
# регулирането на винта на леглото.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
# Допълнителни винтове за нивелиране на леглото. Трябва да бъдат поставени поне три винта
# дефинирани.
#horizontal_move_z: 5
# Височината (в мм), на която трябва да се командва главата да се движи
# при преместване от едно място на винта към следващото. По подразбиране е 5.
#probe_height: 0
# Височината на сондата (в мм) след коригиране за термичната
# разширение на леглото и дюзата. По подразбиране е нула.
#speed: 50
# Скоростта (в мм/сек) на движенията, които не са свързани с пробовземане, по време на калибрирането.
# По подразбиране е 50.
#probe_speed: 5
# Скоростта (в мм/сек) при преместване от хоризонтална позиция_move_z
# до позиция probe_height. По подразбиране е 5.
```

### [screws_tilt_adjust]

Tool to help adjust bed screws tilt using Z probe. One may define a screws_tilt_adjust config section to enable a SCREWS_TILT_CALCULATE g-code command.

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
#   The type of screw used for bed leveling, M3, M4, or M5, and the
#   rotation direction of the knob that is used to level the bed.
#   Accepted values: CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
#   Default value is CW-M3 which most printers use. A clockwise
#   rotation of the knob decreases the gap between the nozzle and the
#   bed. Conversely, a counter-clockwise rotation increases the gap.
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

Moving gantry leveling using 4 independently controlled Z motors. Corrects hyperbolic parabola effects (potato chip) on moving gantry which is more flexible. WARNING: Using this on a moving bed may lead to undesirable results. If this section is present then a QUAD_GANTRY_LEVEL extended G-Code command becomes available. This routine assumes the following Z motor configuration:

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

## Персонализирано насочване

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

Отмяна на насочването. Този механизъм може да се използва за изпълнение на серия от g-code команди вместо G28, намиращ се в нормалния g-code вход. Това може да бъде полезно за принтери, които изискват специфична процедура за настройване на машината.

```
[homing_override]
gcode:
#   A list of G-Code commands to execute in place of G28 commands
#   found in the normal g-code input. See docs/Command_Templates.md
#   for G-Code format. If a G28 is contained in this list of commands
#   then it will invoke the normal homing procedure for the printer.
#   The commands listed here must home all axes. This parameter must
#   be provided.
#axes: xyz
#   The axes to override. For example, if this is set to "z" then the
#   override script will only be run when the z axis is homed (eg, via
#   a "G28" or "G28 Z0" command). Note, the override script should
#   still home all axes. The default is "xyz" which causes the
#   override script to be run in place of all G28 commands.
#set_position_x:
#set_position_y:
#set_position_z:
#   If specified, the printer will assume the axis is at the specified
#   position prior to running the above g-code commands. Setting this
#   disables homing checks for that axis. This may be useful if the
#   head must move prior to invoking the normal G28 mechanism for an
#   axis. The default is to not force a position for an axis.
```

### [endstop_phase]

Stepper phase adjusted endstops. To use this feature, define a config section with an "endstop_phase" prefix followed by the name of the corresponding stepper config section (for example, "[endstop_phase stepper_z]"). This feature can improve the accuracy of endstop switches. Add a bare "[endstop_phase]" declaration to enable the ENDSTOP_PHASE_CALIBRATE command.

See the [endstop phases guide](Endstop_Phase.md) and [command reference](G-Codes.md#endstop_phase) for additional information.

```
[endstop_phase stepper_z]
# endstop_accuracy:
# Задава очакваната точност (в мм) на крайния ограничител. Това представлява
# максималното разстояние на грешка, което крайният ограничител може да задейства (например, ако
# крайният ограничител може понякога да се задейства 100um по-рано или до 100um по-късно
# тогава задайте 0,200 за 200um). По подразбиране е
# 4*разстояние на завъртане/пълни стъпки на завъртане.
#trigger_phase:
# Това определя фазата на драйвера на стъпковия двигател, която да се очаква
# при натискане на крайния ограничител. Тя се състои от две числа, разделени
# с наклонена черта напред - фазата и общия брой
# фази (например "7/64"). Задайте тази стойност само ако сте сигурни, че
# драйверът на стъпковия двигател се нулира всеки път, когато се нулира микропроцесорът. Ако това
# не е зададена, тогава фазата на стъпковия механизъм ще бъде разпозната при първото
# и тази фаза ще се използва при всички следващи връщания.
#endstop_align_zero: False
# Ако е вярно, то позицията_endstop на оста ще бъде ефективно
# модифициран така, че нулевата позиция на оста да се извършва при пълна
# стъпка на стъпковия двигател. (Ако се използва за ос Z и печат
# височината на слоя е кратна на разстоянието на пълната стъпка, тогава всеки
# слой ще се появи на пълна стъпка.) По подразбиране е False (Невярно).
```

## G-Code макроси и събития

### [gcode_macro]

макроси на G-Code (могат да се дефинират произволен брой секции с префикс "gcode_macro"). За повече информация вижте [Ръководство за шаблони на команди](Command_Templates.md).

```
[gcode_macro my_cmd]
#gcode:
# Списък с G-Code команди, които да се изпълняват вместо "my_cmd". Вижте
# docs/Command_Templates.md за формата на G-Code. Този параметър трябва да
# да бъде предоставен.
#variable_<name>:
# Може да се посочат произволен брой опции с префикс "variable_".
# На даденото име на променлива ще бъде присвоена дадената стойност (анализирана
# като Python литерал) и ще бъде достъпна по време на разширяването на макроса.
# Например конфигурация с "variable_fan_speed = 75" може да има
# gcode команди, съдържащи "M106 S{ fan_speed * 255 }". Променливи
# могат да бъдат променяни по време на изпълнение с помощта на командата SET_GCODE_VARIABLE
# (за подробности вижте docs/Command_Templates.md). Имената на променливите могат
# да не използват главни букви.
#rename_existing:
# Тази опция ще накара макроса да замени съществуваща G-Code
# и ще предостави предишната дефиниция на командата чрез
# име, предоставено тук. Тази опция може да се използва за отменяне на вградени G-Code
# командите. Трябва да се внимава, когато се заместват команди, тъй като това може да
# да доведе до сложни и неочаквани резултати. По подразбиране е да не
# не се пренаписва съществуваща G-Code команда.
#описание: G-Code макрос
# Това ще добави кратко описание, което се използва в командата HELP или докато
# при използване на функцията за автоматично попълване. По подразбиране "G-Code macro"
```

### [отложен_gcode]

Изпълнение на gcode със зададено закъснение. За повече информация вижте [ръководство за шаблони на команди](Command_Templates.md#delayed-gcodes) и [справка за команди](G-Codes.md#delayed_gcode).

```
[delayed_gcode my_delayed_gcode]
gcode:
# Списък с G-код команди, които да се изпълняват, когато продължителността на забавянето е
# изтече. Поддържат се шаблони на G-Code. Този параметър трябва да бъде
# предоставен.
#initial_duration: 0.0
# Продължителността на първоначалното забавяне (в секунди). Ако се зададе стойност
# ненулева стойност, забавеният_код ще се изпълни за определения брой
# секунди, след като принтерът влезе в състояние "готовност". Това може да бъде
# полезно за инициализиращи процедури или за повтарящ се delayed_gcode.
# Ако се зададе стойност 0, delayed_gcode няма да се изпълни при стартиране.
# По подразбиране е 0.
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

Време за престой. Таймаут при неактивен режим се активира автоматично - добавете изричен раздел idle_timeout в конфигурацията, за да промените настройките по подразбиране.

```
[idle_timeout]
#gcode:
# Списък с G-Code команди, които да се изпълняват при бездействие. Вижте
# docs/Command_Templates.md за формата на G-Code. По подразбиране се изпълнява
# "TURN_OFF_HEATERS" and "M84".
#timeout: 600
# Време на бездействие (в секунди), което да се изчака, преди да се изпълни горният G-код
# командите. По подразбиране е 600 секунди.
```

## Optional G-Code features

### [virtual_sdcard]

Виртуалната карта sdcard може да бъде полезна, ако хост машината не е достатъчно бърза, за да работи добре с OctoPrint. Тя позволява на софтуера на Klipper да отпечатва директно gcode файлове, съхранявани в директория на хоста, като използва стандартни sdcard G-Code команди (напр. M24).

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

Some printers with stage-clearing features, such as a part ejector or a belt printer, can find use in looping sections of the sdcard file. (For example, to print the same part over and over, or repeat the a section of a part for a chain or other repeated pattern).

See the [command reference](G-Codes.md#sdcard_loop) for supported commands. See the [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin compatible M808 G-Code macro.

```
[sdcard_loop]
```

### [force_move]

Support manually moving stepper motors for diagnostic purposes. Note, using this feature may place the printer in an invalid state - see the [command reference](G-Codes.md#force_move) for important details.

```
[force_move]
#enable_force_move: False
# Задайте стойност true, за да активирате FORCE_MOVE и SET_KINEMATIC_POSITION
# разширени команди на G-Code. По подразбиране е false.
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

Прибиране на нишки от фърмуера. Това позволява G10 (прибиране) и G11 (unretract) GCODE команди, издадени от много сегментатор. Параметрите по-долу осигуряват настройки по подразбиране за стартиране, въпреки че стойностите могат да се регулират чрез SET_RETRACTION [команда](G-Codes.md#firmware_retraction)), което позволява настройки за пер-нишки и настройка по време на изпълнение.

```
[firmware_retraction]
#retract_length: 0
# Дължината на нишката (в мм), която се прибира при активиране на G10,
# и да се разгъне, когато се активира G11 (но вижте
# unretract_extra_length по-долу). По подразбиране е 0 mm.
#retract_speed: 20
# Скоростта на прибиране, в mm/s. По подразбиране е 20 mm/s.
#unretract_extra_length: 0
* # Дължината (в мм) на допълнителната нишка *, която да се добави, когато
# при изтегляне.
#unretract_speed: 10
# Скоростта на изтегляне, в mm/s. По подразбиране е 10 mm/s.
```

### [gcode_arcs]

Support for gcode arc (G2/G3) commands.

```
[gcode_arcs]
#резолюция: 1.0
# Дъгата ще бъде разделена на сегменти. Дължината на всеки сегмент ще
# равна на зададената по-горе разделителна способност в mm. По-ниските стойности ще доведат до
# по-фина дъга, но също така и повече работа за вашата машина. Дъги, по-малки от
# конфигурираната стойност, ще се превърнат в прави линии. По подразбиране е
# 1 mm.
```

### [respond]

Активирайте разширените [команди] "M118" и "RESPOND" (G-Codes.md#respond).

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

Позволява изключване или отмяна на отделни обекти по време на процеса на отпечатване.

See the [exclude objects guide](Exclude_Object.md) and [command reference](G-Codes.md#excludeobject) for additional information. See the [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.

```
[exclude_object]
```

## Компенсация на резонанса

### [input_shaper]

Включва [компенсация на резонанса](Resonance_Compensation.md). Вижте също [референция на командата](G-Codes.md#input_shaper).

```
[input_shaper]
#shaper_freq_x: 0
#   A frequency (in Hz) of the input shaper for X axis. This is
#   usually a resonance frequency of X axis that the input shaper
#   should suppress. For more complex shapers, like 2- and 3-hump EI
#   input shapers, this parameter can be set from different
#   considerations. The default value is 0, which disables input
#   shaping for X axis.
#shaper_freq_y: 0
#   A frequency (in Hz) of the input shaper for Y axis. This is
#   usually a resonance frequency of Y axis that the input shaper
#   should suppress. For more complex shapers, like 2- and 3-hump EI
#   input shapers, this parameter can be set from different
#   considerations. The default value is 0, which disables input
#   shaping for Y axis.
#shaper_type: mzv
#   A type of the input shaper to use for both X and Y axes. Supported
#   shapers are zv, mzv, zvd, ei, 2hump_ei, and 3hump_ei. The default
#   is mzv input shaper.
#shaper_type_x:
#shaper_type_y:
#   If shaper_type is not set, these two parameters can be used to
#   configure different input shapers for X and Y axes. The same
#   values are supported as for shaper_type parameter.
#damping_ratio_x: 0.1
#damping_ratio_y: 0.1
#   Damping ratios of vibrations of X and Y axes used by input shapers
#   to improve vibration suppression. Default value is 0.1 which is a
#   good all-round value for most printers. In most circumstances this
#   parameter requires no tuning and should not be changed.
```

### [adxl345]

Support for ADXL345 accelerometers. This support allows one to query accelerometer measurements from the sensor. This enables an ACCELEROMETER_MEASURE command (see [G-Codes](G-Codes.md#adxl345) for more information). The default chip name is "default", but one may specify an explicit name (eg, [adxl345 my_chip_name]).

```
[adxl345]
cs_pin:
# Изводът за разрешаване на SPI за сензора. Този параметър трябва да бъде предоставен.
#spi_speed: 5000000
# Скоростта на SPI (в hz), която да се използва при комуникация с чипа.
# По подразбиране е 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Вижте раздела "Общи настройки на SPI" за описание на
# горепосочените параметри.
#axes_map: x, y, z
# Осите на акселерометъра за всяка от осите X, Y и Z на принтера.
# Това може да е полезно, ако акселерометърът е монтиран в
# ориентация, която не съвпада с ориентацията на принтера. За
# например, може да се зададе "y, x, z", за да се разменят осите X и Y.
# Възможно е също така да се отрече ос, ако акселерометърът
# посоката е обърната (например "x, z, -y"). По подразбиране е "x, y, z".
# скорост: 3200
# Скорост на изходните данни за ADXL345. ADXL345 поддържа следните данни
# скорости: 3200, 1600, 800, 400, 200, 100, 50 и 25. Имайте предвид, че е
# не се препоръчва да променяте тази скорост от стандартната 3200, и
# скорости под 800 ще повлияят значително на качеството на резонанса
# измервания.
```

### [mpu9250]

Support for MPU-9250, MPU-9255, MPU-6515, MPU-6050, and MPU-6500 accelerometers (one may define any number of sections with an "mpu9250" prefix).

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

## Помощни средства за конфигурационния файл

### [board_pins]

Псевдоними на пинове на платки (може да се дефинират произволен брой секции с префикс "board_pins"). Използвайте го, за да дефинирате псевдоними за изводите на микроконтролера.

```
[board_pins my_aliases]
mcu: mcu
# Списък с микроконтролери, разделени със запетая, които могат да използват
# псевдоними. По подразбиране псевдонимите се прилагат към основния "mcu".
aliases:
aliases_<name>:
# Списък, разделен със запетая, на "име=стойност" на псевдоними, които да се създадат за
# дадения микроконтролер. Например, "EXP1_1=PE6" ще създаде
# "EXP1_1" псевдоним за извода "PE6". Ако обаче "value" е затворено
# в "<>", тогава "name" се създава като запазен пин (например,
# "EXP1_9=<GND>" ще резервира "EXP1_9"). Всеки брой опции
# започващи с "aliases_", могат да бъдат зададени.
```

### [include]

Поддръжка на файловете за включване. Можете да включите допълнителен конфигурационен файл от основния конфигурационен файл на принтера. Могат да се използват и заместващи символи (например "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

This tool allows a single micro-controller pin to be defined multiple times in a config file without normal error checking. This is intended for diagnostic and debugging purposes. This section is not needed where Klipper supports using the same pin multiple times, and using this override may cause confusing and unexpected results.

```
[duplicate_pin_override]
пинове:
# Списък с пинове, разделени със запетая, които могат да се използват многократно в
# файл за конфигуриране без нормални проверки за грешки. Този параметър трябва да бъде
# осигурен.
```

## Хардуер за сондиране на легло

### [probe]

Z height probe. One may define this section to enable Z height probing hardware. When this section is enabled, PROBE and QUERY_PROBE extended [g-code commands](G-Codes.md#probe) become available. Also, see the [probe calibrate guide](Probe_Calibrate.md). The probe section also creates a virtual "probe:z_virtual_endstop" pin. One may set the stepper_z endstop_pin to this virtual pin on cartesian style printers that use the probe in place of a z endstop. If using "probe:z_virtual_endstop" then do not define a position_endstop in the stepper_z config section.

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

Сонда BLTouch. Тази секция може да се дефинира (вместо секция за сонда), за да се активира сонда BLTouch. За допълнителна информация вижте [BL-Touch guide](BLTouch.md) и [command reference](G-Codes.md#bltouch). Създава се и виртуален щифт "probe:z_virtual_endstop" (за подробности вижте раздела "Probe").

```
[bltouch]
sensor_pin:
# Пин, свързан с извода на сензора BLTouch. Повечето устройства BLTouch
# изискват издърпване на пина на сензора (предхождайте името на пина с "^").
# Този параметър трябва да се предостави.
control_pin:
# Пин, свързан с контролния пин на BLTouch. Този параметър трябва да бъде
# да се предостави.
#pin_move_time: 0.680
# Времето (в секунди), което трябва да се изчака, за да може щифтът BLTouch да
# да се премести нагоре или надолу. По подразбиране е 0,680 секунди.
#stow_on_each_sample: True
# Това определя дали Klipper трябва да командва щифта да се движи нагоре
# между всеки опит за сондиране, когато се извършва многократно сондиране
# последователност. Прочетете указанията в docs/BLTouch.md, преди да зададете
# тази стойност е False. По подразбиране е True.
#probe_with_touch_mode: False
# Ако това е зададено на True, Klipper ще сондира с устройството в
# "touch_mode". По подразбиране е False (сондиране в режим "pin_down").
#pin_up_reports_not_triggered: True
# Задайте, ако BLTouch последователно съобщава за сондиране в режим "not
# задействана" след успешна команда "pin_up". Това трябва да
# да бъде True за всички истински устройства BLTouch. Прочетете указанията в
# docs/BLTouch.md, преди да зададете стойност False. По подразбиране е True.
#pin_up_touch_mode_reports_triggered: True
# Задайте дали BLTouch последователно да съобщава за състояние "задействан" след
# командите "pin_up", последвани от "touch_mode". Това трябва да бъде
# True за всички истински BLTouch устройства. Прочетете указанията в
# docs/BLTouch.md, преди да зададете стойност False. По подразбиране е True.
#set_output_mode:
# Запитване за специфичен режим на извеждане на сензорния щифт на BLTouch V3.0 (и
# по-късно). Тази настройка не трябва да се използва при други видове сонди.
# Задайте "5V", за да заявите изход на сензорния щифт от 5 волта (използвайте само ако
# контролната платка се нуждае от режим 5 V и толерира 5 V на входа си
# сигнална линия). Задайте "OD", за да поискате използването на изхода на щифта на сензора
# режим на отворен канал. По подразбиране не се изисква режим на изхода.
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
# Вижте раздела "Сонда" за информация относно тези параметри.
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

## Допълнителни стъпкови двигатели и екструдери

### [stepper_z1]

Multi-stepper axes. On a cartesian style printer, the stepper controlling a given axis may have additional config blocks defining steppers that should be stepped in concert with the primary stepper. One may define any number of sections with a numeric suffix starting at 1 (for example, "stepper_z1", "stepper_z2", etc.).

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

При принтер с няколко екструдера добавете допълнителна секция за всеки допълнителен екструдер. Допълнителните екструдерни секции трябва да бъдат наречени "екструдер1", "екструдер2", "екструдер3" и т.н. За описание на наличните параметри вижте раздела "Екструдер".

See [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg) for an example configuration.

```
[екструдер1]
#step_pin:
#dir_pin:
#...
# Вижте раздела "Екструдер" за наличните стъпкови и нагревателни устройства
# параметри.
#shared_heater:
# Тази опция е остаряла и вече не трябва да се посочва.
```

### [двойна_каретка]

Support for cartesian printers with dual carriages on a single axis. The active carriage is set via the SET_DUAL_CARRIAGE extended g-code command. The "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation.

See [sample-idex.cfg](../config/sample-idex.cfg) for an example configuration.

```
[dual_carriage]
ос:
# Оста, по която се движи тази допълнителна количка (x или y). Този параметър
# трябва да бъде предоставен.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
# Вижте раздела "Stepper" за дефиницията на горните параметри.
```

### [extruder_stepper]

Support for additional steppers synchronized to the movement of an extruder (one may define any number of sections with an "extruder_stepper" prefix).

See the [command reference](G-Codes.md#extruder) for more information.

```
[extruder_stepper my_extra_stepper]
екструдер:
# Екструдерът, с който е синхронизиран този стъпков механизъм. Ако това е зададено на
# празен низ, тогава стъпковият механизъм няма да бъде синхронизиран с
# extruder. Този параметър трябва да бъде предоставен.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
# Вижте раздела "Stepper" за дефиницията на горното
# параметри.
```

### [manual_stepper]

Ръчни степери (може да се дефинират произволен брой секции с префикс "manual_stepper"). Това са стъпкообразуватели, които се управляват от g-кодовата команда MANUAL_STEPPER. Например: "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". Вижте файла [G-Codes](G-Codes.md#manual_stepper) за описание на командата MANUAL_STEPPER. Степерите не са свързани с нормалната кинематика на принтера.

```
[manual_stepper my_stepper]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
# Вижте раздела "Stepper" за описание на тези параметри.
#величина:
# Задайте скоростта по подразбиране (в mm/s) за стъпковия механизъм. Тази стойност
# ще бъде използвана, ако командата MANUAL_STEPPER не укаже SPEED
# параметър. По подразбиране е 5 mm/s.
#accel:
# Задайте ускорението по подразбиране (в mm/s^2) за стъпковия механизъм. На
# ускорение нула няма да доведе до никакво ускорение. Тази стойност
# ще бъде използвана, ако командата MANUAL_STEPPER не зададе ACCEL
# параметър. По подразбиране е нула.
#endstop_pin:
# Извод за откриване на превключвател за спиране. Ако е посочен, тогава може да се извърши
# "ходове на самонасочване", като се добави параметър STOP_ON_ENDSTOP към
# командите за движение MANUAL_STEPPER.
```

## Персонализирани нагреватели и сензори

### [verify_heater]

Проверка на нагревателя и температурния сензор. Проверката на нагревателя се активира автоматично за всеки нагревател, който е конфигуриран в принтера. Използвайте секциите verify_heater, за да промените настройките по подразбиране.

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

Tool to disable heaters when homing or probing an axis.

```
[homing_heaters]
#steppers:
#   A comma separated list of steppers that should cause heaters to be
#   disabled. The default is to disable heaters for any homing/probing
#   move.
#   Typical example: stepper_z
#heaters:
#   A comma separated list of heaters to disable during homing/probing
#   moves. The default is to disable all heaters.
#   Typical example: extruder, heater_bed
```

### [thermistor]

Потребителски термистори (може да се дефинират произволен брой секции с префикс "thermistor"). Потребителски термистор може да се използва в полето sensor_type (тип на сензора) на секция за конфигуриране на нагревател. (Например, ако се дефинира секция "[thermistor my_thermistor]", тогава може да се използва "sensor_type: my_thermistor" при дефиниране на нагревател.) Не забравяйте да поставите секцията thermistor в конфигурационния файл над първото ѝ използване в секция за нагревател.

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

Потребителски ADC температурни сензори (може да се дефинират произволен брой секции с префикс "adc_temperature"). Това позволява да се дефинира потребителски температурен сензор, който измерва напрежение на извод на аналогово-цифров преобразувател (ADC) и използва линейна интерполация между набор от конфигурирани измервания на температура/напрежение (или температура/съпротивление), за да определи температурата. Полученият сензор може да се използва като сензор_тип в секция за нагревател. (Например, ако се дефинира секция "[adc_temperature my_sensor]", тогава може да се използва "sensor_type: my_sensor" при дефиниране на нагревател.) Не забравяйте да поставите секцията на сензора във файла за конфигуриране над първото ѝ използване в секция на нагревател.

```
[adc_temperature my_sensor]
#temperature1:
#voltage1:
#температура2:
#voltage2:
#...
# Набор от температури (в градуси по Целзий) и напрежения (във волтове), които да се използват
# като референция при преобразуване на температура. Секция за нагревател, използваща
# този сензор, може да се зададат също adc_voltage и voltage_offset
# параметри за определяне на напрежението на АЦП (виж "Обща температура
# усилватели" за подробности). Поне две измервания трябва да
# да бъдат предоставени.
#температура1:
#съпротивление1:
#температура2:
#съпротивление2:
#...
# Алтернативно може да се посочи набор от температури (в градуси по Целзий)
# и съпротивление (в омове), които да се използват като референтни при преобразуването на
# температура. Секцията на нагревателя, използваща този сензор, може също така да посочи
# параметър pullup_resistor (за подробности вижте раздела "Екструдер"). На адрес
# поне две измервания трябва да бъдат предоставени.
```

### [heater_generic]

Общи нагреватели (могат да се дефинират произволен брой секции с префикс "heater_generic"). Тези нагреватели се държат подобно на стандартните нагреватели (екструдери, нагрявани легла). Използвайте командата SET_HEATER_TEMPERATURE (за подробности вижте [G-Codes](G-Codes.md#heaters)), за да зададете целевата температура.

```
[heater_generic my_generic_heater]
#gcode_id:
#   The id to use when reporting the temperature in the M105 command.
#   This parameter must be provided.
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
#   See the "extruder" section for the definition of the above
#   parameters.
```

### [temperature_sensor]

Общи температурни сензори. Може да се дефинира произволен брой допълнителни температурни сензори, които се отчитат чрез командата M105.

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

Klipper включва дефиниции за много видове температурни сензори. Тези сензори могат да се използват във всеки раздел на конфигурацията, който изисква температурен сензор (например раздел `[extruder]` или `[heater_bed]` ).

### Общи термистори

Обикновени термистори. Следните параметри са налични в секциите на нагревателите, които използват един от тези сензори.

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

### Усилватели с обща температура

Усилватели с обща температура. Следните параметри са налични в секциите на нагревателите, които използват един от тези сензори.

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

### Директно свързан сензор PT1000

Директно свързан сензор PT1000. Следните параметри са налични в секциите на нагревателите, които използват един от тези сензори.

```
sensor_type: PT1000
sensor_pin:
#   Analog input pin connected to the sensor. This parameter must be
#   provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the sensor. The
#   default is 4700 ohms.
```

### MAXxxxxx temperature sensors

MAXxxxxx serial peripheral interface (SPI) temperature based sensors. The following parameters are available in heater sections that use one of these sensor types.

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

### Температурен сензор BMP280/BME280/BME680

Сензори за околна среда BMP280/BME280/BME680 с двупроводен интерфейс (I2C). Обърнете внимание, че тези сензори не са предназначени за използване с екструдери и нагреватели, а по-скоро за наблюдение на температурата на околната среда (C), налягането (hPa), относителната влажност и в случай на BME680 - нивото на газа. Вижте [sample-macros.cfg](../config/sample-macros.cfg) за gcode_macro, който може да се използва за отчитане на налягането и влажността в допълнение към температурата.

```
sensor_type: BME280
#i2c_address:
#   Default is 118 (0x76). Some BME280 sensors have an address of 119
#   (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### AHT10/AHT20/AHT21 temperature sensor

AHT10/AHT20/AHT21 two wire interface (I2C) environmental sensors. Note that these sensors are not intended for use with extruders and heater beds, but rather for monitoring ambient temperature (C) and relative humidity. See [sample-macros.cfg](../config/sample-macros.cfg) for a gcode_macro that may be used to report humidity in addition to temperature.

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

### Сензор HTU21D

Сензор за околната среда от семейство HTU21D с двупроводен интерфейс (I2C). Обърнете внимание, че този сензор не е предназначен за използване с екструдери и нагреватели, а по-скоро за наблюдение на температурата на околната среда (C) и относителната влажност. Вижте [sample-macros.cfg](../config/sample-macros.cfg) за gcode_macro, който може да се използва за отчитане на влажността в допълнение към температурата.

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

### Температурен сензор LM75

Температурни сензори LM75/LM75A, свързани с два проводника (I2C). Тези сензори имат обхват от -55~125 C, така че могат да се използват например за наблюдение на температурата в камерата. Те могат да функционират и като прости контролери на вентилатори/нагреватели.

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

### Вграден сензор за температура в микроконтролера

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

### Сензор за температура на хоста

Temperature from the machine (eg Raspberry Pi) running the host software.

```
sensor_type: temperature_host
#sensor_path:
#   The path to temperature system file. The default is
#   "/sys/class/thermal/thermal_zone0/temp" which is the temperature
#   system file on a Raspberry Pi computer.
```

### Температурен сензор DS18B20

DS18B20 е еднопроводен (w1) цифров температурен сензор. Обърнете внимание, че този сензор не е предназначен за използване с екструдери и нагревателни легла, а по-скоро за наблюдение на температурата на околната среда (C). Тези сензори имат обхват до 125 С, така че могат да се използват например за наблюдение на температурата в камерата. Те могат да функционират и като прости контролери на вентилатори/нагреватели. Сензорите DS18B20 се поддържат само от "хост mcu", напр. Raspberry Pi. Трябва да се инсталира модулът w1-gpio в ядрото на Linux.

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

## Вентилатори

### [вентилатор]

Print cooling fan.

```
[fan]
pin:
#   Output pin controlling the fan. This parameter must be provided.
#max_power: 1.0
#   The maximum power (expressed as a value from 0.0 to 1.0) that the
#   pin may be set to. The value 1.0 allows the pin to be set fully
#   enabled for extended periods, while a value of 0.5 would allow the
#   pin to be enabled for no more than half the time. This setting may
#   be used to limit the total power output (over extended periods) to
#   the fan. If this value is less than 1.0 then fan speed requests
#   will be scaled between zero and max_power (for example, if
#   max_power is .9 and a fan speed of 80% is requested then the fan
#   power will be set to 72%). The default is 1.0.
#shutdown_speed: 0
#   The desired fan speed (expressed as a value from 0.0 to 1.0) if
#   the micro-controller software enters an error state. The default
#   is 0.
#cycle_time: 0.010
#   The amount of time (in seconds) for each PWM power cycle to the
#   fan. It is recommended this be 10 milliseconds or greater when
#   using software based PWM. The default is 0.010 seconds.
#hardware_pwm: False
#   Enable this to use hardware PWM instead of software PWM. Most fans
#   do not work well with hardware PWM, so it is not recommended to
#   enable this unless there is an electrical requirement to switch at
#   very high speeds. When using hardware PWM the actual cycle time is
#   constrained by the implementation and may be significantly
#   different than the requested cycle_time. The default is False.
#kick_start_time: 0.100
#   Time (in seconds) to run the fan at full speed when either first
#   enabling or increasing it by more than 50% (helps get the fan
#   spinning). The default is 0.100 seconds.
#off_below: 0.0
#   The minimum input speed which will power the fan (expressed as a
#   value from 0.0 to 1.0). When a speed lower than off_below is
#   requested the fan will instead be turned off. This setting may be
#   used to prevent fan stalls and to ensure kick starts are
#   effective. The default is 0.0.
#
#   This setting should be recalibrated whenever max_power is adjusted.
#   To calibrate this setting, start with off_below set to 0.0 and the
#   fan spinning. Gradually lower the fan speed to determine the lowest
#   input speed which reliably drives the fan without stalls. Set
#   off_below to the duty cycle corresponding to this value (for
#   example, 12% -> 0.12) or slightly higher.
#tachometer_pin:
#   Tachometer input pin for monitoring fan speed. A pullup is generally
#   required. This parameter is optional.
#tachometer_ppr: 2
#   When tachometer_pin is specified, this is the number of pulses per
#   revolution of the tachometer signal. For a BLDC fan this is
#   normally half the number of poles. The default is 2.
#tachometer_poll_interval: 0.0015
#   When tachometer_pin is specified, this is the polling period of the
#   tachometer pin, in seconds. The default is 0.0015, which is fast
#   enough for fans below 10000 RPM at 2 PPR. This must be smaller than
#   30/(tachometer_ppr*rpm), with some margin, where rpm is the
#   maximum speed (in RPM) of the fan.
#enable_pin:
#   Optional pin to enable power to the fan. This can be useful for fans
#   with dedicated PWM inputs. Some of these fans stay on even at 0% PWM
#   input. In such a case, the PWM pin can be used normally, and e.g. a
#   ground-switched FET(standard fan pin) can be used to control power to
#   the fan.
```

### [heater_fan]

Вентилатори за охлаждане на нагреватели (могат да се дефинират произволен брой секции с префикс "heater_fan"). "Вентилатор на нагревател" е вентилатор, който ще бъде активиран, когато свързаният с него нагревател е активен. По подразбиране вентилаторът на нагревателя има скорост на изключване, равна на max_power.

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

Вентилатор за охлаждане на контролера (може да се дефинират произволен брой секции с префикс "controller_fan"). Вентилаторът на контролера" е вентилатор, който ще бъде активиран, когато свързаният с него нагревател или свързаният с него стъпков драйвер е активен. Вентилаторът ще спира винаги, когато се достигне idle_timeout, за да се гарантира, че няма да настъпи прегряване след деактивиране на наблюдаван компонент.

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
#   See the "fan" section for a description of the above parameters.
#fan_speed: 1.0
#   The fan speed (expressed as a value from 0.0 to 1.0) that the fan
#   will be set to when a heater or stepper driver is active.
#   The default is 1.0
#idle_timeout:
#   The amount of time (in seconds) after a stepper driver or heater
#   was active and the fan should be kept running. The default
#   is 30 seconds.
#idle_speed:
#   The fan speed (expressed as a value from 0.0 to 1.0) that the fan
#   will be set to when a heater or stepper driver was active and
#   before the idle_timeout is reached. The default is fan_speed.
#heater:
#stepper:
#   Name of the config section defining the heater/stepper that this fan
#   is associated with. If a comma separated list of heater/stepper names
#   is provided here, then the fan will be enabled when any of the given
#   heaters/steppers are enabled. The default heater is "extruder", the
#   default stepper is all of them.
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

Вентилатор с ръчно управление (може да се дефинират произволен брой секции с префикс "fan_generic"). Скоростта на ръчно управлявания вентилатор се задава с командата SET_FAN_SPEED [gcode команда](G-Codes.md#fan_generic).

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
#   See the "fan" section for a description of the above parameters.
```

## светодиоди

### [led]

Support for LEDs (and LED strips) controlled via micro-controller PWM pins (one may define any number of sections with an "led" prefix). See the [command reference](G-Codes.md#led) for more information.

```
[led my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
# Изводът, управляващ дадения цвят на светодиода. Поне един от горните
# параметри трябва да бъдат предоставени.
#cycle_time: 0.010
# Времето (в секунди) за един ШИМ цикъл. Препоръчва се
# това да бъде 10 милисекунди или повече, когато се използва софтуерно базирана ШИМ.
# По подразбиране е 0,010 секунди.
#hardware_pwm: False
# Активирайте това, за да използвате хардуерна ШИМ вместо софтуерна ШИМ. Когато
# използване на хардуерна ШИМ действителното време на цикъла се ограничава от
# изпълнението и може да се различава значително от
# заявеното време на цикъла. По подразбиране е False.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
# Задава първоначалния цвят на светодиода. Всяка стойност трябва да е между 0,0 и
# 1.0. По подразбиране за всеки цвят е 0.
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

Поддръжка на светодиод Dotstar (известен още като APA102) (може да се дефинират произволен брой секции с префикс "dotstar"). За повече информация вижте [справка за командите](G-Codes.md#led).

```
[dotstar my_dotstar]
data_pin:
# Изводът, свързан с линията за данни на dotstar. Този параметър
# трябва да бъде предоставен.
clock_pin:
# Изводът, свързан към тактовата линия на dotstar. Този параметър
# трябва да бъде предоставен.
#chain_count:
# Вижте раздела "Неопиксел" за информация относно този параметър.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
# Вижте раздела "led" за информация относно тези параметри.
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

PCA9632 LED support. The PCA9632 is used on the FlashForge Dreamer.

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

## Допълнителни сервоуправления, бутони и други щифтове

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

Изпълнение на gcode при натискане или отпускане на бутон (или при промяна на състоянието на щифт). Можете да проверите състоянието на бутона, като използвате `QUERY_BUTTON button=my_gcode_button`.

```
[gcode_button my_gcode_button]
pin:
# Изводът, към който е свързан бутонът. Този параметър трябва да бъде
# предоставен.
#analog_range:
# Две съпротивления, разделени със запетая (в омове), които определят минималния
# и максималния обхват на съпротивлението за бутона. Ако analog_range е
#, тогава щифтът трябва да е аналогов щифт. По подразбиране
# е да се използва цифров gpio за бутона.
#analog_pullup_resistor:
# Съпротивлението на издърпване (в омове), когато е зададен analog_range.
# По подразбиране е 4700 ома.
#press_gcode:
# Списък с G-Code команди, които да се изпълняват при натискане на бутона.
# Поддържат се шаблони на G-Code. Този параметър трябва да бъде предоставен.
#release_gcode:
# Списък с G-Code команди, които да се изпълняват, когато бутонът е освободен.
# Поддържат се шаблони на G-Code. По подразбиране не се изпълняват никакви
# команди при освобождаване на бутона.
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

Конфигуриране на драйвери за стъпкови двигатели Trinamic в режим UART/SPI. Допълнителна информация се съдържа в [Ръководство за драйвери на TMC](TMC_Drivers.md) и в [Справка за командите](G-Codes.md#tmcxxxx).

### [tmc2130]

Конфигуриране на драйвер на стъпков двигател TMC2130 чрез шина SPI. За да използвате тази функция, дефинирайте секция за конфигуриране с префикс "tmc2130", последван от името на съответната секция за конфигуриране на стъпков двигател (например "[tmc2130 stepper_x]").

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

Конфигуриране на драйвер за стъпков двигател TMC2208 (или TMC2224) чрез еднопроводен UART. За да използвате тази функция, дефинирайте секция за конфигуриране с префикс "tmc2208", последван от името на съответната секция за конфигуриране на стъпков двигател (например "[tmc2208 stepper_x]").

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

Конфигуриране на драйвер за стъпков двигател TMC2209 чрез еднопроводен UART. За да използвате тази функция, дефинирайте секция за конфигуриране с префикс "tmc2209", последван от името на съответната секция за конфигуриране на стъпков двигател (например "[tmc2209 stepper_x]").

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

Конфигуриране на драйвер за стъпков двигател TMC2660 чрез SPI шина. За да използвате тази функция, дефинирайте секция за конфигуриране с префикс tmc2660, последван от името на съответната секция за конфигуриране на стъпков двигател (например "[tmc2660 stepper_x]").

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

### [tmc2240]

Configure a TMC2240 stepper motor driver via SPI bus. To use this feature, define a config section with a "tmc2240" prefix followed by the name of the corresponding stepper config section (for example, "[tmc2240 stepper_x]").

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

Конфигуриране на драйвер за стъпков двигател TMC5160 чрез SPI шина. За да използвате тази функция, дефинирайте секция за конфигуриране с префикс "tmc5160", последван от името на съответната секция за конфигуриране на стъпков двигател (например "[tmc5160 stepper_x]").

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

## Run-time stepper motor current configuration

### [ad5206]

Statically configured AD5206 digipots connected via SPI bus (one may define any number of sections with an "ad5206" prefix).

```
[ad5206 my_digipot]
enable_pin:
# Изводът, съответстващ на линията за избор на чип на AD5206. Този пин
# ще бъде поставен на ниско ниво в началото на SPI съобщенията и ще бъде повишен на високо ниво
# след приключване на съобщението. Този параметър трябва да се предостави.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Вижте раздела "Общи настройки на SPI" за описание на
# горепосочените параметри.
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
# Стойността, на която статично се настройва даденият канал на AD5206. Това е
# обикновено се задава като число между 0,0 и 1,0, като 1,0 е
# най-високото съпротивление и 0,0 е най-ниското съпротивление. Въпреки това,
# обхватът може да бъде променен с параметъра 'scale' (вж. по-долу).
# Ако каналът не е посочен, той се оставя неконфигуриран.
#scale:
# Този параметър може да се използва за промяна на начина, по който параметрите "channel_x
# се интерпретират. Ако е предоставен, параметрите 'channel_x'
# трябва да бъдат между 0,0 и 'scale'. Това може да е полезно, когато
# AD5206 се използва за задаване на референтни стойности на напрежението на стъпковия механизъм. Параметърът 'scale' може
# да се зададе еквивалентното напрежение на стъпковия генератор, ако AD5206 е на
# най-високото си съпротивление, а след това параметрите 'channel_x' могат да бъдат
# да се зададе, като се използва желаната стойност на ампеража за стъпковия механизъм. В
# по подразбиране параметрите 'channel_x' не се мащабират.
```

### [mcp4451]

Statically configured MCP4451 digipot connected via I2C bus (one may define any number of sections with an "mcp4451" prefix).

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

Statically configured MCP4728 digital-to-analog converter connected via I2C bus (one may define any number of sections with an "mcp4728" prefix).

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

Statically configured MCP4018 digipot connected via two gpio "bit banging" pins (one may define any number of sections with an "mcp4018" prefix).

```
[mcp4018 my_digipot]
scl_pin:
#   The SCL "clock" pin. This parameter must be provided.
sda_pin:
#   The SDA "data" pin. This parameter must be provided.
wiper:
#   The value to statically set the given MCP4018 "wiper" to. This is
#   typically set to a number between 0.0 and 1.0 with 1.0 being the
#   highest resistance and 0.0 being the lowest resistance. However,
#   the range may be changed with the 'scale' parameter (see below).
#   This parameter must be provided.
#scale:
#   This parameter can be used to alter how the 'wiper' parameter is
#   interpreted. If provided, then the 'wiper' parameter should be
#   between 0.0 and 'scale'. This may be useful when the MCP4018 is
#   used to set stepper voltage references. The 'scale' can be set to
#   the equivalent stepper amperage if the MCP4018 is at its highest
#   resistance, and then the 'wiper' parameter can be specified using
#   the desired amperage value for the stepper. The default is to not
#   scale the 'wiper' parameter.
```

## Поддръжка на дисплея

### [дисплей]

Support for a display attached to the micro-controller.

```
[дисплей]
lcd_type:
# Типът на използвания LCD чип. Това може да бъде "hd44780", "hd44780_spi",
# "st7920", "emulated_st7920", "uc1701", "ssd1306" или "sh1106".
# Вижте разделите за дисплея по-долу за информация за всеки тип и
# допълнителните параметри, които те предоставят. Този параметър трябва да бъде
# предоставен.
#display_group:
# Името на групата display_data, която ще се показва на дисплея. Това
# контролира съдържанието на екрана (вж. раздела "display_data")
# за повече информация). По подразбиране е _default_20x4 за hd44780
# и _default_16x4 за други дисплеи.
#menu_timeout:
# Време за изчакване на менюто. Ако не сте активни, този брой секунди ще
# задейства излизане от менюто или връщане към главното меню, когато има автоматично стартиране
# активирано. По подразбиране е 0 секунди (изключено).
#menu_root:
# Името на раздела на главното меню, който ще се показва при щракване върху енкодера
# на началния екран. По подразбиране е __main и това показва
# менютата по подразбиране, както са дефинирани в klippy/extras/display/menu.cfg
#menu_reverse_navigation:
# Когато е разрешено, то ще обърне посоките нагоре и надолу за списъка
# навигация. По подразбиране е False. Този параметър е незадължителен.
#encoder_pins:
# Изводите, свързани с енкодера. Трябва да се предоставят 2 извода, когато се използва
# енкодер. Този параметър трябва да бъде предоставен, когато се използва меню.
#encoder_steps_per_detent:
# Колко стъпки излъчва енкодерът за едно натискане ("кликване"). Ако
# енкодерът се нуждае от два детента, за да се придвижи между позиции или се движи с два
# записи от един детент, опитайте да промените това. Позволените стойности са 2
# (половин стъпка) или 4 (пълна стъпка). По подразбиране е 4.
#click_pin:
# Изводът, свързан с бутона 'enter' или енкодера 'click'. Този
# параметър трябва да бъде предоставен, когато се използва менюто. Наличието на
# 'analog_range_click_pin' конфигурационен параметър превръща този параметър
# от цифров в аналогов.
#back_pin:
# Изводът, свързан с бутона "назад". Този параметър не е задължителен,
# менюто може да се използва и без него. Наличието на
# 'analog_range_back_pin' превръща този параметър от
# цифров в аналогов.
#up_pin:
# Изводът, свързан с бутона 'up'. Този параметър трябва да се предостави
# когато използвате меню без енкодер. Наличието на
# 'analog_range_up_pin' превръща този параметър от
# цифров в аналогов.
#down_pin:
# Изводът, свързан с бутона "надолу". Този параметър трябва да бъде
# когато се използва меню без енкодер. Наличието на
# 'analog_range_down_pin' превръща този параметър от
# цифров в аналогов.
#kill_pin:
# Изводът, свързан с бутона 'kill'. Този бутон ще извика
# аварийно спиране. Наличието на конфигурация 'analog_range_kill_pin'
# превръща този параметър от цифров в аналогов.
#analog_pullup_resistor: 4700
# Съпротивлението (в омове) на издърпването, свързано към аналоговия
# бутон. По подразбиране е 4700 ома.
#analog_range_click_pin:
# Диапазонът на съпротивлението за бутон "Enter". Минимален обхват и
# максимални стойности, разделени със запетая, трябва да бъдат предоставени, когато се използва аналогов
# бутон.
#analog_range_back_pin:
# Диапазонът на съпротивление за бутон "назад". Минимален обхват и
# максимални стойности, разделени със запетая, трябва да бъдат предоставени при използване на аналогов
# бутон.
#analog_range_up_pin:
# Диапазонът на съпротивление за бутон "нагоре". Минимален и максимален обхват
# трябва да се посочат стойности, разделени със запетая, когато се използва аналогов бутон.
#analog_range_down_pin:
# Диапазонът на съпротивление за бутон "надолу". Минимален обхват и
# максималните стойности, разделени със запетая, трябва да бъдат предоставени, когато се използва аналогов
# бутон.
#analog_range_kill_pin:
# Диапазонът на съпротивление за бутон "kill". Минимален обхват и
# максимални стойности, разделени със запетая, трябва да бъдат предоставени при използване на аналогов
# бутон.
```

#### hd44780 дисплей

Информация за конфигуриране на дисплеи hd44780 (които се използват в дисплеи тип "RepRapDiscount 2004 Smart Controller").

```
[дисплей]
lcd_type: hd44780
# Задайте на "hd44780" за дисплеи hd44780.
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
# Изводите, свързани към LCD тип hd44780. Тези параметри трябва да
# да бъдат предоставени.
#hd44780_protocol_init: True
# Извършва инициализация на 8-битов/4-битов протокол на дисплей hd44780.
# Това е необходимо при реални устройства hd44780. Въпреки това, може да се наложи
# да се деактивира това при някои "клонирани" устройства. По подразбиране е True.
#line_length:
# Задайте броя на символите на ред за lcd тип hd44780.
# Възможните стойности са 20 (по подразбиране) и 16. Броят на редовете е
# фиксиран на 4.
...
```

#### hd44780_spi дисплей

Информация за конфигуриране на дисплей hd44780_spi - дисплей с размери 20x04, управляван чрез хардуерен "регистър за смяна" (който се използва в принтерите, базирани на mightyboard).

```
[дисплей]
lcd_type: hd44780_spi
# Задайте на "hd44780_spi" за дисплеи hd44780_spi.
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
# Изводите, свързани към регистъра за смяна, управляващ дисплея.
# Изводът spi_software_miso_pin трябва да се зададе към неизползван извод на
# дънната платка на принтера, тъй като регистърът за смяна няма MISO извод,
# но софтуерната реализация на spi изисква този извод да бъде
# конфигуриран.
#hd44780_protocol_init: True
# Извършва инициализация на 8-битов/4-битов протокол на дисплей hd44780.
# Това е необходимо при реални устройства hd44780. Въпреки това, може да се наложи
# да се деактивира това при някои "клонирани" устройства. По подразбиране е True.
#line_length:
# Задайте броя на символите на ред за lcd тип hd44780.
# Възможните стойности са 20 (по подразбиране) и 16. Броят на редовете е
# фиксиран на 4.
...
```

#### st7920 display

Информация за конфигуриране на дисплеи st7920 (които се използват в дисплеи тип "RepRapDiscount 12864 Full Graphic Smart Controller").

```
[дисплей]
lcd_type: st7920
# Задава се на "st7920" за дисплеи st7920.
cs_pin:
sclk_pin:
sid_pin:
# Изводите, свързани към lcd тип st7920. Тези параметри трябва да бъдат
# осигурени.
...
```

#### Емулиран_st7920 дисплей

Информация за конфигуриране на емулиран дисплей st7920 - намира се в някои "2,4-инчови устройства със сензорен екран" и подобни.

```
[дисплей]
lcd_type: emulated_st7920
# Задава се на "emulated_st7920" за дисплеи emulated_st7920.
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
# Изводите, свързани към lcd тип emulated_st7920. en_pin
# съответства на cs_pin на lcd тип st7920,
# spi_software_sclk_pin съответства на sclk_pin и
# spi_software_mosi_pin съответства на sid_pin. .
# spi_software_miso_pin трябва да бъде зададен на неизползван извод на
# дънната платка на принтера, тъй като st7920 няма MISO извод, но софтуерът
# spi имплементацията изисква конфигурирането на този извод.
...
```

#### uc1701 display

Информация за конфигуриране на дисплеи uc1701 (които се използват в дисплеи тип "MKS Mini 12864").

```
[дисплей]
lcd_type: uc1701
# Задава се на "uc1701" за дисплеи uc1701.
cs_pin:
a0_pin:
# Изводите, свързани към lcd тип uc1701. Тези параметри трябва да бъдат
# осигурени.
#rst_pin:
# Изводът, свързан към извода "rst" на lcd. Ако той не е
# посочен, тогава хардуерът трябва да има издърпване на
# съответната линия на lcd.
#contrast:
# Контрастът, който трябва да се зададе. Стойността може да варира от 0 до 63 и
# по подразбиране е 40.
...
```

#### ssd1306 and sh1106 displays

Информация за конфигуриране на дисплеите ssd1306 и sh1106.

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

Support for displaying custom data on an lcd screen. One may create any number of display groups and any number of data items under those groups. The display will show all the data items for a given group if the display_group option in the [display] section is set to the given group name.

Автоматично се създава [набор от групи по подразбиране](../klippy/extras/display/display.cfg). Може да се заменят или разширят тези елементи display_data, като се заменят настройките по подразбиране в основния конфигурационен файл printer.cfg.

```
[display_data my_group_name my_data_name]
position:
# Ред и колона на позицията на дисплея, които трябва да се отделят със запетая
# да се използва за показване на информацията. Този параметър трябва да бъде
# предоставен.
text:
# Текстът, който трябва да се покаже на дадената позиция. Това поле се оценява
# с помощта на шаблони на команди (виж docs/Command_Templates.md). Това
# параметър трябва да бъде предоставен.
```

### [шаблон за показване]

"Макроси" за текст на данни за показване (могат да се дефинират произволен брой раздели с префикс display_template). За информация относно оценката на шаблоните вижте документа [command templates](Command_Templates.md).

This feature allows one to reduce repetitive definitions in display_data sections. One may use the builtin `render()` function in display_data sections to evaluate a template. For example, if one were to define `[display_template my_template]` then one could use `{ render('my_template') }` in a display_data section.

This feature can also be used for continuous LED updates using the [SET_LED_TEMPLATE](G-Codes.md#set_led_template) command.

```
[display_template my_template_name]
#param_<name>:
# Може да се посочат произволен брой опции с префикс "param_". В
# даденото име ще получи дадената стойност (анализирана като Python
# литерал) и ще бъде достъпно по време на разширяването на макроса. Ако
# параметърът е предаден при извикването на render(), тогава тази стойност ще
# ще бъде използвана по време на разширяването на макроса. Например, конфигурация с
# "param_speed = 75" може да има повикващ с
# "render('my_template_name', param_speed=80)". Имената на параметрите могат
# да не използват главни букви.
текст:
# Текстът, който да се върне, когато този шаблон се визуализира. Това поле
# се оценява, като се използват шаблони за команди (вж.
# docs/Command_Templates.md). Този параметър трябва да бъде предоставен.
```

### [display_glyph]

Показване на потребителски глиф на дисплеи, които го поддържат. На даденото име ще бъдат присвоени дадените данни за дисплея, към които след това може да се направи препратка в шаблоните на дисплея чрез името им, заобиколено от два символа "тилда", т.е. `~my_display_glyph~`

See [sample-glyphs.cfg](../config/sample-glyphs.cfg) for some examples.

```
[display_glyph my_display_glyph]
#data:
# Данните за дисплея, съхранени като 16 реда, състоящи се от 16 бита (по 1 на
# пиксел), където "." е празен пиксел, а "*" е включен пиксел (напр,
# "****************" за показване на плътна хоризонтална линия).
# Алтернативно може да се използва '0' за празен пиксел и '1' за включен пиксел.
# пиксел. Поставете всеки ред за показване в отделен конфигурационен ред. В
# глифът трябва да се състои от точно 16 линии с 16 бита всяка. Този
# параметър е незадължителен.
#hd44780_data:
# Глиф, който да се използва за 20x4 hd44780 дисплеи. Глифът трябва да се състои от
# точно 8 реда с по 5 бита всеки. Този параметър е незадължителен.
#hd44780_slot:
# Хардуерният индекс на hd44780 (0..7), в който да се съхранява глифът. Ако
# няколко различни изображения използват един и същ слот, то се уверете, че само
# да използвате едно от тези изображения на даден екран. Този параметър е
# задължителен, ако е посочен hd44780_data.
```

### [display my_extra_display]

Ако в принтера е дефиниран първичен раздел [дисплей].cfg както е показано по-горе е възможно да се дефинират няколко спомагателни дисплея. Имайте предвид, че помощните дисплеи в момента не поддържат функционалността на менюто, като по този начин те не поддържат опциите "меню" или конфигурацията на бутоните.

```
[display my_extra_display]
# Вижте раздела "display" за наличните параметри.
```

### [menu]

Персонализируеми менюта на LCD дисплея.

Автоматично се създава [набор от менюта по подразбиране](../klippy/extras/display/menu.cfg). Човек може да замени или разшири менюто, като отмени настройките по подразбиране в основния конфигурационен файл printer.cfg.

See the [command template document](Command_Templates.md#menu-templates) for information on menu attributes available during template rendering.

```
# Общи параметри, достъпни за всички секции на конфигурацията на менюто.
#[меню __some_list __some_name]
#type: disabled
# Постоянно деактивиран елемент на менюто, единственият задължителен атрибут е 'type'.
# Позволява ви лесно да деактивирате/скривате съществуващи елементи от менюто.

#[menu some_name]
#type:
# Едно от следните: команда, вход, списък, текст:
# команда - основен елемент на менюто с различни скриптове за задействане
# вход - същото като "команда", но има възможност за промяна на стойността.
# Натискането ще стартира/спира режима на редактиране.
# списък - дава възможност за групиране на елементи от менюто в
# списък, който може да се превърта.  Добавяйте към списъка, като създавате меню
# конфигурации, използвайки "some_list" като префикс - за
# например: [menu some_list some_item_in_the_list]
# vsdlist - същото като 'list', но ще добавя файлове от виртуална карта sdcard
# (ще бъде премахнат в бъдеще)
#name:
# Име на елемент от менюто - оценява се като шаблон.
#enable:
# Шаблон, който се оценява на True или False.
#index:
# Позиция, в която елементът трябва да бъде вмъкнат в списъка. По подразбиране
# елементът се добавя в края.

#[меню some_list]
#тип: списък
#име:
#enable:
# Вижте по-горе за описание на тези параметри.

#[menu some_list some_command]
#тип: команда
#име:
#enable:
# Вижте по-горе за описание на тези параметри.
#gcode:
# Скрипт, който да се изпълнява при натискане на бутон или дълго натискане. Изчислява се като
# шаблон.

#[menu some_list some_input]
#тип: вход
#име:
#enable:
# Вижте по-горе за описание на тези параметри.
#input:
# Първоначална стойност, която да се използва при редактиране - оценява се като шаблон.
# Резултатът трябва да е float.
#input_min:
# Минимална стойност на обхвата - оценява се като шаблон. По подразбиране -99999.
#input_max:
# Максимална стойност на диапазона - оценява се като шаблон. По подразбиране - 99999.
#input_step:
# Стъпка на редактиране - Трябва да бъде положително цяло число или стойност float. Тя има
# вътрешна стъпка за бърза скорост. Когато "(input_max - input_min) /
# input_step > 100", тогава бързата стъпка на скоростта е 10 * input_step иначе fast
# стъпката на скоростта е същата като input_step.
#реално време:
# Този атрибут приема статична булева стойност. Когато е активиран, тогава
# gcode скриптът се изпълнява след всяка промяна на стойността. По подразбиране е False.
#gcode:
# Скрипт, който се изпълнява при щракване върху бутон, дълго щракване или промяна на стойността.
# Оценява се като шаблон. Кликването върху бутон ще задейства редактирането
# начало или край на режима.
```

## Сензори за нишки

### [filament_switch_sensor]

Сензор за превключване на нишките. Поддръжка за откриване на вмъкване на нишка и напускане на нишката с помощта на сензор за превключване, като например превключвател за край.

See the [command reference](G-Codes.md#filament_switch_sensor) for more information.

```
[filament_switch_sensor my_sensor]
#pause_on_runout: True
# Когато е зададено на True, PAUSE ще се изпълни веднага след изтичане
# се открива. Имайте предвид, че ако pause_on_runout е False и
# runout_gcode е пропуснат, тогава откриването на пробег е деактивирано. По подразбиране
# е True.
#runout_gcode:
# Списък с G-Code команди, които да се изпълняват след изтичане на нишката.
# открит. Вижте docs/Command_Templates.md за формата на G-Code. Ако
# pause_on_runout е зададена стойност True, този G-Code ще се изпълни след
# PAUSE е завършен. По подразбиране не се изпълняват никакви G-Code команди.
#insert_gcode:
# Списък с G-Code команди, които да се изпълняват след вмъкване на нишка.
# открит. Вижте docs/Command_Templates.md за формата на G-Code. В
# по подразбиране е да не се изпълняват никакви G-Code команди, което деактивира вмъкването
# откриване на вложка.
#event_delay: 3.0
# Минималното време в секунди за забавяне между събитията.
# Събитията, задействани по време на този период от време, ще бъдат безшумно
# игнорирани. По подразбиране е 3 секунди.
#pause_delay: 0.5
# Времето за забавяне, в секунди, между командата за пауза
# изпращането и изпълнението на runout_gcode. Може да е полезно да
# да увеличите това забавяне, ако OctoPrint показва странно поведение при пауза.
# По подразбиране е 0,5 секунди.
#switch_pin:
# Изводът, към който е свързан превключвателят. Този параметър трябва да бъде
# да бъде предоставен.
```

### [filament_motion_sensor]

Сензор за движение с нишки. Поддръжка за откриване на вмъкване и изтичане на нишка с помощта на енкодер, който превключва изходния щифт по време на движението на нишката през сензора.

See the [command reference](G-Codes.md#filament_switch_sensor) for more information.

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
# Минималната дължина на влакното, преминало през сензора, за да се задейства
# промяна на състоянието на превключвателя
# По подразбиране е 7 mm.
екструдер:
# Името на секцията на екструдера, с която е свързан този сензор.
# Този параметър трябва да бъде предоставен.
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
# Вижте раздела "filament_switch_sensor" за описание на
# горните параметри.
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

### [сензор_за_широчина_на_нишката_на_хол]

Сензор за ширина на нишката на Хол (вижте [Сензор за ширина на нишката на Хол](Hall_Filament_Width_Sensor.md)).

```
[hall_filament_width_sensor]
adc1:
adc2:
# Аналогови входни щифтове, свързани към сензора. Тези параметри трябва да
# да бъдат предоставени.
#cal_dia1: 1.50
#cal_dia2: 2,00
# Стойностите за калибриране (в мм) за сензорите. По подразбиране е
# 1,50 за cal_dia1 и 2,00 за cal_dia2.
#raw_dia1: 9500
#raw_dia2: 10500
# Суровите стойности за калибриране на сензорите. По подразбиране е 9500
# за raw_dia1 и 10500 за raw_dia2.
#default_nominal_filament_diameter: 1.75
# Номиналният диаметър на нишката. Този параметър трябва да бъде предоставен.
#max_difference: 0.200
# Максимално допустима разлика в диаметъра на нишките в милиметри (mm).
# Ако разликата между номиналния диаметър на влакното и изхода на сензора
# е по-голяма от +- max_difference, коефициентът на екструдиране се връща назад
# на 100 %. По подразбиране е 0,200.
#measurement_delay: 70
# Разстоянието от сензора до камерата за топене/горещия край в
# милиметри (mm). Нишката между сензора и горещия край
# ще бъде третирано като диаметър по подразбиране_номинален_диаметър на нишката. Домакин
# Модулът работи с FIFO логика. Той запазва всяка стойност на сензора и
# позиция в масив и ги връща обратно в правилната позиция. Този
# параметър трябва да бъде предоставен.
# разрешаване: False
# Сензорът се включва или изключва след включване на захранването. По подразбиране е
# disable.
#measurement_interval: 10
# Приблизителното разстояние (в мм) между показанията на сензора. На
# по подразбиране е 10 mm.
#logging: False
# Диаметърът на изхода към терминала и klipper.log може да бъде включен|от
# команда.
#min_diameter: 1.0
# Минимален диаметър за задействане на виртуалния сензор filament_switch_sensor.
#use_current_dia_while_delay: False
# Използвайте текущия диаметър вместо номиналния, докато
# закъснението на измерването не е изтекло.
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
# Вижте раздела "filament_switch_sensor" за описание на
# горните параметри.
```

## Специфична хардуерна поддръжка на борда

### [sx1509]

Конфигуриране на разширител SX1509 I2C към GPIO. Поради закъснението, което се получава при I2C комуникацията, НЕ трябва да използвате изводите на SX1509 като изводи за разрешаване на стъпковия механизъм, стъпка или дир или други изводи, които изискват бърза обработка на битове. Най-добре е те да се използват като статични или управлявани от gcode цифрови изходи или като хардуерни-pwm изводи, например за вентилатори. Може да се дефинират произволен брой секции с префикс "sx1509". Всеки разширител предоставя набор от 16 извода (sx1509_my_sx1509:PIN_0 до sx1509_my_sx1509:PIN_15), които могат да се използват в конфигурацията на принтера.

See the [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg) file for an example.

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

Аналогово мащабиране на Duet2 Maestro по показания на vref и vssa. Дефинирането на секция adc_scaled позволява използването на виртуални adc изводи (като например "my_name:PB0"), които се настройват автоматично от контролните изводи vref и vssa на платката. Не забравяйте да дефинирате тази секция за конфигуриране над всички секции за конфигуриране, които използват тези виртуални щифтове.

See the [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg) file for an example.

```
[adc_scaled my_name]
vref_pin:
# Изводът на АЦП, който ще се използва за наблюдение на VREF. Този параметър трябва да бъде
# да бъде предоставен.
vssa_pin:
# Изводът на ADC, който се използва за наблюдение на VSSA. Този параметър трябва да бъде
# осигурен.
#smooth_time: 2.0
# Стойност на времето (в секунди), през което vref и vssa
# измерванията ще бъдат изгладени, за да се намали въздействието на измерването
# шума. По подразбиране е 2 секунди.
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

Ако използвате този модул, не използвайте приставката Palette 2 за Octoprint, тъй като те ще си противоречат и 1 няма да успее да се инициализира правилно, което вероятно ще доведе до прекъсване на печата.

Ако използвате Octoprint и предавате gcode по серийния порт, вместо да печатате от virtual_sd, тогава ремо **M1** и **M0** от *Спирането на командите* в *Settings (Настройки) > Serial Connection (Серийна връзка) > Firmware & protocol (Фирмен софтуер и протокол)* ще предотврати необходимостта от стартиране на печатането на Palette 2 и отключване на паузата в Octoprint, за да започне вашето печатане.

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
#   Auto cancel print when ping variation is above this threshold
```

### [ъгъл]

Поддръжка на магнитен сензор за ъгъл на Хол за отчитане на измервания на ъгъла на вала на стъпковия двигател с помощта на SPI чипове a1333, as5047d или tle5012b. Измерванията са достъпни чрез [API Server](API_Server.md) и [инструмент за анализ на движението](Debugging.md#motion-analysis-and-data-logging). За наличните команди вижте [G-Code reference](G-Codes.md#angle).

```
[ъгъл my_angle_sensor]
sensor_type:
# Типът на чипа на магнитния сензор на Хол. Наличните варианти са
# "a1333", "as5047d" и "tle5012b". Този параметър трябва да бъде
# посочен.
#sample_period: 0.000400
# Периодът на запитване (в секунди), който ще се използва по време на измерванията. В
# по подразбиране е 0,000400 (което е 2500 проби в секунда).
#stepper:
# Името на стъпковия механизъм, към който е свързан сензорът за ъгъл (напр,
# "stepper_x"). Задаването на тази стойност позволява калибриране на ъгъла
# инструмент. За да се използва тази функция, трябва да се използва пакетът Python "numpy".
# инсталиран. По подразбиране не се разрешава калибрирането на ъгъла за
# ъглов сензор.
cs_pin:
# Изводът за разрешаване на SPI за сензора. Този параметър трябва да бъде предоставен.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# Вижте раздела "Общи настройки на SPI" за описание на
# горепосочените параметри.
```

## Общи параметри на шината

### Общи настройки на SPI

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

### Общи настройки на I2C

The following parameters are generally available for devices using an I2C bus.

Note that Klipper's current micro-controller support for I2C is generally not tolerant to line noise. Unexpected errors on the I2C wires may result in Klipper raising a run-time error. Klipper's support for error recovery varies between each micro-controller type. It is generally recommended to only use I2C devices that are on the same printed circuit board as the micro-controller.

Most Klipper micro-controller implementations only support an `i2c_speed` of 100000 (*standard mode*, 100kbit/s). The Klipper "Linux" micro-controller supports a 400000 speed (*fast mode*, 400kbit/s), but it must be [set in the operating system](RPi_microcontroller.md#optional-enabling-i2c) and the `i2c_speed` parameter is otherwise ignored. The Klipper "RP2040" micro-controller and ATmega AVR family support a rate of 400000 via the `i2c_speed` parameter. All other Klipper micro-controllers use a 100000 rate and ignore the `i2c_speed` parameter.

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
