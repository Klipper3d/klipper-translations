# G-Codes

Този документ описва командите, които Klipper поддържа. Това са команди, които могат да се въведат в терминалния раздел на OctoPrint.

## Команди G-Code

Klipper поддържа следните стандартни команди на G-Code:

- Move (G0 or G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- Dwell: `G4 P<milliseconds>`
- Преместване към произхода: `G28 [X] [Y] [Z]`
- Turn off motors: `M18` or `M84`
- Wait for current moves to finish: `M400`
- Use absolute/relative distances for extrusion: `M82`, `M83`
- Use absolute/relative coordinates: `G90`, `G91`
- Set position: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- Set speed factor override percentage: `M220 S<percent>`
- Set extrude factor override percentage: `M221 S<percent>`
- Задаване на ускорение: `M204 S<стойност>` ИЛИ `M204 P<стойност> T<стойност>`
   - Забележка: Ако не е посочено S и са посочени P и T, ускорението се задава на минимума от P и T. Ако е посочено само едно от P или T, командата няма ефект.
- Получаване на температурата на екструдера: `M105`
- Set extruder temperature: `M104 [T<index>] [S<temperature>]`
- Set extruder temperature and wait: `M109 [T<index>] S<temperature>`
   - Забележка: M109 винаги изчаква температурата да се установи на заявената стойност.
- Задаване на температура на леглото: `M140 [S<temperature>]`
- Задайте температурата на леглото и изчакайте: `M190 S<температура>`
   - Забележка: M190 винаги изчаква температурата да се установи на заявената стойност.
- Set fan speed: `M106 S<value>`
- Turn fan off: `M107`
- Emergency stop: `M112`
- Получаване на текущата позиция: `M114`
- Получаване на версия на фърмуера: `M115`

За повече подробности относно горните команди вижте [Документация на RepRap G-Code](http://reprap.org/wiki/G-code).

Целта на Klipper е да поддържа командите G-Code, създавани от общия софтуер на трети страни (например OctoPrint, Printrun, Slic3r, Cura и т.н.) в техните стандартни конфигурации. Целта не е да се поддържат всички възможни G-Code команди. Вместо това Klipper предпочита четими от човека ["разширени G-Code команди"](#additional-commands). Аналогично, изходът на G-Code терминала е предназначен само за четене от човек - вижте документа [API Server](API_Server.md), ако управлявате Klipper от външен софтуер.

Ако е необходима по-рядко срещана команда на G-Code, може да е възможно тя да бъде реализирана с потребителски раздел [gcode_macro config](Config_Reference.md#gcode_macro). Например това може да се използва за реализиране на: `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1` и т.н.

## Допълнителни команди

Klipper използва "разширени" G-Code команди за обща конфигурация и състояние. Всички тези разширени команди следват подобен формат - започват с името на командата и могат да бъдат последвани от един или повече параметри. Например: `SET_SERVO SERVO=myservo ANGLE=5,3`. В този документ командите и параметрите са показани с главни букви, но те не са чувствителни към големи и малки букви. (Така че "SET_SERVO" и "set_servo" изпълняват една и съща команда.)

This section is organized by Klipper module name, which generally follows the section names specified in the [printer configuration file](Config_Reference.md). Note that some modules are automatically loaded.

### [adxl345]

The following commands are available when an [adxl345 config section](Config_Reference.md#adxl345) is enabled.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: Стартира измервания на акселерометъра със заявения брой проби в секунда. Ако не е зададен CHIP, по подразбиране се задава "adxl345". Командата работи в режим старт-стоп: когато се изпълни за първи път, тя стартира измерванията, а следващото изпълнение ги спира. Резултатите от измерванията се записват във файл с име `/tmp/adxl345-<chip>-<name>.csv`, където `<chip>` е името на чипа на акселерометъра (`my_chip_name` от `[adxl345 my_chip_name]`), а `<name>` е незадължителният параметър NAME. Ако не е посочено NAME, по подразбиране се задава текущото време във формат "YYYYMMDD_HHMMSS". Ако акселерометърът няма име в секцията си за конфигуриране (просто `[adxl345]`), частта от името `<chip>` не се генерира.

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: запитва акселерометъра за текущата стойност. Ако не е зададен CHIP, по подразбиране се задава "adxl345". Ако не е зададена RATE, се използва стойността по подразбиране. Тази команда е полезна за тестване на връзката с акселерометъра ADXL345: една от върнатите стойности трябва да бъде ускорение при свободно падане (+/- известен шум на чипа).

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`: запитва регистъра ADXL345 за "регистър" (напр. 44 или 0x2C). Може да бъде полезно за целите на отстраняване на грешки.

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<register> VAL=<value>`: Записва необработена "стойност" в регистър "register". И "value", и "register" могат да бъдат десетични или шестнадесетични цели числа. Използвайте ги внимателно и направете справка в информационния лист на ADXL345.

### [ъгъл]

The following commands are available when an [angle config section](Config_Reference.md#angle) is enabled.

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<chip_name>`: Извършва калибриране на ъгъла на дадения сензор (трябва да има конфигурационен раздел `[име на чип за ъгъла]`, в който е зададен параметър `степер`). ВАЖНО - този инструмент ще даде команда на стъпковия двигател да се движи, без да проверява нормалните кинематични гранични стойности. В идеалния случай двигателят трябва да бъде изключен от всяка каретка на принтера, преди да се извърши калибриране. Ако стъпковият двигател не може да бъде изключен от принтера, уверете се, че каретата е близо до центъра на релсата си, преди да започнете калибрирането. (По време на този тест стъпковият двигател може да се придвижи напред или назад с две пълни завъртания.) След приключване на този тест използвайте командата `SAVE_CONFIG`, за да запишете данните от калибрирането в конфигурационния файл. За да използвате този инструмент, трябва да бъде инсталиран пакетът Python "numpy" (за повече информация вижте документа [измерване на резонанси](Measuring_Resonances.md#software-installation)).

#### ANGLE_CHIP_CALIBRATE

`ANGLE_CHIP_CALIBRATE CHIP=<chip_name>`: Perform internal sensor calibration, if implemented (MT6826S/MT6835).

- **MT68XX**: The motor should be disconnected from any printer carriage before performing calibration. After calibration, the sensor should be reset by disconnecting the power.

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: Запитва "регистъра" на сензора (напр. 44 или 0x2C). Може да бъде полезно за целите на отстраняване на грешки. Това е налично само за чипове tle5012b.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: Записва необработена "стойност" в регистър "регистър". Както "value", така и "register" могат да бъдат десетични или шестнадесетични цели числа. Използвайте ги внимателно и направете справка в информационния лист на сензора. Това е налично само за чипове tle5012b.

### [axis_twist_compensation]

The following commands are available when the [axis_twist_compensation config
section](Config_Reference.md#axis_twist_compensation) is enabled.

#### AXIS_TWIST_COMPENSATION_CALIBRATE

`AXIS_TWIST_COMPENSATION_CALIBRATE [AXIS=<X|Y>] [SAMPLE_COUNT=<value>]`

Calibrates axis twist compensation by specifying the target axis or enabling automatic calibration.

- **AXIS:** Define the axis (`X` or `Y`) for which the twist compensation will be calibrated. If not specified, the axis defaults to `'X'`.

### [bed_mesh]

The following commands are available when the [bed_mesh config section](Config_Reference.md#bed_mesh) is enabled (also see the [bed mesh guide](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [PROFILE=<name>] [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=1] [ADAPTIVE_MARGIN=<value>]`: This command probes the bed using generated points specified by the parameters in the config. After probing, a mesh is generated and z-movement is adjusted according to the mesh. The mesh is immediately active after successful completion of `BED_MESH_CALIBRATE`. The mesh will be saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. If ADAPTIVE=1 is specified then the profile name will begin with `adaptive-` and should not be saved for reuse. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file. If ADAPTIVE=1 is specified then the objects defined by the Gcode file being printed will be used to define the probed area. The optional `ADAPTIVE_MARGIN` value overrides the `adaptive_margin` option specified in the config file.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`: Тази команда извежда на терминала текущите стойности на сондата z и текущите стойности на мрежата. Ако е зададено PGP=1, на терминала ще бъдат изведени координатите X, Y, генерирани от bed_mesh, заедно със съответните им индекси.

#### BED_MESH_MAP

`BED_MESH_MAP`: Подобно на BED_MESH_OUTPUT, тази команда отпечатва текущото състояние на мрежата на терминала. Вместо да се отпечатват стойностите в разбираем за човека формат, състоянието се сериализира в json формат. Това позволява на плъгините на octoprint лесно да улавят данните и да генерират карти на височината, приближаващи повърхността на леглото.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: Тази команда изчиства мрежата и премахва всички z корекции. Препоръчително е да я поставите в крайния си код.

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<име> SAVE=<име> REMOVE=<име>`: Тази команда осигурява управление на профила за състоянието на мрежата. LOAD ще възстанови състоянието на мрежата от профила, отговарящ на въведеното име. SAVE (Запазване) ще запази текущото състояние на мрежата в профил, отговарящ на предоставеното име. Remove (Премахване) ще изтрие профила, отговарящ на въведеното име, от постоянната памет. Имайте предвид, че след изпълнение на операциите SAVE (Запазване) или REMOVE (Премахване) трябва да се изпълни gcode SAVE_CONFIG (Запазване на конфигурацията), за да станат промените в постоянната памет постоянни.

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<стойност>] [Y=<стойност>] [ZFADE=<стойност]`: Прилага отмествания X, Y и/или ZFADE към търсенето на мрежата. Това е полезно за принтери с независими екструдери, тъй като е необходимо отместване, за да се получи правилна Z настройка след смяна на инструмента. Обърнете внимание, че отместването на ZFADE не прилага директно допълнителна Z-корекция, а се използва за коригиране на изчислението на `затихването`, когато към оста Z е приложено отместване на `gcode`.

### [винтове за легло]

The following commands are available when the [bed_screws config section](Config_Reference.md#bed_screws) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`: Тази команда ще задейства инструмента за регулиране на винтовете на леглото. Той ще командва дюзата на различни места (както е определено във файла за конфигуриране) и ще позволи да се направят настройки на винтовете на леглото, така че леглото да е на постоянно разстояние от дюзата.

### [bed_tilt]

The following commands are available when the [bed_tilt config section](Config_Reference.md#bed_tilt) is enabled.

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Тази команда ще сондира точките, посочени в конфигурацията, и след това ще препоръча актуализирани настройки на наклона x и y. За подробности относно незадължителните параметри на сондата вижте командата PROBE. Ако е зададено METHOD=manual, се активира инструментът за ръчно сондиране - вижте командата MANUAL_PROBE по-горе за подробности относно допълнителните команди, налични, когато този инструмент е активен. Незадължителната стойност `HORIZONTAL_MOVE_Z` отменя опцията `horizontal_move_z`, зададена в конфигурационния файл.

### [bltouch]

The following command is available when a [bltouch config section](Config_Reference.md#bltouch) is enabled (also see the [BL-Touch guide](BLTouch.md)).

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<command>`: Изпраща команда към BLTouch. Тя може да бъде полезна за отстраняване на грешки. Наличните команди са: `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`. BL-Touch V3.0 или V3.1 може също да поддържа командите `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store`.

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`: Това запаметява изходен режим в EEPROM на BLTouch V3.1 Наличните output_modes са: `5V`, `OD`

### [configfile]

The configfile module is automatically loaded.

#### SAVE_CONFIG

`SAVE_CONFIG`: Тази команда ще презапише основния конфигурационен файл на принтера и ще рестартира хост софтуера. Тази команда се използва заедно с други команди за калибриране, за да се съхранят резултатите от тестовете за калибриране.

### [отложен_gcode]

The following command is enabled if a [delayed_gcode config section](Config_Reference.md#delayed_gcode) has been enabled (also see the [template guide](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: Updates the delay duration for the identified [delayed_gcode] and starts the timer for gcode execution. A value of 0 will cancel a pending delayed gcode from executing.

### [delta_calibrate]

The following commands are available when the [delta_calibrate config section](Config_Reference.md#linear-delta-kinematics) is enabled (also see the [delta calibrate guide](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_ANALYZE`: Тази команда се използва по време на подобрено делта калибриране. За подробности вижте [Delta Calibrate](Delta_Calibrate.md).

#### DELTA_ANALYZE

`DELTA_ANALYZE`: Тази команда се използва по време на подобрено делта калибриране. За подробности вижте [Delta Calibrate](Delta_Calibrate.md).

### [дисплей]

The following command is available when a [display config section](Config_Reference.md#gcode_macro) is enabled.

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`: Set the active display group of an lcd display. This allows to define multiple display data groups in the config, e.g. `[display_data <group> <elementname>]` and switch between them using this extended gcode command. If DISPLAY is not specified it defaults to "display" (the primary display).

### [display_status]

The display_status module is automatically loaded if a [display config section](Config_Reference.md#display) is enabled. It provides the following standard G-Code commands:

- Display Message: `M117 <message>`
- Задаване на процент на изграждане: `M73 P<percent>`

Предоставена е и следната разширена команда G-Code:

- `SET_DISPLAY_TEXT MSG=<message>`: Performs the equivalent of M117, setting the supplied `MSG` as the current display message. If `MSG` is omitted the display will be cleared.

### [двойна_каретка]

The following command is available when the [dual_carriage config section](Config_Reference.md#dual_carriage) is enabled.

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=<carriage> [MODE=[PRIMARY|COPY|MIRROR]]`: This command will change the mode of the specified carriage. If no `MODE` is provided it defaults to `PRIMARY`. `<carriage>` must reference a defined primary or dual carriage for `generic_cartesian` kinematics or be 0 (for primary carriage) or 1 (for dual carriage) for all other kinematics supporting IDEX. Setting the mode to `PRIMARY` deactivates the other carriage and makes the specified carriage execute subsequent G-Code commands as-is. `COPY` and `MIRROR` modes are supported only for dual carriages. When set to either of these modes, dual carriage will then track the subsequent moves of its primary carriage and either copy relative movements of it (in `COPY` mode) or execute them in the opposite (mirror) direction (in `MIRROR` mode).

#### SAVE_DUAL_CARRIAGE_STATE

`SAVE_DUAL_CARRIAGE_STATE [NAME=<state_name>]`: Записва текущите позиции на двойните вагони и техните режими. Запаметяването и възстановяването на състоянието на DUAL_CARRIAGE може да бъде полезно в скриптове и макроси, както и при пренасочване на рутинни процедури за насочване. Ако е предоставено ИМЕ, това позволява да се даде име на запаметеното състояние в дадения низ. Ако не е предоставено NAME, по подразбиране е "default" (по подразбиране).

#### RESTORE_DUAL_CARRIAGE_STATE

`RESTORE_DUAL_CARRIAGE_STATE [NAME=<state_name>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: Възстановява запаметените преди това позиции на двойните колички и техните режими, освен ако не е зададено "MOVE=0", в който случай ще бъдат възстановени само запаметените режими, но не и позициите на количките. Ако се възстановяват позиции и е зададено "MOVE_SPEED", тогава преместването на инструменталната глава ще се извърши със зададената скорост (в mm/s); в противен случай преместването на инструменталната глава ще използва скоростта на релсовото самонасочване. Обърнете внимание, че вагончетата възстановяват позициите си само по собствената си ос, което може да е необходимо за правилното възстановяване на режимите COPY и MIRROR на двойното вагонче.

### [endstop_phase]

The following commands are available when an [endstop_phase config section](Config_Reference.md#endstop_phase) is enabled (also see the [endstop phase guide](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]`: Ако не е зададен параметър STEPPER, тази команда ще отчете статистически данни за фазите на стъпковия механизъм за крайно спиране по време на минали операции по самонасочване. Когато е зададен параметър STEPPER, тя организира записването на дадената настройка на фазата на крайния стоп в конфигурационния файл (във връзка с командата SAVE_CONFIG).

### [exclude_object]

The following commands are available when an [exclude_object config section](Config_Reference.md#exclude_object) is enabled (also see the [exclude object guide](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=object_name] [CURRENT=1] [RESET=1]`: Без параметри тази опция ще върне списък с всички изключени в момента обекти.

When the `NAME` parameter is given, the named object will be excluded from printing.

When the `CURRENT` parameter is given, the current object will be excluded from printing.

When the `RESET` parameter is given, the list of excluded objects will be cleared. Additionally including `NAME` will only reset the named object. This **can** cause print failures, if layers were already skipped.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=име_обекта [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`: Предоставя резюме на даден обект във файла.

With no parameters provided, this will list the defined objects known to Klipper. Returns a list of strings, unless the `JSON` parameter is given, when it will return object details in json format.

When the `NAME` parameter is included, this defines an object to be excluded.

- `NAME`: Този параметър е задължителен. Той е идентификаторът, използван от други команди в този модул.
- `CENTER`: Координати X,Y за обекта.
- `POLYGON`: Масив от координати X,Y, които осигуряват контур на обекта.

When the `RESET` parameter is provided, all defined objects will be cleared, and the `[exclude_object]` module will be reset.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=object_name`: Тази команда приема параметър `NAME` и обозначава началото на gcode за даден обект на текущия слой.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=object_name]`: Обозначава края на gcode на обекта за слоя. Съчетава се с `EXCLUDE_OBJECT_START`. Параметърът `NAME` не е задължителен и ще предупреждава само когато предоставеното име не съвпада с текущия обект.

### [extruder]

The following commands are available if an [extruder config section](Config_Reference.md#extruder) is enabled:

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: В принтер с няколко конфигурационни секции [extruder](Config_Reference.md#extruder) тази команда променя активния горещ модул.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Set pressure advance parameters of an extruder stepper (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section). If EXTRUDER is not specified, it defaults to the stepper defined in the active hotend.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: Set a new value for the provided extruder stepper's "rotation distance" (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section). If the rotation distance is a negative number then the stepper motion will be inverted (relative to the stepper direction specified in the config file). Changed settings are not retained on Klipper reset. Use with caution as small changes can result in excessive pressure between extruder and hotend. Do proper calibration with filament before use. If 'DISTANCE' value is not provided then this command will return the current rotation distance.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<name> MOTION_QUEUE=<name>`: This command will cause the stepper specified by EXTRUDER (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section) to become synchronized to the movement of an extruder specified by MOTION_QUEUE (as defined in an [extruder](Config_Reference.md#extruder) config section). If MOTION_QUEUE is an empty string then the stepper will be desynchronized from all extruder movement.

### [fan_generic]

The following command is available when a [fan_generic config section](Config_Reference.md#fan_generic) is enabled.

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<speed>` This command sets the speed of a fan. "speed" must be between 0.0 and 1.0.

`SET_FAN_SPEED PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given fan. For example, if one defined a `[display_template my_fan_template]` config section then one could assign `TEMPLATE=my_fan_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the fan will be automatically set to the resulting speed. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_FAN_SPEED` commands to manage the values directly).

### [filament_switch_sensor]

The following command is available when a [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) or [filament_motion_sensor](Config_Reference.md#filament_motion_sensor) config section is enabled.

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`: Запитва за текущото състояние на сензора за нишки. Данните, които се показват на терминала, зависят от типа на сензора, дефиниран в конфигурацията.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]`: Sets the filament sensor on/off. If ENABLE is set to 0, the filament sensor will be disabled, if set to 1 it is enabled.

### [firmware_retraction]

The following standard G-Code commands are available when the [firmware_retraction config section](Config_Reference.md#firmware_retraction) is enabled. These commands allow you to utilize the firmware retraction feature available in many slicers, to reduce stringing during non-extrusion moves from one part of the print to another. Appropriately configuring pressure advance reduces the length of retraction required.

- `G10`: Изтегля екструдера, като използва текущо конфигурираните параметри.
- `G11`: Развързва екструдера, като използва конфигурираните в момента параметри.

The following additional commands are also available.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>]`: Adjust the parameters used by firmware retraction. RETRACT_LENGTH determines the length of filament to retract and unretract. The speed of retraction is adjusted via RETRACT_SPEED, and is typically set relatively high. The speed of unretraction is adjusted via UNRETRACT_SPEED, and is not particularly critical, although often lower than RETRACT_SPEED. In some cases it is useful to add a small amount of additional length on unretraction, and this is set via UNRETRACT_EXTRA_LENGTH. SET_RETRACTION is commonly set as part of slicer per-filament configuration, as different filaments require different parameter settings.

#### GET_RETRACTION

`GET_RETRACTION`: Запитва за текущите параметри, използвани от привличането на фърмуера, и ги показва на терминала.

### [force_move]

The force_move module is automatically loaded, however some commands require setting `enable_force_move` in the [printer config](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<config_name>`: Move the given stepper forward one mm and then backward one mm, repeated 10 times. This is a diagnostic tool to help verify stepper connectivity.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]`: Тази команда ще премести принудително дадения стъпков механизъм на зададеното разстояние (в mm) с дадената постоянна скорост (в mm/s). Ако е зададено ACCEL и е по-голямо от нула, ще се използва даденото ускорение (в mm/s^2); в противен случай не се извършва ускорение. Не се извършват гранични проверки; не се извършват кинематични актуализации; други паралелни степери по дадена ос няма да бъдат преместени. Бъдете внимателни, тъй като неправилната команда може да причини повреда! Използването на тази команда почти сигурно ще постави кинематиката на ниско ниво в неправилно състояние; издайте G28 след това, за да нулирате кинематиката. Тази команда е предназначена за диагностика на ниско ниво и отстраняване на грешки.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] [SET_HOMED=<[X][Y][Z]>] [CLEAR_HOMED=<[X][Y][Z]>]`: Force the low-level kinematic code to believe the toolhead is at the given cartesian position and set/clear homed status. This is a diagnostic and debugging command; use SET_GCODE_OFFSET and/or G92 for regular axis transformations. Setting an incorrect or invalid position may lead to internal software errors.

The `X`, `Y`, and `Z` parameters are used to alter the low-level kinematic position tracking. If any of these parameters are not set then the position is not changed - for example `SET_KINEMATIC_POSITION Z=10` would set all axes as homed, set the internal Z position to 10, and leave the X and Y positions unchanged. Changing the internal position tracking is not dependent on the internal homing state - one may alter the position for both homed and not homed axes, and similarly one may set or clear the homing state of an axis without altering its internal position.

The `SET_HOMED` parameter defaults to `XYZ` which instructs the kinematics to consider all axes as homed. A bare `SET_KINEMATIC_POSITION` command will result in all axes being considered homed (and not change its current position). If it is not desired to change the state of homed axes then assign `SET_HOMED` to an empty string - for example: `SET_KINEMATIC_POSITION SET_HOMED= X=10`. It is also possible to request an individual axis be considered homed (eg, `SET_HOMED=X`), but note that non-cartesian style kinematics (such as delta kinematics) may not support setting an individual axis as homed.

The `CLEAR_HOMED` parameter instructs the kinematics to consider the given axes as not homed. For example, `CLEAR_HOMED=XYZ` would request all axes to be considered not homed (and thus require homing prior to movement on those axes). The default is `SET_HOMED=XYZ` even if `CLEAR_HOMED` is present, so the command `SET_KINEMATIC_POSITION CLEAR_HOMED=Z` will set X and Y as homed and clear the homing state for Z. Use `SET_KINEMATIC_POSITION SET_HOMED= CLEAR_HOMED=Z` if the goal is to clear only the Z homing state. If an axis is specified in neither `SET_HOMED` nor `CLEAR_HOMED` then its homing state is not changed and if it is specified in both then `CLEAR_HOMED` has precedence. It is possible to request clearing of an individual axis, but on non-cartesian style kinematics (such as delta kinematics) doing so may result in clearing the homing state of additional axes. Note the `CLEAR` parameter is currently an alias for the `CLEAR_HOMED` parameter, but this alias will be removed in the future.

### [gcode]

The gcode module is automatically loaded.

#### RESTART

`RESTART`: Това ще накара хост софтуера да презареди конфигурацията си и да извърши вътрешно нулиране. Тази команда няма да изчисти състоянието на грешка от микроконтролера (вж. FIRMWARE_RESTART), нито ще зареди нов софтуер (вж. [често задавани въпроси](FAQ.md#how-do-i-upgrade-to-the-latest-software)).

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`: Това е подобно на командата RESTART, но също така изчиства състоянието на грешки от микроконтролера.

#### STATUS

`STATUS`: Report the Klipper host software status.

#### ПОМОЩ

`HELP`: Отчита списъка на наличните разширени команди на G-Code.

### [gcode_arcs]

The following standard G-Code commands are available if a [gcode_arcs config section](Config_Reference.md#gcode_arcs) is enabled:

- Arc Move Clockwise (G2), Arc Move Counter-clockwise (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`
- Избор на равнина на дъгата: G17 (равнина XY), G18 (равнина XZ), G19 (равнина YZ)

### [gcode_macro]

The following command is available when a [gcode_macro config section](Config_Reference.md#gcode_macro) is enabled (also see the [command templates guide](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`: This command allows one to change the value of a gcode_macro variable at run-time. The provided VALUE is parsed as a Python literal.

### [gcode_move]

The gcode_move module is automatically loaded.

#### GET_POSITION

`GET_POSITION`: Връща информация за текущото местоположение на главата на инструмента. За повече информация вижте документацията за разработчици на [GET_POSITION output](Code_Overview.md#coordinate-systems).

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Set a positional offset to apply to future G-Code commands. This is commonly used to virtually change the Z bed offset or to set nozzle XY offsets when switching extruders. For example, if "SET_GCODE_OFFSET Z=0.2" is sent, then future G-Code moves will have 0.2mm added to their Z height. If the X_ADJUST style parameters are used, then the adjustment will be added to any existing offset (eg, "SET_GCODE_OFFSET Z=-0.2" followed by "SET_GCODE_OFFSET Z_ADJUST=0.3" would result in a total Z offset of 0.1). If "MOVE=1" is specified then a toolhead move will be issued to apply the given offset (otherwise the offset will take effect on the next absolute G-Code move that specifies the given axis). If "MOVE_SPEED" is specified then the toolhead move will be performed with the given speed (in mm/s); otherwise the toolhead move will use the last specified G-Code speed.

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<state_name>]`: Запазване на текущото състояние на обработката на координатите на g-кода. Запазването и възстановяването на състоянието на g-кода е полезно в скриптове и макроси. Тази команда запазва текущия режим на абсолютните координати на g-кода (G90/G91), абсолютния режим на екструдиране (M82/M83), произхода (G92), отместването (SET_GCODE_OFFSET), отмяната на скоростта (M220), отмяната на екструдера (M221), скоростта на движение, текущата позиция XYZ и относителната позиция на екструдера "E". Ако е предоставено NAME (Име), това позволява да се даде име на запаметеното състояние в дадения низ. Ако не е предоставено NAME, по подразбиране е "default" (по подразбиране).

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Възстановяване на състояние, записано преди това чрез SAVE_GCODE_STATE. Ако е зададено "MOVE=1", ще бъде издадено движение на главата на инструмента, за да се върне в предишната позиция XYZ. Ако е зададено "MOVE_SPEED", тогава преместването на главата на инструмента ще се извърши със зададената скорост (в mm/s); в противен случай преместването на главата на инструмента ще използва възстановената скорост на g-кода.

### [generic_cartesian]

The commands in this section become automatically available when `kinematics: generic_cartesian` is specified as the printer kinematics.

#### SET_STEPPER_CARRIAGES

`SET_STEPPER_CARRIAGES STEPPER=<stepper_name> CARRIAGES=<carriages> [DISABLE_CHECKS=[0|1]]`: Set or update the stepper carriages. `<stepper_name>` must reference an existing stepper defined in `printer.cfg`, and `<carriages>` describes the carriages the stepper moves. See [Generic Cartesian Kinematics](Config_Reference.md#generic-cartesian-kinematics) for a more detailed overview of the `carriages` parameter in the stepper configuration section. Note that it is only possible to change the coefficients or signs of the carriages with this command, but a user cannot add or remove the carriages that the stepper controls.

`SET_STEPPER_CARRIAGES` is an advanced tool, and the user is advised to exercise an extreme caution using it, since specifying incorrect configuration may physically damage the printer.

Note that `SET_STEPPER_CARRIAGES` performs certain internal validations of the new printer kinematics after the change. Keep in mind that if it detects an issue, it may leave printer kinematics in an invalid state. This means that if `SET_STEPPER_CARRIAGES` reports an error, it is unsafe to issue other GCode commands, and the user must inspect the error message and either fix the problem, or manually restore the previous stepper(s) configuration.

Since `SET_STEPPER_CARRIAGES` can update a configuration of a single stepper at a time, some sequences of changes can lead to invalid intermediate kinematic configurations, even if the final configuration is valid. In such cases a user can pass `DISABLE_CHECKS=1` parameters to all but the last command to disable intermediate checks. For example, if `stepper a` and `stepper b` initially have `x-y` and `x+y` carriages correspondingly, then the following sequence of commands will let a user effectively swap the carriage controls: `SET_STEPPER_CARRIAGES STEPPER=a CARRIAGES=x+y DISABLE_CHECKS=1` and `SET_STEPPER_CARRIAGES STEPPER=b CARRIAGES=x-y`, while still validating the final kinematics state.

### [сензор_за_широчина_на_нишката_на_хол]

The following commands are available when the [tsl1401cl filament width sensor config section](Config_Reference.md#tsl1401cl_filament_width_sensor) or [hall filament width sensor config section](Config_Reference.md#hall_filament_width_sensor) is enabled (also see [TSLl401CL Filament Width Sensor](TSL1401CL_Filament_Width_Sensor.md) and [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)):

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`: Връща текущата измерена ширина на нишката.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`: Изчистване на всички показания на сензора. Полезно след смяна на нишката.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`: Изключете сензора за широчина на нишката и спрете да го използвате за контрол на потока.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR`: Включете сензора за широчина на нишката и започнете да го използвате за контрол на потока.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`: Върнете текущите показания на ADC канала и RAW стойността на сензора за точките на калибриране.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`: Включва регистрирането на диаметъра.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`: Изключва регистрирането на диаметъра.

### [heaters]

The heaters module is automatically loaded if a heater is defined in the config file.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`: Turn off all heaters.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Wait until the given temperature sensor is at or above the supplied MINIMUM and/or at or below the supplied MAXIMUM.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<heater_name> [TARGET=<target_temperature>]`: Sets the target temperature for a heater. If a target temperature is not supplied, the target is 0.

### [idle_timeout]

The idle_timeout module is automatically loaded.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: Allows the user to set the idle timeout (in seconds).

### [input_shaper]

The following command is enabled if an [input_shaper config section](Config_Reference.md#input_shaper) has been enabled (also see the [resonance compensation guide](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`: Modify input shaper parameters. Note that SHAPER_TYPE parameter resets input shaper for both X and Y axes even if different shaper types have been configured in [input_shaper] section. SHAPER_TYPE cannot be used together with either of SHAPER_TYPE_X and SHAPER_TYPE_Y parameters. See [config reference](Config_Reference.md#input_shaper) for more details on each of these parameters.

### [led]

The following command is available when any of the [led config sections](Config_Reference.md#leds) are enabled.

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: This sets the LED output. Each color `<value>` must be between 0.0 and 1.0. The WHITE option is only valid on RGBW LEDs. If the LED supports multiple chips in a daisy-chain then one may specify INDEX to alter the color of just the given chip (1 for the first chip, 2 for the second, etc.). If INDEX is not provided then all LEDs in the daisy-chain will be set to the provided color. If TRANSMIT=0 is specified then the color change will only be made on the next SET_LED command that does not specify TRANSMIT=0; this may be useful in combination with the INDEX parameter to batch multiple updates in a daisy-chain. By default, the SET_LED command will sync it's changes with other ongoing gcode commands. This can lead to undesirable behavior if LEDs are being set while the printer is not printing as it will reset the idle timeout. If careful timing is not needed, the optional SYNC=0 parameter can be specified to apply the changes without resetting the idle timeout.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: Assign a [display_template](Config_Reference.md#display_template) to a given [LED](Config_Reference.md#leds). For example, if one defined a `[display_template my_led_template]` config section then one could assign `TEMPLATE=my_led_template` here. The display_template should produce a comma separated string containing four floating point numbers corresponding to red, green, blue, and white color settings. The template will be continuously evaluated and the LED will be automatically set to the resulting colors. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If INDEX is not specified then all chips in the LED's daisy-chain will be set to the template, otherwise only the chip with the given index will be updated. If TEMPLATE is an empty string then this command will clear any previous template assigned to the LED (one can then use `SET_LED` commands to manage the LED's color settings).

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

The manual_probe module is automatically loaded.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`: Изпълнява помощен скрипт, полезен за измерване на височината на дюзата на дадено място. Ако е зададена СКОРОСТ, тя задава скоростта на командите TESTZ (по подразбиране е 5 mm/s). По време на ръчна проба са налични следните допълнителни команди:

- `ACCEPT`: Тази команда приема текущата Z-позиция и прекратява работата на инструмента за ръчно сондиране.
- `ABORT`: Тази команда прекратява работата на инструмента за ръчно сондиране.
- `TESTZ Z=<value>`: This command moves the nozzle up or down by the amount specified in "value". For example, `TESTZ Z=-.1` would move the nozzle down .1mm while `TESTZ Z=.1` would move the nozzle up .1mm. The value may also be `+`, `-`, `++`, or `--` to move the nozzle up or down an amount relative to previous attempts.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: Run a helper script useful for calibrating a Z position_endstop config setting. See the MANUAL_PROBE command for details on the parameters and the additional commands available while the tool is active.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`: Take the current Z Gcode offset (aka, babystepping), and subtract it from the stepper_z endstop_position. This acts to take a frequently used babystepping value, and "make it permanent". Requires a `SAVE_CONFIG` to take effect.

### [manual_stepper]

The following command is available when a [manual_stepper config section](Config_Reference.md#manual_stepper) is enabled.

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]]`: Тази команда ще промени състоянието на стъпковия механизъм. Използвайте параметъра ENABLE, за да активирате/деактивирате стъпковия механизъм. Използвайте параметъра SET_POSITION, за да накарате стъпковия механизъм да мисли, че се намира в зададената позиция. Използвайте параметъра MOVE (Преместване), за да заявите преместване до зададената позиция. Ако е зададена скорост и/или ускорение, ще се използват дадените стойности вместо стойностите по подразбиране, зададени в конфигурационния файл. Ако е зададено нулево ACCEL, няма да се извършва ускорение. Ако е зададено STOP_ON_ENDSTOP=1, движението ще завърши по-рано, ако крайният ограничител се отчете като задействан (използвайте STOP_ON_ENDSTOP=2, за да завършите движението без грешка, дори ако крайният ограничител не се задейства, използвайте -1 или -2, за да спрете, когато крайният ограничител не се отчете като задействан). Обикновено бъдещите команди G-Code се планират да се изпълняват след завършване на движението на стъпковия механизъм, но ако при ръчно движение на стъпковия механизъм се използва SYNC=0, бъдещите команди за движение на G-Code могат да се изпълняват паралелно с движението на стъпковия механизъм.

`MANUAL_STEPPER STEPPER=config_name GCODE_AXIS=[A-Z] [LIMIT_VELOCITY=<velocity>] [LIMIT_ACCEL=<accel>] [INSTANTANEOUS_CORNER_VELOCITY=<velocity>]`: If the `GCODE_AXIS` parameter is specified then it configures the stepper motor as an extra axis on `G1` move commands. For example, if one were to issue a `MANUAL_STEPPER ... GCODE_AXIS=R` command then one could issue commands like `G1 X10 Y20 R30` to move the stepper motor. The resulting moves will occur synchronously with the associated toolhead xyz movements. If the motor is associated with a `GCODE_AXIS` then one may no longer issue movements using the above `MANUAL_STEPPER` command - one may unregister the stepper with a `MANUAL_STEPPER ... GCODE_AXIS=` command to resume manual control of the motor. The `LIMIT_VELOCITY` and `LIMIT_ACCEL` parameters allow one to reduce the speed of `G1` moves if those moves would result in a velocity or acceleration above the specified limits. The `INSTANTANEOUS_CORNER_VELOCITY` specifies the maximum instantaneous velocity change (in mm/s) of the motor during the junction of two moves (the default is 1mm/s).

### [mcp4018]

The following command is available when a [mcp4018 config section](Config_Reference.md#mcp4018) is enabled.

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: This command will change the current value of the digipot. This value should typically be between 0.0 and 1.0, unless a 'scale' is defined in the config. When 'scale' is defined, then this value should be between 0.0 and 'scale'.

### [output_pin]

The following command is available when an [output_pin config section](Config_Reference.md#output_pin) is enabled.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value>`: Set the pin to the given output `VALUE`. VALUE should be 0 or 1 for "digital" output pins. For PWM pins, set to a value between 0.0 and 1.0, or between 0.0 and `scale` if a scale is configured in the output_pin config section.

`SET_PIN PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given pin. For example, if one defined a `[display_template my_pin_template]` config section then one could assign `TEMPLATE=my_pin_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the pin will be automatically set to the resulting value. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_PIN` commands to manage the values directly).

### [palette2]

The following commands are available when the [palette2 config section](Config_Reference.md#palette2) is enabled.

Отпечатъците на палитрата работят чрез вграждане на специални OCodes (кодове Omega) във файла GCode:

- `O1`...`O32`: Тези кодове се четат от потока GCode, обработват се от този модул и се предават на устройството Palette 2.

The following additional commands are also available.

#### PALETTE_CONNECT

`PALETTE_CONNECT`: Тази команда инициализира връзката с Palette 2.

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`: Тази команда прекъсва връзката с палитрата 2.

#### PALETTE_CLEAR

```PALETTE_CLEAR`: Тази команда инструктира Palette 2 да изчисти всички входни и изходни трасета от нишки.

#### PALETTE_CUT

`PALETTE_CUT`: Тази команда указва на Палитра 2 да отреже нишката, която в момента е заредена в ядрото за снаждане.

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`: Тази команда стартира последователността на интелигентно зареждане на палитрата 2. Филаментът се зарежда автоматично, като се екструдира на разстоянието, калибрирано в устройството за принтера, и инструктира Palette 2, след като зареждането приключи. Тази команда е същата като натискането на **Smart Load** директно на екрана на Палитра 2, след като зареждането на филамента е приключило.

### [pause_resume]

The following commands are available when the [pause_resume config section](Config_Reference.md#pause_resume) is enabled:

#### PAUSE

`PAUSE`: Спира текущото отпечатване. Текущата позиция се запаметява, за да се възстанови при възобновяване.

#### RESUME

`RESUME [VELOCITY=<value>]`: Възобновява отпечатването от пауза, като първо възстановява предишната заснета позиция. Параметърът VELOCITY определя скоростта, с която инструментът трябва да се върне в първоначално заснетата позиция.

#### CLEAR_PAUSE

`CLEAR_PAUSE`: Изтрива текущото състояние на пауза, без да възобновява печата. Това е полезно, ако решите да отмените печат след ПАУЗА. Препоръчително е да добавите това към стартовия gcode, за да сте сигурни, че състоянието на пауза е ново за всеки печат.

#### CANCEL_PRINT

`CANCEL_PRINT`: Отменя текущия печат.

### [pid_calibrate]

The pid_calibrate module is automatically loaded if a heater is defined in the config file.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`: Извършва тест за калибриране на PID. Определеният нагревател ще бъде активиран до достигане на определената целева температура, след което нагревателят ще бъде изключен и включен за няколко цикъла. Ако параметърът WRITE_FILE е разрешен, ще се създаде файл /tmp/heattest.txt с дневник на всички температурни проби, взети по време на теста.

### [print_stats]

The print_stats module is automatically loaded.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>] [CURRENT_LAYER= <current_layer>]`: Pass slicer info like layer act and total to Klipper. Add `SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>]` to your slicer start gcode section and `SET_PRINT_STATS_INFO [CURRENT_LAYER= <current_layer>]` at the layer change gcode section to pass layer information from your slicer to Klipper.

### [probe]

The following commands are available when a [probe config section](Config_Reference.md#probe) or [bltouch config section](Config_Reference.md#bltouch) is enabled (also see the [probe calibrate guide](Probe_Calibrate.md)).

#### PROBE

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`: Преместете дюзата надолу, докато сондата се задейства. Ако са зададени някои от незадължителните параметри, те отменят еквивалентната им настройка в раздела [конфигурация на сондата](Config_Reference.md#probe).

#### QUERY_PROBE

`QUERY_PROBE`: Докладва текущото състояние на сондата ("задействана" или "отворена").

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`: Изчислява максимума, минимума, средната стойност, медианата и стандартното отклонение на множество проби от сонди. По подразбиране се вземат 10 ПРОБИ. В противен случай незадължителните параметри по подразбиране отговарят на еквивалентните им настройки в раздела за конфигурация на сондата.

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>]`: Изпълнява помощен скрипт, полезен за калибриране на z_offset на сондата. За подробности относно незадължителните параметри на сондата вижте командата PROBE. Вижте командата MANUAL_PROBE за подробности относно параметъра SPEED и допълнителните команди, които са на разположение, докато инструментът е активен. Обърнете внимание, че командата PROBE_CALIBRATE използва променливата скорост за движение в посока XY, както и в посока Z.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`: Take the current Z Gcode offset (aka, babystepping), and subtract if from the probe's z_offset. This acts to take a frequently used babystepping value, and "make it permanent". Requires a `SAVE_CONFIG` to take effect.

### [probe_eddy_current]

The following commands are available when a [probe_eddy_current config section](Config_Reference.md#probe_eddy_current) is enabled.

#### PROBE_EDDY_CURRENT_CALIBRATE

`PROBE_EDDY_CURRENT_CALIBRATE CHIP=<config_name>`: Това стартира инструмент, който калибрира резонансните честоти на сензора към съответните височини Z. Завършването на инструмента ще отнеме няколко минути. След приключването му използвайте командата SAVE_CONFIG, за да съхраните резултатите във файла printer.cfg.

#### LDC_CALIBRATE_DRIVE_CURRENT

`LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` Този инструмент ще калибрира регистъра ldc1612 DRIVE_CURRENT0. Преди да използвате този инструмент, преместете сензора така, че да се намира близо до центъра на леглото и на около 20 мм над повърхността на леглото. Изпълнете тази команда, за да определите подходящ DRIVE_CURRENT за сензора. След изпълнението на тази команда използвайте командата SAVE_CONFIG, за да съхраните новата настройка в конфигурационния файл printer.cfg.

### [pwm_cycle_time]

The following command is available when a [pwm_cycle_time config section](Config_Reference.md#pwm_cycle_time) is enabled.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: This command works similarly to [output_pin](#output_pin) SET_PIN commands. The command here supports setting an explicit cycle time using the CYCLE_TIME parameter (specified in seconds). Note that the CYCLE_TIME parameter is not stored between SET_PIN commands (any SET_PIN command without an explicit CYCLE_TIME parameter will use the `cycle_time` specified in the pwm_cycle_time config section).

### [quad_gantry_level]

The following commands are available when the [quad_gantry_level config section](Config_Reference.md#quad_gantry_level) is enabled.

#### QUAD_GANTRY_LEVEL

`QUAD_GANTRY_LEVEL [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `RETRIES`, `RETRY_TOLERANCE`, and `HORIZONTAL_MOVE_Z` values override those options specified in the config file.

### [query_adc]

The query_adc module is automatically loaded.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]`: Отчита последната аналогова стойност, получена за конфигуриран аналогов извод. Ако не е предоставено име, се докладва списъкът с наличните имена adc. Ако е посочен PULLUP (като стойност в омове), се отчита суровата аналогова стойност заедно с еквивалентното съпротивление при този pullup.

### [query_endstops]

The query_endstops module is automatically loaded. The following standard G-Code commands are currently available, but using them is not recommended:

- Получаване на състояние на Endstop: (Използвайте QUERY_ENDSTOPS вместо това.)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`: Проучва крайните ограничители на оста и докладва дали са "задействани" или са в състояние "отворено". Тази команда обикновено се използва, за да се провери дали даден краен ограничител работи правилно.

### [resonance_tester]

The following commands are available when a [resonance_tester config section](Config_Reference.md#resonance_tester) is enabled (also see the [measuring resonances guide](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: Измерва и извежда шума за всички оси на всички активирани акселерометрични чипове.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> [OUTPUT=<resonances,raw_data>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [POINT=x,y,z] [INPUT_SHAPING=<0:1>]`: Runs the resonance test in all configured probe points for the requested "axis" and measures the acceleration using the accelerometer chips configured for the respective axis. "axis" can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. `chip_name` can be one or more configured accel chips, delimited with comma, for example `CHIPS="adxl345, adxl345 rpi"`. If POINT is specified it will override the point(s) configured in `[resonance_tester]`. If `INPUT_SHAPING=0` or not set(default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured or POINT is specified). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>][HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [MAX_SMOOTHING=<max_smoothing>] [INPUT_SHAPING=<0:1>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command, and if `[input_shaper]` was already enabled previously, these parameters take effect immediately.

### [respond]

The following standard G-Code commands are available when the [respond config section](Config_Reference.md#respond) is enabled:

- `M118 <съобщение>`: ехо на съобщението, допълнено с конфигурирания префикс по подразбиране (или `echo: `, ако не е конфигуриран префикс).

The following additional commands are also available.

#### RESPOND

- `RESPOND MSG="<съобщение>"`: повтаря съобщението, допълнено с конфигурирания префикс по подразбиране (или `echo: `, ако не е конфигуриран префикс).
- `RESPOND TYPE=echo MSG="<message>"`: повтаря съобщението, допълнено с `echo: `.
- `RESPOND TYPE=echo_no_space MSG="<message>"`: повтаря съобщението, предшествано от `echo:`, без интервал между префикса и съобщението, което е полезно за съвместимост с някои приставки на octoprint, които очакват много специфично форматиране.
- `RESPOND TYPE=команда MSG="<съобщение>"`: повтаря съобщението, допълнено с `//`. OctoPrint може да бъде конфигуриран да отговаря на тези съобщения (например `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<message>"`: повтори съобщението, допълнено с `!!! `.
- `RESPOND PREFIX=<prefix> MSG="<message>"`: повтаря съобщението, допълнено с `<prefix>`. (Параметърът `PREFIX` има приоритет пред параметъра `TYPE`)

### [save_variables]

The following command is enabled if a [save_variables config section](Config_Reference.md#save_variables) has been enabled.

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`: Saves the variable to disk so that it can be used across restarts. The VARIABLE must be lowercase. All stored variables are loaded into the `printer.save_variables.variables` dict at startup and can be used in gcode macros. The provided VALUE is parsed as a Python literal.

### [screws_tilt_adjust]

The following commands are available when the [screws_tilt_adjust config section](Config_Reference.md#screws_tilt_adjust) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Тази команда ще задейства инструмента за регулиране на винтовете на леглото. Той ще подаде команда на дюзата към различни места (както е определено във файла за конфигуриране), сондирайки височината z, и ще изчисли броя на завъртанията на копчето за регулиране на нивото на леглото. Ако е зададена ДИРЕКЦИЯ, всички завъртания на копчето ще бъдат в една и съща посока - по посока на часовниковата стрелка (CW) или обратно на нея (CCW). За подробности относно допълнителните параметри на сондата вижте командата PROBE. ВАЖНО: Винаги ТРЯБВА да правите G28, преди да използвате тази команда. Ако е зададена MAX_DEVIATION, командата ще предизвика грешка в gcode, ако разликата във височината на винта спрямо базовата височина на винта е по-голяма от зададената стойност. Незадължителната стойност `HORIZONTAL_MOVE_Z` отменя опцията `horizontal_move_z`, зададена в конфигурационния файл.

### [sdcard_loop]

When the [sdcard_loop config section](Config_Reference.md#sdcard_loop) is enabled, the following extended commands are available.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`: Започва зациклена секция в SD печат. Брояч от 0 показва, че секцията трябва да бъде зациклена за неопределено време.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: Край на зациклена секция в SD принта.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: Завършване на съществуващите цикли без допълнителни итерации.

### [servo]

The following commands are available when a [servo config section](Config_Reference.md#servo) is enabled.

#### SET_SERVO

`SET_SERVO SERVO=config_name [ANGLE=<degrees> | WIDTH=<seconds>]`: Set the servo position to the given angle (in degrees) or pulse width (in seconds). Use `WIDTH=0` to disable the servo output.

### [skew_correction]

The following commands are available when the [skew_correction config section](Config_Reference.md#skew_correction) is enabled (also see the [Skew Correction](Skew_Correction.md) guide).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`: Configures the [skew_correction] module with measurements (in mm) taken from a calibration print. One may enter measurements for any combination of planes, planes not entered will retain their current value. If `CLEAR=1` is entered then all skew correction will be disabled.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: Съобщава текущото отклонение на принтера за всяка равнина в радиани и градуси. Наклонението се изчислява въз основа на параметрите, предоставени чрез gcode `SET_SKEW`.

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>]`: Изчислява и отчита наклона (в радиани и градуси) въз основа на измерен отпечатък. Това може да бъде полезно за определяне на текущото изкривяване на принтера след прилагане на корекция. Тя може да бъде полезна и преди прилагането на корекцията, за да се определи дали е необходима корекция на изкривяването. Вижте [Skew Correction](Skew_Correction.md) за подробности относно обектите и измерванията за калибриране на наклона.

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<name>] [SAVE=<name>] [REMOVE=<name>]`: Profile management for skew_correction. LOAD will restore skew state from the profile matching the supplied name. SAVE will save the current skew state to a profile matching the supplied name. Remove will delete the profile matching the supplied name from persistent memory. Note that after SAVE or REMOVE operations have been run the SAVE_CONFIG gcode must be run to make the changes to persistent memory permanent.

### [smart_effector]

Several commands are available when a [smart_effector config section](Config_Reference.md#smart_effector) is enabled. Be sure to check the official documentation for the Smart Effector on the [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer) before changing the Smart Effector parameters. Also check the [probe calibration guide](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<sensitivity>] [ACCEL=<accel>] [RECOVERY_TIME=<time>]`: Set the Smart Effector parameters. When `SENSITIVITY` is specified, the respective value is written to the SmartEffector EEPROM (requires `control_pin` to be provided). Acceptable `<sensitivity>` values are 0..255, the default is 50. Lower values require less nozzle contact force to trigger (but there is a higher risk of false triggering due to vibrations during probing), and higher values reduce false triggering (but require larger contact force to trigger). Since the sensitivity is written to EEPROM, it is preserved after the shutdown, and so it does not need to be configured on every printer startup. `ACCEL` and `RECOVERY_TIME` allow to override the corresponding parameters at run-time, see the [config section](Config_Reference.md#smart_effector) of Smart Effector for more info on those parameters.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`: Възстановява фабричните настройки на чувствителността на Smart Effector. Изисква в секцията config да се посочи `control_pin`.

### [stepper_enable]

The stepper_enable module is automatically loaded.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<config_name> ENABLE=[0|1]`: Enable or disable only the given stepper. This is a diagnostic and debugging tool and must be used with care. Disabling an axis motor does not reset the homing information. Manually moving a disabled stepper may cause the machine to operate the motor outside of safe limits. This can lead to damage to axis components, hot ends, and print surface.

### [temperature_fan]

The following command is available when a [temperature_fan config section](Config_Reference.md#temperature_fan) is enabled.

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>] [max_speed=<max_speed>]`: Sets the target temperature for a temperature_fan. If a target is not supplied, it is set to the specified temperature in the config file. If speeds are not supplied, no change is applied.

### [temperature_probe]

The following commands are available when a [temperature_probe config section](Config_Reference.md#temperature_probe) is enabled.

#### TEMPERATURE_PROBE_CALIBRATE

`TEMPERATURE_PROBE_CALIBRATE [PROBE=<probe name>] [TARGET=<value>] [STEP=<value>]`: Initiates probe drift calibration for eddy current based probes. The `TARGET` is a target temperature for the last sample. When the temperature recorded during a sample exceeds the `TARGET` calibration will complete. The `STEP` parameter sets temperature delta (in C) between samples. After a sample has been taken, this delta is used to schedule a call to `TEMPERATURE_PROBE_NEXT`. The default `STEP` is 2.

#### TEMPERATURE_PROBE_NEXT

`TEMPERATURE_PROBE_NEXT`: After calibration has started this command is run to take the next sample. It is automatically scheduled to run when the delta specified by `STEP` has been reached, however its also possible to manually run this command to force a new sample. This command is only available during calibration.

#### TEMPERATURE_PROBE_COMPLETE:

`TEMPERATURE_PROBE_COMPLETE`: Can be used to end calibration and save the current result before the `TARGET` temperature is reached. This command is only available during calibration.

#### ABORT

`ABORT`: Прекратява процеса на калибриране, като изхвърля текущите резултати. Тази команда е достъпна само по време на калибриране на дрейфа.

### TEMPERATURE_PROBE_ENABLE

`TEMPERATURE_PROBE_ENABLE ENABLE=[0|1]`: Sets temperature drift compensation on or off. If ENABLE is set to 0, drift compensation will be disabled, if set to 1 it is enabled.

### [tmcXXXX]

The following commands are available when any of the [tmcXXXX config sections](Config_Reference.md#tmc-stepper-driver-configuration) are enabled.

#### DUMP_TMC

`DUMP_TMC STEPPER=<име> [REGISTER=<име>]`: Тази команда ще прочете всички регистри на TMC драйвера и ще отчете техните стойности. Ако е посочен РЕГИСТЪР, ще бъде изведен само посоченият регистър.

#### INIT_TMC

`INIT_TMC STEPPER=<име>`: Тази команда ще инициализира регистрите на TMC. Необходима е, за да се активира отново драйверът, ако захранването на чипа е изключено и отново включено.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: This will adjust the run and hold currents of the TMC driver. `HOLDCURRENT` is not applicable to tmc2660 drivers. When used on a driver which has the `globalscaler` field (tmc5160 and tmc2240), if StealthChop2 is used, the stepper must be held at standstill for >130ms so that the driver executes the AT#1 calibration.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value> VELOCITY=<value>`: This will alter the value of the specified register field of the TMC driver. This command is intended for low-level diagnostics and debugging only because changing the fields during run-time can lead to undesired and potentially dangerous behavior of your printer. Permanent changes should be made using the printer configuration file instead. No sanity checks are performed for the given values. A VELOCITY can also be specified instead of a VALUE. This velocity is converted to the 20bit TSTEP based value representation. Only use the VELOCITY argument for fields that represent velocities.

### [toolhead]

The toolhead module is automatically loaded.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [MINIMUM_CRUISE_RATIO=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: This command can alter the velocity limits that were specified in the printer config file. See the [printer config section](Config_Reference.md#printer) for a description of each parameter.

### [tuning_tower]

The tuning_tower module is automatically loaded.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<command> PARAMETER=<name> START=<value> [SKIP=<value>] [FACTOR=<value> [BAND=<value>]] | [STEP_DELTA=<value> STEP_HEIGHT=<value>]`: A tool for tuning a parameter on each Z height during a print. The tool will run the given `COMMAND` with the given `PARAMETER` assigned to a value that varies with `Z` according to a formula. Use `FACTOR` if you will use a ruler or calipers to measure the Z height of the optimum value, or `STEP_DELTA` and `STEP_HEIGHT` if the tuning tower model has bands of discrete values as is common with temperature towers. If `SKIP=<value>` is specified, the tuning process doesn't begin until Z height `<value>` is reached, and below that the value will be set to `START`; in this case, the `z_height` used in the formulas below is actually `max(z - skip, 0)`. There are three possible combinations of options:

- `FACTOR`: Стойността се променя със скорост `фактор` на милиметър. Използваната формула е: `стойност = старт + фактор * z_височина`. Можете да включите оптималната височина Z директно във формулата, за да определите оптималната стойност на параметъра.
- `FACTOR` и `BAND`: Стойността се променя със средна скорост от `фактор` на милиметър, но в дискретни диапазони, където корекцията ще се извършва само на всеки `БАНД` милиметра от височината Z. Използваната формула е: `стойност = старт + фактор * ((floor(z_height / band) + .5) * band)`.
- `STEP_DELTA` and `STEP_HEIGHT`: The value changes by `STEP_DELTA` every `STEP_HEIGHT` millimeters. The formula used is: `value = start + step_delta * floor(z_height / step_height)`. You can simply count bands or read tuning tower labels to determine the optimum value.

### [virtual_sdcard]

Klipper поддържа следните стандартни G-Code команди, ако е активиран разделът [virtual_sdcard config](Config_Reference.md#virtual_sdcard):

- Списък на SD картата: `M20`
- Инициирайте SD картата: `M21`
- Изберете SD файл: `M23 <името на файла>``
- Start/resume SD print: `M24`
- Пауза на SD печат: `M25`
- Set SD position: `M26 S<offset>`
- Доклад за състоянието на печат на SD: `M27`

Освен това следните разширени команди са налични, когато секцията за конфигуриране "virtual_sdcard" е активирана.

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<име на файла>`: Зареждане на файл и стартиране на SD печат.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`: Разтоварване на файла и изчистване на състоянието на SD.

### [z_thermal_adjust]

The following commands are available when the [z_thermal_adjust config section](Config_Reference.md#z_thermal_adjust) is enabled.

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<value>] [REF_TEMP=<value>]`: Enable or disable the Z thermal adjustment with `ENABLE`. Disabling does not remove any adjustment already applied, but will freeze the current adjustment value - this prevents potentially unsafe downward Z movement. Re-enabling can potentially cause upward tool movement as the adjustment is updated and applied. `TEMP_COEFF` allows run-time tuning of the adjustment temperature coefficient (i.e. the `TEMP_COEFF` config parameter). `TEMP_COEFF` values are not saved to the config. `REF_TEMP` manually overrides the reference temperature typically set during homing (for use in e.g. non-standard homing routines) - will be reset automatically upon homing.

### [z_tilt]

The following commands are available when the [z_tilt config section](Config_Reference.md#z_tilt) is enabled.

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `RETRIES`, `RETRY_TOLERANCE`, and `HORIZONTAL_MOVE_Z` values override those options specified in the config file.
