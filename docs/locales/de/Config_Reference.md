# Konfigurationsreferenz

Dieses Dokument ist eine Referenz für Optionen, die in der Klipper-Konfigurationsdatei verfügbar sind.

Die Beschreibungen in diesem Dokument sind so formatiert, dass es möglich ist, sie auszuschneiden und in eine Druckerkonfigurationsdatei einzufügen. Siehe das [Installationsdokument](Installation.md) für Informationen über die Einrichtung von Klipper und die Auswahl einer ersten Konfigurationsdatei.

## Mikrocontroller-Konfiguration

### Format der Mikrocontroller Pin Namen

Viele Konfigurationsoptionen erfordern den Namen eines Mikrocontroller-Pins. Klipper verwendet für diese Pins die Hardwarenamen - zum Beispiel `PA4`.

Pin-Namen kann ein `!` vorangestellt werden, um anzugeben, dass eine umgekehrte Polarität verwendet werden soll (z. B. Auslösen bei Low statt bei High).

Eingangspins kann ein `^` vorangestellt werden, um anzugeben, dass für den Pin ein Hardware-Pull-up-Widerstand aktiviert werden soll. Wenn der Mikrocontroller Pull-down-Widerstände unterstützt, kann einem Eingangspin alternativ ein `~` vorangestellt werden.

Beachten Sie, dass einige Konfigurationsabschnitte zusätzliche Pins "erzeugen" können. Wo dies der Fall ist, muss der Konfigurationsabschnitt, der die Pins definiert, in der Konfigurationsdatei vor allen Abschnitten stehen, die diese Pins verwenden.

### [mcu]

Konfiguration des primären Mikrocontrollers.

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

Zusätzliche Mikrocontroller (Jemand kann eine beliebige Anzahl an Abschnitten mit einer "mcu"-Präfix definieren). Zusätzliche Mikrocontroller fügen zusätzliche Pins hinzu die als Heizeinheiten, Schrittmotor, Lüfter etc.. konfiguriert werden können. Zum Beispiel, wenn ein Abschnitt "[mcu extra_mcu]" hinzugefügt wird, können Pins wie "extra_mcu:ar9" (wo "ar9" ein Hardware-Pin-Name oder Alias-Name von dem gegebenen mcu ist) woanders in der Konfiguration benutzt werden.

```
[mcu my_extra_mcu]
# See the "mcu" section for configuration parameters.
```

## Gebräuchliche Kinematik Einstellungen

### [printer]

Der Abschnitt printer steuert übergeordnete Druckereinstellungen.

```
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid_corexy, hybrid_corexz, generic_cartesian,
#   rotary_delta, delta, deltesian, polar, winch, or none.
#   This parameter must be specified.
max_velocity:
#   Maximum velocity (in mm/s) of the toolhead (relative to the
#   print). This value may be changed at runtime using the
#   SET_VELOCITY_LIMIT command. This parameter must be specified.
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
```

### [stepper]

Definitionen der Schrittmotoren. Unterschiedliche Druckertypen (festgelegt über die Option "kinematics" im Konfigurationsabschnitt [printer]) erfordern unterschiedliche Namen für die Schrittmotoren (z. B. `stepper_x` gegenüber `stepper_a`). Nachfolgend die gängigen Schrittmotordefinitionen.

Informationen zur Berechnung des Parameters `rotation_distance` finden Sie im [Dokument zur Rotationsdistanz](Rotation_Distance.md). Informationen zum Homing mit mehreren Mikrocontrollern finden Sie im Dokument [Multi-MCU-Homing](Multi_MCU_Homing.md).

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

### Kartesische Kinematik

Eine Beispiel-Konfigurationsdatei für kartesische Kinematik finden Sie unter [example-cartesian.cfg](../config/example-cartesian.cfg).

Hier werden nur die Parameter beschrieben, die für kartesische Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

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

### Lineare Delta Kinematik

Eine Beispiel-Konfigurationsdatei für lineare Delta-Kinematik finden Sie unter [example-delta.cfg](../config/example-delta.cfg). Informationen zur Kalibrierung finden Sie in der [Anleitung zur Delta-Kalibrierung](Delta_Calibrate.md).

Hier werden nur die Parameter beschrieben, die für lineare Delta-Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

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

### Deltesische Kinematik

Eine Beispiel-Konfigurationsdatei für Deltesian-Kinematik finden Sie unter [example-deltesian.cfg](../config/example-deltesian.cfg).

Hier werden nur die Parameter beschrieben, die für Deltesian-Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

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

### CoreXY Kinematik

Eine Beispieldatei für CoreXY-Kinematik (und H-Bot) finden Sie unter [example-corexy.cfg](../config/example-corexy.cfg).

Hier werden nur die Parameter beschrieben, die für CoreXY-Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

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

### CoreXZ Kinematik

Eine Beispiel-Konfigurationsdatei für CoreXZ-Kinematik finden Sie unter [example-corexz.cfg](../config/example-corexz.cfg).

Hier werden nur die Parameter beschrieben, die für CoreXZ-Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

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

### Hybrid-CoreXY Kinematik

Eine Beispiel-Konfigurationsdatei für hybride CoreXY-Kinematik finden Sie unter [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg).

Diese Kinematik ist auch als Markforged-Kinematik bekannt.

Hier werden nur die Parameter beschrieben, die für hybride CoreXY-Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

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

### Hybrid-CoreXZ Kinematik

Eine Beispiel-Konfigurationsdatei für hybride CoreXZ-Kinematik finden Sie unter [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg).

Diese Kinematik ist auch als Markforged-Kinematik bekannt.

Hier werden nur die Parameter beschrieben, die für hybride CoreXY-Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

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

### Polar Kinematik

Eine Beispiel-Konfigurationsdatei für polare Kinematik finden Sie unter [example-polar.cfg](../config/example-polar.cfg).

Hier werden nur die Parameter beschrieben, die für polare Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

DIE POLARE KINEMATIK BEFINDET SICH IN ARBEIT. Es ist bekannt, dass Bewegungen um die Position 0, 0 nicht korrekt funktionieren.

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
# max_angular_velocity: 0
#   This limits the maximum angular velocity (in rad/s) of a move.
#   Lower values will result in longer print times, but prevents too
#   fast motions near the center. A value of 0 deactivates the
#   scaling. The default is to not apply maximum angular velocity limits.

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

### Rotierende Delta Kinematik

Eine Beispiel-Konfigurationsdatei für Rotary-Delta-Kinematik finden Sie unter [example-rotary-delta.cfg](../config/example-rotary-delta.cfg).

Hier werden nur die Parameter beschrieben, die für Rotary-Delta-Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

DIE ROTARY-DELTA-KINEMATIK BEFINDET SICH IN ARBEIT. Homing-Bewegungen können in eine Zeitüberschreitung laufen und einige Grenzwertprüfungen sind nicht implementiert.

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

### Seilwinden Kinematik

Eine Beispiel-Konfigurationsdatei für die Kinematik von Seilwinden-Druckern finden Sie unter [example-winch.cfg](../config/example-winch.cfg).

