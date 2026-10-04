# Hall-sensor för filamentbredd

Detta dokument beskriver värdmodulen för en sensor för filamentbredd. Maskinvaran som användes för att utveckla värdmodulen bygger på två linjära Hall-sensorer (till exempel ss49e). Sensorerna sitter på motsatta sidor i höljet. Funktionsprincip: två Hall-sensorer arbetar i differentiellt läge, och temperaturdriften är densamma för båda sensorerna. Särskild temperaturkompensering behövs inte.

Konstruktioner finns på [Thingiverse](https://www.thingiverse.com/thing:4138933); en monteringsvideo finns också på [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4).

Läs [konfigurationsreferensen](Config_Reference.md#hall_filament_width_sensor) och [G-kodsdokumentationen](G-Codes.md#hall_filament_width_sensor) för att använda Hall-sensorn för filamentbredd.

## Så fungerar den

Sensorn genererar två analoga utgångar baserade på den beräknade filamentbredden. Summan av utspänningarna motsvarar alltid den uppmätta filamentbredden. Värdmodulen övervakar spänningsförändringar och justerar extruderingsmultiplikatorn. aux2-kontakten på ett RAMPS-liknande kort med stiften analog11 och analog12 används. Andra stift och kort kan användas.

## Mall för menyvariabler

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

## Kalibreringsförfarande

Du kan använda menyalternativet eller kommandot **QUERY_RAW_FILAMENT_WIDTH** i terminalen för att hämta det råa sensorvärdet.

1. Sätt in den första kalibreringsstaven (1,5 mm) och hämta det första råa sensorvärdet
1. Sätt in den andra kalibreringsstaven (2,0 mm) och hämta det andra råa sensorvärdet
1. Spara de råa sensorvärdena i konfigurationsparametrarna `Raw_dia1` och `Raw_dia2`

## Så aktiveras sensorn

Sensorn är som standard inaktiverad vid start.

Aktivera sensorn genom att köra kommandot **ENABLE_FILAMENT_WIDTH_SENSOR** eller ange parametern `enable` till `true`.

## Använd endast som filamentslutssensor

Sensorn mäter som standard filamentdiametern och justerar extruderingsmultiplikatorn för att kompensera för variationer.

Om du endast vill använda sensorn som filamentslutssensor anger du konfigurationsparametern `enable_flow_compensation` till `false`. I det läget utlöser sensorn bara händelser om slut på filament när filament inte upptäcks och ändrar inte extruderingsmultiplikatorn.

Detta är användbart för skrivare där filamentsensorn inte är tillräckligt exakt för flödeskompensering men pålitligt kan upptäcka att filamentet tar slut, eller vid utskrift med flexibla filament vars diameter varierar.

Kör **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=1** för att aktivera flödeskompensering eller **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=0** för att inaktivera den.

Observera att inaktivering av kompensation för filamentbredd automatiskt återställer extruderingsmultiplikatorn till 100 %.

**QUERY_FILAMENT_WIDTH** inkluderar flödeskompenseringens aktuella tillstånd i utdata.

## Loggning

Loggning av diameter är som standard inaktiverad vid start.

Kör kommandot **ENABLE_FILAMENT_WIDTH_LOG** för att starta loggning och **DISABLE_FILAMENT_WIDTH_LOG** för att stoppa den. Aktivera loggning vid start genom att ange parametern `logging` till `true`.

Filamentdiametern loggas vid varje mätintervall (10 mm som standard).
