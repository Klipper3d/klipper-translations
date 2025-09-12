# 配置参考

本文档是 Klipper 配置文件中可用选项的参考。

本文档中的描述格式化为可直接剪切并粘贴到打印机配置文件中。有关设置 Klipper 和选择初始配置文件的信息，请参阅[安装文档](Installation.md)。

## 微控制器配置

### 微控制器引脚名称格式

许多配置选项需要微控制器引脚的名称。Klipper 使用这些引脚的硬件名称，例如 `PA4`。

引脚名称前可加 `!` 表示应使用反向极性（例如，低电平触发而不是高电平触发）。

输入引脚前可加 `^` 表示应为该引脚启用硬件上拉电阻。如果微控制器支持下拉电阻，则输入引脚前可加 `~`。

注意，某些配置部分可能会“创建”额外的引脚。发生这种情况时，定义这些引脚的配置部分必须在配置文件中位于使用这些引脚的部分之前。

### [mcu]

主微控制器的配置。

```
[mcu]
serial:
#   连接到 MCU 的串行端口。如果不确定（或端口会变化），请参阅常见问题解答中的“我的串行端口在哪里？”部分。
#   使用串行端口时必须提供此参数。
#baud: 250000
#   使用的波特率。默认值为 250000。
#canbus_uuid:
#   如果使用连接到 CAN 总线的设备，则此参数设置要连接的唯一芯片标识符。
#   使用 CAN 总线进行通信时必须提供此值。
#canbus_interface:
#   如果使用连接到 CAN 总线的设备，则此参数设置要使用的 CAN 网络接口。
#   默认值为 'can0'。
#restart_method:
#   此参数控制主机用于重置微控制器的机制。
#   选项包括 'arduino'、'cheetah'、'rpi_usb' 和 'command'。
#   'arduino' 方法（切换 DTR）在 Arduino 开发板及其克隆板上很常见。
#   'cheetah' 方法是某些 Fysetc Cheetah 开发板所需的特殊方法。
#   'rpi_usb' 方法在通过 USB 供电的 Raspberry Pi 开发板上的微控制器上很有用——
#   它会短暂地禁用所有 USB 端口的电源以实现微控制器重置。
#   'command' 方法涉及向微控制器发送 Klipper 命令，使其自行重置。
#   如果微控制器通过串行端口通信，默认为 'arduino'，否则默认为 'command'。
```

### [mcu my_extra_mcu]

附加的微控制器（可以定义任意数量以 "mcu" 为前缀的部分）。附加的微控制器会引入额外的引脚，这些引脚可配置为加热器、步进电机、风扇等。例如，如果引入了 "[mcu extra_mcu]" 部分，则配置文件中的其他位置就可以使用诸如 "extra_mcu:ar9" 之类的引脚（其中 "ar9" 是给定 mcu 上的硬件引脚名称或别名）。

```
[mcu my_extra_mcu]
# 请参阅 "mcu" 部分以获取配置参数。
```

## 常见运动学设置

### [printer]

printer 部分控制打印机的高级设置。

```
[printer]
kinematics:
#   使用的打印机类型。此选项可以是：cartesian、corexy、corexz、hybrid_corexy、
#   hybrid_corexz、generic_cartesian、rotary_delta、delta、deltesian、polar、winch 或 none。
#   必须指定此参数。
max_velocity:
#   工具头的最大速度（单位：mm/s，相对于打印）。此值可在运行时使用
#   SET_VELOCITY_LIMIT 命令更改。必须指定此参数。
max_accel:
#   工具头的最大加速度（单位：mm/s^2，相对于打印）。
#   尽管此参数被描述为“最大”加速度，但在实践中，大多数加速或减速的移动
#   都会以此处指定的速率进行。此处指定的值可在运行时使用
#   SET_VELOCITY_LIMIT 命令更改。必须指定此参数。
#minimum_cruise_ratio: 0.5
#   大多数移动会加速到巡航速度，以该速度行驶，然后减速。
#   然而，一些短距离移动可能会加速然后立即减速。
#   此选项会降低这些移动的最高速度，以确保在巡航速度下始终行驶的最小距离。
#   也就是说，它强制在巡航速度下行驶的最小距离相对于总行驶距离的比例。
#   其目的是降低短锯齿形移动的最高速度（从而减少这些移动引起的打印机振动）。
#   例如，minimum_cruise_ratio 为 0.5 将确保一个独立的 1.5mm 移动的最小巡航距离为 0.75mm。
#   指定 0.0 的比例以禁用此功能（在加速和减速之间不会强制执行最小巡航距离）。
#   此处指定的值可在运行时使用 SET_VELOCITY_LIMIT 命令更改。默认值为 0.5。
#square_corner_velocity: 5.0
#   工具头在 90 度拐角处可能行驶的最大速度（单位：mm/s）。
#   非零值可以通过在拐角处实现工具头的瞬时速度变化来减少挤出机流速的变化。
#   此值配置内部向心速度拐角算法；大于 90 度的拐角将具有更高的拐角速度，
#   而小于 90 度的拐角将具有更低的拐角速度。
#   如果设置为零，则工具头将在每个拐角处减速到零。
#   此处指定的值可在运行时使用 SET_VELOCITY_LIMIT 命令更改。默认值为 5mm/s。
```

### [stepper]

步进电机定义。不同类型的打印机（由 [printer] 配置部分中的 "kinematics" 选项指定）需要不同的步进电机名称（例如 `stepper_x` 与 `stepper_a`）。以下是常见的步进电机定义。

有关计算 `rotation_distance` 参数的信息，请参阅[旋转距离文档](Rotation_Distance.md)。有关使用多个微控制器进行归位的信息，请参阅[多 MCU 归位](Multi_MCU_Homing.md)文档。

```
[stepper_x]
step_pin:
#   步进 GPIO 引脚（高电平触发）。必须提供此参数。
dir_pin:
#   方向 GPIO 引脚（高电平表示正方向）。必须提供此参数。
enable_pin:
#   使能引脚（默认为高电平有效；使用 ! 表示低电平有效）。
#   如果未提供此参数，则步进电机驱动器必须始终处于使能状态。
rotation_distance:
#   步进电机（或指定 gear_ratio 时的最终齿轮）完整旋转一圈时轴移动的距离（单位：mm）。
#   必须提供此参数。
microsteps:
#   步进电机驱动器使用的微步数。必须提供此参数。
#full_steps_per_rotation: 200
#   步进电机完整旋转一圈的全步数。对于 1.8 度的步进电机设置为 200，
#   对于 0.9 度的步进电机设置为 400。默认值为 200。
#gear_ratio:
#   如果步进电机通过齿轮箱连接到轴，则为齿轮比。
#   例如，如果使用 5:1 的齿轮箱，可以指定 "5:1"。
#   如果轴有多个齿轮箱，可以指定以逗号分隔的齿轮比列表（例如，"57:11, 2:1"）。
#   如果指定了 gear_ratio，则 rotation_distance 指定最终齿轮完整旋转一圈时轴移动的距离。
#   默认值为不使用齿轮比。
#step_pulse_duration:
#   步进脉冲信号边沿与下一个“取消步进”信号边沿之间的最短时间。
#   这也用于设置步进脉冲与方向变化信号之间的最短时间。
#   对于配置为 UART 或 SPI 模式的 TMC 步进电机，默认值为 0.000000100（100ns），
#   对于所有其他步进电机，默认值为 0.000002（即 2us）。
endstop_pin:
#   限位开关检测引脚。如果此限位引脚位于与步进电机不同的 mcu 上，则启用“多 mcu 归位”。
#   对于笛卡尔式打印机的 X、Y 和 Z 步进电机，必须提供此参数。
#position_min: 0
#   用户可命令步进电机移动到的最小有效距离（单位：mm）。默认值为 0mm。
position_endstop:
#   限位开关的位置（单位：mm）。对于笛卡尔式打印机的 X、Y 和 Z 步进电机，必须提供此参数。
position_max:
#   用户可命令步进电机移动到的最大有效距离（单位：mm）。对于笛卡尔式打印机的 X、Y 和 Z 步进电机，必须提供此参数。
#homing_speed: 5.0
#   步进电机归位时的最大速度（单位：mm/s）。默认值为 5mm/s。
#homing_retract_dist: 5.0
#   在归位期间第二次归位前回退的距离（单位：mm）。设置为零以禁用第二次归位。默认值为 5mm。
#homing_retract_speed:
#   归位后回退移动的速度，如果此速度应与归位速度不同，则使用此参数，该参数的默认值为此参数。
#second_homing_speed:
#   执行第二次归位时步进电机的速度（单位：mm/s）。默认值为 homing_speed/2。
#homing_positive_dir:
#   如果为 true，归位将导致步进电机向正方向移动（远离零点）；如果为 false，则向零点移动。
#   最好使用默认值而不是指定此参数。如果 position_endstop 靠近 position_max 则默认为 true，如果靠近 position_min 则默认为 false。
```

### 笛卡尔运动学

有关笛卡尔运动学配置文件的示例，请参阅 [example-cartesian.cfg](../config/example-cartesian.cfg)。

此处仅描述笛卡尔打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: cartesian
max_z_velocity:
#   设置 Z 轴移动的最大速度（单位：mm/s）。此设置可用于限制 Z 步进电机的最大速度。
#   默认值为使用 max_velocity 作为 max_z_velocity。
max_z_accel:
#   设置 Z 轴移动的最大加速度（单位：mm/s^2）。它限制 Z 步进电机的加速度。
#   默认值为使用 max_accel 作为 max_z_accel。

# stepper_x 部分用于描述笛卡尔机器人中控制 X 轴的步进电机。
[stepper_x]

# stepper_y 部分用于描述笛卡尔机器人中控制 Y 轴的步进电机。
[stepper_y]

# stepper_z 部分用于描述笛卡尔机器人中控制 Z 轴的步进电机。
[stepper_z]
```

### 线性三角洲运动学

有关线性三角洲运动学配置文件的示例，请参阅 [example-delta.cfg](../config/example-delta.cfg)。有关校准的信息，请参阅[三角洲校准指南](Delta_Calibrate.md)。

此处仅描述线性三角洲打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: delta
max_z_velocity:
#   对于三角洲打印机，此参数限制带有 Z 轴移动的移动的最大速度（单位：mm/s）。
#   此设置可用于降低上下移动的最大速度（在三角洲打印机上，这些移动需要更高的步进速率）。
#   默认值为使用 max_velocity 作为 max_z_velocity。
#max_z_accel:
#   设置 Z 轴移动的最大加速度（单位：mm/s^2）。如果打印机在 XY 移动上的加速度高于 Z 移动（例如，使用输入整形器时），则设置此参数可能有用。
#   默认值为使用 max_accel 作为 max_z_accel。
#minimum_z_position: 0
#   用户可命令机头移动到的最小 Z 位置。默认值为 0。
delta_radius:
#   由三个线性轴塔形成的水平圆的半径（单位：mm）。
#   此参数也可计算为：delta_radius = smooth_rod_offset - effector_offset - carriage_offset
#   必须提供此参数。
#print_radius:
#   有效工具头 XY 坐标的半径（单位：mm）。可使用此设置自定义工具头移动的范围检查。
#   如果在此处指定较大的值，则可能命令工具头与塔发生碰撞。
#   默认值为使用 delta_radius 作为 print_radius（通常可防止塔碰撞）。

# stepper_a 部分描述控制前左塔（210 度）的步进电机。
#   此部分还控制所有塔的归位参数（homing_speed, homing_retract_dist）。
[stepper_a]
position_endstop:
#   当喷嘴位于构建区域中心且限位开关触发时，喷嘴与床之间的距离（单位：mm）。
#   必须为 stepper_a 提供此参数；对于 stepper_b 和 stepper_c，此参数默认为 stepper_a 指定的值。
arm_length:
#   连接此塔与打印头的对角连杆的长度（单位：mm）。
#   必须为 stepper_a 提供此参数；对于 stepper_b 和 stepper_c，此参数默认为 stepper_a 指定的值。
#angle:
#   此选项指定塔的角度（单位：度）。stepper_a 的默认值为 210，stepper_b 为 330，stepper_c 为 90。

# stepper_b 部分描述控制前右塔（330 度）的步进电机。
[stepper_b]

# stepper_c 部分描述控制后塔（90 度）的步进电机。
[stepper_c]

# delta_calibrate 部分启用 DELTA_CALIBRATE 扩展 G 代码命令，可用于校准塔限位开关位置和角度。
[delta_calibrate]
radius:
#   可探测区域的半径（单位：mm）。这是要探测的喷嘴坐标的半径；
#   如果使用带有 XY 偏移的自动探针，则选择足够小的半径，以确保探针始终适合床面。
#   必须提供此参数。
#speed: 50
#   校准期间非探测移动的速度（单位：mm/s）。默认值为 50。
#horizontal_move_z: 5
#   在开始探测操作之前，机头应被命令移动到的高度（单位：mm）。默认值为 5。
```

### Deltesian 运动学

有关 Deltesian 运动学配置文件的示例，请参阅 [example-deltesian.cfg](../config/example-deltesian.cfg)。

此处仅描述 Deltesian 打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: deltesian
max_z_velocity:
#   对于 Deltesian 打印机，此参数限制带有 Z 轴移动的移动的最大速度（单位：mm/s）。
#   此设置可用于降低上下移动的最大速度（在 Deltesian 打印机上，这些移动需要更高的步进速率）。
#   默认值为使用 max_velocity 作为 max_z_velocity。
#max_z_accel:
#   设置 Z 轴移动的最大加速度（单位：mm/s^2）。如果打印机在 XY 移动上的加速度高于 Z 移动（例如，使用输入整形器时），则设置此参数可能有用。
#   默认值为使用 max_accel 作为 max_z_accel。
#minimum_z_position: 0
#   用户可命令机头移动到的最小 Z 位置。默认值为 0。
#min_angle: 5
#   这表示 Deltesian 臂相对于水平方向允许达到的最小角度（单位：度）。
#   此参数旨在限制臂完全水平，以避免意外反转 XZ 轴的风险。
#   默认值为 5。
#print_width:
#   有效工具头 X 坐标的距离（单位：mm）。可使用此设置自定义工具头移动的范围检查。
#   如果在此处指定较大的值，则可能命令工具头与塔发生碰撞。
#   此设置通常对应于床宽（单位：mm）。
#slow_ratio: 3
#   用于限制在 X 轴极端位置附近移动时的速度和加速度的比率。
#   如果垂直距离除以水平距离超过 slow_ratio 的值，则速度和加速度限制为标称值的一半。
#   如果垂直距离除以水平距离超过 slow_ratio 值的两倍，则速度和加速度限制为标称值的四分之一。
#   默认值为 3。

# stepper_left 部分用于描述控制左塔的步进电机。
#   此部分还控制所有塔的归位参数（homing_speed, homing_retract_dist）。
[stepper_left]
position_endstop:
#   当喷嘴位于构建区域中心且限位开关触发时，喷嘴与床之间的距离（单位：mm）。
#   必须为 stepper_left 提供此参数；对于 stepper_right，此参数默认为 stepper_left 指定的值。
arm_length:
#   连接塔滑块与打印头的对角连杆的长度（单位：mm）。
#   必须为 stepper_left 提供此参数；对于 stepper_right，此参数默认为 stepper_left 指定的值。
arm_x_length:
#   打印机归位时，打印头与塔之间的水平距离。
#   必须为 stepper_left 提供此参数；对于 stepper_right，此参数默认为 stepper_left 指定的值。

# stepper_right 部分用于描述控制右塔的步进电机。
[stepper_right]

# stepper_y 部分用于描述 Deltesian 机器人中控制 Y 轴的步进电机。
[stepper_y]
```

### CoreXY 运动学

有关 CoreXY（和 h-bot）运动学文件的示例，请参阅 [example-corexy.cfg](../config/example-corexy.cfg)。

此处仅描述 CoreXY 打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: corexy
max_z_velocity:
#   设置 Z 轴移动的最大速度（单位：mm/s）。此设置可用于限制 Z 步进电机的最大速度。
#   默认值为使用 max_velocity 作为 max_z_velocity。
max_z_accel:
#   设置 Z 轴移动的最大加速度（单位：mm/s^2）。它限制 Z 步进电机的加速度。
#   默认值为使用 max_accel 作为 max_z_accel。

# stepper_x 部分用于描述 X 轴以及控制 X+Y 移动的步进电机。
[stepper_x]

# stepper_y 部分用于描述 Y 轴以及控制 X-Y 移动的步进电机。
[stepper_y]

# stepper_z 部分用于描述控制 Z 轴的步进电机。
[stepper_z]
```

### CoreXZ 运动学

有关 CoreXZ 运动学配置文件的示例，请参阅 [example-corexz.cfg](../config/example-corexz.cfg)。

此处仅描述 CoreXZ 打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: corexz
max_z_velocity:
#   设置 Z 轴移动的最大速度（单位：mm/s）。默认值为使用 max_velocity 作为 max_z_velocity。
max_z_accel:
#   设置 Z 轴移动的最大加速度（单位：mm/s^2）。默认值为使用 max_accel 作为 max_z_accel。

# stepper_x 部分用于描述 X 轴以及控制 X+Z 移动的步进电机。
[stepper_x]

# stepper_y 部分用于描述控制 Y 轴的步进电机。
[stepper_y]

# stepper_z 部分用于描述 Z 轴以及控制 X-Z 移动的步进电机。
[stepper_z]
```

### 混合 CoreXY 运动学

有关混合 CoreXY 运动学配置文件的示例，请参阅 [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg)。

此运动学也称为 Markforged 运动学。

此处仅描述混合 CoreXY 打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: hybrid_corexy
max_z_velocity:
#   设置 Z 轴移动的最大速度（单位：mm/s）。默认值为使用 max_velocity 作为 max_z_velocity。
max_z_accel:
#   设置 Z 轴移动的最大加速度（单位：mm/s^2）。默认值为使用 max_accel 作为 max_z_accel。

# stepper_x 部分用于描述 X 轴以及控制 X-Y 移动的步进电机。
[stepper_x]

# stepper_y 部分用于描述控制 Y 轴的步进电机。
[stepper_y]

# stepper_z 部分用于描述控制 Z 轴的步进电机。
[stepper_z]
```

### 混合 CoreXZ 运动学

有关混合 CoreXZ 运动学配置文件的示例，请参阅 [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg)。

此运动学也称为 Markforged 运动学。

此处仅描述混合 CoreXY 打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

```
[printer]
kinematics: hybrid_corexz
max_z_velocity:
#   设置 Z 轴移动的最大速度（单位：mm/s）。默认值为使用 max_velocity 作为 max_z_velocity。
max_z_accel:
#   设置 Z 轴移动的最大加速度（单位：mm/s^2）。默认值为使用 max_accel 作为 max_z_accel。

# stepper_x 部分用于描述 X 轴以及控制 X-Z 移动的步进电机。
[stepper_x]

# stepper_y 部分用于描述控制 Y 轴的步进电机。
[stepper_y]

# stepper_z 部分用于描述控制 Z 轴的步进电机。
[stepper_z]
```

### 极坐标运动学

有关极坐标运动学配置文件的示例，请参阅 [example-polar.cfg](../config/example-polar.cfg)。

此处仅描述极坐标打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

极坐标运动学仍在开发中。围绕 0, 0 位置的移动已知无法正常工作。

```
[printer]
kinematics: polar
max_z_velocity:
#   设置 Z 轴移动的最大速度（单位：mm/s）。此设置可用于限制 Z 步进电机的最大速度。
#   默认值为使用 max_velocity 作为 max_z_velocity。
max_z_accel:
#   设置 Z 轴移动的最大加速度（单位：mm/s^2）。它限制 Z 步进电机的加速度。
#   默认值为使用 max_accel 作为 max_z_accel。

# stepper_bed 部分用于描述控制床的步进电机。
[stepper_bed]
gear_ratio:
#   必须指定 gear_ratio，且不能指定 rotation_distance。
#   例如，如果床由 80 齿皮带轮驱动，由步进电机的 16 齿皮带轮驱动，则应指定 80:16 的齿轮比。
#   必须提供此参数。

# stepper_arm 部分用于描述控制臂上滑块的步进电机。
[stepper_arm]

# stepper_z 部分用于描述控制 Z 轴的步进电机。
[stepper_z]
```

### 旋转三角洲运动学

有关旋转三角洲运动学配置文件的示例，请参阅 [example-rotary-delta.cfg](../config/example-rotary-delta.cfg)。

此处仅描述旋转三角洲打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

旋转三角洲运动学仍在开发中。归位移动可能会超时，并且某些边界检查尚未实现。

