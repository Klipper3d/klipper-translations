# Telepítés

Ezek az utasítások feltételezik, hogy a szoftver egy Raspberry Pi számítógépen fut az OctoPrint-el együtt. Javasoljuk, hogy egy Raspberry Pi 2, 3 vagy 4-es számítógépet használjon gazdagépként (más gépekre vonatkozóan lásd a [GYIK](FAQ.md#can-i-run-klipper-on-something-other-other-than-a-raspberry-pi-3) című részt).

A Klipper jelenleg számos Atmel ATmega alapú mikrovezérlőt, [ARM alapú mikrovezérlőt](Features.md#step-benchmarks) és [Beaglebone PRU](Beaglebone.md) alapú nyomtatót támogat.

## OS képfájl előkészítése

Kezdje az [OctoPi](https://github.com/guysoft/OctoPi) telepítésével a Raspberry Pi számítógépére. Használja az OctoPi v0.17.0-s vagy újabb verzióját. A kiadásokkal kapcsolatos információkért tekintse meg az [OctoPi-kiadásokat](https://github.com/guysoft/OctoPi/releases). Ellenőrizni kell, hogy az OctoPi elindul-e, és hogy az OctoPrint webszerver működik-e. Miután csatlakozott az OctoPrint weboldalhoz, kövesse az utasításokat az OctoPrint 1.4.2-es vagy újabb verziójára való frissítéséhez.

Az OctoPi telepítése és az OctoPrint frissítése után néhány rendszerparancs futtatásához szükség lesz az "SSH" kapcsolatra a célgéphez. Ha Linux vagy MacOS asztali számítógépet használ, akkor az "SSH" szoftvernek már telepítve kell lennie az asztalon. Vannak ingyenes ssh-kliensek más asztali számítógépekhez (pl. [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Az SSH segédprogrammal csatlakozzon a Raspberry Pi-hez (ssh pi@octopi -- a jelszó "raspberry"), és futtassa a következő parancsokat:

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

Válassza ki a megfelelő mikrovezérlőt, és tekintse át a rendelkezésre álló egyéb lehetőségeket. A konfigurálás után futtassa:

```
make
```

Meg kell határozni a mikrovezérlőhöz csatlakoztatott soros portot. Az USB-n keresztül csatlakozó mikrovezérlők esetében futtassa a következőt:

```
ls /dev/serial/by-id/*
```

Valami hasonlót kell kapnia az alábbiakhoz:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Gyakori, hogy minden nyomtatónak saját egyedi soros port neve van. Ezt az egyedi nevet használjuk a mikrokontroller égetésére. Lehetséges, hogy a fenti kimenetben több sor is található – ha igen, válassza ki a mikrovezérlőnek megfelelő sort (további információért lásd a [GYIK](FAQ.md#wheres-my-serial-port) részt).

Az általános mikrokontrollereknél a kódot valami hasonlóval lehet égetni:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Feltétlenül frissítse a FLASH_DEVICE eszközt a nyomtató egyedi soros portjának nevével.

Amikor először éget, győződjön meg arról, hogy az OctoPrint nincs közvetlenül csatlakoztatva a nyomtatóhoz (az OctoPrint weboldalon a "Kapcsolat" részben kattintson a "Kapcsolat bontása" gombra).

## Az OctoPrint beállítása a Klipper használatához

Az OctoPrint webszervert konfigurálni kell, hogy kommunikáljon a Klipper gazdagép szoftverével. Egy webböngészővel jelentkezzen be az OctoPrint weboldalra, majd konfigurálja a következő elemeket:

Lépjen a Beállítások lapra (a csavarkulcs ikon az oldal tetején). A "További soros portok" részben a "Soros kapcsolat" alatt adja hozzá a "/tmp/printer" elemet. Ezután kattintson a "Mentés" gombra.

Lépjen újra a Beállítások fülre, és a „Soros kapcsolat” alatt módosítsa a „Soros port” beállítást „/tmp/printer”-re.

A Beállítások lapon lépjen a „Viselkedés” allapra, és válassza a „Folyamatban lévő nyomtatás törlése, de továbbra is csatlakozva maradjon a nyomtatóhoz” lehetőséget. Kattintson a "Mentés" gombra.

A főoldalon, a „Kapcsolat” részben (az oldal bal felső sarkában) győződjön meg arról, hogy a „Soros Port” beállítása „/tmp/printer”, majd kattintson a „Csatlakozás” gombra. (Ha a „/tmp/printer” nem elérhető, próbálja meg újratölteni az oldalt.)

A csatlakozás után lépjen a "Terminal" fülre, és írja be a "status" kifejezést (idézőjelek nélkül) a parancsbeviteli mezőbe, majd kattintson a "Küldés" gombra. A terminálablak valószínűleg hibát jelez a konfigurációs fájl megnyitásakor – ez azt jelenti, hogy az OctoPrint sikeresen kommunikál a Klipperrel. Tovább a következő részhez.

## A Klipper beállítása

A Klipper konfigurációja a Raspberry Pi szöveges fájljában van tárolva. Vessen egy pillantást a példa konfigurációs fájlokra a [Konfigurációs könyvtárban](../config/). A [Konfigurációs hivatkozás](Config_Reference.md) dokumentációt tartalmaz a konfigurációs paraméterekről.

A Klipper konfigurációs fájljának frissítésének legegyszerűbb módja egy olyan asztali szerkesztő használata, amely támogatja a fájlok "scp" és/vagy "sftp" protokollon keresztüli szerkesztését. Vannak ingyenesen elérhető eszközök, amelyek ezt támogatják (pl. Notepad++, WinSCP és Cyberduck). Használja az egyik példa konfigurációs fájlt kiindulási pontként, és mentse el "printer.cfg" nevű fájlként a pi felhasználó kezdőkönyvtárába (azaz /home/pi/printer.cfg).

Alternatív megoldásként a fájlt közvetlenül a Raspberry Pi-n is másolhatja és szerkesztheti SSH-n keresztül - például:

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Mindenképpen tekintse át és frissítse a hardvernek megfelelő beállításokat.

Gyakori, hogy minden nyomtató mikrovezérlőnek egyedi neve van a. A név megváltozhat a Klipper égetése után, ezért futtassa újra az `ls /dev/serial/by-id/*` parancsot, majd frissítse a konfigurációs fájlt az egyedi névvel. Például frissítse az `[mcu]` részt, hogy az a következőhöz hasonló legyen:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

A fájl létrehozása és szerkesztése után a konfiguráció betöltéséhez az OctoPrint webterminálban egy "restart" parancsot kell kiadni. A "status" parancs jelzi, hogy a nyomtató készen áll, ha a Klipper konfigurációs fájlja sikeresen beolvasásra került, és a mikrovezérlőt sikerült megtalálni és konfigurálni. Nem szokatlan, hogy a kezdeti beállítás során konfigurációs hibák lépnek fel – frissítse a nyomtató konfigurációs fájlját, és adja meg az „újraindítás” üzenetet, amíg az „állapot” nem jelzi, hogy a nyomtató készen áll.

A Klipper az OctoPrint terminállapon keresztül jelenti a hibaüzeneteket. A "status" paranccsal a hibaüzenetek újra jelenthetők. A Klipper alapértelmezett indítószkriptje egy naplót is elhelyez a **/tmp/klippy.log** fájlban, amely részletesebb információkat tartalmaz.

A gyakori G-kód parancsokon kívül a Klipper néhány kiterjesztett parancsot is támogat. Az „állapot” és az „újraindítás” példák ezekre a parancsokra. Használja a "help" parancsot az egyéb kiterjesztett parancsok listájának megtekintéséhez.

Miután a Klipper azt jelenti, hogy a nyomtató készen áll, lépjen tovább a [konfigurációs ellenőrző dokumentum](Config_checks.md) oldalra, és hajtson végre néhány alapvető ellenőrzést a tű-definíciókon a konfigurációs fájlban.

## Kapcsolatfelvétel a fejlesztőkkel

Nézze meg a [GYIK](FAQ.md) részt, ahol választ talál néhány gyakori kérdésre. Tekintse meg a [kapcsolati oldalt](Contact.md) a hiba bejelentéséhez vagy a fejlesztőkkel való kapcsolatfelvételhez.
