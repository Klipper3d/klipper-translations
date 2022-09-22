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
SD Card upload utility for Klipper

usage: flash_sdcard.sh [-h] [-l] [-c] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -c              run flash check/verify only (skip upload)
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

The `-c` option is used to perform a check or verify-only operation to test if the board is running the specified firmware correctly. This option is primarily intended for cases where a manual power-cycle is necessary to complete the flashing procedure, such as with bootloaders that use SDIO mode instead of SPI to access their SD Cards. (See Caveats below) But, it can also be used anytime to verify if the code flashed into the board matches the version in your build folder on any supported board.

## Óvintézkedések

- Ahogy a bevezetőben említettük, ez a módszer csak a firmware frissítésére alkalmas. A kezdeti égetési eljárást kézzel kell elvégezni az alaplapra vonatkozó utasítások szerint.
- Bár lehetséges a soros adatátvitelt vagy a csatlakozási interfészt (pl. USB-ről UART-ra) módosító készlet égetése, az ellenőrzés mindig sikertelen lesz, mivel a szkript nem tud újra csatlakozni az MCU-hoz az aktuális verzió ellenőrzéséhez.
- Only boards that use SPI for SD Card communication are supported. Boards that use SDIO, such as the Flymaker Flyboard and MKS Robin Nano V1/V2, will not work in SDIO mode. However, it's usually possible to flash such boards using Software SPI mode instead. But if the board's bootloader only uses SDIO mode to access the SD Card, a power-cycle of the board and SD Card will be necessary so that the mode can switch from SPI back to SDIO to complete reflashing. Such boards should be defined with `skip_verify` enabled to skip the verify step immediately after flashing. Then after the manual power-cycle, you can rerun the exact same `./scripts/flash-sdcard.sh` command, but add the `-c` option to complete the check/verify operation. See [Flashing Boards that use SDIO](#flashing-boards-that-use-sdio) for examples.

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
- `current_firmware_path`: The path on the SD Card where the renamed firmware file is located after a successful flash. The default is `firmware.cur`.
- `skip_verify`: This defines a boolean value which tells the scripts to skip the firmware verification step during the flashing process. The default is `False`. It can be set to `True` for boards that require a manual power-cycle to complete flashing. To verify the firmware afterward, run the script again with the `-c` option to perform the verification step. [See caveats with SDIO cards](#caveats)

If software SPI is required, the `spi_bus` field should be set to `swspi` and the following additional field should be specified:

- `spi_pins`: Ennek 3 vesszővel elválasztott tűnek kell lennie, amelyek `miso,mosi,sclk` formátumban csatlakoznak az SD-kártyához.

It should be exceedingly rare that Software SPI is necessary, typically only boards with design errors or boards that normally only support SDIO mode for their SD Card will require it. The `btt-skr-pro` board definition provides an example of the former, and the `btt-octopus-f446-v1` board definition provides an example of the latter.

Egy új alaplap definíció létrehozása előtt ellenőrizni kell, hogy egy meglévő alaplap definíció megfelel-e az új alaplap számára szükséges kritériumoknak. Ha ez a helyzet, akkor egy `BOARD_ALIAS` adható meg. Például a következő álnév adható hozzá `az én-új alaplapom` álneveként a `generic-lpc1768` meghatározásához:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Ha új alaplap definícióra van szükséged, és nem tetszik a fent leírt eljárás, akkor ajánlott, hogy a [Klipper Közösségi Discord](Contact.md#discord) segítségével kérj egyet.

## Flashing Boards that use SDIO

[As mentioned in the Caveats](#caveats), boards whose bootloader uses SDIO mode to access their SD Card require a power-cycle of the board, and specifically the SD Card itself, in order to switch from the SPI Mode used while writing the file to the SD Card back to SDIO mode for the bootloader to flash it into the board. These board definitions will use the `skip_verify` flag, which tells the flashing tool to stop after writing the firmware to the SD Card so that the board can be manually power-cycled and the verification step deferred until that's complete.

There are two scenarios -- one with the RPi Host running on a separate power supply and the other when the RPi Host is running on the same power supply as the main board being flashed. The difference is whether or not it's necessary to also shutdown the RPi and then `ssh` again after the flashing is complete in order to do the verification step, or if the verification can be done immediately. Here's examples of the two scenarios:

### SDIO Programming with RPi on Separate Power Supply

A typical session with the RPi on a Separate Power Supply looks like the following. You will, of course, need to use your proper device path and board name:

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

### SDIO Programming with RPi on the Same Power Supply

A typical session with the RPi on the Same Power Supply looks like the following. You will, of course, need to use your proper device path and board name:

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

In this case, since the RPi Host is being restarted, which will restart the `klipper` service, it's necessary to stop `klipper` again before doing the verification step and restart it after verification is complete.

### SDIO to SPI Pin Mapping

If your board's schematic uses SDIO for its SD Card, you can map the pins as described in the chart below to determine the compatible Software SPI pins to assign in the `board_defs.py` file:

| SD Card Pin | Micro SD Card Pin | SDIO Pin Name | SPI Pin Name |
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

\* None (PU) indicates an unused pin with a pull-up resistor
