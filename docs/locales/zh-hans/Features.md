Klipper 有几个引人注目的功能：

* 高精度步进运动。Klipper使用一个应用处理器（例如低成本的树莓派）来计算打印机运动。应用处理器决定何时对每个步进电机发出步进信号，压缩这些事件，并将它们发送到微控制器。微处理器将会把每个事件按请求时间执行。每一个步进事件被以25毫秒或更高的精度安排。软件不进行运动估计，例如 Bresenham算法，而是通过加速度与机械运动物理计算精确的步进时间。更精准的步进电机运动意味着打印机更安静和稳定的运行。
* 同类固件中最佳表现。 Klipper 能够在新的和旧的微控制器上实现高步进率。即使是旧的 8 位微控制器也可以获得超过每秒 175K 步的速率。在较新的微控制器上，速率可以超过每秒 500K 步。更高的步进速率可实现更高的打印速度。即使在高速下也能保持步进事件计时精确，从而提高整体稳定性。
* Klipper 支持带有多个微控制器的打印机。例如，一个微控制器可以被用来控制挤出机，而另一个用来控制加热器，并使用第三个来控制其他的打印机组件。Klipper 主机程序实现了时钟同步，解决了微处理器之间的时钟漂移。 启用多个控制器只需要在配置文件中添加几行，不需要任何特殊代码。
* 通过简单的配置文件进行配置。修改设置不需要重新刷写微控制器。Klipper 的所有配置都被存储在一个易编辑的配置文件中，大大减少了配置与维护硬件的难度。
* Klipper 支持“平滑提前压力”--一种考虑了挤出机内压力影响的机制。这项技术可以减少喷嘴溢料并改善转角的打印质量。Klipper 的实现不会引入瞬间挤出机速度变化，改善了整体稳定性和稳健性。
* 支持使用“输入整形”来减少振动对打印质量的影响。这项功能可以减少或消除打印件的“振纹(ringing)”（又名“ghosting”，“echoing”，或“rippling”）。在一些情况下它可以在保持打印质量的同时提高打印速度。
* Klipper 使用“迭代求解器”从简单的运动学方程中计算精准的步进时间。这降低了移植Klipper到新的机械结构的难度并保证了精确的步进计时（而不需要“线段化”）。
* 易移植的代码。Klipper 可以在 ARM，AVR，和PRU架构的微控制器上运行。现有的“reprap”类打印机不需要改动任何硬件就可以运行 Klipper，只需要加一个树莓派。Klipper 的内部代码结构使它能够被简单的移植到其他架构。
* 简洁的代码。大部分 Klipper 代码使用一个极高级编程语言（Python），这包括了运动算法，G代码解析，加热，温度传感器算法和其他，降低了开发新功能的难度。
* 自定义可编程脚本。可以在打印机配置文件中定义新的G代码命令（而不需要修改任何代码）。这些命令都是可编程的，可以能根据打印机的状态做出不同的响应。
* 内置API服务器。除了标准G代码接口，Klipper也支持富JSON API。使程序员能编写对打印机进行精细控制的外置程序。

# 其他功能

Klipper 支持许多标准的 3d 打印机功能：

* 兼容Octoprint。这使得打印机可以通过普通浏览器来控制。运行Klipper的树莓派可以同时用来运行Octoprint。
* 标准G代码支持。支持典型的切片软件生成的G代码。Klipper可以与 Slic3r、Cura 和其他切片软件进行操作。
* 支持多挤出机。包括对共享热端的挤出机（多进一出）和多头（IDEX）的支持。
* 支持笛卡尔（cartesian）、三角洲（delta）、CoreXY、CoreXZ、旋转三角洲（rotary delta）和缆绳绞盘（cable winch）结构打印机。
* Automatic bed leveling support. Klipper can be configured for basic bed tilt detection or full mesh bed leveling. If the bed uses multiple Z steppers then Klipper can also level by independently manipulating the Z steppers. Most Z height probes are supported, including BL-Touch probes and servo activated probes.
* Automatic delta calibration support. The calibration tool can perform basic height calibration as well as an enhanced X and Y dimension calibration. The calibration can be done with a Z height probe or via manual probing.
* 支持常见的温度传感器（例如，常见的热敏电阻、AD595、AD597、AD849x、PT100、PT1000、MAX6675、MAX31855、MAX31856、MAX31865、BME280、HTU21D和LM75）。还可以配置自定义热敏电阻和自定义模拟温度传感器。
* 默认启用基本加热器保护。
* 支持标准风扇、喷嘴风扇和温控风扇。当打印机闲置时，不需要保持风扇运行。
* Support for run-time configuration of TMC2130, TMC2208/TMC2224, TMC2209, TMC2660, and TMC5160 stepper motor drivers. There is also support for current control of traditional stepper drivers via AD5206, MCP4451, MCP4728, MCP4018, and PWM pins.
* Support for common LCD displays attached directly to the printer. A default menu is also available. The contents of the display and menu can be fully customized via the config file.
* Constant acceleration and "look-ahead" support. All printer moves will gradually accelerate from standstill to cruising speed and then decelerate back to a standstill. The incoming stream of G-Code movement commands are queued and analyzed - the acceleration between movements in a similar direction will be optimized to reduce print stalls and improve overall print time.
* Klipper implements a "stepper phase endstop" algorithm that can improve the accuracy of typical endstop switches. When properly tuned it can improve a print's first layer bed adhesion.
* Support for measuring and recording acceleration using an adxl345 accelerometer.
* Support for limiting the top speed of short "zigzag" moves to reduce printer vibration and noise. See the [kinematics](Kinematics.md) document for more information.
* Sample configuration files are available for many common printers. Check the [config directory](../config/) for a list.

To get started with Klipper, read the [installation](Installation.md) guide.

# Step Benchmarks

Below are the results of stepper performance tests. The numbers shown represent total number of steps per second on the micro-controller.

| Micro-controller | Fastest step rate | 3 steppers active |
| --- | --- | --- |
| 16Mhz AVR | 154K | 102K |
| 20Mhz AVR | 192K | 127K |
| Arduino Zero (SAMD21) | 234K | 217K |
| "Blue Pill" (STM32F103) | 387K | 360K |
| Arduino Due (SAM3X8E) | 438K | 438K |
| Duet2 Maestro (SAM4S8C) | 564K | 564K |
| Smoothieboard (LPC1768) | 574K | 574K |
| Smoothieboard (LPC1769) | 661K | 661K |
| Beaglebone PRU | 680K | 680K |
| Duet2 Wifi/Eth (SAM4E8E) | 686K | 686K |
| Adafruit Metro M4 (SAMD51) | 761K | 692K |
| BigTreeTech SKR Pro (STM32F407) | 922K | 711K |

On AVR platforms, the highest achievable step rate is with just one stepper
stepping. On the SAMD21 and STM32F103 the highest step rate is with two simultaneous steppers stepping. On the SAM3X8E, SAM4S8C, SAM4E8E, LPC176x, and PRU the highest step rate is with three simultaneous steppers. On the SAMD51 and STM32F4 the highest step rate is with four simultaneous steppers. (Further details on the benchmarks are available in the [Benchmarks document](Benchmarks.md).)
