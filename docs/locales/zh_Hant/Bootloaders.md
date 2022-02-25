# 底層載入程式

本文件介紹Klipper支援的用於微控制器的底層載入程式（bootloader）。

載入程式是第三方軟體，在微控制器上電后優先執行。該程式可以在不需要特殊硬體（如燒錄器）下對微控制器的程式進行刷寫（如寫入Klipper程式）。然而，目前還沒有一刷寫微控制器的工業標準，也沒有一個適用於所有微控制器的標準載入程式。更麻煩的是，每種引導載入程式需要不同的步驟以觸發刷寫功能。

如果能用某種方式將 bootloader 刷寫到微控制器，使用該方式通常也能完成程式刷寫操作，但是，這種直接刷寫可能會將 bootloader 覆蓋掉。相對地，bootloader 只允許使用者刷寫應用程式區域。因此，儘可能使用 bootloader 完成程式的刷寫。

該文件將盡可能介紹常見的bootloaders，刷入bootloader所需的步驟和觸發bootloader進行程式刷寫的流程。該文件亦非官方指引，這只是在Klipper開發人員使用過程中收集到的有用資訊。

## AVR 微控制器

總體上來說，Arduino專案是8位Atmel Atmega微控制器的載入程式和刷寫程式的好的參考。特別是" boards.txt "檔案。 <https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt>是一個有用的參考。

要刷寫載入程式本身，AVR 晶片需要一個外部硬體刷寫工具（它使用 SPI 與晶片進行通訊）。這個工具可以購買（例如，在網上搜索 "avr isp"、"arduino isp "或 "usb tiny isp"）。也可以使用另一個Arduino或Raspberry Pi來快閃記憶體AVR載入程式（例如，在網上搜索 "用raspberry pi程式設計AVR"）。下面的例子是在假設使用 "AVR ISP Mk2 "型別的裝置的情況下編寫的。

"avrdude "程式是最常用的工具，用於刷寫atmega晶片（包括載入程式刷寫和應用程式刷寫）。

### Atmega2560

這個晶片通常出現在 "Arduino Mega" 中，在3D印表機主板中也十分普遍。

要刷寫載入程式本身，請使用類似以下的方法：

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要刷寫一個應用程式使用：

```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

這個晶片通常出現在早期版本的 "Arduino Mega "中。

要刷寫載入程式本身，請使用類似以下的方法：

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要刷寫一個應用程式使用：

```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

這種晶片通常出現在 "Melzi "式的3D印表機主板上。

要刷寫載入程式本身，請使用類似以下的方法：

