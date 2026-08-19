# Загрузчики

В этом документе содержится информация об общих загрузчиках, которые можно найти на микроконтроллерах, поддерживаемых Klipper.

Загрузчик - это стороннее программное обеспечение, которое запускается на микроконтроллере при его первом включении. Обычно он используется для прошивки нового приложения (например, Klipper) на микроконтроллер, не требуя специального оборудования. К сожалению, не существует общепромышленного стандарта для перепрошивки микроконтроллера, равно как и стандартного загрузчика, который работал бы на всех микроконтроллерах. Хуже того, для каждого загрузчика обычно требуется различный набор шагов для прошивки приложения.

Если можно прошить загрузчик на микроконтроллер, то, как правило, можно также использовать этот механизм для прошивки приложения, но при этом следует соблюдать осторожность, поскольку можно непреднамеренно удалить загрузчик. В отличие от этого, загрузчик, как правило, разрешает пользователю только прошивать приложение. Поэтому рекомендуется использовать загрузчик для прошивки приложения, где это возможно.

В этом документе предпринята попытка описать распространенные загрузчики, шаги, необходимые для прошивки загрузчика, и шаги, необходимые для прошивки приложения. Этот документ не является авторитетной ссылкой; он предназначен для сбора полезной информации, накопленной разработчиками Klipper.

## AVR micro-controllers

В целом, проект Arduino является хорошим справочником по загрузчикам и процедурам прошивки 8-битных микроконтроллеров Atmel Atmega. В частности, файл "boards.txt": <https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt> является полезным справочником.

Для самостоятельной прошивки загрузчика в микросхемах AVR требуется внешнее аппаратное средство прошивки (которое взаимодействует с микросхемой по интерфейсу SPI). Такой инструмент можно приобрести (например, выполните поиск в Интернете по словам "avr isp", "arduino isp" или "usb tiny isp"). Также можно использовать другую Arduino или Raspberry Pi для прошивки загрузчика AVR (например, выполните поиск в Интернете по запросу "program an avr using raspberry pi"). Приведенные ниже примеры написаны в предположении, что используется устройство типа "AVR ISP Mk2".

Программа "avrdude" является наиболее распространенным инструментом, используемым для прошивки микросхем atmega (как для прошивки загрузчика, так и для прошивки приложений).

### Atmega2560

Этот чип обычно встречается в "Arduino Mega" и очень распространен в платах для 3d-принтеров.

Чтобы прошить сам загрузчик, используйте что-то вроде:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Чтобы прошить приложение, используйте что-то вроде:

```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

Этот чип обычно встречается в ранних версиях "Arduino Mega".

Чтобы прошить сам загрузчик, используйте что-то вроде:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Чтобы прошить приложение, используйте что-то вроде:

```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

Этот чип часто встречается в платах для 3d-принтеров типа "Melzi".

Чтобы прошить сам загрузчик, используйте что-то вроде:

```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Чтобы прошить приложение, используйте что-то вроде:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

Обратите внимание, что некоторые платы типа "Melzi" поставляются с предустановленным загрузчиком, который использует скорость передачи данных 57600. В этом случае для прошивки приложения используйте что-то вроде этого:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

В этом документе не рассматривается метод прошивки загрузчика в At90usb1286, а также прошивка общих приложений для этого устройства.

Устройство Teensy++ от pjrc.com поставляется с проприетарным загрузчиком. Для его прошивки требуется пользовательская утилита с сайта <https://github.com/PaulStoffregen/teensy_loader_cli>. С его помощью можно прошить приложение, используя что-то вроде:

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

Флэш-память atmega168 имеет ограниченное пространство. Если вы используете загрузчик, рекомендуется использовать загрузчик Optiboot. Чтобы прошить этот загрузчик, используйте что-то вроде:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Чтобы прошить приложение через загрузчик Optiboot, выполните следующие действия:

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## Микроконтроллеры SAM3 (Arduino Due)

Использование загрузчика с микросхемой SAM3 не является обычным делом. Сама микросхема имеет ПЗУ, позволяющее программировать флэш-память с последовательного порта 3,3 В или с USB.

Чтобы включить ПЗУ, во время сброса удерживается высокий уровень на контакте "erase", который стирает содержимое флэш-памяти и запускает ПЗУ. На Arduino Due эту последовательность можно выполнить, установив скорость передачи 1200 бод на "программирующем usb-порту" (USB-порт, ближайший к источнику питания).

Для программирования SAM3 можно использовать код по адресу <https://github.com/shumatech/BOSSA>. Рекомендуется использовать версию 1.9 или более позднюю.

Чтобы прошить приложение, используйте что-то вроде:

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## Микроконтроллеры SAM4 (Duet Wifi)

Использование загрузчика с микросхемой SAM4 не является обычным делом. Сама микросхема имеет ПЗУ, позволяющее программировать флэш-память с последовательного порта 3,3 В или с USB.

Чтобы включить ПЗУ, во время сброса удерживайте вывод "erase" в высоком состоянии, что стирает содержимое флэш-памяти и запускает ПЗУ.

Код по адресу <https://github.com/shumatech/BOSSA> может быть использован для программирования SAM4. Необходимо использовать версию `1.8.0` или выше.

Чтобы прошить приложение, используйте что-то вроде:

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## Микроконтроллеры SAMDC21 (Duet3D Toolboard 1LC)

Прошивка SAMC21 осуществляется через интерфейс ARM Serial Wire Debug (SWD). Обычно для этого используется специальный аппаратный SWD-ключ. В качестве альтернативы можно использовать [Raspberry Pi with OpenOCD](#running-openocd-on-the-raspberry-pi).

When using OpenOCD with the SAMC21, extra steps must be taken to first put the chip into Cold Plugging mode if the board makes use of the SWD pins for other purposes. If using OpenOCD on a Raspberry Pi, this can be done by running the following commands before invoking OpenOCD.

```
SWCLK=25
SWDIO=24
SRST=18

