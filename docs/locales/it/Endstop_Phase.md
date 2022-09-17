# Fase di fine corsa

Questo documento descrive il sistema di finecorsa di Klipper regolato sulla fase degli stepper. Questa funzionalità può migliorare la precisione degli interruttori di fine corsa tradizionali. È particolarmente utile quando si utilizza un driver per motori passo-passo Trinamic con configurazione runtime.

Un tipico interruttore di fine corsa ha una precisione di circa 100 micron. (Ogni volta l'interruttore può attivarsi leggermente prima o leggermente dopo.) Sebbene si tratti di un errore relativamente piccolo, può causare artefatti indesiderati. In particolare, questa deviazione di posizione può essere evidente quando si stampa il primo strato di un oggetto. Al contrario, i tipici motori passo-passo possono ottenere una precisione significativamente maggiore.

Il meccanismo di fine corsa con regolazione della fase può utilizzare la precisione dei motori passo-passo per migliorare la precisione degli interruttori di fine corsa. Un motore passo-passo si muove ciclicamente attraverso una serie di fasi fino a completare quattro "passi completi". Quindi, un motore passo-passo che utilizza 16 micro-passi avrebbe 64 fasi e quando si muove in direzione positiva passerebbe in rassegna le fasi: 0, 1, 2, ... 61, 62, 63, 0, 1, 2, ecc. Fondamentalmente, quando il motore passo-passo si trova in una posizione particolare su una guida lineare, dovrebbe essere sempre nella stessa fase passo-passo. Pertanto, quando un carrello fa scattare l'interruttore di fine corsa, lo stepper che controlla quel carrello dovrebbe essere sempre nella stessa fase del motore passo-passo. Il sistema di fase finecorsa di Klipper combina la fase del motore con l'attivazione del finecorsa per migliorare la precisione.

Per utilizzare questa funzionalità è necessario essere in grado di identificare la fase del motore passo-passo. Se si utilizzano i driver Trinamic TMC2130, TMC2208, TMC2224 o TMC2660 in modalità di configurazione runtime (cioè non in modalità stand-alone), Klipper può interrogare la fase stepper dal driver. (È anche possibile utilizzare questo sistema su driver stepper tradizionali se è possibile ripristinare in modo affidabile i driver stepper - vedere sotto per i dettagli.)

## Taratura fasi dei finecorsa

Se si utilizzano driver Trinamic per motori passo-passo in configurazione runtime, è possibile calibrare le fasi di fine corsa utilizzando il comando ENDSTOP_PHASE_CALIBRATE. Inizia aggiungendo quanto segue al file di configurazione:

```
[endstop_phase]
```

Quindi RIAVVIARE la stampante ed eseguire un comando `G28` seguito da un comando `ENDSTOP_PHASE_CALIBRATE`. Quindi spostare la testina in una nuova posizione ed eseguire nuovamente `G28`. Prova a spostare la testina in diverse posizioni ed esegui nuovamente `G28` da ciascuna posizione. Esegui almeno cinque comandi `G28`.

Dopo aver eseguito quanto sopra, il comando `ENDSTOP_PHASE_CALIBRATE` riporterà spesso la stessa (o quasi) fase per lo stepper. Questa fase può essere salvata nel file di configurazione in modo che tutti i futuri comandi G28 utilizzino quella fase. (Quindi, nelle future operazioni di homing, Klipper otterrà la stessa posizione anche se il finecorsa si attiva un po' prima o un po' dopo.)

Per salvare la fase di fine corsa per un particolare motore passo-passo, eseguire qualcosa di simile a:

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Esegui quanto sopra per tutti gli stepper che desideri salvare. Tipicamente, si usa questo su stepper_z per stampanti cartesiane e corexy e per stepper_a, stepper_b e stepper_c su stampanti delta. Infine, eseguire quanto segue per aggiornare il file di configurazione con i dati:

```
SAVE_CONFIG
```

### Note aggiuntive

* Questa funzione è particolarmente utile sulle stampanti delta e sul fine corsa Z delle stampanti cartesiane/corexy. È possibile utilizzare questa funzione sui fine corsa XY delle stampanti cartesiane, ma ciò non è particolarmente utile poiché è improbabile che un errore minore nella posizione dell'arresto X/Y influisca sulla qualità di stampa. Non è valido utilizzare questa funzione sugli arresti XY delle stampanti corexy (poiché la posizione XY non è determinata da un singolo stepper sulla cinematica corexy). Non è valido utilizzare questa funzione su una stampante che utilizza un fine corsa Z "probe:z_virtual_endstop" (poiché la fase stepper è stabile solo se il fine corsa si trova in una posizione statica su una guida).
* Dopo aver calibrato la fase del finecorsa, se il finecorsa viene successivamente spostato o regolato, sarà necessario ricalibrarlo. Rimuovere i dati di calibrazione dal file di configurazione ed eseguire nuovamente i passaggi precedenti.
* Per utilizzare questo sistema, il finecorsa deve essere sufficientemente preciso da identificare la posizione dello stepper entro due "passi completi". Quindi, ad esempio, se uno stepper utilizza 16 micropassi con una distanza del passo di 0,005 mm, il finecorsa deve avere una precisione di almeno 0,160 mm. Se si ottengono messaggi di errore di tipo "Finecorsa stepper_z non corretto", potrebbero essere dovuti a un finecorsa che non è sufficientemente accurato. Se la ricalibrazione non aiuta, disabilitare le regolazioni della fase finecorsa rimuovendole dal file di configurazione.
* Se si utilizza un tradizionale asse Z controllato da stepper (come su una stampante cartesiana o corexy) insieme alle tradizionali viti di livellamento del letto, è anche possibile utilizzare questo sistema per fare in modo che ogni strato di stampa venga eseguito su un confine "passo completo" . Per abilitare questa funzione, assicurati che lo slicer del G-Code sia configurato con un'altezza del livello che sia un multiplo di un "passo completo", abilita manualmente l'opzione endstop_align_zero nella sezione di configurazione endstop_phase (vedi [config reference](Config_Reference.md#endstop_phase) per ulteriori dettagli), quindi livellare nuovamente le viti del piatto.
* È possibile utilizzare questo sistema con driver per motori passo-passo tradizionali (non Trinamici). Tuttavia, per fare ciò è necessario assicurarsi che i driver del motore passo-passo vengano ripristinati ogni volta che viene ripristinato il microcontrollore. (Se i due vengono sempre ripristinati insieme, Klipper può determinare la fase dello stepper tracciando il numero totale di passaggi che ha comandato allo stepper di muoversi.) Attualmente, l'unico modo per farlo in modo affidabile è se sia il microcontrollore che il motore passo-passo i driver siano alimentati esclusivamente da USB e che l'alimentazione USB sia fornita da un host in esecuzione su un Raspberry Pi. In questa situazione è possibile specificare una configurazione mcu con "restart_method: rpi_usb" - quell'opzione farà in modo che il microcontrollore venga sempre ripristinato tramite un ripristino dell'alimentazione USB, il che farebbe in modo che sia il microcontrollore che i driver del motore passo-passo siano resettare insieme. Se si utilizza questo meccanismo, è necessario configurare manualmente le sezioni di configurazione "trigger_phase" (consultare [config reference](Config_Reference.md#endstop_phase) per i dettagli).
