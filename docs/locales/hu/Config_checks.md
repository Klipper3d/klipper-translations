# Konfigurációs ellenőrzések

Ez a dokumentum a Klipper printer.cfg fájl tű beállításainak megerősítéséhez szükséges lépések listáját tartalmazza. Célszerű ezeket a lépéseket a [telepítési dokumentum](Installation.md) lépéseinek követésével végrehajtani.

Az útmutató során szükség lehet a Klipper konfigurációs fájljának módosítására. Ügyelj arra, hogy a konfigurációs fájl minden módosítása után adj ki egy RESTART parancsot, hogy megbizonyosodj arról, hogy a változtatás érvénybe lép (írd be a "restart" kifejezést az Octoprint terminál lapjára, majd kattints a "Küldés" gombra). Az is jó ötlet, hogy minden RESTART után kiadsz egy STATUS parancsot a konfigurációs fájl sikeres betöltésének ellenőrzésére.

## Ellenőrizd a hőmérsékletet

Kezd azzal, hogy ellenőrzöd, a hőmérséklet megfelelően van-e jelentve. Lépj az Octoprint hőmérséklet lapjára.

![octoprint-temperature](img/octoprint-temperature.png)

Ellenőrizd, hogy a fúvóka és a tárgyasztal hőmérséklete (ha van) jelen van-e, és nem emelkedik. Ha növekszik, kapcsold ki a nyomtatót. Ha a hőmérsékletek nem pontosak, tekintsd át a fúvóka és/vagy tárgyasztal "sensor_type" és "sensor_pin" beállításait.

## Ellenőrzés M112

Navigálj az Octoprint terminál fülre, és adj ki egy M112 parancsot a terminálmezőben. Ez a parancs arra kéri a Klippert, hogy lépjen "leállási" állapotba. Ennek hatására az Octoprint megszakítja a kapcsolatot a Klipperrel. Navigálj a Connection (Kapcsolat) területre, és kattints a "Kapcsolódás" gombra, hogy az Octoprint újra csatlakozzon. Ezután navigálj az Octoprint hőmérséklet fülre, és ellenőrizd, hogy a hőmérsékletek továbbra is frissülnek-e, és a hőmérsékletek nem emelkednek-e. Ha a hőmérsékletek emelkednek, kapcsold le a nyomtatót a hálózatról.

Az M112 parancs hatására a Klipper "leállítás" állapotba kerül. Ennek az állapotnak a törléséhez adj ki egy FIRMWARE_RESTART parancsot az Octoprint terminál lapon.

## Ellenőrizd a fűtőtesteket

Navigálj az Octoprint hőmérséklet fülre, és írd be az 50-et, majd nyomj Entert az "Eszköz" hőmérséklet mezőbe. Az extruder hőmérsékletének a grafikonon növekednie kell (körülbelül 30 másodpercen belül). Ezután lépj az "Eszköz" hőmérséklet legördülő mezőbe, és válaszd az "Off" lehetőséget. Néhány perc múlva a hőmérsékletnek el kell kezdenie visszaesni a kezdeti hőmérséklet felé. Ha a hőmérséklet nem emelkedik, akkor ellenőrizd a "heater_pin" beállítását a konfigurációs fájlban.

Ha a nyomtató fűtött ággyal rendelkezik, akkor végezd el a fenti vizsgálatot a tárgyasztalnál is.

## A léptetőmotor engedélyező tű ellenőrzése

Ellenőrizd, hogy a nyomtató minden tengelye manuálisan szabadon mozog-e (a léptetőmotorok ki vannak kapcsolva). Ha nem, akkor adj ki egy M84 parancsot a motorok letiltásához. Ha valamelyik tengely még mindig nem tud szabadon mozogni, akkor ellenőrizd a léptető "enable_pin" konfigurációt az adott tengelyhez. A legtöbb hagyományos léptetőmotor meghajtónál a motor engedélyező tű "active low", ezért az engedélyező tű előtt egy "!" jelnek kell állnia (például "enable_pin: !ar38").

## Végállások ellenőrzése

Kézzel mozgasd az összes nyomtatótengelyt úgy, hogy egyikük se érintkezzen végállással. Küldj QUERY_ENDSTOPS parancsot az Octoprint terminál lapján keresztül. A nyomtatónak válaszolnia kell az összes konfigurált végállás aktuális állapotával, és mindegyiknek "open" állapotot kell jeleznie. Az egyes végleállások esetében futtasd újra a QUERY_ENDSTOPS parancsot, miközben manuálisan használd a végleállást. A QUERY_ENDSTOPS parancsnak jeleznie kell a végállást, mint "TRIGGERED".

Ha a végállás inverznek tűnik (a kiváltáskor "open" jelzést ad, és fordítva), akkor adjunk hozzá egy "!" -t a tű definícióhoz (például "endstop_pin: ^!ar3"), vagy távolítsuk el a "!" -t, ha már van ilyen.

Ha a végállás egyáltalán nem változik, akkor ez általában azt jelzi, hogy a végállás egy másik tűhöz van csatlakoztatva. Azonban az is előfordulhat, hogy a tű "pullup" beállításának megváltoztatására van szükség (a '^' az endstop_pin név elején, a legtöbb nyomtató "pullup" ellenállást használ, és a '^' -nek jelen kell lennie).

## Léptetőmotorok ellenőrzése

