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
#   corexy, corexz, hybrid_corexy, hybrid_corexz, generic_cartesian,
#   rotary_delta, delta, deltesian, polar, winch, or none.
#   This parameter must be specified.
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

步进电机定义。 不同的打印机类型（由 [打印] 配置部分中的“运动学”选项指定）步进器需要定义不同的名称（例如，`stepper_x` 与 `stepper_a`）。 以下是常见的步进器定义。

关于计算`rotation_distance` 参数的方法，请参见[旋转距离文档](Rotation_Distance.md)。关于使用多个微控制器的归位的方法，请参见[Multi-MCU homing](Multi_MCU_Homing.md)文件。

```
[stepper_x]
step_pin:
#   步进 GPIO 引脚（高电平表示触发）。
#   必须提供此参数。
dir_pin:
#   方向 GPIO 引脚（高电平表示正方向）。
#   必须提供此参数。
enable_pin:
#   使能引脚（默认是高电平启用；使用！表示低电平启用）。
#   如果未提供此参数，步进电机驱动器必须始终被启用。
rotation_distance:
#   轴在步进电机（或指定了齿轮比例的最后一个齿轮）进行一
#   次完整旋转时行进的距离（以毫米为单位）。
#   必须提供此参数。
microsteps:
#   步进电机驱动器使用的微步数。
#   必须提供此参数。
#full_steps_per_rotation: 200
#   步进电机一次旋转的完整步数。对于1.8度的步进电机，将此
#   值设定为200；对于0.9度的电机，设定为400。
#   默认值是200。
#gear_ratio:
#   如果步进电机通过齿轮箱与轴相连，则为齿轮比例。例如，如
#   果使用的是5到1的齿轮箱，可以指定"5:1"。如果轴有多个齿轮
#   箱，可以指定逗号分隔的齿轮比例列表（例如，"57:11, 2:1"）。
#   如果指定了gear_ratio，则rotation_distance指定了最后一个齿轮
#   完整旋转时轴行进的距离。
#   默认情况下不使用齿轮比例。
#step_pulse_duration:
#   step脉冲信号边缘与后续的"unstep"信号边缘之间的最短时间。
#   这也用于设置step脉冲和方向变化信号之间的最短时间。对于在UART
#   或SPI模式下配置的TMC步进器，默认值为0.000000100（100ns），
#   对于所有其他步进器，默认值为0.000002（即2us）。
endstop_pin:
#   限位开关检测引脚。如果此限位引脚位于与步进电机不同的mcu上，
#   则启用"多mcu归位"。
#   笛卡尔式打印机上的X，Y和Z步进电机必须提供此参数。
#position_min: 0
#   用户可以命令步进器移动到的最小有效距离（以毫米为单位）。
#   默认值是0毫米。
position_endstop:
#   限位开关的位置（以毫米为单位）。
#   对于笛卡尔式打印机上的X，Y和Z步进电机，必须提供此参数。
position_max:
#   用户可以命令步进器移动到的最大有效距离（以毫米为单位）。
#   对于笛卡尔式打印机上的X，Y和Z步进电机，必须提供此参数。
#homing_speed: 5.0
#   步进器在归位时的最大速度（以毫米/秒为单位）。
#   默认值是5毫米/秒。
#homing_retract_dist: 5.0
#   在归位过程中第二次归位之前的后退距离（以毫米为单位）。
#   将此设置为零以禁用第二次归位。
#   默认值是5毫米。
#homing_retract_speed:
#   在归位后进行收缩移动的速度，如果这个速度应该与归位速度不同。
#   归位速度是这个参数的默认值
#second_homing_speed:
#   在进行第二次归位时步进器的速度（以毫米/秒为单位）。
#   默认值是homing_speed的一半。
#homing_positive_dir:
#   如果为True，归位会使步进器向正方向移动（远离零）；如果为False，
#   向零方向归位。
#   最好使用默认值，而不是指定此参数。
#   如果position_endstop靠近position_max，则默认值为True，如果靠近
#   position_min，则默认值为False。
```

### 笛卡尔运动学

cartesian 运动学配置文件参考[example-cartesian.cfg](../config/example-cartesian.cfg)

