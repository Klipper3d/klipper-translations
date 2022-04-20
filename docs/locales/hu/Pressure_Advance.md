# Nyomásszabályozás

Ez a dokumentum a "nyomás szabályozás" konfigurációs változó adott fúvókához és nyomtatószálhoz való beállításával kapcsolatos információkat tartalmaz. A nyomás szabályozás funkció hasznos lehet a nyákosodás csökkentésében. A nyomás szabályozás megvalósításáról további információkat a [kinematika](Kinematics.md) dokumentumban talál.

## Nyomás szabályozás hangolása

A nyomás szabályozás két hasznos dolgot tesz. Csökkenti a nem extrudált mozgások során fellépő nyákosodást, és csökkenti a kanyarodás során fellépő puffadást. Ez az útmutató a második funkciót (kanyarodás közbeni puffadás csökkentése) használja a hangolás mechanizmusaként.

A nyomás szabályozás kalibrálásához a nyomtatónak konfiguráltnak és működőképesnek kell lennie, mivel a hangolási teszt egy tesztobjektum nyomtatásával és vizsgálatával jár. A teszt lefuttatása előtt érdemes ezt a dokumentumot teljes egészében elolvasni.

A [docs/prints/square_tower.stl](prints/square_tower.stl) fájlban található nagy üreges négyzet G-Kódjának létrehozásához használjon egy szeletelőt. Használjon nagy sebességet (pl. 100 mm/s), nulla kitöltést és durva rétegmagasságot (a rétegmagasságnak a fúvóka átmérőjének 75%-a körül kell lennie). Győződjön meg róla, hogy a szeletelőben minden "dinamikus gyorsításvezérlés" ki van kapcsolva.

Készüljön fel a tesztre a következő G-Kód parancs kiadásával:

```
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
```

Ezzel a paranccsal a fúvóka lassabban halad át a kanyarokon, hogy kiemelje az extrudernyomás hatását. Ezután a direkt extruderrel rendelkező nyomtatók esetében futtassa az alábbi parancsot:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

