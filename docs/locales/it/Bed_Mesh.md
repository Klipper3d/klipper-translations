# Matrice del Piatto

Il modulo Bed Mesh può essere utilizzato per compensare le irregolarità della superficie del piatto per ottenere un primo strato migliore sull'intero piatto. Va notato che la correzione basata sul software non otterrà risultati perfetti, potrà solo approssimare la forma del piatto. Inoltre, Bed Mesh non può compensare problemi meccanici ed elettrici. Se un asse è inclinato o una sonda non è precisa, il modulo bed_mesh non riceverà risultati accurati dal processo di tastatura.

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
- `mesh_max: 240, 198` *Required* The probed coordinate farthest from the origin. This is not necessarily the last point probed, as the probing process occurs in a zig-zag fashion. As with `mesh_min`, this coordinate is relative to the probe's location.
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

L'illustrazione seguente mostra come vengono generati i punti rilevati. Come puoi vedere, impostando `mesh_origin` su (-10, 0) ci consente di specificare un raggio di mesh maggiore di 85.

![bedmesh_round_basic](img/bedmesh_round_basic.svg)

## Configurazione avanzata

Di seguito vengono spiegate in dettaglio le opzioni di configurazione più avanzate. Ciascun esempio si baserà sulla configurazione base del piatto rettangolare mostrata sopra. Ciascuna delle opzioni avanzate si applica allo stesso modo ai piatti rotondi.

### Interpolazione mesh

Sebbene sia possibile campionare direttamente la matrice rilevata utilizzando una semplice interpolazione bilineare per determinare i valori Z tra i punti rilevati, è spesso utile interpolare punti aggiuntivi utilizzando algoritmi di interpolazione più avanzati per aumentare la densità della mesh. Questi algoritmi aggiungono curvatura alla mesh, tentando di simulare le proprietà del materiale del letto. Bed Mesh offre interpolazione lagrange e bicubica per raggiungere questo obiettivo.

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

Generalmente i valori predefiniti per queste opzioni sono sufficienti, infatti il valore predefinito di 5 mm per `move_check_distance` potrebbe essere eccessivo. Tuttavia un utente esperto potrebbe voler sperimentare queste opzioni nel tentativo di ottenere il primo livello ottimale.

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
- `fade_target: 0` *Valore predefinito: il valore Z medio della mesh* Il `fade_target` può essere considerato come un offset Z aggiuntivo applicato all'intero piatto una volta completata la dissolvenza. In generale vorremmo che questo valore fosse 0, tuttavia ci sono circostanze in cui non dovrebbe esserlo. Ad esempio, supponiamo che la posizione di homing sul piatto sia un valore anomalo, ovvero 0,2 mm inferiore all'altezza media rilevata del piatto. Se `fade_target` è 0, la dissolvenza ridurrà la stampa in media di 0,2 mm sul piano. Impostando `fade_target` su .2, l'area home si espanderà di 0,2 mm, tuttavia, il resto del piatto verrà dimensionato accuratamente. Generalmente è una buona idea lasciare "fade_target" fuori dalla configurazione in modo da utilizzare l'altezza media della mesh, tuttavia potrebbe essere preferibile regolare manualmente il target di dissolvenza se si desidera stampare su una porzione specifica del piano.

### Configuring the zero reference position

