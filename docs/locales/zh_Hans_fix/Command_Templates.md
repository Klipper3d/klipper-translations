# 命令模板

本文档提供了在 `gcode_macro`（及类似）配置部分中实现 G-Code 命令序列的信息。

## G-Code 宏命名

G-Code 宏名称的大小写不重要——`MY_MACRO` 和 `my_macro` 的效果相同，调用时可以使用大写或小写。如果宏名称中使用了任何数字，则它们必须全部位于名称的末尾（例如，`TEST_MACRO25` 是有效的，但 `MACRO25_TEST3` 无效）。

## 配置文件中的 G-Code 格式

在配置文件中定义宏时，缩进非常重要。要指定多行 G-Code 序列，每行都必须有正确的缩进。例如：

```
[gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

请注意，`gcode:` 配置选项始终从行首开始，而 G-Code 宏中的后续行绝不能从行首开始。

## 为宏添加描述

为了便于识别功能，可以添加简短的描述。使用 `description:` 添加一段简短的文字来描述功能。如果未指定，默认为 "G-Code macro"。例如：

```
[gcode_macro blink_led]
description: Blink my_led one time
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

当您使用 `HELP` 命令或自动补全功能时，终端将显示该描述。

## 保存/恢复 G-Code 移动的状态

不幸的是，G-Code 命令语言可能难以使用。移动打印头的标准机制是通过 `G1` 命令（`G0` 命令是 `G1` 的别名，可与之互换使用）。然而，此命令依赖于由 `M82`、`M83`、`G90`、`G91`、`G92` 和先前的 `G1` 命令设置的“G-Code 解析状态”。创建 G-Code 宏时，最好在发出 `G1` 命令之前始终明确设置 G-Code 解析状态。（否则，`G1` 命令可能会发出不良请求的风险。）

实现此目的的常见方法是将 `G1` 移动包裹在 `SAVE_GCODE_STATE`、`G91` 和 `RESTORE_GCODE_STATE` 中。例如：

```
[gcode_macro MOVE_UP]
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state
  G91
  G1 Z10 F300
  RESTORE_GCODE_STATE NAME=my_move_up_state
```

`G91` 命令将 G-Code 解析状态置于“相对移动模式”，而 `RESTORE_GCODE_STATE` 命令将状态恢复到进入宏之前的状态。请确保在第一个 `G1` 命令中通过 `F` 参数明确指定速度。

## 模板扩展

