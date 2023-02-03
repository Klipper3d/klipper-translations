# Tárgyasztal háló

A tárgyasztal háló modul használható a tárgyasztal felület egyenetlenségeinek kiegyenlítésére, hogy jobb első réteget kapj az egész tárgyasztalon. Meg kell jegyezni, hogy a szoftveralapú korrekció nem fog tökéletes eredményt elérni, csak megközelítő értékekkel tudatja a tárgyasztal alakját. A tárgyasztal háló szintén nem tudja kompenzálni a mechanikai és elektromos problémákat. Ha egy tengely ferde vagy egy szonda nem pontos, akkor a bed_mesh modul nem fog pontos eredményeket kapni a szintezésről.

A hálókalibrálás előtt meg kell győződnöd arról, hogy a szonda Z-eltolása kalibrálva van. Ha végállást használsz a Z-kezdőponthoz, akkor azt is kalibrálni kell. További információkért lásd a [Szonda Kalibrálás](Probe_Calibrate.md) és a Z_ENDSTOP_CALIBRATE című fejezetben a [Kézi Szintezést](Manual_Level.md).

## Alapvető konfiguráció

### Téglalap alakú tárgyasztalok

Ez a példa egy 250 mm x 220 mm-es téglalap alakú tárgyasztalú nyomtatót és egy 24 mm-es x-eltolású és 5 mm-es y-eltolású szondát mutat.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `speed: 120` * Alapértelmezett érték: 50* A sebesség, amellyel a fej a pontok között mozog.
- `horizontal_move_z: 5` *Alapértelmezett érték: 5* A Z koordináta, amelyre a szonda a mérőpontok közötti utazás előtt emelkedik.
- `mesh_min: 35, 6` *Ajánlott* Az első, az origóhoz legközelebbi koordináta. Ez a koordináta a szonda helyéhez képest relatív.
- `mesh_max: 240, 198` *Ajánlott* Az origótól legtávolabb eső mért koordináta. Ez nem feltétlenül az utolsó mért pont, mivel a mérés cikcakkos módon történik. A `mesh_min` koordinátához hasonlóan ez a koordináta is a szonda helyéhez van viszonyítva.
- `probe_count: 5, 3` *Alapértelmezett érték: 3,3* Az egyes tengelyeken mérendő pontok száma, X, Y egész értékben megadva. Ebben a példában az X tengely mentén 5 pont lesz mérve, az Y tengely mentén 3 pont, összesen 15 mért pont. Vedd figyelembe, hogy ha négyzetrácsot szeretnél, például 3x3, akkor ezt egyetlen egész számértékként is megadhatod, amelyet mindkét tengelyre használsz, azaz `probe_count: 3`. Vedd figyelembe, hogy egy hálóhoz mindkét tengely mentén legalább 3 darab mérési számra van szükség.

Az alábbi ábra azt mutatja, hogy a `mesh_min`, `mesh_max` és `probe_count` opciók hogyan használhatók a mérőpontok létrehozására. A nyilak jelzik a mérési eljárás irányát, kezdve a `mesh_min` ponttól. Hivatkozásképpen, amikor a szonda a `mesh_min` pontnál van, a fúvóka a (11, 1) pontnál lesz, és amikor a szonda a `mesh_max` pontnál van, a fúvóka a (206, 193) pontnál lesz.

![bedmesh_rect_basic](img/bedmesh_rect_basic.svg)

### Kerek tárgyasztalok

