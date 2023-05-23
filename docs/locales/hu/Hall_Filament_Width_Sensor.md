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

## Naplózás

Alapértelmezés szerint az átmérő naplózása bekapcsoláskor le van tiltva.

Add ki az **ENABLE_FILAMENT_WIDTH_LOG** parancsot a naplózás elindításához, és add ki a **DISABLE_FILAMENT_WIDTH_LOG** parancsot a naplózás leállításához. A bekapcsoláskor történő naplózás engedélyezéséhez állítsd a `logging paramétert `true` értékre.

A nyomtatószál átmérője minden mérési intervallumban naplózásra kerül (alapértelmezés szerint 10 mm).
