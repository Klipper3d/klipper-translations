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

#### ANGLE_CHIP_CALIBRATE

`ANGLE_CHIP_CALIBRATE CHIP=<chip_name>`: Perform internal sensor calibration, if implemented (MT6826S/MT6835).

- **MT68XX**: The motor should be disconnected from any printer carriage before performing calibration. After calibration, the sensor should be reset by disconnecting the power.

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<配置名> REG=<寄存器>`：查询传感器寄存器"寄存器"（例如：44或0x2C）。该命令常用于调试，仅适用于tle5012b芯片。

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<配置名> REG=<寄存器> VAL=<值>`：将“值”写入“寄存器”。“值”和“寄存器”可以是十进制或十六进制整数。请小心使用，并参考传感器数据手册。仅适用于 tle5012b芯片。

### [axis_twist_compensation]

The following commands are available when the [axis_twist_compensation config
section](Config_Reference.md#axis_twist_compensation) is enabled.

#### AXIS_TWIST_COMPENSATION_CALIBRATE

`AXIS_TWIST_COMPENSATION_CALIBRATE [AXIS=<X|Y>] [SAMPLE_COUNT=<value>]`

Calibrates axis twist compensation by specifying the target axis or enabling automatic calibration.

- **AXIS:** Define the axis (`X` or `Y`) for which the twist compensation will be calibrated. If not specified, the axis defaults to `'X'`.

### [bed_mesh]

启用[床网格配置部分]（config_Reference.md#bed_mesh）时，以下命令可用（另请参阅[床网格指南]（bed_mesh.md））。

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [PROFILE=<name>] [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=1] [ADAPTIVE_MARGIN=<value>]`: This command probes the bed using generated points specified by the parameters in the config. After probing, a mesh is generated and z-movement is adjusted according to the mesh. The mesh is immediately active after successful completion of `BED_MESH_CALIBRATE`. The mesh will be saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. If ADAPTIVE=1 is specified then the profile name will begin with `adaptive-` and should not be saved for reuse. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file. If ADAPTIVE=1 is specified then the objects defined by the Gcode file being printed will be used to define the probed area. The optional `ADAPTIVE_MARGIN` value overrides the `adaptive_margin` option specified in the config file.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`：该命令将当前探测到的 Z 值和当前网格的值输出到终端。如果指定 PGP=1，则将bed_mesh产生的X、Y坐标，以及它们关联的指数，输出到终端。

#### BED_MESH_MAP

`BED_MESH_MAP`：类似 BED_MESH_OUTPUT，这个命令在终端中显示网格的当前状态。它不以人类可读格式打印，而是被序列化为 json 格式。这允许 Octoprint 插件捕获数据并生成描绘打印床表面的高度图。

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`：此命令清除床网并移除所有 z 调整。建议把它放在你的 end-gcode （结束G代码）中。

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<名称> SAVE=<名称> REMOVE=<名称>`：此命令提供了网床配置管理功能。LOAD 将从与所提供的名称相符的配置文件中恢复网格状态。SAVE 将会把目前的网格状态保存到与提供的名称相符的配置文件中。REMOVE（移除）将从持久性内存中删除与所提供名称相符的配置文件。请注意，在 SAVE 或 REMOVE 操作后，必须发送SAVE_CONFIG G代码，以保存变更到持久性内存。

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value]`：将 X、Y 和/或 ZFADE 偏移应用于网格查找。这对于具有独立挤出机的打印机非常有用，因为在更换工具后，偏移对于产生正确的 Z 调整是必需的。请注意，ZFADE 偏移不会直接应用额外的 z 调整，它用于在将 `gcode 偏移` 应用于 Z 轴时校正 `fade` 计算。

### [bed_screws]

以下命令当 [bed_screws 配置段](Config_Reference.md#bed_screws) 使能的时候可用 (也可参考 [手动调平指南](Manual_Level.md#adjusting-bed-leveling-screws))。

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`：该命令将调用打印床螺丝调整工具。它将命令喷嘴移动到不同的位置（在配置文件中定义），并允许对打印床螺丝进行手动调整，使打印床与喷嘴的距离保持不变。

### [bed_tilt]

