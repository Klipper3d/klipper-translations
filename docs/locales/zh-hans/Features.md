Klipper 有几个引人注目的功能：

* 高精度步进运动。Klipper使用一个应用处理器（例如低成本的树莓派）来计算打印机运动。应用处理器决定何时对每个步进电机发出步进信号，压缩这些事件，并将它们发
送到微控制器。微处理器将会把每个事件按请求时间执行。每一个步进事件被以25毫秒或更高的精度安排。软件不进行运动估计，例如
Bresenham算法，而是通过加速度与机械运动物理计算精确的步进时间。更精准的步进电机运动意味着打印机更安静和稳定的运行。

* 同类固件中最佳表现。 Klipper 能够在新的和旧的微控制器上实现高步进率。即使是旧的 8 位微控制器也可以获得超过每秒 175K
步的速率。在较新的微控制器上，速率可以超过每秒 500K 步。更高的步进速率可实现更高的打印速度。即使在高速下也能保持步进事件计时精确，从而提高整体稳定性。

* Klipper 支持带有多个微控制器的打印机。例如，一个微控制器可以被用来控制挤出机，而另一个用来控制加热器，并使用第三个来控制其他的打印机组件。Klipper
主机程序实现了时钟同步，解决了微处理器之间的时钟漂移。 启用多个控制器只需要在配置文件中添加几行，不需要任何特殊代码。

* 通过简单的配置文件进行配置。修改设置不需要重新刷写微控制器。Klipper 的所有配置都被存储在一个易编辑的配置文件中，大大减少了配置与维护硬件的难度。

* Klipper supports "Smooth Pressure Advance" - a mechanism to account for the
effects of pressure within an extruder. This reduces extruder "ooze" and
improves the quality of print corners. Klipper's implementation does not
introduce instantaneous extruder speed changes, which improves overall stability
and robustness.

* Klipper supports "Input Shaping" to reduce the impact of vibrations on print
quality. This can reduce or eliminate "ringing" (also known as "ghosting",
"echoing", or "rippling") in prints. It may also allow one to obtain faster
printing speeds while still maintaining high print quality.

* Klipper uses an "iterative solver" to calculate precise step times from simple
kinematic equations. This makes porting Klipper to new types of robots easier
and it keeps timing precise even with complex kinematics (no "line
segmentation" is needed).

* Portable code. Klipper works on ARM, AVR, and PRU based micro-controllers.
Existing "reprap" style printers can run Klipper without hardware modification
- just add a Raspberry Pi. Klipper's internal code layout makes it easier to
support other micro-controller architectures as well.

* 简洁的代码。大部分 Klipper
代码使用一个极高级编程语言（Python），这包括了运动算法，G代码解析，加热，温度传感器算法和其他，降低了开发新功能的难度。

* 自定义可编程脚本。可以在打印机配置文件中定义新的G代码命令（而不需要修改任何代码）。这些命令都是可编程的，可以能根据打印机的状态做出不同的响应。

* 内置API服务器。In addition to the standard G-Code interface, Klipper supports a rich
JSON based application interface. This enables programmers to build external
applications with detailed control of the printer.


# 其他功能

Klipper 支持许多标准的 3d 打印机功能：

* Works with Octoprint. This allows the printer to be controlled using a regular
web-browser. The same Raspberry Pi that runs Klipper can also run Octoprint.

* Standard G-Code support. Common g-code commands that are produced by typical
"slicers" are supported. One may continue to use Slic3r, Cura, etc. with
Klipper.

* Support for multiple extruders. Extruders with shared heaters and extruders on
independent carriages (IDEX) are also supported.

* Support for cartesian, delta, corexy, corexz, rotary delta, polar, and cable
winch style printers.

* Automatic bed leveling support. Klipper can be configured for basic bed tilt
detection or full mesh bed leveling. If the bed uses multiple Z steppers then
Klipper can also level by independently manipulating the Z steppers. Most Z
height probes are supported, including BL-Touch probes and servo activated
probes.

* Automatic delta calibration support. The calibration tool can perform basic
height calibration as well as an enhanced X and Y dimension calibration. The
calibration can be done with a Z height probe or via manual probing.

* 支持常见的温度传感器（例如，常见的热敏电阻、AD595、AD597、AD849x、PT100、PT1000、MAX6675、MAX31855、MAX31856
、MAX31865、BME280、HTU21D和LM75）。还可以配置自定义热敏电阻和自定义模拟温度传感器。

* 默认启用基本加热器保护。

* 支持标准风扇、喷嘴风扇和温控风扇。当打印机闲置时，不需要保持风扇运行。

* Support for run-time configuration of TMC2130, TMC2208/TMC2224, TMC2209,
TMC2660, and TMC5160 stepper motor drivers. There is also support for current
control of traditional stepper drivers via AD5206, MCP4451, MCP4728, MCP4018,
and PWM pins.

* Support for common LCD displays attached directly to the printer. A default menu
is also available. The contents of the display and menu can be fully customized
via the config file.

* Constant acceleration and "look-ahead" support. All printer moves will
gradually accelerate from standstill to cruising speed and then decelerate back
to a standstill. The incoming stream of G-Code movement commands are queued and
analyzed - the acceleration between movements in a similar direction will be
optimized to reduce print stalls and improve overall print time.

* Klipper implements a "stepper phase endstop" algorithm that can improve the
accuracy of typical endstop switches. When properly tuned it can improve a
print's first layer bed adhesion.

* Support for measuring and recording acceleration using an adxl345 accelerometer.

* Support for limiting the top speed of short "zigzag" moves to reduce printer
vibration and noise. See the [kinematics](Kinematics.md) document for more
information.

* Sample configuration files are available for many common printers. Check the
[config directory](../config/) for a list.


To get started with Klipper, read the [installation](Installation.md) guide.

# Step Benchmarks

Below are the results of stepper performance tests. The numbers shown represent
total number of steps per second on the micro-controller.

| Micro-controller | Fastest step rate | 3 steppers active |
| ---------------- | ----------------- | ----------------- |
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
stepping. On the SAMD21 and STM32F103 the highest step rate is with two
simultaneous steppers stepping. On the SAM3X8E, SAM4S8C, SAM4E8E, LPC176x, and
PRU the highest step rate is with three simultaneous steppers. On the SAMD51 and
STM32F4 the highest step rate is with four simultaneous steppers. (Further
details on the benchmarks are available in the [Benchmarks
document](Benchmarks.md).)
