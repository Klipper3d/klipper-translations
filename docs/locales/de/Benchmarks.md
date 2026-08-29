# Benchmarks

Dieses Dokument beschreibt die Klipper-Benchmarks.

## Mikrocontroller-Benchmarks

Dieser Abschnitt beschreibt den genutzten Mechanismus für die Ermittlung der maximalen Schrittrate der Mikrocontroller.

Das primäre Ziel des Benchmarks ist, einen gleichbleibenden Mechanismus zur Ermittlung der Einflüsse durch Codeänderungen in der Software. Das sekundäre Ziel ist, High-Level Messdaten zum Vergleich der Performance zwischen verschiedenen Chips und Software Plattformen zu ermitteln.

Der Schrittraten Benchmark ist designed um die maximalen Schrittraten der Hard und Software zu ermitteln. Der Schrittraten Benchmark ist nicht für den täglichen Gebrauch vorgesehen da Klipper auch andere Vorgänge (z.B. MCU/Host Kommunikation, Temperatur Erfassung, überprüfung der Endschalter etc) ver- bzw bearbeitet.

Grundsätzlich sind die Pins des Benchmark Tests für die Ansteuerung von z.B LED's oder anderen nicht kritischen Vorgängen gedacht. ** Vergewissern Sie sich, dass es sicher ist die konfigurierten Pins im Benchmark zu benutzen bevor der Benchmark gestartet wird.** Es ist nicht empfehlenswert einen Schrittmotor mit dem Benchmarks zu betreiben.

### Schrittraten Benchmark Test

Der Test wird mit dem Werkzeug console.py durchgeführt (beschrieben in <Debugging.md>). Der Mikrocontroller wird für die jeweilige Hardwareplattform konfiguriert (siehe unten) und anschließend wird Folgendes in das Terminalfenster von console.py kopiert:

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

Der obige Vorgang testet drei gleichzeitig arbeitende Schrittmotoren. Endet der Test mit einem Fehler wie "Rescheduled timer in the past" oder "Stepper too far in past", deutet dies auf einen zu niedrigen Wert des Parameters `ticks` hin (die resultierende Schrittrate ist zu hoch). Ziel ist es, den niedrigsten Wert des ticks-Parameters zu finden, mit dem der Test zuverlässig erfolgreich durchläuft. Der Wert lässt sich durch Intervallhalbierung eingrenzen, bis ein stabiler Wert gefunden ist.

Bei Fehlschlagen, fügen Sie das folgende ein um den Error zu bestätigen und zu löschen um den Test erneut durchzuführen:

```
clear_shutdown
```

Um den Einzel Schrittmotor Benchmark durchzuführen, wird die selbe Konfigurations Sequenz verwendet und nur der erste Block des obigen Tests in das console.py Fenster eingefügt.

Um die im Dokument [Features](Features.md) angegebenen Leistungswerte zu erhalten, wird die Gesamtzahl der Schritte pro Sekunde berechnet, indem die Anzahl der aktiven Schrittmotoren mit der nominellen MCU-Frequenz multipliziert und durch den endgültigen ticks-Parameter geteilt wird. Die Ergebnisse werden auf volle Tausend (K) gerundet. Zum Beispiel bei drei aktiven Schrittmotoren:

```
ECHO Test result is: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

Die Leistungstests werden mit für TMC-Treiber geeigneten Parametern durchgeführt. Bei Mikrocontrollern, die `STEPPER_BOTH_EDGE=1` unterstützen (angezeigt in der Zeile `MCU config` beim Start von console.py), verwenden Sie `step_pulse_duration=0` und `invert_step=-1`, um optimiertes Schalten an beiden Flanken des Schrittimpulses zu aktivieren. Bei anderen Mikrocontrollern verwenden Sie eine `step_pulse_duration` entsprechend 100 ns.

### AVR Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei AVR Chips verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `avr-gcc (GCC) 5.4.0` ausgeführt. Sowohl der 16-MHz- als auch der 20-MHz-Test wurden mit simulavr in der Konfiguration für einen atmega644p durchgeführt (frühere Tests haben bestätigt, dass die simulavr-Ergebnisse mit Tests an einem 16-MHz-at90usb und einem 16-MHz-atmega2560 übereinstimmen).

| AVR | ticks |
| --- | --- |
| 1 Schrittmotor | 102 |
| 3 Schrittmotoren | 486 |

### Arduino Due Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei Due verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` ausgeführt.

| SAM3x8e | ticks |
| --- | --- |
| 1 Schrittmotor | 66 |
| 3 Schrittmotoren | 257 |

### Duet Maestro Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei Duet Maestro verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` ausgeführt.

| SAM4s8c | ticks |
| --- | --- |
| 1 Schrittmotor | 71 |
| 3 Schrittmotoren | 260 |

