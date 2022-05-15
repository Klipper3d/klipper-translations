# Protokoll

A Klipper üzenetküldő protokoll a Klipper gazdagép szoftver és a Klipper mikrovezérlő szoftver közötti alacsony szintű kommunikációra szolgál. Magas szinten a protokoll felfogható parancs és válaszkarakterláncok sorozatának, amelyeket tömörítenek, továbbítanak, majd feldolgoznak a fogadó oldalon. Egy példa parancssorozat tömörítetlen, ember által olvasható formátumban így nézhet ki:

```
set_digital_out pin=PA3 value=1
set_digital_out pin=PA7 value=1
schedule_digital_out oid=8 clock=4000000 value=0
queue_step oid=7 interval=7458 count=10 add=331
queue_step oid=7 interval=11717 count=4 add=1281
```

Az elérhető parancsokról az [mcu parancsok](MCU_Commands.md) dokumentumban olvashat bővebben. Tekintse meg a [hibakeresés](Debugging.md) dokumentumot a G-kód fájl megfelelő, ember által olvasható mikrovezérlő parancsaira történő lefordításával kapcsolatban.

Ez az oldal magának a Klipper üzenetküldő protokollnak a magas szintű leírását tartalmazza. Leírja az üzenetek deklarálását, bináris formátumú kódolását (a séma "tömörítését") és továbbítását.

A protokoll célja, hogy hibamentes kommunikációs csatornát tegyen lehetővé a gazdagép és a mikrovezérlő között, amely alacsony késleltetésű, alacsony sávszélességű és alacsony bonyolultságú a mikrovezérlő számára.

## Mikrovezérlő interfész

