# Tárgyasztal háló

Az ágy háló modul használható az ágyfelület egyenetlenségeinek kiegyenlítésére, hogy jobb első réteget érjen el az egész ágyon. Meg kell jegyezni, hogy a szoftveralapú korrekció nem fog tökéletes eredményt elérni, csak megközelítőleg tudja az ágy alakját. A Bed Mesh szintén nem tudja kompenzálni a mechanikai és elektromos problémákat. Ha egy tengely ferde vagy egy szonda nem pontos, akkor a bed_mesh modul nem fog pontos eredményeket kapni a szondázásból.

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
- `mesh_max: 240, 198` *Ajánlott* Az origótól legtávolabb eső koordináta. Ez nem feltétlenül az utolsó mért pont, mivel a mérés cikcakkos módon történik. A `mesh_min` koordinátához hasonlóan ez a koordináta is a szonda helyéhez képest relatív.
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

Az alábbi ábra mutatja, hogyan generálódnak a szondázott pontok. Amint látható, a `mesh_origin` (-10, 0) értékre állítása lehetővé teszi, hogy nagyobb, 85-ös hálósugarat adjunk meg.

![bedmesh_round_basic](img/bedmesh_round_basic.svg)

## Speciális konfiguráció

Az alábbiakban részletesen ismertetjük a fejlettebb konfigurációs lehetőségeket. Minden példa a fent bemutatott téglalap alakú alapkonfigurációra épül. A speciális lehetőségek mindegyike ugyanúgy alkalmazható a kerek tárgyasztalokra is.

### Háló interpoláció

Míg a szondázott mátrixot közvetlenül egyszerű bilineáris interpolációval lehet mintavételezni a szondázott pontok közötti Z-értékek meghatározásához, a háló sűrűségének növelése érdekében gyakran hasznos további pontokat interpolálni fejlettebb interpolációs algoritmusokkal. Ezek az algoritmusok görbületet adnak a hálóhoz, megkísérelve szimulálni a meder anyagi tulajdonságait. A Bed Mesh ehhez Lagrange- és bikubikus interpolációt kínál.

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
- `fade_target: 0` *Alapértelmezett érték: A háló átlagos Z-értéke* A `fade_target` úgy tekinthető, mint egy további Z-eltolás, amelyet a teljes ágyra alkalmaznak a fade befejezése után. Általánosságban azt szeretnénk, ha ez az érték 0 lenne, azonban vannak olyan körülmények, amikor ez nem kell, hogy így legyen. Tegyük fel például, hogy az ágyon a kezdőpont pozíciója egy kiugró érték, amely 0,2 mm-rel alacsonyabb, mint az ágy átlagos mért magassága. Ha a `fade_target` értéke 0, akkor a fade átlagosan 0,2 mm-rel zsugorítja a nyomtatást az ágyon. Ha a `fade_target` értéket .2-re állítja, a homed terület .2 mm-rel fog tágulni, azonban az ágy többi része pontosan lesz mérve. Általában jó ötlet a `fade_target` elhagyása a konfigurációból, így a háló átlagos magassága kerül felhasználásra, azonban kívánatos lehet a fade target kézi beállítása, ha az ágy egy bizonyos részére szeretnénk nyomtatni.

### A nulla referenciapozíció beállítása

