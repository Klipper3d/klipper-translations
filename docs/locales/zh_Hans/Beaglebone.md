# Beaglebone

本文档描述了在 Beaglebone 可编程实时单元上运行 Klipper 的过程。

## 构建一个操作系统镜像

首先安装 [Debian 11.7 2023-09-02 4GB microSD IoT]（https://beagleboard.org/latest-images） 镜像。可以从 micro-SD 卡或内置 eMMC 运行映像。如果使用 eMMC，请按照上述链接中的说明立即将其安装到 eMMC。

然后 ssh 进入 Beaglebone 机器(`ssh debian@beaglebone` -- password is `temppwd`).

开始之前安装Klipper你需要腾出额外空间。 有3个选项中做到这一点：

1. 删除一些 BeagleBone“Demo”资源
1. 如果你确实从 SD 卡启动，并且它大于 4Gb - 你可以扩展当前文件系统以占用整个卡空间
1. 同时执行选项 #1 和 #2。

要删除一些 BeagleBone“Demo”资源，请执行以下命令

```
sudo apt remove bb-node-red-installer
sudo apt remove bb-code-server
```

要将文件系统扩展至 SD 卡的全部大小，请执行此命令，无需重新启动。

```
sudo growpart /dev/mmcblk0 1
sudo resize2fs /dev/mmcblk0p1
```

通过运行以下命令安装 Klipper：

```
git clone https://github.com/Klipper3d/klipper.git
./klipper/scripts/install-beaglebone.sh
```

安装 Klipper 后，您需要决定需要什么样的部署，但请注意，BeagleBone 是基于 3.3v 的硬件，在大多数情况下，如果没有转换板，您不能直接将引脚连接到基于 5v 或 12v 的硬件。

由于 Klipper 在 BeagleBone 上具有多模块架构，因此您可以实现许多不同的用例，但一般用例如下：

用例 1：仅使用 BeagleBone 作为主机系统来运行 Klipper 和其他软件，如 OctoPrint/Fluidd + Moonraker/...，并且此配置将通过串行/usb/canbus 连接驱动外部微控制器。

用例 2：将 BeagleBone 与 CRAMPS 板等扩展板（cape）一起使用。在此配置下，BeagleBone 将托管 Klipper + 附加软件，并使用 BeagleBone PRU 内核（2 个附加内核 200Mh，32Bit）驱动扩展板。

用例 3：它与“用例 1”相同，但此外您还想利用 PRU 核心卸载主 CPU，以高速驱动 BeagleBone GPIO。

## 安装 Octoprint

然后可以安装 Octoprint，或者如果需要其他软件，可以完全跳过此部分：

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

在配置 Klipper 之前，需要先修改OctoPrint的 **/etc/default/octoprint** 配置文件。把 `OCTOPRINT_USER` 用户改为 `debian`，把 `NICELEVEL` 改为 `0` ，取消注释 `BASEDIR`、`CONFIGFILE` 和 `DAEMON` 的设置，并把引用从`/home/pi/`改为`/home/debian/`：

```
sudo nano /etc/default/octoprint
```

然后启动 Octoprint 服务：

```
sudo systemctl start octoprint
```

等待 1-2 分钟，确保 OctoPrint 网络服务器可访问 - 它应该位于：<http://beaglebone:5000/>

## 构建 BeagleBone PRU 微控制器代码（PRU 固件）

此部分对于上面提到的“用例 2”和“用例 3”是必需的，对于“用例 1”，则应跳过此部分。

检查是否存在所需设备

```
sudo beagle-version
```

您应该检查输出是否包含成功的“remoteproc”驱动程序加载和 PRU 核心的存在，在内核 5.10 中，它们应该是“remoteproc1”和“remoteproc2”（4a334000.pru、4a338000.pru）还应检查是否加载了许多 GPIO，它们看起来像“分配的 GPIO id=0 name='P8_03'”通常一切都很好，不需要硬件配置。如果缺少某些东西 - 尝试使用“uboot overlays”选项或 cape-overlays 仅供参考，使用 CRAMPS 板工作的 BeagleBone Black 配置的一些输出：

```
model:[TI_AM335x_BeagleBone_Black]
UBOOT: Booted Device-Tree:[am335x-boneblack-uboot-univ.dts]
UBOOT: Loaded Overlay:[BB-ADC-00A0.bb.org-overlays]
UBOOT: Loaded Overlay:[BB-BONE-eMMC1-01-00A0.bb.org-overlays]
kernel:[5.10.168-ti-r71]
/boot/uEnv.txt Settings:
uboot_overlay_options:[enable_uboot_overlays=1]
uboot_overlay_options:[disable_uboot_overlay_video=0]
uboot_overlay_options:[disable_uboot_overlay_audio=1]
uboot_overlay_options:[disable_uboot_overlay_wireless=1]
uboot_overlay_options:[enable_uboot_cape_universal=1]
pkg:[bb-cape-overlays]:[4.14.20210821.0-0~bullseye+20210821]
pkg:[bb-customizations]:[1.20230720.1-0~bullseye+20230720]
pkg:[bb-usb-gadgets]:[1.20230414.0-0~bullseye+20230414]
pkg:[bb-wl18xx-firmware]:[1.20230414.0-0~bullseye+20230414]
.............
.............
```

