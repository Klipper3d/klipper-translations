# Livellamento del piatto

La livellatura del letto è fondamentale per ottenere stampe di alta qualità. Se un letto non è adeguatamente "livellato" può portare a una scarsa adesione del letto, a una "deformazione" e a problemi minori durante la stampa. Questo documento serve come guida per eseguire il livellamento del letto in Klipper.

È importante comprendere l'obiettivo del livellamento del piatto. Se alla stampante viene comandata una posizione `X0 Y0 Z10` durante una stampa, l'obiettivo è che l'ugello della stampante si trovi esattamente a 10 mm dal letto della stampante. Inoltre, se poi la stampante dovesse essere comandata in una posizione di `X50 Z10`, l'obiettivo è che l'ugello mantenga una distanza esatta di 10 mm dal letto durante l'intero movimento orizzontale.

Per ottenere stampe di buona qualità, la stampante deve essere calibrata in modo che le distanze Z siano precise entro circa 25 micron (0,025 mm). Questa è una piccola distanza, significativamente più piccola della larghezza di un tipico capello umano. Questa scala non può essere misurata "a occhio". Gli effetti sottili (come l'espansione del calore) influiscono sulle misurazioni a questa scala. Il segreto per ottenere un'elevata precisione è utilizzare un processo ripetibile e un metodo di livellamento che sfrutti l'elevata precisione del sistema di movimento della stampante.

## Scegliere il meccanismo di calibrazione appropriato

Diversi tipi di stampanti utilizzano metodi diversi per eseguire il livellamento del piatto. Tutti alla fine dipendono dal "test cartaceo" (descritto di seguito). Tuttavia, il processo effettivo per un particolare tipo di stampante è descritto in altri documenti.

Prima di eseguire uno di questi strumenti di calibrazione, assicurarsi di eseguire i controlli descritti nel [document check di configurazione](Config_checks.md). È necessario verificare il movimento di base della stampante prima di eseguire il livellamento del piatto.

Per le stampanti con una "sonda Z automatica", assicurarsi di calibrare la sonda seguendo le istruzioni nel documento [Probe Calibrate](Probe_Calibrate.md). Per le stampanti delta, vedere il documento [Delta Calibrate](Delta_Calibrate.md). Per le stampanti con viti di fissaggio e fermi Z tradizionali, vedere il documento [Manual Level](Manual_Level.md).

Durante la calibrazione potrebbe essere necessario impostare la Z `position_min` della stampante su un numero negativo (ad esempio, `position_min = -2`). La stampante applica i controlli dei confini anche durante le routine di calibrazione. L'impostazione di un numero negativo consente alla stampante di spostarsi al di sotto della posizione nominale del piatto, il che può aiutare quando si tenta di determinare la posizione effettiva del piatto.

## Il "test con la carta"

Il meccanismo primario di calibrazione del piatto primario è il "test della carta". Si tratta di posizionare un normale pezzo di "carta per fotocopiatrice" tra il piatto della stampante e l'ugello, quindi comandare l'ugello a diverse altezze Z finché non si avverte una piccola quantità di attrito quando si spinge la carta avanti e indietro.

È importante comprendere il "test della carta" anche se si dispone di una "sonda Z automatica". La sonda stessa deve spesso essere calibrata per ottenere buoni risultati. La calibrazione della sonda viene eseguita utilizzando questo "test della carta".

Per eseguire il test della carta, taglia un piccolo pezzo di carta rettangolare usando un paio di forbici (es. 5x3 cm). La carta ha generalmente uno spessore di circa 100 micron (0,100 mm). (Lo spessore esatto della carta non è cruciale.)

Il primo passaggio del test della carta consiste nell'ispezione dell'ugello e del piatto della stampante. Assicurati che non ci sia plastica (o altri detriti) sull'ugello o sul letto.

**Ispeziona l'ugello e il piatto per assicurarti che non sia presente plastica!**

Se si stampa sempre su un determinato nastro o superficie di stampa, è possibile eseguire il test della carta con quel nastro/superficie in posizione. Tuttavia, tieni presente che il nastro stesso ha uno spessore e nastri diversi (o qualsiasi altra superficie di stampa) influiranno sulle misurazioni Z. Assicurati di eseguire nuovamente il test della carta per misurare ogni tipo di superficie in uso.

Se c'è della plastica sull'ugello, riscalda l'estrusore e usa una pinzetta di metallo per rimuovere quella plastica. Attendere che l'estrusore si raffreddi completamente a temperatura ambiente prima di continuare con il test della carta. Mentre l'ugello si sta raffreddando, usa le pinzette di metallo per rimuovere la plastica che potrebbe fuoriuscire.

**Esegui sempre il test della carta quando sia l'ugello che il letto sono a temperatura ambiente!**

Quando l'ugello è riscaldato, la sua posizione (rispetto al piatto) cambia a causa dell'espansione termica. Questa espansione termica è in genere di circa 100 micron, che ha all'incirca lo stesso spessore di un tipico pezzo di carta per stampante. L'esatta quantità di espansione termica non è cruciale, così come lo spessore esatto della carta non è cruciale. Inizia con il presupposto che i due siano uguali (vedi sotto per un metodo per determinare la differenza tra le due distanze).

Può sembrare strano calibrare la distanza a temperatura ambiente quando l'obiettivo è avere una distanza costante quando riscaldata. Tuttavia, se si calibra quando l'ugello è riscaldato, tende a rilasciare piccole quantità di plastica fusa alla carta, il che cambia la quantità di attrito sentito. Ciò rende più difficile ottenere una buona calibrazione. La calibrazione mentre il letto/ugello è caldo aumenta notevolmente anche il rischio di ustione. La quantità di espansione termica è stabile, quindi è facilmente contabilizzabile più avanti nel processo di calibrazione.

**Utilizza uno strumento automatizzato per determinare l'altezza Z precisa!**

Klipper ha diversi script di supporto disponibili (ad esempio, MANUAL_PROBE, Z_ENDSTOP_CALIBRATE, PROBE_CALIBRATE, DELTA_CALIBRATE). Consulta i documenti [descritti sopra](#scegli-il-meccanismo-di-calibrazione-appropriato) per sceglierne uno.

Eseguire il comando appropriato nella finestra del terminale di OctoPrint. Lo script richiederà l'interazione dell'utente nell'output del terminale OctoPrint. Sembrerà qualcosa come:

```
Recv: // Starting manual Z probe. Use TESTZ to adjust position.
Recv: // Finish with ACCEPT or ABORT command.
Recv: // Z position: ?????? --> 5.000 <-- ??????
```

L'altezza attuale dell'ugello (come la intende attualmente la stampante) è mostrata tra "--> <--". Il numero a destra è l'altezza dell'ultimo tentativo di sonda appena maggiore dell'altezza attuale e a sinistra è l'ultimo tentativo di sonda inferiore all'altezza attuale (o ?????? se non è stato effettuato alcun tentativo).

Metti la carta tra l'ugello e il letto. Può essere utile piegare un angolo della carta in modo che sia più facile da afferrare. (Cerca di non spingere il piatto quando muovi la carta avanti e indietro.)

![paper-test](img/paper-test.jpg)

Utilizzare il comando TESTZ per richiedere all'ugello di avvicinarsi alla carta. Per esempio:

```
TESTZ Z=-.1
```

Il comando TESTZ sposterà l'ugello di una distanza relativa dalla posizione corrente dell'ugello. (Quindi, `Z=-.1` richiede che l'ugello si avvicini al piatto di 0,1 mm.) Dopo che l'ugello ha smesso di muoversi, spingere la carta avanti e indietro per controllare se l'ugello è in contatto con la carta e per sentire la quantità di attrito. Continua a emettere comandi TESTZ finché non si avverte una piccola quantità di attrito durante il test con la carta.

Se si trova troppo attrito, è possibile utilizzare un valore Z positivo per spostare l'ugello verso l'alto. È anche possibile utilizzare `TESTZ Z=+` o `TESTZ Z=-` per "sezionare in due" l'ultima posizione, ovvero per spostarsi in una posizione a metà strada tra due posizioni. Ad esempio, se si riceve il seguente prompt da un comando TESTZ:

```
Recv: // Z position: 0.130 --> 0.230 <-- 0.280
```

Quindi un `TESTZ Z=-` sposterebbe l'ugello in una posizione Z di 0,180 (a metà strada tra 0,130 e 0,230). È possibile utilizzare questa funzione per ridurre rapidamente a un attrito costante. È anche possibile usare `Z=++` e `Z=--` per tornare direttamente a una misurazione passata - per esempio, dopo il prompt sopra un comando `TESTZ Z=--` sposterebbe l'ugello su una Z posizione di 0,130.

Dopo aver trovato una piccola quantità di attrito, eseguire il comando ACCETTA:

```
ACCEPT
```

Questo accetterà l'altezza Z data e procederà con lo strumento di calibrazione fornito.

L'esatta quantità di attrito percepito non è cruciale, così come la quantità di espansione termica e l'esatta larghezza della carta non sono cruciali. Cerca solo di ottenere la stessa quantità di attrito ogni volta che esegui il test.

Se qualcosa va storto durante il test, è possibile utilizzare il comando `ABORT` per uscire dallo strumento di calibrazione.

## Determinare l'espansione termica

Dopo aver eseguito con successo il livellamento del piatto, si può continuare a calcolare un valore più preciso per l'impatto combinato di "espansione termica", "spessore della carta" e "quantità di attrito sentito durante il test della carta".

Questo tipo di calcolo generalmente non è necessario poiché la maggior parte degli utenti ritiene che il semplice "test cartaceo" fornisca buoni risultati.

Il modo più semplice per eseguire questo calcolo è stampare un oggetto di prova con pareti dritte su tutti i lati. Il cubo vuoto che si trova in [docs/prints/square.stl](prints/square.stl) può essere usato per questo. Quando si fa lo slicing l'oggetto, assicurarsi che lo slicer utilizzi la stessa altezza del livello e la stessa larghezza di estrusione per il primo livello che utilizza per tutti i livelli successivi. Utilizzare un'altezza dello strato grossolana (l'altezza dello strato dovrebbe essere circa il 75% del diametro dell'ugello) e non utilizzare un bordo o una raft.

Stampa l'oggetto di prova, attendi che si raffreddi e rimuovilo dal letto. Ispeziona lo strato più basso dell'oggetto. (Può anche essere utile far scorrere un dito o un'unghia lungo il bordo inferiore.) Se si scopre che lo strato inferiore si gonfia leggermente lungo tutti i lati dell'oggetto, significa che l'ugello era leggermente più vicino al letto di quanto dovrebbe essere. Si può emettere un comando `SET_GCODE_OFFSET Z=+.010` per aumentare l'altezza. Nelle stampe successive è possibile controllare questo comportamento e apportare ulteriori modifiche secondo necessità. Le regolazioni di questo tipo sono in genere in 10 micron (0,010 mm).

Se il livello inferiore appare costantemente più stretto dei livelli successivi, è possibile utilizzare il comando SET_GCODE_OFFSET per effettuare una regolazione Z negativa. Se non si è sicuri, è possibile diminuire la regolazione Z finché lo strato inferiore delle stampe non mostra un piccolo rigonfiamento, quindi arretrare finché non scompare.

Il modo più semplice per applicare la regolazione Z desiderata è creare una macro di G-code START_PRINT, fare in modo che lo slicer chiami quella macro all'inizio di ogni stampa e aggiungere un comando SET_GCODE_OFFSET a quella macro. Per ulteriori dettagli, vedere il documento [slicers](Slicers.md).