Many probes are susceptible to "drift", ie: inaccuracies in probing introduced by heat or interference. This can make calculating the probe's z-offset challenging, particularly at different bed temperatures. As such, some printers use an endstop for homing the Z axis and a probe for calibrating the mesh. In this configuration it is possible offset the mesh so that the (X, Y) `reference position` applies zero adjustment. The `reference postion` should be the location on the bed where a [Z_ENDSTOP_CALIBRATE](./Manual_Level.md#calibrating-a-z-endstop) paper test is performed. The bed_mesh module provides the `zero_reference_position` option for specifying this coordinate:

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
zero_reference_position: 125, 110
probe_count: 5, 3
```

- `zero_reference_position: ` *Default Value: None (disabled)* The `zero_reference_position` expects an (X, Y) coordinate matching that of the `reference position` described above. If the coordinate lies within the mesh then the mesh will be offset so the reference position applies zero adjustment. If the coordinate lies outside of the mesh then the coordinate will be probed after calibration, with the resulting z-value used as the z-offset. Note that this coordinate must NOT be in a location specified as a `faulty_region` if a probe is necessary.

#### The deprecated relative_reference_index

Existing configurations using the `relative_reference_index` option must be updated to use the `zero_reference_position`. The response to the [BED_MESH_OUTPUT PGP=1](#output) gcode command will include the (X, Y) coordinate associated with the index; this position may be used as the value for the `zero_reference_position`. The output will look similar to the following:

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (1.0, 1.0) | (24.0, 6.0)
// 1 | (36.7, 1.0) | (59.7, 6.0)
// 2 | (72.3, 1.0) | (95.3, 6.0)
// 3 | (108.0, 1.0) | (131.0, 6.0)
... (additional generated points)
// bed_mesh: relative_reference_index 24 is (131.5, 108.0)
```

*Note: The above output is also printed in `klippy.log` during initialization.*

Using the example above we see that the `relative_reference_index` is printed along with its coordinate. Thus the `zero_reference_position` is `131.5, 108`.

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

### Adaptive Meshes

Adaptive bed meshing is a way to speed up the bed mesh generation by only probing the area of the bed used by the objects being printed. When used, the method will automatically adjust the mesh parameters based on the area occupied by the defined print objects.

The adapted mesh area will be computed from the area defined by the boundaries of all the defined print objects so it covers every object, including any margins defined in the configuration. After the area is computed, the number of probe points will be scaled down based on the ratio of the default mesh area and the adapted mesh area. To illustrate this consider the following example:

For a 150mmx150mm bed with `mesh_min` set to `25,25` and `mesh_max` set to `125,125`, the default mesh area is a 100mmx100mm square. An adapted mesh area of `50,50` means a ratio of `0.5x0.5` between the adapted area and default mesh area.

If the `bed_mesh` configuration specified `probe_count` as `7x7`, the adapted bed mesh will use 4x4 probe points (7 * 0.5 rounded up).

![adaptive_bedmesh](img/adaptive_bed_mesh.svg)

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
adaptive_margin: 5
```

- `adaptive_margin`  *Default Value: 0*  Margin (in mm) to add around the area of the bed used by the defined objects. The diagram below shows the adapted bed mesh area with an `adaptive_margin` of 5mm. The adapted mesh area (area in green) is computed as the used bed area (area in blue) plus the defined margin.

   ![adaptive_bedmesh_margin](img/adaptive_bed_mesh_margin.svg)

By nature, adaptive bed meshes use the objects defined by the Gcode file being printed. Therefore, it is expected that each Gcode file will generate a mesh that probes a different area of the print bed. Therefore, adapted bed meshes should not be re-used. The expectation is that a new mesh will be generated for each print if adaptive meshing is used.

It is also important to consider that adaptive bed meshing is best used on machines that can normally probe the entire bed and achieve a maximum variance less than or equal to 1 layer height. Machines with mechanical issues that a full bed mesh normally compensates for may have undesirable results when attempting print moves **outside** of the probed area. If a full bed mesh has a variance greater than 1 layer height, caution must be taken when using adaptive bed meshes and attempting print moves outside of the meshed area.

## Surface Scans

Some probes, such as the [Eddy Current Probe](./Eddy_Probe.md), are capable of "scanning" the surface of the bed. That is, these probes can sample a mesh without lifting the tool between samples. To activate scanning mode, the `METHOD=scan` or `METHOD=rapid_scan` probe parameter should be passed in the `BED_MESH_CALIBRATE` gcode command.

### Scan Height

The scan height is set by the `horizontal_move_z` option in `[bed_mesh]`. In addition it can be supplied with the `BED_MESH_CALIBRATE` gcode command via the `HORIZONTAL_MOVE_Z` parameter.

The scan height must be sufficiently low to avoid scanning errors. Typically a height of 2mm (ie: `HORIZONTAL_MOVE_Z=2`) should work well, presuming that the probe is mounted correctly.

It should be noted that if the probe is more than 4mm above the surface then the results will be invalid. Thus, scanning is not possible on beds with severe surface deviation or beds with extreme tilt that hasn't been corrected.

### Rapid (Continuous) Scanning

When performing a `rapid_scan` one should keep in mind that the results will have some amount of error. This error should be low enough to be useful on large print areas with reasonably thick layer heights. Some probes may be more prone to error than others.

It is not recommended that rapid mode be used to scan a "dense" mesh. Some of the error introduced during a rapid scan may be gaussian noise from the sensor, and a dense mesh will reflect this noise (ie: there will be peaks and valleys).

Bed Mesh will attempt to optimize the travel path to provide the best possible result based on the configuration. This includes avoiding faulty regions when collecting samples and "overshooting" the mesh when changing direction. This overshoot improves sampling at the edges of a mesh, however it requires that the mesh be configured in a way that allows the tool to travel outside of the mesh.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5
scan_overshoot: 8
```

