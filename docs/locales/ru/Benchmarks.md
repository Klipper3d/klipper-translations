# Бенчмарки

В этом документе описываются эталонные тесты Klipper.

## Тесты микроконтроллеров

В этом разделе описывается механизм, используемый для создания тестов скорости шага микроконтроллера Klipper.

Основная цель оценок состоит в том, чтобы обеспечить последовательный механизм для измерения влияния кодирования изменений в рамках программного обеспечения. Вторая цель — предоставить высокоуровневые показатели для сравнения производительности чипов и программных платформ.

Эталон скорости шага предназначен для определения максимальной скорости шага, которую может достичь аппаратное и программное обеспечение. Эта эталонная пошаговая скорость недостижима при повседневном использовании, поскольку Klipper необходимо выполнять другие задачи (например, связь между микроконтроллером и хостом, считывание температуры, проверка конечной остановки) при любом реальном использовании.

Обычно для эталонных тестов выбирают пины, на которых будут мигать светодиоды или другие безобидные пины. **Всегда проверяйте безопасность управления сконфигурированными контактами перед запуском эталонного теста.** Не рекомендуется управлять реальным степпером во время эталонного теста.

### Эталонный тест скорости шага

Тест выполняется с помощью инструмента console.py (описан в <Debugging.md>). Микроконтроллер конфигурируется под конкретную аппаратную платформу (см. ниже), а затем в окно терминала console.py вставляется следующий текст:

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

Вышеуказанные испытания осуществляют одновременно трех шаговых двигателей. Если в результате выполнения вышеперечисленного возникает ошибка «Rescheduled timer in the past» или «Stepper too far in past», то это указывает на то, что параметр `ticks` слишком мал (это приводит к слишком быстрой скорости пошагового изменения). Цель состоит в том, чтобы найти наименьшее значение параметра засечки, которое надежно приводит к успешному завершению теста. Параметр засечек можно делить пополам до тех пор, пока не будет найдено стабильное значение.

В случае сбоя можно скопировать и вставить следующее, чтобы устранить ошибку при подготовке к следующему тесту:

```
clear_shutdown
```

Для получения бенчмарков одиночного шага используется та же последовательность конфигурации, но в окно console.py вырезается и вставляется только первый блок приведенного выше теста.

Для получения эталонов, приведенных в документе [Features](Features.md), общее количество шагов в секунду рассчитывается путем умножения числа активных степперов на номинальную частоту mcu и деления на параметр final ticks. Результаты округляются до ближайшего К. Например, при трех активных шаговиках:

```
ECHO Результат теста: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

Бенчмарки запускаются с параметрами, подходящими для TMC-драйверов. Для микроконтроллеров, поддерживающих `STEPPER_BOTH_EDGE=1` (как сообщается в строке `MCU config` при первом запуске console.py), используйте `step_pulse_duration=0` и `invert_step=-1`, чтобы включить оптимизированный степпинг по обоим фронтам шагового импульса. Для других микроконтроллеров используйте `step_pulse_duration`, соответствующую 100 нс.

### Тест скорости шага AVR

На микросхемах AVR используется следующая последовательность конфигурации:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
finalize_config crc=0
```

Последний раз тест был запущен на коммите `59314d99` с gcc версии `avr-gcc (GCC) 5.4.0`. Тесты на 16 и 20 МГц проводились с использованием simulavr, настроенного на atmega644p (предыдущие тесты подтвердили, что результаты simulavr совпадают с тестами на 16 МГц at90usb и 16 МГц atmega2560).

| avr | клещи |
| --- | --- |
| 1 шаговый двигатель | 102 |
| 3 шаговых двигателя | 486 |

### Тест скорости шага Arduino Due

На Due используется следующая последовательность настройки:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест выполнялся на коммите `59314d99` с gcc версии `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam3x8e | клещи |
| --- | --- |
| 1 шаговый двигатель | 66 |
| 3 шаговых двигателя | 257 |

### Тест скорости шага Duet Maestro

В Duet Maestro используется следующая последовательность настройки:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест выполнялся на коммите `59314d99` с gcc версии `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam4s8c | клещи |
| --- | --- |
| 1 шаговый двигатель | 71 |
| 3 шаговых двигателя | 260 |

### Тест скорости шага Duet Wifi

