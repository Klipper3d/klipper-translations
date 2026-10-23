# Uppstartsprogram

Detta dokument innehåller information om vanliga uppstartsprogram på mikrokontroller som Klipper stöder.

Ett uppstartsprogram är programvara från tredje part som körs på mikrokontrollern när den först får ström. Den används normalt för att flasha ett nytt program, exempelvis Klipper, utan särskild maskinvara. Det finns tyvärr ingen branschstandard för flashning av mikrokontroller och inte heller något standardiserat uppstartsprogram för alla mikrokontroller. Dessutom kräver varje uppstartsprogram ofta olika steg för att flasha ett program.

Om ett uppstartsprogram kan flashas till en mikrokontroller går det vanligtvis också att använda samma mekanism för att flasha ett program, men var försiktig eftersom uppstartsprogrammet kan tas bort oavsiktligt. Ett uppstartsprogram tillåter däremot normalt bara att ett program flashas. Använd därför ett uppstartsprogram för att flasha program när det är möjligt.

Dokumentet beskriver vanliga uppstartsprogram, stegen för att flasha dem och stegen för att flasha program. Det är ingen auktoritativ referens utan en samling användbar information från Klippers utvecklare.

## AVR-mikrokontroller

Arduino-projektet är i allmänhet en bra referens för uppstartsprogram och flashningsförfaranden för 8-bitars Atmel Atmega-mikrokontroller. Särskilt filen "boards.txt": <https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt> är användbar.

För att flasha själva uppstartsprogrammet kräver AVR-kretsar ett externt maskinvaruverktyg för flashning, som kommunicerar med kretsen via SPI. Verktyget kan köpas (sök exempelvis på "avr isp", "arduino isp" eller "usb tiny isp"). Det går även att använda en annan Arduino eller Raspberry Pi för att flasha ett AVR-uppstartsprogram (sök exempelvis på "program an avr using raspberry pi"). Exemplen nedan förutsätter en enhet av typen "AVR ISP Mk2".

Programmet "avrdude" är det vanligaste verktyget för att flasha Atmega-kretsar, både uppstartsprogram och program.

### Atmega2560

Kretsen finns normalt i "Arduino Mega" och är mycket vanlig på kort för 3D-skrivare.

Använd något i stil med följande för att flasha själva uppstartsprogrammet:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Använd något i stil med följande för att flasha ett program:

```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

Kretsen finns normalt i äldre versioner av "Arduino Mega".

Använd något i stil med följande för att flasha själva uppstartsprogrammet:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Använd något i stil med följande för att flasha ett program:

```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

Kretsen finns ofta på kort för 3D-skrivare av typen "Melzi".

Använd något i stil med följande för att flasha själva uppstartsprogrammet:

