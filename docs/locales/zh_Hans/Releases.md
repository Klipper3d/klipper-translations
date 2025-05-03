# 发行说明

Klipper版本发布。如何安装Klipper ，请查看[installation](Installation.md)。

## Klipper 0.13.0

Available on 20250411. Major changes in this release:

* New "sweeping vibrations" resonance testing mechanism for input shaper.
* Fans and GPIO pins can now be assigned a formula (via Jinja2 "templates").
* The bed_mesh code now supports "adaptive bed mesh". The area probed can be adjusted for the size of the print.
* A new `minimum_cruise_ratio` kinematic parameter has been added (it replaces the previous `max_accel_to_decel` parameter).
* Several new sensors added:
   * Support for ldc1612 "eddy" current sensors. This includes probing support, fast "scan" probing, and temperature calibration.
   * New support for "load cell" measurements. Support for connecting these load cells to hx71x and ads1220 ADC sensors.
   * Support for BMP180, BMP388, and SHT3x temperature sensors. Support for measuring temperature with ADS1x1x ADC chips.
   * New lis3dh and icm20948 accelerometer support.
   * Support for mt6816 and mt6826s "hall angle" sensors.
* New micro-controller improvements:
   * New support for rp2350 micro-controllers.
   * Existing rp2040 chips now run at 200MHz (up from 125Mhz).
   * The micro-controller code can now define many more commands (up to 16384 from 128).
* Other modules added: aip31068_spi, canbus_stats, error_mcu, garbage_collection, pwm_cycle_time, pwm_tool, garbage_collection.
* 几个错误的修复和代码的清理。

## Klipper 0.12.0

Available on 20231110. Major changes in this release:

* Support for COPY and MIRROR modes on IDEX printers.
* Several micro-controller improvements:
   * Support for new ar100 and hc32f460 architectures.
   * Support for stm32f7, stm32g0b0, stm32g07x, stm32g4, stm32h723, n32g45x, samc21, and samd21j18 chip variants.
   * Improved DFU and Katapult reboot handling.
   * Improved performance on USB to CANbus bridge mode.
   * Improved performance on "linux mcu".
   * New support for software based i2c.
* New hardware support for tmc2240 stepper motor drivers, lis2dw12 accelerometers, and aht10 temperature sensors.
* New axis_twist_compensation and temperature_combined modules added.
* New support for gcode arcs in XY, XZ, and YZ planes.
* 几个错误的修复和代码的清理。

## Klipper 0.11.0

发布于2022年11月28日。此版本的主要更新：

* 优化了Trinamic驱动的 "step on both edges"功能。
* 添加对Python3的支持。现在Klipper Host 的代码可以运行在Python2 或 Python3中。
* 改进了CAN Bus 支持。在rp2040 stm32g0 stm32h7 same51 以及 same54 芯片上支持了CAN Bus。并支持了"USB to CAN bus bridge" 模式。
* 添加了对CanBoot bootloader的支持。
* 添加了对mpu9250以及mpu6050 加速度计的支持。
* 改进了对温度传感器max31856 max31855 max31865 max6675的错误处理。
* 现在可以使用LED“模板”支持将LED配置为在长时间运行G-Code命令期间更新。
* 多项微控制器改进。 新增对 stm32h743 stm32h750 stm32l412 stm32g0b1 same70 same51 same54 芯片的支持。在 atsamd 和 stm32f0 上支持 i2c 读取。在 stm32 上支持硬件 pwm。基于 Linux mcu 信号的事件分派。 新的 rp2040 支持 "make flash" i2c 以及 rp2040-e5 USB 勘误。
* 新增模块：ANGLE、DAC084S085、EXCLUDE_OBJECT、LED、mpu9250、pca9632、SMART_EFECTOR、Z_HEARTER_ADJUST。添加了新的Deltesian运动学。添加了新的Dump_MCU工具。
* 几个错误的修复和代码的清理。

## Klipper 0.10.0

发布于2021年9月29日。此版本主要更新：

