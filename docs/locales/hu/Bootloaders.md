# Bootloaderek

Ez a dokumentum a Klipper által támogatott mikrovezérlőkön található gyakori bootloaderekkel kapcsolatos információkat tartalmazza.

A bootloader egy harmadik féltől származó szoftver, amely a mikrovezérlőn fut, amikor az először bekapcsol. Általában egy új alkalmazás (pl. Klipper) égetésére használják a mikrokontrollerre anélkül, hogy speciális hardverre lenne szükség. Sajnos a mikrokontrollerek égetésére nincs iparági szabvány, és nincs olyan szabványos bootloader sem, amely minden mikrokontrolleren működik. Ami még rosszabb, hogy minden egyes bootloader más és más lépéseket igényel az alkalmazás égetéséhez.

Ha egy mikrokontrollerre tudunk bootloadert égetni, akkor általában ezt a mechanizmust használhatjuk egy alkalmazás égetésére is, de óvatosan kell eljárni, mert véletlenül eltávolíthatjuk a bootloadert. Ezzel szemben a bootloader általában csak egy alkalmazás égetését teszi lehetővé. Ezért ajánlott, ha lehetséges, bootloadert használni egy alkalmazás égetésére.

Ez a dokumentum megpróbálja leírni a gyakori bootloadereket, a bootloader égetéséhez szükséges lépéseket és az alkalmazás égetéséhez szükséges lépéseket. Ez a dokumentum nem tekintélyes hivatkozás. A Klipper fejlesztői által összegyűjtött hasznos információk gyűjteményének szánjuk.

## AVR mikrovezérlők

Általánosságban az Arduino projekt jó referencia a 8 bites Atmel Atmega mikrovezérlők bootloadereiről és az égetési eljárásokról. Különösen a "boards.txt" fájl: <https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt> hasznos referencia.

A bootloader égetéséhez az AVR chipekhez külső hardveres égető eszközre van szükség (amely SPI segítségével kommunikál a chippel). Ez az eszköz megvásárolható (például keress rá az interneten az "avr isp", "arduino isp" vagy "usb tiny isp" szavakra). Az is lehetséges, hogy egy másik Arduino vagy Raspberry Pi segítségével égess egy AVR bootloadert (például keress rá az interneten a "program an avr using raspberry pi" kifejezésre). Az alábbi példákat egy "AVR ISP Mk2" típusú eszköz használatát feltételezve írtuk.

Az "avrdude" program a leggyakrabban használt eszköz az atmega chipek égetésére (mind a bootloader, mind az alkalmazások égetésére).

### Atmega2560

Ez a chip jellemzően az "Arduino Mega" chipben található, és nagyon gyakori a 3D nyomtató lapokban.

A bootloader égetéséhez használj valami olyasmit, mint:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Egy alkalmazás égetéséhez használj valami olyasmit, mint:

```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

Ez a chip jellemzően az "Arduino Mega" korábbi verzióiban található.

A bootloader égetéséhez használj valami olyasmit, mint:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Egy alkalmazás égetéséhez használj valami olyasmit, mint:

```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

Ez a chip gyakran megtalálható a "Melzi" stílusú 3D nyomtató alaplapokban.

A bootloader égetéséhez használj valami olyasmit, mint:

