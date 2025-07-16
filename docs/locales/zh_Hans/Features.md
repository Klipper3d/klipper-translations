# 功能

Klipper 有几个引人注目的功能：

* 高精度步进运动。Klipper使用一个应用处理器（例如低成本的树莓派）来计算打印机运动。应用处理器决定何时对每个步进电机发出步进信号，压缩这些事件，并将它们发送到微控制器。微处理器将会把每个事件按请求时间执行。每一个步进事件被以25毫秒或更高的精度安排。Klipper不使用运动估计，例如 Bresenham算法，而是通过加速度与机械运动物理计算精确的步进时间。更精准的步进电机运动意味着打印机更安静和稳定的运行。
* 最佳表现。Klipper 能够在新旧微控制器上实现高步进速率。即使是老的 8 位微控制器也可以获得超过 175K 步/秒的速率。在较新的微控制器上，数百万步/秒也是可能的。更高的步进速率使打印速度更快。即使在高速运行时，步进电机的事件定时仍然保持精确，从而提高了整体稳定性。
* Klipper 支持带有多个微控制器的打印机。例如，一个微控制器可以被用来控制挤出机，而另一个用来控制加热器，并使用第三个来控制其他的打印机组件。Klipper 主机程序实现了时钟同步，解决了微处理器之间的时钟漂移。 启用多个控制器只需要在配置文件中添加几行，不需要任何特殊代码。
* 通过简单的配置文件进行配置。修改设置不需要重新刷写微控制器。Klipper 的所有配置都被存储在一个易编辑的配置文件中，大大减少了配置与维护硬件的难度。
* Klipper 支持“平滑提前压力”--一种考虑了挤出机内压力影响的机制。这项技术可以减少喷嘴溢料并改善转角的打印质量。Klipper 的实现不会引入瞬间挤出机速度变化，改善了整体稳定性和稳健性。
* 支持使用“输入整形”来减少振动对打印质量的影响。这项功能可以减少或消除打印件的“振纹(ringing)”（又名“ghosting”，“echoing”，或“rippling”）。在一些情况下它可以在保持打印质量的同时提高打印速度。
* Klipper 使用“迭代求解器”从简单的运动学方程中计算精准的步进时间。这降低了移植Klipper到新的机械结构的难度并保证了精确的步进计时（而不需要“线段化”）。
* Klipper 不受硬件影响。所有运行Klipper的打印机都有底层硬件无关的相同精确时序。Klipper 微控制器代码旨在忠实地遵循 Klipper 主机软件提供的时间表（或在无法遵循时突出显示提醒用户）。这样可以放心、轻松的使用和升级硬件。
* 易移植的代码。Klipper 可以在 ARM，AVR，和PRU架构的微控制器上运行。现有的“reprap”类打印机不需要改动任何硬件就可以运行 Klipper，只需要加一个树莓派。Klipper 的内部代码结构使它能够被简单的移植到其他架构。
* 简洁的代码。大部分 Klipper 代码使用一个极高级编程语言（Python），这包括了运动算法，G代码解析，加热，温度传感器算法和其他，降低了开发新功能的难度。
* 自定义可编程脚本。可以在打印机配置文件中定义新的G代码命令（而不需要修改任何代码）。这些命令都是可编程的，可以能根据打印机的状态做出不同的响应。
* 内置API服务器。除了标准G代码接口，Klipper也支持富JSON API。使程序员能编写对打印机进行精细控制的外置程序。

## 其他功能

Klipper 支持许多标准的 3d 打印机功能：

