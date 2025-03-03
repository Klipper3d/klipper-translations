# Бенчмарки

Цей документ описує бендикти Klipper.

## Мікроконтролер бенчмарки

Цей розділ описує механізм, який використовується для створення мікроконтролерів Klipper.

Основною метою оцінки є забезпечення послідовного механізму вимірювання впливу змін кодування в програмному забезпеченні. Другою метою є забезпечення високорівневої метрики для порівняння продуктивності між чіпами та між програмними платформами.

Поетапний еталон призначений для пошуку максимальної швидкості крокування, яка може досягати обладнання та програмного забезпечення. Ця еталонна швидкість крокування не є обов'язковою в день-до дня використання як Klipper вимагає виконання інших завдань (наприклад, mcu/host спілкування, читання температури, перевірка кінцевих точок) в будь-якому режимі реального використання.

В цілому, штифти для бендикційних тестів вибираються для спалаху світлодіодів або інших ненуклеозних штифтів. **Always Перевірте, що він безпечний для приводу налаштованих штифтів до запуску бенчмарка ** Не рекомендується приводити фактичний кроковий апарат під час бенчмарка.

### Тест еталона кроку

Тест виконується за допомогою консолі. py інструмент (опис в <Debugging.md>). Мікроконтролер налаштовується для конкретної апаратної платформи (див. нижче) і після чого на пульті ріжучих і пасти. вікно терміналу py:

```
SET старт_clock {clock+freq}
Тісточки SET 1000

Электронная пошта: info@start_clock.com
set_next_step_dir oid=0 dir=0
string_step oid=0 інтервал={ticks} count=60000 add=0
set_next_step_dir oid=0 dir=1
string_step oid=0 інтервал=3000 count=1 add=0

Электронная пошта: info@start_clock.com
set_next_step_dir oid=1 dir=0
string_step oid=1 інтервал={ticks} count=60000 add=0
set_next_step_dir oid=1 dir=1
string_step oid=1 інтервал=3000 count=1 add=0

Электронная пошта: info@start_clock.com
set_next_step_dir oid=2 dir=0
string_step oid=2 інтервал={ticks} count=60000 add=0
set_next_step_dir oid=2 dir=1
string_step oid=2 інтервал=3000 count=1 add=0
```

Наведені тести три крокети одночасно крокові. Якщо запущено вищевказані результати в параметрі "Попередня таймер в минулому" або "Степпер занадто далеко за минулі" помилки, то він вказує на `ticks` занадто низький (це призводить до покрокової швидкості, яка занадто швидко). Мета полягає в тому, щоб знайти найнижчий параметр ticks, який надійно призводить до успішного завершення тесту. Щоб уникнути параметра ticks до знайденого стабільного значення.

На відмові можна копіювати і ставити наступне, щоб очистити помилку при підготовці до наступного тесту:

```
clear_shutdown
```

Для отримання одноступінкових бендиктів використовується однакова послідовність конфігурацій, але тільки перший блок вищевказаного тесту ріжучий і простий в консолі. py вікно.

Для отримання бендиктів, знайдених в документі [Особливості](Features.md) сума кроків на другий обчислюється шляхом розмноження кількості активних кроків з номінальною частотою mcu і поділу за кінцевими показниками ticks. Результати закруглені до найближчого К. Наприклад, з трьома активними кроками:

```
ЕКОХО Результати випробувань: {"%.0fK" % (3. * freq / ticks / 1000.
```

Для драйверів TMC працюють бендикти. Для мікроконтролерів, які підтримують `STEPPER_BOTH_EDGE=1` (як повідомляється в лінійці `MCU` при консолі. py first start) use `step_pulse_duration=0` і `invert_step=-1`, щоб увімкнути оптимізований крок на обох краях степового імпульсу. Для інших мікроконтролерів використовують `step_pulse_duration`, відповідну 100ns.

### AVR покрокова оцінка

На мікросхемах AVR використовуються наступні конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
JavaScript licenses API Веб-сайт Go1.13.8
```

`59314d99` з версією Gcc `avr-gcc (GCC) 5.4.0`. Тести 16Mhz і 20Mhz були запущені за допомогою simulavr, налаштованих для atmega644p (передові тести підтвердили результати Ssimulavr на обох 16Mhz at90usb і 16Mhz atmega2560).

| авр | кліщі |
| --- | --- |
| 1 крок | 102 |
| 3 крок | 486 |

### Arduino еталон швидкості

У зв'язку з цим використовується наступна послідовність конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dr_pin=PC30 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

`59314d99` з версією Gcc `arm-on-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam3x8e | кліщі |
| --- | --- |
| 1 крок | 66 |
| 3 крок | 257 |

### Duet Maestro покрокова оцінка

Далі конфігурація використовується на Duet Maestro:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

