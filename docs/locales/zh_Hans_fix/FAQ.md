# 常见问题解答

## 如何向项目捐款？

感谢您的支持。请参阅 [赞助商页面](Sponsors.md) 获取更多信息。

## 如何计算 rotation_distance 配置参数？

请参阅 [旋转距离文档](Rotation_Distance.md)。

## 我的串行端口在哪里？

查找 USB 串行端口的一般方法是在主机的 ssh 终端中运行 `ls /dev/serial/by-id/*` 命令。该命令可能会产生类似以下的输出：
```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

上述命令找到的名称是稳定的，可以在配置文件中以及刷新微控制器代码时使用。例如，刷新命令可能类似于：
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

请务必复制并粘贴您上面运行的 "ls" 命令中找到的名称，因为每个打印机的名称都会不同。

如果您使用多个微控制器，而它们没有唯一的 ID（在带有 CH340 USB 芯片的板子上很常见），那么请改用 `ls /dev/serial/by-path/*` 命令并按照上述说明操作。

## 当微控制器重启时，设备变成了 /dev/ttyUSB1

请遵循 “[我的串行端口在哪里？](#wheres-my-serial-port)” 部分中的说明，以防止此问题发生。

## “make flash” 命令不起作用

代码尝试使用每种平台最常见的方法来刷新设备。不幸的是，刷新方法存在很大差异，因此 “make flash” 命令可能不适用于所有开发板。

如果您遇到间歇性失败，或者您的设置是标准的，请再次检查刷新时 Klipper 是否未运行（sudo service klipper stop），确保 OctoPrint 没有尝试直接连接到设备（在网页中打开连接选项卡并单击断开连接，如果串行端口设置为设备），并确保 FLASH_DEVICE 为您的开发板正确设置（参见上面的[问题](#wheres-my-serial-port)）。

然而，如果 “make flash” 命令对您的开发板就是不起作用，那么您需要手动刷新。请查看 [配置目录](../config) 中是否有配置文件提供了刷新设备的具体说明。此外，请检查开发板制造商的文档，看是否描述了如何刷新设备。最后，可以使用 “avrdude” 或 “bossac” 等工具手动刷新设备 —— 请参阅 [引导加载程序文档](Bootloaders.md) 获取更多信息。

## 如何更改串行波特率？

Klipper 推荐的波特率为 250000。此波特率在 Klipper 支持的所有微控制器板上都能正常工作。如果您在网上找到的指南建议使用不同的波特率，请忽略该部分并继续使用默认值 250000。

如果您无论如何都想更改波特率，则需要在微控制器中配置新速率（在 **make menuconfig** 期间），并且需要编译并刷新该更新后的代码到微控制器。Klipper 的 printer.cfg 文件也需要更新以匹配该波特率（详见 [配置参考](Config_Reference.md#mcu)）。例如：
```
[mcu]
baud: 250000
```

OctoPrint 网页上显示的波特率对 Klipper 内部的微控制器波特率没有影响。使用 Klipper 时，请始终将 OctoPrint 波特率设置为 250000。

Klipper 微控制器波特率与微控制器引导加载程序的波特率无关。有关引导加载程序的更多信息，请参阅 [引导加载程序文档](Bootloaders.md)。

## 我可以在 Raspberry Pi 3 以外的设备上运行 Klipper 吗？

推荐的硬件是 Raspberry Pi Zero2w、Raspberry Pi 3、Raspberry Pi 4 或 Raspberry Pi 5。Klipper 也可以在其他 SBC 设备以及 x86 硬件上运行，如下所述。

Klipper 可以在 Raspberry Pi 1、2 和 Raspberry Pi Zero1 上运行，但这些板子的处理能力不足以很好地运行 Klipper。在打印时，这些较慢的机器上通常会发生打印停滞（打印机的移动速度可能比 Klipper 发送移动命令的速度快）。不建议在这些旧机器上运行 Klipper。

在 Beaglebone 上运行时，请参阅 [Beaglebone 专用安装说明](Beaglebone.md)。

Klipper 已在其他机器上运行过。Klipper 主机软件仅需要在 Linux（或类似）计算机上运行 Python。但是，如果您希望在不同的机器上运行它，则需要 Linux 管理员知识来安装该特定机器的系统先决条件。有关必要的 Linux 管理步骤的更多信息，请参阅 [install-octopi.sh](../scripts/install-octopi.sh) 脚本。

如果您打算在低端芯片上运行 Klipper 主机软件，请注意，至少需要具有“双精度浮点”硬件的机器。

如果您打算在共享的通用桌面或服务器级机器上运行 Klipper 主机软件，请注意 Klipper 有一些实时调度要求。如果在打印期间，主机计算机还执行密集的通用计算任务（例如，碎片整理硬盘、3D 渲染、大量交换等），则可能导致 Klipper 报告打印错误。

注意：如果您未使用 OctoPi 镜像，请注意一些 Linux 发行版启用了 “ModemManager”（或类似）包，这可能会中断串行通信。（这可能导致 Klipper 报告看似随机的 “与 MCU 通信丢失” 错误。）如果在这些发行版之一上安装 Klipper，您可能需要禁用该包。

## 我可以在同一台主机上运行多个 Klipper 实例吗？

可以运行多个 Klipper 主机软件实例，但这需要 Linux 管理员知识。Klipper 安装脚本最终会导致运行以下 Unix 命令：
```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```
只要每个实例都有自己的打印机配置文件、自己的日志文件和自己的伪终端，就可以运行上述命令的多个实例。例如：
```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

如果您选择这样做，您需要实现必要的启动、停止和安装脚本（如果有）。[install-octopi.sh](../scripts/install-octopi.sh) 脚本和 [klipper-start.sh](../scripts/klipper-start.sh) 脚本可能作为示例有用。

## 我必须使用 OctoPrint 吗？

Klipper 软件不依赖于 OctoPrint。可以使用替代软件向 Klipper 发送命令，但这需要 Linux 管理员知识。

Klipper 通过 “/tmp/printer” 文件创建一个 “虚拟串行端口”，并通过该文件模拟经典的 3D 打印机串行接口。通常，只要替代软件可以配置为使用 “/tmp/printer” 作为打印机串行端口，就可以与 Klipper 一起工作。

## 为什么在归位打印机之前我不能移动步进电机？

代码这样做是为了减少意外命令喷头撞到床或墙壁的风险。一旦打印机归位，软件会尝试验证每次移动是否在配置文件中定义的 position_min/max 范围内。如果电机被禁用（通过 M84 或 M18 命令），则在移动之前需要再次归位。

如果您想通过 OctoPrint 取消打印后移动喷头，请考虑更改 OctoPrint 的取消序列以为您完成此操作。它在 OctoPrint 中通过网页浏览器在以下位置配置：设置->GCODE 脚本

如果您想在打印完成后移动喷头，请考虑将所需的移动添加到切片软件的 “自定义 g-code” 部分。

如果打印机在归位过程本身需要一些额外的移动（或从根本上没有归位过程），则考虑在配置文件中使用 safe_z_home 或 homing_override 部分。如果您需要为诊断或调试目的移动步进电机，请考虑在配置文件中添加一个 force_move 部分。有关这些选项的更多详细信息，请参阅 [配置参考](Config_Reference.md#customized_homing)。

## 为什么默认配置中 Z position_endstop 设置为 0.5？

对于笛卡尔式打印机，Z position_endstop 指定当限位开关触发时喷嘴离床的距离。如果可能，建议使用 Z-max 限位开关并远离床归位（这减少了与床碰撞的潜在风险）。但是，如果必须朝床归位，则建议将限位开关定位在喷嘴仍离床一小段距离时触发。这样，在归位轴时，它会在喷嘴接触床之前停止。更多信息请参阅 [床水平文档](Bed_Level.md)。

## 我从 Marlin 转换了我的配置，X/Y 轴工作正常，但归位 Z 轴时我只听到刺耳的噪音

简短回答：首先，请确保您已按照 [配置检查文档](Config_checks.md) 中描述的那样验证了步进电机配置。如果问题仍然存在，请尝试降低打印机配置中的 max_z_velocity 设置。

长回答：实际上，Marlin 通常只能以大约 10000 步/秒的速率步进。如果要求以需要更高步进速率的速度移动，Marlin 通常只会以它能实现的最快速度步进。Klipper 能够实现更高的步进速率，但步进电机可能没有足够的扭矩以更高的速度移动。因此，对于具有高齿轮比或高微步设置的 Z 轴，实际可达到的 max_z_velocity 可能小于 Marlin 中配置的值。

## 我的 TMC 电机驱动器在打印中途关闭

如果在 “独立模式” 下使用 TMC2208（或 TMC2224）驱动器，请确保使用 [最新版本的 Klipper](#how-do-i-upgrade-to-the-latest-software)。2020 年 3 月中旬，Klipper 添加了一个针对 TMC2208 “stealthchop” 驱动器问题的解决方法。

## 我不断收到随机的 “与 MCU 通信丢失” 错误

这通常是由主机和微控制器之间的 USB 连接上的硬件错误引起的。需要注意的事项：
- 在主机和微控制器之间使用高质量的 USB 电缆。确保插头牢固。
- 如果使用 Raspberry Pi，请使用 [高质量的电源适配器](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply) 为 Raspberry Pi 供电，并使用 [高质量的 USB 电缆](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877) 将该电源适配器连接到 Pi。如果从 OctoPrint 收到 “电压过低” 警告，这与电源有关，必须解决。
- 确保打印机的电源没有过载。（微控制器 USB 芯片的电源波动可能导致该芯片重置。）
- 验证步进电机、加热器和其他打印机线缆没有被压扁或磨损。（打印机移动可能会对有故障的线缆施加应力，导致其失去接触、短暂短路或产生过多噪音。）
- 有报告称，当打印机的电源和主机的 5V 电源混合时，USB 噪音较高。（如果您发现微控制器在打印机电源开启或 USB 电缆插入时通电，则表明 5V 电源正在混合。）将微控制器配置为仅使用一个电源源可能会有所帮助。（或者，如果微控制器板无法配置其电源源，可以修改 USB 电缆，使其在主机和微控制器之间不传输 5V 电源。）

## 我的 Raspberry Pi 在打印期间不断重启

这很可能是由于电压波动引起的。请遵循与 [“与 MCU 通信丢失”](#i-keep-getting-random-lost-communication-with-mcu-errors) 错误相同的故障排除步骤。

## 当我设置 `restart_method=command` 时，我的 AVR 设备在重启时卡住

一些旧版本的 AVR 引导加载程序在看门狗事件处理中存在已知错误。当 printer.cfg 文件中的 restart_method 设置为 “command” 时，通常会出现这种情况。当发生此错误时，AVR 设备将无响应，直到断电并重新通电（电源或状态 LED 也可能在断电前反复闪烁）。

解决方法是使用 “command” 以外的 restart_method，或向 AVR 设备刷新更新的引导加载程序。刷新新的引导加载程序是一次性步骤，通常需要外部编程器 —— 详情请参阅 [引导加载程序](Bootloaders.md)。

## 如果 Raspberry Pi 崩溃，加热器会保持开启状态吗？

软件设计上防止了这种情况。一旦主机启用加热器，主机软件需要每 5 秒确认一次该启用状态。如果微控制器没有每 5 秒收到一次确认，它将进入 “关机” 状态，该状态旨在关闭所有加热器和步进电机。

有关更多详细信息，请参阅 [MCU 命令](MCU_Commands.md) 文档中的 “config_digital_out” 命令。

此外，微控制器软件在启动时为每个加热器配置了最小和最大温度范围（详见 [配置参考](Config_Reference.md#extruder) 中的 min_temp 和 max_temp 参数）。如果微控制器检测到温度超出该范围，它也会进入 “关机” 状态。

另外，主机软件还实现了代码来检查加热器和温度传感器是否正常工作。更多详细信息请参阅 [配置参考](Config_Reference.md#verify_heater)。

## 如何将 Marlin 引脚编号转换为 Klipper 引脚名称？

简短回答：映射可在 [sample-aliases.cfg](../config/sample-aliases.cfg) 文件中找到。使用该文件作为指南来查找实际的微控制器引脚名称。（也可以将相关的 [board_pins](Config_Reference.md#board_pins) 配置部分复制到您的配置文件中并在配置中使用别名，但更推荐翻译并使用实际的微控制器引脚名称。）请注意，sample-aliases.cfg 文件使用以 “ar” 而不是 “D” 开头的引脚名称（例如，Arduino 引脚 `D23` 是 Klipper 别名 `ar23`），以及以 “analog” 而不是 “A” 开头的引脚名称（例如，Arduino 引脚 `A14` 是 Klipper 别名 `analog14`）。

长回答：Klipper 使用微控制器定义的标准引脚名称。在 Atmega 芯片上，这些硬件引脚的名称如 `PA4`、`PC7` 或 `PD2`。

很久以前，Arduino 项目决定避免使用标准硬件名称，而使用基于递增数字的自己的引脚名称 —— 这些 Arduino 名称通常看起来像 `D23` 或 `A14`。这是一个不幸的选择，导致了大量的混淆。特别是，Arduino 引脚编号通常不会转换为相同的硬件名称。例如，`D21` 在一个常见的 Arduino 板上是 `PD0`，但在另一个常见的 Arduino 板上是 `PC7`。

为了避免这种混淆，Klipper 核心代码使用微控制器定义的标准引脚名称。

## 我是否必须将设备连接到特定类型的微控制器引脚？

这取决于设备类型和引脚类型：

ADC 引脚（或模拟引脚）：对于热敏电阻和类似的 “模拟” 传感器，设备必须连接到微控制器上的 “模拟” 或 “ADC” 功能引脚。如果您配置 Klipper 使用不具备模拟功能的引脚，Klipper 将报告 “Not a valid ADC pin” 错误。

PWM 引脚（或定时器引脚）：Klipper 默认不为任何设备使用硬件 PWM。因此，一般来说，可以将加热器、风扇和类似设备连接到任何通用 IO 引脚。但是，风扇和 output_pin 设备可以可选地配置为使用 `hardware_pwm: True`，在这种情况下，微控制器必须在引脚上支持硬件 PWM（否则，Klipper 将报告 “Not a valid PWM pin” 错误）。

IRQ 引脚（或中断引脚）：Klipper 不在 IO 引脚上使用硬件中断，因此永远不需要将设备连接到这些微控制器引脚之一。

SPI 引脚：使用硬件 SPI 时，必须将引脚连接到微控制器的 SPI 功能引脚。但是，大多数设备可以配置为使用 “软件 SPI”，在这种情况下可以使用任何通用 IO 引脚。

I2C 引脚：使用 I2C 时，必须将引脚连接到微控制器的 I2C 功能引脚。

其他设备可以连接到任何通用 IO 引脚。例如，步进电机、加热器、风扇、Z 探针、伺服电机、LED、常见的 hd44780/st7920 LCD 显示屏、Trinamic UART 控制线可以连接到任何通用 IO 引脚。

## 如何取消 M109/M190 “等待温度” 请求？

导航到 OctoPrint 终端选项卡并在终端框中发出 M112 命令。M112 命令将导致 Klipper 进入 “关机” 状态，并导致 OctoPrint 断开与 Klipper 的连接。导航到 OctoPrint 连接区域并单击 “连接” 以使 OctoPrint 重新连接。返回终端选项卡并发出 FIRMWARE_RESTART 命令以清除 Klipper 错误状态。完成此序列后，先前的加热请求将被取消，可以开始新的打印。

## 我能否发现打印机是否丢失了步数？

在某种程度上，可以。让打印机归位，发出 `GET_POSITION` 命令，运行您的打印，再次归位并发出另一个 `GET_POSITION` 命令。然后比较 `mcu:` 行中的值。

这可能有助于调整步进电机电流、加速度和速度等设置，而无需实际打印和浪费耗材：只需在 `GET_POSITION` 命令之间运行一些高速移动即可。

请注意，限位开关本身倾向于在稍微不同的位置触发，因此几微步的差异可能是限位开关不准确的结果。步进电机本身只能以 4 整步的增量丢失步数。（因此，如果使用 16 微步，则步进电机上的丢失步数将导致 “mcu:” 步数计数器偏离 64 微步的倍数。）

## 为什么 Klipper 报告错误？我失去了我的打印！

简短回答：我们希望知道我们的打印机是否检测到问题，以便可以修复根本原因并获得高质量的打印。我们绝对不希望我们的打印机无声地产生低质量的打印。

长回答：Klipper 被设计为自动解决许多瞬态问题。例如，它自动检测通信错误并会重新传输；它提前调度操作并在多层缓冲命令，以实现精确的定时，即使有间歇性干扰。但是，如果软件检测到无法恢复的错误、被命令执行无效操作，或检测到无法完成其命令任务，则 Klipper 将报告错误。在这些情况下，产生低质量打印（或更糟）的风险很高。希望提醒用户能够使他们修复根本问题并提高打印的整体质量。

还有一些相关问题：为什么 Klipper 不暂停打印？改为报告警告？在打印前检查错误？忽略用户输入命令中的错误？等等？目前 Klipper 使用 G-Code 协议读取命令，不幸的是，G-Code 命令协议不够灵活，今天无法使这些替代方案实用。开发人员有兴趣在异常事件期间改善用户体验，但预计这将需要显著的基础设施工作（包括从 G-Code 转移）。

## 如何升级到最新软件？

升级软件的第一步是查看最新的 [配置更改](Config_Changes.md) 文档。有时，软件的更改需要用户在软件升级时更新其设置。在升级之前查看此文档是个好主意。

准备好升级后，一般方法是通过 ssh 登录到 Raspberry Pi 并运行：

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

然后可以重新编译并刷新微控制器代码。例如：

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

然而，通常只有主机软件发生变化。在这种情况下，可以仅更新并重启主机软件：

```
cd ~/klipper
git pull
sudo service klipper restart
```

如果使用此快捷方式后，软件警告需要重新刷新微控制器或发生其他异常错误，则请遵循上述完整的升级步骤。

如果任何错误仍然存在，请再次检查 [配置更改](Config_Changes.md) 文档，因为您可能需要修改打印机配置。

请注意，RESTART 和 FIRMWARE_RESTART g-code 命令不会加载新软件 —— 上述 “sudo service klipper restart” 和 “make flash” 命令是使软件更改生效所必需的。

## 如何卸载 Klipper？

在固件端，无需特殊操作。只需遵循新固件的刷新说明。

在 Raspberry Pi 端，[scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh) 中提供了卸载脚本。例如：
```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```