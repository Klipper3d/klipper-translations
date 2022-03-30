# 版本发布

Klipper版本发布。如何安装Klipper ，请查看[installation](Installation.md)。

## Klipper 0.10.0

Available on 20210929. Major changes in this release:

* Support for "Multi-MCU Homing". It is now possible for a stepper motor and its endstop to be wired to separate micro-controllers. This simplifies wiring of Z probes on "toolhead boards".
* Klipper now has a [Community Discord Server](https://discord.klipper3d.org) and a [Community Discourse Server](https://community.klipper3d.org).
* The [Klipper website](https://www.klipper3d.org) now uses the "mkdocs" infrastructure. There is also a [Klipper Translations](https://github.com/Klipper3d/klipper-translations) project.
* Automated support for flashing firmware via sdcard on many boards.
* New kinematic support for "Hybrid CoreXY" and "Hybrid CoreXZ" printers.
* Klipper now uses `rotation_distance` to configure stepper motor travel distances.
* The main Klipper host code can now directly communicate with micro-controllers using CAN bus.
* New "motion analysis" system. Klipper's internal motion updates and sensor results can be tracked and logged for analysis.
* Trinamic stepper motor drivers are now continuously monitored for error conditions.
* Support for the rp2040 micro-controller (Raspberry Pi Pico boards).
* The "make menuconfig" system now utilizes kconfiglib.
* Many additional modules added: ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu
* 几个错误的修复和代码的清理。

## Klipper 0.9.0

发布于2020年10月20日，此版本更新内容:

* 支持使用“Input Shaping”功能 - 此功能主要作用是抵消打印机共振。它可以减少甚至消除打印中产生的“ringing”振纹。
* “Smooth Pressure Advance”全新的挤出算法机制。这实现了“Pressure Advance”(打印挤出）同时不会引起挤出速度瞬间的改变，相反会变得更加平滑。现在也可以使用“Tuning Tower”方法来调整“Pressure Advance”(打印挤出）。
* “webhooks”全新的API 服务器。 这次 Klipper 添加了可编程的 JSON 接口。
* 现在可以使用 Jinja2 模板语言配置 LCD 显示和菜单。
* 现在TMC2208 步进电机驱动器可以在 Klipper系统中 使用“standalone”模式。
* 支持并优化使用BL-Touch v3 。
* 改进了USB识别。Klipper现在有自己的USB识别代码，微控制器现在可以在USB识别期间报告其唯一的序列号。
* 对 "Rotary Delta "和 "CoreXZ "打印机的新运动学支持。
* 微控制器的改进：支持stm32f070，支持stm32f207，支持 "Linux MCU "的GPIO引脚，支持stm32 "HID启动引导程序"，支持Chitu启动引导程序，支持MKS Robin启动引导程序。
* 改进了对Python "垃圾收集 "事件的处理。
* 增加了许多额外的模块：adc_scaled, adxl345, bme280, display_status, extruder_stepper, fan_generic, hall_filament_width_sensor, htu21d, homing_heaters, input_shaper, lm75, print_stats, resonance_tester, shaper_calibrate, query_adc, graph_accelerometer, graph_extruder, graph_motion, graph_shaper, graph_temp_sensor, whconsole
* 几个错误的修复和代码的清理。

### Klipper 0.9.1

在20201028发布。只包含错误修复。

## Klipper 0.8.0

在20191021年发布。此版本的主要变化：

* 新的G-Code命令模板支持。配置文件中的G-Code现在可以用Jinja2模板语言进行编写。
* 对Trinamic步进驱动器的改进：
   * 新增对TMC2209和TMC5160驱动器的支持。
   * 改进了 DUMP_TMC、SET_TMC_CURRENT 和 INIT_TMC G-Code 命令。
   * 通过模拟一个多路复用器改进了对 TMC UART 处理的支持。
* 改进了对归位、探测和床位平整的支持：
   * 新增 manual_probe, bed_screws, screws_tilt_adjust, skew_correction, safe_z_home 模块。
   * 通过使用中位数、平均值和重试逻辑改进了多样本探测。
   * 改进了 BL-Touch、探针校准、限位校准、三角洲校准、无传感器归位和限位相位校准的文档。
   * 改进了长 Z 轴上的归位支持。
* 许多 Klipper 微控制器改进：
   * Klipper 被移植到：sam3x8c、sam4s8c、samd51、stm32f042和stm32f4
   * SAM3X、SAM4、STM32F4 上现在的使用了一个人新的 USB CDC 驱动程序实现。
   * 改进了对通过 USB 刷写 Klipper 的支持。
   * 支持软件 SPI。
   * 大大改善了 LPC176x 的温度滤波。
   * 可以在微控制器中配置初始引脚输出。
* Klipper 文档的新网站：http://klipper3d.org/
   * Klipper 现在有了一个标志。
* 对polar和"cable winch"运动学的实验性支持。
* 配置文件现在可以包括其他配置文件。
* 添加了许多新的模块：board_pins，controller_fan，delayed_gcode，dotstar，filament_switch_sensor，firmware_retraction，gcode_arcs，gcode_button，heater_generic，manual_stepper，mcp4018，mcp4728，neopixel，pause_resume，响应，temperature_sensor tsl1401cl_filament_width_sensor，tuning_tower
* 增加了许多命令：RESTORE_GCODE_STATE、SAVE_GCODE_STATE、SET_GCODE_VARIABLE、SET_HEATER_TEMPERATURE、SET_IDLE_TIMEOUT SET_TEMPERATURE_FAN_TARGET
* 几个错误的修复和代码的清理。

## Klipper 0.7.0

发布于2018年12月20日，此版本更新内容:

* Klipper 现在支持“网状”打印床调平
* 新增对“增强”三角洲校准的支持（校准三角洲打印机上的打印 x/y 尺寸）
* 支持运行时配置 Trinamic 步进电机驱动（tmc2130, tmc2208, tmc2660）
* 改进的温度传感器支持：MAX6675、MAX31855、MAX31856、MAX31865、定制热敏电阻、common pt100类传感器
* 几个新模块：temperature_fan, sx1509, force_move, mcp4451, z_tilt, quad_gantry_level, endstop_phase, bltouch
* 添加了几个新命令：SAVE_CONFIG、SET_PRESSURE_ADVANCE、SET_GCODE_OFFSET、SET_VELOCITY_LIMIT、STEPPER_BUZZ、TURN_OFF_HEATERS、M204、自定义G代码宏
* 扩展 LCD 显示支持：
   * Support for run-time menus
   * 新的显示屏图标
   * 对“uc1701”和“ssd1306”显示器的支持
* 支持更多的微控制器：
   * Klipper被移植到：LPC176x (Smoothieboards), SAM4E8E (Duet2), SAMD21 (Arduino Zero), STM32F103 ("Blue pill" devices), atmega32u4
   * 在AVR、LPC176x、SAMD21和STM32F103上实现了新的通用USB CDC驱动程序
   * 改善了在ARM处理器上运行时的性能
* 运动学代码被重写为使用"迭代求解器"
* 适用于 Klipper 主机软件的新自动测试用例
* 为常见的商品打印机提供了许多新的配置文件范例
* 更新了引导加载程序、基准测试、微控制器移植、配置检查、引脚映射、切片设置、打包等的文档
* 修复了几个错误并整理了代码

## Klipper 0.6.0

发布于2018年3月31日。此版本的重要变化：

* 改进了加热器和热敏电阻硬件故障检查
* 支持 Z 探针
* 初步支持对三角洲的自动参数校准（通过一个新的delta_calibrate命令）
* 最初支持打印床倾斜补偿（通过bed_tilt_calibrate命令）
* 初步支持 "安全归位 "和归位重写
* Initial support for displaying status on RepRapDiscount style 2004 and 12864 displays
* New multi-extruder improvements:
   * Support for shared heaters
   * Initial support for dual carriages
* Support for configuring multiple steppers per axis (eg, dual Z)
* Support for custom digital and pwm output pins (with a new SET_PIN command)
* Initial support for a "virtual sdcard" that allows printing directly from Klipper (helps on machines too slow to run OctoPrint well)
* Support for setting different arm lengths on each tower of a delta
* Support for G-Code M220/M221 commands (speed factor override / extrude factor override)
* Several documentation updates:
   * 为常见的商品打印机提供了许多新的配置文件范例
   * New multiple MCU config example
   * New bltouch sensor config example
   * New FAQ, config check, and G-Code documents
* Initial support for continuous integration testing on all github commits
* 修复了几个错误并整理了代码

## Klipper 0.5.0

Available on 20171025. Major changes in this release:

* Support for printers with multiple extruders.
* Initial support for running on the Beaglebone PRU. Initial support for the Replicape board.
* Initial support for running the micro-controller code in a real-time Linux process.
* Support for multiple micro-controllers. (For example, one could control an extruder with one micro-controller and the rest of the printer with another.) Software clock synchronization is implemented to coordinate actions between micro-controllers.
* Stepper performance improvements (20Mhz AVRs up to 189K steps per second).
* Support for controlling servos and support for defining nozzle cooling fans.
* 修复了几个错误并整理了代码

## Klipper 0.4.0

Available on 20170503. Major changes in this release:

* Improved installation on Raspberry Pi machines. Most of the install is now scripted.
* Support for corexy kinematics
* Documentation updates: New Kinematics document, new Pressure Advance tuning guide, new example config files, and more
* Stepper performance improvements (20Mhz AVRs over 175K steps per second, Arduino Due over 460K)
* Support for automatic micro-controller resets. Support for resets via toggling USB power on Raspberry Pi.
* The pressure advance algorithm now works with look-ahead to reduce pressure changes during cornering.
* Support for limiting the top speed of short zigzag moves
* Support for AD595 sensors
* 修复了几个错误并整理了代码

## Klipper 0.3.0

Available on 20161223. Major changes in this release:

* Improved documentation
* Support for robots with delta kinematics
* Support for Arduino Due micro-controller (ARM cortex-M3)
* Support for USB based AVR micro-controllers
* Support for "pressure advance" algorithm - it reduces ooze during prints.
* New "stepper phased based endstop" feature - enables higher precision on endstop homing.
* Support for "extended g-code" commands such as "help", "restart", and "status".
* Support for reloading the Klipper config and restarting the host software by issuing a "restart" command from the terminal.
* Stepper performance improvements (20Mhz AVRs up to 158K steps per second).
* Improved error reporting. Most errors now shown via the terminal along with help on how to resolve.
* 修复了几个错误并整理了代码

## Klipper 0.2.0

Initial release of Klipper. Available on 20160525. Major features available in the initial release include:

* Basic support for cartesian printers (steppers, extruder, heated bed, cooling fan).
* Support for common g-code commands. Support for interfacing with OctoPrint.
* Acceleration and lookahead handling
* Support for AVR micro-controllers via standard serial ports
