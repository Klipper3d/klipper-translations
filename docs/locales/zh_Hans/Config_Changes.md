# 配置变更

本文档涵盖了软件更新中对配置文件不向后兼容的部分。在升级 Klipper 时，最好也查看一下这份文档。

文档的所有日期都是大概时间。

## 变更

20250428: The maximum `cycle_time` for pwm `[output_pin]`, `[pwm_cycle_time]`, `[pwm_tool]`, and similar config sections is now 3 seconds (reduced from 5 seconds). The `maximum_mcu_duration` in `[pwm_tool]` is now also 3 seconds.

20250418: The manual_stepper `STOP_ON_ENDSTOP` feature may now take less time to complete. Previously, the command would wait the entire time the move could possibly take even if the endstop triggered earlier. Now, the command finishes shortly after the endstop trigger.

20250417: SPI devices using "software SPI" are now rate limited. Previously, the `spi_speed` in the config was ignored and the transmission speed was only limited by the processing speed of the micro-controller. Now, speeds are limited by the `spi_speed` config parameter (actual hardware speeds are likely to be lower than the configured value due to software overhead).

20250411: Klipper v0.13.0 released.

20250308: The `AUTO` parameter of the `AXIS_TWIST_COMPENSATION_CALIBRATE` command has been removed.

20250131: Option `VARIABLE=<name>` in `SAVE_VARIABLE` requires lowercase value. For example, `extruder` instead of mixedcase `Extruder` or uppercase `EXTRUDER`. Using any uppercase letter will raise an error.

20241203: The resonance test has been changed to include slow sweeping moves. This change requires that testing point(s) have some clearance in X/Y plane (+/- 30 mm from the test point should suffice when using the default settings). The new test should generally produce more accurate and reliable test results. However, if required, the previous test behavior can be restored by adding options `sweeping_period: 0` and `accel_per_hz: 75` to the `[resonance_tester]` config section.

20241201: In some cases Klipper may have ignored leading characters or spaces in a traditional G-Code command. For example, "99M123" may have been interpreted as "M123" and "M 321" may have been interpreted as "M321". Klipper will now report these cases with an "Unknown command" warning.

20241112: Option `CHIPS=<chip_name>` in `TEST_RESONANCES` and `SHAPER_CALIBRATE` requires specifying the full name(s) of the accel chip(s). For example, `adxl345 rpi` instead of short name - `rpi`.

20240912: `SET_PIN`, `SET_SERVO`, `SET_FAN_SPEED`, `M106`, and `M107` commands are now collated. Previously, if many updates to the same object were issued faster than the minimum scheduling time (typically 100ms) then actual updates could be queued far into the future. Now if many updates are issued in rapid succession then it is possible that only the latest request will be applied. If the previous behavior is requried then consider adding explicit `G4` delay commands between updates.

20240912: Support for `maximum_mcu_duration` and `static_value` parameters in `[output_pin]` config sections have been removed. These options have been deprecated since 20240123.

20240415: The `on_error_gcode` parameter in the `[virtual_sdcard]` config section now has a default. If this parameter is not specified it now defaults to `TURN_OFF_HEATERS`. If the previous behavior is desired (take no default action on an error during a virtual_sdcard print) then define `on_error_gcode` with an empty value.