```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Egy alkalmazás égetéséhez használj valami olyasmit, mint:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

Megjegyzendő, hogy számos "Melzi" stílusú alaplap előre betöltött bootloaderrel érkezik, amely 57600-as átviteli sebesség használatával működik. Ebben az esetben egy alkalmazás égetéséhez használj helyette valami ilyesmit:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

Ez a dokumentum nem foglalkozik az At90usb1286 bootloader égetési módszerével, és nem foglalkozik az általános alkalmazás égetésével sem.

A pjrc.com Teensy++ eszköze saját bootloaderrel rendelkezik. Ehhez egy egyedi égető eszközre van szükség a <https://github.com/PaulStoffregen/teensy_loader_cli> oldalról. Egy alkalmazást lehet vele égetni valami ilyesmivel:

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

Az atmega168 korlátozott flash-tárhellyel rendelkezik. Ha bootloader-t használ, ajánlott az Optiboot bootloader-t használni. A bootloader égetéséhez használj valami hasonlót:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Az Optiboot bootloader-el történő alkalmazás égetéséhez használj valami hasonlót:

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## SAM3 mikrovezérlők (Arduino Due)

A SAM3 MCU-val nem szokás bootloadert használni. Maga a chip rendelkezik egy ROM-mal, amely lehetővé teszi a flash programozását 3,3V-os soros portról vagy USB-ről.

A ROM engedélyezéséhez az "erase" tűt magasan kell tartani a visszaállítás során, ami törli a flash tartalmát, és a ROM-ot elindítja. Az Arduino Due-n ezt a sorrendet úgy lehet elérni, hogy 1200-as adatátviteli sebességet állítunk be a "programozási usb-porton" (a tápegységhez legközelebbi USB-porton).

A <https://github.com/shumatech/BOSSA> alatti kód használható a SAM3 programozásához. Az 1.9-es vagy újabb verzió használata ajánlott.

Egy alkalmazás égetéséhez használj valami olyasmit, mint:

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## SAM4 mikrovezérlők (Duet Wifi)

A SAM4 MCU-val nem szokás bootloadert használni. Maga a chip rendelkezik egy ROM-mal, amely lehetővé teszi a flash programozását 3,3V-os soros portról vagy USB-ről.

A ROM engedélyezéséhez az "erase" csapot magasan kell tartani a visszaállítás során, ami törli a flash tartalmát, és a ROM-ot elindítja.

A <https://github.com/shumatech/BOSSA> kód használható a SAM4 programozásához. Szükséges az `1.8.0` vagy magasabb verzió használata.

Egy alkalmazás égetéséhez használj valami olyasmit, mint:

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## SAMD21 mikrovezérlők (Arduino Zero)

A SAMD21 bootloader az ARM Serial Wire Debug (SWD) interfészen keresztül töltődik fel. Ez általában egy dedikált SWD hardver dongle segítségével történik. Alternatívaként használhatunk egy [OpenOCD futtatást a Raspberry PI-n](#az-openocd-futtatasa-a-raspberry-pi-n).

A bootloader OpenOCD-vel történő égetéséhez használd a következő chip konfigurációt:

```
forrás [find target/at91samdXX.cfg]
```

Szerezz be egy bootloadert - például:

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

Égetés az OpenOCD parancsokhoz hasonló parancsokkal:

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

A SAMD21 leggyakoribb bootloadere az "Arduino Zero" -ban található. Ez egy 8KiB-es bootloadert használ (az alkalmazást 8KiB kezdőcímmel kell lefordítani). Ebbe a bootloaderbe a reset gombra való dupla kattintással lehet belépni. Egy alkalmazás égetéséhez használj valami hasonlót:

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

Ezzel szemben az "Arduino M0" 16KiB bootloadert használ (az alkalmazást 16KiB kezdőcímmel kell lefordítani). Egy alkalmazás égetéséhez ezen a bootloaderen, állítsd vissza a mikrokontrollert, és futtasd a flash parancsot a bootolás első néhány másodpercében. Valami ilyesmi:

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## SAMD51 mikrovezérlők (Adafruit Metro-M4 és hasonló)

A SAMD21-hez hasonlóan a SAMD51 bootloader is az ARM Serial Wire Debug (SWD) interfészen keresztül töltődik fel. Az [OpenOCD futtatása a Raspberry PI-n](#az-openocd-futtatasa-a-raspberry-pi-n) bootloader égetéséhez használd a következő chipkonfigurációt:

```
forrás [find target/atsame5x.cfg]
```

Szerezz be egy bootloadert. Számos bootloader elérhető a <https://github.com/adafruit/uf2-samdx1/releases/latest> oldalon. Például:

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

Égetés az OpenOCD parancsokhoz hasonló parancsokkal:

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

A SAMD51 16KiB-es bootloadert használ (az alkalmazást 16KiB kezdőcímmel kell lefordítani). Egy alkalmazás égetéséhez használj valami hasonlót:

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## STM32F103 mikrovezérlők (Blue Pill eszközök)

Az STM32F103 eszközök rendelkeznek egy ROM-mal, amely 3,3 V-os soros kapcsolaton keresztül képes bootloadert vagy alkalmazást égetni. Általában a PA10 (MCU Rx) és PA9 (MCU Tx) tűket egy 3,3V-os UART adapterhez kell csatlakoztatni. A ROM eléréséhez a "boot 0" tűt magasra, a "boot 1" tűt pedig alacsonyra kell kapcsolni, majd vissza kell állítani az eszközt. Az "stm32flash" csomagot ezután használhatjuk az eszköz égetésére, például a következőkkel:

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

Vedd figyelembe, hogy ha Raspberry Pi-t használsz a 3,3V-os soros kapcsolathoz, az stm32flash protokoll olyan soros paritásmódot használ, amelyet a Raspberry Pi "mini UART" nem támogat. Lásd <https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts> a teljes uart engedélyezéséről a Raspberry Pi GPIO tűin.

Az égetés után állítsd vissza a "boot 0" és a "boot 1" értéket alacsonyra, hogy a jövőben az égetésről induló rendszer újrainduljon.

### STM32F103 stm32duino bootloaderrel

Az "stm32duino" projekt rendelkezik USB-képes bootloaderrel. Lásd: <https://github.com/rogerclarkmelbourne/STM32duino-bootloader>

Ez a bootloader 3,3V-os soros kapcsolaton keresztül égethető valami hasonlóval:

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

Ez a bootloader 8KiB-es flash memóriát használ (az alkalmazást 8KiB kezdőcímmel kell lefordítani). Égess egy alkalmazást valami ilyesmivel:

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

A bootloader általában csak rövid ideig fut a rendszerindítás után. Szükség lehet arra, hogy a fenti parancsot úgy időzítsük, hogy az akkor fusson le, amikor a bootloader még aktív (a bootloader üzem közben villogtat egy a lapon lévő ledet). Alternatív megoldásként a "boot 0" csapot állítsd alacsonyra, a "boot 1" csapot pedig magasra, hogy a bootloaderben maradj a reset után.

### STM32F103 HID bootloaderrel

A [HID bootloader](https://github.com/Serasidis/STM32_HID_Bootloader) egy kompakt, driver nélküli bootloader, amely képes USB-n keresztül égetni. Szintén elérhető egy [fork az SKR Mini E3 1.2 specifikus buildekkel](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

Az általános STM32F103 lapok, például a Bluepill esetében a bootloader 3,3 V-os soros égetése lehetséges az stm32flash használatával, ahogyan azt a fenti stm32duino szakaszban említettük, a kívánt hid bootloader bináris fájlnevének behelyettesítésével (azaz: hid_generic_pc13.bin a Bluepill-hez).

Az SKR Mini E3 esetében nem lehet stm32flash-t használni, mivel a boot0 láb közvetlenül a földre van kötve, és nincs alaplapi tűkiállása. A bootloader égetéséhez ajánlott STLink V2-t használni STM32Cube programozóval. Ha nincs vagy nem fér hozzá egy STLink-hez, akkor lehetséges egy [OpenOCD futtatása a Raspberry PI-n](#az-openocd-futtatasa-a-raspberry-pi-n) használata is a következő chip konfigurációval:

```
forrás [find target/stm32f1x.cfg]
```

Ha szeretnéd, a következő paranccsal készíthetsz biztonsági másolatot az aktuális flash memóriáról. Vedd figyelembe, hogy ez némi időt vehet igénybe:

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

végül, a következő parancsokhoz hasonló parancsokkal égethetsz:

```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```

MEGJEGYZÉSEK:

- A fenti példa törli a chipet, majd beprogramozza a bootloadert. Az égetéshez választott módszertől függetlenül ajánlott a chipet az égetés előtt törölni.
- Mielőtt az SKR Mini E3-at ezzel a bootloader-el égetnéd, tudnod kell, hogy a firmware frissítése már nem lesz lehetséges az SD-kártyán keresztül.
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
Ezt követően elengedheted a reset gombot.

Ez a bootloader 2KiB-os flash memóriát igényel (az alkalmazást 2KiB kezdőcímmel kell lefordítani).

A hid-flash program egy bináris fájl feltöltésére szolgál a bootloader-re. Ezt a szoftvert a következő parancsokkal telepítheted:

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

Ha a bootloader fut, akkor égethetsz valami olyasmivel, mint:

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

alternatívaként használhatod a `make flash` parancsot a klipper közvetlen égetéséhez:

```
make flash FLASH_DEVICE=1209:BEBA
```

VAGY ha a klippert korábban már égették:

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

Szükség lehet a bootloader manuális belépésére, ezt a "boot 0" alacsony és a "boot 1" magas értékének beállításával lehet megtenni. Az SKR Mini E3 lapon a "Boot 1" nem elérhető, ezért a "hid_btt_skr_mini_e3.bin" égetése esetén a PA2 tű alacsonyra húzásával teheted meg. Ez a tű "TX0" feliratú a TFT fejlécén az SKR Mini E3 "PIN" dokumentumában. A PA2 mellett van egy földelt tű, amelyet a PA2 alacsonyra húzására használhatsz.

### STM32F103/STM32F072 MSC bootloaderrel

Az [MSC bootloader](https://github.com/Telekatz/MSC-stm32f103-bootloader) egy USB-n keresztül égethető, driver nélküli bootloader.

Lehetőség van a bootloader 3,3V-os soros égetésére az stm32flash használatával, ahogyan azt a fenti stm32duino szakaszban említettük, a kívánt MSC bootloader bináris fájlnevét behelyettesítve (azaz: MSCboot-Bluepill.bin a Bluepill-hez).

Az STM32F072 lapok esetében a bootloader USB-n keresztül (DFU-n keresztül) is égethető, például a következőkkel:

```
 dfu-util -d 0483:df11 -a 0 -R -D  MSCboot-STM32F072.bin -s0x08000000:leave
