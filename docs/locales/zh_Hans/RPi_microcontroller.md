# RPi 微控制器

这个文档描述了在RPi上运行Klipper的过程，并使用相同的RPi作为辅助MCU。

## 为什么使用RPi作为辅助MCU？

通常情况下，专门用于控制3D打印机的MCU有有限的、预先配置好的引脚来管理主要的打印功能（热敏电阻、挤出机、步进器...）。使用安装了Klipper的RPi作为辅助MCU，可以直接使用klipper内的GPIO和RPi的总线（i2c，spi），而不需要使用Octoprint插件（如果使用的话）或外部程序，从而能够控制打印GCODE内的一切。

**警告**。如果你的平台是*Beaglebone*，并且你已经正确地按照安装步骤进行了安装，那么linux mcu已经为你的系统安装和配置了。

## 安装 rc 脚本

如果你想把主机作为一个辅助MCU，klipper_mcu进程必须在klippy进程之前运行。

安装 Klipper 后，运行以下命令来安装脚本：

```
cd ~/klipper/
sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
```

## 构建微控制器代码

要编译的 Klipper 微控制器代码，需要先将编译配置设置为“Linux Process”：

```
cd ~/klipper/
make menuconfig
```

在菜单中，设置“Microcontroller Archetecture”（微控制器架构）为“Linux Process”（Linux 进程），然后保存(save)并退出(exit)。

要构建和安装新的微控制器代码，请运行：

```
sudo service klipper stop
make flash
sudo service klipper start
```

如果klippy.log在试图连接到`/tmp/klipper_host_mcu`时输出 "Permission denied" 错误，那么你需要将你的用户添加到tty用户组。下面的命令将把 "pi "用户添加到tty用户组中：

```
sudo usermod -a -G tty pi
```

## 剩余的配置

按照[RaspberryPi 参考配置](../config/sample-raspberry-pi.cfg)和[多微控制器参考配置](../config/sample-multi-mcu.cfg)中的说明配置Klipper 二级微控制器来完成安装。

## 可选：启用 SPI

通过运行`sudo raspi-config` 后的 "Interfacing options"菜单中启用 SPI 以确保Linux SPI 驱动已启用。

## 可选：启用 I2C

通过运行`sudo raspi-config`并在"Interfacing options"（接口选项）菜单下启用I2C来启用Linux的I2C驱动程序。如果计划使用I2C与 MPU 加速度计进行连接，还需要将波特率设置为400000，方法是：在`/boot/config.txt`中添加/取消注释`dtparam=i2c_arm=on,i2c_arm_baudrate=400000`（在某些发行版中需要修改`/boot/firmware/config.txt`）。

## 可选步骤：识别正确的 gpiochip

在Raspberry Pi和许多类似的单板电脑上，暴露在 GPIO 上的引脚属于第一个gpiochip。因此，它们可以在klipper上使用，只需用`gpio0...n`的名字来引用它们。然而，在有些情况下，暴露的引脚属于第一个以外的gpiochips。例如，在一些OrangePi型号或者如果使用了一个端口扩展器的情况下，需要使用命令访问*Linux GPIO character device*来验证配置是有用的。

要在基于 Debian 的发行版（如 OctoPi）上安装 *Linux GPIO character device - binary*，请运行：

```
sudo apt-get install gpiod
```

要检查可用的gpiochip，请运行：

```
gpiodetect
```

要检查针脚编号和针脚可用性，请运行：

```
gpioinfo
```

因此，所选引脚可以在配置中可以通过 `gpiochip<n>/gpio<o>`引用，其中 **n** 是由 `gpiodetect` 命令看到的芯片编号**o** 是 ` gpioinfo` 命令看到的行号。

***警告：***只有标记为`unused`的 gpio 才可以被使用。一条*线路*不可能被多个进程同时使用。

例如，在树莓派 3B+上 将GPIO20作为 Klipper 的一个开关：

