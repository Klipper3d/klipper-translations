# 霍尔耗材线径传感器

本文件介绍了耗材直径传感器的主机模块。用于开发该主机模块的硬件基于两个霍尔线性传感器（例如，ss49e）。霍尔传感器位于相对耗材直径模块的两侧。工作原理：两个霍尔传感器以差分模式工作，由于传感器的温度漂移相同，不需要特殊的温度补偿。

你可以在[Thingiverse](https://www.thingiverse.com/thing:4138933)上找到设计，在[Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)上也有一个装配视频

要使用霍尔耗材线径传感器，请阅读[配置参考](Config_Reference.md#hall_filament_width_sensor)和[G-Code 文档](G-Codes.md#hall_filament_width_sensor)。

## 它如何运作？

传感器基于两个模拟输出计算出耗材直径。检测到的电压之和始终对应耗材直径。主机模块监测电压变化并调整挤出倍率。例如可以在类似ramps的控制板上使用 aux2 连接器的 analog11和analog12引脚，你也可以使用不同的引脚和不同的控制板。

## 菜单变量模板

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## 校准程序

要获得原始传感器值，你可以使用菜单中的选项或在终端发送**QUERY_RAW_FILAMENT_WIDTH**命令。

1. 插入第一根校准棒（1.5毫米直径），并得到第一个原始传感器值
1. 插入第二根校准棒（2.0毫米直径），并得到第二个原始传感器值
1. 在配置参数`Raw_dia1`和`Raw_dia2`中写入原始传感器值

## 如何启用传感器

传感器在开机时默认被禁用。

要启用传感器，发送**ENABLE_FILAMENT_WIDTH_SENSOR**命令或将`enable`参数改为`true`。

## 记录

直径记录在开机时默认被禁用。

发送**ENABLE_FILAMENT_WIDTH_LOG**命令开始记录，发送**DISABLE_FILAMENT_WIDTH_LOG**命令停止记录。如果想在开机时启用日志记录，请将`logging`配置参数设置为`true`。

每个测量间隔都会记录耗材直径（默认为10毫米）。
