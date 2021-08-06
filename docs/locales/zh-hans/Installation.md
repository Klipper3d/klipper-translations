# 安装

本教程假定软件将会在树莓派上和 Octoprint 一起运行。推荐使用树莓派2/3/4作为主机（关于其他设备，请见[常见问题](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)）。

Klipper目前支持数种基于Atmel ATmega的微控制器、[基于ARM的微控制器](Features.md#step-benchmarks)、和[Beaglebone可编程实时单元](beaglebone.md)的打印机。

## 准备操作系统镜像

先在树莓派上安装 [OctoPi](https://github.com/guysoft/OctoPi)。使用OctoPi v0.17.0或更高版本，查看 [Octopi 发行版](https://github.com/guysoft/OctoPi/releases)来获取最新的发布版。安装完系统后，请先验证 OctoPi 能正常启动，并且 OctoPrint 网络服务器正常运行。连接到 OctoPrint 网页后，按照提示将 OctoPrint 更新到v1.4.2或更高版本。

在安装 OctoPi 和升级 OctoPrint后，用 ssh 进入目标设备，以运行少量的系统命令。如果使用Linux或MacOS系统，那么 "ssh"软件应该已经预装在系统上。有一些免费的ssh客户端可用于其他操作系统（例如，[PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)）。使用ssh工具连接到Raspberry Pi（ssh pi@octopi --密码是 "raspberry"），并运行以下命令：

```
git clone https://github.com/KevinOConnor/klipper
./klipper/scripts/install-octopi.sh
```

以上将会下载 Klipper 、安装一些系统依赖、设置 Klipper 在系统启动时运行并启动Klipper 主机程序。这将需要互联网连接以及可能需要几分钟时间才能完成。

## 构建和刷写微控制器

在编译微控制器代码之前，首先在树莓派上运行这些命令：

```
cd ~/klipper/
make menuconfig
```

选择恰当的微控制器并复查提供的其他选项。配置好后，运行：

```
make
```

必须先确定连接到微控制器的串行端口。对于通过 USB 连接的微控制器，运行以下命令：

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

Klipper configuration 存储在Raspberry Pi上的一个文本文件中。看一下[config directory](../config/)。[config reference](Config_Reference.md)包含了config parameters.

可以说，更新Klipper configuration 文件的最简单方法是使用一个支持通过 "scp "或 "sftp "协议编辑文件的桌面编辑器。有一些免费的工具支持这个功能（例如，Notepad++、WinSCP和Cyberduck）。使用其中一个配置文件的例子作为起点，并将其保存为pi用户的主目录中名为 "printer.cfg "的文件（例如，/home/pi/printer.cfg）。

另外，也可以通过ssh在Raspberry Pi上直接复制和编辑该文件。比如说：

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

确保你检查和更新每一个设置并且与硬件相符合。

通常每台打印机都有自己独特的微控制器名称。刷写Klipper后这个名字可能会改变，所以重新运行`ls /dev/serial/by-id/*`命令，然后用这个唯一的名字更新配置文件。例如，更新"[mcu]"部分，看起来类似于:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

在创建和编辑该文件后，有必要在OctoPrint网络终端发出 "restart"命令去重新加载config。"status" 命令将报告打印机已准备就绪。在初始设置期间出现配置错误是很正常的。更新打印机配置文件并发出 "restart"命令，直到 "状态 "报告打印机已准备就绪。

Klipper通过OctoPrint终端标签报告错误信息。可以使用 "status "命令来重新报告错误信息。默认的Klipper启动脚本也在**/tmp/klippy.log**中放置一个日志，提供更详细的信息。

除此之外常见的g-code命令之外，Klipper还支持一些扩展命令"status "和 "restart "就是这些命令的例子。使用 "help "命令可以获得其他扩展命令的列表。

在Klipper反馈打印机已经准备好后，进入[config check document](Config_checks.md)对配置文件中的引脚定义进行一些基本检查。

## 联系开发者

请务必查看[FAQ](FAQ.md)，了解一些常见问题的答案。请参阅[联系页面](Contact.md)来报告一个错误或联系开发者。