### Duet Wifi Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei Duet WiFi verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `gcc version 10.3.1 20210621 (release) (GNU Arm Embedded Toolchain 10.3-2021.07)` ausgeführt.

| SAM4e8e | ticks |
| --- | --- |
| 1 Schrittmotor | 48 |
| 3 Schrittmotoren | 215 |

### Beaglebone PRU Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei PRU verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `pru-gcc (GCC) 8.0.0 20170530 (experimental)` ausgeführt.

| PRU | ticks |
| --- | --- |
| 1 Schrittmotor | 231 |
| 3 Schrittmotoren | 847 |

### STM32F042 Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei STM32F042 verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` ausgeführt.

| STM32F042 | ticks |
| --- | --- |
| 1 Schrittmotor | 59 |
| 3 Schrittmotoren | 249 |

### STM32F103 Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei STM32F103 verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` ausgeführt.

| STM32F103 | ticks |
| --- | --- |
| 1 Schrittmotor | 61 |
| 3 Schrittmotoren | 264 |

### STM32F4 Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei STM32F4 verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` ausgeführt. Die Ergebnisse für den STM32F407 wurden erzielt, indem ein STM32F407-Binary auf einem STM32F446 ausgeführt wurde (und damit mit einem 168-MHz-Takt).

| STM32F446 | ticks |
| --- | --- |
| 1 Schrittmotor | 46 |
| 3 Schrittmotoren | 205 |

| STM32F407 | ticks |
| --- | --- |
| 1 Schrittmotor | 46 |
| 3 Schrittmotoren | 205 |

### STM32H7 Schrittraten-Leistungstest

Auf dem STM32H723 wird die folgende Konfigurationssequenz verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=52
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=52
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=52
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `554ae78d` und gcc-Version `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0` ausgeführt.

| stm32h723 | ticks |
| --- | --- |
| 1 Schrittmotor | 70 |
| 3 Schrittmotoren | 181 |

### STM32G0B1 Schrittraten-Leistungstest

Auf dem STM32G0B1 wird die folgende Konfigurationssequenz verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB13 dir_pin=PB12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB10 dir_pin=PB2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB0 dir_pin=PC5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `247cd753` und gcc-Version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` ausgeführt.

| stm32g0b1 | ticks |
| --- | --- |
| 1 Schrittmotor | 58 |
| 3 Schrittmotoren | 243 |

### STM32G4 Schrittraten-Leistungstest

Auf dem STM32G431 wird die folgende Konfigurationssequenz verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA0 dir_pin=PB5 invert_step=-1 step_pulse_ticks=17
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=17
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=17
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `cfa48fe3` und gcc-Version `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0` ausgeführt.

| stm32g431 | ticks |
| --- | --- |
| 1 Schrittmotor | 47 |
| 3 Schrittmotoren | 208 |

### LPC176x Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei LPC176x verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` ausgeführt. Die Ergebnisse für den LPC1769 mit 120 MHz wurden durch Übertakten eines LPC1768 auf 120 MHz erzielt.

| LPC1768 | ticks |
| --- | --- |
| 1 Schrittmotor | 52 |
| 3 Schrittmotoren | 222 |

| LPC1769 | ticks |
| --- | --- |
| 1 Schrittmotor | 51 |
| 3 Schrittmotoren | 222 |

### SAMD21 Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei SAMD21 verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` auf einem SAMD21G18-Mikrocontroller ausgeführt.

| SAMD21 | ticks |
| --- | --- |
| 1 Schrittmotor | 70 |
| 3 Schrittmotoren | 306 |

### SAMD51 Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei SAMD51 verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` auf einem SAMD51J19A-Mikrocontroller ausgeführt.

| SAMD51 | ticks |
| --- | --- |
| 1 Schrittmotor | 39 |
| 3 Schrittmotoren | 191 |
| 1 Schrittmotor (200Mhz) | 39 |
| 3 Schrittmotoren (200Mhz) | 181 |

### SAME70 Schrittraten-Leistungstest

Auf dem SAME70 wird die folgende Konfigurationssequenz verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC18 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC16 dir_pin=PD10 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC28 dir_pin=PA4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `34e9ea55` und gcc-Version `arm-none-eabi-gcc (NixOS 10.3-2021.10) 10.3.1` auf einem SAME70Q20B-Mikrocontroller ausgeführt.

| same70 | ticks |
| --- | --- |
| 1 Schrittmotor | 45 |
| 3 Schrittmotoren | 190 |

### AR100 Schrittraten-Leistungstest

Auf der AR100-CPU (Allwinner A64) wird die folgende Konfigurationssequenz verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PL10 dir_pin=PE14 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PL11 dir_pin=PE15 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PL12 dir_pin=PE16 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `b7978d37` und gcc-Version `or1k-linux-musl-gcc (GCC) 9.2.0` auf einem Allwinner-A64-H-Mikrocontroller ausgeführt.

