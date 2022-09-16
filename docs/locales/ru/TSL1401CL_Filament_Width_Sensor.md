# Датчик филамента TSL1401CL

This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on TSL1401CL linear sensor array but it can work with any sensor array that has analog output. You can find designs at [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

To use a sensor array as a filament width sensor, read [Config Reference](Config_Reference.md#tsl1401cl_filament_width_sensor) and [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Как это работает?

Датчик генерирует аналоговый выходной сигнал на основе расчетной ширины нити накала. Выходное напряжение всегда равно обнаруженной ширине нити накала (например, 1,65 В, 1,70 В, 3,0 В). Главный модуль отслеживает изменения напряжения и регулирует множитель экструзии.

## Note:

Показания датчика по умолчанию выполняются с интервалом в 10 мм. При необходимости вы можете изменить этот параметр, отредактировав параметр ***MEASUREMENT_INTERVAL_MM*** в **filament_width_sensor.py ** файл.
