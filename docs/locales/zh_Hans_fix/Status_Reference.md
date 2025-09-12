# 状态参考

本文档是Klipper中可用的打印机状态信息的参考，这些信息可通过[宏](Command_Templates.md)、[显示字段](Config_Reference.md#display)以及[API服务器](API_Server.md)获取。

本文档中的字段可能会发生变化——如果使用了某个属性，在升级Klipper软件时请务必查阅[配置变更文档](Config_Changes.md)。

## angle

以下信息可在[angle some_name](Config_Reference.md#angle)对象中获取：
- `temperature`：来自tle5012b磁性霍尔传感器的最后温度读数（摄氏度）。仅当角度传感器为tle5012b芯片且正在进行测量时，此值才可用（否则报告为`None`）。

## bed_mesh

以下信息可在[bed_mesh](Config_Reference.md#bed_mesh)对象中获取：
- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`：当前活动的bed_mesh的相关信息。
- `profiles`：使用BED_MESH_PROFILE设置的当前定义的配置文件集合。

## bed_screws

以下信息可在[bed_screws](Config_Reference.md#bed_screws)对象中获取：
- `is_active`：如果床调平螺丝调整工具当前处于活动状态，则返回True。
- `state`：床调平螺丝调整工具的状态。其值为以下字符串之一："adjust"（调整）、"fine"（精细）。
- `current_screw`：当前正在调整的螺丝的索引。
- `accepted_screws`：已接受的螺丝数量。

## canbus_stats

以下信息可在`canbus_stats some_mcu_name`对象中获取（如果mcu配置为使用canbus，则此对象会自动可用）：
- `rx_error`：微控制器canbus硬件检测到的接收错误次数。
- `tx_error`：微控制器canbus硬件检测到的发送错误次数。
- `tx_retries`：由于总线争用或错误而重试的发送尝试次数。
- `bus_state`：接口状态（通常为“active”表示总线正常运行，“warn”表示总线最近有错误，“passive”表示总线将不再发送canbus错误帧，或“off”表示总线将不再发送或接收消息）。

请注意，只有rp2XXX微控制器报告非零的`tx_retries`字段，而rp2XXX微控制器始终将`tx_error`报告为零，将`bus_state`报告为“active”。

## configfile

以下信息可在`configfile`对象中获取（此对象始终可用）：
- `settings.<section>.<option>`：返回上次软件启动或重启时给定的配置文件设置（或默认值）。（运行时更改的任何设置在此处不会反映。）
- `config.<section>.<option>`：返回Klipper在上次软件启动或重启时读取的原始配置文件设置。（运行时更改的任何设置在此处不会反映。）所有值均以字符串形式返回。
- `save_config_pending`：如果存在`SAVE_CONFIG`命令可能持久化到磁盘的更新，则返回true。
- `save_config_pending_items`：包含已更改且将由`SAVE_CONFIG`持久化的节和选项。
- `warnings`：关于配置选项的警告列表。列表中的每个条目将是一个包含`type`和`message`字段（均为字符串）的字典。根据警告类型，可能提供其他字段。

## display_status

以下信息可在`display_status`对象中获取（如果定义了[display](Config_Reference.md#display)配置节，则此对象会自动可用）：
- `progress`：最后一条`M73` G-Code命令的进度值（或`virtual_sdcard.progress`，如果没有收到最近的`M73`）。
- `message`：最后一条`M117` G-Code命令中包含的消息。

## endstop_phase

以下信息可在[endstop_phase](Config_Reference.md#endstop_phase)对象中获取：
- `last_home.<stepper name>.phase`：上次归位尝试结束时步进电机的相位。
- `last_home.<stepper name>.phases`：步进电机上可用的总相位数。
- `last_home.<stepper name>.mcu_position`：上次归位尝试结束时步进电机的位置（由微控制器跟踪）。该位置是自微控制器上次重启以来向前方向的总步数减去向后方向的总步数。

## exclude_object

以下信息可在[exclude_object](Exclude_Object.md)对象中获取：

- `objects`：由`EXCLUDE_OBJECT_DEFINE`命令提供的已知对象数组。这与`EXCLUDE_OBJECT VERBOSE=1`命令提供的信息相同。`center`和`polygon`字段仅在原始`EXCLUDE_OBJECT_DEFINE`中提供时才存在。

  以下是JSON示例：
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
- `excluded_objects`：列出排除对象名称的字符串数组。
- `current_object`：当前正在打印的对象的名称。

## extruder_stepper

以下信息可用于extruder_stepper对象（以及[extruder](Config_Reference.md#extruder)对象）：
- `pressure_advance`：当前的[压力提前](Pressure_Advance.md)值。
- `smooth_time`：当前的压力提前平滑时间。
- `motion_queue`：此挤出机步进电机当前同步到的挤出机名称。如果挤出机步进电机当前未与挤出机关联，则报告为`None`。

## fan

以下信息可在[fan](Config_Reference.md#fan)、[heater_fan some_name](Config_Reference.md#heater_fan)和[controller_fan some_name](Config_Reference.md#controller_fan)对象中获取：
- `speed`：风扇速度，范围为0.0到1.0的浮点数。
- `rpm`：如果风扇定义了tachometer_pin，则为测得的风扇转速（每分钟转数）。

## filament_switch_sensor

以下信息可在[filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor)对象中获取：
- `enabled`：如果开关传感器当前已启用，则返回True。
- `filament_detected`：如果传感器处于触发状态，则返回True。

## filament_motion_sensor

以下信息可在[filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor)对象中获取：
- `enabled`：如果运动传感器当前已启用，则返回True。
- `filament_detected`：如果传感器处于触发状态，则返回True。

## firmware_retraction

以下信息可在[firmware_retraction](Config_Reference.md#firmware_retraction)对象中获取：
- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`：固件回抽模块的当前设置。如果`SET_RETRACTION`命令更改了这些设置，则这些设置可能与配置文件中的设置不同。

## gcode

以下信息可在`gcode`对象中获取：
- `commands`：返回所有当前可用命令的列表。对于每个命令，如果定义了帮助字符串，也会提供。

## gcode_button

以下信息可在[gcode_button some_name](Config_Reference.md#gcode_button)对象中获取：
- `state`：当前按钮状态，返回为“PRESSED”（按下）或“RELEASED”（释放）。

## gcode_macro

以下信息可在[gcode_macro some_name](Config_Reference.md#gcode_macro)对象中获取：
- `<variable>`：[gcode_macro变量](Command_Templates.md#variables)的当前值。

## gcode_move

以下信息可在`gcode_move`对象中获取（此对象始终可用）：
- `gcode_position`：工具头相对于当前G代码原点的当前位置。即可以直接发送到`G1`命令的位置。可以访问此位置的x、y、z和e分量（例如，`gcode_position.x`）。
- `position`：使用配置文件中指定的坐标系的工具头最后命令位置。可以访问此位置的x、y、z和e分量（例如，`position.x`）。
- `homing_origin`：`G28`命令后使用的gcode坐标系原点（相对于配置文件中指定的坐标系）。`SET_GCODE_OFFSET`命令可以更改此位置。可以访问此位置的x、y和z分量（例如，`homing_origin.x`）。
- `speed`：最后在`G1`命令中设置的速度（mm/s）。
- `speed_factor`：由`M220`命令设置的“速度因子覆盖”。这是一个浮点数值，1.0表示无覆盖，例如2.0将使请求的速度加倍。
- `extrude_factor`：由`M221`命令设置的“挤出因子覆盖”。这是一个浮点数值，1.0表示无覆盖，例如2.0将使请求的挤出量加倍。
- `absolute_coordinates`：如果处于`G90`绝对坐标模式则返回True，如果处于`G91`相对模式则返回False。
- `absolute_extrude`：如果处于`M82`绝对挤出模式则返回True，如果处于`M83`相对模式则返回False。

## hall_filament_width_sensor

以下信息可在[hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor)对象中获取：
- 来自[filament_switch_sensor](Status_Reference.md#filament_switch_sensor)的所有项目
- `is_active`：如果传感器当前处于活动状态，则返回True。
- `Diameter`：传感器的最后读数（毫米）。
- `Raw`：传感器的最后原始ADC读数。

## heater

以下信息可用于加热器对象，如[extruder](Config_Reference.md#extruder)、[heater_bed](Config_Reference.md#heater_bed)和[heater_generic](Config_Reference.md#heater_generic)：
- `temperature`：给定加热器报告的最后温度（摄氏度，浮点数）。
- `target`：给定加热器的当前目标温度（摄氏度，浮点数）。
- `power`：与加热器关联的PWM引脚的最后设置（介于0.0和1.0之间的值）。
- `can_extrude`：如果挤出机能挤出（由`min_extrude_temp`定义），仅适用于[extruder](Config_Reference.md#extruder)。

## heaters

以下信息可在`heaters`对象中获取（如果定义了任何加热器，则此对象可用）：
- `available_heaters`：返回所有当前可用加热器的完整配置节名称列表，例如`["extruder", "heater_bed", "heater_generic my_custom_heater"]`。
- `available_sensors`：返回所有当前可用温度传感器的完整配置节名称列表，例如`["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"]`。
- `available_monitors`：返回所有当前可用温度监控器的完整配置节名称列表，例如`["tmc2240 stepper_x"]`。虽然温度传感器始终可读，但温度监控器可能不可用，在这种情况下将返回null。

## idle_timeout

以下信息可在[idle_timeout](Config_Reference.md#idle_timeout)对象中获取（此对象始终可用）：
- `state`：由idle_timeout模块跟踪的打印机当前状态。其值为以下字符串之一：“Idle”（空闲）、“Printing”（打印中）、“Ready”（就绪）。
- `printing_time`：打印机处于“Printing”状态的时间量（秒），由idle_timeout模块跟踪。
- `idle_timeout`：等待gcode触发的当前“超时”时间（秒）。（由[SET_IDLE_TIMEOUT](G-Codes.md#set_idle_timeout)设置）

## led

以下信息可用于printer.cfg中定义的每个`[led led_name]`、`[neopixel led_name]`、`[dotstar led_name]`、`[pca9533 led_name]`和`[pca9632 led_name]`配置节：
- `color_data`：包含链中LED的RGBW值的颜色列表。每个值表示为0.0到1.0之间的浮点数。每个颜色列表包含4个项目（红色、绿色、蓝色、白色），即使底层LED支持较少的颜色通道也是如此。例如，链中第二个neopixel的蓝色值（颜色列表中的第3个项目）可通过`printer["neopixel <config_name>"].color_data[1][2]`访问。

## load_cell

以下信息可用于每个`[load_cell name]`：
- 'is_calibrated'：True/False，表示称重传感器是否已校准
- 'counts_per_gram'：等于1克力的原始传感器计数值
- 'reference_tare_counts'：0力的参考原始传感器计数值
- 'tare_counts'：0力的当前原始传感器计数值
- 'force_g'：以克为单位的力，在上次轮询周期内取平均值。
- 'min_force_g'：上次轮询周期内的最小力（克）。
- 'max_force_g'：上次轮询周期内的最大力（克）。

## load_cell_probe

以下信息可用于`[load_cell_probe]`：
- 来自[load_cell](Status_Reference.md#load_cell)的所有项目
- 来自[probe](Status_Reference.md#probe)的所有项目
- 'endstop_tare_counts'：称重传感器探头保持独立于称重传感器的去皮值。每次探测开始时重置此值。
- 'last_trigger_time'：上次归位触发的时间戳

## manual_probe

以下信息可在`manual_probe`对象中获取：
- `is_active`：如果当前处于手动探测辅助脚本活动状态，则返回True。
- `z_position`：喷嘴的当前位置（打印机当前理解的）。
- `z_position_lower`：上次探测尝试刚好低于当前位置。
- `z_position_upper`：上次探测尝试刚好高于当前位置。

## mcu

以下信息可在[mcu](Config_Reference.md#mcu)和[mcu some_name](Config_Reference.md#mcu-my_extra_mcu)对象中获取：
- `mcu_version`：微控制器报告的Klipper代码版本。
- `mcu_build_versions`：用于生成微控制器代码的构建工具信息（由微控制器报告）。
- `mcu_constants.<constant_name>`：微控制器报告的编译时常量。可用常量可能因微控制器架构和每次代码修订而异。
- `last_stats.<statistics_name>`：微控制器连接的统计信息。

## motion_report

以下信息可在`motion_report`对象中获取（如果定义了任何步进电机配置节，则此对象会自动可用）：
- `live_position`：插值到当前时间的请求工具头位置。
- `live_velocity`：当前时间的请求工具头速度（mm/s）。
- `live_extruder_velocity`：当前时间的请求挤出机速度（mm/s）。

## output_pin

以下信息可在[output_pin some_name](Config_Reference.md#output_pin)和[pwm_tool some_name](Config_Reference.md#pwm_tool)对象中获取：
- `value`：由`SET_PIN`命令设置的引脚“值”。

## palette2

以下信息可在[palette2](Config_Reference.md#palette2)对象中获取：
- `ping`：上次报告的Palette 2 ping的百分比。
- `remaining_load_length`：启动Palette 2打印时，这将是装入挤出机的耗材量。
- `is_splicing`：当Palette 2正在拼接耗材时为True。

## pause_resume

以下信息可在[pause_resume](Config_Reference.md#pause_resume)对象中获取：
- `is_paused`：如果已执行PAUSE命令而没有相应的RESUME，则返回true。

## print_stats

以下信息可在`print_stats`对象中获取（如果定义了[virtual_sdcard](Config_Reference.md#virtual_sdcard)配置节，则此对象会自动可用）：
- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message`：当虚拟SD卡打印处于活动状态时，有关当前打印的估计信息。
- `info.total_layer`：最后一条`SET_PRINT_STATS_INFO TOTAL_LAYER=<value>` G-Code命令的总层数值。
- `info.current_layer`：最后一条`SET_PRINT_STATS_INFO CURRENT_LAYER=<value>` G-Code命令的当前层数值。

## probe

以下信息可在[probe](Config_Reference.md#probe)对象中获取（如果定义了[bltouch](Config_Reference.md#bltouch)配置节，则此对象也可用）：
- `name`：返回正在使用的探头名称。
- `last_query`：如果在最后的QUERY_PROBE命令期间探头报告为“已触发”，则返回True。注意，如果在宏中使用此值，由于模板扩展的顺序，必须在包含此引用的宏之前运行QUERY_PROBE命令。
- `last_z_result`：返回最后PROBE命令的Z结果值。注意，如果在宏中使用此值，由于模板扩展的顺序，必须在包含此引用的宏之前运行PROBE（或类似）命令。

## pwm_cycle_time

以下信息可在[pwm_cycle_time some_name](Config_Reference.md#pwm_cycle_time)对象中获取：
- `value`：由`SET_PIN`命令设置的引脚“值”。

## quad_gantry_level

以下信息可在`quad_gantry_level`对象中获取（如果定义了quad_gantry_level，则此对象可用）：
- `applied`：如果龙门架调平过程已运行并成功完成，则为True。

## query_endstops

以下信息可在`query_endstops`对象中获取（如果定义了任何限位开关，则此对象可用）：
- `last_query["<endstop>"]`：如果在最后的QUERY_ENDSTOP命令期间给定的限位开关报告为“已触发”，则返回True。注意，如果在宏中使用此值，由于模板扩展的顺序，必须在包含此引用的宏之前运行QUERY_ENDSTOP命令。

## screws_tilt_adjust

以下信息可在`screws_tilt_adjust`对象中获取：
- `error`：如果最近的`SCREWS_TILT_CALCULATE`命令包含`MAX_DEVIATION`参数，并且任何探测的螺丝点超过了指定的`MAX_DEVIATION`，则返回True。
- `max_deviation`：返回最近`SCREWS_TILT_CALCULATE`命令的最后`MAX_DEVIATION`值。
- `results["<screw>"]`：包含以下键的字典：
  - `z`：螺丝位置的测量Z高度。
  - `sign`：指定拧紧螺丝必要调整方向的字符串。顺时针为“CW”，逆时针为“CCW”。
  - `adjust`：调整螺丝的圈数，格式为“HH:MM”，其中“HH”为完整螺丝圈数，“MM”为部分螺丝圈数的“钟面分钟数”。（例如，“01:15”表示将螺丝转动一圈又四分之一圈。）
  - `is_base`：如果这是基准螺丝，则返回True。

## servo

以下信息可在[servo some_name](Config_Reference.md#servo)对象中获取：
- `printer["servo <config_name>"].value`：与伺服关联的PWM引脚的最后设置（介于0.0和1.0之间的值）。

## skew_correction.py

以下信息可在`skew_correction`对象中获取（如果定义了任何skew_correction，则此对象可用）：
- `current_profile_name`：返回当前加载的SKEW_PROFILE的名称。

## stepper_enable

以下信息可在`stepper_enable`对象中获取（如果定义了任何步进电机，则此对象可用）：
- `steppers["<stepper>"]`：如果给定的步进电机已启用，则返回True。

## system_stats

以下信息可在`system_stats`对象中获取（此对象始终可用）：
- `sysload`, `cputime`, `memavail`：主机操作系统和进程负载的信息。

## 温度传感器

以下信息可在[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor)、[htu21d config_section_name](Config_Reference.md#htu21d-sensor)、[sht3x config_section_name](Config_Reference.md#sht31-sensor)、[lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor)、[temperature_host config_section_name](Config_Reference.md#host-temperature-sensor)和[temperature_combined config_section_name](Config_Reference.md#combined-temperature-sensor)对象中获取：
- `temperature`：传感器的最后读取温度。
- `humidity`, `pressure`, `gas`：传感器的最后读取值（仅在bme280、htu21d、sht3x和lm75传感器上可用）。

## temperature_fan

以下信息可在[temperature_fan some_name](Config_Reference.md#temperature_fan)对象中获取：
- `temperature`：传感器的最后读取温度。
- `target`：风扇的目标温度。

## temperature_sensor

以下信息可在[temperature_sensor some_name](Config_Reference.md#temperature_sensor)对象中获取：
- `temperature`：传感器的最后读取温度。
- `measured_min_temp`, `measured_max_temp`：自Klipper主机软件上次重启以来，传感器看到的最低和最高温度。

## TMC驱动器

以下信息可在[TMC步进驱动器](Config_Reference.md#tmc-stepper-driver-configuration)对象（例如，`[tmc2208 stepper_x]`）中获取：
- `mcu_phase_offset`：与驱动器“零”相位对应的微控制器步进位置。如果相位偏移未知，此字段可能为null。
- `phase_offset_position`：对应于驱动器“零”相位的“命令位置”。如果相位偏移未知，此字段可能为null。
- `drv_status`：上次驱动器状态查询的结果。（仅报告非零字段。）如果驱动器未启用（因此不会定期查询），此字段将为null。
- `temperature`：驱动器报告的内部温度。如果驱动器未启用或不支持温度报告，此字段将为null。
- `run_current`：当前设置的运行电流。
- `hold_current`：当前设置的保持电流。

## toolhead

以下信息可在`toolhead`对象中获取（此对象始终可用）：
- `position`：工具头相对于配置文件中指定的坐标系的最后命令位置。可以访问此位置的x、y、z和e分量（例如，`position.x`）。
- `extruder`：当前活动的挤出机名称。例如，在宏中可以使用`printer[printer.toolhead.extruder].target`来获取当前挤出机的目标温度。
- `homed_axes`：当前认为处于“归位”状态的笛卡尔轴。这是一个包含一个或多个“x”、“y”、“z”的字符串。
- `axis_minimum`, `axis_maximum`：归位后的轴行程限制（毫米）。可以访问此限制值的x、y、z分量（例如，`axis_minimum.x`，`axis_maximum.z`）。
- 对于Delta打印机，`cone_start_z`是最大半径下的最大z高度（`printer.toolhead.cone_start_z`）。
- `max_velocity`, `max_accel`, `minimum_cruise_ratio`, `square_corner_velocity`：当前生效的打印限制。如果`SET_VELOCITY_LIMIT`（或`M204`）命令在运行时更改了这些设置，则可能与配置文件设置不同。
- `stalls`：自上次重启以来，由于工具头移动速度超过G代码输入读取速度而导致打印机必须暂停的总次数。

## dual_carriage

以下信息可在cartesian、hybrid_corexy或hybrid_corexz机器人上的[dual_carriage](Config_Reference.md#dual_carriage)中获取：
- `carriage_0`：载架0的模式。可能的值为：“INACTIVE”（非活动）和“PRIMARY”（主）。
- `carriage_1`：载架1的模式。可能的值为：“INACTIVE”（非活动）、“PRIMARY”（主）、“COPY”（复制）和“MIRROR”（镜像）。

在`generic_cartesian`运动学中，`dual_carriage`中可获取以下信息：
- `carriages["<carriage>"]`：载架`<carriage>`的模式。主载架的可能值为“INACTIVE”（非活动）和“PRIMARY”（主），双载架的可能值为“INACTIVE”（非活动）、“PRIMARY”（主）、“COPY”（复制）和“MIRROR”（镜像）。

## virtual_sdcard

以下信息可在[virtual_sdcard](Config_Reference.md#virtual_sdcard)对象中获取：
- `is_active`：如果当前处于从文件打印的活动状态，则返回True。
- `progress`：当前打印进度的估计值（基于文件大小和文件位置）。
- `file_path`：当前加载文件的完整路径。
- `file_position`：活动打印的当前位置（字节）。
- `file_size`：当前加载文件的文件大小（字节）。

## webhooks

以下信息可在`webhooks`对象中获取（此对象始终可用）：
- `state`：返回一个字符串，指示当前Klipper状态。可能的值为：“ready”（就绪）、“startup”（启动）、“shutdown”（关闭）、“error”（错误）。
- `state_message`：一个人类可读的字符串，提供有关当前Klipper状态的额外上下文。

## z_thermal_adjust

以下信息可在`z_thermal_adjust`对象中获取（如果定义了[z_thermal_adjust](Config_Reference.md#z_thermal_adjust)，则此对象可用）。
- `enabled`：如果调整已启用，则返回True。
- `temperature`：定义的传感器的当前（平滑）温度。[摄氏度]
- `measured_min_temp`：测量到的最低温度。[摄氏度]
- `measured_max_temp`：测量到的最高温度。[摄氏度]
- `current_z_adjust`：最后计算的Z调整值[毫米]。
- `z_adjust_ref_temperature`：用于计算Z `current_z_adjust`的当前参考温度[摄氏度]。

## z_tilt

以下信息可在`z_tilt`对象中获取（如果定义了z_tilt，则此对象可用）：
- `applied`：如果z-倾斜调平过程已运行并成功完成，则为True。