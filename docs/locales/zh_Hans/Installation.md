# 安装

这些说明假设软件将在运行 Klipper 兼容前端的 Linux 主机上运行。建议使用 SBC（小型板计算机），例如 Raspberry Pi 或基于 Debian 的 Linux 设备作为主机（有关其他选项，请参阅 [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)）。

就本说明而言，主机与 Linux 设备相关，而 mcu 与印刷电路板相关。SBC 与术语“小型板计算机”相关，例如 Raspberry Pi。

## 获取 Klipper 配置文件

大多数 Klipper 设置由“打印机配置文件”printer.cfg 决定，该文件将存储在主机上。通常可以通过在 Klipper [config 目录](../config/) 中查找以“printer-”前缀开头且与目标打印机相对应的文件来找到适当的配置文件。Klipper 配置文件包含安装过程中需要的有关打印机的技术信息。

如果 Klipper 配置目录中没有合适的打印机配置文件，请尝试搜索打印机制造商的网站，看看他们是否有合适的 Klipper 配置文件。

如果找不到打印机的配置文件，但可以找到打印机控制板的类型，则可以查找以“generic-”前缀开头的适当 [配置文件](../config/)。这些示例打印机模板文件应该足以成功完成初始安装，但需要进行一些自定义才能获得完整的打印机功能。

也可以从头开始定义一个新的打印机配置。然而，这需要关于打印机及其电子系统的大量技术知识。建议大多数用户从一个适当的配置文件开始。如果需要创建一个新的自定义打印机配置文件，那么可以先从最接近的[配置文件](../config/)的例子开始，并从 Klipper [配置参考文档](Config_Reference.md)了解进一步信息。

## 与 Klipper 交互

Klipper 是一个 3D 打印机固件，因此需要某种方式让用户与其进行交互。

目前最好的选择是通过 [Moonraker web API](https://moonraker.readthedocs.io/) 检索信息的前端，也可以选择使用 [Octoprint](https://octoprint.org/) 来控制 Klipper。

用户可自行选择使用哪种工具，但底层的 Klipper 在所有情况下都是相同的。我们鼓励用户研究可用的选项并做出明智的决定。

## 获取 SBC 的操作系统映像

有多种方法可以获取用于 SBC 的 Klipper 操作系统映像，大多数方法取决于您希望使用哪种前端。这些 SBC 板的一些制造商还提供自己的以 Klipper 为中心的映像。

两个主要的基于 Moonraker 的前端是 [Fluidd](https://docs.fluidd.xyz/) 和 [Mainsail](https://docs.mainsail.xyz/)，后者具有预制的安装映像 ["MainsailOS"](http://docs.mainsailOS.xyz)，它有适用于 Raspberry Pi 和一些 OrangePi 变体的选项。

Fluidd 可以通过 KIAUH（Klipper 安装和更新助手）进行安装，如下所述，它是所有 Klipper 的第三方安装程序。

OctoPrint 可以通过流行的 OctoPi 镜像或通过 KIAUH 安装，此过程在 <OctoPrint.md> 中有说明

## 通过 KIAUH 安装

通常，您会从 SBC 的基本映像（例如 RPiOS Lite）开始，或者在 x86 Linux 设备的情况下，从 Ubuntu Server 开始。请注意，不建议使用桌面版本，因为某些辅助程序可能会阻止某些 Klipper 功能运行，甚至屏蔽对某些打印板的访问。

KIAUH 可用于在运行 Debian 的各种 Linux 系统上安装 Klipper 及其相关程序。更多信息请访问 https://github.com/dw-0/kiauh

## 构建和刷写微控制器

要编译微控制器代码，首先在主机设备上运行以下命令：

```
cd ~/klipper/
make menuconfig
```

[打印机配置文件](#obtain-a-klipper-configuration-file)的顶部注释应该描述了"make menuconfig"期间需要设置的设置。在网络浏览器或文本编辑器中打开该文件，在文件顶部附近寻找这些说明。一旦适当的"menuconfig"设置被配置好了，按"Q"退出，然后按"Y"保存，运行：

```
make
```

如果[打印机配置文件](#obtain-a-klipper-configuration-file)顶部的注释描述了"flashing"最终固件镜像到打印机控制板的特殊步骤，那么请遵循这些步骤，然后继续进行[配置OctoPrint](#configuring-octoprint-to-use-klipper)。

否则，通常采用以下步骤来"flash"打印机控制板。首先，需要确定连接到微控制器的串行端口。然后，运行以下程序：

```
ls /dev/serial/by-id/*
```

它应该报告类似以下的内容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

通常，每台打印机都有自己独特的串行端口名称。此唯一名称将在刷新微控制器时使用。上面的输出中可能有多行 - 如果是这样，请选择与微控制器相对应的行。如果列出了许多项目并且选择不明确，请拔下电路板并再次运行命令，缺少的项目将是您的打印板（有关更多信息，请参阅 [FAQ](FAQ.md#wheres-my-serial-port)）。

对于带有 STM32 或克隆芯片、LPC 芯片和其他芯片的常见微控制器，通常需要通过 SD 卡进行初始 Klipper 闪存。

使用此方法进行刷写时，务必确保打印板未通过 USB 连接到主机，因为某些电路板能够将电源反馈给电路板并阻止刷写开始。

对于使用 Atmega 芯片的常见微控制器，例如 2560，代码可以使用类似以下内容进行烧录：

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

请务必用打印机的唯一串行端口名称来更新 FLASH_DEVICE 参数。

对于使用 RP2040 芯片的常见微控制器，代码可以使用类似以下方式烧录：

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

It is important to note that RP2040 chips may need to be put into Boot mode before this operation.

## 配置 Klipper

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the host.

Arguably the easiest way to set the Klipper configuration file is using the built in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Another option is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

通常每台打印机都有自己独特的微控制器名称。刷写Klipper后，名称可能会改变，所以即使在闪存时已经完成，也要重新运行这些步骤。运行：

```
ls /dev/serial/by-id/*
```

它应该报告类似以下的内容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

然后用这个唯一的名字更新配置文件。例如，更新`[mcu]`部分，类似于：

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

在定制打印机配置文件时，Klipper 报告配置错误是很正常的情况。如果发生错误，请对打印机配置文件进行必要的修正，并发出"restart"，直到"status"报告打印机已准备就绪。

Klipper reports error messages via the command console and via pop up in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located in ~/printer_data/logs this is named klippy.log

在Klipper报告打印机已就绪后，继续进入[配置检查文件](Config_checks.md)，对配置文件中的定义进行一些基本检查。其他信息见主[文档参考](Overview.md)。
