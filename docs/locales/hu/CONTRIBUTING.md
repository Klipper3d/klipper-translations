# Hozzájárulás a Klipperhez

Köszönjük, hogy hozzájárult a Klipperhez! Ez a dokumentum leírja a Klipper változtatásokhoz való hozzájárulás folyamatát.

Kérjük, tekintse meg a [kapcsolat oldal](Contact.md) oldalt a probléma bejelentésével kapcsolatos információkért vagy a fejlesztőkkel való kapcsolatfelvételre vonatkozó részletekért.

## A hozzájárulási folyamat áttekintése

A Klipperhez való hozzájárulás általában egy magas szintű folyamatot követ:

1. A benyújtó egy [GitHub Pull Request](https://github.com/Klipper3d/klipper/pulls) létrehozásával kezdi, amikor egy beadvány készen áll a széles körű telepítésre.
1. Amikor egy [bíráló](#reviewers) elérhető a [review](#what-to-expect-in-a-review) benyújtásához, akkor hozzárendeli magát a Pull Requesthez a GitHubon. A felülvizsgálat célja a hibák keresése és annak ellenőrzése, hogy a beadvány követi-e a dokumentált irányelveket.
1. Sikeres felülvizsgálat után a felülvizsgáló "jóváhagyja a felülvizsgálatot" a GitHubon, és egy [karbantartó](#reviewers) átvezeti a módosítást a Klipper master ágába.

Ha fejlesztéseken dolgozol, fontold meg egy téma indítását (vagy a témához való hozzájárulást) a [Klipper Discourse](Contact.md) oldalon. A fórumon folyó vita javíthatja a fejlesztési munka láthatóságát, és vonzhat másokat is, akik érdeklődnek az új munka tesztelése iránt.

## Mire számíthatunk egy felülvizsgálat során

A Klipperhez való hozzájárulásokat az egyesítés előtt felülvizsgálják. A felülvizsgálati folyamat elsődleges célja a hibák ellenőrzése, valamint annak ellenőrzése, hogy a beadvány megfelel-e a Klipper dokumentációjában meghatározott irányelveknek.

Természetesen egy feladatot sokféleképpen lehet elvégezni; a felülvizsgálat célja nem az, hogy megvitassa a "legjobb" végrehajtást. Ahol lehetséges, a felülvizsgálati megbeszélések inkább a tényekre és a mérésekre összpontosítanak.

A beadványok többsége visszajelzést eredményez egy felülvizsgálatról. Készüljön fel a visszajelzések beszerzésére, további részletek megadására és szükség esetén a beadvány frissítésére.

Gyakori dolgok, amiket a bíráló keres:


   1. Hibátlan-e a beadvány, és készen áll-e a széles körű bevezetésre?A benyújtóknak a benyújtás előtt tesztelniük kell a változtatásokat. A bírálók keresik a hibákat, de általában nem tesztelik a beküldött anyagokat. Egy elfogadott beadványt gyakran az elfogadást követő néhány héten belül több ezer nyomtatóhoz juttatnak el. A beadványok minőségét ezért prioritásnak tekintik.

   A fő [Klipper3d/klipper](https://github.com/Klipper3d/klipper) GitHub tároló nem fogad el kísérleti munkát. A beküldőknek a kísérletezést, hibakeresést és tesztelést a saját tárolójukban kell elvégezniük. A [Klipper Discourse](Contact.md) szerver jó hely arra, hogy felhívjuk a figyelmet az új munkára, és megtaláljuk azokat a felhasználókat, akiket érdekel a valós visszajelzés.

   A beadványoknak át kell menniük az összes [regressziós teszteseten](Debugging.md).

   A beküldött kódok nem tartalmazhatnak túlzottan sok hibakeresési kódot, hibakeresési opciót vagy futásidejű hibakeresési naplózást.

   A kódbeadványokhoz fűzött megjegyzéseknek a kód karbantartásának javítására kell összpontosítaniuk. A beadványok nem tartalmazhatnak "kikommentált kódot" vagy túlzottan sok, korábbi megvalósításokat leíró megjegyzést. Nem lehetnek túlzott mértékű "todo" megjegyzések.

   A dokumentáció frissítései nem jelenthetik ki, hogy azok "folyamatban lévő munkák".

   1. A beadott pályázat "nagy hatású" előnyt jelent-e a valós felhasználók számára, akik valós feladatokat látnak el?A bírálóknak - legalábbis a saját fejükben - nagyjából meg kell határozniuk, hogy "ki a célközönség", hogy "mekkora a célközönség", hogy "milyen előnyökhöz" jutnak, hogy "az előnyöket hogyan mérik", és hogy "milyen eredményeket hoznak ezek a mérési tesztek". A legtöbb esetben ez mind a benyújtó, mind a bíráló számára nyilvánvaló, és a bírálat során nem kerül kifejezett kijelentésre.

   A mester Klipper ágba küldött beadványok várhatóan figyelemre méltó célközönséggel rendelkeznek. Általános "ökölszabályként" a beadványoknak legalább 100 valós felhasználóból álló felhasználói bázist kell megcélozniuk.

   Ha egy bíráló részleteket kér egy beadvány "hasznáról", kérjük, ne tekintse ezt kritikának. Az, hogy képesek legyünk megérteni egy változtatás valós előnyeit, a felülvizsgálat természetes része.

   Az előnyök megvitatásakor előnyösebb a "tények és mérések" megvitatása. Általában véve a bírálók nem a "valaki hasznosnak találhatja az X opciót", sem pedig a "ez a beadvány olyan funkciót ad hozzá, amelyet az X firmware valósít meg" formájú válaszokat keresik. Ehelyett általában előnyösebb, ha részletesen tárgyalják, hogy a minőségjavulást hogyan mérték, és milyen eredményeket hoztak ezek a mérések - például: "az Acme X1000 nyomtatókon végzett tesztek a ...képen látható javuló sarkokat mutatnak ", vagy például "az X valós tárgy nyomtatási ideje egy Foomatic X900 nyomtatón 4 óráról 3,5 órára csökkent". Magától értetődik, hogy az ilyen típusú tesztelés jelentős időt és erőfeszítést igényel. A Klipper legjelentősebb funkcióinak némelyike hónapokig tartott a megbeszélések, átdolgozások, tesztelések és dokumentációk során, mielőtt beolvadt a master ágba.

   Minden új modulnak, konfigurációs opciónak, parancsnak, parancsparaméternek és dokumentumnak "nagy hatással" kell rendelkeznie. Nem akarjuk a felhasználókat olyan opciókkal terhelni, amelyeket nem tudnak ésszerűen konfigurálni, és nem akarjuk őket olyan opciókkal terhelni, amelyek nem nyújtanak számottevő előnyt.

   A bíráló kérhet pontosítást arról, hogy a felhasználónak hogyan kell beállítania egy opciót - az ideális válasz tartalmazza a folyamat részleteit - például: "a MegaX500 felhasználóinak az X opciót 99,3-ra kell beállítaniuk, míg az Elite100Y felhasználóinak az X opciót a ..." eljárással kell kalibrálniuk...".

   Ha az opció célja, hogy a kódot modulárisabbá tegye, akkor inkább használjon kódkonstansokat a felhasználóval szembenéző konfigurációs opciók helyett.

   Az új modulok, új opciók és új paraméterek nem biztosíthatnak hasonló funkciókat a meglévő modulokhoz - ha a különbségek önkényesek, akkor inkább a meglévő rendszert kell használni, vagy a meglévő kódot kell átalakítani.

   1. A beadvány szerzői joga egyértelmű, nem hálapénz és összeegyeztethető?Az új C és Python fájloknak egyértelmű szerzői jogi nyilatkozatot kell tartalmazniuk. Az előnyben részesített formátumot lásd a meglévő fájlokban. A meglévő fájl szerzői jogának deklarálása a fájl kisebb módosításai esetén elhanyagolható.

   A harmadik féltől származó kódnak kompatibilisnek kell lennie a Klipper licenszel (GNU GPLv3). A nagyobb, harmadik féltől származó kódkiegészítéseket a `lib/` könyvtárba kell helyezni (és a [lib/README](../lib/README) könyvtárban leírt formátumot kell követni).

   A beküldőknek meg kell adniuk egy [Signed-off-by line](#format-of-commit-messages) sort a teljes valódi nevükkel. Ez azt jelzi, hogy a benyújtó egyetért a [fejlesztői származási igazolással](developer-certificate-of-origin).

   1. A benyújtás követi a Klipper dokumentációban meghatározott irányelveket?Különösen a kódnak a <Code_Overview.md>, a konfigurációs fájloknak pedig a <Example_Configs.md> című dokumentumban található irányelveket kell követniük.

   1. A Klipper dokumentáció frissítve van az új változásoknak megfelelően?Legalább a referenciadokumentációt kell frissíteni a kód megfelelő változtatásaival:

   * Minden parancsot és parancsparamétert a <G-Codes.md> dokumentumban kell dokumentálni.
   * Minden felhasználó előtt álló modult és azok konfigurációs paramétereit dokumentálni kell a <Config_Reference.md> fájlban.
   * Minden exportált "állapotváltozót" dokumentálni kell <Status_Reference.md>.
   * Minden új "webhooks" és paramétereiket dokumentálni kell <API_Server.md>.
   * Minden olyan módosítás, amely nem visszafelé kompatibilis módosítást hajt végre egy parancs vagy konfigurációs fájl beállításán, dokumentálni kell a <Config_Changes.md> dokumentumban.

Az új dokumentumokat hozzá kell adni az <Overview.md> fájlhoz, és hozzá kell adni a weboldal indexéhez [docs/_klipper3d/mkdocs.yml](../docs/_klipper3d/mkdocs.yml).


   1. A véglegesítések jól megformáltak, véglegesítésként egyetlen témával foglalkoznak, és függetlenek?A kérelmi üzeneteknek a [preferált formátumot](#format-of-commit-messages) kell követniük.

   A kérelmeknek nem lehet összeolvadási konfliktusuk. A Klipper master ágához való új hozzáadások mindig egy "rebase" vagy "squash and rebase" segítségével történnek. A benyújtóknak általában nem szükséges a Klipper főadattár minden egyes frissítésénél újra egyesíteniük a beadványukat. Ha azonban összeolvasztási konfliktus van, akkor a benyújtóknak ajánlott a `git rebase` használata a konfliktus megoldására.

   Minden egyes kérelemnek egyetlen magas szintű változtatással kell foglalkoznia. A nagyobb változtatásokat több független kérelemre kell bontani. Minden commitnak "önállóan kell állnia", hogy az olyan eszközök, mint a `git bisect` és `git revert` megbízhatóan működjenek.

   A fehérterületi változtatásokat nem szabad összekeverni a funkcionális változtatásokkal. Általánosságban elmondható, hogy az indokolatlan szóköz módosításokat nem fogadjuk el, kivéve, ha azok a módosítandó kód megállapított "tulajdonosától" származnak.

A Klipper nem alkalmaz szigorú "kódolási stílus útmutatót", de a meglévő kód módosításainak követniük kell a meglévő kód magas szintű kódáramlását, kódbehúzási stílusát és formátumát. Az új modulok és rendszerek benyújtása esetén a kódolási stílus rugalmasabb, de előnyösebb, ha az új kód belsőleg konzisztens stílust követ, és általában az iparági kódolási normákat követi.

A felülvizsgálat célja nem a "jobb megvalósítások" megvitatása. Ha azonban egy bírálónak nehézséget okoz egy beadott pályázat megvalósításának megértése, akkor kérhet változtatásokat a megvalósítás átláthatóbbá tétele érdekében. Különösen, ha a bírálók nem tudják meggyőzni magukat arról, hogy egy beadott pályázat hibátlan, akkor változtatásokra lehet szükség.

A felülvizsgálat részeként egy felülvizsgáló létrehozhat egy alternatív kérést egy témához. Ezt azért lehet megtenni, hogy elkerülhető legyen a túlzott "oda-vissza" a kisebb eljárási kérdésekben, és így egyszerűsödjön a benyújtási folyamat. Ez azért is megtörténhet, mert a vita arra ösztönzi a bírálót, hogy egy alternatív implementációt készítsen. Mindkét helyzet a felülvizsgálat normális eredménye, és nem tekinthető az eredeti beadvány kritikájának.

### Segítség a felülvizsgálatokban

Nagyra értékeljük a segítséget a véleményekkel kapcsolatban! Nem szükséges [listázott értékelőnek](#reviewers) lenni az értékelés elvégzéséhez. A GitHub kérelmek benyújtóit is arra ösztönözzük, hogy saját beadványaikat vizsgálják felül.

A felülvizsgálat során segítsen, kövesse a [mire számíthat egy felülvizsgálat során](#what-to-expect-in-a-review) pontban leírt lépéseket a beküldés ellenőrzéséhez. A felülvizsgálat befejezése után adjon hozzá egy megjegyzést a GitHub kérésekhez a megállapításokkal. Ha a benyújtás átmegy az ellenőrzésen, akkor kérjük, ezt kifejezetten jelezze a megjegyzésben. Például valami olyasmit, hogy "Átnéztem ezt a módosítást a CONTRIBUTING dokumentumban leírtak szerint, és minden jónak tűnik számomra". Ha nem tudta elvégezni a felülvizsgálat egyes lépéseit, akkor kérjük, kifejezetten jelezze, hogy mely lépéseket vizsgálta felül, és melyeket nem. Például valami olyasmit, mint: "Nem ellenőriztem a kódot hibák szempontjából, de minden mást átnéztem a CONTRIBUTING dokumentumban, és úgy tűnik, hogy minden rendben van".

A beadványok tesztelését is értékeljük. Ha a kódot teszteltük, kérjük írjon egy megjegyzést a GitHub kérésekhez a tesztelés eredményével - sikerrel vagy sikertelenséggel. Kérjük, kifejezetten jelezze, hogy a kódot tesztelték, és az eredményeket - például valami olyasmit, mint: "Leteszteltem ezt a kódot az Acme900Z nyomtatómon egy váza nyomtatásával, és az eredmények jók voltak".

### Értékelők

A Klipper "értékelők" a következők:

| Név | GitHub azonosító | Érdeklődési körök |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | Bemenetformálás, rezonancia vizsgálat, kinematika |
| Eric Callahan | @Arksine | Tárgyasztal szintezése, MCU égetés |
| Kevin O'Connor | @KevinOConnor | Mag mozgási rendszer, mikrokontroller kód |
| Paul McGowan | @mental405 | Konfigurációs fájlok, dokumentáció |

Kérjük, ne "pingelje" a bírálókat, és ne küldjön beadványokat nekik. Az összes bíráló figyelemmel kíséri a fórumokat és a PR-eket, és ha van idejük, akkor vállalják a bírálatokat.

A Klipper "karbantartók" a következők:

| Név | GitHub név |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## A megbízási üzenetek formátuma

Minden megbízásnak a következőhöz hasonlóan formázott üzenetet kell tartalmaznia:

```
modul: Nagybetűs, rövid (legfeljebb 50 karakteres) összefoglaló.

Szükség esetén részletesebb magyarázó szöveg.  Körülbelül 75
karakter.  Bizonyos kontextusokban az első sort úgy kezelik, mint a
az e-mail tárgya, a szöveg többi részét pedig szövegtestként.  Az üres
sor, amely elválasztja az összefoglalót a szövegtesttől, kritikus (kivéve, ha kihagyja a
a törzsszöveget teljesen); az olyan eszközök, mint a rebase, összezavarodhatnak, ha a
a kettőt együtt futtatják.

Az üres sorok után további bekezdések következnek..

Aláírás: Név <myemail@example.org>
```

A fenti példában `module` egy fájl vagy könyvtár neve kell, hogy legyen a tárolóban (fájlkiterjesztés nélkül). Például `clocksync: Javítsuk ki a pause() hívásban lévő elírást a csatlakozás idején`. A modulnév megadásának célja a kérelmi üzenetben az, hogy segítsen kontextust biztosítani a kérelmi megjegyzésekhez.

Fontos, hogy minden kérésnél legyen egy "Signed-off-by" sor. Ez igazolja, hogy egyetértesz a [fejlesztői eredetigazolással](developer-certificate-of-origin). Tartalmaznia kell a valódi nevét (sajnálom, nincs álnév vagy névtelen hozzájárulás), és tartalmaznia kell egy aktuális e-mail címet.

## Hozzájárulás a Klipper Fordításokhoz

[Klipper-fordítási Projekt](https://github.com/Klipper3d/klipper-translations) egy olyan projekt, amely a Klipper különböző nyelvekre való fordítását tűzte ki célul. A [Weblate](https://hosted.weblate.org/projects/klipper/) az összes Gettext stringet tárolja a fordításhoz és felülvizsgálathoz. A [klipper3d.org](https://www.klipper3d.org) oldalon megjeleníthetők a helyi nyelvek, ha megfelelnek a következő követelményeknek:

- [ ] 75% Teljes lefedettség
- [ ] Minden cím (H1) le van fordítva
- [ ] Egy frissített navigációs hierarchia PR a klipper-fordításokban.

A domain-specifikus kifejezések fordításával járó frusztráció csökkentése és a folyamatban lévő fordítások megismerése érdekében küldhet PR-t, amely módosítja a [Klipper-fordítási Projekt](https://github.com/Klipper3d/klipper-translations) `readme.md` fájlt. Amint a fordítás elkészült, a Klipper-projekt megfelelő módosítása elvégezhető.

Ha egy fordítás már létezik a Klipper adattárban, és már nem felel meg a fenti ellenőrző listának, akkor egy hónap után frissítés nélkül elavultnak lesz jelölve.

Ha a követelmények teljesülnek, akkor:

1. klipper-fordítási adattár frissítése [active_translations](https://github.com/Klipper3d/klipper-translations/blob/translations/active_translations)
1. Opcionális: adjunk hozzá egy manual-index.md fájlt a klipper-translations repository's `docs\locals\<lang>` mappába a nyelvspecifikus index.md helyett (a generált index.md nem renderelhető helyesen).

Ismert problémák:

1. Jelenleg a dokumentációban nincs módszer a képek helyes fordítására
1. Az mkdocs.yml-ben nem lehet címeket fordítani.
