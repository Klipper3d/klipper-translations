# Matrice del Piatto

Il modulo rete piatto (bed mesh) può essere usato per compensare le irregolarità della superficie del piatto e per ottenere un primo strato migliore su tutto il piatto. Va notato che la correzione basata sul software non raggiungerà risultati perfetti, può solo approssimare la forma del piatto. Bed mesh inoltre non può compensare i problemi meccanici ed elettrici. Se un asse è obliquo o una sonda non è accurata, il modulo Bed mesh non riceverà risultati accurati dal processo di ispezione.

Prima della calibrazione della mesh dovrai assicurarti che l'offset Z della tua sonda sia calibrato. Se si utilizza un fine corsa per l'homing Z, anche questo dovrà essere calibrato. Per ulteriori informazioni, vedere [Probe Calibrate](Probe_Calibrate.md) e Z_ENDSTOP_CALIBRATE in [Manual Level](Manual_Level.md).

## Configurazione base

### Piatti rettangolari

Questo esempio presuppone una stampante con un piatto rettangolare di 250 mm x 220 mm e una sonda con un offset x di 24 mm e un offset y di 5 mm.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `speed: 120` *Valore predefinito: 50* La velocità con cui la testa di stampa si sposta tra i punti.
- `horizontal_move_z: 5` *Valore predefinito: 5* La coordinata Z a cui si solleva la sonda prima di spostarsi tra i punti.
- `mesh_min: 35, 6` *Richiesto* La prima coordinata rilevata, più vicina all'origine. Questa coordinata è relativa alla posizione della sonda.
- `mesh_max: 240, 198` *Richiesto* La coordinata rilevata più lontana dall'origine. Questo non è necessariamente l'ultimo punto sondato, poiché il processo di rilevamento avviene a zig-zag. Come per `mesh_min`, questa coordinata è relativa alla posizione della sonda.
- `probe_count: 5, 3` *Valore predefinito: 3, 3* Il numero di punti da sondare su ciascun asse, specificato come valori interi X, Y. In questo esempio verranno tastati 5 punti lungo l'asse X, con 3 punti lungo l'asse Y, per un totale di 15 punti tastati. Nota che se desideri una griglia quadrata, ad esempio 3x3, questo potrebbe essere specificato come un singolo valore intero che viene utilizzato per entrambi gli assi, ad esempio `probe_count: 3`. Si noti che una mesh richiede un probe_count minimo di 3 lungo ciascun asse.

L'illustrazione seguente mostra come le opzioni `mesh_min`, `mesh_max` e `probe_count` vengono utilizzate per generare punti sonda. Le frecce indicano la direzione della procedura di probing, a partire da `mesh_min`. Per riferimento, quando la sonda è a `mesh_min`, l'ugello sarà a (11, 1), e quando la sonda è a `mesh_max`, l'ugello sarà a (206, 193).

![bedmesh_rect_basic](img/bedmesh_rect_basic.svg)

### Piatti rotondi

Questo esempio presuppone una stampante dotata di un raggio del piatto rotondo di 100 mm. Utilizzeremo gli stessi offset della sonda dell'esempio rettangolare, 24 mm su X e 5 mm su Y.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius: 75` *Obbligatorio* Il raggio della mesh sondata in mm, relativo a `mesh_origin`. Si noti che gli offset della sonda limitano la dimensione del raggio della mesh. In questo esempio, un raggio maggiore di 76 sposterebbe lo strumento oltre il range della stampante.
- `mesh_origin: 0, 0` *Valore predefinito: 0, 0* Il punto centrale della mesh. Questa coordinata è relativa alla posizione della sonda. Sebbene il valore predefinito sia 0, 0, può essere utile regolare l'origine nel tentativo di sondare una porzione più ampia del letto. Vedi l'illustrazione qui sotto.
- `round_probe_count: 5` *Valore predefinito: 5* Questo è un valore intero che definisce il numero massimo di punti sondati lungo gli assi X e Y. Per "massimo" si intende il numero di punti tastati lungo l'origine della mesh. Questo valore deve essere un numero dispari, in quanto è necessario che venga sondato il centro della mesh.

