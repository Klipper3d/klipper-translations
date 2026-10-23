# Prestandamätningar

Det här dokumentet beskriver prestandamätningar för Klipper.

## Prestandamätningar för mikrokontroller

Det här avsnittet beskriver mekanismen som används för att skapa prestandamätningar av Klippers steghastighet för mikrokontroller.

Det främsta syftet med prestandamätningarna är att tillhandahålla ett konsekvent sätt att mäta hur kodändringar påverkar programvaran. Ett sekundärt syfte är att tillhandahålla övergripande mått för att jämföra prestanda mellan chip och programvaruplattformar.

Prestandamätningen av steghastighet är utformad för att hitta den högsta steghastighet som maskin- och programvaran kan uppnå. Denna steghastighet går inte att använda till vardags eftersom Klipper vid verklig användning måste utföra andra uppgifter (till exempel kommunikation mellan MCU och värd, temperaturavläsning och kontroll av ändlägen).

I allmänhet väljs stiften för prestandamätningarna så att lysdioder eller andra ofarliga stift växlas. **Kontrollera alltid att det är säkert att styra de konfigurerade stiften innan du kör en prestandamätning.** Vi rekommenderar inte att du styr en faktisk stegmotor under en prestandamätning.

### Test av steghastighet

Testet utförs med verktyget console.py (beskrivet i <Debugging.md>). Mikrokontrollern konfigureras för den aktuella maskinvaruplattformen (se nedan) och sedan klistras följande in i terminalfönstret för console.py:

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

Ovanstående testar tre stegmotorer som stegar samtidigt. Om körning av ovanstående ger felet "Rescheduled timer in the past" eller "Stepper too far in past" är parametern `ticks` för låg (vilket ger en för hög steghastighet). Målet är att hitta den lägsta inställningen av parametern ticks som tillförlitligt leder till att testet slutförs. Det bör gå att halvera sökområdet för parametern ticks tills ett stabilt värde hittas.

Vid fel kan du kopiera och klistra in följande för att rensa felet inför nästa test:

```
clear_shutdown
```

För att få prestandamätningarna för en stegmotor används samma konfigurationssekvens, men bara det första blocket i testet ovan klistras in i console.py-fönstret.

För att skapa prestandamätningarna i dokumentet [Funktioner](Features.md) beräknas det totala antalet steg per sekund genom att antalet aktiva stegmotorer multipliceras med den nominella MCU-frekvensen och delas med den slutliga ticks-parametern. Resultaten avrundas till närmaste K. Till exempel med tre aktiva stegmotorer:

```
ECHO Test result is: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

Prestandamätningarna körs med parametrar som passar TMC-drivrutiner. För mikrokontroller som har stöd för `STEPPER_BOTH_EDGE=1` (som rapporteras på raden `MCU config` när console.py startas första gången) använder du `step_pulse_duration=0` och `invert_step=-1` för att aktivera optimerad stegräkning på båda kanter av stegpulsen. För andra mikrokontroller använder du `step_pulse_duration` som motsvarar 100 ns.

### Prestandamätning av steghastighet för AVR

Följande konfigurationssekvens används på AVR-chip:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `avr-gcc (GCC) 5.4.0`. Både testerna på 16 MHz och 20 MHz kördes med simulavr konfigurerad för atmega644p (tidigare tester har bekräftat att resultat från simulavr överensstämmer med tester på både 16 MHz at90usb och 16 MHz atmega2560).

| avr | ticks |
| --- | --- |
| 1 stegmotor | 102 |
| 3 stegmotorer | 486 |

### Prestandamätning av steghastighet för Arduino Due

Följande konfigurationssekvens används på Due:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam3x8e | ticks |
| --- | --- |
| 1 stegmotor | 66 |
| 3 stegmotorer | 257 |

### Prestandamätning av steghastighet för Duet Maestro

Följande konfigurationssekvens används på Duet Maestro:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam4s8c | ticks |
| --- | --- |
| 1 stegmotor | 71 |
| 3 stegmotorer | 260 |

### Prestandamätning av steghastighet för Duet WiFi

Följande konfigurationssekvens används på Duet WiFi:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `gcc version 10.3.1 20210621 (release) (GNU Arm Embedded Toolchain 10.3-2021.07)`.

| sam4e8e | ticks |
| --- | --- |
| 1 stegmotor | 48 |
| 3 stegmotorer | 215 |

### Prestandamätning av steghastighet för Beaglebone PRU

Följande konfigurationssekvens används på PRU:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `pru-gcc (GCC) 8.0.0 20170530 (experimental)`.

| pru | ticks |
| --- | --- |
| 1 stegmotor | 231 |
| 3 stegmotorer | 847 |

### Prestandamätning av steghastighet för STM32F042

Följande konfigurationssekvens används på STM32F042:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f042 | ticks |
| --- | --- |
| 1 stegmotor | 59 |
| 3 stegmotorer | 249 |

### Prestandamätning av steghastighet för STM32F103

Följande konfigurationssekvens används på STM32F103:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f103 | ticks |
| --- | --- |
| 1 stegmotor | 61 |
| 3 stegmotorer | 264 |

### Prestandamätning av steghastighet för STM32F4

Följande konfigurationssekvens används på STM32F4:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. Resultaten för STM32F407 erhölls genom att köra en STM32F407-binärfil på en STM32F446 (och därmed använda en klocka på 168 MHz).

| stm32f446 | ticks |
| --- | --- |
| 1 stegmotor | 46 |
| 3 stegmotorer | 205 |

| stm32f407 | ticks |
| --- | --- |
| 1 stegmotor | 46 |
| 3 stegmotorer | 205 |

### Prestandamätning av steghastighet för STM32H7

Följande konfigurationssekvens används på STM32H723:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=52
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=52
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=52
finalize_config crc=0
```

