# Beaglebone

本文档描述了在 Beaglebone 可编程实时单元上运行 Klipper 的过程。

## 构建一个操作系统镜像

Start by installing the [Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images) image. One may run the image from either a micro-SD card or from builtin eMMC. If using the eMMC, install it to eMMC now by following the instructions from the above link.

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

It is necessary to modify OctoPrint's **/etc/default/octoprint** configuration file. One must change the OCTOPRINT_USER user to "debian", change NICELEVEL to 0, uncomment the BASEDIR, CONFIGFILE, and DAEMON settings and change the references from "/home/pi/" to "/home/debian/":

```
sudo nano /etc/default/octoprint
```

然后启动 Octoprint 服务：

```
sudo systemctl start octoprint
```

Make sure the octoprint web server is accessible - it should be at: <http://beaglebone:5000/>

## 构建微控制器代码

To compile the Klipper micro-controller code, start by configuring it for the "Beaglebone PRU":

```
cd ~/klipper/
make menuconfig
```

To build and install the new micro-controller code, run:

```
sudo service klipper stop
make flash
sudo service klipper start
```

It is also necessary to compile and install the micro-controller code for a Linux host process. Run "make menuconfig" a second time and configure it for a "Linux process":

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

Complete the installation by configuring Klipper and Octoprint following the instructions in [the main installation document](Installation.md#configuring-klipper).

## 在 Beaglebone 上打印

Unfortunately, the Beaglebone processor can sometimes struggle to run OctoPrint well. Print stalls have been known to occur on complex prints (the printer may move faster than OctoPrint can send movement commands). If this occurs, consider using the "virtual_sdcard" feature (see [config reference](Config_Reference.md#virtual_sdcard) for details) to print directly from Klipper.
