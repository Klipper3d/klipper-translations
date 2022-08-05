# Calibrazione sonda

Questo documento descrive il metodo per calibrare gli offset X, Y e Z di una "sonda z automatica" in Klipper. Questo è utile per gli utenti che hanno una sezione `[probe]` o `[bltouch]` nel loro file di configurazione.

## Calibrazione degli offset X e Y della sonda

Per calibrare l'offset X e Y, vai alla scheda "Controllo" di OctoPrint, avvia la stampante, quindi usa i pulsanti di spostamento di OctoPrint per spostare la testa in una posizione vicino al centro del piatto.

Metti un pezzo di nastro adesivo blu (o simile) sul piatto sotto la sonda. Passare alla scheda "Terminale" di OctoPrint ed emettere un comando PROBE:

```
PROBE
```

Metti un segno sul nastro direttamente sotto il punto in cui si trova la sonda (o usa un metodo simile per annotare la posizione sul letto).

Emettere un comando `GET_POSITION` e registrare la posizione XY della testa riportata da quel comando. Ad esempio se si vede:

```
Recv: // toolhead: X:46.500000 Y:27.000000 Z:15.000000 E:0.000000
```

quindi si registrerebbe una posizione X della sonda di 46,5 e una posizione Y della sonda di 27.

Dopo aver registrato la posizione della sonda, emettere una serie di comandi G1 fino a quando l'ugello si trova direttamente sopra il segno sul letto. Ad esempio, si potrebbe emettere:

```
G1 F300 X57 Y30 Z15
```

per spostare l'ugello in una posizione X di 57 e Y di 30. Una volta trovata la posizione direttamente sopra il segno, utilizzare il comando `GET_POSITION` per segnalare quella posizione. Questa è la posizione dell'ugello.

L'offset_x è quindi `posizione_x_ugello - posizione_x_sonda` e l'offset_y è analogamente a `posizione_y_ugello - posizione_y_sonda`. Aggiorna il file printer.cfg con i valori indicati, rimuovi il nastro con i riferimento dal piatto, quindi esegui un comando `RESTART` in modo che i nuovi valori diventino effettivi.

## Calibrazione Z offset sonda

Inserire una z_offset accurata per la sonda è fondamentale per ottenere stampe di alta qualità. Lo z_offset è la distanza tra l'ugello e il letto quando la sonda si attiva. Lo strumento Klipper `PROBE_CALIBRATE` può essere utilizzato per ottenere questo valore: eseguirà una sonda automatica per misurare la posizione di trigger Z della sonda e quindi avvierà una sonda manuale per ottenere l'altezza Z dell'ugello. La sonda z_offset verrà quindi calcolata da queste misurazioni.

Inizia spostando testa in una posizione vicino al centro del piatto. Passare alla scheda del terminale OctoPrint ed eseguire il comando `PROBE_CALIBRATE` per avviare lo strumento.

Questo strumento eseguirà una misura automatica con la sonda, quindi solleverà la testina, sposterà l'ugello sulla posizione del punto sonda e avvierà lo strumento sonda manuale. Se l'ugello non si sposta in una posizione al di sopra del punto della sonda automatica, allora `ANNULLA` lo strumento sonda manuale ed eseguire la calibrazione dell'offset della sonda XY descritta sopra.