Testet kördes senast på incheckningen `554ae78d` med GCC-versionen `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0`.

| stm32h723 | ticks |
| --- | --- |
| 1 stegmotor | 70 |
| 3 stegmotorer | 181 |

### Prestandamätning av steghastighet för STM32G0B1

Följande konfigurationssekvens används på STM32G0B1:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB13 dir_pin=PB12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB10 dir_pin=PB2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB0 dir_pin=PC5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `247cd753` med GCC-versionen `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32g0b1 | ticks |
| --- | --- |
| 1 stegmotor | 58 |
| 3 stegmotorer | 243 |

### Prestandamätning av steghastighet för STM32G4

Följande konfigurationssekvens används på STM32G431:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA0 dir_pin=PB5 invert_step=-1 step_pulse_ticks=17
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=17
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=17
finalize_config crc=0
```

Testet kördes senast på incheckningen `cfa48fe3` med GCC-versionen `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0`.

| stm32g431 | ticks |
| --- | --- |
| 1 stegmotor | 47 |
| 3 stegmotorer | 208 |

### Prestandamätning av steghastighet för LPC176x

Följande konfigurationssekvens används på LPC176x:

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. Resultaten för LPC1769 vid 120 MHz erhölls genom att överklocka en LPC1768 till 120 MHz.

| lpc1768 | ticks |
| --- | --- |
| 1 stegmotor | 52 |
| 3 stegmotorer | 222 |

| lpc1769 | ticks |
| --- | --- |
| 1 stegmotor | 51 |
| 3 stegmotorer | 222 |

### Prestandamätning av steghastighet för SAMD21

Följande konfigurationssekvens används på SAMD21:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` på en SAMD21G18-mikrokontroller.

| samd21 | ticks |
| --- | --- |
| 1 stegmotor | 70 |
| 3 stegmotorer | 306 |

### Prestandamätning av steghastighet för SAMD51

Följande konfigurationssekvens används på SAMD51:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` på en SAMD51J19A-mikrokontroller.

| samd51 | ticks |
| --- | --- |
| 1 stegmotor | 39 |
| 3 stegmotorer | 191 |
| 1 stegmotor (200 MHz) | 39 |
| 3 stegmotorer (200 MHz) | 181 |

### Prestandamätning av steghastighet för SAME70

Följande konfigurationssekvens används på SAME70:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC18 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC16 dir_pin=PD10 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC28 dir_pin=PA4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `34e9ea55` med GCC-versionen `arm-none-eabi-gcc (NixOS 10.3-2021.10) 10.3.1` på en SAME70Q20B-mikrokontroller.

| same70 | ticks |
| --- | --- |
| 1 stegmotor | 45 |
| 3 stegmotorer | 190 |

### Prestandamätning av steghastighet för AR100

Följande konfigurationssekvens används på AR100-processorn (Allwinner A64):

