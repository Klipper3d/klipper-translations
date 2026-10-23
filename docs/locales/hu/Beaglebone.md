# Beaglebone

Ez a dokumentum a Klipper futtatásának folyamatát írja le egy Beaglebone PRU-n.

## OS-képfájl készítése

Kezdd a [Debian 11.7 2023-09-02 4GB microSD IoT](https://beagleboard.org/latest-images) lemezkép telepítésével. A lemezképet futtathatjuk micro-SD kártyáról vagy beépített eMMC-ről is. Ha az eMMC-t használjuk, akkor telepítsük az eMMC-re a fenti link utasításait követve.

Ezután lépj be SSH-n a Beaglebone gépre (`ssh debian@beaglebone` -- a jelszó `temppwd`).

A Klipper telepítése előtt további helyet kell felszabadítani. Erre 3 lehetőség van:

1. néhány BeagleBone "Demo" erőforrás eltávolítása
1. ha az SD-kártyáról bootoltál, és ez nagyobb, mint 4Gb - bővítheted a jelenlegi fájlrendszert, hogy a teljes területet használhasd
1. az 1. és a 2. lehetőséget együtt kell elvégezni.

Néhány BeagleBone "Demo" erőforrás eltávolításához hajtsd végre a következő parancsokat

```
sudo apt remove bb-node-red-installer
sudo apt remove bb-code-server
```

A SD-kártya fájlrendszer teljes méretére történő bővítéséhez hajtsd végre ezt a parancsot, újraindítás nem szükséges.

```
sudo growpart /dev/mmcblk0 1
sudo resize2fs /dev/mmcblk0p1
```

Telepítsd a Klippert a következő parancsok futtatásával:

```
git clone https://github.com/Klipper3d/klipper.git
./klipper/scripts/install-beaglebone.sh
```

A Klipper telepítése után el kell döntened, hogy milyen telepítésre van szükséged, de vedd figyelembe, hogy a BeagleBone 3.3v alapú hardver, és a legtöbb esetben nem lehet közvetlenül csatlakoztatni a tűket 5v vagy 12v alapú hardverhez átalakító lapok nélkül.

Mivel a Klipper többmodulos architektúrával rendelkezik a BeagleBone-on, számos különböző felhasználási esetet lehet megvalósítani, de az általánosak a következők:

1. felhasználási eset: A BeagleBone-t csak gazdagépként használjuk a Klipper és további szoftverek, mint az OctoPrint/Fluidd + Moonraker/... futtatására, és ez a konfiguráció külső mikrovezérlőket fog vezérelni soros/usb/canbus kapcsolatokon keresztül.

2. felhasználási eset: BeagleBone használata bővítőkártyával (köpeny), mint a CRAMPS deszka. Ebben a konfigurációban a BeagleBone a Klipper + további szoftvereket fog fogadni, és a BeagleBone PRU magokkal (2 további mag 200Mh, 32Bit) meghajtja a bővítőkártyát.

3. felhasználási eset: Ugyanaz, mint az "1. felhasználási eset", de emellett a BeagleBone GPIO-kat nagy sebességgel fogja meghajtani a PRU magok felhasználásával a fő CPU tehermentesítésére.

## Octoprint telepítése

Ezután telepítheted az Octoprint-et, vagy kihagyhatod ezt a lépést, ha más szoftvert szeretnél:

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

Ezután indítsd el az Octoprint szolgáltatást:

```
sudo systemctl start octoprint
```

Várj 1-2 percet, és győződj meg róla, hogy az OctoPrint webszerver elérhető - a következő címen kell lennie: <http://beaglebone:5000/>

## A BeagleBone PRU mikrokontroller kódjának elkészítése (PRU firmware)

Ez a szakasz a fent említett "2. használati eset" és "3. használati eset" esetében szükséges, az "1. használati eset" esetében kihagyható.

Ellenőrizd a szükséges eszközök meglétét

```
sudo beagle-version
```

Ellenőrizd, hogy a kimenet tartalmazza a sikeres "remoteproc" illesztőprogramok betöltését és a PRU magok jelenlétét, a Kernel 5.10-ben ezeknek "remoteproc1" és "remoteproc2" (4a334000.pru, 4a338000.pru) kell lenniük. Ellenőrizd azt is, hogy sok GPIO betöltődött-e. Úgy fog kinézni, mint "Allocated GPIO id=0 name='P8_03'" Általában minden rendben van, és nincs szükség hardver konfigurációra. Ha valami hiányzik - próbálj meg játszani az "uboot overlays" opciókkal vagy a cape-overlays-szel. Csak referenciaként néhány kimenet a működő BeagleBone Black konfigurációról a CRAMPS táblával:

```
model:[TI_AM335x_BeagleBone_Black]
UBOOT: Booted Device-Tree:[am335x-boneblack-uboot-univ.dts]
UBOOT: Loaded Overlay:[BB-ADC-00A0.bb.org-overlays]
UBOOT: Loaded Overlay:[BB-BONE-eMMC1-01-00A0.bb.org-overlays]
kernel:[5.10.168-ti-r71]
/boot/uEnv.txt Settings:
uboot_overlay_options:[enable_uboot_overlays=1]
uboot_overlay_options:[disable_uboot_overlay_video=0]
uboot_overlay_options:[disable_uboot_overlay_audio=1]
uboot_overlay_options:[disable_uboot_overlay_wireless=1]
uboot_overlay_options:[enable_uboot_cape_universal=1]
pkg:[bb-cape-overlays]:[4.14.20210821.0-0~bullseye+20210821]
pkg:[bb-customizations]:[1.20230720.1-0~bullseye+20230720]
pkg:[bb-usb-gadgets]:[1.20230414.0-0~bullseye+20230414]
pkg:[bb-wl18xx-firmware]:[1.20230414.0-0~bullseye+20230414]
.............
.............
```

A Klipper mikrokontroller kódjának lefordításához kezd a "Beaglebone PRU" konfigurálásával, a "BeagleBone Black" esetében kapcsold ki a "Support GPIO Bit-banging devices" és a "Support LCD devices" opciót az "Optional features" menüben, mert ezek nem férnek el a 8Kb PRU firmware memóriában, majd lépj ki és mentsd a konfigurációt:

```
cd ~/klipper/
make menuconfig
```

Az új PRU mikrokontroller kódjának elkészítéséhez és telepítéséhez futtasd a következőt:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Az előző parancsok végrehajtása után a PRU firmware-nek készen kell állnia, és el kell kezdenie ellenőrizni, hogy minden rendben volt-e. A következő parancsot hajthatod végre

```
dmesg
```

és hasonlítsd össze az utolsó üzeneteket a mintával, amely azt jelzi, hogy minden rendben elindult:

```
[   71.105499] remoteproc remoteproc1: 4a334000.pru is available
[   71.157155] remoteproc remoteproc2: 4a338000.pru is available
[   73.256287] remoteproc remoteproc1: powering up 4a334000.pru
[   73.279246] remoteproc remoteproc1: Booting fw image am335x-pru0-fw, size 97112
[   73.285807]  remoteproc1#vdev0buffer: registered virtio0 (type 7)
[   73.285836] remoteproc remoteproc1: remote processor 4a334000.pru is now up
[   73.286322] remoteproc remoteproc2: powering up 4a338000.pru
[   73.313717] remoteproc remoteproc2: Booting fw image am335x-pru1-fw, size 188560
[   73.313753] remoteproc remoteproc2: header-less resource table
[   73.329964] remoteproc remoteproc2: header-less resource table
[   73.348321] remoteproc remoteproc2: remote processor 4a338000.pru is now up
[   73.443355] virtio_rpmsg_bus virtio0: creating channel rpmsg-pru addr 0x1e
[   73.443727] virtio_rpmsg_bus virtio0: msg received with no recipient
[   73.444352] virtio_rpmsg_bus virtio0: rpmsg host is online
[   73.540993] rpmsg_pru virtio0.rpmsg-pru.-1.30: new rpmsg_pru device: /dev/rpmsg_pru30
```

vedd figyelembe a "/dev/rpmsg_pru30" - ez a jövőbeli soros eszköz a fő MCU konfigurációhoz, ennek az eszköznek jelen kell lennie, ha hiányzik - a PRU magok nem indulnak el megfelelően.

## Linux gazdagép mikrokontroller kódjának létrehozása és telepítése

Ez a szakasz a "2. használati eset" esetében kötelező, a fent említett "3. használati eset" esetében pedig nem kötelező

Szükséges továbbá a mikrokontroller kódjának lefordítása és telepítése egy Linux gazdafolyamathoz. Konfiguráld másodszor is egy "Linux folyamat" számára:

```
make menuconfig
```

Ezután telepítsd ezt a mikrokontroller kódot is:

```
sudo service klipper stop
make flash
sudo service klipper start
```

jegyezd meg a "/tmp/klipper_host_mcu" - ez lesz a jövőbeli soros eszközöd az "mcu host" számára, ha ez a fájl nem létezik - lásd a "scripts/klipper-mcu.service" fájlt, az előző parancsok telepítették, és ez a felelős érte.

A "2. felhasználási eset" esetében jegyezd meg a következőket: amikor a nyomtató konfigurációját határozod meg, mindig az "mcu host" hőmérséklet-érzékelőit kell használni, mivel az ADC-k nincsenek jelen az alapértelmezett "mcu"-ban (PRU magok). A "sensor_pin" mintakonfigurációja az extruder és a fűtött ágy számára elérhető a "generic-cramps.cfg"-ben. Bármely más GPIO-t használhatsz közvetlenül az "mcu host"-ból, ha így hivatkozol rájuk: "host:gpiochip1/gpio17", de ezt kerülni kell, mert ez további terhelést jelent a fő CPU-ra, és valószínűleg nem tudja használni a léptető vezérlésére.

## Hátralevő konfiguráció

Complete the installation by configuring Klipper following the instructions in the main [Installation](Installation.md#configuring-klipper) document.

## Nyomtatás a Beaglebone-on

Sajnos a Beaglebone processzor néha nehezen tudja jól futtatni az OctoPrintet. Előfordult már, hogy összetett nyomtatásoknál a nyomtatás akadozott (a nyomtató gyorsabban mozog, mint ahogy az OctoPrint mozgatási parancsokat tud küldeni). Ha ez előfordul, fontold meg a „virtual_sdcard” funkció használatát (a részletekért lásd a [Konfigurációs referencia](Config_Reference.md#virtual_sdcard)) pontot, hogy közvetlenül a Klipperből nyomtass, és kapcsold ki a DEBUG vagy VERBOSE naplózási opciókat, ha engedélyezted őket.

## AVR mikrovezérlő kód építése

Ez a környezet mindent tartalmaz a szükséges mikrokontroller kód építéséhez, kivéve az AVR-t. Az AVR csomagok eltávolításra kerültek a PRU csomagokkal való konfliktus miatt. Ha még mindig AVR mikrokontroller kódot akarsz építeni ebben a környezetben, akkor el kell távolítanod a PRU csomagokat és telepítened kell az AVR csomagokat a következő parancsok végrehajtásával

```
sudo apt-get remove gcc-pru
sudo apt-get install avrdude gcc-avr binutils-avr avr-libc
```

ha vissza kell állítani a PRU csomagokat - akkor előtte távolítsd el az AVR csomagokat

```
sudo apt-get remove avrdude gcc-avr binutils-avr avr-libc
sudo apt-get install gcc-pru
```

## Hardver tű megjelölés

A BeagleBone nagyon rugalmas a tűk kijelölése szempontjából, ugyanaz a tű különböző funkciókhoz konfigurálható, de mindig egyetlen funkciót egyetlen tűhöz, ugyanaz a funkció különböző tűkön is jelen lehet. Tehát nem lehet több funkció egyetlen tűn, vagy ugyanaz a funkció több tűn. Példa: P9_20 - i2c2_sda/can0_tx/spi1_cs0/gpio0_12/uart1_ctsn P9_19 - i2c2_scl/can0_rx/spi1_cs1/gpio0_13/uart1_rtsn P9_24 - i2c1_scl/can1_rx/gpio0_15/uart1_tx P9_26 - i2c1_sda/can1_tx/gpio0_14/uart1_rx

A TŰK kijelölése speciális "overlay"-ek használatával történik, amelyek a Linux indításakor töltődnek be. Ezeket a /boot/uEnv.txt fájl szerkesztésével lehet beállítani, megnövelt jogosultságokkal

```
sudo editor /boot/uEnv.txt
```

és annak meghatározása, hogy melyik funkciót kell betölteni, például a CAN1 engedélyezéséhez meg kell határozni az overlay-t

```
uboot_overlay_addr4=/lib/firmware/BB-CAN1-00A0.dtbo
```

Ez az overlay BB-CAN1-00A0.dtbo átkonfigurálja a CAN1 összes szükséges tűjét, és létrehozza a CAN eszközt Linux-ban. Az overlay-ek bármilyen módosítása a rendszer újraindítását igényli. Ha megérted, hogy mely tűk vesznek részt valamelyik overlay-ben - elemezheted a forrásfájlokat ezen a helyen: /opt/sources/bb.org-overlays/src/arm/ vagy keress információt a BeagleBone fórumokon.

## Hardver SPI engedélyezése

A BeagleBone általában több hardveres SPI busszal rendelkezik, például a BeagleBone Black 2 ilyen busz van, ezek akár 48Mhz-ig is működhetnek, de általában 16Mhz-re korlátozza őket a Kernel Device-tree. Alapértelmezés szerint a BeagleBone Black-ben néhány SPI1 pin HDMI-Audio kimenetre van konfigurálva, a 4-vezetékes SPI1 teljes engedélyezéséhez ki kell kapcsolni a HDMI Audio-t és engedélyezni kell az SPI1-et. Ehhez a /boot/uEnv.txt fájlt kell szerkeszteni megnövelt jogosultságokkal

```
sudo editor /boot/uEnv.txt
```

változó feloldása

```
disable_uboot_overlay_audio=1
```

a következő változót ki kell kommentelni, és így kell definiálni

```
uboot_overlay_addr4=/lib/firmware/BB-SPIDEV1-00A0.dtbo
```

Mentsd a változtatásokat a /boot/uEnv.txt állományba, és indítsd újra az alaplapot. Most már az SPI1 engedélyezve van, a jelenlétének ellenőrzéséhez hajtsd végre a következő parancsot

```
ls /dev/spidev1.*
```

Vedd figyelembe, hogy a BeagleBone általában 3,3V alapú hardver, és az 5V-os SPI eszközök használatához szintváltó chipet kell hozzáadni, például SN74CBTD3861, SN74LVC1G34 vagy hasonló. Ha CRAMPS táblát használ - ez már tartalmaz Level-Shifting chipet és SPI1 tűk elérhetővé válnak a P503 porton, és elfogadják az 5V hardvert, ellenőrizd a CRAMPS tábla kapcsolási rajzát a tű-referenciákért.

## Hardver I2C engedélyezése

A BeagleBone rendszerint több hardveres I2C buszokkal rendelkezik, például a BeagleBone Black 3 ilyen buszokkal rendelkezhet, amelyek támogatják a 400Kbit gyors üzemmódig terjedő sebességet. Alapértelmezés szerint a BeagleBone Blackben kettő van belőlük (i2c-1 és i2c-2) általában mindkettő már konfigurálva van és jelen van a P9-en, a harmadik i2c-0 általában belső használatra van fenntartva. Ha CRAMPS lapot használsz, akkor az i2c-2 a P303 porton van jelen 3,3V-os szinten, Ha az I2c-1-et a CRAMPS lapon szeretnéd használni - az Extruder1.Step, Extruder1.Dir tűkön kaphatod meg őket, ezek szintén 3,3V alapúak, nézd meg a CRAMPS lap kapcsolási rajzát a tű-referenciákért. Kapcsolódó átfedések, a [Hardver tű megnevezés](#hardware-pin-designation): I2C1(100Kbit): BB-I2C1-00A0.dtbo I2C1(400Kbit): BB-I2C1-FAST-00A0.dtbo I2C2(100Kbit): BB-I2C2-00A0.dtbo I2C2(400Kbit): BB-I2C2-FAST-00A0.dtbo

## Hardveres UART(Soros)/CAN aktiválása

A BeagleBone akár 6 hardveres UART(Soros) busz (akár 3Mbit) és akár 2 hardveres CAN(1Mbit) busz. UART1(RX,TX) és CAN1(TX,RX) és I2C2(SDA,SCL) ugyanazokat a tűket használják - így ki kell választanod, hogy mit használjon UART1(CTSN,RTSN) és CAN0(TX,RX) és I2C1(SDA,SCL) ugyanazokat a tűket használják - így ki kell választanod, hogy mit használjon. Minden UART/CAN kapcsolódó tű 3.3V alapú, így olyan adó-vevő chipeket/lapokat kell használnod, mint az SN74LVC2G241DCUR (UART-hoz), SN65HVD230 (CAN-hez), TTL-RS485 (RS-485-hez) vagy valami hasonlót, amely képes a 3.3V jeleket megfelelő szintre konvertálni.

Kapcsolódó overlay-ek, a [Hardver Tű-megjelölés](#hardware-pin-designation) esetén CAN0: BB-CAN0-00A0.dtbo CAN1: BB-CAN1-00A0.dtbo UART0: - a konzol számára UART1(RX,TX): BB-UART3-00A0.dtbo UART4(RS-485): BB-UART4-RS485-00A0.dtbo UART5(RX,TX): BB-UART5-00A0.dtbo
