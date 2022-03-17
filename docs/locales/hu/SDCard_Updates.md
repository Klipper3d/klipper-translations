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

Ha nem látod az alaplapodat a listában, akkor lehet, hogy új alaplap definíciót kell hozzáadnod a [lentebb leírtak szerint](#board-definitions).

## Fejlett felhasználás

A fenti parancsok feltételezik, hogy az MCU az alapértelmezett 250000-es átviteli sebességgel csatlakozik, és a firmware a `~/klipper/out/klipper.bin` címen található. A `flash-sdcard.sh` szkript lehetőséget biztosít ezen alapértelmezések megváltoztatására. Az összes opciót a súgó képernyőn lehet megtekinteni:

```
./scripts/flash-sdcard.sh -h
SD Card upload utility for Klipper

usage: flash_sdcard.sh [-h] [-l] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -b <baud>       serial baud rate (default is 250000)
  -f <firmware>   path to klipper.bin
```

Ha az alaplapod olyan firmware-vel égetted, amely egyéni átviteli sebesség mellett csatlakozik, akkor a `-b` opció megadásával frissítheted:

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

Ha a Klipper egy, az alapértelmezett helytől eltérő helyen található készletét szeretné égetni, akkor ezt a `-f` opció megadásával teheti meg:

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

Ne feledje, hogy az MKS Robin E3 frissítésekor nem szükséges manuálisan futtatni a `update_mks_robin.py` fájlt, és az így kapott bináris állományt a `flash-sdcard.sh` fájlba táplálni. Ez az eljárás a feltöltési folyamat során automatikusan megtörténik.

## Óvintézkedések

- Ahogy a bevezetőben említettük, ez a módszer csak a firmware frissítésére alkalmas. A kezdeti égetési eljárást kézzel kell elvégezni az alaplapra vonatkozó utasítások szerint.
- Bár lehetséges a soros adatátvitelt vagy a csatlakozási interfészt (pl. USB-ről UART-ra) módosító készlet égetése, az ellenőrzés mindig sikertelen lesz, mivel a szkript nem tud újra csatlakozni az MCU-hoz az aktuális verzió ellenőrzéséhez.
- Csak azok a kártyák támogatottak, amelyek SPI-t használnak az SD-kártya kommunikációhoz. Az SDIO-t használó alaplapok, például a Flymaker Flyboard és az MKS Robin Nano V1/V2, nem működnek.

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
- `cs_pin`: Az SD-kártyához csatlakoztatott chipkiválasztó pin. Ezt a kártya kapcsolási rajzából kell visszakeresni. Ez a mező kötelező.
- `firmware_path`: Az SD-kártyán lévő elérési útvonal, ahová a firmware-t át kell vinni. Az alapértelmezett érték `firmware.bin`.
- `current_firmware_path` Az SD-kártyán lévő elérési útvonal, ahol az átnevezett firmware fájl található a sikeres flashelés után. Az alapértelmezett érték `firmware.cur`.

Ha szoftveres SPI szükséges, az `spi_bus` mezőt `swspi` értékre kell állítani, és a következő további mezőt kell megadni:

- `spi_pins`: Ennek 3 vesszővel elválasztott tűnek kell lennie, amelyek `miso,mosi,sclk` formátumban csatlakoznak az SD-kártyához.

Rendkívül ritkán van szükség a Software SPI-re, jellemzően csak a tervezési hibás lapok igénylik. A `btt-skr-pro` alaplap definíció erre ad példát.

Egy új alaplap definíció létrehozása előtt ellenőrizni kell, hogy egy meglévő alaplap definíció megfelel-e az új alaplap számára szükséges kritériumoknak. Ha ez a helyzet, akkor egy `BOARD_ALIAS` adható meg. Például a következő álnév adható hozzá `az én-új alaplapom` álneveként a `generic-lpc1768` meghatározásához:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Ha új alaplap definícióra van szükséged, és nem tetszik a fent leírt eljárás, akkor ajánlott, hogy a [Klipper Community Discord](Contact.md#discord) segítségével kérj egyet.
