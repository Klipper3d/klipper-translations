# G-kódok

Ez a dokumentum a Klipper által támogatott parancsokat írja le. Ezek olyan parancsok, amelyeket az OctoPrint konzoljába lehet beírni.

## G-kód parancsok

A Klipper a következő szabványos G-kód parancsokat támogatja:

- Move (G0 or G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- Tartózkodás: `G4 P<milliszekundum>`
- Ugrás a forrásra: `G28 [X] [Y] [Z]`
- Kapcsolja ki a motorokat: `M18` vagy `M84`
- Várja meg, amíg az aktuális mozdulat befejeződik: `M400`
- Használjon abszolút/relatív távolságokat az extrudáláshoz: `M82`, `M83`
- Abszolút/relatív koordináták használata: `G90`, `G91`
- Állítsa be a pozíciót: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- A sebességtényező felülbírálási százalékának beállítása: `M220 S<percent>`
- Extrudálási tényező felülbírálási százalékának beállítása: `M221 S<percent>`
- Gyorsítás beállítása: `M204 S<value>` VAGY `M204 P<value> T<value>`
   - Megjegyzés: Ha az S nincs megadva, de a P és a T meg van adva, akkor a gyorsulás a P és a T közül a minimumra van beállítva. Ha a P vagy a T közül csak az egyik van megadva, a parancsnak nincs hatása.
- Extruder hőmérsékletének lekérdezése: `M105`
- Az extruder hőmérsékletének beállítása: `M104 [T<index>] [S<temperature>]`
- Beállítja az extruder hőmérsékletét és várakozik: `M109 [T<index>] S<temperature>`
   - Megjegyzés: Az M109 mindig megvárja, míg a hőmérséklet beáll a kért értékre
- Beállítja az ágy hőmérsékletét: `M140 [S<temperature>]`
- Beállítja az ágy hőmérsékletét és várakozik: `M190 S<temperature>`
   - Megjegyzés: Az M190 mindig megvárja, hogy a hőmérséklet beálljon a kért értékre
- A ventilátor sebességének beállítása: `M106 S<value>`
- Kikapcsolja a ventilátort: `M107`
- Vészleállító: `M112`
- Jelenlegi pozíció lekérdezése: `M114`
- A firmware verziójának lekérdezése: `M115`

A fenti parancsokkal kapcsolatos további részletekért lásd a [RepRap G-kód dokumentáció](http://reprap.org/wiki/G-code) fájlt.

A Klipper célja, hogy támogassa az általános 3. féltől származó szoftverek (pl. OctoPrint, Printrun, Slic3r, Cura, stb.) által generált G-kód parancsokat a szabványos konfigurációikban. Nem cél, hogy minden lehetséges G-kód parancsot támogasson. Ehelyett a Klipper az ember által olvasható ["kiterjesztett G-kód"](#additional-commands) parancsokat részesíti előnyben. Hasonlóképpen, a G-kód terminál kimenete is csak ember által olvasható. Lásd az [API Szerver dokumentumot](API_Server.md), ha a Klippert külső szoftverből irányítod.

Ha egy kevésbé gyakori G-kód parancsra van szükség, akkor azt egy egyéni [gcode_macro config section](Config_Reference.md#gcode_macro) segítségével lehet megvalósítani. Például ezt használhatnánk a következőkre: `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1` stb.

## További parancsok

A Klipper "kiterjesztett" G-kód parancsokat használ az általános konfigurációhoz és állapothoz. Ezek a kiterjesztett parancsok mind hasonló formátumot követnek, egy parancsnévvel kezdődnek, és egy vagy több paraméter követheti őket. Például: `SET_SERVO SERVO=myservo ANGLE=5.3`. Ebben a parancssorban a parancsok és paraméterek nagybetűvel szerepelnek, azonban a nagy- és kisbetűket nem kell figyelembe venni. (Tehát a "SET_SERVO" és a "set_servo" mindkettő ugyanazt jelenti.)

Ez a szakasz a Klipper modul neve szerint van rendezve, amely általában a [nyomtató konfigurációs fájlban](Config_Reference.md) megadott szakaszneveket követi. Vegye figyelembe, hogy egyes modulok automatikusan betöltődnek.

### [adxl345]

A következő parancsok akkor érhetők el, ha az [adxl345 konfigurációs szakasz](Config_Reference.md#adxl345) engedélyezve van.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: A gyorsulásmérő mérések elindítása a kért másodpercenkénti mintavételek számával. Ha a CHIP nincs megadva, az alapértelmezett érték "adxl345". A parancs start-stop üzemmódban működik: az első végrehajtáskor elindítja a méréseket, a következő végrehajtáskor leállítja azokat. A mérések eredményei a `/tmp/adxl345-<chip>-<name> .csv nevű fájlba kerülnek kiírásra`, ahol `<chip>` a gyorsulásmérő chip neve (`my_chip_name` from `[adxl345 my_chip_name]`) és `<name>` az opcionális NAME paraméter. Ha a NAME nincs megadva, akkor az alapértelmezett érték az aktuális idő "ÉÉÉÉÉHHNN_ÓÓPPMM" formátumban. Ha a gyorsulásmérőnek nincs neve a konfigurációs szakaszban (egyszerűen `[adxl345]`), akkor a `<chip>` névrész nem generálódik.

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: lekérdezi a gyorsulásmérő aktuális értékét. Ha a CHIP nincs megadva, az alapértelmezett"adxl345". Ha a RATE nincs megadva, az alapértelmezett értéket használja. Ez a parancs hasznos az ADXL345 gyorsulásmérővel való kapcsolat tesztelésére. A visszaadott értékek egyikének a szabadeséses gyorsulásnak kell lennie (+/- a chip alapzaja).

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`: lekérdezi az ADXL345 "register" (pl. 44 vagy 0x2C) regiszterét. Hasznos lehet hibakeresési célokra.

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<register> VAL=<value>`: Nyers "érték" írása a "register"-be. Mind az "érték", mind a "register" lehet decimális vagy hexadecimális egész szám. Használja óvatosan, és hivatkozzon az ADXL345 adatlapjára.

### [angle]

A következő parancsok akkor érhetők el, ha az [szög konfigurációs szakasz](Config_Reference.md#angle) engedélyezve van.

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<chip_name>`: Szögkalibrálás végrehajtása az adott érzékelőn (kell lennie egy `[angle chip_name]` konfigurációs szakasznak, amely megadta a `stepper` paramétert). FONTOS! Ez az eszköz a normál kinematikai határértékek ellenőrzése nélkül adja ki a léptetőmotor mozgását. Ideális esetben a motort a kalibrálás elvégzése előtt le kell választani az adott kocsiról. Ha a léptetőmotor nem kapcsolható le a nyomtatóról, győződjön meg róla, hogy a kocsi a kalibrálás megkezdése előtt a sín közepénél van. (A léptetőmotor két teljes fordulatot előre vagy hátra mozoghat a teszt során.) A teszt elvégzése után használja a `SAVE_CONFIG` parancsot a kalibrációs adatok printer.cfg fájlba történő mentéséhez. Az eszköz használatához telepíteni kell a Python "numpy" csomagot (további információkért lásd a [rezonancia mérése dokumentumot](Measuring_Resonances.md#software-installation).

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: A "regiszter" (pl. 44 vagy 0x2C) érzékelőregiszter lekérdezése. Hasznos lehet hibakeresési célokra. Ez csak a TLE5012B chipek esetében érhető el.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: Nyers "érték" írása a "register" regiszterébe. Mind az "érték", mind a "regiszter" lehet decimális vagy hexadecimális egész szám. Használja óvatosan, és hivatkozzon az érzékelő adatlapjára. Ez csak a TLE5012B chipek esetében érhető el.

### [bed_mesh]

A következő parancsok akkor érhetők el, ha a [bed_mesh konfigurációs szakasz](Config_Reference.md#bed_mesh) engedélyezve van (lásd még az [ágy háló útmutatót](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>] [<mesh_parameter>=<value>]`: Ez a parancs az ágyat a konfigurációban megadott paraméterek által generált pontok segítségével szintezi. A szintezés után egy háló generálódik, és a Z elmozdulás a hálónak megfelelően kerül beállításra. Az opcionális szintező paraméterekkel kapcsolatos részletekért lásd a PROBE parancsot. Ha a METHOD=manual parancsot adta meg, akkor a kézi szintező eszköz aktiválódik. Az eszköz aktiválása közben elérhető további parancsok részleteit lásd a fenti MANUAL_PROBE parancsban.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`: Ez a parancs az aktuális mért Z értékeket és az aktuális hálóértékeket adja ki a terminálra. A PGP=1 megadása esetén a bed_mesh által generált X, Y koordináták és a hozzájuk tartozó indexek kerülnek a terminálra.

#### BED_MESH_MAP

`BED_MESH_MAP`: Ez a parancs a BED_MESH_OUTPUT-hoz hasonlóan a háló aktuális állapotát írja ki a terminálra. Az értékek ember által olvasható formátumban történő kiírása helyett az állapotot JSON formátumban szerializálja. Ez lehetővé teszi az OctoPrint pluginek számára, hogy könnyen rögzítsék az adatokat, és az ágy felszínét közelítő magassági térképeket hozzanak létre.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: Ez a parancs törli a hálót és eltávolít minden Z-beállítást. Ajánlott ezt a parancsot befejező G-kódba tenni.

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<name> SAVE=<name> REMOVE=<name>`: Ez a parancs a háló állapotának profilkezelését biztosítja. A LOAD a háló állapotát a megadott névnek megfelelő profilból állítja vissza. A SAVE parancs az aktuális hálóállapotot a megadott névnek megfelelő profilba menti. A REMOVE a megadott névnek megfelelő profilt törli a tartós memóriából. Megjegyzendő, hogy a SAVE vagy REMOVE műveletek lefuttatása után a SAVE_CONFIG parancsot kell futtatni, hogy a tartós memóriában végrehajtott változtatások véglegesek legyenek.

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<value>] [Y=<value>]`: X és/vagy Y eltolást alkalmazza a hálókereséshez. Ez a független extruderekkel rendelkező nyomtatóknál hasznos, mivel az eltolás szükséges a szerszámcsere utáni helyes Z-beállításhoz.

### [bed_screws]

A következő parancsok akkor érhetők el, ha az [ágyszintező csavarok konfigurációs szakasz](Config_Reference.md#bed_screws) engedélyezve van (lásd még a [kézi szintezés útmutatót](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`: Ez a parancs az ágy állítócsavarok beállítási eszközét hívja elő. A fúvókát különböző helyekre küldi (a konfigurációs fájlban meghatározottak szerint), és lehetővé teszi az ágy állítócsavarok beállítását, hogy az ágy állandó távolságra legyen a fúvókától.

### [bed_tilt]

A következő parancsok akkor érhetők el, ha a [bed_tilt konfigurációs szakasz](Config_Reference.md#bed_tilt) engedélyezve van.

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>]`: Ez a parancs a konfigurációban megadott pontokat vizsgálja, majd frissített X és Y dőlésbeállításokat javasol. Az opcionális mérési paraméterekkel kapcsolatos részletekért lásd a PROBE parancsot. Ha a METHOD=manual van megadva, akkor a kézi szintező aktiválódik. Az ezen eszköz aktiválásakor elérhető további parancsok részleteit lásd a fenti MANUAL_PROBE parancsban.

### [bltouch]

A következő parancs akkor érhető el, ha a [bltouch konfigurációs szakasz](Config_Reference.md#bltouch) engedélyezve van (lásd még a [BL-Touch útmutatót](BLTouch.md)).

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<command>`: Ez egy parancsot küld a BLTouch-nak. Hasznos lehet a hibakereséshez. A rendelkezésre álló parancsok a következők: `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`. A BL-Touch V3.0 vagy V3.1 támogathatja a `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store` parancsokat is.

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`: Ez egy kimeneti módot tárol a BLTouch V3.1 EEPROM-jában: `5V`, `OD`

### [configfile]

A configfile modul automatikusan betöltődik.

#### SAVE_CONFIG

`SAVE_CONFIG`: Ez a parancs felülírja a nyomtató fő konfigurációs fájlját és újraindítja a gazdaszoftvert. Ez a parancs más kalibrálási parancsokkal együtt használható a kalibrációs tesztek eredményeinek tárolására.

### [delayed_gcode]

A következő parancs akkor engedélyezett, ha a [delayed_gcode konfigurációs szakasz](Config_Reference.md#delayed_gcode) engedélyezve van (lásd még a [parancssablon útmutatót](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: Frissíti az azonosított [delayed_gcode] késleltetési időtartamát és elindítja a G-kód végrehajtásának időzítőjét. A 0 érték törli a függőben lévő késleltetett G-kód végrehajtását.

### [delta_calibrate]

A következő parancsok akkor érhetők el, ha a [delta_kalibrate konfigurációs szakasz](Config_Reference.md#linear-delta-kinematics) engedélyezve van (lásd még a [delta kalibrációs útmutatót](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>]`: Ez a parancs az ágy hét pontját vizsgálja meg, és frissített végállások, toronyszögek és sugarak ajánlására szolgál. Az opcionális mérési paraméterekkel kapcsolatos részletekért lásd a PROBE parancsot. Ha a METHOD=manual érték van megadva, akkor a kézi szintezés aktiválódik. Lásd a fenti MANUAL_PROBE parancsot a további parancsok részleteiért, amelyek akkor állnak rendelkezésre, amikor ez az eszköz aktív.

#### DELTA_ANALYZE

`DELTA_ANALYZE`: Ez a parancs a fokozott delta-kalibrálás során használatos. A részletekért lásd a [Delta kalibrálás](Delta_Calibrate.md) című dokumentumot.

### [display]

A következő parancs akkor érhető el, ha a [konfigurációs szakasz megjelenítése](Config_Reference.md#gcode_macro) engedélyezve van.

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`: Az LCD-kijelző aktív kijelzőcsoportjának beállítása. Ez lehetővé teszi több kijelző adatcsoport definiálását a konfigurációban, pl. `[display_data <group> <elementname>]` és a köztük való váltást ezzel a kiterjesztett G-kód paranccsal. Ha a DISPLAY nincs megadva, akkor alapértelmezés szerint "display" (az elsődleges kijelző).

### [display_status]

A display_status modul automatikusan betöltődik, ha a [display konfigurációs szakasz](Config_Reference.md#display) engedélyezve van. A következő szabványos G-kód parancsokat biztosítja:

- Üzenet megjelenítése: `M117 <message>`
- Nyomtatási folyamat százalékos arány beállítása: `M73 P<percent>`

A következő kiterjesztett G-kód parancs is rendelkezésre áll:

- `SET_DISPLAY_TEXT MSG=<message>`: Az M117 paranccsal egyenértékű művelet, amely az `MSG` címen megadott üzenetet állítja be aktuális kijelzőüzenetként. Ha az `MSG` elmarad, a kijelző törlődik.

### [dual_carriage]

A következő parancs akkor érhető el, ha a [dual_carriage konfigurációs szakasz](Config_Reference.md#dual_carriage) engedélyezve van.

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=[0|1]`: Ez a parancs beállítja az aktív kocsit. Általában az activate_gcode és deactivate_gcode mezőkből hívható elő több extruder konfigurációban.

### [endstop_phase]

A következő parancsok akkor érhetők el, ha az [endstop_phase konfigurációs szakasz](Config_Reference.md#endstop_phase) engedélyezve van (lásd még a [végállás fázis útmutatót](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]`: Ha nincs megadva STEPPER paraméter, akkor ez a parancs a múltbeli kezdőpont felvételi műveletek során a végállási lépcsőfázisok statisztikáit jelenti. STEPPER paraméter megadása esetén gondoskodik arról, hogy a megadott végállásfázis-beállítás a konfigurációs fájlba íródjon (a SAVE_CONFIG parancs segítségével).

### [exclude_object]

A következő parancsok akkor érhetők el, ha az [exclude_object konfigurációs szakasz](Config_Reference.md#exclude_object) engedélyezve van (lásd még a [tárgyútmutató kizárása](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=object_name] [CURRENT=1] [RESET=1]`: Paraméterek nélkül az összes jelenleg kizárt objektum listáját adja vissza.

Ha a `NAME` paramétert adjuk meg, a megnevezett objektumot kizárjuk a nyomtatásból.

A `CURRENT` paraméter megadásakor az aktuális objektumot kizárja a nyomtatásból.

A `RESET` paraméter megadásakor a kizárt objektumok listája törlődik. Ezen kívül a `NAME` bevonása csak a megnevezett objektumot fogja visszaállítani. Ez **nyomtatási** hibákat okozhat, ha a rétegek már kihagyásra kerültek.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=object_name [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`: A fájlban lévő objektum összefoglalóját adja meg.

Ha nem adunk meg paramétereket, akkor a Klipper által ismert, definiált objektumok listája jelenik meg. Sztringek listáját adja vissza, kivéve, ha a `JSON` paramétert adjuk meg, ekkor az objektumok adatait JSON formátumban adja vissza.

Ha a `NAME` paraméter szerepel, ez egy kizárandó objektumot határoz meg.

- `NAME`: Ez a paraméter kötelező. Ez a modul más parancsai által használt azonosító.
- `CENTER`: Az objektum X,Y koordinátája.
- `POLYGON`: X,Y koordináták tömbje, amely az objektum körvonalát adja.

A `RESET` paraméter megadásakor az összes definiált objektum törlődik, és az `[exclude_object]` modul visszaáll.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=object_name`: Ez a parancs egy `NAME` paramétert vesz fel, és az aktuális rétegen lévő objektum G-kódjának kezdetét jelöli.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=object_name]`: Az objektum G-kódjának végét jelöli a réteghez. Az `EXCLUDE_OBJECT_START`-al párosul. A `NAME` paraméter opcionális, és csak akkor figyelmeztet, ha a megadott név nem egyezik az aktuális objektummal.

### [extruder]

A következő parancsok akkor érhetők el, ha az [extruder konfigurációs szakasz](Config_Reference.md#extruder) engedélyezve van:

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: Több [extruder](Config_Reference.md#extruder) konfigurációs szakaszokkal rendelkező nyomtatóban ez a parancs megváltoztatja az aktív nyomtatófejet.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Egy extruder léptető nyomástovábbítási paramétereinek beállítása (ahogyan az egy [extruder](Config_Reference.md#extruder) vagy [extruder_stepper](Config_Reference.md#extruder_stepper) konfigurációs szakaszban szerepel). Ha az EXTRUDER nincs megadva, akkor az alapértelmezett érték az aktív hotendben definiált stepper.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: A megadott extruder léptetők "forgási távolság" új értékének beállítása (ahogyan az [extruder](Config_Reference.md#extruder) vagy [extruder_stepper](Config_Reference.md#extruder_stepper) konfigurációs szakaszban meghatározott). Ha a forgási távolság negatív szám, akkor a léptető mozgása inverz lesz (a konfigurációs fájlban megadott léptető irányhoz képest). A megváltoztatott beállítások nem maradnak meg a Klipper visszaállításakor. Óvatosan használja, mivel a kis változtatások túlzott nyomást eredményezhetnek az extruder és a hotend között. Használat előtt végezze el a megfelelő kalibrációt a filamenttel. Ha a 'DISTANCE' érték nincs megadva, akkor ez a parancs az aktuális forgási távolságot adja meg.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<name> MOTION_QUEUE=<name>`: Ez a parancs az EXTRUDER által meghatározott léptetőt (ahogyan az [extruder](Config_Reference.md#extruder) vagy [extruder_stepper](Config_Reference.md#extruder_stepper) konfigurációs szakaszban) meghatározott extruder mozgásához szinkronizálódik a MOTION_QUEUE által meghatározott extruder mozgásához (ahogyan az [extruder](Config_Reference.md#extruder) konfigurációs szakaszban definiálták). Ha a MOTION_QUEUE üres karakterlánc, akkor a léptető deszinkronizálódik az extruder minden mozgására.

#### SET_EXTRUDER_STEP_DISTANCE

Ez a parancs elavult, és a közeljövőben eltávolításra kerül.

#### SYNC_STEPPER_TO_EXTRUDER

Ez a parancs elavult, és a közeljövőben eltávolításra kerül.

### [fan_generic]

A következő parancs akkor érhető el, ha a [fan_generic konfigurációs szakasz](Config_Reference.md#fan_generic) engedélyezve van.

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<speed>` Ez a parancs beállítja a ventilátor sebességét. "speed" 0.0 és 1.0 között kell lennie.

### [filament_switch_sensor]

A következő parancs akkor érhető el, ha a [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) vagy [filament_motion_sensor](Config_Reference.md#filament_motion_sensor) konfigurációs szakasz engedélyezve van.

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`: A nyomtatószál-érzékelő aktuális állapotának lekérdezése. A terminálon megjelenő adatok a konfigurációban meghatározott érzékelőtípustól függnek.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]`: A nyomtatószál érzékelő be/ki kapcsolása. Ha az ENABLE értéke 0, akkor a nyomtatószál-érzékelő ki lesz kapcsolva, ha 1-re van állítva, akkor bekapcsol.

### [firmware_retraction]

A következő szabványos G-kódú parancsok állnak rendelkezésre, ha a [firmware_retraction konfigurációs szakasz](Config_Reference.md#firmware_retraction) engedélyezve van. Ezek a parancsok lehetővé teszik a szeletelőkben elérhető firmware retraction funkció kihasználását, hogy csökkentse a húrosodást a nem extrudálásos mozgások során a nyomtatás egyik részéből a másikba. A nyomás előtolás megfelelő beállítása csökkenti a szükséges visszahúzás hosszát.

- `G10`: Visszahúzza a nyomtatószálat a konfigurált paraméterek szerint.
- `G11`: Betölti a nyomtatószálat a konfigurált paraméterek szerint.

A következő további parancsok is rendelkezésre állnak.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>]`: A firmware visszahúzás által használt paraméterek beállítása. A RETRACT_LENGTH határozza meg a visszahúzandó és a visszahúzást megszüntető szál hosszát. A visszahúzás sebessége a RETRACT_SPEED segítségével állítható be, és általában viszonylag magasra van állítva. A visszahúzás sebességét az UNRETRACT_SPEED segítségével állítjuk be, és nem különösebben kritikus, bár gyakran alacsonyabb, mint a RETRACT_SPEED. Bizonyos esetekben hasznos, ha a visszahúzáskor egy kis plusz hosszúságot adunk hozzá, és ezt az UNRETRACT_EXTRA_LENGTH segítségével állítjuk be. A SET_RETRACTION általában a szeletelő szálankénti konfiguráció részeként kerül beállításra, mivel a különböző szálak különböző paraméterbeállításokat igényelnek.

#### GET_RETRACTION

`GET_RETRACTION`: A firmware visszahúzás által használt aktuális paraméterek lekérdezése és megjelenítése a terminálon.

### [force_move]

A force_move modul automatikusan betöltődik, azonban néhány parancshoz szükséges az `enable_force_move` beállítása a [nyomtató konfig](Config_Reference.md#force_move)-ban.

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<config_name>`: Az adott léptetőmotor mozgatása egy mm-t előre, majd egy mm-t hátra, 10 alkalommal megismételve. Ez egy diagnosztikai eszköz, amely segít a léptető kapcsolatának ellenőrzésében.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]`: Ez a parancs az adott léptetőmotort az adott távolságon (mm-ben) a megadott állandó sebességgel (mm/mp-ben) kényszerrel mozgatja. Ha az ACCEL meg van adva, és nagyobb, mint nulla, akkor a megadott gyorsulás (mm/mp^2-en) kerül alkalmazásra; egyébként nem történik gyorsítás. Nem történik határérték ellenőrzés; nem történik kinematikai frissítés; a tengelyen lévő más párhuzamos léptetők nem kerülnek mozgatásra. Legyen óvatos, mert a helytelen parancs kárt okozhat! A parancs használata szinte biztosan helytelen állapotba hozza az alacsony szintű kinematikát; a kinematika visszaállításához adjon ki utána egy G28 parancsot. Ez a parancs alacsony szintű diagnosztikára és hibakeresésre szolgál.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>]`: Kényszeríti az alacsony szintű kinematikai kódot, hogy azt higgye, a nyomtatófej a megadott cartesian pozícióban van. Ez egy diagnosztikai és hibakeresési parancs; használja a SET_GCODE_OFFSET és/vagy a G92 parancsot a normál tengelytranszformációkhoz. Ha egy tengely nincs megadva, akkor alapértelmezés szerint az a pozíció lesz, ahová a fejet utoljára parancsolták. A helytelen vagy érvénytelen pozíció beállítása belső szoftverhibához vezethet. Ez a parancs érvénytelenítheti a későbbi határérték ellenőrzéseket; a kinematika visszaállításához adjon ki egy G28 parancsot.

### [gcode]

A G-kód modul automatikusan betöltődik.

#### RESTART

`RESTART`: Ez arra készteti a gazdaszoftvert, hogy újratöltse a konfigurációját és belső alaphelyzetbe állítást végezzen. Ez a parancs nem törli a mikrokontroller hibaállapotát (lásd FIRMWARE_RESTART), és nem tölt be új szoftvert (lásd a [GYIK](FAQ.md#how-do-i-upgrade-to-the-latest-software) oldalt).

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`: Ez hasonló a RESTART parancshoz, de a mikrokontroller hibaállapotát is törli.

#### STATUS

`STATUS`: Jelentse a Klipper gazdagép szoftver állapotát.

#### SÚGÓ

`HELP`: A rendelkezésre álló kiterjesztett G-kód parancsok listájának megjelenítése.

### [gcode_arcs]

A következő szabványos G-kód parancsok elérhetők, ha a [gcode_arcs config section](Config_Reference.md#gcode_arcs) engedélyezve van:

- Vezérelt ívmozgás (G2 vagy G3): `G2 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>`

### [gcode_macro]

A következő parancs akkor érhető el, ha a [gcode_macro konfigurációs szakasz](Config_Reference.md#gcode_macro) engedélyezve van (lásd még a [parancssablonok útmutatóját](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`: Ez a parancs lehetővé teszi a gcode_macro változó értékének megváltoztatását üzem közben. A megadott VALUE-t Python literálként elemzi a program.

### [gcode_move]

A gcode_move modul automatikusan betöltődik.

#### GET_POSITION

`GET_POSITION`: A nyomtatófej aktuális helyzetére vonatkozó információk visszaadása. További információkért lásd a [GET_POSITION kimenet](Code_Overview.md#coordinate-systems) fejlesztői dokumentációját.

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Pozíciós eltolás beállítása, amelyet a későbbi G-kód parancsokra kell alkalmazni. Ezt általában a Z ágy eltolás virtuális megváltoztatására vagy a fúvókák XY eltolásának beállítására használják extruder váltáskor. Például, ha a "SET_GCODE_OFFSET Z=0.2" parancsot küldjük, akkor a jövőbeli G-kód mozgások Z magasságához 0,2 mm-t adunk hozzá. Ha az X_ADJUST stílusparamétereket használjuk, akkor a kiigazítás hozzáadódik a meglévő eltoláshoz (pl. a "SET_GCODE_OFFSET Z=-0.2" és a "SET_GCODE_OFFSET Z_ADJUST=0.3" utána a teljes Z eltolás 0.1 lesz). Ha a "MOVE=1" van megadva, akkor a nyomtatófej mozgatása a megadott eltolás alkalmazására történik (egyébként az eltolás a következő abszolút G-kódú mozgatáskor lép hatályba, amely az adott tengelyt adja meg). Ha a "MOVE_SPEED" meg van adva, akkor a szerszámfej mozgatása a megadott sebességgel (mm/mp-ben) történik; egyébként a nyomtatófej mozgatása az utoljára megadott G-kód sebességet fogja használni.

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<state_name>]`: Az aktuális G-kód koordináták elemzési állapotának mentése. A G-kód állapotának mentése és visszaállítása hasznos a szkriptekben és makrókban. Ez a parancs elmenti az aktuális G-kód abszolút koordinátamódot (G90/G91), az abszolút extrudálási módot (M82/M83), az origót (G92), az eltolást (SET_GCODE_OFFSET), a sebesség felülbírálását (M220), az extruder felülbírálását (M221), a mozgási sebességet, az aktuális XYZ pozíciót és a relatív extruder "E" pozíciót. A NAME megadása esetén lehetővé teszi, hogy a mentett állapotot a megadott karakterláncnak nevezzük el. Ha a NAME nincs megadva, az alapértelmezett érték "default".

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`: A SAVE_GCODE_STATE segítségével korábban elmentett állapot visszaállítása. Ha "MOVE=1" van megadva, akkor a nyomtatófej mozgatása az előző XYZ-pozícióba való visszalépéshez történik. Ha "MOVE_SPEED" van megadva, akkor a nyomtatófej mozgatása a megadott sebességgel (mm/mp-ben) történik; egyébként a nyomtatófej mozgatása a visszaállított G-kód sebességét használja.

### [hall_filament_width_sensor]

A következő parancsok akkor érhetők el, ha a [tsl1401cl szálszélesség érzékelő konfigurációs szakasz](Config_Reference.md#tsl1401cl_filament_width_sensor) vagy a [hall szálszélesség érzékelő konfigurációs szakasz](Config_Reference.md#hall_filament_width_sensor) engedélyezve van (lásd még [TSLll401CL Szálszélesség érzékelő](TSL1401CL_Filament_Width_Sensor.md) és a [Hall Szálszélesség érzékelő](Hall_Filament_Width_Sensor.md) dokumentumot):

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`: Visszaadja az aktuálisan mért izzószál szélességet.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`: Törli az összes érzékelő leolvasását. Hasznos nyomtatószál csere után.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`: Kapcsolja ki a szálszélesség érzékelőt, és ne használja áramlásszabályozáshoz.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR`: Kapcsolja be a szálszélesség érzékelőt, és kezdje el használni az áramlásszabályozáshoz.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`: Visszaadja az ADC-csatorna aktuális leolvasását és a RAW-érzékelő értékét a kalibrációs pontokhoz.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`: Az átmérő naplózásának bekapcsolása.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`: Az átmérő naplózásának kikapcsolása.

### [heaters]

A fűtőmodul automatikusan betöltődik, ha a konfigurációs fájlban van fűtőelem definiálva.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`: Kapcsolja ki az összes fűtőberendezést.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Várjon, amíg az adott hőmérséklet-érzékelő a megadott MINIMUM értéken vagy a megadott MINIMUM érték felett és/vagy a megadott MAXIMUM értéken vagy az alatt van.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<heater_name> [TARGET=<target_temperature>]`: A fűtőtest célhőmérsékletének beállítása. Ha nincs megadva célhőmérséklet, akkor az érték 0.

### [idle_timeout]

Az idle_timeout modul automatikusan betöltődik.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: Lehetővé teszi a felhasználó számára az üresjárati időkorlát beállítását (másodpercben).

### [input_shaper]

A következő parancs akkor engedélyezett, ha az [input_shaper konfigurációs szakasz](Config_Reference.md#input_shaper) engedélyezve van (lásd még a [rezonancia kompenzációs útmutatót](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`: A bemeneti formáló paraméterek módosítása. Vegye figyelembe, hogy a SHAPER_TYPE paraméter visszaállítja a bemeneti formálót mind az X, mind az Y tengelyre, még akkor is, ha az [input_shaper] szakaszban különböző formálótípusok lettek beállítva. A SHAPER_TYPE nem használható együtt a SHAPER_TYPE_X és SHAPER_TYPE_Y paraméterekkel. Az egyes paraméterekkel kapcsolatos további részletekért lásd a [konfigurációs hivatkozást](Config_Reference.md#input_shaper).

### [manual_probe]

A manual_probe modul automatikusan betöltődik.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`: Egy segédszkript futtatása, amely hasznos a fúvóka magasságának méréséhez egy adott helyen. Ha SPEED van megadva, akkor a TESTZ parancsok sebességét állítja be (az alapértelmezett 5 mm/mp). A kézi mérés során a következő további parancsok állnak rendelkezésre:

- `ACCEPT`: Ez a parancs elfogadja az aktuális Z pozíciót, és lezárja a kézi szintező eszközt.
- `ABORT`: Ez a parancs megszakítja a kézi szintezést.
- `TESTZ Z=<value>`: Ez a parancs a fúvókát a "value" értékben megadott értékkel felfelé vagy lefelé mozgatja. Például a `TESTZ Z=-.1` a fúvókát 0,1 mm-rel lefelé, míg a `TESTZ Z=.1` a fúvókát 0,1 mm-rel felfelé mozgatja. Az érték lehet `+`, `-`, `++`, vagy `--` is, hogy a fúvókát a korábbi próbálkozásokhoz képest felfelé vagy lefelé mozdítsa.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: Egy segédszkript futtatása, amely hasznos a Z pozíció végállás konfigurációs beállításának kalibrálásához. A paraméterekkel és az eszköz aktív működése közben elérhető további parancsokkal kapcsolatos részletekért használd a MANUAL_PROBE parancsot.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`: Vegyük az aktuális Z G-kód eltolást (más néven mikrolépés), és vonjuk ki a stepper_z endstop_positionból. Ez egy gyakran használt mikrolépés értéket vesz, és "állandóvá teszi". Egy `SAVE_CONFIG` szükséges a hatálybalépéshez.

### [manual_stepper]

A következő parancs akkor érhető el, ha a [manual_stepper konfigurációs szakasz](Config_Reference.md#manual_stepper) engedélyezve van.

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|2|-1|-2]] [SYNC=0]]]`: Ez a parancs megváltoztatja a léptető állapotát. Az ENABLE paraméterrel engedélyezheti/letilthatja a léptetőt. A SET_POSITION paraméterrel kényszerítheti a léptetőt arra, hogy azt higgye, az adott helyzetben van. A MOVE paraméterrel kezdeményezhet mozgást egy adott pozícióba. Ha a SPEED és/vagy az ACCEL paraméter meg van adva, akkor a rendszer a megadott értékeket használja a konfigurációs fájlban megadott alapértelmezett értékek helyett. Ha nulla ACCEL-t ad meg, akkor nem történik gyorsítás. Ha STOP_ON_ENDSTOP=1 van megadva, akkor a lépés korán véget ér. Ha a végálláskapcsoló aktiválódik (a STOP_ON_ENDSTOP=2 paranccsal hiba nélkül befejezheti a mozgást, még akkor is, ha a végálláskapcsoló nem aktiválódott. Használja a -1 vagy a -2 jelölést, hogy leálljon, amikor a végálláskapcsoló még nem aktiválódott). Normális esetben a későbbi G-kód parancsok a léptetőmozgás befejezése után kerülnek ütemezésre, azonban ha a kézi léptetőmozgás parancs a SYNC=0 értéket használja, akkor a későbbi G-kód mozgatási parancsok a léptetőmozgással párhuzamosan is futhatnak.

### [led]

A következő parancs akkor érhető el, ha a [LED konfigurációs szakaszok](Config_Reference.md#leds) bármelyike engedélyezve van.

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: Ez állítja be a LED kimenetet. Minden szín `<value>` 0,0 és 1,0 között kell lennie. A WHITE opció csak RGBW LED-ek esetén érvényes. Ha a LED több chipet támogat egy daisy-chainben, akkor megadhatjuk az INDEX-et, hogy csak az adott chip színét változtassuk meg (1 az első chiphez, 2 a másodikhoz stb.). Ha az INDEX nincs megadva, akkor a daisy-chain összes LED-je a megadott színre lesz beállítva. Ha TRANSMIT=0 van megadva, akkor a színváltoztatás csak a következő SET_LED parancsnál történik meg, amely nem ad meg TRANSMIT=0-t. Ez hasznos lehet az INDEX paraméterrel kombinálva, ha egy daisy-chainben több frissítést szeretnénk kötegelni. Alapértelmezés szerint a SET_LED parancs szinkronizálja a változtatásokat a többi folyamatban lévő G-kód paranccsal. Ez nemkívánatos viselkedéshez vezethet, ha a LED-ek beállítása akkor történik, amikor a nyomtató nem nyomtat, mivel ez visszaállítja az üresjárati időkorlátot. Ha nincs szükség gondos időzítésre, az opcionális SYNC=0 paraméter megadható, hogy a módosításokat az üresjárati időkorlát visszaállítása nélkül alkalmazza.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: Egy [display_template](Config_Reference.md#display_template) hozzárendelése egy adott [LED-hez](Config_Reference.md#leds). Például, ha definiáltunk egy `[display_template my_led_template]` konfigurációs szakaszt, akkor itt hozzárendelhetjük a `TEMPLATE=my_led_template`. A display_template-nek egy vesszővel elválasztott karakterláncot kell létrehoznia, amely négy lebegőpontos számot tartalmaz, amelyek megfelelnek a piros, zöld, kék és fehér színbeállításoknak. A sablon folyamatosan kiértékelésre kerül, és a LED automatikusan az így kapott színekre lesz beállítva. A sablon kiértékelése során használandó display_template paramétereket lehet beállítani (a paraméterek Python literálokként lesznek elemezve). Ha az INDEX nincs megadva, akkor a LED's daisy-chain összes chipje a sablonra lesz beállítva, ellenkező esetben csak a megadott indexszel rendelkező chip lesz frissítve. Ha a TEMPLATE üres karakterlánc, akkor ez a parancs törli a LED-hez rendelt korábbi sablonokat (ekkor a `SET_LED` parancsokat használhatjuk a LED színbeállításainak kezelésére).

### [output_pin]

A következő parancs akkor érhető el, ha az [output_pin konfigurációs szakasz](Config_Reference.md#output_pin) engedélyezve van.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> CYCLE_TIME=<cycle_time>`: Megjegyzés: A hardveres PWM jelenleg nem támogatja a CYCLE_TIME paramétert, és a konfigurációban meghatározott ciklusidőt használja.

### [palette2]

A következő parancsok akkor érhetők el, ha a [palette2 konfigurációs szakasz](Config_Reference.md#palette2) engedélyezve van.

A paletta nyomtatások speciális OCode-ok (Omega-kódok) beágyazásával működnek a G-kód fájlban:

- `O1`...`O32`: Ezeket a kódokat a G-kód folyamatból olvassa be és dolgozza fel ez a modul, majd továbbítja a Palette 2 eszköznek.

A következő további parancsok is rendelkezésre állnak.

#### PALETTE_CONNECT

`PALETTE_CONNECT`: Ez a parancs inicializálja a kapcsolatot a Palette 2-vel.

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`: Ez a parancs megszakítja a kapcsolatot a Paletta 2-vel.

#### PALETTE_CLEAR

`PALETTE_CLEAR`: Ez a parancs arra utasítja a Palette 2-t, hogy törölje az összes szálat a bemeneti és kimeneti útvonalból.

#### PALETTE_CUT

`PALETTE_CUT`: Ez a parancs utasítja a Palette 2-t, hogy vágja el az illesztési magba töltött szálat.

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`: Ez a parancs elindítja az intelligens betöltési sorozatot a Paletta 2-n. A nyomtatószál betöltése automatikusan történik a készülékben a nyomtatóhoz kalibrált távolság extrudálásával, és utasítja a Palette 2-t, amint a betöltés befejeződött. Ez a parancs megegyezik a **Smart Load** megnyomásával közvetlenül a Palette 2 képernyőjén, miután a nyomtatószál betöltése befejeződött.

### [pid_calibrate]

A pid_calibrate modul automatikusan betöltődik, ha a konfigurációs fájlban van egy fűtés definiálva.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`: A PID kalibrációs teszt elvégzése. A megadott fűtőberendezés a megadott célhőmérséklet eléréséig engedélyezve lesz, majd a fűtőberendezés több cikluson keresztül ki- és bekapcsol. Ha a WRITE_FILE paraméter engedélyezve van, akkor létrejön a /tmp/heattest.txt fájl a teszt során vett összes hőmérséklet-mintát tartalmazó naplóval.

### [pause_resume]

A következő parancsok akkor érhetők el, ha a [pause_resume konfigurációs szakasz](Config_Reference.md#pause_resume) engedélyezve van:

#### PAUSE

`PAUSE`: Az aktuális nyomtatás szüneteltetése. Az aktuális pozíció rögzítésre kerül, hogy a folytatáskor visszaállítható legyen.

#### RESUME

`RESUME [VELOCITY=<value>]`: Folytatja a nyomtatást szünet után, először visszaállítva a korábban rögzített pozíciót. A VELOCITY paraméter határozza meg, hogy a fúvóka milyen sebességgel térjen vissza az eredeti rögzített pozícióba.

#### CLEAR_PAUSE

`CLEAR_PAUSE`: Törli az aktuális szüneteltetett állapotot a nyomtatás folytatása nélkül. Ez akkor hasznos, ha valaki úgy dönt, hogy PAUSE után megszakítja a nyomtatást. Ajánlatos ezt hozzáadni az indító G-kódhoz, hogy a szüneteltetett állapot minden nyomtatásnál friss legyen.

#### CANCEL_PRINT

`CANCEL_PRINT`: Az aktuális nyomtatás törlése.

### [probe]

A következő parancsok akkor érhetők el, ha a [szonda konfigurációs szakasz](Config_Reference.md#probe) vagy a [bltouch konfigurációs szakasz](Config_Reference.md#bltouch) engedélyezve van (lásd még a [szonda kalibrációs útmutatót](Probe_Calibrate.md)).

#### PROBE

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`: Mozgassa a fúvókát lefelé, amíg a szonda nem érzékel. Ha bármelyik opcionális paramétert megadjuk, azok felülírják a [szonda konfigurációs szakaszában](Config_Reference.md#szonda) megadott megfelelő beállításokat.

#### QUERY_PROBE

`QUERY_PROBE`: Jelentse a szonda aktuális állapotát ("triggered" vagy "open").

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`: Több mérési minta maximumának, minimumának, átlagának, mediánjának és szórásának kiszámítása. Alapértelmezés szerint 10 MINTÁT veszünk. Egyébként az opcionális paraméterek alapértelmezés szerint a szonda konfigurációs szakaszában szereplő megfelelő beállításokat használják.

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>]`: A szonda z_offset kalibrálásához hasznos segédszkript futtatása. Az opcionális szondaparaméterekkel kapcsolatos részletekért lásd a PROBE parancsot. Lásd a MANUAL_PROBE parancsot a SPEED paraméterre és az eszköz aktív működése közben elérhető további parancsokra vonatkozó részletekért. Felhívjuk a figyelmet, hogy a PROBE_CALIBRATE parancs a sebesség változót használja az XY irányú és a Z irányú mozgáshoz.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`: Vegyük az aktuális Z G-kód eltolást (más néven mikrolépés), és vonjuk ki a szonda z_offset-jéből. Ez egy gyakran használt mikrolépés értéket vesz, és "állandóvá teszi". Egy `SAVE_CONFIG` szükséges a hatálybalépéshez.

### [query_adc]

A query_adc modul automatikusan betöltődik.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]`: Jelenti a konfigurált analóg tűhöz utoljára kapott analóg értéket. Ha NAME nincs megadva, a rendelkezésre álló ADC nevek listája kerül jelentésre. Ha a PULLUP meg van adva (ohmban megadott értékként), akkor a nyers analóg értéket és a pullup adott egyenértékű ellenállást jelenti.

### [query_endstops]

A query_endstops modul automatikusan betöltődik. Jelenleg a következő szabványos G-kód parancsok állnak rendelkezésre, de használatuk nem ajánlott:

- Végállás állapotának lekérdezése: `M119` (Használja QUERY_ENDSTOPS helyett.)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`: Méri a tengelyvégállásokat és jelenti, ha azok "kioldottak" vagy "nyitott" állapotban vannak. Ezt a parancsot általában annak ellenőrzésére használják, hogy egy végállás megfelelően működik-e.

### [resonance_tester]

A következő parancsok akkor érhetők el, ha a [resonance_tester konfigurációs szakasz](Config_Reference.md#resonance_tester) engedélyezve van (lásd még a [rezonanciák mérése útmutatót](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: Az összes engedélyezett gyorsulásmérő chip összes tengelyének zaját méri és adja ki.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> OUTPUT=<resonances,raw_data> [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<adxl345_chip_name>] [POINT=x,y,z] [INPUT_SHAPING=[<0:1>]]`: Lefuttatja a rezonanciatesztet a kért "tengely" összes konfigurált mérőpontjában, és méri a gyorsulást az adott tengelyhez konfigurált gyorsulásmérő chipek segítségével. A "tengely" lehet X vagy Y, vagy megadhat egy tetszőleges irányt `AXIS=dx,dy`, ahol dx és dy egy irányvektort meghatározó lebegőpontos szám (pl. `AXIS=X`, `AXIS=Y`, vagy `AXIS=1,-1` az átlós irány meghatározásához). Vegyük figyelembe, hogy az `AXIS=dx,dy` és az `AXIS=-dx,-dy` egyenértékű. Az `adxl345_chip_name` lehet egy vagy több konfigurált adxl345 chip, vesszővel elválasztva, például `CHIPS="adxl345, adxl345 rpi"`. Megjegyzendő, hogy az `adxl345` elhagyható a nevesített adxl345 chipeknél. Ha POINT van megadva, az felülírja a `[resonance_tester]` alatt konfigurált pontokat. Ha `INPUT_SHAPING=0` vagy nincs beállítva (alapértelmezett), letiltja a bemeneti alakítást a rezonancia teszteléshez, mert a rezonancia tesztelés nem érvényes a bemeneti alakító engedélyezésével. Az `OUTPUT` paraméter egy vesszővel elválasztott lista arról, hogy mely kimenetek kerülnek kiírásra. Ha `raw_data` paramétert kér, akkor a nyers gyorsulásmérő adatok egy `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` fájlba vagy fájlsorozatba íródnak. A (`<point>_` név részével, amely csak akkor generálódik, ha 1-nél több mérőpont van konfigurálva vagy POINT van megadva). Ha `resonances` van megadva, a frekvenciaválasz kiszámításra kerül (az összes mérőpontra vonatkozóan), és a `/tmp/resonances_<axis>_<name>.csv` fájlba íródik. Ha nincs beállítva, az OUTPUT alapértelmezés szerinti `resonances`, a NAME pedig alapértelmezés szerint az aktuális időpontot jelenti "ÉÉÉÉHHNN_ÓÓPPMPMP" formátumban.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [MAX_SMOOTHING=<max_smoothing>]`: A `TEST_RESONANCES` paraméterhez hasonlóan lefuttatja a rezonancia tesztet a konfiguráltak szerint, és megpróbálja megtalálni a bemeneti változó optimális paramétereit a kért tengelyre (vagy mind az X, mind az Y tengelyre, ha az `AXIS` paraméter nincs beállítva). Ha a `MAX_SMOOTHING` nincs beállítva, az értékét a `[resonance_tester]` szakaszból veszi, az alapértelmezett érték pedig a be nem állított érték. Lásd a [Max simítás](Measuring_Resonances.md#max-smoothing) a rezonanciák mérése című útmutatóban a funkció használatáról szóló további információkat. A hangolás eredményei kiíródnak a konzolra, a frekvenciaválaszok és a különböző bemeneti alakítók értékei pedig egy vagy több CSV-fájlba íródnak `/tmp/calibration_data_<axis>_<name>.csv`. Hacsak nincs megadva, a NAME alapértelmezés szerint az aktuális időpontot jelenti "YYYYMMDD_HHMMSS" formátumban. Vegye figyelembe, hogy a javasolt bemeneti változó paraméterek a `SAVE_CONFIG` parancs kiadásával megőrizhetők a konfigurációs fájlban.

### [respond]

A következő szabványos G-kódú parancsok állnak rendelkezésre, ha a [respond konfigurációs szakasz](Config_Reference.md#respond) engedélyezve van:

- `M118 <message>`: visszhangozza az üzenetet a konfigurált alapértelmezett előtaggal (vagy `echo: `, ha nincs konfigurálva előtag).

A következő további parancsok is rendelkezésre állnak.

#### RESPOND

- `RESPOND MSG="<message>"`: visszhangozza az üzenetet a konfigurált alapértelmezett előtaggal kiegészítve (vagy `echo: `, ha nincs konfigurálva előtag).
- `RESPOND TYPE=echo MSG="<message>"`: visszhangozza az üzenetet, amelyet `echo: ` küld.
- `RESPOND TYPE=echo_no_space MSG="<message>"`: az üzenet visszhangja az `előtaggal kiegészítve echo:` szóköz nélkül az előtag és az üzenet között, hasznos a kompatibilitás néhány olyan octoprint pluginnal, amelyek nagyon speciális formázást várnak el.
- `RESPOND TYPE=command MSG="<message>"`: visszhangozza az üzenetet `// `. Az OctoPrint konfigurálható úgy, hogy válaszoljon ezekre az üzenetekre (pl. `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<message>"`: visszhangozza az üzenetet `!! `.
- `RESPOND PREFIX=<prefix> MSG="<message>"`: visszhangozza az üzenetet `<prefix>` előtaggal kiegészítve. (A `PREFIX` paraméter elsőbbséget élvez a `TYPE` paraméterrel szemben.)

### [save_variables]

A következő parancs akkor engedélyezett, ha a [save_variables konfigurációs szakasz](Config_Reference.md#save_variables) engedélyezve van.

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`: A változót a lemezre menti, hogy újraindításkor is használható legyen. Minden tárolt változó betöltődik a `printer.save_variables.variables` dict indításkor, és használható a G-kód makrókban. A megadott VALUE-t Python literálként elemzi.

### [screws_tilt_adjust]

A következő parancsok akkor érhetők el, ha a [screws_tilt_adjust konfigurációs szakasz](Config_Reference.md#screws_tilt_adjust) engedélyezve van (lásd még a [kézi szintbeállítási útmutatót](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [<probe_parameter>=<value>]`: Ez a parancs az ágy csavarjainak beállítási eszközét hívja elő. A fúvókát különböző helyekre (a konfigurációs fájlban meghatározottak szerint) parancsolja a Z magasságot mérve, és kiszámítja az ágy szintjének beállításához szükséges gombfordulatok számát. Ha DIRECTION van megadva, akkor a gombfordulások mind ugyanabba az irányba, az óramutató járásával megegyező vagy az óramutató járásával ellentétes irányba fognak történni. Az opcionális szondaparaméterekkel kapcsolatos részletekért lásd a PROBE parancsot. FONTOS: A parancs használata előtt mindig ki kell adni egy G28 parancsot. Ha MAX_DEVIATION van megadva, a parancs G-kód hibát fog adni, ha a csavar magasságának az alapcsavar magasságához viszonyított bármilyen különbsége nagyobb, mint a megadott érték.

### [sdcard_loop]

Ha az [sdcard_loop konfigurációs szakasz](Config_Reference.md#sdcard_loop) engedélyezve van, a következő kiterjesztett parancsok állnak rendelkezésre.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`: Egy hurokszerű szakasz kezdete az SD nyomtatásban. A 0-ás szám azt jelzi, hogy a szakasz végtelenített hurokba kerüljön.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: Az SD-nyomtatásban egy ciklusos szakasz befejezése.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: A meglévő ciklusok befejezése további iterációk nélkül.

### [servo]

A következő parancsok akkor érhetők el, ha a [szervó konfigurációs szakasz](Config_Reference.md#servo) engedélyezve van.

#### SET_SERVO

`SET_SERVO SERVO=config_name [ANGLE=<degrees> | WIDTH=<seconds>]`: A szervó pozíciójának beállítása a megadott szögre (fokban) vagy impulzusszélességre (másodpercben). A `WIDTH=0` használatával letilthatja a szervókimenetet.

### [skew_correction]

A következő parancsok akkor érhetők el, ha a [skew_correction konfigurációs szakasz](Config_Reference.md#skew_correction) engedélyezve van (lásd még a [Ferdeségi korrekció](Skew_Correction.md) útmutatót).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`: A [skew_correction] modul konfigurálása a kalibrációs nyomatból vett mérésekkel (mm-ben). A mérések a síkok tetszőleges kombinációjára adhatók meg, a be nem adott síkok megtartják az aktuális értéküket. Ha `CLEAR=1` van megadva, akkor minden ferdeségkorrekció ki lesz kapcsolva.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: A nyomtató aktuális ferdeségét jelenti minden síkhoz radiánban és fokban. A ferdeség kiszámítása a `SET_SKEW` G-kódal megadott paraméterek alapján történik.

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>]`: Kiszámítja és jelenti a ferdeséget (radiánban és fokban) egy mért lenyomat alapján. Ez hasznos lehet a nyomtató aktuális ferdeségének meghatározásához a korrekció alkalmazása után. A korrekció alkalmazása előtt is hasznos lehet annak meghatározásához, hogy szükséges-e a ferdeségkorrekció. A ferdeség kalibrációs objektumok és mérések részleteiért lásd a [Ferdeség korrekció](Skew_Correction.md) dokumentumot.

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<name>] [SAVE=<name>] [REMOVE=<name>]`: Profilkezelés a skew_correction számára. A LOAD visszaállítja a ferdeség állapotát a megadott névnek megfelelő profilból. A SAVE a megadott névnek megfelelő profilba menti az aktuális ferdeségállapotot. A REMOVE törli a megadott névnek megfelelő profilt a tartós memóriából. Megjegyzendő, hogy a SAVE vagy REMOVE műveletek lefuttatása után a SAVE_CONFIG parancsot kell futtatni, hogy a tartós memóriában végrehajtott változtatások véglegesek legyenek.

### [smart_effector]

Több parancs is elérhető, ha a [smart_effector konfigurációs szakasz](Config_Reference.md#smart_effector) engedélyezve van. A Smart Effector paramétereinek módosítása előtt mindenképpen nézze meg a Smart Effector hivatalos dokumentációját a [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer) oldalon. Ellenőrizze továbbá a [szonda kalibrációs útmutató](Probe_Calibrate.md) című dokumenmot is.

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<sensitivity>] [ACCEL=<accel>] [RECOVERY_TIME=<time>]`: A Smart Effector paramétereinek beállítása. Ha `SENSITIVITY` van megadva, a megfelelő érték a SmartEffector EEPROM-ba íródik (`control_pin` biztosítása szükséges). Az elfogadható `<sensitivity>` értékek 0..255, az alapértelmezett érték 50..255. Az alacsonyabb értékek kisebb fúvóka-érintkezési erőt igényelnek a kioldáshoz (de nagyobb a téves kioldás kockázata a szondázás közbeni rezgések miatt), a magasabb értékek pedig csökkentik a téves kioldást (de nagyobb érintkezési erőt igényelnek a kioldáshoz). Mivel az érzékenység az EEPROM-ba íródik, a leállítás után is megmarad, így nem kell minden nyomtató indításakor konfigurálni. `ACCEL` és `RECOVERY_TIME` lehetővé teszi a megfelelő paraméterek futásidőben történő felülbírálását, a Smart Effector [konfigurációs szakasz](Config_Reference.md#smart_effector) további információkat tartalmaz ezekről a paraméterekről.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`: Visszaállítja a Smart Effector érzékenységét a gyári beállításokra. Szükséges a `control_pin` megadása a config szakaszban.

### [stepper_enable]

A stepper_enable modul automatikusan betöltődik.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<config_name> ENABLE=[0|1]`: Csak az adott léptetőmotor engedélyezése vagy letiltása. Ez egy diagnosztikai és hibakeresési eszköz, ezért óvatosan kell használni. Egy léptetőmotor letiltása nem állítja vissza a kezdőpont felvételi információkat. Egy letiltott léptetőmotor kézi mozgatása azt okozhatja, hogy a gép a biztonságos határértékeken kívül működteti a motort. Ez a tengely alkatrészeinek, a nyomtatófejnek és a nyomtatási felületnek a károsodásához vezethet.

### [temperature_fan]

A következő parancs akkor érhető el, ha a [temperature_fan konfigurációs szakasz](Config_Reference.md#temperature_fan) engedélyezve van.

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>] [max_speed=<max_speed>]`: A temperature_fan célhőmérsékletének beállítása. Ha nincs megadva célérték, akkor a konfigurációs fájlban megadott hőmérsékletet állítja be. Ha a sebességek nincsenek megadva, akkor nem történik változás.

### [tmcXXXX]

A következő parancsok akkor érhetők el, ha a [tmcXXXXXX konfigurációs szakaszok](Config_Reference.md#tmc-motorvezerlo-konfiguracioja) bármelyike engedélyezve van.

#### DUMP_TMC

`DUMP_TMC STEPPER=<name>`: Ez a parancs kiolvassa a TMC-motorvezérlő regisztereit és jelenti azok értékeit.

#### INIT_TMC

`INIT_TMC STEPPER=<name>`: Ez a parancs inicializálja a TMC regisztereket. A meghajtó újraaktiválásához szükséges, ha a chip áramellátása kikapcsol, majd visszakapcsol.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: Ez a TMC-motorvezérlő futó- és tartóáramát állítja be. (A HOLDCURRENT nem alkalmazható a tmc2660 motorvezérlőkre).

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value>`: Ez módosítja a TMC-motorvezérlő megadott regisztermezőjének értékét. Ez a parancs csak alacsony szintű diagnosztikára és hibakeresésre szolgál, mivel a mezők futás közbeni módosítása a nyomtató nem kívánt és potenciálisan veszélyes viselkedéséhez vezethet. A tartós változtatásokat inkább a nyomtató konfigurációs fájljának használatával kell elvégezni. A megadott értékek esetében nem történik ellenőrzés.

### [toolhead]

A nyomtatófejmodul automatikusan betöltődik.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [ACCEL_TO_DECEL=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: A nyomtató sebességhatárainak módosítása.

### [tuning_tower]

A tuning_tower modul automatikusan betöltődik.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<command> PARAMETER=<name> START=<value> [SKIP=<value>] [FACTOR=<value> [BAND=<value>]] | [STEP_DELTA=<value> STEP_HEIGHT=<value>]`: Egy eszköz egy paraméter beállítására minden egyes Z magasságon a nyomtatás során. Az eszköz az adott `COMMAND` parancsot a megadott `PARAMETER` értékhez rendelt `Z` értékkel egy képlet szerint változó értékkel futtatja. Használja a `FACTOR` lehetőséget, ha vonalzóval vagy tolómérővel fogja mérni az optimális Z magasságot, vagy `STEP_DELTA` és `STEP_HEIGHT`, ha a hangolótorony modellje diszkrét értékek sávjaival rendelkezik, mint ahogy az a hőmérséklet-tornyoknál gyakori. Ha `SKIP=<value>` van megadva, akkor a hangolási folyamat nem kezdődik meg, amíg a Z magasság `<value>` elérését, és ez alatt az érték `START` értékre lesz beállítva; ebben az esetben az alábbi képletekben használt `z_height` valójában `max(z - skip, 0)`. Három lehetséges kombináció létezik:

- `FACTOR`: Az érték `factor` milliméterenként változik. Az alkalmazott képlet: `value = start + factor * z_height`. Az optimális Z magasságot közvetlenül a képletbe illesztheti az optimális paraméterérték meghatározásához.
- `FACTOR` és `BAND`: Az érték átlagosan `Faktor` milliméterenként változik, de diszkrét sávokban, ahol a kiigazítás csak minden `BAND` milliméterenként történik a Z magasságban. A használt képlet a következő: `value= start + factor* ((floor(z_height / band) + .5) * band)`.
- `STEP_DELTA` és `STEP_HEIGHT`: Az érték `STEP_DELTA` minden `STEP_HEIGHT` milliméterrel változik. A használt képlet a következő: `value = start + step_delta * floor(z_height / step_height)`. Az optimális érték meghatározásához egyszerűen megszámolhatja a sávokat vagy leolvashatja a hangolótorony értékeit.

### [virtual_sdcard]

A Klipper támogatja a következő szabványos G-kód parancsokat, ha a [virtual_sdcard konfigurációs szakasz](Config_Reference.md#virtual_sdcard) engedélyezve van:

- SD-kártya listázása: `M20`
- SD-kártya inicializálása: `M21`
- Válassza ki az SD fájlt: `M23 <filename>`
- SD nyomtatás indítása/folytatása: `M24`
- SD nyomtatás szüneteltetése: `M25`
- SD pozíció beállítása: `M26 S<offset>`
- SD nyomtatási státusz jelentése: `M27`

Ezenkívül a következő kiterjesztett parancsok is elérhetők, ha a "virtual_sdcard" konfigurációs szakasz engedélyezve van.

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<filename>`: Egy fájl betöltése és az SD-nyomtatás elindítása.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`: A fájl eltávolítása és az SD állapotának törlése.

### [z_tilt]

A következő parancsok akkor érhetők el, ha a [z_tilt konfigurációs szakasz](Config_Reference.md#z_tilt) engedélyezve van.

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [<probe_parameter>=<value>]`: Ez a parancs a konfigurációban megadott pontokat vizsgálja meg, majd a dőlés kompenzálása érdekében minden egyes Z léptetőn független beállításokat végez. Az opcionális mérési paraméterekkel kapcsolatos részletekért lásd a PROBE parancsot.