Hier werden nur die Parameter beschrieben, die für Seilwinden-Drucker spezifisch sind - die verfügbaren Parameter finden Sie unter [gemeinsame Kinematikeinstellungen](#common-kinematic-settings).

DIE UNTERSTÜTZUNG FÜR SEILWINDEN IST EXPERIMENTELL. Für die Seilwinden-Kinematik ist kein Homing implementiert. Um den Drucker zu homen, senden Sie manuell Bewegungsbefehle, bis der Druckkopf bei 0, 0, 0 steht, und setzen Sie anschließend einen `G28`-Befehl ab.

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

### Generische kartesische Kinematik

Eine Beispiel-Konfigurationsdatei für generische kartesische Kinematik finden Sie unter [example-generic-cartesian.cfg](../config/example-generic-caretesian.cfg).

Diese Kinematikklasse erlaubt es, auf recht flexible Weise eine beliebige Kinematik kartesischer Bauart zu definieren. Grundsätzlich lassen sich damit auch die regulären Kinematiken cartesian, corexy und hybrid_corexy definieren. Wichtiger ist jedoch, dass sich mit dieser Kinematik verschiedene ansonsten nicht unterstützte Kinematiken definieren lassen, etwa invertiertes hybrid_corexy oder corexyuv.

Bemerkenswert ist, dass die Definition einer generischen kartesischen Kinematik deutlich von den übrigen Kinematiktypen abweicht. Sie folgt dieser Konvention: Der Benutzer definiert eine Reihe von Schlitten mit einem bestimmten Bewegungsbereich, die sich unabhängig voneinander bewegen können (sie sollten sich entlang der kartesischen Achsen X, Y und Z bewegen, daher der Name der Kinematik), sowie zugehörige Endschalter, mit denen die Firmware die Position der Schlitten beim Homing bestimmen kann, und eine Reihe von Schrittmotoren, die diese Schlitten bewegen. Der Abschnitt `[printer]` muss die Kinematik und weitere druckerweite Einstellungen genauso angeben wie bei der regulären kartesischen Kinematik:

```
[printer]
kinematics: generic_cartesian
max_velocity:
max_accel:
#minimum_cruise_ratio:
#square_corner_velocity:
#max_z_velocity:
#max_z_accel:
```

Anschließend muss der Benutzer drei primäre Schlitten für die X-, Y- und Z-Achse definieren, z. B.:

```
[carriage carriage_x]
axis:
#   Axis of a carriage, either x, y, or z. This parameter must be provided,
#   unless a carriage name is x, y, or z itself.
endstop_pin:
#   Endstop switch detection pin. If this endstop pin is on a
#   different mcu than the stepper motor(s) moving this carriage,
#   then it enables "multi-mcu homing". This parameter must be provided.
#position_min: 0
#   Minimum valid distance (in mm) the user may command the carriage to
#   move to.  The default is 0mm.
position_endstop:
#   Location of the endstop (in mm). This parameter must be provided.
position_max:
#   Maximum valid distance (in mm) the user may command the stepper to
#   move to. This parameter must be provided.
#homing_speed: 5.0
#   Maximum velocity (in mm/s) of the carriage when homing. The default
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
#   Velocity (in mm/s) of the carriage when performing the second home.
#   The default is homing_speed/2.
#homing_positive_dir:
#   If true, homing will cause the carriage to move in a positive
#   direction (away from zero); if false, home towards zero. It is
#   better to use the default than to specify this parameter. The
#   default is true if position_endstop is near position_max and false
#   if near position_min.
```

Danach gibt der Benutzer die Schrittmotoren an, die diese Schlitten bewegen, zum Beispiel

```
[stepper my_stepper]
carriages:
#   A string describing the carriages the stepper moves. All defined
#   carriages can be specified here, as well as their linear combinations,
#   e.g. carriage_x, carriage_x+carriage_y, carriage_y-0.5*carriage_z,
#   carriage_x-carriage_z, etc. This parameter must be provided.
step_pin:
dir_pin:
enable_pin:
rotation_distance:
microsteps:
#full_steps_per_rotation: 200
#gear_ratio:
#step_pulse_duration:
```

Weitere Informationen zu den regulären Schrittmotorparametern finden Sie im Abschnitt [stepper](#stepper). Der Parameter `carriages` legt fest, wie der Schrittmotor die Bewegung der Schlitten beeinflusst. `carriage_x+carriage_y` bedeutet zum Beispiel, dass eine Bewegung des Schrittmotors in positiver Richtung um die Distanz `d` die Schlitten `carriage_x` und `carriage_y` um dieselbe Distanz `d` in positiver Richtung bewegt, während `carriage_x-0.5*carriage_y` bedeutet, dass eine Bewegung des Schrittmotors in positiver Richtung um die Distanz `d` den Schlitten `carriage_x` um die Distanz `d` in positiver Richtung bewegt, der Schlitten `carriage_y` jedoch die Distanz `d/2` in negativer Richtung zurücklegt.

Es kann mehr als ein Schrittmotor definiert werden, um dieselbe Achse oder denselben Riemen anzutreiben. Bei CoreXY-AWD-Aufbauten lassen sich zum Beispiel zwei Motoren, die denselben Riemen antreiben, so definieren:

```
[carriage carriage_x]
endstop_pin: ...
...

[carriage carriage_y]
endstop_pin: ...
...

[stepper a0]
carriages: carriage_x-carriage_y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...

[stepper a1]
carriages: carriage_x-carriage_y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...
```

wobei die Schrittmotoren `a0` und `a1` eigene Steuerpins besitzen, sich aber dieselben `carriages` und die zugehörigen Endschalter teilen.

Es gibt Situationen, in denen mehr als ein Endschalter pro Achse gewünscht ist. Beispiele für solche Konfigurationen sind eine Y-Achse, die von zwei unabhängigen Schrittmotoren angetrieben wird, deren Riemen an beiden Enden des X-Portals befestigt sind - wodurch es faktisch zwei Schlitten auf der Y-Achse mit jeweils eigenem Endschalter gibt -, sowie eine Z-Achse mit mehreren Schrittmotoren, bei der jeder Schrittmotor einen eigenen Endschalter besitzt (nicht zu verwechseln mit Konfigurationen mit mehreren Z-Motoren, aber nur einem einzigen Endschalter). Diese Konfigurationen lassen sich durch Angabe zusätzlicher Schlitten mit ihren Endschaltern deklarieren:

```
[extra_carriage my_carriage]
primary_carriage:
#   The name of the primary carriage this carriage corresponds to.
#   It also effectively defines the axis the carriage moves over.
#   This parameter must be provided.
endstop_pin:
#   Endstop switch detection pin. This parameter must be provided.
```

und die zugehörigen Schrittmotoren, zum Beispiel:

```
[extra_carriage carriage_y1]
primary_carriage: carriage_y
endstop_pin: ...

[stepper sy1]
carriages: carriage_y1
...
```

Bemerkenswert ist, dass ein `[extra_carriage]` keine Parameter wie `position_min`, `position_max` und `position_endstop` definiert, sondern sie vom angegebenen `primary_carriage` erbt und sich damit denselben Bewegungsbereich mit dem primären Schlitten teilt.

Hinweise zur Konfiguration von IDEX-Aufbauten finden Sie im Abschnitt [dual carriage](#dual-carriage).

### Keine Kinematik

Es ist möglich, eine spezielle Kinematik "none" zu definieren, um die Kinematikunterstützung in Klipper zu deaktivieren. Das kann für die Ansteuerung von Geräten nützlich sein, die keine typischen 3D-Drucker sind, oder zu Debugging-Zwecken.

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   The max_velocity and max_accel parameters must be defined. The
#   values are not used for "none" kinematics.
```

## Übliche Extruder und Heizbettunterstützung

### [extruder]

Der Abschnitt extruder beschreibt die Heizungsparameter des Hotends samt dem Schrittmotor, der den Extruder antreibt. Weitere Informationen finden Sie in der [Befehlsreferenz](G-Codes.md#extruder). Informationen zum Abstimmen von Pressure Advance finden Sie in der [Pressure-Advance-Anleitung](Pressure_Advance.md).

```
[extruder]
step_pin:
dir_pin:
enable_pin:
microsteps:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#   See the "stepper" section for a description of the above
#   parameters. If none of the above parameters are specified then no
#   stepper will be associated with the nozzle hotend (though a
#   SYNC_EXTRUDER_MOTION command may associate one at run-time).
nozzle_diameter:
#   Diameter of the nozzle orifice (in mm). This parameter must be
#   provided.
filament_diameter:
#   The nominal diameter of the raw filament (in mm) as it enters the
#   extruder. This parameter must be provided.
#max_extrude_cross_section:
#   Maximum area (in mm^2) of an extrusion cross section (eg,
#   extrusion width multiplied by layer height). This setting prevents
#   excessive amounts of extrusion during relatively small XY moves.
#   If a move requests an extrusion rate that would exceed this value
#   it will cause an error to be returned. The default is: 4.0 *
#   nozzle_diameter^2
#instantaneous_corner_velocity: 1.000
#   The maximum instantaneous velocity change (in mm/s) of the
#   extruder during the junction of two moves. The default is 1mm/s.
#max_extrude_only_distance: 50.0
#   Maximum length (in mm of raw filament) that a retraction or
#   extrude-only move may have. If a retraction or extrude-only move
#   requests a distance greater than this value it will cause an error
#   to be returned. The default is 50mm.
#max_extrude_only_velocity:
#max_extrude_only_accel:
#   Maximum velocity (in mm/s) and acceleration (in mm/s^2) of the
#   extruder motor for retractions and extrude-only moves. These
#   settings do not have any impact on normal printing moves. If not
#   specified then they are calculated to match the limit an XY
#   printing move with a cross section of 4.0*nozzle_diameter^2 would
#   have.
#pressure_advance: 0.0
#   The amount of raw filament to push into the extruder during
#   extruder acceleration. An equal amount of filament is retracted
#   during deceleration. It is measured in millimeters per
#   millimeter/second. The default is 0, which disables pressure
#   advance.
#pressure_advance_smooth_time: 0.040
#   A time range (in seconds) to use when calculating the average
#   extruder velocity for pressure advance. A larger value results in
#   smoother extruder movements. This parameter may not exceed 200ms.
#   This setting only applies if pressure_advance is non-zero. The
#   default is 0.040 (40 milliseconds).
#
# The remaining variables describe the extruder heater.
heater_pin:
#   PWM output pin controlling the heater. This parameter must be
#   provided.
#max_power: 1.0
#   The maximum power (expressed as a value from 0.0 to 1.0) that the
#   heater_pin may be set to. The value 1.0 allows the pin to be set
#   fully enabled for extended periods, while a value of 0.5 would
#   allow the pin to be enabled for no more than half the time. This
#   setting may be used to limit the total power output (over extended
#   periods) to the heater. The default is 1.0.
sensor_type:
#   Type of sensor - common thermistors are "EPCOS 100K B57560G104F",
#   "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Generic
#   3950","Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", and "TDK NTCG104LH104JT1". See the
#   "Temperature sensors" section for other sensors. This parameter
#   must be provided.
sensor_pin:
#   Analog input pin connected to the sensor. This parameter must be
#   provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the thermistor.
#   This parameter is only valid when the sensor is a thermistor. The
#   default is 4700 ohms.
#smooth_time: 1.0
#   A time value (in seconds) over which temperature measurements will
#   be smoothed to reduce the impact of measurement noise. The default
#   is 1 seconds.
control:
#   Control algorithm (either pid or watermark). This parameter must
#   be provided.
pid_Kp:
pid_Ki:
pid_Kd:
#   The proportional (pid_Kp), integral (pid_Ki), and derivative
#   (pid_Kd) settings for the PID feedback control system. Klipper
#   evaluates the PID settings with the following general formula:
#     heater_pwm = (Kp*error + Ki*integral(error) - Kd*derivative(error)) / 255
#   Where "error" is "requested_temperature - measured_temperature"
#   and "heater_pwm" is the requested heating rate with 0.0 being full
#   off and 1.0 being full on. Consider using the PID_CALIBRATE
#   command to obtain these parameters. The pid_Kp, pid_Ki, and pid_Kd
#   parameters must be provided for PID heaters.
#max_delta: 2.0
#   On 'watermark' controlled heaters this is the number of degrees in
#   Celsius above the target temperature before disabling the heater
#   as well as the number of degrees below the target before
#   re-enabling the heater. The default is 2 degrees Celsius.
#pwm_cycle_time: 0.100
#   Time in seconds for each software PWM cycle of the heater. It is
#   not recommended to set this unless there is an electrical
#   requirement to switch the heater faster than 10 times a second.
#   The default is 0.100 seconds.
#min_extrude_temp: 170
#   The minimum temperature (in Celsius) at which extruder move
#   commands may be issued. The default is 170 Celsius.
min_temp:
max_temp:
#   The maximum range of valid temperatures (in Celsius) that the
#   heater must remain within. This controls a safety feature
#   implemented in the micro-controller code - should the measured
#   temperature ever fall outside this range then the micro-controller
#   will go into a shutdown state. This check can help detect some
#   heater and sensor hardware failures. Set this range just wide
#   enough so that reasonable temperatures do not result in an error.
#   These parameters must be provided.
```

### [heater_bed]

Der Abschnitt heater_bed beschreibt ein beheiztes Bett. Er verwendet dieselben Heizungseinstellungen, die im Abschnitt "extruder" beschrieben sind.

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

## Bett Nivelierung Unterstützung

### [bed_mesh]

Mesh Bed Leveling. Man kann einen Konfigurationsabschnitt bed_mesh definieren, um Bewegungstransformationen zu aktivieren, die die Z-Achse anhand eines aus Messpunkten erzeugten Meshes versetzen. Wenn eine Sonde für das Homing der Z-Achse verwendet wird, wird empfohlen, in der printer.cfg einen Abschnitt safe_z_home zu definieren, um in Richtung der Mitte des Druckbereichs zu homen.

Weitere Informationen finden Sie in der [Bed-Mesh-Anleitung](Bed_Mesh.md) und in der [Befehlsreferenz](G-Codes.md#bed_mesh).

Visuelle Beispiele:

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

Druckbett verzug Kompensierung. Ein Konfigurationseintrag ermöglicht das Entgegenwirken des Verzugs durch eine aktive Anpassung der Bewegungen. Beachte, bed_mesh und bed_tilt sind nicht mit einander kombinierbar; es kann nur eine der beiden Optionen existieren.

Siehe die [command reference](G-Codes.md#bed_tilt) für weitere Informationen.

```
[bed_tilt]
#x_adjust: 0
#   The amount to add to each move's Z height for each mm on the X
#   axis. The default is 0.
#y_adjust: 0
#   The amount to add to each move's Z height for each mm on the Y
#   axis. The default is 0.
#z_adjust: 0
#   The amount to add to the Z height when the nozzle is nominally at
#   0, 0. The default is 0.
# The remaining parameters control a BED_TILT_CALIBRATE extended
# g-code command that may be used to calibrate appropriate x and y
# adjustment parameters.
#points:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) that should be probed during a BED_TILT_CALIBRATE
#   command. Specify coordinates of the nozzle and be sure the probe
#   is above the bed at the given nozzle coordinates. The default is
#   to not enable the command.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### [bed_screws]

Werkzeug zur Unterstützung beim Einstellen der Bettnivellierschrauben. Man kann einen Konfigurationsabschnitt [bed_screws] definieren, um den G-Code-Befehl BED_SCREWS_ADJUST zu aktivieren.

Weitere Informationen finden Sie in der [Nivellierungsanleitung](Manual_Level.md#adjusting-bed-leveling-screws) und in der [Befehlsreferenz](G-Codes.md#bed_screws).

```
[bed_screws]
#screw1:
#   The X, Y coordinate of the first bed leveling screw. This is a
#   position to command the nozzle to that is directly above the bed
#   screw (or as close as possible while still being above the bed).
#   This parameter must be provided.
#screw1_name:
#   An arbitrary name for the given screw. This name is displayed when
#   the helper script runs. The default is to use a name based upon
#   the screw XY location.
#screw1_fine_adjust:
#   An X, Y coordinate to command the nozzle to so that one can fine
#   tune the bed leveling screw. The default is to not perform fine
#   adjustments on the bed screw.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#   Additional bed leveling screws. At least three screws must be
#   defined.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   when moving from one screw location to the next. The default is 5.
#probe_height: 0
#   The height of the probe (in mm) after adjusting for the thermal
#   expansion of bed and nozzle. The default is zero.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#probe_speed: 5
#   The speed (in mm/s) when moving from a horizontal_move_z position
#   to a probe_height position. The default is 5.
```

### [screws_tilt_adjust]

Werkzeug zur Unterstützung beim Einstellen der Neigung über die Bettschrauben mithilfe der Z-Sonde. Man kann einen Konfigurationsabschnitt screws_tilt_adjust definieren, um den G-Code-Befehl SCREWS_TILT_CALCULATE zu aktivieren.

Weitere Informationen finden Sie in der [Nivellierungsanleitung](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) und in der [Befehlsreferenz](G-Codes.md#screws_tilt_adjust).

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

Neigungsausgleich über mehrere Z-Schrittmotoren. Diese Funktion ermöglicht die unabhängige Anpassung mehrerer Z-Schrittmotoren (siehe Abschnitt "stepper_z1"), um eine Neigung auszugleichen. Ist dieser Abschnitt vorhanden, steht der erweiterte [G-Code-Befehl](G-Codes.md#z_tilt) Z_TILT_ADJUST zur Verfügung.

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

Nivellierung eines beweglichen Portals mit 4 unabhängig angesteuerten Z-Motoren. Korrigiert Effekte eines hyperbolischen Paraboloids (Kartoffelchip-Effekt) an beweglichen Portalen, die nachgiebiger sind. WARNUNG: Die Verwendung bei einem beweglichen Bett kann zu unerwünschten Ergebnissen führen. Ist dieser Abschnitt vorhanden, steht der erweiterte G-Code-Befehl QUAD_GANTRY_LEVEL zur Verfügung. Diese Routine setzt die folgende Anordnung der Z-Motoren voraus:

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

Dabei ist x der Punkt 0, 0 auf dem Bett

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

Korrektur der Druckerschrägstellung. Es ist möglich, die Schrägstellung des Druckers softwareseitig in den drei Ebenen XY, XZ und YZ zu korrigieren. Dazu druckt man ein Kalibriermodell entlang einer Ebene und misst drei Längen. Aufgrund der Funktionsweise der Schrägkorrektur werden diese Längen per G-Code gesetzt. Einzelheiten finden Sie unter [Skew Correction](Skew_Correction.md) und in der [Befehlsreferenz](G-Codes.md#skew_correction).

```
[skew_correction]
```

### [z_thermal_adjust]

Temperaturabhängige Anpassung der Z-Position des Druckkopfes. Gleicht die durch Wärmeausdehnung des Druckerrahmens verursachte vertikale Bewegung des Druckkopfes in Echtzeit mithilfe eines Temperatursensors aus (der üblicherweise an einem vertikalen Rahmenabschnitt angebracht ist).

Siehe auch: [erweiterte g-Code-Befehle](G-Codes.md#z_thermal_adjust).

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

## Benutzerdefiniertes Homing

### [safe_z_home]

Sicheres Z-Homing. Über diesen Mechanismus kann die Z-Achse an einer bestimmten X-, Y-Koordinate gehomt werden. Das ist nützlich, wenn der Druckkopf zum Beispiel erst in die Bettmitte fahren muss, bevor Z gehomt werden kann.

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

Homing-Überschreibung (homing override). Über diesen Mechanismus kann anstelle eines im normalen G-Code-Eingang enthaltenen G28 eine Reihe von G-Code-Befehlen ausgeführt werden. Das kann bei Druckern nützlich sein, die ein spezielles Verfahren für das Homing der Maschine erfordern.

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

Endschalter mit Schrittphasenanpassung. Um diese Funktion zu nutzen, definieren Sie einen Konfigurationsabschnitt mit dem Präfix "endstop_phase", gefolgt vom Namen des zugehörigen Schrittmotor-Konfigurationsabschnitts (zum Beispiel "[endstop_phase stepper_z]"). Diese Funktion kann die Genauigkeit von Endschaltern verbessern. Fügen Sie eine reine Deklaration "[endstop_phase]" hinzu, um den Befehl ENDSTOP_PHASE_CALIBRATE zu aktivieren.

Weitere Informationen finden Sie in der [Anleitung zu Endschalterphasen](Endstop_Phase.md) und in der [Befehlsreferenz](G-Codes.md#endstop_phase).

```
[endstop_phase stepper_z]
#endstop_accuracy:
#   Sets the expected accuracy (in mm) of the endstop. This represents
#   the maximum error distance the endstop may trigger (eg, if an
#   endstop may occasionally trigger 100um early or up to 100um late
#   then set this to 0.200 for 200um). The default is
#   4*rotation_distance/full_steps_per_rotation.
#trigger_phase:
#   This specifies the phase of the stepper motor driver to expect
#   when hitting the endstop. It is composed of two numbers separated
#   by a forward slash character - the phase and the total number of
#   phases (eg, "7/64"). Only set this value if one is sure the
#   stepper motor driver is reset every time the mcu is reset. If this
#   is not set, then the stepper phase will be detected on the first
#   home and that phase will be used on all subsequent homes.
#endstop_align_zero: False
#   If true then the position_endstop of the axis will effectively be
#   modified so that the zero position for the axis occurs at a full
#   step on the stepper motor. (If used on the Z axis and the print
#   layer height is a multiple of a full step distance then every
#   layer will occur on a full step.) The default is False.
```

## G-Code Makros und Ereignisse

### [gcode_macro]

G-Code-Makros (man kann beliebig viele Abschnitte mit dem Präfix "gcode_macro" definieren). Weitere Informationen finden Sie in der [Anleitung zu Befehlsvorlagen](Command_Templates.md).

```
[gcode_macro my_cmd]
#gcode:
#   A list of G-Code commands to execute in place of "my_cmd". See
#   docs/Command_Templates.md for G-Code format. This parameter must
#   be provided.
#variable_<name>:
#   One may specify any number of options with a "variable_" prefix.
#   The given variable name will be assigned the given value (parsed
#   as a Python literal) and will be available during macro expansion.
#   For example, a config with "variable_fan_speed = 75" might have
#   gcode commands containing "M106 S{ fan_speed * 255 }". Variables
#   can be changed at run-time using the SET_GCODE_VARIABLE command
#   (see docs/Command_Templates.md for details). Variable names may
#   not use upper case characters.
#rename_existing:
#   This option will cause the macro to override an existing G-Code
#   command and provide the previous definition of the command via the
#   name provided here. This can be used to override builtin G-Code
#   commands. Care should be taken when overriding commands as it can
#   cause complex and unexpected results. The default is to not
#   override an existing G-Code command.
#description: G-Code macro
#   This will add a short description used at the HELP command or while
#   using the auto completion feature. Default "G-Code macro"
```

### [delayed_gcode]

Einen G-Code nach einer festgelegten Verzögerung ausführen. Weitere Informationen finden Sie in der [Anleitung zu Befehlsvorlagen](Command_Templates.md#delayed-gcodes) und in der [Befehlsreferenz](G-Codes.md#delayed_gcode).

```
[delayed_gcode my_delayed_gcode]
gcode:
#   A list of G-Code commands to execute when the delay duration has
#   elapsed. G-Code templates are supported. This parameter must be
#   provided.
#initial_duration: 0.0
#   The duration of the initial delay (in seconds). If set to a
#   non-zero value the delayed_gcode will execute the specified number
#   of seconds after the printer enters the "ready" state. This can be
#   useful for initialization procedures or a repeating delayed_gcode.
#   If set to 0 the delayed_gcode will not execute on startup.
#   Default is 0.
```

### [save_variables]

Unterstützung für das Speichern von Variablen auf der Festplatte, sodass sie über Neustarts hinweg erhalten bleiben. Weitere Informationen finden Sie unter [Befehlsvorlagen](Command_Templates.md#save-variables-to-disk) und in der [G-Code-Referenz](G-Codes.md#save_variables).

```
[save_variables]
filename:
#   Required - provide a filename that would be used to save the
#   variables to disk e.g. ~/variables.cfg
```

### [idle_timeout]

Leerlauf-Zeitüberschreitung. Eine Leerlauf-Zeitüberschreitung ist automatisch aktiviert - fügen Sie einen expliziten Konfigurationsabschnitt idle_timeout hinzu, um die Standardeinstellungen zu ändern.

```
[idle_timeout]
#gcode:
#   A list of G-Code commands to execute on an idle timeout. See
#   docs/Command_Templates.md for G-Code format. The default is to run
#   "TURN_OFF_HEATERS" and "M84".
#timeout: 600
#   Idle time (in seconds) to wait before running the above G-Code
#   commands. The default is 600 seconds.
```

## Optionale G-Code Funktionen

### [virtual_sdcard]

Eine virtuelle SD Karte kann dann hilfreich sein, wenn der Host Computer  nicht schnell genug ist Octoprint flüssig auszuführen. Es erlaubt  der Klipper Software  direkt  Gcode aus einem Verzeichnis auf dem Host zu drucken bei Benutzung von Standard G-Code Kommandos (z.b. M24)

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

Bei manchen Druckern mit Funktionen zum Freiräumen des Druckbereichs, etwa einem Bauteilauswerfer oder einem Banddrucker, kann es sinnvoll sein, Abschnitte der SD-Karten-Datei in einer Schleife auszuführen. (Zum Beispiel, um dasselbe Bauteil immer wieder zu drucken oder einen Abschnitt eines Bauteils für eine Kette oder ein anderes sich wiederholendes Muster zu wiederholen.)

Die unterstützten Befehle finden Sie in der [Befehlsreferenz](G-Codes.md#sdcard_loop). Ein zu Marlin kompatibles M808-G-Code-Makro finden Sie in der Datei [sample-macros.cfg](../config/sample-macros.cfg).

```
[sdcard_loop]
```

### [force_move]

Unterstützung für das manuelle Bewegen von Schrittmotoren zu Diagnosezwecken. Beachten Sie, dass die Verwendung dieser Funktion den Drucker in einen ungültigen Zustand versetzen kann - wichtige Einzelheiten finden Sie in der [Befehlsreferenz](G-Codes.md#force_move).

```
[force_move]
#enable_force_move: False
#   Set to true to enable FORCE_MOVE and SET_KINEMATIC_POSITION
#   extended G-Code commands. The default is false.
```

### [pause_resume]

Pause-/Fortsetzen-Funktionalität mit Unterstützung für das Erfassen und Wiederherstellen der Position. Weitere Informationen finden Sie in der [Befehlsreferenz](G-Codes.md#pause_resume).

```
[pause_resume]
#recover_velocity: 50.
#   When capture/restore is enabled, the speed at which to return to
#   the captured position (in mm/s). Default is 50.0 mm/s.
```

### [firmware_retraction]

Firmwareseitiger Filamentrückzug. Damit werden die G-Code-Befehle G10 (Rückzug) und G11 (Rückzug zurücknehmen) aktiviert, die von vielen Slicern gesendet werden. Die nachfolgenden Parameter legen die Startwerte fest; die Werte lassen sich jedoch über den [Befehl](G-Codes.md#firmware_retraction) SET_RETRACTION anpassen, was filamentspezifische Einstellungen und eine Abstimmung zur Laufzeit ermöglicht.

```
[firmware_retraction]
#retract_length: 0
#   The length of filament (in mm) to retract when G10 is activated,
#   and to unretract when G11 is activated (but see
#   unretract_extra_length below). The default is 0 mm.
#retract_speed: 20
#   The speed of retraction, in mm/s. The default is 20 mm/s.
#unretract_extra_length: 0
#   The length (in mm) of *additional* filament to add when
#   unretracting.
#unretract_speed: 10
#   The speed of unretraction, in mm/s. The default is 10 mm/s.
```

### [gcode_arcs]

Unterstützung für gcode arc (G2/G3) Befehle.

```
[gcode_arcs]
#resolution: 1.0
#   An arc will be split into segments. Each segment's length will
#   equal the resolution in mm set above. Lower values will produce a
#   finer arc, but also more work for your machine. Arcs smaller than
#   the configured value will become straight lines. The default is
#   1mm.
```

### [respond]

Aktiviert die erweiterten [Befehle](G-Codes.md#respond) "M118" und "RESPOND".

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

Aktiviert die Unterstützung dafür, einzelne Objekte während des Druckvorgangs auszuschließen oder abzubrechen.

Weitere Informationen finden Sie in der [Anleitung zum Ausschließen von Objekten](Exclude_Object.md) und in der [Befehlsreferenz](G-Codes.md#excludeobject). Ein zu Marlin/RepRapFirmware kompatibles M486-G-Code-Makro finden Sie in der Datei [sample-macros.cfg](../config/sample-macros.cfg).

```
[exclude_object]
```

## Resonanzkompensation

### [input_shaper]

Aktiviert  [resonance compensation](Resonance_Compensation.md). Siehe auch [command reference](G-Codes.md#input_shaper).

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
#shaper_freq_z: 0
#   A frequency (in Hz) of the input shaper for Z axis. The default
#   value is 0, which disables input shaping for Z axis.
#shaper_type: mzv
#   A type of the input shaper to use for all axes. Supported
#   shapers are zv, mzv, zvd, ei, 2hump_ei, and 3hump_ei. Some shapers
#   support optional additional parameters, e.g. mzv(n=4,t=0.9) or
#   ei(v_tol=0.1). The default is mzv input shaper (without parameters).
#shaper_type_x:
#shaper_type_y:
#shaper_type_z:
#   If shaper_type is not set, these parameters can be used to
#   configure different input shapers for X, Y, and Z axes. The same
#   values are supported as for shaper_type parameter.
#damping_ratio_x: 0.1
#damping_ratio_y: 0.1
#damping_ratio_z: 0.1
#   Damping ratios of vibrations of X and Y axes used by input shapers
#   to improve vibration suppression. Default value is 0.1 which is a
#   good all-round value for most printers. In most circumstances this
#   parameter requires no tuning and should not be changed.
```

### [adxl345]

Unterstützung für ADXL345-Beschleunigungssensoren. Damit lassen sich Beschleunigungsmesswerte vom Sensor abfragen. Dies aktiviert den Befehl ACCELEROMETER_MEASURE (weitere Informationen siehe [G-Codes](G-Codes.md#adxl345)). Der Standard-Chipname lautet "default", man kann jedoch einen expliziten Namen angeben (z. B. [adxl345 my_chip_name]).

```
Gängige SPI Einstellungen
```

### [icm20948]

Unterstützung für icm20948-Beschleunigungssensoren.

```
[icm20948]
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

### [lis2dw]

Unterstützung für LIS2DW Beschleunigungsmesser.

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

Unterstützung für LIS3DH-Beschleunigungssensoren.

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

### [bmi160]

BMI160-Beschleunigungssensor. Dieser Sensor kann über den I2C- oder den SPI-Bus abgefragt werden.

```
[bmi160]
#i2c_address:
#   Default is 105 (0x69). If SA0 is tied to GND, use 104 (0x68).
#   Only used for I2C.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters. Only used for I2C.
#cs_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters. Only used for SPI.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

**Wichtig:** Viele BMI160-Module verwenden mehrdeutige Pin-Beschriftungen. Für SPI gilt:

- Verwenden Sie **SCL** für den Takt (nicht SCX)
- Verwenden Sie **SDA** für MOSI (nicht SDX)
- Verwenden Sie **SA0** für MISO
- Verwenden Sie **CS** für Chip Select

Die mit SCX/SDX beschrifteten Pins sind für den zusätzlichen Magnetometer-Bus vorgesehen.

### [mpu9250]

Unterstützung für die Beschleunigungssensoren MPU-9250, MPU-9255, MPU-6515, MPU-6050 und MPU-6500 (man kann beliebig viele Abschnitte mit dem Präfix "mpu9250" definieren).

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

Unterstützung für Resonanztests und die automatische Kalibrierung des Input Shapers. Um den größten Teil der Funktionalität dieses Moduls zu nutzen, müssen zusätzliche Softwareabhängigkeiten installiert werden; weitere Informationen finden Sie unter [Resonanzen messen](Measuring_Resonances.md) und in der [Befehlsreferenz](G-Codes.md#resonance_tester). Weitere Informationen zum Parameter `max_smoothing` und seiner Verwendung finden Sie im Abschnitt [Max smoothing](Measuring_Resonances.md#max-smoothing) der Anleitung zum Messen von Resonanzen.

```
[resonance_tester]
#probe_points:
#   A list of X, Y, Z coordinates of points (one point per line) to test
#   resonances at. At least one point is required. Make sure that all
#   points with some safety margin in XY plane (~a few centimeters)
#   are reachable by the toolhead.
#accel_chip:
#   A name of the accelerometer chip to use for measurements. If
#   an accelerometer was defined without an explicit name, this parameter
#   can simply reference it by type, e.g. "accel_chip: adxl345", otherwise
#   a full name must be supplied, e.g. "accel_chip: adxl345 my_chip_name".
#   Either this, or the next two parameters must be set.
#accel_chip_x:
#accel_chip_y:
#   Names of the accelerometer chips to use for measurements for each
#   of the axis. Can be useful, for instance, on bed slinger printer,
#   if two separate accelerometers are mounted on the bed (for Y axis)
#   and on the toolhead (for X axis). These parameters have the same
#   format as 'accel_chip' parameter. Only 'accel_chip' or these two
#   parameters must be provided.
#accel_chip_z:
#   A name of the accelerometer chip to use for measurements of Z axis.
#   This parameter has the same format as 'accel_chip'. The default is
#   not to configure an accelerometer for Z axis.
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
#max_freq: 135
#   Maximum frequency to test for resonances. The default is 135 Hz.
#max_freq_z: 100
#   Maximum frequency to test Z axis for resonances. The default is 100 Hz.
#accel_per_hz: 60
#   This parameter is used to determine which acceleration to use to
#   test a specific frequency: accel = accel_per_hz * freq. Higher the
#   value, the higher is the energy of the oscillations. Can be set to
#   a lower than the default value if the resonances get too strong on
#   the printer. However, lower values make measurements of high-frequency
#   resonances less precise. The default value is 60 (mm/sec).
#accel_per_hz_z: 15
#   This parameter has the same meaning as accel_per_hz, but applies to
#   Z axis specifically. The default is 15 (mm/sec).
#hz_per_sec: 1
#   Determines the speed of the test. When testing all frequencies in
#   range [min_freq, max_freq], each second the frequency increases by
#   hz_per_sec. Small values make the test slow, and the large values
#   will decrease the precision of the test. The default value is 1.0
#   (Hz/sec == sec^-2).
#sweeping_accel: 400
#   An acceleration of slow sweeping moves. The default is 400 mm/sec^2.
#sweeping_accel_z: 50
#   Same as sweeping_accel above, but for Z axis. The default is 50 mm/sec^2.
#sweeping_period: 1.2
#   A period of slow sweeping moves. Setting this parameter to 0
#   disables slow sweeping moves. Avoid setting it to a too small
#   non-zero value in order to not poison the measurements.
#   The default is 1.2 sec which is a good all-round choice.
```

## Hilfsmittel für Konfigurationsdateien

### [board_pins]

Board Pin Pseudonym (Es können mehrere Einträge mit dem "board_pins" prefix angelegt werden). Nutze dies um ein Pseudonym für Mikrocontroller Pins zu erstellen.

```
[board_pins my_aliases]
mcu: mcu
#   A comma separated list of micro-controllers that may use the
#   aliases. The default is to apply the aliases to the main "mcu".
aliases:
aliases_<name>:
#   A comma separated list of "name=value" aliases to create for the
#   given micro-controller. For example, "EXP1_1=PE6" would create an
#   "EXP1_1" alias for the "PE6" pin. However, if "value" is enclosed
#   in "<>" then "name" is created as a reserved pin (for example,
#   "EXP1_9=<GND>" would reserve "EXP1_9"). Any number of options
#   starting with "aliases_" may be specified.
```

### [include]

Unterstützung für Include-Dateien. Man kann aus der Haupt-Konfigurationsdatei des Druckers weitere Konfigurationsdateien einbinden. Es können auch Platzhalter verwendet werden (z. B. "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

Dieses Werkzeug erlaubt es, einen einzelnen Mikrocontroller-Pin in einer Konfigurationsdatei mehrfach zu definieren, ohne die übliche Fehlerprüfung. Es ist für Diagnose- und Debugging-Zwecke gedacht. Dieser Abschnitt wird dort nicht benötigt, wo Klipper die mehrfache Verwendung desselben Pins ohnehin unterstützt; die Verwendung dieser Überschreibung kann zu verwirrenden und unerwarteten Ergebnissen führen.

```
[duplicate_pin_override]
pins:
#   A comma separated list of pins that may be used multiple times in
#   a config file without normal error checks. This parameter must be
#   provided.
```

## Bett Nivelierung Sensor

### [probe]

Z-Höhensonde. Man kann diesen Abschnitt definieren, um die Hardware zur Z-Höhenmessung zu aktivieren. Wenn dieser Abschnitt aktiviert ist, stehen die erweiterten [G-Code-Befehle](G-Codes.md#probe) PROBE und QUERY_PROBE zur Verfügung. Siehe auch die [Anleitung zur Sondenkalibrierung](Probe_Calibrate.md). Der Abschnitt probe erzeugt außerdem einen virtuellen Pin "probe:z_virtual_endstop". Bei kartesischen Druckern, die die Sonde anstelle eines Z-Endschalters verwenden, kann man den endstop_pin von stepper_z auf diesen virtuellen Pin setzen. Wenn "probe:z_virtual_endstop" verwendet wird, definieren Sie im Konfigurationsabschnitt stepper_z keinen position_endstop.

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
#   Speed (in mm/s) of the Z axis when probing. It may be possible to
#   change this value at runtime via a "PROBE_SPEED" command
#   parameter. The default is 5mm/s.
#samples: 1
#   The number of times to probe each point. The probed z-values will
#   be averaged. It may be possible to change this value at runtime
#   via a "SAMPLES" command parameter. The default is to probe 1 time.
#sample_retract_dist: 2.0
#   The distance (in mm) to lift the toolhead between each sample (if
#   sampling more than once). It may be possible to change this value
#   at runtime via a "SAMPLE_RETRACT_DIST" command parameter. The
#   default is 2mm.
#lift_speed:
#   Speed (in mm/s) of the Z axis when lifting the probe between
#   samples. It may be possible to change this value at runtime via a
#   "LIFT_SPEED" command parameter. The default is to use the same
#   value as the 'speed' parameter.
#samples_result: average
#   The calculation method when sampling more than once - either
#   "median" or "average". It may be possible to change this value at
#   runtime via a "SAMPLES_RESULT" command parameter. The default is
#   average.
#samples_tolerance: 0.100
#   The maximum Z distance (in mm) that a sample may differ from other
#   samples. If this tolerance is exceeded then either an error is
#   reported or the attempt is restarted (see
#   samples_tolerance_retries). It may be possible to change this
#   value at runtime via a "SAMPLES_TOLERANCE" command parameter. The
#   default is 0.100mm.
#samples_tolerance_retries: 0
#   The number of times to retry if a sample is found that exceeds
#   samples_tolerance. On a retry, all current samples are discarded
#   and the probe attempt is restarted. If a valid set of samples are
#   not obtained in the given number of retries then an error is
#   reported. It may be possible to change this value at runtime via a
#   "SAMPLES_TOLERANCE_RETRIES" command parameter. The default is zero
#   which causes an error to be reported on the first sample that
#   exceeds samples_tolerance.
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

BLTouch Probe. Ein Eintrag definiert und schaltet die Nutzung des BLTouch (oder ähnlich arbeitenden) Probe frei (anstelle der Probe Sektion). Siehe [BL-Touch guide](BLTouch.md) und [command reference](G-Codes.md#bltouch) für mehr und detailliertere Informationen. Ein virtueller "probe:z_virtual_endstop" Pin wird mit diesem Eintrag verfügbar und kann genutzt werden (siehe die "probe" Sektion für mehr und detailliertere Informationen).

```
[bltouch]
sensor_pin:
#   Pin connected to the BLTouch sensor pin. Most BLTouch devices
#   require a pullup on the sensor pin (prefix the pin name with "^").
#   This parameter must be provided.
control_pin:
#   Pin connected to the BLTouch control pin. This parameter must be
#   provided.
#pin_move_time: 0.680
#   The amount of time (in seconds) to wait for the BLTouch pin to
#   move up or down. The default is 0.680 seconds.
#stow_on_each_sample: True
#   This determines if Klipper should command the pin to move up
#   between each probe attempt when performing a multiple probe
#   sequence. Read the directions in docs/BLTouch.md before setting
#   this to False. The default is True.
#probe_with_touch_mode: False
#   If this is set to True then Klipper will probe with the device in
#   "touch_mode". The default is False (probing in "pin_down" mode).
#pin_up_reports_not_triggered: True
#   Set if the BLTouch consistently reports the probe in a "not
#   triggered" state after a successful "pin_up" command. This should
#   be True for all genuine BLTouch devices. Read the directions in
#   docs/BLTouch.md before setting this to False. The default is True.
#pin_up_touch_mode_reports_triggered: True
#   Set if the BLTouch consistently reports a "triggered" state after
#   the commands "pin_up" followed by "touch_mode". This should be
#   True for all genuine BLTouch devices. Read the directions in
#   docs/BLTouch.md before setting this to False. The default is True.
#set_output_mode:
#   Request a specific sensor pin output mode on the BLTouch V3.0 (and
#   later). This setting should not be used on other types of probes.
#   Set to "5V" to request a sensor pin output of 5 Volts (only use if
#   the controller board needs 5V mode and is 5V tolerant on its input
#   signal line). Set to "OD" to request the sensor pin output use
#   open drain mode. The default is to not request an output mode.
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
#   See the "probe" section for information on these parameters.
```

### [smart_effector]

Der "Smart Effector" von Duet3d realisiert eine Z-Sonde mithilfe eines Kraftsensors. Man kann diesen Abschnitt anstelle von `[probe]` definieren, um die spezifischen Funktionen des Smart Effector zu aktivieren. Dadurch werden außerdem [Laufzeitbefehle](G-Codes.md#smart_effector) aktiviert, mit denen sich die Parameter des Smart Effector zur Laufzeit anpassen lassen.

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

### [probe_eddy_current]

Unterstützung für induktive Wirbelstromsonden. Man kann diesen Abschnitt (anstelle eines probe-Abschnitts) definieren, um diese Sonde zu aktivieren. Weitere Informationen finden Sie in der [Befehlsreferenz](G-Codes.md#probe_eddy_current).

```
[probe_eddy_current my_eddy_probe]
sensor_type: ldc1612
#   The sensor chip used to perform eddy current measurements. This
#   parameter must be provided and must be set to ldc1612.
#frequency:
#   The external crystal frequency (in Hz) of the LDC1612 chip.
#   The default is 12000000.
#intb_pin:
#   MCU gpio pin connected to the ldc1612 sensor's INTB pin (if
#   available). The default is to not use the INTB pin.
#max_sensor_hz:
#   Maximum expected resonant frequency reported by the sensor (in
#   Hz). This is used during internal clock rate configuration. This
#   value is typically only configured if the software reports a
#   warning suggesting the value should be increased. The default is
#   5000000.
#descend_z:
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
#   The distance (in mm) between the probe and the nozzle along the
#   x and y axes. The default is 0.
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   See the "probe" section for information on these parameters. Note
#   that the settings here apply only to regular probe commands. These
#   settings do not have an effect if using a probe "METHOD" of
#   "scan", "rapid_scan", or "tap".
#tap_threshold:
#   Descent stop threshold (in Hz/mm) for "tap" probing. Larger values
#   reduce the chance of the toolhead incorrectly stopping early due
#   to noise, while increasing the risk of the toolhead not correctly
#   stopping when it first contacts the bed. See Eddy_Probe.md for
#   more information. This value may be overridden at run-time using
#   the "TAP_THRESHOLD" parameter on probe commands.  The default is
#   to not enable "tap" probing.
#tap_z_offset: 0.0
#   The Z height (in mm) of the nozzle relative to the bed at the
#   contact point detected during "tap" probing. Nominally this would
#   be 0.0 to indicate the contact point has zero distance, but one
#   may set this to account for backlash, thermal expansion, a
#   systemic probing bias, or similar. The default is zero.
```

### [axis_twist_compensation]

Ein Werkzeug um ungenaue Probe Werte durch Verzug in der X und Y Achse zu kompensieren. Siehe [Axis Twist Kompensation Guide] (Axis_Twist_Compensation.md) für mehr detaillierte Informationen über symptome, konfiguration und setup.

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

## Zusätzliche Steppermotoren und Extruder

### [stepper_z1]

Achsen mit mehreren Schrittmotoren. Bei einem Drucker kartesischer Bauart kann der Schrittmotor, der eine bestimmte Achse steuert, zusätzliche Konfigurationsblöcke besitzen, die Schrittmotoren definieren, die im Gleichlauf mit dem primären Schrittmotor angesteuert werden sollen. Man kann beliebig viele Abschnitte mit einem numerischen Suffix ab 1 definieren (zum Beispiel "stepper_z1", "stepper_z2" usw.).

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

Fügen Sie bei einem Drucker mit mehreren Extrudern für jeden zusätzlichen Extruder einen weiteren Abschnitt extruder hinzu. Die zusätzlichen Extruder-Abschnitte sollten "extruder1", "extruder2", "extruder3" usw. heißen. Eine Beschreibung der verfügbaren Parameter finden Sie im Abschnitt "extruder".

Siehe [sample-multi-extruder.cfg](./config/sample-multi-extruder.cfg) für eine Beispielkonfiguration.

```
[extruder1]
#step_pin:
#dir_pin:
#...
#   See the "extruder" section for available stepper and heater
#   parameters.
#shared_heater:
#   This option is deprecated and should no longer be specified.
```

### [dual_carriage]

Unterstützung für Drucker der Bauarten cartesian, generic_cartesian und hybrid_corexy/z mit zwei Schlitten auf einer Achse. Der Schlittenmodus lässt sich über den erweiterten G-Code-Befehl SET_DUAL_CARRIAGE einstellen. Der Befehl "SET_DUAL_CARRIAGE CARRIAGE=1" aktiviert zum Beispiel den in diesem Abschnitt definierten Schlitten (CARRIAGE=0 gibt die Aktivierung an den primären Schlitten zurück). Die Unterstützung für zwei Schlitten wird typischerweise mit zusätzlichen Extrudern kombiniert - der Befehl SET_DUAL_CARRIAGE wird häufig gemeinsam mit dem Befehl ACTIVATE_EXTRUDER aufgerufen. Achten Sie darauf, die Schlitten beim Deaktivieren zu parken. Beachten Sie, dass beim Homing mit G28 üblicherweise zuerst der primäre Schlitten und anschließend der im Abschnitt `[dual_carriage]` definierte Schlitten gehomt wird. Der `[dual_carriage]`-Schlitten wird jedoch zuerst gehomt, wenn beide Schlitten in positiver Richtung homen und der [dual_carriage]-Schlitten einen größeren `position_endstop` als der primäre Schlitten hat, oder wenn beide Schlitten in negativer Richtung homen und der `[dual_carriage]`-Schlitten einen kleineren `position_endstop` als der primäre Schlitten hat.

Zusätzlich könnte man die Befehle "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY" oder "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR" verwenden, um entweder den Kopier- oder Spiegelmodus des doppelten Fahrwerks zu aktivieren, in dem Fall wird es die Bewegung des Fahrwerks 0 entsprechend nachvollziehen. Diese Befehle können verwendet werden, um zwei Teile gleichzeitig zu drucken - entweder zwei identische Teile (im COPY-Modus) oder gespiegelte Teile (im MIRROR-Modus). Beachten Sie, dass die COPY- und MIRROR-Modi auch eine angemessene Konfiguration des Extruders auf dem doppelten Fahrwerk erfordern, die normalerweise mit "SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=<dual_carriage_extruder>" oder einem ähnlichen Befehl erreicht werden kann.

Ein Beispiel für eine Konfiguration mit regulärer kartesischer Kinematik finden Sie unter [sample-idex.cfg](../config/sample-idex.cfg).

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
#   identical for the primary and dual carriages), the carriages proximity
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

Ein Beispiel für eine Dual-Carriage-Konfiguration mit `generic_cartesian`-Kinematik finden Sie in der folgenden [Beispielkonfiguration](../config/example-generic-caretesian.cfg). Beachten Sie, dass die `[dual_carriage]`-Konfiguration in diesem Fall von der oben beschriebenen Konfiguration abweicht:

```
[dual_carriage my_dc_carriage]
#primary_carriage:
#   Defines the matching carriage on the same gantry as this dual carriage and
#   the corresponding dual axis. Must match a name of a defined `[carriage]` or
#   another independent `[dual_carriage]`. If not set, which is a default,
#   defines a dual carriage independent of a `[carriage]` with the same axis
#   as this one (e.g. on a different gantry).
#axis:
#   Axis of a carriage, either x or y. If 'primary_carriage' is defined, then
#   this parameter defaults to the 'axis' parameter of that primary carriage,
#   otherwise this parameter must be defined.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carriages), the carriages proximity
#   checks will be disabled. Only valid for a dual_carriage with a defined
#   'primary_carriage'.
endstop_pin:
#position_min:
position_endstop:
position_max:
#homing_speed:
#homing_retract_dist:
#homing_retract_speed:
#second_homing_speed:
#homing_positive_dir:
...
```

Weitere Informationen zu den regulären `carriage`-Parametern finden Sie im Abschnitt [generic cartesian](#generic-cartesian).

Anschließend muss der Benutzer einen oder mehrere Schrittmotoren definieren, die den Dual Carriage (und gegebenenfalls weitere Schlitten) bewegen, zum Beispiel

```
[carriage carriage_x]
...

[carriage carriage_y]
...

[dual_carriage carriage_u]
primary_carriage: carriage_x
...

[stepper dc_stepper]
carriages: carriage_u-carriage_y
...
```

`[dual_carriage]` erfordert eine besondere Konfiguration des Input Shapers. Im Allgemeinen ist es notwendig, die Input-Shaper-Kalibrierung zweimal durchzuführen - für den `dual_carriage` und für seinen `primary_carriage` bezogen auf die gemeinsam genutzte Achse. Anschließend kann der Input Shaper wie folgt konfiguriert werden, ausgehend vom obigen Beispiel:

```
[input_shaper]
# Intentionally empty

[delayed_gcode init_shaper]
initial_duration: 0.1
gcode:
  SET_DUAL_CARRIAGE CARRIAGE=carriage_u
  SET_INPUT_SHAPER SHAPER_TYPE_X=<carriage_u_shaper> SHAPER_FREQ_X=<carriage_x_freq> SHAPER_TYPE_Y=<carriage_y_shaper> SHAPER_FREQ_Y=<carriage_y_freq>
  SET_DUAL_CARRIAGE CARRIAGE=carriage_x
  SET_INPUT_SHAPER SHAPER_TYPE_X=<carriage_x_shaper> SHAPER_FREQ_X=<carriage_x_freq> SHAPER_TYPE_Y=<carriage_y_shaper> SHAPER_FREQ_Y=<carriage_y_freq>
```

Beachten Sie, dass `SHAPER_TYPE_Y` und `SHAPER_FREQ_Y` in diesem Fall in beiden Befehlen identisch sein müssen, da dieselben Motoren die Y-Achse antreiben, gleich ob der Schlitten `carriage_x` oder `carriage_u` aktiv ist.

Erwähnenswert ist, dass die `generic_cartesian`-Kinematik zwei Dual Carriages für die X- und die Y-Achse unterstützen kann. Als Referenz siehe zum Beispiel ein [Beispiel](../config/sample-corexyuv.cfg) für eine CoreXYUV-Konfiguration.

### [extruder_stepper]

Unterstützung für zusätzliche Schrittmotoren, die mit der Bewegung eines Extruders synchronisiert sind (man kann beliebig viele Abschnitte mit dem Präfix "extruder_stepper" definieren).

Siehe die [Befehlsreferenz](G-Codes.md#extruder) für weitere Informationen.

```
[extruder_stepper my_extra_stepper]
extruder:
#   The extruder this stepper is synchronized to. If this is set to an
#   empty string then the stepper will not be synchronized to an
#   extruder. This parameter must be provided.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   See the "stepper" section for the definition of the above
#   parameters.
```

### [manual_stepper]

Manuelle Schrittmotoren (man kann beliebig viele Abschnitte mit dem Präfix "manual_stepper" definieren). Dabei handelt es sich um Schrittmotoren, die über den G-Code-Befehl MANUAL_STEPPER gesteuert werden. Zum Beispiel: "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". Eine Beschreibung des Befehls MANUAL_STEPPER finden Sie in der Datei [G-Codes](G-Codes.md#manual_stepper). Diese Schrittmotoren sind nicht mit der normalen Druckerkinematik verbunden.

```
[manual_stepper my_stepper]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   See the "stepper" section for a description of these parameters.
#velocity:
#   Set the default velocity (in mm/s) for the stepper. This value
#   will be used if a MANUAL_STEPPER command does not specify a SPEED
#   parameter. The default is 5mm/s.
#accel:
#   Set the default acceleration (in mm/s^2) for the stepper. An
#   acceleration of zero will result in no acceleration. This value
#   will be used if a MANUAL_STEPPER command does not specify an ACCEL
#   parameter. The default is zero.
#endstop_pin:
#   Endstop switch detection pin. If specified, then one may perform
#   "homing moves" by adding a STOP_ON_ENDSTOP parameter to
#   MANUAL_STEPPER movement commands.
#position_min:
#position_max:
#   The minimum and maximum position the stepper can be commanded to
#   move to. If specified then one may not command the stepper to move
#   past the given position. Note that these limits do not prevent
#   setting an arbitrary position with the `MANUAL_STEPPER
#   SET_POSITION=x` command. The default is to not enforce a limit.
```

## Benutzerdefinierte Heizelemente und Sensoren

### [verify_heater]

Überprüfung von Heizungen und Temperatursensoren. Die Heizungsüberprüfung ist für jede am Drucker konfigurierte Heizung automatisch aktiviert. Verwenden Sie verify_heater-Abschnitte, um die Standardeinstellungen zu ändern.

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

Werkzeug zum Deaktivieren von Heizungen beim Homing oder beim Abtasten einer Achse.

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

Benutzerdefinierte Thermistoren (man kann beliebig viele Abschnitte mit dem Präfix "thermistor" definieren). Ein benutzerdefinierter Thermistor kann im Feld sensor_type eines Heizungs-Konfigurationsabschnitts verwendet werden. (Definiert man zum Beispiel einen Abschnitt "[thermistor my_thermistor]", kann man beim Definieren einer Heizung "sensor_type: my_thermistor" verwenden.) Achten Sie darauf, den Thermistor-Abschnitt in der Konfigurationsdatei oberhalb seiner ersten Verwendung in einem Heizungsabschnitt zu platzieren.

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

Benutzerdefinierte ADC-Temperatursensoren (man kann beliebig viele Abschnitte mit dem Präfix "adc_temperature" definieren). Damit lässt sich ein benutzerdefinierter Temperatursensor definieren, der eine Spannung an einem Pin des Analog-Digital-Wandlers (ADC) misst und die Temperatur durch lineare Interpolation zwischen einer Reihe konfigurierter Temperatur-/Spannungs- (oder Temperatur-/Widerstands-)Messwerte bestimmt. Der resultierende Sensor kann als sensor_type in einem Heizungsabschnitt verwendet werden. (Definiert man zum Beispiel einen Abschnitt "[adc_temperature my_sensor]", kann man beim Definieren einer Heizung "sensor_type: my_sensor" verwenden.) Achten Sie darauf, den Sensorabschnitt in der Konfigurationsdatei oberhalb seiner ersten Verwendung in einem Heizungsabschnitt zu platzieren.

```
[adc_temperature my_sensor]
#temperature1:
#voltage1:
#temperature2:
#voltage2:
#...
#   Eine Reihe von Temperaturen (in Celsius) und Spannungen (in Volt) zur Verwendung
#   als Referenz bei der Temperaturumwandlung. Ein Heizabschnitt, der
#   diesen Sensor verwendet, kann auch die Parameter adc_voltage und voltage_offset
#   angeben, um die ADC-Spannung zu definieren (siehe Abschnitt "Gemeinsame Temperaturverstärker"
#   für Details). Mindestens zwei Messungen müssen angegeben werden.
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#...
#   Alternativ kann man eine Reihe von Temperaturen (in Celsius) und Widerständen
#   (in Ohm) zur Verwendung als Referenz bei der Temperaturumwandlung angeben.
#   Ein Heizabschnitt, der diesen Sensor verwendet, kann auch einen
#   Pullup_resistor-Parameter angeben (siehe Abschnitt "Extruder" für Details). Mindestens
#   zwei Messungen müssen angegeben werden.
```

### [heater_generic]

Allgemeine Heizungen (man kann beliebig viele Abschnitte mit dem Präfix "heater_generic" definieren). Diese Heizungen verhalten sich ähnlich wie Standardheizungen (Extruder, Heizbetten). Verwenden Sie den Befehl SET_HEATER_TEMPERATURE (Einzelheiten siehe [G-Codes](G-Codes.md#heaters)), um die Zieltemperatur festzulegen.

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

Allgemeine Temperatursensoren. Man kann beliebig viele zusätzliche Temperatursensoren definieren, die über den Befehl M105 gemeldet werden.

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

### [temperature_probe]

Meldet die Temperatur der Sondenspule. Enthält eine optionale Kalibrierung der thermischen Drift für Sonden auf Wirbelstrombasis. Ein Abschnitt `[temperature_probe]` kann mit einem `[probe_eddy_current]` verknüpft werden, indem für beide Abschnitte dasselbe Suffix verwendet wird.

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

## Temperatur Sensoren

Klipper enthält Definitionen für viele Arten von Temperatursensoren. Diese Sensoren können in jedem Konfigurationsabschnitt verwendet werden, der einen Temperatursensor erfordert (etwa in einem Abschnitt `[extruder]` oder `[heater_bed]`).

### Gebräuchlicher Thermo-Widerstand

Gemeinsame Thermistoren. Die folgenden Parameter sind in Heizungs Sektionen verfügbar, wenn einer der Sensoren genutzt wird.

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

### Gebräuchliche Temperatur Verstärker

Gebräuchliche Temperatur Verstärker. Die folgenden Parameter sind in der Heizer Sektion  verfügbar, die einen der Sensoren benutzt.

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

### Direkt angeschlossener PT1000 Sensor

Direkt angeschlossener PT1000-Sensor. In Heizungsabschnitten, die einen dieser Sensoren verwenden, stehen die folgenden Parameter zur Verfügung.

```
sensor_type: PT1000
sensor_pin:
#   Analog input pin connected to the sensor. This parameter must be
#   provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the sensor. The
#   default is 4700 ohms.
```

### MAXxxxxx Temperatur Sensoren

Temperatursensoren der MAXxxxxx-Reihe mit Serial Peripheral Interface (SPI). In Heizungsabschnitten, die einen dieser Sensortypen verwenden, stehen die folgenden Parameter zur Verfügung.

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

### BMP180/BMP280/BME280/BMP388/BME680 Temperatur Sensoren

BMP180/BMP280/BME280/BMP388/BME680 zwei Draht Kommunikation (I2C) Umgebungs Sensoren. Bitte beachte, dass diese Sensoren für die Nutzung von Extruder oder Betttemperatur nicht geeignet sind, sie sind eher zur Aufnahme von Umgebungsparametern wie Temperatur (C), Druck (hPa), relative Feuchtigkeit und im Falle des BME680, zu Erfassung von Gaskonzentrationen zu nutzen. Siehe [sample-macros.cfg](../config/sample-macros.cfg) für ein gcode_macro um Druck und Feuchtigkeit zusätzlich zur Temperatur zu erhalten.

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

### AHT10/AHT20/AHT21 Temperatursensor

Umgebungssensoren AHT10/AHT15/AHT20/AHT21/AHT30 mit Two Wire Interface (I2C). Beachten Sie, dass diese Sensoren nicht für den Einsatz an Extrudern und Heizbetten vorgesehen sind, sondern für die Überwachung von Umgebungstemperatur (C) und relativer Luftfeuchtigkeit. Siehe [sample-macros.cfg](../config/sample-macros.cfg) für ein gcode_macro, mit dem zusätzlich zur Temperatur auch die Luftfeuchtigkeit ausgegeben werden kann.

```
sensor_type: AHT1X
#   Must be "AHT1X" , "AHT2X", "AHT3X"
#   Some AHT20 sensors can use "AHT1X"
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

### HTU21D sensor

Umgebungssensor der HTU21D-Familie mit Two Wire Interface (I2C). Beachten Sie, dass dieser Sensor nicht für den Einsatz an Extrudern und Heizbetten vorgesehen ist, sondern für die Überwachung von Umgebungstemperatur (C) und relativer Luftfeuchtigkeit. Siehe [sample-macros.cfg](../config/sample-macros.cfg) für ein gcode_macro, mit dem zusätzlich zur Temperatur auch die Luftfeuchtigkeit ausgegeben werden kann.

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

### SHT3X-Sensor

Umgebungssensor der SHT3X-Familie mit Two Wire Interface (I2C). Diese Sensoren haben einen Messbereich von -55~125 C und eignen sich daher z. B. für die Überwachung der Kammertemperatur. Sie können auch als einfache Lüfter-/Heizungssteuerung dienen.

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

### LM75 Temperatur Sensor

Über Two Wire Interface (I2C) angeschlossene Temperatursensoren LM75/LM75A. Diese Sensoren haben einen Messbereich von -55~125 C und eignen sich daher z. B. für die Überwachung der Kammertemperatur. Sie können auch als einfache Lüfter-/Heizungssteuerung dienen.

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

### Integrierter Mikrocontroller Temperatursensor

Die Mikrocontroller atsam, atsamd, stm32 und rp2040 enthalten einen internen Temperatursensor. Mit dem Sensor "temperature_mcu" lassen sich diese Temperaturen überwachen.

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

### Temperatursensor des Hosts

Temperatur des Rechners (z. B. Raspberry Pi), auf dem die Host-Software läuft.

```
sensor_type: temperature_host
#sensor_path:
#   The path to temperature system file. The default is
#   "/sys/class/thermal/thermal_zone0/temp" which is the temperature
#   system file on a Raspberry Pi computer.
```

### DS18B20 Temperatur Sensor

Der DS18B20 ist ein digitaler 1-Wire-Temperatursensor (w1). Beachten Sie, dass dieser Sensor nicht für den Einsatz an Extrudern und Heizbetten vorgesehen ist, sondern für die Überwachung der Umgebungstemperatur (C). Diese Sensoren haben einen Messbereich bis 125 C und eignen sich daher z. B. für die Überwachung der Kammertemperatur. Sie können auch als einfache Lüfter-/Heizungssteuerung dienen. DS18B20-Sensoren werden nur am "Host-MCU" unterstützt, z. B. am Raspberry Pi. Das Linux-Kernelmodul w1-gpio muss installiert sein.

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

### Kombinierter Temperatursensor

Kombinierte Temperatursensoren sind virtuelle Temperatursensoren dieauf Basis von mehreren anderen Sensoren erzeugt werden. Dieser Sensor kann in Verbindung mit Extruder als auch heater_generic und Druckbett genutzt werden.

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

## Lüfter

### [fan]

Bauteilkühlungs Lüfter.

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

Heizungskühllüfter (man kann beliebig viele Abschnitte mit dem Präfix "heater_fan" definieren). Ein "heater fan" ist ein Lüfter, der immer dann eingeschaltet wird, wenn die zugehörige Heizung aktiv ist. Standardmäßig hat ein heater_fan eine shutdown_speed in Höhe von max_power.

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

Lüfter zur Elektronikkühlung (man kann beliebig viele Abschnitte mit dem Präfix "controller_fan" definieren). Ein "controller fan" ist ein Lüfter, der immer dann eingeschaltet wird, wenn die zugehörige Heizung oder der zugehörige Schrittmotortreiber aktiv ist. Der Lüfter stoppt, sobald ein idle_timeout erreicht wird, um sicherzustellen, dass es nach dem Deaktivieren einer überwachten Komponente zu keiner Überhitzung kommt.

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

Temperaturgesteuerte Kühllüfter (man kann beliebig viele Abschnitte mit dem Präfix "temperature_fan" definieren). Ein "temperature fan" ist ein Lüfter, der immer dann eingeschaltet wird, wenn der zugehörige Sensor über einer festgelegten Temperatur liegt. Standardmäßig hat ein temperature_fan eine shutdown_speed in Höhe von max_power.

Siehe die [Befehlsreferenz](G-Codes.md#temperature_fan) für weitere Informationen.

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

Manuell gesteuerter Lüfter (man kann beliebig viele Abschnitte mit dem Präfix "fan_generic" definieren). Die Drehzahl eines manuell gesteuerten Lüfters wird mit dem [G-Code-Befehl](G-Codes.md#fan_generic) SET_FAN_SPEED festgelegt.

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

## LEDs

### [led]

Unterstützung für LEDs (und LED-Streifen), die über PWM-Pins des Mikrocontrollers angesteuert werden (man kann beliebig viele Abschnitte mit dem Präfix "led" definieren). Weitere Informationen finden Sie in der [Befehlsreferenz](G-Codes.md#led).

```
[led my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
#   The pin controlling the given LED color. At least one of the above
#   parameters must be provided.
#cycle_time: 0.010
#   The amount of time (in seconds) per PWM cycle. It is recommended
#   this be 10 milliseconds or greater when using software based PWM.
#   The default is 0.010 seconds.
#hardware_pwm: False
#   Enable this to use hardware PWM instead of software PWM. When
#   using hardware PWM the actual cycle time is constrained by the
#   implementation and may be significantly different than the
#   requested cycle_time. The default is False.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Sets the initial LED color. Each value should be between 0.0 and
#   1.0. The default for each color is 0.
```

### [neopixel]

Unterstützung für Neopixel-LEDs (auch WS2812) (man kann beliebig viele Abschnitte mit dem Präfix "neopixel" definieren). Weitere Informationen finden Sie in der [Befehlsreferenz](G-Codes.md#led).

Beachten Sie, dass die Implementierung des [Linux-MCU](RPi_microcontroller.md) derzeit keine direkt angeschlossenen Neopixel unterstützt. Der aktuelle Entwurf auf Basis der Linux-Kernel-Schnittstelle lässt dieses Szenario nicht zu, da die GPIO-Schnittstelle des Kernels nicht schnell genug ist, um die erforderlichen Pulsraten zu liefern.

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

Unterstützung für Dotstar-LEDs (auch APA102) (man kann beliebig viele Abschnitte mit dem Präfix "dotstar" definieren). Weitere Informationen finden Sie in der [Befehlsreferenz](G-Codes.md#led).

```
[dotstar my_dotstar]
data_pin:
#   The pin connected to the data line of the dotstar. This parameter
#   must be provided.
clock_pin:
#   The pin connected to the clock line of the dotstar. This parameter
#   must be provided.
#chain_count:
#   See the "neopixel" section for information on this parameter.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#   See the "led" section for information on these parameters.
```

### [pca9533]

Unterstützung für PCA9533-LEDs. Der PCA9533 wird auf dem Mightyboard eingesetzt.

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

Unterstützung für PCA9632-LEDs. Der PCA9632 wird im FlashForge Dreamer eingesetzt.

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
#color_order: RGBW
#   Set the pixel order of the LED (using a string containing the
#   letters R, G, B, W). The default is RGBW.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

## Zusätzliche Servomotoren, Schalter und andere Pins

### [servo]

Servos (man kann beliebig viele Abschnitte mit dem Präfix "servo" definieren). Die Servos können über den [G-Code-Befehl](G-Codes.md#servo) SET_SERVO gesteuert werden. Zum Beispiel: SET_SERVO SERVO=my_servo ANGLE=180

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

G-Code ausführen, wenn eine Taste gedrückt oder losgelassen wird (oder wenn ein Pin seinen Zustand ändert). Den Zustand der Taste können Sie mit `QUERY_BUTTON button=my_gcode_button` abfragen.

```
[gcode_button my_gcode_button]
pin:
#   The pin on which the button is connected. This parameter must be
#   provided.
#analog_range:
#   Two comma separated resistances (in Ohms) specifying the minimum
#   and maximum resistance range for the button. If analog_range is
#   provided then the pin must be an analog capable pin. The default
#   is to use digital gpio for the button.
#analog_pullup_resistor:
#   The pullup resistance (in Ohms) when analog_range is specified.
#   The default is 4700 ohms.
#press_gcode:
#   A list of G-Code commands to execute when the button is pressed.
#   G-Code templates are supported. This parameter must be provided.
#release_gcode:
#   A list of G-Code commands to execute when the button is released.
#   G-Code templates are supported. The default is to not run any
#   commands on a button release.
#debounce_delay:
#   A period of time in seconds to debounce events prior to running the
#   button gcode. If the button is pressed and released during this
#   delay, the entire button press is ignored. Default is 0.
```

### [output_pin]

Zur Laufzeit konfigurierbare Ausgangspins (man kann beliebig viele Abschnitte mit dem Präfix "output_pin" definieren). Hier konfigurierte Pins werden als Ausgangspins eingerichtet und lassen sich zur Laufzeit über erweiterte [G-Code-Befehle](G-Codes.md#output_pin) der Art "SET_PIN PIN=my_pin VALUE=.1" verändern.

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

### [static_pwm_clock]

Statisch konfigurierbarer Ausgangspin (man kann beliebig viele Abschnitte mit dem Präfix "static_pwm_clock" definieren). Hier konfigurierte Pins werden als Taktausgänge eingerichtet. Sie werden im Allgemeinen verwendet, um anderer Hardware auf der Platine ein Taktsignal bereitzustellen.

```
[static_pwm_clock my_pin]
pin:
#   The pin to configure as an output. This parameter must be provided.
#frequency: 100
#   Target output frequency.
```

### [pwm_tool]

Digitale Ausgangspins mit Pulsweitenmodulation, die schnelle Aktualisierungen ermöglichen (man kann beliebig viele Abschnitte mit dem Präfix "output_pin" definieren). Hier konfigurierte Pins werden als Ausgangspins eingerichtet und lassen sich zur Laufzeit über erweiterte [G-Code-Befehle](G-Codes.md#output_pin) der Art "SET_PIN PIN=my_pin VALUE=.1" verändern.

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

Zur Laufzeit konfigurierbare Ausgangspins mit dynamischer PWM-Zykluszeit (man kann beliebig viele Abschnitte mit dem Präfix "pwm_cycle_time" definieren). Hier konfigurierte Pins werden als Ausgangspins eingerichtet und lassen sich zur Laufzeit über erweiterte [G-Code-Befehle](G-Codes.md#pwm_cycle_time) der Art "SET_PIN PIN=my_pin VALUE=.1 CYCLE_TIME=0.100" verändern.

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

Statisch konfigurierte digitale Ausgangspins (man kann beliebig viele Abschnitte mit dem Präfix "static_digital_output" definieren). Hier konfigurierte Pins werden während der MCU-Konfiguration als GPIO-Ausgang eingerichtet. Sie können zur Laufzeit nicht geändert werden.

```
[static_digital_output my_output_pins]
pins:
#   A comma separated list of pins to be set as GPIO output pins. The
#   pin will be set to a high level unless the pin name is prefaced
#   with "!". This parameter must be provided.
```

### [multi_pin]

Ausgänge mit mehreren Pins (man kann beliebig viele Abschnitte mit dem Präfix "multi_pin" definieren). Ein multi_pin-Ausgang erzeugt einen internen Pin-Alias, der bei jedem Setzen des Alias-Pins mehrere Ausgangspins ändern kann. So könnte man zum Beispiel ein Objekt "[multi_pin my_fan]" mit zwei Pins definieren und dann im Abschnitt "[fan]" "pin=multi_pin:my_fan" setzen - bei jeder Lüfteränderung würden dann beide Ausgangspins aktualisiert. Diese Aliase dürfen nicht mit Schrittmotor-Pins verwendet werden.

```
[multi_pin my_multi_pin]
pins:
#   A comma separated list of pins associated with this alias. This
#   parameter must be provided.
```

## TMC Schrittmotor Treiberkonfiguration

Konfiguration der Trinamics Schrittmotor Treiber im UART/SPI Modus. Zusätzliche Informationen sind im [TMC Treiber Leitfaden](TMC_Drivers.md) und [Allgemeinen Referenzen](G-Codes.md#tmcxxxx) zu finden.

### [tmc2130]

Konfiguration eines TMC2130 Schrittmotortreibers über die SPI Schnittstelle. Um dieses Feature zu nutzen, muss eine Sektion mit dem Prefix "tmc2130" erstellt werden, gefolgt von der dazugehörigen Schrittmotorkonfiguration (z.B ,"[tmc2130 stepper_x]").

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
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
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
#driver_FREEWHEEL: 0
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

Konfiguration eines TMC2208- (oder TMC2224-)Schrittmotortreibers über Einleiter-UART. Um diese Funktion zu nutzen, definieren Sie einen Konfigurationsabschnitt mit dem Präfix "tmc2208", gefolgt vom Namen des zugehörigen Schrittmotor-Konfigurationsabschnitts (zum Beispiel "[tmc2208 stepper_x]").

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
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
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
#driver_FREEWHEEL: 0
#   Set the given register during the configuration of the TMC2208
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
```

### [tmc2209]

Konfiguration eines TMC2209-Schrittmotortreibers über Einleiter-UART. Um diese Funktion zu nutzen, definieren Sie einen Konfigurationsabschnitt mit dem Präfix "tmc2209", gefolgt vom Namen des zugehörigen Schrittmotor-Konfigurationsabschnitts (zum Beispiel "[tmc2209 stepper_x]").

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
#driver_FREEWHEEL: 0
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

Konfiguration eines TMC2660-Schrittmotortreibers über den SPI-Bus. Um diese Funktion zu nutzen, definieren Sie einen Konfigurationsabschnitt mit dem Präfix tmc2660, gefolgt vom Namen des zugehörigen Schrittmotor-Konfigurationsabschnitts (zum Beispiel "[tmc2660 stepper_x]").

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

Konfiguration eines TMC2240-Schrittmotortreibers über den SPI-Bus oder UART. Um diese Funktion zu nutzen, definieren Sie einen Konfigurationsabschnitt mit dem Präfix "tmc2240", gefolgt vom Namen des zugehörigen Schrittmotor-Konfigurationsabschnitts (zum Beispiel "[tmc2240 stepper_x]").

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
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
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
#driver_SG4_THRS: 0
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
#   "sensorless homing". (Be sure to also set driver_SGT OR driver_SG4_THRS
#   to an appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc5160]

Konfiguration eines TMC5160-Schrittmotortreibers über den SPI-Bus. Um diese Funktion zu nutzen, definieren Sie einen Konfigurationsabschnitt mit dem Präfix "tmc5160", gefolgt vom Namen des zugehörigen Schrittmotor-Konfigurationsabschnitts (zum Beispiel "[tmc5160 stepper_x]").

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
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
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

## Konfiguration des Schrittmotorstroms während der Betriebszeit

### [ad5206]

Statisch konfigurierte, über den SPI-Bus angeschlossene AD5206-Digipots (man kann beliebig viele Abschnitte mit dem Präfix "ad5206" definieren).

```
gebräuchliche Spi Einstellungen
```

### [mcp4451]

Statisch konfiguriertes, über den I2C-Bus angeschlossenes MCP4451-Digipot (man kann beliebig viele Abschnitte mit dem Präfix "mcp4451" definieren).

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

Statisch konfigurierter, über den I2C-Bus angeschlossener Digital-Analog-Wandler MCP4728 (man kann beliebig viele Abschnitte mit dem Präfix "mcp4728" definieren).

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

Statisch konfiguriertes, über I2C angeschlossenes MCP4018-Digipot (man kann beliebig viele Abschnitte mit dem Präfix "mcp4018" definieren).

```
[mcp4018 my_digipot]
#i2c_address: 47
#   The i2c address that the chip is using on the i2c bus. The default
#   is 47.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
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

## Display Unterstützung

### [display]

Unterstützung für ein am Mikrocontroller angeschlossenes Display.

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

#### hd44780 display

Informationen zur Konfiguration von hd44780-Displays (die in Displays vom Typ "RepRapDiscount 2004 Smart Controller" verwendet werden).

```
[display]
lcd_type: hd44780
#   Set to "hd44780" for hd44780 displays.
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#   The pins connected to an hd44780 type lcd. These parameters must
#   be provided.
#hd44780_protocol_init: True
#   Perform 8-bit/4-bit protocol initialization on an hd44780 display.
#   This is necessary on real hd44780 devices. However, one may need
#   to disable this on some "clone" devices. The default is True.
#line_length:
#   Set the number of characters per line for an hd44780 type lcd.
#   Possible values are 20 (default) and 16. The number of lines is
#   fixed to 4.
...
```

#### hd44780_spi display

Informationen zur Konfiguration eines hd44780_spi-Displays - ein 20x04-Display, das über ein Hardware-Schieberegister angesteuert wird (wird in Druckern auf Mightyboard-Basis verwendet).

```
[display]
lcd_type: hd44780_spi
#   Set to "hd44780_spi" for hd44780_spi displays.
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   The pins connected to the shift register controlling the display.
#   The spi_software_miso_pin needs to be set to an unused pin of the
#   printer mainboard as the shift register does not have a MISO pin,
#   but the software spi implementation requires this pin to be
#   configured.
#hd44780_protocol_init: True
#   Perform 8-bit/4-bit protocol initialization on an hd44780 display.
#   This is necessary on real hd44780 devices. However, one may need
#   to disable this on some "clone" devices. The default is True.
#line_length:
#   Set the number of characters per line for an hd44780 type lcd.
#   Possible values are 20 (default) and 16. The number of lines is
#   fixed to 4.
...
```

#### aip31068_spi Display

Informationen zur Konfiguration eines aip31068_spi-Displays - ein dem hd44780_spi sehr ähnliches 20x04-Display (20 Zeichen mal 4 Zeilen) mit leicht abweichendem internen Protokoll.

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

#### st7920 display

Informationen zur Konfiguration von st7920-Displays (die in Displays vom Typ "RepRapDiscount 12864 Full Graphic Smart Controller" verwendet werden).

```
[display]
lcd_type: st7920
#   Set to "st7920" for st7920 displays.
cs_pin:
sclk_pin:
sid_pin:
#   The pins connected to an st7920 type lcd. These parameters must be
#   provided.
...
```

#### emulated_st7920 display

Informationen zur Konfiguration eines emulierten st7920-Displays - zu finden in manchen "2,4-Zoll-Touchscreen-Geräten" und Ähnlichem.

```
[display]
lcd_type: emulated_st7920
#   Set to "emulated_st7920" for emulated_st7920 displays.
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   The pins connected to an emulated_st7920 type lcd. The en_pin
#   corresponds to the cs_pin of the st7920 type lcd,
#   spi_software_sclk_pin corresponds to sclk_pin and
#   spi_software_mosi_pin corresponds to sid_pin. The
#   spi_software_miso_pin needs to be set to an unused pin of the
#   printer mainboard as the st7920 as no MISO pin but the software
#   spi implementation requires this pin to be configured.
...
```

#### uc1701 display

Informationen zur Konfiguration von uc1701-Displays (die in Displays vom Typ "MKS Mini 12864" verwendet werden).

```
[display]
lcd_type: uc1701
#   Set to "uc1701" for uc1701 displays.
cs_pin:
a0_pin:
#   The pins connected to a uc1701 type lcd. These parameters must be
#   provided.
#rst_pin:
#   The pin connected to the "rst" pin on the lcd. If it is not
#   specified then the hardware must have a pull-up on the
#   corresponding lcd line.
#contrast:
#   The contrast to set. The value may range from 0 to 63 and the
#   default is 40.
...
```

#### ssd1306 und sh1106 Displays

Informationen zur Konfiguration der Anzeigen ssd1306 und sh1106.

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

Unterstützung für die Anzeige benutzerdefinierter Daten auf einem LCD-Bildschirm. Man kann beliebig viele Anzeigegruppen und darunter beliebig viele Datenelemente anlegen. Das Display zeigt alle Datenelemente einer bestimmten Gruppe an, wenn die Option display_group im Abschnitt [display] auf den Namen dieser Gruppe gesetzt ist.

Ein [Standard-Set an Display-Gruppen](../klippy/extras/display/display.cfg) werden automatisch erstellt. Diese display_data-Objekte können überschrieben oder vergrößert werden, indem die Standardkonfiguration in der primären printer.cfg Konfigurationsdatei überschrieben wird.

```
[display_data my_group_name my_data_name]
position:
#   Comma separated row and column of the display position that should
#   be used to display the information. This parameter must be
#   provided.
text:
#   The text to show at the given position. This field is evaluated
#   using command templates (see docs/Command_Templates.md). This
#   parameter must be provided.
```

### [display_template]

Text-"Makros" für Anzeigedaten (man kann beliebig viele Abschnitte mit dem Präfix display_template definieren). Informationen zur Auswertung von Vorlagen finden Sie im Dokument [Befehlsvorlagen](Command_Templates.md).

Mit dieser Funktion lassen sich sich wiederholende Definitionen in display_data-Abschnitten reduzieren. In display_data-Abschnitten kann die eingebaute Funktion `render()` verwendet werden, um eine Vorlage auszuwerten. Definiert man zum Beispiel `[display_template my_template]`, so kann man in einem display_data-Abschnitt `{ render('my_template') }` verwenden.

Diese Funktion kann mit dem Befehl [SET_LED_TEMPLATE](G-Codes.md#set_led_template) auch für fortlaufende LED-Aktualisierungen genutzt werden.

```
[display_template my_template_name]
#param_<name>:
#   One may specify any number of options with a "param_" prefix. The
#   given name will be assigned the given value (parsed as a Python
#   literal) and will be available during macro expansion. If the
#   parameter is passed in the call to render() then that value will
#   be used during macro expansion. For example, a config with
#   "param_speed = 75" might have a caller with
#   "render('my_template_name', param_speed=80)". Parameter names may
#   not use upper case characters.
text:
#   The text to return when the this template is rendered. This field
#   is evaluated using command templates (see
#   docs/Command_Templates.md). This parameter must be provided.
```

### [display_glyph]

Anzeige eines benutzerdefinierten Glyphs auf Displays, die dies unterstützen. Dem angegebenen Namen werden die angegebenen Anzeigedaten zugewiesen, die dann in den Anzeigevorlagen über ihren Namen umschlossen von zwei Tilde-Zeichen referenziert werden können, also `~my_display_glyph~`

See [sample-glyphs.cfg](../config/sample-glyphs.cfg) for some examples.

```
[display_glyph my_display_glyph]
#data:
#   The display data, stored as 16 lines consisting of 16 bits (1 per
#   pixel) where '.' is a blank pixel and '*' is an on pixel (e.g.,
#   "****************" to display a solid horizontal line).
#   Alternatively, one can use '0' for a blank pixel and '1' for an on
#   pixel. Put each display line into a separate config line. The
#   glyph must consist of exactly 16 lines with 16 bits each. This
#   parameter is optional.
#hd44780_data:
#   Glyph to use on 20x4 hd44780 displays. The glyph must consist of
#   exactly 8 lines with 5 bits each. This parameter is optional.
#hd44780_slot:
#   The hd44780 hardware index (0..7) to store the glyph at. If
#   multiple distinct images use the same slot then make sure to only
#   use one of those images in any given screen. This parameter is
#   required if hd44780_data is specified.
```

### [display my_extra_display]

Wenn wie oben gezeigt ein primärer Abschnitt [display] in der printer.cfg definiert wurde, können mehrere zusätzliche Displays definiert werden. Beachten Sie, dass zusätzliche Displays derzeit keine Menüfunktionalität unterstützen und daher weder die Optionen "menu" noch eine Tastenkonfiguration unterstützen.

```
[display my_extra_display]
# See the "display" section for available parameters.
```

### [menu]

Anpassbare LCD Anzeigen Menüs.

Eine [Standart Menüstruktur](../klippy/extras/Display/menu.cfg) wird durch Klipper automatisch generiert. Ein Eintrag in der printer.cfg Datei, überschreibt den Standarteintrag und kann den vorhandenen Menüpunkt ersetzen oder erweitern.

Informationen zu den während des Renderns von Vorlagen verfügbaren Menüattributen finden Sie im [Dokument zu Befehlsvorlagen](Command_Templates.md#menu-templates).

```
# Common parameters available for all menu config sections.
#[menu __some_list __some_name]
#type: disabled
#   Permanently disabled menu element, only required attribute is 'type'.
#   Allows you to easily disable/hide existing menu items.

#[menu some_name]
#type:
#   One of command, input, list, text:
#       command - basic menu element with various script triggers
#       input   - same like 'command' but has value changing capabilities.
#                 Press will start/stop edit mode.
#       list    - it allows for menu items to be grouped together in a
#                 scrollable list.  Add to the list by creating menu
#                 configurations using "some_list" as a prefix - for
#                 example: [menu some_list some_item_in_the_list]
#       vsdlist - same as 'list' but will append files from virtual sdcard
#                 (will be removed in the future)
#name:
#   Name of menu item - evaluated as a template.
#enable:
#   Template that evaluates to True or False.
#index:
#   Position where an item needs to be inserted in list. By default
#   the item is added at the end.

#[menu some_list]
#type: list
#name:
#enable:
#   See above for a description of these parameters.

#[menu some_list some_command]
#type: command
#name:
#enable:
#   See above for a description of these parameters.
#gcode:
#   Script to run on button click or long click. Evaluated as a
#   template.

#[menu some_list some_input]
#type: input
#name:
#enable:
#   See above for a description of these parameters.
#input:
#   Initial value to use when editing - evaluated as a template.
#   Result must be float.
#input_min:
#   Minimum value of range - evaluated as a template. Default -99999.
#input_max:
#   Maximum value of range - evaluated as a template. Default 99999.
#input_step:
#   Editing step - Must be a positive integer or float value. It has
#   internal fast rate step. When "(input_max - input_min) /
#   input_step > 100" then fast rate step is 10 * input_step else fast
#   rate step is same input_step.
#realtime:
#   This attribute accepts static boolean value. When enabled then
#   gcode script is run after each value change. The default is False.
#gcode:
#   Script to run on button click, long click or value change.
#   Evaluated as a template. The button click will trigger the edit
#   mode start or end.
```

## Filament Sensoren

### [filament_switch_sensor]

Filament-Schaltsensor. Unterstützung für die Erkennung von eingelegtem und ausgegangenem Filament mithilfe eines Schaltsensors, zum Beispiel eines Endschalters.

Siehe die [Befehlsreferenz](G-Codes.md#filament_switch_sensor) für weitere Informationen.

```
[filament_switch_sensor my_sensor]
#pause_on_runout: True
#   When set to True, a PAUSE will execute immediately after a runout
#   is detected. Note that if pause_on_runout is False and the
#   runout_gcode is omitted then runout detection is disabled. Default
#   is True.
#runout_gcode:
#   A list of G-Code commands to execute after a filament runout is
#   detected. See docs/Command_Templates.md for G-Code format. If
#   pause_on_runout is set to True this G-Code will run after the
#   PAUSE is complete. The default is not to run any G-Code commands.
#insert_gcode:
#   A list of G-Code commands to execute after a filament insert is
#   detected. See docs/Command_Templates.md for G-Code format. The
#   default is not to run any G-Code commands, which disables insert
#   detection.
#event_delay: 3.0
#   The minimum amount of time in seconds to delay between events.
#   Events triggered during this time period will be silently
#   ignored. The default is 3 seconds.
#pause_delay: 0.5
#   The amount of time to delay, in seconds, between the pause command
#   dispatch and execution of the runout_gcode. It may be useful to
#   increase this delay if OctoPrint exhibits strange pause behavior.
#   Default is 0.5 seconds.
#debounce_delay:
#   A period of time in seconds to debounce events prior to running the
#   switch gcode. The switch must he held in a single state for at least
#   this long to activate. If the switch is toggled on/off during this delay,
#   the event is ignored. Default is 0.
#switch_pin:
#   The pin on which the switch is connected. This parameter must be
#   provided.
```

### [filament_motion_sensor]

Filament-Bewegungssensor. Unterstützung für die Erkennung von eingelegtem und ausgegangenem Filament mithilfe eines Encoders, der den Ausgangspin während der Filamentbewegung durch den Sensor umschaltet.

Siehe die [Befehlsreferenz](G-Codes.md#filament_switch_sensor) für weitere Informationen.

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#   The minimum length of filament pulled through the sensor to trigger
#   a state change on the switch_pin
#   Default is 7 mm.
extruder:
#   The name of the extruder or extruder_stepper section this sensor
#   is associated with. This parameter must be provided.
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   See the "filament_switch_sensor" section for a description of the
#   above parameters.
```

### [tsl1401cl_filament_width_sensor]

Filamentbreitensensor auf Basis des TSL1401CL. Weitere Informationen finden Sie in der [Anleitung](TSL1401CL_Filament_Width_Sensor.md).

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

Hall-Filamentbreitensensor (siehe [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)).

```
[hall_filament_width_sensor]
adc1:
adc2:
#   Analog input pins connected to the sensor. These parameters must
#   be provided.
#cal_dia1: 1.50
#cal_dia2: 2.00
#   The calibration values (in mm) for the sensors. The default is
#   1.50 for cal_dia1 and 2.00 for cal_dia2.
#raw_dia1: 9500
#raw_dia2: 10500
#   The raw calibration values for the sensors. The values must be
#   different. The default is 9500 for raw_dia1 and 10500 for raw_dia2.
#default_nominal_filament_diameter: 1.75
#   The nominal filament diameter. This parameter must be provided.
#max_difference: 0.200
#   Maximum allowed filament diameter difference in millimeters (mm).
#   If difference between nominal filament diameter and sensor output
#   is more than +- max_difference, extrusion multiplier is set back
#   to 100%. Must be less than default_nominal_filament_diameter.
#   The default is 0.200.
#measurement_delay: 70
#   The distance from sensor to the melting chamber/hot-end in
#   millimeters (mm). The filament between the sensor and the hot-end
#   will be treated as the default_nominal_filament_diameter. Host
#   module works with FIFO logic. It keeps each sensor value and
#   position in an array and POP them back in correct position. This
#   parameter must be provided.
#enable: False
#   Sensor enabled or disabled after power on. The default is to
#   disable.
#enable_flow_compensation: True
#   Flow compensation enabled or disabled. If set to False, the sensor
#   will not modify the extrusion multiplier and will only trigger
#   runout events. The default is True.
#measurement_interval: 10
#   The approximate distance (in mm) between sensor readings. The
#   default is 10mm.
#logging: False
#   Out diameter to terminal and klipper.log can be turn on|of by
#   command.
#min_diameter: 1.0
#   Minimal diameter for trigger virtual filament_switch_sensor.
#max_diameter:
#   Maximum diameter for triggering virtual filament_switch_sensor.
#   The default is default_nominal_filament_diameter + max_difference.
#use_current_dia_while_delay: False
#   Use the current diameter instead of the nominal diameter while
#   the measurement delay has not run through.
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   See the "filament_switch_sensor" section for a description of the
#   above parameters.
```

## Zellen laden

### [load_cell]

Wägezelle. Verwendet einen an eine Wägezelle angeschlossenen ADC-Sensor, um eine digitale Waage zu realisieren.

```
[load_cell]
sensor_type:
#   This must be one of the supported sensor types, see below.
#counts_per_gram:
#   The floating point number of sensor counts that indicates 1 gram of force.
#   This value is calculated by the LOAD_CELL_CALIBRATE command.
#reference_tare_counts:
#   The integer tare value, in raw sensor counts, taken when LOAD_CELL_CALIBRATE
#   is run. This is the default tare value when klipper starts up.
#sensor_orientation:
#   Change the sensor's orientation. Can be either 'normal' or 'inverted'.
#   The default is 'normal'. Use 'inverted' if the sensor reports a
#   decreasing force value when placed under load.
```

#### HX711

Dies ist ein 24-Bit-Chip mit niedriger Abtastrate, der "Bit-Banging"-Kommunikation verwendet. Er eignet sich für Filamentwaagen.

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

Dies ist die Variante des HX711 mit vierfach höherer Abtastrate, die sich zum Abtasten eignet.

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

Der ADS1220 ist ein 24-Bit-ADC, der eine softwareseitig konfigurierbare Abtastrate von bis zu 2 kHz unterstützt.

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

#### ADS131M0x

Der ADS131M0x ist eine Familie schneller 24-Bit-Delta-Sigma-ADCs. Aus dieser Familie werden zwei Sensoren unterstützt: der ADS131M02 mit zwei gleichzeitig abtastenden Differenzkanälen und der ADS131M04 mit vier Kanälen. Sie verfügen über einen programmierbaren Verstärker (PGA) mit Verstärkungen bis 128 und konfigurierbaren Abtastraten bis 64000 Abtastungen pro Sekunde und benötigen ein externes Taktsignal (300 kHz bis 8,4 MHz, nominal 8,192 MHz).

```
[load_cell]
sensor_type: ads131m02
#   Select 'ads131m02' for the 2-channel variant or 'ads131m04' for the
#   4-channel variant. This parameter must be provided.
cs_pin:
#   The pin connected to the chip select line. This parameter must be
#   provided.
#spi_speed: 4000000
#   The SPI bus speed. The default is 4 MHz.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
data_ready_pin:
#   Pin connected to the data ready (DRDY) line. This parameter must be
#   provided.
#adc_channel: 0
#   The ADC channel to read. For the ADS131M02, valid values are 0 and 1.
#   For the ADS131M04, valid values are 0, 1, 2, and 3. The default is 0.
#clock_freq:
#   The external clock frequency (fCLKIN) in Hz supplied to the CLKIN pin.
#   The valid range is 300000 to 8400000. The nominal clock frequency for the
#   ADS131M0x is 8192000 Hz; it is recommended to use a clock source near
#   this frequency. Either clock_freq or pwm_clock must be provided.
#pwm_clock:
#   Reference to a [static_pwm_clock] section that generates the clock signal
#   for the CLKIN pin. The frequency of this clock is used as fCLKIN.
#   Either clock_freq or pwm_clock must be provided.
#sample_rate: 500.0
#   The desired output sampling rate in samples per second. The firmware will
#   select the closest available rate, if possible. When the nominal clock
#   frequency of 8192000 Hz is used and global-chop mode is disabled, the
#   following rates are available: 250, 500, 1000, 2000, 4000, 8000, 16000,
#   32000, and 64000. The actual effective sampling rate can be checked via
#   the LOAD_CELL_DIAGNOSTIC command. The default is 500.
#gain: 128
#   The PGA gain setting. Valid values are: 1, 2, 4, 8, 16, 32, 64, and
#   128. The default is 128.
#enable_global_chop: False
#   Enable global-chop mode to reduce internal system offset errors by averaging
#   two conversions with opposite input polarities. The default is False.
#global_chop_delay: 16
#   The global-chop delay in modulator clock periods, only used when
#   enable_global_chop is True. Higher values allow more settling time
#   between input swaps. Valid values are all powers of 2 from 2 to 65536.
#   The default is 16.
```

### [load_cell_probe]

Wägezellen-Sonde. Sie vereint die Funktionalität von [probe] und [load_cell].

```
[load_cell_probe]
sensor_type:
#   This must be one of the supported bulk ADC sensor types and support
#   load cell endstops on the mcu.
#counts_per_gram:
#reference_tare_counts:
#sensor_orientation:
#   These parameters must be configured before the probe will operate.
#   See the [load_cell] section for further details.
#force_safety_limit: 2000
#   The safe limit for probing force relative to the reference_tare_counts on
#   the load_cell. The default is +/-2Kg.
#trigger_force: 75.0
#   The force that the probe will trigger at. 75g is the default.
#drift_filter_cutoff_frequency: 0.8
#   Enable optional continuous taring while homing & probing to reject drift.
#   The value is a frequency, in Hz, below which drift will be ignored. This
#   option requires the SciPy library. Default: None
#drift_filter_delay: 2
#   The delay, or 'order', of the drift filter. This controls the number of
#   samples required to make a trigger detection. Can be 1 or 2, the default
#   is 2.
#buzz_filter_cutoff_frequency: 100.0
#   The value is a frequency, in Hz, above which high frequency noise in the
#   load cell will be igfiltered outnored. This option requires the SciPy
#   library. Default: None
#buzz_filter_delay: 2
#   The delay, or 'order', of the buzz filter. This controls the number of
#   samples required to make a trigger detection. Can be 1 or 2, the default
#   is 2.
#notch_filter_frequencies: 50, 60
#   1 or 2 frequencies, in Hz, to filter out of the load cell data. This is
#   intended to reject power line noise. This option requires the SciPy
#   library.  Default: None
#notch_filter_quality: 2.0
#   Controls how narrow the range of frequencies are that the notch filter
#   removes. Larger numbers produce a narrower filter. Minimum value is 0.5 and
#   maximum is 3.0. Default: 2.0
#tare_time:
#   The rime in seconds used for taring the load_cell before each probe. The
#   default value is: 4 / 60 = 0.066. This collects samples from 4 cycles of
#   60Hz mains power to cancel power line noise.
#z_offset:
#speed:
#samples:
#sample_retract_dist:
#lift_speed:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#   See the "[probe]" section for a description of the above parameters.
```

## Board spezifische Hardware Unterstützung

### [sx1509]

Konfiguration einer SX1509 I2C zu GPIO Erweiterung. Durch die Latenz der I2C Kommunikation sollte der SX1509 NICHT als Schrittmotorfreigabe, Schritte oder Richtungspin, oder andere schnell wechselnde Signale verwendet werden. Sie sollten als statische oder durch gcode kontrollierte GPIO oder hardware-pwm Signale genutzt werden, z.B als Lüfter. Es können mehrere Einträge mit dem prefix "sx1509" angelegt werden. Jeder Erweiterungschip verfügt über 16 Pins (sx1509_my_sx1509:PIN_0 to sx1509_my_sx1509:PIN_15) die in der Druckerkonfiguration genutzt werden können.

Siehe die Datei [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg) für ein Beispiel.

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

SAMD-SERCOM-Konfiguration zur Festlegung, welche Pins an einem bestimmten SERCOM verwendet werden. Man kann beliebig viele Abschnitte mit dem Präfix "samd_sercom" definieren. Jedes SERCOM muss konfiguriert werden, bevor es als SPI- oder I2C-Peripherie verwendet wird. Platzieren Sie diesen Konfigurationsabschnitt oberhalb aller anderen Abschnitte, die SPI- oder I2C-Busse nutzen.

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

Analoge Skalierung des Duet2 Maestro anhand der vref- und vssa-Messwerte. Das Definieren eines Abschnitts adc_scaled aktiviert virtuelle ADC-Pins (wie "my_name:PB0"), die automatisch über die vref- und vssa-Überwachungspins der Platine angepasst werden. Achten Sie darauf, diesen Konfigurationsabschnitt oberhalb aller Abschnitte zu platzieren, die einen dieser virtuellen Pins verwenden.

Siehe die Datei [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg) für ein Beispiel.

```
[adc_scaled my_name]
vref_pin:
#   Der ADC-Pin zur Überwachung von VREF. Dieser Parameter muss
#   angegeben werden.
vssa_pin:
#   Der ADC-Pin zur Überwachung von VSSA. Dieser Parameter muss
#   angegeben werden.
#smooth_time: 2.0
#   Ein Zeitwert (in Sekunden), über den die vref- und vssa-
#   Messungen geglättet werden, um den Einfluss von Messrauschen
#   zu verringern. Die Standardeinstellung sind 2 Sekunden.
```

### [ads1x1x]

ADS1013, ADS1014, ADS1015, ADS1113, ADS1114 und ADS1115 sind I2C-basierte Analog-Digital-Wandler, die für Temperatursensoren verwendet werden können. Sie stellen 4 analoge Eingangspins entweder als einzelne Leitung oder als Differenzeingang bereit.

Hinweis: Seien Sie vorsichtig, wenn Sie diesen Sensor zur Steuerung von Heizungen verwenden. Die Werte min_temp und max_temp der Heizung werden nur im Host überprüft und nur dann, wenn der Host läuft und normal arbeitet. (Direkt am Mikrocontroller angeschlossene ADC-Eingänge prüfen min_temp und max_temp innerhalb des Mikrocontrollers und benötigen dafür keine funktionierende Verbindung zum Host.)

```
[ads1x1x my_ads1x1x]
chip: ADS1115
#pga: 4.096V
#   Default value is 4.096V. The maximum voltage range used for the input. This
#   scales all values read from the ADC. Options are: 6.144V, 4.096V, 2.048V,
#   1.024V, 0.512V, 0.256V
#adc_voltage: 3.3
#   The supply voltage for the device. This allows additional software scaling
#   for all values read from the ADC.
i2c_mcu: host
i2c_bus: i2c.1
#address_pin: GND
#   Default value is GND.  There can be up to four addressed devices depending
#   upon wiring of the device. Check the datasheet for details. The i2c_address
#   can be specified directly instead of using the address_pin.
```

Der Chip stellt Pins bereit, die für andere Sensoren verwendet werden können.

```
sensor_type: ...
#   Can be any thermistor or adc_temperature.
sensor_pin: my_ads1x1x:AIN0
#   A combination of the name of the ads1x1x chip and the pin. Possible
#   pin values are AIN0, AIN1, AIN2 and AIN3 for single ended lines and
#   DIFF01, DIFF03, DIFF13 and DIFF23 for differential between their
#   corresponding lines. For example
#   DIFF03 measures the differential between line 0 and 3. Only specific
#   combinations for the differentials are allowed.
```

### [replicape]

Replicape-Unterstützung - siehe die [Beaglebone-Anleitung](Beaglebone.md) und die Datei [generic-replicape.cfg](../config/generic-replicape.cfg) für ein Beispiel.

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

## Weitere spezifische Module

### [palette2]

Unterstützung für Palette 2 Multimaterial - bietet eine engere Integration für Palette-2-Geräte im verbundenen Modus.

Dieses Modul erfordert für den vollen Funktionsumfang außerdem `[virtual_sdcard]` und `[pause_resume]`.

Wenn Sie dieses Modul verwenden, nutzen Sie nicht zusätzlich das Palette-2-Plugin für OctoPrint, da sich beide gegenseitig stören und eines von beiden nicht korrekt initialisiert wird, was Ihren Druck wahrscheinlich abbricht.

Wenn Sie OctoPrint verwenden und G-Code über die serielle Schnittstelle streamen, anstatt von virtual_sd zu drucken, verhindert das Entfernen von **M1** und **M0** aus *Pausing commands* unter *Settings > Serial Connection > Firmware & protocol*, dass Sie den Druck auf der Palette 2 starten und in OctoPrint die Pause aufheben müssen, damit Ihr Druck beginnt.

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

### [angle]

Unterstützung für magnetische Hall-Winkelsensoren zum Auslesen von Winkelmessungen an Schrittmotorwellen über die SPI-Chips a1333, as5047d, mt6816, mt6826s oder tle5012b. Die Messwerte stehen über den [API-Server](API_Server.md) und das [Bewegungsanalyse-Werkzeug](Debugging.md#motion-analysis-and-data-logging) zur Verfügung. Die verfügbaren Befehle finden Sie in der [G-Code-Referenz](G-Codes.md#angle).

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

## Allgemeine Bus Parameter

### Gebräuchliche SPI Einstellungen

Die folgenden Parameter stehen allgemein für Geräte zur Verfügung, die einen SPI-Bus verwenden.

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

### Gebräuchliche I2C Einstellungen

Die folgenden Parameter stehen allgemein für Geräte zur Verfügung, die einen I2C-Bus verwenden.

Beachten Sie, dass die aktuelle I2C-Unterstützung in Klippers Mikrocontroller-Code im Allgemeinen nicht störungstolerant gegenüber Leitungsrauschen ist. Unerwartete Fehler auf den I2C-Leitungen können dazu führen, dass Klipper einen Laufzeitfehler auslöst. Die Unterstützung für Fehlerbehebung ist je nach Mikrocontrollertyp unterschiedlich. Es wird generell empfohlen, nur I2C-Geräte zu verwenden, die sich auf derselben Leiterplatte wie der Mikrocontroller befinden.

Die meisten Klipper-Mikrocontroller-Implementierungen unterstützen nur eine `i2c_speed` von 100000 (*Standard Mode*, 100 kbit/s). Der Klipper-Mikrocontroller "Linux" unterstützt eine Geschwindigkeit von 400000 (*Fast Mode*, 400 kbit/s), diese muss jedoch [im Betriebssystem eingestellt werden](RPi_microcontroller.md#optional-enabling-i2c); der Parameter `i2c_speed` wird andernfalls ignoriert. Der Klipper-Mikrocontroller "RP2040", die ATmega-AVR-Familie und einige STM32 (F0, G0, G4, L4, F7, H7) unterstützen über den Parameter `i2c_speed` eine Rate von 400000. Alle anderen Klipper-Mikrocontroller verwenden eine Rate von 100000 und ignorieren den Parameter `i2c_speed`.

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