编译Klipper微控制器代码时，选择为“Beaglebone PRU”配置（选用“BeagleBone Black”配置时，因PRU框架内存仅8KB不兼容，应额外关闭“Optional features”【可选特性】里“Support GPIO Bit-banging devices”【支持GPIO模拟协议通信设备】和“Support LCD devices”【支持LCD设备】），然后保存退出配置：

```
cd ~/klipper/
make menuconfig
```

为构建安装新的PRU微控制器代码，执行以下命令：

```
sudo service klipper stop
make flash
sudo service klipper start
```

执行前述命令后，你的PRU平台应已就绪并开始自检是否正常。你可以运行以下指令

```
dmesg
```

并比较回显的最后输出和如上正常的示例输出是否一致：

```
[   71.105499] remoteproc remoteproc1: 4a334000.pru is available
[   71.157155] remoteproc remoteproc2: 4a338000.pru is available
[   73.256287] remoteproc remoteproc1: powering up 4a334000.pru
[   73.279246] remoteproc remoteproc1: Booting fw image am335x-pru0-fw, size 97112
[   73.285807]  remoteproc1#vdev0buffer: registered virtio0 (type 7)
[   73.285836] remoteproc remoteproc1: remote processor 4a334000.pru is now up
[   73.286322] remoteproc remoteproc2: powering up 4a338000.pru
[   73.313717] remoteproc remoteproc2: Booting fw image am335x-pru1-fw, size 188560
[   73.313753] remoteproc remoteproc2: header-less resource table
[   73.329964] remoteproc remoteproc2: header-less resource table
[   73.348321] remoteproc remoteproc2: remote processor 4a338000.pru is now up
[   73.443355] virtio_rpmsg_bus virtio0: creating channel rpmsg-pru addr 0x1e
[   73.443727] virtio_rpmsg_bus virtio0: msg received with no recipient
[   73.444352] virtio_rpmsg_bus virtio0: rpmsg host is online
[   73.540993] rpmsg_pru virtio0.rpmsg-pru.-1.30: new rpmsg_pru device: /dev/rpmsg_pru30
```

注意"/dev/rpmsg_pru30"相关内容，这是你在主控制器配置时需要使用的串行设备号。如果没显示对应设备号，你的PRU核心就没有正常启动。

## 构建及安装Linux微控制器代码

上述的“用例2”需要本分区的操作，本分区对于上述的“用例3”则是可选的

还需要编译和安装用于 Linux 主机进程的微控制器代码。再次修改编译配置为"Linux process"：

```
make menuconfig
```

然后也安装这个微控制器代码：

```
sudo service klipper stop
make flash
sudo service klipper start
```

take a note about "/tmp/klipper_host_mcu" - it will be your future serial device for "mcu host" if that file don't exist - refer to "scripts/klipper-mcu.service" file, it was installed by previous commands, and it's responsible for it.

Take a note for "Use case 2" about following: when you will define printer configuration you should always use temperature sensors from "mcu host" because ADCs not present in default "mcu" (PRU cores). Sample configuration of "sensor_pin" for extruder and heated bed are available in "generic-cramps.cfg" You can use any other GPIO directly from "mcu host" by referencing them this way "host:gpiochip1/gpio17" but that should be avoided because it will be creating additional load on main CPU and most probably you can't use them for stepper control.

## 剩余的配置

