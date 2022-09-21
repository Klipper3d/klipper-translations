# Konfigurációs változások

Ez a dokumentum a konfigurációs fájl legújabb szoftveres változtatásait tartalmazza, amelyek nem kompatibilisek visszafelé. A Klipper szoftver frissítésekor érdemes áttanulmányozni ezt a dokumentumot.

A dokumentumban szereplő valamennyi dátum hozzávetőleges.

## Változások

20220616: Korábban egy rp2040-et bootloader módban lehetett égetni a `make flash FLASH_DEVICE=first` futtatásával. Az ezzel egyenértékű parancs mostantól `make flash FLASH_DEVICE=2e8a:0003`.

20220612: Az rp2040 mikrokontroller mostantól rendelkezik a "rp2040-e5" USB hiba elhárításával. Ez megbízhatóbbá teszi a kezdeti USB-kapcsolatokat. Ez azonban a GPIO15 tű viselkedésének megváltozását eredményezheti. Nem valószínű, hogy a GPIO15 viselkedésének változása észrevehető lesz.

20220407: A temperature_fan `pid_integral_max` konfigurációs opciót eltávolítottuk (a 20210612-es verzióval elavult).

20220407: A pca9632 LED-ek alapértelmezett színsorrendje mostantól "RGBW". Adjunk hozzá egy explicit `color_ordert: RBGW` beállítást a pca9632 konfigurációs szakaszába a korábbi működés visszaállításához.

