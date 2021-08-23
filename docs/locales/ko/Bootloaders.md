# 부트로더

이 문서는 클리퍼가 지원하는 마이크로 컨트롤러에 발견되는 공통 부트로더에 대한 정보를 포함하고 있다.

부트로더는 써드파티 소프트웨어다. 처음 전원이 인가될때 마이크로 컨트롤러를 동작시키는 역할을 한다. 이것은 일반적으로 별도 특별한 하드웨어 추가없이 클리퍼와 같은 새로운 어플리케이션을 마이크로컨트롤러에 굽기 위해 사용된다. 불행하게도, 마이크로 컨트롤러를 굽는것에 대한 산업전반 걸친 표준은 존재하지 않는다. 또한 모든 마이크로 컨트롤러에서 작동하는 표준 부트로더도 없다. 더 나아가 각 부트로더는 어플리케이션을 굽기 위해 저마다 다른 절차를 필요로 한다.

만일 마이크로 컨트롤러에 부트로더를 구을 수 있다면 일반적으로 어플리케이션을 굽는 메커니즘을 사용할 수 있다. 그러나 이런 과정속에 부지중에 부트로더를 날려버릴 수 있음을 주의해야 한다. 반대로, 부트로더는 일반적으로 오직 사용자들이 어플리케이션을 굽도록만 허용되어 있다. 그런 이유로 부트로더에 가능한 어플리케이션을 굽는에 사용할것을 권한다.

이 문서는 공통 부트로더와, 부트로더를 구을때 필요한 과정, 그리고 어플리케이션을 구을때 필요한 과정에 대해 기술하려고 한다. 이 문서는 권위있는 참조문서는 아니다 ; 이것은 클리퍼 개발자들이 쌓아둔 유용한 정보의 모임이라는 성격이 있다.

## AVR 마이크로 컨트롤러

In general, the Arduino project is a good reference for bootloaders and flashing procedures on the 8-bit Atmel Atmega micro-controllers. In particular, the "boards.txt" file: <https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt> is a useful reference.

부트로더 자체를 굽기 위해서는 AVR 칩은 (SPI를 사용하여 칩과 통신을 하는) 외부 하드웨어 플래싱 도구가 필요하다. 이 도구는 구입할 수 있다. (예를덜어, 인터넷에서 "avr isp", "arduino isp", 도는 "usb tiny isp" 로 검색해보기 바란다) 또한 AVR 부트로더를 굽기 위해 다른 아두이노나 라즈베리파이를 사용하는 것도 가능하다. (예를 들어 인터넷에 "program an avr using raspberry pi" 검색해보라) 아래 예는 "AVR ISP Mk2" 타입의 디바이스를 사용한다는 전제하에 기록되어있다.

"avrdude" 프로그램은 atmega칩을 굽는데(부트로더와 어플리케이션 플래싱 모두) 사용되어지는 가장 많이 쓰이는 공통 도구이다.

### Atmega2560

이 칩은 전형적으로 "Arduino Mega" 에서 볼 수 있다. 이것은 3D 프린터에 매우 전형적이다.

부트로더 그자체를 굽기 위해 다음과 같이 사용하면 된다. :

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

어플리케이션을 구으려면 다음처럼 사용하라:

```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

이 칩은 일반적으로 "Arduino Mega"의 초기버전에서 발견된다.

부트로더 그자체를 굽기 위해 다음과 같이 사용하면 된다. :

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

어플리케이션을 구으려면 다음처럼 사용하라:

```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

이 칩은 일반적으로 Melzi 스타일 3D 프린터 보드에서 발견된다.

부트로더 그자체를 굽기 위해 다음과 같이 사용하면 된다. :