Complete the installation by configuring Klipper following the instructions in the main [Installation](Installation.md#configuring-octoprint-to-use-klipper) document.

## 在 Beaglebone 上打印

Unfortunately, the Beaglebone processor can sometimes struggle to run OctoPrint well. Print stalls have been known to occur on complex prints (the printer may move faster than OctoPrint can send movement commands). If this occurs, consider using the "virtual_sdcard" feature (see [Config Reference](Config_Reference.md#virtual_sdcard) for details) to print directly from Klipper and disable any DEBUG or VERBOSE logging options if you did enable them.

## AVR micro-controller code build

This environment have everything to build necessary micro-controller code except AVR, AVR packages was removed because of conflict with PRU packages. if you still want to build AVR micro-controller code in this environment you need to remove PRU packages and install AVR packages by executing following commands

```
sudo apt-get remove gcc-pru
sudo apt-get install avrdude gcc-avr binutils-avr avr-libc
```

if you need to restore PRU packages - then remove ARV packages before that

```
sudo apt-get remove avrdude gcc-avr binutils-avr avr-libc
sudo apt-get install gcc-pru
```

## Hardware Pin designation

BeagleBone 在引脚功能上非常灵活，同一引脚可以配置为不同功能，相同功能也可以配置在不同引脚上，但运行中同一引脚只执行一个功能。你不能在单个引脚上复用多个功能，也不能把一个功能赋予多个引脚。
示例：（配置P9_20为gpio0_12时，它不能承担i2c2_sda的功能）
P9_20 - i2c2_sda/can0_tx/spi1_cs0/gpio0_12/uart1_ctsn 
P9_19 - i2c2_scl/can0_rx/spi1_cs1/gpio0_13/uart1_rtsn 
P9_24 - i2c1_scl/can1_rx/gpio0_15/uart1_tx 
P9_26 - i2c1_sda/can1_tx/gpio0_14/uart1_rx

引脚功能是在Linux启动时通过专门覆写的文件定义的，需要使用特权编辑/boot/uEnv.txt来配置

```
sudo editor /boot/uEnv.txt
```

并具体定义引脚采用什么功能，比如你可以定义overlay覆写来启用CAN1

```
uboot_overlay_addr4=/lib/firmware/BB-CAN1-00A0.dtbo
```

以上覆写BB-CAN1-00A0.dtbo会重新配置所有CAN1所需引脚，并在Linux内创建CAN设备。改变覆写需要重启系统以生效。如果你想要知道覆写影响、占用了哪些引脚，你可以分析源文件或到BeagleBone论坛查找信息，源文件在：/opt/sources/bb.org-overlays/src/arm/ 。

## 启用硬件SPI

BeagleBone一般有多个硬件SPI总线（比如BeagleBone Black有2条最高48MHz的硬件SPI，虽然它们一般会被内核设备树限制到16MHz）。默认情况下，BeagleBone Black的部分SPI1引脚被配置为HDMI音频输出。如要使用完整4线SPI1，你需要用特权编辑/boot/uEnv.txt以禁用HDMI音频并启用SPI1

```
sudo editor /boot/uEnv.txt
```

去除注释掉变量的#

```
disable_uboot_overlay_audio=1
```

再去除到对应变量的注释，并如下定义

```
uboot_overlay_addr4=/lib/firmware/BB-SPIDEV1-00A0.dtbo
```

保存/boot/uEnv.txt的变更并重启板子。现在SPI1已启用，执行以下命令检查SPI是否已启用

```
ls /dev/spidev1.*
```

注意BeagleBone硬件电压是3.3V，使用5V SPI设备时需要电平转换芯片，比如SN74CBTD3861, SN74LVC1G34或类似物。如果你使用了CRAMPS板，那么它已经自带了电平转换芯片，把SPI1发布于P503端口并支持5V硬件。查看CRAMPS板原理图以获取引脚定义。

## 启用硬件I2C

BeagleBone usually have multiple hardware I2C buses, for example BeagleBone Black can have 3 of them, they support speed up-to 400Kbit Fast mode. By default, in BeagleBone Black there are two of them (i2c-1 and i2c-2) usually both are already configured and present on P9, third ic2-0 usually reserved for internal use. If you are using CRAMPS board then i2c-2 is present on P303 port with 3.3v level, If you want to obtain I2c-1 in CRAMPS board - you can get them on Extruder1.Step, Extruder1.Dir pins, they also are 3.3v based, check CRAMPS board Schematics for pin references. Related overlays, for [Hardware Pin designation](#hardware-pin-designation): I2C1(100Kbit): BB-I2C1-00A0.dtbo I2C1(400Kbit): BB-I2C1-FAST-00A0.dtbo I2C2(100Kbit): BB-I2C2-00A0.dtbo I2C2(400Kbit): BB-I2C2-FAST-00A0.dtbo

## Enabling hardware UART(Serial)/CAN

BeagleBone have up to 6 hardware UART(Serial) buses (up to 3Mbit) and up to 2 hardware CAN(1Mbit) buses. UART1(RX,TX) and CAN1(TX,RX) and I2C2(SDA,SCL) are using same pins - so you need to chose what to use UART1(CTSN,RTSN) and CAN0(TX,RX) and I2C1(SDA,SCL) are using same pins - so you need to chose what to use All UART/CAN related pins are 3.3v based, so you will need to use Transceiver chips/boards like SN74LVC2G241DCUR (for UART), SN65HVD230 (for CAN), TTL-RS485 (for RS-485) or something similar which can convert 3.3v signals to appropriate levels.

Related overlays, for [Hardware Pin designation](#hardware-pin-designation) CAN0: BB-CAN0-00A0.dtbo CAN1: BB-CAN1-00A0.dtbo UART0: - used for Console UART1(RX,TX): BB-UART1-00A0.dtbo UART1(RTS,CTS): BB-UART1-RTSCTS-00A0.dtbo UART2(RX,TX): BB-UART2-00A0.dtbo UART3(RX,TX): BB-UART3-00A0.dtbo UART4(RS-485): BB-UART4-RS485-00A0.dtbo UART5(RX,TX): BB-UART5-00A0.dtbo
