# 轴扭曲补偿

This document describes the `[axis_twist_compensation]` module.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

该模块使用用户手动测量来修正探头的结果。请注意，如果您的轴严重扭曲，强烈建议您在应用软件更正之前首先使用机械方法修复它。

**警告**：此模块暂时与可对接探头不兼容，如果使用，将尝试在不连接探头的情况下探床。

## 薪酬使用概览

> **提示：**请确保正确设置[Probe X和Y Offset](Config_Reference.md#Probe)，因为它们对校准影响很大。

### 基础用途：X轴校准

1. 在设置完毕`[axis_twist_compensation]`模块后，运行：

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

This command will calibrate the X-axis by default.

- The calibration wizard will prompt you to measure the probe Z offset at several points along the bed.
- By default, the calibration uses 3 points, but you can specify a different number with the option: `SAMPLE_COUNT=<value>`

1. **Adjust Your Z Offset:** After completing the calibration, be sure to [adjust your Z offset](Probe_Calibrate.md#calibrating-probe-z-offset).
1. **进行打印床调平操作：**使用基于探针的操作（如果需要），如下：

- [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust)
- [Z轴倾斜校正](G-Codes.md#z_tilt_adjust)

1. **结束设置：**

- 归零所有轴，并进行一次[床网](Bed_Mesh.md)（如果需要）。
- 进行测试打印，并进行[精细调整](Axis_Twist_Compensation.md#fine-tuning)如果需要。

### 对于Y轴校准

Y轴的校准流程与X轴接近。如果要校准Y轴，使用一下方法：

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

这将会进行与X轴相同的测量流程。

> **提示：**床温、喷嘴温度和尺寸似乎对校准过程没有影响。

## [AXIS_TWIST_COMMENTION]设置和命令

Configuration options for `[axis_twist_compensation]` can be found in the [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Commands for `[axis_twist_compensation]` can be found in the [G-Codes Reference](G-Codes.md#axis_twist_compensation)
