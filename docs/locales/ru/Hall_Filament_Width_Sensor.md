# Датчик Холла ширины филамента

В этом документе описывается хост-модуль датчика ширины филамента. Аппаратное обеспечение, используемое для разработки этого главного модуля, основано на двух линейных датчиках Холла (например, ss49e). Датчики в корпусе расположены с противоположных сторон. Принцип работы: два датчика Холла работают в дифференциальном режиме, температурный дрейф одинаков для датчика. Специальная температурная компенсация не требуется.

Вы можете найти примеры на [Thingiverse](https://www.thingiverse.com/thing:4138933), также доступно видео на [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)

To use Hall filament width sensor, read [Config Reference](Config_Reference.md#hall_filament_width_sensor) and [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Как это работает?

Sensor generates two analog output based on calculated filament width. Sum of output voltage always equals to detected filament width. Host module monitors voltage changes and adjusts extrusion multiplier. I use aux2 connector on ramps-like board analog11 and analog12 pins. You can use different pins and differenr boards.

## Шаблон переменных меню

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## Процедура калибровки

To get raw sensor value you can use menu item or **QUERY_RAW_FILAMENT_WIDTH** command in terminal.

1. Insert first calibration rod (1.5 mm size) get first raw sensor value
1. Insert second calibration rod (2.0 mm size) get second raw sensor value
1. Save raw sensor values in config parameter `Raw_dia1` and `Raw_dia2`

## Как включить сенсор

По умолчанию датчик выключен при включении.

To enable the sensor, issue **ENABLE_FILAMENT_WIDTH_SENSOR** command or set the `enable` parameter to `true`.

## Журнал

По умолчанию регистрация диаметра отключена при включении питания.

Issue **ENABLE_FILAMENT_WIDTH_LOG** command to start logging and issue **DISABLE_FILAMENT_WIDTH_LOG** command to stop logging. To enable logging at power-on, set the `logging` parameter to `true`.

Диаметр филамента регистрируется на каждом интервале измерения (по умолчанию 10 мм).
