# Beaglebone

Ez a dokumentum a Klipper futtatásának folyamatát írja le egy Beaglebone PRU-n.

## OS-képfájl készítése

Kezdd a [Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images) lemezkép telepítésével. A lemezképet futtathatjuk micro-SD kártyáról vagy beépített eMMC-ről is. Ha az eMMC-t használjuk, akkor most telepítsük az eMMC-re a fenti link utasításait követve.

Ezután lépj be SSH-n a Beaglebone gépre (`ssh debian@beaglebone` -- a jelszó `temppwd`) és telepítsd a Klippert a következő parancsok futtatásával:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-beaglebone.sh
```

## Octoprint telepítése

Ezután telepíthetjük az Octoprintet:

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

És állítsd be az OctoPrintet úgy, hogy az indításkor elinduljon:

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

Módosítani kell az OctoPrint **/etc/default/octoprint** konfigurációs fájlját. Meg kell változtatni a `OCTOPRINT_USER` felhasználót `debian`-ra, változtassuk meg a `NICELEVEL`-t `0`-ra, vegyük ki a `BASEDIR` megjegyzést, `CONFIGFILE`, és `DAEMON` beállításokat, és módosítsd a hivatkozásokat `/home/pi/`-ről `/home/debian/`-re:

```
sudo nano /etc/default/octoprint
```

Ezután indítsa el az Octoprint szolgáltatást:

```
sudo systemctl start octoprint
```

Győződj meg róla, hogy az OctoPrint webszerver elérhető - a következő címen kell lennie: <http://beaglebone:5000/>

## A mikrokontroller kódjának elkészítése

A Klipper mikrokontroller kódjának lefordításához kezdjük a "Beaglebone PRU" konfigurálásával:

```
cd ~/klipper/
make menuconfig
```

Az új mikrokontroller kódjának elkészítéséhez és telepítéséhez futtassa a következőt:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Szükséges továbbá a mikrokontroller kódjának lefordítása és telepítése egy Linux gazdafolyamathoz. Konfiguráld másodszor is egy "Linux folyamat" számára:

```
make menuconfig
```

Ezután telepítse ezt a mikrokontroller kódot is:

```
sudo service klipper stop
make flash
sudo service klipper start
```

## Hátralevő konfiguráció

Fejezze be a telepítést a Klipper és az Octoprint konfigurálásával a [Telepítés](Installation.md#configuring-klipper) fődokumentumban található utasítások szerint.

## Nyomtatás a Beaglebone-on

Sajnos a Beaglebone processzor néha nehezen tudja jól futtatni az OctoPrintet. Előfordult már, hogy összetett nyomtatásoknál a nyomtatás akadozott (a nyomtató gyorsabban mozog, mint ahogy az OctoPrint mozgatási parancsokat tud küldeni). Ha ez előfordul, fontolja meg a "virtual_sdcard" funkció használatát (a részletekért lásd a [konfigurációs hivatkozást](Config_Reference.md#virtual_sdcard)), hogy közvetlenül a Klipperből nyomtass.
