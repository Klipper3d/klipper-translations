# TMC meghajtók

Ez a dokumentum a Trinamic léptetőmotor-meghajtók SPI/UART üzemmódban történő Klipperben való használatáról nyújt információt.

A Klipper a Trinamic illesztőprogramokat is tudja használni "standalone módban". Ha azonban az illesztőprogramok ebben az üzemmódban vannak, nincs szükség speciális Klipper konfigurációra, és az ebben a dokumentumban tárgyalt fejlett Klipper funkciók nem állnak rendelkezésre.

Ezen a dokumentumon kívül feltétlenül tekintse át a [TMC illesztőprogram-konfigurációs hivatkozást](Config_Reference.md#tmc-stepper-driver-configuration).

## Motoráram hangolása

A nagyobb meghajtóáram növeli a pozicionálási pontosságot és a nyomatékot. A nagyobb áram azonban növeli a léptetőmotor és a léptetőmotor-meghajtó által termelt hőt is. Ha a léptetőmotor-meghajtó túlságosan felmelegszik, akkor kikapcsolja magát, és a Klipper hibát jelez. Ha a léptetőmotor túlságosan felmelegszik, veszít a nyomatékból és a pozícionálási pontosságból. (Ha nagyon felforrósodik, akkor a hozzáérő vagy a közelében lévő műanyag alkatrészeket is megolvaszthatja.)

As a general tuning tip, prefer higher current values as long as the stepper motor does not get too hot and the stepper motor driver does not report warnings or errors. In general, it is okay for the stepper motor to feel warm, but it should not become so hot that it is painful to touch.

## Prefer to not specify a hold_current

If one configures a `hold_current` then the TMC driver can reduce current to the stepper motor when it detects that the stepper is not moving. However, changing motor current may itself introduce motor movement. This may occur due to "detent forces" within the stepper motor (the permanent magnet in the rotor pulls towards the iron teeth in the stator) or due to external forces on the axis carriage.

Most stepper motors will not obtain a significant benefit to reducing current during normal prints, because few printing moves will leave a stepper motor idle for sufficiently long to activate the `hold_current` feature. And, it is unlikely that one would want to introduce subtle print artifacts to the few printing moves that do leave a stepper idle sufficiently long.

If one wishes to reduce current to motors during print start routines, then consider issuing [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) commands in a [START_PRINT macro](Slicers.md#klipper-gcode_macro) to adjust the current before and after normal printing moves.

Some printers with dedicated Z motors that are idle during normal printing moves (no bed_mesh, no bed_tilt, no Z skew_correction, no "vase mode" prints, etc.) may find that Z motors do run cooler with a `hold_current`. If implementing this then be sure to take into account this type of uncommanded Z axis movement during bed leveling, bed probing, probe calibration, and similar. The `driver_TPOWERDOWN` and `driver_IHOLDDELAY` should also be calibrated accordingly. If unsure, prefer to not specify a `hold_current`.

## Setting "spreadCycle" vs "stealthChop" Mode

Alapértelmezés szerint a Klipper a TMC meghajtókat "spreadCycle" üzemmódba helyezi. Ha a meghajtó támogatja a "stealthChop" módot, akkor azt a `stealthchop_threshold hozzáadásával lehet engedélyezni: 999999` a TMC konfigurációs szakaszához.

In general, spreadCycle mode provides greater torque and greater positional accuracy than stealthChop mode. However, stealthChop mode may produce significantly lower audible noise on some printers.

Tests comparing modes have shown an increased "positional lag" of around 75% of a full-step during constant velocity moves when using stealthChop mode (for example, on a printer with 40mm rotation_distance and 200 steps_per_rotation, position deviation of constant speed moves increased by ~0.150mm). However, this "delay in obtaining the requested position" may not manifest as a significant print defect and one may prefer the quieter behavior of stealthChop mode.

Javasoljuk, hogy mindig a "spreadCycle" módot használja (nem megadva a `stealthchop_threshold` értéket) vagy mindig a "stealthChop" módot (a `stealthchop_threshold` 999999-re állítva). Sajnos a meghajtók gyakran rossz és zavaros eredményeket produkálnak, ha a mód változik, miközben a motor nem álló állapotban van.

## TMC interpolate setting introduces small position deviation

The TMC driver `interpolate` setting may reduce the audible noise of printer movement at the cost of introducing a small systemic positional error. This systemic positional error results from the driver's delay in executing "steps" that Klipper sends it. During constant velocity moves, this delay results in a positional error of nearly half a configured microstep (more precisely, the error is half a microstep distance minus a 512th of a full step distance). For example, on an axis with a 40mm rotation_distance, 200 steps_per_rotation, and 16 microsteps, the systemic error introduced during constant velocity moves is ~0.006mm.

For best positional accuracy consider using spreadCycle mode and disable interpolation (set `interpolate: False` in the TMC driver config). When configured this way, one may increase the `microstep` setting to reduce audible noise during stepper movement. Typically, a microstep setting of `64` or `128` will have similar audible noise as interpolation, and do so without introducing a systemic positional error.

If using stealthChop mode then the positional inaccuracy from interpolation is small relative to the positional inaccuracy introduced from stealthChop mode. Therefore tuning interpolation is not considered useful when in stealthChop mode, and one can leave interpolation in its default state.

## Érzékelő nélküli kezdőpont

Az érzékelő nélküli kezdőpont lehetővé teszi a tengely kezdőpont felvételét fizikai végálláskapcsoló nélkül. Ehelyett a tengelyen lévő kocsit a mechanikus végállásba mozgatja, így a léptetőmotor lépéseket veszít. A léptető meghajtó érzékeli az elveszett lépéseket, és ezt egy pin kapcsolásával jelzi a vezérlő MCU-nak (Klipper). Ezt az információt a Klipper a tengely végállásaként használhatja.

Ez az útmutató az érzékelő nélküli kezdőpont fevétel beállítását mutatja be a (cartesian) nyomtató X tengelyére. Ez azonban ugyanígy működik az összes többi tengely esetében is (amelyek végállást igényelnek). Egyszerre csak egy tengelyre kell beállítani és hangolni.

### Korlátozások

Győződjön meg arról, hogy a mechanikus alkatrészek képesek kezelni a tengely határértékének ismételt ütközéséből eredő terhelést. Különösen a szíjak nagy erőt fejthetnek ki. A Z tengelynek a fúvókával az ágyba való ütközéssel történő szintezése nem biztos, hogy jó ötlet. A legjobb eredmény érdekében ellenőrizze, hogy a tengelyn lévő kocsi szilárdan érintkezik-e a tengelyhatárral.

Továbbá, az érzékelő nélküli kezdőpont felvétel nem biztos, hogy elég pontos az Ön nyomtatója számára. Míg az X és Y tengelyek kezdőpont felvétele egy cartesian gépen jól működhet, a Z tengely kezdőpont felvétele általában nem elég pontos, és következetlen első rétegmagasságot eredményezhet. A delta nyomtató érzékelő nélküli kezdőpont felvétele a pontatlanság miatt nem tanácsos.

Továbbá a léptető meghajtó elakadásérzékelése a motor mechanikai terhelésétől, a motoráramtól és a motor hőmérsékletétől (tekercsellenállástól) is függ.

Az érzékelő nélküli kezdőpont felvétel közepes motorsebességnél működik a legjobban. Nagyon lassú fordulatszámoknál (kevesebb mint 10 fordulat/perc) a motor nem termel jelentős ellenáramot, és a TMC nem képes megbízhatóan érzékelni a motor leállását. Továbbá, nagyon nagy fordulatszámon a motor ellen-EMF-je megközelíti a motor tápfeszültségét, így a TMC már nem képes érzékelni a leállást. Javasoljuk, hogy tekintse meg az adott TMC-k adatlapját. Ott további részleteket is találhat ennek a beállításnak a korlátairól.

### Előfeltételek

Néhány előfeltétel szükséges az érzékelő nélküli kezdőpont felvétel használatához:

1. StallGuard-képes TMC léptetőmeghajtó (TMC2130, TMC2209, TMC2660 vagy TMC5160).
1. A TMC-meghajtók SPI/UART interfésze mikrokontrollerrel összekötve (a stand-alone üzemmód nem működik).
1. A TMC motorvezérlő megfelelő "DIAG" vagy "SG_TST" tűje a mikrovezérlőhöz csatlakoztatva.
1. A [konfiguráció ellenőrzések](Config_checks.md) dokumentumban szereplő lépéseket kell lefuttatni annak megerősítésére, hogy a léptetőmotorok megfelelően vannak konfigurálva és működnek.

### Hangolás

Az itt leírt eljárás hat fő lépésből áll:

1. Válassza ki a kezdőpont felvételi sebességet.
1. Konfigurálja a `printer.cfg` fájlt, hogy engedélyezze az érzékelő nélküli kezdőpont felvételt.
1. Keresse meg a legnagyobb érzékenységű StallGuard beállítást, amely sikeresen felveszi a kezdőpontot.
1. Keresse meg a legalacsonyabb érzékenységű StallGuard-beállítást, amely egyetlen érintéssel sikeres megállást jelez.
1. Frissítse a `printer.cfg` állományt a kívánt StallGuard beállítással.
1. Hozzon létre vagy frissítse a `printer.cfg` makrókat, hogy kéznél legyenek.

#### Válassza ki a kezdőpont felvételi sebességet

A kezdőpont felvételi sebesség fontos választás az érzékelő nélküli kezdőpont felvétel során. Ajánlott lassú állítási sebességet használni, hogy a kocsi ne gyakoroljon túlzott erőt a keretre, amikor a sín végével érintkezik. A TMC vezérlők azonban nagyon lassú sebességeknél nem képesek megbízhatóan érzékelni az elakadást.

Az indítási sebességnek jó kiindulópontja az, hogy a léptetőmotor két másodpercenként egy teljes fordulatot végezzen. Sok tengely esetében ez a `rotation_distance` osztva kettővel. Például:

```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### A printer.cfg beállítása érzékelő nélküli kezdőpont felvételhez

A `homing_retract_dist` beállítást nullára kell állítani a `stepper_x` config szakaszban a második kezdőpont felvételi mozdulat letiltásához. A második kezdőpont felvételi kísérlet nem ad hozzáadott értéket az érzékelő nélküli kezdőpont felvételhez, nem fog megbízhatóan működni, és összezavarja a hangolási folyamatot.

Győződjön meg róla, hogy a konfiguráció TMC meghajtó részlegében nincs megadva `hold_current` beállítás. (Ha hold_current használatban van, akkor a kapcsolat létrejötte után a motor megáll, miközben a kocsi a sín végéhez van nyomva, és az áram csökkentése ebben a helyzetben a kocsi mozgását okozhatja. Ez rossz teljesítményt eredményez, és összezavarja a hangolási folyamatot.)

Szükséges a szenzor nélküli kezdőpont felvételi tűk konfigurálása és a kezdeti "StallGuard" beállítások konfigurálása. Egy TMC2209 példakonfiguráció egy X tengelyhez így nézhet ki:

```
[tmc2209 stepper_x]
diag_pin: ^PA1       # A TMC DIAG tűhöz csatlakoztatott MCU tűre állítva.
driver_SGTHRS: 255  # 255 a legérzékenyebb érték, 0 a legkevésbé érzékeny.
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Egy TMC2130 vagy TMC5160 konfiguráció például így nézhet ki:

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # A TMC DIAG1 tűhöz csatlakoztatott tű (vagy használja a diag0_pin / DIAG0 tűt)
driver_SGT: -64  # -64 a legérzékenyebb érték, 63 a legkevésbé érzékeny.
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Egy TMC2660 konfiguráció így nézhet ki:

```
[tmc2660 stepper_x]
driver_SGT: -64      # -64 a legérzékenyebb érték, 63 a legkevésbé érzékeny.
...

[stepper_x]
endstop_pin: ^PA1    # A TMC SG_TST tűjéhez csatlakoztatott tű.
homing_retract_dist: 0
...
```

A fenti példák csak az érzékelő nélküli kezdőpont felvételre jellemző beállításokat mutatják. Az összes elérhető beállításért lásd a [konfigurációs referencia](Config_Reference.md#tmc-stepper-driver-configuration) dokumentumot.

#### Keresse meg a legmagasabb érzékenységet, amely sikeresen jelzi a kezdőpontot

Helyezze a kocsit a sín közepéhez közel. A SET_TMC_FIELD paranccsal állítsa be a legnagyobb érzékenységet. A TMC2209 esetében:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

A TMC2130, TMC5160 és a TMC2660 modellekhez:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

Ezután adjon ki egy `G28 X0` parancsot, és ellenőrizze, hogy a tengely egyáltalán nem mozog. Ha a tengely mozog, akkor adjon ki egy `M112` parancsot a nyomtató leállításához. Valami nem stimmel a diag/sg_tst pin kábelezésével vagy konfigurációjával, ezt a folytatás előtt ki kell javítani.

Ezután folyamatosan csökkentse a `VALUE` beállítás érzékenységét, és futtassa le újra a `SET_TMC_FIELD` `G28 X0` parancsokat, hogy megtalálja a legnagyobb érzékenységet, amely a kocsi sikeres mozgását eredményezi a végállásig és a megállásig. (A TMC2209 meghajtók esetében ez az SGTHRS csökkentése, más meghajtók esetében az sgt növelése lesz.) Ügyeljen arra, hogy minden kísérletet úgy kezdjen, hogy a kocsi a sín közepéhez közel legyen (ha szükséges, adjon ki egy `M84` parancsot, majd kézzel mozgassa a kocsit középállásba). Meg kell találni a legnagyobb érzékenységet, amely megbízhatóan jelzi a végállást (a nagyobb érzékenységű beállítások kicsi vagy semmilyen mozgást nem eredményeznek). Jegyezze fel a kapott értéket *maximum_sensitivity* néven. (Ha a lehető legkisebb érzékenységet (SGTHRS=0 vagy sgt=63) kapjuk a kocsi elmozdulása nélkül, akkor valami nincs rendben a diag/sg_tst tűk bekötésével vagy konfigurációjával, és a folytatás előtt ki kell javítani.)

A maximum_sensitivity keresésekor kényelmes lehet a különböző VALUE beállításokra ugrani (a VALUE paraméter kettéosztása érdekében). Ha ezt tesszük, akkor készüljünk fel arra, hogy a nyomtató leállításához adjunk ki egy `M112` parancsot, mivel egy nagyon alacsony érzékenységű beállítás miatt a tengely többször "beleütközhet" a sín végébe.

Ügyeljen arra, hogy várjon néhány másodpercet minden egyes végállási kísérlet között. Miután a TMC-illesztőprogram érzékeli az elakadást, eltarthat egy kis ideig, amíg a belső visszajelzője törlődik, és képes lesz egy újabb megállást érzékelni.

Ha a hangolási tesztek során a `G28 X0` parancs nem mozdul el egészen a tengelyhatárig, akkor óvatosan kell eljárni a szabályos mozgatási parancsok kiadásával (pl. `G1`). A Klipper nem fogja helyesen értelmezni a kocsi helyzetét, és a mozgatási parancs nemkívánatos és zavaros eredményeket okozhat.

#### Keresse meg a legalacsonyabb érzékenységet, amely egyetlen érintéssel kezdőponton van

Ha a talált *maximum_sensitivity* értékkel állítja be a tengelyt a sín végére, és egy "egyszeri érintéssel" áll meg, azaz nem szabad, hogy "kattogó" vagy "csattanó" hangot halljon. (Ha a maximális érzékenység mellett csattanó vagy kattogó hang hallatszik, akkor a homing_speed túl alacsony, a meghajtóáram túl alacsony, vagy az érzékelő nélküli kezdőpont felvétel nem jó választás a tengely számára.)

A következő lépés az, hogy a kocsit ismét a sín közepére mozgatjuk, csökkentjük az érzékenységet, és futtatjuk a `SET_TMC_FIELD` `G28 X0` parancsokat. A cél most az, hogy megtaláljuk a legkisebb érzékenységet, amely még mindig azt eredményezi, hogy a kocsi egy "egyetlen érintéssel" sikeresen célba ér. Vagyis nem "bumm" vagy "csatt" a sín végének érintésekor. Jegyezze meg a talált értéket *minimum_sensitivity*.

#### Frissítse a printer.cfg fájlt az érzékenységi értékkel

A *maximum_sensitivity* és *minimum_sensitivity* megállapítása után számológép segítségével kapjuk meg az ajánlott érzékenységet a *minimum_sensitivity + (maximum_sensitivity - minimum_sensitivity)/3* képlettel. Az ajánlott érzékenységnek a minimális és maximális értékek közötti tartományban kell lennie, de valamivel közelebb a minimális értékhez. A végső értéket kerekítse a legközelebbi egész értékre.

A TMC2209 esetében ezt a konfigurációban a `driver_SGTHRS`, más TMC-illesztőprogramok esetében a `driver_SGT` értékkel kell beállítani.

Ha a *maximum_sensitivity* és *minimum_sensitivity* közötti tartomány kicsi (pl. 5-nél kisebb), akkor ez instabil kezdőpont felvételt eredményezhet. A gyorsabb kezdőpont felvételi sebesség növelheti a hatótávolságot és stabilabbá teheti a működést.

Vegye figyelembe, hogy ha bármilyen változás történik az illesztőprogram áramában, az indítási sebességben vagy a nyomtató hardverén, akkor a hangolási folyamatot újra el kell végezni.

#### Makrók használata a kezdőpont felvétel során

Az érzékelő nélküli kezdőpont felvétel befejezése után a kocsi a sín végéhez lesz nyomva, és a léptető erőt fejt ki a keretre, amíg a kocsi el nem mozdul. Jó ötlet egy makrót létrehozni a tengely kezdőpont felvételéhez, és azonnal elmozdítani a kocsit a sín végétől.

Jó ötlet, ha a makró legalább 2 másodperc szünetet tart az érzékelő nélküli kezdőpont felvétel elindítása előtt (vagy más módon biztosítja, hogy a léptetőn 2 másodpercig nem volt mozgás). A késleltetés nélkül lehetséges, hogy a meghajtó belső leállási jelzője még mindig be van állítva egy korábbi mozgás miatt.

It can also be useful to have that macro set the driver current before homing and set a new current after the carriage has moved away.

Egy példamakró így nézhet ki:

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # Set current for sensorless homing
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # Pause to ensure driver stall flag is clear
    G4 P2000
    # Home
    G28 X0
    # Move away
    G90
    G1 X5 F1200
    # Set current during print
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

Az így kapott makró meghívható a [homing_override konfigurációs szakasz](Config_Reference.md#homing_override) vagy a [START_PRINT makró](Slicers.md#klipper-gcode_macro) segítségével.

Vegye figyelembe, hogy ha a vezérlő áramát a kezdőpont felvétel során megváltoztatják, akkor a hangolási folyamatot újra el kell végezni.

### Tippek CoreXY gépek szenzor nélküli kezdőpont felvételéhez

A CoreXY nyomtató X és Y kocsiknál érzékelő nélküli kezdőpont felvételre is van lehetőség. A Klipper a `[stepper_x]` léptetőt használja az X kocsi kezdőpont felvételekor az elakadások érzékelésére, az Y kocsi kezdőpont felvételekor pedig a `[stepper_y]` léptetőt.

Használja a fent leírt hangolási útmutatót, hogy megtalálja a megfelelő "elakadás érzékenységet" az egyes kocsikhoz, de vegye figyelembe a következő korlátozásokat:

1. When using sensorless homing on CoreXY, make sure there is no `hold_current` configured for either stepper.
1. A hangolás során győződjön meg arról, hogy az X és az Y kocsik a sínek közepénél vannak-e minden egyes kezdőpont felvételi kísérlet előtt.
1. A hangolás befejezése után az X és Y kezdőpont felvételét makrók segítségével biztosítsa, hogy először az egyik tengely vegye fel a kezdőpontot, majd mozgassa el a kocsit a tengelyhatártól, tartson legalább 2 másodperc szünetet, majd kezdje el a másik kocsi kezdőpont felvételét. A tengelytől való eltávolodással elkerülhető, hogy az egyik tengelyt akkor indítsuk el, amikor a másik a tengelyhatárhoz van nyomva (ami eltorzíthatja az akadásérzékelést). A szünetre azért van szükség, hogy a meghajtó az újraindítás előtt törölje az elakadás érzékelő puffert.

## Az illesztőprogram beállításainak lekérdezése és diagnosztizálása

The `[DUMP_TMC command](G-Codes.md#dump_tmc) is a useful tool when configuring and diagnosing the drivers. It will report all fields configured by Klipper as well as all fields that can be queried from the driver.

Az összes bejelentett mezőt az egyes meghajtók Trinamic adatlapja határozza meg. Ezek az adatlapok megtalálhatók a [Trinamic weboldalán](https://www.trinamic.com/). A DUMP_TMC eredményeinek értelmezéséhez szerezze be és tekintse át a meghajtó Trinamic adatlapját.

## A driver_XXX beállítások konfigurálása

A Klipper támogatja számos alacsony szintű illesztőprogram-mező konfigurálását a `driver_XXX` beállítások használatával. A [TMC meghajtó konfigurációs hivatkozás](Config_Reference.md#tmc-stepper-driver-configuration) tartalmazza az egyes meghajtótípusokhoz elérhető mezők teljes listáját.

In addition, almost all fields can be modified at run-time using the [SET_TMC_FIELD command](G-Codes.md#set_tmc_field).

E mezők mindegyikét az egyes meghajtók Trinamic adatlapja határozza meg. Ezek az adatlapok megtalálhatók a [Trinamic weboldalán](https://www.trinamic.com/).

Vegye figyelembe, hogy a Trinamic adatlapok néha olyan megfogalmazást használnak, amely összetéveszthet egy magas szintű beállítást (például "hiszterézis vége") egy alacsony szintű mezőértékkel (pl. "HEND"). A Klipperben a `driver_XXX` és a SET_TMC_FIELD mindig azt az alacsony szintű mezőértéket állítja be, amely ténylegesen a meghajtóba íródik. Így például, ha a Trinamic adatlapja szerint 3 értéket kell írni a HEND mezőbe, hogy a "hiszterézis vége" 0 legyen, akkor a `driver_HEND=3` beállításával a 0 magas szintű értéket kapjuk.

## Gyakori kérdések

### Használhatom a StealthChop üzemmódot nyomásszabályozással rendelkező extruderen?

Sokan sikeresen használják a "StealthChop" üzemmódot a Klipper nyomásszabályozással. A Klipper [smooth pressure advance](Kinematics.md#pressure-advance), amely nem vezet be pillanatnyi sebesség változást.

A "StealthChop" üzemmód azonban alacsonyabb motornyomatékot és/vagy nagyobb motorhőt eredményezhet. Lehet, hogy ez az üzemmód megfelelő az Ön adott nyomtatója számára, de az is lehet, hogy nem.

### Folyamatosan kap "Nem tudom olvasni a tmc uart 'stepper_x' regiszter IFCNT" hibákat?

Ez akkor fordul elő, ha a Klipper nem tud kommunikálni egy TMC2208 vagy TMC2209 meghajtóval.

Győződjön meg róla, hogy a motor tápellátása engedélyezve van, mivel a léptetőmotor-meghajtónak általában motoráramra van szüksége, mielőtt kommunikálni tudna a mikrokontrollerrel.

Ha ez a hiba a Klipper első égetése után jelentkezik, akkor a léptető meghajtó korábban olyan állapotba programozódott, amely nem kompatibilis a Klipperrel. Az állapot visszaállításához néhány másodpercre távolítsa el a nyomtatót az áramellátástól (fizikailag húzza ki az USB-t és a hálózati csatlakozót).

Ellenkező esetben ez a hiba általában az UART-tű helytelen huzalozásának vagy az UART-pinbeállítások helytelen Klipper konfigurációjának eredménye.

### Folyamatosan kap "Nem lehet írni tmc spi "stepper_x" register ..." hibát?

Ez akkor fordul elő, ha a Klipper nem tud kommunikálni egy TMC2208 vagy TMC2209 meghajtóval.

Győződjön meg róla, hogy a motor tápellátása engedélyezve van, mivel a léptetőmotor-meghajtónak általában motoráramra van szüksége, mielőtt kommunikálni tudna a mikrokontrollerrel.

Ellenkező esetben ez a hiba általában a helytelen SPI-vezetékezés, az SPI-beállítások helytelen Klipper-konfigurációja vagy az SPI-buszon lévő eszközök hiányos konfigurációjának eredménye.

Ne feledje, hogy ha az illesztőprogram egy megosztott SPI-buszon van több eszközzel, akkor győződjön meg róla, hogy teljes mértékben konfigurálja a Klipperben lévő megosztott SPI-busz minden eszközét. Ha egy megosztott SPI-buszon lévő eszköz nincs konfigurálva, akkor előfordulhat, hogy helytelenül reagál a nem erre szánt parancsokra, és meghiúsul a kívánt eszközzel folytatott kommunikáció. Ha van olyan eszköz egy megosztott SPI-buszon, amelyet nem lehet konfigurálni a Klipperben, akkor a [static_digital_output konfigurációs szakasz](Config_Reference.md#static_digital_output) segítségével állítsa magasra a nem használt eszköz CS-pinjét (hogy ne kísérelje meg használni az SPI-buszt). A tábla vázlata gyakran hasznos referencia annak megállapításához, hogy mely eszközök vannak egy SPI-buszon és a hozzájuk tartozó tűkön.

### Miért kaptam egy "TMC jelentés hiba: ..." hibaüzenetet?

Az ilyen típusú hiba azt jelzi, hogy a TMC-illesztőprogram hibát észlelt, és letiltotta magát. Vagyis a meghajtó abbahagyta a pozícióját, és figyelmen kívül hagyta a mozgási parancsokat. Ha a Klipper azt észleli, hogy egy aktív illesztőprogram letiltotta magát, a nyomtatót "leállítás" állapotba állítja.

Az is lehetséges, hogy a **TMC hiba** leállítása SPI hibák miatt következik be, amelyek megakadályozzák az illesztőprogrammal való kommunikációt (TMC2130, TMC5160 vagy TMC2660). Ebben az esetben gyakori, hogy a jelentett illesztőprogram állapota `000000000` vagy `ffffffffff` - például: `TMC hibát jelent: DRV_STATUS: ffffffff ... ` VAGY `TMC jelentések hiba: READRSP@RDSEL2: 00000000 ... `. Az ilyen hiba oka lehet egy SPI vezetékezési probléma, vagy lehet, hogy a visszaállítás vagy a TMC illesztőprogram meghibásodása.

Néhány gyakori hiba és tipp a diagnosztizáláshoz:

#### TMC reports error: `... ot=1(OvertempError!)`

Ez azt jelzi, hogy a motorvezérlő kikapcsolta magát, mert túl meleg lett. A tipikus megoldások a léptetőmotor áramának csökkentése, a léptetőmotor-meghajtó hűtésének növelése és/vagy a léptetőmotor hűtésének növelése.

#### TMC reports error: `... ShortToGND` OR `LowSideShort`

Ez azt jelzi, hogy a meghajtó letiltotta magát, mert nagyon magas áramot érzékelt a meghajtón keresztül. Ez azt jelezheti, hogy meglazult vagy rövidre zárt vezeték van a léptetőmotorban vagy magához a léptetőmotorhoz futó vezeték hibás.

Ez a hiba akkor is előfordulhat, ha StealthChop üzemmódot használ, és a TMC vezérlő nem képes pontosan megjósolni a motor mechanikai terhelését. (Ha a meghajtó rosszul jósol, akkor előfordulhat, hogy túl nagy áramot küld a motoron keresztül, és ezzel kiváltja saját túláram-érzékelését). Ennek teszteléséhez kapcsolja ki a StealthChop üzemmódot, és ellenőrizze, hogy a hibák továbbra is előfordulnak-e.

#### TMC reports error: `... reset=1(Reset)` OR `CS_ACTUAL=0(Reset?)` OR `SE=0(Reset?)`

Ez azt jelzi, hogy az illesztőprogram a nyomtatás közepén visszaállította magát. Ennek oka lehet feszültség vagy vezetékezési probléma.

#### TMC reports error: `... uv_cp=1(Undervoltage!)`

Ez azt jelzi, hogy a meghajtó alacsony feszültséget észlelt, és letiltotta magát. Ennek oka lehet vezetékezési vagy tápellátási probléma.

### Hogyan tudom beállítani a spreadCycle/coolStep/etc. üzemmódot a motorvezérlőimhez?

A [Trinamic weboldal](https://www.trinamic.com/) tartalmaz útmutatókat az illesztőprogramok konfigurálásához. Ezek az útmutatók gyakran technikai jellegűek, alacsony szintűek, és speciális hardvert igényelhetnek. Ettől függetlenül ez a legjobb információforrás.
