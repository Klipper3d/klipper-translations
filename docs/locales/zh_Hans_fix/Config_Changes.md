# 配置更改

本文档涵盖了对配置文件最近进行的软件更改，这些更改不具备向后兼容性。在升级 Klipper 软件时，建议查阅本文档。

本文档中的所有日期均为近似日期。

## 更改

20250811：已移除 `[printer]` 配置部分中对 `max_accel_to_decel` 参数的支持，同时移除了 `SET_VELOCITY_LIMIT` 命令中对 `ACCEL_TO_DECEL` 参数的支持。这些功能已于 20240313 被弃用。

20250721：`[pca9632]` 和 `[mcp4018]` 模块不再接受 `scl_pin` 和 `sda_pin` 选项。请改用 `i2c_software_scl_pin` 和 `i2c_software_sda_pin`。

20250428：pwm `[output_pin]`、`[pwm_cycle_time]`、`[pwm_tool]` 及类似配置部分的最大 `cycle_time` 现在为 3 秒（从 5 秒减少）。`[pwm_tool]` 中的 `maximum_mcu_duration` 现在也为 3 秒。

20250418：manual_stepper 的 `STOP_ON_ENDSTOP` 功能现在可能需要更少的时间完成。之前，即使触发了限位开关，该命令也会等待整个移动可能需要的时间。现在，命令在限位开关触发后不久即完成。

20250417：使用“软件 SPI”的 SPI 设备现在受到速率限制。之前，配置中的 `spi_speed` 被忽略，传输速度仅受微控制器处理速度的限制。现在，速度受 `spi_speed` 配置参数限制（由于软件开销，实际硬件速度可能低于配置值）。

20250411：Klipper v0.13.0 发布。

20250308：已移除 `AXIS_TWIST_COMPENSATION_CALIBRATE` 命令的 `AUTO` 参数。

20250131：`SAVE_VARIABLE` 中的选项 `VARIABLE=<name>` 需要小写值。例如，使用 `extruder` 而不是大小写混合的 `Extruder` 或大写的 `EXTRUDER`。使用任何大写字母都会引发错误。

20241203：共振测试已更改，以包含缓慢扫频移动。此更改要求测试点在 X/Y 平面上有一定余量（使用默认设置时，测试点 +/- 30 mm 应足够）。新测试通常应产生更准确和可靠的测试结果。但是，如果需要，可以通过在 `[resonance_tester]` 配置部分中添加选项 `sweeping_period: 0` 和 `accel_per_hz: 75` 来恢复之前的测试行为。

20241201：在某些情况下，Klipper 可能忽略了传统 G 代码命令中的前导字符或空格。例如，“99M123”可能被解释为“M123”，而“M 321”可能被解释为“M321”。现在，Klipper 将报告这些情况并显示“未知命令”警告。

20241112：`TEST_RESONANCES` 和 `SHAPER_CALIBRATE` 中的选项 `CHIPS=<chip_name>` 需要指定加速度芯片的完整名称。例如，使用 `adxl345 rpi` 而不是简短名称 `rpi`。

20240912：`SET_PIN`、`SET_SERVO`、`SET_FAN_SPEED`、`M106` 和 `M107` 命令现在已合并。之前，如果对同一对象的多次更新比最小调度时间（通常为 100ms）更快，则实际更新可能会被排到很远的未来。现在，如果快速连续发出多次更新，则可能只应用最新的请求。如果需要之前的行为，请考虑在更新之间添加显式的 `G4` 延迟命令。

20240912：已移除 `[output_pin]` 配置部分中对 `maximum_mcu_duration` 和 `static_value` 参数的支持。这些选项自 20240123 起已被弃用。

20240415：`[virtual_sdcard]` 配置部分中的 `on_error_gcode` 参数现在有了默认值。如果未指定此参数，现在默认为 `TURN_OFF_HEATERS`。如果希望恢复之前的行为（在虚拟 sdcard 打印期间发生错误时不采取默认操作），请将 `on_error_gcode` 定义为空值。

