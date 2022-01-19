# 状态参考

本文档是可用于 Klipper [宏](Command_Templates.md)、[显示字段](Config_Reference.md#display)以及[API服务器](API_Server.md) 的打印机状态信息的参考。

本文档中的字段可能会发生变化 - 如果使用了任何字段，在更新 Klipper 时，请务必查看[配置变化文档](Config_Changes.md)。

## bed_mesh

[bed_mesh](Config_Reference.md#bed_mesh) 对象中提供了以下信息：

- `profile_name`、`mesh_min`、`mesh_max`、`probed_matrix`、`mesh_matrix`：关于当前活跃的 bed_mesh 配置信息。

## configfile

`configfile` 对象中提供了以下信息（该对象始终可用）：

- `settings.<分段>.<选项>`：返回最后一次软件启动或重启时给定的配置文件设置（或默认值）。(不会反映运行时的修改。）
- `config.<分段>.<选项>`：返回Klipper在上次软件启动或重启时读取的原始配置文件设置。(不会反映运行时的修改。)所有值都以字符串形式返回。
- `save_config_pending`：如果存在可以通过 `SAVE_CONFIG` 命令保存到配置文件的更新，则返回 True。
- `warnings`：有关配置选项的警告列表。列表中的每个条目都将是一个 dictionary，其中包含 ` type` 和 `message` 字段（都是字符串）。根据警告类型，可能还有其他可用字段。

## display_status

`display_status` 对象中提供以下信息（如果定义了 [display](Config_Reference.md#display) 配置分段，则该对象自动可用）：

- `progress`：最后一个 `M73` G代码命令报告的进度（如果没有收到`M73`，则会用`virtual_sdcard.progress`替代）。
- `message`：最后一条 `M117` G代码命令中包含的消息。

## endstop_phase

[endstop_phase](Config_Reference.md#endstop_phase) 对象中提供了以下信息：

- `last_home.<步进电机名>.phase`：最后一次归为尝试结束时步进电机的相位。
- `last_home.<步进电机名称>.phase`：步进电机上可用的总相数。
- `last_home.<步进电机名称>.mcu_position`：步进电机在上次归位尝试结束时的位置（由微控制器跟踪）。该位置是自微控制器最后一次重启以来，向前走的总步数减去反向走的总步数。

## fan

[fan](Config_Reference.md#fan)、[heater_fan some_name](Config_Reference.md#heater_fan)和[controller_fan some_name](Config_Reference.md#controller_fan)对象提供了以下信息：

- `speed`：风扇速度，0.0和1.0之间的浮点数。
- `rpm`：如果风扇有一个 tachometer_pin，则测量的风扇速度，单位是每分钟转数。

## filament_switch_sensor

[filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor) 对象提供了以下信息：

- `enabled`：如果开关传感器当前已启用，则返回True。
- `filament_detected`：如果传感器处于触发状态，则返回 True。

## filament_motion_sensor

[filament_motion_sensor 传感器名](Config_Reference.md#filament_motion_sensor) 对象提供了以下信息：

- `enabled`：如果当前启用了运动传感器，则返回 True。
- `filament_detected`：如果传感器处于触发状态，则返回 True。

## firmware_retraction

[firmware_retraction](Config_Reference.md#firmware_retraction) 对象提供了以下信息：

- `retract_length`、`retract_speed`、`unretract_extra_length`、`unretract_speed`：firmware_retraction 模块的当前设置。如果 `SET_RETRACTION` 命令改变它们，这些设置可能与配置文件不同。

## gcode_macro

[gcode_macro <名称> 对象提供了以下信息：

- `<变量名>`：[gcode_macro 变量](Command_Templates.md#variables) 的当前值。

## gcode_move

`gcode_move` 对象中提供了以下信息（该对象始终可用）：

- `gcode_position`：工具头相对于当前 G 代码原点的当前位置。也就是可以直接被发送到`G1`命令的位置。可以分别访问这个位置的x、y、z和e分量（例如，`gcode_position.x`）。
- `position`：打印头在配置文件中定义的坐标系中的最后指令位置。可以访问这个位置的x、y、z和e分量（例如，`position.x`）。
- `homing_origin`：在`G28`命令之后要使用的 G-Code 坐标系的原点（相对于配置文件中定义的坐标系）。`SET_GCODE_OFFSET` 命令可以改变这个位置。可以分别访问这个位置的x、y和z分量（例如，`homing_origin.x`）。
- `speed`：在`G1`命令中最后一次设定的速度（单位：mm/s）。
- `speed_factor`：通过 `M220` 命令设置的"速度因子覆盖"。这是一个浮点值，1.0 意味着没有覆盖，例如，2.0 将请求的速度翻倍。
- `extrude_factor`：由`M221`命令设置的"挤出倍率覆盖" 。这是一个浮点值，1.0意味着没有覆盖，例如，2.0将使要求的挤出量翻倍。
- `absolute_coordinates`：如果在 `G90` 绝对坐标模式下，则返回 True；如果在 `G91` 相对模式下，则返回 False。
- `absolute_extrude`：如果在`M82`绝对挤出模式，则返回True；如果在`M83`相对模式，则返回False。

## hall_filament_width_sensor

[hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor) 对象提供了以下信息：

- `is_active`：如果传感器当前处于活动状态，返回True。
- `Diameter`: The last reading from the sensor in mm.
- `Raw`: The last raw ADC reading from the sensor.

## heater

加热器对象，如[extruder](Config_Reference.md#extruder)、[heater_bed](Config_Reference.md#heater_bed)和[heater_generic](Config_Reference.md#heater_generic)，提供了以下信息：

- `temperature`：给定加热器最后报告的温度（以摄氏度为单位的浮点数）。
- `target`：给定加热器的当前目标温度（以摄氏度为单位的浮点数）。
- `power`：与加热器相关的 PWM 引脚的最后设置（0.0和1.0之间的数值）。
- `can_extrude`：挤出机是否可以挤出（由`min_extrude_temp`定义），仅可用于[extruder](Config_Reference.md#extruder)

## heaters

`heaters` 对象中提供以下信息（如果定义了任何加热器，则该对象可用）：

- `available_heaters`：返回所有当前可用加热器的完整配置分段名称，例如 `["extruder"、"heater_bed"、"heater_generic my_custom_heater"]`。
- `available_sensors`：返回所有当前可用的温度传感器的完整配置分段名称列表，例如：`["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"] `。

## idle_timeout

[idle_timeout](Config_Reference.md#idle_timeout) 对象中提供了以下信息（该对象始终可用）：

- `state`：由 idle_timeout 模块跟踪的打印机的当前状态。它可以是以下字符串之一："Idle", "Printing", "Ready"。
- `printing_time`：打印机处于“Printing”状态的时间（以秒为单位）（由 idle_timeout 模块跟踪）。

## mcu

[mcu](Config_Reference.md#mcu)和[mcu some_name](Config_Reference.md#mcu-my_extra_mcu)对象提供了以下信息：

- `mcu_version`：由微控制器报告的 Klipper 代码版本。
- `mcu_build_versions`：有关用于生成微控制器代码的构建工具的信息（由微控制器报告）。
- `mcu_constants.<常量名>`：由微控制器报告编译时使用的常量。可用的常量在不同的微控制器架构和每个代码修订版中可能有所不同。
- `last_stats.<统计信息名>`：关于微控制器连接的统计信息。

## motion_report

`motion_report` 对象提供了以下信息（如果定义了任何步进器配置分段，则该对象自动可用）：

- `live_position`：请求的打印头位置插值到当前时间后的位置。
- `live_velocity`：当前请求的打印头速度（以毫米/秒为单位）。
- `live_extruder_velocity`：当前请求的挤出机速度（单位：mm/s）。

## output_pin

[output_pin <配置名称> 对象提供以下信息：

- `value`：由`SET_PIN`指令设置的引脚“值”。

## palette2

[palette2](Config_Reference.md#palette2) 对象提供了以下信息：

- `ping`。最后一次报告的Palette 2 ping值（百分比）。
- `remaining_load_length`：当开始一个使用 Palette 2 的打印时，这是需要加载到挤出机中的耗材长度。
- `is_splicing`：当Palette 2正在拼接耗材时为 True。

## pause_resume

[palette2](Config_Reference.md#palette2) 对象提供了以下信息：

- `is_paused`：如果执行了 PAUSE 命令而没有执行 RESUME，则返回 True。

## print_stats

`print_stats` 对象提供了以下信息（如果定义了 [virtual_sdcard](Config_Reference.md#virtual_sdcard) 配置分段，则此对象自动可用）：

- `filename`、`total_duration`、`print_duration`、`filament_used`、`state`、`message`：virtual_sdcard 打印处于活动状态时有关当前打印的估测。

## probe

[probe](Config_Reference.md#probe) 对象中提供了以下信息（如果定义了 [bltouch](Config_Reference.md#bltouch) 配置分段，则此对象也可用）：

- `last_query`：如果探针在上一个 QUERY_PROBE 命令期间报告为"已触发"，则返回 True。请注意，如果在宏中使用它，根据模板展开的顺序，必须在包含此引用的宏之前运行 QUERY_PROBE 命令。
- `last_z_result`：返回上一次 PROBE 命令的结果 Z 值。请注意，由于模板展开的顺序，在宏中使用时必须在包含此引用的宏之前运行 PROBE（或类似）命令。

## quad_gantry_level

`quad_gantry_level` 对象提供了以下信息（如果定义了 quad_gantry_level，则该对象可用）：

- `applied`：如果龙门调平已运行并成功完成，则为 True。

## query_endstops

`query_endstops` 对象提供以下信息（如果定义了任何限位，则该对象可用）：

- `last_query["<限位>"]`：如果在最后一次 QUERY_ENDSTOP 命令中，给定的 endstop 处于“触发”状态，则返回 True。注意，如果在宏中使用，由于模板扩展的顺序，QUERY_ENDSTOP 命令必须在包含这个引用的宏之前运行。

## servo

[servo some_name](Config_Reference.md#servo) 对象提供了以下信息：

- `printer["servo <配置名>"].value`：与指定伺服相关 PWM 引脚的上一次设置的值（0.0 和 1.0 之间的值）。

## system_stats

`system_stats` 对象提供了以下信息（该对象始终可用）：

- `sysload`、`cputime`、`memavail`：关于主机操作系统和进程负载的信息。

## 温度传感器

以下信息可在

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor)、[htu21d config_section_name](Config_Reference.md#htu21d-sensor)、[lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor)和[temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) 对象：

- `temperature`：上一次从传感器读取的温度。
- `hemidity`、`pressure`和`gas`：传感器上一次读取的值（仅在bme280、htu21d和lm75传感器上）。

## temperature_fan

[temperature_fan some_name](Config_Reference.md#temperature_fan) 对象提供了以下信息：

- `temperature`：上一次从传感器读取的温度。
- `target`：风扇目标温度。

## temperature_sensor

[temperature_sensor some_name](Config_Reference.md#temperature_sensor) 对象提供了以下信息：

- `temperature`：上一次从传感器读取的温度。
- `measured_min_temp`和`measured_max_temp`：自Klipper主机软件上次重新启动以来，传感器测量的最低和最高温度。

## tmc 驱动

[TMC 步进驱动](Config_Reference.md#tmc-stepper-driver-configuration)对象（例如，`[tmc2208 stepper_x]`）提供了以下信息：

- `mcu_phase_offset`：微控制器步进位置与驱动器的"零"相位的相对位置。如果相位偏移未知，则此字段可能为空。
- `phase_offset_position`：对应电机“零”相位的“指令位置”。如果相位偏移未知，则该字段可以为空。
- `drv_status`：上次驱动状态查询结果。（仅报告非零字段。如果驱动没有被启用（因此没有轮询），则此字段将为 null。
- `run_current`：当前设置的运行电流。
- `hold_current`：当前设置的保持电流。

## toolhead

`toolhead` 对象提供了以下信息（该对象始终可用）：

- `position`：打印头相对于配置文件中指定的坐标系的最后命令位置。可以访问该位置的 x、y、z 和 e 分量（例如，`position.x`）。
- `extruder`：当前活跃的挤出机的名称。例如，在宏中可以使用`printer[printer.toolhead.extruder].target`来获取当前挤出机的目标温度。
- `homed_axes`：当前被认为处于“已归位”状态的车轴。这是一个包含一个或多个"x"、"y"、"z"的字符串。
- `axis_minimum`、`axis_maximum`：归位后的轴的行程限制（毫米）。可以访问此极限值的 x、y、z 分量（例如，`axis_minimum.x`、`axis_maximum.z`）。
- `max_velocity`、`max_accel`、`max_accel_to_decel`和`square_corner_velocity`：当前生效的打印机限制。如果 `SET_VELOCITY_LIMIT`（或 `M204`）命令在运行时改变它们，这些值可能与配置文件设置不同。
- `stalls`：由于工具头移动速度快于从 G 代码输入读取的移动速度，因此打印机必须暂停的总次数（自上次重新启动以来）。

## dual_carriage

使用了 hybrid_corexy 或 hybrid_corexz 运动学的 [dual_carriage](Config_Reference.md#dual_carriage) 对象提供了以下信息

- `mode`：当前模式。可能的值："FULL_CONTROL"
- `active_carriage`：当前的活跃的滑车。可能的值是"CARRIAGE_0"和"CARRIAGE_1"

## virtual_sdcard

[virtual_sdcard](Config_Reference.md#virtual_sdcard)对象提供了以下信息：

- `is_active`：如果正在从文件进行打印，则返回 True。
- `progress`：对当前打印进度的估计（基于文件大小和文件位置）。
- `file_path`：当前加载的文件的完整路径。
- `file_position`：当前打印的位置（以字节为单位）。
- `file_size`：当前加载的文件的大小（以字节为单位）。

## webhooks

`system_stats` 对象提供了以下信息（该对象始终可用）：

- `state`：返回一个表示当前 Klipper 状态的字符串。可能的值为："ready"、"startup"、"shutdown"和"error"。
- `state_message`：提供了一个包含当前 Klipper 状态和上下文的可读字符串。

## z_tilt

`z_tilt` 对象提供了以下信息（如果定义了 z_tilt，则该对象可用）：

- `applied`：如果 z 倾斜调平过程已运行并成功完成，则为 True。

## neopixel / dotstar

以下信息适用于每个在 printer.cfg 中定义的 `[neopixel led_name]` 和 `[dotstar led_name]`：

- `color_data`：对象数组，每个对象包含链中一个 LED 的 RGBW 值。请注意，并非所有配置都包含白色值。每个值都是从 0 到 1 的浮点数。例如，链中第二个 neopixel 的蓝色值可以通过`printer["neopixel <config_name>"].color_data[1].B`访问。
