# Kód áttekintése

Ez a dokumentum a Klipper általános kódelrendezését és főbb kódfolyamát írja le.

## Könyvtár elrendezése

Az **src/** könyvtár tartalmazza a mikrovezérlő kódjának C forrását. Az **src/atsam/**, **src/atsamd/**, **src/avr/**, **src/linux/**, **src/lpc176x/**, **src/ A pru/** és **src/stm32/** könyvtárak architektúra-specifikus mikrovezérlő kódot tartalmaznak. Az **src/simulator/** kódcsonkokat tartalmaz, amelyek lehetővé teszik a mikrokontroller tesztelését más architektúrákon. Az **src/generic/** könyvtár segédkódot tartalmaz, amely hasznos lehet a különböző architektúrákban. A build gondoskodik arról, hogy az include "board/somefile.h" először az aktuális architektúra könyvtárban (pl. src/avr/somefile.h), majd az általános könyvtárban (pl. src/generic/somefile.h) keressen.

A **klippy/** könyvtár tartalmazza a gazdaszoftvert. A gazdaszoftver nagy része Python nyelven íródott, azonban a **klippy/chelper/** könyvtár tartalmaz néhány C kódú segédprogramot. A **klippy/kinematics/** könyvtár tartalmazza a robot kinematikai kódját. A **klippy/extras/** könyvtár tartalmazza a gazdakód bővíthető "moduljait".

A **lib/** könyvtár külső, harmadik féltől származó könyvtári kódot tartalmaz, amely néhány célprogram elkészítéséhez szükséges.

A **config/** könyvtár a nyomtató konfigurációs példafájljait tartalmazza.

Az **scripts/** könyvtár felépítési idejű szkripteket tartalmaz, amelyek hasznosak a mikrovezérlő kódjának fordításához.

A **test/** könyvtár automatikus teszteseteket tartalmaz.

Fordítás során a build létrehozhat egy **out/** könyvtárat. Ez ideiglenes építési idejű objektumokat tartalmaz. A végső mikrokontroller objektum, amely felépül, AVR esetén **out/klipper.elf.hex**, ARM esetén **out/klipper.bin**.

## Mikrokontroller kódfolyamat

A mikrokontroller kódjának végrehajtása az architektúra-specifikus kódban kezdődik (pl. **src/avr/main.c**), amely végül a **src/sched.c**-ban található sched_main() parancsot hívja meg. A sched_main() kód a DECL_INIT() makróval jelölt összes függvény futtatásával kezdődik. Ezután a DECL_TASK() makróval megjelölt függvények ismételt futtatására kerül sor.

Az egyik fő feladatfüggvény a command_dispatch(), amely a **src/command.c** fájlban található. Ezt a függvényt a kártyaspecifikus bemeneti/kimeneti kódból (pl. **src/avr/serial.c**, **src/generic/serial_irq.c**) hívjuk meg, és a bemeneti folyamban található parancsokhoz tartozó parancsfüggvényeket futtatja. A parancsfüggvények deklarálása a DECL_COMMAND() makróval történik (további információkért lásd a [protokol](Protocol.md) dokumentumot).

A feladat-, init- és parancsfüggvények mindig engedélyezett megszakításokkal futnak (szükség esetén azonban ideiglenesen letilthatják a megszakításokat). Ezek a függvények soha nem tarthatnak szünetet, nem késleltethetnek, és nem végezhetnek olyan munkát, amely néhány mikroszekundumnál tovább tart. Ezek a függvények a munkát meghatározott időpontokra ütemezik időzítők segítségével.

Az időzítő függvények ütemezése a sched_add_timer() meghívásával történik (a **src/sched.c** fájlban található). Az ütemező kód gondoskodik arról, hogy az adott függvényt a kért időben hívja meg. Az időzítő megszakítások kezelése kezdetben egy architektúra-specifikus megszakításkezelőben történik (pl. **src/avr/timer.c**), amely a **src/sched.c**-ban található sched_timer_dispatch() funkciót hívja. Az időzítő megszakítása az ütemező időzítő függvények végrehajtásához vezet. Az időzítő függvények mindig megszakítások kikapcsolásával futnak. Az időzítőfüggvényeknek mindig néhány mikroszekundumon belül kell befejeződniük. Az időzítő esemény befejezésekor a függvény dönthet úgy, hogy átütemezi magát.

Hiba észlelése esetén a kód meghívhatja a shutdown() funkciót (egy makró, amely a **src/sched.c**-ben található sched_shutdown() funkciót hívja). A shutdown() meghívása a DECL_SHUTDOWN() makróval jelölt összes függvény futtatását eredményezi. A leállítási függvények mindig megszakítások letiltásával futnak.

A mikrokontroller funkcióinak nagy része az általános célú bemeneti/kimeneti érintkezőkkel (GPIO) való munkát foglalja magában. Annak érdekében, hogy az alacsony szintű architektúra-specifikus kódot elvonatkoztassuk a magas szintű feladatkódtól, minden GPIO eseményt architektúra-specifikus burkolatokban valósítunk meg (pl. **src/avr/gpio.c**). A kódot a gcc's "-flto -fwhole-program" optimalizálással fordítottuk, amely kiváló munkát végez a függvények inline-olásában a fordítási egységeken keresztül, így a legtöbb ilyen apró GPIO függvény inline-olva van a hívóikban, és nincs futásidejű költsége a használatuknak.

## Klippy kód áttekintése

A gazdakódot (Klippy) egy olcsó számítógépen (például egy Raspberry Pi) kell futtatni a mikrokontrollerrel párosítva. A kód elsősorban Pythonban íródott, azonban a CFFI-t használja néhány funkció C kódban történő megvalósításához.

A kezdeti végrehajtás a **klippy/klippy.py** fájlban kezdődik. Ez beolvassa a parancssori argumentumokat, megnyitja a nyomtató konfigurációs fájlját, példányosítja a fő nyomtatóobjektumokat, és elindítja a soros kapcsolatot. A G-kód parancsok fő végrehajtása a process_commands() metódusban történik az **klippy/gcode.py** fájlban. Ez a kód a G-kód parancsokat nyomtatóobjektum-hívásokká fordítja le, amelyek gyakran a műveleteket a mikrovezérlőn végrehajtandó parancsokká alakítják (a mikrovezérlő kódjában a DECL_COMMAND makrón keresztül).

A Klippy gazdagép kódjában négy szál van. A fő szál kezeli a bejövő G-kód parancsokat. Egy második szál (amely teljes egészében a **klippy/chelper/serialqueue.c** C kódban található) az alacsony szintű IO-t kezeli a soros porttal. A harmadik szál a Python kódban (lásd **klippy/serialhdl.py**) a mikrokontroller válaszüzeneteinek feldolgozására szolgál. A negyedik szál hibakeresési üzeneteket ír a naplóba (lásd **klippy/queuelogger.py**), hogy a többi szál soha ne blokkoljon a naplóíráskor.

## Mozgásparancs kódfolyama

Egy tipikus nyomtatómozgás akkor kezdődik, amikor egy "G1" parancsot küldünk a Klippy gazdagépnek, és akkor fejeződik be, amikor a megfelelő lépésimpulzusok megjelennek a mikrokontrolleren. Ez a szakasz egy tipikus mozgatási parancs kódfolyamatát vázolja fel. A [kinematika](Kinematics.md) dokumentum további információkat tartalmaz a mozgások mechanikájáról.

* A mozgás parancs feldolgozása a gcode.py fájlban kezdődik. A gcode.py célja a G-kód lefordítása belső hívásokká. Egy G1 parancs a klippy/extras/gcode_move.py állományban lévő cmd_G1() parancsot hívja meg. A gcode_move.py kód kezeli az eredetváltozásokat (pl. G92), a relatív és abszolút pozíciók közötti változásokat (pl. G90) és az egységváltozásokat (pl. F6000=100mm/s). A kód útvonala a mozgatáshoz a következő: `_process_data() -> _process_commands() -> cmd_G1()`. Végül a ToolHead osztályt hívjuk meg a tényleges kérés végrehajtásához: `cmd_G1() -> ToolHead.move()`
* A ToolHead osztály (a toolhead.py állományban) kezeli a "look-ahead" és követi a nyomtatási műveletek időzítését. A fő kódútvonal egy mozdulathoz a következő: `ToolHead.move() -> MoveQueue.add_move() -> MoveQueue.flush() -> Move.set_junction() -> ToolHead._process_moves()`.
   * A ToolHead.move() létrehoz egy Move() objektumot a mozgás paramétereivel (cartesian térben, másodperc és milliméter egységekben).
   * A kinematikai osztály lehetőséget kap az egyes mozgások ellenőrzésére (`ToolHead.move() -> kin.check_move()`). A kinematikai osztályok a klippy/kinematics/ könyvtárban találhatók. A check_move() kód hibát adhat ki, ha a mozgás nem érvényes. Ha a check_move() sikeresen befejeződik, akkor az alapul szolgáló kinematikának képesnek kell lennie a mozgás kezelésére.
   * A MoveQueue.add_move() elhelyezi a move objektumot a "look-ahead" várólistán.
   * A MoveQueue.flush() meghatározza az egyes mozgások kezdő és végsebességét.
   * A Move.set_junction() a "trapézgenerátort" valósítja meg egy mozgásban. A "trapézgenerátor" minden mozgást három részre bont: egy állandó gyorsulási fázisra, majd egy állandó sebesség fázisra, majd egy állandó lassulási fázisra. Minden mozgás ebben a sorrendben tartalmazza ezt a három fázist, de egyes fázisok időtartama lehet nulla is.
   * Amikor a ToolHead._process_moves() meghívásra kerül, a mozgással kapcsolatban minden ismert - a kezdőhelye, a véghelye, a gyorsulása, a kezdő/körözési/végsebessége és a gyorsulás/körözési/végsebesség alatt megtett távolság. Minden információ a Move() osztályban tárolódik, és cartesian térben, milliméter és másodperc egységekben van megadva.
* A Klipper egy [iteratív megoldót](https://en.wikipedia.org/wiki/Root-finding_algorithm) használ az egyes léptetők lépésidejének létrehozásához. Hatékonysági okokból a léptető impulzusidőket C kódban generálja. A mozgásokat először egy "trapézmozgás-várólistára" helyezzük: `ToolHead._process_moves() -> trapq_append()` (a klippy/chelper/trapq.c-ben). A lépésidők ezután generálódnak: `ToolHead._process_moves() -> ToolHead._update_move_time() -> MCU_Stepper.generate_steps() -> itersolve_generate_steps() -> itersolve_gen_steps_range()` (a klippy/chelper/itersolve.c-ben). Az iteratív megoldó célja, hogy lépésidőket találjon egy olyan függvényt adva, amely egy időből kiszámítja a lépéshelyzetet. Ez úgy történik, hogy többször "kitaláljuk" a különböző időket, amíg a léptető pozíció képlet vissza nem adja a léptető következő lépésének kívánt pozícióját. Az egyes találgatásokból származó visszajelzéseket a jövőbeli találgatások javítására használjuk, hogy a folyamat gyorsan konvergáljon a kívánt időhöz. A kinematikus stepper pozíció képletek a klippy/chelper/ könyvtárban találhatók (pl. kin_cart.c, kin_corexy.c, kin_delta.c, kin_extruder.c).
* Vegye figyelembe, hogy az extruder saját kinematikai osztályban van kezelve: `ToolHead._process_moves() -> PrinterExtruder.move()`. Mivel a Move() osztály pontosan megadja a mozgás idejét, és mivel a lépésimpulzusokat meghatározott időzítéssel küldi a mikrokontrollerhez, az extruder osztály által előállított léptetőmozgások szinkronban lesznek a fejmozgással, annak ellenére, hogy a kódot elkülönítve tartjuk.
* Miután az iteratív megoldó kiszámítja a lépésidőket, azok egy tömbhöz kerülnek hozzáadásra: `itersolve_gen_steps_range() -> stepcompress_append()` (in klippy/chelper/stepcompress.c). A tömb (struct stepcompress.queue) minden lépéshez tárolja a mikrokontroller megfelelő óraszámláló idejét. Itt a "mikrokontroller óra számláló" értéke közvetlenül megfelel a mikrokontroller hardveres számlálójának, a mikrokontroller utolsó bekapcsolásának időpontjához viszonyítva.
* A következő fontos lépés a lépések tömörítése: `stepcompress_flush() -> compress_bisect_add()` (in klippy/chelper/stepcompress.c). Ez a kód generálja és kódolja a mikrokontroller "queue_step" parancsainak sorozatát, amelyek megfelelnek az előző szakaszban felépített léptető lépésidők listájának. Ezek a "queue_step" parancsok ezután sorba kerülnek, prioritást kapnak, és elküldésre kerülnek a mikrokontrollernek (a stepcompress.c:steppersync és a serialqueue.c:serialqueue kódokon keresztül).
* A queue_step parancsok feldolgozása a mikrokontrollerben az src/command.c állományban kezdődik, amely elemzi a parancsot és meghívja a `command_queue_step()` parancsot. A command_queue_step() kód (az src/stepper.c-ben) csak az egyes queue_step parancsok paramétereit csatolja egy-egy stepper sorba. Normál működés esetén a queue_step parancsot legalább 100ms-mal az első lépés időpontja előtt elemzi és beállítja a sorba. Végül a stepper események generálása a `stepper_event()`-ban történik. Ezt a hardveres időzítő megszakításából hívjuk meg az első lépés tervezett időpontjában. A stepper_event() kód generál egy lépésimpulzust, majd átütemezi magát a következő lépésimpulzus idejére a megadott queue_step paraméterekhez. Az egyes queue_step parancsok paraméterei a következők: "interval", "count" és "add". Magas szinten a stepper_event() a következőket hajtja végre, 'count' times: `do_step(); next_wake_time = last_wake_time + interval; interval += add;`

A fentiek soknak tűnhetnek egy mozdulat végrehajtásához. Az egyetlen igazán érdekes rész azonban a ToolHead és a kinematikai osztályokban található. Ez a kódnak azon része, amely meghatározza a mozgásokat és azok időzítését. A feldolgozás többi része többnyire csak kommunikáció és munka.

## Gazdamodul hozzáadása

A Klippy host kódja dinamikus modulbetöltési képességgel rendelkezik. Ha a nyomtató konfigurációs fájljában található egy "[my_module]" nevű konfigurációs szakasz, akkor a szoftver automatikusan megpróbálja betölteni a klippy/extras/my_module.py . modult. Ez a modulrendszer a Klipper új funkciók hozzáadásának előnyben részesített módszere.

Egy új modul hozzáadásának legegyszerűbb módja, ha egy meglévő modult használunk hivatkozásként - lásd **klippy/extras/servo.py** példaként.

A következők is hasznosak lehetnek:

* A modul végrehajtása a modulszintű `load_config()` függvényben kezdődik (a [my_module] formájú config szakaszok esetén) vagy a `load_config_prefix()` függvényben (a [my_module my_name] formájú config szakaszok esetén). Ennek a függvénynek egy "config" objektumot kell átadni, és egy új "printer objektumot" kell visszaadnia, amely az adott config szakaszhoz kapcsolódik.
* Egy új nyomtatóobjektum példányosítása során a config objektum segítségével paramétereket olvashat be az adott config szakaszból. Erre a `config.get()`, `config.getfloat()`, `config.getint()` stb. metódusok szolgálnak. Ügyeljen arra, hogy a nyomtató objektum felépítése során minden értéket beolvasson a configból. Ha a felhasználó olyan config paramétert ad meg, amelyet ebben a fázisban nem olvas be, akkor azt feltételezi, hogy elírás történt a configban, és hibaüzenetet ad.
* A `config.get_printer()` metódus segítségével megkapjuk a fő "printer" osztályra való hivatkozást. Ez a "nyomtató" osztály tárolja a hivatkozásokat az összes "nyomtatóobjektumra", amelyet már példányosítottak. A `printer.lookup_object()` metódus segítségével megkereshetjük a többi nyomtatóobjektumra mutató hivatkozásokat. Szinte minden funkció (még az alapvető kinematikai modulok is) egy ilyen nyomtatóobjektumba vannak kapszulázva. Vegyük azonban figyelembe, hogy egy új modul példányosításakor nem minden más nyomtatóobjektumot példányosítottunk. A "gcode" és a "pins" modulok mindig elérhetőek lesznek, de a többi modul esetében érdemes elhalasztani a keresést.
* Az eseménykezelőket a `printer.register_event_handler()` módszerrel regisztrálhatja, ha a kódot más nyomtatóobjektumok által kiváltott "események" során kell meghívni. Minden esemény neve egy karakterlánc, és a konvenció szerint az eseményt kiváltó fő forrásmodul neve, valamint az eseményt kiváltó művelet rövid neve (pl. "klippy:connect"). Az egyes eseménykezelőknek átadott paraméterek az adott eseményre jellemzőek (ahogy a kivételkezelés és a végrehajtási kontextus is). Két gyakori indítási esemény a következő:
   * klippy:connect - Ez az esemény az összes nyomtatóobjektum példányosítása után generálódik. Általában más nyomtatóobjektumok keresésére, a konfigurációs beállítások ellenőrzésére és a kezdeti "kézfogás" végrehajtására használják a nyomtató hardverével.
   * klippy:ready - Ez az esemény az összes csatlakozási kezelő sikeres befejezése után generálódik. Jelzi, hogy a nyomtató átvált a normál műveletek kezelésére kész állapotba. Ebben a visszahívásban ne jelezzen hibát.
* Ha hiba van a felhasználó konfigurációjában, mindenképpen hívja fel a figyelmet a `load_config()` vagy a "connect event" fázisokban. Használja a `raise config.error("my error")` vagy `raise printer.config_error("my error")` hibajelzést.
* A "pins" modul segítségével konfigurálhat egy csatlakozót a mikrokontrollerben. Ez általában a `printer.lookup_object("pins").setup_pin("pwm", config.get("my_pin"))`-hoz hasonló módon történik. A visszakapott objektumot ezután futásidőben lehet utasítani.
* Ha a nyomtató objektum definiál egy `get_status()` metódust, akkor a modul [állapotinformációt](Status_Reference.md) exportálhat a [makrókon](Command_Templates.md) és az [API Szerveren](API_Server.md) keresztül. A `get_status()` metódusnak egy Python szótárat kell visszaadnia, amelynek kulcsai karakterláncok, értékei pedig egész számok, lebegő számok, karakterláncok, listák, szótárak, True, False vagy None. Használhatók tuplik (és nevesített tuplik) is (ezek az API-kiszolgálón keresztül történő eléréskor listaként jelennek meg). Az exportált listákat és szótárakat "megváltoztathatatlanok". Ha tartalmuk megváltozik, akkor egy új objektumot kell visszaküldeni a `get_status()` parancsból, különben az API-kiszolgáló nem fogja észlelni a változásokat.
* Ha a modulnak hozzáférésre van szüksége a rendszer időzítéséhez vagy külső fájlleírókhoz, akkor a `printer.get_reactor()` segítségével hozzáférhetünk a globális "event reactor" osztályhoz. Ez a reactor osztály lehetővé teszi az időzítők ütemezését, a fájlleírók bemenetének várakozását, valamint a gazdakód "alvó" használatát.
* Ne használjon globális változókat. Minden állapotot a `load_config()` függvény által visszaadott nyomtató objektumban kell tárolni. Ez azért fontos, mert ellenkező esetben a RESTART parancs nem az elvártaknak megfelelően fog működni. Szintén hasonló okokból, ha bármilyen külső fájl (vagy foglalat) megnyílt, akkor mindenképpen regisztráljunk egy "klippy:disconnect" eseménykezelőt, és zárjuk be őket ebből a visszahívásból.
* Kerülje a más nyomtatóobjektumok belső tagváltozóinak elérését (vagy az aláhúzással kezdődő metódusok hívását). Ennek a konvenciónak a betartása megkönnyíti a jövőbeli változások kezelését.
* Javasoljuk, hogy a Python osztályok Python konstruktorában minden tagváltozóhoz értéket rendeljen. (És ezért kerülje a Python azon képességének kihasználását, hogy dinamikusan hozzon létre új tagváltozókat.)
* Ha egy Python változónak lebegőpontos értéket kell tárolnia, akkor ajánlott mindig lebegőpontos konstansokkal hozzárendelni és kezelni a változót (és soha ne használjunk egészértékű konstansokat). Például részesítsük előnyben a `self.speed = 1.` értéket a `self.speed = 1` értékkel szemben, és részesítsük előnyben a `self.speed = 2 értéket. * x` a `self.speed = 2 * x` helyett. A lebegőpontos értékek következetes használatával elkerülhetők a Python-típuskonverziók nehezen hibakereshető furcsaságai.
* Ha a modult a Klipper főkódjába való beépítésre küldöd, mindenképpen helyezz el egy szerzői jogi megjegyzést a modul tetején. Az előnyben részesített formátumot lásd a meglévő moduloknál.

## Új kinematika hozzáadása

Ez a szakasz néhány tippet ad a Klipper további nyomtató kinematikai típusok támogatásának hozzáadásához. Az ilyen típusú tevékenységhez a cél kinematikához tartozó matematikai képletek kiváló ismerete szükséges. Szoftverfejlesztési ismereteket is igényel, bár csak a gazdaszoftvert kell frissíteni.

Hasznos lépések:

1. Kezdd a "[Egy mozgás kódfolyamata](#code-flow-of-a-move-command)" szakasz és a [Kinematika dokumentum](Kinematics.md) tanulmányozásával.
1. Tekintse át a klippy/kinematics/ könyvtárban található kinematikai osztályokat. A kinematikai osztályok feladata egy cartesian koordinátákban megadott mozgás átalakítása az egyes steppereken történő mozgássá. Kiindulópontként le kell tudni másolni az egyik ilyen fájlt.
1. Implementáljuk a C stepperek kinematikai pozíciófüggvényeit minden stepperhez, ha azok még nem állnak rendelkezésre (lásd a kin_cart.c, kin_corexy.c és kin_delta.c fájlokat a klippy/chelper/ állományban). A függvénynek meg kell hívnia `move_get_coord()`, hogy egy adott mozgási időt (másodpercben) kartéziánus koordinátává (milliméterben) konvertáljon, majd ebből a cartesian koordinátából kiszámítsa a kívánt stepper pozíciót (milliméterben).
1. Az új kinematikai osztályban implementáljuk a `calc_position()` módszert. Ez a metódus kiszámítja a nyomtatófej pozícióját cartesian koordinátákban az egyes léptetőmotorok pozíciójából. Nem kell, hogy hatékony legyen, mivel jellemzően csak a kezdőpont és az érintési műveletek során hívjuk meg.
1. Egyéb módszerek. Implementálja a `check_move()`, `get_status()` metódusokat, `get_steppers()`, `home()` és `set_position()` módszereket. Ezeket a függvényeket általában kinematikai specifikus ellenőrzések biztosítására használják. A fejlesztés kezdetén azonban használhatunk itt kazánszerű kódot.
1. Tesztelési esetek végrehajtása. Készítsen egy G-kódfájlt egy sor olyan mozgással, amelyekkel az adott kinematika fontos eseteit tesztelheti. Kövesse a [Hibakeresési dokumentációt](Debugging.md), hogy ezt a G-kódfájlt mikrokontroller-parancsokká alakítsa át. Ez hasznos a sarokesetek gyakorlására és a regressziók ellenőrzésére.

## Portolás új mikrokontrollerre

Ez a szakasz néhány tippet ad a Klipper mikrokontroller kódjának új architektúrára történő átviteléhez. Ez a fajta tevékenység jó beágyazott fejlesztési ismereteket és gyakorlati hozzáférést igényel a célmikrokontrollerhez.

Hasznos lépések:

1. Kezdje a portolás során használni kívánt harmadik féltől származó könyvtárak azonosításával. Gyakori példa erre a "CMSIS" csomagolások és a gyártó "HAL" könyvtárak. Minden harmadik féltől származó kódnak GNU GPLv3 kompatibilisnek kell lennie. A harmadik féltől származó kódot a Klipper lib/ könyvtárba kell átvinni. Frissítse a lib/README fájlt azzal az információval, hogy hol és mikor szerezte meg a könyvtárat. A kódot lehetőleg változatlanul másolja be a Klipper tárolóba, de ha bármilyen változtatásra van szükség, akkor ezeket a változtatásokat kifejezetten fel kell tüntetni a lib/README fájlban.
1. Hozzon létre egy új architektúra alkönyvtárat az src/ könyvtárban, és adjon hozzá kezdeti Kconfig és Makefile támogatást. Használja a meglévő architektúrákat útmutatóként. Az src/simulator egy alapvető példát nyújt egy minimális kiindulási pontra.
1. Az első fő kódolási feladat a kommunikációs támogatás felállítása az alaplapnak. Ez a legnehezebb lépés egy új port esetében. Ha az alapvető kommunikáció már működik, a további lépések általában sokkal könnyebbek. A kezdeti fejlesztés során jellemzően UART típusú soros eszközt használunk, mivel az ilyen típusú hardvereszközöket általában könnyebb engedélyezni és vezérelni. Ebben a fázisban bőkezűen használja az src/generic/ könyvtárban található segédkódot (ellenőrizze, hogy az src/simulator/Makefile hogyan tartalmazza a generikus C kódot a felépítésben). Ebben a fázisban szükséges definiálni a timer_read_time() funkciót is (amely visszaadja az aktuális rendszerórát), de nem szükséges a timer irq kezelésének teljes támogatása.
1. Ismerkedjen meg a console.py eszközzel (a [Hibakeresési dokumentumban](Debugging.md) leírtak szerint), és ellenőrizze vele a mikrokontrollerrel való kapcsolatot. Ez az eszköz lefordítja az alacsony szintű mikrokontroller kommunikációs protokollt ember által olvasható formára.
1. A hardveres megszakításokból történő időzítő-küldés támogatásának hozzáadása. Lásd a Klipper [commit 970831ee](https://github.com/Klipper3d/klipper/commit/970831ee0d3b91897196e92270d98b2a3067427f) példáját az LPC176x architektúra 1-5. lépéseire.
1. Alapvető GPIO bemeneti és kimeneti támogatás megjelenítése. Lásd a Klipper [commit c78b9076](https://github.com/Klipper3d/klipper/commit/c78b90767f19c9e8510c3155b89fb7ad64ca3c54) példáját erre.
1. További perifériák felhozása - lásd például a Klipper megbízásokat [65613aed](https://github.com/Klipper3d/klipper/commit/65613aeddfb9ef86905cb1dade9e773a02ef3c27), [c812a40a](https://github.com/Klipper3d/klipper/commit/c812a40a3782415e454b04bf7bd2158a6f0ec8b5) és [c381d03a](https://github.com/Klipper3d/klipper/commit/c381d03aad5c3ee761169b7c7bced519cc14da29).
1. Hozzon létre egy minta Klipper konfigurációs fájlt a config/ könyvtárban. Teszteljük a mikrokontrollert a klippy.py főprogrammal.
1. Fontolja meg a test/ könyvtárban lévő build tesztesetek hozzáadását.

További kódolási tippek:

1. Kerülje a "C bitmezők" használatát az IO regiszterek eléréséhez; részesítse előnyben a 32 bites, 16 bites vagy 8 bites egész számok közvetlen olvasási és írási műveleteit. A C nyelvi specifikációk nem határozzák meg egyértelműen, hogy a fordítónak hogyan kell megvalósítania a C bitmezőket (pl. endianness és bitkiosztás), és nehéz meghatározni, hogy milyen IO műveletek történnek egy C bitmező olvasásakor vagy írásakor.
1. Inkább írjon explicit értékeket az IO regiszterekbe, minthogy olvasás-módosítás-írás műveleteket használjon. Azaz, ha egy olyan IO-regiszterben frissítünk egy mezőt, ahol a többi mező értékei ismertek, akkor előnyösebb a regiszter teljes tartalmát explicit módon kiírni. Az explicit írások kisebb, gyorsabb és könnyebben hibakereshető kódot eredményeznek.

## Koordináta-rendszerek

A Klipper belsőleg elsősorban a nyomtatófej helyzetét követi cartesian koordinátákban, amelyek a konfigurációs fájlban megadott koordináta rendszerhez viszonyítva vannak. Ez azt jelenti, hogy a Klipper kód nagy része soha nem tapasztal koordináta rendszer-változást. Ha a felhasználó az origó megváltoztatását kéri (pl. egy `G92` parancsal), akkor ezt a hatást a jövőbeli parancsok elsődleges koordináta rendszerre történő átváltásával érjük el.

Bizonyos esetekben azonban hasznos, ha a nyomtatófej helyzetét más koordináta rendszerben szeretnénk megkapni, és a Klipper több eszközzel is megkönnyíti ezt. Ez a GET_POSITION parancs futtatásával látható. Például:

```
Send: GET_POSITION
Recv: // mcu: stepper_a:-2060 stepper_b:-1169 stepper_c:-1613
Recv: // stepper: stepper_a:457.254159 stepper_b:466.085669 stepper_c:465.382132
Recv: // kinematic: X:8.339144 Y:-3.131558 Z:233.347121
Recv: // toolhead: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode base: X:0.000000 Y:0.000000 Z:0.000000 E:0.000000
Recv: // gcode homing: X:0.000000 Y:0.000000 Z:0.000000
```

Az "MCU" pozíció (`stepper.get_mcu_position()` a kódban) a mikrokontroller által pozitív irányban kiadott lépések száma mínusz a mikrokontroller utolsó resetelése óta negatív irányban kiadott lépések száma. Ha a gép a lekérdezéskor mozgásban van, akkor a jelentett érték tartalmazza a mikrokontrollerben pufferelt lépéseket, de nem tartalmazza a look-ahead sorban lévő lépéseket.

A "stepper" pozíció (`stepper.get_commanded_position()`) az adott léptető pozíciója, ahogyan azt a kinematikai kód követi. Ez általában megfelel a kocsinak a sín mentén a konfigurációs fájlban megadott position_endstop-hoz viszonyított pozíciójának (mm-ben). (Egyes kinematikák a léptetők pozícióját milliméter helyett radiánban követik.) Ha a gép a lekérdezéskor mozgásban van, akkor a jelentett érték tartalmazza a mikrokontrollerben pufferelt mozgásokat, de nem tartalmazza a look-ahead sorban lévő mozgásokat. Használhatjuk a `toolhead.flush_step_generation()` vagy `toolhead.wait_moves()` hívásokat a look-ahead és a lépésgeneráló kód teljes kiürítéséhez.

A "kinematikai" pozíció (`kin.calc_position()`) a szerszámfej "stepper" pozíciókból származtatott cartesian pozíciója, és a konfigurációs fájlban megadott koordinátarendszerhez képest relatív. Ez eltérhet a kért cartesian pozíciótól a léptetőmotorok szaggatottsága miatt. Ha a gép a "stepper" pozíciók felvételekor mozgásban van, akkor a jelentett érték tartalmazza a mikrokontrollerben pufferelt mozgásokat, de nem tartalmazza a look-ahead várólistán lévő mozgásokat. Használhatjuk a `toolhead.flush_step_generation()` vagy `toolhead.wait_moves()` hívásokat a look-ahead és a lépésgeneráló kód teljes kiürítéséhez.

A "toolhead" pozíció (`toolhead.get_position()`) az eszközfej utolsó kért pozíciója cartesian koordinátákban a konfigurációs fájlban megadott koordinátarendszerhez képest. Ha a gép a lekérdezés kiadásakor mozgásban van, akkor a jelentett érték tartalmazza az összes kért mozgást (még azokat is, amelyek a pufferben vannak és a léptetőmotor-meghajtóknak való kiadásra várnak).

A "gcode" pozíció a `G1` (vagy `G0`) parancs utolsó kért pozíciója cartesian koordinátákban, a konfigurációs fájlban megadott koordinátarendszerhez képest. Ez eltérhet a "toolhead" pozíciótól, ha egy G-kód transzformáció (pl. bed_mesh, bed_tilt, skew_correction) van érvényben. Ez eltérhet az utolsó `G1` parancsban megadott tényleges koordinátáktól, ha a G-kód origója megváltozott (pl, `G92`, `SET_GCODE_OFFSET`, `M221`). A `M114` parancs (`gcode_move.get_status()['gcode_position']`) az aktuális G-kód koordinátarendszerhez viszonyított utolsó G-kód pozíciót jelenti.

A "gcode base" a G-kód origójának helye cartesian koordinátákban a konfigurációs fájlban megadott koordinátarendszerhez képest. Az olyan parancsok, mint a `G92`, `SET_GCODE_OFFSET` és `M221` módosítják ezt az értéket.

A "gcode homing" az a hely, amelyet a G-kód origójaként (a konfigurációs fájlban megadott koordinátarendszerhez viszonyított cartesian koordinátákban) a `G28` home parancs után használni kell. A `SET_GCODE_OFFSET` parancs megváltoztathatja ezt az értéket.

## Idő

A Klipper működésének alapvető eleme az órák, időpontok és időbélyegek kezelése. A Klipper a nyomtatón végrehajtott műveleteket a közeljövőben bekövetkező események ütemezésével hajtja végre. Például egy ventilátor bekapcsolásához a kód ütemezheti egy GPIO-tű változását 100 ms alatt. Ritkán fordul elő, hogy a kód azonnali műveletet próbál végrehajtani. Ezért az idő kezelése a Klipperben kritikus fontosságú a helyes működés szempontjából.

A Klipper gazdaszoftverben háromféle időtípust követhetünk nyomon:

* Rendszeridő. A rendszeridő a rendszer monoton óráját használja. Ez egy lebegőpontos szám, amelyet másodpercként tárolnak, és (általában) a gazdaszámítógép utolsó indításakor. A rendszeridők korlátozottan használhatók a szoftverben. Elsősorban az operációs rendszerrel való interakció során használják őket. Az állomáskódon belül a rendszeridőket gyakran az *eventtime* vagy *curtime* nevű változók tárolják.
* Nyomtatási idő. A nyomtatási idő a mikrokontroller fő órájához szinkronizálódik az ("[mcu]" config szakaszban meghatározott mikrokontrollerhez). Ez egy másodpercben tárolt lebegőpontos szám, és a fő MCU utolsó újraindításának időpontjához viszonyítva van. Lehetőség van a "nyomtatási idő"-ről a fő mikrokontroller hardveres órájára való átváltásra. A nyomtatási időnek az MCU-val való megszorzásával a statikusan konfigurált frekvenciával. A magas szintű gazdakód szinte minden fizikai művelet (pl. fejmozgás, fűtésváltás stb.) kiszámításához nyomtatási időt használ. A gazdakódon belül a nyomtatási időket általában a *print_time* vagy *move_time* nevű változókban tárolják.
* MCU óra. Ez az egyes mikrovezérlők hardveres óraszámlálója. Egész számként van tárolva, frissítési gyakorisága az adott mikrovezérlő frekvenciájához viszonyított. A gazdaszoftver belső idejét lefordítja órákra, mielőtt továbbítaná az MCU-nak. Az MCU kód mindig csak az óra ketyegésében követi az időt. A gazdagép kódon belül az óraértékeket 64 bites egész számként követi nyomon, míg az MCU kód 32 bites egész számokat használ. A gazdagép kódon belül az órák általában *clock* vagy *tick* nevet tartalmazó változókban tárolódnak.

A különböző időformátumok közötti konverzió elsősorban a **klippy/clocksync.py** kódban valósul meg.

Néhány dolog, amire figyelni kell a kód áttekintésekor:

* 32 bites és 64 bites órajelek: A sávszélesség csökkentése és a mikrokontroller hatékonyságának javítása érdekében a mikrokontroller órajeleit 32 bites egész számokként követik. Két órajel összehasonlításakor az MCU kódban mindig a `timer_is_before()` függvényt kell használni, hogy az egész számok átfordítását megfelelően kezeljük. A gazdaszoftver a 32 bites órajeleket 64 bites órajelekké alakítja át azáltal, hogy hozzáadja az utolsó kapott MCU időbélyegző magasrendű bitjeit. Egyetlen MCU-tól érkező üzenet sem lehet 2^31 órajelnél több a jövőben vagy a múltban, így ez az átalakítás soha nem félreérthető. A gazdagép a 64 bites órajelekről 32 bites órajelekre konvertál a magasrendű bitek egyszerű lefaragásával. Annak érdekében, hogy ez az átalakítás ne legyen kétértelmű, a **klippy/chelper/serialqueue.c** kód addig puffereli az üzeneteket, amíg azok 2^31 órajelen belül vannak a célidőhöz képest.
* Több mikrovezérlő: A gazdaszoftver támogatja több mikrovezérlő használatát egyetlen nyomtatón. Ebben az esetben minden mikrokontroller "MCU órajelét" külön-külön követi. A clocksync.py kód kezeli a mikrovezérlők közötti óraeltolódást a "nyomtatási időről" az "MCU órára" történő átalakítás módjának módosításával. A másodlagos MCU-nál az ebben az átalakításban használt MCU frekvencia rendszeresen frissül, hogy figyelembe vegye a mért csúszást.
