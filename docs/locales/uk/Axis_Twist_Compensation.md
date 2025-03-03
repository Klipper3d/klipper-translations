# Компенсація скручування осі

Цей документ описує модуль [axis_twist_compensation].

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

Ця команда відкалібрує вісь Х за замовчуванням. - Майстер калібрування запропонує вам виміряти зсув зонда Z у кількох точках уздовж дна. - За замовчуванням калібрування використовує 3 точки, але ви можете вказати інше число за допомогою опції: `SAMPLE_COUNT=<value>`

1. **Налаштуйте зміщення Z:** Після завершення калібрування обов’язково [налаштуйте зміщення Z] (Probe_Calibrate.md#calibrating-probe-z-offset).
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

### Автоматичне калібрування для обох осей

Щоб виконати автоматичне калібрування осей X і Y без ручного втручання, використовуйте:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AUTO=True
```

У цьому режимі процес калібрування буде виконуватися для обох осей автоматично.

> **Порада:** Здається, температура шару, температура та розмір сопла не впливають на процес калібрування.

## Налаштування та команди [axis_twist_compensation]

Параметри конфігурації для [axis_twist_compensation] можна знайти в [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Команди для [axis_twist_compensation] можна знайти в [G-Codes Reference](G-Codes.md#axis_twist_compensation)
