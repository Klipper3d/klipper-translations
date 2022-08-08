# 常见问题

## 我如何向项目捐款？

感谢您的支持。请参阅[赞助商页面](Sponsors.md)以获取信息。

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

要在Beaglebone上运行，请参阅[Beaglebone特别安装说明](Beaglebone.md)。

Klipper 可以在其他计算机上运行。Klipper 主机软件只需要在Linux（或类似）系统的计算机上运行 Python。然而，如果你想在其他计算机上运行它，你将需要一些 Linux 管理知识来安装该计算机上系统的依赖包。参见 [install-octopi.sh](../scripts/install-octopi.sh) 脚本，以进一步了解必要的 Linux 安装方法。

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

如果你选择这样做，你将需要实现必要的启动、停止和安装脚本。[install-octopi.sh](../scripts/install-octopi.sh)和[klipper-start.sh](../scripts/klipper-start.sh)脚本提供了一些例子。

## 我必须使用 OctoPrint 吗？

Klipper 不依赖 OctoPrint。其他软件也可以向 Klipper 发送命令，但这样做可能需要一些 Linux 管理知识。

Klipper 通过 “/tmp/printer” 文件创建了一个“虚拟串口”，该文件模拟了一个标准的3D打印机串口。理论上任何能配置并使用 “/tmp/printer” 作为打印机串口的软件都可以与Klipper一起工作。

