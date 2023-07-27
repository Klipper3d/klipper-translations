# 切片软件

本文档提供了与 Klipper 一起使用的一些切片软件配置技巧。 Klipper 常用的切片软件有 Slic3r、Cura、Simplify3D 等。

## 将 G-Code 风格设置为 Marlin

很多切片软件可以设置“G代码风格”选项。Klipper支持通常默认的“Marlin”；Klipper 也兼容“Smoothieware”风格。

## Klipper gcode_macro

切片软件通常可以配置一个"开始G代码 "(Start G-Code)和 "结束G代码 "(End G-Code)序列。但在 Klipper 配置文件中定义自定义宏通常更简便，例如：`[gcode_macro START_PRINT]` 和 `[gcode_macro END_PRINT]` 。然后就可以在切片软件的配置中使用 START_PRINT 和 END_PRINT 。在 Klipper 的配置中定义这些动作可能会简化打印机的开始和结束步骤的配置，因为修改不需要重新切片。

参见[sample-macros.cfg](../config/sample-macros.cfg)中的示例 START_PRINT 和END_PRINT 宏。

参见[配置参考](Config_Reference.md#gcode_macro)中关于定义 gcode_macro 的细节。

## 大的回抽值可能意味着需要调优 Klipper

在Klipper中，回抽的最大速度和加速度由 `max_extrude_only_velocity` 和 `max_extrude_only_accel` 参数控制。在大多数打印机上这些参数的默认值应该能很好地工作。然而，如果切片软件中配置了一个大的回抽值(例如，5毫米或更大)，可能会发现期望的回抽速度受到了限制。

如果你正在使用一个大的回抽值，考虑调优 Klipper 的[提前压力](Pressure_Advance.md)来代替。否则你可能会发现打印头在回抽和启动时暂停，此时可以考虑在 Klipper 配置文件中设置`max_extrude_only_velocity`和`max_extrude_only_accel`参数来解决这个问题。

## 不要启用“滑行(coasting)”

和Klipper 一起使用“滑行(coasting)”功能可能会导致打印质量不佳。考虑使用 Klipper 的[提前压力](Pressure_Advance.md)功能替代。

具体来说，如果切片软件在移动之间大幅改变挤出率，那么 Klipper 将在移动之间进行减速和加速。这更可能会造成更多的挤出颗粒(blobbing)，而不是更少。

相反，使用切片软件的"回抽"、"擦拭 "和/或 "缩回时擦拭 "设置通常是有益的。

## 不要在 Simplify3d 上使用“额外重启距离(extra restart distance)”

这个设置会导致挤出速度的剧烈变化，从而触发 Klipper 的最大挤出截面检查。考虑使用 Klipper 的[提前](Pressure_Advance.md)或 Simplify3d 的常规回抽设置来代替。

## 在 KISSlicer 上禁用“PreloadVE”

如果使用 KISSlicer 切片软件，那么需要把 "PreloadVE "设为0并考虑使用Klipper的[提前压力](Pressure_Advance.md)代替。

## 禁用任何"提前挤出压力"的设置

一些切片软件宣传有 "高级挤出机压力调整 "的功能。建议在使用 Klipper 时禁用这些功能，因为它们很可能会降低打印质量。考虑使用 Klipper 的[压力提前](Pressure_Advance.md)代替。

具体来说，这些切片软件的设置生成的命令会固件对挤出率进行剧烈的改变，希望固件能接近这些请求值，使打印机获得一个大致理想的挤出机压力。然而，Klipper利用精确的运动学计算和计时。当Klipper被命令对挤出率进行重大改变时，它将计划出速度、加速度和挤出机运动的相应变化--这不是切片软件的意图。切片软件甚至可能产生过大的挤出速度，以至于触发Klipper的最大挤出截面检查。

相反，使用切片软件的"回抽"、"擦拭 "和/或 "缩回时擦拭 "设置通常是有益的。

## START_PRINT宏

当使用START_PRINT宏或类似的宏时，也可以将切片变量的参数传递给宏。

在 Cura 中，要传递温度参数，使用以下开始G代码：

```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

在PrusaSlicer和SuperSlicer等sli3er衍生版本中，使用以下G代码：

```
START_PRINT EXTRUDER_TEMP=[first_layer_temperature] BED_TEMP=[first_layer_bed_temperature]
```

还要注意，当某些条件不满足时，这些切片软件会插入自己的加热代码。在Cura中，存在`{material_bed_temperature_layer_0}`和`{material_print_temperature_layer_0}`这两个变量就足够了。在slic3r衍生品中，你需要使用：

```
M140 S0
M104 S0
```

在宏调用之前。还要注意的是，SuperSlicer有一个 "仅包含定制G代码"的按钮选项，可以达到同样的效果。

在config/sample-macros.cfg中可以找到一个使用这些参数的START_PRINT宏的例子