* 支持“多微控制器归位”。现在可以将步进电机和限位连接到单独的微控制器上。此举简化了“工具板”上的Z探头的接线。
* klipper 现在有[社区Discord 服务器](https://discord.klipper3d.org)和[社区论坛](https://community.klipper3d.org).
* [Klipper官网](https://www.klipper3d.org)现在使用“mkdocs”基础架构。还有一个[翻译Klipper](https://github.com/Klipper3d/klipper-translations)项目。
* 在许多开发板上通过sdcard自动更新固件。
* 添加了新的运动学"Hybrid CoreXY"和"Hybrid CoreXZ"的打印机支持。
* Klipper 现在使用`rotation_distance`来配置步进电机的行程距离。
* Klipper上位机现在可以使用CAN总线与微控制器进行通信。
* 新的“运动分析”系统。可以追踪和记录Klipper内部的运动更新和传感器结果以供分析。
* Trinamic步进电机驱动现在可以连续监控错误情况。
* 添加了对RP2040 MCU的支持（Raspberry Pi Pico）。
* "make menuconfig"系统现在使用 kconfiglib。
* 添加了许多附加模块：ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu
* 几个错误的修复和代码的清理。

## Klipper 0.9.0

发布于2020年10月20日，此版本更新内容:

* 支持使用“输入整形”功能 - 此功能主要作用是抵消打印机共振。它可以减少甚至消除打印中产生的“ringing”振纹。
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
   * 支持实时菜单
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
* 初步支持在RepRapDiscount 样式的2004和12864屏幕上显示状态（STATUS）
* 全新多挤出机改进：
   * 支持共享加热头（二合一或者多合一模式）
   * 对于双步进模式的初步支持
* 支持为每个轴配置多个步进电机（例如：双Z）
* 支持自定义数字和PWM输出引脚（使用新的 SET_PIN 命令）
* 初步支持Klipper从“虚拟SDCard”直接开始打印（有助于在由于机器速度太慢而无法运行OctoPrint的情况）
* 支持在三角洲机型上每个柱上设置不同的打印臂长度
* 支持 G-Code M220/M221 指令（运行速度系数/运行挤出系数）
* 几个文档更新：
   * 为常见的商品打印机提供了许多新的配置文件范例
   * 新增多微控制器配置示例
   * 新增bltouch传感器配置示例
   * 新的常见问题，配置检查和G-Code文档
* 初步支持所有github提交的持续集成测试
* 修复了几个错误并整理了代码

## Klipper 0.5.0

发布于2017年10月25日。此版本的主要更新：

* 支持拥有多个挤出机的打印机。
* 初步支持在Beaglebone 可编程实时单元上运行。初步支持其复制板。
* 初步支持在实时Linux进程中运行微控制器代码。
* 支持多个微控制器。（例如，可以在一个微控制器控制挤出机，而用另外一个微控制器控制打印机的其他部分）实现软件时钟同步用来协调微控制器之间的动作。
* 步进器性能提升（20Mhz AVR单片机可提升至每秒189千步）。
* 支持控制舵机，支持自定义喷嘴冷却风扇。
* 修复了几个错误并整理了代码

## Klipper 0.4.0

发布于2017年5月3日。此版本主要更新：

* 改进树莓派机器上的安装。现在大部分安装都是脚本化方式执行。
* 支持CoreXY运动学机型
* 文档更新：全新运动学文档，全新压力提前调整指南，全新示例配置文件等
* 步进器性能改进（20Mhz的AVR单片机每秒超过175千步，Arduino Due超过460千步）
* 支持自动微控制器复位。支持在树莓派上切换USB电源进行重置。
* 压力提前算法现在与前瞻（look-ahead）算法一起使用，以减少转弯过程中的压力变化。
* 支持限制短之字形移动的最高速度
* 支持了AD595 传感器
* 修复了几个错误并整理了代码

## Klipper 0.3.0

发布于2016年12月23日。此版本的主要更新：

* 改进文档
* 支持delta运动学的机器
* 添加了Arduino Due MCU (ARM cortex-M3)的支持
* 添加了对USB based 的AVR MCU 支持
* 添加了对"pressure advance"算法的支持 - 以减少打印过程中的溢出。
* 添加了"stepper phased based endstop"特性 - 以获得更高的限位精度。
* 添加了对"extended g-code"的支持，例如"help" "restart"和 "status"。
* 支持重新加载 Klipper 配置，并通过终端发出 "restart"命令重启主机软件。
* 步进电机性能提升（20Mhz AVRs 可以到达158K steps 每秒）。
* 改善了报错。绝大多数错误会在终端中显示并且有解决方法。
* 修复了几个错误并整理了代码

## Klipper 0.2.0

Klipper的最初版本。发布于2016年5月25日。初始版本中提供的主要功能包括：

* 对于笛卡尔打印机（步进电机、挤出机、热床、冷却风扇）的初步支持。
* 支持常见的G-Code命令。支持OctoPrint的接口。
* 加速和前瞻处理
* 通过标准串行接口支持AVR微控制器
