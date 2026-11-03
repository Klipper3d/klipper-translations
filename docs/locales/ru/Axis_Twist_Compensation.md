# Компенсация поворота оси

В этом документе описан модуль `[axis_twist_compensation]`.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Этот модуль использует ручные измерения пользователя для коррекции результатов измерений датчика. Обратите внимание, что если ваша ось значительно искривлена, настоятельно рекомендуется сначала использовать механические средства для ее исправления, прежде чем применять программные корректировки.

**Предупреждение**: Этот модуль пока не совместим со стыкуемыми зондами и при его использовании будет пытаться прощупать кровать, не прикрепляя зонд.

## Обзор использования компенсаций

> **Совет:** Убедитесь, что параметры [смещения зонда по X и Y](Config_Reference.md#probe) установлены правильно, так как они сильно влияют на калибровку.

### Базовое использование: калибровка оси X

1. После установки модуля `[axis_twist_compensation]` запустите:

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

По умолчанию эта команда калибрует ось X.

- Мастер калибровки предложит вам измерить Z-смещение датчика в нескольких точках стола.
- По умолчанию калибровка использует 3 точки, но вы можете указать другое количество с помощью опции: `SAMPLE_COUNT=<value>`

1. **Отрегулируйте Z-смещение:** после завершения калибровки обязательно [отрегулируйте Z-смещение](Probe_Calibrate.md#calibrating-probe-z-offset).
1. **Передельные операции по уравниванию кровати: ** Использовать операции на основе зондов по мере необходимости, такие как:

- [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust)
- [Z Tilt Adjust](G-Codes.md#z_tilt_adjust)

1. **Финализируйте настройку: **

- Домой все топоры, и выполнить [Bed Mesh](Bed_Mesh.md) при необходимости.
- Проведите тест-печать, за которым следует любая [настройка](Axis_Twist_Compensation.md#fine-tuning), если это необходимо.

### Для калибровки Y-Axis

Процесс калибровки для Y-оси похож на X-оси. Для калибровки Y-оси используются:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

Это будет направлять вас через тот же процесс измерения, что и для X-оси.

> **Совет: ** Температура слоя, температура и размер сопла не оказывают влияния на процесс калибровки.

## Настройка и команды [axis_twist_compensation]

Параметры конфигурации для `[axis_twist_compensation]` можно найти в [справочнике конфигурации](Config_Reference.md#axis_twist_compensation).

Команды для `[axis_twist_compensation]` можно найти в [справочнике G-кодов](G-Codes.md#axis_twist_compensation)
