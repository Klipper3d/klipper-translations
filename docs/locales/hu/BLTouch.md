# BL-Touch

## BL-Touch csatlakoztatása

Egy **figyelmeztetés** mielőtt elkezdené: Kerülje a BL-Touch tűjének puszta ujjal való érintését, mivel meglehetősen érzékeny az zsírra. Ha pedig mégis hozzáér, legyen nagyon óvatos, hogy ne hajlítsa vagy nyomja meg a tüskét.

Csatlakoztassa a BL-Touch "servo" csatlakozót a `control_pin` csatlakozóhoz a BL-Touch dokumentáció vagy az MCU dokumentációja szerint. Az eredeti kábelezést használva a hármasból a sárga vezeték a `control_pin` és a vezetékpárból a fehér lesz a `sensor_pin`. Ezeket a tűket a kábelezésnek megfelelően kell konfigurálnia. A legtöbb BL-Touch pullup jelet igényel a tűbeállításnál (ezért a csatlakozás nevének előtagja "^"). Például:

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

Ha a BL-Touch-ot a Z tengely alaphelyzetbe állítására használjuk, akkor állítsuk be az `endstop_pin:probe:z_virtual_endstop`-ra és távolítsa el a `position_endstop` és a `[stepper_z]`-t a config szakaszban, majd adjuk hozzá a `[safe_z_home]` config szakaszt a Z tengely megemeléséhez, az X,Y tengelyek kezdőpont felvételére a tárgyasztal közepére való elmozduláshoz és a Z tengely kezdőpont felvételére. Például:

```
[safe_z_home]
home_xy_position: 100, 100 # A koordinátákat a tárgyasztal közepére módosítjuk.
speed: 50
z_hop: 10 # Mozgás felfelé 10mm
z_hop_speed: 5
```

Fontos, hogy a z_hop mozgás a safe_z_home-ban elég nagy legyen ahhoz, hogy a mérőcsúcs ne ütközzön semmibe, még akkor sem, ha a BL-Touch mérőtüskéje a legalacsonyabb állásban van.

## Kezdeti tesztek

Mielőtt továbblépne, ellenőrizze, hogy a BL-Touch a megfelelő magasságban van-e felszerelve. A mérőtüskének behúzott állapotban nagyjából 2 mm-rel a fúvóka fölött kell lennie

Amikor bekapcsolja a nyomtatót, a BL-Touch szondának önellenőrzést kell végeznie, és néhányszor fel-le kell mozgatnia a mérőtüskét. Az önellenőrzés befejezése után a mérőtüskének vissza kell húzódnia, és a szondán lévő piros LED-nek világítania kell. Ha bármilyen hibát észlelsz, például a szonda pirosan villog, vagy a mérőtüske lefelé van, nem pedig behúzva, kérjük kapcsolja ki a nyomtatót, és ellenőrizze a kábelezést és a konfigurációt.

Ha a fentiek rendben vannak, itt az ideje tesztelni, hogy a vezérlés megfelelően működik-e. Először futtassuk le a `BLTOUCH_DEBUG COMMAND=pin_down` parancsot a konzolban. Ellenőrizze, hogy a mérőtüske lefelé mozog-e, és hogy a BL-Touchon lévő piros LED kialszik-e. Ha nem, ellenőrizze újra a kábelezést és a konfigurációt. Ezután adj ki egy `BLTOUCH_DEBUG COMMAND=pin_up` parancsot. Ellenőrizze, hogy a mérőtüske felfelé mozdul-e, és hogy a piros LED ismét világít-e. Ha villog, akkor valamilyen probléma van.