gcode_macro 的 `gcode:` 配置部分使用 Jinja2 模板语言进行求值。可以通过将表达式包裹在 `{}` 字符中或使用包裹在 `{% %}` 中的条件语句在运行时求值。有关语法的更多信息，请参阅 [Jinja2 文档](http://jinja.pocoo.org/docs/2.10/templates/)。

一个复杂宏的示例：
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

### 宏参数

检查调用宏时传递的参数通常很有用。这些参数可通过 `params` 伪变量获得。例如，如果调用宏：

```
[gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
```

调用方式为 `SET_PERCENT VALUE=.2`，则它将求值为 `M117 Now at 20%`。请注意，参数名称在宏中求值时始终为大写，并且始终作为字符串传递。如果执行数学运算，则必须显式转换为整数或浮点数。

使用 Jinja2 的 `set` 指令来使用默认参数并将结果赋给局部名称是很常见的。例如：

```
[gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp}
```

### “rawparams” 变量

正在运行的宏的完整未解析参数可通过 `rawparams` 伪变量访问。

请注意，这将包括原始命令中的任何注释。

有关如何使用 `rawparams` 覆盖 `M117` 命令的示例，请参阅 [sample-macros.cfg](../config/sample-macros.cfg) 文件。

### “printer” 变量

可以通过 `printer` 伪变量检查（和更改）打印机的当前状态。例如：

```
[gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
```

可用字段在 [状态参考](Status_Reference.md) 文档中定义。

重要！宏首先被完全求值，然后才执行生成的命令。如果宏发出更改打印机状态的命令，则该状态更改的结果在宏求值期间不可见。当宏生成调用其他宏的命令时，这也可能导致细微的行为，因为被调用的宏在其被调用时求值（即在调用宏的整个求值之后）。

按照惯例，紧跟在 `printer` 后面的名称是配置部分的名称。例如，`printer.fan` 指的是由 `[fan]` 配置部分创建的风扇对象。此规则有一些例外——特别是 `gcode_move` 和 `toolhead` 对象。如果配置部分包含空格，则可以通过 `[ ]` 访问器访问它——例如：`printer["generic_heater my_chamber_heater"].temperature`。

请注意，Jinja2 的 `set` 指令可以为 `printer` 层次结构中的对象分配局部名称。这可以使宏更具可读性并减少打字量。例如：
```
[gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
```

## 操作

有一些可用的命令可以更改打印机的状态。例如，`{ action_emergency_stop() }` 会使打印机进入关机状态。请注意，这些操作在宏求值时执行，这可能在生成的 G-Code 命令执行之前有相当长的时间。

可用的“操作”命令：
- `action_respond_info(msg)`：将给定的 `msg` 写入 /tmp/printer 伪终端。`msg` 的每一行将以 "// " 前缀发送。
- `action_raise_error(msg)`：中止当前宏（以及任何调用宏）并将给定的 `msg` 写入 /tmp/printer 伪终端。`msg` 的第一行将以 "!! " 前缀发送，后续行将以 "// " 前缀发送。
- `action_emergency_stop(msg)`：将打印机转换到关机状态。`msg` 参数是可选的，可用于描述关机原因。
- `action_call_remote_method(method_name)`：调用由远程客户端注册的方法。如果方法需要参数，应通过关键字参数提供，例如：`action_call_remote_method("print_stuff", my_arg="hello_world")`

## 变量

`SET_GCODE_VARIABLE` 命令可能对在宏调用之间保存状态很有用。变量名称不能包含任何大写字符。例如：

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

使用 `SET_GCODE_VARIABLE` 时，请务必考虑宏求值和命令执行的时间。

## 延迟 G-Code

`[delayed_gcode]` 配置选项可用于执行延迟的 G-Code 序列：

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

当执行上述 `load_filament` 宏时，挤出完成后会显示“Load Complete!”消息。G-Code 的最后一行启用了“clear_display”延迟 G-Code，设置为 10 秒后执行。

可以设置 `initial_duration` 配置选项以在打印机启动时执行延迟 G-Code。倒计时从打印机进入“就绪”状态时开始。例如，以下延迟 G-Code 将在打印机就绪后 5 秒执行，用“Welcome!”消息初始化显示：

```
[delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
```

通过在 G-Code 选项中更新自身，可以使延迟 G-Code 重复执行：

```
[delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
```

上述延迟 G-Code 将每 2 秒向 Octoprint 发送一次 "// Extruder Temp: [ex0_temp]"。可以通过以下 G-Code 取消：

```
UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
```

## 菜单模板

如果启用了 [display 配置部分](Config_Reference.md#display)，则可以通过 [menu](Config_Reference.md#menu) 配置部分自定义菜单。

菜单模板中可用的只读属性有：
* `menu.width` - 元素宽度（显示列数）
* `menu.ns` - 元素命名空间
* `menu.event` - 触发脚本的事件名称
* `menu.input` - 输入值，仅在输入脚本上下文中可用

菜单模板中可用的操作有：
* `menu.back(force, update)`：执行菜单返回命令，可选布尔参数 `<force>` 和 `<update>`。
  * 当 `<force>` 设置为 True 时，它也会停止编辑。默认值为 False。
  * 当 `<update>` 设置为 False 时，父容器项不会更新。默认值为 True。
* `menu.exit(force)` - 执行菜单退出命令，可选布尔参数 `<force>` 默认值为 False。
  * 当 `<force>` 设置为 True 时，它也会停止编辑。默认值为 False。

## 将变量保存到磁盘

如果已启用
[save_variables 配置部分](Config_Reference.md#save_variables)，
则可以使用 `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>` 将变量保存到磁盘，以便在重启后使用。
所有存储的变量在启动时加载到 `printer.save_variables.variables` 字典中，并可在 G-Code 宏中使用。
为避免行过长，可以在宏顶部添加以下内容：
```
{% set svv = printer.save_variables.variables %}
```

例如，它可以用来保存 2 进 1 出热端的状态，并在开始打印时确保使用活动的挤出机，而不是 T0：

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