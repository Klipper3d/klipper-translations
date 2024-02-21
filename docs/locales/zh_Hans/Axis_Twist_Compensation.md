# 轴扭曲补偿

本文档介绍了[AXIS_TWIST_COMPOMENT]模块。

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

该模块使用用户手动测量来修正探头的结果。请注意，如果您的轴严重扭曲，强烈建议您在应用软件更正之前首先使用机械方法修复它。

**警告**：此模块暂时与可对接探头不兼容，如果使用，将尝试在不连接探头的情况下探床。

## 薪酬使用概览

> **提示：**请确保正确设置[Probe X和Y Offset](Config_Reference.md#Probe)，因为它们对校准影响很大。

1. 设置好[AXIS_TWIST_COMPOMENT]模块后，执行`AXIS_TWIST_COMCOMPATION_CALIBRATE`

* 校准向导将提示您在床上的几个点上测量探头Z偏移量
* 该校准默认为3分，但您可以使用选项`SAMPLE_COUNT=`来使用不同的数字。

1. [调整您的Z offset](Probe_Calibrate.md#calibrating-probe-z-offset)
1. 执行自动/探针式床铺操作，如[螺旋倾斜调整](G-Codes.md#螺旋倾斜调整)、[Z倾斜调整](G-Codes.md#z_倾斜调整)等
1. 原点所有轴，然后根据需要执行[Bed Mesh](Bed_Mesh.md)
1. 执行测试打印，然后根据需要执行任何[fine-tuning](Axis_Twist_Compensation.md#fine-tuning)

> **提示：**床温、喷嘴温度和尺寸似乎对校准过程没有影响。

## [AXIS_TWIST_COMMENTION]设置和命令

可在[配置Reference](Config_Reference.md#axis_twist_compensation).]中找到[AXIS_TWIST_COMPOMENT]的配置选项。

可在[G-Codes Reference](G-Codes.md#axis_twist_compensation)]中找到[AXIS_TWIST_COMPATION]的命令