- `scan_overshoot` *Default Value: 0 (disabled)* The maximum amount of travel (in mm) available outside of the mesh. For rectangular beds this applies to travel on the X axis, and for round beds it applies to the entire radius. The tool must be able to travel the amount specified outside of the mesh. This value is used to optimize the travel path when performing a "rapid scan". The minimum value that may be specified is 1. The default is no overshoot.

If no scan overshoot is configured then travel path optimization will not be applied to changes in direction.

## GCodes della mesh del piatto

### Calibrazione

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic | scan | rapid_scan] \ [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] \ [ADAPTIVE_MARGIN=<value>]` *Default Profile: default* *Default Method: automatic if a probe is detected, otherwise manual*  *Default Adaptive: 0*  *Default Adaptive Margin: 0*

Avvia la procedura di sondaggio per la calibrazione della mesh del piatto.

The mesh will be immediately ready to use when the command completes and saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. The `METHOD` parameter takes one of the following values:

- `METHOD=manual`: enables manual probing using the nozzle and the paper test
- `METHOD=automatic`: Automatic (standard) probing. This is the default.
- `METHOD=scan`: Enables surface scanning. The tool will pause over each position to collect a sample.
- `METHOD=rapid_scan`: Enables continuous surface scanning.

XY positions are automatically adjusted to include the X and/or Y offsets when a probing method other than `manual` is selected.

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
   - `MESH_PPS`
   - `ALGORITHM`
   - `ADAPTIVE`
   - `ADAPTIVE_MARGIN`

Vedere la documentazione di configurazione sopra per i dettagli su come ogni parametro si applica alla mesh.

### Profili

`BED_MESH_PROFILE SAVE=<name> LOAD=<name> REMOVE=<name>`

Dopo aver eseguito un BED_MESH_CALIBRATE, è possibile salvare lo stato della mesh corrente in un profilo denominato. Ciò consente di caricare una mesh senza risondare il piatto. Dopo che un profilo è stato salvato usando `BED_MESH_PROFILE SAVE=<nome>` è possibile eseguire il gcode `SAVE_CONFIG` per scrivere il profilo su printer.cfg.

I profili possono essere caricati eseguendo `BED_MESH_PROFILE LOAD=<name>`.

Va notato che ogni volta che si verifica un BED_MESH_CALIBRATE, lo stato corrente viene automaticamente salvato nel profilo *predefinito*. Il profilo *predefinito* può essere rimosso come segue:

`BED_MESH_PROFILE REMOVE=default`

Qualsiasi altro profilo salvato può essere rimosso allo stesso modo, sostituendo *default* con il nome del profilo che desideri rimuovere.

#### Caricamento del profilo predefinito

Le versioni precedenti di `bed_mesh` caricavano sempre il profilo denominato *default* all'avvio se era presente. Questo comportamento è stato rimosso per consentire all'utente di determinare quando viene caricato un profilo. Se un utente desidera caricare il profilo `predefinito`, si consiglia di aggiungere `BED_MESH_PROFILE LOAD=default` alla macro `START_PRINT` o alla configurazione "Start G-Code" del proprio slicer, a seconda di quale sia applicabile.

Note that this is not required if a new mesh is generated with `BED_MESH_CALIBRATE` in the `START_PRINT` macro or the slicer's "Start G-Code" and may produce unexpected results, especially with adaptive meshing.

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

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value>]`

