# 配置参考

本文档是 Klipper 配置文件中可用配置分段的参考。

本文档中的描述已经格式化，以便可以将它们剪切并粘贴到打印机配置文件中。 见 [安装文档](Installation.md) 有关设置 Klipper 和选择初始配置文件的信息。

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
#   连接到单片机的串行通讯接口
#   如果你不确定的话（或可能它变更拉了），可以查看FAQ中的
#   “Where's my serial port?”章节。
#   当使用串口时，这个参数必须给定
#baud: 250000
#   使用的波特率。默认是250000
#canbus_uuid:
#   如果使用一个连接到CAN总线的设备，这个参数需要被设置为
#   要连接的芯片的唯一ID。
#   当使用CAN总线时，这个参数必须给定
#canbus_interface:
#   当使用的设备连接到CAN总线时，这个参数需要被设置为
#   使用的网络接口
#   默认值是can0
#restart_method:
#   这个参数控制着重置单片机的方式
#   可选项是'arduino'、'cheetah'、'rpi_usb'和'command'
#   'arduino'方法（翻转DTR）通常适用于Arduino板或其克隆板
#   'cheetah'方法是一个特殊的方法，通常适用于一些富源盛的Cheetah板
#   'rpi_usb'方法对于使用树莓派的USB供电的单片机十分有效
#   它简单地关闭所有USB端口的电源来完成单片机的重置
#   'command'方法调用向单片机发送klipper命令来重置它们自己
#   当单片机连接到串口时默认是'arduino'，否则默认是'command'
```

### [mcu my_extra_mcu]

额外的微控制器（可以定义任意数量的带有“mcu”前缀的部分）。 额外的微控制器引入了额外的引脚，这些引脚可以配置为加热器、步进器、风扇等。例如，如果引入了“[mcu extra_mcu]”部分，那么诸如“extra_mcu:ar9”之类的引脚就可以在其他地方使用 ，在配置中（其中“ar9”是给定 mcu 上的硬件引脚名称或别名）。

```
[mcu my_extra_mcu]
#   请参阅"mcu"分段的配置参数。
```

## 常见的运动学设置

### [printer]

打印机控制的高级设置部分。

```
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid_corexy, hybrid_corexz, rotary_delta, delta,
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

### 笛卡尔运动学

cartesian 运动学配置文件参考[example-cartesian.cfg](../config/example-cartesian.cfg)

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

linear delta运动学配置文件参考[example-delta.cfg](../config/example-delta.cfg)。 关于校准方法 [三角洲校准指南](Delta_Calibrate.md)。

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

### CoreXY 运动学

corexy或者h-bot运动学配置文件参考[example-corexy.cfg](./config/example-corexy.cfg)