```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要刷寫一個應用程式使用：

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

注意，一些 "Melzi "風格的板子預載了一個使用57600波特率的載入程式。在這種情況下，要刷寫一個應用程式，請使用類似這樣的東西來代替：

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

本檔案不包括向At90usb1286刷寫載入程式的方法，也不包括向該裝置刷寫一般應用。

來自pjrc.com的Teensy++裝置帶有一個專用的載入程式。它需要一個來自 <https://github.com/PaulStoffregen/teensy_loader_cli>的定製刷寫工具。可以用這個工具來刷寫一個應用程式，例如：

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

atmega168的快閃記憶體空間有限。如果使用載入程式，建議使用Optiboot bootloader。要刷寫該載入程式，請使用這個的方法：

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

要通過Optiboot bootloader 刷寫一個應用程式，請使用以下方法：

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## SAM3 微控制器 (Arduino Due)

通常在 SAM 3 微控制器上不使用載入程式。晶片自帶一個允許從3.3V 串列埠或從USB進行程式設計的ROM。

爲了啟用ROM，將"erase"引腳在復位過程中保持高電平，這將擦除快閃記憶體的內容，並使ROM執行。在Arduino Due上，這個程式可以通過在 "programming usb port"（程式設計USB口，最靠近電源的USB埠）上設定1200的波特率來完成。

 <https://github.com/shumatech/BOSSA>中的程式碼可以用來為SAM3程式設計。建議使用1.9或更高版本。

要刷寫一個應用程式使用：

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## SAM4 微控制器 (Duet Wifi)

通常在 SAM4 微控制器中不使用載入程式。晶片自帶一個可以從 3.3V 串列埠或 USB 進行程式設計的ROM。

爲了啟用ROM，在復位過程中要將"erase"引腳保持為高電平，這將擦除快閃記憶體內容，並使ROM執行。

 <https://github.com/shumatech/BOSSA>中的程式碼可以用來為SAM4程式設計。需要使用`1.8.0`或更高的版本。

要刷寫一個應用程式使用：

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## SAMD21微控制器（Arduino Zero）

SAMD21 引導載入程式通過 ARM 序列線除錯 （SWD） 介面進行刷寫，通常需要一個專用的 SWD 硬體轉換器或者使用[安裝了 OpenOCD 的 Raspberry Pi](#running-openocd-on-the-raspberry-pi)來完成。

要使用 OpenOCD 刷寫引導載入程式，請使用以下晶片配置：

```
來源 [查詢目標/at91samdXX.cfg]
```

獲取引導載入程式 - 例如：

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

使用類似下面的 OpenOCD 命令來刷寫：

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

SAMD21上最常見的啟動載入程式可以在 "Arduino Zero "上找到。它使用一個 8KiB 的載入程式（應用程式必須以 8KiB 的起始地址進行編譯），按下復位按鈕兩次就可以進入。要刷寫一個程式，請使用類似以下的方法：

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

相比之下，"Arduino M0 "使用一個 16KiB 的啟動載入程式（程式必須用 16KiB 的起始地址進行編譯）。使用這個啟動載入程式來刷寫一個程式，請重置微控制器，並在啟動的頭幾秒鐘內執行刷寫命令--類似如下命令：

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## SAMD51 微控制器(Adafruit Metro-M4及類似的開發板)

和 SAMD21 一樣，SAMD51 的啟動載入程式也是通過 ARM 序列線除錯（SWD）介面刷寫的。要用[執行 OpenOCD的 Raspberry Pi](#running-openocd-on-the-raspberry-pi)刷寫載入程式，請使用以下晶片配置：

```
來源 [查詢目標/atsame5x.cfg]
```

獲得一個載入程式--很多載入程式可以從 <https://github.com/adafruit/uf2-samdx1/releases/latest>獲得。例如：

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

使用類似下面的 OpenOCD 命令來刷寫：

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

SAMD51 使用 16KiB 的啟動載入程式（應用程式必須以16KiB的起始地址進行編譯）。要刷寫一個應用程式，請使用類似以下的方法：

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## STM32F103 微控制器（Blue Pill 開發板）

STM32F103 產品線的晶片包含一個可以通過 3.3V 串列埠刷寫載入程式或應用程式的ROM。要訪問這個ROM，在"boot 0 "引腳接到高電平"boot 1 " 引腳接到低電平後重置晶片。然後，可以使用 "stm32flash "軟體包，使用類似以下的命令刷寫：

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

注意，如果使用樹莓派的3.3V串列埠，stm32flash協議使用的序列奇偶校驗模式，樹莓派的 "mini UART "並不支援。關於在樹莓派的GPIO引腳上啟用完整的UART的細節，見 <https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts>。

刷寫后，將 "boot 0 "和 "boot 1 "都恢復設為低電平，以便在復位后從快閃記憶體啟動。

### 帶有 stm32duino 引導載入程式的 STM32F103

"stm32duino "專案有一個USB功能的載入程式-參見： <https://github.com/rogerclarkmelbourne/STM32duino-bootloader>

這個載入程式可以通過3.3V的串列埠用類似以下的命令來刷寫：

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

這個載入程式使用 8KiB 的快閃記憶體空間（應用程式必須以 8KiB 的起始地址編譯）。刷寫應用程式需要使用類似以下的命令：

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

啟動載入程式通常只在啟動后的一小段時間執行。在輸入以上命令的時候，需要確保啟動載入程式還在執行（啟動載入程式執行的時候會控制板上的led閃爍）。此外，啟動后如果設定「boot 0」引腳為低，設定「boot 1」引腳為高則可以一直停留在啟動載入程式。

### 帶有 HID 載入程式的STM32F103

[HID bootloader](https://github.com/Serasidis/STM32_HID_Bootloader)是一個緊湊的、不包含驅動的啟動載入程式，能夠通過USB進行刷寫。此外，還有一個[針對SKR Mini E3 1.2構建的分支](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest)。

對於常見的STM32F103板，如Blue Pill，和 stm32duino 章節中一樣，可以通過 3.3v 序列用stm32flash 刷寫啟動載入程式，將檔名替換為所需的 hid載入程式二進制檔案（例如Blue Pill 使用的 hid_generic_pc13.bin）。

SKR Mini E3無法使用stm32flash ，因為boot 0引腳被直接接到GND且沒有跳線斷開。推薦使用STLink V2通過STM32Cubeprogrammer刷寫啟動載入程式。如果你沒有STLink ，也可以按照以下晶片配置使用[樹莓派和OpenOCD](#running-openocd-on-the-raspberry-pi) 刷寫：

```
來源 [查詢目標/stm32f1x.cfg]
```

如果你願意，可以使用下面的命令備份目前快閃記憶體上的程式。請注意，這可能需要一些時間來完成備份：

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

最後，你可以用類似以下的命令刷寫韌體：

```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```

注意：

- 上面的例子是先擦除晶片，然後再寫入載入程式。無論選擇哪種方法刷寫，都建議在刷寫前擦除晶片。
- 在用這個載入程式刷寫SKR Mini E3之前，你需要知道之後你將不能再通過SD卡更新韌體。
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
之後可以鬆開復位按鈕。

這個載入程式需要2KiB的快閃記憶體空間（應用程式必須以2KiB的起始地址進行編譯）。

hid-flash程式是用來上傳二進制檔案到啟動載入程式的。你可以用以下命令安裝這個軟體：

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

如果bootloader正在執行，你可以用這個來刷寫：

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

或者，你可以使用`make flash`來直接刷寫klipper：

```
make flash FLASH_DEVICE=1209:BEBA
```

或者，如果klipper之前已經被寫入過：

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

可能需要手動進入載入程式，這可以通過設定 "boot 0 "的低電平和 "boot 1 "的高電平來完成。在SKR Mini E3上，"Boot 1 "是不可用的，所以如果你寫入過"hid_btt_skr_mini_e3.bin"，可以通過設定PA2的低電平來完成。在SKR Mini E3的 "PIN "檔案中，這個引腳在TFT插座上被標記為 "TX0"。在PA2旁邊有一個接地引腳，你可以用它來把PA2拉低。

## STM32F4 微控制器 (SKR Pro 1.1)

STM32F4微控制器配備了一個內建的系統載入程式，能夠通過USB（通過DFU）、3.3v串列埠和其他各種方法進行刷寫（更多資訊見STM檔案AN2606）。一些STM32F4板，如SKR Pro 1.1，不能進入DFU載入程式。基於STM32F405/407的板子可以使用HID載入程式，如果使用者願意通過USB刷寫而不是使用SD卡。請注意，你可能需針對你的板子配置和構建一個特定的版本，[針對SKR Pro 1.1的構建可以在這裡找到](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest)。

除非你的板子有DFU功能，否則最容易的寫入方法可能是通過3.3v的串列埠，這與[使用stm32flash刷寫STM32F103](#stm32f103-micro-controllers-blue-pill-devices)的步驟相同。例如：

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

這個載入程式在STM32F4上需要16Kib的快閃記憶體空間（應用程式必須以16KiB的起始地址進行編譯）。

與STM32F1一樣，STM32F4使用hid-flash工具來上傳二進制檔案到MCU。關於如何構建和使用hid-flash的細節，請參見上面的說明。

可能需要手動進入載入程式，這可以通過設定 "boot 0 "為低電平，"boot 1 "為高電平並上電來完成。程式設計完成後，裝置斷電，將 "boot 1 "重設為低電平，這樣應用程式就會被載入。

## LPC176x微控制器（Smoothieboards）

本檔案沒有描述刷寫載入程式本身的方法--見： <http://smoothieware.org/flashing-the-bootloader>以獲得關於該主題的進一步資訊。

Smoothieboards通常帶有一個來自 <https://github.com/triffid/LPC17xx-DFU-Bootloader>的bootloader。當使用這個載入程式時，應用程式必須以16KiB的起始地址進行編譯。用這個載入程式刷寫應用程式的最簡單方法是將應用程式檔案（例如`out/klipper.bin`）複製到SD卡上一個名為`firmware.bin`的檔案，然後用該SD卡重新啟動微控制器。

## 在樹莓派上執行OpenOCD

OpenOCD是一個軟體包，可以進行底層的晶片程式設計和除錯。它可以使用樹莓派上的GPIO引腳與各種ARM晶片通訊。

本節描述瞭如何安裝和啟動OpenOCD。它來自於以下的說明： <https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>

開始下載和編譯軟體（每個步驟可能需要數分鐘，"make "步驟可能需要30分鐘以上）：

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

建立一個OpenOCD配置檔案：

```
nano ~/openocd/openocd.cfg
```

使用類似於以下的配置：

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

### 將樹莓派與目標晶片相連

在接線之前，請關閉樹莓派和目標晶片的電源! 在連線到樹莓派之前，請確認目標晶片使用3.3V電壓!

將目標晶片上的GND、SWDCLK、SWDIO和RST分別連線到樹莓派上的GND、GPIO25、GPIO24和GPIO18。

然後給樹莓派上電，再給目標晶片供電。

### 執行OpenOCD

執行OpenOCD：

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

上述操作應該使OpenOCD輸出一些文字資訊，然後等待（它不會立即返回到Unix shell提示符）。如果OpenOCD自己退出或繼續輸出文字資訊，那麼請仔細檢查接線。

一旦OpenOCD執行穩定，就可以通過telnet向它發送命令。打開另一個ssh會話，執行下面的命令：

```
telnet 127.0.0.1 4444
```

(可以按ctrl+]退出telnet，然後執行 "quit "命令。)

### OpenOCD和gdb

可以使用OpenOCD和gdb來除錯Klipper。下面的命令假設是在臺式機上執行gdb。

在OpenOCD的配置檔案中加入以下內容：

```
bindto 0.0.0.0
gdb_port 44444
```

在樹莓派上重新啟動OpenOCD，然後在臺式機上執行以下Unix命令：

```
cd /path/to/klipper/
gdb out/klipper.elf
```

在gdb中執行：

```
target remote octopi:44444
```

(用樹莓派的主機名替換 "octopi"）一旦gdb執行，就可以設定斷點並檢查暫存器。
