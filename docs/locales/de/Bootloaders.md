# Bootloader

Dieses Dokument enthält Informationen über gängige Bootloader für Mikrocontroller, die von Klipper unterstützt werden.

Der Bootloader ist eine Software eines Drittanbieters, die auf dem Mikrocontroller läuft, wenn dieser zum ersten Mal eingeschaltet wird. Er wird in der Regel verwendet, um eine neue Anwendung (z. B. Klipper) auf den Mikrocontroller zu flashen, ohne dass spezielle Hardware erforderlich ist. Leider gibt es weder einen industrieweiten Standard für das Flashen eines Mikrocontrollers, noch einen Standard-Bootloader, der für alle Mikrocontroller funktioniert. Schlimmer noch, jeder Bootloader erfordert in der Regel eine andere Anzahl von Schritten, um eine Anwendung zu flashen.

Wenn man einen Bootloader in einen Mikrocontroller flashen kann, kann man diesen Mechanismus in der Regel auch zum Flashen einer Anwendung verwenden, aber dabei ist Vorsicht geboten, da man den Bootloader versehentlich entfernen könnte. Im Gegensatz dazu erlaubt ein Bootloader dem Benutzer im Allgemeinen nur das Flashen einer Anwendung. Es wird daher empfohlen, einen Bootloader zum Flashen einer Anwendung zu verwenden, wenn dies möglich ist.

Dieses Dokument versucht, gängige Bootloader zu beschreiben, die zum Flashen eines Bootloaders erforderlichen Schritte sowie die Schritte, die zum Flashen einer Anwendung nötig sind. Dieses Dokument ist keine verbindliche Referenz; es ist als Sammlung nützlicher Informationen gedacht, die die Klipper-Entwickler zusammengetragen haben.

## AVR Mikrocontroller

Im Allgemeinen ist das Arduino-Projekt eine gute Referenz für Bootloader und Flash-Vorgänge auf den 8-Bit-Atmel-Atmega-Mikrocontrollern. Insbesondere die Datei "boards.txt" ist eine nützliche Referenz: <https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt>.

Um den Bootloader selbst zu flashen, benötigen die AVR-Chips ein externes Hardware-Flash-Werkzeug (das über SPI mit dem Chip kommuniziert). Ein solches Werkzeug kann man kaufen (suchen Sie zum Beispiel im Web nach "avr isp", "arduino isp" oder "usb tiny isp"). Es ist auch möglich, einen anderen Arduino oder einen Raspberry Pi zum Flashen eines AVR-Bootloaders zu verwenden (suchen Sie zum Beispiel im Web nach "program an avr using raspberry pi"). Die folgenden Beispiele gehen davon aus, dass ein Gerät vom Typ "AVR ISP Mk2" verwendet wird.

Das Programm "avrdude" ist das am häufigsten verwendete Werkzeug zum Flashen von Atmega-Chips (sowohl für das Flashen des Bootloaders als auch für das Flashen der Anwendung).

### Atmega2560

Dieser Chip findet sich typischerweise im "Arduino Mega" und ist auf 3D-Drucker-Platinen sehr verbreitet.

Um den Bootloader selbst zu flashen, verwenden Sie etwas wie:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Um eine Anwendung zu flashen, verwenden Sie etwas wie:

```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

Dieser Chip findet sich typischerweise in früheren Versionen des "Arduino Mega".

Um den Bootloader selbst zu flashen, verwenden Sie etwas wie:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Um eine Anwendung zu flashen, verwenden Sie etwas wie:

```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

Dieser Chip findet sich häufig auf 3D-Drucker-Platinen im "Melzi"-Stil.

Um den Bootloader selbst zu flashen, verwenden Sie etwas wie:

