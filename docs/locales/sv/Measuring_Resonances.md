# Mäta resonanser

Klipper har inbyggt stöd för ADXL345- samt MPU-9250-, LIS2DW- och LIS3DH-kompatibla accelerometrar, som kan användas för att mäta skrivarens resonansfrekvenser för olika axlar och automatiskt trimma [input shaper](Resonance_Compensation.md) för att kompensera för resonanser. Observera att accelerometrar kräver en del lödning och krimpning. ADXL345 kan anslutas till SPI-gränssnittet på ett Raspberry Pi- eller MCU-kort (det behöver vara någorlunda snabbt). MPU-familjen kan anslutas direkt till I2C-gränssnittet på Raspberry Pi eller till ett I2C-gränssnitt på ett MCU-kort som har stöd för Klippers *fast mode* på 400 kbit/s. LIS2DW och LIS3DH kan anslutas via antingen SPI eller I2C med samma överväganden som ovan.

Tänk på att det finns många olika mönsterkortskonstruktioner och kloner när du köper accelerometrar. Om accelerometern ska anslutas till en 5 V-skrivar-MCU måste den ha en spänningsregulator och nivåomvandlare.

För ADXL345 ska du se till att kortet har stöd för SPI-läge (ett litet antal kort verkar vara fast konfigurerade för I2C genom att SDO är draget till GND).

För MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500/ICM20948 och LIS2DW/LIS3DH finns också många olika kortkonstruktioner och kloner med olika I2C-pull-up-motstånd som kan behöva kompletteras.

## MCU:er med stöd för Klipper I2C i *fast mode*

| MCU-familj | Testade MCU:er | MCU:er med stöd |
| :-: | :-- | :-- |
| Raspberry Pi | 3B+, Pico | 3A, 3A+, 3B, 4 |
| AVR ATmega | ATmega328p | ATmega32u4, ATmega128, ATmega168, ATmega328, ATmega644p, ATmega1280, ATmega1284, ATmega2560 |
| AVR AT90 | - | AT90usb646, AT90usb1286 |
| SAMD | SAMC21G18 | SAMC21G18, SAMD21G18, SAMD21E18, SAMD21J18, SAMD21E15, SAMD51G19, SAMD51J19, SAMD51N19, SAMD51P20, SAME51J19, SAME51N19, SAME54P20 |

## Installationsanvisningar

### Koppling

En Ethernet-kabel med skärmade tvinnade par (Cat5e eller bättre) rekommenderas för signalintegriteten över längre avstånd. Om du ändå får problem med signalintegriteten (SPI-/I2C-fel):

- Kontrollera kabeldragningen med en digital multimeter med avseende på:
   - korrekta anslutningar när enheten är avstängd (kontinuitet),
   - korrekta spänningsnivåer för ström och jord.
