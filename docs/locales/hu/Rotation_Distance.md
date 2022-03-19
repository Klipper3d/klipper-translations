# Rotation distance

A Klipper léptetőmotor-meghajtók minden [léptető konfigurációs szakaszban](Config_Reference.md#stepper) megkövetelnek egy `rotation_distance` paramétert. A `rotation_distance` az a távolság, amelyet a tengely a léptetőmotor egy teljes fordulatával elmozdít. Ez a dokumentum leírja, hogyan lehet ezt az értéket beállítani.

## A rotation_distance kinyerése a steps_per_mm (vagy step_distance) értékből

A 3d nyomtató tervezői eredetileg `steps_per_mm` forgási távolságból számították ki. Ha ismeri a steps_per_mm értéket, akkor ezzel az általános képlettel megkaphatja ezt az eredeti forgási távolságot:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> / <steps_per_mm>
```

Vagy ha régebbi Klipper-konfigurációval rendelkezik, és ismeri a `step_distance` paramétert, akkor használhatja ezt a képletet:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> * <step_distance>
```

A `<full_steps_per_rotation>` beállítást a léptetőmotor típusa határozza meg. A legtöbb léptetőmotor "1,8 fokos lépésszögű" és ezért 200 teljes lépés/fordulat (360 osztva 1,8-al 200). Egyes léptetőmotorok "0,9 fokos lépésszögűek" és így 400 teljes lépést tesznek meg fordulatonként. Más léptetőmotorok ritkábbak. Ha bizonytalan, ne állítsa be a full_steps_per_rotation értéket a konfigurációs fájlban, és használja a 200-at a fenti képletben.

A `<mikrolépések>` beállítást a léptetőmotor-meghajtó határozza meg. A legtöbb meghajtó 16 mikrolépést használ. Ha bizonytalan, állítsa be a `microsteps: 16` a konfigurációban, és használja a 16-ot a fenti képletben.

Almost all printers should have a whole number for `rotation_distance` on X, Y, and Z type axes. If the above formula results in a rotation_distance that is within .01 of a whole number then round the final value to that whole_number.

## A rotation_distance kalibrálása extrudereken

Egy extruder esetében a `rotation_distance` az a távolság, amelyet a nyomtatószál léptetőmotor egy teljes fordulatán megtesz. Ennek a beállításnak a pontos értékét a "mérés és igazítás" eljárással lehet a legjobban meghatározni.

Először is kezdjük a forgási távolság kezdeti becslésével. Ezt a [steps_per_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance) vagy [a hardver vizsgálata](#extruder) segítségével kaphatjuk meg.

Ezután a következő eljárást alkalmazza a "mérés és igazítás" elvégzéséhez:

1. Győződjön meg arról, hogy az extruderben van-e nyomtatószál, a hotend megfelelő hőmérsékletre van-e melegítve, és a nyomtató készen áll-e az extrudálásra.
1. Jelölje meg a nyomtatószálat egy jelölővel az extrudertest szívónyílásától kb. 70 mm-re. Ezután egy digitális tolómérővel mérje meg a lehető legpontosabban ennek a jelölésnek a tényleges távolságát. Ezt jegyezze fel `<initial_mark_distance>`.
1. Extrude 50mm of filament with the following command sequence: `G91` followed by `G1 E50 F60`. Note 50mm as `<requested_extrude_distance>`. Wait for the extruder to finish the move (it will take about 50 seconds). It is important to use the slow extrusion rate for this test as a faster rate can cause high pressure in the extruder which will skew the results. (Do not use the "extrude button" on graphical front-ends for this test as they extrude at a fast rate.)
1. A digitális tolómérővel mérje meg az extruder teste és a szálon lévő jelölés közötti új távolságot. Ezt jegyezze fel `<subsequent_mark_distance>`. Ezután számítsa ki: `actual_extrude_distance = <initial_mark_distance> - <subsequent_mark_distance>`
1. A rotation_distance kiszámítása: `rotation_distance = <previous_rotation_distance> * <actual_extrude_distance> / <requested_extrude_distance>` Az új rotation_distance-t három tizedesjegyre kerekítjük.

Ha az actual_extrude_distance több mint 2 mm-rel eltér a requested_extrude_distance-tól, akkor érdemes a fenti lépéseket másodszor is elvégezni.

Megjegyzés: Ne használjon *nem* "mérés és trimmelés" típusú módszert az x, y vagy z típusú tengelyek kalibrálására. A "measure and trim" módszer nem elég pontos ezekhez a tengelyekhez, és valószínűleg rosszabb konfigurációhoz vezet. Ehelyett, ha szükséges, ezeket a tengelyeket [a szíjak, a szíjtárcsák és az ólomcsavarok hardverének mérésével](#obtaining-rotation_distance-by-inspecting-the-hardware) lehet meghatározni.

## A rotation_distance meghatározása a hardver vizsgálatával

Lehetséges a rotation_distance kiszámítása a léptetőmotorok és a nyomtató kinematikájának ismeretében. Ez hasznos lehet, ha a steps_per_mm nem ismert, vagy ha új nyomtatót tervezünk.

### Szíjhajtású tengelyek

Egyszerű kiszámítani a rotation_distance-t egy szíjat és csigát használó lineáris tengely esetében.

Először határozza meg a szíj típusát. A legtöbb nyomtató 2 mm-es fogosztást használ (azaz a szalag minden egyes foga 2 mm távolságra van egymástól). Ezután számolja meg a léptetőmotor szíjtárcsájának fogainak számát. A rotation_distance ezután a következőképpen számítható ki:

```
rotation_distance = <belt_pitch> * <number_of_teeth_on_pulley>
```

Ha például egy nyomtató 2 mm-es fogosztású szíjjal rendelkezik, és 20 fogú tárcsát használ, akkor a forgási távolság 40.

### Tengelyek trapézmenetes orsóval

A rotation_distance a szokásos csavarok esetében könnyen kiszámítható a következő képlet segítségével:

```
rotation_distance = <screw_pitch> * <number_of_separate_threads>
```

Például a szokásos "T8-as trapézmenetes orsó" forgási távolsága 8 (2 mm-es lépésközzel és 4 különálló menettel rendelkezik).

A "menetes szárakkal" ellátott régebbi nyomtatóknak csak egy "menet" van a menetes száron, és így a forgási távolság a csavar lépésszöge. (A csavar lépésköze a csavaron lévő egyes hornyok közötti távolság.) Így például egy M6-os metrikus menetes szár forgási távolsága 1, és egy M8-as menetes száré pedig 1,25mm-es.

### Extruder

Az extruderek kezdeti forgási távolságát úgy lehet meghatározni, hogy megmérjük a "szálmozgató kerék" átmérőjét, amely a szálakat tolja, és a következő képletet használjuk: `rotation_distance = <diameter> * 3.14`

Ha az extruder fogaskerekeket használ, akkor [meg kell határozni és be kell állítani a gear_ratio-t](#using-a-gear_ratio) értéket az extruderhez.

Az extruder tényleges forgási távolsága nyomtatóról nyomtatóra változik, mivel a "szálmozgató kerék" fogása, amely a szálakkal érintkezik, változhat. Ez még az egyes száltekercsek között is változhat. A kezdeti rotation_distance meghatározása után használja a [mérés és trimmelés eljárás](#calibrating-rotation_distance-on-extruders) műveletet a pontosabb beállításhoz.

## Gear_ratio használata

A `gear_ratio` beállítása megkönnyítheti a `rotation_distance` konfigurálását olyan léptetőknél, amelyekhez áttétel (vagy hasonló) van csatlakoztatva. A legtöbb léptető nem rendelkezik áttétellel. Ha nem biztos benne, akkor ne állítsa be a `gear_ratio` értéket a konfigurációban.

Ha `gear_ratio` be van állítva, a `rotation_distance` azt a távolságot jelöli, amelyet a tengely az áttételen lévő utolsó fogaskerék egy teljes elfordulásával megtesz. Ha például egy "5:1"-es áttételt használunk, akkor kiszámíthatjuk a rotation_distance-ot [a hardver ismeretében](#obtaining-rotation_distance-by-inspecting-the-hardware), majd hozzáadhatjuk a `gear_ratio: 5:1` értéket a konfigurációs fájlhoz.

A szíjakkal és szíjtárcsákkal megvalósított hajtóművek esetében a fogaskerekek fogainak megszámlálásával lehet meghatározni a gear_ratio-t. Ha például egy 16 fogazású szíjtárcsával rendelkező léptető meghajtja a, 80 fogazású szíjtárcsát, akkor a `gear_ratio: 80:16` értéket használjuk. Valóban, ki lehetne nyitni egy közönséges, "fogaskerékdobozt" és megszámolni a benne lévő fogakat, hogy megerősítsük a fogaskerék áttételét.

Note that sometimes a gearbox will have a slightly different gear ratio than what it is advertised as. The common BMG extruder motor gears are an example of this - they are advertised as "3:1" but actually use "50:17" gearing. (Using teeth numbers without a common denominator may improve overall gear wear as the teeth don't always mesh the same way with each revolution.) The common "5.18:1 planetary gearbox", is more accurately configured with `gear_ratio: 57:11`.

If several gears are used on an axis then it is possible to provide a comma separated list to gear_ratio. For example, a "5:1" gear box driving a 16 toothed to 80 toothed pulley could use `gear_ratio: 5:1, 80:16`.

In most cases, gear_ratio should be defined with whole numbers as common gears and pulleys have a whole number of teeth on them. However, in cases where a belt drives a pulley using friction instead of teeth, it may make sense to use a floating point number in the gear ratio (eg, `gear_ratio: 107.237:16`).
