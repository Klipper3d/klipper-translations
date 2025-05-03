# Измерване на резонанси

Klipper has built-in support for the ADXL345, MPU-9250, LIS2DW and LIS3DH compatible accelerometers which can be used to measure resonance frequencies of the printer for different axes, and auto-tune [input shapers](Resonance_Compensation.md) to compensate for resonances. Note that using accelerometers requires some soldering and crimping. The ADXL345 can be connected to the SPI interface of a Raspberry Pi or MCU board (it needs to be reasonably fast). The MPU family can be connected to the I2C interface of a Raspberry Pi directly, or to an I2C interface of an MCU board that supports 400kbit/s *fast mode* in Klipper. The LIS2DW and LIS3DH can be connected to either SPI or I2C with the same considerations as above.

When sourcing accelerometers, be aware that there are a variety of different PCB board designs and different clones of them. If it is going to be connected to a 5V printer MCU ensure it has a voltage regulator and level shifters.

For ADXL345s, make sure that the board supports SPI mode (a small number of boards appear to be hard-configured for I2C by pulling SDO to GND).

For MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500/ICM20948s and LIS2DW/LIS3DH there are also a variety of board designs and clones with different I2C pull-up resistors which will need supplementing.

## MCUs with Klipper I2C *fast-mode* Support

| MCU Family | MCU(s) Tested | MCU(s) with Support |
| :-: | :-- | :-- |
| Raspberry Pi | 3B+, Pico | 3A, 3A+, 3B, 4 |
| AVR ATmega | ATmega328p | ATmega32u4, ATmega128, ATmega168, ATmega328, ATmega644p, ATmega1280, ATmega1284, ATmega2560 |
| AVR AT90 | - | AT90usb646, AT90usb1286 |
| SAMD | SAMC21G18 | SAMC21G18, SAMD21G18, SAMD21E18, SAMD21J18, SAMD21E15, SAMD51G19, SAMD51J19, SAMD51N19, SAMD51P20, SAME51J19, SAME51N19, SAME54P20 |

## Инструкции за инсталиране

### Окабеляване

An ethernet cable with shielded twisted pairs (cat5e or better) is recommended for signal integrity over a long distance. If you still experience signal integrity issues (SPI/I2C errors):

- Double check the wiring with a digital multimeter for:
   - Correct connections when turned off (continuity)
   - Correct power and ground voltages
