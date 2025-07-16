# Ссылка на статус

Этот документ является справочником информации о состоянии принтера, доступной в Klipper [macros](Command_Templates.md), [display fields](Config_Reference.md#display) и через[API Server](API_Server.md).

Поля в этом документе могут быть изменены - при использовании атрибута обязательно ознакомьтесь с документом [Config Changes document](Config_Changes.md) при обновлении программного обеспечения Klipper.

## угол

Следующая информация доступна в объектах [angle some_name](Config_Reference.md#angle):

- `температура`: Последнее показание температуры (в градусах Цельсия) с магнитного датчика Холла tle5012b. Это значение доступно только в том случае, если датчик угла является микросхемой tle5012b и если ведутся измерения (в противном случае он сообщает `Нет`).

## сетка постели (bed_mesh)

Следующая информация доступна в объекте [bed_mesh](Config_Reference.md#bed_mesh):

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`: Информация о текущей активной сетке bed_mesh.
- `профайлы`: Набор определенных в данный момент профилей, установленных с помощью BED_MESH_PROFILE.

## bed_screws

The following information is available in the [bed_screws](Config_Reference.md#bed_screws) object:

- `is_active`: Возвращает True, если инструмент регулировки винтов станины активен в данный момент.
- `Состояние`: Состояние инструмента для регулировки винтов кровати. Это одна из следующих строк: " регулировать", "тонкий".
- `current_screw`: Индекс для текущего винта, который регулируется.
- `accepted_screws`: Количество принимаемых винтов.

## canbus_stats

The following information is available in the `canbus_stats some_mcu_name` object (this object is automatically available if an mcu is configured to use canbus):

- `rx_error`: The number of receive errors detected by the micro-controller canbus hardware.
- `tx_error`: The number of transmit errors detected by the micro-controller canbus hardware.
- `tx_retries`: The number of transmit attempts that were retried due to bus contention or errors.
- `bus_state`: The status of the interface (typically "active" for a bus in normal operation, "warn" for a bus with recent errors, "passive" for a bus that will no longer transmit canbus error frames, or "off" for a bus that will no longer transmit or receive messages).

Note that only the rp2XXX micro-controllers report a non-zero `tx_retries` field and the rp2XXX micro-controllers always report `tx_error` as zero and `bus_state` as "active".

## configfile

Следующая информация доступна в объекте `configfile` (этот объект всегда доступен):

- `settings.<section>.<option>`: Возвращает заданную настройку файла конфигурации (или значение по умолчанию) во время последнего запуска или перезапуска программы. (Любые настройки, измененные во время выполнения, не будут отражены здесь.)
- `config.<section>.<option>`: Возвращает заданные необработанные настройки конфигурационного файла, считанные Klipper во время последнего запуска или перезапуска программы. (Любые настройки, измененные во время выполнения, не будут отражены здесь). Все значения возвращаются в виде строк.
- `save_config_pending`: Возвращает true, если есть обновления, которые команда `SAVE_CONFIG` может сохранить на диске.
- `save_config_pending_items`: Содержит секции и опции, которые были изменены и будут сохранены при `SAVE_CONFIG`.
- `предупреждения`: Список предупреждений о параметрах конфигурации. Каждая запись в списке будет представлять собой словарь, содержащий поле `type` и `message` (оба - строки). В зависимости от типа предупреждения могут быть доступны дополнительные поля.

## display_status

Следующая информация доступна в объекте `display_status` (этот объект автоматически доступен, если определен раздел конфигурации [display](Config_Reference.md#display)):

- `progress`: Значение прогресса последней `M73` команды G-Code (или `virtual_sdcard.progress`, если не получена последняя `M73` команда).
- `сообщение`: Сообщение, содержащееся в последней `M117` команде G-кода.

## endstop_phase

Следующая информация доступна в объекте [endstop_phase](Config_Reference.md#endstop_phase):

- `last_home.<имя шагового двигателя>.phase`: Фаза шагового двигателя в конце последней попытки возврата домой.
- `last_home.<имя шагового двигателя>.phases`: Общее количество фаз, доступных на шаговом двигателе.
- `last_home.<имя шагового двигателя>.mcu_position`: Положение (отслеживаемое микроконтроллером) шагового двигателя в конце последней попытки возврата домой. Позиция - это общее количество шагов, сделанных в прямом направлении, минус общее количество шагов, сделанных в обратном направлении с момента последнего перезапуска микроконтроллера.

## exclude_object

Следующая информация доступна в объекте [exclude_object](Exclude_Object.md):

- `объекты`: Массив известных объектов, предоставленных командой `EXCLUDE_OBJECT_DEFINE`. Это та же информация, которую предоставляет команда `EXCLUDE_OBJECT VERBOSE=1`. Поля `центр` и `полигон` будут присутствовать только в том случае, если они были указаны в исходной команде `EXCLUDE_OBJECT_DEFINE`

   Вот пример JSON:

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

- `excluded_objects`: Массив строк, в которых перечислены имена исключенных объектов.
- `current_object`: Имя объекта, который печатается в данный момент.

## extruder_stepper

Следующая информация доступна для объектов extruder_stepper (а также для объектов [extruder](Config_Reference.md#extruder)):

- `pressure_advance`: Текущее значение [pressure advance](Pressure_Advance.md).
- `smooth_time`: Текущее время плавного повышения давления.
- `motion_queue`: Имя экструдера, с которым в данный момент синхронизирован этот шаговый механизм экструдера. Сообщается как `Нет`, если шаговый механизм экструдера в данный момент не связан с экструдером.

## вентилятор

Следующая информация доступна в объектах [вентилятор](Config_Reference.md#fan), [heater_fan some_name](Config_Reference.md#heater_fan) и [controller_fan some_name](Config_Reference.md#controller_fan):

- `Скорость`: Скорость вращения вентилятора в виде плавающей величины между 0,0 и 1,0.
- `rpm`: Измеренная скорость вращения вентилятора в оборотах в минуту, если у вентилятора определен контакт тахометра (tachometer_pin).

## filament_switch_sensor

Следующая информация доступна в объектах [filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor):

- `включен`: Возвращает истину, если датчик переключателя в данный момент включен.
- `filament_detected`: Возвращает истину, если датчик находится в состоянии срабатывания.

## filament_motion_sensor

Следующая информация доступна в объектах [filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor):

- `включен`: Возвращает истину, если датчик движения включен.
- `filament_detected`: Возвращает истину, если датчик находится в состоянии срабатывания.

## firmware_retraction

Следующая информация доступна в объекте [firmware_retraction](Config_Reference.md#firmware_retraction):

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`: Текущие настройки для модуля firmware_retraction. Эти настройки могут отличаться от настроек в файле конфигурации, если команда `SET_RETRACTION` изменит их.

## gcode_button

Следующая информация доступна в объектах [gcode_button some_name](Config_Reference.md#gcode_button):

- `состояние`: Текущее состояние кнопки, возвращаемое как "НАЖАТО" или "ОТПУЩЕНО"

## gcode_macro

Следующая информация доступна в объектах [gcode_macro some_name](Config_Reference.md#gcode_macro):

- `<переменная>`: Текущее значение переменной [gcode_macro](Command_Templates.md#variables).

## gcode_move

Следующая информация доступна в объекте `gcode_move` (этот объект всегда доступен):

- `gcode_position`: Текущее положение головки инструмента относительно текущего начала G-кода. То есть, позиция, которую можно напрямую передать в команду `G1`. Можно получить доступ к компонентам x, y, z и e этой позиции (например, `gcode_position.x`).
- `позиция`: Последнее заданное положение головки инструмента в системе координат, указанной в файле конфигурации. Можно получить доступ к компонентам x, y, z и e этой позиции (например, `position.x`).
- `homing_origin`: Начало системы координат gcode (относительно системы координат, указанной в файле конфигурации), которую следует использовать после команды `G28`. Команда `SET_GCODE_OFFSET` может изменить это положение. Можно получить доступ к компонентам x, y и z этой позиции (например, `homing_origin.x`).
- `скорость`: Последняя скорость, установленная в команде `G1` (в мм/с).
- `speed_factor`: "Переопределение коэффициента скорости", установленное командой `M220`. Это значение с плавающей точкой: 1.0 означает отсутствие переопределения, а, например, 2.0 удваивает запрашиваемую скорость.
- `extrude_factor`: "Переопределение коэффициента выдавливания", задаваемое командой `M221`. Это значение с плавающей точкой: 1.0 означает отсутствие переопределения, а, например, 2.0 удваивает требуемые экструзии.
- `абсолютные_координаты`: Возвращает True, если в режиме абсолютных координат `G90`, или False, если в режиме относительных координат `G91`.
- `absolute_extrude`: Возвращает True, если используется режим абсолютного выдавливания `M82`, или False, если используется режим относительного выдавливания `M83`.

## hall_filament_width_sensor

Следующая информация доступна в объекте [hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor):

- all items from [filament_switch_sensor](Status_Reference.md#filament_switch_sensor)
- `is_active`: Возвращает True, если датчик в данный момент активен.
- `Диаметр`: Последнее показание датчика в мм.
- `Сырой`: Последнее необработанное показание АЦП с датчика.

## нагреватель

Следующая информация доступна для таких объектов нагревателей, как [ экструдер](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed) и [heater_generic](Config_Reference.md#heater_generic):

- `температура`: Последнее сообщение о температуре (в градусах Цельсия в виде float) для данного нагревателя.
- `цель`: Текущая целевая температура (в градусах Цельсия в виде плавающей величины) для данного нагревателя.
- `power`: Последняя настройка PWM-штырька (значение между 0.0 и 1.0), связанного с нагревателем.
- `can_extrude`: Если экструдер может выдавливать (определяется `min_extrude_temp`), доступно только для [extruder](Config_Reference.md#extruder)

## обогреватели

Следующая информация доступна в объекте `нагреватели` (этот объект доступен, если определен любой нагреватель):

- `available_heaters`: Возвращает список всех доступных на данный момент нагревателей по их полным именам секций конфигурации, например, `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `available_sensors`: Возвращает список всех доступных на данный момент датчиков температуры по их полным именам разделов конфигурации, например, `["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"]`.
- `available_monitors`: Возвращает список всех доступных на данный момент температурных мониторов по их полным именам секций конфигурации, например, `["tmc2240 stepper_x"]`. В то время как датчик температуры всегда доступен для чтения, монитор температуры может быть недоступен, и в этом случае будет возвращен null.

## idle_timeout

Следующая информация доступна в объекте [idle_timeout](Config_Reference.md#idle_timeout) (этот объект всегда доступен):

- `состояние`: Текущее состояние принтера, отслеживаемое модулем idle_timeout. Это одна из следующих строк: " простаивает", "печатает", "готов".
- `printing_time`: Количество времени (в секундах), в течение которого принтер находился в состоянии "Печать" (отслеживается модулем idle_timeout).

## светодиод

Следующая информация доступна для каждого раздела конфигурации `[led led_name]`, `[neopixel led_name]`, `[dotstar led_name]`, `[pca9533 led_name]` и `[pca9632 led_name]`, определенного в файле printer.cfg:

- `color_data`: Список списков цветов, содержащих значения RGBW для светодиода в цепочке. Каждое значение представлено в виде float от 0.0 до 1.0. Каждый список цветов содержит 4 элемента (красный, зеленый, синий, белый), даже если подстроечный светодиод поддерживает меньшее количество цветовых каналов. Например, значение синего цвета (3-й элемент в списке цветов) второго неопикселя в цепочке может быть доступно по адресу `printer["neopixel <config_name>"].color_data[1][2]`.

## load_cell

The following information is available for each `[load_cell name]`:

- 'is_calibrated': True/False is the load cell calibrated
- 'counts_per_gram': The number of raw sensor counts that equals 1 gram of force
- 'reference_tare_counts': The reference number of raw sensor counts for 0 force
- 'tare_counts': The current number of raw sensor counts for 0 force
- 'force_g': The force in grams, averaged over the last polling period.
- 'min_force_g': The minimum force in grams, over the last polling period.
- 'max_force_g': The maximum force in grams, over the last polling period.

## load_cell_probe

The following information is available for `[load_cell_probe]`:

- all items from [load_cell](Status_Reference.md#load_cell)
- all items from [probe](Status_Reference.md#probe)
- 'endstop_tare_counts': the load cell probe keeps a tare value independent of the load cell. This re-set at the start of each probe.
- 'last_trigger_time': timestamp of the last homing trigger

## manual_probe

В объекте `manual_probe` доступна следующая информация:

- `is_active`: Возвращает True, если в данный момент активен вспомогательный скрипт ручного зондирования.
- `z_position`: Текущая высота сопла (как ее понимает принтер).
- `z_position_lower`: Последняя попытка зондирования ниже текущей высоты.
- `z_position_upper`: Последняя попытка зондирования, превышающая текущую высоту.

## mcu

Следующая информация доступна в объектах [mcu](Config_Reference.md#mcu) и [mcu some_name](Config_Reference.md#mcu-my_extra_mcu):

- `mcu_version`: Версия кода Klipper, сообщенная микроконтроллером.
- `mcu_build_versions`: Информация о средствах сборки, использованных для генерации кода микроконтроллера (по данным микроконтроллера).
- `mcu_constants.<constant_name>`: Константы времени компиляции, сообщаемые микроконтроллером. Доступные константы могут отличаться в разных архитектурах микроконтроллеров и в каждой ревизии кода.
- `last_stats.<statistics_name>`: Статистическая информация о подключении микроконтроллера.

## motion_report

Следующая информация доступна в объекте `motion_report` (этот объект автоматически доступен, если определена любая секция конфигурации степпера):

- `live_position`: Запрашиваемая позиция головки инструмента, интерполированная к текущему времени.
- `live_velocity`: Запрашиваемая скорость головки инструмента (в мм/с) в текущий момент времени.
- `live_extruder_velocity`: Запрашиваемая скорость экструдера (в мм/с) в текущий момент времени.

## output_pin

Следующая информация доступна в объектах [output_pin some_name](Config_Reference.md#output_pin):

- `value`: "Значение" пина, заданное командой `SET_PIN`.

## palette2

Следующая информация доступна в объекте [palette2](Config_Reference.md#palette2):

- `ping`: Величина последнего зарегистрированного пинга Palette 2 в процентах.
- `remaining_load_length`: При запуске печати Palette 2 это будет количество нити, которое нужно загрузить в экструдер.
- `is_splicing`: Истина, если палитра 2 сращивает нити.

## pause_resume

Следующая информация доступна в объекте [pause_resume](Config_Reference.md#pause_resume):

- `is_paused`: Возвращает true, если была выполнена команда PAUSE без соответствующего RESUME.

## print_stats

Следующая информация доступна в объекте `print_stats` (этот объект автоматически доступен, если определен раздел конфигурации [virtual_sdcard](Config_Reference.md#virtual_sdcard)):

- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message`: Оценочная информация о текущем отпечатке, если активен отпечаток virtual_sdcard.
- `info.total_layer`: Значение общего слоя, полученное в результате выполнения последней команды G-кода `SET_PRINT_STATS_INFO TOTAL_LAYER=<значение>`.
- `info.current_layer`: Значение текущего слоя, полученное в результате выполнения последней команды G-кода `SET_PRINT_STATS_INFO CURRENT_LAYER=<значение>`.

## probe

Следующая информация доступна в объекте [probe](Config_Reference.md#probe) (этот объект также доступен, если определен раздел конфигурации [bltouch](Config_Reference.md#bltouch)):

- `name`: Возвращает имя используемого зонда.
- `last_query`: Возвращает True, если во время последней команды QUERY_PROBE зонд был признан "сработавшим". Обратите внимание, если это используется в макросе, то из-за порядка расширения шаблона команда QUERY_PROBE должна быть запущена до макроса, содержащего эту ссылку.
- `last_z_result`: Возвращает значение Z-результата последней команды PROBE. Обратите внимание, если это используется в макросе, то из-за порядка расширения шаблона команда PROBE (или аналогичная) должна быть запущена до макроса, содержащего эту ссылку.

## pwm_cycle_time

Следующая информация доступна в объектах [pwm_cycle_time some_name](Config_Reference.md#pwm_cycle_time):

- `value`: "Значение" пина, заданное командой `SET_PIN`.

## quad_gantry_level

Следующая информация доступна в объекте `quad_gantry_level` (этот объект доступен, если определен quad_gantry_level):

- `применено`: True, если процесс выравнивания порталов был запущен и успешно завершен.

## query_endstops

Следующая информация доступна в объекте `query_endstops` (этот объект доступен, если определена какая-либо конечная остановка):

- `last_query["<endstop>"]`: Возвращает True, если указанный endstop был зарегистрирован как "сработавший" во время последней команды QUERY_ENDSTOP. Обратите внимание, если это используется в макросе, то из-за порядка расширения шаблона команда QUERY_ENDSTOP должна быть запущена до макроса, содержащего эту ссылку.

## screws_tilt_adjust

Следующая информация доступна в объекте `screws_tilt_adjust`:

- `error`: Возвращает True, если последняя команда `SCREWS_TILT_CALCULATE` включала параметр `MAX_DEVIATION` и любая из точек зондирования винта превысила указанное значение `MAX_DEVIATION`.
- `max_deviation`: Возвращает последнее значение `MAX_DEVIATION` последней команды `SCREWS_TILT_CALCULATE`.
- `results["<screw>"]`: Словарь, содержащий следующие ключи:
   - `z`: Измеренная высота Z расположения винта.
   - `знак`: Строка, указывающая направление вращения винта для необходимой регулировки. Либо "CW" - по часовой стрелке, либо "CCW" - против часовой стрелки.
   - `adjust`: Количество оборотов винта для регулировки, заданное в формате "HH:MM", где "HH" - количество полных оборотов винта, а "MM" - количество "минут циферблата часов", представляющих собой неполный оборот винта. (Например, "01:15" означает, что нужно повернуть винт на один и четверть оборота)
   - `is_base`: Возвращает True, если это базовый винт.

## сервопривод

Следующая информация доступна в объектах [servo some_name](Config_Reference.md#servo):

- `printer["servo <config_name>"].value`: Последняя настройка вывода ШИМ (значение между 0.0 и 1.0), связанного с сервоприводом.

## skew_correction.py

The following information is available in the `skew_correction` object (this object is available if any skew_correction is defined):

- `current_profile_name`: Returns the name of the currently loaded SKEW_PROFILE.

## stepper_enable

Следующая информация доступна в объекте `stepper_enable` (этот объект доступен, если определен любой степпер):

- `steppers["<stepper>"]`: Возвращает True, если указанный степпер включен.

## system_stats

Следующая информация доступна в объекте `system_stats` (этот объект доступен всегда):

- `sysload`, `cputime`, `memavail`: Информация об операционной системе хоста и загрузке процессов.

## температурные датчики

Следующая информация доступна в

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [sht3x config_section_name](Config_Reference.md#sht31-sensor), [lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor), [temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) and [temperature_combined config_section_name](Config_Reference.md#combined-temperature-sensor) objects:

- `температура`: Последнее значение температуры, считанное с датчика.
- `влажность`, `давление`, `газ`: Последние считанные значения с датчика (только для датчиков bme280, htu21d, sht3x и lm75).

## temperature_fan

Следующая информация доступна в объектах [temperature_fan some_name](Config_Reference.md#temperature_fan):

- `температура`: Последнее значение температуры, считанное с датчика.
- `Цель`: Целевая температура для вентилятора.

## temperature_sensor

Следующая информация доступна в объектах [temperature_sensor some_name](Config_Reference.md#temperature_sensor):

- `температура`: Последнее значение температуры, считанное с датчика.
- `measured_min_temp`, `measured_max_temp`: Самая низкая и самая высокая температура, наблюдаемая датчиком с момента последнего перезапуска хост-программы Klipper.

## драйверы tmc

Следующая информация доступна в объектах [TMC stepper driver](Config_Reference.md#tmc-stepper-driver-configuration) (например, `[tmc2208 stepper_x]`):

- `mcu_phase_offset`: Позиция шага микроконтроллера, соответствующая "нулевой" фазе драйвера. Это поле может быть нулевым, если смещение фазы неизвестно.
- `phase_offset_position`: "Заданное положение", соответствующее "нулевой" фазе водителя. Это поле может быть нулевым, если смещение фазы неизвестно.
- `drv_status`: Результаты последнего запроса состояния драйвера. (Сообщаются только ненулевые поля.) Это поле будет равно нулю, если драйвер не включен (и, следовательно, периодически не запрашивается).
- `температура`: Внутренняя температура, о которой сообщает драйвер. Это поле будет равно null, если драйвер не включен или если драйвер не поддерживает отчет о температуре.
- `run_current`: Текущее значение тока выполнения.
- `hold_current`: Установленный в данный момент ток удержания.

## головка инструмента

Следующая информация доступна в объекте `toolhead` (этот объект всегда доступен):

- `позиция`: Последнее заданное положение головки инструмента относительно системы координат, указанной в файле конфигурации. Можно получить доступ к компонентам x, y, z и e этой позиции (например, `position.x`).
- `экструдер`: Имя активного в данный момент экструдера. Например, в макросе можно использовать `принтер[printer.toolhead.extruder].target`, чтобы получить целевую температуру текущего экструдера.
- `homed_axes`: Текущие декартовы оси, которые считаются находящимися в состоянии ""дома"". Это строка, содержащая одно или несколько значений "x", "y", "z".
- `axis_minimum`, `axis_maximum`: Предельные значения перемещения оси (мм) после наведения. Можно получить доступ к компонентам x, y, z этого предельного значения (например, `axis_minimum.x`, `axis_maximum.z`).
- Для принтеров Delta значение `cone_start_z` - это максимальная высота по оси z при максимальном радиусе (`printer.toolhead.cone_start_z`).
- `max_velocity`, `max_accel`, `minimum_cruise_ratio`, `square_corner_velocity`: Текущие действующие ограничения печати. Они могут отличаться от настроек файла конфигурации, если команда `SET_VELOCITY_LIMIT` (или `M204`) изменит их во время выполнения.
- `stalls`: Общее количество раз (с момента последнего перезапуска), когда принтер был приостановлен из-за того, что головка инструмента двигалась быстрее, чем можно было считать перемещения из G-кода.

## dual_carriage

Следующая информация доступна в [dual_carriage](Config_Reference.md#dual_carriage) для робота cartesian, hybrid_corexy или hybrid_corexz

- `carriage_0`: Режим работы каретки 0. Возможные значения: " ИНАКТИВНЫЙ" и "ПЕРВИЧНЫЙ".
- `Карета_1`: Режим работы каретки 1. Возможные значения: " ИНАКТИВНЫЙ", "ПЕРВИЧНЫЙ", "КОПИРОВАНИЕ" и "ЗЕРКАЛО".

On a `generic_cartesian` kinematic, the following information is available in `dual_carriage`:

- `carriages["<carriage>"]`: The mode of the carriage `<carriage>`. Possible values are "INACTIVE" and "PRIMARY" for the primary carriage and "INACTIVE", "PRIMARY", "COPY", and "MIRROR" for the dual carriage.

## virtual_sdcard

Следующая информация доступна в объекте [virtual_sdcard](Config_Reference.md#virtual_sdcard):

- `is_active`: Возвращает True, если печать из файла активна в данный момент.
- `progress`: Оценка текущего прогресса печати (на основе размера и позиции файла).
- `file_path`: Полный путь к файлу текущего загруженного файла.
- `file_position`: Текущая позиция (в байтах) активного отпечатка.
- `file_size`: Размер файла (в байтах) текущего загруженного файла.

## вебхуки

Следующая информация доступна в объекте `webhooks` (этот объект всегда доступен):

- `state`: Возвращает строку, указывающую на текущее состояние клиппера. Возможные значения: "готов", "запуск", "выключение", "ошибка".
- `state_message`: Человекочитаемая строка, дающая дополнительный контекст о текущем состоянии Klipper.

## z_thermal_adjust

Следующая информация доступна в объекте `z_thermal_adjust` (этот объект доступен, если определен [z_thermal_adjust](Config_Reference.md#z_thermal_adjust)).

- `включено`: Возвращает True, если настройка включена.
- `температура`: Текущая (сглаженная) температура определенного датчика. [degC]
- `measured_min_temp`: Минимальная измеренная температура. [degC]
- `measured_max_temp`: Максимальная измеренная температура. [degC]
- `current_z_adjust`: Последняя вычисленная корректировка по Z [мм].
- `z_adjust_ref_temperature`: Текущая опорная температура, используемая для расчета Z `current_z_adjust` [degC].

## z_tilt

Следующая информация доступна в объекте `z_tilt` (этот объект доступен, если определено z_tilt):

- `applied`: True, если процесс выравнивания наклона был запущен и успешно завершен.