```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Um eine Anwendung zu flashen, verwenden Sie etwas wie:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

Beachten Sie, dass eine Reihe von Platinen im "Melzi"-Stil mit einem Bootloader vorinstalliert ist, der eine Baudrate von 57600 verwendet. Verwenden Sie in diesem Fall zum Flashen einer Anwendung stattdessen etwas wie:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

Dieses Dokument beschreibt weder die Methode zum Flashen eines Bootloaders auf den At90usb1286 noch das allgemeine Flashen von Anwendungen auf dieses Gerät.

Das Teensy++-Gerät von pjrc.com wird mit einem proprietären Bootloader ausgeliefert. Es benötigt ein spezielles Flash-Werkzeug von <https://github.com/PaulStoffregen/teensy_loader_cli>. Damit lässt sich eine Anwendung etwa wie folgt flashen:

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

Der atmega168 verfügt über begrenzten Flash-Speicher. Wenn Sie einen Bootloader verwenden, wird der Optiboot-Bootloader empfohlen. Um diesen Bootloader zu flashen, verwenden Sie etwas wie:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Um eine Anwendung über den Optiboot-Bootloader zu flashen, verwenden Sie etwas wie:

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## SAM3 Mikrocontroller (Arduino Due)

Es ist unüblich, beim SAM3-MCU einen Bootloader zu verwenden. Der Chip selbst besitzt ein ROM, das die Programmierung des Flash-Speichers über einen 3,3-V-Seriellen-Port oder über USB ermöglicht.

Um das ROM zu aktivieren, wird der "erase"-Pin während eines Resets auf High gehalten, wodurch der Flash-Inhalt gelöscht wird und das ROM ausgeführt wird. Auf einem Arduino Due lässt sich diese Sequenz durch Einstellen einer Baudrate von 1200 am "programming usb port" (dem USB-Anschluss, der dem Netzteil am nächsten liegt) auslösen.

Der Code unter <https://github.com/shumatech/BOSSA> kann verwendet werden, um den SAM3 zu programmieren. Es wird empfohlen, Version 1.9 oder höher zu verwenden.

Um eine Anwendung zu flashen, verwenden Sie etwas wie:

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## SAM4 Mikrocontroller (Duet Wifi)

Es ist unüblich, beim SAM4-MCU einen Bootloader zu verwenden. Der Chip selbst besitzt ein ROM, das die Programmierung des Flash-Speichers über einen 3,3-V-Seriellen-Port oder über USB ermöglicht.

Um das ROM zu aktivieren, wird der "erase"-Pin während eines Resets auf High gehalten, wodurch der Flash-Inhalt gelöscht wird und das ROM ausgeführt wird.

Der Code unter <https://github.com/shumatech/BOSSA> kann verwendet werden, um den SAM4 zu programmieren. Es ist notwendig, Version `1.8.0` oder höher zu verwenden.

Um eine Anwendung zu flashen, verwenden Sie etwas wie:

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## SAMDC21 Mikrocontroller (Duet3D Toolboard 1LC)

Der SAMC21 wird über die ARM Serial Wire Debug (SWD)-Schnittstelle geflasht. Dies geschieht üblicherweise mit einem dedizierten SWD-Hardware-Dongle. Alternativ kann ein [Raspberry Pi mit OpenOCD](#running-openocd-on-the-raspberry-pi) verwendet werden.

Bei Verwendung von OpenOCD mit dem SAMC21 müssen zusätzliche Schritte unternommen werden, um den Chip zunächst in den Cold-Plugging-Modus zu versetzen, falls die Platine die SWD-Pins auch für andere Zwecke nutzt. Bei Verwendung von OpenOCD auf einem Raspberry Pi lässt sich dies erreichen, indem die folgenden Befehle vor dem Aufruf von OpenOCD ausgeführt werden.

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

Um ein Programm mit OpenOCD zu flashen, verwenden Sie folgende Chip-Konfiguration:

```
source [find target/at91samdXX.cfg]
```

Besorgen Sie sich ein Programm; beispielsweise kann Klipper für diesen Chip erstellt werden. Flashen Sie mit OpenOCD-Befehlen ähnlich wie folgt:

```
at91samd chip-erase
at91samd bootloader 0
program out/klipper.elf verify
```

## SAMD21 Mikrocontroller (Arduino Zero)

Der SAMD21-Bootloader wird über die ARM-Serial-Wire-Debug-Schnittstelle (SWD) geflasht. Üblicherweise geschieht dies mit einem dedizierten SWD-Hardware-Dongle. Alternativ können Sie einen [Raspberry Pi mit OpenOCD](#running-openocd-on-the-raspberry-pi) verwenden.

Um einen Bootloader mit OpenOCD zu flashen, verwenden Sie die folgende Chip-Konfiguration:

```
source [find target/at91samdXX.cfg]
```

Beschaffen Sie sich einen Bootloader – zum Beispiel:

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

Flashen Sie mit OpenOCD-Befehlen ähnlich wie:

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

Der gebräuchlichste Bootloader auf dem SAMD21 ist der des "Arduino Zero". Er verwendet einen 8-KiB-Bootloader (die Anwendung muss mit einer Startadresse von 8 KiB kompiliert werden). Sie können diesen Bootloader durch doppeltes Drücken der Reset-Taste aufrufen. Um eine Anwendung zu flashen, verwenden Sie etwas wie:

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

Der "Arduino M0" verwendet dagegen einen 16-KiB-Bootloader (die Anwendung muss mit einer Startadresse von 16 KiB kompiliert werden). Um eine Anwendung mit diesem Bootloader zu flashen, setzen Sie den Mikrocontroller zurück und führen Sie den Flash-Befehl innerhalb der ersten Sekunden nach dem Start aus – etwa so:

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## SAMD51 Mikrocontroller (Adafruit Metro-M4 und ähnliche)

Wie beim SAMD21 wird der SAMD51-Bootloader über die ARM-Serial-Wire-Debug-Schnittstelle (SWD) geflasht. Um einen Bootloader mit [OpenOCD auf einem Raspberry Pi](#running-openocd-on-the-raspberry-pi) zu flashen, verwenden Sie die folgende Chip-Konfiguration:

```
source [find target/atsame5x.cfg]
```

Besorgen Sie sich einen Bootloader - mehrere Bootloader sind unter <https://github.com/adafruit/uf2-samdx1/releases/latest> verfügbar. Zum Beispiel:

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

Flashen Sie mit OpenOCD-Befehlen ähnlich wie:

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

Der SAMD51 verwendet einen 16-KiB-Bootloader (die Anwendung muss mit einer Startadresse von 16 KiB kompiliert werden). Um eine Anwendung zu flashen, verwenden Sie etwas wie:

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## STM32F103 Mikrocontroller (Blue Pill Geräte)

Die STM32F103-Geräte verfügen über einen ROM, der einen Bootloader oder eine Anwendung über 3,3V-Serielle flashen kann. Üblicherweise werden dazu die Pins PA10 (MCU Rx) und PA9 (MCU Tx) mit einem 3,3V-UART-Adapter verbunden. Um auf den ROM zuzugreifen, sollte der Pin "boot 0" auf High und der Pin "boot 1" auf Low gesetzt und das Gerät anschließend zurückgesetzt werden. Mit dem Paket "stm32flash" kann das Gerät anschließend etwa wie folgt geflasht werden:

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

Beachten Sie: Wird ein Raspberry Pi für die 3,3V-Serielle verwendet, nutzt das stm32flash-Protokoll einen seriellen Paritätsmodus, den der "Mini UART" des Raspberry Pi nicht unterstützt. Details zur Aktivierung des vollständigen UART an den GPIO-Pins des Raspberry Pi finden Sie unter <https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts>.

Setzen Sie nach dem Flashen sowohl "boot 0" als auch "boot 1" wieder auf Low, damit künftige Resets vom Flash-Speicher starten.

### STM32F103 mit stm32duino Bootloader

Das Projekt "stm32duino" verfügt über einen USB-fähigen Bootloader - siehe: <https://github.com/rogerclarkmelbourne/STM32duino-bootloader>

Dieser Bootloader kann über eine 3,3-V-Serielle-Verbindung mit etwas wie folgendem geflasht werden:

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

Dieser Bootloader belegt 8 KiB Flash-Speicher (die Anwendung muss mit einer Startadresse von 8 KiB kompiliert werden). Flashen Sie eine Anwendung mit etwas wie:

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

Der Bootloader läuft typischerweise nur für kurze Zeit nach dem Start. Möglicherweise müssen Sie den obigen Befehl zeitlich so abstimmen, dass er ausgeführt wird, während der Bootloader noch aktiv ist (der Bootloader lässt während seiner Ausführung eine LED auf der Platine blinken). Alternativ setzen Sie den Pin "boot 0" auf Low und den Pin "boot 1" auf High, um nach einem Reset im Bootloader zu bleiben.

### STM32F103 mit HID Bootloader

Der [HID-Bootloader](https://github.com/Serasidis/STM32_HID_Bootloader) ist ein kompakter, treiberloser Bootloader, der das Flashen über USB ermöglicht. Verfügbar ist außerdem ein [Fork mit speziellen Builds für das SKR Mini E3 1.2](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

Bei generischen STM32F103-Platinen wie der Blue Pill ist es möglich, den Bootloader über 3,3V-Serielle mit stm32flash zu flashen, wie im obigen Abschnitt zu stm32duino beschrieben, wobei der Dateiname durch den gewünschten HID-Bootloader-Binärdatei-Namen ersetzt wird (z. B. hid_generic_pc13.bin für die Blue Pill).

Beim SKR Mini E3 kann stm32flash nicht verwendet werden, da der boot0-Pin direkt mit Masse verbunden und nicht über Stiftleisten herausgeführt ist. Es wird empfohlen, den Bootloader mit einem STLink V2 und dem STM32Cubeprogrammer zu flashen. Wenn Sie keinen STLink zur Verfügung haben, können Sie auch einen [Raspberry Pi und OpenOCD](#running-openocd-on-the-raspberry-pi) mit der folgenden Chip-Konfiguration verwenden:

```
source [find target/stm32f1x.cfg]
```

Wenn Sie möchten, können Sie mit dem folgenden Befehl eine Sicherung des aktuellen Flash-Inhalts erstellen. Beachten Sie, dass dies einige Zeit dauern kann:

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

Schließlich können Sie mit Befehlen ähnlich den folgenden flashen:

```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```

HINWEISE:

- Das obige Beispiel löscht den Chip und programmiert anschließend den Bootloader. Unabhängig von der gewählten Flash-Methode wird empfohlen, den Chip vor dem Flashen zu löschen.
- Bevor Sie den SKR Mini E3 mit diesem Bootloader flashen, sollten Sie sich bewusst sein, dass Sie die Firmware anschließend nicht mehr über die SD-Karte aktualisieren können.
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
Danach können Sie die Reset-Taste loslassen.

Dieser Bootloader benötigt 2 KiB Flash-Speicher (die Anwendung muss mit einer Startadresse von 2 KiB kompiliert werden).

Das Programm hid-flash wird verwendet, um eine Binärdatei in den Bootloader hochzuladen. Sie können diese Software mit den folgenden Befehlen installieren:

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

Wenn der Bootloader läuft, können Sie mit etwas wie folgendem flashen:

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

Alternativ können Sie `make flash` verwenden, um Klipper direkt zu flashen:

```
make flash FLASH_DEVICE=1209:BEBA
```

oder wenn Klipper zuvor geflasht wurde:

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

Möglicherweise muss der Bootloader manuell aufgerufen werden, indem "boot 0" auf Low und "boot 1" auf High gesetzt wird. Beim SKR Mini E3 ist "Boot 1" nicht verfügbar; stattdessen kann dies erreicht werden, indem Pin PA2 auf Low gesetzt wird, sofern "hid_btt_skr_mini_e3.bin" geflasht wurde. Dieser Pin ist auf dem TFT-Header im "PIN"-Dokument des SKR Mini E3 mit "TX0" beschriftet. Neben PA2 befindet sich ein Masse-Pin, mit dem sich PA2 auf Low ziehen lässt.

### STM32F103/STM32F072 mit MSC Bootloader

Der [MSC-Bootloader](https://github.com/Telekatz/MSC-stm32f103-bootloader) ist ein treiberloser Bootloader, der das Flashen über USB ermöglicht.

Es ist möglich, den Bootloader über 3,3V-Serielle mit stm32flash zu flashen, wie im obigen Abschnitt zu stm32duino beschrieben, wobei der Dateiname durch den gewünschten MSC-Bootloader-Binärdatei-Namen ersetzt wird (z. B. MSCboot-Bluepill.bin für die Blue Pill).

Bei STM32F072-Platinen ist es außerdem möglich, den Bootloader über USB (via DFU) zu flashen, etwa mit:

```
 dfu-util -d 0483:df11 -a 0 -R -D  MSCboot-STM32F072.bin -s0x08000000:leave
