# Frequently Asked Questions

1. [我怎样才能支持项目？](#how-can-i-donate-to-the-project)
1. [如何计算rotation_distance配置参数？](#how-do-i-calculate-the-rotation_distance-config-parameter)
1. [我的串口在哪里找？](#wheres-my-serial-port)
1. [当微控制器重启设备更改为/dev/ttyUSB1](#when-the-micro-controller-restarts-the-device-changes-to-devttyusb1)
1. [“make flash”命令不起作用](#the-make-flash-command-doesnt-work)
1. [如何更改串口波特率？](#how-do-i-change-the-serial-baud-rate)
1. [我可以在 Raspberry Pi 3 以外的其他设备上运行 Klipper 吗？](#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)
1. [我可以在同一台主机上运行多个 Klipper 实例吗？](#can-i-run-multiple-instances-of-klipper-on-the-same-host-machine)
1. [我必须使用 OctoPrint 吗？](#do-i-have-to-use-octoprint)
1. [为什么我不能在归位打印机之前移动步进器？](#why-cant-i-move-the-stepper-before-homing-the-printer)
1. [为什么默认配置中的 Z position_endstop 设置为 0.5？](#why-is-the-z-position_endstop-set-to-05-in-the-default-configs)
1. [我从 Marlin 转换了我的配置，X/Y 轴工作正常，但在 Z 轴归位时我只会听到刺耳的噪音](#i-converted-my-config-from-marlin-and-the-xy-axes-work-fine-but-i-just-get-a-screeching-noise-when-homing-the-z-axis)
1. [我的 TMC 电机驱动程序在打印过程中关闭](#my-tmc-motor-driver-turns-off-in-the-middle-of-a-print)
1. [我不断收到随机的“与 MCU 失去通信”错误](#i-keep-getting-random-lost-communication-with-mcu-errors)
1. [我的树莓派在打印过程中不断重启](#my-raspberry-pi-keeps-rebooting-during-prints)
1. [当我设置“restart_method=command”时，我的 AVR 设备在重启时挂起](#when-i-set-restart_methodcommand-my-avr-device-just-hangs-on-a-restart)
1. [如果 Raspberry Pi 崩溃，加热器会继续打开吗？](#will-the-heaters-be-left-on-if-the-raspberry-pi-crashes)
1. [如何将 Marlin 引脚编号转换为 Klipper 引脚名称？](#how-do-i-convert-a-marlin-pin-number-to-a-klipper-pin-name)
1. [我必须将我的设备连接到特定类型的微控制器引脚吗？](#do-i-have-to-wire-my-device-to-a-specific-type-of-micro-controller-pin)
1. [我如何取消 M109/M190“等待温度”请求？](#how-do-i-cancel-an-m109m190-wait-for-temperature-request)
1. [可以查一下打印机是否丢步吗？](#can-i-find-out-whether-the-printer-has-lost-steps)
1. [为什么Klipper会报错？ 我打印的文件丢了！](#why-does-klipper-report-errors-i-lost-my-print)
1. [如何升级到最新软件？](#how-do-i-upgrade-to-the-latest-software)
1. [如何卸载 klipper？](#how-do-i-uninstall-klipper)

## 我如何向项目捐款？

Thanks. Kevin has a Patreon page at: <https://www.patreon.com/koconnor>

## 如何计算 rotation_distance 配置参数？

参见[旋转距离文档](Rotation_Distance.md)。

## 我的串口在哪里找？

查找 USB 串行端口的一般方法是从主机上的 ssh 终端运行 `ls /dev/serial/by-id/*`。 它可能会产生类似于以下内容的输出：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

在上述命令中找到的名称是稳定的，可以在配置文件中使用它，同时可用于刷写微控制器的代码。 例如，一个 flash 命令：

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

更新后的配置可能如下所示：

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

请务必从上面运行的“ls”命令中复制并粘贴名称，因为每个打印机的名称都不同。

如果您使用多个微控制器并且它们没有唯一的 ID（在带有 CH340 USB 芯片的板上很常见），那么请按照上面的说明使用命令 `ls /dev/serial/by-path/*` 代替。

## 当微控制器重新启动设备更改为/dev/ttyUSB1

按照“[我的串行端口在哪里找？](#wheres-my-serial-port)”部分中的说明来防止这种情况发生。

## “make flash”命令不起作用

该代码尝试使用每个平台最常用的方法来刷写设备。 不幸的是，刷写方法存在很多差异，因此“make flash”命令可能不适用于所有主板。

如果您遇到间歇性故障或您确实有标准设置，请仔细检查刷写时 Klipper 是否未运行（sudo service klipper stop），确保 OctoPrint 未尝试直接连接到设备（打开 网页中的连接选项卡，如果串行端口设置为设备，则单击断开连接），并确保为您的电路板正确设置了 FLASH_DEVICE（请参阅[上面的问题](#wheres-my-serial-port)）。

但是，如果“make flash”对您的电路板不起作用，那么您将需要手动刷写。 查看 [config directory](../config) 中是否有一个配置文件，里面有刷机的具体说明。 此外，请查看电路板制造商的文档，看看它是否描述了如何刷写设备。 最后，可以使用诸如“avrdude”或“bossac”之类的工具手动刷写设备——有关更多信息，请参阅[引导加载程序文档](Bootloaders.md)。

## 如何更改串行波特率？

Klipper的推荐波特率是 250000。这个波特率在 Klipper 支持的所有微控制器板上都很好用。如果你发现网上的指南推荐了一个不同的波特率，那么请忽略这部分指南，继续使用默认值 250000。

如果你还是想改变波特率，那么需要重新配置微控制器为新的波特率（在**make menuconfig**过程中），然后将更新的代码编译并刷写到微控制器中。Klipper 的 printer.cfg 文件也需要更新以匹配该波特率（详见[配置参考](Config_Reference.md#mcu）)。例如：

```
[mcu]
baud: 250000
```

OctoPrint 网页上显示的波特率对内部 Klipper 微控制器的波特率没有影响。使用 Klipper 时，始终将 OctoPrint 的波特率设置为250000。

Klipper 微控制器的波特率与微控制器启动引导程序的波特率无关。有关启动引导程序的额外信息请参阅[启动引导程序文档](Bootloaders.md)。

## 我可以在 Raspberry Pi 3 以外的其他设备上运行 Klipper 吗？

推荐的硬件是 Raspberry Pi 2、Raspberry Pi 3 或 Raspberry Pi 4。

Klipper 可以在 Raspberry Pi 1和Raspberry Pi Zero上运行，但这些板子没有足够的处理能力来运行 OctoPrint。在这些较慢的机器上直接从 OctoPrint 打印时，经常会出现打印停滞。(打印机的移动速度可能比 OctoPrint 发送移动命令的速度快。)如果你希望在这些较慢的板子上运行，请考虑在打印时使用 "virtual_sdcard "功能(详情请参见[配置参考](Config_Reference.md#virtual_sdcard))。

For running on the Beaglebone, see the [Beaglebone specific installation instructions](Beaglebone.md).

Klipper 可以在其他计算机上运行。Klipper 主机软件只需要在Linux（或类似）系统的计算机上运行 Python。然而，如果你想在其他计算机上运行它，你将需要一些 Linux 管理知识来安装该计算机上系统的依赖包。参见 [install-octopi.sh](..../scripts/install-octopi.sh) 脚本，以进一步了解必要的 Linux 安装方法。

如果你想在低端处理器上运行 Klipper 主机软件，请注意，你至少需要一台具有 "双精度浮点 "运算硬件的计算机。

如果你想在共享的通用计算机或服务器上运行 Klipper 主机程序，请注意 Klipper 有一些实时调度要求。如果在打印过程中，主机也在执行密集型的通用计算任务（如硬盘碎片整理、3D渲染、大量swapping （虚拟内存交换）等），可能会导致 Klipper 报告打印错误。

注意：如果你没有使用 OctoPi 镜像，一些Linux发行版启用了一个 "ModemManager"（或类似的）软件包，它干扰串行通信。(这可能导致 Klipper 报告看似随机的 "与MCU失去通信 "错误）。如果你在这些发行版上安装Klipper，你可能需要禁用该软件包。

## 我可以在同一台主机上运行多个 Klipper 实例吗？

可以运行 Klipper 主机软件的多个实例，但这样做需要一定的 Linux 知识。 Klipper 安装脚本最终会导致运行以下 Unix 命令：

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

只要每个实例都有自己的打印机配置文件、自己的日志文件和自己的伪 tty，就可以运行上述命令的多个实例。 例如：

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

如果你选择这样做，你将需要实现必要的启动、停止和安装脚本。[install-octopi.sh](..../scripts/install-octopi.sh)和[klipper-start.sh](..../scripts/klipper-start.sh)脚本提供了一些例子。

## 我必须使用 OctoPrint 吗？

Klipper 不依赖 OctoPrint。其他软件也可以向 Klipper 发送命令，但这样做可能需要一些 Linux 管理知识。

Klipper 通过 “/tmp/printer” 文件创建了一个“虚拟串口”，该文件模拟了一个标准的3D打印机串口。理论上任何能配置并使用 “/tmp/printer” 作为打印机串口的软件都可以与Klipper一起工作。

## 为什么在归位打印机之前我不能移动步进器？

代码这样做是为了减少意外将头撞到床或墙壁的机会。 打印机归位后，软件会尝试验证每个移动是否在配置文件中定义的 position_min/max 范围内。 如果电机被禁用（通过 M84 或 M18 命令），那么电机将需要在运动前再次归位。

如果您想在通过 OctoPrint 取消打印后移动打印头，请考虑更改 OctoPrint 取消顺序来为您执行此操作。 它是通过 Web 浏览器在 OctoPrint 中配置的：设置-> GCODE 脚本

如果您想在打印完成后移动头部，请考虑将所需的移动添加到切片机的“自定义 g 代码”部分。

如果打印机归位过程中需要一些额外的移动（或者根本上没有归位运动），那么可以在配置文件中定义safe_z_home或 homing_override分段。如果你需要为诊断或调试目的移动一个步进，可以在配置文件中添加一个 force_move 分段。参见[配置参考](Config_Reference.md#customized_homing)以了解关于这些选项的详情。

## 为什么 Z position_endstop 在默认配置中设置为 0.5？

对于笛卡尔式打印机，Z position_endstop 定义了当限位触发时喷嘴离床的距离。如果可能的话，建议使用 Z-max 限位使归位时打印头远离床（因为这可以减少碰撞的发生）。如果必须朝向床归位，那么建议将限位固定在喷嘴距离床还有一小段距离时触发。这样，当归位 Z 轴时，喷嘴会在接触床之前停止。有关详细信息，请参阅 [打印床调平文档](Bed_Level.md)。

## 我从 Marlin 转换了我的配置并且 X/Y 轴工作正常，但是在归位 Z 轴时我只听到刺耳的噪音且打印机不动

长话短说：首先，请确保您已按照 [配置检查文档](Config_checks.md) 中描述的步骤验证了步进驱动配置。如果问题仍然存在，请尝试降低打印机配置中的 max_z_velocity 设置。

具体原理：在实践中，Marlin 通常只能以每秒 10000 步左右的速度发送步进。如果要求它以需要更高的步进率的速度移动，那么 Marlin 会尽可能快地步进。Klipper 能够实现更高的步进率，但步进电机可能没有足够的扭矩以更高的速度移动。因此，对于一个具有高传动比或高微步设定的 Z 轴，实际的最大速度可能小于 Marlin 中配置的值。

## 我的 TMC 电机驱动在打印过程中关闭了

如果在“独立模式”中使用 TMC2208（或 TMC2224）驱动，那么请确保您正在使用[最新版本的 Klipper](#how-do-i-upgrade-to-the-latest-software)。2020年3月中旬，Klipper 中修复了 TMC2208 “StealthChop” 驱动的问题。

## 我不断收到随机的"与MCU失去通信"错误

这通常是由主机和微控制器之间的 USB 连接中硬件错误引起的。注意这些问题：

- 在主机和微控制器之间应该使用高质量USB线，并确保插头牢固。
- If using a Raspberry Pi, use a [good quality power supply](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply) for the Raspberry Pi and use a [good quality USB cable](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877) to connect that power supply to the Pi. If you get "under voltage" warnings from OctoPrint, this is related to the power supply and it must be fixed.
- 请确保打印机的电源没有过载。(微控制器 USB 芯片的电压波动可能会导致该芯片欠压复位。)
- 确认步进电机、加热器和其他打印机电线没有被压坏或磨损。（打印机移动时可能对故障的电线施加压力，导致其失去接触、短暂短路或产生过多的噪音。）
- There have been reports of high USB noise when both the printer's power supply and the host's 5V power supply are mixed. (If you find that the micro-controller powers on when either the printer's power supply is on or the USB cable is plugged in, then it indicates the 5V power supplies are being mixed.) It may help to configure the micro-controller to use power from only one source. (Alternatively, if the micro-controller board can not configure its power source, one may modify a USB cable so that it does not carry 5V power between the host and micro-controller.)

## 我的树莓派在打印时不断重启

This is most likely do to voltage fluctuations. Follow the same troubleshooting steps for a ["Lost communication with MCU"](#i-keep-getting-random-lost-communication-with-mcu-errors) error.

## When I set "restart_method=command" my AVR device just hangs on a restart

Some old versions of the AVR bootloader have a known bug in watchdog event handling. This typically manifests when the printer.cfg file has restart_method set to "command". When the bug occurs, the AVR device will be unresponsive until power is removed and reapplied to the device (the power or status LEDs may also blink repeatedly until the power is removed).

The workaround is to use a restart_method other than "command" or to flash an updated bootloader to the AVR device. Flashing a new bootloader is a one time step that typically requires an external programmer - see [Bootloaders](Bootloaders.md) for further details.

## Will the heaters be left on if the Raspberry Pi crashes?

The software has been designed to prevent that. Once the host enables a heater, the host software needs to confirm that enablement every 5 seconds. If the micro-controller does not receive a confirmation every 5 seconds it goes into a "shutdown" state which is designed to turn off all heaters and stepper motors.

See the "config_digital_out" command in the [MCU commands](MCU_Commands.md) document for further details.

In addition, the micro-controller software is configured with a minimum and maximum temperature range for each heater at startup (see the min_temp and max_temp parameters in the [config reference](Config_Reference.md#extruder) for details). If the micro-controller detects that the temperature is outside of that range then it will also enter a "shutdown" state.

Separately, the host software also implements code to check that heaters and temperature sensors are functioning correctly. See the [config reference](Config_Reference.md#verify_heater) for further details.

## How do I convert a Marlin pin number to a Klipper pin name?

Short answer: A mapping is available in the [sample-aliases.cfg](../config/sample-aliases.cfg) file. Use that file as a guide to finding the actual micro-controller pin names. (It is also possible to copy the relevant [board_pins](Config_Reference.md#board_pins) config section into your config file and use the aliases in your config, but it is preferable to translate and use the actual micro-controller pin names.) Note that the sample-aliases.cfg file uses pin names that start with the prefix "ar" instead of "D" (eg, Arduino pin `D23` is Klipper alias `ar23`) and the prefix "analog" instead of "A" (eg, Arduino pin `A14` is Klipper alias `analog14`).

Long answer: Klipper uses the standard pin names defined by the micro-controller. On the Atmega chips these hardware pins have names like `PA4`, `PC7`, or `PD2`.

Long ago, the Arduino project decided to avoid using the standard hardware names in favor of their own pin names based on incrementing numbers - these Arduino names generally look like `D23` or `A14`. This was an unfortunate choice that has lead to a great deal of confusion. In particular the Arduino pin numbers frequently don't translate to the same hardware names. For example, `D21` is `PD0` on one common Arduino board, but is `PC7` on another common Arduino board.

To avoid this confusion, the core Klipper code uses the standard pin names defined by the micro-controller.

## Do I have to wire my device to a specific type of micro-controller pin?

It depends on the type of device and type of pin:

ADC pins (or Analog pins): For thermistors and similar "analog" sensors, the device must be wired to an "analog" or "ADC" capable pin on the micro-controller. If you configure Klipper to use a pin that is not analog capable, Klipper will report a "Not a valid ADC pin" error.

PWM pins (or Timer pins): Klipper does not use hardware PWM by default for any device. So, in general, one may wire heaters, fans, and similar devices to any general purpose IO pin. However, fans and output_pin devices may be optionally configured to use `hardware_pwm: True`, in which case the micro-controller must support hardware PWM on the pin (otherwise, Klipper will report a "Not a valid PWM pin" error).

IRQ pins (or Interrupt pins): Klipper does not use hardware interrupts on IO pins, so it is never necessary to wire a device to one of these micro-controller pins.

SPI pins: When using hardware SPI it is necessary to wire the pins to the micro-controller's SPI capable pins. However, most devices can be configured to use "software SPI", in which case any general purpose IO pins may be used.

I2C pins: When using I2C it is necessary to wire the pins to the micro-controller's I2C capable pins.

Other devices may be wired to any general purpose IO pin. For example, steppers, heaters, fans, Z probes, servos, LEDs, common hd44780/st7920 LCD displays, the Trinamic UART control line may be wired to any general purpose IO pin.

## How do I cancel an M109/M190 "wait for temperature" request?

Navigate to the OctoPrint terminal tab and issue an M112 command in the terminal box. The M112 command will cause Klipper to enter into a "shutdown" state, and it will cause OctoPrint to disconnect from Klipper. Navigate to the OctoPrint connection area and click on "Connect" to cause OctoPrint to reconnect. Navigate back to the terminal tab and issue a FIRMWARE_RESTART command to clear the Klipper error state. After completing this sequence, the previous heating request will be canceled and a new print may be started.

## Can I find out whether the printer has lost steps?

In a way, yes. Home the printer, issue a `GET_POSITION` command, run your print, home again and issue another `GET_POSITION`. Then compare the values in the `mcu:` line.

This might be helpful to tune settings like stepper motor currents, accelerations and speeds without needing to actually print something and waste filament: just run some high-speed moves in between the `GET_POSITION` commands.

Note that endstop switches themselves tend to trigger at slightly different positions, so a difference of a couple of microsteps is likely the result of endstop inaccuracies. A stepper motor itself can only lose steps in increments of 4 full steps. (So, if one is using 16 microsteps, then a lost step on the stepper would result in the "mcu:" step counter being off by a multiple of 64 microsteps.)

## Why does Klipper report errors? I lost my print!

Short answer: We want to know if our printers detect a problem so that the underlying issue can be fixed and we can obtain great quality prints. We definitely do not want our printers to silently produce low quality prints.

Long answer: Klipper has been engineered to automatically workaround many transient problems. For example, it automatically detects communication errors and will retransmit; it schedules actions in advance and buffers commands at multiple layers to enable precise timing even with intermittent interference. However, should the software detect an error that it can not recover from, if it is commanded to take an invalid action, or if it detects it is hopelessly unable to perform its commanded task, then Klipper will report an error. In these situations there is a high risk of producing a low-quality print (or worse). It is hoped that alerting the user will empower them to fix the underlying issue and improve the overall quality of their prints.

There are some related questions: Why doesn't Klipper pause the print instead? Report a warning instead? Check for errors before the print? Ignore errors in user typed commands? etc? Currently Klipper reads commands using the G-Code protocol, and unfortunately the G-Code command protocol is not flexible enough to make these alternatives practical today. There is developer interest in improving the user experience during abnormal events, but it is expected that will require notable infrastructure work (including a shift away from G-Code).

## How do I upgrade to the latest software?

The first step to upgrading the software is to review the latest [config changes](Config_Changes.md) document. On occasion, changes are made to the software that require users to update their settings as part of a software upgrade. It is a good idea to review this document prior to upgrading.

When ready to upgrade, the general method is to ssh into the Raspberry Pi and run:

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

Then one can recompile and flash the micro-controller code. For example:

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

However, it's often the case that only the host software changes. In this case, one can update and restart just the host software with:

```
cd ~/klipper
git pull
sudo service klipper restart
```

If after using this shortcut the software warns about needing to reflash the micro-controller or some other unusual error occurs, then follow the full upgrade steps outlined above.

If any errors persist then double check the [config changes](Config_Changes.md) document, as you may need to modify the printer configuration.

Note that the RESTART and FIRMWARE_RESTART g-code commands do not load new software - the above "sudo service klipper restart" and "make flash" commands are needed for a software change to take effect.

## How do I uninstall Klipper?

On the firmware end, nothing special needs to happen. Just follow the flashing directions for the new firmware.

On the raspberry pi end, an uninstall script is available in [scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh). For example:

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
