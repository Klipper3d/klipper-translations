# Telepítés

These instructions assume the software will run on a Linux-based host running a Klipper-compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian-based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions, host relates to the Linux device and mcu relates to the printer board. SBC relates to the term Small Board Computer such as the Raspberry Pi.

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

There are many ways to obtain an OS image for Klipper for SBC use, most depend on what front end you wish to use. Some manufacturers of these SBC boards also provide their own Klipper-centric images.

The two main Moonraker-based front ends are [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/), the latter of which has a premade install image ["MainsailOS"](https://docs-os.mainsail.xyz/), this has the option for Raspberry Pi and some OrangePi variants.

A Fluidd telepíthető a KIAUH (Klipper Install And Update Helper) segítségével, amely az alábbiakban ismertetésre kerül, és egy harmadik féltől származó telepítő minden Klipper dologhoz.

Az OctoPrint telepíthető a népszerű OctoPi képen keresztül vagy a KIAUH segítségével, ezt a folyamatot a <OctoPrint.md> ismerteti.

## Telepítés a KIAUH-n keresztül

Normally you would start with a base image for your SBC, RPiOS Lite for example, or in the case of an x86 Linux device, Ubuntu Server. Please note that Desktop variants are not recommended due to certain helper programs that can stop some Klipper functions from working and even mask access to some printer boards.

KIAUH can be used to install Klipper and its associated programs on a variety of Linux-based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

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

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board, then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Ellenkező esetben a következő lépéseket gyakran használják a nyomtató vezérlőlapjának "flash" égetésére. Először meg kell határozni a mikrokontrollerhez csatlakoztatott soros portot. Futtasd a következőket:

```
ls /dev/serial/by-id/*
```

Az alábbiakhoz hasonlót kell kapnod:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Gyakori, hogy minden nyomtatónak saját egyedi soros port neve van. Ez az egyedi név kerül felhasználásra a mikrokontroller égetésekor. Lehetséges, hogy a fenti kimeneten több sor is szerepel - ha igen, válaszd ki a mikrokontrollernek megfelelő sort. Ha több elem is szerepel a listában, és a választás nem egyértelmű, húzd ki a kártyát, és futtasd le újra a parancsot, a hiányzó elem a nyomtató alaplapod lesz(további információért lásd [GYIK](FAQ.md#wheres-my-serial-port)).

For common micro-controllers with STM32 or clone chips, LPC chips and others, it is usual that these need an initial Klipper flash via SD card.

When flashing with this method, it is important to make sure that the print board is not connected with USB to the host, due to some boards being able to feed power back to the board and stopping a flash from occurring.

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

Arguably the easiest way to set the Klipper configuration file is using the built-in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Egy másik lehetőség egy olyan asztali szerkesztő használata, amely támogatja a fájlok szerkesztését az „scp” és/vagy „sftp” protokollokon keresztül. Vannak szabadon elérhető eszközök, amelyek támogatják ezt (pl. Notepad++, WinSCP és Cyberduck). Töltsd be a nyomtató konfigurációs fájlját a szerkesztőbe, majd mentsd el a „printer.cfg” nevű fájlként a PI felhasználó home könyvtárába (pl. /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via SSH. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

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

After creating and editing the file, it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report that the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

A nyomtató konfigurációs fájljának testreszabásakor nem ritka, hogy a Klipper konfigurációs hibát jelez. Ha hiba lép fel, végezd el a szükséges javításokat a nyomtató konfigurációs fájljában, és add ki az "újraindítás" parancsot, amíg az "állapot" nem jelzi, hogy a nyomtató készen áll.

Klipper reports error messages via the command console and pop-ups in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located at `~/printer_data/logs/klippy.log`.

Miután a Klipper jelenti, hogy a nyomtató készen áll, folytasd a [konfigurációs ellenőrzés](Config_checks.md) című dokumentummal, hogy elvégezz néhány alapvető ellenőrzést a config fájlban lévő definíciókon. További információkért lásd a fő [dokumentációs hivatkozás](Overview.md) című rész.
