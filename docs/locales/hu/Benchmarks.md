# Referenciaértékek

Ez a dokumentum a Klipper referenciaértékeit ismerteti.

## Mikrokontroller referenciaértékek

Ez a szakasz ismerteti a Klipper mikrokontroller lépési sebességreferencia létrehozására használt mechanizmust.

A referenciamutatók elsődleges célja, hogy következetes mechanizmust biztosítsanak a szoftveren belüli kódolási változtatások hatásának mérésére. Másodlagos cél, hogy magas szintű mérőszámokat biztosítson a chipek és a szoftverplatformok teljesítményének összehasonlításához.

A lépésszám-összehasonlítás célja a hardver és a szoftver által elérhető maximális lépésszám meghatározása. Ez az összehasonlító lépési sebesség a mindennapi használat során nem érhető el, mivel a Klippernek más feladatokat is el kell látnia (pl. mcu/host kommunikáció, hőmérséklet leolvasás, végállás ellenőrzés) minden valós használat során.

Általában a referencia-tesztekhez használt tűket úgy választják ki, hogy LED-eket vagy más ártalmatlan eszközöket működtessen. **A referencia futtatása előtt mindig ellenőrizd, hogy a konfigurált tűk meghajtása biztonságos-e.** Nem ajánlott a tényleges léptetők használata a referencia során.

### Léptetőarányos referenciaérték teszt

A teszt a console.py eszközzel történik (a <Debugging.md> című fejezetben leírtak szerint). A mikrokontrollert az adott hardverplatformhoz konfiguráljuk (lásd alább), majd a következőket vágjuk ki és illesszük be a console.py terminálablakba:

```
SET start_clock {clock+freq}
SET ticks 1000

reset_step_clock oid=0 clock={start_clock}
set_next_step_dir oid=0 dir=0
queue_step oid=0 interval={ticks} count=60000 add=0
set_next_step_dir oid=0 dir=1
queue_step oid=0 interval=3000 count=1 add=0

reset_step_clock oid=1 clock={start_clock}
set_next_step_dir oid=1 dir=0
queue_step oid=1 interval={ticks} count=60000 add=0
set_next_step_dir oid=1 dir=1
queue_step oid=1 interval=3000 count=1 add=0

reset_step_clock oid=2 clock={start_clock}
set_next_step_dir oid=2 dir=0
queue_step oid=2 interval={ticks} count=60000 add=0
set_next_step_dir oid=2 dir=1
queue_step oid=2 interval=3000 count=1 add=0
```

A fentiekben három léptető egyidejű léptetését teszteljük. Ha a fentiek futtatása egy "Rescheduled timer in the past" a "Stepper too far in pas" hibát eredményez, akkor ez azt jelzi, hogy a `ticks` paraméter túl alacsony (túl gyors léptetési sebességet eredményez). A cél az, hogy megtaláljuk a ticks paraméter legalacsonyabb beállítását, amely megbízhatóan eredményezi a teszt sikeres befejezését. A ticks paramétert addig kell felezni, amíg stabil értéket nem találunk.

Sikertelenség esetén az alábbiakat másolva és beillesztve törölheted a hibát a következő tesztre való felkészüléshez:

```
clear_shutdown
```

Az egylépcsős referenciaértékek eléréséhez ugyanazt a konfigurációs sorrendet kell használni, de a fenti tesztnek csak az első blokkja a másolás és beillesztés a console.py ablakba.

A [Funkciók](Features.md) dokumentumban található referenciatesztek előállításához a másodpercenkénti lépések teljes számát úgy kell kiszámítani, hogy az aktív léptetők számát megszorozzuk a névleges MCU frekvenciával, és elosztjuk a végső "ticks" paraméterrel. Az eredményeket a legközelebbi K-ra kerekítjük. Például három aktív léptetővel:

```
ECHO A teszt eredménye: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

A referenciaértékeket a TMC vezérlők számára megfelelő paraméterekkel futtatjuk. Az olyan mikrovezérlők esetében, amelyek támogatják a `STEPPER_BOTH_EDGE=1` (amint azt az `MCU config` sorban a konzolnál console.py első indításakor) a `step_pulse_duration=0` és `invert_step=-1` használatával engedélyezzük az optimalizált lépést a lépésimpulzus mindkét élére. Más mikrovezérlők esetében használd a 100ns-nak megfelelő `step_pulse_duration` értéket.

### AVR lépési sebesség referenciaérték

Az AVR chipeknél a következő konfigurációs sorrend használatos:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
finalize_config crc=0
```

