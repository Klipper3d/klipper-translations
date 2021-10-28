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

If you want to change the baud rate anyway, then the new rate will need to be configured in the micro-controller (during **make menuconfig**) and that updated code will need to be compiled and flashed to the micro-controller. The Klipper printer.cfg file will also need to be updated to match that baud rate (see the [config reference](Config_Reference.md#mcu) for details). For example:

```
[mcu]
baud: 250000
```

The baud rate shown on the OctoPrint web page has no impact on the internal Klipper micro-controller baud rate. Always set the OctoPrint baud rate to 250000 when using Klipper.

The Klipper micro-controller baud rate is not related to the baud rate of the micro-controller's bootloader. See the [bootloader document](Bootloaders.md) for additional information on bootloaders.

## 我可以在 Raspberry Pi 3 以外的其他设备上运行 Klipper 吗？

推荐的硬件是 Raspberry Pi 2、Raspberry Pi 3 或 Raspberry Pi 4。

Klipper will run on a Raspberry Pi 1 and on the Raspberry Pi Zero, but these boards don't have enough processing power to run OctoPrint well. It is common for print stalls to occur on these slower machines when printing directly from OctoPrint. (The printer may move faster than OctoPrint can send movement commands.) If you wish to run on one one of these slower boards anyway, consider using the "virtual_sdcard" feature when printing (see [config reference](Config_Reference.md#virtual_sdcard) for details).

要在 Beaglebone 上运行，请参阅 [Beaglebone 特定安装说明](beaglebone.md)。

Klipper has been run on other machines. The Klipper host software only requires Python running on a Linux (or similar) computer. However, if you wish to run it on a different machine you will need Linux admin knowledge to install the system prerequisites for that particular machine. See the [install-octopi.sh](../scripts/install-octopi.sh) script for further information on the necessary Linux admin steps.

If you are looking to run the Klipper host software on a low-end chip, then be aware that, at a minimum, a machine with "double precision floating point" hardware is required.

If you are looking to run the Klipper host software on a shared general-purpose desktop or server class machine, then note that Klipper has some real-time scheduling requirements. If, during a print, the host computer also performs an intensive general-purpose computing task (such as defragmenting a hard drive, 3d rendering, heavy swapping, etc.), then it may cause Klipper to report print errors.

Note: If you are not using an OctoPi image, be aware that several Linux distributions enable a "ModemManager" (or similar) package that can disrupt serial communication. (Which can cause Klipper to report seemingly random "Lost communication with MCU" errors.) If you install Klipper on one of these distributions you may need to disable that package.

## 我可以在同一台主机上运行多个 Klipper 实例吗？

可以运行 Klipper 主机软件的多个实例，但这样做需要一定的 Linux 知识。 Klipper 安装脚本最终会导致运行以下 Unix 命令：

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

只要每个实例都有自己的打印机配置文件、自己的日志文件和自己的伪 tty，就可以运行上述命令的多个实例。 例如：

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

If you choose to do this, you will need to implement the necessary start, stop, and installation scripts (if any). The [install-octopi.sh](../scripts/install-octopi.sh) script and the [klipper-start.sh](../scripts/klipper-start.sh) script may be useful as examples.

## 我必须使用 OctoPrint 吗？

The Klipper software is not dependent on OctoPrint. It is possible to use alternative software to send commands to Klipper, but doing so requires Linux admin knowledge.

Klipper creates a "virtual serial port" via the "/tmp/printer" file, and it emulates a classic 3d-printer serial interface via that file. In general, alternative software may work with Klipper as long as it can be configured to use "/tmp/printer" for the printer serial port.

## 为什么在归位打印机之前我不能移动步进器？

代码这样做是为了减少意外将头撞到床或墙壁的机会。 打印机归位后，软件会尝试验证每个移动是否在配置文件中定义的 position_min/max 范围内。 如果电机被禁用（通过 M84 或 M18 命令），那么电机将需要在运动前再次归位。

如果您想在通过 OctoPrint 取消打印后移动打印头，请考虑更改 OctoPrint 取消顺序来为您执行此操作。 它是通过 Web 浏览器在 OctoPrint 中配置的：设置-> GCODE 脚本

如果您想在打印完成后移动头部，请考虑将所需的移动添加到切片机的“自定义 g 代码”部分。

If the printer requires some additional movement as part of the homing process itself (or fundamentally does not have a homing process) then consider using a safe_z_home or homing_override section in the config file. If you need to move a stepper for diagnostic or debugging purposes then consider adding a force_move section to the config file. See [config reference](Config_Reference.md#customized_homing) for further details on these options.

## 为什么 Z position_endstop 在默认配置中设置为 0.5？

For cartesian style printers the Z position_endstop specifies how far the nozzle is from the bed when the endstop triggers. If possible, it is recommended to use a Z-max endstop and home away from the bed (as this reduces the potential for bed collisions). However, if one must home towards the bed then it is recommended to position the endstop so it triggers when the nozzle is still a small distance away from the bed. This way, when homing the axis, it will stop before the nozzle touches the bed. See the [bed level document](Bed_Level.md) for more information.

## I converted my config from Marlin and the X/Y axes work fine, but I just get a screeching noise when homing the Z axis

Short answer: First, make sure you have verified the stepper configuration as described in the [config check document](Config_checks.md). If the problem persists, try reducing the max_z_velocity setting in the printer config.

Long answer: In practice Marlin can typically only step at a rate of around 10000 steps per second. If it is requested to move at a speed that would require a higher step rate then Marlin will generally just step as fast as it can. Klipper is able to achieve much higher step rates, but the stepper motor may not have sufficient torque to move at a higher speed. So, for a Z axis with a high gearing ratio or high microsteps setting the actual obtainable max_z_velocity may be smaller than what is configured in Marlin.

## My TMC motor driver turns off in the middle of a print

If using the TMC2208 (or TMC2224) driver in "standalone mode" then make sure to use the [latest version of Klipper](#how-do-i-upgrade-to-the-latest-software). A workaround for a TMC2208 "stealthchop" driver problem was added to Klipper in mid-March of 2020.

## I keep getting random "Lost communication with MCU" errors

This is commonly caused by hardware errors on the USB connection between the host machine and the micro-controller. Things to look for:

- Use a good quality USB cable between the host machine and micro-controller. Make sure the plugs are secure.
- If using a Raspberry Pi, use a [good quality power supply](https://www.raspberrypi.org/documentation/hardware/raspberrypi/power/README.md) for the Raspberry Pi and use a [good quality USB cable](https://www.raspberrypi.org/forums/viewtopic.php?p=589877#p589877) to connect that power supply to the Pi. If you get "under voltage" warnings from OctoPrint, this is related to the power supply and it must be fixed.
- Make sure the printer's power supply is not being overloaded. (Power fluctuations to the micro-controller's USB chip may result in resets of that chip.)
- Verify stepper, heater, and other printer wires are not crimped or frayed. (Printer movement may place stress on a faulty wire causing it to lose contact, briefly short, or generate excessive noise.)
- There have been reports of high USB noise when both the printer's power supply and the host's 5V power supply are mixed. (If you find that the micro-controller powers on when either the printer's power supply is on or the USB cable is plugged in, then it indicates the 5V power supplies are being mixed.) It may help to configure the micro-controller to use power from only one source. (Alternatively, if the micro-controller board can not configure its power source, one may modify a USB cable so that it does not carry 5V power between the host and micro-controller.)

## My Raspberry Pi keeps rebooting during prints

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