20240313：`[printer]` 配置部分中的 `max_accel_to_decel` 参数已被弃用。`SET_VELOCITY_LIMIT` 命令的 `ACCEL_TO_DECEL` 参数已被弃用。`printer.toolhead.max_accel_to_decel` 状态已被移除。请改用 [minimum_cruise_ratio 参数](./Config_Reference.md#printer)。弃用的功能将在不久的将来被移除，在此期间使用它们可能会导致行为略有不同。

20240215：已移除多个已弃用的功能。已移除将“NTC 100K beta 3950”作为热敏电阻名称的用法（于 20211110 弃用）。已移除 `SYNC_STEPPER_TO_EXTRUDER` 和 `SET_EXTRUDER_STEP_DISTANCE` 命令，以及挤出机的 `shared_heater` 配置选项（于 20220210 弃用）。已移除 bed_mesh 的 `relative_reference_index` 选项（于 20230619 弃用）。

20240123：已移除 output_pin SET_PIN CYCLE_TIME 参数。如果需要动态更改 pwm 引脚的周期时间，请使用新的 [pwm_cycle_time](Config_Reference.md#pwm_cycle_time) 模块。

20240123：output_pin 的 `maximum_mcu_duration` 参数已被弃用。请改用 [pwm_tool 配置部分](Config_Reference.md#pwm_tool)。该选项将在不久的将来被移除。

20240123：output_pin 的 `static_value` 参数已被弃用。请替换为 `value` 和 `shutdown_value` 参数。该选项将在不久的将来被移除。

20231216：`[hall_filament_width_sensor]` 已更改为当耗材直径超过 `max_diameter` 时触发耗材耗尽。最大直径默认为 `default_nominal_filament_diameter + max_difference`。详情请参见 [[hall_filament_width_sensor] 配置参考](./Config_Reference.md#hall_filament_width_sensor)。

20231207：已移除 `[printer]` 配置部分中的几个未记录的配置参数（buffer_time_low、buffer_time_high、buffer_time_start 和 move_flush_time 参数）。

20231110：Klipper v0.12.0 发布。

20230826：如果在 `[dual_carriage]` 中将 `safe_distance` 设置或计算为 0，则将禁用车架的接近检查，如文档所述。用户可能希望显式配置 `safe_distance` 以防止车架之间意外碰撞。此外，在某些配置中（当两个车架在同一方向归位时的某些配置），主车架和双车架的归位顺序已更改。详情请参见 [[dual_carriage] 配置参考](./Config_Reference.md#dual_carriage)。

20230810：flash-sdcard.sh 脚本现在支持 Bigtreetech SKR-3 的两种变体，STM32H743 和 STM32H723。为此，原始的 btt-skr-3 标签现已更改为 btt-skr-3-h743 或 btt-skr-3-h723。

20230729：`dual_carriage` 的导出状态已更改。不再导出 `mode` 和 `active_carriage`，而是将每个车架的单独模式导出为 `printer.dual_carriage.carriage_0` 和 `printer.dual_carriage.carriage_1`。

20230619：`relative_reference_index` 选项已被弃用，并由 `zero_reference_position` 选项取代。有关如何更新配置的详细信息，请参阅 [Bed Mesh 文档](./Bed_Mesh.md#the-deprecated-relative_reference_index)。随着此弃用，`RELATIVE_REFERENCE_INDEX` 不再作为 `BED_MESH_CALIBRATE` gcode 命令的参数可用。

20230530：在“make menuconfig”中，默认的 canbus 频率现在为 1000000。如果使用 canbus 并需要使用其他频率，请确保在编译和刷新微控制器时，在“make menuconfig”中选择“启用额外的低级配置选项”并指定所需的“CAN 总线速度”。

20230525：如果 `[input_shaper]` 已启用，则 `SHAPER_CALIBRATE` 命令会立即应用输入整形参数。

20230407：日志和 `printer.mcu.last_stats` 字段中的 `stalled_bytes` 计数器已重命名为 `upcoming_bytes`。

20230323：在 tmc5160 驱动器上，`multistep_filt` 现在默认启用。如需之前的行为，请在 tmc5160 配置中设置 `driver_MULTISTEP_FILT: False`。

20230304：`SET_TMC_CURRENT` 命令现在会正确调整具有 globalscaler 寄存器的驱动器。这消除了之前在 tmc5160 上使用 `SET_TMC_CURRENT` 无法将电流提高到高于配置文件中 `run_current` 值的限制。然而，这有一个副作用：运行 `SET_TMC_CURRENT` 后，步进电机必须静止保持 >130ms，以便驱动器执行 AT#1 校准（如果使用 StealthChop2）。

20230202：`printer.screws_tilt_adjust` 状态信息的格式已更改。信息现在以螺丝字典形式存储，并附带相应的测量结果。详情请参阅 [状态参考](Status_Reference.md#screws_tilt_adjust)。

20230201：`[bed_mesh]` 模块在启动时不再加载 `default` 配置文件。建议使用 `default` 配置文件的用户在 `START_PRINT` 宏中添加 `BED_MESH_PROFILE LOAD=default`（或在适用时添加到切片软件的“启动 G 代码”配置中）。

20230103：现在可以使用 flash-sdcard.sh 脚本刷新 Bigtreetech SKR-2 的两种变体，STM32F407 和 STM32F429。这意味着原始的 btt-skr2 标签现在已更改为 btt-skr-2-f407 或 btt-skr-2-f429。

20221128：Klipper v0.11.0 发布。

20221122：之前，在 safe_z_home 的情况下，g28 归位后的 z_hop 可能会向负 Z 方向移动。现在，仅当 z_hop 产生正向跳跃时才会在 g28 归位后执行 z_hop，这与 g28 归位前发生的 z_hop 行为一致。

20220616：之前，可以通过运行 `make flash FLASH_DEVICE=first` 在引导模式下刷新 rp2040。等效的命令现在是 `make flash FLASH_DEVICE=2e8a:0003`。

20220612：rp2040 微控制器现在为“rp2040-e5”USB 问题提供了解决方案。这应使初始 USB 连接更可靠。但是，它可能会导致 gpio15 引脚行为发生变化。gpio15 行为的变化不太可能被注意到。

20220407：已移除 temperature_fan 的 `pid_integral_max` 配置选项（于 20210612 弃用）。

20220407：pca9632 LED 的默认颜色顺序现在为“RGBW”。要在 pca9632 配置部分中获得之前的行为，请添加显式的 `color_order: RBGW` 设置。

20220330：neopixel 和 dotstar 模块的 `printer.neopixel.color_data` 状态信息格式已更改。信息现在存储为颜色列表的列表（而不是字典列表）。详情请参阅 [状态参考](Status_Reference.md#led)。

20220307：如果缺少 `P`，`M73` 将不再将打印进度设置为 0。

20220304：`[extruder_stepper](Config_Reference.md#extruder_stepper)` 配置部分的 `extruder` 参数不再有默认值。如果需要，请显式指定 `extruder: extruder` 以在启动时将步进电机与“extruder”运动队列关联。

20220210：`SYNC_STEPPER_TO_EXTRUDER` 命令已被弃用；`SET_EXTRUDER_STEP_DISTANCE` 命令已被弃用；[extruder](Config_Reference.md#extruder) 的 `shared_heater` 配置选项已被弃用。这些功能将在不久的将来被移除。将 `SET_EXTRUDER_STEP_DISTANCE` 替换为 `SET_EXTRUDER_ROTATION_DISTANCE`。将 `SYNC_STEPPER_TO_EXTRUDER` 替换为 `SYNC_EXTRUDER_MOTION`。使用 `shared_heater` 的挤出机配置部分替换为 [extruder_stepper](Config_Reference.md#extruder_stepper) 配置部分，并更新任何激活宏以使用 [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion)。

20220116：tmc2130、tmc2208、tmc2209 和 tmc2660 的 `run_current` 计算代码已更改。对于某些 `run_current` 设置，驱动器现在可能会被配置得不同。这种新配置应该更准确，但它可能会使之前的 tmc 驱动器调校失效。

20211230：用于调校输入整形的脚本（`scripts/calibrate_shaper.py` 和 `scripts/graph_accelerometer.py`）已迁移到默认使用 Python3。因此，用户必须安装某些包的 Python3 版本（例如 `sudo apt install python3-numpy python3-matplotlib`）才能继续使用这些脚本。有关更多详细信息，请参阅 [软件安装](Measuring_Resonances.md#software-installation)。或者，用户可以通过在控制台中显式调用 Python2 解释器来暂时强制在 Python 2 下执行这些脚本：`python2 ~/klipper/scripts/calibrate_shaper.py ...`

20211110：已弃用“NTC 100K beta 3950”温度传感器。该传感器将在不久的将来被移除。大多数用户会发现“Generic 3950”温度传感器更准确。要继续使用较旧（通常不太准确）的定义，请使用 `temperature1: 25`、`resistance1: 100000` 和 `beta: 3950` 定义自定义 [热敏电阻](Config_Reference.md#thermistor)。

20211104：在“make menuconfig”中的“步进脉冲持续时间”选项已被移除。现在，配置为 UART 或 SPI 模式的 TMC 驱动器的默认步进持续时间为 100ns。应为所有需要自定义脉冲持续时间的步进电机在 [步进配置部分](Config_Reference.md#stepper) 中设置新的 `step_pulse_duration` 设置。

20211102：已移除多个已弃用的功能。已移除步进电机的 `step_distance` 选项（于 20201222 弃用）。已移除 `rpi_temperature` 传感器别名（于 20210219 弃用）。已移除 mcu 的 `pin_map` 选项（于 20210325 弃用）。已移除 gcode_macro 的 `default_parameter_<name>` 和通过 `params` 伪变量以外的方式访问命令参数的功能（于 20210503 弃用）。已移除加热器的 `pid_integral_max` 选项（于 20210612 弃用）。

20210929：Klipper v0.10.0 发布。

20210903：加热器的默认 [`smooth_time`](Config_Reference.md#extruder) 已更改为 1 秒（从 2 秒）。对于大多数打印机，这将实现更稳定的温度控制。

20210830：adxl345 的默认名称现在为“adxl345”。`ACCELEROMETER_MEASURE` 和 `ACCELEROMETER_QUERY` 的默认 CHIP 参数现在也为“adxl345”。

20210830：adxl345 的 ACCELEROMETER_MEASURE 命令不再支持 RATE 参数。要更改查询速率，请更新 printer.cfg 文件并发出 RESTART 命令。

20210821：`printer.configfile.settings` 中的几个配置设置现在将报告为列表而不是原始字符串。如果需要实际的原始字符串，请改用 `printer.configfile.config`。

20210819：在某些情况下，`G28` 归位移动可能以名义上超出有效移动范围的位置结束。在极少数情况下，这可能导致归位后出现令人困惑的“移动超出范围”错误。如果发生这种情况，请更改启动脚本，在归位后立即将打印头移动到有效位置。

20210814：atmega168 和 atmega328 上的模拟专用伪引脚已从 PE0/PE1 重命名为 PE2/PE3。

20210720：controller_fan 部分现在默认监控所有步进电机（而不仅仅是运动学步进电机）。如果需要之前的行为，请参阅 [配置参考](Config_Reference.md#controller_fan) 中的 `stepper` 配置选项。

20210703：`samd_sercom` 配置部分现在必须通过 `sercom` 选项指定其配置的 sercom 总线。

20210612：加热器和 temperature_fan 部分中的 `pid_integral_max` 配置选项已被弃用。该选项将在不久的将来被移除。

20210503：gcode_macro 的 `default_parameter_<name>` 配置选项已被弃用。使用 `params` 伪变量访问宏参数。访问宏参数的其他方法将在不久的将来被移除。大多数用户可以在宏的开头用类似以下的行替换 `default_parameter_NAME: VALUE` 配置选项：` {% set NAME = params.NAME|default(VALUE)|float %}`。示例请参阅 [命令模板文档](Command_Templates.md#macro-parameters)。

20210430：SET_VELOCITY_LIMIT（和 M204）命令现在可以设置比配置文件中指定值更大的速度、加速度和 square_corner_velocity。

20210325：`pin_map` 配置选项的支持已被弃用。使用 [sample-aliases.cfg](../config/sample-aliases.cfg) 文件转换为实际的微控制器引脚名称。`pin_map` 配置选项将在不久的将来被移除。

20210313：Klipper 对通过 CAN 总线通信的微控制器的支持已更改。如果使用 CAN 总线，则必须重新刷新所有微控制器，并 [更新 Klipper 配置](CANBUS.md)。

20210310：TMC2660 的 driver_SFILT 默认值已从 1 更改为 0。

20210227：现在，每当启用时，UART 或 SPI 模式的 TMC 步进电机驱动器会每秒查询一次 - 如果无法联系驱动器或驱动器报告错误，则 Klipper 将转换到关机状态。

20210219：`rpi_temperature` 模块已重命名为 `temperature_host`。将 `sensor_type: rpi_temperature` 的任何出现替换为 `sensor_type: temperature_host`。可以在 `sensor_path` 配置变量中指定温度文件的路径。`rpi_temperature` 名称已被弃用，并将在不久的将来被移除。

20210201：`TEST_RESONANCES` 命令现在将在之前启用时禁用输入整形（并在测试后重新启用）。要覆盖此行为并保持输入整形启用，可以向命令传递附加参数 `INPUT_SHAPING=1`。

20210201：如果在 printer.cfg 的相应 adxl345 部分中为加速度计芯片命名，则 `ACCELEROMETER_MEASURE` 命令现在会将加速度计芯片的名称追加到输出文件名中。

20201222：步进电机配置部分中的 `step_distance` 设置已被弃用。建议更新配置以使用 [`rotation_distance`](Rotation_Distance.md) 设置。对 `step_distance` 的支持将在不久的将来被移除。

20201218：endstop_phase 模块中的 `endstop_phase` 设置已被 `trigger_phase` 取代。如果使用 endstop phases 模块，则必须转换为 [`rotation_distance`](Rotation_Distance.md) 并通过运行 ENDSTOP_PHASE_CALIBRATE 命令重新校准任何 endstop phases。

20201218：旋转三角洲和极坐标打印机现在必须为其旋转步进电机指定 `gear_ratio`，并且不能再指定 `step_distance` 参数。有关新 gear_ratio 参数格式的详细信息，请参阅 [配置参考](Config_Reference.md#stepper)。

20201213：在使用“probe:z_virtual_endstop”时，指定 Z 的“position_endstop”无效。现在，如果在“probe:z_virtual_endstop”中指定了 Z 的“position_endstop”，将引发错误。删除 Z 的“position_endstop”定义以修复错误。

20201120：`[board_pins]` 配置部分现在在显式的 `mcu:` 参数中指定 mcu 名称。如果为辅助 mcu 使用 board_pins，则必须更新配置以指定该名称。有关更多详细信息，请参阅 [配置参考](Config_Reference.md#board_pins)。

20201112：`print_stats.print_duration` 报告的时间已更改。现在排除首次检测到挤出之前的时间。

20201029：neopixel 的 `color_order_GRB` 配置选项已被移除。如有必要，请更新配置以将新的 `color_order` 选项设置为 RGB、GRB、RGBW 或 GRBW。

20201029：mcu 配置部分中的串行选项不再默认为 /dev/ttyS0。在 /dev/ttyS0 是所需串行端口的罕见情况下，必须显式指定。

20200816：gcode 宏 `printer.gcode` 对象已重命名为 `printer.gcode_move`。已移除 `printer.toolhead` 和 `printer.gcode` 中的几个未记录的变量。可用模板变量列表请参阅 docs/Command_Templates.md。

20200816：gcode 宏 "action_" 系统已更改。将 `printer.gcode.action_emergency_stop()` 的任何调用替换为 `action_emergency_stop()`，将 `printer.gcode.action_respond_info()` 替换为 `action_respond_info()`，将 `printer.gcode.action_respond_error()` 替换为 `action_raise_error()`。

20200809：菜单系统已重写。如果菜单已自定义，则必须更新为新配置。配置详情请参阅 config/example-menu.cfg，示例请参阅 klippy/extras/display/menu.cfg。

20200731：`virtual_sdcard` 打印机对象报告的 `progress` 属性的行为已更改。暂停打印时，进度不再重置为 0。现在，它将始终根据内部文件位置报告进度，如果没有加载文件，则报告为 0。

20200725：已移除伺服的 `enable` 配置参数和 SET_SERVO 的 `ENABLE` 参数。更新任何宏以使用 `SET_SERVO SERVO=my_servo WIDTH=0` 来禁用伺服。

20200608：LCD 显示支持更改了一些内部“字形”的名称。如果实现了自定义显示布局，可能需要更新为最新的字形名称（可用字形列表请参阅 klippy/extras/display/display.cfg）。

20200606：linux mcu 上的引脚名称已更改。引脚现在的名称形式为 `gpiochip<chipid>/gpio<gpio>`。对于 gpiochip0，您也可以使用简短的 `gpio<gpio>`。例如，之前称为 `P20` 的现在变为 `gpio20` 或 `gpiochip0/gpio20`。

20200603：默认的 16x4 LCD 布局将不再显示打印的剩余估计时间。（仅显示经过的时间。）如果需要旧的行为，可以使用该信息自定义菜单显示（详情请参阅 config/example-extras.cfg 中 display_data 的描述）。

20200531：默认的 USB 供应商/产品 ID 现在为 0x1d50/0x614e。这些新 ID 保留给 Klipper（感谢 openmoko 项目）。此更改不需要任何配置更改，但新 ID 可能会出现在系统日志中。

20200524：tmc5160 pwm_freq 字段的默认值现在为零（而不是一）。

20200425：gcode_macro 命令模板变量 `printer.heater` 已重命名为 `printer.heaters`。

20200313：带 16x4 屏幕的多挤出机打印机的默认 lcd 布局已更改。现在默认为单挤出机屏幕布局，并将显示当前激活的挤出机。要使用之前的显示布局，请在 printer.cfg 文件的 [display] 部分中设置“display_group: _multiextruder_16x4”。

20200308：已移除默认的 `__test` 菜单项。如果配置文件有自定义菜单，请确保移除对此 `__test` 菜单项的所有引用。

20200308：菜单的“deck”和“card”选项已被移除。要自定义 lcd 屏幕的布局，请使用新的 display_data 配置部分（详情请参阅 config/example-extras.cfg）。

20200109：bed_mesh 模块现在引用探头位置进行网格配置。因此，一些配置选项已重命名以更准确地反映其预期功能。对于矩形床，`min_point` 和 `max_point` 分别重命名为 `mesh_min` 和 `mesh_max`。对于圆形床，`bed_radius` 已重命名为 `mesh_radius`。圆形床还添加了新的 `mesh_origin` 选项。请注意，这些更改与之前保存的网格配置文件不兼容。如果检测到不兼容的配置文件，将忽略并计划删除。可以通过发出 SAVE_CONFIG 命令完成删除过程。用户需要重新校准每个配置文件。

20191218：display 配置部分不再支持“lcd_type: st7567”。请改用“uc1701”显示类型 - 设置“lcd_type: uc1701”并将“rs_pin: some_pin”更改为“rst_pin: some_pin”。可能还需要添加“contrast: 60”配置设置。

20191210：已移除内置的 T0、T1、T2、... 命令。已移除挤出机 activate_gcode 和 deactivate_gcode 配置选项。如果需要这些命令（和脚本），请定义调用 ACTIVATE_EXTRUDER 命令的单个 [gcode_macro T0] 风格宏。示例请参阅 config/sample-idex.cfg 和 sample-multi-extruder.cfg 文件。

20191210：已移除对 M206 命令的支持。请替换为对 SET_GCODE_OFFSET 的调用。如果需要 M206 支持，请添加调用 SET_GCODE_OFFSET 的 [gcode_macro M206] 配置部分。（例如“SET_GCODE_OFFSET Z=-{params.Z}”。）

20191202：已移除对“G4”命令的未记录“S”参数的支持。将任何 S 替换为标准的“P”参数（以毫秒为单位的延迟）。

20191126：具有原生 USB 支持的微控制器上的 USB 名称已更改。它们现在默认使用唯一的芯片 ID（如果可用）。如果“mcu”配置部分使用以“/dev/serial/by-id/”开头的“serial”设置，则可能需要更新配置。在 ssh 终端中运行“ls /dev/serial/by-id/*”以确定新 ID。

20191121：已移除 pressure_advance_lookahead_time 参数。有关替代配置设置，请参阅 example.cfg。

20191112：如果步进电机没有专用的步进电机使能引脚，则现在会自动启用 TMC 步进电机驱动器的虚拟使能功能。从配置中移除对 tmcXXXX:virtual_enable 的引用。已移除在步进电机 enable_pin 配置中控制多个引脚的功能。如果需要多个引脚，请使用 multi_pin 配置部分。

20191107：主挤出机配置部分必须指定为“extruder”，不能再指定为“extruder0”。查询挤出机状态的 G 代码命令模板现在通过“{printer.extruder}”访问。

20191021：Klipper v0.8.0 发布

20191003：[safe_z_homing] 中的 move_to_previous 选项现在默认为 False。（在 20190918 之前实际上为 False。）

20190918：[safe_z_homing] 中的 zhop 选项在 Z 轴归位完成后总是重新应用。这可能需要用户根据此模块更新自定义脚本。

20190806：SET_NEOPIXEL 命令已重命名为 SET_LED。

20190726：mcp4728 数模转换代码已更改。默认 i2c_address 现在为 0x60，电压参考现在相对于 mcp4728 的内部 2.048 伏参考。

20190710：[firmware_retract] 配置部分中已移除 z_hop 选项。z_hop 支持不完整，可能会与几个常用切片软件产生不正确的行为。

20190710：PROBE_ACCURACY 命令的可选参数已更改。可能需要更新使用该命令的任何宏或脚本。

20190628：[skew_correction] 部分中的所有配置选项已被移除。现在通过 SET_SKEW gcode 进行 skew_correction 的配置。有关推荐用法，请参阅 [Skew Correction](Skew_Correction.md)。

20190607：gcode_macro 的“variable_X”参数（以及 SET_GCODE_VARIABLE 的 VALUE 参数）现在被解析为 Python 字面量。如果需要为值分配字符串，请用引号将值括起来，以便将其评估为字符串。

20190606：“samples”、“samples_result”和“sample_retract_dist”配置选项已移至“probe”配置部分。这些选项不再支持在“delta_calibrate”、“bed_tilt”、“bed_mesh”、“screws_tilt_adjust”、“z_tilt”或“quad_gantry_level”配置部分中使用。

20190528：gcode_macro 模板评估中的魔术“status”变量已重命名为“printer”。

20190520：SET_GCODE_OFFSET 命令已更改；相应地更新任何 G 代码宏。该命令将不再将请求的偏移应用于下一个 G1 命令。可以通过使用新的“MOVE=1”参数来近似旧的行为。

20190404：Python 主机软件包已更新。用户需要重新运行 ~/klipper/scripts/install-octopi.sh 脚本（或如果不是标准 OctoPi 安装，则以其他方式升级 Python 依赖项）。

20190404：各种配置部分中的 i2c_bus 和 spi_bus 参数现在取总线名称而不是数字。

20190404：sx1509 配置参数已更改。“address”参数现在为“i2c_address”，并且必须指定为十进制数。之前使用 0x3E 的地方，现在指定为 62。

20190328：现在将尊重 [temperature_fan] 配置中的 min_speed 值，并且风扇在 PID 模式下将始终以该速度或更高速度运行。

20190322：[tmc2660] 配置部分中“driver_HEND”的默认值已从 6 更改为 3。“driver_VSENSE”字段已被移除（现在从 run_current 自动计算）。

20190310：[controller_fan] 配置部分现在始终需要一个名称（例如 [controller_fan my_controller_fan]）。

20190308：[tmc2130] 和 [tmc2208] 配置部分中的“driver_BLANK_TIME_SELECT”字段已重命名为“driver_TBL”。

20190308：[tmc2660] 配置部分已更改。现在必须提供新的 sense_resistor 配置参数。几个 driver_XXX 参数的含义已更改。

20190228：使用 SAMD21 板上的 SPI 或 I2C 的用户现在必须通过 [samd_sercom] 配置部分指定总线引脚。

20190224：已从 bed_mesh 中移除 bed_shape 选项。radius 选项已重命名为 bed_radius。圆形床的用户应提供 bed_radius 和 round_probe_count 选项。

20190107：mcp4451 配置部分中的 i2c_address 参数已更改。这是 Smoothieboards 上的常见设置。新值是旧值的一半（88 应更改为 44，90 应更改为 45）。

20181220：Klipper v0.7.0 发布