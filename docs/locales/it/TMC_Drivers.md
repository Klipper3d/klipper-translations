# Driver TMC

Questo documento fornisce informazioni sull'utilizzo dei driver Trinamic per motori stepper in modalità SPI/UART su Klipper.

Klipper può anche utilizzare i driver Trinamic nella loro "modalità standalone". Tuttavia, quando i driver sono in questa modalità, non è necessaria alcuna configurazione speciale di Klipper e le funzionalità avanzate di Klipper discusse in questo documento non sono disponibili.

Oltre a questo documento, assicurati di rivedere il [riferimento alla configurazione del driver TMC](Config_Reference.md#tmc-stepper-driver-configuration).

## Regolazione della corrente del motore

Una corrente più alta del driver aumenta la precisione del posizionamento e la coppia. Tuttavia, una corrente più elevata aumenta anche il calore prodotto dal motore passo-passo e dal driver del motore passo-passo. Se il driver del motore passo-passo si surriscalda, si disabiliterà e Klipper segnalerà un errore. Se il motore passo-passo si surriscalda, perde coppia e precisione di posizionamento. (Se diventa molto caldo, potrebbe anche fondere le parti di plastica attaccate o vicino ad esso.)

Come consiglio generale per l'ottimizzazione, preferire valori di corrente più elevati purché il motore passo-passo non si surriscaldi troppo e il driver del motore passo-passo non segnali avvisi o errori. In generale, va bene che il motore passo-passo sia caldo, ma non dovrebbe diventare così caldo da risultare doloroso al tatto.

## Preferibilmente non specificare un hold_current

Se si configura un `hold_current`, il driver TMC può ridurre la corrente al motore passo-passo quando rileva che il passo-passo non si sta muovendo. Tuttavia, la variazione della corrente del motore può di per sé introdurre il movimento del motore. Ciò può verificarsi a causa di "forze di arresto" all'interno del motore passo-passo (il magnete permanente nel rotore tira verso i denti di ferro nello statore) o a causa di forze esterne sul carrello dell'asse.

La maggior parte dei motori passo-passo non otterrà un beneficio significativo dalla riduzione della corrente durante le normali stampe, perché pochi movimenti di stampa lasceranno un motore passo-passo inattivo per un tempo sufficientemente lungo da attivare la funzione `hold_current`. Ed è improbabile che si vogliano introdurre sottili artefatti di stampa nelle poche mosse di stampa che lasciano uno stepper inattivo sufficientemente a lungo.

Se si desidera ridurre la corrente ai motori durante le routine di avvio della stampa, considerare l'emissione di comandi [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) in una [START_PRINT macro](Slicers.md#klipper-gcode_macro) per regolare la corrente prima e dopo i normali spostamenti di stampa.

Alcune stampanti con motori Z dedicati che sono inattivi durante i normali movimenti di stampa (nessuna bed_mesho, nessuna inclinazione_piatto, nessuna correzione_inclinazione Z, nessuna stampa in "modalità vaso", ecc.) potrebbero scoprire che i motori Z funzionano a temperature più basse con un `hold_current`. Se si implementa questo, assicurarsi di prendere in considerazione questo tipo di movimento dell'asse Z non comandato durante il livellamento del piatto, il rilevamento del piatto, la calibrazione della sonda e simili. Anche `driver_TPOWERDOWN` e `driver_IHOLDDELAY` dovrebbero essere calibrati di conseguenza. Se non sei sicuro, preferisci non specificare un `hold_current`.

## Impostazione della modalità "spreadCycle" rispetto a "stealthChop"

Per impostazione predefinita, Klipper mette i driver TMC in modalità "spreadCycle". Se il driver supporta "stealthChop", può essere abilitato aggiungendo `stealthchop_threshold: 999999` alla sezione di configurazione di TMC.

In generale, la modalità SpreadCycle fornisce una coppia maggiore e una maggiore precisione di posizionamento rispetto alla modalità StealthChop. Tuttavia, la modalità StealthChop può produrre un rumore udibile notevolmente inferiore su alcune stampanti.

I test di confronto delle modalità hanno mostrato un "ritardo posizionale" aumentato di circa il 75% di un passo completo durante i movimenti a velocità costante quando si utilizza la modalità StealthChop (ad esempio, su una stampante con distanza_rotazione di 40 mm e 200 passi_per_rotazione, la deviazione di posizione dei movimenti a velocità costante è aumentata di ~0,150 mm). Tuttavia, questo "ritardo nell'ottenimento della posizione richiesta" potrebbe non manifestarsi come un difetto di stampa significativo e si potrebbe preferire il comportamento più silenzioso della modalità stealthChop.

Si consiglia di utilizzare sempre la modalità "spreadCycle" (non specificando `stealthchop_threshold`) o di utilizzare sempre la modalità "stealthChop" (impostando `stealthchop_threshold` su 999999). Sfortunatamente, i driver spesso producono risultati scadenti e confusi se la modalità cambia mentre il motore è a una velocità diversa da zero.

## L'impostazione dell'interpolazione TMC introduce una piccola deviazione di posizione

L'impostazione `interpolate` del driver TMC può ridurre il rumore udibile del movimento della stampante a costo di introdurre un piccolo errore di posizione sistemico. Questo errore di posizione sistematico deriva dal ritardo del driver nell'esecuzione dei "passi" inviati da Klipper. Durante i movimenti a velocità costante, questo ritardo si traduce in un errore di posizione di quasi mezzo micropasso configurato (più precisamente, l'errore è di mezzo micropasso meno un 512esimo di un passo intero). Ad esempio, su un asse con una distanza_rotazione di 40 mm, 200 passi_per_rotazione e 16 micropassi, l'errore sistemico introdotto durante i movimenti a velocità costante è ~0,006 mm.

Per una migliore precisione di posizionamento, considerare l'utilizzo della modalità SpreadCycle e disabilitare l'interpolazione (impostare `interpolate: False` nella configurazione del driver TMC). Se configurato in questo modo, è possibile aumentare l'impostazione `microstep` per ridurre il rumore udibile durante il movimento del passo-passo. Tipicamente, un'impostazione microstep di `64` o `128` avrà un rumore udibile simile all'interpolazione e lo farà senza introdurre un errore posizionale sistemico.

Se si utilizza la modalità StealthChop, l'imprecisione posizionale dell'interpolazione è piccola rispetto all'imprecisione posizionale introdotta dalla modalità StealthChop. Pertanto l'interpolazione dell'ottimizzazione non è considerata utile in modalità StealthChop e si può lasciare l'interpolazione nel suo stato predefinito.

## Homing Sensorless

L'homing senza sensori consente di posizionare un asse senza la necessità di un finecorsa fisico. Invece, il carrello sull'asse viene spostato nel finecorsa meccanico facendo perdere passi al motore passo-passo. Il driver stepper rileva i passi persi e lo indica all'MCU di controllo (Klipper) attivando un pin. Queste informazioni possono essere utilizzate da Klipper come fine corsa per l'asse.

Questa guida illustra l'impostazione dell'homing sensorless per l'asse X della stampante (cartesiana). Tuttavia, funziona allo stesso modo con tutti gli altri assi (che richiedono un fine corsa). Dovresti configurarlo e sintonizzarlo per un asse alla volta.

### Limitazioni

Assicurati che i tuoi componenti meccanici siano in grado di sopportare il carico del carrello che urta ripetutamente il limite dell'asse. Soprattutto le viti di comando potrebbero generare molta forza. L'homing di un asse Z facendo urtare l'ugello sulla superficie di stampa potrebbe non essere una buona idea. Per ottenere i migliori risultati, verificare che il carrello dell'asse stabilisca un contatto stabile con il limite dell'asse.

Inoltre, l'homing sensorless potrebbe non essere sufficientemente preciso per la tua stampante. Sebbene l'homing degli assi X e Y su una macchina cartesiana possa funzionare bene, l'homing dell'asse Z in genere non è sufficientemente preciso e può comportare un'altezza del primo strato incoerente. L'homing di una stampante delta sensorless non è consigliabile a causa della mancanza di precisione.

Inoltre, il rilevamento dello stallo del driver passo-passo dipende dal carico meccanico sul motore, dalla corrente del motore e dalla temperatura del motore (resistenza della bobina).

L'homing sensorless funziona meglio a velocità medie del motore. Per velocità molto basse (inferiori a 10 giri/min) il motore non genera una significativa EMF di ritorno e il TMC non è in grado di rilevare in modo affidabile gli stalli del motore. Inoltre, a velocità molto elevate, l'EMF di ritorno del motore si avvicina alla tensione di alimentazione del motore, quindi il TMC non è più in grado di rilevare gli stalli. Si consiglia di dare un'occhiata alla scheda tecnica del proprio TMC specifico. Lì puoi anche trovare maggiori dettagli sulle limitazioni di questa configurazione.

### Prerequisiti

Sono necessari alcuni prerequisiti per utilizzare l'homing sensorless:

1. Driver passo-passo TMC compatibile con stallGuard (tmc2130, tmc2209, tmc2660 o tmc5160).
1. Interfaccia SPI/UART del driver TMC cablata al microcontrollore (la modalità stand-alone non funziona).
1. Il pin "DIAG" o "SG_TST" appropriato del driver TMC collegato al microcontrollore.
1. I passaggi nel documento [config checks](Config_checks.md) devono essere eseguiti per confermare che i motori passo-passo siano configurati e funzionino correttamente.

### Messa a punto

La procedura qui descritta prevede sei passaggi principali:

1. Scegli una velocità di homing.
1. Configura il file `printer.cfg` per abilitare l'homing sensorless.
1. Trova l'impostazione stallguard con la massima sensibilità che funziona con successo.
1. Trova l'impostazione stallguard con la sensibilità più bassa che effettua homing con successo con un solo tocco.
1. Aggiorna il `printer.cfg` con l'impostazione di stallguard desiderata.
1. Crea o aggiorna le macro `printer.cfg` per homing in modo coerente.

#### Scegli la velocità di homing

La velocità di homing è una scelta importante quando si esegue l'homing senza sensori. È consigliabile utilizzare una velocità di riferimento bassa in modo che il carrello non eserciti una forza eccessiva sul telaio quando entra in contatto con l'estremità della rotaia. Tuttavia, i driver TMC non sono in grado di rilevare in modo affidabile uno stallo a velocità molto basse.

Un buon punto di partenza per la velocità di homing è che il motore passo-passo esegua una rotazione completa ogni due secondi. Per molti assi questa sarà la `rotation_distance` divisa per due. Per esempio:

```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### Configura printer.cfg per l'homing sensorless

L'impostazione `homing_retract_dist` deve essere impostata su zero nella sezione di configurazione `stepper_x` per disabilitare il secondo movimento di homing. Il secondo tentativo di homing non aggiunge valore quando si utilizza l'homing sensorless, non funzionerà in modo affidabile e confonderà il processo di ottimizzazione.

Assicurati che un'impostazione `hold_current` non sia specificata nella sezione del driver TMC del file config. (Se viene impostata una hold_current, dopo che è stato stabilito il contatto, il motore si arresta mentre il carrello viene premuto contro l'estremità del binario e la riduzione della corrente mentre si trova in quella posizione può causare il movimento del carrello, il che si traduce in prestazioni scadenti e confonde il processo di regolazione.)

È necessario configurare i pin di homing sensorless e configurare le impostazioni iniziali di "stallguard". Una configurazione di esempio tmc2209 per un asse X potrebbe essere simile a:

```
[tmc2209 stepper_x]
diag_pin: ^PA1      # Impostare sul pin MCU collegato al pin TMC DIAG
driver_SGTHRS: 255  #255 è il valore più sensibile, 0 è il meno sensibile
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Un esempio di configurazione tmc2130 o tmc5160 potrebbe essere simile a:

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # Pin collegato al pin TMC DIAG1 (o utilizzare pin diag0_pin / DIAG0)
driver_SGT: -64  # -64 è il valore più sensibile, 63 è il meno sensibile
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Un esempio di configurazione di tmc2660 potrebbe essere simile a:

```
[tmc2660 stepper_x]
driver_SGT: -64     # -64 è il valore più sensibile, 63 è il meno sensibile
...

[stepper_x]
endstop_pin: ^PA1   # Pin collegato al pin TMC SG_TST
homing_retract_dist: 0
...
```

Gli esempi sopra mostrano solo le impostazioni specifiche per l'homing sensorless. Vedere il [riferimento alla configurazione](Config_Reference.md#tmc-stepper-driver-configuration) per tutte le opzioni disponibili.

#### Trova la massima sensibilità che porta a homing con successo

Posizionare il carrello vicino al centro del binario. Utilizzare il comando SET_TMC_FIELD per impostare la sensibilità più alta. Per tmc2209:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

Per tmc2130, tmc5160 e tmc2660:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

Quindi emettere un comando `G28 X0` e verificare che l'asse non si muova affatto. Se l'asse si muove, emettere un `M112` per fermare la stampante - qualcosa non è corretto con il cablaggio o la configurazione del pin diag/sg_tst e deve essere corretto prima di continuare.

Quindi, diminuire progressivamente la sensibilità dell'impostazione `VALUE` ed eseguire nuovamente i comandi `SET_TMC_FIELD` `G28 X0` per trovare la sensibilità più alta che fa sì che il carrello si muova con successo fino all'arresto e si arresti. (Per i driver tmc2209 questo diminuirà SGTHRS, per altri conducenti aumenterà il sgt.) Assicurati di iniziare ogni tentativo con il carrello vicino al centro del binario (se necessario, emetti `M84` e quindi sposta manualmente il carrello sul centro). Dovrebbe essere possibile trovare la sensibilità più alta che si adatta in modo affidabile (le impostazioni con una sensibilità più alta comportano movimenti piccoli o nulli). Nota il valore trovato come *sensibilità_massima*. (Se si ottiene la sensibilità minima possibile (SGTHRS=0 o sgt=63) senza alcun movimento del carrello, allora qualcosa non è corretto con il cablaggio o la configurazione dei pin diag/sg_tst e deve essere corretto prima di continuare.)

Quando si cerca la sensibilità_massima, può essere conveniente passare a diverse impostazioni VALUE (in modo da dividere in due il parametro VALUE). In tal caso, prepararsi a emettere un comando `M112` per arrestare la stampante, poiché un'impostazione con una sensibilità molto bassa potrebbe far "sbattere" ripetutamente l'asse contro l'estremità del binario.

Assicurati di attendere un paio di secondi tra ogni tentativo di homing. Dopo che il driver TMC ha rilevato uno stallo, potrebbe volerci un po' di tempo per cancellare il suo indicatore interno ed essere in grado di rilevare un altro stallo.

Durante questi test di ottimizzazione, se un comando `G28 X0` non si sposta fino al limite dell'asse, prestare attenzione nell'emettere qualsiasi comando di movimento regolare (ad es. `G1`). Klipper non avrà una corretta comprensione della posizione del carrello e un comando di spostamento potrebbe causare risultati indesiderati e confusi.

#### Trova la sensibilità più bassa che porta a homing con un solo tocco

Quando si effettua l'homing con il valore *maximum_sensitivity* trovato, l'asse dovrebbe spostarsi all'estremità del binario e fermarsi con un "tocco singolo", ovvero non dovrebbe esserci un "clic" o un "sbattere". (Se c'è un suono che sbatte o scatta alla sensibilità_massima, allora la velocità di riferimento potrebbe essere troppo bassa, la corrente del driver potrebbe essere troppo bassa o la corsa di riferimento senza sensore potrebbe non essere una buona scelta per l'asse.)

Il passo successivo è spostare di nuovo continuamente il carrello in una posizione vicino al centro della rotaia, diminuire la sensibilità ed eseguire i comandi `SET_TMC_FIELD` `G28 X0` - l'obiettivo ora è trovare la sensibilità più bassa che risulti ancora nel la carrozza torna con successo al punto di riferimento con un "tocco singolo". Cioè, non "sbatte" o "clic" quando viene a contatto con l'estremità del binario. Nota il valore trovato come *sensibilità_minima*.

#### Aggiorna printer.cfg con il valore della sensibilità

Dopo aver trovato *sensibilità_massima* e *sensibilità_minima*, utilizzare una calcolatrice per ottenere la sensibilità consigliata come *sensibilità_minima + (sensibilità_massima - sensibilità_minima)/3*. La sensibilità consigliata dovrebbe essere compresa tra il minimo e il massimo, ma leggermente più vicino al minimo. Arrotonda il valore finale al valore intero più vicino.

Per tmc2209 impostalo nella configurazione come `driver_SGTHRS`, per altri driver TMC impostalo nella configurazione come `driver_SGT`.

Se l'intervallo tra *sensibilità_massima* e *sensibilità_minima* è piccolo (ad esempio, inferiore a 5), potrebbe risultare in un homing instabile. Una velocità di riferimento più elevata può aumentare il range e rendere l'operazione più stabile.

Si noti che se viene apportata una modifica alla corrente del driver, alla velocità di riferimento o viene apportata una modifica notevole all'hardware della stampante, sarà necessario eseguire nuovamente il processo di ottimizzazione.

#### Utilizzo delle macro durante l'homing

Dopo aver completato l'homing senza sensori, il carrello verrà premuto contro l'estremità del binario e lo stepper eserciterà una forza sul telaio fino a quando il carrello non si allontana. È una buona idea creare una macro per posizionare l'asse e allontanare immediatamente il carrello dall'estremità della rotaia.

È una buona idea che la macro si metta in pausa di almeno 2 secondi prima di iniziare l'homing sensorless (o altrimenti assicurarsi che non ci siano stati movimenti sullo stepper per 2 secondi). Senza ritardo è possibile che il flag di stallo interno del driver sia ancora impostato da un movimento precedente.

Può anche essere utile fare in modo che quella macro imposti la corrente del driver prima della corsa di riferimento e imposti una nuova corrente dopo che il carrello si è allontanato.

Una macro di esempio potrebbe assomigliare a:

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # Imposta la corrente per l'homing sensorless
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # Fai una pausa per assicurarti che il flag di stallo del driver sia clear
    G4 P2000
    # Home
    G28 X0
    # Spostamento
    G90
    G1 X5 F1200
    # Imposta corrente durante la stampa
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

La macro risultante può essere chiamata da una [sezione di configurazione homing_override](Config_Reference.md#homing_override) o da una [START_PRINT macro](Slicers.md#klipper-gcode_macro).

Si noti che se viene modificata la corrente del driver durante l'homing, il processo di ottimizzazione dovrebbe essere eseguito nuovamente.

### Suggerimenti per l'homing sensorless su CoreXY

È possibile utilizzare l'homing sensorless sui carrelli X e Y di una stampante CoreXY. Klipper usa lo stepper `[stepper_x]` per rilevare gli stalli durante l'homing del carrello X e usa lo stepper `[stepper_y]` per rilevare gli stalli durante l'homing del carrello Y.

Utilizzare la guida alla messa a punto sopra descritta per trovare la "sensibilità allo stallo" appropriata per ciascun carrello, ma prestare attenzione alle seguenti restrizioni:

1. Quando si utilizza l'homing sensorless su CoreXY, assicurarsi che non sia configurato `hold_current` per nessuno dei due stepper.
1. Durante la messa a punto, assicurati che entrambi i carrelli X e Y siano vicini al centro dei loro binari prima di ogni tentativo di homing.
1. Al termine dell'ottimizzazione, quando si esegue l'homing sia di X che Y, utilizzare le macro per assicurarsi che un asse sia homed per primo, quindi spostare il carrello lontano dal limite dell'asse, fare una pausa per almeno 2 secondi, quindi avviare l'orientamento dell'altro carrello. L'allontanamento dall'asse evita l'homing di un asse mentre l'altro viene premuto contro il limite dell'asse (cosa potrebbe distorcere il rilevamento dello stallo). La pausa è necessaria per garantire che il flag di stallo del driver sia cancellata prima del homing.

## Interrogazione e diagnosi delle impostazioni del driver

Il [comando DUMP_TMC](G-Codes.md#dump_tmc) è uno strumento utile durante la configurazione e la diagnosi dei driver. Riporterà tutti i campi configurati da Klipper così come tutti i campi che possono essere interrogati dal driver.

Tutti i campi riportati sono definiti nella scheda tecnica Trinamic per ciascun driver. Queste schede tecniche possono essere trovate sul [sito web Trinamic](https://www.trinamic.com/). Ottenere e rivedere i dati Trinamic affinché il conducente interpreti i risultati di DUMP_TMC.

## Configurazione delle impostazioni driver_XXX

Klipper supporta la configurazione di molti campi driver di basso livello usando le impostazioni `driver_XXX`. Il [Riferimento alla configurazione del driver TMC](Config_Reference.md#tmc-stepper-driver-configuration) contiene l'elenco completo dei campi disponibili per ogni tipo di driver.

Inoltre, quasi tutti i campi possono essere modificati in fase di esecuzione utilizzando il [comando SET_TMC_FIELD](G-Codes.md#set_tmc_field).

Ciascuno di questi campi è definito nella scheda tecnica Trinamic per ciascun driver. Queste schede tecniche possono essere trovate sul [sito web Trinamic](https://www.trinamic.com/).

Si noti che i fogli dati Trinamic a volte utilizzano un'espressione che può confondere un'impostazione di alto livello (come "fine isteresi") con un valore di campo di basso livello (ad esempio, "HEND"). In Klipper, `driver_XXX` e SET_TMC_FIELD impostano sempre il valore del campo di basso livello che viene effettivamente scritto nel driver. Quindi, ad esempio, se il foglio dati Trinamic afferma che è necessario scrivere un valore di 3 nel campo HEND per ottenere una "fine dell'isteresi" di 0, impostare `driver_HEND=3` per ottenere il valore di alto livello di 0.

## Domande comuni

### Posso usare la modalità StealthChop su un estrusore con anticipo della pressione?

Molte persone usano con successo la modalità "stealthChop" con pressure advance di Klipper. Klipper implementa [Smooth Pressure Advance](Kinematics.md#pressure-advance) che non introduce variazioni di velocità istantanee.

Tuttavia, la modalità "stealthChop" può produrre una coppia del motore inferiore e/o produrre un maggiore calore del motore. Potrebbe essere o meno una modalità adeguata per la tua particolare stampante.

### Continuo a ricevere gli errori "Impossibile leggere tmc uart 'stepper_x' register IFCNT"?

Ciò si verifica quando Klipper non è in grado di comunicare con un driver tmc2208 o tmc2209.

Assicurarsi che l'alimentazione del motore sia abilitata, poiché il driver del motore passo-passo generalmente necessita dell'alimentazione del motore prima di poter comunicare con il microcontrollore.

Se questo errore si verifica dopo aver eseguito il flashing di Klipper per la prima volta, è possibile che il driver stepper sia stato precedentemente programmato in uno stato non compatibile con Klipper. Per ripristinare lo stato, rimuovere tutta l'alimentazione dalla stampante per alcuni secondi (scollegare fisicamente sia USB che le spine di alimentazione).

In caso contrario, questo errore è in genere il risultato di un cablaggio errato del pin UART o di una configurazione Klipper errata delle impostazioni del pin UART.

### Continuo a ricevere errori "Unable to write tmc spi 'stepper_x' register ..."?

Ciò si verifica quando Klipper non è in grado di comunicare con un driver tmc2130 o tmc5160.

Assicurarsi che l'alimentazione del motore sia abilitata, poiché il driver del motore passo-passo generalmente necessita dell'alimentazione del motore prima di poter comunicare con il microcontrollore.

In caso contrario, questo errore è in genere il risultato di un cablaggio SPI errato, una configurazione Klipper errata delle impostazioni SPI o una configurazione incompleta dei dispositivi su un bus SPI.

Nota che se il driver si trova su un bus SPI condiviso con più dispositivi, assicurati di configurare completamente ogni dispositivo su quel bus SPI condiviso in Klipper. Se un dispositivo su un bus SPI condiviso non è configurato, potrebbe rispondere in modo errato a comandi non previsti e danneggiare la comunicazione con il dispositivo previsto. Se è presente un dispositivo su un bus SPI condiviso che non può essere configurato in Klipper, utilizzare una [sezione di configurazione static_digital_output](Config_Reference.md#static_digital_output) per impostare il pin CS del dispositivo inutilizzato alto (in modo che non tenti utilizzare il bus SPI). Lo schema della scheda è spesso un utile riferimento per trovare quali dispositivi si trovano su un bus SPI e i pin associati.

### Perché ho ricevuto un errore "TMC reports error: ..."?

Questo tipo di errore indica che il driver TMC ha rilevato un problema e si è disabilitato. Cioè, il conducente ha smesso di mantenere la sua posizione e ha ignorato i comandi di movimento. Se Klipper rileva che un driver attivo si è disabilitato, la stampante passerà allo stato di "spegnimento".

È anche possibile che si verifichi un arresto **TMC segnala errore** a causa di errori SPI che impediscono la comunicazione con il driver (su tmc2130, tmc5160 o tmc2660). Se ciò si verifica, è normale che lo stato del driver riportato mostri `00000000` o `ffffffff`, ad esempio: `TMC reports error: DRV_STATUS: ffffffff ...` O `TMC reports error: READRSP@RDSEL2: 00000000 ... `. Tale errore può essere dovuto a un problema di cablaggio SPI o può essere dovuto a un ripristino automatico o a un guasto del driver TMC.

Alcuni errori comuni e suggerimenti per diagnosticarli:

#### TMC segnala l'errore: `... ot=1(OvertempError!)`

Ciò indica che il driver del motore si è disabilitato perché è diventato troppo caldo. Le soluzioni tipiche consistono nel ridurre la corrente del motore passo-passo, aumentare il raffreddamento sul driver del motore passo-passo e/o aumentare il raffreddamento sul motore passo-passo.

#### TMC segnala un errore: `... ShortToGND` O `LowSideShort`

Ciò indica che il driver si è disabilitato perché ha rilevato una corrente molto elevata che passa attraverso il driver. Ciò potrebbe indicare un filo allentato o in cortocircuito al motore passo-passo o all'interno del motore passo-passo stesso.

Questo errore può verificarsi anche se si utilizza la modalità StealthChop e il driver TMC non è in grado di prevedere con precisione il carico meccanico del motore. (Se il driver fa una previsione scadente, potrebbe inviare troppa corrente attraverso il motore e attivare il proprio rilevamento di sovracorrente.) Per verificarlo, disabilitare la modalità StealthChop e verificare se gli errori continuano a verificarsi.

#### TMC segnala un errore: `... reset=1(Reset)` OR `CS_ACTUAL=0(Reset?)` OR `SE=0(Reset?)`

Ciò indica che il driver si è ripristinato durante la stampa. Ciò potrebbe essere dovuto a problemi di tensione o cablaggio.

#### TMC segnala l'errore: `... uv_cp=1(Undervoltage!)`

Ciò indica che il driver ha rilevato un evento di bassa tensione e si è disabilitato. Ciò potrebbe essere dovuto a problemi di cablaggio o alimentazione.

### Come si regola la modalità spreadCycle/coolStep/etc. sui miei driver?

Il [sito web Trinamic](https://www.trinamic.com/) contiene guide sulla configurazione dei driver. Queste guide sono spesso tecniche, di basso livello e potrebbero richiedere hardware specializzato. In ogni caso, sono la migliore fonte di informazioni.
