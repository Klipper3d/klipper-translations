# Telepítés

Ezek az utasítások feltételezik, hogy a szoftver egy Raspberry Pi számítógépen fut az OctoPrint-el együtt. Javasoljuk, hogy egy Raspberry Pi 2, 3 vagy 4-es számítógépet használj gazdagépként (más gépekre vonatkozóan lásd a [GYIK](FAQ.md#can-i-run-klipper-on-something-other-other-than-a-raspberry-pi-3) című részt).

## Klipper konfigurációs fájl beszerzése

A legtöbb Klipper beállítást egy "nyomtató konfigurációs fájl" határozza meg, amelyet a Raspberry Pi tárol. A megfelelő konfigurációs fájlt gyakran úgy találhatjuk meg, hogy a Klipper [config könyvtárában](../config/) keresünk egy "printer-" előtaggal kezdődő fájlt, amely megfelel a célnyomtatónak. A Klipper konfigurációs fájl tartalmazza a nyomtatóra vonatkozó technikai információkat, amelyekre a telepítés során szükség lesz.

Ha nincs megfelelő nyomtató konfigurációs fájl a Klipper config könyvtárban, akkor keresse meg a nyomtató gyártójának weboldalát, hogy van-e megfelelő Klipper konfigurációs fájljuk.

Ha nem találja a nyomtatóhoz tartozó konfigurációs fájlt, de a nyomtató vezérlőpanelének típusa ismert, akkor keressen egy megfelelő [config fájlt](../config/), amely "generic-" előtaggal kezdődik. Ezekkel a nyomtató vezérlőpanel példafájlokkal sikeresen elvégezhető a kezdeti telepítés, de a nyomtató teljes funkcionalitásának eléréséhez némi testreszabásra lesz szükség.

Lehetőség van új nyomtatókonfiguráció nulláról történő meghatározására is. Ehhez azonban jelentős műszaki ismeretekre van szükség a nyomtatóval és annak elektronikájával kapcsolatban. A legtöbb felhasználónak ajánlott, hogy egy megfelelő konfigurációs fájllal kezd. Ha új, egyéni nyomtató konfigurációs fájlt hoz létre, akkor a legközelebbi példával [config fájl](../config/) kezd, és további információkért használd a Klipper [konfigurációs hivatkozás](Config_Reference.md) című dokumentumot.

## OS képfájl előkészítése

Kezd az [OctoPi](https://github.com/guysoft/OctoPi) telepítésével a Raspberry Pi számítógépére. Használd az OctoPi v0.17.0-s vagy újabb verzióját. A kiadásokkal kapcsolatos információkért tekintsd meg az [OctoPi-kiadásokat](https://github.com/guysoft/OctoPi/releases). Ellenőrizni kell, hogy az OctoPi elindul-e, és hogy az OctoPrint webszerver működik-e. Miután csatlakozott az OctoPrint weboldalhoz, kövesse az utasításokat az OctoPrint 1.4.2-es vagy újabb verziójára való frissítéséhez.

Az OctoPi telepítése és az OctoPrint frissítése után néhány rendszerparancs futtatásához szükség lesz az "SSH" kapcsolatra a célgéphez. Ha Linux vagy MacOS asztali számítógépet használ, akkor az "SSH" szoftvernek már telepítve kell lennie a gépen. Vannak ingyenes ssh-kliensek más asztali számítógépekhez (pl. [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Az SSH segédprogrammal csatlakozzon a Raspberry Pi-hez (ssh pi@octopi -- a jelszó "raspberry"), és futtassa a következő parancsokat:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

A fentiek letöltik a Klippert, telepítenek néhány rendszerösszetevőt, beállítják a Klippert, hogy a rendszer indulásakor fusson, és elindítja a Klipper gazdagép szoftverét. Internetkapcsolatra lesz szükség, és néhány percet is igénybe vehet.

## A mikrokontroller felépítése és égetése

A mikrokontroller kódjának lefordításához futtassa ezeket a parancsokat a Raspberry Pi-n:

```
cd ~/klipper/
make menuconfig
```

A [nyomtató konfigurációs fájl](#obtain-a-klipper-configuration-file) tetején található megjegyzéseknek le kell írniuk a beállításokat, amelyeket a "make menuconfig" során kell beállítani. Nyissa meg a fájlt egy webböngészőben vagy szövegszerkesztőben, és keresse meg ezeket az utasításokat a fájl teteje közelében. Miután a megfelelő "menuconfig" beállításokat elvégezte, nyomja meg a "Q" gombot a kilépéshez, majd az "Y" gombot a mentéshez. Ezután futtassa:

```
make
```

Ha a [nyomtató konfigurációs fájl](#obtain-a-klipper-configuration-file) tetején található megjegyzések egyéni lépéseket írnak le a "flash" végső képnek a nyomtató vezérlőpanelére történő égetéséhez, akkor kövesd ezeket a lépéseket, majd folytasd az [OctoPrint konfigurálása](#configuring-octoprint-to-use-klipper) lépésekkel.

Ellenkező esetben a következő lépéseket gyakran használják a nyomtató vezérlőlapjának "flash" égetésére. Először meg kell határozni a mikrokontrollerhez csatlakoztatott soros portot. Futtassa a következőket:

```
ls /dev/serial/by-id/*
```

Valami hasonlót kell kapnia az alábbiakhoz:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Gyakori, hogy minden nyomtatónak saját egyedi soros port neve van. Ezt az egyedi nevet használjuk a mikrokontroller égetésére. Lehetséges, hogy a fenti kimenetben több sor is található – ha igen, válaszd ki a mikrovezérlőnek megfelelő sort (további információért lásd a [GYIK](FAQ.md#wheres-my-serial-port) részt).

Az általános mikrokontrollereknél a kódot valami hasonlóval lehet égetni:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Feltétlenül frissítse a FLASH_DEVICE eszközt a nyomtató egyedi soros portjának nevével.

Amikor először égetsz, győződj meg arról, hogy az OctoPrint nincs közvetlenül csatlakoztatva a nyomtatóhoz (az OctoPrint weboldalon a "Kapcsolat" részben kattints a "Kapcsolat bontása" gombra).

## Az OctoPrint beállítása a Klipper használatához

Az OctoPrint webszervert konfigurálni kell, hogy kommunikáljon a Klipper gazdagép szoftverével. Egy webböngészővel jelentkezz be az OctoPrint weboldalra, majd konfiguráld a következő elemeket:

Lépj a Beállítások lapra (a csavarkulcs ikon az oldal tetején). A "További soros portok" részben a "Soros kapcsolat" alatt add hozzá a "/tmp/printer" elemet. Ezután kattints a "Mentés" gombra.

Lépj újra a Beállítások fülre, és a „Soros kapcsolat” alatt módosítsd a „Soros port” beállítást „/tmp/printer”-re.

A Beállítások lapon lépj a „Viselkedés” allapra, és válaszd a „Folyamatban lévő nyomtatás törlése, de továbbra is csatlakozva maradjon a nyomtatóhoz” lehetőséget. Kattints a "Mentés" gombra.

A főoldalon, a „Kapcsolat” részben (az oldal bal felső sarkában) győződj meg arról, hogy a „Soros Port” beállítása „/tmp/printer”, majd kattints a „Csatlakozás” gombra. (Ha a „/tmp/printer” nem elérhető, próbáld meg újratölteni az oldalt.)

A csatlakozás után lépj a "Terminal" fülre, és írd be a "status" kifejezést (idézőjelek nélkül) a parancsbeviteli mezőbe, majd kattints a "Küldés" gombra. A terminálablak valószínűleg hibát jelez a konfigurációs fájl megnyitásakor – ez azt jelenti, hogy az OctoPrint sikeresen kommunikál a Klipperrel. Tovább a következő részhez.

## A Klipper beállítása

A következő lépés a [nyomtató konfigurációs fájl](#obtain-a-klipper-configuration-file) átmásolása a Raspberry Pi-re.

Vitathatatlanul a Klipper konfigurációs fájl beállításának legegyszerűbb módja egy olyan asztali szerkesztő használata, amely támogatja a fájlok szerkesztését az "scp" és/vagy "sftp" protokollokon keresztül. Vannak szabadon elérhető eszközök, amelyek támogatják ezt (pl. Notepad++, WinSCP és Cyberduck). Töltse be a nyomtató konfigurációs fájlját a szerkesztőprogramba, majd mentsd el egy "printer.cfg" nevű fájlként a pi felhasználó home könyvtárába (pl. /home/pi/printer.cfg).

Alternatívaként a fájlt közvetlenül a Raspberry Pi-n is lehet másolni és szerkeszteni SSH-n keresztül. Ez valahogy így nézhet ki (ügyeljünk arra, hogy a parancsot frissítsük a megfelelő nyomtató konfigurációs fájlnévvel):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Gyakori, hogy minden nyomtatónak saját egyedi neve van a mikrokontroller számára. A név a Klipper égetése után megváltozhat, ezért futtassa újra ezeket a lépéseket, még akkor is, ha már az égetéskor elvégezte őket. Futtatás:

```
ls /dev/serial/by-id/*
```

Valami hasonlót kell kapnia az alábbiakhoz:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Ezután frissítse a konfigurációs fájlt az egyedi névvel. Például frissítse az `[mcu]` részt, hogy valami hasonlót kapjon:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

A fájl létrehozása és szerkesztése után az OctoPrint webes terminálján ki kell adni egy "újraindítás" parancsot a konfiguráció betöltéséhez. A "status" parancs azt jelenti, hogy a nyomtató készen áll, ha a Klipper config fájl sikeresen beolvasásra került, és a mikrokontroller sikeresen meg lett találva és konfigurálva.

A nyomtató konfigurációs fájljának testreszabásakor nem ritka, hogy a Klipper konfigurációs hibát jelez. Ha hiba lép fel, végezd el a szükséges javításokat a nyomtató konfigurációs fájljában, és add ki az "újraindítás" parancsot, amíg az "állapot" nem jelzi, hogy a nyomtató készen áll.

A Klipper az OctoPrint terminállapon keresztül jelenti a hibaüzeneteket. A "status" paranccsal a hibaüzenetek újra jelenthetők. A Klipper alapértelmezett indítószkriptje egy naplót is elhelyez a **/tmp/klippy.log** fájlban, amely részletesebb információkat tartalmaz.

Miután a Klipper jelenti, hogy a nyomtató készen áll, folytasd a [konfigurációs ellenőrzés](Config_checks.md) című dokumentumal, hogy elvégezz néhány alapvető ellenőrzést a config fájlban lévő definíciókon. További információkért lásd a fő [dokumentációs hivatkozás](Overview.md) című rész.
