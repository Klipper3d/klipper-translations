# Calibrazione delta

Questo documento descrive il sistema di calibrazione automatica di Klipper per stampanti "delta".

La calibrazione delta implica la ricerca delle posizioni dei finecorsa della torre, degli angoli della torre, del raggio delta e delle lunghezze del braccio delta. Queste impostazioni controllano il movimento della stampante su una stampante delta. Ognuno di questi parametri ha un impatto non evidente e non lineare ed è difficile calibrarli manualmente. Al contrario, il codice di calibrazione del software può fornire risultati eccellenti in pochi minuti di tempo. Non è necessario alcun hardware di rilevamento speciale.

In definitiva, la calibrazione delta dipende dalla precisione degli interruttori di fine corsa della torre. Se si utilizzano i driver per motori passo-passo Trinamic, considerare l'abilitazione del rilevamento [fase endstop](Endstop_Phase.md) per migliorare la precisione di tali interruttori.

## Sonda automatica vs manuale

Klipper supporta la calibrazione dei parametri delta tramite un metodo di sonda manuale o tramite una sonda Z automatica.

Numerosi kit di stampanti delta sono dotati di sonde Z automatiche che non sono sufficientemente accurate (in particolare, piccole differenze nella lunghezza del braccio possono causare l'inclinazione dell'effettore che può distorcere una sonda automatica). Se si utilizza una sonda automatica, prima [calibrare la sonda](Probe_Calibrate.md) e quindi verificare la presenza di un [bias posizione sonda](Probe_Calibrate.md#location-bias-check). Se la sonda automatica ha una polarizzazione superiore a 25 micron (0,025 mm), utilizzare invece la sonda manuale. Il probing manuale richiede solo pochi minuti ed elimina l'errore introdotto dalla sonda.

Se si utilizza una sonda montata sul lato dell'hotend (ovvero ha un offset X o Y), tenere presente che l'esecuzione della calibrazione delta invaliderà i risultati della calibrazione della sonda. Questi tipi di sonde sono raramente adatti per l'uso su un delta (poiché una minore inclinazione dell'effettore risulterà in una distorsione della posizione della sonda). Se si utilizza comunque la sonda, assicurarsi di eseguire nuovamente la calibrazione della sonda dopo qualsiasi calibrazione delta.

## Calibrazione delta di base

Klipper ha un comando DELTA_CALIBRATE che può eseguire la calibrazione delta di base. Questo comando sonda sette diversi punti sul letto e calcola nuovi valori per gli angoli della torre, i punti terminali della torre e il raggio delta.

Per eseguire questa calibrazione devono essere forniti i parametri delta iniziali (lunghezze dei bracci, raggio e posizioni dei finecorsa) e devono avere una precisione di pochi millimetri. La maggior parte dei kit della stampante delta fornisce questi parametri: configurare la stampante con queste impostazioni predefinite iniziali e quindi eseguire il comando DELTA_CALIBRATE come descritto di seguito. Se non sono disponibili impostazioni predefinite, cercare online una guida alla calibrazione delta che possa fornire un punto di partenza di base.

Durante il processo di calibrazione delta potrebbe essere necessario che la stampante sondi al di sotto di quello che altrimenti sarebbe considerato il piano del piatto. È tipico consentire ciò durante la calibrazione aggiornando la configurazione in modo che `minimum_z_position=-5` della stampante. (Una volta completata la calibrazione, è possibile rimuovere questa impostazione dalla configurazione.)

Ci sono due modi per eseguire la procedura: probing manuale (`DELTA_CALIBRATE METHOD=manual`) e automatica (`DELTA_CALIBRATE`). Il metodo di rilevamento manuale sposterà la testa vicino al piatto e quindi attenderà che l'utente segua i passaggi descritti in ["test della carta"](Bed_Level.md#the-paper-test) per determinare la distanza effettiva tra l'ugello e letto nel luogo indicato.

Per eseguire la misura di base, assicurati che la configurazione abbia una sezione [delta_calibrate] definita e quindi esegui lo strumento:

```
G28
DELTA_CALIBRATE METHOD=manual
```

Dopo aver sondato i sette punti verranno calcolati i nuovi parametri delta. Salva e applica questi parametri eseguendo:

```
SAVE_CONFIG
```

