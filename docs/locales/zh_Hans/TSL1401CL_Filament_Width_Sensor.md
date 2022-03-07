# TSL1401CL 耗材宽度传感器

本文档描述了耗材宽度传感器主机模块。用于开发此主机模块的硬件基于 TSL1401CL 线性传感器阵列，但该模块可以与任何具有模拟输出的传感器阵列一起使用。您可以在 [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor) 找到可用的设计。

要使用基于传感器阵列的耗材宽度传感器，请参阅[配置参考](Config_Reference.md#tsl1401cl_filament_width_sensor)和[G-Code documentation](G-Code.md#hall_filament_width_sensor)。

## 它如何运作？

根据传感器产生模拟输出计算的耗材宽度。检测到的耗材宽度和输出电压相对应（例如：1.65v、1.70v、3.0v）。主机模块监测电压变化并调整挤出倍率。

## 注意：

默认以 10 毫米的间隔对传感器进行读数。如果需要，可以通过编辑 **filament_width_sensor.py** 文件中的 ***MEASUREMENT_INTERVAL_MM*** 文件中的参数来改变这一设置。
