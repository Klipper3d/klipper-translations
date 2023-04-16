# Hall nyomtatószál szélesség érzékelő

This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on two Hall linear sensors (ss49e for example). Sensors in the body are located on opposite sides. Principle of operation: two hall sensors work in differential mode, temperature drift same for sensor. Special temperature compensation not needed.

Terveket a [Thingiverse] oldalon találod (https://www.thingiverse.com/thing:4138933), az összeszerelési videó a [Youtube]-on is elérhető (https://www.youtube.com/watch?v=TDO9tME8vp4 )

A Hall nyomtatószál szélesség érzékelő használatához olvasd el a [Konfigurációs hivatkozás](Config_Reference.md#hall_filament_width_sensor) és a [G-kód dokumentáció](G-Codes.md#hall_filament_width_sensor) részt.

## Hogyan működik?

Sensor generates two analog output based on calculated filament width. Sum of output voltage always equals to detected filament width. Host module monitors voltage changes and adjusts extrusion multiplier. I use the aux2 connector on a ramps-like board with the analog11 and analog12 pins. You can use different pins and different boards.

## Menüváltozók sablonja

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

## Kalibrálási eljárás

Az érzékelő nyers értékének meghatározásához használhatod a menüelemet vagy a **QUERY_RAW_FILAMENT_WIDTH** parancsot a terminálban.

1. Helyezd be az első kalibráló rudat (1,5 mm-es méret), hogy megkapd az első nyers szenzorértéket
1. Helyezd be a második kalibráló rudat (2,0 mm-es méret), hogy megkapd a második nyers szenzorértéket
1. Mentsd a nyers szenzorértékeket a `Raw_dia1` és a `Raw_dia2` konfigurációs paraméterekbe

## Az érzékelő engedélyezése

Alapértelmezés szerint az érzékelő le van tiltva bekapcsoláskor.

Az érzékelő engedélyezéséhez add ki az **ENABLE_FILAMENT_WIDTH_SENSOR** parancsot, vagy állítsd az `enable` paramétert `true` értékre.

## Naplózás

Alapértelmezés szerint az átmérő naplózása bekapcsoláskor le van tiltva.

Add ki az **ENABLE_FILAMENT_WIDTH_LOG** parancsot a naplózás elindításához, és add ki a **DISABLE_FILAMENT_WIDTH_LOG** parancsot a naplózás leállításához. A bekapcsoláskor történő naplózás engedélyezéséhez állítsd a `logging paramétert `true` értékre.

A nyomtatószál átmérője minden mérési intervallumban naplózásra kerül (alapértelmezés szerint 10 mm).
