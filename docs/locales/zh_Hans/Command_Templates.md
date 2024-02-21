# 命令模板

本文档描述了 gcode_macro（和其他类似）配置分段中实现 G-Code 命令序列的方法。

## G 代码宏命名

G-Code 宏的名称大小写并不重要。比如，MY_MACRO 和 my_macro 是等效的，可以用大写或小写来调用。如果在宏的名称中使用任何数字，那么它们必须都在名称的末尾（例如，TEST_MACRO25是合法的，但MACRO25_TEST3是不合法的）。

## 配置中 G 代码的格式

在配置文件中定义一个宏时需要注意缩进。在定义多行的G代码序列时每行都要有适当的缩进。例如：

```
[gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1 #亮灯
  G4 P2000 # 等待2000毫秒
  SET_PIN PIN=my_led VALUE=0 #关灯
```

请注意，`gcode:` 配置选项总是从行首开始，而 G-Code 宏中的后续行从不从行首开始。

## 向宏添加描述

可以通过添加 `description:` 和简短的描述来帮助理解该功能。如果没有指定，默认为"G-Code macro"。例如：

```
[gcode_macro blink_led] #闪灯
description: Blink my_led one time # 简介：闪一下my_led
gcode:
  SET_PIN PIN=my_led VALUE=1 #亮灯
  G4 P2000 # 等待2000毫秒
  SET_PIN PIN=my_led VALUE=0 #关灯
```

当您使用`HELP`命令或自动补全功能时，终端会显示说明。

## 保存/恢复 G-Code 移动的状态

