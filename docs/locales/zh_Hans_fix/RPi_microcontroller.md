# RPi 微控制器

本文档描述了在 RPi 上运行 Klipper 并将同一 RPi 用作次要 MCU 的过程。

## 为何使用 RPi 作为次要 MCU？

通常，专用于控制 3D 打印机的微控制器（MCU）具有有限且预配置的引脚数量，用于管理主要打印功能（热敏电阻、挤出机、步进电机等）。将安装了 Klipper 的 RPi 用作次要 MCU，可以在 Klipper 内直接使用 RPi 的 GPIO 和总线（i2c、spi），而无需使用 Octoprint 插件（如果使用了的话）或外部程序，从而能够在打印 GCODE 中统一控制所有设备。

**警告**：如果您的平台是 _Beaglebone_ 且已正确完成安装步骤，则 Linux MCU 已安装并为您的系统配置好。

## 安装 rc 脚本

如果您想将主机用作次要 MCU，则 klipper_mcu 进程必须在 klippy 进程之前运行。

安装 Klipper 后，请安装该脚本。运行：
```
cd ~/klipper/
sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
```

## 编译微控制器代码

要编译 Klipper 微控制器代码，请首先为“Linux 进程”进行配置：
```
cd ~/klipper/
make menuconfig
```

在菜单中，将“微控制器架构”设置为“Linux 进程”，然后保存并退出。

要构建并安装新的微控制器代码，请运行：
```
sudo service klipper stop
make flash
sudo service klipper start
```

如果 klippy.log 在尝试连接 `/tmp/klipper_host_mcu` 时报告“Permission denied”（权限被拒绝）错误，则需要将您的用户添加到 tty 组。以下命令将 "pi" 用户添加到 tty 组：
```
sudo usermod -a -G tty pi
```

## 剩余配置

通过按照 [RaspberryPi 示例配置](../config/sample-raspberry-pi.cfg) 和 [多 MCU 示例配置](../config/sample-multi-mcu.cfg) 中的说明配置 Klipper 次要 MCU 来完成安装。

## 可选：启用 SPI

通过运行 `sudo raspi-config` 并在“接口选项”菜单下启用 SPI，确保已启用 Linux SPI 驱动程序。

## 可选：启用 I2C

通过运行 `sudo raspi-config` 并在“接口选项”菜单下启用 I2C，确保已启用 Linux I2C 驱动程序。
如果计划将 I2C 用于 MPU 加速度计，还需要将波特率设置为 400000，方法是在 `/boot/config.txt`（或某些发行版中的 `/boot/firmware/config.txt`）中添加/取消注释：
`dtparam=i2c_arm=on,i2c_arm_baudrate=400000`

## 可选：识别正确的 gpiochip

在 Raspberry Pi 及许多克隆板上，GPIO 接头上暴露的引脚属于第一个 gpiochip。因此，只需在 Klipper 中使用 `gpio0..n` 名称即可引用它们。然而，也存在一些情况下暴露的引脚属于第一个以外的 gpiochip。例如某些 OrangePi 型号或使用了端口扩展器的情况。在这种情况下，使用命令访问 _Linux GPIO 字符设备_ 来验证配置会很有帮助。

要在基于 Debian 的发行版（如 octopi）上安装 _Linux GPIO 字符设备 - 二进制文件_，请运行：
```
sudo apt-get install gpiod
```

检查可用的 gpiochip，请运行：
```
gpiodetect
```

检查引脚编号和引脚可用性，请运行：
```
gpioinfo
```

然后可以在配置中使用选定的引脚，格式为 `gpiochip<n>/gpio<o>`，其中 **n** 是 `gpiodetect` 命令显示的芯片编号，**o** 是 `gpioinfo` 命令显示的线路编号。

***警告：*** 只有标记为 `unused` 的 gpio 才能使用。_线路_ 不能被多个进程同时使用。

例如，在 RPi 3B+ 上，Klipper 使用 GPIO20 作为开关：
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

## 可选：硬件 PWM

Raspberry Pi 拥有两个 PWM 通道（PWM0 和 PWM1），它们可以直接在接头上引出，或者可以路由到现有的 gpio 引脚。Linux mcu 守护进程使用 pwmchip sysfs 接口来控制 Linux 主机上的硬件 PWM 设备。默认情况下，pwm sysfs 接口在 Raspberry Pi 上并未启用，可以通过在 `/boot/config.txt` 中添加一行来激活：
```
# 启用 pwmchip sysfs 接口
dtoverlay=pwm,pin=12,func=4
```
此示例仅启用 PWM0 并将其路由到 gpio12。如果需要启用两个 PWM 通道，可以使用 `pwm-2chan`：
```
# 启用 pwmchip sysfs 接口
dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4
```
此示例额外启用了 PWM1 并将其路由到 gpio13。

该设备树覆盖层不会在启动时自动将 pwm 线路暴露在 sysfs 上，需要通过将 PWM 通道编号写入 `/sys/class/pwm/pwmchip0/export` 来导出。这将在文件系统中创建设备 `/sys/class/pwm/pwmchip0/pwm0`。最简单的方法是在 `/etc/rc.local` 文件中 `exit 0` 行之前添加以下内容：
```
# 启用 pwmchip sysfs 接口
echo 0 > /sys/class/pwm/pwmchip0/export
```
当使用两个 PWM 通道时，还需要导出第二个通道的编号：
```
# 启用 pwmchip sysfs 接口
echo 0 > /sys/class/pwm/pwmchip0/export
echo 1 > /sys/class/pwm/pwmchip0/export
```

配置好 sysfs 后，现在可以通过在 `printer.cfg` 配置文件中添加以下配置来使用 PWM 通道：
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
这将为 Pi 上的 gpio12 和 gpio13 添加硬件 PWM 控制（因为设备树覆盖层配置为将 pwm0 路由到 pin=12，pwm1 路由到 pin=13）。

PWM0 可以路由到 gpio12 和 gpio18，PWM1 可以路由到 gpio13 和 gpio19：

| PWM | gpio 引脚 | Func |
| --- | -------- | ---- |
|   0 |       12 |    4 |
|   0 |       18 |    2 |
|   1 |       13 |    4 |
|   1 |       19 |    2 |