L'illustrazione seguente mostra come vengono generati i punti sondati. Come puoi vedere, l'impostazione di `mesh_origin` su (-10, 0) ci consente di specificare un raggio di mesh maggiore di 85.

![bedmesh_round_basic](img/bedmesh_round_basic.svg)

## Configurazione avanzata

Di seguito vengono spiegate in dettaglio le opzioni di configurazione più avanzate. Ciascun esempio si baserà sulla configurazione base del piatto rettangolare mostrata sopra. Ciascuna delle opzioni avanzate si applica allo stesso modo ai piatti rotondi.

### Interpolazione mesh

Sebbene sia possibile campionare la matrice sondata direttamente utilizzando una semplice interpolazione bilineare per determinare i valori Z tra i punti sondati, è spesso utile interpolare punti extra utilizzando algoritmi di interpolazione più avanzati per aumentare la densità della mesh. Questi algoritmi aggiungono curvatura alla mesh, tentando di simulare le proprietà del materiale del piatto. Bed Mesh offre l'interpolazione lagrange e bicubica per ottenere questo risultato.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
mesh_pps: 2, 3
algorithm: bicubic
bicubic_tension: 0.2
```

- `mesh_pps: 2, 3` *Valore predefinito: 2, 2* L'opzione `mesh_pps` è un'abbreviazione per Mesh Points Per Segment. Questa opzione specifica quanti punti interpolare per ciascun segmento lungo gli assi X e Y. Considera un "segmento" come lo spazio tra ogni punto sondato. Come `probe_count`, `mesh_pps` è specificato come una coppia di interi X, Y e può anche essere specificato un singolo intero che viene applicato a entrambi gli assi. In questo esempio ci sono 4 segmenti lungo l'asse X e 2 segmenti lungo l'asse Y. Questo restituisce 8 punti interpolati lungo X, 6 punti interpolati lungo Y, che si traduce in una mesh 13x8. Si noti che se mesh_pps è impostato su 0, l'interpolazione della mesh è disabilitata e la matrice sondata verrà campionata direttamente.
- `algoritmo: lagrange` *Valore predefinito: lagrange* L'algoritmo utilizzato per interpolare la mesh. Può essere "lagrange" o "bicubico". L'interpolazione Lagrange è limitata a 6 punti sondati poiché tende a verificarsi l'oscillazione con un numero maggiore di campioni. L'interpolazione bicubica richiede un minimo di 4 punti sondati lungo ciascun asse, se vengono specificati meno di 4 punti, viene forzato il campionamento lagrange. Se `mesh_pps` è impostato su 0, questo valore viene ignorato poiché non viene eseguita alcuna interpolazione della mesh.
- `bicubic_tension: 0.2` *Valore predefinito: 0.2* Se l'opzione `algorithm` è impostata su bicubic è possibile specificare il valore della tensione. Maggiore è la tensione, maggiore è la pendenza interpolata. Prestare attenzione durante la regolazione, poiché valori più elevati creano anche una maggiore sovraelongazione, che risulterà in valori interpolati superiori o inferiori rispetto ai punti rilevati.

L'illustrazione seguente mostra come vengono utilizzate le opzioni precedenti per generare una mesh interpolata.

![bedmesh_interpolated](img/bedmesh_interpolated.svg)

### Divisione dei movimenti

Bed Mesh funziona intercettando i comandi di spostamento di gcode e applicando una trasformazione alla loro coordinata Z. I movimenti lunghi devono essere suddivisi in movimenti più piccoli per seguire correttamente la forma del piatto. Le opzioni seguenti controllano il comportamento di divisione.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
move_check_distance: 5
split_delta_z: .025
```

- `move_check_distance: 5` *Valore predefinito: 5* La distanza minima per verificare la modifica desiderata in Z prima di eseguire una divisione. In questo esempio, un movimento più lungo di 5 mm verrà eseguito dall'algoritmo. Ogni 5 mm si verificherà una ricerca Z della mesh, confrontandola con il valore Z del movimento precedente. Se il delta raggiunge la soglia impostata da `split_delta_z`, il movimento sarà diviso e l'attraversamento continuerà. Questo processo si ripete fino al raggiungimento della fine del movimento, dove verrà applicato un aggiustamento finale. I movimenti più brevi di `move_check_distance` hanno la correzione Z corretta applicata direttamente alla mossa senza attraversamento o divisione.
- `split_delta_z: .025` *Valore predefinito: .025* Come accennato in precedenza, questa è la deviazione minima richiesta per attivare una divisione del movimento. In questo esempio, qualsiasi valore Z con una deviazione +/- 0,025 mm attiverà una divisione.

