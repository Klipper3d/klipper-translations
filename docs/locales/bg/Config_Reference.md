# Справка за конфигурацията

Този документ представлява справка за наличните опции в конфигурационния файл на Klipper.

Описанията в този документ са форматирани така, че да е възможно да бъдат изрязани и поставени във файл с конфигурацията на принтера. Вижте [инсталационния документ](Installation.md) за информация относно настройката на Klipper и избора на първоначален конфигурационен файл.

## Конфигуриране на микроконтролера

### Формат на имената на пиновете на микроконтролера

Много опции за конфигуриране изискват името на пин на микроконтролера. Klipper използва хардуерните имена на тези пинове - например `PA4`.

Имената на изводите могат да бъдат предшествани от `!`, за да се укаже, че трябва да се използва обратна полярност (напр. задействане при нисък вместо при висок сигнал).

Входните пинове могат да бъдат предшествани от `^`, за да се укаже, че за пина трябва да се включи хардуерен издърпващ резистор. Ако микроконтролерът поддържа издърпващи резистори, тогава входният щифт може да бъде предшестван от `~`.

Обърнете внимание, че някои секции на конфигурацията могат да "създадат" допълнителни щифтове. Когато това се случи, секцията за конфигуриране, която дефинира изводите, трябва да бъде посочена във файла за конфигуриране преди всички секции, които използват тези изводи.

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

Разделът за принтера управлява настройките на принтера на високо ниво.

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

Дефиниции на стъпкови двигатели. Различните типове принтери (както е посочено от опцията "kinematics" в раздела [printer] config) изискват различни имена за стъпковия двигател (например `stepper_x` срещу `stepper_a`). По-долу са дадени общи дефиниции на стъпков механизъм.

Вижте документа [rotation distance](Rotation_Distance.md) за информация относно изчисляването на параметъра `rotation_distance`. Вижте документа [Multi-MCU homing](Multi_MCU_Homing.md) за информация относно насочването с помощта на няколко микроконтролера.

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

### Декартова кинематика

Вижте [example-cartesian.cfg](../config/example-cartesian.cfg) за примерен файл за конфигуриране на картезианска кинематика.

Тук са описани само параметрите, специфични за картезианските принтери - вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

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

Вижте [example-delta.cfg](../config/example-delta.cfg) за примерен конфигурационен файл за линейна делта кинематика. Вижте ръководството [delta calibrate guide]( Delta_Calibrate.md) за информация относно калибрирането.

Тук са описани само параметрите, характерни за линейните делта-принтери - вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

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

### Делта кинематика

Вижте [example-deltesian.cfg](../config/example-deltesian.cfg) за примерен файл за конфигуриране на делтезианска кинематика.

Тук са описани само параметрите, специфични за делтезианските принтери - вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

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

### Кинематика CoreXY

Вижте [example-corexy.cfg](../config/example-corexy.cfg) за примерен файл за кинематика на corexy (и h-bot).

Тук са описани само параметрите, специфични за принтерите corexy - вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

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

### Кинематика CoreXZ

Вижте [example-corexz.cfg](../config/example-corexz.cfg) за примерен конфигурационен файл за кинематика на corexz.

Тук са описани само параметрите, специфични за принтерите corexz - вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

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

### Кинематика CoreXY Хибрид

Вижте [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg) за примерен файл за конфигурация на хибридната кинематика на corexy.

Тази кинематика е известна и като Markforged кинематика.

Тук са описани само параметрите, характерни за хибридните принтери за корекси, вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

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

### Кинематика CoreXZ Хибрид

Вижте [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg) за примерен файл за конфигуриране на хибридна кинематика corexz.

Тази кинематика е известна и като Markforged кинематика.

Тук са описани само параметрите, характерни за хибридните принтери за корекси, вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

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

### Полярна кинематика

Вижте [example-polar.cfg](../config/example-polar.cfg) за примерен файл за конфигурация на полярната кинематика.

Тук са описани само параметрите, специфични за полярните принтери - вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

