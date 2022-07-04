# TSL1401CL czujnik szerokości filamentu

This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on TSL1401CL linear sensor array but it can work with any sensor array that has analog output. You can find designs at [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

To use a sensor array as a filament width sensor, read [Config Reference](Config_Reference.md#tsl1401cl_filament_width_sensor) and [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Jak to działa?

Czujnik generuje wyjście analogowe na podstawie obliczonej szerokości żarnika. Napięcie wyjściowe jest zawsze równe wykrytej szerokości włókna (np. 1.65v, 1.70v, 3.0v). Moduł hosta monitoruje zmiany napięcia i dostosowuje mnożnik ekstruzji.

## Note:

Odczyty czujnika są domyślnie wykonywane w odstępach co 10 mm. W razie potrzeby można zmienić to ustawienie poprzez edycję parametru ***MEASUREMENT_INTERVAL_MM*** w pliku **filament_width_sensor.py**.
