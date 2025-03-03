# Örvényáramú induktív szonda

Ez a dokumentum az [örvényáramú](https://en.wikipedia.org/wiki/Eddy_current) induktív szonda Klipperben történő használatát írja le.

Jelenleg az örvényáramú szonda nem használható Z-kezdőpont felvételre. Az érzékelő csak Z-szondázásra használható.

Kezdd a [probe_eddy_current konfigurációs szakasz](Config_Reference.md#probe_eddy_current) deklarálásával a printer.cfg fájlban. A `z_offset` értéket ajánlott 0,5 mm-re állítani. Jellemző, hogy az érzékelőnek szüksége van egy `x_offset` és egy `y_offset` értékre. Ha ezek az értékek nem ismertek, akkor a kezdeti kalibrálás során becsléssel adjuk meg az értékeket.

A kalibrálás első lépése az érzékelő megfelelő DRIVE_CURRENT értékének meghatározása. Állítsd be a nyomtatót, és navigáld a nyomtatófejet úgy, hogy az érzékelő az ágy közepéhez közel, az ágy felett kb. 20 mm-re legyen. Ezután add ki az `LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` parancsot. Ha például a konfigurációs szakasz neve `[probe_eddy_current my_eddy_probe]`, akkor az `LDC_CALIBRATE_DRIVE_CURRENT CHIP=my_eddy_probe` parancsot kell futtatni. Ez a parancs néhány másodperc alatt befejeződik. Miután befejeződött, adj ki egy `SAVE_CONFIG` parancsot az eredmények mentéséhez a printer.cfg fájlba, és indítsd újra.

A kalibrálás második lépése az érzékelő leolvasásainak és a megfelelő Z magasságoknak a korrelálása. Állítsd be a nyomtatót, és navigáld a nyomtatófejet úgy, hogy a fúvóka az ágy közepéhez közel legyen. Ezután futtass egy `PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe` parancsot. Miután a fej elindult, kövesd a [„a papír teszt”](Bed_Level.md#the-paper-test) pontban leírt lépéseket a fúvóka és az ágy közötti tényleges távolság meghatározásához az adott helyen. Ha ezek a lépések befejeződtek, akkor a pozíciót „ELFOGADHATJUK”. A gép ezután úgy mozgatja a nyomtatófejet, hogy az érzékelő a fúvóka korábbi helye fölé kerüljön, és lefuttat egy sor mozgást, hogy az érzékelőt a Z pozíciókkal korrelálja. Ez néhány percet vesz igénybe. Miután az eszköz befejezte a munkát, adj ki egy `SAVE_CONFIG` parancsot az eredmények mentéséhez a printer.cfg fájlba, és indítsd újra.

A kezdeti kalibrálás után érdemes ellenőrizni, hogy az `x_offset` és `y_offset` értékek pontosak-e. Kövesd a [szonda X- és Y-eltolásának kalibrálása](Probe_Calibrate.md#calibrating-probe-x-and-y-offsets) lépéseit. Ha az `x_offset` vagy az `y_offset` értéket módosítod, akkor a módosítás után feltétlenül futtasd a `PROBE_EDDY_CURRENT_CALIBRATE` parancsot (a fent leírtak szerint).

A kalibrálás befejezése után a Z-szondát használó összes szabványos Klipper eszköz használható.

Vedd figyelembe, hogy az örvényáram-érzékelők (és általában az induktív szondák) érzékenyek a „termikus elhajlásra”. Vagyis a hőmérséklet változása a jelentett Z magasság változását eredményezheti. Az ágyfelület hőmérsékletének vagy a szenzor hardverhőmérsékletének változása torzíthatja az eredményeket. Fontos, hogy a kalibrálás és a szondázás csak akkor történjen, amikor a nyomtató stabil hőmérsékleten van.

## Termikus elhajlás kalibrálása

Mint minden induktív szondánál, az örvényáramú szondáknál is jelentős a termikus elhajlás. Ha az örvényáramú szonda a tekercsen hőmérséklet-érzékelővel rendelkezik, akkor lehetőség van egy `[temperature_probe]-t konfigurálni a tekercs hőmérsékletének jelentésére és a szoftveres hajláskompenzáció engedélyezésére. A hőmérsékletmérő szonda és az örvényáramú szonda összekapcsolásához a `[temperature_probe]` szakasszal közös nevet kell adnia a `[probe_eddy_current]` szakasznak. Például:

```
[probe_eddy_current my_probe]
# eddy probe configuration...

[temperature_probe my_probe]
# temperature probe configuration...
```

A [konfigurációs hivatkozás](Config_Reference.md#temperature_probe) további részleteket tartalmaz a `temperature_probe` konfigurálásáról. Javasoljuk a `calibration_position`, `calibration_extruder_temp`, `extruder_heating_z` és `calibration_bed_temp` opciók konfigurálását, mivel ez automatizálja az alább ismertetett lépések egy részét. Ha a kalibrálandó nyomtató zárt, erősen ajánlott a `max_validation_temp` opciót 100 és 120 közötti értékre állítani.

Az örvényszondák gyártói kínálhatnak készleten lévő elhajlás kalibrációt, amelyet manuálisan hozzá lehet adni a `[probe_eddy_current]` szakasz `drift_calibration` opciójához. Ha nem, vagy ha a készletkalibráció nem működik jól a rendszereden, a `temperature_probe` modul a `TEMPERATURE_PROBE_CALIBRATE` G-kód parancs segítségével manuális kalibrálási eljárást kínál.

A kalibrálás elvégzése előtt a felhasználónak tudnia kell, hogy mi a maximálisan elérhető hőmérsékletű szondatekercs hőmérséklete. Ezt a hőmérsékletet kell használni a `TEMPERATURE_PROBE_CALIBRATE` parancs `TARGET` paraméterének beállításához. A cél a lehető legszélesebb hőmérséklet-tartományban történő kalibrálás, ezért ajánlatos, hogy hidegen kezdjük, és a tekercset a maximálisan elérhető hőmérsékleten fejezzük be a kalibrálást.

Miután a `[temperature_probe]`-t konfiguráltuk, a következő lépésekkel végezhető el a termikus elhajlás kalibrálás:

- A szondát a `PROBE_EDDY_CURRENT_CALIBRATE` használatával kell kalibrálni, amikor a `[temperature_probe]`-t konfiguráljuk és összekapcsoljuk. Ez rögzíti a hőmérsékletet a kalibrálás során, ami a termikus elhajlás kompenzáció elvégzéséhez szükséges.
- Győződj meg róla, hogy a fúvóka mentes a törmeléktől és a szálaktól.
- Az ágynak, a fúvókának és a szondatekercsnek hidegnek kell lennie a kalibrálás előtt.
- A következő lépésekre akkor van szükség, ha a `[temperature_probe]`-ban a `calibration_position`, `calibration_extruder_temp` és `extruder_heating_z` opciók **NINCSENEK** beállítva:
   - Vidd a nyomtatófejet az ágy közepére. A Z-nek az ágy felett 30 mm-nél nagyobb magasságban kell lennie.
   - Fűtsd fel az extrudert a maximális biztonságos ágyhőmérséklet feletti hőmérsékletre. A legtöbb konfigurációhoz 150-170C elegendőnek kell lennie. Az extruder felmelegítésének célja a fúvóka tágulásának elkerülése a kalibrálás során.
   - Amikor az extruder hőmérséklete beállt, mozgasd a Z tengelyt körülbelül 1 mm-rel az ágy fölé.
- Elhajlás kalibrálás megkezdése. Ha a szonda neve `my_probe` és a maximálisan elérhető szondahőmérséklet 80C, a megfelelő G-kód parancs a `TEMPERATURE_PROBE_CALIBRATE PROBE=my_probe TARGET=80`. Ha beállítjuk, a nyomtatófejet a `calibration_position` által megadott X-Y koordinátára, akkor az `extruder_heating_z` által megadott Z értékre fog mozogni. Miután az extruder a megadott hőmérsékletre melegedett, a szerszám a `calibration_position ` által megadott Z értékre mozog.
- Az eljárás kézi szondát fog kérni. Végezd el a kézi mérést a papírteszttel és az `ACCEPT` gombbal. A kalibrálási eljárás a szondával elvégzi az első mintasorozatot, majd a szondát a fűtési pozícióban leállítja.
- Ha a `calibration_bed_temp` értéke **NINCSEN** beállítva, kapcsold be az ágy fűtését a maximális biztonságos hőmérsékletre. Ellenkező esetben ez a lépés automatikusan végrehajtásra kerül.
- Alapértelmezés szerint a kalibrációs eljárás a minták között 2C-nként kézi szondát kér, amíg a `TARGET` el nem éri a célt. A minták közötti hőmérséklet-különbség testre szabható a `TEMPERATURE_PROBE_CALIBRATE` paraméter `STEP` beállításával. Az egyéni `STEP` érték beállításakor óvatosan kell eljárni, a túl magas érték túl kevés mintát kérhet, ami rossz kalibrációt eredményezhet.
- Az elhajlás kalibrálás során a következő további G-kód parancsok állnak rendelkezésre:
   - A `TEMPERATURE_PROBE_NEXT` használható egy új minta kényszerítésére a lépés delta elérése előtt.
   - A `TEMPERATURE_PROBE_COMPLETE` használható a kalibrálás befejezéséhez a `TARGET` elérése előtt.
   - Az `ABORT` a kalibrálás befejezéséhez és az eredmények elvetéséhez használható.
- Ha a kalibrálás befejeződött, használd a `SAVE_CONFIG` funkciót az elhajlás kalibrálás tárolásához.

Amint arra következtethetünk, a fent vázolt kalibrációs folyamat nagyobb kihívást jelent és időigényesebb, mint a legtöbb más eljárás. Az optimális kalibrálás eléréséhez gyakorlatra és többszöri próbálkozásra lehet szükség.