echo "Экспорт выводов SWCLK и SRST".
echo $SWCLK > /sys/class/gpio/export
echo $SRST > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$SWCLK/direction
echo "out" > /sys/class/gpio/gpio$SRST/direction

echo "Установка низкого уровня SWCLK и подача импульсов на SRST".
echo "0" > /sys/class/gpio/gpio$SWCLK/value
echo "0" > /sys/class/gpio/gpio$SRST/value
echo "1" > /sys/class/gpio/gpio$SRST/value

echo "Неэкспорт выводов SWCLK и SRST".
echo $SWCLK > /sys/class/gpio/unexport
echo $SRST > /sys/class/gpio/unexport
```

Чтобы прошить программу с помощью OpenOCD, используйте следующую конфигурацию чипа:

```
источник [найти target/at91samdXX.cfg]
```

Получите программу; например, для этого чипа можно собрать klipper. Прошивка с помощью команд OpenOCD, таких как:

```
at91samd chip-erase
at91samd bootloader 0
program out/klipper.elf verify
```

## Микроконтроллеры SAMD21 (Arduino Zero)

Загрузчик SAMD21 прошивается через интерфейс ARM Serial Wire Debug (SWD). Обычно для этого используется специальный аппаратный SWD-ключ. В качестве альтернативы можно использовать [Raspberry Pi with OpenOCD](#running-openocd-on-the-raspberry-pi).

Чтобы прошить загрузчик с помощью OpenOCD, используйте следующую конфигурацию микросхемы:

```
источник [найти target/at91samdXX.cfg]
```

Получите загрузчик - например:

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

Flash с помощью команд OpenOCD, похожих на:

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

Наиболее распространенным загрузчиком для SAMD21 является тот, который используется в "Arduino Zero". В нем используется загрузчик размером 8 КБ (приложение должно быть скомпилировано с начальным адресом 8 КБ). Войти в этот загрузчик можно двойным нажатием на кнопку сброса. Для прошивки приложения используйте что-то вроде:

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

В отличие от него, в "Arduino M0" используется загрузчик объемом 16 КБ (приложение должно быть скомпилировано с начальным адресом 16 КБ). Чтобы прошить приложение в этот загрузчик, сбросьте микроконтроллер и выполните команду flash в течение первых нескольких секунд после загрузки - что-то вроде:

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## Микроконтроллеры SAMD51 (Adafruit Metro-M4 и аналогичные)

Как и SAMD21, загрузчик SAMD51 прошивается через интерфейс ARM Serial Wire Debug (SWD). Чтобы прошить загрузчик с помощью [OpenOCD на Raspberry Pi](#running-openocd-on-the-raspberry-pi), используйте следующую конфигурацию чипа:

```
источник [найти target/atsame5x.cfg]
```

Получите загрузчик - несколько загрузчиков доступны по адресу <https://github.com/adafruit/uf2-samdx1/releases/latest>. Например:

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

Flash с помощью команд OpenOCD, похожих на:

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

В SAMD51 используется 16-килобайтный загрузчик (приложение должно быть скомпилировано с начальным адресом 16 килобайт). Для прошивки приложения используйте что-то вроде:

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## Микроконтроллеры STM32F103 (устройства Blue Pill)

Устройства STM32F103 оснащены ПЗУ, которое может прошивать загрузчик или приложение через последовательный порт 3,3 В. Обычно выводы PA10 (MCU Rx) и PA9 (MCU Tx) подключаются к адаптеру UART 3,3 В. Для доступа к ПЗУ необходимо подключить вывод "boot 0" к высокому уровню, а вывод "boot 1" - к низкому, а затем сбросить устройство. Пакет "stm32flash" можно использовать для прошивки устройства, используя что-то вроде:

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

Обратите внимание, что если вы используете Raspberry Pi для последовательного 3,3 В, протокол stm32flash использует режим последовательной четности, который "мини UART" Raspberry Pi не поддерживает. Смотрите <https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts> для получения подробной информации о включении полного UART на GPIO пинах Raspberry Pi.

После прошивки установите "boot 0" и "boot 1" в низкое положение, чтобы в дальнейшем загрузка осуществлялась с флэш-памяти.

### STM32F103 с загрузчиком stm32duino

В проекте "stm32duino" есть загрузчик с поддержкой USB - см: <https://github.com/rogerclarkmelbourne/STM32duino-bootloader>

Этот загрузчик можно прошить через последовательный порт 3,3 В, используя что-то вроде:

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

Этот загрузчик использует 8 килобайт флэш-памяти (приложение должно быть скомпилировано с начальным адресом 8 килобайт). Прошиваем приложение, используя что-то вроде:

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

Обычно загрузчик работает в течение короткого периода времени после загрузки. Может потребоваться задать время выполнения вышеуказанной команды, чтобы она выполнялась в то время, когда загрузчик все еще активен (во время работы загрузчика на плате будет мигать светодиод). В качестве альтернативы установите вывод "boot 0" в низкое, а вывод "boot 1" - в высокое положение, чтобы оставаться в загрузчике после сброса.

### STM32F103 с загрузчиком HID

[HID bootloader](https://github.com/Serasidis/STM32_HID_Bootloader) - это компактный загрузчик без драйверов, способный прошиваться по USB. Также доступен [форк со сборками, специфичными для SKR Mini E3 1.2](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

Для типовых плат STM32F103, таких как синяя таблетка, можно прошить загрузчик через последовательный порт 3,3 В с помощью stm32flash, как указано в разделе stm32duino выше, заменив имя файла на нужный двоичный файл загрузчика hid (т.е.: hid_generic_pc13.bin для синей таблетки).

Использование программы stm32flash для SKR Mini E3 невозможно, так как вывод boot0 привязан непосредственно к земле и не разведен через контакты заголовка. Для прошивки загрузчика рекомендуется использовать STLink V2 с программой STM32Cubeprogrammer. Если у вас нет доступа к STLink, можно также использовать [Raspberry Pi и OpenOCD](#running-openocd-on-the-raspberry-pi) со следующей конфигурацией чипа:

```
источник [найти target/stm32f1x.cfg]
```

При желании вы можете создать резервную копию текущей прошивки с помощью следующей команды. Обратите внимание, что выполнение этой команды может занять некоторое время:

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

Наконец, вы можете сделать вспышку с помощью команд, подобных:

```
stm32f1x mass_erase 0
программа hid_btt_skr_mini_e3.bin проверка 0x08000000
```

ПРИМЕЧАНИЯ:

- В приведенном выше примере микросхема стирается, а затем программируется загрузчик. Независимо от выбранного метода прошивки рекомендуется стирать микросхему перед прошивкой.
- Перед прошивкой SKR Mini E3 этим загрузчиком вы должны знать, что больше не сможете обновлять прошивку через sdcard.
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
После этого можно отпустить кнопку сброса.

Этот загрузчик требует 2 КБ флэш-памяти (приложение должно быть скомпилировано с начальным адресом 2 КБ).

Программа hid-flash используется для загрузки двоичного файла в загрузчик. Вы можете установить это программное обеспечение с помощью следующих команд:

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

Если загрузчик запущен, вы можете прошить его с помощью чего-то вроде:

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

В качестве альтернативы вы можете использовать `make flash`, чтобы прошить klipper напрямую:

```
make flash FLASH_DEVICE=1209:BEBA
```

ИЛИ если клиппер был ранее прошит:

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

Возможно, потребуется вручную войти в загрузчик, это можно сделать, установив низкий уровень "boot 0" и высокий "boot 1". В SKR Mini E3 функция "Boot 1" недоступна, поэтому ее можно выполнить, установив низкий уровень на выводе PA2, если вы прошили файл "hid_btt_skr_mini_e3.bin". В документе "PIN" SKR Mini E3 этот вывод обозначен как "TX0" на заголовке TFT. Рядом с PA2 есть контакт заземления, который можно использовать для подтягивания PA2 к низкому уровню.

### STM32F103/STM32F072 с загрузчиком MSC

[MSC bootloader](https://github.com/Telekatz/MSC-stm32f103-bootloader) - это бездрайверный загрузчик, способный прошиваться по USB.

Можно прошить загрузчик через последовательный порт 3,3 В с помощью stm32flash, как указано в разделе stm32duino выше, заменив имя файла на нужный двоичный файл загрузчика MSC (т.е. MSCboot-Bluepill.bin для синей таблетки).

Для плат STM32F072 также можно прошить загрузчик через USB (через DFU), используя что-то вроде:

```
 dfu-util -d 0483:df11 -a 0 -R -D  MSCboot-STM32F072.bin -s0x08000000:leave