20220330: A `printer.neopixel.color_data` állapotinformáció formátuma megváltozott a neopixel és dotstar modulok esetében. Az információ mostantól színlisták listájaként tárolódik (szótárak listája helyett). A részletekért lásd az [állapot hivatkozás](Status_Reference.md#led) című dokumentumot.

20220307: `M73` már nem állítja 0-ra a nyomtatás előrehaladását, ha `P` hiányzik.

20220304: Az [extruder_stepper](Config_Reference.md#extruder_stepper) konfigurációs szakaszok `extruder` paramétere már nem alapértelmezett. Ha szükséges, add meg kifejezetten az `extruder: extruder` paramétert, hogy a léptetőmotort indításkor az "extruder" mozgássorhoz társítsa.

20220210: A `SYNC_STEPPER_TO_EXTRUDER` parancs elavult; a `SET_EXTRUDER_STEP_DISTANCE` parancs elavult; az [extruder](Config_Reference.md#extruder) `shared_heater` config opció elavult. Ezek a funkciók a közeljövőben eltávolításra kerülnek. A `SET_EXTRUDER_STEP_DISTANCE` helyett `SET_EXTRUDER_ROTATION_DISTANCE`. Cserélje ki a `SYNC_STEPPER_TO_EXTRUDER` értéket a `SYNC_EXTRUDER_MOTION` értékre. Cserélje ki a `shared_heater` extruder konfigurációs szakaszokat [extruder_stepper](Config_Reference.md#extruder_stepper) konfigurációs szakaszokra, és frissítse az aktiválási makrókat a [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion) használatára.

20220116: A tmc2130, tmc2208, tmc2209 és tmc2660 `run_current` számítási kód megváltozott. Egyes `run_current` beállításoknál az illesztőprogramok most másképp konfigurálhatók. Ennek az új konfigurációnak pontosabbnak kell lennie, de érvénytelenítheti a korábbi TMC illesztőprogram-hangolást.

20211230: A bemeneti alakító hangolására szolgáló szkriptek (`scripts/calibrate_shaper.py` és `scripts/graph_accelerometer.py`) alapértelmezés szerint Python3-at használnak. Ennek eredményeképpen a felhasználóknak telepíteniük kell bizonyos csomagok Python3 verzióit (pl. `sudo apt install python3-numpy python3-matplotlib`), hogy továbbra is használni tudják ezeket a szkripteket. További részletekért lásd a [Szoftvertelepítés](Measuring_Resonances.md#software-installation) című részt. Alternatívaként a felhasználók ideiglenesen kikényszeríthetik ezeknek a szkripteknek a Python 2 alatti végrehajtását a Python2 interpretor explicit meghívásával a konzolon: `python2 ~/klipper/scripts/calibrate_shaper.py ...`

20211110: Az "NTC 100K beta 3950" hőmérséklet-érzékelő elavult. Ez az érzékelő a közeljövőben eltávolításra kerül. A legtöbb felhasználó a "Generic 3950" hőmérséklet-érzékelőt pontosabbnak fogja találni. Ha továbbra is a régebbi (jellemzően kevésbé pontos) definíciót szeretné használni, definiáljon egy egyéni [termisztort](Config_Reference.md#thermistor) a `temperature1: 25`, `resistance1: 100000`, és `beta: 3950` értékeken.

20211104: A "step pulse duration" opció a "make menuconfig" menüből eltávolításra került. Az UART vagy SPI módban konfigurált TMC-meghajtók alapértelmezett lépésimpulzus időtartama mostantól 100ns. Egy új `step_pulse_duration` beállítást kell megadni a [stepper config szakaszban](Config_Reference.md#stepper) minden olyan stepper esetében, amely egyéni impulzus időtartamot igényel.

20211102: Számos elavult funkciót eltávolítottunk. A léptető `step_distance` opciót eltávolítottuk (20201222-től elavult). Az `rpi_temperature` érzékelő álnév eltávolításra került (elavult 20210219). Az MCU `pin_map` opció eltávolításra került (elavult 20210325). A gcode_macro `default_parameter_<name>` és a parancsparaméterekhez való, `params` pszeudováltozótól eltérő makróhoz való hozzáférés eltávolításra került (elavult 20210503). A fűtés `pid_integral_max` opciót eltávolítottuk (elavult 20210612).

20210929: Klipper v0.10.0 megjelent.

20210903: Az alapértelmezett [`smooth_time`](Config_Reference.md#extruder) a fűtőberendezésekhez 1 másodpercre változott (2 másodpercről). A legtöbb nyomtatónál ez stabilabb hőmérséklet-szabályozást eredményez.

20210830: Az alapértelmezett adxl345 név mostantól "adxl345". Az `ACCELEROMETER_MEASURE` és `ACCELEROMETER_QUERY` alapértelmezett CHIP paramétere mostantól szintén "adxl345".

20210830: Az adxl345 ACCELEROMETER_MEASURE parancs már nem támogatja a RATE paramétert. A lekérdezési sebesség módosításához frissítse a printer.cfg fájlt, és adjon ki egy RESTART parancsot.

20210821: A `printer.configfile.settings` több konfigurációs beállítása mostantól listaként lesz jelentve a nyers karakterláncok helyett. Ha a tényleges nyers karakterláncra van szükség, használja helyette a `printer.configfile.config`-t.

20210819: Bizonyos esetekben egy `G28` célbaérési mozgás olyan pozícióban végződhet, amely névlegesen az érvényes mozgási tartományon kívül esik. Ritka helyzetekben ez zavaró "Move out of range" hibákat eredményezhet a kezdőpont felvétele után. Ha ez előfordul, módosítsa az indítási szkripteket úgy, hogy a nyomtatófej a kezdőpont felvétel után azonnal érvényes pozícióba kerüljön.

20210814: Az atmega168 és atmega328 csak analóg pszeudo-tüskéi PE0/PE1-ről PE2/PE3-ra lettek átnevezve.

20210720: A controller_fan szakasz most már alapértelmezés szerint az összes léptetőmotort figyeli (nem csak a kinematikus léptetőmotorokat). Ha a korábbi működést szeretnénk, lásd a [konfigurációs referencia](Config_Reference.md#controller_fan)-ban a `stepper` config opciót.

20210703: A `samd_sercom` konfigurációs szakasznak mostantól meg kell adnia az általa konfigurált sercom buszt a `sercom` opcióval.

20210612: A `pid_integral_max` konfigurációs opció a fűtés és a temperature_fan szakaszokban elavult. Az opció a közeljövőben eltávolításra kerül.

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430: A SET_VELOCITY_LIMIT (és az M204) parancs mostantól a konfigurációs fájlban megadott értékeknél nagyobb sebességet, gyorsulást és square_corner_velocity-t is beállíthat.

20210325: A `pin_map` config opció támogatása elavult. Használja a [sample-aliases.cfg](../config/sample-aliases.cfg) fájlt a tényleges mikrokontroller tű nevekre való fordításhoz. A `pin_map` config opció a közeljövőben eltávolításra kerül.

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

20201120: A `[board_pins]` config szakasz most már explicit `mcu:` paraméterben add meg az MCU nevét. Ha board_pins-t használunk egy másodlagos MCU-hoz, akkor a configot frissíteni kell, hogy megadd ezt a nevet. További részletekért lásd a [konfigurációs referenciát](Config_Reference.md#board_pins).

20201112: A `print_stats.print_duration` által bejelentett idő megváltozott. Az első észlelt extrudálás előtti időtartamot mostantól nem veszi figyelembe.

20201029: A neopixel `color_order_GRB` config opciót eltávolítottuk. Szükség esetén frissítse a configot, hogy az új `color_order` opciót RGB, GRB, RGBW vagy GRBW értékre állítsd be.

20201029: A serial opció az mcu config szakaszban már nem /dev/ttyS0 az alapértelmezett érték. Abban a ritka helyzetben, amikor a /dev/ttyS0 a kívánt soros port, azt kifejezetten meg kell adni.

20201020: Klipper v0.9.0 megjelent.

20200902: A MAX31865 átalakítók RTD ellenállás-hőmérséklet számítása javításra került, hogy ne legyen alacsony. Ha ilyen eszközt használ, akkor kalibrálja újra a nyomtatási hőmérsékletet és a PID-beállításokat.

20200816: A G-kód makró `printer.gcode` objektumot átneveztük `printer.gcode_move` objektumra. A `printer.toolhead` és `printer.gcode` objektumokból több nem dokumentált változót eltávolítottunk. A rendelkezésre álló sablonváltozók listáját lásd a docs/Command_Templates.md fájlban.

20200816: A G-kód makró "action_" rendszere megváltozott. Cserélje ki a `printer.gcode.action_emergency_stop()` hívásokat `action_emergency_stop()`, `printer.gcode.action_respond_info()` a `action_respond_info()`, és `printer.gcode.action_respond_error()` a `action_raise_error()`-el.

20200809: A menürendszer átírásra került. Ha a menüt testre szabták, akkor frissíteni kell az új konfigurációra. A konfiguráció részleteiért lásd a config/example-menu.cfg fájlt, a példákért pedig a klippy/extras/display/menu.cfg fájlt.

20200731: A `progress` attribútum viselkedése megváltozott, amelyet a `virtual_sdcard` nyomtatóobjektum jelentett. A nyomtatás szüneteltetésekor a Progress már nem áll vissza 0-ra. Mostantól mindig a belső fájl pozíciója alapján jelenti a haladást. Vagy 0, ha nincs betöltve fájl.

20200725: A szervo `enable` konfigurációs paraméter és a SET_SERVO `ENABLE` paraméter eltávolításra került. Frissítsen minden makrót, hogy a `SET_SERVO SERVO=my_servo WIDTH=0` paramétert használja a szervó letiltásához.

20200608: Az LCD-kijelző támogatása megváltoztatta néhány belső "írásjel" nevét. Ha egyéni kijelző elrendezés került implementálásra, akkor szükséges lehet frissíteni a legújabb gliph nevekre (lásd klippy/extras/display/display.cfg az elérhető gliph-ek listáját).

20200606: A linux MCU tű nevei megváltoztak. A tűnevek mostantól a `gpiochip<chipid>/gpio<gpio>` formájúak. A gpiochip0 esetében egy rövid `gpio<gpio>` is használható. Például, amire korábban `P20` néven hivatkoztunk, az most `gpio20` vagy `gpiochip0/gpio20` lesz.

20200603: Az alapértelmezett 16x4-es LCD kijelzőn már nem jelenik meg a nyomtatásból hátralévő becsült idő. (Csak az eltelt idő jelenik meg.) Ha a régi működést szeretnénk, akkor a menü kijelzőjét testre lehet szabni ezzel az információval (a részletekért lásd a config/example-extras.cfg fájlban a display_data leírását).

20200531: Az alapértelmezett USB gyártó/termék azonosító mostantól 0x1d50/0x614e. Ezek az új azonosítók a Klipper számára vannak fenntartva (köszönet az openmoko projektnek). Ez a változás nem igényel semmilyen konfigurációs módosítást, de az új azonosítók megjelenhetnek a rendszer naplóiban.

20200524: A TMC5160 pwm_freq mező alapértelmezett értéke mostantól nulla (egy helyett).

20200425: A gcode_macro parancs sablonváltozója `printer.heater` át lett nevezve `printer.heaters`-re.

20200313: A 16x4-es képernyővel és a több extruderrel rendelkező nyomtatók alapértelmezett LCD-kiosztása megváltozott. Mostantól az egy extruderrel rendelkező képernyő elrendezése az alapértelmezett, és az aktuálisan aktív extrudert mutatja. A korábbi kijelző elrendezés használatához állítsd be a "display_group: _multiextruder_16x4" a printer.cfg fájl [display] szakaszában.

20200308: Az alapértelmezett `__test` menüpont eltávolításra került. Ha a konfigurációs fájlban egyéni menü van, akkor mindenképpen távolítson el minden hivatkozást erre a `__test` menüpontra.

20200308: A "pakli" és "kártya" menüpontok eltávolításra kerültek. Az LCD képernyő elrendezésének testreszabásához használd az új display_data config szakaszokat (a részletekért lásd a config/example-extras.cfg fájlt).

20200109: A bed_mesh modul most már hivatkozik a szonda helyére a hálókonfigurációban. Ennek megfelelően néhány konfigurációs opciót átneveztek, hogy pontosabban tükrözze a tervezett funkciójukat. Téglalap alakú tárgyasztalok esetében a `min_point` és `max_point` átnevezésre került `mesh_min` és `mesh_max`-ra. A kerek tárgyasztalok esetében a `bed_radius` át lett nevezve `mesh_radius`-ra. A kerek tárgyasztalokhoz egy új `mesh_origin` opció is hozzá lett adva. Vedd figyelembe, hogy ezek a változások a korábban elmentett hálóprofilokkal is inkompatibilisek. Ha egy inkompatibilis profilt észlelünk, azt figyelmen kívül hagyjuk és eltávolításra ütemezzük. Az eltávolítási folyamat a SAVE_CONFIG parancs kiadásával fejezhető be. A felhasználónak minden egyes profilt újra kell kalibrálnia.

20191218: A display config szakasz már nem támogatja az "lcd_type: st7567". Használja helyette az "uc1701" kijelzőtípust. Állítsd be az "lcd_type: uc1701" értéket, és módosítsa az "rs_pin: some_pin" értéket "rst_pin: some_pin" értékre. Szükség lehet még egy "contrast: 60" konfigurációs beállítás hozzáadására.

20191210: A beépített T0, T1, T2, ... parancsok eltávolításra kerültek. Az extruder activate_gcode és deactivate_gcode konfigurációs opciók eltávolításra kerültek. Ha szükség van ezekre a parancsokra (és szkriptekre), akkor definiáljon egyedi [gcode_macro T0] stílusú makrókat, amelyek meghívják az ACTIVATE_EXTRUDER parancsot. Példákért lásd a config/sample-idex.cfg és sample-multi-extruder.cfg fájlokat.

20191210: Az M206 parancs támogatása megszűnt. A SET_GCODE_OFFSET hívásával helyettesítjük. Ha szükség van az M206 támogatására, adjunk hozzá egy [gcode_macro M206] config szakaszt, amely meghívja a SET_GCODE_OFFSET-et. (Például "SET_GCODE_OFFSET Z=-{params.Z}".)

20191202: A "G4" parancs nem dokumentált "S" paraméterének támogatása megszűnt. Az S minden előfordulását a szabványos "P" paraméterrel helyettesíti (a milliszekundumokban megadott késleltetés).

20191126: Az USB nevek megváltoztak a natív USB-támogatással rendelkező mikrovezérlőkön. Mostantól alapértelmezés szerint egyedi chip-azonosítót használnak (ahol van ilyen). Ha egy "MCU" config szakasz olyan "serial" beállítást használ, amely "/dev/serial/by-id/" kezdetű, akkor szükség lehet a config frissítésére. Futtassa a "ls /dev/serial/by-id/*" parancsot egy SSH terminálban az új azonosító meghatározásához.

20191121: A pressure_advance_lookahead_time paramétert eltávolítottuk. Az alternatív konfigurációs beállításokat lásd a example.cfg fájlban.

20191112: A TMC léptető vezérlő virtuális engedélyezési képessége mostantól automatikusan engedélyezve van, ha a léptető nem rendelkezik dedikált léptető engedélyező tűvel. A tmcXXXX:virtual_enable-re való hivatkozások eltávolítása a konfigurációból. A stepper enable_pin konfigurációban több tű vezérlésének lehetősége megszűnt. Ha több tűre van szükség, akkor használjon egy multi_pin config szekciót.

20191107: Az elsődleges extruder konfigurációs szakaszát "extruder" néven kell megadni, és már nem lehet "extruder0" néven megadni. Az extruder állapotát lekérdező G-kód parancssablonokat mostantól a "{printer.extruder}" segítségével lehet elérni.

20191021: Klipper v0.8.0 megjelent

20191003: A move_to_previous opció a [safe_z_homing]-ban mostantól alapértelmezés szerint False. (A 20190918 előtt ténylegesen False volt.)

20190918: A z-hop opció a [safe_z_homing]-ban mindig újra alkalmazásra kerül, miután a Z tengelyre történő homing befejeződött. Ez szükségessé teheti a felhasználók számára, hogy frissítsék az ezen a modulon alapuló egyéni szkripteket.

20190806: A SET_NEOPIXEL parancsot átnevezték SET_LED-re.

20190726: Az mcp4728 digitális-analóg kódja megváltozott. Az alapértelmezett i2c_address most 0x60, és a feszültségreferencia most az mcp4728's belső 2,048 voltos referenciához viszonyítva van.

20190710: A [firmware_retract] konfigurációs szakaszból eltávolították a z_hop opciót. A z_hop támogatása hiányos volt, és több gyakori szeletelővel hibás viselkedést okozott.

20190710: A PROBE_ACCURACY parancs opcionális paraméterei megváltoztak. Szükség lehet a parancsot használó makrók vagy szkriptek frissítésére.

20190628: A [skew_correction] szakaszból eltávolítottuk az összes konfigurációs opciót. A skew_correction konfigurálása mostantól a SET_SKEW G-kódon keresztül történik. Lásd a [Ferdeség Korrekció](Skew_Correction.md) ajánlott használatát.

20190607: A gcode_macro "variable_X" paraméterei (a SET_GCODE_VARIABLE VALUE paraméterével együtt) mostantól Python literálokként kerülnek értelmezésre. Ha egy értékhez karakterláncot kell rendelni, akkor csomagolja az értéket idézőjelekbe, hogy karakterláncként kerüljön kiértékelésre.

20190606: A "samples", "samples_result" és "sample_retract_dist" konfigurációs beállítások átkerültek a "probe" konfigurációs szakaszba. Ezek az opciók már nem támogatottak a "delta_calibrate", "bed_tilt", "bed_mesh", "screws_tilt_adjust", "z_tilt", vagy "quad_gantry_level" config szakaszokban.

20190528: A gcode_macro sablon kiértékelésében a mágikus "status" változót átneveztük "printer" -re.

20190520: A SET_GCODE_OFFSET parancs megváltozott; ennek megfelelően frissítse a G-kód makrókat. A parancs már nem alkalmazza a kért eltolást a következő G1 parancsra. A régi viselkedés megközelíthető az új "MOVE=1" paraméter használatával.

20190404: A Python gazda szoftvercsomagok frissítésre kerültek. A felhasználóknak újra kell futtatniuk a ~/klipper/scripts/install-octopi.sh szkriptet (vagy más módon frissíteniük kell a python függőségeket, ha nem standard OctoPi telepítést használnak).

20190404: Az i2c_bus és spi_bus paraméterek (a különböző konfigurációs szakaszokban) mostantól szám helyett busznevet fogadnak el.

20190404: Az sx1509 konfigurációs paraméterei megváltoztak. Az 'address' paraméter mostantól 'i2c_address', és decimális számként kell megadni. A korábban használt 0x3E helyett 62-t kell megadni.

20190328: A [temperature_fan] konfigurációban megadott min_speed értéket mostantól tiszteletben tartjuk, és a ventilátor PID üzemmódban mindig ezen vagy annál magasabb fordulatszámon fog működni.

20190322: A "driver_HEND" alapértelmezett értéke a [tmc2660] konfigurációs szakaszokban 6-ról 3-ra változott. A "driver_VSENSE" mezőt eltávolítottuk (mostantól automatikusan a run_current-ből számítják ki).

20190310: A [controller_fan] config szakasz mostantól mindig kap egy nevet (például [controller_fan my_controller_fan]).

20190308: A [tmc2130] és [tmc2208] konfigurációs szakaszok "driver_BLANK_TIME_SELECT" mezője át lett nevezve "driver_TBL" -re.

20190308: A [tmc2660] config szakasz megváltozott. Mostantól egy új sense_resistor config paramétert kell megadni. A driver_XXX paraméterek közül többnek a jelentése is megváltozott.

20190228: A SAMD21 kártyákon SPI vagy I2C-t használóknak mostantól a [samd_sercom] config szakaszban kell megadniuk a BUSZ csatlakozásait.

20190224: A bed_shape opciót eltávolítottuk a bed_mesh-ből. A radius opciót átneveztük bed_radiusra. A kerek tárgyasztalokkal rendelkező felhasználóknak a bed_radius és a round_probe_count opciókat kell megadniuk.

20190107: Az i2c_address paraméter az mcp4451 config szakaszban megváltozott. Ez egy gyakori beállítás a Smoothie alaplapokon. Az új érték a régi érték fele (a 88-as értéket 44-re, a 90-es értéket pedig 45-re kell módosítani).

20181220: Klipper v0.7.0 megjelent