Sok szonda hajlamos a „csúszásra”, azaz: a hő vagy interferencia által okozott pontatlanságokra. Ez kihívássá teheti a szonda Z-eltolásának kiszámítását, különösen különböző ágyhőmérsékleteken. Ezért egyes nyomtatók a Z tengely beállításához végállást, a háló kalibrálásához pedig szondát használnak. Ebben a konfigurációban lehetséges a háló eltolása úgy, hogy az (X, Y) `referenciapozíció` nullpontbeállításra vonatkozik. A `referenciapozíciónak` az ágyon annak a helynek kell lennie, ahol a [Z_ENDSTOP_CALIBRATE](./Manual_Level.md#calibrating-a-z-endstop) papírpróbát végzik. A bed_mesh modul biztosítja a `zero_reference_position` opciót e koordináta megadásához:

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
zero_reference_position: 125, 110
probe_count: 5, 3
```

- `zero_reference_position: ` *Alapértelmezett érték: A `zero_reference_position` egy olyan (X, Y) koordinátát vár el, amely megfelel a fent leírt `reference position` koordinátának. Ha a koordináta a hálóban van, akkor a háló eltolódik, így a referenciapozíció nulla korrekciót alkalmaz. Ha a koordináta a hálón kívül esik, akkor a koordinátát a kalibrálás után meg kell vizsgálni, és az így kapott Z-értéket kell Z-eltolásként használni. Vedd figyelembe, hogy ez a koordináta NEM lehet olyan helyen, amelyet `faulty_region`-ként határoztak meg, ahol mérésre van szükség.

#### Az elavult relative_reference_index

A `relative_reference_index` opciót használó meglévő konfigurációkat frissíteni kell a `zero_reference_position` használatához. A [BED_MESH_OUTPUT PGP=1](#output) G-kód parancsra adott válasz tartalmazza az indexhez tartozó (X, Y) koordinátát; ez a pozíció használható a `zero_reference_position` értékeként. A kimenet az alábbiakhoz hasonlóan fog kinézni:

```
// bed_mesh: generált pontok
// Index | Szerszámbeállítás | Szonda
// 0 | (1.0, 1.0) | (24.0, 6.0)
// 1 | (36.7, 1.0) | (59.7, 6.0)
// 2 | (72.3, 1.0) | (95.3, 6.0)
// 3 | (108.0, 1.0) | (131.0, 6.0)
... (további generált pontok)
// bed_mesh: relative_reference_index 24 is (131.5, 108.0)
```

*Figyelem: A fenti kimenet az inicializálás során a `klippy.log`-ban is megjelenik.*

A fenti példa alapján láthatjuk, hogy a `relative_reference_index` a koordinátával együtt kerül kiírásra. Így a `zero_reference_position` a `131.5, 108`.

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

### Adaptív hálók

Az adaptív ágyrácsozás egy olyan módszer, amely felgyorsítja az ágyrács generálását azáltal, hogy csak az ágynak a nyomtatandó tárgyak által használt területét vizsgálja. Használatakor a módszer automatikusan beállítja a háló paramétereit a meghatározott nyomtatási objektumok által elfoglalt terület alapján.

Az adaptált háló területe az összes meghatározott nyomtatási objektum határai által meghatározott területből kerül kiszámításra, így minden objektumot lefed, beleértve a konfigurációban meghatározott margókat is. A terület kiszámítása után a mérőpontok száma az alapértelmezett hálóterület és az adaptált hálóterület aránya alapján lesz kicsinyítve. Ennek szemléltetésére nézd meg a következő példát:

Egy 150mm x 150mm-es ágy esetében, ahol a "mesh_min" értéke "25,25" és a "mesh_max" értéke "125,125", az alapértelmezett hálóterület egy 100mm x 100mm-es négyzet. Az `50,50` adaptált hálóterület azt jelenti, hogy az adaptált terület és az alapértelmezett hálóterület közötti arány `0,5x0,5`.

Ha a `bed_mesh` konfigurációban a `probe_count` értéke `7x7`, akkor az adaptív ágyháló 4x4 próbapontot fog használni (7 * 0,5 felfelé kerekítve).

![adaptive_bedmesh](img/adaptive_bed_mesh.svg)

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
adaptive_margin: 5
```

- `adaptive_margin` *Alapértelmezett érték: 0* Az ágy meghatározott objektumok által használt területe köré hozzáadandó margó (mm-ben). Az alábbi ábra az adaptív ágy hálóterületét mutatja, ha az `adaptive_margin` értéke 5 mm. Az adaptív hálóterület (zöld színű terület) a használt ágyterület (kék színű terület) és a meghatározott margó összegeként kerül kiszámításra.

   ![adaptive_bedmesh_margin](img/adaptive_bed_mesh_margin.svg)

Az adaptív ágyrácsok természetüknél fogva a nyomtatás alatt álló G-Kód fájlban meghatározott objektumokat használják. Ezért várható, hogy minden egyes G-Kód fájl olyan hálót generál, amely a nyomtatóágy különböző területét vizsgálja. Ezért az adaptív ágyhálót nem szabad újra felhasználni. Az adaptív hálózás használata esetén elvárás, hogy minden egyes nyomtatáshoz új hálót generáljon.

Azt is fontos figyelembe venni, hogy az adaptív ágyhálózást olyan gépeken lehet a legjobban alkalmazni, amelyek általában a teljes ágyat meg tudják tapogatni, és 1 rétegmagasságnál kisebb vagy azzal egyenlő maximális eltérést érnek el. Az olyan mechanikai problémákkal küzdő gépek, amelyeket a teljes ágyháló általában kompenzál, nemkívánatos eredményeket hozhatnak, amikor a nyomtatási mozgásokat a szondázott területen **kívül** próbálják végrehajtani. Ha a teljes ágyháló eltérése nagyobb, mint 1 rétegmagasság, akkor óvatosan kell eljárni, amikor adaptív ágyhálót használunk, és a hálózott területen kívüli nyomtatási mozgásokat kísérelünk meg.

## Felületi mérések

Egyes szondák, mint például az [Örvényáramú szonda](./Eddy_Probe.md), képesek az ágy felületének "letapogatására". Azaz ezek a szondák anélkül képesek háló mintát készíteni, hogy a fejet a minták között felemelnék. A pásztázó üzemmód aktiválásához a `METHOD=scan` vagy `METHOD=rapid_scan` szonda paramétert kell átadni a `BED_MESH_CALIBRATE` G-kód parancsban.

### Mérési magasság

A pásztázási magasságot a `[bed_mesh]-ben a `horizontal_move_z` opció határozza meg. Ezenkívül a `BED_MESH_CALIBRATE` G-kód parancs a `HORIZONTAL_MOVE_Z` paraméteren keresztül is megadható.

A mérési magasságnak kellően alacsonynak kell lennie a beolvasási hibák elkerülése érdekében. Általában 2 mm-es magasság (azaz: `HORIZONTAL_MOVE_Z=2`) jól működik, feltéve, hogy a szonda megfelelően van felszerelve.

Meg kell jegyezni, hogy ha a szonda több mint 4 mm-rel a felszín felett van, akkor az eredmények érvénytelenek lesznek. Így a mérés nem lehetséges olyan ágyaknál, ahol a felület nagymértékben eltérő vagy extrém dőlésszögű, amelyeket nem korrigáltak.

### Gyors (folyamatos) mérés

A `rapid_scan` elvégzésekor szem előtt kell tartani, hogy az eredmények némi hibával fognak rendelkezni. Ennek a hibának elég alacsonynak kell lennie ahhoz, hogy nagy nyomtatási területeken, viszonylag vastag rétegmagassággal hasznos legyen. Egyes szondák hajlamosabbak lehetnek a hibára, mint mások.

Nem ajánlott a gyors üzemmód használata "sűrű" háló beolvasására. A gyors pásztázás során keletkező hiba egy része az érzékelő gauss-zajából származhat, és a sűrű háló ezt a zajt fogja tükrözni (azaz: lesznek csúcsok és völgyek).

Az Ágy háló megpróbálja optimalizálni az útvonalat, hogy a konfiguráció alapján a lehető legjobb eredményt érje el. Ez magában foglalja a hibás régiók elkerülését a minták gyűjtésekor és a háló "túllövését" irányváltáskor. Ez a túllövés javítja a mintavételt a háló széleinél, azonban megköveteli, hogy a hálót úgy konfigurálják, hogy a szerszám a hálón kívülre kerüljön.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5
scan_overshoot: 8
```

- `scan_overshoot` *Alapértelmezett érték: 0 (letiltva)* A hálón kívül rendelkezésre álló maximális elmozdulás (mm-ben). Téglalap alakú ágyak esetén ez az X tengelyen történő mozgásra vonatkozik, kerek ágyak esetén pedig a teljes sugárra. A fejnek képesnek kell lennie a megadott mértékű mozgásra a hálómezőn kívül. Ez az érték a "gyors mérés" végrehajtása során a mozgási útvonal optimalizálására szolgál. A minimálisan megadható érték 1. Az alapértelmezett érték a túllövés hiánya.

Ha nincs beállítva mérési túllövés, akkor az útvonal-optimalizálás nem kerül alkalmazásra az irányváltozásokkor.

## Tárgyasztal háló G-kódok

### Kalibráció

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic | scan | rapid_scan] \ [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] \ [ADAPTIVE_MARGIN=<value>]` *Alapértelmezett profil: alapértelmezett* *Alapértelmezett módszer: automatikus, ha szondát észlel, egyébként manuális* *Alapértelmezett adaptív: 0* *Alapértelmezett adaptív margó: 0*

Mérési eljárást indítása a tárgyasztal háló kalibrálásához.

A háló a `PROFILE` paraméter által megadott profilba lesz mentve, vagy a `default`, ha nincs megadva. A `METHOD` paraméter a következő értékek egyikét veszi fel:

- `METHOD=manual`: lehetővé teszi a kézi mérést a fúvókával és a papírlappal
- `METHOD=automatic`: Automatikus (szabvány) mérés. Ez az alapértelmezett.
- `METHOD=scan`: Engedélyezi a felületi mérést. A fej minden egyes pozíció felett megáll, hogy mérést végezzen.
- `METHOD=rapid_scan`: Engedélyezi a folyamatos felületi mérést.

Az XY pozíciók automatikusan beállítódnak az X és Y eltolások figyelembevételével, ha a `kézi`-től eltérő mérési módszert választunk.

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
   - `MESH_PPS`
   - `ALGORITHM`
   - `ADAPTIVE`
   - `ADAPTIVE_MARGIN`

Az egyes paraméterek hálóra való alkalmazásának részleteit lásd a fenti konfigurációs dokumentációban.

### Profilok

`BED_MESH_PROFILE SAVE=<name> LOAD=<name> REMOVE=<name>`

A BED_MESH_CALIBRATE elvégzése után lehetőség van a háló aktuális állapotának elmentésére egy megnevezett profilba. Ez lehetővé teszi a háló betöltését a tárgyasztal újbóli mérése nélkül. Miután egy profilt a `BED_MESH_PROFILE SAVE=<name>` segítségével elmentettünk, a `SAVE_CONFIG` G-kód végrehajtható a profil printer.cfg fájlba való írásához.

A profilok a `BED_MESH_PROFILE LOAD=<name>` parancs végrehajtásával tölthetők be.

Meg kell jegyezni, hogy minden alkalommal, amikor egy BED_MESH_CALIBRATE történik, az aktuális állapot automatikusan elmentésre kerül az *alapértelmezett* profilba. Az *alapértelmezett* profil a következőképpen távolítható el:

`BED_MESH_PROFILE REMOVE=default`

Bármely más elmentett profil ugyanígy eltávolítható, a *default* helyettesítve az eltávolítani kívánt névvel.

#### Az alapértelmezett profil betöltése

A `bed_mesh` korábbi verziói indításkor mindig betöltötték az *alapértelmezett* nevű profilt, ha az jelen volt. Ezt a viselkedést megszüntettük annak érdekében, hogy a felhasználó határozhassa meg, mikor töltődik be egy profil. Ha a felhasználó az `alapértelmezett` profilt kívánja betölteni, ajánlott a `BED_MESH_PROFILE LOAD=default` hozzáadása a `START_PRINT` makróhoz vagy a szeletelő "Start G-Code" konfigurációjához, attól függően, hogy melyik alkalmazandó.

Alternatívaként a `[delayed_gcode]` segítségével visszaállítható a profil indításkor történő betöltésének régi viselkedése:

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

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value>]`