* 提供多种网络界面。兼容Mainsail、Fluidd、OctoPrint和其他选择。这允许使用普通的网络浏览器来控制打印机。运行Klipper的树莓派也可以运行网络界面。
* 标准 G 代码支持。支持由常见“切片软件”（SuperSlicer、Cura、PrusaSlicer 等）生成的通用 G 代码命令。
* 支持多挤出机。包括对共享热端的挤出机（多进一出）和多头（IDEX）的支持。
* 支持笛卡尔、三角洲、CoreXY、CoreXZ、混合CoreXY、混合CoreXZ、deltesian、旋转三角洲、极坐标和缆绳铰盘式打印机。
* Automatic bed leveling support. Klipper can be configured for basic bed tilt detection or full mesh bed leveling. The bed mesh can be customized to the print size (adaptive bed mesh). If the bed uses multiple Z steppers then Klipper can also level by independently manipulating the Z steppers. Most Z height probes are supported, including BL-Touch probes and servo activated probes. Probes may be calibrated for axis twist compensation. If using an "eddy current probe" then one can utilize fast bed mesh scanning,
* 支持自动delta校准。校准工具可以进行基本的高度校准，以及增强的X和Y尺寸校准。校准可以用Z型高度探头或通过手动探测来完成。
* 支持打印时“排除对象”。配置后，此模块可以取消多零件打印中的一个对象。
* Support for common temperature sensors (eg, common thermistors, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20, AHT10, SHT3x, and LM75). Custom thermistors and custom analog temperature sensors can also be configured. One can monitor the internal micro-controller temperature sensor and the internal temperature sensor of a Raspberry Pi.
* 默认启用基本加热器保护。
* Support for standard fans, nozzle fans, and temperature controlled fans. No need to keep fans running when the printer is idle. Fan speed can be monitored on fans that have a tachometer. One can assign a "math formula" to a fan for automatic fan speed updating.
* 支持TMC2130、TMC2208/TMC2224、TMC2209、TMC2660和TMC5160步进电机驱动器的运行时配置。还支持通过AD5206、DAC084S085、MCP4451、MCP4728、MCP4018和PWM引脚对传统步进驱动器进行电流控制。
* 支持直接连接到打印机的普通LCD显示器。还提供了一个默认的菜单。显示器和菜单的内容可以通过配置文件完全定制。
* 恒定加速和“look-ahead”（前瞻）支持。所有打印机移动将从静止逐渐加速到巡航速度，然后减速回到静止。对传入的 G 代码移动命令流进行排队和分析 - 将优化类似方向上的移动之间的加速度，以减少打印停顿并改善整体打印时间。
* Klipper 实现了一种“步进相位限位”算法，可以提高典型限位开关的精度。如果调整得当，它可以提高打印件首层和打印床的附着力。
* 支持打印丝存在传感器、打印丝运动传感器和打印丝宽度传感器。
* Support for measuring and recording acceleration using adxl345, mpu9250, mpu6050, lis2dw12, lis3dh, and icm20948 accelerometers.
* 支持限制短距离“之”字形移动的最高速度，以减少打印机的振动和噪音。更多信息见[运动学](Kinematics.md)文档。
* 许多常见的打印机都有样本配置文件。查看[配置文件夹](../config/)中的列表。

要开始使用Klipper，请阅读[安装](Installation.md)指南。

## 步速基准测试

下面是步进性能测试的结果。显示的数字代表了微控制器上每秒的总步数。

| 微控制器 | 1个活跃步进电机 | 3个步进器活跃 |
| --- | --- | --- |
| 16Mhz AVR | 157K | 99K |
| 20Mhz AVR | 196K | 123K |
| SAMD21 | 686K | 471K |
| STM32F042 | 814K | 578K |
| Beaglebone 可编程实时单元 | 866K | 708K |
| STM32G0B1 | 1103K | 790K |
| STM32F103 | 1180K | 818K |
| SAM3X8E | 1273K | 981K |
| SAM4S8C | 1690K | 1385K |
| LPC1768 | 1923K | 1351K |
| LPC1769 | 2353K | 1622K |
| SAM4E8E | 2500K | 1674K |
| SAMD51 | 3077K | 1885K |
| AR100 | 3529K | 2507K |
| STM32G431 | 3617K | 2452K |
| STM32F407 | 3652K | 2459K |
| STM32F446 | 3913K | 2634K |
| RP2040 | 4000K | 2571K |
| RP2350 | 4167K | 2663K |
| SAME70 | 6667K | 4737K |
| STM32H723 | 7429K | 8619K |

如果不确定一个控制板上的微控制器型号，可以先找到相应的[配置文件](../config/)，并在该文件顶部的注释中寻找微控制器的型号。

关于基准测试的更多详细信息可在[基准测试文档](Benchmarks.md)中找到。