不幸的是，G-Code 命令语言在使用上有些难度。移动工具头的标准机制是通过 `G1` 命令（`G0` 命令是 `G1` 的别名，它们互换使用）。然而，这个命令依赖于由`M82`、`M83`、`G90`、`G91`、`G92`, 以及先前的`G1`命令所设置的"G-Code解析状态"。在创建 G-Code 宏时，最好在发出`G1`命令之前，先明确 G-Code 解析状态。(否则，`G1` 命令就有可能提出一个不符合预期的请求。）

实现这一目标的常见方法是将 `G1` 移动包装在 `SAVE_GCODE_STATE`、`G91`和`RESTORE_GCODE_STATE`中。例如：

```
[gcode_macro MOVE_UP] # 向上移动
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state # 保存名称为my_move_up_state的G代码状态
  G91 # 相对模式
  G1 Z10 F300 # 慢慢往上移动 10mm，5mm/s
  RESTORE_GCODE_STATE NAME=my_move_up_state # 恢复名称为my_move_up_state的G代码状态
```

`G91` 命令将G代码解析状态放入 "相对移动模式"，`RESTORE_GCODE_STATE` 命令将状态恢复到进入宏之前的状态。请确保在第一条`G1` 命令中指定一个明确的速度（通过`F` 参数）。

## 模板扩展

gcode_macro`gcode:` 配置部分是使用的是Jinja2模板语言。人们可以通过用`{ }` 字符包装来在运行时使用表达式，或者使用用`{% %}` 包装的条件语句。参考[Jinja2文档](http://jinja.pocoo.org/docs/2.10/templates/)以了解更多关于语法的信息。

一个更复杂的宏示例：

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

### 宏观参数

当macro被调用时，检查传递给它的参数往往是有用的。这些参数可以通过`params` 伪变量（pseudo-variable）获得。类似于以下macro：

```
[gcode_macro SET_PERCENT] # 设置百分比
gcode:
  M117 Now at { params.VALUE|float * 100 }% # 现在在VALUE* 100的百分比
```

如果以`SET_PERCENT VALUE=.2` 的方式调用，则会评估为`M117 现在为 20%` 。需要注意的是在宏（macro）中进行评估时，参数名称始终使用大写字母，并且始终以字符串（strings）形式传递。如果执行数学运算，则必须明确地将其转换为整数（integers）或浮点数（floats）。

通常使用Jinja2的`set` 指令来使用一个默认参数，并将结果分配给一个本地名称。比如说：

```
[gcode_macro SET_BED_TEMPERATURE] # 设置热床温度
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %} # 热床温度=params.TEMPERATURE或者默认40
  M140 S{bed_temp} # 设置热床温度为bed_temp
```

### “rawparams”变量

可以通过`rawpars`伪变量访问正在运行的宏的完整未解析参数。

请注意，这将包括原始命令中的任何注释。

有关如何使用`rawpars`覆盖`M117`命令的示例，请参阅[sample-macros.cfg](../config/sample-macros.cfg)文件。

### "printer"变量

可以通过`printer` 的pseudo-variable来检查（和变更）打印机的当前状态。比如说：

```
[gcode_macro slow_fan] # 降低风速
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
```

[Status Reference](Status_Reference.md) 文档中定义了可用字段。

注意！宏会先被进行整体计算，然后所产生的命令才会被执行。如果一个宏发出的命令改变了打印机的状态，那么在评估宏的过程中，该状态改变的结果将在执行时不可见。当一个宏产生调用其他宏的命令时，这也可能导致微妙的行为，因为被调用的宏在被调用时才被评估（这是在调用宏的整体计算过程之后）。

按照惯例，紧跟在`printer` 后面的名称是一个配置分段的名称。因此，例如，`printer.fan` 指的是由`[fan]` 配置分段创建的风扇对象。这条规则有一些例外 - 特别是`gcode_move` 和`toolhead` 对象。如果配置分段包含空格，那么可以通过`[ ]` 访问器访问它--例如：`printer["generic_heater my_chamber_heater"].temperature` 。

请注意，Jinja2的`set` 指令可以为`printer` 层次结构中的一个对象指定一个本地名称。这可以改善宏的可读性并减少键入量。例如：

```
[gcode_macro QUERY_HTU21D] # 查询HTU21D
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
```

## 行动

有一些可用的命令可以改变打印机的状态。例如，`{ action_emergency_stop() }` 将导致打印机进入关闭状态。请注意，这些动作会在宏被评估的时候执行，这可能是在生成的G代码命令被执行之前的一段相当长的时间。

可用的“动作”命令：

- `action_respond_info(msg)`：将给定的 `msg` 写入 /tmp/printer 伪终端。 `msg` 的每一行都会以“//”前缀发送。
- `action_raise_error(消息)`：终止当前宏（以及任何调用的宏），并将给定的`消息` 写到 /tmp/printer 伪终端。`msg` 的第一行将以"！！"为前缀发送，随后几行将以"//"为前缀。
- `action_emergency_stop(消息)`：将打印机过渡到关机状态。`消息` 参数是可选的，可以用来描述关机的原因。
- `action_call_remote_method(方法名)`：调用一个由远程客户端注册的方法。如果该方法需要参数，应通过关键字参数提供，即：`action_call_remote_method("print_stuff", 参数="hello_world")`

## 变量

SET_GCODE_VARIABLE 命令可以在宏调用之间保存状态。变量名不能包含任何大写字符。例如：

```
[gcode_macro start_probe]
variable_bed_temp: 0
gcode:
  # 保存参数到bed_temp变量
  SET_GCODE_VARIABLE MACRO=start_probe VARIABLE=bed_temp VALUE={printer.heater_bed.target}
  # 禁用热床
  M140
  # 进行探测
  PROBE
  # 在结束时调用finish_probe脚本
  finish_probe

[gcode_macro finish_probe]
gcode:
  # 恢复热床温度
  M140 S{printer["gcode_macro start_probe"].bed_temp}
```

在使用SET_GCODE_VARIABLE时，一定要考虑到宏评估和命令执行的时间顺序。

## 延迟G代码

[delayed_gcode]配置分段可以用来执行一个延迟的G代码序列：

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

当上面的`load_filament` 宏执行时，它将在挤出结束后显示一个 "Load Complete!"的信息。最后一行G代码启用 "clear_display "delayed_gcode，设置为10秒后执行。

`initial_duration` 配置选项可以被设置为在打印机启动时执行 delayed_gcode。倒计时从打印机进入"ready"（准备）状态时开始。例如，下面的 delayed_gcode 将在打印机准备好后5秒执行，以 "Welcome！"的信息初始化显示屏：

```
[delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
```

延迟G代码可以通过在G代码选项中更新自己来重复自生：

```
[delayed_gcode report_temp]
初始_持续时间： 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
```

上述delayed_gcode将每2秒向Octoprint发送 "// Extruder Temp: [ex0_temp]"。这可以用下面的gcode取消：

```
UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
```

## 菜单模板

如果启用了[display配置分段](Config_Reference.md#display)，那么就可以用[menu](Config_Reference.md#menu)配置分段自定义菜单。

以下只读属性在菜单模板中可用：

* `menu.width` - 元素宽度（显示列数）
* `menu.ns` - 元素命名空间
* `menu.event` - 触发脚本的事件名称
* `menu.input` - 输入值，仅在输入脚本上下文中可用

以下操作在菜单模板中可用：

* `menu.back(force, update)`：将执行菜单返回命令，可选的布尔参数有`<force>`（强制）和`<update>`（更新）。
   * 当 `<force>` 设置为 True 时，它也将停止编辑。默认值为 False。
   * 当`<update>` 被设置为False，那么父级容器项目就不会被更新。默认值是True。
* `menu.exit(force)` - 将执行菜单退出命令，可选的布尔参数有`<force>`（强制）默认值 False。
   * 当 `<force>` 设置为 True 时，它也将停止编辑。默认值为 False。

## 保存变量到磁盘

如果启用了[save_variables配置分段](Config_Reference.md#save_variables)，`SAVE_VARIABLE VARIABLE=<名称> VALUE=<值>`可以用来将变量保存到磁盘，以便在重新启动时使用。所有存储的变量在启动时会被加载到`printer.save_variables.variables` dict 变量中，可以在G代码宏中使用。为避免行数过长，可以在宏的顶部添加以下内容：

```
{% set svv = printer.save_variables.variables %}
```

例如，它可以用来保存2进1出热端的状态，当开始打印时，确保使用活跃的挤出机，而不是T0：

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