Generalmente i valori di default per queste opzioni sono sufficienti, infatti il valore di default di 5mm per il `move_check_distance` potrebbe essere eccessivo. Tuttavia, un utente esperto potrebbe voler sperimentare queste opzioni nel tentativo di spremere un primo layer ottimale.

### Dissolvenza Mesh

Quando la "dissolvenza" è abilitata, la regolazione Z viene gradualmente eliminata su una distanza definita dalla configurazione. Ciò si ottiene applicando piccole regolazioni all'altezza dello strato, aumentando o diminuendo a seconda della forma del letto. Quando la dissolvenza è completata, la regolazione Z non viene più applicata, consentendo alla parte superiore della stampa di essere piatta anziché rispecchiare la forma del letto. La dissolvenza può anche avere alcuni tratti indesiderati, se dissolve troppo rapidamente può causare artefatti visibili sulla stampa. Inoltre, se il tuo letto è notevolmente deformato, la dissolvenza può ridurre o allungare l'altezza Z della stampa. In quanto tale, la dissolvenza è disabilitata per impostazione predefinita.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
fade_start: 1
fade_end: 10
fade_target: 0
```

- `fade_start: 1` *Valore predefinito: 1* L'altezza Z in cui iniziare la regolazione graduale. È una buona idea avere alcuni layer prima di iniziare il processo di dissolvenza.
- `fade_end: 10` *Valore predefinito: 0* L'altezza Z in cui deve essere completata la dissolvenza. Se questo valore è inferiore a `fade_start`, la dissolvenza è disabilitata. Questo valore può essere regolato a seconda di quanto è deformata la superficie di stampa. Una superficie notevolmente deformata dovrebbe dissolvere su una distanza maggiore. Una superficie quasi piatta potrebbe essere in grado di ridurre questo valore per eliminarlo gradualmente più rapidamente. 10mm è un valore ragionevole per cominciare se si utilizza il valore predefinito di 1 per `fade_start`.
- `fade_target: 0` *Valore predefinito: il valore Z medio della mesh* Il `fade_target` può essere pensato come un offset Z aggiuntivo applicato all'intero letto dopo il completamento della dissolvenza. In generale, vorremmo che questo valore fosse 0, tuttavia ci sono circostanze in cui non dovrebbe essere. Ad esempio, supponiamo che la tua posizione di riferimento sul letto sia un valore anomalo, 0,2 mm inferiore all'altezza media rilevata del letto. Se `fade_target` è 0, la dissolvenza ridurrà la stampa di una media di 0,2 mm sul letto. Impostando `fade_target` su .2, l'area homed si espanderà di .2 mm, tuttavia il resto del letto avrà una dimensione precisa. Generalmente è una buona idea lasciare `fade_target` fuori dalla configurazione in modo che venga utilizzata l'altezza media della mesh, tuttavia potrebbe essere desiderabile regolare manualmente il target di dissolvenza se si desidera stampare su una parte specifica del letto.

### L'Indice di Riferimento Relativo

La maggior parte delle sonde è suscettibile alla deriva, cioè: imprecisioni nel sondaggio introdotte da calore o interferenza. Ciò può rendere difficile il calcolo dell'offset z della sonda, in particolare a diverse temperature del letto. In quanto tali, alcune stampanti utilizzano un fine corsa per l'homing dell'asse Z e una sonda per calibrare la mesh. Queste stampanti possono trarre vantaggio dalla configurazione del relativo indice di riferimento.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
relative_reference_index: 7
```

