# 配置参考

本文档是 Klipper 配置文件中可用配置分段的参考。

本文档中的描述已经格式化，以便可以将它们剪切并粘贴到打印机配置文件中。 见 [installation document](Installation.md) 有关设置 Klipper 和选择初始配置文件的信息。

## 微控制器配置

### 微控制器引脚名字的格式

许多配置选项需要微控制器引脚的名称。Klipper 使用了这些引脚的硬件名称 - 例如`PA4`。

在 引脚名称前加 `!`来表示相反的电极极性（ 例如触发条件时低电平而不是高电平）。

在引脚名称前面加 `^` ，以指示该引脚启用硬件上拉电阻。如果微控制器支持下拉电阻器，那么输入引脚也可以在前面加上`~`。

注意，某些配置部分可能会“创建”额外的引脚。 如果发生这种情况，定义引脚的配置部分必须在使用这些引脚的任何部分之前列在配置文件中。

### [MCU]

主微控制器的配置。

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

### 额外的mcu [mcu my_extra_mcu]

额外的微控制器（可以定义任意数量的带有“mcu”前缀的部分）。 额外的微控制器引入了额外的引脚，这些引脚可以配置为加热器、步进器、风扇等。例如，如果引入了“[mcu extra_mcu]”部分，那么诸如“extra_mcu:ar9”之类的引脚就可以在其他地方使用 ，在配置中（其中“ar9”是给定 mcu 上的硬件引脚名称或别名）。

```
[mcu my_extra_mcu]
# See the "mcu" section for configuration parameters.
```

## 常用的运动学设置

### [打印]

打印机控制的高级设置部分。

```
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid-corexy, hybrid-corexz, rotary_delta, delta,
#   polar, winch, or none. This
#   parameter must be specified.
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

步进电机定义。 不同的打印机类型（由 [打印] 配置部分中的“运动学”选项指定）步进器需要定义不同的名称（例如，`stepper_x` 与 `stepper_a`）。 以下是常见的步进器定义。

有关计算`rotation_distance`参数的信息，请参阅[旋转距离文档](Rotation_Distance.md) 。

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
endstop_pin:
#   Endstop switch detection pin. This parameter must be provided for
#   the X, Y, and Z steppers on cartesian style printers.
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

### 笛卡尔运动学

有关示例笛卡尔运动学配置文件，请参阅 [example-cartesian.cfg](../config/example-cartesian.cfg)。

此处描述的参数只适用于笛卡尔打印机，有关可用参数，请参阅 [常用运动设置](#common-kinematic-settings)。

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

### 线性三角洲运动学

有关示例线性三角洲运动学配置文件，请参阅 [example-delta.cfg](../config/example-delta.cfg)。 有关校准的信息，请参阅 [三角洲校准指南](Delta_Calibrate.md)。

此处仅描述了线性三角洲打印机的特定参数 - 有关可用参数，请参阅 [常用运动设置](#common-kinematic-settings)。

```
[printer]
kinematics: delta
max_z_velocity:
#   For delta printers this limits the maximum velocity (in mm/s) of
#   moves with z axis movement. This setting can be used to reduce the
#   maximum speed of up/down moves (which require a higher step rate
#   than other moves on a delta printer). The default is to use
#   max_velocity for max_z_velocity.
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

### CoreXY 运动学

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

### CoreXY 运动学

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

POLAR KINEMATICS ARE A WORK IN PROGRESS. Moves around the `0,0` position are known to not work properly.

```
[printer]
kinematics: polar

# The stepper_bed section is used to describe the stepper controlling
# the bed.
[stepper_bed]
gear_ratio:
#   A gear_ratio must be specified and rotation_distance may not be
#   specified. For example, if the bed has an 80 toothed pulley driven
#   by a stepper with a 16 toothed pulley then one would specify a
#   gear ratio of "80:16". This parameter must be provided.
max_z_velocity:
#   This sets the maximum velocity (in mm/s) of movement along the z
#   axis. This setting can be used to restrict the maximum speed of
#   the z stepper motor. The default is to use max_velocity for
#   max_z_velocity.
max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. It limits the acceleration of the z stepper motor. The
#   default is to use max_accel for max_z_accel.

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

### 缆绳绞盘运动学

See the [example-winch.cfg](../config/example-winch.cfg) for an example cable winch kinematics config file.

Only parameters specific to cable winch printers are described here - see [common kinematic settings](#common-kinematic-settings) for available parameters.

缆绳绞盘运动学支持是实验性的。归零尚未在缆绳绞盘运动学中实现。为了将打印机归零，需要手动发送移动命令直到工具头处于 0,0,0 位置，然后发出 ` G28` 命令。

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
#   The x, y, and z position of the cable winch in cartesian space.
#   These parameters must be provided.
```

### None Kinematics

It is possible to define a special "none" kinematics to disable kinematic support in Klipper. This may be useful for controlling devices that are not typical 3d-printers or for debugging purposes.

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   The max_velocity and max_accel parameters must be defined. The
#   values are not used for "none" kinematics.
```

## 通用挤出机和热床支持

### [extruder]

The extruder section is used to describe both the stepper controlling the printer extruder and the heater parameters for the nozzle. See the [pressure advance guide](Pressure_Advance.md) for information on tuning pressure advance.

```
[extruder]
step_pin:
dir_pin:
enable_pin:
microsteps:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#   See the "stepper" section for a description of the above parameters.
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
#   "ATC Semitec 104GT-2", "NTC 100K beta 3950", "Honeywell 100K
#   135-104LAG-J01", "NTC 100K MGB18-104F39050L32", "SliceEngineering
#   450", and "TDK NTCG104LH104JT1". See the "Temperature sensors"
#   section for other sensors. This parameter must be provided.
sensor_pin:
#   Analog input pin connected to the sensor. This parameter must be
#   provided.
#pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the thermistor.
#   This parameter is only valid when the sensor is a thermistor. The
#   default is 4700 ohms.
#smooth_time: 2.0
#   A time value (in seconds) over which temperature measurements will
#   be smoothed to reduce the impact of measurement noise. The default
#   is 2 seconds.
control:
#   Control algorithm (either pid or watermark). This parameter must
#   be provided.
pid_Kp:
#   Kp is the "proportional" constant for the pid. This parameter must
#   be provided for PID heaters.
pid_Ki:
#   Ki is the "integral" constant for the pid. This parameter must be
#   provided for PID heaters.
pid_Kd:
#   Kd is the "derivative" constant for the pid. This parameter must
#   be provided for PID heaters.
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

## 打印床调平支持

### [bed_mesh]

Mesh Bed Leveling. One may define a bed_mesh config section to enable move transformations that offset the z axis based on a mesh generated from probed points. When using a probe to home the z-axis, it is recommended to define a safe_z_home section in printer.cfg to home toward the center of the print area.

