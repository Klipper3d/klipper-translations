# G-Codes

本文档描述了 Klipper 支持的命令。这些命令可以输入到 OctoPrint 终端中。

## G代码命令

Klipper支持以下标准的G-Code命令：

- 移动 (G0 or G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- 驻留：`G4 P<毫秒>`
- 返回原点：`G28 [X] [Y] [Z]`
- 关闭步进电机：`M18`或`M84`
- 等待当前移动完成： `M400`
- 使用绝对/相对挤出距离：`M82`， `M83`
- 使用绝对/相对坐标：`G90`, `G91`
- 设置坐标：`G92 [X<坐标>] [Y<坐标>] [Z<坐标>] [E<坐标>]`
- 设置速度因子覆写百分比：`M220 S<百分比>`
- 设置挤压因子覆盖百分比：`M221 S<percent>`
- 设置加速度：`M204 S<value>` 或 `M204 P<value> T<value>`
   - 注意：如果没有指定S，同时指定了P和T，那么加速度将被设置为P和T中的最小值。
- 获取挤出机温度：`M105`
- 设置挤出机温度：`M104 [T<index>] [S<temperature>]`
- 设置挤出机温度并等待：`M109 [T<index>] S<temperature>`。
   - 注意：M109总是等待温度稳定在请求的数值上。
- 设置热床温度：`M140 [S<temperature>]`
- 设置热床温度并且等待：`M190 S<temperature>`
   - 注意：M190总是等待温度稳定在请求的数值上。
- 设置风扇速度：`M106 S<value>`
- 停止风扇：`M107`
- 紧急停止：`M112`
- 获取当前位置：`M114`
- 获取固件版本：`M115`

有关上述命令的更多详细信息，请参阅 [RepRap G-Code documentation](http://reprap.org/wiki/G-code)

Klipper 的目标是支持普通第三方软件（如OctoPrint、Printrun、Slic3r、Cura等）使用标准配置产生的G代码命令。支持所有可能的G-Code命令并不是我们的目标。相反，Klipper 更喜欢人类可读的["扩展的G-Code命令"](#additional-commands)。同样地，G-Code终端输出也只是为了让人可读--如果从外部软件控制Klipper，请参阅[API服务器文件](API_Server.md)。

如果一个人需要一个不太常见的G-Code命令，那么可以用一个自定义的[gcode_macro config section](Config_Reference.md#gcode_macro)来实现它。例如，我们可以用这个来实现。`G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1` ，etc

## 其他命令

Klipper使用 "extended" 的G代码命令来进行一般的配置和状态。这些扩展命令都遵循一个类似的格式--它们以一个命令名开始，后面可能有一个或多个参数。比如说：`SET_SERVO SERVO=myservo ANGLE=5.3`。在本文件中，命令和参数以大写字母显示，但它们不分大小写。(所以，"SET_SERVO "和 "set_servo "都是运行同一个命令）

This section is organized by Klipper module name, which generally follows the section names specified in the [printer configuration file](Config_Reference.md). Note that some modules are automatically loaded.

### [adxl345]

The following commands are available when an [adxl345 config section](Config_Reference.md#adxl345) is enabled.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]` 。以要求的每秒采样数启动加速度计测量。如果没有指定CHIP，则默认为 "adxl345"。该命令以启动-停止模式工作：第一次执行时，它开始测量，下次执行时停止测量。测量结果被写入一个名为`/tmp/adxl345-<chip>-<name>的文件中。csv`，其中`<chip>`是加速度计芯片的名称（`my_chip_name`来自`[adxl345 my_chip_name]`），`<name>`是可选NAME参数。如果没有指定NAME，则默认为当前时间，格式为 "YYYMMDD_HHMMSS"。如果加速度计在其配置部分没有名称（只是`[adxl345]`），那么`<chip >`部分的名称就不会生成。

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: 查询加速度计的当前值。如果没有指定芯片，则默认为 "adxl345"。如果没有指定RATE，则使用默认值。该命令对于测试与ADXL345加速度计的连接非常有用：返回的数值之一应该是自由落体加速度（+/-芯片的一些噪声）。

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<配置名>] REG=<寄存器>`：查询ADXL345的寄存器"REG"（例如44或0x2C）。可以用于debug。

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<配置名>] REG=<寄存器> VAL=<值>`：将原始的"值"写进寄存器"寄存器"。"值"和"寄存器"都可以是一个十进制或十六进制的整数。请谨慎使用，并参考 ADXL345 数据手册。

### [angle]

The following commands are available when an [angle config section](Config_Reference.md#angle) is enabled.

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<芯片名>`：在指定传感器上执行角度校准（必须有一个`[angle 芯片名]`的配置分段，并指定一个`stepper`参数）。重要的是 - 这个工具将命令步进电机移动而不检查正常的运动学边界限制。理想情况下，在执行校准之前，电机不应被连接到任何打印机的滑块。如果不能断开步进电机和打印机滑块的连接，在开始校准之前，确保滑车接近其轨道的中心。(在这个测试中，步进电机可能会向前或向后移动两圈）。完成这个测试后，使用`SAVE_CONFIG`命令，将校准数据保存到配置文件中。为了使用这个工具，必须安装Python "numpy"软件包（更多信息见[测量谐振文档](Measuring_Resonances.md#software-installation)）。

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<配置名> REG=<寄存器>`：查询传感器寄存器"寄存器"（例如：44或0x2C）。该命令常用于调试，仅适用于tle5012b芯片。

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<配置名> REG=<寄存器> VAL=<值>`：将“值”写入“寄存器”。“值”和“寄存器”可以是十进制或十六进制整数。请小心使用，并参考传感器数据手册。仅适用于 tle5012b芯片。

### [bed_mesh]

The following commands are available when the [bed_mesh config section](Config_Reference.md#bed_mesh) is enabled (also see the [bed mesh guide](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>]`: This command probes the bed using generated points specified by the parameters in the config. After probing, a mesh is generated and z-movement is adjusted according to the mesh. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`：该命令将当前探测到的 Z 值和当前网格的值输出到终端。如果指定 PGP=1，则将bed_mesh产生的X、Y坐标，以及它们关联的指数，输出到终端。

#### BED_MESH_MAP

`BED_MESH_MAP`：类似 BED_MESH_OUTPUT，这个命令在终端中显示网格的当前状态。它不以人类可读格式打印，而是被序列化为 json 格式。这允许 Octoprint 插件捕获数据并生成描绘打印床表面的高度图。

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`：此命令清除床网并移除所有 z 调整。建议把它放在你的 end-gcode （结束G代码）中。

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<名称> SAVE=<名称> REMOVE=<名称>`：此命令提供了网床配置管理功能。LOAD 将从与所提供的名称相符的配置文件中恢复网格状态。SAVE 将会把目前的网格状态保存到与提供的名称相符的配置文件中。REMOVE（移除）将从持久性内存中删除与所提供名称相符的配置文件。请注意，在 SAVE 或 REMOVE 操作后，必须发送SAVE_CONFIG G代码，以保存变更到持久性内存。

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<value>] [Y=<value>]`。将X和/或Y的偏移量应用于网格查找。这对具有多个独立挤出头的打印机很有用，因为偏移量对切换工具头后产生正确的 Z 值调整是至关重要的。

### [bed_screws]

The following commands are available when the [bed_screws config section](Config_Reference.md#bed_screws) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`：该命令将调用打印床螺丝调整工具。它将命令喷嘴移动到不同的位置（在配置文件中定义），并允许对打印床螺丝进行手动调整，使打印床与喷嘴的距离保持不变。

### [bed_tilt]

The following commands are available when the [bed_tilt config section](Config_Reference.md#bed_tilt) is enabled.

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then recommend updated x and y tilt adjustments. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

### [bltouch]

当[bltouch 配置分段](Config_Reference.md#bltouch)被启用时，以下命令可用（也可参见[BL-Touch guide](BLTouch.md)）。

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<命令>`：向BLTouch发送一个指定的命令，可以用于调试。可用的命令有：`pin_down`、`touch_mode`、`pin_up`、`self_test`和`reset`。BL-TOUCH V3.0 或 V3.1 也可能支持`set_5V_output_mode`、`set_OD_output_mode`和`output_mode_store`命令。

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`:这将在BLTouch V3.1的EEPROM中存储一个输出模式 可用的输出模式有`5V`, `OD`

### [configfile]

configfile模块被自动加载。

#### SAVE_CONFIG

`SAVE_CONFIG`：该命令将覆盖打印机的主配置文件，并重新启动主机软件。该命令与其他校准命令一起使用，用于存储校准测试的结果。

### [delayed_gcode]

The following command is enabled if a [delayed_gcode config section](Config_Reference.md#delayed_gcode) has been enabled (also see the [template guide](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<名称>] [DURATION=<秒>]`：更新目标 [delayed_gcode] 的延迟并启动G代码执行的计时器。为0的值会取消准备执行的延迟G代码。

### [delta_calibrate]

The following commands are available when the [delta_calibrate config section](Config_Reference.md#linear-delta-kinematics) is enabled (also see the [delta calibrate guide](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe seven points on the bed and recommend updated endstop positions, tower angles, and radius. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

#### DELTA_ANALYZE

`DELTA_ANALYZE`:这个命令在增强的delta校准过程中使用。详情见[Delta Calibrate](Delta_Calibrate.md)。

### [display]

当[display 配置分段](Config_Reference.md#gcode_macro)被启用时，以下命令可用：

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`:设置一个lcd显示器的活动显示组。这允许在配置中定义多个显示数据组，例如`[display_data <group> <elementname>]`并使用这个扩展的gcode命令在它们之间切换。如果没有指定DISPLAY，则默认为 "display"（主显示）。

### [display_status]

如果使用了[display config 配置分段](Config_Reference.md#display)，display_status模块会自动加载。它提供了以下标准的G代码命令：

- 显示信息： `M117 <message> `
- 设置构建百分比：`M73 P<percent>`

还提供了以下扩展 G 语言命令：

- `SET_DISPLAY_TEXT MSG=<message>`: Performs the equivalent of M117, setting the supplied `MSG` as the current display message. If `MSG` is omitted the display will be cleared.

### [dual_carriage]

使用[dual_carriage 配置分段](Config_Reference.md#dual_carriage)时，以下命令可用：

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=[0|1]`:该命令将设置活动的滑块。它通常是在一个多挤出机配置中从 activate_gcode和deactivate_gcode字段调用。

### [endstop_phase]

The following commands are available when an [endstop_phase config section](Config_Reference.md#endstop_phase) is enabled (also see the [endstop phase guide](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]` 。如果没有提供STEPPER参数，那么该命令将报告在过去的归位操作中对端停步进相的统计。当提供STEPPER参数时，它会安排将给定的终点站相位设置写入配置文件中（与SAVE_CONFIG命令一起使用）。

### [exclude_object]

The following commands are available when an [exclude_object config section](Config_Reference.md#exclude_object) is enabled (also see the [exclude object guide](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=对象名称] [CURRENT=1] [RESET=1]`：在没有参数的情况下，这将返回一个当前所有被排除的对象的列表。

When the `NAME` parameter is given, the named object will be excluded from printing.

When the `CURRENT` parameter is given, the current object will be excluded from printing.

When the `RESET` parameter is given, the list of excluded objects will be cleared. Additionally including `NAME` will only reset the named object. This **can** cause print failures, if layers were already skipped.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=对象名称[CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`：提供文件中一个对象的摘要。

With no parameters provided, this will list the defined objects known to Klipper. Returns a list of strings, unless the `JSON` parameter is given, when it will return object details in json format.

When the `NAME` parameter is included, this defines an object to be excluded.

- `NAME`：这个参数是必需的。它是本模块中其他命令所使用的标识符。
- `CENTER`：对象的 X，Y 坐标。
- `POLYGON`：提供对象轮廓的 X,Y 坐标数组。

When the `RESET` parameter is provided, all defined objects will be cleared, and the `[exclude_object]` module will be reset.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=对象名称`：这个命令接收一个`NAME`参数，表示当前层上一个对象的gcode开始。

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=对象名称]`：表示对象在该层的代码的结束。它与`EXCLUDE_OBJECT_START`相配。`NAME`参数是可选的，只在提供的名称与当前对象不匹配时才会发出警告。

### [extruder]

The following commands are available if an [extruder config section](Config_Reference.md#extruder) is enabled:

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<配置名>`：在有多个[extruder](Config_Reference.md#extruder)配置分段的打印机中，该命令会改变活跃的热端。

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Set pressure advance parameters of an extruder stepper (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section). If EXTRUDER is not specified, it defaults to the stepper defined in the active hotend.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<配置名> [DISTANCE=<距离>]`：为提供的挤出机步进电机的“旋转距离”（如 [挤出机](Config_Reference.md#extruder) 或 [extruder_stepper](Config_Reference.md#extruder_stepper)配置分段中定义）设置新值。如果旋转距离为负数，则步进运动将反转（相对于配置文件中指定的步进方向）。更改的设置不会在 Klipper 重置时保留。请谨慎使用，因为微小的变化会导致挤出机和热端之间的压力过大。使用前需要用耗材进行适当的校准。如果未提供“DISTANCE”值，则此命令将返回当前旋转距离。

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<name> MOTION_QUEUE=<name>`: This command will cause the stepper specified by EXTRUDER (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section) to become synchronized to the movement of an extruder specified by MOTION_QUEUE (as defined in an [extruder](Config_Reference.md#extruder) config section). If MOTION_QUEUE is an empty string then the stepper will be desynchronized from all extruder movement.

#### SET_EXTRUDER_STEP_DISTANCE

This command is deprecated and will be removed in the near future.

#### SYNC_STEPPER_TO_EXTRUDER

This command is deprecated and will be removed in the near future.

### [fan_generic]

当[fan_generic 配置分段](Config_Reference.md#fan_generic)被启用时，以下命令可用：

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<速度>`该命令设置风扇的速度。"速度" 必须在0.0到1.0之间。

### [filament_switch_sensor]

启用[filament_switch_sensor](Config_Reference.md#filament_switch_sensor)或[filament_motion_sensor](Config_Reference.md#filament_motion_sensor)配置分段后，可使用以下命令：

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<传感器名>`：查询耗材传感器的当前状态。在终端中显示的数据将取决于配置中定义的传感器类型。

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]` ：设置灯丝传感器的开/关。如果 ENABLE 设置为 0，耗材传感器将被禁用，如果设置为 1是启用。

### [firmware_retraction]

The following standard G-Code commands are available when the [firmware_retraction config section](Config_Reference.md#firmware_retraction) is enabled. These commands allow you to utilize the firmware retraction feature available in many slicers, to reduce stringing during non-extrusion moves from one part of the print to another. Appropriately configuring pressure advance reduces the length of retraction required.

- `G10`：使用当前配置的参数回抽挤出机。
- `G11`：使用当前配置的参数回填挤出机。

还可以使用以下额外命令：

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<毫米>] [RETRACT_SPEED=<毫米每秒>] [UNRETRACT_EXTRA_LENGTH=<毫米>] [UNRETRACT_SPEED=<毫米每秒>]`：调整固件回抽所使用的参数。RETRACT_LENGTH 决定回抽和回填的耗材长度。回抽的速度通过 RETRACT_SPEED 调整，通常设置得比较高。回填的速度通过 UNRETRACT_SPEED 调整，虽然经常比RETRACT_SPEED 低，但不是特别重要。在某些情况下，在回填时增加少量的额外长度的耗材可能有益，这可以通过 UNRETRACT_EXTRA_LENGTH 设置。SET_RETRACTION 通常作为切片机耗材配置的一部分来设置，因为不同的耗材需要不同的参数设置。

#### GET_RETRACTION

`GET_RETRACTION`:查询当前固件回抽所使用的参数并在终端显示。

### [force_move]

The force_move module is automatically loaded, however some commands require setting `enable_force_move` in the [printer config](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<配置名>`：移动指定的步进电机前后运动一毫米，重复的10次。这是一个用于验证步进电机接线的工具

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]` 。该命令将以给定的恒定速度（mm/s）强制移动给定的步进器，移动距离（mm）。如果指定了ACCEL并且大于零，那么将使用给定的加速度（单位：mm/s^2）；否则不进行加速。不执行边界检查；不进行运动学更新；一个轴上的其他平行步进器将不会被移动。请谨慎使用，因为不正确的命令可能会导致损坏使用该命令几乎肯定会使低级运动学处于不正确的状态；随后发出G28命令以重置运动学。该命令用于低级别的诊断和调试。

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<值>] [Y=<值>] [Z=<值>]`：强制设定低级运动学代码使用的打印头位置。这是一个诊断和调试工具，常规的轴转换应该使用 SET_GCODE_OFFSET 和/或 G92指令。如果没有指定一个轴，则使用上一次命令的打印头位置。设定一个不合理的数值可能会导致内部程序问题。这个命令可能会使边界检查失效，使用后发送 G28 来重置运动学。

### [gcode]

The gcode module is automatically loaded.

#### RESTART

`RESTART`：这将导致主机软件重新加载其配置并执行内部重置。此命令不会从微控制器清除错误状态（请参阅 FIRMWARE_RESTART），也不会加载新软件（请参阅 [常见问题](FAQ.md#how-do-i-upgrade-to-the-latest-software)） .

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`：这类似于重启命令，但它也清除了微控制器的任何错误状态。

#### STATUS

`STATUS`：报告Klipper主机程序的状态。

#### HELP

`HELP`：报告可用的扩展G-Code命令列表。

### [gcode_arcs]

如果启用了[gcode_arcs 配置分段](Config_Reference.md#gcode_arcs)，下列标准G代码命令可用：

- Arc Move Clockwise (G2), Arc Move Counter-clockwise (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`
- Arc Plane Select: G17 (XY plane), G18 (XZ plane), G19 (YZ plane)

### [gcode_macro]

当[gcode_macro配置分段](Config_Reference.md#gcode_macro)被启用时，以下命令可用（也可参见[命令模板指南](Command_Templates.md)）：

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`：这条命令允许在运行时对 gcode_macro 变量的值进行修改。所提供的 VALUE 会被解析为一个 Python 字面。

### [gcode_move]

The gcode_move module is automatically loaded.

#### GET_POSITION

`GET_POSITION`：返回打印头的当前位置信息。更多信息请参见[GET_POSITION输出](Code_Overview.md#coordinate-systems)的开发者文档。

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]` 。设置一个位置偏移，以应用于未来的G代码命令。这通常用于实际改变Z床的偏移量或在切换挤出机时设置喷嘴的XY偏移量。例如，如果发送 "SET_GCODE_OFFSET Z=0.2"，那么未来的G代码移动将在其Z高度上增加0.2mm。如果使用X_ADJUST风格的参数，那么调整将被添加到任何现有的偏移上（例如，"SET_GCODE_OFFSET Z=-0.2"，然后是 "SET_GCODE_OFFSET Z_ADJUST=0.3"，将导致总的Z偏移为0.1）。如果指定了 "MOVE=1"，那么将发出一个工具头移动来应用给定的偏移量（否则偏移量将在指定给定轴的下一次绝对G-Code移动中生效）。如果指定了 "MOVE_SPEED"，那么刀头移动将以给定的速度（mm/s）执行；否则，打印头移动将使用最后指定的G-Code速度。

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<state_name>]`：保存当前的g-code坐标解析状态。保存和恢复g-code状态在脚本和宏中很有用。该命令保存当前g-code绝对坐标模式（G90/G91）绝对挤出模式（M82/M83）原点（G92）偏移量（SET_GCODE_OFFSET）速度覆盖（M220）挤出机覆盖（M221）移动速度。当前XYZ位置和相对挤出机 "E "位置。如果提供NAME，它可以将保存的状态命名为给定的字符串。如果没有提供NAME，则默认为 "default"

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`：恢复之前通过 SAVE_GCODE_STATE 保存的状态。如果指定“MOVE=1”，则将发出刀头移动以返回到先前的 XYZ 位置。如果指定了“MOVE_SPEED”，则刀头移动将以给定的速度（以mm/s为单位）执行；否则工具头移动将使用恢复的G-Code速度。

### [hall_filament_width_sensor]

The following commands are available when the [tsl1401cl filament width sensor config section](Config_Reference.md#tsl1401cl_filament_width_sensor) or [hall filament width sensor config section](Config_Reference.md#hall_filament_width_sensor) is enabled (also see [TSLl401CL Filament Width Sensor](TSL1401CL_Filament_Width_Sensor.md) and [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)):

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`：返回当前测量的耗材直径。

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`：清除全部传感器读数。在更换耗材后有用。

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`：关闭耗材直径传感器并停止使用它进行流量控制。

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR`：启用耗材直径传感器并使用它进行流量控制。

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`：返回当前 ADC 通道读数和校准点的 RAW 传感器值。

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`：开启直径记录。

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`：停止直径记录。

### [heaters]

The heaters module is automatically loaded if a heater is defined in the config file.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`：关闭全部加热器。

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<配置名> [MINIMUM=<目标>] [MAXIMUM=<目标>]`：等待指定温度传感器读数高于 MINIMUM 和或低于 MAXIMUM。

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<加热器名称> [TARGET=<目标温度>]`：设置一个加热器的目标温度。如果没有提供目标温度，则目标温度为 0。

### [idle_timeout]

The idle_timeout module is automatically loaded.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<超时>]`：允许用户设置空闲超时（以秒为单位）。

### [input_shaper]

The following command is enabled if an [input_shaper config section](Config_Reference.md#input_shaper) has been enabled (also see the [resonance compensation guide](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`：修改输入整形参数。注意 SHAPER_TYPE 参数会同时覆写 X 和 Y 轴的整形器类型，即使它们在 [input_shaper] 配置分段中有不同的整形器类型。SHAPER_TYPE 不能和 SHAPER_TYPE_X 和 SHAPER_TYPE_Y 参数同时使用。这些参数的细节请见[配置参考](Config_Reference.md#input_shaper)。

### [manual_probe]

The manual_probe module is automatically loaded.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`：运行一个辅助脚本，对测量给定位置的喷嘴高度有用。如果指定了速度，它将设置TESTZ命令的速度（默认为5mm/s）。在手动探测过程中，可使用以下附加命令：

- `ACCEPT`：该命令接受当前的Z位置，并结束手动探测工具。
- `ABORT`：该命令终止手动探测工具。
- `TESTZ Z=<值>`：这个命令可以将喷嘴上升或下降给定值，以毫米为单位。例如，`TESTZ Z=-.1` 会将喷嘴下降 0.1 毫米，而 `TESTZ Z=.1` 会将喷嘴上升 0.1 毫米，参数可以带有`+`, `-`, `++`, or `--`来根据上次尝试相对的移动喷嘴。

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<速度>]`：运行一个校准 Z position_endstop 参数的辅助脚本。有关更多参数和额外命令的信息，请查看 MANUAL_PROBE 命令。

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`：将当前的Z 的 G 代码偏移量（就是 babystepping）从 stepper_z 的 endstop_position 中减去。该命令将持久化一个常用babystepping 微调值。需要执行 `SAVE_CONFIG`才能生效。

### [manual_stepper]

当[manual_stepper 配置分段](Config_Reference.md#manual_stepper)被启用时，以下命令可用。

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]]`：该命令将改变步进器的状态。使用ENABLE参数来启用/禁用步进。使用SET_POSITION参数，迫使步进认为它处于给定的位置。使用MOVE参数，要求移动到给定位置。如果指定了SPEED或者ACCEL，那么将使用给定的值而不是配置文件中指定的默认值。如果指定ACCEL为0，那么将不执行加速。如果STOP_ON_ENDSTOP=1被指定，那么如果止动器报告被触发，动作将提前结束（使用STOP_ON_ENDSTOP=2来完成动作，即使止动器没有被触发也不会出错，使用-1或-2来在止动器报告没有被触发时停止）。通常情况下，未来的G-Code命令将被安排在步进运动完成后运行，但是如果手动步进运动使用SYNC=0，那么未来的G-Code运动命令可能与步进运动平行运行。

### [mcp4018]

The following command is available when a [mcp4018 config section](Config_Reference.md#mcp4018) is enabled.

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: This command will change the current value of the digipot. This value should typically be between 0.0 and 1.0, unless a 'scale' is defined in the config. When 'scale' is defined, then this value should be between 0.0 and 'scale'.

### [led]

The following command is available when any of the [led config sections](Config_Reference.md#leds) are enabled.

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: This sets the LED output. Each color `<value>` must be between 0.0 and 1.0. The WHITE option is only valid on RGBW LEDs. If the LED supports multiple chips in a daisy-chain then one may specify INDEX to alter the color of just the given chip (1 for the first chip, 2 for the second, etc.). If INDEX is not provided then all LEDs in the daisy-chain will be set to the provided color. If TRANSMIT=0 is specified then the color change will only be made on the next SET_LED command that does not specify TRANSMIT=0; this may be useful in combination with the INDEX parameter to batch multiple updates in a daisy-chain. By default, the SET_LED command will sync it's changes with other ongoing gcode commands. This can lead to undesirable behavior if LEDs are being set while the printer is not printing as it will reset the idle timeout. If careful timing is not needed, the optional SYNC=0 parameter can be specified to apply the changes without resetting the idle timeout.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: Assign a [display_template](Config_Reference.md#display_template) to a given [LED](Config_Reference.md#leds). For example, if one defined a `[display_template my_led_template]` config section then one could assign `TEMPLATE=my_led_template` here. The display_template should produce a comma separated string containing four floating point numbers corresponding to red, green, blue, and white color settings. The template will be continuously evaluated and the LED will be automatically set to the resulting colors. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If INDEX is not specified then all chips in the LED's daisy-chain will be set to the template, otherwise only the chip with the given index will be updated. If TEMPLATE is an empty string then this command will clear any previous template assigned to the LED (one can then use `SET_LED` commands to manage the LED's color settings).

### [output_pin]

使用[output_pin 配置分段](Config_Reference.md#output_pin)时，以下命令可用：

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: Set the pin to the given output `VALUE`. VALUE should be 0 or 1 for "digital" output pins. For PWM pins, set to a value between 0.0 and 1.0, or between 0.0 and `scale` if a scale is configured in the output_pin config section.

Some pins (currently only "soft PWM" pins) support setting an explicit cycle time using the CYCLE_TIME parameter (specified in seconds). Note that the CYCLE_TIME parameter is not stored between SET_PIN commands (any SET_PIN command without an explicit CYCLE_TIME parameter will use the `cycle_time` specified in the output_pin config section).

### [palette2]

The following commands are available when the [palette2 config section](Config_Reference.md#palette2) is enabled.

Palette打印通过在GCode文件中嵌入特殊的OCodes（Omega Codes）来工作。

- `O1`...`O32`：这些代码从G-Code流中读出并且传递给Palette 2设备进行处理。

还可以使用以下额外命令：

#### PALETTE_CONNECT

`PALETTE_CONNECT`：该命令初始化与Palette 2的连接。

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`：该命令断开与Palette 2的连接。

#### PALETTE_CLEAR

`PALETTE_CLEAR`:该命令指示 Palette 2 清除所有耗材的输入或者输出。

#### PALETTE_CUT

`PALETTE_CUT`:该命令指引Palette 2切割耗材并且装载分段的耗材。

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`：该命令在Palette 2上启动智能加载序列。通过在设备上为打印机校准的距离挤压，自动加载耗材，并在加载完成后指示Palette 2。该命令与耗材加载完成后直接在Palette 2屏幕上按**Smart Load**相同。

### [pid_calibrate]

The pid_calibrate module is automatically loaded if a heater is defined in the config file.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`：执行一个PID校准测试。指定的加热器将被启用，直到达到指定的目标温度，然后加热器将被关闭和开启几个周期。如果WRITE_FILE参数被启用，那么将创建文件/tmp/heattest.txt，其中包含测试期间所有温度样本的日志。

### [pause_resume]

当[pause_resume 配置分段](Config_Reference.md#pause_resume)被启用时，以下命令可用：

#### PAUSE

`PAUSE`：暂停当前的打印。当前的位置被报错以便在恢复时恢复。

#### RESUME

`RESUME [VELOCITY=<value>]`：从暂停中恢复打印，首先恢复以前保持的位置。VELOCITY参数决定了工具返回到原始捕捉位置的速度。

#### CLEAR_PAUSE

`CLEAR_PAUSE`:清除当前的暂停状态而不恢复打印。如果一个人决定在暂停后取消打印，这很有用。建议将其添加到你的启动代码中，以确保每次打印时的暂停状态是新的。

#### CANCEL_PRINT

`CANCEL_PRINT`：取消当前的打印。

### [print_stats]

The print_stats module is automatically loaded.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>] [CURRENT_LAYER= <current_layer>]`: Pass slicer info like layer act and total to Klipper. Add `SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>]` to your slicer start gcode section and `SET_PRINT_STATS_INFO [CURRENT_LAYER= <current_layer>]` at the layer change gcode section to pass layer information from your slicer to Klipper.

### [probe]

The following commands are available when a [probe config section](Config_Reference.md#probe) or [bltouch config section](Config_Reference.md#bltouch) is enabled (also see the [probe calibrate guide](Probe_Calibrate.md)).

#### PROBE

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`：向下移动喷嘴直到探针触发。如果提供了任何可选参数，它们将覆盖 [probe config section](Config_Reference.md#probe) 中的等效设置。

#### QUERY_PROBE

`QUERY_PROBE`:报告探针的当前状态（"triggered"或 "open"）。

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`：计算多个探针样本的最大、最小、平均、中位数和标准偏差。默认情况下采样10次。否则可选参数默认为探针配置部分的同等设置。

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>] `:运行一个对校准测头的z_offset有用的辅助脚本。有关可选测头参数的详细信息，请参见PROBE命令。参见MANUAL_PROBE命令，了解SPEED参数和工具激活时可用的附加命令的详细信息。请注意，PROBE_CALIBRATE命令使用速度变量在XY方向以及Z方向上移动。

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`：将当前的Z 的 G 代码偏移量（就是 babystepping）从 probe 的 z_offset 中减去。该命令将持久化一个常用babystepping 微调值。需要执行 `SAVE_CONFIG`才能生效。

### [query_adc]

The query_adc module is automatically loaded.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]` ：返回为配置的模拟引脚收到的最后一个模拟值。如果NAME没有被提供，将报告可用的adc名称列表。如果提供了PULLUP（以欧姆为单位的数值），将会返回原始模拟值和给定的等效电阻。

### [query_endstops]

The query_endstops module is automatically loaded. The following standard G-Code commands are currently available, but using them is not recommended:

- 获取限位状态：`M119` (使用QUERY_ENDSTOPS代替)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`：检测限位并返回限位是否被 "triggered"或处于"open"。该命令通常用于验证一个限位是否正常工作。

### [resonance_tester]

The following commands are available when a [resonance_tester config section](Config_Reference.md#resonance_tester) is enabled (also see the [measuring resonances guide](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`：测量并输出所有启用的加速度计芯片的所有轴的噪声。

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> OUTPUT=<resonances,raw_data> [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<adxl345_chip_name>] [POINT=x,y,z] [INPUT_SHAPING=[<0:1>]]`: Runs the resonance test in all configured probe points for the requested "axis" and measures the acceleration using the accelerometer chips configured for the respective axis. "axis" can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. `adxl345_chip_name` can be one or more configured adxl345 chip,delimited with comma, for example `CHIPS="adxl345, adxl345 rpi"`. Note that `adxl345` can be omitted from named adxl345 chips. If POINT is specified it will override the point(s) configured in `[resonance_tester]`. If `INPUT_SHAPING=0` or not set(default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured or POINT is specified). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<adxl345_chip_name>] [MAX_SMOOTHING=<max_smoothing>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command, and if `[input_shaper]` was already enabled previously, these parameters take effect immediately.

### [respond]

The following standard G-Code commands are available when the [respond config section](Config_Reference.md#respond) is enabled:

- `M118 <message>`：回显配置了默认前缀的信息（如果没有配置前缀，则返回`echo: `）。

还可以使用以下额外命令：

#### RESPOND

- `RESPOND MSG="<message>"`：回显带有配置的默认前缀的消息（没有配置前缀则默认 `echo: `为前缀 ）。
- `RESPOND TYPE=echo MSG="<消息>"`：回显`echo:`开头消息。
- `RESPOND TYPE=echo_no_space MSG="<message>"`: echo the message prepended with `echo:` without a space between prefix and message, helpful for compatibility with some octoprint plugins that expect very specific formatting.
- `RESPOND TYPE=command MSG="<消息>"`：回显以`/`为前缀的消息。可以配置 OctoPrint 对这些消息进行响应（例如，`RESPOND TYPE=command MSG=action:pause`）。
- `RESPOND TYPE=error MSG="<消息>"`：回显以 `!!`开头的消息。
- `RESPOND PREFIX=<prefix> MSG="<message>"`: 回应以`<prefix>`为前缀的信息。(`PREFIX`参数将优先于`TYPE`参数)

### [save_variables]

The following command is enabled if a [save_variables config section](Config_Reference.md#save_variables) has been enabled.

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`：将变量保存到磁盘，以便在重新启动时使用。所有存储的变量都会在启动时加载到 `printer.save_variables.variables` 目录中，并可以在 gcode 宏中使用。所提供的 VALUE 会被解析为一个 Python 字面。

### [screws_tilt_adjust]

The following commands are available when the [screws_tilt_adjust config section](Config_Reference.md#screws_tilt_adjust) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will invoke the bed screws adjustment tool. It will command the nozzle to different locations (as defined in the config file) probing the z height and calculate the number of knob turns to adjust the bed level. If DIRECTION is specified, the knob turns will all be in the same direction, clockwise (CW) or counterclockwise (CCW). See the PROBE command for details on the optional probe parameters. IMPORTANT: You MUST always do a G28 before using this command. If MAX_DEVIATION is specified, the command will raise a gcode error if any difference in the screw height relative to the base screw height is greater than the value provided. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

### [sdcard_loop]

When the [sdcard_loop config section](Config_Reference.md#sdcard_loop) is enabled, the following extended commands are available.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`：SD 打印中开始循环的部分。计数为0表示该部分应无限期地循环。

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`：结束SD打印中的一个循环部分。

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`：完成现有的循环，不再继续迭代。

### [servo]

The following commands are available when a [servo config section](Config_Reference.md#servo) is enabled.

#### SET_SERVO

`SET_SERVO SERVO=配置名 [ANGLE=<角度> | WIDTH=<秒>]`：将舵机位置设置为给定的角度（度）或脉冲宽度（秒）。使用 `WIDTH=0` 来禁用舵机输出。

### [skew_correction]

The following commands are available when the [skew_correction config section](Config_Reference.md#skew_correction) is enabled (also see the [Skew Correction](Skew_Correction.md) guide).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`：用从校准打印中测量的数据（以毫米为单位）配置 [skew_correction] 模块。可以输入任何组合的平面，没有新输入的平面将保持它们原有的数值。如果传入 `CLEAR=1`，则全部偏斜校正将被禁用。

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`:以弧度和度数报告每个平面的当前打印机偏移。斜度是根据通过`SET_SKEW`代码提供的参数计算的。

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac 长度>] [BD=<bd 长度>] [AD=<ad 长度>]`：计算并报告基于一个打印件测量的偏斜度（以弧度和角度为单位）。它可以用来验证应用校正后打印机的当前偏斜度。它也可以用来确定是否有必要进行偏斜矫正。有关偏斜矫正打印模型和测量方法详见[偏斜校正文档](Skew_Correction.md)。

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<名称>] [SAVE=<名称>] [REMOVE=<名称>]`：skew_correction 配置管理命令。 LOAD 将从与提供的名称匹配的配置中载入偏斜状态。 SAVE 会将当前偏斜状态保存到与提供的名称匹配的配置中。 REMOVE 将从持久内存中删除与提供的名称匹配的配置。请注意，在运行 SAVE 或 REMOVE 操作后，必须运行 SAVE_CONFIG G代码才能保存更改。

### [smart_effector]

Several commands are available when a [smart_effector config section](Config_Reference.md#smart_effector) is enabled. Be sure to check the official documentation for the Smart Effector on the [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer) before changing the Smart Effector parameters. Also check the [probe calibration guide](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<sensitivity>] [ACCEL=<accel>] [RECOVERY_TIME=<time>]`: Set the Smart Effector parameters. When `SENSITIVITY` is specified, the respective value is written to the SmartEffector EEPROM (requires `control_pin` to be provided). Acceptable `<sensitivity>` values are 0..255, the default is 50. Lower values require less nozzle contact force to trigger (but there is a higher risk of false triggering due to vibrations during probing), and higher values reduce false triggering (but require larger contact force to trigger). Since the sensitivity is written to EEPROM, it is preserved after the shutdown, and so it does not need to be configured on every printer startup. `ACCEL` and `RECOVERY_TIME` allow to override the corresponding parameters at run-time, see the [config section](Config_Reference.md#smart_effector) of Smart Effector for more info on those parameters.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`：将Smart Effector灵敏度重置为出厂设置。需要在配置部分提供 `control_pin`。

### [stepper_enable]

The stepper_enable module is automatically loaded.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<配置名> ENABLE=[0|1]` 。启用或禁用指定的步进电机。这是一个诊断和调试工具，必须谨慎使用。因为禁用一个轴电机不会重置归位信息，手动移动一个被禁用的步进可能会导致机器在安全限值外操作电机。这可能导致轴结构、热端和打印件的损坏。

### [temperature_fan]

使用[temperature_fan配置分段](Config_Reference.md#temperature_fan)时，以下命令可用：

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_名称> [target=<目标温度>] [min_speed=<最小速度>] [max_speed=<最大速度>]`：设置一个温度控制风扇的目标温度。如果没有提供目标温度，它将被设为配置文件中定义的温度。如果没有提供速度，则不会进行任何更改。

### [tmcXXXX]

The following commands are available when any of the [tmcXXXX config sections](Config_Reference.md#tmc-stepper-driver-configuration) are enabled.

#### DUMP_TMC

`DUMP_TMC STEPPER=<name> [REGISTER=<name>]`: This command will read all TMC driver registers and report their values. If a REGISTER is provided, only the specified register will be dumped.

#### INIT_TMC

`INIT_TMC STEPPER=<名称>`：此命令将初始化 TMC 寄存器。如果芯片的电源关闭然后重新打开，则需要重新启用该驱动。

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: This will adjust the run and hold currents of the TMC driver. `HOLDCURRENT` is not applicable to tmc2660 drivers. When used on a driver which has the `globalscaler` field (tmc5160 and tmc2240), if StealthChop2 is used, the stepper must be held at standstill for >130ms so that the driver executes the AT#1 calibration.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value> VELOCITY=<value>`: This will alter the value of the specified register field of the TMC driver. This command is intended for low-level diagnostics and debugging only because changing the fields during run-time can lead to undesired and potentially dangerous behavior of your printer. Permanent changes should be made using the printer configuration file instead. No sanity checks are performed for the given values. A VELOCITY can also be specified instead of a VALUE. This velocity is converted to the 20bit TSTEP based value representation. Only use the VELOCITY argument for fields that represent velocities.

### [toolhead]

The toolhead module is automatically loaded.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<值>] [ACCEL=<值>] [ACCEL_TO_DECEL=<值>] [SQUARE_CORNER_VELOCITY=<值>]`：修改打印机速度限制。

### [tuning_tower]

The tuning_tower module is automatically loaded.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<命令> PARAMETER=<名称> START=<值> [SKIP=<值>] [FACTOR=<值> [BAND=<值>]] | [STEP_DELTA=<值> STEP_HEIGHT=<值>]`：根据Z高度调整参数的工具。该工具将定期运行一个 `PARAMETER` 不断根据 `Z` 的公式变化的 `COMMAND`（命令）。如果使用一把尺子或者游标卡尺测量 Z来获得最佳值，你可以用`FACTOR`。如果打印件带有带状标识或者使用离散数值（例如温度塔），可以用`STEP_DELTA`和 `STEP_HEIGHT` 。如果 `SKIP=<值>` 被定义，则调整只会在到达 Z 高度 `<值>` 后才开始。在此之前，参数会被设定为 `START`；在这种情况下，下面公式中`z_height`用`max(z - skip, 0)`替代。这些选项有三种不同的组合：

- `FACTOR`：数值以`factor`每毫米的速度变化。使用的公式是：`value = start + factor * z_height`。你可以将最佳的 Z 高度直接插入该公式，以确定最佳的参数值。
- `FACTOR` 和 `BAND`：该值以`factor`每毫米的平均速度变化，但在离散的环上，每`BAND`毫米的Z高度才会进行调整。使用的公式是：`value = start + factor * ((floor(z_height / band) + .5) * band)`。
- `STEP_DELTA` and `STEP_HEIGHT`: The value changes by `STEP_DELTA` every `STEP_HEIGHT` millimeters. The formula used is: `value = start + step_delta * floor(z_height / step_height)`. You can simply count bands or read tuning tower labels to determine the optimum value.

### [virtual_sdcard]

如果启用了 [virtual_sdcard 配置分段](Config_Reference.md#virtual_sdcard)，Klipper 支持以下标准 G-Code 命令：

- 列出SD卡：`M20` 。
- 初始化SD卡：`M21`
- 选择SD卡文件：`M23 <filename>`
- 开始/暂停 SD 卡打印：`M24`
- 暂停 SD 卡打印： `M25`
- 设置 SD 块位置：`M26 S<偏移>`。
- 报告SD卡打印状态：`M27`

此外，当启用"virtual_sdcard"配置分段时，以下扩展命令可用。

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<文件名>`：载入一个文件并开始 SD 打印

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`：卸载文件并清除SD状态。

### [z_thermal_adjust]

The following commands are available when the [z_thermal_adjust config section](Config_Reference.md#z_thermal_adjust) is enabled.

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<value>] [REF_TEMP=<value>]`: Enable or disable the Z thermal adjustment with `ENABLE`. Disabling does not remove any adjustment already applied, but will freeze the current adjustment value - this prevents potentially unsafe downward Z movement. Re-enabling can potentially cause upward tool movement as the adjustment is updated and applied. `TEMP_COEFF` allows run-time tuning of the adjustment temperature coefficient (i.e. the `TEMP_COEFF` config parameter). `TEMP_COEFF` values are not saved to the config. `REF_TEMP` manually overrides the reference temperature typically set during homing (for use in e.g. non-standard homing routines) - will be reset automatically upon homing.

### [z_tilt]

The following commands are available when the [z_tilt config section](Config_Reference.md#z_tilt) is enabled.

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.