```
[printer]
kinematics: rotary_delta
max_z_velocity:
#   对于三角洲打印机，此参数限制带有 Z 轴移动的移动的最大速度（单位：mm/s）。
#   此设置可用于降低上下移动的最大速度（在三角洲打印机上，这些移动需要更高的步进速率）。
#   默认值为使用 max_velocity 作为 max_z_velocity。
#minimum_z_position: 0
#   用户可命令机头移动到的最小 Z 位置。默认值为 0。
shoulder_radius:
#   三个肩关节形成的水平圆的半径减去效应器关节形成的圆的半径（单位：mm）。
#   此参数也可计算为：shoulder_radius = (delta_f - delta_e) / sqrt(12)
#   必须提供此参数。
shoulder_height:
#   肩关节距床的高度减去效应器工具头高度（单位：mm）。必须提供此参数。

# stepper_a 部分描述控制右后臂（30 度）的步进电机。
#   此部分还控制所有臂的归位参数（homing_speed, homing_retract_dist）。
[stepper_a]
gear_ratio:
#   必须指定 gear_ratio，且不能指定 rotation_distance。
#   例如，如果臂由 80 齿皮带轮驱动，由 16 齿皮带轮驱动，而该皮带轮又连接到由步进电机的 16 齿皮带轮驱动的 60 齿皮带轮，
#   则应指定 80:16, 60:16 的齿轮比。必须提供此参数。
position_endstop:
#   当喷嘴位于构建区域中心且限位开关触发时，喷嘴与床之间的距离（单位：mm）。
#   必须为 stepper_a 提供此参数；对于 stepper_b 和 stepper_c，此参数默认为 stepper_a 指定的值。
upper_arm_length:
#   连接“肩关节”与“肘关节”的臂的长度（单位：mm）。
#   必须为 stepper_a 提供此参数；对于 stepper_b 和 stepper_c，此参数默认为 stepper_a 指定的值。
lower_arm_length:
#   连接“肘关节”与“效应器关节”的臂的长度（单位：mm）。
#   必须为 stepper_a 提供此参数；对于 stepper_b 和 stepper_c，此参数默认为 stepper_a 指定的值。
#angle:
#   此选项指定臂的角度（单位：度）。stepper_a 的默认值为 30，stepper_b 为 150，stepper_c 为 270。

# stepper_b 部分描述控制左后臂（150 度）的步进电机。
[stepper_b]

# stepper_c 部分描述控制前臂（270 度）的步进电机。
[stepper_c]

# delta_calibrate 部分启用 DELTA_CALIBRATE 扩展 G 代码命令，可用于校准肩关节限位开关位置。
[delta_calibrate]
radius:
#   可探测区域的半径（单位：mm）。这是要探测的喷嘴坐标的半径；
#   如果使用带有 XY 偏移的自动探针，则选择足够小的半径，以确保探针始终适合床面。
#   必须提供此参数。
#speed: 50
#   校准期间非探测移动的速度（单位：mm/s）。默认值为 50。
#horizontal_move_z: 5
#   在开始探测操作之前，机头应被命令移动到的高度（单位：mm）。默认值为 5。
```

### 缆绳绞盘运动学

有关缆绳绞盘运动学配置文件的示例，请参阅 [example-winch.cfg](../config/example-winch.cfg)。

