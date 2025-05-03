# 轴扭曲补偿

This document describes the `[axis_twist_compensation]` module.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

该模块使用用户手动测量来修正探头的结果。请注意，如果您的轴严重扭曲，强烈建议您在应用软件更正之前首先使用机械方法修复它。

**警告**：此模块暂时与可对接探头不兼容，如果使用，将尝试在不连接探头的情况下探床。

## 薪酬使用概览

> **提示：**请确保正确设置[Probe X和Y Offset](Config_Reference.md#Probe)，因为它们对校准影响很大。

### Basic Usage: X-Axis Calibration

1. After setting up the `[axis_twist_compensation]` module, run:

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

This command will calibrate the X-axis by default.

- The calibration wizard will prompt you to measure the probe Z offset at several points along the bed.
- By default, the calibration uses 3 points, but you can specify a different number with the option: `SAMPLE_COUNT=<value>`

1. **Adjust Your Z Offset:** After completing the calibration, be sure to [adjust your Z offset](Probe_Calibrate.md#calibrating-probe-z-offset).
1. **Perform Bed Leveling Operations:** Use probe-based operations as needed, such as:

- [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust)
- [Z Tilt Adjust](G-Codes.md#z_tilt_adjust)

1. **Finalize the Setup:**

- Home all axes, and perform a [Bed Mesh](Bed_Mesh.md) if necessary.
- Run a test print, followed by any [fine-tuning](Axis_Twist_Compensation.md#fine-tuning) if needed.

### For Y-Axis Calibration

The calibration process for the Y-axis is similar to the X-axis. To calibrate the Y-axis, use:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

This will guide you through the same measuring process as for the X-axis.

> **提示：**床温、喷嘴温度和尺寸似乎对校准过程没有影响。

## [AXIS_TWIST_COMMENTION]设置和命令

Configuration options for `[axis_twist_compensation]` can be found in the [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Commands for `[axis_twist_compensation]` can be found in the [G-Codes Reference](G-Codes.md#axis_twist_compensation)
