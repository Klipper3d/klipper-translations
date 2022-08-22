# Anticipo di pressione

Questo documento fornisce informazioni sulla messa a punto della variabile di regolazione de "l'anticipo della pressione" per un particolare ugello e filamento. La funzione di anticipo della pressione può essere utile per ridurre i filamenti. Per maggiori informazioni su come viene implementato l'anticipo di pressione, vedere il documento [kinematics](Kinematics.md).

## Regolazione del pressure advance

Pressure advance fa due cose utili: riduce l 'ooze' durante i movimenti senza estrusione e riduce il blobbing durante le curve. Questa guida utilizza la seconda funzione (riduzione del blobbing durante le curve) come meccanismo per la messa a punto.

Per calibrare la pressure advance, la stampante deve essere configurata e operativa poiché il test di ottimizzazione prevede la stampa e l'ispezione di un oggetto di prova. È una buona idea leggere questo documento per intero prima di eseguire il test.

Usa uno slicer per generare il codice G per il grande cubo vuoto che si trova in [docs/prints/square_tower.stl](prints/square_tower.stl). Utilizzare una velocità elevata (ad es. 100 mm/s), riempimento zero e un'altezza dello strato grossolana (l'altezza dello strato dovrebbe essere circa il 75% del diametro dell'ugello). Assicurati che qualsiasi "controllo dinamico dell'accelerazione" sia disabilitato nello slicer.

Prepararsi per il test emettendo il seguente comando G-Code:

```
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
```

Questo comando fa viaggiare l'ugello più lentamente attraverso gli angoli per enfatizzare gli effetti della pressione dell'estrusore. Quindi per le stampanti con un estrusore a trasmissione diretta eseguire il comando:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