- I2C only:
   - Check the SCL and SDA lines' resistances to 3.3V are in the range of 900 ohms to 1.8K
   - For full technical details consult [chapter 7 of the I2C-bus specification and user manual UM10204](https://www.pololu.com/file/0J435/UM10204.pdf) for *fast-mode*
- Shorten the cable

Connect ethernet cable shielding only to the MCU board/Pi ground.

***Double-check your wiring before powering up to prevent damaging your MCU/Raspberry Pi or the accelerometer.***

### SPI Accelerometers

Suggested twisted pair order for three twisted pairs:

```
GND+MISO
3.3V+MOSI
SCLK+CS
```

Note that unlike a cable shield, GND must be connected at both ends.

#### ADXL345

##### Direct to Raspberry Pi

**Note: Many MCUs will work with an ADXL345 in SPI mode (e.g. Pi Pico), wiring and configuration will vary according to your specific board and available pins.**

Трябва да свържете ADXL345 към вашия Raspberry Pi чрез SPI. Имайте предвид, че I2C връзката, която е предложена в документацията на ADXL345, има твърде ниска пропускателна способност и **няма да работи**. Препоръчителната схема на свързване:

| ADXL345 pin | RPi pin | RPi pin name |
| :-: | :-: | :-: |
| 3V3 (or VCC) | 01 | 3.3V DC power |
| GND | 06 | Маса |
| CS | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

Електрически схеми за някои от платките ADXL345 на Fritzing:

![ADXL345-Rpi](img/adxl345-fritzing.png)

##### Using Raspberry Pi Pico

You may connect the ADXL345 to your Raspberry Pi Pico and then connect the Pico to your Raspberry Pi via USB. This makes it easy to reuse the accelerometer on other Klipper devices, as you can connect via USB instead of GPIO. The Pico does not have much processing power, so make sure it is only running the accelerometer and not performing any other duties.

In order to avoid damage to your RPi make sure to connect the ADXL345 to 3.3V only. Depending on the board's layout, a level shifter may be present, which makes 5V dangerous for your RPi.

| ADXL345 pin | Pico pin | Pico pin name |
| :-: | :-: | :-: |
| 3V3 (or VCC) | 36 | 3.3V DC power |
| GND | 38 | Маса |
| CS | 2 | GP1 (SPI0_CSn) |
| SDO | 1 | GP0 (SPI0_RX) |
| SDA | 5 | GP3 (SPI0_TX) |
| SCL | 4 | GP2 (SPI0_SCK) |

Wiring diagrams for some of the ADXL345 boards:

![ADXL345-Pico](img/adxl345-pico.png)

### I2C Accelerometers

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

#### MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500/ICM20948

These accelerometers have been tested to work over I2C on the RPi, RP2040 (Pico) and AVR at 400kbit/s (*fast mode*). Some MPU accelerometer modules include pull-ups, but some are too large at 10K and must be changed or supplemented by smaller parallel resistors.

Recommended connection scheme for I2C on the Raspberry Pi:

| MPU-9250 pin | RPi pin | RPi pin name |
| :-: | :-: | :-: |
| VCC | 01 | 3.3v DC power |
| GND | 09 | Маса |
| SDA | 03 | GPIO02 (SDA1) |
| SCL | 05 | GPIO03 (SCL1) |

The RPi has buit-in 1.8K pull-ups on both SCL and SDA.

![MPU-9250 connected to Pi](img/mpu9250-PI-fritzing.png)

Recommended connection scheme for I2C (i2c0a) on the RP2040:

| MPU-9250 pin | RP2040 pin | RP2040 pin name |
| :-: | :-: | :-: |
| VCC | 36 | 3v3 |
| GND | 38 | Маса |
| SDA | 01 | GP0 (I2C0 SDA) |
| SCL | 02 | GP1 (I2C0 SCL) |

The Pico does not include any built-in I2C pull-up resistors.

![MPU-9250 connected to Pico](img/mpu9250-PICO-fritzing.png)

##### Recommended connection scheme for I2C(TWI) on the AVR ATmega328P Arduino Nano:

| MPU-9250 pin | Atmega328P TQFP32 pin | Atmega328P pin name | Arduino Nano pin |
| :-: | :-: | :-: | :-: |
| VCC | 39 | - | - |
| GND | 38 | Маса | GND |
| SDA | 27 | SDA | A4 |
| SCL | 28 | SCL | A5 |

The Arduino Nano does not include any built-in pull-up resistors nor a 3.3V power pin.

### Монтиране на акселерометъра

Акселерометърът трябва да е прикрепен към главата на инструмента. Човек трябва да проектира подходяща стойка, която да пасва на собствения му 3D принтер. По-добре е осите на акселерометъра да се изравнят с осите на принтера (но ако това е по-удобно, осите могат да се разменят, т.е. не е необходимо оста X да се изравнява с оста X и т.н. - всичко трябва да е наред, дори ако оста Z на акселерометъра е оста X на принтера и т.н.).

Пример за монтиране на ADXL345 върху SmartEffector:

![ADXL345 on SmartEffector](img/adxl345-mount.jpg)

Обърнете внимание, че при принтера с праг на леглото трябва да се проектират 2 опори: една за главата на инструмента и една за леглото, и да се извършат измерванията два пъти. За повече подробности вижте съответния [раздел](#bed-slinger-printers).

**Внимание:** уверете се, че акселерометърът и всички винтове, които го държат на място, не се допират до метални части на принтера. По принцип монтажът трябва да бъде проектиран така, че да осигурява електрическа изолация на акселерометъра от рамката на принтера. Ако това не бъде осигурено, може да се създаде заземителен контур в системата, който може да повреди електрониката.

### Инсталиране на софтуер

Note that resonance measurements and shaper auto-calibration require additional software dependencies not installed by default. First, run on your Raspberry Pi the following commands:

```
sudo apt update
sudo apt install python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev
```

Next, in order to install NumPy in the Klipper environment, run the command:

```
~/klippy-env/bin/pip install -v "numpy<1.26"
```

Note that, depending on the performance of the CPU, it may take *a lot* of time, up to 10-20 minutes. Be patient and wait for the completion of the installation. On some occasions, if the board has too little RAM the installation may fail and you will need to enable swap. Also note the forced version, due to newer versions of NumPY having requirements that may not be satisfied in some klipper python environments.

Once installed please check that no errors show from the command:

```
~/klippy-env/bin/python -c 'import numpy;'
```

The correct output should simply be a new line.

#### Configure ADXL345 With RPi

First, check and follow the instructions in the [RPi Microcontroller document](RPi_microcontroller.md) to setup the "linux mcu" on the Raspberry Pi. This will configure a second Klipper instance that runs on your Pi.

Уверете се, че SPI драйверът на Linux е активиран, като стартирате `sudo raspi-config` и активирате SPI в менюто "Interfacing options".

Add the following to the printer.cfg file:

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

Препоръчително е да започнете с 1 точка на сондата, в средата на печатащото легло, малко над него.

#### Configure ADXL345 With Pi Pico

##### Flash the Pico Firmware

On your Raspberry Pi, compile the firmware for the Pico.

```
cd ~/klipper
make clean
make menuconfig
```

![Pico menuconfig](img/klipper_pico_menuconfig.png)

Now, while holding down the `BOOTSEL` button on the Pico, connect the Pico to the Raspberry Pi via USB. Compile and flash the firmware.

```
make flash FLASH_DEVICE=first
```

If that fails, you will be told which `FLASH_DEVICE` to use. In this example, that's `make flash FLASH_DEVICE=2e8a:0003`. ![Determine flash device](img/flash_rp2040_FLASH_DEVICE.png)

##### Configure the Connection

The Pico will now reboot with the new firmware and should show up as a serial device. Find the pico serial device with `ls /dev/serial/by-id/*`. You can now add an `adxl.cfg` file with the following settings:

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

If setting up the ADXL345 configuration in a separate file, as shown above, you'll also want to modify your `printer.cfg` file to include this:

```
[include adxl.cfg] # Comment this out when you disconnect the accelerometer
```

Рестартирайте Klipper чрез командата `RESTART`.

#### Configure LIS2DW series over SPI

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

#### Configure MPU-6000/9000 series With RPi

Make sure the Linux I2C driver is enabled and the baud rate is set to 400000 (see [Enabling I2C](RPi_microcontroller.md#optional-enabling-i2c) section for more details). Then, add the following to the printer.cfg:

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

If you are using the ICM20948, replace instances of "mpu9250" with "icm20948".

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

If you are using the ICM20948, replace instances of "mpu9250" with "icm20948".

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

If you are using the ICM20948, replace instances of "mpu9250" with "icm20948".

Рестартирайте Klipper чрез командата `RESTART`.

## Измерване на резонансите

### Проверка на настройките

Сега можете да тествате връзката.

- В Octoprint въведете `ACCELEROMETER_QUERY` за "устройства, които не са на легло" (напр. един акселерометър).
- За "bed-slingers" (напр. повече от един акселерометър) въведете `ACCELEROMETER_QUERY CHIP=<chip>`, където `<chip>` е името на чипа, както е въведено, напр. `CHIP=bed` (вижте: [bed-slinger](#bed-slinger-printers)) за всички инсталирани чипове на акселерометър.

Трябва да видите текущите измервания от акселерометъра, включително ускорението при свободно падане, напр.

```
Recv: // adxl345 values (x, y, z): 470.719200, 941.438400, 9728.196800
```

If you get an error like `Invalid adxl345 id (got xx vs e5)`, where `xx` is some other ID, immediately try again. There's an issue with SPI initialization. If you still get an error, it is indicative of the connection problem with ADXL345, or the faulty sensor. Double-check the power, the wiring (that it matches the schematics, no wire is broken or loose, etc.), and soldering quality.

**If you are using a MPU-9250 compatible accelerometer and it shows up as `mpu-unknown`, use with caution! They are probably refurbished chips!**

След това опитайте да стартирате `MEASURE_AXES_NOISE` в Octoprint, за да получите някои базови стойности за шума на акселерометъра по осите (трябва да е някъде в диапазона ~1-100). Твърде високият шум по осите (напр. 1000 и повече) може да е показателен за проблеми със сензора, проблеми с неговото захранване или твърде шумни дисбалансирани вентилатори на 3D принтера.

### Измерване на резонансите

Сега можете да проведете някои тестове в реални условия. Изпълнете следната команда:

```
TEST_RESONANCES AXIS=X
```

Обърнете внимание, че това ще доведе до вибрации по оста X. То също така ще деактивира оформянето на входа, ако преди това е било разрешено, тъй като не е валидно да се провежда изпитване за резонанс с разрешено оформяне на входа.

**Внимание!** Не забравяйте да наблюдавате принтера за първи път, за да се уверите, че вибрациите не са прекалено силни (командата `M112` може да се използва за прекъсване на теста в случай на спешност; надяваме се, че няма да се стигне до това). Ако вибрациите станат твърде силни, можете да се опитате да зададете по-ниска от стойността по подразбиране за параметъра `accel_per_hz` в раздела `[resonance_tester]`, напр.

```
[resonance_tester]
accel_chip: adxl345
accel_per_hz: 50  # default is 75
probe_points: ...
```

Ако работи за ос X, изпълнете го и за ос Y:

```
TEST_RESONANCES AXIS=Y
```

This will generate 2 CSV files (`/tmp/resonances_x_*.csv` and `/tmp/resonances_y_*.csv`). These files can be processed with the stand-alone script on a Raspberry Pi. This script is intended to be run with a single CSV file for each axis measured, although it can be used with multiple CSV files if you desire to average the results. Averaging results can be useful, for example, if resonance tests were done at multiple test points. Delete the extra CSV files if you do not desire to average them.

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

Този скрипт ще генерира диаграмите `/tmp/shaper_calibrate_x.png` и `/tmp/shaper_calibrate_y.png` с честотни отговори. Ще получите също така предложените честоти за всеки от входните формиращи устройства, както и кое входно формиращо устройство е препоръчително за вашата конфигурация. Например:

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

Предложената конфигурация може да бъде добавена в раздела `[input_shaper]` на `printer.cfg`, например:

```
[input_shaper]
shaper_freq_x: ...
shaper_type_x: ...
shaper_freq_y: 34.6
shaper_type_y: mzv

[printer]
max_accel: 3000  # should not exceed the estimated max_accel for X and Y axes
```

или можете сами да изберете друга конфигурация въз основа на генерираните диаграми: пиковете в спектралната плътност на мощността на диаграмите съответстват на резонансните честоти на принтера.

Note that alternatively you can run the input shaper auto-calibration from Klipper [directly](#input-shaper-auto-calibration), which can be convenient, for example, for the input shaper [re-calibration](#input-shaper-re-calibration).

### Bed-slinger printers

Ако вашият принтер е с леглова прашка, ще трябва да промените местоположението на акселерометъра между измерванията за осите X и Y: измерете резонансите на ос X с акселерометър, прикрепен към главата на инструмента, а резонансите на ос Y - към леглото (обичайната настройка на легловата прашка).

However, you can also connect two accelerometers simultaneously, though the ADXL345 must be connected to different boards (say, to an RPi and printer MCU board), or to two different physical SPI interfaces on the same board (rarely available). Then they can be configured in the following manner:

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

Тогава командите `TEST_RESONANCES AXIS=X` и `TEST_RESONANCES AXIS=Y` ще използват правилния акселерометър за всяка ос.

### Максимално изглаждане

Имайте предвид, че входният формировател може да създаде известно изглаждане на частите. Автоматичната настройка на входния формировател, извършвана от скрипта `calibrate_shaper.py` или командата `SHAPER_CALIBRATE`, се опитва да не засилва изглаждането, но в същото време се опитва да сведе до минимум възникващите вибрации. Понякога те могат да направят неоптимален избор на честотата на формирователя или може би просто предпочитате да имате по-малко изглаждане в частите за сметка на по-големи оставащи вибрации. В тези случаи можете да поискате да се ограничи максималното изглаждане от входния формировател.

Нека разгледаме следните резултати от автоматичната настройка:

![Resonances](img/calibrate-x.png)

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

Обърнете внимание, че отчетените стойности за "изглаждане" са абстрактни прогнозни стойности. Тези стойности могат да се използват за сравняване на различни конфигурации: колкото по-висока е стойността, толкова по-голямо изглаждане ще създаде даден шейпър. Тези оценки за изглаждане обаче не представляват реална мярка за изглаждане, тъй като действителното изглаждане зависи от параметрите [`max_accel`](#selecting-max-accel) и `square_corner_velocity`. Затова трябва да отпечатате няколко тестови разпечатки, за да видите колко точно изглаждане създава избраната конфигурация.

В примера по-горе предложените параметри на формирователя не са лоши, но какво ще стане, ако искате да получите по-малко изглаждане по оста Х? Можете да опитате да ограничите максималното изглаждане на формирователя, като използвате следната команда:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```

което ограничава изглаждането до 0,2 точки. Сега можете да получите следния резултат:

![Resonances](img/calibrate-x-max-smoothing.png)

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

Ако сравните с предложените преди това параметри, вибрациите са малко по-големи, но изглаждането е значително по-малко от преди, което позволява по-голямо максимално ускорение.

Когато решавате кой параметър `max_smoothing` да изберете, можете да използвате подхода "проба-грешка". Опитайте няколко различни стойности и вижте какви резултати ще получите. Обърнете внимание, че действителното изглаждане, произведено от входния формировател, зависи най-вече от най-ниската резонансна честота на принтера: колкото по-висока е честотата на най-ниския резонанс - толкова по-малко е изглаждането. Следователно, ако поискате от скрипта да намери конфигурация на входния формировател с нереално малко изглаждане, това ще бъде за сметка на повишено звънене при най-ниските резонансни честоти (които обикновено са и по-ясно видими в разпечатките). Затова винаги проверявайте два пъти прогнозните остатъчни вибрации, отчетени от скрипта, и се уверете, че те не са твърде високи.

Обърнете внимание, че ако сте избрали добра стойност на `max_smoothing` за двете си оси, можете да я съхраните в `printer.cfg` като

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # an example
```

След това, ако в бъдеще [повторите](#input-shaper-re-calibration) автоматичната настройка на входния формировател с помощта на командата `SHAPER_CALIBRATE` на Klipper, тя ще използва съхранената стойност `max_smoothing` като референтна.

### Избор на max_accel

Тъй като входният формировател може да създаде известно изглаждане на частите, особено при високи ускорения, все пак ще трябва да изберете стойност на `max_accel`, която да не създава прекалено голямо изглаждане на отпечатаните части. Скриптът за калибриране осигурява оценка на параметъра `max_accel`, който не трябва да създава твърде голямо изглаждане. Имайте предвид, че показаният от скрипта за калибриране параметър `max_accel` е само теоретичен максимум, при който съответният формировател все още е в състояние да работи, без да създава прекалено голямо изглаждане. По никакъв начин не е препоръка да се задава това ускорение за печат. Максималното ускорение, което вашият принтер може да поддържа, зависи от неговите механични свойства и максималния въртящ момент на използваните стъпкови двигатели. Ето защо се препоръчва да зададете `max_accel` в раздела `[printer]`, който да не надвишава изчислените стойности за осите X и Y, вероятно с известен консервативен резерв за безопасност.

Като алтернатива следвайте [this](Resonance_Compensation.md#selecting-max_accel) частта от ръководството за настройка на входния формировател и отпечатайте тестовия модел, за да изберете експериментално параметъра `max_accel`.

Същото предупреждение се отнася и за входния формировател [автоматично калибриране](#input-shaper-auto-calibration) с командата `SHAPER_CALIBRATE`: все още е необходимо да се избере правилната стойност на `max_accel` след автоматичното калибриране и предложените граници на ускорението няма да бъдат приложени автоматично.

Keep in mind that the maximum acceleration without too much smoothing depends on the `square_corner_velocity`. The general recommendation is not to change it from its default value 5.0, and this is the value used by default by the `calibrate_shaper.py` script. If you did change it though, you should inform the script about it by passing `--square_corner_velocity=...` parameter, e.g.

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --square_corner_velocity=10.0
```

so that it can calculate the maximum acceleration recommendations correctly. Note that the `SHAPER_CALIBRATE` command already takes the configured `square_corner_velocity` parameter into account, and there is no need to specify it explicitly.

Ако извършвате повторно калибриране на формирователя и отчетеното изглаждане за предложената конфигурация на формирователя е почти същото като полученото при предишното калибриране, тази стъпка може да бъде пропусната.

### Unreliable measurements of resonance frequencies

Sometimes the resonance measurements can produce bogus results, leading to the incorrect suggestions for the input shapers. This can be caused by a variety of reasons, including running fans on the toolhead, incorrect position or non-rigid mounting of the accelerometer, or mechanical problems such as loose belts or binding or bumpy axis. Keep in mind that all fans should be disabled for resonance testing, especially the noisy ones, and that the accelerometer should be rigidly mounted on the corresponding moving part (e.g. on the bed itself for the bed slinger, or on the extruder of the printer itself and not the carriage, and some people get better results by mounting the accelerometer on the nozzle itself). As for mechanical problems, the user should inspect if there is any fault that can be fixed with a moving axis (e.g. linear guide rails cleaned up and lubricated and V-slot wheels tension adjusted correctly). If none of that helps, a user may try the other shapers from the produced list besides the one recommended by default.

### Testing custom axes

`TEST_RESONANCES` command supports custom axes. While this is not really useful for input shaper calibration, it can be used to study printer resonances in-depth and to check, for example, belt tension.

To check the belt tension on CoreXY printers, execute

```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```

and use `graph_accelerometer.py` to process the generated files, e.g.

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

which will generate `/tmp/resonances.png` comparing the resonances.

For Delta printers with the default tower placement (tower A ~= 210 degrees, B ~= 330 degrees, and C ~= 90 degrees), execute

```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```

and then use the same command

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

to generate `/tmp/resonances.png` comparing the resonances.

## Автоматично калибриране на входния формировател

Освен ръчното избиране на подходящите параметри за функцията на входния формировател е възможно да се стартира автоматичната настройка на входния формировател директно от Klipper. Изпълнете следната команда чрез терминала Octoprint:

```
SHAPER_CALIBRATE
```

Това ще изпълни пълния тест за двете оси и ще генерира изходния файл csv (`/tmp/calibration_data_*.csv` по подразбиране) за честотната характеристика и предложените входни оформители. В конзолата на Octoprint ще получите също така предложените честоти за всеки входен формировател, както и кой входен формировател се препоръчва за вашата конфигурация. Например:

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

Ако сте съгласни с предложените параметри, сега можете да изпълните `SAVE_CONFIG`, за да ги запазите и да рестартирате Klipper. Имайте предвид, че това няма да актуализира стойността на `max_accel` в раздела `[printer]`. Трябва да я актуализирате ръчно, като следвате съображенията в раздел [Избор на max_accel](#selecting-max_accel).

Ако вашият принтер е принтер с прашка, можете да посочите коя ос да се тества, така че да можете да променяте точката на монтиране на акселерометъра между тестовете (по подразбиране тестът се извършва и за двете оси):

```
SHAPER_CALIBRATE AXIS=Y
```

Можете да изпълните `SAVE_CONFIG` два пъти - след калибриране на всяка ос.

Ако обаче сте свързали два акселерометъра едновременно, можете просто да стартирате `SHAPER_CALIBRATE`, без да посочвате ос, за да калибрирате входния формировател за двете оси наведнъж.

### Повторно калибриране на входния формировател

Командата `SHAPER_CALIBRATE` може да се използва и за повторно калибриране на входния формировател в бъдеще, особено ако в принтера са направени промени, които могат да повлияят на неговата кинематика. Може да се извърши повторно пълно калибриране с помощта на командата `SHAPER_CALIBRATE` или да се ограничи автоматичното калибриране до една ос, като се въведе параметър `AXIS=`, както

```
SHAPER_CALIBRATE AXIS=X
```

**Warning!** It is not advisable to run the shaper auto-calibration very frequently (e.g. before every print, or every day). In order to determine resonance frequencies, auto-calibration creates intensive vibrations on each of the axes. Generally, 3D printers are not designed to withstand a prolonged exposure to vibrations near the resonance frequencies. Doing so may increase wear of the printer components and reduce their lifespan. There is also an increased risk of some parts unscrewing or becoming loose. Always check that all parts of the printer (including the ones that may normally not move) are securely fixed in place after each auto-tuning.

Освен това, поради някои шумове в измерванията, е възможно резултатите от настройката да се различават леко при различните калибрирания. Все пак не се очаква шумът да повлияе твърде много на качеството на печата. Въпреки това все пак се препоръчва да проверите два пъти предложените параметри и да отпечатате няколко тестови отпечатъка, преди да ги използвате, за да потвърдите, че са добри.

## Офлайн обработка на данните от акселерометъра

Възможно е да се генерират необработени данни от акселерометъра и да се обработват офлайн (напр. на хост машина), например за откриване на резонанси. За да направите това, изпълнете следните команди чрез терминала Octoprint:

```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```

игнориране на всички грешки за командата `SET_INPUT_SHAPER`. За командата `TEST_RESONANCES` посочете желаната тестова ос. Суровите данни ще бъдат записани в директорията `/tmp` на RPi.

The raw data can also be obtained by running the command `ACCELEROMETER_MEASURE` command twice during some normal printer activity - first to start the measurements, and then to stop them and write the output file. Refer to [G-Codes](G-Codes.md#adxl345) for more details.

Данните могат да бъдат обработени по-късно чрез следните скриптове: `scripts/graph_accelerometer.py` и `scripts/calibrate_shaper.py`. И двата приемат един или няколко необработени csv файла като вход в зависимост от режима. Скриптът graph_accelerometer.py поддържа няколко режима на работа:

* при изчертаване на сурови данни от акселерометър (използвайте параметъра `-r`) се поддържа само 1 вход;
* начертаване на честотна характеристика (не се изискват допълнителни параметри), ако са зададени множество входове, се изчислява средната честотна характеристика;
* сравнение на честотната характеристика между няколко входа (използвайте параметъра `-c`); можете допълнително да посочите коя ос на акселерометъра да се вземе предвид чрез параметъра `-a x`, `-a y` или `-a z` (ако не е посочен такъв, се използва сумата от вибрациите за всички оси);
* при построяване на спектрограмата (използвайте параметъра `-s`) се поддържа само 1 вход; можете допълнително да посочите коя ос на акселерометъра да се вземе предвид чрез параметъра `-a x`, `-a y` или `-a z` (ако не е посочен такъв, се използва сумата от вибрациите за всички оси).

Обърнете внимание, че скриптът graph_accelerometer.py поддържа само файловете raw_data\*.csv, но не и файловете resonances\*.csv или calibration_data\*.csv.

Например,

```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```

ще изобрази сравнението на няколко файла `/tmp/raw_data_x_*.csv` за ос Z с файл `/tmp/resonances_x.png`.

The shaper_calibrate.py script accepts 1 or several inputs and can run automatic tuning of the input shaper and suggest the best parameters that work well for all provided inputs. It prints the suggested parameters to the console, and can additionally generate the chart if `-o output.png` parameter is provided, or the CSV file if `-c output.csv` parameter is specified.

Providing several inputs to shaper_calibrate.py script can be useful if running some advanced tuning of the input shapers, for example:

* Running `TEST_RESONANCES AXIS=X OUTPUT=raw_data` (and `Y` axis) for a single axis twice on a bed slinger printer with the accelerometer attached to the toolhead the first time, and the accelerometer attached to the bed the second time in order to detect axes cross-resonances and attempt to cancel them with input shapers.
* Running `TEST_RESONANCES AXIS=Y OUTPUT=raw_data` twice on a bed slinger with a glass bed and a magnetic surfaces (which is lighter) to find the input shaper parameters that work well for any print surface configuration.
* Combining the resonance data from multiple test points.
* Combining the resonance data from 2 axis (e.g. on a bed slinger printer to configure X-axis input_shaper from both X and Y axes resonances to cancel vibrations of the *bed* in case the nozzle 'catches' a print when moving in X axis direction).
