# Kapcsolat

Ez a dokumentum a Klipper csapatának elérhetőségét tartalmazza.

1. [Közösségi Fórum](#kozossegi-forum)
1. [Discord Csevegés](#discord-cseveges)
1. [Kérdésem van a Klipperrel kapcsolatban](#kerdesem-van-a-klipperrel-kapcsolatban)
1. [Van egy funkciókérelmem](#van-egy-funkciokerelmem)
1. [Segítség! Nem működik!](#segitseg-nem-mukodik)
1. [Hibát diagnosztizáltam a Klipper szoftverben](#hibat-diagnosztizaltam-a-klipper-szoftverben)
1. [Változtatásokat végzek, amelyeket szeretnék a Klipperbe beépíteni](#valtoztatasokat-vegzek-amelyeket-szeretnek-a-klipperbe-beepiteni)

## Közösségi Fórum

Van egy [Klipper Közösségi Társalgó szerver](https://community.klipper3d.org) a Klipperrel kapcsolatos beszélgetésekhez.

## Discord Csevegés

Van egy Klippernek szentelt Discord szerver a következő címen: <https://discord.klipper3d.org>.

Ezt a szervert egy Klipper-rajongókból álló közösség működteti, amely a Klipperrel kapcsolatos vitáknak szenteli magát. Lehetővé teszi a felhasználók számára, hogy valós időben csevegjenek más felhasználókkal.

## Kérdésem van a Klipperrel kapcsolatban

Sok kérdésre már választ kaptunk a [Klipper dokumentációban](Overview.md). Kérjük, mindenképpen olvasd el a dokumentációt és kövesd az ott megadott utasításokat.

Lehetőség van hasonló kérdések keresésére a [Klipper Közösségi Fórum](#kozossegi-forum) oldalon is.

Ha szeretnéd megosztani tudásodat és tapasztalataidat más Klipper felhasználókkal, akkor csatlakozhatsz a [Klipper Közösségi Fórum](#kozossegi-forum) vagy a [Discord Csevegés](#discord-cseveges)-hez. Mindkettő olyan közösség, ahol a Klipper felhasználók megvitathatják a Klippert más felhasználókkal.

Sok kérdés, amit kapunk, általános 3D-nyomtatással kapcsolatos, amely nem kifejezetten a Klipperre vonatkozik. Ha általános kérdésed van, vagy általános nyomtatási problémákkal küzdesz, akkor valószínűleg jobb választ kapsz, ha egy általános 3D-nyomtatási fórumon vagy a nyomtató hardverével foglalkozó fórumon teszed fel a kérdést.

Ne nyiss GitHub-on a Klippernél problémajelentést-t, ha kérdést szeretnél feltenni.

## Van egy funkciókérelmem

Minden új funkcióhoz szükség van valakire, akit érdekel és képes az adott funkció megvalósítására. Ha szeretnél segíteni egy új funkció megvalósításában vagy tesztelésében, akkor a [Klipper Közösségi Fórum](#kozossegi-forum) oldalon keresheted a folyamatban lévő fejlesztéseket. A [Discord Csevegés](#discord-cseveges) is rendelkezésre áll a munkatársak közötti megbeszélésekhez.

Ne nyiss GitHub-on a Klippernél problémajelentést, hogy funkciót kérj.

## Segítség! Nem működik!

Sajnos sokkal több segítségkérés érkezik hozzánk, mint amennyit meg tudnánk válaszolni. A legtöbb problémás bejelentés, amit látunk végül a következőkre vezethető vissza:

1. Finom hibák a hardverben, vagy
1. Nem követi a Klipper dokumentációban leírt összes lépést.

Ha problémákat tapasztalsz, javasoljuk, hogy figyelmesen olvasd el a [Klipper dokumentációt](Overview.md), és ellenőrizd, hogy minden lépést követtél-e.

Ha nyomtatási problémát tapasztalsz, akkor javasoljuk, hogy alaposan vizsgáld meg a nyomtató hardverét (minden illesztést, vezetéket, csavart stb.), és győződj meg arról, hogy semmi rendellenes nincs. Úgy találjuk, hogy a legtöbb nyomtatási probléma nem a Klipper szoftverrel kapcsolatos. Ha a nyomtató hardverével kapcsolatos problémát találsz, akkor valószínűleg jobb választ kapsz, ha egy általános 3D-nyomtatási fórumon vagy egy, a nyomtató hardverével foglalkozó fórumon keresel.

A [Klipper Közösségi Fórumban](#kozossegi-forum) is kereshetsz hasonló kérdéseket.

Ha szeretnéd megosztani tudásodat és tapasztalataidat más Klipper felhasználókkal, akkor csatlakozhatsz a [Klipper Közösségi Fórum](#kozossegi-forum) vagy a [Discord Csevegés](#discord-cseveges)-hez. Mindkettő olyan közösség, ahol a Klipper felhasználók megvitathatják a Klippert más felhasználókkal.

Ne nyiss GitHub-on a Klippernél problémajelentést, hogy segítséget kérj.

## Hibát diagnosztizáltam a Klipper szoftverben

A Klipper egy nyílt forráskódú projekt, és nagyra értékeljük, ha a munkatársak diagnosztizálják a szoftver hibáit.

Fontos információkra lesz szükség a hiba kijavításához. Kérjük, kövesse az alábbi lépéseket:

1. Győződj meg róla, hogy a hiba a Klipper szoftverben van. Ha úgy gondolja, hogy "van egy probléma, nem tudom kitalálni, hogy miért, és ezért ez egy Klipper hiba", akkor **ne** nyiss egy github problémabejelentést. Ebben az esetben valakinek, akit érdekel és képes rá, először fel kell kutatnia és diagnosztizálnia a probléma kiváltó okát. Ha szeretnéd megosztani a kutatásod eredményét, vagy megnézni, hogy más felhasználók is hasonló problémákkal küzdenek-e, akkor keresd meg a [Klipper Közösségi Fórum](#kozossegi-forum) oldalát.
1. Győződj meg róla, hogy a <https://github.com/Klipper3d/klipper> változatlan kódját futtatja. Ha a kódot módosították, vagy más forrásból származik, akkor a hiba bejelentése előtt reprodukálnia kell a problémát a <https://github.com/Klipper3d/klipper> nem módosított kóddal.
1. Ha lehetséges, futtasson egy `M112` parancsot az OctoPrint konzoljában közvetlenül a nemkívánatos esemény bekövetkezése után. Ennek hatására a Klipper "leállítási állapotba" kerül, és további hibakeresési információk íródnak a naplófájlba.
1. Szerezd be a Klipper naplófájlt az eseményből. A naplófájlt úgy alakították ki, hogy választ adjon a Klipper fejlesztőinek a szoftverrel és környezetével kapcsolatos gyakori kérdéseire (szoftver verzió, hardvertípus, konfiguráció, eseményidőzítés és több száz egyéb kérdés).
   1. A Klipper naplófájlja a `/tmp/klippy.log` címen található a Klipper "gazdagépen" (vagyis a Raspberry Pi-n).
   1. Egy "SCP" vagy "SFTP" segédprogram szükséges a naplófájlnak az asztali számítógépre való másolásához. Az "SCP" segédprogram alapfelszereltségként jár a Linux és MacOS asztali számítógépekhez. Más asztali számítógépekhez szabadon elérhető SCP segédprogramok is léteznek (pl. WinSCP). Ha olyan grafikus SCP segédprogramot használ, amely nem tudja közvetlenül másolni a `/tmp/klippy.log`, akkor kattints többször a `...` vagy `parent folder`, amíg el nem jutunk a gyökérkönyvtárba, kattintsunk a `tmp` mappára, majd válasszuk ki a `klippy.log` fájlt.
   1. Másolja a naplófájlt az asztalára, hogy csatolni tudja egy problémajelentéshez.
   1. Ne módosítsd a naplófájlt semmilyen módon; ne adj meg egy részletet a naplóból. Csak a teljes, változatlan naplófájl nyújtja a szükséges információkat.
   1. Ha a naplófájl nagyon nagy (pl. 2 MB-nál nagyobb), akkor szükség lehet a napló zip vagy gzip tömörítésére.

   1. Nyiss egy új GitHub problémabejelentést a <https://github.com/Klipper3d/klipper/issues> címen, és írd le egyértelműen a problémát. A Klipper fejlesztőinek meg kell érteniük, hogy milyen lépéseket tettek, mi volt a kívánt eredmény, és milyen eredmény történt valójában. A Klipper naplófájlt **csatolni kell** a hibajegyhez:![attach-issue](img/attach-issue.png)

## Változtatásokat végzek, amelyeket szeretnék a Klipperbe beépíteni

A Klipper nyílt forráskódú szoftver, és örömmel fogadjuk az új hozzájárulásokat.

Az új hozzájárulásokat (mind a kódot, mind a dokumentációt illetően) a GitHub Pull Requests-en keresztül küldheted be. Lásd a [CONTRIBUTING dokumentumot](CONTRIBUTING.md) a fontos információkért.

Számos [Fejlesztői dokumentum](Overview.md#developer-documentation) van fejlesztőknek. Ha kérdése van a kóddal kapcsolatban, akkor a [Klipper Közösségi Fórum](#kozossegi-forum) vagy a [Discord Csevegés](#discord-cseveges) oldalon is felteheti a kérdést. Ha frissíteni szeretnéd az aktuális fejlesztést, akkor megnyithat egy GitHub-problémát a kód helyével, a módosítások áttekintésével és az aktuális állapot leírásával.
