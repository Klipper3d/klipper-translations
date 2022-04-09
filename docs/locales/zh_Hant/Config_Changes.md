# 配置變更

本文件涵蓋了軟體更新中對配置檔案不向后相容的部分。在升級 Klipper 時，最好也檢視一下這份文件。

本文件中的所有日期都是不精確的。

## 變更

20220407: The temperature_fan `pid_integral_max` config option has been removed (it was deprecated on 20210612).

20220407: The default color order for pca9632 LEDs is now "RGBW". Add an explicit `color_order: RBGW` setting to the pca9632 config section to obtain the previous behavior.

20220330: The format of the `printer.neopixel.color_data` status information for neopixel and dotstar modules has changed. The information is now stored as a list of color lists (instead of a list of dictionaries). See the [status reference](Status_Reference.md#led) for details.

20220307: `M73` will no longer set print progress to 0 if `P` is missing.

20220304: There is no longer a default for the `extruder` parameter of [extruder_stepper](Config_Reference.md#extruder_stepper) config sections. If desired, specify `extruder: extruder` explicitly to associate the stepper motor with the "extruder" motion queue at startup.

20220210：`SYNC_STEPPER_TO_EXTRUDER`、`SET_EXTRUDER_STEP_DISTANCE`、[extruder](Config_Reference.md#extruder)的 `shared_heater` 配置選項已棄用。這些功能將在不久的將來被刪除。將`SET_EXTRUDER_STEP_DISTANCE`替換為`SET_EXTRUDER_ROTATION_DISTANCE`，`SYNC_STEPPER_TO_EXTRUDER`替換為`SYNC_EXTRUDER_MOTION`，使用 `shared_heater` 與 [extruder_stepper](Config_Reference.md#extruder_stepper)配置分段替換 extruder 配置分段，並更新所有啟用宏以使用 [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion)。

20220116: 變更了tmc2130、tmc2208、tmc2209和tmc2660的 `run_current` 計算程式碼。對於一些 `run_current`設定，驅動程式現在的配置結果可能被和原來不同。新的配置應該更準確，但它可能導致前的tmc驅動調諧失效。

20211230: 遷移輸入整形器調整指令碼（`scripts/calibrate_shaper.py`和`scripts/graph_accelerometer.py`），新指令碼預設使用Python3。因此，必須安裝Python3版本的某些軟體包（例如，`sudo apt install python3-numpy python3-matplotlib`）才能繼續使用這些指令碼。更多細節，請參考[軟體安裝](Measuring_Resonances.md#software-installation)。另外，使用者可以通過在控制檯顯性呼叫Python2直譯器，臨時強制在Python 2下執行這些指令碼：`python2 ~/klipper/scripts/calibrate_shaper.py ...`

20211110: 棄用"NTC 100K beta 3950 "溫度感測器。未來會刪除這個感測器。大多數使用者會發現 "Generic 3950 "溫度感測器更準確。要繼續使用舊的（通常不太準確）定義，請定義一個自定義的[thermistor](Config_Reference.md#thermistor)，其中包括`temperature1: 25`，`resistance1: 100000`和`beta: 3950`。

20211104：刪除了"make menuconfig "中的 "step pulse duration "選項。現在在UART或SPI模式下配置的TMC驅動器的預設步長是100ns。在[stepper config section](Config_Reference.md#stepper)中的增加了一個新的`step_pulse_duration`設定，所有需要自定義脈衝持續時間的步進驅動器都需要設定。

20211102：刪除了多個廢棄的功能。刪除了步進器`step_distance`選項（已於20201222廢棄）。刪除了`rpi_temperature`感測器別名（已於20210219廢棄）。刪除了mcu的`pin_map`選項（已於20210325廢棄）。刪除了gcode_macro `default_parameter_<name>`和通過`params`偽變數以外的宏訪問命令參數（已於20210503廢棄）。刪除了加熱器的`pid_integral_max`選項（已於20210612廢棄）。

20210929: Klipper v0.10.0發佈。

20210903: 加熱器的預設[`smooth_time`](Config_Reference.md#extruder)已改為1秒（從2秒）。對於大多數印表機來說，這將使溫度控制更加穩定。

20210830: 預設的adxl345名稱現在是 "adxl345"。`ACCELEROMETER_MEASURE`和`ACCELEROMETER_QUERY`的預設CHIP參數現在也是 "adxl345"。

20210830: adxl345 ACCELEROMETER_MEASURE命令不再支援RATE參數。要改變查詢速率，請更新printer.cfg檔案併發出RESTART命令。

20210821: `printer.configfile.settings`中的一些配置設定現在將以列表形式報告，而不是原始字串。如果需要原始的字串，請使用`printer.configfile.config`代替。

20210819: 在某些情況下，`G28`的歸零動作可能在某個超出有效移動範圍的位置結束。在少數情況下，這可能導致歸位后出現 "移動超出範圍（Move out of range）"的錯誤。如果發生這種情況，請改變你的啟動指令碼，在歸位后立即將列印頭移動到有效位置。

20210814: atmega168和atmega328上的僅有模擬的偽引腳已經從PE0/PE1改名為PE2/PE3。

20210720: controller_fan部分現在預設監控所有步進電機（而不僅僅是運動型步進電機）。如果需要以前的行為，請參考[config reference](Config_Reference.md#controller_fan)中的`stepper`配置選項。

20210703: `samd_sercom`配置部分現在必須通過`sercom`選項指定它要配置的sercom匯流排。

20210612: 加熱器(heater)和溫度控制風扇(temperature_fan)配置中的`pid_integral_max`選項已被棄用。該選項將在未來被移除。

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430: SET_VELOCITY_LIMIT（和M204）命令現在可以設定大於配置檔案中指定值的速度(velocity)、加速度(acceleration)和轉角離心速度(square_corner_velocity)。

20210325:配置中的`pin_map`選項已被廢棄。使用[sample-aliases.cfg](../config/sample-aliases.cfg)檔案將現有的引腳名翻譯成實際的微控制器引腳名稱。配置中的`pin_map` 選項將在未來被移除。

20210313：Klipper對CAN匯流排通訊的微控制器的支援發生了變化。如果使用CAN匯流排，全部微控制器必須被重新刷寫並更新[Klipper CAN 匯流排配置](CANBUS.md)。

20210310：TMC2660 預設 driver_SFILT 從1 改為 0。

20210227：現在每當啟用 UART 或 SPI 模式的 TMC 步進電機驅動活躍時，每秒會查詢一次 - 如果無法聯繫到驅動或如果驅動報告錯誤，則 Klipper 將過渡到關閉狀態。

20210219：`rpi_temperature` 模組已被重新命名為 `temperature_host`。用 `sensor_type: temperature_host` 替換全部的 `sensor_type: rpi_temperature`。溫度檔案的路徑可以在 `sensor_path` 配置變數中指定。名稱「`rpi_temperature`」已被廢棄，在不久的將來會被刪除。

20210201: `TEST_RESONANCES` 命令現在將禁用之前啟用的輸入整形（並在測試後重新啟用）。如果需要覆蓋這一行為並保持輸入整形在測試時啟用，可以在命令中傳遞一個附加參數 `INPUT_SHAPING=1`。

20210201：如果一個加速度計晶片在printer.cfg的相應 adxl345 分段被賦予了一個名稱，`ACCELEROMETER_MEASURE` 命令的輸出檔案現在會包含它的名稱。

20201222：步進配置分段中的`step_distance`設定已被廢棄。建議更新配置以使用[`rotrot_distance`](Rotation_Distance.md)設定。對`step_distance`的支援將在不久的將來被移除。

20201218：endstop_phase 模組中的 `endstop_phase` 設定已被 `trigger_phase` 取代。如果使用相位限位模組，則需要轉換為 [`rotation_distance`](Rotation_Distance.md)，並通過執行 ENDSTOP_PHASE_CALIBRATE 命令重新校準任何相位限位。

20201218：旋轉三角洲和極點印表機現在必須為旋轉步進電機指定 `gear_ratio ` ，並且它們可以不再指定 `step_distance ` 參數。有關新 gear_ratio 參數的格式，請參閱 [配置參考](Config_Reference.md#stepper)。

20201213：當使用"probe:z_virtual_endstop"時，指定的 Z "position_endstop"是無效的。現在，如果用"probe:z_virtual_endstop"指定一個 Z "position_endstop"，將會報告一個錯誤。刪除 Z 的 "position_endstop"定義以解決這個錯誤。

20201120: `[board_pins]`配置部分現在在`mcu:`參數中明確指定了對應MCU名稱。如果使用輔助MCU的board_pins，則必須更新配置以指定該MCU名稱。參見 [配置參考](Config_Reference.md#board_pins) 以瞭解更多細節。

20201112: 由`print_stats.print_duration`控制的報告時間已經改變。現在不包括檢測到的首次擠出之前的時間。

20201029: neopixel `color_order_GRB` 配置已從配置中移除。如果需要，請更新配置檔案，將新的`color_order`選項設定為RGB、GRB、RGBW或GRBW。

20201029: mcu配置部分的序列選項不再預設為 /dev/ttyS0 。在極其罕見的情況下，如果 /dev/ttyS0 是所需的串列埠，必須明確指定它。

20201020: Klipper v0.9.0發佈。

20200902: 修正了MAX31865轉換器的RTD電阻-溫度計算無法為低的錯誤。如果你使用此晶片，請重新校準你的列印溫度和PID設定。

20200816: G程式碼宏`printer.gcode`對像已被重新命名為`printer.gcode_move`。刪除了 `printer.toolhead` 和 `printer.gcode` 中幾個沒有文件的變數。參見 docs/Command_Templates.md 以獲得可用的模板變數列表。

20200816: gcode宏 "action_"系統已經改變。請用`action_emergency_stop()`替換所有`printer.gcode.action_emergency_stop()` ，用`action_respond_info()`替換所有`printer.gcode.action_respond_info()`，用`action_raise_error()`替換所有`printer.gcode.action_respond_error()`。

20200809: 菜單系統已被重寫。如果是定製菜單，那需要更新配置。配置細節見config/example-menu.cfg，例子見klippy/extras/display/menu.cfg。

20200731: `virtual_sdcard`印表機對像報告的`progress`屬性的行為已經改變。當列印暫停時，進度不再被重置為0。現在它會始終根據已載入檔案的讀取位置來報告進度，如果目前沒有載入檔案，則報告0。

20200725: 移除了舵機`enable`配置參數和SET_SERVO`ENABLE`參數。請更新所有宏，用`SET_SERVO SERVO=my_servo WIDTH=0`來禁用舵機。

20200608: LCD顯示支援部分改變了一些內部 "字形 "的名稱。如果自定義了顯示佈局，可能需要更新到最新的字形名稱（見klippy/extras/display/display.cfg中的可用字形列表）。

20200606: 改變了linux mcu上的引腳名稱。現在引腳的名稱格式是`gpiochip<chipid>/gpio<gpio>`。對於gpiochip0，你也可以使用`gpio<gpio>`的縮寫。例如，以前名字為`P20'，現在變成`gpio20'或`gpiochip0/gpio20'。

20200603：預設的16x4 LCD佈局將不再顯示列印的預計剩餘時間。(只顯示已用時間。)如果需要舊的佈局，可以用定製菜單顯示該資訊(詳情見config/example-extras.cfg中display_data的描述)。

20200531: 預設的USB廠商/產品ID現在是0x1d50/0x614e。這個新ID是為Klipper保留的（感謝openmoko專案）。這個變化不需要改變任何配置，但新的ID可能會出現在系統日誌中。

20200524：現在tmc5160的pwm_freq欄位，預設值是0（而不是1）。

20200425: gcode_macro命令模板變數`printer.heater`改命名為`printer.heaters`。

20200313: 改變多擠出機印表機16x4螢幕的預設液晶屏佈局。現在預設是單個擠出機螢幕佈局，用於顯示目前活動的擠出機。要使用以前的顯示佈局，請設定printer.cfg檔案中[display]部分的 "display_group: _multiextruder_16x4"。

20200308：移除了預設的`__test`菜單項。如果配置檔案中有自定義的菜單，那麼請確保刪除所有對這個`__test`菜單項的引用。

20200308: 移除了菜單中的 "desk "和 "card "選項。要定製lcd螢幕的佈局，請使用新的display_data配置部分（詳見config/example-extras.cfg）。

20200109: bed_mesh 模組現在引用探針的位置來進行網格配置。因此，一些配置選項已被重新命名以更準確地反映其功能。對於矩形床，`min_point'和`max_point`分別重新命名為`mesh_min`和`mesh_max`。對於圓形床，`bed_radius`重新命名為`mesh_radius`。對於圓形床，還增加了一個新的`mesh_origin`選項。請注意，這些變更與之前儲存的網格配置檔案不相容。如果檢測到一個不相容的配置檔案，此檔案會被忽略並被刪除。刪除過程可以通過發出 SAVE_CONFIG 命令來完成。使用者將需要重新校準每個床的網床配置。

20191218: 顯示配置部分不再支援 "lcd_type: st7567"。請使用 "uc1701 "顯示型別代替：設定 "lcd_type: uc1701 "，將 "rs_pin: some_pin "改為 "rst_pin: some_pin"。可能還需要增加一個 "contrast: 60"的配置設定。

20191210：刪除了內建的T0、T1、T2...命令。移除了擠出機 activate_gcode 和 deactivate_gcode 配置選項。如果需要這些命令（和指令碼），請定義單獨的[gcode_macro T0]風格的宏，呼叫ACTIVATE_EXTRUDER命令。參見config/sample-idex.cfg和sample-multi-extruder.cfg檔案中的例子。

20191210：移除了對M206命令的支援。用呼叫SET_GCODE_OFFSET來代替。如果需要對M206的支援，請新增一個[gcode_macro M206]配置部分，呼叫SET_GCODE_OFFSET。(例如 "SET_GCODE_OFFSET Z=-{params.Z}"。)

20191202：移除了對 "G4 "命令中無標註的 "S "參數的支援。用標準的 "P "參數（以毫秒為單位的延遲）取代任何出現的S。

20191126：改變了那些原生USB支援的微控制器上的USB名稱。現在預設使用唯一的晶片ID（如果可用）。如果 "MCU "配置部分使用以"/dev/serial/by-id/"開頭的 "串列埠 "設定，那麼可能有必要更新配置。在ssh終端執行 "ls /dev/serial/by-id/*"來確定新的id。

20191121：移除了pressure_advance_lookahead_time參數。檢視example.cfg以瞭解替代的配置設定。

20191112：如果步進驅動器沒有專用的步進電機使能引腳，那麼就會自動啟用tmc步進驅動器的虛擬使能功能。從配置中刪除對tmcXXXX:virtual_enable的引用。移除了在步進驅動器 enable_pin 配置中控制多個引腳的能力。如果需要控制多個引腳，請使用multi_pin 配置部分。

20191107：主擠出機配置部分必須指定為 "extruder"，不得再指定為 "extruder0"。查詢擠出機狀態的Gcode命令模板現在可以通過"{printer.extruder}"訪問。

20191021: Klipper v0.8.0發佈

20191003: [safe_z_homing] 中的 move_to_previous 選項現在預設為 False。(在20190918年之前，它實際上是False。)

20190918: [safe_z_homing]中的 zhop 選項總是在Z軸歸位完成後重新應用。這可能需要使用者更新基於此模組的自定義指令碼。

20190806: SET_NEOPIXEL 命令已被重新命名為 SET_LED。

20190726：更改了mcp4728的數模轉換程式碼。預設的i2c_address現在是0x60，電壓參考現在是相對於mcp4728的內部2.048V參考源。

20190710: 刪除了[firmware_retract]配置部分中的z_hop選項。由於對z_hop的支援不完整，可能會導致幾個常見切片軟體的異常行為。

20190710：改變了PROBE_ACCURACY命令的可選參數。如果宏或指令碼使用了該命令，可能需要更新。

20190628：移除了[skew_correction]部分所有的配置選項。現在，對skew_correction的配置是通過SET_SKEW gcode完成的。推薦使用方法請參見[傾斜校正](Skew_Correction.md)。

20190607: gcode_macro 的 "variable_X "參數（以及 SET_GCODE_VARIABLE 的 VALUE 參數）現在被解析為 Python 字元。如果一個值需要分配成字串型，那麼用引號包裹該值以確保它被解析為一個字串。

20190606: samples"、"samples_result "和 "samples_retract_dist "配置選項已被移至 "probe "配置部分。在 "delta_calibrate"、"bed_tilt"、"bed_mesh"、"screw_tilt_adjust"、"z_tilt "或 "quad_gantry_level "配置部分不再支援這些選項。

20190528：gcode_macro模板評估中的特殊 "status "變數已更名為 "printer"。

20190520: SET_GCODE_OFFSET命令已經改變，請相應地更新G程式碼宏。該命令將不再把要求的偏移量應用於下一個G1命令。舊的行為可以通過使用新的 "MOVE=1 "參數來近似實現。

20190404：Python主機軟體包已經更新。使用者需要重新執行~/klipper/scripts/install-octopi.sh指令碼（如果不使用標準的OctoPi安裝，則需要升級Python的依賴關係）。

20190404：現在i2c_bus和spi_bus參數（在各個配置部分）採用匯流排名稱而不是數字。

20190404：變更了sx1509的配置參數。'address' 參數改名為 'i2c_address'且必須被指定為十進制數字。以前使用的是0x3E，現在則用62。

20190328：現在[temperature_fan]配置中的min_speed值將被使用，在PID模式下，風扇將始終以這個速度或更高的速度轉動。

20190322: [tmc2660] 配置部分中 "driver_HEND "的預設值從6改為3。"driver_VSENSE "欄位被刪除（從run_current中自動計算的）。

20190310：現在[controller_fan]配置部分總是包含一個名字（例如[controller_fan my_controller_fan]）。

20190308：[tmc2130]和[tmc2208]配置部分中的 "driver_BLANK_TIME_SELECT "欄位已被重新命名為 "driver_TBL"。

20190308：變更了[tmc2660]配置部分。現在必須提供一個新的sense_resistor配置參數。變更了幾個driver_XXX參數的含義。

20190228: SAMD21板上的SPI或I2C現在必須通過[samd_sercom]配置部分指定匯流排引腳。

20190224: bed_shape選項已從bed_mesh中移除。半徑（radius）選項已被重新命名為bed_radius。如果使用圓形床，需要提供bed_radius和round_probe_count選項。

20190107：變更了mcp4451配置部分的i2c_address參數。這是Smoothieboards上的一個常規設定。新值是舊值的一半（88應改為44，而90應改為45）。

20181220: Klipper v0.7.0發佈
