# Végállás fázis

Ez a dokumentum a Klipper léptetőfázis-beállított végütköző rendszerét írja le. Ez a funkció javíthatja a hagyományos végálláskapcsolók pontosságát. Ez a leghasznosabb olyan Trinamic léptetőmotor-illesztőprogram használatakor, amely futásidejű konfigurációval rendelkezik.

Egy tipikus végálláskapcsoló pontossága körülbelül 100 mikron. (A tengely minden egyes indításakor a kapcsoló valamivel korábban vagy valamivel később léphet működésbe). Bár ez viszonylag kis hiba, nem kívánt nyomtatványokat eredményezhet. Különösen a tárgy első rétegének nyomtatásakor lehet észrevehető ez a pozícióeltérés. Ezzel szemben a tipikus léptetőmotorokkal lényegesen nagyobb pontosság érhető el.

A lépcsős fázisú végállás mechanizmus a lépcsős motorok pontosságát használhatja a végálláskapcsolók pontosságának javítására. A léptetőmotor egy sor fázison keresztül ciklikusan mozog, amíg négy "teljes lépést" nem teljesít. Tehát egy 16 mikrolépést használó léptetőmotornak 64 fázisa lenne, és pozitív irányba történő mozgáskor a fázisok között ciklikusan haladna: 0, 1, 2, ... 61, 62, 63, 0, 1, 2, stb. Lényeges, hogy amikor a léptetőmotor egy adott pozícióban van a lineáris sínen, mindig ugyanabban a léptetőfázisban kell lennie. Így amikor egy kocsi a végálláskapcsolót aktiválja, az adott kocsit vezérlő léptetőnek mindig ugyanabban a léptetőmotor fázisban kell lennie. A Klipper'végállás fázis rendszere a végállás pontosságának javítása érdekében kombinálja a léptető fázist a végállás kioldójával.

Ahhoz, hogy ezt a funkciót használni lehessen, azonosítani kell a léptetőmotor fázisát. Ha a Trinamic TMC2130, TMC2208, TMC2224 vagy TMC2660 meghajtókat futásidejű konfigurációs módban használja (azaz nem önálló módban), akkor a Klipper le tudja kérdezni a léptetőmotor fázisát a meghajtóból. (Ez a rendszer hagyományos léptető meghajtókon is használható, ha megbízhatóan vissza lehet állítani a léptető meghajtókat - a részleteket lásd alább.)

## Végállási fázisok kalibrálása

Ha Trinamic léptetőmotor-meghajtókat használunk futásidejű konfigurációval, akkor az ENDSTOP_PHASE_CALIBRATE paranccsal kalibrálhatjuk a végállási fázisokat. Kezdje a következők hozzáadásával a konfigurációs fájlhoz:

```
[endstop_phase]
```

Ezután indítsa újra a nyomtatót, és futtasson egy `G28` parancsot, amelyet egy `ENDSTOP_PHASE_CALIBRATE` parancs követ. Ezután mozgassa a nyomtatófejet egy új helyre, és futtassa újra a `G28` parancsot. Próbálja meg a nyomtatófejet több különböző helyre mozgatni, és minden egyes pozícióból futtassa újra a `G28` parancsot. Futtasson legalább öt `G28` parancsot.

A fentiek elvégzése után a `ENDSTOP_PHASE_CALIBRATE` parancs gyakran ugyanazt (vagy közel ugyanazt) a fázist fogja jelenteni a léptető számára. Ezt a fázist el lehet menteni a konfigurációs fájlban, hogy a jövőben minden G28 parancs ezt a fázist használja. (Így a jövőbeni kezdőpont kérési műveletek során a Klipper ugyanazt a pozíciót fogja elérni, még akkor is, ha a végállás egy kicsit korábban vagy egy kicsit később lép működésbe.)

Egy adott léptetőmotor végállási fázisának elmentéséhez futtasson valami hasonlót, mint a következő:

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Futtassa a fenti lépéseket az összes menteni kívánt léptetőre. Általában ezt a stepper_z-nél használjuk cartesian és corexy-nyomtatókhoz, illetve stepper_a, stepper_b és stepper_c-hez delta nyomtatókhoz. Végül futtassa a következőt a konfigurációs fájl frissítéséhez az adatokkal:

```
SAVE_CONFIG
```

### További megjegyzések

* Ez a funkció a leghasznosabb a delta nyomtatókon és a cartesian/corexy nyomtatók Z végpontján. A funkciót a cartesian nyomtatók XY végállásainál is lehet használni, de ez nem túl hasznos, mivel az X/Y végállás pozíciójának kisebb hibája valószínűleg nem befolyásolja a nyomtatás minőségét. Nem érvényes ezt a funkciót a corexy nyomtatók XY végállásainál használni (mivel az XY pozíciót nem egyetlen léptető határozza meg a corexy kinematikánál). Nem érvényes ezt a funkciót olyan nyomtatókon használni, amelyek "probe:z_virtual_endstop" Z végállást használnak (mivel a léptetőfázis csak akkor stabil, ha a végállás egy sín statikus helyén van).
* A végállásfázis kalibrálása után, ha a végállást később elmozdítják vagy beállítják, akkor a végállást újra kell kalibrálni. Távolítsa el a kalibrálási adatokat a konfigurációs fájlból, és futtassa újra a fenti lépéseket.
* A rendszer használatához a végállásnak elég pontosnak kell lennie ahhoz, hogy a léptető pozícióját két "teljes lépésen" belül azonosítsa. Így például, ha egy léptető 16 mikrolépést használ 0,005 mm-es lépésközzel, akkor a végállásnak legalább 0,160 mm-es pontossággal kell rendelkeznie. Ha a "Endstop stepper_z incorrect phase" típusú hibaüzeneteket kapunk, akkor ez egy nem kellően pontos végállás miatt lehet. Ha az újrakalibrálás nem segít, akkor tiltsa le az endstop fázisbeállítását a konfigurációs fájlból való eltávolítással.
* Ha valaki hagyományos léptető vezérlésű Z tengelyt használ (mint egy cartesian vagy corexy nyomtatón) hagyományos ágykiegyenlítő csavarokkal együtt, akkor az is lehetséges, hogy ezt a rendszert úgy használja, hogy minden egyes nyomtatási réteget egy "teljes lépés" határon végezzen el. Ennek a funkciónak az engedélyezéséhez győződjön meg arról, hogy a G-kód szeletelő olyan rétegmagassággal van konfigurálva, amely a "teljes lépés" többszöröse, manuálisan engedélyezze az endstop_align_zero opciót az endstop_phase config szakaszban (további részletekért lásd [config reference](Config_Reference.md#endstop_phase)), majd szintezze újra az ágy csavarjait.
* Ez a rendszer hagyományos (nem Trinamic) léptetőmotor-meghajtókkal is használható. Ehhez azonban gondoskodni kell arról, hogy a léptetőmotor-meghajtók a mikrokontroller minden egyes resetelésekor újrainduljanak. (Ha a kettő mindig együtt van resetelve, akkor a Klipper a léptető fázisát úgy tudja meghatározni, hogy nyomon követi a léptetőnek adott parancsok teljes lépésszámát). Jelenleg ez csak akkor lehetséges megbízhatóan, ha mind a mikrokontroller, mind a léptetőmotor-meghajtók kizárólag USB-ről kapnak áramot, és az USB-ről egy Raspberry Pi-n futó hostról kapjuk az áramot. Ebben a helyzetben meg lehet adni egy MCU konfigurációt a "restart_method: rpi_usb" - ez az opció gondoskodik arról, hogy a mikrokontrollert mindig USB tápellátás-visszaállítással állítsák vissza, ami gondoskodik arról, hogy a mikrokontroller és a léptetőmotor-illesztőprogramok együtt álljanak vissza. Ha ezt a mechanizmust használjuk, akkor manuálisan kell konfigurálni a "trigger_phase" konfigurációs szakaszokat (a részleteket lásd [config reference](Config_Reference.md#endstop_phase)).