20240313: The `max_accel_to_decel` parameter in the `[printer]` config section has been deprecated. The `ACCEL_TO_DECEL` parameter of the `SET_VELOCITY_LIMIT` command has been deprecated. The `printer.toolhead.max_accel_to_decel` status has been removed. Use the [minimum_cruise_ratio parameter](./Config_Reference.md#printer) instead. The deprecated features will be removed in the near future, and using them in the interim may result in subtly different behavior.

20240215: Several deprecated features have been removed. Using "NTC 100K beta 3950" as a thermistor name has been removed (deprecated on 20211110). The `SYNC_STEPPER_TO_EXTRUDER` and `SET_EXTRUDER_STEP_DISTANCE` commands have been removed, and the extruder `shared_heater` config option has been removed (deprecated on 20220210). The bed_mesh `relative_reference_index` option has been removed (deprecated on 20230619).

20240123: The output_pin SET_PIN CYCLE_TIME parameter has been removed. Use the new [pwm_cycle_time](Config_Reference.md#pwm_cycle_time) module if it is necessary to dynamically change a pwm pin's cycle time.

20240123: The output_pin `maximum_mcu_duration` parameter is deprecated. Use a [pwm_tool config section](Config_Reference.md#pwm_tool) instead. The option will be removed in the near future.

20240123: The output_pin `static_value` parameter is deprecated. Replace with `value` and `shutdown_value` parameters. The option will be removed in the near future.

20231216: The `[hall_filament_width_sensor]` is changed to trigger filament runout when the thickness of the filament exceeds `max_diameter`. The maximum diameter defaults to `default_nominal_filament_diameter + max_difference`. See [[hall_filament_width_sensor] configuration
reference](./Config_Reference.md#hall_filament_width_sensor) for more details.

20231207: Several undocumented config parameters in the `[printer]` config section have been removed (the buffer_time_low, buffer_time_high, buffer_time_start, and move_flush_time parameters).

20231110: Klipper v0.12.0 released.

20230826：如果在 `[dual_carriage]`中将“safe_distance”设置或计算为0，则将根据文档禁用车厢接近检查。用户可能希望明确配置“safe_distance”，以防止车厢彼此意外碰撞。此外，主滑架和双滑架的归位顺序在某些配置中会发生变化（当两个滑架都在同一方向上归位时的某些配置，请参阅[[dual_carriage] 配置参考](./Config_Reference.md#dual_carriage)了解更多详细信息）。

20230810：Flash-sdcard.sh脚本现在支持Bigtreetech SKR-3的两个变体：STM32H743和STM32H723。为此，btt-skr-3的原始标签现在已更改为btt-skr-3-h743或btt-skr-3-h723。

20230729:`dual_carriage`的导出状态已更改。不是导出 `mode`和`active_carriage`，而是将每个车厢的各个模式导出为 `printer.dual_carriage.carriage_0`和 `printer.dual_carriage.carriage_1`.

20230619：`Relative_Reference_Index`选项已弃用，取而代之的是`ZERO_REFERENCE_Position`选项。有关如何更新配置的详细信息请参阅[Bed Mesh Documentation](./Bed_Mesh.md#the-deprecated-relative_reference_index)。在此情况下，`Relative_Reference_INDEX`不再可用作`BED_MESH_CALIBRATE`gcode命令的参数。

20230530：“make menuconfig”中的默认CANBUS频率现在为1000000。如果需要使用CANBUS和使用其他频率的CANBUS，则在编译和刷新微控制器时，请务必选择“启用额外的低级配置选项”，并在“Make menuconfig”中指定所需的“CAN Bus速度”。

20230525：如果`[INPUT_SHAPPER]`已启用，则`SHAPER_CALIBRATE`命令立即应用输入形成器参数。

20230407：日志和`printer.mcu.last_stats`字段中的`stalled_bytes`计数器已重命名为`income_bytes`。

20230323：在tmc5160驱动上，现在默认开启`MultiStep_filt`。对于之前的行为，在tmc5160配置中设置`DRIVER_MULTSTEP_FILT：False`。

20230304:`SET_TMC_CURRENT` 命令现在可以正确地调整有globalscalar的驱动的globalscalar。这消除了一个限制，即在 tmc5160 上，使用`SET_TMC_CURRENT` 所提高的电流不能高于配置文件中设置的`run_current` 值。然而，这有一个副作用：如果使用StealthChop2，在运行`SET_TMC_CURRENT` 之后，步进电机必须保持在静止状态至少130ms，这样AT#1校准才会被驱动执行。

20230202：`printer.screw_tilt_adjust` 状态信息的格式已经改变。该信息现在是以screws的字典形式存储的，并附有测量结果。详情见[状态参考文档](Status_Reference.md#screws_tilt_adjust)。

20230201：`[bed_mesh]` 模块在启动时不再加载`default` 配置文件。建议使用`default` 配置的用户将`BED_MESH_PROFILE LOAD=default` 添加到他们的`START_PRINT` 宏中（或者在适用时添加到他们的切片软件的 "启动G代码 "配置中）。

20230103: 现在可以用flash-sdcard.sh脚本对Bigtreetech SKR-2的两个变体STM32F407和STM32F429进行刷写。这意味着原来的标签 btt-skr2 现在变成了btt-skr-2-f407 或 btt-skr-2-f429。

20221128: Klipper v0.11.0发布。

20221122：原先使用safe_z_home时，g28归位后的 z_hop 有可能会向负Z方向移动。现在，g28之后的 z_hop 只有在产生抬升（正方向）时才会被执行，这镜像了 g28 归位之前发生的 z_hop 的行为。

20220616：以前可以通过运行`make flash FLASH_DEVICE=first`在引导程序模式下刷写rp2040。新的等效命令是`make flash FLASH_DEVICE=2e8a:0003`。

20220612: 实现了rp2040上"rp2040-e5"USB数据错误的一个解决办法。这应该使最初的 USB 连接更加可靠。然而，它可能会导致gpio15引脚的行为发生变化。gpio15的行为变化不太可能有明显影响。

20220407：temperature_fan 配置分段中的 `pid_integral_max` 选项已被删除（在 20210612 时已弃用）。

20220407: pca9632 LED的默认色序现在是"RGBW"。在pca9632配置分段中显式加入`color_order:RBGW`设置以获得以和原来一样的行为。

20220330：neopixel和dotstar模块的`printer.neopixel.color_data`状态信息的格式已经改变。这些信息现在被存储为一个列表中的颜色列表（而不是字典列表）。详情见[状态参考](Status_Reference.md#led)。

20220307:`M73`如果不给定`P`，则不再将打印进度设置为0。

20220304：[extruder_stepper](Config_Reference.md#extruder_stepper)配置分段的`extruder`参数不再有默认设置。如果需要，可以明确指定`extruder: extruder`，以便在启动时关联步进电机和"extruder"运动序列。

20220210：`SYNC_STEPPER_TO_EXTRUDER`、`SET_EXTRUDER_STEP_DISTANCE`、[extruder](Config_Reference.md#extruder)的 `shared_heater` 配置选项已弃用。这些功能将在不久的将来被删除。将`SET_EXTRUDER_STEP_DISTANCE`替换为`SET_EXTRUDER_ROTATION_DISTANCE`，`SYNC_STEPPER_TO_EXTRUDER`替换为`SYNC_EXTRUDER_MOTION`，使用 `shared_heater` 与 [extruder_stepper](Config_Reference.md#extruder_stepper)配置分段替换 extruder 配置分段，并更新所有激活宏以使用 [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion)。

20220116: 变更了tmc2130、tmc2208、tmc2209和tmc2660的 `run_current` 计算代码。对于一些 `run_current`设置，驱动程序现在的配置结果可能被和原来不同。新的配置应该更准确，但它可能导致前的tmc驱动调谐失效。

20211230: 迁移输入整形器调整脚本（`scripts/calibrate_shaper.py`和`scripts/graph_accelerometer.py`），新脚本默认使用Python3。因此，必须安装Python3版本的某些软件包（例如，`sudo apt install python3-numpy python3-matplotlib`）才能继续使用这些脚本。更多细节，请参考[软件安装](Measuring_Resonances.md#software-installation)。另外，用户可以通过在控制台显性调用Python2解释器，临时强制在Python 2下执行这些脚本：`python2 ~/klipper/scripts/calibrate_shaper.py ...`

20211110: 弃用"NTC 100K beta 3950 "温度传感器。未来会删除这个传感器。大多数用户会发现 "Generic 3950 "温度传感器更准确。要继续使用旧的（通常不太准确）定义，请定义一个自定义的[thermistor](Config_Reference.md#thermistor)，其中包括`temperature1: 25`，`resistance1: 100000`和`beta: 3950`。

20211104：删除了"make menuconfig "中的 "step pulse duration "选项。现在在UART或SPI模式下配置的TMC驱动器的默认步长是100ns。在[stepper config section](Config_Reference.md#stepper)中的增加了一个新的`step_pulse_duration`设置，所有需要自定义脉冲持续时间的步进驱动器都需要设置。

20211102：删除了多个废弃的功能。删除了步进器`step_distance`选项（已于20201222废弃）。删除了`rpi_temperature`传感器别名（已于20210219废弃）。删除了mcu的`pin_map`选项（已于20210325废弃）。删除了gcode_macro `default_parameter_<name>`和通过`params`伪变量以外的宏访问命令参数（已于20210503废弃）。删除了加热器的`pid_integral_max`选项（已于20210612废弃）。

20210929: Klipper v0.10.0发布。

20210903: 加热器的默认[`smooth_time`](Config_Reference.md#extruder)已改为1秒（从2秒）。对于大多数打印机来说，这将使温度控制更加稳定。

20210830: 默认的adxl345名称现在是 "adxl345"。`ACCELEROMETER_MEASURE`和`ACCELEROMETER_QUERY`的默认CHIP参数现在也是 "adxl345"。

20210830: adxl345 ACCELEROMETER_MEASURE命令不再支持RATE参数。要改变查询速率，请更新printer.cfg文件并发出RESTART命令。

20210821: `printer.configfile.settings`中的一些配置设置现在将以列表形式报告，而不是原始字符串。如果需要原始的字符串，请使用`printer.configfile.config`代替。

20210819: 在某些情况下，`G28`的归零动作可能在某个超出有效移动范围的位置结束。在少数情况下，这可能导致归位后出现 "移动超出范围（Move out of range）"的错误。如果发生这种情况，请改变你的启动脚本，在归位后立即将打印头移动到有效位置。

20210814: atmega168和atmega328上的仅有模拟的伪引脚已经从PE0/PE1改名为PE2/PE3。

20210720: controller_fan部分现在默认监控所有步进电机（而不仅仅是运动型步进电机）。如果需要以前的行为，请参考[config reference](Config_Reference.md#controller_fan)中的`stepper`配置选项。

20210703: `samd_sercom`配置部分现在必须通过`sercom`选项指定它要配置的sercom总线。

20210612: 加热器(heater)和温度控制风扇(temperature_fan)配置中的`pid_integral_max`选项已被弃用。该选项将在未来被移除。

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430: SET_VELOCITY_LIMIT（和M204）命令现在可以设置大于配置文件中指定值的速度(velocity)、加速度(acceleration)和转角离心速度(square_corner_velocity)。

20210325:配置中的`pin_map`选项已被废弃。使用[sample-aliases.cfg](../config/sample-aliases.cfg)文件将现有的引脚名翻译成实际的微控制器引脚名称。配置中的`pin_map` 选项将在未来被移除。

20210313：Klipper对CAN总线通信的微控制器的支持发生了变化。如果使用CAN总线，全部微控制器必须被重新刷写并更新[Klipper CAN 总线配置](CANBUS.md)。

20210310：TMC2660 默认 driver_SFILT 从1 改为 0。

20210227：现在每当启用 UART 或 SPI 模式的 TMC 步进电机驱动活跃时，每秒会查询一次 - 如果无法联系到驱动或如果驱动报告错误，则 Klipper 将过渡到关闭状态。

20210219：`rpi_temperature` 模块已被重新命名为 `temperature_host`。用 `sensor_type: temperature_host` 替换全部的 `sensor_type: rpi_temperature`。温度文件的路径可以在 `sensor_path` 配置变量中指定。名称“`rpi_temperature`”已被废弃，在不久的将来会被删除。

20210201: `TEST_RESONANCES` 命令现在将禁用之前启用的输入整形（并在测试后重新启用）。如果需要覆盖这一行为并保持输入整形在测试时启用，可以在命令中传递一个附加参数 `INPUT_SHAPING=1`。

20210201：如果一个加速度计芯片在printer.cfg的相应 adxl345 分段被赋予了一个名称，`ACCELEROMETER_MEASURE` 命令的输出文件现在会包含它的名称。

20201222：步进配置分段中的`step_distance`设置已被废弃。建议更新配置以使用[`rotrot_distance`](Rotation_Distance.md)设置。对`step_distance`的支持将在不久的将来被移除。

20201218：endstop_phase 模块中的 `endstop_phase` 设置已被 `trigger_phase` 取代。如果使用相位限位模块，则需要转换为 [`rotation_distance`](Rotation_Distance.md)，并通过运行 ENDSTOP_PHASE_CALIBRATE 命令重新校准任何相位限位。

20201218：旋转三角洲和极点打印机现在必须为旋转步进电机指定 `gear_ratio ` ，并且它们可以不再指定 `step_distance ` 参数。有关新 gear_ratio 参数的格式，请参阅 [配置参考](Config_Reference.md#stepper)。

20201213：当使用"probe:z_virtual_endstop"时，指定的 Z "position_endstop"是无效的。现在，如果用"probe:z_virtual_endstop"指定一个 Z "position_endstop"，将会报告一个错误。删除 Z 的 "position_endstop"定义以解决这个错误。

20201120: `[board_pins]`配置部分现在在`mcu:`参数中明确指定了对应MCU名称。如果使用辅助MCU的board_pins，则必须更新配置以指定该MCU名称。参见 [配置参考](Config_Reference.md#board_pins) 以了解更多细节。

20201112: 由`print_stats.print_duration`控制的报告时间已经改变。现在不包括检测到的首次挤出之前的时间。

20201029: neopixel `color_order_GRB` 配置已从配置中移除。如果需要，请更新配置文件，将新的`color_order`选项设置为RGB、GRB、RGBW或GRBW。

20201029: mcu配置部分的串行选项不再默认为 /dev/ttyS0 。在极其罕见的情况下，如果 /dev/ttyS0 是所需的串行端口，必须明确指定它。

20201020: Klipper v0.9.0发布。

20200902: 修正了MAX31865转换器的RTD电阻-温度计算无法为低的错误。如果你使用此芯片，请重新校准你的打印温度和PID设定。

20200816: G代码宏`printer.gcode`对象已被重命名为`printer.gcode_move`。删除了 `printer.toolhead` 和 `printer.gcode` 中几个没有文档的变量。参见 docs/Command_Templates.md 以获得可用的模板变量列表。

20200816: gcode宏 "action_"系统已经改变。请用`action_emergency_stop()`替换所有`printer.gcode.action_emergency_stop()` ，用`action_respond_info()`替换所有`printer.gcode.action_respond_info()`，用`action_raise_error()`替换所有`printer.gcode.action_respond_error()`。

20200809: 菜单系统已被重写。如果是定制菜单，那需要更新配置。配置细节见config/example-menu.cfg，例子见klippy/extras/display/menu.cfg。

20200731: `virtual_sdcard`打印机对象报告的`progress`属性的行为已经改变。当打印暂停时，进度不再被重置为0。现在它会始终根据已加载文件的读取位置来报告进度，如果当前没有加载文件，则报告0。

20200725: 移除了舵机`enable`配置参数和SET_SERVO`ENABLE`参数。请更新所有宏，用`SET_SERVO SERVO=my_servo WIDTH=0`来禁用舵机。

20200608: LCD显示支持部分改变了一些内部 "字形 "的名称。如果自定义了显示布局，可能需要更新到最新的字形名称（见klippy/extras/display/display.cfg中的可用字形列表）。

20200606: 改变了linux mcu上的引脚名称。现在引脚的名称格式是`gpiochip<chipid>/gpio<gpio>`。对于gpiochip0，你也可以使用`gpio<gpio>`的缩写。例如，以前名字为`P20'，现在变成`gpio20'或`gpiochip0/gpio20'。

20200603：默认的16x4 LCD布局将不再显示打印的预计剩余时间。(只显示已用时间。)如果需要旧的布局，可以用定制菜单显示该信息(详情见config/example-extras.cfg中display_data的描述)。

20200531: 默认的USB厂商/产品ID现在是0x1d50/0x614e。这个新ID是为Klipper保留的（感谢openmoko项目）。这个变化不需要改变任何配置，但新的ID可能会出现在系统日志中。

20200524：现在tmc5160的pwm_freq字段，默认值是0（而不是1）。

20200425: gcode_macro命令模板变量`printer.heater`改命名为`printer.heaters`。

20200313: 改变多挤出机打印机16x4屏幕的默认液晶屏布局。现在默认是单个挤出机屏幕布局，用于显示当前活动的挤出机。要使用以前的显示布局，请设置printer.cfg文件中[display]部分的 "display_group: _multiextruder_16x4"。

20200308：移除了默认的`__test`菜单项。如果配置文件中有自定义的菜单，那么请确保删除所有对这个`__test`菜单项的引用。

20200308: 移除了菜单中的 "desk "和 "card "选项。要定制lcd屏幕的布局，请使用新的display_data配置部分（详见config/example-extras.cfg）。

20200109: bed_mesh 模块现在引用探针的位置来进行网格配置。因此，一些配置选项已被重新命名以更准确地反映其功能。对于矩形床，`min_point'和`max_point`分别重新命名为`mesh_min`和`mesh_max`。对于圆形床，`bed_radius`重新命名为`mesh_radius`。对于圆形床，还增加了一个新的`mesh_origin`选项。请注意，这些变更与之前保存的网格配置文件不兼容。如果检测到一个不兼容的配置文件，此文件会被忽略并被删除。删除过程可以通过发出 SAVE_CONFIG 命令来完成。用户将需要重新校准每个床的网床配置。

20191218: 显示配置部分不再支持 "lcd_type: st7567"。请使用 "uc1701 "显示类型代替：设置 "lcd_type: uc1701 "，将 "rs_pin: some_pin "改为 "rst_pin: some_pin"。可能还需要增加一个 "contrast: 60"的配置设置。

20191210：删除了内置的T0、T1、T2...命令。移除了挤出机 activate_gcode 和 deactivate_gcode 配置选项。如果需要这些命令（和脚本），请定义单独的[gcode_macro T0]风格的宏，调用ACTIVATE_EXTRUDER命令。参见config/sample-idex.cfg和sample-multi-extruder.cfg文件中的例子。

20191210：移除了对M206命令的支持。用调用SET_GCODE_OFFSET来代替。如果需要对M206的支持，请添加一个[gcode_macro M206]配置部分，调用SET_GCODE_OFFSET。(例如 "SET_GCODE_OFFSET Z=-{params.Z}"。)

20191202：移除了对 "G4 "命令中无标注的 "S "参数的支持。用标准的 "P "参数（以毫秒为单位的延迟）取代任何出现的S。

20191126：改变了那些原生USB支持的微控制器上的USB名称。现在默认使用唯一的芯片ID（如果可用）。如果 "MCU "配置部分使用以"/dev/serial/by-id/"开头的 "串口 "设置，那么可能有必要更新配置。在ssh终端运行 "ls /dev/serial/by-id/*"来确定新的id。

20191121：移除了pressure_advance_lookahead_time参数。查看example.cfg以了解替代的配置设置。

20191112：如果步进驱动器没有专用的步进电机使能引脚，那么就会自动启用tmc步进驱动器的虚拟使能功能。从配置中删除对tmcXXXX:virtual_enable的引用。移除了在步进驱动器 enable_pin 配置中控制多个引脚的能力。如果需要控制多个引脚，请使用multi_pin 配置部分。

20191107：主挤出机配置部分必须指定为 "extruder"，不得再指定为 "extruder0"。查询挤出机状态的Gcode命令模板现在可以通过"{printer.extruder}"访问。

20191021: Klipper v0.8.0发布

20191003: [safe_z_homing] 中的 move_to_previous 选项现在默认为 False。(在20190918年之前，它实际上是False。)

20190918: [safe_z_homing]中的 zhop 选项总是在Z轴归位完成后重新应用。这可能需要用户更新基于此模块的自定义脚本。

20190806: SET_NEOPIXEL 命令已被重新命名为 SET_LED。

20190726：更改了mcp4728的数模转换代码。默认的i2c_address现在是0x60，电压参考现在是相对于mcp4728的内部2.048V参考源。

20190710: 删除了[firmware_retract]配置部分中的z_hop选项。由于对z_hop的支持不完整，可能会导致几个常见切片软件的异常行为。

20190710：改变了PROBE_ACCURACY命令的可选参数。如果宏或脚本使用了该命令，可能需要更新。

20190628：移除了[skew_correction]部分所有的配置选项。现在，对skew_correction的配置是通过SET_SKEW gcode完成的。推荐使用方法请参见[倾斜校正](Skew_Correction.md)。

20190607: gcode_macro 的 "variable_X "参数（以及 SET_GCODE_VARIABLE 的 VALUE 参数）现在被解析为 Python 字符。如果一个值需要分配成字符串型，那么用引号包裹该值以确保它被解析为一个字符串。

20190606: samples"、"samples_result "和 "samples_retract_dist "配置选项已被移至 "probe "配置部分。在 "delta_calibrate"、"bed_tilt"、"bed_mesh"、"screw_tilt_adjust"、"z_tilt "或 "quad_gantry_level "配置部分不再支持这些选项。

20190528：gcode_macro模板评估中的特殊 "status "变量已更名为 "printer"。

20190520: SET_GCODE_OFFSET命令已经改变，请相应地更新G代码宏。该命令将不再把要求的偏移量应用于下一个G1命令。旧的行为可以通过使用新的 "MOVE=1 "参数来近似实现。

20190404：Python主机软件包已经更新。用户需要重新运行~/klipper/scripts/install-octopi.sh脚本（如果不使用标准的OctoPi安装，则需要升级Python的依赖关系）。

20190404：现在i2c_bus和spi_bus参数（在各个配置部分）采用总线名称而不是数字。

20190404：变更了sx1509的配置参数。'address' 参数改名为 'i2c_address'且必须被指定为十进制数字。以前使用的是0x3E，现在则用62。

20190328：现在[temperature_fan]配置中的min_speed值将被使用，在PID模式下，风扇将始终以这个速度或更高的速度转动。

20190322: [tmc2660] 配置部分中 "driver_HEND "的默认值从6改为3。"driver_VSENSE "字段被删除（从run_current中自动计算的）。

20190310：现在[controller_fan]配置部分总是包含一个名字（例如[controller_fan my_controller_fan]）。

20190308：[tmc2130]和[tmc2208]配置部分中的 "driver_BLANK_TIME_SELECT "字段已被重新命名为 "driver_TBL"。

20190308：变更了[tmc2660]配置部分。现在必须提供一个新的sense_resistor配置参数。变更了几个driver_XXX参数的含义。

20190228: SAMD21板上的SPI或I2C现在必须通过[samd_sercom]配置部分指定总线引脚。

20190224: bed_shape选项已从bed_mesh中移除。半径（radius）选项已被重新命名为bed_radius。如果使用圆形床，需要提供bed_radius和round_probe_count选项。

20190107：变更了mcp4451配置部分的i2c_address参数。这是Smoothieboards上的一个常规设置。新值是旧值的一半（88应改为44，而90应改为45）。

20181220: Klipper v0.7.0发布