This is useful for printers with multiple independent extruders, as an offset is necessary to produce correct Z adjustment after a tool change. Offsets should be specified relative to the primary extruder. That is, a positive X offset should be specified if the secondary extruder is mounted to the right of the primary extruder, a positive Y offset should be specified if the secondary extruder is mounted "behind" the primary extruder, and a positive ZFADE offset should be specified if the secondary extruder's nozzle is above the primary extruder's.

Note that a ZFADE offset does *NOT* directly apply additional adjustment. It is intended to compensate for a `gcode offset` when [mesh fade](#mesh-fade) is enabled. For example, if a secondary extruder is higher than the primary and needs a negative gcode offset, ie: `SET_GCODE_OFFSET Z=-.2`, it can be accounted for in `bed_mesh` with `BED_MESH_OFFSET ZFADE=.2`.

## Bed Mesh Webhooks APIs

### Dumping mesh data

`{"id": 123, "method": "bed_mesh/dump_mesh"}`

Dumps the configuration and state for the current mesh and all saved profiles.

The `dump_mesh` endpoint takes one optional parameter, `mesh_args`. This parameter must be an object, where the keys and values are parameters available to [BED_MESH_CALIBRATE](#bed_mesh_calibrate). This will update the mesh configuration and probe points using the supplied parameters prior to returning the result. It is recommended to omit mesh parameters unless it is desired to visualize the probe points and/or travel path before performing `BED_MESH_CALIBRATE`.

## Visualization and analysis

Most users will likely find that the visualizers included with applications such as Mainsail, Fluidd, and Octoprint are sufficient for basic analysis. However, Klipper's `scripts` folder contains the `graph_mesh.py` script that may be used to perform additional visualizations and more detailed analysis, particularly useful for debugging hardware or the results produced by `bed_mesh`:

```
usage: graph_mesh.py [-h] {list,plot,analyze,dump} ...

Graph Bed Mesh Data

positional arguments:
  {list,plot,analyze,dump}
    list                List available plot types
    plot                Plot a specified type
    analyze             Perform analysis on mesh data
    dump                Dump API response to json file

options:
  -h, --help            show this help message and exit
```

### Pre-requisites

Like most graphing tools provided by Klipper, `graph_mesh.py` requires the `matplotlib` and `numpy` python dependencies. In addition, connecting to Klipper via Moonraker's websocket requires the `websockets` python dependency. While all visualizations can be output to an `svg` file, most of the visualizations offered by `graph_mesh.py` are better viewed in live preview mode on a desktop class PC. For example, the 3D visualizations may be rotated and zoomed in preview mode, and the path visualizations can optionally be animated in preview mode.

### Plotting Mesh data

The `graph_mesh.py` tool can plot several types of visualizations. Available types can be shown by running `graph_mesh.py list`:

```
graph_mesh.py list
points    Plot original generated points
path      Plot probe travel path
rapid     Plot rapid scan travel path
probedz   Plot probed Z values
meshz     Plot mesh Z values
overlay   Plots the current probed mesh overlaid with a profile
delta     Plots the delta between current probed mesh and a profile
```

Several options are available when plotting visualizations:

```
usage: graph_mesh.py plot [-h] [-a] [-s] [-p PROFILE_NAME] [-o OUTPUT] <plot type> <input>

positional arguments:
  <plot type>           Type of data to graph
  <input>               Path/url to Klipper Socket or path to json file

options:
  -h, --help            show this help message and exit
  -a, --animate         Animate paths in live preview
  -s, --scale-plot      Use axis limits reported by Klipper to scale plot X/Y
  -p PROFILE_NAME, --profile-name PROFILE_NAME
                        Optional name of a profile to plot for 'probedz'
  -o OUTPUT, --output OUTPUT
                        Output file path
```

Below is a description of each argument:

- `plot type`: A required positional argument designating the type of visualization to generate. Must be one of the types output by the `graph_mesh.py list` command.
- `input`: A required positional argument containing a path or url to the input source. This must be one of the following:
   - A path to Klipper's Unix Domain Socket
   - A url to an instance of Moonraker
   - A path to a json file produced by `graph_mesh.py dump <input>`
- `-a`: Optional animation for the `path` and `rapid` visualization types. Animations only apply to a live preview.
- `-s`: Optionally scales a plot using the `axis_minimum` and `axis_maximum` values reported by Klipper's `toolhead` object when the dump file was generated.
- `-p`: A profile name that may be specified when generating the `probedz` 3D mesh visualization. When generating an `overlay` or `delta` visualization this argument must be provided.
- `-o`: An optional file path indicating that the script should save the visualization to this location rather than run in preview mode. Images are saved in `svg` format.

For example, to plot an animated rapid path, connecting via Klipper's unix socket:

```
graph_mesh.py plot -a rapid ~/printer_data/comms/klippy.sock
```

Or to plot a 3d visualization of the mesh, connecting via Moonraker:

```
graph_mesh.py plot meshz http://my-printer.local
```

### Bed Mesh Analysis

The `graph_mesh.py` tool may also be used to perform an analysis on the data provided by the [bed_mesh/dump_mesh](#dumping-mesh-data) API:

```
graph_mesh.py analyze <input>
```

As with the `plot` command, the `<input>` must be a path to Klipper's unix socket, a URL to an instance of Moonraker, or a path to a json file generated by the dump command.

To begin, the analysis will perform various checks on the points and probe paths generated by `bed_mesh` at the time of the dump. This includes the following:

- The number of probe points generated, without any additions
- The number of probe points generated including any points generated as the result faulty regions and/or a configured zero reference position.
- The number of probe points generated when performing a rapid scan.
- The total number of moves generated for a rapid scan.
- A validation that the probe points generated for a rapid scan are identical to the probe points generated for a standard probing procedure.
- A "backtracking" check for both the standard probe path and a rapid scan path. Backtracking can be defined as moving to the same position more than once during the probing procedure. Backtracking should never occur during a standard probe. Faulty regions *can* result in backtracking during a rapid scan in an attempt to avoid entering a faulty region when approaching or leaving a probe location, however should never occur otherwise.

Next each probed mesh present in the dump will by analyzed, beginning with the mesh loaded at the time of the dump (if present) and followed by any saved profiles. The following data is extracted:

- Mesh shape (Min X,Y, Max X,Y Probe Count)
- Mesh Z range, (Minimum Z, Maximum Z)
- Mean Z value in the mesh
- Standard Deviation of the Z values in the Mesh

In addition to the above, a delta analysis is performed between meshes with the same shape, reporting the following:

- The range of the delta between to meshes (Minimum and Maximum)
- The mean delta
- Standard Deviation of the delta
- The absolute maximum difference
- The absolute mean

### Save mesh data to a file

The `dump` command may be used to save the response to a file which can be shared for analysis when troubleshooting:

```
graph_mesh.py dump -o <output file name> <input>
```

The `<input>` should be a path to Klipper's unix socket or a URL to an instance of Moonraker. The `-o` option may be used to specify the path to the output file. If omitted, the file will be saved in the working directory, with a file name in the following format:

`klipper-bedmesh-{year}{month}{day}{hour}{minute}{second}.json`
