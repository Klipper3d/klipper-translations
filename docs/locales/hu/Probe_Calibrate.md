# Szonda kalibrálása

Ez a dokumentum a Klipperben található "automatikus z szonda" X, Y és Z eltolásának kalibrálási módszerét írja le. Ez azon felhasználók számára hasznos, akiknek van egy `[probe]` vagy `[bltouch]` szakasz a konfigurációs fájljukban.

## A szonda X és Y eltolásának kalibrálása

Az X és Y eltolás kalibrálásához navigáljon az OctoPrint "Control" fülre, állítsd be a nyomtatót, majd az OctoPrint léptető gombjaival mozgasd a fejet a tárgyasztal közepéhez közeli pozícióba.

Helyezzen egy darab kék festőszalagot (vagy hasonlót) a tárgyasztalra a szonda alá. Navigáljon az OctoPrint "Terminal" fülre, és adjon ki egy PROBE parancsot:

```
PROBE
```

Helyezzen egy jelet a szalagra közvetlenül a szonda alatt (vagy hasonló módszerrel jegyezze fel a helyet a tárgyasztalon).

Adjon ki egy `GET_POSITION` parancsot, és rögzítse a parancs által jelentett nyomtatófej X-Y pozícióját. Például, ha a következőket látjuk:

```
Recv: // toolhead: X:46.500000 Y:27.000000 Z:15.000000 E:0.000000
```

akkor a szonda X pozíciója 46,5 és Y pozíciója 27.

A szonda pozíciójának rögzítése után adjon ki egy sor G1 parancsot, amíg a fúvóka közvetlenül a tárgyasztalon lévő jelölés fölé nem kerül. Például a következőket:

```
G1 F300 X57 Y30 Z15
```

a fúvóka 57-es X-pozícióba és 30-as Y-pozícióba történő mozgatásához. Ha megtaláltuk a közvetlenül a jelölés feletti pozíciót, a `GET_POSITION` paranccsal jelenthetjük ezt a pozíciót. Ez a fúvóka pozíciója.

Az x_offset ekkor a `nozzle_x_position - probe_x_position` és az y_offset hasonlóan a `nozzle_y_position - probe_y_position`. Frissítse a printer.cfg fájlt a megadott értékekkel, távolítsa el a szalagot/jeleket a tárgyasztalról, majd adjon ki egy `RESTART` parancsot, hogy az új értékek hatályba lépjenek.

## A szonda Z eltolás kalibrálása

A pontos z_offset beállítása kritikus fontos a jó minőségű nyomatok előállításához. A z_offset a fúvóka és a tárgyasztal közötti távolság, amikor a szonda működésbe lép. A Klipper `PROBE_CALIBRATE` eszköz használható ennek az értéknek a meghatározására - ez egy automatikus szondát futtat a szonda Z kioldási pozíciójának mérésére, majd egy kézi szondát indít a fúvóka Z magasságának meghatározására. A szonda z_offset értékét ezután ezekből a mérésekből számítja ki.

Kezd a nyomtató alaphelyzetbe állításával, majd mozgasd a fejet a tárgyasztal közepéhez közeli pozícióba. Navigáljon az OctoPrint terminál fülre, és futtassa a `PROBE_CALIBRATE` parancsot az eszköz indításához.

Ez az eszköz automatikus mérést hajt végre, majd felemeli a fejet, mozgatja a fúvókát a mérőpont helye fölé, és elindítja a kézi mérést. Ha a fúvóka nem mozdul el az automatikus mérőpont feletti pozícióba, akkor `ABORT` a kézi mérőeszközzel, hajtsd végre a fent leírt X-Y szondaeltolás kalibrálását.

