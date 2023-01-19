# TSL1401CL czujnik szerokości filamentu

Niniejszy dokument opisuje czujnik szerokości włókna. Sprzęt użyty do opracowania tego modułu bazuje na liniowym układzie czujników TSL1401CL, ale może on współpracować z dowolnym układem czujników z wyjściem analogowym. Projekty można znaleźć na stronie [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

Aby użyć tablicy czujników jako czujnika szerokości włókna, przeczytaj [Config Reference](Config_Reference.md#tsl1401cl_filament_width_sensor) i [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Jak to działa?

Czujnik generuje wyjście analogowe na podstawie obliczonej szerokości żarnika. Napięcie wyjściowe jest zawsze równe wykrytej szerokości włókna (np. 1.65v, 1.70v, 3.0v). Moduł hosta monitoruje zmiany napięcia i dostosowuje mnożnik ekstruzji.

## Uwaga:

Odczyty czujnika są domyślnie wykonywane w odstępach co 10 mm. W razie potrzeby można zmienić to ustawienie poprzez edycję parametru ***MEASUREMENT_INTERVAL_MM*** w pliku **filament_width_sensor.py**.