```

Этот загрузчик использует 8 или 16 килобайт флэш-памяти, см. описание загрузчика (приложение должно быть скомпилировано с соответствующим начальным адресом).

Загрузчик можно активировать, дважды нажав на кнопку сброса платы. Как только загрузчик активирован, плата становится USB-накопителем, на который можно скопировать файл klipper.bin.

### STM32F103/STM32F0x2 с загрузчиком CanBoot

Загрузчик [CanBoot](https://github.com/Arksine/CanBoot) предоставляет возможность загрузки прошивки Klipper по шине CANBUS. Сам загрузчик получен из исходного кода Klipper. В настоящее время CanBoot поддерживает модели STM32F103, STM32F042 и STM32F072.

Для прошивки CanBoot рекомендуется использовать программатор ST-Link, однако для устройств STM32F103 можно использовать `stm32flash`, а для устройств STM32F042/STM32F072 - `dfu-util`. Инструкции по этим методам прошивки см. в предыдущих разделах этого документа, заменяя `canboot.bin` в имени файла, где это необходимо. В репозитории CanBoot, ссылка на который приведена выше, содержатся инструкции по сборке загрузчика.

При первой прошивке CanBoot должен обнаружить отсутствие приложения и войти в загрузчик. Если этого не происходит, можно войти в загрузчик, нажав кнопку сброса два раза подряд.

The `flashtool.py` utility supplied in the `lib/katapult` folder may be used to upload Klipper firmware. The device UUID is necessary to flash. If you do not have a UUID it is possible to query nodes currently running the bootloader:

```
python3 flash_can.py -q
```

Это вернет UUID для всех подключенных узлов, которым в данный момент не присвоен UUID. Это должно включать все узлы, находящиеся в данный момент в загрузчике.

Получив UUID, вы можете загрузить прошивку с помощью следующей команды:

```
python3 flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u aabbccddeeff
```

Где `aabbccddeeff` заменяется вашим UUID. Обратите внимание, что опции `-i` и `-f` могут быть опущены, по умолчанию они принимают значения `can0` и `~/klipper/out/klipper.bin` соответственно.

При сборке Klipper для использования с CanBoot выберите опцию 8 KiB Bootloader.

## Микроконтроллеры STM32F4 (SKR Pro 1.1)

Микроконтроллеры STM32F4 оснащены встроенным системным загрузчиком, способным прошиваться по USB (через DFU), через последовательный порт 3,3 В и различными другими способами (более подробная информация приведена в документе STM AN2606). Некоторые платы STM32F4, такие как SKR Pro 1.1, не могут войти в загрузчик DFU. Для плат на базе STM32F405/407 доступен загрузчик HID, если пользователь предпочитает прошивку через USB, а не через sdcard. Обратите внимание, что вам может потребоваться настройка и сборка версии, специфичной для вашей платы, а [сборка для SKR Pro 1.1 доступна здесь](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

Если ваша плата не поддерживает DFU, наиболее доступным методом прошивки, скорее всего, будет последовательный 3,3 В, что соответствует процедуре [прошивка STM32F103 с помощью stm32flash](#stm32f103-micro-controllers-blue-pill-devices). Например:

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

Этот загрузчик требует 16 Кб флэш-памяти на STM32F4 (приложение должно быть скомпилировано с начальным адресом 16 Кб).

Как и STM32F1, STM32F4 использует инструмент hid-flash для загрузки двоичных файлов в MCU. Подробную информацию о том, как создать и использовать hid-flash, см. в инструкциях выше.

Может потребоваться ручной вход в загрузчик, для этого установите низкий уровень "boot 0", высокий - "boot 1" и подключите устройство. После завершения программирования отключите устройство и установите "boot 1" обратно в низкое положение, чтобы приложение загрузилось.

## Микроконтроллеры LPC176x (сглаживающие платы)

В этом документе не описывается метод прошивки загрузчика - см: <http://smoothieware.org/flashing-the-bootloader> для получения дополнительной информации по этой теме.

Обычно Smoothieboards поставляются с загрузчиком с сайта: <https://github.com/triffid/LPC17xx-DFU-Bootloader>. При использовании этого загрузчика приложение должно быть скомпилировано с начальным адресом 16KiB. Самый простой способ прошить приложение с помощью этого загрузчика - скопировать файл приложения (например, `out/klipper.bin`) в файл с именем `firmware.bin` на SD-карту, а затем перезагрузить микроконтроллер с помощью этой SD-карты.

## Запуск OpenOCD на Raspberry PI

OpenOCD - это программный пакет, позволяющий выполнять низкоуровневую прошивку и отладку микросхем. Он может использовать контакты GPIO на Raspberry Pi для связи с различными ARM-чипами.

В этом разделе описано, как установить и запустить OpenOCD. Он заимствован из инструкций по адресу: <https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>

Начните с загрузки и компиляции программного обеспечения (каждый шаг может занять несколько минут, а шаг "make" может занять более 30 минут):

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

### Конфигурирование OpenOCD

Создайте файл конфигурации OpenOCD:

```
nano ~/openocd/openocd.cfg
```

Используйте конфигурацию, подобную следующей:

```
# Использует выводы RPi: GPIO25 для SWDCLK, GPIO24 для SWDIO, GPIO18 для nRST
source [find interface/raspberrypi2-native.cfg]
bcm2835gpio_swd_nums 25 24
bcm2835gpio_srst_num 18
выбор транспорта swd

