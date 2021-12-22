# G-Codes

本文档描述了 Klipper 支持的命令。这些命令可以输入到 OctoPrint 终端中。

## G代码命令

Klipper支持以下标准的G-Code命令：

- 移动 (G0 or G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- 停留时间：`G4 P<milliseconds>`
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
- 卸载文件并清除SD卡状态：`SDCARD_RESET_FILE`

### G-Code弧

如果启用了[gcode_arcs 配置分段](Config_Reference.md#gcode_arcs)，下列标准G代码命令可用：

- 受控弧线移动（G2或G3）。`G2 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>` 。

### G-Code固件回抽

如果启用了[firmware_retraction 配置分段](Config_Reference.md#firmware_retraction)，则以下标准G代码命令可用：

- 回抽：`G10`
- 回填：`G11`

### G-Code 显示命令

如果启用了[display 配置分段](Config_Reference.md#display)，以下标准G代码命令可用：

- 显示信息： `M117 <message> `
- 设置构建百分比：`M73 P<percent>`

### 其他可用的G-Code命令

目前以下标准的G代码命令可用，但不建议使用这些命令：

- 获取限位状态：`M119` (使用QUERY_ENDSTOPS代替)

## 扩展的G-Code 命令

Klipper使用 "extended" 的G代码命令来进行一般的配置和状态。这些扩展命令都遵循一个类似的格式--它们以一个命令名开始，后面可能有一个或多个参数。比如说：`SET_SERVO SERVO=myservo ANGLE=5.3`。在本文件中，命令和参数以大写字母显示，但它们不分大小写。(所以，"SET_SERVO "和 "set_servo "都是运行同一个命令）

支持以下标准命令：

- `QUERY_ENDSTOPS`：检测限位并返回限位是否被 "triggered"或处于"open"。该命令通常用于验证一个限位是否正常工作。
- `QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]` ：返回为配置的模拟引脚收到的最后一个模拟值。如果NAME没有被提供，将报告可用的adc名称列表。如果提供了PULLUP（以欧姆为单位的数值），将会返回原始模拟值和给定的等效电阻。
- `GET_POSITION`：返回工具当前位置信息
- `SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]` 。设置一个位置偏移，以应用于未来的G代码命令。这通常用于实际改变Z床的偏移量或在切换挤出机时设置喷嘴的XY偏移量。例如，如果发送 "SET_GCODE_OFFSET Z=0.2"，那么未来的G代码移动将在其Z高度上增加0.2mm。如果使用X_ADJUST风格的参数，那么调整将被添加到任何现有的偏移上（例如，"SET_GCODE_OFFSET Z=-0.2"，然后是 "SET_GCODE_OFFSET Z_ADJUST=0.3"，将导致总的Z偏移为0.1）。如果指定了 "MOVE=1"，那么将发出一个工具头移动来应用给定的偏移量（否则偏移量将在指定给定轴的下一次绝对G-Code移动中生效）。如果指定了 "MOVE_SPEED"，那么刀头移动将以给定的速度（mm/s）执行；否则，打印头移动将使用最后指定的G-Code速度。
- `SAVE_GCODE_STATE [NAME=<state_name>]`：保存当前的g-code坐标解析状态。保存和恢复g-code状态在脚本和宏中很有用。该命令保存当前g-code绝对坐标模式（G90/G91）绝对挤出模式（M82/M83）原点（G92）偏移量（SET_GCODE_OFFSET）速度覆盖（M220）挤出机覆盖（M221）移动速度。当前XYZ位置和相对挤出机 "E "位置。如果提供NAME，它允许人们将保存的状态命名为给定的字符串。如果没有提供NAME，则默认为 "default"
- `RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`：恢复之前通过 SAVE_GCODE_STATE 保存的状态。如果指定“MOVE=1”，则将发出刀头移动以返回到先前的 XYZ 位置。如果指定了“MOVE_SPEED”，则刀头移动将以给定的速度（以mm/s为单位）执行；否则工具头移动将使用恢复的G-Code速度。
- `PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`：执行一个PID校准测试。指定的加热器将被启用，直到达到指定的目标温度，然后加热器将被关闭和开启几个周期。如果WRITE_FILE参数被启用，那么将创建文件/tmp/heattest.txt，其中包含测试期间所有温度样本的日志。
- `TURN_OFF_HEATERS`：关闭全部加热器。
- `TEMPERATURE_WAIT SENSOR=<配置名> [MINIMUM=<目标>] [MAXIMUM=<目标>]`：等待指定温度传感器读数高于 MINIMUM 和或低于 MAXIMUM。
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
   - `TESTZ Z=<值>`：这个命令可以将喷嘴上升或下降给定值，以毫米为单位。例如，`TESTZ Z=-.1` 会将喷嘴下降 0.1 毫米，而 `TESTZ Z=.1` 会将喷嘴上升 0.1 毫米，参数可以带有`+`, `-`, `++`, or `--`来根据上次尝试相对的移动喷嘴。
- `Z_ENDSTOP_CALIBRATE [SPEED=<速度>]`：运行一个校准 Z position_endstop 参数的辅助脚本。有关更多参数和额外命令的信息，请查看 MANUAL_PROBE 命令。
- `Z_OFFSET_APPLY_ENDSTOP`：将当前的Z 的 G 代码偏移量（就是 babystepping）从 stepper_z 的 endstop_position 中减去。该命令将持久化一个常用babystepping 微调值。需要执行 `SAVE_CONFIG`才能生效。
- `TUNING_TOWER COMMAND=<命令> PARAMETER=<名称> START=<值> [SKIP=<值>] [FACTOR=<值> [BAND=<值>]] | [STEP_DELTA=<值> STEP_HEIGHT=<值>]`：根据Z高度调整参数的工具。该工具将定期运行一个 `PARAMETER` 不断根据 `Z` 的公式变化的 `COMMAND`（命令）。如果使用一把尺子或者游标卡尺测量 Z来获得最佳值，你可以用`FACTOR`。如果打印件带有带状标识或者使用离散数值（例如温度塔），可以用`STEP_DELTA`和 `STEP_HEIGHT` 。如果 `SKIP=<值>` 被定义，则调整只会在到达 Z 高度 `<值>` 后才开始。在此之前，参数会被设定为 `START`；在这种情况下，下面公式中`z_height`用`max(z - skip, 0)`替代。这些选项有三种不同的组合：
   - `FACTOR`：值以每毫米`factor` 的速度变化。使用的公式是`value = start + factor * z_height`。你可以把最佳的Z高度直接插入公式中，以确定最佳的参数值。
   - `FACTOR`和`BAND`：值以每毫米`factor`的平均速度变化，但在离散的带子中，每隔`BAND`毫米的Z高度才会进行调整。使用的公式是 `value = start + factor * ((floor(z_height / band) + .5) * band)`。
   - `STEP_DELTA` 和 `STEP_HEIGHT`：每 `STEP_HEIGHT` 毫米后由`STEP_DELTA` 改变的值。公式是 `value = start + step_delta * floor(z_height / step_height)`。你可以通过数打印件上的圈或者读上面的标记来确定最佳值。
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

- `SET_LED LED=<配置中的名称> RED=<值> GREEN=<值> BLUE=<值> WHITE=<值> [INDEX=<索引>] [TRANSMIT=0] [SYNC=1]`：这条指令设置LED的输出。每个颜色的 `<值>` 必须在0.0和1.0之间。WHITE（白色）参数仅在 RGBW LED上有效果。如果多个 LED 芯片是通过菊链连接的，可以用INDEX参数来指定改变指定芯片的颜色（1是第一颗芯片，2是第二颗芯片…）。如果不提供 INDEX 则全部菊链中的 LED 将被设置为给定的颜色。如果指定了 TRANSMIT=0 ，色彩变化只会在下一条不是 TRANSMIT=0 的 SET_LED命令发送后发生。这个特性和 INDEX 参数一起使用可以在菊链中批量改变LED的颜色。默认情况下，SET_LED命令将与其他正在进行的G代码命令同步其变化。 因为修改LED状态会重置空闲超时，这可能在不打印时造成不期望的行为。 如果精确的时序不重要，可选的 SYNC=0 参数可以立刻应用LED变化而不重置LED超时。

### 舵机命令

当[servo 配置分段](Config_Reference.md#servo)被启用时，以下命令可用：

- `SET_SERVO SERVO=配置名 [ANGLE=<角度> | WIDTH=<秒>]`：将舵机位置设置为给定的角度（度）或脉冲宽度（秒）。使用 `WIDTH=0` 来禁用舵机输出。

### 手动步进电机命令

当[manual_stepper 配置分段](Config_Reference.md#manual_stepper)被启用时，以下命令可用：

- `MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]]`：该命令将改变步进器的状态。使用ENABLE参数来启用/禁用步进。使用SET_POSITION参数，迫使步进认为它处于给定的位置。使用MOVE参数，要求移动到给定位置。如果指定了SPEED或者ACCEL，那么将使用给定的值而不是配置文件中指定的默认值。如果指定ACCEL为0，那么将不执行加速。如果STOP_ON_ENDSTOP=1被指定，那么如果止动器报告被触发，动作将提前结束（使用STOP_ON_ENDSTOP=2来完成动作，即使止动器没有被触发也不会出错，使用-1或-2来在止动器报告没有被触发时停止）。通常情况下，未来的G-Code命令将被安排在步进运动完成后运行，但是如果手动步进运动使用SYNC=0，那么未来的G-Code运动命令可能与步进运动平行运行。

### 挤出机步进电机命令

当[extruder_stepper 配置分段](Config_Reference.md#extruder_stepper)被启用时，以下命令可用：

- `SYNC_STEPPER_TO_EXTRUDER STEPPER=<挤出步进电机配置名> [EXTRUDER=<挤出机配置名>]`：这个命令会使给定步进电机与给定挤出机同步，覆盖 "extruder_stepper" 配置分段定义的挤出机。

### 探针

当[probe 配置分段](Config_Reference.md#probe)被启用时，以下命令可用（也请参见[探针校准指南](Probe_Calibrate.md)）：

- `PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`：向下移动喷嘴直到探针触发。如果提供了任何可选参数，它们将覆盖 [probe config section](Config_Reference.md#probe) 中的等效设置。
- `QUERY_PROBE`:报告探针的当前状态（"triggered"或 "open"）。
- `PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`：计算多个探针样本的最大、最小、平均、中位数和标准偏差。默认情况下采样10次。否则可选参数默认为探针配置部分的同等设置。
- `PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>] `:运行一个对校准测头的z_offset有用的辅助脚本。有关可选测头参数的详细信息，请参见PROBE命令。参见MANUAL_PROBE命令，了解SPEED参数和工具激活时可用的附加命令的详细信息。请注意，PROBE_CALIBRATE命令使用速度变量在XY方向以及Z方向上移动。
- `Z_OFFSET_APPLY_PROBE`：将当前的Z 的 G 代码偏移量（就是 babystepping）从 probe 的 z_offset 中减去。该命令将持久化一个常用babystepping 微调值。需要执行 `SAVE_CONFIG`才能生效。

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

当[screws_tilt_adjust配置分段](Config_Reference.md#screws_tilt_adjust)被启用时，以下命令可用（也可参考[手动水平指南](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)）：

- `SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [<probe_parameter>=<value>]`：该命令将调用热床丝杆调整工具。它将命令喷嘴到不同的位置（如配置文件中定义的）探测z高度，并计算出调整床面水平的旋钮旋转次数。如果指定了DIRECTION，旋钮的转动方向都是一样的，顺时针（CW）或逆时针（CCW）。有关可选探头参数的详细信息，请参见PROBE命令。重要的是：在使用这个命令之前，你必须先做一个G28。

### Z 倾斜

当[z_tilt 配置分段](Config_Reference.md#z_tilt)被启用时，以下命令可用：

- `Z_TILT_ADJUST [<probe_参数>=<值>]`：该命令将探测配置中指定的坐标并对每个Z步进电机进行独立的调整以抵消倾斜。有关可选的探针参数，详见 PROBE 命令。

### 双滑车

当[dual_carriage 配置分段](Config_Reference.md#dual_carriage)被启用时，以下命令可用：

- `SET_DUAL_CARRIAGE CARRIAGE=[0|1]`:该命令将设置活动的滑块。它通常是在一个多挤出机配置中从 activate_gcode和deactivate_gcode字段调用。

### TMC步进驱动

当启用了任何 [tmcXXXX 配置分段](Config_Reference.md#tmc-stepper-driver-configuration)时，以下命令可用：

- `DUMP_TMC STEPPER=<name>`。该命令将读取TMC驱动寄存器并报告其值。
- `INIT_TMC STEPPER=<name>`：该命令将初始化TMC寄存器。如果芯片的电源被关闭然后又被打开，需要重新启用驱动程序。
- `SET_TMC_CURRENT STEPPER=<名称> CURRENT=<安培> HOLDCURRENT=<安培>`：该命令修改TMC驱动的运行和保持电流（HOLDCURRENT 在 tmc2660 驱动上不起效）。
- `SET_TMC_FIELD STEPPER=<名称> FIELD=<字段> VALUE=<值>`：这将修改指定 TMC 步进驱动寄存器字段的值。该命令仅适用于低级别的诊断和调试，因为在运行期间改变字段可能会导致打印机出现不符合预期的、有潜在危险的行为。常规修改应当通过打印机配置文件进行。该命令不会对给定的值进行越界检查。

### 通过步进相位进行限位调整

当[endstop_phase配置分段](Config_Reference.md#endstop_phase)被启用时，以下命令可用（也可参见[限位相位指南](Endstop_Phase.md)）：

- `ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]` 。如果没有提供STEPPER参数，那么该命令将报告在过去的归位操作中对端停步进相的统计。当提供STEPPER参数时，它会安排将给定的终点站相位设置写入配置文件中（与SAVE_CONFIG命令一起使用）。

### Force movement

当 [force_move 配置分段](Config_Reference.md#force_move)被启用时，以下命令可用：

- `FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]` 。该命令将以给定的恒定速度（mm/s）强制移动给定的步进器，移动距离（mm）。如果指定了ACCEL并且大于零，那么将使用给定的加速度（单位：mm/s^2）；否则不进行加速。不执行边界检查；不进行运动学更新；一个轴上的其他平行步进器将不会被移动。请谨慎使用，因为不正确的命令可能会导致损坏使用该命令几乎肯定会使低级运动学处于不正确的状态；随后发出G28命令以重置运动学。该命令用于低级别的诊断和调试。
- `SET_KINEMATIC_POSITION [X=<值>] [Y=<值>] [Z=<值>]`：强制设定低级运动学代码使用的打印头位置。这是一个诊断和调试工具，常规的轴转换应该使用 SET_GCODE_OFFSET 和/或 G92指令。如果没有指定一个轴，则使用上一次命令的打印头位置。设定一个不合理的数值可能会导致内部程序问题。这个命令可能会使边界检查失效，使用后发送 G28 来重置运动学。

### SD卡循环

当[sdcard_loop 配置分段](Config_Reference.md#sdcard_loop)被启用时，以下扩展命令可用：

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

当[pause_resume 配置分段](Config_Reference.md#pause_resume)被启用时，以下命令可用：

- `PAUSE`：暂停当前的打印。当前的位置被报错以便在恢复时恢复。
- `RESUME [VELOCITY=<value>]`：从暂停中恢复打印，首先恢复以前保持的位置。VELOCITY参数决定了工具返回到原始捕捉位置的速度。
- `CLEAR_PAUSE`:清除当前的暂停状态而不恢复打印。如果一个人决定在暂停后取消打印，这很有用。建议将其添加到你的启动代码中，以确保每次打印时的暂停状态是新的。
- `CANCEL_PRINT`：取消当前的打印。

### 耗材传感器

当[filament_switch_sensor 或 filament_motion_sensor 配置分段](Config_Reference.md#filament_switch_sensor)被启用时，以下命令可用：

- `QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`。查询耗材传感器的当前状态。终端上显示的数据将取决于配置中定义的传感器类型。
- `SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]` ：设置灯丝传感器的开/关。如果 ENABLE 设置为 0，耗材传感器将被禁用，如果设置为 1是启用。

### 固件回抽

当[firmware_retraction 配置分段](Config_Reference.md#firmware_retraction) 被启用时以下命令可用。这些命令兼容大多数切片软件的固件回抽功能，可以减少在非挤出移动中的拉丝现象。正确配置的压力提前参数可以减少所需的回抽长度。

- `SET_RETRACTION [RETRACT_LENGTH=<毫米>] [RETRACT_SPEED=<毫米每秒>] [UNRETRACT_EXTRA_LENGTH=<毫米>] [UNRETRACT_SPEED=<毫米每秒>]`：调整固件回抽所使用的参数。RETRACT_LENGTH 决定回抽和回填的耗材长度。回抽的速度通过 RETRACT_SPEED 调整，通常设置得比较高。回填的速度通过 UNRETRACT_SPEED 调整，虽然经常比RETRACT_SPEED 低，但不是特别重要。在某些情况下，在回填时增加少量的额外长度的耗材可能有益，这可以通过 UNRETRACT_EXTRA_LENGTH 设置。SET_RETRACTION 通常作为切片机耗材配置的一部分来设置，因为不同的耗材需要不同的参数设置。
- `GET_RETRACTION`:查询当前固件回抽所使用的参数并在终端显示。
- `G10`：使用当前配置的参数回抽挤出机。
- `G11`：不使用当前配置的参数回抽挤出机。

### 偏斜校正

当[skew_correction 配置分段](Config_Reference.md#skew_correction)被启用时，以下命令可用（也请参见[Skew Correction](Skew_Correction.md)指南）：

- `SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`：用从校准打印中测量的数据（以毫米为单位）配置 [skew_correction] 模块。可以输入任何组合的平面，没有新输入的平面将保持它们原有的数值。如果传入 `CLEAR=1`，则全部偏斜校正将被禁用。
- `GET_CURRENT_SKEW`:以弧度和度数报告每个平面的当前打印机偏移。斜度是根据通过`SET_SKEW`代码提供的参数计算的。
- `CALC_MEASURED_SKEW [AC=<ac 长度>] [BD=<bd 长度>] [AD=<ad 长度>]`：计算并报告基于一个打印件测量的偏斜度（以弧度和角度为单位）。它可以用来验证应用校正后打印机的当前偏斜度。它也可以用来确定是否有必要进行偏斜矫正。有关偏斜矫正打印模型和测量方法详见[偏斜校正文档](Skew_Correction.md)。
- `SKEW_PROFILE [LOAD=<名称>] [SAVE=<名称>] [REMOVE=<名称>] `：管理歪斜校正配置。LOAD 将从与指定名称相匹配的配置中恢复偏斜状态。SAVE 将把当前的偏斜状态保存到与指定名称相匹配的配置文件中。REMOVE（删除）将从持久性内存中删除与指定名称相匹配的配置。请注意，在 SAVE 或 REMOVE 操作运行后，必须运行 SAVE_CONFIG G代码以使持久性存储器的变化永久化。

### 延迟 GCode

如果启用了[delayed_gcode 配置分段](Config_Reference.md#delayed_gcode)，则可用以下命令（也可参见[template guide](Command_Templates.md#delayed-gcodes)）：

- `UPDATE_DELAYED_GCODE [ID=<名称>] [DURATION=<秒>]`：更新目标 [delayed_gcode] 的延迟并启动G代码执行的计时器。为0的值会取消准备执行的延迟G代码。

### 保存变量

如果[save_variables 配置分段](Config_Reference.md#save_variables)已被启用，则以下命令可用：

- `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`：将变量保存到磁盘，以便在重新启动时使用。所有存储的变量都会在启动时加载到 `printer.save_variables.variables` 目录中，并可以在 gcode 宏中使用。所提供的 VALUE 会被解析为一个 Python 字面。

### 共振补偿

如果[input_shaper 配置分段](Config_Reference.md#input_shaper)被启用，以下命令可用（另请参阅[共振补偿指南](Resonance_Compensation.md)）：

- `SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`：修改输入整形参数。注意 SHAPER_TYPE 参数会同时覆写 X 和 Y 轴的整形器类型，即使它们在 [input_shaper] 配置分段中有不同的整形器类型。SHAPER_TYPE 不能和 SHAPER_TYPE_X 和 SHAPER_TYPE_Y 参数同时使用。这些参数的细节请见[配置参考](Config_Reference.md#input_shaper)。

### 温控风扇命令

当[temperature_fan 配置分段](Config_Reference.md#temperature_fan)被启用时，以下命令可用。

- `SET_TEMPERATURE_FAN_TARGET temperature_fan=<温度控制风扇名称> [target=<目标温度>] [min_speed=<最小速度>]  [max_speed=<最大速度>]`：设置一个temperature_fan的目标温度。如果没有定义目标温度，配置文件中定义的温度将被使用。如果速度没有定义，不会应用任何变化。

### Adxl345 加速度传感器命令

当[adxl345配置分段](Config_Reference.md#adxl345)被启用时，以下命令可用：

- `ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]` 。以要求的每秒采样数启动加速度计测量。如果没有指定CHIP，则默认为 "adxl345"。该命令以启动-停止模式工作：第一次执行时，它开始测量，下次执行时停止测量。测量结果被写入一个名为`/tmp/adxl345-<chip>-<name>的文件中。csv`，其中`<chip>`是加速度计芯片的名称（`my_chip_name`来自`[adxl345 my_chip_name]`），`<name>`是可选NAME参数。如果没有指定NAME，则默认为当前时间，格式为 "YYYMMDD_HHMMSS"。如果加速度计在其配置部分没有名称（只是`[adxl345]`），那么`<chip >`部分的名称就不会生成。
- `ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: 查询加速度计的当前值。如果没有指定芯片，则默认为 "adxl345"。如果没有指定RATE，则使用默认值。该命令对于测试与ADXL345加速度计的连接非常有用：返回的数值之一应该是自由落体加速度（+/-芯片的一些噪声）。
- `ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`：查询ADXL345的 <register> 寄存器（例如44或0x2C）。对于调试来说是很有用的。
- `ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<reg> VAL=<value>`：将原始<value>写入寄存器<register>中。<value>和<register>都可以是一个十进制或十六进制的整数。使用时要注意，参考ADXL345数据表。

### 共振测试命令

当[resonance_tester 配置分段](Config_Reference.md#resonance_tester)被启用时，以下命令可用（也可参见[Measurement resonances guide](Measurement_Resonances.md)）：

- `MEASURE_AXES_NOISE`：测量并输出所有启用的加速度计芯片的所有轴的噪声。
- `TEST_RESONANCES AXIS=<轴> OUTPUT=<resonances,raw_data> [NAME=<名称>] [FREQ_START=<最小频率>] [FREQ_END=<最大频率>] [HZ_PER_SEC=<hz_per_sec>] [INPUT_SHAPING=[<0:1>]]`：在请求的<轴>全部配置的探测点运行共振测试并使用加速度计测量相应轴的加速度。<轴> 可以是 X 或者 Y，或者一个抽象的方向例如 `AXIS=dx,dy`，dx和dy是定义了方向矢量的浮点数（例如 `AXIS=X`、`AXIS=Y`或`AXIS=1,-1`来定义一个对角的方向）。注意，`AXIS=dx,dy` 和 `AXIS=-dx,-dy` 是等效的。`INPUT_SHAPING=0` 或默认会在共振测试时禁用输入整形，在输入整形启用时的共振测试结果是无效的。`OUTPUT` 参数是一个用来选择输出的逗号分隔列表。 如果请求了`raw_data`，原始加速度计数据将被写到一个或多个路径为`/tmp/raw_data_<轴>_[<坐标>_]<名称>.csv`的文件。（`<坐标>_`部分只会在多个探测点被配置时才会被加入）。如果定义了`resonances`，频响会被计算 （包括全部探测点）并写入到`/tmp/resonances_<轴>_<名称>.csv` 文件中。如果没有定义，则输出默认为`resonances`，而名称将被默认为"YYYYMMDD_HHMMSS"格式。
- `SHAPER_CALIBRATE [AXIS=<轴>] [NAME=<名称>] [FREQ_START=<最小频率>] [FREQ_END=<最大频率>] [HZ_PER_SEC=<hz_per_sec>] [MAX_SMOOTHING=<max_smoothing>]`：类似`TEST_RESONANCES`，该命令按配置运行共振测试并尝试寻找给定轴最佳的输入整形参数。如果没有选择`AXIS`，则测量X和Y轴。如果没有选择 `MAX_SMOOTHING` ，会使用 `[resonance_tester]` 的默认参数。有关该特性的使用方法，详见共振量测量指南中的 [最大平滑](Measuring_Resonances.md#max-smoothing)章节。测试结果会被输出到终端，而频响和不同输入整形器的参数将被写入到一个或多个 CSV 文件中。它们的名称是`/tmp/calibration_data_<轴>_<名称>.csv`。如果没有指定，名称默认为“YYYYMMDD_HHMMSS”格式的当前时间。注意，可以通过请求 `SAVE_CONFIG` 命令将推荐的输入整形器参数直接保存到配置文件中。

### Palette 2 命令

当[palette2 配置分段](Config_Reference.md#palette2)被启用时，以下命令可用：

- `PALETTE_CONNECT`：该命令初始化与Palette 2的连接。
- `PALETTE_DISCONNECT`：该命令断开与Palette 2的连接。
- `PALETTE_CLEAR`:该命令指示 Palette 2 清除所有耗材的输入或者输出。
- `PALETTE_CUT`:该命令指引Palette 2切割耗材并且装载分段的耗材。
- `PALETTE_SMART_LOAD`：该命令在Palette 2上启动智能加载序列。通过在设备上为打印机校准的距离挤压，自动加载耗材，并在加载完成后指示Palette 2。该命令与耗材加载完成后直接在Palette 2屏幕上按**Smart Load**相同。

Palette打印通过在GCode文件中嵌入特殊的OCodes（Omega Codes）来工作。

- `O1`...`O32`：这些代码从G-Code流中读出并且传递给Palette 2设备进行处理。
