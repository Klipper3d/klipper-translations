# G代码

本文档描述了Klipper支持的命令。
这些是用户可以在OctoPrint终端选项卡中输入的命令。

## G-Code 命令

Klipper支持以下标准G-Code命令：
- 移动 (G0 或 G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- 暂停: `G4 P<毫秒>`
- 移动到原点: `G28 [X] [Y] [Z]`
- 关闭电机: `M18` 或 `M84`
- 等待当前移动完成: `M400`
- 使用绝对/相对距离进行挤出: `M82`, `M83`
- 使用绝对/相对坐标: `G90`, `G91`
- 设置位置: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- 设置速度因子覆盖百分比: `M220 S<百分比>`
- 设置挤出因子覆盖百分比: `M221 S<百分比>`
- 设置加速度: `M204 S<值>` 或 `M204 P<值> T<值>`
  - 注意：如果未指定S且同时指定了P和T，则加速度设置为P和T的最小值。如果只指定了P或T中的一个，则该命令无效。
- 获取挤出机温度: `M105`
- 设置挤出机温度: `M104 [T<索引>] [S<温度>]`
- 设置挤出机温度并等待: `M109 [T<索引>] S<温度>`
  - 注意：M109始终等待温度稳定在请求的值
- 设置热床温度: `M140 [S<温度>]`
- 设置热床温度并等待: `M190 S<温度>`
  - 注意：M190始终等待温度稳定在请求的值
- 设置风扇速度: `M106 S<值>`
- 关闭风扇: `M107`
- 紧急停止: `M112`
- 获取当前位置: `M114`
- 获取固件版本: `M115`

有关上述命令的更多详细信息，请参阅
[RepRap G-Code文档](http://reprap.org/wiki/G-code)。

Klipper的目标是支持常见第三方软件（例如OctoPrint、Printrun、Slic3r、Cura等）在其标准配置中生成的G-Code命令。其目标不是支持每一个可能的G-Code命令。相反，Klipper更倾向于使用人类可读的["扩展G-Code命令"](#additional-commands)。同样，G-Code终端输出仅旨在供人类阅读 - 如果从外部软件控制Klipper，请参阅[API服务器文档](API_Server.md)。

如果需要较少见的G-Code命令，则可能可以通过自定义[gcode_macro配置部分](Config_Reference.md#gcode_macro)来实现。例如，可以使用此方法来实现：`G12`、`G29`、`G30`、`G31`、`M42`、`M80`、`M81`、`T1`等。

## 其他命令

Klipper使用“扩展”G-Code命令进行常规配置和状态查询。这些扩展命令都遵循类似的格式 - 它们以命令名称开头，后面可能跟着一个或多个参数。例如：`SET_SERVO SERVO=myservo ANGLE=5.3`。在本文档中，命令和参数以大写显示，但它们不区分大小写。（因此，“SET_SERVO”和“set_servo”运行相同的命令。）

本节按Klipper模块名称组织，通常遵循[打印机配置文件](Config_Reference.md)中指定的章节名称。请注意，某些模块会自动加载。

### [adxl345]

当启用[adxl345配置部分](Config_Reference.md#adxl345)时，以下命令可用。

#### ACCELEROMETER_MEASURE
`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: 以请求的每秒采样数启动加速度计测量。如果未指定CHIP，则默认为"adxl345"。该命令以启动-停止模式工作：首次执行时，它启动测量，下次执行时停止测量。测量结果将写入名为`/tmp/adxl345-<chip>-<name>.csv`的文件，其中`<chip>`是加速度计芯片的名称（来自`[adxl345 my_chip_name]`的`my_chip_name`），`<name>`是可选的NAME参数。如果未指定NAME，则默认为"YYYYMMDD_HHMMSS"格式的当前时间。如果加速度计在配置部分中没有名称（仅`[adxl345]`），则名称中的`<chip>`部分不会生成。

#### ACCELEROMETER_QUERY
`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: 查询加速度计的当前值。如果未指定CHIP，则默认为"adxl345"。如果未指定RATE，则使用默认值。此命令可用于测试与ADXL345加速度计的连接：返回的值之一应该是自由落体加速度（+/-芯片的一些噪声）。

#### ACCELEROMETER_DEBUG_READ
`ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`: 查询ADXL345寄存器"register"（例如44或0x2C）。可用于调试目的。

#### ACCELEROMETER_DEBUG_WRITE
`ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<register> VAL=<value>`: 将原始"value"写入寄存器"register"。"value"和"register"都可以是十进制或十六进制整数。请谨慎使用，并参考ADXL345数据表。

### [angle]

当启用[angle配置部分](Config_Reference.md#angle)时，以下命令可用。

#### ANGLE_CALIBRATE
`ANGLE_CALIBRATE CHIP=<chip_name>`: 对给定传感器执行角度校准（必须存在指定`stepper`参数的`[angle chip_name]`配置部分）。重要 - 此工具将命令步进电机移动而不检查正常的运动学边界限制。在校准期间，理想情况下应将电机从任何打印机滑架上断开。如果无法从打印机上断开步进电机，请确保在校准开始前滑架靠近其导轨中心。（步进电机在此测试期间可能向前或向后旋转两整圈。）完成此测试后，使用`SAVE_CONFIG`命令将校准数据保存到配置文件。要使用此工具，必须安装Python "numpy"包（更多信息请参阅[测量共振文档](Measuring_Resonances.md#software-installation)）。

#### ANGLE_CHIP_CALIBRATE
`ANGLE_CHIP_CALIBRATE CHIP=<chip_name>`: 执行内部传感器校准（如果已实现）（MT6826S/MT6835）。

- **MT68XX**: 在执行校准前，应将电机从任何打印机滑架上断开。
校准后，应通过断开电源来重置传感器。

#### ANGLE_DEBUG_READ
`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: 查询传感器寄存器"register"（例如44或0x2C）。可用于调试目的。仅适用于tle5012b芯片。

#### ANGLE_DEBUG_WRITE
`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: 将原始"value"写入寄存器"register"。"value"和"register"都可以是十进制或十六进制整数。请谨慎使用，并参考传感器数据表。仅适用于tle5012b芯片。

### [axis_twist_compensation]

当启用[Axis_twist_compensation配置部分](Config_Reference.md#axis_twist_compensation)时，以下命令可用。

#### AXIS_TWIST_COMPENSATION_CALIBRATE
`AXIS_TWIST_COMPENSATION_CALIBRATE [AXIS=<X|Y>] [SAMPLE_COUNT=<value>]`

通过指定目标轴或启用自动校准来校准轴扭曲补偿。

- **AXIS**: 定义将为其校准扭曲补偿的轴（`X`或`Y`）。如果未指定，则轴默认为`'X'`。

### [bed_mesh]

当启用[bed_mesh配置部分](Config_Reference.md#bed_mesh)时（另请参阅[床网格指南](Bed_Mesh.md)），以下命令可用。

#### BED_MESH_CALIBRATE
`BED_MESH_CALIBRATE [PROFILE=<name>] [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=1] [ADAPTIVE_MARGIN=<value>]`: 此命令使用配置中指定的生成点探测床面。探测后，将生成网格并根据网格调整z轴移动。`BED_MESH_CALIBRATE`成功完成后，网格立即生效。网格将保存到由`PROFILE`参数指定的配置文件中，如果未指定则为`default`。如果指定了ADAPTIVE=1，则配置文件名将以`adaptive-`开头，不应保存以供重用。有关可选探测参数的详细信息，请参阅PROBE命令。如果指定了METHOD=manual，则激活手动探测工具 - 有关此工具激活时可用的附加命令的详细信息，请参阅上面的MANUAL_PROBE命令。可选的`HORIZONTAL_MOVE_Z`值将覆盖配置文件中指定的`horizontal_move_z`选项。如果指定了ADAPTIVE=1，则正在打印的Gcode文件中定义的对象将用于定义探测区域。可选的`ADAPTIVE_MARGIN`值将覆盖配置文件中指定的`adaptive_margin`选项。

#### BED_MESH_OUTPUT
`BED_MESH_OUTPUT PGP=[<0:1>]`: 此命令将当前探测的z值和当前网格值输出到终端。如果指定了PGP=1，则bed_mesh生成的X、Y坐标及其关联的索引将输出到终端。

#### BED_MESH_MAP
`BED_MESH_MAP`: 类似于BED_MESH_OUTPUT，此命令将网格的当前状态打印到终端。不是以人类可读格式打印值，而是以json格式序列化状态。这允许Octoprint插件轻松捕获数据并生成近似床面表面的高度图。

#### BED_MESH_CLEAR
`BED_MESH_CLEAR`: 此命令清除网格并移除所有z调整。建议将其放入您的结束gcode中。

#### BED_MESH_PROFILE
`BED_MESH_PROFILE LOAD=<name> SAVE=<name> REMOVE=<name>`: 此命令提供网格状态的配置文件管理。LOAD将从匹配提供的名称的配置文件恢复网格状态。SAVE将当前网格状态保存到匹配提供的名称的配置文件中。Remove将从持久内存中删除匹配提供的名称的配置文件。请注意，在运行SAVE或REMOVE操作后，必须运行SAVE_CONFIG gcode才能使对持久内存的更改永久生效。

#### BED_MESH_OFFSET
`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value]`: 对网格查找应用X、Y和/或ZFADE偏移。这对于具有独立挤出机的打印机很有用，因为工具更换后需要偏移才能产生正确的Z调整。请注意，ZFADE偏移不会直接应用额外的z调整，它用于在Z轴应用了`gcode offset`时校正`fade`计算。

### [bed_screws]

当启用[bed_screws配置部分](Config_Reference.md#bed_screws)时（另请参阅[手动调平指南](Manual_Level.md#adjusting-bed-leveling-screws)），以下命令可用。

#### BED_SCREWS_ADJUST
`BED_SCREWS_ADJUST`: 此命令将调用床面螺丝调整工具。它将命令喷嘴到不同位置（如配置文件中定义），并允许您调整床面螺丝，使床面与喷嘴保持恒定距离。

### [bed_tilt]

当启用[bed_tilt配置部分](Config_Reference.md#bed_tilt)时，以下命令可用。

#### BED_TILT_CALIBRATE
`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: 此命令将探测配置中指定的点，然后推荐更新的x和y倾斜调整。有关可选探测参数的详细信息，请参阅PROBE命令。如果指定了METHOD=manual，则激活手动探测工具 - 有关此工具激活时可用的附加命令的详细信息，请参阅MANUAL_PROBE命令。可选的`HORIZONTAL_MOVE_Z`值将覆盖配置文件中指定的`horizontal_move_z`选项。

### [bltouch]

当启用[bltouch配置部分](Config_Reference.md#bltouch)时（另请参阅[BL-Touch指南](BLTouch.md)），以下命令可用。

#### BLTOUCH_DEBUG
`BLTOUCH_DEBUG COMMAND=<command>`: 这向BLTouch发送一个命令。可能对调试有用。可用命令有：`pin_down`、`touch_mode`、`pin_up`、`self_test`、`reset`。BL-Touch V3.0或V3.1还可能支持`set_5V_output_mode`、`set_OD_output_mode`、`output_mode_store`命令。

#### BLTOUCH_STORE
`BLTOUCH_STORE MODE=<output_mode>`: 这将输出模式存储在BLTouch V3.1的EEPROM中。可用的output_modes有：`5V`、`OD`

### [configfile]

configfile模块会自动加载。

#### SAVE_CONFIG
`SAVE_CONFIG`: 此命令将覆盖主打印机配置文件并重启主机软件。此命令与其他校准命令结合使用，以存储校准测试的结果。

### [delayed_gcode]

如果已启用[delayed_gcode配置部分](Config_Reference.md#delayed_gcode)（另请参阅[模板指南](Command_Templates.md#delayed-gcodes)），则启用以下命令。

#### UPDATE_DELAYED_GCODE
`UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: 更新已识别的[delayed_gcode]的延迟持续时间并启动gcode执行的计时器。值为0将取消待处理的延迟gcode执行。

### [delta_calibrate]

当启用[delta_calibrate配置部分](Config_Reference.md#linear-delta-kinematics)时（另请参阅[delta校准指南](Delta_Calibrate.md)），以下命令可用。

#### DELTA_CALIBRATE
`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: 此命令将在床面上探测七个点并推荐更新的限位开关位置、塔角和半径。有关可选探测参数的详细信息，请参阅PROBE命令。如果指定了METHOD=manual，则激活手动探测工具 - 有关此工具激活时可用的附加命令的详细信息，请参阅MANUAL_PROBE命令。可选的`HORIZONTAL_MOVE_Z`值将覆盖配置文件中指定的`horizontal_move_z`选项。

#### DELTA_ANALYZE
`DELTA_ANALYZE`: 此命令在增强型delta校准期间使用。详情请参阅[Delta校准](Delta_Calibrate.md)。

### [display]

当启用[display配置部分](Config_Reference.md#gcode_macro)时，以下命令可用。

#### SET_DISPLAY_GROUP
`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`: 设置液晶显示屏的活动显示组。这允许在配置中定义多个显示数据组，例如`[display_data <group> <elementname>]`，并使用此扩展gcode命令在它们之间切换。如果未指定DISPLAY，则默认为"display"（主显示屏）。

### [display_status]

如果启用了[display配置部分](Config_Reference.md#display)，则display_status模块会自动加载。它提供以下标准G-Code命令：
- 显示消息: `M117 <message>`
- 设置构建百分比: `M73 P<percent>`

还提供以下扩展G-Code命令：
- `SET_DISPLAY_TEXT MSG=<message>`: 执行与M117等效的操作，将提供的`MSG`设置为当前显示消息。如果省略`MSG`，则显示将被清除。

### [dual_carriage]

当启用[dual_carriage配置部分](Config_Reference.md#dual_carriage)时，以下命令可用。

#### SET_DUAL_CARRIAGE
`SET_DUAL_CARRIAGE CARRIAGE=<carriage> [MODE=[PRIMARY|COPY|MIRROR]]`: 此命令将更改指定滑架的模式。如果未提供`MODE`，则默认为`PRIMARY`。`<carriage>`必须引用为`generic_cartesian`运动学定义的主或双滑架，或为支持IDEX的所有其他运动学的0（主滑架）或1（双滑架）。将模式设置为`PRIMARY`会停用另一个滑架，并使指定滑架按原样执行后续G-Code命令。`COPY`和`MIRROR`模式仅支持双滑架。当设置为这些模式之一时，双滑架将跟踪其主滑架的后续移动，并在`COPY`模式下复制其相对移动，或在`MIRROR`模式下以相反（镜像）方向执行它们。

#### SAVE_DUAL_CARRIAGE_STATE
`SAVE_DUAL_CARRIAGE_STATE [NAME=<state_name>]`: 保存双滑架的当前位置及其模式。保存和恢复DUAL_CARRIAGE状态在脚本和宏中以及在归位例程覆盖中很有用。如果提供了NAME，则允许将保存的状态命名为给定字符串。如果未提供NAME，则默认为"default"。

#### RESTORE_DUAL_CARRIAGE_STATE
`RESTORE_DUAL_CARRIAGE_STATE [NAME=<state_name>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: 恢复先前保存的双滑架位置及其模式，除非指定了"MOVE=0"，在这种情况下仅恢复保存的模式，但不恢复滑架位置。如果正在恢复位置并且指定了"MOVE_SPEED"，则工具头移动将以给定速度（mm/s）执行；否则工具头移动将使用导轨归位速度。请注意，滑架仅在其自身轴上恢复其位置，这可能需要正确恢复双滑架的COPY和MIRROR模式。

### [endstop_phase]

当启用[endstop_phase配置部分](Config_Reference.md#endstop_phase)时（另请参阅[endstop相位指南](Endstop_Phase.md)），以下命令可用。

#### ENDSTOP_PHASE_CALIBRATE
`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]`: 如果未提供STEPPER参数，则此命令将报告过去归位操作期间限位开关步进电机的相位统计信息。当提供STEPPER参数时，它安排将给定的限位开关相位设置写入配置文件（与SAVE_CONFIG命令结合使用）。

### [exclude_object]

当启用[exclude_object配置部分](Config_Reference.md#exclude_object)时（另请参阅[排除对象指南](Exclude_Object.md)），以下命令可用：

#### `EXCLUDE_OBJECT`
`EXCLUDE_OBJECT [NAME=object_name] [CURRENT=1] [RESET=1]`:
不带参数时，这将返回当前排除的所有对象列表。

当给出`NAME`参数时，指定的对象将被排除打印。

当给出`CURRENT`参数时，当前对象将被排除打印。

当给出`RESET`参数时，排除的对象列表将被清除。另外包含`NAME`将仅重置指定的对象。这**可能**导致打印失败，如果已经跳过了某些层。

#### `EXCLUDE_OBJECT_DEFINE`
`EXCLUDE_OBJECT_DEFINE [NAME=object_name [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`:
提供文件中对象的摘要。

未提供参数时，这将列出Klipper已知的已定义对象。返回字符串列表，除非给出`JSON`参数，此时将以json格式返回对象详细信息。

当包含`NAME`参数时，这定义一个要排除的对象。

  - `NAME`: 此参数是必需的。它是本模块中其他命令使用的标识符。
  - `CENTER`: 对象的X,Y坐标。
  - `POLYGON`: 提供对象轮廓的X,Y坐标数组。

当提供`RESET`参数时，所有已定义的对象将被清除，`[exclude_object]`模块将被重置。

#### `EXCLUDE_OBJECT_START`
`EXCLUDE_OBJECT_START NAME=object_name`:
此命令接受一个`NAME`参数，并表示当前层对象gcode的开始。

#### `EXCLUDE_OBJECT_END`
`EXCLUDE_OBJECT_END [NAME=object_name]`:
表示对象gcode在该层的结束。它与`EXCLUDE_OBJECT_START`配对。`NAME`参数是可选的，仅当提供的名称与当前对象不匹配时会发出警告。

### [extruder]

如果启用了[extruder配置部分](Config_Reference.md#extruder)，则以下命令可用：

#### ACTIVATE_EXTRUDER
`ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: 在具有多个[extruder](Config_Reference.md#extruder)配置部分的打印机中，此命令更改活动的热端。

#### SET_PRESSURE_ADVANCE
`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: 设置挤出机步进电机的压力提前参数（如[extruder](Config_Reference.md#extruder)或[extruder_stepper](Config_Reference.md#extruder_stepper)配置部分中定义）。如果未指定EXTRUDER，则默认为活动热端中定义的步进电机。

#### SET_EXTRUDER_ROTATION_DISTANCE
`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: 为提供的挤出机步进电机设置新的"旋转距离"值（如[extruder](Config_Reference.md#extruder)或[extruder_stepper](Config_Reference.md#extruder_stepper)配置部分中定义）。如果旋转距离为负数，则步进电机运动将被反转（相对于配置文件中指定的步进电机方向）。更改的设置在Klipper重置后不会保留。请谨慎使用，因为小的变化可能导致挤出机和热端之间压力过大。使用前请进行适当的校准。如果未提供'DISTANCE'值，则此命令将返回当前旋转距离。

#### SYNC_EXTRUDER_MOTION
`SYNC_EXTRUDER_MOTION EXTRUDER=<name> MOTION_QUEUE=<name>`: 此命令将导致由EXTRUDER指定的步进电机（如[extruder](Config_Reference.md#extruder)或[extruder_stepper](Config_Reference.md#extruder_stepper)配置部分中定义）与由MOTION_QUEUE指定的挤出机（如[extruder](Config_Reference.md#extruder)配置部分中定义）的运动同步。如果MOTION_QUEUE为空字符串，则步进电机将与所有挤出机运动不同步。

### [fan_generic]

当启用[fan_generic配置部分](Config_Reference.md#fan_generic)时，以下命令可用。

#### SET_FAN_SPEED
`SET_FAN_SPEED FAN=config_name SPEED=<speed>` 此命令设置风扇速度。"speed"必须在0.0和1.0之间。

`SET_FAN_SPEED PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: 如果指定了`TEMPLATE`，则将[display_template](Config_Reference.md#display_template)分配给给定风扇。例如，如果定义了`[display_template my_fan_template]`配置部分，则可以在此处分配`TEMPLATE=my_fan_template`。display_template应生成包含浮点数的字符串，表示所需值。模板将连续评估，风扇将自动设置为结果速度。可以设置在模板评估期间使用的display_template参数（参数将被解析为Python字面量）。如果TEMPLATE为空字符串，则此命令将清除分配给引脚的任何先前模板（然后可以使用`SET_FAN_SPEED`命令直接管理值）。

### [filament_switch_sensor]

当启用[filament_switch_sensor](Config_Reference.md#filament_switch_sensor)或[filament_motion_sensor](Config_Reference.md#filament_motion_sensor)配置部分时，以下命令可用。

#### QUERY_FILAMENT_SENSOR
`QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`: 查询丝材传感器的当前状态。终端上显示的数据将取决于配置中定义的传感器类型。

#### SET_FILAMENT_SENSOR
`SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]`: 设置丝材传感器的开/关。如果ENABLE设置为0，丝材传感器将被禁用，如果设置为1，则启用。

### [firmware_retraction]

当启用[firmware_retraction配置部分](Config_Reference.md#firmware_retraction)时，以下标准G-Code命令可用。这些命令允许您利用许多切片软件中可用的固件回抽功能，以减少从打印的一个部分移动到另一个部分时的非挤出移动中的拉丝。适当配置压力提前可减少所需的回抽长度。
- `G10`: 使用当前配置的参数回抽挤出机。
- `G11`: 使用当前配置的参数取消回抽挤出机。

以下附加命令也可用。

#### SET_RETRACTION
`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>]`: 调整固件回抽使用的参数。RETRACT_LENGTH确定要回抽和取消回抽的丝材长度。回抽速度通过RETRACT_SPEED调整，通常设置得相对较高。取消回抽速度通过UNRETRACT_SPEED调整，不太关键，尽管通常低于RETRACT_SPEED。在某些情况下，取消回抽时添加少量额外长度很有用，这通过UNRETRACT_EXTRA_LENGTH设置。SET_RETRACTION通常作为切片软件每丝材配置的一部分设置，因为不同丝材需要不同的参数设置。

#### GET_RETRACTION
`GET_RETRACTION`: 查询固件回抽使用的当前参数并在终端上显示它们。

### [force_move]

force_move模块会自动加载，但某些命令需要在[打印机配置](Config_Reference.md#force_move)中设置`enable_force_move`。

#### STEPPER_BUZZ
`STEPPER_BUZZ STEPPER=<config_name>`: 将给定步进电机向前移动一毫米，然后向后移动一毫米，重复10次。这是一种诊断工具，有助于验证步进电机连接。

#### FORCE_MOVE
`FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]`: 此命令将强制给定步进电机以给定恒定速度（mm/s）移动给定距离（mm）。如果指定了ACCEL且大于零，则使用给定加速度（mm/s^2）；否则不执行加速度。不执行边界检查；不进行运动学更新；轴上的其他并行步进电机不会移动。请谨慎使用，因为错误的命令可能导致损坏！使用此命令几乎肯定会使底层运动学处于不正确状态；之后发出G28以重置运动学。此命令旨在用于底层诊断和调试。

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] [SET_HOMED=<[X][Y][Z]>] [CLEAR_HOMED=<[X][Y][Z]>]`: 强制底层运动学代码相信工具头处于给定笛卡尔位置并设置/清除归位状态。这是一个诊断和调试命令；使用SET_GCODE_OFFSET和/或G92进行常规轴变换。设置不正确或无效的位置可能导致内部软件错误。

`X`、`Y`和`Z`参数用于更改底层运动学位置跟踪。如果未设置这些参数中的任何一个，则位置不会更改 - 例如`SET_KINEMATIC_POSITION Z=10`将设置所有轴为归位，将内部Z位置设置为10，并保持X和Y位置不变。更改内部位置跟踪不依赖于内部归位状态 - 可以同时更改归位和未归位轴的位置，同样可以在不更改其内部位置的情况下设置或清除轴的归位状态。

`SET_HOMED`参数默认为`XYZ`，指示运动学将所有轴视为已归位。裸`SET_KINEMATIC_POSITION`命令将导致所有轴被视为已归位（且不更改其当前位置）。如果不想更改已归位轴的状态，则将`SET_HOMED`分配为空字符串 - 例如：`SET_KINEMATIC_POSITION SET_HOMED= X=10`。也可以请求将单个轴视为已归位（例如，`SET_HOMED=X`），但请注意，非笛卡尔式运动学（如delta运动学）可能不支持将单个轴设置为已归位。

`CLEAR_HOMED`参数指示运动学将给定轴视为未归位。例如，`CLEAR_HOMED=XYZ`将请求所有轴被视为未归位（因此在这些轴上的移动前需要归位）。即使存在`CLEAR_HOMED`，默认也是`SET_HOMED=XYZ`，因此命令`SET_KINEMATIC_POSITION CLEAR_HOMED=Z`将设置X和Y为已归位并清除Z的归位状态。如果目标是仅清除Z归位状态，请使用`SET_KINEMATIC_POSITION SET_HOMED= CLEAR_HOMED=Z`。如果轴未在`SET_HOMED`或`CLEAR_HOMED`中指定，则其归位状态不变，如果在两者中都指定，则`CLEAR_HOMED`优先。可以请求清除单个轴，但在非笛卡尔式运动学（如delta运动学）上这样做可能导致清除其他轴的归位状态。注意`CLEAR`参数目前是`CLEAR_HOMED`参数的别名，但此别名将在未来移除。

### [gcode]

gcode模块会自动加载。

#### RESTART
`RESTART`: 这将导致主机软件重新加载其配置并执行内部重置。此命令不会清除微控制器的错误状态（参见FIRMWARE_RESTART），也不会加载新软件（参见[常见问题解答](FAQ.md#how-do-i-upgrade-to-the-latest-software)）。

#### FIRMWARE_RESTART
`FIRMWARE_RESTART`: 这类似于RESTART命令，但它还会清除微控制器的任何错误状态。

#### STATUS
`STATUS`: 报告Klipper主机软件状态。

#### HELP
`HELP`: 报告可用的扩展G-Code命令列表。

### [gcode_arcs]

如果启用了[gcode_arcs配置部分](Config_Reference.md#gcode_arcs)，则以下标准G-Code命令可用：
- 顺时针弧线移动 (G2), 逆时针弧线移动 (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`
- 弧线平面选择: G17 (XY平面), G18 (XZ平面), G19 (YZ平面)

### [gcode_macro]

当启用[gcode_macro配置部分](Config_Reference.md#gcode_macro)时（另请参阅[命令模板指南](Command_Templates.md)），以下命令可用。

#### SET_GCODE_VARIABLE
`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`: 此命令允许在运行时更改gcode_macro变量的值。提供的VALUE被解析为Python字面量。

### [gcode_move]

gcode_move模块会自动加载。

#### GET_POSITION
`GET_POSITION`: 返回有关工具头当前位置的信息。更多信息请参阅[GET_POSITION输出](Code_Overview.md#coordinate-systems)的开发人员文档。

#### SET_GCODE_OFFSET
`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]`: 设置应用于未来G-Code命令的位置偏移。这通常用于虚拟更改Z床面偏移或在切换挤出机时设置喷嘴XY偏移。例如，如果发送"SET_GCODE_OFFSET Z=0.2"，则未来的G-Code移动将在其Z高度上增加0.2mm。如果使用X_ADJUST样式的参数，则调整将添加到任何现有偏移（例如，"SET_GCODE_OFFSET Z=-0.2"后跟"SET_GCODE_OFFSET Z_ADJUST=0.3"将导致总Z偏移为0.1）。如果指定了"MOVE=1"，则将发出工具头移动以应用给定偏移（否则偏移将在下一次指定给定轴的绝对G-Code移动时生效）。如果指定了"MOVE_SPEED"，则工具头移动将以给定速度（mm/s）执行；否则工具头移动将使用最后指定的G-Code速度。

#### SAVE_GCODE_STATE
`SAVE_GCODE_STATE [NAME=<state_name>]`: 保存当前g-code坐标解析状态。保存和恢复g-code状态在脚本和宏中很有用。此命令保存当前g-code绝对坐标模式（G90/G91）、绝对挤出模式（M82/M83）、原点（G92）、偏移（SET_GCODE_OFFSET）、速度覆盖（M220）、挤出机覆盖（M221）、移动速度、当前XYZ位置和相对挤出机"E"位置。如果提供了NAME，则允许将保存的状态命名为给定字符串。如果未提供NAME，则默认为"default"。

#### RESTORE_GCODE_STATE
`RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`: 恢复先前通过SAVE_GCODE_STATE保存的状态。如果指定了"MOVE=1"，则将发出工具头移动以移回之前的XYZ位置。如果指定了"MOVE_SPEED"，则工具头移动将以给定速度（mm/s）执行；否则工具头移动将使用恢复的g-code速度。

### [generic_cartesian]
当指定`kinematics: generic_cartesian`作为打印机运动学时，此部分中的命令将自动可用。

#### SET_STEPPER_CARRIAGES
`SET_STEPPER_CARRIAGES STEPPER=<stepper_name> CARRIAGES=<carriages> [DISABLE_CHECKS=[0|1]]`: 设置或更新步进电机滑架。`<stepper_name>`必须引用在`printer.cfg`中定义的现有步进电机，`<carriages>`描述步进电机移动的滑架。有关配置部分中`carriages`参数的更详细概述，请参阅[通用笛卡尔运动学](Config_Reference.md#generic-cartesian-kinematics)。请注意，使用此命令只能更改滑架的系数或符号，但用户不能添加或删除步进电机控制的滑架。

`SET_STEPPER_CARRIAGES`是一个高级工具，建议用户使用时极度谨慎，因为指定不正确的配置可能会物理损坏打印机。

请注意，`SET_STEPPER_CARRIAGES`在更改后会对新的打印机运动学执行某些内部验证。请记住，如果检测到问题，可能会使打印机运动学处于无效状态。这意味着如果`SET_STEPPER_CARRIAGES`报告错误，则发出其他GCode命令是不安全的，用户必须检查错误消息并修复问题，或手动恢复先前的步进电机配置。

由于`SET_STEPPER_CARRIAGES`一次只能更新单个步进电机的配置，某些更改序列可能会导致无效的中间运动学配置，即使最终配置是有效的。在这种情况下，用户可以在除最后一个命令外的所有命令中传递`DISABLE_CHECKS=1`参数以禁用中间检查。例如，如果`stepper a`和`stepper b`最初分别有`x-y`和`x+y`滑架，则以下命令序列将允许用户有效地交换滑架控制：
`SET_STEPPER_CARRIAGES STEPPER=a CARRIAGES=x+y DISABLE_CHECKS=1`
和 `SET_STEPPER_CARRIAGES STEPPER=b CARRIAGES=x-y`，同时仍然验证最终的运动学状态。

### [hall_filament_width_sensor]

当启用[tsl1401cl丝材宽度传感器配置部分](Config_Reference.md#tsl1401cl_filament_width_sensor)或[霍尔丝材宽度传感器配置部分](Config_Reference.md#hall_filament_width_sensor)时（另请参阅[TSLl401CL丝材宽度传感器](TSL1401CL_Filament_Width_Sensor.md)和[霍尔丝材宽度传感器](Hall_Filament_Width_Sensor.md)），以下命令可用：

#### QUERY_FILAMENT_WIDTH
`QUERY_FILAMENT_WIDTH`: 返回当前测量的丝材宽度。

#### RESET_FILAMENT_WIDTH_SENSOR
`RESET_FILAMENT_WIDTH_SENSOR`: 清除所有传感器读数。更换丝材后很有帮助。

#### DISABLE_FILAMENT_WIDTH_SENSOR
`DISABLE_FILAMENT_WIDTH_SENSOR`: 关闭丝材宽度传感器并停止使用它进行流量控制。

#### ENABLE_FILAMENT_WIDTH_SENSOR
`ENABLE_FILAMENT_WIDTH_SENSOR`: 打开丝材宽度传感器并开始使用它进行流量控制。

#### QUERY_RAW_FILAMENT_WIDTH
`QUERY_RAW_FILAMENT_WIDTH`: 返回当前ADC通道读数和用于校准点的RAW传感器值。

#### ENABLE_FILAMENT_WIDTH_LOG
`ENABLE_FILAMENT_WIDTH_LOG`: 打开直径日志记录。

#### DISABLE_FILAMENT_WIDTH_LOG
`DISABLE_FILAMENT_WIDTH_LOG`: 关闭直径日志记录。

### [heaters]

如果在配置文件中定义了加热器，则heaters模块会自动加载。

#### TURN_OFF_HEATERS
`TURN_OFF_HEATERS`: 关闭所有加热器。

#### TEMPERATURE_WAIT
`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: 等待直到给定温度传感器达到或高于提供的MINIMUM和/或达到或低于提供的MAXIMUM。

#### SET_HEATER_TEMPERATURE
`SET_HEATER_TEMPERATURE HEATER=<heater_name> [TARGET=<target_temperature>]`: 设置加热器的目标温度。如果未提供目标温度，则目标为0。

### [idle_timeout]

idle_timeout模块会自动加载。

#### SET_IDLE_TIMEOUT
`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: 允许用户设置空闲超时（以秒为单位）。

### [input_shaper]

如果启用了[input_shaper配置部分](Config_Reference.md#input_shaper)（另请参阅[共振补偿指南](Resonance_Compensation.md)），则启用以下命令。

#### SET_INPUT_SHAPER
`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`: 修改输入整形器参数。请注意，SHAPER_TYPE参数会重置X和Y轴的输入整形器，即使在[input_shaper]部分中配置了不同的整形器类型。SHAPER_TYPE不能与SHAPER_TYPE_X和SHAPER_TYPE_Y参数一起使用。有关每个参数的更多详细信息，请参阅[配置参考](Config_Reference.md#input_shaper)。

### [led]

当启用任何[led配置部分](Config_Reference.md#leds)时，以下命令可用。

#### SET_LED
`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: 这设置LED输出。每个颜色`<value>`必须在0.0和1.0之间。WHITE选项仅对RGBW LED有效。如果LED支持菊花链中的多个芯片，则可以指定INDEX来仅更改给定芯片的颜色（1为第一个芯片，2为第二个，等等）。如果未提供INDEX，则菊花链中的所有LED将设置为提供的颜色。如果指定了TRANSMIT=0，则颜色更改仅在下一个未指定TRANSMIT=0的SET_LED命令时进行；这可能与INDEX参数结合使用，以在菊花链中批量更新。默认情况下，SET_LED命令会将其更改与其他正在进行的gcode命令同步。如果在打印机不打印时设置LED，这可能导致不良行为，因为它会重置空闲超时。如果不需要仔细定时，可以指定可选的SYNC=0参数以应用更改而不重置空闲超时。

#### SET_LED_TEMPLATE
`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: 将[display_template](Config_Reference.md#display_template)分配给给定[LED](Config_Reference.md#leds)。例如，如果定义了`[display_template my_led_template]`配置部分，则可以在此处分配`TEMPLATE=my_led_template`。display_template应生成包含四个浮点数的逗号分隔字符串，对应于红、绿、蓝和白颜色设置。模板将连续评估，LED将自动设置为结果颜色。可以设置在模板评估期间使用的display_template参数（参数将被解析为Python字面量）。如果未指定INDEX，则LED菊花链中的所有芯片将设置为模板，否则仅更新具有给定索引的芯片。如果TEMPLATE为空字符串，则此命令将清除分配给LED的任何先前模板（然后可以使用`SET_LED`命令管理LED的颜色设置）。

### [load_cell]

如果启用了[load_cell配置部分](Config_Reference.md#load_cell)，则启用以下命令。

### LOAD_CELL_DIAGNOSTIC
`LOAD_CELL_DIAGNOSTIC [LOAD_CELL=<config_name>]`: 此命令收集10秒的称重传感器数据，并报告统计信息，帮助您验证称重传感器的正常运行。此命令可以在已校准和未校准的称重传感器上运行。

### LOAD_CELL_CALIBRATE
`LOAD_CELL_CALIBRATE [LOAD_CELL=<config_name>]`: 启动引导校准实用程序。校准是一个三步过程：
1. 首先从称重传感器上移除所有负载并运行`TARE`命令
2. 接着在称重传感器上施加已知负载并运行`CALIBRATE GRAMS=nnn`命令
3. 最后使用`ACCEPT`命令保存结果

您可以随时使用`ABORT`取消校准过程。

### LOAD_CELL_TARE
`LOAD_CELL_TARE [LOAD_CELL=<config_name>]`: 这就像数字秤上的去皮按钮。它将称重传感器的当前原始读数设置为零点参考值。响应是传感器范围的百分比和以计数为单位的原始值。如果称重传感器已校准，则还会报告以克为单位的力。

### LOAD_CELL_READ load_cell="name"
`LOAD_CELL_READ [LOAD_CELL=<config_name>]`:
此命令从称重传感器获取读数。响应是传感器范围的百分比和以计数为单位的原始值。如果称重传感器已校准，则还会报告以克为单位的力。

### [load_cell_probe]

如果启用了[load_cell配置部分](Config_Reference.md#load_cell_probe)，则启用以下命令。

### LOAD_CELL_TEST_TAP
`LOAD_CELL_TEST_TAP [TAPS=<taps>] [TIMEOUT=<timeout>]`: 运行一个测试例程，报告称重传感器上的敲击。工具头不会移动，但称重传感器探头会像探测一样感应敲击。这可以用作健全性检查，以确保探头正常工作。此工具取代了称重传感器探头的QUERY_ENDSTOPS和QUERY_PROBE。
- `TAPS`: 工具期望的敲击次数
- `TIMEOUT`: 工具在每次敲击前等待的秒数，超时则中止。

### 称重传感器命令扩展
执行探测的命令，如[`PROBE`](#probe)、[`PROBE_ACCURACY`](#probe_accuracy)、[`BED_MESH_CALIBRATE`](#bed_mesh_calibrate)等，如果定义了`[load_cell_probe]`，则会接受额外参数。这些参数会覆盖来自[`[load_cell_probe]`](./Config_Reference.md#load_cell_probe)配置的相应设置：
- `FORCE_SAFETY_LIMIT=<grams>`
- `TRIGGER_FORCE=<grams>`
- `DRIFT_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `DRIFT_FILTER_DELAY=<1|2>`
- `BUZZ_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `BUZZ_FILTER_DELAY=<1|2>`
- `NOTCH_FILTER_FREQUENCIES=<list of frequency_hz>`
- `NOTCH_FILTER_QUALITY=<quality>`
- `TARE_TIME=<seconds>`

### [manual_probe]

manual_probe模块会自动加载。

#### MANUAL_PROBE
`MANUAL_PROBE [SPEED=<speed>]`: 运行一个有用的辅助脚本，用于测量喷嘴在给定位置的高度。如果指定了SPEED，则设置TESTZ命令的速度（默认为5mm/s）。在手动探测期间，以下附加命令可用：
- `ACCEPT`: 此命令接受当前Z位置并结束手动探测工具。
- `ABORT`: 此命令终止手动探测工具。
- `TESTZ Z=<value>`: 此命令将喷嘴向上或向下移动"值"中指定的数量。例如，`TESTZ Z=-.1`将喷嘴向下移动0.1mm，而`TESTZ Z=.1`将喷嘴向上移动0.1mm。值也可以是`+`、`-`、`++`或`--`，以相对于先前尝试向上或向下移动喷嘴。

#### Z_ENDSTOP_CALIBRATE
`Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: 运行一个有用的辅助脚本，用于校准Z位置限位开关配置设置。有关参数和工具激活时可用的附加命令的详细信息，请参阅MANUAL_PROBE命令。

#### Z_OFFSET_APPLY_ENDSTOP
`Z_OFFSET_APPLY_ENDSTOP`: 取当前Z Gcode偏移（即，微调），并从stepper_z endstop_position中减去它。这起到将常用微调值"永久化"的作用。需要`SAVE_CONFIG`才能生效。

### [manual_stepper]

当启用[manual_stepper配置部分](Config_Reference.md#manual_stepper)时，以下命令可用。

#### MANUAL_STEPPER
`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]]`: 此命令将更改步进电机的状态。使用ENABLE参数启用/禁用步进电机。使用SET_POSITION参数强制步进电机认为它处于给定位置。使用MOVE参数请求移动到给定位置。如果指定了SPEED和/或ACCEL，则使用给定值而不是配置文件中指定的默认值。如果指定了零加速度，则不执行加速度。如果指定了STOP_ON_ENDSTOP=1，则移动将在限位开关报告触发时提前结束（使用STOP_ON_ENDSTOP=2即使限位开关未触发也完成移动而不报错，使用-1或-2在限位开关报告未触发时停止）。通常，未来的G-Code命令将在步进电机移动完成后调度运行，但如果手动步进电机移动使用SYNC=0，则未来的G-Code移动命令可能与步进电机移动并行运行。

`MANUAL_STEPPER STEPPER=config_name GCODE_AXIS=[A-Z] [LIMIT_VELOCITY=<velocity>] [LIMIT_ACCEL=<accel>] [INSTANTANEOUS_CORNER_VELOCITY=<velocity>]`: 如果指定了`GCODE_AXIS`参数，则它将步进电机配置为`G1`移动命令上的额外轴。例如，如果发出`MANUAL_STEPPER ... GCODE_AXIS=R`命令，则可以发出`G1 X10 Y20 R30`之类的命令来移动步进电机。结果移动将与相关工具头xyz移动同步。如果电机与`GCODE_AXIS`关联，则不能再使用上述`MANUAL_STEPPER`命令发出移动 - 可以使用`MANUAL_STEPPER ... GCODE_AXIS=`命令注销步进电机以恢复手动控制电机。`LIMIT_VELOCITY`和`LIMIT_ACCEL`参数允许在`G1`移动可能导致速度或加速度超过指定限制时降低速度。`INSTANTANEOUS_CORNER_VELOCITY`指定电机在两个移动连接处的最大瞬时速度变化（mm/s）（默认为1mm/s）。

### [mcp4018]

当启用 [mcp4018 配置部分](Config_Reference.md#mcp4018) 时，以下命令可用。

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=配置名称 WIPER=<值>`：此命令将更改数字电位器的当前值。该值通常应在 0.0 到 1.0 之间，除非在配置中定义了“scale”（比例）。当定义了“scale”时，该值应在 0.0 到“scale”之间。

### [output_pin]

当启用 [output_pin 配置部分](Config_Reference.md#output_pin) 或 [pwm_tool 配置部分](Config_Reference.md#pwm_tool) 时，以下命令可用。

#### SET_PIN
`SET_PIN PIN=配置名称 VALUE=<值>`：将引脚设置为给定的输出 `VALUE`。对于“数字”输出引脚，VALUE 应为 0 或 1。对于 PWM 引脚，将其设置为 0.0 到 1.0 之间的值，或者如果在 output_pin 配置部分中配置了 `scale`，则设置为 0.0 到 `scale` 之间的值。

`SET_PIN PIN=配置名称 TEMPLATE=<模板名称> [<param_x>=<字面值>]`：如果指定了 `TEMPLATE`，则会将 [display_template](Config_Reference.md#display_template) 分配给指定引脚。例如，如果定义了 `[display_template my_pin_template]` 配置部分，则可以在此处分配 `TEMPLATE=my_pin_template`。display_template 应生成一个包含浮点数的字符串，该数为所需值。模板将被持续求值，引脚将自动设置为求值结果。可以设置 display_template 参数以在模板求值期间使用（参数将被解析为 Python 字面值）。如果 TEMPLATE 为空字符串，则此命令将清除之前分配给该引脚的任何模板（然后可以使用 `SET_PIN` 命令直接管理值）。

### [palette2]

当启用 [palette2 配置部分](Config_Reference.md#palette2) 时，以下命令可用。

调色板打印通过在 GCode 文件中嵌入特殊的 OCodes（Omega Codes）来工作：
- `O1`...`O32`：这些代码从 GCode 流中读取，并由该模块处理，然后传递给 Palette 2 设备。

以下附加命令也可用。

#### PALETTE_CONNECT
`PALETTE_CONNECT`：此命令初始化与 Palette 2 的连接。

#### PALETTE_DISCONNECT
`PALETTE_DISCONNECT`：此命令断开与 Palette 2 的连接。

#### PALETTE_CLEAR
`PALETTE_CLEAR`：此命令指示 Palette 2 清除所有输入和输出路径中的耗材。

#### PALETTE_CUT
`PALETTE_CUT`：此命令指示 Palette 2 切断当前装入拼接核心中的耗材。

#### PALETTE_SMART_LOAD
`PALETTE_SMART_LOAD`：此命令在 Palette 2 上启动智能装料序列。耗材通过挤出设备为打印机校准的距离自动装料，并在装料完成后通知 Palette 2。此命令等同于在耗材装料完成后直接在 Palette 2 屏幕上按“智能装料”。

### [pause_resume]

当启用 [pause_resume 配置部分](Config_Reference.md#pause_resume) 时，以下命令可用：

#### PAUSE
`PAUSE`：暂停当前打印。当前坐标将被捕获，以便在恢复时还原。

#### RESUME
`RESUME [VELOCITY=<值>]`：从暂停中恢复打印，首先恢复之前捕获的位置。VELOCITY 参数确定工具返回原始捕获位置的速度。

#### CLEAR_PAUSE
`CLEAR_PAUSE`：清除当前暂停状态而不恢复打印。如果在 PAUSE 后决定取消打印，这将非常有用。建议将其添加到启动 gcode 中，以确保每次打印的暂停状态都是全新的。

#### CANCEL_PRINT
`CANCEL_PRINT`：取消当前打印。

### [pid_calibrate]

如果在配置文件中定义了加热器，则 pid_calibrate 模块会自动加载。

#### PID_CALIBRATE
`PID_CALIBRATE HEATER=<配置名称> TARGET=<温度> [WRITE_FILE=1]`：执行 PID 校准测试。指定的加热器将被启用，直到达到指定的目标温度，然后加热器将关闭和开启多个周期。如果启用了 WRITE_FILE 参数，则将创建文件 /tmp/heattest.txt，其中包含测试期间所有温度样本的日志。

### [print_stats]

print_stats 模块会自动加载。

#### SET_PRINT_STATS_INFO
`SET_PRINT_STATS_INFO [TOTAL_LAYER=<总层数>] [CURRENT_LAYER= <当前层>]`：将切片器信息（如当前层和总层数）传递给 Klipper。在切片器的启动 gcode 部分添加 `SET_PRINT_STATS_INFO [TOTAL_LAYER=<总层数>]`，并在层变更 gcode 部分添加 `SET_PRINT_STATS_INFO [CURRENT_LAYER= <当前层>]`，以将层信息从切片器传递给 Klipper。

### [probe]

当启用 [probe 配置部分](Config_Reference.md#probe) 或 [bltouch 配置部分](Config_Reference.md#bltouch) 时（另请参阅 [探针校准指南](Probe_Calibrate.md)），以下命令可用。

#### PROBE
`PROBE [PROBE_SPEED=<毫米/秒>] [LIFT_SPEED=<毫米/秒>] [SAMPLES=<数量>] [SAMPLE_RETRACT_DIST=<毫米>] [SAMPLES_TOLERANCE=<毫米>] [SAMPLES_TOLERANCE_RETRIES=<数量>] [SAMPLES_RESULT=median|average]`：将喷嘴向下移动，直到探针触发。如果提供了任何可选参数，它们将覆盖 [probe 配置部分](Config_Reference.md#probe) 中的等效设置。

#### QUERY_PROBE
`QUERY_PROBE`：报告探针的当前状态（“已触发”或“未触发”）。

#### PROBE_ACCURACY
`PROBE_ACCURACY [PROBE_SPEED=<毫米/秒>] [SAMPLES=<数量>] [SAMPLE_RETRACT_DIST=<毫米>]`：计算多个探针样本的最大值、最小值、平均值、中位数和标准偏差。默认情况下，采集 10 个样本。否则，可选参数默认为探针配置部分中的等效设置。

#### PROBE_CALIBRATE
`PROBE_CALIBRATE [SPEED=<速度>] [<探针参数>=<值>]`：运行一个有助于校准探针 z_offset 的辅助脚本。有关可选探针参数的详细信息，请参阅 PROBE 命令。有关 SPEED 参数以及工具激活时可用的附加命令的详细信息，请参阅 MANUAL_PROBE 命令。请注意，PROBE_CALIBRATE 命令使用速度变量在 XY 方向和 Z 方向上移动。

#### Z_OFFSET_APPLY_PROBE
`Z_OFFSET_APPLY_PROBE`：获取当前 Z Gcode 偏移（即，微步调整），并从探针的 z_offset 中减去它。这相当于将常用的微步调整值“永久化”。需要使用 `SAVE_CONFIG` 命令才能生效。

### [probe_eddy_current]

当启用 [probe_eddy_current 配置部分](Config_Reference.md#probe_eddy_current) 时，以下命令可用。

#### PROBE_EDDY_CURRENT_CALIBRATE
`PROBE_EDDY_CURRENT_CALIBRATE CHIP=<配置名称>`：此命令启动一个工具，用于校准传感器的共振频率到相应的 Z 高度。该工具需要几分钟才能完成。完成后，使用 SAVE_CONFIG 命令将结果存储在 printer.cfg 文件中。

#### LDC_CALIBRATE_DRIVE_CURRENT
`LDC_CALIBRATE_DRIVE_CURRENT CHIP=<配置名称>` 此工具将校准 ldc1612 DRIVE_CURRENT0 寄存器。在使用此工具之前，移动传感器，使其位于床中心附近，并距离床表面约 20mm。运行此命令以确定传感器的适当 DRIVE_CURRENT。运行此命令后，使用 SAVE_CONFIG 命令将新设置存储在 printer.cfg 配置文件中。

### [pwm_cycle_time]

当启用 [pwm_cycle_time 配置部分](Config_Reference.md#pwm_cycle_time) 时，以下命令可用。

#### SET_PIN
`SET_PIN PIN=配置名称 VALUE=<值> [CYCLE_TIME=<周期时间>]`：此命令的工作方式类似于 [output_pin](#output_pin) 的 SET_PIN 命令。此处的命令支持使用 CYCLE_TIME 参数（以秒为单位）设置显式周期时间。请注意，CYCLE_TIME 参数不会在 SET_PIN 命令之间存储（任何没有显式 CYCLE_TIME 参数的 SET_PIN 命令将使用 pwm_cycle_time 配置部分中指定的 `cycle_time`）。

### [quad_gantry_level]

当启用 [quad_gantry_level 配置部分](Config_Reference.md#quad_gantry_level) 时，以下命令可用。

#### QUAD_GANTRY_LEVEL
`QUAD_GANTRY_LEVEL [RETRIES=<值>] [RETRY_TOLERANCE=<值>] [HORIZONTAL_MOVE_Z=<值>] [<探针参数>=<值>]`：此命令将探测配置中指定的点，然后对每个 Z 步进电机进行独立调整，以补偿倾斜。有关可选探针参数的详细信息，请参阅 PROBE 命令。可选的 `RETRIES`、`RETRY_TOLERANCE` 和 `HORIZONTAL_MOVE_Z` 值将覆盖配置文件中指定的选项。

### [query_adc]

query_adc 模块会自动加载。

#### QUERY_ADC
`QUERY_ADC [NAME=<配置名称>] [PULLUP=<值>]`：报告为配置的模拟引脚接收到的最后一个模拟值。如果未提供 NAME，则报告可用的 adc 名称列表。如果提供了 PULLUP（以欧姆为单位的值），则报告原始模拟值以及给定上拉的等效电阻。

### [query_endstops]

query_endstops 模块会自动加载。当前可用以下标准 G-Code 命令，但不建议使用它们：
- 获取限位开关状态：`M119`（请改用 QUERY_ENDSTOPS。）

#### QUERY_ENDSTOPS
`QUERY_ENDSTOPS`：探测轴限位开关并报告它们是“已触发”还是“未触发”状态。此命令通常用于验证限位开关是否正常工作。

### [resonance_tester]

当启用 [resonance_tester 配置部分](Config_Reference.md#resonance_tester) 时（另请参阅 [测量共振指南](Measuring_Resonances.md)），以下命令可用。

#### MEASURE_AXES_NOISE
`MEASURE_AXES_NOISE`：测量并输出所有启用的加速度计芯片的所有轴的噪声。

#### TEST_RESONANCES
`TEST_RESONANCES AXIS=<轴> [OUTPUT=<共振,原始数据>] [NAME=<名称>] [FREQ_START=<最小频率>] [FREQ_END=<最大频率>] [ACCEL_PER_HZ=<每赫兹加速度>] [HZ_PER_SEC=<每秒赫兹>] [CHIPS=<芯片名称>] [POINT=x,y,z] [INPUT_SHAPING=<0:1>]`：在请求的“轴”上运行共振测试，并使用为相应轴配置的加速度计芯片测量加速度。"轴"可以是 X 或 Y，或通过 `AXIS=dx,dy` 指定任意方向，其中 dx 和 dy 是定义方向向量的浮点数（例如 `AXIS=X`、`AXIS=Y` 或 `AXIS=1,-1` 以定义对角线方向）。请注意，`AXIS=dx,dy` 和 `AXIS=-dx,-dy` 是等效的。`芯片名称` 可以是一个或多个配置的加速度计芯片，用逗号分隔，例如 `CHIPS="adxl345, adxl345 rpi"`。如果指定了 POINT，则将覆盖 `[resonance_tester]` 中配置的点。如果 `INPUT_SHAPING=0` 或未设置（默认），则在共振测试期间禁用输入整形，因为启用输入整形时运行共振测试是无效的。`OUTPUT` 参数是将要写入的输出的逗号分隔列表。如果请求了 `原始数据`，则原始加速度计数据将写入一个或一系列文件 `/tmp/raw_data_<轴>_[<芯片名称>_][<点>_]<名称>.csv`（只有在配置了多个探测点或指定了 POINT 时，名称中才会包含 `<点>_` 部分）。如果指定了 `共振`，则计算频率响应（跨所有探测点）并写入 `/tmp/resonances_<轴>_<名称>.csv` 文件。如果未设置，OUTPUT 默认为 `共振`，NAME 默认为当前时间，格式为 "YYYYMMDD_HHMMSS"。

#### SHAPER_CALIBRATE
`SHAPER_CALIBRATE [AXIS=<轴>] [NAME=<名称>] [FREQ_START=<最小频率>] [FREQ_END=<最大频率>] [ACCEL_PER_HZ=<每赫兹加速度>][HZ_PER_SEC=<每秒赫兹>] [CHIPS=<芯片名称>] [MAX_SMOOTHING=<最大平滑>] [INPUT_SHAPING=<0:1>]`：类似于 `TEST_RESONANCES`，运行配置的共振测试，并尝试为请求的轴（如果未设置 `AXIS` 参数，则为 X 和 Y 轴）找到输入整形器的最佳参数。如果未设置 `MAX_SMOOTHING`，则其值取自 `[resonance_tester]` 部分，默认为未设置。有关此功能的更多详细信息，请参阅测量共振指南中的 [最大平滑](Measuring_Resonances.md#max-smoothing)。调优结果将打印到控制台，频率响应和不同的输入整形器值将写入 CSV 文件 `/tmp/calibration_data_<轴>_<名称>.csv`。除非另有指定，NAME 默认为当前时间，格式为 "YYYYMMDD_HHMMSS"。请注意，通过发出 `SAVE_CONFIG` 命令，可以将建议的输入整形器参数持久化到配置中，如果之前已启用 `[input_shaper]`，这些参数将立即生效。

### [respond]

当启用 [respond 配置部分](Config_Reference.md#respond) 时，以下标准 G-Code 命令可用：
- `M118 <消息>`：回显消息，前面加上配置的默认前缀（如果没有配置前缀，则为 `echo: `）。

以下附加命令也可用。

#### RESPOND
- `RESPOND MSG="<消息>"`：回显消息，前面加上配置的默认前缀（如果没有配置前缀，则为 `echo: `）。
- `RESPOND TYPE=echo MSG="<消息>"`：回显消息，前面加上 `echo: `。
- `RESPOND TYPE=echo_no_space MSG="<消息>"`：回显消息，前面加上 `echo:`，前缀和消息之间没有空格，有助于与某些期望特定格式的 Octoprint 插件兼容。
- `RESPOND TYPE=command MSG="<消息>"`：回显消息，前面加上 `// `。可以配置 OctoPrint 来响应这些消息（例如 `RESPOND TYPE=command MSG=action:pause`）。
- `RESPOND TYPE=error MSG="<消息>"`：回显消息，前面加上 `!! `。
- `RESPOND PREFIX=<前缀> MSG="<消息>"`：回显消息，前面加上 `<前缀>`。（`PREFIX` 参数将优先于 `TYPE` 参数）

### [save_variables]

如果启用了 [save_variables 配置部分](Config_Reference.md#save_variables)，则启用以下命令。

#### SAVE_VARIABLE
`SAVE_VARIABLE VARIABLE=<名称> VALUE=<值>`：将变量保存到磁盘，以便跨重启使用。VARIABLE 必须为小写。所有存储的变量在启动时都会加载到 `printer.save_variables.variables` 字典中，并可用于 gcode 宏。提供的 VALUE 将被解析为 Python 字面值。

### [screws_tilt_adjust]

当启用 [screws_tilt_adjust 配置部分](Config_Reference.md#screws_tilt_adjust) 时（另请参阅 [手动调平指南](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)），以下命令可用。

#### SCREWS_TILT_CALCULATE
`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<值>] [HORIZONTAL_MOVE_Z=<值>] [<探针参数>=<值>]`：此命令将调用床螺丝调整工具。它将命令喷嘴到不同的位置（如配置文件中定义），探测 z 高度并计算旋钮转动的圈数以调整床的水平。如果指定了 DIRECTION，则所有旋钮转动都将朝同一方向，顺时针 (CW) 或逆时针 (CCW)。有关可选探针参数的详细信息，请参阅 PROBE 命令。重要提示：在使用此命令之前，必须始终先执行 G28。如果指定了 MAX_DEVIATION，则当任何螺丝高度与基准螺丝高度的差异大于提供的值时，命令将引发 gcode 错误。可选的 `HORIZONTAL_MOVE_Z` 值将覆盖配置文件中指定的 `horizontal_move_z` 选项。

### [sdcard_loop]

当启用 [sdcard_loop 配置部分](Config_Reference.md#sdcard_loop) 时，以下扩展命令可用。

#### SDCARD_LOOP_BEGIN
`SDCARD_LOOP_BEGIN COUNT=<数量>`：开始 SD 打印中的循环部分。数量为 0 表示该部分应无限循环。

#### SDCARD_LOOP_END
`SDCARD_LOOP_END`：结束 SD 打印中的循环部分。

#### SDCARD_LOOP_DESIST
`SDCARD_LOOP_DESIST`：完成现有循环，不再进行进一步迭代。

### [servo]

当启用 [servo 配置部分](Config_Reference.md#servo) 时，以下命令可用。

#### SET_SERVO
`SET_SERVO SERVO=配置名称 [ANGLE=<度数> | WIDTH=<秒>]`：将伺服位置设置为给定的角度（以度为单位）或脉冲宽度（以秒为单位）。使用 `WIDTH=0` 禁用伺服输出。

### [skew_correction]

当启用 [skew_correction 配置部分](Config_Reference.md#skew_correction) 时（另请参阅 [斜度校正](Skew_Correction.md) 指南），以下命令可用。

#### SET_SKEW
`SET_SKEW [XY=<ac长度,bd长度,ad长度>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`：使用从校准打印中获取的测量值（以毫米为单位）配置 [skew_correction] 模块。可以输入任意平面组合的测量值，未输入的平面将保留其当前值。如果输入 `CLEAR=1`，则将禁用所有斜度校正。

#### GET_CURRENT_SKEW
`GET_CURRENT_SKEW`：以弧度和度为单位报告每个平面的当前打印机斜度。斜度基于通过 `SET_SKEW` gcode 提供的参数计算。

#### CALC_MEASURED_SKEW
`CALC_MEASURED_SKEW [AC=<ac长度>] [BD=<bd长度>] [AD=<ad长度>]`：根据测量的打印计算并报告斜度（以弧度和度为单位）。这有助于在应用校正后确定打印机的当前斜度。在校正应用之前，它也可能有助于确定是否需要斜度校正。有关斜度校正对象和测量的详细信息，请参阅 [斜度校正](Skew_Correction.md)。

#### SKEW_PROFILE
`SKEW_PROFILE [LOAD=<名称>] [SAVE=<名称>] [REMOVE=<名称>]`：用于斜度校正的配置文件管理。LOAD 将从匹配所提供名称的配置文件中恢复斜度状态。SAVE 将当前斜度状态保存到匹配所提供名称的配置文件中。Remove 将从持久内存中删除匹配所提供名称的配置文件。请注意，在运行 SAVE 或 REMOVE 操作后，必须运行 SAVE_CONFIG gcode 才能使对持久内存的更改永久生效。

### [smart_effector]

当启用 [smart_effector 配置部分](Config_Reference.md#smart_effector) 时，有多个命令可用。在更改 Smart Effector 参数之前，请务必查阅 Duet3D Wiki 上关于 Smart Effector 的官方文档。另请参阅 [探针校准指南](Probe_Calibrate.md)。

#### SET_SMART_EFFECTOR
`SET_SMART_EFFECTOR [SENSITIVITY=<灵敏度>] [ACCEL=<加速度>] [RECOVERY_TIME=<时间>]`：设置 Smart Effector 参数。当指定 `SENSITIVITY` 时，相应值将写入 SmartEffector EEPROM（需要提供 `control_pin`）。可接受的 `<灵敏度>` 值为 0..255，默认值为 50。较低的值需要较小的喷嘴接触力来触发（但在探测期间由于振动导致误触发的风险较高），较高的值减少误触发（但需要较大的接触力来触发）。由于灵敏度写入 EEPROM，因此在关机后仍会保留，因此无需在每次打印机启动时进行配置。`ACCEL` 和 `RECOVERY_TIME` 允许在运行时覆盖相应参数，有关这些参数的更多信息，请参阅 Smart Effector 的 [配置部分](Config_Reference.md#smart_effector)。

#### RESET_SMART_EFFECTOR
`RESET_SMART_EFFECTOR`：将 Smart Effector 灵敏度重置为其出厂设置。需要在配置部分中提供 `control_pin`。

### [stepper_enable]

stepper_enable 模块会自动加载。

#### SET_STEPPER_ENABLE
`SET_STEPPER_ENABLE STEPPER=<配置名称> ENABLE=[0|1]`：仅启用或禁用指定的步进电机。这是一个诊断和调试工具，必须谨慎使用。禁用轴电机不会重置归位信息。手动移动禁用的步进电机可能会导致机器在安全限值之外操作电机。这可能会损坏轴组件、热端和打印表面。

### [temperature_fan]

当启用 [temperature_fan 配置部分](Config_Reference.md#temperature_fan) 时，以下命令可用。

#### SET_TEMPERATURE_FAN_TARGET
`SET_TEMPERATURE_FAN_TARGET temperature_fan=<温度风扇名称> [target=<目标温度>] [min_speed=<最小速度>] [max_speed=<最大速度>]`：设置温度风扇的目标温度。如果未提供目标，则设置为配置文件中指定的温度。如果未提供速度，则不进行更改。

### [temperature_probe]

当启用 [temperature_probe 配置部分](Config_Reference.md#temperature_probe) 时，以下命令可用。

#### TEMPERATURE_PROBE_CALIBRATE
`TEMPERATURE_PROBE_CALIBRATE [PROBE=<探针名称>] [TARGET=<值>] [STEP=<值>]`：启动基于涡流的探针的漂移校准。`TARGET` 是最后一个样本的目标温度。当样本记录的温度超过 `TARGET` 时，校准将完成。`STEP` 参数设置样本之间的温度增量（以摄氏度为单位）。采集样本后，此增量用于安排调用 `TEMPERATURE_PROBE_NEXT`。默认 `STEP` 为 2。

#### TEMPERATURE_PROBE_NEXT
`TEMPERATURE_PROBE_NEXT`：校准开始后，此命令用于采集下一个样本。当达到 `STEP` 指定的增量时，它会自动安排运行，但也可以手动运行此命令以强制采集新样本。此命令仅在校准期间可用。

#### TEMPERATURE_PROBE_COMPLETE:
`TEMPERATURE_PROBE_COMPLETE`：可用于在达到 `TARGET` 温度之前结束校准并保存当前结果。此命令仅在校准期间可用。

#### ABORT
`ABORT`：中止校准过程，丢弃当前结果。此命令仅在漂移校准期间可用。

### TEMPERATURE_PROBE_ENABLE
`TEMPERATURE_PROBE_ENABLE ENABLE=[0|1]`：设置温度漂移补偿的开启或关闭。如果将 ENABLE 设置为 0，则禁用漂移补偿，如果设置为 1，则启用。

### [tmcXXXX]

当启用任何 [tmcXXXX 配置部分](Config_Reference.md#tmc-stepper-driver-configuration) 时，以下命令可用。

#### DUMP_TMC
`DUMP_TMC STEPPER=<名称> [REGISTER=<名称>]`：此命令将读取所有 TMC 驱动器寄存器并报告其值。如果提供了 REGISTER，则仅转储指定的寄存器。

#### INIT_TMC
`INIT_TMC STEPPER=<名称>`：此命令将初始化 TMC 寄存器。如果芯片的电源关闭然后重新打开，则需要重新启用驱动器。

#### SET_TMC_CURRENT
`SET_TMC_CURRENT STEPPER=<名称> CURRENT=<安培> HOLDCURRENT=<安培>`：这将调整 TMC 驱动器的运行和保持电流。`HOLDCURRENT` 不适用于 tmc2660 驱动器。当在具有 `globalscaler` 字段的驱动器（tmc5160 和 tmc2240）上使用时，如果使用 StealthChop2，则步进电机必须在静止状态下保持 >130ms，以便驱动器执行 AT#1 校准。

#### SET_TMC_FIELD
`SET_TMC_FIELD STEPPER=<名称> FIELD=<字段> VALUE=<值> VELOCITY=<值>`：这将更改 TMC 驱动器指定寄存器字段的值。此命令仅用于低级诊断和调试，因为在运行时更改字段可能导致打印机出现不希望的和潜在危险的行为。永久更改应使用打印机配置文件进行。不会对给定值执行健全性检查。还可以指定 VELOCITY 而不是 VALUE。该速度被转换为 20 位 TSTEP 值表示。仅对表示速度的字段使用 VELOCITY 参数。

### [toolhead]

toolhead 模块会自动加载。

#### SET_VELOCITY_LIMIT
`SET_VELOCITY_LIMIT [VELOCITY=<值>] [ACCEL=<值>] [MINIMUM_CRUISE_RATIO=<值>] [SQUARE_CORNER_VELOCITY=<值>]`：此命令可以更改在打印机配置文件中指定的速度限制。有关每个参数的描述，请参阅 [打印机配置部分](Config_Reference.md#printer)。

### [tuning_tower]

tuning_tower 模块会自动加载。

#### TUNING_TOWER
`TUNING_TOWER COMMAND=<命令> PARAMETER=<名称> START=<值> [SKIP=<值>] [FACTOR=<值> [BAND=<值>]] | [STEP_DELTA=<值> STEP_HEIGHT=<值>]`：用于在打印期间根据每个 Z 高度调整参数的工具。该工具将使用给定的 `PARAMETER` 运行给定的 `COMMAND`，其值根据公式随 `Z` 变化。如果将使用尺子或卡尺测量最佳值的 Z 高度，请使用 `FACTOR`，如果调谐塔模型具有离散值带（如温度塔中常见的），请使用 `STEP_DELTA` 和 `STEP_HEIGHT`。如果指定了 `SKIP=<值>`，则在达到 Z 高度 `<值>` 之前，调谐过程不会开始，在此之下，值将设置为 `START`；在这种情况下，公式中使用的 `z_height` 实际上是 `max(z - skip, 0)`。有三种可能的选项组合：
- `FACTOR`：值以每毫米 `factor` 的速率变化。使用的公式为：`value = start + factor * z_height`。您可以直接将最佳 Z 高度代入公式以确定最佳参数值。
- `FACTOR` 和 `BAND`：值以平均每毫米 `factor` 的速率变化，但以离散带变化，调整仅在 Z 高度每 `BAND` 毫米进行一次。使用的公式为：`value = start + factor * ((floor(z_height / band) + .5) * band)`。
- `STEP_DELTA` 和 `STEP_HEIGHT`：值每 `STEP_HEIGHT` 毫米变化 `STEP_DELTA`。使用的公式为：`value = start + step_delta * floor(z_height / step_height)`。您只需计算带或读取调谐塔标签即可确定最佳值。

### [virtual_sdcard]

如果启用了 [virtual_sdcard 配置部分](Config_Reference.md#virtual_sdcard)，Klipper 支持以下标准 G-Code 命令：
- 列出 SD 卡：`M20`
- 初始化 SD 卡：`M21`
- 选择 SD 文件：`M23 <文件名>`
- 开始/恢复 SD 打印：`M24`
- 暂停 SD 打印：`M25`
- 设置 SD 位置：`M26 S<偏移量>`
- 报告 SD 打印状态：`M27`

此外，当启用 "virtual_sdcard" 配置部分时，以下扩展命令可用。

#### SDCARD_PRINT_FILE
`SDCARD_PRINT_FILE FILENAME=<文件名>`：加载文件并开始 SD 打印。

#### SDCARD_RESET_FILE
`SDCARD_RESET_FILE`：卸载文件并清除 SD 状态。

### [z_thermal_adjust]

当启用 [z_thermal_adjust 配置部分](Config_Reference.md#z_thermal_adjust) 时，以下命令可用。

#### SET_Z_THERMAL_ADJUST
`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<值>] [REF_TEMP=<值>]`：使用 `ENABLE` 启用或禁用 Z 热调整。禁用不会删除已应用的任何调整，但会冻结当前调整值 - 这可以防止潜在的不安全的向下 Z 移动。重新启用可能会导致工具向上移动，因为调整被更新和应用。`TEMP_COEFF` 允许在运行时调整调整温度系数（即 `TEMP_COEFF` 配置参数）。`TEMP_COEFF` 值不会保存到配置中。`REF_TEMP` 手动覆盖通常在归位期间设置的参考温度（用于例如非标准归位例程） - 归位时将自动重置。

### [z_tilt]

当启用 [z_tilt 配置部分](Config_Reference.md#z_tilt) 时，以下命令可用。

#### Z_TILT_ADJUST
`Z_TILT_ADJUST [RETRIES=<值>] [RETRY_TOLERANCE=<值>] [HORIZONTAL_MOVE_Z=<值>] [<探针参数>=<值>]`：此命令将探测配置中指定的点，然后对每个 Z 步进电机进行独立调整，以补偿倾斜。有关可选探针参数的详细信息，请参阅 PROBE 命令。可选的 `RETRIES`、`RETRY_TOLERANCE` 和 `HORIZONTAL_MOVE_Z` 值将覆盖配置文件中指定的选项。