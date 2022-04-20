# Ágyszintezés

Az ágyszintezés (néha más néven "bed tramming") kritikus fontosságú a jó minőségű nyomatok előállításához. Ha az ágy nem megfelelően van "szintezve", az rossz tapadáshoz, "vetemedéshez" és finom problémákhoz vezethet a nyomtatás során. Ez a dokumentum útmutatóként szolgál az ágyszintzés Klipperben történő elvégzéséhez.

Fontos megérteni az ágy szintezésének célját. Ha a nyomtatót egy `X0 Y0 Z10` pozícióba irányítjuk a nyomtatás során, akkor a cél az, hogy a nyomtató fúvókája pontosan 10 mm-re legyen a nyomtató ágyától. Továbbá, ha a nyomtatót ezután a `X50 Z10` pozícióba irányítjuk, a cél az, hogy a fúvóka pontosan 10 mm távolságot tartson az ágytól a teljes vízszintes mozgás során.

A jó minőségű nyomatok érdekében a nyomtatót úgy kell kalibrálni, hogy a Z távolságok körülbelül 25 mikron (.025 mm) pontosságúak legyenek. Ez egy kis távolság - lényegesen kisebb, mint egy átlagos emberi hajszál szélessége. Ez a méretarány nem mérhető "szemmel". Finom hatások (mint például a hőtágulás) befolyásolják az ilyen skálán végzett méréseket. A nagy pontosság elérésének titka az ismételhető folyamat és a nyomtató saját mozgásrendszerének nagy pontosságát kihasználó szintezési módszer alkalmazása.

## Válassza ki a megfelelő kalibrációs mechanizmust

A különböző típusú nyomtatók különböző módszereket használnak az ágyszintezés elvégzésére. Ezek mindegyike végső soron a "papírteszt" (lásd alább) függvénye. Az adott nyomtatótípusra vonatkozó tényleges eljárást azonban más dokumentumok írják le.

A kalibrációs eszközök futtatása előtt feltétlenül futtassa le a [config check dokumentumban](Config_checks.md) leírt ellenőrzéseket. A nyomtató alapvető mozgásának ellenőrzése szükséges az ágyszintezés elvégzése előtt.

A "automatikus Z-szondával" rendelkező nyomtatók esetében a szondát mindenképpen kalibrálja a [Probe Calibrate](Probe_Calibrate.md) dokumentumban található utasítások szerint. Delta nyomtatók esetében lásd a [Delta Calibrate](Delta_Calibrate.md) dokumentumot. Szintezőcsavarokkal és hagyományos Z végállással rendelkező nyomtatók esetében lásd a [Manual Level](Manual_Level.md) dokumentumot.

A kalibrálás során szükség lehet arra, hogy a nyomtató Z `position_min` értékét negatív számra állítsa be (pl. `position_min = -2`). A nyomtató a kalibrációs rutinok során is végrehajtja a határérték-ellenőrzést. A negatív szám beállítása lehetővé teszi, hogy a nyomtató az ágy névleges pozíciója alá mozogjon, ami segíthet az ágy tényleges pozíciójának meghatározásakor.

## A "papírteszt"

Az elsődleges ágyszintezési mechanizmus a "papírteszt". Ennek során egy normál "fénymásolópapírt" helyezünk a nyomtató ágya és a fúvóka közé, majd a fúvókát különböző Z magasságba állítjuk, amíg a papír előre-hátra tolása közben egy kis súrlódást nem érzünk.

Fontos megérteni a "papírtesztet" még akkor is, ha valakinek van "automatikus szintezője". Magát a szondát gyakran kalibrálni kell a jó eredmények eléréséhez. A szonda kalibrálása a "papírteszt" segítségével történik.

A papírteszt elvégzéséhez vágjon ki egy kis téglalap alakú papírdarabot egy ollóval (pl. 5x3 cm). A papír vastagsága általában körülbelül 100 mikron (0,100 mm). (A papír pontos vastagsága nem döntő fontosságú.)

A papírteszt első lépése a nyomtató fúvókájának és ágyának ellenőrzése. Győződjön meg róla, hogy nincs műanyag (vagy más törmelék) a fúvókán vagy az ágyon.

**Ellenőrizze a fúvókát és az ágyat, hogy nincs-e benne/rajta műanyag!**

