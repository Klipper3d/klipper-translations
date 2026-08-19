# Rezonancia Kompenzáció

A Klipper támogatja a bemeneti formázást. Egy olyan technikát, amely a nyomatok csengésének (más néven visszhang, szellemkép vagy hullámzás) csökkentésére használható. A gyűrődés egy felületi nyomtatási hiba, amikor jellemzően az olyan elemek, mint az élek, finom 'visszhangként' ismétlődnek a nyomtatott felületen:

|![Ringing test](img/ringing-test.jpg)|![3D Benchy](img/ringing-3dbenchy.jpg)|

A gyűrődést a nyomtatási irány gyors változása miatt fellépő mechanikus rezgések okozzák. Vedd figyelembe, hogy a gyűrődés általában mechanikai eredetű: nem elég merev nyomtatókeret, nem feszes vagy túlságosan rugós szíjak, a mechanikus alkatrészek beállítási problémái, nagy mozgó tömeg stb. Ezeket kell először ellenőrizni és lehetőség szerint javítani.

A [Bemeneti formázás](https://en.wikipedia.org/wiki/Input_shaping) egy olyan nyílt hurkú vezérlési technika, amely olyan utasító jelet hoz létre, amely megszünteti a saját rezgéseit. A bemeneti alakítás némi hangolást és méréseket igényel, mielőtt engedélyezhető lenne. A csengésen kívül a bemeneti formázás általában csökkenti a nyomtató rezgéseit és rázkódását, és javíthatja a Trinamic léptető meghajtók StealthChop üzemmódjának megbízhatóságát is.

## Hangolás

Az alaphangoláshoz a nyomtató gyűrődési frekvenciájának mérése szükséges egy tesztmodell nyomtatásával.

Szeleteld fel a [docs/prints/ringing_tower.stl](prints/ringing_tower.stl) fájlban található gyűrődési tesztmodellt a szeletelőben:

* A javasolt rétegmagasság 0,2 vagy 0,25 mm.
* A kitöltő és a felső rétegek 0-ra állíthatók.
* Használj 1-2 falat, vagy még jobb a sima váza mód 1-2 mm-es alappal.
* A **külső** kerületeknél használj kellően nagy sebességet, körülbelül 80-100 mm/sec.
* Győződj meg róla, hogy a minimális rétegidő **legfeljebb** 3 másodperc.
* Győződj meg róla, hogy a szeletelőben a "dinamikus gyorsításvezérlés" ki van kapcsolva.
* Ne fordítsd el a modellt. A modell hátulján X és Y jelölések vannak. Figyeld meg a jelek szokatlan elhelyezkedését a nyomtató tengelyeihez képest. Ez nem hiba. A jelölések később a hangolási folyamat során referenciaként használhatók, mert megmutatják, hogy a mérések melyik tengelynek felelnek meg.

### Gyűrődési frekvencia

Először is mérd meg a **gyűrődési frekvenciát**.

1. Ha a `square_corner_velocity` paramétert megváltoztattuk, állítsuk vissza az 5.0-ra. Nem tanácsos növelni, ha bemeneti alakítót használsz, mert ez nagyobb simítást okozhat az alkatrészeken - helyette jobb, ha nagyobb gyorsulási értéket használsz.
1. Kapcsold ki a `minimum_cruise_ratio` funkciót a következő parancs kiadásával: `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. Nyomás előtolás kikapcsolása: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Ha már hozzáadtad az `[input_shaper]` részt a printer.cfg fájlhoz, akkor hajtsd végre a `SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0` parancsot. Ha "Unknown command" hibát kapsz, nyugodtan figyelmen kívül hagyhatod ezen a ponton, és folytathatod a méréseket.
1. Végezd el a parancsot: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5` Alapvetően a gyorsulás különböző nagy értékeinek beállításával próbáljuk a gyűrődést hangsúlyosabbá tenni. Ez a parancs 1500 mm/sec^2-től kezdve 5 mm-enként növeli a gyorsulást: 1500 mm/sec^2, 2000 mm/sec^2, 2500 mm/sec^2 és így tovább, egészen 7000 mm/sec^2-ig az utolsó sávra.
1. Nyomtasd ki a szeletelt tesztmodellt a javasolt paraméterekkel.
1. A nyomtatást korábban is leállíthatod, ha a gyűrődés jól látható, és úgy látod, hogy a gyorsulás túl nagy lesz a nyomtató számára (pl. a nyomtató túlságosan remeg, vagy elkezd lépéseket kihagyni).
1. Használd a modell hátulján található X és Y jeleket a tájékozódáshoz. Az X-jelöléssel ellátott oldalról történő méréseket kell használni az X tengely *konfigurációhoz*, az Y-jelölést pedig az Y tengely konfigurációjához. Mérd meg a távolságot *D* (mm-ben) több rezgés között az X jelzésű alkatrészen, a bevágások közelében, lehetőleg az első egy-két rezgést kihagyva. Az oszcillációk közötti távolság könnyebb méréséhez először jelöld meg az oszcillációkat, majd mérd meg a jelölések közötti távolságot vonalzóval vagy tolómérővel:

   |![Mark ringing](img/ringing-mark.jpg)|![Measure ringing](img/ringing-measure.jpg)|
1. Számold meg, hogy a mért távolság *N* hány rezgésnek *D* felel meg. Ha nem vagy biztos benne, hogy hogyan számold a rezgéseket, nézd meg a fenti képet, ahol *N* = 6 rezgés.
1. Számítsuk ki az X tengely gyűrődési frekvenciáját *V* &middot; *N* / *D* (Hz), ahol *V* a külső kerületekre vonatkozó sebesség (mm/sec). A fenti példánál 6 rezgést jelöltünk meg, és a tesztet 100 mm/sec sebességgel nyomtattuk, így a frekvencia 100 * 6 / 12,14 ≈ 49,4 Hz.
1. A (8)-(10) pontokat az Y jel esetében is végezzük el.

Vedd figyelembe, hogy a próbanyomaton a gyűrődésnek a fenti képen látható íves bevágások mintáját kell követnie. Ha nem így van, akkor ez a hiba nem igazán gyűrődés, és más eredetű. Vagy mechanikai, vagy extruder probléma. Ezt kell először kijavítani, mielőtt engedélyeznénk és hangolnánk a bemeneti formázókat.

Ha a mérések nem megbízhatóak, mert például a rezgések közötti távolság nem stabil, az azt jelentheti, hogy a nyomtatónak több rezonanciafrekvenciája van ugyanazon a tengelyen. Megpróbálhatjuk helyette a [A gyűrődési frekvenciák megbízhatatlan mérései](#a-gyurodesi-frekvenciak-megbizhatatlan-meresei) szakaszban leírt hangolási eljárást követni, és még mindig kaphatunk valami infót a bemeneti alakítási technikáról.

A gyűrődési frekvencia függhet a modell tárgyasztalon belüli helyzetétől és a Z magasságtól, *különösen a delta nyomtatóknál*; ellenőrizheted, hogy a tesztmodell oldalai mentén és különböző magasságokban különböző pozíciókban látsz-e különbséget a frekvenciákban. Ha ez a helyzet, akkor kiszámíthatod az X és Y tengelyen mért átlagos gyűrődési frekvenciákat.

Ha a mért gyűrődési frekvencia nagyon alacsony (kb. 20-25 Hz alatti), akkor érdemes lehet a nyomtató merevítésére vagy a mozgó tömeg csökkentésére beruházni - attól függően, hogy mi alkalmazható a te esetedben -, mielőtt a bemeneti alakítás további hangolását folytatnád, és utána újra megmérnéd a frekvenciákat. Sok népszerű nyomtatómodell esetében gyakran már rendelkezésre áll néhány megoldás.

Vedd figyelembe, hogy a gyűrődési frekvenciák változhatnak, ha a nyomtatóban olyan változtatásokat végzel, amelyek hatással vannak a mozgó tömegre, vagy például megváltoztatod a gépváz merevségét:

* A nyomtatófejre néhány olyan eszközt telepítenek, eltávolítanak vagy kicserélnek, amelyek megváltoztatják annak tömegét, pl. új (nehezebb vagy könnyebb) léptetőmotor a közvetlen extruder-nek vagy új nyomtatófej telepítése, nehéz, tárgyhűtővel ellátott ventilátor beépítése stb.
* A szíjak meghúzása.
* A váz merevségének növelésére szolgáló néhány kiegészítés telepítve van.
* Különböző tárgyasztal van telepítve egy Y tárgyasztalos nyomtatóra, vagy üveg hozzáadása stb.

Ha ilyen változtatásokat hajtotok végre, akkor érdemes legalább a gyűrődési frekvenciákat megmérni, hogy lássátok, változtak-e azok.

### Bemeneti formázó konfigurációja

Az X és Y tengelyek gyűrődési frekvenciájának mérése után a következő szakaszt adhatod hozzá a `printer.cfg` fájlhoz:

```
[input_shaper]
shaper_freq_x: ...  # a tesztmodell X jelének frekvenciája
shaper_freq_y: ...  # a tesztmodell Y jelének frekvenciája
```

A fenti példában a shaper_freq_x/y = 49.4.

### Bemeneti formázó kiválasztása

A Klipper számos bemeneti formázót támogat. Ezek a rezonanciafrekvenciát meghatározó hibákra való érzékenységükben és abban különböznek, hogy milyen mértékű simítást okoznak a nyomtatott alkatrészekben. Emellett néhány shapert, például a 2HUMP_EI és a 3HUMP_EI formázókat általában nem szabad használni shaper_freq = rezonanciafrekvenciával - ezek különböző megfontolásokból vannak beállítva, hogy egyszerre több rezonanciát csökkentsenek.

A legtöbb nyomtatóhoz MZV vagy EI alakítók ajánlhatók. Ez a szakasz egy tesztelési eljárást ír le a kettő közötti választáshoz, valamint néhány egyéb kapcsolódó paraméter meghatározásához.

Nyomtasd ki a gyűrődési tesztmodellt az alábbiak szerint:

1. Indítsd újra a firmware-t: `RESTART`
1. Tesztre való felkészülés: `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. Nyomás előtolás kikapcsolása: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Add ki a parancsot: `SET_INPUT_SHAPER SHAPER_TYPE=MZV `
1. Add ki a parancsot: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`
1. Nyomtasd ki a szeletelt tesztmodellt a javasolt paraméterekkel.

Ha ezen a ponton nem látsz gyűrődést, akkor az MZV formázó használatát lehet javasolni.

Ha mégis gyűrődést észlelsz, mérd meg újra a frekvenciákat a [Gyűrődési frekvencia](#ringing-frequency) szakaszban leírt (8)-(10) lépésekkel. Ha a frekvenciák jelentősen eltérnek a korábban kapott értékektől, akkor összetettebb bemeneti alakító konfigurációra van szükség. Lásd a [Bemeneti alakítók](#input-shapers) szakasz műszaki részleteit. Ellenkező esetben folytasd a következő lépéssel.

Most próbáld ki az EI bemeneti alakítót. Ehhez ismételd meg a fenti (1)-(6) lépéseket, de a 4. lépésnél hajtsd végre a következő parancsot: `SET_INPUT_SHAPER SHAPER_TYPE=EI`.

Két nyomat összehasonlítása MZV és EI bemeneti alakítóval. Ha az EI észrevehetően jobb eredményt mutat, mint az MZV, akkor használd az EI alakítót, egyébként inkább az MZV-t. Vedd figyelembe, hogy az EI shaper több simítást okoz a nyomtatott alkatrészeken (további részletekért lásd a következő szakaszt). Add hozzá a `shaper_type: mzv` (vagy ei) paramétert az [input_shaper] szakaszhoz, pl.:

```
[input_shaper]
shaper_freq_x: ...
shaper_freq_y: ...
shaper_type: mzv
```

Néhány megjegyzés a formázó kiválasztásáról:

* Az EI-formázó alkalmasabb lehet az Y tárgyasztalos nyomtatókhoz (ha a rezonanciafrekvencia és az ebből eredő simítás lehetővé teszi): mivel több szál kerül a mozgó tárgyasztalra, a tárgyasztal tömege nő, és a rezonanciafrekvencia csökken. Mivel az EI shaper robusztusabb a rezonanciafrekvencia-változásokkal szemben, jobban működhet nagy méretű alkatrészek nyomtatásakor.
* A delta kinematika természetéből adódóan a rezonanciafrekvenciák a térfogat különböző részein nagymértékben eltérhetnek. Ezért az EI alakító jobban illeszkedhet a delta nyomtatókhoz, mint az MZV vagy a ZV, és megfontolandó a használata. Ha a rezonanciafrekvencia kellően nagy (50-60 Hz-nél nagyobb), akkor akár meg is próbálkozhatunk a 2HUMP_EI shaper tesztelésével (a fent javasolt teszt futtatásával a `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI`), de ellenőrizd [ebben a szakaszban](#a-max_accel-kivalasztasa) található megfontolásokat, mielőtt engedélyeznéd.

### A max_accel kiválasztása

Az előző lépésben kiválasztott formázóhoz nyomtatott tesztet kell készítened (ha nem nyomtatod ki a [javasolt paraméterekkel](#tuning) felszeletelt tesztmodellt a nyomás előtolás kikapcsolásával `SET_PRESSURE_ADVANCE ADVANCE=0` és a tuningtorony engedélyezésével `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`). Vedd figyelembe, hogy nagyon nagy gyorsulásoknál a rezonanciafrekvenciától és a választott bemeneti alakítótól függően (pl. az EI alakító nagyobb simítást hoz létre, mint az MZV) a bemeneti alakítás túl nagy simítást és az alkatrészek lekerekítését okozhatja. A max_accel értéket tehát úgy kell megválasztani, hogy ezt megakadályozd. Egy másik paraméter, amely hatással lehet a simításra, az `square_corner_velocity`, ezért nem tanácsos az alapértelmezett 5 mm/sec fölé növelni, hogy megakadályozzuk a fokozott simítást.

A megfelelő max_accel érték kiválasztásához vizsgáld meg a kiválasztott bemeneti alakító modelljét. Először is jegyezd meg, hogy melyik gyorsulásnál még kicsi a gyorsulás gyűrődése hogy Neked ez megfeleljen.

Ezután ellenőrizd a simítást. Ennek elősegítése érdekében a tesztmodellben egy kis rés van a falon (0,15 mm):

![Test gap](img/smoothing-test.png)

Ahogy nő a gyorsulás, úgy nő a simítás is, és a tényleges rés a nyomtatásban kiszélesedik:

![Shaper smoothing](img/shaper-smoothing.jpg)

Ezen a képen a gyorsulás balról jobbra növekszik, és a rés 3500 mm/sec^2-től (balról az 5. sáv) kezd nőni. Tehát ebben az esetben a max_accel = 3000 (mm/sec^2) a jó érték, hogy elkerüljük a túlzott simítást.

Figyeld meg a gyorsulást, amikor a rés még mindig nagyon kicsi a próbanyomaton. Ha kidudorodásokat látsz, de a falon egyáltalán nincs rés, még nagy gyorsulásnál is, az a kikapcsolt nyomáselőtolás miatt lehet, különösen a bowdenes extrudereken. Ha ez a helyzet, akkor lehet, hogy meg kell ismételni a nyomtatást engedélyezett PA-val. Ez lehet a rosszul kalibrált (túl magas) nyomtatószál áramlás eredménye is, ezért ezt is érdemes ellenőrizni.

Válaszd ki a két gyorsulási érték közül a legkisebbet (a gyűrődésből és a simításból), és írd be `max_accel` néven a printer.cfg fájlba.

Megjegyzendő, hogy előfordulhat különösen alacsony gyűrődési frekvenciáknál, hogy az EI shaper még kisebb gyorsulásoknál is túl nagy simítást okoz. Ebben az esetben az MZV jobb választás lehet, mert nagyobb gyorsulási értékeket engedhet meg.

Nagyon alacsony gyűrődési frekvenciákon (~25 Hz és az alatt) még az MZV shaper is túl sok simítást hozhat létre. Ha ez a helyzet, akkor megpróbálhatod megismételni a [Bemeneti formázó kiválasztása](#choosing-input-shaper) szakaszban leírt lépéseket ZV shaper-el is, a `SET_INPUT_SHAPER SHAPER_TYPE=ZV` parancs használatával. A ZV shaper-nek még kevesebb simítást kell mutatnia, mint az MZV-nek, de érzékenyebb a gyűrődési frekvenciák mérési hibáira.

Egy másik szempont, hogy ha a rezonanciafrekvencia túl alacsony (20-25 Hz alatt), akkor érdemes lehet növelni a nyomtató vázának merevségét vagy csökkenteni a mozgó tömeget. Ellenkező esetben a gyorsulás és a nyomtatási sebesség korlátozódhat a túl sok simítás miatt most a gyűrődés helyett.

### A rezonanciafrekvenciák finomhangolása

Megjegyzendő, hogy a rezonanciafrekvenciák mérésének pontossága a gyűrődési tesztmodell segítségével a legtöbb célra elegendő, így további hangolás nem javasolt. Ha mégis meg akarod próbálni kétszeresen ellenőrizni az eredményeid (például ha még mindig látsz némi gyűrődést, miután kinyomtattál egy tesztmodellt egy tetszőleges bemeneti alakítóval, ugyanazokkal a frekvenciákkal, mint amiket korábban mértél), akkor kövesd az ebben a szakaszban leírt lépéseket. Vedd figyelembe, hogy ha az [input_shaper] engedélyezése után különböző frekvenciákon látsz gyűrődést, ez a szakasz nem fog segíteni.

Feltételezve, hogy szeletelted a gyűrődési modellt a javasolt paraméterekkel, hajtsd végre a következő lépéseket az X és Y tengelyek mindegyikén:

1. Tesztre való felkészülés: `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. Győződj meg róla, hogy a nyomás előtolás ki van kapcsolva: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Add ki a parancsot: `SET_INPUT_SHAPER SHAPER_TYPE=ZV `
1. A meglévő gyűrődési tesztmodellből a kiválasztott bemeneti alakítóval válaszd ki azt a gyorsulást, amely kellően jól mutatja a gyűrődést, és állítsd be a következővel: `SET_VELOCITY_LIMIT ACCEL=...`
1. Számítsd ki a `TUNING_TOWER` parancshoz szükséges paramétereket a `shaper_freq_x` paraméter hangolásához az alábbiak szerint: Itt a `shaper_freq_x` paraméter a nyomtató aktuális értéke a `printer.cfg` fájlban megadva.
1. Add ki a parancsot: `TUNING_TOWER COMMAND=SET_INPUT_SHAPER PARAMETER=SHAPER_FREQ_X START=start FACTOR=factor BAND=5` a `start` és `factor` értékek felhasználásával, amelyeket az (5.) lépésben számítottunk.
1. Nyomtasd ki a tesztmodellt.
1. Az eredeti frekvenciaérték visszaállítása: `SET_INPUT_SHAPER SHAPER_FREQ_X=...`.
1. Keresd meg azt a sávot, amelyik a legkevésbé gyűrött, és számold meg a számát alulról 1-től kezdve.
1. Az új shaper_freq_x érték kiszámítása a régi shaper_freq_x * (39 + 5 * #band-number) / 66 segítségével.

Ismételd meg ezeket a lépéseket az Y tengelyre ugyanígy, az X tengelyre való hivatkozásokat az Y tengelyre való hivatkozással helyettesítve (pl. cseréld ki a `shaper_freq_x`-t `shaper_freq_y`-ra a képletekben és a `TUNING_TOWER` parancsban).

Példaként tegyük fel, hogy az egyik tengelyen 45 Hz-es gyűrődési frekvenciát mértünk. Ez a start = 45 * 83 / 132 = 28,30 és a faktor = 45 / 66 = 0,6818 értéket ad a `TUNING_TOWER` parancshoz. Most tegyük fel, hogy a tesztmodell kinyomtatása után az alulról számított negyedik sáv adja a legkevesebb gyűrődést. Ekkor a frissített shaper_freq_? érték 45 * (39 + 5 * 4) / 66 ≈ 40,23.

Miután mindkét új `shaper_freq_x` és `shaper_freq_y` paramétert kiszámítottad, frissítheted az `[input_shaper]` szakaszát a nyomtató `printer.cfg` fájljában az új `shaper_freq_x` és `shaper_freq_y` értékekkel.

### Nyomás előtolás

Ha nyomás előtolást használsz, akkor lehet, hogy újra kell hangolni. Kövesd az [utasításokat](Pressure_Advance.md#tuning-pressure-advance) az új érték megtalálásához, ha az eltér az előzőtől. A nyomás előtolás beállítása előtt mindenképpen indítsd újra a Klippert.

### A gyűrődési frekvenciák megbízhatatlan mérései

Ha nem tudod mérni a gyűrődési frekvenciákat, pl. ha a rezgések közötti távolság nem stabil, akkor még mindig kihasználhatod a bemeneti alakítási technikákat, de az eredmények nem biztos, hogy olyan jók lesznek, mint a frekvenciák megfelelő mérésével. Valamint egy kicsit több hangolást és a tesztmodell nyomtatását igényli. Megjegyzendő, hogy egy másik lehetőség egy gyorsulásmérő beszerzése és felszerelése, valamint a rezonanciák mérése (lásd a [dokumentumot](Measuring_Resonances.md), amely leírja a szükséges hardvert és a beállítási folyamatot) - de ez a lehetőség némi kézügyességet, krimpelést és forrasztást igényel.

A hangoláshoz adjunk hozzá üres `[input_shaper]` szakaszt a `printer.cfg` fájlhoz. Ezután, feltételezve, hogy a javasolt paraméterekkel felszeletelt gyűrődési modellt, nyomtasd ki 3-szor az alábbiak szerint. Első alkalommal, a nyomtatás előtt futtasd le a

1. `RESTART`
1. `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. `SET_PRESSURE_ADVANCE ADVANCE=0`
1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=60 SHAPER_FREQ_Y=60`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

és nyomtasd ki a modellt. Ezután nyomtasd ki a modellt újra, de a nyomtatás előtt futtasd az alábbiakat

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=50 SHAPER_FREQ_Y=50`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

Ezután nyomtassuk ki a modellt harmadszorra, de most futtassuk le a következőt

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=40 SHAPER_FREQ_Y=40`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

Lényegében a gyűrődési tesztmodellt TUNING_TOWER segítségével nyomtatjuk ki, 2HUMP_EI shaper-el, shaper_freq = 60 Hz, 50 Hz és 40 Hz.

Ha egyik modell sem mutat javulást a gyűrődésben, akkor sajnos úgy tűnik, hogy a bemeneti alakítási technikák nem segíthetnek a Te esetedben.

Máskülönben előfordulhat, hogy az összes modell nem mutat gyűrődést, vagy néhány modell gyűrődést mutat, néhány pedig nem annyira. Válaszd ki azt a tesztmodellt, amelyik a legmagasabb frekvenciával készült, és még mindig jó javulást mutat a gyűrődések tekintetében. Ha például a 40 Hz-es és az 50 Hz-es modellek szinte egyáltalán nem mutatnak gyűrődést, a 60 Hz-es modell pedig már némileg több gyűrődést mutat, maradj az 50 Hz-esnél.

Most ellenőrizd, hogy az EI alakító elég jó lenne-e az esetedben. Válaszd ki az EI alakító frekvenciáját az általad választott 2HUMP_EI alakító frekvenciája alapján:

* A 2HUMP_EI 60 Hz-es formázó esetében használj EI formázót shaper_freq = 50 Hz-es frekvenciával.
* A 2HUMP_EI 50 Hz-es formázóhoz használj EI formázót shaper_freq = 40 Hz értékkel.
* A 2HUMP_EI 40 Hz-es formázóhoz használj EI formázót shaper_freq = 33 Hz értékkel.

Most nyomtassuk ki a tesztmodellt még egyszer, a következő futtatásával

1. `SET_INPUT_SHAPER SHAPER_TYPE=EI SHAPER_FREQ_X=... SHAPER_FREQ_Y=...`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

a korábban meghatározott shaper_freq_x=... és shaper_freq_y=... értékek megadásával.

Ha az EI alakító a 2HUMP_EI alakítóhoz hasonlóan jó eredményeket mutat, maradj az EI alakító és a korábban meghatározott frekvencia mellett, ellenkező esetben használd a 2HUMP_EI alakítót a megfelelő frekvenciával. Add hozzá az eredményeket a `printer.cfg` fájlhoz, pl. a következő módon.

```
[input_shaper]
shaper_freq_x: 50
shaper_freq_y: 50
shaper_type: 2hump_ei
```

Folytassa a hangolást a [A max_accel kiválasztása](#a-max_accel-kivalasztasa) szakaszban.

## Hibaelhárítás és GYIK

### Nem tudok megbízható méréseket végezni a rezonanciafrekvenciákról

Először is győződj meg róla, hogy a gyűrődés helyett nem más probléma van a nyomtatóval. Ha a mérések nem megbízhatóak, mert például a rezgések közötti távolság nem stabil, az azt jelentheti, hogy a nyomtatónak több rezonanciafrekvenciája van ugyanazon a tengelyen. Megpróbálhatjuk követni a [A gyűrődési frekvenciák megbízhatatlan mérései](#a-gyurodesi-frekvenciak-megbizhatatlan-meresei) szakaszban leírt hangolási eljárást, és még mindig ki lehet hozni valamit a bemeneti alakítási technikából. Egy másik lehetőség egy gyorsulásmérő beszerelése, majd rezonanciák [mérése](Measuring_Resonances.md) vele, és a bemeneti alakító automatikus hangolása e mérések eredményeinek felhasználásával.

### Az [input_shaper] engedélyezése után túlságosan simított nyomtatott alkatrészeket kapok, és a finom részletek elvesznek

Ellenőrizd a [Max_accel kiválasztása](#a-max_accel-kivalasztasa) szakaszban található szempontokat. Ha a rezonanciafrekvencia alacsony, nem szabad túl magas max_accel értéket beállítani, vagy növelni a square_corner_velocity paramétereket. Az is lehet, hogy az EI (vagy a 2HUMP_EI és 3HUMP_EI) változók helyett jobb az MZV vagy akár a ZV bemeneti változókat választani.

### Miután egy ideig sikeresen nyomtatott gyűrődések nélkül, most úgy tűnik, hogy visszajött

Lehetséges, hogy egy idő után a rezonanciafrekvenciák megváltoztak. Pl. talán a szíjak feszessége megváltozott (a szíjak lazábbak lettek) stb. Jó ötlet a [Gyűrődési frekvencia](#ringing-frequency) szakaszban leírtak szerint ellenőrizni és újra megmérni a rezonanciafrekvenciákat, és szükség esetén frissíteni a konfigurációs fájlt.

### Támogatott a kettős kocsi beállítása a bemeneti formázókkal?

Igen. Ebben az esetben minden kocsinál kétszer kell megmérni a rezonanciákat. Például, ha a második (kettős) kocsi az X tengelyre van felszerelve, lehetőség van különböző bemeneti formálók beállítására az X tengelyhez az elsődleges és a kettős kocsihoz. Az Y tengely bemeneti alakítójának azonban mindkét kocsinál azonosnak kell lennie (mivel végső soron ezt a tengelyt egy vagy több léptetőmotor hajtja, amelyek mindegyike pontosan ugyanazokat a lépéseket hajtja végre). Az egyik lehetőség a bemeneti alakító konfigurálására az ilyen beállításokhoz az, hogy az `[input_shaper]' szakaszt üresen hagyja, és a `printer.cfg' fájlban a következőképpen határozzon meg egy `[delayed_gcode]' szakaszt:

```
[input_shaper]
# Szándékosan üres

[delayed_gcode init_shaper]
kezdeti_időtartam: 0.1
gcode:
   SET_DUAL_CARRIAGE CARRIAGE=1
   SET_INPUT_SHAPER SHAPER_TYPE_X=<dual_carriage_shaper> SHAPER_FREQ_X=<dual_carriage_shaper> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
   SET_DUAL_CARRIAGE CARRIAGE=0
   SET_INPUT_SHAPER SHAPER_TYPE_X=<primary_carriage_shaper> SHAPER_FREQ_X=<elsődleges_kocsi_gyakoriság> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
```

However, users of `generic_cartesian` kinematics should specify carriage names in `CARRIAGE=` parameters of `SET_DUAL_CARRIAGE` instead of their numbers. Note that `SHAPER_TYPE_Y` and `SHAPER_FREQ_Y` should be the same in both commands. If you need to configure an input shaper for Z axis, include its parameters in both `SET_INPUT_SHAPER` commands.

Besides `delayed_gcode`, it is also possible to put a similar snippet into the start g-code in the slicer, however then the shaper will not be enabled until any print is started.

Vegye figyelembe, hogy a bemeneti alakítót csak egyszer kell konfigurálni. A kocsik vagy módozataik`SET_DUAL_CARRIAGE`paranccsal történő későbbi módosítása megőrzi a konfigurált bemeneti alakformáló paramétereket.

### Az input_shaper befolyásolja a nyomtatási időt?

Nem, a `input_shaper` funkció önmagában nincs hatással a nyomtatási időre. A `max_accel` értéke azonban bizonyosan befolyásolja (ennek a paraméternek a hangolása [ebben a szakaszban](#a-max_accel-kivalasztasa) le van írva).

### Should I enable and tune input shaper for Z axis?

Most of the users are not likely to see improvements in the quality of the prints directly, much unlike X and Y shapers. However, users of delta printers, printers with flying gantry, or printers with heavy moving beds may be able to increase the `max_z_accel` and `max_z_velocity` kinematics limits and thus get faster Z movements. This can be especially useful e.g. for toolchangers, but also when Z-hops are enabled in slicer. And in general, after enabling Z input shaper many users will hear that Z axis operates more smoothly, which may increase the comfort of printer operation, and may somewhat extend lifespan of Z axis parts.

## Műszaki részletek

### Bemeneti változók

This section contains a brief overview of some technical aspects of the supported input shapers. Input shapers used in Klipper are rather standard, with the exception of MZV, and one can find more in-depth overview in the articles describing the corresponding shapers.

MZV stands for a Modified-ZV input shaper. The classic definition of ZV shaper assumes two pulses and the total duration `t` equal to 1/2 of the damped period of oscillations `Td`. However, it is possible to construct a generalized form of ZV input shaper with `n >= 3` pulses and an arbitrary total duration `t >= 0.5 * Td` (with the maximum of `t` depending on `n` value), see for instance SNA-ZV and MIS-ZV input shapers, which can be seen as special cases of a more generalized implementation of MZV input shaper in Klipper. The default MZV parameters in Klipper are `n=3`, `t=0.75` (of `Td`), and this shaper was designed to serve as an intermediate shaper between ZV and ZVD, offering better vibrations suppression than ZV when the determined (measured) shaper parameters deviate from the ones actually required by the printer, and smaller smoothing than ZVD. Effectively, its specific duration `t=0.75`, exactly between ZV (with `t=0.5` of `Td`) and ZVD (`t=1` of `Td`), and it happens to work well for many real-life 3D printers. However, experienced users can modify the default parameters of the MZV input shaper and try other variations that may work better for their specific printers (with these non-default variations specified as, e.g. `mzv(n=3,t=0.8)` or `mzv(n=5,t=1.1)` in the `[input_shaper]` section or as a parameter to `SET_INPUT_SHAPER` command, as well as in a parameter to `~/klipper/scripts/calibrate_shaper.py` script, e.g. as `--shapers='2hump_ei,3hump_ei,mzv(n=6,t=1.0)'`. These custom parameters of the shapers are supported by `~/klipper/scripts/graph_shaper.py` scripts via e.g. `--shaper='mzv(n=3,t=0.6666666666)'` parameter.

The table below shows some (usually approximate) parameters of each shaper with their default parameters.

| Bemeneti <br> változó | Változó <br> időtartam | Rezonancia csökkentés 20x <br> (5% rezgéstűrés) | Rezonancia csökkentés 10x <br> (10% rezgéstűrés) |
| :-: | :-: | :-: | :-: |
| ZV | 0.5 / shaper_freq | N/A | ± 5% shaper_freq |
| MZV | 0.75 / shaper_freq | ± 4% shaper_freq | -10%...+15% shaper_freq |
| ZVD | 1 / shaper_freq | ± 15% shaper_freq | ± 22% shaper_freq |
| EI | 1 / shaper_freq | ± 20% shaper_freq | ± 25% shaper_freq |
| 2HUMP_EI | 1.5 / shaper_freq | -40...+45% shaper_freq | -45..+50% shaper_freq |
| 3HUMP_EI | 2 / shaper_freq | -50...+60% shaper_freq | -55%...+65% shaper_freq |

A note on vibration reduction: the values in the table above are approximate. If the damping ratio of the printer is known for each axis, the shaper can be configured more precisely and it will then reduce the resonances in a bit wider range of frequencies. However, the damping ratio is usually unknown and is hard to estimate without a special equipment, so Klipper uses 0.1 value by default, which is a good all-round value. The frequency ranges in the table cover a number of different possible damping ratios around that value (approx. from 0.075 to 0.15).

Also note that EI, 2HUMP_EI, and 3HUMP_EI are tuned to reduce vibrations to 5%, so the values for 10% vibration tolerance are provided only for the reference. However, a user can force a desired vibration tolerance for EI input shaper in a manner similar to MZV input shaper as, e.g. `ei(v_tol=0.02)` or `ei(v_tol=0.1)`, in which case the vibration reduction range will be different.

**Hogyan használjuk ezt a táblázatot:**

* A formázó időtartama befolyásolja az alkatrészek simítását - minél nagyobb, annál simábbak az alkatrészek. Ez a függés nem lineáris, de érzékelteti, hogy ugyanazon frekvencia esetén melyik shaper 'simító' simít jobban. A simítás szerinti sorrend így néz ki: ZV < MZV < ZVD ≈ EI < 2HUMP_EI < 3HUMP_EI. Továbbá, a 2HUMP_EI és 3HUMP_EI alakítók esetében ritkán praktikus a shaper_freq = rezonancia frekvencia értéket beállítani (ezeket több frekvencia rezgéseinek csökkentésére kell használni).
* Megbecsülhető az a frekvenciatartomány, amelyben a formázó csökkenti a rezgéseket. Például a shaper_freq = 35 Hz-es MZV a [33,6, 36,4] Hz-es frekvencián 5%-ra csökkenti a rezgéseket. A 3HUMP_EI shaper_freq = 50 Hz esetén a [27,5, 75] Hz tartományban 5%-ra csökkenti a rezgéseket.
* One can use this table to check which shaper they should be using if they need to reduce vibrations at several frequencies. For example, if one has resonances at 35 Hz and 60 Hz on the same axis: a) EI shaper needs to have shaper_freq = 35 / (1 - 0.2) = 43.75 Hz, and it will reduce resonances until 43.75 * (1 + 0.2) = 52.5 Hz, so it is not sufficient; b) 2HUMP_EI shaper needs to have shaper_freq = 35 / (1 - 0.4) = 58.3 Hz and will reduce vibrations until 58.3 * (1 + 0.45) = 84.5 Hz - so this is an acceptable configuration. Always try to use as high shaper_freq as possible for a given shaper (perhaps with some safety margin, so in this example shaper_freq ≈ 55 Hz would work best), and try to use a shaper with as small shaper duration as possible.
* Ha több nagyon különböző frekvencián (mondjuk 30 Hz és 100 Hz) kell csökkenteni a rezgéseket, láthatod, hogy a fenti táblázat nem nyújt elegendő információt. Ebben az esetben több szerencsénk lehet a [scripts/graph_shaper.py](../scripts/graph_shaper.py) szkripttel, amely rugalmasabb.
