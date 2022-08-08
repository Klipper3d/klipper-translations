# Cinematica

Questo documento è una panoramica su come Klipper implementa la movimentazione del sistema meccanico(la sua [cinematica](https://en.wikipedia.org/wiki/Kinematics)). Questi contenuti potrebbero interessare sia gli sviluppatori che intendono lacorare sul software Klipper che gli utenti che desiderano comprendere meglio il funzionamento delle proprie macchine.

## Accelerazione

Klipper utilizza uno schema ad accelerazione costrante ogni qualvolta la testa di stampa cambia velocità - la velocità viene gradualmente variata fino a raggiungere la nuova velocità invece di strattonare direttamente alla nuova velocità. Klipper mantiene sempre l'accelerazione tra la testa di stampa e la stampa. Il filamento in uscita dall'ugello può essere piuttosto fragile, rapidi sobbalzi e/o cambi di flusso di estrusione portano a cattiva qualità di stampa e bassa adesione al piano di stampa. Anche quando non viene estruso filamento, se l'ugello si trova allo stesso livello della stampa, un repentino cambio di velocità potrebbe disturbare il filamento appena depositato. Limitare i cambi di velocità della testa di stampa relativamente alla stampa riduce il rischio di rovinare la stampa.

È anche importante limitare l'accelerazione in modo da evitare che i motori stepper perdano passi e per ridurre le sollecitazioni alla macchina. Klipper limita la coppia su ciascuno stepper mediante la limitazione dell'accelerazione sulla testina di stampa. Imporre l'accelerazione alla testa di stampa ha la conseguenza naturale di limitare la coppia degli stepper che la muovono (l'inverso non è sempre vero).

Klipper implementa l'accelerazione costante. La formula chiave per l'accelerazione costante è:

```
velocità(tempo) = velocità_inizio + accelerazione*tempo
```

## Generatore di trapezoide

Klipper utilizza un "generatore di trapezoide" di tipo tradizionale per modellare il movimento - ogni movimento ha una velocità iniziale, accelera verso la velocità di crociera ad accelerazione costante, prosegue a velocità costante ed infine decelera fino alla velocità finale ad accelerazione costante.

![trapezoid](img/trapezoid.svg.png)

Viene detto "generatore di trapezoide" perché il diagramma di velocità del movimento sembra un trapezoide.

La velocità di crociera è sempre maggiore o uguale sia alla velocità iniziale che a quella finale. La fase di accelerazione potrebbe avere durata zero (se la velocità iniziale è uguale alla velocità di crociera), la fase di movimento a valocità costante potrebbe avere durata zero (se il movimento inizia a decelerare subito l'accelerazione) e/o la fase di decelerazione potrebbe avere durata zero (se la velocità finale è uguale alla velocità di crociera).

![trapezoids](img/trapezoids.svg.png)

## Look-ahead (Precalcolo)

Il sistema di "look-ahead" (precalcolo) è usato per determinare le velocità nelle giunzioni tra movimenti (cornering speed).

Consideriamo questi due movimenti sul piano XY:

![corner](img/corner.svg.png)

Nella situazione sopra descritta è possibile decelerare completamente dopo il primo movimento e poi accelerare all'inizio del movimento successivo; però questo non è un comportamento ideale dato che continue accelerazioni e decelerazioni aumentano il tempo di stampa e continue variazioni nel flusso dell'estrusore peggiorano la qualità di stampa.

Per risolvere questo problema, la funzione "look-ahead" (precalcolo) accoda i movimenti da eseguire ed analizza gli angoli tra essi per calcolare la velocità da usare nella giunzione tra due movimenti. Se il prossimo movimento è all'incirca nella stessa direzione del precedente, la testina di stampa deve rallentare molto poco (se non per nulla).

![lookahead](img/lookahead.svg.png)

Se però il prossimo movimento forma un angolo acuto (la testina deve praticamente invertire la direzione di marcia), la velocità alla giunzione sarà piccola.

![lookahead](img/lookahead-slow.svg.png)

Le velocità di giunzione sono determinate utilizzando "accelerazione centripeta approssimata". Meglio su [descritto dall'autore](https://onehossshay.wordpress.com/2011/09/24/improving_grbl_cornering_algorithm/). Tuttavia, in Klipper, le velocità di giunzione sono configurate specificando la velocità desiderata che dovrebbe avere un angolo di 90° (la "velocità dell'angolo retto") e da quella vengono derivate le velocità di giunzione per altri angoli.

Formula chiave per il look-ahead:

```
velocità_finale^2 = velocità_iniziale^2 + 2*accelerazione*distanza_movimento
```

### Look-ahead ammorbidito

Klipper implementa anche un meccanismo per smussare i movimenti di brevi movimenti a "zigzag". Considera i seguenti movimenti:

![zigzag](img/zigzag.svg.png)

In quanto sopra, i frequenti passaggi dall'accelerazione alla decelerazione possono causare vibrazioni della macchina che provocano sollecitazioni e aumentano la rumorosità. Per ridurre questo, Klipper tiene traccia sia dell'accelerazione di movimento regolare che di una velocità virtuale di "accelerazione alla decelerazione". Utilizzando questo sistema, la velocità massima di questi brevi movimenti a "zigzag" è limitata per rendere più fluido il movimento della stampante:

![smoothed](img/smoothed.svg.png)

In particolare, il codice calcola quale sarebbe la velocità di ogni mossa se fosse limitata a questa velocità di "accelerazione alla decelerazione" virtuale (la metà della velocità di accelerazione normale per impostazione predefinita). Nell'immagine sopra le linee grigie tratteggiate rappresentano questa velocità di accelerazione virtuale per il primo movimento. Se un movimento non può raggiungere la sua piena velocità di crociera usando questa velocità di accelerazione virtuale, la sua velocità massima viene ridotta alla velocità massima che potrebbe ottenere a questa velocità di accelerazione virtuale. Per la maggior parte dei movimenti il limite sarà pari o superiore ai limiti esistenti del movimento e non verrà indotto alcun cambiamento nel comportamento. Per brevi movimenti a zigzag, tuttavia, questo limite riduce la velocità massima. Nota che non cambia l'accelerazione effettiva all'interno del movimento: Il movimento continua a utilizzare lo schema di accelerazione normale fino alla sua velocità massima regolata.

## Generazione di passi

Una volta completato il processo di look-ahead, il movimento della testina di stampa per il dato spostamento è completamente noto (tempo, posizione iniziale, posizione finale, velocità in ogni punto) ed è possibile generare i tempi di passaggio per lo spostamento. Questo processo viene eseguito all'interno di "classi cinematiche" nel codice di Klipper. Al di fuori di queste classi cinematiche, tutto viene tracciato in millimetri, secondi e nello spazio delle coordinate cartesiane. È compito delle classi cinematiche convertire da questo sistema di coordinate generico alle specifiche hardware di una particolare stampante.

Klipper utilizza un [risolutore iterativo](https://en.wikipedia.org/wiki/Root-finding_algorithm) per generare i tempi dei passo per ogni stepper. Il codice contiene le formule per calcolare le coordinate cartesiane ideali della testa in ogni momento e ha le formule cinematiche per calcolare le posizioni ideali dello stepper in base a quelle coordinate cartesiane. Con queste formule, Klipper può determinare il tempo ideale in cui lo stepper dovrebbe trovarsi in ogni posizione del passo. I passaggi indicati vengono quindi programmati in questi orari calcolati.

La formula chiave per determinare la distanza che un movimento deve percorrere con un'accelerazione costante è:

```
distanza_movimento = (velocita_iniziale + .5 * accelerazione *durata_movimento) * durata_movimento
```

e la formula chiave per il movimento a velocità costante è:

```
distanza_movimento = velocità_crociera * durata_movimento
```

Le formule chiave per determinare la coordinata cartesiana di un movimento data una distanza di movimento sono:

```
cartesian_x_position = start_x + move_distance * total_x_movement / total_movement
cartesian_y_position = start_y + move_distance * total_y_movement / total_movement
cartesian_z_position = start_z + move_distance * total_z_movement / total_movement
```

### Robot Cartesiani

La generazione di passaggi per stampanti cartesiane è il caso più semplice. Il movimento su ciascun asse è direttamente correlato al movimento nello spazio cartesiano.

Formule chiave:

```
stepper_x_position = cartesian_x_position
stepper_y_position = cartesian_y_position
stepper_z_position = cartesian_z_position
```

### Robot CoreXY

La generazione di passaggi su una macchina CoreXY è solo un po' più complessa dei robot cartesiani di base. Le formule chiave sono:

```
stepper_a_position = cartesian_x_position + cartesian_y_position
stepper_b_position = cartesian_x_position - cartesian_y_position
stepper_z_position = cartesian_z_position
```

### Robot Delta

La generazione di passi su un robot delta si basa sul teorema di Pitagora:

```
stepper_position = (sqrt(arm_length^2
                         - (cartesian_x_position - tower_x_position)^2
                         - (cartesian_y_position - tower_y_position)^2)
                    + cartesian_z_position)
```

### Limiti di accelerazione del motore passo-passo

Con la cinematica delta è possibile che un movimento che sta accelerando nello spazio cartesiano richieda un'accelerazione su un particolare motore passo-passo maggiore dell'accelerazione del movimento. Ciò può verificarsi quando un braccio dello stepper è più orizzontale che verticale e la linea di movimento passa vicino alla torre dello stepper. Sebbene questi movimenti possano richiedere un'accelerazione del motore passo-passo maggiore dell'accelerazione di movimento massima configurata della stampante, la massa effettiva spostata da quel passo-passo sarebbe inferiore. Pertanto la maggiore accelerazione stepper non si traduce in una coppia stepper significativamente più elevata ed è quindi considerata innocua.

Tuttavia, per evitare casi estremi, Klipper impone un limite massimo all'accelerazione stepper di tre volte l'accelerazione di movimento massima configurata della stampante. (Allo stesso modo, la velocità massima dello stepper è limitata a tre volte la velocità massima di spostamento.) Per far rispettare questo limite, i movimenti sul bordo estremo dell'inviluppo (dove un braccio dello stepper può essere quasi orizzontale) avranno un massima accelerazione e velocità.

### Cinematica dell'estrusore

Klipper implementa il movimento dell'estrusore nella propria classe cinematica. Poiché i tempi e la velocità di ogni movimento della testina di stampa sono completamente noti per ogni movimento, è possibile calcolare i tempi di passaggio per l'estrusore indipendentemente dai calcoli del tempo di passaggio del movimento della testina di stampa.

Il movimento di base dell'estrusore è semplice da calcolare. La generazione del tempo di passaggio utilizza le stesse formule utilizzate dai robot cartesiani:

```
stepper_position = requested_e_position
```

### Anticipo di pressione

La sperimentazione ha dimostrato che è possibile migliorare la modellazione dell'estrusore oltre la formula di base dell'estrusore. Nel caso ideale, mentre un movimento di estrusione avanza, lo stesso volume di filamento dovrebbe essere depositato in ogni punto lungo il movimento e non dovrebbe esserci volume estruso dopo il movimento. Sfortunatamente, è comune scoprire che le formule di estrusione di base fanno sì che una quantità insufficiente di filamento fuoriesca dall'estrusore all'inizio dei movimenti di estrusione e che il filamento in eccesso venga estruso al termine dell'estrusione. Questo è spesso indicato come "melma" "ooze".

![ooze](img/ooze.svg.png)

Il sistema di "pressure advance" tenta di spiegare ciò utilizzando un modello diverso per l'estrusore. Invece di credere ingenuamente che ogni mm^3 di filamento alimentato nell'estrusore comporterà l'uscita immediata di quella quantità di mm^3 dall'estrusore, utilizza un modello basato sulla pressione. La pressione aumenta quando il filamento viene spinto nell'estrusore (come in [Legge di Hook](https://en.wikipedia.org/wiki/Hooke%27s_law)) e la pressione necessaria per estrudere è dominata dalla portata attraverso l'orifizio dell'ugello (come nella [legge di Poiseuille](https://en.wikipedia.org/wiki/Poiseuille_law)). L'idea chiave è che la relazione tra filamento, pressione e portata può essere modellata utilizzando un coefficiente lineare:

```
pa_position = nominal_position + pressure_advance_coefficient * nominal_velocity
```

Per informazioni su come trovare questo coefficiente di anticipo della pressione, vedere il documento [Pressure Advance](Pressure_Advance.md).

La formula di base del pressure advance può far sì che il motore dell'estrusore apporti improvvisi cambiamenti di velocità. Klipper implementa la "smussatura" del movimento dell'estrusore per evitarlo.

![pressure-advance](img/pressure-velocity.png)

Il grafico sopra mostra un esempio di due movimenti di estrusione con una velocità in curva diversa da zero tra di loro. Si noti che il sistema di pressure advance fa sì che il filamento aggiuntivo venga spinto nell'estrusore durante l'accelerazione. Maggiore è la portata del filamento desiderata, più filamento deve essere spinto durante l'accelerazione per tenere conto della pressione. Durante la decelerazione della testa il filamento extra viene retratto (l'estrusore avrà una velocità negativa).

Lo "smussamento" viene implementato utilizzando una media pesata della posizione dell'estrusore in un breve periodo di tempo (come specificato dal parametro di configurazione `pressure_advance_smooth_time`). Questa media può estendersi su più mosse del codice G. Notare come il motore dell'estrusore inizierà a muoversi prima dell'inizio nominale del primo movimento di estrusione e continuerà a muoversi dopo la fine nominale dell'ultimo movimento di estrusione.

Formula chiave per "smoothed pressure advance":

```
smooth_pa_position(t) =
    ( definitive_integral(pa_position(x) * (smooth_time/2 - abs(t - x)) * dx,
                          from=t-smooth_time/2, to=t+smooth_time/2)
     / (smooth_time/2)^2 )
```
