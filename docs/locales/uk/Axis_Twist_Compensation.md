# Компенсація скручування осі

This document describes the `[axis_twist_compensation]` module.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Цей модуль використовує ручні вимірювання користувача для корекції результатів датчика. Зауважте, що якщо ваша вісь значно перекручена, настійно рекомендується спочатку використати механічні засоби, щоб виправити це, перш ніж застосовувати програмні виправлення.

**Попередження**: цей модуль ще не сумісний із зондами, які можна приєднати, і, якщо ви його використовуєте, намагатиметься досліджувати ліжко, не приєднуючи зонд.

## Огляд використання компенсації

> **Порада.** Переконайтеся, що [зміщення зонда X і Y](Config_Reference.md#probe) налаштовано правильно, оскільки вони значною мірою впливають на калібрування.

### Основне використання: калібрування осі X

1. Після налаштування модуля `[axis_twist_compensation]` виконайте:

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

This command will calibrate the X-axis by default.

- The calibration wizard will prompt you to measure the probe Z offset at several points along the bed.
- By default, the calibration uses 3 points, but you can specify a different number with the option: `SAMPLE_COUNT=<value>`

1. **Adjust Your Z Offset:** After completing the calibration, be sure to [adjust your Z offset](Probe_Calibrate.md#calibrating-probe-z-offset).
1. **Виконайте операції з вирівнювання ліжка: ** За потреби використовуйте операції на основі зонда, наприклад:

- [Регулювання нахилу гвинтів](G-Codes.md#screws_tilt_adjust)
- [Налаштування нахилу Z](G-Codes.md#z_tilt_adjust)

1. **Завершіть налаштування:**

- Розмістіть усі осі та за потреби виконайте [Bed Mesh](Bed_Mesh.md).
- Запустіть пробний друк, а потім будь-яке [точне налаштування](Axis_Twist_Compensation.md#fine-tuning), якщо потрібно.

### Для калібрування осі Y

Процес калібрування для осі Y подібний до процесу калібрування для осі X. Щоб відкалібрувати вісь Y, використовуйте:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

Це проведе вас через той самий процес вимірювання, що й для осі X.

> **Порада:** Здається, температура шару, температура та розмір сопла не впливають на процес калібрування.

## Налаштування та команди [axis_twist_compensation]

Configuration options for `[axis_twist_compensation]` can be found in the [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Commands for `[axis_twist_compensation]` can be found in the [G-Codes Reference](G-Codes.md#axis_twist_compensation)
