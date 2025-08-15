# Senzor šírky filamentu TSL1401CL

Tento dokument popisuje hostiteľský modul snímača šírky vlákna. Hardvér použitý na vývoj tohto hostiteľského modulu je založený na lineárnom senzorovom poli TSL1401CL, ale môže fungovať s akýmkoľvek senzorovým poľom, ktorý má analógový výstup. Návrhy nájdete na [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

Ak chcete použiť pole senzorov ako senzor šírky filamentu, prečítajte si [Referencia konfigurácie](Config_Reference.md#tsl1401cl_filament_width_sensor) a [Dokumentácia G-Code](G-Codes.md#hall_filament_width_sensor).

## Ako to funguje?

Senzor generuje analógový výstup na základe vypočítanej šírky filamentu. Výstupné napätie sa vždy rovná detekovanej šírke filamentu (napr. 1,65 V, 1,70 V, 3,0 V). Hostiteľský modul monitoruje zmeny napätia a upravuje multiplikátor extrúzie.

## Poznámka:

Hodnoty senzora sa štandardne odčítavajú v 10 mm intervaloch. V prípade potreby môžete toto nastavenie zmeniť úpravou parametra ***MEASUREMENT_INTERVAL_MM*** v súbore **filament_width_sensor.py**.
