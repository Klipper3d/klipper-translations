# 霍尔式线径传感器

本文档介绍线径传感器主机模块。开发此主机模块所使用的硬件基于两个霍尔线性传感器（例如 ss49e）。传感器在主体内位于相对的两侧。工作原理：两个霍尔传感器以差分模式工作，温度漂移对两个传感器相同，因此无需特殊的温度补偿。

您可以在 [Thingiverse](https://www.thingiverse.com/thing:4138933) 上找到设计图，[Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4) 上也提供了组装视频。

要使用霍尔式线径传感器，请阅读 [配置参考](Config_Reference.md#hall_filament_width_sensor) 和 [G-Code 文档](G-Codes.md#hall_filament_width_sensor)。

## 它是如何工作的？

传感器根据计算出的线材直径生成两个模拟输出。输出电压之和始终等于检测到的线材直径。主机模块监控电压变化并调整挤出倍率。我在类似 Ramps 的主板上的 aux2 接口使用 analog11 和 analog12 引脚。您可以使用不同的引脚和不同的主板。

## 菜单变量模板

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: 直径: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: 原始值: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## 校准程序

要获取传感器的原始值，可以使用菜单项或在终端中使用 **QUERY_RAW_FILAMENT_WIDTH** 命令。

1. 插入第一个校准杆（1.5 mm 尺寸），获取第一个原始传感器值。

2. 插入第二个校准杆（2.0 mm 尺寸），获取第二个原始传感器值。

3. 将原始传感器值保存在配置参数 `Raw_dia1` 和 `Raw_dia2` 中。

## 如何启用传感器

默认情况下，上电时传感器处于禁用状态。

要启用传感器，请发送 **ENABLE_FILAMENT_WIDTH_SENSOR** 命令，或将 `enable` 参数设置为 `true`。

## 日志记录

默认情况下，上电时直径日志记录处于禁用状态。

发送 **ENABLE_FILAMENT_WIDTH_LOG** 命令以开始记录，发送 **DISABLE_FILAMENT_WIDTH_LOG** 命令以停止记录。要在上电时启用日志记录，请将 `logging` 参数设置为 `true`。

线材直径在每次测量间隔（默认为 10 毫米）时记录一次。