- `relative_reference_index: 7` *Valore predefinito: Nessuno (disabilitato)* Quando i punti sondati vengono generati, a ciascuno viene assegnato un indice. Puoi cercare questo indice in klippy.log o usando BED_MESH_OUTPUT (vedi la sezione sui GCodes Bed Mesh di seguito per maggiori informazioni). Se si assegna un indice all'opzione `relative_reference_index`, il valore rilevato a questa coordinata sostituirà lo z_offset del probe. Questo rende effettivamente questa coordinata il riferimento "zero" per la mesh.

Quando si utilizza l'indice di riferimento relativo, è necessario scegliere l'indice più vicino al punto sul letto in cui è stata eseguita la calibrazione del fine corsa Z. Nota che quando cerchi l'indice usando il log o BED_MESH_OUTPUT, dovresti usare le coordinate elencate sotto l'intestazione "Probe" per trovare l'indice corretto.

### Regioni difettose

È possibile che alcune aree di un piatto riportino risultati imprecisi durante il sondaggio a causa di un "guasto" in punti specifici. Il miglior esempio di ciò sono i piatti con serie di magneti integrati utilizzati per trattenere le lamiere di acciaio rimovibili. Il campo magnetico su e intorno a questi magneti può causare l'attivazione di una sonda induttiva a una distanza maggiore o minore di quanto sarebbe altrimenti, risultando in una mesh che non rappresenta accuratamente la superficie in queste posizioni. **Nota: questo non deve essere confuso con la distorsione della posizione della sonda, che produce risultati imprecisi sull'intero letto.**

