# Kinematika

Ez a dokumentum áttekintést nyújt arról, hogy a Klipper hogyan valósítja meg a robot mozgását (a [kinematika](https://en.wikipedia.org/wiki/Kinematics)). A tartalom mind a Klipper szoftveren dolgozni kívánó fejlesztők, mind a gépük mechanikájának jobb megértése iránt érdeklődő felhasználók számára érdekes lehet.

## Gyorsulás

A Klipper állandó gyorsítási rendszert alkalmaz, amikor a nyomtatófej sebességet változtat. A sebesség fokozatosan változik az új sebességre, ahelyett, hogy hirtelen rángatózna. A Klipper mindig kikényszeríti a gyorsulást a nyomtatófej és a nyomtatás között. Az extruderből kilépő szál meglehetősen törékeny lehet. A gyors rángások és/vagy az extruder áramlásának változása rossz minőséghez és rossz tapadáshoz vezet. Még ha nem is extrudál, ha a nyomtatófej a nyomtatással egy magasságban van, akkor a fej gyors rángása a nemrég letapadt anyag felválását okozhatja. A nyomtatófej sebességváltoztatásának korlátozása (a nyomtatáshoz képest) csökkenti a nyomat felválásának kockázatát.

Fontos a gyorsulás korlátozása is, hogy a léptetőmotorok ne ugorjanak, és ne terheljék túlzottan a gépet. A Klipper a nyomtatófej gyorsulásának korlátozásával korlátozza az egyes léptetőmotorok nyomatékát. A nyomtatófej gyorsulásának kikényszerítése természetesen a nyomtatófejet mozgató léptetőmotorok nyomatékát is korlátozza (a fordítottja nem mindig igaz).

A Klipper állandó gyorsulást valósít meg. Az állandó gyorsulás legfontosabb képlete a következő:

```
velocity(time) = start_velocity + accel*time
```

## Trapéz generátor

A Klipper hagyományos "trapézgenerátort" használ az egyes mozgások modellezésére. Minden lépésnek van kezdősebessége, állandó gyorsítás mellett utazósebességre gyorsul, állandó sebességgel utazik, majd állandó gyorsítással lelassít a végsebességre .

![trapezoid](img/trapezoid.svg.png)

Ezt "trapézgenerátornak" nevezik, mert a mozgás sebességdiagramja úgy néz ki, mint egy trapéz.

Az utazósebesség mindig nagyobb vagy egyenlő a kezdő- és a végsebességgel. A gyorsulási fázis lehet nulla időtartamú (ha a kezdősebesség egyenlő az utazósebességgel), az utazási fázis lehet nulla időtartamú (ha a mozgás a gyorsulás után azonnal lassulni kezd), és/vagy a lassulási fázis lehet nulla időtartamú (ha a végsebesség egyenlő az utazósebességgel).

![trapezoids](img/trapezoids.svg.png)

## Előretekintő

A "look-ahead" rendszert a kanyarsebességek meghatározására használják a mozgások között.

Nézzük meg a következő két mozgást, amelyek egy X-Y-síkon helyezkednek el:

![corner](img/corner.svg.png)

A fenti helyzetben lehetséges az első lépés után teljesen lelassítani, majd a következő lépés kezdetén teljesen felgyorsítani, de ez nem ideális, mivel ez a sok gyorsítás és lassítás jelentősen megnövelné a nyomtatási időt, és az anyagáramlás gyakori változása rossz nyomtatási minőséget eredményezne.

Ennek megoldására a "look-ahead" mechanizmus több bejövő mozgást sorba állít, és elemzi a mozgások közötti szögeket, hogy meghatározzon egy ésszerű sebességet, amelyet a két mozgás közötti "kereszteződés" alatt lehet elérni. Ha a következő lépés közel azonos irányba mutat, akkor a fejnek csak egy kicsit kell lassítania (ha egyáltalán kell).

![lookahead](img/lookahead.svg.png)

Ha azonban a következő mozdulat hegyesszöget zár be (a fej a következő mozdulatnál majdnem fordított irányban fog haladni), akkor csak egy kis csomóponti sebesség a megengedett.

![lookahead](img/lookahead-slow.svg.png)

A csomóponti sebességeket a "közelítő centripetális gyorsulás" segítségével határozzuk meg. Legjobb [a szerző által leírt](https://onehossshay.wordpress.com/2011/09/24/improving_grbl_cornering_algorithm/). A Klipperben azonban a csomóponti sebességek úgy kerülnek beállításra, hogy megadjuk a 90°-os sarok kívánt sebességét (a "négyzetes saroksebesség"), és a többi szögre vonatkozó csomóponti sebességeket ebből vezetjük le.

Kulcsképlet az előretekintéshez:

```
end_velocity^2 = start_velocity^2 + 2*accel*move_distance
```

### Simított előretekintés

A Klipper egy olyan mechanizmust is megvalósít, amely kisimítja a rövid "cikkcakk" mozgásokat. Tekintsük a következő mozgásokat:

![zigzag](img/zigzag.svg.png)

A fentiekben a gyorsításról lassításra történő gyakori váltás a gép rezgését okozhatja, ami a gépet terheli, és növeli a zajt. Ennek csökkentése érdekében a Klipper mind a rendszeres mozgási gyorsulást, mind pedig a virtuális "gyorsításról lassításra" sebességet követi. Ezzel a rendszerrel a nyomtató mozgásának kiegyenlítése érdekében a rövid "cikkcakkos" mozgások csúcssebessége korlátozott:

![smoothed](img/smoothed.svg.png)

Konkrétan, a kód kiszámítja, hogy mi lenne az egyes mozgások sebessége, ha az adott virtuális "gyorsulás-lassulás" sebességre korlátozódna (alapértelmezés szerint a normál gyorsulási sebesség fele). A fenti képen a szaggatott szürke vonalak ezt a virtuális gyorsulási sebességet jelölik az első mozdulatnál. Ha egy mozgás nem tudja elérni a teljes utazósebességét ezzel a virtuális gyorsulási sebességgel, akkor a végsebessége arra a maximális sebességre csökken, amelyet ezzel a virtuális gyorsulási sebességgel elérhetne. A legtöbb mozgás esetében ez a határérték a mozgás meglévő határértékeinél vagy azok felett lesz, és nem változik a viselkedés. Rövid cikk-cakk mozgások esetén azonban ez a határ csökkenti a csúcssebességet. Vegye figyelembe, hogy ez nem változtatja meg a tényleges gyorsulást a mozgáson belül. A mozgás továbbra is a normál gyorsulási sémát használja a beállított csúcssebességig.

## Lépések generálása

Miután a look-ahead folyamat befejeződött, a nyomtatófej mozgása az adott mozgáshoz teljes mértékben ismert (idő, kezdő pozíció, végpozíció, sebesség minden egyes ponton), és lehetséges a lépésidők generálása a mozgáshoz. Ez a folyamat a Klipper kódban a "kinematikai osztályokon" belül történik. Ezeken a kinematikai osztályokon kívül minden milliméterben, másodpercben és cartesian koordináta térben követhető. A kinematikai osztályok feladata, hogy ebből az általános koordináta-rendszerből az adott nyomtató hardveres sajátosságaihoz igazítsák.

A Klipper egy [iteratív megoldót](https://en.wikipedia.org/wiki/Root-finding_algorithm) használ az egyes léptetők lépésidejének létrehozásához. A kód tartalmazza a képleteket a fej ideális cartesian koordinátáinak kiszámításához minden egyes időpontban, és rendelkezik a kinematikai képletekkel az ideális stepper pozíciók kiszámításához ezen cartesian koordináták alapján. Ezekkel a képletekkel a Klipper meg tudja határozni azt az ideális időt, amikor a steppernek az egyes lépéshelyzetekben kell lennie. Az adott lépéseket ezután ezekre a kiszámított időpontokra ütemezi.

A legfontosabb képlet annak meghatározására, hogy egy mozgásnak milyen messzire kell eljutnia állandó gyorsulás mellett, a következő:

```
move_distance = (start_velocity + .5 * accel * move_time) * move_time
```

és az állandó sebességű mozgásra vonatkozó kulcsképlet a következő:

```
move_distance = cruise_velocity * move_time
```

A mozgások cartesian koordinátáinak meghatározására szolgáló kulcsképletek a következők:

```
cartesian_x_position = start_x + move_distance * total_x_movement / total_movement
cartesian_y_position = start_y + move_distance * total_y_movement / total_movement
cartesian_z_position = start_z + move_distance * total_z_movement / total_movement
```

### Cartesian robotok

A legegyszerűbb eset a lépések generálása a kartotéknyomtatókhoz. Az egyes tengelyeken történő mozgás közvetlenül kapcsolódik a cartesian térben történő mozgáshoz.

Kulcsképletek:

```
stepper_x_position = cartesian_x_position
stepper_y_position = cartesian_y_position
stepper_z_position = cartesian_z_position
```

### CoreXY robotok

A lépések generálása egy CoreXY gépen csak egy kicsit bonyolultabb, mint az egyszerű cartesian robotoké. A legfontosabb képletek a következők:

```
stepper_a_position = cartesian_x_position + cartesian_y_position
stepper_b_position = cartesian_x_position - cartesian_y_position
stepper_z_position = cartesian_z_position
```

### Delta robotok

A delta roboton történő lépésgenerálás a Pitagorasz-tételen alapul:

```
stepper_position = (sqrt(arm_length^2
                         - (cartesian_x_position - tower_x_position)^2
                         - (cartesian_y_position - tower_y_position)^2)
                    + cartesian_z_position)
```

### Léptetőmotor gyorsulási határértékei

A delta kinematikával lehetséges, hogy egy cartesian térben gyorsuló mozgás nagyobb gyorsulást igényel egy adott léptetőmotoron, mint a mozgás gyorsulása. Ez akkor fordulhat elő, ha egy mozgatott kar inkább vízszintes, mint függőleges, és a mozgás vonala az adott léptető torony közelében halad el. Bár ezekhez a mozgásokhoz nagyobb léptetőmotor-gyorsulásra lehet szükség, mint a nyomtató maximálisan konfigurált mozgásgyorsulása, az adott léptető által mozgatott effektív tömeg kisebb lesz. Így a nagyobb léptető gyorsulás nem eredményez jelentősen nagyobb léptető nyomatékot, és ezért ártalmatlannak tekinthető.

A szélsőséges esetek elkerülése érdekében azonban a Klipper a nyomtató konfigurált maximális mozgási gyorsulásának háromszorosában határozza meg a léptető gyorsulásának felső határát. (Hasonlóképpen, a léptető maximális sebessége a maximális mozgatási sebesség háromszorosára van korlátozva). E korlát betartása érdekében az építési terület szélső szélén (ahol a léptető kar közel vízszintes lehet) a mozgások maximális gyorsulása és sebessége alacsonyabb lesz.

### Extruder kinematika

A Klipper az extruder mozgását saját kinematikai osztályában valósítja meg. Mivel a nyomtatófej mozgásának időzítése és sebessége minden egyes mozgásnál teljesen ismert, az extruder lépésidejét a nyomtatófej mozgásának lépésidő-számításaitól függetlenül lehet kiszámítani.

Az extruder alapmozgása egyszerűen kiszámítható. A lépésidő generálása ugyanazokat a képleteket használja, mint a cartesian gépek:

```
stepper_position = requested_e_position
```

### Nyomás előtolás

A kísérletek azt mutatták, hogy az extruder modellezését az alap extruder képleten túl is lehet javítani. Ideális esetben az extrudálási mozgás előrehaladtával a mozgás minden egyes pontján ugyanannyi szálnak kell lerakódnia, és a mozgás után nem szabad extrudálódnia. Sajnos gyakran előfordul, hogy az alap extrudálási képletek miatt az extrudálási mozgások kezdetén túl kevés szál kerül ki az extruderből, és az extrudálás befejezése után többletszál kerül extrudálásra. Ezt gyakran nevezik "ooze"-nak.

![ooze](img/ooze.svg.png)

A "nyomás előtolás" rendszer ezt úgy próbálja figyelembe venni, hogy az extruderhez egy másik modellt használ. Ahelyett, hogy naivan azt hinné, hogy az extruderbe táplált minden egyes mm^3 szálat az extruderből azonnal ugyanannyi mm^3 fog kilépni, a rendszer egy nyomáson alapuló modellt használ. A nyomás nő, amikor a szál az extruderbe kerül (mint a [Hooke törvény](https://en.wikipedia.org/wiki/Hooke%27s_law) szerint), és az extrudáláshoz szükséges nyomást a fúvóka nyílásán keresztül történő áramlási sebesség uralja (mint a [Poiseuille törvény](https://en.wikipedia.org/wiki/Poiseuille_law) szerint). A kulcsgondolat az, hogy a szál, a nyomás és az áramlási sebesség közötti kapcsolat egy lineáris együtthatóval modellezhető:

```
pa_position = nominal_position + pressure_advance_coefficient * nominal_velocity
```

A nyomás előtolás együttható meghatározásához lásd a [nyomás előtolás](Pressure_Advance.md) dokumentumot.

Az alapvető nyomás előtolás képlete az extruder motorjának hirtelen sebességváltozásait okozhatja. A Klipper ennek elkerülése érdekében az extruder mozgásának "simítását" alkalmazza.

![pressure-advance](img/pressure-velocity.png)

A fenti grafikon egy példát mutat két olyan extrudálási mozgásra, amelyek között a kanyarsebesség nem nulla. Vegye figyelembe, hogy a nyomás előtolás rendszer miatt a gyorsítás során további szálak kerülnek az extruderbe. Minél nagyobb a kívánt száláramlási sebesség, annál több szálat kell betolni a gyorsítás során a nyomás miatt. A fej lassítása során a plusz szál visszahúzódik (az extruder sebessége negatív lesz).

A "simítás" az extruder pozíciójának súlyozott átlagával történik egy kis időintervallumban (ahogyan azt a `pressure_advance_smooth_time` konfigurációs paraméter megadja). Ez az átlagolás több G-kód mozgást is átfoghat. Figyelje meg, hogy az extrudermotor az első extrudermozgás névleges kezdete előtt elkezd mozogni, és az utolsó extrudermozgás névleges vége után is mozogni fog.

Kulcsképlet a "simított nyomás előtoláshoz":

```
smooth_pa_position(t) =
    ( definitive_integral(pa_position(x) * (smooth_time/2 - abs(t - x)) * dx,
                          from=t-smooth_time/2, to=t+smooth_time/2)
     / (smooth_time/2)^2 )
```