`59314d99` з версією Gcc `arm-on-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam4s8c | кліщі |
| --- | --- |
| 1 крок | 71 |
| 3 крок | 260 |

### Duet Wifi покрокова оцінка

Далі конфігурація використовується на Duet Wifi:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dr_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dr_pin=PD13 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

Тест був останній курс на комітування `59314d99` з версією Gcc `gcc версії 10.3.1 20210621 (випуск) (GNU Arm Embedded Toolchain 10.3-2021.07)`.

| sam4e8e | кліщі |
| --- | --- |
| 1 крок | 48 |
| 3 крок | 215 |

### Beaglebone PRU покрокова оцінка

На PRU використовується наступна послідовність конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
javascript licenses api веб-сайт go1.13.8
```

`59314d99` з версією Gcc `pru-gcc (GCC) 8.0.0 20170530 (досвідчений)`.

| прут | кліщі |
| --- | --- |
| 1 крок | 231 |
| 3 крок | 847 |

### STM32F042 покрокова оцінка

На STM32F042 використовується наступна послідовність конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

`59314d99` з версією Gcc `arm-on-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| стм32ф042 | кліщі |
| --- | --- |
| 1 крок | 59 |
| 3 крок | 249 |

### STM32F103 покрокова оцінка

На STM32F103 використовується наступна послідовність конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

`59314d99` з версією Gcc `arm-on-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| стм32ф103 | кліщі |
| --- | --- |
| 1 крок | 61 |
| 3 крок | 264 |

### STM32F4 покрокова оцінка

На СТМ32Ф4 використовується наступна послідовність конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dr_pin=PB7 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

Тест востаннє запускався на коміті `59314d99` з версією gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. Результати STM32F407 були отримані шляхом запуску двійкового файлу STM32F407 на STM32F446 (і, отже, з використанням тактової частоти 168 МГц).

| стм32ф446 | кліщі |
| --- | --- |
| 1 крок | 46 |
| 3 крок | 205 |

| стм32ф407 | кліщі |
| --- | --- |
| 1 крок | 46 |
| 3 крок | 205 |

### STM32H7 покрокова оцінка

Далі конфігурація використовується на STM32H743VIT6:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PD4 dir_pin=PD3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA15 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PE2 dir_pin=PE3 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

Тест був останній курс на комітування `00191b5c` з версією Gcc `arm-non-eabi-gcc (15:8-2019-q3-1+b1) 8.3.1 20190703 (випуск) [gcc-8-branch version 273027]`.

| стм32х7 | кліщі |
| --- | --- |
| 1 крок | 44 |
| 3 крок | 198 |

### STM32G0B1 покрокова оцінка

На СТМ32Г0Б1 використовується наступна послідовність конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PB13 dr_pin=PB12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB10 dir_pin=PB2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB0 dir_pin=PC5 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

`247cd753` з версією Gcc `arm-on-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32g0b1 | кліщі |
| --- | --- |
| 1 крок | 58 |
| 3 крок | 243 |

### LPC176x покрокова оцінка

Далі конфігурація використовується на LPC176x:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

`59314d99` з версією Gcc `arm-on-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. 120Mhz LPC1769 результати були отримані шляхом перекриття LPC1768 до 120Mhz.

| лп1768 | кліщі |
| --- | --- |
| 1 крок | 52 |
| 3 крок | 222 |

| лп1769 | кліщі |
| --- | --- |
| 1 крок | 51 |
| 3 крок | 222 |

### Еталонна швидкість кроку SAMD21

На SAMD21 використовується наступна послідовність конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PA27 dr_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dr_pin=PA21 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

Тест був останній курс на комітування `59314d99` з версією Gcc `arm-non-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` на мікроконтролері SAMD21G18.

| шемале21 | кліщі |
| --- | --- |
| 1 крок | 70 |
| 3 крок | 306 |

### SAMD51 еталон швидкості

На SAMD51 використовується наступна послідовність конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

Тест був останній курс на комітування `59314d99` з версією Gcc `arm-non-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` на мікроконтролері SAMD51J19A.

| шемале51 | кліщі |
| --- | --- |
| 1 крок | 39 хв |
| 3 крок | 191 |
| 1 кроковий (200Mhz) | 39 хв |
| 3 кроковий (200Mhz) | 181 |

### Еталонний показник швидкості кроків SAME70

Наступна послідовність конфігурації використовується на SAME70:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC18 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC16 dir_pin=PD10 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC28 dir_pin=PA4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Тест востаннє запускався на коміті `34e9ea55` з версією gcc `arm-none-eabi-gcc (NixOS 10.3-2021.10) 10.3.1` на мікроконтролері SAME70Q20B.

| same70 | кліщі |
| --- | --- |
| 1 крок | 45 |
| 3 крок | 190 |

### AR100 покрокова оцінка

