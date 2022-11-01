# Benchmark

Questo documento descrive i benchmark di Klipper.

## Benchmark del microcontrollore

Questa sezione descrive il meccanismo utilizzato per generare i benchmark della velocità di passaggio del microcontrollore Klipper.

L'obiettivo principale dei benchmark è fornire un meccanismo coerente per misurare l'impatto delle modifiche alla codifica all'interno del software. Un obiettivo secondario è fornire metriche di alto livello per confrontare le prestazioni tra i chip e tra le piattaforme software.

Il benchmark dello step rate è progettato per trovare la velocità di stepping massima che l'hardware e il software possono raggiungere. Questa velocità di stepping del benchmark non è raggiungibile nell'uso quotidiano poiché Klipper ha bisogno di eseguire altre attività (ad esempio, comunicazione mcu/host, lettura della temperatura, controllo endstop) in qualsiasi utilizzo nel mondo reale.

In generale, i pin per i test di benchmark sono scelti per far lampeggiare LED o altri pin innocui. **Verifica sempre che sia sicuro guidare i pin configurati prima di eseguire un benchmark.** Non è consigliabile pilotare uno stepper reale durante un benchmark.

### Test di riferimento della frequenza di passi

Il test viene eseguito utilizzando lo strumento console.py (descritto in <Debugging.md>). Il microcontrollore è configurato per la particolare piattaforma hardware (vedi sotto) e quindi quanto segue viene tagliato e incollato nella finestra del terminale console.py:

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

Quanto sopra testa tre stepper che fanno un passo simultaneo. Se l'esecuzione di quanto sopra comporta un errore "Rescheduled timer in the past" o "Stepper too far in past", indica che il parametro `ticks` è troppo basso (risulta in una velocità di incremento troppo veloce). L'obiettivo è trovare l'impostazione più bassa del parametro tick che si traduca in modo affidabile in un completamento positivo del test. Dovrebbe essere possibile dividere in due il parametro tick fino a trovare un valore stabile.

In caso di errore, è possibile copiare e incollare quanto segue per cancellare l'errore in preparazione per il test successivo:

```
clear_shutdown
```

Per ottenere i benchmark del singolo stepper, viene utilizzata la stessa sequenza di configurazione, ma solo il primo blocco del test precedente viene tagliato e incollato nella finestra di console.py.

Per produrre i benchmark trovati nel documento [Features](Features.md), il numero totale di passi al secondo viene calcolato moltiplicando il numero di stepper attivi per la frequenza nominale mcu e dividendo per il parametro tick finale. I risultati vengono arrotondati alla K più vicina. Ad esempio, con tre stepper attivi:

```
ECHO Test result is: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

I benchmark vengono eseguiti con parametri adatti ai driver TMC. Per i microcontrollori che supportano `STEPPER_BOTH_EDGE=1` (come riportato nella riga `MCU config` al primo avvio di console.py) usa `step_pulse_duration=0` e `invert_step=-1` per abilitare lo stepping ottimizzato su entrambi i bordi del impulso di passo. Per altri microcontrollori usa un `step_pulse_duration` corrispondente a 100ns.

### Benchmark rateo passi AVR

La seguente sequenza di configurazione viene utilizzata sui chip AVR:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `avr-gcc (GCC) 5.4.0`. Entrambi i test a 16Mhz e 20Mhz sono stati eseguiti utilizzando simulavr configurato per un atmega644p (i test precedenti hanno confermato i risultati del simulavr match test su entrambi un 16Mhz at90usb e un 16Mhz atmega2560).

| avr | ticks |
| --- | --- |
| 1 stepper | 102 |
| 3 stepper | 486 |

### Benchmark rateo passi Arduino Due

Sul Due viene utilizzata la seguente sequenza di configurazione:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam3x8e | ticks |
| --- | --- |
| 1 stepper | 66 |
| 3 stepper | 257 |

### Benchmark step rate Duet Maestro

La seguente sequenza di configurazione viene utilizzata su Duet Maestro:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam4s8c | ticks |
| --- | --- |
| 1 stepper | 71 |
| 3 stepper | 260 |

### Benchmark step rate Duet Wifi

La seguente sequenza di configurazione viene utilizzata su Duet Wifi:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con gcc versione `gcc versione 10.3.1 20210621 (rilascio) (GNU Arm Embedded Toolchain 10.3-2021.07)`.

| sam4e8e | ticks |
| --- | --- |
| 1 stepper | 48 |
| 3 stepper | 215 |

### Benchmark step rate Beaglebone PRU

Sulla PRU viene utilizzata la seguente sequenza di configurazione:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `pru-gcc (GCC) 8.0.0 20170530 (sperimentale)`.

| pru | ticks |
| --- | --- |
| 1 stepper | 231 |
| 3 stepper | 847 |

### Benchmark step rate STM32F042

La seguente sequenza di configurazione viene utilizzata sull'STM32F042:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f042 | ticks |
| --- | --- |
| 1 stepper | 59 |
| 3 stepper | 249 |

### Benchmark step rate STM32F103

Sull'STM32F103 viene utilizzata la seguente sequenza di configurazione:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f103 | ticks |
| --- | --- |
| 1 stepper | 61 |
| 3 stepper | 264 |

### Benchmark step rate STM32F4

Sull'STM32F4 viene utilizzata la seguente sequenza di configurazione:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. I risultati dell'STM32F407 sono stati ottenuti eseguendo un binario STM32F407 su un STM32F446 (e quindi utilizzando un clock a 168 Mhz).

| stm32f446 | ticks |
| --- | --- |
| 1 stepper | 46 |
| 3 stepper | 205 |

| stm32f407 | ticks |
| --- | --- |
| 1 stepper | 46 |
| 3 stepper | 205 |

### STM32H7 benchmark della velocità di step

La seguente sequenza di configurazione viene utilizzata su un STM32H743VIT6:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD4 dir_pin=PD3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA15 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PE2 dir_pin=PE3 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `00191b5c` con versione gcc `arm-none-eabi-gcc (15:8-2019-q3-1+b1) 8.3.1 20190703 (release) [gcc-8-branch revisione 273027] `.

| stm32h7 | ticks |
| --- | --- |
| 1 stepper | 44 |
| 3 stepper | 198 |

### Benchmark step rate STM32G0B1

Sull'STM32G0B1 viene utilizzata la seguente sequenza di configurazione:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB13 dir_pin=PB12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB10 dir_pin=PB2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB0 dir_pin=PC5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `247cd753` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32g0b1 | ticks |
| --- | --- |
| 1 stepper | 58 |
| 3 stepper | 243 |

### Benchmark step rate LPC176x

La seguente sequenza di configurazione viene utilizzata sull'LPC176x:

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. I risultati a 120 Mhz LPC1769 sono stati ottenuti overclockando un LPC1768 a 120 Mhz.

| lpc1768 | ticks |
| --- | --- |
| 1 stepper | 52 |
| 3 stepper | 222 |

| lpc1769 | ticks |
| --- | --- |
| 1 stepper | 51 |
| 3 stepper | 222 |

### Benchmark step rate SAMD21

La seguente sequenza di configurazione viene utilizzata sul SAMD21:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` su un microcontrollore SAMD21G18.