Una volta avviata manualmente la sonda, seguire i passaggi descritti in ["the paper test"](Bed_Level.md#the-paper-test) per determinare la distanza effettiva tra l'ugello e il letto in una determinata posizione. Una volta completati questi passaggi, è possibile `ACCEPT` la posizione e salvare i risultati nel file di configurazione con:

```
SAVE_CONFIG
```

Si noti che se viene apportata una modifica al sistema di movimento della stampante, alla posizione dell'hotend o alla posizione della sonda, i risultati di PROBE_CALIBRATE verranno invalidati.

Se la sonda ha un offset X o Y e l'inclinazione del letto viene modificata (ad es. regolando le viti del letto, eseguendo DELTA_CALIBRATE, eseguendo Z_TILT_ADJUST, eseguendo QUAD_GANTRY_LEVEL o simili), i risultati di PROBE_CALIBRATE verranno invalidati. Dopo aver apportato una qualsiasi delle modifiche di cui sopra, sarà necessario eseguire nuovamente PROBE_CALIBRATE.

Se i risultati di PROBE_CALIBRATE vengono invalidati, anche tutti i risultati precedenti di [bed mesh](Bed_Mesh.md) ottenuti utilizzando la sonda vengono invalidati: sarà necessario eseguire nuovamente BED_MESH_CALIBRATE dopo aver ricalibrato la sonda.

## Verifica di ripetibilità

Dopo aver calibrato gli offset X, Y e Z della sonda, è una buona idea verificare che la sonda fornisca risultati ripetibili. Inizia portando a home la stampante e quindi sposta la testa in una posizione vicino al centro del letto. Passare al terminale di OctoPrint ed eseguire il comando `PROBE_ACCURACY`.

Questo comando eseguirà il test con la sonda dieci volte e produrrà un output simile al seguente:

```
Recv: // probe accuracy: at X:0.000 Y:0.000 Z:10.000
Recv: // and read 10 times with speed of 5 mm/s
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe accuracy results: maximum 2.519448, minimum 2.506948, range 0.012500, average 2.513198, median 2.513198, standard deviation 0.006250
```

Idealmente lo strumento riporterà un valore massimo e minimo identico. (Ovvero, idealmente la sonda ottiene un risultato identico su tutte e dieci le prove.) Tuttavia, è normale che i valori minimo e massimo differiscano di una "distanza di passo" Z o fino a 5 micron (0,005 mm). Una "distanza passo" è `rotation_distance/(full_steps_per_rotation*microsteps)`. La distanza tra il valore minimo e quello massimo è chiamata intervallo. Quindi, nell'esempio precedente, poiché la stampante utilizza una distanza di passo Z di 0,0125, un intervallo di 0,012500 sarebbe considerato normale.

Se i risultati del test mostrano un valore di intervallo maggiore di 25 micron (0,025 mm), la sonda non ha una precisione sufficiente per le procedure tipiche di livellamento del piatto. Potrebbe essere possibile regolare la velocità della sonda e/o l'altezza di inizio della sonda per migliorare la ripetibilità della sonda. Il comando `PROBE_ACCURACY` consente di eseguire test con parametri diversi per vederne l'impatto - vedere il [documento G-Codes](G-Codes.md#probe_accuracy) per ulteriori dettagli. Se la sonda generalmente ottiene risultati ripetibili ma presenta un valore anomalo occasionale, potrebbe essere possibile tenerne conto utilizzando più campioni su ciascuna sonda - leggere la descrizione dei parametri di configurazione dei `campioni` della sonda in [riferimento di configurazione](Config_Reference. md#probe) per maggiori dettagli.

Se sono necessarie una nuova velocità della sonda, diversa quantità di campioni o altre impostazioni, aggiornare il file printer.cfg ed eseguire un comando `RESTART`. In tal caso, è una buona idea anche [calibrare z_offset](#calibrating-probe-z-offset) di nuovo. Se non è possibile ottenere risultati ripetibili, non utilizzare la sonda per livellare il letto. Klipper ha diversi strumenti manuali che possono essere utilizzati in alternativa: vedere il [Bed Level document](Bed_Level.md) per ulteriori dettagli.

## Verifica scostamenti di posizione

Alcune sonde possono avere una distorsione sistematica che altera i risultati della sonda in determinate posizioni della testa. Ad esempio, se il supporto della sonda si inclina leggermente durante lo spostamento lungo l'asse Y, la sonda potrebbe riportare risultati distorti in differenti posizioni Y.

Questo è un problema comune con le sonde sulle stampanti delta, tuttavia può verificarsi su tutte le stampanti.

Si può verificare una distorsione di posizione utilizzando il comando `PROBE_CALIBRATE` per misurare l'offset z della sonda in varie posizioni X e Y. Idealmente, il probe z_offset sarebbe un valore costante in ogni posizione della stampante.

Per le stampanti delta, prova a misurare z_offset in una posizione vicino alla torre A, in una posizione vicino alla torre B e in una posizione vicino alla torre C. Per stampanti cartesiane, corexy e simili, prova a misurare z_offset in posizioni vicino ai quattro angoli del letto.

Prima di iniziare questo test, calibrare prima gli offset della sonda X, Y e Z come descritto all'inizio di questo documento. Quindi porta a home la stampante e vai alla prima posizione XY. Seguire i passaggi in [calibrazione dell'offset Z della sonda](#calibrating-probe-z-offset) per eseguire il comando `PROBE_CALIBRATE`, i comandi `TESTZ` e il comando `ACCETTA`, ma non eseguire `SAVE_CONFIG`. Nota lo z_offset segnalato trovato. Quindi passare alle altre posizioni XY, ripetere questi passaggi `PROBE_CALIBRATE` e annotare lo z_offset riportato.

Se la differenza tra l'offset z minimo riportato e l'offset z massimo riportato è maggiore di 25 micron (0,025 mm), la sonda non è adatta per le tipiche procedure di livellamento del letto. Consultare il [Bed Level document](Bed_Level.md) per sonde alternative manuali.

## Scostamenti per temperatura

Molte sonde hanno una distorsione sistemica quando misurano a temperature diverse. Ad esempio, la sonda può attivarsi costantemente a un'altezza inferiore quando la sonda si trova a una temperatura più elevata.

Si consiglia di eseguire le procedure di livellamento del piatto a una temperatura costante per tenere conto di questa distorsione. Ad esempio, usare sempre la sonda quando la stampante è a temperatura ambiente oppure eseguire sempre la procedura dopo che la stampante ha raggiunto una temperatura costante. In entrambi i casi, è una buona idea attendere diversi minuti dopo che è stata raggiunta la temperatura desiderata, in modo che tutto apparato stampante sia alla temperatura desiderata costantemente.

Per verificare la presenza di un errore per temperatura, iniziare con la stampante a temperatura ambiente e poi portare a home la stampante, spostare la testina in una posizione vicino al centro del letto ed eseguire il comando `PROBE_ACCURACY`. Nota i risultati. Quindi, senza eseguire l'homing o disabilitare i motori passo-passo, riscaldare l'ugello della stampante e il piatto alla temperatura di stampa ed eseguire nuovamente il comando `PROBE_ACCURACY`. Idealmente, il comando riporterà risultati identici. Come sopra, se la sonda ha un errore causato dalla temperatura, fare attenzione a usare sempre la sonda a una temperatura costante stabile.