这里只描述了 CoreXY 打印机特有的参数 -- 有关可用参数，请参阅 [常见运动学设置](#common-kinematic-settings)。

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

corexz 运动学配置文件参考[example-corexz.cfg](../config/example-corexz.cfg)

此处描述的参数只适用于笛卡尔打印机—有关全部可用参数，请参阅 [常用的运动学设置](#common-kinematic-settings)。

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

### Hybrid-CoreXY (混合型 CoreXY) 运动学

hybrid corexy运动学配置文件参考[example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg)

This kinematic is also known as Markforged kinematic.

此处仅描述了线性三角洲打印机的特定参数—有关全部可用参数，请参阅 [常用的运动学设置](#common-kinematic-settings)。

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

### Hybrid-CoreXZ (混合型 CoreXZ) 运动学

hybrid corexz 运动学配置文件参考 [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg)

This kinematic is also known as Markforged kinematic.

此处仅描述了线性三角洲打印机的特定参数—有关全部可用参数，请参阅 [常用的运动学设置](#common-kinematic-settings)。

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

### 极坐标运动学

polar运动学配置文件参考 [example-polar.cfg](../config/example-polar.cfg)

这里只描述了极地打印机特有的参数—全部可用的参数请见[常用的运动学设置](#common-kinematic-settings)。

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

### Rotary delta 运动学

Rotary Delta运动学配置文件参考[example-rotary-delta.cfg](../config/example-rotary-delta.cfg)

此处仅介绍特定于旋转三角洲打印机的参数—有关可用参数，请参阅[常用的运动学设置](#common-kinematic-settings)。

ROTARY DELTA运动学正在进行的修复工作。归位动作可能会超时并且一些边界检查也没有实现。

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

这里只描述了缆绳铰盘式(cable winch)打印机特有的参数 — 全部可用的参数见[常用的运动学设置](#common-kinematic-settings)。

缆绳铰盘支持是实验性的。归位在缆绳绞盘运动学中没有实现。在打印机归位时需要手动发送运动指令将工具头处于0, 0, 0位置，然后发出`G28`归位。

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

### 无运动学

可以定义特殊的 "none" 运动学来禁用 Klipper 中的运动学支持。可以用于控制不是 3D 打印机的设备或调试。

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   The max_velocity and max_accel parameters must be defined. The
#   values are not used for "none" kinematics.
```

## 常见的挤出机和热床支持

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
#   以上参数详见“stepper”配置分段。
#   如果未指定任意上述参数，则没有步进电机与热端相关联
#   （尽管使用SYNC_EXTRUDER_MOTION命令可能可以在运行时关联一个热端）
nozzle_diameter:
#   喷嘴的孔径（以毫米为单位）
#   必须提供这个参数。
filament_diameter:
#   进入挤出机的耗材上标的直径（以毫米为单位）
#   必须提供这个参数。
#max_extrude_cross_section:
#   挤出线条横截面的最大面积（以平方毫米为单位）
#   （例如：挤出线宽乘层高）
#   这个设置能防止在相对较小的XY移动时产生过度的挤出
#   如果一个挤出速率请求超过了这个值，这会导致返回一个错误
#   默认值是：4.0 * 喷嘴直径 ^ 2
#instantaneous_corner_velocity: 1.000
#   两次挤出之间最大的速度变化（以毫米每秒为单位）
#   默认值是：1mm/s
#max_extrude_only_distance: 50.0
#   一次挤出或回抽的最大长度（以毫米耗材的长度为单位）
#   如果一次挤出或回抽超过了这个值，这会导致返回一个错误
#   默认值是：50mm
#max_extrude_only_velocity:
#max_extrude_only_accel:
#   最大的挤出和回抽速度（以毫米每秒为单位）
#   和加速度（以毫米每二次方秒为单位）
#   这些设置对正常打印的移动没有任何影响
#   如果未指定，则会计算来匹配 XY打印速度和挤出线横截面为4.0 * 喷嘴直径 ^ 2的限制
#pressure_advance: 0.0
#   挤出机加速过程中耗材被挤入的数量
#   同等数量的耗材会在减速过程中收回
#   这个值以毫米每毫米每秒测量
#   关闭压力提前时默认值是0
#pressure_advance_smooth_time: 0.040
#   A time range (in seconds) to use when calculating the average
#   extruder velocity for pressure advance. A larger value results in
#   smoother extruder movements. This parameter may not exceed 200ms.
#   This setting only applies if pressure_advance is non-zero. The
#   default is 0.040 (40 milliseconds).
#
#  The remaining variables describe the extruder heater.
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

The heater_bed section describes a heated bed. It uses the same heater settings described in the "extruder" section.

```
[heater_bed]
heater_pin:
sensor_type:
sensor_pin:
control:
min_temp:
max_temp:
#   以上参数详见“extruder”配置分段。
```

## 打印床调平支持

### [bed_mesh]

网床调平。定义一个 bed_mesh 配置分段来启用基于探测点生成网格的 Z 轴偏移移动变换。当使用探针归位 Z 轴时，建议通过 printer.cfg 中定义一个 safe_z_home 分段使 Z 轴归位在打印区域的中心执行。

See the [bed mesh guide](Bed_Mesh.md) and [command reference](G-Codes.md#bed_mesh) for additional information.

可视化示例：

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
# 校准期间非探测移动的速度(mm/s)
# 默认是 50.
#horizontal_move_z: 5
# 在探测中喷头的高度单位是mm
# 默认值是5
#mesh_radius:
# 定义探测圆形热床的网格半径
# 半径是相对于mesh_origin指定的坐标
# 此选项只适用于圆形热床
#mesh_origin:
# 定义圆形热床的中心X Y坐标 
# 此坐标相对于探头的位置
# 调整 mesh_origin可能会对最大化mesh_radius有帮助
# 默认值是0,0
# 此选项只适用于圆形热床
#mesh_min:
# 定义矩形热床的最小X Y 坐标
# 这个坐标是相对于
# 这是探测的第一个点在原点附近
# 矩形热床必须要提供此参数
#mesh_max:
# 定义矩形热床的最大X Y 坐标
# 与mesh_min相同但是这将是离床的原点最远的探测点
# 矩形热床必须要提供此参数
#probe_count: 3, 3
# 对于矩形热床，这个逗号分开了在X Y 轴需要探测的点数
# 单个值也是有效的，在这个情况下值会被应用到两个轴
# 默认值是 3, 3
#round_probe_count: 5
# 对于圆形热床，这个值去定义了每个轴最大的探测点的数量
# 这个值必须要是奇数
# 默认值是 5
#fade_start: 1.0
# 启用fade_start时开始分阶段调整的gcode z位置
# 默认值是 1.0.
#fade_end: 0.0
# 在完成渐变后的gcode z 位置
# 当值比 fade_start低的时候会禁用此功能
# 注意这个功能可能会在打印的时候往z轴添加不需要的缩放
# 如果希望启用过度那么, 推荐值为10.0
# 默认值是 0.0 不启用过度
#fade_target:
# 淡化应该聚集的z位置
# 当这个值被设置为非零值时那么就必须在网格中的Z值范围内
# 用户希望汇聚的时候z原点的位置
# 应该被设置为0
# 默认是网格的平均值
#split_delta_z: .025
# 触发分层的沿途Z差量 (mm)
# 默认值是 .025.
#move_check_distance: 5.0
# 检查split_delta_z的距离
# 这也是一个动作可以分层的最小长度。
# 默认值是 5.0
#mesh_pps: 2, 2
# 一对以逗号分隔的整数X、Y，定义每段的点的数量
# 在网格中沿每个轴插值的点数
# "segment "可以被定义为每个探测点之间的空间
# 如果用户输入了一个值那么将会应用到两个轴上
# 默认值上 2, 2
#algorithm: lagrange
# 要使用的插值算法
# 可以是"lagrange"或者"bicubic"
# 这个选项不会影响 3x3 的网格因为3x3 的网格会强制使用lagrange采样
# 默认值是lagrange
#bicubic_tension: .2
# 当使用bicubic算法时使用bicubic_tension参数来改变插值的斜率量
# 较大的数字会增加斜率的数量会在网格中产生更多的弯曲
# 默认值是 .2
#relative_reference_index:
# 网格中的一个点索引，用来引用所有的Z值
# 启用这个参数可以产生一个相对于所提供的索引处的
# 探测到的Z位置的网格
#faulty_region_1_min:
#faulty_region_1_max:
# 可选点被定义为故障区域
# 更多对于故障区域多信息See docs/Bed_Mesh.md
# 最多可添加 99 个故障区域。
# 默认没有设置故障区域
```

### [bed_tilt]

打印床倾斜补偿。可以定义一个 bed_tilt 配置分段来启用移动变换倾斜打印床补偿。请注意，bed_mesh 和 bed_tilt 不兼容：两者无法同时被定义。

See the [command reference](G-Codes.md#bed_tilt) for additional information.

```
[bed_tilt]
#x_调整：0
# 在 X 轴上每 mm 添加到每次移动的 Z 高度的量
# 轴。默认值为 0。
#y_调整：0
# 在 Y 轴上每 mm 添加到每次移动的 Z 高度的量
# 轴。默认值为 0。
#z_调整：0
# 喷嘴标称位置时添加到 Z 高度的量
# 0, 0。默认为 0。
# 其余参数控制一个 BED_TILT_CALIBRATE 扩展
# g-code 命令，可用于校准适当的 x 和 y
#调整参数。
#点：
# X、Y 坐标列表（每行一个；后续行
# indented) 应该在 BED_TILT_CALIBRATE 期间探测
＃   命令。指定喷嘴的坐标并确保探头
# 在给定喷嘴坐标处的床上方。默认是
# 不启用命令。
#速度：50
# 校准期间非探测移动的速度（以 mm/s 为单位）。
# 默认为 50。
#horizontal_move_z：5
# 头部应该被命令移动到的高度（以毫米为单位）
# 就在开始探测操作之前。默认值为 5。
```

### [bed_screws]

Tool to help adjust bed leveling screws. One may define a [bed_screws] config section to enable a BED_SCREWS_ADJUST g-code command.

See the [leveling guide](Manual_Level.md#adjusting-bed-leveling-screws) and [command reference](G-Codes.md#bed_screws) for additional information.

```
[bed_screws]
#screw1:
# 第一颗打印机调平螺丝的X,Y坐标。这是将命令喷嘴移动到螺丝正
# 上方时的位置（或在床上方时尽可能接近的位置）。
# 必须提供此参数。
#screw1_name:
# 给定螺丝的名称。当调平助手脚本运行时会使用该名称。
# 默认值是螺丝的 XY 位置
#screw1_fine_adjust:
# 用于精细调整第一颗调平螺丝时的喷嘴被命令移动到的X,Y坐标。
# 默认值为不执行对打印床螺丝的精细调整。
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
# 可以有而外的调平螺丝但是至少需要3个
#horizontal_move_z: 5
# 打印头在两个点之间移动时候的高度
# 默认值为 5
#probe_height: 0
# 探针高度 (mm) 在打印床和热端热膨胀后探针的高度。
# 默认值为 0
#speed: 50
# 校准过程中非探测移动的速度 (mm/s)
# 默认值为 50
#probe_speed: 5
# 从 horizontal_move_z 位置移动到 probe_height 位置的速度 (mm/s)
# 默认值为 5
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

调平使用4个独立Z轴电机的动龙门。纠正动龙门架由于龙门活动性造成的双曲抛物线效应（薯片形）。警告：在移动打印床上使用该功能可能会导致不理想的结果。如果该分段存在，可以使用 QUAD_GANTRY_LEVEL 扩展G代码命令。该程序假定Z轴电机配置如下：

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

## 自定义归零

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
#z_hop_speed: 20.0
#   Speed (in mm/s) at which the Z axis is lifted prior to homing. The
#   default is 20mm/s.
#move_to_previous: False
#   When set to True, the X and Y axes are reset to their previous
#   positions after Z axis homing. The default is False.
```

### [homing_override]

归位覆写。可以使用这种机制来运行一系列 G-Code 命令来替代常规的G28。通常用于需要特定过程才能将机器归零的打印机。

```
[homing_override]
gcode：
#   覆盖常规 G28 命令的 G 代码命令序列。
#   G 代码格式请参阅 docs/Command_Templates.md。如果
#   G28 包含在此命令列表中，常规版本的G28会被调用并进
#   行打印机的正常归位过程。此处列出的命令必须归位所
#   有轴。
#   必须提供此参数。
#axes: xyz
#   要覆盖的轴。例如，如果将其设置为"z"，则覆盖脚本将
#   仅在 z 轴被归位时运行（例如，通过"G28" 或 "G28 Z0"
#   命令）。请注意，覆盖脚本仍然需要归位所有轴。
#   默认值为"xyz"，覆盖全部所有 G28 命令。
#set_position_x：
#set_position_y：
#set_position_z：
#   如果指定，打印机将假定轴在运行上述 G 代码命令序列
#   之前的位置。该设置会禁用相应轴的归位检查。在打印
#   头必须在执行常规 G28 机制前移动相应的轴时有用。
#   默认不假定轴的位置。
```

### [endstop_phase]

Stepper phase adjusted endstops. To use this feature, define a config section with an "endstop_phase" prefix followed by the name of the corresponding stepper config section (for example, "[endstop_phase stepper_z]"). This feature can improve the accuracy of endstop switches. Add a bare "[endstop_phase]" declaration to enable the ENDSTOP_PHASE_CALIBRATE command.

See the [endstop phases guide](Endstop_Phase.md) and [command reference](G-Codes.md#endstop_phase) for additional information.

```
[endstop_phase stepper_z]
#endstop_accuracy:
#   设置预期的限位精度（以毫米(mm)为单位）。 代表了相位可能
#   触发的最大误差距离（比如，一个可能会提早 100um 触发或延迟
#   100um 触发的限位需要将该值设为 0.200,也就是 200um）。
#  默认为 4*rotation_distance/full_steps_per_rotation。
#trigger_phase:
#   该参数定义了相位触发时预期的步进电机驱动相位。这通常是两
#   个由正斜杠符号分隔的整数 - 相位和总相位数（例如 "7/64"）。
#   只有当步进电机驱动在 mcu 重置时也会重置才需要该参数。
#   如果没有定义，步进相位会在第一次归位时检测并被用于后续归位。
#endstop_align_zero: False
#   如果是 True 则打印机的 position_endstop 相应轴的零点位置是步进
#   电机的一个全步位置。(在Z轴上，如果打印层高是全步的倍数，每
#   层都会在全步上。）
#   默认为 False。
```

## G 代码宏和事件

### [gcode_macro]

G-Code宏（"gcode_macro"前缀定义的G-Code 宏分段没有数量限制）。更多信息请参见[命令模板指南](Command_Templates.md)。

```
[gcode_macro 命令] 。
#gcode:
#   一个替代"命令" 执行的 G 代码命令的列表。请看
#   docs/Command_Templates.md 了解支持的 G 代码格式。
#   必须提供此参数。
#variable_<名称>:
#   可以指定任意数量的带有"变量_"前缀的设置。
#   定义的变量名将被赋予给定的值（并被解析为作为一个
#   Python Literal），并在宏扩展时可用。
#   例如，一个带有"variable_fan_speed = 75"的 G-Code 命令的
#   G 代码列表中可以包含"M106 S{ fan_speed * 255 }"。变量
#   可以在运行时使用 SET_GCODE_VARIABLE 命令进行修改
#   （详见docs/Command_Templates.md）。变量名称
#   不能使用大写字母。
#rename_existing:
#   这个选项将导致宏覆盖一个现有的 G-Code 命令，并通过
#   这里提供的名称引用该命令的先前定义。覆盖命令时应注
#   意，因为它可能会导致复杂和意外的错误。
#   默认不覆盖现有的 G-Code 命令。
#description: G-Code macro
#   在 HELP 命令或自动完成中使用的简单描述。
#   默认为"G-Code macro"。
```

### [delayed_gcode]

在设定的延迟上执行 gcode。 有关详细信息，请参阅 [命令模板指南](Command_Templates.md#delayed-gcodes) 和 [命令参考](G-Codes.md#delayed_gcode)。

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

Support saving variables to disk so that they are retained across restarts. See [command templates](Command_Templates.md#save-variables-to-disk) and [G-Code reference](G-Codes.md#save_variables) for further information.

```
[save_variables]
filename:
#   必须提供一个可以用来保存参数到磁盘的文件名。
#   例如 . ~/variables.cfg
```

### [idle_timeout]

空闲超时。默认启用空闲超时 - 添加显式 idle_timeout 配置分段以更改默认设置。

```
[idle_timeout]
#gcode:
#   在空闲超时时执行的一系列 G-Code 命令。G-Code 格式请见
#   docs/Command_Templates.md。
#   默认运行 "TURN_OFF_HEATERS" 和 "M84"。
#timeout: 600
#   在执行以上 G-Code 前等待的空闲时间（以秒为单位）
#   默认为 600 秒。
```

## 可选的 G-Code 特性

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

See the [command reference](G-Codes.md#sdcard_loop) for supported commands. See the [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin compatible M808 G-Code macro.

```
[sdcard_loop]
```

### [force_move]

Support manually moving stepper motors for diagnostic purposes. Note, using this feature may place the printer in an invalid state - see the [command reference](G-Codes.md#force_move) for important details.

```
[force_move]
#enable_force_move: False
#   设置为true来启用 FORCE_MOVE 和 SET_KINEMATIC_POSITION 扩展 
#   G代码命令。
#   默认为false。
```

### [pause_resume]

暂停/恢复功能，支持位置储存和恢复。更多信息见[命令参考](G-Code.md#pause_resume)。

```
[pause_resume]
#recover_velocity: 50.
# 当捕捉/恢复功能被启用时，返回到捕获的位置的速度(单位：毫米/秒)。
# 默认为50.0 mm/s。
```

### [firmware_retraction]

固件耗材回抽。这个选项启用了许多切片软件发布的G10（回抽）和G11（回抽后恢复挤出）GCODE指令。下面的参数提供了启动默认值，尽管这些值可以通过SET_RETRACTION[command](G-Codes.md#firmware_retraction)来允许每个耗材设置和运行时调整

```
[firmware_retraction]
#retract_length: 0
# 当 G10 被运行时回抽的长度（以毫米(mm)为单位）
# 和当 G11 被运行时退回的长度（但同时也包括
# 以下的unretract_extra_length）。
# 默认为0毫米。
#retract_speed: 20
# 回抽速度，以毫米每秒(mm/s)为单位。默认为每秒20毫米。
#unretract_extra_length: 0
# 退回时增加*额外*长度（以毫米(mm)为单位）的耗材。
#unretract_speed: 10
# 退回速度，以毫米(mm)为单位。
# 默认值为10mm/s
```

### [gcode_arcs]

Support for gcode arc (G2/G3) commands.

```
[gcode_arcs]
#resolution: 1.0
#   一条弧线将被分割成若干段。每段的长度将
#   等于上面设置的分辨率（mm）。更低的值会产生一个
#   更细腻的弧线，但也会需要机器进行更多运算。小于
#   配置值的曲线会被视为直线。
#   默认为1毫米。
```

### [respond]

启用“M118”和“RESPOND”扩展 [commands](G-Codes.md#respond)。

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

## 共振补偿

### [input_shaper]

启用 [共振补偿](Resonance_Compensation.md)。 另请参阅 [命令参考](G-Codes.md#input_shaper)。

```
[input_shaper]
#shaper_freq_x: 0
#   输入整形器的 X 轴频率(Hz)。通常这是希望被输入整形器消除的
#   X 轴共振频率。对于更复杂的整形器，例如2- 和 3-hump EI 输入
#   整形器，设置这个参数可能需要考虑其他特性。
#   默认值是0，禁用 X 轴输入整形。
#shaper_freq_y: 0
#   输入整形器的 Y 轴频率(Hz)。通常这是希望被输入整形器消除的
#   Y 轴共振频率。对于更复杂的整形器，例如2- 和 3-hump EI 输入
#   整形器，设置这个参数可能需要考虑其他特性。
#   默认值是0，禁用 Y 轴输入整形。
#shaper_type: mzv
#   用于 X 和 Y 轴的输入整形器。支持的输入整形器有 zv、mzv、
#   zvd、ei、2hump_ei 和 3hump_ei。
#   默认为 mzv 输入整形器。
#shaper_type_x:
#shaper_type_y:
#   如果没有设置 shaper_type，可以用这两个参数来单独配置 X
#   和 Y 轴的 输入整形器。
#   该参数支持全部shaper_type 支持的选项。
#damping_ratio_x: 0.1
#damping_ratio_y: 0.1
#   X 和 Y 轴的共振抑制比例，可以用来改善振动抑制效果。
#   默认值是 0.1，适用于大多数打印机。
#   大多数情况下不需要调整这个值。
```

### [adxl345]

Support for ADXL345 accelerometers. This support allows one to query accelerometer measurements from the sensor. This enables an ACCELEROMETER_MEASURE command (see [G-Codes](G-Codes.md#adxl345) for more information). The default chip name is "default", but one may specify an explicit name (eg, [adxl345 my_chip_name]).

```
[adxl345]
cs_pin:
#   传感器的 SPI 启用引脚。
#   必须提供此参数。
#spi_speed: 5000000
#   与芯片通信时使用的SPI速度(hz)。
#   默认为5000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   参见"常见的SPI设置"章节，以了解对上述参数的描述。
#axes_map: x, y, z
#   打印机的X、Y和Z轴的加速度计轴。
#   如果加速度计的安装方向与打印机的方向不一致，
#   可能需要修改该设定。
#   例如，可以将其设置为"y, x, z"来交换X和Y轴。
#   如果加速度计方向是相反的，可能需要反转相应轴
#   （例如，"x, z, -y"）。
#   默认是"x, y, z"。
#rate: 3200
#   ADXL345的输出数据速率。ADXL345支持以下数据速率。
#   3200、1600、800、400、200、100、50和25。请注意，不建议
#   将此速率从默认的3200改为低于800的速率，这将大大影响
#   共振测量的质量。
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

引入文件支持。可以在主打印机配置文件中引用额外的配置文件。支持通配符（例如，`configs/*.cfg`）。

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

This tool allows a single micro-controller pin to be defined multiple times in a config file without normal error checking. This is intended for diagnostic and debugging purposes. This section is not needed where Klipper supports using the same pin multiple times, and using this override may cause confusing and unexpected results.

```
[duplicate_pin_override]
pins:
#   一个逗号分隔的引脚列表，允许其中的引脚在配置文件中被多次使用而不触发错误检查。
#   必须提供此参数。
```

## 热床探测硬件

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

BLTouch 探针。可以定义这个分段（而不是探针（probe）分段）来启用 BLTouch 探针。更多信息见[BL-Touch 指南](BLTouch.md)和[命令参考](G-Code.md#bltouch)。一个虚拟的 "probe:z_virtual_endstop "引脚也会被同时创建（详见 "probe "章节）。

```
[bltouch]
sensor_pin:
#   连接到 BLTouch sensor 针脚的引脚。大多数 BLTouch 需要在传感器引脚
#   上有一个上拉（在引脚名称前加上"^"）。
#   必须提供这个参数。
control_pin:
#   连接到 BLTouch control 引脚的引脚。
#   必须提供这个参数。
#pin_move_time: 0.680
#   等待 BLTouch 引脚向上或向下移动的时间（秒）。
#   默认为0.680秒。
#stow_on_each_sample: True
#   决定 Klipper 在多次探测的序列中每一次探测间是否命令缩回探针。
#   在设置为False之前，请阅读docs/BLTouch.md中的说明。
#   默认值是True。
#probe_with_touch_mode: False
#   如果为True，那么Klipper将在设备处于"touch_mode"模式下进行
#   探测。
#   默认为False(在"pin_down"模式下探测)。
#pin_up_reports_not_triggered: True
#   设置 BLTouch 在每次成功的发送“pin_up"命令收针后时候会持续
#   报告探针处于"未触发"状态。所有正版的 BLTouch 都应该是 True。
#   在设置为False前请阅读docs/BLTouch.md中的说明。
#   默认为True。
#pin_up_touch_mode_reports_triggered:True
#   设置 BLTouch 在连续发送"pin_up"和"touch_mode"后是否持续报告
#   "触发"状态。所有正版 BLTouch 都是True。在设置为False之前，请先阅读
#   docs/BLTouch.md中的说明。
#   默认为True。
#set_output_mode:
#   在BLTouch V3.0(及以后的版本)上请求一个特定的传感器引脚输出模式。
#   在其他类型的探针上不应该请求任何输出模式。设置为"5V"以要求传感
#   器引脚输出5伏电压（只在打印机主板引脚需要 5V 模式，并且其输入的
#   信号线可以容忍5V时可以使用）。设置为"OD"以要求传感器引脚输出
#   使用开漏(open drain)模式。
#   默认不要求输出模式。
#x_offset:
#y_offset:
#z_offset: #z_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries: #samples_tolerance_retries:
#   有关这些参数的信息，请参见"probe"分段。
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

在一个多挤出机的打印机中，为每个额外的挤出机添加一个额外挤出机分段。额外挤出机分段应被命名为"extruder1"、"extruder2"、"extruder3"，以此类推。有关可用参数，参见"extruder"章节。

多挤出机参考示例[sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg)

```
[挤出机1]
#step_pin：
#dir_pin：
#...
# 有关可用的步进器和加热器，请参阅“挤出机”部分
＃   参数。
#shared_heater：
# 此选项已弃用，不应再指定。
```

### [dual_carriage]

Support for cartesian printers with dual carriages on a single axis. The active carriage is set via the SET_DUAL_CARRIAGE extended g-code command. The "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation.

Idex参考示例[sample-idex.cfg](../config/sample-idex.cfg)

```
[dual_carriage]
axis:
#   额外滑车所在的轴（x或者y）。
#   必须提供这个参数。
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   以上参数的定义请查阅“stepper”分段。
```

### [extruder_stepper]

Support for additional steppers synchronized to the movement of an extruder (one may define any number of sections with an "extruder_stepper" prefix).

See the [command reference](G-Codes.md#extruder) for more information.

```
[extruder_stepper my_extra_stepper]
extruder:
#   这个步进电机将要同步到的挤出机名称
#   如果被设为空字符串，这个步进电机将不会被同步到挤出机
#   必须提供此参数
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   以上参数详见“stepper”配置分段。
```

### [manual_stepper]

手动步进器（可以通过定义任何数量"manual_stepper"前缀的配置分段）。这些是由 MANUAL_STEPPER G代码命令控制的步进电机。例如："MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5"。参见[G-Code](G-Code.md#manual_stepper)文档中关于 MANUAL_STEPPER 命令的描述。手动步进器械不会连接到正常的打印机运动学中。

```
[manual_stepper my_stepper]。
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   有关这些参数的描述请见"stepper"分段。
#velocity:
#   设置步进电机的默认速度（单位：mm/s）。这个值会在 MANUAL_STEPPER
#   命令没有指定一个 SPEED 参数时会被使用。
#   默认为 5 mm/s。
#accel:
#   设置步进电机的默认加速度（单位：mm/s^2）。设置加速度为零将导致
#   没有加速度。这个值会在 MANUAL_STEPPER 命令没有指定 ACCEL 参数时
#   会被使用。
#   默认为 0。
#endstop_pin:
#   限位开关检测引脚。如果定义了这个参数，可以通过在 MANUAL_STEPPER
#   运动命令中添加一个 STOP_ON_ENDSTOP 参数来执行 "归位动作" 。
```

## 自定义加热器和传感器

### [verify_heater]

加热器和温度传感器验证。默认在打印机上每个配置的加热器上启用加热器验证。使用 verify_heater 分段来覆盖默认设置。

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
#   会使加热器被禁用的步进电机逗号分隔列表。
#   默认在归零和探测时禁用全部加热器。
#   例如：stepper_z
#heaters:
#   归零和探测时会被禁用的加热器的逗号分隔列表。
#   默认禁用全部加热器。
#   例如：extruder, heater_bed
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

通用的加热器（任意数量的使用"heater_generic"前缀定义的节）。这些加热器表现得类似于标准加热器（挤出机、热床）。使用SET_HEATER_TEMPERATURE命令（详见[G-Code](G-Code.md#heaters)）来设置目标温度。

```
[heater_generic my_generic_heater]
#gcode_id:
#   使用M105查询温度时使用的ID。
#   必须提供此参数。
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
#   以上参数详见“extruder”分段。
```

### [temperature_sensor]

通用温度传感器（可以定义任意数量的通用温度传感器）。通过 M105 命令查询温度。

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

## 温度传感器

Klipper 包括许多类型的温度传感器的定义。这些传感器可以在任何需要温度传感器的配置分段中使用（例如`[extruder]`或`[heated_bed]`分段）。

### 常见热敏电阻

常见的热敏电阻。在使用这些传感器之一的加热器分段中可以使用以下参数。

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

### 直接连接PT1000 传感器

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

### MAXxxxxx 温度传感器

MAXxxxxx 串行外设接口（SPI）温度传感器。以下参数在使用该类型传感器的加热器分段中可用。

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

BMP280/BME280/BME680 两线接口 (I2C) 环境传感器。注意，这些传感器不适用于挤出机和加热床。它们可以用于监测环境温度 (C)、压力 (hPa)、相对湿度以及气体水平（仅在BME680上）。请参阅 [sample-macros.cfg](../config/sample-macros.cfg) 以获取可用于报告压力和湿度以及温度的gcode_macro。

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

### HTU21D 传感器

HTU21D 系列双线接口（I2C）环境传感器。注意，这种传感器不适用于挤出机和加热床，它们可以用于监测环境温度（C）和相对湿度。参见 [sample-macros.cfg](../config/sample-macros.cfg) 中可以报告温度和湿度的 gcode_macro。

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

### LM75 温度传感器

LM75/LM75A两线（I2C）连接的温度传感器。这些传感器的温度范围为-55~125 C，因此可用于例如试验室温度监测。它们还可以作为简单的风扇/加热器控制器使用。

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

### 微控制器的内置温度传感器

atsam、atsamd和stm32微控制器包含一个内部温度传感器。可以使用"temperature_mcu"传感器来监测这些温度。

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

### 主机温度传感器

Temperature from the machine (eg Raspberry Pi) running the host software.

```
sensor_type: temperature_host
#sensor_path:
#   The path to temperature system file. The default is
#   "/sys/class/thermal/thermal_zone0/temp" which is the temperature
#   system file on a Raspberry Pi computer.
```

### DS18B20 温度传感器

DS18B20 是一个单总线 (1-wire (w1)) 数值温度传感器。注意，这个传感器不是被设计用于热端或热床， 而是用于监测环境温度(C)。这些传感器最高量程是125 C，因此可用于例如箱体温度监测。它们也可以被当作简单的风扇/加热器控制器。DS18B20 传感器仅在“主机 mcu”上支持，例如树莓派。w1-gpio Linux 内核模块必须被安装。

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

打印冷却风扇。

```
[fan]
pin:
#   控制风扇的输出引脚。
#   必须提供此参数。
#max_power: 1.0
#   引脚允许被设置的最大占空比（在0.0和1.0之间）。
#   1.0 允许引脚被长时间完全启用，而0.5会只允许引脚只在一半的时间里
#   被启用。这个设置可以限制风扇的最大功率（平均功率）。如果这个值
#   小于 1.0 则风速请求会被缩放到 0 和 max_power 之间（例如，如果
#   max_power 是 0.9，请求 80% 风速速度会使风扇功率设为72%）。
#   默认为1.0。
#shutdown_speed: 0
#   在微控制器进入错误状态时期望的（一个在0.0和1.0之间的值）
#   风扇速度。
#   默认为 0。
#cycle_time: 0.010
#   每个风扇电源的PWM周期时间（以秒为单位）
#   使用基于软件的PWM时建议大于10毫秒
#   默认为0.010秒
#hardware_pwm: False
#   启用硬件PWM来代替软件PWM
#   许多风扇使用硬件PWM时可能会不能很好地工作
#   所以这不是很推荐启用的，除非有切换得非常快的电气需求
#   当使用硬件PWM时，真正的PWM周期时间受执行的约束，
#   可能显著地与请求的周期时间不同。
#   默认为False
#kick_start_time: 0.100
#   当初次开启或提高风扇速度到50%以上时
#   使风扇全速运行的时间（以秒为单位）
#   （帮助风扇开始旋转）
#   默认为0.100秒
#off_below: 0.0
#   给风扇供电的最低输入速度（在0.0到1.0之间）
#   当请求了一个低于off_below的速度，风扇会关闭
#   这个设置可能会被用于防止风扇失速并且
#   保证kick starts的有效
#   默认为0.0
#
#   这个设置应该在max_power被调整时重新校准
#   为了校准这个设置，可以在off_below设为0.0时让风扇转动
#   逐步降低风扇的速度来决定最小的可靠的不使风扇失速的速度
#   根据相应或略微更高的值设置off_below（比如12%->0.12）
#tachometer_pin:
#    监控风扇转速的输入引脚
#   通常需要一个上拉电阻
#   这个参数是可选的
#tachometer_ppr: 2
#   当指定了tachometer_pin，这是每转脉冲的个数
#   对于一个无刷直流风扇（BLDC）这个通常为极对数的一半
#   默认为2
#tachometer_poll_interval: 0.0015
#   当指定了tachometer_pin，这是tachometer_pin的轮询周期，以秒为单位
#   默认为0.0015，对于测量低于10000转每分和2脉冲每转已经够快
#   这个值必须比30/(tachometer_ppr * rpm)小且留有一些余量
#   其中rpm是风扇的最高转速
```

### [heater_fan]

加热器冷却风扇（可以用"heater_fan"前缀定义任意数量的分段）。"加热器风扇"是一种当其关联的加热器活跃时会启用的风扇。默认情况下，heater_fan shutdown_speed 等于 max_power。

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
#   以上参数详见“fan”章节。
#heater: extruder
#   该风扇关联的加热器配置分段名称。如果提供了一个逗号分隔的
#   加热器列表，则风扇将会在任一加热器被启用时启动。
#   默认为"extruder"。
#heater_temp: 50.0
#   风扇可以被禁用的最高加热器温度（以摄氏度为单位）。加热器
#   必须被降低到该温度以下风扇才会被禁用。
#   默认为 50 摄氏度。
#fan_speed: 1.0
#   当相关联的加热器活跃时该风扇的速度（在0.0和1.0之间）。
#   默认为 1.0
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

温度触发的冷却风扇（可以定义任意数量的带有“temperature_fan”前缀的部分）。一个"temperature fan"是一个只要其相关的传感器高于设定温度就会启用的风扇。默认情况下，一个温度风扇的关闭速度等于最大功率。

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

手动控制的风扇（可以用"fan_generic"前缀定义任何数量的手动风扇分）。可以通过 SET_FAN_SPEED[gcode命令](G-Code.md#fan_generic)设置风扇速度。

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

## LEDs

### [led]

Support for LEDs (and LED strips) controlled via micro-controller PWM pins (one may define any number of sections with an "led" prefix). See the [command reference](G-Codes.md#led) for more information.

```
[led my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
#   控制给定LED的引脚。
#   至少提供一个上述引脚
#cycle_time: 0.010
#   每个PWM周期的时间（以秒为单位）
#   使用软件PWM时建议大于10毫秒
#   默认值为0.010秒
#hardware_pwm: False
#   启用硬件PWM代替软件PWM
#   当使用硬件PWM时，真正的PWM周期时间受执行的约束，
#   可能显著地与请求的周期时间不同。
#   默认为False
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   设置初始化时LED颜色
#   每个值应当在0.0与1.0之间
#   每个颜色的默认值都为0
```

### [neopixel]

对于Neopixel（也就是WS2812）LED的支持（可以定义任意数量的带有“neopixel”前缀的部分）见[command reference](G-Codes.md#led)获取更多信息

注意！[linux mcu](RPi_microcontroller.md)的实现目前不支持直接连接的neopixels。目前使用Linux内核接口的设计不允许这种情况发生，因为内核的GPIO接口速度不够快，无法提供所需的脉冲率。

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

Dotstar（又名 APA102）LED 支持（可以使用“dotstar”前缀定义任意数量的部分）。 有关详细信息，请参阅 [命令参考](G-Codes.md#led)。

```
[dotstar my_dotstar]
数据引脚：
# 接点星数据线的管脚。 这个参数
＃   必须提供。
时钟引脚：
# 连接到dotstar时钟线的引脚。 这个参数
＃   必须提供。
#chain_count：
# 有关此参数的信息，请参阅“neopixel”部分。
#initial_RED：0.0
#initial_GREEN：0.0
#initial_BLUE：0.0
# 有关这些参数的信息，请参阅“led”部分。
```

### [pca9533]

PCA9533 LED支持。PCA9533 在mightyboard上使用。

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

PCA9632 LED支持。PCA9632在FlashForge Dreamer上使用。

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

## 额外的舵机、按钮和其他引脚

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

在一个按钮被按下或放开（或当一个引脚状态发生变化时）时运行G代码。你可以使用 `QUERY_BUTTON button=my_gcode_button` 来查询按钮的状态。

```
[gcode_button my_gcode_button]
pin:
#   连接到按钮的引脚。
#   必须提供此参数。
#analog_range:
#   两个逗号分隔的阻值(单位：欧姆)，指定了按钮的最小和最大电阻。
#   如果提供了 analog_range ，必须使用一个模拟功能的引脚。默认
#   情况下为按钮使用数字GPIO。
#   analog_pullup_resistor:
#   当定义 analog_range 时的上拉电阻(欧姆)。默认为4700欧姆。
#press_gcode:
#   当按钮被按下时要执行的 G-Code 命令序列，支持G-Code模板。
#   必须提供此参数。
#release_gcode:
#   当按钮被释放时要执行的G-Code命令序列，支持G-Code模板。
#   默认在按钮释放时不运行任何命令。
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
#   与此别名关联的引脚的逗号分隔列表。
#   必须提供此参数。
```

## TMC stepper driver configuration

在UART/SPI模式下配置Trinamic步进电机驱动器。其他信息在[TMC驱动程序指南](TMC_Drivers.md)和[命令参考](G-Code.md#tmcxxxx)中。

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
#   以上参数见"tmc2208"部分
#uart_address:
#   TMC2209的UART地址（0-3的整数）
#   这个参数通常用于多个TMC2209连接到同个UART接口
#   默认是0
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
#   配置TMC2209时配置的寄存器
#   这些参数通常用于设定自己定制的电机参数
#   每个参数的默认值如上
#diag_pin:
#   微控制器连接到TMC2209的DIAG接口的引脚
#   这个引脚通常使用"^"前缀来开启内部上拉
#   设置这个会创建一个名为"tmc2209_stepper_x:virtual_endstop"的虚拟引脚
#   用做步进电机的终止引脚。
#   在启动"sensorless homing"（无限位归零）时设置这个。
#   （确保同时设置了driver_SGTHRS为一个合适的灵敏度）
#   默认是关闭了无限位归零
```

### [tmc2660]

通过 SPI 总线配置 TMC2660 步进电机驱动。要使用此功能，请定义一个带有 “tmc 2660” 前缀并后跟步进驱动配置分段相应名称的配置分段（例如，“[tmc2660 stepper_x]”）。

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

## 运行时步进电机电流配置

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
#   芯片在I2C总线上的地址。
#   必须提供此参数。
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   以上参数请见“常见的I2C设置”章节。
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
#   芯片在I2C总线上使用的地址。
#   默认为96。
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   以上参数请见“常见的I2C设置”
#channel_a:
#channel_b:
#channel_c:
#channel_d:
#   设置 MCP4728 通道为给定的静态值。通常它被设置为一个在
#   0.0和1.0之间，1.0代表最高电压（2.048V）而0.0代表最低电压。
#   然而，该范围可以被'scale'（ 缩放）参数改变（见下文）。没有给
#   定值的通道不会被配置。
#scale:
#   该参数可以改变'channel_x'参数被解释的方式。如果设定了该参数，
#   'channel_x'参数的范围会在0.0 和 'scale'之间。该功能在使用MCP4728 产生
#   步进电机参考电压时可能有用。The 'scale' can
#   be set to the equivalent stepper amperage if the MCP4728 were at
#   its highest voltage (2.048V), and then the 'channel_x' parameters
#   can be specified using the desired amperage value for the
#   stepper.默认不对channel_x'参数进行缩放。
```

### [mcp4018]

Statically configured MCP4018 digipot connected via two gpio "bit banging" pins (one may define any number of sections with an "mcp4018" prefix).

```
[mcp4018 my_digipot]
scl_pin:
#   SCL "时钟"引脚。
#   必须提供这个参数。
sda_pin:
#   SCL "数据"引脚。
#   必须提供这个参数。
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

## 显示屏支持

### [display]

Support for a display attached to the micro-controller.

```
[display]
lcd_type:
#   使用的 LCD 芯片类型。这可以是“hd44780”、“hd44780_spi”、
#   “st7920”、“emulated_st7920”、“uc1701”、“ssd1306”、或“sh1106”。
#   有关不同的LCD芯片类型和它们特有的参数，请查看下面的显示屏分段。
#   必须提供此参数。
#display_group:
#   显示在这个显示屏上的 display_data 组。它决定了这个屏幕显示
#   的内容（详见“display_data”分段）。
#   hd44780 默认使用 _default_20x4，其他显示屏则默认使用 _default_16x4。
#menu_timeout:
#   菜单超时时间。在不活跃给定时间后将会退出菜单或在 autorun 启用时
#   回到根菜单。
#   默认为 0 秒（禁用）。
#menu_root:
#   在主屏幕按下编码器时显示的主菜单段名称。
#   默认为 __main，这会显示在 klippy/extras/display/menu.cfg中定义的主菜单。
#menu_reverse_navigation:
#   启用时反转上滚动和下滚动。
#   默认为False。这是一个可选参数。
#encoder_pins:
#   连接到编码器的引脚。使用编码器时必须提供两个引脚。
#   使用菜单时必须提供此参数。
#encoder_steps_per_detent:
#   编码器在每一个凹陷处（"click"）发出多少步。如果编码器需要转过两个凹
#   陷才能在条目之间移动，或者转过一个凹痕会在两个词条之间移动/跳过
#   一个词条，可以尝试改变这个值。
#   允许的值是2 （半步）或 4（全步）。
#   默认为 4。
#click_pin:
#   连接到 "enter" 按钮或编码器按压的引脚。
#   使用菜单时必须提供此参数。
#   如果定义了 “analog_range_click_pin”配置参数，则这个参数的引脚需要
#   是模拟引脚。
#back_pin:
#   连接到“back”按钮的引脚。这是一个可选参数，菜单不需要这个按钮。
#   如果定义了 “analog_range_back_pin”配置参数，则这个参数的引脚需要
#   是模拟引脚。
#up_pin:
#   连接到“up”按钮的引脚。在不使用编码器时使用菜单必须提供这个参数。
#   如果定义了 “analog_range_up_pin”配置参数，则这个参数的引脚需要
#   是模拟引脚。
#down_pin:
#   连接到“down”按钮的引脚。 在不使用编码器时使用菜单必须提供这个参数。
#   如果定义了 “analog_range_down_pin”配置参数，则这个参数的引脚需要
#   是模拟引脚。
#kill_pin:
#   连接到“kill”按钮的引脚。 这个按钮将会触发紧急停止。
#   如果定义了 “analog_range_kill_pin”配置参数，则这个参数的引脚需要
#   是模拟引脚。
#analog_pullup_resistor: 4700
#   连接到模拟按钮的拉高电阻阻值(ohms)
#   默认为 4700 ohms。
#analog_range_click_pin:
#   'enter'按钮的阻值范围。
#   在使用模拟按钮时必须提供由逗号分隔最小和最大值。
#analog_range_back_pin:
#   'back'按钮的阻值范围。
#   在使用模拟按钮时必须提供由逗号分隔最小和最大值。
#analog_range_up_pin:
#   'up'按钮的阻值范围。
#   在使用模拟按钮时必须提供由逗号分隔最小和最大值。
#analog_range_down_pin:
#   'down'按钮的阻值范围。
#   在使用模拟按钮时必须提供由逗号分隔最小和最大值。
#analog_range_kill_pin:
#   'kill'按钮的阻值范围。
#   在使用模拟按钮时必须提供由逗号分隔最小和最大值。
```

#### hd44780显示器

有关配置 hd44780 显示器（在"RepRapDiscount 2004 Smart Controller"类型显示屏中可以找到）的信息。

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

#### hd44780_spi显示器

有关配置 hd44780_spi 显示屏的信息 - 通过硬件"移位寄存器"（用于基于 mightyboard 的打印机）控制的20x04显示器。

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

#### st7920 display

有关配置 st7920 类显示屏的信息（可用于 "RepRapDiscount 12864 Full Graphic Smart Controller" 类型的显示器）。

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

#### emulated_st7920（模拟ST7920）显示屏

有关配置模拟 st7920 显示屏的信息 —它可以在一些"2.4 寸触摸屏"和其他类似设备中找到。

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

#### uc1701 display

有关配置 uc1701 显示屏的信息（用于“MKS Mini 12864”型显示屏）。

```
[display]
lcd_type: uc1701
#   uc1701 显示屏应设为"uc1701"。
cs_pin:
a0_pin:
#   连接到 uc1701 类LCD的引脚。
#   必须提供这些参数。
#rst_pin:
#   连接到 LCD "rst" 的引脚。 如果没有定义，则硬件必须在LCD
#   相应的线路上带一个LCD引脚。
#contrast:
#   显示屏的对比度。必须在0和63之间。
#   默认为40。
...
```

#### ssd1306 and sh1106 displays

ssd1306 和 sh1106 显示屏的配置信息。

```
[display]
lcd_type:
#   对于给定的显示屏类型，设置为 “ssd1306" 或 "sh1106"。
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   连接到I2C总线的显示屏的可选参数， 以上参数详见通
#   用 I2C 设置章节。
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   使用4线 SPI 模式时连接到 lcd 的引脚。以 "spi_" 开头的
#   参数详见 “通用 SPI 设置” 章节。
#   显示屏默认使用 I2C 模式
#reset_pin:
#   可以指定一个显示屏上的重置引脚，如果不指定，硬件
#   必须在相应的 lcd 线路上有一个拉高电阻。
#contrast:
#   可设置的对比度。
#   数值必须在 0 和 256 之间，默认为 239。
#vcomh: 0
#   设置显示屏的 Vcomh 值。这个值与一些OLED显示屏的
#   模糊效果有关。这个数值可以在 0 和 63 之间。
#   默认为0。
#invert: False
#   TRUE 可以在一些OLED显示屏上反转像素
#   默认为 False。
#x_offset: 0
#   设置在 SH1106 显示屏上的水平偏移。
#   默认为0。
...
```

### [display_data]

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

### [display_template]

显示数据文本"macros"（可以定义任意数量的带有display_template前缀的部分）。有关模板评估的信息，请参阅[命令模板](Command_Templates.md)文件。

This feature allows one to reduce repetitive definitions in display_data sections. One may use the builtin `render()` function in display_data sections to evaluate a template. For example, if one were to define `[display_template my_template]` then one could use `{ render('my_template') }` in a display_data section.

This feature can also be used for continuous LED updates using the [SET_LED_TEMPLATE](G-Codes.md#set_led_template) command.

```
[显示模板我的模板名称]
#param_<名称>：
# 可以指定任意数量的带有“param_”前缀的选项。 这
# 给定的名称将被赋予给定的值（解析为 Python
# 字面量）并且在宏扩展期间可用。 如果
# 参数在调用 render() 时传递，然后该值将
# 在宏扩展时使用。 例如，一个配置
# "param_speed = 75" 可能有一个调用者
# "render('my_template_name', param_speed=80)". 参数名称可以
# 不使用大写字符。
文本：
# 渲染此模板时要返回的文本。 这个领域
# 使用命令模板进行评估（参见
# docs/Command_Templates.md）。 必须提供此参数。
```

### [display_glyph]

在支持自定义字形的显示器上显示一个自定义字形。给定的名称将被分配给给定的显示数据，然后可以在显示模板中通过用“波浪形（～）”符号包围的名称来引用，即 `~my_display_glyph~` 。

更多示例 [sample-glyphs.cfg](../config/sample-glyphs.cfg)

```
[display_glyph my_display_glyph]
#data:
#   被存储为16 行，每行 16 位（1位代表1个像素）的显示数据。“.”是一个
#   空白的像素，而‘*’是一个开启的像素（例如，"****************"
#   可以用来显示一条横向的实线。除此以外，也可以用“0”作为空
#   白的像素，而‘1’作为开启的像素。需要将每个显示的行放到配置文件
#   中独立的一行。每个字形都必须包含且仅包含 16 行，每行 16 位。
#   这是一个可选参数。
#hd44780_data:
#   用于 20x4 hd44780 显示屏的字形。字形必须包含且仅包含 8 行，
#   每行 5 位。
#   这是一个可选参数。
#hd44780_slot:
#   用于存储字形的 hd44780 硬件索引（0..7）。如果多个独特的图片使用
#   了相同的索引位置，需要保证在任何屏幕上只使用其中一个图片。
#   如果定义了 hd44780_data ，则必须提供此参数。
```

### [display my_extra_display]

如果如上所示在 printer.cfg 中定义了主要的 [display] 分段，还可以定义多个辅助显示器。注意，辅助显示器当前不支持菜单功能，因此它们不支持“menu”选项或按钮配置。

```
[display my_extra_display] 。
#   可用参数参见 "显示 "分段。
```

### [menu]

可自定义液晶显示屏菜单。

一套[默认菜单](../klippy/extras/display/menu.cfg)将被自动创建。通过覆盖 printer.cfg 主配置文件中的默认值可以替换或扩展该菜单。

See the [command template document](Command_Templates.md#menu-templates) for information on menu attributes available during template rendering.

```
# 所有的菜单配置分段都有的通用参数。
#[menu __some_list __some_name]
#type: disabled
#   永久禁用这个菜单元素，唯一需要的属性是 "type"。
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

## 耗材传感器

### [filament_switch_sensor]

耗材开关传感器。支持使用开关传感器（如限位开关）进行耗材插入和耗尽检测。

See the [command reference](G-Codes.md#filament_switch_sensor) for more information.

```
[filament_switch_sensor my_sensor]。
#pause_on_runout: True
#   当设置为 "True "时，会在检测到耗尽后立即暂停打印机。
#   请注意, 如果 pause_on_runout 为 False 并且没有定义。
#   runout_gcode的话, 耗尽检测将被禁用。
#   默认为 True。
#runout_gcode:
#   在检测到耗材耗尽后会执行的G代码命令列表。
#   有关G-Code 格式请见 docs/Command_Templates.md。
#   如果 pause_on_runout 被设置为 True，这个G-Code将在
#   暂停后执行。
#   默认情况是不运行任何 G-Code 命令。
#insert_gcode:
#   在检测到耗材插入后会执行的 G-Code 命令列表。
#   关于G代码格式，请参见 docs/Command_Templates.md。
#   默认不运行任何 G-Code 命令，这将禁用耗材插入检测。
#event_delay: 3.0
#   事件之间的最小延迟时间（秒）。
#   在这个时间段内触发的事件将被默许忽略。
#   默认为3秒。
#pause_delay: 0.5
#   暂停命令和执行 runout_gcode 之间的延迟时间, 单位是秒。
#   如果在OctoPrint的情况下，增加这个延迟可能改善暂
#   停的可靠性。如果OctoPrint表现出奇怪的暂停行为，
#   考虑增加这个延迟。
#   默认为0.5秒。
#switch_pin:
#   连接到检测开关的引脚。
#   必须提供此参数。
```

### [filament_motion_sensor]

耗材移动传感器。使用一个在耗材通过传感器时输出引脚状态会发生变化来检测耗材插入和耗尽。

See the [command reference](G-Codes.md#filament_switch_sensor) for more information.

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#   触发传感器 switch_pin 引脚状态变化的最小距离。
#   默认为 7 mm。
extruder:
#   该传感器相关联的挤出机。
#   必须提供此参数。
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   以上参数详见“filament_switch_sensor”章节。
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

霍尔耗材宽度传感器（详见[霍尔耗材宽度传感器](Hall_Filament_Width_Sensor.md)）。

```
[hall_filament_width_sensor]
adc1:
adc2:
#   连接到传感器的模拟输入引脚。
#   必须提供这些参数。
#cal_dia1: 1.50
#cal_dia2: 2.00
#   传感器的校准值（单位：毫米）。
#   默认 cal_dia1 为1.50，cal_dia2 为 2.00。
#raw_dia1: 9500
#raw_dia2: 10500
#   传感器的原始校准值。默认raw_dial1 为 9500
#   而 raw_dia2 为 10500。
#default_nominal_filament_diameter: 1.75
#   标称耗材直径。
#   必须提供此参数。
#max_difference: 0.200
#   允许的耗材最大直径差异，单位是毫米（mm）。
#   如果耗材标称直径和传感器输出之间的差异
#   超过正负 max_difference，挤出倍数将被设回
#   到100%。
#   默认为0.200。
#measurement_delay: 70
#   从传感器到熔腔/热端的距离，单位是毫米 (mm)。
#   传感器和热端之间的耗材将被视为标称直径。主机
#   模块采用先进先出的逻辑工作。它将每个传感器的值和
#   位置在一个数组中，并会在正确的位置使用传感器值。
#   必须提供这个参数。
#enable:False
#   传感器在开机后启用或禁用。
#   默认是 False。
#measurement_interval: 10
#   传感器读数之间的近似距离(mm)。
#   默认为10mm。
#logging:False
#   输出直径到终端和 klipper.log，可以通过命令启用或禁用。
#min_diameter: 1.0
#   触发虚拟 filament_switch_sensor 的最小直径。
#use_current_dia_while_delay: False
#   在未被测量的 measurement_delay 部分耗材使用当前耗材
#   传感器报告的直径而不是标称直径。
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   关于上述参数的描述请参见"filament_switch_sensor"章节。
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

Duet 2 Maestro 通过vref和vssa读数进行模拟缩放。定义一个adc_scaled分段来启用根据板载vref和vssa监视引脚调节的虚拟adc引脚（例如“my_name:PB0"）。虚拟引脚必须先被Duet 2 Maestro 通过vref和vssa读数进行模拟缩放。定义一个adc_scaled分段来启用根据板载vref和vssa监视引脚调节的虚拟adc引脚（例如“my_name:PB0"）。虚拟引脚必须先被定义才能用在其他配置分段中。

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

Replicape支持 - 参考[beaglebone guide](Beaglebone.md)和[generic-replicape.cfg](./config/generic-replicape.cfg)

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

## 其他自定义模块

### [palette2]

Palette 2 多材料支持 - 提供更紧密的集成，支持处于连接模式的 Palette 2 设备。

This modules also requires `[virtual_sdcard]` and `[pause_resume]` for full functionality.

不要和 Octoprint 的 Palette 2插件一起使用这个模块，因为它们会发生冲突，造成初始化和打印失败。

如果使用 OctoPrint 并通过串行端口流式传输 G-Code，而不通过 virtual_sd 打印，将 * 设置>串行连接>固件和协议 * 中的“暂停命令” 设置为**M1** 和 **M0** 可以避免在开始打印时需要在Palette 2 上选择开始打印并在 OctoPrint 中取消暂停。

```
[palette2]
serial:
#   连接到 Palette 2 的串口。
#baud: 115200
#   使用的波特率。
#   默认为115200。
#feedrate_splice: 0.8
#   融接时的给进率
#   默认为0.8。
#feedrate_normal: 1.0
#   不在融接时的给进率 1.0
#auto_load_speed: 2
#   自动换料时的给近率
#   默认 2 (mm/s)
#auto_cancel_variation: 0.1
#   # 当 ping 值变化高于此阈值时自动取消打印
```

### [angle]

支持使用a1333、as5047d或tle5012b SPI芯片的磁性霍尔角度传感器测量并读取步进电机的角度。测量结果可以通过[API服务器](API_Server.md)和[运动分析工具](Debugging.md#motion-analysis-and-data-logging)获取。可用的命令请见[G代码参考](G-Codes.md#angle)。

```
[angle my_angle_sensor]
sensor_type:
# 磁性霍尔传感器芯片的类型。
# 可用的选择是 "a1333" "as5047d "和 "tle5012b"。
# 这个参数必须被指定。
#sample_period: 0.000400
# 测量时使用的查询周期（以秒为单位）。
# 默认值是 0.000400 （每秒钟2500个样本）
#stepper:
# 角度传感器连接的步进电机名称（例如，"stepper_x"）。
# 设置这个值可以启用一个角度校准工具
# 要使用这个功能需要安装Python "numpy "包。
# 默认是不启用角度传感器的角度校准。
cs_pin:
# 传感器的SPI引脚。必须提供此参数。
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
# 有关上述参数的描述，参考 "common SPI settings "
```

## 常见的总线参数

### 常见 SPI 设置

以下参数一般适用于使用SPI总线的设备。

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

### 常见的I2C设置

以下参数一般适用于使用I2C总线的设备。

```
#i2c_address:
#   设备的 I2C 地址。必须是一个十进制数字（而不是十六进制）。
#   默认值取决于设备的类型。
#i2c_mcu:
#   芯片所连接的微控制器的名称。
#   默认为"mcu"。
#i2c_bus:
# 如果微控制器支持多个 I2C 总线，可以指定微控制器的总线名称。
#   默认值取决于微控制器的类型。
#i2c_speed:
#   与设备通信时使用的I2C速度（Hz）。在某些微控制器上，
#   该数值无效。
#   默认值是默认为100000。
```
