# Beaglebone

本文档描述了在 Beaglebone 可编程实时单元上运行 Klipper 的过程。

## 构建一个操作系统镜像

首先安装[Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images)镜像。可以从micro-SD卡或内置的eMMC中运行该镜像。如果使用eMMC，现在需要按照上述链接的说明将其安装到eMMC。

然后 ssh 进入 Beaglebone 机器（ssh debian@beaglebone -- 密码是 "temppwd"），通过运行以下命令安装 Klipper：

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-beaglebone.sh
```

## 安装 Octoprint

然后可以安装 Octoprint：

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

和设置 Octoprint 开始启动：

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

有必要修改OctoPrint的 **/etc/default/octoprint** 配置文件。我们必须把 OCTOPRINT_USER 用户改为 "debian"，把 NICELEVEL 改为 0 ，取消注释 BASEDIR、CONFIGFILE 和 DAEMON 的设置，并把引用从"/home/pi/"改为"/home/debian/"：

```
sudo nano /etc/default/octoprint
```

然后启动 Octoprint 服务：

```
sudo systemctl start octoprint
```

确保可以访问 OctoPrint 网络服务器 - 它应该在以下位置： <http://beaglebone:5000/>

## 构建微控制器代码

要编译的 Klipper 微控制器代码，需要先将编译配置设为“Beaglebone PRU”：

```
cd ~/klipper/
make menuconfig
```

要构建和安装新的微控制器代码，请运行：

```
sudo service klipper stop
make flash
sudo service klipper start
```

还需要编译和安装用于 Linux 主机进程的微控制器代码。再次运行 "make menuconfig"，并将其配置为"Linux process"：

```
make menuconfig
```

然后也安装这个微控制器代码：

```
sudo service klipper stop
make flash
sudo service klipper start
```

## 剩余的配置

根据[总安装文档](Installation.md#configuring-klipper)来配置 Klipper 和 Octoprint 来完成安装。

## 在 Beaglebone 上打印

不幸的是，Beaglebone 处理器有时难以很好地运行 OctoPrint。据了解，在复杂的打印中会出现打印停滞（打印机的移动速度可能比 OctoPrint 发送的移动命令快）。如果发生这种情况，可以考虑使用 "virtual_sdcard" 功能（详见[配置参考](Config_Reference.md#virtual_sdcard)），直接从 Klipper 打印。