- Endast I2C:
   - Kontrollera att SCL- och SDA-ledningarnas resistans till 3,3 V ligger mellan 900 ohm och 1,8 kΩ.
   - Fullständiga tekniska detaljer finns i [kapitel 7 i I2C-busspecifikationen och användarhandboken UM10204](https://www.pololu.com/file/0J435/UM10204.pdf) för *fast mode*.
- Förkorta kabeln.

Anslut Ethernet-kabelns skärm endast till jord på MCU-kortet/Pi:n.

***Kontrollera kabeldragningen en gång till innan du slår på strömmen, så att MCU:n/Raspberry Pi:n eller accelerometern inte skadas.***

### SPI-accelerometrar

Föreslagen ordning för tvinnade par för tre tvinnade par:

```
GND+MISO
3.3V+MOSI
SCLK+CS
```

Observera att GND, till skillnad från kabelskärmen, måste anslutas i båda ändar.

#### ADXL345

##### Direkt till Raspberry Pi

**Observera: Många MCU:er fungerar med en ADXL345 i SPI-läge (till exempel Pi Pico); kabeldragning och konfiguration varierar beroende på just ditt kort och tillgängliga stift.**

Du måste ansluta ADXL345 till din Raspberry Pi via SPI. Observera att I2C-anslutningen, som föreslås i ADXL345-dokumentationen, har för låg genomströmning och **fungerar inte**. Rekommenderad koppling:

| ADXL345-stift | RPi-stift | RPi-stiftnamn |
| :-: | :-: | :-: |
| 3V3 (eller VCC) | 01 | 3,3 V likström |
| GND | 06 | Jord |
| CS | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

Fritzing-kopplingsscheman för några ADXL345-kort:

![ADXL345-Rpi](img/adxl345-fritzing.png)

##### Använda Raspberry Pi Pico

Du kan ansluta ADXL345 till Raspberry Pi Pico och sedan ansluta Pico till Raspberry Pi via USB. Det gör det enkelt att återanvända accelerometern på andra Klipper-enheter eftersom du kan ansluta via USB i stället för GPIO. Pico har inte särskilt mycket beräkningskraft, så se till att den endast kör accelerometern och inte utför andra uppgifter.

För att undvika skador på RPi:n ska ADXL345 endast anslutas till 3,3 V. Beroende på kortets utformning kan en nivåomvandlare finnas, vilket gör 5 V farligt för RPi:n.

| ADXL345-stift | Pico-stift | Pico-stiftnamn |
| :-: | :-: | :-: |
| 3V3 (eller VCC) | 36 | 3,3 V likström |
| GND | 38 | Jord |
| CS | 2 | GP1 (SPI0_CSn) |
| SDO | 1 | GP0 (SPI0_RX) |
| SDA | 5 | GP3 (SPI0_TX) |
| SCL | 4 | GP2 (SPI0_SCK) |

Kopplingsscheman för några av ADXL345-korten:

![ADXL345-Pico](img/adxl345-pico.png)

### I2C-accelerometrar

Föreslagen ordning för tvinnade par för tre par (föredras):

```
3.3V+GND
SDA+GND
SCL+GND
```

eller för två par:

```
3.3V+SDA
GND+SCL
```

Observera att eventuell GND, till skillnad från kabelskärmen, ska anslutas i båda ändar.

#### MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500/ICM20948

Dessa accelerometrar har testats med I2C på RPi, RP2040 (Pico) och AVR med 400 kbit/s (*fast mode*). Vissa MPU-accelerometermoduler har pull-up-motstånd, men en del är för stora, 10 kΩ, och måste bytas eller kompletteras med mindre parallellkopplade motstånd.

Rekommenderat anslutningsschema för I2C på Raspberry Pi:

| MPU-9250-stift | RPi-stift | RPi-stiftnamn |
| :-: | :-: | :-: |
| VCC | 01 | 3,3 V DC-ström |
| GND | 09 | Jord |
| SDA | 03 | GPIO02 (SDA1) |
| SCL | 05 | GPIO03 (SCL1) |

RPi har inbyggda pull-up-motstånd på 1,8 kΩ på både SCL och SDA.

![MPU-9250 ansluten till Pi](img/mpu9250-PI-fritzing.png)

Rekommenderat anslutningsschema för I2C (i2c0a) på RP2040:

| MPU-9250-stift | RP2040-stift | RP2040-stiftnamn |
| :-: | :-: | :-: |
| VCC | 36 | 3v3 |
| GND | 38 | Jord |
| SDA | 01 | GP0 (I2C0 SDA) |
| SCL | 02 | GP1 (I2C0 SCL) |

Pico har inga inbyggda pull-up-motstånd för I2C.

![MPU-9250 ansluten till Pico](img/mpu9250-PICO-fritzing.png)

##### Rekommenderat anslutningsschema för I2C (TWI) på AVR ATmega328P Arduino Nano:

| MPU-9250-stift | Atmega328P TQFP32-stift | Atmega328P-stiftnamn | Arduino Nano-stift |
| :-: | :-: | :-: | :-: |
| VCC | 39 | - | - |
| GND | 38 | Jord | GND |
| SDA | 27 | SDA | A4 |
| SCL | 28 | SCL | A5 |

Arduino Nano har varken inbyggda pull-up-motstånd eller en 3,3 V-strömanslutning.

### Montera accelerometern

Accelerometern måste fästas på verktygshuvudet. Ett lämpligt fäste som passar den egna 3D-skrivaren behöver konstrueras. Det är bäst att rikta accelerometerns axlar efter skrivarens axlar, men axlarna kan bytas om det är enklare. X-axeln behöver alltså inte riktas mot X och så vidare; det fungerar även om accelerometerns Z-axel är skrivarens X-axel.

Ett exempel på montering av ADXL345 på SmartEffector:

![ADXL345 on SmartEffector](img/adxl345-mount.jpg)

Observera att en skrivare med rörlig bädd kräver två fästen, ett för verktygshuvudet och ett för bädden, och att mätningarna måste köras två gånger. Se motsvarande [avsnitt](#bed-slinger-printers) för mer information.

**Varning:** kontrollera att accelerometern och alla skruvar som håller den på plats inte rör några metalldelar på skrivaren. Fästet måste säkerställa elektrisk isolering mellan accelerometern och skrivarens ram. Annars kan en jordslinga uppstå och skada elektroniken.

### Programvaruinstallation

Observera att resonansmätningar och automatisk shaper-kalibrering kräver ytterligare programvaruberoenden som inte installeras som standard. Kör först följande kommandon på Raspberry Pi:

```
sudo apt update
sudo apt install python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev
```

Kör sedan följande kommando för att installera NumPy i Klipper-miljön:

```
~/klippy-env/bin/pip install -v "numpy<1.26"
```

Beroende på processorns prestanda kan detta ta *mycket* lång tid, upp till 10–20 minuter. Ha tålamod och vänta tills installationen är klar. Ibland kan installationen misslyckas om kortet har för lite RAM, och då måste swap aktiveras. Observera också den tvingade versionen eftersom nyare versioner av NumPy kan ha krav som inte uppfylls i vissa Klipper Python-miljöer.

När det har installerats kontrollerar du att kommandot inte visar några fel:

```
~/klippy-env/bin/python -c 'import numpy;'
```

Korrekt utdata ska endast vara en ny rad.

#### Konfigurera ADXL345 med RPi

Kontrollera först och följ anvisningarna i [dokumentet om RPi-mikrokontrollern](RPi_microcontroller.md) för att ställa in "linux mcu" på Raspberry Pi. Det konfigurerar en andra Klipper-instans som körs på Pi:n.

Kontrollera att Linux SPI-drivrutinen är aktiverad genom att köra `sudo raspi-config` och aktivera SPI i menyn "Interfacing options".

Lägg till följande i filen printer.cfg:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # an example
```

Börja gärna med en sonderingspunkt mitt på utskriftsbädden, strax ovanför den.

#### Konfigurera ADXL345 med Pi Pico

##### Flasha Pico-firmware

Kompilera firmwaren för Pico på Raspberry Pi.

```
cd ~/klipper
make clean
make menuconfig
```

![Pico menuconfig](img/klipper_pico_menuconfig.png)

Håll ned `BOOTSEL`-knappen på Pico och anslut sedan Pico till Raspberry Pi via USB. Kompilera och flasha firmwaren.

```
make flash FLASH_DEVICE=first
```

Om det misslyckas får du information om vilken `FLASH_DEVICE` som ska användas. I det här exemplet är det `make flash FLASH_DEVICE=2e8a:0003`. ![Bestäm flash-enhet](img/flash_rp2040_FLASH_DEVICE.png)

##### Konfigurera anslutningen

Pico startar nu om med den nya firmwaren och bör visas som en seriell enhet. Hitta Picos seriella enhet med `ls /dev/serial/by-id/*`. Du kan nu lägga till en fil `adxl.cfg` med följande inställningar:

```
[mcu adxl]
# Change <mySerial> to whatever you found above. For example,
# usb-Klipper_rp2040_E661640843545B2E-if00
serial: /dev/serial/by-id/usb-Klipper_rp2040_<mySerial>

[adxl345]
cs_pin: adxl:gpio1
spi_bus: spi0a
axes_map: x,z,y

[resonance_tester]
accel_chip: adxl345
probe_points:
    # Somewhere slightly above the middle of your print bed
    147,154, 20

[output_pin power_mode] # Improve power stability
pin: adxl:gpio23
```

Om du konfigurerar ADXL345 i en separat fil enligt ovan bör du också ändra filen `printer.cfg` så att den innehåller följande:

```
[include adxl.cfg] # Comment this out when you disconnect the accelerometer
```

Starta om Klipper med kommandot `RESTART`.

#### Konfigurera LIS2DW-serien via SPI

```
[mcu lis]
# Change <mySerial> to whatever you found above. For example,
# usb-Klipper_rp2040_E661640843545B2E-if00
serial: /dev/serial/by-id/usb-Klipper_rp2040_<mySerial>

[lis2dw]
cs_pin: lis:gpio1
spi_bus: spi0a
axes_map: x,z,y

[resonance_tester]
accel_chip: lis2dw
probe_points:
    # Somewhere slightly above the middle of your print bed
    147,154, 20
```

#### Konfigurera MPU-6000/9000-serien med RPi

Kontrollera att Linux I2C-drivrutinen är aktiverad och att överföringshastigheten är 400000 (mer information finns i avsnittet [Aktivera I2C](RPi_microcontroller.md#optional-enabling-i2c)). Lägg sedan till följande i printer.cfg:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[mpu9250]
i2c_mcu: rpi
i2c_bus: i2c.1

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # an example
```

Om du använder ICM20948 ersätter du förekomster av "mpu9250" med "icm20948".

#### Konfigurera MPU-9520-kompatibla enheter med Pico

Pico I2C är som standard inställt på 400000. Lägg bara till följande i printer.cfg:

```
[mcu pico]
serial: /dev/serial/by-id/<your Pico's serial ID>

[mpu9250]
i2c_mcu: pico
i2c_bus: i2c0a

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # an example

[static_digital_output pico_3V3pwm] # Improve power stability
pins: pico:gpio23
```

Om du använder ICM20948 ersätter du förekomster av "mpu9250" med "icm20948".

#### Konfigurera MPU-9520-kompatibla enheter med AVR

AVR I2C ställs in på 400000 av alternativet mpu9250. Lägg bara till följande i printer.cfg:

```
[mcu nano]
serial: /dev/serial/by-id/<your nano's serial ID>

[mpu9250]
i2c_mcu: nano

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # an example
```

Om du använder ICM20948 ersätter du förekomster av "mpu9250" med "icm20948".

Starta om Klipper med kommandot `RESTART`.

## Mäta resonanserna

### Kontrollera inställningen

Nu kan du testa anslutningen.

- För skrivare utan rörlig bädd, till exempel med en accelerometer, anger du `ACCELEROMETER_QUERY` i OctoPrint.
- För skrivare med rörlig bädd, till exempel med fler än en accelerometer, anger du `ACCELEROMETER_QUERY CHIP=<chip>`, där `<chip>` är namnet på kretsen som det angavs, till exempel `CHIP=bed`. Se [skrivare med rörlig bädd](#bed-slinger-printers) för alla installerade accelerometerkretsar.

Du bör se accelerometerns aktuella mätvärden, inklusive fritt falls acceleration, till exempel:

```
Recv: // adxl345 values (x, y, z): 470.719200, 941.438400, 9728.196800
```

Om du får ett fel som `Invalid adxl345 id (got xx vs e5)`, där `xx` är ett annat ID, försök omedelbart igen. Det finns ett problem med SPI-initieringen. Om felet kvarstår tyder det på ett anslutningsproblem med ADXL345 eller en trasig sensor. Kontrollera strömförsörjningen, kabeldragningen (att den överensstämmer med schemat, att ingen kabel är av eller glappar osv.) och lödkvaliteten en gång till.

**Om du använder en MPU-9250-kompatibel accelerometer och den visas som `mpu-unknown` ska du vara försiktig! Det är troligen renoverade chip!**

Kör sedan `MEASURE_AXES_NOISE` i OctoPrint. Du bör få några basvärden för accelerometerns brus på axlarna, vanligen ungefär 1–100. Mycket högt brus på axlarna, till exempel 1000 eller mer, kan tyda på sensorproblem, problem med strömförsörjningen eller för brusiga och obalanserade fläktar på 3D-skrivaren.

### Mäta resonanserna

Nu kan du köra praktiska tester. Kör följande kommando:

```
TEST_RESONANCES AXIS=X
```

Observera att detta skapar vibrationer på X-axeln. Det inaktiverar också input shaping om funktionen tidigare var aktiverad, eftersom resonanstestning inte kan köras med input shaping aktiverat.

**Varning!** Övervaka skrivaren första gången för att kontrollera att vibrationerna inte blir för kraftiga. Kommandot `M112` kan användas för att avbryta testet vid en nödsituation. Om vibrationerna blir för kraftiga kan du försöka ange ett lägre värde än standard för parametern `accel_per_hz` i avsnittet `[resonance_tester]`, till exempel:

```
[resonance_tester]
accel_chip: adxl345
accel_per_hz: 50  # default is 75
probe_points: ...
```

Om det fungerar för X-axeln kör du även för Y-axeln:

```
TEST_RESONANCES AXIS=Y
```

Detta skapar två CSV-filer (`/tmp/resonances_x_*.csv` och `/tmp/resonances_y_*.csv`). Filerna kan bearbetas med det fristående skriptet på Raspberry Pi. Skriptet är avsett att köras med en CSV-fil för varje uppmätt axel, men kan användas med flera CSV-filer om du vill beräkna ett medelvärde av resultaten. Medelvärdesberäkning kan till exempel vara användbar om resonanstester gjordes vid flera testpunkter. Ta bort extra CSV-filer om du inte vill beräkna ett medelvärde.

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

Skriptet skapar diagrammen `/tmp/shaper_calibrate_x.png` och `/tmp/shaper_calibrate_y.png` med frekvenssvar. Du får också föreslagna frekvenser för varje input shaper och vilken input shaper som rekommenderas för din konfiguration. Till exempel:

![Resonances](img/calibrate-y.png)

```
Fitted shaper 'zv' frequency = 34.4 Hz (vibrations = 4.0%, smoothing ~= 0.132)
To avoid too much smoothing with 'zv', suggested max_accel <= 4500 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 0.0%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 41.4 Hz (vibrations = 0.0%, smoothing ~= 0.188)
To avoid too much smoothing with 'ei', suggested max_accel <= 3200 mm/sec^2
Fitted shaper '2hump_ei' frequency = 51.8 Hz (vibrations = 0.0%, smoothing ~= 0.201)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 61.8 Hz (vibrations = 0.0%, smoothing ~= 0.215)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2800 mm/sec^2
Recommended shaper is mzv @ 34.6 Hz
```

Den föreslagna konfigurationen kan läggas till i avsnittet `[input_shaper]` i `printer.cfg`, till exempel:

```
[input_shaper]
shaper_freq_x: ...
shaper_type_x: ...
shaper_freq_y: 34.6
shaper_type_y: mzv

[printer]
max_accel: 3000  # should not exceed the estimated max_accel for X and Y axes
```

Du kan också själv välja en annan konfiguration baserat på de genererade diagrammen: toppar i diagrammens spektrala effekttäthet motsvarar skrivarens resonansfrekvenser.

Observera att du även kan köra automatisk kalibrering av input shaper från Klipper [direkt](#input-shaper-auto-calibration), vilket kan vara praktiskt, till exempel för [omkalibrering](#input-shaper-re-calibration) av input shaper.

### Skrivare med rörlig bädd

Om skrivaren har rörlig bädd måste accelerometerns placering ändras mellan mätningarna av X- och Y-axlarna: mät X-axelns resonanser med accelerometern fäst vid verktygshuvudet och Y-axelns resonanser med accelerometern fäst vid bädden, vilket är den vanliga konfigurationen.

Du kan dock också ansluta två accelerometrar samtidigt, men ADXL345 måste anslutas till olika kort (exempelvis till ett RPi- och ett skrivar-MCU-kort) eller till två olika fysiska SPI-gränssnitt på samma kort (som sällan finns). De kan då konfigureras på följande sätt:

```
[adxl345 hotend]
# Assuming `hotend` chip is connected to an RPi
cs_pin: rpi:None

[adxl345 bed]
# Assuming `bed` chip is connected to a printer MCU board
cs_pin: ...  # Printer board SPI chip select (CS) pin

[resonance_tester]
# Assuming the typical setup of the bed slinger printer
accel_chip_x: adxl345 hotend
accel_chip_y: adxl345 bed
probe_points: ...
```

Två MPU:er kan dela en I2C-buss, men de **kan inte** mäta samtidigt eftersom I2C-bussen på 400 kbit/s inte är tillräckligt snabb. Den ena måste ha sitt AD0-stift neddraget till 0 V (adress 104) och den andra sitt AD0-stift uppdraget till 3,3 V (adress 105):

```
[mpu9250 hotend]
i2c_mcu: rpi
i2c_bus: i2c.1
i2c_address: 104 # This MPU has pin AD0 pulled low

[mpu9250 bed]
i2c_mcu: rpi
i2c_bus: i2c.1
i2c_address: 105 # This MPU has pin AD0 pulled high

[resonance_tester]
# Assuming the typical setup of the bed slinger printer
accel_chip_x: mpu9250 hotend
accel_chip_y: mpu9250 bed
probe_points: ...
```

[Testa varje MPU för sig innan båda ansluts till bussen, så blir felsökningen enklare.]

Kommandona `TEST_RESONANCES AXIS=X` och `TEST_RESONANCES AXIS=Y` använder då rätt accelerometer för respektive axel.

### Maximal utjämning

Tänk på att input shaper kan ge viss utjämning i utskrivna delar. Den automatiska trimningen med skriptet `calibrate_shaper.py` eller kommandot `SHAPER_CALIBRATE` försöker begränsa utjämningen och samtidigt minimera kvarvarande vibrationer. Ibland väljer den en mindre optimal shaper-frekvens, eller så föredrar du mindre utjämning på bekostnad av större kvarvarande vibrationer. Då kan du begränsa den maximala utjämningen från input shaper.

Betrakta följande resultat från den automatiska trimningen:

![Resonanser](img/calibrate-x.png)

```
Fitted shaper 'zv' frequency = 57.8 Hz (vibrations = 20.3%, smoothing ~= 0.053)
To avoid too much smoothing with 'zv', suggested max_accel <= 13000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.8 Hz (vibrations = 3.6%, smoothing ~= 0.168)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3600 mm/sec^2
Fitted shaper 'ei' frequency = 48.8 Hz (vibrations = 4.9%, smoothing ~= 0.135)
To avoid too much smoothing with 'ei', suggested max_accel <= 4400 mm/sec^2
Fitted shaper '2hump_ei' frequency = 45.2 Hz (vibrations = 0.1%, smoothing ~= 0.264)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2200 mm/sec^2
Fitted shaper '3hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.356)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 1500 mm/sec^2
Recommended shaper is 2hump_ei @ 45.2 Hz
```

Observera att rapporterade `smoothing`-värden är abstrakta, projicerade värden. De kan användas för att jämföra olika konfigurationer: ju högre värde, desto mer utjämning skapar en shaper. Värdena motsvarar dock inget verkligt mått på utjämning eftersom den faktiska utjämningen beror på parametrarna [`max_accel`](#selecting-max-accel) och `square_corner_velocity`. Skriv därför ut testutskrifter för att se hur mycket utjämning en vald konfiguration faktiskt ger.

I exemplet ovan är de föreslagna shaper-parametrarna inte dåliga, men om du vill få mindre utjämning på X-axeln kan du begränsa maximal shaper-utjämning med följande kommando:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```

Det begränsar utjämningen till värdet 0.2. Då kan du få följande resultat:

![Resonanser](img/calibrate-x-max-smoothing.png)

```
Fitted shaper 'zv' frequency = 55.4 Hz (vibrations = 19.7%, smoothing ~= 0.057)
To avoid too much smoothing with 'zv', suggested max_accel <= 12000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 3.6%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 48.2 Hz (vibrations = 4.8%, smoothing ~= 0.139)
To avoid too much smoothing with 'ei', suggested max_accel <= 4300 mm/sec^2
Fitted shaper '2hump_ei' frequency = 52.0 Hz (vibrations = 2.7%, smoothing ~= 0.200)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 72.6 Hz (vibrations = 1.4%, smoothing ~= 0.155)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 3900 mm/sec^2
Recommended shaper is 3hump_ei @ 72.6 Hz
```

Jämfört med de tidigare föreslagna parametrarna är vibrationerna något större, men utjämningen betydligt mindre, vilket tillåter högre maximal acceleration.

När du väljer parametern `max_smoothing` kan du använda försök och misstag. Prova några olika värden och se vilka resultat du får. Den faktiska utjämningen från input shaper beror främst på skrivarens lägsta resonansfrekvens: ju högre frekvens, desto mindre utjämning. En orealistiskt låg begärd utjämning ger därför mer ringing vid de lägsta resonansfrekvenserna, som vanligen syns tydligast i utskrifter. Kontrollera alltid att de projicerade kvarvarande vibrationerna som skriptet rapporterar inte är för höga.

Om du har valt ett bra `max_smoothing`-värde för båda axlarna kan det sparas i `printer.cfg` enligt följande:

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # an example
```

Om du i framtiden [kör om](#input-shaper-re-calibration) den automatiska input shaper-trimningen med kommandot `SHAPER_CALIBRATE` använder Klipper det sparade värdet `max_smoothing` som referens.

### Välja max_accel

Eftersom input shaper kan ge viss utjämning i utskrivna delar, särskilt vid höga accelerationer, måste du ändå välja ett `max_accel`-värde som inte ger för mycket utjämning. Kalibreringsskriptet uppskattar ett `max_accel`-värde som inte bör ge för mycket utjämning. Observera att `max_accel` som visas av kalibreringsskriptet endast är ett teoretiskt maximum där respektive shaper fortfarande kan fungera utan att skapa för mycket utjämning. Det är inte en rekommendation att använda denna acceleration för utskrift. Den högsta acceleration skrivaren klarar beror på dess mekaniska egenskaper och de använda stegmotorernas maximala vridmoment. Vi rekommenderar därför att `max_accel` i avsnittet `[printer]` inte överstiger de beräknade värdena för X- och Y-axeln, sannolikt med en försiktig säkerhetsmarginal.

Du kan också följa [den här](Resonance_Compensation.md#selecting-max_accel) delen av guiden för input shaper-trimning och skriva ut testmodellen för att välja parametern `max_accel` experimentellt.

Samma anmärkning gäller [automatisk kalibrering](#input-shaper-auto-calibration) av input shaper med kommandot `SHAPER_CALIBRATE`: även efter den automatiska kalibreringen måste du välja rätt `max_accel`-värde, och de föreslagna accelerationsgränserna tillämpas inte automatiskt.

Tänk på att den högsta accelerationen utan alltför mycket utjämning beror på `square_corner_velocity`. Den allmänna rekommendationen är att inte ändra standardvärdet 5.0, och det är det värde som används som standard av skriptet `calibrate_shaper.py`. Om du har ändrat värdet bör du ange det för skriptet med parametern `--square_corner_velocity=...`, till exempel

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --square_corner_velocity=10.0
```

så att rekommendationerna för högsta acceleration kan beräknas korrekt. Observera att kommandot `SHAPER_CALIBRATE` redan tar hänsyn till den konfigurerade parametern `square_corner_velocity`, så den behöver inte anges uttryckligen.

Om du kalibrerar shaper på nytt och den rapporterade utjämningen för den föreslagna shaper-konfigurationen är nästan densamma som vid föregående kalibrering, kan du hoppa över det här steget.

### Mäta resonanserna för Z-axeln

Att mäta resonanserna för Z-axeln liknar på många sätt mätning av resonanserna för X- och Y-axeln, men det finns några subtila skillnader. Precis som vid mätning av andra axlar måste en accelerometer vara monterad på Z-axelns rörliga delar – antingen på själva bädden (om bädden rör sig längs Z-axeln) eller på verktygshuvudet (om verktygshuvudet/gantryt rör sig längs Z). Du behöver lägga till lämplig chipkonfiguration i `printer.cfg` och även lägga till den i avsnittet `[resonance_tester]`, till exempel

```
[resonance_tester]
accel_chip_z: <accelerometer full name>
```

Kontrollera också att `probe_points` som konfigurerats i `[resonance_tester]` ger tillräckligt fritt utrymme för Z-axelns rörelser (20 mm ovanför bäddytan bör ge tillräckligt spelrum med standardparametrarna för testet).

Nästa övervägande är att Z-axeln vanligtvis når lägre högsta hastigheter och accelerationer än X- och Y-axeln. Testets standardparametrar tar hänsyn till detta och är betydligt mindre aggressiva, men det kan ändå vara nödvändigt att öka `max_z_accel` och `max_z_velocity`. Om de är konfigurerade i avsnittet `[printer]` ska du kontrollera att de är minst

```
[printer]
max_z_velocity: 20
max_z_accel: 1550
```

men bara under testet; sedan kan du vid behov återställa deras ursprungliga värden. Om du använder egna testparametrar för Z-axeln anger `TEST_RESONANCES` och `SHAPER_CALIBRATE` vid behov de lägsta nödvändiga gränserna för just ditt fall.

När alla ändringar i `printer.cfg` är gjorda startar du om Klipper och kör antingen

```
TEST_RESONANCES AXIS=Z
```

eller

```
SHAPER_CALIBRATE AXIS=Z
```

och fortsätter sedan på motsvarande sätt som för de andra axlarna. Efter kommandot `TEST_RESONANCES` kan du till exempel köra skriptet `calibrate_shaper.py` och få shaper-rekommendationer och ett diagram över resonansresponsen:

![Resonanser](img/calibrate-z.png)

Efter kalibreringen kan shaper-parametrarna sparas i `printer.cfg`, till exempel från exemplet ovan:

```
[input_shaper]
...
shaper_type_z: mzv
shaper_freq_z: 42.6
```

Eftersom Z-axelns rörelser är långsamma kan du också överväga mer aggressiva input shaper, till exempel

```
[input_shaper]
...
shaper_type_z: 2hump_ei
shaper_freq_z: 63.0
```

Om testet ger felaktiga resultat kan du försöka öka parametern `accel_per_hz_z` i `[resonance_tester]` från standardvärdet 15 till ett större värde mellan 20 och 30, till exempel

```
[resonance_tester]
accel_per_hz_z: 25
```

och upprepa testet. En ökning av värdet kräver sannolikt även att parametrarna `max_z_accel` och `max_z_velocity` ökas. Du kan köra kommandot `TEST_RESONANCES AXIS=Z` för att få de lägsta nödvändiga värdena.

Om du däremot inte kan mäta resonanserna för Z-axeln kan du överväga att bara använda

```
[input_shaper]
...
shaper_type_z: 3hump_ei
shaper_freq_z: 65
```

som ett acceptabelt, allsidigt val, eftersom utjämning av Z-axelns rörelser inte är särskilt viktig.

### Otillförlitliga mätningar av resonansfrekvenser

Resonansmätningarna kan ibland ge felaktiga resultat, vilket leder till felaktiga förslag för input shaper. Det kan bero på många saker, bland annat fläktar som körs på verktygshuvudet, fel placering eller icke-styv montering av accelerometern samt mekaniska problem som lösa remmar eller en kärvande eller ojämn axel. Tänk på att alla fläktar bör vara avstängda under resonanstestet, särskilt bullriga fläktar, och att accelerometern ska vara styvt monterad på motsvarande rörliga del (till exempel på själva bädden på en skrivare med rörlig bädd eller på skrivarens extruder, inte vagnen; vissa får bättre resultat genom att montera accelerometern på själva munstycket). Vad gäller mekaniska problem bör du undersöka om det finns fel som kan åtgärdas på en rörlig axel (till exempel rengöra och smörja linjärstyrningar och justera spänningen för V-spårhjulen korrekt). Om inget av detta hjälper kan du prova andra shaper från den skapade listan än den som rekommenderas som standard.

### Testa anpassade axlar

Kommandot `TEST_RESONANCES` stöder anpassade axlar. Det är inte särskilt användbart för kalibrering av input shaper, men kan användas för att studera skrivarens resonanser på djupet och exempelvis kontrollera remspänningen.

Kör följande för att kontrollera remspänningen på CoreXY-skrivare:

```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```

och använd `graph_accelerometer.py` för att bearbeta de skapade filerna, till exempel

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

som skapar `/tmp/resonances.png` med en jämförelse av resonanserna.

Kör följande för Delta-skrivare med standardplaceringen av tornen (torn A ~= 210 grader, B ~= 330 grader och C ~= 90 grader):

```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```

och använd sedan samma kommando

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

för att skapa `/tmp/resonances.png` med en jämförelse av resonanserna.

## Automatisk kalibrering av Input Shaper

Förutom att välja lämpliga parametrar för funktionen input shaper manuellt går det att köra automatisk trimning av input shaper direkt från Klipper. Kör följande kommando i OctoPrint-terminalen:

```
SHAPER_CALIBRATE
```

Det kör hela testet för båda axlarna och skapar CSV-utdata (`/tmp/calibration_data_*.csv` som standard) för frekvensresponsen och de föreslagna input shaper-konfigurationerna. I OctoPrint-konsolen visas också de föreslagna frekvenserna för varje input shaper samt vilken input shaper som rekommenderas för din konfiguration. Exempel:

```
Calculating the best input shaper parameters for y axis
Fitted shaper 'zv' frequency = 39.0 Hz (vibrations = 13.2%, smoothing ~= 0.105)
To avoid too much smoothing with 'zv', suggested max_accel <= 5900 mm/sec^2
Fitted shaper 'mzv' frequency = 36.8 Hz (vibrations = 1.7%, smoothing ~= 0.150)
To avoid too much smoothing with 'mzv', suggested max_accel <= 4000 mm/sec^2
Fitted shaper 'ei' frequency = 36.6 Hz (vibrations = 2.2%, smoothing ~= 0.240)
To avoid too much smoothing with 'ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '2hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.234)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '3hump_ei' frequency = 59.0 Hz (vibrations = 0.0%, smoothing ~= 0.235)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2500 mm/sec^2
Recommended shaper_type_y = mzv, shaper_freq_y = 36.8 Hz
```

Om du godtar de föreslagna parametrarna kan du nu köra `SAVE_CONFIG` för att spara dem och starta om Klipper. Observera att detta inte uppdaterar värdet `max_accel` i avsnittet `[printer]`. Du bör uppdatera det manuellt enligt övervägandena i avsnittet [Välja max_accel](#selecting-max_accel).

Om skrivaren har en rörlig bädd kan du ange vilken axel som ska testas, så att du kan flytta accelerometerns monteringspunkt mellan testerna (som standard utförs testet för båda axlarna):

```
SHAPER_CALIBRATE AXIS=Y
```

Du kan köra `SAVE_CONFIG` två gånger – efter kalibreringen av respektive axel.

Om du däremot har anslutit två accelerometrar samtidigt kör du bara `SHAPER_CALIBRATE` utan att ange axel, för att kalibrera input shaper för båda axlarna i ett steg.

### Omkalibrering av Input Shaper

Kommandot `SHAPER_CALIBRATE` kan även användas för att omkalibrera input shaper senare, särskilt om skrivaren har ändrats på ett sätt som kan påverka kinematiken. Du kan antingen köra om hela kalibreringen med `SHAPER_CALIBRATE` eller begränsa den automatiska kalibreringen till en enda axel genom att ange parametern `AXIS=`, till exempel

```
SHAPER_CALIBRATE AXIS=X
```

**Varning!** Det är inte lämpligt att köra automatisk shaper-kalibrering mycket ofta (till exempel före varje utskrift eller varje dag). För att bestämma resonansfrekvenser skapar den automatiska kalibreringen kraftiga vibrationer på varje axel. 3D-skrivare är generellt inte konstruerade för långvarig exponering för vibrationer nära resonansfrekvenserna. Det kan öka slitaget på skrivarens komponenter och förkorta deras livslängd. Risken ökar också för att delar skruvas loss eller lossnar. Kontrollera alltid efter varje automatisk trimning att alla delar av skrivaren (även sådana som normalt inte rör sig) sitter ordentligt fast.

På grund av visst mätbrus kan trimningsresultaten också skilja sig något mellan kalibreringskörningar. Bruset förväntas dock inte påverka utskriftskvaliteten särskilt mycket. Det rekommenderas ändå att du dubbelkontrollerar de föreslagna parametrarna och skriver ut några testutskrifter innan du använder dem för att bekräfta att de fungerar bra.

## Offlinebearbetning av accelerometerdata

Det går att skapa rådata från accelerometern och bearbeta dem offline (till exempel på en värddator), exempelvis för att hitta resonanser. Kör följande kommandon i OctoPrint-terminalen:

```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```

och ignorera eventuella fel för kommandot `SET_INPUT_SHAPER`. Ange önskad testaxel för kommandot `TEST_RESONANCES`. Rådata skrivs till katalogen `/tmp` på RPi:n.

Rådata kan också hämtas genom att köra kommandot `ACCELEROMETER_MEASURE` två gånger under normal skrivaraktivitet – först för att starta mätningarna och sedan för att stoppa dem och skriva utdatafilen. Mer information finns i [G-koder](G-Codes.md#adxl345).

Data kan sedan bearbetas med följande skript: `scripts/graph_accelerometer.py` och `scripts/calibrate_shaper.py`. Båda tar emot en eller flera råa CSV-filer som indata, beroende på läge. Skriptet graph_accelerometer.py har flera driftslägen:

* rita råa accelerometerdata (använd parametern `-r`), endast 1 indatafil stöds;
* rita en frekvensrespons (inga extra parametrar krävs); om flera indatafiler anges beräknas den genomsnittliga frekvensresponsen;
* jämföra frekvensresponsen mellan flera indatafiler (använd parametern `-c`); du kan dessutom ange vilken accelerometeraxel som ska användas med parametern `-a x`, `-a y` eller `-a z` (om ingen anges används summan av vibrationerna för alla axlar);
* rita spektrogrammet (använd parametern `-s`), endast 1 indatafil stöds; du kan dessutom ange vilken accelerometeraxel som ska användas med parametern `-a x`, `-a y` eller `-a z` (om ingen anges används summan av vibrationerna för alla axlar).

Observera att skriptet graph_accelerometer.py endast stöder filerna raw_data\*.csv, inte filerna resonances\*.csv eller calibration_data\*.csv.

Exempel:

```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```

ritar jämförelsen av flera `/tmp/raw_data_x_*.csv`-filer för Z-axeln till filen `/tmp/resonances_x.png`.

Skriptet shaper_calibrate.py accepterar 1 eller flera indatafiler och kan automatiskt trimma input shaper och föreslå de bästa parametrarna som fungerar väl för alla angivna indatafiler. Det skriver de föreslagna parametrarna till konsolen och kan dessutom skapa diagrammet om parametern `-o output.png` anges, eller CSV-filen om parametern `-c output.csv` anges.

Flera indatafiler till skriptet shaper_calibrate.py kan vara användbara vid avancerad trimning av input shaper, till exempel:

* Kör `TEST_RESONANCES AXIS=X OUTPUT=raw_data` (och för `Y`-axeln) två gånger för en enskild axel på en skrivare med rörlig bädd: första gången med accelerometern fäst vid verktygshuvudet och andra gången med accelerometern fäst vid bädden, för att upptäcka korsresonanser mellan axlarna och försöka kompensera för dem med input shaper.
* Kör `TEST_RESONANCES AXIS=Y OUTPUT=raw_data` två gånger på en skrivare med rörlig bädd, en gång med en glasbädd och en gång med en magnetisk yta (som är lättare), för att hitta input shaper-parametrar som fungerar väl för alla konfigurationer av utskriftsytan.
* Kombinera resonansdata från flera testpunkter.
* Kombinera resonansdata från två axlar (till exempel på en skrivare med rörlig bädd för att konfigurera X-axelns input_shaper från både X- och Y-axlarnas resonanser så att vibrationer från *bädden* kompenseras om munstycket "fastnar" i en utskrift när det rör sig i X-axelns riktning).
