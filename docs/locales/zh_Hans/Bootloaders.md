# 底层引导程序

本文档介绍Klipper支持的用于微控制器的底层引导程序（bootloader）。

引导程序是第三方软件，在微控制器上电后优先运行。该程序可以在不需要特殊硬件（如烧录器）下对微控制器的程序进行刷写（如写入Klipper程序）。然而，目前还没有一刷写微控制器的工业标准，也没有一个适用于所有微控制器的标准引导程序。更麻烦的是，每种引导加载程序需要不同的步骤以触发刷写功能。

如果能用某种方式将 bootloader 刷写到微控制器，使用该方式通常也能完成程序刷写操作，但是，这种直接刷写可能会将 bootloader 覆盖掉。相对地，bootloader 只允许用户刷写应用程序区域。因此，尽可能使用 bootloader 完成程序的刷写。

该文档将尽可能介绍常见的bootloaders，刷入bootloader所需的步骤和触发bootloader进行程序刷写的流程。该文档亦非官方指引，这只是在Klipper开发人员使用过程中收集到的有用信息。

## AVR 微控制器

总体上来说，Arduino项目是8位Atmel Atmega微控制器的引导程序和刷写程序的好的参考。特别是" boards.txt "文件。<https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt>是一个有用的参考。

要刷写引导程序本身，AVR 芯片需要一个外部硬件刷写工具（它使用 SPI 与芯片进行通信）。这个工具可以购买（例如，在网上搜索 "avr isp"、"arduino isp "或 "usb tiny isp"）。也可以使用另一个Arduino或Raspberry Pi来闪存AVR引导程序（例如，在网上搜索 "用raspberry pi编程AVR"）。下面的例子是在假设使用 "AVR ISP Mk2 "类型的设备的情况下编写的。

"avrdude "程序是最常用的工具，用于刷写atmega芯片（包括引导程序刷写和应用程序刷写）。

### Atmega2560

这个芯片通常出现在 "Arduino Mega" 中，在3D打印机主板中也十分普遍。

要刷写引导程序本身，请使用类似以下的方法：

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要刷写一个应用程序使用：

```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

这个芯片通常出现在早期版本的 "Arduino Mega "中。

要刷写引导程序本身，请使用类似以下的方法：

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要刷写一个应用程序使用：

```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

这种芯片通常出现在 "Melzi "式的3D打印机主板上。

要刷写引导程序本身，请使用类似以下的方法：

