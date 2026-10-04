# TSL1401CL-filamentbreddssensor

Det här dokumentet beskriver värdmodulen för filamentbreddssensorn. Maskinvaran som användes för att utveckla modulen bygger på den linjära sensormatrisen TSL1401CL, men den kan fungera med alla sensormatrisar med analog utgång. Det finns konstruktioner på [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

För att använda en sensormatris som filamentbreddssensor, läs [konfigurationsreferensen](Config_Reference.md#tsl1401cl_filament_width_sensor) och [G-koddokumentationen](G-Codes.md#hall_filament_width_sensor).

## Så fungerar den

Sensorn ger en analog utgång baserad på den beräknade filamentbredden. Utspänningen motsvarar alltid den identifierade filamentbredden, till exempel 1,65 V, 1,70 V eller 3,0 V. Värdmodulen övervakar spänningsändringar och justerar extruderingsmultiplikatorn.

## Observera:

Sensoravläsningar görs som standard med 10 mm intervall. Vid behov kan du ändra inställningen genom att redigera parametern ***MEASUREMENT_INTERVAL_MM*** i filen **filament_width_sensor.py**.
