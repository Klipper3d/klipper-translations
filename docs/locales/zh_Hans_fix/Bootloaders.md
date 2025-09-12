# 引导加载程序 (Bootloaders)

本文档提供了 Klipper 支持的微控制器上常见引导加载程序的信息。

引导加载程序（Bootloader）是微控制器在首次通电时运行的第三方软件。它通常用于在无需专用硬件的情况下，将新的应用程序（例如 Klipper）烧录到微控制器中。不幸的是，目前业界没有统一的微控制器烧录标准，也没有一种通用的引导加载程序可以在所有微控制器上运行。更糟糕的是，每种引导加载程序通常都需要不同的步骤来烧录应用程序。

如果可以将引导加载程序烧录到微控制器上，那么通常也可以使用该机制来烧录应用程序，但在这样做时需要格外小心，因为可能会意外地删除引导加载程序。相比之下，引导加载程序通常只允许用户烧录应用程序。因此，建议在可能的情况下使用引导加载程序来烧录应用程序。

本文档试图描述常见的引导加载程序、烧录引导加载程序所需的步骤以及烧录应用程序所需的步骤。本文档并非权威参考，而是 Klipper 开发人员积累的一些有用信息的集合。

## AVR 微控制器

通常，Arduino 项目是 8 位 Atmel Atmega 微控制器上引导加载程序和烧录程序的良好参考。特别是 "boards.txt" 文件：
[https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt](https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt)
是一个有用的参考。

要烧录引导加载程序本身，AVR 芯片需要一个外部硬件烧录工具（通过 SPI 与芯片通信）。这种工具可以购买（例如，在网上搜索 "avr isp"、"arduino isp" 或 "usb tiny isp"）。也可以使用另一个 Arduino 或树莓派来烧录 AVR 引导加载程序（例如，在网上搜索 "使用树莓派编程 AVR"）。下面的示例假设使用的是 "AVR ISP Mk2" 类型的设备。

“avrdude” 程序是最常用于烧录 atmega 芯片的工具（包括烧录引导加载程序和应用程序）。

### Atmega2560

该芯片通常出现在 "Arduino Mega" 中，在 3D 打印机主板中非常常见。

要烧录引导加载程序本身，请使用类似以下的命令：
```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要烧录应用程序，请使用类似以下的命令：
```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

该芯片通常出现在早期版本的 "Arduino Mega" 中。

要烧录引导加载程序本身，请使用类似以下的命令：
```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要烧录应用程序，请使用类似以下的命令：
```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

该芯片通常出现在 "Melzi" 类型的 3D 打印机主板中。

要烧录引导加载程序本身，请使用类似以下的命令：
```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要烧录应用程序，请使用类似以下的命令：
```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

请注意，许多 "Melzi" 类型的主板预装的引导加载程序使用 57600 的波特率。在这种情况下，要烧录应用程序，请改用以下命令：
```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

本文档不涵盖向 At90usb1286 烧录引导加载程序的方法，也不涵盖向此设备烧录应用程序的一般方法。

来自 pjrc.com 的 Teensy++ 设备附带了一个专有的引导加载程序。它需要一个来自
[https://github.com/PaulStoffregen/teensy_loader_cli](https://github.com/PaulStoffregen/teensy_loader_cli)
的自定义烧录工具。可以使用类似以下的命令烧录应用程序：

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

Atmega168 的闪存空间有限。如果使用引导加载程序，建议使用 Optiboot 引导加载程序。要烧录该引导加载程序，请使用类似以下的命令：
```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要通过 Optiboot 引导加载程序烧录应用程序，请使用类似以下的命令：
```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## SAM3 微控制器 (Arduino Due)

SAM3 mcu 通常不使用引导加载程序。该芯片本身具有一个 ROM，允许通过 3.3V 串行端口或 USB 对闪存进行编程。

要启用 ROM，需要在复位期间将 "erase" 引脚保持为高电平，这将擦除闪存内容并导致 ROM 运行。在 Arduino Due 上，可以通过将 "编程 usb 端口"（靠近电源的 USB 端口）的波特率设置为 1200 来完成此序列。

位于
[https://github.com/shumatech/BOSSA](https://github.com/shumatech/BOSSA)
的代码可用于对 SAM3 进行编程。建议使用 1.9 版或更高版本。

要烧录应用程序，请使用类似以下的命令：
```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## SAM4 微控制器 (Duet Wifi)