Hosszú bowdenes extruderekhez:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020
```

Ezután nyomtassa ki az objektumot. Teljesen kinyomtatva a tesztnyomat így néz ki:

![tuning_tower](img/tuning_tower.jpg)

A fenti TUNING_TOWER parancs utasítja a Klippert, hogy a nyomtatás minden egyes rétegénél módosítsa a pressure_advance beállítást. A nyomtatás magasabb rétegeire nagyobb nyomáselőtolási érték lesz beállítva. Az ideális pressure_advance beállítás alatti rétegeknél a sarkoknál pattogás, az ideális beállítás feletti rétegeknél pedig lekerekített sarkok és gyenge extrudálás alakulhat ki a sarokig.

A nyomtatást idő előtt megszakíthatja, ha azt észleli, hogy a sarkok már nem nyomtatnak jól (és így elkerülheti az olyan rétegek nyomtatását, amelyekről ismert, hogy az ideális pressure_advance érték felett vannak).

Ellenőrizze az objektumot, majd digitális tolómérővel mérje meg azt a magasságot, amely a legjobb minőségű sarkokkal rendelkezik. Ha kétségei vannak, válassza az alacsonyabb magasságot.

![tune_pa](img/tune_pa.jpg)

A pressure_advance értéket ezután a következőképpen lehet kiszámítani: `pressure_advance = <start> + <measured_height> * <factor>`. (Például `0 + 12,90 * .020` lenne `.258`.)

Lehetőség van a START és a FACTOR egyéni beállításainak kiválasztására, ha ez segít a legjobb nyomás szabályozás beállítás meghatározásában. Ennek során ügyeljen arra, hogy a TUNING_TOWER parancsot minden egyes próbanyomtatás elején ki kell adni.

A tipikus nyomás szabályozás értékek 0,050 és 1,000 között vannak (a legmagasabb értékek általában csak a bowdenes extrudereknél). Ha az 1,000-ig terjedő nyomás szabályozással nem tapasztalható jelentős javulás, akkor a nyomás szabályozás valószínűleg nem javítja a nyomatok minőségét. Térjen vissza az alapértelmezett konfigurációhoz, ahol a nyomás szabályozás ki van kapcsolva.

Bár ez a hangolási gyakorlat közvetlenül javítja a sarkok minőségét, érdemes megjegyezni, hogy a jó nyomás szabályozási konfiguráció csökkenti a nyomat teljes terjedelmét.

A teszt befejezésekor állítsa be a `pressure_advance = <calculated_value>` értéket a konfigurációs fájl `[extruder]` szakaszában, és adjon ki egy RESTART parancsot. A RESTART parancs törli a tesztállapotot, és visszaállítja a gyorsulási és kanyarodási sebességeket a normál értékekre.

## Fontos megjegyzések

* A nyomás szabályozás értéke az extruder, a fúvóka és a szál függvénye. Gyakori, hogy a különböző gyártóktól származó vagy különböző pigmenteket tartalmazó nyomtatószálak jelentősen eltérő nyomás szabályozási értékeket igényelnek. Ezért minden nyomtatónál és minden egyes tekercs nyomtatószálnál kalibrálni kell a nyomás szabályozást.
* A nyomtatási hőmérséklet és az extrudálási sebesség befolyásolhatja a nyomást. A nyomás szabályozás beállítása előtt mindenképpen hangolja be az [extruder rotation_distance](Rotation_Distance.md#calibrating-rotation_distance-on-extruders) és a [fúvóka hőmérséklet](http://reprap.org/wiki/Triffid_Hunter%27s_Calibration_Guide#Nozzle_Temperature) értékeket.
* A tesztnyomtatást úgy tervezték, hogy nagy extruder-áramlási sebességgel, de egyébként "normál" szeletelő beállításokkal fusson. A nagy áramlási sebességet nagy nyomtatási sebesség (pl. 100 mm/s) és durva rétegmagasság (jellemzően a fúvóka átmérőjének kb. 75%-a) alkalmazásával érjük el. A többi szeletelőbeállításnak hasonlónak kell lennie az alapértelmezettekhez (pl. 2 vagy 3 soros kerület, normál behúzási mennyiség). Hasznos lehet a külső kerület sebességét a nyomtatás többi részével megegyező sebességre állítani, de ez nem követelmény.
* Gyakori, hogy a tesztnyomtatás minden egyes sarkon eltérő viselkedést mutat. Gyakran előfordul, hogy a szeletelő az egyik sarkon rétegváltást hajt végre, ami azt eredményezheti, hogy az a sarok jelentősen eltér a többi három saroktól. Ha ez előfordul, akkor hagyja figyelmen kívül ezt a sarkot, és a másik három sarkot használva hangolja a nyomás szabályozást. Az is gyakori, hogy a fennmaradó sarkok kissé eltérnek. (Ez azért fordulhat elő, mert a nyomtató kerete kis eltérésekkel reagál a bizonyos irányokba történő kanyarodásra.) Próbáljon meg olyan értéket választani, amely az összes többi saroknál jól működik. Ha kétségei vannak, válasszon inkább egy alacsonyabb nyomás szabályozási értéket.
* Ha magas nyomás szabályozási értéket (pl. 0,200 fölött) használunk, akkor előfordulhat, hogy az extruder kihagy, amikor visszatér a nyomtató normál gyorsuláshoz. A nyomás szabályozási rendszer úgy veszi figyelembe a nyomást, hogy gyorsításkor extra szálat tol, és lassításkor visszahúzza ezt a szálat. Nagy gyorsítás és nagy nyomás szabályozás esetén előfordulhat, hogy az extruder nem rendelkezik elegendő nyomatékkal a szükséges szálak kinyomásához. Ha ez bekövetkezik, vagy használjon alacsonyabb gyorsítási értéket, vagy tiltsa le a nyomás szabályozási funkciót.
* Miután a Klipperben beállítottuk a nyomás szabályozást, hasznos lehet kisebb visszahúzási értéket beállítani a szeletelőben (pl. 0,75 mm), és használni a szeletelő "wipe on retract" opciót, ha rendelkezésre áll. Ezek a szeletelő beállítások segíthetnek a szálak kohéziója (a műanyag ragadós volta miatt a fúvókából kihúzott szálak) okozta folyása ellen. Ajánlott a szeletelő "z-lift on retract" opció kikapcsolása.
* A nyomás szabályozási rendszer nem változtatja meg a nymtatófej időzítését vagy útját. A nyomás szabályozással bekapcsolt állapotban ugyanannyi időt vesz igénybe, mint a nyomás szabályozás nélküli nyomtatás. A nyomás szabályozás nem változtatja meg a nyomtatás során extrudált szál teljes mennyiségét sem. A nyomás szabályozás extra extrudermozgást eredményez a mozgás gyorsítása és lassítása során. Egy nagyon magas nyomás szabályozási beállítás nagyon nagy extrudermozgást eredményez a gyorsítás és lassítás során, és semmilyen konfigurációs beállítás nem szab határt ennek a mozgásnak.
