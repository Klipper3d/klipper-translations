# Konfigurációs ellenőrzések

Ez a dokumentum a Klipper printer.cfg fájl tű beállításainak megerősítéséhez szükséges lépések listáját tartalmazza. Célszerű ezeket a lépéseket a [telepítési dokumentum](Installation.md) lépéseinek követésével végrehajtani.

Az útmutató során szükség lehet a Klipper konfigurációs fájljának módosítására. Ügyelj arra, hogy a konfigurációs fájl minden módosítása után adj ki egy RESTART parancsot, hogy megbizonyosodj arról, hogy a változtatás érvénybe lép (írd be a "restart" kifejezést az Octoprint terminál lapjára, majd kattints a "Küldés" gombra). Az is jó ötlet, hogy minden RESTART után kiadsz egy STATUS parancsot a konfigurációs fájl sikeres betöltésének ellenőrzésére.

## Ellenőrizd a hőmérsékletet

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Ellenőrzés M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Ellenőrizd a fűtőtesteket

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Ha a nyomtató fűtött ággyal rendelkezik, akkor végezd el a fenti vizsgálatot a tárgyasztalnál is.

## A léptetőmotor engedélyező tű ellenőrzése

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Végállások ellenőrzése

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Ha a végállás egyáltalán nem változik, akkor ez általában azt jelzi, hogy a végállás egy másik tűhöz van csatlakoztatva. Azonban az is előfordulhat, hogy a tű "pullup" beállításának megváltoztatására van szükség (a '^' az endstop_pin név elején, a legtöbb nyomtató "pullup" ellenállást használ, és a '^' -nek jelen kell lennie).

## Léptetőmotorok ellenőrzése

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Ha a léptető egyáltalán nem mozog, akkor ellenőrizd az "enable_pin" és "step_pin" beállításokat a léptetőnél. Ha a léptetőmotor mozog, de nem tér vissza az eredeti helyzetébe, akkor ellenőrizd a "dir_pin" beállítást. Ha a léptetőmotor helytelen irányban mozog, akkor ez általában azt jelzi, hogy a tengely "dir_pin" beállítását meg kell fordítani. Ezt úgy lehet megtenni, hogy a nyomtató konfigurációs fájlban a "dir_pin" értékhez hozzáadunk egy '!' jelet (vagy eltávolítjuk, ha már van ilyen). Ha a motor egy milliméternél lényegesen többet vagy lényegesen kevesebbet mozog, akkor ellenőrizd a "rotation_distance" beállítást.

Futtasd a fenti tesztet a konfigurációs fájlban definiált minden egyes léptetőmotorra. (Állítsd a STEPPER_BUZZ parancs STEPPER paraméterét a tesztelendő konfigurációs szakasz nevére). Ha nincs nyomtatószál az extruderben, akkor a STEPPER_BUZZ paranccsal ellenőrizheted az extruder motor csatlakozását (használd a STEPPER=extruder parancsot). Ellenkező esetben a legjobb ha az extruder motort külön teszteljük (lásd a következő szakaszt).

Az összes végállás és léptetőmotor ellenőrzése után a célba állítási mechanizmust tesztelni kell. Adj ki egy G28 parancsot az összes tengely alaphelyzetbe állításához. Ha a nyomtató nem állítható be megfelelően, akkor kapcsold ki. Ha szükséges, ismételd meg a végállások és a léptetőmotorok ellenőrzését.

## Extruder motor ellenőrzése

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## PID beállítások kalibrálása

A Klipper támogatja a [PID-szabályozást](https://hu.wikipedia.org/wiki/PID_szab%C3%A1lyoz%C3%B3) az extruder és a tárgyasztal fűtés számára. Ahhoz, hogy ezt a vezérlési mechanizmust használni lehessen, a PID-beállításokat minden nyomtatónál kalibrálni kell (a más firmware-ekben vagy a példakonfigurációs fájlokban található PID-beállítások gyakran rosszul működnek).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

A hangolási teszt végén futtasd a `SAVE_CONFIG` parancsot a printer.cfg fájl új PID-beállításainak frissítéséhez.

Ha a nyomtató fűtött ággyal rendelkezik, és az támogatja a PWM (impulzusszélesség-moduláció) vezérlést, akkor ajánlott PID vezérlést használni a tárgyasztalhoz. (Ha a tárgyasztal fűtést PID algoritmussal vezérled, akkor másodpercenként tízszer is be- és kikapcsolhat, ami nem biztos, hogy megfelelő a mechanikus kapcsolót használó fűtőberendezésekhez.) A tipikus tárgyasztal PID-kalibrálási parancs: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Következő lépések

Ez az útmutató a Klipper konfigurációs fájlban lévő tű-beállítások alapvető ellenőrzéséhez nyújt segítséget. Mindenképpen olvasd el a [tárgyasztal szintezése](Bed_Level.md) útmutatót. A Klipperrel történő szeletelő konfigurálásával kapcsolatos információkért olvasd el a [Szeletelők](Slicers.md) dokumentumot is.

Miután meggyőződtünk arról, hogy az alapnyomtatás működik, érdemes megfontolni a [nyomás előtolás](Pressure_Advance.md) kalibrálását.

Előfordulhat, hogy más típusú részletes nyomtató-kalibrálásra is szükség lehet. Ehhez számos útmutató áll rendelkezésre az interneten (keress rá például a "3d nyomtató kalibrálás" szövegre). Ha például a gyűrődésnek nevezett hatást tapasztalod, megpróbálhatod követni a [rezonancia kompenzáció](Resonance_Compensation.md) hangolási útmutatót.