此处描述的参数只适用于笛卡尔打印机，有关可用参数，请参阅 [常用运动设置](#common-kinematic-settings)。

```
[printer]
kinematics: cartesian
max_z_velocity:
#   定义沿z轴运动的最大速度（单位：mm/s）。它限制了Z轴步进
#   电机的最大速度。
#   默认使用max_velocity为 max_z_velocity。
max_z_accel:
#   定义沿Z轴运动的最大加速度（单位：mm/s^2）。
#   它限制了z步进电机的加速度。
#   默认使用使用max_accel为max_z_accel。

#   stepper_x 分段描述了控制了笛卡尔结构中X轴的
#   步进器。
[stepper_x]

#   stepper_y 分段描述了控制了笛卡尔结构中Y轴的
#   步进器。
[stepper_y]

#   stepper_z 分段描述了控制了笛卡尔结构中Z轴的
#   步进器。
[stepper_z]
```

### 线性三角洲运动学

linear delta运动学配置文件参考[example-delta.cfg](../config/example-delta.cfg)。 关于校准方法 [三角洲校准指南](Delta_Calibrate.md)。

此处仅描述了线性三角洲打印机的特定参数 - 有关可用参数，请参阅 [常用运动设置](#common-kinematic-settings)。

```
[printer]
kinematics: delta
max_z_velocity:
#   对于Delta打印机，这限制了Z轴运动的最大速度（单位：mm/s）。
#   该设置可用于降低上/下移动的最大速度（上下移动需要比Delta
#   打印机上的其他移动要高的步进脉冲速率）。
#   默认使用 max_velocity 定义 max_z_velocity。
#max_z_accel:
#   这设置了沿Z轴移动的最大加速度（单位：mm/s^2）。
#   Z轴的最大加速度。如果打印机在XY轴运动时加速度可以比Z轴运动
#   速度高，可以设置这个参数。（例如，当使用输入整形器时）
#   默认使用 max_accel 定义 max_z_accel。
#minimum_z_position:0
#   用户可以命令打印头移动的最小Z位置。
#   默认为0。
delta_radius:
#   由三个线性轴塔形成的水平圆的半径（mm）。这个参数通过以下公式计算：
#   delta_radius = smooth_rod_offset - effector_offset - carriage_offset
#   必须提供这个参数。
# print_radius:
#   有效打印头XY坐标的半径（mm）。可以使用该1设置来定制打印头
#   移动范围的检查。如果这里指定的值很大，那么命令有可能会使打
#   印头与轴塔发生碰撞。
#   默认使用 delta_radius来代替print_radius（这通常足以避免碰撞）。

#   stepper_a 分段描述了控制左前方轴塔的的步进器（210度）。该分段
#   还定义了归位全部轴塔的参数（归位速度，归位缩回距离）。
[stepper_a]
position_endstop:
#   喷嘴和床身之间的距离（mm），当喷嘴在在打印空间的中心，并且
#   限位被触发。
#   必须在stepper_a中被定义；对于stepper_b和stepper_c，这个参数默
#   认为stepper_a指定的值。
arm_length:
#   连接该轴塔和打印头的对角线连杆长度(mm)。此参数必须提供给
#   stepper_a；对于stepper_b和stepper_c，该参数的默认值为stepper_a
#   指定的值。
#angle:
#   这个选项指定了轴塔的角度(度)。stepper_a的默认值是210，stepper_b
#   的默认值是330，而stepper_c的默认值是90。

#   stepper_b 分段描述了控制前右方轴塔的步进器(330度)。
[stepper_b]

#   stepper_c 分段描述了控制后方轴塔的步进器(90度)。
[stepper_c]

#   delta_calibrate部分启用了DELTA_CALIBRATE扩展的
#   g-code命令，可以校准塔台的端点位置和角度。
[delta_calibrate]
radius:
#   可以探测到的区域的半径（mm）。这是要探测的喷嘴坐标的半径；
#   如果使用自动探针有一个XY偏移，那么需要选择一个足够小的半径，使
#   探针总是在打印床上探测。
#   必须提供此参数。
#speed: 50
#   校准过程中非探测移动的速度(单位：mm/s)。
#   默认为50。
#horizontal_move_z: 5
#   在开始探测操作之前，探针应被命令移动到的高度（以毫米为单位）。
#   默认值为5。
```

### Delta 运动学

参见[example-deltesian.cfg](.../config/example-deltesian.cfg)，以了解三角洲运动学配置文件实例。

这里只描述了特定于deltesian打印机的参数 - 有关可用参数，请参见[常见运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: deltesian
max_z_velocity:
#   对于deltesian打印机，这限制了带有z轴移动的运动的最大速度（
#   以mm/s为单位）。此设置可以用于减小上下移动的最大速度（这
#   需要比deltesian打印机上的其他移动更高的步进率）。
#   默认情况下，max_z_velocity使用max_velocity的值。
#max_z_accel:
#   这设置了沿z轴移动的最大加速度（以mm/s^2为单位）。如果打印
#   机在XY移动上可以达到比Z轴移动更高的加速度（例如，当使用输入
#   整形器时），那么设置这个可能会很有用。
#   默认情况下，max_z_accel使用max_accel的值。
#minimum_z_position: 0
#   用户可以命令头部移动到的最小Z位置。
#   默认值为0。
#min_angle: 5
#   这代表deltesian手臂相对于水平线所能达到的最小角度（以度为单位）。
#   此参数旨在限制手臂变得完全水平，这可能会导致XZ轴意外翻转。
#   默认值为5。
#print_width:
#   有效工具头X坐标的距离（以mm为单位）。人们可以使用此设置来自
#   定义工具头移动的范围检查。如果在此处指定了一个大值，那么可能会
#   命令工具头与塔发生碰撞。
#   此设置通常对应于床宽（以mm为单位）。
#slow_ratio: 3
#   用于在X轴极限附近限制移动速度和加速度的比率。如果垂直距离除以
#   水平距离超过slow_ratio的值，那么速度和加速度就限制为其标称值的
#   一半。如果垂直距离除以水平距离超过slow_ratio值的两倍，那么速度
#   和加速度就限制为其标称值的四分之一。
#   默认值为3。

#   stepper_left部分用于描述控制左塔的步进马达。此部分还控制所有塔
#   的归零参数（homing_speed, homing_retract_dist）。
[stepper_left]
position_endstop:
#   当喷嘴在构建区域的中心并且终点开关被触发时，喷嘴与床之间的距
#   离（以mm为单位）。此参数必须为stepper_left提供；对于stepper_right，
#   此参数默认为为stepper_left指定的值。
arm_length:
#   连接塔运输车与打印头的对角杆的长度（以mm为单位）。
#   此参数必须为stepper_left提供；
#   对于stepper_right，此参数默认为为stepper_left指定的值。
arm_x_length:
#   打印机归位时，打印头与塔之间的水平距离。此参数必须
#   为stepper_left提供；
#   对于stepper_right，此参数默认为为stepper_left指定的值。

#   stepper_right部分用于描述控制右塔的步进马达。
[stepper_right]

#   stepper_y部分用于描述控制deltesian机器人的Y轴的步进马达。
[stepper_y]
```

### CoreXY 运动学

corexy或者h-bot运动学配置文件参考[example-corexy.cfg](./config/example-corexy.cfg)

这里只描述了 CoreXY 打印机特有的参数 -- 有关可用参数，请参阅 [常见运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: corexy
max_z_velocity:
#   定义了沿z轴运动的最大速度（单位：mm/s）。这个设置可以
#   限制z步进电机的最大速度。
#   默认使用max_velocity 定义 max_z_velocity。
max_z_accel:
#   定义了沿Z轴运动的最大加速度（单位：mm/s^2）。该设置可
#   以限制z步进电机的加速度。
#   默认使用max_accel 定义 max_z_accel。

#   stepper_x分段描述了X轴，以及控制X+Y运动的步进器。
[stepper_x]

#   stepper_y分段描述了Y轴，以及控制X-Y运动的步进器。
[stepper_y]

#   stepper_z 分段用于描述控制Z轴的步进器。
[stepper_z]
```

### CoreXZ 运动学

corexz 运动学配置文件参考[example-corexz.cfg](../config/example-corexz.cfg)

此处描述的参数只适用于笛卡尔打印机—有关全部可用参数，请参阅 [常用的运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: corexz
max_z_velocity:
#   定义沿z轴运动的最大速度（单位：mm/s）。
#   默认使用max_velocity 定义 max_z_velocity。
max_z_accel:
#   这设置了沿Z轴运动的最大加速度(以mm/s^2为单位)。
#   Z轴的最大加速度。默认使用max_accel 定义 max_z_accel。

#   stepper_x 分段定义了X轴以及控制X+Z的步进器。
[stepper_x]

#   stepper_y 分段定义了y轴以及控制Y轴的步进器。
[stepper_y]

#   stepper_z 分段定义了X轴以及控制X-Z的步进器。
[stepper_z]
```

### Hybrid-CoreXY (混合型 CoreXY) 运动学

hybrid corexy运动学配置文件参考[example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg)

该运动学也称为 Markforged 运动学。

此处仅描述了线性三角洲打印机的特定参数—有关全部可用参数，请参阅 [常用的运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: hybrid_corexy
max_z_velocity:
#   定义了沿z轴运动的最大速度（单位：mm/s）。
#   默认使用使用max_velocity定义max_z_velocity。
max_z_accel:
#   定义了沿Z轴运动的最大加速度(以mm/s^2为单位)。
#   默认使用max_accel定义max_z_accel。

#   stepper_x分段用于描述X轴，以及控制X-Y运动的步进器。
[stepper_x]

#   stepper_y分段用于描述控制Y轴的步进器。
[stepper_y]

#   stepper_z分段用于描述控制Z轴的步进器。
[stepper_z]
```

### Hybrid-CoreXZ (混合型 CoreXZ) 运动学

hybrid corexz 运动学配置文件参考 [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg)

该运动学也称为 Markforged 运动学。

此处仅描述了线性三角洲打印机的特定参数—有关全部可用参数，请参阅 [常用的运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: hybrid_corexz
max_z_velocity:
#   定义了沿z轴运动的最大速度（单位：mm/s）。
#   默认使用max_velocity定义max_z_velocity。
max_z_accel:
#   定义了沿Z轴运动的最大加速度(以mm/s^2为单位)。
#   默认使用max_accel定义max_z_accel。

#   stepper_x 分段描述了X轴，以及控制X-Z运动的步进器。
[stepper_x]

#   stepper_y分段描述了Y轴和控制Y轴的步进器。
[stepper_y]

#   stepper_z分段描述了Z轴和控制Z轴的步进器。
[stepper_z]
```

### 极坐标运动学

polar运动学配置文件参考 [example-polar.cfg](../config/example-polar.cfg)

这里只描述了极坐标打印机特有的参数—全部可用的参数请见[常用的运动学设置](#common-kinematic-settings)。

极坐标运动学还在开发中。在0, 0位置周围移动有一些已知问题。

```
[printer]
kinematics: polar
max_z_velocity:
#   定义了z轴的极限速度（单位：mm/s）。该设置可以单独限制
#   Z轴步进电机的极限速度。
#   默认使用 max_velocity 为 max_z_velocity。
max_z_accel:
#   定义了Z轴的极限加速度（单位：mm/s^2）。该设置单独限制了
#   Z轴步进电机的加速度。
#   默认使用max_accel为max_z_accel。

#   stepper_bed 分段定义了控制打印床的步进电机。
[stepper_bed]
gear_ratio:
#   必须指定齿轮比，但不必须指定旋转距离。例如，如果打印床有
#   一个80齿的滑轮，由一个16齿的步进电机驱动，那么可以指定
#   齿轮比为"80:16"。
#   必须提供此参数。

#   stepper_arm分段定义了控制机械臂上滑车的步进电机。
[stepper_arm]

#   stepper_z 分段定义了控制Z轴的步进电机。
[stepper_z]
```

### Rotary delta 运动学

Rotary Delta运动学配置文件参考[example-rotary-delta.cfg](../config/example-rotary-delta.cfg)

此处仅介绍特定于旋转三角洲打印机的参数—有关可用参数，请参阅[常用的运动学设置](#common-kinematic-settings)。

ROTARY DELTA运动学正在进行的修复工作。归位动作可能会超时并且一些边界检查也没有实现。

```
[打印机]
kinematics: rotary_delta
max_z_velocity:
#   对于delta打印机，此设置限制了带有z轴移动的移动的最大速度（以
#   mm/s为单位）。可以使用此设置来降低上下移动的最大速度（在
#   delta打印机上，这些移动需要比其他移动更高的步进速率）。
#   默认max_z_velocity使用max_velocity。
#minimum_z_position: 0
#   用户可以命令头部移动到的最小Z位置。
#   默认为0。
shoulder_radius:
#   三个肩部关节形成的水平圆的半径（以毫米为单位），减去效应器
#   关节形成的圆的半径。此参数也可以计算为：
#   shoulder_radius = (delta_f - delta_e) / sqrt(12)
#   必须提供此参数。
shoulder_height:
#   肩部关节与床之间的距离（以毫米为单位），减去效应器工具头高度。
#   必须提供此参数。

#   stepper_a分段描述了控制后右臂（30度方位）的步进电机。此部分还控制
#   所有臂的归位参数（homing_speed，homing_retract_dist）。
[stepper_a]
gear_ratio:
#   必须指定一个gear_ratio，且可能不指定rotation_distance。例如，如果臂上
#   有一个80齿的滑轮，由16齿的滑轮驱动，该滑轮又连接到一个由16齿的步
#   进电机驱动的60齿滑轮，则应指定gear_ratio为"80:16, 60:16"。
#   必须提供此参数。
position_endstop:
#   喷嘴在构建区域中心并触发终点开关时，喷嘴与床之间的距离（以毫米为
#   单位）。
#   必须为stepper_a提供此参数；对于stepper_b和stepper_c，此参数默认为
#   stepper_a指定的值。
upper_arm_length:
#   连接"肩部关节"和"肘部关节"的手臂的长度（以毫米为单位）。
#   必须为stepper_a提供此参数；对于stepper_b和stepper_c，此参数默认为
#   stepper_a指定的值。
lower_arm_length:
#   连接"肩部关节"和"效应器关节"的手臂的长度（以毫米为单位）。
#   必须为stepper_a提供此参数；对于stepper_b和stepper_c，此参数默认为
#   stepper_a指定的值。
#angle:
#   此选项指定手臂的角度（以度为单位）。
#   默认情况下，stepper_a为30度，stepper_b为150度，stepper_c为270度。

#    stepper_b分段描述了控制后左臂（150度方位）的步进电机。
[stepper_b]

#   stepper_c分段描述了控制前臂（270度方位）的步进电机。
[stepper_c]

#   delta_calibrate分段启用了一个DELTA_CALIBRATE扩展G代码命令，可以
#   校准肩部终点位置。
[delta_calibrate]
radius:
#   可以探测的区域的半径（以毫米为单位）。这是要探测的喷嘴坐标的半径；
#   如果使用带有XY偏移的自动探针，则选择一个半径足够小，以便探针总是
#   适合在床上。
#   必须提供此参数。
#speed: 50
#   校准期间非探测移动的速度（以毫米/秒为单位）。
#   默认为50。
#horizontal_move_z: 5
#   开始探测操作之前，头部应被命令移动到的高度（以毫米为单位）。
#   默认为5。
```

### 缆绳绞盘运动学

有关缆绳绞盘运动学配置文件的例子，参见[example-winch.cfg](./config/example-winch.cfg)。

这里只描述了缆绳铰盘式(cable winch)打印机特有的参数 — 全部可用的参数见[常用的运动学设置](#common-kinematic-settings)。

缆绳铰盘支持是实验性的。归位在缆绳绞盘运动学中没有实现。在打印机归位时需要手动发送运动指令将工具头处于0, 0, 0位置，然后发出`G28`归位。

```
[printer]
kinematics: winch

#   stepper_a 分段描述了连接到缆绳铰盘的第一个步进器。
#   最少3个，最多26个缆绳铰盘可以被定义(stepper_a 到 stepper_z)，但通常
#   会定义4个。
[stepper_a]
rotation_distance:
#   rotation_distance 是工具头在步进电机每转一圈时向缆绳绞盘移动的额定距离（单位：mm）。
#   必须提供这个参数。
anchor_x:
anchor_y:
anchor_z:
#   缆绳绞盘在笛卡尔空间的X、Y和Z位置。
#   必须提供这些参数。
```

### Generic Cartesian Kinematics

See [example-generic-cartesian.cfg](../config/example-generic-caretesian.cfg) for an example generic Cartesian kinematics config file.

This printer kinematic class allows a user to define in a pretty flexible manner an arbitrary Cartesian-style kinematics. In principle, the regular cartesian, corexy, hybrid_corexy can be defined this way too. However, more importantly, various otherwise unsupported kinematics such as inverted hybrid_corexy or corexyuv can be defined using this kinematic.

Notably, the definition of a generic Cartesian kinematic deviates significantly from the other kinematic types. It follows the following convention: a user defines a set of carriages with certain range of motion that can move independently from each other (they should move over the Cartesian axes X, Y, and Z, hence the name of the kinematic) and corresponding endstops that allow the firmware to determine the position of carriages during homing, as well as a set of steppers that move those carriages. The `[printer]` section must specify the kinematic and other printer-level settings same as the regular Cartesian kinematic:

```
[printer]
kinematics: generic_cartesian
max_velocity:
max_accel:
#minimum_cruise_ratio:
#square_corner_velocity:
#max_accel_to_decel:
#max_z_velocity:
#max_z_accel:
```

Then a user must define the following three carriages: `[carriage x]`, `[carriage y]`, and `[carriage z]`, e.g.

```
[carriage x]
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

Afterwards, a user specifies the stepper motors that move these carriages, for instance

```
[stepper my_stepper]
carriages:
#   A string describing the carriages the stepper moves. All defined
#   carriages can be specified here, as well as their linear combinations,
#   e.g. x, x+y, y-0.5*z, x-z, etc. This parameter must be provided.
step_pin:
dir_pin:
enable_pin:
rotation_distance:
microsteps:
#full_steps_per_rotation: 200
#gear_ratio:
#step_pulse_duration:
```

See [stepper](#stepper) section for more information on the regular stepper parameters. The `carriages` parameter defines how the stepper affects the motion of the carriages. For example, `x+y` indicates that the motion of the stepper in the positive direction by the distance `d` moves the carriages `x` and `y` by the same distance `d` in the positive direction, while `x-0.5*y` means the motion of the stepper in the positive direction by the distance `d` moves the carriage `x` by the distance `d` in the positive direction, but the carriage `y` will travel distance `d/2` in the negative direction.

More than a single stepper motor can be defined to drive the same axis or belt. For example, on a CoreXY AWD setups two motors driving the same belt can be defined as

```
[carriage x]
endstop_pin: ...
...

[carriage y]
endstop_pin: ...
...

[stepper a0]
carriages: x-y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...

[stepper a1]
carriages: x-y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...
```

with `a0` and `a1` steppers having their own control pins, but sharing the same `carriages` and corresponding endstops.

There are situations when a user wants to have more than one endstop per axis. Examples of such configurations include Y axis driven by two independent stepper motors with belts attached to both ends of the X beam, with effectively two carriages on Y axis each having an independent endstop, and multi-stepper Z axis with each stepper having its own endstop (not to be confused with the configurations with multiple Z motors but only a single endstop). These configurations can be declared by specifying additional carriage(s) with their endstops:

```
[extra_carriage my_carriage]
primary_carriage:
#   The name of the primary carriage this carriage corresponds to.
#   It also effectively defines the axis the carriage moves over.
#   This parameter must be provided.
endstop_pin:
#   Endstop switch detection pin. This parameter must be provided.
```

and the corresponding stepper motors, for example:

```
[extra_carriage y1]
primary_carriage: y
endstop_pin: ...

[stepper sy1]
carriages: y1
...
```

Notably, an `[extra_carriage]` does not define parameters such as `position_min`, `position_max`, and `position_endstop`, but instead inherits them from the specified `primary_carriage`, thus sharing the same range of motion with the primary carriage.

For the references on how to configure IDEX setups, see the [dual carriage](#dual-carriage) section.

### 无运动学

可以定义特殊的 "none" 运动学来禁用 Klipper 中的运动学支持。可以用于控制不是 3D 打印机的设备或调试。

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   必须定义 max_velocity 和 max_accel，但是 它们不会被“none”运动学使用。
```

## 常见的挤出机和热床支持

### [extruder]

挤出机部分用于描述喷嘴热端以及控制挤出机的步进器的加热器参数。请参阅[命令参考](G-Code.md#extruder)了解更多信息。参见[压力提前量指南](Pressure_Advance.md)以了解关于调整压力提前量的信息。

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

heater_bed分段定义了一个热床。它有和“extruder”分段的加热器设置选项。

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

更多信息请参阅 [网床指南](Bed_Mesh.md)和[命令参考](G-Codes.md#bed_mesh)。

可视化示例：

```
 矩形热床，probe_count = 3, 3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 圆形热床，round_probe_count = 5, bed_radius = r:
                 x (0, r) 结束点
               /
             x---x---x
                       \
 (-r, 0) x---x---x---x---x (r, 0)
           \
             x---x---x
                   /
                 x  (0, -r) 起点
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

打印床倾斜补偿。可以定义一个 bed_tilt 配置分段来启用移动变换倾斜打印床补偿。请注意，bed_mesh 和 bed_tilt 不兼容：两者无法同时被定义。

更多信息请参阅[命令参考](G-Codes.md#bed_tilt) 。

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

有关更多信息，请参阅 [调平指南](Manual_Level.md#adjusting-bed-leveling-screws)和 [命令参考](G-Codes.md#bed_screws)。

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

请参阅[调平指南](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)和[命令参考](G-Code.md#screws_tilt_adjust)了解更多信息。

```
[screws_tilt_adjust]
#screw1:
#   第一个调平螺丝的（X，Y）坐标。这是一个命令喷嘴的位置，使得
#   探针直接位于床螺丝的正上方（或者尽可能靠近并且仍在床上）。
#   这是用于计算的基础螺丝。
#   必须提供此参数。
#screw1_name:
#   给定螺丝的任意名称。当助手脚本运行时，将显示此名称。
#   默认情况下，使用基于螺丝 XY 位置的名称。
#screw2:
#screw2_name:
#...
#   额外的床调平螺丝。至少必须定义两个螺丝。
#speed: 50
#   在校准期间非探测移动的速度（以mm / s为单位）。
#   默认值为50。
#horizontal_move_z: 5
#   头部应该在开始探测操作之前移动到的高度（以mm为单位）。
#   默认值为5。
#screw_thread: CW-M3
#   用于床平整的螺丝类型，M3，M4或M5，以及用于调平床的旋钮的旋转方向。
#   接受的值：CW-M3，CCW-M3，CW-M4，CCW-M4，CW-M5，CCW-M5。
#   默认值是大多数打印机使用的CW-M3。旋钮的顺时针旋转减小了喷嘴和床之
#   间的间隙。相反，逆时针旋转增加了间隙。
```

### [z_tilt]

多个独立Z轴步进电机的倾斜校正。这个功能可以独立调整多个 Z 步进电机（见"stepper_z1"部分），以调整倾斜度。如果该分段存在，那么Z_TILT_ADJUST 扩展[G代码命令](G-Code.md#z_tilt)就可用。

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
#   描述龙门两个对立角的X，Y坐标的换行分隔列表。第一行对应Z，
#   第二行对应Z2。
#   必须提供此参数。
#points:
#   应在QUAD_GANTRY_LEVEL命令期间探测的四个X，Y点的换行分隔列表。
#   位置的顺序很重要，应该按照Z，Z1，Z2和Z3的位置顺序。
#   必须提供此参数。
#   为了最大的准确性，请确保配置了你的探针偏移。
#speed: 50
#   校准期间非探测移动的速度（以mm/s为单位）。
#   默认值是50。
#horizontal_move_z: 5
#   头部应被命令移动到的高度（以mm为单位），在开始探针操作之前。
#   默认值是5。
#max_adjust: 4
#   如果请求的调整大于此值，则quad_gantry_level将中止。
#retries: 0
#   如果探测的点不在容忍范围内，重试的次数。
#retry_tolerance: 0
#   如果启用了重试，则在最大和最小的探测点差异超过
#   retry_tolerance时重试。
```

### [skew_correction]

打印机偏斜校正。可以用软件来纠正打印机在xy、xz、yz三个平面上的偏斜。这是通过沿一个平面打印一个校准模型并测量三个长度来完成的。由于偏斜校正的性质，这些长度是通过G代码设置的。详情见[偏斜校正](Skew_Correction.md)和[命令参考](G-Code.md#skew_correction)。

```
[skew_correction]
```

### [z_thermal_adjust]

基于温度的工具头Z位置调整。使用温度传感器（通常连接到框架的垂直部分）实时补偿由于打印机框架的热膨胀引起的垂直方向工具头移动。

另请参阅：[扩展G代码命令](G-Codes.md#z_thermal_adjust)。

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

## 自定义归零

### [safe_z_home]

安全Z轴归位。可以用该机制定义Z轴归位时的 X, Y 坐标。在工具头必须先移动到打印床中央再进行Z归位时很有用。

```
[safe_z_home]
home_xy_position:
#   一个X，Y坐标（例如100，100），在这个坐标上应该进行Z归位。
#   必须提供此参数
#speed: 50.0
#   工具头移动到安全Z原点的速度。
#   默认为50毫米/秒
#z_hop:
#   在归位前抬升Z轴的距离（mm）。这将用于任何归位命令，即使
#   它没有将Z轴归位。
#   如果Z轴已经归位，并且当前的Z轴位置小于z_hop，那么这条命令
#   将把打印头提升到z_hop的高度。如果
#   Z轴尚未归位，则打印头将被提升z_hop的高度。
#   默认不执行Z抬升。
#z_hop_speed: 15.0
#   在归位之前，Z轴抬升的速度（单位：mm/s）。
#   默认为15mm/s。
#move_to_previous: False
#   当设置为 "True "时，X轴和Y轴在Z轴归位后会重置到之前的位置。
#   默认为false。
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

步进器相位调整限位（Stepper phase adjusted endstops）。要使用这个功能，需要定义一个配置部分，其前缀为 "endstop_phase"，后面是相应的步进配置部分的名称（例如，"[endstop_phase stepper_z]"）。这个功能可以提高限位开关的准确性。在配置文件添加"[endstop_phase]"的参数以启用ENDSTOP_PHASE_CALIBRATE命令。

更多信息见[相位限位指南](Endstop_Phase.md)和[命令参考](G-Code.md#endstop_phase)。

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

支持将变量保存到磁盘，以便在重新启动后保留。有关更多信息，请参阅[命令模板](Command_Templates.md#save-variables-to-disk)和[G-Code参考文档](G-Codes.md#save_variables)。

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
#on_error_gcode:
#   A list of G-Code commands to execute when an error is reported.
#   See docs/Command_Templates.md for G-Code format. The default is to
#   run TURN_OFF_HEATERS.
```

### [sdcard_loop]

一些具有阶段清空功能的打印机，如打印件移除器或带式打印机，可以找到并使用sdcard文件中循环部分。(例如，重复打印同一个零件，或者重复一个零件的某一节，以形成连锁或其他重复模式）。

有关支持的命令请参阅[命令参考](G-Codes.md#sdcard_loop)。兼容Marlin M808 的G代码宏可以在[sample-macros.cfg](../config/sample-macros.cfg)中找到。

```
[sdcard_loop]
```

### [force_move]

支持手动移动步进电机以进行诊断。注意，使用此功能可能会使打印机处于无效状态——有关重要细节，请参阅[命令参考](G-Codes.md#force_move)。

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

支持G代码弧线(G2/G3)命令。

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
#   将 "M118 "和 "RESPOND "输出的默认前缀设置为以下之一：
#      echo: "echo: " (这是默认的)
#      command: "// "
#      error: "!!"
#default_prefix: echo:
#   直接设置默认的前缀。如果定义，这个值将覆盖 "default_type"。
```

### [exclude_object]

启用对在打印过程中排除或取消单个对象的支持。

有关其他信息，请参阅 [排除对象指南](Exclude_Object.md) 和 [命令参考](G-Codes.md#excludeobject)。请参阅 [sample-macros.cfg](../config/sample-macros.cfg) 文件了解与 Marlin/RepRapFirmware 兼容的 M486 G 代码宏。

```
[exclude_object]
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

对 ADXL345 加速度传感器的支持。该支持允许用户从传感器获取加速度测量数据。这启用了一个 ACCELEROMETER_MEASURE 命令（有关更多信息，请参见 [G-Codes](G-Codes.md#adxl345)）。默认的芯片名称为 "default"，但您也可以指定一个明确的名称（例如，[adxl345 芯片名称]）。

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

支持 MPU-9250、MPU-9255、MPU-6515、MPU-6050 和 MPU-6500 加速度计（可通过“mpu9250”前缀定义任意数量的分段）。

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

支持共振测试和自动输入整形器校准。为了使用该模块的大多数功能，必须安装额外的软件依赖项；参考[测量共振](Measuring_Resonances.md)和[命令参考](G-Codes.md#resonance_tester)以获取更多信息。有关 `max_smoothing` 参数及其用途的更多信息，请查阅测量共振指南的 [Max smoothing](Measuring_Resonances.md#max-smoothing) 章节。

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
#   探针检测引脚。如果引脚在与Z轴步进电机不同的微控制器上，
#   则启用“多MCU归位”。
#   必须提供此参数。
#deactivate_on_each_sample: True
#   这决定了在执行多次探测尝试时，Klipper是否应在每次尝试之间
#   执行取消激活(deactivate)G代码。
#   默认为True。
#x_offset: 0.0
#   探针和喷嘴在x轴上的距离（以mm为单位）。
#   默认为0。
#y_offset: 0.0
#   探针和喷嘴在y轴上的距离（以mm为单位）。
#   默认为0。
z_offset:
#   当探针触发时，床和喷嘴之间的距离（以mm为单位）。
#   必须提供此参数。
#speed: 5.0
#   探测时Z轴的速度（以mm/s为单位）。
#   默认为5mm/s。
#samples: 1
#   探测每个点的次数。探测的z值将被平均。
#   默认是探测1次。
#sample_retract_dist: 2.0
#   在每个样本之间提升打印头的距离（以mm为单位）（如果采样超
#   过一次）。
#   默认为2mm。
#lift_speed:
#   在样本之间提升探针时Z轴的速度（以mm/s为单位）。
#   默认使用与'speed'参数相同的值。
#samples_result: average
#   采样超过一次时的计算方法 - median(中位数) 或average（平均值）。
#   默认为 average。
#samples_tolerance: 0.100
#   样本可能与其他样本的最大Z距离（以mm为单位）差异。
#   如果超出此公差，则报告错误或重新开始尝试（参见
#   samples_tolerance_retries）。
#   默认为0.100mm。
#samples_tolerance_retries: 0
#   如果发现超过samples_tolerance的样本，重试的次数。
#   在重试时，丢弃所有当前的样本并重新开始探针尝试。
#   如果在给定的重试次数内未获得有效的样本集，则报告错误。
#   默认值为0，这导致在第一个超过samples_tolerance的样本上报告错误。
#activate_gcode:
#   在每次探针尝试之前执行的G-Code命令列表。有关G-Code格式，请参见
#   docs/Command_Templates.md。如果需要以某种方式激活探针，
#   这可能会很有用。不要在此处发送任何移动打印头的命令（例如，G1）。
#   默认情况下，激活时不运行任何特殊的G-Code命令。
#deactivate_gcode:
#   在每次探针尝试完成后执行的G-Code命令列表。有关G-Code格式，
#   请参见docs/Command_Templates.md。不要在此处发送任何移动
#   工具头的命令。
#   默认情况下，取消激活时不运行任何特殊的G-Code命令。
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

Duet3d的 "Smart Effector"使用一个力传感器实现了一个Z探针。可以定义这个分段，而不是`[probe]` ，以启用智能效应器的具体功能。这也使[运行时命令](G-Code.md#smart_effector)能够在运行时调整Smart Effector 的参数。

```
[smart_effector]
pin:
#   连接到Smart Effector Z探针输出引脚（引脚5）的引脚。注意，板上通
#   常不需要拉升电阻。然而，如果输出引脚连接到带有拉升电阻的板引脚，那么
#   电阻必须是高值（例如，10K欧姆或更多）。有些板上有低值拉升电阻在Z探
#   针输入上，这可能导致始终触发的探针状态。在这种情况下，将Smart Effector
#   连接到板上的不同引脚。
#   必须提供此参数。
#control_pin:
#   连接到Smart Effector控制输入引脚（引脚7）的引脚。如果提供，Smart Effector
#   敏感度的编程命令将会变得可用。
#probe_accel:
#   如果设置，限制探针移动的加速度（以毫米/秒^2为单位）。探针移动开始时
#   的突然大加速度可能会导致探针错误触发，特别是如果热端很重。为了防止这
#   种情况，可能需要通过此参数降低探针移动的加速度。
#recovery_time: 0.4
#   旅行移动与探测移动之间的延迟，以秒为单位。快速探测前的移动可能导致探
#   针错误触发。 如果没有设置延迟，这可能会导致“探针在移动前触发”的错误。
#   默认值是0.4。
#x_offset:
#y_offset:
#   应保持未设置（或设置为0）。
z_offset:
#   探针的触发高度。从-0.1（毫米）开始，然后使用`PROBE_CALIBRATE`命令进
#   行调整。
#   必须提供此参数。
#speed:
#   探针时Z轴的速度（以毫米/秒为单位）。建议从20毫米/秒的探针速度开始，
#   并根据需要调整以提高探针触发的准确性和重复性。
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#deactivate_on_each_sample:
#   有关以上参数的更多信息，请参阅"probe"分段。
```

### [probe_eddy_current]

Support for eddy current inductive probes. One may define this section (instead of a probe section) to enable this probe. See the [command reference](G-Codes.md#probe_eddy_current) for further information.

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

## 额外的步进电机和挤出机

### [stepper_z1]

多步进电机轴。在笛卡尔式打印机上，可以在给定的轴上定义与主步进器同步的的步进器的额外配置分段。可以定义任何数量的以数字为后缀的分段（例如，"stepper_z1"、"stepper_z2"，等等）。

```
[stepper_z1]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   参见"stepper"部分以获取上述参数的定义。
#endstop_pin:
#   如果为附加步进电机定义了endstop_pin，则步进电机将进行
#   归位，直到触发终点开关。否则，步进电机将进行归位，
#   直到触发主步进电机的轴上的终点开关。
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

Support for cartesian, generic_cartesian and hybrid_corexy/z printers with dual carriages on a single axis. The carriage mode can be set via the SET_DUAL_CARRIAGE extended g-code command. For example, "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation. Note that during G28 homing, typically the primary carriage is homed first followed by the carriage defined in the `[dual_carriage]` config section. However, the `[dual_carriage]` carriage will be homed first if both carriages home in a positive direction and the [dual_carriage] carriage has a `position_endstop` greater than the primary carriage, or if both carriages home in a negative direction and the `[dual_carriage]` carriage has a `position_endstop` less than the primary carriage.

Additionally, one could use "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY" or "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR" commands to activate either copying or mirroring mode of the dual carriage, in which case it will follow the motion of the carriage 0 accordingly. These commands can be used to print two parts simultaneously - either two identical parts (in COPY mode) or mirrored parts (in MIRROR mode). Note that COPY and MIRROR modes also require appropriate configuration of the extruder on the dual carriage, which can typically be achieved with "SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=<dual_carriage_extruder>" or a similar command.

See [sample-idex.cfg](../config/sample-idex.cfg) for an example configuration with a regular Cartesian kinematic.

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

For an example of dual carriage configuration with `generic_cartesian` kinematic, see the following configuration [sample](../config/example-generic-caretesian.cfg). Please note that in this case the `[dual_carriage]` configuration deviates from the configuration described above:

```
[dual_carriage my_dc_carriage]
primary_carriage:
#   Defines the matching primary carriage of this dual carriage and
#   the corresponding IDEX axis. Valid choices are x, y, z.
#   This parameter must be provided.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carriages), the carriages proximity
#   checks will be disabled.
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

Refer to [generic cartesian](#generic-cartesian) section for more information on the regular `carriage` parameters.

Then a user must define one or more stepper motors moving the dual carriage (and other carriages as appropriate), for instance

```
[carriage x]
...

[carriage y]
...

[dual_carriage u]
primary_carriage: x
...

[stepper dc_stepper]
carriages: u-y
...
```

`[dual_carriage]` requires special configuration for the input shaper. In general, it is necessary to run input shaper calibration twice - for the `dual_carriage` and its `primary_carriage` for the axis they share. Then the input shaper can be configured as follows, assuming the example above:

```
[input_shaper]
# Intentionally empty

[delayed_gcode init_shaper]
initial_duration: 0.1
gcode:
  SET_DUAL_CARRIAGE CARRIAGE=u
  SET_INPUT_SHAPER SHAPER_TYPE_X=<dual_carriage_x_shaper> SHAPER_FREQ_X=<dual_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
  SET_DUAL_CARRIAGE CARRIAGE=x
  SET_INPUT_SHAPER SHAPER_TYPE_X=<primary_carriage_x_shaper> SHAPER_FREQ_X=<primary_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
```

Note that `SHAPER_TYPE_Y` and `SHAPER_FREQ_Y` must be the same in both commands in this case, since the same motors drive Y axis when either of the `x` and `u` carriages are active.

It is worth noting that `generic_cartesian` kinematic can support two dual carriages for X and Y axes. For reference, see for instance a [sample](../config/sample-corexyuv.cfg) of CoreXYUV configuration.

### [extruder_stepper]

支持额外和挤出机运动同步的步进电机（可以定义任意数量的带有“extruder_stepper”前缀的分段）。

更多信息请参阅[命令参考](G-Codes.md#extruder)。

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

## 自定义加热器和传感器

### [verify_heater]

加热器和温度传感器验证。默认在打印机上每个配置的加热器上启用加热器验证。使用 verify_heater 分段来覆盖默认设置。

```
[verify_heater heater_config_name]
#max_error: 120
#   报错之前最大的“累计温度偏差”
#   更小的值会导致更严格的检查，而更大的值在报错前允许更多的时间
#   具体地说，温度会每秒检查一次。
#   如果温度正在接近目标温度，内部的“错误计数”会重置。
#   否则，如果温度低于目标区间，那么计数器会增加汇报的温度与目标的差
#   当计数值超过“max_error”就会报错
#   默认值是120
#check_gain_time:
#   这个量控制着加热器初始化加热时的检查。
#   更小的值会导致更严格的检查，而更大的值在报错前允许更多的时间
#   具体地说，初始化加热时，只要加热器在时间片内（秒）升高温度，
#   错误计数会重置
#   默认值对于挤出头是20秒，热床是60秒
#hysteresis: 5
#   被认为是在目标区间内的最大温差（以摄氏度为单位）
#   这个量控制着max_error区间检测
#   很少定制这个值
#   默认是5
#heating_gain: 2
#   在check_gain_time检查中最小需要升高的温度（以摄氏度为单位）
#   很少定制这个值
#   默认是2
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
#   三个在给定温度（以摄氏度为单位）下的阻值（以欧姆为单位）
#   这三个测量值将会被用于计算热敏电阻的Steinhart-Hart系数
#   当使用Steinhart-Hart来定义热敏电阻时这三个参数必须给定
#beta:
#   或者，可以使用temperature1 resistance1和beta来定义热敏电阻参数
#   当使用beta来定义热敏电阻时这个参数必须给定
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
#   以上参数的定义请见“extruder”章节。
#gcode_id:
#   以上参数的定义请见“heater_generic”章节。
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

## 温度传感器

Klipper内置了许多类型的温度传感器的定义。这些传感器可用于任何需要温度传感器的配置分段（如`[extruder]` 或`[heater_bed]` 分段）。

### 常见热敏电阻

常见的热敏电阻。在使用这些传感器之一的加热器分段中可以使用以下参数。

```
sensor_type:
#   "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
#   "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
#   "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", 或者 "TDK NTCG104LH104JT1" 中的一个
sensor_pin:
#   连接到热敏电阻的模拟输入引脚。
#   必须提供此参数。

#pullup_resistor: 4700
#   连接到热敏电阻的上拉电阻（以欧姆为单位）。
#   默认值为4700欧姆。

#inline_resistor: 0
#   与热敏电阻并联的额外电阻（不随热量变化）的电阻（以欧姆为单位）。
#   设置这个参数的情况比较罕见。
#   默认值为0欧姆。
```

### 常见温度放大器

常见温度放大器。在使用这些传感器之一的加热器分段中可以使用以下参数。

```
sensor_type:
#   "PT100 INA826", "AD595", "AD597", "AD8494", "AD8495",
#   "AD8496", 或 "AD8497"中的一种。
sensor_pin:
#   连接到传感器的模拟输入引脚。
#   必须提供此参数。
#adc_voltage: 5.0
#   ADC比较电压（以伏特为单位）。
#   默认为5伏特。
#voltage_offset: 0
#   ADC电压偏移（以伏特为单位）。
#   默认为0。
```

### 直接连接PT1000 传感器

直接连接到控制板的 PT1000 传感器。以下参数可用于使用这些传感器之一的加热器分段。

```
sensor_type: PT1000
sensor_pin:
#   连接到传感器的模拟引脚。
#   必须提供此参数。
#pullup_resistor: 4700
#   连接到传感器的上拉电阻阻值（单位：ohm）。
#   默认为 4700 ohms。
```

### MAXxxxxx 温度传感器

MAXxxxxx 串行外设接口（SPI）温度传感器。以下参数在使用该类型传感器的加热器分段中可用。

```
sensor_type:
#   "MAX6675", "MAX31855", "MAX31856", 或者 "MAX31865" 中的一种。
sensor_pin:
#   传感器芯片的芯片选择线(cs)。
#   必须提供此参数。
#spi_speed: 4000000
#   与芯片通讯时使用的SPI速度（以hz为单位）。
#   默认值为4000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   以上参数的描述，请参阅“常见SPI设置”章节。
#tc_type: K
#tc_use_50Hz_filter: False
#tc_averaging_count: 1
#   以上参数控制MAX31856芯片的传感器参数。
#   每个参数的默认值在上述列表的参数名称旁边。
#rtd_nominal_r: 100
#rtd_reference_r: 430
#rtd_num_of_wires: 2
#rtd_use_50Hz_filter: False
#   以上参数控制MAX31865芯片的传感器参数。
#   每个参数的默认值在上述列表的参数名称旁边。
```

### BMP180/BMP280/BME280/BMP388/BME680 temperature sensor

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

### AHT10/AHT20/AHT21 温度传感器

AHT10/AHT20/AHT21 是两线接口（I2C）环境传感器。注意这些传感器不是给挤出机或者热床使用的，他们通常用来测量环境温度（C）以及相对湿度。关于如何在gcode_macro 中使用环境温度传感器可以参考[sample-macros.cfg](../config/sample-macros.cfg)。

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

### HTU21D 传感器

[adc_temperature]

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
#i2c_software_scl_pin:
#i2c_software_sda_pin:
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
#   要读取的微控制器。
#   默认为"mcu"。
#sensor_temperature1:
#sensor_adc1:
#   指定以上两个参数（以摄氏度为单位的温度和一个在0.0到1.0之间的
#   浮点ADC值）来校准微控制器的温度。这可能会提高某些芯片上报告
#   的温度准确性。获取此校准信息的一种典型方法是几小时内完全断开
#   打印机的电源（以确保它处于环境温度），然后开机并使用
#   QUERY_ADC命令获取一个ADC测量值。使用打印机上的其他温度传感
#   器来找出相应的环境温度。
#   默认情况下是使用微控制器上的工厂校准数据（如果适用）或微控制
#   器规格书中的公称值。
#   必须提供此参数。
#sensor_temperature2:
#sensor_adc2:
#   如果指定了sensor_temperature1/sensor_adc1，那么也可以指定
#   sensor_temperature2/sensor_adc2的校准数据。这样做可能会提供校
#   准的"温度斜率"信息。
#   默认情况下是使用微控制器上的工厂校准数据（如果适用）或微控
#   制器规格书中的公称值。
```

### 主机温度传感器

运行主机程序的电脑（例如树莓派）的温度。

```
sensor_type: temperature_host
#sensor_path:
#   此路径指向温度系统文件。默认为
#   "/sys/class/thermal/thermal_zone0/temp"，这是 Raspberry Pi
#   计算机上的温度系统文件。
```

### DS18B20 温度传感器

DS18B20 是一个单总线 (1-wire (w1)) 数值温度传感器。注意，这个传感器不是被设计用于热端或热床， 而是用于监测环境温度(C)。这些传感器最高量程是125 C，因此可用于例如箱体温度监测。它们也可以被当作简单的风扇/加热器控制器。DS18B20 传感器仅在“主机 mcu”上支持，例如树莓派。w1-gpio Linux 内核模块必须被安装。

```
sensor_type: DS18B20
serial_no:
#   每个1-wire 设备都有一个唯一的序列号，用于识别设备，通常格式类似
#   28-031674b175ff。
#   必须提供此参数。
#   可以使用以下 Linux 命令列出连接的 1 线设备：
#   ls /sys/bus/w1/devices/
#ds18_report_time:
#   读数之间的间隔（以秒为单位）。
#   默认值为 3.0，最小值为 1.0
#sensor_mcu：
#   读取的微控制器。必须是host_mcu
```

### Combined temperature sensor

Combined temperature sensor is a virtual temperature sensor based on several other sensors. This sensor can be used with extruders, heater_generic and heater beds.

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

## 风扇

### [fan]

打印冷却风扇。

```
[fan]
pin:
#   控制风扇的输出引脚。必须提供此参数。
#max_power: 1.0
#   引脚可以设置的最大功率（以0.0到1.0的值表示）。1.0的值允许引脚完全
#   启用，而0.5的值则最多只能启用一半的时间。此设置可用于限制风扇的总
#   功率输出（在延长时间内）。如果此值小于1.0，则风扇速度请求将在零和
#   最大功率之间进行缩放（例如，如果最大功率为.9且请求的风扇速度为80%，
#   则风扇功率将被设置为72%）。
#   默认值为1.0。
#shutdown_speed: 0
#   微控制器软件进入错误状态时的风扇速度（以0.0到1.0的值表示）。
#   默认值为0。
#cycle_time: 0.010
#   每个PWM电源周期到风扇的时间（以秒为单位）。当使用基于软件
#   的PWM时，建议此值为10毫秒或更大。
#   默认值为0.010秒。
#hardware_pwm: False
#   启用此选项以使用硬件PWM而非软件PWM。大多数风扇不适合使用
#   硬件PWM，因此除非有电气需求以非常高的速度切换，否则不建议
#   启用此功能。当使用硬件PWM时，实际的周期时间受到实现的限制，
#   可能与请求的周期时间有很大的不同。
#   默认值为False。
#kick_start_time: 0.100
#   风扇全速运行的时间（以秒为单位），当首次启用或增加超过50%时
#   （有助于使风扇开始旋转）。
#   默认值为0.100秒。
#off_below: 0.0
#   将供电给风扇的最小输入速度（以0.0到1.0的值表示）。当请求低于
#   off_below的速度时，风扇将被关闭。此设置可以用于防止风扇停滞，
#   并确保起动开始有效。
#   默认值为0.0。
#
#   每次调整max_power时，都应重新校准此设置。为校准此设置，以
#   off_below设置为0.0和风扇旋转开始。逐渐降低风扇速度，确定
#   可可靠驱动风扇且不停滞的最低输入速度。将off_below设置为对应
#   于此值的占空比（例如，12% -> 0.12）或稍高。
#tachometer_pin:
#   用于监控风扇速度的转速计输入引脚。通常需要上拉。此参数是可
#   选的。
#tachometer_ppr: 2
#   当指定了转速计引脚时，这是转速计信号每转一圈的脉冲数。对于
#   BLDC风扇，这通常是极数的一半。
#   默认值是2。
#tachometer_poll_interval: 0.0015
#   当指定了转速计引脚时，这是转速计引脚的轮询周期，以秒为单位。
#   默认值是0.0015，对于2PPR以下的10000转/分钟的风扇来说已经足够
#   快了。这个值必须小于30/(转速计_ppr*rpm)，并且有一些余量，其中
#   rpm是风扇的最大速度（以RPM为单位）。
#enable_pin:
#   可选引脚，用于使风扇供电。对于具有专用PWM输入的风扇，这可以
#   很有用。这些风扇即使在0% PWM输入下也会保持开启。在这种情况下，
#   PWM引脚可以使用，例如，可以使用接地开关的FET（标准风扇引脚）
#   来控制风扇的电源。
```

### [heater_fan]

加热器冷却风扇（可以用"heater_fan"前缀定义任意数量的分段）。"加热器风扇"是一种当其关联的加热器活跃时会启用的风扇。默认情况下，heater_fan shutdown_speed 等于 max_power。

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
#enable_pin:
#    请参阅“fan”分段，了解上述参数的描述。
#fan_speed: 1.0
#    当加热器或步进驱动器活跃时，将设置风扇速度（表示为从 0.0 到 1.0 的值）。
#    默认值为 1.0。
#idle_timeout:
#    在步进驱动器或加热器不再活跃后风扇应保持运行的时间（以秒为单位）。
#    默认值为 30 秒。
#idle_speed:
#    当步进驱动器或加热器不再活跃后并且达到 idle_timeout 之前，将设置风扇速度
#    （表示为从 0.0 到 1.0 的值）。
#    默认值为 fan_speed。
#heater:
#stepper:
#    定义与此风扇相关联的加热器/步进器的配置分段的名称。如果在此处提供了逗号分隔的
#    加热器/步进器名称列表，则当任何给定的加热器/步进器启用时，将启用该风扇。
#    默认加热器为 "extruder"，默认步进器为所有步进器。
```

### [temperature_fan]

温度触发的冷却风扇（可以定义任意数量的带有“temperature_fan”前缀的部分）。一个"temperature fan"是一个只要其相关的传感器高于设定温度就会启用的风扇。默认情况下，一个温度风扇的关闭速度等于最大功率。

更多信息请参阅[command reference](G-Codes.md#temperature_fan)。

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
#enable_pin:
#   请参阅“fan"分段，了解上述参数的描述。
```

## LEDs

### [led]

支持通过微控制器 PWM 引脚控制的 LED（和 LED 条）（可通过“led”前缀定义任意数量的分段）。有关更多信息，请参阅[命令参考](G-Codes.md#led)。

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
[neopixel 我的neopixel]
pin:
#   连接到neopixel的引脚。
#   必须提供此参数。
#chain_count:
#   菊链中 neopixel 芯片的数量。
#   默认为1（代表有一个neopixel芯片连接到了这个引脚）。
#color_order: GRB
#   设置LED硬件的RGB像素顺序（提供一个包含字母R（红），G（绿）
#   ，B（蓝）和W（白）的字符串，W是可选的）。或者也可以用一个
#   逗号分隔字符列表来描述像素顺序。
#   默认为GRB。
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#  以上参数请参阅“led”章节。
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

PCA9632 LED支持。PCA9632在FlashForge Dreamer上使用。

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

## 额外的舵机、按钮和其他引脚

### [servo]

伺服电机（可以定义任意数量的带有“servo”前缀的分段）。可以通过SET_SERVO[G代码命令](G-Codes.md#servo)控制伺服电机。例如：SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
pin:
#   控制伺服的PWM输出引脚。
#   必须提供此参数。
#maximum_servo_angle: 180
#   这个伺服可以设定的最大角度（以度为单位）。
#   默认是180度。
#minimum_pulse_width: 0.001
#   最小脉宽时间（以秒为单位）。这应该对应于0度的角度。
#   默认是0.001秒。
#maximum_pulse_width: 0.002
#   最大脉宽时间（以秒为单位）。这应该对应于maximum_servo_angle的角度。
#   默认是0.002秒。
#initial_angle:
#   初始设定的伺服角度（以度为单位）。
#   默认启动时不发送任何信号。
#initial_pulse_width:
#   初始设定的脉宽时间（以秒为单位）。（只有在未设定initial_angle时才有效）。
#   默认启动时不发送任何信号。
```

### [gcode_button]

在一个按钮被按下或放开（或当一个引脚状态发生变化时）时运行G代码。你可以使用 `QUERY_BUTTON button=my_gcode_button` 来查询按钮的状态。

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

运行时可配置的输出引脚（可以定义任意数量的带有 "output_pin "前缀的分段）。在这里配置的引脚将被设置为输出引脚，可以在运行时使用 "SET_PIN PIN=my_pin VALUE=.1 "类型的扩展[G代码命令](G-Code.md#output_pin)对其进行修改。

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

静态配置的数字输出引脚（可以定义任意数量的带有 "static_digital_output "前缀的分段）。在这里配置的引脚将在MCU配置期间被设置为GPIO输出。它们在运行时不能被改变。

```
[static_digital_output my_output_pins]
pins：
#   将被设置为GPIO输出的引脚的逗号分隔列表。引脚将被设置为高
#   电平，除非引脚名称前面有"!"。
#   必须提供这个参数。
```

### [multi_pin]

多引脚输出（可以定义任意数量的带有“multi_pin”前缀的分段）。 每个 multi_pin 输出会创建一个相应的内部引脚别名，配置中使用别名引脚时可以修改多个输出引脚的输出状态。例如，可以定义一个包含两个引脚的“[multi_pin my_fan]”对象，然后在“[fan]”部分设置“pin=multi_pin:my_fan”——在每次风扇更改时，两个输出引脚都会更新。这些别名可能不适用于步进电机引脚。

```
[multi_pin my_multi_pin]
pins:
#   与此别名关联的引脚的逗号分隔列表。
#   必须提供此参数。
```

## TMC步进驱动配置

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

通过 SPI 总线配置 TMC2660 步进电机驱动。要使用此功能，请定义一个带有 “tmc 2660” 前缀并后跟步进驱动配置分段相应名称的配置分段（例如，“[tmc2660 stepper_x]”）。

```
[tmc2660 stepper_x]
cs_pin:
#   对应于TMC2660芯片选择线的引脚。此引脚在SPI消息开始时将设置
#   为低，消息传输完成后将设置为高。
#   必须提供此参数。
#spi_speed: 4000000
#   用于与TMC2660步进驱动器通信的SPI总线频率。
#   默认为4000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见“常见SPI设置”章节。
#interpolate: True
#   如果为真，则启用步进插值（驱动器将以256微步的速度内部步进）。
#   只有当microsteps设置为16时，这才有效。插值会引入了极小的系统性位置
#   偏差 - 有关详细信息，请参见TMC_Drivers.md。
#   默认为True。
run_current:
#   驱动器在步进运动期间使用的电流量（以安培RMS为单位）。
#   必须提供此参数。
#sense_resistor:
#   电机感应电阻的阻值（以欧姆为单位）。
#   必须提供此参数。
#idle_current_percent: 100
#   当空闲超时到期时，步进驱动器将降低至run_current的百分比（您需要使用
#   [idle_timeout]配置部分设置超时）。一旦步进器需要再次移动，电流将再次
#   增加。确保将其设置为足够高的值，以便步进器不会丢失位置。在电流再次
#   增加之前也会有小的延迟，因此在步进器空闲时指令快速移动时请考虑此因素。
#   默认为100（不减少）。
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
#   在配置TMC2660芯片时设置给定参数。这可以用于设置自定义驱动器参数。每个参
#   数的默认值都在参数名称旁边的上面的列表中。请参阅TMC2660数据表了解每个参
#   数的作用以及参数组合的限制。特别注意CHOPCONF寄存器，将CHM设置为0或1
#   将导致布局更改（在这种情况下，HDEC的第一位被解释为HSTRT的MSB）。
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

## 运行时步进电机电流配置

### [ad5206]

通过SPI总线连接的静态配置的AD5206 digipot（可以定义任何数量的带有 "ad5206 "前缀的分段）。

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

通过I2C总线连接的静态配置的MCP4451 digipot（可以定义任意数量带有 "mcp4451 "前缀的分段）。

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

通过I2C总线连接的静态配置的MCP4728数模转换器（可以定义任何数量带有 "mcp4728 "前缀的分段）。

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

静态配置的MCP4018 digipot 通过两个GPIO "bit banging"引脚连接（可以定义任意数量的带有 "mcp4018 "前缀的分段）。

```
[mcp4018 my_digipot]
scl_pin:
#   SCL "时钟"引脚。
#   必须提供此参数。
sda_pin:
#   SDA "数据"引脚。
#   必须提供此参数。
wiper:
#   静态设置给定MCP4018 "wiper"的值。这通常设置为0.0到1.0之间
#   的数字，其中1.0是最高阻值，0.0是最低阻值。然而，可以用
#   'scale'参数（见下文）改变范围。
#   必须提供此参数。
#scale:
#   此参数可用于改变对'wiper'参数的解释。如果提供了此参数，
#   那么'wiper'参数应在0.0和'scale'之间。当MCP4018用于设置步进
#   电压引用时，这可能很有用。'scale'可以设置为当MCP4018处于
#   最高阻值时的等效步进电流，然后可以使用步进电机所需的电
#   流值来指定'wiper'参数。
#   默认不对'wiper'参数进行缩放。
```

## 显示屏支持

### [display]

支持一个连接到微控制器的屏幕

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

#### st7920屏幕

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

#### ssd1306和sh1106屏幕

ssd1306 和 sh1106 显示屏的配置信息。

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

支持在LCD屏幕上显示自定义数据。您可以创建任意数量的显示组和该组下的任意数量的数据项。如果[display]分段中的display_group参数设置为给定的组名，则显示屏将显示该组下的所有数据项。

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

这个功能允许在display_data 分段减少重复的定义。可以在 display_data 分段使用内置的`render()` 函数来评估一个模板。例如，如果我们定义了`[display_template my_template]` ，那么我们可以在display_data 分段使用`{ render('my_template') }` 。

这个功能也可以使用[SET_LED_TEMPLATE](G-Code.md#set_led_template)命令来连续更新LED。

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

参见[命令模板文档](Command_Templates.md#menu-templates)，了解模板渲染过程中可用的菜单属性。

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

更多信息请参阅[命令参考](G-Codes.md#filament_switch_sensor)。

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

耗材移动传感器。使用一个在耗材通过传感器时输出引脚状态会发生变化来检测耗材插入和耗尽。

更多信息请参阅[命令参考](G-Codes.md#filament_switch_sensor)。

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

## Load Cells

### [load_cell]

Load Cell. Uses an ADC sensor attached to a load cell to create a digital scale.

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

### [load_cell_probe]

Load Cell Probe. This combines the functionality of a [probe] and a [load_cell].

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
#   The delay, or 'order', of the buzz filter. This controle the number of
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

## 控制板特定硬件支持

### [sx1509]

将一个 SX1509 I2C 配置为 GPIO 扩展器。由于 I2C 通信本身的延迟，不应将 SX1509 引脚用作步进电机的 enable （启用)、step（步进）或 dir （方向）引脚或任何其他需要快速 bit-banging（位拆裂）的引脚。它们最适合用作静态或G代码控制的数字输出或硬件 pwm 引脚，例如风扇。可以使用“sx1509”前缀定义任意数量的分段。每个扩展器提供可用于打印机配置的一组 16 个引脚（sx1509_my_sx1509:PIN_0 到 sx1509_my_sx1509:PIN_15）。

请见范例配置文件[generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg)。

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

SAMD SERCOM配置，指定在一个给定的SERCOM上使用哪些引脚。可以用 "samd_sercom "前缀来定义任何数量的分段。每个SERCOM必须在使用它作为SPI或I2C外围设备之前进行配置。将这个配置分段必须在任何其他使用SPI或I2C总线的分段之上。

```
[samd_sercom my_sercom]
sercom:
#   在微控制器中配置的sercom总线的名称。可用的名称是 "sercom0"、
#   "sercom1"，等等。
#   必须提供此参数。
tx_pin:
#   用于SPI通信的MOSI引脚，或用于I2C通讯的SDA（数据）引脚。
#   该引脚必须有一个用于给定的SERCOM外围设备的有效pinmux配置。
#   必须提供此参数。
#rx_pin:
#   用于SPI通信的MISO引脚。该引脚不用于I2C通信(I2C使用tx_pin来发送和接收)。
#   该引脚必须有一个用于给定的SERCOM外围设备的有效pinmux配置。
#   这个参数是可选的。
clk_pin。
#   用于SPI通信的CLK引脚，或用于I2C通信的SCL(时钟)引脚。
#   该引脚必须有一个用于给定的SERCOM外围设备的有效pinmux配置。
#   必须提供此参数。
```

### [adc_scaled]

Duet 2 Maestro 通过vref和vssa读数进行模拟缩放。定义一个adc_scaled分段来启用根据板载vref和vssa监视引脚调节的虚拟adc引脚（例如“my_name:PB0"）。虚拟引脚必须先被Duet 2 Maestro 通过vref和vssa读数进行模拟缩放。定义一个adc_scaled分段来启用根据板载vref和vssa监视引脚调节的虚拟adc引脚（例如“my_name:PB0"）。虚拟引脚必须先被定义才能用在其他配置分段中。

请见范例配置文件[generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg)。

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

Replicape支持 - 参考[beaglebone guide](Beaglebone.md)和[generic-replicape.cfg](./config/generic-replicape.cfg)

```
#   "replicape"配置分段添加了"replicape:stepper_x_enable"虚拟步进使能
#   引脚（适用于X、Y、Z、E和H的步进电机）以及"replicape:power_x"
#   PWM输出引脚（适用于热床、E、H、风扇0、风扇1，风扇2和风扇3）
#   ，然后可以在配置文件的其他地方使用。
[replicape]
revision:
#   Replicape硬件修订版本。目前只支持"B3"版本。
#   必须提供此参数。
#enable_pin: !gpio0_20
#   Replicape全局使能引脚。
#   默认值为!gpio0_20（即P9_41）。
host_mcu:
#   与Klipper "linux process" mcu实例通信的mcu配置部分的名称。
#   必须提供此参数。
#standstill_power_down: False
#   此参数控制所有步进电机的CFG6_ENN线。True将使能线设置为"打开"。
#   默认值为False。
#stepper_x_microstep_mode:
#stepper_y_microstep_mode:
#stepper_z_microstep_mode:
#stepper_e_microstep_mode:
#stepper_h_microstep_mode:
#   此参数控制给定步进电机驱动器的CFG1和CFG2引脚。可用选项包括：禁用，1，2，
#   spread2, 4, 16, spread4, spread16, stealth4和stealth16。
#   默认为禁用。
#stepper_x_current:
#stepper_y_current:
#stepper_z_current:
#stepper_e_current:
#stepper_h_current:
#   步进电机驱动器的最大电流（以Amp为单位）的配置。
#   如果步进器不处于禁用模式，必须提供此参数。
#stepper_x_chopper_off_time_high:
#stepper_y_chopper_off_time_high:
#stepper_z_chopper_off_time_high:
#stepper_e_chopper_off_time_high:
#stepper_h_chopper_off_time_high:
#   此参数控制步进电机驱动器的CFG0引脚（True设置CFG0高，False设置它低）。
#   默认为False。
#stepper_x_chopper_hysteresis_high:
#stepper_y_chopper_hysteresis_high:
#stepper_z_chopper_hysteresis_high:
#stepper_e_chopper_hysteresis_high:
#stepper_h_chopper_hysteresis_high:
#   此参数控制步进电机驱动器的CFG4引脚（True设置CFG4高，False设置它低）。
#   默认为False。
#stepper_x_chopper_blank_time_high:
#stepper_y_chopper_blank_time_high:
#stepper_z_chopper_blank_time_high:
#stepper_e_chopper_blank_time_high:
#stepper_h_chopper_blank_time_high:
#   此参数控制步进电机驱动器的CFG5引脚（True设置CFG5高，False设置它低）。
#   默认为True。
```

## 其他自定义模块

### [palette2]

Palette 2 多材料支持 - 提供更紧密的集成，支持处于连接模式的 Palette 2 设备。

该模块的全部功能需要`[virtual_sdcard]`和`[pause_resume]`。

不要和 Octoprint 的 Palette 2插件一起使用这个模块，因为它们会发生冲突，造成初始化和打印失败。

If you use Octoprint and stream gcode over the serial port instead of printing from virtual_sd, then remove **M1** and **M0** from *Pausing commands* in *Settings > Serial Connection > Firmware & protocol* will prevent the need to start print on the Palette 2 and unpausing in Octoprint for your print to begin.

```
[palette2]
serial:
#   与 Palette 2 连接的串口。
#baud: 115200
#   使用的波特率。
#   默认是 115200。
#feedrate_splice: 0.8
#   拼接时使用的进给速度，
#   默认是 0.8
#feedrate_normal: 1.0
#   拼接后使用的进给速度，
#   默认是 1.0
#auto_load_speed: 2
#   自动装载时的挤出进给速度，
#   默认是 2 (mm/s)
#auto_cancel_variation: 0.1
#   当 ping 变化超过此阈值时，自动取消打印
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

## 常见的总线参数

### 常见 SPI 设置

以下参数适用于多数使用SPI总线的设备。

```
#spi_speed:
#   必须提供此参数。设备通信时使用的SPI速度（以hz为单位）。
#   默认取决于设备类型。
#spi_bus:
#   如果微控制器支持多个SPI总线，则可以在此处指定微控制器总线名称。
#   默认取决于微控制器的类型。
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   指定上述参数以使用"基于软件的SPI"。这种模式不需要微控制器硬件支持
#   （通常可以使用任何通用目的引脚）。
#   默认情况下不使用"软件spi"。
```

### 常见的I2C设置

以下参数一般适用于使用I2C总线的设备。

请注意，Klipper当前的微控制器对I2C的支持通常不能容忍线路噪声。I2C线路上的意外错误可能会导致Klipper产生运行时错误。Klipper 对错误恢复的支持在每种微控制器类型之间有所不同。通常建议只使用与微控制器位于同一印刷电路板上的I2C设备。

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
