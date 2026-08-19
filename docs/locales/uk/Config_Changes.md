# Зміни конфігурації

Цей документ охоплює останні зміни програмного забезпечення у файлі конфігурації, які не є зворотно сумісними. Бажано переглянути цей документ під час оновлення програмного забезпечення Klipper.

Усі дати в цьому документі є приблизними.

## Зміни

20260525: The internal implementation of "probe:z_virtual_endstop" has changed. Most users will not observe a change in behavior. Previously it was technically possible to mix "probe:z_virtual_endstop" with other types of Z endstops and this behavior is no longer valid.

20260501: The handling of the `[probe_eddy_current]` `tap_threshold` config option and associated `TAP_THRESHOLD` G-Code parameter has changed. It will be necessary to recalibrate the value. See the [eddy probe documentation](Eddy_Probe.md) for calibration directions.

20260408: The script `lib/canboot/flash_can.py` has been updated to the most current version from [Katapult](https://github.com/Arksine/katapult) and as such renamed to `lib/katapult/flashtool.py`. If you call this script directly instead of using the existing Makefiles, you will need to change the path to the script to `lib/katapult/flashtool.py`.

20260318: The `[probe_eddy_current]` config options `speed`, `lift_speed`, `samples`, `sample_retract_dist`, `samples_result`, `samples_tolerance`, and `samples_tolerance_retries` no longer apply to probe commands using `METHOD=scan`, `METHOD=rapid_scan`, nor `METHOD=tap`. To use different settings, supply the equivalent `PROBE_SPEED`, `LIFT_SPEED`, `SAMPLES`, `SAMPLE_RETRACT_DIST`, `SAMPLES_RESULT`, `SAMPLES_TOLERANCE`, or `SAMPLES_TOLERANCE_RETRIES` parameter with the probe command.

20260318: The `[probe_eddy_current]` config option `z_offset` has been renamed to `descend_z`. Using the old name is deprecated and it will be removed in the near future.

20260214: The `MANUAL_STEPPER` G-Code command `STOP_ON_ENDSTOP` parameter has changed. See the [MANUAL_STEPPER](G-Codes.md#manual_stepper) documentation for details. Using the previous integer values (-2, -1, 1, 2) is deprecated and support will be removed in the near future.

20260207: The low-level i2c behavior of sx1509 and uc1701 devices has changed. Previously an i2c error would result in a shutdown, and now i2c errors when communicating with these devices will only generate warnings in the log file.

20260109: The status value `{printer.probe.last_z_result}` is deprecated; it will be removed in the near future. Use `{printer.probe.last_probe_position}` instead, and note that this new value already has the probe's configured xyz offsets applied.

20260109: The g-code console text output from the `PROBE`, `PROBE_ACCURACY`, and similar commands has changed. Now Z heights are reported relative to the nominal bed Z position instead of relative to the probe's configured `z_offset`. Similarly, intermediate probe x and y console reports will also have the probe's configured `x_offset` and `y_offset` applied.

20260109: The `[screws_tilt_adjust]` module now reports the status variable `{printer.screws_tilt_adjust.result.screw1.z}` with the probe's `z_offset` applied. That is, one would previously need to subtract the probe's configured `z_offset` to find the absolute Z deviation at the given screw location and now one must not apply the `z_offset`.

20251122: An option `axis` has been added to `[carriage <name>]` sections for `generic_cartesian` kinematics, allowing arbitrary names for primary carriages. Users are encouraged to explicitly specify `axis` option now.

20251106: The status fields `{printer.toolhead.position}`, `{printer.gcode_move.position}`, `{printer.gcode_move.gcode_position}`, and `{printer.motion_report.live_position}` are changing. These coordinates used to always contain four components, but now may contain additional components. The ordering and number of components may change at run-time - see the [status reference](Status_Reference.md#accessing-coordinates) for important details. Accessing any of these coordinates in macros using the ".e" accessor is deprecated - use something like `{printer.toolhead.position[printer.gcode_move.axis_map.E]}` as an alternative.

20251106: The status fields `{printer.gcode_move.homing_origin}`, `{printer.toolhead.axis_min}`, and `{printer.toolhead.axis_max}` currently contain four components where the fourth component is always zero. This behavior is deprecated. In the future these coordinates may contain only three components. For additional information see the [status reference](Status_Reference.md#accessing-coordinates).

20251010: During normal printing the command processing will now attempt to stay one second ahead of printer movement (reduced from two seconds previously).

20251003: Support for the undocumented `max_stepper_error` option in the `[printer]` config section has been removed.

20250916: The definitions of EI, 2HUMP_EI, and 3HUMP_EI input shapers were updated. For best performance it is recommended to recalibrate input shapers, especially if some of these shapers are currently used.

20250811: Support for the `max_accel_to_decel` parameter in the `[printer]` config section has been removed and support for the `ACCEL_TO_DECEL` parameter in the `SET_VELOCITY_LIMIT` command has been removed. These capabilities were deprecated on 20240313.

20250721: The `[pca9632]` and `[mcp4018]` modules no longer accept the `scl_pin` and `sda_pin` options. Use `i2c_software_scl_pin` and `i2c_software_sda_pin` instead.

20250428: The maximum `cycle_time` for pwm `[output_pin]`, `[pwm_cycle_time]`, `[pwm_tool]`, and similar config sections is now 3 seconds (reduced from 5 seconds). The `maximum_mcu_duration` in `[pwm_tool]` is now also 3 seconds.

20250418: The manual_stepper `STOP_ON_ENDSTOP` feature may now take less time to complete. Previously, the command would wait the entire time the move could possibly take even if the endstop triggered earlier. Now, the command finishes shortly after the endstop trigger.

20250417: SPI devices using "software SPI" are now rate limited. Previously, the `spi_speed` in the config was ignored and the transmission speed was only limited by the processing speed of the micro-controller. Now, speeds are limited by the `spi_speed` config parameter (actual hardware speeds are likely to be lower than the configured value due to software overhead).

20250411: Klipper v0.13.0 released.

20250308: The `AUTO` parameter of the `AXIS_TWIST_COMPENSATION_CALIBRATE` command has been removed.

20250131: Option `VARIABLE=<name>` in `SAVE_VARIABLE` requires lowercase value. For example, `extruder` instead of mixedcase `Extruder` or uppercase `EXTRUDER`. Using any uppercase letter will raise an error.

20241203: перевірку резонансу було змінено, щоб включити повільні розгортаючі рухи. Ця зміна вимагає, щоб точки тестування мали певний зазор у площині X/Y (+/- 30 мм від точки тестування має бути достатньо, якщо використовуються налаштування за замовчуванням). Новий тест, як правило, повинен дати точніші та надійніші результати тестування. Однак, якщо потрібно, попередню поведінку тесту можна відновити, додавши параметри `sweeping_period: 0` і `accel_per_hz: 75` до розділу конфігурації `[resonance_tester]`.

20241201: у деяких випадках Klipper міг проігнорувати початкові символи або пробіли в традиційній команді G-коду. Наприклад, «99M123» могло бути інтерпретовано як «M123», а «M 321» могло бути інтерпретовано як «M321». Klipper тепер повідомлятиме про ці випадки з попередженням «Невідома команда».

20241112: параметр `CHIPS=<назва_чіпа>` в `TEST_RESONANCES` і `SHAPER_CALIBRATE` вимагає вказувати повну назву(на) чіпа(ів) прискорення. Наприклад, `adxl345 rpi` замість короткого імені - `rpi`.

20240912: `SET_PIN`, `SET_SERVO`, `SET_FAN_SPEED`, `M106`, and `M107` commands are now collated. Previously, if many updates to the same object were issued faster than the minimum scheduling time (typically 100ms) then actual updates could be queued far into the future. Now if many updates are issued in rapid succession then it is possible that only the latest request will be applied. If the previous behavior is required then consider adding explicit `G4` delay commands between updates.

20240912: вилучено підтримку параметрів `maximum_mcu_duration` і `static_value` у розділах конфігурації `[output_pin]`. Ці параметри застаріли з 2024 0123.

20240415: параметр `on_error_gcode` в параметрі `[virtual_sdcard]` config розділ тепер має за замовчуванням. Якщо цей параметр не вказаний зараз за замовчуванням до `TURN_OFF_HEATERS`. Якщо попередня поведінка є бажаною (застосуйте не дію за замовчуванням на помилку під час віртуального друку_sdcard) потім визначте `on_error_gcode` з порожньою вартістю.

20240313: параметр `max_accel_to_decel` у розділі `[printer]` було вилучено. `ACCEL_TO_DECEL` параметр `SET_VELOCITY_LIMIT` команда була розшифрована. `printer.toolhead.max_accel_to_decel` було вилучено статус. Використовуйте параметр [minimum_cruise_ratio](./Config_Reference.md#printer) замість. Відхилені функції будуть видалені в найближчому майбутньому, і використовуючи їх в проміжному режимі може призвести до того, що не відрізняється поведінкою.

20240215: було видалено декілька депресованих функцій. За допомогою "NTC 100K beta 3950" в якості ім'я аристора було вилучено (прийнято на 20211110). `SYNC_STEPPER_TO_EXTRUDER` і `SET_EXTRUDER_STEP_DISTANCE` команди були видалені, а екструддер `shared_heater` опція конфігурації була вилучена (депресована 20220210). The Bed_mesh `relative_reference_index` був видалений варіант (депресований 20230619).

20240123: Видалено вихід_pin SET_PIN CYCLE_TIME. Використовуйте новий модуль [pwm_cycle_time](Config_Reference.md#pwm_cycle_time) якщо необхідно динамічно змінити час циклу pwm.

20240123: Вихід_pin `maximum_mcu_duration` параметр відхилений. Використовуйте [pwm_tool config розділ](Config_Reference.md#pwm_tool) замість. Опція буде видалена найближчим часом.

20240123: Вихід_pin `static_value` параметр відхилений. `value` і `shutdown_value` параметри. Опція буде видалена найближчим часом.

20231216: The `[hall_filament_width_sensor]` is changed to trigger filament runout when the thickness of the filament exceeds `max_diameter`. The maximum diameter defaults to `default_nominal_filament_diameter + max_difference`. See [[hall_filament_width_sensor] configuration
reference](./Config_Reference.md#hall_filament_width_sensor) for more details.

20231207: Кілька недокументованих параметрів конфігурації в параметрах `[printer]` видалено розділ конфігурації (buffer_time_low, buffer_time_high, buffer_time_start, and switch_flush_time параметри).

20231110: Klipper v0.12.0 випущено.

20230826: якщо `safe_distance` встановлено або розраховано як 0 у `[dual_carriage]`, перевірки близькості вагонів буде вимкнено відповідно до документації. Користувач може забажати налаштувати `safe_distance` явно, щоб запобігти випадковим зіткненням вагонів один з одним. Крім того, у деяких конфігураціях змінюється порядок переміщення основної та подвійної кареток (у деяких конфігураціях, коли обидві каретки рухаються в одному напрямку, див. [[dual_carriage] довідник щодо конфігурації](./Config_Reference.md#dual_carriage) для отримання додаткової інформації) .

20230810: Флеш-sdcard.sh скрипт тепер підтримує як варіанти Bigtreetech SKR-3, STM32H743 і STM32H723. Для цього оригінальний тег btt-skr-3 тепер змінився як btt-skr-3-h743 або btt-skr-3-h723.

20230729: Змінено експортований статус `dual_carriage`. замість експорту `mode` і `active_carriage`, окремі режими для кожного перевезення експортуються як `printer.dual_carriage.carriage_0` і `printer.dual_carriage.carriage_1`.

20230619: The `relative_reference_index` option has been deprecated and superseded by the `zero_reference_position` option. Refer to the [Bed Mesh Documentation](./Bed_Mesh.md#the-deprecated-relative_reference_index) for details on how to update the configuration. With this deprecation the `RELATIVE_REFERENCE_INDEX` is no longer available as a parameter for the `BED_MESH_CALIBRATE` gcode command.

20230530: Частота за замовчуванням в "зробити налаштування меню" тепер 1000000. Якщо використовувати канбус і за допомогою канбуса з деякими іншими частотами, то обов'язково виберіть «Включені додаткові опції конфігурації низького рівня» і вкажіть бажану «CAN автобусну швидкість» в «зробити меню налаштування», коли компіляція і миготливий мікроконтролер.

20230525: `SHAPER_CALIBRATE` команда відразу ж застосовує параметри вводу, якщо `[input_shaper]` була включена вже.

20230407: `stalled_bytes` лічильник в колоді і в `printer.mcu.last_stats` поле перейменовано на `upcoming_bytes`.

20230323: На драйверах tmc5160 `multistep_filt` тепер включений за замовчуванням. Набір `driver_MULTISTEP_FILT: False` в tmc5160 настройка для попередньої поведінки.

20230304: The `SET_TMC_CURRENT` тепер належним чином регулює глобальний рейтинг для водіїв, які мають його. Це видаляє обмеження, де на tmc5160, струми не можуть бути збільшені вище за допомогою `SET_TMC_CURRENT`, ніж `run_current` значення, встановленого в файлі конфігурації. Однак, це має побічний ефект: Після запуску `SET_TMC_CURRENT`, stepper повинен бути проведений на стендах для >130ms у випадку, якщо StealthChop2 використовується так, щоб калібрування AT#1 була виконана водієм.

20230202: Змінено формат `printer.screws_tilt_adjust`. Інформація тепер зберігається як словник шурупів з отриманими вимірами. Див. [статус посилання](Status_Reference.md#screws_tilt_adjust) для деталей.

20230201: Модуль `[bed_mesh]` не завантажує профілі `default` на старті. Рекомендується користувачам, які використовують профілі ` ` додати `BED_MESH_PROFILE LOAD=default` до їх `START_PRINT` макро (або їх конфігурацію скибки "Start G-Code".

20230103: Тепер можливо з флеш-картою.sh скрипт для спалаху обох варіантів Bigtreetech SKR-2, STM32F407 і STM32F429. Це означає, що оригінальний тег btt-skr2 тепер змінився на або btt-skr-2-f407 або btt-skr-2-f429.

20221128: Klipper v0.11.0 випущено.

20221122: Попередньо, з сейфом_z_home, можливо, що z_hop після того, як g28 хмінг буде йти в негативний з напряму. Тепер, z_hop виконується після g28 тільки якщо він призводить до позитивного хмелю, віддзеркаливши поведінку z_hop, що відбувається до хмінгу g28.

20220616: Раніше миготливий RP2040 в режимі завантаження, працює `make flash FLASH_DEVICE=first`. При еквіваленті команди тепер `make flash FLASH_DEVICE=2e8a:0003`.

20220612: Мікроконтролер rp2040 тепер має значення для "rp2040-e5" USB errata. Це повинно зробити ініціал USB з'єднання більш надійним. Однак це може призвести до зміни поведінки для штифта gpio15. Неймовірно зміна поведінки gpio15 буде помітно.

20220407: Температурний параметр `pid_integral_max` був видалений параметр налаштування (прийнято на 20210612).

20220407: Замовлення за замовчуванням для pca9632 світлодіодів тепер "RGBW". Додати явну `color_order: RBGW` налаштування до розділу pca9632 для отримання попередньої поведінки.

20220330: У форматі `printer.neoпіксел.color_data` змінилася інформація про статус непікселів і dotstar. Інформація тепер зберігається в списку кольорових списків (замість списку словників). Див. [статус посилання](Status_Reference.md#led) для деталей.

20220307: `M73` не буде встановлювати прогрес друку до 0, якщо `P` відсутні.

20220304: Існує більше за замовчуванням для параметра `extruder` параметр [extruder_stepper](Config_Reference.md#extruder_stepper) конфігураційних розділів. При бажанні уточнюйте `extruder: extruder` явно зв'язувати кроковий двигун з чергою руху "екструдера" при запуску.

20220210: The `SYNC_STEPPER_TO_EXTRUDER` команда депресована; `SET_EXTRUDER_STEP_DISTANCE` команда депресована; [extruder](Config_Reference.md#extruder) `shared_heater` опція налаштування розшифровується. Ці функції будуть видалені найближчим часом. Заміна `SET_EXTRUDER_STEP_DISTANCE` з `SET_EXTRUDER_ROTRUDER_ROTATION_DISTANCE`. `SYNC_STEPPER_TO_EXTRUDER` з `SYNC_EXTRUDER_MOTION`. Заміна розділів налаштування екструдера за допомогою `shared_heater` з [extruder_stepper](Config_Reference.md#extruder_stepper) конфігурації розділів і оновлення будь-яких активаційних макросів для використання [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion).

20220116: Tmc2130, tmc2208, tmc2209 і tmc2660 `run_current` код розрахунку змінився. Для деяких `run_current` налаштування драйверів тепер можна налаштувати інакше. Ця нова конфігурація повинна бути більш точною, але вона може бути недійсною попередньої настройки драйвера tmc.

20211230: скрипти, щоб налаштувати формувальну форму (`scripts/calibrate_shaper.py` і `scripts/graph_accelerometer.py`) мігрували використовувати Python3 за замовчуванням. У результаті користувачі повинні встановити версії Python3 певних пакетів (наприклад, `sudo apt встановити python3-numpython3-matplotlib`) для продовження використання цих скриптів. Для отримання більш детальної інформації див. у розділі [Установка програмного забезпечення](Measuring_Resonances.md#software-installation). Крім того, користувачі можуть тимчасово змусити виконання цих сценаріїв під Python 2, явно зателефонувавши до інтерпретатора Python2 в консолі: `python2 ~/klipper/scripts/calibrate_shaper.py ...`

20211110: датчик температури "NTC 100K 3950" відхилений. Цей датчик буде видалений найближчим часом. Більшість користувачів знайдуть датчик температури "Generic 3950" більш точний. Для продовження використання старшого (типово менш точного) визначення, визначення на замовлення [thermistor](Config_Reference.md#thermistor) з ` Температурою1: 25`, `resistance1: 100000`, і `beta: 3950`.

20211104: параметр «тривалість покрокового імпульсу» в «make menuconfig» видалено. Стандартна тривалість кроку для драйверів TMC, налаштованих у режимі UART або SPI, тепер становить 100 нс. Нове налаштування `step_pulse_duration` у [розділі конфігурації крокового кроку](Config_Reference.md#stepper) має бути встановлено для всіх степерів, яким потрібна спеціальна тривалість імпульсу.

20211102: вилучено кілька депресованих функцій. `step_distance` було видалено варіант (згідно 20201222). `rpi_температурний` Датчик псевдонімів був вилучений (депресований на 20210219). Mcu `pin_map` було видалено варіант (прийнято 20210325). Gcode_macro `default_parameter_<name>` та макродоступ до параметрів команд, крім `params` було видалено псевдоваріативний (депресовано на 20210503). Нагрівач `pid_integral_max` було видалено опцію (розраховано на 20210612).

20210929: Klipper v0.10.0 випущено.

20210903: За замовчуванням [`smooth_time`](Config_Reference.md#extruder) для нагрівачів змінився на 1 секунду (від 2 секунд). Для більшості принтерів це призведе до більш стабільного контролю температури.

20210830: назва adxl345 за умовчанням тепер «adxl345». Параметром CHIP за замовчуванням для `ACCELEROMETER_MEASURE` і `ACCELEROMETER_QUERY` тепер також є "adxl345".

20210830: Adxl345 ACCELEROMETER_MEASURE Команда більше не підтримує параметр RATE. Щоб змінити швидкість запиту, оновити файл принтера.cfg і випустити команду RESTART.

20210821: Кілька налаштувань конфігурації в `printer.configfile.settings` тепер буде повідомлено як списки замість сирих рядків. Якщо потрібно фактичну сиру рядок, скористайтеся `printer.configfile.config` замість.

20210819: У деяких випадках, `G28` переміщення хмінгу може призвести до положення, яка номінально за межами діючого діапазону руху. У рідкісних ситуаціях це може призвести до плутанності «Зроблено з діапазону» помилок після гоління. Якщо це відбувається, змініть скрипти запуску, щоб перемістити ключ до дійсного положення відразу після гоління.

20210814: аналог тільки псевдо-піни на atmega168 і atmega328 були перейменовані з PE0/PE1 в PE2/PE3.

20210720: розділ контролера_fan тепер контролює всі крокові двигуни за замовчуванням (не тільки кінематичний кроковий двигун). Якщо потрібна попередня поведінка, див. `stepper` параметр налаштування в [посилання на налаштування](Config_Reference.md#controller_fan).

20210703: A `samd_sercom` конфігурація розділу повинна тепер вказати маршрут sercom, який він конфігурується через параметр `sercom`.

20210612: Параметр конфігурації `pid_integral_max` у розділах heater і temperature_fan застарів. Опція буде видалена найближчим часом.

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430: команда SET_VELOCITY_LIMIT (та M204) тепер може встановлювати швидкість, прискорення та квадратну_кутову_швидкість, більші за вказані значення у файлі конфігурації.

20210325: підтримка параметра конфігурації `pin_map` застаріла. Використовуйте файл [sample-aliases.cfg](../config/sample-aliases.cfg) для перекладу на фактичні назви контактів мікроконтролера. Параметр конфігурації `pin_map` буде видалено найближчим часом.

20210313: змінено підтримку Klipper для мікроконтролерів, які взаємодіють із шиною CAN. Якщо використовується шина CAN, усі мікроконтролери необхідно оновити та [конфігурацію Klipper необхідно оновити](CANBUS.md).

20210310: значення TMC2660 за умовчанням для driver_SFILT змінено з 1 на 0.

20210227: драйвери крокового двигуна TMC у режимі UART або SPI тепер запитуються раз на секунду щоразу, коли їх увімкнено. Якщо з драйвером неможливо зв’язатися або якщо драйвер повідомляє про помилку, Klipper перейде в стан вимкнення.

20210219: модуль `rpi_temperature` було перейменовано на `temperature_host`. Замініть будь-які випадки "sensor_type: rpi_temperature" на "sensor_type: temperature_host". Шлях до файлу температури можна вказати в конфігураційній змінній `sensor_path`. Назва `rpi_temperature` застаріла та буде видалена найближчим часом.

20210201: команда `TEST_RESONANCES` тепер вимкне формування вхідних даних, якщо воно було ввімкнено раніше (і знову ввімкне його після тесту). Щоб перевизначити цю поведінку та зберегти форму введення ввімкненою, можна передати команді додатковий параметр `INPUT_SHAPING=1`.

20210201: команда `ACCELEROMETER_MEASURE` тепер додаватиме назву чіпа акселерометра до назви вихідного файлу, якщо чіпу було дано ім’я у відповідному розділі adxl345 файлу printer.cfg.

20201222: Параметр `step_distance` у розділах конфігурації степера застарів. Рекомендується оновити конфігурацію, щоб використовувати налаштування [`rotation_distance`](Rotation_Distance.md). Підтримку `step_distance` буде вилучено найближчим часом.

20201218: параметр endstop_phase у модулі endstop_phase замінено на trigger_phase. Якщо використовується модуль фаз кінцевої зупинки, тоді потрібно буде перетворити на [`rotation_distance`](Rotation_Distance.md) і повторно відкалібрувати будь-які фази кінцевої зупинки, виконавши команду ENDSTOP_PHASE_CALIBRATE.

20201218: Rotary delta and polar printers must now specify a `gear_ratio` for their rotary steppers, and they may no longer specify a `step_distance` parameter. See the [config reference](Config_Reference.md#stepper) for the format of the new gear_ratio parameter.

20201213: Неможливо вказати Z "position_endstop" під час використання "probe:z_virtual_endstop". Тепер виникне помилка, якщо Z "position_endstop" указано з "probe:z_virtual_endstop". Видаліть визначення Z "position_endstop", щоб виправити помилку.

20201120: розділ конфігурації `[board_pins]` тепер визначає назву mcu в явному параметрі `mcu:`. Якщо board_pins використовується для вторинного мікроконтролера, необхідно оновити конфігурацію, щоб указати це ім’я. Дивіться [довідку конфігурації](Config_Reference.md#board_pins), щоб отримати додаткові відомості.

20201112: час, який повідомляє `print_stats.print_duration`, змінено. Тривалість до першої виявленої екструзії тепер виключена.

20201029: опцію конфігурації neopixel `color_order_GRB` було видалено. Якщо необхідно, оновіть конфігурацію, щоб встановити новий параметр `color_order` на RGB, GRB, RGBW або GRBW.

20201029: Параметр послідовного порту в розділі конфігурації mcu більше не використовується за замовчуванням /dev/ttyS0. У тих рідкісних ситуаціях, коли /dev/ttyS0 є потрібним послідовним портом, його потрібно вказати явно.

20201020: Випущено Klipper v0.9.0.

20200902: Розрахунок опору термометра RTD для перетворювачів MAX31865 виправлено, щоб не зчитувати низький рівень. Якщо ви використовуєте такий пристрій, вам слід повторно відкалібрувати температуру друку та параметри PID.

20200816: об’єкт макросу gcode `printer.gcode` було перейменовано на `printer.gcode_move`. Кілька недокументованих змінних у `printer.toolhead` і `printer.gcode` було видалено. Перегляньте docs/Command_Templates.md, щоб отримати список доступних змінних шаблону.

20200816: систему gcode макросу "action_" змінено. Замініть будь-які виклики `printer.gcode.action_emergency_stop()` на `action_emergency_stop()`, `printer.gcode.action_respond_info()` на `action_respond_info()`, а `printer.gcode.action_respond_error()` на `action_raise_error() )`.

20200809: систему меню було переписано. Якщо меню було налаштовано, необхідно оновити його до нової конфігурації. Перегляньте config/example-menu.cfg для деталей конфігурації та див. klippy/extras/display/menu.cfg для прикладів.

20200731: Поведінка атрибута `progress`, про яку повідомляє об’єкт принтера `virtual_sdcard`, змінилася. Перебіг більше не скидається до 0, коли друк призупинено. Тепер він завжди повідомлятиме про прогрес на основі внутрішньої позиції файлу або 0, якщо файл наразі не завантажено.

20200725: Параметр конфігурації `enable` сервоприводу та параметр `ENABLE` SET_SERVO було видалено. Оновіть усі макроси, щоб використовувати `SET_SERVO SERVO=my_servo WIDTH=0`, щоб вимкнути сервопривід.

20200608: підтримка РК-дисплеїв змінила назву деяких внутрішніх «гліфів». Якщо було реалізовано спеціальний макет відображення, можливо, знадобиться оновити найновіші назви гліфів (див. klippy/extras/display/display.cfg, щоб переглянути список доступних гліфів).

20200606: назви контактів на linux mcu змінено. Піни тепер мають імена у формі `gpiochip<chipid>/gpio<gpio>`. Для gpiochip0 ви також можете використовувати короткий `gpio<gpio>`. Наприклад, те, що раніше називалося «P20», тепер стає «gpio20» або «gpiochip0/gpio20».

20200603: РК-верстка за замовчуванням 16x4 більше не показує розрахунковий час, що залишився в друку. (Тільки час клацання буде показано.) Якщо стара поведінка потрібна, можна налаштувати відображення меню з цією інформацією (див. опис відображення_data в config/example-extras.cfg для деталей).

20200531: За замовчуванням USB постачальник / продукт id тепер 0x1d50 / 0x614e. Ці нові кришки зарезервовані для Klipper (завдяки до проекту openmoko). Ця зміна не повинна вимагати ніяких змін налаштувань, але нові потоки можуть з'явитися в логах системи.

20200524: Значення за замовчуванням для tmc5160 pwm_freq поле тепер нуль (замість одного).

20200425: змінна шаблона gcode_macro `printer.heater` перейменовано на `printer.heaters`.

20200313: Зміна макета за замовчуванням для багатопрофільних принтерів з екраном 16x4. Одиночна версія екрана екструдера тепер за замовчуванням і вона покаже в даний час активний екструдера. Щоб використовувати попередній набір макетів відображення "display_group: _multiextruder_16x4" в розділі [Вибір] принтера.cfg файл.

20200308: За замовчуванням `_test` було видалено пункт меню. Якщо файл config має користувацьке меню, то обов'язково слід видалити всі посилання на це `__test` пункт меню.

20200308: У меню "дек" та "картка" були видалені варіанти. Для налаштування макета екрана lcd використовуйте нові розділи налаштування даних (див. config/example-extras.cfg для деталей).

20200109: Модуль ліжко_меш тепер посилює розташування зонда для конфігурації сітки. Таким чином, деякі параметри конфігурації були перейменовані в точно відображають їх призначену функціональність. Для прямокутних місць `min_point` і `max_point` були перейменовані в `mesh_min` і `mesh_max` відповідно. `mesh_radius` Для круглих клумб додано новий варіант `mesh_origin`. Зверніть увагу, що ці зміни також несумісні з попередньо збереженими профільами сітки. Якщо несумісний профіль виявлений, він ігнорується і планується видалення. Процес видалення може бути завершено, видаючи команду SAVE_CONFIG. Користувач повинен перерахувати кожен профіль.

20191218: розділ налаштування дисплея більше не підтримує "lcd_type: st7567". Використовуйте тип дисплея "uc1701" замість - встановити "lcd_type: uc1701" і змінити "rs_pin: some_pin" до "rst_pin: some_pin". Щоб додати параметр "contrast: 60".

20191210: Вбудований T0, T1, T2, ... команди були видалені. Видалено активацію extruder_gcode та deactivate_gcode. Якщо ці команди (і скрипти) потрібні, то визначаються індивідуальні [gcode_macro T0] макроси, які називають команду ACTIVATE_EXTRUDER. Переглянути файл config/sample-idex.cfg і зразок-multi-extruder.cfg для прикладів.

20191210: Усунено підтримку команди M206. Замініть дзвінки до SET_GCODE_OFFSET. Якщо потрібна підтримка M206, додайте [gcode_macro M206] розділ налаштування, який викликає SET_GCODE_OFFSET. (На прикладі "SET_GCODE_OFFSET Z=-{params.Z}).)

20191202: Додано підтримку параметра «S» команди «G4». Заміна будь-яких появ S з параметром "P" (затримка, зазначена в мілісекундах).

20191126: На мікроконтролерах змінено імена USB. В даний час ми використовуємо унікальний чіп id за замовчуванням. Якщо в розділі "mcu" config використовує параметр "serial", який починається з "/dev/serial/by-id/" після чого може знадобитися оновити налаштування. Запуск "ls /dev/serial/by-id/*" в терміналі Ssh для визначення нової ідентифікатора.

20191121: Видалено тиск_advance_lookahead_time параметр. Див. приклад.cfg для альтернативних налаштувань конфігурації.

20191112: Увімкнути можливість драйвера tmc stepper автоматично ввімкнено, якщо stepper не має виділеного крокової панелі. Видалити посилання на tmcXXXX:virtual_enable з налаштування. Увімкнути можливість керування декількома шпильками в степпері увімкнути_pin config. Якщо потрібно декілька штифтів, то скористайтеся розділом багатоконтактного налаштування.

20191107: В розділі Налаштування первинного екструдера необхідно вказати як "екструдера" і не може бути зазначений як "extruder0". Шаблони командних кодів Gcode, які перетворюють статус екструдера, тепер доступні через "{printer.extruder}".

20191021: Klipper v0.8.0 випущений

20191003: Перехід_to_previous параметр в [safe_z_homing] тепер за замовчуванням до False. (Це було ефективно False до 20190918)

20190918: Опція zhop в [safe_z_homing] завжди re-applied після закінчення осі Z. Це може знадобитися для оновлення користувацьких скриптів на основі цього модуля.

20190806: Команда SET_NEOPIXEL була перейменована в SET_LED.

20190726: змінено цифровий код mcp4728. За замовчуванням i2c_address тепер 0x60 і посилання на напругу тепер відносно внутрішньої версії mcp4728.

20190710: параметр z_hop був вилучений з розділу [firmware_retract]. Підтримка z_hop була неповною і може викликати неправильну поведінку з декількома загальними скибочками.

20190710: Змінено параметри команди PROBE_ACCURACY. Щоб оновити будь-які макроси або скрипти, які використовують цю команду.

20190628: Всі варіанти конфігурації були вилучені з розділу [skew_correction]. Конфігурація для skew_correction тепер проводиться за допомогою SET_SKEW gcode. Див. [Skew Корекція](Skew_Correction.md) для рекомендованого використання.

20190607: Параметри "variable_X" gcode_macro (хоча з параметром VALUE SET_GCODE_VARIABLE) тепер паруються як лінійки Python. Якщо значення має бути призначене рядок, а потім оберніть значення в лапках, щоб він оцінюється як рядок.

20190606: У розділі "Пробе" переведено параметри налаштування "пробе". Ці параметри більше не підтримуються в "delta_calibrate", "bed_tilt", "bed_mesh", "screws_tilt_adjust", "z_tilt", або "quad_gantry_level" конфігураційних розділів.

20190528: Змінна магія "статус" в Gcode_macro шаблонна оцінка була перейменована в "принтер".

20190520: Команда SET_GCODE_OFFSET змінилася; оновлення будь-яких макросів g-коду відповідно. Команда більше не застосуватиме запит на наступну команду G1. Стара поведінка може бути приблизена за допомогою параметра «MOVE=1».

20190404: Оновлено програмні пакети Python host. Користувачі потрібно перезапустити ~ / клапти / скрипти / встановити-octopi.sh (або іншим чином оновити залежності python, якщо не використовуючи стандарт OctoPi установки).

20190404: Параметри i2c_bus і spi_bus (в різних розділах налаштування) тепер приймають назву автобуса замість номера.

20190404: Змінено параметри налаштування sx1509. параметр 'address' тепер 'i2c_address' і він повинен бути вказаний як десятковий номер. Де раніше використовували 0x3E, вкажіть 62.

20190328: Мінімальне значення в [температур_фан] config тепер буде поважним і вентилятор завжди буде працювати на цій швидкості або вище в режимі PID.

20190322: Значення за замовчуванням для "driver_HEND" в розділі [tmc2660] змінено з 6 до 3. Видалено поле "driver_VSENSE" (це тепер автоматично обчислюється з run_current).

20190310: У розділі налаштування [controller_fan] тепер завжди є ім'я (наприклад, [controller_fan my_controller_fan]).

20190308: поле "driver_BLANK_TIME_SELECT" в [tmc2130] та [tmc2208] перейменовані на "driver_TBL".

20190308: Змінено розділ налаштування [tmc2660]. На даний момент необхідно надати новий параметр налаштування значення_resistor. Значення декількох драйверів_ Змінилися параметри xxx.

20190228: Користувачі SPI або I2C на дошках SAMD21 тепер обов'язково вкажіть за допомогою розділу налаштувань [samd_sercom].

20190224: Видалено варіант постільної білизни. Варіант радіусу був перейменований в ліжко_radius. Користувачі з круглими ліжками повинні поставляти ліжко_radius і round_probe_count параметри.

20190107: Змінено параметр i2c_address у розділі налаштування mcp4451. Це загальне налаштування на смузі. Нова вартість - половина старого значення (88 повинні бути змінені до 44, а 90 повинні бути змінені до 45).

20181220: Klipper v0.7.0 випущений
