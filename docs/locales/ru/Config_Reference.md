# Ссылка на конфигурацию

Этот документ является справочником по опциям, доступным в файле конфигурации Klipper.

Описания в этом документе отформатированы таким образом, чтобы их можно было вырезать и вставить в конфигурационный файл принтера. См. [installation document](Installation.md) для получения информации о настройке Klipper и выборе начального конфигурационного файла.

## Конфигурация микроконтроллера

### Формат имен контактов микроконтроллера

Многие параметры конфигурации требуют указания имени вывода микроконтроллера. Klipper использует аппаратные имена этих выводов - например, `PA4`.

Перед названиями выводов может стоять символ `!`, указывающий на необходимость использования обратной полярности (например, срабатывание по низкому, а не по высокому уровню).

Перед входными выводами может стоять символ `^`, указывающий на необходимость включения аппаратного подтягивающего резистора для данного вывода. Если микроконтроллер поддерживает подтягивающие резисторы, то перед входным выводом можно поставить `~`.

Обратите внимание, что некоторые секции конфигурации могут "создавать" дополнительные пины. Если это происходит, секция конфигурации, определяющая контакты, должна быть указана в файле конфигурации перед секциями, использующими эти контакты.

### [mcu]

Конфигурация основного микроконтроллера.

```
[mcu]
serial:
# Последовательный порт для подключения к MCU. Если вы не уверены (или если он
# меняется), смотрите раздел FAQ "Где мой последовательный порт?".
# Этот параметр должен быть указан при использовании последовательного порта.
#baud: 250000
# Используемая скорость передачи данных. По умолчанию 250000.
#canbus_uuid:
# Если используется устройство, подключенное к шине CAN, то этот параметр задает уникальный
# идентификатор чипа для подключения. Это значение должно быть предоставлено при использовании
# шину CAN для связи.
#canbus_interface:
# Если используется устройство, подключенное к шине CAN, то здесь задается сетевой интерфейс CAN
# сетевой интерфейс для использования. По умолчанию используется 'can0'.
#restart_method:
# Здесь задается механизм, который будет использоваться хостом для перезагрузки
# микроконтроллера. На выбор предлагаются следующие варианты: 'arduino', 'cheetah', 'rpi_usb',
# и 'command'. Метод 'arduino' (переключение DTR) распространен на
# платах и клонах Arduino. Метод 'cheetah' - это специальный
# метод, необходимый для некоторых плат Fysetc Cheetah. Метод 'rpi_usb'
# полезен на платах Raspberry Pi с микроконтроллерами, питающимися
# по USB - он кратковременно отключает питание всех USB-портов, чтобы
# выполнить сброс микроконтроллера. Метод 'command' включает в себя
# отправку команды Klipper микроконтроллеру, чтобы он мог
# сбросить себя. По умолчанию используется 'arduino', если микроконтроллер
# общается через последовательный порт, в противном случае - 'command'.
```

### [mcu my_extra_mcu]

Дополнительные микроконтроллеры (можно определить любое количество секций с префиксом "mcu"). Дополнительные микроконтроллеры вводят дополнительные контакты, которые могут быть сконфигурированы как нагреватели, шаговики, вентиляторы и т. д.. Например, если введена секция "[mcu extra_mcu]", то такие пины, как "extra_mcu:ar9", могут быть использованы в других местах конфигурации (где "ar9" - это имя аппаратного пина или псевдоним данного mcu).

```
[mcu my_extra_mcu]
# Параметры конфигурации смотрите в разделе "mcu".
```

## Общие кинематические настройки

### [принтер]

Раздел принтера управляет высокоуровневыми настройками принтера.

```
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid_corexy, hybrid_corexz, generic_cartesian,
#   rotary_delta, delta, deltesian, polar, winch, or none.
#   This parameter must be specified.
max_velocity:
#   Maximum velocity (in mm/s) of the toolhead (relative to the
#   print). This parameter must be specified.
max_accel:
#   Maximum acceleration (in mm/s^2) of the toolhead (relative to the
#   print). Although this parameter is described as a "maximum"
#   acceleration, in practice most moves that accelerate or decelerate
#   will do so at the rate specified here. The value specified here
#   may be changed at runtime using the SET_VELOCITY_LIMIT command.
#   This parameter must be specified.
#minimum_cruise_ratio: 0.5
#   Most moves will accelerate to a cruising speed, travel at that
#   cruising speed, and then decelerate. However, some moves that
#   travel a short distance could nominally accelerate and then
#   immediately decelerate. This option reduces the top speed of these
#   moves to ensure there is always a minimum distance traveled at a
#   cruising speed. That is, it enforces a minimum distance traveled
#   at cruising speed relative to the total distance traveled. It is
#   intended to reduce the top speed of short zigzag moves (and thus
#   reduce printer vibration from these moves). For example, a
#   minimum_cruise_ratio of 0.5 would ensure that a standalone 1.5mm
#   move would have a minimum cruising distance of 0.75mm. Specify a
#   ratio of 0.0 to disable this feature (there would be no minimum
#   cruising distance enforced between acceleration and deceleration).
#   The value specified here may be changed at runtime using the
#   SET_VELOCITY_LIMIT command. The default is 0.5.
#square_corner_velocity: 5.0
#   The maximum velocity (in mm/s) that the toolhead may travel a 90
#   degree corner at. A non-zero value can reduce changes in extruder
#   flow rates by enabling instantaneous velocity changes of the
#   toolhead during cornering. This value configures the internal
#   centripetal velocity cornering algorithm; corners with angles
#   larger than 90 degrees will have a higher cornering velocity while
#   corners with angles less than 90 degrees will have a lower
#   cornering velocity. If this is set to zero then the toolhead will
#   decelerate to zero at each corner. The value specified here may be
#   changed at runtime using the SET_VELOCITY_LIMIT command. The
#   default is 5mm/s.
#max_accel_to_decel:
#   This parameter is deprecated and should no longer be used.
```

### [шаговый]

Определения шагового двигателя. Разные типы принтеров (как указано в опции "кинематика" в разделе [принтер] конфигурация) требуют разных имен для шагового двигателя (например, `stepper_x` против `stepper_a`). Ниже приведены общие определения шаговиков.

Информацию о расчете параметра `расстояние_вращения` смотрите в документе [rotation distance document](Rotation_Distance.md). Информацию о самонаведении с использованием нескольких микроконтроллеров см. в документе [Multi-MCU homing](Multi_MCU_Homing.md).

```
[stepper_x]
step_pin:
#    Контакт GPIO шага (высокий уровень срабатывания). Этот параметр должен быть указан.
dir_pin:
#    Контакт GPIO направления (высокий уровень указывает на положительное направление). Этот
#    параметр должен быть указан.
enable_pin:
#    Разрешающий вывод (по умолчанию - высокий уровень; используйте ! для обозначения разрешения
#    низкий). Если этот параметр не указан, то драйвер шагового двигателя
#    драйвер должен быть всегда включен.
rotation_distance:
#    Расстояние (в мм), которое проходит ось за один полный оборот
#    шагового двигателя (или конечной передачи, если указано передаточное_отношение).
#    Этот параметр должен быть указан.
microsteps:
#    Количество микрошагов, используемых драйвером шагового двигателя. Этот
#    параметр должен быть указан.
#full_steps_per_rotation: 200
#    Количество полных шагов для одного оборота шагового двигателя.
#    Установите это значение на 200 для шагового двигателя с углом поворота 1,8 градуса или на 400 для двигателя с углом поворота
#    0,9 градусов. По умолчанию установлено значение 200.
#gear_ratio:
#    Передаточное число, если шаговый двигатель подключен к оси через
#    редуктор. Например, можно указать "5:1", если используется редуктор 5 к 1.
#    используется. Если ось имеет несколько редукторов, можно указать разделенный запятыми
#    разделенный запятыми список передаточных чисел (например, "57:11, 2:1"). Если
#    передаточное_отношение указано, то расстояние_вращения определяет
#    расстояние, которое проходит ось за один полный оборот конечной передачи.
#    По умолчанию передаточное число не используется.
#    длительность_шагового_импульса:
#    Минимальное время между фронтом импульсного сигнала шага и
#    следующим за ним фронтом сигнала "отбой". Это также используется для установки
#    минимального времени между импульсом шага и сигналом изменения направления.
#    По умолчанию 0.000000100 (100ns) для степперов TMC, которые
#    сконфигурированы в режиме UART или SPI, и по умолчанию 0.000002 (что
#    это 2us) для всех остальных степперов.
endstop_pin:
#    Контакт обнаружения переключателя конечного останова. Если этот вывод endstop находится на
#    другом микроконтроллере, чем шаговый двигатель, то он включает "мульти-микроконтроллер
#    самонаведение". Этот параметр должен быть задан для шаговых двигателей X, Y и Z
#    шаговых двигателей на принтерах с картезианским стилем.
#position_min: 0
#    Минимальное допустимое расстояние (в мм), на которое пользователь может приказать шаговому механизму
#    перемещаться.  По умолчанию 0 мм.
position_endstop:
#    Расположение конечного ограничителя (в мм). Этот параметр должен быть задан
#    для шаговых механизмов X, Y и Z на принтерах с картезианским стилем печати.
position_max:
#    Максимальное допустимое расстояние (в мм), на которое пользователь может дать команду степперу
#    перемещаться. Этот параметр должен быть указан для степперов X, Y и Z
#    степперов на принтерах с картезианским стилем печати.
#homing_speed: 5.0
#    Максимальная скорость (в мм/с) шагового устройства при наведении. По умолчанию
#    5 мм/с.
#homing_retract_dist: 5.0
#    Расстояние до отката (в мм) перед повторным наведением во время
#    самонаведения. Установите это значение на ноль, чтобы отключить второе возвращение. По умолчанию
#    является 5 мм.
#homing_retract_speed:
#    Скорость, используемая при втягивании после самонаведения, в случае, если она должна
#    отличаться от скорости наведения, которая используется по умолчанию для этого
#    параметр
#second_homing_speed:
#    Скорость (в мм/с) шагового механизма при выполнении второго возврата домой.
#    По умолчанию это homing_speed/2.
#homing_positive_dir:
#    Если установлено значение true, то при наведении шаговый механизм будет двигаться в положительном
#    направлении (в сторону от нуля); если false, то в сторону нуля. Это
#    лучше использовать значение по умолчанию, чем указывать этот параметр. По адресу
#    по умолчанию равно true, если position_endstop находится вблизи position_max, и false
#    если вблизи position_min.
```

### Декартова кинематика

Пример файла конфигурации картезианской кинематики смотрите в [example-cartesian.cfg](../config/example-cartesian.cfg).

