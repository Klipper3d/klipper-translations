# Bootloaders

本文档提供了有关 Klipper 支持的微控制器上常见引导加载程序的信息。

引导程序是第三方软件，在微控制器首次通电时在其上运行。它通常用于将一个新的应用程序（例如，Klipper）闪存到微控制器上，而不需要专门的硬件。遗憾的是，目前还没有一刷写微控制器的工业标准，也没有一个适用于所有微控制器的标准引导程序。更糟糕的是，每个引导程序都需要一套不同的步骤来闪现一个应用程序但是这这很常见。

如果一个人可以在微控制器上刷写一个引导程序，那么他通常也可以使用这个机制来刷写一个应用程序，但是在这样做的时候应该小心，因为他可能会无意中删除引导程序。与此相反，引导程序一般只允许用户刷写应用程序。因此，建议在可能的情况下使用引导程序来闪存应用程序。

本文件试图描述常见的引导程序，刷写引导程序所需的步骤，以及刷写应用程序所需的步骤。这个文档不是一个权威的参考资料，它是作为Klipper开发者积累的有用信息的一个集合。

## AVR micro-controllers

In general, the Arduino project is a good reference for bootloaders and flashing procedures on the 8-bit Atmel Atmega micro-controllers. In particular, the "boards.txt" file: <https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt> is a useful reference.

要刷写引导程序本身，AVR芯片需要一个外部硬件刷写工具（它使用SPI与芯片进行通信）。这个工具可以购买（例如，在网上搜索 "avr isp"、"arduino isp "或 "usb tiny isp"）。也可以使用另一个Arduino或Raspberry Pi来闪存AVR引导程序（例如，在网上搜索 "用raspberry pi编程AVR"）。下面的例子是在假设使用 "AVR ISP Mk2 "类型的设备的情况下编写的。

"avrdude "程序是最常用的工具，用于刷写atmega芯片（包括引导程序刷写和应用程序刷写）。

### Atmega2560

这种芯片通常出现在 "Arduino Mega"中并且在3D打印机主板中非常常见。

要刷写引导程序本身：

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

要刷写引导程序本身：

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

要刷写引导程序本身：

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

The Teensy++ device from pjrc.com comes with a proprietary bootloader. It requires a custom flashing tool from <https://github.com/PaulStoffregen/teensy_loader_cli>. One can flash an application with it using something like:

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

要通过Optibootbootloader 刷写一个应用程序，请使用以下方法：

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## SAM3 微控制器 (Arduino Due)

使用SAM3 mcu的bootloader是不常见的。芯片本身有一个ROM，允许从3.3V serial port 或从USB对闪存进行编程。

为了启用ROM，"erase"引脚在复位过程中保持高电平，这将擦除闪存的内容，并使ROM运行。在Arduino Due上，这个程序可以通过在 "programming usb port"（最靠近电源的USB端口）上设置1200的波特率来完成。

The code at <https://github.com/shumatech/BOSSA> can be used to program the SAM3. It is recommended to use version 1.9 or later.

要刷写一个应用程序使用：

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## SAM4 micro-controllers (Duet Wifi)

It is not common to use a bootloader with the SAM4 mcu. The chip itself has a ROM that allows the flash to be programmed from 3.3V serial port or from USB.

To enable the ROM, the "erase" pin is held high during a reset, which erases the flash contents, and causes the ROM to run.

The code at <https://github.com/shumatech/BOSSA> can be used to program the SAM4. It is necessary to use version `1.8.0` or higher.

要刷写一个应用程序使用：

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## SAMD21 micro-controllers (Arduino Zero)

