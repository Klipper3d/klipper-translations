# 涡流电感式探头

本文档介绍了如何在Klipper中使用[涡流](https://en.wikipedia.org/wiki/Eddy_current)电感式探头。

目前，涡流探头不能用于Z轴归零。该传感器只能用于Z轴探测。

首先，在printer.cfg文件中声明一个[probe_eddy_current 配置部分](Config_Reference.md#probe_eddy_current)。建议将`z_offset`设置为0.5mm。该传感器通常需要设置`x_offset`和`y_offset`。如果这些值未知，应在初始校准期间进行估算。

校准的第一步是确定传感器合适的DRIVE_CURRENT。归零打印机，并将打印头移动到靠近床中心且距离床面约20mm的位置。然后执行`LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>`命令。例如，如果配置部分命名为`[probe_eddy_current my_eddy_probe]`，则应运行`LDC_CALIBRATE_DRIVE_CURRENT CHIP=my_eddy_probe`。此命令应在几秒钟内完成。完成后，执行`SAVE_CONFIG`命令将结果保存到printer.cfg并重启。

校准的第二步是将传感器读数与相应的Z高度关联起来。归零打印机，并将打印头移动到靠近床中心的位置。然后运行`PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe`命令。一旦工具启动，按照["纸张测试"](Bed_Level.md#the-paper-test)中描述的步骤确定喷嘴与床面在该位置的实际距离。完成这些步骤后，可以`ACCEPT`该位置。工具将移动打印头，使传感器位于喷嘴原来所在位置的上方，并执行一系列移动以将传感器与Z位置关联起来。这将需要几分钟时间。工具完成后，执行`SAVE_CONFIG`命令将结果保存到printer.cfg并重启。

初始校准后，最好验证`x_offset`和`y_offset`是否准确。按照[校准探头X和Y偏移](Probe_Calibrate.md#calibrating-probe-x-and-y-offsets)的步骤进行。如果修改了`x_offset`或`y_offset`，请务必在更改后运行`PROBE_EDDY_CURRENT_CALIBRATE`命令（如上所述）。

校准完成后，即可使用所有使用Z探头的标准Klipper工具。

请注意，涡流传感器（以及电感式探头总体而言）容易受到“热漂移”的影响。也就是说，温度的变化会导致报告的Z高度发生变化。床面温度或传感器硬件温度的变化都会使结果产生偏差。重要的是，只有在打印机处于稳定温度时才进行校准和探测。

## 热漂移校准

与所有电感式探头一样，涡流探头也容易发生显著的热漂移。如果涡流探头在线圈上装有温度传感器，则可以配置一个`[temperature_probe]`来报告线圈温度并启用软件漂移补偿。要将温度探头与涡流探头关联，`[temperature_probe]`部分必须与`[probe_eddy_current]`部分共享名称。例如：

```
[probe_eddy_current my_probe]
# 涡流探头配置...

[temperature_probe my_probe]
# 温度探头配置...
```

有关如何配置`temperature_probe`的更多详细信息，请参阅[配置参考](Config_Reference.md#temperature_probe)。建议配置`calibration_position`、`calibration_extruder_temp`、`extruder_heating_z`和`calibration_bed_temp`选项，因为这样做可以自动完成下面概述的一些步骤。如果要校准的打印机是封闭的，强烈建议将`max_validation_temp`选项设置为100至120之间的值。

涡流探头制造商可能会提供标准的漂移校准，可手动添加到`[probe_eddy_current]`部分的`drift_calibration`选项中。如果没有，或者标准校准在您的系统上表现不佳，`temperature_probe`模块通过`TEMPERATURE_PROBE_CALIBRATE` gcode命令提供手动校准程序。

在执行校准之前，用户应了解温度探头线圈可达到的最高温度。此温度应用于设置`TEMPERATURE_PROBE_CALIBRATE`命令的`TARGET`参数。目标是尽可能宽的温度范围内进行校准，因此最好从冷机开始，到线圈达到其可达到的最高温度结束。

配置`[temperature_probe]`后，可采取以下步骤进行热漂移校准：

- 当配置并链接`[temperature_probe]`时，必须使用`PROBE_EDDY_CURRENT_CALIBRATE`对探头进行校准。这将在校准期间捕获温度，这是进行热漂移补偿所必需的。
- 确保喷嘴无碎屑和耗材。
- 校准前，床面、喷嘴和探头线圈应处于冷态。
- 如果`[temperature_probe]`中的`calibration_position`、`calibration_extruder_temp`和`extruder_heating_z`选项**未**配置，则必须执行以下步骤：
  - 将工具移动到床中心。Z应高于床面30mm以上。
  - 将挤出机加热到高于床最高安全温度的温度。对于大多数配置，150-170°C就足够了。加热挤出机的目的是避免校准期间喷嘴膨胀。
  - 当挤出机温度稳定后，将Z轴向下移动到距床面约1mm的位置。
- 开始漂移校准。如果探头名称为`my_probe`，我们能达到的最高探头温度为80°C，则适当的gcode命令为`TEMPERATURE_PROBE_CALIBRATE PROBE=my_probe TARGET=80`。如果已配置，工具将移动到`calibration_position`指定的X、Y坐标和`extruder_heating_z`指定的Z值。在将挤出机加热到指定温度后，工具将移动到`calibration_position`指定的Z值。
- 该程序将请求手动探测。使用纸张测试并`ACCEPT`进行手动探测。校准程序将采集第一组样本，然后将探头停放在加热位置。
- 如果`calibration_bed_temp`**未**配置，请打开床加热到最高安全温度。否则此步骤将自动执行。
- 默认情况下，校准程序将在样本之间每2°C请求一次手动探测，直到达到`TARGET`。可以通过在`TEMPERATURE_PROBE_CALIBRATE`中设置`STEP`参数来自定义样本之间的温度增量。设置自定义`STEP`值时应小心，值过高可能会导致样本过少，从而导致校准效果不佳。
- 校准期间还可使用以下附加gcode命令：
  - `TEMPERATURE_PROBE_NEXT`可用于在达到步进增量之前强制获取新样本。
  - `TEMPERATURE_PROBE_COMPLETE`可用于在达到`TARGET`之前完成校准。
  - `ABORT`可用于结束校准并丢弃结果。
- 校准完成后，使用`SAVE_CONFIG`存储漂移校准。

正如可以得出的结论，上述校准过程比大多数其他程序更具挑战性且耗时。可能需要练习和多次尝试才能达到最佳校准。