```

Ez a bootloader 8KiB vagy 16KiB memória helyet használ, lásd a bootloader leírását (az alkalmazást a megfelelő kezdőcímmel kell lefordítani).

A bootloader a kártya reset gombjának kétszeri megnyomásával aktiválható. Amint a bootloader aktiválódik, a kártya USB flash meghajtóként jelenik meg, amelyre a klipper.bin fájl másolható.

### STM32F103/STM32F0x2 CanBoot bootloaderrel

A [CanBoot](https://github.com/Arksine/CanBoot) bootloader lehetőséget biztosít a Klipper firmware feltöltésére CANBUS-on keresztül. Maga a bootloader a Klipper forráskódjából származik. A CanBoot jelenleg az STM32F103, STM32F042 és STM32F072 modelleket támogatja.

A CanBoot égetéséhez ajánlott ST-Link programozót használni, azonban STM32F103 eszközökön az `stm32flash`, STM32F103 eszközökön a `dfu-util`, STM32F042/STM32F072 eszközökön pedig a dfu-util segítségével is lehet égetni. Lásd a dokumentum előző szakaszait az égetési módszerekre vonatkozó utasításokért, adott esetben a `canboot.bin` fájlnévvel helyettesítve. A fent hivatkozott CanBoot tároló tartalmaz utasításokat a bootloader elkészítéséhez.

A CanBoot első égetésénél észlelned kell, hogy nincs jelen alkalmazás, és be kell lépned a bootloaderbe. Ha ez nem történik meg, akkor a reset gomb kétszer egymás utáni megnyomásával lehet belépni a bootloaderbe.

A Klipper firmware feltöltéséhez a `flash_can.py` segédprogram használható, amely a `lib/canboot` mappában található. Az égetéshez szükséges az eszköz UUID azonosítója. Ha nincs meg az UUID, akkor a bootloadert jelenleg futtató csomópontok lekérdezése lehetséges:

```
python3 flash_can.py -q
```

Ez visszaadja az összes olyan csatlakoztatott csomópont UUID-jét, amelyhez jelenleg nem tartozik UUID. Ennek tartalmaznia kell a jelenlegi bootloaderben lévő összes csomópontot.

Ha megvan az UUID, a következő paranccsal tölthetsz fel firmware-t:

```
python3 flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u aabbccddeeff
```

Ahol `aabbccddeeff` helyébe a Te UUID-d lép. Vedd figyelembe, hogy a `-i` és `-f` opciók elhagyhatók, ezek alapértelmezett értéke `can0` és `~/klipper/out/klipper.bin`.

Amikor a Klippert a CanBoot-al való használatra készíted, válaszd a 8 KiB-os bootloader opciót.

## STM32F4 mikrovezérlők (SKR Pro 1.1)

Az STM32F4 mikrovezérlők beépített rendszerbetöltővel vannak felszerelve, amely képes USB-n keresztül (DFU módban), 3,3V-os soros és különböző más módszerekkel égetni (további információkért lásd az STM AN2606 dokumentumát). Egyes STM32F4 lapok, mint például az SKR Pro 1.1, nem képesek belépni a DFU bootloaderbe. A HID bootloader elérhető az STM32F405/407 alapú lapokhoz, amennyiben a felhasználó az USB-n keresztül történő égetést részesíti előnyben az SD-kártya használatával szemben. Ne feledd, hogy szükség lehet egy, az alaplappal specifikus verzió konfigurálására és égetésére, egy [az SKR Pro 1.1-es verzióra vonatkozó bootloader elérhető itt](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

Hacsak a lapod nem DFU-képes, a legkönnyebben elérhető égetési módszer valószínűleg a 3,3V-os soros, amely ugyanazt az eljárást követi, mint [az STM32F103 égetése az stm32flash segítségével](#stm32f103-micro-controllers-blue-pill-devices). Például:

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

Ez a bootloader 16Kib-es flash memóriát igényel az STM32F4-en (az alkalmazást 16KiB kezdőcímmel kell lefordítani).

Az STM32F1-hez hasonlóan az STM32F4 is a hid-flash eszközt használd a binárisok MCU-ra történő feltöltéséhez. A hid-flash elkészítésének és használatának részletei a fenti utasításokban találhatók.

Szükség lehet a bootloader manuális belépésére, ez a "boot 0" alacsony, "boot 1" magas érték beállításával és az eszköz csatlakoztatásával történhet. A programozás befejezése után húzd ki az eszközt, és állítsd vissza a "boot 1" értéket alacsonyra, hogy az alkalmazás betöltődjön.

## LPC176x mikrovezérlők (Smoothieboards)

Ez a dokumentum nem írja le a bootloader égetésének módszerét. Lásd: <http://smoothieware.org/flashing-the-bootloader> a témával kapcsolatos további információkért.

A Smoothieboardok általában a következő bootloaderrel érkeznek: <https://github.com/triffid/LPC17xx-DFU-Bootloader>. Ha ezt a bootloadert használjuk, az alkalmazást 16KiB kezdőcímmel kell lefordítani. Az alkalmazás égetésének legegyszerűbb módja ezzel a bootloaderrel az alkalmazásfájl (pl. `out/klipper.bin`) másolása egy SD-kártyán lévő `firmware.bin` nevű fájlra, majd a mikrokontroller újraindítása ezzel az SD-kártyával.

## Az OpenOCD futtatása a Raspberry PI-n

Az OpenOCD egy olyan szoftvercsomag, amely képes alacsony szintű égetésekre és hibakeresésre. A Raspberry Pi GPIO-tűit használhatod a különböző ARM-chipekkel való kommunikációra.

Ez a szakasz leírja, hogyan lehet telepíteni és elindítani az OpenOCD-t. A következő oldalon található utasításokból származik: <https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>

Kezd a szoftver letöltésével és fordításával (minden lépés több percet vehet igénybe, és a "make" lépés több mint 30 percet is igénybe vehet):

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

### Az OpenOCD konfigurálása

OpenOCD konfigurációs fájl létrehozása:

```
nano ~/openocd/openocd.cfg
```

Használj a következőhöz hasonló konfigurációt:

```
# RPi tűket használ: GPIO25 az SWDCLK-hoz, GPIO24 az SWDIO-hoz, GPIO18 az nRST-hez.
forrás [find interface/raspberrypi2-native.cfg]
bcm2835gpio_swd_nums 25 24
bcm2835gpio_srst_num 18
szállítás kiválasztása swd

