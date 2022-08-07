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

Se la tua scheda è stata flashata con un firmware che si connette a un baud rate personalizzato, è possibile eseguire l'aggiornamento specificando l'opzione `-b`:

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

Se desideri eseguire il flashing di una build di Klipper situata in un luogo diverso da quello predefinito, puoi farlo specificando l'opzione `-f`:

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

Nota che quando si aggiorna un MKS Robin E3 non è necessario eseguire manualmente `update_mks_robin.py` e fornire il binario risultante a `flash-sdcard.sh`. Questa procedura è automatizzata durante il processo di caricamento.

## Avvertenze

- Come accennato nell'introduzione, questo metodo funziona solo per l'aggiornamento del firmware. La procedura di flashing iniziale deve essere eseguita manualmente secondo le istruzioni che si applicano alla scheda del controller.
- Sebbene sia possibile eseguire il flashing di una build che modifica il baud seriale o l'interfaccia di connessione (ad esempio: da USB a UART), la verifica avrà sempre esito negativo poiché lo script non sarà in grado di riconnettersi all'MCU per verificare la versione corrente.
- Sono supportate solo le schede che utilizzano SPI per la comunicazione con scheda SD. Le schede che utilizzano SDIO, come Flymaker Flyboard e MKS Robin Nano V1/V2, non funzioneranno.

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
- `current_firmware_path` Il percorso sulla scheda SD in cui si trova il file del firmware rinominato dopo un flash riuscito. L'impostazione predefinita è "firmware.cur".

Se è richiesto il software SPI, il campo `spi_bus` deve essere impostato su `swspi` e deve essere specificato il seguente campo aggiuntivo:

- spi_pins`: Dovrebbero essere 3 pin separati da virgola che sono collegati alla scheda SD nel formato `miso,mosi,sclk`.

Dovrebbe essere estremamente raro che sia necessario Software SPI, in genere solo le schede con errori di progettazione lo richiederanno. La definizione della scheda `btt-skr-pro` fornisce un esempio.

Prima di creare una nuova definizione di scheda, è necessario verificare se una definizione di scheda esistente soddisfa i criteri necessari per la nuova scheda. Se questo è il caso, può essere specificato un `BOARD_ALIAS`. Ad esempio, è possibile aggiungere il seguente alias per specificare `my-new-board` come alias per `generic-lpc1768`:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Se hai bisogno di una nuova definizione di scheda e ti senti a disagio con la procedura descritta sopra, ti consigliamo di rivolgerti a [Klipper Community Discord](Contact.md#discord).
