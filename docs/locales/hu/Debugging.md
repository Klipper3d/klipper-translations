# Hibakeresés

Ez a dokumentum a Klipper hibakeresési eszközeinek egy részét ismerteti.

## Regressziós tesztek futtatása

A Klipper GitHub fő tárolója a "github actions"-t használja egy sor regressziós teszt futtatásához. Hasznos lehet néhány ilyen tesztet helyben futtatni.

A forráskód "whitespace check" a következővel futtatható:

```
./scripts/check_whitespace.sh
```

A Klippy regressziós tesztcsomag számos platformról igényel "adatszótárakat". A legegyszerűbben úgy szerezhetjük be őket, ha [letöltjük őket a githubról](https://github.com/Klipper3d/klipper/issues/1438). Miután letöltöttük az adatszótárakat, a regressziós csomag futtatásához használjuk a következőket:

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## Parancsok kézi küldése a mikrokontrollernek

Normális esetben a G-kód parancsokat a klippy.py folyamat fordítja Klipper mikrokontroller parancsokra. Azonban az is lehetséges, hogy manuálisan küldjük el ezeket az MCU-parancsokat (a Klipper forráskódjában a DECL_COMMAND() makróval jelölt függvények). Ehhez futtasd a következőket:

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

Az eszközön belül a "HELP" parancsban találsz további információkat a funkcióiról.

Néhány parancssori opció is rendelkezésre áll. További információkért futtasd a: `~/klippy-env/bin/python ./klippy/console.py --help` parancsot

## A G-kód fájlok lefordítása mikrokontroller-parancsokra

A Klippy gazdagép kódja futhat kötegelt üzemmódban, hogy előállítsa a G-kód fájlhoz tartozó alacsony szintű mikrokontroller-parancsokat. Ezeknek az alacsony szintű parancsoknak a vizsgálata hasznos, amikor megpróbálod megérteni az alacsony szintű hardver műveleteit. Az is hasznos lehet, hogy összehasonlítsuk a mikrokontroller-parancsok közötti különbséget egy kódváltás után.

A Klippy futtatásához ebben a kötegelt üzemmódban egy egyszeri lépés szükséges a mikrokontroller "adatszótár" létrehozásához. Ez a mikrokontroller kódjának lefordításával történik, hogy megkapjuk az **out/klipper.dict** fájlt:

```
make menuconfig
make
```

Ha a fentiek megtörténtek, a Klipper futtatása batch üzemmódban is lehetséges (a [Telepítés](Installation.md) python virtuális környezet és a printer.cfg) fájl létrehozásához szükséges lépéseket lásd:

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

A fenti művelet egy **test.serial** fájlt fog létrehozni a bináris soros kimenettel. Ez a kimenet lefordítható olvasható szöveggé a következővel:

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

Az eredményül kapott **test.txt** fájl a mikrokontroller parancsok ember által olvasható listáját tartalmazza.

A kötegelt üzemmód letilt bizonyos válasz/kérés parancsokat a működés érdekében. Ennek eredményeképpen a tényleges parancsok és a fenti kimenet között némi eltérés lesz. A generált adatok teszteléshez és ellenőrzéshez hasznosak; nem használhatóak valódi mikrokontrollerhez való elküldésre.

## Mozgáselemzés és adatnaplózás

A Klipper támogatja a belső mozgástörténet naplózását, amely később elemezhető. Ennek a funkciónak a használatához a Klippert az [API Szerver](API_Server.md) engedélyezésével kell elindítani.

Az adatnaplózást a `data_logger.py` eszközzel lehet engedélyezni. Például:

```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog
```

Ez a parancs csatlakozik a Klipper API-kiszolgálóhoz, feliratkozik az állapot- és mozgásinformációkra, és naplózza az eredményeket. Két fájl jön létre. Egy tömörített adatfájl és egy indexfájl (pl. `mylog.json.gz` és `mylog.index.gz`). A naplózás elindítása után lehetőség van nyomtatások és egyéb műveletek elvégzésére. A naplózás a háttérben folytatódik. Ha befejeztük a naplózást, nyomjuk meg a `ctrl-c` billentyűkombinációt a `data_logger.py` eszközből való kilépéshez.

Az így kapott fájlok a `motan_graph.py` eszközzel olvashatók és grafikusan ábrázolhatók. A grafikonok Raspberry Pi-n történő generálásához egyszeri lépésben telepíteni kell a "matplotlib" csomagot:

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Kényelmesebb lehet azonban az adatfájlokat a `scripts/motan/` könyvtárban található Python-kóddal együtt egy asztali gépre másolni. A mozgáselemző szkripteknek minden olyan gépen futniuk kell, amelyre a [Python](https://python.org) és a [Matplotlib](https://matplotlib.org/) legújabb verziója telepítve van.

A grafikonok a következő parancs segítségével hozhatók létre:

```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

A `-g` opciót használhatjuk a grafikusan ábrázolandó adatkészletek megadására (ez egy Python literal-t fogad el, amely listák listáját tartalmazza). Például:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

Az elérhető adatkészletek listája a `-l` opcióval érhető el. Például:

```
~/klipper/scripts/motan/motan_graph.py -l
```

Lehetőség van arra is, hogy minden egyes adatkészlethez matplotlib ábrázolási opciókat adj meg:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```

Számos matplotlib opció áll rendelkezésre; néhány példa: "color", "label", "alpha" és "linestyle".

A `motan_graph.py` eszköz számos más parancssori opciót is támogat a `--help` opcióval megtekintheted a listát. Kényelmes lehet magát a [motan_graph.py](../scripts/motan/motan_graph.py) szkriptet is megtekinteni/módosítani.

A `data_logger.py` eszköz által előállított nyers adatnaplók az [API Szerver](API_Server.md) című dokumentumban leírt formátumot követik. Hasznos lehet az adatokat egy Unix-paranccsal megvizsgálni, mint például a következő: `gunzip < mylog.json.gz | tr '\03' '\n' | less`

## Terhelési grafikonok generálása

A Klippy naplófájl (/tmp/klippy.log) tárolja a sávszélességre, a mikrokontroller terhelésre és a gazdagép pufferterhelésre vonatkozó statisztikákat. Hasznos lehet ezeket a statisztikákat grafikusan ábrázolni a nyomtatás után.

A grafikon generálásához egy alkalommal telepíteni kell a "matplotlib" csomagot:

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Ezután grafikonok készíthetők:

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

Ezután megtekinthetjük az eredményül kapott **loadgraph.png** fájlt.

Különböző grafikonok készíthetők. További információért futtasd: `~/klipper/scripts/graphstats.py --help `

## Információk kinyerése a klippy.log fájlból

A Klippy naplófájl (/tmp/klippy.log) szintén tartalmaz hibakeresési információkat. Van egy logextract.py szkript, amely hasznos lehet egy mikrokontroller leállásának vagy hasonló problémának az elemzésekor. Általában valami ilyesmivel futtatható:

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

A szkript kinyeri a nyomtató konfigurációs fájlját, és kinyeri az MCU leállítási adatait. Az MCU leállításából származó információsor (ha van ilyen) időbélyegek szerint át lesz rendezve, hogy segítse az ok-okozati forgatókönyvek diagnosztizálását.

## Tesztelés simulavr-rel

A [simulavr](http://www.nongnu.org/simulavr/) eszköz lehetővé teszi egy Atmel ATmega mikrokontroller szimulálását. Ez a szakasz leírja, hogyan lehet teszt G-kód fájlokat futtatni a simulavr segítségével. Javasoljuk, hogy ezt egy asztali gépen futtasd (nem Raspberry Pi), mivel a hatékony futtatáshoz erős CPU-ra van szükség.

A simulavr használatához töltsd le a simulavr csomagot, és fordítsd le python támogatással. Vedd figyelembe, hogy a build rendszernek telepítenie kell néhány csomagot (például a swig-et) ahhoz, hogy a python modult fel tudja építeni.

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```

Győződjünk meg róla, hogy a fenti fordítás után a **./build/pysimulavr/_pysimulavr.*.so** fájl jött létre:

```
ls ./build/pysimulavr/_pysimulavr.*.so
```

Ennek a parancsnak egy adott fájlt (például **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**) kell jelentenie, nem pedig hibát.

Ha Debian-alapú rendszert használsz (Debian, Ubuntu, stb.), akkor telepítheted a következő csomagokat, és *.deb fájlokat generálhatsz a simulavr rendszerszintű telepítéséhez:

```
sudo apt update
sudo apt install g++ make cmake swig rst2pdf help2man texinfo
make cfgclean python debian
sudo dpkg -i build/debian/python3-simulavr*.deb
```

A Klipper lefordításához a simulavr-ben való használathoz futtasd a következőt:

```
cd /path/to/klipper
make menuconfig
```

és fordítsd le a mikrokontroller szoftvert egy AVR atmega644p számára, és válaszd a SIMULAVR szoftver emulációs támogatást. Ezután lefordíthatjuk a Klippert (futtassuk `make`), majd indítsuk el a szimulációt a következőkkel:

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

Vegyük észre, hogy ha a python3-simulavr-t az egész rendszerre telepítettük, akkor nem kell beállítanunk a `PYTHONPATH` értéket, és egyszerűen futtathatjuk a szimulátort mint

```
./scripts/avrsim.py out/klipper.elf
```

Ezután, ha a simulavr egy másik ablakban fut, futtathatjuk a következőt, hogy G-kódot olvassunk be egy fájlból (pl. "test.gcode"), feldolgozzuk a Klippy-vel, és elküldjük a simulavr-ben futó Klipper-nek (lásd [Telepítés](Installation.md) a python virtuális környezet létrehozásához szükséges lépéseket):

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### A simulavr használata gtkwave-vel

A simulavr egyik hasznos funkciója, hogy képes jelhullámgeneráló fájlokat létrehozni az események pontos időzítésével. Ehhez kövesd a fenti utasításokat, de futtasd az avrsim.py programot a következő parancssorral:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

A fentiek létrehoznak egy **avrsim.vcd** fájlt a PORTA és PORTB GPIO-k minden egyes módosításával kapcsolatos információkkal. Ezt aztán a gtkwave segítségével meg lehetne nézni a következővel:

```
gtkwave avrsim.vcd
```