В Duet Wifi используется следующая последовательность настройки:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест выполнялся на коммите `59314d99` с версией gcc `gcc версии 10.3.1 20210621 (release) (GNU Arm Embedded Toolchain 10.3-2021.07)`.

| sam4e8e | клещи |
| --- | --- |
| 1 шаговый двигатель | 48 |
| 3 шаговых двигателя | 215 |

### Тест скорости шага Beaglebone PRU

На PRU используется следующая последовательность конфигурации:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
finalize_config crc=0
```

Последний раз тест был запущен на коммите `59314d99` с gcc версии `pru-gcc (GCC) 8.0.0 20170530 (experimental)`.

| pru | клещи |
| --- | --- |
| 1 шаговый двигатель | 231 |
| 3 шаговых двигателя | 847 |

### Тест скорости шага STM32F042

В STM32F042 используется следующая последовательность настройки:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест выполнялся на коммите `59314d99` с gcc версии `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f042 | клещи |
| --- | --- |
| 1 шаговый двигатель | 59 |
| 3 шаговых двигателя | 249 |

### Тест скорости шага STM32F103

В STM32F103 используется следующая последовательность настройки:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест выполнялся на коммите `59314d99` с gcc версии `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f103 | клещи |
| --- | --- |
| 1 шаговый двигатель | 61 |
| 3 шаговых двигателя | 264 |

### Тест скорости шага STM32F4

В STM32F4 используется следующая последовательность конфигурации:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест выполнялся на коммите `59314d99` с gcc версии `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. Результаты для STM32F407 были получены путем запуска бинарного файла STM32F407 на STM32F446 (и, таким образом, с использованием тактовой частоты 168 МГц).

| stm32f446 | клещи |
| --- | --- |
| 1 шаговый двигатель | 46 |
| 3 шаговых двигателя | 205 |

| stm32f407 | клещи |
| --- | --- |
| 1 шаговый двигатель | 46 |
| 3 шаговых двигателя | 205 |

### Эталонный образец частоты шагов STM32H7

The following configuration sequence is used on STM32H723:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=52
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=52
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=52
finalize_config crc=0
```

The test was last run on commit `554ae78d` with gcc version `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0`.

| stm32h723 | клещи |
| --- | --- |
| 1 шаговый двигатель | 70 |
| 3 шаговых двигателя | 181 |

### Эталонный образец частоты шагов STM32G0B1

Для STM32G0B1 используется следующая последовательность конфигурирования:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB13 dir_pin=PB12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB10 dir_pin=PB2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB0 dir_pin=PC5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест выполнялся на коммите `247cd753` с gcc версии `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32g0b1 | клещи |
| --- | --- |
| 1 шаговый двигатель | 58 |
| 3 шаговых двигателя | 243 |

### Тест скорости шага LPC176x