此处仅描述缆绳绞盘打印机的特定参数 - 有关可用参数，请参阅[常见运动学设置](#common-kinematic-settings)。

缆绳绞盘支持处于实验阶段。缆绳绞盘运动学未实现归位。要归位打印机，请手动发送移动命令，直到工具头位于 0, 0, 0，然后发出 `G28` 命令。

```
[printer]
kinematics: winch

# stepper_a 部分描述连接到第一个缆绳绞盘的步进电机。
#   可定义最少 3 个、最多 26 个缆绳绞盘（stepper_a 到 stepper_z），但通常定义 4 个。
[stepper_a]
rotation_distance:
#   rotation_distance 是工具头每完整旋转一步进电机一圈时向缆绳绞盘移动的标称距离（单位：mm）。
#   必须提供此参数。
anchor_x:
anchor_y:
anchor_z:
#   缆绳绞盘在笛卡尔空间中的 X、Y 和 Z 位置。必须提供这些参数。
```

### 通用笛卡尔运动学

有关通用笛卡尔运动学配置文件的示例，请参阅 [example-generic-cartesian.cfg](../config/example-generic-caretesian.cfg)。

这种打印机运动学类别允许用户相当灵活地定义任意笛卡尔式运动学。原则上，常规的笛卡尔、corexy、hybrid_corexy 也可以这样定义。然而，更重要的是，各种其他不支持的运动学，如反向 hybrid_corexy 或 corexyuv，也可以使用这种运动学来定义。

值得注意的是，通用笛卡尔运动学的定义与其它运动学类型有显著不同。它遵循以下约定：用户定义一组可以在笛卡尔轴 X、Y 和 Z 上独立移动的滑车（因此得名运动学），以及相应的限位开关，允许固件在归位期间确定滑车的位置，以及一组移动这些滑车的步进电机。`[printer]` 部分必须指定运动学和其他打印机级别设置，与常规笛卡尔运动学相同：
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

然后用户必须定义以下三个滑车：`[carriage x]`、`[carriage y]` 和 `[carriage z]`，例如
```
[carriage x]
endstop_pin:
#   限位开关检测引脚。如果此限位引脚位于移动该滑车的步进电机（s）不同的 mcu 上，
#   则启用“多 mcu 归位”。必须提供此参数。
#position_min: 0
#   用户可命令滑车移动到的最小有效距离（单位：mm）。默认值为 0mm。
position_endstop:
#   限位开关的位置（单位：mm）。必须提供此参数。
position_max:
#   用户可命令步进电机移动到的最大有效距离（单位：mm）。必须提供此参数。
#homing_speed: 5.0
#   滑车归位时的最大速度（单位：mm/s）。默认值为 5mm/s。
#homing_retract_dist: 5.0
#   在归位期间第二次归位前回退的距离（单位：mm）。设置为零以禁用第二次归位。默认值为 5mm。
#homing_retract_speed:
#   归位后回退移动的速度，如果此速度应与归位速度不同，则使用此参数，该参数的默认值为此参数。
#second_homing_speed:
#   执行第二次归位时滑车的速度（单位：mm/s）。默认值为 homing_speed/2。
#homing_positive_dir:
#   如果为 true，归位将导致滑车向正方向移动（远离零点）；如果为 false，则向零点移动。
#   最好使用默认值而不是指定此参数。如果 position_endstop 靠近 position_max 则默认为 true，如果靠近 position_min 则默认为 false。
```

之后，用户指定移动这些滑车的步进电机，例如
```
[stepper my_stepper]
carriages:
#   描述步进电机移动的滑车的字符串。所有定义的滑车都可以在此处指定，以及它们的线性组合，
#   例如 x, x+y, y-0.5*z, x-z 等。必须提供此参数。
step_pin:
dir_pin:
enable_pin:
rotation_distance:
microsteps:
#full_steps_per_rotation: 200
#gear_ratio:
#step_pulse_duration:
```
有关常规步进电机参数的更多信息，请参阅[步进电机](#stepper)部分。`carriages` 参数定义了步进电机如何影响滑车的运动。例如，`x+y` 表示步进电机在正方向移动距离 `d` 会使滑车 `x` 和 `y` 在正方向各移动距离 `d`，而 `x-0.5*y` 表示步进电机在正方向移动距离 `d` 会使滑车 `x` 在正方向移动距离 `d`，但滑车 `y` 将在负方向移动距离 `d/2`。

可以定义多个步进电机来驱动同一轴或皮带。例如，在 CoreXY AWD 设置中，两个驱动同一皮带的电机可以定义为
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
其中 `a0` 和 `a1` 步进电机有自己的控制引脚，但共享相同的 `carriages` 和相应的限位开关。

在某些情况下，用户希望每个轴有多个限位开关。此类配置的示例包括由两个独立的步进电机驱动的 Y 轴，皮带连接到 X 梁的两端，实际上 Y 轴上有两个滑车，每个都有独立的限位开关，以及每个步进电机都有自己的限位开关的多步进 Z 轴（不要与多个 Z 电机但只有一个限位开关的配置混淆）。这些配置可以通过指定带有其限位开关的额外滑车来声明：

```
[extra_carriage my_carriage]
primary_carriage:
#   此滑车对应的主滑车的名称。它也有效地定义了滑车移动的轴。
#   必须提供此参数。
endstop_pin:
#   限位开关检测引脚。必须提供此参数。
```

以及相应的步进电机，例如：
```
[extra_carriage y1]
primary_carriage: y
endstop_pin: ...

[stepper sy1]
carriages: y1
...
```
值得注意的是，`[extra_carriage]` 不定义 `position_min`、`position_max` 和 `position_endstop` 等参数，而是从指定的 `primary_carriage` 继承它们，从而与主滑车共享相同的运动范围。

有关如何配置 IDEX 设置的参考，请参阅[双滑车](#dual-carriage)部分。

### 无运动学

可以定义特殊的“none”运动学来禁用 Klipper 中的运动学支持。这对于控制非典型 3D 打印机的设备或用于调试目的可能很有用。

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   必须定义 max_velocity 和 max_accel 参数。
#   对于“none”运动学，这些值不使用。
```

## 常见挤出机和加热床支持

### [extruder]

extruder 部分用于描述喷嘴热端的加热器参数以及控制挤出机的步进电机。有关更多信息，请参阅[命令参考](G-Codes.md#extruder)。有关调谐压力推进的信息，请参阅[压力推进指南](Pressure_Advance.md)。

```
[extruder]
step_pin:
dir_pin:
enable_pin:
microsteps:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#   有关上述参数的描述，请参阅“stepper”部分。
#   如果未指定上述任何参数，则不会将步进电机与喷嘴热端关联（尽管 SYNC_EXTRUDER_MOTION 命令可以在运行时关联一个）。
nozzle_diameter:
#   喷嘴孔径（单位：mm）。必须提供此参数。
filament_diameter:
#   原丝进入挤出机时的标称直径（单位：mm）。必须提供此参数。
#max_extrude_cross_section:
#   挤出横截面（例如，挤出宽度乘以层高）的最大面积（单位：mm^2）。
#   此设置可防止在相对较小的 XY 移动期间过度挤出。
#   如果移动请求的挤出速率超过此值，将返回错误。
#   默认值为：4.0 * nozzle_diameter^2
#instantaneous_corner_velocity: 1.000
#   挤出机在两个移动连接处的最大瞬时速度变化（单位：mm/s）。默认值为 1mm/s。
#max_extrude_only_distance: 50.0
#   回抽或仅挤出移动的最大长度（单位：mm 原丝）。如果回抽或仅挤出移动请求的距离大于此值，将返回错误。默认值为 50mm。
#max_extrude_only_velocity:
#max_extrude_only_accel:
#   挤出机电机在回抽和仅挤出移动时的最大速度（单位：mm/s）和最大加速度（单位：mm/s^2）。
#   这些设置对正常打印移动没有影响。
#   如果未指定，则计算为匹配具有 4.0*nozzle_diameter^2 横截面的 XY 打印移动的限制。
#pressure_advance: 0.0
#   在挤出机加速期间推入挤出机的原丝量。在减速期间会回抽相同量的原丝。
#   以毫米每毫米/秒为单位测量。默认值为 0，禁用压力推进。
#pressure_advance_smooth_time: 0.040
#   用于计算压力推进平均挤出机速度的时间范围（单位：秒）。
#   较大的值会产生更平滑的挤出机移动。此参数不得超过 200ms。
#   仅当 pressure_advance 非零时此设置才适用。默认值为 0.040（40 毫秒）。
#
# 剩余变量描述挤出机加热器。
heater_pin:
#   控制加热器的 PWM 输出引脚。必须提供此参数。
#max_power: 1.0
#   加热器引脚可设置的最大功率（以 0.0 到 1.0 的值表示）。
#   值 1.0 允许引脚长时间完全开启，而值 0.5 允许引脚开启时间不超过一半。
#   此设置可用于限制加热器的总输出功率（长时间）。默认值为 1.0。
sensor_type:
#   传感器类型 - 常见的热敏电阻有 "EPCOS 100K B57560G104F"、"ATC Semitec 104GT-2"、
#   "ATC Semitec 104NT-4-R025H42G"、"Generic 3950"、"Honeywell 100K 135-104LAG-J01"、
#   "NTC 100K MGB18-104F39050L32"、"SliceEngineering 450" 和 "TDK NTCG104LH104JT1"。
#   有关其他传感器，请参阅“温度传感器”部分。必须提供此参数。
sensor_pin:
#   连接到传感器的模拟输入引脚。必须提供此参数。
#pullup_resistor: 4700
#   连接到热敏电阻的上拉电阻的阻值（单位：欧姆）。
#   仅当传感器为热敏电阻时此参数有效。默认值为 4700 欧姆。
#smooth_time: 1.0
#   温度测量值将被平滑的时间值（单位：秒），以减少测量噪声的影响。
#   默认值为 1 秒。
control:
#   控制算法（pid 或 watermark）。必须提供此参数。
pid_Kp:
pid_Ki:
pid_Kd:
#   PID 反馈控制系统中的比例（pid_Kp）、积分（pid_Ki）和微分（pid_Kd）设置。
#   Klipper 使用以下通用公式评估 PID 设置：
#     heater_pwm = (Kp*error + Ki*integral(error) - Kd*derivative(error)) / 255
#   其中 "error" 为 "requested_temperature - measured_temperature"，
#   而 "heater_pwm" 为请求的加热速率，0.0 为完全关闭，1.0 为完全开启。
#   考虑使用 PID_CALIBRATE 命令获取这些参数。
#   对于 PID 加热器，必须提供 pid_Kp、pid_Ki 和 pid_Kd 参数。
#max_delta: 2.0
#   对于 'watermark' 控制的加热器，这是在目标温度以上多少摄氏度时关闭加热器，
#   以及在目标温度以下多少摄氏度时重新开启加热器。默认值为 2 摄氏度。
#pwm_cycle_time: 0.100
#   加热器每个软件 PWM 周期的时间（单位：秒）。
#   除非有电气要求需要比每秒 10 次更快地切换加热器，否则不建议设置此参数。
#   默认值为 0.100 秒。
#min_extrude_temp: 170
#   允许发出挤出机移动命令的最低温度（单位：摄氏度）。默认值为 170 摄氏度。
min_temp:
max_temp:
#   加热器必须保持在的有效温度范围的最大值（单位：摄氏度）。
#   这控制微控制器代码中实现的安全功能 - 如果测得的温度超出此范围，则微控制器将进入关机状态。
#   此检查有助于检测某些加热器和传感器硬件故障。
#   设置此范围时，只需足够宽以避免合理的温度导致错误。
#   必须提供这些参数。
```

### [heater_bed]

heater_bed 部分描述加热床。它使用 "extruder" 部分中描述的相同加热器设置。

```
[heater_bed]
heater_pin:
sensor_type:
sensor_pin:
control:
min_temp:
max_temp:
#   有关上述参数的描述，请参阅“extruder”部分。
```

## 床层校准支持

### [bed_mesh]

网格床层校准。可以定义 bed_mesh 配置部分以启用基于从探测点生成的网格来偏移 Z 轴的移动变换。在使用探针归位 Z 轴时，建议在 printer.cfg 中定义一个 safe_z_home 部分，以便向打印区域中心归位。

有关更多信息，请参阅[床层网格指南](Bed_Mesh.md)和[命令参考](G-Codes.md#bed_mesh)。

视觉示例：
```
 矩形床，probe_count = 3, 3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 圆形床，round_probe_count = 5，bed_radius = r:
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
#   校准期间非探测移动的速度（单位：mm/s）。默认值为 50。
#horizontal_move_z: 5
#   在开始探测操作之前，机头应被命令移动到的高度（单位：mm）。默认值为 5。
#mesh_radius:
#   为圆形床定义要探测的网格半径。请注意，半径相对于 mesh_origin 选项指定的坐标。
#   圆形床必须提供此参数，矩形床必须省略此参数。
#mesh_origin:
#   定义圆形床网格的中心 X、Y 坐标。此坐标相对于探针的位置。
#   调整 mesh_origin 可能有助于最大化网格半径的大小。默认值为 0, 0。
#   矩形床必须省略此参数。
#mesh_min:
#   定义矩形床网格的最小 X、Y 坐标。此坐标相对于探针的位置。
#   这将是第一个探测点，最接近原点。矩形床必须提供此参数。
#mesh_max:
#   定义矩形床网格的最大 X、Y 坐标。遵循与 mesh_min 相同的原则，但这将是离床原点最远的探测点。
#   矩形床必须提供此参数。
#probe_count: 3, 3
#   对于矩形床，这是一对用逗号分隔的整数 X、Y，定义沿每个轴探测的点数。
#   也可以使用单个值，此时该值将应用于两个轴。默认值为 3, 3。
#round_probe_count: 5
#   对于圆形床，此整数值定义沿每个轴探测的最大点数。此值必须为奇数。默认值为 5。
#fade_start: 1.0
#   启用淡出时开始逐步减少 z 调整的 gcode z 位置。默认值为 1.0。
#fade_end: 0.0
#   逐步减少完成的 gcode z 位置。当此值低于 fade_start 时，淡出被禁用。
#   应注意，淡出可能会在打印的 z 轴上添加不需要的缩放。
#   如果用户希望启用淡出，建议使用 10.0 的值。默认值为 0.0，即禁用淡出。
#fade_target:
#   淡出应收敛的 z 位置。当此值设置为非零值时，它必须在网格的 z 值范围内。
#   希望收敛到 z 归位位置的用户应将其设置为 0。默认值为网格的平均 z 值。
#split_delta_z: .025
#   沿移动触发分割的 Z 差值（单位：mm）。默认值为 .025。
#move_check_distance: 5.0
#   沿移动检查 split_delta_z 的距离（单位：mm）。这也是移动可分割的最小长度。默认值为 5.0。
#mesh_pps: 2, 2
#   一对用逗号分隔的整数 X、Y，定义在每个轴的网格中每个段插值的点数。
#   “段”可以定义为每个探测点之间的空间。用户可以输入单个值，该值将应用于两个轴。
#   默认值为 2, 2。
#algorithm: lagrange
#   使用的插值算法。可以是 "lagrange" 或 "bicubic"。此选项不会影响 3x3 网格，3x3 网格强制使用拉格朗日采样。
#   默认值为 lagrange。
#bicubic_tension: .2
#   使用双三次算法时，可应用上述张力参数来改变插值的斜率量。
#   较大的数字会增加斜率，从而在网格中产生更多的曲率。默认值为 .2。
#zero_reference_position:
#   可选的 X,Y 坐标，指定床上 Z = 0 的位置。指定此选项时，网格将被偏移，以便在此位置发生零 Z 调整。
#   默认值为无零参考。
#faulty_region_1_min:
#faulty_region_1_max:
#   定义故障区域的可选点。有关故障区域的详细信息，请参阅 docs/Bed_Mesh.md。
#   最多可添加 99 个故障区域。默认情况下不设置故障区域。
#adaptive_margin:
#   可选的边距（单位：mm），在生成自适应网格时添加到定义的打印对象使用的床区域周围。
#scan_overshoot:
#   网格外部可用的最大行程（单位：mm）。对于矩形床，这适用于 X 轴行程，对于圆形床，它适用于整个半径。
#   工具必须能够在网格外部行驶指定的数量。此值用于优化“快速扫描”期间的行驶路径。
#   可指定的最小值为 1。默认值为无过冲。
```

### [bed_tilt]

床倾斜补偿。可以定义 bed_tilt 配置部分以启用考虑倾斜床的移动变换。注意，bed_mesh 和 bed_tilt 不兼容；两者不能同时定义。

有关更多信息，请参阅[命令参考](G-Codes.md#bed_tilt)。

```
[bed_tilt]
#x_adjust: 0
#   为每个移动的 Z 高度添加到 X 轴每毫米的量。默认值为 0。
#y_adjust: 0
#   为每个移动的 Z 高度添加到 Y 轴每毫米的量。默认值为 0。
#z_adjust: 0
#   当喷嘴名义上位于 0, 0 时，添加到 Z 高度的量。默认值为 0。
# 剩余参数控制 BED_TILT_CALIBRATE 扩展 g-code 命令，可用于校准适当的 x 和 y 调整参数。
#points:
#   在 BED_TILT_CALIBRATE 命令期间应探测的 X, Y 坐标列表（每行一个；后续行缩进）。
#   指定喷嘴的坐标，并确保探针在给定的喷嘴坐标上位于床上方。
#   默认值为不启用该命令。
#speed: 50
#   校准期间非探测移动的速度（单位：mm/s）。默认值为 50。
#horizontal_move_z: 5
#   在开始探测操作之前，机头应被命令移动到的高度（单位：mm）。默认值为 5。
```

### [bed_screws]

帮助调整床调平螺丝的工具。可以定义 [bed_screws] 配置部分以启用 BED_SCREWS_ADJUST g-code 命令。

有关更多信息，请参阅[调平指南](Manual_Level.md#adjusting-bed-leveling-screws)和[命令参考](G-Codes.md#bed_screws)。

```
[bed_screws]
#screw1:
#   第一个床调平螺丝的X、Y坐标。这是指令喷嘴移动到的位置，该位置应直接位于床调平螺丝正上方（或尽可能接近且仍在床面上）。
#   此参数必须提供。
#screw1_name:
#   为给定螺丝指定的任意名称。当辅助脚本运行时，此名称将显示。默认值是使用基于螺丝XY位置的名称。
#screw1_fine_adjust:
#   一个X、Y坐标，用于指令喷嘴移动到该位置以精细调节床调平螺丝。默认值是不对此床调平螺丝进行精细调整。
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#   额外的床调平螺丝。至少必须定义三个螺丝。
#horizontal_move_z: 5
#   在从一个螺丝位置移动到下一个螺丝位置时，喷头应移动到的高度（单位：毫米）。默认值为5。
#probe_height: 0
#   探针在调整了床和喷嘴的热膨胀之后的高度（单位：毫米）。默认值为零。
#speed: 50
#   校准过程中非探测移动的速度（单位：毫米/秒）。默认值为50。
#probe_speed: 5
#   从horizontal_move_z位置移动到probe_height位置时的速度（单位：毫米/秒）。默认值为5。
```

### [screws_tilt_adjust]

使用Z探针帮助调整床调平螺丝倾斜度的工具。可以定义一个screws_tilt_adjust配置部分以启用SCREWS_TILT_CALCULATE G代码命令。

有关更多信息，请参阅
[调平指南](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)
和 [命令参考](G-Codes.md#screws_tilt_adjust)。

```
[screws_tilt_adjust]
#screw1:
#   第一个床调平螺丝的(X, Y)坐标。这是指令喷嘴移动到的位置，使探针直接位于床调平螺丝上方（或尽可能接近且仍在床面上）。
#   这是在计算中使用的基准螺丝。此参数必须提供。
#screw1_name:
#   为给定螺丝指定的任意名称。当辅助脚本运行时，此名称将显示。默认值是使用基于螺丝XY位置的名称。
#screw2:
#screw2_name:
#...
#   额外的床调平螺丝。至少必须定义两个螺丝。
#speed: 50
#   校准期间非探测移动的速度（单位：毫米/秒）。默认值为50。
#horizontal_move_z: 5
#   在开始探测操作之前，喷头应移动到的高度（单位：毫米）。默认值为5。
#screw_thread: CW-M3
#   用于床调平的螺丝类型，M3、M4或M5，以及用于调平床的旋钮旋转方向。
#   可接受的值：CW-M3、CCW-M3、CW-M4、CCW-M4、CW-M5、CCW-M5。
#   默认值是大多数打印机使用的CW-M3。顺时针旋转旋钮会减小喷嘴与床之间的间隙。
#   相反，逆时针旋转会增加间隙。
```

### [z_tilt]

多Z步进电机倾斜调整。此功能允许独立调整多个Z步进电机（参见“stepper_z1”部分），以校正倾斜。如果存在此部分，则会提供一个Z_TILT_ADJUST扩展[G代码命令](G-Codes.md#z_tilt)。

```
[z_tilt]
#z_positions:
#   X、Y坐标的列表（每行一个；后续行缩进），描述每个床“支点”的位置。“支点”是床连接到给定Z步进电机的点。
#   它使用喷嘴坐标描述（喷嘴直接位于该点上方时的X、Y位置）。第一个条目对应stepper_z，第二个对应stepper_z1，
#   第三个对应stepper_z2，依此类推。此参数必须提供。
#points:
#   应在Z_TILT_ADJUST命令期间探测的X、Y坐标列表（每行一个；后续行缩进）。指定喷嘴坐标，并确保在给定的喷嘴坐标下探针位于床面上方。
#   此参数必须提供。
#speed: 50
#   校准期间非探测移动的速度（单位：毫米/秒）。默认值为50。
#horizontal_move_z: 5
#   在开始探测操作之前，喷头应移动到的高度（单位：毫米）。默认值为5。
#retries: 0
#   如果探测点不在公差范围内，则重试的次数。
#retry_tolerance: 0
#   如果启用了重试，则当最大和最小探测点之间的差异超过retry_tolerance时重试。注意这里的最小变化单位是一个步长。
#   然而，如果你探测的点数多于步进电机数量，那么探测点范围可能会有一个固定的最小值，你可以通过观察命令输出来了解。
```

### [quad_gantry_level]

使用四个独立控制的Z电机进行移动龙门架调平。可校正移动龙门架上的双曲抛物面效应（如薯片状），因为移动龙门架更灵活。
警告：在移动床上使用此功能可能会导致不良结果。如果存在此部分，则会提供一个QUAD_GANTRY_LEVEL扩展G代码命令。
此例程假设以下Z电机配置：
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
其中x是床的0, 0点

```
[quad_gantry_level]
#gantry_corners:
#   描述龙门架两个对角的X、Y坐标的新行分隔列表。第一个条目对应Z，第二个对应Z2。此参数必须提供。
#points:
#   在QUAD_GANTRY_LEVEL命令期间应探测的四个X、Y点的新行分隔列表。位置的顺序很重要，应依次对应Z、Z1、Z2和Z3位置。
#   此参数必须提供。为了获得最大精度，请确保已配置好探针偏移。
#speed: 50
#   校准期间非探测移动的速度（单位：毫米/秒）。默认值为50。
#horizontal_move_z: 5
#   在开始探测操作之前，喷头应移动到的高度（单位：毫米）。默认值为5。
#max_adjust: 4
#   安全限制，如果请求的调整大于此值，quad_gantry_level将中止。
#retries: 0
#   如果探测点不在公差范围内，则重试的次数。
#retry_tolerance: 0
#   如果启用了重试，则当最大和最小探测点之间的差异超过retry_tolerance时重试。
```

### [skew_correction]

打印机歪斜校正。可以通过软件校正在三个平面上的打印机歪斜，即xy、xz、yz。这是通过沿一个平面打印校准模型并测量三个长度来实现的。
由于歪斜校正的性质，这些长度通过G代码设置。详情请参阅[歪斜校正](Skew_Correction.md)和[命令参考](G-Codes.md#skew_correction)。

```
[skew_correction]
```

### [z_thermal_adjust]

温度依赖的工具头Z位置调整。使用温度传感器（通常耦合到框架的垂直部分）实时补偿打印机框架热膨胀引起的垂直工具头移动。

另请参阅：[扩展G代码命令](G-Codes.md#z_thermal_adjust)。

```
[z_thermal_adjust]
#temp_coeff:
#   膨胀的温度系数，单位为毫米/摄氏度。例如，temp_coeff为0.01毫米/摄氏度意味着每当温度传感器升高1摄氏度时，Z轴就会向下移动0.01毫米。
#   默认值为0.0毫米/摄氏度，即不进行调整。
#smooth_time:
#   应用于温度传感器的平滑窗口，单位为秒。可以减少因传感器噪声导致的过量小校正引起的电机噪声。默认值为2.0秒。
#z_adjust_off_above:
#   在此Z高度以上禁用调整[毫米]。最后一次计算的校正将保持应用，直到工具头再次移动到指定Z高度以下为止。默认值为99999999.0毫米（始终开启）。
#max_z_adjustment:
#   可应用于Z轴的最大绝对调整量[毫米]。默认值为99999999.0毫米（无限制）。
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   温度传感器配置。
#   有关上述参数的定义，请参见“extruder”部分。
#gcode_id:
#   有关此参数的定义，请参见“heater_generic”部分。
```

## 自定义归位

### [safe_z_home]

安全Z轴归位。可以使用此机制在特定的X、Y坐标处对Z轴进行归位。如果例如工具头必须先移动到床中心才能对Z轴归位，则此功能非常有用。

```
[safe_z_home]
home_xy_position:
#   Z轴归位应执行的X、Y坐标（例如100, 100）。此参数必须提供。
#speed: 50.0
#   工具头移动到安全Z归位坐标的速度。默认值为50毫米/秒。
#z_hop:
#   在归位前提升Z轴的距离（单位：毫米）。这适用于任何归位命令，即使它不归位Z轴。
#   如果Z轴已经归位且当前Z位置小于z_hop，则这会将头部提升到z_hop高度。如果Z轴尚未归位，则头部将被提升z_hop距离。
#   默认值是不实施Z跳。
#z_hop_speed: 15.0
#   在归位前提升Z轴的速度（单位：毫米/秒）。默认值为15毫米/秒。
#move_to_previous: False
#   设置为True时，Z轴归位后X和Y轴将重置为其先前的位置。默认值为False。
```

### [homing_override]

归位覆盖。可以使用此机制运行一系列G代码命令，以替代在正常G代码输入中找到的G28。这在需要特定程序来归位机器的打印机上可能很有用。

```
[homing_override]
gcode:
#   用于替代在正常G代码输入中找到的G28命令的一系列G代码命令。有关G代码格式，请参见docs/Command_Templates.md。
#   如果此命令列表中包含G28，则将调用打印机的正常归位程序。此处列出的命令必须归位所有轴。此参数必须提供。
#axes: xyz
#   要覆盖的轴。例如，如果设置为“z”，则仅当归位z轴时（例如通过“G28”或“G28 Z0”命令）才会运行覆盖脚本。
#   请注意，覆盖脚本仍应归位所有轴。默认值为“xyz”，这会导致覆盖脚本替代所有G28命令。
#set_position_x:
#set_position_y:
#set_position_z:
#   如果指定，打印机将假定在运行上述G代码命令之前该轴处于指定位置。设置此值会禁用该轴的归位检查。
#   如果头部必须在调用某个轴的正常G28机制之前移动，则这可能很有用。默认值是不强制设置轴的位置。
```

### [endstop_phase]

步进电机相位调整的限位开关。要使用此功能，请定义一个以“endstop_phase”为前缀并后跟相应步进电机配置部分名称的配置部分
（例如，“[endstop_phase stepper_z]”）。此功能可以提高限位开关的准确性。添加一个裸的“[endstop_phase]”声明以启用ENDSTOP_PHASE_CALIBRATE命令。

有关更多信息，请参阅 [限位开关相位指南](Endstop_Phase.md) 和 [命令参考](G-Codes.md#endstop_phase)。

```
[endstop_phase stepper_z]
#endstop_accuracy:
#   设置限位开关的预期精度（单位：毫米）。这代表限位开关可能触发的最大误差距离
#   （例如，如果限位开关偶尔会提前100微米或延迟最多100微米触发，则将其设置为0.200，即200微米）。
#   默认值为4*rotation_distance/full_steps_per_rotation。
#trigger_phase:
#   这指定了撞击限位开关时期望的步进电机驱动器相位。它由两个数字组成，中间用正斜杠字符分隔——相位和总相位数（例如“7/64”）。
#   仅当确定每次mcu重置时步进电机驱动器都会重置时才设置此值。如果未设置此值，则步进电机相位将在第一次归位时检测，并在所有后续归位中使用该相位。
#endstop_align_zero: False
#   如果为真，则该轴的position_endstop将被有效修改，使得该轴的零位置发生在步进电机的一个整步上。
#   （如果在Z轴上使用并且打印层高是步进电机整步距离的倍数，则每一层都会发生在整步上。）默认值为False。
```

## G代码宏和事件

### [gcode_macro]

G代码宏（可以定义任意数量以“gcode_macro”为前缀的部分）。更多信息请参见
[命令模板指南](Command_Templates.md)。

```
[gcode_macro my_cmd]
#gcode:
#   执行以替代“my_cmd”的一系列G代码命令。有关G代码格式，请参见docs/Command_Templates.md。
#   此参数必须提供。
#variable_<name>:
#   可以指定任意数量以“variable_”为前缀的选项。给定的变量名将被分配给定的值（解析为Python字面量），
#   并在宏展开期间可用。例如，配置中包含“variable_fan_speed = 75”的配置可能包含G代码命令“M106 S{ fan_speed * 255 }”。
#   变量可以在运行时使用SET_GCODE_VARIABLE命令更改（详情请参见docs/Command_Templates.md）。
#   变量名不能使用大写字母。
#rename_existing:
#   此选项将导致宏覆盖现有的G代码命令，并通过此处提供的名称提供该命令的先前定义。
#   这可用于覆盖内置的G代码命令。覆盖命令时应小心，因为它可能导致复杂且意外的结果。
#   默认值是不覆盖现有的G代码命令。
#description: G-Code macro
#   这将添加一个简短的描述，用于HELP命令或使用自动补全功能时。默认为“G-Code macro”
```

### [delayed_gcode]

在设定的延迟后执行G代码。更多信息请参见
[命令模板指南](Command_Templates.md#delayed-gcodes) 和
[命令参考](G-Codes.md#delayed_gcode)。

```
[delayed_gcode my_delayed_gcode]
gcode:
#   当延迟持续时间结束时要执行的一系列G代码命令。支持G代码模板。此参数必须提供。
#initial_duration: 0.0
#   初始延迟的持续时间（单位：秒）。如果设置为非零值，delayed_gcode将在打印机进入“就绪”状态后指定的秒数执行。
#   这对于初始化程序或重复的delayed_gcode可能很有用。如果设置为0，则delayed_gcode在启动时不会执行。
#   默认值为0。
```

### [save_variables]

支持将变量保存到磁盘，以便在重启后保留。更多信息请参见
[命令模板](Command_Templates.md#save-variables-to-disk) 和
[G代码参考](G-Codes.md#save_variables)。

```
[save_variables]
filename:
#   必需 - 提供一个文件名，用于将变量保存到磁盘，例如 ~/variables.cfg
```

### [idle_timeout]

空闲超时。空闲超时是自动启用的 - 添加一个显式的idle_timeout配置部分以更改默认设置。

```
[idle_timeout]
#gcode:
#   在空闲超时时要执行的一系列G代码命令。有关G代码格式，请参见docs/Command_Templates.md。默认是运行“TURN_OFF_HEATERS”和“M84”。
#timeout: 600
#   等待空闲时间（单位：秒），然后运行上述G代码命令。默认值为600秒。
```

## 可选G代码功能

### [virtual_sdcard]

虚拟SD卡在主机机器无法很好地运行OctoPrint时可能很有用。它允许Klipper主机软件直接打印存储在主机目录中的G代码文件，使用标准的SD卡G代码命令（例如M24）。

```
[virtual_sdcard]
path:
#   主机机器上用于查找G代码文件的本地目录路径。这是一个只读目录（不支持SD卡文件写入）。
#   可以将其指向OctoPrint的上传目录（通常为 ~/.octoprint/uploads/）。此参数必须提供。
#on_error_gcode:
#   当报告错误时要执行的一系列G代码命令。有关G代码格式，请参见docs/Command_Templates.md。默认是运行TURN_OFF_HEATERS。
```

### [sdcard_loop]

一些具有阶段清除功能的打印机，例如零件弹出器或皮带打印机，可以在SD卡文件中循环播放部分。
（例如，重复打印同一个零件，或重复零件的一部分以形成链条或其他重复图案）。

有关支持的命令，请参阅 [命令参考](G-Codes.md#sdcard_loop)。有关Marlin兼容的M808 G代码宏，请参阅[sample-macros.cfg](../config/sample-macros.cfg)文件。

```
[sdcard_loop]
```

### [force_move]

支持手动移动步进电机以用于诊断目的。注意，使用此功能可能会使打印机处于无效状态 - 有关重要细节，请参阅[命令参考](G-Codes.md#force_move)。

```
[force_move]
#enable_force_move: False
#   设置为true以启用FORCE_MOVE和SET_KINEMATIC_POSITION扩展G代码命令。默认值为false。
```

### [pause_resume]

支持位置捕获和恢复的暂停/恢复功能。更多信息请参阅 [命令参考](G-Codes.md#pause_resume)。

```
[pause_resume]
#recover_velocity: 50.
#   启用捕获/恢复时，返回到捕获位置的速度（单位：毫米/秒）。默认值为50.0毫米/秒。
```

### [firmware_retraction]

固件耗材回抽。这启用了许多切片软件发出的G10（回抽）和G11（取消回抽）G代码命令。以下参数提供启动默认值，
尽管可以通过SET_RETRACTION [命令](G-Codes.md#firmware_retraction)调整这些值，从而实现每种耗材的设置和运行时调优。

```
[firmware_retraction]
#retract_length: 0
#   激活G10时回抽的耗材长度（单位：毫米），以及激活G11时取消回抽的长度（但请参见unretract_extra_length）。
#   默认值为0毫米。
#retract_speed: 20
#   回抽速度，单位为毫米/秒。默认值为20毫米/秒。
#unretract_extra_length: 0
#   取消回抽时额外添加的耗材长度（单位：毫米）。
#unretract_speed: 10
#   取消回抽速度，单位为毫米/秒。默认值为10毫米/秒。
```

### [gcode_arcs]

支持G代码弧线（G2/G3）命令。

```
[gcode_arcs]
#resolution: 1.0
#   弧线将被分割成多个线段。每个线段的长度等于上面设置的分辨率（单位：毫米）。较低的值会产生更精细的弧线，但也会给机器带来更多的工作量。
#   小于配置值的弧线将变为直线。默认值为1毫米。
```

### [respond]

启用“M118”和“RESPOND”扩展[命令](G-Codes.md#respond)。

```
[respond]
#default_type: echo
#   设置“M118”和“RESPOND”输出的默认前缀为以下之一：
#       echo: "echo: " （这是默认值）
#       command: "// "
#       error: "!! "
#default_prefix: echo:
#   直接设置默认前缀。如果存在，此值将覆盖“default_type”。
```

### [exclude_object]
在打印过程中启用支持排除或取消单个对象。

有关更多信息，请参阅 [排除对象指南](Exclude_Object.md) 和
[命令参考](G-Codes.md#excludeobject)
。有关Marlin/RepRapFirmware兼容的M486 G代码宏，请参阅
[sample-macros.cfg](../config/sample-macros.cfg) 文件。

```
[exclude_object]
```

## 共振补偿

### [input_shaper]

启用[共振补偿](Resonance_Compensation.md)。另请参阅
[命令参考](G-Codes.md#input_shaper)。

```
[input_shaper]
#shaper_freq_x: 0
#   X轴输入整形器的频率（单位：赫兹）。这通常是输入整形器应抑制的X轴共振频率。
#   对于更复杂的整形器，如2峰和3峰EI输入整形器，此参数可根据不同考虑设置。
#   默认值为0，这会禁用X轴的输入整形。
#shaper_freq_y: 0
#   Y轴输入整形器的频率（单位：赫兹）。这通常是输入整形器应抑制的Y轴共振频率。
#   对于更复杂的整形器，如2峰和3峰EI输入整形器，此参数可根据不同考虑设置。
#   默认值为0，这会禁用Y轴的输入整形。
#shaper_type: mzv
#   用于X和Y轴的输入整形器类型。支持的整形器有zv、mzv、zvd、ei、2hump_ei和3hump_ei。默认值为mzv输入整形器。
#shaper_type_x:
#shaper_type_y:
#   如果未设置shaper_type，可以使用这两个参数为X和Y轴配置不同的输入整形器。
#   支持与shaper_type参数相同的值。
#damping_ratio_x: 0.1
#damping_ratio_y: 0.1
#   输入整形器用于改善振动抑制的X和Y轴振动阻尼比。默认值为0.1，这对于大多数打印机来说是一个良好的通用值。
#   在大多数情况下，此参数无需调优且不应更改。
```

### [adxl345]

支持ADXL345加速度计。此支持允许从传感器查询加速度计测量值。这启用了ACCELEROMETER_MEASURE命令（更多信息请参见[G-Codes](G-Codes.md#adxl345)）。
默认芯片名称为“default”，但可以指定显式名称（例如，[adxl345 my_chip_name]）。

```
[adxl345]
cs_pin:
#   传感器的SPI使能引脚。此参数必须提供。
#spi_speed: 5000000
#   与芯片通信时使用的SPI速度（单位：赫兹）。默认值为5000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见“通用SPI设置”部分。
#axes_map: x, y, z
#   打印机X、Y和Z轴对应的加速度计轴。如果加速度计安装方向与打印机方向不匹配，这可能很有用。
#   例如，可以将其设置为“y, x, z”以交换X和Y轴。如果加速度计方向相反，也可以否定一个轴（例如“x, z, -y”）。
#   默认值为“x, y, z”。
#rate: 3200
#   ADXL345的输出数据速率。ADXL345支持以下数据速率：3200、1600、800、400、200、100、50和25。
#   请注意，不建议将此速率从默认的3200更改，并且低于800的速率会显著影响共振测量的质量。
```

### [icm20948]

支持icm20948加速度计。

```
[icm20948]
#i2c_address:
#   默认为104 (0x68)。如果AD0为高电平，则为0x69。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   有关上述参数的描述，请参见“通用I2C设置”部分。默认“i2c_speed”为400000。
#axes_map: x, y, z
#   有关此参数的信息，请参见“adxl345”部分。
```

### [lis2dw]

支持LIS2DW加速度计。

```
[lis2dw]
#cs_pin:
#   传感器的SPI使能引脚。如果使用SPI，则必须提供此参数。
#spi_speed: 5000000
#   与芯片通信时使用的SPI速度（单位：赫兹）。默认值为5000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见“通用SPI设置”部分。
#i2c_address:
#   默认为25 (0x19)。如果SA0为高电平，则为24 (0x18)。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   有关上述参数的描述，请参见“通用I2C设置”部分。默认“i2c_speed”为400000。
#axes_map: x, y, z
#   有关此参数的信息，请参见“adxl345”部分。
```

### [lis3dh]

支持LIS3DH加速度计。

```
[lis3dh]
#cs_pin:
#   传感器的SPI使能引脚。如果使用SPI，则必须提供此参数。
#spi_speed: 5000000
#   与芯片通信时使用的SPI速度（单位：赫兹）。默认值为5000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见“通用SPI设置”部分。
#i2c_address:
#   默认为25 (0x19)。如果SA0为高电平，则为24 (0x18)。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   有关上述参数的描述，请参见“通用I2C设置”部分。默认“i2c_speed”为400000。
#axes_map: x, y, z
#   有关此参数的信息，请参见“adxl345”部分。
```

### [mpu9250]

支持MPU-9250、MPU-9255、MPU-6515、MPU-6050和MPU-6500加速度计（可以定义任意数量以“mpu9250”为前缀的部分）。

```
[mpu9250 my_accelerometer]
#i2c_address:
#   默认为104 (0x68)。如果AD0为高电平，则为0x69。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   有关上述参数的描述，请参见“通用I2C设置”部分。默认“i2c_speed”为400000。
#axes_map: x, y, z
#   有关此参数的信息，请参见“adxl345”部分。
```

### [resonance_tester]

支持共振测试和自动输入整形器校准。要使用此模块的大部分功能，必须安装额外的软件依赖项；
更多信息请参阅[测量共振](Measuring_Resonances.md)和[命令参考](G-Codes.md#resonance_tester)。
有关`max_smoothing`参数及其使用的更多信息，请参阅测量共振指南中的[最大平滑](Measuring_Resonances.md#max-smoothing)部分。

```
[resonance_tester]
#probe_points:
#   要测试共振的X、Y、Z坐标点列表（每行一个点）。至少需要一个点。确保所有点在XY平面上都有一定的安全裕度（约几厘米）。
#accel_chip:
#   用于测量的加速度计芯片名称。如果adxl345芯片定义时没有显式名称，则此参数可以直接引用它为“accel_chip: adxl345”，
#   否则还必须提供显式名称，例如“accel_chip: adxl345 my_chip_name”。必须设置此参数或接下来的两个参数之一。
#accel_chip_x:
#accel_chip_y:
#   用于每个轴测量的加速度计芯片名称。例如，在床甩动打印机上，如果两个独立的加速度计分别安装在床（用于Y轴）和工具头（用于X轴）上，则此参数可能很有用。
#   这些参数的格式与'accel_chip'参数相同。只能提供'accel_chip'或这两个参数。
#max_smoothing:
#   在整形器自动校准（使用'SHAPER_CALIBRATE'命令）期间，每个轴允许的最大输入整形器平滑度。默认情况下未指定最大平滑度。
#   有关使用此功能的更多详细信息，请参阅测量共振指南。
#move_speed: 50
#   校准期间将工具头移动到和在测试点之间移动的速度（单位：毫米/秒）。默认值为50。
#min_freq: 5
#   测试共振的最低频率。默认值为5赫兹。
#max_freq: 133.33
#   测试共振的最高频率。默认值为133.33赫兹。
#accel_per_hz: 60
#   此参数用于确定使用哪种加速度来测试特定频率：accel = accel_per_hz * freq。
#   值越高，振荡的能量越高。如果打印机上的共振过强，可以将此值设置为低于默认值。
#   然而，较低的值会使高频共振的测量精度降低。默认值为75（毫米/秒）。
#hz_per_sec: 1
#   确定测试速度。当在[min_freq, max_freq]范围内测试所有频率时，每秒频率增加hz_per_sec。
#   较小的值会使测试变慢，较大的值会降低测试的精度。默认值为1.0（赫兹/秒 == 秒^-2）。
#sweeping_accel: 400
#   慢速扫动移动的加速度。默认值为400毫米/秒^2。
#sweeping_period: 1.2
#   慢速扫动移动的周期。将此参数设置为0会禁用慢速扫动移动。避免将其设置为太小的非零值，以免污染测量结果。
#   默认值为1.2秒，这是一个良好的通用选择。
```

## 配置文件助手

### [board_pins]

板载引脚别名（可以定义任意数量以“board_pins”为前缀的部分）。使用此功能为微控制器上的引脚定义别名。

```
[board_pins my_aliases]
mcu: mcu
#   可以使用别名的微控制器的逗号分隔列表。默认值是将别名应用于主“mcu”。
aliases:
aliases_<name>:
#   为给定微控制器创建的“name=value”别名的逗号分隔列表。例如，“EXP1_1=PE6”将为“PE6”引脚创建一个“EXP1_1”别名。
#   然而，如果“value”用“<>”括起来，则“name”将被创建为保留引脚（例如，“EXP1_9=<GND>”将保留“EXP1_9”）。
#   可以指定任意数量以“aliases_”开头的选项。
```

### [include]

包含文件支持。可以从主打印机配置文件中包含其他配置文件。也可以使用通配符（例如，“configs/*.cfg”）。

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

此工具允许在配置文件中多次定义单个微控制器引脚而无需正常的错误检查。这旨在用于诊断和调试目的。
在Klipper支持多次使用同一引脚的地方不需要此部分，并且使用此覆盖可能会导致混淆和意外结果。

```
[duplicate_pin_override]
pins:
#   可以在配置文件中多次使用而无需正常错误检查的引脚的逗号分隔列表。此参数必须提供。
```

## 床探测硬件

### [probe]

Z高度探测器。可以定义此部分以启用Z高度探测硬件。启用此部分后，PROBE和QUERY_PROBE扩展[G代码命令](G-Codes.md#probe)将可用。
另请参阅[探测校准指南](Probe_Calibrate.md)。probe部分还会创建一个虚拟的“probe:z_virtual_endstop”引脚。
在使用探测器代替Z限位开关的笛卡尔式打印机上，可以将stepper_z的endstop_pin设置为此虚拟引脚。
如果使用“probe:z_virtual_endstop”，则不要在stepper_z配置部分中定义position_endstop。

```
[probe]
pin:
#   探测检测引脚。如果引脚位于与Z步进电机不同的微控制器上，则会启用“多mcu归位”。此参数必须提供。
#deactivate_on_each_sample: True
#   这决定了Klipper在执行多次探测序列时，是否在每次探测尝试之间执行停用G代码。
#   默认值为True。
#x_offset: 0.0
#   探测器与喷嘴沿x轴的距离（单位：毫米）。默认值为0。
#y_offset: 0.0
#   探测器与喷嘴沿y轴的距离（单位：毫米）。默认值为0。
z_offset:
#   探测器触发时床与喷嘴之间的距离（单位：毫米）。此参数必须提供。
#speed: 5.0
#   探测时Z轴的速度（单位：毫米/秒）。默认值为5毫米/秒。
#samples: 1
#   每个点探测的次数。探测的z值将被平均。默认值是探测1次。
#sample_retract_dist: 2.0
#   在每次采样之间提升工具头的距离（单位：毫米）。默认值为2毫米。
#lift_speed:
#   在样本之间提升探针时Z轴的速度（单位：毫米/秒）。默认值是使用与'speed'参数相同的值。
#samples_result: average
#   采样超过一次时的计算方法——“median”或“average”。默认值为average。
#samples_tolerance: 0.100
#   样本可能与其他样本相差的最大Z距离（单位：毫米）。如果超过此公差，则会报告错误或重新尝试（参见samples_tolerance_retries）。
#   默认值为0.100毫米。
#samples_tolerance_retries: 0
#   如果发现样本超过samples_tolerance，则重试的次数。在重试时，所有当前样本将被丢弃，探测尝试将重新开始。
#   如果在给定的重试次数内未获得有效的样本集，则会报告错误。默认值为零，这会导致在第一次样本超过samples_tolerance时报告错误。
#activate_gcode:
#   在每次探测尝试之前执行的一系列G代码命令。有关G代码格式，请参见docs/Command_Templates.md。
#   如果探测器需要以某种方式激活，这可能很有用。不要在此处发出任何移动工具头的命令（例如G1）。
#   默认值是不在此激活时运行任何特殊G代码命令。
#deactivate_gcode:
#   在每次探测尝试完成后执行的一系列G代码命令。有关G代码格式，请参见docs/Command_Templates.md。
#   不要在此处发出任何移动工具头的命令。默认值是不在此停用时运行任何特殊G代码命令。
```

### [bltouch]

BLTouch探针。可以定义此部分（而不是probe部分）以启用BLTouch探针。更多信息请参见[BL-Touch指南](BLTouch.md)和[命令参考](G-Codes.md#bltouch)。
也会创建一个虚拟的“probe:z_virtual_endstop”引脚（有关详细信息，请参见“probe”部分）。

```
[bltouch]
sensor_pin:
#   连接到BLTouch传感器引脚的引脚。大多数BLTouch设备需要在传感器引脚上使用上拉电阻（在引脚名称前加“^”）。
#   此参数必须提供。
control_pin:
#   连接到BLTouch控制引脚的引脚。此参数必须提供。
#pin_move_time: 0.680
#   等待BLTouch引脚移动向上或向下的时间（单位：秒）。默认值为0.680秒。
#stow_on_each_sample: True
#   这决定了Klipper在执行多次探测序列时，是否应在每次探测尝试之间命令引脚向上移动。
#   在将此设置为False之前，请阅读docs/BLTouch.md中的说明。默认值为True。
#probe_with_touch_mode: False
#   如果设置为True，则Klipper将以“touch_mode”模式进行探测。默认值为False（以“pin_down”模式探测）。
#pin_up_reports_not_triggered: True
#   如果BLTouch在成功执行“pin_up”命令后始终报告探针处于“未触发”状态，则设置此值。
#   所有真正的BLTouch设备都应为True。在将此设置为False之前，请阅读docs/BLTouch.md中的说明。默认值为True。
#pin_up_touch_mode_reports_triggered: True
#   如果BLTouch在执行“pin_up”命令后紧接着执行“touch_mode”命令时始终报告“已触发”状态，则设置此值。
#   所有真正的BLTouch设备都应为True。在将此设置为False之前，请阅读docs/BLTouch.md中的说明。默认值为True。
#set_output_mode:
#   请求BLTouch V3.0（及更高版本）上的特定传感器引脚输出模式。此设置不应在其他类型的探针上使用。
#   设置为“5V”以请求传感器引脚输出为5伏特（仅在控制器板需要5V模式且其输入信号线为5V耐受时使用）。
#   设置为“OD”以请求传感器引脚输出使用开漏模式。默认值是不请求输出模式。
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
#   有关这些参数的信息，请参见“probe”部分。
```

### [smart_effector]

Duet3d的“Smart Effector”使用力传感器实现Z探针。可以定义此部分而不是`[probe]`以启用Smart Effector特定功能。
这还启用了[runtime命令](G-Codes.md#smart_effector)以在运行时调整Smart Effector的参数。

```
[smart_effector]
pin:
#   连接到Smart Effector Z探针输出引脚（引脚5）的引脚。请注意，板上的上拉电阻通常不需要。
#   但是，如果输出引脚连接到带有上拉电阻的板引脚，则该电阻必须是高阻值（例如10K欧姆或更高）。
#   一些板在Z探针输入上有低阻值上拉电阻，这可能导致探针状态始终触发。
#   在这种情况下，请将Smart Effector连接到板上的另一个引脚。此参数是必需的。
#control_pin:
#   连接到Smart Effector控制输入引脚（引脚7）的引脚。如果提供，Smart Effector灵敏度编程命令将可用。
#probe_accel:
#   如果设置，将限制探测移动的加速度（单位：毫米/秒^2）。
#   探测移动开始时的突然大加速度可能导致虚假的探针触发，特别是如果热端很重。
#   为了防止这种情况，可能需要通过此参数降低探测移动的加速度。
#recovery_time: 0.4
#   行走移动和探测移动之间的延迟（单位：秒）。之前的快速行走移动可能导致虚假的探针触发。
#   如果未设置延迟，可能会导致“Probe triggered prior to movement”错误。值0禁用恢复延迟。
#   默认值为0.4。
#x_offset:
#y_offset:
#   应保持未设置（或设置为0）。
z_offset:
#   探针的触发高度。从-0.1（毫米）开始，并在之后使用`PROBE_CALIBRATE`命令进行调整。此参数必须提供。
#speed:
#   探测时Z轴的速度（单位：毫米/秒）。建议从20毫米/秒的探测速度开始，并根据需要调整以提高探针触发的准确性和重复性。
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#deactivate_on_each_sample:
#   有关上述参数的更多信息，请参见“probe”部分。
```

### [probe_eddy_current]

支持涡流电感探针。可以定义此部分（而不是probe部分）以启用此探针。更多信息请参见[命令参考](G-Codes.md#probe_eddy_current)。

```
[probe_eddy_current my_eddy_probe]
sensor_type: ldc1612
#   用于执行涡流测量的传感器芯片。此参数必须提供，并且必须设置为ldc1612。
#frequency:
#   LDC1612芯片的外部晶体频率（单位：赫兹）。默认值为12000000。
#intb_pin:
#   连接到ldc1612传感器INTB引脚的MCU gpio引脚（如果可用）。默认值是不使用INTB引脚。
#z_offset:
#   探测尝试应停止时喷嘴与床之间的标称距离（单位：毫米）。此参数必须提供。
#i2c_address:
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   传感器芯片的i2c设置。有关上述参数的描述，请参见“通用I2C设置”部分。
#x_offset:
#y_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   有关这些参数的信息，请参见“probe”部分。
```

### [axis_twist_compensation]

用于补偿由于X或Y龙门架扭曲导致的探测读数不准确的工具。有关症状、配置和设置的更详细信息，请参阅[轴扭曲补偿指南](Axis_Twist_Compensation.md)。

```
[axis_twist_compensation]
#speed: 50
#   校准期间非探测移动的速度（单位：毫米/秒）。默认值为50。
#horizontal_move_z: 5
#   在开始探测操作之前，喷头应移动到的高度（单位：毫米）。默认值为5。
calibrate_start_x: 20
#   定义校准的最小X坐标
#   这应该是将喷嘴定位在起始校准位置的X坐标。
calibrate_end_x: 200
#   定义校准的最大X坐标
#   这应该是将喷嘴定位在结束校准位置的X坐标。
calibrate_y: 112.5
#   定义校准的Y坐标
#   这应该是校准过程中喷嘴定位的Y坐标。建议此参数接近床的中心

# 对于Y轴扭曲补偿，请指定以下参数：
calibrate_start_y: ...
#   定义校准的最小Y坐标
#   这应该是将喷嘴定位在Y轴起始校准位置的Y坐标。如果补偿Y轴扭曲，则必须提供此参数。
calibrate_end_y: ...
#   定义校准的最大Y坐标
#   这应该是将喷嘴定位在Y轴结束校准位置的Y坐标。如果补偿Y轴扭曲，则必须提供此参数。
calibrate_x: ...
#   定义Y轴扭曲补偿的校准X坐标
#   这应该是Y轴扭曲补偿校准过程中喷嘴定位的X坐标。必须提供此参数，并建议接近床的中心。
```

## 额外的步进电机和挤出机

### [stepper_z1]

多步进电机轴。在笛卡尔式打印机上，控制给定轴的步进电机可能有额外的配置块，用于定义应与主步进电机同步运行的步进电机。可以定义任意数量的以数字1开始的配置块（例如，“stepper_z1”，“stepper_z2”等）。

```
[stepper_z1]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   上述参数的定义请参见“stepper”部分。
#endstop_pin:
#   如果为额外的步进电机定义了endstop_pin，则该步进电机将回零直到限位开关被触发。
#   否则，该步进电机将回零直到该轴的主步进电机的限位开关被触发。
```

### [extruder1]

在多挤出机打印机上，为每个额外的挤出机添加一个额外的挤出机部分。额外的挤出机部分应命名为“extruder1”，“extruder2”，“extruder3”等。有关可用参数的描述，请参见“extruder”部分。

示例配置，请参见[sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg)。

```
[extruder1]
#step_pin:
#dir_pin:
#...
#   挤出机步进电机和加热器的可用参数请参见“extruder”部分。
#shared_heater:
#   此选项已弃用，不应再指定。
```

### [dual_carriage]

支持在单个轴上具有双滑架的笛卡尔、generic_cartesian和混合型corexy/z打印机。滑架模式可以通过SET_DUAL_CARRIAGE扩展G代码命令进行设置。例如，“SET_DUAL_CARRIAGE CARRIAGE=1”命令将激活在此部分中定义的滑架（CARRIAGE=0将返回激活主滑架）。双滑架支持通常与额外的挤出机结合使用——SET_DUAL_CARRIAGE命令通常与ACTIVATE_EXTRUDER命令同时调用。确保在停用时将滑架停靠。请注意，在G28回零时，通常先对主滑架进行回零，然后对`[dual_carriage]`配置部分中定义的滑架进行回零。然而，如果两个滑架都向正方向回零且`[dual_carriage]`滑架的`position_endstop`大于主滑架，或者两个滑架都向负方向回零且`[dual_carriage]`滑架的`position_endstop`小于主滑架，则`[dual_carriage]`滑架将首先回零。

此外，可以使用“SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY”或“SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR”命令来激活双滑架的复制或镜像模式，在这种情况下，它将相应地跟随滑架0的运动。这些命令可用于同时打印两个零件——两个相同的零件（在COPY模式下）或镜像零件（在MIRROR模式下）。请注意，COPY和MIRROR模式还需要对双滑架上的挤出机进行适当的配置，这通常可以通过“SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=<dual_carriage_extruder>”或类似命令实现。

示例配置，请参见[sample-idex.cfg](../config/sample-idex.cfg)，其中包含常规笛卡尔运动学。

```
[dual_carriage]
axis:
#   此额外滑架所在的轴（x或y）。必须提供此参数。
#safe_distance:
#   双滑架与主滑架之间强制执行的最小距离（以毫米为单位）。如果执行的G代码命令将使滑架
#   之间的距离小于指定的限制，则该命令将因错误而被拒绝。如果未提供safe_distance，则将
#   根据双滑架和主滑架的position_min和position_max推断。如果设置为0（或safe_distance未设置且
#   主滑架和双滑架的position_min和position_max相同），则将禁用滑架接近检查。
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   上述参数的定义请参见“stepper”部分。
```

有关`generic_cartesian`运动学的双滑架配置示例，请参见以下配置
[sample](../config/example-generic-caretesian.cfg)。
请注意，在这种情况下，`[dual_carriage]`配置与上述描述的配置有所不同：
```
[dual_carriage my_dc_carriage]
primary_carriage:
#   定义此双滑架的匹配主滑架及相应的IDEX轴。有效选择为x，y，z。
#   必须提供此参数。
#safe_distance:
#   双滑架与主滑架之间强制执行的最小距离（以毫米为单位）。如果执行的G代码命令将使滑架
#   之间的距离小于指定的限制，则该命令将因错误而被拒绝。如果未提供safe_distance，则将
#   根据双滑架和主滑架的position_min和position_max推断。如果设置为0（或safe_distance未设置且
#   主滑架和双滑架的position_min和position_max相同），则将禁用滑架接近检查。
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
有关常规`carriage`参数的更多信息，请参见[generic cartesian](#generic-cartesian)部分。

然后，用户必须定义一个或多个移动双滑架（及其他适当滑架）的步进电机，例如
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

`[dual_carriage]`需要对输入整形器进行特殊配置。
通常，需要为`dual_carriage`及其`primary_carriage`共享的轴运行两次输入整形器校准。
然后可以按如下方式配置输入整形器，假设以上示例：
```
[input_shaper]
# 故意留空

[delayed_gcode init_shaper]
initial_duration: 0.1
gcode:
  SET_DUAL_CARRIAGE CARRIAGE=u
  SET_INPUT_SHAPER SHAPER_TYPE_X=<dual_carriage_x_shaper> SHAPER_FREQ_X=<dual_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
  SET_DUAL_CARRIAGE CARRIAGE=x
  SET_INPUT_SHAPER SHAPER_TYPE_X=<primary_carriage_x_shaper> SHAPER_FREQ_X=<primary_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
```
请注意，在此情况下，两条命令中的`SHAPER_TYPE_Y`和`SHAPER_FREQ_Y`必须相同，因为当任一`x`或`u`滑架激活时，相同的电机驱动Y轴。

值得注意的是，`generic_cartesian`运动学可以支持X轴和Y轴的两个双滑架。作为参考，请参见例如CoreXYUV配置的
[sample](../config/sample-corexyuv.cfg)。

### [extruder_stepper]

支持与挤出机运动同步的额外步进电机（可以定义任意数量以“extruder_stepper”为前缀的部分）。

有关更多信息，请参见[命令参考](G-Codes.md#extruder)。

```
[extruder_stepper my_extra_stepper]
extruder:
#   此步进电机所同步的挤出机。如果设置为空字符串，则步进电机不会与挤出机同步。
#   必须提供此参数。
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   上述参数的定义请参见“stepper”部分。
```

### [manual_stepper]

手动步进电机（可以定义任意数量以“manual_stepper”为前缀的部分）。这些步进电机由MANUAL_STEPPER g代码命令控制。例如：“MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5”。有关MANUAL_STEPPER命令的描述，请参见[G-Codes](G-Codes.md#manual_stepper)文件。这些步进电机不连接到正常的打印机运动学。

```
[manual_stepper my_stepper]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   这些参数的描述请参见“stepper”部分。
#velocity:
#   设置步进电机的默认速度（以毫米/秒为单位）。如果MANUAL_STEPPER命令未指定SPEED
#   参数，则将使用此值。默认值为5毫米/秒。
#accel:
#   设置步进电机的默认加速度（以毫米/秒²为单位）。加速度为零将导致无加速度。
#   如果MANUAL_STEPPER命令未指定ACCEL参数，则将使用此值。默认值为零。
#endstop_pin:
#   限位开关检测引脚。如果指定，则可以通过在MANUAL_STEPPER移动命令中添加STOP_ON_ENDSTOP参数
#   来执行“回零移动”。
#position_min:
#position_max:
#   步进电机可被命令移动到的最小和最大位置。如果指定，则不能命令步进电机
#   移动到给定位置之外。请注意，这些限制不会阻止使用`MANUAL_STEPPER SET_POSITION=x`命令设置任意位置。
#   默认值为不限制。
```

## 自定义加热器和传感器

### [verify_heater]

加热器和温度传感器验证。每个在打印机上配置的加热器都会自动启用加热器验证。使用verify_heater部分更改默认设置。

```
[verify_heater heater_config_name]
#max_error: 120
#   在引发错误之前允许的“累积温度误差”最大值。较小的值导致更严格的检查，较大的值允许更多时间
#   才报告错误。具体来说，温度每秒检查一次，如果接近目标温度，则内部“错误计数器”将重置；
#   否则，如果温度低于目标范围，则计数器将增加报告温度与该范围的差异量。
#   如果计数器超过此“max_error”，则引发错误。默认值为120。
#check_gain_time:
#   这控制初始加热期间的加热器验证。较小的值导致更严格的检查，较大的值允许更多时间
#   才报告错误。具体来说，在初始加热期间，只要加热器在此时间段内（以秒为单位）温度升高，
#   则内部“错误计数器”将重置。默认值对于挤出机为20秒，对于heater_bed为60秒。
#hysteresis: 5
#   被认为在目标温度范围内的最大温度差（以摄氏度为单位）。这控制max_error范围检查。
#   很少需要自定义此值。默认值为5。
#heating_gain: 2
#   加热器在check_gain_time检查期间必须增加的最小温度（以摄氏度为单位）。
#   很少需要自定义此值。默认值为2。
```

### [homing_heaters]

在回零或探针检测轴时禁用加热器的工具。

```
[homing_heaters]
#steppers:
#   逗号分隔的步进电机列表，这些步进电机应导致加热器被禁用。默认值是在任何回零/探针移动时禁用加热器。
#   典型示例：stepper_z
#heaters:
#   在回零/探针移动期间要禁用的加热器的逗号分隔列表。默认值是禁用所有加热器。
#   典型示例：extruder, heater_bed
```

### [thermistor]

自定义热敏电阻（可以定义任意数量以“thermistor”为前缀的部分）。自定义热敏电阻可以在加热器配置部分的sensor_type字段中使用。（例如，如果定义了“[thermistor my_thermistor]”部分，则在定义加热器时可以使用“sensor_type: my_thermistor”）。确保在配置文件中，热敏电阻部分位于其在加热器部分中的首次使用之前。

```
[thermistor my_thermistor]
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#temperature3:
#resistance3:
#   在给定温度（以摄氏度为单位）下的三个电阻测量值（以欧姆为单位）。
#   这三个测量值将用于计算热敏电阻的Steinhart-Hart系数。
#   当使用Steinhart-Hart定义热敏电阻时，必须提供这些参数。
#beta:
#   或者，可以定义temperature1、resistance1和beta来定义热敏电阻参数。
#   当使用“beta”定义热敏电阻时，必须提供此参数。
```

### [adc_temperature]

自定义ADC温度传感器（可以定义任意数量以“adc_temperature”为前缀的部分）。这允许定义一个自定义温度传感器，该传感器在模数转换器（ADC）引脚上测量电压，并使用一组配置的温度/电压（或温度/电阻）测量值之间的线性插值来确定温度。生成的传感器可以在加热器部分中用作sensor_type。（例如，如果定义了“[adc_temperature my_sensor]”部分，则在定义加热器时可以使用“sensor_type: my_sensor”）。确保在配置文件中，传感器部分位于其在加热器部分中的首次使用之前。

```
[adc_temperature my_sensor]
#temperature1:
#voltage1:
#temperature2:
#voltage2:
#...
#   一组用于转换温度的参考温度（以摄氏度为单位）和电压（以伏特为单位）。
#   使用此传感器的加热器部分也可以指定adc_voltage和voltage_offset参数来定义ADC电压
#   （详情请参见“常用温度放大器”部分）。必须至少提供两个测量值。
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#...
#   或者，可以指定一组用于转换温度的参考温度（以摄氏度为单位）和电阻（以欧姆为单位）。
#   使用此传感器的加热器部分也可以指定pullup_resistor参数（详情请参见“extruder”部分）。
#   必须至少提供两个测量值。
```

### [heater_generic]

通用加热器（可以定义任意数量以“heater_generic”为前缀的部分）。这些加热器的行为类似于标准加热器（挤出机、加热床）。使用SET_HEATER_TEMPERATURE命令（详情请参见[G-Codes](G-Codes.md#heaters)）设置目标温度。

```
[heater_generic my_generic_heater]
#gcode_id:
#   在M105命令中报告温度时使用的ID。必须提供此参数。
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
#   上述参数的定义请参见“extruder”部分。
```

### [temperature_sensor]

通用温度传感器。可以定义任意数量的额外温度传感器，这些传感器通过M105命令报告。

```
[temperature_sensor my_sensor]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   上述参数的定义请参见“extruder”部分。
#gcode_id:
#   此参数的定义请参见“heater_generic”部分。
```

### [temperature_probe]

报告探针线圈温度。包括基于涡流的探针对热漂移的可选校准。 `[temperature_probe]`部分可以通过对两个部分使用相同的后缀来链接到`[probe_eddy_current]`。

```
[temperature_probe my_probe]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   温度传感器配置。
#   上述参数的定义请参见“extruder”部分。
#smooth_time:
#   温度测量值将在此时间值（以秒为单位）内进行平滑，以减少测量噪声的影响。
#   默认值为2.0秒。
#gcode_id:
#   此参数的定义请参见“heater_generic”部分。
#speed:
#   校准期间xy移动的行进速度[毫米/秒]。默认值是由探针定义的速度。
#horizontal_move_z:
#   校准期间xy移动发生时距离床面的z距离[毫米]。默认值为2毫米。
#resting_z:
#   校准期间工具将停靠以加热探针线圈的距离床面的z距离[毫米]。默认值为.4毫米
#calibration_position:
#   探针漂移校准初始化时工具应移动到的X, Y, Z位置。这是第一次手动探针发生的位置。
#   如果省略，默认行为是在第一次手动探针之前不移动工具。
#calibration_bed_temp:
#   用于在探针漂移校准期间加热探针的最大安全床温（以C为单位）。当设置时，
#   校准程序将在获取第一个样本后打开床温。当校准程序完成时，床温将设置为零。
#   当省略时，默认行为是不设置床温。
#calibration_extruder_temp:
#   在漂移校准期间设置探针的挤出机温度（以C为单位）。当提供此选项时，
#   程序将等待直到达到指定温度才请求第一次手动探针。当校准程序完成时，
#   挤出机温度将设置为0。当省略时，默认行为是不设置挤出机温度。
#extruder_heating_z: 50.
#   如果设置了“calibration_extruder_temp”选项，则挤出机加热将发生的Z位置。
#   建议在距离床面一定距离处加热挤出机，以最小化其对探针线圈温度的影响。
#   默认值为50。
#max_validation_temp: 60.
#   用于验证校准的最大温度。建议为封闭式打印机设置在100至120之间的值。
#   默认值为60。
```

## 温度传感器

Klipper包含许多类型温度传感器的定义。这些传感器可用于任何需要温度传感器的配置部分（例如`[extruder]`或`[heater_bed]`部分）。

### 常用热敏电阻

常用热敏电阻。以下参数在使用这些传感器之一的加热器部分中可用。

```
sensor_type:
#   “EPCOS 100K B57560G104F”、“ATC Semitec 104GT-2”、“ATC Semitec 104NT-4-R025H42G”、
#   “Generic 3950”、“Honeywell 100K 135-104LAG-J01”、“NTC 100K MGB18-104F39050L32”、
#   “SliceEngineering 450”或“TDK NTCG104LH104JT1”之一
sensor_pin:
#   连接到热敏电阻的模拟输入引脚。必须提供此参数。
#pullup_resistor: 4700
#   连接到热敏电阻的上拉电阻的阻值（以欧姆为单位）。默认值为4700欧姆。
#inline_resistor: 0
#   与热敏电阻串联的额外（非热变）电阻的阻值（以欧姆为单位）。很少需要设置此值。
#   默认值为0欧姆。
```

### 常用温度放大器

常用温度放大器。以下参数在使用这些传感器之一的加热器部分中可用。

```
sensor_type:
#   “PT100 INA826”、“AD595”、“AD597”、“AD8494”、“AD8495”、“AD8496”或“AD8497”之一
sensor_pin:
#   连接到传感器的模拟输入引脚。必须提供此参数。
#adc_voltage: 5.0
#   ADC比较电压（以伏特为单位）。默认值为5伏特。
#voltage_offset: 0
#   ADC电压偏移（以伏特为单位）。默认值为0。
```

### 直接连接的PT1000传感器

直接连接的PT1000传感器。以下参数在使用这些传感器之一的加热器部分中可用。

```
sensor_type: PT1000
sensor_pin:
#   连接到传感器的模拟输入引脚。必须提供此参数。
#pullup_resistor: 4700
#   连接到传感器的上拉电阻的阻值（以欧姆为单位）。默认值为4700欧姆。
```

### MAXxxxxx温度传感器

MAXxxxxx串行外设接口（SPI）温度传感器。以下参数在使用这些传感器类型之一的加热器部分中可用。

```
sensor_type:
#   “MAX6675”、“MAX31855”、“MAX31856”或“MAX31865”之一
sensor_pin:
#   传感器芯片的片选线。必须提供此参数。
#spi_speed: 4000000
#   与芯片通信时使用的SPI速度（以赫兹为单位）。默认值为4000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   上述参数的描述请参见“常用SPI设置”部分。
#tc_type: K
#tc_use_50Hz_filter: False
#tc_averaging_count: 1
#   上述参数控制MAX31856芯片的传感器参数。每个参数的默认值在上面的列表中紧邻参数名称。
#rtd_nominal_r: 100
#rtd_reference_r: 430
#rtd_num_of_wires: 2
#rtd_use_50Hz_filter: False
#   上述参数控制MAX31865芯片的传感器参数。每个参数的默认值在上面的列表中紧邻参数名称。
```

### BMP180/BMP280/BME280/BMP388/BME680温度传感器

BMP180/BMP280/BME280/BMP388/BME680双线接口（I2C）环境传感器。
请注意，这些传感器不适用于挤出机和加热床，而是用于监测环境温度（C）、压力（hPa）、相对湿度，对于BME680还包括气体水平。
有关可用于报告压力和湿度以及温度的gcode_macro，请参见[sample-macros.cfg](../config/sample-macros.cfg)。

```
sensor_type: BME280
#i2c_address:
#   默认值为118 (0x76)。BMP180、BMP388和一些BME280传感器的地址为119 (0x77)。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   上述参数的描述请参见“常用I2C设置”部分。
```

### AHT10/AHT20/AHT21温度传感器

AHT10/AHT20/AHT21双线接口（I2C）环境传感器。
请注意，这些传感器不适用于挤出机和加热床，而是用于监测环境温度（C）和相对湿度。
有关可用于报告湿度以及温度的gcode_macro，请参见[sample-macros.cfg](../config/sample-macros.cfg)。

```
sensor_type: AHT10
#   AHT20和AHT21传感器也使用AHT10。
#i2c_address:
#   默认值为56 (0x38)。一些AHT10传感器通过移动电阻器可以选择使用57 (0x39)。
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   上述参数的描述请参见“常用I2C设置”部分。
#aht10_report_time:
#   读数之间的间隔（以秒为单位）。默认值为30，最小值为5
```

### HTU21D传感器

HTU21D系列双线接口（I2C）环境传感器。请注意，此传感器不适用于挤出机和加热床，而是用于监测环境温度（C）和相对湿度。有关可用于报告湿度以及温度的gcode_macro，请参见[sample-macros.cfg](../config/sample-macros.cfg)。

```
sensor_type:
#   必须是“HTU21D”、“SI7013”、“SI7020”、“SI7021”或“SHT21”
#i2c_address:
#   默认值为64 (0x40)。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   上述参数的描述请参见“常用I2C设置”部分。
#htu21d_hold_master:
#   传感器在读取时是否可以保持I2C总线。如果为True，则在读取过程中无法进行其他总线通信。
#   默认值为False。
#htu21d_resolution:
#   温度和湿度读数的分辨率。
#   有效值为：
#    'TEMP14_HUM12' -> 温度14位，湿度12位
#    'TEMP13_HUM10' -> 温度13位，湿度10位
#    'TEMP12_HUM08' -> 温度12位，湿度08位
#    'TEMP11_HUM11' -> 温度11位，湿度11位
#   默认值为："TEMP11_HUM11"
#htu21d_report_time:
#   读数之间的间隔（以秒为单位）。默认值为30
```

### SHT3X传感器

SHT3X系列双线接口（I2C）环境传感器。这些传感器的范围为-55~125 C，因此可用于例如腔室温度监测。它们也可以作为简单的风扇/加热器控制器。

```
sensor_type: SHT3X
#i2c_address:
#   默认值为68 (0x44)。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   上述参数的描述请参见“常用I2C设置”部分。
```

### LM75温度传感器

LM75/LM75A双线（I2C）连接的温度传感器。这些传感器的范围为-55~125 C，因此可用于例如腔室温度监测。它们也可以作为简单的风扇/加热器控制器。

```
sensor_type: LM75
#i2c_address:
#   默认值为72 (0x48)。正常范围为72-79 (0x48-0x4F)，地址的3个低位由芯片上的引脚配置
#   （通常通过跳线或硬连线）。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   上述参数的描述请参见“常用I2C设置”部分。
#lm75_report_time:
#   读数之间的间隔（以秒为单位）。默认值为0.8，最小值为0.5。
```

### 内置微控制器温度传感器

atsam、atsamd、stm32和rp2040微控制器包含一个内部温度传感器。可以使用“temperature_mcu”传感器来监控这些温度。

```
sensor_type: temperature_mcu
#sensor_mcu: mcu
#   要读取的微控制器。默认值为“mcu”。
#sensor_temperature1:
#sensor_adc1:
#   指定上述两个参数（摄氏度下的温度和0.0到1.0之间的浮点ADC值）来校准
#   微控制器温度。这可能会提高某些芯片上报温度的准确性。获得此校准信息的典型方法是
#   完全切断打印机电源数小时（以确保其处于环境温度），然后通电并使用QUERY_ADC命令
#   获得ADC测量值。使用打印机上的其他温度传感器找到相应的环境温度。
#   默认值是使用微控制器上的工厂校准数据（如果适用）或微控制器规格中的标称值。
#sensor_temperature2:
#sensor_adc2:
#   如果指定了sensor_temperature1/sensor_adc1，则也可以指定sensor_temperature2/sensor_adc2校准数据。
#   这样做可能会提供校准的“温度斜率”信息。默认值是使用微控制器上的工厂校准数据（如果适用）
#   或微控制器规格中的标称值。
```

### 主机温度传感器

来自运行主机软件的机器（例如树莓派）的温度。

```
sensor_type: temperature_host
#sensor_path:
#   温度系统文件的路径。默认值为
#   “/sys/class/thermal/thermal_zone0/temp”，这是树莓派计算机上的温度系统文件。
```

### DS18B20温度传感器

DS18B20是一种1线（w1）数字温度传感器。请注意，此传感器不适用于挤出机和加热床，而是用于监测环境温度（C）。这些传感器的范围高达125 C，因此可用于例如腔室温度监测。它们也可以作为简单的风扇/加热器控制器。DS18B20传感器仅在“主机mcu”（例如树莓派）上受支持。必须安装w1-gpio Linux内核模块。

```
sensor_type: DS18B20
serial_no:
#   每个1线设备都有一个用于识别设备的唯一序列号，通常格式为28-031674b175ff。
#   必须提供此参数。可以使用以下Linux命令列出连接的1线设备：
#   ls /sys/bus/w1/devices/
#ds18_report_time:
#   读数之间的间隔（以秒为单位）。默认值为3.0，最小值为1.0
#sensor_mcu:
#   要读取的微控制器。必须是host_mcu
```

### 组合温度传感器

组合温度传感器是基于多个其他传感器的虚拟温度传感器。此传感器可用于挤出机、heater_generic和加热床。

```
sensor_type: temperature_combined
#sensor_list:
#   必须提供。要组合成新“虚拟”传感器的传感器列表。
#   例如：'temperature_sensor sensor1,extruder,heater_bed'
#combination_method:
#   必须提供。用于传感器的组合方法。
#   可用选项为'max'、'min'、'mean'。
#maximum_deviation:
#   必须提供。要组合的传感器之间允许的最大偏差（例如5度）。
#   要禁用它，请使用大值（例如999.9）
```

## 风扇

### [fan]

打印冷却风扇。

```
[fan]
pin:
#   控制风扇的输出引脚。必须提供此参数。
#max_power: 1.0
#   引脚可设置的最大功率（以0.0到1.0之间的值表示）。值1.0允许引脚在延长
#   时间内完全开启，而值0.5则允许引脚开启时间不超过一半。此设置可用于限制
#   风扇的总功率输出（在延长期间）。如果此值小于1.0，则风扇速度请求将
#   在零和max_power之间缩放（例如，如果max_power为.9且请求80%的风扇速度，
#   则风扇功率将设置为72%）。默认值为1.0。
#shutdown_speed: 0
#   如果微控制器软件进入错误状态，所需风扇速度（以0.0到1.0之间的值表示）。
#   默认值为0。
#cycle_time: 0.010
#   每个PWM电源周期到风扇的时间量（以秒为单位）。当使用基于软件的PWM时，
#   建议此值为10毫秒或更大。默认值为0.010秒。
#hardware_pwm: False
#   启用此选项以使用硬件PWM而不是软件PWM。大多数风扇在使用硬件PWM时工作不佳，
#   因此除非有电气要求需要非常高速切换，否则不建议启用此选项。
#   当使用硬件PWM时，实际周期时间受实现约束，可能与请求的cycle_time显著不同。
#   默认值为False。
#kick_start_time: 0.100
#   风扇首次开启或增加超过50%时以全速运行的时间（以秒为单位）（有助于启动风扇）。
#   默认值为0.100秒。
#off_below: 0.0
#   为风扇供电的最小输入速度（以0.0到1.0之间的值表示）。当请求的速度低于off_below时，
#   风扇将关闭。此设置可用于防止风扇停转并确保启动有效。
#   默认值为0.0。
#
#   每当调整max_power时，都应重新校准此设置。
#   要校准此设置，请从off_below设置为0.0且风扇旋转开始。
#   逐渐降低风扇速度以确定可靠驱动风扇而不停转的最低输入速度。
#   将off_below设置为对应于此值的占空比（例如，12% -> 0.12）或稍高。
#tachometer_pin:
#   用于监控风扇速度的测速计输入引脚。通常需要上拉。
#   此参数是可选的。
#tachometer_ppr: 2
#   指定tachometer_pin时，这是测速计信号每转的脉冲数。
#   对于BLDC风扇，这通常是极数的一半。默认值为2。
#tachometer_poll_interval: 0.0015
#   指定tachometer_pin时，这是测速计引脚的轮询周期，以秒为单位。
#   默认值为0.0015，对于低于10000 RPM且PPR为2的风扇来说足够快。
#   这必须小于30/(tachometer_ppr*rpm)，并留有一定余量，其中rpm是风扇的最大速度（以RPM为单位）。
#enable_pin:
#   可选引脚，用于为风扇供电。这对于具有专用PWM输入的风扇很有用。
#   这些风扇在0% PWM输入时仍会保持开启。在这种情况下，可以正常使用PWM引脚，
#   并使用例如接地开关FET（标准风扇引脚）来控制风扇的电源。
```

### [heater_fan]

加热器冷却风扇（可以定义任意数量以“heater_fan”为前缀的部分）。 “加热器风扇”是在其关联的加热器激活时将启用的风扇。默认情况下，heater_fan的shutdown_speed等于max_power。

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
#   上述参数的描述请参见“fan”部分。
#heater: extruder
#   定义与此风扇关联的加热器的配置部分的名称。
#   如果在此处提供以逗号分隔的加热器名称列表，则当任何给定加热器启用时，风扇将启用。
#   默认值为“extruder”。
#heater_temp: 50.0
#   加热器必须降至其以下风扇才会禁用的温度（以摄氏度为单位）。默认值为50摄氏度。
#fan_speed: 1.0
#   当其关联的加热器启用时，风扇将设置的速度（以0.0到1.0之间的值表示）。
#   默认值为1.0
```

### [controller_fan]

控制器冷却风扇（可以定义任意数量以“controller_fan”为前缀的部分）。 “控制器风扇”是在其关联的加热器或其关联的步进驱动器激活时将启用的风扇。当达到idle_timeout时，风扇将停止，以确保在停用被监视组件后不会过热。

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
#   上述参数的描述请参见“fan”部分。
#fan_speed: 1.0
#   当加热器或步进驱动器激活时，风扇将设置的速度（以0.0到1.0之间的值表示）。
#   默认值为1.0
#idle_timeout:
#   步进驱动器或加热器激活后，风扇应继续运行的时间（以秒为单位）。
#   默认值为30秒。
#idle_speed:
#   当加热器或步进驱动器激活且在达到idle_timeout之前，风扇将设置的速度（以0.0到1.0之间的值表示）。
#   默认值为fan_speed。
#heater:
#stepper:
#   定义与此风扇关联的加热器/步进电机的配置部分的名称。
#   如果在此处提供以逗号分隔的加热器/步进电机名称列表，则当任何给定加热器/步进电机启用时，风扇将启用。
#   默认加热器为“extruder”，默认步进电机为所有步进电机。
```

### [temperature_fan]

温度触发的冷却风扇（可以定义任意数量以“temperature_fan”为前缀的部分）。 “温度风扇”是在其关联的传感器高于设定温度时将启用的风扇。默认情况下，temperature_fan的shutdown_speed等于max_power。

有关其他信息，请参见[命令参考](G-Codes.md#temperature_fan)。

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
#   上述参数的描述请参见“fan”部分。
#sensor_type:
#sensor_pin:
#control:
#max_delta:
#min_temp:
#max_temp:
#   上述参数的描述请参见“extruder”部分。
#pid_Kp:
#pid_Ki:
#pid_Kd:
#   PID反馈控制系统中的比例（pid_Kp）、积分（pid_Ki）和微分（pid_Kd）设置。
#   Klipper使用以下通用公式评估PID设置：
#     fan_pwm = max_power - (Kp*e + Ki*integral(e) - Kd*derivative(e)) / 255
#   其中“e”为“target_temperature - measured_temperature”，而“fan_pwm”为请求的风扇速率，
#   0.0为完全关闭，1.0为完全开启。当启用PID控制算法时，必须提供pid_Kp、pid_Ki和pid_Kd参数。
#pid_deriv_time: 2.0
#   使用PID控制算法时，温度测量值将在此时间值（以秒为单位）内进行平滑，以减少测量噪声的影响。
#   默认值为2秒。
#target_temp: 40.0
#   将作为目标温度的温度（以摄氏度为单位）。默认值为40度。
#max_speed: 1.0
#   当传感器温度超过设定值时，风扇将设置的速度（以0.0到1.0之间的值表示）。
#   默认值为1.0。
#min_speed: 0.3
#   PID温度风扇的最小风扇速度（以0.0到1.0之间的值表示）。
#   默认值为0.3。
#gcode_id:
#   如果设置，温度将在M105查询中使用给定ID报告。默认值是不通过M105报告温度。
```

### [fan_generic]

手动控制的风扇（可以定义任意数量以“fan_generic”为前缀的部分）。手动控制风扇的速度由SET_FAN_SPEED [gcode命令](G-Codes.md#fan_generic)设置。

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
#   上述参数的描述请参见“fan”部分。
```

## LED

### [led]

支持通过微控制器PWM引脚控制的LED（和LED灯带）（可以定义任意数量以“led”为前缀的部分）。有关更多信息，请参见[命令参考](G-Codes.md#led)。

```
[led my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
#   控制给定LED颜色的引脚。必须至少提供上述参数之一。
#cycle_time: 0.010
#   每个PWM周期的时间量（以秒为单位）。当使用基于软件的PWM时，建议此值为10毫秒或更大。
#   默认值为0.010秒。
#hardware_pwm: False
#   启用此选项以使用硬件PWM而不是软件PWM。当使用硬件PWM时，实际周期时间受实现约束，
#   可能与请求的cycle_time显著不同。默认值为False。
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   设置初始LED颜色。每个值应在0.0到1.0之间。每种颜色的默认值为0。
```

### [neopixel]

Neopixel（又称WS2812）LED支持（可以定义任意数量以“neopixel”为前缀的部分）。有关更多信息，请参见[命令参考](G-Codes.md#led)。

请注意，[linux mcu](RPi_microcontroller.md)实现目前不支持直接连接的neopixel。当前使用Linux内核接口的设计不允许此场景，因为内核GPIO接口不够快，无法提供所需的脉冲率。

```
[neopixel my_neopixel]
pin:
#   连接到neopixel的引脚。必须提供此参数。
#chain_count:
#   连接到所提供引脚的“菊花链”Neopixel芯片数量。默认值为1（表示仅连接一个Neopixel到引脚）。
#color_order: GRB
#   设置LED硬件所需的像素顺序（使用包含R、G、B、W字母的字符串，W为可选）。
#   或者，这可以是像素顺序的逗号分隔列表——每个链中的LED一个。默认值为GRB。
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   有关这些参数的信息，请参见“led”部分。
```

### [dotstar]

Dotstar（又称APA102）LED支持（可以定义任意数量以“dotstar”为前缀的部分）。有关更多信息，请参见[命令参考](G-Codes.md#led)。

```
[dotstar my_dotstar]
data_pin:
#   连接到dotstar数据线的引脚。必须提供此参数。
clock_pin:
#   连接到dotstar时钟线的引脚。必须提供此参数。
#chain_count:
#   有关此参数的信息，请参见“neopixel”部分。
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#   有关这些参数的信息，请参见“led”部分。
```

### [pca9533]

PCA9533 LED支持。PCA9533用于mightyboard。

```
[pca9533 my_pca9533]
#i2c_address: 98
#   芯片在I2C总线上使用的I2C地址。PCA9533/1使用98，PCA9533/2使用99。默认值为98。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   上述参数的描述请参见“常用I2C设置”部分。
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   有关这些参数的信息，请参见“led”部分。
```

### [pca9632]

PCA9632 LED支持。PCA9632用于FlashForge Dreamer。

```
[pca9632 my_pca9632]
#i2c_address: 98
#   芯片在I2C总线上使用的I2C地址。可以是96、97、98或99。默认值为98。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   上述参数的描述请参见“常用I2C设置”部分。
#color_order: RGBW
#   设置LED的像素顺序（使用包含R、G、B、W字母的字符串）。默认值为RGBW。
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   有关这些参数的信息，请参见“led”部分。
```

## 额外的舵机、按钮和其他引脚

### [servo]

舵机（可以定义任意数量以“servo”为前缀的配置段）。可以使用 SET_SERVO [G代码命令](G-Codes.md#servo) 来控制舵机。例如：SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
pin:
#   控制舵机的PWM输出引脚。此参数必须提供。
#maximum_servo_angle: 180
#   该舵机可设置的最大角度（以度为单位）。默认值为180度。
#minimum_pulse_width: 0.001
#   最小脉冲宽度时间（以秒为单位）。这应对应于0度的角度。默认值为0.001秒。
#maximum_pulse_width: 0.002
#   最大脉冲宽度时间（以秒为单位）。这应对应于maximum_servo_angle角度。默认值为0.002
#   秒。
#initial_angle:
#   舵机启动时的初始角度（以度为单位）。默认值是启动时不发送任何信号。
#initial_pulse_width:
#   舵机启动时的初始脉冲宽度时间（以秒为单位）。（仅当未设置initial_angle时有效。）默认值是启动时不发送任何信号。
```

### [gcode_button]

当按钮被按下或释放时（或当引脚状态改变时）执行G代码。可以使用 `QUERY_BUTTON button=my_gcode_button` 来检查按钮状态。

```
[gcode_button my_gcode_button]
pin:
#   连接按钮的引脚。此参数必须提供。
#analog_range:
#   两个以逗号分隔的电阻值（以欧姆为单位），指定按钮的最小和最大电阻范围。如果提供了analog_range，则引脚必须是模拟引脚。默认值是使用数字GPIO作为按钮。
#analog_pullup_resistor:
#   当指定了analog_range时的上拉电阻（以欧姆为单位）。默认值为4700欧姆。
#press_gcode:
#   按钮按下时要执行的G代码命令列表。支持G代码模板。此参数必须提供。
#release_gcode:
#   按钮释放时要执行的G代码命令列表。支持G代码模板。默认值是在按钮释放时不运行任何命令。
#debounce_delay:
#   在执行按钮G代码之前，用于消除按钮抖动的时间（以秒为单位）。如果在该延迟期间按钮被按下并释放，则整个按钮按下事件将被忽略。默认值为0。
```

### [output_pin]

运行时可配置的输出引脚（可以定义任意数量以“output_pin”为前缀的配置段）。在此处配置的引脚将被设置为输出引脚，并且可以使用“SET_PIN PIN=my_pin VALUE=.1”类型的扩展[G代码命令](G-Codes.md#output_pin)在运行时修改它们。

```
[output_pin my_pin]
pin:
#   要配置为输出的引脚。此参数必须提供。
#pwm: False
#   设置输出引脚是否应具备脉宽调制能力。如果为真，值字段应在0到1之间；如果为假，值字段应为0或1。默认值为False。
#value:
#   在MCU配置期间最初将引脚设置为此值。默认值为0（低电压）。
#shutdown_value:
#   在MCU关闭事件时将引脚设置为此值。默认值为0（低电压）。
#cycle_time: 0.100
#   PWM周期的持续时间（以秒为单位）。建议在使用基于软件的PWM时，此值至少为10毫秒。对于PWM引脚，默认值为0.100秒。
#hardware_pwm: False
#   启用此选项以使用硬件PWM而不是软件PWM。使用硬件PWM时，实际周期时间受实现方式限制，可能与请求的cycle_time有显著不同。默认值为False。
#scale:
#   此参数可用于改变'value'和'shutdown_value'参数对PWM引脚的解释方式。如果提供了此参数，则'value'参数应在0.0到'scale'之间。当配置控制步进电机电压参考的PWM引脚时，这可能很有用。'scale'可以设置为PWM完全启用时等效的步进电机电流，然后'value'参数可以用步进电机所需的电流值来指定。默认值是不对'value'参数进行缩放。
#maximum_mcu_duration:
#static_value:
#   这些选项已弃用，不应再指定。
```

### [pwm_tool]

能够进行高速更新的脉宽调制数字输出引脚（可以定义任意数量以“output_pin”为前缀的配置段）。在此处配置的引脚将被设置为输出引脚，并且可以使用“SET_PIN PIN=my_pin VALUE=.1”类型的扩展[G代码命令](G-Codes.md#output_pin)在运行时修改它们。

```
[pwm_tool my_tool]
pin:
#   要配置为输出的引脚。此参数必须提供。
#maximum_mcu_duration:
#   在没有来自主机的确认的情况下，非关机值可由MCU驱动的最长时间。
#   如果主机无法跟上更新，MCU将关闭并将其所有引脚设置为其各自的关机值。
#   默认值：0（禁用）
#   通常值约为5秒。
#value:
#shutdown_value:
#cycle_time: 0.100
#hardware_pwm: False
#scale:
#   有关这些参数的定义，请参见“output_pin”部分。
```

### [pwm_cycle_time]

具有动态PWM周期定时的运行时可配置输出引脚（可以定义任意数量以“pwm_cycle_time”为前缀的配置段）。在此处配置的引脚将被设置为输出引脚，并且可以使用“SET_PIN PIN=my_pin VALUE=.1 CYCLE_TIME=0.100”类型的扩展[G代码命令](G-Codes.md#pwm_cycle_time)在运行时修改它们。

```
[pwm_cycle_time my_pin]
pin:
#value:
#shutdown_value:
#cycle_time: 0.100
#scale:
#   有关这些参数的信息，请参见“output_pin”部分。
```

### [static_digital_output]

静态配置的数字输出引脚（可以定义任意数量以“static_digital_output”为前缀的配置段）。在此处配置的引脚将在MCU配置期间被设置为GPIO输出。它们在运行时无法更改。

```
[static_digital_output my_output_pins]
pins:
#   以逗号分隔的引脚列表，这些引脚将被设置为GPIO输出引脚。除非引脚名称前加“!”，否则引脚将被设置为高电平。此参数必须提供。
```

### [multi_pin]

多引脚输出（可以定义任意数量以“multi_pin”为前缀的配置段）。multi_pin输出创建一个内部引脚别名，每次设置别名引脚时都可以修改多个输出引脚。例如，可以定义一个包含两个引脚的“[multi_pin my_fan]”对象，然后在“[fan]”部分中设置“pin=multi_pin:my_fan”——每次风扇改变时，两个输出引脚都将被更新。这些别名不能用于步进电机引脚。

```
[multi_pin my_multi_pin]
pins:
#   与此别名关联的以逗号分隔的引脚列表。此参数必须提供。
```

## TMC步进驱动器配置

通过UART/SPI模式配置Trinamic步进电机驱动器。更多信息请参见[TMC驱动器指南](TMC_Drivers.md)和[命令参考](G-Codes.md#tmcxxxx)。

### [tmc2130]

通过SPI总线配置TMC2130步进电机驱动器。要使用此功能，请定义一个以“tmc2130”为前缀，后跟相应步进配置部分名称的配置段（例如，“[tmc2130 stepper_x]”）。

```
[tmc2130 stepper_x]
cs_pin:
#   对应于TMC2130芯片选择线的引脚。在SPI消息开始时，该引脚将被设置为低电平，在消息完成之后被拉高。此参数必须提供。
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见“通用SPI设置”部分。
#chain_position:
#chain_length:
#   这些参数配置SPI菊花链。这两个参数定义了步进电机在链中的位置和总链长。位置1对应于连接到MOSI信号的步进电机。
#   默认值是不使用SPI菊花链。
#interpolate: True
#   如果为真，则启用步进插值（驱动器将在内部以256微步的速率步进）。这种插值会引入微小的系统性位置偏差——详见TMC_Drivers.md。默认值为True。
run_current:
#   配置驱动器在步进电机移动期间使用的电流大小（以安培RMS为单位）。此参数必须提供。
#hold_current:
#   配置驱动器在步进电机不移动时使用的电流大小（以安培RMS为单位）。不建议设置hold_current（详见TMC_Drivers.md）。默认值是不降低电流。
#sense_resistor: 0.110
#   电机感应电阻的阻值（以欧姆为单位）。默认值为0.110欧姆。
#stealthchop_threshold: 0
#   设置“stealthChop”阈值的速度（以mm/s为单位）。设置后，当步进电机速度低于此值时，“stealthChop”模式将被启用。请注意，“无传感器归位”代码在归位操作期间可能会暂时覆盖此设置。默认值为0，即禁用“stealthChop”模式。
#coolstep_threshold:
#   设置TMC驱动器内部“CoolStep”阈值的速度（以mm/s为单位）。如果设置了此值，则当步进电机速度接近或高于此值时，coolstep功能将被启用。重要提示——如果设置了coolstep_threshold并使用了“无传感器归位”，则必须确保归位速度高于coolstep阈值！默认值是不启用coolstep功能。
#high_velocity_threshold:
#   设置TMC驱动器内部“高速”阈值（THIGH）的速度（以mm/s为单位）。这通常用于在高速时禁用“CoolStep”功能。默认值是不设置TMC“高速”阈值。
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
#   这些字段直接控制微步表寄存器。最佳波形表对每个电机都是特定的，并且可能随电流变化。最佳配置将使由步进电机非线性移动引起的打印伪影最小化。上面指定的值是驱动器使用的默认值。该值必须指定为十进制整数（不支持十六进制形式）。要计算波形表字段，请参见Trinamic网站上的tmc2130“计算表”。
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
#   在TMC2130芯片配置期间设置给定寄存器。这可用于设置自定义电机参数。每个参数的默认值在上述列表中的参数名称旁边。
#diag0_pin:
#diag1_pin:
#   连接到TMC2130芯片一个DIAG线的微控制器引脚。只能指定一个diag引脚。该引脚为“低电平有效”，因此通常以“^!”为前缀。设置此参数会创建一个“tmc2130_stepper_x:virtual_endstop”虚拟引脚，可用作步进电机的endstop_pin。这样做可以启用“无传感器归位”。（请务必也将driver_SGT设置为适当的灵敏度值。）默认值是不启用无传感器归位。
```

### [tmc2208]

通过单线UART配置TMC2208（或TMC2224）步进电机驱动器。要使用此功能，请定义一个以“tmc2208”为前缀，后跟相应步进配置部分名称的配置段（例如，“[tmc2208 stepper_x]”）。

```
[tmc2208 stepper_x]
uart_pin:
#   连接到TMC2208 PDN_UART线的引脚。此参数必须提供。
#tx_pin:
#   如果使用单独的接收和发送线路与驱动器通信，则将uart_pin设置为接收引脚，tx_pin设置为发送引脚。默认值是使用uart_pin进行读写。
#select_pins:
#   在访问tmc2208 UART之前要设置的以逗号分隔的引脚列表。这可能对配置模拟多路复用器进行UART通信有用。默认值是不配置任何引脚。
#interpolate: True
#   如果为真，则启用步进插值（驱动器将在内部以256微步的速率步进）。这种插值会引入微小的系统性位置偏差——详见TMC_Drivers.md。默认值为True。
run_current:
#   配置驱动器在步进电机移动期间使用的电流大小（以安培RMS为单位）。此参数必须提供。
#hold_current:
#   配置驱动器在步进电机不移动时使用的电流大小（以安培RMS为单位）。不建议设置hold_current（详见TMC_Drivers.md）。默认值是不降低电流。
#sense_resistor: 0.110
#   电机感应电阻的阻值（以欧姆为单位）。默认值为0.110欧姆。
#stealthchop_threshold: 0
#   设置“stealthChop”阈值的速度（以mm/s为单位）。设置后，当步进电机速度低于此值时，“stealthChop”模式将被启用。请注意，“无传感器归位”代码在归位操作期间可能会暂时覆盖此设置。默认值为0，即禁用“stealthChop”模式。
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
#   在TMC2208芯片配置期间设置给定寄存器。这可用于设置自定义电机参数。每个参数的默认值在上述列表中的参数名称旁边。
```

### [tmc2209]

通过单线UART配置TMC2209步进电机驱动器。要使用此功能，请定义一个以“tmc2209”为前缀，后跟相应步进配置部分名称的配置段（例如，“[tmc2209 stepper_x]”）。

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
#   有关这些参数的定义，请参见“tmc2208”部分。
#coolstep_threshold:
#   设置TMC驱动器内部“CoolStep”阈值的速度（以mm/s为单位）。如果设置了此值，则当步进电机速度接近或高于此值时，coolstep功能将被启用。重要提示——如果设置了coolstep_threshold并使用了“无传感器归位”，则必须确保归位速度高于coolstep阈值！默认值是不启用coolstep功能。
#uart_address:
#   TMC2209芯片用于UART消息的地址（0到3之间的整数）。当多个TMC2209芯片连接到同一UART引脚时通常使用此参数。默认值为零。
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
#   在TMC2209芯片配置期间设置给定寄存器。这可用于设置自定义电机参数。每个参数的默认值在上述列表中的参数名称旁边。
#diag_pin:
#   连接到TMC2209芯片DIAG线的微控制器引脚。该引脚通常以“^”为前缀以启用上拉。设置此参数会创建一个“tmc2209_stepper_x:virtual_endstop”虚拟引脚，可用作步进电机的endstop_pin。这样做可以启用“无传感器归位”。（请务必也将driver_SGTHRS设置为适当的灵敏度值。）默认值是不启用无传感器归位。
```

### [tmc2660]

通过SPI总线配置TMC2660步进电机驱动器。要使用此功能，请定义一个以“tmc2660”为前缀，后跟相应步进配置部分名称的配置段（例如，“[tmc2660 stepper_x]”）。

```
[tmc2660 stepper_x]
cs_pin:
#   对应于TMC2660芯片选择线的引脚。在SPI消息开始时，该引脚将被设置为低电平，在消息传输完成后被设置为高电平。此参数必须提供。
#spi_speed: 4000000
#   用于与TMC2660步进驱动器通信的SPI总线频率。默认值为4000000。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见“通用SPI设置”部分。
#interpolate: True
#   如果为真，则启用步进插值（驱动器将在内部以256微步的速率步进）。这只在microsteps设置为16时才有效。插值会引入微小的系统性位置偏差——详见TMC_Drivers.md。默认值为True。
run_current:
#   步进电机移动期间驱动器使用的电流大小（以安培RMS为单位）。此参数必须提供。
#sense_resistor:
#   电机感应电阻的阻值（以欧姆为单位）。此参数必须提供。
#idle_current_percent: 100
#   当空闲超时过期时（您需要使用[idle_timeout]配置段设置超时），步进驱动器将降低到运行电流的百分比。当步进电机需要再次移动时，电流将再次升高。请确保将其设置得足够高，以防止步进电机丢失位置。再次升高电流前会有轻微延迟，因此在步进电机空闲时发出快速移动命令时请注意这一点。默认值为100（不降低）。
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
#   在TMC2660芯片配置期间设置给定参数。这可用于设置自定义驱动器参数。每个参数的默认值在上述列表中的参数名称旁边。有关每个参数的作用及参数组合的限制，请参见TMC2660数据手册。特别是要注意CHOPCONF寄存器，当CHM设置为零或一时，会导致布局变化（在这种情况下，HDEC的第一位被解释为HSTRT的MSB）。
```

### [tmc2240]

通过SPI总线或UART配置TMC2240步进电机驱动器。要使用此功能，请定义一个以“tmc2240”为前缀，后跟相应步进配置部分名称的配置段（例如，“[tmc2240 stepper_x]”）。

```
[tmc2240 stepper_x]
cs_pin:
#   对应于TMC2240芯片选择线的引脚。在SPI消息开始时，该引脚将被设置为低电平，在消息完成之后被拉高。此参数必须提供。
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见“通用SPI设置”部分。
#uart_pin:
#   连接到TMC2240 DIAG1/SW线的引脚。如果提供了此参数，则使用UART通信而不是SPI。
#chain_position:
#chain_length:
#   这些参数配置SPI菊花链。这两个参数定义了步进电机在链中的位置和总链长。位置1对应于连接到MOSI信号的步进电机。
#   默认值是不使用SPI菊花链。
#interpolate: True
#   如果为真，则启用步进插值（驱动器将在内部以256微步的速率步进）。默认值为True。
run_current:
#   配置驱动器在步进电机移动期间使用的电流大小（以安培RMS为单位）。此参数必须提供。
#hold_current:
#   配置驱动器在步进电机不移动时使用的电流大小（以安培RMS为单位）。不建议设置hold_current（详见TMC_Drivers.md）。默认值是不降低电流。
#rref: 12000
#   IREF和GND之间电阻的阻值（以欧姆为单位）。默认值为12000。
#stealthchop_threshold: 0
#   设置“stealthChop”阈值的速度（以mm/s为单位）。设置后，当步进电机速度低于此值时，“stealthChop”模式将被启用。请注意，“无传感器归位”代码在归位操作期间可能会暂时覆盖此设置。默认值为0，即禁用“stealthChop”模式。
#coolstep_threshold:
#   设置TMC驱动器内部“CoolStep”阈值的速度（以mm/s为单位）。如果设置了此值，则当步进电机速度接近或高于此值时，coolstep功能将被启用。重要提示——如果设置了coolstep_threshold并使用了“无传感器归位”，则必须确保归位速度高于coolstep阈值！默认值是不启用coolstep功能。
#high_velocity_threshold:
#   设置TMC驱动器内部“高速”阈值（THIGH）的速度（以mm/s为单位）。这通常用于在高速时禁用“CoolStep”功能。默认值是不设置TMC“高速”阈值。
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
#   这些字段直接控制微步表寄存器。最佳波形表对每个电机都是特定的，并且可能随电流变化。最佳配置将使由步进电机非线性移动引起的打印伪影最小化。上面指定的值是驱动器使用的默认值。该值必须指定为十进制整数（不支持十六进制形式）。要计算波形表字段，请参见Trinamic网站上的tmc2130“计算表”。
#   此外，此驱动器还有OFFSET_SIN90字段，可用于调整线圈不平衡的电机。请参见数据手册中的“正弦波查找表”部分以了解此字段及其调谐方法。
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
#   在TMC2240芯片配置期间设置给定寄存器。这可用于设置自定义电机参数。每个参数的默认值在上述列表中的参数名称旁边。
#diag0_pin:
#diag1_pin:
#   连接到TMC2240芯片一个DIAG线的微控制器引脚。只能指定一个diag引脚。该引脚为“低电平有效”，因此通常以“^!”为前缀。设置此参数会创建一个“tmc2240_stepper_x:virtual_endstop”虚拟引脚，可用作步进电机的endstop_pin。这样做可以启用“无传感器归位”。（请务必也将driver_SGT设置为适当的灵敏度值。）默认值是不启用无传感器归位。
```

### [tmc5160]

通过SPI总线配置TMC5160步进电机驱动器。要使用此功能，请定义一个以“tmc5160”为前缀，后跟相应步进配置部分名称的配置段（例如，“[tmc5160 stepper_x]”）。

```
[tmc5160 stepper_x]
cs_pin:
#   对应于TMC5160芯片选择线的引脚。在SPI消息开始时，该引脚将被设置为低电平，在消息完成之后被拉高。此参数必须提供。
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见“通用SPI设置”部分。
#chain_position:
#chain_length:
#   这些参数配置SPI菊花链。这两个参数定义了步进电机在链中的位置和总链长。位置1对应于连接到MOSI信号的步进电机。
#   默认值是不使用SPI菊花链。
#interpolate: True
#   如果为真，则启用步进插值（驱动器将在内部以256微步的速率步进）。默认值为True。
run_current:
#   配置驱动器在步进电机移动期间使用的电流大小（以安培RMS为单位）。此参数必须提供。
#hold_current:
#   配置驱动器在步进电机不移动时使用的电流大小（以安培RMS为单位）。不建议设置hold_current（详见TMC_Drivers.md）。默认值是不降低电流。
#sense_resistor: 0.075
#   电机感应电阻的阻值（以欧姆为单位）。默认值为0.075欧姆。
#stealthchop_threshold: 0
#   设置“stealthChop”阈值的速度（以mm/s为单位）。设置后，当步进电机速度低于此值时，“stealthChop”模式将被启用。请注意，“无传感器归位”代码在归位操作期间可能会暂时覆盖此设置。默认值为0，即禁用“stealthChop”模式。
#coolstep_threshold:
#   设置TMC驱动器内部“CoolStep”阈值的速度（以mm/s为单位）。如果设置了此值，则当步进电机速度接近或高于此值时，coolstep功能将被启用。重要提示——如果设置了coolstep_threshold并使用了“无传感器归位”，则必须确保归位速度高于coolstep阈值！默认值是不启用coolstep功能。
#high_velocity_threshold:
#   设置TMC驱动器内部“高速”阈值（THIGH）的速度（以mm/s为单位）。这通常用于在高速时禁用“CoolStep”功能。默认值是不设置TMC“高速”阈值。
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
#   这些字段直接控制微步表寄存器。最佳波形表对每个电机都是特定的，并且可能随电流变化。最佳配置将使由步进电机非线性移动引起的打印伪影最小化。上面指定的值是驱动器使用的默认值。该值必须指定为十进制整数（不支持十六进制形式）。要计算波形表字段，请参见Trinamic网站上的tmc2130“计算表”。
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
#   在TMC5160芯片配置期间设置给定寄存器。这可用于设置自定义电机参数。每个参数的默认值在上述列表中的参数名称旁边。
#diag0_pin:
#diag1_pin:
#   连接到TMC5160芯片一个DIAG线的微控制器引脚。只能指定一个diag引脚。该引脚为“低电平有效”，因此通常以“^!”为前缀。设置此参数会创建一个“tmc5160_stepper_x:virtual_endstop”虚拟引脚，可用作步进电机的endstop_pin。这样做可以启用“无传感器归位”。（请务必也将driver_SGT设置为适当的灵敏度值。）默认值是不启用无传感器归位。
```

## 运行时步进电机电流配置

### [ad5206]

通过SPI总线连接的静态配置AD5206数字电位器（可以定义任意数量以“ad5206”为前缀的配置段）。

```
[ad5206 my_digipot]
enable_pin:
#   对应于AD5206芯片选择线的引脚。在SPI消息开始时，该引脚将被设置为低电平，在消息完成之后被拉高。此参数必须提供。
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见“通用SPI设置”部分。
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
#   要静态设置给定AD5206通道的值。这通常设置为0.0到1.0之间的数字，1.0为最高电阻，0.0为最低电阻。但是，可以使用'scale'参数更改范围（见下文）。如果未指定通道，则保持未配置状态。
#scale:
#   此参数可用于改变'channel_x'参数的解释方式。如果提供了此参数，则'channel_x'参数应在0.0到'scale'之间。当AD5206用于设置步进电机电压参考时，这可能很有用。'scale'可以设置为AD5206处于最高电阻时等效的步进电机电流，然后'channel_x'参数可以用步进电机所需的电流值来指定。默认值是不对'channel_x'参数进行缩放。
```

### [mcp4451]

通过I2C总线连接的静态配置MCP4451数字电位器（可以定义任意数量以“mcp4451”为前缀的配置段）。

```
[mcp4451 my_digipot]
i2c_address:
#   芯片在I2C总线上使用的I2C地址。此参数必须提供。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   有关上述参数的描述，请参见“通用I2C设置”部分。
#wiper_0:
#wiper_1:
#wiper_2:
#wiper_3:
#   要静态设置给定MCP4451“滑臂”的值。这通常设置为0.0到1.0之间的数字，1.0为最高电阻，0.0为最低电阻。但是，可以使用'scale'参数更改范围（见下文）。如果未指定滑臂，则保持未配置状态。
#scale:
#   此参数可用于改变'wiper_x'参数的解释方式。如果提供了此参数，则'wiper_x'参数应在0.0到'scale'之间。当MCP4451用于设置步进电机电压参考时，这可能很有用。'scale'可以设置为MCP4451处于最高电阻时等效的步进电机电流，然后'wiper_x'参数可以用步进电机所需的电流值来指定。默认值是不对'wiper_x'参数进行缩放。
```

### [mcp4728]

通过I2C总线连接的静态配置MCP4728数模转换器（可以定义任意数量以“mcp4728”为前缀的配置段）。

```
[mcp4728 my_dac]
#i2c_address: 96
#   芯片在I2C总线上使用的I2C地址。默认值为96。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   有关上述参数的描述，请参见“通用I2C设置”部分。
#channel_a:
#channel_b:
#channel_c:
#channel_d:
#   要静态设置给定MCP4728通道的值。这通常设置为0.0到1.0之间的数字，1.0为最高电压（2.048V），0.0为最低电压。但是，可以使用'scale'参数更改范围（见下文）。如果未指定通道，则保持未配置状态。
#scale:
#   此参数可用于改变'channel_x'参数的解释方式。如果提供了此参数，则'channel_x'参数应在0.0到'scale'之间。当MCP4728用于设置步进电机电压参考时，这可能很有用。'scale'可以设置为MCP4728处于最高电压（2.048V）时等效的步进电机电流，然后'channel_x'参数可以用步进电机所需的电流值来指定。默认值是不对'channel_x'参数进行缩放。
```

### [mcp4018]

通过I2C连接的静态配置MCP4018数字电位器（可以定义任意数量以“mcp4018”为前缀的配置段）。

```
[mcp4018 my_digipot]
#i2c_address: 47
#   芯片在I2C总线上使用的I2C地址。默认值为47。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   有关上述参数的描述，请参见“通用I2C设置”部分。
wiper:
#   要静态设置给定MCP4018“滑臂”的值。这通常设置为0.0到1.0之间的数字，1.0为最高电阻，0.0为最低电阻。但是，可以使用'scale'参数更改范围（见下文）。此参数必须提供。
#scale:
#   此参数可用于改变'wiper'参数的解释方式。如果提供了此参数，则'wiper'参数应在0.0到'scale'之间。当MCP4018用于设置步进电机电压参考时，这可能很有用。'scale'可以设置为MCP4018处于最高电阻时等效的步进电机电流，然后'wiper'参数可以用步进电机所需的电流值来指定。默认值是不对'wiper'参数进行缩放。
```

## 显示支持

### [display]

支持连接到微控制器的显示器。

```
[display]
lcd_type:
#   使用的LCD芯片类型。可以是“hd44780”、“hd44780_spi”、“aip31068_spi”、“st7920”、“emulated_st7920”、“uc1701”、“ssd1306”或“sh1106”。
#   有关每种类型的信息和它们提供的额外参数，请参见下面的显示部分。此参数必须提供。
#display_group:
#   要在显示器上显示的display_data组的名称。这控制屏幕内容（有关更多信息，请参见“display_data”部分）。对于hd44780或aip31068_spi显示器，默认值为_default_20x4，对于其他显示器为_default_16x4。
#menu_timeout:
#   菜单超时时间。此秒数的不活动将触发菜单退出或在启用自动运行时返回主菜单。默认值为0秒（禁用）。
#menu_root:
#   在主屏幕点击编码器时显示的主菜单部分的名称。默认值为__main，这会显示klippy/extras/display/menu.cfg中定义的默认菜单。
#menu_reverse_navigation:
#   启用后，列表导航的上下方向将反转。默认值为False。此参数是可选的。
#encoder_pins:
#   连接到编码器的引脚。使用编码器时必须提供2个引脚。使用菜单时必须提供此参数。
#encoder_steps_per_detent:
#   编码器每个“咔嗒”声发出的步数。如果编码器需要两个“咔嗒”声才能在条目间移动或一个“咔嗒”声移动两个条目，请尝试更改此值。允许的值为2（半步）或4（全步）。默认值为4。
#click_pin:
#   连接到“确定”按钮或编码器“点击”的引脚。使用菜单时必须提供此参数。存在'analog_range_click_pin'配置参数会将此参数从数字变为模拟。
#back_pin:
#   连接到“返回”按钮的引脚。此参数是可选的，菜单可以在没有它的情况下使用。存在'analog_range_back_pin'配置参数会将此参数从数字变为模拟。
#up_pin:
#   连接到“上”按钮的引脚。在不使用编码器时使用菜单时必须提供此参数。存在'analog_range_up_pin'配置参数会将此参数从数字变为模拟。
#down_pin:
#   连接到“下”按钮的引脚。在不使用编码器时使用菜单时必须提供此参数。存在'analog_range_down_pin'配置参数会将此参数从数字变为模拟。
#kill_pin:
#   连接到“急停”按钮的引脚。此按钮将调用紧急停止。存在'analog_range_kill_pin'配置参数会将此参数从数字变为模拟。
#analog_pullup_resistor: 4700
#   连接到模拟按钮的上拉电阻的阻值（以欧姆为单位）。默认值为4700欧姆。
#analog_range_click_pin:
#   “确定”按钮的电阻范围。使用模拟按钮时必须提供以逗号分隔的最小和最大范围值。
#analog_range_back_pin:
#   “返回”按钮的电阻范围。使用模拟按钮时必须提供以逗号分隔的最小和最大范围值。
#analog_range_up_pin:
#   “上”按钮的电阻范围。使用模拟按钮时必须提供以逗号分隔的最小和最大范围值。
#analog_range_down_pin:
#   “下”按钮的电阻范围。使用模拟按钮时必须提供以逗号分隔的最小和最大范围值。
#analog_range_kill_pin:
#   “急停”按钮的电阻范围。使用模拟按钮时必须提供以逗号分隔的最小和最大范围值。
```

#### hd44780 显示器

配置hd44780显示器的信息（用于“RepRapDiscount 2004 Smart Controller”类型的显示器）。

```
[display]
lcd_type: hd44780
#   对于hd44780显示器，设置为“hd44780”。
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#   连接到hd44780类型LCD的引脚。这些参数必须提供。
#hd44780_protocol_init: True
#   在hd44780显示器上执行8位/4位协议初始化。这对于真正的hd44780设备是必要的。但是，可能需要在某些“克隆”设备上禁用此功能。默认值为True。
#line_length:
#   设置hd44780类型LCD每行的字符数。可能的值为20（默认）和16。行数固定为4。
...
```

#### hd44780_spi 显示器

配置hd44780_spi显示器的信息——一种通过硬件“移位寄存器”控制的20x04显示器（用于基于mightyboard的打印机）。

```
[display]
lcd_type: hd44780_spi
#   对于hd44780_spi显示器，设置为“hd44780_spi”。
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   连接到控制显示器的移位寄存器的引脚。
#   spi_software_miso_pin需要设置为打印机主板的一个未使用引脚，因为移位寄存器没有MISO引脚，但软件SPI实现需要配置此引脚。
#hd44780_protocol_init: True
#   在hd44780显示器上执行8位/4位协议初始化。这对于真正的hd44780设备是必要的。但是，可能需要在某些“克隆”设备上禁用此功能。默认值为True。
#line_length:
#   设置hd44780类型LCD每行的字符数。可能的值为20（默认）和16。行数固定为4。
...
```

#### aip31068_spi 显示器

配置aip31068_spi显示器的信息——与hd44780_spi非常相似，是一种20x04（20个符号乘以4行）显示器，但内部协议略有不同。

```
[display]
lcd_type: aip31068_spi
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   连接到控制显示器的移位寄存器的引脚。
#   spi_software_miso_pin需要设置为打印机主板的一个未使用引脚，因为移位寄存器没有MISO引脚，但软件SPI实现需要配置此引脚。
#line_length:
#   设置hd44780类型LCD每行的字符数。可能的值为20（默认）和16。行数固定为4。
...
```

#### st7920 显示器

配置st7920显示器的信息（用于“RepRapDiscount 12864 Full Graphic Smart Controller”类型的显示器）。

```
[display]
lcd_type: st7920
#   对于st7920显示器，设置为“st7920”。
cs_pin:
sclk_pin:
sid_pin:
#   连接到st7920类型LCD的引脚。这些参数必须提供。
...
```

#### emulated_st7920 显示器

配置emulated_st7920显示器的信息——在某些“2.4英寸触摸屏设备”和类似设备中发现。

```
[display]
lcd_type: emulated_st7920
#   对于emulated_st7920显示器，设置为“emulated_st7920”。
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   连接到emulated_st7920类型LCD的引脚。en_pin对应于st7920类型LCD的cs_pin，
#   spi_software_sclk_pin对应于sclk_pin，spi_software_mosi_pin对应于sid_pin。spi_software_miso_pin需要设置为打印机主板的一个未使用引脚，因为st7920没有MISO引脚，但软件SPI实现需要配置此引脚。
...
```

#### uc1701 显示器

配置uc1701显示器的信息（用于“MKS Mini 12864”类型的显示器）。

```
[display]
lcd_type: uc1701
#   对于uc1701显示器，设置为“uc1701”。
cs_pin:
a0_pin:
#   连接到uc1701类型LCD的引脚。这些参数必须提供。
#rst_pin:
#   连接到LCD上“rst”引脚的引脚。如果未指定，则硬件必须在相应的LCD线上有上拉。
#contrast:
#   要设置的对比度。值的范围可以从0到63，默认值为40。
...
```

#### ssd1306 和 sh1106 显示器

配置ssd1306和sh1106显示器的信息。

```
[display]
lcd_type:
#   设置为“ssd1306”或“sh1106”以用于给定的显示器类型。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   通过I2C总线连接的显示器可用的可选参数。有关以“spi_”开头的参数的描述，请参见“通用SPI设置”部分。
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   当处于“4线”SPI模式时连接到LCD的引脚。有关以“spi_”开头的参数的描述，请参见“通用SPI设置”部分。默认值是为显示器使用I2C模式。
#reset_pin:
#   可以在显示器上指定一个复位引脚。如果未指定，则硬件必须在相应的LCD线上有上拉。
#contrast:
#   要设置的对比度。值的范围可以从0到256，默认值为239。
#vcomh: 0
#   在显示器上设置Vcomh值。此值与某些OLED显示器上的“拖影”效应有关。值的范围可以从0到63。默认值为0。
#invert: False
#   TRUE会在某些OLED显示器上反转像素。默认值为False。
#x_offset: 0
#   在SH1106显示器上设置水平偏移值。默认值为0。
...
```

### [display_data]

支持在LCD屏幕上显示自定义数据。可以创建任意数量的显示组和这些组下的任意数量的数据项。如果[display]部分中的display_group选项设置为给定组名，则显示器将显示该组的所有数据项。

一组[默认的显示组](../klippy/extras/display/display.cfg)会自动创建。可以通过在主printer.cfg配置文件中覆盖默认值来替换或扩展这些display_data项。

```
[display_data my_group_name my_data_name]
position:
#   以逗号分隔的行和列，用于显示信息的显示器位置。此参数必须提供。
text:
#   在给定位置显示的文本。此字段使用命令模板进行求值（参见docs/Command_Templates.md）。此参数必须提供。
```

### [display_template]

显示数据文本“宏”（可以定义任意数量以 `display_template` 为前缀的
部分）。有关模板求值的信息，请参见
[命令模板](Command_Templates.md) 文档。

此功能允许减少
`display_data` 部分中的重复定义。可以在 `display_data` 部分中使用内置的 `render()` 函数来求值一个模板。例如，如果定义了 `[display_template my_template]`，则可以在 `display_data` 部分中使用 `{ render('my_template') }`。

也可以使用
[SET_LED_TEMPLATE](G-Codes.md#set_led_template) 命令将此功能用于 LED 的连续更新。

```
[display_template my_template_name]
#param_<name>:
#   可以指定任意数量以 "param_" 为前缀的选项。给定的名称将被赋予给定的值（解析为 Python 字面量），并在宏展开期间可用。如果在调用 render() 时传入了参数，则该值将在宏展开期间使用。例如，配置中包含 "param_speed = 75"，则调用者可以使用 "render('my_template_name', param_speed=80)"。参数名称不能使用大写字母。
text:
#   当此模板被渲染时返回的文本。此字段使用命令模板进行求值（参见
#   docs/Command_Templates.md）。必须提供此参数。
```

### [display_glyph]

在支持的显示器上显示自定义字形。给定的名称将被赋予给定的显示数据，然后可以在显示模板中通过用两个“波浪号”符号包围其名称来引用，即 `~my_display_glyph~`。

有关一些示例，请参见 [sample-glyphs.cfg](../config/sample-glyphs.cfg)。

```
[display_glyph my_display_glyph]
#data:
#   显示数据，存储为 16 行，每行 16 位（每像素 1 位），其中 '.' 表示空白像素，'*' 表示点亮的像素（例如，"****************" 表示一条实心水平线）。
#   或者，可以使用 '0' 表示空白像素，'1' 表示点亮的像素。将每一行显示数据放入单独的配置行中。字形必须恰好由 16 行 16 位组成。此参数是可选的。
#hd44780_data:
#   用于 20x4 hd44780 显示屏的字形。字形必须恰好由 8 行 5 位组成。此参数是可选的。
#hd44780_slot:
#   存储字形的 hd44780 硬件索引（0..7）。如果多个不同的图像使用相同的插槽，则确保在任何给定屏幕中只使用其中一个图像。如果指定了 hd44780_data，则此参数是必需的。
```

### [display my_extra_display]

如果已在 printer.cfg 中定义了主 [display] 部分（如上所示），则可以定义多个辅助显示器。请注意，辅助显示器目前不支持菜单功能，因此不支持“菜单”选项或按钮配置。

```
[display my_extra_display]
# 有关可用参数，请参见 "display" 部分。
```

### [menu]

可自定义的 LCD 显示菜单。

[默认菜单集](../klippy/extras/display/menu.cfg) 会自动创建。可以通过在主 printer.cfg 配置文件中覆盖默认值来替换或扩展菜单。

有关模板渲染期间可用的菜单属性信息，请参见
[命令模板文档](Command_Templates.md#menu-templates)。

```
# 所有菜单配置部分可用的通用参数。
#[menu __some_list __some_name]
#type: disabled
#   永久禁用的菜单元素，唯一必需的属性是 'type'。
#   允许您轻松禁用/隐藏现有菜单项。

#[menu some_name]
#type:
#   以下之一：command, input, list, text:
#       command - 具有各种脚本触发器的基本菜单元素
#       input   - 与 'command' 相同，但具有值更改功能。
#                 按下将开始/停止编辑模式。
#       list    - 允许将菜单项分组到可滚动列表中。通过创建使用 "some_list" 作为前缀的菜单配置来添加到列表中 - 例如：[menu some_list some_item_in_the_list]
#       vsdlist - 与 'list' 相同，但会附加虚拟 SD 卡中的文件
#                 （将来会移除）
#name:
#   菜单项的名称 - 作为模板求值。
#enable:
#   求值为 True 或 False 的模板。
#index:
#   项目在列表中插入的位置。默认情况下，项目添加到末尾。

#[menu some_list]
#type: list
#name:
#enable:
#   有关这些参数的描述，请参见上文。

#[menu some_list some_command]
#type: command
#name:
#enable:
#   有关这些参数的描述，请参见上文。
#gcode:
#   在按钮点击或长按时运行的脚本。作为模板求值。

#[menu some_list some_input]
#type: input
#name:
#enable:
#   有关这些参数的描述，请参见上文。
#input:
#   编辑时使用的初始值 - 作为模板求值。
#   结果必须是浮点数。
#input_min:
#   范围的最小值 - 作为模板求值。默认为 -99999。
#input_max:
#   范围的最大值 - 作为模板求值。默认为 99999。
#input_step:
#   编辑步长 - 必须是正整数或浮点数值。它有内部快速速率步长。当 "(input_max - input_min) / input_step > 100" 时，快速速率步长为 10 * input_step，否则快速速率步长与 input_step 相同。
#realtime:
#   此属性接受静态布尔值。启用后，每次值更改后都会运行 gcode 脚本。默认为 False。
#gcode:
#   在按钮点击、长按或值更改时运行的脚本。
#   作为模板求值。按钮点击将触发编辑模式的开始或结束。
```

## 耗材传感器

### [filament_switch_sensor]

耗材开关传感器。支持使用开关传感器（如限位开关）进行耗材插入和耗尽检测。

更多信息请参见 [命令参考](G-Codes.md#filament_switch_sensor)。

```
[filament_switch_sensor my_sensor]
#pause_on_runout: True
#   设置为 True 时，检测到耗材耗尽后将立即执行 PAUSE。注意，如果 pause_on_runout 为 False 且省略了 runout_gcode，则耗尽检测将被禁用。默认为 True。
#runout_gcode:
#   在检测到耗材耗尽后执行的 G-Code 命令列表。有关 G-Code 格式，请参见 docs/Command_Templates.md。如果 pause_on_runout 设置为 True，则此 G-Code 将在 PAUSE 完成后运行。默认不运行任何 G-Code 命令。
#insert_gcode:
#   在检测到耗材插入后执行的 G-Code 命令列表。有关 G-Code 格式，请参见 docs/Command_Templates.md。默认不运行任何 G-Code 命令，这将禁用插入检测。
#event_delay: 3.0
#   事件之间的最小延迟时间（秒）。在此期间触发的事件将被静默忽略。默认为 3 秒。
#pause_delay: 0.5
#   暂停命令分派与执行 runout_gcode 之间的延迟时间（秒）。如果 OctoPrint 表现出奇怪的暂停行为，增加此延迟可能有用。默认为 0.5 秒。
#debounce_delay:
#   在运行开关 gcode 之前对事件进行去抖动的持续时间（秒）。开关必须保持单一状态至少这么长时间才能激活。如果在延迟期间开关被切换开/关，则事件将被忽略。默认为 0。
#switch_pin:
#   连接开关的引脚。必须提供此参数。
```

### [filament_motion_sensor]

耗材运动传感器。支持使用在耗材通过传感器时切换输出引脚的编码器进行耗材插入和耗尽检测。

更多信息请参见 [命令参考](G-Codes.md#filament_switch_sensor)。

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#   触发 switch_pin 状态改变时，通过传感器的最小耗材长度
#   默认为 7 毫米。
extruder:
#   此传感器关联的挤出机或 extruder_stepper 部分的名称。必须提供此参数。
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   有关上述参数的描述，请参见 "filament_switch_sensor" 部分。
```

### [tsl1401cl_filament_width_sensor]

基于 TSL1401CL 的耗材直径传感器。更多信息请参见
[指南](TSL1401CL_Filament_Width_Sensor.md)。

```
[tsl1401cl_filament_width_sensor]
#pin:
#default_nominal_filament_diameter: 1.75 # (mm)
#   允许的最大耗材直径差值（毫米）。
#max_difference: 0.2
#   从传感器到熔化室的距离（毫米）。
#measurement_delay: 100
```

### [hall_filament_width_sensor]

霍尔耗材直径传感器（参见
[霍尔耗材直径传感器](Hall_Filament_Width_Sensor.md)）。

```
[hall_filament_width_sensor]
adc1:
adc2:
#   连接到传感器的模拟输入引脚。必须提供这些参数。
#cal_dia1: 1.50
#cal_dia2: 2.00
#   传感器的校准值（毫米）。默认为 cal_dia1 1.50 和 cal_dia2 2.00。
#raw_dia1: 9500
#raw_dia2: 10500
#   传感器的原始校准值。默认为 raw_dia1 9500 和 raw_dia2 10500。
#default_nominal_filament_diameter: 1.75
#   标称耗材直径。必须提供此参数。
#max_difference: 0.200
#   允许的最大耗材直径差值（毫米）。如果标称耗材直径与传感器输出之间的差值超过 +- max_difference，则挤出倍率将重置为 %100。默认为 0.200。
#measurement_delay: 70
#   从传感器到熔化室/热端的距离（毫米）。传感器与热端之间的耗材将被视为 default_nominal_filament_diameter。主机模块采用 FIFO 逻辑。它将每个传感器值和位置保存在数组中，并在正确位置弹出。必须提供此参数。
#enable: False
#   上电后传感器启用或禁用。默认为禁用。
#measurement_interval: 10
#   传感器读数之间的近似距离（毫米）。默认为 10 毫米。
#logging: False
#   可通过命令打开或关闭直径输出到终端和 klipper.log。
#min_diameter: 1.0
#   触发虚拟 filament_switch_sensor 的最小直径。
#max_diameter:
#   触发虚拟 filament_switch_sensor 的最大直径。
#   默认为 default_nominal_filament_diameter + max_difference。
#use_current_dia_while_delay: False
#   在测量延迟未完成时，使用当前直径而不是标称直径。
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   有关上述参数的描述，请参见 "filament_switch_sensor" 部分。
```

## 称重传感器

### [load_cell]
称重传感器。使用连接到称重传感器的 ADC 传感器创建数字秤。

```
[load_cell]
sensor_type:
#   必须是支持的传感器类型之一，请参见下文。
#counts_per_gram:
#   表示 1 克力的浮点传感器计数。此值由 LOAD_CELL_CALIBRATE 命令计算。
#reference_tare_counts:
#   LOAD_CELL_CALIBRATE 运行时获取的整数去皮值，以原始传感器计数表示。这是 Klipper 启动时的默认去皮值。
#sensor_orientation:
#   更改传感器的方向。可以是 'normal' 或 'inverted'。
#   默认为 'normal'。如果传感器在负载下报告的力值减小，则使用 'inverted'。
```

#### HX711
这是一个使用“位敲击”通信的 24 位低采样率芯片。适用于耗材秤。
```
[load_cell]
sensor_type: hx711
sclk_pin:
#   连接到 HX711 时钟线的引脚。必须提供此参数。
dout_pin:
#   连接到 HX711 数据输出线的引脚。必须提供此参数。
#gain: A-128
#   增益的有效值为：A-128, A-64, B-32。默认为 A-128。
#   'A' 表示输入通道，数字表示增益。芯片仅支持列出的 3 种组合。注意，更改增益设置也会选择要读取的通道。
#sample_rate: 80
#   采样率的有效值为 80 或 10。默认值为 80。
#   这必须与芯片的接线匹配。采样率不能在软件中更改。
```

#### HX717
这是 HX711 的 4 倍高采样率版本，适用于探针。
```
[load_cell]
sensor_type: hx717
sclk_pin:
#   连接到 HX717 时钟线的引脚。必须提供此参数。
dout_pin:
#   连接到 HX717 数据输出线的引脚。必须提供此参数。
#gain: A-128
#   增益的有效值为 A-128, B-64, A-64, B-8。
#   'A' 表示输入通道，数字表示增益设置。
#   芯片仅支持列出的 4 种组合。注意，更改增益设置也会选择要读取的通道。
#sample_rate: 320
#   采样率的有效值为：10, 20, 80, 320。默认为 320。
#   这必须与芯片的接线匹配。采样率不能在软件中更改。
```

#### ADS1220
ADS1220 是一个 24 位 ADC，支持高达 2Khz 的采样率，可在软件中配置。
```
[load_cell]
sensor_type: ads1220
cs_pin:
#   连接到 ADS1220 片选线的引脚。必须提供此参数。
#spi_speed: 512000
#   该芯片支持 2 种速度：256000 或 512000。当使用 Turbo 采样率之一时，才会启用更快的速度。正确的 spi_speed 会根据采样率选择。
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见 "common SPI settings" 部分。
data_ready_pin:
#   连接到 ADS1220 数据就绪线的引脚。必须提供此参数。
#gain: 128
#   有效增益值为 128, 64, 32, 16, 8, 4, 2, 1
#   默认为 128
#pga_bypass: False
#   禁用内部可编程增益放大器。如果为 True，则对于增益 1, 2, 和 4 将禁用 PGA。对于增益设置 8 到 128，无论 pga_bypass 设置如何，PGA 始终启用。如果使用 AVSS 作为输入，则 pga_bypass 强制为 True。
#   默认为 False。
#sample_rate: 660
#   该芯片支持两种采样率范围，正常和 Turbo。在 Turbo 模式下，芯片的内部时钟运行速度是正常模式的两倍，SPI 通信速度也加倍。
#   正常采样率：20, 45, 90, 175, 330, 600, 1000
#   Turbo 采样率：40, 90, 180, 350, 660, 1200, 2000
#   默认为 660
#input_mux:
#   输入多路复用器配置，选择一对引脚使用。第一个引脚是正极 AINP，第二个引脚是负极 AINN。有效值为：'AIN0_AIN1', 'AIN0_AIN2', 'AIN0_AIN3', 'AIN1_AIN2', 'AIN1_AIN3', 'AIN2_AIN3', 'AIN1_AIN0', 'AIN3_AIN2', 'AIN0_AVSS', 'AIN1_AVSS', 'AIN2_AVSS' 和 'AIN3_AVSS'。如果使用 AVSS，则 PGA 被旁路，pga_bypass 设置将强制为 True。
#   默认为 AIN0_AIN1。
#vref:
#   选择的电压参考。有效值为：'internal', 'REF0', 'REF1' 和 'analog_supply'。默认为 'internal'。
```

### [load_cell_probe]
称重传感器探针。此功能结合了 [probe] 和 [load_cell] 的功能。

```
[load_cell_probe]
sensor_type:
#   必须是支持的批量 ADC 传感器类型之一，并支持 mcu 上的称重传感器限位。
#counts_per_gram:
#reference_tare_counts:
#sensor_orientation:
#   在探针工作前必须配置这些参数。
#   有关更多详细信息，请参见 [load_cell] 部分。
#force_safety_limit: 2000
#   探针力相对于 load_cell 上 reference_tare_counts 的安全限制。默认为 +/-2Kg。
#trigger_force: 75.0
#   探针触发时的力。默认为 75g。
#drift_filter_cutoff_frequency: 0.8
#   在归位和探针期间启用可选的连续去皮以拒绝漂移。
#   该值是一个频率（Hz），低于该频率的漂移将被忽略。此选项需要 SciPy 库。默认：None
#drift_filter_delay: 2
#   漂移滤波器的延迟或“阶数”。这控制触发检测所需的样本数。可以是 1 或 2，默认为 2。
#buzz_filter_cutoff_frequency: 100.0
#   该值是一个频率（Hz），高于该频率的称重传感器高频噪声将被滤除。此选项需要 SciPy 库。默认：None
#buzz_filter_delay: 2
#   嗡嗡滤波器的延迟或“阶数”。这控制触发检测所需的样本数。可以是 1 或 2，默认为 2。
#notch_filter_frequencies: 50, 60
#   1 或 2 个频率（Hz），用于从称重传感器数据中滤除。旨在拒绝电源线噪声。此选项需要 SciPy 库。默认：None
#notch_filter_quality: 2.0
#   控制陷波滤波器去除的频率范围有多窄。较大的数值产生更窄的滤波器。最小值为 0.5，最大值为 3.0。默认：2.0
#tare_time:
#   探针前用于去皮称重传感器的秒数。默认值为：4 / 60 = 0.066。这会收集来自 4 个 60Hz 市电周期的样本以抵消电源线噪声。
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
#   有关上述参数的描述，请参见 "[probe]" 部分。
```

## 特定板卡的硬件支持

### [sx1509]

配置一个 SX1509 I2C 到 GPIO 扩展器。由于 I2C 通信带来的延迟，您不应将 SX1509 引脚用作步进电机使能、步进或方向引脚，或任何需要快速位敲击的引脚。它们最适合用作静态或 Gcode 控制的数字输出或硬件 PWM 引脚（例如风扇）。可以定义任意数量以 "sx1509" 为前缀的部分。每个扩展器提供一组 16 个引脚（sx1509_my_sx1509:PIN_0 到 sx1509_my_sx1509:PIN_15），可在打印机配置中使用。

有关示例，请参见 [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg) 文件。

```
[sx1509 my_sx1509]
i2c_address:
#   此扩展器使用的 I2C 地址。根据硬件跳线，可以是以下地址之一：62 63 112 113。必须提供此参数。
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   有关上述参数的描述，请参见 "common I2C settings" 部分。
```

### [samd_sercom]

SAMD SERCOM 配置，用于指定在给定 SERCOM 上使用的引脚。可以定义任意数量以 "samd_sercom" 为前缀的部分。在将其用作 SPI 或 I2C 外设之前，必须先配置每个 SERCOM。将此配置部分放在使用 SPI 或 I2C 总线的任何其他部分之上。

```
[samd_sercom my_sercom]
sercom:
#   在微控制器中配置的 sercom 总线名称。
#   可用名称为 "sercom0", "sercom1" 等。必须提供此参数。
tx_pin:
#   用于 SPI 通信的 MOSI 引脚，或用于 I2C 通信的 SDA（数据）引脚。引脚必须对给定的 SERCOM 外设有有效的 pinmux 配置。必须提供此参数。
#rx_pin:
#   用于 SPI 通信的 MISO 引脚。此引脚不用于 I2C 通信（I2C 使用 tx_pin 进行发送和接收）。引脚必须对给定的 SERCOM 外设有有效的 pinmux 配置。此参数是可选的。
clk_pin:
#   用于 SPI 通信的 CLK 引脚，或用于 I2C 通信的 SCL（时钟）引脚。引脚必须对给定的 SERCOM 外设有有效的 pinmux 配置。必须提供此参数。
```

### [adc_scaled]

Duet2 Maestro 通过 vref 和 vssa 读数进行模拟缩放。定义 adc_scaled 部分可启用虚拟 adc 引脚（例如 "my_name:PB0"），这些引脚会自动根据板卡的 vref 和 vssa 监控引脚进行调整。请确保在此配置部分中定义的虚拟引脚使用的任何其他配置部分之前定义此配置部分。

有关示例，请参见
[generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg) 文件。

```
[adc_scaled my_name]
vref_pin:
#   用于 VREF 监控的 ADC 引脚。必须提供此参数。
vssa_pin:
#   用于 VSSA 监控的 ADC 引脚。必须提供此参数。
#smooth_time: 2.0
#   vref 和 vssa 测量值将在此时间（秒）内进行平滑处理，以减少测量噪声的影响。默认为 2 秒。
```

### [ads1x1x]

ADS1013、ADS1014、ADS1015、ADS1113、ADS1114 和 ADS1115 是基于 I2C 的模数转换器，可用于温度传感器。它们提供 4 个模拟输入引脚，可以是单线或差分输入。

注意：如果使用此传感器控制加热器，请小心。加热器的 min_temp 和 max_temp 仅在主机运行且正常工作时在主机中验证。（直接连接到微控制器的 ADC 输入在微控制器内验证 min_temp 和 max_temp，不需要与主机的正常连接。）

```
[ads1x1x my_ads1x1x]
chip: ADS1115
#pga: 4.096V
#   默认值为 4.096V。输入使用的最大电压范围。这会缩放从 ADC 读取的所有值。选项为：6.144V, 4.096V, 2.048V, 1.024V, 0.512V, 0.256V
#adc_voltage: 3.3
#   设备的供电电压。这允许对从 ADC 读取的所有值进行额外的软件缩放。
i2c_mcu: host
i2c_bus: i2c.1
#address_pin: GND
#   默认值为 GND。根据设备接线，最多可以有四个寻址设备。请查阅数据手册以了解详细信息。可以直接指定 i2c_address 而不是使用 address_pin。
```

该芯片提供可与其他传感器一起使用的引脚。

```
sensor_type: ...
#   可以是任何热敏电阻或 adc_temperature。
sensor_pin: my_ads1x1x:AIN0
#   ADS1x1x 芯片名称和引脚的组合。可能的引脚值为 AIN0、AIN1、AIN2 和 AIN3（单端线）以及 DIFF01、DIFF03、DIFF13 和 DIFF23（对应线之间的差分）。例如，DIFF03 测量线 0 和 3 之间的差分。仅允许特定的差分组合。
```

### [replicape]

Replicape 支持 - 有关示例，请参见 [beaglebone 指南](Beaglebone.md) 和
[generic-replicape.cfg](../config/generic-replicape.cfg) 文件。

```
# "replicape" 配置部分添加了 "replicape:stepper_x_enable"
# 虚拟步进电机使能引脚（用于步进电机 X, Y, Z, E, 和 H）和
# "replicape:power_x" PWM 输出引脚（用于热床、e、h、fan0、fan1、
# fan2 和 fan3），然后可以在配置文件的其他地方使用。
[replicape]
revision:
#   Replicape 硬件版本。目前仅支持版本 "B3"。必须提供此参数。
#enable_pin: !gpio0_20
#   Replicape 全局使能引脚。默认为 !gpio0_20（即 P9_41）。
host_mcu:
#   与 Klipper "linux process" mcu 实例通信的 mcu 配置部分的名称。必须提供此参数。
#standstill_power_down: False
#   此参数控制所有步进电机上的 CFG6_ENN 线。True 将使能线设置为“打开”。默认为 False。
#stepper_x_microstep_mode:
#stepper_y_microstep_mode:
#stepper_z_microstep_mode:
#stepper_e_microstep_mode:
#stepper_h_microstep_mode:
#   此参数控制给定步进电机驱动器的 CFG1 和 CFG2 引脚。可用选项为：disable, 1, 2, spread2, 4, 16, spread4, spread16, stealth4, 和 stealth16。默认为 disable。
#stepper_x_current:
#stepper_y_current:
#stepper_z_current:
#stepper_e_current:
#stepper_h_current:
#   步进电机驱动器配置的最大电流（安培）。如果步进电机未处于禁用模式，则必须提供此参数。
#stepper_x_chopper_off_time_high:
#stepper_y_chopper_off_time_high:
#stepper_z_chopper_off_time_high:
#stepper_e_chopper_off_time_high:
#stepper_h_chopper_off_time_high:
#   此参数控制步进电机驱动器的 CFG0 引脚（True 设置 CFG0 高，False 设置为低）。默认为 False。
#stepper_x_chopper_hysteresis_high:
#stepper_y_chopper_hysteresis_high:
#stepper_z_chopper_hysteresis_high:
#stepper_e_chopper_hysteresis_high:
#stepper_h_chopper_hysteresis_high:
#   此参数控制步进电机驱动器的 CFG4 引脚（True 设置 CFG4 高，False 设置为低）。默认为 False。
#stepper_x_chopper_blank_time_high:
#stepper_y_chopper_blank_time_high:
#stepper_z_chopper_blank_time_high:
#stepper_e_chopper_blank_time_high:
#stepper_h_chopper_blank_time_high:
#   此参数控制步进电机驱动器的 CFG5 引脚（True 设置 CFG5 高，False 设置为低）。默认为 True。
```

## 其他自定义模块

### [palette2]

Palette 2 多材料支持 - 提供更紧密的集成支持，支持连接模式下的 Palette 2 设备。

此模块还需要 `[virtual_sdcard]` 和 `[pause_resume]` 才能实现完整功能。

如果使用此模块，请不要使用 Octoprint 的 Palette 2 插件，因为它们会冲突，并且其中一个将无法正确初始化，可能导致打印中止。

如果使用 Octoprint 并通过串行端口流式传输 gcode 而不是从 virtual_sd 打印，则从 *设置 > 串行连接 > 固件和协议* 中的 *暂停命令* 中移除 **M1** 和 **M0**，可以避免需要在 Palette 2 上开始打印并在 Octoprint 中取消暂停才能开始打印。

```
[palette2]
serial:
#   连接到 Palette 2 的串行端口。
#baud: 115200
#   使用的波特率。默认为 115200。
#feedrate_splice: 0.8
#   拼接时使用的进给速率，默认为 0.8
#feedrate_normal: 1.0
#   拼接后使用的进给速率，默认为 1.0
#auto_load_speed: 2
#   自动加载时的挤出进给速率，默认为 2 (mm/s)
#auto_cancel_variation: 0.1
#   当 ping 变化超过此阈值时自动取消打印
```

### [angle]

磁性霍尔角度传感器支持，使用 a1333、as5047d、mt6816、mt6826s 或 tle5012b SPI 芯片读取步进电机轴的角度测量。
测量值可通过 [API Server](API_Server.md) 和
[运动分析工具](Debugging.md#motion-analysis-and-data-logging) 获得。
有关可用命令，请参见 [G-Code 参考](G-Codes.md#angle)。

```
[angle my_angle_sensor]
sensor_type:
#   磁性霍尔传感器芯片的类型。可用选项为
#   "a1333", "as5047d", "mt6816", "mt6826s", 和 "tle5012b"。必须指定此参数。
#sample_period: 0.000400
#   测量期间使用的查询周期（秒）。默认为 0.000400（即每秒 2500 个样本）。
#stepper:
#   角度传感器连接的步进电机名称（例如 "stepper_x"）。设置此值可启用角度校准工具。要使用此功能，必须安装 Python "numpy" 包。默认为不为角度传感器启用角度校准。
cs_pin:
#   传感器的 SPI 使能引脚。必须提供此参数。
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   有关上述参数的描述，请参见 "common SPI settings" 部分。
```

## 常用总线参数

### 常用 SPI 设置

以下参数通常可用于使用 SPI 总线的设备。

```
#spi_speed:
#   与设备通信时使用的 SPI 速度（赫兹）。默认值取决于设备类型。
#spi_bus:
#   如果微控制器支持多个 SPI 总线，则可以在此处指定微控制器总线名称。默认值取决于微控制器类型。
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   指定上述参数以使用“基于软件的 SPI”。此模式不需要微控制器硬件支持（通常可以使用任何通用引脚）。默认为不使用“软件 SPI”。
```

### 常用 I2C 设置

以下参数通常可用于使用 I2C 总线的设备。

请注意，Klipper 当前的微控制器 I2C 支持通常对线路噪声不耐受。I2C 线路上的意外错误可能导致 Klipper 引发运行时错误。Klipper 对错误恢复的支持因微控制器类型而异。通常建议仅使用与微控制器在同一印刷电路板上的 I2C 设备。

大多数 Klipper 微控制器实现仅支持 100000 的 `i2c_speed`（*标准模式*，100kbit/s）。Klipper “Linux” 微控制器支持 400000 的速度（*快速模式*，400kbit/s），但必须在[操作系统中设置](RPi_microcontroller.md#optional-enabling-i2c)，并且 `i2c_speed` 参数将被忽略。Klipper “RP2040” 微控制器以及 ATmega AVR 系列和某些 STM32（F0、G0、G4、L4、F7、H7）支持通过 `i2c_speed` 参数设置 400000 的速率。所有其他 Klipper 微控制器使用 100000 的速率并忽略 `i2c_speed` 参数。

```
#i2c_address:
#   设备的 i2c 地址。必须以十进制数（而非十六进制）指定。默认值取决于设备类型。
#i2c_mcu:
#   芯片连接的微控制器的名称。默认为 "mcu"。
#i2c_bus:
#   如果微控制器支持多个 I2C 总线，则可以在此处指定微控制器总线名称。默认值取决于微控制器类型。
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#   指定这些参数以使用微控制器基于软件的 I2C “位敲击” 支持。这两个参数应为微控制器上用于 scl 和 sda 线的两个引脚。默认为使用由 i2c_bus 参数指定的基于硬件的 I2C 支持。
#i2c_speed:
#   与设备通信时使用的 I2C 速度（赫兹）。大多数微控制器上的 Klipper 实现硬编码为 100000，更改此值无效。默认为 100000。Linux、RP2040 和 ATmega 支持 400000。
```