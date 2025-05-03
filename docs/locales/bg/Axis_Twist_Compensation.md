# Компенсация на усукването на оста

This document describes the `[axis_twist_compensation]` module.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Този модул използва ръчните измервания на потребителя за коригиране на резултатите от сондата. Обърнете внимание, че ако оста е значително усукана, силно се препоръчва първо да използвате механични средства, за да я фиксирате, преди да прилагате софтуерни корекции.

**Предупреждение**: Този модул все още не е съвместим с докинг сондите и ако го използвате, ще се опита да изследва леглото, без да е прикрепена сондата.

## Преглед на използването на компенсациите

> **Съвет:** Уверете се, че [отместванията на сондата X и Y](Config_Reference.md#probe) са правилно зададени, тъй като те оказват голямо влияние върху калибрирането.

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

> **Съвет:** Изглежда, че температурата на леглото и температурата и размерът на дюзата не оказват влияние върху процеса на калибриране.

## [axis_twist_compensation] настройка и команди

Configuration options for `[axis_twist_compensation]` can be found in the [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Commands for `[axis_twist_compensation]` can be found in the [G-Codes Reference](G-Codes.md#axis_twist_compensation)
