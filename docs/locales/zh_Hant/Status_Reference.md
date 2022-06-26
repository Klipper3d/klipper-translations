# 狀態參考

本文件是可用於 Klipper [宏](Command_Templates.md)、[顯示欄位](Config_Reference.md#display)以及[API伺服器](API_Server.md) 的印表機狀態資訊的參考。

本文件中的欄位可能會發生變化 - 如果使用了任何欄位，在更新 Klipper 時，請務必檢視[配置變化文件](Config_Changes.md)。

## angle

The following information is available in [angle some_name](Config_Reference.md#angle) objects:

- `temperature`: The last temperature reading (in Celsius) from a tle5012b magnetic hall sensor. This value is only available if the angle sensor is a tle5012b chip and if measurements are in progress (otherwise it reports `None`).

## bed_mesh

[bed_mesh](Config_Reference.md#bed_mesh) 對像中提供了以下資訊：

- `profile_name`、`mesh_min`、`mesh_max`、`probed_matrix`、`mesh_matrix`：關於目前活躍的 bed_mesh 配置資訊。
- `profiles`: The set of currently defined profiles as setup using BED_MESH_PROFILE.

## configfile

`configfile` 對像中提供了以下資訊（該對像始終可用）：

- `settings.<分段>.<選項>`：返回最後一次軟體啟動或重啟時給定的配置檔案設定（或預設值）。(不會反映執行時的修改。）
- `config.<分段>.<選項>`：返回Klipper在上次軟體啟動或重啟時讀取的原始配置檔案設定。(不會反映執行時的修改。)所有值都以字串形式返回。
- `save_config_pending`：如果存在可以通過 `SAVE_CONFIG` 命令儲存到配置檔案的更新，則返回 True。
- `save_config_pending_items`: Contains the sections and options that were changed and would be persisted by a `SAVE_CONFIG`.
- `warnings`：有關配置選項的警告列表。列表中的每個條目都將是一個 dictionary，其中包含 ` type` 和 `message` 欄位（都是字串）。根據警告型別，可能還有其他可用欄位。

## display_status

`display_status` 對像中提供以下資訊（如果定義了 [display](Config_Reference.md#display) 配置分段，則該對像自動可用）：

- `progress`：最後一個 `M73` G程式碼命令報告的進度（如果沒有收到`M73`，則會用`virtual_sdcard.progress`替代）。
- `message`：最後一條 `M117` G程式碼命令中包含的訊息。

## endstop_phase

[endstop_phase](Config_Reference.md#endstop_phase) 對像中提供了以下資訊：

- `last_home.<步進電機名>.phase`：最後一次歸為嘗試結束時步進電機的相位。
- `last_home.<步進電機名稱>.phase`：步進電機上可用的總相數。
- `last_home.<步進電機名稱>.mcu_position`：步進電機在上次歸位嘗試結束時的位置（由微控制器跟蹤）。該位置是自微控制器最後一次重啟以來，向前走的總步數減去反向走的總步數。

## exclude_object

The following information is available in the [exclude_object](Exclude_Object.md) object:


   - `objects`: An array of the known objects as provided by the `EXCLUDE_OBJECT_DEFINE` command. This is the same information provided by the `EXCLUDE_OBJECT VERBOSE=1` command. The `center` and `polygon` fields will only be present if provided in the original `EXCLUDE_OBJECT_DEFINE`Here is a JSON sample:

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

- `excluded_objects`: An array of strings listing the names of excluded objects.
- `current_object`: The name of the object currently being printed.

## fan

[fan](Config_Reference.md#fan)、[heater_fan some_name](Config_Reference.md#heater_fan)和[controller_fan some_name](Config_Reference.md#controller_fan)對像提供了以下資訊：

- `speed`：風扇速度，0.0和1.0之間的浮點數。
- `rpm`：如果風扇有一個 tachometer_pin，則測量的風扇速度，單位是每分鐘轉數。

## filament_switch_sensor

[filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor) 對像提供了以下資訊：

- `enabled`：如果開關感測器目前已啟用，則返回True。
- `filament_detected`：如果感測器處於觸發狀態，則返回 True。

## filament_motion_sensor

[filament_motion_sensor 感測器名](Config_Reference.md#filament_motion_sensor) 對像提供了以下資訊：

- `enabled`：如果目前啟用了運動感測器，則返回 True。
- `filament_detected`：如果感測器處於觸發狀態，則返回 True。

## firmware_retraction

[firmware_retraction](Config_Reference.md#firmware_retraction) 對像提供了以下資訊：

- `retract_length`、`retract_speed`、`unretract_extra_length`、`unretract_speed`：firmware_retraction 模組的當前設定。如果 `SET_RETRACTION` 命令改變它們，這些設定可能與配置檔案不同。

## gcode_macro

[gcode_macro <名稱> 對像提供了以下資訊：

- `<變數名>`：[gcode_macro 變數](Command_Templates.md#variables) 的當前值。

## gcode_move

`gcode_move` 對像中提供了以下資訊（該對像始終可用）：

- `gcode_position`：工具頭相對於目前 G 程式碼原點的當前位置。也就是可以直接被髮送到`G1`命令的位置。可以分別訪問這個位置的x、y、z和e份量（例如，`gcode_position.x`）。
- `position`：列印頭在配置檔案中定義的座標系中的最後指令位置。可以訪問這個位置的x、y、z和e份量（例如，`position.x`）。
- `homing_origin`：在`G28`命令之後要使用的 G-Code 座標系的原點（相對於配置檔案中定義的座標系）。`SET_GCODE_OFFSET` 命令可以改變這個位置。可以分別訪問這個位置的x、y和z份量（例如，`homing_origin.x`）。
- `speed`：在`G1`命令中最後一次設定的速度（單位：mm/s）。
- `speed_factor`：通過 `M220` 命令設定的"速度因子覆蓋"。這是一個浮點值，1.0 意味著沒有覆蓋，例如，2.0 將請求的速度翻倍。
- `extrude_factor`：由`M221`命令設定的"擠出倍率覆蓋" 。這是一個浮點值，1.0意味著沒有覆蓋，例如，2.0將使要求的擠出量翻倍。
- `absolute_coordinates`：如果在 `G90` 絕對座標模式下，則返回 True；如果在 `G91` 相對模式下，則返回 False。
- `absolute_extrude`：如果在`M82`絕對擠出模式，則返回True；如果在`M83`相對模式，則返回False。

## hall_filament_width_sensor

[hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor) 對像提供了以下資訊：

- `is_active`：如果感測器目前處於活動狀態，返回True。
- `Diameter`：上一次感測器讀數，單位為 mm。
- `Raw`：上一次感測器原始 ADC 讀數。

## heater

加熱器對象，如[extruder](Config_Reference.md#extruder)、[heater_bed](Config_Reference.md#heater_bed)和[heater_generic](Config_Reference.md#heater_generic)，提供了以下資訊：

- `temperature`：給定加熱器最後報告的溫度（以攝氏度為單位的浮點數）。
- `target`：給定加熱器的當前目標溫度（以攝氏度為單位的浮點數）。
- `power`：與加熱器相關的 PWM 引腳的最後設定（0.0和1.0之間的數值）。
- `can_extrude`：擠出機是否可以擠出（由`min_extrude_temp`定義），僅可用於[extruder](Config_Reference.md#extruder)

## heaters

`heaters` 對像中提供以下資訊（如果定義了任何加熱器，則該對象可用）：

- `available_heaters`：返回所有當前可用加熱器的完整配置分段名稱，例如 `["extruder"、"heater_bed"、"heater_generic my_custom_heater"]`。
- `available_sensors`：返回所有當前可用的溫度感測器的完整配置分段名稱列表，例如：`["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"] `。

## idle_timeout

[idle_timeout](Config_Reference.md#idle_timeout) 對像中提供了以下資訊（該對像始終可用）：

- `state`：由 idle_timeout 模組跟蹤的印表機的當前狀態。它可以是以下字串之一："Idle", "Printing", "Ready"。
- `printing_time`：印表機處於「Printing」狀態的時間（以秒為單位）（由 idle_timeout 模組跟蹤）。

## led

The following information is available for each `[led led_name]`, `[neopixel led_name]`, `[dotstar led_name]`, `[pca9533 led_name]`, and `[pca9632 led_name]` config section defined in printer.cfg:

- `color_data`: A list of color lists containing the RGBW values for a led in the chain. Each value is represented as a float from 0.0 to 1.0. Each color list contains 4 items (red, green, blue, white) even if the underyling LED supports fewer color channels. For example, the blue value (3rd item in color list) of the second neopixel in a chain could be accessed at `printer["neopixel <config_name>"].color_data[1][2]`.

## mcu

[mcu](Config_Reference.md#mcu)和[mcu some_name](Config_Reference.md#mcu-my_extra_mcu)對像提供了以下資訊：

- `mcu_version`：由微控制器報告的 Klipper 程式碼版本。
- `mcu_build_versions`：有關用於產生微控制器程式碼的構建工具的資訊（由微控制器報告）。
- `mcu_constants.<常量名>`：由微控制器報告編譯時使用的常量。可用的常量在不同的微控制器架構和每個程式碼修訂版中可能有所不同。
- `last_stats.<統計資訊名>`：關於微控制器連線的統計資訊。

## motion_report

`motion_report` 對像提供了以下資訊（如果定義了任何步進器配置分段，則該對像自動可用）：

- `live_position`：請求的列印頭位置插值到目前時間后的位置。
- `live_velocity`：目前請求的列印頭速度（以毫米/秒為單位）。
- `live_extruder_velocity`：目前請求的擠出機速度（單位：mm/s）。

## output_pin

[output_pin <配置名稱> 對像提供以下資訊：

- `value`：由`SET_PIN`指令設定的引腳「值」。

## palette2

[palette2](Config_Reference.md#palette2) 對像提供了以下資訊：

- `ping`。最後一次報告的Palette 2 ping值（百分比）。
- `remaining_load_length`：當開始一個使用 Palette 2 的列印時，這是需要載入到擠出機中的耗材長度。
- `is_splicing`：當Palette 2正在拼接耗材時為 True。

## pause_resume

[palette2](Config_Reference.md#palette2) 對像提供了以下資訊：

- `is_paused`：如果執行了 PAUSE 命令而沒有執行 RESUME，則返回 True。

## print_stats

`print_stats` 對像提供了以下資訊（如果定義了 [virtual_sdcard](Config_Reference.md#virtual_sdcard) 配置分段，則此對像自動可用）：

- `filename`、`total_duration`、`print_duration`、`filament_used`、`state`、`message`：virtual_sdcard 列印處於活動狀態時有關目前列印的估測。

## probe

[probe](Config_Reference.md#probe) 對像中提供了以下資訊（如果定義了 [bltouch](Config_Reference.md#bltouch) 配置分段，則此對象也可用）：

- `last_query`：如果探針在上一個 QUERY_PROBE 命令期間報告為"已觸發"，則返回 True。請注意，如果在宏中使用它，根據模板展開的順序，必須在包含此引用的宏之前執行 QUERY_PROBE 命令。
- `last_z_result`：返回上一次 PROBE 命令的結果 Z 值。請注意，由於模板展開的順序，在宏中使用時必須在包含此引用的宏之前執行 PROBE（或類似）命令。

## quad_gantry_level

`quad_gantry_level` 對像提供了以下資訊（如果定義了 quad_gantry_level，則該對象可用）：

- `applied`：如果龍門調平已執行併成功完成，則為 True。

## query_endstops

`query_endstops` 對像提供以下資訊（如果定義了任何限位，則該對象可用）：

- `last_query["<限位>"]`：如果在最後一次 QUERY_ENDSTOP 命令中，給定的 endstop 處於「觸發」狀態，則返回 True。注意，如果在宏中使用，由於模板擴充套件的順序，QUERY_ENDSTOP 命令必須在包含這個引用的宏之前執行。

## servo

[servo some_name](Config_Reference.md#servo) 對像提供了以下資訊：

- `printer["servo <配置名>"].value`：與指定伺服相關 PWM 引腳的上一次設定的值（0.0 和 1.0 之間的值）。

## system_stats

`system_stats` 對像提供了以下資訊（該對像始終可用）：

- `sysload`、`cputime`、`memavail`：關於主機操作系統和程序負載的資訊。

## 溫度感測器

以下資訊可在

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor)、[htu21d config_section_name](Config_Reference.md#htu21d-sensor)、[lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor)和[temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) 對像：

- `temperature`：上一次從感測器讀取的溫度。
- `hemidity`、`pressure`和`gas`：感測器上一次讀取的值（僅在bme280、htu21d和lm75感測器上）。

## temperature_fan

[temperature_fan some_name](Config_Reference.md#temperature_fan) 對像提供了以下資訊：

- `temperature`：上一次從感測器讀取的溫度。
- `target`：風扇目標溫度。

## temperature_sensor

[temperature_sensor some_name](Config_Reference.md#temperature_sensor) 對像提供了以下資訊：

- `temperature`：上一次從感測器讀取的溫度。
- `measured_min_temp`和`measured_max_temp`：自Klipper主機軟體上次重新啟動以來，感測器測量的最低和最高溫度。

## tmc 驅動

[TMC 步進驅動](Config_Reference.md#tmc-stepper-driver-configuration)對像（例如，`[tmc2208 stepper_x]`）提供了以下資訊：

- `mcu_phase_offset`：微控制器步進位置與驅動器的"零"相位的相對位置。如果相位偏移未知，則此欄位可能為空。
- `phase_offset_position`：對應電機「零」相位的「指令位置」。如果相位偏移未知，則該欄位可以為空。
- `drv_status`：上次驅動狀態查詢結果。（僅報告非零欄位。如果驅動沒有被啟用（因此沒有輪詢），則此欄位將為 null。
- `run_current`：目前設定的執行電流。
- `hold_current`：目前設定的保持電流。

## toolhead

`toolhead` 對像提供了以下資訊（該對像始終可用）：

- `position`：列印頭相對於配置檔案中指定的座標系的最後命令位置。可以訪問該位置的 x、y、z 和 e 份量（例如，`position.x`）。
- `extruder`：目前活躍的擠出機的名稱。例如，在宏中可以使用`printer[printer.toolhead.extruder].target`來獲取目前擠出機的目標溫度。
- `homed_axes`：目前被認為處於「已歸位」狀態的車軸。這是一個包含一個或多個"x"、"y"、"z"的字串。
- `axis_minimum`、`axis_maximum`：歸位后的軸的行程限制（毫米）。可以訪問此極限值的 x、y、z 份量（例如，`axis_minimum.x`、`axis_maximum.z`）。
- `max_velocity`、`max_accel`、`max_accel_to_decel`和`square_corner_velocity`：目前生效的印表機限制。如果 `SET_VELOCITY_LIMIT`（或 `M204`）命令在執行時改變它們，這些值可能與配置檔案設定不同。
- `stalls`：由於工具頭移動速度快于從 G 程式碼輸入讀取的移動速度，因此印表機必須暫停的總次數（自上次重新啟動以來）。

## dual_carriage

使用了 hybrid_corexy 或 hybrid_corexz 運動學的 [dual_carriage](Config_Reference.md#dual_carriage) 對像提供了以下資訊

- `mode`：目前模式。可能的值："FULL_CONTROL"
- `active_carriage`：目前的活躍的滑車。可能的值是"CARRIAGE_0"和"CARRIAGE_1"

## virtual_sdcard

[virtual_sdcard](Config_Reference.md#virtual_sdcard)對像提供了以下資訊：

- `is_active`：如果正在從檔案進行列印，則返回 True。
- `progress`：對當前列印進度的估計（基於檔案大小和檔案位置）。
- `file_path`：目前載入的檔案的完整路徑。
- `file_position`：目前列印的位置（以位元組為單位）。
- `file_size`：目前載入的檔案的大小（以位元組為單位）。

## webhooks

`system_stats` 對像提供了以下資訊（該對像始終可用）：

- `state`：返回一個表示目前 Klipper 狀態的字串。可能的值為："ready"、"startup"、"shutdown"和"error"。
- `state_message`：提供了一個包含目前 Klipper 狀態和上下文的可讀字串。

## z_tilt

`z_tilt` 對像提供了以下資訊（如果定義了 z_tilt，則該對象可用）：

- `applied`：如果 z 傾斜調平過程已執行併成功完成，則為 True。