# Используйте провод аппаратного сброса для сброса микросхемы
reset_config srst_only
adapter_nsrst_delay 100
adapter_nsrst_assert_width 100

# Укажите тип микросхемы
source [find target/atsame5x.cfg]

# Установите скорость адаптера
adapter_khz 40

# Подключиться к чипу
init
targets
сброс остановка
```

### Подключите Raspberry Pi к целевому чипу

Перед подключением выключите питание Raspberry Pi и целевого чипа! Убедитесь, что целевой чип использует напряжение 3,3 В перед подключением к Raspberry Pi!

Подключите GND, SWDCLK, SWDIO и RST на целевом чипе к GND, GPIO25, GPIO24 и GPIO18 на Raspberry Pi соответственно.

Затем включите Raspberry Pi и подайте питание на целевой чип.

### Запустить OpenOCD

Запустите OpenOCD:

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

В результате выполнения этих действий OpenOCD должен выдать несколько текстовых сообщений, а затем подождать (он не должен сразу же вернуться к приглашению оболочки Unix). Если OpenOCD завершает работу самостоятельно или продолжает выдавать текстовые сообщения, перепроверьте подключение.

Когда OpenOCD запущен и работает стабильно, можно отправлять ему команды по telnet. Откройте еще один сеанс ssh и выполните следующие действия:

```
telnet 127.0.0.1 4444
```

(Можно выйти из telnet, нажав ctrl+], а затем выполнив команду "quit")

### OpenOCD и gdb

Для отладки Klipper можно использовать OpenOCD вместе с gdb. Следующие команды предполагают, что gdb запущен на машине класса desktop.

Добавьте следующее в файл конфигурации OpenOCD:

```
bindto 0.0.0.0
gdb_port 44444
```

Перезапустите OpenOCD на Raspberry Pi, а затем выполните следующую команду Unix на настольной машине:

```
cd /path/to/klipper/
gdb out/klipper.elf
```

Запустите gdb:

```
целевой удаленный octopi:44444
```

(Замените "octopi" на имя хоста Raspberry Pi.) После запуска gdb можно устанавливать точки останова и проверять регистры.
