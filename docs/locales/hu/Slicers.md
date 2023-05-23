# Szeletelők

Ez a dokumentum néhány tippet ad a Klipperrel használható "szeletelő" alkalmazás konfigurálásához. A Klipperrel együtt használt gyakori szeletelőprogramok a Slic3r, Cura, Simplify3D stb.

## Állítsd be a G-kód ízét Marlinra

Sok szeletelőprogram rendelkezik a "G-kód ízének" konfigurálási lehetőséggel. Az alapértelmezett gyakran a "Marlin", és ez jól működik a Klipperrel. A "Smoothieware" beállítás szintén jól működik a Klipperrel.

## Klipper gcode_macro

A szeletelők gyakran lehetővé teszik a "Start G-kód" és "End G-kód" szekvenciák konfigurálását. Ehelyett gyakran kényelmes egyéni makrókat definiálni a Klipper config fájlban - például: `[gcode_macro START_PRINT]` és `[gcode_macro END_PRINT]`. Ezután csak a START_PRINT és END_PRINT futtatását kell elvégezni a szeletelő konfigurációjában. Ha ezeket a műveleteket a Klipper konfigurációban definiáljuk, könnyebbé válhat a nyomtató indítási és befejezési lépéseinek finomhangolása, mivel a változtatások nem igényelnek újbóli szeletelést.

Lásd a [sample-macros.cfg](../config/sample-macros.cfg) a START_PRINT és END_PRINT makrók példáját.

A gcode_macro definiálásának részleteiért lásd a [konfigurációs hivatkozást](Config_Reference.md#gcode_macro).

## Nagy visszahúzási értékek beállítása szükségessé tehetik a Klipper hangolását

A behúzási mozgások maximális sebességét és gyorsulását a Klipperben a `max_extrude_only_velocity` és `max_extrude_only_accel` konfigurációs beállítások szabályozzák. Ezeknek a beállításoknak van egy alapértelmezett értéke, amely sok nyomtatónál jól fog működni. Ha azonban valaki nagy behúzást állított be a szeletelőben (pl. 5 mm vagy nagyobb), akkor előfordulhat, hogy ezek korlátozzák a kívánt behúzási sebességet.

Ha nagy visszahúzást használsz, fontold meg a Klipper [nyomás előtolás](Pressure_Advance.md) beállítását. Ellenkező esetben, ha úgy találjuk, hogy a nyomtatófej úgy tűnik, hogy "szünetel" a behúzás és az alapozás során, akkor fontold meg a `max_extrude_only_velocity` és `max_extrude_only_accel` kifejezett meghatározását a Klipper konfigurációs fájlban.

## Ne engedélyezd a "coasting-ot"

A "coasting" funkció valószínűleg rossz minőségű nyomatokat eredményez a Klipperrel. Fontold meg helyette a Klipper [pressure advance](Pressure_Advance.md) használatát.

Konkrétan, ha a szeletelő drasztikusan megváltoztatja az extrudálási sebességet a mozgások között, akkor a Klipper lassítást és gyorsítást hajt végre a mozgások között. Ez valószínűleg rontja a blobbingot, nem pedig javítja.

Ezzel szemben a szeletelő "visszahúzás" beállítása, "törlés" beállítása és/vagy "törlés visszahúzáskor" beállítása rendben van (és gyakran hasznos).

## Ne használd az "extra újraindítási távolságot" a Simplify3d-nél

Ez a beállítás drámai változásokat okozhat az extrudálási sebességben, ami kiválthatja a Klipper maximális extrudálási keresztmetszet ellenőrzését. Fontold meg a Klipper [nyomás előtolás](Pressure_Advance.md) vagy a normál Simplify3d visszahúzási beállítás használatát helyette.

## A "PreloadVE" letiltása a KISSlicer-en

Ha a KISSlicer szeletelőszoftvert használod, akkor állítsd a "PreloadVE" értéket nullára. Fontold meg helyette a Klipper [nyomás előtolás](Pressure_Advance.md) használatát.

## Tiltja a "fejlett nyomás előtolás" beállításokat

Néhány szeletelőnek "fejlett nyomás előtolás" képessége van. A Klipper használata esetén ajánlott ezeket az opciókat kikapcsolva tartani, mivel valószínűleg rossz minőségű nyomatokat eredményeznek. Fontold meg ehelyett a Klipper [nyomás előtolás](Pressure_Advance.md) használatát.

Konkrétan ezek a szeletelő beállítások utasíthatják a firmware-t, hogy vad változtatásokat végezzen az extrudálási sebességben, abban a reményben, hogy a firmware közelíteni fogja ezeket a kéréseket, és a nyomtató nagyjából a kívánt extrudernyomást fogja elérni. A Klipper azonban pontos kinematikai számításokat és időzítést használ. Amikor a Klipper parancsot kap az extrudálási sebesség jelentős változtatására, megtervezi a sebesség, a gyorsulás és az extruder mozgásának megfelelő változásait - ami nem a szeletelő szándékában áll. A szeletelő akár túlzott extrudálási sebességet is parancsolhat, olyannyira, hogy az kiváltja a Klipper maximális extrudálási keresztmetszet ellenőrzését.

Ezzel szemben a szeletelő "visszahúzás" beállítása, "törlés" beállítása és/vagy "törlés visszahúzáskor" beállítása rendben van (és gyakran hasznos).

## START_PRINT makrók

START_PRINT makró vagy hasonló makró használata esetén néha hasznos, ha a szeletelőváltozókból paramétereket adunk át a makrónak.

A Cura programban a hőmérsékleteknek való átváltásához a következő start G-kódot kell használni:

```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

A slic3r származékokban, mint például a PrusaSlicer és a SuperSlicer, a következőket kell használni:

START_PRINT EXTRUDER_TEMP=[first_layer_temperature] BED_TEMP=[first_layer_bed_temperature]

Vedd figyelembe azt is, hogy ezek a szeletelők saját fűtési kódokat adnak meg, ha bizonyos feltételek nem teljesülnek. A Curában a `{material_bed_temperature_layer_0}` és a `{material_print_temperature_layer_0}` változók létezése elegendő ennek enyhítésére. A slic3r származékokban a következőket használhatod:

```
M140 S0
M104 S0
```

a makróhívás előtt. Vedd figyelembe, hogy a SuperSlicer rendelkezik egy "egyéni G-kód" gomb opcióval, amely ugyanezt az eredményt éri el.

Egy példát a START_PRINT makróra, amely ezeket a paramétereket használja, az alábbi fájlban találhatsz config/sample-macros.cfg
