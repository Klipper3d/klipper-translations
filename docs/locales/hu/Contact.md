# Kapcsolat

Ez a dokumentum a Klipper csapatának elérhetőségét tartalmazza.

1. [Közösségi Fórum](#kozossegi-forum)
1. [Discord Csevegés](#discord-cseveges)
1. [Kérdésem van a Klipperrel kapcsolatban](#kerdesem-van-a-klipperrel-kapcsolatban)
1. [Van egy funkciókérelmem](#van-egy-funkciokerelmem)
1. [Segítség! Nem működik!](#segitseg-nem-mukodik)
1. [I found a bug in the Klipper software](#i-found-a-bug-in-the-klipper-software)
1. [Változtatásokat végzek, amelyeket szeretnék a Klipperbe beépíteni](#valtoztatasokat-vegzek-amelyeket-szeretnek-a-klipperbe-beepiteni)
1. [Klipper github](#klipper-github)

## Közösségi Fórum

Van egy [Klipper Közösségi Társalgó szerver](https://community.klipper3d.org) a Klipperrel kapcsolatos beszélgetésekhez.

## Discord Csevegés

Van egy Klipper-nek szentelt Discord szerver a következő címen: <https://discord.klipper3d.org>.

Ezt a szervert egy Klipper-rajongókból álló közösség működteti, amely a Klipperrel kapcsolatos vitáknak szenteli magát. Lehetővé teszi a felhasználók számára, hogy valós időben csevegjenek más felhasználókkal.

## Kérdésem van a Klipperrel kapcsolatban

Sok kérdésre már választ kaptunk a [Klipper dokumentációban](Overview.md). Kérjük, mindenképpen olvasd el a dokumentációt és kövesd az ott megadott utasításokat.

Lehetőség van hasonló kérdések keresésére a [Klipper Közösségi Fórum](#kozossegi-forum) oldalon is.

Ha szeretnéd megosztani tudásodat és tapasztalataidat más Klipper felhasználókkal, akkor csatlakozhatsz a [Klipper Közösségi Fórum](#kozossegi-forum) vagy a [Discord Csevegés](#discord-cseveges)-hez. Mindkettő olyan közösség, ahol a Klipper felhasználók megvitathatják a Klippert más felhasználókkal.

Sok kérdés, amit kapunk, általános 3D-nyomtatással kapcsolatos, amely nem kifejezetten a Klipperre vonatkozik. Ha általános kérdésed van, vagy általános nyomtatási problémákkal küzdesz, akkor valószínűleg jobb választ kapsz, ha egy általános 3D-nyomtatási fórumon vagy a nyomtató hardverével foglalkozó fórumon teszed fel a kérdést.

## Van egy funkciókérelmem

Minden új funkcióhoz szükség van valakire, akit érdekel és képes az adott funkció megvalósítására. Ha szeretnél segíteni egy új funkció megvalósításában vagy tesztelésében, akkor a [Klipper Közösségi Fórum](#kozossegi-forum) oldalon keresheted a folyamatban lévő fejlesztéseket. A [Discord Csevegés](#discord-cseveges) is rendelkezésre áll a munkatársak közötti megbeszélésekhez.

## Segítség! Nem működik!

Sajnos sokkal több segítségkérés érkezik hozzánk, mint amennyit meg tudnánk válaszolni. A legtöbb problémás bejelentés, amit látunk végül a következőkre vezethető vissza:

1. Finom hibák a hardverben, vagy
1. Nem követi a Klipper dokumentációban leírt összes lépést.

Ha problémákat tapasztalsz, javasoljuk, hogy figyelmesen olvasd el a [Klipper dokumentációt](Overview.md), és ellenőrizd, hogy minden lépést követtél-e.

Ha nyomtatási problémát tapasztalsz, akkor javasoljuk, hogy alaposan vizsgáld meg a nyomtató hardverét (minden illesztést, vezetéket, csavart stb.), és győződj meg arról, hogy semmi rendellenes nincs. Úgy találjuk, hogy a legtöbb nyomtatási probléma nem a Klipper szoftverrel kapcsolatos. Ha a nyomtató hardverével kapcsolatos problémát találsz, akkor valószínűleg jobb választ kapsz, ha egy általános 3D-nyomtatási fórumon vagy egy, a nyomtató hardverével foglalkozó fórumon keresel.

A [Klipper Közösségi Fórumban](#kozossegi-forum) is kereshetsz hasonló kérdéseket.

Ha szeretnéd megosztani tudásodat és tapasztalataidat más Klipper felhasználókkal, akkor csatlakozhatsz a [Klipper Közösségi Fórum](#kozossegi-forum) vagy a [Discord Csevegés](#discord-cseveges)-hez. Mindkettő olyan közösség, ahol a Klipper felhasználók megvitathatják a Klippert más felhasználókkal.

## I found a bug in the Klipper software

A Klipper egy nyílt forráskódú projekt, és nagyra értékeljük, ha a munkatársak diagnosztizálják a szoftver hibáit.

Problems should be reported in the [Klipper Community Forum](#community-forum).

Fontos információkra lesz szükség a hiba kijavításához. Kérjük, kövesd az alábbi lépéseket:

1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you should reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting.
1. If possible, run an `M112` command immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. Szerezd be a Klipper naplófájlt az eseményből. A naplófájlt úgy alakították ki, hogy választ adjon a Klipper fejlesztőinek a szoftverrel és környezetével kapcsolatos gyakori kérdéseire (szoftver verzió, hardvertípus, konfiguráció, eseményidőzítés és több száz egyéb kérdés).
   1. A Klipper naplófájlja a `/tmp/klippy.log` címen található a Klipper "gazdagépen" (vagyis a Raspberry Pi-n).
   1. Egy "SCP" vagy "SFTP" segédprogram szükséges a naplófájlnak az asztali számítógépre való másolásához. Az "SCP" segédprogram alapfelszereltségként jár a Linux és MacOS asztali számítógépekhez. Más asztali számítógépekhez szabadon elérhető SCP segédprogramok is léteznek (pl. WinSCP). Ha olyan grafikus SCP segédprogramot használsz, amely nem tudja közvetlenül másolni a `/tmp/klippy.log`, akkor kattints többször a `...` vagy `parent folder`, amíg el nem jutunk a gyökérkönyvtárba, kattintsunk a `tmp` mappára, majd válasszuk ki a `klippy.log` fájlt.
   1. Másold a naplófájlt az asztalára, hogy csatolni tudd egy problémajelentéshez.
   1. Ne módosítsd a naplófájlt semmilyen módon; ne adj meg egy részletet a naplóból. Csak a teljes, változatlan naplófájl nyújtja a szükséges információkat.
   1. It is a good idea to compress the log file with zip or gzip.
1. Open a new topic on the [Klipper Community Forum](#community-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## Változtatásokat végzek, amelyeket szeretnék a Klipperbe beépíteni

A Klipper nyílt forráskódú szoftver, és örömmel fogadjuk az új hozzájárulásokat.

Az új hozzájárulásokat (mind a kódot, mind a dokumentációt illetően) a GitHub Pull Requests-en keresztül küldheted be. Lásd a [CONTRIBUTING dokumentumot](CONTRIBUTING.md) a fontos információkért.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Community Forum](#community-forum) or on the [Klipper Community Discord](#discord-chat).

## Klipper github

Klipper github may be used by contributors to share the status of their work to improve Klipper. It is expected that the person opening a github ticket is actively working on the given task and will be the one performing all the work necessary to accomplish it. The Klipper github is not used for requests, nor to report bugs, nor to ask questions. Use the [Klipper Community Forum](#community-forum) or the [Klipper Community Discord](#discord-chat) instead.
