# Статус на сервери

Цей документ є посиланням на інформацію про статус принтера, доступні в Klipper [macros](Command_Templates.md), [display поля](Config_Reference.md#display), а через [API Server](API_Server.md).

Поле в цьому документі підлягають зміні - якщо за допомогою атрибута обов'язково перегляньте документ [Config Changes](Config_Changes.md) при оновленні програмного забезпечення Klipper.

## кут

Наступна інформація доступна в [angle some_name](Config_Reference.md#angle) об'єкти:

- `температура`: Останнє читання температури (в Кельсі) від датчика магнітного залу tle5012b. Ця величина доступна тільки в тому випадку, якщо датчик кута є чіпом tle5012b і якщо вимірювання знаходяться в прогресі (інші звіти `None`).

## постіль

Наступна інформація доступна в [bed_mesh](Config_Reference.md#bed_mesh) об'єкт:

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`: Інформація про в даний час активне ліжко_меш.
- `profiles`: Набір в даний час визначених профілів як налаштування за допомогою BED_ MESH_PROFILE.

## bed_screws

The following information is available in the [bed_screws](Config_Reference.md#bed_screws) object:

- `is_active`: Повернення Правда, якщо в даний час працює інструмент регулювання саморізів.
- `state`: Регулювання шурупами стан інструменту. Він є одним з наступних рядків: "регулюйте", "fine".
- `current_screw`: Індекс для поточного гвинта регулюється.
- `accepted_screws`: Кількість прийнятих шурупів.

## canbus_stats

The following information is available in the `canbus_stats some_mcu_name` object (this object is automatically available if an mcu is configured to use canbus):

- `rx_error`: The number of receive errors detected by the micro-controller canbus hardware.
- `tx_error`: The number of transmit errors detected by the micro-controller canbus hardware.
- `tx_retries`: The number of transmit attempts that were retried due to bus contention or errors.
- `bus_state`: The status of the interface (typically "active" for a bus in normal operation, "warn" for a bus with recent errors, "passive" for a bus that will no longer transmit canbus error frames, or "off" for a bus that will no longer transmit or receive messages).

Note that only the rp2XXX micro-controllers report a non-zero `tx_retries` field and the rp2XXX micro-controllers always report `tx_error` as zero and `bus_state` as "active".

## налаштування

Наступна інформація доступна в `configfile` об'єкт ( цей об'єкт завжди доступний):

- `settings.<section>.<option>`: повертає задану налаштування файлу (або значення за замовчуванням) під час останнього запуску програмного забезпечення або перезавантаження. (Налаштування змінені в режимі run-time не будуть відображені тут.)
- `config.<section>.<option>`: повертає задану конфігурацію файлу, як читати Klipper під час останнього запуску програмного забезпечення або перезавантаження. (Налаштування змінені в режимі run-time не будуть відображені тут.) Всі значення повертаються як рядки.
- `save_config_pending`: Повертає true, якщо є оновлення, що `SAVE_CONFIG` команда може зберігатися на диску.
- `save_config_pending_items`: Містить розділи та параметри, які були змінені і будуть перенасичені `SAVE_CONFIG`.
- `warnings`: Перелік попереджень про параметри налаштування. Кожен запис у списку буде словником, що містить `тип` та `message` поле (однорядні рядки). Додаткові поля можуть бути доступні в залежності від типу попередження.

## огляд

Наступна інформація доступна в об'єкті `display_status` ( цей об'єкт автоматично доступний, якщо параметр [display](Config_Reference.md#display)):

- `прогрес`: Вартість прогресу останнього `M73` G-Code команди (або `virtual_sdcard.progress` if no last `M73`.
- `message`: Останнє повідомлення `M117` G-Code команди.

## endstop_фаза

Наступна інформація доступна в [endstop_phase](Config_Reference.md#endstop_phase) об'єкт:

- `last_home.<stepper name>.фаз`: Фаза крокової двигуна в кінці останньої домашньої спроби.
- `last_home.<stepper name>.фаз`: Загальна кількість фаз, доступних на кроковий двигун.
- `last_home.<Прізвище>.mcu_позиція`: Позиція (як відстежується мікроконтролером) крокової двигуна в кінці останньої домашньої спроби. Посада – загальна кількість кроків, які беруться в напрямку вперед, мінус загальна кількість кроків, що беруться в зворотному напрямку, так як мікроконтролер був прослужений.

## без категорії

Наступна інформація доступна в [exclude_object](Exclude_Object.md) об'єкт:

- `objects`: масив відомих об'єктів, що надаються `EXCLUDE_OBJECT_DEFINE` команди. Ця ж інформація, надана командою `EXCLUDE_OBJECT VERBOSE=1`. `center` і `polygon` поля будуть присутні тільки при наявності в оригінальному `EXCLUDE_OBJECT_DEFINE`

   Ось зразок JSON:

```
Про нас
Довідник
"polygon": [
[ 156.25, 146.2511675 ],
[ 156.25, 153.7488325 ],
[ 163.75, 153.7488325 ],
[ 163.75, 146.2511675 ]
й
"name": "CYLINDER_2_STL_ID_2_COPY_0",
"центр": [ 160, 150 ]
Головна
Довідник
"polygon": [
[ 146.25, 146.2511675 ],
[ 146.25, 153.7488325 ],
[ 153.75, 153.7488325 ],
[ 153.75, 146.2511675 ]
й
"name": "CYLINDER_2_STL_ID_1_COPY_0",
"центр": [150, 150 ]
Про нас
до
```

- `excluded_objects`: Список імен виключених об'єктів масиву рядків.
- `current_object`: Ім'я об'єкта в даний час друкується.

## extruder_starper

Інформація доступна для об'єктів extruder_stepper (а також [extruder](Config_Reference.md#extruder)):

- `pressure_advance`: поточне значення [випередження тиску](Pressure_Advance.md).
- `smooth_time`: Поточний тиск заздалегідь плавний час.
- `motion_queue`: Ім'я екструдера, що цей степпер екструдера наразі синхронізується. Про це повідомляється, як `None`, якщо кроковий крок екструдера не пов'язаний з екструдером.

## fan

Додаткова інформація доступна в [fan](Config_Reference.md#fan), [heater_fan some_name](Config_Reference.md#heater_fan) і [controller_fan some_name](Config_Reference.md#controller_fan) об'єкти:

- `speed`: Швидкість вентилятора в порівнянні з 0,0 і 1,0.
- `rpm`: Вимірюється швидкість вентилятора в обертах в хвилину, якщо вентилятор має тахометр_pin визначений.

## javascript licenses api веб-сайт

Наступна інформація доступна в [filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor) об'єктах:

- `enabled`: Повернення Правда, якщо датчик вимкнення в даний час включений.
- `filament_detected`: Повернення Правда, якщо датчик перебуває в запущеному стані.

## filament_motion_sensor

Наступна інформація доступна в [filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor) об'єктах:

- `enabled`: Повернення Правда, якщо датчик руху в даний час включений.
- `filament_detected`: Повернення Правда, якщо датчик перебуває в запущеному стані.

## прошивка_відновлення

Додаткова інформація доступна в об'єкті [firmware_retraction](Config_Reference.md#firmware_retraction):

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`: Поточні налаштування для модуля прошивки_відновлення. Ці налаштування можуть відрізнятися від файла конфігурації, якщо `SET_RETRACTION` команди змінює їх.

## gcode

The following information is available in the `gcode` object:

- `commands`: Returns a list of all currently available commands. For each command, if a help string is defined it will also be provided.

## g code_button

У розділі [gcode_button some_name](Config_Reference.md#gcode_button) об'єкти:

- `state`: Поточний стан кнопок повернувся як "ПРЕСЕД" або "РЕЛІЗД"

## gcode_macro

У розділі [gcode_macro some_name](Config_Reference.md#gcode_macro) об'єкти:

- `<variable>`: Поточне значення [gcode_macro змінного](Command_Templates.md#variables).

## gcode_move

Наступна інформація доступна в об'єкті `gcode_move` ( цей об'єкт завжди доступний):

- `gcode_position`: The current position of the toolhead relative to the current G-Code origin. That is, positions that one might directly send to a `G1` command. This value is encoded as a [coordinate](#accessing-coordinates).
- `position`: The last commanded position of the toolhead using the coordinate system specified in the config file. This value is encoded as a [coordinate](#accessing-coordinates).
- `homing_origin`: The origin of the gcode coordinate system (relative to the coordinate system specified in the config file) to use after a `G28` command. The `SET_GCODE_OFFSET` command can alter this position. This value is encoded as a [coordinate](#accessing-coordinates).
- `speed`: Останній набір швидкості в `G1` команди (в мм / с).
- `speed_фактор`: "швидкий фактор перенареченості" в комплекті команди `M220`. Це плаваючою точкою значення, таким чином, 1,0 означає, що не перейди і, наприклад, 2.0 буде подвійний запитаний швидкість.
- `extrude_фактор`: "надійний фактор перенареченого" як набір `M221` команди. Це плаваючою точкою значення, наприклад, 1,0 означає, що не перенаречена і, наприклад, 2.0 буде подвійний запитаний екструзії.
- `absolute_координати`: Це повертає Правда, якщо в `G90` абсолютний координатний режим або False, якщо в `G91` відносний режим.
- `absolute_extrude`: Це повертає Правда, якщо в `M82` абсолютний вихідний режим або False, якщо в `M83` відносний режим.
- `axis_map`: Provides a mechanism for finding the coordinate component for a given G-Code id that is used in `G1` commands. See the [Accessing Coordinates](#accessing-coordinates) section for details.

## href="http://realtor.if.ua/" title="агентство нерухомості ріелтор"

Наступна інформація доступна в об'єкті [hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor):

- all items from [filament_switch_sensor](Status_Reference.md#filament_switch_sensor)
- `is_active`: Повернення Правда, якщо датчик в даний час активний.
- `flow_compensation_enabled`: Returns True if flow compensation is enabled.
- `Diameter`: Returns the last width reading in mm if the sensor is active or the nominal filament diameter if it is not.
- `Raw`: Остання сира ADC читання від датчика.

## нагрівач

Додаткова інформація доступна для теплових об'єктів, таких як [extruder](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed), а [heater_generic](Config_Reference.md#heater_generic):

- `температура`: Останнє повідомлення про температуру (в Келсіус як плавлення) для даної нагрівачі.
- `target`: Поточна цільова температура (в Келсіу як плавача) для даної опалювальної машини.
- `power`: Останнє налаштування штифта PWM (ціна між 0,0 і 1,0) пов'язана з нагрівачем.
- `can_extrude`: Якщо extruder може extrude (визначений `min_extrude_temp`), доступний тільки для [extruder](Config_Reference.md#extruder)

## нагрівачі

В об’єкті `heaters` доступна така інформація (цей об’єкт доступний, якщо визначено будь-який нагрівач):

- `0_heaters`: Повертає список всіх наявних на даний момент опалювальних пристроїв за іменами повного налаштування, наприклад, `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `0_sensors`: Повертає список всіх наявних датчиків температури за їхніми іменами повного налаштування, наприклад, `["extruder", "heater_bed", "heater_generic my_custom_heater", "температурна електроніка_temp"]`.
- `0_monitors`: Повертає список всіх наявних температурних моніторів за їх іменами повного налаштування, наприклад, `["tmc2240 stepper_x"]`. В той час як датчик температури завжди доступний для читання, датчик температури може бути недоступний і повернеться null в такому випадку.

## idle_timeout

Наступна інформація доступна в [idle_timeout](Config_Reference.md#idle_timeout) об'єкт (це об'єкт завжди доступний):

- `state`: Поточний стан принтера як відстежується модулем idle_timeout. Він є одним з наступних рядків: "Попередження", "Читання".
- `printing_time`: Сума часу (в секундах) принтера була в стані "припинення" (як відстежити модуль idle_timeout).
- `idle_timeout`: The current 'timeout' (in seconds) to wait for the gcode to be triggered. (as set by [SET_IDLE_TIMEOUT](G-Codes.md#set_idle_timeout))

## під керівництвом

Наступна інформація доступна для кожного `[led led_name]`, `[neoпіксель Led_name]`, `[dotstar led_name]`, `[pca9533 led_name]`, і `[pca9632 led_name]` config розділ, визначений у принтері.cfg:

- `color_data`: A list of color lists containing the RGBW values for a led in the chain. Each value is represented as a float from 0.0 to 1.0. Each color list contains 4 items (red, green, blue, white) even if the underlying LED supports fewer color channels. For example, the blue value (3rd item in color list) of the second neopixel in a chain could be accessed at `printer["neopixel <config_name>"].color_data[1][2]`.

## load_cell

The following information is available for each `[load_cell name]`:

- `is_calibrated`: True/False whether the load cell is calibrated.
- `counts_per_gram`: The number of raw sensor counts that equals 1 gram of force.
- `reference_tare_counts`: The reference number of raw sensor counts for 0 force.
- `tare_counts`: The current number of raw sensor counts for 0 force.
- `force_g`: The force in grams, averaged over the last polling period.
- `min_force_g`: The minimum force in grams, over the last polling period.
- `max_force_g`: The maximum force in grams, over the last polling period.
- `errors`: The number of sensor errors detected since the last start of measurements.
- `overflows`: The number of data buffer overflows detected since the last start of measurements.
- `sample_rate`: The sensor's sample rate in samples per second.

## load_cell_probe

The following information is available for `[load_cell_probe]`:

- all items from [load_cell](Status_Reference.md#load_cell)
- all items from [probe](Status_Reference.md#probe)
- `endstop_tare_counts`: The load cell probe keeps a tare value independent of the load cell. This is re-set at the start of each probe.
- `last_trigger_time`: Timestamp of the last homing trigger.
- `last_z_result`: The Z position result of the last tap.
- `is_last_tap_valid`: True if the last tap result is valid.

## manual_probe

В об’єкті `manual_probe` доступна така інформація:

- `is_active`: Повернення Правда, якщо в даний час працює ручний скрипт пробування.
- `z_position`: Поточна висота сопла (як принтер в даний час розуміє його).
- `z_position_lower`: Остання спроба зонду трохи нижче поточного висоти.
- `z_position_upper`: Остання спроба проби тільки більше, ніж поточна висота.

## мапи

Наступна інформація доступна в [mcu](Config_Reference.md#mcu) і [mcu some_name](Config_Reference.md#mcu-my_extra_mcu) об'єкти:

- `mcu_version`: Версія коду Klipper, що повідомляється мікроконтролером.
- `mcu_build_versions`: Відомості про інструменти побудови, які використовуються для створення мікроконтролерного коду (як повідомляється мікроконтролером).
- `mcu_constants.<constant_name>`: Спірні часові константи, що повідомляються мікроконтролером. Доступні константи можуть відрізнятися між архітектурами мікроконтролерів і з кожним кодом.
- `last_stats.<statistics_name>`: Статистика інформації про підключення мікроконтролера.

## транспорт

Наступна інформація доступна в об'єкті `motion_report` (цей об'єкт автоматично доступний, якщо визначено розділ налаштування кроку):

- `live_position`: The requested toolhead position interpolated to the current time. This value is encoded as a [coordinate](#accessing-coordinates).
- `live_velocity`: Вимагажена швидкість інструменту (в мм/с) в поточний час.
- `live_extruder_velocity`: Випробувано швидкість екструдера (в мм/с) в поточний час.

## output_pin

The following information is available in [output_pin some_name](Config_Reference.md#output_pin) and [pwm_tool some_name](Config_Reference.md#pwm_tool) objects:

- `value`: "значення" шпильки, як встановити `SET_PIN` команди.

## палітра2

Наступна інформація доступна в [palette2](Config_Reference.md#palette2) об'єкт:

- `ping`: Сума останнього повідомлення Палетт 2 ping в відсотках.
- `remaining_load_length`: При відпускі палета 2 друку, це буде кількість ниток для завантаження в екструдер.
- `is_splicing`: Правда, коли палета 2 є запобіжним поданням.

## пауза_пошук

Наступна інформація доступна в [pause_resume](Config_Reference.md#pause_resume) об'єкт:

- `is_paused`: Повертає true, якщо команда PAUSE була виконана без відповідного RESUME.

## друк_статисти

Наступна інформація доступна в об'єкті `print_stats` (цей об'єкт автоматично доступний, якщо [virtual_sdcard](Config_Reference.md#virtual_sdcard)):

- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message`: Оцінена інформація про поточний принт, коли активний віртуальний_sdcard друку.
- `info.total_layer`: Загальний шар значення останнього `SET_PRINT_STATS_INFO TOTAL_LAYER=<value>` G-Code команди.
- `info.current_layer`: Поточне значення шару останнього `SET_PRINT_STATS_INFO CURRENT_LAYER=<value>` G-Code команди.

## пробе

Наступна інформація доступна в [probe](Config_Reference.md#probe) об'єкт ( цей об'єкт також доступний, якщо параметр [bltouch](Config_Reference.md#bltouch) config розділу:

- `name`: Повертає ім'я зонду у використанні.
- `last_query`: Повернення Правда, якщо зонд був повідомлений як "підготовлений" під час останнього команди QUERY_PROBE. Примітка, якщо це використовується в макросі, через порядок розширення шаблону, команда QUERY_PROBE повинна працювати до макрос, що містить цю посилання.
- `last_probe_position`: The results of the last `PROBE` command. This value is encoded as a [coordinate](#accessing-coordinates). The probe hardware estimates that if one were to command the toolhead to XY position `last_probe_position.x`,`last_probe_position.y` and descend then the tip of the toolhead would first contact the bed at a Z height of `last_probe_position.z`. These coordinates are relative to the frame (that is, they use the coordinate system specified in the config file). Note, if this is used in a macro, due to the order of template expansion, the `PROBE` command must be run prior to the macro containing this reference.
- `last_z_result`: This value is deprecated; it will be removed in the near future.

## pwm_cycle_time

Наступна інформація доступна в [pwm_cycle_time some_name](Config_Reference.md#pwm_cycle_time) об'єкти:

- `value`: "значення" шпильки, як встановити `SET_PIN` команди.

## quad_gantry_level

У розділі `quad_gantry_level` об'єкт (цей об'єкт доступний, якщо визначено квадротип_gantry_level):

- `applied`: Правда, якщо процес вирівнювання ганчі успішно завершений.

## query_endstops

Наступна інформація доступна в `query_endstops` об'єкт ( цей об'єкт доступний, якщо будь-який кінцевий стіл визначений):

- `last_query["<endstop>"]`: Повернення Правда, якщо надана ендстоп була повідомлена як "підготовлений" під час останнього команди QUERY_ENDSTOP. Примітка, якщо це використовується в макросі, через порядок розширення шаблону, команда QUERY_ENDSTOP повинна працювати до макрос, що містить цей посилання.

## гвинти_tilt_adjust

Наступна інформація доступна в `screws_tilt_adjust` об'єкт:

- `error`: Повернення Правда, якщо останні ` SCREWS_TILT_CALCULATE` команди включені параметр `MAX_DEVIATION` і будь-який з прокладених гвинтових точок перевищили зазначену `MAX_DEVIATION`.
- `max_deviation`: Повернути останні `MAX_DEVIATION` значення останнього `SCREWS_TILT_CALCULATE` команди.
- `results["<screw>"]`: Словник, що містить такі ключі:
   - `z`: Вимірюється Z висота гвинтового розташування.
   - `sign`: Рядок, що визначає напрямок для включення гвинта для необхідного регулювання. Ефір "CW" за годинниковою стрілкою або "CCW" для проти годинникової стрілки.
   - `adjust`: Кількість гвинтових поворотів для регулювання гвинта, що надається в форматі "HH:MM", де "HH" є числом повного шнека поворотів і "MM" є числом "хви годинникового обличчя", що представляє частковий шнековий поворот. (Е.g. "01:15" буде означати, щоб повернути гвинт один і чверть революцій.)
   - `is_base`: Повернення Правда, якщо це основний гвинт.

## серво

Додаткова інформація доступна в [servo some_name](Config_Reference.md#servo) об'єктах:

- `printer["servo <config_name>"].value`: Останнє налаштування штифта PWM ( значення між 0.0 і 1,0) пов'язане з серво.

## skew_correction.py

The following information is available in the `skew_correction` object (this object is available if any skew_correction is defined):

- `current_profile_name`: Returns the name of the currently loaded SKEW_PROFILE.

## stepper_enable

Наступна інформація доступна в об'єкті `stepper_enable` ( цей об'єкт доступний, якщо будь-який stepper визначений):

- `Степпери["<stepper>"]`: Повернення Правда, якщо задана степпер ввімкнено.

## система_статисти

Наступна інформація доступна в об'єкті `system_stats` ( цей об'єкт завжди доступний):

- `sysload`, `cputime`, `memavail`: Відомості про операційну систему та навантаження процесу.

## датчики температури

Інформація доступна в

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [sht3x config_section_name](Config_Reference.md#sht31-sensor), [lm75 con fig_section_name](Config_Reference .md#lm75-temperature-sensor), [temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) і [temperature_combined config_section_name](Config_Reference.md#combined-temperature-sensor) об’єкти:

- `температура`: Остання температура читання від датчика.
- `humidity`, `pressure`, `гас`: Останні значення читання від датчика (тільки на bme280, htu21d, sht3x і lm75 сенсорів).

## температура_фан

Наступна інформація доступна в об’єктах [temperature_fan some_name](Config_Reference.md#temperature_fan):

- `температура`: Остання температура читання від датчика.
- `target`: Цільова температура для вентилятора.

## температура_сенсор

Вказана нижче інформація доступна в [температурна_сенсорна частина_ім'я](Config_Reference.md# Infrastructure_sensor) об'єктах:

- `температура`: Остання температура читання від датчика.
- `measured_min_temp`, `measured_max_temp`: Найнижчою і найвищою температурою, що бачив датчиком, оскільки програмне забезпечення для хостів Klipper було оновлено останнім часом.

## драйвери tmc

Наступна інформація доступна в [TMC stepper драйвер](Config_Reference.md#tmc-stepper-driver-configuration) об'єкта (наприклад, `[tmc2208 stepper_x]`):

- `mcu_phase_offset`: положення мікроконтролера, що відповідає фазі драйвера. Це поле може бути null, якщо фаза не відома.
- `фаза_поставка`: "командована позиція" відповідає фазі водія "зеро". Це поле може бути null, якщо фаза не відома.
- `drv_status`: Результати запиту останнього стану водія. (Повідомо про ненульські поля.) Якщо водій не ввімкнено (і таким чином не періодично передається).
- `температура`: Внутрішня температура повідомляє водієві. Якщо водій не ввімкнено, або якщо водій не підтримує температурну звітність.
- `run_current`: В даний час встановлюється струм.
- `hold_current`: В даний час встановлюється струм утримання.

## головна

Наступна інформація доступна в об'єкті `toolhead` ( цей об'єкт завжди доступний):

- `position`: The last commanded position of the toolhead relative to the coordinate system specified in the config file. This value is encoded as a [coordinate](#accessing-coordinates).
- `extruder`: Назва діючого екструдера. Наприклад, в макросі можна використовувати `принтер[printer.toolhead.extruder].target`, щоб отримати цільову температуру поточного екструдера.
- `homed_axes`: Поточні кошики Це рядок, що містить один або більше "x", "y", "z".
- `axis_minimum`, `axis_maximum`: The axis travel limits (mm) after homing. This value is encoded as a [coordinate](#accessing-coordinates).
- Для принтерів Delta `cone_start_z` є максимальною висотою z при максимальному радіусі (`printer.toolhead.cone_start_z`).
- `max_velocity`, `max_accel`, `minimum_cruise_ratio`, `square_corner_velocity`: Поточні ліміти друку, які впливають на ефект. Це може відрізнятися від налаштувань конфігураційного файлу, якщо `SET_VELOCITY_LIMIT` (або `M204`) команда змінює їх на run-time.
- `stalls`: Загальна кількість разів (з останнього перезаряджання), що принтер повинен бути виловлений, тому що накладний інструмент переміщається швидше, ніж переміщення можна читати з входу G-Code.
- `extra_axes`: Provides a mechanism for finding the coordinate component for extra axes available in standard `G1` type move commands. See the [Accessing Coordinates](#accessing-coordinates) section for details.

## подвійний_кар'єр

Наступна інформація доступна в [dual_carriage](Config_Reference.md#dual_carriage) на візках, гібрид_corexy або гібрид_corexz robot

- `carriage_0`: Режим перевезення 0. Можливі значення: "INACTIVE" і "PRIMARY".
- `carriage_1`: Режим перевезення 1. Можливі значення: "INACTIVE", "PRIMARY", "COPY", "MIRROR".

On a `generic_cartesian` kinematic, the following information is available in `dual_carriage`:

- `carriages["<carriage>"]`: The mode of the carriage `<carriage>`. Possible values are "INACTIVE" and "PRIMARY" for the primary carriage and "INACTIVE", "PRIMARY", "COPY", and "MIRROR" for the dual carriage.

## virtual_sdcard

Наступна інформація доступна в [virtual_sdcard](Config_Reference.md#virtual_sdcard) об'єкт:

- `is_active`: Повернення Правда, якщо друк з файлу в даний час активний.
- `прогрес`: Оцінка поточного прогресу друку (на основі розміру файлу та позиції файлів).
- `file_path`: Повний шлях до файлу в даний час завантажений файл.
- `file_position`: Поточна позиція (в байтах) активного друку.
- `file_size`: Розмір файлу (в байтах) в даний час завантажений файл.

## вебхуки

Наступна інформація доступна в об'єкті `webhooks` ( цей об'єкт завжди доступний):

- `state`: Повертає рядок, що вказує на поточний стан затискачів. Можливі значення: "живо", "startup", "shutdown", "error".
- `state_message`: Людина, що читається, дає додатковий контекст на поточний стан Кліппера.

## z_thermal_adjust

Наступна інформація доступна в об'єкті `z_thermal_adjust` ( цей об'єкт доступний, якщо [z_thermal_adjust](Config_Reference.md#z_thermal_adjust)).

- `enabled`: Повернення Правда, якщо ввімкнено налаштування.
- `температурна`: Поточна (змочена) температура визначеного датчика. [degC]
- `measured_min_temp`: Мінімальна виміряна температура. [degC]
- `measured_max_temp`: Максимальна виміряна температура. [degC]
- `current_z_adjust`: Останнє оновлення Z [мм].
- `z_adjust_ref_color`: Поточна температура посилання, що використовується для розрахунку Z `current_z_adjust` [degC].

## z_tilt

Наступна інформація доступна в об'єкті `z_tilt` ( цей об'єкт доступний, якщо z_tilt визначено):

- `applied`: Правда, якщо процес вирівнювання захвату успішно завершено.

## Accessing Coordinates

Some status fields provide a "coordinate". For macro users these fields may be accessed by component name (eg,`{printer.toolhead.position.x}`), where the component name may be "x", "y", or "z".

For developers using the Klipper API Server these fields are transmitted as a list - for example: `{"toolhead": {"position": [1.0, 2.0, 3.0, 7.3, 19.2]}}` . The first three components of the list correspond with the x, y, and z axes.

A coordinate will typically have at least 3 components (x, y, and z), however there may also be additional components. Care should be taken when accessing any of these additional components as the ordering and number of components may change at run-time.

One may use `{printer.gcode_move.axis_map}` and/or `{printer.toolhead.extra_axes}` to determine the number of components and the ordering of components. For example, to access the "E" component one could use `{printer.toolhead.position[printer.gcode_move.axis_map.E]}`. Or, if one wanted to find the component associated with the "extruder" object, one could use `{printer.toolhead.position[printer.toolhead.extra_axes.extruder]}`.