Здесь описаны только параметры, характерные для картезианских принтеров - доступные параметры см. в разделе [общие кинематические настройки](#common-kinematic-settings)

```
[принтер].
кинематика: картезианская
max_z_velocity:
# Это задает максимальную скорость (в мм/с) перемещения вдоль оси z
# оси. Эта настройка может использоваться для ограничения максимальной скорости
# шагового двигателя z. По умолчанию используется значение max_velocity для
# max_z_velocity.
max_z_accel:
# Эта настройка задает максимальное ускорение (в мм/с^2) движения вдоль
# оси z. Оно ограничивает ускорение шагового двигателя z. По
# по умолчанию используется max_accel для max_z_accel.

# Секция stepper_x используется для описания шагового двигателя, управляющего
# осью X в картезианском роботе.
[stepper_x]

# Раздел stepper_y используется для описания шагового механизма, управляющего осью
# осью Y в картезианском роботе.
[stepper_y]

# Раздел stepper_z используется для описания шагового устройства, управляющего осью
# осью Z в картезианском роботе.
[stepper_z]
```

### Линейная дельта-кинематика

Пример файла конфигурации линейной дельта-кинематики см. в [example-delta.cfg](../config/example-delta.cfg). Информацию о калибровке смотрите в руководстве [delta calibrate guide](Delta_Calibrate.md).

Здесь описаны только параметры, характерные для линейных дельта-принтеров - доступные параметры смотрите в разделе [общие кинематические настройки](#common-kinematic-settings).

```
[принтер].
кинематика: дельта
max_z_velocity:
#    Для дельта-принтеров это ограничение максимальной скорости (в мм/с)
#    перемещения по оси z. Эта настройка может быть использована для уменьшения
#    максимальной скорости перемещений вверх/вниз (которые требуют более высокой скорости шага
#    чем другие перемещения на дельта-принтере). По умолчанию используется
#    max_velocity для max_z_velocity.
#max_z_accel:
#    Это задает максимальное ускорение (в мм/с^2) перемещения вдоль
#    оси z. Установка этого параметра может быть полезна, если принтер может достичь большего
#    ускорения при движении по XY, чем при движении по Z (например, при использовании входного формирователя).
#    По умолчанию используется max_accel для max_z_accel.
#minimum_z_position: 0
#    Минимальная позиция по Z, в которую пользователь может приказать голове переместиться.
#    в. По умолчанию равно 0.
delta_radius:
#    Радиус (в мм) горизонтальной окружности, образованной тремя линейными
#    осями. Этот параметр также может быть рассчитан как:
#    delta_radius = smooth_rod_offset - effector_offset - carriage_offset
#    Этот параметр должен быть указан.
# print_radius:
#    Радиус (в мм) действительных координат XY головки инструмента. Можно использовать
#    этот параметр для настройки проверки диапазона перемещения головки инструмента. Если
#    здесь задано большое значение, то может возникнуть команда
#    головке инструмента в столкновение с башней. По умолчанию используется
#    delta_radius для print_radius (что обычно предотвращает
#    столкновения с башней).

#    Секция stepper_a описывает шаговый механизм, управляющий передней
#    левой башней (на 210 градусов). Эта секция также управляет параметрами наведения
#    параметрами (homing_speed, homing_retract_dist) для всех башен.
[stepper_a]
position_endstop:
#    Расстояние (в мм) между соплом и станиной, когда сопло находится
#    в центре зоны сборки и срабатывает концевой упор. Этот
#    параметр должен быть указан для степпера_a; для степпера_b и
#    stepper_c этот параметр по умолчанию принимает значение, указанное для
# stepper_a.
длина_руки:
#    Длина (в мм) диагонального стержня, соединяющего эту башню с
#    печатающей головкой. Этот параметр должен быть указан для степпера_a; для
#    stepper_b и stepper_c этот параметр по умолчанию принимает значение
#    указанное для stepper_a.
#angle:
#    Этот параметр задает угол (в градусах), под которым находится башня
#    под которым находится башня. По умолчанию это 210 для stepper_a, 330 для stepper_b и 90
#    для stepper_c.

#    Секция stepper_b описывает шаговый механизм, управляющий передней
#    правой башней (под углом 330 градусов).
[stepper_b]

#    Раздел stepper_c описывает шаговый механизм, управляющий задней
#    башней (под углом 90 градусов).
[stepper_c]

#    Секция delta_calibrate включает расширенную команду DELTA_CALIBRATE
#    команду g-кода, которая может откалибровать положения конечных упоров башни и
#    углы.
[delta_calibrate]
радиус:
#    Радиус (в мм) области, которую можно зондировать. Это радиус
#    координат сопла для зондирования; если используется автоматическое зондирование
#    с XY-смещением, то выберите радиус достаточно малым, чтобы
#    зонд всегда помещался над станиной. Этот параметр должен быть указан.
#speed: 50
#    Скорость (в мм/с) перемещения без зондирования во время калибровки.
#    По умолчанию - 50.
#horizontal_move_z: 5
#    Высота (в мм), на которую следует дать команду головке переместиться
#    непосредственно перед началом работы датчика. По умолчанию равно 5.
```

### Дельтезианская кинематика

Смотрите [example-deltesian.cfg](../config/example-deltesian.cfg) для примера файла конфигурации кинематики Дельтезиана.

Здесь описаны только параметры, специфичные для дельтезианских принтеров - доступные параметры см. в разделе [общие кинематические настройки] (#common-kinematic-settings).

```
[принтер].
кинематика: дельтезианская
max_z_velocity:
#    Для дельтезианских принтеров это ограничение максимальной скорости (в мм/с)
#    перемещения по оси z. Эта настройка может быть использована для уменьшения
#    максимальной скорости перемещений вверх/вниз (которые требуют более высокой скорости шага
#    чем другие перемещения на дельтезианском принтере). По умолчанию используется
#    max_velocity для max_z_velocity.
#max_z_accel:
#    Это задает максимальное ускорение (в мм/с^2) движения вдоль
#    оси z. Установка этого параметра может быть полезна, если принтер может достичь большего
#    ускорения при движении по XY, чем при движении по Z (например, при использовании входного формирователя).
#    По умолчанию используется max_accel для max_z_accel.
#minimum_z_position: 0
#    Минимальная позиция по Z, в которую пользователь может приказать голове переместиться.
#    в. По умолчанию равно 0.
#min_angle: 5
#    Это минимальный угол (в градусах) относительно горизонтали.
#    которого могут достичь дельтезианские руки. Этот параметр
#    предназначен для того, чтобы ограничить руки от полного горизонтального положения,
#    что может привести к случайной инверсии оси XZ. По умолчанию значение равно 5.
#print_width:
#    Расстояние (в мм) от действительных координат X головки инструмента. Можно использовать
#    эту настройку, чтобы настроить проверку диапазона перемещения инструментальной головки. Если
#    здесь задано большое значение, то может возникнуть команда
#    головке инструмента в столкновение с башней. Обычно эта настройка
#    соответствует ширине станины (в мм).
#slow_ratio: 3
#    Коэффициент, используемый для ограничения скорости и ускорения при перемещениях вблизи
#    крайних точек оси X. Если вертикальное расстояние, деленное на горизонтальное
#    расстояние превышает значение параметра slow_ratio, то скорость и
#    ускорение ограничиваются половиной их номинальных значений. Если вертикальное
#    расстояние, деленное на горизонтальное расстояние, превышает вдвое значение
#    соотношения slow_ratio, то скорость и ускорение ограничены одной
#    четвертью своих номинальных значений. По умолчанию установлено значение 3.

#    Секция stepper_left используется для описания шагового механизма, управляющего
#    левой башней. Эта секция также управляет параметрами самонаведения
# (homing_speed, homing_retract_dist) для всех башен.
[stepper_left]
position_endstop:
#    Расстояние (в мм) между соплом и станиной, когда сопло находится
#    в центре зоны сборки и срабатывают концевые упоры. Этот
#    параметр должен быть указан для stepper_left; для stepper_right этот
#    параметр по умолчанию принимает значение, указанное для stepper_left.
arm_length:
#    Длина (в мм) диагонального стержня, соединяющего каретку башни с
#    печатающей головкой. Этот параметр должен быть указан для stepper_left; для
#    stepper_right этот параметр по умолчанию принимает значение, указанное для
# stepper_left.
arm_x_length:
#    Горизонтальное расстояние между печатающей головкой и башней, когда
#    принтера. Этот параметр должен быть указан для stepper_left;
#    для stepper_right этот параметр по умолчанию принимает значение, указанное для
# stepper_left.

#    Секция stepper_right используется для описания шагового механизма, управляющего
#    правой башней.
[stepper_right]

#    Секция stepper_y используется для описания шагового механизма, управляющего
#    осью Y в дельтезианском роботе.
[stepper_y]
```

### Кинематика CoreXY

Смотрите [example-corexy.cfg](../config/example-corexy.cfg) для примера файла кинематики corexy (и h-bot).

Здесь описаны только параметры, характерные для принтеров corexy - доступные параметры смотрите в разделе [общие кинематические настройки](#common-kinematic-settings).

```
[принтер].
кинематика: corexy
max_z_velocity:
# Это задает максимальную скорость (в мм/с) перемещения вдоль оси z
# оси. Эта настройка может использоваться для ограничения максимальной скорости
# шагового двигателя z. По умолчанию используется значение max_velocity для
# max_z_velocity.
max_z_accel:
# Эта настройка задает максимальное ускорение (в мм/с^2) движения вдоль
# оси z. Оно ограничивает ускорение шагового двигателя z. По
# по умолчанию используется max_accel для max_z_accel.

# Секция stepper_x используется для описания оси X, а также
# шагового двигателя, управляющего движением X+Y.
[stepper_x]

# Секция stepper_y используется для описания оси Y, а также
# шагового механизма, управляющего движением X-Y.
[stepper_y]

# Секция stepper_z используется для описания шага, управляющего
# осью Z.
[stepper_z]
```

### Кинематика CoreXZ

Пример файла конфигурации кинематики corexz см. в [example-corexz.cfg](../config/example-corexz.cfg).

Здесь описаны только параметры, характерные для принтеров corexz - доступные параметры смотрите в разделе [общие кинематические настройки](#common-kinematic-settings).

```
[принтер]
кинематика: corexz
max_z_velocity:
# Это задает максимальную скорость (в мм/с) перемещения вдоль оси z
# оси. По умолчанию для max_z_velocity используется max_velocity.
max_z_accel:
# Задает максимальное ускорение (в мм/с^2) движения вдоль оси
# оси z. По умолчанию используется max_accel для max_z_accel.

# Секция stepper_x используется для описания оси X, а также
# шагового механизма, управляющего движением X+Z.
[stepper_x]

# Секция stepper_y используется для описания шага, управляющего
# осью Y.
[stepper_y]

# Секция stepper_z используется для описания оси Z, а также
# шагового механизма, управляющего движением по оси X-Z.
[stepper_z]
```

### Кинематика Hybrid-CoreXY

Пример файла конфигурации кинематики гибридного corexy смотрите в [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg).

Эта кинематика также известна как кинематика Markforged.

Здесь описаны только параметры, характерные для гибридных принтеров corexy, доступные параметры смотрите в разделе [общие кинематические настройки](#common-kinematic-settings).

```
[принтер]
кинематика: гибридная_коррекция
max_z_velocity:
# Здесь задается максимальная скорость (в мм/с) перемещения вдоль оси z
# оси. По умолчанию для max_z_velocity используется max_velocity.
max_z_accel:
# Задает максимальное ускорение (в мм/с^2) движения вдоль оси
# оси z. По умолчанию используется max_accel для max_z_accel.

# Секция stepper_x используется для описания оси X, а также
# шагового механизма, управляющего движением по оси X-Y.
[stepper_x]

# Секция stepper_y используется для описания шага, управляющего
# осью Y.
[stepper_y]

# Секция stepper_z используется для описания шага, управляющего
# осью Z.
[stepper_z]
```

### Кинематика Hybrid-CoreXZ

Пример файла конфигурации гибридной кинематики corexz смотрите в [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg).

Эта кинематика также известна как кинематика Markforged.

Здесь описаны только параметры, характерные для гибридных принтеров corexy, доступные параметры смотрите в разделе [общие кинематические настройки](#common-kinematic-settings).

```
[принтер]
кинематика: hybrid_corexz
max_z_velocity:
# Здесь задается максимальная скорость (в мм/с) перемещения вдоль оси z
# оси. По умолчанию для max_z_velocity используется max_velocity.
max_z_accel:
# Задает максимальное ускорение (в мм/с^2) движения вдоль оси
# оси z. По умолчанию используется max_accel для max_z_accel.

# Секция stepper_x используется для описания оси X, а также
# шагового механизма, управляющего движением по оси X-Z.
[stepper_x]

# Секция stepper_y используется для описания шага, управляющего
# осью Y.
[stepper_y]

# Секция stepper_z используется для описания шага, управляющего
# осью Z.
[stepper_z]
```

### Полярная кинематика

Пример файла конфигурации полярной кинематики смотрите в [example-polar.cfg](../config/example-polar.cfg).

Здесь описаны только параметры, специфичные для полярных принтеров - доступные параметры смотрите в разделе [общие кинематические настройки](#common-kinematic-settings).

ПОЛЯРНАЯ КИНЕМАТИКА НАХОДИТСЯ В СТАДИИ РАЗРАБОТКИ. Известно, что перемещения вокруг позиции 0, 0 не работают должным образом.

```
[принтер].
кинематика: полярная
max_z_velocity:
#    Это задает максимальную скорость (в мм/с) перемещения вдоль оси z
#    оси. Эта настройка может использоваться для ограничения максимальной скорости
#    шагового двигателя z. По умолчанию используется значение max_velocity для
#    max_z_velocity.
max_z_accel:
#    Эта настройка задает максимальное ускорение (в мм/с^2) движения вдоль
#    оси z. Оно ограничивает ускорение шагового двигателя z. По
#    по умолчанию используется max_accel для max_z_accel.

#    Секция stepper_bed используется для описания шагового механизма, управляющего
#    кроватью.
[stepper_bed].
gear_ratio:
#    Должно быть указано передаточное_отношение, а расстояние_вращения не может быть
#    задано. Например, если кровать имеет 80-зубый шкив, приводимый в движение
#    шаговым механизмом с 16-зубчатым шкивом, то можно указать
#    передаточное число "80:16". Этот параметр должен быть указан.

#    Секция stepper_arm используется для описания шагового механизма, управляющего
#    кареткой на манипуляторе.
[stepper_arm]

#    Секция stepper_z используется для описания шагового механизма, управляющего
#    осью Z.
[stepper_z]
```

### Роторная дельта-кинематика

Пример файла конфигурации кинематики роторной дельты смотрите в [example-rotary-delta.cfg](../config/example-rotary-delta.cfg).

Здесь описаны только параметры, характерные для ротационных дельта-принтеров - доступные параметры смотрите в разделе [общие кинематические настройки](#common-kinematic-settings).

КИНЕМАТИКА ВРАЩАЮЩИХСЯ ДЕЛЬТАЛЕТОВ НАХОДИТСЯ В СТАДИИ РАЗРАБОТКИ. Движения самонаведения могут прерываться по времени, а некоторые проверки границ не реализованы.

```
[принтер]
кинематика: вращение_дельта
max_z_velocity:
# Для дельта-принтеров это ограничение максимальной скорости (в мм/с)
# перемещения по оси z. Эта настройка может быть использована для уменьшения
# максимальной скорости перемещений вверх/вниз (которые требуют более высокой скорости шага
# чем другие перемещения на дельта-принтере). По умолчанию используется
# max_velocity для max_z_velocity.
#minimum_z_position: 0
# Минимальная позиция Z, в которую пользователь может приказать головке переместиться.
# в.  По умолчанию равно 0.
плечо_радиуса:
# Радиус (в мм) горизонтальной окружности, образованной тремя
# плечевыми суставами, минус радиус окружности, образованной
# суставами эффекторов. Этот параметр также может быть рассчитан как:
# shoulder_radius = (delta_f - delta_e) / sqrt(12)
# Этот параметр должен быть указан.
высота_плеча:
# Расстояние (в мм) плечевых соединений от станины за вычетом
# высота головки инструмента эффектора. Этот параметр должен быть указан.

# Раздел stepper_a описывает шаговый механизм, управляющий задней частью
# правой руки (под углом 30 градусов). Эта секция также управляет параметрами наведения
# параметры (homing_speed, homing_retract_dist) для всех рук.
[stepper_a]
gear_ratio:
# Должно быть указано передаточное_отношение, а расстояние_вращения не может быть
# задано. Например, если рука имеет 80-зубый шкив, приводимый в движение
# шкивом с 16 зубьями, который, в свою очередь, соединен с 60
# зубчатым шкивом, приводимым в движение шаговым механизмом с 16-зубым шкивом, то
# можно указать передаточное число "80:16, 60:16". Этот параметр
# должен быть указан.
position_endstop:
# Расстояние (в мм) между соплом и станиной, когда сопло находится
# в центре области сборки и срабатывает концевой упор. Этот
# параметр должен быть указан для степпера_a; для степпера_b и
# stepper_c этот параметр по умолчанию принимает значение, указанное для
# stepper_a.
upper_arm_length:
# Длина (в мм) руки, соединяющей "плечевой сустав" с
# "локтевым суставом". Этот параметр должен быть указан для степпера_a; для
# stepper_b и stepper_c этот параметр по умолчанию принимает значение
# указанное для stepper_a.
lower_arm_length:
# Длина (в мм) руки, соединяющей "локтевой сустав" с
# "эффекторным суставом". Этот параметр должен быть указан для степпера_a;
# для stepper_b и stepper_c этот параметр по умолчанию принимает значение.
# указанное для stepper_a.
#angle:
# Этот параметр задает угол (в градусах), под которым находится рука.
# По умолчанию это 30 для stepper_a, 150 для stepper_b и 270 для
# stepper_c.

# Раздел stepper_b описывает шаговый механизм, управляющий задней
# левой рукой (под углом 150 градусов).
[stepper_b]

# Раздел stepper_c описывает шаговый механизм, управляющий передней
# рукой (под углом 270 градусов).
[stepper_c]

# Секция delta_calibrate включает расширенную команду DELTA_CALIBRATE
# команду g-кода, которая может откалибровать положения концевых упоров плеч.
[delta_calibrate]
радиус:
# Радиус (в мм) области, которую можно зондировать. Это радиус
# координат сопла для зондирования; если используется автоматическое зондирование
# с XY-смещением, то выберите радиус достаточно малым, чтобы
# зонд всегда помещался над станиной. Этот параметр должен быть указан.
#speed: 50
# Скорость (в мм/с) перемещения без зондирования во время калибровки.
# По умолчанию - 50.
#horizontal_move_z: 5
# Высота (в мм), на которую следует дать команду головке переместиться
# непосредственно перед началом работы датчика. По умолчанию равно 5.
```

### Кинематика тросовой лебедки

Смотрите файл [example-winch.cfg](../config/example-winch.cfg) для примера файла конфигурации кинематики кабельной лебедки.

Здесь описаны только параметры, специфичные для принтеров кабельных лебедок - доступные параметры см. в разделе [общие кинематические настройки](#common-kinematic-settings).

ПОДДЕРЖКА ТРОСОВОЙ ЛЕБЕДКИ ЯВЛЯЕТСЯ ЭКСПЕРИМЕНТАЛЬНОЙ. Наведение не реализовано в кинематике кабельной лебедки. Чтобы установить принтер в исходное положение, вручную подавайте команды перемещения, пока головка инструмента не окажется в точке 0, 0, 0, а затем подайте команду `G28`.

```
[принтер]
кинематика: лебедка

#    Секция stepper_a описывает шаговый механизм, подключенный к первой
#    кабельной лебедке. Может быть определено минимум 3 и максимум 26 тросовых лебедок
#    определены (от stepper_a до stepper_z), хотя обычно определяют 4.
[stepper_a].
расстояние поворота:
#    Расстояние_поворота - это номинальное расстояние (в мм), на которое головка инструмента
#    перемещается по направлению к кабельной лебедке за каждый полный оборот
#    шагового двигателя. Этот параметр должен быть указан.
anchor_x:
anchor_y:
anchor_z:
#    Положение X, Y и Z тросовой лебедки в декартовом пространстве.
#    Эти параметры должны быть указаны.
```

### Generic Cartesian Kinematics

See [example-generic-cartesian.cfg](../config/example-generic-caretesian.cfg) for an example generic Cartesian kinematics config file.

This printer kinematic class allows a user to define in a pretty flexible manner an arbitrary Cartesian-style kinematics. In principle, the regular cartesian, corexy, hybrid_corexy can be defined this way too. However, more importantly, various otherwise unsupported kinematics such as inverted hybrid_corexy or corexyuv can be defined using this kinematic.

Notably, the definition of a generic Cartesian kinematic deviates significantly from the other kinematic types. It follows the following convention: a user defines a set of carriages with certain range of motion that can move independently from each other (they should move over the Cartesian axes X, Y, and Z, hence the name of the kinematic) and corresponding endstops that allow the firmware to determine the position of carriages during homing, as well as a set of steppers that move those carriages. The `[printer]` section must specify the kinematic and other printer-level settings same as the regular Cartesian kinematic:

```
[printer]
kinematics: generic_cartesian
max_velocity:
max_accel:
#minimum_cruise_ratio:
#square_corner_velocity:
#max_accel_to_decel:
#max_z_velocity:
#max_z_accel:
```

Then a user must define the following three carriages: `[carriage x]`, `[carriage y]`, and `[carriage z]`, e.g.

```
[carriage x]
endstop_pin:
#   Endstop switch detection pin. If this endstop pin is on a
#   different mcu than the stepper motor(s) moving this carriage,
#   then it enables "multi-mcu homing". This parameter must be provided.
#position_min: 0
#   Minimum valid distance (in mm) the user may command the carriage to
#   move to.  The default is 0mm.
position_endstop:
#   Location of the endstop (in mm). This parameter must be provided.
position_max:
#   Maximum valid distance (in mm) the user may command the stepper to
#   move to. This parameter must be provided.
#homing_speed: 5.0
#   Maximum velocity (in mm/s) of the carriage when homing. The default
#   is 5mm/s.
#homing_retract_dist: 5.0
#   Distance to backoff (in mm) before homing a second time during
#   homing. Set this to zero to disable the second home. The default
#   is 5mm.
#homing_retract_speed:
#   Speed to use on the retract move after homing in case this should
#   be different from the homing speed, which is the default for this
#   parameter
#second_homing_speed:
#   Velocity (in mm/s) of the carriage when performing the second home.
#   The default is homing_speed/2.
#homing_positive_dir:
#   If true, homing will cause the carriage to move in a positive
#   direction (away from zero); if false, home towards zero. It is
#   better to use the default than to specify this parameter. The
#   default is true if position_endstop is near position_max and false
#   if near position_min.
```

Afterwards, a user specifies the stepper motors that move these carriages, for instance

```
[stepper my_stepper]
carriages:
#   A string describing the carriages the stepper moves. All defined
#   carriages can be specified here, as well as their linear combinations,
#   e.g. x, x+y, y-0.5*z, x-z, etc. This parameter must be provided.
step_pin:
dir_pin:
enable_pin:
rotation_distance:
microsteps:
#full_steps_per_rotation: 200
#gear_ratio:
#step_pulse_duration:
```

See [stepper](#stepper) section for more information on the regular stepper parameters. The `carriages` parameter defines how the stepper affects the motion of the carriages. For example, `x+y` indicates that the motion of the stepper in the positive direction by the distance `d` moves the carriages `x` and `y` by the same distance `d` in the positive direction, while `x-0.5*y` means the motion of the stepper in the positive direction by the distance `d` moves the carriage `x` by the distance `d` in the positive direction, but the carriage `y` will travel distance `d/2` in the negative direction.

More than a single stepper motor can be defined to drive the same axis or belt. For example, on a CoreXY AWD setups two motors driving the same belt can be defined as

```
[carriage x]
endstop_pin: ...
...

[carriage y]
endstop_pin: ...
...

[stepper a0]
carriages: x-y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...

[stepper a1]
carriages: x-y
step_pin: ...
dir_pin: ...
enable_pin: ...
rotation_distance: ...
...
```

with `a0` and `a1` steppers having their own control pins, but sharing the same `carriages` and corresponding endstops.

There are situations when a user wants to have more than one endstop per axis. Examples of such configurations include Y axis driven by two independent stepper motors with belts attached to both ends of the X beam, with effectively two carriages on Y axis each having an independent endstop, and multi-stepper Z axis with each stepper having its own endstop (not to be confused with the configurations with multiple Z motors but only a single endstop). These configurations can be declared by specifying additional carriage(s) with their endstops:

```
[extra_carriage my_carriage]
primary_carriage:
#   The name of the primary carriage this carriage corresponds to.
#   It also effectively defines the axis the carriage moves over.
#   This parameter must be provided.
endstop_pin:
#   Endstop switch detection pin. This parameter must be provided.
```

and the corresponding stepper motors, for example:

```
[extra_carriage y1]
primary_carriage: y
endstop_pin: ...

[stepper sy1]
carriages: y1
...
```

Notably, an `[extra_carriage]` does not define parameters such as `position_min`, `position_max`, and `position_endstop`, but instead inherits them from the specified `primary_carriage`, thus sharing the same range of motion with the primary carriage.

For the references on how to configure IDEX setups, see the [dual carriage](#dual-carriage) section.

### Отсутствует Кинематика

Можно задать специальную кинематику " нет", чтобы отключить кинематическую поддержку в Klipper. Это может быть полезно для управления устройствами, которые не являются типичными 3d-принтерами, или для целей отладки.

```
[принтер].
кинематика: нет
макс_скорость: 1
макс_ускорение: 1
#    Параметры max_velocity и max_accel должны быть определены. На
#    значения не используются для кинематики " нет".
```

## Общий экструдер и подогреваемая подставка

### [экструдер]

Раздел "Экструдер" используется для описания параметров нагревателя для сопла хотэнда и шагового механизма, управляющего экструдером. Дополнительную информацию см. в [справочнике команд](G-Codes.md#extruder). Информацию о настройке опережения давления см. в руководстве [pressure advance guide](Pressure_Advance.md).

```
[экструдер].
step_pin:
dir_pin:
enable_pin:
микрошаги:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#    См. раздел "Шаговое управление" для описания вышеуказанных
#    параметров. Если ни один из вышеперечисленных параметров не указан, то ни один
#    степпер не будет связан с хотэндом форсунки (хотя
#    команда SYNC_EXTRUDER_MOTION может связать его во время выполнения).
диаметр_сопла:
#    Диаметр отверстия сопла (в мм). Этот параметр должен быть
#    предоставлен.
диаметр нити (filament_diameter):
#    Номинальный диаметр сырой нити (в мм), когда она поступает в
#    экструдер. Этот параметр должен быть предоставлен.
#max_extrude_cross_section:
#    Максимальная площадь (в мм^2) поперечного сечения экструзии (например,
#    ширина экструзии, умноженная на высоту слоя). Эта настройка предотвращает
#    чрезмерного количества экструзии при относительно небольших перемещениях по XY.
Если перемещение запрашивает скорость экструзии, превышающую это значение, #
#    это приведет к возврату ошибки. По умолчанию: 4.0 *
#    диаметр_сопла^2
#    мгновенная_угловая_скорость: 1.000
#    Максимальное мгновенное изменение скорости (в мм/с)
#    экструдера во время стыка двух движений. По умолчанию 1 мм/с.
#max_extrude_only_distance: 50.0
#    Максимальная длина (в мм сырой нити), на которую может быть выполнено втягивание или
#    extrude-only move может иметь. Если движение с втягиванием или только с выдавливанием
#    запрашивает расстояние, превышающее это значение, это приведет к ошибке
#    будет возвращена ошибка. По умолчанию это значение равно 50 мм.
#max_extrude_only_velocity:
#max_extrude_only_accel:
#    Максимальная скорость (в мм/с) и ускорение (в мм/с^2)
#    двигателя экструдера для втягивания и перемещения только экструдера. Эти
#    настройки не оказывают никакого влияния на обычные движения печати. Если они не
#    указаны, то они рассчитываются так, чтобы соответствовать пределу XY
#    движения печати с поперечным сечением 4,0*диаметр_сопла^2
#    иметь.
# pressure_advance: 0.0
#    Количество сырого филамента, которое нужно протолкнуть в экструдер во время
#    ускорения экструдера. Равное количество нити втягивается
#    во время замедления. Измеряется в миллиметрах на
#    миллиметр/секунду. По умолчанию установлено значение 0, что отключает давление
#    опережение.
#pressure_advance_smooth_time: 0.040
#    Диапазон времени (в секундах), используемый при расчете средней
#    скорости экструдера для опережения давления. Большее значение приводит к
#    более плавное движение экструдера. Этот параметр не может превышать 200 мс.
#    Эта настройка применяется только в том случае, если pressure_advance ненулевое. На
#    по умолчанию составляет 0,040 (40 миллисекунд).
#
#    Остальные переменные описывают нагреватель экструдера.
heater_pin:
#    ШИМ-выходной контакт, управляющий нагревателем. Этот параметр должен быть
#    предоставлен.
#max_power: 1.0
#    Максимальная мощность (выраженная в виде значения от 0,0 до 1,0), на которую может быть установлен
#    нагревателя_контакта может быть установлена. Значение 1.0 позволяет установить контакт
#    полностью включенным на длительное время, в то время как значение 0,5
#    позволит контакту быть включенным не более половины времени. Этот
#    настройка может быть использована для ограничения общей выходной мощности (в течение длительных
#    периодов) на нагреватель. По умолчанию значение равно 1,0.
тип_датчика:
#    Тип датчика - распространенные термисторы: "EPCOS 100K B57560G104F",
#    "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Generic
#    3950", "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#    "SliceEngineering 450", и "TDK NTCG104LH104JT1". См.
#    "Датчики температуры" для других датчиков. Этот параметр
#    должен быть указан.
sensor_pin:
#    Контакт аналогового входа, подключенный к датчику. Этот параметр должен быть
#    предоставлен.
#pullup_resistor: 4700
#    Сопротивление (в омах) подтяжки, подключенной к термистору.
#    Этот параметр действителен только в том случае, если датчик является термистором. По адресу
#    по умолчанию составляет 4700 Ом.
#smooth_time: 1.0
#    Значение времени (в секундах), в течение которого измерения температуры будут
#    будут сглажены, чтобы уменьшить влияние шума при измерении. По умолчанию
#    является 1 секунда.
control:
#    Алгоритм управления (либо pid, либо watermark). Этот параметр должен
#    быть предоставлен.
pid_Kp:
pid_Ki:
pid_Kd:
#    Пропорциональная (pid_Kp), интегральная (pid_Ki) и производная
#    (pid_Kd) настройки для системы управления с обратной связью PID. Клиппер
#    оценивает настройки ПИД-регулятора по следующей общей формуле:
#    heater_pwm = (Kp*error + Ki*integral(error) - Kd*derivative(error)) / 255
#    Где "error" - это "requested_temperature - measured_temperature"
#    и "heater_pwm" - запрашиваемая скорость нагрева, при этом 0.0 - полное
#    выключен, а 1.0 - полностью включен. Рассмотрите возможность использования команды PID_CALIBRATE
#    для получения этих параметров. Параметры pid_Kp, pid_Ki и pid_Kd
#    параметры должны быть указаны для ПИД-нагревателей.
#max_delta: 2.0
#    Для нагревателей с управлением "водяной знак" это количество градусов в
#    Цельсия выше целевой температуры перед отключением нагревателя
#    а также количество градусов ниже целевой температуры перед тем, как
#    повторным включением нагревателя. По умолчанию - 2 градуса Цельсия.
#pwm_cycle_time: 0.100
#   Время в секундах для каждого программного цикла ШИМ нагревателя   
#    не рекомендуется устанавливать это значение, если нет электрического
#    требования переключать нагреватель быстрее, чем 10 раз в секунду.
#    По умолчаию 0,100 секунды.
#min_extrude_temp: 170
#    Минимальная температура (в градусах Цельсия), при которой перемещение экструдера
#    могут быть поданы команды. По умолчанию 170 градусов Цельсия.
min_temp:
max_temp:
#    Максимальный диапазон допустимых температур (в градусах Цельсия), в пределах которого
#    нагреватель должен оставаться в пределах. Это контролирует функцию безопасности
#    реализованной в коде микроконтроллера - если измеренная
#    температура выйдет за пределы этого диапазона, то микроконтроллер
#    перейдет в состояние отключения. Эта проверка может помочь обнаружить некоторые
#    аппаратные сбои нагревателей и датчиков. Установите этот диапазон достаточно широким
#    достаточно, чтобы разумные температуры не приводили к ошибке.
#    Эти параметры должны быть указаны.
```

### [heater_bed]

Раздел heater_bed описывает подогреваемую станину. В нем используются те же настройки нагревателя, что и в разделе "Экструдер".

```
[heater_bed]
контакт_нагревателя:
тип_датчика:
контакт_датчика:
управление:
min_temp:
max_temp:
# Описание вышеуказанных параметров см. в разделе "Экструдер".
```

## Поддержка на уровне кровати

### [кровать_сетка]

Выравнивание слоя сетки. Можно определить раздел конфигурации bed_mesh, чтобы включить преобразования перемещения, которые смещают ось z на основе сетки, созданной из точек зондирования. При использовании датчика для установки оси z рекомендуется задать в файле printer.cfg секцию safe_z_home для установки оси z в центр области печати.

Дополнительную информацию см. в [руководстве по сетке кровати] (Bed_Mesh.md) и [справочнике команд] (G-Codes.md#bed_mesh).

Визуальные примеры:

```
 rectangular bed, probe_count = 3, 3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 round bed, round_probe_count = 5, bed_radius = r:
                 x (0, r) end
               /
             x---x---x
                       \
 (-r, 0) x---x---x---x---x (r, 0)
           \
             x---x---x
                   /
                 x  (0, -r) start
```

```
[bed_mesh]
#speed: 50
#    Скорость (в мм/с) перемещения без рельефа во время калибровки.
#    По умолчанию 50.
#horizontal_move_z: 5
#    Высота (в мм), на которую следует дать команду головке переместиться
#    непосредственно перед началом работы датчика. По умолчанию равно 5.
#mesh_radius:
#    Определяет радиус сетки для зондирования круглых кроватей. Обратите внимание, что
#    радиус задается относительно координаты, указанной параметром
#    параметром mesh_origin. Этот параметр должен быть указан для круглых кроватей
#    и опущен для прямоугольных кроватей.
#mesh_origin:
#    Определяет координаты центра X, Y сетки для круглых кроватей. Эта
#    координата является относительной по отношению к местоположению зонда. Может оказаться полезным
#    настроить mesh_origin в попытке максимизировать размер
#    радиуса сетки. По умолчанию 0, 0. Этот параметр должен быть опущен для
#    прямоугольных кроватей.
#mesh_min:
#    Определяет минимальные координаты X, Y сетки для прямоугольных
#    кровати. Эта координата относится к местоположению зонда. Это
#    будет первой точкой зондирования, ближайшей к началу координат. Этот
#    параметр должен быть задан для прямоугольных грядок.
#mesh_max:
#    Определяет максимальную координату X, Y сетки для прямоугольных
#    кроватей. Придерживается того же принципа, что и mesh_min, однако это будет
#    будет самой удаленной точкой от начала координат кровати. Этот параметр
#    должен быть задан для прямоугольных кроватей.
#probe_count: 3, 3
#    Для прямоугольных кроватей это пара целых чисел через запятую.
#    значений X, Y, определяющих количество точек для зондирования вдоль каждой
#    оси. Одиночное значение также допустимо, в этом случае это значение будет
#    будет применяться к обеим осям. По умолчанию 3, 3.
# round_probe_count: 5
#    Для круглых кроватей это целочисленное значение определяет максимальное количество
#    точек для зондирования вдоль каждой оси. Это значение должно быть нечетным числом.
#    По умолчанию 5.
#fade_start: 1.0
#    Позиция gcode z, в которой начинается постепенное уменьшение z-коррекции
#    когда включено затухание. По умолчанию 1.0.
#fade_end: 0.0
#    Позиция gcode z, в которой завершается фазирование. Если установлено значение
#    значение ниже fade_start, сглаживание отключается. Следует отметить, что
#    затухание может добавить нежелательное масштабирование по оси z отпечатка. Если
#    пользователь хочет включить затухание, рекомендуется использовать значение 10.0.
#    По умолчанию 0.0, что отключает затухание.
#fade_target:
#    Позиция по оси z, в которой должно сходиться затухание. Когда это значение
#    устанавливается ненулевое значение, оно должно быть в диапазоне значений z в
#    сетке. Пользователи, которые хотят сходиться в z-позиции самонаведения
#    должны установить это значение в 0. По умолчанию это среднее значение z сетки.
#split_delta_z: .025
#    Величина разницы Z (в мм) вдоль перемещения, которая вызовет
#    разделение. По умолчанию .025.
#move_check_distance: 5.0
#    Расстояние (в мм) вдоль перемещения для проверки на наличие split_delta_z.
#    Это также минимальная длина, на которую можно разделить ход. По умолчанию
#    равно 5.0.
#mesh_pps: 2, 2
#    Пара целых чисел X, Y, разделенных запятыми, определяющая количество
#    точек в сегменте для интерполяции в сетке вдоль каждой оси. A
#    "сегмент" может быть определен как пространство между каждой точкой зондирования.
#    Пользователь может ввести одно значение, которое будет применяться к обеим
#    осям. По умолчанию 2, 2.
#алгоритм: lagrange
#    Используемый алгоритм интерполяции. Может быть либо "lagrange", либо
#    "bicubic". Эта опция не влияет на сетки 3x3, которые вынуждены
#    использовать выборку Лагранжа. По умолчанию используется lagrange.
#bicubic_tension: .2
#    При использовании бикубического алгоритма параметр tension, указанный выше, может
#    быть применен для изменения величины интерполируемого наклона. Большие
#    числа увеличат величину наклона, что приведет к большей
#    кривизны в сетке. По умолчанию - .2.
# zeroo_reference_position:
#    Необязательная координата X,Y, определяющая местоположение на кровати.
#    где Z = 0. При указании этой опции сетка будет смещена
#    таким образом, чтобы в этом месте происходила нулевая регулировка Z.  По умолчанию
#    без нулевой привязки.
#faulty_region_1_min:
#faulty_region_1_max:
#    Необязательные точки, определяющие дефектную область.  См. docs/Bed_Mesh.md
#    для получения подробной информации о дефектных регионах.  Может быть добавлено до 99 дефектных областей.
#    По умолчанию дефектные области не заданы.
#adaptive_margin:
#    Необязательное поле (в мм), добавляемое вокруг области кровати, используемой
#    определенными объектами печати при генерации адаптивной сетки.
#scan_overshoot:
#    Максимальная величина перемещения (в мм), доступная за пределами сетки.
#    Для прямоугольных станин это относится к перемещению по оси X, а для круглых станин
#    это относится ко всему радиусу.  Инструмент должен иметь возможность перемещаться на указанную величину
#    указанного за пределами сетки.  Это значение используется для оптимизации
#    пути при выполнении "быстрого сканирования".  Минимальное значение, которое может быть указано.
#    равно 1. По умолчанию проскакивание отсутствует.
```

### [кровать_наклон]

Компенсация наклона кровати. Можно определить секцию конфигурации bed_tilt, чтобы включить трансформации перемещения, учитывающие наклон кровати. Обратите внимание, что bed_mesh и bed_tilt несовместимы; оба эти параметра не могут быть определены.

Дополнительную информацию см. в [справочнике команд](G-Codes.md#bed_tilt).

```
[bed_tilt]
#x_adjust: 0
#    Сумма, которую нужно добавить к высоте Z каждого движения за каждый мм по оси X
#    оси. По умолчанию 0.
#y_adjust: 0
#    Сумма, добавляемая к высоте Z каждого хода за каждый мм по оси Y
#    оси. По умолчанию 0.
#z_adjust: 0
#    Сумма, добавляемая к высоте Z, когда сопло номинально находится в точке
#    0, 0. По умолчанию 0.
#    Остальные параметры управляют расширенной командой BED_TILT_CALIBRATE
#    командой g-кода, которая может быть использована для калибровки соответствующих x и y
#    параметров настройки.
#points:
#    Список координат X, Y (по одной в строке; последующие строки
#    с отступом), которые должны быть проверены во время выполнения команды BED_TILT_CALIBRATE
#    команды. Укажите координаты сопла и убедитесь, что зонд
#    находится над пластом в заданных координатах сопла. По умолчанию
#    не включать команду.
#speed: 50
#    Скорость (в мм/с) перемещения без зондирования во время калибровки.
#    По умолчанию - 50.
#horizontal_move_z: 5
#    Высота (в мм), на которую следует дать команду головке переместиться
#    непосредственно перед началом работы датчика. По умолчанию равно 5.
```

### [bed_screws]

Инструмент для регулировки винтов выравнивания кровати. Можно определить секцию конфигурации [bed_screws], чтобы включить команду g-кода BED_SCREWS_ADJUST.

Дополнительную информацию см. в [руководстве по выравниванию] (Manual_Level.md#adjusting bed-leveling-screws) и [справочнике команд](G-Codes.md#bed_screws).

```
[bed_screws]
#screw1:
#   The X, Y coordinate of the first bed leveling screw. This is a
#   position to command the nozzle to that is directly above the bed
#   screw (or as close as possible while still being above the bed).
#   This parameter must be provided.
#screw1_name:
#   An arbitrary name for the given screw. This name is displayed when
#   the helper script runs. The default is to use a name based upon
#   the screw XY location.
#screw1_fine_adjust:
#   An X, Y coordinate to command the nozzle to so that one can fine
#   tune the bed leveling screw. The default is to not perform fine
#   adjustments on the bed screw.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#   Additional bed leveling screws. At least three screws must be
#   defined.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   when moving from one screw location to the next. The default is 5.
#probe_height: 0
#   The height of the probe (in mm) after adjusting for the thermal
#   expansion of bed and nozzle. The default is zero.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#probe_speed: 5
#   The speed (in mm/s) when moving from a horizontal_move_z position
#   to a probe_height position. The default is 5.
```

### [screws_tilt_adjust]

Инструмент для регулировки наклона винтов кровати с помощью Z-зонда. Можно определить секцию конфигурации screws_tilt_adjust, чтобы включить команду g-кода SCREWS_TILT_CALCULATE.

Дополнительную информацию см. в [руководстве по выравниванию] (Manual_Level.md#adjusting bed-leveling-screws-using-the-bed-probe) и [справочнике команд](G-Codes.md#screws_tilt_adjust).

```
[screws_tilt_adjust]
#screw1:
#    Координата (X, Y) первого винта выравнивания кровати. Это
#    положение, в которое нужно установить сопло, чтобы зонд находился прямо
#    над винтом кровати (или как можно ближе к нему, оставаясь при этом
#    над станиной). Это базовый винт, используемый в расчетах. Этот
#    параметр должен быть предоставлен.
#screw1_name:
#    произвольное имя для данного винта. Это имя отображается при
#    запуске вспомогательного скрипта. По умолчанию используется имя, основанное на
#    расположения винта по оси XY.
#screw2:
#screw2_name:
#...
#    Дополнительные винты для выравнивания кровати. Должно быть определено не менее двух винтов.
#    определены.
#speed: 50
#    Скорость (в мм/с) перемещения без пробивки во время калибровки.
#    По умолчанию 50.
#horizontal_move_z: 5
#    Высота (в мм), на которую следует дать команду головке переместиться
#    непосредственно перед началом работы датчика. По умолчанию равно 5.
#screw_thread: CW-M3
#    Тип винта, используемого для выравнивания ложа, M3, M4 или M5, и
#    направление вращения ручки, используемой для выравнивания кровати.
#    Принимаемые значения: CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
#    Значение по умолчанию - CW-M3, которое используется в большинстве принтеров. Вращение по часовой стрелке
#    вращение ручки уменьшает зазор между соплом и
#    постелью. И наоборот, поворот против часовой стрелки увеличивает зазор.
```

### [z_tilt]

Регулировка наклона нескольких Z-шаговиков. Эта функция позволяет независимо регулировать наклон нескольких шаговиков z (см. раздел "stepper_z1"). Если эта секция присутствует, то становится доступной расширенная [команда G-кода] Z_TILT_ADJUST (G-Codes.md#z_tilt).

```
[z_tilt]
#z_positions:
#    Список координат X, Y (по одной в строке; последующие строки
#    с отступом), описывающих расположение каждой "точки поворота" кровати. На
#    "точка поворота" - это точка, в которой кровать крепится к данному Z
#    степперу. Она описывается с помощью координат сопла (положение X, Y
#    сопла, если бы оно могло двигаться прямо над точкой). На
#    первая запись соответствует stepper_z, вторая - stepper_z1,
#    третья - stepper_z2 и т. д. Этот параметр должен быть указан.
#points:
#    Список координат X, Y (по одной в строке; последующие строки
#    отступы), которые должны быть проверены во время выполнения команды Z_TILT_ADJUST.
#    Укажите координаты сопла и убедитесь, что зонд находится над
#    станиной в заданных координатах сопла. Этот параметр должен быть
#    предоставлен.
#speed: 50
#    Скорость (в мм/с) перемещения без зондирования во время калибровки.
#    По умолчанию - 50.
#horizontal_move_z: 5
#    Высота (в мм), на которую следует дать команду головке переместиться
#    непосредственно перед началом работы датчика. По умолчанию равно 5.
#retries: 0
#    Количество повторных попыток, если точки зондирования не находятся в пределах
#    допуска.
#retry_tolerance: 0
#    Если включены повторные попытки, то повторите попытку, если наибольшая и наименьшая прозондированные
#    точки отличаются больше, чем допуск retry_tolerance. Обратите внимание, что наименьшей единицей
#    изменения здесь будет один шаг. Однако если вы измеряете
#    больше точек, чем шагов, то у вас, скорее всего, будет фиксированное
#    минимальное значение для диапазона зондируемых точек, которое можно узнать
#    путем наблюдения за выводом команды.
```

### [quad_gantry_level]

Выравнивание подвижного портала с помощью 4 независимо управляемых двигателей Z. Корректирует эффект гиперболической параболы (картофельной крошки) на подвижном портале, который является более гибким. ПРЕДУПРЕЖДЕНИЕ: Использование этой функции на движущейся станине может привести к нежелательным результатам. Если эта секция присутствует, то становится доступной расширенная команда G-кода QUAD_GANTRY_LEVEL. Эта процедура предполагает следующую конфигурацию двигателя Z:

```
 ----------------
 |Z1          Z2|
 |  ---------   |
 |  |       |   |
 |  |       |   |
 |  x--------   |
 |Z           Z3|
 ----------------
```

Где x - точка 0, 0 на станине.

```
[quad_gantry_level]
#gantry_corners:
#    Список координат X, Y, разделенных новой строкой, описывающий два
#    противоположные углы портала. Первая запись соответствует Z,
#    вторая - Z2. Этот параметр должен быть указан.
#points:
#    Список из четырех точек X, Y, которые должны быть прощупаны
#    во время выполнения команды QUAD_GANTRY_LEVEL. Порядок расположения точек
#    важен и должен соответствовать расположению Z, Z1, Z2 и Z3 в
#    порядке. Этот параметр должен быть указан. Для достижения максимальной точности,
#    убедитесь, что смещения ваших датчиков настроены.
#speed: 50
#    Скорость (в мм/с) перемещения без зондирования во время калибровки.
#    По умолчанию - 50.
#horizontal_move_z: 5
#    Высота (в мм), на которую следует дать команду головке переместиться
#    непосредственно перед началом работы датчика. По умолчанию равно 5.
#max_adjust: 4
#    Предел безопасности, если запрашивается регулировка, превышающая это значение.
#    quad_gantry_level прервется.
#retries: 0
#    Количество повторных попыток, если точки зондирования не находятся в пределах
#    допуска.
#retry_tolerance: 0
#    Если включены повторные попытки, то повторите попытку, если наибольшая и наименьшая прозондированные
#    точки отличаются больше, чем допуск retry_tolerance.
```

### [skew_correction]

Коррекция перекоса принтера. С помощью программного обеспечения можно исправить перекос принтера в трех плоскостях - xy, xz, yz. Это делается путем печати калибровочной модели вдоль плоскости и измерения трех длин. В силу особенностей коррекции перекоса эти длины задаются с помощью gcode. Подробности см. в разделе [Skew Correction](Skew_Correction.md) и [Command Reference](G-Codes.md#skew_correction).

```
[skew_correction]
```

### [z_thermal_adjust]

Регулировка положения Z головки инструмента в зависимости от температуры. Компенсация вертикального перемещения головки инструмента, вызванного тепловым расширением рамы принтера, в режиме реального времени с помощью датчика температуры (обычно подключаемого к вертикальной части рамы).

Смотрите также: [расширенные команды g-кода](G-Codes.md#z_thermal_adjust).

```
[z_thermal_adjust]
#temp_coeff:
#    Температурный коэффициент расширения, в мм/degC. Например.
# temp_coeff 0,01 мм/degC будет перемещать ось Z вниз на 0,01 мм за
#    каждый градус Цельсия, на который увеличивается температура датчика. По умолчанию
#    0,0 мм/градус Цельсия, при котором корректировка не применяется.
#smooth_time:
#    Окно сглаживания, применяемое к датчику температуры, в секундах. Может уменьшить
#    шум двигателя от чрезмерно малых коррекций в ответ на шум датчика.
#    По умолчанию 2,0 секунды.
#z_adjust_off_above:
#    Отключает корректировку выше данной высоты Z [мм]. Последняя рассчитанная коррекция
#    будет применяться до тех пор, пока головка инструмента не переместится ниже указанной высоты Z
#    снова. По умолчанию 99999999.0 мм (всегда включена).
#max_z_adjustment:
#    Максимальная абсолютная корректировка, которая может быть применена к оси Z [мм]. По
#    по умолчанию 99999999.0 мм (неограниченно).
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#    Конфигурация датчика температуры.
#    См. раздел "Экструдер" для определения вышеуказанных
#    параметров.
#gcode_id:
#    Определение этого параметра см. в разделе "Нагреватель_генератора".
#    параметра.
```

## Индивидуальная наводка

### [safe_z_home]

Безопасная установка оси Z. С помощью этого механизма можно установить ось Z на определенную координату X, Y. Это полезно, если, например, инструментальная головка должна переместиться в центр станины, прежде чем ось Z будет установлена.

```
[safe_z_home]
home_xy_position:
#    Координаты X, Y (например, 100, 100), по которым должно быть выполнено Z-самонаведение.
#    выполняться. Этот параметр должен быть предоставлен.
#speed: 50.0
#    Скорость, с которой головка инструмента перемещается в безопасную точку Z.
#    координате. По умолчанию 50 мм/с.
#z_hop:
#    Расстояние (в мм) для подъема оси Z перед установкой в исходное положение. Это значение
#    применяется к любой команде наведения, даже если она не наводит ось Z.
#    Если ось Z уже установлена и текущее положение Z меньше
#    чем z_hop, то эта команда поднимет головку на высоту z_hop. Если
#    ось Z еще не выведена, то головка будет поднята на высоту z_hop.
#    По умолчанию Z-хоп не используется.
#z_hop_speed: 15.0
#    Скорость (в мм/с), с которой ось Z поднимается перед самонаведением. По
#    по умолчанию составляет 15 мм/с.
#move_to_previous: False
#    Если установлено значение True, оси X и Y возвращаются в свои предыдущие
#    положения после наведения оси Z. По умолчанию установлено значение False.
```

### [homing_override]

Переопределение наведения. С помощью этого механизма можно запустить серию команд g-кода вместо G28, используемого при обычном вводе g-кода. Это может быть полезно для принтеров, которые требуют специальной процедуры для установки машины в исходное положение.

```
[homing_override]
gcode:
#    Список команд G-кода для выполнения вместо команд G28.
#    встречающихся в обычном вводе G-кода. См. docs/Command_Templates.md
#    для формата G-кода. Если G28 содержится в этом списке команд.
#    то она вызовет обычную процедуру возврата принтера в исходное положение.
#    Команды, перечисленные здесь, должны вывести все оси. Этот параметр должен быть
#    быть предоставлен.
#axes: xyz
#    Оси для переопределения. Например, если этот параметр имеет значение "z", то скрипт
#    скрипт переопределения будет выполняться только при наведении оси z (например, через
#    команду "G28" или "G28 Z0"). Обратите внимание, что сценарий переопределения должен
#    по-прежнему устанавливать все оси. По умолчанию используется значение "xyz", которое заставляет
#    скрипт переопределения будет выполняться вместо всех команд G28.
#set_position_x:
#set_position_y:
#set_position_z:
#    Если указано, принтер будет считать, что ось находится в указанном
#    позиции перед выполнением вышеуказанных команд g-кода. Установка этого параметра
#    отключает проверку наведения для этой оси. Это может быть полезно, если
#    головка должна перемещаться до того, как будет задействован обычный механизм G28 для оси
#    оси. По умолчанию положение оси не задается.
```

### [endstop_phase]

Конечные остановки с регулировкой фазы шагового механизма. Чтобы использовать эту функцию, определите секцию конфигурации с префиксом "endstop_phase", за которым следует имя соответствующей секции конфигурации степпера (например, "[endstop_phase stepper_z]"). Эта функция может повысить точность переключения конечных остановок. Добавьте голое объявление "[endstop_phase]", чтобы включить команду ENDSTOP_PHASE_CALIBRATE.

Дополнительную информацию см. в руководстве [Endstop Phases guide](Endstop_Phase.md) и [command reference](G-Codes.md#endstop_phase).

```
[endstop_phase stepper_z]
#endstop_accuracy:
#    Устанавливает ожидаемую точность (в мм) концевого упора. Это представляет собой
#    максимальное расстояние ошибки, на котором может сработать концевой ограничитель (например, если
#    концевой упор может иногда срабатывать на 100 м раньше или до 100 м позже
#    то установите значение 0.200 для 200um). По умолчанию
#    4*расстояние_вращения/полное_количество_шагов_на_вращение.
#    фаза_триггера:
#    Здесь указывается фаза драйвера шагового двигателя, которую следует ожидать
#    при ударе о конечный ограничитель. Она состоит из двух чисел, разделенных
#    символом прямой косой черты - фаза и общее количество
#    фаз (например, "7/64"). Устанавливайте это значение только в том случае, если вы уверены, что
#    драйвер шагового двигателя сбрасывается каждый раз при перезагрузке микроконтроллера. Если это значение
#    не установлено, то фаза шагового двигателя будет определена при первом
#    доме и эта фаза будет использоваться во всех последующих домах.
#endstop_align_zero: False
#    Если установлено значение true, то позиционный_концевой_стоп оси будет эффективно
#    изменен таким образом, что нулевая позиция для оси происходит на полном
#    шаге шагового двигателя. (Если используется на оси Z и высота печатного
#    высота слоя печати кратна расстоянию полного шага, то каждый
#    слой будет располагаться на полном шаге). По умолчанию установлено значение False.
```

## Макросы и события G-кода

### [gcode_macro]

Макросы G-кода (можно определить любое количество секций с префиксом "gcode_macro"). Дополнительную информацию см. в руководстве [Шаблоны команд] (Command_Templates.md).

```
gcode_macro my_cmd]
#gcode:
#    Список команд G-кода для выполнения вместо "my_cmd". См.
#    docs/Command_Templates.md для формата G-кода. Этот параметр должен быть
#    быть предоставлен.
#    переменная_<имя>:
#    Можно указать любое количество параметров с префиксом "переменная_".
#    Заданному имени переменной будет присвоено заданное значение (разобранное
#    как литерал Python) и будет доступно при расширении макроса.
#    Например, конфигурация с "variable_fan_speed = 75" может содержать
#    gcode-команды, содержащие "M106 S{ fan_speed * 255 }". Переменные
#    могут быть изменены во время выполнения программы с помощью команды SET_GCODE_VARIABLE
#    (подробности см. в файле docs/Command_Templates.md). Имена переменных могут
#    не использовать символы верхнего регистра.
#rename_existing:
#    Этот параметр заставит макрос переопределить существующую команду G-Code
#    команду и предоставить предыдущее определение команды через
#    имя, указанное здесь. Это можно использовать для переопределения встроенных G-Code
#    команды. При переопределении команд следует соблюдать осторожность, так как это может
#    привести к сложным и неожиданным результатам. По умолчанию не следует
#    переопределять существующую команду G-Code.
#description: Макрос G-кода
#    Это добавит краткое описание, используемое в команде HELP или при
#    использовании функции автоматического завершения. По умолчанию "макрос G-кода"
```

### [delayed_gcode]

Выполнение gcode с заданной задержкой. Дополнительную информацию см. в [руководстве по шаблонам команд](Command_Templates.md#delayed-gcodes) и [справочнике команд](G-Codes.md#delayed_gcode).

```
[delayed_gcode my_delayed_gcode]
gcode:
#    Список команд G-кода для выполнения, когда длительность задержки
#    истекло. Поддерживаются шаблоны G-кода. Этот параметр должен быть
#    предоставлен.
#initial_duration: 0.0
#    Длительность начальной задержки (в секундах). Если задано
#    ненулевое значение, то отложенный_гкод будет выполняться указанное количество
#    секунд после того, как принтер перейдет в состояние "готов". Это может быть
#    полезным для процедур инициализации или повторяющегося delayed_gcode.
#    Если установлено значение 0, отложенный_gcode не будет выполняться при запуске.
#    По умолчанию 0.
```

### [save_variables]

Поддержка сохранения переменных на диск, чтобы они сохранялись после перезапуска. Дополнительную информацию см. в [шаблонах команд](Command_Templates.md#save-variables-to-disk) и [справочнике G-кодов](G-Codes.md#save_variables).

```
[save_variables]
filename:
#    Требуется - укажите имя файла, который будет использоваться для сохранения
#    переменных на диск, например ~/variables.cfg
```

### [idle_timeout]

Таймаут простоя. Таймаут простоя включается автоматически - добавьте явную секцию конфигурации idle_timeout, чтобы изменить настройки по умолчанию.

```
[idle_timeout]
#gcode:
#    Список команд G-кода для выполнения по таймауту простоя. См.
#    docs/Command_Templates.md для формата G-кода. По умолчанию выполняется
#    "TURN_OFF_HEATERS" и "M84".
#timeout: 600
#    Время простоя (в секундах) для ожидания перед выполнением вышеуказанных G-кодов
#    команды. По умолчанию установлено значение 600 секунд.
```

## Optional G-Code features

### [virtual_sdcard]

Виртуальная sdcard может быть полезна, если хост-машина недостаточно быстра для хорошей работы OctoPrint. Она позволяет хост-программе Klipper напрямую печатать файлы gcode, хранящиеся в каталоге на хосте, используя стандартные команды sdcard G-Code (например, M24).

```
[virtual_sdcard]
путь:
#    Путь к локальному каталогу на хост-машине для поиска
#    файлы g-кода. Это каталог, доступный только для чтения (запись файлов sdcard
#    не поддерживается). Можно указать на каталог загрузки OctoPrint.
#    каталог (обычно ~/.octoprint/uploads/ ). Этот параметр должен
#    быть предоставлен.
#on_error_gcode:
#    Список команд G-кода для выполнения при сообщении об ошибке.
#    Формат G-кода см. в файле docs/Command_Templates.md. По умолчанию
#    выполнить TURN_OFF_HEATERS.
```

### [sdcard_loop]

Некоторые принтеры с функцией очистки этапа, такие как выталкиватель деталей или ленточный принтер, могут найти применение в зацикливании секций файла sdcard. (Например, для печати одной и той же детали снова и снова или повторения участка детали для создания цепочки или другого повторяющегося узора).

Поддерживаемые команды см. в [справочнике команд](G-Codes.md#sdcard_loop). Файл [sample-macros.cfg](../config/sample-macros.cfg) для макроса G-кода M808, совместимого с Marlin.

```
[sdcard_loop]
```

### [force_move]

Поддержка ручного перемещения шаговых двигателей в целях диагностики. Обратите внимание, что использование этой функции может перевести принтер в нерабочее состояние - важные подробности см. в [справочнике команд](G-Codes.md#force_move).

```
[force_move]
#enable_force_move: False
#    Установите значение true, чтобы включить FORCE_MOVE и SET_KINEMATIC_POSITION
#    расширенные команды G-кода. По умолчанию установлено значение false.
```

### [pause_resume]

Функции паузы/возобновления с поддержкой захвата и восстановления позиции. Дополнительную информацию см. в [справочнике команд](G-Codes.md#pause_resume).

```
[pause_resume]
#recover_velocity: 50.
#    Когда захват/восстановление включен, скорость, с которой нужно вернуться в
#    захваченному положению (в мм/с). По умолчанию 50,0 мм/с.
```

### [firmware_retraction]

Втягивание нити прошивки. Это позволяет выполнять GCODE-команды G10 (втягивание) и G11 (оттягивание), выдаваемые многими слайсерами. Приведенные ниже параметры являются начальными значениями по умолчанию, однако их можно настроить с помощью команды SET_RETRACTION [command](G-Codes.md#firmware_retraction)), что позволяет устанавливать параметры для каждого филамента и настраивать их во время работы.

```
[firmware_retraction]
#retract_length: 0
#    Длина нити (в мм) для втягивания при активации G10,
#    и не втягивать при активации G11 (но см.
#    unretract_extra_length ниже). По умолчанию 0 мм.
#retract_speed: 20
#    Скорость втягивания, в мм/с. По умолчанию 20 мм/с.
#unretract_extra_length: 0
#    Длина (в мм) *дополнительной* нити, которую нужно добавить при
#    распутывании.
#unretract_speed: 10
#    Скорость распутывания, в мм/с. По умолчанию 10 мм/с.
```

### [gcode_arcs]

Поддержка команд gcode arc (G2/G3).

```
[gcode_arcs]
#разрешение: 1.0
#    Дуга будет разбита на сегменты. Длина каждого сегмента будет
#    равна разрешению в мм, заданному выше. При меньших значениях получится
#    более тонкую дугу, но и больше работы для вашего станка. Дуги меньше, чем
#    заданного значения, станут прямыми линиями. По умолчанию
#    1 мм.
```

### [respond]

Включите расширенные [команды] "M118" и "RESPOND" (G-Codes.md#respond).

```
[ответить]
#default_type: echo
#    Устанавливает префикс вывода "M118" и "RESPOND" по умолчанию в одно из следующих значений
#        из следующих:
#        echo: "echo: " (Это значение по умолчанию)
#        command: "// "
#    error: "!! "
#default_prefix: echo:
#    Непосредственно задает префикс по умолчанию. Если он присутствует, это значение будет
#    отменяет значение "default_type".
```

### [exclude_object]

Включает поддержку исключения или отмены отдельных объектов в процессе печати.

Дополнительную информацию см. в руководстве [exclude objects guide](Exclude_Object.md) и [command reference](G-Codes.md#excludeobject). Смотрите файл [sample-macros.cfg](../config/sample-macros.cfg) для макроса G-кода M486, совместимого с Marlin/RepRapFirmware.

```
[exclude_object]
```

## Компенсация резонанса

### [input_shaper]

Включает [компенсацию резонанса](Resonance_Compensation.md). Также см. справочник [команд](G-Codes.md#input_shaper).

```
[input_shaper]
#shaper_freq_x: 0
#    Частота (в Гц) входного формирователя для оси X. Это
#    обычно резонансная частота оси X, которую входной формирователь
#    должен подавлять. Для более сложных формирователей, например 2- и 3-горбых EI
#    входных формирователей, этот параметр может быть задан из различных
#    соображений. Значение по умолчанию равно 0, что отключает входной
#    формирователь для оси X.
#shaper_freq_y: 0
#    Частота (в Гц) входного шейпера для оси Y. Это
#    обычно резонансная частота оси Y, которую входной формирователь
#    должен подавлять. Для более сложных формирователей, например 2- и 3-горбых EI
#    входных формирователей, этот параметр может быть задан из различных
#    соображений. Значение по умолчанию равно 0, что отключает входной
#    формирователь для оси Y.
#shaper_type: mzv
#    Тип входного формирователя, который будет использоваться для осей X и Y. Поддерживаемые
#    шейперы: zv, mzv, zvd, ei, 2hump_ei и 3hump_ei. По умолчанию
#    является входной шейпер mzv.
#shaper_type_x:
#shaper_type_y:
#    Если тип_шейпера не задан, эти два параметра можно использовать для того, чтобы
#    настроить разные входные формирователи для осей X и Y. Те же
#    значения, что и для параметра shaper_type.
#damping_ratio_x: 0.1
#damping_ratio_y: 0.1
#    Коэффициенты демпфирования вибраций по осям X и Y, используемые входными формирователями
#    для улучшения подавления вибраций. Значение по умолчанию - 0,1, что является
#    хорошим универсальным значением для большинства принтеров. В большинстве случаев этот
#    параметр не требует настройки и не должен изменяться.
```

### [adxl345]

Поддержка акселерометров ADXL345. Эта поддержка позволяет запрашивать измерения акселерометра у датчика. Для этого используется команда ACCELEROMETER_MEASURE (более подробную информацию см. в [G-Codes](G-Codes.md#adxl345)). По умолчанию используется имя чипа "default", но можно указать явное имя (например, [adxl345 my_chip_name]).

```
[adxl345]
cs_pin:
#    Контакт разрешения SPI для датчика. Этот параметр должен быть указан.
#spi_speed: 5000000
#    Скорость SPI (в гц), используемая при обмене данными с чипом.
#    По умолчанию 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    См. раздел "Общие настройки SPI" для описания
#    вышеуказанных параметров.
#axes_map: x, y, z
#    Ось акселерометра для каждой из осей X, Y и Z принтера.
#    Это может быть полезно, если акселерометр установлен в
#    ориентации, которая не совпадает с ориентацией принтера. Например,
#    например, можно установить значение "y, x, z", чтобы поменять местами оси X и Y.
#    Также можно отменить ось, если акселерометр
#    направление меняется на противоположное (например, "x, z, -y"). По умолчанию используется значение "x, y, z".
# rate: 3200
#    Скорость передачи выходных данных для ADXL345. ADXL345 поддерживает следующие данные
#    скорости: 3200, 1600, 800, 400, 200, 100, 50 и 25. Обратите внимание, что
#    не рекомендуется изменять эту скорость по сравнению с 3200 по умолчанию, и
#    скорости ниже 800 значительно ухудшают качество резонансных
#    измерений.
```

### [icm20948]

Support for icm20948 accelerometers.

```
[icm20948]
#i2c_address:
#   Default is 104 (0x68). If AD0 is high, it would be 0x69 instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [lis2dw]

Поддержка акселерометров LIS2DW.

```
[lis2dw]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [lis3dh]

Support for LIS3DH accelerometers.

```
[lis3dh]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [mpu9250]

Поддержка акселерометров MPU-9250, MPU-9255, MPU-6515, MPU-6050 и MPU-6500 (можно задать любое количество секций с префиксом "mpu9250").

```
[mpu9250 my_accelerometer]
#i2c_address:
#    По умолчанию 104 (0x68). Если AD0 имеет высокий уровень, вместо него будет 0x69.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#    См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров. По умолчанию "i2c_speed" равно 400000.
# axes_map: x, y, z
#    Информацию об этом параметре см. в разделе "adxl345".
```

### [resonance_tester]

Поддержка тестирования резонансов и автоматической калибровки входного формирователя. Для использования большей части функциональности этого модуля необходимо установить дополнительные программные зависимости; за дополнительной информацией обратитесь к разделу [Измерение резонансов](Measuring_Resonances.md) и справочнику [Команда](G-Codes.md#resonance_tester). Дополнительную информацию о параметре `max_smoothing` и его использовании см. в разделе [Max smoothing](Measuring_Resonances.md#max-smoothing) руководства по измерению резонансов.

```
[resonance_tester]
#probe_points:
#   A list of X, Y, Z coordinates of points (one point per line) to test
#   resonances at. At least one point is required. Make sure that all
#   points with some safety margin in XY plane (~a few centimeters)
#   are reachable by the toolhead.
#accel_chip:
#   A name of the accelerometer chip to use for measurements. If
#   adxl345 chip was defined without an explicit name, this parameter
#   can simply reference it as "accel_chip: adxl345", otherwise an
#   explicit name must be supplied as well, e.g. "accel_chip: adxl345
#   my_chip_name". Either this, or the next two parameters must be
#   set.
#accel_chip_x:
#accel_chip_y:
#   Names of the accelerometer chips to use for measurements for each
#   of the axis. Can be useful, for instance, on bed slinger printer,
#   if two separate accelerometers are mounted on the bed (for Y axis)
#   and on the toolhead (for X axis). These parameters have the same
#   format as 'accel_chip' parameter. Only 'accel_chip' or these two
#   parameters must be provided.
#max_smoothing:
#   Maximum input shaper smoothing to allow for each axis during shaper
#   auto-calibration (with 'SHAPER_CALIBRATE' command). By default no
#   maximum smoothing is specified. Refer to Measuring_Resonances guide
#   for more details on using this feature.
#move_speed: 50
#   The speed (in mm/s) to move the toolhead to and between test points
#   during the calibration. The default is 50.
#min_freq: 5
#   Minimum frequency to test for resonances. The default is 5 Hz.
#max_freq: 133.33
#   Maximum frequency to test for resonances. The default is 133.33 Hz.
#accel_per_hz: 60
#   This parameter is used to determine which acceleration to use to
#   test a specific frequency: accel = accel_per_hz * freq. Higher the
#   value, the higher is the energy of the oscillations. Can be set to
#   a lower than the default value if the resonances get too strong on
#   the printer. However, lower values make measurements of
#   high-frequency resonances less precise. The default value is 75
#   (mm/sec).
#hz_per_sec: 1
#   Determines the speed of the test. When testing all frequencies in
#   range [min_freq, max_freq], each second the frequency increases by
#   hz_per_sec. Small values make the test slow, and the large values
#   will decrease the precision of the test. The default value is 1.0
#   (Hz/sec == sec^-2).
#sweeping_accel: 400
#   An acceleration of slow sweeping moves. The default is 400 mm/sec^2.
#sweeping_period: 1.2
#   A period of slow sweeping moves. Setting this parameter to 0
#   disables slow sweeping moves. Avoid setting it to a too small
#   non-zero value in order to not poison the measurements.
#   The default is 1.2 sec which is a good all-round choice.
```

## Помощники для конфигурационных файлов

### [board_pins]

Псевдонимы выводов платы (можно задать любое количество секций с префиксом "board_pins"). Используйте это для определения псевдонимов выводов микроконтроллера.

```
[board_pins my_aliases]
mcu: mcu
#   A comma separated list of micro-controllers that may use the
#   aliases. The default is to apply the aliases to the main "mcu".
aliases:
aliases_<name>:
#   A comma separated list of "name=value" aliases to create for the
#   given micro-controller. For example, "EXP1_1=PE6" would create an
#   "EXP1_1" alias for the "PE6" pin. However, if "value" is enclosed
#   in "<>" then "name" is created as a reserved pin (for example,
#   "EXP1_9=<GND>" would reserve "EXP1_9"). Any number of options
#   starting with "aliases_" may be specified.
```

### [включить]

Поддержка включаемых файлов. Можно включить дополнительный файл конфигурации из основного файла конфигурации принтера. Также могут использоваться символы подстановки (например, "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

Этот инструмент позволяет многократно определять один вывод микроконтроллера в конфигурационном файле без обычной проверки ошибок. Это предназначено для диагностики и отладки. Этот раздел не нужен там, где Klipper поддерживает многократное использование одного и того же вывода, и использование этого переопределения может привести к запутанным и неожиданным результатам.

```
[duplicate_pin_override]
пины:
#    Список пинов, разделенных запятыми, который может быть использован несколько раз в
#    конфигурационном файле без обычных проверок на ошибки. Этот параметр должен быть
#    предоставлен.
```

## Оборудование для зондирования кровати

### [зонд]

Датчик высоты Z. Эту секцию можно определить, чтобы включить аппаратное обеспечение зондирования высоты Z. Когда эта секция включена, становятся доступными расширенные команды [g-кода] PROBE и QUERY_PROBE (G-Codes.md#probe). Также см. руководство по калибровке [probe calibrate](Probe_Calibrate.md). Секция probe также создает виртуальный вывод "probe:z_virtual_endstop". На принтерах картезианского типа, использующих датчик вместо концевого упора по оси z, можно установить контакт stepper_z endstop_pin на этот виртуальный контакт. Если вы используете "probe:z_virtual_endstop", то не определяйте position_endstop в разделе конфигурации stepper_z.

```
[probe]
pin:
#    Контакт обнаружения зонда. Если этот вывод находится на другом микроконтроллере.
#    чем Z-шаговый, то он включает "multi-mcu homing". Этот
#    параметр должен быть указан.
#deactivate_on_each_sample: True
#    Этот параметр определяет, должен ли Klipper выполнять gcode деактивации
#    между каждой попыткой зондирования при выполнении последовательности из нескольких зондирований
#    последовательности. По умолчанию установлено значение True.
#x_offset: 0.0
#    Расстояние (в мм) между зондом и соплом по оси
#    оси x. По умолчанию равно 0.
#y_offset: 0.0
#    Расстояние (в мм) между зондом и соплом по оси
#    оси y. По умолчанию равно 0.
z_offset:
#    Расстояние (в мм) между станиной и соплом, когда зонд
#    срабатывает. Этот параметр должен быть предоставлен.
#speed: 5.0
#    Скорость (в мм/с) оси Z при зондировании. По умолчанию 5 мм/с.
#samples: 1
#    Количество раз для зондирования каждой точки. Полученные значения z
#    будут усреднены. По умолчанию зондирование выполняется 1 раз.
#sample_retract_dist: 2.0
#    Расстояние (в мм), на которое следует поднимать головку инструмента между каждым образцом (если
#    отбора проб более одного раза). По умолчанию - 2 мм.
#lift_speed:
#    Скорость (в мм/с) оси Z при подъеме зонда между
#    пробами. По умолчанию используется то же значение, что и параметр 'speed'
#    параметр.
#samples_result: average
#    Метод расчета при более чем однократной выборке - либо
#    "медиана" или "среднее". По умолчанию используется среднее значение.
#samples_tolerance: 0.100
#    Максимальное расстояние по Z (в мм), на которое образец может отличаться от других
#    образцов. Если этот допуск превышен, то либо сообщается об ошибке
#    сообщается об ошибке, либо попытка перезапускается (см.
# samples_tolerance_retries). По умолчанию 0,100 мм.
#samples_tolerance_retries: 0
#    Количество повторных попыток, если найден образец, превышающий
# samples_tolerance. При повторной попытке все текущие образцы отбрасываются
#    и попытка зондирования начинается заново. Если правильный набор образцов
#    не получен за заданное число повторных попыток, то об ошибке
#    сообщается об ошибке. По умолчанию равно нулю, что приводит к сообщению об ошибке
#    на первом образце, превышающем samples_tolerance.
#activate_gcode:
#    Список команд G-кода для выполнения перед каждой попыткой зондирования.
#    Формат G-кода см. в файле docs/Command_Templates.md. Это может быть
#    полезным, если зонд нужно активировать каким-либо образом. Не следует
#    вводить сюда команды, которые перемещают головку инструмента (например, G1). По адресу
#    по умолчанию не запускать никаких специальных команд G-кода при активации.
#deactivate_gcode:
#    Список команд G-кода для выполнения после каждой попытки зондирования
#    завершается. Формат G-кода см. в файле docs/Command_Templates.md. Не следует
#    выполнять здесь команды, которые перемещают головку инструмента. По умолчанию
#    не выполнять никаких специальных команд G-кода при деактивации.
```

### [bltouch]

Сенсорный датчик BLTouch. Можно определить эту секцию (вместо секции зонда), чтобы включить зонд BLTouch. Дополнительную информацию см. в [BL-Touch guide](BLTouch.md) и [command reference](G-Codes.md#bltouch). Также создается виртуальный вывод "probe:z_virtual_endstop" (подробности см. в разделе "probe").

```
[bltouch]
sensor_pin:
#    Контакт, подключенный к контакту датчика BLTouch. Большинство устройств BLTouch
#    требуют подтяжки к выводу датчика (префикс имени вывода - "^").
#    Этот параметр должен быть указан.
control_pin:
#    Контакт, подключенный к управляющему контакту BLTouch. Этот параметр должен быть
#    предоставлен.
#pin_move_time: 0.680
#    Количество времени (в секундах), в течение которого нужно ждать, пока пин BLTouch
#    перемещение вверх или вниз. По умолчанию 0,680 секунды.
#stow_on_each_sample: True
#    Это определяет, должен ли Klipper давать команду штырьку двигаться вверх
#    между каждой попыткой зондирования при выполнении последовательности из нескольких зондирований
#    последовательности. Прочитайте инструкции в файле docs/BLTouch.md, прежде чем устанавливать значение
#    это значение на False. По умолчанию установлено значение True.
#probe_with_touch_mode: False
#    Если это значение установлено в True, то Klipper будет зондировать устройство в
#    "touch_mode". По умолчанию установлено значение False (зондирование в режиме "pin_down").
#pin_up_reports_not_triggered: True
#    Устанавливается, если BLTouch постоянно сообщает о том, что пробник находится в состоянии "не
#    сработал" после успешной команды "pin_up". Это должно
#    быть True для всех подлинных устройств BLTouch. Прочитайте инструкции в
#    docs/BLTouch.md, прежде чем устанавливать значение False. По умолчанию установлено значение True.
#pin_up_touch_mode_reports_triggered: True
#    Устанавливает, будет ли BLTouch постоянно сообщать о состоянии "срабатывания" после
#    команды "pin_up", за которой следует "touch_mode". Это должно быть
#    True для всех настоящих устройств BLTouch. Прочитайте инструкции в
#    docs/BLTouch.md, прежде чем устанавливать значение False. По умолчанию установлено значение True.
#set_output_mode:
#    Запрашивает определенный режим вывода контактов датчика на BLTouch V3.0 (и
#    более поздних версий). Эта настройка не должна использоваться для других типов датчиков.
#    Установите значение "5V", чтобы запросить выход датчика на 5 вольт (используйте только в том случае, если
#    плата контроллера нуждается в режиме 5 В и допускает 5 В на своем входе
#    сигнальной линии). Установите значение "OD", чтобы запросить использование выхода датчика в режиме
#    режим открытого стока. По умолчанию режим вывода не запрашивается.
#x_offset:
#y_offset:
#z_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#    Информацию об этих параметрах см. в разделе "probe".
```

### [smart_effector]

Smart Effector" из Duet3d реализует Z-зонд с помощью датчика силы. Можно определить эту секцию вместо `[probe]`, чтобы включить специфические функции Smart Effector. Это также позволяет использовать [runtime commands](G-Codes.md#smart_effector) для настройки параметров Smart Effector во время выполнения.

```
[smart_effector]
pin:
#    Контакт, подключенный к выходному контакту Smart Effector Z Probe (контакт 5). Обратите внимание, что
#    подтягивающий резистор на плате обычно не требуется. Однако если
#    выходной контакт подключен к контакту платы с подтягивающим резистором, этот
#    резистор должен иметь высокое значение (например, 10K Ом или более). На некоторых платах подтягивающий резистор имеет низкое
#    подтягивающий резистор на входе датчика Z, что, скорее всего, приведет к тому, что
#    всегда задействованному состоянию датчика. В этом случае подключите интеллектуальный эффектор к
#    другому выводу на плате. Этот параметр является обязательным.
#control_pin:
#    Контакт, подключенный к входному контакту управления Smart Effector (контакт 7). Если задан,
#    становятся доступны команды программирования чувствительности Smart Effector.
#probe_accel:
#    Если установлен, ограничивает ускорение перемещения зонда (в мм/сек^2).
#    Внезапное большое ускорение в начале движения зонда может
#    привести к ложным срабатываниям датчика, особенно если хотэнд тяжелый.
#    Чтобы предотвратить это, может потребоваться уменьшить ускорение
#    движения зонда с помощью этого параметра.
#    время_восстановления: 0,4
#    Задержка между перемещением и перемещением зонда в секундах. Быстрое
#    перемещение перед зондированием может привести к ложным срабатываниям зонда.
#    Это может привести к ошибке "Зонд сработал до перемещения", если задержка не установлена.
#    не установлена. Значение 0 отключает задержку восстановления.
#    Значение по умолчанию - 0,4.
#x_offset:
#y_offset:
#    следует оставить без значения (или установить на 0).
z_offset:
#    Высота срабатывания датчика. Начните с -0,1 (мм), а затем скорректируйте с помощью
#    команды `PROBE_CALIBRATE`. Этот параметр должен быть указан.
#speed:
#    Скорость (в мм/с) оси Z при выполнении зондирования. Рекомендуется начинать
#    со скорости зондирования 20 мм/с и регулировать ее по мере необходимости для повышения
#    точности и повторяемости срабатывания датчика.
# образцы:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#deactivate_on_each_sample:
#    Дополнительные сведения о параметрах см. в разделе "Зонд".
```

### [probe_eddy_current]

Поддержка вихретоковых индуктивных датчиков. Можно определить эту секцию (вместо секции зонда), чтобы включить этот зонд. Дополнительную информацию см. в [справочнике команд](G-Codes.md#probe_eddy_current).

```
[probe_eddy_current my_eddy_probe]
sensor_type: ldc1612
#   The sensor chip used to perform eddy current measurements. This
#   parameter must be provided and must be set to ldc1612.
#frequency:
#   The external crystal frequency (in Hz) of the LDC1612 chip.
#   The default is 12000000.
#intb_pin:
#   MCU gpio pin connected to the ldc1612 sensor's INTB pin (if
#   available). The default is to not use the INTB pin.
#z_offset:
#   The nominal distance (in mm) between the nozzle and bed that a
#   probing attempt should stop at. This parameter must be provided.
#i2c_address:
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   The i2c settings for the sensor chip. See the "common I2C
#   settings" section for a description of the above parameters.
#x_offset:
#y_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   See the "probe" section for information on these parameters.
```

### [axis_twist_compensation]

A tool to compensate for inaccurate probe readings due to twist in X or Y gantry. See the [Axis Twist Compensation Guide](Axis_Twist_Compensation.md) for more detailed information regarding symptoms, configuration and setup.

```
[axis_twist_compensation]
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
calibrate_start_x: 20
#   Defines the minimum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the starting
#   calibration position.
calibrate_end_x: 200
#   Defines the maximum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the ending
#   calibration position.
calibrate_y: 112.5
#   Defines the Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle during the
#   calibration process. This parameter is recommended to
#   be near the center of the bed

# For Y-axis twist compensation, specify the following parameters:
calibrate_start_y: ...
#   Defines the minimum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the starting
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_end_y: ...
#   Defines the maximum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the ending
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_x: ...
#   Defines the X coordinate of the calibration for Y axis twist compensation
#   This should be the X coordinate that positions the nozzle during the
#   calibration process for Y axis twist compensation. This parameter must be
#   provided and is recommended to be near the center of the bed.
```

## Дополнительные шаговые двигатели и экструдеры

### [stepper_z1]

Многошаговые оси. В принтере, работающем в картезианском стиле, степпер, управляющий данной осью, может иметь дополнительные блоки конфигурации, определяющие степперы, которые должны работать в паре с основным степпером. Можно задать любое количество секций с числовым суффиксом, начиная с 1 (например, "stepper_z1", "stepper_z2" и т. д.).

```
[stepper_z1]
#step_pin:
#dir_pin:
#enable_pin:
#микрошаги:
#rotation_distance:
#    Определение вышеуказанных параметров см. в разделе "степпер".
#endstop_pin:
#    Если для дополнительного шагового механизма задан штифт endstop_pin, то он
#    степпер будет двигаться до тех пор, пока не сработает endstop. В противном случае
#    шаговый механизм будет перемещаться до тех пор, пока не сработает концевой упор на основном шаговом механизме для
#    оси не сработает.
```

### [экструдер1]

В принтере с несколькими экструдерами добавьте дополнительную секцию для каждого экструдера. Дополнительные секции экструдера должны называться " экструдер1", "экструдер2", "экструдер3" и так далее. Описание доступных параметров смотрите в разделе "Экструдер".

Пример конфигурации смотрите в [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg).

```
[extruder1]
#step_pin:
#dir_pin:
#...
#    См. раздел "Экструдер" для получения информации о доступных шаговых и нагревательных
#    параметры.
#shared_heater:
#    Эта опция устарела и больше не должна указываться.
```

### [dual_carriage]

Support for cartesian, generic_cartesian and hybrid_corexy/z printers with dual carriages on a single axis. The carriage mode can be set via the SET_DUAL_CARRIAGE extended g-code command. For example, "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation. Note that during G28 homing, typically the primary carriage is homed first followed by the carriage defined in the `[dual_carriage]` config section. However, the `[dual_carriage]` carriage will be homed first if both carriages home in a positive direction and the [dual_carriage] carriage has a `position_endstop` greater than the primary carriage, or if both carriages home in a negative direction and the `[dual_carriage]` carriage has a `position_endstop` less than the primary carriage.

Кроме того, можно использовать команды "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY" или "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR" для активации режима копирования или зеркального отображения двойной каретки, в этом случае она будет следовать за движением каретки 0 соответственно. Эти команды можно использовать для одновременной печати двух деталей - либо двух одинаковых деталей (в режиме COPY), либо зеркально отраженных (в режиме MIRROR). Обратите внимание, что режимы COPY и MIRROR также требуют соответствующей настройки экструдера на двойной каретке, что обычно достигается с помощью команды "SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=<dual_carriage_extruder>" или аналогичной команды.

See [sample-idex.cfg](../config/sample-idex.cfg) for an example configuration with a regular Cartesian kinematic.

```
[dual_carriage]
axis:
#   The axis this extra carriage is on (either x or y). This parameter
#   must be provided.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carriages), the carriages proximity
#   checks will be disabled.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   See the "stepper" section for the definition of the above parameters.
```

For an example of dual carriage configuration with `generic_cartesian` kinematic, see the following configuration [sample](../config/example-generic-caretesian.cfg). Please note that in this case the `[dual_carriage]` configuration deviates from the configuration described above:

```
[dual_carriage my_dc_carriage]
primary_carriage:
#   Defines the matching primary carriage of this dual carriage and
#   the corresponding IDEX axis. Valid choices are x, y, z.
#   This parameter must be provided.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carriages), the carriages proximity
#   checks will be disabled.
endstop_pin:
#position_min:
position_endstop:
position_max:
#homing_speed:
#homing_retract_dist:
#homing_retract_speed:
#second_homing_speed:
#homing_positive_dir:
...
```

Refer to [generic cartesian](#generic-cartesian) section for more information on the regular `carriage` parameters.

Then a user must define one or more stepper motors moving the dual carriage (and other carriages as appropriate), for instance

```
[carriage x]
...

[carriage y]
...

[dual_carriage u]
primary_carriage: x
...

[stepper dc_stepper]
carriages: u-y
...
```

`[dual_carriage]` requires special configuration for the input shaper. In general, it is necessary to run input shaper calibration twice - for the `dual_carriage` and its `primary_carriage` for the axis they share. Then the input shaper can be configured as follows, assuming the example above:

```
[input_shaper]
# Intentionally empty

[delayed_gcode init_shaper]
initial_duration: 0.1
gcode:
  SET_DUAL_CARRIAGE CARRIAGE=u
  SET_INPUT_SHAPER SHAPER_TYPE_X=<dual_carriage_x_shaper> SHAPER_FREQ_X=<dual_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
  SET_DUAL_CARRIAGE CARRIAGE=x
  SET_INPUT_SHAPER SHAPER_TYPE_X=<primary_carriage_x_shaper> SHAPER_FREQ_X=<primary_carriage_x_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
```

Note that `SHAPER_TYPE_Y` and `SHAPER_FREQ_Y` must be the same in both commands in this case, since the same motors drive Y axis when either of the `x` and `u` carriages are active.

It is worth noting that `generic_cartesian` kinematic can support two dual carriages for X and Y axes. For reference, see for instance a [sample](../config/sample-corexyuv.cfg) of CoreXYUV configuration.

### [extruder_stepper]

Поддержка дополнительных степперов, синхронизированных с движением экструдера (можно определить любое количество секций с префиксом "extruder_stepper").

Дополнительную информацию см. в [справочнике команд](G-Codes.md#extruder).

```
[extruder_stepper my_extra_stepper].
extruder:
#    Экструдер, с которым синхронизируется этот степпер. Если это значение установлено в
#    пустая строка, то степпер не будет синхронизирован с
#    экструдером. Этот параметр должен быть указан.
#step_pin:
#dir_pin:
#enable_pin:
#микрошаги:
#rotation_distance:
#    См. раздел "Степпер" для определения вышеуказанных
#    параметров.
```

### [manual_stepper]

Ручные степперы (можно определить любое количество секций с префиксом "manual_stepper"). Это степперы, которые управляются командой g-кода MANUAL_STEPPER. Например: "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". Описание команды MANUAL_STEPPER см. в файле [G-Codes](G-Codes.md#manual_stepper). Шаговые механизмы не связаны с обычной кинематикой принтера.

```
[manual_stepper my_stepper]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   See the "stepper" section for a description of these parameters.
#velocity:
#   Set the default velocity (in mm/s) for the stepper. This value
#   will be used if a MANUAL_STEPPER command does not specify a SPEED
#   parameter. The default is 5mm/s.
#accel:
#   Set the default acceleration (in mm/s^2) for the stepper. An
#   acceleration of zero will result in no acceleration. This value
#   will be used if a MANUAL_STEPPER command does not specify an ACCEL
#   parameter. The default is zero.
#endstop_pin:
#   Endstop switch detection pin. If specified, then one may perform
#   "homing moves" by adding a STOP_ON_ENDSTOP parameter to
#   MANUAL_STEPPER movement commands.
#position_min:
#position_max:
#   The minimum and maximum position the stepper can be commanded to
#   move to. If specified then one may not command the stepper to move
#   past the given position. Note that these limits do not prevent
#   setting an arbitrary position with the `MANUAL_STEPPER
#   SET_POSITION=x` command. The default is to not enforce a limit.
```

## Индивидуальные нагреватели и датчики

### [verify_heater]

Проверка нагревателя и датчика температуры. Проверка нагревателя автоматически включается для каждого нагревателя, настроенного на принтере. Используйте секции verify_heater, чтобы изменить настройки по умолчанию.

```
[verify_heater heater_config_name]
#max_error: 120
#   Максимальная "суммарная ошибка температуры" перед тем, как выдать
#   ошибку. Меньшие значения приводят к более строгой проверке, а большие
#   значения позволяют увеличить время до сообщения об ошибке.
#   В частности, температура проверяется раз в секунду, и если она
#   близка к целевой температуре, то внутренний "счетчик ошибок
#   счетчик ошибок" сбрасывается; в противном случае, если температура ниже
#   целевого диапазона, то счетчик увеличивается на величину
#   зарегистрированная температура отличается от этого диапазона. Если счетчик
#   превысит это значение "max_error", то будет выдана ошибка. По умолчанию
#   120.
#check_gain_time:
#   Это контролирует проверку нагревателя во время начального нагрева. Меньшие
#   значения приводят к более строгой проверке, а большие значения позволяют
#   больше времени до сообщения об ошибке. В частности, во время
#   начального нагрева, если температура нагревателя увеличивается
#   в течение этого времени (указанного в секундах), то внутренний
#   "счетчик ошибок" сбрасывается. По умолчанию это 20 секунд для экструдеров
#   и 60 секунд для нагревателя_кровати.
#гистерезис: 5
#   Максимальная разница температур (в градусах Цельсия) с целевой
#   температуры, которая считается в диапазоне целевой. Это
#   управляет проверкой диапазона max_error. Настраивать это
#   значение. По умолчанию это значение равно 5.
#heating_gain: 2
#   Минимальная температура (в градусах Цельсия), на которую должен увеличиться нагреватель.
#   на время проверки check_gain_time. Настраивать это
#   значение. По умолчанию это значение равно 2.
```

### [homing_heaters]

Инструмент для отключения нагревателей при наведении или зондировании оси.

```
[homing_heaters]
#steppers:
#    Список степперов, которые должны вызывать отключение нагревателей, разделенный запятыми.
#    отключены. По умолчанию нагреватели отключаются для любого хоминга/пробивания
#    move.
#    Типичный пример: stepper_z
#heaters:
#    Список нагревателей, которые нужно отключить во время хоминга/пробивания, разделенный запятыми.
#    движения. По умолчанию отключаются все нагреватели.
#    Типичный пример: экструдер, нагревательная_кровать
```

### [термистор]

Пользовательские термисторы (можно определить любое количество секций с префиксом "термистор"). Пользовательский термистор может быть использован в поле sensor_type секции конфигурации нагревателя. (Например, если определить секцию "[термистор мой_термистор]", то при определении нагревателя можно использовать "тип_датчика: мой_термистор"). Обязательно поместите секцию термистора в конфигурационный файл выше ее первого использования в секции нагревателя.

```
[thermistor my_thermistor]
#температура1:
#сопротивление1:
#temperature2:
#сопротивление2:
#temperature3:
#resistance3:
#    Три измерения сопротивления (в Омах) при заданных температурах
#    (в градусах Цельсия). Эти три измерения будут использованы для расчета
#    коэффициентов Штейнхарта-Харта для термистора. Эти параметры
#    должны быть указаны при использовании метода Штейнхарта-Харта для определения
#    термистора.
#beta:
#    Альтернативно, можно определить температуру1, сопротивление1 и бету
#    для определения параметров термистора. Этот параметр должен быть
#    указываться при использовании "beta" для определения термистора.
```

### [adc_temperature]

Пользовательские датчики температуры АЦП (можно определить любое количество секций с префиксом "adc_temperature"). Это позволяет определить пользовательский датчик температуры, который измеряет напряжение на выводе аналого-цифрового преобразователя (ADC) и использует линейную интерполяцию между набором настроенных измерений температуры/напряжения (или температуры/сопротивления) для определения температуры. Полученный датчик можно использовать как тип_датчика в секции нагревателя. (Например, если определить секцию "[adc_temperature my_sensor]", то при определении нагревателя можно использовать "sensor_type: my_sensor"). Обязательно поместите секцию датчика в конфигурационный файл выше ее первого использования в секции нагревателя.

```
[adc_temperature my_sensor]
#температура1:
#voltage1:
#temperature2:
#voltage2:
#...
#    Набор температур (в градусах Цельсия) и напряжений (в вольтах) для использования
#    в качестве ссылки при преобразовании температуры. Секция нагревателя, использующая
#    этот датчик, может также указать параметры adc_voltage и voltage_offset
#    параметры для определения напряжения АЦП (см. раздел "Общие температурные
#    усилители" для получения подробной информации). Необходимо указать как минимум два измерения
#    быть предоставлены.
#температура1:
#сопротивление1:
#температура2:
#сопротивление2:
#...
#    В качестве альтернативы можно указать набор температур (в градусах Цельсия)
#    и сопротивление (в Омах) для использования в качестве эталона при преобразовании
#    температуры. Секция нагревателя, использующая этот датчик, может также указать
#    параметр pullup_resistor (подробности см. в разделе "Экструдер"). На
#    необходимо указать как минимум два измерения.
```

### [heater_generic]

Общие нагреватели (можно определить любое количество секций с префиксом "heater_generic"). Эти нагреватели ведут себя так же, как и стандартные нагреватели (экструдеры, обогреваемые станины). Для задания целевой температуры используйте команду SET_HEATER_TEMPERATURE (подробности см. в [G-Codes](G-Codes.md#heaters)).

```
[heater_generic my_generic_heater]
#gcode_id:
#    Идентификатор, который будет использоваться при сообщении температуры в команде M105.
#    Этот параметр должен быть указан.
#heater_pin:
#max_power:
#sensor_type:
#sensor_pin:
#smooth_time:
#control:
#pid_Kp:
#pid_Ki:
#pid_Kd:
#pwm_cycle_time:
#min_temp:
#max_temp:
#    См. раздел "Экструдер" для определения вышеуказанных
#    параметров.
```

### [temperature_sensor]

Общие датчики температуры. Можно определить любое количество дополнительных датчиков температуры, которые будут сообщаться с помощью команды M105.

```
[температурный_сенсор мой_сенсор]
#сенсор_типа:
#sensor_pin:
#min_temp:
#max_temp:
#    См. раздел "Экструдер" для определения вышеуказанных
#    параметров.
#gcode_id:
#    Определение этого параметра см. в разделе "Нагреватель_генеральный".
#    параметра.
```

### [temperature_probe]

Сообщает о температуре катушки зонда. Включает дополнительную калибровку теплового дрейфа для зондов на основе вихревых токов. Секция `[temperature_probe]` может быть связана с секцией `[probe_eddy_current]`, используя один и тот же постфикс для обеих секций.

```
[temperature_probe my_probe]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Temperature sensor configuration.
#   See the "extruder" section for the definition of the above
#   parameters.
#smooth_time:
#   A time value (in seconds) over which temperature measurements will
#   be smoothed to reduce the impact of measurement noise. The default
#   is 2.0 seconds.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
#speed:
#   The travel speed [mm/s] for xy moves during calibration.  Default
#   is the speed defined by the probe.
#horizontal_move_z:
#   The z distance [mm] from the bed at which xy moves will occur
#   during calibration. Default is 2mm.
#resting_z:
#   The z distance [mm] from the bed at which the tool will rest
#   to heat the probe coil during calibration.  Default is .4mm
#calibration_position:
#   The X, Y, Z position where the tool should be moved when
#   probe drift calibration initializes.  This is the location
#   where the first manual probe will occur.  If omitted, the
#   default behavior is not to move the tool prior to the first
#   manual probe.
#calibration_bed_temp:
#   The maximum safe bed temperature (in C) used to heat the probe
#   during probe drift calibration.  When set, the calibration
#   procedure will turn on the bed after the first sample is
#   taken.  When the calibration procedure is complete the bed
#   temperature will be set to zero.  When omitted the default
#   behavior is not to set the bed temperature.
#calibration_extruder_temp:
#   The extruder temperature (in C) set probe during drift calibration.
#   When this option is supplied the procedure will wait for until the
#   specified temperature is reached before requesting the first manual
#   probe.  When the calibration procedure is complete the extruder
#   temperature will be set to 0.  When omitted the default behavior is
#   not to set the extruder temperature.
#extruder_heating_z: 50.
#   The Z location where extruder heating will occur if the
#   "calibration_extruder_temp" option is set.  Its recommended to heat
#   the extruder some distance from the bed to minimize its impact on
#   the probe coil temperature.  The default is 50.
#max_validation_temp: 60.
#   The maximum temperature used to validate the calibration.  It is
#   recommended to set this to a value between 100 and 120 for enclosed
#   printers.  The default is 60.
```

## Датчики температуры

Klipper содержит определения для многих типов температурных датчиков. Эти датчики можно использовать в любой секции конфигурации, где требуется датчик температуры (например, в секции `[extruder]` или `[heater_bed]`).

### Обычные термисторы

Обычные термисторы. Следующие параметры доступны в секциях нагревателей, использующих один из этих датчиков.

```
sensor_type:
#    Один из "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
#    "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
#    "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#    "SliceEngineering 450", или "TDK NTCG104LH104JT1".
sensor_pin:
#    Контакт аналогового входа, подключенный к термистору. Этот параметр должен
#    быть предоставлен.
#pullup_resistor: 4700
#    Сопротивление (в омах) подтяжки, подключенной к термистору.
#    По умолчанию 4700 Ом.
#inline_resistor: 0
#    Сопротивление (в омах) дополнительного (не изменяющего тепло) резистора.
#    который устанавливается в линию с термистором. Это редко задается.
#    По умолчанию 0 Ом.
```

### Усилители общей температуры

Общие усилители температуры. Следующие параметры доступны в секциях нагревателей, использующих один из этих датчиков.

```
тип_датчика:
#    Один из "PT100 INA826", "AD595", "AD597", "AD8494", "AD8495",
#    "AD8496" или "AD8497".
sensor_pin:
#    Контакт аналогового входа, подключенный к датчику. Этот параметр должен быть
#    предоставлен.
#adc_voltage: 5.0
#    Напряжение сравнения АЦП (в вольтах). По умолчанию 5 вольт.
#voltage_offset: 0
#    Смещение напряжения АЦП (в вольтах). По умолчанию 0.
```

### Датчик PT1000 с прямым подключением

Датчик PT1000 с прямым подключением. Следующие параметры доступны в секциях нагревателей, использующих один из этих датчиков.

```
тип_датчика: PT1000
sensor_pin:
#    Контакт аналогового входа, подключенный к датчику. Этот параметр должен быть
#    предоставлен.
#pullup_resistor: 4700
#    Сопротивление (в омах) подтягивающего устройства, подключенного к датчику. По
#    по умолчанию составляет 4700 Ом.
```

### Датчики температуры MAXxxxxx

Датчики температуры на основе последовательного периферийного интерфейса (SPI) MAXxxxxx. Следующие параметры доступны в секциях нагревателей, использующих один из этих типов датчиков.

```
тип_датчика:
# Один из "MAX6675", "MAX31855", "MAX31856" или "MAX31865".
sensor_pin:
# Линия выбора микросхемы для микросхемы датчика. Этот параметр должен быть
# предоставлен.
#spi_speed: 4000000
# Скорость SPI (в гц), используемая при обмене данными с микросхемой.
# По умолчанию 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    См. раздел "Общие настройки SPI" для описания
#    вышеуказанных параметров.
#tc_type: K
#tc_use_50Hz_filter: False
#tc_averaging_count: 1
# Вышеуказанные параметры управляют параметрами датчиков MAX31856
#    микросхемы. Значения по умолчанию для каждого параметра находятся рядом с его
#    в приведенном выше списке.
#rtd_nominal_r: 100
#rtd_reference_r: 430
#rtd_num_of_wires: 2
#rtd_use_50Hz_filter: False
#    Вышеуказанные параметры управляют параметрами датчиков микросхемы MAX31865
#    микросхемы. Значения по умолчанию для каждого параметра находятся рядом с его
#    в приведенном выше списке.
```

### Датчик температуры BMP180/BMP280/BME280/BMP388/BME680

Датчики окружающей среды BMP180/BMP280/BME280/BMP388/BME680 с двухпроводным интерфейсом (I2C). Обратите внимание, что эти датчики не предназначены для использования с экструдерами и нагревателями, а скорее для мониторинга температуры окружающей среды (C), давления (гПа), относительной влажности и, в случае BME680, уровня газа. Смотрите [sample-macros.cfg](../config/sample-macros.cfg) для gcode_macro, который может использоваться для сообщения о давлении и влажности в дополнение к температуре.

```
тип_датчика: BME280
#i2c_address:
#    По умолчанию 118 (0x76). Датчики BMP180, BMP388 и некоторые датчики BME280
#    имеют адрес 119 (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров.
```

### Датчик температуры AHT10/AHT20/AHT21

Датчики окружающей среды AHT10/AHT20/AHT21 с двухпроводным интерфейсом (I2C). Обратите внимание, что эти датчики не предназначены для использования с экструдерами и нагревателями, а скорее для мониторинга температуры окружающей среды (C) и относительной влажности. Смотрите [sample-macros.cfg](../config/sample-macros.cfg) для макроса gcode_macro, который можно использовать для сообщения о влажности в дополнение к температуре.

```
тип_датчика: AHT10
#    Также используйте AHT10 для датчиков AHT20 и AHT21.
#i2c_address:
#    По умолчанию 56 (0x38). Некоторые датчики AHT10 позволяют использовать.
#    57 (0x39) путем перемещения резистора.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров.
#aht10_report_time:
#    Интервал в секундах между считываниями. По умолчанию 30, минимум 5
```

### Датчик HTU21D

Датчик окружающей среды семейства HTU21D с двухпроводным интерфейсом (I2C). Обратите внимание, что этот датчик не предназначен для использования с экструдерами и нагревателями, а скорее для мониторинга температуры окружающей среды (C) и относительной влажности. Смотрите [sample-macros.cfg](../config/sample-macros.cfg) для макроса gcode_macro, который можно использовать для сообщения о влажности в дополнение к температуре.

```
тип_датчика:
#    Должно быть "HTU21D", "SI7013", "SI7020", "SI7021" или "SHT21".
#i2c_address:
#    По умолчанию 64 (0x40).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
# вышеуказанных параметров.
#htu21d_hold_master:
#    Может ли датчик удерживать I2C buf во время чтения. Если True, то никакие другие
#    обмен данными по шине не может осуществляться во время чтения.
#    По умолчанию False.
#htu21d_resolution:
#    Разрешение показаний температуры и влажности.
#    Допустимые значения:
#    'TEMP14_HUM12' -> 14 бит для температуры и 12 бит для влажности.
#     'TEMP13_HUM10' -> 13 бит для температуры и 10 бит для влажности
#     'TEMP12_HUM08' -> 12 бит для температуры и 08 бит для влажности
#     'TEMP11_HUM11' -> 11 бит для температуры и 11 бит для влажности
#    По умолчанию: "TEMP11_HUM11"
#htu21d_report_time:
#    Интервал в секундах между показаниями. По умолчанию 30
```

### Датчик SHT3X

Датчики окружающей среды семейства SHT3X с двухпроводным интерфейсом (I2C). Эти датчики имеют диапазон -55~125 C, поэтому могут использоваться, например, для мониторинга температуры в камере. Они также могут работать в качестве простых контроллеров вентиляторов/нагревателей.

```
тип_датчика: SHT3X
#i2c_address:
#    По умолчанию 68 (0x44).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров.
```

### Датчик температуры LM75

Датчики температуры LM75/LM75A с двухпроводным подключением (I2C). Эти датчики имеют диапазон -55~125 C, поэтому могут использоваться, например, для контроля температуры в камере. Они также могут работать в качестве простых контроллеров вентиляторов/нагревателей.

```
тип_датчика: LM75
#i2c_address:
#    По умолчанию 72 (0x48). Нормальный диапазон - 72-79 (0x48-0x4F), а 3
#    младших бита адреса конфигурируются с помощью выводов на чипе
#    (обычно с помощью перемычек или жесткого подключения).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров.
#lm75_report_time:
#    Интервал в секундах между считываниями. По умолчанию 0,8, минимальное значение
#    0.5.
```

### Встроенный микроконтроллерный датчик температуры

Микроконтроллеры atsam, atsamd и stm32 содержат внутренний датчик температуры. Для мониторинга этих температур можно использовать датчик "temperature_mcu".

```
тип_датчика: temperature_mcu
#sensor_mcu: mcu
#    Микроконтроллер, с которого будет считываться информация. По умолчанию используется "mcu".
#sensor_temperature1:
#sensor_adc1:
#    Укажите два вышеуказанных параметра (температуру в градусах Цельсия и
#    значение АЦП в виде плавающей величины между 0,0 и 1,0) для калибровки
#    температуры микроконтроллера. Это может улучшить заявленную
#    точность температуры на некоторых чипах. Типичный способ получения этой
#    калибровочной информации является полное отключение питания от
#    принтера на несколько часов (чтобы убедиться, что он находится при температуре окружающей среды).
#    температуре окружающей среды), затем включить его и использовать команду QUERY_ADC для
#    получения измерений АЦП. Используйте какой-либо другой датчик температуры на
#    принтера, чтобы найти соответствующую температуру окружающей среды. На сайте
#    по умолчанию используются данные заводской калибровки на
#    микроконтроллера (если применимо) или номинальные значения из
#    спецификации микроконтроллера.
#sensor_temperature2:
#sensor_adc2:
#    Если указаны sensor_temperature1/sensor_adc1, то можно также
#    указать калибровочные данные sensor_temperature2/sensor_adc2. В этом случае
#    может предоставить калиброванную информацию о "температурном наклоне". По
#    по умолчанию используются заводские калибровочные данные на
#    микроконтроллера (если применимо) или номинальные значения из
#    спецификации микроконтроллера.
```

### Датчик температуры хоста

Температура от компьютера (например, Raspberry Pi), на котором запущено программное обеспечение хоста.

```
тип_датчика: температура_хоста
#sensor_path:
#    Путь к системному файлу температуры. По умолчанию это.
#    "/sys/class/thermal/thermal_zone0/temp", который является температурным
#    системный файл на компьютере Raspberry Pi.
```

### Датчик температуры DS18B20

DS18B20 - это 1-проводной (w1) цифровой датчик температуры. Обратите внимание, что этот датчик не предназначен для использования с экструдерами и нагревателями, а скорее для контроля температуры окружающей среды (C). Эти датчики имеют диапазон до 125 C, поэтому их можно использовать, например, для контроля температуры в камере. Они также могут работать в качестве простых контроллеров вентиляторов/нагревателей. Датчики DS18B20 поддерживаются только на "главном микроконтроллере", например, Raspberry Pi. Необходимо установить модуль w1-gpio ядра Linux.

```
тип_датчика: DS18B20
serial_no:
#    Каждое 1-проводное устройство имеет уникальный серийный номер, используемый для идентификации устройства,
#    обычно в формате 28-031674b175ff. Этот параметр должен быть указан.
#    Присоединенные 1-проводные устройства можно перечислить с помощью следующей команды Linux:
#    ls /sys/bus/w1/devices/
#ds18_report_time:
#    Интервал в секундах между считываниями. По умолчанию 3,0, минимум 1,0.
#sensor_mcu:
#    Микроконтроллер, с которого будут считываться данные. Должен быть host_mcu
```

### Комбинированный датчик температуры

Комбинированный датчик температуры - это виртуальный датчик температуры, основанный на нескольких других датчиках. Этот датчик можно использовать с экструдерами, нагревателем_generic и нагревателями.

```
тип_датчика: температура_комбинированная
#sensor_list:
#    Должен быть предоставлен. Список датчиков для объединения в новый "виртуальный"
#    sensor.
#    Например, 'temperature_sensor sensor1,extruder,heater_bed'
#combination_method:
#    Должно быть указано. Метод объединения, используемый для датчика.
#    Доступны следующие варианты: 'max', 'min', 'mean'.
#maximum_deviation:
#    Должно быть указано. Максимально допустимое отклонение между датчиками.
#    для объединения (например, 5 градусов). Чтобы отключить его, используйте большое значение (например, 999,9).
```

## Вентиляторы

### [вентилятор]

Вентилятор охлаждения печати.

```
[fan]
pin:
#    Выходной контакт, управляющий вентилятором. Этот параметр должен быть предоставлен.
#max_power: 1.0
#    Максимальная мощность (выраженная в виде значения от 0,0 до 1,0), на которую может быть установлен
#    пин может быть установлен. Значение 1.0 позволяет установить пин полностью
#    включенным на длительное время, в то время как значение 0,5 позволяет
#    пин быть включенным не более чем на половину времени. Эта настройка может
#    может использоваться для ограничения общей выходной мощности (в течение длительного времени)
#    вентилятора. Если это значение меньше 1,0, то запросы скорости вентилятора
#    будут масштабироваться между нулем и max_power (например, если
#    max_power равно .9 и запрашивается скорость вентилятора 80 %, то вентилятор
#    мощность будет установлена на 72%). По умолчанию это значение равно 1,0.
#shutdown_speed: 0
#    Желаемая скорость вращения вентилятора (выражается в виде значения от 0,0 до 1,0), если
#    программное обеспечение микроконтроллера перейдет в состояние ошибки. По умолчанию
#    является 0.
#cycle_time: 0.010
#    Количество времени (в секундах) для каждого цикла питания ШИМ для
#    вентилятора. Рекомендуется, чтобы это время составляло 10 миллисекунд или больше, если
#    использовании программного ШИМ. По умолчанию 0,010 секунды.
#hardware_pwm: False
#    Включите эту опцию, чтобы использовать аппаратный ШИМ вместо программного ШИМ. Большинство вентиляторов
#    плохо работают с аппаратным ШИМ, поэтому не рекомендуется
#    включать эту опцию, если только нет электрических требований к переключению на
#    очень высоких скоростях. При использовании аппаратной ШИМ фактическое время цикла
#    ограничивается реализацией и может значительно
#    отличаться от запрошенного времени цикла. По умолчанию установлено значение False.
#kick_start_time: 0.100
#    Время (в секундах) для запуска вентилятора на полную скорость при первом
#    включении, либо увеличении ее более чем на 50 % (помогает заставить вентилятор
#    вращаться). По умолчанию 0,100 секунды.
#off_below: 0.0
#    Минимальная входная скорость, при которой вентилятор будет работать (выражается в виде
#    значение от 0.0 до 1.0). Если запрашивается скорость ниже, чем off_below
#    запрашивается, вентилятор будет выключен. Эта настройка может быть
#    использоваться для предотвращения остановки вентилятора и для обеспечения эффективного запуска
#    эффективным. По умолчанию 0.0.
#
#    Эту настройку следует перекалибровать при каждом изменении max_power.
#    Чтобы откалибровать эту настройку, начните с того, что off_below установлено на 0.0 и
#    вращается вентилятор. Постепенно снижайте скорость вентилятора, чтобы определить самую низкую
#    входной скорости, которая обеспечивает надежную работу вентилятора без застоев. Установите
#    off_below на рабочий цикл, соответствующий этому значению (например.
#    например, 12% -> 0,12) или немного выше.
#tachometer_pin:
#    Входной контакт тахометра для контроля скорости вращения вентилятора. Подтягивание обычно
#    требуется. Этот параметр необязателен.
#tachometer_ppr: 2
#    Если указан параметр tachometer_pin, это количество импульсов на один
#    оборот сигнала тахометра. Для вентилятора BLDC это
#    обычно половина числа полюсов. По умолчанию это 2.
#tachometer_poll_interval: 0.0015
#    Если указан tachometer_pin, это период опроса
#    пина тахометра, в секундах. По умолчанию 0.0015, что достаточно быстро
#    достаточно быстро для вентиляторов со скоростью менее 10000 об/мин при 2 PPR. Это значение должно быть меньше, чем
#    30/(tachometer_ppr*rpm), с некоторым запасом, где rpm - это
#    максимальная скорость (в оборотах в минуту) вентилятора.
#enable_pin:
#    Дополнительный контакт для включения питания вентилятора. Это может быть полезно для вентиляторов
#    с выделенными ШИМ-входами. Некоторые из этих вентиляторов остаются включенными даже при 0% ШИМ
#    на входе. В этом случае вывод PWM можно использовать нормально, и, например.
#    переключаемый на землю FET (стандартный вывод вентилятора) может быть использован для управления питанием
#    вентилятора.
```

### [heater_fan]

Вентиляторы охлаждения нагревателя (можно определить любое количество секций с префиксом "heater_fan"). Вентилятор нагревателя" - это вентилятор, который будет включен каждый раз, когда соответствующий ему нагреватель активен. По умолчанию вентилятор_нагревателя имеет скорость выключения, равную max_power.

```
[heater_fan heatbreak_cooling_fan]
#pin:
#макс_мощность:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#    Описание вышеуказанных параметров см. в разделе "Вентилятор".
#heater: extruder
#    Имя секции конфигурации, определяющей нагреватель, с которым связан этот вентилятор.
#    ассоциирован с ним. Если список имен нагревателей, разделенных запятой.
#    указан, то вентилятор будет включен, когда любой из указанных
#    нагревателей. По умолчанию используется "Экструдер".
#heater_temp: 50.0
#    Температура (в градусах Цельсия), ниже которой должен опуститься нагреватель, прежде чем
#    отключения вентилятора. По умолчанию 50 градусов Цельсия.
#fan_speed: 1.0
#    Скорость вентилятора (выраженная в виде значения от 0,0 до 1,0), которую вентилятор
#    будет установлена при включении связанного с ним нагревателя. По умолчанию
#    является 1.0
```

### [controller_fan]

Вентилятор охлаждения контроллера (можно определить любое количество секций с префиксом "controller_fan"). Вентилятор контроллера" - это вентилятор, который будет включен всякий раз, когда активен связанный с ним нагреватель или связанный с ним шаговый драйвер. Вентилятор будет останавливаться при достижении значения idle_timeout, чтобы исключить перегрев после отключения компонента, за которым ведется наблюдение.

```
[controller_fan my_controller_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#    Описание вышеуказанных параметров см. в разделе "Вентилятор".
#fan_speed: 1.0
#    Скорость вентилятора (выраженная в виде значения от 0.0 до 1.0), на которую вентилятор
#    будет установлена, когда активен нагреватель или шаговый драйвер.
#    По умолчанию 1.0
#idle_timeout:
#    Количество времени (в секундах) после того, как шаговый драйвер или нагреватель
#    был активен, и вентилятор должен продолжать работать. По умолчанию
#    является 30 секунд.
#idle_speed:
#    Скорость вентилятора (выраженная в виде значения от 0,0 до 1,0), которую вентилятор
#    будет установлена, если нагреватель или шаговый драйвер были активны и
#    до достижения значения idle_timeout. По умолчанию используется значение fan_speed.
#heater:
#stepper:
#    Имя секции конфигурации, определяющей нагреватель/шаговый вентилятор, с которым этот вентилятор
#    связан с этим вентилятором. Если список имен нагревателей/шаговиков, разделенных запятой.
#    указан здесь, то вентилятор будет включен, когда любой из указанных
#    нагревателей/шаговиков. Нагревателем по умолчанию является "Экструдер", а
#    шаговый по умолчанию - все.
```

### [temperature_fan]

Вентиляторы охлаждения с температурным триггером (можно определить любое количество секций с префиксом "temperature_fan"). Температурный вентилятор" - это вентилятор, который будет включаться всякий раз, когда температура соответствующего датчика будет выше заданной. По умолчанию у вентилятора temperature_fan скорость выключения равна max_power.

Дополнительную информацию см. в [справочнике команд](G-Codes.md#temperature_fan).

```
[temperature_fan my_temp_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#    Описание вышеуказанных параметров см. в разделе "Вентилятор".
#sensor_type:
#sensor_pin:
#control:
#max_delta:
#min_temp:
#max_temp:
#    Описание вышеуказанных параметров см. в разделе "Экструдер".
#pid_Kp:
#pid_Ki:
#pid_Kd:
#    Пропорциональная (pid_Kp), интегральная (pid_Ki) и производная
#    (pid_Kd) настройки для системы управления с обратной связью PID. Клиппер
#    оценивает настройки ПИД-регулятора по следующей общей формуле:
#    fan_pwm = max_power - (Kp*e + Ki*integral(e) - Kd*derivative(e)) / 255
#    Где "e" - это "целевая_температура - измеренная_температура" и
#    "fan_pwm" - запрашиваемая частота вращения вентилятора, где 0.0 - полное выключение, а
#    1.0 - полное включение. Параметры pid_Kp, pid_Ki и pid_Kd должны быть
#    должны быть заданы, если включен алгоритм ПИД-регулирования.
#pid_deriv_time: 2.0
#    Значение времени (в секундах), в течение которого измерения температуры будут
#    сглаживаться при использовании алгоритма ПИД-регулирования. Это может уменьшить
#    влияние шума при измерениях. По умолчанию установлено значение 2 секунды.
#target_temp: 40.0
#    Температура (в градусах Цельсия), которая будет целевой температурой.
#    По умолчанию - 40 градусов.
#max_speed: 1.0
#    Скорость вращения вентилятора (выраженная в виде значения от 0,0 до 1,0), на которую вентилятор
#    будет установлена, когда температура датчика превысит заданное значение.
#    По умолчанию 1.0.
#min_speed: 0.3
#    Минимальная скорость вентилятора (выраженная в виде значения от 0,0 до 1,0), на которую
#    будет установлена для вентиляторов с ПИД-регулятором температуры.
#    По умолчанию 0.3.
#gcode_id:
#    Если задано, температура будет сообщаться в запросах M105 с использованием
#    заданный идентификатор. По умолчанию температура не сообщается через M105.
```

### [fan_generic]

Вентилятор с ручным управлением (можно определить любое количество секций с префиксом "fan_generic"). Скорость вентилятора с ручным управлением задается командой SET_FAN_SPEED [gcode](G-Codes.md#fan_generic).

```
[fan_generic extruder_partfan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#    Описание вышеуказанных параметров см. в разделе "Вентилятор".
```

## LEDs

### [led]

Поддержка светодиодов (и светодиодных лент), управляемых через ШИМ-штырьки микроконтроллера (можно задать любое количество секций с префиксом "led"). Дополнительную информацию см. в [справочнике команд](G-Codes.md#led).

```
[led my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
#    Контакт, управляющий заданным цветом светодиода. Хотя бы один из перечисленных выше
#    параметров должно быть указано.
#cycle_time: 0.010
#    Количество времени (в секундах) на один цикл ШИМ. Рекомендуется.
#    это время должно быть 10 миллисекунд или больше, если используется программный ШИМ.
#    По умолчанию 0,010 секунды.
#hardware_pwm: False
#    Включите эту опцию, чтобы использовать аппаратный ШИМ вместо программного. Когда
#    использовании аппаратной ШИМ фактическое время цикла ограничивается
#    реализацией и может значительно отличаться от
#    запрошенного времени цикла. По умолчанию установлено значение False.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#    Устанавливает начальный цвет светодиода. Каждое значение должно находиться в диапазоне от 0,0 до
#    1.0. По умолчанию для каждого цвета установлено значение 0.
```

### [неопиксель]

Поддержка неопиксельных (они же WS2812) светодиодов (можно задать любое количество секций с префиксом "neopixel"). Дополнительную информацию см. в [справочнике команд](G-Codes.md#led).

Обратите внимание, что реализация [linux mcu](RPi_microcontroller.md) в настоящее время не поддерживает напрямую подключенные неопиксели. Текущая конструкция, использующая интерфейс ядра Linux, не позволяет реализовать этот сценарий, поскольку интерфейс GPIO ядра недостаточно быстр для обеспечения требуемой частоты импульсов.

```
[neopixel my_neopixel].
pin:
#    Контакт, подключенный к неопикселю. Этот параметр должен быть
#    предоставлен.
#chain_count:
#    Количество чипов Neopixel, которые "соединены в цепочку" с
#    указанному пину. По умолчанию равно 1 (что означает, что только один
#    Neopixel подключен к пину).
#color_order: GRB
#    Устанавливает порядок пикселей, требуемый аппаратным обеспечением светодиода (используется строка
#    содержащей буквы R, G, B, W, причём W необязательно). В качестве альтернативы,
#    это может быть разделенный запятыми список порядков пикселей - по одному для каждого
#    светодиодов в цепочке. По умолчанию используется GRB.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#    Информацию об этих параметрах см. в разделе "led".
```

### [dotstar]

Поддержка светодиодов Dotstar (aka APA102) (можно задать любое количество секций с префиксом "dotstar"). Дополнительную информацию см. в [справочнике команд](G-Codes.md#led).

```
[dotstar my_dotstar]
data_pin:
#    Контакт, подключенный к линии данных дотстара. Этот параметр
#    должен быть указан.
clock_pin:
#    Контакт, подключенный к тактовой линии дотстара. Этот параметр
#    должен быть указан.
#chain_count:
#    Информацию об этом параметре см. в разделе "Неопиксели".
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#    Информацию об этих параметрах см. в разделе "led".
```

### [pca9533]

Поддержка светодиодов PCA9533. PCA9533 используется на плате mightyboard.

```
[pca9533 my_pca9533]
#i2c_address: 98
#    Адрес i2c, который чип использует на шине i2c. Используйте 98 для
#    PCA9533/1, 99 - для PCA9533/2. По умолчанию используется 98.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#    Информацию об этих параметрах см. в разделе "led".
```

### [pca9632]

Поддержка светодиодов PCA9632. PCA9632 используется в FlashForge Dreamer.

```
[pca9632 my_pca9632]
#i2c_address: 98
#    Адрес i2c, который чип использует на шине i2c. Это может быть
#    96, 97, 98 или 99.  По умолчанию это 98.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров.
#scl_pin:
#sda_pin:
#    Альтернативный вариант, если pca9632 не подключен к аппаратной I2C
#    шине, то можно указать "часы" (scl_pin) и "данные"
#    (sda_pin). По умолчанию используется аппаратный I2C.
#color_order: RGBW
#    Устанавливает порядок пикселей светодиода (используя строку, содержащую
#    буквы R, G, B, W). По умолчанию используется RGBW.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#    Информацию об этих параметрах см. в разделе "led".
```

## Дополнительные сервоприводы, кнопки и другие контакты

### [сервопривод]

Сервоприводы (можно задать любое количество секций с префиксом "servo"). Сервоприводами можно управлять с помощью команды SET_SERVO [g-код](G-Codes.md#servo). Например: SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
пин:
#    ШИМ-выход, управляющий сервоприводом. Этот параметр должен быть
#    предоставлен.
#maximum_servo_angle: 180
#    Максимальный угол (в градусах), на который может быть установлен данный сервопривод. По
#    по умолчанию составляет 180 градусов.
#minimum_pulse_width: 0.001
#    Минимальная длительность импульса (в секундах). Это должно соответствовать
#    с углом в 0 градусов. По умолчанию 0,001 секунды.
#maximum_pulse_width: 0.002
#    Время максимальной ширины импульса (в секундах). Это должно соответствовать
#    с углом maximum_servo_angle. По умолчанию 0,002
#    секунд.
#initial_angle:
#    Начальный угол (в градусах) для установки сервопривода. По умолчанию
#    не посылать никаких сигналов при запуске.
#initial_pulse_width:
#    Начальная длительность импульса (в секундах) для настройки сервопривода. (Это
#    действует только в том случае, если не задан initial_angle). По умолчанию не
#    посылать никаких сигналов при запуске.
```

### [gcode_button]

Выполняйте gcode при нажатии или отпускании кнопки (или при изменении состояния пина). Вы можете проверить состояние кнопки, используя `QUERY_BUTTON button=my_gcode_button`.

```
[gcode_button my_gcode_button]
pin:
#   The pin on which the button is connected. This parameter must be
#   provided.
#analog_range:
#   Two comma separated resistances (in Ohms) specifying the minimum
#   and maximum resistance range for the button. If analog_range is
#   provided then the pin must be an analog capable pin. The default
#   is to use digital gpio for the button.
#analog_pullup_resistor:
#   The pullup resistance (in Ohms) when analog_range is specified.
#   The default is 4700 ohms.
#press_gcode:
#   A list of G-Code commands to execute when the button is pressed.
#   G-Code templates are supported. This parameter must be provided.
#release_gcode:
#   A list of G-Code commands to execute when the button is released.
#   G-Code templates are supported. The default is to not run any
#   commands on a button release.
#debounce_delay:
#   A period of time in seconds to debounce events prior to running the
#   button gcode. If the button is pressed and released during this
#   delay, the entire button press is ignored. Default is 0.
```

### [output_pin]

Конфигурируемые во время выполнения выходные пины (можно определить любое количество секций с префиксом "output_pin"). Сконфигурированные здесь пины будут настроены как выходные, и их можно будет изменить во время выполнения с помощью расширенных [команд g-кода] типа "SET_PIN PIN=my_pin VALUE=.1" (G-Codes.md#output_pin).

```
[output_pin my_pin]
pin:
#    Вывод для конфигурирования в качестве выхода. Этот параметр должен быть
#    предоставлен.
#pwm: False
#    Устанавливает, должен ли выходной пин иметь возможность широтно-импульсной модуляции.
#    Если этот параметр истинный, поля значений должны быть от 0 до 1; если он
#    false, то поля значений должны быть либо 0, либо 1.    По умолчанию
# False.
#value:
#    Значение, на которое изначально устанавливается вывод при конфигурировании MCU.
#    По умолчанию 0 (для низкого напряжения).
#shutdown_value:
#    Значение, на которое устанавливается вывод при событии выключения MCU. По умолчанию
#    является 0 (для низкого напряжения).
#cycle_time: 0.100
#    Количество времени (в секундах) на один цикл ШИМ. Рекомендуется.
#    при использовании программного ШИМ это время должно быть 10 миллисекунд или больше.
#    По умолчанию 0,100 секунды для pwm пинов.
#hardware_pwm: False
#    Включите эту опцию, чтобы использовать аппаратный ШИМ вместо программного. Когда
#    использовании аппаратной ШИМ фактическое время цикла ограничивается
#    реализацией и может значительно отличаться от
#    запрошенного времени цикла. По умолчанию установлено значение False.
#scale:
#    Этот параметр можно использовать для изменения того, как параметры 'value' и
#    'shutdown_value' интерпретируются для pwm пинов. Если
#    указан, то параметр 'value' должен быть между 0.0 и
#    'scale'. Это может быть полезно при настройке вывода ШИМ, который
#    управляет опорным напряжением шагового двигателя. Параметр 'scale' может быть установлен в значение
#    эквивалентную силу тока шагового двигателя, если бы ШИМ был полностью включен, и
#    затем параметр 'value' можно задать, используя желаемую
#    ампераж для шагового двигателя. По умолчанию параметр 'value' не масштабируется.
#    параметр.
#maximum_mcu_duration:
#static_value:
#    Эти параметры устарели и больше не должны указываться.
```

### [pwm_tool]

Цифровые выходные контакты с широтно-импульсной модуляцией, способные к высокоскоростному обновлению (можно определить любое количество секций с префиксом "output_pin"). Сконфигурированные здесь пины будут настроены как выходные, и их можно будет изменить во время выполнения программы с помощью расширенных типа "SET_PIN PIN=my_pin VALUE=.1"[команд g-кода](G-Codes.md#output_pin).

```
[pwm_tool my_tool]
pin:
#    Контакт для конфигурирования в качестве выхода. Этот параметр должен быть указан.
#maximum_mcu_duration:
#    Максимальное время, в течение которого MCU может управлять не выключенным значением.
#    без подтверждения от хоста.
#    Если хост не успевает за обновлением, MCU выключится
#    и установит все пины в соответствующие значения отключения.
#    По умолчанию: 0 (отключено)
#    Обычные значения составляют около 5 секунд.
#value:
#shutdown_value:
#cycle_time: 0.100
#hardware_pwm: False
#scale:
#    Определение этих параметров см. в разделе "output_pin".
```

### Цикл PWM

Конфигурируемые во время выполнения выходные пины с динамической синхронизацией циклов pwm (можно определить любое количество секций с префиксом "pwm_cycle_time"). Сконфигурированные здесь пины будут настроены как выходные, и их можно будет изменять во время выполнения с помощью расширенных [команд g-кода] типа "SET_PIN PIN=my_pin VALUE=.1 CYCLE_TIME=0.100" (G-Codes.md#pwm_cycle_time).

```
[pwm_cycle_time my_pin]
пин:
#значение:
#выключение_значения:
#cycle_time: 0.100
#scale:
#    Информацию об этих параметрах см. в разделе "output_pin".
```

### [static_digital_output]

Статически сконфигурированные цифровые выходные контакты (можно определить любое количество секций с префиксом "static_digital_output"). Настроенные здесь выводы будут установлены как выводы GPIO во время конфигурирования MCU. Они не могут быть изменены во время выполнения программы.

```
[static_digital_output my_output_pins]
pins:
#    Список выводов, которые будут установлены в качестве выходных выводов GPIO, разделенный запятыми. Пины
#    пин будет установлен на высокий уровень, если перед именем пина не стоит
#    с "!". Этот параметр должен быть указан.
```

### [multi_pin]

Многоконтактные выходы (можно определить любое количество секций с префиксом "multi_pin"). Выход multi_pin создает внутренний псевдоним пина, который может изменять несколько выходных пинов каждый раз, когда устанавливается псевдоним пина. Например, можно определить объект "[multi_pin my_fan]", содержащий два вывода, а затем задать "pin=multi_pin:my_fan" в секции "[fan]" - при каждом изменении вентилятора оба вывода будут обновляться. Эти псевдонимы нельзя использовать с контактами шагового двигателя.

```
[multi_pin my_multi_pin].
pins:
#    Список пинов, связанных с этим псевдонимом, разделенный запятыми. Этот
#    параметр должен быть указан.
```

## Конфигурация шагового драйвера TMC

Конфигурация драйверов шаговых двигателей Trinamic в режиме UART/SPI. Дополнительная информация содержится в руководстве [TMC Drivers guide](TMC_Drivers.md) и в справочнике [command reference](G-Codes.md#tmcxxxx).

### [tmc2130]

Конфигурирование драйвера шагового двигателя TMC2130 через шину SPI. Чтобы использовать эту функцию, определите секцию конфигурации с префиксом "tmc2130", за которым следует имя соответствующей секции конфигурации шагового двигателя (например, "[tmc2130 stepper_x]").

```
[tmc2130 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2130 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 0
#driver_TBL: 1
#driver_TOFF: 4
#driver_HEND: 7
#driver_HSTRT: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 4
#driver_PWM_AMPL: 128
#driver_FREEWHEEL: 0
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#   Set the given register during the configuration of the TMC2130
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2130 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2130_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2208]

Настройка драйвера шагового двигателя TMC2208 (или TMC2224) через однопроводной UART. Чтобы использовать эту функцию, определите секцию конфигурации с префиксом "tmc2208", за которым следует имя соответствующей секции конфигурации шагового двигателя (например, "[tmc2208 stepper_x]").

```
[tmc2208 stepper_x]
uart_pin:
#   The pin connected to the TMC2208 PDN_UART line. This parameter
#   must be provided.
#tx_pin:
#   If using separate receive and transmit lines to communicate with
#   the driver then set uart_pin to the receive pin and tx_pin to the
#   transmit pin. The default is to use uart_pin for both reading and
#   writing.
#select_pins:
#   A comma separated list of pins to set prior to accessing the
#   tmc2208 UART. This may be useful for configuring an analog mux for
#   UART communication. The default is to not configure any pins.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#driver_FREEWHEEL: 0
#   Set the given register during the configuration of the TMC2208
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
```

### [tmc2209]

Настройка драйвера шагового двигателя TMC2209 через однопроводной UART. Чтобы использовать эту функцию, определите секцию конфигурации с префиксом "tmc2209", за которым следует имя соответствующей секции конфигурации шагового двигателя (например, "[tmc2209 stepper_x]").

```
[tmc2209 stepper_x]
uart_pin:
#tx_pin:
#select_pins:
#interpolate: True
run_current:
#hold_current:
#sense_resistor: 0.110
#stealthchop_threshold: 0
#   See the "tmc2208" section for the definition of these parameters.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#uart_address:
#   The address of the TMC2209 chip for UART messages (an integer
#   between 0 and 3). This is typically used when multiple TMC2209
#   chips are connected to the same UART pin. The default is zero.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#driver_FREEWHEEL: 0
#driver_SGTHRS: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#   Set the given register during the configuration of the TMC2209
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag_pin:
#   The micro-controller pin attached to the DIAG line of the TMC2209
#   chip. The pin is normally prefaced with "^" to enable a pullup.
#   Setting this creates a "tmc2209_stepper_x:virtual_endstop" virtual
#   pin which may be used as the stepper's endstop_pin. Doing this
#   enables "sensorless homing". (Be sure to also set driver_SGTHRS to
#   an appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2660]

Конфигурирование драйвера шагового двигателя TMC2660 через шину SPI. Чтобы использовать эту функцию, определите секцию конфигурации с префиксом tmc2660, за которым следует имя соответствующей секции конфигурации шагового двигателя (например, "[tmc2660 stepper_x]").

```
[tmc2660 stepper_x]
cs_pin:
#    Вывод, соответствующий линии выбора микросхемы TMC2660. Этот вывод
#    будет установлен в низкий уровень в начале передачи SPI-сообщений и в высокий уровень
#    после завершения передачи сообщения. Этот параметр должен быть
#    предоставлен.
#spi_speed: 4000000
#    Частота шины SPI, используемая для связи с шаговым механизмом TMC2660
#    драйвером. По умолчанию - 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    См. раздел "Общие настройки SPI" для описания
#    вышеуказанных параметров.
#interpolate: True
#    Если true, включите пошаговую интерполяцию (драйвер будет внутренне
#    шагать с частотой 256 микрошагов). Это работает только в том случае, если параметр microsteps
#    установлено значение 16. Интерполяция вносит небольшое системное
#    позиционное отклонение - подробности см. в TMC_Drivers.md. По умолчанию
# является True.
run_current:
#    Количество тока (в амперах RMS), используемого драйвером во время
#    движения шаговика. Этот параметр должен быть предоставлен.
#sense_resistor:
#    Сопротивление (в омах) резистора чувства двигателя. Этот
#    параметр должен быть указан.
#idle_current_percent: 100
#    Процент от тока работы, на который будет опускаться драйвер шагового двигателя.
#    снижаться, когда истечет таймаут холостого хода (необходимо настроить
#    таймаут с помощью секции конфигурации [idle_timeout]). Ток будет
#    будет снова повышен, как только шаговый механизм снова начнет двигаться. Убедитесь, что
#    установить достаточно высокое значение, чтобы шаговики не потеряли
#    свое положение. Существует также небольшая задержка, пока ток
#    снова увеличится, так что учитывайте это при командовании быстрыми движениями
#    во время холостого хода шагового механизма. По умолчанию установлено значение 100 (без уменьшения).
#driver_TBL: 2
#driver_RNDTF: 0
#driver_HDEC: 0
#driver_CHM: 0
#driver_HEND: 3
#driver_HSTRT: 3
#driver_TOFF: 4
#driver_SEIMIN: 0
#driver_SEDN: 0
#driver_SEMAX: 0
#driver_SEUP: 0
#driver_SEMIN: 0
#driver_SFILT: 0
#driver_SGT: 0
#driver_SLPH: 0
#driver_SLPL: 0
#driver_DISS2G: 0
#driver_TS2G: 3
#    Установите данный параметр во время конфигурирования микросхемы TMC2660
#    чипа. Это может быть использовано для установки пользовательских параметров драйвера. На
#    значения по умолчанию для каждого параметра находятся рядом с его именем в
#    списке выше. О том, что делает каждый параметр, смотрите в техническом описании TMC2660.
#    и ограничения на комбинации параметров. Будьте
#    особенно внимательны к регистру CHOPCONF, где установка CHM в
#    либо в ноль, либо в единицу приведет к изменению схемы (первый бит
#    HDEC) интерпретируется как MSB HSTRT в этом случае).
```

### [tmc2240]

Конфигурирование драйвера шагового двигателя TMC2240 через шину SPI или UART. Чтобы использовать эту функцию, определите секцию конфигурации с префиксом "tmc2240", за которым следует имя соответствующей секции конфигурации шагового двигателя (например, "[tmc2240 stepper_x]").

```
[tmc2240 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2240 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#uart_pin:
#   The pin connected to the TMC2240 DIAG1/SW line. If this parameter
#   is provided UART communication is used rather then SPI.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#rref: 12000
#   The resistance (in ohms) of the resistor between IREF and GND. The
#   default is 12000.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#driver_OFFSET_SIN90: 0
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#   Additionally, this driver also has the OFFSET_SIN90 field which can be used
#   to tune a motor with unbalanced coils. See the `Sine Wave Lookup Table`
#   section in the datasheet for information about this field and how to tune
#   it.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_IRUNDELAY: 4
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 29
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_SG4_ANGLE_OFFSET: 1
#driver_SLOPE_CONTROL: 0
#   Set the given register during the configuration of the TMC2240
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2240 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2240_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc5160]

Конфигурирование драйвера шагового двигателя TMC5160 через шину SPI. Чтобы использовать эту функцию, определите секцию конфигурации с префиксом "tmc5160", за которым следует имя соответствующей секции конфигурации шагового двигателя (например, "[tmc5160 stepper_x]").

```
[tmc5160 stepper_x]
cs_pin:
#   The pin corresponding to the TMC5160 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.075
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.075 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. Note that the "sensorless homing"
#   code may temporarily override this setting during homing
#   operations. The default is 0, which disables "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 30
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_DRVSTRENGTH: 0
#driver_BBMCLKS: 4
#driver_BBMTIME: 0
#driver_FILT_ISENSE: 0
#   Set the given register during the configuration of the TMC5160
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC5160 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc5160_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

## Конфигурация тока шагового двигателя во время работы

### [ad5206]

Статически сконфигурированные дигипоты AD5206, подключенные через шину SPI (можно задать любое количество секций с префиксом "ad5206").

```
[ad5206 my_digipot]
enable_pin:
#    Вывод, соответствующий линии выбора микросхемы AD5206. Этот вывод
#    будет установлен в низкий уровень при запуске SPI-сообщений и поднят в высокий уровень
#    после завершения сообщения. Этот параметр должен быть указан.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    См. раздел "Общие настройки SPI" для описания
#    вышеуказанных параметров.
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
#    Значение, на которое статически устанавливается данный канал AD5206. Это
#    обычно задается числом от 0.0 до 1.0, причем 1.0 - это самое
#    наибольшее сопротивление, а 0.0 - наименьшее. Однако,
#    диапазон может быть изменен с помощью параметра 'scale' (см. ниже).
#    Если канал не указан, то он остается неконфигурированным.
#scale:
#    Этот параметр можно использовать для изменения того, как параметры 'channel_x'
#    интерпретируются. Если он указан, то параметры 'channel_x'
#    должны находиться в диапазоне от 0,0 до 'scale'. Это может быть полезно, когда
#    AD5206 используется для установки опорного напряжения шагового управления. Значение 'scale' может
#    быть установлен на эквивалентную силу тока шагового двигателя, если бы AD5206 был на
#    максимальном сопротивлении, а затем параметры 'channel_x' могут быть
#    задаются с помощью желаемого значения силы тока для шаговика. На сайте
#    по умолчанию параметры 'channel_x' не масштабируются.
```

### [mcp4451]

Статически сконфигурированный дигипот MCP4451, подключенный по шине I2C (можно задать любое количество секций с префиксом "mcp4451").

```
[mcp4451 my_digipot]
i2c_address:
#    Адрес i2c, который микросхема использует на шине i2c. Этот
#    параметр должен быть предоставлен.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров.
#wiper_0:
#wiper_1:
#wiper_2:
#wiper_3:
#    Значение, на которое статически устанавливается данный "дворник" MCP4451. Это
#    обычно устанавливается в число от 0.0 до 1.0, причем 1.0 - это
#    наибольшее сопротивление, а 0.0 - наименьшее. Однако,
#    диапазон может быть изменен с помощью параметра 'scale' (см. ниже).
#    Если стеклоочиститель не указан, то он остается ненастроенным.
#scale:
#    Этот параметр можно использовать для изменения того, как параметры 'wiper_x'
#    интерпретируются. Если он задан, то параметры 'wiper_x' должны
#    находиться в диапазоне от 0.0 до 'scale'. Это может быть полезно, когда MCP4451
#    используется для установки опорных значений шагового напряжения. Параметр 'scale' может быть установлен в значение
#    эквивалентную силу тока шагового двигателя, если бы MCP4451 имел максимальное
#    сопротивление, а затем параметры 'wiper_x' могут быть заданы
#    используя желаемое значение силы тока для шагового двигателя. По умолчанию
#    не масштабировать параметры 'wiper_x'.
```

### [mcp4728]

Статически сконфигурированный цифро-аналоговый преобразователь MCP4728, подключенный по шине I2C (можно задать любое количество секций с префиксом "mcp4728").

```
[mcp4728 my_dac]
#i2c_address: 96
#    Адрес i2c, который чип использует на шине i2c. По умолчанию
#    96.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров.
#channel_a:
#channel_b:
#channel_c:
#channel_d:
#    Значение, на которое статически устанавливается данный канал MCP4728. Это
#    обычно устанавливается в число от 0.0 до 1.0, причем 1.0 - это
#    самое высокое напряжение (2,048 В) и 0,0 - самое низкое напряжение.
#    Однако диапазон может быть изменен с помощью параметра 'scale' (см.
#    ниже). Если канал не указан, то он остается
#    ненастроенным.
#scale:
#    Этот параметр можно использовать для изменения того, как параметры 'channel_x'
#    интерпретируются. Если он указан, то параметры 'channel_x'
#    должны находиться в диапазоне от 0,0 до 'scale'. Это может быть полезно, когда
#    MCP4728 используется для установки опорного напряжения шагового управления. Значение 'scale' может
#    быть установлен на эквивалентный ампераж шагового двигателя, если бы MCP4728 был на
#    максимальном напряжении (2,048 В), а затем параметры 'channel_x'
#    можно задать, используя желаемое значение силы тока для
#    шаговика. По умолчанию параметры 'channel_x' не масштабируются.
```

### [mcp4018]

Статически сконфигурированный дигипот MCP4018, подключенный через два gpio "bit banging" пина (можно задать любое количество секций с префиксом "mcp4018").

```
[mcp4018 my_digipot]
scl_pin:
#    Вывод "тактового" сигнала SCL. Этот параметр должен быть указан.
sda_pin:
#    Вывод SDA "данные". Этот параметр должен быть указан.
wiper:
#    Значение, на которое статически устанавливается данный "дворник" MCP4018. Это
#    обычно устанавливается в число от 0.0 до 1.0, причем 1.0 - это самое
#    наибольшее сопротивление, а 0.0 - наименьшее. Однако,
#    диапазон может быть изменен с помощью параметра 'scale' (см. ниже).
#    Этот параметр должен быть указан.
#scale:
#    Этот параметр можно использовать для изменения того, как будет интерпретироваться параметр 'wiper'
#    интерпретации. Если он указан, то параметр 'wiper' должен находиться
#    между 0,0 и 'scale'. Это может быть полезно, когда MCP4018
#    используется для установки опорных значений шагового напряжения. Параметр 'scale' может быть установлен в значение
#    эквивалентную силу тока шагового двигателя, если MCP4018 имеет максимальное
#    сопротивление, а затем параметр 'wiper' может быть задан с помощью
#    желаемое значение силы тока для шаговика. По умолчанию
#    масштабирование параметра 'wiper'.
```

## Поддержка дисплея

### [display]

Поддержка дисплея, подключенного к микроконтроллеру.

```
[display]
lcd_type:
#   The type of LCD chip in use. This may be "hd44780", "hd44780_spi",
#   "aip31068_spi", "st7920", "emulated_st7920", "uc1701", "ssd1306", or
#   "sh1106".
#   See the display sections below for information on each type and
#   additional parameters they provide. This parameter must be
#   provided.
#display_group:
#   The name of the display_data group to show on the display. This
#   controls the content of the screen (see the "display_data" section
#   for more information). The default is _default_20x4 for hd44780 or
#   aip31068_spi displays and _default_16x4 for other displays.
#menu_timeout:
#   Timeout for menu. Being inactive this amount of seconds will
#   trigger menu exit or return to root menu when having autorun
#   enabled. The default is 0 seconds (disabled)
#menu_root:
#   Name of the main menu section to show when clicking the encoder
#   on the home screen. The defaults is __main, and this shows the
#   the default menus as defined in klippy/extras/display/menu.cfg
#menu_reverse_navigation:
#   When enabled it will reverse up and down directions for list
#   navigation. The default is False. This parameter is optional.
#encoder_pins:
#   The pins connected to encoder. 2 pins must be provided when using
#   encoder. This parameter must be provided when using menu.
#encoder_steps_per_detent:
#   How many steps the encoder emits per detent ("click"). If the
#   encoder takes two detents to move between entries or moves two
#   entries from one detent, try changing this. Allowed values are 2
#   (half-stepping) or 4 (full-stepping). The default is 4.
#click_pin:
#   The pin connected to 'enter' button or encoder 'click'. This
#   parameter must be provided when using menu. The presence of an
#   'analog_range_click_pin' config parameter turns this parameter
#   from digital to analog.
#back_pin:
#   The pin connected to 'back' button. This parameter is optional,
#   menu can be used without it. The presence of an
#   'analog_range_back_pin' config parameter turns this parameter from
#   digital to analog.
#up_pin:
#   The pin connected to 'up' button. This parameter must be provided
#   when using menu without encoder. The presence of an
#   'analog_range_up_pin' config parameter turns this parameter from
#   digital to analog.
#down_pin:
#   The pin connected to 'down' button. This parameter must be
#   provided when using menu without encoder. The presence of an
#   'analog_range_down_pin' config parameter turns this parameter from
#   digital to analog.
#kill_pin:
#   The pin connected to 'kill' button. This button will call
#   emergency stop. The presence of an 'analog_range_kill_pin' config
#   parameter turns this parameter from digital to analog.
#analog_pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the analog
#   button. The default is 4700 ohms.
#analog_range_click_pin:
#   The resistance range for a 'enter' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_back_pin:
#   The resistance range for a 'back' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_up_pin:
#   The resistance range for a 'up' button. Range minimum and maximum
#   comma-separated values must be provided when using analog button.
#analog_range_down_pin:
#   The resistance range for a 'down' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_kill_pin:
#   The resistance range for a 'kill' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
```

#### дисплей hd44780

Информация о настройке дисплеев hd44780 (используется в дисплеях типа "RepRapDiscount 2004 Smart Controller").

```
[дисплей]
lcd_type: hd44780
#    Установите значение "hd44780" для дисплеев hd44780.
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#    Пины, подключенные к ЖК-дисплею типа hd44780. Эти параметры должны
#    быть предоставлены.
#hd44780_protocol_init: True
#    Выполняет инициализацию 8-битного/4-битного протокола на дисплее hd44780.
#    Это необходимо на реальных устройствах hd44780. Однако может потребоваться
#    отключить это на некоторых "клонированных" устройствах. По умолчанию установлено значение True.
#line_length:
#    Устанавливает количество символов в строке для lcd типа hd44780.
#    Возможные значения: 20 (по умолчанию) и 16. Количество строк
#    фиксировано на 4.
...
```

#### hd44780_spi display

Информация о настройке дисплея hd44780_spi - дисплея 20x04, управляемого через аппаратный "сдвиговый регистр" (который используется в принтерах на базе mightyboard).

```
[display]
lcd_type: hd44780_spi
#    Установите значение "hd44780_spi" для дисплеев hd44780_spi.
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#    Пины, подключенные к сдвиговому регистру, управляющему дисплеем.
#    Вывод spi_software_miso_pin должен быть установлен на неиспользуемый вывод
#    основной платы принтера, поскольку сдвиговый регистр не имеет вывода MISO,
#    но программная реализация spi требует, чтобы этот вывод был
#    сконфигурирован.
#hd44780_protocol_init: True
#    Выполняет инициализацию 8-битного/4-битного протокола на дисплее hd44780.
#    Это необходимо на реальных устройствах hd44780. Однако может потребоваться
#    отключить это на некоторых "клонированных" устройствах. По умолчанию установлено значение True.
#line_length:
#    Устанавливает количество символов в строке для lcd типа hd44780.
#    Возможные значения: 20 (по умолчанию) и 16. Количество строк
#    фиксировано на 4.
...
```

#### aip31068_spi display

Information on configuring an aip31068_spi display - a very similar to hd44780_spi a 20x04 (20 symbols by 4 lines) display with slightly different internal protocol.

```
[display]
lcd_type: aip31068_spi
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   The pins connected to the shift register controlling the display.
#   The spi_software_miso_pin needs to be set to an unused pin of the
#   printer mainboard as the shift register does not have a MISO pin,
#   but the software spi implementation requires this pin to be
#   configured.
#line_length:
#   Set the number of characters per line for an hd44780 type lcd.
#   Possible values are 20 (default) and 16. The number of lines is
#   fixed to 4.
...
```

#### дисплей st7920

Информация о настройке дисплеев st7920 (используется в дисплеях типа "RepRapDiscount 12864 Full Graphic Smart Controller").

```
[дисплей]
lcd_type: st7920
#    Установите значение "st7920" для дисплеев st7920.
cs_pin:
sclk_pin:
sid_pin:
#    Выводы, подключаемые к ЖК-дисплею типа st7920. Эти параметры должны быть
#    предоставлены.
...
```

#### emulated_st7920 display

Информация о настройке эмулированного дисплея st7920 - встречается в некоторых "2,4-дюймовых устройствах с сенсорным экраном" и им подобных.

```
[display]
lcd_type: emulated_st7920
#    Установите значение "emulated_st7920" для дисплеев emulated_st7920.
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#    Пины, подключенные к ЖК-дисплею типа emulated_st7920. Вывод en_pin
#    соответствует cs_pin ЖК-дисплея типа st7920,
#    spi_software_sclk_pin соответствует sclk_pin и
#    spi_software_mosi_pin соответствует sid_pin. На сайте
#    spi_software_miso_pin должен быть установлен на неиспользуемый контакт
#    основной платы принтера, поскольку у st7920 нет вывода MISO, но программная
#    реализация spi требует, чтобы этот вывод был настроен.
...
```

#### uc1701 дисплей

Информация о настройке дисплеев uc1701 (который используется в дисплеях типа "MKS Mini 12864").

```
[дисплей]
lcd_type: uc1701
#    Установите значение "uc1701" для дисплеев uc1701.
cs_pin:
a0_pin:
#    Выводы, подключенные к дисплею типа uc1701. Эти параметры должны быть
#    предоставлены.
#rst_pin:
#    Контакт, подключенный к контакту "rst" на ЖК-дисплее. Если он не указан.
#    указан, то аппаратное обеспечение должно иметь подтяжку на
#    соответствующей линии ЖК-дисплея.
#contrast:
#    Устанавливаемый контраст. Значение может варьироваться от 0 до 63, а по
#    по умолчанию - 40.
...
```

#### ssd1306 и sh1106 дисплеи

Информация о настройке дисплеев ssd1306 и sh1106.

```
[display]
lcd_type:
#    Установите значение "ssd1306" или "sh1106" для данного типа дисплея.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    Дополнительные параметры, доступные для дисплеев, подключенных через шину i2c.
#    шиной. См. раздел "Общие настройки I2C" для описания
#    вышеуказанных параметров.
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    Пины, подключенные к lcd в режиме "4-wire" spi. См.
#    "Общие настройки SPI" для описания параметров.
#    которые начинаются с "spi_". По умолчанию используется режим i2c для
#    дисплея.
#reset_pin:
#    На дисплее может быть указан вывод сброса. Если он не указан.
#    указан, то аппаратное обеспечение должно иметь подтяжку на
#    соответствующей линии ЖК-дисплея.
#contrast:
#    Устанавливаемый контраст. Значение может варьироваться от 0 до 256, а по
#    по умолчанию - 239.
#vcomh: 0
#    Установка значения Vcomh на дисплее. Это значение связано с
#    эффектом "размазывания" на некоторых OLED-дисплеях. Значение может варьироваться
#    от 0 до 63. По умолчанию 0.
#invert: False
#    TRUE инвертирует пиксели на некоторых OLED-дисплеях.  По умолчанию
#    False.
#x_offset: 0
#    Установка значения горизонтального смещения на дисплеях SH1106. По умолчанию
#    0.
...
```

### [display_data]

Поддержка отображения пользовательских данных на ЖК-дисплее. Можно создать любое количество групп отображения и любое количество элементов данных в этих группах. На экране будут отображаться все элементы данных для данной группы, если параметр display_group в секции [display] установлен на имя данной группы.

Автоматически создается [набор групп отображения по умолчанию](.../klippy/extras/display/display.cfg). Можно заменить или расширить эти элементы display_data, переопределив значения по умолчанию в основном файле конфигурации printer.cfg.

```
[display_data my_group_name my_data_name]
позиция:
#    Через запятую строки и столбцы позиции отображения, которая должна
#    использоваться для отображения информации. Этот параметр должен быть
#    предоставлен.
text:
#    Текст для отображения в данной позиции. Это поле оценивается
#    с помощью шаблонов команд (см. docs/Command_Templates.md). Этот
#    параметр должен быть указан.
```

### [display_template]

Текстовые "макросы" отображения данных (можно определить любое количество секций с префиксом display_template). Информацию об оценке шаблонов см. в документе [Шаблоны команд](Command_Templates.md).

Эта возможность позволяет сократить количество повторяющихся определений в секциях display_data. Для оценки шаблона в секциях display_data можно использовать встроенную функцию `render()`. Например, если определить `[display_template my_template]`, то можно использовать `{ render('my_template')}` в секции display_data.

Эта функция также может быть использована для непрерывного обновления светодиодов с помощью команды [SET_LED_TEMPLATE](G-Codes.md#set_led_template).

```
[display_template my_template_name]
#param_<имя>:
#    Можно указать любое количество опций с префиксом "param_". .
#    заданному имени будет присвоено заданное значение (разобранное как Python
#    литерал) и будет доступно при расширении макроса. Если
#    параметр передан в вызове render(), то это значение будет
#    будет использоваться при расширении макроса. Например, конфигурация с
#    "param_speed = 75" может иметь вызывающую функцию с
#    "render('my_template_name', param_speed=80)". Имена параметров могут
#    не использовать символы верхнего регистра.
text:
#    Текст, возвращаемый при рендеринге этого шаблона. Это поле
#    оценивается с помощью шаблонов команд (см.
#    docs/Command_Templates.md). Этот параметр должен быть указан.
```

### [display_glyph]

Отображает пользовательский глиф на дисплеях, которые его поддерживают. Заданное имя будет присвоено данным дисплея, на которые затем можно ссылаться в шаблонах дисплеев по их имени, окруженному двумя символами "тильда", т.е. `~my_display_glyph~`

Примеры смотрите в [sample-glyphs.cfg](../config/sample-glyphs.cfg).

```
[display_glyph my_display_glyph]
#data:
#    Данные дисплея, хранящиеся в виде 16 строк, состоящих из 16 битов (1 на
#    пиксель), где '.' - пустой пиксель, а '*' - включенный пиксель (например,
#    "****************" для отображения сплошной горизонтальной линии).
#    В качестве альтернативы можно использовать '0' для пустого пикселя и '1' для включенного
#    пикселя. Поместите каждую строку отображения в отдельную строку конфигурации. Глиф
#    глиф должен состоять ровно из 16 строк с 16 битами каждая. Этот
#    параметр является необязательным.
#hd44780_data:
#    Глиф для использования на дисплеях 20x4 hd44780. Глиф должен состоять из.
#    ровно 8 строк с 5 битами в каждой. Этот параметр необязателен.
#hd44780_slot:
#    Аппаратный индекс hd44780 (0..7) для хранения глифа. Если
#    несколько разных изображений используют один и тот же слот, то убедитесь, что только
#    использовать только одно из этих изображений на любом экране. Этот параметр
#    требуется, если указан параметр hd44780_data.
```

### [display my_extra_display]

Если в файле printer.cfg определена основная секция [display], как показано выше, можно определить несколько вспомогательных дисплеев. Обратите внимание, что вспомогательные дисплеи в настоящее время не поддерживают функциональность меню, поэтому они не поддерживают опции "меню" или конфигурацию кнопок.

```
[display my_extra_display]
# Доступные параметры см. в разделе "Дисплей".
```

### [меню]

Настраиваемые меню ЖК-дисплея.

Автоматически создается [набор меню по умолчанию](.../klippy/extras/display/menu.cfg). Можно заменить или расширить меню, переопределив значения по умолчанию в основном файле конфигурации printer.cfg.

Информацию об атрибутах меню, доступных при отрисовке шаблона, см. в документе [Шаблоны команд](Command_Templates.md#menu-templates).

```
# Общие параметры, доступные для всех разделов конфигурации меню.
#[menu __some_list __some_name]
#type: disabled
#   Постоянно отключенный элемент меню, единственный обязательный атрибут - 'type'.
#   Позволяет легко отключать/скрывать существующие пункты меню.

#[menu some_name]
#type:
#   Один из команд, ввод, список, текст:
#       command - базовый элемент меню с различными скриптовыми триггерами
#        input    - то же самое, что и 'command', но с возможностью изменения значения.
#                  нажатие запускает/останавливает режим редактирования.
#        список     - позволяет группировать пункты меню в
#                  прокручиваемый список.  Пополняйте список, создавая меню
#                  конфигурации, используя "some_list" в качестве префикса - для
#                  например: [menu some_list some_item_in_the_list]
#       vsdlist - то же самое, что и 'list', но добавляет файлы с виртуальной sdcard
#                 (в будущем будет удален)
#name:
#   Имя пункта меню - оценивается как шаблон.
#enable:
#   Шаблон, который оценивается как True или False.
#index:
#   Позиция, на которую нужно вставить пункт в списке. По умолчанию
#   элемент добавляется в конец.

#[menu some_list]
#type: list
#name:
#enable:
#   Описание этих параметров см. выше.

#[menu some_list some_command]
#type: command
#name:
#enable:
#   Описание этих параметров см. выше.
#gcode:
#   Сценарий для запуска при нажатии кнопки или длительном нажатии. Оценивается как
#  шаблон.

#[menu some_list some_input]
#type: input
#name:
#enable:
#   Описание этих параметров см. выше.
#input:
#   Начальное значение для использования при редактировании - оценивается как шаблон.
#   Результат должен быть float.
#input_min:
#   Минимальное значение диапазона - оценивается как шаблон. По умолчанию -99999.
#input_max:
#   Максимальное значение диапазона - оценивается как шаблон. По умолчанию 99999.
#input_step:
#   Шаг редактирования - должно быть положительным целым числом или плавающей величиной. Имеет
#   внутренний быстрый шаг. Если "(input_max - input_min) /
#   input_step > 100", то быстрый шаг равен 10 * input_step, иначе быстрый шаг
#   шаг скорости равен input_step.
#realtime:
#   Этот атрибут принимает статическое булево значение. Если он включен, то
#   скрипт gcode запускается после каждого изменения значения. По умолчанию установлено значение False.
#gcode:
#   Скрипт для запуска при нажатии кнопки, длительном нажатии или изменении значения.
#   Оценивается как шаблон. Нажатие на кнопку запускает редактирование
#   начало или конец режима.
```

## Датчики нити

### [filament_switch_sensor]

Датчик переключения нити. Поддержка обнаружения вставки и выбега нити с помощью датчика-переключателя, например, концевого выключателя.

Дополнительную информацию см. в [справочнике команд](G-Codes.md#filament_switch_sensor).

```
[filament_switch_sensor my_sensor]
#pause_on_runout: True
#   When set to True, a PAUSE will execute immediately after a runout
#   is detected. Note that if pause_on_runout is False and the
#   runout_gcode is omitted then runout detection is disabled. Default
#   is True.
#runout_gcode:
#   A list of G-Code commands to execute after a filament runout is
#   detected. See docs/Command_Templates.md for G-Code format. If
#   pause_on_runout is set to True this G-Code will run after the
#   PAUSE is complete. The default is not to run any G-Code commands.
#insert_gcode:
#   A list of G-Code commands to execute after a filament insert is
#   detected. See docs/Command_Templates.md for G-Code format. The
#   default is not to run any G-Code commands, which disables insert
#   detection.
#event_delay: 3.0
#   The minimum amount of time in seconds to delay between events.
#   Events triggered during this time period will be silently
#   ignored. The default is 3 seconds.
#pause_delay: 0.5
#   The amount of time to delay, in seconds, between the pause command
#   dispatch and execution of the runout_gcode. It may be useful to
#   increase this delay if OctoPrint exhibits strange pause behavior.
#   Default is 0.5 seconds.
#debounce_delay:
#   A period of time in seconds to debounce events prior to running the
#   switch gcode. The switch must he held in a single state for at least
#   this long to activate. If the switch is toggled on/off during this delay,
#   the event is ignored. Default is 0.
#switch_pin:
#   The pin on which the switch is connected. This parameter must be
#   provided.
```

### [filament_motion_sensor]

Датчик движения нити. Поддержка обнаружения вставки и выбега нити с помощью энкодера, который переключает выходной контакт во время движения нити через датчик.

Дополнительную информацию см. в [справочнике команд](G-Codes.md#filament_switch_sensor).

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#    Минимальная длина нити, протянутой через датчик, чтобы вызвать
#    изменение состояния на контакте switch_pin
#    По умолчанию 7 мм.
extruder:
#    Имя секции экструдера, с которой связан этот датчик.
#    Этот параметр должен быть указан.
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#    Описание параметров см. в разделе "filament_switch_sensor".
#    вышеуказанных параметров.
```

### [tsl1401cl_filament_width_sensor]

Датчик ширины филамента на базе TSLl401CL. Дополнительную информацию см. в [руководстве](TSL1401CL_Filament_Width_Sensor.md).

```
[tsl1401cl_filament_width_sensor]
#pin:
#default_nominal_filament_diameter: 1.75 # (mm)
#    Максимально допустимая разница диаметров нитей в мм.
#max_difference: 0.2
#    Расстояние от датчика до плавильной камеры в мм.
#measurement_delay: 100
```

### [hall_filament_width_sensor]

Датчик ширины нити Холла (см. [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)).

```
[hall_filament_width_sensor]
adc1:
adc2:
#    Контакты аналогового входа, подключенные к датчику. Эти параметры должны
#    быть предоставлены.
#cal_dia1: 1.50
#cal_dia2: 2.00
#    Калибровочные значения (в мм) для датчиков. По умолчанию
# 1.50 для cal_dia1 и 2.00 для cal_dia2.
#raw_dia1: 9500
#raw_dia2: 10500
#    Необработанные калибровочные значения для датчиков. По умолчанию 9500
#    для raw_dia1 и 10500 для raw_dia2.
#default_nominal_filament_diameter: 1.75
#    Номинальный диаметр нити. Этот параметр должен быть указан.
#max_difference: 0.200
#    Максимально допустимая разница в диаметре нити в миллиметрах (мм).
#    Если разница между номинальным диаметром нити и выходным сигналом датчика
#    превышает +- max_difference, множитель экструзии устанавливается обратно
#    до %100. По умолчанию 0.200.
#measurement_delay: 70
#    Расстояние от датчика до плавильной камеры/горячего конца в
#    миллиметрах (мм). Нить между датчиком и горячим концом
#    будет рассматриваться как диаметр_номинального_филамента_по_умолчанию. Хост
#    модуль работает с логикой FIFO. Он сохраняет каждое значение датчика и
#    положение в массиве и возвращает их в правильное положение. Этот
#    параметр должен быть предоставлен.
#enable: False
#    Датчик включается или выключается после включения питания. По умолчанию
#    disable.
#measurement_interval: 10
#    Приблизительное расстояние (в мм) между показаниями датчика. По
#    по умолчанию - 10 мм.
#logging: False
#    Вывод диаметра в терминал и klipper.log можно включить|отключить командой
#    командой.
#min_diameter: 1.0
#    Минимальный диаметр для срабатывания виртуального датчика filament_switch_sensor.
#use_current_dia_while_delay: False
#    Использовать текущий диаметр вместо номинального, пока
#    задержка измерения не закончилась.
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#    Описание параметров см. в разделе "filament_switch_sensor".
#    вышеуказанных параметров.
```

## Датчики нагрузки

### [load_cell]

Тензодатчик. Использует датчик ADC, подключенный к тензодатчику, для создания цифровой шкалы.

```
[load_cell]
sensor_type:
#   This must be one of the supported sensor types, see below.
#counts_per_gram:
#   The floating point number of sensor counts that indicates 1 gram of force.
#   This value is calculated by the LOAD_CELL_CALIBRATE command.
#reference_tare_counts:
#   The integer tare value, in raw sensor counts, taken when LOAD_CELL_CALIBRATE
#   is run. This is the default tare value when klipper starts up.
#sensor_orientation:
#   Change the sensor's orientation. Can be either 'normal' or 'inverted'.
#   The default is 'normal'. Use 'inverted' if the sensor reports a
#   decreasing force value when placed under load.
```

#### HX711

Это 24-битная микросхема с низкой частотой дискретизации, использующая "бит-банг" обмен данными. Он подходит для нитевидных весов.

```
[load_cell]
тип датчика: hx711
sclk_pin:
#    Контакт, подключенный к тактовой линии HX711. Этот параметр должен быть указан.
dout_pin:
#    Контакт, подключенный к линии вывода данных HX711. Этот параметр должен быть
#    предоставлен.
#gain: A-128
#    Допустимыми значениями для коэффициента усиления являются: A-128, A-64, B-32. По умолчанию используется значение A-128.
#    'A' обозначает входной канал, а число - коэффициент усиления. Только 3
#    перечисленных комбинаций поддерживаются микросхемой. Обратите внимание, что изменение коэффициента усиления
#    также выбирает считываемый канал.
#sample_rate: 80
#    Допустимые значения для sample_rate - 80 или 10. По умолчанию используется значение 80.
#    Это должно соответствовать схеме подключения микросхемы. Частота дискретизации не может быть изменена
#    в программном обеспечении.
```

#### HX717

Это версия HX711 с 4-кратным увеличением частоты дискретизации, подходящая для измерений.

```
[load_cell]
тип датчика: hx717
sclk_pin:
#    Контакт, подключенный к тактовой линии HX717. Этот параметр должен быть указан.
dout_pin:
#    Контакт, подключенный к линии вывода данных HX717. Этот параметр должен быть
#    предоставлен.
#gain: A-128
#    Допустимые значения коэффициента усиления: A-128, B-64, A-64, B-8.
#    'A' обозначает входной канал, а число - настройку усиления.
#    Микросхема поддерживает только 4 перечисленные комбинации. Обратите внимание, что
#    изменение настройки усиления также выбирает считываемый канал.
#sample_rate: 320
#    Допустимыми значениями для sample_rate являются: 10, 20, 80, 320. По умолчанию используется значение 320.
#    Это должно соответствовать схеме подключения микросхемы. Частота дискретизации не может быть изменена
#    в программном обеспечении.
```

#### ADS1220

ADS1220 - это 24-битный АЦП, поддерживающий частоту дискретизации до 2 КГц, настраиваемую программно.

```
[load_cell]
sensor_type: ads1220
cs_pin:
#   The pin connected to the ADS1220 chip select line. This parameter must
#   be provided.
#spi_speed: 512000
#   This chip supports 2 speeds: 256000 or 512000. The faster speed is only
#   enabled when one of the Turbo sample rates is used. The correct spi_speed
#   is selected based on the sample rate.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
data_ready_pin:
#   Pin connected to the ADS1220 data ready line. This parameter must be
#   provided.
#gain: 128
#   Valid gain values are 128, 64, 32, 16, 8, 4, 2, 1
#   The default is 128
#pga_bypass: False
#   Disable the internal Programmable Gain Amplifier. If
#   True the PGA will be disabled for gains 1, 2, and 4. The PGA is always
#   enabled for gain settings 8 to 128, regardless of the pga_bypass setting.
#   If AVSS is used as an input pga_bypass is forced to True.
#   The default is False.
#sample_rate: 660
#   This chip supports two ranges of sample rates, Normal and Turbo. In turbo
#   mode the chip's internal clock runs twice as fast and the SPI communication
#   speed is also doubled.
#   Normal sample rates: 20, 45, 90, 175, 330, 600, 1000
#   Turbo sample rates: 40, 90, 180, 350, 660, 1200, 2000
#   The default is 660
#input_mux:
#   Input multiplexer configuration, select a pair of pins to use. The first pin
#   is the positive, AINP, and the second pin is the negative, AINN. Valid
#   values are: 'AIN0_AIN1', 'AIN0_AIN2', 'AIN0_AIN3', 'AIN1_AIN2', 'AIN1_AIN3',
#   'AIN2_AIN3', 'AIN1_AIN0', 'AIN3_AIN2', 'AIN0_AVSS', 'AIN1_AVSS', 'AIN2_AVSS'
#   and 'AIN3_AVSS'. If AVSS is used the PGA is bypassed and the pga_bypass
#   setting will be forced to True.
#   The default is AIN0_AIN1.
#vref:
#   The selected voltage reference. Valid values are: 'internal', 'REF0', 'REF1'
#   and 'analog_supply'. Default is 'internal'.
```

### [load_cell_probe]

Load Cell Probe. This combines the functionality of a [probe] and a [load_cell].

```
[load_cell_probe]
sensor_type:
#   This must be one of the supported bulk ADC sensor types and support
#   load cell endstops on the mcu.
#counts_per_gram:
#reference_tare_counts:
#sensor_orientation:
#   These parameters must be configured before the probe will operate.
#   See the [load_cell] section for further details.
#force_safety_limit: 2000
#   The safe limit for probing force relative to the reference_tare_counts on
#   the load_cell. The default is +/-2Kg.
#trigger_force: 75.0
#   The force that the probe will trigger at. 75g is the default.
#drift_filter_cutoff_frequency: 0.8
#   Enable optional continuous taring while homing & probing to reject drift.
#   The value is a frequency, in Hz, below which drift will be ignored. This
#   option requires the SciPy library. Default: None
#drift_filter_delay: 2
#   The delay, or 'order', of the drift filter. This controls the number of
#   samples required to make a trigger detection. Can be 1 or 2, the default
#   is 2.
#buzz_filter_cutoff_frequency: 100.0
#   The value is a frequency, in Hz, above which high frequency noise in the
#   load cell will be igfiltered outnored. This option requires the SciPy
#   library. Default: None
#buzz_filter_delay: 2
#   The delay, or 'order', of the buzz filter. This controle the number of
#   samples required to make a trigger detection. Can be 1 or 2, the default
#   is 2.
#notch_filter_frequencies: 50, 60
#   1 or 2 frequencies, in Hz, to filter out of the load cell data. This is
#   intended to reject power line noise. This option requires the SciPy
#   library.  Default: None
#notch_filter_quality: 2.0
#   Controls how narrow the range of frequencies are that the notch filter
#   removes. Larger numbers produce a narrower filter. Minimum value is 0.5 and
#   maximum is 3.0. Default: 2.0
#tare_time:
#   The rime in seconds used for taring the load_cell before each probe. The
#   default value is: 4 / 60 = 0.066. This collects samples from 4 cycles of
#   60Hz mains power to cancel power line noise.
#z_offset:
#speed:
#samples:
#sample_retract_dist:
#lift_speed:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#   See the "[probe]" section for a description of the above parameters.
```

## Поддержка аппаратного обеспечения для конкретной платы

### [sx1509]

Настройте расширитель SX1509 с I2C на GPIO. Из-за задержки, возникающей при обмене данными по протоколу I2C, вы не должны использовать выводы SX1509 в качестве выводов разрешения шага, шага или дир или любых других выводов, требующих быстрого перебора битов. Лучше всего использовать их в качестве статических или управляемых кодом цифровых выходов или аппаратных pwm-выводов для, например, вентиляторов. Можно определить любое количество секций с префиксом "sx1509". Каждый расширитель предоставляет набор из 16 выводов (sx1509_my_sx1509:PIN_0 - sx1509_my_sx1509:PIN_15), которые могут быть использованы в конфигурации принтера.

Пример смотрите в файле [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg).

```
[sx1509 my_sx1509]
i2c_address:
#    Адрес I2C, используемый этим расширителем. В зависимости от аппаратных
#    перемычек это один из следующих адресов: 62 63 112
#    113. Этот параметр должен быть указан.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#    См. раздел "Общие настройки I2C" для описания
#    выше указанных параметров.
```

### [samd_sercom]

Конфигурация SAMD SERCOM, определяющая, какие контакты использовать на данном SERCOM. Можно определить любое количество секций с префиксом "samd_sercom". Каждый SERCOM должен быть сконфигурирован до использования его в качестве периферийного устройства SPI или I2C. Поместите эту секцию конфигурации выше любой другой секции, использующей шины SPI или I2C.

```
[samd_sercom my_sercom]
sercom:
#    Имя шины sercom для конфигурирования в микроконтроллере.
#    Доступные имена: "sercom0", "sercom1" и т. д. Этот параметр
#    должен быть указан.
tx_pin:
#    вывод MOSI для SPI-коммуникации, или вывод SDA (данные) для I2C
#    связи. Контакт должен иметь действительную конфигурацию pinmux
#    для данного периферийного устройства SERCOM. Этот параметр должен быть предоставлен.
#rx_pin:
#    вывод MISO для связи по SPI. Этот вывод не используется для I2C
#    связи (I2C использует tx_pin как для отправки, так и для приема).
#    Контакт должен иметь правильную конфигурацию pinmux для данного
#    периферийного устройства SERCOM. Этот параметр является необязательным.
clk_pin:
#    вывод CLK для SPI-коммуникации, или вывод SCL (тактовый генератор) для I2C
#    связи. Контакт должен иметь правильную конфигурацию pinmux
#    для данного периферийного устройства SERCOM. Этот параметр должен быть предоставлен.
```

### [adc_scaled]

Масштабирование аналоговых сигналов Duet2 Maestro по показаниям vref и vssa. Определение секции adc_scaled позволяет использовать виртуальные выводы adc (например, "my_name:PB0"), которые автоматически корректируются контрольными выводами vref и vssa платы. Обязательно определите эту секцию конфигурации выше всех секций конфигурации, которые используют один из этих виртуальных выводов.

Пример смотрите в файле [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg).

```
[adc_scaled my_name]
vref_pin:
#    Контакт АЦП, который будет использоваться для контроля VREF. Этот параметр должен быть
#    предоставлен.
vssa_pin:
#    Вывод АЦП, используемый для мониторинга VSSA. Этот параметр должен быть
#    предоставлен.
#smooth_time: 2.0
#    Значение времени (в секундах), в течение которого измерения vref и vssa
#    измерения будут сглажены, чтобы уменьшить влияние
#    шума. По умолчанию - 2 секунды.
```

### [ads1x1x]

ADS1013, ADS1014, ADS1015, ADS1113, ADS1114 and ADS1115 are I2C based Analog to Digital Converters that can be used for temperature sensors. They provide 4 analog input pins either as single line or as differential input.

Note: Use caution if using this sensor to control heaters. The heater min_temp and max_temp are only verified in the host and only if the host is running and operating normally. (ADC inputs directly connected to the micro-controller verify min_temp and max_temp within the micro-controller and do not require a working connection to the host.)

```
[ads1x1x my_ads1x1x]
chip: ADS1115
#pga: 4.096V
#   Default value is 4.096V. The maximum voltage range used for the input. This
#   scales all values read from the ADC. Options are: 6.144V, 4.096V, 2.048V,
#   1.024V, 0.512V, 0.256V
#adc_voltage: 3.3
#   The suppy voltage for the device. This allows additional software scaling
#   for all values read from the ADC.
i2c_mcu: host
i2c_bus: i2c.1
#address_pin: GND
#   Default value is GND.  There can be up to four addressed devices depending
#   upon wiring of the device. Check the datasheet for details. The i2c_address
#   can be specified directly instead of using the address_pin.
```

The chip provides pins that can be used on other sensors.

```
sensor_type: ...
#   Can be any thermistor or adc_temperature.
sensor_pin: my_ads1x1x:AIN0
#   A combination of the name of the ads1x1x chip and the pin. Possible
#   pin values are AIN0, AIN1, AIN2 and AIN3 for single ended lines and
#   DIFF01, DIFF03, DIFF13 and DIFF23 for differential between their
#   correspoding lines. For example
#   DIFF03 measures the differential between line 0 and 3. Only specific
#   combinations for the differentials are allowed.
```

### [реплика]

Поддержка репликации - см. руководство [beaglebone guide](Beaglebone.md) и файл [generic-replicape.cfg](../config/generic-replicape.cfg) для примера.

```
# Раздел конфигурации "replicape" добавляет "replicape:stepper_x_enable"
# виртуальные контакты разрешения шагов (для шагов X, Y, Z, E и H) и
# "replicape:power_x" выходные контакты ШИМ (для hotbed, e, h, fan0, fan1,
# fan2 и fan3), которые затем могут быть использованы в других местах конфигурационного файла.
[replicape].
ревизия:
#    Ревизия аппаратного обеспечения replicape. В настоящее время поддерживается только ревизия "B3"
#    поддерживается. Этот параметр должен быть указан.
#enable_pin: !gpio0_20
#    Глобальный разрешающий пин replicape. По умолчанию используется !gpio0_20 (он же
#    P9_41).
host_mcu:
#    Имя секции конфигурации mcu, которая взаимодействует с
#    экземпляром mcu Klipper "linux process". Этот параметр должен быть
#    предоставлен.
#standstill_power_down: False
#    Этот параметр управляет строкой CFG6_ENN на всех шаговых
#    моторов. True устанавливает строки разрешения в "открытое" состояние. По умолчанию
#    False.
#stepper_x_microstep_mode:
#stepper_y_microstep_mode:
#stepper_z_microstep_mode:
#stepper_e_microstep_mode:
#stepper_h_microstep_mode:
#    Этот параметр управляет контактами CFG1 и CFG2 данного
#    драйвера шагового двигателя. Доступные опции: disable, 1, 2,
#    spread2, 4, 16, spread4, spread16, stealth4 и stealth16. По адресу
#    по умолчанию - disable.
#stepper_x_current:
#stepper_y_current:
#stepper_z_current:
#stepper_e_current:
#stepper_h_current:
#    Настроенный максимальный ток (в амперах) шагового двигателя.
#    драйвера. Этот параметр должен быть указан, если шаговый двигатель не находится в
#    отключенном режиме.
#stepper_x_chopper_off_time_high:
#stepper_y_chopper_off_time_high:
#stepper_z_chopper_off_time_high:
#stepper_e_chopper_off_time_high:
#stepper_h_chopper_off_time_high:
#    Этот параметр управляет выводом CFG0 драйвера шагового двигателя.
#    (True устанавливает высокий уровень CFG0, False - низкий). По умолчанию используется значение False.
#stepper_x_chopper_hysteresis_high:
#stepper_y_chopper_hysteresis_high:
#stepper_z_chopper_hysteresis_high:
#stepper_e_chopper_hysteresis_high:
#stepper_h_chopper_hysteresis_high:
#    Этот параметр управляет выводом CFG4 драйвера шагового двигателя.
#    (True устанавливает высокий уровень CFG4, False - низкий). По умолчанию используется значение False.
#stepper_x_chopper_blank_time_high:
#stepper_y_chopper_blank_time_high:
#stepper_z_chopper_blank_time_high:
#stepper_e_chopper_blank_time_high:
#stepper_h_chopper_blank_time_high:
#    Этот параметр управляет выводом CFG5 драйвера шагового двигателя.
#    (True устанавливает высокий уровень CFG5, False - низкий). По умолчанию установлено значение True.
```

## Другие пользовательские модули

### [палитра2]

Поддержка мультиматериалов Palette 2 - обеспечивает более тесную интеграцию, поддерживая устройства Palette 2 в подключенном режиме.

Для полной функциональности этого модуля также необходимы `[virtual_sdcard]` и `[pause_resume]`.

Если вы используете этот модуль, не используйте плагин Palette 2 для Octoprint, так как они будут конфликтовать, и 1 не сможет инициализироваться должным образом, что приведет к прерыванию печати.

If you use Octoprint and stream gcode over the serial port instead of printing from virtual_sd, then remove **M1** and **M0** from *Pausing commands* in *Settings > Serial Connection > Firmware & protocol* will prevent the need to start print on the Palette 2 and unpausing in Octoprint for your print to begin.

```
[palette2]
serial:
#    Последовательный порт для подключения к Palette 2.
# Baud: 115200
#    Используемая скорость передачи данных. По умолчанию 115200.
#feedrate_splice: 0.8
#    Скорость передачи данных, используемая при сращивании, по умолчанию 0,8
#feedrate_normal: 1.0
#    Скорость подачи после сращивания, по умолчанию 1,0
#auto_load_speed: 2
#    Скорость подачи экструзии при автозагрузке, по умолчанию 2 (мм/с)
#auto_cancel_variation: 0.1
#   Автоматическая отмена печати при изменении пинга выше этого порога
```

### [angle]

Magnetic hall angle sensor support for reading stepper motor angle shaft measurements using a1333, as5047d, mt6816, mt6826s, or tle5012b SPI chips. The measurements are available via the [API Server](API_Server.md) and [motion analysis tool](Debugging.md#motion-analysis-and-data-logging). See the [G-Code reference](G-Codes.md#angle) for available commands.

```
[angle my_angle_sensor]
sensor_type:
#   The type of the magnetic hall sensor chip. Available choices are
#   "a1333", "as5047d", "mt6816", "mt6826s", and "tle5012b". This parameter must be
#   specified.
#sample_period: 0.000400
#   The query period (in seconds) to use during measurements. The
#   default is 0.000400 (which is 2500 samples per second).
#stepper:
#   The name of the stepper that the angle sensor is attached to (eg,
#   "stepper_x"). Setting this value enables an angle calibration
#   tool. To use this feature, the Python "numpy" package must be
#   installed. The default is to not enable angle calibration for the
#   angle sensor.
cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
```

## Общие параметры шины

### Общие настройки SPI

Следующие параметры обычно доступны для устройств, использующих шину SPI.

```
#spi_speed:
#    Скорость SPI (в гц), которую следует использовать при обмене данными с устройством.
#    Значение по умолчанию зависит от типа устройства.
#spi_bus:
#    Если микроконтроллер поддерживает несколько шин SPI, то можно
#    указать здесь имя шины микроконтроллера. Значение по умолчанию зависит от
#    типа микроконтроллера.
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#    Укажите вышеуказанные параметры для использования "программного SPI". Этот
#    режим не требует аппаратной поддержки микроконтроллера (обычно
#    могут использоваться любые пины общего назначения). По умолчанию не используется
#    "программный SPI".
```

### Общие настройки I2C

Следующие параметры обычно доступны для устройств, использующих шину I2C.

Обратите внимание, что текущая поддержка I2C микроконтроллерами Klipper, как правило, не толерантна к помехам на линии. Неожиданные ошибки на проводах I2C могут привести к тому, что Klipper выдаст ошибку во время выполнения. Поддержка Klipper для устранения ошибок варьируется в зависимости от типа микроконтроллера. Обычно рекомендуется использовать только те устройства I2C, которые находятся на той же печатной плате, что и микроконтроллер.

Most Klipper micro-controller implementations only support an `i2c_speed` of 100000 (*standard mode*, 100kbit/s). The Klipper "Linux" micro-controller supports a 400000 speed (*fast mode*, 400kbit/s), but it must be [set in the operating system](RPi_microcontroller.md#optional-enabling-i2c) and the `i2c_speed` parameter is otherwise ignored. The Klipper "RP2040" micro-controller and ATmega AVR family and some STM32 (F0, G0, G4, L4, F7, H7) support a rate of 400000 via the `i2c_speed` parameter. All other Klipper micro-controllers use a 100000 rate and ignore the `i2c_speed` parameter.

```
#i2c_address:
#    i2c-адрес устройства. Он должен быть указан в виде десятичного
#    число (не в шестнадцатеричном виде). Значение по умолчанию зависит от типа устройства.
#i2c_mcu:
#    Имя микроконтроллера, к которому подключена микросхема.
#    По умолчанию - "mcu".
#i2c_bus:
#    Если микроконтроллер поддерживает несколько шин I2C, то можно
#    указать здесь имя шины микроконтроллера. Значение по умолчанию зависит от
#    типа микроконтроллера.
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#    Укажите эти параметры, чтобы использовать программное обеспечение микроконтроллера.
#    поддержки "битового удара" I2C. Эти два параметра должны соответствовать двум выводам
#    на микроконтроллере для проводов scl и sda. На
#    по умолчанию используется аппаратная поддержка I2C, указанная параметром
#    параметром i2c_bus.
#i2c_speed:
#    Скорость I2C (в Гц), которую следует использовать при взаимодействии с устройством.
#    Реализация Klipper на большинстве микроконтроллеров жестко закодирована
#    на 100000, и изменение этого значения не имеет никакого эффекта. По умолчанию
#    100000. Linux, RP2040 и ATmega поддерживают 400000.
```