На AR100 використовується послідовність конфігурації (Allwinner A64):

```
сортувати_oids count=3
config_stepper oid=0 step_pin=PL10 dir_pin=PE14 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PL11 dr_pin=PE15 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PL12 dr_pin=PE16 invert_step=-1 step_pulse_ticks=0
JavaScript licenses API Веб-сайт Go1.13.8
```

Востаннє тест проводився на коміті `b7978d37` з версією gcc `or1k-linux-musl-gcc (GCC) 9.2.0` на мікроконтролері Allwinner A64-H.

| АР100 Р_ПІО | кліщі |
| --- | --- |
| 1 крок | 85 |
| 3 крок | 359 |

### RPxxxx контрольний показник швидкості кроків

На RP2040 і RP2350 використовується така послідовність конфігурації:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
javascript licenses api веб-сайт go1.13.8
```

Тест востаннє запускався на коміті `f6718291` з версією gcc `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0` на платах Raspberry Pi Pico та Pico 2.

| rp2040 (*) | кліщі |
| --- | --- |
| 1 крок | 5 |
| 3 крок | 22 |

| rp2350 | кліщі |
| --- | --- |
| 1 крок | 36 |
| 3 крок | 169 |

(*) Зверніть увагу, що зареєстровані такти rp2040 відносяться до таймера планування 12 МГц і не відповідають його швидкості внутрішньої обробки ARM 125 МГц. Очікується, що 5 тактів планування відповідає ~47 циклам ядра ARM, а 22 такти планування відповідають ~224 циклам ядра ARM.

### Linux MCU покрокова оцінка

Наступна послідовність конфігурації використовується на Raspberry Pi:

```
сортувати_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
javascript licenses api веб-сайт go1.13.8
```

Тест був останній курс на комітування `59314d99` з версією Gcc `gcc (Raspbian 8.3.0-6+rpi1) 8.3.0` на Малині Пі 3 (редагування a02082). Це важко отримати стабільні результати в цьому еталоні.

| Linux (RPi3) | кліщі |
| --- | --- |
| 1 крок | 160 |
| 3 крок | 380 |

## Еталон для відправки команд

Командний контрольний еталонний тест, скільки "думій" працює на мікроконтролері. В першу чергу тест апаратного механізму зв'язку. Тест здійснюється за допомогою консолі. py інструмент (опис в <Debugging.md>). Наступне ріжуча і паста в консолі. вікно терміналу py:

```
DELAY {clock + 2*freq} Увійти
FLOOD 100000 0.0 debug_nop
Увійти
```

Коли тест завершується, визначте різницю між годинниками, які повідомляються в двох "часових" повідомленнях відповіді. Загальна кількість команд за секунду — `100000 * mcu_ Частота / годинник_diff`.

Зауважте, що цей тест може наситити USB / CPU ємність Raspberry Pi. Якщо працює на Raspberry Pi, Beaglebone або аналогічний комп'ютер хосту, то збільшення затримки (наприклад, `DELAY {clock + 20*freq} get_uptime`). Де це можливо, бендикти нижче з консолі. py, що працює на машині настільного класу з пристроєм, підключеним через швидкісний вузол.

| мікроконтролер | Ціна | Почати | Створити компілятор |
| --- | --- | --- | --- |
| стм32ф042 (CAN) | 18КХ | c105adc8 | arm-on-eabi-gcc (GNU Tools 7-2018-q3-update) 7.3.1 |
| atmega2560 (серійне) | 23КХ | б161а69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (серійний) | 23КХ | б161а69e | arm-on-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| в90усб1286 (USB) | 75 КМ | 01д2183ф | avr-gcc (GCC) 5.4.0 |
| ar100 (серійний) | 138K | 08d037c6 | or1k-linux-musl-gcc 9.3.0 км |
| samd21 (USB) | 223К | 01д2183ф | arm-on-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| pru (поголена пам'ять) | 260КХ | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (експериментально) |
| стм32ф103 (USB) | 355K | 01д2183ф | arm-on-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418K | 01д2183ф | arm-on-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| лп1768 (USB) | 534K | 01д2183ф | arm-on-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| лп1769 (USB) | 628K | 01д2183ф | arm-on-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650K | 8d4a5c16 | arm-on-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864K | 01д2183ф | arm-on-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| стм32ф446 (USB) | 870K | 01д2183ф | arm-on-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| rp2350 (USB) | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |

## Хост Бенчмарки

Ви можете запустити тестові тести на програмне забезпечення хосту за допомогою механізму обробки «податковий режим» (описаний в <Debugging.md>). Це, як правило, робиться, вибираючи великий і складний G-Code файл і терміни, як довго він займає для хост-програми для обробки його. Наприклад:

```
час ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -і javascript licenses api веб-сайт go1.13.8
```
