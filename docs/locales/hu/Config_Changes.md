# Configuration Changes

Ez a dokumentum a konfigurációs fájl legújabb szoftveres változtatásait tartalmazza, amelyek nem kompatibilisek visszafelé. A Klipper szoftver frissítésekor érdemes áttanulmányozni ezt a dokumentumot.

A dokumentumban szereplő valamennyi dátum hozzávetőleges.

## Változások

20220307: `M73` will no longer set print progress to 0 if `P` is missing.

20220304: There is no longer a default for the `extruder` parameter of [extruder_stepper](Config_Reference.md#extruder_stepper) config sections. If desired, specify `extruder: extruder` explicitly to associate the stepper motor with the "extruder" motion queue at startup.

20220210: The `SYNC_STEPPER_TO_EXTRUDER` command is deprecated; the `SET_EXTRUDER_STEP_DISTANCE` command is deprecated; the [extruder](Config_Reference.md#extruder) `shared_heater` config option is deprecated. These features will be removed in the near future. Replace `SET_EXTRUDER_STEP_DISTANCE` with `SET_EXTRUDER_ROTATION_DISTANCE`. Replace `SYNC_STEPPER_TO_EXTRUDER` with `SYNC_EXTRUDER_MOTION`. Replace extruder config sections using `shared_heater` with [extruder_stepper](Config_Reference.md#extruder_stepper) config sections and update any activation macros to use [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion).

20220116: The tmc2130, tmc2208, tmc2209, and tmc2660 `run_current` calculation code has changed. For some `run_current` settings the drivers may now be configured differently. This new configuration should be more accurate, but it may invalidate previous tmc driver tuning.

20211230: Scripts to tune input shaper (`scripts/calibrate_shaper.py` and `scripts/graph_accelerometer.py`) were migrated to use Python3 by default. As a result, users must install Python3 versions of certain packages (e.g. `sudo apt install python3-numpy python3-matplotlib`) to continue using these scripts. For more details, refer to [Software installation](Measuring_Resonances.md#software-installation). Alternatively, users can temporarily force the execution of these scripts under Python 2 by explicitly calling Python2 interpretor in the console: `python2 ~/klipper/scripts/calibrate_shaper.py ...`

20211110: The "NTC 100K beta 3950" temperature sensor is deprecated. This sensor will be removed in the near future. Most users will find the "Generic 3950" temperature sensor more accurate. To continue to use the older (typically less accurate) definition, define a custom [thermistor](Config_Reference.md#thermistor) with `temperature1: 25`, `resistance1: 100000`, and `beta: 3950`.

20211104: The "step pulse duration" option in "make menuconfig" has been removed. The default step duration for TMC drivers configured in UART or SPI mode is now 100ns. A new `step_pulse_duration` setting in the [stepper config section](Config_Reference.md#stepper) should be set for all steppers that need a custom pulse duration.

20211102: Several deprecated features have been removed. The stepper `step_distance` option has been removed (deprecated on 20201222). The `rpi_temperature` sensor alias has been removed (deprecated on 20210219). The mcu `pin_map` option has been removed (deprecated on 20210325). The gcode_macro `default_parameter_<name>` and macro access to command parameters other than via the `params` pseudo-variable has been removed (deprecated on 20210503). The heater `pid_integral_max` option has been removed (deprecated on 20210612).

20210929: Klipper v0.10.0 released.

20210903: The default [`smooth_time`](Config_Reference.md#extruder) for heaters has changed to 1 second (from 2 seconds). For most printers this will result in more stable temperature control.

20210830: The default adxl345 name is now "adxl345". The default CHIP parameter for the `ACCELEROMETER_MEASURE` and `ACCELEROMETER_QUERY` is now also "adxl345".

20210830: The adxl345 ACCELEROMETER_MEASURE command no longer supports a RATE parameter. To alter the query rate, update the printer.cfg file and issue a RESTART command.

20210821: Several config settings in `printer.configfile.settings` will now be reported as lists instead of raw strings. If the actual raw string is desired, use `printer.configfile.config` instead.

20210819: In some cases, a `G28` homing move may end in a position that is nominally outside the valid movement range. In rare situations this may result in confusing "Move out of range" errors after homing. If this occurs, change your start scripts to move the toolhead to a valid position immediately after homing.

20210814: The analog only pseudo-pins on the atmega168 and atmega328 have been renamed from PE0/PE1 to PE2/PE3.

20210720: A controller_fan section now monitors all stepper motors by default (not just the kinematic stepper motors). If the previous behavior is desired, see the `stepper` config option in the [config reference](Config_Reference.md#controller_fan).

20210703: A `samd_sercom` config section must now specify the sercom bus it is configuring via the `sercom` option.

20210612: A `pid_integral_max` konfigurációs opció a fűtés és a temperature_fan szakaszokban elavult. Az opció a közeljövőben eltávolításra kerül.

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430: A SET_VELOCITY_LIMIT (és az M204) parancs mostantól a konfigurációs fájlban megadott értékeknél nagyobb sebességet, gyorsulást és square_corner_velocity-t is beállíthat.

20210325: A `pin_map` config opció támogatása elavult. Használja a [sample-aliases.cfg](../config/sample-aliases.cfg) fájlt a tényleges mikrokontroller pin nevekre való fordításhoz. A `pin_map` config opció a közeljövőben eltávolításra kerül.

20210313: A Klipper CAN-busszal kommunikáló mikrovezérlők támogatása megváltozott. Ha CAN-buszt használ, akkor az összes mikrokontrollert újra kell égetni és a [Klipper konfigurációt frissíteni kell](CANBUS.md).

20210310: A TMC2660 alapértelmezett driver_SFILT értéke 1-ről 0-ra változott.

20210227: Az UART vagy SPI módban lévő TMC léptetőmotor-meghajtók mostantól másodpercenként egyszer lekérdezésre kerülnek, amikor engedélyezve vannak. Ha a meghajtóval nem lehet kapcsolatba lépni, vagy ha a meghajtó hibát jelent, akkor a Klipper leállási állapotba lép.

20210219: Az `rpi_temperature` modult átneveztük `temperature_host`-ra. A `sensor_type: rpi_temperature` minden előfordulását cserélje ki `sensor_type: temperature_host`-ra. A hőmérsékleti fájl elérési útvonalát a `sensor_path` config változóban lehet megadni. Az `rpi_temperature` név elavult, és a közeljövőben eltávolításra kerül.

20210201: A `TEST_RESONANCES` parancs mostantól letiltja a bemeneti alakítást, ha az korábban engedélyezve volt (és a teszt után újra engedélyezi). Ennek a viselkedésnek a felülírása és a bemeneti alakítás engedélyezve tartása érdekében egy további `INPUT_SHAPING=1` paramétert adhatunk át a parancsnak.

20210201: Az `ACCELEROMETER_MEASURE` parancs mostantól a kimeneti fájl nevéhez hozzáadja a gyorsulásmérő chip nevét, ha a chipnek a printer.cfg megfelelő adxl345 szakaszában adtak nevet.

20201222: A `step_distance` beállítás a stepper config szakaszokban elavult. Javasoljuk, hogy frissítse a konfigurációt a [`rotation_distance`](Rotation_Distance.md) beállítás használatára. A `step_distance` támogatása a közeljövőben megszűnik.

20201218: Az endstop_phase modulban az `endstop_phase` beállítás helyébe a `trigger_phase` beállítás lépett. Ha az endstop phase modult használja, akkor át kell konvertálni a [`rotation_distance`](Rotation_Distance.md) értékre, és az ENDSTOP_PHASE_CALIBRATE parancs futtatásával újra kell kalibrálni az esetleges endstop fázisokat.

20201218: A forgó delta- és polárnyomtatóknak mostantól meg kell adniuk egy `gear_ratio` paramétert a forgó léptetőikhez, és többé nem adhatnak meg `step_distance` paramétert. Az új gear_ratio paraméter formátumát lásd a [konfigurációs hivatkozás](Config_Reference.md#stepper) dokumentumban.

20201213: A "probe:z_virtual_endstop" használatakor nem érvényes a Z "position_endstop" megadása. Mostantól hibaüzenet jelenik meg, ha Z "position_endstop" van megadva a "probe:z_virtual_endstop" használatával. A hiba kijavításához távolítsa el a Z "position_endstop" meghatározást.

20201120: A `[board_pins]` config szakasz most már explicit `mcu:` paraméterben adja meg az MCU nevét. Ha board_pins-t használunk egy másodlagos MCU-hoz, akkor a configot frissíteni kell, hogy megadja ezt a nevet. További részletekért lásd a [konfigurációs referenciát](Config_Reference.md#board_pins).

20201112: A `print_stats.print_duration` által bejelentett idő megváltozott. Az első észlelt extrudálás előtti időtartamot mostantól nem veszi figyelembe.

20201029: A neopixel `color_order_GRB` config opciót eltávolítottuk. Szükség esetén frissítse a configot, hogy az új `color_order` opciót RGB, GRB, RGBW vagy GRBW értékre állítsa be.

20201029: A serial opció az mcu config szakaszban már nem /dev/ttyS0 az alapértelmezett érték. Abban a ritka helyzetben, amikor a /dev/ttyS0 a kívánt soros port, azt kifejezetten meg kell adni.

20201020: Klipper v0.9.0 megjelent.

20200902: A MAX31865 átalakítók RTD ellenállás-hőmérséklet számítása javításra került, hogy ne legyen alacsony. Ha ilyen eszközt használ, akkor kalibrálja újra a nyomtatási hőmérsékletet és a PID-beállításokat.

20200816: A G-kód makró `printer.gcode` objektumot átneveztük `printer.gcode_move` objektumra. A `printer.toolhead` és `printer.gcode` objektumokból több nem dokumentált változót eltávolítottunk. A rendelkezésre álló sablonváltozók listáját lásd a docs/Command_Templates.md fájlban.

20200816: A G-kód makró "action_" rendszere megváltozott. Cserélje ki a `printer.gcode.action_emergency_stop()` hívásokat `action_emergency_stop()`, `printer.gcode.action_respond_info()` a `action_respond_info()`, és `printer.gcode.action_respond_error()` a `action_raise_error()`-el.

20200809: A menürendszer átírásra került. Ha a menüt testre szabták, akkor frissíteni kell az új konfigurációra. A konfiguráció részleteiért lásd a config/example-menu.cfg fájlt, a példákért pedig a klippy/extras/display/menu.cfg fájlt.

20200731: A `progress` attribútum viselkedése megváltozott, amelyet a `virtual_sdcard` nyomtatóobjektum jelentett. A nyomtatás szüneteltetésekor a Progress már nem áll vissza 0-ra. Mostantól mindig a belső fájl pozíciója alapján jelenti a haladást. Vagy 0, ha nincs betöltve fájl.

20200725: A szervo `enable` konfigurációs paraméter és a SET_SERVO `ENABLE` paraméter eltávolításra került. Frissítsen minden makrót, hogy a `SET_SERVO SERVO=my_servo WIDTH=0` paramétert használja a szervó letiltásához.

20200608: Az LCD-kijelző támogatása megváltoztatta néhány belső "írásjel" nevét. Ha egyéni kijelző elrendezés került implementálásra, akkor szükséges lehet frissíteni a legújabb gliph nevekre (lásd klippy/extras/display/display.cfg az elérhető gliph-ek listáját).

20200606: A linux MCU pin nevei megváltoztak. A pin nevek mostantól a `gpiochip<chipid>/gpio<gpio>` formájúak. A gpiochip0 esetében egy rövid `gpio<gpio>` is használható. Például, amire korábban `P20` néven hivatkoztunk, az most `gpio20` vagy `gpiochip0/gpio20` lesz.

20200603: Az alapértelmezett 16x4-es LCD kijelzőn már nem jelenik meg a nyomtatásból hátralévő becsült idő. (Csak az eltelt idő jelenik meg.) Ha a régi működést szeretnénk, akkor a menü kijelzőjét testre lehet szabni ezzel az információval (a részletekért lásd a config/example-extras.cfg fájlban a display_data leírását).

20200531: Az alapértelmezett USB gyártó/termék azonosító mostantól 0x1d50/0x614e. Ezek az új azonosítók a Klipper számára vannak fenntartva (köszönet az openmoko projektnek). Ez a változás nem igényel semmilyen konfigurációs módosítást, de az új azonosítók megjelenhetnek a rendszer naplóiban.

20200524: A TMC5160 pwm_freq mező alapértelmezett értéke mostantól nulla (egy helyett).

20200425: A gcode_macro parancs sablonváltozója `printer.heater` át lett nevezve `printer.heaters`-re.

20200313: A 16x4-es képernyővel és a több extruderrel rendelkező nyomtatók alapértelmezett LCD-kiosztása megváltozott. Mostantól az egy extruderrel rendelkező képernyő elrendezése az alapértelmezett, és az aktuálisan aktív extrudert mutatja. A korábbi kijelző elrendezés használatához állítsa be a "display_group: _multiextruder_16x4" a printer.cfg fájl [display] szakaszában.

20200308: Az alapértelmezett `__test` menüpont eltávolításra került. Ha a konfigurációs fájlban egyéni menü van, akkor mindenképpen távolítson el minden hivatkozást erre a `__test` menüpontra.

20200308: A "pakli" és "kártya" menüpontok eltávolításra kerültek. Az LCD képernyő elrendezésének testreszabásához használd az új display_data config szakaszokat (a részletekért lásd a config/example-extras.cfg fájlt).

20200109: A bed_mesh modul most már hivatkozik a szonda helyére a hálókonfigurációban. Ennek megfelelően néhány konfigurációs opciót átneveztek, hogy pontosabban tükrözze a tervezett funkciójukat. Téglalap alakú ágyak esetében a `min_point` és `max_point` átnevezésre került `mesh_min` és `mesh_max`-ra. A kerek ágyak esetében a `bed_radius` át lett nevezve `mesh_radius`-ra. A kerek ágyakhoz egy új `mesh_origin` opció is hozzá lett adva. Vegye figyelembe, hogy ezek a változások a korábban elmentett hálóprofilokkal is inkompatibilisek. Ha egy inkompatibilis profilt észlelünk, azt figyelmen kívül hagyjuk és eltávolításra ütemezzük. Az eltávolítási folyamat a SAVE_CONFIG parancs kiadásával fejezhető be. A felhasználónak minden egyes profilt újra kell kalibrálnia.

20191218: A display config szakasz már nem támogatja az "lcd_type: st7567". Használja helyette az "uc1701" kijelzőtípust. Állítsa be az "lcd_type: uc1701" értéket, és módosítsa az "rs_pin: some_pin" értéket "rst_pin: some_pin" értékre. Szükség lehet még egy "contrast: 60" konfigurációs beállítás hozzáadására.

20191210: A beépített T0, T1, T2, ... parancsok eltávolításra kerültek. Az extruder activate_gcode és deactivate_gcode konfigurációs opciók eltávolításra kerültek. Ha szükség van ezekre a parancsokra (és szkriptekre), akkor definiáljon egyedi [gcode_macro T0] stílusú makrókat, amelyek meghívják az ACTIVATE_EXTRUDER parancsot. Példákért lásd a config/sample-idex.cfg és sample-multi-extruder.cfg fájlokat.

20191210: Az M206 parancs támogatása megszűnt. A SET_GCODE_OFFSET hívásával helyettesítjük. Ha szükség van az M206 támogatására, adjunk hozzá egy [gcode_macro M206] config szakaszt, amely meghívja a SET_GCODE_OFFSET-et. (Például "SET_GCODE_OFFSET Z=-{params.Z}".)

20191202: A "G4" parancs nem dokumentált "S" paraméterének támogatása megszűnt. Az S minden előfordulását a szabványos "P" paraméterrel helyettesíti (a milliszekundumokban megadott késleltetés).

20191126: Az USB nevek megváltoztak a natív USB-támogatással rendelkező mikrovezérlőkön. Mostantól alapértelmezés szerint egyedi chip-azonosítót használnak (ahol van ilyen). Ha egy "MCU" config szakasz olyan "serial" beállítást használ, amely "/dev/serial/by-id/" kezdetű, akkor szükség lehet a config frissítésére. Futtassa a "ls /dev/serial/by-id/*" parancsot egy SSH terminálban az új azonosító meghatározásához.

20191121: A pressure_advance_lookahead_time paramétert eltávolítottuk. Az alternatív konfigurációs beállításokat lásd a example.cfg fájlban.

20191112: A TMC léptető vezérlő virtuális engedélyezési képessége mostantól automatikusan engedélyezve van, ha a léptető nem rendelkezik dedikált léptető engedélyező pin-nel. A tmcXXXX:virtual_enable-re való hivatkozások eltávolítása a konfigurációból. A stepper enable_pin konfigurációban több pin vezérlésének lehetősége megszűnt. Ha több pinre van szükség, akkor használjon egy multi_pin config szekciót.

20191107: Az elsődleges extruder konfigurációs szakaszát "extruder" néven kell megadni, és már nem lehet "extruder0" néven megadni. Az extruder állapotát lekérdező Gcode parancssablonokat mostantól a "{printer.extruder}" segítségével lehet elérni.

20191021: Klipper v0.8.0 megjelent

20191003: A move_to_previous opció a [safe_z_homing]-ban mostantól alapértelmezés szerint False. (A 20190918 előtt ténylegesen False volt.)

20190918: A z-hop opció a [safe_z_homing]-ban mindig újra alkalmazásra kerül, miután a Z tengelyre történő homing befejeződött. Ez szükségessé teheti a felhasználók számára, hogy frissítsék az ezen a modulon alapuló egyéni szkripteket.

20190806: A SET_NEOPIXEL parancsot átnevezték SET_LED-re.

20190726: Az mcp4728 digitális-analóg kódja megváltozott. Az alapértelmezett i2c_address most 0x60, és a feszültségreferencia most az mcp4728's belső 2,048 voltos referenciához viszonyítva van.

20190710: A [firmware_retract] konfigurációs szakaszból eltávolították a z_hop opciót. A z_hop támogatása hiányos volt, és több gyakori szeletelővel hibás viselkedést okozott.

20190710: The optional parameters of the PROBE_ACCURACY command have changed. It may be necessary to update any macros or scripts that use that command.

20190628: All configuration options have been removed from the [skew_correction] section. Configuration for skew_correction is now done via the SET_SKEW gcode. See [Skew Correction](Skew_Correction.md) for recommended usage.

20190607: The "variable_X" parameters of gcode_macro (along with the VALUE parameter of SET_GCODE_VARIABLE) are now parsed as Python literals. If a value needs to be assigned a string then wrap the value in quotes so that it is evaluated as a string.

20190606: The "samples", "samples_result", and "sample_retract_dist" config options have been moved to the "probe" config section. These options are no longer supported in the "delta_calibrate", "bed_tilt", "bed_mesh", "screws_tilt_adjust", "z_tilt", or "quad_gantry_level" config sections.

20190528: The magic "status" variable in gcode_macro template evaluation has been renamed to "printer".

20190520: The SET_GCODE_OFFSET command has changed; update any g-code macros accordingly. The command will no longer apply the requested offset to the next G1 command. The old behavior may be approximated by using the new "MOVE=1" parameter.

20190404: The Python host software packages were updated. Users will need to rerun the ~/klipper/scripts/install-octopi.sh script (or otherwise upgrade the python dependencies if not using a standard OctoPi installation).

20190404: The i2c_bus and spi_bus parameters (in various config sections) now take a bus name instead of a number.

20190404: The sx1509 config parameters have changed. The 'address' parameter is now 'i2c_address' and it must be specified as a decimal number. Where 0x3E was previously used, specify 62.

20190328: The min_speed value in [temperature_fan] config will now be respected and the fan will always run at this speed or higher in PID mode.

20190322: The default value for "driver_HEND" in [tmc2660] config sections was changed from 6 to 3. The "driver_VSENSE" field was removed (it is now automatically calculated from run_current).

20190310: The [controller_fan] config section now always takes a name (such as [controller_fan my_controller_fan]).

20190308: The "driver_BLANK_TIME_SELECT" field in [tmc2130] and [tmc2208] config sections has been renamed to "driver_TBL".

20190308: The [tmc2660] config section has changed. A new sense_resistor config parameter must now be provided. The meaning of several of the driver_XXX parameters has changed.

20190228: Users of SPI or I2C on SAMD21 boards must now specify the bus pins via a [samd_sercom] config section.

20190224: The bed_shape option has been removed from bed_mesh. The radius option has been renamed to bed_radius. Users with round beds should supply the bed_radius and round_probe_count options.

20190107: The i2c_address parameter in the mcp4451 config section changed. This is a common setting on Smoothieboards. The new value is half the old value (88 should be changed to 44, and 90 should be changed to 45).

20181220: Klipper v0.7.0 released