A tesztet utoljára a `59314d99` megbízáson futtattuk, a gcc `avr-gcc (GCC) 5.4.0` verziójával. Mind a 16Mhz-es, mind a 20Mhz-es teszteket egy atmega644p-re konfigurált simulavr segítségével futtattuk (korábbi tesztek megerősítették, hogy a simulavr eredményei egyeznek a 16Mhz-es at90usb és a 16Mhz-es atmega2560-as tesztekkel).

| avr | trükkök |
| --- | --- |
| 1 léptető | 102 |
| 3 léptető | 486 |

### Arduino Due lépésszám referencia

A következő konfigurációs sorrendet használjuk a Due-n:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet utoljára a `59314d99` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` futtatta.

| sam3x8e | trükkök |
| --- | --- |
| 1 léptető | 66 |
| 3 léptető | 257 |

### Duet Maestro lépésszám referencia

A Duet Maestro a következő konfigurációs sorrendet használja:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet utoljára a `59314d99` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` futtatta.

| sam4s8c | trükkök |
| --- | --- |
| 1 léptető | 71 |
| 3 léptető | 260 |

### Duet WiFi lépésszám referencia

A Duet WiFi esetében a következő konfigurációs sorrendet használjuk:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet utoljára a `59314d99` megbízási gcc verzióval `gcc 10.3.1 20210621 (release) (GNU Arm Embedded Toolchain 10.3-2021.07)` futtatta.

| sam4e8e | trükkök |
| --- | --- |
| 1 léptető | 48 |
| 3 léptető | 215 |

### Beaglebone PRU lépésszám referencia

A PRU-n a következő konfigurációs sorrendet kell alkalmazni:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
finalize_config crc=0
```

A tesztet utoljára a `59314d99` megbízási gcc verzióval `pru-gcc (GCC) 8.0.0 20170530 (experimental)` futtatta.

| pru | trükkök |
| --- | --- |
| 1 léptető | 231 |
| 3 léptető | 847 |

### STM32F042 lépésszám referencia

Az STM32F042-nél a következő konfigurációs sorrendet használjuk:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet utoljára a `59314d99` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` futtatta.

| stm32f042 | trükkök |
| --- | --- |
| 1 léptető | 59 |
| 3 léptető | 249 |

### STM32F103 lépésszám referencia

Az STM32F103 esetében a következő konfigurációs sorrendet használjuk:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet utoljára a `59314d99` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` futtatta.

| stm32f103 | trükkök |
| --- | --- |
| 1 léptető | 61 |
| 3 léptető | 264 |

### STM32F4 lépésszám referencia

Az STM32F4 esetében a következő konfigurációs sorrendet használjuk:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet utoljára a `59314d99` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` futtatta. Az STM32F407-es eredményeket úgy kaptuk, hogy egy STM32F407-es bináris programot futtattunk egy STM32F446-oson (és így 168 MHz-es órajelet használtunk).

| stm32f446 | trükkök |
| --- | --- |
| 1 léptető | 46 |
| 3 léptető | 205 |

| stm32f407 | trükkök |
| --- | --- |
| 1 léptető | 46 |
| 3 léptető | 205 |

### STM32H7 lépésszám referencia

A következő konfigurációs sorrendet egy STM32H743VIT6 esetében használjuk:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD4 dir_pin=PD3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA15 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PE2 dir_pin=PE3 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A teszt utoljára `00191b5c` véglegesítéssel futott a gcc `arm-none-eabi-gcc (15:8-2019-q3-1+b1) 8.3.1 20190703 (release) [gcc-8-branch revision 273027]` véglegesítéssel.

| stm32h7 | trükkök |
| --- | --- |
| 1 léptető | 44 |
| 3 léptető | 198 |

### STM32G0B1 lépésszám referencia

Az STM32G0B1 esetében a következő konfigurációs sorrendet használjuk:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB13 dir_pin=PB12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB10 dir_pin=PB2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB0 dir_pin=PC5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet utoljára a `247cd753` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` futtatta.

| stm32g0b1 | trükkök |
| --- | --- |
| 1 léptető | 58 |
| 3 léptető | 243 |

### LPC176x lépésszám referencia

Az LPC176x esetében a következő konfigurációs sorrendet használjuk:

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet utoljára a `59314d99` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` futtatta. A 120Mhz-es LPC1769-es eredményeket egy LPC1768-as 120Mhz-re való túlhajtásával kaptuk.