A STEPPER_BUZZ parancs segítségével ellenőrizd az egyes léptetőmotorok csatlakozását. Kezd az adott tengely kézi pozicionálásával egy középső pontra, majd futtasd a `STEPPER_BUZZ STEPPER=stepper_x` parancsot. A STEPPER_BUZZ parancs hatására az adott stepper egy millimétert mozdul pozitív irányba, majd visszatér a kiindulási helyzetébe. (Ha a végállást a position_endstop=0 értéken definiáljuk, akkor minden egyes mozgás kezdetén a léptető a végállástól távolodik). Ezt a mozgást tízszer fogja végrehajtani.

Ha a léptető egyáltalán nem mozog, akkor ellenőrizd az "enable_pin" és "step_pin" beállításokat a léptetőnél. Ha a léptetőmotor mozog, de nem tér vissza az eredeti helyzetébe, akkor ellenőrizd a "dir_pin" beállítást. Ha a léptetőmotor helytelen irányban mozog, akkor ez általában azt jelzi, hogy a tengely "dir_pin" beállítását meg kell fordítani. Ezt úgy lehet megtenni, hogy a nyomtató konfigurációs fájlban a "dir_pin" értékhez hozzáadunk egy '!' jelet (vagy eltávolítjuk, ha már van ilyen). Ha a motor egy milliméternél lényegesen többet vagy lényegesen kevesebbet mozog, akkor ellenőrizd a "rotation_distance" beállítást.

Futtasd a fenti tesztet a konfigurációs fájlban definiált minden egyes léptetőmotorra. (Állítsd a STEPPER_BUZZ parancs STEPPER paraméterét a tesztelendő konfigurációs szakasz nevére). Ha nincs nyomtatószál az extruderben, akkor a STEPPER_BUZZ paranccsal ellenőrizheted az extruder motor csatlakozását (használd a STEPPER=extruder parancsot). Ellenkező esetben a legjobb ha az extruder motort külön teszteljük (lásd a következő szakaszt).

Az összes végállás és léptetőmotor ellenőrzése után a célba állítási mechanizmust tesztelni kell. Adj ki egy G28 parancsot az összes tengely alaphelyzetbe állításához. Ha a nyomtató nem állítható be megfelelően, akkor kapcsold ki. Ha szükséges, ismételd meg a végállások és a léptetőmotorok ellenőrzését.

## Extruder motor ellenőrzése

Az extruder motor teszteléséhez a nyomtatófejet nyomtatási hőmérsékletre kell melegíteni. Navigálj az Octoprint hőmérséklet fülre, és válassz ki egy célhőmérsékletet a hőmérséklet legördülő menüből (vagy add meg manuálisan a megfelelő hőmérsékletet). Várd meg, amíg a fej eléri a kívánt hőmérsékletet. Ezután navigálj az Octoprint vezérlő lapra, és kattints az "Extrudálás" gombra. Ellenőrizd, hogy az extruder motorja a megfelelő irányba forog-e. Ha nem, akkor az előző szakaszban található hibaelhárítási tippek alapján ellenőrizd az extruder "enable_pin", "step_pin" és "dir_pin" beállításait.

## PID beállítások kalibrálása

A Klipper támogatja a [PID-szabályozást](https://hu.wikipedia.org/wiki/PID_szab%C3%A1lyoz%C3%B3) az extruder és a tárgyasztal fűtés számára. Ahhoz, hogy ezt a vezérlési mechanizmust használni lehessen, a PID-beállításokat minden nyomtatónál kalibrálni kell (a más firmware-ekben vagy a példakonfigurációs fájlokban található PID-beállítások gyakran rosszul működnek).

Az extruder kalibrálásához navigálj az OctoPrint terminál fülre, és futtasd a PID_CALIBRATE parancsot. Például: `PID_CALIBRATE HEATER=extruder TARGET=170`

A hangolási teszt végén futtasd a `SAVE_CONFIG` parancsot a printer.cfg fájl új PID-beállításainak frissítéséhez.

Ha a nyomtató fűtött ággyal rendelkezik, és az támogatja a PWM (impulzusszélesség-moduláció) vezérlést, akkor ajánlott PID vezérlést használni a tárgyasztalhoz. (Ha a tárgyasztal fűtést PID algoritmussal vezérled, akkor másodpercenként tízszer is be- és kikapcsolhat, ami nem biztos, hogy megfelelő a mechanikus kapcsolót használó fűtőberendezésekhez.) A tipikus tárgyasztal PID-kalibrálási parancs: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Következő lépések

Ez az útmutató a Klipper konfigurációs fájlban lévő tű-beállítások alapvető ellenőrzéséhez nyújt segítséget. Mindenképpen olvasd el a [tárgyasztal szintezése](Bed_Level.md) útmutatót. A Klipperrel történő szeletelő konfigurálásával kapcsolatos információkért olvasd el a [Szeletelők](Slicers.md) dokumentumot is.

Miután meggyőződtünk arról, hogy az alapnyomtatás működik, érdemes megfontolni a [nyomás előtolás](Pressure_Advance.md) kalibrálását.

Előfordulhat, hogy más típusú részletes nyomtató-kalibrálásra is szükség lehet. Ehhez számos útmutató áll rendelkezésre az interneten (keress rá például a "3d nyomtató kalibrálás" szövegre). Ha például a gyűrődésnek nevezett hatást tapasztalod, megpróbálhatod követni a [rezonancia kompenzáció](Resonance_Compensation.md) hangolási útmutatót.
