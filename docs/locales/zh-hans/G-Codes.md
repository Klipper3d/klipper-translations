# G-Codes

This document describes the commands that Klipper supports. These are commands that one may enter into the OctoPrint terminal tab.

## G代码命令

Klipper支持以下标准的G-Code命令：

- 移动 (G0 or G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- 停留时间：`G4 P<milliseconds>`
- 返回原点：`G28 [X] [Y] [Z]`
- Turn off motors: `M18` or `M84`
- Wait for current moves to finish: `M400`
- Use absolute/relative distances for extrusion: `M82`, `M83`
- Use absolute/relative coordinates: `G90`, `G91`
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
- Turn fan off: `M107`
- 紧急停止：`M112`
- 获取当前位置：`M114`
- 获取固件版本：`M115`

有关上述命令的更多详细信息，请参阅 [RepRap G-Code documentation](http://reprap.org/wiki/G-code)

Klipper的目标是支持普通第三方软件（如OctoPrint、Printrun、Slic3r、Cura等）在其标准配置中产生的G-Code命令。支持所有可能的G-Code命令并不是我们的目标。相反，Klipper更倾向于使用人类可读的["extended G-Code commands"](#extended-g-code-commands).

如果一个人需要一个不太常见的G-Code命令，那么可以用一个自定义的[gcode_macro config section](Config_Reference.md#gcode_macro)来实现它。例如，我们可以用这个来实现。`G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1` ，etc

### G-Code SD卡命令

如果[virtual_sdcard config section](Config_Reference.md#virtual_sdcard)被启用，Klipper也支持以下标准G-Code命令。

- 列出SD卡：`M20` 。
- 初始化SD卡：`M21`
- 选择SD卡文件：`M23 <filename>`
- 开始/暂停 SD 卡打印：`M24`
- 暂停 SD 卡打印： `M25`
- 设置 SD 块位置：`M26 S<偏移>`。
- 报告SD卡打印状态：`M27`

此外，当 "virtual_sdcard "配置部分被启用时，可以使用以下扩展命令。

- 加载文件并且开始SD卡打印：`SDCARD_PRINT_FILE FILENAME=<filename>`
- Unload file and clear SD state: `SDCARD_RESET_FILE`

### G-Code弧

The following standard G-Code commands are available if a [gcode_arcs config section](Config_Reference.md#gcode_arcs) is enabled:

- 受控弧线移动（G2或G3）。`G2 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>` 。

### G-Code固件回抽

The following standard G-Code commands are available if a [firmware_retraction config section](Config_Reference.md#firmware_retraction) is enabled:

- 回抽：`G10`
- Unretract: `G11`

### G-Code 显示命令

The following standard G-Code commands are available if a [display config section](Config_Reference.md#display) is enabled:

- 显示信息： `M117 <message> `
- 设置构建百分比：`M73 P<percent>`

### 其他可用的G-Code命令

The following standard G-Code commands are currently available, but using them is not recommended:

- 获取限位状态：`M119` (使用QUERY_ENDSTOPS代替)

## 扩展的G-Code 命令

Klipper使用 "extended" 的G代码命令来进行一般的配置和状态。这些扩展命令都遵循一个类似的格式--它们以一个命令名开始，后面可能有一个或多个参数。比如说：`SET_SERVO SERVO=myservo ANGLE=5.3`。在本文件中，命令和参数以大写字母显示，但它们不分大小写。(所以，"SET_SERVO "和 "set_servo "都是运行同一个命令）

The following standard commands are supported:

- `QUERY_ENDSTOPS`：检测限位并返回限位是否被 "triggered"或处于"open"。该命令通常用于验证一个限位是否正常工作。
- `QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]` ：返回为配置的模拟引脚收到的最后一个模拟值。如果NAME没有被提供，将报告可用的adc名称列表。如果提供了PULLUP（以欧姆为单位的数值），将会返回原始模拟值和给定的等效电阻。
- `GET_POSITION`：返回工具当前位置信息
- `SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]` 。设置一个位置偏移，以应用于未来的G代码命令。这通常用于实际改变Z床的偏移量或在切换挤出机时设置喷嘴的XY偏移量。例如，如果发送 "SET_GCODE_OFFSET Z=0.2"，那么未来的G代码移动将在其Z高度上增加0.2mm。如果使用X_ADJUST风格的参数，那么调整将被添加到任何现有的偏移上（例如，"SET_GCODE_OFFSET Z=-0.2"，然后是 "SET_GCODE_OFFSET Z_ADJUST=0.3"，将导致总的Z偏移为0.1）。如果指定了 "MOVE=1"，那么将发出一个工具头移动来应用给定的偏移量（否则偏移量将在指定给定轴的下一次绝对G-Code移动中生效）。如果指定了 "MOVE_SPEED"，那么刀头移动将以给定的速度（mm/s）执行；否则，打印头移动将使用最后指定的G-Code速度。
- `SAVE_GCODE_STATE [NAME=<state_name>]`：保存当前的g-code坐标解析状态。保存和恢复g-code状态在脚本和宏中很有用。该命令保存当前g-code绝对坐标模式（G90/G91）绝对挤出模式（M82/M83）原点（G92）偏移量（SET_GCODE_OFFSET）速度覆盖（M220）挤出机覆盖（M221）移动速度。当前XYZ位置和相对挤出机 "E "位置。如果提供NAME，它允许人们将保存的状态命名为给定的字符串。如果没有提供NAME，则默认为 "default"
- `RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`：恢复之前通过 SAVE_GCODE_STATE 保存的状态。如果指定“MOVE=1”，则将发出刀头移动以返回到先前的 XYZ 位置。如果指定了“MOVE_SPEED”，则刀头移动将以给定的速度（以mm/s为单位）执行；否则工具头移动将使用恢复的G-Code速度。
- `PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`：执行一个PID校准测试。指定的加热器将被启用，直到达到指定的目标温度，然后加热器将被关闭和开启几个周期。如果WRITE_FILE参数被启用，那么将创建文件/tmp/heattest.txt，其中包含测试期间所有温度样本的日志。
- `TURN_OFF_HEATERS`: Turn off all heaters.
- `TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Wait until the given temperature sensor is at or above the supplied MINIMUM and/or at or below the supplied MAXIMUM.
- `SET_VELOCITY_LIMIT [VELOCITY=<值>] [ACCEL=<值>] [ACCEL_TO_DECEL=<值>] [SQUARE_CORNER_VELOCITY=<值>]`：修改打印机速度限制。
- `SET_HEATER_TEMPERATURE HEATER=<加热器名称> [TARGET=<目标温度>]`：设置一个加热器的目标温度。如果没有提供目标温度，则目标温度为 0。
- `ACTIVATE_EXTRUDER EXTRUDER=<config_name>`：这个命令在具有多个挤出机的打印机中用于更改活动挤出机。
- `SET_PRESSURE_ADVANCE [EXTRUDER=<挤出机名称>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]` ：设置压力提前的参数。如果没有指定挤出机，则默认为活动的挤出机。
- `SET_EXTRUDER_STEP_DISTANCE [EXTRUDER=<config_name>] [DISTANCE=<distance>]`。为所提供的挤出机的 "步距 "设置一个新值。"步距 "是 `rotation_distance/(full_steps_per_rotation*microsteps)`。Klipper复位时，该值不会被保留。谨慎使用，小的变化会导致挤出机和热端之间的压力过大。在使用前，请用打印材料做适当的校准步骤。如果不包括'DISTANCE'值，命令将返回当前步距。
- `SET_STEPPER_ENABLE STEPPER=<配置名> ENABLE=[0|1]` 。启用或禁用指定的步进电机。这是一个诊断和调试工具，必须谨慎使用。因为禁用一个轴电机不会重置归位信息，手动移动一个被禁用的步进可能会导致机器在安全限值外操作电机。这可能导致轴结构、热端和打印件的损坏。
- `STEPPER_BUZZ STEPPER=<配置名>`：移动指定的步进电机前后运动一毫米，重复的10次。这是一个用于验证步进电机接线的工具
- `MANUAL_PROBE [SPEED=<speed>]`：运行一个辅助脚本，对测量给定位置的喷嘴高度有用。如果指定了速度，它将设置TESTZ命令的速度（默认为5mm/s）。在手动探测过程中，可使用以下附加命令：
   - `ACCEPT`：该命令接受当前的Z位置，并结束手动探测工具。
   - `ABORT`：该命令终止手动探测工具。
   - `TESTZ Z=<value>`: This command moves the nozzle up or down by the amount specified in "value". For example, `TESTZ Z=-.1` would move the nozzle down .1mm while `TESTZ Z=.1` would move the nozzle up .1mm. The value may also be `+`, `-`, `++`, or `--` to move the nozzle up or down an amount relative to previous attempts.
- `Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: Run a helper script useful for calibrating a Z position_endstop config setting. See the MANUAL_PROBE command for details on the parameters and the additional commands available while the tool is active.
- `Z_OFFSET_APPLY_ENDSTOP`: Take the current Z Gcode offset (aka, babystepping), and subtract it from the stepper_z endstop_position. This acts to take a frequently used babystepping value, and "make it permanent". Requires a `SAVE_CONFIG` to take effect.
- `TUNING_TOWER COMMAND=<command> PARAMETER=<name> START=<value> [SKIP=<value>] [FACTOR=<value> [BAND=<value>]] | [STEP_DELTA=<value> STEP_HEIGHT=<value>]`: A tool for tuning a parameter on each Z height during a print. The tool will run the given `COMMAND` with the given `PARAMETER` assigned to a value that varies with `Z` according to a formula. Use `FACTOR` if you will use a ruler or calipers to measure the Z height of the optimum value, or `STEP_DELTA` and `STEP_HEIGHT` if the tuning tower model has bands of discrete values as is common with temperature towers. If `SKIP=<value>` is specified, the tuning process doesn't begin until Z height `<value>` is reached, and below that the value will be set to `START`; in this case, the `z_height` used in the formulas below is actually `max(z - skip, 0)`. There are three possible combinations of options:
   - `FACTOR`：值以每毫米`factor` 的速度变化。使用的公式是`value = start + factor * z_height`。你可以把最佳的Z高度直接插入公式中，以确定最佳的参数值。
   - `FACTOR`和`BAND`：值以每毫米`factor`的平均速度变化，但在离散的带子中，每隔`BAND`毫米的Z高度才会进行调整。使用的公式是 `value = start + factor * ((floor(z_height / band) + .5) * band)`。
   - `STEP_DELTA` and `STEP_HEIGHT`: The value changes by `STEP_DELTA` every `STEP_HEIGHT` millimeters. The formula used is `value = start + step_delta * floor(z_height / step_height)`. You can simply count bands or read tuning tower labels to determine the optimum value.
- `SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`:设置一个lcd显示器的活动显示组。这允许在配置中定义多个显示数据组，例如`[display_data <group> <elementname>]`并使用这个扩展的gcode命令在它们之间切换。如果没有指定DISPLAY，则默认为 "display"（主显示）。
- `SET_IDLE_TIMEOUT [TIMEOUT=<超时>]`：允许用户设置空闲超时（以秒为单位）。
- `RESTART`：这将导致主机软件重新加载其配置并执行内部重置。此命令不会从微控制器清除错误状态（请参阅 FIRMWARE_RESTART），也不会加载新软件（请参阅 [常见问题](FAQ.md#how-do-i-upgrade-to-the-latest-software)） .
- `FIRMWARE_RESTART`：这类似于重启命令，但它也清除了微控制器的任何错误状态。
- `SAVE_CONFIG`：该命令将覆盖打印机的主配置文件，并重新启动主机软件。该命令与其他校准命令一起使用，用于存储校准测试的结果。
- `STATUS`：报告Klipper主机程序的状态。
- `HELP`：报告可用的扩展G-Code命令列表。

### G-Code宏命令

当[gcode_macro 配置分段](Config_Reference.md#gcode_macro)被启用时，以下命令可用（另请参见[命令模板指南](Command_Templates.md)）：

- `SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`：这条命令允许人们在运行时改变 gcode_macro 变量的值。所提供的 VALUE 会被解析为一个 Python 字面。

### 自定义引脚命令

当[output_pin 配置分段](Config_Reference.md#output_pin)被启用时，以下命令可用：

- `SET_PIN PIN=config_name VALUE=<值> CYCLE_TIME=<循环时间>`

注意：硬件PWM目前不支持CYCLE_TIME参数，将使用配置中定义的周期时间。

### 手动控制风扇命令

当启用 [fan_generic 配置分段](Config_Reference.md#fan_generic) 时，以下命令可用：

- `SET_FAN_SPEED FAN=config_name SPEED=<speed>` 此命令设置风扇的速度。<speed>必须在0.0和1.0之间。

### Neopixel 和 Dotstar 命令

当启用[neopixel 配置分段](Config_Reference.md#neopixel)或[dotstar 配置分段](Config_Reference.md#dotstar)时，以下命令可用：

- `SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: This sets the LED output. Each color `<value>` must be between 0.0 and 1.0. The WHITE option is only valid on RGBW LEDs. If multiple LED chips are daisy-chained then one may specify INDEX to alter the color of just the given chip (1 for the first chip, 2 for the second, etc.). If INDEX is not provided then all LEDs in the daisy-chain will be set to the provided color. If TRANSMIT=0 is specified then the color change will only be made on the next SET_LED command that does not specify TRANSMIT=0; this may be useful in combination with the INDEX parameter to batch multiple updates in a daisy-chain. By default, the SET_LED command will sync it's changes with other ongoing gcode commands. This can lead to undesirable behavior if LEDs are being set while the printer is not printing as it will reset the idle timeout. If careful timing is not needed, the optional SYNC=0 parameter can be specified to apply the changes instantly and not reset the idle timeout.

### 舵机命令

The following commands are available when a [servo config section](Config_Reference.md#servo) is enabled:

- `SET_SERVO SERVO=配置名 [ANGLE=<角度> | WIDTH=<秒>]`：将舵机位置设置为给定的角度（度）或脉冲宽度（秒）。使用 `WIDTH=0` 来禁用舵机输出。

### 手动步进电机命令

当[manual_stepper 配置分段](Config_Reference.md#manual_stepper)被启用时，以下命令可用：

- `MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]]`：该命令将改变步进器的状态。使用ENABLE参数来启用/禁用步进。使用SET_POSITION参数，迫使步进认为它处于给定的位置。使用MOVE参数，要求移动到给定位置。如果指定了SPEED或者ACCEL，那么将使用给定的值而不是配置文件中指定的默认值。如果指定ACCEL为0，那么将不执行加速。如果STOP_ON_ENDSTOP=1被指定，那么如果止动器报告被触发，动作将提前结束（使用STOP_ON_ENDSTOP=2来完成动作，即使止动器没有被触发也不会出错，使用-1或-2来在止动器报告没有被触发时停止）。通常情况下，未来的G-Code命令将被安排在步进运动完成后运行，但是如果手动步进运动使用SYNC=0，那么未来的G-Code运动命令可能与步进运动平行运行。

### 挤出机步进电机命令

当[extruder_stepper 配置分段](Config_Reference.md#extruder_stepper)被启用时，以下命令可用：

- `SYNC_STEPPER_TO_EXTRUDER STEPPER=<extruder_stepper config_name> [EXTRUDER=<extruder config_name>]`: This command will cause the given STEPPER to become synchronized to the given EXTRUDER, overriding the extruder defined in the "extruder_stepper" config section.

### 探针

当[probe 配置分段](Config_Reference.md#probe)被启用时，以下命令可用（也请参见[探针校准指南](Probe_Calibrate.md)）：

- `PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`：向下移动喷嘴直到探针触发。如果提供了任何可选参数，它们将覆盖 [probe config section](Config_Reference.md#probe) 中的等效设置。
- `QUERY_PROBE`:报告探针的当前状态（"triggered"或 "open"）。
- `PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`：计算多个探针样本的最大、最小、平均、中位数和标准偏差。默认情况下采样10次。否则可选参数默认为探针配置部分的同等设置。
- `PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>] `:运行一个对校准测头的z_offset有用的辅助脚本。有关可选测头参数的详细信息，请参见PROBE命令。参见MANUAL_PROBE命令，了解SPEED参数和工具激活时可用的附加命令的详细信息。请注意，PROBE_CALIBRATE命令使用速度变量在XY方向以及Z方向上移动。
- `Z_OFFSET_APPLY_PROBE`: Take the current Z Gcode offset (aka, babystepping), and subtract if from the probe's z_offset. This acts to take a frequently used babystepping value, and "make it permanent". Requires a `SAVE_CONFIG` to take effect.

### BLTouch

当启用 [bltouch 配置分段](Config_Reference.md#bltouch) 时，以下命令可用（另请参阅 [BL-Touch 指南](BLTouch.md)）：


   - `BLTOUCH_DEBUG COMMAND=<command>`:这将向BLTouch发送一个命令。这可能对调试很有用。可用的命令有 `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`, (*1): `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store`*** 注意，标有（*1）的命令仅由BL-TOUCH V3.0或V3.1（+）支持。
- `BLTOUCH_STORE MODE=<output_mode>`:这将在BLTouch V3.1的EEPROM中存储一个输出模式 可用的输出模式有`5V`, `OD`

### 三角洲校准

当[delta_calibrate 配置分段](Config_Reference.md#linear-delta-kinematics)被启用时，以下命令可用（另请参阅[三角洲校准指南](Delta_Calibrate.md)）：

- `DELTA_CALIBRATE [Method=manual] [<probe_parameter>=<value>] `:这条命令将探测床身的七个点，并建议更新限位位置、塔架角度和半径。有关可选探测参数的详细信息，请参见PROBE命令。如果指定METHOD=manual，那么手动探测工具将被激活 - 关于该工具激活时可用的附加命令的详细信息，请参见上面的MANUAL_PROBE命令。
- `DELTA_ANALYZE`:这个命令在增强的delta校准过程中使用。详情见[Delta Calibrate](Delta_Calibrate.md)。

### 打印床倾斜

当 [bed_tilt 配置分段](Config_Reference.md#bed_tilt)被启用时，以下命令可用：

- `BED_TILT_CALIBRATE [Method=manual] [<probe_parameter>=<value>] `:该命令将探测配置中指定的点，然后建议更新X和Y的倾斜调整。有关可选探测参数的详细信息，请参见PROBE命令。如果指定METHOD=manual，那么手动探测工具就会被激活 - 关于该工具激活时可用的附加命令，请参见上面的MANUAL_PROBE命令。

### 网床调平

当[bed_mesh配置分段](Config_Reference.md#bed_mesh)被启用时，以下命令是可用的（另请参阅[床网指南](Bed_Mesh.md)）：

- `BED_MESH_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>] [<mesh_parameter>=<value>]`: 此命令使用通过配置参数指定并生成的探测点探测打印床。在探测后，一个网格将被生成，z 轴移动将根据网格调整。有关可选探测参数，请见 PROBE命令。如果指定 METHOD=manual ，则会启动手动探测工具 - 有关此工具活跃时可用的额外命令，详见 MANUAL_PROBE 命令。
- `BED_MESH_OUTPUT PGP=[<0:1>]`：此命令输出当前探测的 z 值和当前网格数值们到终端。如果指定 PGP=1 则 bed_mesh 生成的 x,y 坐标和它们相关联的索引将被输出到终端。
- `BED_MESH_MAP`：类似 BED_MESH_OUTPUT，这个命令在终端中显示网格的当前状态。它不以人类可读格式打印，而是被序列化为 json 格式。这允许 Octoprint 插件捕获数据并生成描绘打印床表面的高度图。
- `BED_MESH_CLEAR`：此命令清除床网并移除所有 z 调整。建议把它放在你的 end-gcode （结束G代码）中。
- `BED_MESH_PROFILE LOAD=<name> SAVE=<name> REMOVE=<name>`：此命令提供网格状态的配置文件管理。LOAD 将从与所提供名称匹配的配置文件中恢复网格状态。SAVE 会将当前的网格状态保存到与所提供的名称相符的配置文件中。Remove（删除）将从持久性内存中删除与所提供名称相匹配的配置文件。请注意，在SAVE或REMOVE操作后，必须运行SAVE_CONFIG gcode，以便永久更改。
- `BED_MESH_OFFSET [X=<value>] [Y=<value>]`。将X和/或Y的偏移量应用于网格查找。这对具有多个独立挤出头的打印机很有用，因为偏移量对切换工具头后产生正确的 Z 值调整是至关重要的。

### 打印床螺丝助手

当 [bed_screws 配置分段](Config_Reference.md#bed_screws)被启用时，以下命令可用（另请参阅[手动调平指南](Manual_Level.md#adjusting-bed-leveling-screws)）：

- `BED_SCREWS_ADJUST`：该命令将调用打印床螺丝调整工具。它将命令喷嘴移动到不同的位置（在配置文件中定义），并允许对打印床螺丝进行手动调整，使打印床与喷嘴的距离保持不变。

### 打印床螺丝倾斜调整助手

The following commands are available when the [screws_tilt_adjust config section](Config_Reference.md#screws_tilt_adjust) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)):

- `SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [<probe_parameter>=<value>]`：该命令将调用热床丝杆调整工具。它将命令喷嘴到不同的位置（如配置文件中定义的）探测z高度，并计算出调整床面水平的旋钮旋转次数。如果指定了DIRECTION，旋钮的转动方向都是一样的，顺时针（CW）或逆时针（CCW）。有关可选探头参数的详细信息，请参见PROBE命令。重要的是：在使用这个命令之前，你必须先做一个G28。

### Z Tilt

The following commands are available when the [z_tilt config section](Config_Reference.md#z_tilt) is enabled:

- `Z_TILT_ADJUST [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters.

### 双滑车

当[dual_carriage 配置分段](Config_Reference.md#dual_carriage)被启用时，以下命令可用：

- `SET_DUAL_CARRIAGE CARRIAGE=[0|1]`:该命令将设置活动的滑块。它通常是在一个多挤出机配置中从 activate_gcode和deactivate_gcode字段调用。

### TMC stepper drivers

当启用了任何 [tmcXXXX 配置分段](Config_Reference.md#tmc-stepper-driver-configuration)时，以下命令可用：

- `DUMP_TMC STEPPER=<name>`。该命令将读取TMC驱动寄存器并报告其值。
- `INIT_TMC STEPPER=<name>`：该命令将初始化TMC寄存器。如果芯片的电源被关闭然后又被打开，需要重新启用驱动程序。
- `SET_TMC_CURRENT STEPPER=<名称> CURRENT=<安培> HOLDCURRENT=<安培>`：该命令修改TMC驱动的运行和保持电流（HOLDCURRENT 在 tmc2660 驱动上不起效）。
- `SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value>`: This will alter the value of the specified register field of the TMC driver. This command is intended for low-level diagnostics and debugging only because changing the fields during run-time can lead to undesired and potentially dangerous behavior of your printer. Permanent changes should be made using the printer configuration file instead. No sanity checks are performed for the given values.

### 通过步进相位进行限位调整

当[endstop_phase配置分段](Config_Reference.md#endstop_phase)被启用时，以下命令可用（也可参见[限位相位指南](Endstop_Phase.md)）：

- `ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]` 。如果没有提供STEPPER参数，那么该命令将报告在过去的归位操作中对端停步进相的统计。当提供STEPPER参数时，它会安排将给定的终点站相位设置写入配置文件中（与SAVE_CONFIG命令一起使用）。

### Force movement

当 [force_move 配置分段](Config_Reference.md#force_move)被启用时，以下命令可用：

- `FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]` 。该命令将以给定的恒定速度（mm/s）强制移动给定的步进器，移动距离（mm）。如果指定了ACCEL并且大于零，那么将使用给定的加速度（单位：mm/s^2）；否则不进行加速。不执行边界检查；不进行运动学更新；一个轴上的其他平行步进器将不会被移动。请谨慎使用，因为不正确的命令可能会导致损坏使用该命令几乎肯定会使低级运动学处于不正确的状态；随后发出G28命令以重置运动学。该命令用于低级别的诊断和调试。
- `SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>]`: Force the low-level kinematic code to believe the toolhead is at the given cartesian position. This is a diagnostic and debugging command; use SET_GCODE_OFFSET and/or G92 for regular axis transformations. If an axis is not specified then it will default to the position that the head was last commanded to. Setting an incorrect or invalid position may lead to internal software errors. This command may invalidate future boundary checks; issue a G28 afterwards to reset the kinematics.

### SD卡循环

When the [sdcard_loop config section](Config_Reference.md#sdcard_loop) is enabled, the following extended commands are available:

- `SDCARD_LOOP_BEGIN COUNT=<count>`：在SD打印中开始一个循环的部分。计数为0表示该部分应无限期地循环。
- `SDCARD_LOOP_END`：结束SD打印中的一个循环部分。
- `SDCARD_LOOP_DESIST`：完成现有的循环，不再继续迭代。

### 向主机发送消息（回复）

[response 配置分段](Config_Reference.md#respond)启用时，以下命令可用：

- `M118 <message>`：回显配置了默认前缀的信息（如果没有配置前缀，则返回`echo: `）。
- `RESPOND MSG="<message>"`：回显带有配置的默认前缀的消息（没有配置前缀则默认 `echo: `为前缀 ）。
- `RESPOND TYPE=echo MSG="<消息>"`：回显`echo:`开头消息。
- `RESPOND TYPE=command MSG="<消息>"`: 回显以`//`为前缀的消息。可以配置 OctoPrint 对这些信息响应（例如，`RESPOND TYPE=command MSG=action:pause`）。
- `RESPOND TYPE=error MSG="<消息>"`：回显以 `!!`开头的消息。
- `RESPOND PREFIX=<prefix> MSG="<message>"`: 回应以`<prefix>`为前缀的信息。(`PREFIX`参数将优先于`TYPE`参数)

### 暂停与恢复

The following commands are available when the [pause_resume config section](Config_Reference.md#pause_resume) is enabled:

- `PAUSE`：暂停当前的打印。当前的位置被报错以便在恢复时恢复。
- `RESUME [VELOCITY=<value>]`：从暂停中恢复打印，首先恢复以前保持的位置。VELOCITY参数决定了工具返回到原始捕捉位置的速度。
- `CLEAR_PAUSE`:清除当前的暂停状态而不恢复打印。如果一个人决定在暂停后取消打印，这很有用。建议将其添加到你的启动代码中，以确保每次打印时的暂停状态是新的。
- `CANCEL_PRINT`：取消当前的打印。

### 耗材传感器

当[filament_switch_sensor 或 filament_motion_sensor 配置分段](Config_Reference.md#filament_switch_sensor)被启用时，以下命令可用：

- `QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`。查询耗材传感器的当前状态。终端上显示的数据将取决于配置中定义的传感器类型。
- `SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]` ：设置灯丝传感器的开/关。如果 ENABLE 设置为 0，耗材传感器将被禁用，如果设置为 1是启用。

### 固件回抽

The following commands are available when the [firmware_retraction config section](Config_Reference.md#firmware_retraction) is enabled. These commands allow you to utilise the firmware retraction feature available in many slicers, to reduce stringing during non-extrusion moves from one part of the print to another. Appropriately configuring pressure advance reduces the length of retraction required.

- `SET_RETRACTION [RETRACT_LENGTH=<毫米>] [RETRACT_SPEED=<毫米每秒>] [UNRETRACT_EXTRA_LENGTH=<毫米>] [UNRETRACT_SPEED=<毫米每秒>]`：调整固件回抽所使用的参数。RETRACT_LENGTH 决定回抽和回填的耗材长度。回抽的速度通过 RETRACT_SPEED 调整，通常设置得比较高。回填的速度通过 UNRETRACT_SPEED 调整，虽然经常比RETRACT_SPEED 低，但不是特别重要。在某些情况下，在回填时增加少量的额外长度的耗材可能有益，这可以通过 UNRETRACT_EXTRA_LENGTH 设置。SET_RETRACTION 通常作为切片机耗材配置的一部分来设置，因为不同的耗材需要不同的参数设置。
- `GET_RETRACTION`:查询当前固件回抽所使用的参数并在终端显示。
- `G10`：使用当前配置的参数回抽挤出机。
- `G11`：不使用当前配置的参数回抽挤出机。

### 偏斜校正

The following commands are available when the [skew_correction config section](Config_Reference.md#skew_correction) is enabled (also see the [Skew Correction](Skew_Correction.md) guide):

- `SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`：用从校准打印中测量的数据（以毫米为单位）配置 [skew_correction] 模块。可以输入任何组合的平面，没有新输入的平面将保持它们原有的数值。如果传入 `CLEAR=1`，则全部偏斜校正将被禁用。
- `GET_CURRENT_SKEW`:以弧度和度数报告每个平面的当前打印机偏移。斜度是根据通过`SET_SKEW`代码提供的参数计算的。
- `CALC_MEASURED_SKEW [AC=<ac 长度>] [BD=<bd 长度>] [AD=<ad 长度>]`：计算并报告基于一个打印件测量的偏斜度（以弧度和角度为单位）。它可以用来验证应用校正后打印机的当前偏斜度。它也可以用来确定是否有必要进行偏斜矫正。有关偏斜矫正打印模型和测量方法详见[偏斜校正文档](Skew_Correction.md)。
- `SKEW_PROFILE [LOAD=<名称>] [SAVE=<名称>] [REMOVE=<名称>] `：管理歪斜校正配置。LOAD 将从与指定名称相匹配的配置中恢复偏斜状态。SAVE 将把当前的偏斜状态保存到与指定名称相匹配的配置文件中。REMOVE（删除）将从持久性内存中删除与指定名称相匹配的配置。请注意，在 SAVE 或 REMOVE 操作运行后，必须运行 SAVE_CONFIG G代码以使持久性存储器的变化永久化。

### 延迟 GCode

The following command is enabled if a [delayed_gcode config section](Config_Reference.md#delayed_gcode) has been enabled (also see the [template guide](Command_Templates.md#delayed-gcodes)):

- `UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: Updates the delay duration for the identified [delayed_gcode] and starts the timer for gcode execution. A value of 0 will cancel a pending delayed gcode from executing.

### 保存变量

如果[save_variables 配置分段](Config_Reference.md#save_variables)已被启用，则以下命令可用：

- `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`：将变量保存到磁盘，以便在重新启动时使用。所有存储的变量都会在启动时加载到 `printer.save_variables.variables` 目录中，并可以在 gcode 宏中使用。所提供的 VALUE 会被解析为一个 Python 字面。

### 共振补偿

如果[input_shaper 配置分段](Config_Reference.md#input_shaper)被启用，以下命令可用（另请参阅[共振补偿指南](Resonance_Compensation.md)）：

- `SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`：修改输入整形参数。注意 SHAPER_TYPE 参数会同时覆写 X 和 Y 轴的整形器类型，即使它们在 [input_shaper] 配置分段中有不同的整形器类型。SHAPER_TYPE 不能和 SHAPER_TYPE_X 和 SHAPER_TYPE_Y 参数同时使用。这些参数的细节请见[配置参考](Config_Reference.md#input_shaper)。

### 温控风扇命令

当[temperature_fan 配置分段](Config_Reference.md#temperature_fan)被启用时，以下命令可用。

- `SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>]  [max_speed=<max_speed>]`: Sets the target temperature for a temperature_fan. If a target is not supplied, it is set to the specified temperature in the config file. If speeds are not supplied, no change is applied.

### Adxl345 加速度传感器命令

当[adxl345配置分段](Config_Reference.md#adxl345)被启用时，以下命令可用：

- `ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]` 。以要求的每秒采样数启动加速度计测量。如果没有指定CHIP，则默认为 "adxl345"。该命令以启动-停止模式工作：第一次执行时，它开始测量，下次执行时停止测量。测量结果被写入一个名为`/tmp/adxl345-<chip>-<name>的文件中。csv`，其中`<chip>`是加速度计芯片的名称（`my_chip_name`来自`[adxl345 my_chip_name]`），`<name>`是可选NAME参数。如果没有指定NAME，则默认为当前时间，格式为 "YYYMMDD_HHMMSS"。如果加速度计在其配置部分没有名称（只是`[adxl345]`），那么`<chip >`部分的名称就不会生成。
- `ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: 查询加速度计的当前值。如果没有指定芯片，则默认为 "adxl345"。如果没有指定RATE，则使用默认值。该命令对于测试与ADXL345加速度计的连接非常有用：返回的数值之一应该是自由落体加速度（+/-芯片的一些噪声）。
- `ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`：查询ADXL345的 <register> 寄存器（例如44或0x2C）。对于调试来说是很有用的。
- `ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<reg> VAL=<value>`：将原始<value>写入寄存器<register>中。<value>和<register>都可以是一个十进制或十六进制的整数。使用时要注意，参考ADXL345数据表。

### 共振测试命令

The following commands are available when a [resonance_tester config section](Config_Reference.md#resonance_tester) is enabled (also see the [measuring resonances guide](Measuring_Resonances.md)):

- `MEASURE_AXES_NOISE`：测量并输出所有启用的加速度计芯片的所有轴的噪声。
- `TEST_RESONANCES AXIS=<axis> OUTPUT=<resonances,raw_data> [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [INPUT_SHAPING=[<0:1>]]`: Runs the resonance test in all configured probe points for the requested <axis> and measures the acceleration using the accelerometer chips configured for the respective axis. <axis> can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. If `INPUT_SHAPING=0` or not set (default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.
- `SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [MAX_SMOOTHING=<max_smoothing>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command.

### Palette 2 命令

当[palette2 配置分段](Config_Reference.md#palette2)被启用时，以下命令可用：

- `PALETTE_CONNECT`：该命令初始化与Palette 2的连接。
- `PALETTE_DISCONNECT`：该命令断开与Palette 2的连接。
- `PALETTE_CLEAR`:该命令指示 Palette 2 清除所有耗材的输入或者输出。
- `PALETTE_CUT`:该命令指引Palette 2切割耗材并且装载分段的耗材。
- `PALETTE_SMART_LOAD`：该命令在Palette 2上启动智能加载序列。通过在设备上为打印机校准的距离挤压，自动加载耗材，并在加载完成后指示Palette 2。该命令与耗材加载完成后直接在Palette 2屏幕上按**Smart Load**相同。

Palette打印通过在GCode文件中嵌入特殊的OCodes（Omega Codes）来工作。

- `O1`...`O32`：这些代码从G-Code流中读出并且传递给Palette 2设备进行处理。