# Hardveres reset vezeték használata a chip reseteléséhez
reset_config srst_only
adapter_nsrst_delay 100
adapter_nsrst_assert_width 100

# A chip típusának megadása
source [find target/atsame5x.cfg]

# Add meg az adapter sebességét
adapter_khz 40

# Csatlakozás a chiphez
init
targets
reset halt
```

### A Raspberry Pi és a célchip összekötése

Kapcsold ki mind a Raspberry Pi-t, mind a célchipet a kábelezés előtt! Ellenőrizd, hogy a célchip 3,3V-ot használ-e a Raspberry Pi csatlakoztatása előtt!

Csatlakoztasd a célchip GND, SWDCLK, SWDIO és RST tűit a Raspberry Pi GND, GPIO25, GPIO24 és GPIO18 tűihez.

Ezután kapcsold be a Raspberry Pi-t, és adj áramot a cél chip-nek.

### OpenOCD futtatása

Futtasd az OpenOCD-t:

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

A fentieknek hatására az OpenOCD-nek ki kell adnia néhány szöveges üzenetet, majd várnia kell (nem szabad azonnal visszatérnie az Unix shell prompthoz). Ha az OpenOCD magától kilép, vagy ha továbbra is szöveges üzeneteket ad ki, akkor ellenőrizd kétszer a kábelezést.

Ha az OpenOCD fut és stabilan működik, akkor telneten keresztül parancsokat küldhetünk neki. Nyissunk egy másik SSH munkamenetet, és futtassuk a következőket:

```
telnet 127.0.0.1 4444
```

(A telnet-ből a ctrl+] billentyűkombinációval, majd a "quit" parancs futtatásával lehet kilépni.)

### OpenOCD és gdb

Lehetőség van az OpenOCD és a gdb használatára a Klipper hibakeresésére. A következő parancsok feltételezik, hogy a gdb egy asztali gépen fut.

Add hozzá a következőket az OpenOCD konfigurációs fájljához:

```
bindto 0.0.0.0
gdb_port 44444
```

Indítsd újra az OpenOCD-t a Raspberry Pi-n, majd futtasd a következő Unix parancsot az asztali gépen:

```
cd /path/to/klipper/
gdb out/klipper.elf
```

A gdb futtatása:

```
target remote octopi:44444
```

(Cseréld ki az "octopi" -t a Raspberry Pi gazdagép nevére.) Ha a gdb fut, lehetőség van töréspontok beállítására és a regiszterek vizsgálatára.
