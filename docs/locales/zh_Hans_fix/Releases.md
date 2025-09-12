# 发布记录

Klipper 的发布历史。有关安装 Klipper 的信息，请参阅
[安装指南](Installation.md)。

## Klipper 0.13.0

发布于 2025年4月11日。此版本的主要变更：
* 为输入整形器新增“扫频振动”共振测试机制。
* 风扇和 GPIO 引脚现在可以分配一个公式（通过 Jinja2 “模板”）。
* `bed_mesh` 代码现在支持“自适应床网”。探测区域可根据打印尺寸进行调整。
* 新增了一个新的运动学参数 `minimum_cruise_ratio`（它取代了之前的 `max_accel_to_decel` 参数）。
* 新增了多种传感器支持：
  * 支持 ldc1612 “涡流”传感器。包括探测支持、快速“扫描”探测和温度校准。
  * 新增对“称重传感器”测量的支持。支持将这些称重传感器连接到 hx71x 和 ads1220 ADC 传感器。
  * 支持 BMP180、BMP388 和 SHT3x 温度传感器。支持使用 ADS1x1x ADC 芯片测量温度。
  * 新增对 lis3dh 和 icm20948 加速度计的支持。
  * 支持 mt6816 和 mt6826s “霍尔角度”传感器。
* 新的微控制器改进：
  * 新增对 rp2350 微控制器的支持。
  * 现有的 rp2040 芯片现在以 200MHz 运行（之前为 125MHz）。
  * 微控制器代码现在可以定义更多的命令（从 128 个增加到 16384 个）。
* 新增了其他模块：aip31068_spi、canbus_stats、error_mcu、garbage_collection、pwm_cycle_time、pwm_tool、garbage_collection。
* 多项错误修复和代码清理。

## Klipper 0.12.0

发布于 2023年11月10日。此版本的主要变更：
* 支持 IDEX 打印机的 COPY（复制）和 MIRROR（镜像）模式。
* 多项微控制器改进：
  * 支持新的 ar100 和 hc32f460 架构。
  * 支持 stm32f7、stm32g0b0、stm32g07x、stm32g4、stm32h723、n32g45x、samc21 和 samd21j18 芯片变体。
  * 改进了 DFU 和 Katapult 的重启处理。
  * 改进了 USB 转 CAN 总线桥接模式的性能。
  * 改进了“linux mcu”上的性能。
  * 新增对基于软件的 i2c 的支持。
* 新增对 tmc2240 步进电机驱动器、lis2dw12 加速度计和 aht10 温度传感器的硬件支持。
* 新增了 axis_twist_compensation 和 temperature_combined 模块。
* 新增对 XY、XZ 和 YZ 平面中 G 代码圆弧的支持。
* 多项错误修复和代码清理。

## Klipper 0.11.0

发布于 2022年11月28日。此版本的主要变更：
* Trinamic 步进电机驱动器的“双边触发”优化。
* 支持 Python3。Klipper 主机代码可在 Python2 或 Python3 下运行。
* 增强了 CAN 总线支持。支持在 rp2040、stm32g0、stm32h7、same51 和 same54 芯片上使用 CAN 总线。支持“USB 转 CAN 总线桥接”模式。
* 支持 CanBoot 引导程序。
* 支持 mpu9250 和 mpu6050 加速度计。
* 改进了对 max31856、max31855、max31865 和 max6675 温度传感器的错误处理。
* 现在可以使用 LED “模板”支持在长时间运行的 G 代码命令期间配置 LED 更新。
* 多项微控制器改进。新增对 stm32h743、stm32h750、stm32l412、stm32g0b1、same70、same51 和 same54 芯片的支持。支持在 atsamd 和 stm32f0 上进行 i2c 读取。stm32 上的硬件 pwm 支持。“linux mcu”基于信号的事件分发。新增对 rp2040 的“make flash”、i2c 和 rp2040-e5 USB 问题的修复支持。
* 新增模块：angle、dac084S085、exclude_object、led、mpu9250、pca9632、smart_effector、z_thermal_adjust。新增了 deltesian 运动学。新增了 dump_mcu 工具。
* 多项错误修复和代码清理。

