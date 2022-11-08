# Forgatási távolság

A Klipper léptetőmotor meghajtók minden [léptető konfigurációs szakaszban](Config_Reference.md#stepper) megkövetelnek egy `rotation_distance` paramétert. A `rotation_distance` az a távolság, amelyet a tengely a léptetőmotor egy teljes fordulatával elmozdít. Ez a dokumentum leírja, hogyan lehet ezt az értéket beállítani.

## A rotation_distance kinyerése a steps_per_mm (vagy step_distance) értékből

A 3D nyomtató tervezői eredetileg `steps_per_mm` forgatási távolságból számították ki. Ha ismered a steps_per_mm értéket, akkor ezzel az általános képlettel megkaphatod az eredeti forgatási távolságot:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> / <steps_per_mm>
```

Vagy ha régebbi Klipper konfigurációval rendelkezel, és ismered a `step_distance` paramétert, akkor használhatod ezt a képletet:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> * <step_distance>
```

A `<full_steps_per_rotation>` beállítást a léptetőmotor típusa határozza meg. A legtöbb léptetőmotor "1,8 fokos lépésszögű" és ezért 200 teljes lépés/fordulat (360 osztva 1,8-al az a 200). Egyes léptetőmotorok "0,9 fokos lépésszögűek" és így 400 teljes lépést tesznek meg fordulatonként. Más léptetőmotorok ritkábbak. Ha bizonytalan vagy, ne állítsd be a full_steps_per_rotation értéket a konfigurációs fájlban, és használd a 200-at a fenti képletben.

A `<microsteps>` beállítást a léptetőmotor-meghajtó határozza meg. A legtöbb meghajtó 16 mikrolépést használ. Ha bizonytalan vagy, állítsd be a `microsteps: 16` a konfigurációban, és használd a 16-ot a fenti képletben.

Szinte minden nyomtatónak egész számot kell megadnia a `rotation_distance` X, Y és Z típusú tengelyeknél. Ha a fenti képlet olyan rotation_distance-ot eredményez, amely 0,01 egész számon belül van, akkor kerekítse a végső értéket erre az egész számra.

## A rotation_distance kalibrálása extrudereken

Egy extruder esetében a `rotation_distance` az a távolság, amelyet a nyomtatószál léptetőmotor egy teljes fordulatán megtesz. Ennek a beállításnak a pontos értékét a "mérés és igazítás" eljárással lehet a legjobban meghatározni.

Először is kezdjük a forgatási távolság kezdeti becslésével. Ezt a [steps_per_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance) vagy [a hardver vizsgálata](#extruder) segítségével kaphatjuk meg.

Ezután a következő eljárást alkalmazd a "mérés és igazítás" elvégzéséhez:

1. Győződj meg arról, hogy az extruderben van-e nyomtatószál, a hotend megfelelő hőmérsékletre van-e melegítve, és a nyomtató készen áll-e az extrudálásra.
1. Jelöld meg a nyomtatószálat egy jelölővel az extrudertest bemenő nyílásától kb. 70 mm-re. Ezután egy digitális tolómérővel mérd meg a lehető legpontosabban ennek a jelölésnek a tényleges távolságát. Ezt jegyezd fel `<initial_mark_distance>`.
1. Extrudáljon 50 mm nyomtatószálat a következő parancsokkal: `G91`, majd `G1 E50 F60`. Az 50 mm-t jegyezze meg `<requested_extrude_distance>`. Várja meg, amíg az extruder befejezi a mozgást (ez körülbelül 50 másodpercig tart). Fontos, hogy lassú extrudálási sebességet használj ehhez a teszthez, mivel a gyorsabb sebesség magas nyomást okozhat az extruderben, ami torzítja az eredményeket. (Ne használod az "extrude gombot" a grafikus előlapon ehhez a teszthez, mivel azok gyors ütemben extrudálnak.)
1. Digitális tolómérővel mérd meg az extruder teste és a szálon lévő jelölés közötti új távolságot. Ezt jegyezd fel `<subsequent_mark_distance>`. Ezután számítsd ki: `actual_extrude_distance = <initial_mark_distance> - <subsequent_mark_distance>`
1. A rotation_distance kiszámítása: `rotation_distance = <previous_rotation_distance> * <actual_extrude_distance> / <requested_extrude_distance>` Az új rotation_distance-t három tizedesjegyre kerekítjük.

Ha az actual_extrude_distance több mint 2 mm-rel eltér a requested_extrude_distance-tól, akkor érdemes a fenti lépéseket másodszor is elvégezni.

Megjegyzés: *Ne* használj "mérés és trimmelés" típusú módszert az X, Y vagy Z típusú tengelyek kalibrálására. A "measure and trim" módszer nem elég pontos ezekhez a tengelyekhez, és valószínűleg rosszabb konfigurációhoz vezet. Ehelyett, ha szükséges, ezeket a tengelyeket [a szíjak, szíjtárcsák és az orsók hardverének mérésével](#a-forgasi_tavolsag-kinyerese-a-hardver-ellenorzesevel) lehet meghatározni.

## A rotation_distance meghatározása a hardver vizsgálatával

Lehetséges a rotation_distance kiszámítása a léptetőmotorok és a nyomtató kinematikájának ismeretében. Ez hasznos lehet, ha a steps_per_mm nem ismert, vagy ha új nyomtatót tervezünk.

### Szíjhajtású tengelyek

Egyszerű kiszámítani a rotation_distance-t egy szíjat és csigát használó lineáris tengely esetében.

Először határozd meg a szíj típusát. A legtöbb nyomtató 2 mm-es fogosztást használ (azaz a szíj minden egyes foga 2 mm távolságra van egymástól). Ezután számold meg a léptetőmotor szíjtárcsája fogainak számát. A rotation_distance ezután a következőképpen számítható ki:

```
rotation_distance = <belt_pitch> * <number_of_teeth_on_pulley>
```

Ha például egy nyomtató 2 mm-es fogosztású szíjjal rendelkezik, és 20 fogú tárcsát használ, akkor a forgatási távolság 40.

### Tengelyek trapézmenetes orsóval

A rotation_distance a szokásos csavarok esetében könnyen kiszámítható a következő képlet segítségével:

```
rotation_distance = <screw_pitch> * <number_of_separate_threads>
```

Például a szokásos "T8-as trapézmenetes orsó" forgatási távolsága 8 (2 mm-es lépésközzel és 4 különálló menettel rendelkezik).

A "menetes szárakkal" ellátott régebbi nyomtatóknak csak egy "menet" van a menetes száron, és így a forgatási távolság a csavar lépésszöge. (A csavar lépésköze a csavaron lévő egyes hornyok közötti távolság.) Így például egy M6-os metrikus menetes szár forgatási távolsága 1, és egy M8-as menetes száré pedig 1,25mm-es.

### Extruder

Az extruderek kezdeti forgatási távolságát úgy lehet meghatározni, hogy megmérjük a "szálmozgató kerék" átmérőjét, amely a szálakat tolja, és a következő képletet használjuk: `rotation_distance = <diameter> * 3.14`

Ha az extruder fogaskerekeket használ, akkor [meg kell határozni és be kell állítani a gear_ratio](#using-a-gear_ratio) értéket az extruderhez.

Az extruder tényleges forgatási távolsága nyomtatóról nyomtatóra változik, mivel a "szálmozgató kerék" fogazása, amely a szálakkal érintkezik, változhat. Ez még az egyes száltekercsek között is változhat. A kezdeti rotation_distance meghatározása után használd a [mérés és trimmelés eljárás](#calibrating-rotation_distance-on-extruders) műveletet a pontosabb beállításhoz.

## A gear_ratio használata

A `gear_ratio` beállítása megkönnyítheti a `rotation_distance` konfigurálását olyan léptetőknél, amelyekhez áttétel (vagy hasonló) van csatlakoztatva. A legtöbb léptető nem rendelkezik áttétellel. Ha nem biztos benne, akkor ne állítsd be a `gear_ratio` értéket a konfigurációban.

Ha `gear_ratio` be van állítva, a `rotation_distance` azt a távolságot jelöli, amelyet a tengely az áttételen lévő utolsó fogaskerék egy teljes elfordulásával megtesz. Ha például egy "5:1"-es áttételt használunk, akkor kiszámíthatjuk a rotation_distance-ot [a hardver ismeretében](#a-forgasi_tavolsag-kinyerese-a-hardver-ellenorzesevel), majd hozzáadhatjuk a `gear_ratio: 5:1` értéket a konfigurációs fájlhoz.

A szíjakkal és szíjtárcsákkal megvalósított hajtóművek esetében a fogaskerekek fogainak megszámlálásával lehet meghatározni a gear_ratio-t. Ha például egy 16 fogazású szíjtárcsával rendelkező léptető meghajtja a, 80 fogazású szíjtárcsát, akkor a `gear_ratio: 80:16` értéket használjuk. Valóban, ki lehetne nyitni egy közönséges, "fogaskerékdobozt" és megszámolni a benne lévő fogakat, hogy megerősítsük a fogaskerék áttételét.

Vedd figyelembe, hogy néha egy áttétel kissé eltér a hirdetett értéktől. A BMG extrudermotorok közös fogaskerekei példát mutatnak erre. A reklámok szerint "3:1", de valójában "50:17" áttételt használnak. (A közös nevező nélküli fogszámok használata javíthatja a fogaskerekek általános kopását, mivel a fogak nem mindig ugyanúgy fognak össze minden egyes fordulatnál.) A gyakori "5,18:1 bolygóműves sebességváltó", pontosabban a `gear_ratio: 57:11` értékkel van konfigurálva.

Ha egy tengelyen több fogaskerék van használatban, akkor a gear_ratio-nak egy vesszővel elválasztott listát lehet megadni. Például egy "5:1" fogaskerék, amely egy 16 fogazású és egy 80 fogazású tárcsát hajt, használhatod a `gear_ratio: 5:1, 80:16` értékeket.

A legtöbb esetben a gear_ratio értékét egész számokkal kell megadni, mivel a fogaskerekek és a szíjtárcsák fogainak száma általában egész. Azokban az esetekben azonban, amikor a szíj fogak helyett súrlódással hajtja a szíjtárcsát, érdemes lehet lebegőpontos számot használni a fogaskerék-áttételben (pl. `gear_ratio: 107,237:16`).