| samd21 | ticks |
| --- | --- |
| 1 stepper | 70 |
| 3 stepper | 306 |

### Benchmark step rate SAMD51

La seguente sequenza di configurazione viene utilizzata sul SAMD51:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` su un microcontrollore SAMD51J19A.

| samd51 | ticks |
| --- | --- |
| 1 stepper | 39 |
| 3 stepper | 191 |
| 1 stepper (200Mhz) | 39 |
| 3 stepper (200Mhz) | 181 |

### Benchmark step rate RP2040

Sull'RP2040 viene utilizzata la seguente sequenza di configurazione:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` su una scheda Raspberry Pi Pico.

| rp2040 | ticks |
| --- | --- |
| 1 stepper | 5 |
| 3 stepper | 22 |

### Benchmark step rate MCU Linux

La seguente sequenza di configurazione viene utilizzata su un Raspberry Pi:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
finalize_config crc=0
```

Il test è stato eseguito l'ultima volta su commit `59314d99` con versione gcc `gcc (Raspbian 8.3.0-6+rpi1) 8.3.0` su un Raspberry Pi 3 (revisione a02082). È stato difficile ottenere risultati stabili in questo benchmark.

| Linux (RPi3) | ticks |
| --- | --- |
| 1 stepper | 160 |
| 3 stepper | 380 |

## Benchmark dispacciamento comandi

Il benchmark di invio dei comandi verifica quanti comandi "fittizi" possono elaborare il microcontrollore. È principalmente un test del meccanismo di comunicazione hardware. Il test viene eseguito utilizzando lo strumento console.py (descritto in <Debugging.md>). Quanto segue è taglia e incolla nella finestra del terminale console.py:

```
DELAY {clock + 2*freq} get_uptime
FLOOD 100000 0.0 debug_nop
get_uptime
```

Al termine del test, determinare la differenza tra gli orologi riportati nei due messaggi di risposta "uptime". Il numero totale di comandi al secondo è quindi `100000 * mcu_frequency / clock_diff`.

Nota che questo test potrebbe saturare la capacità USB/CPU di un Raspberry Pi. Se è in esecuzione su un computer host Raspberry Pi, Beaglebone o simile, aumenta il ritardo (ad esempio, `DELAY {clock + 20*freq} get_uptime`). Ove applicabile, i benchmark seguenti riguardano console.py in esecuzione su una macchina di classe desktop con il dispositivo connesso tramite un hub ad alta velocità.

| MCU | Rateo | Build | Build compiler |
| --- | --- | --- | --- |
| stm32f042 (CAN) | 18K | c105adc8 | arm-none-eabi-gcc (GNU Tools 7-2018-q3-update) 7.3.1 |
| atmega2560 (serial) | 23K | b161a69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (serial) | 23K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| at90usb1286 (USB) | 75K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| samd21 (USB) | 223K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| pru (shared memory) | 260K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (experimental) |
| stm32f103 (USB) | 355K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB) | 534K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB) | 628K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB) | 870K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 873K | c5667193 | arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0 |

## Benchmark Host

È possibile eseguire test di temporizzazione sul software host utilizzando il meccanismo di elaborazione "batch mode" (descritto in <Debugging.md>). Questo viene in genere fatto scegliendo un file G-Code grande e complesso e calcolando il tempo impiegato dal software host per elaborarlo. Per esempio:

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
