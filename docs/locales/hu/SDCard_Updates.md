# SD-kártya frissítések

A manapság népszerű vezérlőlapok közül sokan olyan bootloaderrel rendelkeznek, amely képes a firmware SD-kártyán keresztül történő frissítésére. Bár ez sok esetben kényelmes, ezek a bootloaderek általában nem biztosítanak más módot a firmware frissítésére. Ez kellemetlen lehet, ha a kártyaolvasót úgy helyezték, hogy nehéz hozzáférni, főleg ha gyakran kell frissíteni a firmware-t. Miután a Klipper eredetileg egy vezérlőre lett égetve, lehetőség van az új firmware átvitelére az SD-kártyára, és a égetési eljárás elindítására SSH-n keresztül.

## Tipikus frissítési eljárás

Az MCU firmware SD-kártya használatával történő frissítésének menete hasonló a többi módszerhez. A `make flash` használata helyett egy segédszkriptet kell futtatni, `flash-sdcard.sh`. Egy BigTreeTech SKR 1.3 frissítése a következőképpen néz ki:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-skr-v1.3
sudo service klipper start
```

Az eszköz helyének és az alaplap nevének meghatározása a felhasználó feladata. Ha a felhasználónak több alaplapot kell égetnie, akkor a Klipper szolgáltatás újraindítása előtt a `flash-sdcard.sh` (vagy `make flash`, ha szükséges) programot kell futtatni minden egyes alaplaphoz.

A támogatott alaplapok a következő paranccsal listázhatók:

```
./scripts/flash-sdcard.sh -l
```

Ha nem látod az alaplapodat a listában, akkor lehet, hogy új alaplap definíciót kell hozzáadnod a [lentebb leírtak szerint](#alaplap-definiciok).

## Fejlett felhasználás

A fenti parancsok feltételezik, hogy az MCU az alapértelmezett 250000-es átviteli sebességgel csatlakozik, és a firmware a `~/klipper/out/klipper.bin` címen található. A `flash-sdcard.sh` szkript lehetőséget biztosít ezen alapértelmezések megváltoztatására. Az összes opciót a súgó képernyőn lehet megtekinteni:

```
./scripts/flash-sdcard.sh -h
SD-kártya feltöltő segédprogram Klipperhez

használat: flash_sdcard.sh [-h] [-l] [-c] [-b <baud>] [-f <firmware>]
                       <device> <board>

pozicionális argumentumok:
  <device>         eszköz soros port
  <board>          alaplap típus

opcionális argumentumok:
  -h              mutatja az üzenetet
  -l              listázza a rendelkezésre álló kártyákat
  -c              csak a flash ellenőrzés/ellenőrzés futtatása (a feltöltést kihagyja)
  -b <baud>       soros átviteli sebesség (alapértelmezett 250000)
  -f <firmware>   a klipper.bin elérési útja