Per estrusori bowden lunghi utilizzare:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020
```

Quindi stampare l'oggetto. Una volta stampata completamente, la stampa di prova avrà il seguente aspetto:

![tuning_tower](img/tuning_tower.jpg)

Il comando TUNING_TOWER sopra indica a Klipper di modificare l'impostazione pressure_advance su ogni strato della stampa. Gli strati più alti nella stampa avranno un valore di anticipo della pressione maggiore impostato. Gli strati al di sotto dell'impostazione pressione_anticipo ideale avranno macchie agli angoli e gli strati al di sopra dell'impostazione ideale possono portare a angoli arrotondati e una scarsa estrusione all'angolo.

È possibile annullare la stampa in anticipo se si osserva che gli angoli non vengono più stampati bene (e quindi si può evitare di stampare livelli noti per essere al di sopra del valore di pressione_avanzamento ideale).

Ispeziona la stampa e quindi utilizza un calibro digitale per trovare l'altezza con gli angoli della migliore qualità. In caso di dubbio, preferire un'altezza inferiore.

![tune_pa](img/tune_pa.jpg)

Il valore pressure_advance può quindi essere calcolato come `pressure_advance = <inizio> + <altezza_misurata> * <fattore>`. (Ad esempio, `0 + 12.90 * .020` sarebbe `.258`.)

È possibile scegliere impostazioni personalizzate per START e FACTOR se ciò aiuta a identificare la migliore impostazione di anticipo della pressione. Quando si esegue questa operazione, assicurarsi di emettere il comando TUNING_TOWER all'inizio di ogni stampa di prova.

I valori tipici di pressure advance sono compresi tra 0,050 e 1,000 (la fascia alta di solito solo con estrusori bowden). Se non vi è alcun miglioramento significativo con un pressure advance fino a 1.000, è improbabile che la pressure advance migliori la qualità delle stampe. Ritorno ad una configurazione di default con pressure advance disabilitato.

Sebbene questo esercizio di messa a punto migliori direttamente la qualità degli angoli, vale la pena ricordare che una buona configurazione del pressure advance riduce anche gli ooze durante la stampa.

Al termine di questo test, impostare `pressure_advance = <calculated_value>` nella sezione `[extruder]` del file di configurazione ed emettere un comando RESTART. Il comando RESTART cancellerà lo stato di test e riporterà le velocità di accelerazione e in curva ai valori normali.

## Note importanti

* Il valore di pressure advance dipende dall'estrusore, dall'ugello e dal filamento. È comune che filamenti di produttori diversi o con pigmenti diversi richiedano valori di pressure advance significativamente diversi. Pertanto, si dovrebbe calibrare pressure advance su ciascuna stampante e con ogni bobina di filamento.
* La temperatura di stampa e le velocità di estrusione possono influire sulla pressure advance. Assicurati di regolare [extruder rotation_distance](Rotation_Distance.md#calibrating-rotation_distance-on-extruders) e [nozzle temperature](http://reprap.org/wiki/Triffid_Hunter%27s_Calibration_Guide#Nozzle_Temperature) prima di regolare l'avanzamento della pressione.
* La stampa di prova è progettata per funzionare con un'elevata portata dell'estrusore, ma per il resto con impostazioni dello slicer "normali". Un'elevata portata si ottiene utilizzando un'elevata velocità di stampa (ad es. 100 mm/s) e un'altezza dello strato grossolano (tipicamente circa il 75% del diametro dell'ugello). Altre impostazioni dello slicer dovrebbero essere simili alle loro impostazioni predefinite (ad esempio, perimetri di 2 o 3 linee, quantità di retrazione normale). Può essere utile impostare la velocità del perimetro esterno in modo che sia la stessa velocità del resto della stampa, ma non è un requisito.
* È comune che la stampa di prova mostri un comportamento diverso su ciascun angolo. Spesso lo slicer provvederà a cambiare i livelli in un angolo, il che può comportare che quell'angolo sia significativamente diverso dai restanti tre angoli. Se ciò si verifica, ignora quell'angolo e regola pressure advance utilizzando gli altri tre angoli. È anche comune che gli angoli rimanenti varino leggermente. (Ciò può verificarsi a causa di piccole differenze nel modo in cui il telaio della stampante reagisce alle curve in determinate direzioni.) Prova a scegliere un valore che funzioni bene per tutti gli angoli rimanenti. In caso di dubbio, preferire un valore di pressure advance inferiore.
* Se viene utilizzato un valore di pressure advance (ad esempio, superiore a 0.200), è possibile che l'estrusore salti quando torna alla normale accelerazione della stampante. Il sistema di pressure advance tiene conto della pressione spingendo il filamento extra durante l'accelerazione e ritraendo quel filamento durante la decelerazione. Con un'elevata accelerazione e un'elevata pressione di anticipo, l'estrusore potrebbe non avere una coppia sufficiente per spingere il filamento richiesto. In tal caso, utilizzare un valore di accelerazione inferiore o disattivare la pressure advance.
* Una volta che pressure advance è stato regolato in Klipper, può essere comunque utile configurare un piccolo valore di retrazione nello slicer (ad es. 0,75 mm) e utilizzare l'opzione "pulizia in retrazione" dello slicer, se disponibile. Queste impostazioni dello slicer possono aiutare a contrastare la trasudazione causata dalla coesione del filamento ( estratto dall'ugello a causa della viscosità della plastica). Si consiglia di disabilitare l'opzione "Z-lift in retrazione" dello slicer.
* Il sistema di pressure advance non modifica i tempi o il percorso della testa di stampa. Una stampa con pressure advance abilitato richiederà lo stesso tempo di una stampa senza pressure advance. Inoltre, pressure advance non modifica la quantità totale di filamento estruso durante una stampa. L a pressure advance determina un movimento extra dell'estrusore durante l'accelerazione e la decelerazione del movimento. Un'impostazione di pressure advance molto elevata risulterà in una quantità molto grande di movimento dell'estrusore durante l'accelerazione e la decelerazione e nessuna impostazione di configurazione pone un limite alla quantità di tale movimento.
