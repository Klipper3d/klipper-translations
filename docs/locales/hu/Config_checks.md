# Konfigurációs ellenőrzések

Ez a dokumentum a Klipper printer.cfg fájl tű beállításainak megerősítéséhez szükséges lépések listáját tartalmazza. Célszerű ezeket a lépéseket a [telepítési dokumentum](Installation.md) lépéseinek követésével végrehajtani.

Az útmutató során szükség lehet a Klipper konfigurációs fájljának módosítására. Ügyelj arra, hogy a konfigurációs fájl minden módosítása után adj ki egy RESTART parancsot, hogy megbizonyosodj arról, hogy a változtatás érvénybe lép (írd be a "restart" kifejezést az Octoprint terminál lapjára, majd kattints a "Küldés" gombra). Az is jó ötlet, hogy minden RESTART után kiadsz egy STATUS parancsot a konfigurációs fájl sikeres betöltésének ellenőrzésére.

## Ellenőrizd a hőmérsékletet

Kezd annak ellenőrzésével, hogy a hőmérsékletek megfelelően jelennek-e meg. Navigálj a felhasználói felület hőmérsékletgrafikon szakaszához. Ellenőrizd, hogy a fúvóka és az ágy hőmérséklete (ha van ilyen) jelen van-e, és nem emelkedik-e. Ha növekszik, kapcsold le a nyomtató tápellátását. Ha a hőmérsékletek nem pontosak, vizsgáld felül a fúvóka és/vagy az ágy "sensor_type" és "sensor_pin" beállításait.

## Ellenőrzés M112

Navigálj a parancskonzolra, és adj ki egy M112 parancsot a terminálmezőben. Ez a parancs arra kéri a Klippert, hogy "leállási" állapotba kerüljön. Ez egy hiba megjelenését okozza, amely a FIRMWARE_RESTART paranccsal törölhető a parancskonzolon. Az Octoprint is újrakapcsolást fog kérni. Ezután navigálj a hőmérsékleti grafikon részhez, és ellenőrizd, hogy a hőmérsékletek továbbra is frissülnek, és a hőmérsékletek nem emelkednek. Ha a hőmérsékletek emelkednek, kapcsold ki a nyomtató tápellátását.

## Ellenőrizd a fűtőtesteket

Navigálj a hőmérsékleti grafikon részhez, és írd be az 50-et, majd az enter-t az extruder/szerszám hőmérséklet mezőbe. Az extruder hőmérsékletének a grafikonon növekednie kell (kb. 30 másodpercen belül). Ezután lépj az extruder hőmérséklet legördülő menübe, és válaszd az "Off" (Ki) lehetőséget. Néhány perc múlva a hőmérsékletnek el kell kezdenie csökkenni a kezdeti szobahőmérsékleti értékre. Ha a hőmérséklet nem emelkedik, akkor ellenőrizd a "heater_pin" beállítást a konfigurációban.

Ha a nyomtató fűtött ággyal rendelkezik, akkor végezd el a fenti vizsgálatot a tárgyasztalnál is.

## A léptetőmotor engedélyező tű ellenőrzése

Ellenőrizd, hogy a nyomtató minden tengelye manuálisan szabadon mozog-e (a léptetőmotorok ki vannak kapcsolva). Ha nem, adj ki egy M84 parancsot a motorok letiltására. Ha valamelyik tengely még mindig nem tud szabadon mozogni, akkor ellenőrizd a léptetőmotor "enable_pin" konfigurációját az adott tengelyhez. A legtöbb hagyományos léptetőmotor-meghajtónál a motor engedélyező pin "aktív alacsony", ezért az engedélyező pin előtt egy "!"-nek kell lennie (például "enable_pin: !PA1").

## Végállások ellenőrzése

Kézzel mozgasd az összes nyomtatótengelyt úgy, hogy egyikük se érintkezzen végállással. Küldj QUERY_ENDSTOPS parancsot a parancskonzolon keresztül. Válaszul meg kell kapnod az összes konfigurált végállás aktuális állapotát, és mindegyiknek "nyitott" állapotot kell jeleznie. Minden egyes végállás esetében futtasd újra a QUERY_ENDSTOPS parancsot, miközben kézzel kezdeményezed a végállást. A QUERY_ENDSTOPS parancsnak a végállást "TRIGGERED"-ként kell jeleznie.

Ha a végállás invertáltnak tűnik ("nyitott" jelzést ad, amikor kivált, és fordítva), akkor adjunk hozzá egy "!"-t a pin-definícióhoz (például "endstop_pin: ^PA2"), vagy távolítsuk el a "!"-t, ha már van benne egy.

Ha a végállás egyáltalán nem változik, akkor ez általában azt jelzi, hogy a végállás egy másik tűhöz van csatlakoztatva. Azonban az is előfordulhat, hogy a tű "pullup" beállításának megváltoztatására van szükség (a '^' az endstop_pin név elején, a legtöbb nyomtató "pullup" ellenállást használ, és a '^' -nek jelen kell lennie).

## Léptetőmotorok ellenőrzése

