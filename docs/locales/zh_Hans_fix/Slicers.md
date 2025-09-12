# 切片软件

本文档提供了一些关于为 Klipper 配置“切片”应用程序的提示。与 Klipper 常用的切片软件有 Slic3r、Cura、Simplify3D 等。

## 将 G-Code 类型设置为 Marlin

许多切片软件都有一个选项来配置“G-Code 类型”。默认值通常是“Marlin”，这与 Klipper 配合得很好。“Smoothieware”设置也与 Klipper 兼容。

## Klipper gcode_macro

切片软件通常允许用户配置“开始 G-Code”和“结束 G-Code”序列。在 Klipper 配置文件中定义自定义宏通常更为方便，例如：`[gcode_macro START_PRINT]` 和 `[gcode_macro END_PRINT]`。然后，您只需在切片软件的配置中运行 START_PRINT 和 END_PRINT。在 Klipper 配置中定义这些操作可能更容易调整打印机的启动和结束步骤，因为更改不需要重新切片。

有关示例 START_PRINT 和 END_PRINT 宏，请参阅 [sample-macros.cfg](../config/sample-macros.cfg)。

有关定义 gcode_macro 的详细信息，请参阅 [配置参考](Config_Reference.md#gcode_macro)。

## 大回抽设置可能需要调整 Klipper

回抽移动的最大速度和加速度由 Klipper 中的 `max_extrude_only_velocity` 和 `max_extrude_only_accel` 配置设置控制。这些设置的默认值在许多打印机上都能很好地工作。但是，如果在切片软件中配置了较大的回抽（例如，5mm 或更大），则可能会发现它们限制了所需回抽速度。

如果使用大回抽，请考虑调整 Klipper 的 [压力提前](Pressure_Advance.md)。否则，如果发现打印头在回抽和出料时似乎“暂停”，则考虑在 Klipper 配置文件中显式定义 `max_extrude_only_velocity` 和 `max_extrude_only_accel`。

## 不要启用“滑行 (coasting)”

“滑行”功能可能会导致 Klipper 打印质量不佳。建议使用 Klipper 的 [压力提前](Pressure_Advance.md) 来代替。

具体来说，如果切片软件在移动之间大幅改变挤出速率，则 Klipper 将在移动之间进行减速和加速。这可能会使拉丝情况变得更糟，而不是更好。

相比之下，使用切片软件的“回抽”设置、“擦拭”设置和/或“回抽时擦拭”设置是可以的（通常是有帮助的）。

## 在 Simplify3D 中不要使用“额外重启距离”

此设置可能会导致挤出速率发生剧烈变化，从而触发 Klipper 的最大挤出截面检查。建议使用 Klipper 的 [压力提前](Pressure_Advance.md) 或 Simplify3D 的常规回抽设置来代替。

## 在 KISSlicer 中禁用“PreloadVE”

如果使用 KISSlicer 切片软件，请将“PreloadVE”设置为零。建议使用 Klipper 的 [压力提前](Pressure_Advance.md) 来代替。

## 禁用任何“高级挤出机压力”设置

一些切片软件宣传具有“高级挤出机压力”功能。建议在使用 Klipper 时保持这些选项禁用，因为它们可能会导致打印质量不佳。建议使用 Klipper 的 [压力提前](Pressure_Advance.md) 来代替。

具体来说，这些切片软件设置可以指示固件对挤出速率进行剧烈更改，希望固件能近似满足这些请求，并且打印机能大致获得理想的挤出机压力。然而，Klipper 使用精确的运动学计算和时序。当 Klipper 被命令对挤出速率进行显著更改时，它会规划出相应的速度、加速度和挤出机移动的变化——而这并非切片软件的本意。切片软件甚至可能命令过高的挤出速率，以至于触发 Klipper 的最大挤出截面检查。

相比之下，使用切片软件的“回抽”设置、“擦拭”设置和/或“回抽时擦拭”设置是可以的（通常是有帮助的）。

## START_PRINT 宏

当使用 START_PRINT 宏或类似功能时，有时将切片软件变量中的参数传递给宏会很有用。

在 Cura 中，要传递温度，可以使用以下开始 G-Code：

```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

在 Slic3r 衍生产品（如 PrusaSlicer 和 SuperSlicer）中，应使用以下代码：

```
START_PRINT EXTRUDER_TEMP=[first_layer_temperature] BED_TEMP=[first_layer_bed_temperature]
```

另外请注意，当某些条件未满足时，这些切片软件会插入自己的加热代码。在 Cura 中，存在 `{material_bed_temperature_layer_0}` 和 `{material_print_temperature_layer_0}` 变量就足以避免这种情况。在 Slic3r 衍生产品中，您应在宏调用前使用：

```
M140 S0
M104 S0
```

另外请注意，SuperSlicer 有一个“仅自定义 G-Code”按钮选项，可以达到相同的效果。

在 config/sample-macros.cfg 中可以找到使用这些参数的 START_PRINT 宏的示例。