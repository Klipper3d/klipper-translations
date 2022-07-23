# 命令模板

本文件描述了 gcode_macro（和其他類似）配置分段中實現 G-Code 命令序列的方法。

## G 程式碼宏命名

G-Code 宏的名稱大小寫並不重要。比如，MY_MACRO 和 my_macro 是等效的，可以用大寫或小寫來呼叫。如果在宏的名稱中使用任何數字，那麼它們必須都在名稱的末尾（例如，TEST_MACRO25是合法的，但MACRO25_TEST3是不合法的）。

## 配置中 G-Code的格式

在配置檔案中定義一個宏時需要注意縮排。在定義多行的G程式碼序列時每行都要有適當的縮排。例如：

```
[gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

請注意，`gcode:` 配置選項總是從行首開始，而 G-Code 宏中的後續行從不從行首開始。

## 向宏新增描述

可以通過新增 `description:` 和簡短的描述來幫助理解該功能。如果沒有指定，預設為"G-Code macro"。例如：

```
[gcode_macro blink_led]
description: Blink my_led one time
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

當您使用“HELP”命令或自動完成功能時，終端將顯示描述。

## 儲存/恢復 G-Code 移動的狀態

不幸的是，G-Code 命令語言在使用上有些難度。移動工具頭的標準機制是通過 `G1` 命令（`G0` 命令是 `G1` 的別名，它們互換使用）。然而，這個命令依賴於由`M82`、`M83`、`G90`、`G91`、`G92`, 以及先前的`G1`命令所設定的"G-Code解析狀態"。在建立 G-Code 宏時，最好在發出`G1`命令之前，先明確 G-Code 解析狀態。(否則，`G1` 命令就有可能提出一個不符合預期的請求。）

實現這一目標的常見方法是將 `G1` 移動包裝在 `SAVE_GCODE_STATE`、`G91`和`RESTORE_GCODE_STATE`中。例如：

```
[gcode_macro MOVE_UP]
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state
  G91
  G1 Z10 F300
  RESTORE_GCODE_STATE NAME=my_move_up_state
```

`G91` 命令將 G-Code解析狀態置於“相對移動模式”，而 `RESTORE_GCODE_STATE` 命令將狀態恢復到進入巨集之前的狀態。確保在第一個“G1”命令上指定一個明確的速度（通過“F”參數）。

## 模板擴充套件

gcode_macro `gcode:` 配置部分使用 Jinja2 模板語言進行評估。可以通過將表達式包裝在“{}”字符中或使用條件語句包裝在“{% %}”中來在運行時評估表達式。有關語法的更多信息，請參閱 [Jinja2 文檔](http://jinja.pocoo.org/docs/2.10/templates/).

一個更復雜的宏示例：

```
[gcode_macro clean_nozzle]
gcode:
  {% set wipe_count = 8 %}
  SAVE_GCODE_STATE NAME=clean_nozzle_state
  G90
  G0 Z15 F300
  {% for wipe in range(wipe_count) %}
    {% for coordinate in [(275, 4),(235, 4)] %}
      G0 X{coordinate[0]} Y{coordinate[1] + 0.25 * wipe} Z9.7 F12000
    {% endfor %}
  {% endfor %}
  RESTORE_GCODE_STATE NAME=clean_nozzle_state
```

### 宏觀參數

在調用巨集時檢查傳遞給巨集的參數通常很有用。這些參數可通過 `params` 偽變數獲得。例如，如果巨集：

```
[gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
```

被調用為“SET_PERCENT VALUE=.2”，它將評估為“M117 Now at 20%”。請注意，在宏中求值時，參數名稱始終為大寫，並且始終作為字符串傳遞。如果執行數學運算，則必須將它們顯式轉換為整數或浮點數。

通常使用 Jinja2 `set` 指令來使用默認參數並將結果分配給本地名稱。例如：

```
[gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp}
```

### "rawparams" 變數

運行巨集的完整未解析參數可以通過 `rawparams` 偽變數訪問。

Note that this will include any comments that were part of the original command.

See the [sample-macros.cfg](../config/sample-macros.cfg) file for an example showing how to override the `M117` command using `rawparams`.

### "printer"變數

可以通過 `printer` 偽變數檢查（和更改）打印機的當前狀態。例如：

```
[gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
```

[Status Reference](Status_Reference.md) 文檔中定義了可用字段。

重要！首先對巨集進行整體評估，然後才執行結果命令。如果宏發出更改打印機狀態的命令，則在評估宏期間將看不到該狀態更改的結果。當巨集生成調用其他巨集的命令時，這也可能導致微妙的行為，因為被調用的巨集在調用時進行評估（這是在調用巨集的整個評估之後）。

按照慣例，緊跟在 `printer` 後面的名稱是配置部分的名稱。因此，例如，`printer.fan` 指的是由 `[fan]` 配置部分創建的風扇對象。這條規則有一些例外——特別是 `gcode_move` 和 `toolhead` 對象。如果配置部分包含空格，則可以通過 `[ ]` 訪問器訪問它 - 例如：`printer["generic_heater my_chamber_heater"].temperature`。

請注意，Jinja2 `set` 指令可以為 `printer` 層次結構中的對象分配本地名稱。這可以使宏更具可讀性並減少鍵入。例如：

```
[gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
```

## 可用操作

有一些可用的命令可以改變打印機的狀態。例如，`{ action_emergency_stop() }` 會導致打印機進入關機狀態。請注意，這些操作是在評估宏時執行的，這可能是執行生成的 G-Code命令之前的大量時間。

可用的「操作」命令：

- `action_respond_info(msg)`：將給定的`msg`寫入/tmp/printer偽終端。 `msg` 的每一行都會以“//”前綴發送。
- `action_raise_error(msg)`：中止當前巨集（和任何調用巨集）並將給定的`msg`寫入/tmp/printer偽終端。 `msg` 的第一行將使用“!!”前綴發送，後續行將使用“//”前綴。
- `action_emergency_stop(msg)`：將打印機轉換為關機狀態。 `msg` 參數是可選的，它可能有助於描述關閉的原因。
- `action_call_remote_method(method_name)`：調用遠程客戶端註冊的方法。如果方法採用參數，則應通過關鍵字參數提供，即：`action_call_remote_method("print_stuff", my_arg="hello_world")`

## 變數

SET_GCODE_VARIABLE 命令可能有助於在巨集調用之間保存狀態。變量名不能包含任何大寫字符。例如：

```
[gcode_macro start_probe]
variable_bed_temp: 0
gcode:
  # Save target temperature to bed_temp variable
  SET_GCODE_VARIABLE MACRO=start_probe VARIABLE=bed_temp VALUE={printer.heater_bed.target}
  # Disable bed heater
  M140
  # Perform probe
  PROBE
  # Call finish_probe macro at completion of probe
  finish_probe

[gcode_macro finish_probe]
gcode:
  # Restore temperature
  M140 S{printer["gcode_macro start_probe"].bed_temp}
```

使用 SET_GCODE_VARIABLE 時，請務必考慮巨集評估和命令執行的時間。

## 延遲 G-Code

[delayed_gcode] 配置選項可用於執行延遲的 G-Code 序列：

```
[delayed_gcode clear_display]
gcode:
  M117

[gcode_macro load_filament]
gcode:
 G91
 G1 E50
 G90
 M400
 M117 Load Complete!
 UPDATE_DELAYED_GCODE ID=clear_display DURATION=10
```

當上面的`load_filament`宏執行時，它會顯示“加載完成！”擠壓完成後的消息。 G-Code 的最後一行啟用了“clear_display”delayed_gcode，設置為在 10 秒內執行。

`initial_duration` 配置選項可以設置為在打印機啟動時執行delayed_gcode。當打印機進入“就緒”狀態時開始倒計時。例如，下面的delayed_gcode將在打印機準備好5秒後執行，用“歡迎！”初始化顯示信息：

```
[delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
```

通過在 G-Code 選項中自我更新，延遲的 G-Code 可能會重複：

```
[delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
```

上面的delayed_gcode 將每2 秒向Octoprint 發送“// Extruder Temp: [ex0_temp]”。這可以使用以下 G-Code 取消：

```
UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
```

## 功能表範本

如果啟用了 [display config section](Config_Reference.md#display)，則可以使用 [menu](Config_Reference.md#menu) 配置部分自定義菜單。

菜單模板中提供以下只讀屬性：

* `menu.width` - 元素寬度（顯示列數）
* `menu.ns` - 元素命名空間
* "menu.event" - 觸發腳本的事件的名稱
* `menu.input` - 輸入數值，僅在輸入腳本上下文中可用

選單範本中提供了以下操作：

* `menu.back(force, update)`：將執行菜單返回命令，可選"是/否"參數`<force>`和`<update>`。
   * 當 `<force>` 設置為"是"時，它也會停止編輯。默認值為"否"。
   * 當 `<update>` 設置為 "否" 時，不會更新父容器項。默認值為"是"。
* `menu.exit(force)` - 將執行菜單退出命令，可選"是/否"參數 `<force>` 默認值為 "否"。
   * 當 `<force>` 設置為"是"時，它也會停止編輯。默認值為"否"。

## 將變數保存到磁碟

如果啟用了 [save_variables config section](Config_Reference.md#save_variables)，則可以使用 `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>` 將變數保存到磁盤，以便在重新啟動時使用它。所有存儲的變數都會在啟動時加載到`printer.save_variables.variables` dict 中，並且可以在G-Code 巨集中使用。為避免行過長，您可以在巨集頂部添加以下內容：

```
{% set svv = printer.save_variables.variables %}
```

例如，它可用於保存 二入一出熱頭的狀態，並在開始打印時確保使用活動的擠出機，而不是 T0：

```
[gcode_macro T1]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder1
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder1"'

[gcode_macro T0]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder"'

[gcode_macro START_GCODE]
gcode:
  {% set svv = printer.save_variables.variables %}
  ACTIVATE_EXTRUDER extruder={svv.currentextruder}
```