```
allocate_oids count=3
config_stepper oid=0 step_pin=PL10 dir_pin=PE14 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PL11 dir_pin=PE15 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PL12 dir_pin=PE16 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `b7978d37` med GCC-versionen `or1k-linux-musl-gcc (GCC) 9.2.0` på en Allwinner A64-H-mikrokontroller.

| AR100 R_PIO | ticks |
| --- | --- |
| 1 stegmotor | 85 |
| 3 stegmotorer | 359 |

### Prestandamätning av steghastighet för RPxxxx

Följande konfigurationssekvens används på RP2040 och RP2350:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Testet kördes senast på incheckningen `14c105b8` med GCC-versionen `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0` på Raspberry Pi Pico- och Pico 2-kort.

| rp2040 (*) | ticks |
| --- | --- |
| 1 stegmotor | 3 |
| 3 stegmotorer | 14 |

| rp2350 | ticks |
| --- | --- |
| 1 stegmotor | 36 |
| 3 stegmotorer | 169 |

(*) Observera att de rapporterade rp2040-ticken är relativa till en schemaläggningstimer på 12 MHz och inte motsvarar den interna ARM-bearbetningshastigheten på 200 MHz. Tre schemaläggningstick förväntas motsvara cirka 42 ARM-kärncykler och 14 schemaläggningstick cirka 225 ARM-kärncykler.

### Prestandamätning av steghastighet för Linux MCU

Följande konfigurationssekvens används på Raspberry Pi:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
finalize_config crc=0
```

Testet kördes senast på incheckningen `59314d99` med GCC-versionen `gcc (Raspbian 8.3.0-6+rpi1) 8.3.0` på en Raspberry Pi 3 (revision a02082). Det var svårt att få stabila resultat i den här prestandamätningen.

| Linux (RPi3) | ticks |
| --- | --- |
| 1 stegmotor | 160 |
| 3 stegmotorer | 380 |

## Prestandamätning av kommandohantering

Prestandamätningen av kommandohantering testar hur många "dummy"-kommandon mikrokontrollern kan bearbeta. Det är i första hand ett test av maskinvarukommunikationsmekanismen. Testet körs med verktyget console.py (beskrivet i <Debugging.md>). Följande klistras in i terminalfönstret för console.py:

```
DELAY {clock + 2*freq} get_uptime
FLOOD 100000 0.0 debug_nop
get_uptime
```

När testet är klart beräknar du skillnaden mellan klockvärdena som rapporteras i de två "uptime"-svarsmeddelandena. Det totala antalet kommandon per sekund är då `100000 * mcu_frequency / clock_diff`.

USB-testerna kan överskrida CPU-kapaciteten på en Raspberry Pi. Om testet körs på en Raspberry Pi, Beaglebone eller liknande värddator ökar du fördröjningen (till exempel `DELAY {clock + 20*freq} get_uptime`). Där så är tillämpligt körs nedanstående prestandamätningar med console.py på en dator av skrivbordsklass och enheten ansluten via en supersnabb hubb.

CAN-busstesterna kan mätta USB-värdstyrenheten på en Raspberry Pi (vid testning via en vanlig gs_usb USB-till-CAN-bussadapter). Där så är tillämpligt körs nedanstående CAN-bussprestandamätningar med console.py på en dator av skrivbordsklass och en USB-till-CAN-bussadapter ansluten via en supersnabb USB-hubb.

| MCU | Hastighet | Bygge | Byggkompilator |
| --- | --- | --- | --- |
| atmega2560 (seriell) | 23 K | b161a69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (seriell) | 23 K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| rp2350 (CAN) | 59 K | 17b8ce4c | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| at90usb1286 (USB) | 75 K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| ar100 (seriell) | 138 K | 08d037c6 | or1k-linux-musl-gcc 9.3.0 |
| samd21 (USB) | 223 K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| pru (delat minne) | 260 K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (experimentell) |
| stm32f103 (USB) | 355 K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418 K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB) | 534 K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB) | 628 K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650 K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864 K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB) | 870 K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 885 K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| rp2350 (USB) | 885 K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |

## Prestandamätningar för värden

Det går att köra tidstester på värdprogramvaran med bearbetningsmekanismen "batch mode" (beskriven i <Debugging.md>). Vanligtvis görs detta genom att välja en stor och komplex G-kodfil och mäta hur lång tid värdprogramvaran behöver för att bearbeta den. Exempel:

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
