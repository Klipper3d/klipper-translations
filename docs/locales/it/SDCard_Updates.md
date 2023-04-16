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

L'opzione `-c` viene utilizzata per eseguire un controllo o un'operazione di sola verifica per testare se la scheda esegue correttamente il firmware specificato. Questa opzione è destinata principalmente ai casi in cui è necessario un ciclo di alimentazione manuale per completare la procedura di flashing, ad esempio con i bootloader che utilizzano la modalità SDIO anziché SPI per accedere alle proprie schede SD. (Vedi avvertenze di seguito) Ma può anche essere utilizzato in qualsiasi momento per verificare se il codice visualizzato nella scheda corrisponde alla versione nella cartella build su qualsiasi scheda supportata.

## Avvertenze

- Come accennato nell'introduzione, questo metodo funziona solo per l'aggiornamento del firmware. La procedura di flashing iniziale deve essere eseguita manualmente secondo le istruzioni che si applicano alla scheda del controller.
- Sebbene sia possibile eseguire il flashing di una build che modifica il baud seriale o l'interfaccia di connessione (ad esempio: da USB a UART), la verifica avrà sempre esito negativo poiché lo script non sarà in grado di riconnettersi all'MCU per verificare la versione corrente.
- Sono supportate solo le schede che utilizzano SPI per la comunicazione con scheda SD. Le schede che utilizzano SDIO, come Flymaker Flyboard e MKS Robin Nano V1/V2, non funzioneranno in modalità SDIO. Tuttavia, di solito è possibile eseguire il flashing di tali schede utilizzando invece la modalità Software SPI. Ma se il bootloader della scheda utilizza solo la modalità SDIO per accedere alla scheda SD, sarà necessario un ciclo di alimentazione della scheda e della scheda SD in modo che la modalità possa tornare da SPI a SDIO per completare il reflashing. Tali schede dovrebbero essere definite con `skip_verify` abilitato per saltare il passaggio di verifica immediatamente dopo il flashing. Quindi, dopo il ciclo di spegnimento manuale, è possibile eseguire nuovamente lo stesso identico comando `./scripts/flash-sdcard.sh`, ma aggiungere l'opzione `-c` per completare l'operazione di controllo/verifica. Vedere [Flashing Boards that use SDIO](#flashing-boards-that-use-sdio) per esempi.

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

- `mcu`: The mcu type. This can be retrieved after configuring the build via `make menuconfig` by running `cat .config | grep CONFIG_MCU`. This field is required.
- `spi_bus`: The SPI bus connected to the SD Card. This should be retrieved from the board's schematic. This field is required.
- `cs_pin`: The Chip Select Pin connected to the SD Card. This should be retrieved from the board schematic. This field is required.
- `firmware_path`: il percorso sulla scheda SD in cui trasferire il firmware. L'impostazione predefinita è `firmware.bin`.
- `current_firmware_path`: il percorso sulla scheda SD in cui si trova il file del firmware rinominato dopo un flash riuscito. L'impostazione predefinita è 'firmware.cur'.
- `skip_verify`: Definisce un valore booleano che dice agli script di saltare il passaggio di verifica del firmware durante il processo di flashing. L'impostazione predefinita è `False`. Può essere impostato su `True` per le schede che richiedono un ciclo di alimentazione manuale per completare il flashing. Per verificare il firmware in seguito, eseguire nuovamente lo script con l'opzione `-c` per eseguire lo step di verifica. [Vedi le avvertenze con le schede SDIO](#caveats)

Se è richiesto il software SPI, il campo `spi_bus` deve essere impostato su `swspi` e deve essere specificato il seguente campo aggiuntivo:

- spi_pins`: Dovrebbero essere 3 pin separati da virgola che sono collegati alla scheda SD nel formato `miso,mosi,sclk`.

Dovrebbe essere estremamente raro che sia necessario Software SPI, in genere solo le schede con errori di progettazione o le schede che normalmente supportano solo la modalità SDIO per la loro scheda SD lo richiederanno. La definizione della scheda `btt-skr-pro` fornisce un esempio della prima, e la definizione della scheda `btt-octopus-f446-v1` fornisce un esempio della seconda.

Prima di creare una nuova definizione di scheda, è necessario verificare se una definizione di scheda esistente soddisfa i criteri necessari per la nuova scheda. Se questo è il caso, può essere specificato un `BOARD_ALIAS`. Ad esempio, è possibile aggiungere il seguente alias per specificare `my-new-board` come alias per `generic-lpc1768`:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Se hai bisogno di una nuova definizione di scheda e ti senti a disagio con la procedura descritta sopra, ti consigliamo di rivolgerti a [Klipper Community Discord](Contact.md#discord).

## Flashing di schede che utilizzano SDIO

[Come menzionato nelle avvertenze](#caveats), le schede il cui bootloader utilizza la modalità SDIO per accedere alla scheda SD richiedono un ciclo di alimentazione della scheda, e in particolare della scheda SD stessa, per passare dalla modalità SPI utilizzata durante la scrittura il file sulla scheda SD di nuovo in modalità SDIO affinché il bootloader lo inserisca nella scheda. Queste definizioni della scheda utilizzeranno il flag `skip_verify`, che indica allo strumento di flashing di interrompersi dopo aver scritto il firmware sulla scheda SD in modo che la scheda possa essere spenta e riaccesa manualmente e il passaggio di verifica posticipato fino al completamento.

Esistono due scenari -- uno con l'host RPi in esecuzione su un alimentatore separato e l'altro quando l'host RPi è in esecuzione con lo stesso alimentatore della scheda principale sottoposta a flashing. La differenza è se è necessario o meno spegnere anche l'RPi e quindi `ssh`di nuovo dopo che il flashing è completo per eseguire il passaggio di verifica, o se la verifica può essere eseguita immediatamente. Ecco alcuni esempi dei due scenari:

### Programmazione SDIO con RPi su alimentazione separata

Una sessione tipica con l'RPi su un alimentatore separato è simile alla seguente. Ovviamente, dovrai utilizzare il percorso del dispositivo e il nome della scheda corretti:

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

### Programmazione SDIO con RPi sullo stesso alimentatore

Una sessione tipica con l'RPi sullo stesso alimentatore è simile alla seguente. Ovviamente, dovrai utilizzare il percorso del dispositivo e il nome della scheda corretti:

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

In questo caso, poiché è in corso il riavvio dell'RPi Host, che riavvierà il servizio `klipper`, è necessario arrestare nuovamente `klipper` prima di eseguire il passaggio di verifica e riavviarlo al termine della verifica.

### Mappatura pin da SDIO a SPI

Se lo schema della tua scheda utilizza SDIO per la sua scheda SD, puoi mappare i pin come descritto nella tabella seguente per determinare i pin SPI del software compatibili da assegnare nel file `board_defs.py`:

| Pin della scheda SD | Pin della scheda micro SD | Nome PIN SDIO | Nome Pin SPI |
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

\* None (PU) indica un pin inutilizzato con una resistenza di pull-up
