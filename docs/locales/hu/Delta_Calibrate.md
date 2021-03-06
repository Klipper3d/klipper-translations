# Delta kalibrálás

Ez a dokumentum a Klipper "delta" stílusú nyomtatók automatikus kalibrációs rendszerét írja le.

A deltakalibrálás magában foglalja a torony végállásának, a torony szögének, a deltasugárnak és a deltakarok hosszának meghatározását. Ezek a beállítások szabályozzák a nyomtató mozgását a delta nyomtatónál. E paraméterek mindegyike nem nyilvánvaló és nem lineáris hatással bír, és manuálisan nehéz kalibrálni őket. Ezzel szemben a szoftver kalibrációs kódja néhány perc ráfordítással kiváló eredményt adhat. Nincs szükség speciális szintező hardverre.

A delta-kalibrálás végső soron a torony végálláskapcsolóinak pontosságától függ. Ha valaki Trinamic léptetőmotor-meghajtókat használ, akkor fontolja meg a [végállási fázis](Endstop_Phase.md) érzékelés engedélyezését, hogy javítsa e kapcsolók pontosságát.

## Automatikus vagy kézi szintezés

A Klipper támogatja a delta paraméterek kalibrálását kézi szintezéssel vagy automatikus Z-szondával.

Számos delta nyomtató készlethez automatikus Z-szondák tartoznak, amelyek nem elég pontosak (különösen a karok hosszának kis különbségei okozhatnak effektor dőlést, ami elferdítheti az automatikus szondát). Ha automatikus szondát használ, akkor először [kalibrálja a szondát](Probe_Calibrate.md), majd ellenőrizze a [szonda helyének torzítását](Probe_Calibrate.md#location-bias-check). Ha az automatikus szonda torzítása több mint 25 mikron (0.025mm), akkor helyette használjon kézi szintezést. A kézi szintezés csak néhány percet vesz igénybe, és kiküszöböli a szonda által okozott hibát.

Ha olyan szondát használ, amely a fűtőberendezés oldalára van szerelve (azaz X vagy Y eltolással rendelkezik), akkor vegye figyelembe, hogy a delta-kalibrálás végrehajtása érvényteleníti a szonda kalibrálásának eredményeit. Az ilyen típusú szondák ritkán alkalmasak a delta használatára (mivel a kisebb effektor dőlés a szonda helyének torzítását eredményezi). Ha mégis használja a szondát, akkor a delta-kalibrálás után mindenképpen végezze el újra a szonda kalibrálását.

## Alapvető delta kalibrálás

A Klipper rendelkezik egy DELTA_CALIBRATE paranccsal, amely alapvető delta-kalibrálást végezhet. Ez a parancs az ágy hét különböző pontját vizsgálja, és új értékeket számol ki a toronyszögek, a toronyvégállások és a delta-sugár számára.

A kalibrálás elvégzéséhez meg kell adni a kiindulási delta paramétereket (karhossz, sugár és végállások), amelyeknek néhány milliméteres pontossággal kell rendelkezniük. A legtöbb delta nyomtató készlet biztosítja ezeket a paramétereket. Konfigurálja a nyomtatót ezekkel a kezdeti alapbeállításokkal, majd futtassa a DELTA_CALIBRATE parancsot az alábbiakban leírtak szerint. Ha nem állnak rendelkezésre alapértelmezett értékek, akkor keressen az interneten egy delta-kalibrálási útmutatót, amely alapvető kiindulópontot adhat.

A delta-kalibrálás során előfordulhat, hogy a nyomtatónak az ágy síkja alatt kell szinteznie, amit egyébként az ágy síkjának tekinthetnénk. Jellemzően ezt a kalibrálás során a konfiguráció frissítésével engedélyezzük a `minimum_z_position=-5` értékkel. (A kalibrálás befejezése után ez a beállítás eltávolítható a konfigurációból.)

A szintezést kétféleképpen lehet elvégezni: kézi szintezés (`DELTA_CALIBRATE METHOD=manual`) és automatikus szintezés (`DELTA_CALIBRATE`). A kézi szintezési módszer a fejet az ágy közelébe mozgatja, majd megvárja, hogy a felhasználó kövesse a ["a papírteszt"](Bed_Level.md#the-paper-test) pontban leírt lépéseket, hogy meghatározza a fúvóka és az ágy közötti tényleges távolságot az adott helyen.

Az alapvető mérés elvégzéséhez győződjön meg arról, hogy a konfigurációban van-e definiálva egy [delta_calibrate] szakasz, majd futtassa az eszközt:

```
G28
DELTA_CALIBRATE METHOD=manual
```

A hét pont szintezése után új delta paraméterek kerülnek kiszámításra. Mentse el és alkalmazza ezeket a paramétereket a következőt futtatva:

```
SAVE_CONFIG
```

Az alapkalibrációnak olyan delta paramétereket kell biztosítania, amelyek elég pontosak az alapvető nyomtatáshoz. Ha ez egy új nyomtató, ez egy jó alkalom néhány alapvető objektum nyomtatására és az általános működés ellenőrzésére.

## Továbbfejlesztett delta kalibrálás

Az alap delta-kalibrálás általában jó munkát végez a delta paraméterek kiszámításában, hogy a fúvóka a megfelelő távolságra legyen az ágytól. Nem próbálja azonban kalibrálni az X és Y dimenzió pontosságát. A méretpontosság ellenőrzésére érdemes egy kibővített delta-kalibrációt elvégezni.

Ehhez a kalibrálási eljáráshoz ki kell nyomtatni egy tesztobjektumot, és a tesztobjektum egyes részeit digitális tolómérővel kell megmérni.

A kibővített delta-kalibrálás futtatása előtt le kell futtatni az alap delta-kalibrálást (a DELTA_CALIBRATE paranccsal) és el kell menteni az eredményeket (a SAVE_CONFIG paranccsal). Győződjön meg róla, hogy a nyomtató konfigurációjában és hardverében nem történt semmilyen jelentős változás az alap delta-kalibrálás legutóbbi végrehajtása óta (ha nem biztos benne, futtassa le újra az [alap delta-kalibrálás](#basic-delta-calibration) parancsot, beleértve a SAVE_CONFIG parancsot is, közvetlenül az alább leírt tesztobjektum nyomtatása előtt.)

Használjon szeletelőt a [docs/prints/calibrate_size.stl](prints/calibrate_size.stl) fájlból G-kód generálásához. Szeletelje az objektumot lassú sebességgel (pl. 40mm/s). Ha lehetséges, használjon merev műanyagot (pl. PLA) a tárgyhoz. A tárgy átmérője 140 mm. Ha ez túl nagy a nyomtató számára, akkor át lehet méretezni (de ügyeljen arra, hogy mind az X, és az Y tengelyt egyenletesen méretezze). Ha a nyomtató jelentősen nagyobb nyomatokat támogat, akkor a tárgy is megnövelhető. A nagyobb méret javíthatja a mérési pontosságot, de a jó tapadás fontosabb, mint a nagyobb nyomtatási méret.

Nyomtassa ki a tesztobjektumot, és várja meg, amíg teljesen kihűl. Az alább leírt parancsokat ugyanazokkal a nyomtatóbeállításokkal kell futtatni, mint amelyekkel a kalibrációs tárgyat nyomtatta (ne futtassa a DELTA_CALIBRATE parancsot a nyomtatás és a mérés között, vagy ne tegyen olyat, ami egyébként megváltoztatná a nyomtató konfigurációját).

Ha lehetséges, az alábbiakban leírt méréseket akkor végezze el, amikor a tárgy még mindig a nyomtatóágyhoz van rögzítve, de ne aggódjon, ha az alkatrész leválik az ágyról. Csak próbálja meg elkerülni a tárgy meghajlását a mérések elvégzésekor.

Kezdje a középső oszlop és az "A" felirat melletti oszlop közötti távolság mérésével (amelynek szintén az "A" torony felé kell mutatnia).

![delta-a-distance](img/delta-a-distance.jpg)

Ezután menjen az óramutató járásával ellentétes irányba, és mérje meg a középső oszlop és a többi oszlop közötti távolságokat (a középsőtől a "C" feliratú oszlopig terjedő távolság, a középsőtől a "B" feliratú oszlopig terjedő távolság stb.).

![delta_cal_e_step1](img/delta_cal_e_step1.png)

Adja meg ezeket a paramétereket a Klipperbe lebegőpontos számok vesszővel elválasztott listájával:

```
DELTA_ANALYZE CENTER_DISTS=<a_dist>,<far_c_dist>,<b_dist>,<far_a_dist>,<c_dist>,<far_b_dist>
```

Az értékeket szóközök nélkül adja meg.

Ezután mérje meg a távolságot az "A" oszlop és a "C" címkével szemben lévő oszlop között.

![delta-ab-distance](img/delta-outer-distance.jpg)

Ezután menjünk az óramutató járásával ellentétes irányba, és mérjük meg a távolságot a "C" oszlop és a "B" oszlop között, majd a "B" oszlop és az "A" oszlop között, és így tovább.

![delta_cal_e_step2](img/delta_cal_e_step2.png)

Adja meg ezeket a paramétereket a Klippernek:

```
DELTA_ANALYZE OUTER_DISTS=<a_to_far_c>,<far_c_to_b>,<b_to_far_a>,<far_a_to_c>,<c_to_far_b>,<far_b_to_a>
```

Ezen a ponton nyugodtan leveheti a tárgyat az ágyról. A végső mérések magukra az oszlopokra vonatkoznak. Mérje meg a középső oszlop méretét az "A" küllők mentén, majd a "B" küllők mentén, végül a "C" küllők mentén.

![delta-a-pillar](img/delta-a-pillar.jpg)

![delta_cal_e_step3](img/delta_cal_e_step3.png)

Adja meg őket a Klippernek:

```
DELTA_ANALYZE CENTER_PILLAR_WIDTHS=<a>,<b>,<c>
```

A végső mérések a külső küllőkről szólnak. Kezdjük azzal, hogy megmérjük az "A" küllő távolságát az "A" küllőtől a "C" küllővel szemben lévő küllőig tartó vonal mentén.

![delta-ab-pillar](img/delta-outer-pillar.jpg)

Ezután az óramutató járásával ellentétes irányban mérjük meg a többi külső oszlopot (a "C" küllővel szemben lévő oszlop a "B" küllővel szembeni vonal mentén, a "B" küllő a "B" küllővel szembeni vonal mentén az "A" küllővel szemben lévő oszlopig stb.).

![delta_cal_e_step4](img/delta_cal_e_step4.png)

És adja meg őket a Klippernek:

```
DELTA_ANALYZE OUTER_PILLAR_WIDTHS=<a>,<far_c>,<b>,<far_a>,<c>,<far_b>
```

Ha az objektumot kisebb vagy nagyobb méretre méretezték, akkor adja meg az objektum szeletelésekor használt méretezési tényezőt:

```
DELTA_ANALYZE SCALE=1.0
```

(A 2,0-ás méretarány azt jelenti, hogy az objektum kétszer akkora, mint az eredeti mérete, 0,5 pedig az eredeti méret fele.)

Végezze el végül a továbbfejlesztett delta-kalibrálást a következő futtatásával:

```
DELTA_ANALYZE CALIBRATE=extended
```

Ez a parancs több percig is eltarthat. A parancs befejezése után kiszámítja a frissített delta paramétereket (delta sugár, toronyszögek, végállások és karok hossza). A SAVE_CONFIG paranccsal mentse el és alkalmazza a beállításokat:

```
SAVE_CONFIG
```

A SAVE_CONFIG parancs mind a frissített delta paramétereket, mind a távolságmérésekből származó információkat elmenti. A jövőbeni DELTA_CALIBRATE parancsok ezeket a távolságinformációkat is felhasználják. A SAVE_CONFIG parancs futtatása után ne próbálja meg újra megadni a nyers távolságméréseket, mivel ez a parancs megváltoztatja a nyomtató konfigurációját, és a nyers mérések már nem érvényesek.

### További megjegyzések

* Ha a delta nyomtató jó méretpontossággal rendelkezik, akkor a két oszlop közötti távolságnak körülbelül 74 mm-nek kell lennie, és minden oszlop szélességének körülbelül 9 mm-nek kell lennie. (Pontosabban, a cél az, hogy a két oszlop közötti távolság mínusz az egyik oszlop szélessége pontosan 65 mm legyen.) Ha az alkatrészben méretpontatlanság van, akkor a DELTA_ANALYZE rutin új delta paramétereket számol ki a távolságmérések és a legutóbbi DELTA_CALIBRATE parancsból származó korábbi magasságmérések felhasználásával.
* A DELTA_ANALYZE meglepő delta paramétereket eredményezhet. Például olyan karhosszúságokat javasolhat, amelyek nem egyeznek a nyomtató tényleges karhosszúságával. Ennek ellenére a tesztek azt mutatták, hogy a DELTA_ANALYZE gyakran jobb eredményeket ad. Úgy véljük, hogy a kiszámított delta paraméterek képesek figyelembe venni a hardver máshol előforduló kisebb hibáit. Például a karhossz kis eltérései az effektor dőlését eredményezhetik, és ennek a dőlésnek egy része a karhossz paraméterek beállításával figyelembe vehető.

## Ágyháló használata a Deltán

Lehetőség van [ágyháló](Bed_Mesh.md) használatára egy delta esetében. Fontos azonban, hogy jó deltakalibrációt érjen el, mielőtt engedélyezné az ágyhálót. A bed mesh futtatása rossz delta-kalibrációval zavaros és rossz eredményeket fog eredményezni.

Vegye figyelembe, hogy a delta-kalibrálás végrehajtása érvényteleníti a korábban kapott ágyhálót. Az új delta-kalibrálás elvégzése után feltétlenül futtassa újra a BED_MESH_CALIBRATE programot.
