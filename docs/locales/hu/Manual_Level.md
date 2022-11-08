# Kézi szintezés

Ez a dokumentum a Z végállás kalibrálásához és a tárgyasztalt kiegyenlítő csavarok beállításához szükséges eszközöket ismerteti.

## Z végállás kalibrálása

A pontos Z végállás pozíciója kritikus fontosságú a jó minőségű nyomatok elkészítéséhez.

Vedd figyelembe azonban, hogy maga a Z végálláskapcsoló pontossága korlátozó tényező lehet. Ha Trinamic léptetőmotor-meghajtókat használunk, akkor fontoljuk meg a [végstop fázis](Endstop_Phase.md) érzékelés engedélyezését a kapcsoló pontosságának javítása érdekében.

A Z végpont kalibrálásának végrehajtásához kapcsold be a nyomtatót, utasítsd a fejet, hogy mozogjon egy Z pozícióba, amely legalább öt milliméterrel a tárgyasztal felett van (ha még nincs), utasítsd a fejet, hogy mozogjon egy X-Y pozícióba, közel a nyomtató közepéhez a tárgyasztalra, majd navigálj az OctoPrint terminál fülre, és futtasd:

```
Z_ENDSTOP_CALIBRATE
```

Ezután kövesd a ["a papírteszt"](Bed_Level.md#the-paper-test) pontban leírt lépéseket a fúvóka és a tárgyasztal közötti tényleges távolság meghatározásához az adott helyen. Ha ezek a lépések befejeződtek, akkor `ACCEPT` és elmentheted az eredményeket a config fájlba a következővel:

```
SAVE_CONFIG
```

Előnyösebb, ha a Z végálláskapcsolót a Z tengelynek az ággyal ellentétes végére helyezzük. (A tárgyasztaltól távolabb történő kezdőpont keresés robusztusabb, mivel akkor általában mindig biztonságosan lehet a Z-t kezdőpontra állítani.) Ha azonban a tárgyasztal felé kell kezdőpontot felvenni, ajánlott a végálláskapcsolót úgy beállítani, hogy az kis távolságra (pl. 0,5 mm-re) a tárgyasztal fölött kapcsoljon. Majdnem minden végálláskapcsoló biztonságosan lenyomható egy kis távolsággal a kioldási ponton túl. Ha ez megtörtént, azt kell tapasztalni, hogy a `Z_ENDSTOP_CALIBRATE` parancs egy kis pozitív értéket (pl. .5mm) jelez a Z pozíció végálláshoz. A végállás érzékelése akkor, amikor az még bizonyos távolságra van a tárgyasztaltól, csökkenti a véletlen tárgyasztalba ütközések kockázatát.

Egyes nyomtatókon lehetőség van a fizikai végálláskapcsoló helyének kézi beállítására. Azonban ajánlott a Z végállás pozíciónálását szoftveresen elvégezni a Klipperrel. Ha a végállás fizikai helyzete megfelelő helyen van, a további beállításokat a Z_ENDSTOP_CALIBRATE futtatásával vagy a Z position_endstop konfigurációs fájlban lévő Z position_endstop manuális frissítésével lehet elvégezni.

## Tárgyasztal szintezőcsavarok beállítása

A tárgyasztalt kiegyenlítő csavarokkal történő jó szintezés titka a nyomtató nagy pontosságú mozgásrendszerének kihasználása a szintezési folyamat során. Ez úgy történik, hogy a fúvókát az egyes szintezőcsavarok közelében lévő pozícióba navigáljuk, majd az adott csavart addig állítjuk, amíg a tárgyasztal egy meghatározott távolságra nem kerül a fúvókától. A Klipper rendelkezik egy eszközzel, amely ezt segíti. Az eszköz használatához meg kell adni az egyes csavarok X-Y helyzetét.

Ezt egy `[bed_screws]` konfigurációs szakasz létrehozásával érhetjük el. Ez például valahogy így nézhet ki:

```
[bed_screws]
screw1: 100, 50
screw2: 100, 150
screw3: 150, 100
```

Ha egy tárgyasztal csavar a tárgyasztal alatt van, akkor add meg az X-Y pozíciót közvetlenül a csavar felett. Ha a csavar a tárgyasztalon kívül van, akkor add meg a csavarhoz legközelebbi X-Y-pozíciót, amely még a tárgyasztal hatótávolságán belül van.

Miután a konfigurációs fájl készen áll, futtasd a `RESTART` parancsot a konfiguráció betöltéséhez, majd elindíthatod az eszközt a következő futtatásával:

```
BED_SCREWS_ADJUST
```

Ez az eszköz a nyomtató fúvókát minden egyes csavar X-Y helyére mozgatja, majd a fúvókát Z=0 magasságba mozgatja. Ezen a ponton a "papírteszt" segítségével közvetlenül a fúvóka alatt lehet beállítani a tárgyasztal csavarját. Lásd a ["a papírteszt"](Bed_Level.md#the-paper-test)-ben leírtakat. De a fúvóka különböző magasságokba navigálása helyett a tárgyasztalcsavart állítsd be. Addig állítsd a csavart, amíg a papír előre-hátra tolása közben kis súrlódás nem keletkezik.

Miután a csavart úgy állítottuk be, hogy egy kis súrlódás érezhető legyen, futtassuk az `ACCEPT` vagy az `ADJUSTED` parancsot. Használd az `ADJUSTED` parancsot, ha a szintezőcsavar beállítására van szükség (általában bármi, ami több mint 1/8 csavarfordulat). Használd az `ACCEPT` parancsot, ha nincs szükség jelentős beállításra. Mindkét parancs hatására a szerszám a következő csavarhoz lép. (Ha az `ADJUSTED` parancsot használod, a szerszám egy további szintezőcsavar-beállítási ciklust ütemez be. A szerszám sikeresen befejezi, ha az összes szintezőcsavarról bebizonyosodik, hogy nem igényel jelentős beállítást.) Az `ABORT` paranccsal idő előtt ki lehet lépni a szintezésből.

Ez a rendszer akkor működik a legjobban, ha a nyomtató sík nyomtatási felülettel (például üveggel) és egyenes sínekkel rendelkezik. A tárgyasztal szintező eszköz sikeres elvégzése után a tárgyasztal készen áll a nyomtatásra.

### Finom menetes tárgyasztal csavar beállítások

Ha a nyomtató három szintezőcsavart használ, és mindhárom csavar a tárgyasztal alatt van, akkor lehetséges egy második "nagy pontosságú" szintezési lépés elvégzése. Ez úgy történik, hogy a fúvókát olyan helyekre irányítja, ahol a tárgyasztal minden egyes szintezőcsavar beállítással nagyobb távolságot mozdul el.

Vegyünk például egy tárgyasztalt, amelynek A, B és C helyén csavarok vannak:

![bed_screws](img/bed_screws.svg.png)

A C helyen lévő szintezőcsavar minden egyes beállítása esetén a tárgyasztal a fennmaradó két szintezőcsavar által meghatározott inga mentén fog lengeni (itt zöld vonalként látható). Ebben a helyzetben a szintezőcsavar állítása a C helyzetben a tárgyasztalt kisebb a D helyzetben egy nagyobb mértékben mozdítja el.

A funkció engedélyezéséhez meg kell határozni a további fúvókakoordinátákat, és hozzá kell adni őket a konfigurációs fájlhoz. Ez például így nézhet ki:

```
[bed_screws]
screw1: 100, 50
screw1_fine_adjust: 0, 0
screw2: 100, 150
screw2_fine_adjust: 300, 300
screw3: 150, 100
screw3_fine_adjust: 0, 100
```

Ha ez a funkció engedélyezve van, a `BED_SCREWS_ADJUST` eszköz először közvetlenül az egyes csavarok pozíciói felett kér durva beállításokat, és ha ezeket elfogadtad, akkor a további helyeken finom beállításokat kér. Folytasd az `ACCEPT` és `ADJUSTED` használatával minden egyes pozícióban.

## A tárgyasztal szintezőcsavarjainak beállítása mérőszonda segítségével

Ez egy másik módja a tárgyasztal szint kalibrálásának a mérőszonda segítségével. Használatához rendelkezned kell Z-szondával (BL Touch, induktív érzékelő stb.).

A funkció engedélyezéséhez meg kell határozni a fúvóka koordinátáit úgy, hogy a Z szonda a csavarok felett legyen, majd hozzá kell adni a konfigurációs fájlhoz. Ez például így nézhet ki:

```
[screws_tilt_adjust]
screw1: -5, 30
screw1_name: front left screw
screw2: 155, 30
screw2_name: front right screw
screw3: 155, 190
screw3_name: rear right screw
screw4: -5, 190
screw4_name: rear left screw
horizontal_move_z: 10.
speed: 50.
screw_thread: CW-M3
```

Az 1. csavar mindig a referenciapont a többi csavar számára, így a rendszer feltételezi, hogy az 1. csavar a megfelelő magasságban van. Először mindig futtassa le a `G28` G-kódot, majd futtassa le a `SCREWS_TILT_CALCULATE` parancsot. Ennek a következőhöz hasonló kimenetet kell eredményeznie:

```
Send: G28
Recv: ok
Send: SCREWS_TILT_CALCULATE
Recv: // 01:20 means 1 full turn and 20 minutes, CW=clockwise, CCW=counter-clockwise
Recv: // front left screw (base) : x=-5.0, y=30.0, z=2.48750
Recv: // front right screw : x=155.0, y=30.0, z=2.36000 : adjust CW 01:15
Recv: // rear right screw : y=155.0, y=190.0, z=2.71500 : adjust CCW 00:50
Recv: // read left screw : x=-5.0, y=190.0, z=2.47250 : adjust CW 00:02
Recv: ok
```

Ez azt jelenti, hogy:

- a bal első csavar a referenciapont, nem szabad megváltoztatni.
- a jobb első csavart az óramutató járásával megegyező irányban kell elfordítani 1 teljes és negyed fordulatot
- a jobb hátsó csavart az óramutató járásával ellentétes irányba kell forgatni 50 percnyi fordulatot
- bal hátsó csavart az óramutató járásával megegyező irányba kell forgatni 2 percnyit (nem kell tökéletesnek lennie)

Vedd figyelembe, hogy a "percek" az "óra számlapjának perceire" utalnak. Így például 15 perc egy teljes fordulat negyedének felel meg.

Ismételd meg a folyamatot többször, amíg egy jó vízszintes tárgyasztalt nem kapsz. Általában akkor jó, ha minden beállítás 6 percnyi fordulat alatt van.

Ha olyan szondát használsz, amely a nyomtatófej oldalára van szerelve (azaz X vagy Y eltolással rendelkezik), akkor vedd figyelembe, hogy a tárgyasztal dőlésének beállítása érvényteleníti a korábbi, dőlésszögű tárgyasztalon végzett szintkalibrálást. A tárgyasztal csavarjainak beállítása után mindenképpen futtasd le a [szonda kalibrálása](Probe_Calibrate.md) parancsot.

A `MAX_DEVIATION` paraméter akkor hasznos, ha egy mentett tárgyasztal hálót használunk, hogy biztosítsuk, hogy a tárgyasztal szintje ne térjen el túlságosan attól a helytől, ahol a háló létrehozásakor volt. Például a `SCREWS_TILT_CALCULATE MAX_DEVIATION=0.01` hozzáadható a szeletelő egyéni indító G-kódjához a háló betöltése előtt. Ez megszakítja a nyomtatást, ha a beállított határértéket túllépi (ebben a példában 0,01 mm), lehetőséget adva a felhasználónak a csavarok beállítására és a nyomtatás újraindítására.

A `DIRECTION` paraméter akkor hasznos, ha a tárgyasztal szintező csavarjait csak egy irányba tudja elfordítani. Például lehetnek olyan csavarjai, amelyek a lehető legalacsonyabb (vagy legmagasabb) pozícióban vannak meghúzva, és csak egy irányba forgathatók a tárgyasztal emeléséhez (vagy süllyesztéséhez). Ha a csavarokat csak az óramutató járásával megegyező irányban tudja elfordítani, futtassa a `SCREWS_TILT_CALCULATE DIRECTION=CW` parancsot. Ha csak az óramutató járásával ellentétes irányban tudja elforgatni őket, futtassa a `SCREWS_TILT_CALCULATE DIRECTION=CCW` parancsot. A program kiválaszt egy megfelelő referenciapontot, hogy a tárgyasztalt az összes csavar adott irányba történő elfordításával szintezhesse.