Le opzioni `faulty_region` possono essere configurate per compensare questo effetto. Se un punto generato si trova all'interno di una regione difettosa, la mesh del letto tenterà di sondare fino a 4 punti ai confini di questa regione. Questi valori sondati verranno mediati e inseriti nella mesh come valore Z alla coordinata generata (X, Y).

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
faulty_region_1_min: 130.0, 0.0
faulty_region_1_max: 145.0, 40.0
faulty_region_2_min: 225.0, 0.0
faulty_region_2_max: 250.0, 25.0
faulty_region_3_min: 165.0, 95.0
faulty_region_3_max: 205.0, 110.0
faulty_region_4_min: 30.0, 170.0
faulty_region_4_max: 45.0, 210.0
```

- `faulty_region_{1...99}_min` `faulty_region_{1..99}_max` *Valore predefinito: Nessuno (disabilitato)* Le regioni difettose sono definite in modo simile a quello della mesh stessa, dove minimo e massimo (X , Y) delle coordinate devono essere specificate per ciascuna regione. Una regione difettosa può estendersi al di fuori di una mesh, tuttavia i punti alternativi generati saranno sempre all'interno del confine della mesh. Non possono sovrapporsi due regioni.

L'immagine seguente illustra come vengono generati i punti di sostituzione quando un punto generato si trova all'interno di una regione difettosa. Le regioni mostrate corrispondono a quelle nella configurazione di esempio sopra. I punti di sostituzione e le relative coordinate sono identificati in verde.

![bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

## GCodes della mesh del piatto

### Calibrazione

`BED_MESH_CALIBRATE PROFILE=<nome> METHOD=[manuale | automatico] [<parametro_sonda>=<valore>] [<mesh_parameter>=<valore>]` *Profilo predefinito: default* *Metodo predefinito: automatico se viene rilevata una sonda, altrimenti manuale*

Avvia la procedura di sondaggio per la calibrazione della mesh del piatto.

La mesh verrà salvata in un profilo specificato dal parametro `PROFILE`, o `default` se non specificato. Se viene selezionato `METHOD=manual`, si verificherà il rilevamento manuale. Quando si passa dal probing automatico a quello manuale, i punti mesh generati verranno regolati automaticamente.

È possibile specificare parametri mesh per modificare l'area sondata. Sono disponibili i seguenti parametri:

- Piatti rettangolari (cartesiani):
   - `MESH_MIN`
   - `MESH_MAX`
   - `PROBE_COUNT`
- Piatti rotondi (delta):
   - `MESH_RADIUS`
   - `MESH_ORIGIN`
   - `ROUND_PROBE_COUNT`
- Tutti i piatti:
   - `RELATIVE_REFERNCE_INDEX`
   - `ALGORITHM`

Vedere la documentazione di configurazione sopra per i dettagli su come ogni parametro si applica alla mesh.

### Profili

`BED_MESH_PROFILE SAVE=<name> LOAD=<name> REMOVE=<name>`

Dopo aver eseguito un BED_MESH_CALIBRATE, è possibile salvare lo stato della mesh corrente in un profilo denominato. Ciò consente di caricare una mesh senza risondare il piatto. Dopo che un profilo è stato salvato usando `BED_MESH_PROFILE SAVE=<nome>` è possibile eseguire il gcode `SAVE_CONFIG` per scrivere il profilo su printer.cfg.

I profili possono essere caricati eseguendo `BED_MESH_PROFILE LOAD=<name>`.

Va notato che ogni volta che si verifica un BED_MESH_CALIBRATE, lo stato corrente viene automaticamente salvato nel profilo *predefinito*. Se questo profilo esiste, viene caricato automaticamente all'avvio di Klipper. Se questo comportamento non è desiderabile, il profilo *predefinito* può essere rimosso come segue:

`BED_MESH_PROFILE REMOVE=default`

Qualsiasi altro profilo salvato può essere rimosso allo stesso modo, sostituendo *default* con il nome del profilo che desideri rimuovere.

#### Caricamento del profilo predefinito

Le versioni precedenti di `bed_mesh` caricavano sempre il profilo denominato *default* all'avvio se era presente. Questo comportamento è stato rimosso per consentire all'utente di determinare quando viene caricato un profilo. Se un utente desidera caricare il profilo `predefinito`, si consiglia di aggiungere `BED_MESH_PROFILE LOAD=default` alla macro `START_PRINT` o alla configurazione "Start G-Code" del proprio slicer, a seconda di quale sia applicabile.

In alternativa, il vecchio comportamento di caricamento di un profilo all'avvio può essere ripristinato con un `[delayed_gcode]`:

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### Output

`BED_MESH_OUTPUT PGP=[0 | 1]`

Invia lo stato della mesh corrente al terminale. Si noti che viene emessa la mesh stessa

Il parametro PGP è un'abbreviazione per "Print Generated Points". Se è impostato `PGP=1`, i punti sondati generati verranno inviati al terminale:

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (11.0, 1.0) | (35.0, 6.0)
// 1 | (62.2, 1.0) | (86.2, 6.0)
// 2 | (113.5, 1.0) | (137.5, 6.0)
// 3 | (164.8, 1.0) | (188.8, 6.0)
// 4 | (216.0, 1.0) | (240.0, 6.0)
// 5 | (216.0, 97.0) | (240.0, 102.0)
// 6 | (164.8, 97.0) | (188.8, 102.0)
// 7 | (113.5, 97.0) | (137.5, 102.0)
// 8 | (62.2, 97.0) | (86.2, 102.0)
// 9 | (11.0, 97.0) | (35.0, 102.0)
// 10 | (11.0, 193.0) | (35.0, 198.0)
// 11 | (62.2, 193.0) | (86.2, 198.0)
// 12 | (113.5, 193.0) | (137.5, 198.0)
// 13 | (164.8, 193.0) | (188.8, 198.0)
// 14 | (216.0, 193.0) | (240.0, 198.0)
```

I punti "Tool Adjusted" si riferiscono alla posizione dell'ugello per ciascun punto e i punti "Probe" si riferiscono alla posizione della sonda. Si noti che quando il probing è manuale i punti "sonda" si riferiscono sia alla posizione dell'utensile che dell'ugello.

### Cancella stato mesh

`BED_MESH_CLEAR`

Questo gcode può essere utilizzato per cancellare lo stato della mesh interna.

### Applicare gli offset X/Y

`BED_MESH_OFFSET [X=<value>] [Y=<value>]`

Ciò è utile per le stampanti con più estrusori indipendenti, poiché è necessario un offset per produrre la corretta regolazione Z dopo un cambio utensile. Gli offset devono essere specificati rispetto all'estrusore primario. Vale a dire, è necessario specificare un offset X positivo se l'estrusore secondario è montato a destra dell'estrusore primario e un offset Y positivo se l'estrusore secondario è montato "dietro" l'estrusore primario.