A következő lépés annak megerősítése, hogy a mérőtüske megfelelően működik. Futtassa a `BLTOUCH_DEBUG COMMAND=pin_down` parancsot, és ellenőrizze, hogy a mérőtüske lefelé mozdul-e. Majd futtassa a `BLTOUCH_DEBUG COMMAND=touch_mode` parancsot. Futtassa a `QUERY_PROBE` parancsot, és ellenőrizze, hogy az üzenet "probe: OPEN". Ezután, miközben a körmével finoman felfelé nyomja a mérőtüskét, futtassa le újra a `QUERY_PROBE` parancsot. Ellenőrizze, hogy az üzenet a "probe: TRIGGERED". Ha bármelyik lekérdezés nem a megfelelő üzenetet írja, akkor az általában hibás bekötést vagy konfigurációt jelez (bár egyes [klónok](#bl-touch-clones) speciális kezelést igényelhetnek). A teszt befejezésekor futtassuk le a `BLTOUCH_DEBUG COMMAND=pin_up` parancsot, és ellenőrizzük, hogy a mérőtüske felfelé mozdul.

A BL-Touch vezérlő és érzékelőtüskék tesztelésének befejezése után itt az ideje a szintezés tesztelésének, de egy kis csavarral. Ahelyett, hogy a mérőtüske a tárgyasztalt érintené, a körmünkel fogjuk megérinteni. Helyezze a nyomtatófejet messze a tárgyasztaltól, adj ki egy `G28` (vagy `PROBE`, ha nem használja a probe:z_virtual_endstopot) parancsot, várjon míg a nyomtatófej elkezd lefelé mozogni, és állítsd meg a mozgást úgy, hogy nagyon óvatosan megérinti a mérőtüskét a körmével. Lehet, hogy ezt kétszer kell megtennie, mivel az alapértelmezett kezdőpont konfiguráció kétszer mér. Készüljön fel arra is, hogy kikapcsolja a nyomtatót, ha az nem áll meg, amikor megérinti a mérőtüskét.

Ha ez sikerült, kezd újra `G28` (vagy `PROBE`) parancsal, de ezúttal hagyja, hogy a mérőtüske megérintse a tárgyasztalt.

## A BL-Touch elromlott

Amint a BL-Touch inkonzisztens állapotba kerül, pirosan villogni kezd. Az állapotból való kilépést a következő parancs kiadásával lehet kényszeríteni:

BLTOUCH_DEBUG COMMAND=reset

Ez akkor fordulhat elő, ha a kalibrálás megszakad, mert a mérőtüske nem jön ki a helyéről.

Előfordulhat azonban az is, hogy a BL-Touch már nem tudja magát kalibrálni. Ez akkor fordulhat elő, ha a tetején lévő csavar rossz helyzetben van, vagy ha a mérőtüskében lévő mágneses mag elmozdult. Ha úgy mozdult felfelé, hogy a csavarhoz tapad, előfordulhat, hogy már nem tudja leengedni a tüskét. Ilyen esetben ki kell venni a csavart, és a mérőtüskét óvatosan visszatolni a helyére. Helyezze vissza a tüskét a BL-Touch-ba úgy, hogy az a kihúzott helyzetbe essen. Óvatosan tegye vissza a hernyócsavart a helyére. Meg kell találnia a megfelelő pozíciót, hogy képes legyen leengedni és felemelni a tüskét, hogy a piros LED be és kikapcsoljon. Ehhez használja a `reset`, `pin_up` és `pin_down` parancsokat.

## BL-Touch "klónok"

Sok BL-Touch "klón" működik megfelelően a Klipperrel az alapértelmezett konfigurációval. Néhány "klón" azonban nem támogatja a `QUERY_PROBE` parancsot, és néhány "klón" készülékek a `pin_up_reports_not_triggered` vagy a `pin_up_touch_mode_reports_triggered` parancsok használatát követelik meg.

Fontos! Ne állítsd a `pin_up_reports_not_triggered` vagy a `pin_up_touch_mode_reports_triggered` értékét False értékre anélkül, hogy előbb ne követné ezeket az utasításokat. Ne állítsd egyiket sem False értékre egy valódi BL-Touch esetében. Ezek helytelen beállítása hamis értékre növelheti a mérési időt, és növelheti a nyomtató károsodásának kockázatát.

Néhány "klón" nem támogatja a `touch_mode` parancsot, és ennek eredményeként a `QUERY_PROBE` parancs sem működik. Ennek ellenére lehetséges, hogy ezekkel az eszközökkel még mindig lehet mérést és kezdőpont felvételt végezni. Ezeken az eszközökön a [kezdeti tesztek](#initial-tests) során a `QUERY_PROBE` parancs nem lesz sikeres, azonban az ezt követő `G28` (vagy `PROBE`) teszt sikerül. Lehetséges, hogy ezeket a "klónokat" Klipperrel lehet használni, ha nem használjuk a `QUERY_PROBE` parancsot, és nem engedélyezzük a `probe_with_touch_mode` funkciót.

Néhány "klón" eszköz nem képes elvégezni a Klipper belső érzékelő ellenőrző tesztjét. Ezeken az eszközökön a kezdőpont vagy a szonda próbálkozásai a Klipper "BLTouch failed to verify sensor state" hibát jelentenek. Ha ez bekövetkezik, akkor kézzel futtassa le a [kezdeti tesztek szakaszban](#initial-tests) leírt lépéseket az érzékelőtüske működésének megerősítésére. Ha a `QUERY_PROBE` parancsok ebben a tesztben mindig a várt eredményt adják, és a "BLTouch failed to verify sensor state" hiba továbbra is előfordul, akkor szükséges lehet a Klipper konfigurációs fájlban a `pin_up_touch_mode_reports_triggered` értékét False-ra állítani.

Néhány régi "klón" készülék nem képes jelenteni, ha sikeresen felemelte a szondát. Ezeken az eszközökön a Klipper minden egyes kezdőpont vagy mérési kísérlet után egy "BLTouch failed to raise probe" hibát jelent. Ezeket az eszközöket tesztelhetjük. Távolítsuk el a fejet a tárgyasztaltól, futtassuk a `BLTOUCH_DEBUG COMMAND=pin_down` parancsot, ellenőrizzük, hogy a mérőtüske lefelé mozdult-e, futtassuk a `QUERY_PROBE` parancsot, ellenőrizzük, hogy a "probe: OPEN" értéket kapjuk, futtassuk a `BLTOUCH_DEBUG COMMAND=pin_up`, ellenőrizzük, hogy a mérőtüske felfelé mozdult-e, és futtassuk a `QUERY_PROBE`. Ha a mérőtüske továbbra is fent marad, az eszköz nem lép hibaállapotba, és az első lekérdezés a "probe: OPEN", míg a második lekérdezés a "probe: TRIGGERED", akkor ez azt jelzi, hogy a Klipper konfigurációs fájlban a `pin_up_reports_not_triggered` értékét False-ra kell állítani.

## BL-Touch v3

Egyes BL-Touch v3.0 és BL-Touch 3.1 eszközök esetében előfordulhat, hogy a nyomtató konfigurációs fájljában a `probe_with_touch_mode` beállítása szükséges.

Ha a BL-Touch v3.0 jelkábelét egy (zajszűrő kondenzátorral ellátott) végállás csatlakozóhoz csatlakoztatja, akkor előfordulhat, hogy a BL-Touch v3.0 nem tud következetesen jelet küldeni a kezdőpont felvétel és a mérés során. Ha a [kezdeti tesztek szakaszban](#initial-tests) található `QUERY_PROBE` parancsok mindig a várt eredményt adják, de a nyomtatófej nem mindig áll meg a G28/PROBE parancsok alatt, akkor ez erre a problémára utal. A megoldás a `probe_with_touch_mode: True` beállítása a konfigurációs fájlban.

Előfordulhat, hogy a BL-Touch v3.1 egy sikeres mérési kísérlet után hibaállapotba kerül. Ennek tünete a BL-Touch v3.1 időnként villogó fénye, amely néhány másodpercig tart, miután sikeresen érintkezik az ággyal. A Klippernek ezt a hibát automatikusan törölnie kell, és általában ártalmatlan. A konfigurációs fájlban azonban beállíthatjuk a `probe_with_touch_mode` értéket, hogy elkerüljük ezt a problémát.

Fontos! Néhány "klón" eszköz és a BL-Touch v2.0 (és korábbi) csökkent pontosságú lehet, ha a `probe_with_touch_mode` értéke True. Ennek True értékre állítása a szonda telepítésének idejét is megnöveli. Ha ezt az értéket egy "klón" vagy régebbi BL-Touch eszközön konfigurálja, mindenképpen tesztelje a szonda pontosságát az érték beállítása előtt és után (a teszteléshez használja a `PROBE_ACCURACY` parancsot).

## Többszöri szúrópróbaszerű mérés

Alapértelmezés szerint a Klipper minden egyes méréskísérlet kezdetén kitelepíti a mérőtüskét, majd utána elrakja. A szonda ismételt be és kitelepítése megnövelheti a sok mérést tartalmazó kalibrálási folyamatok teljes időtartamát. A Klipper támogatja, hogy a mérőtüskét az egymást követő mérések között is kihelyezve hagyja, ami csökkentheti a mérések teljes idejét. Ez az üzemmód a `stow_on_each_sample` False értékre való beállításával engedélyezhető a konfigurációs fájlban.

Fontos! A `stow_on_each_sample` False (Hamis) beállítása ahhoz vezethet, hogy a Klipper vízszintes nyomtatófej mozgásokat végez, miközben a szonda ki van helyezve. Győződjön meg róla, hogy minden szondázási műveletnél elegendő Z-távolság van, mielőtt ezt az értéket False értékre állítaná. Ha nincs elegendő szabad tér, akkor a vízszintes mozgások során a mérőtüske beleakadhat egy akadályba, ami a nyomtató vagy mérőeszköz károsodását eredményezheti.

Fontos! Ajánlott a True értékre konfigurált `probe_with_touch_mode` használata, ha a False értékre konfigurált `stow_on_each_sample` értéket használja. Néhány "klón" eszköz nem érzékeli a tárgyasztal későbbi érintését, ha a `probe_with_touch_mode` nincs beállítva. Minden eszközön e két beállítás kombinációjának használata egyszerűsíti az eszköz jelzését, ami javíthatja az általános stabilitást.

Vedd figyelembe azonban, hogy néhány "klón" eszköz és a BL-Touch v2.0 (és korábbi) csökkentett pontosságú lehet, ha a `probe_with_touch_mode` értéke True. Ezeken az eszközökön érdemes tesztelni a szonda pontosságát a `probe_with_touch_mode` beállítása előtt és után (a teszteléshez használja a `PROBE_ACCURACY` parancsot).

## A BL-Touch eltolások kalibrálása

Az x_offset, y_offset és z_offset konfigurációs paraméterek beállításához kövesse a [Szintező Kalibrálása](Probe_Calibrate.md) útmutatóban található utasításokat.

Jó ötlet ellenőrizni, hogy a Z eltolás közel 1 mm. Ha nem, akkor valószínűleg felfelé vagy lefelé kell mozgatni a szondát, hogy ezt kijavítsa. Azt szeretné, hogy aktiválódjon, mielőtt a fúvóka a tárgyasztalhoz ér, hogy a fúvókához ragadt nyomtatószál vagy a meggörbült tárgyasztal ne befolyásolja a mérési műveletet. Ugyanakkor azonban azt szeretné, ha a visszahúzott pozíció a lehető legmesszebb lenne a fúvóka felett, hogy elkerülje a nyomtatott tárgyak érintkezését. Ha a szonda pozíciójáballítása megtörtént, akkor ismételje meg a kalibrálás lépéseit.

## BL-Touch kimeneti mód


   * A BL-Touch V3.0 támogatja az 5V vagy OPEN-DRAIN kimeneti mód beállítását, a BL-Touch V3.1 szintén támogatja ezt, de ezt a belső EEPROM-jában is el tudja tárolni. Ha az alaplapjának szüksége van az 5V-os üzemmód fix 5V magas logikai szintjére, akkor a nyomtató konfigurációs fájl [bltouch] szakaszában a 'set_output_mode' paramétert "5V" értékre állíthatja.*** Csak akkor használja az 5V-os üzemmódot, ha az alaplapnak a bemeneti vonala 5V-os toleráns. Ezért ezeknek a BL-Touch verzióknak az alapértelmezett konfigurációja a OPEN-DRAIN üzemmód. Ezzel potenciálisan károsíthatja az alaplap CPU-ját ***

   Ezért tehát: Ha egy alaplapnak 5V-os üzemmódra van szüksége ÉS 5V-os toleráns a bemeneti jelvonalon ÉS ha

   - ha neked BL-Touch Smart V3.0 van, akkor a 'set_output_mode-ot: 5V' paramétert kell megadni, hogy minden egyes indításkor biztosítsd ezt a beállítást, mivel a szonda nem tudja megjegyezni a szükséges beállítást.
   - ha neked BL-Touch Smart V3.1 van, akkor választhatsz a 'set_output_mode: 5V' vagy az üzemmód egyszeri tárolása a 'BLTOUCH_STORE MODE=5V' parancsok közül, kézzel és NEM a 'set_output_mode:' paraméter használatával.
   - ha van más szondája is: A kimeneti üzemmód (végleges) beállításához néhány szondának van egy bekötése az alaplapon, amelyet el kell vágni, vagy egy jumperrel kell beállítani. Ebben az esetben hagyja ki teljesen a 'set_output_mode' paramétert.
Ha V3.1 szondával rendelkezik, ne automatizálja vagy ismételje a kimeneti üzemmód tárolását, hogy elkerülje a szonda EEPROM-jának elhasználódását. A BLTouch EEPROM körülbelül 100.000 frissítésre alkalmas. A napi 100 tárolás körülbelül 3 évnyi működést jelentene, mielőtt elhasználódna. Így a kimeneti üzemmód tárolását a V3.1-ben a gyártó bonyolult műveletnek tervezte (a gyári alapértelmezett egy biztonságos OPEN DRAIN üzemmód), és nem alkalmas arra, hogy bármilyen szeletelő, makró vagy bármi más által ismételten kiadja, lehetőleg csak akkor használható, amikor először integrálják a szondát egy nyomtató alaplapjára.