```

Dieser Bootloader belegt 8 KiB oder 16 KiB Flash-Speicher, siehe die Beschreibung des Bootloaders (die Anwendung muss mit der entsprechenden Startadresse kompiliert werden).

Der Bootloader lässt sich aktivieren, indem die Reset-Taste der Platine zweimal gedrückt wird. Sobald der Bootloader aktiviert ist, erscheint die Platine als USB-Flash-Laufwerk, auf das die Datei klipper.bin kopiert werden kann.

### STM32F103/STM32F0x2 mit CanBoot Bootloader

Der [CanBoot](https://github.com/Arksine/CanBoot)-Bootloader bietet eine Möglichkeit, Klipper-Firmware über den CANBUS hochzuladen. Der Bootloader selbst leitet sich vom Quellcode von Klipper ab. CanBoot unterstützt derzeit die Modelle STM32F103, STM32F042 und STM32F072.

Es wird empfohlen, zum Flashen von CanBoot einen ST-Link-Programmer zu verwenden. Es sollte jedoch auch möglich sein, `stm32flash` auf STM32F103-Geräten und `dfu-util` auf STM32F042/STM32F072-Geräten zu verwenden. Anweisungen zu diesen Flash-Methoden finden Sie in den vorherigen Abschnitten dieses Dokuments; ersetzen Sie dabei den Dateinamen gegebenenfalls durch `canboot.bin`. Das oben verlinkte CanBoot-Repository enthält Anweisungen zum Erstellen des Bootloaders.

Beim ersten Flashen sollte CanBoot erkennen, dass keine Anwendung vorhanden ist, und den Bootloader starten. Geschieht dies nicht, kann der Bootloader durch zweimaliges Drücken der Reset-Taste hintereinander aufgerufen werden.

Das im Ordner `lib/katapult` bereitgestellte Werkzeug `flashtool.py` kann verwendet werden, um Klipper-Firmware hochzuladen. Zum Flashen wird die Geräte-UUID benötigt. Falls Sie keine UUID haben, können Sie Knoten abfragen, auf denen derzeit der Bootloader läuft:

```
python3 flash_can.py -q
```

Dies gibt die UUIDs aller verbundenen Knoten zurück, denen aktuell keine UUID zugewiesen ist. Dies sollte alle Knoten einschließen, die sich derzeit im Bootloader befinden.

Sobald Sie eine UUID haben, können Sie Firmware mit folgendem Befehl hochladen:

```
python3 flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u aabbccddeeff
```

Dabei wird `aabbccddeeff` durch Ihre UUID ersetzt. Beachten Sie, dass die Optionen `-i` und `-f` weggelassen werden können; sie verwenden standardmäßig `can0` bzw. `~/klipper/out/klipper.bin`.

Wählen Sie beim Erstellen von Klipper zur Verwendung mit CanBoot die Option 8-KiB-Bootloader.

## STM32F4 Mikrocontroller (SKR Pro 1.1)

STM32F4-Mikrocontroller verfügen über einen eingebauten System-Bootloader, der das Flashen über USB (via DFU), 3,3V-Serielle und verschiedene weitere Methoden ermöglicht (siehe STM-Dokument AN2606 für weitere Informationen). Einige STM32F4-Platinen, wie das SKR Pro 1.1, können den DFU-Bootloader nicht aufrufen. Der HID-Bootloader ist für auf STM32F405/407 basierende Platinen verfügbar, falls der Anwender das Flashen über USB anstelle der SD-Karte bevorzugt. Beachten Sie, dass möglicherweise eine für Ihre Platine spezifische Version konfiguriert und erstellt werden muss; [ein Build für das SKR Pro 1.1 ist hier verfügbar](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

Sofern Ihre Platine nicht DFU-fähig ist, ist die am leichtesten zugängliche Flash-Methode wahrscheinlich über 3,3V-Serielle, wobei dasselbe Verfahren wie beim [Flashen des STM32F103 mit stm32flash](#stm32f103-micro-controllers-blue-pill-devices) angewendet wird. Zum Beispiel:

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

Dieser Bootloader benötigt 16 KiB Flash-Speicher auf dem STM32F4 (die Anwendung muss mit einer Startadresse von 16 KiB kompiliert werden).

Wie beim STM32F1 verwendet der STM32F4 das Werkzeug hid-flash, um Binärdateien auf den MCU zu übertragen. Details zum Erstellen und Verwenden von hid-flash finden Sie in den obigen Anweisungen.

Möglicherweise muss der Bootloader manuell aufgerufen werden. Dies gelingt, indem "boot 0" auf Low und "boot 1" auf High gesetzt und das Gerät anschließend eingesteckt wird. Nach Abschluss der Programmierung trennen Sie das Gerät und setzen "boot 1" wieder auf Low, damit die Anwendung geladen wird.

## LPC176x Mikrocontroller (Smoothieboards)

Dieses Dokument beschreibt nicht, wie ein Bootloader selbst geflasht wird - weitere Informationen zu diesem Thema finden Sie unter: <http://smoothieware.org/flashing-the-bootloader>.

Es ist üblich, dass Smoothieboards mit einem Bootloader von <https://github.com/triffid/LPC17xx-DFU-Bootloader> ausgeliefert werden. Bei Verwendung dieses Bootloaders muss die Anwendung mit einer Startadresse von 16 KiB kompiliert werden. Am einfachsten lässt sich eine Anwendung mit diesem Bootloader flashen, indem die Anwendungsdatei (z. B. `out/klipper.bin`) unter dem Namen `firmware.bin` auf eine SD-Karte kopiert und der Mikrocontroller anschließend mit dieser SD-Karte neu gestartet wird.

## Ausführen von OpenOCD auf dem Raspberry PI

OpenOCD ist ein Softwarepaket, das Low-Level-Chip-Flashing und -Debugging ermöglicht. Es kann die GPIO-Pins eines Raspberry Pi nutzen, um mit einer Vielzahl von ARM-Chips zu kommunizieren.

Dieser Abschnitt beschreibt, wie OpenOCD installiert und gestartet werden kann. Er basiert auf den Anweisungen unter: <https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>

Beginnen Sie damit, die Software herunterzuladen und zu kompilieren (jeder Schritt kann einige Minuten dauern, der "make"-Schritt kann über 30 Minuten dauern):

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

### OpenOCD konfigurieren

Erstellen Sie eine OpenOCD config Datei:

```
nano ~/openocd/openocd.cfg
```

Verwenden Sie eine Konfiguration ähnlich der folgenden:

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

### Raspberry Pi mit dem Zielchip verkabeln

Schalten Sie vor dem Verkabeln sowohl den Raspberry Pi als auch den Zielchip aus! Stellen Sie vor dem Anschließen an einen Raspberry Pi sicher, dass der Zielchip mit 3,3V arbeitet!

Verbinden Sie GND, SWDCLK, SWDIO und RST am Zielchip mit GND, GPIO25, GPIO24 bzw. GPIO18 am Raspberry Pi.

Schalten Sie anschließend den Raspberry Pi ein und versorgen Sie den Zielchip mit Strom.

### OpenOCD starten

OpenOCD starten:

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

Das oben Genannte sollte dazu führen, dass OpenOCD einige Textmeldungen ausgibt und dann wartet (es sollte nicht sofort zur Unix-Shell-Eingabeaufforderung zurückkehren). Falls OpenOCD von selbst beendet wird oder weiterhin Textmeldungen ausgibt, überprüfen Sie die Verkabelung erneut.

Sobald OpenOCD läuft und stabil ist, können ihm Befehle per Telnet gesendet werden. Öffnen Sie eine weitere SSH-Sitzung und führen Sie Folgendes aus:

```
telnet 127.0.0.1 4444
```

(Telnet kann durch Drücken von Strg+] und anschließendes Ausführen des Befehls "quit" beendet werden.)

### OpenOCD und gdb

Es ist möglich, OpenOCD zusammen mit gdb zu verwenden, um Klipper zu debuggen. Die folgenden Befehle setzen voraus, dass gdb auf einem Desktop-Rechner läuft.

Fügen Sie der OpenOCD Konfigurationsdatei Folgendes hinzu:

```
bindto 0.0.0.0
gdb_port 44444
```

Starten Sie OpenOCD auf dem Raspberry Pi neu und führen Sie anschließend den folgenden Unix-Befehl auf dem Desktop-Rechner aus:

```
cd /path/to/klipper/
gdb out/klipper.elf
```

Innerhalb von gdb ausführen:

```
target remote octopi:44444
```

(Ersetzen Sie "octopi" durch den Hostnamen des Raspberry Pi.) Sobald gdb läuft, können Breakpoints gesetzt und Register untersucht werden.
