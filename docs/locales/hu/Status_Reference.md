# Állapot referencia

Ez a dokumentum a Klipper [makrók](Command_Templates.md), [megjelenítési mezők](Config_Reference.md#display) és az [API Szerver](API_Server.md) segítségével elérhető nyomtató állapotinformációk referenciája.

Az ebben a dokumentumban szereplő mezők változhatnak. Ha egy attribútumot használ, a Klipper szoftver frissítésekor mindenképpen nézze át a [Konfigurációs változások dokumentumot](Config_Changes.md).

## angle

A következő információk az [angle some_name](Config_Reference.md#angle) objektumban érhetők el:

- `temperature`: A tle5012b mágneses hall-érzékelő utolsó hőmérsékleti értéke (Celsiusban). Ez az érték csak akkor érhető el, ha a szögérzékelő egy tle5012b chip, és ha a mérések folyamatban vannak (ellenkező esetben `None`).

## bed_mesh

A következő információk a [bed_mesh](Config_Reference.md#bed_mesh) objektumban érhetők el:

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`: Az aktuálisan aktív bed_mesh-re vonatkozó információk.
- `profiles`: A BED_MESH_PROFILE használatával beállított, jelenleg definiált profilok halmaza.

## configfile

A következő információk a `configfile` objektumban találhatók (ez az objektum mindig elérhető):

- `settings.<section>.<option>`: Visszaadja az adott konfigurációs fájl beállítását (vagy alapértelmezett értékét) a szoftver utolsó indítása vagy újraindítása során. (A használat közben megváltoztatott beállítások nem jelennek meg itt.)
- `config.<section>.<option>`: Visszaadja az adott nyers konfigurációs fájl beállítását, ahogyan azt a Klipper a legutóbbi szoftverindítás vagy újraindítás során beolvasta. (A működés közben megváltoztatott beállítások nem jelennek meg itt.) Minden értéket stringként ad vissza.
- `save_config_pending`: True értéket ad, ha vannak olyan frissítések, amelyeket a `SAVE_CONFIG` parancs a lemezen is megőrizhet.
- `save_config_pending_items`: Tartalmazza azokat a szakaszokat és opciókat, amelyeket megváltoztattak, és amelyeket egy `SAVE_CONFIG` elmenthetne.
- `figyelmeztetések`: A konfigurációs beállításokkal kapcsolatos figyelmeztetések listája. A lista minden egyes bejegyzése egy szótár lesz, amely tartalmaz egy `type` és egy `message` mezőt (mindkettő karakterlánc). A figyelmeztetés típusától függően további mezők is rendelkezésre állhatnak.

## display_status

A következő információk a `display_status` objektumban érhetők el (ez az objektum automatikusan elérhető, ha a [kijelző](Config_Reference.md#display) konfigurációs szakasz definiálva van):

- `progress`: A legutóbbi `M73` G-kód parancs progress értéke (vagy `virtual_sdcard.progress`, ha nem érkezett legutóbbi `M73`).
- `message`: Az utolsó `M117` G-kódú parancsban szereplő üzenet.

## endstop_phase

A következő információk az [endstop_phase](Config_Reference.md#endstop_phase) objektumban érhetők el:

- `last_home.<stepper name>.phase`: A léptetőmotor fázisa az utolsó kezdőpont felvételi kísérlet végén.
- `last_home.<stepper name>.phases`: A léptetőmotoron rendelkezésre álló fázisok száma.
- `last_home.<stepper name>.mcu_position`: A léptetőmotor pozíciója (ahogyan azt a mikrokontroller követi) a legutóbbi kezdőpont felvételi kísérlet végén. A pozíció az előremenő irányban megtett lépések száma mínusz a mikrokontroller utolsó újraindítása óta visszafelé megtett lépések számával.

## exclude_object

A következő információk az [exclude_object](Exclude_Object.md) objektumban találhatók:


   - `objektumok`: Az `EXCLUDE_OBJECT_DEFINE` parancs által megadott ismert objektumok tömbje. Ez ugyanaz az információ, amelyet az `EXCLUDE_OBJECT VERBOSE=1` parancs szolgáltat. A `center` és `polygon` mezők csak akkor lesznek jelen, ha az eredeti `EXCLUDE_OBJECT_DEFINE` parancsban szerepelnek.Íme egy JSON-minta:

```
[
  {
    "polygon": [
      [ 156.25, 146.2511675 ],
      [ 156.25, 153.7488325 ],
      [ 163.75, 153.7488325 ],
      [ 163.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_2_COPY_0",
    "center": [ 160, 150 ]
  },
  {
    "polygon": [
      [ 146.25, 146.2511675 ],
      [ 146.25, 153.7488325 ],
      [ 153.75, 153.7488325 ],
      [ 153.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_1_COPY_0",
    "center": [ 150, 150 ]
  }
]
```

- `excluded_objects`: A kizárt objektumok neveit felsoroló karakterláncok tömbje.
- `current_object`: Az aktuálisan nyomtatott objektum neve.

## fan

A következő információk a [ventilátor](Config_Reference.md#fan), [heater_fan some_name](Config_Reference.md#heater_fan) és [controller_fan some_name](Config_Reference.md#controller_fan) objektumokban érhetők el:

- `speed`: A ventilátor fordulatszáma lebegőértékként 0.0 és 1.0 között.
- `rpm`: A ventilátor mért fordulatszáma percenkénti fordulatszámban, ha a ventilátor rendelkezik tachometer_pin kimenettel.

## filament_switch_sensor

A következő információk a [filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor) objektumokban érhetők el:

- `enabled`: True értéket ad vissza, ha a kapcsoló engedélyezve van.
- `filament_detected`: True értéket ad ha az érzékelő kioldott állapotban van.

## filament_motion_sensor

A következő információk a [filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor) objektumokban érhetők el:

- `enabled`: True értéket ad, ha a mozgásérzékelő engedélyezve van.
- `filament_detected`: True értéket ad ha az érzékelő kioldott állapotban van.

## firmware_retraction

A következő információk a [firmware_retraction](Config_Reference.md#firmware_retraction) objektumban találhatók:

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`: A firmware_retraction modul aktuális beállításai. Ezek a beállítások eltérhetnek a konfigurációs állománytól, ha a `SET_RETRACTION` parancs megváltoztatja őket.

## gcode_macro

A következő információk a [gcode_macro some_name](Config_Reference.md#gcode_macro) objektumokban érhetők el:

- `<variable>`: Egy [gcode_macro változó](Command_Templates.md#variables) aktuális értéke.

## gcode_move

A következő információk a `gcode_move` objektumban érhetők el (ez az objektum mindig elérhető):

- `gcode_position`: A nyomtatófej aktuális pozíciója az aktuális G-kód origóhoz képest. Vagyis olyan pozíciók, amelyeket közvetlenül egy `G1` parancsnak küldhetünk. Lehetőség van e pozíció X, Y, Z és az E, komponensének elérésére (pl. `gcode_position.x`).
- `position`: A nyomtatófej utolsó kiadott pozíciója a konfigurációs fájlban megadott koordináta rendszerrel. Lehetőség van ennek a pozíciónak az X, Y, Z és az E, komponenséhez hozzáférni (pl. `position.x`).
- `homing_origin`: A G-kód koordináta rendszer origója (a config fájlban megadott koordináta rendszerhez képest), amelyet a `G28` parancs után használni kell. A `SET_GCODE_OFFSET` parancs megváltoztathatja ezt a pozíciót. Lehetőség van ennek a pozíciónak az X, Y és Z komponenséhez hozzáférni (pl. `homing_origin.x`).
- `speed`: Az utolsó, `G1` parancsban beállított sebesség (mm/mp-ben).
- `speed_factor`: Az `M220` parancs által beállított "sebességtényező felülbírálása". Ez egy lebegőpontos érték, így 1.0 azt jelenti, hogy nincs felülbírálat, és például a 2.0 megduplázza a kért sebességet.
- `extrude_factor`: Az `M221` parancs által beállított "extrude factor override". Ez egy lebegőpontos érték, így 1.0 azt jelenti, hogy nincs felülbírálat, és például a 2.0 megduplázza a kért extrudálásokat.
- `absolute_coordinates`: True értéket ad, ha a `G90` abszolút koordináta módban van, vagy False értéket, ha a `G91` relatív módban van.
- `absolute_extrude`: True értéket ad, ha az `M82` abszolút extrude módban van, vagy False értéket, ha az `M83` relatív módban van.

## hall_filament_width_sensor

A következő információk a [hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor) objektumban érhetők el:

- `is_active`: True értéket ad, ha az érzékelő jelenleg aktív.
- `Diameter`: Az érzékelő utolsó leolvasása mm-ben.
- `Raw`: Az érzékelő utolsó nyers ADC-olvasása.

## heater

A következő információk az olyan fűtőelemekhez állnak rendelkezésre, mint az [extruder](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed) és [heater_generic](Config_Reference.md#heater_generic):

- `temperature`: Az adott fűtőberendezés legutóbb jelentett hőmérséklete (Celsiusban, lebegőértékként).
- `target`: Az adott fűtőberendezés aktuális célhőmérséklete (Celsiusban, lebegőértékként).
- `power`: A fűtőtesthez tartozó PWM-tű utolsó értéke (0,0 és 1,0 közötti érték).
- `can_extrude`: Ha az extruder tud extrudálni (`min_extrude_temp` határozza meg), csak az [extruder](Config_Reference.md#extruder) esetében elérhető

## heaters

A következő információk a `heaters` objektumban érhetők el (ez az objektum akkor érhető el, ha bármilyen fűtőberendezés definiálva van):

- `available_heaters`: Visszaadja az összes jelenleg elérhető fűtőberendezés listáját a teljes config szekció nevével, pl. `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `available_sensors`: Visszaadja az összes jelenleg elérhető hőmérséklet érzékelő listáját a teljes config szekció nevével, pl. `["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"]`.

## idle_timeout

A következő információk az [idle_timeout](Config_Reference.md#idle_timeout) objektumban érhetők el (ez az objektum mindig elérhető):

- `state`: A nyomtató aktuális állapota, amelyet az idle_timeout modul követ. A következő karakterláncok egyike: "Idle", "Printing", "Ready".
- `printing_time`: Az az idő (másodpercben), amíg a nyomtató "nyomtatás" állapotban volt (ahogyan azt az idle_timeout modul követi).

## led

A következő információk állnak rendelkezésre minden egyes `[led led_name]`, `[neopixel led_name` esetében, `[dotstar led_name]`, `[pca9533 led_name]`, és `[pca9632 led_name]` a nyomtatóban meghatározott printer.cfg fájlban:

- `color_data`: A láncban lévő ledek RGBW értékeit tartalmazó színlisták listája. Minden értéket 0,0 és 1,0 közötti lebegőértékként ábrázolunk. Minden színlista 4 elemet tartalmaz (piros, zöld, kék, fehér), még akkor is, ha az alatta lévő LED kevesebb színcsatornát támogat. Például a lánc második neopixelének kék értéke (a színlista 3. eleme) a `printer["neopixel <config_name>"].color_data[1][2]` címen érhető el.

## mcu

A következő információk az [mcu](Config_Reference.md#mcu) és [mcu some_name](Config_Reference.md#mcu-my_extra_mcu) objektumokban érhetők el:

- `mcu_version`: A mikrokontroller által jelentett Klipper kód verziója.
- `mcu_build_versions`: A mikrokontroller kódjának generálásához használt építőeszközökre vonatkozó információk (a mikrokontroller által jelentett módon).
- `mcu_constants.<constant_name>`: A mikrokontroller által jelentett fordítási idejű konstansok. A rendelkezésre álló konstansok mikrokontroller architektúránként és kódrevíziónként eltérőek lehetnek.
- `last_stats.<statistics_name>`: Statisztikai információk a mikrokontroller kapcsolatról.

## motion_report

A következő információk a `motion_report` objektumban érhetők el (ez az objektum automatikusan elérhető, ha bármilyen stepper konfigurációs szakasz definiálva van):

- `live_position`: A nyomtatófej kért pozíciója az aktuális időre interpolálva.
- `live_velocity`: A nyomtatófej kért sebessége (mm/mp-ben) az aktuális időpontban.
- `live_extruder_velocity`: A kért extruder sebesség (mm/mp-ben) az aktuális időpontban.

## output_pin

A következő információk a [output_pin some_name](Config_Reference.md#output_pin) objektumokban érhetők el:

- `value`: A `SET_PIN` paranccsal beállított "value" a tű értéke.

## palette2

A következő információk a [palette2](Config_Reference.md#palette2) objektumban érhetők el:

- `ping`: Az utolsó jelentett Palette 2 ping összege százalékban.
- `remaining_load_length`: A Palette 2 nyomtatás indításakor ez lesz a nyomtatófejbe töltendő nyomtatószál mennyisége.
- `is_splicing`: True, ha a Palette 2 nyomtatószálat adagol.

## pause_resume

A következő információk a [pause_resume](Config_Reference.md#pause_resume) objektumban érhetők el:

- `is_paused`: True, ha egy PAUSE parancsot hajtottak végre a megfelelő RESUME parancs nélkül.

## print_stats

A következő információk a `print_stats` objektumban érhetők el (ez az objektum automatikusan elérhető, ha a [virtual_sdcard](Config_Reference.md#virtual_sdcard) config szakasz definiálva van):

- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message`: Becsült információ az aktuális nyomtatásról, ha egy virtual_sdcard nyomtatás aktív.

## probe

A következő információk a [szonda](Config_Reference.md#probe) objektumban érhetők el (ez az objektum akkor is elérhető, ha egy [bltouch](Config_Reference.md#bltouch) konfigurációs szakasz van definiálva):

- `last_query`: True értéket ad vissza, ha a szondát az utolsó QUERY_PROBE parancs során "triggered" -ként jelentették. Megjegyzés: ha ezt egy makróban használjuk, a sablon bővítési sorrendje miatt a QUERY_PROBE parancsot akkor ezt a hivatkozást tartalmazó makró előtt kell lefuttatni.
- `last_z_result`: Az utolsó PROBE parancs Z eredményének értékét adja vissza. Figyelem, ha ezt egy makróban használjuk, a sablon bővítési sorrendje miatt a PROBE (vagy hasonló) parancsot akkor ezt a hivatkozást tartalmazó makró előtt kell lefuttatni.

## quad_gantry_level

A következő információk a `quad_gantry_level` objektumban érhetők el (ez az objektum akkor érhető el, ha a quad_gantry_level definiálva van):

- `applied`: True, ha a portál szintezési folyamata lefutott és sikeresen befejeződött.

## query_endstops

A következő információk a `query_endstops` objektumban érhetők el (ez az objektum akkor érhető el, ha bármilyen végálláskapcsoló definiálva van):

- `last_query["<endstop>"]`: True értéket ad, ha az adott végálláskapcsolót az utolsó QUERY_ENDSTOP parancs során "triggered" -ként jelentették. Megjegyzés: ha ezt egy makróban használjuk, a sablon bővítési sorrendje miatt a QUERY_ENDSTOP parancsot akkor ezt a hivatkozást tartalmazó makró előtt kell lefuttatni.

## servo

A következő információk a [szervó some_name](Config_Reference.md#servo) objektumokban érhetők el:

- `printer["servo <config_name>"].value`: A szervóhoz tartozó PWM tű utolsó beállítása (0,0 és 1,0 közötti érték).

## system_stats

A következő információk a `system_stats` objektumban érhetők el (ez az objektum mindig elérhető):

- `sysload`, `cputime`, `memavail`: Információ a gazdagép operációs rendszeréről és a folyamatok terheléséről.

## hőmérséklet érzékelők

A következő információk a következő dokumentumban találhatók

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor), és [temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) objektumok:

- `temperature`: Az érzékelőtől utoljára kapott hőmérséklet.
- `humidity`, `pressure`, `gas`: Az érzékelőtől utoljára kapott értékek (csak a bme280, htu21d és lm75 érzékelők esetében).

## temperature_fan

A következő információk a [temperature_fan some_name](Config_Reference.md#temperature_fan) objektumokban érhetők el:

- `temperature`: Az érzékelőtől utoljára kapott hőmérséklet.
- `target`: A ventilátor célhőmérséklete.

## temperature_sensor

A következő információk a [temperature_sensor some_name](Config_Reference.md#temperature_sensor) objektumokban érhetők el:

- `temperature`: Az érzékelőtől utoljára kapott hőmérséklet.
- `measured_min_temp`, `measured_max_temp`: Az érzékelő által a Klipper gazdagép szoftver utolsó újraindítása óta mért legalacsonyabb és legmagasabb hőmérséklet.

## tmc motorvezérlők

A következő információk a [TMC léptető motorvezérlők](Config_Reference.md#tmc-motorvezerlo-konfiguracioja) objektumban érhetők el (pl. `[tmc2208 stepper_x]`):

- `mcu_phase_offset`: A mikrokontroller léptető pozíciója, amely megfelel a meghajtó "nulla" fázisának. Ez a mező lehet nulla, ha a fáziseltolás nem ismert.
- `phase_offset_position`: A vezető "nulladik" fázisának megfelelő "parancsolt pozíció". Ez a mező lehet nulla, ha a fáziseltolás nem ismert.
- `drv_status`: A legutóbbi motorvezérlő állapotlekérdezés eredményei. (Csak a nem nulla mezők kerülnek jelentésre.) Ez a mező nulla lesz, ha a motorvezérlő nincs engedélyezve (és így nem kerül rendszeresen lekérdezésre).
- `run_current`: Az aktuálisan beállított működési áram.
- `hold_current`: Az aktuálisan beállított tartóáram.

## toolhead

A következő információk a `toolhead` objektumban érhetők el (ez az objektum mindig elérhető):

- `position`: A nyomtatófej utolsó parancsolt pozíciója a konfigurációs fájlban megadott koordináta rendszerhez képest. Lehetőség van ennek a pozíciónak az X, Y, Z és az E, komponenséhez hozzáférni (pl. `position.x`).
- `extruder`: A jelenleg aktív extruder neve. Például egy makróban használhatjuk a `printer[printer.toolhead.extruder].target` parancsot, hogy megkapjuk az aktuális extruder célhőmérsékletét.
- `homed_axes`: Az aktuálisan "homed" állapotban lévőnek tekintett cartesian tengelyek. Ez egy karakterlánc, amely egy vagy több "X", "Y", "Z" értéket tartalmaz.
- `axis_minimum`, `axis_maximum`: A tengely mozgásának határai (mm) a kezdőpont felvétel után. Lehetőség van e határérték X, Y, Z összetevőinek elérésére (pl. `axis_minimum.x`, `axis_maximum.z`).
- `max_velocity`, `max_accel`, `max_accel_to_decel`, `square_corner_velocity`: Az aktuálisan érvényben lévő nyomtatási korlátok. Ez eltérhet a konfigurációs fájl beállításaitól, ha a `SET_VELOCITY_LIMIT` (vagy `M204`) parancs megváltoztatja azokat használat közben.
- `stalls`: Az összes alkalom száma (az utolsó újraindítás óta), amikor a nyomtatót szüneteltetni kellett, mert a nyomtatófej gyorsabban mozgott, mint ahány mozdulatot a G-kód bemenetről be lehetett olvasni.

## dual_carriage

A következő információk a [dual_carriage](Config_Reference.md#dual_carriage) alatt érhetőek el egy hybrid_corexy vagy hybrid_corexz gép esetében

- `mode`: Az aktuális üzemmód. A lehetséges értékek: "FULL_CONTROL"
- `active_carriage`: Az aktuális aktív kocsi. Lehetséges értékek: "CARRIAGE_0", "CARRIAGE_1"

## virtual_sdcard

A következő információk a [virtual_sdcard](Config_Reference.md#virtual_sdcard) objektumban érhetők el:

- `is_active`: True értéket ad, ha a fájlból való nyomtatás aktív.
- `progressz`: A nyomtatás aktuális előrehaladásának becslése (a fájlméret és a fájl pozíciója alapján).
- `file_path`: Az aktuálisan betöltött fájl teljes elérési útja.
- `file_position`: Az aktív nyomtatás aktuális pozíciója (bájtokban).
- `file_size`: Az aktuálisan betöltött fájl mérete (bájtokban).

## webhooks

A következő információk a `webhooks` objektumban érhetők el (ez az objektum mindig elérhető):

- `state`: A Klipper aktuális állapotát jelző karakterláncot adja vissza. A lehetséges értékek: "ready", "startup", "shutdown", "error".
- `state_message`: Egy ember által olvasható karakterlánc, amely további kontextust ad az aktuális Klipper állapotról.

## z_tilt

A következő információk a `z_tilt` objektumban érhetők el (ez az objektum akkor érhető el, ha a z_tilt definiálva van):

- `applied`: True, ha a Z végállás kiegyenlítési folyamat lefutott és sikeresen befejeződött.
