# 安装

这些说明假设软件将在运行 Klipper 兼容前端的基于 Linux 的主机上运行。建议使用树莓派或基于 Debian 的 Linux 设备等小型单板计算机（SBC）作为主机（有关其他选项，请参见[常见问题解答](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)）。

在本说明中，“主机”指 Linux 设备，“mcu”指打印机控制板。“SBC”指小型单板计算机，例如树莓派。

## 获取 Klipper 配置文件

Klipper 的大多数设置由一个名为“printer.cfg”的“打印机配置文件”确定，该文件将存储在主机上。通常可以通过在 Klipper 的[配置目录](../config/)中查找以“printer-”开头且对应目标打印机的文件来找到合适的配置文件。Klipper 配置文件包含安装过程中所需的打印机技术信息。

如果 Klipper 配置目录中没有合适的打印机配置文件，则尝试搜索打印机制造商的网站，查看是否有合适的 Klipper 配置文件。

如果找不到打印机的配置文件，但已知打印机控制板的类型，则查找以“generic-”开头的合适[配置文件](../config/)。这些示例打印机板文件应能帮助您成功完成初始安装，但需要进行一些自定义才能实现打印机的全部功能。

也可以从头开始定义新的打印机配置。然而，这需要对打印机及其电子元件有相当深入的技术知识。建议大多数用户从合适的配置文件开始。如果要创建新的自定义打印机配置文件，请从最接近的示例[配置文件](../config/)开始，并参考 Klipper 的[配置参考](Config_Reference.md)获取更多信息。

## 与 Klipper 交互

Klipper 是一种 3D 打印机固件，因此需要某种方式供用户与其交互。