```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Använd något i stil med följande för att flasha ett program:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

Observera att flera kort av typen "Melzi" levereras med ett uppstartsprogram som använder överföringshastigheten 57600. Använd i så fall något i stil med följande för att flasha ett program:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

Detta dokument beskriver inte hur ett uppstartsprogram flashas till At90usb1286 och inte heller allmän flashning av program till enheten.

Teensy++-enheten från pjrc.com levereras med ett proprietärt uppstartsprogram. Den kräver ett särskilt flashningsverktyg från <https://github.com/PaulStoffregen/teensy_loader_cli>. Ett program kan flashas med något i stil med:

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

Atmega168 har begränsat flashminne. Om ett uppstartsprogram används rekommenderas Optiboot. Använd något i stil med följande för att flasha det:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Använd något i stil med följande för att flasha ett program via Optiboot:

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## SAM3-mikrokontroller (Arduino Due)

Det är ovanligt att använda uppstartsprogram med SAM3-MCU:n. Kretsen har själv ett ROM som gör att flashminnet kan programmeras från en seriell 3,3 V-port eller USB.

För att aktivera ROM hålls stiftet "erase" högt under en återställning. Det raderar flashinnehållet och startar ROM. På en Arduino Due kan detta göras genom att ställa in överföringshastigheten 1200 på "programming usb port" (USB-porten närmast strömförsörjningen).

Koden på <https://github.com/shumatech/BOSSA> kan användas för att programmera SAM3. Version 1.9 eller senare rekommenderas.

Använd något i stil med följande för att flasha ett program:

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## SAM4-mikrokontroller (Duet Wifi)

Det är ovanligt att använda uppstartsprogram med SAM4-MCU:n. Kretsen har själv ett ROM som gör att flashminnet kan programmeras från en seriell 3,3 V-port eller USB.

För att aktivera ROM hålls stiftet "erase" högt under en återställning. Det raderar flashinnehållet och startar ROM.

Koden på <https://github.com/shumatech/BOSSA> kan användas för att programmera SAM4. Version `1.8.0` eller senare krävs.

Använd något i stil med följande för att flasha ett program:

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## SAMDC21-mikrokontroller (Duet3D Toolboard 1LC)

SAMC21 flashas via ARM Serial Wire Debug-gränssnittet (SWD). Det görs vanligen med en särskild SWD-dongel, men en [Raspberry Pi med OpenOCD](#running-openocd-on-the-raspberry-pi) kan också användas.

När OpenOCD används med SAMC21 krävs extra steg för att först sätta kretsen i läget Cold Plugging om kortet använder SWD-stiften till annat. Med OpenOCD på Raspberry Pi görs detta genom att köra följande kommandon före OpenOCD.

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

Använd följande kretskonfiguration för att flasha ett program med OpenOCD:

```
source [find target/at91samdXX.cfg]
```

Hämta ett program; Klipper kan exempelvis byggas för denna krets. Flasha med OpenOCD-kommandon i stil med:

```
at91samd chip-erase
at91samd bootloader 0
program out/klipper.elf verify
```

## SAMD21-mikrokontroller (Arduino Zero)

SAMD21-uppstartsprogrammet flashas via ARM Serial Wire Debug-gränssnittet (SWD). Det görs vanligen med en särskild SWD-dongel, men du kan även använda en [Raspberry Pi med OpenOCD](#running-openocd-on-the-raspberry-pi).

Använd följande kretskonfiguration för att flasha ett uppstartsprogram med OpenOCD:

```
source [find target/at91samdXX.cfg]
```

Hämta ett uppstartsprogram, exempelvis:

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

Flasha med OpenOCD-kommandon i stil med:

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

Det vanligaste uppstartsprogrammet för SAMD21 är det som finns på "Arduino Zero". Det använder 8 KiB (programmet måste kompileras med startadressen 8 KiB). Du öppnar uppstartsprogrammet genom att dubbelklicka på återställningsknappen. Flasha ett program med något i stil med:

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

"Arduino M0" använder däremot ett uppstartsprogram på 16 KiB (programmet måste kompileras med startadressen 16 KiB). Återställ mikrokontrollern och kör flashkommandot under de första sekunderna efter uppstart för att flasha ett program till detta uppstartsprogram, exempelvis:

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## SAMD51-mikrokontroller (Adafruit Metro-M4 och liknande)

Precis som SAMD21 flashas SAMD51-uppstartsprogrammet via ARM Serial Wire Debug-gränssnittet (SWD). Använd följande kretskonfiguration för att flasha ett uppstartsprogram med [OpenOCD på en Raspberry Pi](#running-openocd-on-the-raspberry-pi):

```
source [find target/atsame5x.cfg]
```

Hämta ett uppstartsprogram – flera finns på <https://github.com/adafruit/uf2-samdx1/releases/latest>. Exempelvis:

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

Flasha med OpenOCD-kommandon i stil med:

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

SAMD51 använder ett uppstartsprogram på 16 KiB (programmet måste kompileras med startadressen 16 KiB). Flasha ett program med något i stil med:

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## STM32F103-mikrokontroller (Blue Pill-enheter)

STM32F103-enheter har ett ROM som kan flasha ett uppstartsprogram eller program via seriell 3,3 V-anslutning. Anslut normalt PA10 (MCU Rx) och PA9 (MCU Tx) till en 3,3 V-UART-adapter. För att komma åt ROM ansluts "boot 0" högt och "boot 1" lågt och enheten återställs. Paketet "stm32flash" kan sedan användas för flashning, exempelvis:

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

Om Raspberry Pi används för seriell 3,3 V-anslutning använder stm32flash ett paritetsläge som Raspberry Pi:s "mini UART" inte stöder. Se <https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts> för hur fullständig UART aktiveras på Raspberry Pi:s GPIO-stift.

Sätt både "boot 0" och "boot 1" till låg nivå efter flashningen, så att framtida återställningar startar från flashminnet.

### STM32F103 med stm32duino-uppstartsprogram

Projektet "stm32duino" har ett USB-kompatibelt uppstartsprogram, se <https://github.com/rogerclarkmelbourne/STM32duino-bootloader>.

Detta uppstartsprogram kan flashas via seriell 3,3 V-anslutning med något i stil med:

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

Uppstartsprogrammet använder 8 KiB flashminne (programmet måste kompileras med startadressen 8 KiB). Flasha ett program med något i stil med:

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

Uppstartsprogrammet körs normalt bara en kort tid efter uppstart. Du kan behöva tidsanpassa kommandot ovan så att det körs medan uppstartsprogrammet fortfarande är aktivt (kortets lysdiod blinkar då). Alternativt kan du sätta "boot 0" lågt och "boot 1" högt för att stanna i uppstartsprogrammet efter en återställning.

### STM32F103 med HID-uppstartsprogram

[HID-uppstartsprogrammet](https://github.com/Serasidis/STM32_HID_Bootloader) är kompakt, drivrutinsfritt och kan flasha via USB. Det finns även en [gren med byggen för SKR Mini E3 1.2](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

För vanliga STM32F103-kort som Blue Pill kan uppstartsprogrammet flashas via seriell 3,3 V-anslutning med stm32flash enligt stm32duino-avsnittet ovan. Ersätt filnamnet med önskad binärfil för HID-uppstartsprogrammet, exempelvis hid_generic_pc13.bin för Blue Pill.

Det går inte att använda stm32flash för SKR Mini E3, eftersom boot0-stiftet är kopplat direkt till jord och inte finns på någon stiftlist. Använd helst en STLink V2 med STM32CubeProgrammer för att flasha uppstartsprogrammet. Om du saknar STLink kan en [Raspberry Pi med OpenOCD](#running-openocd-on-the-raspberry-pi) användas med följande kretskonfiguration:

```
source [find target/stm32f1x.cfg]
```

Om du vill kan du säkerhetskopiera det nuvarande flashminnet med följande kommando. Det kan ta en stund att slutföra:

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

slutligen kan du flasha med kommandon i stil med:

```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```

ANMÄRKNINGAR:

- Exemplet ovan raderar kretsen och programmerar sedan uppstartsprogrammet. Oavsett flashningsmetod rekommenderas att kretsen raderas före flashningen.
- Innan du flashar SKR Mini E3 med detta uppstartsprogram ska du känna till att firmware inte längre kan uppdateras via SD-kortet.
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

Detta uppstartsprogram kräver 2 KiB flashminne (programmet måste kompileras med startadressen 2 KiB).

Programmet hid-flash används för att överföra en binärfil till uppstartsprogrammet. Du kan installera programmet med följande kommandon:

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

Om uppstartsprogrammet körs kan du flasha med något i stil med:

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

du kan även använda `make flash` för att flasha Klipper direkt:

```
make flash FLASH_DEVICE=1209:BEBA
```

ELLER om Klipper har flashats tidigare:

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

Du kan behöva gå in i uppstartsprogrammet manuellt genom att sätta "boot 0" lågt och "boot 1" högt. SKR Mini E3 saknar "Boot 1"; om "hid_btt_skr_mini_e3.bin" har flashats kan stift PA2 i stället sättas lågt. Stiftet är märkt "TX0" på TFT-stiftlisten i SKR Mini E3-dokumentet "PIN". Jordstiftet bredvid PA2 kan användas för att dra PA2 lågt.

### STM32F103/STM32F072 med MSC-uppstartsprogram

[MSC-uppstartsprogrammet](https://github.com/Telekatz/MSC-stm32f103-bootloader) är drivrutinsfritt och kan flasha via USB.

Uppstartsprogrammet kan flashas via seriell 3,3 V-anslutning med stm32flash enligt stm32duino-avsnittet ovan. Ersätt filnamnet med önskad binärfil för MSC-uppstartsprogrammet, exempelvis MSCboot-Bluepill.bin för Blue Pill.

För STM32F072-kort går det även att flasha uppstartsprogrammet via USB (DFU) med något i stil med:

```
 dfu-util -d 0483:df11 -a 0 -R -D  MSCboot-STM32F072.bin -s0x08000000:leave