La calibrazione di base dovrebbe fornire parametri delta sufficientemente accurati per la stampa di base. Se si tratta di una nuova stampante, questo è un buon momento per stampare alcuni oggetti di base e verificarne la funzionalità generale.

## Calibrazione delta migliorata

La calibrazione delta di base generalmente fa un buon lavoro nel calcolo dei parametri delta in modo tale che l'ugello sia alla distanza corretta dal letto. Tuttavia, non tenta di calibrare la precisione dimensionale X e Y. È una buona idea eseguire una calibrazione delta avanzata per verificare l'accuratezza dimensionale.

Questa procedura di calibrazione richiede la stampa di un oggetto di prova e la misurazione di parti di tale oggetto di prova con un calibro digitale.

Prima di eseguire una calibrazione delta avanzata, è necessario eseguire la calibrazione delta di base (tramite il comando DELTA_CALIBRATE) e salvare i risultati (tramite il comando SAVE_CONFIG). Assicurati che non siano state apportate modifiche degne di nota alla configurazione della stampante né all'hardware dall'ultima esecuzione di una calibrazione delta di base (se non sei sicuro, esegui nuovamente la [calibrazione delta di base](#basic-delta-calibration), incluso SAVE_CONFIG, appena prima della stampa l'oggetto di prova descritto di seguito.)

Usa uno slicer per generare il G-code dal file [docs/prints/calibrate_size.stl](prints/calibrate_size.stl). Estrudere l'oggetto a bassa velocità (ad es. 40 mm/s). Se possibile, usa una plastica rigida (come il PLA) per l'oggetto. L'oggetto ha un diametro di 140 mm. Se questo è troppo grande per la stampante, è possibile ridimensionarlo (ma assicurati di ridimensionare uniformemente entrambi gli assi X e Y). Se la stampante supporta stampe significativamente più grandi, è anche possibile aumentare le dimensioni di questo oggetto. Un formato più grande può migliorare la precisione della misurazione, ma una buona adesione di stampa è più importante di un formato di stampa più grande.

Stampa l'oggetto di prova e attendi che si raffreddi completamente. I comandi descritti di seguito devono essere eseguiti con le stesse impostazioni della stampante utilizzate per stampare l'oggetto di calibrazione (non eseguire DELTA_CALIBRATE tra la stampa e la misurazione, o fare qualcosa che altrimenti modificherebbe la configurazione della stampante).

Se possibile, esegui le misurazioni descritte di seguito mentre l'oggetto è ancora attaccato al piano di stampa, ma non preoccuparti se la parte si stacca dal letto: cerca solo di evitare di piegare l'oggetto durante l'esecuzione delle misurazioni.

Inizia misurando la distanza tra il pilastro centrale e il pilastro accanto all'etichetta "A" (che dovrebbe anche puntare verso la torre "A").

![delta-a-distance](img/delta-a-distance.jpg)

Quindi procedere in senso antiorario e misurare le distanze tra il pilastro centrale e gli altri pilastri (distanza dal centro al pilastro attraverso l'etichetta C, distanza dal centro al pilastro con l'etichetta B, ecc.).

![delta_cal_e_step1](img/delta_cal_e_step1.png)

Inserisci questi parametri in Klipper con un elenco separato da virgole di numeri in virgola mobile:

```
DELTA_ANALYZE CENTER_DISTS=<a_dist>,<far_c_dist>,<b_dist>,<far_a_dist>,<c_dist>,<far_b_dist>
```

Fornisci i valori senza spazi tra di loro.

Quindi misurare la distanza tra il montante A e il montante di fronte all'etichetta C.

![delta-ab-distance](img/delta-outer-distance.jpg)

Quindi andare in senso antiorario e misurare la distanza tra il pilastro di fronte a C e il pilastro B, la distanza tra il pilastro B e il pilastro di fronte a A, e così via.

![delta_cal_e_step2](img/delta_cal_e_step2.png)

Inserisci questi parametri in Klipper:

```
DELTA_ANALYZE OUTER_DISTS=<a_to_far_c>,<far_c_to_b>,<b_to_far_a>,<far_a_to_c>,<c_to_far_b>,<far_b_to_a>
```

A questo punto va bene rimuovere l'oggetto dal letto. Le misure finali sono dei pilastri stessi. Misurare la dimensione del pilastro centrale lungo il raggio A, poi il raggio B e poi il raggio C.

![delta-a-pillar](img/delta-a-pillar.jpg)

![delta_cal_e_step3](img/delta_cal_e_step3.png)

Inseriscili in Klipper:

```
DELTA_ANALYZE CENTER_PILLAR_WIDTHS=<a>,<b>,<c>
```

Le misure finali sono dei pilastri esterni. Inizia misurando la distanza del pilastro A lungo la linea da A al pilastro di fronte a C.

![delta-ab-pillar](img/delta-outer-pillar.jpg)

Quindi andare in senso antiorario e misurare i restanti pilastri esterni (pilastro di fronte a C lungo la linea a B, pilastro B lungo la linea a pilastro di fronte ad A, ecc.).

![delta_cal_e_step4](img/delta_cal_e_step4.png)

E inseriscili in Klipper:

```
DELTA_ANALYZE OUTER_PILLAR_WIDTHS=<a>,<far_c>,<b>,<far_a>,<c>,<far_b>
```

Se l'oggetto è stato ridimensionato a una dimensione inferiore o superiore, fornire il fattore di scala utilizzato durante il taglio dell'oggetto:

```
DELTA_ANALYZE SCALE=1.0
```

(Un valore di scala di 2,0 significherebbe che l'oggetto è il doppio della sua dimensione originale, 0,5 sarebbe la metà della sua dimensione originale.)

Infine, esegui la calibrazione delta avanzata eseguendo:

```
DELTA_ANALYZE CALIBRATE=extended
```

Il completamento di questo comando può richiedere diversi minuti. Dopo il completamento, calcolerà i parametri delta aggiornati (raggio delta, angoli della torre, posizioni dei finecorsa e lunghezze dei bracci). Utilizzare il comando SAVE_CONFIG per salvare e applicare le impostazioni:

```
SAVE_CONFIG
```

Il comando SAVE_CONFIG salverà sia i parametri delta aggiornati che le informazioni dalle misurazioni della distanza. Anche i futuri comandi DELTA_CALIBRATE utilizzeranno queste informazioni sulla distanza. Non tentare di reinserire le misurazioni grezze della distanza dopo aver eseguito SAVE_CONFIG, poiché questo comando modifica la configurazione della stampante e le misurazioni grezze non vengono più applicate.

### Note aggiuntive

* Se la stampante delta ha una buona precisione dimensionale, la distanza tra due pilastri qualsiasi dovrebbe essere di circa 74 mm e la larghezza di ogni pilastro dovrebbe essere di circa 9 mm. (In particolare, l'obiettivo è che la distanza tra due pilastri qualsiasi meno la larghezza di uno dei pilastri sia esattamente 65 mm.) In caso di imprecisione dimensionale nella parte, la routine DELTA_ANALYZE calcolerà nuovi parametri delta utilizzando entrambe le misurazioni della distanza e le misurazioni dell'altezza precedenti dall'ultimo comando DELTA_CALIBRATE.
* DELTA_ANALYZE può produrre parametri delta sorprendenti. Ad esempio, può suggerire lunghezze dei bracci che non corrispondono alle lunghezze effettive dei bracci della stampante. Nonostante ciò, i test hanno dimostrato che DELTA_ANALYZE produce spesso risultati superiori. Si ritiene che i parametri delta calcolati siano in grado di tenere conto di lievi errori in altre parti dell'hardware. Ad esempio, piccole differenze nella lunghezza del braccio possono comportare un'inclinazione dell'effettore e parte di tale inclinazione può essere spiegata regolando i parametri della lunghezza del braccio.

## Utilizzo della mesh del piatto su un delta

È possibile utilizzare [bed mesh](Bed_Mesh.md) su un delta. Tuttavia, è importante ottenere una buona calibrazione delta prima di abilitare una mesh del letto. L'esecuzione della mesh del letto con una scarsa calibrazione delta comporterà risultati confusi e scarsi.

Si noti che l'esecuzione della calibrazione delta invaliderà qualsiasi mesh del piatto precedentemente ottenuto. Dopo aver eseguito una nuova calibrazione delta, assicurati di eseguire nuovamente BED_MESH_CALIBRATE.