| AR100 R_PIO | ticks |
| --- | --- |
| 1 Schrittmotor | 85 |
| 3 Schrittmotoren | 359 |

### RPxxxx Schrittraten-Leistungstest

Auf dem RP2040 und dem RP2350 wird die folgende Konfigurationssequenz verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `14c105b8` und gcc-Version `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0` auf Raspberry Pi Pico und Pico 2 ausgeführt.

| rp2040 (*) | ticks |
| --- | --- |
| 1 Schrittmotor | 3 |
| 3 Schrittmotoren | 14 |

| rp2350 | ticks |
| --- | --- |
| 1 Schrittmotor | 36 |
| 3 Schrittmotoren | 169 |

(*) Beachten Sie, dass sich die angegebenen rp2040-Ticks auf einen 12-MHz-Planungstimer beziehen und nicht der internen ARM-Verarbeitungsrate von 200 MHz entsprechen. Es ist zu erwarten, dass 3 Planungsticks etwa 42 ARM-Kerntakten und 14 Planungsticks etwa 225 ARM-Kerntakten entsprechen.

### Linux MCU Schrittraten Benchmark

Die nachfolgende Konfiguration wird bei einem Raspberry Pi verwendet:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
finalize_config crc=0
```

Der Test wurde zuletzt mit Commit `59314d99` und gcc-Version `gcc (Raspbian 8.3.0-6+rpi1) 8.3.0` auf einem Raspberry Pi 3 (Revision a02082) ausgeführt. Es war schwierig, in diesem Leistungstest stabile Ergebnisse zu erzielen.

| Linux (RPi3) | ticks |
| --- | --- |
| 1 Schrittmotor | 160 |
| 3 Schrittmotoren | 380 |

## Leistungstest der Befehlsabarbeitung

Der Leistungstest der Befehlsabarbeitung prüft, wie viele "Dummy"-Befehle der Mikrocontroller verarbeiten kann. Er ist in erster Linie ein Test des Kommunikationsmechanismus der Hardware. Der Test wird mit dem Werkzeug console.py durchgeführt (beschrieben in <Debugging.md>). Folgendes wird in das Terminalfenster von console.py kopiert:

```
DELAY {clock + 2*freq} get_uptime
FLOOD 100000 0.0 debug_nop
get_uptime
```

Ist der Test abgeschlossen, berechnen Sie die Differenz zwischen den beiden clocks in den "uptime" Antwortnachrichten `clock_diff`. Die Gesamt Nachrichtenanzahl pro Sekunde wird wie folgt berechnet `100000 * mcu_frequency / clock_diff`.

Die USB-Tests können die CPU-Kapazität eines Raspberry Pi übersteigen. Wenn Sie auf einem Raspberry Pi, einem Beaglebone oder einem ähnlichen Host-Rechner testen, erhöhen Sie die Verzögerung (z. B. `DELAY {clock + 20*freq} get_uptime`). Die nachfolgenden Leistungstests wurden, soweit zutreffend, mit console.py auf einem Desktop-Rechner durchgeführt, wobei das Gerät über einen SuperSpeed-Hub angeschlossen war.

Die CAN-Bus-Tests können den USB-Host-Controller eines Raspberry Pi auslasten (beim Test über einen üblichen gs_usb-USB-zu-CAN-Bus-Adapter). Die nachfolgenden CAN-Bus-Leistungstests wurden, soweit zutreffend, mit console.py auf einem Desktop-Rechner durchgeführt, wobei ein USB-zu-CAN-Bus-Adapter über einen SuperSpeed-USB-Hub angeschlossen war.

| MCU | Rate | Bau | Build Compiler |
| --- | --- | --- | --- |
| ATMEGA2560 (serial) | 23K | b161a69e | avr-gcc (GCC) 4.8.1 |
| SAM3x8e (serial) | 23K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| rp2350 (CAN) | 59K | 17b8ce4c | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| at90usb1286 (USB) | 75K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| AR100 (serial) | 138K | 08d037c6 | or1k-linux-musl-gcc 9.3.0 |
| samd21 (USB) | 223K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| pru (gemeinsam genutzter Speicher) | 260K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (experimentel) |
| stm32f103 (USB) | 355K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB) | 534K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB) | 628K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB) | 870K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| rp2350 (USB) | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |

## Host Benchmarks

Mit dem Mechanismus der "Stapelverarbeitung" (beschrieben in <Debugging.md>) lassen sich Zeitmessungen an der Host-Software durchführen. Üblicherweise wählt man dafür eine große und komplexe G-Code-Datei und misst, wie lange die Host-Software für deren Verarbeitung benötigt. Zum Beispiel:

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