ПОЛЯРНАТА КИНЕМАТИКА Е В ПРОЦЕС НА РАЗРАБОТКА. Известно е, че движенията около позиция 0, 0 не работят правилно.

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

### Ротационна делта кинематика

Вижте [example-rotary-delta.cfg](../config/example-rotary-delta.cfg) за примерен файл за конфигуриране на ротационна делта кинематика.

Тук са описани само параметрите, специфични за ротационните делта-принтери - вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

РОТАЦИОННАТА ДЕЛТАКИНЕМАТИКА Е В ПРОЦЕС НА РАЗРАБОТКА. Движенията за насочване могат да се забавят и някои гранични проверки не са реализирани.

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

Вижте файла [example-winch.cfg](../config/example-winch.cfg) за примерен файл за конфигуриране на кинематиката на кабелната лебедка.

Тук са описани само параметрите, специфични за принтерите на кабелни лебедки - вижте [общи кинематични настройки](#common-kinematic-settings) за наличните параметри.

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

### Няма Кинематика

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

Разделът за екструдера се използва за описване на параметрите на нагревателя за горещата част на дюзата, както и на стъпковия механизъм за управление на екструдера. За допълнителна информация вижте [справка за командите](G-Codes.md#extruder). За информация относно настройката на аванса на налягането вижте [ръководство за аванса на налягането](Pressure_Advance.md).

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

Разделът heater_bed описва отопляемо легло. Той използва същите настройки на нагревателя, описани в раздела "Екструдер".

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

Изравняване на мрежестото легло. Може да се дефинира конфигурационен раздел bed_mesh, за да се активират трансформации на преместване, които изместват оста z въз основа на мрежа, генерирана от сондирани точки. Когато се използва сонда за насочване на оста z, се препоръчва да се дефинира секция safe_z_home в printer.cfg, за да се насочи към центъра на зоната за печат.

За допълнителна информация вижте [ръководство за мрежа на легло](Bed_Mesh.md) и [справка за командите](G-Codes.md#bed_mesh).

Визуални примери:

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

Компенсация на наклона на леглото. Може да се дефинира конфигурационен раздел bed_tilt, за да се активират трансформациите на движенията, които отчитат наклоненото легло. Обърнете внимание, че bed_mesh и bed_tilt са несъвместими; и двете не могат да бъдат дефинирани.

За допълнителна информация вижте [справка за командата](G-Codes.md#bed_tilt).

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

Инструмент за регулиране на винтовете за нивелиране на леглото. Може да се дефинира конфигурационен раздел [bed_screws], за да се активира g-кодова команда BED_SCREWS_ADJUST.

За допълнителна информация вижте [ръководство за нивелиране](Manual_Level.md#adjusting-bed-leveling-screws) и [справка за команди](G-Codes.md#bed_screws).

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

Инструмент за регулиране на наклона на винтовете на леглото с помощта на Z-сонда. Може да се дефинира конфигурационна секция screws_tilt_adjust, за да се активира командата SCREWS_TILT_CALCULATE g-code.

За допълнителна информация вижте [ръководство за нивелиране](Manual_Level.md#adjusting-bed-leveling-screwing-using-the-bed-probe) и [справка за команди](G-Codes.md#screws_tilt_adjust).

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

Многократно регулиране на наклона на стъпката Z. Тази функция позволява независима настройка на няколко Z-стъпки (вж. раздела "stepper_z1"), за да се регулира наклонът. Ако този раздел е налице, тогава разширената [G-Code команда](G-Codes.md#z_tilt) Z_TILT_ADJUST става достъпна.

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

Изравняване на портала с помощта на 4 независимо управлявани Z-мотора. Коригира ефекта на хиперболичната парабола (картофен чипс) при подвижния портал, който е по-гъвкав. ПРЕДУПРЕЖДЕНИЕ: Използването на тази функция върху движещо се легло може да доведе до нежелани резултати. Ако този раздел е налице, тогава става достъпна разширената команда QUAD_GANTRY_LEVEL на G-Code. Тази процедура предполага следната конфигурация на двигателя Z:

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

Където x е точката 0, 0 на леглото

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

Корекция на наклона на принтера. Възможно е да се използва софтуер за коригиране на изкривяването на принтера в 3 равнини: xy, xz, yz. Това става чрез отпечатване на калибровъчен модел по протежение на една равнина и измерване на три дължини. Поради естеството на корекцията на наклона тези дължини се задават чрез gcode. За подробности вижте [Skew Correction](Skew_Correction.md) и [Command Reference](G-Codes.md#skew_correction).

```
[skew_correction]
```

### [z_thermal_adjust]

Регулиране на позицията Z на главата на инструмента в зависимост от температурата. Компенсиране на вертикалното движение на главата на инструмента, причинено от температурното разширение на рамката на принтера, в реално време с помощта на температурен сензор (обикновено свързан с вертикална секция на рамката).

Вижте също: [extended g-code commands](G-Codes.md#z_thermal_adjust).

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

Безопасно насочване по Z. Този механизъм може да се използва за насочване на оста Z към определена координата X, Y. Това е полезно, ако например главата на инструмента трябва да се придвижи до центъра на леглото, преди Z да бъде ориентирана.

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

Крайни ограничители с регулиране на фазата на стъпковия механизъм. За да използвате тази функция, дефинирайте секция от конфигурацията с префикс "endstop_phase", последван от името на съответната секция от конфигурацията на стъпковия механизъм (например "[endstop_phase stepper_z]"). Тази функция може да подобри точността на крайните спиращи превключватели. Добавете гола декларация "[endstop_phase]", за да активирате командата ENDSTOP_PHASE_CALIBRATE.

За допълнителна информация вижте [Ръководство за фазите на спиране](Endstop_Phase.md) и [Справка за командите](G-Codes.md#endstop_phase).

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

Поддържа запаметяване на променливи на диска, така че те да се запазват при рестартиране. За допълнителна информация вижте [шаблони на команди](Command_Templates.md#save-variables-to-disk) и [G-Code reference](G-Codes.md#save_variables).

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

## Допълнителни функции на G-Code

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
#   See docs/Command_Templates.md for G-Code format. The default is to
#   run TURN_OFF_HEATERS.
```

### [sdcard_loop]

Някои принтери с функции за изчистване на етапи, като например изхвъргач на части или лентов принтер, могат да намерят приложение в цикличните секции на файла sdcard. (Например, за отпечатване на една и съща част отново и отново или за повтаряне на участък от част за верига или друг повтарящ се модел).

Вижте [справка за командите](G-Codes.md#sdcard_loop) за поддържаните команди. Вижте файла [sample-macros.cfg](../config/sample-macros.cfg) за G-Code макрос, съвместим с Marlin M808.

```
[sdcard_loop]
```

### [force_move]

Поддържа ръчно преместване на стъпкови двигатели за диагностични цели. Обърнете внимание, че използването на тази функция може да доведе до невалидно състояние на принтера - вижте [справка за командите](G-Codes.md#force_move) за важни подробности.

```
[force_move]
#enable_force_move: False
# Задайте стойност true, за да активирате FORCE_MOVE и SET_KINEMATIC_POSITION
# разширени команди на G-Code. По подразбиране е false.
```

### [pause_resume]

Функции за пауза/възобновяване с поддръжка на заснемане и възстановяване на позиции. За повече информация вижте [справка за командите](G-Codes.md#pause_resume).

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

Поддръжка на командите gcode arc (G2/G3).

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

За допълнителна информация вижте [ръководство за изключване на обекти](Exclude_Object.md) и [справка за командата](G-Codes.md#excludeobject). Вижте файла [sample-macros.cfg](../config/sample-macros.cfg) за макрос, съвместим с Marlin/RepRapFirmware M486 G-Code.

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

Поддръжка на акселерометри ADXL345. Тази поддръжка позволява да се правят справки за измерванията на акселерометъра от сензора. Това активира командата ACCELEROMETER_MEASURE (за повече информация вижте [G-Codes](G-Codes.md#adxl345)). Името на чипа по подразбиране е "default" (по подразбиране), но може да се посочи изрично име (например [adxl345 my_chip_name]).

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

### [icm20948]

Support for icm20948 accelerometers.

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

Поддръжка на акселерометри LIS2DW.

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

Поддръжка на акселерометри MPU-9250, MPU-9255, MPU-6515, MPU-6050 и MPU-6500 (може да се дефинират произволен брой секции с префикс "mpu9250").

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

Поддръжка на резонансни тестове и автоматично калибриране на входните форми. За да се използва по-голямата част от функционалността на този модул, трябва да се инсталират допълнителни софтуерни зависимости; за повече информация вижте [Measuring Resonances](Measuring_Resonances.md) и [command reference](G-Codes.md#resonance_tester). Вижте раздела [Максимално изглаждане](Measuring_Resonances.md#max-smoothing) на ръководството за измерване на резонанси за повече информация относно параметъра `max_smoothing` и неговото използване.

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

Този инструмент позволява един пин на микроконтролера да бъде дефиниран многократно в конфигурационен файл без нормална проверка за грешки. Това е предназначено за диагностика и отстраняване на грешки. Този раздел не е необходим в случаите, когато Klipper поддържа многократно използване на един и същ пин, а използването на тази промяна може да доведе до объркващи и неочаквани резултати.

```
[duplicate_pin_override]
пинове:
# Списък с пинове, разделени със запетая, които могат да се използват многократно в
# файл за конфигуриране без нормални проверки за грешки. Този параметър трябва да бъде
# осигурен.
```

## Хардуер за сондиране на легло

### [probe]

Сонда за височина Z. Този раздел може да се дефинира, за да се активира хардуерът за измерване на височината Z. Когато този раздел е активиран, стават достъпни разширените [g-кодови команди] PROBE и QUERY_PROBE (G-Codes.md#probe). Също така, вижте [ръководство за калибриране на сонда](Probe_Calibrate.md). Секцията на сондата също така създава виртуален щифт "probe:z_virtual_endstop". Може да се зададе Stepper_z endstop_pin към този виртуален щифт на принтерите в картезиански стил, които използват сондата вместо z endstop. Ако използвате "probe:z_virtual_endstop", не дефинирайте position_endstop в раздела за конфигурация на stepper_z.

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

"Smart Effector" от Duet3d реализира Z-сонда с помощта на сензор за сила. Може да се дефинира този раздел вместо `[probe]`, за да се активират специфичните функции на Smart Effector. Това също така дава възможност на [runtime commands](G-Codes.md#smart_effector) да се настройват параметрите на Smart Effector по време на работа.

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

Поддръжка на индуктивни сонди за вихрови токове. Може да се дефинира този раздел (вместо раздел за сонда), за да се активира тази сонда. За повече информация вижте [справка за командите](G-Codes.md#probe_eddy_current).

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

A tool to compensate for inaccurate probe readings due to twist in X or Y gantry. See the [Axis Twist Compensation Guide](Axis_Twist_Compensation.md) for more detailed information regarding symptoms, configuration and setup.

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

## Допълнителни стъпкови двигатели и екструдери

### [stepper_z1]

Оси с многостранно управление. При принтер в картезиански стил стъпковият механизъм, контролиращ дадена ос, може да има допълнителни блокове за конфигуриране, определящи стъпкови механизми, които трябва да се задействат съвместно с основния стъпков механизъм. Могат да се дефинират произволен брой секции с цифров суфикс, започващ от 1 (например "stepper_z1", "stepper_z2" и т.н.).

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

Вижте [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg) за примерна конфигурация.

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

Поддръжка на картезиански и хибридни_corexy/z принтери с две колички на една ос. Режимът на каретките може да се зададе чрез разширената g-кодова команда SET_DUAL_CARRIAGE. Например командата "SET_DUAL_CARRIAGE CARRIAGE=1" ще активира каретата, определена в този раздел (CARRIAGE=0 ще върне активирането към основната карета). Поддръжката на двойна каретка обикновено се комбинира с допълнителни екструдери - командата SET_DUAL_CARRIAGE често се извиква едновременно с командата ACTIVATE_EXTRUDER. Не забравяйте да паркирате каретките по време на деактивирането. Обърнете внимание, че по време на насочването на G28 обикновено първо се насочва основната количка, последвана от количката, определена в секцията за конфигуриране `[dual_carriage]`. Въпреки това, каретата `[dual_carriage]` ще бъде насочена първа, ако и двете карета се насочат в положителна посока и каретата [dual_carriage] има `position_endstop` по-голяма от основната карета, или ако и двете карета се насочат в отрицателна посока и каретата `[dual_carriage]` има `position_endstop` по-малка от основната карета.

Освен това може да се използват командите "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY" или "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR", за да се активира режим на копиране или огледален режим на двойната каретка, като в този случай тя ще следва съответно движението на каретка 0. Тези команди могат да се използват за отпечатване на две части едновременно - две идентични части (в режим COPY) или огледални части (в режим MIRROR). Обърнете внимание, че режимите COPY (копиране) и MIRROR (огледален печат) изискват и подходящо конфигуриране на екструдера на двойната каретка, което обикновено може да се постигне с "SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=<dual_carriage_extruder>" или подобна команда.

See [sample-idex.cfg](../config/sample-idex.cfg) for an example configuration.

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

Поддръжка на допълнителни степери, синхронизирани с движението на екструдера (може да се дефинират произволен брой секции с префикс "extruder_stepper").

За повече информация вижте [справка за командите](G-Codes.md#extruder).

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

Инструмент за деактивиране на нагревателите при насочване или сондиране на ос.

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

### [temperature_probe]

Отчита температурата на намотката на сондата. Включва опционално калибриране на термичния дрейф за сонди, базирани на вихрови токове. Раздел `[temperature_probe]` може да бъде свързан с раздел `[probe_eddy_current]`, като се използва един и същ постфикс и за двата раздела.

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

## Температурни сензори

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

### Температурни сензори MAXxxxxx

Температурни сензори със сериен периферен интерфейс (SPI) MAXxxxxx. Следните параметри са налични в секциите на нагревателите, които използват един от тези типове сензори.

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

### Температурен сензор BMP180/BMP280/BME280/BMP388/BME680

Сензори за околна среда BMP180/BMP280/BME280/BMP388/BME680 с двупроводен интерфейс (I2C). Имайте предвид, че тези сензори не са предназначени за използване с екструдери и нагреватели, а по-скоро за наблюдение на температурата на околната среда (C), налягането (hPa), относителната влажност и в случай на BME680 - нивото на газа. Вижте [sample-macros.cfg](../config/sample-macros.cfg) за gcode_macro, който може да се използва за отчитане на налягането и влажността в допълнение към температурата.

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

### Температурен сензор AHT10/AHT20/AHT21

Сензори за околна среда AHT10/AHT20/AHT21 с двупроводен интерфейс (I2C). Имайте предвид, че тези сензори не са предназначени за използване с екструдери и нагреватели, а по-скоро за наблюдение на температурата на околната среда (C) и относителната влажност. Вижте [sample-macros.cfg](../config/sample-macros.cfg) за gcode_macro, който може да се използва за отчитане на влажността в допълнение към температурата.

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

### Сензор SHT3X

Сензор за околна среда от семейство SHT3X с двупроводен интерфейс (I2C). Диапазонът на тези сензори е -55~125 C, така че могат да се използват например за наблюдение на температурата в камерата. Те могат да функционират и като прости контролери на вентилатори/нагреватели.

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

Микроконтролерите atsam, atsamd и stm32 съдържат вътрешен температурен сензор. За наблюдение на тези температури може да се използва сензорът "temperature_mcu".

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

Температура от машината (напр. Raspberry Pi), на която е инсталиран хост софтуерът.

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

### Комбиниран температурен сензор

Комбинираният температурен сензор е виртуален температурен сензор, базиран на няколко други сензора. Този сензор може да се използва с екструдери, нагревател_generic и нагревателни легла.

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

## Вентилатори

### [вентилатор]

Вентилатор за охлаждане на печата.

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

Вентилатори за охлаждане, задействани от температурата (могат да се дефинират произволен брой секции с префикс "temperature_fan"). "Температурен вентилатор" е вентилатор, който се активира, когато свързаният с него сензор е над определена температура. По подразбиране температурният вентилатор има скорост на изключване, равна на max_power.

За допълнителна информация вижте [справка за командата](G-Codes.md#temperature_fan).

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

Поддръжка на светодиоди (и светодиодни ленти), управлявани чрез ШИМ изводите на микроконтролера (може да се дефинират произволен брой секции с префикс "led"). За повече информация вижте [справка за командите](G-Codes.md#led).

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

Поддръжка на светодиоди Neopixel (известни още като WS2812) (може да се дефинират произволен брой секции с префикс "neopixel"). За повече информация вижте [справка за командите](G-Codes.md#led).

Имайте предвид, че реализацията на [linux mcu](RPi_microcontroller.md) понастоящем не поддържа директно свързани неопиксели. Настоящият проект, използващ интерфейса на ядрото на Linux, не позволява този сценарий, тъй като интерфейсът GPIO на ядрото не е достатъчно бърз, за да осигури необходимата честота на импулсите.

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

Поддръжка на светодиод PCA9533. PCA9533 се използва на платката mightyboard.

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

Поддръжка на светодиода PCA9632. PCA9632 се използва във FlashForge Dreamer.

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

Сервозадвижвания (може да се дефинират произволен брой секции с префикс "servo"). Сервоприводите могат да се управляват с помощта на командата SET_SERVO [g-code](G-Codes.md#servo). Например: SET_SERVO SERVO=my_servo ANGLE=180

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

Конфигурируеми по време на работа изходни щифтове (могат да се дефинират произволен брой секции с префикс "output_pin"). Конфигурираните тук щифтове ще бъдат настроени като изходни щифтове и могат да се променят по време на работа с помощта на разширените [g-code commands](G-Codes.md#output_pin) от типа "SET_PIN PIN=my_pin VALUE=.1".

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

Цифрови изходни щифтове с широчинно-импулсна модулация, които могат да се актуализират с висока скорост (може да се дефинират произволен брой секции с префикс "output_pin"). Конфигурираните тук щифтове ще бъдат настроени като изходни щифтове и могат да се променят по време на работа с помощта на разширени [g-code commands] (G-Codes.md#output_pin) от типа "SET_PIN PIN=my_pin VALUE=.1".

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

Конфигурируеми по време на работа изходни щифтове с динамично синхронизиране на циклите pwm (може да се дефинират произволен брой секции с префикс "pwm_cycle_time"). Конфигурираните тук щифтове ще бъдат настроени като изходни щифтове и могат да се променят по време на работа с помощта на разширени [g-code commands] (G-Codes.md#pwm_cycle_time) от типа "SET_PIN PIN=my_pin VALUE=.1 CYCLE_TIME=0.100".

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

Статично конфигурирани цифрови изходни щифтове (може да се дефинират произволен брой секции с префикс "static_digital_output"). Конфигурираните тук пинове ще бъдат настроени като GPIO изход по време на конфигурирането на MCU. Те не могат да бъдат променяни по време на работа.

```
[static_digital_output my_output_pins]
pins:
#   A comma separated list of pins to be set as GPIO output pins. The
#   pin will be set to a high level unless the pin name is prefaced
#   with "!". This parameter must be provided.
```

### [multi_pin]

Изходи с множество изводи (може да се дефинират произволен брой секции с префикс "multi_pin"). Изходът с няколко извода създава вътрешен псевдоним на извод, който може да променя няколко извода всеки път, когато псевдонимът на извода е зададен. Например може да се дефинира обект "[multi_pin my_fan]", съдържащ два извода, и след това да се зададе "pin=multi_pin:my_fan" в секцията "[fan]" - при всяка промяна на вентилатора ще се актуализират и двата изходни извода. Тези псевдоними не могат да се използват с изводи на стъпкови двигатели.

```
[multi_pin my_multi_pin]
pins:
#   A comma separated list of pins associated with this alias. This
#   parameter must be provided.
```

## Конфигурация на стъпковия драйвер TMC

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

Конфигуриране на драйвер на стъпков двигател TMC2240 чрез SPI шина или UART. За да използвате тази функция, дефинирайте секция за конфигуриране с префикс "tmc2240", последван от името на съответната секция за конфигуриране на стъпков двигател (например "[tmc2240 stepper_x]").

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

## Конфигурация на тока на стъпковия двигател по време на работа

### [ad5206]

Статично конфигурирани цифрови модули AD5206, свързани чрез SPI шина (може да се дефинират произволен брой секции с префикс "ad5206").

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

Статично конфигуриран дигипот MCP4451, свързан чрез шина I2C (може да се дефинират произволен брой секции с префикс "mcp4451").

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

Статично конфигуриран цифрово-аналогов преобразувател MCP4728, свързан чрез шина I2C (може да се дефинират произволен брой секции с префикс "mcp4728").

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

Статично конфигуриран MCP4018 digipot, свързан чрез два gpio "bit banging" пина (може да се дефинират произволен брой секции с префикс "mcp4018").

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

Поддръжка на дисплей, свързан към микроконтролера.

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

#### дисплей на st7920

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

#### дисплей uc1701

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

#### Дисплеи ssd1306 и sh1106

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

Поддръжка за показване на потребителски данни на LCD екран. Може да се създадат произволен брой групи за показване и произволен брой елементи за данни в тези групи. Дисплеят ще покаже всички елементи на данни за дадена група, ако опцията display_group в раздела [display] е зададена на името на дадената група.

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

Тази функция позволява да се намалят повтарящите се дефиниции в секциите display_data. Може да се използва вградената функция `render()` в секциите display_data, за да се оцени шаблон. Например, ако се дефинира `[display_template my_template]`, тогава може да се използва `{ render('my_template') }` в секция display_data.

Тази функция може да се използва и за непрекъснати актуализации на светодиодите, като се използва командата [SET_LED_TEMPLATE](G-Codes.md#set_led_template).

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

За информация относно атрибутите на менюто, налични по време на изобразяването на шаблона, вижте документа [шаблони на команди](Command_Templates.md#menu-templates).

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

За повече информация вижте [препратка към командата](G-Codes.md#filament_switch_sensor).

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

Сензор за движение с нишки. Поддръжка за откриване на вмъкване и изтичане на нишка с помощта на енкодер, който превключва изходния щифт по време на движението на нишката през сензора.

За повече информация вижте [препратка към командата](G-Codes.md#filament_switch_sensor).

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

Сензор за ширината на нишката на базата на TSLl401CL. За повече информация вижте [ръководството](TSL1401CL_Filament_Width_Sensor.md).

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

## Load Cells

### [load_cell]

Клетка за натоварване. Използва ADC сензор, прикрепен към клетка за натоварване, за да създаде цифрова скала.

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

Това е 24-битов чип с ниска честота на дискретизация, който използва "bit-bang" комуникации. Той е подходящ за везни с нишки.

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

Това е версията на HX711 с 4 пъти по-висока честота на дискретизация, подходяща за сондиране.

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

ADS1220 е 24-битов АЦП, поддържащ честота на дискретизация до 2Khz, която може да се конфигурира софтуерно.

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

## Специфична хардуерна поддръжка на борда

### [sx1509]

Конфигуриране на разширител SX1509 I2C към GPIO. Поради закъснението, което се получава при I2C комуникацията, НЕ трябва да използвате изводите на SX1509 като изводи за разрешаване на стъпковия механизъм, стъпка или дир или други изводи, които изискват бърза обработка на битове. Най-добре е те да се използват като статични или управлявани от gcode цифрови изходи или като хардуерни-pwm изводи, например за вентилатори. Може да се дефинират произволен брой секции с префикс "sx1509". Всеки разширител предоставя набор от 16 извода (sx1509_my_sx1509:PIN_0 до sx1509_my_sx1509:PIN_15), които могат да се използват в конфигурацията на принтера.

За пример вижте файла [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg).

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

Конфигурация на SAMD SERCOM за определяне на изводите, които да се използват в даден SERCOM. Може да се дефинират произволен брой секции с префикс "samd_sercom". Всеки SERCOM трябва да се конфигурира, преди да се използва като SPI или I2C периферно устройство. Поставете този раздел за конфигуриране над всеки друг раздел, в който се използват шини SPI или I2C.

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

За пример вижте файла [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg).

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

### [ads1x1x]

ADS1013, ADS1014, ADS1015, ADS1113, ADS1114 and ADS1115 are I2C based Analog to Digital Converters that can be used for temperature sensors. They provide 4 analog input pins either as single line or as differential input.

Note: Use caution if using this sensor to control heaters. The heater min_temp and max_temp are only verified in the host and only if the host is running and operating normally. (ADC inputs directly connected to the micro-controller verify min_temp and max_temp within the micro-controller and do not require a working connection to the host.)

```
[ads1x1x my_ads1x1x]
chip: ADS1115
#pga: 4.096V
#   Default value is 4.096V. The maximum voltage range used for the input. This
#   scales all values read from the ADC. Options are: 6.144V, 4.096V, 2.048V,
#   1.024V, 0.512V, 0.256V
#adc_voltage: 3.3
#   The suppy voltage for the device. This allows additional software scaling
#   for all values read from the ADC.
i2c_mcu: host
i2c_bus: i2c.1
#address_pin: GND
#   Default value is GND.  There can be up to four addressed devices depending
#   upon wiring of the device. Check the datasheet for details. The i2c_address
#   can be specified directly instead of using the address_pin.
```

The chip provides pins that can be used on other sensors.

```
sensor_type: ...
#   Can be any thermistor or adc_temperature.
sensor_pin: my_ads1x1x:AIN0
#   A combination of the name of the ads1x1x chip and the pin. Possible
#   pin values are AIN0, AIN1, AIN2 and AIN3 for single ended lines and
#   DIFF01, DIFF03, DIFF13 and DIFF23 for differential between their
#   correspoding lines. For example
#   DIFF03 measures the differential between line 0 and 3. Only specific
#   combinations for the differentials are allowed.
```

### [replicape]

Поддръжка на Replicape - за пример вижте [beaglebone guide](Beaglebone.md) и файла [generic-replicape.cfg](../config/generic-replicape.cfg).

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

## Други персонализирани модули

### [palette2]

Поддръжка на мултиматериали от Palette 2 - осигурява по-тясна интеграция, като поддържа устройства от Palette 2 в свързан режим.

Този модул изисква също така `[virtual_sdcard]` и `[pause_resume]` за пълна функционалност.

Ако използвате този модул, не използвайте приставката Palette 2 за Octoprint, тъй като те ще си противоречат и 1 няма да успее да се инициализира правилно, което вероятно ще доведе до прекъсване на печата.

If you use Octoprint and stream gcode over the serial port instead of printing from virtual_sd, then remove **M1** and **M0** from *Pausing commands* in *Settings > Serial Connection > Firmware & protocol* will prevent the need to start print on the Palette 2 and unpausing in Octoprint for your print to begin.

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

## Общи параметри на шината

### Общи настройки на SPI

Следните параметри са общодостъпни за устройства, използващи шина SPI.

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

Следните параметри са общодостъпни за устройства, използващи шина I2C.

Обърнете внимание, че текущата поддръжка на I2C от страна на микроконтролера Klipper обикновено не е толерантна към линейни шумове. Неочаквани грешки по I2C проводниците могат да доведат до това Klipper да обяви грешка по време на изпълнение. Поддръжката на Klipper за възстановяване на грешки е различна за всеки тип микроконтролер. Обикновено се препоръчва да се използват само I2C устройства, които са на същата печатна платка като микроконтролера.

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