| lpc1768 | trükkök |
| --- | --- |
| 1 léptető | 52 |
| 3 léptető | 222 |

| lpc1769 | trükkök |
| --- | --- |
| 1 léptető | 51 |
| 3 léptető | 222 |

### SAMD21 lépési sebesség referencia

A SAMD21 esetében a következő konfigurációs sorrendet kell alkalmazni:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet legutóbb a `59314d99` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` futtatta egy SAMD21G18 mikrokontrollerrel.

| samd21 | trükkök |
| --- | --- |
| 1 léptető | 70 |
| 3 léptető | 306 |

### SAMD51 lépési sebesség referencia

A SAMD51 esetében a következő konfigurációs sorrendet kell alkalmazni:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet legutóbb a `59314d99` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` futtatta egy SAMD51J19A mikrokontrollerrel.

| samd51 | trükkök |
| --- | --- |
| 1 léptető | 39 |
| 3 léptető | 191 |
| 1 lépés (200Mhz) | 39 |
| 3 lépés (200Mhz) | 181 |

### RP2040 léptetési referencia

Az RP2040 esetében a következő konfigurációs sorrendet kell alkalmazni:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

A tesztet legutóbb a `59314d99` megbízási gcc verzióval `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` Raspberry Pi Pico kártyán futtattuk.

| rp2040 | trükkök |
| --- | --- |
| 1 léptető | 5 |
| 3 léptető | 22 |

### Linux MCU lépésszám referencia

A következő konfigurációs sorrendet egy Raspberry Pi esetében használjuk:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
finalize_config crc=0
```

A tesztet legutóbb a `59314d99` megbízási gcc verzióval `gcc (Raspbian 8.3.0-6+rpi1) 8.3.0` Raspberry Pi 3-on (revision a02082) futtatták. Ebben a referenciatesztben nehéz volt stabil eredményeket elérni.

| Linux (RPi3) | trükkök |
| --- | --- |
| 1 léptető | 160 |
| 3 léptető | 380 |

## Parancsküldési referencia

A parancskiadási referenciateszt azt teszteli, hogy a mikrokontroller hány "dummy" parancsot képes feldolgozni. Ez elsősorban a hardveres kommunikációs mechanizmus tesztje. A tesztet a console.py eszközzel futtatjuk (a <Debugging.md> című fejezetben leírtak szerint). Az alábbiakat másoljuk ki és illesszük be a console.py terminálablakba:

```
DELAY {clock + 2*freq} get_uptime
FLOOD 100000 0.0 debug_nop
get_uptime
```

A teszt befejezésekor határozza meg a két "üzemidő" válaszüzenetben jelentett órák közötti különbséget. A másodpercenkénti parancsok teljes száma ekkor `100000 * mcu_frequency / clock_diff`.

Vedd figyelembe, hogy ez a teszt telítheti a Raspberry Pi USB/CPU kapacitását. Ha Raspberry Pi, Beaglebone vagy hasonló gazdagépen fut, akkor növelje a késleltetést (pl. `DELAY {clock + 20*freq} get_uptime`). Ahol alkalmazható, az alábbi referenciák a console.py futtatásával készültek egy asztali számítógépen, ahol az eszköz egy nagy sebességű HUB-on keresztül van csatlakoztatva.

| MCU | Arány | Gyári szám | Fordító program |
| --- | --- | --- | --- |
| stm32f042 (CAN) | 18K | c105adc8 | arm-none-eabi-gcc (GNU Tools 7-2018-q3-update) 7.3.1 |
| atmega2560 (serial) | 23K | b161a69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (serial) | 23K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| at90usb1286 (USB) | 75K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| samd21 (USB) | 223K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| pru (megosztott memória) | 260K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (kísérleti) |
| stm32f103 (USB) | 355K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB) | 534K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB) | 628K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB) | 870K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 873K | c5667193 | arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0 |

## Gazdagép referenciaértékei

Lehetőség van időzítési tesztek futtatására a gazdagépen a "batch mode" feldolgozási mechanizmus használatával (a <Debugging.md> című fejezetben leírtak szerint). Ez általában úgy történik, hogy kiválasztunk egy nagy és összetett G-kód fájlt, és megmérjük, hogy mennyi idő alatt dolgozza fel a gazdaszoftver. Például:

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
