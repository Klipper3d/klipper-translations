# G-коди

Цей документ описує команди які підтримує Klipper. Це команди які ви можете ввести у вікні терміналу OctoPrint.

## Команди G-коду

Klipper підтримує такі стандартні команди G-коду:

- Переміщення (G0 або G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<швидкість>]`
- Затримка: `G4 P<мілісекунди>`
- Перейти до початку: `G28 [X] [Y] [Z]`
- Вимкніть двигуни: `M18` або `M84`
- Зачекайте, поки завершаться поточні ходи: `M400`
- Використовуйте абсолютні/відносні відстані для екструзії: `M82`, `M83`
- Використовуйте абсолютні/відносні координати: `G90`, `G91`
- Установити позицію: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- Установіть відсоток перевизначення коефіцієнта швидкості: `M220 S<percent>`
- Установіть відсоток перевизначення коефіцієнта екструдування: `M221 S<percent>`
- Установити прискорення: `M204 S<value>` АБО `M204 P<value> T<value>`
   - Примітка: якщо S не вказано, а вказано як P, так і T, тоді для прискорення встановлюється мінімальне значення P і T. Якщо вказано лише одне з P або T, команда не має ефекту.
- Отримайте температуру екструдера: "M105".
- Встановіть температуру екструдера: `M104 [T<index>] [S<temperature>]`
- Встановіть температуру екструдера та зачекайте: `M109 [T<index>] S<temperature>`
   - Примітка: M109 завжди чекає, поки температура досягне заданого значення
- Встановлена температура шару: `M140 [S<temperature>]`
- Встановіть температуру ліжка та зачекайте: `M190 S<температура>`
   - Примітка: M190 завжди чекає, поки температура досягне потрібного значення
- Встановіть швидкість вентилятора: `M106 S<value>`
- Вимкніть вентилятор: `M107`
- Аварійна зупинка: `М112`
- Отримати поточну позицію: `M114`
- Отримати версію мікропрограми: `M115`

Щоб отримати додаткові відомості про команди вище, перегляньте [документацію G-коду RepRap](http://reprap.org/wiki/G-code).

Метою Klipper є підтримка команд G-Code, створених звичайним стороннім програмним забезпеченням (наприклад, OctoPrint, Printrun, Slic3r, Cura тощо) у їхніх стандартних конфігураціях. Це не мета підтримувати всі можливі команди G-коду. Натомість Klipper віддає перевагу зрозумілим для людини ["розширеним командам G-коду"](#additional-commands). Подібним чином вихід терміналу G-Code призначений лише для читання людиною - див. [документ сервера API] (API_Server.md), якщо керувати Klipper із зовнішнього програмного забезпечення.

Якщо вам потрібна менш поширена команда G-Code, її можна реалізувати за допомогою спеціального [gcode_macro конфігураційного розділу](Config_Reference.md#gcode_macro). Наприклад, це можна використовувати для реалізації: `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1` тощо.

## Додаткові команди

Klipper використовує "розширені" команди G-коду для загальної конфігурації та стану. Усі ці розширені команди мають схожий формат — вони починаються з назви команди та можуть супроводжуватися одним або кількома параметрами. Наприклад: `SET_SERVO SERVO=myservo ANGLE=5.3`. У цьому документі команди та параметри наведено великими літерами, однак вони не чутливі до регістру. (Отже, "SET_SERVO" і "set_servo" запускають ту саму команду.)

Цей розділ упорядковано за назвою модуля Klipper, яка зазвичай слідує за назвами розділів, указаними у [файлі конфігурації принтера] (Config_Reference.md). Зауважте, що деякі модулі завантажуються автоматично.

### [adxl345]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації adxl345](Config_Reference.md#adxl345).

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: починає вимірювання акселерометра із заданою кількістю вибірок за секунду. Якщо CHIP не вказано, за замовчуванням буде "adxl345". Команда працює в режимі старт-стоп: при першому виконанні запускає вимірювання, наступне виконання припиняє їх. Результати вимірювань записуються у файл з іменем `/tmp/adxl345-<chip>-<name>.csv`, де `<chip>` — це назва мікросхеми акселерометра (`my_chip_name` від `[adxl345 my_chip_name]` ), а `<name>` є необов'язковим параметром NAME. Якщо NAME не вказано, за замовчуванням використовується поточний час у форматі "YYYYMMDDHHMMSS." Якщо акселерометр не має назви в розділі конфігурації (просто `[adxl345]`), то частина назви `<chip>` не генерується.

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: запитує акселерометр для поточного значення. Якщо CHIP не вказано, за замовчуванням буде "adxl345". Якщо RATE не вказано, використовується значення за замовчуванням. Ця команда корисна для перевірки підключення до акселерометра ADXL345: одним із повернених значень має бути прискорення вільного падіння (+/- певний шум мікросхеми).

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`: надсилає запит ADXL345 на реєстр "зареєструвати" (наприклад, 44 або 0x2C). Може бути корисним для налагодження.

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<реєстр> VAL=<значення>`: записує необроблене «значення» в регістр «реєстр». І «значення», і «реєстр» можуть бути десятковим або шістнадцятковим цілим числом. Використовуйте обережно та зверніться до таблиці даних ADXL345 для довідки.

### [кут]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації кута](Config_Reference.md#angle).

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<chip_name>`: Виконайте калібрування кута на даному датчику (має бути розділ конфігурації `[angle chip_name]`, який вказав параметр `stepper`). ВАЖЛИВО: цей інструмент надає команду кроковому двигуну рухатися без перевірки нормальних кінематичних меж. В ідеалі двигун слід від’єднати від будь-якої каретки принтера перед виконанням калібрування. Якщо кроковий кроковий пристрій не можна від’єднати від принтера, перед початком калібрування переконайтеся, що каретка знаходиться біля центру напрямної. (Під час цього тесту кроковий двигун може рухатися вперед або назад на два повних оберти.) Після завершення цього тесту скористайтеся командою `SAVE_CONFIG`, щоб зберегти дані калібрування у файлі конфігурації. Щоб використовувати цей інструмент, потрібно встановити пакет Python "numpy" (додаткову інформацію див. у [документі про вимірювання резонансу](Measuring_Resonances.md#software-installation).

#### ANGLE_CHIP_CALIBRATE

`ANGLE_CHIP_CALIBRATE CHIP=<назва_чіпа>`: Виконайте калібрування внутрішнього датчика, якщо реалізовано (MT6826S/MT6835).

- **MT68XX**: двигун слід від’єднати від будь-якої каретки принтера перед виконанням калібрування. Після калібрування датчик слід скинути, відключивши живлення.

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: запитує "реєстр" регістра датчика (наприклад, 44 або 0x2C). Може бути корисним для налагодження. Це доступно лише для мікросхем tle5012b.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: записує необроблене «значення» в регістр «register». І «значення», і «реєстр» можуть бути десятковим або шістнадцятковим цілим числом. Використовуйте обережно та зверніться до таблиці даних датчика для довідки. Це доступно лише для мікросхем tle5012b.

### [axis_twist_compensation]

The following commands are available when the [axis_twist_compensation config
section](Config_Reference.md#axis_twist_compensation) is enabled.

#### AXIS_TWIST_COMPENSATION_CALIBRATE

`AXIS_TWIST_COMPENSATION_CALIBRATE [AXIS=<X|Y>] [SAMPLE_COUNT=<value>]`

Калібрує компенсацію скручування осі, вказуючи цільову вісь або вмикаючи автоматичне калібрування.

- **AXIS:** Визначте вісь ('X' або 'Y'), для якої буде відкалібровано компенсацію скручування. Якщо не вказано, вісь за замовчуванням `'X'`.

### [bed_mesh]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації bed_mesh](Config_Reference.md#bed_mesh) (також див. [довідник щодо сітки для ліжка](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [PROFILE=<name>] [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=1] [ADAPTIVE_MARGIN=<value>]`: This command probes the bed using generated points specified by the parameters in the config. After probing, a mesh is generated and z-movement is adjusted according to the mesh. The mesh is immediately active after successful completion of `BED_MESH_CALIBRATE`. The mesh will be saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. If ADAPTIVE=1 is specified then the profile name will begin with `adaptive-` and should not be saved for reuse. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file. If ADAPTIVE=1 is specified then the objects defined by the Gcode file being printed will be used to define the probed area. The optional `ADAPTIVE_MARGIN` value overrides the `adaptive_margin` option specified in the config file.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`: ця команда виводить на термінал поточні досліджувані значення z і поточні значення сітки. Якщо вказано PGP=1, координати X, Y, згенеровані bed_mesh, разом із відповідними індексами будуть виведені на термінал.

#### BED_MESH_MAP

`BED_MESH_MAP`: як і BED_MESH_OUTPUT, ця команда друкує поточний стан сітки на терміналі. Замість друку значень у форматі, зрозумілому людині, стан серіалізується у форматі json. Це дозволяє плагінам octoprint легко збирати дані та генерувати карти висот, які приблизно відповідають поверхні ліжка.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: ця команда очищає сітку та видаляє всі налаштування z. Рекомендовано розмістити це у вашому кінцевому gcode.

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<name> SAVE=<name> REMOVE=<name>`: ця команда забезпечує керування профілем для стану сітки. LOAD відновить стан сітки з профілю, який відповідає наданій назві. SAVE збереже поточний стан сітки в профілі, що відповідає наданій назві. Видалити видалить профіль, який відповідає наданому імені, із постійної пам’яті. Зауважте, що після виконання операцій SAVE або REMOVE потрібно запустити gcode SAVE_CONFIG, щоб зробити зміни в постійній пам’яті постійними.

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<значення>] [Y=<значення>] [ZFADE=<значення]`: застосовує зміщення X, Y та/або ZFADE до пошуку сітки. Це корисно для принтерів із незалежними екструдерами, оскільки зсув необхідний для правильного налаштування Z після зміни інструменту. Зауважте, що зміщення ZFADE не застосовує додаткове коригування z напряму, воно використовується для виправлення обчислення «згасання», коли до осі Z застосовано «зміщення gcode».

### [гвинти_ліжка]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації bed_screws](Config_Reference.md#bed_screws) (також див. [посібник з ручного рівня](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`: Ця команда викличе інструмент регулювання кріпильних гвинтів. Він керуватиме насадкою в різних місцях (як визначено у конфігураційному файлі) і дозволить регулювати гвинти станини так, щоб станина була на постійній відстані від сопла.

### [bed_tilt]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації bed_tilt](Config_Reference.md#bed_tilt).

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: ця команда перевірить точки, указані в конфігурації, а потім порекомендує оновлені налаштування нахилу x і y. Дивіться команду PROBE, щоб дізнатися про додаткові параметри зонду. Якщо вказано METHOD=manual, інструмент ручного тестування активовано - дивіться команду MANUAL_PROBE вище, щоб дізнатися більше про додаткові команди, доступні, коли цей інструмент активний. Додаткове значення `HORIZONTAL_MOVE_Z` замінює параметр `horizontal_move_z`, указаний у файлі конфігурації.

### [bltouch]

Наступна команда доступна, якщо ввімкнено [розділ конфігурації bltouch](Config_Reference.md#bltouch) (також див. [посібник BL-Touch](BLTouch.md)).

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<команда>`: надсилає команду на BLTouch. Це може бути корисним для налагодження. Доступні команди: `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`. BL-Touch V3.0 або V3.1 також може підтримувати команди `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store`.

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`: зберігає режим виведення в EEPROM BLTouch V3.1. Доступні режими виводу: `5V`, `OD`

### [файл конфігурації]

Модуль configfile завантажується автоматично.

#### SAVE_CONFIG

`SAVE_CONFIG`: ця команда перезапише основний файл конфігурації принтера та перезапустить програмне забезпечення хоста. Ця команда використовується в поєднанні з іншими командами калібрування для збереження результатів калібрувальних тестів.

### [delayed_gcode]

Наступну команду ввімкнено, якщо ввімкнено [розділ конфігурації delayed_gcode](Config_Reference.md#delayed_gcode) (також див. [посібник із шаблонів](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: оновлює тривалість затримки для визначеного [delayed_gcode] і запускає таймер для виконання gcode. Значення 0 скасує виконання відкладеного gcode, що очікує на виконання.

### [delta_calibrate]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації delta_calibrate](Config_Reference.md#linear-delta-kinematics) (також див. [посібник із калібрування дельти](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: ця команда перевірить сім точок на станині та рекомендує оновлені положення кінцевих упорів, кути башти та радіус. Дивіться команду PROBE, щоб дізнатися про додаткові параметри зонду. Якщо вказано METHOD=manual, інструмент ручного тестування активовано - дивіться команду MANUAL_PROBE вище, щоб дізнатися більше про додаткові команди, доступні, коли цей інструмент активний. Додаткове значення `HORIZONTAL_MOVE_Z` замінює параметр `horizontal_move_z`, указаний у файлі конфігурації.

#### DELTA_ANALYZE

`DELTA_ANALYZE`: Ця команда використовується під час розширеного дельта-калібрування. Докладніше див. у [Delta Calibrate](Delta_Calibrate.md).

### [дисплей]

Наступна команда доступна, якщо ввімкнено [розділ конфігурації дисплея](Config_Reference.md#gcode_macro).

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<дисплей>] GROUP=<група>`: установіть активну групу відображення РК-дисплея. Це дозволяє визначити декілька груп відображення даних у конфігурації, напр. `[display_data <group> <elementname>]` і перемикатися між ними за допомогою цієї розширеної команди gcode. Якщо DISPLAY не вказано, за замовчуванням буде «display» (основний дисплей).

### [дисплей_статус]

Модуль display_status завантажується автоматично, якщо ввімкнено [розділ конфігурації дисплея](Config_Reference.md#display). Він надає такі стандартні команди G-коду:

- Відображення повідомлення: `M117 <повідомлення>`
- Встановити відсоток збірки: `M73 P<percent>`

Також надається така розширена команда G-коду:

- `SET_DISPLAY_TEXT MSG=<message>`: Виконує еквівалент M117, встановлюючи наданий `MSG` як поточне повідомлення на дисплеї. Якщо `MSG` пропущено, дисплей буде очищено.

### [dual_carriage]

Наступна команда доступна, якщо ввімкнено [розділ конфігурації dual_carriage](Config_Reference.md#dual_carriage).

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=<carriage> [MODE=[PRIMARY|COPY|MIRROR|INACTIVE]]`: This command will change the mode of the specified carriage. If no `MODE` is provided it defaults to `PRIMARY`. `<carriage>` must reference a defined primary or dual carriage for `generic_cartesian` kinematics or be 0 (for primary carriage) or 1 (for dual carriage) for all other kinematics supporting IDEX. Setting the mode to `PRIMARY` deactivates all other carriages on the same axis and makes the specified carriage execute subsequent G-Code movement commands as-is. Before activating `COPY` or `MIRROR` mode for a carriage, a different one must be activated as `PRIMARY` on the same axis. When set to either of these two modes, the carriage will track the subsequent G-Code moves and either copy relative movements (in `COPY` mode) or execute them in the opposite (mirror) direction (in `MIRROR` mode). Setting the mode to `INACTIVE` deactivates the carriage and makes it ignore further G-Code moves. Note that deactivating the primary carriage on the axis does not disable other carriages working in `COPY` or `MIRROR` mode, which can be used to disable printing a failed part by any of the tools and park that tool to prevent collisions with an unfinished part, see this [sample configuration](../config/sample-corexyuv.cfg) for macros examples.

#### SAVE_DUAL_CARRIAGE_STATE

`SAVE_DUAL_CARRIAGE_STATE [NAME=<state_name>]`: Збереження поточних позицій подвійних кареток і їх режимів. Збереження та відновлення стану DUAL_CARRIAGE може бути корисним у сценаріях і макросах, а також у перевизначеннях процедур повернення до початкового місця. Якщо вказано NAME, це дозволяє назвати збережений стан у заданому рядку. Якщо NAME не вказано, за замовчуванням використовується значення "default".

#### RESTORE_DUAL_CARRIAGE_STATE

`RESTORE_DUAL_CARRIAGE_STATE [NAME=<state_name>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: Restore the previously saved states of all dual and their primary carriages. This command restores the modes of the carriages and moves them to their previously saved positions, unless "MOVE=0" is specified. If positions are being restored and "MOVE_SPEED" is specified, then the carriages will move with at most the provided speed (in mm/s); otherwise the homing speeds of the corresponding carriages will be used as a reference. Note that the carriages restore their positions only over their own axes, which may be necessary to correctly restore COPY and MIRROR mode of the dual carriage. In addition, this command updates the Klipper toolhead position for each axis that has some dual carriages: it is set to match the actual position of the activated primary carriage of an axis or, if an axis does not have a saved primary carriage, to the axis position when `SAVE_DUAL_CARRIAGE_STATE` command was called.

### [кінцева_фаза]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації endstop_phase](Config_Reference.md#endstop_phase) (також див. [посібник з фази endstop](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]`: якщо параметр STEPPER не надано, ця команда звітуватиме про статистику крокових фаз кінцевої зупинки під час попередніх операцій наведення. Якщо надається параметр STEPPER, він організовує запис даного параметра фази кінцевої зупинки у файл конфігурації (у поєднанні з командою SAVE_CONFIG).

### [exclude_object]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації exclude_object](Config_Reference.md#exclude_object) (також див. [посібник з виключення об’єктів](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=назва_об’єкта] [CURRENT=1] [RESET=1]`: без параметрів буде повернуто список усіх наразі виключених об’єктів.

Якщо вказано параметр `NAME`, названий об'єкт буде виключено з друку.

Якщо вказано параметр `CURRENT`, поточний об'єкт буде виключено з друку.

Якщо задано параметр `RESET`, список виключених об'єктів буде очищено. Крім того, включення `NAME` призведе до скидання лише названого об’єкта. Це **може** спричинити помилки друку, якщо шари вже були пропущені.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=назва_об’єкта [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`: надає короткий опис об’єкта у файлі.

За відсутності параметрів буде показано список визначених об’єктів, відомих Klipper. Повертає список рядків, якщо не вказано параметр `JSON`, коли він повертає деталі об’єкта у форматі json.

Якщо включено параметр `NAME`, це визначає об’єкт, який потрібно виключити.

- `NAME`: цей параметр обов'язковий. Це ідентифікатор, який використовується іншими командами в цьому модулі.
- `CENTER`: координати X, Y для об’єкта.
- `ПОЛІГОН`: масив координат X, Y, які забезпечують контур об’єкта.

Коли вказано параметр `RESET`, усі визначені об’єкти буде очищено, а модуль `[exclude_object]` буде скинуто.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=назва_об’єкта`: ця команда приймає параметр `NAME` і позначає початок gcode для об’єкта на поточному рівні.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=object_name]`: позначає кінець gcode об’єкта для шару. Він поєднується з `EXCLUDE_OBJECT_START`. Параметр `NAME` необов'язковий і попереджатиме, лише якщо надане ім'я не збігається з поточним об'єктом.

### [екструдер]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації екструдера](Config_Reference.md#extruder):

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: у принтері з кількома розділами конфігурації [extruder](Config_Reference.md#extruder) ця команда змінює активний hotend.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: установіть параметри підвищення тиску крокового екструдера (як визначено в [extruder](Config_Reference.md#extruder) або [  extruder_stepper](Config_Reference.md#extruder_stepper) розділ конфігурації). Якщо ЕКСТРУДЕР не вказано, за замовчуванням використовується степер, визначений у активному хотенді.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: установіть нове значення для «відстані обертання» наданого крокового екструдера (як визначено в [extruder](Config_Reference.md#extruder) або [extruder_stepper](Config_Reference) .md#extruder_stepper) розділ конфігурації). Якщо відстань обертання є від’ємним числом, кроковий рух буде інвертованим (відносно напрямку крокового кроку, указаного у файлі конфігурації). Змінені налаштування не зберігаються під час скидання Klipper. Використовуйте з обережністю, оскільки невеликі зміни можуть призвести до надмірного тиску між екструдером і гарячою частиною. Виконайте належне калібрування нитки перед використанням. Якщо значення «DISTANCE» не вказано, ця команда поверне поточну відстань обертання.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<ім'я> MOTION_QUEUE=<ім'я>': ця команда викличе крок, указаний EXTRUDER (як визначено в конфігурації [extruder](Config_Reference.md#extruder) або [extruder_stepper](Config_Reference.md#extruder_stepper) розділ), щоб стати синхронізованим із рухом екструдера, визначеного MOTION_QUEUE (як визначено в розділі конфігурації [extruder](Config_Reference.md#extruder). Якщо MOTION_QUEUE є порожнім рядком, тоді кроковий механізм буде десинхронізовано від усіх рухів екструдера.

### [fan_generic]

Наступна команда доступна, якщо ввімкнено [розділ конфігурації fan_generic](Config_Reference.md#fan_generic).

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<швидкість>` Ця команда встановлює швидкість вентилятора. "швидкість" має бути між 0,0 і 1,0.

`SET_FAN_SPEED FAN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given fan. For example, if one defined a `[display_template my_fan_template]` config section then one could assign `TEMPLATE=my_fan_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the fan will be automatically set to the resulting speed. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_FAN_SPEED` commands to manage the values directly).

### [filament_switch_sensor]

Наступна команда доступна, якщо ввімкнено розділ конфігурації [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) або [filament_motion_sensor](Config_Reference.md#filament_motion_sensor).

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<назва_сенсора>`: запитує поточний статус датчика нитки. Дані, що відображаються на терміналі, залежатимуть від типу датчика, визначеного в конфігурації.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<назва_сенсора> ENABLE=[0|1]`: вмикає/вимикає датчик нитки. Якщо ENABLE встановлено на 0, датчик нитки буде вимкнено, якщо встановлено на 1, він увімкнено.

### [firmware_retraction]

Наступні стандартні команди G-Code доступні, якщо ввімкнено [розділ конфігурації firmware_retraction](Config_Reference.md#firmware_retraction). Ці команди дозволяють використовувати функцію ретракції вбудованого програмного забезпечення, доступну в багатьох слайсерах, щоб зменшити кількість рядків під час неекструзійних переміщень від однієї частини друку до іншої. Відповідне налаштування просування тиску зменшує необхідну довжину втягування.

- `G10`: втягує екструдер із використанням поточних налаштованих параметрів.
- `G11`: скасовує втягування екструдера за допомогою поточних налаштованих параметрів.

Також доступні такі додаткові команди.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<мм>] [RETRACT_SPEED=<мм/с>] [UNRETRACT_EXTRA_LENGTH=<мм>] [UNRETRACT_SPEED=<мм/с>]`: налаштуйте параметри, які використовуються для ретракції мікропрограми. RETRACT_LENGTH визначає довжину нитки для втягування та розтягування. Швидкість втягування регулюється за допомогою RETRACT_SPEED і зазвичай встановлюється відносно високою. Швидкість скасування ретракції регулюється за допомогою UNRETRACT_SPEED і не є критичною, хоча часто нижча, ніж RETRACT_SPEED. У деяких випадках корисно додати невелику додаткову довжину при скасуванні відкликання, і це встановлюється через UNRETRACT_EXTRA_LENGTH. SET_RETRACTION зазвичай встановлюється як частина конфігурації слайсера для кожної нитки, оскільки для різних ниток потрібні різні налаштування параметрів.

#### GET_RETRACTION

`GET_RETRACTION`: запитує поточні параметри, які використовуються відкликанням мікропрограми, і відображає їх на терміналі.

### [force_move]

Модуль force_move завантажується автоматично, однак деякі команди вимагають налаштування `enable_force_move` у [конфігурації принтера](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<config_name>`: перемістіть заданий степпер на один мм вперед, а потім на один мм назад, повторюючи 10 разів. Це діагностичний інструмент, який допомагає перевірити підключення крокового кроку.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<назва_конфігурації> DISTANCE=<значення> VELOCITY=<значення> [ACCEL=<значення>]`: ця команда примусово перемістить заданий крок на задану відстань (у мм) із заданою постійною швидкістю (у мм/ s). Якщо вказано значення ACCEL і воно більше нуля, буде використано задане прискорення (у мм/с^2); інакше прискорення не виконується. Граничні перевірки не проводяться; кінематичні оновлення не виконуються; інші паралельні степери на осі не будуть переміщатися. Будьте обережні, оскільки неправильна команда може призвести до пошкодження! Використання цієї команди майже напевно переведе кінематику низького рівня в неправильний стан. потім видайте G28, щоб скинути кінематику. Ця команда призначена для низькорівневої діагностики та налагодження.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] [SET_HOMED=<[X][Y][Z]>] [CLEAR_HOMED=<[X][Y][Z]>]`: Force the low-level kinematic code to believe the toolhead is at the given cartesian position and set/clear homed status. This is a diagnostic and debugging command; use SET_GCODE_OFFSET and/or G92 for regular axis transformations. Setting an incorrect or invalid position may lead to internal software errors.

The `X`, `Y`, and `Z` parameters are used to alter the low-level kinematic position tracking. If any of these parameters are not set then the position is not changed - for example `SET_KINEMATIC_POSITION Z=10` would set all axes as homed, set the internal Z position to 10, and leave the X and Y positions unchanged. Changing the internal position tracking is not dependent on the internal homing state - one may alter the position for both homed and not homed axes, and similarly one may set or clear the homing state of an axis without altering its internal position.

The `SET_HOMED` parameter defaults to `XYZ` which instructs the kinematics to consider all axes as homed. A bare `SET_KINEMATIC_POSITION` command will result in all axes being considered homed (and not change its current position). If it is not desired to change the state of homed axes then assign `SET_HOMED` to an empty string - for example: `SET_KINEMATIC_POSITION SET_HOMED= X=10`. It is also possible to request an individual axis be considered homed (eg, `SET_HOMED=X`), but note that non-cartesian style kinematics (such as delta kinematics) may not support setting an individual axis as homed.

The `CLEAR_HOMED` parameter instructs the kinematics to consider the given axes as not homed. For example, `CLEAR_HOMED=XYZ` would request all axes to be considered not homed (and thus require homing prior to movement on those axes). The default is `SET_HOMED=XYZ` even if `CLEAR_HOMED` is present, so the command `SET_KINEMATIC_POSITION CLEAR_HOMED=Z` will set X and Y as homed and clear the homing state for Z. Use `SET_KINEMATIC_POSITION SET_HOMED= CLEAR_HOMED=Z` if the goal is to clear only the Z homing state. If an axis is specified in neither `SET_HOMED` nor `CLEAR_HOMED` then its homing state is not changed and if it is specified in both then `CLEAR_HOMED` has precedence. It is possible to request clearing of an individual axis, but on non-cartesian style kinematics (such as delta kinematics) doing so may result in clearing the homing state of additional axes. Note the `CLEAR` parameter is currently an alias for the `CLEAR_HOMED` parameter, but this alias will be removed in the future.

### [gcode]

Модуль gcode завантажується автоматично.

#### ПЕРЕЗАПУСК

`ПЕРЕЗАПУСК`: це змусить програмне забезпечення хоста перезавантажити свою конфігурацію та виконати внутрішнє скидання. Ця команда не видалить стан помилки з мікроконтролера (див. FIRMWARE_RESTART), а також не завантажить нове програмне забезпечення (див. [FAQ](FAQ.md#how-do-i-upgrade-to-the-latest-software)).

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`: це схоже на команду RESTART, але також очищає будь-який стан помилки мікроконтролера.

#### СТАТУС

`СТАТУС`: звіт про статус програмного забезпечення хоста Klipper.

#### ДОПОМОГА

`HELP`: звіт про список доступних розширених команд G-коду.

### [gcode_arcs]

Наступні стандартні команди G-Code доступні, якщо ввімкнено [розділ конфігурації gcode_arcs](Config_Reference.md#gcode_arcs):

- Переміщення дуги за годинниковою стрілкою (G2), переміщення дуги проти годинникової стрілки (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<швидкість>] I<значення> J<значення>|I<значення> K<значення>|J<значення> K<значення>`
- Вибір площини дуги: G17 (площина XY), G18 (площина XZ), G19 (площина YZ)

### [gcode_macro]

Наступна команда доступна, якщо ввімкнено [розділ конфігурації gcode_macro](Config_Reference.md#gcode_macro) (також див. [посібник із шаблонів команд](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<назва_макросу> VARIABLE=<назва> VALUE=<значення>`: ця команда дозволяє змінювати значення змінної gcode_macro під час виконання. Надане VALUE аналізується як літерал Python.

### [gcode_move]

Модуль gcode_move завантажується автоматично.

#### GET_POSITION

`GET_POSITION`: повертає інформацію про поточне розташування інструментальної головки. Додаткову інформацію див. у документації для розробників [виходу GET_POSITION](Code_Overview.md#coordinate-systems).

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed  >]]`: установіть позиційне зміщення для застосування до майбутніх команд G-коду. Це зазвичай використовується для віртуальної зміни зміщення шару Z або для встановлення зсуву сопла XY під час перемикання екструдерів. Наприклад, якщо надіслано "SET_GCODE_OFFSET Z=0,2", то майбутні переміщення G-коду матимуть 0,2 мм до їх висоти Z. Якщо використовуються параметри стилю X_ADJUST, тоді коригування буде додано до будь-якого існуючого зміщення (наприклад, «SET_GCODE_OFFSET Z=-0,2», а потім «SET_GCODE_OFFSET Z_ADJUST=0,3» призведе до загального зміщення Z, що дорівнює 0,1). Якщо вказано «MOVE=1», буде виконано переміщення інструментальної головки для застосування заданого зміщення (інакше зміщення набуде чинності під час наступного абсолютного переміщення G-коду, що визначає дану вісь). Якщо вказано "MOVE_SPEED", то переміщення інструментальної головки виконуватиметься із заданою швидкістю (у мм/с); інакше для переміщення інструментальної головки використовуватиметься остання задана швидкість G-коду.

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<state_name>]`: зберегти поточний стан аналізу координат g-коду. Збереження та відновлення стану g-коду корисно в сценаріях і макросах. Ця команда зберігає поточний режим абсолютних координат g-коду (G90/G91), абсолютний режим екструдування (M82/M83), початок (G92), зміщення (SET_GCODE_OFFSET), перевизначення швидкості (M220), перевизначення екструдера (M221), швидкість переміщення , поточне положення XYZ і відносне положення екструдера "E". Якщо вказано NAME, це дозволяє назвати збережений стан у заданому рядку. Якщо NAME не вказано, за замовчуванням використовується значення "default".

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<ім'я_стану>] [MOVE=1 [MOVE_SPEED=<швидкість>]]`: відновити стан, попередньо збережений за допомогою SAVE_GCODE_STATE. Якщо вказано "MOVE=1", буде виконано переміщення інструментальної головки для повернення до попередньої позиції XYZ. Якщо вказано "MOVE_SPEED", то переміщення інструментальної головки виконуватиметься із заданою швидкістю (у мм/с); інакше переміщення інструментальної головки використовуватиме відновлену швидкість g-коду.

### [generic_cartesian]

The commands in this section become automatically available when `kinematics: generic_cartesian` is specified as the printer kinematics.

#### SET_STEPPER_CARRIAGES

`SET_STEPPER_CARRIAGES STEPPER=<stepper_name> CARRIAGES=<carriages> [DISABLE_CHECKS=[0|1]]`: Set or update the stepper carriages. `<stepper_name>` must reference an existing stepper defined in `printer.cfg`, and `<carriages>` describes the carriages the stepper moves. See [Generic Cartesian Kinematics](Config_Reference.md#generic-cartesian-kinematics) for a more detailed overview of the `carriages` parameter in the stepper configuration section. Note that it is only possible to change the coefficients or signs of the carriages with this command, but a user cannot add or remove the carriages that the stepper controls.

`SET_STEPPER_CARRIAGES` is an advanced tool, and the user is advised to exercise an extreme caution using it, since specifying incorrect configuration may physically damage the printer.

Note that `SET_STEPPER_CARRIAGES` performs certain internal validations of the new printer kinematics after the change. Keep in mind that if it detects an issue, it may leave printer kinematics in an invalid state. This means that if `SET_STEPPER_CARRIAGES` reports an error, it is unsafe to issue other GCode commands, and the user must inspect the error message and either fix the problem, or manually restore the previous stepper(s) configuration.

Since `SET_STEPPER_CARRIAGES` can update a configuration of a single stepper at a time, some sequences of changes can lead to invalid intermediate kinematic configurations, even if the final configuration is valid. In such cases a user can pass `DISABLE_CHECKS=1` parameters to all but the last command to disable intermediate checks. For example, if `stepper a` and `stepper b` initially have `carriage_x-carriage_y` and `carriage_x+carriage_y` carriages correspondingly, then the following sequence of commands will let a user effectively swap the carriage controls: `SET_STEPPER_CARRIAGES STEPPER=a CARRIAGES=carriage_x+carriage_y DISABLE_CHECKS=1` and `SET_STEPPER_CARRIAGES STEPPER=b CARRIAGES=carriage_x-carriage_y`, while still validating the final kinematics state.

### [сенсор_ширини_нитки_холу]

Наступні команди доступні, коли ввімкнено [розділ конфігурації датчика ширини нитки tsl1401cl](Config_Reference.md#tsl1401cl_filament_width_sensor) або [розділ конфігурації датчика ширини нитки Холла](Config_Reference.md#hall_filament_width_sensor) (також див. [Датчик ширини нитки TSLl401CL]( TSL1401CL_Filament_Width_Sensor.md) і [Датчик ширини нитки Холла](Hall_Filament_Width_Sensor.md)):

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`: Return the current measured filament width, the state of the width sensor, the state of the filament sensor and the state of flow compensation.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`: Clear all sensor readings. Helpful after filament change. Resets flow rate to 100%.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`: Turn off the filament width sensor and stop using it for flow compensation. Resets flow rate to 100%.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR [FLOW_COMPENSATION=[0|1]`: Turn on the filament width sensor and enable or disable flow compensation. If `FLOW_COMPENSATION` is not specified, the current flow compensation state is preserved.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`: повертає поточні показники каналу АЦП і значення датчика RAW для точок калібрування.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`: увімкнути реєстрацію діаметра.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`: Вимкнути реєстрацію діаметра.

### [нагрівачі]

Модуль нагрівачів завантажується автоматично, якщо нагрівач визначено у файлі конфігурації.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`: Вимкнути всі обігрівачі.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: зачекайте, доки даний датчик температури не досягне або перевищить вказане МІНІМАЛЬНЕ значення та/або досягне або буде нижче заданого МАКСИМУМУ.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<heater_name> [TARGET=<target_temperature>]`: встановлює цільову температуру для обігрівача. Якщо цільова температура не вказана, цільове значення дорівнює 0.

### [idle_timeout]

Модуль idle_timeout завантажується автоматично.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: дозволяє користувачеві встановлювати час простою (у секундах).

### [input_shaper]

Наступну команду ввімкнено, якщо ввімкнено [розділ конфігурації input_shaper](Config_Reference.md#input_shaper) (також див. [посібник із компенсації резонансу](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [SHAPER_FREQ_Y=<shaper_freq_z>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [DAMPING_RATIO_Z=<damping_ratio_z>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>] [SHAPER_TYPE_Z=<shaper_type_z>]`: Modify input shaper parameters. Note that SHAPER_TYPE parameter resets input shaper for all axes even if different shaper types have been configured in [input_shaper] section. SHAPER_TYPE cannot be used together with any of SHAPER_TYPE_X, SHAPER_TYPE_Y, and SHAPER_TYPE_Z parameters. See [config reference](Config_Reference.md#input_shaper) for more details on each of these parameters.

### [під керівництвом]

Наступна команда доступна, коли ввімкнено будь-який із [розділів конфігурації світлодіодів](Config_Reference.md#leds).

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: це встановлює світлодіод вихід. Кожен колір "<value>" має бути від 0,0 до 1,0. Опція WHITE дійсна лише для світлодіодів RGBW. Якщо світлодіод підтримує кілька чіпів у послідовному з’єднанні, тоді можна вказати INDEX, щоб змінити колір лише даного чіпа (1 для першого чіпа, 2 для другого тощо). Якщо INDEX не надано, тоді всі світлодіоди в ланцюжку буде встановлено на наданий колір. Якщо вказано TRANSMIT=0, зміна кольору буде здійснена лише для наступної команди SET_LED, яка не вказує TRANSMIT=0; це може бути корисним у поєднанні з параметром INDEX для групування кількох оновлень у послідовному ланцюжку. За замовчуванням команда SET_LED синхронізує свої зміни з іншими поточними командами gcode. Це може призвести до небажаної поведінки, якщо світлодіоди встановлюються, коли принтер не друкує, оскільки це призведе до скидання часу простою. Якщо ретельний час не потрібен, можна вказати додатковий параметр SYNC=0, щоб застосувати зміни без скидання тайм-ауту простою.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<назва_індикатора> TEMPLATE=<назва_шаблону> [<параметр_x>=<літерал>] [INDEX=<індекс>]`: призначити [шаблон_дисплея](Config_Reference.md#шаблон_дисплея) заданому [світлодіодному](Config_Reference) .md#світлодіоди). Наприклад, якщо визначити розділ конфігурації`[display_template my_led_template]`, то тут можна призначити `TEMPLATE=my_led_template`. Display_template має створювати розділений комами рядок, що містить чотири числа з плаваючою комою, що відповідають параметрам червоного, зеленого, синього та білого кольорів. Шаблон буде постійно оцінюватися, і світлодіод автоматично встановлюватиметься на отримані кольори. Можна встановити параметри display_template для використання під час оцінки шаблону (параметри аналізуватимуться як літерали Python). Якщо INDEX не вказано, тоді всі мікросхеми в послідовному ланцюжку світлодіода будуть встановлені на шаблон, інакше буде оновлено лише мікросхему з заданим індексом. Якщо TEMPLATE є порожнім рядком, тоді ця команда очистить будь-який попередній шаблон, призначений світлодіодному індикатору (тоді можна використовувати команди `SET_LED` для керування параметрами кольору світлодіода).

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

The commands below are enabled if a [load_cell config section](Config_Reference.md#load_cell_probe) has been enabled.

In addition, commands that perform probes, such as [`PROBE`](#probe), [`PROBE_ACCURACY`](#probe_accuracy), [`BED_MESH_CALIBRATE`](#bed_mesh_calibrate) etc. will accept additional parameters if a `[load_cell_probe]` is defined. The parameters override the corresponding settings from the [`[load_cell_probe]`](./Config_Reference.md#load_cell_probe) configuration:

- `FORCE_SAFETY_LIMIT=<grams>`
- `TRIGGER_FORCE=<grams>`
- `DRIFT_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `DRIFT_FILTER_DELAY=<1|2>`
- `BUZZ_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `BUZZ_FILTER_DELAY=<1|2>`
- `NOTCH_FILTER_FREQUENCIES=<list of frequency_hz>`
- `NOTCH_FILTER_QUALITY=<quality>`
- `TARE_TIME=<seconds>`

### LOAD_CELL_TEST_TAP

`LOAD_CELL_TEST_TAP [TAPS=<taps>] [TIMEOUT=<timeout>]`: Run a testing routine that reports taps on the load cell. The toolhead will not move but the load cell probe will sense taps just as if it was probing. This can be used as a sanity check to make sure that the probe works. This tool replaces QUERY_ENDSTOPS and QUERY_PROBE for load cell probes.

- `TAPS`: the number of taps the tool expects
- `TIMEOOUT`: the time, in seconds, that the tool waits for each tab before aborting.

### [ручний_зонд]

Модуль manual_probe завантажується автоматично.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<швидкість>]`: запустіть допоміжний сценарій, корисний для вимірювання висоти сопла в заданому місці. Якщо вказано SPEED, він встановлює швидкість команд TESTZ (за замовчуванням 5 мм/с). Під час ручного тестування доступні такі додаткові команди:

- `ACCEPT`: Ця команда приймає поточну позицію Z і завершує ручний інструмент зондування.
- `ABORT`: ця команда завершує роботу інструменту ручного зондування.
- `TESTZ Z=<value>`: ця команда переміщує сопло вгору або вниз на величину, указану в «value». Наприклад, `TESTZ Z=-,1` перемістить сопло вниз на 0,1 мм, тоді як `TESTZ Z=,1` перемістить сопло вгору на 0,1 мм. Значення також може бути `+`, `-`, `++` або `--`, щоб перемістити сопло вгору або вниз на величину відносно попередніх спроб.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<швидкість>]`: запустіть допоміжний сценарій, корисний для калібрування параметра конфігурації Z position_endstop. Перегляньте команду MANUAL_PROBE, щоб дізнатися більше про параметри та додаткові команди, доступні, коли інструмент активний.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`: взяти поточне зміщення G-коду Z (він же babystepping) і відняти його від stepper_z endstop_position. Це діє, щоб прийняти часто використовуване значення babystepping і "зробити його постійним". Потрібен `SAVE_CONFIG`, щоб вступити в силу.

### [ручний_степпер]

Наступна команда доступна, якщо ввімкнено [розділ конфігурації manual_stepper](Config_Reference.md#manual_stepper).

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos>] [SYNC=0]]`: This command will alter the state of the stepper. Use the ENABLE parameter to enable/disable the stepper. Use the SET_POSITION parameter to force the stepper to think it is at the given position. Use the MOVE parameter to request a movement to the given position. If SPEED and/or ACCEL is specified then the given values will be used instead of the defaults specified in the config file. If an ACCEL of zero is specified then no acceleration will be performed. Normally future G-Code commands will be scheduled to run after the stepper move completes, however if a manual stepper move uses SYNC=0 then future G-Code movement commands may run in parallel with the stepper movement.

`MANUAL_STEPPER STEPPER=config_name [SPEED=<speed>] [ACCEL=<accel>] MOVE=<pos> STOP_ON_ENDSTOP=<check_type>`: If STOP_ON_ENDSTOP is specified then the move will end early if an endstop event occurs. The `STOP_ON_ENDSTOP` parameter may be set to one of the following values:

* `probe`: The movement will stop when the endstop reports triggered.
* `home`: The movement will stop when the endstop reports triggered and the final position of the manual_stepper will be set such that the trigger position matches the position specified in the `MOVE` parameter.
* `inverted_probe`, `inverted_home`: As above, however, the movement will stop when the endstop reports it is in a non-triggered state.
* `try_probe`, `try_inverted_probe`, `try_home`, `try_inverted_home`: As above, but no error will be reported if the movement fully completes without an endstop event stopping the move early.

`MANUAL_STEPPER STEPPER=config_name GCODE_AXIS=[A-Z] [LIMIT_VELOCITY=<velocity>] [LIMIT_ACCEL=<accel>] [INSTANTANEOUS_CORNER_VELOCITY=<velocity>]`: If the `GCODE_AXIS` parameter is specified then it configures the stepper motor as an extra axis on `G1` move commands. For example, if one were to issue a `MANUAL_STEPPER ... GCODE_AXIS=R` command then one could issue commands like `G1 X10 Y20 R30` to move the stepper motor. The resulting moves will occur synchronously with the associated toolhead xyz movements. If the motor is associated with a `GCODE_AXIS` then one may no longer issue movements using the above `MANUAL_STEPPER` command - one may unregister the stepper with a `MANUAL_STEPPER ... GCODE_AXIS=` command to resume manual control of the motor. The `LIMIT_VELOCITY` and `LIMIT_ACCEL` parameters allow one to reduce the speed of `G1` moves if those moves would result in a velocity or acceleration above the specified limits. The `INSTANTANEOUS_CORNER_VELOCITY` specifies the maximum instantaneous velocity change (in mm/s) of the motor during the junction of two moves (the default is 1mm/s).

### [mcp4018]

Наступна команда доступна, якщо ввімкнено [розділ конфігурації mcp4018](Config_Reference.md#mcp4018).

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: ця команда змінить поточне значення digipot. Зазвичай це значення має бути між 0,0 і 1,0, якщо в конфігурації не визначено «масштаб». Якщо визначено «масштаб», це значення має бути між 0,0 і «масштабом».

### [вихідний_контакт]

The following command is available when an [output_pin config section](Config_Reference.md#output_pin) or [pwm_tool config section](Config_Reference.md#pwm_tool) is enabled.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value>`: установіть PIN-код на заданий вихід `VALUE`. VALUE має бути 0 або 1 для «цифрових» вихідних контактів. Для контактів ШІМ встановіть значення від 0,0 до 1,0 або від 0,0 до `scale`, якщо масштаб налаштовано в розділі конфігурації output_pin.

`SET_PIN PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: якщо вказано `TEMPLATE`, тоді він призначає [display_template](Config_Reference.md#display_template) для вказаного PIN-коду. Наприклад, якщо ви визначили розділ конфігурації `[display_template my_pin_template]`, то тут можна призначити `TEMPLATE=my_pin_template`. Display_template має створити рядок, що містить число з плаваючою комою з потрібним значенням. Шаблон буде постійно оцінюватися, а пін-код автоматично встановлюватиметься на отримане значення. Можна встановити параметри display_template для використання під час оцінки шаблону (параметри аналізуватимуться як літерали Python). Якщо TEMPLATE є порожнім рядком, ця команда очистить будь-який попередній шаблон, призначений піну (тоді можна використовувати команди `SET_PIN` для безпосереднього керування значеннями).

### [палітра2]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації palete2](Config_Reference.md#palette2).

Друк палітри працює шляхом вбудовування спеціальних OCodes (Omega Codes) у файл GCode:

- `O1`...`O32`: ці коди зчитуються з потоку GCode, обробляються цим модулем і передаються на пристрій Palette 2.

Також доступні такі додаткові команди.

#### PALETTE_CONNECT

`PALETTE_CONNECT`: ця команда ініціалізує з’єднання з палітрою 2.

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`: ця команда від’єднується від палітри 2.

#### PALETTE_CLEAR

`PALETTE_CLEAR`: Ця команда наказує Palette 2 очистити всі вхідні та вихідні шляхи нитки.

#### PALETTE_CUT

`PALETTE_CUT`: ця команда дає вказівку Palette 2 розрізати нитку, яка наразі завантажена в осердя з’єднання.

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`: ця команда запускає інтелектуальну послідовність завантаження палітри 2. Нитка завантажується автоматично, видавлюючи її на відстань, відкалібровану на пристрої для принтера, і дає вказівки палітрі 2 після завершення завантаження. Ця команда схожа на натискання **Smart Load** безпосередньо на екрані Palette 2 після завершення завантаження нитки.

### [pause_resume]

Наступні команди доступні, коли ввімкнено [розділ конфігурації pause_resume](Config_Reference.md#pause_resume):

#### ПАУЗА

`PAUSE`: призупиняє поточний друк. Поточна позиція фіксується для відновлення після відновлення.

#### РЕЗЮМЕ

`RESUME [VELOCITY=<value>]`: відновлює друк із паузи, спочатку відновлюючи попередньо записану позицію. Параметр VELOCITY визначає швидкість, з якою інструмент має повернутися до початкового захопленого положення.

#### CLEAR_PAUSE

`CLEAR_PAUSE`: Очищає поточний призупинений стан без відновлення друку. Це корисно, якщо ви вирішите скасувати друк після ПАУЗИ. Рекомендовано додати це до вашого стартового gcode, щоб переконатися, що стан паузи є свіжим для кожного друку.

#### CANCEL_PRINT

`CANCEL_PRINT`: скасовує поточний друк.

### [pid_calibrate]

Модуль pid_calibrate завантажується автоматично, якщо нагрівач визначено у конфігураційному файлі.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`: Виконайте тест калібрування PID. Зазначений нагрівач буде ввімкнено, доки не буде досягнуто вказану цільову температуру, а потім нагрівач вимкнеться та ввімкнеться на кілька циклів. Якщо ввімкнути параметр WRITE_FILE, буде створено файл /tmp/heattest.txt із журналом усіх зразків температури, взятих під час тесту.

### [print_stats]

Модуль print_stats завантажується автоматично.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>] [CURRENT_LAYER= <current_layer>]`: передавати інформацію про зріз, як-от дію шару та підсумок, до Klipper. Додайте `SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>]` до розділу gcode початку слайсера та `SET_PRINT_STATS_INFO [CURRENT_LAYER= <current_layer>]` до розділу gcode зміни шару, щоб передати інформацію про шар із вашого слайсера до Klipper.

### [зонд]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації зонда](Config_Reference.md#probe) або [розділ конфігурації bltouch](Config_Reference.md#bltouch) (також див. [посібник з калібрування зонда](Probe_Calibrate.md)).

#### ЗОНД

`PROBE [PROBE_SPEED=<мм/с>] [LIFT_SPEED=<мм/с>] [SAMPLES=<кількість>] [SAMPLE_RETRACT_DIST=<мм>] [SAMPLES_TOLERANCE=<мм>] [SAMPLES_TOLERANCE_RETRIES=<кількість>] [SAMPLES_RESULT=медіана|середнє]`: перемістіть сопло вниз, доки не спрацює датчик. Якщо надається будь-який із додаткових параметрів, вони замінюють еквівалентне налаштування в [розділі конфігурації зонда](Config_Reference.md#probe).

#### QUERY_PROBE

`QUERY_PROBE`: Повідомити про поточний статус зонду ("запущений" або "відкритий").

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`: обчисліть максимальне, мінімальне, середнє, медіане та стандартне відхилення кількох зразків зонда. За замовчуванням береться 10 ЗРАЗКІВ. В іншому випадку додаткові параметри за умовчанням мають еквівалентні налаштування в розділі конфігурації зонда.

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<швидкість>] [<probe_parameter>=<значення>]`: запустіть допоміжний сценарій, корисний для калібрування z_offset зонда. Дивіться команду PROBE, щоб дізнатися про додаткові параметри зонду. Перегляньте команду MANUAL_PROBE, щоб дізнатися більше про параметр SPEED і додаткові команди, доступні, коли інструмент активний. Зауважте, що команда PROBE_CALIBRATE використовує змінну швидкості для переміщення в напрямку XY, а також у напрямку Z.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`: Візьміть поточне зміщення Z Gcode (він же babystepping) і відніміть його від z_offset зонда. Це діє, щоб прийняти часто використовуване значення babystepping і "зробити його постійним". Потрібен `SAVE_CONFIG`, щоб вступити в силу.

### [probe_eddy_current]

The commands below are available when a [probe_eddy_current config section](Config_Reference.md#probe_eddy_current) is enabled.

In addition, commands that perform probes, such as [`PROBE`](#probe), [`PROBE_ACCURACY`](#probe_accuracy), [`BED_MESH_CALIBRATE`](#bed_mesh_calibrate) etc. will accept additional parameters if a `[probe_eddy_current]` section is defined:

- `METHOD=<scan|rapid_scan|tap>`: This alters the probing mechanism:
   - `METHOD=scan`: The toolhead does not descend. Instead the toolhead will pause briefly above each target location and return the measured height at that position.
   - `METHOD=rapid_scan`: The toolhead does not descend and does not pause at each target location. The value returned is the measured height around the time that the toolhead was near each target position.
   - `METHOD=tap`: The toolhead will descend until the nozzle makes contact with the bed. This method is only available if `tap_threshold` is specified in the `[probe_eddy_current]` config section.
   - default: If no `METHOD` parameter is specified then the default behavior is for the toolhead to descend until the sensor detects that the distance to the bed is at or below the `z_offset` parameter specified in the `[probe_eddy_current]` config section.
- `SAMPLE_TIME=<time>`: When using `METHOD=scan` probing, this specifies the time (in seconds) to pause at each target point. When using `METHOD=rapid_scan` this specifies the measurement time window at each target. If not specified, the default is 0.100 (which is 100ms).
- `TAP_THRESHOLD=<value>`: This overrides the `tap_threshold` specified in the `[probe_eddy_current]` config section when probing using `METHOD=tap`.

The `Z_OFFSET_APPLY_PROBE` command is also extended to support a `METHOD=tap` parameter. When no METHOD parameter is provided, the `Z_OFFSET_APPLY_PROBE` command alters the probe calibration to apply the current Z G-Code offset to future `scan`, `rapid_scan`, and default probes. If `METHOD=tap` is specified then the command instead applies the change to `tap_z_offset` so that future `tap` probes are updated to use the current Z G-Code offset.

#### PROBE_EDDY_CURRENT_CALIBRATE

`PROBE_EDDY_CURRENT_CALIBRATE CHIP=<config_name>`: це запускає інструмент, який калібрує резонансні частоти датчика відповідно до висот Z. Інструменту знадобиться кілька хвилин, щоб завершити роботу. Після завершення скористайтеся командою SAVE_CONFIG, щоб зберегти результати у файлі printer.cfg.

#### PROBE_EDDY_CURRENT_TAP_CALIBRATE

`PROBE_EDDY_CURRENT_TAP_CALIBRATE [TAP=guess|refine|verify]`: This starts a tool that can calibrate the probe's "tap_threshold" parameter. See the [eddy probe documentation](Eddy_Probe.md#tap-calibration) for details.

#### LDC_CALIBRATE_DRIVE_CURRENT

`LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` Цей інструмент відкалібрує регістр ldc1612 DRIVE_CURRENT0. Перед використанням цього інструменту перемістіть датчик так, щоб він знаходився біля центру ліжка та приблизно на 20 мм над поверхнею ліжка. Виконайте цю команду, щоб визначити відповідний DRIVE_CURRENT для датчика. Після виконання цієї команди використовуйте команду SAVE_CONFIG, щоб зберегти цей новий параметр у файлі конфігурації printer.cfg.

### [pwm_cycle_time]

Наступна команда доступна, коли ввімкнено [розділ конфігурації pwm_cycle_time](Config_Reference.md#pwm_cycle_time).

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: ця команда працює подібно до команд [output_pin](#output_pin) SET_PIN. Ця команда підтримує встановлення явного часу циклу за допомогою параметра CYCLE_TIME (вказаного в секундах). Зверніть увагу, що параметр CYCLE_TIME не зберігається між командами SET_PIN (будь-яка команда SET_PIN без явного параметра CYCLE_TIME використовуватиме `cycle_time', указаний у розділі конфігурації pwm_cycle_time).

### [quad_gantry_level]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації quad_gantry_level](Config_Reference.md#quad_gantry_level).

#### QUAD_GANTRY_LEVEL

`QUAD_GANTRY_LEVEL [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: ця команда досліджуватиме точки, зазначені в конфігурації, а потім здійснюватиме незалежні коригування кожного кроку Z для компенсації нахилу. Дивіться команду PROBE, щоб дізнатися про додаткові параметри зонду. Додаткові значення `RETRIES`, `RETRY_TOLERANCE` і `HORIZONTAL_MOVE_Z` замінюють параметри, указані у файлі конфігурації.

### [query_adc]

Модуль query_adc завантажується автоматично.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]`: звіт про останнє отримане аналогове значення для налаштованого аналогового контакту. Якщо NAME не вказано, повідомляється список доступних імен adc. Якщо надається PULLUP (як значення в Омах), повідомляється необроблене аналогове значення разом із еквівалентним опором, враховуючи, що підтягування.

### [query_endstops]

Модуль query_endstops завантажується автоматично. Наразі доступні наступні стандартні команди G-коду, але використовувати їх не рекомендується:

- Отримати статус кінцевої зупинки: `M119` (використовуйте замість цього QUERY_ENDSTOPS.)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`: перевірте кінцеві упори осі та повідомте, чи вони "спрацьовані" чи перебувають у "відкритому" стані. Ця команда зазвичай використовується для перевірки правильності роботи кінцевого упору.

### [resonance_tester]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації resonance_tester](Config_Reference.md#resonance_tester) (також див. [посібник із вимірювання резонансів](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: Вимірює та виводить шум для всіх осей усіх увімкнених мікросхем акселерометра.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> [OUTPUT=<resonances,raw_data>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [POINT=x,y,z] [INPUT_SHAPING=<0:1>]`: Runs the resonance test in all configured probe points for the requested "axis" and measures the acceleration using the accelerometer chips configured for the respective axis. "axis" can either be X, Y or Z, or specify an arbitrary direction as `AXIS=dx,dy[,dz]`, where dx, dy, dz are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction in XY plane, or `AXIS=0,1,1` to define a direction in YZ plane). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. `chip_name` can be one or more configured accel chips, delimited with comma, for example `CHIPS="adxl345, adxl345 rpi"`. If POINT is specified it will override the point(s) configured in `[resonance_tester]`. If `INPUT_SHAPING=0` or not set(default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured or POINT is specified). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>][HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [MAX_SMOOTHING=<max_smoothing>] [INPUT_SHAPING=<0:1>]`: подібно до `TEST_RESONANCES`, запускає резонансний тест, як налаштовано, і намагається знайти оптимальні параметри для формувача вхідних даних для запитуваної осі (або обох осей X і Y, якщо параметр `AXIS` не встановлено). Якщо `MAX_SMOOTHING` не встановлено, його значення береться з розділу `[resonance_tester]`, а значення за замовчуванням не встановлено. Див. [Максимальне згладжування](Measuring_Resonances.md#max-smoothing) посібника з вимірювання резонансів, щоб дізнатися більше про використання цієї функції. Результати налаштування друкуються на консолі, а частотні характеристики та різні значення формувачів вхідних даних записуються у файл(и) CSV `/tmp/calibration_data_<axis>_<name>.csv`. Якщо не вказано, NAME за умовчанням використовує поточний час у форматі "РРРРММДД_ГГММСС". Зверніть увагу, що запропоновані параметри формувача вводу можна зберегти в конфігурації, виконавши команду `SAVE_CONFIG`, і якщо `[input_shaper]` було вже ввімкнено раніше, ці параметри набувають чинності негайно.

### [відповісти]

Наступні стандартні команди G-Code доступні, якщо ввімкнено [розділ конфігурації відповідей](Config_Reference.md#respond):

- `M118 <message>`: повторити повідомлення, перед яким налаштований префікс за умовчанням (або `echo:`, якщо префікс не налаштовано).

Також доступні такі додаткові команди.

#### ВІДПОВІСТИ

- `RESPOND MSG="<message>"`: повторити повідомлення, перед яким налаштовано налаштований префікс за замовчуванням (або `echo:`, якщо префікс не налаштовано).
- `RESPOND TYPE=echo MSG="<message>"`: повторити повідомлення, перед яким стоїть `echo:`.
- `RESPOND TYPE=echo_no_space MSG="<message>"`: повторити повідомлення, до якого додано `echo:` без пробілу між префіксом і повідомленням, корисно для сумісності з деякими плагінами octoprint, які очікують дуже специфічного форматування.
- `RESPOND TYPE=команда MSG="<message>"`: повторити повідомлення, перед яким стоїть `// `. OctoPrint можна налаштувати для відповіді на ці повідомлення (наприклад, `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<message>"`: повторити повідомлення, перед яким стоїть `!! `.
- `RESPOND PREFIX=<prefix> MSG="<message>"`: повторити повідомлення, перед яким стоїть `<префікс>`. (Параметр `PREFIX` матиме пріоритет над параметром `TYPE`)

### [зберегти_змінні]

Наступну команду ввімкнено, якщо ввімкнено [розділ конфігурації save_variables](Config_Reference.md#save_variables).

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`: Saves the variable to disk so that it can be used across restarts. The VARIABLE must be lowercase. All stored variables are loaded into the `printer.save_variables.variables` dict at startup and can be used in gcode macros. The provided VALUE is parsed as a Python literal.

### [screws_tilt_adjust]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації screws_tilt_adjust](Config_Reference.md#screws_tilt_adjust) (також див. [посібник з ручного рівня](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe))).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Ця команда викличе інструмент регулювання кріпильних гвинтів. Він надсилатиме команди насадці в різні місця (як визначено у конфігураційному файлі), досліджуючи висоту z і обчислюючи кількість обертів ручки для регулювання рівня ліжка. Якщо вказано DIRECTION, обертання ручки відбуватиметься в одному напрямку, за годинниковою стрілкою (CW) або проти годинникової стрілки (CCW). Дивіться команду PROBE, щоб дізнатися про додаткові параметри зонду. ВАЖЛИВО: Ви ПОВИННІ завжди виконувати G28 перед використанням цієї команди. Якщо вказано MAX_DEVIATION, команда викличе помилку gcode, якщо будь-яка різниця у висоті гвинта відносно висоти базового гвинта перевищує вказане значення. Додаткове значення `HORIZONTAL_MOVE_Z` замінює параметр `horizontal_move_z`, указаний у файлі конфігурації.

### [sdcard_loop]

Коли [розділ конфігурації sdcard_loop](Config_Reference.md#sdcard_loop) увімкнено, доступні такі розширені команди.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`: початок зацикленого розділу в SD-друкі. Лічильник, рівний 0, вказує на те, що розділ має бути зациклений на невизначений термін.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: завершує зациклену секцію на SD-друкі.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: завершити існуючі цикли без подальших ітерацій.

### [серво]

Наступні команди доступні, коли ввімкнено [розділ конфігурації сервосистеми](Config_Reference.md#servo).

#### SET_SERVO

`SET_SERVO SERVO=config_name [ANGLE=<градуси> | WIDTH=<seconds>]`: установіть позицію сервоприводу відповідно до заданого кута (у градусах) або ширини імпульсу (у секундах). Використовуйте `WIDTH=0`, щоб вимкнути вихід сервоприводу.

### [виправлення перекосу]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації skew_correction](Config_Reference.md#skew_correction) (також див. посібник [Skew Correction](Skew_Correction.md).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`: налаштовує [перекос ] модуль із розмірами (у мм), взятими з калібрувального відбитка. Можна ввести вимірювання для будь-якої комбінації площин, невведені площини збережуть своє поточне значення. Якщо введено `CLEAR=1`, усі виправлення перекосів буде вимкнено.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: повідомляє про поточний перекіс принтера для кожної площини в радіанах і градусах. Перекіс обчислюється на основі параметрів, наданих через gcode `SET_SKEW`.

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>]`: обчислює та повідомляє перекіс (у радіанах і градусах) на основі виміряного відбитка. Це може бути корисним для визначення поточного перекосу принтера після застосування корекції. Це також може бути корисним перед застосуванням корекції, щоб визначити, чи потрібна корекція перекосу. Перегляньте [Корекція перекосу] (Skew_Correction.md) для отримання докладної інформації про об’єкти калібрування перекосу та вимірювання.

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<name>] [SAVE=<name>] [REMOVE=<name>]`: Керування профілем для skew_correction. LOAD відновить спотворений стан із профілю, що відповідає наданій назві. SAVE збереже поточний стан перекосу в профілі, що відповідає наданій назві. Видалити видалить профіль, який відповідає наданому імені, із постійної пам’яті. Зауважте, що після виконання операцій SAVE або REMOVE потрібно запустити gcode SAVE_CONFIG, щоб зробити зміни в постійній пам’яті постійними.

### [smart_effector]

Кілька команд доступні, якщо ввімкнено [розділ конфігурації smart_effector](Config_Reference.md#smart_effector). Обов’язково перевірте офіційну документацію для Smart Effector на [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer), перш ніж змінювати параметри Smart Effector. Також перегляньте [посібник з калібрування зонда](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<чутливість>] [ACCEL=<прискорення>] [RECOVERY_TIME=<час>]`: установіть параметри Smart Effector. Якщо вказано `SENSITIVITY`, відповідне значення записується в SmartEffector EEPROM (потрібно вказати `control_pin`). Прийнятні значення `<чутливості>`: 0..255, за замовчуванням 50. Нижчі значення вимагають меншої сили контакту сопла для спрацьовування (але існує більший ризик помилкового спрацьовування через вібрацію під час зондування), а вищі значення зменшують помилкове спрацьовування (але потрібна більша контактна сила для спрацьовування). Оскільки чутливість записується в EEPROM, вона зберігається після вимкнення, тому її не потрібно налаштовувати під час кожного запуску принтера. `ACCEL` і `RECOVERY_TIME` дозволяють замінити відповідні параметри під час виконання; див. [розділ конфігурації](Config_Reference.md#smart_effector) Smart Effector, щоб отримати додаткові відомості про ці параметри.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`: скидає чутливість Smart Effector до заводських налаштувань. У розділі конфігурації потрібно вказати `control_pin`.

### [stepper_enable]

Модуль stepper_enable завантажується автоматично.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<config_name> ENABLE=[0|1]`: увімкнути або вимкнути лише вказаний степер. Це інструмент діагностики та налагодження, яким слід користуватися обережно. Вимкнення двигуна осі не скидає інформацію про вихід. Ручне переміщення вимкненого степера може призвести до того, що машина працюватиме двигуном поза безпечними межами. Це може призвести до пошкодження компонентів осі, гарячих кінців і поверхні друку.

### [temperature_fan]

Наступна команда доступна, якщо ввімкнено [розділ конфігурації temperatur_fan](Config_Reference.md#temperature_fan).

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>] [max_speed=<max_speed>]`: встановлює цільову температуру для temperature_fan. Якщо ціль не вказано, для нього встановлюється температура, указана у файлі конфігурації. Якщо швидкості не вказано, зміни не застосовуються.

### [temperature_probe]

Наступні команди доступні, коли ввімкнено [розділ конфігурації temperature_probe](Config_Reference.md#temperature_probe).

#### TEMPERATURE_PROBE_CALIBRATE

`TEMPERATURE_PROBE_CALIBRATE [PROBE=<probe name>] [TARGET=<value>] [STEP=<value>] [METHOD=<method>]`: Initiates probe drift calibration for eddy current based probes. The `TARGET` is a target temperature for the last sample. When the temperature recorded during a sample exceeds the `TARGET` calibration will complete. The `STEP` parameter sets temperature delta (in C) between samples. After a sample has been taken, this delta is used to schedule a call to `TEMPERATURE_PROBE_NEXT`. The default `STEP` is 2. The `METHOD` only supports `tap` as an option, if specified, probing will be automated.

#### TEMPERATURE_PROBE_NEXT

`TEMPERATURE_PROBE_NEXT`: після початку калібрування виконується ця команда для взяття наступного зразка. Його запуск автоматично заплановано, коли досягнуто дельта, визначену `STEP`, однак цю команду також можна запустити вручну, щоб примусово створити новий зразок. Ця команда доступна лише під час калібрування.

#### TEMPERATURE_PROBE_COMPLETE:

`TEMPERATURE_PROBE_COMPLETE`: можна використовувати для завершення калібрування та збереження поточного результату до досягнення температури `TARGET`. Ця команда доступна лише під час калібрування.

#### ПЕРЕРАТИ

`ABORT`: перериває процес калібрування, відкидаючи поточні результати.  Ця команда доступна лише під час калібрування дрейфу.

### TEMPERATURE_PROBE_ENABLE

`TEMPERATURE_PROBE_ENABLE ENABLE=[0|1]`: вмикає або вимикає компенсацію дрейфу температури. Якщо ENABLE встановлено на 0, компенсація дрейфу буде вимкнена, якщо встановлено на 1, вона ввімкнена.

### [tmcXXXX]

Наступні команди доступні, якщо ввімкнено будь-який із [розділів конфігурації tmcXXXX](Config_Reference.md#tmc-stepper-driver-configuration).

#### DUMP_TMC

`DUMP_TMC STEPPER=<ім'я> [REGISTER=<ім'я>]`: ця команда читатиме всі регістри драйверів TMC і повідомлятиме їхні значення. Якщо надано REGISTER, буде створено лише вказаний реєстр.

#### INIT_TMC

`INIT_TMC STEPPER=<name>`: ця команда ініціалізує регістри TMC. Необхідно повторно ввімкнути драйвер, якщо живлення чіпа вимкнуто, а потім знову ввімкніть.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: це регулює струми запуску та утримання драйвера TMC. `HOLDCURRENT` не застосовується до драйверів tmc2660. Якщо використовується на драйвері, який має поле `globalscaler` (tmc5160 і tmc2240), якщо використовується StealthChop2, кроковий кроковий механізм потрібно утримувати в стані зупинки понад 130 мс, щоб драйвер виконав калібрування AT#1.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<ім'я> FIELD=<поле> VALUE=<значення> VELOCITY=<значення>`: це змінить значення вказаного поля реєстру драйвера TMC. Ця команда призначена лише для низькорівневої діагностики та налагодження, оскільки зміна полів під час виконання може призвести до небажаної та потенційно небезпечної поведінки вашого принтера. Натомість постійні зміни слід вносити за допомогою файлу конфігурації принтера. Для наведених значень перевірки на працездатність не виконуються. Замість VALUE також можна вказати VELOCITY. Ця швидкість перетворюється на 20-бітне представлення значення на основі TSTEP. Використовуйте аргумент ШВИДКІСТЬ лише для полів, які представляють швидкості.

### [насадка]

Модуль інструментальної головки завантажується автоматично.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<значення>] [ACCEL=<значення>] [MINIMUM_CRUISE_RATIO=<значення>] [SQUARE_CORNER_VELOCITY=<значення>]`: ця команда може змінити обмеження швидкості, указані у файлі конфігурації принтера. Опис кожного параметра див. у [розділі конфігурації принтера](Config_Reference.md#printer).

### [tuning_tower]

Модуль tuning_tower завантажується автоматично.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<команда> PARAMETER=<ім'я> START=<значення> [SKIP=<значення>] [FACTOR=<значення> [BAND=<значення>]] | [STEP_DELTA=<значення> STEP_HEIGHT=<значення>]`: інструмент для налаштування параметра для кожної висоти Z під час друку. Інструмент виконає задану `КОМАНДУ` із заданим `ПАРАМЕТРОМ`, призначеним для значення, яке змінюється в залежності від `Z` відповідно до формули. Використовуйте `FACTOR`, якщо ви будете використовувати лінійку або штангенциркуль для вимірювання висоти Z оптимального значення, або `STEP_DELTA` і `STEP_HEIGHT`, якщо модель вежі налаштування має смуги дискретних значень, як це зазвичай буває для веж температур. Якщо вказано `SKIP=<value>`, процес налаштування не починається, доки не буде досягнуто Z висоти `<value>`, а нижче цього значення буде встановлено на `START`; у цьому випадку «z_height», що використовується у формулах нижче, насправді є «max(z - пропуск, 0)». Є три можливі комбінації варіантів:

- `FACTOR`: значення змінюється зі швидкістю `factor` на міліметр. Використовується така формула: «значення = початок + коефіцієнт * z_висота». Ви можете включити оптимальну висоту Z безпосередньо у формулу, щоб визначити оптимальне значення параметра.
- `FACTOR` і `BAND`: значення змінюється із середньою швидкістю `factor` на міліметр, але в окремих діапазонах, де коригування здійснюватиметься лише через кожні `BAND` міліметри висоти Z. Використовується така формула: «значення = початок + коефіцієнт * ((поверх(z_висота / діапазон) + .5) * діапазон)».
- `STEP_DELTA` і `STEP_HEIGHT`: значення змінюється на `STEP_DELTA` кожні `STEP_HEIGHT` міліметрів. Використовується така формула: `value = start + step_delta * floor(z_height / step_height)`. Щоб визначити оптимальне значення, ви можете просто порахувати діапазони або прочитати етикетки настроювальних веж.

### [virtual_sdcard]

Klipper підтримує такі стандартні команди G-Code, якщо ввімкнено [розділ конфігурації virtual_sdcard](Config_Reference.md#virtual_sdcard):

- Список SD-карт: `M20`
- Ініціалізація SD-карти: `M21`
- Виберіть файл SD: `M23 <filename>`
- Початок/відновлення друку SD: `M24`
- Призупинити друк SD: `M25`
- Установіть позицію SD: `M26 S<offset>`
- Повідомити про стан друку SD: `M27`

Крім того, наведені нижче розширені команди доступні, якщо ввімкнено розділ конфігурації "virtual_sdcard".

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<ім'я файлу>`: завантажте файл і почніть друк SD.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`: вивантажити файл і очистити стан SD.

### [z_thermal_adjust]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації z_thermal_adjust](Config_Reference.md#z_thermal_adjust).

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<значення>] [REF_TEMP=<значення>]`: увімкнути або вимкнути температурне регулювання Z за допомогою `ENABLE`. Вимкнення не видаляє будь-які вже застосовані коригування, але призведе до заморожування поточного значення коригування - це запобігає потенційно небезпечному руху вниз по Z. Повторне ввімкнення потенційно може призвести до переміщення інструмента вгору під час оновлення та застосування коригування. `TEMP_COEFF` дозволяє налаштовувати температурний коефіцієнт налаштування під час виконання (тобто параметр конфігурації `TEMP_COEFF`). Значення `TEMP_COEFF` не зберігаються в конфігурації. `REF_TEMP` вручну змінює еталонну температуру, яка зазвичай встановлюється під час повернення до початкової точки (для використання, наприклад, у нестандартних процедурах повернення до початкової точки) – буде скинуто автоматично після повернення до початкової точки.

### [z_tilt]

Наступні команди доступні, якщо ввімкнено [розділ конфігурації z_tilt](Config_Reference.md#z_tilt).

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: ця команда перевірить точки, зазначені в конфігурації, а потім зробить незалежне коригування кожного кроку Z для компенсації нахилу. Дивіться команду PROBE, щоб дізнатися про додаткові параметри зонду. Додаткові значення `RETRIES`, `RETRY_TOLERANCE` і `HORIZONTAL_MOVE_Z` замінюють параметри, указані у файлі конфігурації.
