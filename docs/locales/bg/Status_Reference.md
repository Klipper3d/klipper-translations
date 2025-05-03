# Status reference

Този документ представлява справка за информацията за състоянието на принтера, налична в Klipper [макроси](Command_Templates.md), [полета за показване](Config_Reference.md#display) и чрез [API Server](API_Server.md).

Полетата в този документ могат да се променят - ако използвате даден атрибут, не забравяйте да прегледате документа [Config Changes](Config_Changes.md) при обновяване на софтуера Klipper.

## ъгъл

Следната информация е налична в обектите [angle some_name](Config_Reference.md#angle):

- `температура`: Последното отчитане на температурата (в градуси по Целзий) от магнитен сензор на Хола tle5012b. Тази стойност е налична само ако сензорът за ъгъл е чип tle5012b и ако измерванията са в ход (в противен случай се съобщава `None`).

## bed_mesh

Следната информация е налична в обекта [bed_mesh](Config_Reference.md#bed_mesh):

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`: Информация за активния в момента bed_mesh.
- `profiles`: Наборът от текущо дефинирани профили, настроен с помощта на BED_MESH_PROFILE.

## bed_screws

The following information is available in the [bed_screws](Config_Reference.md#bed_screws) object:

- `is_active`: Връща True, ако инструментът за регулиране на винтовете на леглото е активен в момента.
- `state`: Състояние на инструмента за регулиране на винтовете на леглото. Това е една от следните струни: "adjust", "fine".
- `current_screw`: Индексът на текущия винт, който се регулира.
- `accepted_screws`: Броят на приетите винтове.

## canbus_stats

The following information is available in the `canbus_stats some_mcu_name` object (this object is automatically available if an mcu is configured to use canbus):

- `rx_error`: The number of receive errors detected by the micro-controller canbus hardware.
- `tx_error`: The number of transmit errors detected by the micro-controller canbus hardware.
- `tx_retries`: The number of transmit attempts that were retried due to bus contention or errors.
- `bus_state`: The status of the interface (typically "active" for a bus in normal operation, "warn" for a bus with recent errors, "passive" for a bus that will no longer transmit canbus error frames, or "off" for a bus that will no longer transmit or receive messages).

Note that only the rp2XXX micro-controllers report a non-zero `tx_retries` field and the rp2XXX micro-controllers always report `tx_error` as zero and `bus_state` as "active".

## конфигурационен файл

Следната информация е налична в обекта `configfile` (този обект е винаги наличен):

- `settings.<section>.<option>`: Връща зададената настройка на конфигурационния файл (или стойността по подразбиране) по време на последното стартиране или рестартиране на софтуера. (Всички настройки, променени по време на работа, няма да бъдат отразени тук.)
- `config.<section>.<option>`: Връща зададената сурова настройка на конфигурационния файл, прочетена от Klipper по време на последното стартиране или рестартиране на софтуера. (Всички настройки, променени по време на работа, няма да бъдат отразени тук.) Всички стойности се връщат като низове.
- `save_config_pending`: Връща true, ако има актуализации, които командата `SAVE_CONFIG` може да запази на диска.
- `save_config_pending_items`: Съдържа секциите и опциите, които са били променени и ще бъдат запазени при `SAVE_CONFIG`.
- `предупреждения`: Списък с предупреждения за опциите на конфигурацията. Всеки запис в списъка е речник, съдържащ полета `type` и `message` (и двете са низове). Възможно е да има допълнителни полета в зависимост от типа на предупреждението.

## display_status

Следната информация е налична в обекта `display_status` (този обект е автоматично наличен, ако е дефинирана секция [display](Config_Reference.md#display) на конфигурацията):

- `progress`: Стойността на прогреса на последната `M73` G-Code команда (или `virtual_sdcard.progress`, ако не е получена скорошна `M73`).
- `message`: Съобщението, съдържащо се в последната G-кодова команда `M117`.

## endstop_phase

Следната информация е налична в обекта [endstop_phase](Config_Reference.md#endstop_phase):

- `last_home.<име на степер>.phase`: Фазата на стъпковия двигател в края на последния домашен опит.
- `last_home.<име на степер>.phases`: Общият брой на наличните фази на стъпковия двигател.
- `last_home.<име на степер>.mcu_position`: Позицията (проследена от микроконтролера) на стъпковия двигател в края на последния опит за връщане в изходно положение. Позицията е общият брой стъпки, направени в права посока, минус общия брой стъпки, направени в обратна посока, след последното рестартиране на микроконтролера.

## exclude_object

Следната информация е налична в обекта [exclude_object](Exclude_Object.md):

- `objects`: Масив от известните обекти, предоставени от командата `EXCLUDE_OBJECT_DEFINE`. Това е същата информация, предоставена от командата `EXCLUDE_OBJECT VERBOSE=1`. Полетата `center` и `polygon` ще присъстват само ако са предоставени в оригиналната команда `EXCLUDE_OBJECT_DEFINE`.

   Ето една JSON извадка:

```
[
  {
    "polygon": [
      [ 156.25, 146.2511675 ],
      [ 156.25, 153.7488325 ],
      [ 163.75, 153.7488325 ],
      [ 163.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_2_COPY_0",
    "center": [ 160, 150 ]
  },
  {
    "polygon": [
      [ 146.25, 146.2511675 ],
      [ 146.25, 153.7488325 ],
      [ 153.75, 153.7488325 ],
      [ 153.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_1_COPY_0",
    "center": [ 150, 150 ]
  }
]
```

- `excluded_objects`: Масив от низове, съдържащ имената на изключените обекти.
- `current_object`: Името на обекта, който се отпечатва в момента.

## extruder_stepper

Следната информация е налична за обектите extruder_stepper (както и за обектите [extruder](Config_Reference.md#extruder)):

- `pressure_advance`: Текущата стойност на [аванс на налягането](Pressure_Advance.md).
- `smooth_time`: Текущото време за плавно увеличаване на налягането.
- `motion_queue`: Името на екструдера, с който в момента е синхронизиран този стъпков екструдер. Това се съобщава като `None`, ако стъпката на екструдера в момента не е свързана с екструдер.

## вентилатор

Следната информация е налична в обектите [fan](Config_Reference.md#fan), [heater_fan some_name](Config_Reference.md#heater_fan) и [controller_fan some_name](Config_Reference.md#controller_fan):

- `speed`: Скоростта на вентилатора като плаващо число между 0,0 и 1,0.
- `rpm`: Измерената скорост на вентилатора в обороти в минута, ако вентилаторът има дефиниран tachometer_pin.

## filament_switch_sensor

Следната информация е налична в обектите [filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor):

- `enabled`: Връща True, ако сензорът за превключване в момента е активиран.
- `filament_detected`: Връща True, ако сензорът е в състояние на задействане.

## filament_motion_sensor

Следната информация е налична в обектите [filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor):

- `enabled`: Връща True, ако сензорът за движение в момента е активиран.
- `filament_detected`: Връща True, ако сензорът е в състояние на задействане.

## firmware_retraction

Следната информация е налична в обекта [firmware_retraction](Config_Reference.md#firmware_retraction):

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`: Текущите настройки за модула firmware_retraction. Тези настройки могат да се различават от тези в конфигурационния файл, ако командата `SET_RETRACTION` ги промени.

## gcode_button

Следната информация е налична в обектите [gcode_button some_name](Config_Reference.md#gcode_button):

- `state`: Текущото състояние на бутона, върнато като "PRESSED" или "RELEASED".

## gcode_macro

Следната информация е налична в обектите [gcode_macro some_name](Config_Reference.md#gcode_macro):

- `<променлива>`: Текущата стойност на променлива [gcode_macro](Command_Templates.md#variables).

## gcode_move

Следната информация е налична в обекта `gcode_move` (този обект е винаги наличен):

- `gcode_position`: Текущата позиция на главата на инструмента спрямо текущото начало на G-кода. Тоест позициите, които могат да се изпратят директно към команда `G1`. Възможно е да се получи достъп до компонентите x, y, z и e на тази позиция (например, `gcode_position.x`).
- `позиция`: Последната заповядана позиция на главата на инструмента, използваща координатната система, зададена в конфигурационния файл. Възможно е да се получи достъп до компонентите x, y, z и e на тази позиция (напр., `position.x`).
- `homing_origin`: Произходът на координатната система gcode (спрямо координатната система, посочена в конфигурационния файл), която да се използва след команда `G28`. Командата `SET_GCODE_OFFSET` може да промени тази позиция. Възможен е достъп до компонентите x, y и z на тази позиция (например, `homing_origin.x`).
- `speed`: Последната скорост, зададена с команда `G1` (в mm/s).
- `speed_factor`: "Коефициент на скоростта", зададен с команда `M220`. Това е стойност с плаваща запетая, като 1,0 означава, че няма превишаване, а например 2,0 ще удвои заявената скорост.
- `extrude_factor`: "Коефициент на екструдиране", зададен с команда `M221`. Това е стойност с плаваща запетая, така че 1,0 означава, че няма промяна, а например 2,0 ще удвои исканите екструзии.
- `absolute_coordinates`: Връща True, ако е в режим на абсолютни координати `G90`, или False, ако е в режим на относителни координати `G91`.
- `absolute_extrude`: Връща True, ако е в режим `M82` на абсолютно екструдиране, или False, ако е в режим `M83` на относително екструдиране.

## hall_filament_width_sensor

Следната информация е налична в обекта [hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor):

- all items from [filament_switch_sensor](Status_Reference.md#filament_switch_sensor)
- `is_active`: Връща True, ако сензорът в момента е активен.
- `Диаметър`: Последното показание на сензора в мм.
- `Raw`: Последното необработено ADC показание от сензора.

## нагревател

Следната информация е налична за обекти за нагреватели като [extruder](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed) и [heater_generic](Config_Reference.md#heater_generic):

- `температура`: Последната отчетена температура (в градуси по Целзий като float) за дадения нагревател.
- `Target`: Текущата целева температура (в градуси по Целзий като float) за дадения нагревател.
- `power`: Последната настройка на щифта PWM (стойност между 0,0 и 1,0), свързана с нагревателя.
- `can_extrude`: Ако екструдерът може да екструдира (определено от `min_extrude_temp`), достъпно само за [extruder](Config_Reference.md#extruder)

## нагреватели

Следната информация е налична в обекта `heaters` (този обект е наличен, ако е дефиниран някой нагревател):

- `available_heaters`: Връща списък на всички налични в момента нагреватели по техните пълни имена на секциите на конфигурацията, например `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `available_sensors`: Връща списък на всички налични в момента температурни сензори чрез пълните им имена на секциите на конфигурацията, например `["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"]`.
- `available_monitors`: Връща списък на всички налични в момента температурни монитори по техните пълни имена на секциите в конфигурацията, например `["tmc2240 stepper_x"]`. Докато температурен сензор е винаги наличен за четене, температурен монитор може да не е наличен и в такъв случай ще се върне null.

## idle_timeout

Следната информация е налична в обекта [idle_timeout](Config_Reference.md#idle_timeout) (този обект е винаги наличен):

- `state`: Текущото състояние на принтера, проследявано от модула idle_timeout. Това е един от следните низове: "Idle", "Printing", "Ready".
- `printing_time`: Времето (в секунди), през което принтерът е бил в състояние "Печат" (както се следи от модула idle_timeout).

## led

Следната информация е налична за всеки раздел от конфигурацията `[led led_name]`, `[neopixel led_name]`, `[dotstar led_name]`, `[pca9533 led_name]` и `[pca9632 led_name]`, дефиниран в printer.cfg:

- `color_data`: Списък с цветови списъци, съдържащи RGBW стойностите за даден светодиод във веригата. Всяка стойност е представена като float от 0,0 до 1,0. Всеки списък с цветове съдържа 4 елемента (червено, зелено, синьо, бяло), дори ако светодиодът с подсветка поддържа по-малко цветови канали. Например стойността на синьото (3-ти елемент в списъка с цветове) на втория неопиксел във веригата може да се получи на адрес `printer["neopixel <config_name>"].color_data[1][2]`.

## load_cell

The following information is available for each `[load_cell name]`:

- 'is_calibrated': True/False is the load cell calibrated
- 'counts_per_gram': The number of raw sensor counts that equals 1 gram of force
- 'reference_tare_counts': The reference number of raw sensor counts for 0 force
- 'tare_counts': The current number of raw sensor counts for 0 force
- 'force_g': The force in grams, averaged over the last polling period.
- 'min_force_g': The minimum force in grams, over the last polling period.
- 'max_force_g': The maximum force in grams, over the last polling period.

## manual_probe

Следната информация е налична в обекта `manual_probe`:

- `is_active`: Връща True, ако в момента е активен помощен скрипт за ръчно сондиране.
- `z_position`: Текущата височина на дюзата (както принтерът я разбира в момента).
- `z_position_lower`: Последният опит за сондиране е по-нисък от текущата височина.
- `z_position_upper`: Последният опит за сондиране е по-голям от текущата височина.

## mcu

Следната информация е налична в обектите [mcu](Config_Reference.md#mcu) и [mcu some_name](Config_Reference.md#mcu-my_extra_mcu):

- `mcu_version`: Версията на кода на Klipper, съобщена от микроконтролера.
- `mcu_build_versions`: Информация за инструментите за изграждане, използвани за генериране на кода на микроконтролера (както се съобщава от микроконтролера).
- `mcu_constants.<constant_name>`: Константи по време на компилация, докладвани от микроконтролера. Наличните константи могат да се различават при различните архитектури на микроконтролера и при всяка ревизия на кода.
- ```last_stats.<statistics_name>`: Статистическа информация за връзката с микроконтролера.

## motion_report

Следната информация е налична в обекта `motion_report` (този обект е наличен автоматично, ако е дефиниран някой раздел от конфигурацията на стъпковия механизъм):

- `live_position`: Заявената позиция на главата на инструмента, интерполирана към текущото време.
- `live_velocity`: Заявената скорост на главата на инструмента (в mm/s) в текущия момент.
- `live_extruder_velocity`: Заявената скорост на екструдера (в mm/s) в текущия момент.

## output_pin

Следната информация е налична в обектите [output_pin some_name](Config_Reference.md#output_pin):

- `value`: "Стойността" на пина, зададена с команда `SET_PIN`.

## палитри2

Следната информация е налична в обекта [palette2](Config_Reference.md#palette2):

- `ping`: Размер на последния отчетен пинг на Palette 2 в проценти.
- `remaining_load_length`: При стартиране на печат с Palette 2 това ще бъде количеството нишка, което ще се зареди в екструдера.
- `is_splicing`: Вярно, когато палитрата 2 е сплитаща нишка.

## pause_resume

Следната информация е налична в обекта [pause_resume](Config_Reference.md#pause_resume):

- `is_paused`: Връща true, ако е била изпълнена команда PAUSE без съответна команда RESUME.

## print_stats

Следната информация е налична в обекта `print_stats` (този обект е автоматично наличен, ако е дефинирана конфигурационна секция [virtual_sdcard](Config_Reference.md#virtual_sdcard)):

- `име на филма`, `обща продължителност`, `продължителност на печат`, `използвани влакна`, `състояние`, `съобщение`: Очаквана информация за текущия печат, когато е активен печат на virtual_sdcard.
- `info.total_layer`: Стойността на общия слой от последната команда `SET_PRINT_STATS_INFO TOTAL_LAYER=<value>` на G-Code.
- `info.current_layer`: Стойността на текущия слой от последната команда на G-Code `SET_PRINT_STATS_INFO CURRENT_LAYER=<value>`.

## сонда

Следната информация е налична в обекта [probe](Config_Reference.md#probe) (този обект също е наличен, ако е дефинирана секция [bltouch](Config_Reference.md#bltouch) config):

- `name`: Връща името на използваната сонда.
- `last_query`: Връща True, ако сондата е била отчетена като "задействана" по време на последната команда QUERY_PROBE. Обърнете внимание, че ако това се използва в макрос, поради реда на разширяване на шаблона, командата QUERY_PROBE трябва да се изпълни преди макроса, съдържащ тази препратка.
- `last_z_result`: Връща стойността на Z резултата от последната команда PROBE. Обърнете внимание, че ако това се използва в макрос, поради реда на разширяване на шаблона, командата PROBE (или подобна) трябва да се изпълни преди макроса, съдържащ тази препратка.

## pwm_cycle_time

Следната информация е налична в обектите [pwm_cycle_time some_name](Config_Reference.md#pwm_cycle_time):

- `value`: "Стойността" на пина, зададена с команда `SET_PIN`.

## quad_gantry_level

Следната информация е налична в обекта `quad_gantry_level` (този обект е наличен, ако е дефиниран quad_gantry_level):

- `applied`: Вярно, ако процесът на нивелиране на портала е стартиран и е завършил успешно.

## query_endstops

Следната информация е налична в обекта `query_endstops` (този обект е наличен, ако е дефиниран някой endstop):

- `last_query["<endstop>"]`: Връща True, ако даденият endstop е отчетен като "задействан" по време на последната команда QUERY_ENDSTOP. Обърнете внимание, че ако това се използва в макрос, поради реда на разширяване на шаблона, командата QUERY_ENDSTOP трябва да се изпълни преди макроса, съдържащ тази препратка.

## screws_tilt_adjust

Следната информация е налична в обекта `screws_tilt_adjust`:

- `error`: Връща True, ако последната команда `SCREWS_TILT_CALCULATE` е включвала параметъра `MAX_DEVIATION` и някоя от изследваните точки на винта е надвишила зададения параметър `MAX_DEVIATION`.
- `max_deviation`: Връща последната стойност на `MAX_DEVIATION` на последната команда `SCREWS_TILT_CALCULATE`.
- `Results["<screw>"]`: Речник, съдържащ следните ключове:
   - `z`: Измерената височина Z на местоположението на винта.
   - `sign`: низ, указващ посоката на завъртане на винта за необходимата настройка. "CW" - по посока на часовниковата стрелка, или "CCW" - обратно на часовниковата стрелка.
   - `adjust`: Броят на завъртанията на винта за регулиране, зададен във формат "HH:MM", където "HH" е броят на пълните завъртания на винта, а "MM" е броят на "минутите на часовниковия циферблат", представляващи частично завъртане на винта. (Например "01:15" означава да завъртите винта с един и четвърт оборот.)
   - `is_base`: Връща True, ако това е базовият винт.

## Серво

Следната информация е налична в обектите [servo some_name](Config_Reference.md#servo):

- `printer["servo <config_name>"].value`: Последната настройка на щифта PWM (стойност между 0,0 и 1,0), свързана със сервоусилвателя.

## skew_correction.py

The following information is available in the `skew_correction` object (this object is available if any skew_correction is defined):

- `current_profile_name`: Returns the name of the currently loaded SKEW_PROFILE.

## stepper_enable

Следната информация е налична в обекта `stepper_enable` (този обект е наличен, ако е дефиниран някой стъпков механизъм):

- `steppers["<stepper>"]`: Връща True, ако даденият стъпков механизъм е активиран.

## system_stats

Следната информация е налична в обекта `system_stats` (този обект е винаги наличен):

- `sysload`, `cputime`, `memavail`: Информация за операционната система на хоста и натоварването на процесите.

## температурни сензори

Следната информация е налична в

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [sht3x config_section_name](Config_Reference.md#sht31-sensor), [lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor), [temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) and [temperature_combined config_section_name](Config_Reference.md#combined-temperature-sensor) objects:

- `температура`: Последната отчетена температура от сензора.
- `влажност`, `налягане`, `газ`: Последните прочетени стойности от сензора (само за сензорите bme280, htu21d, sht3x и lm75).

## temperature_fan

Следната информация е налична в обектите [temperature_fan some_name](Config_Reference.md#temperature_fan):

- `температура`: Последната отчетена температура от сензора.
- `Target`: Целевата температура за вентилатора.

## temperature_sensor

Следната информация е налична в обектите [temperature_sensor some_name](Config_Reference.md#temperature_sensor):

- `температура`: Последната отчетена температура от сензора.
- `measured_min_temp`, `measured_max_temp`: Най-ниската и най-високата температура, отчетена от сензора след последното рестартиране на софтуера на Klipper.

## tmc drivers

Следната информация е налична в обектите [TMC stepper driver](Config_Reference.md#tmc-stepper-driver-configuration) (например, `[tmc2208 stepper_x]`):

- `mcu_phase_offset`: Позицията на стъпковия механизъм на микроконтролера, съответстваща на "нулевата" фаза на драйвера. Това поле може да бъде нулево, ако фазовото отместване не е известно.
- `phase_offset_position`: Командната позиция", съответстваща на "нулевата" фаза на водача. Това поле може да бъде нулево, ако фазовото отместване не е известно.
- `drv_status`: Резултатите от последната заявка за състоянието на водача. (Отчитат се само полета, които не са нулеви.) Това поле ще бъде нулево, ако драйверът не е активиран (и следователно не се запитва периодично).
- `температура`: Вътрешната температура, отчетена от драйвера. Това поле ще бъде нулево, ако драйверът не е активиран или ако драйверът не поддържа отчитане на температурата.
- `run_current`: Текущият ток на изпълнение.
- `hold_current`: Текущо зададеният ток на задържане.

## глава на инструмент

Следната информация е налична в обекта `toolhead` (този обект е винаги наличен):

- `позиция`: Последната командна позиция на главата на инструмента спрямо координатната система, посочена в конфигурационния файл. Възможно е да се получи достъп до компонентите x, y, z и e на тази позиция (например, `position.x`).
- `екструдер`: Името на активния в момента екструдер. Например в макрос може да се използва `printer[printer.toolhead.extruder].target`, за да се получи целевата температура на текущия екструдер.
- `homed_axes`: Текущите картезиански оси, за които се счита, че са в състояние "homed". Това е низ, съдържащ един или повече от символите "x", "y", "z".
- `axis_minimum`, `axis_maximum`: Границите на преместване на оста (mm) след самонасочване. Възможен е достъп до компонентите x, y, z на тази гранична стойност (например, `axis_minimum.x`, `axis_maximum.z`).
- За принтерите Delta `cone_start_z` е максималната височина z при максимален радиус (`printer.toolhead.cone_start_z`).
- `max_velocity`, `max_accel`, `minimum_cruise_ratio`, `square_corner_velocity`: Текущите ограничения за печат, които са в сила. Това може да се различава от настройките в конфигурационния файл, ако командата `SET_VELOCITY_LIMIT` (или `M204`) ги промени по време на работа.
- `stalls`: Общият брой пъти (от последното рестартиране), когато се е наложило принтерът да бъде спрян, тъй като главата на инструмента се е движила по-бързо от движенията, които могат да бъдат прочетени от входа на G-Code.

## dual_carriage

Следната информация е налична в [dual_carriage](Config_Reference.md#dual_carriage) за картезиански, хибриден_corexy или хибриден_corexz робот

- `carriage_0`: Възможните стойности са: "НЕАКТИВЕН" и "ПЪРВИЧЕН".
- `carriage_1`: Режимът на карета 1. Възможните стойности са: "INACTIVE", "PRIMARY", "COPY" и "MIRROR".

## virtual_sdcard

Следната информация е налична в обекта [virtual_sdcard](Config_Reference.md#virtual_sdcard):

- `is_active`: Връща True, ако отпечатването от файл в момента е активно.
- `progress`: Оценка на текущия напредък на печата (въз основа на размера на файла и позицията на файла).
- `file_path`: Пълен път до файла на текущо заредения файл.
- `file_position`: Текущата позиция (в байтове) на активния печат.
- `file_size`: Размерът на файла (в байтове) на текущо заредения файл.

## webhooks

Следната информация е налична в обекта `webhooks` (този обект е винаги наличен):

- `state`: Връща низ, указващ текущото състояние на Klipper. Възможните стойности са: "готов", "стартиране", "изключване", "грешка".
- `state_message`: Човешки прочетен низ, който дава допълнителен контекст за текущото състояние на Klipper.

## z_thermal_adjust

Следната информация е налична в обекта `z_thermal_adjust` (този обект е наличен, ако е дефиниран [z_thermal_adjust](Config_Reference.md#z_thermal_adjust)).

- `enabled`: Връща True, ако настройката е разрешена.
- `температура`: Текуща (изгладена) температура на определения сензор. [degC]
- `measured_min_temp`: Минимална измерена температура. [degC]
- `measured_max_temp`: Максимална измерена температура. [degC]
- `current_z_adjust`: Последната изчислена Z корекция [mm].
- `z_adjust_ref_temperature`: Текуща референтна температура, използвана за изчисляване на Z `current_z_adjust` [degC].

## z_tilt

Следната информация е налична в обекта `z_tilt` (този обект е наличен, ако е дефиниран z_tilt):

- `applied`: Вярно, ако процесът на изравняване на z-наклона е стартиран и е завършил успешно.
