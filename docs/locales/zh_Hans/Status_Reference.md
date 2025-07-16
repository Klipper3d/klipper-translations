# 状态参考

本文档是可用于 Klipper [宏](Command_Templates.md)、[显示字段](Config_Reference.md#display)以及[API服务器](API_Server.md) 的打印机状态信息的参考。

本文档中的字段可能会发生变化 - 如果使用了任何字段，在更新 Klipper 时，请务必查看[配置变化文档](Config_Changes.md)。

## angle

[angle some_name](Config_Reference.md#angle) 对象提供了以下信息：

- `temperature`：tle5012b 磁性霍尔传感器的最后一次温度读数（以摄氏度为单位）。该值仅在角度传感器是 tle5012b 芯片并且正在进行测量时可用（否则它会报告 `None`）。

## bed_mesh

[bed_mesh](Config_Reference.md#bed_mesh) 对象中提供了以下信息：

- `profile_name`、`mesh_min`、`mesh_max`、`probed_matrix`、`mesh_matrix`：关于当前活跃的 bed_mesh 配置信息。
- `profiles`：当前定义的配置，使用 BED_MESH_PROFILE 进行设置。

## bed_screws

The following information is available in the [bed_screws](Config_Reference.md#bed_screws) object:

- `is_active`：如果床调平螺丝调整工具当前处于活动状态，则返回 True。
- `state`：床调平螺丝调整工具状态。它可以是以下字符串之一："adjust", "fine"。
- `current_screw`：当前正在被调整的螺丝的索引。
- `accepted_screws`：已被接受的螺丝数量。

## canbus_stats

The following information is available in the `canbus_stats some_mcu_name` object (this object is automatically available if an mcu is configured to use canbus):

- `rx_error`: The number of receive errors detected by the micro-controller canbus hardware.
- `tx_error`: The number of transmit errors detected by the micro-controller canbus hardware.
- `tx_retries`: The number of transmit attempts that were retried due to bus contention or errors.
- `bus_state`: The status of the interface (typically "active" for a bus in normal operation, "warn" for a bus with recent errors, "passive" for a bus that will no longer transmit canbus error frames, or "off" for a bus that will no longer transmit or receive messages).

Note that only the rp2XXX micro-controllers report a non-zero `tx_retries` field and the rp2XXX micro-controllers always report `tx_error` as zero and `bus_state` as "active".

## configfile

`configfile` 对象中提供了以下信息（该对象始终可用）：

- `settings.<分段>.<选项>`：返回最后一次软件启动或重启时给定的配置文件设置（或默认值）。(不会反映运行时的修改。）
- `config.<分段>.<选项>`：返回Klipper在上次软件启动或重启时读取的原始配置文件设置。(不会反映运行时的修改。)所有值都以字符串形式返回。
- `save_config_pending`：如果存在可以通过 `SAVE_CONFIG` 命令保存到配置文件的更新，则返回 True。
- `save_config_pending_items`：包含已更改并可以由 `SAVE_CONFIG ` 保存的分段和选项。
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

## exclude_object

以下信息可在[exclude_object](Exclude_Object.md)对象中找到：

- `objects`：`EXCLUDE_OBJECT_DEFINE` 命令提供的已知对象数组。这与 `EXCLUDE_OBJECT VERBOSE=1` 命令提供的信息相同。 `center` 和 `polygon` 字段只有在原始 `EXCLUDE_OBJECT_DEFINE` 中提供时才会出现

   这里有一个JSON样本：

```
[
  {
    "polygon": [
      [ 156.25, 146.2511675 ],
      [ 156.25, 153.7488325 ],
      [ 163.75, 153.7488325 ],
      [ 163.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_2_COPY_0",
    "center": [ 160, 150 ]
  },
  {
    "polygon": [
      [ 146.25, 146.2511675 ],
      [ 146.25, 153.7488325 ],
      [ 153.75, 153.7488325 ],
      [ 153.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_1_COPY_0",
    "center": [ 150, 150 ]
  }
]
```

- `excluded_objects`：列出已排除对象名称的字符串数组。
- `current_object`：当前正在打印的对象的名称。

## extruder_stepper

以下信息在extruder_stepper对象以及[extruder](Config_Reference.md#extruder)对象中可用：

- `pressure_advance`：当前的[压力提前](Pressure_Advance.md)值。
- `smooth_time`：当前压力提前平滑时间。
- `motion_queue`：当前与该挤出机步进电机同步的挤出机名称。如果该挤出机步进电机目前未与任何挤出机相关联，则报告为`None`。

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

## gcode_button

在[Gcode_Button Some_NAME](Config_Reference.md#gcode_Button)对象中提供了以下信息：

- `state`：当前返回的按钮状态为按下或释放

## gcode_macro

[gcode_macro <名称>](Config_Reference.md#gcode_macro) 对象提供了以下信息：

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

- all items from [filament_switch_sensor](Status_Reference.md#filament_switch_sensor)
- `is_active`：如果传感器当前处于活动状态，返回True。
- `Diameter`：上一次传感器读数，单位为 mm。
- `Raw`：上一次传感器原始 ADC 读数。

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
- `available_monitor ors`：按配置节全名返回当前所有可用的温度监视器的列表，例如`[“tmc2240 Steper_x”]`。虽然温度传感器始终可用于读取，但温度监视器可能不可用，在这种情况下将返回NULL。

## idle_timeout

[idle_timeout](Config_Reference.md#idle_timeout) 对象中提供了以下信息（该对象始终可用）：

- `state`：由 idle_timeout 模块跟踪的打印机的当前状态。它可以是以下字符串之一："Idle", "Printing", "Ready"。
- `printing_time`：打印机处于“Printing”状态的时间（以秒为单位）（由 idle_timeout 模块跟踪）。

## led

以下信息适用于每个在printer.cfg中定义了的 `[led led_name]`、`[neopixel led_name]`、`[dotstar led_name]`、`[pca9533 led_name]` , 和 `[pca9632 led_name]` 配置分段：

- `color_data`：一个包含链中每个LED的RGBW值的颜色列表的列表。每个值都以0.0到1.0的浮点数表示。每个颜色列表包含4个项目（红、绿、蓝、白），即使底层的LED支持较少的颜色通道。例如，可以通过`printer["neopixel <配置名>"].color_data[1][2]`访问链中第二个neopixel的蓝色值（颜色列表中的第三项）。

## load_cell

The following information is available for each `[load_cell name]`:

- 'is_calibrated': True/False is the load cell calibrated
- 'counts_per_gram': The number of raw sensor counts that equals 1 gram of force
- 'reference_tare_counts': The reference number of raw sensor counts for 0 force
- 'tare_counts': The current number of raw sensor counts for 0 force
- 'force_g': The force in grams, averaged over the last polling period.
- 'min_force_g': The minimum force in grams, over the last polling period.
- 'max_force_g': The maximum force in grams, over the last polling period.

## load_cell_probe

The following information is available for `[load_cell_probe]`:

- all items from [load_cell](Status_Reference.md#load_cell)
- all items from [probe](Status_Reference.md#probe)
- 'endstop_tare_counts': the load cell probe keeps a tare value independent of the load cell. This re-set at the start of each probe.
- 'last_trigger_time': timestamp of the last homing trigger

## manual_probe

`manual_probe` 对象中提供了以下信息：

- `is_active`：如果手动探测助手程序脚本当前处于活动状态，则返回 True。
- `z_position` 。喷嘴的当前高度（按照打印机目前的理解）。
- `z_position_lower`：上次探测尝试略低于当前高度。
- `z_position_upper`：上次探测尝试仅大于当前高度。

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

[output_pin <配置名称>](Config_Reference.md#output_pin) 对象提供以下信息：

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
- `info.total_layer`：最后一条`SET_PRINT_STATS_INFO TOTAL_LAYER=<值>` G-Code命令的总层值。
- `info.current_layer`: 上一条 `SET_PRINT_STATS_INFO CURRENT_LAYER=<值>` G代码命令的当前层值。

## probe

[probe](Config_Reference.md#probe) 对象中提供了以下信息（如果定义了 [bltouch](Config_Reference.md#bltouch) 配置分段，则此对象也可用）：

- `name`：返回正在使用的探针的名称。
- `last_query`：如果探针在上一个 QUERY_PROBE 命令期间报告为"已触发"，则返回 True。请注意，如果在宏中使用它，根据模板展开的顺序，必须在包含此引用的宏之前运行 QUERY_PROBE 命令。
- `last_z_result`：返回上一次 PROBE 命令的结果 Z 值。请注意，由于模板展开的顺序，在宏中使用时必须在包含此引用的宏之前运行 PROBE（或类似）命令。

## pwm_cycle_time

The following information is available in [pwm_cycle_time some_name](Config_Reference.md#pwm_cycle_time) objects:

- `value`：由`SET_PIN`指令设置的引脚“值”。

## quad_gantry_level

`quad_gantry_level` 对象提供了以下信息（如果定义了 quad_gantry_level，则该对象可用）：

- `applied`：如果龙门调平已运行并成功完成，则为 True。

## query_endstops

`query_endstops` 对象提供以下信息（如果定义了任何限位，则该对象可用）：

- `last_query["<限位>"]`：如果在最后一次 QUERY_ENDSTOP 命令中，给定的 endstop 处于“触发”状态，则返回 True。注意，如果在宏中使用，由于模板扩展的顺序，QUERY_ENDSTOP 命令必须在包含这个引用的宏之前运行。

## screws_tilt_adjust

以下信息可在`screws_tilt_adjust`对象中获取：

- `error`: 如果最近的 `SCREWS_TILT_CALCULATE` 命令包含了 `MAX_DEVIATION` 参数，并且任何一个已探测的螺丝坐标超过了指定的 `MAX_DEVIATION`，则返回 True。
- `MAX_DEVERATION`：返回最新的`SPRWS_TILT_CALCULATE`命令的最后一个`MAX_DEVIATION`值。
- `results["<螺丝>"]`：包含以下键的字典：
   - `z`: 螺丝坐标测量的 Z 高度。
   - `sign`：一个字符串，指定进行必要的调整时旋转螺丝的方向。“CW”表示顺时针，“CCW”表示逆时针。
   - `adjust`: 调整螺丝的圈数，格式为 "HH:MM"，其中 "HH" 表示完整螺丝圈数，"MM" 表示代表部分螺丝圈数的 "时钟面的分钟数"。（例如，“01:15”表示旋转螺丝一圈和四分之一圈。）
   - `is_base` ：如果这是基准螺丝，则返回True。

## servo

[servo some_name](Config_Reference.md#servo) 对象提供了以下信息：

- `printer["servo <配置名>"].value`：与指定伺服相关 PWM 引脚的上一次设置的值（0.0 和 1.0 之间的值）。

## skew_correction.py

The following information is available in the `skew_correction` object (this object is available if any skew_correction is defined):

- `current_profile_name`: Returns the name of the currently loaded SKEW_PROFILE.

## stepper_enable

以下信息可在`stepper_enable` 对象中获得（这个对象在定义了任何步进电机后可用）：

- `steppers["<步进器>"]` ：如果给定的步进器被启用，返回True。

## system_stats

`system_stats` 对象提供了以下信息（该对象始终可用）：

- `sysload`、`cputime`、`memavail`：关于主机操作系统和进程负载的信息。

## 温度传感器

以下信息可在

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [sht3x config_section_name](Config_Reference.md#sht31-sensor), [lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor), [temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) and [temperature_combined config_section_name](Config_Reference.md#combined-temperature-sensor) objects:

- `temperature`：上一次从传感器读取的温度。
- `humidity`, `pressure`, `gas`: The last read values from the sensor (only on bme280, htu21d, sht3x and lm75 sensors).

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
- `temperature`：司机上报的车内温度。如果驱动程序未启用或驱动程序不支持温度报告，则此字段为空。
- `run_current`：当前设置的运行电流。
- `hold_current`：当前设置的保持电流。

## toolhead

`toolhead` 对象提供了以下信息（该对象始终可用）：

- `position`：打印头相对于配置文件中指定的坐标系的最后命令位置。可以访问该位置的 x、y、z 和 e 分量（例如，`position.x`）。
- `extruder`：当前活跃的挤出机的名称。例如，在宏中可以使用`printer[printer.toolhead.extruder].target`来获取当前挤出机的目标温度。
- `homed_axes`：当前被认为处于“已归位”状态的车轴。这是一个包含一个或多个"x"、"y"、"z"的字符串。
- `axis_minimum`、`axis_maximum`：归位后的轴的行程限制（毫米）。可以访问此极限值的 x、y、z 分量（例如，`axis_minimum.x`、`axis_maximum.z`）。
- 对于三角洲打印机，`cone_start_z` 是最大半径时的最大z高度(`printer.toolhead.cone_start_z`)。
- `max_velocity`, `max_accel`, `minimum_cruise_ratio`, `square_corner_velocity`: The current printing limits that are in effect. This may differ from the config file settings if a `SET_VELOCITY_LIMIT` (or `M204`) command alters them at run-time.
- `stalls`：由于工具头移动速度快于从 G 代码输入读取的移动速度，因此打印机必须暂停的总次数（自上次重新启动以来）。

## dual_carriage

关于笛卡尔机器人、混合核心机器人或混合核心机器人，[dual_carriage](Config_Reference.md#dual_carriage)中提供了以下信息

- `Carty_0`：表示0的车厢模式。可能的值为：“非活动”和“主要”。
- `Carrance_1`：马车1的模式，可选值为：Inactive、PRIMARY、COPY、MIRROR。

On a `generic_cartesian` kinematic, the following information is available in `dual_carriage`:

- `carriages["<carriage>"]`: The mode of the carriage `<carriage>`. Possible values are "INACTIVE" and "PRIMARY" for the primary carriage and "INACTIVE", "PRIMARY", "COPY", and "MIRROR" for the dual carriage.

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

## z_thermal_adjust

`z_thermal_adjust` 对象提供以下信息（如果定义了[z_thermal_adjust](Config_Reference.md#z_thermal_adjust)配置分段，该对象就可用）。

- `enabled`：如果启用调整，则返回 True。
- `temperature`：定义传感器的当前（平滑后的）温度。 [摄氏度]
- `measured_min_temp`：最小测量温度。[摄氏度]
- `measured_max_temp`：最大测量温度。[摄氏度]
- `current_z_adjust`：上次计算的z调整[mm]。
- `z_adjust_ref_temperature`：用于计算Z `current_z_adjust`的当前参考温度[degC]。

## z_tilt

`z_tilt` 对象提供了以下信息（如果定义了 z_tilt，则该对象可用）：

- `applied`：如果 z 倾斜调平过程已运行并成功完成，则为 True。
