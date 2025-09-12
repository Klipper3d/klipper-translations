# Beaglebone

本文档描述了在 Beaglebone PRU 上运行 Klipper 的过程。

## 构建操作系统镜像

首先安装 [Debian 11.7 2023-09-02 4GB microSD IoT](https://beagleboard.org/latest-images) 镜像。您可以从 micro-SD 卡或内置 eMMC 启动该镜像。如果使用 eMMC，请按照上述链接中的说明现在就将其安装到 eMMC。

然后通过 SSH 登录 Beaglebone 机器（`ssh debian@beaglebone` ——密码为 `temppwd`）。

在开始安装 Klipper 之前，您需要释放额外的空间。有以下三种选择：
1. 删除一些 BeagleBone 的“演示”资源
2. 如果您是从 SD 卡启动，并且其容量大于 4GB —— 您可以将当前文件系统扩展至占据整个 SD 卡空间
3. 同时执行选项 #1 和 #2。

要删除一些 BeagleBone 的“演示”资源，请执行以下命令：
```
sudo apt remove bb-node-red-installer
sudo apt remove bb-code-server
```

要将文件系统扩展到 SD 卡的全部空间，请执行以下命令，无需重启：
```
sudo growpart /dev/mmcblk0 1
sudo resize2fs /dev/mmcblk0p1
```

通过运行以下命令安装 Klipper：

```
git clone https://github.com/Klipper3d/klipper.git
./klipper/scripts/install-beaglebone.sh
```

安装 Klipper 后，您需要决定需要哪种部署方式，但请注意 BeagleBone 是基于 3.3V 的硬件，大多数情况下不能在没有转换板的情况下直接将引脚连接到 5V 或 12V 的硬件。

由于 Klipper 在 BeagleBone 上具有多模块架构，您可以实现多种不同的使用场景，但常见情况如下：

使用场景 1：仅将 BeagleBone 用作主机系统来运行 Klipper 和其他软件（如 OctoPrint/Fluidd + Moonraker/...），此配置将通过串行/USB/CAN 总线连接驱动外部微控制器。

使用场景 2：将 BeagleBone 与扩展板（cape）（如 CRAMPS 板）一起使用。在此配置中，BeagleBone 将托管 Klipper 及其他软件，并利用 BeagleBone 的 PRU 核心（2 个额外核心，200MHz，32 位）驱动扩展板。

使用场景 3：与“使用场景 1”相同，但您还想利用 PRU 核心高速驱动 BeagleBone 的 GPIO，以减轻主 CPU 的负载。

## 安装 OctoPrint

然后可以安装 OctoPrint，或者如果您希望使用其他软件，可以完全跳过此部分：
```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

并设置 OctoPrint 开机自启动：
```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

必须修改 OctoPrint 的 **/etc/default/octoprint** 配置文件。必须将 `OCTOPRINT_USER` 用户更改为 `debian`，将 `NICELEVEL` 更改为 `0`，取消注释 `BASEDIR`、`CONFIGFILE` 和 `DAEMON` 设置，并将其中的 `/home/pi/` 引用更改为 `/home/debian/`：
```
sudo nano /etc/default/octoprint
```

然后启动 OctoPrint 服务：
```
sudo systemctl start octoprint
```
等待 1-2 分钟，确保 OctoPrint 网页服务器可访问 —— 它的地址应为：[http://beaglebone:5000/](http://beaglebone:5000/)

## 构建 BeagleBone PRU 微控制器代码（PRU 固件）
本节适用于上述“使用场景 2”和“使用场景 3”，对于“使用场景 1”应跳过此步骤。

检查所需设备是否存在：

```
sudo beagle-version
```
您应检查输出中是否成功加载了 "remoteproc" 驱动程序并存在 PRU 核心，在内核 5.10 中它们应为 "remoteproc1" 和 "remoteproc2"（4a334000.pru, 4a338000.pru）。同时检查是否加载了许多 GPIO，它们将显示为 "Allocated GPIO id=0 name='P8_03'"。通常一切正常，无需硬件配置。如果缺少某些内容，请尝试调整 "uboot overlays" 选项或 cape-overlays。作为参考，以下是使用 CRAMPS 板的正常 BeagleBone Black 配置的部分输出：
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

要编译 Klipper 微控制器代码，请首先将其配置为“Beaglebone PRU”。对于“BeagleBone Black”，还需在“可选功能”中禁用“支持 GPIO 模拟设备”和“支持 LCD 设备”选项，因为它们无法适应 8KB 的 PRU 固件内存。然后退出并保存配置：
```
cd ~/klipper/
make menuconfig
```

要构建并安装新的 PRU 微控制器代码，请运行：
```
sudo service klipper stop
make flash
sudo service klipper start
```
执行完上述命令后，您的 PRU 固件应已准备就绪并启动。要检查是否一切正常，您可以执行以下命令：
```
dmesg
```
将最后的消息与以下示例进行比较，以确认一切正常启动：
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
请注意 "/dev/rpmsg_pru30" —— 这将是您未来主 mcu 配置的串行设备。此设备必须存在，如果缺失，则说明您的 PRU 核心未正确启动。

## 构建并安装 Linux 主机微控制器代码
本节适用于上述“使用场景 2”，对于“使用场景 3”是可选的。

还需要为 Linux 主机进程编译并安装微控制器代码。再次配置为“Linux 进程”：
```
make menuconfig
```

然后也安装此微控制器代码：
```
sudo service klipper stop
make flash
sudo service klipper start
```
请注意 "/tmp/klipper_host_mcu" —— 这将是您未来“mcu host”的串行设备。如果该文件不存在，请参考 "scripts/klipper-mcu.service" 文件，它由之前的命令安装，并负责创建该文件。

对于“使用场景 2”，请注意：当您定义打印机配置时，应始终使用“mcu host”的温度传感器，因为默认的“mcu”（PRU 核心）中没有 ADC。挤出机和加热床的“sensor_pin”示例配置可在 "generic-cramps.cfg" 中找到。您可以通过 "host:gpiochip1/gpio17" 这种方式直接从“mcu host”使用任何其他 GPIO，但应避免这样做，因为它会增加主 CPU 的额外负载，而且很可能无法将其用于步进电机控制。

## 剩余配置

按照主 [安装](Installation.md#configuring-octoprint-to-use-klipper) 文档中的说明配置 Klipper 来完成安装。

## 在 Beaglebone 上打印

不幸的是，Beaglebone 处理器有时难以良好运行 OctoPrint。在复杂打印中已知会出现打印停滞（打印机的移动速度可能快于 OctoPrint 发送运动命令的速度）。如果发生这种情况，请考虑使用“virtual_sdcard”功能（详见 [配置参考](Config_Reference.md#virtual_sdcard)），直接从 Klipper 打印，并禁用任何您已启用的 DEBUG 或 VERBOSE 日志选项。

## AVR 微控制器代码构建
此环境包含构建必要微控制器代码所需的一切，但不包括 AVR，因为 AVR 包与 PRU 包存在冲突而被移除。如果您仍希望在此环境中构建 AVR 微控制器代码，需要移除 PRU 包并安装 AVR 包，执行以下命令：

```
sudo apt-get remove gcc-pru
sudo apt-get install avrdude gcc-avr binutils-avr avr-libc
```
如果您需要恢复 PRU 包，则需先移除 AVR 包：
```
sudo apt-get remove avrdude gcc-avr binutils-avr avr-libc
sudo apt-get install gcc-pru
```

## 硬件引脚定义
BeagleBone 在引脚定义方面非常灵活，同一引脚可配置为不同功能，但每个引脚只能有一个功能，同一功能不能出现在多个引脚上。因此，您不能在单个引脚上拥有多个功能，也不能在多个引脚上拥有相同功能。例如：
P9_20 - i2c2_sda/can0_tx/spi1_cs0/gpio0_12/uart1_ctsn
P9_19 - i2c2_scl/can0_rx/spi1_cs1/gpio0_13/uart1_rtsn
P9_24 - i2c1_scl/can1_rx/gpio0_15/uart1_tx
P9_26 - i2c1_sda/can1_tx/gpio0_14/uart1_rx

引脚定义是通过使用特殊的“覆盖层”（overlays）实现的，这些覆盖层在 Linux 启动时加载。通过以提升的权限编辑文件 /boot/uEnv.txt 来配置：
```
sudo editor /boot/uEnv.txt
```
并定义要加载的功能，例如要启用 CAN1，您需要为其定义覆盖层：
```
uboot_overlay_addr4=/lib/firmware/BB-CAN1-00A0.dtbo
```
此覆盖层 BB-CAN1-00A0.dtbo 将重新配置 CAN1 所需的所有引脚，并在 Linux 中创建 CAN 设备。任何覆盖层的更改都需要重启系统才能生效。如果您需要了解某个覆盖层涉及哪些引脚，可以分析以下位置的源文件：/opt/sources/bb.org-overlays/src/arm/ 或在 BeagleBone 论坛中搜索相关信息。

## 启用硬件 SPI
BeagleBone 通常有多个硬件 SPI 总线，例如 BeagleBone Black 可以有两个，它们最高可工作到 48MHz，但通常受内核设备树限制为 16MHz。默认情况下，在 BeagleBone Black 上，一些 SPI1 引脚被配置为 HDMI 音频输出。要完全启用 4 线 SPI1，您需要禁用 HDMI 音频并启用 SPI1。为此，请以提升的权限编辑文件 /boot/uEnv.txt：
```
sudo editor /boot/uEnv.txt
```
取消注释变量：
```
disable_uboot_overlay_audio=1
```

接下来取消注释变量并按如下方式定义：
```
uboot_overlay_addr4=/lib/firmware/BB-SPIDEV1-00A0.dtbo
```
保存 /boot/uEnv.txt 中的更改并重启开发板。现在您已启用 SPI1，要验证其存在，请执行命令：
```
ls /dev/spidev1.*
```
请注意，BeagleBone 通常是基于 3.3V 的硬件，要使用 5V 的 SPI 设备，您需要添加电平转换芯片，例如 SN74CBTD3861、SN74LVC1G34 或类似芯片。如果您使用的是 CRAMPS 板，它已经包含电平转换芯片，SPI1 引脚将出现在 P503 端口，并且可以接受 5V 硬件，请查阅 CRAMPS 板原理图以获取引脚参考。

## 启用硬件 I2C
BeagleBone 通常有多个硬件 I2C 总线，例如 BeagleBone Black 可以有三个，它们支持高达 400Kbit 的快速模式。默认情况下，在 BeagleBone Black 上，有两个（i2c-1 和 i2c-2）通常已经配置好并出现在 P9 上，第三个 i2c-0 通常保留用于内部使用。如果您使用的是 CRAMPS 板，则 i2c-2 出现在 P303 端口，电平为 3.3V。如果您想在 CRAMPS 板上获取 I2C-1，可以从 Extruder1.Step、Extruder1.Dir 引脚获取，它们也是基于 3.3V 的，请查阅 CRAMPS 板原理图以获取引脚参考。相关覆盖层，用于[硬件引脚定义](#hardware-pin-designation)：
I2C1(100Kbit)：BB-I2C1-00A0.dtbo
I2C1(400Kbit)：BB-I2C1-FAST-00A0.dtbo
I2C2(100Kbit)：BB-I2C2-00A0.dtbo
I2C2(400Kbit)：BB-I2C2-FAST-00A0.dtbo

## 启用硬件 UART(串行)/CAN
BeagleBone 最多有 6 个硬件 UART(串行) 总线（最高 3Mbit）和最多 2 个硬件 CAN(1Mbit) 总线。UART1(RX,TX) 和 CAN1(TX,RX) 以及 I2C2(SDA,SCL) 使用相同的引脚 —— 因此您需要选择使用哪一个。UART1(CTSN,RTSN) 和 CAN0(TX,RX) 以及 I2C1(SDA,SCL) 使用相同的引脚 —— 因此您需要选择使用哪一个。所有 UART/CAN 相关引脚都是基于 3.3V 的，因此您需要使用转换芯片/板，如 SN74LVC2G241DCUR（用于 UART）、SN65HVD230（用于 CAN）、TTL-RS485（用于 RS-485）或类似设备，将 3.3V 信号转换为适当的电平。

相关覆盖层，用于[硬件引脚定义](#hardware-pin-designation)
CAN0：BB-CAN0-00A0.dtbo
CAN1：BB-CAN1-00A0.dtbo
UART0：- 用于控制台
UART1(RX,TX)：BB-UART1-00A0.dtbo
UART1(RTS,CTS)：BB-UART1-RTSCTS-00A0.dtbo
UART2(RX,TX)：BB-UART2-00A0.dtbo
UART3(RX,TX)：BB-UART3-00A0.dtbo
UART4(RS-485)：BB-UART4-RS485-00A0.dtbo
UART5(RX,TX)：BB-UART5-00A0.dtbo