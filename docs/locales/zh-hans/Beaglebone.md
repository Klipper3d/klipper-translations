# Beaglebone

本文档描述了在 Beaglebone 可编程实时单元上运行 Klipper 的过程。

## 构建一个操作系统镜像

首先安装[Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images)镜像。可以从micro-SD卡或内置的eMMC中运行该镜像。如果使用eMMC，现在需要按照上述链接的说明将其安装到eMMC。

Then ssh into the Beaglebone machine (`ssh debian@beaglebone` -- password is `temppwd`) and install Klipper by running the following commands:

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

It is necessary to modify OctoPrint's **/etc/default/octoprint** configuration file. One must change the `OCTOPRINT_USER` user to `debian`, change `NICELEVEL` to `0`, uncomment the `BASEDIR`, `CONFIGFILE`, and `DAEMON` settings and change the references from `/home/pi/` to `/home/debian/`:

```
sudo nano /etc/default/octoprint
```

然后启动 Octoprint 服务：

```
sudo systemctl start octoprint
```

Make sure the OctoPrint web server is accessible - it should be at: <http://beaglebone:5000/>

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

It is also necessary to compile and install the micro-controller code for a Linux host process. Configure it a second time for a "Linux process":

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

Complete the installation by configuring Klipper and Octoprint following the instructions in the main [Installation](Installation.md#configuring-klipper) document.

## 在 Beaglebone 上打印

Unfortunately, the Beaglebone processor can sometimes struggle to run OctoPrint well. Print stalls have been known to occur on complex prints (the printer may move faster than OctoPrint can send movement commands). If this occurs, consider using the "virtual_sdcard" feature (see [Config Reference](Config_Reference.md#virtual_sdcard) for details) to print directly from Klipper.
