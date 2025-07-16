# G-коды

Этот документ описываетJВ этом документе описаны команды, поддерживаемые Klipper. Это команды, которые можно ввести на вкладке терминала OctoPrint. команды, поддерживаемые Klipper. Это команды, которые можно ввести на вкладке терминала OctoPrint.

## Команды G-кода

Klipper поддерживает следующие стандартные команды G-кода:

- Перемещение (G0 или G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- Ожидание: `G4 P<time(ms)>`
- Перемещение в начало координат: `G28 [X] [Y] [Z]`.
- Выключите моторы: `М18` или `М84`
- Ожидание окончания всех перемещений в планировщике: `M400`
- Использовать абсолютное/относительное расстояния для выдавливания экструдером: `M82`/`M83`
- Использовать абсолютные/относительные координаты: `G90`, `G91`
- Установить указанное значение положения: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- Установите процентный коэффициент скорости: `M220 S<percent>`
- Установите коэффициент потока: `M221 S<percent>`
- Установка ускорений: `M204 S<value>` OR `M204 P<value> T<value>`
   - Примечание: Если S не указано, а указаны P и T, то ускорение устанавливается на минимальное значение из P и T. Если указано только одно из P или T, то команда не имеет эффекта.
- Получить температуру экструдера: `M105`
- Установить температуру экструдеру: `M104 [T<index>] [S<temperature>]`
- Установить температуру экструдеру и ожидать нагрева: `M109 [T<index>] S<temperature>`
   - Примечание: M109 ждет, пока температура установится на требуемом значении.
- Установить температуру стола: `M140 [S<temperature>]`
- Установить температуру стола и ждать нагрева: `M190 S<temperature>`
   - Примечание: M190 ждет, пока температура установится на требуемом значении.
- Установить скорость вентилятору: `M106 S<value>`
- Выключить вентилятор: `M107`
- Аварийная остановка: `M112`
- Получить текущее значение положения активного инструмента: `M114`
- Получить информацию о прошивке: `M115`

Дополнительные сведения о приведенных выше командах см. в документации [RepRap G-Code](http://reprap.org/wiki/G-code).

Цель Klipper - поддерживать команды G-Code, создаваемые распространенным программным обеспечением сторонних производителей (например, OctoPrint, Printrun, Slic3r, Cura и т.д.) в их стандартных конфигурациях. Целью не является поддержка всех возможных команд G-кода. Вместо этого Klipper отдает предпочтение человекочитаемым ["расширенным командам G-Code"](#additional-commands). Аналогично, вывод терминала в G-коде предназначен только для чтения человеком - см. документ [API Server](API_Server.md), если вы управляете Klipper из внешнего программного обеспечения.

Если требуется менее распространенная команда G-Code, то ее можно реализовать с помощью [пользовательского макроса gcode_macro](Config_Reference.md#gcode_macro). Например, это можно использовать для реализации: `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1`, и т.д.

## Дополнительные команды

Klipper использует «расширенные» команды G-Code для общей конфигурации и статуса. Все эти расширенные команды следуют схожему формату — они начинаются с имени команды и могут сопровождаться одним или несколькими параметрами. Например: `SET_SERVO SERVO=myservo ANGLE=5.3`. В этом документе команды и параметры показаны в верхнем регистре, однако они не чувствительны к регистру. (Так, «SET_SERVO» и «set_servo» запускают одну и ту же команду.)

Этот раздел организован по названиям модулей Klipper, которые обычно следуют за названиями разделов, указанными в [файле конфигурации принтера](Config_Reference.md). Обратите внимание, что некоторые модули загружаются автоматически.

### [adxl345]

Следующие команды доступны, если включен раздел [adxl345 config](Config_Reference.md#adxl345).

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: Запускает измерения акселерометра с требуемым количеством выборок в секунду. Если CHIP не указан, по умолчанию используется значение "adxl345". Команда работает в режиме старт-стоп: при первом выполнении она запускает измерения, при последующих - останавливает их. Результаты измерений записываются в файл с именем `/tmp/adxl345-<chip>-<name>.csv`, где `<chip>` - имя чипа акселерометра (`my_chip_name` из `[adxl345 my_chip_name]`), а `<name>` - необязательный параметр NAME. Если NAME не указан, то по умолчанию используется текущее время в формате "YYYYMMDD_HHMMSS". Если акселерометр не имеет имени в разделе конфигурации (просто `[adxl345]`), то `<чип>` часть имени не генерируется.

#### ОПРОС_АКСЕЛЕРОМЕТРА

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: запрашивает акселерометр для получения текущего значения. Если CHIP не указан, по умолчанию используется значение "adxl345". Если значение RATE не указано, используется значение по умолчанию. Эта команда полезна для проверки соединения с акселерометром ADXL345: одно из возвращаемых значений должно быть ускорением свободного падения (+/- некоторый шум чипа).

#### Отладка акселерометра

`Отладка акселерометра [ЧИП =<имя_конфигурации> РЕГ=<регистр>`: запрос ADXL345 регистрация "регистр" (примеры: 44 или 0x2C). Может быть полезен для целей отладки.

#### Отладка акселерометра: запись

`ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<register> VAL=<value>`: Записывает необработанное «value» в регистр «register». И «value», и «register» могут быть десятичным или шестнадцатеричным целым числом. Используйте с осторожностью и обратитесь к спецификации ADXL345 для справки.

### [угол]

Следующие команды доступны, если включен раздел [angle config](Config_Reference.md#angle).

#### Калибровка угла

`ANGLE_CALIBRATE CHIP=<имя_чипа>`: Выполняет калибровку угла на заданном датчике (должна быть секция конфигурации `[имя_чипа_угла]`, в которой указан параметр `шаговый двигатель`). ВАЖНО - этот инструмент даст команду шаговому двигателю двигаться без проверки обычных кинематических границ. В идеале перед выполнением калибровки двигатель должен быть отсоединен от каретки принтера. Если шаговый двигатель не может быть отсоединен от принтера, перед началом калибровки убедитесь, что каретка находится вблизи центра своей направляющей. (Во время этого теста шаговый двигатель может переместиться вперед или назад на два полных оборота). После завершения теста воспользуйтесь командой `SAVE_CONFIG`, чтобы сохранить данные калибровки в файле config. Для использования этого инструмента необходимо установить пакет Python "numpy" (более подробную информацию см. в документе [Измерение резонансов](Measuring_Resonances.md#software-installation)).

#### ANGLE_CHIP_CALIBRATE

`ANGLE_CHIP_CALIBRATE CHIP=<chip_name>`: Perform internal sensor calibration, if implemented (MT6826S/MT6835).

- **MT68XX**: The motor should be disconnected from any printer carriage before performing calibration. After calibration, the sensor should be reset by disconnecting the power.

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<имя_конфигурации> REG=<регистр>`: Запрашивает "регистр" датчика (например, 44 или 0x2C). Может быть полезен для целей отладки. Эта функция доступна только для чипов tle5012b.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<имя_конфигурации> REG=<регистр> VAL=<значение>`: Записывает необработанное "значение" в регистр "register". И "значение", и "регистр" могут быть десятичными или шестнадцатеричными целыми числами. Используйте с осторожностью и обратитесь к спецификации датчика. Эта функция доступна только для чипов tle5012b.

### [axis_twist_compensation]

The following commands are available when the [axis_twist_compensation config
section](Config_Reference.md#axis_twist_compensation) is enabled.

#### AXIS_TWIST_COMPENSATION_CALIBRATE

`AXIS_TWIST_COMPENSATION_CALIBRATE [AXIS=<X|Y>] [SAMPLE_COUNT=<value>]`

Calibrates axis twist compensation by specifying the target axis or enabling automatic calibration.

- **AXIS:** Define the axis (`X` or `Y`) for which the twist compensation will be calibrated. If not specified, the axis defaults to `'X'`.

### [сетка_стола]

Следующие команды доступны, если включен раздел [bed_mesh config](Config_Reference.md#bed_mesh) (также см. руководство по [bed mesh](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [PROFILE=<name>] [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=1] [ADAPTIVE_MARGIN=<value>]`: This command probes the bed using generated points specified by the parameters in the config. After probing, a mesh is generated and z-movement is adjusted according to the mesh. The mesh is immediately active after successful completion of `BED_MESH_CALIBRATE`. The mesh will be saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. If ADAPTIVE=1 is specified then the profile name will begin with `adaptive-` and should not be saved for reuse. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file. If ADAPTIVE=1 is specified then the objects defined by the Gcode file being printed will be used to define the probed area. The optional `ADAPTIVE_MARGIN` value overrides the `adaptive_margin` option specified in the config file.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`: Эта команда выводит на терминал текущие значения z зондирования и текущие значения сетки. Если указано PGP=1, то на терминал будут выведены координаты X, Y, сгенерированные bed_mesh, и связанные с ними индексы.

#### BED_MESH_MAP

`BED_MESH_MAP`: Как и BED_MESH_OUTPUT, эта команда выводит текущее состояние сетки на терминал. Вместо того чтобы печатать значения в человекочитаемом формате, состояние сериализуется в формате json. Это позволяет плагинам octoprint легко перехватывать данные и генерировать карты высот, приближенные к поверхности кровати.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: Эта команда очищает сетку и удаляет все корректировки по z. Рекомендуется поместить ее в конечный код.

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<имя> SAVE=<имя> REMOVE=<имя>`: Эта команда обеспечивает управление профилем для состояния сетки. LOAD восстановит состояние сетки из профиля, соответствующего указанному имени. SAVE сохранит текущее состояние сетки в профиле, соответствующем указанному имени. Remove удалит профиль, соответствующий указанному имени, из постоянной памяти. Обратите внимание, что после выполнения операций SAVE или REMOVE необходимо запустить код SAVE_CONFIG, чтобы изменения в постоянной памяти стали постоянными.

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<значение>] [Y=<значение>] [ZFADE=<значение]`: Применяет смещения X, Y и/или ZFADE к поиску сетки. Это полезно для принтеров с независимыми экструдерами, поскольку смещение необходимо для правильной настройки Z после смены инструмента. Обратите внимание, что смещение ZFADE не применяет дополнительную корректировку по оси Z напрямую, оно используется для корректировки расчета `fade`, когда к оси Z было применено смещение `gcode`.

### [bed_screws]

Следующие команды доступны, если включен раздел [bed_screws config](Config_Reference.md#bed_screws) (также см. руководство [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`: Эта команда вызывает инструмент регулировки винтов станины. Она направит сопло в разные места (как определено в файле конфигурации) и позволит отрегулировать винты станины так, чтобы станина находилась на постоянном расстоянии от сопла.

### [bed_tilt]

Следующие команды доступны, если включен раздел [bed_tilt config](Config_Reference.md#bed_tilt).

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Эта команда зондирует точки, указанные в конфигурации, а затем рекомендует обновленные корректировки наклона по x и y. Подробности о дополнительных параметрах зондирования см. в команде PROBE. Если указан METHOD=manual, то активируется инструмент ручного зондирования - см. выше команду MANUAL_PROBE для получения подробной информации о дополнительных командах, доступных при активном инструменте. Необязательное значение `HORIZONTAL_MOVE_Z` отменяет параметр `horizontal_move_z`, указанный в файле конфигурации.

### [bltouch]

Следующая команда доступна, если включен раздел [bltouch config](Config_Reference.md#bltouch) (также см. руководство [BL-Touch](BLTouch.md)).

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<команда>`: Это отправляет команду на BLTouch. Это может быть полезно для отладки. Доступны следующие команды: `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`. BL-Touch V3.0 или V3.1 также может поддерживать команды `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store`.

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`: Сохраняет режим вывода в EEPROM BLTouch V3.1 Доступными режимами вывода являются: `5V`, `OD`.

### [ конфигурационный файл ]

Модуль конфигурационного файла загружается автоматически.

#### SAVE_CONFIG

`SAVE_CONFIG`: Эта команда перезапишет основной файл конфигурации принтера и перезапустит программное обеспечение хоста. Эта команда используется вместе с другими командами калибровки для сохранения результатов калибровочных тестов.

### [delayed_gcode]

Следующая команда включается, если включен раздел конфигурации [delayed_gcode](Config_Reference.md#delayed_gcode) (также см. руководство по [шаблонам](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<имя>] [DURATION=<секунды>]`: Обновляет длительность задержки для определенного [delayed_gcode] и запускает таймер для выполнения gcode. Значение 0 отменяет выполнение отложенного gcode.

### [delta_calibrate]

Следующие команды доступны, если включен раздел конфигурации [delta_calibrate config](Config_Reference.md#linear-delta-kinematics) (также см. руководство [delta calibrate](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Эта команда прощупывает семь точек на станине и рекомендует обновить положение конечных упоров, углы наклона башни и радиус. Подробности о дополнительных параметрах зондирования см. в команде PROBE. Если указан METHOD=manual, то активируется инструмент ручного зондирования - см. выше команду MANUAL_PROBE для получения подробной информации о дополнительных командах, доступных при активном инструменте. Необязательное значение `HORIZONTAL_MOVE_Z` отменяет параметр `horizontal_move_z`, указанный в файле конфигурации.

#### DELTA_ANALYZE

`DELTA_ANALYZE`: Эта команда используется во время расширенной дельта-калибровки. Подробности см. в [Delta Calibrate](Delta_Calibrate.md).

### [дисплей]

Следующая команда доступна, если включен [display config section](Config_Reference.md#gcode_macro).

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`: Установка активной группы данных дисплея. Это позволяет определить несколько групп данных дисплея в конфиге, например, `[display_data <group> <elementname>]` и переключаться между ними с помощью этой расширенной команды gcode. Если DISPLAY не указан, то по умолчанию используется значение "display" (основной дисплей).

### [display_status]

Модуль display_status автоматически загружается, если включен раздел [display config](Config_Reference.md#display). Он предоставляет следующие стандартные команды G-кода:

- Отображение сообщения: `M117 <сообщение>`
- Установите процент сборки: `M73 P<процент>`

Также предоставляется следующая расширенная команда G-Code:

- `SET_DISPLAY_TEXT MSG=<message>`: Выполняет эквивалент команды M117, устанавливая заданное значение `MSG` в качестве текущего сообщения на дисплее. Если `MSG` не задано, дисплей будет очищен.

### [dual_carriage]

Следующая команда доступна, если включен раздел [dual_carriage config](Config_Reference.md#dual_carriage).

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=<carriage> [MODE=[PRIMARY|COPY|MIRROR]]`: This command will change the mode of the specified carriage. If no `MODE` is provided it defaults to `PRIMARY`. `<carriage>` must reference a defined primary or dual carriage for `generic_cartesian` kinematics or be 0 (for primary carriage) or 1 (for dual carriage) for all other kinematics supporting IDEX. Setting the mode to `PRIMARY` deactivates the other carriage and makes the specified carriage execute subsequent G-Code commands as-is. `COPY` and `MIRROR` modes are supported only for dual carriages. When set to either of these modes, dual carriage will then track the subsequent moves of its primary carriage and either copy relative movements of it (in `COPY` mode) or execute them in the opposite (mirror) direction (in `MIRROR` mode).

#### SAVE_DUAL_CARRIAGE_STATE

`SAVE_DUAL_CARRIAGE_STATE [NAME=<имя_состояния>]`: Сохраняет текущие положения сдвоенных вагонеток и их режимы. Сохранение и восстановление состояния DUAL_CARRIAGE может быть полезно в скриптах и макросах, а также в переопределении процедур самонаведения. Если указано NAME, то можно дать имя сохраненному состоянию в виде заданной строки. Если NAME не указано, то по умолчанию используется значение "default".

#### RESTORE_DUAL_CARRIAGE_STATE

`RESTORE_DUAL_CARRIAGE_STATE [NAME=<имя_состояния>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: Восстанавливает ранее сохраненные позиции сдвоенных кареток и их режимы, если только не указано "MOVE=0", в этом случае будут восстановлены только сохраненные режимы, но не позиции кареток. Если восстанавливаются позиции и указано "MOVE_SPEED", то перемещения инструментальной головки будут выполняться с заданной скоростью (в мм/с); в противном случае для перемещения инструментальной головки будет использоваться скорость наведения рельса. Обратите внимание, что каретки восстанавливают свои позиции только по своей оси, что может потребоваться для корректного восстановления режимов COPY и MIRROR сдвоенного кареточного узла.

### [endstop_phase]

Следующие команды доступны, если включен раздел конфигурации [endstop_phase](Config_Reference.md#endstop_phase) (также см. руководство по [endstop phase](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<имя_конфигурации>]`: Если параметр STEPPER не указан, то эта команда выдает статистику по фазам шага конечного останова во время прошлых операций самонаведения. Если указан параметр STEPPER, то данная команда записывает заданную настройку фазы конечного останова в файл конфигурации (в сочетании с командой SAVE_CONFIG).

### [exclude_object]

Следующие команды доступны, если включен раздел конфигурации [exclude_object](Config_Reference.md#exclude_object) (также см. руководство по [exclude object](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=имя_объекта] [CURRENT=1] [RESET=1]`: Без параметров возвращает список всех исключенных в данный момент объектов.

Если указан параметр `НАЗВАНИЕ`, именованный объект будет исключен из печати.

Если указан параметр `СЕРВИС`, то текущий объект будет исключен из печати.

При указании параметра `СБРОС` список исключенных объектов будет очищен. Дополнительно указав `НАЗВАНИЕ`, вы сбросите только названный объект. Это **может** привести к сбоям печати, если слои уже были пропущены.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=имя_объекта [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`: Предоставляет краткую информацию об объекте в файле.

Без указания параметров выводит список определенных объектов, известных Klipper. Возвращает список строк, если не указан параметр `JSON`, тогда возвращает информацию об объекте в формате json.

Если включен параметр `NAME`, это определяет объект, который нужно исключить.

- `НАЗВАНИЕ`: Этот параметр является обязательным. Это идентификатор, используемый другими командами в этом модуле.
- `ЦЕНТР`: Координаты X,Y для объекта.
- `POLYGON`: Массив координат X,Y, которые обеспечивают контур объекта.

При указании параметра `СБРОС` все определенные объекты будут очищены, а модуль `[exclude_object]` будет сброшен.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=имя_объекта`: Эта команда принимает параметр `НАЗВАНИЕ` и обозначает начало g-кода для объекта на текущем слое.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=имя_объекта]`: Обозначает конец g-кода объекта для слоя. Он работает в паре с `EXCLUDE_OBJECT_START`. Параметр `NAME` необязателен, и предупреждение будет выдано только в том случае, если указанное имя не соответствует текущему объекту.

### [экструдер]

Следующие команды доступны, если включен раздел [Extruder config](Config_Reference.md#extruder):

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<имя_конфигурации>`: В принтере с несколькими разделами конфигурации [extruder](Config_Reference.md#extruder) эта команда изменяет активный хотэнд.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Установка параметров опережения давления шагового экструдера (как определено в разделе конфигурации [extruder](Config_Reference.md#extruder) или [extruder_stepper](Config_Reference.md#extruder_stepper)). Если EXTRUDER не указан, по умолчанию используется степпер, определенный в активном хотэнде.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: Устанавливает новое значение для "расстояния вращения" шагового механизма экструдера (как определено в разделе конфигурации [extruder](Config_Reference.md#extruder) или [extruder_stepper](Config_Reference.md#extruder_stepper)). Если расстояние поворота - отрицательное число, то шаговое движение будет инвертировано (относительно направления шагового движения, указанного в файле конфигурации). Измененные настройки не сохраняются при перезагрузке Klipper. Используйте настройки с осторожностью, так как небольшие изменения могут привести к чрезмерному давлению между экструдером и хотэндом. Перед использованием выполните правильную калибровку с помощью филамента. Если значение 'DISTANCE' не задано, то эта команда вернет текущее расстояние вращения.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<имя> MOTION_QUEUE=<имя>`: Эта команда заставит степпер, указанный EXTRUDER (как определено в разделе конфигурации [extruder](Config_Reference.md#extruder) или [extruder_stepper](Config_Reference.md#extruder_stepper)), стать синхронизированным с движением экструдера, указанного MOTION_QUEUE (как определено в разделе конфигурации [extruder](Config_Reference.md#extruder)). Если MOTION_QUEUE - пустая строка, то степпер будет десинхронизирован от всех движений экструдера.

### [fan_generic]

Следующая команда доступна, если включен раздел конфигурации [fan_generic config](Config_Reference.md#fan_generic).

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<speed>` Эта команда устанавливает скорость вентилятора. Значение "speed" должно быть в диапазоне от 0,0 до 1,0.

`SET_FAN_SPEED PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given fan. For example, if one defined a `[display_template my_fan_template]` config section then one could assign `TEMPLATE=my_fan_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the fan will be automatically set to the resulting speed. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_FAN_SPEED` commands to manage the values directly).

### [filament_switch_sensor]

Следующая команда доступна, если включен раздел конфигурации [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) или [filament_motion_sensor](Config_Reference.md#filament_motion_sensor).

#### Опрос сенсора (наличия) филамента

`QUERY_FILAMENT_SENSOR SENSOR=<имя_сенсора>`: Запрашивает текущее состояние датчика нити. Данные, отображаемые на терминале, зависят от типа датчика, определенного в конфигурации.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<имя_сенсора> ENABLE=[0|1]`: Устанавливает включение/выключение датчика нити накаливания. Если ENABLE установлен в 0, датчик нити будет отключен, если в 1 - включен.

### [firmware_retraction]

Следующие стандартные команды G-кода доступны, если включен раздел конфигурации [firmware_retraction config](Config_Reference.md#firmware_retraction). Эти команды позволяют использовать встроенную функцию втягивания, доступную во многих слайсерах, для уменьшения натяжения струн во время перемещения без экструзии из одной части печати в другую. Соответствующая настройка опережения давления позволяет уменьшить длительность втягивания.

- `G10`: Втягивает экструдер с использованием текущих настроенных параметров.
- `G11`: Разворачивает экструдер с использованием текущих настроенных параметров.

Также доступны следующие дополнительные команды.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>]`: Настройка параметров, используемых при втягивании микропрограммы. RETRACT_LENGTH определяет длину нити для втягивания и вытягивания. Скорость втягивания регулируется с помощью RETRACT_SPEED и обычно устанавливается относительно высокой. Скорость втягивания регулируется с помощью UNRETRACT_SPEED и не является особенно критичной, хотя часто бывает ниже, чем RETRACT_SPEED. В некоторых случаях полезно добавить небольшое количество дополнительной длины при распутывании, и это задается через UNRETRACT_EXTRA_LENGTH. SET_RETRACTION обычно задается как часть конфигурации слайсера для каждого филамента, поскольку для разных филаментов требуются разные настройки параметров.

#### GET_RETRACTION

`GET_RETRACTION`: Запрашивает текущие параметры, используемые при втягивании прошивки, и выводит их на терминал.

### [force_move]

Модуль force_move загружается автоматически, однако некоторые команды требуют установки `enable_force_move` в [printer config](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<имя_конфигурации>`: Перемещает заданный степпер вперед на один мм, а затем назад на один мм, повторяя 10 раз. Это диагностический инструмент, помогающий проверить подключение шаговика.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<имя_конфигурации> DISTANCE=<значение> VELOCITY=<значение> [ACCEL=<значение>]`: Эта команда принудительно перемещает заданный степпер на заданное расстояние (в мм) с заданной постоянной скоростью (в мм/с). Если значение ACCEL больше нуля, то будет использовано заданное ускорение (в мм/с^2); в противном случае ускорение не выполняется. Проверка границ не выполняется; кинематические обновления не производятся; другие параллельные степперы на оси не будут перемещаться. Соблюдайте осторожность, так как неправильная команда может привести к повреждению! Использование этой команды почти наверняка приведет низкоуровневую кинематику в неправильное состояние; после этого подайте команду G28 для сброса кинематики. Эта команда предназначена для низкоуровневой диагностики и отладки.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] [SET_HOMED=<[X][Y][Z]>] [CLEAR_HOMED=<[X][Y][Z]>]`: Force the low-level kinematic code to believe the toolhead is at the given cartesian position and set/clear homed status. This is a diagnostic and debugging command; use SET_GCODE_OFFSET and/or G92 for regular axis transformations. Setting an incorrect or invalid position may lead to internal software errors.

The `X`, `Y`, and `Z` parameters are used to alter the low-level kinematic position tracking. If any of these parameters are not set then the position is not changed - for example `SET_KINEMATIC_POSITION Z=10` would set all axes as homed, set the internal Z position to 10, and leave the X and Y positions unchanged. Changing the internal position tracking is not dependent on the internal homing state - one may alter the position for both homed and not homed axes, and similarly one may set or clear the homing state of an axis without altering its internal position.

The `SET_HOMED` parameter defaults to `XYZ` which instructs the kinematics to consider all axes as homed. A bare `SET_KINEMATIC_POSITION` command will result in all axes being considered homed (and not change its current position). If it is not desired to change the state of homed axes then assign `SET_HOMED` to an empty string - for example: `SET_KINEMATIC_POSITION SET_HOMED= X=10`. It is also possible to request an individual axis be considered homed (eg, `SET_HOMED=X`), but note that non-cartesian style kinematics (such as delta kinematics) may not support setting an individual axis as homed.

The `CLEAR_HOMED` parameter instructs the kinematics to consider the given axes as not homed. For example, `CLEAR_HOMED=XYZ` would request all axes to be considered not homed (and thus require homing prior to movement on those axes). The default is `SET_HOMED=XYZ` even if `CLEAR_HOMED` is present, so the command `SET_KINEMATIC_POSITION CLEAR_HOMED=Z` will set X and Y as homed and clear the homing state for Z. Use `SET_KINEMATIC_POSITION SET_HOMED= CLEAR_HOMED=Z` if the goal is to clear only the Z homing state. If an axis is specified in neither `SET_HOMED` nor `CLEAR_HOMED` then its homing state is not changed and if it is specified in both then `CLEAR_HOMED` has precedence. It is possible to request clearing of an individual axis, but on non-cartesian style kinematics (such as delta kinematics) doing so may result in clearing the homing state of additional axes. Note the `CLEAR` parameter is currently an alias for the `CLEAR_HOMED` parameter, but this alias will be removed in the future.

### [gcode]

Модуль gcode загружается автоматически.

#### ПЕРЕЗАПУСК

`RESTART`: Эта команда заставит хост-программу перезагрузить свою конфигурацию и выполнить внутренний сброс. Эта команда не очищает состояние ошибки микроконтроллера (см. FIRMWARE_RESTART) и не загружает новое программное обеспечение (см. [FAQ](FAQ.md#how-do-i-upgrade-to-the-latest-software)).

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`: Эта команда похожа на команду RESTART, но она также очищает состояние ошибки микроконтроллера.

#### STATUS

`СТАТУС`: Сообщение о состоянии программного обеспечения хоста Klipper.

#### ПОМОЩЬ

`ПОМОЩЬ`: Сообщение о списке доступных расширенных команд G-Code.

### [gcode_arcs]

Следующие стандартные команды G-Code доступны, если включен раздел [gcode_arcs config](Config_Reference.md#gcode_arcs):

- Перемещение по дуге по часовой стрелке (G2), перемещение по дуге против часовой стрелки (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`.
- Выбор плоскости дуги: G17 (плоскость XY), G18 (плоскость XZ), G19 (плоскость YZ)

### [gcode_macro]

Следующая команда доступна, если включен раздел конфигурации [gcode_macro](Config_Reference.md#gcode_macro) (также см. руководство по [шаблонам команд](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`: Эта команда позволяет изменить значение переменной gcode_macro во время выполнения. Предоставленное значение VALUE разбирается как литерал Python.

### [gcode_move]

Модуль gcode_move загружается автоматически.

#### GET_POSITION

`GET_POSITION`: Возвращает информацию о текущем местоположении головки инструмента. Дополнительную информацию см. в документации разработчика [GET_POSITION output](Code_Overview.md#coordinate-systems).

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Установка позиционного смещения для применения к последующим командам G-кода. Обычно это используется для виртуального изменения смещения станины по оси Z или для установки смещения сопла по оси XY при переключении экструдеров. Например, если отправить команду "SET_GCODE_OFFSET Z=0.2", то к будущим перемещениям G-кода будет добавлено 0,2 мм к их высоте по Z. Если используются параметры стиля X_ADJUST, то корректировка будет добавлена к любому существующему смещению (например, "SET_GCODE_OFFSET Z=-0.2" с последующим "SET_GCODE_OFFSET Z_ADJUST=0.3" приведет к общему смещению по Z на 0.1). Если указано значение "MOVE=1", то для применения заданного смещения будет выполнено перемещение инструментальной головки (в противном случае смещение вступит в силу при следующем абсолютном перемещении G-кода, задающем данную ось). Если задано значение "MOVE_SPEED", то перемещение инструментальной головки будет выполняться с заданной скоростью (в мм/с); в противном случае при перемещении будет использоваться последняя заданная скорость G-кода.

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<имя_состояния>]`: Сохраняет текущее состояние разбора координат g-кода. Сохранение и восстановление состояния g-кода полезно в скриптах и макросах. Эта команда сохраняет текущий режим абсолютных координат g-кода (G90/G91), режим абсолютного выдавливания (M82/M83), начало координат (G92), смещение (SET_GCODE_OFFSET), переопределение скорости (M220), переопределение экструдера (M221), скорость перемещения, текущую позицию XYZ и относительную позицию "E" экструдера. Если указано NAME, то можно присвоить имя сохраненному состоянию в виде заданной строки. Если NAME не указано, то по умолчанию используется значение " по умолчанию".

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<имя_состояния>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Восстановление состояния, ранее сохраненного с помощью SAVE_GCODE_STATE. Если указано "MOVE=1", то будет выдано перемещение головки инструмента для возврата в предыдущую позицию XYZ. Если задано значение "MOVE_SPEED", то перемещение инструментальной головки будет выполнено с заданной скоростью (в мм/с); в противном случае для перемещения будет использована восстановленная скорость g-кода.

### [generic_cartesian]

The commands in this section become automatically available when `kinematics: generic_cartesian` is specified as the printer kinematics.

#### SET_STEPPER_CARRIAGES

`SET_STEPPER_CARRIAGES STEPPER=<stepper_name> CARRIAGES=<carriages> [DISABLE_CHECKS=[0|1]]`: Set or update the stepper carriages. `<stepper_name>` must reference an existing stepper defined in `printer.cfg`, and `<carriages>` describes the carriages the stepper moves. See [Generic Cartesian Kinematics](Config_Reference.md#generic-cartesian-kinematics) for a more detailed overview of the `carriages` parameter in the stepper configuration section. Note that it is only possible to change the coefficients or signs of the carriages with this command, but a user cannot add or remove the carriages that the stepper controls.

`SET_STEPPER_CARRIAGES` is an advanced tool, and the user is advised to exercise an extreme caution using it, since specifying incorrect configuration may physically damage the printer.

Note that `SET_STEPPER_CARRIAGES` performs certain internal validations of the new printer kinematics after the change. Keep in mind that if it detects an issue, it may leave printer kinematics in an invalid state. This means that if `SET_STEPPER_CARRIAGES` reports an error, it is unsafe to issue other GCode commands, and the user must inspect the error message and either fix the problem, or manually restore the previous stepper(s) configuration.

Since `SET_STEPPER_CARRIAGES` can update a configuration of a single stepper at a time, some sequences of changes can lead to invalid intermediate kinematic configurations, even if the final configuration is valid. In such cases a user can pass `DISABLE_CHECKS=1` parameters to all but the last command to disable intermediate checks. For example, if `stepper a` and `stepper b` initially have `x-y` and `x+y` carriages correspondingly, then the following sequence of commands will let a user effectively swap the carriage controls: `SET_STEPPER_CARRIAGES STEPPER=a CARRIAGES=x+y DISABLE_CHECKS=1` and `SET_STEPPER_CARRIAGES STEPPER=b CARRIAGES=x-y`, while still validating the final kinematics state.

### [hall_filament_width_sensor]

Следующие команды доступны, если включен раздел конфигурации [tsl1401cl filament width sensor config](Config_Reference.md#tsl1401cl_filament_width_sensor) или [hall filament width sensor config section](Config_Reference. md#hall_filament_width_sensor) включен (см. также [TSLl401CL Filament Width Sensor](TSL1401CL_Filament_Width_Sensor.md) и [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)):

#### Запрос ширины филамента

`QUERY_FILAMENT_WIDTH`: Возвращает текущую измеренную ширину нити.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`: Очищает все показания датчика. Полезно после замены нити.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`: Отключите датчик ширины нити и перестаньте использовать его для управления потоком.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR`: Включите датчик ширины нити и начните использовать его для управления потоком.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`: Возвращает текущие показания каналов АЦП и значение датчика в формате RAW для точек калибровки.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`: Включите ведение журнала диаметра.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`: Отключает ведение журнала диаметра.

### [обогреватели]

Модуль нагревателей загружается автоматически, если в файле конфигурации определен нагреватель.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`: Выключите все обогреватели.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Подождите, пока заданный датчик температуры не окажется на уровне или выше указанного МИНИМУМА и/или на уровне или ниже указанного МАКСИМУМА.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<имя_нагревателя> [TARGET=<целевая_температура>]`: Устанавливает целевую температуру для нагревателя. Если целевая температура не указана, то она равна 0.

### [idle_timeout]

Модуль idle_timeout загружается автоматически.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: Позволяет пользователю установить таймаут простоя (в секундах).

### [input_shaper]

Следующая команда активируется, если включен раздел [input_shaper config](Config_Reference.md#input_shaper) (также см. руководство по [resonance compensation](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`: Изменение входных параметров формирователя. Обратите внимание, что параметр SHAPER_TYPE сбрасывает входной формирователь для осей X и Y, даже если в разделе [input_shaper] были настроены разные типы формирователей. SHAPER_TYPE нельзя использовать вместе с одним из параметров SHAPER_TYPE_X и SHAPER_TYPE_Y. Дополнительные сведения о каждом из этих параметров см. в [config reference](Config_Reference.md#input_shaper).

### [led]

Следующая команда доступна, если включен любой из разделов [led config](Config_Reference.md#leds).

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: Устанавливает выход светодиодов. Каждый цвет `<значения>` должен быть в диапазоне от 0,0 до 1,0. Опция WHITE действительна только для RGBW-светодиодов. Если светодиод поддерживает несколько чипов в последовательной цепочке, можно указать INDEX для изменения цвета только данного чипа (1 для первого чипа, 2 для второго и т. д.). Если INDEX не указан, то все светодиоды в последовательной цепочке будут настроены на заданный цвет. Если указано TRANSMIT=0, то изменение цвета будет происходить только при следующей команде SET_LED, в которой не указано TRANSMIT=0; это может быть полезно в сочетании с параметром INDEX для пакетного обновления нескольких светодиодов в последовательной цепочке. По умолчанию команда SET_LED синхронизирует свои изменения с другими текущими командами gcode. Это может привести к нежелательному поведению, если светодиоды устанавливаются в то время, когда принтер не печатает, так как это приведет к сбросу таймаута простоя. Если тщательная синхронизация не требуется, можно указать дополнительный параметр SYNC=0, чтобы применить изменения без сброса таймаута простоя.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<имя_леда> TEMPLATE=<имя_шаблона> [<param_x>=<литерал>] [INDEX=<индекс>]`: Присваивает [display_template](Config_Reference.md#display_template) заданному [LED](Config_Reference.md#leds). Например, если определить секцию конфигурации `[display_template my_led_template]`, то здесь можно назначить `TEMPLATE=my_led_template`. Шаблон display_template должен создавать строку, разделенную запятыми, содержащую четыре числа с плавающей точкой, соответствующие настройкам красного, зеленого, синего и белого цветов. Шаблон будет постоянно оцениваться, и светодиод будет автоматически устанавливаться на полученные цвета. Можно задать параметры display_template для использования во время оценки шаблона (параметры будут разобраны как литералы Python). Если INDEX не указан, то все чипы в последовательной цепочке светодиода будут установлены в соответствии с шаблоном, в противном случае будет обновлен только чип с заданным индексом. Если TEMPLATE - пустая строка, то эта команда очистит любой предыдущий шаблон, назначенный светодиоду (после этого можно использовать команды `SET_LED` для управления настройками цвета светодиода).

### [load_cell]

The following commands are enabled if a [load_cell config section](Config_Reference.md#load_cell) has been enabled.

### LOAD_CELL_DIAGNOSTIC

`LOAD_CELL_DIAGNOSTIC [LOAD_CELL=<config_name>]`: This command collects 10 seconds of load cell data and reports statistics that can help you verify proper operation of the load cell. This command can be run on both calibrated and uncalibrated load cells.

### LOAD_CELL_CALIBRATE

`LOAD_CELL_CALIBRATE [LOAD_CELL=<config_name>]`: Start the guided calibration utility. Calibration is a 3 step process:

1. First you remove all load from the load cell and run the `TARE` command
1. Next you apply a known load to the load cell and run the `CALIBRATE GRAMS=nnn` command
1. Finally use the `ACCEPT` command to save the results

You can cancel the calibration process at any time with `ABORT`.

### LOAD_CELL_TARE

`LOAD_CELL_TARE [LOAD_CELL=<config_name>]`: This works just like the tare button on digital scale. It sets the current raw reading of the load cell to be the zero point reference value. The response is the percentage of the sensors range that was read and the raw value in counts. If the load cell is calibrated a force in grams is also reported.

### LOAD_CELL_READ load_cell="name"

`LOAD_CELL_READ [LOAD_CELL=<config_name>]`: This command takes a reading from the load cell. The response is the percentage of the sensors range that was read and the raw value in counts. If the load cell is calibrated a force in grams is also reported.

### [load_cell_probe]

The following commands are enabled if a [load_cell config section](Config_Reference.md#load_cell_probe) has been enabled.

### LOAD_CELL_TEST_TAP

`LOAD_CELL_TEST_TAP [TAPS=<taps>] [TIMEOUT=<timeout>]`: Run a testing routine that reports taps on the load cell. The toolhead will not move but the load cell probe will sense taps just as if it was probing. This can be used as a sanity check to make sure that the probe works. This tool replaces QUERY_ENDSTOPS and QUERY_PROBE for load cell probes.

- `TAPS`: the number of taps the tool expects
- `TIMEOOUT`: the time, in seconds, that the tool waits for each tab before aborting.

### Load Cell Command Extensions

Commands that perform probes, such as [`PROBE`](#probe), [`PROBE_ACCURACY`](#probe_accuracy), [`BED_MESH_CALIBRATE`](#bed_mesh_calibrate) etc. will accept additional parameters if a `[load_cell_probe]` is defined. The parameters override the corresponding settings from the [`[load_cell_probe]`](./Config_Reference.md#load_cell_probe) configuration:

- `FORCE_SAFETY_LIMIT=<grams>`
- `TRIGGER_FORCE=<grams>`
- `DRIFT_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `DRIFT_FILTER_DELAY=<1|2>`
- `BUZZ_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `BUZZ_FILTER_DELAY=<1|2>`
- `NOTCH_FILTER_FREQUENCIES=<list of frequency_hz>`
- `NOTCH_FILTER_QUALITY=<quality>`
- `TARE_TIME=<seconds>`

### [manual_probe]

Модуль manual_probe загружается автоматически.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`: Запуск вспомогательного скрипта, полезного для измерения высоты сопла в заданном месте. Если указано значение SPEED, оно задает скорость команд TESTZ (по умолчанию 5 мм/с). Во время ручного зондирования доступны следующие дополнительные команды:

- `АКТИВИРОВАТЬ`: Эта команда принимает текущее положение Z и завершает работу ручного измерительного инструмента.
- `Прервано`: Эта команда завершает работу инструмента ручного зондирования.
- `TESTZ Z=<значение>`: Эта команда перемещает сопло вверх или вниз на величину, указанную в "value". Например, `TESTZ Z=-.1` переместит сопло вниз на .1 мм, а `TESTZ Z=.1` переместит сопло вверх на .1 мм. Значение также может быть `+`, `-`, `++` или `--` для перемещения форсунки вверх или вниз на величину относительно предыдущих попыток.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: Запуск вспомогательного скрипта, полезного для калибровки настроек конфигурации Z position_endstop. Подробнее о параметрах и дополнительных командах, доступных при активном инструменте, см. в команде MANUAL_PROBE.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`: Берет текущее смещение Z Gcode (оно же babystepping) и вычитает его из позиции endstop_position шагового механизма. Это позволяет взять часто используемое значение babystepping и "сделать его постоянным". Для вступления в силу требуется `SAVE_CONFIG`.

### [manual_stepper]

Следующая команда доступна, если включен раздел [manual_stepper config](Config_Reference.md#manual_stepper).

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]]`: Эта команда изменяет состояние шагового механизма. Используйте параметр ENABLE для включения/выключения шаговика. Используйте параметр SET_POSITION, чтобы заставить шаговик думать, что он находится в заданном положении. Используйте параметр MOVE, чтобы запросить перемещение в заданную позицию. Если указаны SPEED и/или ACCEL, то данные значения будут использоваться вместо значений по умолчанию, указанных в файле конфигурации. Если значение ACCEL равно нулю, то ускорение не будет выполняться. Если указано STOP_ON_ENDSTOP=1, то движение завершится раньше, если конечная остановка сработает (используйте STOP_ON_ENDSTOP=2, чтобы завершить движение без ошибки, даже если конечная остановка не сработает, используйте -1 или -2, чтобы остановиться, если конечная остановка не сработает). Обычно будущие команды G-кода планируются на выполнение после завершения шагового перемещения, однако если при ручном шаговом перемещении используется SYNC=0, то будущие команды G-кода могут выполняться параллельно с шаговым перемещением.

`MANUAL_STEPPER STEPPER=config_name GCODE_AXIS=[A-Z] [LIMIT_VELOCITY=<velocity>] [LIMIT_ACCEL=<accel>] [INSTANTANEOUS_CORNER_VELOCITY=<velocity>]`: If the `GCODE_AXIS` parameter is specified then it configures the stepper motor as an extra axis on `G1` move commands. For example, if one were to issue a `MANUAL_STEPPER ... GCODE_AXIS=R` command then one could issue commands like `G1 X10 Y20 R30` to move the stepper motor. The resulting moves will occur synchronously with the associated toolhead xyz movements. If the motor is associated with a `GCODE_AXIS` then one may no longer issue movements using the above `MANUAL_STEPPER` command - one may unregister the stepper with a `MANUAL_STEPPER ... GCODE_AXIS=` command to resume manual control of the motor. The `LIMIT_VELOCITY` and `LIMIT_ACCEL` parameters allow one to reduce the speed of `G1` moves if those moves would result in a velocity or acceleration above the specified limits. The `INSTANTANEOUS_CORNER_VELOCITY` specifies the maximum instantaneous velocity change (in mm/s) of the motor during the junction of two moves (the default is 1mm/s).

### [mcp4018]

Следующая команда доступна, если включен раздел [mcp4018 config](Config_Reference.md#mcp4018).

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: Эта команда изменит текущее значение дигипота. Обычно это значение должно быть между 0.0 и 1.0, если только в конфигурации не задан 'scale'. Если 'scale' определено, то это значение должно быть между 0.0 и 'scale'.

### [output_pin]

Следующая команда доступна, если включен раздел [output_pin config](Config_Reference.md#output_pin).

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value>`: Устанавливает пин на заданный выход `VALUE`. Для "цифровых" выводов VALUE должно быть 0 или 1. Для ШИМ-выводов установите значение между 0.0 и 1.0 или между 0.0 и `scale`, если шкала задана в секции конфигурации output_pin.

`SET_PIN PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given pin. For example, if one defined a `[display_template my_pin_template]` config section then one could assign `TEMPLATE=my_pin_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the pin will be automatically set to the resulting value. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_PIN` commands to manage the values directly).

### [palette2]

Следующие команды доступны, если включен раздел [palette2 config](Config_Reference.md#palette2).

Палитра печати работает за счет встраивания специальных кодов OCodes (Omega Codes) в файл GCode:

- `O1`...`O32`: Эти коды считываются из потока GCode, обрабатываются этим модулем и передаются на устройство Palette 2.

Также доступны следующие дополнительные команды.

#### PALETTE_CONNECT

`PALETTE_CONNECT`: Эта команда инициализирует соединение с Palette 2.

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`: Эта команда позволяет отключиться от палитры 2.

#### PALETTE_CLEAR

`PALETTE_CLEAR`: Эта команда дает команду Palette 2 очистить все входные и выходные пути от нити.

#### PALETTE_CUT

`PALETTE_CUT`: Эта команда дает команду Palette 2 отрезать нить, загруженную в сердцевину сращивания.

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`: Эта команда запускает последовательность интеллектуальной загрузки на Palette 2. Филамент загружается автоматически, выдавливая его на расстояние, откалиброванное на устройстве для принтера, и дает команду Palette 2, когда загрузка завершена. Эта команда аналогична нажатию кнопки **Smart Load** непосредственно на экране Palette 2 после завершения загрузки филамента.

### [pause_resume]

Следующие команды доступны, если включен раздел [pause_resume config](Config_Reference.md#pause_resume):

#### ПАУЗА

`ПАУЗА`: Приостанавливает текущую печать. Текущая позиция фиксируется для восстановления при возобновлении.

#### РЕЗЮМЕ

`RESUME [VELOCITY=<значение>]`: Возобновляет печать после паузы, сначала восстанавливая ранее захваченную позицию. Параметр VELOCITY определяет скорость, с которой инструмент должен вернуться в исходное захваченное положение.

#### CLEAR_PAUSE

`CLEAR_PAUSE`: Очищает текущее состояние паузы, не возобновляя печать. Это полезно, если вы решили отменить печать после ПАУЗЫ. Рекомендуется добавить эту функцию в стартовый gcode, чтобы убедиться, что состояние паузы обновляется для каждой печати.

#### CANCEL_PRINT

`CANCEL_PRINT`: Отменяет текущую печать.

### [pid_calibrate]

Модуль pid_calibrate загружается автоматически, если в конфигурационном файле задан нагреватель.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<имя_конфигурации> TARGET=<температура> [WRITE_FILE=1]`: Выполняет тест калибровки ПИД. Указанный нагреватель будет включен до достижения заданной целевой температуры, а затем нагреватель будет выключен и включен в течение нескольких циклов. Если параметр WRITE_FILE включен, то будет создан файл /tmp/heattest.txt с журналом всех образцов температуры, взятых во время теста.

### [print_stats]

Модуль print_stats загружается автоматически.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>] [CURRENT_LAYER= <current_layer>]`: Передача информации слайсера, такой как действие слоя и общее количество, в Klipper. Добавьте `SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>]` в секцию gcode запуска слайсера и `SET_PRINT_STATS_INFO [CURRENT_LAYER= <current_layer>]` в секцию gcode изменения слоя, чтобы передать информацию о слоях из слайсера в Klipper.

### [probe]

Следующие команды доступны, если включен раздел [probe config](Config_Reference.md#probe) или [bltouch config](Config_Reference.md#bltouch) (также см. руководство [probe calibrate](Probe_Calibrate.md)).

#### Проба

`PROBE [PROBE_SPEED=<мм/с>] [LIFT_SPEED=<мм/с>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<мм>] [SAMPLES_TOLERANCE=<мм>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`: Перемещайте насадку вниз до срабатывания зонда. Если указан любой из необязательных параметров, они отменяют эквивалентные настройки в разделе [probe config] (Config_Reference.md#probe).

#### QUERY_PROBE

'Запрос_Пробы': Отчёт о текущем статусе пробы (задействована или открыта)

#### Точность пробы

`PROBE_ACCURACY [PROBE_SPEED=<мм/с>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<мм>]`: Вычисляет максимальное, минимальное, среднее, медиану и стандартное отклонение для нескольких образцов зонда. По умолчанию берется 10 проб. В противном случае необязательные параметры по умолчанию соответствуют их эквивалентным настройкам в разделе конфигурации зонда.

#### Калибровка пробы

`PROBE_CALIBRATE [SPEED=<speed>] [<параметр_зонда>=<значение>]`: Запуск вспомогательного сценария, полезного для калибровки z_смещения зонда. Подробные сведения о дополнительных параметрах зонда см. в команде PROBE. Подробные сведения о параметре SPEED и дополнительных командах, доступных при активном инструменте, см. в команде MANUAL_PROBE. Обратите внимание, что команда PROBE_CALIBRATE использует переменную скорости для перемещения в направлении XY, а также Z.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`: Возьмите текущее смещение Z Gcode (оно же babystepping) и вычтите его из z_offset зонда. Это позволяет взять часто используемое значение babystepping и "сделать его постоянным". Для вступления в силу требуется `SAVE_CONFIG`.

### [probe_eddy_current]

Следующие команды доступны, если включен раздел конфигурации [probe_eddy_current](Config_Reference.md#probe_eddy_current).

#### PROBE_EDDY_CURRENT_CALIBRATE

`PROBE_EDDY_CURRENT_CALIBRATE CHIP=<имя_конфигурации>`: Это запускает инструмент, который калибрует резонансные частоты датчиков по соответствующим высотам Z. Работа инструмента займет пару минут. После завершения используйте команду SAVE_CONFIG, чтобы сохранить результаты в файле printer.cfg.

#### LDC_CALIBRATE_DRIVE_CURRENT

`LDC_CALIBRATE_DRIVE_CURRENT CHIP=<имя_конфигурации>` Этот инструмент откалибрует регистр ldc1612 DRIVE_CURRENT0. Перед использованием этого инструмента переместите датчик так, чтобы он находился около центра станины и примерно на 20 мм выше ее поверхности. Выполните эту команду, чтобы определить подходящее значение DRIVE_CURRENT для датчика. После выполнения этой команды воспользуйтесь командой SAVE_CONFIG, чтобы сохранить новую настройку в файле конфигурации printer.cfg.

### Цикл PWM

Следующая команда доступна, если включен раздел конфигурации [pwm_cycle_time](Config_Reference.md#pwm_cycle_time).

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: Эта команда работает аналогично командам [output_pin](#output_pin) SET_PIN. Здесь команда поддерживает установку явного времени цикла с помощью параметра CYCLE_TIME (задается в секундах). Обратите внимание, что параметр CYCLE_TIME не сохраняется между командами SET_PIN (любая команда SET_PIN без явного параметра CYCLE_TIME будет использовать `cycle_time`, указанное в разделе конфигурации pwm_cycle_time).

### [quad_gantry_level]

The following commands are available when the [quad_gantry_level config section](Config_Reference.md#quad_gantry_level) is enabled.

#### QUAD_GANTRY_LEVEL

`QUAD_GANTRY_LEVEL [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `RETRIES`, `RETRY_TOLERANCE`, and `HORIZONTAL_MOVE_Z` values override those options specified in the config file.

### [query_adc]

Модуль query_adc загружается автоматически.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]`: Сообщение о последнем аналоговом значении, полученном для сконфигурированного аналогового вывода. Если NAME не указано, то будет выдан список доступных имен adc. Если указано PULLUP (как значение в Омах), то сообщается необработанное аналоговое значение вместе с эквивалентным сопротивлением с учетом подтяжки.

### Запрос концевиков

Модуль query_endstops загружается автоматически. В настоящее время доступны следующие стандартные команды G-кода, но использовать их не рекомендуется:

- Получить статус конечной остановки: `M119` (Вместо этого используйте QUERY_ENDSTOPS)

#### Запрос концевиков

`QUERY_ENDSTOPS`: Проверяет концевые упоры оси и сообщает, "сработали" они или находятся в "открытом" состоянии. Эта команда обычно используется для проверки правильности работы концевого ограничителя.

### [resonance_tester]

Следующие команды доступны, если включен раздел конфигурации [resonance_tester](Config_Reference.md#resonance_tester) (также см. руководство по [измерению резонансов](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: Измеряет и выводит шум для всех осей всех включенных чипов акселерометров.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> [OUTPUT=<resonances,raw_data>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [POINT=x,y,z] [INPUT_SHAPING=<0:1>]`: Runs the resonance test in all configured probe points for the requested "axis" and measures the acceleration using the accelerometer chips configured for the respective axis. "axis" can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. `chip_name` can be one or more configured accel chips, delimited with comma, for example `CHIPS="adxl345, adxl345 rpi"`. If POINT is specified it will override the point(s) configured in `[resonance_tester]`. If `INPUT_SHAPING=0` or not set(default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured or POINT is specified). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>][HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [MAX_SMOOTHING=<max_smoothing>] [INPUT_SHAPING=<0:1>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command, and if `[input_shaper]` was already enabled previously, these parameters take effect immediately.

### [ответить]

Следующие стандартные команды G-кода доступны, если включен раздел [respond config](Config_Reference.md#respond):

- `M118 <сообщение>`: передать эхом сообщение, дополненное настроенным префиксом по умолчанию (или `echo:`, если префикс не настроен).

Также доступны следующие дополнительные команды.

#### ОТВЕТИТЬ

- `RESPOND MSG="<message>"`: отправить эхом сообщение, дополненное настроенным префиксом по умолчанию (или `echo:`, если префикс не настроен).
- `RESPOND TYPE=echo MSG="<сообщение>"`: передайте эхом сообщение, дополненное `echo: `.
- `RESPOND TYPE=echo_no_space MSG="<message>"`: эхо сообщения, дополненного `echo:`, без пробела между префиксом и сообщением, полезно для совместимости с некоторыми плагинами octoprint, которые ожидают очень специфического форматирования.
- `RESPOND TYPE=command MSG="<message>"`: эхо сообщения, дополненного `//`. OctoPrint может быть настроен на ответ на эти сообщения (например, `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<сообщение>"`: передайте сообщение, дополненное символом `!!! `.
- `RESPOND PREFIX=<prefix> MSG="<сообщение>"`: передать эхом сообщение, дополненное `<префикс>`. (Параметр `ПРЕФИКС` будет иметь приоритет над параметром `ТИП`)

### [save_variables]

Следующая команда включается, если был включен раздел [save_variables config](Config_Reference.md#save_variables).

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`: Saves the variable to disk so that it can be used across restarts. The VARIABLE must be lowercase. All stored variables are loaded into the `printer.save_variables.variables` dict at startup and can be used in gcode macros. The provided VALUE is parsed as a Python literal.

### [screws_tilt_adjust]

Следующие команды доступны, если включен раздел конфигурации [screws_tilt_adjust](Config_Reference.md#screws_tilt_adjust) (также см. руководство [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the bed-probe)).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<значение>] [HORIZONTAL_MOVE_Z=<значение>] [<параметр_зонда>=<значение>]`: Эта команда вызывает инструмент регулировки винтов станины. Она направит сопло в разные места (как определено в файле конфигурации), измеряя высоту z, и рассчитает количество поворотов ручки для регулировки уровня станины. Если указано значение DIRECTION, все повороты ручки будут выполняться в одном направлении - по часовой стрелке (CW) или против часовой стрелки (CCW). Подробные сведения о дополнительных параметрах датчика см. в команде PROBE. ВАЖНО: Перед использованием этой команды всегда необходимо выполнить G28. Если указано MAX_DEVIATION, команда выдаст ошибку gcode, если разница в высоте винта по отношению к базовой высоте винта будет больше указанного значения. Необязательное значение `HORIZONTAL_MOVE_Z` переопределяет опцию `horizontal_move_z`, указанную в файле конфигурации.

### [sdcard_loop]

Когда раздел [sdcard_loop config](Config_Reference.md#sdcard_loop) включен, доступны следующие расширенные команды.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`: Начало зацикленной секции в SD-печати. Счетчик, равный 0, указывает на то, что секцию следует зацикливать бесконечно.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: Завершает зацикленную секцию в SD-печати.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: Завершить существующие циклы без дальнейших итераций.

### [servo]

Следующие команды доступны, если включен раздел [config серво](Config_Reference.md#servo).

#### SET_SERVO

`SET_SERVO SERVO=config_name [ANGLE=<degrees> | WIDTH=<seconds>]`: Устанавливает положение сервопривода на заданный угол (в градусах) или длительность импульса (в секундах). Используйте `WIDTH=0`, чтобы отключить выход сервопривода.

### [skew_correction]

Следующие команды доступны, если включен раздел конфигурации [skew_correction](Config_Reference.md#skew_correction) (также см. руководство [Skew Correction](Skew_Correction.md)).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`: Настраивает модуль [skew_correction] с помощью измерений (в мм), взятых из калибровочной печати. Можно ввести измерения для любой комбинации плоскостей, не введенные плоскости сохранят свое текущее значение. Если ввести `CLEAR=1`, то вся коррекция перекоса будет отключена.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: Сообщает текущий перекос принтера для каждой плоскости в радианах и градусах. Перекос вычисляется на основе параметров, заданных с помощью g-кода `SET_SKEW`.

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>]`: Вычисляет и сообщает величину перекоса (в радианах и градусах) на основе измеренного отпечатка. Это может быть полезно для определения текущего перекоса принтера после применения коррекции. Он также может быть полезен до применения коррекции, чтобы определить необходимость коррекции перекоса. Подробные сведения об объектах калибровки перекоса и измерениях см. в разделе [Skew Correction](Skew_Correction.md).

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<имя>] [SAVE=<имя>] [REMOVE=<имя>]`: Управление профилем для исправления перекоса. LOAD восстанавливает состояние перекоса из профиля, соответствующего указанному имени. SAVE сохранит текущее состояние перекоса в профиле, соответствующем указанному имени. Remove удалит профиль, соответствующий указанному имени, из постоянной памяти. Обратите внимание, что после выполнения операций SAVE или REMOVE необходимо запустить код SAVE_CONFIG, чтобы изменения в постоянной памяти стали постоянными.

### [smart_effector]

Несколько команд доступны, если включен раздел конфигурации [smart_effector](Config_Reference.md#smart_effector). Перед изменением параметров Smart Effector обязательно ознакомьтесь с официальной документацией по Smart Effector на [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer). Также ознакомьтесь с руководством по калибровке [Probe calibration guide](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<чувствительность>] [ACCEL=<ускорение>] [RECOVERY_TIME=<время>]`: Установка параметров интеллектуального эффектора. При указании `SENSITIVITY` соответствующее значение записывается в EEPROM SmartEffector (требуется наличие `control_pin`). Допустимые значения `<чувствительности>` - 0...255, по умолчанию - 50. При меньших значениях требуется меньшее усилие контакта с соплом для срабатывания (но возрастает риск ложного срабатывания из-за вибраций во время зондирования), а при больших значениях уменьшается количество ложных срабатываний (но требуется большее усилие контакта для срабатывания). Поскольку чувствительность записывается в EEPROM, она сохраняется после выключения, и поэтому ее не нужно настраивать при каждом запуске принтера. Параметры `ACCEL` и `RECOVERY_TIME` позволяют переопределять соответствующие параметры во время выполнения, более подробную информацию об этих параметрах см. в разделе [config](Config_Reference.md#smart_effector) Smart Effector.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`: Возвращает чувствительность Smart Effector к заводским настройкам. Требует указания `control_pin` в секции config.

### [stepper_enable]

Модуль stepper_enable загружается автоматически.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<имя_конфигурации> ENABLE=[0|1]`: Включает или выключает только заданный степпер. Это диагностический и отладочный инструмент, который следует использовать с осторожностью. Отключение осевого двигателя не приводит к сбросу информации о наведении. Ручное перемещение отключенного шагового двигателя может привести к тому, что машина будет работать с двигателем вне безопасных пределов. Это может привести к повреждению компонентов оси, горячих концов и поверхности печати.

### [temperature_fan]

Следующая команда доступна, если включен раздел [temperature_fan config](Config_Reference.md#temperature_fan).

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<имя_температурного_вентилятора> [target=<target_temperature>] [min_speed=<min_speed>] [max_speed=<max_speed>]`: Устанавливает целевую температуру для вентилятора temperature_fan. Если целевая температура не указана, она устанавливается на указанную температуру в файле конфигурации. Если скорость не указана, изменения не применяются.

### [temperature_probe]

Следующие команды доступны, если включен раздел [temperature_probe config](Config_Reference.md#temperature_probe).

#### TEMPERATURE_PROBE_CALIBRATE

`TEMPERATURE_PROBE_CALIBRATE [PROBE=<имя зонда>] [TARGET=<значение>] [STEP=<значение>]`: Запускает калибровку дрейфа зонда для зондов на основе вихревых токов. Параметр `TARGET` - это целевая температура для последнего образца. Когда температура, зарегистрированная во время пробы, превысит `TARGET`, калибровка будет завершена. Параметр `STEP` задает дельту температуры (в C) между пробами. После взятия пробы эта дельта используется для планирования вызова `TEMPERATURE_PROBE_NEXT`. По умолчанию `STEP` равен 2.

#### TEMPERATURE_PROBE_NEXT

`TEMPERATURE_PROBE_NEXT`: После начала калибровки эта команда запускается для взятия следующего образца. Она автоматически запланирована на выполнение при достижении дельты, указанной в `STEP`, однако ее можно выполнить и вручную, чтобы заставить взять новый образец. Эта команда доступна только во время калибровки.

#### TEMPERATURE_PROBE_COMPLETE:

`TEMPERATURE_PROBE_COMPLETE`: Может использоваться для завершения калибровки и сохранения текущего результата до достижения температуры `TARGET`. Эта команда доступна только во время калибровки.

#### ПРЕРВАТЬ

`ABORT`: Прерывает процесс калибровки, отменяя текущие результаты. Эта команда доступна только во время калибровки дрейфа.

### TEMPERATURE_PROBE_ENABLE

`TEMPERATURE_PROBE_ENABLE ENABLE=[0|1]`: Устанавливает включение или выключение компенсации температурного дрейфа. Если ENABLE установлен в 0, компенсация дрейфа будет отключена, если установлен в 1 - включена.

### [tmcXXXX]

Следующие команды доступны, если включен любой из разделов [tmcXXXX config](Config_Reference.md#tmc-stepper-driver-configuration).

#### DUMP_TMC

`DUMP_TMC STEPPER=<имя> [REGISTER=<имя>]`: Эта команда считывает все регистры драйвера TMC и сообщает их значения. Если указан REGISTER, то в дамп попадет только указанный регистр.

#### INIT_TMC

`INIT_TMC STEPPER=<имя>`: Эта команда инициализирует регистры TMC. Необходима для повторного включения драйвера, если питание микросхемы отключается, а затем снова включается.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<имя> CURRENT=<амперы> HOLDCURRENT=<амперы>`: Это настроит токи запуска и удержания драйвера TMC. `HOLDCURRENT` не применяется к драйверам tmc2660. При использовании драйвера с полем `globalscaler` (tmc5160 и tmc2240), если используется StealthChop2, шаговик должен быть остановлен в течение >130 мс, чтобы драйвер выполнил калибровку AT#1.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<имя> FIELD=<поле> VALUE=<значение> VELOCITY=<значение>`: Эта команда изменит значение указанного поля регистра драйвера TMC. Эта команда предназначена только для низкоуровневой диагностики и отладки, поскольку изменение полей во время выполнения может привести к нежелательному и потенциально опасному поведению вашего принтера. Для внесения постоянных изменений следует использовать файл конфигурации принтера. Никаких проверок на вменяемость для заданных значений не производится. Вместо VALUE можно также указать VELOCITY. Эта скорость преобразуется в 20-битное представление значений на основе TSTEP. Используйте аргумент VELOCITY только для полей, представляющих скорости.

### [головка инструмента]

Модуль инструментальной головки загружается автоматически.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [MINIMUM_CRUISE_RATIO=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: Эта команда может изменить ограничения скорости, указанные в файле конфигурации принтера. Описание каждого параметра см. в разделе [Конфигурация принтера](Config_Reference.md#printer).

### [tuning_tower]

Модуль tuning_tower загружается автоматически.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<command> PARAMETER=<name> START=<value> [SKIP=<value>] [FACTOR=<value> [BAND=<value>]] | [STEP_DELTA=<value> STEP_HEIGHT=<value>]`: Инструмент для настройки параметра на каждой высоте Z во время печати. Инструмент выполнит заданную `КОМАНДУ` с заданным `ПАРАМЕТРОМ`, которому присвоено значение, изменяющееся с `Z` в соответствии с формулой. Используйте `FACTOR`, если вы будете использовать линейку или штангенциркуль для измерения высоты Z оптимального значения, или `STEP_DELTA` и `STEP_HEIGHT`, если модель настроечной башни имеет диапазоны дискретных значений, как это часто бывает с температурными башнями. Если указано `SKIP=<значение>`, процесс настройки не начнется до тех пор, пока не будет достигнута высота Z `<значение>`, а ниже этого значения будет установлено значение `START`; в этом случае `z_height`, используемое в формулах ниже, фактически равно `max(z - skip, 0)`. Существует три возможных комбинации опций:

- `ФАКТОР`: Значение изменяется со скоростью `фактор` на миллиметр. Используется следующая формула: `значение = старт + фактор * z_высота`. Вы можете подставить оптимальную высоту Z непосредственно в формулу, чтобы определить оптимальное значение параметра.
- `ФАКТОР` и `ПОЛОСА`: Значение изменяется со средней скоростью `фактор` на миллиметр, но в дискретных диапазонах, где корректировка будет производиться только через каждые `BAND` миллиметров высоты Z. Используется следующая формула: `value = start + factor * ((floor(z_height / band) + .5) * band)`.
- `STEP_DELTA` и `STEP_HEIGHT`: Значение изменяется на `STEP_DELTA` каждые `STEP_HEIGHT` миллиметров. Используется следующая формула: `value = start + step_delta * floor(z_height / step_height)`. Чтобы определить оптимальное значение, можно просто посчитать диапазоны или прочитать метки настроечных башен.

### [virtual_sdcard]

Klipper поддерживает следующие стандартные команды G-Code, если включен раздел [virtual_sdcard config](Config_Reference.md#virtual_sdcard):

- Список SD-карт: `M20`
- Инициализация SD-карты: `M21`
- Выбрать SD файл: `M23 <filename>`
- Запуск/возобновление печати на SD: `M24`
- Приостановите печать SD: `M25`
- Установить положение SD: `M26 S<смещение>`
- Сообщить о состоянии печати SD: `M27`

Кроме того, следующие расширенные команды доступны, если включен раздел конфигурации "virtual_sdcard".

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<filename>`: Загрузка файла и запуск SD-печати.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`: Выгружает файл и очищает состояние SD.

### [z_thermal_adjust]

Следующие команды доступны, если включен раздел [z_thermal_adjust config](Config_Reference.md#z_thermal_adjust).

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<значение>] [REF_TEMP=<значение>]`: Включите или отключите терморегулировку Z с помощью `ENABLE`. Отключение не удаляет уже примененную регулировку, но замораживает текущее значение регулировки - это предотвращает потенциально опасное движение вниз по Z. Повторное включение может привести к перемещению инструмента вверх при обновлении и применении регулировки. `TEMP_COEFF` позволяет настраивать температурный коэффициент регулировки (т.е. параметр конфигурации `TEMP_COEFF`). Значения `TEMP_COEFF` не сохраняются в конфигурации. `REF_TEMP` вручную переопределяет эталонную температуру, обычно устанавливаемую при наведении (для использования, например, в нестандартных процедурах наведения) - автоматически сбрасывается при наведении.

### [z_tilt]

Следующие команды доступны, если включен раздел [z_tilt config](Config_Reference.md#z_tilt).

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `RETRIES`, `RETRY_TOLERANCE`, and `HORIZONTAL_MOVE_Z` values override those options specified in the config file.