Ez a példa egy 100 mm-es kerek tárgyasztallal felszerelt nyomtatót feltételez. Ugyanazokat a szondaeltolásokat fogjuk használni, mint a téglalap alakú példánál, 24 mm-t X-en és 5 mm-t Y-on.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius: 75` *Required* A vizsgált háló sugara mm-ben, a `mesh_origin`-hez képest. Vedd figyelembe, hogy a szonda eltolásai korlátozzák a háló sugarának méretét. Ebben a példában a 76-nál nagyobb sugár a szerszámot a nyomtató hatótávolságán kívülre helyezné.
- `mesh_origin: 0, 0` *Alapértelmezett érték: 0, 0* A háló középpontja. Ez a koordináta a szonda helyéhez képest relatív. Bár az alapértelmezett érték 0, 0 hasznos lehet az origó beállítása, ha a tárgyasztal nagyobb részét szeretnéd megmérni. Lásd az alábbi ábrát.
- `round_probe_count: 5` *Alapértelmezett érték: 5* Ez egy egész szám, amely meghatározza az X és Y tengely mentén mért pontok maximális számát. A "maximális" alatt a háló origója mentén mért pontok számát értjük. Ennek az értéknek páratlan számnak kell lennie, mivel a háló középpontját kell megvizsgálni.

Az alábbi ábra mutatja, hogyan generálódnak a mért pontok. Mint látható, a `mesh_origin` (-10, 0) értékre állítása lehetővé teszi, hogy nagyobb, 85-ös hálósugarat adjunk meg.

![bedmesh_round_basic](img/bedmesh_round_basic.svg)

## Speciális konfiguráció

Az alábbiakban részletesen ismertetjük a fejlettebb konfigurációs lehetőségeket. Minden példa a fent bemutatott téglalap alakú alapkonfigurációra épül. A speciális lehetőségek mindegyike ugyanúgy alkalmazható a kerek tárgyasztalokra is.

### Háló interpoláció

Bár a mért mátrixot közvetlenül egyszerű bilineáris interpolációval lehet mintavételezni a mért pontok közötti Z-értékek meghatározásához, a háló sűrűségének növelése érdekében gyakran hasznos a további pontok interpolálása fejlettebb interpolációs algoritmusok segítségével. Ezek az algoritmusok görbületet adnak a hálóhoz, megkísérelve szimulálni a meder anyagi tulajdonságait. A Bed Mesh ehhez Lagrange és bikubik interpolációt kínál.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
mesh_pps: 2, 3
algorithm: bicubic
bicubic_tension: 0.2
```

- `mesh_pps: 2, 3` *Alapértelmezett érték: 2, 2* A `mesh_pps` opció a Hálópontok szegmensenkénti rövidítése. Ez az opció azt adja meg, hogy hány pontot interpoláljon minden egyes szegmenshez az X és Y tengely mentén. Tekintsük egy 'szegmensnek' az egyes mért pontok közötti teret. A `probe_count`-hoz hasonlóan a `mesh_pps` is X, Y egész számpárként adható meg, de megadható egyetlen egész szám is, amely mindkét tengelyre vonatkozik. Ebben a példában 4 szegmens van az X tengely mentén és 2 szegmens az Y tengely mentén. Ez 8 interpolált pontot jelent az X mentén, 6 interpolált pontot az Y mentén, ami egy 13x8-as hálót eredményez. Vedd figyelembe, hogy ha a mesh_pps értéke 0, akkor a hálóinterpoláció le van tiltva, és a mért mátrixot közvetlenül mintavételezi a rendszer.
- `algorithm: lagrange` * Alapértelmezett érték: lagrange* A háló interpolálásához használt algoritmus. Lehet `lagrange` vagy `bicubic`. A Lagrange-interpoláció 6 szondázott pontnál van korlátozva, mivel nagyobb számú minta esetén oszcilláció lép fel. A bikubik interpolációhoz mindkét tengely mentén legalább 4 szondázott pont szükséges, ha 4 pontnál kevesebb van megadva, akkor a Lagrange mintavételezés kikényszerül. Ha a `mesh_pps` 0-ra van állítva, akkor ez az érték figyelmen kívül marad, mivel nem történik hálóinterpoláció.
- `bicubic_tension: 0.2` *Alapértelmezett érték: 0.2* Ha az `algorithm` opció bicubic-ra van állítva, akkor lehet megadni a feszültség értékét. Minél nagyobb a feszültség, annál nagyobb meredekséget interpolál. Legyél óvatos ennek beállításakor, mivel a magasabb értékek több túlhúzást is eredményeznek, ami a mért pontoknál magasabb vagy alacsonyabb interpolált értékeket eredményez.

Az alábbi ábra azt mutatja, hogy a fenti opciókat hogyan használjuk egy interpolált háló létrehozásához.

![bedmesh_interpolated](img/bedmesh_interpolated.svg)

### Mozgás felosztás