```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要刷写一个应用程序使用：

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

注意，一些 "Melzi "风格的板子预载了一个使用57600波特率的引导程序。在这种情况下，要刷写一个应用程序，请使用类似这样的东西来代替：

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

本文件不包括向At90usb1286刷写引导程序的方法，也不包括向该设备刷写一般应用。

来自pjrc.com的Teensy++设备带有一个专用的引导程序。它需要一个来自<https://github.com/PaulStoffregen/teensy_loader_cli>的定制刷写工具。可以用这个工具来刷写一个应用程序，例如：

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

atmega168的闪存空间有限。如果使用引导程序，建议使用Optiboot bootloader。要刷写该引导程序，请使用这个的方法：

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要通过Optiboot bootloader 刷写一个应用程序，请使用以下方法：

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## SAM3 微控制器 (Arduino Due)

通常在 SAM 3 微控制器上不使用引导程序。芯片自带一个允许从3.3V 串口或从USB进行编程的ROM。

为了启用ROM，将"erase"引脚在复位过程中保持高电平，这将擦除闪存的内容，并使ROM运行。在Arduino Due上，这个程序可以通过在 "programming usb port"（编程USB口，最靠近电源的USB端口）上设置1200的波特率来完成。

<https://github.com/shumatech/BOSSA>中的代码可以用来为SAM3编程。建议使用1.9或更高版本。

要刷写一个应用程序使用：

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## SAM4 微控制器 (Duet Wifi)

通常在 SAM4 微控制器中不使用引导程序。芯片自带一个可以从 3.3V 串口或 USB 进行编程的ROM。

为了启用ROM，在复位过程中要将"erase"引脚保持为高电平，这将擦除闪存内容，并使ROM运行。

<https://github.com/shumatech/BOSSA>中的代码可以用来为SAM4编程。需要使用`1.8.0`或更高的版本。

要刷写一个应用程序使用：

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## SAMDC21微控制器(Duet3D工具板1LC)

SAMC21通过ARM串行线调试(SWD)接口进行刷新。这通常是通过专用的社署硬件加密狗来完成的。或者，人们可以使用带有[Raspberry Pi的 OpenOCD](#running-openocd-on-the-raspberry-pi).

当将OpenOCD与SAMC21一起使用时，如果主板将SWD引脚用于其他目的，则必须采取额外步骤，首先将芯片置于冷插拔模式。如果在Rasberry PI上使用OpenOCD，可以通过在调用OpenOCD之前运行以下命令来完成。

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

要使用OpenOCD刷新程序，请使用以下芯片配置：

```
source [find target/at91samdXX.cfg]
```

获取一个程序；例如，可以为该芯片构建Klipper。带有OpenOCD命令的闪存，类似于：

```
AT91samd芯片擦除。
AT91samd引导加载程序%0。
程序输出/klipper.self验证
```

## SAMD21微控制器（Arduino Zero）

SAMD21 引导加载程序通过 ARM 串行线调试 （SWD） 接口进行刷写，通常需要一个专用的 SWD 硬件转换器或者使用[安装了 OpenOCD 的 Raspberry Pi](#running-openocd-on-the-raspberry-pi)来完成。

要使用 OpenOCD 刷写引导加载程序，请使用以下芯片配置：

```
source [find target/at91samdXX.cfg]
```

获取引导加载程序 - 例如：

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

使用类似下面的 OpenOCD 命令来刷写：

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

SAMD21上最常见的启动引导程序可以在 "Arduino Zero "上找到。它使用一个 8KiB 的引导程序（应用程序必须以 8KiB 的起始地址进行编译），按下复位按钮两次就可以进入。要刷写一个程序，请使用类似以下的方法：

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

相比之下，"Arduino M0 "使用一个 16KiB 的启动引导程序（程序必须用 16KiB 的起始地址进行编译）。使用这个启动引导程序来刷写一个程序，请重置微控制器，并在启动的头几秒钟内运行刷写命令--类似如下命令：

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## SAMD51 微控制器(Adafruit Metro-M4及类似的开发板)

和 SAMD21 一样，SAMD51 的启动引导程序也是通过 ARM 串行线调试（SWD）接口刷写的。要用[运行 OpenOCD的 Raspberry Pi](#running-openocd-on-the-raspberry-pi)刷写引导程序，请使用以下芯片配置：

```
source [find target/atsame5x.cfg]
```

获得一个引导程序--很多引导程序可以从<https://github.com/adafruit/uf2-samdx1/releases/latest>获得。例如：

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

使用类似下面的 OpenOCD 命令来刷写：

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

SAMD51 使用 16KiB 的启动引导程序（应用程序必须以16KiB的起始地址进行编译）。要刷写一个应用程序，请使用类似以下的方法：

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## STM32F103 微控制器（Blue Pill 开发板）

STM32F103设备有一个ROM，可以通过3.3V串口刷写引导程序或应用程序。通常会把PA10（MCU Rx）和PA9（MCU Tx）引脚连接到3.3V UART适配器上。要访问ROM，应该把"boot 0"引脚连接到高电平，"boot 1"引脚连接到低电平，然后重置设备。然后可以用"stm32flash"包刷写设备，使用的方法如下：

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

注意，如果使用树莓派的3.3V串口，stm32flash协议使用的串行奇偶校验模式，树莓派的 "mini UART "并不支持。关于在树莓派的GPIO引脚上启用完整的UART的细节，见<https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts>。

刷写后，将 "boot 0 "和 "boot 1 "都恢复设为低电平，以便在复位后从闪存启动。

### 带有 stm32duino 引导加载程序的 STM32F103

"stm32duino "项目有一个USB功能的引导程序-参见：<https://github.com/rogerclarkmelbourne/STM32duino-bootloader>

这个引导程序可以通过3.3V的串口用类似以下的命令来刷写：

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

这个引导程序使用 8KiB 的闪存空间（应用程序必须以 8KiB 的起始地址编译）。刷写应用程序需要使用类似以下的命令：

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

启动引导程序通常只在启动后的一小段时间运行。在输入以上命令的时候，需要确保启动引导程序还在运行（启动引导程序运行的时候会控制板上的led闪烁）。此外，启动后如果设置“boot 0”引脚为低，设置“boot 1”引脚为高则可以一直停留在启动引导程序。

### 带有 HID 引导程序的STM32F103

[HID bootloader](https://github.com/Serasidis/STM32_HID_Bootloader)是一个紧凑的、不包含驱动的启动引导程序，能够通过USB进行刷写。此外，还有一个[针对SKR Mini E3 1.2构建的分支](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest)。

对于常见的 STM32F103 板，如Blue Pill，可以使用 stm32flash 通过 3.3V 串行刷写引导程序，如上面 stm32duino 章节所述，将文件名替换为所需的 hid 引导程序二进制文件（即：hid_generic_pc13.bin 适用于 Blue Pill）。

SKR Mini E3无法使用stm32flash ，因为boot 0引脚被直接接到GND且没有跳线断开。推荐使用STLink V2通过STM32Cubeprogrammer刷写启动引导程序。如果你没有STLink ，也可以按照以下芯片配置使用[树莓派和OpenOCD](#running-openocd-on-the-raspberry-pi) 刷写：

```
source [find target/stm32f1x.cfg]
```

如果你愿意，可以使用下面的命令备份当前闪存上的程序。请注意，这可能需要一些时间来完成备份：

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

最后，你可以用类似以下的命令刷写固件：

```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```

注意：

- 上面的例子是先擦除芯片，然后再写入引导程序。无论选择哪种方法刷写，都建议在刷写前擦除芯片。
- 在用这个引导程序刷写SKR Mini E3之前，你需要知道之后你将不能再通过SD卡更新固件。
- You may need to hold down the reset button on the board while launching OpenOCD. It should display something like:
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

这个引导程序需要2KiB的闪存空间（应用程序必须以2KiB的起始地址进行编译）。

hid-flash程序是用来上传二进制文件到启动引导程序的。你可以用以下命令安装这个软件：

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

如果bootloader正在运行，你可以用这个来刷写：

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

或者，你可以使用`make flash`来直接刷写klipper：

```
make flash FLASH_DEVICE=1209:BEBA
```

或者，如果klipper之前已经被写入过：

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

可能需要手动进入引导程序，可以通过将 "boot 0"配置为低电平和 "boot 1"为高电平来完成。在SKR Mini E3上不能调整"Boot 1"，所以如果你刷写过 "hid_btt_skr_mini_e3.bin"，可以通过设置PA2低电平来完成。在SKR Mini E3的引脚文档中，这个引脚在TFT头中被标为 "TX0"。在PA2旁边有一个接地引脚，你可以用它来把PA2拉低。

### 带MSC引导程序的STM32F103/STM32F072

[MSC 引导程序](https://github.com/Telekatz/MSC-stm32f103-bootloader) 是一个能够进行 USB 刷写的免驱引导程序。

可以通过3.3V串口刷写引导程序，使用stm32flash，如上面stm32duino章节所述，将文件名替换为所需的MSC引导程序二进制文件（即：MSCboot-Bluepill.bin用于blue pill）。

STM32F072板也可以通过USB（通过DFU）刷写引导程序，如下所示：

```
 dfu-util -d 0483:df11 -a 0 -R -D  MSCboot-STM32F072.bin -s0x08000000:leave