当 [bed_tilt 配置部分](Config_Reference.md#bed_tilt) 被启用时，以下命令可用：

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`：此命令将探测配置中指定的点，然后推荐更新的 x 和 y 倾斜调整。有关可选探测参数的详细信息，请参阅 PROBE 命令。如果指定了 METHOD=manual，则将激活手动探测工具 - 有关此工具处于活动状态时可用的其他命令的详细信息，请参阅上面的 MANUAL_PROBE 命令。可选的 `HORIZONTAL_MOVE_Z` 值将覆盖配置文件中指定的 `horizontal_move_z` 选项。

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

`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`：此命令将探测床上的七个点并推荐更新的限位位置、塔角度和半径。有关可选探测参数的详细信息，请参阅 PROBE 命令。如果指定了 METHOD=manual，则将激活手动探测工具 - 有关此工具处于活动状态时可用的其他命令的详细信息，请参阅上面的 MANUAL_PROBE 命令。可选的 `HORIZONTAL_MOVE_Z` 值将覆盖配置文件中指定的 `horizontal_move_z` 选项。

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

`SET_DUAL_CARRIAGE CARRIAGE=<carriage> [MODE=[PRIMARY|COPY|MIRROR]]`: This command will change the mode of the specified carriage. If no `MODE` is provided it defaults to `PRIMARY`. `<carriage>` must reference a defined primary or dual carriage for `generic_cartesian` kinematics or be 0 (for primary carriage) or 1 (for dual carriage) for all other kinematics supporting IDEX. Setting the mode to `PRIMARY` deactivates the other carriage and makes the specified carriage execute subsequent G-Code commands as-is. `COPY` and `MIRROR` modes are supported only for dual carriages. When set to either of these modes, dual carriage will then track the subsequent moves of its primary carriage and either copy relative movements of it (in `COPY` mode) or execute them in the opposite (mirror) direction (in `MIRROR` mode).

#### SAVE_DUAL_CARRIAGE_STATE

`SAVE_DUAL_CARRIAGE_STATE [NAME=<state_name>]`: Save the current positions of the dual carriages and their modes. Saving and restoring DUAL_CARRIAGE state can be useful in scripts and macros, as well as in homing routine overrides. If NAME is provided it allows one to name the saved state to the given string. If NAME is not provided it defaults to "default".

#### RESTORE_DUAL_CARRIAGE_STATE

`RESTORE_DUAL_CARRIAGE_STATE [NAME=<state_name>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: Restore the previously saved positions of the dual carriages and their modes, unless "MOVE=0" is specified, in which case only the saved modes will be restored, but not the positions of the carriages. If positions are being restored and "MOVE_SPEED" is specified, then the toolhead moves will be performed with the given speed (in mm/s); otherwise the toolhead move will use the rail homing speed. Note that the carriages restore their positions only over their own axis, which may be necessary to correctly restore COPY and MIRROR mode of the dual carraige.

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

### [fan_generic]

当[fan_generic 配置分段](Config_Reference.md#fan_generic)被启用时，以下命令可用：

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<速度>`该命令设置风扇的速度。"速度" 必须在0.0到1.0之间。

`SET_FAN_SPEED PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given fan. For example, if one defined a `[display_template my_fan_template]` config section then one could assign `TEMPLATE=my_fan_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the fan will be automatically set to the resulting speed. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_FAN_SPEED` commands to manage the values directly).

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

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] [SET_HOMED=<[X][Y][Z]>] [CLEAR_HOMED=<[X][Y][Z]>]`: Force the low-level kinematic code to believe the toolhead is at the given cartesian position and set/clear homed status. This is a diagnostic and debugging command; use SET_GCODE_OFFSET and/or G92 for regular axis transformations. Setting an incorrect or invalid position may lead to internal software errors.

The `X`, `Y`, and `Z` parameters are used to alter the low-level kinematic position tracking. If any of these parameters are not set then the position is not changed - for example `SET_KINEMATIC_POSITION Z=10` would set all axes as homed, set the internal Z position to 10, and leave the X and Y positions unchanged. Changing the internal position tracking is not dependent on the internal homing state - one may alter the position for both homed and not homed axes, and similarly one may set or clear the homing state of an axis without altering its internal position.

The `SET_HOMED` parameter defaults to `XYZ` which instructs the kinematics to consider all axes as homed. A bare `SET_KINEMATIC_POSITION` command will result in all axes being considered homed (and not change its current position). If it is not desired to change the state of homed axes then assign `SET_HOMED` to an empty string - for example: `SET_KINEMATIC_POSITION SET_HOMED= X=10`. It is also possible to request an individual axis be considered homed (eg, `SET_HOMED=X`), but note that non-cartesian style kinematics (such as delta kinematics) may not support setting an individual axis as homed.

The `CLEAR_HOMED` parameter instructs the kinematics to consider the given axes as not homed. For example, `CLEAR_HOMED=XYZ` would request all axes to be considered not homed (and thus require homing prior to movement on those axes). The default is `SET_HOMED=XYZ` even if `CLEAR_HOMED` is present, so the command `SET_KINEMATIC_POSITION CLEAR_HOMED=Z` will set X and Y as homed and clear the homing state for Z. Use `SET_KINEMATIC_POSITION SET_HOMED= CLEAR_HOMED=Z` if the goal is to clear only the Z homing state. If an axis is specified in neither `SET_HOMED` nor `CLEAR_HOMED` then its homing state is not changed and if it is specified in both then `CLEAR_HOMED` has precedence. It is possible to request clearing of an individual axis, but on non-cartesian style kinematics (such as delta kinematics) doing so may result in clearing the homing state of additional axes. Note the `CLEAR` parameter is currently an alias for the `CLEAR_HOMED` parameter, but this alias will be removed in the future.

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

- 顺时针圆弧运动 (G2), 逆时针圆弧运动 (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`
- 选择圆弧运动参考面: G17 (XY 平面), G18 (XZ 平面), G19 (YZ 平面)

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

### [generic_cartesian]

The commands in this section become automatically available when `kinematics: generic_cartesian` is specified as the printer kinematics.

#### SET_STEPPER_CARRIAGES

`SET_STEPPER_CARRIAGES STEPPER=<stepper_name> CARRIAGES=<carriages> [DISABLE_CHECKS=[0|1]]`: Set or update the stepper carriages. `<stepper_name>` must reference an existing stepper defined in `printer.cfg`, and `<carriages>` describes the carriages the stepper moves. See [Generic Cartesian Kinematics](Config_Reference.md#generic-cartesian-kinematics) for a more detailed overview of the `carriages` parameter in the stepper configuration section. Note that it is only possible to change the coefficients or signs of the carriages with this command, but a user cannot add or remove the carriages that the stepper controls.

`SET_STEPPER_CARRIAGES` is an advanced tool, and the user is advised to exercise an extreme caution using it, since specifying incorrect configuration may physically damage the printer.

Note that `SET_STEPPER_CARRIAGES` performs certain internal validations of the new printer kinematics after the change. Keep in mind that if it detects an issue, it may leave printer kinematics in an invalid state. This means that if `SET_STEPPER_CARRIAGES` reports an error, it is unsafe to issue other GCode commands, and the user must inspect the error message and either fix the problem, or manually restore the previous stepper(s) configuration.

Since `SET_STEPPER_CARRIAGES` can update a configuration of a single stepper at a time, some sequences of changes can lead to invalid intermediate kinematic configurations, even if the final configuration is valid. In such cases a user can pass `DISABLE_CHECKS=1` parameters to all but the last command to disable intermediate checks. For example, if `stepper a` and `stepper b` initially have `x-y` and `x+y` carriages correspondingly, then the following sequence of commands will let a user effectively swap the carriage controls: `SET_STEPPER_CARRIAGES STEPPER=a CARRIAGES=x+y DISABLE_CHECKS=1` and `SET_STEPPER_CARRIAGES STEPPER=b CARRIAGES=x-y`, while still validating the final kinematics state.

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

### [led]

The following command is available when any of the [led config sections](Config_Reference.md#leds) are enabled.

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: This sets the LED output. Each color `<value>` must be between 0.0 and 1.0. The WHITE option is only valid on RGBW LEDs. If the LED supports multiple chips in a daisy-chain then one may specify INDEX to alter the color of just the given chip (1 for the first chip, 2 for the second, etc.). If INDEX is not provided then all LEDs in the daisy-chain will be set to the provided color. If TRANSMIT=0 is specified then the color change will only be made on the next SET_LED command that does not specify TRANSMIT=0; this may be useful in combination with the INDEX parameter to batch multiple updates in a daisy-chain. By default, the SET_LED command will sync it's changes with other ongoing gcode commands. This can lead to undesirable behavior if LEDs are being set while the printer is not printing as it will reset the idle timeout. If careful timing is not needed, the optional SYNC=0 parameter can be specified to apply the changes without resetting the idle timeout.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: Assign a [display_template](Config_Reference.md#display_template) to a given [LED](Config_Reference.md#leds). For example, if one defined a `[display_template my_led_template]` config section then one could assign `TEMPLATE=my_led_template` here. The display_template should produce a comma separated string containing four floating point numbers corresponding to red, green, blue, and white color settings. The template will be continuously evaluated and the LED will be automatically set to the resulting colors. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If INDEX is not specified then all chips in the LED's daisy-chain will be set to the template, otherwise only the chip with the given index will be updated. If TEMPLATE is an empty string then this command will clear any previous template assigned to the LED (one can then use `SET_LED` commands to manage the LED's color settings).

### [load_cell]

The following commands are enabled if a [load_cell config section](Config_Reference.md#load_cell) has been enabled.

### LOAD_CELL_DIAGNOSTIC

`LOAD_CELL_DIAGNOSTIC [LOAD_CELL=<config_name>]`: This command collects 10 seconds of load cell data and reports statistics that can help you verify proper operation of the load cell. This command can be run on both calibrated and uncalibrated load cells.

### LOAD_CELL_CALIBRATE

`LOAD_CELL_CALIBRATE [LOAD_CELL=<config_name>]`: Start the guided calibration utility. Calibration is a 3 step process:

1. First you remove all load from the load cell and run the `TARE` command
1. Next you apply a known load to the load cell and run the `CALIBRATE GRAMS=nnn` command
1. Finally use the `ACCEPT` command to save the results

You can cancel the calibration process at any time with `ABORT`.

### LOAD_CELL_TARE

`LOAD_CELL_TARE [LOAD_CELL=<config_name>]`: This works just like the tare button on digital scale. It sets the current raw reading of the load cell to be the zero point reference value. The response is the percentage of the sensors range that was read and the raw value in counts. If the load cell is calibrated a force in grams is also reported.

### LOAD_CELL_READ load_cell="name"

`LOAD_CELL_READ [LOAD_CELL=<config_name>]`: This command takes a reading from the load cell. The response is the percentage of the sensors range that was read and the raw value in counts. If the load cell is calibrated a force in grams is also reported.

### [load_cell_probe]

The following commands are enabled if a [load_cell config section](Config_Reference.md#load_cell_probe) has been enabled.

### LOAD_CELL_TEST_TAP

`LOAD_CELL_TEST_TAP [TAPS=<taps>] [TIMEOUT=<timeout>]`: Run a testing routine that reports taps on the load cell. The toolhead will not move but the load cell probe will sense taps just as if it was probing. This can be used as a sanity check to make sure that the probe works. This tool replaces QUERY_ENDSTOPS and QUERY_PROBE for load cell probes.

- `TAPS`: the number of taps the tool expects
- `TIMEOOUT`: the time, in seconds, that the tool waits for each tab before aborting.

### Load Cell Command Extensions

Commands that perform probes, such as [`PROBE`](#probe), [`PROBE_ACCURACY`](#probe_accuracy), [`BED_MESH_CALIBRATE`](#bed_mesh_calibrate) etc. will accept additional parameters if a `[load_cell_probe]` is defined. The parameters override the corresponding settings from the [`[load_cell_probe]`](./Config_Reference.md#load_cell_probe) configuration:

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

`MANUAL_STEPPER STEPPER=config_name GCODE_AXIS=[A-Z] [LIMIT_VELOCITY=<velocity>] [LIMIT_ACCEL=<accel>] [INSTANTANEOUS_CORNER_VELOCITY=<velocity>]`: If the `GCODE_AXIS` parameter is specified then it configures the stepper motor as an extra axis on `G1` move commands. For example, if one were to issue a `MANUAL_STEPPER ... GCODE_AXIS=R` command then one could issue commands like `G1 X10 Y20 R30` to move the stepper motor. The resulting moves will occur synchronously with the associated toolhead xyz movements. If the motor is associated with a `GCODE_AXIS` then one may no longer issue movements using the above `MANUAL_STEPPER` command - one may unregister the stepper with a `MANUAL_STEPPER ... GCODE_AXIS=` command to resume manual control of the motor. The `LIMIT_VELOCITY` and `LIMIT_ACCEL` parameters allow one to reduce the speed of `G1` moves if those moves would result in a velocity or acceleration above the specified limits. The `INSTANTANEOUS_CORNER_VELOCITY` specifies the maximum instantaneous velocity change (in mm/s) of the motor during the junction of two moves (the default is 1mm/s).

### [mcp4018]

The following command is available when a [mcp4018 config section](Config_Reference.md#mcp4018) is enabled.

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: This command will change the current value of the digipot. This value should typically be between 0.0 and 1.0, unless a 'scale' is defined in the config. When 'scale' is defined, then this value should be between 0.0 and 'scale'.

### [output_pin]

使用[output_pin 配置分段](Config_Reference.md#output_pin)时，以下命令可用：

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value>`: Set the pin to the given output `VALUE`. VALUE should be 0 or 1 for "digital" output pins. For PWM pins, set to a value between 0.0 and 1.0, or between 0.0 and `scale` if a scale is configured in the output_pin config section.

`SET_PIN PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given pin. For example, if one defined a `[display_template my_pin_template]` config section then one could assign `TEMPLATE=my_pin_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the pin will be automatically set to the resulting value. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_PIN` commands to manage the values directly).

### [palette2]

当[palette2 配置分段](Config_Reference.md#palette2)被启用时，以下命令可用：

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

### [pid_calibrate]

The pid_calibrate module is automatically loaded if a heater is defined in the config file.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`：执行一个PID校准测试。指定的加热器将被启用，直到达到指定的目标温度，然后加热器将被关闭和开启几个周期。如果WRITE_FILE参数被启用，那么将创建文件/tmp/heattest.txt，其中包含测试期间所有温度样本的日志。

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

### [probe_eddy_current]

The following commands are available when a [probe_eddy_current config section](Config_Reference.md#probe_eddy_current) is enabled.

#### PROBE_EDDY_CURRENT_CALIBRATE

`PROBE_EDDY_CURRENT_CALIBRATE CHIP=<config_name>`: This starts a tool that calibrates the sensor resonance frequencies to corresponding Z heights. The tool will take a couple of minutes to complete. After completion, use the SAVE_CONFIG command to store the results in the printer.cfg file.

#### LDC_CALIBRATE_DRIVE_CURRENT

`LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` 此工具将校准 ldc1612 DRIVE_CURRENT0 寄存器。在使用此工具之前，请移动传感器，使其靠近床的中心，并距床表面约 20 毫米。运行此命令以确定传感器的适当 DRIVE_CURRENT。运行此命令后，使用 SAVE_CONFIG 命令将新设置存储在 Printer.cfg 配置文件中。

### [pwm_cycle_time]

The following command is available when a [pwm_cycle_time config section](Config_Reference.md#pwm_cycle_time) is enabled.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: This command works similarly to [output_pin](#output_pin) SET_PIN commands. The command here supports setting an explicit cycle time using the CYCLE_TIME parameter (specified in seconds). Note that the CYCLE_TIME parameter is not stored between SET_PIN commands (any SET_PIN command without an explicit CYCLE_TIME parameter will use the `cycle_time` specified in the pwm_cycle_time config section).

### [quad_gantry_level]

The following commands are available when the [quad_gantry_level config section](Config_Reference.md#quad_gantry_level) is enabled.

#### QUAD_GANTRY_LEVEL

`QUAD_GANTRY_LEVEL [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `RETRIES`, `RETRY_TOLERANCE`, and `HORIZONTAL_MOVE_Z` values override those options specified in the config file.

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

`TEST_RESONANCES AXIS=<axis> [OUTPUT=<resonances,raw_data>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [POINT=x,y,z] [INPUT_SHAPING=<0:1>]`: Runs the resonance test in all configured probe points for the requested "axis" and measures the acceleration using the accelerometer chips configured for the respective axis. "axis" can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. `chip_name` can be one or more configured accel chips, delimited with comma, for example `CHIPS="adxl345, adxl345 rpi"`. If POINT is specified it will override the point(s) configured in `[resonance_tester]`. If `INPUT_SHAPING=0` or not set(default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured or POINT is specified). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>][HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [MAX_SMOOTHING=<max_smoothing>] [INPUT_SHAPING=<0:1>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command, and if `[input_shaper]` was already enabled previously, these parameters take effect immediately.

### [respond]

The following standard G-Code commands are available when the [respond config section](Config_Reference.md#respond) is enabled:

- `M118 <message>`：回显配置了默认前缀的信息（如果没有配置前缀，则返回`echo: `）。

还可以使用以下额外命令：

#### RESPOND

- `RESPOND MSG="<message>"`：回显带有配置的默认前缀的消息（没有配置前缀则默认 `echo: `为前缀 ）。
- `RESPOND TYPE=echo MSG="<消息>"`：回显`echo:`开头消息。
- `RESPOND TYPE=echo_no_space MSG="<message>"`：回显以`echo:`为前缀的消息，前缀和消息之间没有空格，有助于兼容一些需要非常特定格式的 octoprint 插件。
- `RESPOND TYPE=command MSG="<消息>"`：回显以`/`为前缀的消息。可以配置 OctoPrint 对这些消息进行响应（例如，`RESPOND TYPE=command MSG=action:pause`）。
- `RESPOND TYPE=error MSG="<消息>"`：回显以 `!!`开头的消息。
- `RESPOND PREFIX=<prefix> MSG="<message>"`: 回应以`<prefix>`为前缀的信息。(`PREFIX`参数将优先于`TYPE`参数)

### [save_variables]

The following command is enabled if a [save_variables config section](Config_Reference.md#save_variables) has been enabled.

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`: Saves the variable to disk so that it can be used across restarts. The VARIABLE must be lowercase. All stored variables are loaded into the `printer.save_variables.variables` dict at startup and can be used in gcode macros. The provided VALUE is parsed as a Python literal.

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

### [temperature_probe]

The following commands are available when a [temperature_probe config section](Config_Reference.md#temperature_probe) is enabled.

#### TEMPERATURE_PROBE_CALIBRATE

`TEMPERATURE_PROBE_CALIBRATE [PROBE=<probe name>] [TARGET=<value>] [STEP=<value>]`: Initiates probe drift calibration for eddy current based probes. The `TARGET` is a target temperature for the last sample. When the temperature recorded during a sample exceeds the `TARGET` calibration will complete. The `STEP` parameter sets temperature delta (in C) between samples. After a sample has been taken, this delta is used to schedule a call to `TEMPERATURE_PROBE_NEXT`. The default `STEP` is 2.

#### TEMPERATURE_PROBE_NEXT

`TEMPERATURE_PROBE_NEXT`: After calibration has started this command is run to take the next sample. It is automatically scheduled to run when the delta specified by `STEP` has been reached, however its also possible to manually run this command to force a new sample. This command is only available during calibration.

#### TEMPERATURE_PROBE_COMPLETE:

`TEMPERATURE_PROBE_COMPLETE`: Can be used to end calibration and save the current result before the `TARGET` temperature is reached. This command is only available during calibration.

#### 关于

`ABORT`：中止校准过程，丢弃当前结果。此命令仅在漂移校准期间可用。

### TEMPERATURE_PROBE_ENABLE

`TEMPERATURE_PROBE_ENABLE ENABLE=[0|1]`: Sets temperature drift compensation on or off. If ENABLE is set to 0, drift compensation will be disabled, if set to 1 it is enabled.

### [tmcXXXX]

The following commands are available when any of the [tmcXXXX config sections](Config_Reference.md#tmc-stepper-driver-configuration) are enabled.

#### DUMP_TMC

`DUMP_TMC STEPPER=<name> [REGISTER=<name>]`：此命令将读取所有 TMC 驱动器寄存器并报告其值。如果提供了 REGISTER，则只会转储指定的寄存器。

#### INIT_TMC

`INIT_TMC STEPPER=<名称>`：此命令将初始化 TMC 寄存器。如果芯片的电源关闭然后重新打开，则需要重新启用该驱动。

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: This will adjust the run and hold currents of the TMC driver. `HOLDCURRENT` is not applicable to tmc2660 drivers. When used on a driver which has the `globalscaler` field (tmc5160 and tmc2240), if StealthChop2 is used, the stepper must be held at standstill for >130ms so that the driver executes the AT#1 calibration.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name>FIELD=<FIELD>VALUE=<VALUE>VELOCITY=<VALUE>`：这将更改TMC驱动器的指定寄存器字段的值。此命令仅用于低级别诊断和调试，因为在运行时更改字段可能会导致打印机出现不希望出现的潜在危险行为。应使用打印机配置文件进行永久性更改。没有对给定的值执行健全性检查。也可以指定VELOCITY而不是VALUE。该速度被转换为基于20位TSTEP的值表示。仅对表示速度的字段使用VELOCITY参数。

### [toolhead]

The toolhead module is automatically loaded.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [MINIMUM_CRUISE_RATIO=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: This command can alter the velocity limits that were specified in the printer config file. See the [printer config section](Config_Reference.md#printer) for a description of each parameter.

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

`Z_TILT_ADJUST [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `RETRIES`, `RETRY_TOLERANCE`, and `HORIZONTAL_MOVE_Z` values override those options specified in the config file.