## 为什么在归位打印机之前我不能移动步进电机？

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
- 如果使用树莓派，请为树莓派使用[优质电源](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply)，并使用[优质USB电缆](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877)将该电源与Pi连接。如果你从OctoPrint得到 "电压不足 "的警告，这也与电源有关，必须解决。
- 请确保打印机的电源没有过载。(微控制器 USB 芯片的电压波动可能会导致该芯片欠压复位。)
- 确认步进电机、加热器和其他打印机电线没有被压坏或磨损。（打印机移动时可能对故障的电线施加压力，导致其失去接触、短暂短路或产生过多的噪音。）
- 有报告称，当打印机的电源和主机的5V电源混合时，USB噪音很大。(如果你发现当打印机的电源打开或USB电缆插入时，微控制器会通电，那么这表明5V电源被混用了）。配置微控制器，使其只使用一个电源可能会有帮助。(另外，如果微控制器主板不能配置其供电来源，也可以修改USB电缆，使其主机和微控制器之间不共享5V电源。）

## 我的树莓派在打印时不断重启

这很可能是由于电压波动引起的。请遵循["与MCU失去通信"](#i-keep-getting-random-lost-communication-with-mcu-errors)错误同样的故障排除步骤。

## 当设置`restart_method=command`时， AVR 设备在重启时就会死机

一些旧版本的AVR引导程序在看门狗事件处理方面有一个已知的错误。这通常表现在printer.cfg文件中的restart_method设置为 "command"的时候。当这个错误发生时，AVR设备会死机直到电源被移除并重新上电（电源或状态LED也可能不停的闪烁直到断电）。

解决办法是使用 "command "以外的重启方法，或者在AVR设备上刷写一个新的引导程序。刷写一个新的引导程序是一个一次性的步骤，通常需要一个外部编程器--更多细节请参见[Bootloaders](Bootloaders.md)。

## 如果 Raspberry Pi 崩溃了，加热器会一直加热吗？

Klipper 的设计防止了这种情况。一旦主机启用了一个加热器，主机软件需要每 5 秒钟确认一次启用状态。如果微控制器没有收到每 5 秒的确认，它就会进入"关闭"状态，该状态会关闭所有加热器和步进电机。

详情请见[MCU 命令](MCU_Commands.md)文档中的 "config_digital_out" 命令。

此外，微控制器软件在启动时为每个加热器配置了最低和最高温度范围（详见[配置参考](Config_Reference.md#extruder)中的min_temp和max_temp参数）。如果微控制器检测到温度超出了该范围，那么它也将进入 "关机 "状态。

另外，主机软件还实现了检查加热器和温度传感器是否正常工作的代码。详情见[配置参考](Config_Reference.md#verify_heater) 。

## 如何将 Marlin 引脚编号转换为 Klipper 引脚名称？

简要回答：在[sample-aliases.cfg](../config/sample-aliases.cfg)文件中有一个映射。使用该文件作为指引来寻找实际的微控制器引脚名称。(也可以将相关的[board_pins](Config_Reference.md#board_pins)配置部分复制到你的配置文件中，在你的配置中使用别名，但最好是翻译并使用实际的微控制器引脚名称。) 请注意，sample-aliases.cfg文件使用以 "ar "开头的引脚名称替换 "D"（例如，Arduino引脚`D23`是Klipper别名`ar23`）和以 "analog "开头的引脚名称替换 "A"（例如，Arduino引脚`A14`是Klipper别名`analog14`）。

详细答案：Klipper使用微控制器定义的标准引脚名称。在 Atmega 芯片上，这些硬件引脚的名称类似于`PA4`、`PC7`或`PD2`。

很久以前，Arduino项目决定避免使用标准的硬件名称，而采用他们自己的基于递增数字的引脚名称--这些Arduino名称一般看起来像`D23`或`A14`。这是一个不幸的选择，导致了大量的混乱。特别是Arduino的引脚号码经常不能转换为相同的硬件名称。例如，`D21`在一个常见的Arduino板上是`PD0`，但在另一个常见的Arduino板上是`PC7`。

为了避免这种混淆，Klipper 核心代码使用微控制器定义的标准引脚名称。

## 我必须将设备连接到特定类型的微控制器引脚吗？

这取决于设备和引脚的类型：

ADC 引脚（或模拟引脚）：热敏电阻和类似的“模拟”传感器必须连接到微控制器上具有“模拟”或“ADC”功能的引脚。如果您在 Klipper 上为一个模拟传感器配置为使用不具备模拟功能的引脚，Klipper 将报告“Not a valid ADC pin”错误。

PWM引脚（或定时器引脚）。Klipper默认不在任何设备上使用硬件PWM。因此，一般来说，可以将热端、风扇和类似的设备连接到任何的通用IO引脚。然而，风扇和output_pin设备可以选择配置为使用`hardware_pwm: True`，在这种情况下，微控制器在这个引脚上必须支持硬件PWM（否则，Klipper将报告 "不是有效的PWM引脚 "错误）。

IRQ引脚（或中断引脚）。Klipper不使用IO引脚上的硬件中断，所以没有必要将设备连接到这些微控制器引脚上。

SPI 引脚：使用硬件 SPI 时，需要将引脚连接到微控制器的 SPI 引脚。但是，大多数设备都可以配置为使用“软件 SPI”，在这种情况下，可以使用任何通用 IO 引脚。

I2C 引脚：使用 I2C 时，必须将引脚连接到微控制器支持 I2C 的引脚。

其他设备可以连接到任何通用的IO引脚。例如，步进电机、加热器、风扇、Z探头、舵机、LED、通用的hd44780/st7920液晶显示器和Trinamic UART控制线都可以连接到任何通用的IO引脚。

## 如何取消 M109/M190 "等待达到目标温度"的请求？

导航到OctoPrint终端标签页，在终端框中输入M112命令。M112命令将使Klipper进入 "关机 "状态，它将使OctoPrint从Klipper断开。导航到OctoPrint连接区，点击 "连接"，使OctoPrint重新连接。导航回到终端标签页，输入FIRMWARE_RESTART命令以清除Klipper的错误状态。完成这一系列操作将取消先前的加热请求，可以开始新的打印。

## 怎么检查打印机是否发生了丢步?

在某种程度上，是的。将打印机归位，发出 `GET_POSITION `命令，运行打印，再次归位，再发出 `GET_POSITION`。然后比较 `mcu: `行中的值。

这可能有助于调整步进电机电流、加速度和速度等设置，而不需要实际打印东西和浪费材料：只要在 `GET_POSITION `命令之间运行一些高速移动。

请注意，限位开关本身的触发位置略有不同，所以导致限位开关触发结果可能有几个微步的误差。步进电机本身只能以4个整步为增量损失步数。(因此，如果使用16个微步，那么步进器电机上的失步将导致 "MCU: "步进计数器偏离64微步的倍数。）

## 为什么 Klipper 会报错？我收了一盘面条（我又打废了）！

简短的回答：我们想知道打印机是否检测到问题，这样就可以解决潜在的问题，就可以获得高质量的打印件。我们绝对不希望打印机默默地生产低质量的打印件。

详细答案：Klipper被设计成能够自动解决许多瞬时问题。例如，它自动检测到通信错误，并会重新传输；它提前安排行动，并在多层缓冲命令，以便即使有间歇性干扰也能精确控制时序。然而，如果软件检测到它无法恢复的错误，或者它被命令采取无效的行动，或者它检测到它无法执行其被命令的任务，那么Klipper将报告错误。在这些情况下，产生低质量印刷件（或更糟）的风险很大。我们希望通过提醒用户，使他们有能力解决潜在的问题，提高打印的整体质量。

有一些相关的问题。为什么Klipper不暂停打印？为什么不先警告？为什么不在打印前检查错误？为什么不忽略用户输入的命令中的错误？等等？目前，Klipper使用G-Code协议读取命令，不幸的是，G-Code命令协议不够灵活，导致现在并不能使用这些替代方案。开发者对改善异常事件中的用户体验很感兴趣，但预计这将需要大量的底层工作（包括从G-Code的迁移到别的方式）。

## 我怎样才能升级到最新的软件？

升级软件的第一步是查看最新的[配置变更](Config_Changes.md)文件。作为软件升级的一部分，偶尔有时候软件会有一些变化需要用户更新他们的设置。在升级前最好查看该文件。

当准备升级时，一般的方法是ssh进入树莓派并运行：

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

然后可以重新编译和刷写微控制器的代码。例如：

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

然而，通常是只有主机软件发生变化。这时可以只更新和重新启动主机软件：

```
cd ~/klipper
git pull
sudo service klipper restart
```

如果在使用这个快速方式后，软件警告说需要重新刷写微控制器或出现其他不常见的错误，那么请按照上面所述的完整升级步骤进行。

如果任何错误持续存在，那么请仔细检查[config changes](Config_Changes.md)文件，因为可能需要修改打印机配置。

请注意，RESTART和FIRMWARE_RESTART g-code命令不会加载新的软件--需要使用上述 "sudo service klipper restart "和 "make flash "命令才能使软件变化生效。

## 如何卸载Klipper？

在固件端，没有什么特别需要做的。只要刷写新固件就可以了。

在树莓派上，卸载脚本在这里[scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh)。例如：

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