目前最佳选择是通过 [Moonraker 网络 API](https://moonraker.readthedocs.io/) 获取信息的前端，也可以选择使用 [Octoprint](https://octoprint.org/) 来控制 Klipper。

使用何种前端由用户自行决定，但在所有情况下底层的 Klipper 都是相同的。我们鼓励用户研究可用选项并做出明智的选择。

## 获取 SBC 的操作系统镜像

为 SBC 获取用于 Klipper 的操作系统镜像的方法有很多，具体取决于您希望使用的前端。一些 SBC 板制造商也提供以 Klipper 为中心的预配置镜像。

两个主要的基于 Moonraker 的前端是 [Fluidd](https://docs.fluidd.xyz/) 和 [Mainsail](https://docs.mainsail.xyz/)，后者提供了预配置的安装镜像 ["MainsailOS"](https://docs-os.mainsail.xyz/)，支持树莓派和一些 OrangePi 变体。

Fluidd 可通过 KIAUH（Klipper 安装与更新助手）安装，这将在下文说明，KIAUH 是用于所有 Klipper 相关操作的第三方安装程序。

OctoPrint 可通过流行的 OctoPi 镜像或通过 KIAUH 安装，该过程在 [OctoPrint.md](OctoPrint.md) 中有说明。

## 通过 KIAUH 安装

通常，您应从 SBC 的基础镜像开始，例如 RPiOS Lite，或者对于 x86 Linux 设备，使用 Ubuntu Server。请注意，不推荐使用桌面版本，因为某些辅助程序可能会阻止 Klipper 某些功能的正常运行，甚至屏蔽对某些打印机板的访问。

KIAUH 可用于在运行 Debian 系统的各种基于 Linux 的系统上安装 Klipper 及其相关程序。更多信息请访问 https://github.com/dw-0/kiauh

## 编译并刷写微控制器

要编译微控制器代码，请在主机设备上运行以下命令：

```
cd ~/klipper/
make menuconfig
```

[打印机配置文件](#obtain-a-klipper-configuration-file) 顶部的注释应描述在 "make menuconfig" 期间需要设置的选项。在网页浏览器或文本编辑器中打开该文件，并在文件顶部附近查找这些说明。配置好相应的 "menuconfig" 设置后，按 "Q" 键退出，然后按 "Y" 键保存。然后运行：

```
make
```

如果 [打印机配置文件](#obtain-a-klipper-configuration-file) 顶部的注释描述了将最终镜像“刷写”到打印机控制板的自定义步骤，则请遵循这些步骤，然后继续进行 [配置 OctoPrint](#configuring-octoprint-to-use-klipper)。

否则，通常使用以下步骤来“刷写”打印机控制板。首先，需要确定连接到微控制器的串口。运行以下命令：

```
ls /dev/serial/by-id/*
```

它应报告类似以下内容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

每个打印机通常都有其独特的串口名称。此唯一名称将在刷写微控制器时使用。上述输出中可能有多个行——如果有，请选择对应微控制器的那一行。如果有多个设备列出且选择不明确，可先拔下控制板，再次运行该命令，消失的设备即为您的打印板（更多信息请参见[常见问题解答](FAQ.md#wheres-my-serial-port)）。

对于使用 STM32 或兼容芯片、LPC 芯片等常见微控制器，通常需要通过 SD 卡进行首次 Klipper 刷写。

使用此方法刷写时，重要的是确保打印板未通过 USB 连接到主机，因为某些板卡可能会向自身反向供电，从而阻止刷写操作。

请注意，大多数使用 SD 卡刷写的打印板会实现某种刷写循环保护机制，当 SD 卡留在原位时生效。有两种常见方法：

**需要更改文件名**（通常为“原厂”打印板）：

这些板卡要求每次刷写时固件文件具有不同的名称（例如，firmware1.bin、firmware2.bin 等）。如果重复使用相同的文件名，板卡可能会忽略该文件而不进行更新。

**自动文件重命名**（通常为售后市场打印板）：

其他板卡允许使用相同的文件名，通常为 firmware.bin，但刷写后，板卡会将文件重命名为 firmware.cur。这有助于指示固件已成功刷写，并防止下次启动时再次刷写。

刷写前，请务必检查您的板卡遵循哪种行为。

对于使用 Atmega 芯片（例如 2560）的常见微控制器，可以使用类似以下命令刷写代码：

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

请务必将 FLASH_DEVICE 替换为打印机的唯一串口名称。

对于使用 RP2040 芯片的常见微控制器，可以使用类似以下命令刷写代码：

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

需要注意的是，RP2040 芯片在执行此操作前可能需要进入 Boot 模式。

## 配置 Klipper

下一步是将 [打印机配置文件](#obtain-a-klipper-configuration-file) 复制到主机。

设置 Klipper 配置文件最简单的方法可能是使用 Mainsail 或 Fluidd 中内置的编辑器。这些工具允许用户打开配置示例并将其保存为 printer.cfg。

另一种选择是使用支持通过“scp”和/或“sftp”协议编辑文件的桌面编辑器。有许多免费工具支持此功能（例如 Notepad++、WinSCP 和 Cyberduck）。在编辑器中加载打印机配置文件，然后将其保存为 pi 用户主目录中的“printer.cfg”文件（即 /home/pi/printer.cfg）。

或者，也可以通过 SSH 直接在主机上复制并编辑该文件。可能看起来像以下内容（请确保更新命令以使用适当的打印机配置文件名）：

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

每个打印机通常都有自己唯一的微控制器名称。刷写 Klipper 后名称可能会改变，因此即使之前刷写时已执行过这些步骤，也需要重新运行。运行：

```
ls /dev/serial/by-id/*
```

它应报告类似以下内容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

然后使用唯一名称更新配置文件。例如，更新 `[mcu]` 部分，使其看起来类似：

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

创建并编辑文件后，需要在命令控制台中发出“restart”命令以加载配置。“status”命令将在 Klipper 配置文件成功读取且微控制器成功找到并配置时报告打印机已就绪。

在自定义打印机配置文件时，Klipper 报告配置错误的情况并不少见。如果出现错误，请对打印机配置文件进行必要的更正，并发出“restart”命令，直到“status”报告打印机已就绪。

Klipper 通过命令控制台以及 Fluidd 和 Mainsail 中的弹窗报告错误消息。“status”命令可用于重新报告错误消息。日志文件通常位于 `~/printer_data/logs/klippy.log`。

在 Klipper 报告打印机就绪后，请继续阅读[配置检查文档](Config_checks.md)，对配置文件中的定义执行一些基本检查。有关其他信息，请参见主[文档参考](Overview.md)。