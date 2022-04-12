# G-Kódok

Ez a dokumentum a Klipper által támogatott parancsokat írja le. Ezek olyan parancsok, amelyeket az OctoPrint konzoljába lehet beírni.

## G-kód parancsok

A Klipper a következő szabványos G-kód parancsokat támogatja:

- Move (G0 or G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- Tartózkodás: `G4 P<milliszekundum>`
- Ugrás a forrásra: `G28 [X] [Y] [Z]`
- Kapcsolja ki a motorokat: `M18` vagy `M84`.
- Várja meg, amíg az aktuális mozdulat befejeződik: `M400`
- Használjon abszolút/relatív távolságokat az extrudáláshoz: `M82`, `M83`.
- Abszolút/relatív koordináták használata: `G90`, `G91`.
- Állítsa be a pozíciót: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- A sebességtényező felülbírálási százalékának beállítása: `M220 S<percent>`
- Extrudálási tényező felülbírálási százalékának beállítása: `M221 S<percent>`
- Gyorsítás beállítása: `M204 S<value>` VAGY `M204 P<value> T<value>`
   - Megjegyzés: Ha az S nincs megadva, de a P és a T meg van adva, akkor a gyorsulás a P és a T közül a minimumra van beállítva. Ha a P vagy a T közül csak az egyik van megadva, a parancsnak nincs hatása.
- Extruder hőmérsékletének lekérdezése: `M105`
- Az extruder hőmérsékletének beállítása: `M104 [T<index>] [S<temperature>]`
- Beállítja az extruder hőmérsékletét és várakozik: `M109 [T<index>] S<temperature>`
   - Megjegyzés: Az M109 mindig megvárja, míg a hőmérséklet beáll a kért értékre.
- Beállítja az ágy hőmérsékletét: `M140 [S<temperature>]`
- Beállítja az ágy hőmérsékletét és várakozik: `M190 S<temperature>`
   - Megjegyzés: Az M190 mindig megvárja, hogy a hőmérséklet beálljon a kért értékre.
- A ventilátor sebességének beállítása: `M106 S<value>`
- Kikapcsolja a ventilátort: `M107`
- Vészleállító: `M112`
- Jelenlegi pozíció lekérdezése: `M114`
- A firmware verziójának lekérdezése: `M115`

A fenti parancsokkal kapcsolatos további részletekért lásd a [RepRap G-kód dokumentáció](http://reprap.org/wiki/G-code) fájlt.

Klipper's goal is to support the G-Code commands produced by common 3rd party software (eg, OctoPrint, Printrun, Slic3r, Cura, etc.) in their standard configurations. It is not a goal to support every possible G-Code command. Instead, Klipper prefers human readable ["extended G-Code commands"](#additional-commands). Similarly, the G-Code terminal output is only intended to be human readable - see the [API Server document](API_Server.md) if controlling Klipper from external software.

Ha egy kevésbé gyakori G-kód parancsra van szükség, akkor azt egy egyéni [gcode_macro config section](Config_Reference.md#gcode_macro) segítségével lehet megvalósítani. Például ezt használhatnánk a következőkre: `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1` stb.

## További parancsok

A Klipper "kiterjesztett" G-kód parancsokat használ az általános konfigurációhoz és állapothoz. Ezek a kiterjesztett parancsok mind hasonló formátumot követnek, egy parancsnévvel kezdődnek, és egy vagy több paraméter követheti őket. Például: `SET_SERVO SERVO=myservo ANGLE=5.3`. Ebben a parancssorban a parancsok és paraméterek nagybetűvel szerepelnek, azonban a nagy- és kisbetűket nem kell figyelembe venni. (Tehát a "SET_SERVO" és a "set_servo" mindkettő ugyanazt jelenti.)

This section is organized my Klipper module name, which generally follows the section names specified in the [printer configuration file](Config_Reference.md). Note that some modules are automatically loaded.

### [adxl345]

The following commands are available when an [adxl345 config section](Config_Reference.md#adxl345) is enabled.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: A gyorsulásmérő mérések elindítása a kért másodpercenkénti mintavételek számával. Ha a CHIP nincs megadva, az alapértelmezett érték "adxl345". A parancs start-stop üzemmódban működik: az első végrehajtáskor elindítja a méréseket, a következő végrehajtáskor leállítja azokat. A mérések eredményei a `/tmp/adxl345-<chip>-<name> .csv nevű fájlba kerülnek kiírásra`, ahol `<chip>` a gyorsulásmérő chip neve (`my_chip_name` from `[adxl345 my_chip_name]`) és `<name>` az opcionális NAME paraméter. Ha a NAME nincs megadva, akkor az alapértelmezett érték az aktuális idő "ÉÉÉÉÉHHNN_ÓÓPPMM" formátumban. Ha a gyorsulásmérőnek nincs neve a konfigurációs szakaszban (egyszerűen `[adxl345]`), akkor a `<chip>` névrész nem generálódik.

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: lekérdezi a gyorsulásmérő aktuális értékét. Ha a CHIP nincs megadva, az alapértelmezett"adxl345". Ha a RATE nincs megadva, az alapértelmezett értéket használja. Ez a parancs hasznos az ADXL345 gyorsulásmérővel való kapcsolat tesztelésére. A visszaadott értékek egyikének a szabadeséses gyorsulásnak kell lennie (+/- a chip alapzaja).

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`: lekérdezi az ADXL345 "register" (pl. 44 vagy 0x2C) regiszterét. Hasznos lehet hibakeresési célokra.

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<register> VAL=<value>`: Nyers "érték" írása a "register"-be. Mind az "érték", mind a "register" lehet decimális vagy hexadecimális egész szám. Használja óvatosan, és hivatkozzon az ADXL345 adatlapjára.

### [angle]

The following commands are available when an [angle config section](Config_Reference.md#angle) is enabled.

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<chip_name>`: Perform angle calibration on the given sensor (there must be an `[angle chip_name]` config section that has specified a `stepper` parameter). IMPORTANT - this tool will command the stepper motor to move without checking the normal kinematic boundary limits. Ideally the motor should be disconnected from any printer carriage before performing calibration. If the stepper can not be disconnected from the printer, make sure the carriage is near the center of its rail before starting calibration. (The stepper motor may move forwards or backwards two full rotations during this test.) After completing this test use the `SAVE_CONFIG` command to save the calibration data to the config file. In order to use this tool the Python "numpy" package must be installed (see the [measuring resonance document](Measuring_Resonances.md#software-installation) for more information).

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: Queries sensor register "register" (e.g. 44 or 0x2C). Can be useful for debugging purposes. This is only available for tle5012b chips.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: Writes raw "value" into register "register". Both "value" and "register" can be a decimal or a hexadecimal integer. Use with care, and refer to sensor data sheet for the reference. This is only available for tle5012b chips.

### [bed_mesh]

The following commands are available when the [bed_mesh config section](Config_Reference.md#bed_mesh) is enabled (also see the [bed mesh guide](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>] [<mesh_parameter>=<value>]`: Ez a parancs az ágyat a konfigurációban megadott paraméterek által generált pontok segítségével szintezi. A szintezés után egy háló generálódik, és a Z elmozdulás a hálónak megfelelően kerül beállításra. Az opcionális szintező paraméterekkel kapcsolatos részletekért lásd a PROBE parancsot. Ha a METHOD=manual parancsot adta meg, akkor a kézi szintező eszköz aktiválódik. Az eszköz aktiválása közben elérhető további parancsok részleteit lásd a fenti MANUAL_PROBE parancsban.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`: This command outputs the current probed z values and current mesh values to the terminal. If PGP=1 is specified the X, Y coordinates generated by bed_mesh, along with their associated indices, will be output to the terminal.

#### BED_MESH_MAP

`BED_MESH_MAP`: Ez a parancs a BED_MESH_OUTPUT-hoz hasonlóan a háló aktuális állapotát írja ki a terminálra. Az értékek ember által olvasható formátumban történő kiírása helyett az állapotot JSON formátumban szerializálja. Ez lehetővé teszi az OctoPrint pluginek számára, hogy könnyen rögzítsék az adatokat, és az ágy felszínét közelítő magassági térképeket hozzanak létre.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: Ez a parancs törli a hálót és eltávolít minden Z-beállítást. Ajánlott ezt a parancsot befejező G-kódba tenni.

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<name> SAVE=<name> REMOVE=<name>`: This command provides profile management for mesh state. LOAD will restore the mesh state from the profile matching the supplied name. SAVE will save the current mesh state to a profile matching the supplied name. Remove will delete the profile matching the supplied name from persistent memory. Note that after SAVE or REMOVE operations have been run the SAVE_CONFIG gcode must be run to make the changes to persistent memory permanent.

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<value>] [Y=<value>]`: X és/vagy Y eltolást alkalmazza a hálókereséshez. Ez a független extruderekkel rendelkező nyomtatóknál hasznos, mivel az eltolás szükséges a szerszámcsere utáni helyes Z-beállításhoz.

### [bed_screws]

The following commands are available when the [bed_screws config section](Config_Reference.md#bed_screws) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`: Ez a parancs az ágy állítócsavarok beállítási eszközét hívja elő. A fúvókát különböző helyekre küldi (a konfigurációs fájlban meghatározottak szerint), és lehetővé teszi az ágy állítócsavarok beállítását, hogy az ágy állandó távolságra legyen a fúvókától.

### [bed_tilt]

The following commands are available when the [bed_tilt config section](Config_Reference.md#bed_tilt) is enabled.

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>]`: Ez a parancs a konfigurációban megadott pontokat vizsgálja, majd frissített X és Y dőlésbeállításokat javasol. Az opcionális mérési paraméterekkel kapcsolatos részletekért lásd a PROBE parancsot. Ha a METHOD=manual van megadva, akkor a kézi szintező aktiválódik. Az ezen eszköz aktiválásakor elérhető további parancsok részleteit lásd a fenti MANUAL_PROBE parancsban.

### [bltouch]

The following command is available when a [bltouch config section](Config_Reference.md#bltouch) is enabled (also see the [BL-Touch guide](BLTouch.md)).

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<command>`: This sends a command to the BLTouch. It may be useful for debugging. Available commands are: `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`. A BL-Touch V3.0 or V3.1 may also support `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store` commands.

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`: Ez egy kimeneti módot tárol a BLTouch V3.1 EEPROM-jában: `5V`, `OD`.

### [configfile]

The configfile module is automatically loaded.

#### SAVE_CONFIG

`SAVE_CONFIG`: Ez a parancs felülírja a nyomtató fő konfigurációs fájlját és újraindítja a gazdaszoftvert. Ez a parancs más kalibrálási parancsokkal együtt használható a kalibrációs tesztek eredményeinek tárolására.

### [delayed_gcode]

The following command is enabled if a [delayed_gcode config section](Config_Reference.md#delayed_gcode) has been enabled (also see the [template guide](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: Frissíti az azonosított [delayed_gcode] késleltetési időtartamát és elindítja a G-Kód végrehajtásának időzítőjét. A 0 érték törli a függőben lévő késleltetett G-Kód végrehajtását.

### [delta_calibrate]

The following commands are available when the [delta_calibrate config section](Config_Reference.md#linear-delta-kinematics) is enabled (also see the [delta calibrate guide](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [<probe_parameter>=<value>]`: Ez a parancs az ágy hét pontját vizsgálja meg, és frissített végállások, toronyszögek és sugarak ajánlására szolgál. Az opcionális mérési paraméterekkel kapcsolatos részletekért lásd a PROBE parancsot. Ha a METHOD=manual érték van megadva, akkor a kézi szintezés aktiválódik. Lásd a fenti MANUAL_PROBE parancsot a további parancsok részleteiért, amelyek akkor állnak rendelkezésre, amikor ez az eszköz aktív.

#### DELTA_ANALYZE

`DELTA_ANALYZE`: Ez a parancs a fokozott delta-kalibrálás során használatos. A részletekért lásd a [Delta kalibrálás](Delta_Calibrate.md) című dokumentumot.

### [display]

The following command is available when a [display config section](Config_Reference.md#gcode_macro) is enabled.

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`: Az LCD-kijelző aktív kijelzőcsoportjának beállítása. Ez lehetővé teszi több kijelző adatcsoport definiálását a konfigurációban, pl. `[display_data <group> <elementname>]` és a köztük való váltást ezzel a kiterjesztett G-Kód paranccsal. Ha a DISPLAY nincs megadva, akkor alapértelmezés szerint "display" (az elsődleges kijelző).

### [display_status]

The display_status module is automatically loaded if a [display config section](Config_Reference.md#display) is enabled. It provides the following standard G-Code commands:

- Üzenet megjelenítése: `M117 <message>`
- Nyomtatási folyamat százalékos arány beállítása: `M73 P<percent>`

### [dual_carriage]

The following command is available when the [dual_carriage config section](Config_Reference.md#dual_carriage) is enabled.

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=[0|1]`: Ez a parancs beállítja az aktív kocsit. Általában az activate_gcode és deactivate_gcode mezőkből hívható elő több extruder konfigurációban.

### [endstop_phase]

The following commands are available when an [endstop_phase config section](Config_Reference.md#endstop_phase) is enabled (also see the [endstop phase guide](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]`: Ha nincs megadva STEPPER paraméter, akkor ez a parancs a múltbeli kezdőpont felvételi műveletek során a végállási lépcsőfázisok statisztikáit jelenti. STEPPER paraméter megadása esetén gondoskodik arról, hogy a megadott végállásfázis-beállítás a konfigurációs fájlba íródjon (a SAVE_CONFIG parancs segítségével).

### [extruder]

The following commands are available if an [extruder config section](Config_Reference.md#extruder) is enabled:

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: In a printer with multiple [extruder](Config_Reference.md#extruder) config sections, this command changes the active hotend.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Set pressure advance parameters of an extruder stepper (as defined in an [extruder](Config_Reference#extruder) or [extruder_stepper](Config_Reference#extruder_stepper) config section). If EXTRUDER is not specified, it defaults to the stepper defined in the active hotend.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: Set a new value for the provided extruder stepper's "rotation distance" (as defined in an [extruder](Config_Reference#extruder) or [extruder_stepper](Config_Reference#extruder_stepper) config section). If the rotation distance is a negative number then the stepper motion will be inverted (relative to the stepper direction specified in the config file). Changed settings are not retained on Klipper reset. Use with caution as small changes can result in excessive pressure between extruder and hotend. Do proper calibration with filament before use. If 'DISTANCE' value is not provided then this command will return the current rotation distance.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<name> MOTION_QUEUE=<name>`: This command will cause the stepper specified by EXTRUDER (as defined in an [extruder](Config_Reference#extruder) or [extruder_stepper](Config_Reference#extruder_stepper) config section) to become synchronized to the movement of an extruder specified by MOTION_QUEUE (as defined in an [extruder](Config_Reference#extruder) config section). If MOTION_QUEUE is an empty string then the stepper will be desynchronized from all extruder movement.

#### SET_EXTRUDER_STEP_DISTANCE

This command is deprecated and will be removed in the near future.

#### SYNC_STEPPER_TO_EXTRUDER

This command is deprecated and will be removed in the near future.

### [fan_generic]

The following command is available when a [fan_generic config section](Config_Reference.md#fan_generic) is enabled.

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<speed>` This command sets the speed of a fan. "speed" must be between 0.0 and 1.0.

### [filament_switch_sensor]

The following command is available when a [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) or [filament_motion_sensor](Config_Reference.md#filament_motion_sensor) config section is enabled.

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`: Queries the current status of the filament sensor. The data displayed on the terminal will depend on the sensor type defined in the configuration.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]`: A nyomtatószál érzékelő be/ki kapcsolása. Ha az ENABLE értéke 0, akkor a nyomtatószál-érzékelő ki lesz kapcsolva, ha 1-re van állítva, akkor bekapcsol.

### [firmware_retraction]

The following standard G-Code commands are available when the [firmware_retraction config section](Config_Reference.md#firmware_retraction) is enabled. These commands allow you to utilize the firmware retraction feature available in many slicers, to reduce stringing during non-extrusion moves from one part of the print to another. Appropriately configuring pressure advance reduces the length of retraction required.

- `G10`: Visszahúzza a nyomtatószálat a konfigurált paraméterek szerint.
- `G11`: Betölti a nyomtatószálat a konfigurált paraméterek szerint.

The following additional commands are also available.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>]`: A firmware visszahúzás által használt paraméterek beállítása. A RETRACT_LENGTH határozza meg a visszahúzandó és a visszahúzást megszüntető szál hosszát. A visszahúzás sebessége a RETRACT_SPEED segítségével állítható be, és általában viszonylag magasra van állítva. A visszahúzás sebességét az UNRETRACT_SPEED segítségével állítjuk be, és nem különösebben kritikus, bár gyakran alacsonyabb, mint a RETRACT_SPEED. Bizonyos esetekben hasznos, ha a visszahúzáskor egy kis plusz hosszúságot adunk hozzá, és ezt az UNRETRACT_EXTRA_LENGTH segítségével állítjuk be. A SET_RETRACTION általában a szeletelő szálankénti konfiguráció részeként kerül beállításra, mivel a különböző szálak különböző paraméterbeállításokat igényelnek.

#### GET_RETRACTION

`GET_RETRACTION`: A firmware visszahúzás által használt aktuális paraméterek lekérdezése és megjelenítése a terminálon.

### [force_move]

The force_move module is automatically loaded, however some commands require setting `enable_force_move` in the [printer config](Config_Reference#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<config_name>`: Az adott léptetőmotor mozgatása egy mm-t előre, majd egy mm-t hátra, 10 alkalommal megismételve. Ez egy diagnosztikai eszköz, amely segít a léptető kapcsolatának ellenőrzésében.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]`: Ez a parancs az adott léptetőmotort az adott távolságon (mm-ben) a megadott állandó sebességgel (mm/mp-ben) kényszerrel mozgatja. Ha az ACCEL meg van adva, és nagyobb, mint nulla, akkor a megadott gyorsulás (mm/mp^2-en) kerül alkalmazásra; egyébként nem történik gyorsítás. Nem történik határérték ellenőrzés; nem történik kinematikai frissítés; a tengelyen lévő más párhuzamos léptetők nem kerülnek mozgatásra. Legyen óvatos, mert a helytelen parancs kárt okozhat! A parancs használata szinte biztosan helytelen állapotba hozza az alacsony szintű kinematikát; a kinematika visszaállításához adjon ki utána egy G28 parancsot. Ez a parancs alacsony szintű diagnosztikára és hibakeresésre szolgál.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>]`: Kényszeríti az alacsony szintű kinematikai kódot, hogy azt higgye, a nyomtatófej a megadott cartesian pozícióban van. Ez egy diagnosztikai és hibakeresési parancs; használja a SET_GCODE_OFFSET és/vagy a G92 parancsot a normál tengelytranszformációkhoz. Ha egy tengely nincs megadva, akkor alapértelmezés szerint az a pozíció lesz, ahová a fejet utoljára parancsolták. A helytelen vagy érvénytelen pozíció beállítása belső szoftverhibához vezethet. Ez a parancs érvénytelenítheti a későbbi határérték ellenőrzéseket; a kinematika visszaállításához adjon ki egy G28 parancsot.

### [gcode]

The gcode module is automatically loaded.

#### RESTART

`RESTART`: Ez arra készteti a gazdaszoftvert, hogy újratöltse a konfigurációját és belső alaphelyzetbe állítást végezzen. Ez a parancs nem törli a mikrokontroller hibaállapotát (lásd FIRMWARE_RESTART), és nem tölt be új szoftvert (lásd a [GYIK](FAQ.md#how-do-i-upgrade-to-the-latest-software) oldalt).

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`: Ez hasonló a RESTART parancshoz, de a mikrokontroller hibaállapotát is törli.

#### STATUS

`STATUS`: Jelentse a Klipper gazdagép szoftver állapotát.

#### HELP

`HELP`: A rendelkezésre álló kiterjesztett G-Kód parancsok listájának megjelenítése.

### [gcode_arcs]

A következő szabványos G-kód parancsok elérhetők, ha a [gcode_arcs config section](Config_Reference.md#gcode_arcs) engedélyezve van:

- Vezérelt ívmozgás (G2 vagy G3): `G2 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>`

### [gcode_macro]

The following command is available when a [gcode_macro config section](Config_Reference.md#gcode_macro) is enabled (also see the [command templates guide](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`: Ez a parancs lehetővé teszi a gcode_macro változó értékének megváltoztatását üzem közben. A megadott VALUE-t Python literálként elemzi a program.

### [gcode_move]

The gcode_move module is automatically loaded.

#### GET_POSITION

`GET_POSITION`: Return information on the current location of the toolhead. See the developer documentation of [GET_POSITION output](Code_Overview.md#coordinate-systems) for more information.

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Pozíciós eltolás beállítása, amelyet a későbbi G-kód parancsokra kell alkalmazni. Ezt általában a Z ágy eltolás virtuális megváltoztatására vagy a fúvókák XY eltolásának beállítására használják extruder váltáskor. Például, ha a "SET_GCODE_OFFSET Z=0.2" parancsot küldjük, akkor a jövőbeli G-kód mozgások Z magasságához 0,2 mm-t adunk hozzá. Ha az X_ADJUST stílusparamétereket használjuk, akkor a kiigazítás hozzáadódik a meglévő eltoláshoz (pl. a "SET_GCODE_OFFSET Z=-0.2" és a "SET_GCODE_OFFSET Z_ADJUST=0.3" utána a teljes Z eltolás 0.1 lesz). Ha a "MOVE=1" van megadva, akkor a nyomtatófej mozgatása a megadott eltolás alkalmazására történik (egyébként az eltolás a következő abszolút G-kódú mozgatáskor lép hatályba, amely az adott tengelyt adja meg). Ha a "MOVE_SPEED" meg van adva, akkor a szerszámfej mozgatása a megadott sebességgel (mm/mp-ben) történik; egyébként a nyomtatófej mozgatása az utoljára megadott G-kód sebességet fogja használni.

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<state_name>]`: Az aktuális G-Kód koordináták elemzési állapotának mentése. A G-Kód állapotának mentése és visszaállítása hasznos a szkriptekben és makrókban. Ez a parancs elmenti az aktuális G-Kód abszolút koordinátamódot (G90/G91), az abszolút extrudálási módot (M82/M83), az origót (G92), az eltolást (SET_GCODE_OFFSET), a sebesség felülbírálását (M220), az extruder felülbírálását (M221), a mozgási sebességet, az aktuális XYZ pozíciót és a relatív extruder "E" pozíciót. A NAME megadása esetén lehetővé teszi, hogy a mentett állapotot a megadott karakterláncnak nevezzük el. Ha a NAME nincs megadva, az alapértelmezett érték "default".

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`: A SAVE_GCODE_STATE segítségével korábban elmentett állapot visszaállítása. Ha "MOVE=1" van megadva, akkor a nyomtatófej mozgatása az előző XYZ-pozícióba való visszalépéshez történik. Ha "MOVE_SPEED" van megadva, akkor a nyomtatófej mozgatása a megadott sebességgel (mm/mp-ben) történik; egyébként a nyomtatófej mozgatása a visszaállított G-Kód sebességét használja.

### [hall_filament_width_sensor]

The following commands are available when the [tsl1401cl filament width sensor config section](Config_Reference.md#tsl1401cl_filament_width_sensor) or [hall filament width sensor config section](Config_Reference.md#hall_filament_width_sensor) is enabled (also see [TSLl401CL Filament Width Sensor](TSL1401CL_Filament_Width_Sensor.md) and [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)):

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`: Return the current measured filament width.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`: Clear all sensor readings. Helpful after filament change.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`: Turn off the filament width sensor and stop using it for flow control.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR`: Turn on the filament width sensor and start using it for flow control.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`: Return the current ADC channel readings and RAW sensor value for calibration points.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`: Turn on diameter logging.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`: Turn off diameter logging.

### [heaters]

The heaters module is automatically loaded if a heater is defined in the config file.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`: Kapcsolja ki az összes fűtőberendezést.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Várjon, amíg az adott hőmérséklet-érzékelő a megadott MINIMUM értéken vagy a megadott MINIMUM érték felett és/vagy a megadott MAXIMUM értéken vagy az alatt van.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<heater_name> [TARGET=<target_temperature>]`: A fűtőtest célhőmérsékletének beállítása. Ha nincs megadva célhőmérséklet, akkor az érték 0.

### [idle_timeout]

The idle_timeout module is automatically loaded.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: Lehetővé teszi a felhasználó számára az üresjárati időkorlát beállítását (másodpercben).

### [input_shaper]

The following command is enabled if an [input_shaper config section](Config_Reference.md#input_shaper) has been enabled (also see the [resonance compensation guide](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`: A bemeneti formáló paraméterek módosítása. Vegye figyelembe, hogy a SHAPER_TYPE paraméter visszaállítja a bemeneti formálót mind az X, mind az Y tengelyre, még akkor is, ha az [input_shaper] szakaszban különböző formálótípusok lettek beállítva. A SHAPER_TYPE nem használható együtt a SHAPER_TYPE_X és SHAPER_TYPE_Y paraméterekkel. Az egyes paraméterekkel kapcsolatos további részletekért lásd a [konfigurációs hivatkozást](Config_Reference.md#input_shaper).

### [manual_probe]

The manual_probe module is automatically loaded.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`: Egy segédszkript futtatása, amely hasznos a fúvóka magasságának méréséhez egy adott helyen. Ha SPEED van megadva, akkor a TESTZ parancsok sebességét állítja be (az alapértelmezett 5 mm/mp). A kézi mérés során a következő további parancsok állnak rendelkezésre:

- `ACCEPT`: Ez a parancs elfogadja az aktuális Z pozíciót, és lezárja a kézi szintező eszközt.
- `ABORT`: Ez a parancs megszakítja a kézi szintezést.
- `TESTZ Z=<value>`: Ez a parancs a fúvókát a "value" értékben megadott értékkel felfelé vagy lefelé mozgatja. Például a `TESTZ Z=-.1` a fúvókát 0,1 mm-rel lefelé, míg a `TESTZ Z=.1` a fúvókát 0,1 mm-rel felfelé mozgatja. Az érték lehet `+`, `-`, `++`, vagy `--` is, hogy a fúvókát a korábbi próbálkozásokhoz képest felfelé vagy lefelé mozdítsa.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: Egy segédszkript futtatása, amely hasznos a Z pozíció végállás konfigurációs beállításának kalibrálásához. A paraméterekkel és az eszköz aktív működése közben elérhető további parancsokkal kapcsolatos részletekért használd a MANUAL_PROBE parancsot.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`: Vegyük az aktuális Z G-Kód eltolást (más néven mikrolépés), és vonjuk ki a stepper_z endstop_positionból. Ez egy gyakran használt mikrolépés értéket vesz, és "állandóvá teszi". Egy `SAVE_CONFIG` szükséges a hatálybalépéshez.

### [manual_stepper]

The following command is available when a [manual_stepper config section](Config_Reference.md#manual_stepper) is enabled.

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|2|-1|-2]] [SYNC=0]]]`: Ez a parancs megváltoztatja a léptető állapotát. Az ENABLE paraméterrel engedélyezheti/letilthatja a léptetőt. A SET_POSITION paraméterrel kényszerítheti a léptetőt arra, hogy azt higgye, az adott helyzetben van. A MOVE paraméterrel kezdeményezhet mozgást egy adott pozícióba. Ha a SPEED és/vagy az ACCEL paraméter meg van adva, akkor a rendszer a megadott értékeket használja a konfigurációs fájlban megadott alapértelmezett értékek helyett. Ha nulla ACCEL-t ad meg, akkor nem történik gyorsítás. Ha STOP_ON_ENDSTOP=1 van megadva, akkor a lépés korán véget ér. Ha a végálláskapcsoló aktiválódik (a STOP_ON_ENDSTOP=2 paranccsal hiba nélkül befejezheti a mozgást, még akkor is, ha a végálláskapcsoló nem aktiválódott. Használja a -1 vagy a -2 jelölést, hogy leálljon, amikor a végálláskapcsoló még nem aktiválódott). Normális esetben a későbbi G-Kód parancsok a léptetőmozgás befejezése után kerülnek ütemezésre, azonban ha a kézi léptetőmozgás parancs a SYNC=0 értéket használja, akkor a későbbi G-kód mozgatási parancsok a léptetőmozgással párhuzamosan is futhatnak.

### [led]

The following command is available when any of the [led config sections](Config_Reference.md#leds) are enabled.

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: This sets the LED output. Each color `<value>` must be between 0.0 and 1.0. The WHITE option is only valid on RGBW LEDs. If the LED supports multiple chips in a daisy-chain then one may specify INDEX to alter the color of just the given chip (1 for the first chip, 2 for the second, etc.). If INDEX is not provided then all LEDs in the daisy-chain will be set to the provided color. If TRANSMIT=0 is specified then the color change will only be made on the next SET_LED command that does not specify TRANSMIT=0; this may be useful in combination with the INDEX parameter to batch multiple updates in a daisy-chain. By default, the SET_LED command will sync it's changes with other ongoing gcode commands. This can lead to undesirable behavior if LEDs are being set while the printer is not printing as it will reset the idle timeout. If careful timing is not needed, the optional SYNC=0 parameter can be specified to apply the changes without resetting the idle timeout.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: Assign a [display_template](Config_Reference.md#display_template) to a given [LED](Config_Reference.md#leds). For example, if one defined a `[display_template my_led_template]` config section then one could assign `TEMPLATE=my_led_template` here. The display_template should produce a comma separated string containing four floating point numbers corresponding to red, green, blue, and white color settings. The template will be continuously evaluated and the LED will be automatically set to the resulting colors. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If INDEX is not specified then all chips in the LED's daisy-chain will be set to the template, otherwise only the chip with the given index will be updated. If TEMPLATE is an empty string then this command will clear any previous template assigned to the LED (one can then use `SET_LED` commands to manage the LED's color settings).

### [output_pin]

The following command is available when an [output_pin config section](Config_Reference.md#output_pin) is enabled.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> CYCLE_TIME=<cycle_time>`: Note - hardware PWM does not currently support the CYCLE_TIME parameter and will use the cycle time defined in the config.

### [palette2]

The following commands are available when the [palette2 config section](Config_Reference.md#palette2) is enabled.

A paletta nyomtatások speciális OCode-ok (Omega-kódok) beágyazásával működnek a G-Kód fájlban:

- `O1`...`O32`: Ezeket a kódokat a G-Kód folyamatból olvassa be és dolgozza fel ez a modul, majd továbbítja a Palette 2 eszköznek.

The following additional commands are also available.

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

The pid_calibrate module is automatically loaded if a heater is defined in the config file.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`: A PID kalibrációs teszt elvégzése. A megadott fűtőberendezés a megadott célhőmérséklet eléréséig engedélyezve lesz, majd a fűtőberendezés több cikluson keresztül ki- és bekapcsol. Ha a WRITE_FILE paraméter engedélyezve van, akkor létrejön a /tmp/heattest.txt fájl a teszt során vett összes hőmérséklet-mintát tartalmazó naplóval.

### [pause_resume]

A következő parancsok akkor érhetők el, ha a [pause_resume konfigurációs szakasz](Config_Reference.md#pause_resume) engedélyezve van:

#### PAUSE

`PAUSE`: Az aktuális nyomtatás szüneteltetése. Az aktuális pozíció rögzítésre kerül, hogy a folytatáskor visszaállítható legyen.

#### RESUME

`RESUME [VELOCITY=<value>]`: Folytatja a nyomtatást szünet után, először visszaállítva a korábban rögzített pozíciót. A VELOCITY paraméter határozza meg, hogy a fúvóka milyen sebességgel térjen vissza az eredeti rögzített pozícióba.

#### CLEAR_PAUSE

`CLEAR_PAUSE`: Törli az aktuális szüneteltetett állapotot a nyomtatás folytatása nélkül. Ez akkor hasznos, ha valaki úgy dönt, hogy PAUSE után megszakítja a nyomtatást. Ajánlatos ezt hozzáadni az indító G-Kódhoz, hogy a szüneteltetett állapot minden nyomtatásnál friss legyen.

#### CANCEL_PRINT

`CANCEL_PRINT`: Az aktuális nyomtatás törlése.

### [probe]

The following commands are available when a [probe config section](Config_Reference.md#probe) or [bltouch config section](Config_Reference.md#bltouch) is enabled (also see the [probe calibrate guide](Probe_Calibrate.md)).

#### PROBE

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`: Mozgassa a fúvókát lefelé, amíg a szonda nem érzékel. Ha bármelyik opcionális paramétert megadjuk, azok felülírják a [szonda konfigurációs szakaszában](Config_Reference.md#szonda) megadott megfelelő beállításokat.

#### QUERY_PROBE

`QUERY_PROBE`: Jelentse a szonda aktuális állapotát ("triggered" vagy "open").

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`: Több mérési minta maximumának, minimumának, átlagának, mediánjának és szórásának kiszámítása. Alapértelmezés szerint 10 MINTÁT veszünk. Egyébként az opcionális paraméterek alapértelmezés szerint a szonda konfigurációs szakaszában szereplő megfelelő beállításokat használják.

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>]`: A szonda z_offset kalibrálásához hasznos segédszkript futtatása. Az opcionális szondaparaméterekkel kapcsolatos részletekért lásd a PROBE parancsot. Lásd a MANUAL_PROBE parancsot a SPEED paraméterre és az eszköz aktív működése közben elérhető további parancsokra vonatkozó részletekért. Felhívjuk a figyelmet, hogy a PROBE_CALIBRATE parancs a sebesség változót használja az XY irányú és a Z irányú mozgáshoz.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`: Vegyük az aktuális Z G-Kód eltolást (más néven mikrolépés), és vonjuk ki a szonda z_offset-jéből. Ez egy gyakran használt mikrolépés értéket vesz, és "állandóvá teszi". Egy `SAVE_CONFIG` szükséges a hatálybalépéshez.

### [query_adc]

The query_endstops module is automatically loaded.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]`: Jelenti a konfigurált analóg tűhöz utoljára kapott analóg értéket. Ha NAME nincs megadva, a rendelkezésre álló ADC nevek listája kerül jelentésre. Ha a PULLUP meg van adva (ohmban megadott értékként), akkor a nyers analóg értéket és a pullup adott egyenértékű ellenállást jelenti.

### [query_endstops]

The query_endstops module is automatically loaded. The following standard G-Code commands are currently available, but using them is not recommended:

- Végállás állapotának lekérdezése: `M119` (Használja QUERY_ENDSTOPS helyett.)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`: Méri a tengelyvégállásokat és jelenti, ha azok "kioldottak" vagy "nyitott" állapotban vannak. Ezt a parancsot általában annak ellenőrzésére használják, hogy egy végállás megfelelően működik-e.

### [resonance_tester]

The following commands are available when a [resonance_tester config section](Config_Reference.md#resonance_tester) is enabled (also see the [measuring resonances guide](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: Az összes engedélyezett gyorsulásmérő chip összes tengelyének zaját méri és adja ki.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> OUTPUT=<resonances,raw_data> [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [INPUT_SHAPING=[<0:1>]]`: Runs the resonance test in all configured probe points for the requested "axis" and measures the acceleration using the accelerometer chips configured for the respective axis. "axis" can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. If `INPUT_SHAPING=0` or not set (default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [MAX_SMOOTHING=<max_smoothing>]`: A `TEST_RESONANCES` paraméterhez hasonlóan lefuttatja a rezonancia tesztet a konfiguráltak szerint, és megpróbálja megtalálni a bemeneti változó optimális paramétereit a kért tengelyre (vagy mind az X, mind az Y tengelyre, ha az `AXIS` paraméter nincs beállítva). Ha a `MAX_SMOOTHING` nincs beállítva, az értékét a `[resonance_tester]` szakaszból veszi, az alapértelmezett érték pedig a be nem állított érték. Lásd a [Max simítás](Measuring_Resonances.md#max-smoothing) a rezonanciák mérése című útmutatóban a funkció használatáról szóló további információkat. A hangolás eredményei kiíródnak a konzolra, a frekvenciaválaszok és a különböző bemeneti alakítók értékei pedig egy vagy több CSV-fájlba íródnak `/tmp/calibration_data_<axis>_<name>.csv`. Hacsak nincs megadva, a NAME alapértelmezés szerint az aktuális időpontot jelenti "YYYYMMDD_HHMMSS" formátumban. Vegye figyelembe, hogy a javasolt bemeneti változó paraméterek a `SAVE_CONFIG` parancs kiadásával megőrizhetők a konfigurációs fájlban.

### [respond]

The following standard G-Code commands are available when the [respond config section](Config_Reference.md#respond) is enabled:

- `M118 <message>`: visszhangozza az üzenetet a konfigurált alapértelmezett előtaggal (vagy `echo: `, ha nincs konfigurálva előtag).

The following additional commands are also available.

#### RESPOND

- `RESPOND MSG="<message>"`: visszhangozza az üzenetet a konfigurált alapértelmezett előtaggal kiegészítve (vagy `echo: `, ha nincs konfigurálva előtag).
- `RESPOND TYPE=echo MSG="<message>"`: visszhangozza az üzenetet, amelyet `echo: ` küld.
- `RESPOND TYPE=command MSG="<message>"`: echo the message prepended with `// `. OctoPrint can be configured to respond to these messages (e.g. `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<message>"`: visszhangozza az üzenetet `!! `.
- `RESPOND PREFIX=<prefix> MSG="<message>"`: visszhangozza az üzenetet `<prefix>` előtaggal kiegészítve. (A `PREFIX` paraméter elsőbbséget élvez a `TYPE` paraméterrel szemben.)

### [save_variables]

The following command is enabled if a [save_variables config section](Config_Reference.md#save_variables) has been enabled.

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`: A változót a lemezre menti, hogy újraindításkor is használható legyen. Minden tárolt változó betöltődik a `printer.save_variables.variables` dict indításkor, és használható a G-Kód makrókban. A megadott VALUE-t Python literálként elemzi.

### [screws_tilt_adjust]

The following commands are available when the [screws_tilt_adjust config section](Config_Reference.md#screws_tilt_adjust) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [<probe_parameter>=<value>]`: Ez a parancs az ágy csavarjainak beállítási eszközét hívja elő. A fúvókát különböző helyekre (a konfigurációs fájlban meghatározottak szerint) parancsolja a Z magasságot mérve és kiszámítja az ágy szintjének beállításához szükséges gombfordulatok számát. Ha DIRECTION van megadva, akkor a gombfordulatok mind ugyanabba az irányba, az óramutató járásával megegyező (CW) vagy az óramutató járásával ellentétes (CCW) irányba fognak történni. Az opcionális szondaparaméterekkel kapcsolatos részletekért lásd a PROBE parancsot. FONTOS: A parancs használata előtt mindig el kell végezni egy G28-at.

### [sdcard_loop]

When the [sdcard_loop config section](Config_Reference.md#sdcard_loop) is enabled, the following extended commands are available.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`: Begin a looped section in the SD print. A count of 0 indicates that the section should be looped indefinitely.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: Az SD-nyomtatásban egy ciklusos szakasz befejezése.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: A meglévő ciklusok befejezése további iterációk nélkül.

### [servo]

The following commands are available when a [servo config section](Config_Reference.md#servo) is enabled.

#### SET_SERVO

`SET_SERVO SERVO=config_name [ANGLE=<degrees> | WIDTH=<seconds>]`: A szervó pozíciójának beállítása a megadott szögre (fokban) vagy impulzusszélességre (másodpercben). A `WIDTH=0` használatával letilthatja a szervókimenetet.

### [skew_correction]

The following commands are available when the [skew_correction config section](Config_Reference.md#skew_correction) is enabled (also see the [Skew Correction](Skew_Correction.md) guide).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`: A [skew_correction] modul konfigurálása a kalibrációs nyomatból vett mérésekkel (mm-ben). A mérések a síkok tetszőleges kombinációjára adhatók meg, a be nem adott síkok megtartják az aktuális értéküket. Ha `CLEAR=1` van megadva, akkor minden ferdeségkorrekció ki lesz kapcsolva.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: A nyomtató aktuális ferdeségét jelenti minden síkhoz radiánban és fokban. A ferdeség kiszámítása a `SET_SKEW` G-Kóddal megadott paraméterek alapján történik.

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>]`: Calculates and reports the skew (in radians and degrees) based on a measured print. This can be useful for determining the printer's current skew after correction has been applied. It may also be useful before correction is applied to determine if skew correction is necessary. See [Skew Correction](Skew_Correction.md) for details on skew calibration objects and measurements.

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<name>] [SAVE=<name>] [REMOVE=<name>]`: Profile management for skew_correction. LOAD will restore skew state from the profile matching the supplied name. SAVE will save the current skew state to a profile matching the supplied name. Remove will delete the profile matching the supplied name from persistent memory. Note that after SAVE or REMOVE operations have been run the SAVE_CONFIG gcode must be run to make the changes to persistent memory permanent.

### [stepper_enable]

The stepper_enable module is automatically loaded.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<config_name> ENABLE=[0|1]`: Csak az adott léptetőmotor engedélyezése vagy letiltása. Ez egy diagnosztikai és hibakeresési eszköz, ezért óvatosan kell használni. Egy léptetőmotor letiltása nem állítja vissza a kezdőpont felvételi információkat. Egy letiltott léptetőmotor kézi mozgatása azt okozhatja, hogy a gép a biztonságos határértékeken kívül működteti a motort. Ez a tengely alkatrészeinek, a nyomtatófejnek és a nyomtatási felületnek a károsodásához vezethet.

### [temperature_fan]

The following command is available when a [temperature_fan config section](Config_Reference.md#temperature_fan) is enabled.

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>] [max_speed=<max_speed>]`: Sets the target temperature for a temperature_fan. If a target is not supplied, it is set to the specified temperature in the config file. If speeds are not supplied, no change is applied.

### [tmcXXXX]

The following commands are available when any of the [tmcXXXX config sections](Config_Reference.md#tmc-stepper-driver-configuration) are enabled.

#### DUMP_TMC

`DUMP_TMC STEPPER=<name>`: Ez a parancs kiolvassa a TMC-motorvezérlő regisztereit és jelenti azok értékeit.

#### INIT_TMC

`INIT_TMC STEPPER=<name>`: This command will initialize the TMC registers. Needed to re-enable the driver if power to the chip is turned off then back on.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: Ez a TMC-motorvezérlő futó- és tartóáramát állítja be. (A HOLDCURRENT nem alkalmazható a tmc2660 motorvezérlőkre).

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value>`: Ez módosítja a TMC-motorvezérlő megadott regisztermezőjének értékét. Ez a parancs csak alacsony szintű diagnosztikára és hibakeresésre szolgál, mivel a mezők futás közbeni módosítása a nyomtató nem kívánt és potenciálisan veszélyes viselkedéséhez vezethet. A tartós változtatásokat inkább a nyomtató konfigurációs fájljának használatával kell elvégezni. A megadott értékek esetében nem történik ellenőrzés.

### [toolhead]

The toolhead module is automatically loaded.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [ACCEL_TO_DECEL=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: A nyomtató sebességhatárainak módosítása.

### [tuning_tower]

The tuning_tower module is automatically loaded.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<command> PARAMETER=<name> START=<value> [SKIP=<value>] [FACTOR=<value> [BAND=<value>]] | [STEP_DELTA=<value> STEP_HEIGHT=<value>]`: Egy eszköz egy paraméter beállítására minden egyes Z magasságon a nyomtatás során. Az eszköz az adott `COMMAND` parancsot a megadott `PARAMETER` értékhez rendelt `Z` értékkel egy képlet szerint változó értékkel futtatja. Használja a `FACTOR` lehetőséget, ha vonalzóval vagy tolómérővel fogja mérni az optimális Z magasságot, vagy `STEP_DELTA` és `STEP_HEIGHT`, ha a hangolótorony modellje diszkrét értékek sávjaival rendelkezik, mint ahogy az a hőmérséklet-tornyoknál gyakori. Ha `SKIP=<value>` van megadva, akkor a hangolási folyamat nem kezdődik meg, amíg a Z magasság `<value>` elérését, és ez alatt az érték `START` értékre lesz beállítva; ebben az esetben az alábbi képletekben használt `z_height` valójában `max(z - skip, 0)`. Három lehetséges kombináció létezik:

- `FACTOR`: The value changes at a rate of `factor` per millimeter. The formula used is: `value = start + factor * z_height`. You can plug the optimum Z height directly into the formula to determine the optimum parameter value.
- `FACTOR` and `BAND`: The value changes at an average rate of `factor` per millimeter, but in discrete bands where the adjustment will only be made every `BAND` millimeters of Z height. The formula used is: `value = start + factor * ((floor(z_height / band) + .5) * band)`.
- `STEP_DELTA` and `STEP_HEIGHT`: The value changes by `STEP_DELTA` every `STEP_HEIGHT` millimeters. The formula used is: `value = start + step_delta * floor(z_height / step_height)`. You can simply count bands or read tuning tower labels to determine the optimum value.

### [virtual_sdcard]

Klipper supports the following standard G-Code commands if the [virtual_sdcard config section](Config_Reference.md#virtual_sdcard) is enabled:

- SD-kártya listázása: `M20`
- SD-kártya inicializálása: `M21`
- Válassza ki az SD fájlt: `M23 <filename>`
- SD nyomtatás indítása/folytatása: `M24`
- SD nyomtatás szüneteltetése: `M25`
- SD pozíció beállítása: `M26 S<offset>`
- SD nyomtatási státusz jelentése: `M27`

In addition, the following extended commands are available when the "virtual_sdcard" config section is enabled.

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<filename>`: Load a file and start SD print.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`: Unload file and clear SD state.

### [z_tilt]

The following commands are available when the [z_tilt config section](Config_Reference.md#z_tilt) is enabled.

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [<probe_parameter>=<value>]`: Ez a parancs a konfigurációban megadott pontokat vizsgálja meg, majd a dőlés kompenzálása érdekében minden egyes Z léptetőn független beállításokat végez. Az opcionális mérési paraméterekkel kapcsolatos részletekért lásd a PROBE parancsot.