Ez több független extruderrel rendelkező nyomtatóknál hasznos, mivel a szerszámcsere utáni helyes Z-beállításhoz szükség van egy eltolásra. Az eltolásokat az elsődleges extruderhez képest kell megadni. Vagyis pozitív X eltolást kell megadni, ha a másodlagos extruder az elsődleges extruder jobb oldalán van felszerelve, pozitív Y eltolást kell megadni, ha a másodlagos extruder az elsődleges extruder "mögött" van felszerelve, és pozitív ZFADE eltolást kell megadni, ha a másodlagos extruder fúvókája az elsődleges extruder fúvókája felett van.

Vedd figyelembe, hogy a ZFADE eltolás *NEM* alkalmaz közvetlenül további beállításokat. Ez a `gcode offset` kompenzálására szolgál, amikor a [mesh fade](#mesh-fade) engedélyezve van. Például, ha egy másodlagos extruder magasabb, mint az elsődleges, és negatív G-Kód eltolásra van szüksége, azaz: `SET_GCODE_OFFSET Z=-.2`, azt a `bed_mesh`-ben a `BED_MESH_OFFSET ZFADE=.2`-vel lehet figyelembe venni.

## Ágy háló Webhooks API-k

### Hálóadatok kiürítése

`{"id": 123, "method": "bed_mesh/dump_mesh"}`

Kitölti az aktuális háló és az összes mentett profil konfigurációját és állapotát.

A `dump_mesh` végpontnak egy opcionális paramétere van, a `mesh_args`. Ennek a paraméternek egy objektumnak kell lennie, ahol a kulcsok és az értékek a [BED_MESH_CALIBRATE](#bed_mesh_calibrate) számára elérhető paraméterek. Ez frissíti a háló konfigurációját és a mérési pontokat a megadott paraméterek segítségével, mielőtt visszaküldi az eredményt. A hálóparaméterek elhagyása ajánlott, kivéve, ha a `BED_MESH_CALIBRATE` végrehajtása előtt a mérési pontokat és/vagy a haladási útvonalat kívánod megjeleníteni.

## Vizualizáció és elemzés

A legtöbb felhasználó valószínűleg úgy találja, hogy az olyan alkalmazásokhoz, mint a Mainsail, a Fluidd és az Octoprint mellékelt vizualizátorok elegendőek az alapvető elemzésekhez. A Klipper `scripts` mappája azonban tartalmazza a `graph_mesh.py` szkriptet, amely további vizualizációk és részletesebb elemzések elvégzéséhez használható, különösen hasznos a hardver vagy a `bed_mesh` által előállított eredmények hibakereséséhez:

```
usage: graph_mesh.py [-h] {list,plot,analyze,dump} ...

Ágy háló adatok grafikonja

pozícionális érvek:
  {list,plot,analyze,dump}
    list                Elérhető parcellatípusok listája
    plot                Megadott típus ábrázolása
    analyze             Elemzés elvégzése a hálóadatokon
    dump                API-válasz kiürítése json fájlba

options:
  -h, --help            megjeleníti a súgóüzenetet és kilép
```

### Előfeltételek

A Klipper által biztosított legtöbb grafikus eszközhöz hasonlóan a `graph_mesh.py`-nak is szüksége van a `matplotlib` és a `numpy` python függőségekre. Ezen kívül a Klipper-hez a Moonraker websocketjén keresztül történő csatlakozáshoz a `websockets` python függőségre van szükség. Bár az összes vizualizáció kimenete `svg` fájlban is megjeleníthető, a `graph_mesh.py` által kínált legtöbb vizualizáció jobb, ha élő előnézeti módban, asztali számítógépen nézzük meg. Például a 3D-s megjelenítések előnézeti módban forgathatók és nagyíthatók, az útvonalak megjelenítése pedig opcionálisan animálható előnézeti módban.

### Hálóadatok ábrázolása

A `graph_mesh.py` eszköz többféle vizualizáció készítésére képes. A rendelkezésre álló típusok a `graph_mesh.py list` futtatásával jeleníthetők meg:

```
graph_mesh.py list
points    Eredeti generált pontok ábrázolása
path      Szonda útvonalának megrajzolása
rapid     Gyors mérési útvonal megrajzolása
probedz   Vizsgált Z-értékek ábrázolása
meshz     Háló Z-értékeinek ábrázolása
overlay   Aktuális szondázott hálót egy profillal átfedve ábrázolja
delta     Aktuális szondázott háló és egy profil közötti delta ábrázolása
```

A megjelenítések ábrázolásakor számos lehetőség áll rendelkezésre:

```
usage: graph_mesh.py plot [-h] [-a] [-s] [-p PROFILE_NAME] [-o OUTPUT] <plot type> <input>

pozícionális érvek:
  <plot type>           Grafikusan ábrázolandó adatok típusa
  <input>               A Klipper Socket elérési útvonala/url vagy a json fájl elérési útvonala

opciók:
  -h, --help            megjeleníti a súgóüzenetet és kilép
  -a, --animate         Útvonalak animálása élő előnézetben
  -s, --scale-plot      A Klipper által jelentett tengelyhatárok használata a plot X/Y skálázásához
  -p PROFILE_NAME, --profile-name PROFILE_NAME
                        A 'probedz' számára ábrázolandó profil opcionális neve
  -o OUTPUT, --output OUTPUT
                        Kimeneti fájl elérési útja
```

Az alábbiakban az egyes érvek leírása következik:

- `plot type`: A létrehozandó vizualizáció típusát jelölő kötelező pozicionális argumentum. A `graph_mesh.py list` parancs által kiadott típusok egyikének kell lennie.
- `bemenet`: A bemeneti forrás elérési útvonalát vagy URL-címét tartalmazó, kötelezően megadandó pozicionális argumentum. Ennek az alábbiak egyikének kell lennie:
   - A Klipper Unix Domain Socket elérési útvonala
   - Moonraker egy példányának URL-je
   - A `graph_mesh.py dump <input>` által előállított json fájl elérési útvonala
- `-a`: Az `útvonal` és a `gyors` vizualizációs típusokhoz választható animáció. Az animációk csak az élő előnézetre vonatkoznak.
- `-s`: A Klipper `toolhead` objektuma által a dump fájl létrehozásakor jelentett `axis_minimum` és `axis_maximum` értékek segítségével méretezi a diagramot.
- `-p`: Egy profilnév, amelyet a `probedz` 3D háló vizualizáció generálásakor lehet megadni. Az `overlay` vagy `delta` vizualizáció generálásakor ezt az argumentumot meg kell adni.
- `-o`: Egy opcionális fájl elérési útja, amely jelzi, hogy a szkriptnek a vizualizációt erre a helyre kell mentenie, nem pedig előnézeti módban futtatnia. A képek `svg` formátumban kerülnek mentésre.

Például egy animált gyors útvonal megrajzolásához, a Klipper unix foglalatán keresztül csatlakozva:

```
graph_mesh.py plot -a rapid ~/printer_data/comms/klippy.sock
```

A háló 3D-s vizualizációjának megrajzolásához, a Moonraker segítségével csatlakozva:

```
graph_mesh.py plot meshz http://my-printer.local
```

### Ágy háló elemzés

A `graph_mesh.py` eszköz használható a [bed_mesh/dump_mesh](#dumping-mesh-data) API által szolgáltatott adatok elemzéséhez is:

```
graph_mesh.py analyze <input>
```

A `plot` parancshoz hasonlóan az `<input>` a Klipper unix socketjének elérési útvonala, a Moonraker egy példányának URL címe, vagy a dump parancs által generált json fájl elérési útvonala kell, hogy legyen.

Kezdetben az elemzés különböző ellenőrzéseket végez a `bed_mesh` által a dump idején generált pontokon és mérések útvonalain. Ezek közé tartozik a következő:

- A generált mérési pontok száma, kiegészítések nélkül
- A generált mérési pontok száma, beleértve a hibás területek és a konfigurált nulla referenciapozíció eredményeként generált pontokat is.
- A gyors mérések során generált mérőpontok száma.
- A gyors méréshez generált mozgások teljes száma.
- Annak igazolása, hogy a gyors méréshez generált mérőpontok megegyeznek a szabvány mérési eljáráshoz generált mérőpontokkal.
- A "visszalépés" ellenőrzése mind a szabványos mérőút, mind a gyors mérési útvonal esetében. A visszalépés úgy definiálható, hogy a mérési eljárás során többször is elmozdul ugyanabba a pozícióba. A visszalépés soha nem fordulhat elő normál mérés során. A hibás régiók *visszalépést* eredményezhetnek a gyors mérés során, hogy elkerüljék a hibás régióba való belépést, amikor megközelítik vagy elhagyják a mérési helyet, de soha nem fordulhat elő másként.

Ezután minden, a dump-ban lévő mért háló elemzésre kerül, kezdve a kiíráskor betöltött hálóval (ha van), majd az esetleges mentett profilokkal. A következő adatok kerülnek kinyerésre:

- Háló alakja (min. X,Y, max. X,Y mérésszám)
- Háló Z tartomány, (Minimum Z, Maximum Z)
- Átlagos Z érték a hálóban
- A szabvány Z-értékek szórása a hálóban

A fentieken kívül delta-analízist végeznek az azonos alakú hálók között, amely a következőket jelenti:

- A delta tartománya a hálók között (Minimum és Maximum)
- Az átlagos delta
- A delta szabványos szórása
- Az abszolút maximális különbség
- Az abszolút átlag

### A hálóadatok mentése fájlba

A `dump` paranccsal a válasz menthető egy fájlba, amely megosztható elemzés céljából a hibaelhárítás során:

```
graph_mesh.py dump -o <output file name> <input>
```

A `<input>` a Klipper unix socketjének elérési útja, vagy a Moonraker egy példányának URL-je. A "-o" opció használható a kimeneti fájl elérési útjának megadására. Ha kihagyod, a fájl a munkakönyvtárba kerül mentésre, a következő formátumú fájlnévvel:

`klipper-bedmesh-{year}{month}{day}{hour}{minute}{second}.json`
