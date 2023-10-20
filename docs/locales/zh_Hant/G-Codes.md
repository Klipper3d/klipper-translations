# G-Codes

本文件描述了 Klipper 支援的命令。這些命令可以輸入到 OctoPrint 終端中。

## G程式碼命令

Klipper支援以下標準的G-Code命令：

- 移動 (G0 or G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- 停留時間：`G4 P<milliseconds>`
- 返回原點：`G28 [X] [Y] [Z]`
- 關閉步進電機：`M18`或`M84`
- 等待目前移動完成： `M400`
- 使用絕對/相對擠出距離：`M82`， `M83`
- 使用絕對/相對座標：`G90`, `G91`
- 設定座標：`G92 [X<座標>] [Y<座標>] [Z<座標>] [E<座標>]`
- 設定速度因子覆寫百分比：`M220 S<百分比>`
- 設定擠壓因子覆蓋百分比：`M221 S<percent>`
- 設定加速度：`M204 S<value>` 或 `M204 P<value> T<value>`
   - 注意：如果沒有指定S，同時指定了P和T，那麼加速度將被設定為P和T中的最小值。
- 獲取擠出機溫度：`M105`
- 設定擠出機溫度：`M104 [T<index>] [S<temperature>]`
- 設定擠出機溫度並等待：`M109 [T<index>] S<temperature>`
   - 注意：M109總是等待溫度穩定在請求的數值上
- 設定熱床溫度：`M140 [S<temperature>]`
- 設定熱床溫度並且等待：`M190 S<temperature>`
   - 注意：M190總是等待溫度穩定在請求的數值上
- 設定風扇速度：`M106 S<value>`
- 停止風扇：`M107`
- 緊急停止：`M112`
- 獲取目前位置：`M114`
- 獲取韌體版本：`M115`

有關上述命令的更多詳細資訊，請參閱 [RepRap G-Code documentation](http://reprap.org/wiki/G-code)

Klipper's goal is to support the G-Code commands produced by common 3rd party software (eg, OctoPrint, Printrun, Slic3r, Cura, etc.) in their standard configurations. It is not a goal to support every possible G-Code command. Instead, Klipper prefers human readable ["extended G-Code commands"](#additional-commands). Similarly, the G-Code terminal output is only intended to be human readable - see the [API Server document](API_Server.md) if controlling Klipper from external software.

如果一個人需要一個不太常見的G-Code命令，那麼可以用一個自定義的[gcode_macro config section](Config_Reference.md#gcode_macro)來實現它。例如，我們可以用這個來實現。`G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1` ，etc.

## 其他命令

Klipper使用 "extended" 的G程式碼命令來進行一般的配置和狀態。這些擴充套件命令都遵循一個類似的格式--它們以一個命令名開始，後面可能有一個或多個參數。比如說：`SET_SERVO SERVO=myservo ANGLE=5.3`。在本檔案中，命令和參數以大寫字母顯示，但它們不分大小寫。(所以，"SET_SERVO "和 "set_servo "都是執行同一個命令）

This section is organized by Klipper module name, which generally follows the section names specified in the [printer configuration file](Config_Reference.md). Note that some modules are automatically loaded.

### [adxl345]

當[adxl345配置分段](Config_Reference.md#adxl345)被啟用時，以下命令可用.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]` 。以要求的每秒採樣數啟動加速度計測量。如果沒有指定CHIP，則預設為 "adxl345"。該命令以啟動-停止模式工作：第一次執行時，它開始測量，下次執行時停止測量。測量結果被寫入一個名為`/tmp/adxl345-<chip>-<name>的檔案中。csv`，其中`<chip>`是加速度計晶片的名稱（`my_chip_name`來自`[adxl345 my_chip_name]`），`<name>`是可選NAME參數。如果沒有指定NAME，則預設為目前時間，格式為 "YYYMMDD_HHMMSS"。如果加速度計在其配置部分沒有名稱（只是`[adxl345]`），那麼`<chip >`部分的名稱就不會產生。

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: 查詢加速度計的當前值。如果沒有指定晶片，則預設為 "adxl345"。如果沒有指定RATE，則使用預設值。該命令對於測試與ADXL345加速度計的連線非常有用：返回的數值之一應該是自由落體加速度（+/-晶片的一些噪聲）。

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<配置名>] REG=<暫存器>`：查詢ADXL345的暫存器"REG"（例如44或0x2C）。可以用於debug。

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<配置名>] REG=<暫存器> VAL=<值>`：將原始的"值"寫進暫存器"暫存器"。"值"和"暫存器"都可以是一個十進制或十六進制的整數。請謹慎使用，並參考 ADXL345 數據手冊。

### [angle]

The following commands are available when an [angle config section](Config_Reference.md#angle) is enabled.

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<chip_name>`: Perform angle calibration on the given sensor (there must be an `[angle chip_name]` config section that has specified a `stepper` parameter). IMPORTANT - this tool will command the stepper motor to move without checking the normal kinematic boundary limits. Ideally the motor should be disconnected from any printer carriage before performing calibration. If the stepper can not be disconnected from the printer, make sure the carriage is near the center of its rail before starting calibration. (The stepper motor may move forwards or backwards two full rotations during this test.) After completing this test use the `SAVE_CONFIG` command to save the calibration data to the config file. In order to use this tool the Python "numpy" package must be installed (see the [measuring resonance document](Measuring_Resonances.md#software-installation) for more information).

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: Queries sensor register "register" (e.g. 44 or 0x2C). Can be useful for debugging purposes. This is only available for tle5012b chips.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: Writes raw "value" into register "register". Both "value" and "register" can be a decimal or a hexadecimal integer. Use with care, and refer to sensor data sheet for the reference. This is only available for tle5012b chips.

### [bed_mesh]

當啟用 [bed_mesh config section](Config_Reference.md#bed_mesh) 時，以下命令可用（另請參閱 [bed mesh guide](Bed_Mesh.md)）。

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>]`: This command probes the bed using generated points specified by the parameters in the config. After probing, a mesh is generated and z-movement is adjusted according to the mesh. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`：該命令將目前探測到的 Z 值和目前網格的值輸出到終端。如果指定 PGP=1，則將bed_mesh產生的X、Y座標，以及它們關聯的指數，輸出到終端。

#### BED_MESH_MAP

`BED_MESH_MAP`：類似 BED_MESH_OUTPUT，這個命令在終端中顯示網格的當前狀態。它不以人類可讀格式列印，而是被序列化為 json 格式。這允許 Octoprint 外掛捕獲數據並產生描繪列印床表面的高度圖。

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`：此命令清除床網並移除所有 z 調整。建議把它放在你的 end-gcode （結束G程式碼）中。

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<名稱> SAVE=<名稱> REMOVE=<名稱>`：此命令提供了網床配置管理功能。LOAD 將從與所提供的名稱相符的配置檔案中恢復網格狀態。SAVE 將會把目前的網格狀態儲存到與提供的名稱相符的配置檔案中。REMOVE（移除）將從永續性記憶體中刪除與所提供名稱相符的配置檔案。請注意，在 SAVE 或 REMOVE 操作后，必須發送SAVE_CONFIG G程式碼，以儲存變更到永續性記憶體。

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<value>] [Y=<value>]`。將X和/或Y的偏移量應用於網格查詢。這對具有多個獨立擠出頭的印表機很有用，因為偏移量對切換工具頭后產生正確的 Z 值調整是至關重要的。

### [bed_screws]

當啟用 [bed_screws config section](Config_Reference.md#bed_screws) 時，以下命令可用（另請參閱 [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws)）。

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`：該命令將呼叫列印床螺絲調整工具。它將命令噴嘴移動到不同的位置（在配置檔案中定義），並允許對列印床螺絲進行手動調整，使列印床與噴嘴的距離保持不變。

### [bed_tilt]

當啟用 [bed_tilt config section](Config_Reference.md#bed_tilt) 時，以下命令可用。

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then recommend updated x and y tilt adjustments. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

### [bltouch]

當啟用 [bltouch config section](Config_Reference.md#bltouch) 時，以下命令可用（另請參閱 [BL-Touch guide](BLTouch.md)）。

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<命令>`：向BLTouch發送一個指定的命令，可以用於除錯。可用的命令有：`pin_down`、`touch_mode`、`pin_up`、`self_test`和`reset`。BL-TOUCH V3.0 或 V3.1 也可能支援`set_5V_output_mode`、`set_OD_output_mode`和`output_mode_store`命令。

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`:這將在BLTouch V3.1的EEPROM中儲存一個輸出模式 可用的輸出模式有`5V`, `OD`

### [configfile]

模組configfile已自動載入.

#### SAVE_CONFIG

`SAVE_CONFIG`：該命令將覆蓋印表機的主配置檔案，並重新啟動主機軟體。該命令與其他校準命令一起使用，用於儲存校準測試的結果。

### [delayed_gcode]

如果啟用了 [delayed_gcode config section](Config_Reference.md#delayed_gcode)，則啟用以下命令（另請參閱  [template guide](Command_Templates.md#delayed-gcodes)）。

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<名稱>] [DURATION=<秒>]`：更新目標 [delayed_gcode] 的延遲並啟動G程式碼執行的計時器。為0的值會取消準備執行的延遲G程式碼。

### [delta_calibrate]

當啟用 [delta_calibrate config section](Config_Reference.md#linear-delta-kinematics) 時，以下命令可用（另請參見 [delta calibrate guide](Delta_Calibrate.md)）。

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe seven points on the bed and recommend updated endstop positions, tower angles, and radius. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

#### DELTA_ANALYZE

`DELTA_ANALYZE`:這個命令在增強的delta校準過程中使用。詳情見[Delta Calibrate](Delta_Calibrate.md)。

### [display]

當啟用 [display config section](Config_Reference.md#gcode_macro) 時，以下命令可用。

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`:設定一個lcd顯示器的活動顯示組。這允許在配置中定義多個顯示數據組，例如`[display_data <group> <elementname>]`並使用這個擴充套件的gcode命令在它們之間切換。如果沒有指定DISPLAY，則預設為 "display"（主顯示）。

### [display_status]

如果啟用了 [display config section](Config_Reference.md#display)，則會自動載入 display_status 模塊。它提供以下標準 G-Code命令：

- 顯示資訊： `M117 <message> `
- 設定構建百分比：`M73 P<percent>`

Also provided is the following extended G-Code command:

- `SET_DISPLAY_TEXT MSG=<message>`: Performs the equivalent of M117, setting the supplied `MSG` as the current display message. If `MSG` is omitted the display will be cleared.

### [dual_carriage]

當啟用 [dual_carriage config section](Config_Reference.md#dual_carriage) 時，以下命令可用。

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=[0|1] [MODE=[PRIMARY|COPY|MIRROR]]`: This command will change the mode of the specified carriage. If no `MODE` is provided it defaults to `PRIMARY`. Setting the mode to `PRIMARY` deactivates the other carriage and makes the specified carriage execute subsequent G-Code commands as-is. `COPY` and `MIRROR` modes are supported only for `CARRIAGE=1`. When set to either of these modes, carriage 1 will then track the subsequent moves of the carriage 0 and either copy relative movements of it (in `COPY` mode) or execute them in the opposite (mirror) direction (in `MIRROR` mode).

#### SAVE_DUAL_CARRIAGE_STATE

`SAVE_DUAL_CARRIAGE_STATE [NAME=<state_name>]`: Save the current positions of the dual carriages and their modes. Saving and restoring DUAL_CARRIAGE state can be useful in scripts and macros, as well as in homing routine overrides. If NAME is provided it allows one to name the saved state to the given string. If NAME is not provided it defaults to "default".

#### RESTORE_DUAL_CARRIAGE_STATE

`RESTORE_DUAL_CARRIAGE_STATE [NAME=<state_name>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: Restore the previously saved positions of the dual carriages and their modes, unless "MOVE=0" is specified, in which case only the saved modes will be restored, but not the positions of the carriages. If positions are being restored and "MOVE_SPEED" is specified, then the toolhead moves will be performed with the given speed (in mm/s); otherwise the toolhead move will use the rail homing speed. Note that the carriages restore their positions only over their own axis, which may be necessary to correctly restore COPY and MIRROR mode of the dual carraige.

### [endstop_phase]

當啟用 [endstop_phase config section](Config_Reference.md#endstop_phase) 時，以下命令可用（另請參閱 [endstop phase guide](Endstop_Phase.md)）。

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]` 。如果沒有提供STEPPER參數，那麼該命令將報告在過去的歸位操作中對端停步進相的統計。當提供STEPPER參數時，它會安排將給定的終點站相位設定寫入配置檔案中（與SAVE_CONFIG命令一起使用）。

### [exclude_object]

The following commands are available when an [exclude_object config section](Config_Reference.md#exclude_object) is enabled (also see the [exclude object guide](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=object_name] [CURRENT=1] [RESET=1]`: With no parameters, this will return a list of all currently excluded objects.

When the `NAME` parameter is given, the named object will be excluded from printing.

When the `CURRENT` parameter is given, the current object will be excluded from printing.

When the `RESET` parameter is given, the list of excluded objects will be cleared. Additionally including `NAME` will only reset the named object. This **can** cause print failures, if layers were already skipped.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=object_name [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`: Provides a summary of an object in the file.

With no parameters provided, this will list the defined objects known to Klipper. Returns a list of strings, unless the `JSON` parameter is given, when it will return object details in json format.

When the `NAME` parameter is included, this defines an object to be excluded.

- `NAME`: This parameter is required. It is the identifier used by other commands in this module.
- `CENTER`: An X,Y coordinate for the object.
- `POLYGON`: An array of X,Y coordinates that provide an outline for the object.

When the `RESET` parameter is provided, all defined objects will be cleared, and the `[exclude_object]` module will be reset.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=object_name`: This command takes a `NAME` parameter and denotes the start of the gcode for an object on the current layer.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=object_name]`: Denotes the end of the object's gcode for the layer. It is paired with `EXCLUDE_OBJECT_START`. A `NAME` parameter is optional, and will only warn when the provided name does not match the current object.

### [extruder]

如果啟用了 [extruder config section](Config_Reference.md#extruder)，則以下命令可用：

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: In a printer with multiple [extruder](Config_Reference.md#extruder) config sections, this command changes the active hotend.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Set pressure advance parameters of an extruder stepper (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section). If EXTRUDER is not specified, it defaults to the stepper defined in the active hotend.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: Set a new value for the provided extruder stepper's "rotation distance" (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section). If the rotation distance is a negative number then the stepper motion will be inverted (relative to the stepper direction specified in the config file). Changed settings are not retained on Klipper reset. Use with caution as small changes can result in excessive pressure between extruder and hotend. Do proper calibration with filament before use. If 'DISTANCE' value is not provided then this command will return the current rotation distance.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<name> MOTION_QUEUE=<name>`: This command will cause the stepper specified by EXTRUDER (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section) to become synchronized to the movement of an extruder specified by MOTION_QUEUE (as defined in an [extruder](Config_Reference.md#extruder) config section). If MOTION_QUEUE is an empty string then the stepper will be desynchronized from all extruder movement.

#### SET_EXTRUDER_STEP_DISTANCE

此命令已棄用，並將在不久的將來被刪除。

#### SYNC_STEPPER_TO_EXTRUDER

此命令已棄用，並將在不久的將來被刪除。

### [fan_generic]

當啟用 [fan_generic config section](Config_Reference.md#fan_generic) 時，以下命令可用。

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<速度>`該命令設定風扇的速度。"速度" 必須在0.0到1.0之間。

### [filament_switch_sensor]

當啟用 [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) 或 [filament_motion_sensor](Config_Reference.md#filament_motion_sensor) 配置部分時，以下命令可用。

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<感測器名>`：查詢耗材感測器的當前狀態。在終端中顯示的數據將取決於配置中定義的感測器型別。

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]` ：設定燈絲感測器的開/關。如果 ENABLE 設定為 0，耗材感測器將被禁用，如果設定為 1是啟用。

### [firmware_retraction]

當啟用 [firmware_retraction config section](Config_Reference.md#firmware_retraction) 時，以下標準 G-Code命令可用。這些命令允許您利用許多切片機中可用的固件回縮功能，以減少從打印件的一個部分到另一部分的非擠出移動期間的拉絲。適當配置壓力提前可減少所需的回縮長度。

- `G10`：使用目前配置的參數回抽擠出機。
- `G11`：不使用目前配置的參數回抽擠出機。

還可以使用以下額外命令.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<毫米>] [RETRACT_SPEED=<毫米每秒>] [UNRETRACT_EXTRA_LENGTH=<毫米>] [UNRETRACT_SPEED=<毫米每秒>]`：調整韌體回抽所使用的參數。RETRACT_LENGTH 決定回抽和回填的耗材長度。回抽的速度通過 RETRACT_SPEED 調整，通常設定得比較高。回填的速度通過 UNRETRACT_SPEED 調整，雖然經常比RETRACT_SPEED 低，但不是特別重要。在某些情況下，在回填時增加少量的額外長度的耗材可能有益，這可以通過 UNRETRACT_EXTRA_LENGTH 設定。SET_RETRACTION 通常作為切片機耗材配置的一部分來設定，因為不同的耗材需要不同的參數設定。

#### GET_RETRACTION

`GET_RETRACTION`:查詢目前韌體回抽所使用的參數並在終端顯示。

### [force_move]

The force_move module is automatically loaded, however some commands require setting `enable_force_move` in the [printer config](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<配置名>`：移動指定的步進電機前後運動一毫米，重複的10次。這是一個用於驗證步進電機接線的工具.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]` 。該命令將以給定的恒定速度（mm/s）強制移動給定的步進器，移動距離（mm）。如果指定了ACCEL並且大於零，那麼將使用給定的加速度（單位：mm/s^2）；否則不進行加速。不執行邊界檢查；不進行運動學更新；一個軸上的其他平行步進器將不會被移動。請謹慎使用，因為不正確的命令可能會導致損壞使用該命令幾乎肯定會使低階運動學處於不正確的狀態；隨後發出G28命令以重置運動學。該命令用於低階別的診斷和除錯。

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<值>] [Y=<值>] [Z=<值>]`：強制設定低階運動學程式碼使用的列印頭位置。這是一個診斷和除錯工具，常規的軸轉換應該使用 SET_GCODE_OFFSET 和/或 G92指令。如果沒有指定一個軸，則使用上一次命令的列印頭位置。設定一個不合理的數值可能會導致內部程式問題。這個命令可能會使邊界檢查失效，使用后發送 G28 來重置運動學。

### [gcode]

模組gcode module已自動載入.

#### RESTART

`RESTART`：這將導致主機軟體重新載入其配置並執行內部重置。此命令不會從微控制器清除錯誤狀態（請參閱 FIRMWARE_RESTART），也不會載入新軟體（請參閱 [常見問題](FAQ.md#how-do-i-upgrade-to-the-latest-software)） .

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`：這類似於重啟命令，但它也清除了微控制器的任何錯誤狀態。

#### STATUS

`STATUS`：報告Klipper主機程式的狀態。

#### HELP

`HELP`：報告可用的擴充套件G-Code命令列表。

### [gcode_arcs]

如果啟用了[gcode_arcs 配置分段](Config_Reference.md#gcode_arcs)，下列標準G程式碼命令可用：

- Arc Move Clockwise (G2), Arc Move Counter-clockwise (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`
- Arc Plane Select: G17 (XY plane), G18 (XZ plane), G19 (YZ plane)

### [gcode_macro]

當啟用 [gcode_macro config section](Config_Reference.md#gcode_macro) 時，以下命令可用（另請參閱 [command templates guide](Command_Templates.md)）。

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`：這條命令允許人們在執行時改變 gcode_macro 變數的值。所提供的 VALUE 會被解析為一個 Python 字面。

### [gcode_move]

模組gcode_move 已自動載入.

#### GET_POSITION

`GET_POSITION`: Return information on the current location of the toolhead. See the developer documentation of [GET_POSITION output](Code_Overview.md#coordinate-systems) for more information.

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]` 。設定一個位置偏移，以應用於未來的G程式碼命令。這通常用於實際改變Z床的偏移量或在切換擠出機時設定噴嘴的XY偏移量。例如，如果發送 "SET_GCODE_OFFSET Z=0.2"，那麼未來的G程式碼移動將在其Z高度上增加0.2mm。如果使用X_ADJUST風格的參數，那麼調整將被新增到任何現有的偏移上（例如，"SET_GCODE_OFFSET Z=-0.2"，然後是 "SET_GCODE_OFFSET Z_ADJUST=0.3"，將導致總的Z偏移為0.1）。如果指定了 "MOVE=1"，那麼將發出一個工具頭移動來應用給定的偏移量（否則偏移量將在指定給定軸的下一次絕對G-Code移動中生效）。如果指定了 "MOVE_SPEED"，那麼刀頭移動將以給定的速度（mm/s）執行；否則，列印頭移動將使用最後指定的G-Code速度。

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<state_name>]`：儲存目前的g-code座標解析狀態。儲存和恢復g-code狀態在指令碼和宏中很有用。該命令儲存目前g-code絕對座標模式（G90/G91）絕對擠出模式（M82/M83）原點（G92）偏移量（SET_GCODE_OFFSET）速度覆蓋（M220）擠出機覆蓋（M221）移動速度。目前XYZ位置和相對擠出機 "E "位置。如果提供NAME，它允許人們將儲存的狀態命名為給定的字串。如果沒有提供NAME，則預設為 "default".

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`：恢復之前通過 SAVE_GCODE_STATE 儲存的狀態。如果指定「MOVE=1」，則將發出刀頭移動以返回到先前的 XYZ 位置。如果指定了「MOVE_SPEED」，則刀頭移動將以給定的速度（以mm/s為單位）執行；否則工具頭移動將使用恢復的G-Code速度。

### [hall_filament_width_sensor]

當啟用 [tsl1401cl filament width sensor config section](Config_Reference.md#tsl1401cl_filament_width_sensor) 或 [hall filament width sensor config section](Config_Reference.md#hall_filament_width_sensor) 時，以下命令可用（另請參閱 [TSLl401CL Filament Width Sensor]( TSL1401CL_Filament_Width_Sensor.md) 和 [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md))：

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`：返回目前測量的耗材直徑。

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`：清除全部感測器讀數。在更換耗材後有用。

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`：關閉耗材直徑感測器並停止使用它進行流量控制。

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR`：啟用耗材直徑感測器並使用它進行流量控制。

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`：返回目前 ADC 通道讀數和校準點的 RAW 感測器值。

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`：開啟直徑記錄。

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`：停止直徑記錄。

### [heaters]

如果在配置文件中定義了加熱器，則會自動載入加熱器模塊。

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`：關閉全部加熱器。

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<配置名> [MINIMUM=<目標>] [MAXIMUM=<目標>]`：等待指定溫度感測器讀數高於 MINIMUM 和或低於 MAXIMUM。

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<加熱器名稱> [TARGET=<目標溫度>]`：設定一個加熱器的目標溫度。如果沒有提供目標溫度，則目標溫度為 0。

### [idle_timeout]

模組idle_timeout已自動載入.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<超時>]`：允許使用者設定空閑超時（以秒為單位）。

### [input_shaper]

如果啟用了 [input_shaper config section](Config_Reference.md#input_shaper)，則啟用以下命令（另請參閱 [resonance compensation guide](Resonance_Compensation.md)）。

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`：修改輸入整形參數。注意 SHAPER_TYPE 參數會同時覆寫 X 和 Y 軸的整形器型別，即使它們在 [input_shaper] 配置分段中有不同的整形器型別。SHAPER_TYPE 不能和 SHAPER_TYPE_X 和 SHAPER_TYPE_Y 參數同時使用。這些參數的細節請見[配置參考](Config_Reference.md#input_shaper)。

### [manual_probe]

模組manual_probe已自動載入.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`：執行一個輔助指令碼，對測量給定位置的噴嘴高度有用。如果指定了速度，它將設定TESTZ命令的速度（預設為5mm/s）。在手動探測過程中，可使用以下附加命令：

- `ACCEPT`：該命令接受目前的Z位置，並結束手動探測工具。
- `ABORT`：該命令終止手動探測工具。
- `TESTZ Z=<值>`：這個命令可以將噴嘴上升或下降給定值，以毫米為單位。例如，`TESTZ Z=-.1` 會將噴嘴下降 0.1 毫米，而 `TESTZ Z=.1` 會將噴嘴上升 0.1 毫米，參數可以帶有`+`, `-`, `++`, or `--`來根據上次嘗試相對的移動噴嘴。

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<速度>]`：執行一個校準 Z position_endstop 參數的輔助指令碼。有關更多參數和額外命令的資訊，請檢視 MANUAL_PROBE 命令。

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`：將目前的Z 的 G 程式碼偏移量（就是 babystepping）從 stepper_z 的 endstop_position 中減去。該命令將持久化一個常用babystepping 微調值。需要執行 `SAVE_CONFIG`才能生效。

### [manual_stepper]

當[manual_stepper 配置分段](Config_Reference.md#manual_stepper)被啟用時，以下命令可用。

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]]`：該命令將改變步進器的狀態。使用ENABLE參數來啟用/禁用步進。使用SET_POSITION參數，迫使步進認為它處於給定的位置。使用MOVE參數，要求移動到給定位置。如果指定了SPEED或者ACCEL，那麼將使用給定的值而不是配置檔案中指定的預設值。如果指定ACCEL為0，那麼將不執行加速。如果STOP_ON_ENDSTOP=1被指定，那麼如果止動器報告被觸發，動作將提前結束（使用STOP_ON_ENDSTOP=2來完成動作，即使止動器沒有被觸發也不會出錯，使用-1或-2來在止動器報告沒有被觸發時停止）。通常情況下，未來的G-Code命令將被安排在步進運動完成後執行，但是如果手動步進運動使用SYNC=0，那麼未來的G-Code運動命令可能與步進運動平行執行。

### [mcp4018]

The following command is available when a [mcp4018 config section](Config_Reference.md#mcp4018) is enabled.

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: This command will change the current value of the digipot. This value should typically be between 0.0 and 1.0, unless a 'scale' is defined in the config. When 'scale' is defined, then this value should be between 0.0 and 'scale'.

### [led]

The following command is available when any of the [led config sections](Config_Reference.md#leds) are enabled.

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: This sets the LED output. Each color `<value>` must be between 0.0 and 1.0. The WHITE option is only valid on RGBW LEDs. If the LED supports multiple chips in a daisy-chain then one may specify INDEX to alter the color of just the given chip (1 for the first chip, 2 for the second, etc.). If INDEX is not provided then all LEDs in the daisy-chain will be set to the provided color. If TRANSMIT=0 is specified then the color change will only be made on the next SET_LED command that does not specify TRANSMIT=0; this may be useful in combination with the INDEX parameter to batch multiple updates in a daisy-chain. By default, the SET_LED command will sync it's changes with other ongoing gcode commands. This can lead to undesirable behavior if LEDs are being set while the printer is not printing as it will reset the idle timeout. If careful timing is not needed, the optional SYNC=0 parameter can be specified to apply the changes without resetting the idle timeout.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: Assign a [display_template](Config_Reference.md#display_template) to a given [LED](Config_Reference.md#leds). For example, if one defined a `[display_template my_led_template]` config section then one could assign `TEMPLATE=my_led_template` here. The display_template should produce a comma separated string containing four floating point numbers corresponding to red, green, blue, and white color settings. The template will be continuously evaluated and the LED will be automatically set to the resulting colors. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If INDEX is not specified then all chips in the LED's daisy-chain will be set to the template, otherwise only the chip with the given index will be updated. If TEMPLATE is an empty string then this command will clear any previous template assigned to the LED (one can then use `SET_LED` commands to manage the LED's color settings).

### [output_pin]

當啟用 [output_pin config section](Config_Reference.md#output_pin) 時，以下命令可用。

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: Set the pin to the given output `VALUE`. VALUE should be 0 or 1 for "digital" output pins. For PWM pins, set to a value between 0.0 and 1.0, or between 0.0 and `scale` if a scale is configured in the output_pin config section.

Some pins (currently only "soft PWM" pins) support setting an explicit cycle time using the CYCLE_TIME parameter (specified in seconds). Note that the CYCLE_TIME parameter is not stored between SET_PIN commands (any SET_PIN command without an explicit CYCLE_TIME parameter will use the `cycle_time` specified in the output_pin config section).

### [palette2]

啟用 [palette2 config section](Config_Reference.md#palette2) 時，以下命令可用。

Palette列印通過在GCode檔案中嵌入特殊的OCodes（Omega Codes）來工作:

- `O1`...`O32`：這些程式碼從G-Code流中讀出並且傳遞給Palette 2裝置進行處理。

還可以使用以下額外命令.

#### PALETTE_CONNECT

`PALETTE_CONNECT`：該命令初始化與Palette 2的連線。

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`：該命令斷開與Palette 2的連線。

#### PALETTE_CLEAR

`PALETTE_CLEAR`:該命令指示 Palette 2 清除所有耗材的輸入或者輸出。

#### PALETTE_CUT

`PALETTE_CUT`:該命令指引Palette 2切割耗材並且裝載分段的耗材。

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`：該命令在Palette 2上啟動智慧載入序列。通過在裝置上為印表機校準的距離擠壓，自動載入耗材，並在載入完成後指示Palette 2。該命令與耗材載入完成後直接在Palette 2螢幕上按**Smart Load**相同。

### [pid_calibrate]

如果在配置文件中定義了加熱器，則會自動載入 pid_calibrate 模塊。

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`：執行一個PID校準測試。指定的加熱器將被啟用，直到達到指定的目標溫度，然後加熱器將被關閉和開啟幾個週期。如果WRITE_FILE參數被啟用，那麼將建立檔案/tmp/heattest.txt，其中包含測試期間所有溫度樣本的日誌。

### [pause_resume]

當[pause_resume 配置分段](Config_Reference.md#pause_resume)被啟用時，以下命令可用：

#### PAUSE

`PAUSE`：暫停當前的列印。目前的位置被報錯以便在恢復時恢復。

#### RESUME

`RESUME [VELOCITY=<value>]`：從暫停中恢復列印，首先恢復以前保持的位置。VELOCITY參數決定了工具返回到原始捕捉位置的速度。

#### CLEAR_PAUSE

`CLEAR_PAUSE`:清除目前的暫停狀態而不恢復列印。如果一個人決定在暫停后取消列印，這很有用。建議將其新增到你的啟動程式碼中，以確保每次列印時的暫停狀態是新的。

#### CANCEL_PRINT

`CANCEL_PRINT`：取消目前的列印。

### [print_stats]

The print_stats module is automatically loaded.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>] [CURRENT_LAYER= <current_layer>]`: Pass slicer info like layer act and total to Klipper. Add `SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>]` to your slicer start gcode section and `SET_PRINT_STATS_INFO [CURRENT_LAYER= <current_layer>]` at the layer change gcode section to pass layer information from your slicer to Klipper.

### [probe]

當啟用 [probe config section](Config_Reference.md#probe) 或 [bltouch config section](Config_Reference.md#bltouch) 時，以下命令可用（另請參閱 [probe calibrate guide](Probe_Calibrate.md)）。

#### PROBE

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`：向下移動噴嘴直到探針觸發。如果提供了任何可選參數，它們將覆蓋 [probe config section](Config_Reference.md#probe) 中的等效設定。

#### QUERY_PROBE

`QUERY_PROBE`:報告探針的當前狀態（"triggered"或 "open"）。

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`：計算多個探針樣本的最大、最小、平均、中位數和標準偏差。預設情況下采樣10次。否則可選參數預設為探針配置部分的同等設定。

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>] `:執行一個對校準測頭的z_offset有用的輔助指令碼。有關可選測頭參數的詳細資訊，請參見PROBE命令。參見MANUAL_PROBE命令，瞭解SPEED參數和工具啟用時可用的附加命令的詳細資訊。請注意，PROBE_CALIBRATE命令使用速度變數在XY方向以及Z方向上移動。

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`：將目前的Z 的 G 程式碼偏移量（就是 babystepping）從 probe 的 z_offset 中減去。該命令將持久化一個常用babystepping 微調值。需要執行 `SAVE_CONFIG`才能生效。

### [query_adc]

The query_adc module is automatically loaded.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]` ：返回為配置的模擬引腳收到的最後一個模擬值。如果NAME沒有被提供，將報告可用的adc名稱列表。如果提供了PULLUP（以歐姆為單位的數值），將會返回原始模擬值和給定的等效電阻。

### [query_endstops]

模組query_endstops已自動載入。目前可以使用以下標準 G-Code命令，但不建議使用它們：

- 獲取限位狀態：`M119` (使用QUERY_ENDSTOPS代替)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`：檢測限位並返回限位是否被 "triggered"或處於"open"。該命令通常用於驗證一個限位是否正常工作。

### [resonance_tester]

當啟用 [resonance_tester config section](Config_Reference.md#resonance_tester) 時，以下命令可用（另請參閱 [measuring resonances guide](Measuring_Resonances.md)）。

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`：測量並輸出所有啟用的加速度計晶片的所有軸的噪聲。

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> OUTPUT=<resonances,raw_data> [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<adxl345_chip_name>] [POINT=x,y,z] [INPUT_SHAPING=[<0:1>]]`: Runs the resonance test in all configured probe points for the requested "axis" and measures the acceleration using the accelerometer chips configured for the respective axis. "axis" can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. `adxl345_chip_name` can be one or more configured adxl345 chip,delimited with comma, for example `CHIPS="adxl345, adxl345 rpi"`. Note that `adxl345` can be omitted from named adxl345 chips. If POINT is specified it will override the point(s) configured in `[resonance_tester]`. If `INPUT_SHAPING=0` or not set(default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured or POINT is specified). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<adxl345_chip_name>] [MAX_SMOOTHING=<max_smoothing>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command, and if `[input_shaper]` was already enabled previously, these parameters take effect immediately.

### [respond]

當啟用 [respond config section](Config_Reference.md#respond) 時，以下標準 G-Code 命令可用：

- `M118 <message>`：回顯配置了預設字首的資訊（如果沒有配置字首，則返回`echo: `）。

還可以使用以下額外命令.

#### RESPOND

- `RESPOND MSG="<message>"`：回顯帶有配置的預設字首的訊息（沒有配置字首則預設 `echo: `為字首 ）。
- `RESPOND TYPE=echo MSG="<訊息>"`：回顯`echo:`開頭訊息。
- `RESPOND TYPE=echo_no_space MSG="<message>"`: echo the message prepended with `echo:` without a space between prefix and message, helpful for compatibility with some octoprint plugins that expect very specific formatting.
- `RESPOND TYPE=command MSG="<訊息>"`：回顯以`/`為字首的訊息。可以配置 OctoPrint 對這些訊息進行響應（例如，`RESPOND TYPE=command MSG=action:pause`）。
- `RESPOND TYPE=error MSG="<訊息>"`：回顯以 `!!`開頭的訊息。
- `RESPOND PREFIX=<prefix> MSG="<message>"`: 迴應以`<prefix>`為字首的資訊。(`PREFIX`參數將優先於`TYPE`參數)

### [save_variables]

如果啟用了 [save_variables config section](Config_Reference.md#save_variables)，則啟用以下命令。

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`：將變數儲存到磁碟，以便在重新啟動時使用。所有儲存的變數都會在啟動時載入到 `printer.save_variables.variables` 目錄中，並可以在 gcode 宏中使用。所提供的 VALUE 會被解析為一個 Python 字面。

### [screws_tilt_adjust]

當啟用 [screws_tilt_adjust config section](Config_Reference.md#screws_tilt_adjust) 時，以下命令可用（另請參閱 [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe ））。

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will invoke the bed screws adjustment tool. It will command the nozzle to different locations (as defined in the config file) probing the z height and calculate the number of knob turns to adjust the bed level. If DIRECTION is specified, the knob turns will all be in the same direction, clockwise (CW) or counterclockwise (CCW). See the PROBE command for details on the optional probe parameters. IMPORTANT: You MUST always do a G28 before using this command. If MAX_DEVIATION is specified, the command will raise a gcode error if any difference in the screw height relative to the base screw height is greater than the value provided. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

### [sdcard_loop]

當 [sdcard_loop config section](Config_Reference.md#sdcard_loop) 啟用時，以下擴展命令可用。

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`：SD 列印中開始循環的部分。計數為0表示該部分應無限期地循環。

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`：結束SD列印中的一個循環部分。

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`：完成現有的循環，不再繼續迭代。

### [servo]

當啟用[servo config section](Config_Reference.md#servo) 時，以下命令可用。

#### SET_SERVO

`SET_SERVO SERVO=配置名 [ANGLE=<角度> | WIDTH=<秒>]`：將舵機位置設定為給定的角度（度）或脈衝寬度（秒）。使用 `WIDTH=0` 來禁用舵機輸出。

### [skew_correction]

當啟用 [skew_correction config section](Config_Reference.md#skew_correction) 時，以下命令可用（另請參閱 [Skew Correction](Skew_Correction.md) 指南）。

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`：用從校準列印中測量的數據（以毫米為單位）配置 [skew_correction] 模組。可以輸入任何組合的平面，沒有新輸入的平面將保持它們原有的數值。如果傳入 `CLEAR=1`，則全部偏斜校正將被禁用。

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`:以弧度和度數報告每個平面的當前印表機偏移。斜度是根據通過`SET_SKEW`程式碼提供的參數計算的。

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac 長度>] [BD=<bd 長度>] [AD=<ad 長度>]`：計算並報告基於一個列印件測量的偏斜度（以弧度和角度為單位）。它可以用來驗證應用校正後印表機的當前偏斜度。它也可以用來確定是否有必要進行偏斜矯正。有關偏斜矯正列印模型和測量方法詳見[偏斜校正文件](Skew_Correction.md)。

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<名稱>] [SAVE=<名稱>] [REMOVE=<名稱>]`：skew_correction 配置管理命令。 LOAD 將從與提供的名稱匹配的配置中載入偏斜狀態。 SAVE 會將目前偏斜狀態儲存到與提供的名稱匹配的配置中。 REMOVE 將從持久記憶體中刪除與提供的名稱匹配的配置。請注意，在執行 SAVE 或 REMOVE 操作后，必須執行 SAVE_CONFIG G程式碼才能儲存更改。

### [smart_effector]

Several commands are available when a [smart_effector config section](Config_Reference.md#smart_effector) is enabled. Be sure to check the official documentation for the Smart Effector on the [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer) before changing the Smart Effector parameters. Also check the [probe calibration guide](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<sensitivity>] [ACCEL=<accel>] [RECOVERY_TIME=<time>]`: Set the Smart Effector parameters. When `SENSITIVITY` is specified, the respective value is written to the SmartEffector EEPROM (requires `control_pin` to be provided). Acceptable `<sensitivity>` values are 0..255, the default is 50. Lower values require less nozzle contact force to trigger (but there is a higher risk of false triggering due to vibrations during probing), and higher values reduce false triggering (but require larger contact force to trigger). Since the sensitivity is written to EEPROM, it is preserved after the shutdown, and so it does not need to be configured on every printer startup. `ACCEL` and `RECOVERY_TIME` allow to override the corresponding parameters at run-time, see the [config section](Config_Reference.md#smart_effector) of Smart Effector for more info on those parameters.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`: Resets Smart Effector sensitivity to its factory settings. Requires `control_pin` to be provided in the config section.

### [stepper_enable]

模組stepper_enable已自動載入.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<配置名> ENABLE=[0|1]` 。啟用或禁用指定的步進電機。這是一個診斷和除錯工具，必須謹慎使用。因為禁用一個軸電機不會重置歸位資訊，手動移動一個被禁用的步進可能會導致機器在安全限值外操作電機。這可能導致軸結構、熱端和列印件的損壞。

### [temperature_fan]

當啟用 [temperature_fan config section](Config_Reference.md#temperature_fan) 時，以下命令可用。

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_名稱> [target=<目標溫度>] [min_speed=<最小速度>] [max_speed=<最大速度>]`：設定一個溫度控制風扇的目標溫度。如果沒有提供目標溫度，它將被設為配置檔案中定義的溫度。如果沒有提供速度，則不會進行任何更改。

### [tmcXXXX]

當啟用任何 [tmcXXXX config sections](Config_Reference.md#tmc-stepper-driver-configuration) 時，以下命令可用。

#### DUMP_TMC

`DUMP_TMC STEPPER=<name> [REGISTER=<name>]`: This command will read all TMC driver registers and report their values. If a REGISTER is provided, only the specified register will be dumped.

#### INIT_TMC

`INIT_TMC STEPPER=<名稱>`：此命令將初始化 TMC 暫存器。如果晶片的電源關閉然後重新打開，則需要重新啟用該驅動。

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: This will adjust the run and hold currents of the TMC driver. `HOLDCURRENT` is not applicable to tmc2660 drivers. When used on a driver which has the `globalscaler` field (tmc5160 and tmc2240), if StealthChop2 is used, the stepper must be held at standstill for >130ms so that the driver executes the AT#1 calibration.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value> VELOCITY=<value>`: This will alter the value of the specified register field of the TMC driver. This command is intended for low-level diagnostics and debugging only because changing the fields during run-time can lead to undesired and potentially dangerous behavior of your printer. Permanent changes should be made using the printer configuration file instead. No sanity checks are performed for the given values. A VELOCITY can also be specified instead of a VALUE. This velocity is converted to the 20bit TSTEP based value representation. Only use the VELOCITY argument for fields that represent velocities.

### [toolhead]

模組toolhead已自動載入.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<值>] [ACCEL=<值>] [ACCEL_TO_DECEL=<值>] [SQUARE_CORNER_VELOCITY=<值>]`：修改印表機速度限制。

### [tuning_tower]

模組 tuning_tower已自動載入.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<命令> PARAMETER=<名稱> START=<值> [SKIP=<值>] [FACTOR=<值> [BAND=<值>]] | [STEP_DELTA=<值> STEP_HEIGHT=<值>]`：根據Z高度調整參數的工具。該工具將定期執行一個 `PARAMETER` 不斷根據 `Z` 的公式變化的 `COMMAND`（命令）。如果使用一把尺子或者遊標卡尺測量 Z來獲得最佳值，你可以用`FACTOR`。如果列印件帶有帶狀標識或者使用離散數值（例如溫度塔），可以用`STEP_DELTA`和 `STEP_HEIGHT` 。如果 `SKIP=<值>` 被定義，則調整隻會在到達 Z 高度 `<值>` 后才開始。在此之前，參數會被設定為 `START`；在這種情況下，下面公式中`z_height`用`max(z - skip, 0)`替代。這些選項有三種不同的組合：

- `FACTOR`：數值以`factor`每毫米的速度變化。使用的公式是：`value = start + factor * z_height`。你可以將最佳的 Z 高度直接插入該公式，以確定最佳的參數值。
- `FACTOR` 和 `BAND`：該值以`factor`每毫米的平均速度變化，但在離散的環上，每`BAND`毫米的Z高度才會進行調整。使用的公式是：`value = start + factor * ((floor(z_height / band) + .5) * band)`。
- `STEP_DELTA` 和 `STEP_HEIGHT`：值每 `STEP_HEIGHT` 毫米變化 `STEP_DELTA`。使用的公式是：`value = start + step_delta * floor(z_height / step_height)`。您可以簡單地計算頻段或閱讀調諧塔標籤以確定最佳值。

### [virtual_sdcard]

如果啟用了 [virtual_sdcard 配置分段](Config_Reference.md#virtual_sdcard)，Klipper 支援以下標準 G-Code 命令：

- 列出SD卡：`M20`
- 初始化SD卡：`M21`
- 選擇SD卡檔案：`M23 <filename>`
- 開始/暫停 SD 卡列印：`M24`
- 暫停 SD 卡列印： `M25`
- 設定 SD 塊位置：`M26 S<偏移>`
- 報告SD卡列印狀態：`M27`

此外，當啟用"virtual_sdcard"配置分段時，以下擴充套件命令可用。

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<檔名>`：載入一個檔案並開始 SD 列印.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`：解除安裝檔案並清除SD狀態。

### [axis_twist_compensation]

The following commands are available when the [axis_twist_compensation config
section](Config_Reference.md#axis_twist_compensation) is enabled.

#### AXIS_TWIST_COMPENSATION_CALIBRATE

`AXIS_TWIST_COMPENSATION_CALIBRATE [SAMPLE_COUNT=<value>]`: Initiates the X twist calibration wizard. `SAMPLE_COUNT` specifies the number of points along the X axis to calibrate at and defaults to 3.

### [z_thermal_adjust]

The following commands are available when the [z_thermal_adjust config section](Config_Reference.md#z_thermal_adjust) is enabled.

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<value>] [REF_TEMP=<value>]`: Enable or disable the Z thermal adjustment with `ENABLE`. Disabling does not remove any adjustment already applied, but will freeze the current adjustment value - this prevents potentially unsafe downward Z movement. Re-enabling can potentially cause upward tool movement as the adjustment is updated and applied. `TEMP_COEFF` allows run-time tuning of the adjustment temperature coefficient (i.e. the `TEMP_COEFF` config parameter). `TEMP_COEFF` values are not saved to the config. `REF_TEMP` manually overrides the reference temperature typically set during homing (for use in e.g. non-standard homing routines) - will be reset automatically upon homing.

### [z_tilt]

當啟用 [z_tilt config section](Config_Reference.md#z_tilt) 時，以下命令可用。

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.
