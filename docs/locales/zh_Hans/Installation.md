# 安装

本教程假定软件将会在树莓派上和 Octoprint 一起运行。推荐使用树莓派2/3/4作为主机（关于其他设备，请见[常见问题](FAQ.md#我可以在-Raspberry-Pi-3-以外的其他设备上运行-Klipper-吗？)）。

## 获取 Klipper 配置文件

大多数的 Klipper 设置是由保存在树莓派上的"打印机配置文件"决定的。通常可以在Klipper [配置文件夹](../config/)中找到一个以"printer-"前缀开头并与目标打印机相对应的配置文件。Klipper 配置文件包含安装过程中需要的打印机技术信息。

如果 Klipper 配置目录中没有合适的打印机配置文件，请尝试搜索打印机制造商的网站，看看他们是否有合适的 Klipper 配置文件。

如果找不到打印机的配置文件，但可以找到打印机控制板的类型，则可以查找以“generic-”前缀开头的适当 [配置文件](../config/)。这些示例打印机模板文件应该足以成功完成初始安装，但需要进行一些自定义才能获得完整的打印机功能。

也可以从头开始定义一个新的打印机配置。然而，这需要关于打印机及其电子系统的大量技术知识。建议大多数用户从一个适当的配置文件开始。如果需要创建一个新的自定义打印机配置文件，那么可以先从最接近的[配置文件](./config/)的例子开始，并从 Klipper [配置参考文档](Config_Reference.md)了解进一步信息。

## 准备操作系统镜像

先在树莓派上安装 [OctoPi](https://github.com/guysoft/OctoPi)。请使用OctoPi v0.17.0或更高版本，查看 [Octopi 发行版](https://github.com/guysoft/OctoPi/releases)来获取最新发布版本。安装完系统后，请先验证 OctoPi 能正常启动，并且 OctoPrint 网络服务器正常运行。连接到 OctoPrint 网页后，按照提示将 OctoPrint 更新到v1.4.2或更高版本。

在安装 OctoPi 和升级 OctoPrint 后，用 ssh 连接目标设备，以运行少量的系统命令。如果使用Linux或MacOS系统，那么 "ssh"软件应该已经预装在系统上。有一些免费的ssh客户端可用于其他操作系统（例如，[PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)）。使用ssh工具连接到Raspberry Pi（ssh pi@octopi --密码是 "raspberry"），并运行以下命令：

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

以上将会下载 Klipper 、安装一些系统依赖、设置 Klipper 在系统启动时运行并启动Klipper 主机程序。这将需要互联网连接以及可能需要几分钟时间才能完成。

## 构建和刷写微控制器

在编译微控制器代码之前，先在树莓派上运行这些命令：

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

通常每一个打印机都有自己独特的串口名，这个独特串口名将会在刷写微处理器时用到。在上述输出中可能有多行。如果是这样的话选择与微控制器相应的 (查看[FAQ](FAQ.md#wheres-my-serial-port)了解更多信息).

对于常见的微控制器，可以用类似以下的方法来刷写固件：

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

请务必用打印机的唯一串行端口名称来更新 FLASH_DEVICE 参数。

第一次刷写时要确保 OctoPrint 没有直接连接到打印机（在 OctoPrint 网页的 "连接 "分段中点击 "断开连接"）。

## 为Klipper配置 OctoPrint

OctoPrint网络服务器需要进行配置，以便与Klipper host 软件进行通信。使用网络浏览器，登录到OctoPrint网页，然后配置以下项目：

导航到 "设置 "（页面顶部的扳手图标）。在 "串行连接 "下的 "附加串行端口 "中添加"/tmp/printer"。然后点击 "保存"。

再次进入 "设置"，在 "串行连接" 下将 "串行端口" 设置改为"/tmp/printer"。

在 "设置 "中，浏览到 "Behavior "子选项卡，选择 "取消任何正在进行的打印，但保持与打印机的连接 "选项。点击 "保存"。

在主页上，在 "连接 "部分（在页面的左上方），确保 "串行端口 "被设置为"/tmp/printer"，然后点击 "连接"。(如果"/tmp/printer "不是一个可用的选择，那么试着重新加载页面)

连接后，导航到 "终端 "选项卡，在命令输入框中输入 "status"（不带引号），然后点击 "发送"。终端窗口可能会报告在打开配置文件时出现了错误--这意味着 OctoPrint 与 Klipper 成功地进行了通信。继续下一部分。

## 配置 Klipper

下一步是将[打印机配置文件](#obtain-a-klipper-configuration-file)复制到Raspberry Pi。

编写 Klipper 配置文件的最简单方法是使用支持通过“scp”和/或“sftp”协议编辑文件的桌面编辑器。一些免费提供的工具支持这一点（例如，Notepad ++，WinSCP和Cyberduck）。在编辑器中加载打印机配置文件，然后将其另存为 pi 用户主目录中名为“printer.cfg”的文件（即 /home/pi/printer.cfg）。

另外，也可以通过 ssh 在树莓派上直接复制和编辑该文件。这可能看起来像下面这样（请确保更新命令以使用适当的打印机配置文件）：

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

在创建和编辑该文件后，必须在OctoPrint网络终端发出"restart"命令以加载配置。如果Klipper配置文件被成功读取，并且成功找到并配置了微控制器，那么"status"命令将报告打印机已准备就绪。

在定制打印机配置文件时，Klipper 报告配置错误是很正常的情况。如果发生错误，请对打印机配置文件进行必要的修正，并发出"restart"，直到"status"报告打印机已准备就绪。

Klipper通过OctoPrint终端标签报告错误信息。可以使用 "status "命令来重新报告错误信息。默认的Klipper启动脚本也在**/tmp/klippy.log**中放置一个日志，提供更详细的信息。

在Klipper报告打印机已就绪后，继续进入[配置检查文件](Config_checks.md)，对配置文件中的定义进行一些基本检查。其他信息见主[文档参考](Overview.md)。
