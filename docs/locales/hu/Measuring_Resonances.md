# Rezonanciák mérése

Klipper has built-in support for the ADXL345, MPU-9250 and LIS2DW compatible accelerometers which can be used to measure resonance frequencies of the printer for different axes, and auto-tune [input shapers](Resonance_Compensation.md) to compensate for resonances. Note that using accelerometers requires some soldering and crimping. The ADXL345/LIS2DW can be connected to the SPI interface of a Raspberry Pi or MCU board (it needs to be reasonably fast). The MPU family can be connected to the I2C interface of a Raspberry Pi directly, or to an I2C interface of an MCU board that supports 400kbit/s *fast mode* in Klipper.

When sourcing accelerometers, be aware that there are a variety of different PCB board designs and different clones of them. If it is going to be connected to a 5V printer MCU ensure it has a voltage regulator and level shifters.

For ADXL345s/LIS2DWs, make sure that the board supports SPI mode (a small number of boards appear to be hard-configured for I2C by pulling SDO to GND).

For MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500s there are also a variety of board designs and clones with different I2C pull-up resistors which will need supplementing.

## MCUs with Klipper I2C *fast-mode* Support

| MCU Family | MCU(s) Tested | MCU(s) with Support |
| :-: | :-- | :-- |
| Raspberry Pi | 3B+, Pico | 3A, 3A+, 3B, 4 |
| AVR ATmega | ATmega328p | ATmega32u4, ATmega128, ATmega168, ATmega328, ATmega644p, ATmega1280, ATmega1284, ATmega2560 |
| AVR AT90 | - | AT90usb646, AT90usb1286 |

## Telepítési utasítások

### Vezetékek

An ethernet cable with shielded twisted pairs (cat5e or better) is recommended for signal integrity over a long distance. If you still experience signal integrity issues (SPI/I2C errors):

- Double check the wiring with a digital multimeter for:
   - Correct connections when turned off (continuity)
   - Correct power and ground voltages