See the [bed mesh guide](Bed_Mesh.md) and [command reference](G-Codes.md#mesh-bed-leveling) for additional information.

可视化示例：

```
 rectangular bed, probe_count = 3,3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 round bed, round_probe_count = 5, bed_radius = r:
                x (0,r) end
              /
            x---x---x
                      \
 (-r,0) x---x---x---x---x (r,0)
          \
            x---x---x
                  /
                x  (0,-r) start
```

```
[bed_mesh]
#speed: 50
#   在校准时非探测移动的速度（以毫米每秒(mm/s)为单位）。
#   默认为50。
#horizontal_move_z: 5
#   在探测前打印头必须移动到的高度（以毫米(mm)为单位）。
#   默认为5。
#mesh_radius:
#   定义圆形打印床的网格半径。注意，半径相对于 mesh_origin 
#   选项定义的中心。圆形打印床必须提供这个参数，而长方形
#   打印床必须忽略。
#mesh_origin:
#   定义圆形打印床网格中心的 x,y 坐标。 这个坐标相对于探针
#   位置。可以通过调整 mesh_origin 来最大化网格半径。默认为
#   0,0。长方形打印床必须忽略这个参数。
#mesh_min:
#   定义长方形打印床网格的最小 x,y 坐标。这个坐标相对与探针
#   位置。这将会是第一个被探测，最接近原点的坐标。
#   长方形打印床必须提供这个参数。
#mesh_max:
#   定义长方形打印床网格的极限 x,y 坐标。遵循和 mesh_min  相同
#   的原则，但是这将是离打印床原点最远的点。长方形打印床
#   必须提供这个参数。
#probe_count: 3,3
#   用于长方形打印床，这是一对逗号分隔的整数 (X,Y) ，定义了每个
#   轴向的探测点数。也可以仅用一个整数，这个整数将被应用于两
#   个轴。
#   默认为3,3。
#round_probe_count: 5
#   用于圆形热床，这个整数定义了每个轴的最大探测点数。这个数值
#   必须是一个单数。
#   默认为5。
#fade_start: 1.0
#   在淡出启用时开始淡出修正G代码中z坐标的位置。
#   默认为1.0。
#fade_end: 0.0
#   在淡出启用时结束淡出修正G代码中z坐标的位置。 当这个数值小于
#   fade_start 时，淡出会被禁用。注意，淡出可能会在打印件的z轴上
#   增加不期望的缩放。如果一个用户想启用淡出，10.0是一个推荐数值。
#   默认为 0.0，意味着淡出被禁用。
#fade_target:
#   淡出收敛的目标 z 坐标。当这个数值被设为一个非0数值，它必须
#   在网床的 z 数值之间。希望收敛到 z 归零点的用户应该将它设为0。
#   默认为网床的平均 z 数值。
#split_delta_z: .025
#   单次移动中触发运动分隔的最小 Z 差异（以毫米(mm)为单位）。
#   默认为 .025。
#move_check_distance: 5.0
#   触发 split_delta_z 检测的最小单次移动距离（以毫米(mm)为单位）。
#   这也是移动能被分隔成的最小段。
#   默认为 5.0。
#mesh_pps: 2,2
#   一对逗号分隔的整数 (X,Y)，定义了每个轴每段插值点数。一
#   个“段”是在每个探测点之间的空间。也可以仅用一个整数，这个整
#   数将被应用于两个轴。
#   默认为 2,2。
#algorithm: lagrange
#   使用的插值算法。可以是"lagrange"（拉格朗日）或者"bicubic"（双
#   三次）。 这个选项不影响 3x3 网格，因为它会被强制使用拉格朗日
#   采样。
#   默认为lagrange。
#bicubic_tension: .2
#   在使用双三次算法时，上述张力参数可以改变内插斜率的大小。
#   更大的数值可以增加斜率，增加网格的曲率。
#   默认为 .2。
#relative_reference_index:
#   网格中所有 z 值的一个参考点。启用这个参数会产生一个相对于
#   提供参考点探测的 z 高度的网格。
#faulty_region_1_min:
#faulty_region_1_max:
#   可选的故障区域定义点。详见 docs/Bed_Mesh.md。最多可以定
#   义99个故障区域。
#   默认不设定任何故障区域。
```

### [bed_tilt]

打印床倾斜补偿。可以定义一个 bed_tilt 配置分段来启用移动变换倾斜打印床补偿。请注意，bed_mesh 和 bed_tilt 不兼容：两者无法同时被定义。

See the [command reference](G-Codes.md#bed-tilt) for additional information.

```
[bed_tilt]
#x_adjust: 0
#   每毫米X轴运动的Z高度增量。
#   默认为 0。
#y_adjust: 0
#   每毫米Y轴运动的Z高度增量。
#   默认为 0。
#z_adjust: 0
#   喷嘴在 0,0 时的z高度增量。
#   默认为 0。
#   剩余的参数控制用于校准X和Y调整的 BED_TILT_CALIBRATE 增强G代
#   码命令。
#points:
#   BED_TILT_CALIBRATE 命令探测的 X,Y 坐标的列表（一个一行，后续行
#   缩进。坐标根据喷嘴位置决定，确保在相应喷嘴坐标时探针在打印床上
#   默认不启用此命令。
#speed: 50
#   在校准时非探测移动的速度（以毫米每秒(mm/s)为单位）。
#   默认为50。
#horizontal_move_z: 5
#   在探测前打印头必须移动到的高度（以毫米(mm)为单位）。
#   默认为5。
```

### [bed_screws]

Tool to help adjust bed leveling screws. One may define a [bed_screws] config section to enable a BED_SCREWS_ADJUST g-code command.

See the [leveling guide](Manual_Level.md#adjusting-bed-leveling-screws) and [command reference](G-Codes.md#bed-screws-helper) for additional information.

```
[bed_screws]
#screw1:
#   第一个打印床调平螺丝的 X,Y 坐标。这是命令喷嘴到打印床螺丝
#   正上方的坐标（或在打印床上尽可能接近的坐标）。
#   必须提供这个参数。
#screw1_name:
#   给定螺丝的昵称。在助手脚本运行时会显示这跟昵称。
#   默认为基于螺丝坐标的名称。
#screw1_fine_adjust:
#   这是命令喷嘴到打印床螺丝正上方的 X,Y 坐标用于微调打印床调
#   平螺丝的坐标。 
#   默认不在打印床螺丝上进行微调。
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#   额外的打印床调平螺丝坐标。
#   至少要定义三个螺丝。
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

Tool to help adjust bed screws tilt using Z probe. One may define a screws_tilt_adjust config section to enable a SCREWS_TILT_CALCULATE g-code command.

See the [leveling guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) and [command reference](G-Codes.md#bed-screws-tilt-adjust-helper) for additional information.

```
[screws_tilt_adjust]
#screw1:
#   The X,Y coordinate of the first bed leveling screw. This is a
#   position to command the nozzle to that is directly above the bed
#   screw (or as close as possible while still being above the bed).
#   This is the base screw used in calculations. This parameter must
#   be provided.
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

Multiple Z stepper tilt adjustment. This feature enables independent adjustment of multiple z steppers (see the "stepper_z1" section) to adjust for tilt. If this section is present then a Z_TILT_ADJUST extended [G-Code command](G-Codes.md#z-tilt) becomes available.

```
[z_tilt]
#z_positions:
#   A list of X,Y coordinates (one per line; subsequent lines
#   indented) describing the location of each bed "pivot point". The
#   "pivot point" is the point where the bed attaches to the given Z
#   stepper. It is described using nozzle coordinates (the XY position
#   of the nozzle if it could move directly above the point). The
#   first entry corresponds to stepper_z, the second to stepper_z1,
#   the third to stepper_z2, etc. This parameter must be provided.
#points:
#   A list of X,Y coordinates (one per line; subsequent lines
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

x 是打印床上的 （0，0） 点

```
[quad_gantry_level]
#gantry_corners:
#   A newline separated list of X,Y coordinates describing the two
#   opposing corners of the gantry. The first entry corresponds to Z,
#   the second to Z2. This parameter must be provided.
#points:
#   A newline separated list of four X,Y points that should be probed
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

Printer Skew Correction. It is possible to use software to correct printer skew across 3 planes, xy, xz, yz. This is done by printing a calibration model along a plane and measuring three lengths. Due to the nature of skew correction these lengths are set via gcode. See [skew correction](skew_correction.md) and [command reference](G-Codes.md#skew-correction) for details.

```
[skew_correction]
```

## 自定义归零

### [safe_z_home]

Safe Z homing. One may use this mechanism to home the Z axis at a specific XY coordinate. This is useful if the toolhead, for example has to move to the center of the bed before Z can be homed.

```
[safe_z_home]
home_xy_position:
#   A X,Y coordinate (e.g. 100,100) where the Z homing should be
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
#z_hop_speed: 20.0
#   Speed (in mm/s) at which the Z axis is lifted prior to homing. The
#   default is 20mm/s.
#move_to_previous: False
#   When set to True, xy are reset to their previous positions after z
#   homing. The default is False.
```

### [homing_override]

Homing override. One may use this mechanism to run a series of g-code commands in place of a G28 found in the normal g-code input. This may be useful on printers that require a specific procedure to home the machine.

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

See the [endstop phases guide](Endstop_Phase.md) and [command reference](G-Codes.md#endstop-adjustments-by-stepper-phase) for additional information.

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

## G-Code macros and events

### [gcode_macro]

G-Code macros (one may define any number of sections with a "gcode_macro" prefix). See the [command template guide](Command_Templates.md) for more information.

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

Execute a gcode on a set delay. See the [command template guide](Command_Templates.md#delayed-gcodes) and [command reference](G-Codes.md#delayed-gcode) for more information.

```
[delayed_gcode my_delayed_gcode]。
gcode:
#   当延迟时间结束后执行的G代码命令列表。支持G代码模板。
#   必须提供这个参数。
#initial_duration:0.0
#   初始延迟的持续时间(以秒为单位)。如果设置为一个
#   非零值，delayed_gcode 将在打印机进入 "就绪 "状态后指定
#   秒数后执行。可能对初始化程序或重复的 delayed_gcode 有
#   用。如果设置为 0，delayed_gcode 将在启动时不执行。
# 默认为0。
```

### [save_variables]

Support saving variables to disk so that they are retained across restarts. See [command templates](Command_Templates.md#save-variables-to-disk) and [G-Code reference](G-Codes.md#save-variables) for further information.

```
[save_variables]
filename:
#   必须提供一个可以用来保存参数到磁盘的文件名。
#   例如 . ~/variables.cfg
```

### [idle_timeout]

Idle timeout. An idle timeout is automatically enabled - add an explicit idle_timeout config section to change the default settings.

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

## Optional G-Code features

### [virtual_sdcard]

如果主机的速度不足以很好地运行 OctoPrint，虚拟 SD 卡可能有帮助。它允许 Klipper 主机软件使用标准的 SD 卡G代码命令（例如，M24）直接打印存储在主机目录中的 gcode 文件。

```
[virtual_sdcard]
path:
#   The path of the local directory on the host machine to look for
#   g-code files. This is a read-only directory (sdcard file writes
#   are not supported). One may point this to OctoPrint's upload
#   directory (generally ~/.octoprint/uploads/ ). This parameter must
#   be provided.
```

### [sdcard_loop]

Some printers with stage-clearing features, such as a part ejector or a belt printer, can find use in looping sections of the sdcard file. (For example, to print the same part over and over, or repeat the a section of a part for a chain or other repeated pattern).

See the [command reference](G-Codes.md#sdcard-loop) for supported commands. See the [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin compatible M808 G-Code macro.

```
[sdcard_loop]
```

### [force_move]

Support manually moving stepper motors for diagnostic purposes. Note, using this feature may place the printer in an invalid state - see the [command reference](G-Codes.md#force-movement) for important details.

```
[force_move]
#enable_force_move: False
#   Set to true to enable FORCE_MOVE and SET_KINEMATIC_POSITION
#   extended G-Code commands. The default is false.
```

### [pause_resume]

Pause/Resume functionality with support of position capture and restore. See the [command reference](G-Codes.md#pause-resume) for more information.

```
[pause_resume]
#recover_velocity: 50.
#   When capture/restore is enabled, the speed at which to return to
#   the captured position (in mm/s). Default is 50.0 mm/s.
```

### [firmware_retraction]

Firmware filament retraction. This enables G10 (retract) and G11 (unretract) GCODE commands issued by many slicers. The parameters below provide startup defaults, although the values can be adjusted via the SET_RETRACTION [command](G-Codes.md#firmware-retraction)), allowing per-filament settings and runtime tuning.

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

Support for gcode arc (G2/G3) commands.

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

启用 "M118 "和 "RESPOND "扩展[命令](G-Code.md#send-message-respond tohost)。

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

## Resonance compensation

### [input_shaper]

启用[共振补偿](Resonance_Compensation.md)。也请参见[命令参考](G-Code.md#resonance-compensation)。

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

Support for ADXL345 accelerometers. This support allows one to query accelerometer measurements from the sensor. This enables an ACCELEROMETER_MEASURE command (see [G-Codes](G-Codes.md#adxl345-accelerometer-commands) for more information). The default chip name is "default", but one may specify an explicit name (eg, [adxl345 my_chip_name]).

```
[adxl345]
cs_pin:
#   传感器的 SPI 启用引脚。必须提供这个参数。
#spi_speed: 5000000
#   用于和芯片通讯的SPI 速率（以赫兹(hz)为单位）。
#   默认值为5000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   上述参数详见“常见 SPI 设置”章节。
#axes_map: x,y,z
#   打印机 x 、 y 和 z 轴对应的加速度计轴。在加速度计的
#   安装方向和打印机的方向不同时很有用。例如，可
#   以设置为“y,x,z”来交换 x 和 y 轴。也可以在加速度计反装
#   时反转轴。（例如"x,z,-y"）。默认值为”x,y,z“。
#rate: 3200
#   ADXL345的输出数据率。ADXL345支持以下数据输出速率：
#   3200、1600、800、400、200、100、50和25。注意，不推
#   荐降低默认值的3200，低于800的速率会极大的影响共振
#   测量准确性。
```

### [resonance_tester]

Support for resonance testing and automatic input shaper calibration. In order to use most of the functionality of this module, additional software dependencies must be installed; refer to [Measuring Resonances](Measuring_Resonances.md) and the [command reference](G-Codes.md#resonance-testing-commands) for more information. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) section of the measuring resonances guide for more information on `max_smoothing` parameter and its use.

```
[resonance_tester]
#probe_points:
#   A list of X,Y,Z coordinates of points (one point per line) to test
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
#max_freq: 120
#   Maximum frequency to test for resonances. The default is 120 Hz.
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

## 配置文件助手

### [board_pins]

控制板引脚别名（可以定义任意数量的带有 "board_pins "前缀的分段）。用它来定义微控制器上的引脚的别名。

```
[board_pins my_aliases]。
mcu: mcu
#   一个可以使用别名的逗号分隔的微控制器列表。
#   默认将别名应用于主 "mcu"。
aliases:
aliases_<name>:
#   为给定的微控制器创建的一个以逗号分隔的 "name=value "
#   别名列表。例如，"EXP1_1=PE6" 将创建一个用于 "PE6 "引
#   脚的"EXP1_1 "别名。然而，如果 "值 " 被包括在 "<>"中，
#   则 "name "将被创建为一个保留针脚（例如，"EXP1_9=<GND>" 
#   将保留 "EXP1_9"）。可以指定任何数量以 "aliases_"开头的分段。
```

### [include]

Include file support. One may include additional config file from the main printer config file. Wildcards may also be used (eg, "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

This tool allows a single micro-controller pin to be defined multiple times in a config file without normal error checking. This is intended for diagnostic and debugging purposes. This section is not needed where Klipper supports using the same pin multiple times, and using this override may cause confusing and unexpected results.

```
[duplicate_pin_override]
pins:
#   A comma separated list of pins that may be used multiple times in
#   a config file without normal error checks. This parameter must be
#   provided.
```

## 打印床探测硬件

### [probe]

Z height probe. One may define this section to enable Z height probing hardware. When this section is enabled, PROBE and QUERY_PROBE extended [g-code commands](G-Codes.md#probe) become available. Also, see the [probe calibrate guide](Probe_Calibrate.md). The probe section also creates a virtual "probe:z_virtual_endstop" pin. One may set the stepper_z endstop_pin to this virtual pin on cartesian style printers that use the probe in place of a z endstop. If using "probe:z_virtual_endstop" then do not define a position_endstop in the stepper_z config section.

```
[probe]
pin:
#   Probe detection pin. This parameter must be provided.
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

BLTouch 探针。可以定义这个分段（而不是探针（probe）分段）来启用 BLTouch 探针。更多信息见[BL-Touch 指南](BLTouch.md)和[命令参考](G-Code.md#bltouch)。一个虚拟的 "probe:z_virtual_endstop "引脚也会被同时创建（详见 "probe "章节）。

```
[bltouch]
sensor_pin:
#   连接到 BLTouch sensor 引脚的引脚。大多数 BLTouch 需要在
#   sensor 引脚上有一个拉高电阻（在引脚名前加上“^”）。
#   必须提供这个参数。
control_pin:
#   连接到 BLTouch control 引脚的引脚。 
#   必须提供这个参数。
#pin_move_time: 0.680
#   等待 BLTouch探针收放的时间（以秒为单位）。
#   默认为 0.680 秒。
#stow_on_each_sample: True
#   这个参数决定了 Klipper 是否会在进行多次探测的每次探测之间
#   收放探针。在禁用这个动作前请先阅读 docs/BLTouch.md。
#   默认为True（启用）。
#probe_with_touch_mode: False
#   当该选项被启用，Klipper 会以“touch_mode”（触摸模式）使用
#   探针。
#   默认为False （禁用，使用“pin_down”模式探测）。
#pin_up_reports_not_triggered: True
#   只在 BLTouch 在 "pin_up" 命令后稳定汇报探针在一个“not triggered（未
#   触发）”的状态时需要设置。所有正版的 BLTouch 都应该设为 True（启
#   用）。 在设为False（禁用）前，请先阅读 docs/BLTouch.md 中的说明。
#   默认是True（启用）。
#pin_up_touch_mode_reports_triggered: True
#   只在 BLTouch 在 "pin_up" 和 “touch_mode" 命令后稳定汇报探针在一个“not
#    triggered（未触发）”的状态时需要设置。所有正版的 BLTouch 都应该设为 
#   True（启用）。 在设为False（禁用）前，请先阅读 docs/BLTouch.md 中的说明。
#   默认是True（启用）。
#set_output_mode:
#   向BLTouch V3.0 （和更新版本）请求一个特定的 sensor 引脚输出模式 。
#   这个设置不应该在其他类型的探针上使用。设为“5v”会请求 sensor 引脚
#   以5V输出（仅在控制板需要使用5V模式并且这个信号输入引脚可以耐受5V
#   时）。设为“OD”来请求 sensor 引脚输出使用开漏模式。
#   默认不请求输出模式。
#x_offset:
#y_offset:
#z_offset:
#speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   这些参数详见”探针“章节。
```

## 额外的步进电机和挤出机

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

In a multi-extruder printer add an additional extruder section for each additional extruder. The additional extruder sections should be named "extruder1", "extruder2", "extruder3", and so on. See the "extruder" section for a description of available parameters.

See [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg) for an example configuration.

```
[extruder1]
#step_pin:
#dir_pin:
#...
#   See the "extruder" section for available stepper and heater
#   parameters.
#shared_heater:
#   If this extruder uses the same heater already defined for another
#   extruder then place the name of that extruder here. For example,
#   should extruder3 and extruder4 share a heater then the extruder3
#   config section should define the heater and the extruder4 section
#   should specify "shared_heater: extruder3". The default is to not
#   reuse an existing heater.
```

### [dual_carriage]

Support for cartesian printers with dual carriages on a single axis. The active carriage is set via the SET_DUAL_CARRIAGE extended g-code command. The "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation.

See [sample-idex.cfg](../config/sample-idex.cfg) for an example configuration.

```
[dual_carriage]
axis:
#   The axis this extra carriage is on (either x or y). This parameter
#   must be provided.
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

Support for additional steppers synchronized to the movement of an extruder (one may define any number of sections with an "extruder_stepper" prefix).

See the [command reference](G-Codes.md#extruder-stepper-commands) for more information.

```
[extruder_stepper my_extra_stepper]
#extruder: extruder
#   The extruder this stepper is synchronized to. The default is
#   "extruder".
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   See the "stepper" section for the definition of the above
#   parameters.
```

### [manual_stepper]

Manual steppers (one may define any number of sections with a "manual_stepper" prefix). These are steppers that are controlled by the MANUAL_STEPPER g-code command. For example: "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". See [G-Codes](G-Codes.md#manual-stepper-commands) file for a description of the MANUAL_STEPPER command. The steppers are not connected to the normal printer kinematics.

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

## 自定义加热器和传感器

### [verify_heater]

Heater and temperature sensor verification. Heater verification is automatically enabled for each heater that is configured on the printer. Use verify_heater sections to change the default settings.

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

自定义热敏电阻（可以定义任意数量的带有“热敏电阻”前缀的分段）。可以在加热器配置分段的 sensor_type 字段中使用自定义热敏电阻。 （例如，如果定义了“[thermistor my_thermistor]”分段，那么在定义加热器时可以使用“sensor_type: my_thermistor”。）确保将热敏电阻分段放在配置文件中第一次使用这个传感器的加热器分段的上方。

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

自定义 ADC 温度传感器（可以使用 “adc_temperature” 前缀定义任意数量的分段）。这允许定义一个自定义温度传感器，该传感器测量一个模数转换器 (ADC) 引脚上的电压，并在一组配置的温度/电压（或温度/电阻）测量值之间使用线性插值来确定温度。设置的传感器可被用作加热器分段中的 sensor_type。 （例如，如果定义了 “[adc_temperature my_sensor]” 分段，则在定义加热器时可以使用 “sensor_type: my_sensor” 。）确保将传感器分段放在配置文件中第一次使用这个传感器的加热器分段的上方。

```
[adc_temperature my_sensor]
#temperature1:
#voltage1:
#temperature2:
#voltage2:
#...
#   一组用作温度转换的参考温度（以摄氏度为单位）和电压（以
#   伏特为单位）。使用这个传感器的加热器分段也可以指定
#   adc_voltage 和 voltage_offset 参数来定义 ADC 电压（详见“常用温度
#   放大器”章节）。至少要提供两个测量点。
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#...
#   作为替代，也可以指定一组用作温度转换的参考温度（以摄氏度为
#   单位）和阻值（以欧姆为单位）。使用这个传感器的加热器分段也
#   可以指定一个 pullup_resistor 参数（详见“挤出机”章节）。至少要
#   提供两个测量点。
```

### [heater_generic]

Generic heaters (one may define any number of sections with a "heater_generic" prefix). These heaters behave similarly to standard heaters (extruders, heated beds). Use the SET_HEATER_TEMPERATURE command (see [G-Codes](G-Codes.md) for details) to set the target temperature.

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

Generic temperature sensors. One can define any number of additional temperature sensors that are reported via the M105 command.

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

Klipper includes definitions for many types of temperature sensors. These sensors may be used in any config section that requires a temperature sensor (such as an `[extruder]` or `[heated_bed]` section).

### 常见热敏电阻

常见的热敏电阻。在使用这些传感器之一的加热器分段中可以使用以下参数。

```
sensor_type:
#   One of "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
#   "NTC 100K beta 3950", "Honeywell 100K 135-104LAG-J01",
#   "NTC 100K MGB18-104F39050L32", "SliceEngineering 450", or
#   "TDK NTCG104LH104JT1"
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

### 常见温度放大器

常见温度放大器。在使用这些传感器之一的加热器分段中可以使用以下参数。

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

### 直接连接的 PT1000 传感器

直接连接到控制板的 PT1000 传感器。以下参数可用于使用这些传感器之一的加热器分段。

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

### BMP280/BME280/BME680 温度传感器

BMP280/BME280/BME680双线接口（I2C）环境传感器。请注意，这些传感器不被设计用于挤出机和热床，而是用于监测环境温度（C）、压力（hPa）和相对湿度，如果是BME680，还可以测量空气质量。参见[sample-macros.cfg](./config/sample-macros.cfg)中的 gcode_macro，它可以用来报告温度、压力和湿度。

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

### HTU21D sensor

HTU21D family two wire interface (I2C) environmental sensor. Note that this sensor is not intended for use with extruders and heater beds, but rather for monitoring ambient temperature (C) and relative humidity. See [sample-macros.cfg](../config/sample-macros.cfg) for a gcode_macro that may be used to report humidity in addition to temperature.

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

### LM75 temperature sensor

LM75/LM75A two wire (I2C) connected temperature sensors. These sensors have range up to 125 C, so are usable for e.g. chamber temperature monitoring. They can also function as simple fan/heater controllers.

```
sensor_type: lm75
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

### 微控制器的内置温度传感器

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

### Host temperature sensor

Temperature from the machine (eg Raspberry Pi) running the host software.

```
sensor_type: temperature_host
#sensor_path:
#   The path to temperature system file. The default is
#   "/sys/class/thermal/thermal_zone0/temp" which is the temperature
#   system file on a Raspberry Pi computer.
```

### DS18B20 温度传感器

DS18B20 is a 1-wire (w1) digital temperature sensor. Note that this sensor is not intended for use with extruders and heater beds, but rather for monitoring ambient temperature (C). These sensors have range up to 125 C, so are usable for e.g. chamber temperature monitoring. They can also function as simple fan/heater controllers. DS18B20 sensors are only supported on the "host mcu", e.g. the Raspberry Pi. The w1-gpio Linux kernel module must be installed.

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

## 风扇

### [fan]

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
```

### [heater_fan]

Heater cooling fans (one may define any number of sections with a "heater_fan" prefix). A "heater fan" is a fan that will be enabled whenever its associated heater is active. By default, a heater_fan has a shutdown_speed equal to max_power.

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

控制器冷却风扇（可以定义任意数量带有"controller_fan"前缀的分段）。"控制器风扇"(Controller fan)是一个只要关联的加热器或步进驱动程序处于活动状态就会启动的风扇。风扇会在空闲超时(idle_timeout)后停止，以确保被监视组件不再活跃后不会过热。

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
#  以上参数请见“风扇”(fan)分段。
#fan_speed: 1.0
#   当一个加热器或步进电机活跃时的风扇速度（以一个0.0到1.0
#   的数值表示）。
#   默认为 1.0。
#idle_timeout:
#   在步进电机或加热器不再活跃后风扇持续运行的时间（以秒
#   为单位）。
#   默认为 30秒。
#idle_speed:
#   当一个加热器或步进电机不再活跃，但没有达到空闲超时(
#   idle_timeout)时的风扇速度（以一个0.0到1.0的数值表示）。
#   默认为 fan_speed。
#heater:
#stepper:
#   与这个风扇关联的加热器/步进驱动配置分段名称。如果提
#   供一个逗号分隔的加热器/步进驱动名称，任意一个列表中
#   的设备启用时风扇将会启动。
#   默认加热器是“挤出机”（extruder)，默认步进驱动是全部步进驱动。
```

### [temperature_fan]

Temperature-triggered cooling fans (one may define any number of sections with a "temperature_fan" prefix). A "temperature fan" is a fan that will be enabled whenever its associated sensor is above a set temperature. By default, a temperature_fan has a shutdown_speed equal to max_power.

See the [command reference](G-Codes.md#temperature-fan-commands) for additional information.

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
#   See the "fan" section for a description of the above parameters.
#sensor_type:
#sensor_pin:
#control:
#pid_Kp:
#pid_Ki:
#pid_Kd:
#pid_deriv_time:
#max_delta:
#min_temp:
#max_temp:
#   See the "extruder" section for a description of the above parameters.
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

Manually controlled fan (one may define any number of sections with a "fan_generic" prefix). The speed of a manually controlled fan is set with the SET_FAN_SPEED [gcode command](G-Codes.md#manually-controlled-fans-commands).

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
#   以上参数介绍请见“fan”（风扇）章节。
```

## 额外的舵机，LED，按键，和其他引脚。

### [servo]

Servos (one may define any number of sections with a "servo" prefix). The servos may be controlled using the SET_SERVO [g-code command](G-Codes.md#servo-commands). For example: SET_SERVO SERVO=my_servo ANGLE=180

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

### [neopixel]

Neopixel (aka WS2812) LED support (one may define any number of sections with a "neopixel" prefix). One may set the LED color via "SET_LED LED=my_neopixel RED=0.1 GREEN=0.1 BLUE=0.1" type extended [g-code commands](G-Codes.md#neopixel-and-dotstar-commands).

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
#   Set the pixel order required by the LED hardware. Options are GRB,
#   RGB, GRBW, or RGBW. The default is GRB.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Sets the initial LED color of the Neopixel. Each value should be
#   between 0.0 and 1.0. The WHITE option is only available on RGBW
#   LEDs. The default for each color is 0.
```

### [dotstar]

支持Dotstar（又称APA102）LED（可以定义任何数量的带有 "dotstar "前缀的分段）。通过 "SET_LED LED=my_dotstar RED=0.1 GREEN=0.1 BLUE=0.1 "类型的扩展[G代码命令]（G-Code.md#neopixel-and-dotstar-commands）可以设置LED颜色。

```
[dotstar my_dotstar]
data_pin:
#   连接到dotstar data（数据）线的引脚。必须提供这个参数。
clock_pin:
# 连接到dotstar clock（时钟）线的引脚。必须提供这个参数。
#chain_count:
#initial_RED:0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#   有关这些参数的信息，请参见 "Neopixel " 章节。
```

### [PCA9533]

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
#initial_RED: 0
#initial_GREEN: 0
#initial_BLUE: 0
#initial_WHITE: 0
#   The PCA9533 only supports 1 or 0. The default is 0. On the
#   mightyboard, the white led is not populated.
#   Use GCODE to modify led values after startup.
#   set_led led=my_pca9533 red=1 green=1 blue=1
```

### [gcode_button]

Execute gcode when a button is pressed or released (or when a pin changes state). You can check the state of the button by using `QUERY_BUTTON button=my_gcode_button`.

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
```

### [output_pin]

Run-time configurable output pins (one may define any number of sections with an "output_pin" prefix). Pins configured here will be setup as output pins and one may modify them at run-time using "SET_PIN PIN=my_pin VALUE=.1" type extended [g-code commands](G-Codes.md#custom-pin-commands).

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

配置在 UART/SPI 模式下的 Trinamic 步进电机驱动器。其他信息在[TMC驱动指南](TMC_Drivers.md)和[命令参考](G-Code.md#tmc-stepper-drivers)中。

### [tmc2130]

通过 SPI 总线配置 TMC2130 步进电机驱动。要使用此功能，请定义一个带有“tmc2130”前缀并后跟步进驱动配置分段相应名称的配置分段（例如，“[tmc2130 stepper_x]”）。

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
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. The default is to use the same
#   value as run_current.
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

通过单线 UART 配置 TMC2208（或 TMC2224）步进电机驱动。要使用此功能，请定义一个带有 “tmc2208” 前缀并后跟步进驱动配置分段相应名称的配置分段（例如，“[tmc2208 stepper_x]”）。

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
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. The default is to use the same
#   value as run_current.
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

通过单线 UART 配置 TMC2209 步进电机驱动。要使用此功能，请定义一个带有 “tmc2209” 前缀并后跟步进驱动配置分段相应名称的配置分段（例如，“[tmc2209 stepper_x]”）。

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

通过 SPI 总线配置 TMC2660 步进电机驱动。要使用此功能，请定义一个带有 “tmc 2660” 前缀并后跟步进驱动配置分段相应名称的配置分段（例如，“[tmc2660 stepper_x]”）。

```
[tmc2660 stepper_x]
cs_pin:
#   对应 TMC2660 芯片选择线路的引脚。这个引脚将在 SPI 
#   信息开始传输时拉低，并在消息传输完成后拉高。
#   必须提供此参数。
#spi_speed: 4000000
#   SPI 总线与 TMC2660 步进驱动的通信速率。
#   默认为 4000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   以上参数详见“常见 SPI 设置”章节。
#interpolate: True
#   如设置为 True ，则启用步进细分（驱动将会在内部以256
#   微步的频率步进）。这只在微步设置为 16 时有效。
#   默认为 True 。
run_current:
#   驱动在步进电机运动时使用的电流（以安培 RMS 为单位）。
#   必须提供这个参数。
#sense_resistor:
#   电机检测电阻的阻值（以 ohms 为单位）。
#   必须提供这个参数。
#idle_current_percent: 100
#   当空闲超时到期时步进电机将降低到的 run_current 百分比（
#   你必须使用一个 [idle_timeout] 配置分段来设置一个空闲超时）。
#   在步进电机开始运行时电流将会重新提高。确保它被设为一个足
#   够高的数值以保证步进电机不会发生位移。电流重新提高有一个
#   微小的延迟，请在对一个空闲状态步进电机发送快速移动指令前
#   考虑这项延迟。
#   默认为 100 （不减少）。
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
#   在配置 TMC2660 芯片时给定的参数。可以用来设置自定义参数。
#   在列表中参数的默认值是芯片的默认值。查看 TMC2660数据手册
#   以了解这些参数的作用以及它们互相组合的限制。尤其注意 
#   CHOPCONF 寄存器，因为设置 CHM 为 0 或 1 将会造成布局变化（
#   HDEC的第一个比特会在此时被视为 HSTRT 的 MSB）。
```

### [tmc5160]

通过 SPI 总线配置 TMC5160 步进电机驱动。要使用此功能，请定义一个带有 “tmc5160” 前缀并后跟步进驱动配置分段相应名称的配置分段（例如，“[tmc5160 stepper_x]”）。

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
#   when the stepper is not moving. The default is to use the same
#   value as run_current.
#sense_resistor: 0.075
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.075 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode. Try to reexperience this with tmc5160.
#   Values can be much higher than other tmcs.
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
#   对应AD5206 芯片选择(chip select)线路的引脚。这个引脚将
#   在 SPI 消息开始时拉低，并在消息结束后拉高。必须提供
#   这个参数。
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   以上参数的定义请查看 "常规 SPI 设置" 章节
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
#   设置AD5206通道的静态值。通常在0.0和1.0之间，1.0为最高
#   电阻，而0.0为最低电阻。然而，这个范围也可以被 ‘scale’ 参
#   数配置。（见下文）如果一个通道没有参数则它不会被配置。
#scale:
#   这个参数可以用来修改 ‘channel_x’ 参数的定义。如被提供，
#   则 ‘channel_x’ 的范围会在 0.0 和 ‘scale’ 之间。在 AD5206 被作
#   为步进电机参考电压时可能很有帮助。当AD5206在最高电阻时
#   ‘scale’ 可以被设置为步进电机的电流， 然后 ‘channel_x’ 参数可
#   以设置为步进电机的期望电流安培。默认为不对 'channel_x' 参
#   数进行缩放。
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

## 显示器支持

### [display]

Support for a display attached to the micro-controller.

```
[display]
lcd_type:
#   The type of LCD chip in use. This may be "hd44780", "hd44780_spi",
#   "st7920", "emulated_st7920", "uc1701", "ssd1306", or "sh1106".
#   See the display sections below for information on each type and
#   additional parameters they provide. This parameter must be
#   provided.
#display_group:
#   The name of the display_data group to show on the display. This
#   controls the content of the screen (see the "display_data" section
#   for more information). The default is _default_20x4 for hd44780
#   displays and _default_16x4 for other displays.
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

### hd44780 display

Information on configuring hd44780 displays (which is used in "RepRapDiscount 2004 Smart Controller" type displays).

```
[display]
lcd_type: hd44780
#   对于hd44780显示屏，填写 "hd44780"。
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#   连接到hd44780 类LCD的引脚。
#   必须提供这些参数
#hd44780_protocol_init: True
#   在一个 hd44780 显示器上执行 8-bit/4-bit 协议初始化。对于所有
#   正版的 hd44780 设备，这是必须的。但是，在一些克隆的设备上
#   可能需要禁用。
#   默认为True（启用）。
#line_length:
#   设置 hd44780 类LCD 每行显示的字符数。可能的数值有20（默认）
#   和16。行数被锁定为4行。
...
```

### hd44780_spi display

Information on configuring an hd44780_spi display - a 20x04 display controlled via a hardware "shift register" (which is used in mightyboard based printers).

```
[display]
lcd_type: hd44780_spi
#   对于hd44780_spi 显示器，设置为“hd44780_spi”。
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   控制显示器的移位寄存器的引脚。由于位移寄存器没有 MISO 引
#   脚，但是软件 SPI 实现需要这个引脚被配置，
#   spi_software_miso_pin 需要被设置为一个打印机主板上未被使
#   用的引脚。
#hd44780_protocol_init: True
#   在 hd44780 显示器上执行 8-bit/4-bit 协议初始化。正版的
#   hd44780 设备必须执行此操作，但是某些克隆设备上可能需要
#   禁用。
#   默认为True（启用）。
#line_length:
#   设置一个 hd44780 类 LCD 每行显示的字符数量。可能的值为20
#   （默认）和 16。行数固定为4。
...
```

### st7920 display

Information on configuring st7920 displays (which is used in "RepRapDiscount 12864 Full Graphic Smart Controller" type displays).

```
[display]
lcd_type: st7920
#   为st7920显示器设置为 "st7920"。
cs_pin:
sclk_pin:
sid_pin:
#   连接到 st7920 类LCD的引脚。
#   这些参数必须被提供。
...
```

### emulated_st7920（模拟ST7920）显示屏

Information on configuring an emulated st7920 display - found in some "2.4 inch touchscreen devices" and similar.

```
[display]
lcd_type: emulated_st7920
#   对于 emulated_st7920 显示屏，设置为"emulated_st7920"。
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   连接到 emulated_st7920 类LCD的引脚。 en_pin 对应
#   st7920 类LCD的 cs_pin。spi_software_sclk_pin 对应 sclk_pin，
#   还有 spi_software_mosi_pin 对应 sid_pin。由于软件SPI实现
#   的方式，虽然 ST7920 不使用 MISO 引脚， 依旧需要将
#   spi_software_miso_pin设为一个打印机控制板上一个没有被
#   使用的引脚。
...
```

### uc1701 display

Information on configuring uc1701 displays (which is used in "MKS Mini 12864" type displays).

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

### ssd1306 and sh1106 displays

Information on configuring ssd1306 and sh1106 displays.

```
[display]
lcd_type:
#   Set to either "ssd1306" or "sh1106" for the given display type.
#i2c_mcu:
#i2c_bus:
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

## [display_data]

Support for displaying custom data on an lcd screen. One may create any number of display groups and any number of data items under those groups. The display will show all the data items for a given group if the display_group option in the [display] section is set to the given group name.

一套[默认显示组](../klippy/extras/display/display.cfg)将被自动创建。通过覆盖打印机的 printer.cfg 主配置文件中的默认值可以替换或扩展这些 display_data 项。

```
[display_data my_group_name my_data_name]
position:
#   用于显示信息的屏幕位置，由逗号分隔行与列表示。
#   这个参数必须被提供。
text:
#   在指定位置显示的文本。本字段必须用命令样板进行评估。
#   （查看 docs/Command_Templates.md）。
#   这个参数必须被提供。
```

## [display_template]

显示数据文本“宏”（可以使用 display_template 前缀定义任意数量的部分）。此功能可以帮助减少 display_data 部分中重复的定义。可以使用 display_data 部分中的内置 render() 函数来预览模板。例如，如果要定义 `[display_template my_template]` 则可以在 display_data 部分使用 `{ render('my_template') }` 。

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
#text:
#   The text to return when the render() function is called for this
#   template. This field is evaluated using command templates (see
#   docs/Command_Templates.md). This parameter must be provided.
```

## [display_glyph]

在支持自定义字形的显示器上显示一个自定义字形。给定的名称将被分配给给定的显示数据，然后可以在显示模板中通过用“波浪形（～）”符号包围的名称来引用，即 `~my_display_glyph~` 。

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

## [display my_extra_display]

If a primary [display] section has been defined in printer.cfg as shown above it is possible to define multiple auxiliary displays. Note that auxiliary displays do not currently support menu functionality, thus they do not support the "menu" options or button configuration.

```
[display my_extra_display] 。
#   可用参数参见 "显示 "分段。
```

## [menu]

可自定义液晶显示屏菜单。

一套[默认菜单](../klippy/extras/display/menu.cfg)将被自动创建。通过覆盖 printer.cfg 主配置文件中的默认值可以替换或扩展该菜单。

See the [command template document](Command_Templates.md#menu-templates) for information on menu attributes available during template rendering.

```
# 所有的菜单配置分段都有的通用参数。
#[menu __some_list __some_name]
#type: disabled
#   永久禁用这个菜单元素，唯一需要的属性是 "类型"。
#   允许你简单啊的禁用/隐藏现有的菜单项目。
#[menu some_name]
#type:
#   command（命令）, input（输入）, list（列表）, text（文字）之一：
#       command - 可以触发各种脚本的基本菜单元素。
#       input   - 类似 “command” 但是可以修改数值。
#                 点击来进入/退出修改模式。
#       list    - 这允许菜单项被组织成一个可滚动的列表。通过创建由 "some_list"
#                 开头的菜单配置 - 例如：[menu some_list some_item_in_the_list]
#       vsdlist - 和“list”一样，但是会自动从虚拟SD卡中添加文件。
#                 （将在未来被移除）
#name:
#   菜单项的名称 - 被视为模板
#enable:
#   视为 True 或 False 的模板。
#index:
#   项目插入到列表的位置。
#   默认添加到结尾。

#[menu some_list]
#type: list
#name:
#enable:
#   见上文对这些参数的描述。

#[menu some_list some_command]
#type: command
#name:
#enable:
#   见上文对这些参数的描述。
#gcode:
#   点击按钮或长按时运行的G代码脚本。被视为模板。
#[menu some_list some_input]
#type: input
#name:
#enable:
#   见上文对这些参数的描述。
#input:
#   用于修改的初始数值 - 被视为模板。
#   结果必须为浮点数。
#input_min:
#   范围的最小值 - 被视为模板。默认-99999。
#input_max:
#   范围的最大值 - 被视为模板。 默认-99999。
#input_step:
#   修改的步长 - 必须是一个正整数或浮点数。它有内置快进
#   步长。当"(input_max - input_min) /
#   input_step > 100" 时，快进步长是 10 * input_step， 否则
#   步长和 input_step 相同。
#realtime:
#   此属性接受静态布尔值。 在启用时，G代码脚本将会在每
#   次数值变化时执行。
#   默认为False（否）。
#gcode:
#   点击按钮、长按或数值变化时运行的G代码脚本。
#   被视为模板。点击按钮会进入或退出修改模式。
```

## Filament sensors

### [filament_switch_sensor]

Filament Switch Sensor. Support for filament insert and runout detection using a switch sensor, such as an endstop switch.

See the [command reference](G-Codes.md#filament-sensor) for more information.

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
#switch_pin:
#   The pin on which the switch is connected. This parameter must be
#   provided.
```

### [filament_motion_sensor]

Filament Motion Sensor. Support for filament insert and runout detection using an encoder that toggles the output pin during filament movement through the sensor.

See the [command reference](G-Codes.md#filament-sensor) for more information.

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#   The minimum length of filament pulled through the sensor to trigger
#   a state change on the switch_pin
#   Default is 7 mm.
extruder:
#   The name of the extruder section this sensor is associated with.
#   This parameter must be provided.
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

Hall filament width sensor (see [Hall Filament Width Sensor](HallFilamentWidthSensor.md)).

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
#   The raw calibration values for the sensors. The default is 9500
#   for raw_dia1 and 10500 for raw_dia2.
#default_nominal_filament_diameter: 1.75
#   The nominal filament diameter. This parameter must be provided.
#max_difference: 0.200
#   Maximum allowed filament diameter difference in millimeters (mm).
#   If difference between nominal filament diameter and sensor output
#   is more than +- max_difference, extrusion multiplier is set back
#   to %100. The default is 0.200.
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
#measurement_interval: 10
#   The approximate distance (in mm) between sensor readings. The
#   default is 10mm.
#logging: False
#   Out diameter to terminal and klipper.log can be turn on|of by
#   command.
#min_diameter: 1.0
#   Minimal diameter for trigger virtual filament_switch_sensor.
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

## 控制板特定硬件支持

### [sx1509]

将一个 SX1509 I2C 配置为 GPIO 扩展器。由于 I2C 通信本身的延迟，不应将 SX1509 引脚用作步进电机的 enable （启用)、step（步进）或 dir （方向）引脚或任何其他需要快速 bit-banging（位拆裂）的引脚。它们最适合用作静态或G代码控制的数字输出或硬件 pwm 引脚，例如风扇。可以使用“sx1509”前缀定义任意数量的分段。每个扩展器提供可用于打印机配置的一组 16 个引脚（sx1509_my_sx1509:PIN_0 到 sx1509_my_sx1509:PIN_15）。

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

Duet2 Maestro analog scaling by vref and vssa readings. Defining an adc_scaled section enables virtual adc pins (such as "my_name:PB0") that are automatically adjusted by the board's vref and vssa monitoring pins. Be sure to define this config section above any config sections that use one these virtual pins.

See the [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg) file for an example.

```
[adc_scaled my_name]
vref_pin:
#   用于监测 VREF 的 ADC 引脚。这个参数必须被提供。
vssa_pin:
#   用于监测 VSSA 的 ADC 引脚。这个参数必须被提供。
#smooth_time: 2.0
#   一个时间参数（以秒为计）区间用于平滑 VREF 和
#   VSSA 测量来减少测量的干扰。默认为2秒。
```

### [replicape]

Replicape support - see the [beaglebone guide](beaglebone.md) and the [generic-replicape.cfg](../config/generic-replicape.cfg) file for an example.

```
# The "replicape" config section adds "replicape:stepper_x_enable"
# virtual stepper enable pins (for steppers x, y, z, e, and h) and
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

If you use this module, do not use the Palette 2 plugin for Octoprint as they will conflict, and 1 will fail to initialize properly likely aborting your print.

If you use Octoprint and stream gcode over the serial port instead of printing from virtual_sd, then remo **M1** and **M0** from *Pausing commands* in *Settings > Serial Connection > Firmware & protocol* will prevent the need to start print on the Palette 2 and unpausing in Octoprint for your print to begin.

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

## 通用总线参数

### 常见 SPI 设置

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

### 通用 I2C 设置

The following parameters are generally available for devices using an I2C bus.

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
#i2c_speed:
#   The I2C speed (in Hz) to use when communicating with the device.
#   On some micro-controllers changing this value has no effect. The
#   default is 100000.
```