```

此引导加载程序使用 8KiB 或 16KiB 的闪存空间，请参阅引导加载程序的说明（必须使用相应的起始地址编译应用程序）。

可以通过按两次电路板上的复位按钮来激活引导程序。一旦启动引导程序，该板就会显示为一个 USB 闪存驱动器，可以将 klipper.bin 文件复制到该驱动器上。

### 带有CanBoot引导程序的STM32F103/STM32F0x2

[CanBoot](https://github.com/Arksine/CanBoot)引导程序提供了一个通过CANBUS上传Klipper固件的选项。该引导程序本身来自Klipper的源代码。目前CanBoot支持STM32F103、STM32F042和STM32F072型号。

建议使用ST-Link编程器来刷写CanBoot，然而，在STM32F103设备上使用`stm32flash` ，在STM32F042/STM32F072设备上使用`dfu-util` ，应该也是可以刷写的。关于这些刷写方法的说明，请参见本文档的前几节，在适当的地方用`canboot.bin` 代替文件名。上面链接的CanBoot资源库提供了构建引导程序的说明。

在CanBoot第一次被写入时，应该检测到没有应用程序，并进入引导程序。如果没有出现这种情况，可以通过连续按两次复位按钮进入引导程序。

`flash_can.py`在`lib/canboot`文件夹中提供的工具可以用来上传Klipper固件。设备的UUID对于写入固件来说是必要的。如果你没有UUID可以查询当前运行引导程序的节点：

```
python3 flash_can.py -q
```

这会返回所有未被分配UUID的节点的UUID。这应该包括当前在bootloader中的所有节点。

一旦你有了UUID，你可以用以下命令上传固件：

```
python3 flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u aabbccddeeff
```

其中`aabbccddeeff`被你的UUID取代。注意选项`-i`和`-f`可以被省略，它们分别默认为`can0`和`~/klipper/out/klipper.bin`。

当构建Klipper与CanBoot一起使用时，选择8 KiB Bootloader选项。

## STM32F4 微控制器 (SKR Pro 1.1)

STM32F4 微控制器配备了一个内置系统引导加载程序，可通过 USB（通过 DFU）、3.3V 串行和其他各种方法（有关更多信息，请参见 STM 文档 AN2606）进行烧录。一些 STM32F4 板，例如 SKR Pro 1.1，无法进入 DFU 引导加载程序。针对基于 STM32F405/407 的板，提供了 HID 引导加载程序，用户可以选择通过 USB 进行烧录而不使用 sdcard。请注意，您可能需要配置和构建适用于您的板的特定版本，[此处提供了 SKR Pro 1.1 的构建版本](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest)。

除非您的控制板支持 DFU，否则最易于访问的烧录方法可能是通过 3.3V 串口进行烧录，其遵循与 [使用 stm32flash 烧录 STM32F103](#stm32f103-micro-controllers-blue-pill-devices) 相同的过程。例如：

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

这个引导程序在STM32F4上需要16Kib的闪存空间（应用程序必须以16KiB的起始地址进行编译）。

与STM32F1一样，STM32F4使用hid-flash工具来上传二进制文件到MCU。关于如何构建和使用hid-flash的细节，请参见上面的说明。

可能需要手动进入引导程序，这可以通过设置 "boot 0 "为低电平，"boot 1 "为高电平并上电来完成。编程完成后，设备断电，将 "boot 1 "重设为低电平，这样应用程序就会被加载。

## LPC176x微控制器（Smoothieboards）

本文件没有描述刷写引导程序本身的方法--见：<http://smoothieware.org/flashing-the-bootloader>以获得关于该主题的进一步信息。

Smoothieboards通常带有一个来自<https://github.com/triffid/LPC17xx-DFU-Bootloader>的bootloader。当使用这个引导程序时，应用程序必须以16KiB的起始地址进行编译。用这个引导程序刷写应用程序的最简单方法是将应用程序文件（例如`out/klipper.bin`）复制到SD卡上一个名为`firmware.bin`的文件，然后用该SD卡重新启动微控制器。

## 在树莓派上运行OpenOCD

OpenOCD是一个软件包，可以进行底层的芯片编程和调试。它可以使用树莓派上的GPIO引脚与各种ARM芯片通信。

本节描述了如何安装和启动OpenOCD。它来自于以下的说明：<https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>

开始下载和编译软件（每个步骤可能需要数分钟，"make "步骤可能需要30分钟以上）：

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

### 配置OpenOCD

创建一个OpenOCD配置文件：

```
nano ~/openocd/openocd.cfg
```

使用类似于以下的配置：

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

### 将树莓派与目标芯片相连

在接线之前，请关闭树莓派和目标芯片的电源! 在连接到树莓派之前，请确认目标芯片使用3.3V电压!

将目标芯片上的GND、SWDCLK、SWDIO和RST分别连接到树莓派上的GND、GPIO25、GPIO24和GPIO18。

然后给树莓派上电，再给目标芯片供电。

### 运行OpenOCD

运行OpenOCD：

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

上述操作应该使OpenOCD输出一些文本信息，然后等待（它不会立即返回到Unix shell提示符）。如果OpenOCD自己退出或继续输出文本信息，那么请仔细检查接线。

一旦OpenOCD运行稳定，就可以通过telnet向它发送命令。打开另一个ssh会话，运行下面的命令：

```
telnet 127.0.0.1 4444
```

(可以按ctrl+]退出telnet，然后运行 "quit "命令。)

### OpenOCD和gdb

可以使用OpenOCD和gdb来调试Klipper。下面的命令假设是在台式机上运行gdb。

在OpenOCD的配置文件中加入以下内容：

```
bindto 0.0.0.0
gdb_port 44444
```

在树莓派上重新启动OpenOCD，然后在台式机上运行以下Unix命令：

```
cd /path/to/klipper/
gdb out/klipper.elf
```

在gdb中运行：

```
target remote octopi:44444
```

(用树莓派的主机名替换 "octopi"）一旦gdb运行，就可以设置断点并检查寄存器。
