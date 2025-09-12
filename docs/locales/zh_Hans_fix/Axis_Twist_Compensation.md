# 轴扭曲补偿

本文档描述了 `[axis_twist_compensation]` 模块。

某些打印机的 X 滑轨可能存在轻微扭曲，这会导致安装在 X 滑座上的探针测量结果出现偏差。  
这种现象在 Prusa MK3、Sovol SV06 等设计的打印机中较为常见，并在[探针位置偏差](Probe_Calibrate.md#location-bias-check)部分有进一步说明。  
它可能导致诸如[床面网格](Bed_Mesh.md)、[螺钉倾斜调整](G-Codes.md#screws_tilt_adjust)、[Z 轴倾斜调整](G-Codes.md#z_tilt_adjust)等探针操作返回不准确的床面数据。

该模块通过用户手动测量来校正探针的测量结果。请注意，如果您的轴存在明显扭曲，强烈建议先通过机械方式修复，再进行软件校正。

**警告**：此模块目前尚不兼容可拆卸探针，如果使用，它会尝试在未连接探针的情况下对床面进行探测。

## 补偿功能使用概览

> **提示**：请确保正确设置[探针 X 和 Y 偏移量](Config_Reference.md#probe)，因为它们对校准结果有很大影响。

### 基本用法：X 轴校准
1. 设置好 `[axis_twist_compensation]` 模块后，运行：
```
AXIS_TWIST_COMPENSATION_CALIBRATE
```
此命令默认将对 X 轴进行校准。
  - 校准向导会提示您在床面上多个点测量探针的 Z 偏移量。
  - 默认情况下，校准使用 3 个点，但您可以通过以下选项指定不同数量：
``
SAMPLE_COUNT=<值>
``

2. **调整您的 Z 偏移量：**
完成校准后，请务必[调整您的 Z 偏移量](Probe_Calibrate.md#calibrating-probe-z-offset)。

3. **执行床面调平操作：**
根据需要使用基于探针的操作，例如：
  - [螺钉倾斜调整](G-Codes.md#screws_tilt_adjust)
  - [Z 轴倾斜调整](G-Codes.md#z_tilt_adjust)

4. **完成最终设置：**
  - 归零所有轴，如有必要，执行一次[床面网格](Bed_Mesh.md)。
  - 进行测试打印，然后根据需要进行任何[微调](Axis_Twist_Compensation.md#fine-tuning)。

### Y 轴校准
Y 轴的校准过程与 X 轴类似。要校准 Y 轴，请使用：
```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```
这将引导您完成与 X 轴相同的测量过程。

> **提示**：床温、喷嘴温度和喷嘴尺寸似乎对校准过程没有影响。

## [axis_twist_compensation] 设置与命令

有关 `[axis_twist_compensation]` 的配置选项，请参见[配置参考](Config_Reference.md#axis_twist_compensation)。

有关 `[axis_twist_compensation]` 的命令，请参见[G代码参考](G-Codes.md#axis_twist_compensation)