```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

어플리케이션을 구으려면 다음처럼 사용하라:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

일련의 "Melzi" 스타일 보드들은 57600 baud rate 을 사용하도록 미리 부트로더가 올려져 있음을 기억하라. 이 경우 어플리케이션을 굽기 위해 대신 이와 같이 사용한다. :

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

이 문서는 부트로더를 At90usb1286으로 굽는 방법을 다루지 않으며 이 장치로 플래싱하는 일반 애플리케이션도 다루지 않습니다.

The Teensy++ device from pjrc.com comes with a proprietary bootloader. It requires a custom flashing tool from <https://github.com/PaulStoffregen/teensy_loader_cli>. One can flash an application with it using something like:

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

atmega168 은 제한된 용량을 가지고 있다. 만일 부트로더를 사용한다면 Optiboot 부트로더를 사용할것을 권한다. 부트로더를 굽기 위해 다음과 같이 사용하면 된다. :

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Optiboot 부트로더를 통해 어플리케이션을 구으려면 다음과 같이 사용하라 :

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## SAM3 마이크로 컨트롤러 (Arduino Due)

SAM3 mcu 에 부트로더를 사용하는 것은 일반적이지 않다. 칩 자체가 3.3V 시리얼 포트나 USB 로부터 프로그램된 플래쉬를 허용하는 ROM 을 가지고 있다.

ROM 을 활성화하기 위해 "erase"핀이 리셋할동안 high 에 있도록 한다. 리셋은 플래쉬 컨텐츠를 삭제한다. 그리고 ROM 이 작동된다. Arduino Due 에서 "programming usb port"(파워서플라이에 가장 가까운 USB 포트)에 1200 baud rate 을 셋팅하면 이 과정을 성공적으로 마칠 수 있다.

The code at <https://github.com/shumatech/BOSSA> can be used to program the SAM3. It is recommended to use version 1.9 or later.

어플리케이션을 구으려면 다음처럼 사용하라:

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## SAM4 마이크로 컨트롤러 (Duet Wifi)

SAM4 mcu 에 부트로더를 사용하는 것은 일반적이지 않다. 칩 자체가 3.3V 시리얼 포트나 USB 로부터 프로그램된 플래쉬를 허용하는 ROM 을 가지고 있다.

ROM 을 활성화하기 위해 "erase"핀이 리셋할동안 high 에 있도록 한다. 리셋은 플래쉬 컨텐츠를 삭제한다. 그리고 ROM 이 작동된다.

The code at <https://github.com/shumatech/BOSSA> can be used to program the SAM4. It is necessary to use version `1.8.0` or higher.

어플리케이션을 구으려면 다음처럼 사용하라:

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## SAMD21 마이크로 컨트롤러 (Arduino Zero)

SAMD21 부트로더는 ARM Serial Wire Debug (SWD) 인터페이스를 통해 구워진다. 일반적으로 전용 SWD 하드웨어 동글을 사용해 이루어진다. 다른방법으로는 [Raspberry Pi with OpenOCD](#running-openocd-on-the-raspberry-pi)를 사용할 수 있다.

OpenOCD로 부트로더를 구으려면 다음의 칩 설정을 사용하라 :

```
source [find target/at91samdXX.cfg]
```

부트로더를 얻으려면 - 예:

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

OpenOCD 명령으로 굽는것은 아래와 비슷하게 한다 :

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

SAMD21상에서 가장 일반적인 부트로더는 "Arduino Zero"에서 발견되는 것이다. 그것은 8KiB 부트로더를 사용한다.(어플리케이션은 8KiB의 시작 어드레스와 함께 컴파일되어야 한다) 리셋버튼을 두번 클릭하면 이 부트로더로 들어갈 수 있다. 어플리케이션을 구으려면 아래와 같이 사용하면 된다. :

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

그와는 다르게 "Arduino M0" 16KiB 부트로더를 사용한다. (어플리케이션은 16KiB의 시작 어드레스와 함께 컴파일되어야 한다) 이 부트로더상에 어플리케이션을 굽기 위해 마이크로 컨트롤러를 리셋하고 부팅중 처음 몇초안에 플래쉬 명령을 실행시키도록 하라. 다음과 같이 :

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## SAMD51 마이크로 컨트롤러 (Adafruit Metro-M4 및 유사품)

SAMD21과 같이 SAMD51 부트로더는 ARM Serial Wire Debug(SWD)인터페이스를 통해 구워진다. [OpenOCD on a Raspberry Pi](#running-openocd-on-the-raspberry-pi)로 부트로더를 굽고자 한다면 다음에 나오는 칩 설정을 사용하라.:

```
source [find target/atsame5x.cfg]
```

Obtain a bootloader - several bootloaders are available from <https://github.com/adafruit/uf2-samdx1/releases/latest>. For example:

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

OpenOCD 명령으로 굽는것은 아래와 비슷하게 한다 :

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

SAMD51은 16KiB 부트로더를 사용한다. (어플리케이션은 16KiB의 시작 어드레스와 함께 컴파일되어야 한다) 어플리케이션을 굽기 위해서 다음과 같이 하면 된다.:

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## STM32F103 마이크로 컨트롤러 (Blue Pill 디바이스)

STM32F103 디바이스는 3.3V 시리얼을 통해 부트로더나 어플리케이션을 구울수 있는 ROM을 갖고 있다. 이 ROM 에 접근하려면 "boot 0" 핀은 high 로, "boot 1" 핀은 low로 연결하고 장치를 리셋하도록 하라. "stm32flash" 패키지는 아래와 같이 하여 디바이스를 굽는데 사용할 수 있다.:

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

Note that if one is using a Raspberry Pi for the 3.3V serial, the stm32flash protocol uses a serial parity mode which the Raspberry Pi's "miniuart" does not support. See <https://www.raspberrypi.org/documentation/configuration/uart.md> for details on enabling the full uart on the Raspberry Pi GPIO pins.

플래싱 후에 "boot 0"과 "boot 1"을 모두 다시 low로 설정하여 나중에 플래시에서 부팅을 재설정합니다.

### stm32duino 부트로더를 포함한 STM32F103

The "stm32duino" project has a USB capable bootloader - see: <https://github.com/rogerclarkmelbourne/STM32duino-bootloader>

이 부트로더는 아래와 같이 하여 3.3V 시리얼을 통해 구워질 수 있다 :

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

이 부트로더는 8KiB 플래쉬 공간을 사용한다.(어플리케이션은 8KiB의 시작 어드레스와 함께 컴파일되어야 한다) 다음과 같이 하여 어플리케이션을 굽도록 한다. :

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

일반적으로 부트로더는 오직 부팅후 짧은 시간동안 작동한다. 위 명령을 처리할 시간이 필요할 수도 있다. 그래야 부트로더가 활성화 상태일 동안 실행이 된다(부트로더가 동작중에는 보드 led가 점멸할 것이다). 다른방법으로 리셋이후 부트로더에 머물도록 하려면 "boot 0"핀은 low 로 하고 "boot 1" 는 high 로 셋팅하도록 한다.

### HID 부트로더를 가진 STM32F103

[HID bootloader](https://github.com/Serasidis/STM32_HID_Bootloader)는 컴팩트하며 USB를 통해 플래싱이 가능한 드라이버가 없는 부트로더다. 또한 [fork with builds specific to the SKR Mini E3 1.2](https://github.com/Arksine/STM32_HID_Bootloader/releases/tag/v0.5-beta) 도 가능하다.

blue pill 같은 일반적인 STM32F103 보드에 대해 위에 언급된 stm32duino 섹션에 나오는 stm32flash 를 사용한 3.3v 시리얼을 통한 부트로더를 구을 수도 있다. 파일이름을 원하는 hid 부트로더 바이너리로 변경할 수 있다. (즉: blue pill 대신 hid_generic_pc13.bin ).

SKR Mini E3 에 stm32flash 를 사용하는 것은 불가능하다. 왜냐하면 boot0 핀이 그라운드에 직접 ㅇ녀결되어 있고 헤더핀을 통해 나와 있지 않기 때문이다. 부트로더를 굽기 위해서는 STM32Cubeprogrammer 와 함께 STLink V2를 사용하기를 추천한다. 만약 STLink에 접속하지 않는다면 다음의 칩 설정을 통해 [Raspberry Pi and OpenOCD](#running-openocd-on-the-raspberry-pi)을 사용하는게 가능하다. :

```
source [find target/stm32f1x.cfg]
```

만약 원한다면 다음 명령어로 현재 플래시의 백업을 만들어 놓을 수 있다. 이 작업을 완료하려면 시간이 좀 걸린다는 것을 기억해두라. :

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

마지막으로, 아래와 같은 명령을 통해 플래쉬 할 수 있다 :

```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```

참고:

- 위 예제는 칩을 지우고, 부트로더를 프로그램한다. 소개된 굽는 방법과 관계없이 플래싱하기에 앞서 칩을 지우는걸 추천한다.
- 이 부트로더로 SKR Mini E3 보드를 굽기전에 이점을 알아두어야 한다. 당신은 더이상 sdcard를 통해 펌웨어를 업데이트 할 수 없다는 사실을.
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

이 부트로더는 2KiB의 플래싱 공간을 필요로 한다. (어플리케이션은 2KiB의 시작 어드레스와 함께 컴파일되어야 한다).

hid-flash 프로그램은부트로더에 바이너리를 업로드 하는데 사용된다. 다음과 같은 명령어로 이 소프트웨어를 설치할 수 있다. :

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

만약 부트로더가 동작하고 있다면 다음과 같이 하여 구을 수 있다. :

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

다른방법으론 `make flash`를 사용하여 직접적으로 클리퍼를 구을 수 있다. :

```
make flash FLASH_DEVICE=1209:BEBA
```

또는 만약 클리퍼가 이미 설치되어 있다면 :

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

수동으로 부트로더에 들어가야 할 수도 있다. 이를 위해서 "boot 0" 은 low로 하고 "boot 1" 은 high로 설정하면 된다. SKR Mini E3에선 "Boot 1" 은 사용할 수 없다. 그래서 "hid_btt_skr_mini_e3.bin" 를 설치했다면 PA2핀을 low로 설정하여 진행할 수 있다. 이 핀은 SKR Mini E3의 핀 문서에 TFT 헤더상에 "TX0"라고 라벨이 붙어 있다. PA2 핀 옆에는 그라운드 핀이 있어 이걸 이용해 PA2 를 low 로 셋팅할 수 있다.

## STM32F4 마이크로 컨트롤러 (SKR Pro 1.1)

STM32F4 마이크로 컨트롤러는 DFU를 통한 USB로, 3.3v 시리얼로, 그리고 다양한 방법으로 플래싱이 가능한 빌트인 시스템 부트로더를 보유하고 있다.(보다 자세한 내용은 STM 문서 AN2606 를 참고하라). SKR Pro 1.1같은 일부 STM32F4 보드는 DFU 부트로더로 들어갈 수 없다. HID 부트로더는 STM32F405/407 에서 가능하다. 이 보드들에서는 사용자가 원하는 방식으로 USB나 또는 SD카드로 플래싱할 수 있다. 당신의 보드에 맞게 버전을 설정하고 빌드할 필요가 있다. [build for the SKR Pro 1.1 is available here](https://github.com/Arksine/STM32_HID_Bootloader/releases/tag/v0.5-beta).

DFU 를 사용할 수 없는 보드라면 가장 접근가능한 플래싱 방법은 3.3V 시리얼을 통한 방법이다. 이것은 [flashing the STM32F103 using stm32flash](#stm32f103-micro-controllers-blue-pill-devices)과 동일한 절차를 따라 진행하면 된다. 예를 들어:

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

이 부트로더는 16KiB 의 플래싱 공간이 필요하다.(어플리케이션은 16KiB의 시작 어드레스와 함께 컴파일되어야 한다).

STM32F1 를 사용할 때 처럼 STM32F4 도 MCD에 바이너르를 업로드 하기 위해 Hid-flash 도구를 사용한다. hid-flash 를 어떻게 빌드하고 사용하는지에 대한 자세한 내용은 위의 나오는 지시사항을 참고하기 바란다.

수동으로 부트로더에 들어갈 필요가 있다. 이는 "boot 0" 를 low, "boot 1" 를 high로 설정하고 디바이스에 연결함으로 가능하다. 프로그램이 완료된 후에 장치를 분리하고 "boot 1"은 low 로 돌려놓도록 한다. 이렇게 하여 어플리케이션이 로드될 것이다.

## LPC176x 마이크로 컨트롤러 (Smoothieboards)

This document does not describe the method to flash a bootloader itself - see: <http://smoothieware.org/flashing-the-bootloader> for further information on that topic.

It is common for Smoothieboards to come with a bootloader from: <https://github.com/triffid/LPC17xx-DFU-Bootloader>. When using this bootloader the application must be compiled with a start address of 16KiB. The easiest way to flash an application with this bootloader is to copy the application file (eg, `out/klipper.bin`) to a file named `firmware.bin` on an SD card, and then to reboot the micro-controller with that SD card.

## 라즈베리파이상에 OpenOCD를 실행

OpenOCD는 로우레벨 칩 플래생과 디버깅을 수행할 수 있는 소프트웨어 패키지이다. 그것은 다양한 ARM 칩과 통신하기 위해 라즈베리파이상의 GPIO 핀을 사용할 수 있다.

This section describes how one can install and launch OpenOCD. It is derived from the instructions at: <https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>

소프트웨어를 다운로드 하고 컴파일하여 시작하라. (각 단계에는 몇분 가량 소요된다. "make" 단계는 30분 이상 걸릴 수도 있다):

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

### OpenOCD 설정

OpenOCD 설정파일을 만들라:

```
nano ~/openocd/openocd.cfg
```

다음과 같은 방식을 사용하라:

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

### 목표 칩에 라즈베리파이를 배선연결

라즈베리파이와 타겟 칩에 배선연결하기전 전원을 끄도록 하라. 라즈베리파이에 연결하기에 앞서 타겟칩은 3.3V 를 사용함을 확인하라!

타겟칩상에 GND, SWDCLK, SWDIO, 그리고 RST 을 라즈베리파이에 있는 GND, GPIO25,GPIO24, 그리고 GPIO18 에 각각 대응하여 연결한다.

그리고 라즈베리파이의 전원을 켜고 타겟칩에 전원을 공급한다.

### OpenOCD를 실행

OpenOCD를 실행:

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

위 작업은 OpenOCD 가 몇개의 텍스트 메시지를 내보내게 합니다. 그리고 나서 기다리십시오. (너무 급하게 Unix 쉘 프롬프트로 돌아가지 말아야 합니다) OpenOCD가 자체적으로 종료되거나 계속해서 문자 메시지를 내보내는 경우 배선을 다시 확인하십시오.

한번 OpenOCD 가 작동하고 안정화되면, telnet 을 통해 명령을 보낼 수 있습니다. 다른 ssh 세션을 열어 아래와 같이 실행시키십시오:

```
telnet 127.0.0.1 4444
```

(ctrl+] 를 누르고 "quit" 명령을 실행시켜 telnet 을 빠져나올 수 있습니다. )

### OpenOCD 와 gdb

클리퍼를 디버그하기 위해 OpenOCD 를 gbd와 함께 사용할 수 있습니다. 다음 명령은 컵퓨터 class 머신에 gbd를 실행시키는걸 가정하고 있습니다.

다음은 OpenOCD 설정에 추가하십시오:

```
bindto 0.0.0.0
gdb_port 44444
```

라즈베리파이상에서 OpenOCD 를 재실행하고 컴퓨터 상에서 다음 유닉스 명령을 실행시키십시오:

```
cd /path/to/klipper/
gdb out/klipper.elf
```

gbd 내에서 실행시키십시오:

```
target remote octopi:44444
```

(라즈베리파이의 호스트이름으로 "octopi"를 대체하십시오.) gbd 가 실행되고 있다면 브레이크 포인트를 셋팅하고 레지스터를 점검하는것이 가능하다.