- I2C only:
   - Check the SCL and SDA lines' resistances to 3.3V are in the range of 900 ohms to 1.8K
   - For full technical details consult [chapter 7 of the I2C-bus specification and user manual UM10204](https://www.pololu.com/file/0J435/UM10204.pdf) for *fast-mode*
- Shorten the cable

Connect ethernet cable shielding only to the MCU board/Pi ground.

***Kétszer is ellenőrizd a vezetékeket a bekapcsolás előtt, hogy elkerüld az MCU/Raspberry Pi vagy a gyorsulásmérő károsodását.***

### SPI Gyorsulásmérők

Suggested twisted pair order for three twisted pairs:

```
GND+MISO
3.3V+MOSI
SCLK+CS
```

Note that unlike a cable shield, GND must be connected at both ends.

#### ADXL345

##### Közvetlenül a Raspberry Pi-re

**Note: Many MCUs will work with an ADXL345 in SPI mode (e.g. Pi Pico), wiring and configuration will vary according to your specific board and available pins.**

Az ADXL345-öt SPI-n keresztül kell csatlakoztatnod a Raspberry Pi-hez. Vedd figyelembe, hogy az ADXL345 dokumentációja által javasolt I2C kapcsolatnak túl alacsony az adatforgalmi képessége, és **nem fog működni**. Az ajánlott kapcsolási séma:

| ADXL345 tű | RPi tű | RPi tű név |
| :-: | :-: | :-: |
| 3V3 (or VCC) | 01 | 3.3V DC feszültség |
| GND | 06 | Föld |
| CS | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

Fritzing kapcsolási rajzok néhány ADXL345 laphoz:

![ADXL345-Rpi](img/adxl345-fritzing.png)

##### Raspberry Pi Pico használata

Az ADXL345-öt csatlakoztathatod a Raspberry Pi Pico számítógéphez, majd a Pico számítógépet USB-n keresztül csatlakoztathatod a Raspberry Pi számítógéphez. Ez megkönnyíti a gyorsulásmérő újrafelhasználását más Klipper eszközökön, mivel GPIO helyett USB-n keresztül csatlakozik. A Pico nem rendelkezik nagy feldolgozási teljesítménnyel, ezért győződj meg róla, hogy csak a gyorsulásmérőt futtatja, és nem végez más feladatokat.

Az RPi károsodásának elkerülése érdekében ügyelj arra, hogy az ADXL345-öt csak 3,3 V-hoz csatlakoztasd. A tábla elrendezésétől függően előfordulhat, hogy egy feszváltó jelen van, ami veszélyessé teszi az 5V-ot az RPi számára.

| ADXL345 tű | Pico tű | Pico tű neve |
| :-: | :-: | :-: |
| 3V3 (or VCC) | 36 | 3.3V DC feszültség |
| GND | 38 | Föld |
| CS | 2 | GP1 (SPI0_CSn) |
| SDO | 1 | GP0 (SPI0_RX) |
| SDA | 5 | GP3 (SPI0_TX) |
| SCL | 4 | GP2 (SPI0_SCK) |

Néhány ADXL345 lap kapcsolási rajzai:

![ADXL345-Pico](img/adxl345-pico.png)

### I2C Gyorsulásmérők

Suggested twisted pair order for three pairs (preferred):

```
3.3V+GND
SDA+GND
SCL+GND
```

or for two pairs:

```
3.3V+SDA
GND+SCL
```

Note that unlike a cable shield, any GND(s) should be connected at both ends.

#### MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500

These accelerometers have been tested to work over I2C on the RPi, RP2040 (Pico) and AVR at 400kbit/s (*fast mode*). Some MPU accelerometer modules include pull-ups, but some are too large at 10K and must be changed or supplemented by smaller parallel resistors.

Ajánlott csatlakozási séma az I2C-hez a Raspberry Pi-n:

| MPU-9250 tű | RPi tű | RPi tű név |
| :-: | :-: | :-: |
| VCC | 01 | 3.3v DC feszültség |
| GND | 09 | Föld |
| SDA | 03 | GPIO02 (SDA1) |
| SCL | 05 | GPIO03 (SCL1) |

The RPi has buit-in 1.8K pull-ups on both SCL and SDA.

![MPU-9250 connected to Pi](img/mpu9250-PI-fritzing.png)

Recommended connection scheme for I2C (i2c0a) on the RP2040:

| MPU-9250 tű | RP2040 tű | RP2040 pin name |
| :-: | :-: | :-: |
| VCC | 36 | 3v3 |
| GND | 38 | Föld |
| SDA | 01 | GP0 (I2C0 SDA) |
| SCL | 02 | GP1 (I2C0 SCL) |

The Pico does not include any built-in I2C pull-up resistors.

![MPU-9250 connected to Pico](img/mpu9250-PICO-fritzing.png)

##### Recommended connection scheme for I2C(TWI) on the AVR ATmega328P Arduino Nano:

| MPU-9250 tű | Atmega328P TQFP32 pin | Atmega328P pin name | Arduino Nano pin |
| :-: | :-: | :-: | :-: |
| VCC | 39 | - | - |
| GND | 38 | Föld | GND |
| SDA | 27 | SDA | A4 |
| SCL | 28 | SCL | A5 |

The Arduino Nano does not include any built-in pull-up resistors nor a 3.3V power pin.

### A gyorsulásmérő felszerelése

A gyorsulásmérőt a nyomtatófejhez kell csatlakoztatni. Meg kell tervezni egy megfelelő rögzítést, amely illeszkedik a saját 3D nyomtatódhoz. A gyorsulásmérő tengelyeit jobb a nyomtató tengelyeihez igazítani (de ha ez kényelmesebbé teszi, a tengelyek felcserélhetők - azaz nem kell az X tengelyt X-hez igazítani, és így tovább. Akkor is jónak kell lennie, ha a gyorsulásmérő Z tengelye a nyomtató X tengelye, stb).

Példa az ADXL345 SmartEffectorra történő felszerelésére:

![ADXL345 on SmartEffector](img/adxl345-mount.jpg)

Vedd figyelembe, hogy egy tárgyasztal csúsztatós nyomtatónál 2 rögzítést kell tervezni: egyet a nyomtatófejhez és egyet a tárgyasztalhoz, és a méréseket kétszer kell elvégezni. További részletekért lásd a megfelelő [szakaszt](#bed-slinger-nyomtatok).

**Figyelem:** győződj meg arról, hogy a gyorsulásmérő és a helyére rögzítő csavarok nem érnek a nyomtató fém részeihez. Alapvetően a rögzítést úgy kell kialakítani, hogy biztosítsa a gyorsulásmérő elektromos szigetelését a nyomtató keretétől. Ennek elmulasztása földhurkot hozhat létre a rendszerben, ami károsíthatja az elektronikát.

### Szoftver telepítése

Vedd figyelembe, hogy a rezonanciamérések és a shaper automatikus kalibrálása további, alapértelmezés szerint nem telepített szoftverfüggőségeket igényel. Először futtasd a Raspberry Pi számítógépen a következő parancsokat:

```
sudo apt update
sudo apt install python3-numpy python3-matplotlib libatlas-base-dev
```

Ezután a NumPy telepítéséhez a Klipper környezetbe futtassuk a parancsot:

```
~/klippy-env/bin/pip install -v numpy
```

Vedd figyelembe, hogy a CPU teljesítményétől függően ez *sok* időt vehet igénybe, akár 10-20 percet is. Legyél türelmes, és várd meg a telepítés befejezését. Bizonyos esetekben, ha a kártyán túl kevés RAM van, a telepítés meghiúsulhat, és engedélyezned kell a swapot.

#### ADXL345 konfigurálása RPi-vel

First, check and follow the instructions in the [RPi Microcontroller document](RPi_microcontroller.md) to setup the "linux mcu" on the Raspberry Pi. This will configure a second Klipper instance that runs on your Pi.

Győződjünk meg róla, hogy a Linux SPI-illesztőprogram engedélyezve van a `sudo raspi-config` futtatásával és az SPI engedélyezésével az "Interfacing options" menüben.

Adja hozzá a következőket a printer.cfg fájlhoz:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20 # egy példa
```

Javasoljuk, hogy 1 mérőponttal kezd, a nyomtatási tárgyasztal közepén, kissé felette.

#### ADXL345 konfigurálása Pi Pico segítségével

##### A Pico firmware égetése

A Raspberry Pi-n fordítsd le a firmware-t a Pico számára.

```
cd ~/klipper
make clean
make menuconfig
```

![Pico menuconfig](img/klipper_pico_menuconfig.png)

Most, miközben lenyomva tartjuk a `BOOTSEL` gombot a Pico-n, csatlakoztassuk a Pico-t a Raspberry Pi-hez USB-n keresztül. Fordítsuk le és égessük a firmware-t.

```
make flash FLASH_DEVICE=first
```

Ha ez nem sikerül, a rendszer megmondja, hogy melyik `FLASH_DEVICE` címet kell használni. Ebben a példában ez a `make flash FLASH_DEVICE=2e8a:0003`. ![Égető eszköz meghatározása](img/flash_rp2040_FLASH_DEVICE.png)

##### A kapcsolat konfigurálása

A Pico most újraindul az új firmware-vel, és soros eszközként fog megjelenni. Keresd meg a Pico soros eszközét az `ls /dev/serial/by-id/*` segítségével. Most hozzáadhatsz egy `adxl.cfg` fájlt a következő beállításokkal:

```
[mcu adxl]
# Változtassuk meg a <mySerial>-t arra, amit fentebb találtunk. Például,
# usb-Klipper_rp2040_E661640843545B2E-if00
serial: /dev/serial/by-id/usb-Klipper_rp2040_<mySerial>.

[adxl345]
cs_pin: adxl:gpio1
spi_bus: spi0a
axes_map: x,z,y

[resonance_tester]
accel_chip: adxl345
probe_points:
    # Valahol a nyomtatóágy közepe felett
    147,154, 20

[output_pin power_mode] # Javítja a teljesítmény stabilitását
pin: adxl:gpio23
```

Ha az ADXL345 konfigurációját külön fájlban állítod be, ahogy fentebb látható, akkor a `printer.cfg` fájlt is módosítani kell, hogy tartalmazza ezt:

```
[include adxl.cfg] # Kommenteld ki ezt, amikor lekapcsolod a gyorsulásmérőt.
```

Indítsd újra a Klippert a `RESTART` paranccsal.

#### Configure LIS2DW series

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

#### Az MPU-6000/9000 sorozat konfigurálása RPi-vel

Az MPU-9250 esetében győződj meg róla, hogy a Linux I2C illesztőprogram engedélyezve van, és az átviteli sebesség 400000-re van állítva (további részletekért lásd az [I2C engedélyezése](RPi_microcontroller.md#optional-enabling-i2c) részt). Ezután adjuk hozzá a következőket a printer.cfg fájlhoz:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[mpu9250]
i2c_mcu: rpi
i2c_bus: i2c.1

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # egy példa
```

#### Configure MPU-9520 Compatibles With Pico

Pico I2C is set to 400000 on default. Simply add the following to the printer.cfg:

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

#### Configure MPU-9520 Compatibles with AVR

AVR I2C will be set to 400000 by the mpu9250 option. Simply add the following to the printer.cfg:

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

Indítsd újra a Klippert a `RESTART` paranccsal.

## A rezonanciák mérése

### A beállítás ellenőrzése

Most már tesztelheted a kapcsolatot.

- A "nem tárgyasztalt érintő" (pl. egy gyorsulásmérő), az Octoprintbe írd be az `ACCELEROMETER_QUERY` parancsot
- A "bed-slingers" (pl. egynél több gyorsulásmérő) esetében írd be az `ACCELEROMETER_QUERY CHIP=<chip>` ahol `<chip>` a chip neve a beírt formában, pl. `CHIP=bed` (lásd: [bed-slinger nyomtatók](#bed-slinger-nyomtatok)) az összes telepített gyorsulásmérő chip-hez.

A gyorsulásmérő aktuális méréseit kell látnia, beleértve a szabadesés gyorsulását is, pl.

```
Visszahívás: // adxl345 értékek (x, y, z): 470.719200, 941.438400, 9728.196800
```

Ha a következő hibát kapod: `Invalid adxl345 id (got xx vs e5)`, ahol `xx` egy másik azonosító, azonnal próbáld meg újra. Az SPI inicializálásával van probléma. Ha továbbra is hibát kapsz, az az ADXL345-tel való kapcsolódási problémára, vagy a hibás érzékelőre utal. Duplán ellenőrizd a tápellátást, a vezetékezést (hogy megfelel-e a kapcsolási rajzoknak, nincs-e törött vagy laza vezeték stb.) és a forrasztás minőségét.

**If you are using a MPU-9250 compatible accelerometer and it shows up as `mpu-unknown`, use with caution! They are probably refurbished chips!**

Ezután próbáld meg futtatni a `MEASURE_AXES_NOISE` parancsot az Octoprint-ben, így kaphatsz néhány alapszámot a gyorsulásmérő zajára a tengelyeken (valahol a ~1-100-as tartományban kell lennie). A túl magas tengelyzaj (pl. 1000 és több) az érzékelő problémáira, a tápellátásával kapcsolatos problémákra vagy a 3D nyomtató túl zajos, kiegyensúlyozatlan ventilátoraira utalhat.

### A rezonanciák mérése

Most már lefuttathatsz néhány valós tesztet. Futtasd a következő parancsot:

```
TEST_RESONANCES AXIS=X
```

Vedd figyelembe, hogy az X tengelyen rezgéseket hoz létre. A bemeneti alakítást is letiltja, ha az korábban engedélyezve volt, mivel a rezonancia tesztelés nem érvényes a bemeneti alakító engedélyezésével.

**Figyelem!** Az első alkalommal mindenképpen figyeld meg a nyomtatót, hogy a rezgések ne legyenek túl hevesek (az `M112` paranccsal vészhelyzet esetén megszakítható a teszt; remélhetőleg azonban erre nem kerül sor). Ha a rezgések mégis túl erősek lesznek, megpróbálhatsz az alapértelmezettnél alacsonyabb értéket megadni az `accel_per_hz` paraméterhez a `[resonance_tester]` szakaszban, pl.

```
[resonance_tester]
accel_chip: adxl345
accel_per_hz: 50    # alapértelmezett a 75
probe_points: ...
```

Ha az X tengelyen működik, futtasd az Y tengelyen is:

```
TEST_RESONANCES AXIS=Y
```

Ez 2 CSV fájlt fog létrehozni (`/tmp/resonances_x_*.csv` és `/tmp/resonances_y_*.csv`) Ezeket a fájlokat a Raspberry Pi-n lévő önálló szkript segítségével lehet feldolgozni. Ehhez futtasd a következő parancsokat:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

Ez a szkript létrehozza a `/tmp/shaper_calibrate_x.png` és `/tmp/shaper_calibrate_y.png` diagramokat a frekvenciaválaszokkal. Az egyes bemeneti shaperek javasolt frekvenciáit is megkapja, valamint azt, hogy melyik bemeneti shaper ajánlott a te beállításodhoz. Például:

![Resonances](img/calibrate-y.png)

```
Illesztett alakító 'zv' frekvencia = 34,4 Hz (rezgések = 4,0%, simítás ~= 0,132)
A túl nagy simítás elkerülése érdekében a 'zv', javasolt max_accel <= 4500 mm/sec^2
Alkalmazott alakító 'mzv' frekvencia = 34,6 Hz (rezgések = 0,0%, simítás ~= 0,170)
A túl nagy simítás elkerülése érdekében az 'mzv' esetében javasolt max_accel <= 3500 mm/sec^2
Alkalmazott alakító 'ei' frekvencia = 41,4 Hz (rezgések = 0,0%, simítás ~= 0,188)
A túl nagy simítás elkerülése érdekében az 'ei', javasolt max_accel <= 3200 mm/sec^2
Alkalmazott alakító '2hump_ei' frekvencia = 51,8 Hz (rezgések = 0,0%, simítás ~= 0,201)
A túl nagy simítás elkerülése érdekében a '2hump_ei' esetében javasolt max_accel <= 3000 mm/sec^2
Alkalmazott alakító '3hump_ei' frekvencia = 61,8 Hz (rezgések = 0,0%, simítás ~= 0,215)
A túl nagy simítás elkerülése érdekében a '3hump_ei' esetében javasolt max_accel <= 2800 mm/sec^2
Az ajánlott shaper az mzv @ 34,6 Hz.
```

A javasolt konfiguráció hozzáadható az `[input_shaper]` szakaszhoz a `printer.cfg` részben, például:

```
[input_shaper]
shaper_freq_x: ...
shaper_type_x: ...
shaper_freq_y: 34.6
shaper_type_y: mzv

[printer]
max_accel: 3000 # nem haladhatja meg a becsült max_accel értéket az X és Y tengelyeknél.
```

vagy választhatsz más konfigurációt is a generált diagramok alapján: a diagramokon a teljesítményspektrális sűrűség csúcsai megfelelnek a nyomtató rezonanciafrekvenciáinak.

Megjegyzendő, hogy alternatívaként a bemeneti alakító automatikus kalibrációját a Klipperből [közvetlenül](#input-shaper-auto-calibration) is futtathatod, ami például a bemeneti alakító [re-kalibrációjához](#input-shaper-re-calibration) lehet hasznos.

### Bed-slinger nyomtatók

Ha a nyomtatód tárgyasztala Y tengelyen van, akkor meg kell változtatnod a gyorsulásmérő helyét az X és Y tengelyek mérései között: az X tengely rezonanciáit a nyomtatófejre szerelt gyorsulásmérővel, az Y tengely rezonanciáit pedig a tárgyasztalra szerelt gyorsulásmérővel kell mérned (a szokásos nyomtató beállítással).

However, you can also connect two accelerometers simultaneously, though the ADXL345 must be connected to different boards (say, to an RPi and printer MCU board), or to two different physical SPI interfaces on the same board (rarely available). Then they can be configured in the following manner:

```
[adxl345 hotend]
# Feltételezve, hogy a `hotend` chip egy RPi-hez van csatlakoztatva.
cs_pin: rpi:None

[adxl345 bed]
# Feltételezve, hogy a `bed` chip egy nyomtató MCU lapkához van csatlakoztatva.
cs_pin: ...  # nyomtató alaplap SPI chip kiválasztó (CS) tűje

[resonance_tester]
# Feltételezve az Y tárgyasztalos nyomtató tipikus beállítását.
accel_chip_x: adxl345 hotend
accel_chip_y: adxl345 bed
probe_points: ...
```

Two MPUs can share one I2C bus, but they **cannot** measure simultaneously as the 400kbit/s I2C bus is not fast enough. One must have its AD0 pin pulled-down to 0V (address 104) and the other its AD0 pin pulled-up to 3.3V (address 105):

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

[Test with each MPU individually before connecting both to the bus for easy debugging.]

Ekkor a `TEST_RESONANCES AXIS=X` és `TEST_RESONANCES AXIS=Y` parancsok a megfelelő gyorsulásmérőt fogják használni minden tengelyhez.

### Max simítás

Ne feledd, hogy a bemeneti formázó simítást hozhat létre az alkatrészekben. A `calibrate_shaper.py` szkript vagy `SHAPER_CALIBRATE` parancs által végrehajtott bemeneti formázó automatikus hangolása nem súlyosbítja a simítást, ugyanakkor megpróbálja minimalizálni az ebből eredő rezgéseket. Néha az alakformáló frekvencia optimálistól elmaradó választását hozhatja, vagy talán egyszerűen csak kevésbé simítja az alkatrészeket a nagyobb fennmaradó rezgések rovására. Ezekben az esetekben kérheted a bemeneti formázó maximális simításának korlátozását.

Nézzük meg az automatikus hangolás következő eredményeit:

![Resonances](img/calibrate-x.png)

```
Illesztett alakító 'zv' frekvencia = 57,8 Hz (rezgések = 20,3%, simítás ~= 0,053)
A túl nagy simítás elkerülése érdekében a 'zv', javasolt max_accel <= 13000 mm/sec^2
Alkalmazott alakító 'mzv' frekvencia = 34,8 Hz (rezgések = 3,6%, simítás ~= 0,168)
A túl nagy simítás elkerülése érdekében az 'mzv' esetében javasolt max_accel <= 3600 mm/sec^2
Alkalmazott alakító 'ei' frekvencia = 48,8 Hz (rezgések = 4,9%, simítás ~= 0,135)
A túl nagy simítás elkerülése érdekében az 'ei', javasolt max_accel <= 4400 mm/sec^2
Alkalmazott alakító '2hump_ei' frekvencia = 45,2 Hz (rezgések = 0,1%, simítás ~= 0,264)
A túl nagy simítás elkerülése érdekében a '2hump_ei' esetében javasolt max_accel <= 2200 mm/sec^2
Alkalmazott alakító '3hump_ei' frekvencia = 48,0 Hz (rezgések = 0,0%, simítás ~= 0,356)
A túl nagy simítás elkerülése érdekében a '3hump_ei' esetében javasolt max_accel <= 1500 mm/sec^2
Az ajánlott alakító 2hump_ei @ 45,2 Hz.
```

Vedd figyelembe, hogy a bejelentett `simítás` értékek absztrakt vetített értékek. Ezek az értékek különböző konfigurációk összehasonlítására használhatók: minél magasabb az érték, annál nagyobb simítást hoz létre a formázó. Ezek a simítási értékek azonban nem jelentik a simítás valódi mértékét, mivel a tényleges simítás a [`max_accel`](#a-max_accel-kivalasztasa) és `square_corner_velocity` paraméterektől függ. Ezért érdemes néhány tesztnyomatot nyomtatni, hogy lássuk, pontosan mekkora simítást hoz létre a kiválasztott konfiguráció.

A fenti példában a javasolt alakító paraméterek nem rosszak, de mi van akkor, ha az X tengelyen kevesebb simítást szeretnél elérni? Megpróbálhatod korlátozni a maximális alakító simítást a következő paranccsal:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```

amely a simítást 0,2 pontszámra korlátozza. Most a következő eredményt kaphatod:

![Resonances](img/calibrate-x-max-smoothing.png)

```
Illesztett alakító 'zv' frekvencia = 55,4 Hz (rezgések = 19,7%, simítás ~= 0,057)
A túl nagy simítás elkerülése érdekében a 'zv', javasolt max_accel <= 12000 mm/sec^2
Alkalmazott alakító 'mzv' frekvencia = 34,6 Hz (rezgések = 3,6%, simítás ~= 0,170)
A túl nagy simítás elkerülése érdekében az 'mzv' esetében javasolt max_accel <= 3500 mm/sec^2
Alkalmazott alakító 'ei' frekvencia = 48,2 Hz (rezgések = 4,8%, simítás ~= 0,139)
A túl nagy simítás elkerülése érdekében az 'ei' esetében javasolt max_accel <= 4300 mm/sec^2
Alkalmazott alakító '2hump_ei' frekvencia = 52,0 Hz (rezgések = 2,7%, simítás ~= 0,200)
A túl nagy simítás elkerülése érdekében a '2hump_ei' esetében javasolt max_accel <= 3000 mm/sec^2
Alkalmazott alakító '3hump_ei' frekvencia = 72,6 Hz (rezgések = 1,4%, simítás ~= 0,155)
A túl nagy simítás elkerülése érdekében a '3hump_ei' esetében javasolt max_accel <= 3900 mm/sec^2
Az ajánlott alakító 3hump_ei @ 72,6 Hz.
```

Ha összehasonlítjuk a korábban javasolt paraméterekkel, a rezgések kicsit nagyobbak, de a simítás lényegesen kisebb, mint korábban, ami nagyobb maximális gyorsulást tesz lehetővé.

A `max_smoothing` paraméter kiválasztásakor a próbálgatás és a tévedés módszerét alkalmazhatjuk. Próbálj ki néhány különböző értéket, és nézd meg, milyen eredményeket kapsz. Vedd figyelembe, hogy a bemeneti alakító által előállított tényleges simítás elsősorban a nyomtató legalacsonyabb rezonanciafrekvenciájától függ: minél magasabb a legalacsonyabb rezonancia frekvenciája - annál kisebb a simítás. Ezért ha azt kéred a parancsfájltól, hogy a bemeneti alakító olyan konfigurációt keressen meg, amely irreálisan kis simítással rendelkezik, akkor ez a legalacsonyabb rezonanciafrekvenciákon (amelyek jellemzően a nyomatokon is jobban láthatóak) megnövekedett rezgés árán fog történni. Ezért mindig ellenőrizd kétszeresen a szkript által jelzett vetített maradó rezgéseket, és győződj meg róla, hogy azok nem túl magasak.

Ha mindkét tengelyhez jó `max_smoothing` értéket választasz, akkor azt a `printer.cfg` állományban tárolhatod a következő módon

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # egy példa
```

Ezután, ha a jövőben [újraindítod](#bemeneti-formazo-ujrakalibralasa) a bemeneti alakító automatikus hangolását a `SHAPER_CALIBRATE` Klipper parancs segítségével, akkor a tárolt `max_smoothing` értéket fogja referenciaként használni.

### A max_accel kiválasztása

Mivel a bemeneti alakító némi simítást okozhat az elemekben, különösen nagy gyorsulásoknál, továbbra is meg kell választani a `max_accel` értéket, amely nem okoz túl nagy simítást a nyomtatott alkatrészekben. Egy kalibrációs szkript becslést ad a `max_accel` paraméterre, amely nem okozhat túl nagy simítást. Vedd figyelembe, hogy a kalibrációs szkript által megjelenített `max_accel` csak egy elméleti maximum, amelynél az adott alakító még képes úgy dolgozni, hogy nem okoz túl nagy simítást. Semmiképpen sem ajánlott ezt a gyorsulást beállítani a nyomtatáshoz. A nyomtatód által elviselhető maximális gyorsulás a nyomtató mechanikai tulajdonságaitól és a használt léptetőmotorok maximális nyomatékától függ. Ezért javasolt a `max_accel` beállítása a `[nyomtató]` szakaszban, amely nem haladja meg az X és Y tengelyek becsült értékeit, valószínűleg némi konzervatív biztonsági tartalékkal.

Alternatívaként kövesd [ezt](Resonance_Compensation.md#selecting-max_accel) a részt a bemeneti alakító hangolási útmutatójában, és nyomtasd ki a tesztmodellt a `max_accel` paraméter kísérleti kiválasztásához.

Ugyanez a figyelmeztetés vonatkozik a bemeneti alakító [automatikus kalibrálás](#bemeneti-formazo-automatikus-kalibralasa) `SHAPER_CALIBRATE` paranccsal történő használatára is: az automatikus kalibrálás után továbbra is szükséges a megfelelő `max_accel` érték kiválasztása, és a javasolt gyorsulási korlátok nem lesznek automatikusan alkalmazva.

Ha a formázó újrakalibrálását végzi, és a javasolt formázó konfigurációhoz tartozó simítás majdnem megegyezik az előző kalibrálás során kapott értékkel, ez a lépés kihagyható.

### Egyéni tengelyek tesztelése

`TEST_RESONANCES` parancs támogatja az egyéni tengelyeket. Bár ez nem igazán hasznos a bemeneti alakító kalibrálásához, a nyomtató rezonanciáinak alapos tanulmányozására és például a szíjfeszítés ellenőrzésére használható.

A CoreXY nyomtatókon a szíjfeszítés ellenőrzéséhez hajtsd végre a következőt

```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```

és használjuk a `graph_accelerometer.py` fájlt a generált fájlok feldolgozásához, pl.

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

amely a rezonanciákat összehasonlítva `/tmp/resonances.png` képet hoz létre.

Az alapértelmezett toronyelhelyezésű Delta nyomtatók esetében (A torony ~= 210 fok, B ~= 330 fok és C ~= 90 fok), hajtsd végre a következőt

```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```

majd használd ugyanazt a parancsot

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

`/tmp/resonances.png` létrehozásához, amely összehasonlítja a rezonanciákat.

## Bemeneti formázó automatikus kalibrálása

A bemeneti formázó funkció megfelelő paramétereinek kézi kiválasztása mellett a bemeneti alakító automatikus hangolása közvetlenül a Klipperből is elvégezhető. Futtasd a következő parancsot az Octoprint terminálon keresztül:

```
SHAPER_CALIBRATE
```

Ez lefuttatja a teljes tesztet mindkét tengelyre, és létrehozza a csv-kimenetet (`/tmp/calibration_data_*.csv` alapértelmezés szerint) a frekvenciaválaszról és a javasolt bemeneti alakítókról. Az Octoprint konzolon megkapod az egyes bemeneti alakítók javasolt frekvenciáit is, valamint azt, hogy melyik bemeneti alakítót ajánljuk a Te beállításodhoz. Például:

```
A legjobb bemeneti alakító paraméterek kiszámítása az Y tengelyhez
Beillesztett alakító 'zv' frekvencia = 39,0 Hz (rezgések = 13,2%, simítás ~= 0,105)
A túl nagy simítás elkerülése érdekében a 'zv', javasolt max_accel <= 5900 mm/sec^2
Alkalmazott alakító 'mzv' frekvencia = 36,8 Hz (rezgések = 1,7%, simítás ~= 0,150)
A túl nagy simítás elkerülése érdekében az 'mzv' esetében javasolt max_accel <= 4000 mm/sec^2
Alkalmazott alakító 'ei' frekvencia = 36,6 Hz (rezgések = 2,2%, simítás ~= 0,240)
A túl nagy simítás elkerülése érdekében az 'ei', javasolt max_accel <= 2500 mm/sec^2
Alkalmazott alakító '2hump_ei' frekvencia = 48,0 Hz (rezgések = 0,0%, simítás ~= 0,234)
A túl nagy simítás elkerülése érdekében a '2hump_ei' esetében javasolt max_accel <= 2500 mm/sec^2
Alkalmazott alakító '3hump_ei' frekvencia = 59,0 Hz (rezgések = 0,0%, simítás ~= 0,235)
A túl nagy simítás elkerülése érdekében a '3hump_ei' esetében javasolt max_accel <= 2500 mm/sec^2
Ajánlott shaper_type_y = mzv, shaper_freq_y = 36,8 Hz
```

Ha egyetértesz a javasolt paraméterekkel, akkor a `SAVE_CONFIG` parancsot most végre lehet hajtani a paraméterek mentéséhez és a Klipper újraindításához. Vedd figyelembe, hogy ez nem frissíti a `max_accel` értéket a `[printer]` szakaszban. Ezt manuálisan kell frissítened a [max_accel kiválasztása](#a-max_accel-kivalasztasa) szakaszban leírtak szerint.

Ha a nyomtatód Y tengelyén van a tárgyasztal akkor megadhatod, hogy melyik tengelyt kívánod tesztelni, így a tesztek között megváltoztathatod a gyorsulásmérő rögzítési pontját (alapértelmezés szerint a teszt mindkét tengelyen végrehajtásra kerül):

```
SHAPER_CALIBRATE AXIS=Y
```

A `SAVE_CONFIG` parancsot kétszer - minden egyes tengely kalibrálása után - lehet végrehajtani.

Ha azonban egyszerre két gyorsulásmérőt csatlakoztattál, egyszerűen futtasd a `SHAPER_CALIBRATE` parancsot tengely megadása nélkül, hogy a bemeneti alakítót mindkét tengelyre egy menetben kalibráld.

### Bemeneti formázó újrakalibrálása

`SHAPER_CALIBRATE` parancs arra is használható, hogy a bemeneti alakítót a jövőben újra kalibrálja, különösen akkor, ha a nyomtató kinematikáját befolyásoló változások történnek. A teljes kalibrációt vagy a `SHAPER_CALIBRATE` paranccsal lehet újra lefuttatni, vagy az automatikus kalibrálást egyetlen tengelyre lehet korlátozni az `AXIS=` paraméter megadásával, például a következő módon

```
SHAPER_CALIBRATE AXIS=X
```

**Figyelem!** Nem tanácsos a formázógép automatikus kalibrációját nagyon gyakran futtatni (pl. minden nyomtatás előtt vagy minden nap). A rezonanciafrekvenciák meghatározása érdekében az automatikus kalibrálás intenzív rezgéseket hoz létre az egyes tengelyeken. A 3D nyomtatókat általában nem úgy tervezték, hogy a rezonanciafrekvenciákhoz közeli rezgéseknek tartósan ellenálljanak. Ez növelheti a nyomtató alkatrészeinek kopását és csökkentheti élettartamukat. Megnő a kockázata annak is, hogy egyes alkatrészek kicsavarodnak vagy meglazulnak. Minden egyes automatikus hangolás után mindig ellenőrizd, hogy a nyomtató minden alkatrésze (beleértve azokat is, amelyek normál esetben nem mozoghatnak) biztonságosan a helyén van-e rögzítve.

Továbbá a mérések zajossága miatt lehetséges, hogy a hangolási eredmények kissé eltérnek az egyes kalibrálási folyamatok között. Ennek ellenére nem várható, hogy a zaj túlságosan befolyásolja a nyomtatási minőséget. Mindazonáltal továbbra is tanácsos kétszer is ellenőrizni a javasolt paramétereket, és használat előtt nyomtatni néhány próbanyomatot, hogy megbizonyosodj arról, hogy azok megfelelőek.

## A gyorsulásmérő adatainak offline feldolgozása

Lehetőség van a nyers gyorsulásmérő adatok előállítására és offline feldolgozására (pl. egy központi gépen), például rezonanciák keresésére. Ehhez futtasd a következő parancsokat az Octoprint terminálon keresztül:

```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```

a `SET_INPUT_SHAPER` parancs hibáinak figyelmen kívül hagyása. A `TEST_RESONANCES` parancshoz add meg a kívánt teszttengelyt. A nyers adatok az RPi `/tmp` könyvtárába kerülnek kiírásra.

A nyers adatokat úgy is megkaphatjuk, ha a `ACCELEROMETER_MEASURE` parancsot kétszer futtatjuk valamilyen normál nyomtatási tevékenység közben - először a mérések elindításához, majd azok leállításához és a kimeneti fájl írásához. További részletekért lásd a [G-kódok](G-Codes.md#adxl345) című dokumentumot.

Az adatokat később a következő szkriptekkel lehet feldolgozni: `scripts/graph_accelerometer.py` és `scripts/calibrate_shaper.py`. Mindkettő egy vagy több nyers csv-fájlt fogad el bemenetként a módtól függően. A graph_accelerometer.py szkript többféle üzemmódot támogat:

* nyers gyorsulásmérő adatok ábrázolása (használd a `-r` paramétert), csak 1 bemenet támogatott;
* frekvenciaválasz ábrázolása (nincs szükség további paraméterekre), ha több bemenet van megadva, az átlagos frekvenciaválasz kerül kiszámításra;
* több bemenet frekvenciaválaszának összehasonlítása (használd a `-c` paramétert); a `-a x`, `-a y` vagy `-a z` paraméterrel ezen felül megadhatod, hogy melyik gyorsulásmérő tengelyt vegye figyelembe (ha nincs megadva, az összes tengely rezgéseinek összegét használja);
* a spektrogram ábrázolása (használd a `-s` paramétert), csak 1 bemenet támogatott; a `-a x`, `-a y` vagy `-a z` paraméterrel ezen felül megadhatod, hogy melyik gyorsulásmérő tengelyt vegye figyelembe (ha nincs megadva, akkor az összes tengely rezgéseinek összegét használja).

Vedd figyelembe, hogy a graph_accelerometer.py szkript csak a raw_data\*.csv fájlokat támogatja, a resonances\*.csv vagy calibration_data\*.csv fájlokat nem.

Például,

```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```

több `/tmp/raw_data_x_*.csv` fájl és `/tmp/resonances_x.png` fájl összehasonlítását ábrázolja a Z tengelyen.

A shaper_calibrate.py szkript 1 vagy több bemenetet fogad el, és képes a bemeneti formázó automatikus hangolására, valamint a legjobb paraméterek kiválasztására, amelyek jól működnek az összes megadott bemeneten. A javasolt paramétereket kiírja a konzolra, és emellett képes létrehozni a grafikont, ha `-o output.png` paramétert adunk meg, vagy a CSV fájlt, ha `-c output.csv` paramétert adunk meg.

Több bemenet megadása a shaper_calibrate.py szkriptnek hasznos lehet, ha például a bemeneti formázók haladó hangolását végezzük:

* A `TEST_RESONANCES AXIS=X OUTPUT=raw_data` (és `Y` tengely) futtatása egy tengelyre kétszer egy Y tárgyasztalos nyomtatón úgy, hogy a gyorsulásmérő először a nyomtatófejhez, másodszor pedig a tárgyasztalhoz csatlakozik, hogy a tengelyek keresztrezonanciáit felismerjük, és megpróbáljuk azokat a bemeneti alakítókkal megszüntetni.
* A `TEST_RESONANCES AXIS=Y OUTPUT=raw_data` kétszeri futtatása egy üveg tárgyasztalos és egy mágneses felületű (amelyik könnyebb) tárgyasztalon, hogy megtaláljuk azokat a bemeneti alakító paramétereket, amelyek jól működnek bármilyen nyomtatási felületkonfiguráció esetén.
* A több vizsgálati pontból származó rezonanciaadatok kombinálása.
* A 2 tengely rezonanciaadatainak kombinálása (pl. egy Y tengelyen lévő tárgyasztalos nyomtatónál az X-tengely input_shaper konfigurálása mind az X-, mind az Y-tengely rezonanciáiból, hogy a *tárgyasztal* rezgéseit megszüntesse, ha a fúvóka 'elkap' egy nyomtatást, amikor X tengely irányában mozog).
