# Aggiornamenti scheda SD

Molte delle schede controller oggi popolari vengono fornite con un bootloader in grado di aggiornare il firmware tramite scheda SD. Sebbene ciò sia conveniente in molte circostanze, questi bootloader in genere non forniscono altro modo per aggiornare il firmware. Questo può essere un fastidio se la tua scheda è montata in una posizione di difficile accesso o se devi aggiornare spesso il firmware. Dopo che Klipper è stato inizialmente flashato su un controller, è possibile trasferire il nuovo firmware sulla scheda SD e avviare la procedura di flashing tramite ssh.

## Procedura di aggiornamento tipica

La procedura per aggiornare il firmware dell'MCU utilizzando la scheda SD è simile a quella di altri metodi. Invece di usare `make flash` è necessario eseguire uno script di supporto, `flash-sdcard.sh`. L'aggiornamento di un BigTreeTech SKR 1.3 potrebbe essere simile al seguente:

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

Spetta all'utente determinare la posizione del dispositivo e il nome della scheda. Se un utente ha bisogno di eseguire il flashing di più schede, `flash-sdcard.sh` (o `make flash` se appropriato) dovrebbe essere eseguito per ciascuna scheda prima di riavviare il servizio Klipper.

Le schede supportate possono essere elencate con il seguente comando:

```
./scripts/flash-sdcard.sh -l
```

Se non vedi la tua scheda elencata, potrebbe essere necessario aggiungere una nuova definizione di scheda come [descritto di seguito](#board-definitions).

## Utilizzo avanzato

I comandi precedenti presuppongono che l'MCU si connetta alla velocità di trasmissione predefinita di 250000 e che il firmware si trovi in `~/klipper/out/klipper.bin`. Lo script `flash-sdcard.sh` fornisce opzioni per modificare queste impostazioni predefinite. Tutte le opzioni possono essere visualizzate dalla schermata della guida:

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

Se la tua scheda è stata flashata con un firmware che si connette a un baud rate personalizzato, è possibile eseguire l'aggiornamento specificando l'opzione `-b`:

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

Se desideri eseguire il flashing di una build di Klipper situata in un luogo diverso da quello predefinito, puoi farlo specificando l'opzione `-f`:

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

Nota che quando si aggiorna un MKS Robin E3 non è necessario eseguire manualmente `update_mks_robin.py` e fornire il binario risultante a `flash-sdcard.sh`. Questa procedura è automatizzata durante il processo di caricamento.

The `-c` option is used to perform a check or verify-only operation to test if the board is running the specified firmware correctly. This option is primarily intended for cases where a manual power-cycle is necessary to complete the flashing procedure, such as with bootloaders that use SDIO mode instead of SPI to access their SD Cards. (See Caveats below) But, it can also be used anytime to verify if the code flashed into the board matches the version in your build folder on any supported board.

## Avvertenze

- Come accennato nell'introduzione, questo metodo funziona solo per l'aggiornamento del firmware. La procedura di flashing iniziale deve essere eseguita manualmente secondo le istruzioni che si applicano alla scheda del controller.
- Sebbene sia possibile eseguire il flashing di una build che modifica il baud seriale o l'interfaccia di connessione (ad esempio: da USB a UART), la verifica avrà sempre esito negativo poiché lo script non sarà in grado di riconnettersi all'MCU per verificare la versione corrente.
- Only boards that use SPI for SD Card communication are supported. Boards that use SDIO, such as the Flymaker Flyboard and MKS Robin Nano V1/V2, will not work in SDIO mode. However, it's usually possible to flash such boards using Software SPI mode instead. But if the board's bootloader only uses SDIO mode to access the SD Card, a power-cycle of the board and SD Card will be necessary so that the mode can switch from SPI back to SDIO to complete reflashing. Such boards should be defined with `skip_verify` enabled to skip the verify step immediately after flashing. Then after the manual power-cycle, you can rerun the exact same `./scripts/flash-sdcard.sh` command, but add the `-c` option to complete the check/verify operation. See [Flashing Boards that use SDIO](#flashing-boards-that-use-sdio) for examples.

## Definizioni della scheda

Dovrebbero essere disponibili le schede più comuni, tuttavia è possibile aggiungere una nuova definizione di scheda, se necessario. Le definizioni delle schede si trovano in `~/klipper/scripts/spi_flash/board_defs.py`. Le definizioni sono memorizzate nel dizionario, ad esempio:

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

Possono essere specificati i seguenti campi:

- `mcu`: il tipo di mcu. Questo può essere recuperato dopo aver configurato la build tramite `make menuconfig` eseguendo `cat .config | grep CONFIG_MCU`. Questo campo è obbligatorio.
- `spi_bus`: il bus SPI collegato alla scheda SD. Questo dovrebbe essere recuperato dallo schema della scheda. Questo campo è obbligatorio.
- `cs_pin`: il pin di selezione del chip collegato alla scheda SD. Questo dovrebbe essere recuperato dallo schema della scheda. Questo campo è obbligatorio.
- `firmware_path`: il percorso sulla scheda SD in cui trasferire il firmware. L'impostazione predefinita è `firmware.bin`.
- `current_firmware_path`: The path on the SD Card where the renamed firmware file is located after a successful flash. The default is `firmware.cur`.
- `skip_verify`: This defines a boolean value which tells the scripts to skip the firmware verification step during the flashing process. The default is `False`. It can be set to `True` for boards that require a manual power-cycle to complete flashing. To verify the firmware afterward, run the script again with the `-c` option to perform the verification step. [See caveats with SDIO cards](#caveats)

If software SPI is required, the `spi_bus` field should be set to `swspi` and the following additional field should be specified:

- spi_pins`: Dovrebbero essere 3 pin separati da virgola che sono collegati alla scheda SD nel formato `miso,mosi,sclk`.

It should be exceedingly rare that Software SPI is necessary, typically only boards with design errors or boards that normally only support SDIO mode for their SD Card will require it. The `btt-skr-pro` board definition provides an example of the former, and the `btt-octopus-f446-v1` board definition provides an example of the latter.

Prima di creare una nuova definizione di scheda, è necessario verificare se una definizione di scheda esistente soddisfa i criteri necessari per la nuova scheda. Se questo è il caso, può essere specificato un `BOARD_ALIAS`. Ad esempio, è possibile aggiungere il seguente alias per specificare `my-new-board` come alias per `generic-lpc1768`:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Se hai bisogno di una nuova definizione di scheda e ti senti a disagio con la procedura descritta sopra, ti consigliamo di rivolgerti a [Klipper Community Discord](Contact.md#discord).

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
