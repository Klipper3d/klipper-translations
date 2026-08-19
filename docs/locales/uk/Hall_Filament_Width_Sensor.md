# Сенсор ширини філамента на датчику Холла

Цей документ описує модуль датчика нитки. Обладнання, що використовується для розробки цього модуля хосту на основі двох лінійних датчиків холу (s49e наприклад). Датчики в тілі розташовані по протилежних сторонах. Принцип роботи: два датчики залу працюють в диференціальному режимі, температурний дрейф однаковий для датчика. Особлива температура не потрібна.

Ви можете знайти зразки на [Thingiverse](https://www.thingiverse.com/thing:4138933), відео з збірки також доступний на [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)

Для використання датчика ширини залів, читання [Config Reference](Config_Reference.md#hall_filament_width_sensor) і [G-Code документація](G-Codes.md#hall_filament_width_sensor).

## # Як це працює?

Датчик генерує дві аналогові виходи на основі розрахункової ширини нитки. Сума вихідної напруги завжди дорівнює виявленню ширини нитки. Модуль Хост відстежує зміни напруги і регулює екструзійне багатоплище. Я користуюсь роз'ємом aux2 на схожій дошці ramps з аналогом11 і аналоговими12 шпильками. Ви можете використовувати різні шпильки і різні дошки.

## Шаблон змінних меню

```
__main __filament __width_current]
Тип: команда
Увімкніть: {'hall_filament_width_sensor' в принтері}
name: Dia: {'%.2F' % принтер.hall_filament_width_sensor.Diameter}
індекс: 0

__main __filament __raw_width_current]
Тип: команда
Увімкніть: {'hall_filament_width_sensor' в принтері}
Ім'я: Сирий: {'%4.0F' % принтер.hall_filament_width_sensor.Raw}
Індекс: 1 час
```

## Процедура калібрування

Для отримання значення сирого датчика можна використовувати пункт меню або **QUERY_RAW_FILAMENT_WIDTH** в терміналі.

1. Вставити перший калібрувальний стрижень (розмір 1,5 мм) отримати перше значення датчика
1. Вставте другий калібрувальний стрижень (розмір 2,0 мм) отримайте друге значення датчика
1. Зберегти значення датчика в параметрі конфігурації `Raw_dia1` і `Raw_dia2`

## Як включити датчик

За замовчуванням датчик вимкнено в Power-on.

Щоб увімкнути датчик, номер **ENABLE_FILAMENT_WIDTH_SENSOR** команди або `встановити` параметр ` true`.

## Use as a runout switch only

By default, the sensor measures filament diameter and adjusts the extrusion multiplier to compensate for variations.

If you want to use the sensor as a runout switch only, set the `enable_flow_compensation` config parameter to `false`. In this mode, the sensor will only trigger runout events when filament is not detected, it will not modify the extrusion multiplier.

This is useful for printers where the filament sensor is not accurate enough for flow compensation but can reliably detect filament runout, or when printing with flexible filaments which have unstable diameter characteristics.

Issue **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=1** to enable flow compensation or **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=0** to disable it.

Note that disabling filament width compensation automatically resets the extrusion multiplier to 100%.

**QUERY_FILAMENT_WIDTH** includes the current state of flow compensation in its output.

## Журналювання

За замовчуванням, вхід діаметра відключений на Power-on.

**ENABLE_FILAMENT_WIDTH_LOG** команди, щоб розпочати журналювання та випуск **DISABLE_FILAMENT_WIDTH_LOG** команди, щоб зупинити реєстрацію. Щоб увімкнути запис у Power-on, встановіть параметр ` ` до `true`.

Діаметр фільтра вводять на кожен інтервал вимірювання (10 мм за замовчуванням).