A STEPPER_BUZZ parancs segítségével ellenőrizd az egyes léptetőmotorok csatlakoztathatóságát. Kezd az adott tengely kézi pozicionálásával egy középső pontra, majd futtasd a `STEPPER_BUZZ STEPPER=stepper_x` parancsot a parancskonzolon. A STEPPER_BUZZ parancs hatására az adott léptető egy millimétert mozog pozitív irányba, majd visszatér a kiindulási helyzetébe. (Ha a végállást a position_endstop=0 értéken definiáljuk, akkor minden egyes mozgás kezdetén a léptető a végállástól távolodik). Ezt az oszcillációt tízszer fogja végrehajtani.

Ha a léptető egyáltalán nem mozog, akkor ellenőrizd az "enable_pin" és "step_pin" beállításokat a léptetőnél. Ha a léptetőmotor mozog, de nem tér vissza az eredeti helyzetébe, akkor ellenőrizd a "dir_pin" beállítást. Ha a léptetőmotor helytelen irányban mozog, akkor ez általában azt jelzi, hogy a tengely "dir_pin" beállítását meg kell fordítani. Ezt úgy lehet megtenni, hogy a nyomtató konfigurációs fájlban a "dir_pin" értékhez hozzáadunk egy '!' jelet (vagy eltávolítjuk, ha már van ilyen). Ha a motor egy milliméternél lényegesen többet vagy lényegesen kevesebbet mozog, akkor ellenőrizd a "rotation_distance" beállítást.

Futtasd a fenti tesztet a konfigurációs fájlban definiált minden egyes léptetőmotorra. (Állítsd a STEPPER_BUZZ parancs STEPPER paraméterét a tesztelendő konfigurációs szakasz nevére). Ha nincs nyomtatószál az extruderben, akkor a STEPPER_BUZZ paranccsal ellenőrizheted az extruder motor csatlakozását (használd a STEPPER=extruder parancsot). Ellenkező esetben a legjobb ha az extruder motort külön teszteljük (lásd a következő szakaszt).

Az összes végállás és léptetőmotor ellenőrzése után a célba állítási mechanizmust tesztelni kell. Adj ki egy G28 parancsot az összes tengely alaphelyzetbe állításához. Ha a nyomtató nem állítható be megfelelően, akkor kapcsold ki. Ha szükséges, ismételd meg a végállások és a léptetőmotorok ellenőrzését.

## Extruder motor ellenőrzése

Az extrudermotor teszteléséhez az extrudert nyomtatási hőmérsékletre kell melegíteni. Navigálj a hőmérsékletgrafikon szakaszra, és válassz ki egy célhőmérsékletet a hőmérséklet legördülő menüből (vagy add meg manuálisan a megfelelő hőmérsékletet). Várd meg, amíg a nyomtató eléri a kívánt hőmérsékletet. Ezután navigálj a parancskonzolra, és kattints az "Extrudálás" gombra. Ellenőrizd, hogy az extruder motorja a megfelelő irányba forog-e. Ha nem, akkor az előző szakaszban található hibaelhárítási tippek alapján ellenőrizd az extruder "enable_pin", "step_pin" és "dir_pin" beállításait.

## PID beállítások kalibrálása

A Klipper támogatja a [PID-szabályozást](https://hu.wikipedia.org/wiki/PID_szab%C3%A1lyoz%C3%B3) az extruder és a tárgyasztal fűtés számára. Ahhoz, hogy ezt a vezérlési mechanizmust használni lehessen, a PID-beállításokat minden nyomtatónál kalibrálni kell (a más firmware-ekben vagy a példakonfigurációs fájlokban található PID-beállítások gyakran rosszul működnek).

Az extruder kalibrálásához navigálj a parancskonzolra, és futtasd a PID_CALIBRATE parancsot. Például: `PID_CALIBRATE HEATER=extruder TARGET=170`

A hangolási teszt végén futtasd a `SAVE_CONFIG` parancsot a printer.cfg fájl új PID-beállításainak frissítéséhez.

Ha a nyomtató fűtött ággyal rendelkezik, és az támogatja a PWM (impulzusszélesség-moduláció) vezérlést, akkor ajánlott PID vezérlést használni a tárgyasztalhoz. (Ha a tárgyasztal fűtést PID algoritmussal vezérled, akkor másodpercenként tízszer is be- és kikapcsolhat, ami nem biztos, hogy megfelelő a mechanikus kapcsolót használó fűtőberendezésekhez.) A tipikus tárgyasztal PID-kalibrálási parancs: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Következő lépések

Ez az útmutató a Klipper konfigurációs fájlban lévő tű-beállítások alapvető ellenőrzéséhez nyújt segítséget. Mindenképpen olvasd el a [tárgyasztal szintezése](Bed_Level.md) útmutatót. A Klipperrel történő szeletelő konfigurálásával kapcsolatos információkért olvasd el a [Szeletelők](Slicers.md) dokumentumot is.

Miután meggyőződtünk arról, hogy az alapnyomtatás működik, érdemes megfontolni a [nyomás előtolás](Pressure_Advance.md) kalibrálását.

Előfordulhat, hogy más típusú részletes nyomtató-kalibrálásra is szükség lehet. Ehhez számos útmutató áll rendelkezésre az interneten (keress rá például a "3d nyomtató kalibrálás" szövegre). Ha például a gyűrődésnek nevezett hatást tapasztalod, megpróbálhatod követni a [rezonancia kompenzáció](Resonance_Compensation.md) hangolási útmutatót.
