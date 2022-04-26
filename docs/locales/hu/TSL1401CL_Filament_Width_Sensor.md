# TSL1401CL nyomtatószál szélesség érzékelő

Ez a dokumentum a nyomtatószál szélesség érzékelő gazdagép modulját írja le. A gazdamodul fejlesztéséhez használt hardver a TSL1401CL lineáris érzékelőtömbön alapul, de bármilyen analóg kimenettel rendelkező érzékelőtömbbel működik. Terveket a [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor) oldalon találja.

Érzékelőtömb nyomtatószál szélesség érzékelőként való használatához olvassa el a [Konfigurációs hivatkozás](Config_Reference.md#tsl1401cl_filament_width_sensor) és a [G-kód dokumentáció](G-Codes.md#hall_filament_width_sensor) részt.

## Hogyan működik?

Az érzékelő analóg kimenetet generál a számított nyomtatószál szélessége alapján. A kimeneti feszültség mindig megegyezik a nyomtatószál érzékelt szélességével (pl. 1,65 V, 1,70 V, 3,0 V). A gazdamodul figyeli a feszültségváltozásokat és beállítja az extrudálási szorzót.

## Jegyzet:

Az érzékelő leolvasása alapértelmezés szerint 10 mm-es időközönként történik. Ha szükséges, szabadon módosíthatja ezt a beállítást a ***MEASUREMENT_INTERVAL_MM*** paraméter szerkesztésével a **filament_width_sensor.py** fájlban.
