# 安装

本教程假定软件将会在树莓派上和 Octoprint 一起运行。推荐使用树莓派2/3/4作为主机（关于其他设备，请见[常见问题](FAQ.md#我可以在-Raspberry-Pi-3-以外的其他设备上运行-Klipper-吗？)）。

## Obtain a Klipper Configuration File

Most Klipper settings are determined by a "printer configuration file" that will be stored on the Raspberry Pi. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

If there isn't an appropriate printer configuration file in the Klipper config directory then try searching the printer manufacturer's website to see if they have an appropriate Klipper configuration file.

If no configuration file for the printer can be found, but the type of printer control board is known, then look for an appropriate [config file](../config/) starting with a "generic-" prefix. These example printer board files should allow one to successfully complete the initial installation, but will require some customization to obtain full printer functionality.

It is also possible to define a new printer configuration from scratch. However, this requires significant technical knowledge about the printer and its electronics. It is recommended that most users start with an appropriate configuration file. If creating a new custom printer configuration file, then start with the closest example [config file](../config/) and use the Klipper [config reference](Config_Reference.md) for further information.

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

The comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) should describe the settings that need to be set during "make menuconfig". Open the file in a web browser or text editor and look for these instructions near the top of the file. Once the appropriate "menuconfig" settings have been configured, press "Q" to exit, and then "Y" to save. Then run:

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Otherwise, the following steps are often used to "flash" the printer control board. First, it is necessary to determine the serial port connected to the micro-controller. Run the following:

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

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the Raspberry Pi.

Arguably the easiest way to set the Klipper configuration file is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the Raspberry Pi via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

It's common for each printer to have its own unique name for the micro-controller. The name may change after flashing Klipper, so rerun these steps again even if they were already done when flashing. Run:

```
ls /dev/serial/by-id/*
```

它应该报告类似以下的内容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Then update the config file with the unique name. For example, update the `[mcu]` section to look something similar to:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the OctoPrint web terminal to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

When customizing the printer config file, it is not uncommon for Klipper to report a configuration error. If an error occurs, make any necessary corrections to the printer config file and issue "restart" until "status" reports the printer is ready.

Klipper通过OctoPrint终端标签报告错误信息。可以使用 "status "命令来重新报告错误信息。默认的Klipper启动脚本也在**/tmp/klippy.log**中放置一个日志，提供更详细的信息。

After Klipper reports that the printer is ready, proceed to the [config check document](Config_checks.md) to perform some basic checks on the definitions in the config file. See the main [documentation reference](Overview.md) for other information.
