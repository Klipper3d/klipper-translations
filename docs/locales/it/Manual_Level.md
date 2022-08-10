# Livellamento manuale

Questo documento descrive gli strumenti per la calibrazione di un finecorsa Z e per l'esecuzione delle regolazioni delle viti di livellamento del piatto.

## Calibrazione di un finecorsa Z

Una posizione precisa del fine corsa Z è fondamentale per ottenere stampe di alta qualità.

Si noti, tuttavia, che la precisione dell'interruttore di fine corsa Z stesso può essere un fattore limitante. Se si utilizzano i driver per motori passo-passo Trinamic, considerare l'abilitazione del rilevamento [fase finecorsa](Endstop_Phase.md) per migliorare la precisione dell'interruttore.

Per eseguire una calibrazione del fine corsa Z, portare la stampante in posizione di partenza, comandare alla testina di spostarsi in una posizione Z che sia almeno cinque millimetri sopra il piatto (se non lo è già), comandare alla testina di spostarsi in una posizione XY vicino al centro di piatto, quindi vai alla scheda del terminale OctoPrint ed esegui:

```
Z_ENDSTOP_CALIBRATE
```

Quindi segui i passaggi descritti in ["the paper test"](Bed_Level.md#the-paper-test) per determinare la distanza effettiva tra l'ugello e il piatto in una determinata posizione. Una volta completati questi passaggi, è possibile "ACCETTARE" la posizione e salvare i risultati nel file di configurazione con:

```
SAVE_CONFIG
```

È preferibile utilizzare un interruttore di fine corsa Z sull'estremità opposta dell'asse Z rispetto al piatto. (L'allontanamento dal piatto è più robusto in quanto generalmente è sempre sicuro mettere a home la Z.) Tuttavia, se si deve tornare a home verso il piatto, si consiglia di regolare il finecorsa in modo che si attivi a una piccola distanza (ad es. 0,5 mm ) sopra il piatto. Quasi tutti gli interruttori di fine corsa possono essere premuti in sicurezza a una piccola distanza oltre il punto di attivazione. Fatto ciò, si dovrebbe scoprire che il comando `Z_ENDSTOP_CALIBRATE` riporta un piccolo valore positivo (ad esempio, .5mm) per Z position_endstop. L'attivazione del fine corsa mentre si è ancora a una certa distanza dal piatto riduce il rischio di incidenti involontari del piatto.

Alcune stampanti hanno la capacità di regolare manualmente la posizione dell'interruttore di fine corsa fisico. Tuttavia, si consiglia di eseguire il posizionamento del finecorsa Z nel software con Klipper: una volta che la posizione fisica del finecorsa è in una posizione comoda, è possibile apportare ulteriori modifiche eseguendo Z_ENDSTOP_CALIBRATE o aggiornando manualmente Z position_endstop nel file di configurazione.

## Regolazione delle viti di livellamento del piatto

Il segreto per ottenere un buon livellamento del piatto con le viti di livellamento è utilizzare il sistema di movimento ad alta precisione della stampante durante il processo di livellamento del piatto stesso. Questo viene fatto comandando l'ugello in una posizione vicino a ciascuna vite del piatto e quindi regolando quella vite fino a quando il piatto non è a una distanza prestabilita dall'ugello. Klipper ha uno strumento per aiutare con questo. Per utilizzare lo strumento è necessario specificare la posizione XY di ciascuna vite.

Questo viene fatto creando una sezione di configurazione `[bed_screws]`. Ad esempio, potrebbe sembrare qualcosa di simile a:

```
[bed_screws]
screw1: 100, 50
screw2: 100, 150
screw3: 150, 100
```

Se una vite del piatto è sotto il piatto, specificare la posizione XY direttamente sopra la vite. Se la vite è fuori dal piatto, specificare una posizione XY più vicina alla vite che sia ancora all'interno del raggio del piatto.

Una volta che il file di configurazione è pronto, esegui `RESTART` per caricare quella configurazione, quindi puoi avviare lo strumento eseguendo:

```
BED_SCREWS_ADJUST
```

Questo strumento sposterà l'ugello della stampante in ciascuna posizione XY della vite e quindi sposterà l'ugello a un'altezza Z=0. A questo punto si può utilizzare la "prova della carta" per regolare la vite del piatto direttamente sotto l'ugello. Vedere le informazioni descritte in ["the paper test"](Bed_Level.md#the-paper-test), ma regolare la vite del piatto invece di comandare l'ugello ad altezze diverse. Regolare la vite del piatto finché non c'è una piccola quantità di attrito quando si spinge la carta avanti e indietro.

Una volta che la vite è stata regolata in modo da avvertire una piccola quantità di attrito, eseguire il comando `ACCEPT` o`ADJUSTED`. Utilizzare il comando `ADJUSTED` se la vite del piatto necessita di una regolazione (in genere qualcosa di più di circa 1/8 di giro della vite). Utilizzare il comando `ACCEPT` se non sono necessarie modifiche significative. Entrambi i comandi faranno sì che lo strumento proceda alla vite successiva. (Quando viene utilizzato un comando `ADJUSTED`, lo strumento pianificherà un ciclo aggiuntivo di regolazioni delle viti di appoggio; lo strumento viene completato correttamente quando tutte le viti di appoggio vengono verificate e non richiedono regolazioni significative.) È possibile utilizzare il comando 'ABORT' per uscire lo strumento in anticipo.

Questo sistema funziona al meglio quando la stampante ha una superficie di stampa piatta (come il vetro) e ha binari diritti. Dopo aver completato con successo lo strumento di livellamento del piatto, il piatto dovrebbe essere pronto per la stampa.

### Regolazione fine della vite del piatto

Se la stampante utilizza tre viti del piatto e tutte e tre le viti sono sotto il piatto, potrebbe essere possibile eseguire una seconda fase di livellamento del piatto "ad alta precisione". Questo viene fatto comandando l'ugello in punti in cui il piatto si sposta di una distanza maggiore con ciascuna regolazione della vite del piatto.

Ad esempio, considera un piatto con viti nelle posizioni A, B e C:

![bed_screws](img/bed_screws.svg.png)

Per ogni regolazione effettuata alla vite del piatto nella posizione C, il piatto oscillerà lungo un pendolo definito dalle restanti due viti del piatto (mostrate qui come una linea verde). In questa situazione, ogni regolazione della vite del piatto in C sposterà il letto nella posizione D di una quantità maggiore rispetto a C. È quindi possibile effettuare una regolazione della vite C migliorata quando l'ugello è in posizione D.

Per abilitare questa funzione, si dovrebbero determinare le coordinate dell'ugello aggiuntive e aggiungerle al file di configurazione. Ad esempio, potrebbe essere simile a:

```
[bed_screws]
screw1: 100, 50
screw1_fine_adjust: 0, 0
screw2: 100, 150
screw2_fine_adjust: 300, 300
screw3: 150, 100
screw3_fine_adjust: 0, 100
```

Quando questa funzione è abilitata, lo strumento `BED_SCREWS_ADJUST` richiederà prima le regolazioni grossolane direttamente sopra ogni posizione della vite e, una volta accettate, richiederà le regolazioni fini nelle posizioni aggiuntive. Continua a usare `ACCEPT` e `ADJUSTED` in ogni posizione.

## Regolazione delle viti di livellamento del piatto mediante la sonda del piatto

Questo è un altro modo per calibrare il livello del piatto utilizzando la sonda del piatto. Per utilizzarlo è necessario disporre di una sonda Z (BL Touch, Sensore induttivo, ecc).

Per abilitare questa funzione, si dovrebbero determinare le coordinate dell'ugello in modo tale che la sonda Z sia sopra le viti, quindi aggiungerle al file di configurazione. Ad esempio, potrebbe essere simile a:

```
[screws_tilt_adjust]
screw1: -5, 30
screw1_name: front left screw
screw2: 155, 30
screw2_name: front right screw
screw3: 155, 190
screw3_name: rear right screw
screw4: -5, 190
screw4_name: rear left screw
horizontal_move_z: 10.
speed: 50.
screw_thread: CW-M3
```

La vite1 è sempre il punto di riferimento per le altre, quindi il sistema presume che la vite1 sia all'altezza corretta. Eseguire sempre prima `G28` e poi eseguire `SCREWS_TILT_CALCULATE` - dovrebbe produrre un output simile a:

```
Send: G28
Recv: ok
Send: SCREWS_TILT_CALCULATE
Recv: // 01:20 means 1 full turn and 20 minutes, CW=clockwise, CCW=counter-clockwise
Recv: // front left screw (base) : x=-5.0, y=30.0, z=2.48750
Recv: // front right screw : x=155.0, y=30.0, z=2.36000 : adjust CW 01:15
Recv: // rear right screw : y=155.0, y=190.0, z=2.71500 : adjust CCW 00:50
Recv: // read left screw : x=-5.0, y=190.0, z=2.47250 : adjust CW 00:02
Recv: ok
```

Ciò significa che:

- la vite anteriore sinistra è il punto di riferimento non devi cambiarla.
- la vite anteriore destra deve essere ruotata in senso orario di 1 giro completo e un quarto di giro
- la vite posteriore destra deve essere ruotata in senso antiorario per '50 minuti'
- la vite posteriore sinistra deve essere ruotata in senso orario '2 minuti' (non serve va bene)

Si noti che "minuti" si riferisce ai "minuti di un quadrante". Quindi, ad esempio, 15 minuti sono un quarto di giro completo.

Ripeti il processo più volte fino a ottenere un piatto ben livellato, normalmente quando tutte le regolazioni richiedono meno di 6 minuti.

Se si utilizza una sonda montata sul lato dell'hotend (ovvero, ha un offset X o Y), tenere presente che la regolazione dell'inclinazione del piatto invaliderà qualsiasi precedente calibrazione della sonda eseguita con unpiatto inclinato. Assicurarsi di eseguire [calibrazione sonda](Probe_Calibrate.md) dopo aver regolato le viti del piatto.

Il parametro `MAX_DEVIATION` è utile quando viene utilizzata una mesh del piatto salvata, per garantire che il livello del pitto non si sia spostato troppo lontano da dove si trovava quando è stata creata la mesh. Ad esempio, `SCREWS_TILT_CALCULATE MAX_DEVIATION=0.01` può essere aggiunto al gcode iniziale personalizzato dello slicer prima del caricamento della mesh. Interromperà la stampa se viene superato il limite configurato (0,01 mm in questo esempio), dando all'utente la possibilità di regolare le viti e riavviare la stampa.

Il parametro `DIRECTION` è utile se puoi ruotare le viti di regolazione del piatto in una sola direzione. Ad esempio, potresti avere viti che iniziano a stringere nella posizione più bassa (o più alta) possibile, che possono essere ruotate solo in una sola direzione, per alzare (o abbassare) il piatto. Se puoi girare le viti solo in senso orario, esegui `SCREWS_TILT_CALCULATE DIRECTION=CW`. Se puoi ruotarli solo in senso antiorario, esegui `SCREWS_TILT_CALCULATE DIRECTION=CCW`. Verrà scelto un punto di riferimento idoneo in modo tale che il piatto possa essere livellato ruotando tutte le viti nella direzione indicata.