Ha valaki mindig egy adott lapra vagy felületre nyomtat, akkor a papírtesztet az adott lappal/felülettel a helyén végezheti el. Vegye azonban figyelembe, hogy maga a lap vastagsággal rendelkezik, és a különböző lapok (vagy bármely más nyomtatási felület) hatással lesznek a Z mérésekre. Mindenképpen végezze el újra a papírtesztet, hogy minden egyes használt felülettípust megmérjen.

Ha műanyag van a fúvókán, akkor melegítse fel az extrudert, és egy fém csipesszel távolítsa el a műanyagot. Várja meg, amíg az extruder teljesen lehűl szobahőmérsékletűre, mielőtt folytatja a papírtesztet. Amíg a fúvóka hűl, a fémcsipesszel távolítsa el az esetlegesen kiszivárgó műanyagot.

**A papírtesztet mindig akkor végezze el, amikor a fúvóka és az ágy szobahőmérsékleten van!**

A fúvóka melegítésekor a hőtágulás miatt megváltozik a helyzete (az ágyhoz képest). Ez a hőtágulás jellemzően 100 mikron körüli, ami körülbelül ugyanolyan méret, mint egy tipikus nyomtatópapír. A hőtágulás pontos mértéke nem döntő, ahogyan a papír pontos vastagsága sem döntő. Induljunk ki abból a feltételezésből, hogy a kettő egyenlő (a két távolság közötti különbség meghatározásának módszerét lásd alább).

Furcsának tűnhet, hogy a távolságot szobahőmérsékleten kalibráljuk, amikor a cél az, hogy melegítéskor egyenletes távolságot érjünk el. Ha azonban a fúvókát melegítve kalibráljuk, akkor hajlamos kis mennyiségű olvadt műanyagot juttatni a papírra, ami megváltoztatja az érzékelt súrlódás mértékét. Ez megnehezíti a jó kalibrációt. Ha a szintezés felfűtött állapotban történik, akkor nagymértékben megnő a megégés veszélye is. A hőtágulás mértéke stabil, így a kalibrálás során később könnyen figyelembe vehető.

**Automatizált eszközzel határozza meg a pontos Z magasságot!**