A Klipper átviteli protokoll egy [RPC](https://hu.wikipedia.org/wiki/Remote_procedure_call) mechanizmusnak tekinthető a mikrovezérlő és a gazdagép között. A mikrovezérlő szoftver deklarálja azokat a parancsokat, amelyeket a gazdagép meghívhat, az általa generált válaszüzenetekkel együtt. A gazdagép ezeket az információkat arra használja fel, hogy parancsot adjon a mikrokontrollernek a műveletek végrehajtására és az eredmények értelmezésére.

### Parancsok deklarálása

A mikrokontroller szoftvere deklarál egy "parancsot" a DECL_COMMAND() makró használatával a C kódban. Például:

```
DECL_COMMAND(command_update_digital_out, "update_digital_out oid=%c value=%c");
```

A fenti egy "update_digital_out" nevű parancsot deklarál. Ez lehetővé teszi a gazdagép számára, hogy ezt a parancsot "invoke", ami a command_update_digital_out() C függvény végrehajtását eredményezi a mikrovezérlőben. A fentiek azt is jelzik, hogy a parancs két egész paramétert vesz fel. A command_update_digital_out() C kód végrehajtásakor egy tömb kerül átadásra, amely ezt a két egész számot tartalmazza. Az első az 'oid'-nak, a második a 'value'-nak felel meg.

Általában a paraméterek leírása printf() stílusú szintaxissal történik (pl. "%u"). A formázás közvetlenül megfelel a parancsok ember által olvasható nézetének (pl. "update_digital_out oid=7 value=1"). A fenti példában a "value=" a paraméter neve, a "%c" pedig azt jelzi, hogy a paraméter egész szám. Belsőleg a paraméternév csak dokumentációként használatos. Ebben a példában a "%c" is használható dokumentációként, amely jelzi, hogy a várt egész szám 1 bájt méretű (a deklarált egész szám nem befolyásolja az elemzést vagy a kódolást).

A mikrovezérlő szerkesztő összegyűjti a DECL_COMMAND()-al deklarált összes parancsot, meghatározza azok paramétereit, és gondoskodik a meghívásukról.

### Válaszok deklarálása

A mikrovezérlőtől a gazdagépnek történő információ küldéséhez "válasz" jön létre. Ezek deklarálása és továbbítása a sendf() C makró használatával történik. Például:

```
sendf("status clock=%u status=%c", sched_read_time(), sched_is_shutdown());
```

A fenti egy "állapot" válaszüzenetet küld, amely két egész paramétert ("óra" és "állapot") tartalmaz. A mikrovezérlő szerkesztő automatikusan megtalálja az összes sendf() hívást, és kódolókat generál hozzájuk. A sendf() függvény első paramétere írja le a választ, és formátuma megegyezik a parancsdeklarációkkal.

A gazdagép gondoskodhat arról, hogy minden válaszhoz visszahívási funkciót regisztráljon. Tehát valójában a parancsok lehetővé teszik a gazdagép számára, hogy meghívja a C függvényeket a mikrovezérlőben, a válaszok pedig lehetővé teszik, hogy a mikrovezérlő szoftvere kódot hívjon meg a gazdagépben.

A sendf() makró csak parancs vagy feladatkezelőkből hívható meg, és nem hívható meg megszakításokból vagy időzítőkből. A kódnak nem kell sendf()-t kiadnia a kapott parancsra válaszul, nincs korlátozva a sendf() meghívásának száma, és a sendf()-t bármikor meghívhatja egy feladatkezelőből.

#### Kimeneti válaszok

A hibakeresés egyszerűsítése érdekében van egy output() C függvény is. Például:

```
output("The value of %u is %s with size %u.", x, buf, buf_len);
```

Az output() függvény a printf() függvényhez hasonlóan használható. Célja tetszőleges üzenetek generálása és formázása emberi feldolgozásra.

### Felsorolások deklarálása

A felsorolások lehetővé teszik a gazdakód számára, hogy a mikrokontroller által egész számokként kezelt paraméterekhez karakterlánc-azonosítókat használjon. Ezeket a mikrokontroller kódjában kell deklarálni - például:

```
DECL_ENUMERATION("spi_bus", "spi", 0);

DECL_ENUMERATION_RANGE("pin", "PC0", 16, 8);
```

Ha az első példában a DECL_ENUMERATION() makró felsorolást definiál minden olyan parancs/válasz üzenethez, amelynek paraméterneve "spi_bus" vagy "_spi_bus" utótaggal rendelkezik. E paraméterek esetében az "SPI" karakterlánc érvényes érték, és nullás egész számértékkel kerül továbbításra.

Lehetőség van felsorolási tartomány kijelölésére is. A második példában egy "pin" paraméter (vagy bármely paraméter, amelynek utótagja "_pin") elfogadná a PC0, PC1, PC2, ..., PC7 értékeket. A karakterláncokat a 16, 17, 18, ..., ..., 23 egész számokkal kell továbbítani.

### Állandók deklarálása

A konstansok is exportálhatók. Például a következőképp:

```
DECL_CONSTANT("SERIAL_BAUD", 250000);
```

egy "SERIAL_BAUD" nevű, 250000 értékű konstanst exportálna a mikrokontrollerből a gazdagépre. Lehetőség van olyan konstans deklarálására is, amely egy karakterlánc - például:

```
DECL_CONSTANT_STR("MCU", "pru");
```

## Alacsony szintű üzenetkódolás

A fenti RPC-mechanizmus megvalósításához minden egyes parancs és válasz bináris formátumba van kódolva az átvitelhez. Ez a szakasz az átviteli rendszert írja le.

### Üzenetblokkok

A gazdagéptől a mikrovezérlőnek és fordítva küldött összes adat "üzenetblokkban" található. Az üzenetblokk két bájtos fejléccel és három bájtos üzenettel rendelkezik. Az üzenetblokkok formátuma a következő:

```
<1 byte length><1 byte sequence><n-byte content><2 byte crc><1 byte sync>
```

A hosszbájt tartalmazza az üzenetblokkban lévő bájtok számát, beleértve a fejlécet és a követőbájtokat (így az üzenet minimális hossza 5 bájt). Az üzenetblokk maximális hossza jelenleg 64 bájt. A szekvencia bájt egy 4 bites szekvencia számot tartalmaz az alacsony rendű bitekben, a magas rendű bitek pedig mindig 0x10-et tartalmaznak (a magas rendű bitek későbbi használatra vannak fenntartva). A tartalmi bájtok tetszőleges adatokat tartalmaznak, és formátumukat a következő szakasz ismerteti. A crc bájtok tartalmazzák az üzenetblokk 16 bites CCITT [CRC](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) értékét, beleértve a fejlécbájtokat, de kivéve az üzenetbájtokat. A szinkronizálási bájt 0x7e.

Az üzenetblokk formátumát a [HDLC](https://en.wikipedia.org/wiki/High-Level_Data_Link_Control) üzenetkeretek ihlették. A HDLC-hez hasonlóan az üzenetblokk opcionálisan tartalmazhat egy további szinkronizálási karaktert a blokk elején. A HDLC-vel ellentétben a szinkronizálási karakter nem kizárólagos a keretben, és jelen lehet az üzenetblokk tartalmában.

### Üzenetblokk tartalma

Minden egyes, a gazdagépről a mikrokontrollernek küldött üzenetblokk tartalma nulla vagy több üzenetparancsból álló sorozatot tartalmaz. Minden parancs egy [Változó hosszúságú mennyiség](#valtozo-hosszusagu-mennyiseg) (VLQ) kódolt egész számú parancs azonosítóval kezdődik, amelyet az adott parancsra vonatkozó nulla vagy több VLQ paraméter követ.

A következő négy parancsot például egyetlen üzenetblokkba helyezhetjük:

```
update_digital_out oid=6 value=1
update_digital_out oid=5 value=0
get_config
get_clock
```

és a következő nyolc VLQ egész számba kódolva:

```
<id_update_digital_out><6><1><id_update_digital_out><5><0><id_get_config><id_get_clock>
```

Az üzenet tartalmának kódolásához és elemzéséhez a gazdagépnek és a mikrokontrollernek meg kell egyeznie a parancs azonosítóiban és az egyes parancsok paramétereinek számában. Így a fenti példában mind a gazdagép, mind a mikrokontroller tudja, hogy az "id_update_digital_out" parancsot mindig két paraméter követi, és az "id_get_config" és a "id_get_clock" parancsnak nulla paramétere van. A gazdagép és a mikrokontroller megosztja az "adatszótárat", amely a parancsleírásokat (pl. "update_digital_out oid=%c value=%c") egész számú parancs-azonosítókra képezi le. Az adatok feldolgozása során az elemző tudni fogja, hogy egy adott parancs-id után meghatározott számú VLQ-kódolt paramétert várjon.

A mikrokontrollerről a gazdagépnek küldött blokkok üzenettartalma ugyanezt a formátumot követi. Ezekben az üzenetekben szereplő azonosítók "válasz azonosítók", de ugyanazt a célt szolgálják és ugyanazokat a kódolási szabályokat követik. A gyakorlatban a mikrokontrollerről a gazdagépnek küldött üzenetblokkok soha nem tartalmaznak egynél több választ az üzenetblokk tartalmában.

#### Változó hosszúságú mennyiségek

A VLQ kódolt egész számok általános formátumáról lásd a [wikipedia cikket](https://en.wikipedia.org/wiki/Variable-length_quantity). A Klipper olyan kódolási sémát használ, amely támogatja a pozitív és negatív egész számokat is. A nullához közeli egészek kevesebb bájtot használnak a kódoláshoz, és a pozitív egészek kódolása általában kevesebb bájtot használ, mint a negatív egészeké. A következő táblázat mutatja, hogy az egyes egész számok kódolásához hány bájtra van szükség:

| Egész | Kódolt méret |
| --- | --- |
| -32 .. 95 | 1 |
| -4096 .. 12287 | 2 |
| -524288 .. 1572863 | 3 |
| -67108864 .. 201326591 | 4 |
| -2147483648 .. 4294967295 | 5 |

#### Változó hosszúságú karakterláncok

A fenti kódolási szabályok alóli kivételként, ha egy parancs vagy válasz paramétere dinamikus karakterlánc, akkor a paraméter nem egyszerű VLQ egész számként kódolódik. Ehelyett a kódolás úgy történik, hogy a hosszt VLQ kódolt egész számként továbbítják, amelyet maga a tartalom követ:

```
<VLQ encoded length><n-byte contents>
```

Az adatszótárban található parancsleírások lehetővé teszik a gazdagép és a mikrokontroller számára, hogy tudja, mely parancsparaméterek használnak egyszerű VLQ kódolást, és mely paraméterek string kódolást.

## Adatszótár

Ahhoz, hogy a mikrokontroller és a gazdagép között értelmes kommunikáció jöjjön létre, mindkét félnek meg kell állapodnia egy "adatszótárban". Ez az adatszótár tartalmazza a parancsok és válaszok egészértékű azonosítóit és azok leírását.

A mikrokontroller buildje a DECL_COMMAND() és sendf() makrók tartalmát használja az adatszótár létrehozásához. A build automatikusan egyedi azonosítókat rendel minden parancshoz és válaszhoz. Ez a rendszer lehetővé teszi, hogy a gazdagép, és a mikrokontroller kódja zökkenőmentesen használjon leíró, ember által olvasható neveket, miközben minimális sávszélességet használ.

A gazdagép lekérdezi az adatszótárat, amikor először csatlakozik a mikrokontrollerhez. Amint ez megtörtént az adatszótárat használja az összes parancs kódolására és a mikrokontroller összes válaszának elemzésére. A gazdagépnek tehát dinamikus adatszótárat kell kezelnie. A mikrokontroller szoftverének egyszerűségének megőrzése érdekében azonban a mikrokontroller mindig a statikus (befordított) adatszótárát használja.

Az adatszótárat a mikrokontrollerhez küldött "azonosító" parancsok segítségével lehet lekérdezni. A mikrokontroller minden egyes azonosító parancsra egy "identify_response" üzenettel válaszol. Mivel erre a két parancsra az adatszótár lekérdezése előtt van szükség, az egész számok azonosítói és a paramétertípusok mind a mikrokontrollerben, mind a gazdagépben szorosan kódolva vannak. Az "identify_response" válasz azonosítója 0, az "azonosító" parancs azonosítója 1. A keményen kódolt azonosítókon kívül az azonosító parancs és válasz ugyanúgy kerül deklarálásra és továbbításra, mint a többi parancs és válasz. Egyetlen más parancs vagy válasz sincs szorosan kódolva.

A továbbított adatszótár formátuma egy zlib tömörített JSON karakterlánc. A mikrokontroller építési folyamata létrehozza a karakterláncot, tömöríti, és a mikrokontroller flash-jének szöveges részében tárolja. Az adatszótár jóval nagyobb lehet, mint a maximális üzenetblokk mérete. A gazdagép úgy tölti le, hogy több azonosító parancsot küld, amelyek az adatszótár progresszív darabjait kérik. Ha az összes darabot megkapta, a gazdagép összeállítja a darabokat, kitömöríti az adatokat, és elemzi a tartalmukat.

A kommunikációs protokollra vonatkozó információkon kívül az adatszótár tartalmazza a szoftver verzióját, a (DECL_ENUMERATION által meghatározott) felsorolásokat és a (DECL_CONSTANT által meghatározott) konstansokat is.

## Üzenetáramlás

A gazdagépről a mikrokontrollerhez küldött üzenetparancsok hibátlanok. A mikrokontroller ellenőrzi a CRC-t és a sorszámokat minden egyes üzenetblokkban, hogy biztosítsa a parancsok pontosságát és sorrendiségét. A mikrokontroller mindig sorrendben dolgozza fel az üzenetblokkokat. Ha a sorrendtől eltérő blokkot kap, akkor azt és a többi sorrendtől eltérő blokkot is elveti, míg helyes sorrendű blokkokat nem kap.

Az alacsony szintű gazdagép kód egy automatikus újraküldési rendszert valósít meg a mikrokontrollerhez küldött elveszett és hibás üzenetblokkok esetében. Ennek megkönnyítése érdekében a mikrokontroller minden egyes sikeresen fogadott üzenetblokk után egy "ack üzenetblokkot" küld. Az állomás minden egyes blokk elküldése után időkorlátot állít be, és ha az időkorlát lejár anélkül, hogy a megfelelő "ack" üzenetet megkapta volna, akkor újraküldi. Ezen túlmenően, ha a mikrokontroller hibás vagy rendellenes blokkot észlel, a gyors újraküldés megkönnyítése érdekében egy "nak üzenetblokkot" küldhet.

Az "ack" egy üres tartalmú (azaz 5 bájtos) üzenetblokk, amelynek sorszáma nagyobb, mint az utolsó fogadott gazdagép sorszáma. A "nak" egy üres tartalmú üzenetblokk, amelynek sorszáma kisebb, mint az utolsó fogadott gazdagép sorszáma.

A protokoll megkönnyíti az "ablakos" átviteli rendszert, így a fogadó egyszerre több függőben lévő üzenetblokkal rendelkezhet. (Ez azon a sok parancson kívül, amelyek egy adott üzenetblokkban jelen lehetnek.) Ez lehetővé teszi a sávszélesség maximális kihasználását még átviteli késedelem esetén is. Az időkorlátozás, az újraküldés, az ablakozás és az ack mechanizmus a [TCP](https://hu.wikipedia.org/wiki/Transmission_Control_Protocol) hasonló mechanizmusai alapján készült.

A másik irányban a mikrokontrollerről a gazdagéphez küldött üzenetblokkokat úgy tervezték, hogy hibamentesek legyenek, de nincs biztosított átvitelük. (A válaszok nem lehetnek hibásak, de előfordulhat, hogy eltűnnek.) Ez azért történik, hogy a mikrokontrollerben egyszerű legyen a megvalósítás. Nincs automatikus újraküldési rendszer a válaszok számára. A magas szintű kódtól elvárható, hogy képes legyen kezelni az esetenként hiányzó válaszokat (általában a tartalom újrakérdezésével vagy a válaszküldés ismétlődő ütemezésének beállításával). Az állomásnak küldött üzenetblokkok sorszámmezője mindig eggyel nagyobb, mint az utolsó, az állomásról kapott üzenetblokkok sorszáma. Nem a válaszüzenetblokkok sorrendjének nyomon követésére szolgál.
