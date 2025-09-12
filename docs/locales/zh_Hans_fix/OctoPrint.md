# 适用于 Klipper 的 OctoPrint

Klipper 有几种前端选项，OctoPrint 是 Klipper 最初和最早的前端。本文档将简要概述使用此选项的安装方法。

## 使用 OctoPi 安装

首先在树莓派计算机上安装 [OctoPi](https://github.com/guysoft/OctoPi)。请使用 OctoPi v0.17.0 或更高版本——有关发布信息，请参阅 [OctoPi 发布页面](https://github.com/guysoft/OctoPi/releases)。

应验证 OctoPi 是否成功启动，并且 OctoPrint 网页服务器是否正常工作。连接到 OctoPrint 网页后，如果需要，请按照提示升级 OctoPrint。

安装 OctoPi 并升级 OctoPrint 后，需要通过 ssh 登录到目标机器以运行几个系统命令。

首先，在您的主机设备上运行以下命令：

__如果没有安装 git，请先安装：__
```
sudo apt install git
```
然后继续执行：
```
cd ~
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

上述命令将下载 Klipper，安装所需的系统依赖项，设置 Klipper 在系统启动时自动运行，并启动 Klipper 主机软件。此过程需要互联网连接，可能需要几分钟才能完成。

## 使用 KIAUH 安装

KIAUH 可用于在各种基于 Linux 且运行 Debian 系统的设备上安装 OctoPrint。更多信息请访问 https://github.com/dw-0/kiauh

## 配置 OctoPrint 以使用 Klipper

OctoPrint 网页服务器需要配置为与 Klipper 主机软件通信。使用网页浏览器登录 OctoPrint 网页，然后配置以下项目：

导航到“设置”选项卡（页面顶部的扳手图标）。在“串行连接”下的“其他串行端口”中添加：

```
~/printer_data/comms/klippy.serial
```
然后点击“保存”。

_在一些较旧的设置中，此地址可能是 `/tmp/printer`_

再次进入“设置”选项卡，在“串行连接”下将“串行端口”设置为上面添加的端口。

在“设置”选项卡中，导航到“行为”子选项卡，并选择“取消任何正在进行的打印但仍保持与打印机的连接”选项。点击“保存”。

从主页面开始，在“连接”部分（位于页面左上角）确保“串行端口”设置为新添加的端口，然后点击“连接”。（如果未在可用选项中显示，请尝试重新加载页面。）

连接后，转到“终端”选项卡，在命令输入框中键入 "status"（不带引号），然后点击“发送”。终端窗口可能会报告打开配置文件时出错——这表示 OctoPrint 已成功与 Klipper 通信。

请继续阅读 [Installation.md](Installation.md) 中的 _构建和刷写微控制器_ 部分。