A Klipperben számos segédszkript áll rendelkezésre (pl. MANUAL_PROBE, Z_ENDSTOP_CALIBRATE, PROBE_CALIBRATE, DELTA_CALIBRATE). Lásd a documentumokat [fentebb leírva](#choose-the-appropriate-calibration-mechanism), hogy válassz közülük egyet.

Futtassa a megfelelő parancsot az OctoPrint konzoljában. A szkript az OctoPrint terminál kimenetén kéri a felhasználó beavatkozását. Valahogy így fog kinézni:

```
Recv: // Starting manual Z probe. Use TESTZ to adjust position.
Recv: // Finish with ACCEPT or ABORT command.
Recv: // Z position: ?????? --> 5.000 <-- ??????
```

A fúvóka aktuális magassága (ahogyan azt a nyomtató jelenleg értelmezi) a "--> <--" között jelenik meg. A jobb oldali szám a legutóbbi mérés magassága, amely éppen nagyobb, mint az aktuális magasság, a bal oldali pedig a legutóbbi mérés magassága, amely kisebb, mint az aktuális magasság (vagy ??????, ha nem történt kísérlet).

Helyezze a papírt a fúvóka és az ágy közé. Hasznos lehet a papír egyik sarkát behajtani, hogy könnyebb legyen megfogni. (Próbálja úgy, hogy ne nyomja le az ágyat, amikor a papírt előre-hátra mozgatja).

![paper-test](img/paper-test.jpg)

A TESTZ paranccsal kérheti, hogy a fúvóka közelebb menjen a papírhoz. Például:

```
TESTZ Z=-.1
```

A TESTZ parancs a fúvókát az aktuális pozíciójától relatív távolságra mozgatja. (Tehát a `Z=-.1` azt kéri, hogy a fúvóka 0,1 mm-rel közelebb kerüljön az ágyhoz). Miután a fúvóka megállt, tolja előre-hátra a papírt, hogy ellenőrizze, hogy a fúvóka érintkezik-e a papírral, és hogy érezze a súrlódás mértékét. Folytassa a TESTZ parancsok kiadását mindaddig, amíg a papírral való tesztelésekkor nem érez egy kis súrlódást.

Ha túl nagy a súrlódás, akkor egy pozitív Z értéket használhatunk a fúvóka felfelé mozgatására. Lehetőség van a `TESTZ Z=+` vagy a `TESTZ Z=-` használatára is, hogy "felezzük" az utolsó pozíciót - azaz két pozíció között félúton lévő pozícióba lépjünk. Például, ha a TESTZ parancs a következő felszólítást adná:

```
Recv: // Z position: 0.130 --> 0.230 <-- 0.280
```

Ezután egy `TESTZ Z=-` a fúvókát 0,180 Z pozícióba (a 0,130 és 0,230 közötti félútra) mozgatja. Ezt a funkciót arra lehet használni, hogy segítsen gyorsan leszűkíteni egy konzisztens súrlódást. A `Z=++` és `Z=--` parancsok használatával közvetlenül visszatérhetünk egy korábbi méréshez - például a fenti felszólítás után a `TESTZ Z=--` parancs a fúvókát a 0,130-as Z pozícióba mozgatná.

Miután érzékelhető egy kis súrlódás, adja ki az ACCEPT parancsot:

```
ACCEPT
```

Ez elfogadja a megadott Z magasságot, és az adott kalibrációs eszközzel folytatja a munkát.

Az érzékelt súrlódás pontos mértéke nem döntő fontosságú, ahogyan a hőtágulás mértéke és a papír pontos szélessége sem döntő fontosságú. Csak próbáljon meg minden egyes alkalommal ugyanannyi súrlódást elérni, amikor a tesztet lefuttatja.

Ha a teszt során valami rosszul megy, az `ABORT` paranccsal kiléphetünk a kalibrációs eszközből.

## A hőtágulás meghatározása

Miután sikeresen elvégezte az ágyszintezést, pontosabb értéket lehet kiszámítani a "hőtágulás", "a papír vastagsága" és "a papírteszt során érzékelhető súrlódás" együttes hatására.

Ilyen típusú számításokra általában nincs szükség, mivel a legtöbb felhasználó szerint az egyszerű "papírteszt" jó eredményeket ad.

A számítás legegyszerűbben úgy végezhető el, ha kinyomtatunk egy olyan tesztobjektumot, amelynek minden oldalán egyenes falak vannak. Ehhez a [docs/prints/square.stl](prints/square.stl) fájlban található nagy, üreges négyzetet használhatjuk. Az objektum szeletelésekor győződjön meg róla, hogy a szeletelő az első szinthez ugyanazt a rétegmagasságot és extrudálási szélességet használja, mint az összes további réteghez. Használjon durva rétegmagasságot (a rétegmagasságnak a fúvóka átmérőjének körülbelül 75%-ának kell lennie), és ne használjon peremet vagy szoknyát.

Nyomtassa ki a tesztobjektumot, várja meg, amíg lehűl, és vegye le az ágyról. Ellenőrizze a tárgy legalsó rétegét. (Az is hasznos lehet, ha ujját vagy körmét végighúzza az alsó szélén.) Ha azt tapasztaljuk, hogy az alsó réteg a tárgy minden oldala mentén kissé kidudorodik, akkor ez azt jelzi, hogy a fúvóka kissé közelebb volt az ágyhoz, mint kellett volna. A magasság növeléséhez kiadhatunk egy `SET_GCODE_OFFSET Z=+.010` parancsot. A későbbi nyomtatásokban ellenőrizhetjük ezt a viselkedést, és szükség szerint további kiigazításokat végezhetünk. Az ilyen típusú beállítások jellemzően 10 mikronokban (.010mm) történnek.

Ha az alsó réteg keskenyebbnek tűnik, mint a következő rétegek, akkor a SET_GCODE_OFFSET paranccsal negatív Z-beállítást végezhetünk. Ha bizonytalanok vagyunk, akkor a Z-beállítást addig csökkenthetjük, amíg a nyomatok alsó rétege egy kis dudort nem mutat, majd addig csökkenthetjük, amíg az el nem tűnik.

A legegyszerűbb módja a kívánt Z-korrigálásnak, ha létrehoz egy START_PRINT G-Kód makrót. A szeletelő úgy intézi, hogy a makró minden nyomtatás kezdetekor meghívja ezt a parancsot, és hozzáad egy SET_GCODE_OFFSET parancsot. További részletekért lásd a [szeletelők](Slicers.md) dokumentumot.