```

Detta uppstartsprogram använder 8 KiB eller 16 KiB flashminne; se dess beskrivning. Programmet måste kompileras med motsvarande startadress.

Uppstartsprogrammet kan aktiveras genom att trycka på kortets återställningsknapp två gånger. När det är aktivt visas kortet som en USB-flashenhet där filen klipper.bin kan kopieras.

### STM32F103/STM32F0x2 med CanBoot-uppstartsprogram

[CanBoot](https://github.com/Arksine/CanBoot) gör det möjligt att överföra Klipper-firmware via CAN-buss. Uppstartsprogrammet bygger på Klippers källkod och stöder för närvarande STM32F103, STM32F042 och STM32F072.

ST-Link Programmer rekommenderas för att flasha CanBoot. Det bör dock gå att använda `stm32flash` på STM32F103-enheter och `dfu-util` på STM32F042/STM32F072-enheter. Se tidigare avsnitt för metoderna och ersätt vid behov filnamnet med `canboot.bin`. CanBoot-förrådet ovan innehåller instruktioner för att bygga uppstartsprogrammet.

Första gången CanBoot har flashats bör det upptäcka att inget program finns och gå in i uppstartsprogrammet. Om det inte sker kan du trycka på återställningsknappen två gånger i följd.

Verktyget `flashtool.py` i mappen `lib/katapult` kan användas för att överföra Klipper-firmware. Enhetens UUID krävs för flashning. Om du saknar en UUID kan du fråga vilka noder som kör uppstartsprogrammet:

```
python3 flash_can.py -q
```

Detta returnerar UUID:er för alla anslutna noder som inte redan har tilldelats en UUID. Det bör inkludera alla noder som för närvarande är i uppstartsprogrammet.

När du har en UUID kan firmware överföras med följande kommando:

```
python3 flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u aabbccddeeff
```

Ersätt `aabbccddeeff` med din UUID. Alternativen `-i` och `-f` kan utelämnas; de är som standard `can0` respektive `~/klipper/out/klipper.bin`.

Välj alternativet 8 KiB Bootloader när Klipper byggs för CanBoot.

## STM32F4-mikrokontroller (SKR Pro 1.1)

STM32F4-mikrokontroller har ett inbyggt systemuppstartsprogram som kan flasha via USB (DFU), seriell 3,3 V-anslutning och andra metoder (se STM-dokument AN2606). Vissa STM32F4-kort, som SKR Pro 1.1, kan inte gå in i DFU-läget. HID-uppstartsprogrammet finns för STM32F405/407-baserade kort om USB-flashning föredras framför SD-kort. Du kan behöva konfigurera och bygga en variant för ditt kort; ett [bygge för SKR Pro 1.1 finns här](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

Om kortet saknar DFU är seriell 3,3 V-anslutning troligen den mest tillgängliga flashningsmetoden. Den följer samma förfarande som [flashning av STM32F103 med stm32flash](#stm32f103-micro-controllers-blue-pill-devices), exempelvis:

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

Detta uppstartsprogram kräver 16 KiB flashminne på STM32F4 (programmet måste kompileras med startadressen 16 KiB).

Precis som STM32F1 använder STM32F4 verktyget hid-flash för att överföra binärfiler till MCU:n. Se instruktionerna ovan för hur hid-flash byggs och används.

Du kan behöva gå in i uppstartsprogrammet manuellt: sätt "boot 0" lågt, "boot 1" högt och anslut enheten. Koppla från enheten när programmeringen är klar och sätt "boot 1" lågt igen så att programmet läses in.

## LPC176x-mikrokontroller (Smoothieboards)

Detta dokument beskriver inte hur själva uppstartsprogrammet flashas. Mer information finns på <http://smoothieware.org/flashing-the-bootloader>.

Smoothieboards levereras ofta med ett uppstartsprogram från <https://github.com/triffid/LPC17xx-DFU-Bootloader>. När det används måste programmet kompileras med startadressen 16 KiB. Det enklaste sättet att flasha ett program är att kopiera programfilen, exempelvis `out/klipper.bin`, som `firmware.bin` till ett SD-kort och sedan starta om mikrokontrollern med kortet.

## Köra OpenOCD på Raspberry Pi

OpenOCD är ett programpaket för flashning och felsökning på låg nivå. Det kan använda GPIO-stiften på en Raspberry Pi för att kommunicera med flera ARM-kretsar.

Avsnittet beskriver hur OpenOCD installeras och startas. Det bygger på instruktionerna på <https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>.

Börja med att hämta och kompilera programvaran (varje steg kan ta flera minuter och steget "make" kan ta över 30 minuter):

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

### Konfigurera OpenOCD

Skapa en OpenOCD-konfigurationsfil:

```
nano ~/openocd/openocd.cfg
```

Använd en konfiguration i stil med följande:

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

### Anslut Raspberry Pi till målkretsen

Stäng av både Raspberry Pi och målkretsen före inkoppling! Kontrollera att målkretsen använder 3,3 V innan den ansluts till en Raspberry Pi!

Anslut GND, SWDCLK, SWDIO och RST på målkretsen till GND, GPIO25, GPIO24 respektive GPIO18 på Raspberry Pi.

Starta sedan Raspberry Pi och ge målkretsen ström.

### Kör OpenOCD

Kör OpenOCD:

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

Ovanstående ska få OpenOCD att skriva ut meddelanden och sedan vänta (det ska inte omedelbart återgå till Unix-skalets prompt). Om OpenOCD avslutas självt eller fortsätter skriva ut meddelanden ska inkopplingen dubbelkontrolleras.

När OpenOCD kör stabilt kan du skicka kommandon via telnet. Öppna en annan SSH-session och kör följande:

```
telnet 127.0.0.1 4444
```

(Avsluta telnet genom att trycka ctrl+] och sedan köra kommandot "quit".)

### OpenOCD och gdb

OpenOCD kan användas med gdb för att felsöka Klipper. Följande kommandon förutsätter att gdb körs på en stationär dator.

Lägg till följande i OpenOCD-konfigurationsfilen:

```
bindto 0.0.0.0
gdb_port 44444
```

Starta om OpenOCD på Raspberry Pi och kör sedan följande Unix-kommando på den stationära datorn:

```
cd /path/to/klipper/
gdb out/klipper.elf
```

Kör följande i gdb:

```
target remote octopi:44444
```

(Ersätt "octopi" med Raspberry Pi:ns värdnamn.) När gdb körs kan du ange brytpunkter och inspektera register.
