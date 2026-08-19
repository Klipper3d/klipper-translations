# Kapcsolat

Ez a dokumentum a Klipper csapatának elérhetőségét tartalmazza.

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Discord Csevegés

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

Ezt a szervert egy Klipper-rajongókból álló közösség működteti, amely a Klipperrel kapcsolatos vitáknak szenteli magát. Lehetővé teszi a felhasználók számára, hogy valós időben csevegjenek más felhasználókkal.

## Kérdésem van a Klipperrel kapcsolatban

Sok kérdésre már választ kaptunk a [Klipper dokumentációban](Overview.md). Kérjük, mindenképpen olvasd el a dokumentációt és kövesd az ott megadott utasításokat.

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## Van egy funkciókérelmem

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## Segítség! Nem működik!

Ha problémákat tapasztalsz, javasoljuk, hogy figyelmesen olvasd el a [Klipper dokumentációt](Overview.md), és ellenőrizd, hogy minden lépést követtél-e.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## Találtam egy hibát a Klipper szoftverben

A Klipper egy nyílt forráskódú projekt, és nagyra értékeljük, ha a munkatársak diagnosztizálják a szoftver hibáit.

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

Fontos információkra lesz szükség a hiba kijavításához. Kérjük, kövesd az alábbi lépéseket:

1. Győződj meg róla, hogy a <https://github.com/Klipper3d/klipper> változatlan kódját futtatod. Ha a kódot módosították, vagy más forrásból származik, akkor a hiba bejelentése előtt reprodukálnod kell a problémát a <https://github.com/Klipper3d/klipper> nem módosított kóddal.
1. Ha lehetséges, futtass egy `M112` parancsot közvetlenül a nemkívánatos esemény bekövetkezése után. Ennek hatására a Klipper "leállási állapotba" kerül, és további hibakeresési információk íródnak a naplófájlba.
1. Szerezd be a Klipper naplófájlt az eseményből. A naplófájlt úgy alakították ki, hogy választ adjon a Klipper fejlesztőinek a szoftverrel és környezetével kapcsolatos gyakori kérdéseire (szoftver verzió, hardvertípus, konfiguráció, eseményidőzítés és több száz egyéb kérdés).
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. Másold a naplófájlt az asztalára, hogy csatolni tudd egy problémajelentéshez.
   1. Ne módosítsd a naplófájlt semmilyen módon; ne adj meg egy részletet a naplóból. Csak a teljes, változatlan naplófájl nyújtja a szükséges információkat.
   1. Jó ötlet a naplófájlt zip vagy gzip segítségével tömöríteni.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## Változtatásokat végzek, amelyeket szeretnék a Klipperbe beépíteni

A Klipper nyílt forráskódú szoftver, és örömmel fogadjuk az új hozzájárulásokat.

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
