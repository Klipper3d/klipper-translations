# 命令模板

本文件描述了 gcode_macro（和其他類似）配置分段中實現 G-Code 命令序列的方法。

## G-Code巨集命名

G-Code 巨集的名稱大小寫並不重要。比如，MY_MACRO 和 my_macro 是等效的，可以用大寫或小寫來呼叫。如果在宏的名稱中使用任何數字，那麼它們必須都在名稱的末尾（例如，TEST_MACRO25是合法的，但MACRO25_TEST3是不合法的）。

## 配置中 G 程式碼的格式

在配置檔案中定義一個宏時需要注意縮排。在定義多行的G-Code序列時每行都要有適當的縮排。例如：

```
[gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

請注意，`gcode:` 配置選項總是從行首開始，而 G-Code 巨集中的後續行從不從行首開始。

## 新增巨集描述

可以通過新增 `description:` 和簡短的描述來幫助理解該功能。如果沒有指定，預設為"G-Code macro"。例如：

```
[gcode_macro blink_led]
description: Blink my_led one time
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

The terminal will display the description when you use the `HELP` command or the autocomplete function.

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

`G91` 命令將 G-Code解析狀態置於“相對移動模式”，而 `RESTORE_GCODE_STATE` 命令將狀態恢復到進入宏之前的狀態。確保在第一個“G1”命令上指定一個明確的速度（通過“F”參數）。

## 模板擴充套件

The gcode_macro `gcode:` config section is evaluated using the Jinja2 template language. One can evaluate expressions at run-time by wrapping them in `{ }` characters or use conditional statements wrapped in `{% %}`. See the [Jinja2 documentation](http://jinja.pocoo.org/docs/2.10/templates/) for further information on the syntax.

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

### 巨集參數

It is often useful to inspect parameters passed to the macro when it is called. These parameters are available via the `params` pseudo-variable. For example, if the macro:

```
[gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
```

were invoked as `SET_PERCENT VALUE=.2` it would evaluate to `M117 Now at 20%`. Note that parameter names are always in upper-case when evaluated in the macro and are always passed as strings. If performing math then they must be explicitly converted to integers or floats.

It's common to use the Jinja2 `set` directive to use a default parameter and assign the result to a local name. For example:

```
[gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp}
```

### "rawparams"變數

運行巨集的完整未解析參數可以通過 `rawparams` 偽變數訪問。

如果您想更改某些命令（如“M117”）的行為，這非常有用。例如：

```
[gcode_macro M117]
rename_existing: M117.1
gcode:
  M117.1 { rawparams }
  M118 { rawparams }
```

### "printer"變數

It is possible to inspect (and alter) the current state of the printer via the `printer` pseudo-variable. For example:

```
[gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
```

Available fields are defined in the [Status Reference](Status_Reference.md) document.

Important! Macros are first evaluated in entirety and only then are the resulting commands executed. If a macro issues a command that alters the state of the printer, the results of that state change will not be visible during the evaluation of the macro. This can also result in subtle behavior when a macro generates commands that call other macros, as the called macro is evaluated when it is invoked (which is after the entire evaluation of the calling macro).

By convention, the name immediately following `printer` is the name of a config section. So, for example, `printer.fan` refers to the fan object created by the `[fan]` config section. There are some exceptions to this rule - notably the `gcode_move` and `toolhead` objects. If the config section contains spaces in it, then one can access it via the `[ ]` accessor - for example: `printer["generic_heater my_chamber_heater"].temperature`.

Note that the Jinja2 `set` directive can assign a local name to an object in the `printer` hierarchy. This can make macros more readable and reduce typing. For example:

```
[gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
```

## 可用操作

There are some commands available that can alter the state of the printer. For example, `{ action_emergency_stop() }` would cause the printer to go into a shutdown state. Note that these actions are taken at the time that the macro is evaluated, which may be a significant amount of time before the generated g-code commands are executed.

可用的「操作」命令：

- `action_respond_info(msg)`: Write the given `msg` to the /tmp/printer pseudo-terminal. Each line of `msg` will be sent with a "// " prefix.
- `action_raise_error(msg)`: Abort the current macro (and any calling macros) and write the given `msg` to the /tmp/printer pseudo-terminal. The first line of `msg` will be sent with a "!! " prefix and subsequent lines will have a "// " prefix.
- `action_emergency_stop(msg)`: Transition the printer to a shutdown state. The `msg` parameter is optional, it may be useful to describe the reason for the shutdown.
- `action_call_remote_method(method_name)`: Calls a method registered by a remote client. If the method takes parameters they should be provided via keyword arguments, ie: `action_call_remote_method("print_stuff", my_arg="hello_world")`

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

使用 SET_GCODE_VARIABLE 時，請務必考慮宏評估和命令執行的時間。

## 延遲 G-Code

The [delayed_gcode] configuration option can be used to execute a delayed gcode sequence:

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

When the `load_filament` macro above executes, it will display a "Load Complete!" message after the extrusion is finished. The last line of gcode enables the "clear_display" delayed_gcode, set to execute in 10 seconds.

The `initial_duration` config option can be set to execute the delayed_gcode on printer startup. The countdown begins when the printer enters the "ready" state. For example, the below delayed_gcode will execute 5 seconds after the printer is ready, initializing the display with a "Welcome!" message:

```
[delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
```

Its possible for a delayed gcode to repeat by updating itself in the gcode option:

```
[delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
```

The above delayed_gcode will send "// Extruder Temp: [ex0_temp]" to Octoprint every 2 seconds. This can be canceled with the following gcode:

```
UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
```

## 功能表範本

If a [display config section](Config_Reference.md#display) is enabled, then it is possible to customize the menu with [menu](Config_Reference.md#menu) config sections.

菜單模板中提供以下只讀屬性：

* `menu.width` - element width (number of display columns)
* `menu.ns` - element namespace
* "menu.event" - 觸發腳本的事件的名稱
* `menu.input` - input value, only available in input script context

選單範本中提供了以下操作：

* `menu.back(force, update)`: will execute menu back command, optional boolean parameters `<force>` and `<update>`.
   * When `<force>` is set True then it will also stop editing. Default value is False.
   * When `<update>` is set False then parent container items are not updated. Default value is True.
* `menu.exit(force)` - will execute menu exit command, optional boolean parameter `<force>` default value False.
   * When `<force>` is set True then it will also stop editing. Default value is False.

## 將變數保存到磁碟

If a [save_variables config section](Config_Reference.md#save_variables) has been enabled, `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>` can be used to save the variable to disk so that it can be used across restarts. All stored variables are loaded into the `printer.save_variables.variables` dict at startup and can be used in gcode macros. to avoid overly long lines you can add the following at the top of the macro:

```
{% set svv = printer.save_variables.variables %}
```

例如，它可用於保存 二入一出 熱頭 的狀態，並在開始打印時確保使用有效的擠出機，而不是 T0：

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
