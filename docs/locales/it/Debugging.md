# Debugging

Questo documento descrive alcuni degli strumenti di debug di Klipper.

## Esecuzione dei test di regressione

Il repository principale di Klipper GitHub utilizza "github actions" per eseguire una serie di test di regressione. Può essere utile eseguire alcuni di questi test in locale.

Il sorgente "controllo spazi bianchi" può essere eseguito con:

```
./scripts/check_whitespace.sh
```

La suite di test di regressione Klippy richiede "dizionari di dati" da molte piattaforme. Il modo più semplice per ottenerli è [scaricarli da github](https://github.com/Klipper3d/klipper/issues/1438). Una volta scaricati i dizionari di dati, utilizzare quanto segue per eseguire la suite di regressione:

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## Invio manuale di comandi al microcontrollore

Normalmente, il processo host klippy.py verrebbe utilizzato per tradurre i comandi gcode in comandi del microcontrollore Klipper. Tuttavia, è anche possibile inviare manualmente questi comandi MCU (funzioni contrassegnate con la macro DECL_COMMAND() nel codice sorgente di Klipper). Per farlo, esegui:

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

Vedere il comando "HELP" all'interno dello strumento per ulteriori informazioni sulla sua funzionalità.

Sono disponibili alcune opzioni della riga di comando. Per ulteriori informazioni esegui: `~/klippy-env/bin/python ./klippy/console.py --help`

## Traduzione di file gcode in comandi del microcontrollore

Il codice host Klippy può essere eseguito in modalità batch per produrre i comandi del microcontrollore di basso livello associati a un file gcode. L'ispezione di questi comandi di basso livello è utile quando si cerca di comprendere le azioni dell'hardware di basso livello. Può anche essere utile confrontare la differenza nei comandi del microcontrollore dopo una modifica del codice.

Per eseguire Klippy in questa modalità batch, è necessario un passaggio per generare il "dizionario dati" del microcontrollore. Questo viene fatto compilando il codice del microcontrollore per ottenere il file **out/klipper.dict**:

```
make menuconfig
make
```

Una volta fatto quanto sopra è possibile eseguire Klipper in modalità batch (vedi [installazione](Installation.md) per i passaggi necessari per costruire l'ambiente virtuale python e un file printer.cfg):

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

Quanto sopra produrrà un file **test.serial** con output seriale binario. Questo output può essere tradotto in testo leggibile con:

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

Il file risultante **test.txt** contiene un elenco leggibile di comandi del microcontrollore.

La modalità batch disabilita alcuni comandi di risposta/richiesta per funzionare. Di conseguenza, ci saranno alcune differenze tra i comandi effettivi e l'output sopra. I dati generati sono utili per il test e l'ispezione; non è utile per l'invio a un vero microcontrollore.

## Analisi del movimento e registrazione dei dati

Klipper supporta la registrazione della cronologia dei movimenti interni, che può essere analizzata in seguito. Per utilizzare questa funzione, Klipper deve essere avviato con [Server API](API_Server.md) abilitato.

La registrazione dei dati è abilitata con lo strumento `data_logger.py`. Per esempio:

```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog
```

Questo comando si collegherà al Klipper API Server, sottoscriverà le informazioni sullo stato e sul movimento e registrerà i risultati. Vengono generati due file: un file di dati compresso e un file di indice (ad esempio, `mylog.json.gz` e `mylog.index.gz`). Dopo aver avviato la registrazione, è possibile completare le stampe e altre azioni: la registrazione continuerà in background. Al termine della registrazione, premi `ctrl-c` per uscire dallo strumento `data_logger.py`.

I file risultanti possono essere letti e rappresentati graficamente utilizzando lo strumento `motan_graph.py`. Per generare grafici su un Raspberry Pi, è necessario un passaggio per installare il pacchetto "matplotlib":

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Tuttavia, potrebbe essere più conveniente copiare i file di dati su una macchina di classe desktop insieme al codice Python nella directory `scripts/motan/`. Gli script di analisi del movimento dovrebbero essere eseguiti su qualsiasi macchina con una versione recente di [Python](https://python.org) e [Matplotlib](https://matplotlib.org/) installata.

I grafici possono essere generati con un comando come il seguente:

```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

One can use the `-g` option to specify the datasets to graph (it takes a Python literal containing a list of lists). For example:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

L'elenco dei set di dati disponibili può essere trovato usando l'opzione `-l`, ad esempio:

```
~/klipper/scripts/motan/motan_graph.py -l
```

È anche possibile specificare le opzioni di stampa matplotlib per ogni set di dati:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```

Sono disponibili molte opzioni di matplotlib; alcuni esempi sono "color", "label", "alpha" e "linestyle".

Lo strumento `motan_graph.py` supporta molte altre opzioni della riga di comando: usa l'opzione `--help` per vedere un elenco. Può anche essere conveniente visualizzare/modificare lo stesso script [motan_graph.py](../scripts/motan/motan_graph.py).

I log di dati grezzi prodotti dallo strumento `data_logger.py` seguono il formato descritto in [Server API](API_Server.md). Può essere utile ispezionare i dati con un comando Unix come il seguente: `gunzip < mylog.json.gz | tr '\03' '\n' | less`

## Generare di grafici di carico

Il file di registro di Klippy (/tmp/klippy.log) memorizza le statistiche sulla larghezza di banda, sul carico del microcontrollore e sul carico del buffer dell'host. Può essere utile rappresentare graficamente queste statistiche dopo una stampa.

Per generare un grafico, è necessario un passaggio una tantum per installare il pacchetto "matplotlib":

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Quindi i grafici possono essere prodotti con:

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

Si può quindi visualizzare il file **loadgraph.png** risultante.

Possono essere prodotti diversi grafici. Per ulteriori informazioni esegui: `~/klipper/scripts/graphstats.py --help`

## Estrazione di informazioni dal file klippy.log

Anche il file di registro di Klippy (/tmp/klippy.log) contiene informazioni di debug. Esiste uno script logextract.py che può essere utile quando si analizza l'arresto di un microcontrollore o un problema simile. In genere viene eseguito con qualcosa come:

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

Lo script estrarrà il file di configurazione della stampante ed estrarrà le informazioni di arresto dell'MCU. I dump delle informazioni da un arresto dell'MCU (se presente) verranno riordinati in base al timestamp per facilitare la diagnosi degli scenari di causa ed effetto.

## Test con simulavr

Lo strumento [simulavr](http://www.nongnu.org/simulavr/) consente di simulare un microcontrollore Atmel ATmega. Questa sezione descrive come eseguire test di file gcode tramite simulavr. Si consiglia di eseguirlo su una macchina di classe desktop (non un Raspberry Pi) poiché richiede una CPU significativa per funzionare in modo efficiente.

Per utilizzare simulavr, scarica il pacchetto simulavr e compila con il supporto python. Nota che il sistema di build potrebbe aver bisogno di alcuni pacchetti (come swig) installati per costruire il modulo python.

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```

Assicurati che un file come **./build/pysimulavr/_pysimulavr.*.so** sia presente dopo la compilazione di cui sopra:

```
ls ./build/pysimulavr/_pysimulavr.*.so
```

Questo comando dovrebbe segnalare un file specifico (ad es. **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**) e non un errore.

Se utilizzi un sistema basato su Debian (Debian, Ubuntu, ecc.) puoi installare i seguenti pacchetti e generare file *.deb per l'installazione di simulavr a livello di sistema:

```
sudo apt update
sudo apt install g++ make cmake swig rst2pdf help2man texinfo
make cfgclean python debian
sudo dpkg -i build/debian/python3-simulavr*.deb
```

Per compilare Klipper per l'uso in simulavr, eseguire:

```
cd /path/to/klipper
make menuconfig
```

e compilare il software del microcontrollore per un AVR atmega644p e selezionare il supporto per l'emulazione del software SIMULAVR. Quindi si può compilare Klipper (eseguire `make`) e quindi avviare la simulazione con:

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

Nota che se hai installato python3-simulavr a livello di sistema, non è necessario impostare `PYTHONPATH` e puoi semplicemente eseguire il simulatore come

```
./scripts/avrsim.py out/klipper.elf
```

Quindi, con simulavr in esecuzione in un'altra finestra, è possibile eseguire quanto segue per leggere gcode da un file (ad es. "test.gcode"), elaborarlo con Klippy e inviarlo a Klipper in esecuzione in simulavr (vedere [installazione](Installazione .md) per i passaggi necessari per costruire l'ambiente virtuale Python):

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### Utilizzo di simulavr con gtkwave

Una caratteristica utile di simulavr è la sua capacità di creare file di generazione di onde di segnale con l'esatta sincronizzazione degli eventi. Per fare ciò, segui le istruzioni sopra, ma esegui avrsim.py con una riga di comando come la seguente:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

Quanto sopra creerebbe un file **avrsim.vcd** con informazioni su ogni modifica ai GPIO su PORTA e PORTB. Questo potrebbe quindi essere visualizzato usando gtkwave con:

```
gtkwave avrsim.vcd
```