A tárgyasztal háló úgy működik, hogy megkapja a G-kód mozgatási parancsokat és transzformációt alkalmaz a Z koordinátájukra. A hosszú mozgásokat kisebb mozgásokra kell bontani, hogy helyesen kövessék a tárgyasztal alakját. Az alábbi opciók a felosztási viselkedést szabályozzák.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
move_check_distance: 5
split_delta_z: .025
```

- `move_check_distance: 5` *Alapértelmezett érték: 5* A minimális távolság, amellyel a kívánt Z-változást ellenőrizni kell a felosztás végrehajtása előtt. Ebben a példában az 5 mm-nél hosszabb mozgást fog az algoritmus végigjárni. Minden 5 mm-enként egy háló Z mérés történik, összehasonlítva azt az előző lépés Z értékével. Ha a delta eléri a `split_delta_z` által beállított küszöbértéket, akkor a mozgás felosztásra kerül, és a bejárás folytatódik. Ez a folyamat addig ismétlődik, amíg a lépés végére nem érünk, ahol egy végső kiigazítás történik. A `move_check_distance` értéknél rövidebb mozgásoknál a helyes Z kiigazítást közvetlenül a mozgásra alkalmazzák, áthaladás vagy felosztás nélkül.
- `split_delta_z: .025` *Alapértelmezett érték: .025* Mint fentebb említettük, ez a minimális eltérés szükséges a mozgás felosztásának elindításához. Ebben a példában bármely Z-érték +/- .025 mm eltérés kiváltja a felosztást.

Általában az alapértelmezett értékek elegendőek ezekhez az opciókhoz, sőt, a `move_check_distance` alapértelmezett 5 mm-es értéke túlzás lehet. Egy haladó felhasználó azonban kísérletezhet ezekkel az opciókkal, hogy megpróbálja kiszorítani az optimális első réteget.

### Háló elhalványulás

Ha a "fade" engedélyezve van, a Z-beállítás a konfiguráció által meghatározott távolságon belül fokozatosan megszűnik. Ez a rétegmagasság kis kiigazításával érhető el, a tárgyasztal alakjától függően növelve vagy csökkentve. Ha a fade befejeződött, a Z-beállítás már nem kerül alkalmazásra, így a nyomtatás teteje sík lesz, nem pedig a tárgyasztal alakját tükrözi. A fakításnak lehetnek nemkívánatos tulajdonságai is, ha túl gyorsan fakít, akkor látható leleteket eredményezhet a nyomaton. Továbbá, ha a tárgyasztal jelentősen megvetemedett, a fade zsugoríthatja vagy megnyújthatja a nyomat Z magasságát. Ezért a fade alapértelmezés szerint ki van kapcsolva.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
fade_start: 1
fade_end: 10
fade_target: 0
```

- `fade_start: 1` *Alapértelmezett érték: 1* A Z magasság, amelyben a fokozatos kiigazítást el kell kezdeni. Jó ötlet, ha a fade folyamat megkezdése előtt néhány réteggel lejjebb kerül.
- `fade_end: 10` *Alapértelmezett érték: 0* A Z magasság, amelyben a fade-nek be kell fejeződnie. Ha ez az érték kisebb, mint `fade_start` akkor a fade le van tiltva. Ezt az értéket a nyomtatási felület torzulásától függően lehet módosítani. Egy jelentősen görbült felületnek hosszabb távon kell elhalványulnia. Egy közel sík felület esetében ez az érték csökkenthető, hogy gyorsabban fakuljon ki. A 10 mm egy ésszerű érték, ha a `fade_start` alapértelmezett 1 értékét használjuk.
- `fade_target: 0` *Alapértelmezett érték: A háló átlagos Z értéke* A `fade_target` úgy képzelhető el, mint egy további Z eltolás, amelyet a fade befejezése után a teljes tárgyasztalra alkalmaznak. Általánosságban azt szeretnénk, ha ez az érték 0 lenne, azonban vannak olyan körülmények, amikor nem kell, hogy így legyen. Tegyük fel például, hogy a tárgyasztalon a kezdőpont pozíciója egy kiugró érték, amely 0,2 mm-rel alacsonyabb, mint a tárgyasztal átlagos mért magassága. Ha a `fade_target` értéke 0, akkor a fade átlagosan 0,2 mm-rel zsugorítja a nyomtatást a tárgyasztalon. Ha a `fade_target` értékét .2-re állítod, akkor a kezdőponti terület .2 mm-rel fog tágulni, azonban a tárgyasztal többi része pontosan méretezett lesz. Általában jó ötlet a `fade_target` elhagyása a konfigurációból, így a háló átlagos magassága kerül felhasználásra, azonban kívánatos lehet a fade target kézi beállítása, ha a tárgyasztal egy adott részére szeretnénk nyomtatni.

### A relatív referenciaindex

