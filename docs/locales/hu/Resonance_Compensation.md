# Rezonancia Kompenzáció

A Klipper támogatja a bemeneti formázást. Egy olyan technikát, amely a nyomatok csengésének (más néven visszhang, szellemkép vagy hullámzás) csökkentésére használható. A gyűrődés egy felületi nyomtatási hiba, amikor jellemzően az olyan elemek, mint az élek, finom 'visszhangként' ismétlődnek a nyomtatott felületen:

|![Ringing test](img/ringing-test.jpg)|![3D Benchy](img/ringing-3dbenchy.jpg)|

A gyűrődést a nyomtatási irány gyors változása miatt fellépő mechanikus rezgések okozzák. Vegye figyelembe, hogy a gyűrődés általában mechanikai eredetű: nem elég merev nyomtatókeret, nem feszes vagy túlságosan rugós szíjak, a mechanikus alkatrészek beállítási problémái, nagy mozgó tömeg stb. Ezeket kell először ellenőrizni és lehetőség szerint javítani.

A [Bemeneti formázás](https://en.wikipedia.org/wiki/Input_shaping) egy olyan nyílt hurkú vezérlési technika, amely olyan utasító jelet hoz létre, amely megszünteti a saját rezgéseit. A bemeneti alakítás némi hangolást és méréseket igényel, mielőtt engedélyezhető lenne. A csengésen kívül a Bemeneti formázás általában csökkenti a nyomtató rezgéseit és rázkódását, és javíthatja a Trinamic léptető meghajtók StealthChop üzemmódjának megbízhatóságát is.

## Hangolás

Az alaphangoláshoz a nyomtató gyűrődési frekvenciájának mérése szükséges egy tesztmodell nyomtatásával.

Szeletelje fel a [docs/prints/ringing_tower.stl](prints/ringing_tower.stl) fájlban található gyűrődési tesztmodellt a szeletelőben:

* A javasolt rétegmagasság 0,2 vagy 0,25 mm.
* A kitöltő és a felső rétegek 0-ra állíthatók.
* Használjon 1-2 falat, vagy még jobb a sima váza mód 1-2 mm-es alappal.
* A **külső** kerületeknél használjon kellően nagy sebességet, körülbelül 80-100 mm/mp.
* Győződjön meg róla, hogy a minimális rétegidő **legfeljebb** 3 másodperc.
* Győződjön meg róla, hogy a szeletelőben a "dinamikus gyorsításvezérlés" ki van kapcsolva.
* Ne fordítsa el a modellt. A modell hátulján X és Y jelölések vannak. Figyelje meg a jelek szokatlan elhelyezkedését a nyomtató tengelyeihez képest. Ez nem hiba. A jelölések később a hangolási folyamat során referenciaként használhatók, mert megmutatják, hogy a mérések melyik tengelynek felelnek meg.

### Gyűrődési frekvencia

Először is mérje meg a **gyűrődési frekvenciát**.

1. Ha a `square_corner_velocity` paramétert megváltoztattuk, állítsuk vissza az 5.0-ra. Nem tanácsos növelni, ha bemeneti alakítót használ, mert ez nagyobb simítást okozhat az alkatrészekben - helyette jobb, ha nagyobb gyorsulási értéket használ.
1. Növelje a `max_accel_to_decel` értéket a következő parancs kiadásával: `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. Nyomásszabályozás kikapcsolása: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Ha már hozzáadta az `[input_shaper]` részt a printer.cfg fájlhoz, akkor hajtsa végre a `SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0` parancsot. Ha "Unknown command" hibát kap, nyugodtan figyelmen kívül hagyhatja ezen a ponton, és folytathatja a méréseket.
1. Végezze el a parancsot: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5` Alapvetően a gyorsulás különböző nagy értékeinek beállításával próbáljuk a gyűrődést hangsúlyosabbá tenni. Ez a parancs 1500 mm/sec^2-től kezdve 5 mm-enként növeli a gyorsulást: 1500 mm/sec^2, 2000 mm/sec^2, 2500 mm/sec^2 és így tovább, egészen 7000 mm/sec^2-ig az utolsó sávra.
1. Nyomtassa ki a szeletelt tesztmodellt a javasolt paraméterekkel.
1. A nyomtatást korábban is leállíthatja, ha a gyűrődés jól látható, és úgy látja, hogy a gyorsulás túl nagy lesz a nyomtató számára (pl. a nyomtató túlságosan remeg, vagy elkezd lépéseket kihagyni).

   1. Használja a modell hátulján található X és Y jeleket a tájékozódáshoz. Az X-jelöléssel ellátott oldalról történő méréseket kell használni az X tengely *konfigurációhoz*, az Y-jelölést pedig az Y tengely konfigurációjához. Mérje meg a távolságot *D* (mm-ben) több rezgés között az X jelzésű alkatrészen, a bevágások közelében, lehetőleg az első egy-két rezgést kihagyva. Az oszcillációk közötti távolság könnyebb méréséhez először jelölje meg az oszcillációkat, majd mérje meg a jelölések közötti távolságot vonalzóval vagy tolómérővel:|![Mark ringing](img/ringing-mark.jpg)|![Measure ringing](img/ringing-measure.jpg)|
1. Számolja meg, hogy a mért távolság *N* hány rezgésnek *D* felel meg. Ha nem biztos benne, hogy hogyan számolja a rezgéseket, nézze meg a fenti képet, ahol *N* = 6 rezgés.
1. Számítsuk ki az X tengely gyűrődési frekvenciáját *V* &middot; *N* / *D* (Hz), ahol *V* a külső kerületekre vonatkozó sebesség (mm/mp). A fenti példánál 6 rezgést jelöltünk meg, és a tesztet 100 mm/mp sebességgel nyomtattuk, így a frekvencia 100 * 6 / 12,14 ≈ 49,4 Hz.
1. A (8)-(10) pontokat az Y jel esetében is végezzük el.

Vegye figyelembe, hogy a próbanyomaton a gyűrődésnek a fenti képen látható íves bevágások mintáját kell követnie. Ha nem így van, akkor ez a hiba nem igazán gyűrődés, és más eredetű. Vagy mechanikai, vagy extruder probléma. Ezt kell először kijavítani, mielőtt engedélyeznénk és hangolnánk a bemeneti formázókat.

Ha a mérések nem megbízhatóak, mert például a rezgések közötti távolság nem stabil, az azt jelentheti, hogy a nyomtatónak több rezonanciafrekvenciája van ugyanazon a tengelyen. Megpróbálhatjuk helyette a [Megbízhatatlan mérések a gyűrődési frekvenciákról](#unreliable-measurements-of-ringing-frequencies) szakaszban leírt hangolási eljárást követni, és még mindig kaphatunk valami infót a bemeneti alakítási technikáról.

A gyűrődési frekvencia függhet a modell ágyon belüli helyzetétől és a Z magasságtól, *különösen a delta nyomtatóknál*; ellenőrizheti, hogy a tesztmodell oldalai mentén és különböző magasságokban különböző pozíciókban lát-e különbséget a frekvenciákban. Ha ez a helyzet, akkor kiszámíthatja az X és Y tengelyen mért átlagos gyűrődési frekvenciákat.

Ha a mért gyűrődési frekvencia nagyon alacsony (kb. 20-25 Hz alatti), akkor érdemes lehet a nyomtató merevítésére vagy a mozgó tömeg csökkentésére beruházni - attól függően, hogy mi alkalmazható az Ön esetében -, mielőtt a bemeneti alakítás további hangolását folytatná, és utána újra megmérné a frekvenciákat. Sok népszerű nyomtatómodell esetében gyakran már rendelkezésre áll néhány megoldás.

Vegye figyelembe, hogy a gyűrődési frekvenciák változhatnak, ha a nyomtatóban olyan változtatásokat végeznek, amelyek hatással vannak a mozgó tömegre, vagy például megváltoztatják a gépváz merevségét:

* A szerszámfejre néhány olyan eszközt telepítenek, eltávolítanak vagy kicserélnek, amelyek megváltoztatják annak tömegét, pl. új (nehezebb vagy könnyebb) léptetőmotor a közvetlen extrudernek vagy új nyomtatófej telepítése, nehéz, tárgyhűtővel ellátott ventilátor beépítése stb.
* A szíjak meghúzása.
* A váz merevségének növelésére szolgáló néhány kiegészítés telepítve van.
* Különböző ágy van telepítve egy Y ágyas nyomtatóra, vagy üveg hozzáadása stb.

Ha ilyen változtatásokat hajtanak végre, akkor érdemes legalább a gyűrődési frekvenciákat megmérni, hogy lássák, változtak-e azok.

### Bemeneti formázó konfigurációja

Az X és Y tengelyek gyűrődési frekvenciájának mérése után a következő szakaszt adhatja hozzá a `printer.cfg` fájlhoz:

```
[input_shaper]
shaper_freq_x: ...  # a tesztmodell X jelének frekvenciája
shaper_freq_y: ...  # a tesztmodell Y jelének frekvenciája
```

A fenti példában a shaper_freq_x/y = 49.4.

### Bemeneti formázó kiválasztása

A Klipper számos bemeneti formázót támogat. Ezek a rezonanciafrekvenciát meghatározó hibákra való érzékenységükben és abban különböznek, hogy milyen mértékű simítást okoznak a nyomtatott alkatrészekben. Emellett néhány shapert, például a 2HUMP_EI és a 3HUMP_EI formázókat általában nem szabad használni shaper_freq = rezonanciafrekvenciával - ezek különböző megfontolásokból vannak beállítva, hogy egyszerre több rezonanciát csökkentsenek.

A legtöbb nyomtatóhoz MZV vagy EI alakítók ajánlhatók. Ez a szakasz egy tesztelési eljárást ír le a kettő közötti választáshoz, valamint néhány egyéb kapcsolódó paraméter meghatározásához.

Nyomtassa ki a gyűrődési tesztmodellt az alábbiak szerint:

1. Indítsa újra a firmware-t: `RESTART`
1. Készüljön fel a tesztre: `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. Nyomásszabályozás kikapcsolása: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Adja ki a parancsot: `SET_INPUT_SHAPER SHAPER_TYPE=MZV `
1. Adja ki a parancsot: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`
1. Nyomtassa ki a szeletelt tesztmodellt a javasolt paraméterekkel.

Ha ezen a ponton nem lát gyűrődést, akkor az MZV formázó használatát lehet javasolni.

Ha mégis gyűrődést észlel, mérje meg újra a frekvenciákat a [Gyűrődési frekvencia](#ringing-frequency) szakaszban leírt (8)-(10) lépésekkel. Ha a frekvenciák jelentősen eltérnek a korábban kapott értékektől, akkor összetettebb bemeneti alakító konfigurációra van szükség. Lásd a [Bemeneti alakítók](#input-shapers) szakasz műszaki részleteit. Ellenkező esetben folytassa a következő lépéssel.

Most próbálja ki az EI bemeneti alakítót. Ehhez ismételje meg a fenti (1)-(6) lépéseket, de a 4. lépésnél hajtsa végre a következő parancsot: `SET_INPUT_SHAPER SHAPER_TYPE=EI`.

Két nyomat összehasonlítása MZV és EI bemeneti alakítóval. Ha az EI észrevehetően jobb eredményt mutat, mint az MZV, akkor használja az EI alakítót, egyébként inkább az MZV-t. Vegye figyelembe, hogy az EI shaper több simítást okoz a nyomtatott alkatrészeken (további részletekért lásd a következő szakaszt). Adja hozzá a `shaper_type: mzv` (vagy ei) paramétert az [input_shaper] szakaszhoz, pl.:

```
[input_shaper]
shaper_freq_x: ...
shaper_freq_y: ...
shaper_type: mzv
```

Néhány megjegyzés a formázó kiválasztásáról:

* Az EI-formázó alkalmasabb lehet az Y ágyas nyomtatókhoz (ha a rezonanciafrekvencia és az ebből eredő simítás lehetővé teszi): mivel több szál kerül a mozgó ágyra, az ágy tömege nő, és a rezonanciafrekvencia csökken. Mivel az EI shaper robusztusabb a rezonanciafrekvencia-változásokkal szemben, jobban működhet nagy méretű alkatrészek nyomtatásakor.
* A delta kinematika természetéből adódóan a rezonanciafrekvenciák a térfogat különböző részein nagymértékben eltérhetnek. Ezért az EI alakító jobban illeszkedhet a delta nyomtatókhoz, mint az MZV vagy a ZV, és megfontolandó a használata. Ha a rezonanciafrekvencia kellően nagy (50-60 Hz-nél nagyobb), akkor akár meg is próbálkozhatunk a 2HUMP_EI shaper tesztelésével (a fent javasolt teszt futtatásával a `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI`), de ellenőrizze a [lenti](#selecting-max_accel) szakaszban található megfontolásokat, mielőtt engedélyezné.

### A max_accel kiválasztása

Az előző lépésben kiválasztott formázóhoz nyomtatott tesztet kell készítenie (ha nem nyomtatja ki a [javasolt paraméterekkel](#tuning) felszeletelt tesztmodellt a nyomásszabályozás kikapcsolásával `SET_PRESSURE_ADVANCE ADVANCE=0` és a tuningtorony engedélyezésével `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`). Vegye figyelembe, hogy nagyon nagy gyorsulásoknál a rezonanciafrekvenciától és a választott bemeneti alakítótól függően (pl. az EI alakító nagyobb simítást hoz létre, mint az MZV) a bemeneti alakítás túl nagy simítást és az alkatrészek lekerekítését okozhatja. A max_accel értéket tehát úgy kell megválasztani, hogy ezt megakadályozza. Egy másik paraméter, amely hatással lehet a simításra, az `square_corner_velocity`, ezért nem tanácsos az alapértelmezett 5 mm/sec fölé növelni, hogy megakadályozzuk a fokozott simítást.

A megfelelő max_accel érték kiválasztásához vizsgálja meg a kiválasztott bemeneti alakító modelljét. Először is jegyezze meg, hogy melyik gyorsulásnál még kicsi a gyorsulás gyűrődése hogy Önnek ez megfeleljen.

Ezután ellenőrizze a simítást. Ennek elősegítése érdekében a tesztmodellben egy kis rés van a falon (0,15 mm):

![Test gap](img/smoothing-test.png)

Ahogy nő a gyorsulás, úgy nő a simítás is, és a tényleges rés a nyomtatásban kiszélesedik:

![Shaper smoothing](img/shaper-smoothing.jpg)

Ezen a képen a gyorsulás balról jobbra növekszik, és a rés 3500 mm/mp^2-től (balról az 5. sáv) kezd nőni. Tehát ebben az esetben a max_accel = 3000 (mm/sec^2) a jó érték, hogy elkerüljük a túlzott simítást.

Figyelje meg a gyorsulást, amikor a rés még mindig nagyon kicsi a próbanyomaton. Ha kidudorodásokat lát, de a falon egyáltalán nincs rés, még nagy gyorsulásnál is, az a kikapcsolt nyomáselőtolás miatt lehet, különösen a bowdenes extrudereken. Ha ez a helyzet, akkor lehet, hogy meg kell ismételni a nyomtatást engedélyezett PA-val. Ez lehet a rosszul kalibrált (túl magas) nyomtatószál áramlás eredménye is, ezért ezt is érdemes ellenőrizni.

Válassza ki a két gyorsulási érték közül a legkisebbet (a gyűrődésből és a simításból), és írja be `max_accel` néven a printer.cfg fájlba.

Megjegyzendő, hogy előfordulhat különösen alacsony gyűrődési frekvenciáknál, hogy az EI shaper még kisebb gyorsulásoknál is túl nagy simítást okoz. Ebben az esetben az MZV jobb választás lehet, mert nagyobb gyorsulási értékeket engedhet meg.

Nagyon alacsony gyűrődési frekvenciákon (~25 Hz és az alatt) még az MZV shaper is túl sok simítást hozhat létre. Ha ez a helyzet, akkor megpróbálhatja megismételni a [Bemeneti formázó kiválasztása](#choosing-input-shaper) szakaszban leírt lépéseket ZV shaper-el is, a `SET_INPUT_SHAPER SHAPER_TYPE=ZV` parancs használatával. A ZV shaper-nek még kevesebb simítást kell mutatnia, mint az MZV-nek, de érzékenyebb a gyűrődési frekvenciák mérési hibáira.

Egy másik szempont, hogy ha a rezonanciafrekvencia túl alacsony (20-25 Hz alatt), akkor érdemes lehet növelni a nyomtató vázának merevségét vagy csökkenteni a mozgó tömeget. Ellenkező esetben a gyorsulás és a nyomtatási sebesség korlátozódhat a túl sok simítás miatt most a gyűrődés helyett.

### A rezonanciafrekvenciák finomhangolása

Megjegyzendő, hogy a rezonanciafrekvenciák mérésének pontossága a gyűrődési tesztmodell segítségével a legtöbb célra elegendő, így további hangolás nem javasolt. Ha mégis meg akarja próbálni kétszeresen ellenőrizni az eredményeit (például ha még mindig lát némi gyűrődést, miután kinyomtatott egy tesztmodellt egy tetszőleges bemeneti alakítóval, ugyanazokkal a frekvenciákkal, mint amiket korábban mért), akkor kövesse az ebben a szakaszban leírt lépéseket. Vegye figyelembe, hogy ha az [input_shaper] engedélyezése után különböző frekvenciákon lát gyűrődést, ez a szakasz nem fog segíteni.

Feltételezve, hogy felszeletelte a gyűrődési modellt a javasolt paraméterekkel, hajtsa végre a következő lépéseket az X és Y tengelyek mindegyikén:

1. Készüljön fel a tesztre: `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. Győződjön meg róla, hogy a Pressure Advance ki van kapcsolva: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Adja ki a parancsot: `SET_INPUT_SHAPER SHAPER_TYPE=ZV `
1. A meglévő gyűrődési tesztmodellből a kiválasztott bemeneti alakítóval válassza ki azt a gyorsulást, amely kellően jól mutatja a gyűrődést, és állítsa be a következővel: `SET_VELOCITY_LIMIT ACCEL=...`
1. Számítsa ki a `TUNING_TOWER` parancshoz szükséges paramétereket a `shaper_freq_x` paraméter hangolásához az alábbiak szerint: Itt a `shaper_freq_x` paraméter a nyomtató aktuális értéke a `printer.cfg` fájlban megadva.
1. Adja ki a parancsot: `TUNING_TOWER COMMAND=SET_INPUT_SHAPER PARAMETER=SHAPER_FREQ_X START=start FACTOR=factor BAND=5` a `start` és `factor` értékek felhasználásával, amelyeket az (5.) lépésben számítottunk.
1. Nyomtassa ki a tesztmodellt.
1. Az eredeti frekvenciaérték visszaállítása: `SET_INPUT_SHAPER SHAPER_FREQ_X=...`.
1. Keresse meg azt a sávot, amelyik a legkevésbé gyűrött, és számolja meg a számát alulról 1-től kezdve.
1. Az új shaper_freq_x érték kiszámítása a régi shaper_freq_x * (39 + 5 * #band-number) / 66 segítségével.

Ismételje meg ezeket a lépéseket az Y tengelyre ugyanígy, az X tengelyre való hivatkozásokat az Y tengelyre való hivatkozással helyettesítve (pl. cserélje ki a `shaper_freq_x`-t `shaper_freq_y`-ra a képletekben és a `TUNING_TOWER` parancsban).

Példaként tegyük fel, hogy az egyik tengelyen 45 Hz-es gyűrődési frekvenciát mértünk. Ez a start = 45 * 83 / 132 = 28,30 és a faktor = 45 / 66 = 0,6818 értéket ad a `TUNING_TOWER` parancshoz. Most tegyük fel, hogy a tesztmodell kinyomtatása után az alulról számított negyedik sáv adja a legkevesebb gyűrődést. Ekkor a frissített shaper_freq_? érték 45 * (39 + 5 * 4) / 66 ≈ 40,23.

Miután mindkét új `shaper_freq_x` és `shaper_freq_y` paramétert kiszámította, frissítheti az `[input_shaper]` szakaszát a nyomtató `printer.cfg` fájljában az új `shaper_freq_x` és `shaper_freq_y` értékekkel.

### Nyomásszabályozás

Ha Pressure Advance-t használ, akkor lehet, hogy újra kell hangolni. Kövesse az [utasításokat](Pressure_Advance.md#tuning-pressure-advance) az új érték megtalálásához, ha az eltér az előzőtől. A Pressure Advance beállítása előtt mindenképpen indítsa újra a Klippert.

### A gyűrődési frekvenciák megbízhatatlan mérései

Ha nem tudja mérni a gyűrődési frekvenciákat, pl. ha a rezgések közötti távolság nem stabil, akkor még mindig kihasználhatja a bemeneti alakítási technikákat, de az eredmények nem biztos, hogy olyan jók lesznek, mint a frekvenciák megfelelő mérésével. Valamint egy kicsit több hangolást és a tesztmodell nyomtatását igényli. Megjegyzendő, hogy egy másik lehetőség egy gyorsulásmérő beszerzése és felszerelése, valamint a rezonanciák mérése (lásd a [dokumentumot](Measuring_Resonances.md), amely leírja a szükséges hardvert és a beállítási folyamatot) - de ez a lehetőség némi kézügyességet, krimpelést és forrasztást igényel.

A hangoláshoz adjunk hozzá üres `[input_shaper]` szakaszt a `printer.cfg` fájlhoz. Ezután, feltételezve, hogy a javasolt paraméterekkel felszeletelte a gyűrődési modellt, nyomtassa ki 3-szor az alábbiak szerint. Első alkalommal, a nyomtatás előtt futtassa le a

1. `RESTART`
1. `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. `SET_PRESSURE_ADVANCE ADVANCE=0`
1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=60 SHAPER_FREQ_Y=60`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

és nyomtassa ki a modellt. Ezután nyomtassa ki a modellt újra, de a nyomtatás előtt futtassa az alábbiakat

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=50 SHAPER_FREQ_Y=50`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

Ezután nyomtassuk ki a modellt harmadszorra, de most futtassuk le a következőt

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=40 SHAPER_FREQ_Y=40`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

Lényegében a gyűrődési tesztmodellt TUNING_TOWER segítségével nyomtatjuk ki, 2HUMP_EI shaperrel, shaper_freq = 60 Hz, 50 Hz és 40 Hz.

Ha egyik modell sem mutat javulást a gyűrődésben, akkor sajnos úgy tűnik, hogy a bemeneti alakítási technikák nem segíthetnek az Ön esetében.

Máskülönben előfordulhat, hogy az összes modell nem mutat gyűrődést, vagy néhány modell gyűrődést mutat, néhány pedig nem annyira. Válassza ki azt a tesztmodellt, amelyik a legmagasabb frekvenciával készült, és még mindig jó javulást mutat a gyűrődések tekintetében. Ha például a 40 Hz-es és az 50 Hz-es modellek szinte egyáltalán nem mutatnak gyűrődést, a 60 Hz-es modell pedig már némileg több gyűrődést mutat, maradjon az 50 Hz-esnél.

Most ellenőrizze, hogy az EI alakító elég jó lenne-e az Ön esetében. Válassza ki az EI alakító frekvenciáját az Ön által választott 2HUMP_EI alakító frekvenciája alapján:

* A 2HUMP_EI 60 Hz-es formázó esetében használjon EI formázót shaper_freq = 50 Hz-es frekvenciával.
* A 2HUMP_EI 50 Hz-es formázóhoz használjon EI formázót shaper_freq = 40 Hz értékkel.
* A 2HUMP_EI 40 Hz-es formázóhoz használjon EI formázót shaper_freq = 33 Hz értékkel.

Most nyomtassuk ki a tesztmodellt még egyszer, a következő futtatásával

1. `SET_INPUT_SHAPER SHAPER_TYPE=EI SHAPER_FREQ_X=... SHAPER_FREQ_Y=...`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

a korábban meghatározott shaper_freq_x=... és shaper_freq_y=... értékek megadásával.

Ha az EI alakító a 2HUMP_EI alakítóhoz hasonlóan jó eredményeket mutat, maradjon az EI alakító és a korábban meghatározott frekvencia mellett, ellenkező esetben használja a 2HUMP_EI alakítót a megfelelő frekvenciával. Adja hozzá az eredményeket a `printer.cfg` fájlhoz, pl. a következő módon.

```
[input_shaper]
shaper_freq_x: 50
shaper_freq_y: 50
shaper_type: 2hump_ei
```

Folytassa a hangolást a [max_accel kiválasztása](#selecting-max_accel) szakaszban.

## Hibaelhárítás és GYIK

### Nem tudok megbízható méréseket végezni a rezonanciafrekvenciákról

Először is győződjön meg róla, hogy a gyűrődés helyett nem más probléma van a nyomtatóval. Ha a mérések nem megbízhatóak, mert például a rezgések közötti távolság nem stabil, az azt jelentheti, hogy a nyomtatónak több rezonanciafrekvenciája van ugyanazon a tengelyen. Megpróbálhatjuk követni a [Megbízhatatlan mérések a gyűrődési frekvenciákról](#unreliable-measurements-of-ringing-frequencies) szakaszban leírt hangolási eljárást, és még mindig ki lehet hozni valamit a bemeneti alakítási technikából. Egy másik lehetőség egy gyorsulásmérő beszerelése, majd rezonanciák [mérése](Measuring_Resonances.md) vele, és a bemeneti alakító automatikus hangolása e mérések eredményeinek felhasználásával.

### Az [input_shaper] engedélyezése után túlságosan simított nyomtatott alkatrészeket kapok, és a finom részletek elvesznek

Ellenőrizze a [Max_accel kiválasztása](#selecting-max_accel) szakaszban található szempontokat. Ha a rezonanciafrekvencia alacsony, nem szabad túl magas max_accel értéket beállítani, vagy növelni a square_corner_velocity paramétereket. Az is lehet, hogy az EI (vagy a 2HUMP_EI és 3HUMP_EI) változók helyett jobb az MZV vagy akár a ZV bemeneti változókat választani.

### Miután egy ideig sikeresen nyomtatott gyűrődések nélkül, most úgy tűnik, hogy visszajött

Lehetséges, hogy egy idő után a rezonanciafrekvenciák megváltoztak. Pl. talán a szíjak feszessége megváltozott (a szíjak lazábbak lettek) stb. Jó ötlet a [Gyűrődési frekvencia](#ringing-frequency) szakaszban leírtak szerint ellenőrizni és újra megmérni a rezonanciafrekvenciákat, és szükség esetén frissíteni a konfigurációs fájlt.

### Támogatott a kettős kocsi beállítása a bemeneti formázókkal?

Nincs külön támogatás a bemeneti formázókkal ellátott kettős kocsikhoz, de ez nem jelenti azt, hogy ez a beállítás nem fog működni. A hangolást kétszer kell lefuttatni mindkét kocsira, és az X- és Y-tengelyek gyűrődési frekvenciáit mindkét kocsira függetlenül kell kiszámítani. Ezután a 0. kocsira vonatkozó értékeket tegye az [input_shaper] szakaszba, és a kocsik váltásakor menet közben változtassa meg az értékeket, például valamilyen makró segítségével:

```
SET_DUAL_CARRIAGE CARRIAGE=1
SET_INPUT_SHAPER SHAPER_FREQ_X=... SHAPER_FREQ_Y=...
```

És ugyanígy a 0 kocsira való visszakapcsoláskor is.

### Az input_shaper befolyásolja a nyomtatási időt?

Nem, a `input_shaper` funkció önmagában nincs hatással a nyomtatási időre. A `max_accel` értéke azonban bizonyosan befolyásolja (ennek a paraméternek a hangolása [ebben a szakaszban](#selecting-max_accel) le van írva).

## Műszaki részletek

### Bemeneti változók

A Klipperben használt bemeneti formázók meglehetősen szabványosak, és részletesebb áttekintést a megfelelő formázókat leíró cikkekben találhatunk. Ez a szakasz a támogatott bemeneti formázók néhány technikai szempontjának rövid áttekintését tartalmazza. Az alábbi táblázat az egyes shaperek néhány (általában hozzávetőleges) paraméterét mutatja.

| Bemeneti <br> változó | Változó <br> időtartam | Rezonancia csökkentés 20x <br> (5% rezgéstűrés) | Rezonancia csökkentés 10x <br> (10% rezgéstűrés) |
| :-: | :-: | :-: | :-: |
| ZV | 0.5 / shaper_freq | N/A | ± 5% shaper_freq |
| MZV | 0.75 / shaper_freq | ± 4% shaper_freq | -10%...+15% shaper_freq |
| ZVD | 1 / shaper_freq | ± 15% shaper_freq | ± 22% shaper_freq |
| EI | 1 / shaper_freq | ± 20% shaper_freq | ± 25% shaper_freq |
| 2HUMP_EI | 1.5 / shaper_freq | ± 35% shaper_freq | ± 40 shaper_freq |
| 3HUMP_EI | 2 / shaper_freq | -45...+50% shaper_freq | -50%...+55% shaper_freq |

Megjegyzés a rezonancia csökkentéssel kapcsolatban: a fenti táblázatban szereplő értékek hozzávetőlegesek. Ha a nyomtató csillapítási aránya minden egyes tengely esetében ismert, akkor a formázó pontosabban konfigurálható, és ekkor a rezonanciákat egy kicsit szélesebb frekvenciatartományban csökkenti. A csillapítási arány azonban általában ismeretlen, és speciális berendezés nélkül nehéz megbecsülni, ezért a Klipper alapértelmezés szerint 0,1 értéket használ, ami egy jó általános érték. A táblázatban szereplő frekvenciatartományok számos különböző lehetséges csillapítási arányt fednek le ezen érték körül (kb. 0,05-től 0,2-ig).

Vegye figyelembe azt is, hogy az EI, 2HUMP_EI és 3HUMP_EI úgy van beállítva, hogy a rezonanciákat 5%-ra csökkentse, ezért a 10%-os rezonanciára vonatkozó értékek csak referenciaként szolgálnak.

**Hogyan használjuk ezt a táblázatot:**

* A formázó időtartama befolyásolja az alkatrészek simítását - minél nagyobb, annál simábbak az alkatrészek. Ez a függőség nem lineáris, de érzékelteti, hogy ugyanazon frekvencia esetén melyik shaper 'simító' simít jobban. A simítás szerinti sorrend így néz ki: ZV < MZV < ZVD ≈ EI < 2HUMP_EI < 3HUMP_EI. Továbbá, a 2HUMP_EI és 3HUMP_EI alakítók esetében ritkán praktikus a shaper_freq = rezonancia frekvencia értéket beállítani (ezeket több frekvencia rezgéseinek csökkentésére kell használni).
* Megbecsülhető az a frekvenciatartomány, amelyben a formázó csökkenti a rezgéseket. Például a shaper_freq = 35 Hz-es MZV a [33,6, 36,4] Hz-es frekvencián 5%-ra csökkenti a rezgéseket. A 3HUMP_EI shaper_freq = 50 Hz esetén a [27,5, 75] Hz tartományban 5%-ra csökkenti a rezgéseket.
* A táblázat segítségével ellenőrizheti, hogy melyik változót kell használnia, ha több frekvencián kell csökkentenie a rezgéseket. Például, ha ugyanazon a tengelyen 35 Hz-es és 60 Hz-es rezonanciák vannak: a) az EI alakítónak a shaper_freq = 35 / (1 - 0,2) = 43,75 Hz-re van szüksége, és 43,75 * (1 + 0,2) = 52-ig csökkenti a rezonanciákat tehát az 52.5 Hz, nem elegendő. b) a 2HUMP_EI alakítónak shaper_freq = 35 / (1 - 0,35) = 53,85 Hz-nek kell lennie, és 53,85 * (1 + 0,35) = 72,7 Hz-ig csökkenti a rezgéseket - tehát ez egy elfogadható konfiguráció. Mindig próbáljon meg minél magasabb shaper_freq értéket használni egy adott shaper-hez (esetleg némi biztonsági tartalékkal, így ebben a példában a shaper_freq ≈ 50-52 Hz lenne a legjobb), és próbáljon meg minél kisebb shaper időtartamú értéket használni.
* Ha valakinek több nagyon különböző frekvencián (mondjuk 30 Hz és 100 Hz) kell csökkentenie a rezgéseket, láthatja, hogy a fenti táblázat nem nyújt elegendő információt. Ebben az esetben több szerencsénk lehet a [scripts/graph_shaper.py](../scripts/graph_shaper.py) szkripttel, amely rugalmasabb.