```

Ha az alaplapod olyan firmware-vel égetted, amely egyéni átviteli sebesség mellett csatlakozik, akkor a `-b` opció megadásával frissítheted:

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

Ha a Klipper egy, az alapértelmezett helytől eltérő helyen található készletét szeretnéd égetni, akkor ezt a `-f` opció megadásával teheti meg:

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

Ne feledd, hogy az MKS Robin E3 frissítésekor nem szükséges manuálisan futtatni az `update_mks_robin.py` fájlt, és az így kapott bináris állományt a `flash-sdcard.sh` fájlba táplálni. Ez az eljárás a feltöltési folyamat során automatikusan megtörténik.

A `-c` opcióval egy ellenőrző vagy csak ellenőrzésre szolgáló műveletet végezhetsz, amellyel tesztelheted, hogy a kártya helyesen futtatja-e a megadott firmware-t. Ezt az opciót elsősorban olyan esetekre szánjuk, amikor kézi bekapcsolás szükséges az égetési eljárás befejezéséhez, például olyan bootloaderek esetében, amelyek SDIO módot használnak SPI helyett az SD-kártyák elérésekor. (Lásd a figyelmeztetéseket alább.) De bármikor használható annak ellenőrzésére is, hogy a kártyára égetett kód megegyezik-e a build mappában lévő verzióval bármely támogatott kártyán.

## Óvintézkedések

- Ahogy a bevezetőben említettük, ez a módszer csak a firmware frissítésére alkalmas. A kezdeti égetési eljárást kézzel kell elvégezni az alaplapra vonatkozó utasítások szerint.
- Bár lehetséges a soros adatátvitelt vagy a csatlakozási interfészt (pl. USB-ről UART-ra) módosító készlet égetése, az ellenőrzés mindig sikertelen lesz, mivel a szkript nem tud újra csatlakozni az MCU-hoz az aktuális verzió ellenőrzéséhez.
- Csak az SD-kártya SPI kommunikációt használó alaplapok támogatottak. Az SDIO-t használó alaplapok, mint például a Flymaker Flyboard és az MKS Robin Nano V1/V2, nem működnek SDIO módban. Az ilyen alaplapok azonban általában a szoftveres SPI mód használatával égethetők. Ha azonban az alaplap bootloadere csak SDIO módot használ az SD-kártya eléréséhez, akkor az alaplap és az SD-kártya bekapcsolása szükséges ahhoz, hogy az SPI-ről vissza tudjon állni SDIO módra az újrafrissítés befejezéséhez. Az ilyen alaplapokat a `skip_verify` engedélyezésével kell definiálni, hogy az égetés után azonnal kihagyható legyen a verify lépés. Ezután a kézi bekapcsolás után újra lefuttathatod pontosan ugyanazt a `./scripts/flash-sdcard.sh` parancsot, de hozzáadhatod a `-c` opciót az ellenőrzés/ellenőrzés művelet befejezéséhez. Példákért lásd az [SDIO-val égető alaplapok](#flashing-boards-that-use-sdio) részt.

## Alaplap definíciók

A legtöbb általános alaplapnak rendelkezésre kell állnia, azonban szükség esetén új alaplap definíciót is hozzáadhat. Az alaplapdefiníciók a `~/klipper/scripts/spi_flash/board_defs.py` állományban találhatók. A definíciókat például lexikonban tároljuk:

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<further definitions>
}
```

A következő mezők adhatók meg:

