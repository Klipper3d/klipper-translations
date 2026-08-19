# Hall nyomtatószál szélesség érzékelő

Ez a dokumentum a szálszélesség-érzékelő gazdamodult ismerteti. A gazdamodul fejlesztéséhez használt hardver két Hall lineáris érzékelőn alapul (például ss49e). A testben lévő érzékelők ellentétes oldalakon helyezkednek el. Működési elv: a két Hall-érzékelő differenciális üzemmódban működik, a hőmérséklet-drift azonos az érzékelőnél. Speciális hőmérséklet-kompenzációra nincs szükség.

Terveket a [Thingiverse] oldalon találod (https://www.thingiverse.com/thing:4138933), az összeszerelési videó a [Youtube]-on is elérhető (https://www.youtube.com/watch?v=TDO9tME8vp4 )

A Hall nyomtatószál szélesség érzékelő használatához olvasd el a [Konfigurációs hivatkozás](Config_Reference.md#hall_filament_width_sensor) és a [G-kód dokumentáció](G-Codes.md#hall_filament_width_sensor) részt.

## Hogyan működik?

Az érzékelő két analóg kimenetet generál a számított szálszélesség alapján. A kimeneti feszültség összege mindig megegyezik az érzékelt nyomtatószál szélességgel. A gazdamodul figyeli a feszültségváltozásokat és beállítja az extrudálási szorzót. Az aux2 csatlakozót egy RAMPS lapon használom az analóg11 és analóg12 tűkkel. Használhatsz más tűket és más lapokat is.

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

## Use as a runout switch only

By default, the sensor measures filament diameter and adjusts the extrusion multiplier to compensate for variations.

If you want to use the sensor as a runout switch only, set the `enable_flow_compensation` config parameter to `false`. In this mode, the sensor will only trigger runout events when filament is not detected, it will not modify the extrusion multiplier.

This is useful for printers where the filament sensor is not accurate enough for flow compensation but can reliably detect filament runout, or when printing with flexible filaments which have unstable diameter characteristics.

Issue **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=1** to enable flow compensation or **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=0** to disable it.

Note that disabling filament width compensation automatically resets the extrusion multiplier to 100%.

**QUERY_FILAMENT_WIDTH** includes the current state of flow compensation in its output.

## Naplózás

Alapértelmezés szerint az átmérő naplózása bekapcsoláskor le van tiltva.

Add ki az **ENABLE_FILAMENT_WIDTH_LOG** parancsot a naplózás elindításához, és add ki a **DISABLE_FILAMENT_WIDTH_LOG** parancsot a naplózás leállításához. A bekapcsoláskor történő naplózás engedélyezéséhez állítsd a `logging paramétert `true` értékre.

A nyomtatószál átmérője minden mérési intervallumban naplózásra kerül (alapértelmezés szerint 10 mm).