## Klipper 0.10.0

发布于 2021年9月29日。此版本的主要变更：
* 支持“多微控制器归位”。现在可以将步进电机及其限位开关连接到不同的微控制器上。这简化了“工具头板”上 Z 探针的布线。
* Klipper 现在拥有一个
  [社区 Discord 服务器](https://discord.klipper3d.org)
  和一个 [社区 Discourse 服务器](https://community.klipper3d.org)。
* [Klipper 网站](https://www.klipper3d.org) 现在使用“mkdocs”基础设施。还有一个
  [Klipper 翻译项目](https://github.com/Klipper3d/klipper-translations)。
* 许多主板现在支持通过 SD 卡自动烧录固件。
* 新增对“混合 CoreXY”和“混合 CoreXZ”打印机的运动学支持。
* Klipper 现在使用 `rotation_distance` 来配置步进电机的移动距离。
* 主 Klipper 主机代码现在可以直接通过 CAN 总线与微控制器通信。
* 新的“运动分析”系统。可以跟踪和记录 Klipper 内部的运动更新和传感器结果以供分析。
* Trinamic 步进电机驱动器现在会持续监控错误状态。
* 支持 rp2040 微控制器（树莓派 Pico 开发板）。
* “make menuconfig” 系统现在使用 kconfiglib。
* 新增了许多模块：ds18b20、duplicate_pin_override、filament_motion_sensor、palette2、motion_report、pca9533、pulse_counter、save_variables、sdcard_loop、temperature_host、temperature_mcu。
* 多项错误修复和代码清理。

## Klipper 0.9.0

发布于 2020年10月20日。此版本的主要变更：
* 支持“输入整形”——一种抵消打印机共振的机制。它可以减少或消除打印中的“振铃”现象。
* 新的“平滑压力推进”系统。该系统在不引入瞬时速度变化的情况下实现“压力推进”。现在也可以使用“调校塔”方法来调整压力推进。
* 新的“webhooks” API 服务器。为 Klipper 提供可编程的 JSON 接口。
* LCD 显示屏和菜单现在可以使用 Jinja2 模板语言进行配置。
* TMC2208 步进电机驱动器现在可以在“独立”模式下与 Klipper 一起使用。
* 改进了对 BL-Touch v3 的支持。
* 改进了 USB 识别。Klipper 现在拥有自己的 USB 识别码，微控制器在 USB 识别期间可以报告其唯一的序列号。
* 新增对“旋转式 Delta”和“CoreXZ”打印机的运动学支持。
* 微控制器改进：支持 stm32f070，支持 stm32f207，支持“Linux MCU”上的 GPIO 引脚，stm32 “HID 引导程序”支持，Chitu 引导程序支持，MKS Robin 引导程序支持。
* 改进了对 Python “垃圾回收”事件的处理。
* 新增了许多模块：adc_scaled、adxl345、bme280、display_status、extruder_stepper、fan_generic、hall_filament_width_sensor、htu21d、homing_heaters、input_shaper、lm75、print_stats、resonance_tester、shaper_calibrate、query_adc、graph_accelerometer、graph_extruder、graph_motion、graph_shaper、graph_temp_sensor、whconsole。
* 多项错误修复和代码清理。

### Klipper 0.9.1

发布于 2020年10月28日。仅包含错误修复的版本。

## Klipper 0.8.0

发布于 2019年10月21日。此版本的主要变更：
* 新增 G 代码命令模板支持。配置文件中的 G 代码现在使用 Jinja2 模板语言进行解析。
* 对 Trinamic 步进驱动器的改进：
  * 新增对 TMC2209 和 TMC5160 驱动器的支持。
  * 改进了 DUMP_TMC、SET_TMC_CURRENT 和 INIT_TMC G 代码命令。
  * 改进了带模拟多路复用器的 TMC UART 处理支持。
* 改进了归位、探测和床面调平支持：
  * 新增了 manual_probe、bed_screws、screws_tilt_adjust、skew_correction、safe_z_home 模块。
  * 增强了多点探测，支持中位数、平均值和重试逻辑。
  * 改进了对 BL-Touch、探针校准、限位开关校准、Delta 校准、无传感器归位和限位开关相位校准的文档。
  * 改进了大 Z 轴的归位支持。
* 许多 Klipper 微控制器的改进：
  * Klipper 移植到：SAM3X8C、SAM4S8C、SAMD51、STM32F042、STM32F4。
  * 在 SAM3X、SAM4、STM32F4 上实现了新的 USB CDC 驱动程序。
  * 增强了通过 USB 烧录 Klipper 的支持。
  * 支持软件 SPI。
  * 大幅改进了 LPC176x 上的温度滤波。
  * 可以在微控制器中配置早期输出引脚设置。
* 新的网站，包含 Klipper 文档：http://klipper3d.org/
  * Klipper 现在有了自己的标志。
* 实验性支持极坐标和“缆绳卷扬”运动学。
* 配置文件现在可以包含其他配置文件。
* 新增了许多模块：board_pins、controller_fan、delayed_gcode、dotstar、filament_switch_sensor、firmware_retraction、gcode_arcs、gcode_button、heater_generic、manual_stepper、mcp4018、mcp4728、neopixel、pause_resume、respond、temperature_sensor、tsl1401cl_filament_width_sensor、tuning_tower。
* 新增了许多命令：RESTORE_GCODE_STATE、SAVE_GCODE_STATE、SET_GCODE_VARIABLE、SET_HEATER_TEMPERATURE、SET_IDLE_TIMEOUT、SET_TEMPERATURE_FAN_TARGET。
* 多项错误修复和代码清理。

## Klipper 0.7.0

发布于 2018年12月20日。此版本的主要变更：
* Klipper 现在支持“网格”床面调平。
* 新增对“增强型”Delta 校准的支持（可校准 Delta 打印机的打印 X/Y 尺寸）。
* 支持在运行时配置 Trinamic 步进电机驱动器（tmc2130、tmc2208、tmc2660）。
* 改进了温度传感器支持：MAX6675、MAX31855、MAX31856、MAX31865、自定义热敏电阻、常见的 pt100 类型传感器。
* 新增了多个模块：temperature_fan、sx1509、force_move、mcp4451、z_tilt、quad_gantry_level、endstop_phase、bltouch。
* 新增了多个命令：SAVE_CONFIG、SET_PRESSURE_ADVANCE、SET_GCODE_OFFSET、SET_VELOCITY_LIMIT、STEPPER_BUZZ、TURN_OFF_HEATERS、M204、自定义 G 代码宏。
* 扩展了 LCD 显示支持：
  * 支持运行时菜单。
  * 新的显示图标。
  * 支持“uc1701”和“ssd1306”显示屏。
* 新增了微控制器支持：
  * Klipper 移植到：LPC176x（Smoothieboards）、SAM4E8E（Duet2）、SAMD21（Arduino Zero）、STM32F103（“蓝色药丸”设备）、atmega32u4。
  * 在 AVR、LPC176x、SAMD21 和 STM32F103 上实现了新的通用 USB CDC 驱动程序。
  * 在 ARM 处理器上进行了性能改进。
* 运动学代码被重写为使用“迭代求解器”。
* 为 Klipper 主机软件新增了自动测试用例。
* 为常见的现成打印机提供了许多新的示例配置文件。
* 更新了关于引导程序、基准测试、微控制器移植、配置检查、引脚映射、切片软件设置、打包等方面的文档。
* 多项错误修复和代码清理。

## Klipper 0.6.0

发布于 2018年3月31日。此版本的主要变更：
* 增强了加热器和热敏电阻硬件故障检查。
* 支持 Z 探针。
* 初始支持 Delta 打印机的自动参数校准（通过新的 delta_calibrate 命令）。
* 初始支持床面倾斜补偿（通过 bed_tilt_calibrate 命令）。
* 初始支持“安全归位”和归位覆盖。
* 初始支持在 RepRapDiscount 风格的 2004 和 12864 显示屏上显示状态。
* 新的多挤出机改进：
  * 支持共享加热器。
  * 初始支持双滑架。
* 支持为每个轴配置多个步进电机（例如，双 Z 轴）。
* 支持配置自定义数字和 PWM 输出引脚（通过新的 SET_PIN 命令）。
* 初始支持“虚拟 SD 卡”，允许直接从 Klipper 打印（有助于在运行 OctoPrint 性能不佳的机器上使用）。
* 支持在 Delta 打印机的每个塔上设置不同的臂长。
* 支持 G 代码 M220/M221 命令（速度倍率覆盖 / 挤出倍率覆盖）。
* 多项文档更新：
  * 为常见的现成打印机提供了许多新的示例配置文件。
  * 新的多微控制器配置示例。
  * 新的 BLTouch 传感器配置示例。
  * 新的常见问题解答、配置检查和 G 代码文档。
* 初始支持对所有 GitHub 提交进行持续集成测试。
* 多项错误修复和代码清理。

## Klipper 0.5.0

发布于 2017年10月25日。此版本的主要变更：

* 支持多挤出机打印机。
* 初始支持在 Beaglebone PRU 上运行。初始支持 Replicape 电路板。
* 初始支持在实时 Linux 进程中运行微控制器代码。
* 支持多个微控制器。（例如，可以用一个微控制器控制挤出机，另一个控制打印机的其余部分。）实现了软件时钟同步以协调微控制器之间的操作。
* 步进电机性能改进（20MHz 的 AVRs 可达每秒 189K 步）。
* 支持控制舵机，以及定义喷嘴冷却风扇。
* 多项错误修复和代码清理。

## Klipper 0.4.0

发布于 2017年5月3日。此版本的主要变更：

* 改进了在树莓派上的安装。大部分安装过程现在已脚本化。
* 支持 corexy 运动学。
* 文档更新：新的运动学文档、新的压力推进调校指南、新的示例配置文件等。
* 步进电机性能改进（20MHz 的 AVRs 超过每秒 175K 步，Arduino Due 超过每秒 460K 步）。
* 支持自动微控制器复位。支持通过切换树莓派上的 USB 电源进行复位。
* 压力推进算法现在通过前瞻工作，以减少转弯时的压力变化。
* 支持限制短锯齿形移动的最高速度。
* 支持 AD595 传感器。
* 多项错误修复和代码清理。

## Klipper 0.3.0

发布于 2016年12月23日。此版本的主要变更：

* 改进了文档。
* 支持具有 Delta 运动学的机器人。
* 支持 Arduino Due 微控制器（ARM cortex-M3）。
* 支持基于 USB 的 AVR 微控制器。
* 支持“压力推进”算法——它能减少打印过程中的渗出。
* 新的“基于步进相位的限位开关”功能——可实现更高的限位开关归位精度。
* 支持“扩展 G 代码”命令，如“help”、“restart”和“status”。
* 支持通过终端发出“restart”命令来重新加载 Klipper 配置并重启主机软件。
* 步进电机性能改进（20MHz 的 AVRs 可达每秒 158K 步）。
* 改进了错误报告。大多数错误现在会通过终端显示，并提供如何解决的帮助信息。
* 多项错误修复和代码清理。

## Klipper 0.2.0

Klipper 的初始发布版本。发布于 2016年5月25日。初始版本包含的主要功能有：

* 对笛卡尔坐标打印机的基本支持（步进电机、挤出机、加热床、冷却风扇）。
* 支持常见的 G 代码命令。支持与 OctoPrint 交互。
* 加速度和前瞻处理。
* 通过标准串行端口支持 AVR 微控制器。