Miután a kézi mérő eszköz elindult, kövesse a ["a papírteszt"](Bed_Level.md#the-paper-test)] pontban leírt lépéseket a fúvóka és a tárgyasztal közötti tényleges távolság meghatározásához az adott helyen. Ha ezek a lépések befejeződtek, akkor `ACCEPT` a pozíció és elmentheti az eredményeket a config fájlba a következővel:

```
SAVE_CONFIG
```

Vedd figyelembe, hogy ha a nyomtató mozgásrendszerét, a nyomtatófej pozícióját vagy a szonda helyét megváltoztatja, az érvényteleníti a PROBE_CALIBRATE eredményeit.

Ha a szonda X vagy Y eltolással rendelkezik, és a tárgyasztal dőlése megváltozik (pl. szintezőcsavarok beállításával, DELTA_CALIBRATE futtatásával, Z_TILT_ADJUST futtatásával, QUAD_GANTRY_LEVEL futtatásával vagy hasonlóval), akkor ez érvényteleníti a PROBE_CALIBRATE eredményeit. A fenti beállítások bármelyikének módosítása után újra kell kezdeni a PROBE_CALIBRATE futtatását.

Ha a PROBE_CALIBRATE eredményei érvénytelenek, akkor a szondával kapott korábbi [tárgyasztal háló](Bed_Mesh.md) eredmények is érvénytelenek. A szonda újrakalibrálása után újra kell futtatni a BED_MESH_CALIBRATE programot.

## Ismételt mérési teszt

A szonda X, Y és Z eltolásának kalibrálása után érdemes ellenőrizni, hogy a szonda megismételhető mérési eredményeket szolgáltat-e. Kezd a nyomtató alaphelyzetbe állításával, majd mozgasd a fejet a tárgyasztal közepéhez közeli pozícióba. Navigáljon az OctoPrint terminál fülre, és futtassa a `PROBE_ACCURACY` parancsot.

Ez a parancs tízszer futtatja le a mérést, és az alábbiakhoz hasonló kimenetet ad:

```
Recv: // probe accuracy: at X:0.000 Y:0.000 Z:10.000
Recv: // and read 10 times with speed of 5 mm/s
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe accuracy results: maximum 2.519448, minimum 2.506948, range 0.012500, average 2.513198, median 2.513198, standard deviation 0.006250
```

Ideális esetben az eszköz azonos maximális és minimális értéket mutat. (Vagyis ideális esetben a szonda mind a tíz mérésen azonos eredményt ad.) Azonban normális, hogy a minimális és maximális értékek egy Z "lépésköz" vagy akár 5 mikron (.005 mm) eltéréssel különböznek. A "lépésköz" `rotation_distance/(full_steps_per_rotation*microsteps)`. A minimális és a maximális érték közötti távolságot nevezzük tartománynak. Tehát a fenti példában, mivel a nyomtató 0,0125 Z-lépéstávolságot használ, a 0,01252500 tartományt tekintjük normálisnak.

Ha a teszt eredménye 25 mikronnál (0,025 mm-nél) nagyobb tartományértéket mutat, akkor a szonda nem elég pontos a tipikus szintezési eljárásokhoz. Lehetséges a szonda sebességének és/vagy indulási magasságának hangolása a mérés ismételhetőségének javítása érdekében. A `PROBE_ACCURACY` parancs lehetővé teszi a tesztek futtatását különböző paraméterekkel, hogy lássa a hatásukat. További részletekért lásd a [G-kódok dokumentumot](G-Codes.md#probe_accuracy). Ha a szonda általában egyforma eredményeket ad, de időnként előfordulnak kiugró értékek, akkor ezt úgy lehet kiküszöbölni, hogy minden egyes mérőponton több mérést hajtunk végre. Olvassa el a szonda `samples` konfigurációs paramétereinek leírását a [config hivatkozásban ](Config_Reference.md#probe) további részletekért.

Ha új mérési sebességre, mérésszámra vagy egyéb beállításokra van szükség, akkor frissítse a printer.cfg fájlt, és adjon ki egy `RESTART` parancsot. Ha igen, akkor érdemes újra [kalibrálni a z_offsetet](#calibrating-probe-z-offset). Ha nem kap ismétlődő eredményeket, akkor ne használja a szondát tárgyasztal szintezésére. A Klipper számos kézi mérőeszközzel rendelkezik, amelyek helyette használhatók - további részletekért lásd a [Tárgyasztal szintezése dokumentumot](Bed_Level.md).

## Elhelyezkedés ellenőrzése

Egyes szondák rendszerszintű torzítással rendelkezhetnek, amely bizonyos nyomtatófej helyeken elrontja a mérés eredményeit. Például, ha a szonda tartója az Y tengely mentén történő mozgás közben kissé megdől, akkor ez azt eredményezheti, hogy a szonda különböző Y pozíciókban torz eredményeket ad ki.

Ez egy gyakori probléma a delta nyomtatók szondáinál, de más nyomtatónál is előfordulhat.

A helyeltolódás ellenőrzése a `PROBE_CALIBRATE` parancs segítségével történhet a szonda z_offsetjének mérésével különböző X és Y helyeken. Ideális esetben a szonda z_offset értéke minden pozícióban állandó.

A deltanyomtatók esetében próbáld meg a z_offset mérését az A, a B, és a C torony közelében is. Cartesian, corexy és hasonló nyomtatók esetében próbáld meg a z_offsetet a tárgyasztal négy sarkának közelében lévő pozíciókban mérni.

A vizsgálat megkezdése előtt először kalibrálja a szonda X-, Y- és Z-eltolódását a dokumentum elején leírtak szerint. Ezután állítsd be a nyomtatót, és navigáljon az első X-Y pozícióba. A `PROBE_CALIBRATE` parancs futtatásához kövesse a [calibrating probe Z offset](#calibrating-probe-z-offset) pontban leírt lépéseket, `TESTZ` parancsot, és az `ACCEPT` parancsot, de ne futtassa a `SAVE_CONFIG` parancsot. Figyeljük meg a talált z_offset értéket. Ezután navigáljon a többi X-Y pozícióhoz, ismételje meg ezeket a `PROBE_CALIBRATE` lépéseket, és jegyezze fel a mért z_offsetet.

Ha a minimálisan és a maximálisan jelentett z_offset közötti különbség nagyobb, mint 25 mikron (.025 mm), akkor a szonda nem alkalmas a tipikus tárgyasztal szintezési műveletekre. A kézi mérési alternatívákat lásd az [Tárgyasztal szintezése dokumentumban](Bed_Level.md).

## Hőmérséklet torzítás

Sok szondának van egy rendszerszintű torzítása, amikor különböző hőmérsékleten mérnek. Például a szonda következetesen alacsonyabb magasságban mérhet a magasabb hőmérséklet következtében.

Javasoljuk, hogy a tárgyasztal szintező szerszámokat állandó hőmérsékleten működtesse, hogy figyelembe vegyék ezt a torzítást. Vagy szobahőmérsékleten szintezzen, vagy szintezzen miután a nyomtató elérte a nyomtatási hőmérsékletet. Mindkét esetben érdemes néhány percet várni a kívánt hőmérséklet elérése után, hogy a berendezés folyamatosan a kívánt hőmérsékleten legyen.

A hőmérsékleti torzítás ellenőrzéséhez kezd szobahőmérsékleten, majd állítsd be a nyomtatót. Mozgasd a fejet a tárgyasztal közepéhez közeli pozícióba, és futtassa a `PROBE_ACCURACY` parancsot. Figyelje meg az eredményeket. Ezután a léptetőmotorok kezdőpont felvétele vagy kikapcsolása nélkül melegítse fel a nyomtató fúvókáját és tárgyasztalát nyomtatási hőmérsékletre, és futtassa le ismét a `PROBE_ACCURACY` parancsot. Ideális esetben a parancs azonos eredményeket fog mutatni. A fentiekhez hasonlóan, ha a szondának valóban van hőmérsékleti torzítása, akkor ügyelj arra, hogy mindig egyenletes hőmérsékleten használja méréskor.