В LPC176x используется следующая последовательность конфигурации:

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест выполнялся на коммите `59314d99` с gcc версии `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. Результаты 120 МГц LPC1769 были получены путем разгона LPC1768 до 120 МГц.

| lpc1768 | клещи |
| --- | --- |
| 1 шаговый двигатель | 52 |
| 3 шаговых двигателя | 222 |

| lpc1769 | клещи |
| --- | --- |
| 1 шаговый двигатель | 51 |
| 3 шаговых двигателя | 222 |

### Контрольный показатель скорости шага SAMD21

Для SAMD21 используется следующая последовательность настройки:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест был выполнен на коммите `59314d99` с gcc версии `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` на микроконтроллере SAMD21G18.

| samd21 | клещи |
| --- | --- |
| 1 шаговый двигатель | 70 |
| 3 шаговых двигателя | 306 |

### Эталонный показатель частоты шагов SAMD51

Для SAMD51 используется следующая последовательность настройки:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Последний раз тест был выполнен на коммите `59314d99` с gcc версии `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` на микроконтроллере SAMD51J19A.

| samd51 | клещи |
| --- | --- |
| 1 шаговый двигатель | 39 |
| 3 шаговых двигателя | 191 |
| 1 шаговый механизм (200 МГц) | 39 |
| 3 шаговика (200 МГц) | 181 |

### SAME70 step rate benchmark

The following configuration sequence is used on the SAME70:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC18 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC16 dir_pin=PD10 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC28 dir_pin=PA4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `34e9ea55` with gcc version `arm-none-eabi-gcc (NixOS 10.3-2021.10) 10.3.1` on a SAME70Q20B micro-controller.

| same70 | клещи |
| --- | --- |
| 1 шаговый двигатель | 45 |
| 3 шаговых двигателя | 190 |

### Эталонный показатель скорости шага AR100

Для процессора AR100 (Allwinner A64) используется следующая последовательность конфигурирования:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PL10 dir_pin=PE14 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PL11 dir_pin=PE15 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PL12 dir_pin=PE16 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `b7978d37` with gcc version `or1k-linux-musl-gcc (GCC) 9.2.0` on an Allwinner A64-H micro-controller.

| AR100 R_PIO | клещи |
| --- | --- |
| 1 шаговый двигатель | 85 |
| 3 шаговых двигателя | 359 |

### RPxxxx step rate benchmark

The following configuration sequence is used on the RP2040 and RP2350:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `14c105b8` with gcc version `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0` on Raspberry Pi Pico and Pico 2 boards.

| rp2040 (*) | клещи |
| --- | --- |
| 1 шаговый двигатель | 3 |
| 3 шаговых двигателя | 14 |

| rp2350 | клещи |
| --- | --- |
| 1 шаговый двигатель | 36 |
| 3 шаговых двигателя | 169 |

(*) Note that the reported rp2040 ticks are relative to a 12Mhz scheduling timer and do not correspond to its 200Mhz internal ARM processing rate. It is expected that 5 scheduling ticks corresponds to ~42 ARM core cycles and 14 scheduling ticks corresponds to ~225 ARM core cycles.

### Эталонный образец частоты шагов для Linux MCU

Следующая последовательность конфигурации используется на Raspberry Pi:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
finalize_config crc=0
```

Последний раз тест выполнялся на коммите `59314d99` с gcc версии `gcc (Raspbian 8.3.0-6+rpi1) 8.3.0` на Raspberry Pi 3 (ревизия a02082). В этом бенчмарке было сложно получить стабильные результаты.

| Linux (RPi3) | клещи |
| --- | --- |
| 1 шаговый двигатель | 160 |
| 3 шаговых двигателя | 380 |

## Эталон командной диспетчерской службы

Контрольный тест на диспетчеризацию команд проверяет, сколько "фиктивных" команд может обработать микроконтроллер. Это, прежде всего, тест аппаратного механизма связи. Тест выполняется с помощью инструмента console.py (описан в <Debugging.md>). Нижеприведенный текст вырезается и вставляется в окно терминала console.py:

```
ЗАДЕРЖКА {часы + 2*частота} get_uptime
ПОТОК 100000 0.0 debug_nop
get_uptime
```

По завершении теста определите разницу между часами, указанными в двух ответных сообщениях "uptime". Общее количество команд в секунду равно `100000 * mcu_frequency / clock_diff`.

Обратите внимание, что этот тест может насытить USB/CPU Raspberry Pi. Если тест выполняется на Raspberry Pi, Beaglebone или аналогичном хост-компьютере, увеличьте задержку (например, `DELAY {clock + 20*freq} get_uptime`). Там, где это применимо, ниже приведены контрольные показатели с запуском console.py на настольной машине класса с устройством, подключенным через высокоскоростной концентратор.

| MCU | Тариф | Сборка | Сборка компилятора |
| --- | --- | --- | --- |
| stm32f042 (CAN) | 18K | c105adc8 | arm-none-eabi-gcc (GNU Инструменты 7-2018-q3-обновление) 7.3.1 |
| atmega2560 (серийный) | 23K | b161a69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (серийный) | 23K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| at90usb1286 (USB) | 75K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| ar100 (серийный) | 138K | 08d037c6 | or1k-linux-musl-gcc 9.3.0 |
| samd21 (USB) | 223K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| pru (общая память) | 260K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (экспериментальный) |
| stm32f103 (USB) | 355K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB) | 534K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB) | 628K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB) | 870K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| rp2350 (USB) | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |

## Контрольные показатели хоста

Можно запустить тесты времени на хост-программе, используя механизм обработки в "пакетном режиме" (описан в <Debugging.md>). Обычно для этого выбирают большой и сложный файл G-кода и засекают время, которое требуется хост-программе для его обработки. Например:

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