A legtöbb szonda hajlamos a driftre, azaz: a hő vagy interferencia által okozott pontatlanságokra. Ez kihívássá teheti a szonda Z-eltolásának kiszámítását, különösen különböző tárgyasztal hőmérsékleteken. Ezért egyes nyomtatók a Z tengely beállításához végállást, a háló kalibrálásához pedig szondát használnak. Ezeknek a nyomtatóknak előnyös lehet a relatív referenciaindex konfigurálása.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
relative_reference_index: 7
```

- `relative_reference_index: 7` *Alapértelmezett érték: Nincs (letiltva)* A mért pontok létrehozásakor mindegyikhez indexet rendelünk. Ezt az indexet a klippy.log fájlban vagy a BED_MESH_OUTPUT segítségével kereshetjük meg (további információkért lásd az alábbi, Bed Mesh GCodes című részt). Ha indexet rendelsz a `relative_reference_index` opcióhoz, akkor az ezen a koordinátán mért érték fogja helyettesíteni a szonda z_offset-ét. Ezáltal ez a koordináta gyakorlatilag a háló "nulla" referenciájává válik.

A relatív referenciaindex használatakor azt az indexet kell válaztatnod, amelyik a legközelebb van ahhoz a ponthoz a tárgyasztalon, ahol a Z végállás kalibrálása történt. Vedd figyelembe, hogy ha az indexet a napló vagy a BED_MESH_OUTPUT segítségével keresed meg, akkor a "Probe" fejléc alatt felsorolt koordinátákat kell használnod a helyes index megtalálásához.

### Hibás régiók

Előfordulhat, hogy a tárgyasztal egyes területei pontatlan eredményeket jeleznek a mérés során, mivel bizonyos helyeken "hiba" van. Erre a legjobb példa a levehető acéllemezek rögzítésére használt integrált mágnesek sorozatával ellátott tárgyasztalok. Ezeknél a mágneseknél és körülöttük lévő mágneses mező hatására az induktív szonda magasabb vagy alacsonyabb távolságban mérhet, mint egyébként tenné, ami azt eredményezi, hogy a háló nem pontosan reprezentálja a felületet ezeken a helyeken. **Figyelem: Ez nem tévesztendő össze a szonda helyének torzításával, amely pontatlan eredményeket eredményez az egész tárgyasztalon.**

A `faulty_region` opciókat úgy lehet beállítani, hogy kompenzálják ezt a hatást. Ha egy generált pont egy hibás régióba esik, akkor a bed mesh megpróbál akár 4 pontot is megvizsgálni a régió határainál. Ezeket a mért értékeket átlagolja és beilleszti a hálóba Z értékben a generált (X, Y) koordinátán.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
faulty_region_1_min: 130.0, 0.0
faulty_region_1_max: 145.0, 40.0
faulty_region_2_min: 225.0, 0.0
faulty_region_2_max: 250.0, 25.0
faulty_region_3_min: 165.0, 95.0
faulty_region_3_max: 205.0, 110.0
faulty_region_4_min: 30.0, 170.0
faulty_region_4_max: 45.0, 210.0
```

- `faulty_region_{1...99}_min` `faulty_region_{1...99}_max` *Alapértelmezett érték: Nincs (letiltva)* A hibás régiók meghatározása hasonlóan történik, mint magának a hálónak a meghatározása, ahol minden egyes régióhoz meg kell adni a minimális és maximális (X, Y) koordinátákat. Egy hibás régió a hálón kívülre is kiterjedhet, azonban a generált váltakozó pontok mindig a háló határán belül lesznek. Két régió nem fedheti egymást.

Az alábbi kép azt szemlélteti, hogyan generálódnak a cserepontok, ha egy generált pont egy hibás területen belül van. Az ábrázolt régiók megegyeznek a fenti mintakonfigurációban szereplő régiókkal. A cserepontok és koordinátáik zöld színnel vannak jelölve.

![bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

## Tárgyasztal háló G-kódok

### Kalibráció

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic] [<probe_parameter>=<value>] [<mesh_parameter>=<value>]` * Alapértelmezett profil: alapértelmezett* *Alapértelmezett módszer: automatikus, ha érzékelőt észlel, egyébként manuális*

Mérési eljárást indítása a tárgyasztal háló kalibrálásához.

A háló a `PROFILE` paraméter által megadott profilba kerül mentésre, vagy `default`, ha nincs megadva. Ha a `METHOD=manual` paramétert választjuk, akkor kézi mérés történik. Az automatikus és a kézi mérés közötti váltáskor a generált hálópontok automatikusan kiigazításra kerülnek.

Lehetőség van hálóparaméterek megadására a mért terület módosítására. A következő paraméterek állnak rendelkezésre:

- Téglalap alakú tárgyasztalok (cartesian):
   - `MESH_MIN`
   - `MESH_MAX`
   - `PROBE_COUNT`
- Kerek tárgyasztalok (delta):
   - `MESH_RADIUS`
   - `MESH_ORIGIN`
   - `ROUND_PROBE_COUNT`
- Minden tárgyasztal:
   - `RELATIVE_REFERNCE_INDEX`
   - `ALGORITHM`

Az egyes paraméterek hálóra való alkalmazásának részleteit lásd a fenti konfigurációs dokumentációban.

### Profilok

`BED_MESH_PROFILE SAVE=<name> LOAD=<name> REMOVE=<name>`

A BED_MESH_CALIBRATE elvégzése után lehetőség van a háló aktuális állapotának elmentésére egy megnevezett profilba. Ez lehetővé teszi a háló betöltését a tárgyasztal újbóli mérése nélkül. Miután egy profilt a `BED_MESH_PROFILE SAVE=<name>` segítségével elmentettünk, a `SAVE_CONFIG` G-kód végrehajtható a profil printer.cfg fájlba való írásához.

A profilok a `BED_MESH_PROFILE LOAD=<name>` parancs végrehajtásával tölthetők be.

Meg kell jegyezni, hogy minden alkalommal, amikor a BED_MESH_CALIBRATE használatba kerül, az aktuális állapot automatikusan az *alapértelmezett* profilba kerül mentésre. Ha ez a profil létezik, akkor a Klipper indításakor automatikusan betöltődik. Ha ez a viselkedés nem kívánatos, a *default* profil a következőképpen távolítható el:

`BED_MESH_PROFILE REMOVE=default`

Bármely más elmentett profil ugyanígy eltávolítható, a *default* helyettesítve az eltávolítani kívánt névvel.

#### Loading the default profile

Previous versions of `bed_mesh` always loaded the profile named *default* on startup if it was present. This behavior has been removed in favor of allowing the user to determine when a profile is loaded. If a user wishes to load the `default` profile it is recommended to add `BED_MESH_PROFILE LOAD=default` to either their `START_PRINT` macro or their slicer's "Start G-Code" configuration, whichever is applicable.

Alternatively the old behavior of loading a profile at startup can be restored with a `[delayed_gcode]`:

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### Kimenet

`BED_MESH_OUTPUT PGP=[0 | 1]`

Az aktuális hálóállapotot adja ki a terminálra. Vegyük észre, hogy maga a háló is kimenetre kerül

A PGP paraméter a "Print Generated Points" rövidítése. Ha `PGP=1` van beállítva, a generált mért pontok a terminálra kerülnek:

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (11.0, 1.0) | (35.0, 6.0)
// 1 | (62.2, 1.0) | (86.2, 6.0)
// 2 | (113.5, 1.0) | (137.5, 6.0)
// 3 | (164.8, 1.0) | (188.8, 6.0)
// 4 | (216.0, 1.0) | (240.0, 6.0)
// 5 | (216.0, 97.0) | (240.0, 102.0)
// 6 | (164.8, 97.0) | (188.8, 102.0)
// 7 | (113.5, 97.0) | (137.5, 102.0)
// 8 | (62.2, 97.0) | (86.2, 102.0)
// 9 | (11.0, 97.0) | (35.0, 102.0)
// 10 | (11.0, 193.0) | (35.0, 198.0)
// 11 | (62.2, 193.0) | (86.2, 198.0)
// 12 | (113.5, 193.0) | (137.5, 198.0)
// 13 | (164.8, 193.0) | (188.8, 198.0)
// 14 | (216.0, 193.0) | (240.0, 198.0)
```

A "Tool Adjusted" pontok az egyes pontok fúvókájának helyére, a "Probe" pontok pedig a szonda helyére utalnak. Vedd figyelembe, hogy kézi mérés esetén a "Probe" pontok mind a szerszám, mind a fúvóka helyére vonatkoznak.

### Tiszta hálós állapot

`BED_MESH_CLEAR`

Ez a G-kód használható a belső háló állapotának törlésére.

### X/Y eltolások alkalmazása

`BED_MESH_OFFSET [X=<value>] [Y=<value>]`

Ez több független extruderrel rendelkező nyomtatóknál hasznos, mivel a szerszámcsere utáni helyes Z-beállításhoz szükség van egy eltolásra. Az eltolásokat az elsődleges extruderhez képest kell megadni. Vagyis pozitív X eltolást kell megadni, ha a másodlagos extruder az elsődleges extrudertől jobbra van felszerelve, és pozitív Y eltolást kell megadni, ha a másodlagos extruder az elsődleges extruder mögött van felszerelve.