- `mcu`: Az mcu típusa. Ezt a készlet `make menuconfig` segítségével történő konfigurálása után a `cat .config | grep CONFIG_MCU` futtatásával lehet visszakeresni. Ez a mező kötelezően kitöltendő.
- `spi_bus`: Az SD-kártyához csatlakoztatott SPI-busz. Ezt a tábla kapcsolási rajzából kell visszakeresni. Ez a mező kötelező.
- `cs_pin`: Az SD-kártyához csatlakoztatott chipkiválasztó tű. Ezt a kártya kapcsolási rajzából kell visszakeresni. Ez a mező kötelező.
- `firmware_path`: Az SD-kártyán lévő elérési útvonal, ahová a firmware-t át kell vinni. Az alapértelmezett érték `firmware.bin`.
- `current_firmware_path`: Az SD-kártyán lévő elérési útvonal, ahol az átnevezett firmware fájl található a sikeres égetés után. Az alapértelmezett név: `firmware.cur`.
- `skip_verify`: Ez egy logikai értéket határoz meg, amely a szkripteknek azt mondja meg, hogy hagyja ki a firmware ellenőrzésének lépését az égetési folyamat során. Az alapértelmezett érték `False`. Ez az érték `True` értékre állítható olyan kártyák esetében, amelyeknél az égetés befejezéséhez kézi bekapcsolás szükséges. A firmware utólagos ellenőrzéséhez futtasd újra a szkriptet a `-c` opcióval, hogy elvégezd az ellenőrzési lépést. [Lásd az SDIO kártyákkal kapcsolatos figyelmeztetéseket](#caveats)

Ha szoftveres SPI-re van szükség, az `spi_bus` mezőt `swspi` és a következő kiegészítő mezőt kell megadni:

- `spi_pins`: Ennek 3 vesszővel elválasztott tűnek kell lennie, amelyek `miso,mosi,sclk` formátumban csatlakoznak az SD-kártyához.

Rendkívül ritkán van szükség a szoftveres SPI-re, jellemzően csak a tervezési hibás vagy az SD-kártyájuk SDIO módját támogató kártyáknál lesz rá szükség. A `btt-skr-pro` alaplap definíciója az előbbire ad példát, a `btt-octopus-f446-v1` alaplap definíciója pedig az utóbbira.

Egy új alaplap definíció létrehozása előtt ellenőrizni kell, hogy egy meglévő alaplap definíció megfelel-e az új alaplap számára szükséges kritériumoknak. Ha ez a helyzet, akkor egy `BOARD_ALIAS` adható meg. Például a következő álnév adható hozzá `az én-új alaplapom` álneveként a `generic-lpc1768` meghatározásához:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Ha új alaplap definícióra van szükséged, és nem tetszik a fent leírt eljárás, akkor ajánlott, hogy a [Klipper Közösségi Discord](Contact.md#discord) segítségével kérj egyet.

## SDIO-val égető alaplapok

[Ahogyan a figyelmeztetések](#caveats) is említik, azok az alaplapok, amelyek bootloadere SDIO módot használ az SD-kártyához való hozzáféréshez, az alaplapot, és különösen magát az SD-kártyát ki kell kapcsolni, hogy a fájl SD-kártyára írása közben használt SPI módból vissza lehessen váltani SDIO módba, hogy a bootloader be tudja égetni az alaplapra. Ezek az alaplap definíciók a `skip_verify` flag-et használják, amely azt mondja az égető eszköznek, hogy álljon le a firmware SD-kártyára írása után, hogy az alaplapot kézzel lehessen bekapcsolni, és az ellenőrzés lépését elhalasztani, amíg ez be nem fejeződik.

Két forgatókönyv van -- az egyik, amikor az RPi Gazdagép külön tápegységről megy, a másik, amikor az RPi Gazdagép ugyanazon tápegységről megy, mint az égetni kívánt alaplap. A különbség az, hogy az égetés befejezése után le kell-e kapcsolni az RPi-t is, majd újra `ssh`, hogy elvégezhessük az ellenőrző lépést, vagy az ellenőrzés azonnal elvégezhető. Íme példák a két forgatókönyvre:

### SDIO programozás RPi-vel külön tápegységgel

Egy tipikus munkamenet az RPi-vel egy különálló tápegységen a következőképpen néz ki. Természetesen a megfelelő eszköz elérési útvonalát és az alaplap nevét kell használnod:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
[[[manually power-cycle the printer board here when instructed]]]
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

### SDIO programozás RPi-vel ugyanazon tápegységgel

Egy tipikus munkamenet az RPi-vel ugyanazon a tápegységen a következőképpen néz ki. Természetesen a megfelelő eszköz elérési útvonalát és az alaplap nevét kell használnod:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
sudo shutdown -h now
[[[wait for the RPi to shutdown, then power-cycle and ssh again to the RPi when it restarts]]]
sudo service klipper stop
cd ~/klipper
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

Ebben az esetben, mivel az RPi Gazdagép újraindul, ami újraindítja a `klipper` szolgáltatást, az ellenőrzés lépése előtt újra le kell állítani a `klipper` szolgáltatást, és az ellenőrzés befejezése után újra kell indítani.

### SDIO-ból SPI-re lábkiosztás

Ha az alaplap kapcsolási rajza SDIO-t használ az SD-kártyához, akkor az alábbi táblázatban leírtak szerint lekérheted a tűket, hogy meghatározhasd a `board_defs.py` fájlban hozzárendelendő kompatibilis szoftver SPI tűit:

| SD-kártya tű | Micro SD-kártya tű | SDIO tű neve | SPI tű neve |
| :-: | :-: | :-: | :-: |
| 9 | 1 | DATA2 | None (PU)* |
| 1 | 2 | CD/DATA3 | CS |
| 2 | 3 | CMD | MOSI |
| 4 | 4 | +3.3V (VDD) | +3.3V (VDD) |
| 5 | 5 | CLK | SCLK |
| 3 | 6 | GND (VSS) | GND (VSS) |
| 7 | 7 | DATA0 | MISO |
| 8 | 8 | DATA1 | None (PU)* |
| N/A | 9 | Card Detect (CD) | Card Detect (CD) |
| 6 | 10 | GND | GND |

\* None (PU) egy nem használt, felhúzási ellenállással ellátott tűt jelez.
