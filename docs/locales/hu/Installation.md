# Telepítés

Ezek az utasítások feltételezik, hogy a szoftver egy linux alapú gazdagépen fut, ahol egy Klipper-kompatibilis frontend fut. Javasoljuk, hogy egy SBC(Small Board Computer), például egy Raspberry Pi vagy Debian alapú Linux eszköz legyen a gazdagép (lásd a [GYIK](FAQ.md#can-i-run-klipper-on-something-other-other-than-a-raspberry-pi-3) más lehetőségeket).

Ezen utasítások alkalmazásában a gazdagép a Linux eszközre, az MCU pedig a nyomtatólapra vonatkozik. Az SBC a Small Board Computer kifejezésre utal, mint például a Raspberry Pi.

## Klipper konfigurációs fájl beszerzése

A Klipper legtöbb beállítását a printer.cfg „nyomtató konfigurációs fájl” határozza meg, amely a gépen lesz tárolva. A megfelelő konfigurációs fájl gyakran úgy található meg, hogy a Klipper [config könyvtárában](../config/) keresünk egy „printer-” előtaggal kezdődő fájlt, amely megfelel a célnyomtatónak. A Klipper konfigurációs fájl tartalmazza a nyomtatóra vonatkozó technikai információkat, amelyekre a telepítés során szükség lesz.

Ha nincs megfelelő nyomtató konfigurációs fájl a Klipper config könyvtárban, akkor keresd meg a nyomtató gyártójának weboldalát, hogy van-e megfelelő Klipper konfigurációs fájljuk.

Ha nem találod a nyomtatóhoz tartozó konfigurációs fájlt, de a nyomtató vezérlőpanelének típusa ismert, akkor keress egy megfelelő [config fájlt](../config/), amely "generic-" előtaggal kezdődik. Ezekkel a nyomtató vezérlőpanel példafájlokkal sikeresen elvégezhető a kezdeti telepítés, de a nyomtató teljes funkcionalitásának eléréséhez némi testreszabásra lesz szükség.

Lehetőség van új nyomtatókonfiguráció nulláról történő meghatározására is. Ehhez azonban jelentős műszaki ismeretekre van szükség a nyomtatóval és annak elektronikájával kapcsolatban. A legtöbb felhasználónak ajánlott, hogy egy megfelelő konfigurációs fájllal kezd. Ha új, egyéni nyomtató konfigurációs fájlt hozol létre, akkor a legközelebbi példával [config fájl](../config/) kezd, és további információkért használd a Klipper [konfigurációs hivatkozás](Config_Reference.md) című dokumentumot.

## Klipperrel való interakció

A Klipper egy 3D nyomtató firmware, így a felhasználónak valamilyen módon interakcióba kell lépnie vele.

Jelenleg a legjobb választás a frontendek, amelyek a [Moonraker web API](https://moonraker.readthedocs.io/) segítségével kérik le az információkat, és lehetőség van az [Octoprint](https://octoprint.org/) használatára is a Klipper vezérléséhez.

A felhasználó dönti el, hogy mit használ, de az alapjául szolgáló Klipper minden esetben ugyanaz. Arra bátorítjuk a felhasználókat, hogy kutassák fel a rendelkezésre álló lehetőségeket, és hozzanak megalapozott döntést.

## OS-kép beszerzése SBC-khez

Számos módja van annak, hogy a Klipper SBC használatra szánt operációs rendszer képét megszerezd, a legtöbb attól függ, hogy milyen (front end-et) szeretnél használni. Az SBC lapok egyes gyártói saját Klipper-központú image-eket is biztosítanak.

A két fő Moonraker alapú frontend a [Fluidd](https://docs.fluidd.xyz/) és a [Mainsail](https://docs.mainsail.xyz/), az utóbbi rendelkezik egy előre elkészített telepítő image [„MainsailOS”](http://docs.mainsailOS.xyz), ez tartalmazza a Raspberry Pi és néhány OrangePi variáns opciót.

A Fluidd telepíthető a KIAUH (Klipper Install And Update Helper) segítségével, amely az alábbiakban ismertetésre kerül, és egy harmadik féltől származó telepítő minden Klipper dologhoz.

Az OctoPrint telepíthető a népszerű OctoPi képen keresztül vagy a KIAUH segítségével, ezt a folyamatot a <OctoPrint.md> ismerteti.

## Telepítés a KIAUH-n keresztül

Normális esetben az SBC alapképével kezd, például az RPiOS Lite-tal, vagy x86-os Linux eszköz esetén az Ubuntu Server-el. Kérjük, vedd figyelembe, hogy az asztali változatok nem ajánlottak bizonyos segédprogramok miatt, amelyek megakadályozhatják egyes Klipper funkciók működését, sőt, egyes nyomtatólapokhoz való hozzáférést is elfedhetik.

A KIAUH használható a Klipper és a hozzá tartozó programok telepítésére különböző Linux alapú rendszerekre, amelyeken a Debian egy formája fut. További információ a https://github.com/dw-0/kiauh oldalon található.

## A mikrokontroller felépítése és égetése

A mikrokontroller kódjának lefordításához kezdj a következő parancsok futtatásával a gazdakészüléken:

```
cd ~/klipper/
make menuconfig
```

A [nyomtató konfigurációs fájl](#obtain-a-klipper-configuration-file) tetején található megjegyzéseknek le kell írniuk a beállításokat, amelyeket a "make menuconfig" során kell beállítani. Nyisd meg a fájlt egy webböngészőben vagy szövegszerkesztőben, és keresd meg ezeket az utasításokat a fájl teteje közelében. Miután a megfelelő "menuconfig" beállításokat elvégezted, nyomd meg a "Q" gombot a kilépéshez, majd az "Y" gombot a mentéshez. Ezután futtasd:

```
make
```

Ha a [nyomtató konfigurációs fájl](#obtain-a-klipper-configuration-file) tetején található megjegyzések egyéni lépéseket írnak le a "flash" végső képnek a nyomtató vezérlőpanelére történő égetéséhez, akkor kövesd ezeket a lépéseket, majd folytasd az [OctoPrint konfigurálása](#configuring-octoprint-to-use-klipper) lépésekkel.

Ellenkező esetben a következő lépéseket gyakran használják a nyomtató vezérlőlapjának "flash" égetésére. Először meg kell határozni a mikrokontrollerhez csatlakoztatott soros portot. Futtasd a következőket:

```
ls /dev/serial/by-id/*
```

Az alábbiakhoz hasonlót kell kapnod:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Gyakori, hogy minden nyomtatónak saját egyedi soros port neve van. Ez az egyedi név kerül felhasználásra a mikrokontroller égetésekor. Lehetséges, hogy a fenti kimeneten több sor is szerepel - ha igen, válaszd ki a mikrokontrollernek megfelelő sort. Ha több elem is szerepel a listában, és a választás nem egyértelmű, húzd ki a kártyát, és futtasd le újra a parancsot, a hiányzó elem a nyomtató alaplapod lesz(további információért lásd [GYIK](FAQ.md#wheres-my-serial-port)).

Az STM32 vagy klón chipekkel, LPC chipekkel és más, gyakori mikrovezérlők esetében szokásos, hogy ezeknek SD-kártyán keresztül történő kezdeti Klipper flashelésre van szükségük.

Ha ezzel a módszerrel égetsz, fontos, hogy a nyomtatópanel ne legyen USB-n keresztül csatlakoztatva a gazdagéphez, mivel egyes panelek képesek visszatáplálni a feszültséget, és megakadályozni az égetést.

Az Atmega chipeket használó általános mikrovezérlők, például a 2560-asok esetében a kódot a következő módon lehet égetni:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Feltétlenül frissítd a FLASH_DEVICE eszközt a nyomtató egyedi soros portjának nevével.

Az RP2040 chipeket használó általános mikrovezérlők esetében a kódot a következő módon lehet égetni:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

Fontos megjegyezni, hogy az RP2040 chipeket e művelet előtt Boot üzemmódba kell helyezni.

## A Klipper beállítása

A következő lépés a [nyomtató konfigurációs fájl](#obtain-a-klipper-configuration-file) átmásolása a gazdagépre.

Vitathatatlanul a legegyszerűbb módja a Klipper konfigurációs fájl beállításának a Mainsail vagy a Fluidd beépített szerkesztőinek használata. Ezek lehetővé teszik a felhasználó számára, hogy megnyissa a konfigurációs példákat, és elmentse őket a printer.cfg fájlba.

Egy másik lehetőség egy olyan asztali szerkesztő használata, amely támogatja a fájlok szerkesztését az „scp” és/vagy „sftp” protokollokon keresztül. Vannak szabadon elérhető eszközök, amelyek támogatják ezt (pl. Notepad++, WinSCP és Cyberduck). Töltsd be a nyomtató konfigurációs fájlját a szerkesztőbe, majd mentsd el a „printer.cfg” nevű fájlként a PI felhasználó home könyvtárába (pl. /home/pi/printer.cfg).

Alternatív megoldásként a fájlt közvetlenül az állomáson is lehet másolni és szerkeszteni SSH-n keresztül. Ez valahogy így nézhet ki (ügyelj arra, hogy a parancsot frissítsd a megfelelő nyomtató konfigurációs fájlnévvel):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Gyakori, hogy minden nyomtatónak saját egyedi neve van a mikrokontroller számára. A név a Klipper égetése után megváltozhat, ezért futtasd újra ezeket a lépéseket, még akkor is, ha már az égetéskor elvégezted őket. Futtatás:

```
ls /dev/serial/by-id/*
```

Az alábbiakhoz hasonlót kell kapnod:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Ezután frissítsd a konfigurációs fájlt az egyedi névvel. Például frissítsd az `[mcu]` részt, hogy valami hasonlót kapj:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

A fájl létrehozása és szerkesztése után a konfiguráció betöltéséhez szükséges lesz egy „restart” parancs kiadása a parancskonzolon. A „status” parancs azt jelenti, hogy a nyomtató készen áll, ha a Klipper config fájl sikeresen beolvasásra került, és a mikrokontroller sikeresen meg lett találva és konfigurálva.

A nyomtató konfigurációs fájljának testreszabásakor nem ritka, hogy a Klipper konfigurációs hibát jelez. Ha hiba lép fel, végezd el a szükséges javításokat a nyomtató konfigurációs fájljában, és add ki az "újraindítás" parancsot, amíg az "állapot" nem jelzi, hogy a nyomtató készen áll.

A Klipper hibaüzeneteket jelent a parancsikonon és a Fluidd és Mainsail felugró ablakán keresztül. A „status” parancs használható a hibaüzenetek újbóli jelentésére. Egy napló is rendelkezésre áll, és általában a ~/printer_data/logs könyvtárban található, ennek a neve klippy.log.

Miután a Klipper jelenti, hogy a nyomtató készen áll, folytasd a [konfigurációs ellenőrzés](Config_checks.md) című dokumentummal, hogy elvégezz néhány alapvető ellenőrzést a config fájlban lévő definíciókon. További információkért lásd a fő [dokumentációs hivatkozás](Overview.md) című rész.
