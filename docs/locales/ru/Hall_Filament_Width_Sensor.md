# Датчик Холла ширины филамента

This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on two Hall linear sensors (ss49e for example). Sensors in the body are located on opposite sides. Principle of operation: two hall sensors work in differential mode, temperature drift same for sensor. Special temperature compensation not needed.

Вы можете найти примеры на [Thingiverse](https://www.thingiverse.com/thing:4138933), также доступно видео на [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)

To use Hall filament width sensor, read [Config Reference](Config_Reference.md#hall_filament_width_sensor) and [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Как это работает?

Sensor generates two analog output based on calculated filament width. Sum of output voltage always equals to detected filament width. Host module monitors voltage changes and adjusts extrusion multiplier. I use the aux2 connector on a ramps-like board with the analog11 and analog12 pins. You can use different pins and different boards.

## Шаблон переменных меню

```
[menu __main __filament __width_current] /Меню главной толщины филамента
type: command /тип:команда
enable: {'hall_filament_width_sensor' in printer} /включить:
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}/Имя:
index: 0 /индекс:

[menu __main __filament __raw_width_current] /Меню главной толщины сырого филамента
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## Процедура калибровки

To get raw sensor value you can use menu item or **QUERY_RAW_FILAMENT_WIDTH** command in terminal.

1. Вставьте первый калибровочный стержень (размер 1,5 мм) и получите первое необработанное значение датчика
1. Вставьте второй калибровочный стержень (размер 2,0 мм) и получите второе необработанное значение датчика
1. Save raw sensor values in config parameter `Raw_dia1` and `Raw_dia2`

## Как включить сенсор

По умолчанию датчик выключен при включении.

To enable the sensor, issue **ENABLE_FILAMENT_WIDTH_SENSOR** command or set the `enable` parameter to `true`.

## Журнал

По умолчанию регистрация диаметра отключена при включении питания.

Issue **ENABLE_FILAMENT_WIDTH_LOG** command to start logging and issue **DISABLE_FILAMENT_WIDTH_LOG** command to stop logging. To enable logging at power-on, set the `logging` parameter to `true`.

Диаметр филамента регистрируется на каждом интервале измерения (по умолчанию 10 мм).