```
$ gpiodetect
gpiochip0 [pinctrl-bcm2835] (54 lines)
gpiochip1 [raspberrypi-exp-gpio] (8 lines)

$ gpioinfo
gpiochip0 - 54 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       unused   input  active-high
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
        line   8:      unnamed       unused   input  active-high
        line   9:      unnamed       unused   input  active-high
        line  10:      unnamed       unused   input  active-high
        line  11:      unnamed       unused   input  active-high
        line  12:      unnamed       unused   input  active-high
        line  13:      unnamed       unused   input  active-high
        line  14:      unnamed       unused   input  active-high
        line  15:      unnamed       unused   input  active-high
        line  16:      unnamed       unused   input  active-high
        line  17:      unnamed       unused   input  active-high
        line  18:      unnamed       unused   input  active-high
        line  19:      unnamed       unused   input  active-high
        line  20:      unnamed    "klipper"  output  active-high [used]
        line  21:      unnamed       unused   input  active-high
        line  22:      unnamed       unused   input  active-high
        line  23:      unnamed       unused   input  active-high
        line  24:      unnamed       unused   input  active-high
        line  25:      unnamed       unused   input  active-high
        line  26:      unnamed       unused   input  active-high
        line  27:      unnamed       unused   input  active-high
        line  28:      unnamed       unused   input  active-high
        line  29:      unnamed       "led0"  output  active-high [used]
        line  30:      unnamed       unused   input  active-high
        line  31:      unnamed       unused   input  active-high
        line  32:      unnamed       unused   input  active-high
        line  33:      unnamed       unused   input  active-high
        line  34:      unnamed       unused   input  active-high
        line  35:      unnamed       unused   input  active-high
        line  36:      unnamed       unused   input  active-high
        line  37:      unnamed       unused   input  active-high
        line  38:      unnamed       unused   input  active-high
        line  39:      unnamed       unused   input  active-high
        line  40:      unnamed       unused   input  active-high
        line  41:      unnamed       unused   input  active-high
        line  42:      unnamed       unused   input  active-high
        line  43:      unnamed       unused   input  active-high
        line  44:      unnamed       unused   input  active-high
        line  45:      unnamed       unused   input  active-high
        line  46:      unnamed       unused   input  active-high
        line  47:      unnamed       unused   input  active-high
        line  48:      unnamed       unused   input  active-high
        line  49:      unnamed       unused   input  active-high
        line  50:      unnamed       unused   input  active-high
        line  51:      unnamed       unused   input  active-high
        line  52:      unnamed       unused   input  active-high
        line  53:      unnamed       unused   input  active-high
gpiochip1 - 8 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       "led1"  output   active-low [used]
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
```

## 可选功能：硬件 PWM

树莓派有两个PWM通道（PWM0和PWM1），它们通常暴露在header中上，如果没有，可以路由到现有的 gpio 引脚。Linux mcu 守护程序使用 pwmchip sysfs 接口来控制 Linux 主机上的硬件 PWM 设备。pwm sysfs 接口在树莓上默认是隐藏的，可以通过在`/boot/config.txt`中加入一行设置来激活：

```
# 启用 pwmchip sysfs 接口
dtoverlay=pwm,pin=12,func=4
```

This example enables only PWM0 and routes it to gpio12. If both PWM channels need to be enabled you can use `pwm-2chan`:

```
# Enable pwmchip sysfs interface
dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4
```

This example additionally enables PWM1 and routes it to gpio13.

The overlay does not expose the pwm line on sysfs on boot and needs to be exported by echo'ing the number of the pwm channel to `/sys/class/pwm/pwmchip0/export`. This will create device `/sys/class/pwm/pwmchip0/pwm0` in the filesystem. The easiest way to do this is by adding this to `/etc/rc.local` before the `exit 0` line:

```
# Enable pwmchip sysfs interface
echo 0 > /sys/class/pwm/pwmchip0/export
```

When using both PWM channels, the number of the second channel needs to be echo'd as well:

```
# Enable pwmchip sysfs interface
echo 0 > /sys/class/pwm/pwmchip0/export
echo 1 > /sys/class/pwm/pwmchip0/export
```

有了 sysfs，现在可以通过将以下配置添加到 `printer.cfg` 来使用 PWM 通道：

```
[output_pin caselight]
pin: host:pwmchip0/pwm0
pwm: True
hardware_pwm: True
cycle_time: 0.000001

[output_pin beeper]
pin: host:pwmchip0/pwm1
pwm: True
hardware_pwm: True
value: 0
shutdown_value: 0
cycle_time: 0.0005
```

This will add hardware pwm control to gpio12 and gpio13 on the Pi (because the overlay was configured to route pwm0 to pin=12 and pwm1 to pin=13).

PWM0 可以被路由到 gpio12 和 gpio18，PWM1 可以被路由到 gpio13 和 gpio19：

| PWM | GPIO 引脚 | 功能 |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