The SAMD21 bootloader is flashed via the ARM Serial Wire Debug (SWD) interface. This is commonly done with a dedicated SWD hardware dongle. Alternatively, one can use a [Raspberry Pi with OpenOCD](#running-openocd-on-the-raspberry-pi).

To flash a bootloader with OpenOCD use the following chip config:

```
source [find target/at91samdXX.cfg]
```

Obtain a bootloader - for example:

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

Flash with OpenOCD commands similar to:

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

The most common bootloader on the SAMD21 is the one found on the "Arduino Zero". It uses an 8KiB bootloader (the application must be compiled with a start address of 8KiB). One can enter this bootloader by double clicking the reset button. To flash an application use something like:

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

In contrast, the "Arduino M0" uses a 16KiB bootloader (the application must be compiled with a start address of 16KiB). To flash an application on this bootloader, reset the micro-controller and run the flash command within the first few seconds of boot - something like:

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## SAMD51 micro-controllers (Adafruit Metro-M4 and similar)

Like the SAMD21, the SAMD51 bootloader is flashed via the ARM Serial Wire Debug (SWD) interface. To flash a bootloader with [OpenOCD on a Raspberry Pi](#running-openocd-on-the-raspberry-pi) use the following chip config:

```
source [find target/atsame5x.cfg]
```

Obtain a bootloader - several bootloaders are available from <https://github.com/adafruit/uf2-samdx1/releases/latest>. For example:

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

Flash with OpenOCD commands similar to:

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

The SAMD51 uses a 16KiB bootloader (the application must be compiled with a start address of 16KiB). To flash an application use something like:

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## STM32F103 micro-controllers (Blue Pill devices)

The STM32F103 devices have a ROM that can flash a bootloader or application via 3.3V serial. To access this ROM, one should connect the "boot 0" pin to high and "boot 1" pin to low, and then reset the device. The "stm32flash" package can then be used to flash the device using something like:

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

Note that if one is using a Raspberry Pi for the 3.3V serial, the stm32flash protocol uses a serial parity mode which the Raspberry Pi's "miniuart" does not support. See <https://www.raspberrypi.org/documentation/configuration/uart.md> for details on enabling the full uart on the Raspberry Pi GPIO pins.

After flashing, set both "boot 0" and "boot 1" back to low so that future resets boot from flash.

### STM32F103 with stm32duino bootloader

The "stm32duino" project has a USB capable bootloader - see: <https://github.com/rogerclarkmelbourne/STM32duino-bootloader>

This bootloader can be flashed via 3.3V serial with something like:

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

This bootloader uses 8KiB of flash space (the application must be compiled with a start address of 8KiB). Flash an application with something like:

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

The bootloader typically runs for only a short period after boot. It may be necessary to time the above command so that it runs while the bootloader is still active (the bootloader will flash a board led while it is running). Alternatively, set the "boot 0" pin to low and "boot 1" pin to high to stay in the bootloader after a reset.

### STM32F103 with HID bootloader

The [HID bootloader](https://github.com/Serasidis/STM32_HID_Bootloader) is a compact, driverless bootloader capable of flashing over USB. Also available is a [fork with builds specific to the SKR Mini E3 1.2](https://github.com/Arksine/STM32_HID_Bootloader/releases/tag/v0.5-beta).

For generic STM32F103 boards such as the blue pill it is possible to flash the bootloader via 3.3v serial using stm32flash as noted in the stm32duino section above, substituting the file name for the desired hid bootloader binary (ie: hid_generic_pc13.bin for the blue pill).

It is not possible to use stm32flash for the SKR Mini E3 as the boot0 pin is tied directly to ground and not broken out via header pins. It is recommended to use a STLink V2 with STM32Cubeprogrammer to flash the bootloader. If you don't have access to a STLink it is also possible to use a [Raspberry Pi and OpenOCD](#running-openocd-on-the-raspberry-pi) with the following chip config:

```
source [find target/stm32f1x.cfg]
```

If you wish you can make a backup of the current flash with the following command. Note that it may take some time to complete:

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

finally, you can flash with commands similar to:

```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```

NOTES:

- The example above erases the chip then programs the bootloader. Regardless of the method chosen to flash it is recommended to erase the chip prior to flashing.
- Prior flashing the SKR Mini E3 with this bootloader you should be aware that you will no longer be able to update firmware via the sdcard.
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
After which you can release the reset button.

This bootloader requires 2KiB of flash space (the application must be compiled with a start address of 2KiB).

The hid-flash program is used to upload a binary to the bootloader. You can install this software with the following commands:

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

If the bootloader is running you can flash with something like:

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

alternatively, you can use `make flash` to flash klipper directly:

```
make flash FLASH_DEVICE=1209:BEBA
```

OR if klipper has been previously flashed:

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

It may be necessary to manually enter the bootloader, this can be done by setting "boot 0" low and "boot 1" high. On the SKR Mini E3 "Boot 1" is not available, so it may be done by setting pin PA2 low if you flashed "hid_btt_skr_mini_e3.bin". This pin is labeld "TX0" on the TFT header in the SKR Mini E3's "PIN" document. There is a ground pin next to PA2 which you can use to pull PA2 low.

## STM32F4 micro-controllers (SKR Pro 1.1)

STM32F4 microcontrollers come equipped with a built-in system bootloader capable of flashing over USB (via DFU), 3.3v Serial, and various other methods (see STM Document AN2606 for more information). Some STM32F4 boards, such as the SKR Pro 1.1, are not able to enter the DFU bootloader. The HID bootloader is available for STM32F405/407 based boards should the user prefer flashing over USB over using the sdcard. Note that you may need to configure and build a version specific to your board, a [build for the SKR Pro 1.1 is available here](https://github.com/Arksine/STM32_HID_Bootloader/releases/tag/v0.5-beta).

Unless your board is DFU capable the most accessable flashing method is likely via 3.3v serial, which follows the same procedure as [flashing the STM32F103 using stm32flash](#stm32f103-micro-controllers-blue-pill-devices). For example:

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

This bootloader requires 16Kib of flash space on the STM32F4 (the application must be compiled with a start address of 16KiB).

As with the STM32F1, the STM32F4 uses the hid-flash tool to upload binaries to the MCU. See the instructions above for details on how to build and use hid-flash.

It may be necessary to manually enter the bootloader, this can be done by setting "boot 0" low, "boot 1" high and plugging in the device. After programming is complete unplug the device and set "boot 1" back to low so the application will be loaded.

## LPC176x micro-controllers (Smoothieboards)

This document does not describe the method to flash a bootloader itself - see: <http://smoothieware.org/flashing-the-bootloader> for further information on that topic.

It is common for Smoothieboards to come with a bootloader from: <https://github.com/triffid/LPC17xx-DFU-Bootloader>. When using this bootloader the application must be compiled with a start address of 16KiB. The easiest way to flash an application with this bootloader is to copy the application file (eg, `out/klipper.bin`) to a file named `firmware.bin` on an SD card, and then to reboot the micro-controller with that SD card.

## Running OpenOCD on the Raspberry PI

OpenOCD is a software package that can perform low-level chip flashing and debugging. It can use the GPIO pins on a Raspberry Pi to communicate with a variety of ARM chips.

This section describes how one can install and launch OpenOCD. It is derived from the instructions at: <https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>

Begin by downloading and compiling the software (each step may take several minutes and the "make" step may take 30+ minutes):

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

### Configure OpenOCD

Create an OpenOCD config file:

```
nano ~/openocd/openocd.cfg
```

Use a config similar to the following:

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

### Wire the Raspberry Pi to the target chip

Poweroff both the the Raspberry Pi and the target chip before wiring! Verify the target chip uses 3.3V prior to connecting to a Raspberry Pi!

Connect GND, SWDCLK, SWDIO, and RST on the target chip to GND, GPIO25, GPIO24, and GPIO18 respectively on the Raspberry Pi.

Then power up the Raspberry Pi and provide power to the target chip.

### Run OpenOCD

Run OpenOCD:

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

The above should cause OpenOCD to emit some text messages and then wait (it should not immediately return to the Unix shell prompt). If OpenOCD exits on its own or if it continues to emit text messages then double check the wiring.

Once OpenOCD is running and is stable, one can send it commands via telnet. Open another ssh session and run the following:

```
telnet 127.0.0.1 4444
```

(One can exit telnet by pressing ctrl+] and then running the "quit" command.)

### OpenOCD and gdb

It is possible to use OpenOCD with gdb to debug Klipper. The following commands assume one is running gdb on a desktop class machine.

Add the following to the OpenOCD config file:

```
bindto 0.0.0.0
gdb_port 44444
```

Restart OpenOCD on the Raspberry Pi and then run the following Unix command on the desktop machine:

```
cd /path/to/klipper/
gdb out/klipper.elf
```

Within gdb run:

```
target remote octopi:44444
```

(Replace "octopi" with the host name of the Raspberry Pi.) Once gdb is running it is possible to set breakpoints and to inspect registers.