SAM4 mcu 通常不使用引导加载程序。该芯片本身具有一个 ROM，允许通过 3.3V 串行端口或 USB 对闪存进行编程。

要启用 ROM，需要在复位期间将 "erase" 引脚保持为高电平，这将擦除闪存内容并导致 ROM 运行。

位于
[https://github.com/shumatech/BOSSA](https://github.com/shumatech/BOSSA)
的代码可用于对 SAM4 进行编程。必须使用 `1.8.0` 版或更高版本。

要烧录应用程序，请使用类似以下的命令：
```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## SAMDC21 微控制器 (Duet3D Toolboard 1LC)

SAMC21 通过 ARM 串行线调试 (SWD) 接口进行烧录。这通常使用专用的 SWD 硬件加密狗完成。或者，可以使用
[带有 OpenOCD 的树莓派](#running-openocd-on-the-raspberry-pi)。

当使用 OpenOCD 与 SAMC21 时，如果板子将 SWD 引脚用于其他用途，则必须先采取额外步骤将芯片置于冷插拔模式。如果在树莓派上使用 OpenOCD，可以在调用 OpenOCD 之前运行以下命令。
```
SWCLK=25
SWDIO=24
SRST=18

echo "Exporting SWCLK and SRST pins."
echo $SWCLK > /sys/class/gpio/export
echo $SRST > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$SWCLK/direction
echo "out" > /sys/class/gpio/gpio$SRST/direction

echo "Setting SWCLK low and pulsing SRST."
echo "0" > /sys/class/gpio/gpio$SWCLK/value
echo "0" > /sys/class/gpio/gpio$SRST/value
echo "1" > /sys/class/gpio/gpio$SRST/value

echo "Unexporting SWCLK and SRST pins."
echo $SWCLK > /sys/class/gpio/unexport
echo $SRST > /sys/class/gpio/unexport
```

要使用 OpenOCD 烧录程序，请使用以下芯片配置：
```
source [find target/at91samdXX.cfg]
```
获取一个程序；例如，可以为此芯片构建 klipper。使用类似以下的 OpenOCD 命令进行烧录：
```
at91samd chip-erase
at91samd bootloader 0
program out/klipper.elf verify
```

## SAMD21 微控制器 (Arduino Zero)

SAMD21 引导加载程序通过 ARM 串行线调试 (SWD) 接口进行烧录。这通常使用专用的 SWD 硬件加密狗完成。或者，可以使用
[带有 OpenOCD 的树莓派](#running-openocd-on-the-raspberry-pi)。

要使用 OpenOCD 烧录引导加载程序，请使用以下芯片配置：
```
source [find target/at91samdXX.cfg]
```
获取引导加载程序 - 例如：
```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```
使用类似以下的 OpenOCD 命令进行烧录：
```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

SAMD21 上最常见的引导加载程序是 "Arduino Zero" 上的引导加载程序。它使用 8KiB 的引导加载程序（应用程序必须使用 8KiB 的起始地址进行编译）。可以通过双击复位按钮进入此引导加载程序。要烧录应用程序，请使用类似以下的命令：
```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

相比之下，"Arduino M0" 使用 16KiB 的引导加载程序（应用程序必须使用 16KiB 的起始地址进行编译）。要在此引导加载程序上烧录应用程序，请复位微控制器，并在启动后的最初几秒内运行烧录命令 - 类似于：
```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## SAMD51 微控制器 (Adafruit Metro-M4 及类似设备)

与 SAMD21 类似，SAMD51 引导加载程序通过 ARM 串行线调试 (SWD) 接口进行烧录。要使用
[树莓派上的 OpenOCD](#running-openocd-on-the-raspberry-pi) 烧录引导加载程序，请使用以下芯片配置：
```
source [find target/atsame5x.cfg]
```
获取引导加载程序 - 可从
[https://github.com/adafruit/uf2-samdx1/releases/latest](https://github.com/adafruit/uf2-samdx1/releases/latest) 获得多个引导加载程序。例如：
```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```
使用类似以下的 OpenOCD 命令进行烧录：
```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

SAMD51 使用 16KiB 的引导加载程序（应用程序必须使用 16KiB 的起始地址进行编译）。要烧录应用程序，请使用类似以下的命令：
```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## STM32F103 微控制器 (Blue Pill 设备)

STM32F103 设备具有一个 ROM，可以通过 3.3V 串行接口烧录引导加载程序或应用程序。通常需要将 PA10 (MCU Rx) 和 PA9 (MCU Tx) 引脚连接到 3.3V UART 适配器。要访问 ROM，应将 "boot 0" 引脚连接到高电平，"boot 1" 引脚连接到低电平，然后复位设备。然后可以使用 "stm32flash" 软件包，通过类似以下的命令烧录设备：
```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

请注意，如果使用树莓派进行 3.3V 串行通信，stm32flash 协议使用的串行奇偶校验模式是树莓派的 "mini UART" 不支持的。详情请参阅
[https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts](https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts)
关于如何在树莓派 GPIO 引脚上启用完整 UART 的说明。

烧录后，将 "boot 0" 和 "boot 1" 都设置回低电平，以便未来的复位能从闪存启动。

### 带有 stm32duino 引导加载程序的 STM32F103

"stm32duino" 项目有一个支持 USB 的引导加载程序 - 请参阅：
[https://github.com/rogerclarkmelbourne/STM32duino-bootloader](https://github.com/rogerclarkmelbourne/STM32duino-bootloader)

可以通过 3.3V 串行接口烧录此引导加载程序，例如：
```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

此引导加载程序使用 8KiB 的闪存空间（应用程序必须使用 8KiB 的起始地址进行编译）。使用类似以下的命令烧录应用程序：
```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

引导加载程序通常只在启动后短暂运行。可能需要调整上述命令的执行时机，使其在引导加载程序仍处于活动状态时运行（引导加载程序运行时会闪烁板载 LED）。或者，将 "boot 0" 引脚设置为低电平，"boot 1" 引脚设置为高电平，以在复位后停留在引导加载程序中。

### 带有 HID 引导加载程序的 STM32F103

[HID 引导加载程序](https://github.com/Serasidis/STM32_HID_Bootloader) 是一个紧凑的、无需驱动的引导加载程序，能够通过 USB 进行烧录。也可获得一个[专为 SKR Mini E3 1.2 构建的分支](
  https://github.com/Arksine/STM32_HID_Bootloader/releases/latest)。

对于通用 STM32F103 板（如 blue pill），可以使用 stm32flash 通过 3.3V 串行接口烧录引导加载程序，如上文 stm32duino 部分所述，只需将文件名替换为所需的 hid 引导加载程序二进制文件（例如，blue pill 使用 hid_generic_pc13.bin）。

由于 SKR Mini E3 的 boot0 引脚直接接地且未通过接头引出，因此无法使用 stm32flash。建议使用 STLink V2 和 STM32Cubeprogrammer 烧录引导加载程序。如果您无法使用 STLink，也可以使用
[树莓派和 OpenOCD](#running-openocd-on-the-raspberry-pi)，并使用以下芯片配置：

```
source [find target/stm32f1x.cfg]
```
如果需要，可以使用以下命令备份当前的闪存。请注意，这可能需要一些时间才能完成：
```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```
最后，可以使用类似以下的命令进行烧录：
```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```
注意事项：
- 上面的示例先擦除芯片，然后烧录引导加载程序。无论选择哪种烧录方法，都建议在烧录前先擦除芯片。
- 在 SKR Mini E3 上烧录此引导加载程序之前，您应该知道您将无法再通过 SD 卡更新固件。
- 启动 OpenOCD 时可能需要按住板子上的复位按钮。它应该显示类似以下内容：
  ```
  Open On-Chip Debugger 0.10.0+dev-01204-gc60252ac-dirty (2020-04-27-16:00)
  Licensed under GNU GPL v2
  For bug reports, read
          http://openocd.org/doc/doxygen/bugs.html
  DEPRECATED! use 'adapter speed' not 'adapter_khz'
  Info : BCM2835 GPIO JTAG/SWD bitbang driver
  Info : JTAG and SWD modes enabled
  Info : clock speed 40 kHz
  Info : SWD DPIDR 0x1ba01477
  Info : stm32f1x.cpu: hardware has 6 breakpoints, 4 watchpoints
  Info : stm32f1x.cpu: external reset detected
  Info : starting gdb server for stm32f1x.cpu on 3333
  Info : Listening on port 3333 for gdb connections
  ```
  之后可以松开复位按钮。


此引导加载程序需要 2KiB 的闪存空间（应用程序必须使用 2KiB 的起始地址进行编译）。

hid-flash 程序用于将二进制文件上传到引导加载程序。可以使用以下命令安装此软件：
```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

如果引导加载程序正在运行，可以使用类似以下的命令进行烧录：
```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```
或者，可以使用 `make flash` 直接烧录 klipper：
```
make flash FLASH_DEVICE=1209:BEBA
```
或者，如果 klipper 已经烧录过：
```
make flash FLASH_DEVICE=/dev/ttyACM0
```

可能需要手动进入引导加载程序，这可以通过将 "boot 0" 设置为低电平，"boot 1" 设置为高电平来完成。在 SKR Mini E3 上，"Boot 1" 不可用，因此如果烧录了 "hid_btt_skr_mini_e3.bin"，可以通过将 PA2 引脚设置为低电平来完成。此引脚在 SKR Mini E3 的 "PIN" 文档中的 TFT 接头上标记为 "TX0"。PA2 旁边有一个接地引脚，可用于将 PA2 拉低。

### 带有 MSC 引导加载程序的 STM32F103/STM32F072

[MSC 引导加载程序](https://github.com/Telekatz/MSC-stm32f103-bootloader) 是一个无需驱动的引导加载程序，能够通过 USB 进行烧录。

可以使用 stm32flash 通过 3.3V 串行接口烧录引导加载程序，如上文 stm32duino 部分所述，只需将文件名替换为所需的 MSC 引导加载程序二进制文件（例如，blue pill 使用 MSCboot-Bluepill.bin）。

对于 STM32F072 板，也可以通过 USB（通过 DFU）烧录引导加载程序，例如：

```
 dfu-util -d 0483:df11 -a 0 -R -D  MSCboot-STM32F072.bin -s0x08000000:leave
```

此引导加载程序使用 8KiB 或 16KiB 的闪存空间，请参阅引导加载程序的描述（应用程序必须使用相应的起始地址进行编译）。

可以通过按两次板子的复位按钮来激活引导加载程序。一旦引导加载程序被激活，板子就会显示为一个 USB 闪存驱动器，可以将 klipper.bin 文件复制到其中。

### 带有 CanBoot 引导加载程序的 STM32F103/STM32F0x2

[CanBoot](https://github.com/Arksine/CanBoot) 引导加载程序提供了一个通过 CANBUS 上传 Klipper 固件的选项。该引导加载程序本身源自 Klipper 的源代码。目前 CanBoot 支持 STM32F103、STM32F042 和 STM32F072 型号。

建议使用 ST-Link 编程器烧录 CanBoot，但应该可以使用 `stm32flash` 在 STM32F103 设备上烧录，以及使用 `dfu-util` 在 STM32F042/STM32F072 设备上烧录。请参阅本文档前面部分关于这些烧录方法的说明，适当替换文件名为 `canboot.bin`。上面链接的 CanBoot 仓库提供了构建引导加载程序的说明。

首次烧录 CanBoot 时，它应该检测到没有应用程序存在并进入引导加载程序。如果这没有发生，可以通过连续按两次复位按钮进入引导加载程序。

`lib/canboot` 文件夹中提供的 `flash_can.py` 工具可用于上传 Klipper 固件。需要设备 UUID 才能烧录。如果没有 UUID，可以查询当前正在运行引导加载程序的节点：
```
python3 flash_can.py -q
```
这将返回所有未分配 UUID 的连接节点的 UUID。这应该包括所有当前在引导加载程序中的节点。

一旦有了 UUID，可以使用以下命令上传固件：
```
python3 flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u aabbccddeeff
```

其中 `aabbccddeeff` 替换为您的 UUID。请注意，`-i` 和 `-f` 选项可以省略，它们默认分别为 `can0` 和 `~/klipper/out/klipper.bin`。

当为 CanBoot 构建 Klipper 时，选择 8 KiB 引导加载程序选项。

## STM32F4 微控制器 (SKR Pro 1.1)

STM32F4 微控制器配备了内置的系统引导加载程序，能够通过 USB（通过 DFU）、3.3V 串行以及其他各种方法进行烧录（更多信息请参阅 STM 文档 AN2606）。一些 STM32F4 板（如 SKR Pro 1.1）无法进入 DFU 引导加载程序。基于 STM32F405/407 的板卡可使用 HID 引导加载程序，如果用户更倾向于通过 USB 而不是 SD 卡进行烧录。请注意，您可能需要配置和构建一个特定于您板卡的版本，[SKR Pro 1.1 的构建版本可在此处获得](
  https://github.com/Arksine/STM32_HID_Bootloader/releases/latest)。

除非您的板卡支持 DFU，否则最方便的烧录方法可能是通过 3.3V 串行，其过程与[使用 stm32flash 烧录 STM32F103](#stm32f103-micro-controllers-blue-pill-devices) 相同。例如：
```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

此引导加载程序在 STM32F4 上需要 16Kib 的闪存空间（应用程序必须使用 16KiB 的起始地址进行编译）。

与 STM32F1 一样，STM32F4 使用 hid-flash 工具将二进制文件上传到 MCU。有关如何构建和使用 hid-flash 的详细信息，请参阅上述说明。

可能需要手动进入引导加载程序，这可以通过将 "boot 0" 设置为低电平，"boot 1" 设置为高电平并插入设备来完成。编程完成后拔下设备并将 "boot 1" 设置回低电平，以便加载应用程序。

## LPC176x 微控制器 (Smoothieboards)

本文档未描述烧录引导加载程序本身的方法 - 请参阅：
[http://smoothieware.org/flashing-the-bootloader](http://smoothieware.org/flashing-the-bootloader)
以获取更多相关信息。

Smoothieboards 通常附带来自：
[https://github.com/triffid/LPC17xx-DFU-Bootloader](https://github.com/triffid/LPC17xx-DFU-Bootloader)
的引导加载程序。使用此引导加载程序时，应用程序必须使用 16KiB 的起始地址进行编译。使用此引导加载程序烧录应用程序最简单的方法是将应用程序文件（例如 `out/klipper.bin`）复制到 SD 卡上名为 `firmware.bin` 的文件中，然后使用该 SD 卡重新启动微控制器。

## 在树莓派上运行 OpenOCD

OpenOCD 是一个可以执行低级芯片烧录和调试的软件包。它可以使用树莓派上的 GPIO 引脚与各种 ARM 芯片通信。

本节描述如何安装和启动 OpenOCD。它源自以下地址的说明：
[https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi](https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi)

首先下载并编译软件（每个步骤可能需要几分钟，"make" 步骤可能需要 30 多分钟）：

```
sudo apt-get update
sudo apt-get install autoconf libtool telnet
mkdir ~/openocd
cd ~/openocd/
git clone http://openocd.zylin.com/openocd
cd openocd
./bootstrap
./configure --enable-sysfsgpio --enable-bcm2835gpio --prefix=/home/pi/openocd/install
make
make install
```

### 配置 OpenOCD

创建一个 OpenOCD 配置文件：

```
nano ~/openocd/openocd.cfg
```

使用类似以下的配置：

```
# Uses RPi pins: GPIO25 for SWDCLK, GPIO24 for SWDIO, GPIO18 for nRST
source [find interface/raspberrypi2-native.cfg]
bcm2835gpio_swd_nums 25 24
bcm2835gpio_srst_num 18
transport select swd

# Use hardware reset wire for chip resets
reset_config srst_only
adapter_nsrst_delay 100
adapter_nsrst_assert_width 100

# Specify the chip type
source [find target/atsame5x.cfg]

# Set the adapter speed
adapter_khz 40

# Connect to chip
init
targets
reset halt
```

### 将树莓派连接到目标芯片

在接线前关闭树莓派和目标芯片的电源！在连接到树莓派之前，请验证目标芯片使用的是 3.3V！

将目标芯片上的 GND、SWDCLK、SWDIO 和 RST 分别连接到树莓派上的 GND、GPIO25、GPIO24 和 GPIO18。

然后给树莓派上电，并为目标芯片提供电源。

### 运行 OpenOCD

运行 OpenOCD：

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

上述命令应导致 OpenOCD 发出一些文本消息，然后等待（它不应该立即返回到 Unix shell 提示符）。如果 OpenOCD 自行退出或继续发出文本消息，则请仔细检查接线。

一旦 OpenOCD 运行并稳定，就可以通过 telnet 向其发送命令。打开另一个 ssh 会话并运行以下命令：

```
telnet 127.0.0.1 4444
```

（可以通过按 ctrl+] 然后运行 "quit" 命令来退出 telnet。）

### OpenOCD 和 gdb

可以使用 OpenOCD 与 gdb 调试 Klipper。以下命令假设您在桌面级机器上运行 gdb。

将以下内容添加到 OpenOCD 配置文件中：

```
bindto 0.0.0.0
gdb_port 44444
```

在树莓派上重启 OpenOCD，然后在桌面机器上运行以下 Unix 命令：

```
cd /path/to/klipper/
gdb out/klipper.elf
```

在 gdb 中运行：

```
target remote octopi:44444
```

（将 "octopi" 替换为树莓派的主机名。）一旦 gdb 运行，就可以设置断点和检查寄存器。