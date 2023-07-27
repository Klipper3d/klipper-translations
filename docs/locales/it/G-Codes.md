# G-Codes

Questo documento descrive i comandi che Klipper supporta. Questi sono i comandi che si possono inserire nella scheda del terminale OctoPrint.

## Comandi G-Code

Klipper supporta i seguenti comandi G-Code standard:

- Movimento (G0 or G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- Sosta: `G4 P<millisecondi>`
- Sposta all'origine: `G28 [X] [Y] [Z]`
- Spegnere i motori: `M18` o `M84`
- Attendi che li movimenti correnti finiscano: `M400`
- Utilizzare distanze assolute/relative per l'estrusione: `M82`, `M83`
- Usa coordinate assolute/relative: `G90`, `G91`
- Impostare la posizione: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- Impostare la percentuale di override del fattore di velocità: `M220 S<percentuale>`
- Imposta la percentuale di sostituzione del fattore di estrusione: `M221 S<percentuale>`
- Impostare l'accelerazione: `M204 S<valore>` OPPURE `M204 P<valore> T<valore>`
   - Nota: se S non viene specificato e vengono specificati sia P che T, l'accelerazione viene impostata al minimo di P e T. Se viene specificato solo uno di P o T, il comando non ha effetto.
- Ottieni la temperatura dell'estrusore: `M105`
- Imposta la temperatura dell'estrusore: `M104 [T<index>] [S<temperatura>]`
- Imposta la temperatura dell'estrusore e attende: `M109 [T<index>] S<temperatura>`
   - Nota: M109 attende sempre che la temperatura si assesti al valore richiesto
- Imposta la temperatura del piatto: `M140 [S<temperatura>]`
- Imposta la temperatura del piatto e attende: `M190 S<temperatura>`
   - Nota: M190 attende sempre che la temperatura si assesti al valore richiesto
- Imposta la velocità della ventola: `M106 S<valore>`
- Spegnere la ventola: `M107`
- Arresto di emergenza: `M112`
- Ottieni la posizione attuale: `M114`
- Ottieni la versione del firmware: `M115`

Per ulteriori dettagli sui comandi precedenti, vedere la [documentazione RepRap G-Code](http://reprap.org/wiki/G-code).

L'obiettivo di Klipper è supportare i comandi G-Code prodotti da comuni software di terze parti (ad es. OctoPrint, Printrun, Slic3r, Cura, ecc.) nelle loro configurazioni standard. Non è un obiettivo supportare ogni possibile comando G-Code. Invece, Klipper preferisce comandi leggibili dall'uomo ["comandi G-Code estesi"](#comandi-aggiuntivi). Allo stesso modo, l'output del terminale G-Code è inteso solo per essere leggibile dall'uomo - vedere il [documento del server API](API_Server.md) se si controlla Klipper da un software esterno.

Se si necessita di un comando G-Code meno comune, potrebbe essere possibile implementarlo con una [sezione di configurazione gcode_macro] personalizzata (Config_Reference.md#gcode_macro). Ad esempio, si potrebbe usare questo per implementare: `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1`, ecc.

## Comandi aggiuntivi

Klipper utilizza comandi G-Code "estesi" per la configurazione e lo stato generale. Questi comandi estesi seguono tutti un formato simile: iniziano con un nome di comando e possono essere seguiti da uno o più parametri. Ad esempio: `SET_SERVO SERVO=mioservo ANGLE=5.3`. In questo documento, i comandi ed i parametri sono mostrati in maiuscolo, tuttavia non fanno distinzione tra maiuscole e minuscole. (Quindi, "SET_SERVO" e "set_servo" eseguono entrambi lo stesso comando.)

Questa sezione è organizzata in base al nome del modulo Klipper, che generalmente segue i nomi delle sezioni specificati nel [file di configurazione della stampante](Config_Reference.md). Si noti che alcuni moduli vengono caricati automaticamente.

### [adxl345]

I seguenti comandi sono disponibili quando una [sezione di configurazione adxl345](Config_Reference.md#adxl345) è abilitata.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: Avvia le misurazioni dell'accelerometro al numero richiesto di campioni al secondo. Se CHIP non è specificato, il valore predefinito è "adxl345". Il comando funziona in modalità start-stop: alla prima esecuzione avvia le misure, alla successiva esecuzione le interrompe. I risultati delle misurazioni vengono scritti in un file denominato `/tmp/adxl345-<chip>-<name>.csv` dove `<chip>` è il nome del chip dell'accelerometro (`my_chip_name` da `[adxl345 my_chip_name]` ) e `<name>` è il parametro NAME facoltativo. Se NAME non è specificato, il valore predefinito è l'ora corrente nel formato "AAAAMMGG_HHMMSS". Se l'accelerometro non ha un nome nella sua sezione di configurazione (semplicemente `[adxl345]`), allora la parte `<chip>` del nome non viene generata.

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: interroga l'accelerometro per il valore corrente. Se CHIP non è specificato, il valore predefinito è "adxl345". Se RATE non è specificato, viene utilizzato il valore predefinito. Questo comando è utile per testare la connessione all'accelerometro ADXL345: uno dei valori restituiti dovrebbe essere un'accelerazione di caduta libera (+/- un po' di rumore del chip).

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`: interroga l'ADXL345 register "register" (es. 44 o 0x2C). Può essere utile per scopi di debug.

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<nome_config>] REG=<register> VAL=<value>`: Scrive il valore "value" grezzo in un registro "register". Sia "value" che "registrer" possono essere un numero intero decimale o esadecimale. Usare con cura e fare riferimento alla scheda tecnica ADXL345 per riferimento.

### [angle]

I seguenti comandi sono disponibili quando una [sezione di configurazione dell'angolo](Config_Reference.md#angle) è abilitata.

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<chip_name>`: Esegue la calibrazione dell'angolo sul sensore dato (deve esserci una sezione di configurazione `[angle chip_name]` che ha specificato un parametro `stepper`). IMPORTANTE - questo strumento comanderà al motore passo-passo di muoversi senza controllare i normali limiti della cinematica. Idealmente, il motore dovrebbe essere scollegato da qualsiasi carrello della stampante prima di eseguire la calibrazione. Se non è possibile scollegare lo stepper dalla stampante, assicurarsi che il carrello sia vicino al centro della sua guida prima di iniziare la calibrazione. (Il motore passo-passo può spostarsi avanti o indietro di due rotazioni complete durante questo test.) Dopo aver completato questo test, utilizzare il comando `SAVE_CONFIG` per salvare i dati di calibrazione nel file di configurazione. Per utilizzare questo strumento è necessario installare il pacchetto Python "numpy" (consultare il [measuring resonance document](Measuring_Resonances.md#software-installation) per ulteriori informazioni).

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: Interroga il registro del sensore "register" (ad es. 44 o 0x2C). Può essere utile per scopi di debug. Questo è disponibile solo per i chip tle5012b.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: scrive il valore "value" grezzo nel registro "register". Sia "value" che "register" possono essere un numero intero decimale o esadecimale. Usare con cautela e fare riferimento alla scheda tecnica del sensore per riferimento. Questo è disponibile solo per i chip tle5012b.

### [bed_mesh]

I seguenti comandi sono disponibili quando la [sezione di configurazione bed_mesh](Config_Reference.md#bed_mesh) è abilitata (consultare anche la [guida della mesh del letto](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>]`: This command probes the bed using generated points specified by the parameters in the config. After probing, a mesh is generated and z-movement is adjusted according to the mesh. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`: questo comando restituisce i valori z sondati e i valori mesh correnti al terminale. Se viene specificato PGP=1, le coordinate X, Y generate da bed_mesh, insieme ai relativi indici associati, verranno inviate al terminale.

#### BED_MESH_MAP

`BED_MESH_MAP`: Come per BED_MESH_OUTPUT, questo comando stampa lo stato corrente della mesh sul terminale. Invece di stampare i valori in un formato leggibile, lo stato viene serializzato in formato json. Ciò consente ai plug-in di Octoprint di acquisire facilmente i dati e generare mappe di altezza che si approssimano la superficie del piatto.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: questo comando cancella la mesh e rimuove tutte le regolazioni z. Si consiglia di inserirlo nella parte finale del gcode.

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<name> SAVE=<name> REMOVE=<name>`: questo comando fornisce la gestione del profilo per lo stato della mesh. LOAD ripristinerà lo stato della mesh dal profilo corrispondente al nome fornito. SAVE salverà lo stato della mesh corrente in un profilo che corrisponde al nome fornito. Rimuovi eliminerà il profilo corrispondente al nome fornito dalla memoria persistente. Si noti che dopo aver eseguito le operazioni SAVE o REMOVE è necessario eseguire il gcode SAVE_CONFIG per rendere permanenti le modifiche alla memoria persistente.

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<value>] [Y=<value>]`: applica gli offset X e/o Y alla ricerca della mesh. Ciò è utile per le stampanti con estrusori indipendenti, poiché è necessario un offset per produrre la corretta regolazione Z dopo un cambio utensile.

### [bed_screws]

I seguenti comandi sono disponibili quando la [sezione di configurazione bed_screws](Config_Reference.md#bed_screws) è abilitata (consultare anche la [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`: questo comando richiamerà lo strumento di regolazione delle viti del piatto. Comanderà l'ugello in posizioni diverse (come definito nel file di configurazione) e consentirà di effettuare regolazioni alle viti del piatto in modo che il piatto sia a una distanza costante dall'ugello.

### [bed_tilt]

I seguenti comandi sono disponibili quando la [sezione di configurazione inclinazione_piatto](Config_Reference.md#inclinazione_piatto) è abilitata.

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then recommend updated x and y tilt adjustments. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

### [bltouch]

Il comando seguente è disponibile quando è abilitata una [sezione di configurazione bltouch](Config_Reference.md#bltouch) (vedere anche la [Guida BL-Touch](BLTouch.md)).

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<command>`: Invia un comando al BLTouch. Può essere utile per il debug. I comandi disponibili sono: `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`. Un BL-Touch V3.0 o V3.1 può anche supportare i comandi `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store`.

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`: memorizza una modalità di output nella EEPROM di un BLTouch V3.1 Le modalità di output disponibili sono: `5V`, `OD`

### [configfile]

Il modulo configfile viene caricato automaticamente.

#### SAVE_CONFIG

`SAVE_CONFIG`: questo comando sovrascriverà il file di configurazione della stampante principale e riavvierà il software host. Questo comando viene utilizzato insieme ad altri comandi di calibrazione per memorizzare i risultati dei test di calibrazione.

### [delayed_gcode]

Il comando seguente è abilitato se è stata abilitata una [sezione di configurazione di gcode ritardata](Config_Reference.md#delayed_gcode) (consultare anche la [guida ai modelli](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<nome>] [DURATION=<secondi>]`: aggiorna la durata del ritardo per il [gcode_ritardato] identificato e avvia il timer per l'esecuzione di gcode. Un valore di 0 annullerà l'esecuzione di un gcode ritardato in sospeso.

### [delta_calibrate]

I seguenti comandi sono disponibili quando la [sezione di configurazione delta_calibrate](Config_Reference.md#linear-delta-cinematica) è abilitata (consultare anche la [guida alla calibrazione delta](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe seven points on the bed and recommend updated endstop positions, tower angles, and radius. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

#### DELTA_ANALYZE

`DELTA_ANALYZE`: questo comando viene utilizzato durante la calibrazione avanzata delle stampanti delta. Vedere [Delta Calibrate](Delta_Calibrate.md) per i dettagli.

### [display]

Il comando seguente è disponibile quando è abilitata una [sezione di configurazione display](Config_Reference.md#gcode_macro).

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`: Imposta il gruppo di visualizzazione attivo di un display LCD. Ciò consente di definire più gruppi di dati di visualizzazione nella configurazione, ad es. `[display_data <group> <elementname>]` e passare da uno all'altro usando questo comando gcode esteso. Se DISPLAY non è specificato, l'impostazione predefinita è "display" (il display principale).

### [display_status]

Il modulo display_status viene caricato automaticamente se una [sezione di configurazione display](Config_Reference.md#display) è abilitata. Fornisce i seguenti comandi G-Code standard:

- Messaggio visualizzato: `M117 <messaggio>`
- Imposta la percentuale di costruzione: `M73 P<percentuale>`

Viene inoltre fornito il seguente comando G-Code esteso:

- `SET_DISPLAY_TEXT MSG=<messaggio>`: esegue l'equivalente di M117, impostando il `MSG` fornito come messaggio visualizzato. Se `MSG` viene omesso, il display verrà cancellato.

### [dual_carriage]

Il comando seguente è disponibile quando la [sezione di configurazione dual_carriage](Config_Reference.md#dual_carriage) è abilitata.

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=[0|1]`: Questo comando imposterà il carrello attivo. Viene in genere richiamato dai campi activate_gcode e deactivate_gcode in una configurazione a più estrusori.

### [endstop_phase]

I seguenti comandi sono disponibili quando una [sezione di configurazione endstop_phase](Config_Reference.md#endstop_phase) è abilitata (consultare anche la [guida alla fase endstop](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]`: Se non viene fornito alcun parametro STEPPER, questo comando riporterà le statistiche sulle fasi stepper dell'arresto durante le precedenti operazioni di homing. Quando viene fornito un parametro STEPPER, fa in modo che l'impostazione della fase di fine corsa fornita sia scritta nel file di configurazione (insieme al comando SAVE_CONFIG).

### [exclude_object]

I seguenti comandi sono disponibili quando è abilitata una [exclude_object config section](Config_Reference.md#exclude_object) (consultare anche la [exclude object guide](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=object_name] [CURRENT=1] [RESET=1]`: Senza parametri, questo restituirà un elenco di tutti gli oggetti attualmente esclusi.

Quando viene fornito il parametro `NAME`, l'oggetto denominato verrà escluso dalla stampa.

Quando viene fornito il parametro `CURRENT`, l'oggetto corrente verrà escluso dalla stampa.

Quando viene fornito il parametro `RESET` l'elenco degli oggetti esclusi verrà cancellato. Inoltre l'inclusione di `NAME` ripristinerà solo l'oggetto denominato. Questo **può** causare errori di stampa, se i livelli sono già stati saltati.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=object_name [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`: fornisce un riepilogo di un oggetto nel file.

Senza parametri forniti, questo elencherà gli oggetti definiti noti a Klipper. Restituisce un elenco di stringhe, a meno che non venga fornito il parametro `JSON`, quando restituirà i dettagli dell'oggetto in formato json.

Quando il parametro `NAME` è incluso, definisce un oggetto da escludere.

- `NAME`: questo parametro è obbligatorio. È l'identificatore utilizzato da altri comandi in questo modulo.
- `CENTER`: una coordinata X,Y per l'oggetto.
- `POLYGON`: Un array di coordinate X,Y che fornisce un contorno per l'oggetto.

Quando viene fornito il parametro `RESET`, tutti gli oggetti definiti verranno cancellati e il modulo `[exclude_object]` verrà ripristinato.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=object_name`: questo comando prende un parametro `NAME` e marca l'inizio del gcode per un oggetto sul livello corrente.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=object_name]`: Denota la fine del gcode dell'oggetto per il livello. È accoppiato con `EXCLUDE_OBJECT_START`. Un parametro `NAME` è facoltativo e avviserà solo quando il nome fornito non corrisponde all'oggetto corrente.

### [extruder]

I seguenti comandi sono disponibili se una [sezione di configurazione dell'estrusore](Config_Reference.md#extruder) è abilitata:

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: in una stampante con più sezioni di configurazione [extruder](Config_Reference.md#extruder), questo comando cambia l'hotend attivo.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Imposta i parametri di pressure advance delleo stepper di un estrusore (come definito in un [estrusore](Config_Reference.md#extruder) o [ extruder_stepper] (sezione di configurazione Config_Reference.md#extruder_stepper). Se EXTRUDER non è specificato, per impostazione predefinita viene utilizzato lo stepper definito nell'hotend attivo.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: Imposta un nuovo valore per la "distanza di rotazione" dello stepper dell'estrusore fornito (come definito in un [extruder](Config_Reference.md#extruder) o [extruder_stepper](Config_Reference .md#extruder_stepper) sezione di configurazione). Se la distanza di rotazione è un numero negativo, il movimento passo-passo verrà invertito (rispetto alla direzione passo-passo specificata nel file di configurazione). Le impostazioni modificate non vengono mantenute al ripristino di Klipper. Usare con cautela poiché piccole modifiche possono causare una pressione eccessiva tra l'estrusore e l'hotend. Eseguire una corretta calibrazione con il filamento prima dell'uso. Se il valore 'DISTANZA' non viene fornito, questo comando restituirà la distanza di rotazione corrente.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<nome> MOTION_QUEUE=<nome>`: questo comando attiverà lo stepper specificato da EXTRUDER (come definito in un [extruder](Config_Reference.md#extruder) o [extruder_stepper](Config_Reference.md#extruder_stepper) config sezione) per sincronizzarsi con il movimento di un estrusore specificato da MOTION_QUEUE (come definito in una sezione di configurazione [estrusore](Config_Reference.md#estrusore)). Se MOTION_QUEUE è una stringa vuota, lo stepper verrà desincronizzato da tutti i movimenti dell'estrusore.

#### SET_EXTRUDER_STEP_DISTANCE

Questo comando è deprecato e verrà rimosso nel prossimo futuro.

#### SYNC_STEPPER_TO_EXTRUDER

Questo comando è deprecato e verrà rimosso nel prossimo futuro.

### [fan_generic]

Il comando seguente è disponibile quando una [sezione di configurazione fan_generic](Config_Reference.md#fan_generic) è abilitata.

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<velocità>` Questo comando imposta la velocità di una ventola. "velocità" deve essere compresa tra 0.0 e 1.0.

### [filament_switch_sensor]

Il comando seguente è disponibile quando è abilitata una sezione di configurazione [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) o [filament_motion_sensor](Config_Reference.md#filament_motion_sensor).

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`: Interroga lo stato del sensore di filamento. I dati visualizzati sul terminale dipenderanno dal tipo di sensore definito nella configurazione.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<nome_sensore> ENABLE=[0|1]`: Attiva/disattiva il sensore di filamento. Se ENABLE è impostato su 0, il sensore di filamento sarà disabilitato, se impostato su 1 sarà abilitato.

### [firmware_retraction]

I seguenti comandi G-Code standard sono disponibili quando la [sezione di configurazione firmware_retraction](Config_Reference.md#firmware_retraction) è abilitata. Questi comandi consentono di utilizzare la funzione di retraction del firmware disponibile in molti slicer, per ridurre lo stringing durante gli spostamenti di non estrusione da una parte all'altra della stampa. Configurando opportunamente la pressure advance si riduce la lunghezza della retrazione richiesta.

- `G10`: Ritrae l'estrusore utilizzando i parametri attualmente configurati.
- `G11`: Ritira l'estrusore utilizzando i parametri attualmente configurati.

Sono inoltre disponibili i seguenti comandi aggiuntivi.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>]`: regola i parametri utilizzati dalla retrazione. RETRACT_LENGTH determina la lunghezza del filamento da ritrarre e estrudere. La velocità di retrazione viene regolata tramite RETRACT_SPEED, ed è generalmente impostata su un valore relativamente alto. La velocità di annullamento viene regolata tramite UNRETRACT_SPEED e non è particolarmente critica, sebbene spesso inferiore a RETRACT_SPEED. In alcuni casi è utile aggiungere una piccola quantità di lunghezza aggiuntiva all'annullamento della retrazione, e questa viene impostata tramite UNRETRACT_EXTRA_LENGTH. SET_RETRACTION è comunemente impostato come parte della configurazione dello slicer per filamento, poiché filamenti diversi richiedono impostazioni dei parametri diverse.

#### GET_RETRACTION

`GET_RETRACTION`: interroga i parametri correnti utilizzati dal firmware per retrazione e li visualizza sul terminale.

### [force_move]

Il modulo force_move viene caricato automaticamente, tuttavia alcuni comandi richiedono l'impostazione di `enable_force_move` in [printer config](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<nome_config>`: sposta lo stepper dato in avanti di 1 mm e poi indietro di 1 mm, ripetuto 10 volte. Questo è uno strumento diagnostico per aiutare a verificare la connettività stepper.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<nome_config> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]`: Questo comando sposterà forzatamente lo stepper dato della distanza data (in mm) alla velocità costante data (in mm/ S). Se viene specificato ACCEL ed è maggiore di zero, verrà utilizzata l'accelerazione data (in mm/s^2); altrimenti non viene eseguita alcuna accelerazione. Non vengono effettuati controlli sui limiti; non vengono effettuati aggiornamenti cinematici; altri stepper paralleli su un asse non verranno spostati. Prestare attenzione poiché un comando errato potrebbe causare danni! L'uso di questo comando metterà quasi sicuramente la cinematica di basso livello in uno stato errato; emettere un G28 in seguito per ripristinare la cinematica. Questo comando è destinato alla diagnostica e al debug di basso livello.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<valore>] [Y=<valore>] [Z=<valore>]`: forza il codice cinematico di basso livello a credere che la testa di stampa si trovi nella posizione cartesiana data. Questo è un comando diagnostico e di debug; utilizzare SET_GCODE_OFFSET e/o G92 per le normali trasformazioni degli assi. Se un asse non è specificato, verrà impostato automaticamente sulla posizione in cui la testa è stata comandata l'ultima volta. L'impostazione di una posizione errata o non valida può causare errori software interni. Questo comando potrebbe invalidare futuri controlli sui confini; emettere un G28 in seguito per ripristinare la cinematica.

### [gcode]

Il modulo gcode viene caricato automaticamente.

#### RESTART

`RESTART`: Ciò farà sì che il software host ricarichi la sua configurazione ed esegua un ripristino interno. Questo comando non cancellerà lo stato di errore dal microcontrollore (vedi FIRMWARE_RESTART) né caricherà nuovo software (vedi [FAQ](FAQ.md#how-do-i-upgrade-to-the-latest-software)) .

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`: Questo è simile a un comando RESTART, ma cancella anche qualsiasi stato di errore dal microcontrollore.

#### STATUS

`STATUS`: segnala lo stato del software host di Klipper.

#### HELP

`HELP`: riporta l'elenco dei comandi G-Code estesi disponibili.

### [gcode_arcs]

I seguenti comandi G-Code standard sono disponibili se una [sezione di configurazione gcode_arcs](Config_Reference.md#gcode_arcs) è abilitata:

- Movimento dell'arco in senso orario (G2), Movimento dell'arco in senso antiorario (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<velocità>] I<valore> J<valore>|I<valore> K<valore>|J<valore> K<valore>`
- Selezione del piano dell'arco: G17 (piano XY), G18 (piano XZ), G19 (piano YZ)

### [gcode_macro]

Il comando seguente è disponibile quando è abilitata una [sezione di configurazione gcode_macro](Config_Reference.md#gcode_macro) (consultare anche la [guida ai modelli di comando](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<nome_macro> VARIABLE=<nome> VALUE=<valore>`: questo comando consente di modificare il valore di una variabile gcode_macro in fase di esecuzione. Il VALUE fornito viene analizzato come un valore literal in Python.

### [gcode_move]

Il modulo gcode_move viene caricato automaticamente.

#### GET_POSITION

GET_POSITION`: Restituisce informazioni sulla posizione corrente della testa di stampa. Per ulteriori informazioni, vedere la documentazione per gli sviluppatori di [GET_POSITION output](Code_Overview.md#coordinate-systems).

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<regola>] [Y=<pos>|Y_ADJUST=<regola>] [Z=<pos>|Z_ADJUST=<regola>] [MOVE=1 [MOVE_SPEED=<velocità >]]`: imposta un offset di posizione da applicare ai futuri comandi G-Code. Questo è comunemente usato per cambiare virtualmente l'offset del letto Z o per impostare gli offset XY degli ugelli quando si cambia estrusore. Ad esempio, se viene inviato "SET_GCODE_OFFSET Z=0.2", i futuri movimenti G-Code avranno 0.2 mm aggiunti alla loro altezza Z. Se vengono utilizzati i parametri di stile X_ADJUST, la regolazione verrà aggiunta a qualsiasi offset esistente (ad esempio, "SET_GCODE_OFFSET Z=-0.2" seguito da "SET_GCODE_OFFSET Z_ADJUST=0.3" risulterà in un offset Z totale di 0.1). Se viene specificato "MOVE=1", verrà emesso un movimento della testa di stampa per applicare l'offset specificato (altrimenti l'offset avrà effetto sul successivo movimento assoluto del codice G che specifica l'asse dato). Se viene specificato "MOVE_SPEED", lo spostamento della testa utensile verrà eseguito con la velocità data (in mm/s); in caso contrario, il movimento della testa utensile utilizzerà l'ultima velocità del G-code specificata.

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<nome_stato>]`: salva lo stato di analisi delle coordinate del G-code corrente. Il salvataggio e il ripristino dello stato del G-code è utile negli script e nelle macro. Questo comando salva la modalità di coordinate assolute del G-code corrente (G90/G91), la modalità di estrusione assoluta (M82/M83), l'origine (G92), l'offset (SET_GCODE_OFFSET), l'override della velocità (M220), l'override dell'estrusore (M221), la velocità di spostamento , la posizione XYZ corrente e la posizione relativa dell'estrusore "E". Se viene fornito NAME, consente di assegnare un nome allo stato salvato alla stringa data. Se NAME non viene fornito, il valore predefinito è "predefinito".

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<nome_stato>] [MOVE=1 [MOVE_SPEED=<velocità>]]`: ripristina uno stato precedentemente salvato tramite SAVE_GCODE_STATE. Se viene specificato "MOVE=1", verrà emesso un movimento della testa utensile per tornare alla posizione XYZ precedente. Se viene specificato "MOVE_SPEED", lo spostamento della testa utensile verrà eseguito con la velocità data (in mm/s); in caso contrario, lo spostamento della testa utensile utilizzerà la velocità del codice g ripristinata.

### [hall_filament_width_sensor]

I seguenti comandi sono disponibili quando la [sezione di configurazione del sensore di larghezza del filamento tsl1401cl](Config_Reference.md#tsl1401cl_filament_width_sensor) o [sezione di configurazione del sensore di larghezza del filamento hall](Config_Reference.md#hall_filament_width_sensor) è abilitata (consultare anche [Sensore di larghezza del filamento TSLl401CL]( TSL1401CL_Filament_Width_Sensor.md) e [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)):

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`: Restituisce lo spessore del filamento misurato.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`: Cancella tutte le letture del sensore. Utile dopo il cambio del filamento.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`: Spegnere il sensore di larghezza del filamento e smettere di usarlo per il controllo del flusso.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR`: attiva il sensore di larghezza del filamento e inizia a usarlo per il controllo del flusso.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`: Restituisce le letture del canale ADC corrente e il valore grezzo (raw) del sensore per i punti di calibrazione.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`: attiva la registrazione del diametro del filamento.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`: Disattiva la registrazione del diametro del filamento.

### [heaters]

Il modulo heaters viene caricato automaticamente se un riscaldatore è definito nel file di configurazione.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`: Spegni tutti i riscaldatori.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Attendere fino a quando il sensore di temperatura specificato è pari o superiore al MINIMO fornito e/o pari o inferiore al MASSIMO fornito.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<nome_riscaldatore> [TARGET=<temperatura_destinata>]`: Imposta la temperatura target per un riscaldatore. Se non viene fornita una temperatura target, il target è 0.

### [idle_timeout]

Il modulo idle_timeout viene caricato automaticamente.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: consente all'utente di impostare il timeout di inattività (in secondi).

### [input_shaper]

Il comando seguente è abilitato se è stata abilitata una [sezione di configurazione di input_shaper](Config_Reference.md#input_shaper) (consultare anche la [guida alla compensazione della risonanza](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE=<shaper_TYPE_X=<shaper_type_x>] [SHAPER_TYPE=<shaper_type_y=<shaper_type_x> ]`: Modifica i parametri dell'input shaper. Si noti che il parametro SHAPER_TYPE reimposta l'input shaper per entrambi gli assi X e Y anche se sono stati configurati tipi di shaper diversi nella sezione [input_shaper]. SHAPER_TYPE non può essere utilizzato insieme a uno dei parametri SHAPER_TYPE_X e SHAPER_TYPE_Y. Vedere [config reference](Config_Reference.md#input_shaper) per maggiori dettagli su ciascuno di questi parametri.

### [manual_probe]

Il modulo manual_probe viene caricato automaticamente.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`: esegue uno script di supporto utile per misurare l'altezza dell'ugello in una determinata posizione. Se viene specificato SPEED, imposta la velocità dei comandi TESTZ (il valore predefinito è 5mm/s). Durante una sonda manuale, sono disponibili i seguenti comandi aggiuntivi:

- `ACCEPT`: questo comando accetta la posizione Z corrente e conclude il probing manuale.
- `ABORT`: questo comando termina lo strumento di probing manuale.
- `TESTZ Z=<valore>`: questo comando sposta l'ugello verso l'alto o verso il basso della quantità specificata in "valore". Ad esempio, `TESTZ Z=-.1` sposterebbe l'ugello verso il basso di .1 mm mentre `TESTZ Z=.1` sposterebbe l'ugello verso l'alto di .1 mm. Il valore può anche essere `+`, `-`, `++` o `--` per spostare l'ugello verso l'alto o verso il basso di un importo rispetto ai tentativi precedenti.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: esegue uno script di supporto utile per calibrare un'impostazione di configurazione Z position_endstop. Vedere il comando MANUAL_PROBE per i dettagli sui parametri e sui comandi aggiuntivi disponibili mentre lo strumento è attivo.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`: prende l'offset Z Gcode corrente (noto anche come babystepping) e lo sottrae da stepper_z endstop_position. Questa azione per prendere un valore di babystep utilizzato di frequente e "renderlo permanente". Richiede un `SAVE_CONFIG` per avere effetto.

### [Stepper manuali]

Il comando seguente è disponibile quando una [sezione di configurazione stepper_manuale](Config_Reference.md#stepper_manuale) è abilitata.

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=nome_config [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<velocità>] [ACCEL=<accelerazione>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|- 1|-2]] [SYNC=0]]`: Questo comando altererà lo stato dello stepper. Utilizzare il parametro ENABLE per abilitare/disabilitare lo stepper. Utilizzare il parametro SET_POSITION per forzare lo stepper a pensare di trovarsi nella posizione data. Utilizzare il parametro MOVE per richiedere un movimento alla posizione data. Se viene specificato SPEED e/o ACCEL, verranno utilizzati i valori forniti al posto dei valori predefiniti specificati nel file di configurazione. Se viene specificato un ACCEL pari a zero, non verrà eseguita alcuna accelerazione. Se viene specificato STOP_ON_ENDSTOP=1, lo spostamento terminerà in anticipo se l'endstop segnala come attivato (usa STOP_ON_ENDSTOP=2 per completare lo spostamento senza errori anche se l'endstop non si attiva, usa -1 o -2 per interrompere quando l'endstop segnala non innescato). Normalmente i futuri comandi G-Code verranno programmati per essere eseguiti dopo il completamento del movimento passo-passo, tuttavia se un movimento passo-passo manuale utilizza SYNC=0, i futuri comandi di movimento G-Code potrebbero essere eseguiti in parallelo con il movimento passo-passo.

### [mcp4018]

Il comando seguente è disponibile quando una [sezione di configurazione mcp4018](Config_Reference.md#mcp4018) è abilitata.

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: Questo comando cambierà il valore corrente del digipot. Questo valore dovrebbe essere in genere compreso tra 0.0 e 1.0, a meno che non sia definita una 'scale' nella configurazione. Quando viene definita 'scale', questo valore dovrebbe essere compreso tra 0,0 e 'scale'.

### [led]

Il comando seguente è disponibile quando una qualsiasi delle [sezioni di configurazione led](Config_Reference.md#leds) è abilitata.

#### SET_LED

`SET_LED LED=<nome_config> ROSSO=<valore> VERDE=<valore> BLU=<valore> BIANCO=<valore> [INDEX=<indice>] [TRANSMIT=0] [SYNC=1]`: Imposta il LED in output. Ogni colore `<valore>` deve essere compreso tra 0,0 e 1,0. L'opzione BIANCO è valida solo su LED RGBW. Se il LED supporta più chip in una catena daisy-chain, è possibile specificare INDEX per modificare il colore del solo chip specificato (1 per il primo chip, 2 per il secondo, ecc.). Se INDEX non viene fornito, tutti i LED nella catena verranno impostati sul colore fornito. Se viene specificato TRANSMIT=0, il cambio colore verrà effettuato solo sul successivo comando SET_LED che non specifica TRANSMIT=0; questo può essere utile in combinazione con il parametro INDEX per raggruppare più aggiornamenti in una catena. Per impostazione predefinita, il comando SET_LED sincronizzerà le modifiche con altri comandi gcode in corso. Ciò può comportare un comportamento indesiderato se i LED vengono impostati mentre la stampante non sta stampando in quanto reimposta il timeout di inattività. Se non è necessaria una tempistica attenta, è possibile specificare il parametro SYNC=0 opzionale per applicare le modifiche senza ripristinare il timeout di inattività.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<nome_led> TEMPLATE=<nome_modello> [<param_x>=<letterale>] [INDEX=<indice>]`: Assegna un [modello_visualizzazione](Config_Reference.md#modello_visualizzazione) a un dato [LED](Riferimento_Configurazione .md#led). Ad esempio, se si definisce una sezione di configurazione `[display_template my_led_template]` allora si potrebbe assegnare `TEMPLATE=my_led_template` qui. Il display_template dovrebbe produrre una stringa separata da virgole contenente quattro numeri in virgola mobile corrispondenti alle impostazioni dei colori rosso, verde, blu e bianco. Il modello verrà continuamente valutato e il LED verrà impostato automaticamente sui colori risultanti. È possibile impostare i parametri display_template da utilizzare durante la valutazione del modello (i parametri verranno analizzati come valori letterali Python). Se INDEX non è specificato, tutti i chip nella catena dei LED verranno impostati sul modello, altrimenti verrà aggiornato solo il chip con l'indice specificato. Se TEMPLATE è una stringa vuota, questo comando cancellerà qualsiasi modello precedente assegnato al LED (è quindi possibile utilizzare i comandi `SET_LED` per gestire le impostazioni del colore del LED).

### [output_pin]

Il comando seguente è disponibile quando una [sezione di configurazione pin_output](Config_Reference.md#pin_output) è abilitata.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: Imposta il pin sull'output `VALUE`. VALUE dovrebbe essere 0 o 1 per i pin di uscita "digital". Per i pin PWM, impostare su un valore compreso tra 0.0 e 1.0 o tra 0.0 e `scale` se è configurata una scala nella sezione di configurazione output_pin.

Alcuni pin (attualmente solo pin "soft PWM") supportano l'impostazione di un tempo di ciclo esplicito utilizzando il parametro CYCLE_TIME (specificato in secondi). Si noti che il parametro CYCLE_TIME non è memorizzato tra i comandi SET_PIN (qualsiasi comando SET_PIN senza un parametro CYCLE_TIME esplicito utilizzerà il `cycle_time` specificato nella sezione di configurazione output_pin).

### [palette2]

I seguenti comandi sono disponibili quando la [sezione di configurazione della palette2](Config_Reference.md#palette2) è abilitata.

Le stampe di Palette funzionano incorporando speciali OCodes (Codici Omega) nel file GCode:

- `O1`...`O32`: Questi codici vengono letti dal flusso GCode ed elaborati da questo modulo e passati al dispositivo Palette 2.

Sono inoltre disponibili i seguenti comandi aggiuntivi.

#### PALETTE_CONNECT

`PALETTE_CONNECT`: questo comando inizializza la connessione con la Palette 2.

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`: questo comando si disconnette dalla Palette 2.

#### PALETTE_CLEAR

`PALETTE_CLEAR`: questo comando indica alla Palette 2 di cancellare tutti i percorsi di input e output del filamento.

#### PALETTE_CUT

`PALETTE_CUT`: Questo comando indica alla Palette 2 di tagliare il filamento attualmente caricato nello splice core.

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`: Questo comando avvia la sequenza di caricamento intelligente sulla Palette 2. Il filamento viene caricato automaticamente estrudendolo alla distanza calibrata sul dispositivo per la stampante e istruisce la Palette 2 una volta completato il caricamento. Questo comando equivale a premere **Smart Load** direttamente sullo schermo della Palette 2 dopo che il caricamento del filamento è stato completato.

### [pid_calibrate]

Il modulo pid_calibrate viene caricato automaticamente se nel file di configurazione è definito un riscaldatore.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<nome_config> TARGET=<temperatura> [WRITE_FILE=1]`: esegue un test di calibrazione PID. Il riscaldatore specificato verrà abilitato fino al raggiungimento della temperatura target specificata, quindi il riscaldatore verrà spento e acceso per diversi cicli. Se il parametro WRITE_FILE è abilitato, verrà creato il file /tmp/heattest.txt con un log di tutti i campioni di temperatura prelevati durante il test.

### [pause_resume]

I seguenti comandi sono disponibili quando la [pause_resume config section](Config_Reference.md#pause_resume) è abilitata:

#### PAUSE

`PAUSE`: mette in pausa la stampa corrente. La posizione attuale viene acquisita per la ripresa al ripristino.

#### RESUME

`RESUME [VELOCITY=<value>]`: riprende la stampa da una pausa, ripristinando prima la posizione precedentemente acquisita. Il parametro VELOCITY determina la velocità alla quale l'utensile deve tornare alla posizione originale acquisita.

#### CLEAR_PAUSE

`CLEAR_PAUSE`: cancella lo stato di pausa corrente senza riprendere la stampa. Questo è utile se si decide di annullare una stampa dopo un PAUSE. Si consiglia di aggiungerlo al gcode iniziale per assicurarsi che lo stato in pausa sia aggiornato per ogni stampa.

#### CANCEL_PRINT

`CANCEL_PRINT`: Annulla la stampa corrente.

### [print_stats]

Il modulo print_stats viene caricato automaticamente.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>] [CURRENT_LAYER= <current_layer>]`: passa le informazioni sulo slicer come il layer attivo ed il totale a Klipper. Aggiungi `SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>]` alla sezione gcode di inizio del tuo slicer e `SET_PRINT_STATS_INFO [CURRENT_LAYER= <current_layer>]` alla sezione gcode di cambio livello per passare le informazioni sul livello dal tuo slicer a Klipper.

### [probe]

I seguenti comandi sono disponibili quando è abilitata una [sezione di configurazione della sonda](Config_Reference.md#probe) o una [sezione di configurazione di bltouch](Config_Reference.md#bltouch) (consultare anche la [guida alla calibrazione della sonda](Probe_Calibrate.md)).

#### sonda

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`: Sposta il nozzle verso il basso finché la sonda non scatta. Se viene fornito uno qualsiasi dei parametri opzionali, sovrascrive l'impostazione equivalente nella sezione [probe config section](Config_Reference.md#probe).

#### QUERY_PROBE

`QUERY_PROBE`: Riporta lo stato corrente della sonda ("triggered" o "open").

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`: Calcola la deviazione massima, minima, media, mediana e standard di più campionamentidella sonda. Per impostazione predefinita, vengono presi 10 CAMPIONI. In caso contrario, i parametri opzionali sono impostati per default sulla loro impostazione equivalente nella sezione di configurazione della sonda.

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>]`: Eseguire uno script di aiuto utile per calibrare l'offset z della sonda. Vedere il comando PROBE per i dettagli sui parametri opzionali della sonda. Vedere il comando MANUAL_PROBE per i dettagli del parametro SPEED e sui comandi aggiuntivi disponibili mentre lo strumento è attivo. Nota che il comando PROBE_CALIBRATE utilizza la variabile di velocità per spostarsi in direzione XY e Z.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`: prende l'offset Z Gcode corrente (aka, babystepping) e lo sottrae dallo z_offset della sonda. Questo per prendere un valore di babystep utilizzato di frequente e "renderlo permanente". Richiede un `SAVE_CONFIG` per avere effetto.

### [query_adc]

Il modulo query_adc viene caricato automaticamente.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]`: Riporta l'ultimo valore analogico ricevuto per un pin analogico configurato. Se NAME non viene fornito, viene riportato l'elenco dei nomi dei convertitori adc disponibili. Se viene fornito PULLUP (come valore in Ohm), viene riportato il valore analogico grezzo insieme alla resistenza equivalente dato quel pullup specificato.

### [query_endstops]

Il modulo query_endstops viene caricato automaticamente. I seguenti comandi G-Code standard sono attualmente disponibili, ma non è consigliabile utilizzarli:

- Ottieni lo stato del finecorsa: `M119` (usa invece QUERY_ENDSTOPS.)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`: Rilevare i finecorsa degli assi e segnala se sono "attivate" o in uno stato "aperto". Questo comando viene in genere utilizzato per verificare che un finecorsa funzioni correttamente.

### [resonance_tester]

I seguenti comandi sono disponibili quando una [sezione di configurazione di tester_risonanza](Config_Reference.md#tester_risonanza) è abilitata (consultare anche la [guida alle risonanze di misurazione](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: misura ed riporta il rumore per tutti gli assi di tutti i chip dell'accelerometro abilitati.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<asse> OUTPUT=<risonanze,dati_grezzi> [NAME=<nome>] [FREQ_START=<freq_min>] [FREQ_END=<freq_max>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<adxl345_chip_name>] [ POINT=x,y,z] [INPUT_SHAPING=[<0:1>]]`: esegue il test di risonanza in tutti i punti sonda configurati per l'"asse" richiesto e misura l'accelerazione utilizzando i chip dell'accelerometro configurati per il rispettivo asse. "asse" può essere X o Y, oppure specificare una direzione arbitraria come `AXIS=dx,dy`, dove dx e dy sono numeri in virgola mobile che definiscono un vettore di direzione (es. `AXIS=X`, `AXIS=Y`, o `AXIS=1,-1` per definire una direzione diagonale). Nota che `AXIS=dx,dy` e `AXIS=-dx,-dy` sono equivalenti. `adxl345_chip_name` può essere uno o più chip adxl345 configurati, delimitati da virgole, ad esempio `CHIPS="adxl345, adxl345 rpi"`. Nota che `adxl345` può essere omesso dai chip adxl345 denominati. Se POINT è specificato, sovrascriverà i punti configurati in `[resonance_tester]`. Se `INPUT_SHAPING=0` o non impostato (predefinito), disabilita l'input shaping per il test di risonanza, perché non è valido eseguire il test di risonanza con input shaper abilitato. Il parametro `OUTPUT` è un elenco separato da virgole di cui verranno scritti gli output. Se viene richiesto `raw_data`, i dati grezzi dell'accelerometro vengono scritti in un file o in una serie di file `/tmp/raw_data_<asse>_[<nome_chip>_][<punto>_]<nome>.csv` con (`<punto>_` parte del nome generata solo se è configurato più di 1 punto sonda o è specificato PUNTO). Se viene specificato `resonances`, la risposta in frequenza viene calcolata (su tutti i punti sonda) e scritta nel file `/tmp/resonances_<asse>_<nome>.csv`. Se non è impostato, OUTPUT è impostato su `risonanze` e NAME è impostato sull'ora corrente nel formato "AAAAMMGG_HHMMSS".

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<adxl345_chip_name>] [MAX_SMOOTHING=<max_smoothing>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command, and if `[input_shaper]` was already enabled previously, these parameters take effect immediately.

### [respond]

I seguenti comandi G-Code standard sono disponibili quando la [sezione di configurazione di risposta](Config_Reference.md#respond) è abilitata:

- `M118 <messaggio>`: fa eco al messaggio preceduto dal prefisso predefinito configurato (o `echo: ` se non è configurato alcun prefisso).

Sono inoltre disponibili i seguenti comandi aggiuntivi.

#### RESPOND

- `RESPOND MSG="<message>"`: echo il messaggio preceduto dal prefisso predefinito configurato (o `echo: ` se non è configurato alcun prefisso).
- `RESPOND TYPE=echo MSG="<message>"`: echo del messaggio preceduto da `echo: `.
- `RESPOND TYPE=echo_no_space MSG="<messaggio>"`: fa eco al messaggio preceduto da `echo:` senza uno spazio tra prefisso e messaggio, utile per la compatibilità con alcuni plugin di octoprint che prevedono una formattazione molto specifica.
- `RESPOND TYPE=command MSG="<message>"`: echo il messaggio preceduto da `// `. OctoPrint può essere configurato per rispondere a questi messaggi (ad es. `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<messaggio>"`: fa eco al messaggio preceduto da `!! `.
- `RESPOND PREFIX=<prefix> MSG="<message>"`: echo il messaggio preceduto da `<prefix>`. (Il parametro `PREFIX` avrà la priorità sul parametro `TYPE`)

### [save_variables]

Il comando seguente è abilitato se è stata abilitata una [sezione di configurazione save_variables](Config_Reference.md#save_variables).

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<nome> VALUE=<valore>`: salva la variabile su disco in modo che possa essere utilizzata tra i riavvii. Tutte le variabili memorizzate vengono caricate nel dict `printer.save_variables.variables` all'avvio e possono essere utilizzate nelle macro gcode. Il VALUE fornito viene analizzato come un valore letterale Python.

### [screws_tilt_adjust]

I seguenti comandi sono disponibili quando la [sezione di configurazione viti_tilt_adjust](Config_Reference.md#screws_tilt_adjust) è abilitata (consultare anche la [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe )).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will invoke the bed screws adjustment tool. It will command the nozzle to different locations (as defined in the config file) probing the z height and calculate the number of knob turns to adjust the bed level. If DIRECTION is specified, the knob turns will all be in the same direction, clockwise (CW) or counterclockwise (CCW). See the PROBE command for details on the optional probe parameters. IMPORTANT: You MUST always do a G28 before using this command. If MAX_DEVIATION is specified, the command will raise a gcode error if any difference in the screw height relative to the base screw height is greater than the value provided. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

### [sdcard_loop]

Quando la [sezione di configurazione sdcard_loop](Config_Reference.md#sdcard_loop) è abilitata, sono disponibili i seguenti comandi estesi.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`: inizia una sezione in loop nella stampa SD. Un conteggio pari a 0 indica che la sezione deve essere ripetuta indefinitamente.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: termina una sezione in loop nella stampa SD.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: completa i loop esistenti senza ulteriori iterazioni.

### [servo]

I seguenti comandi sono disponibili quando una [sezione di configurazione servo](Config_Reference.md#servo) è abilitata.

#### SET_SERVO

`SET_SERVO SERVO=nome_config [ANGLE=<gradi> | WIDTH=<secondi>]`: Imposta la posizione del servo sull'angolo dato (in gradi) o sulla larghezza dell'impulso (in secondi). Usa `WIDTH=0` per disabilitare l'uscita servo.

### [skew_correction]

I seguenti comandi sono disponibili quando è abilitata la [sezione config_correzione_asimmetria](Config_Reference.md#correzione_asimmetria) (consultare anche la guida [Correzione_asimmetria](Correzione_asimmetria.md)).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`: Configura il modulo [correzione_inclinazione ] con misure (in mm) tratte da una stampa di calibrazione. Si possono inserire misure per qualsiasi combinazione di piani, i piani non inseriti manterranno il loro valore attuale. Se viene immesso `CLEAR=1`, tutta la correzione dell'inclinazione sarà disabilitata.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: Riporta l'inclinazione corrente della stampante per ciascun piano sia in radianti che in gradi. L'inclinazione  viene calcolata in base ai parametri forniti tramite il gcode `SET_SKEW`.

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>]`: calcola e riporta l'inclinazione (in radianti e gradi) in base a una stampa di test misurata. Questo può essere utile per determinare l'inclinazione corrente della stampante dopo che è stata applicata la correzione. Può anche essere utile prima di applicare la correzione per determinare se è necessaria la correzione dell'inclinazione. Vedere [Correzione inclinazione](Correzione_inclinazione.md) per i dettagli su oggetti e misurazioni di calibrazione inclinazione.

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<nome>] [SAVE=<nome>] [REMOVE=<nome>]`: Gestione del profilo per correzione_inclinazione. LOAD ripristinerà lo stato di inclinazione dal profilo corrispondente al nome fornito. SAVE salverà lo stato di inclinazione corrente in un profilo che corrisponde al nome fornito. REMOVE eliminerà il profilo corrispondente al nome fornito dalla memoria persistente. Si noti che dopo aver eseguito le operazioni SAVE o REMOVE è necessario eseguire il gcode SAVE_CONFIG per rendere permanenti le modifiche alla memoria persistente.

### [smart_effector]

Sono disponibili diversi comandi quando una [sezione di configurazione smart_effector](Config_Reference.md#smart_effector) è abilitata. Assicurati di controllare la documentazione ufficiale per Smart Effector su [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer) prima di modificare i parametri di Smart Effector. Controllare anche la [guida alla calibrazione della sonda](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<sensibilità>] [ACCEL=<accel>] [RECOVERY_TIME=<tempo>]`: imposta i parametri di Smart Effector. Quando viene specificato `SENSITIVITY`, il rispettivo valore viene scritto nella EEPROM dello SmartEffector (richiede che sia fornito `control_pin`). I valori di `<sensibilità>` accettabili sono 0..255, il valore predefinito è 50. Valori inferiori richiedono una minore forza di contatto dell'ugello per attivarsi (ma esiste un rischio maggiore di falso trigger a causa delle vibrazioni durante la tastatura) e valori più alti riducono il falso trigger (ma richiede una maggiore forza di contatto per attivarsi). Poiché la sensibilità viene scritta nella EEPROM, viene conservata dopo lo spegnimento e quindi non è necessario configurarla ad ogni avvio della stampante. `ACCEL` e `RECOVERY_TIME` consentono di sovrascrivere i parametri corrispondenti in fase di esecuzione, vedere la [sezione di configurazione](Config_Reference.md#smart_effector) di Smart Effector per maggiori informazioni su quei parametri.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`: Ripristina la sensibilità di Smart Effector alle impostazioni di fabbrica. Richiede che il relativo `control_pin` sia fornito nella sezione di configurazione.

### [stepper_enable]

Il modulo stepper_enable viene caricato automaticamente.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<nome_config> ENABLE=[0|1]`: Abilita o disabilita solo lo stepper dato. Questo è uno strumento diagnostico e di debug e deve essere utilizzato con cautela. La disabilitazione di un motore dell'asse non ripristina le informazioni di homing. Lo spostamento manuale di uno stepper disabilitato può causare l'azionamento del motore della macchina al di fuori dei limiti di sicurezza. Ciò può causare danni ai componenti dell'asse, al hotend e alla superficie di stampa.

### [temperature_fan]

Il comando seguente è disponibile quando una [sezione di configurazione della ventola_temperatura](Config_Reference.md#ventola_temperatura) è abilitata.

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>] [max_speed=<max_speed>]`: Imposta la temperatura target per una temperature_fan. Se non viene fornito un target, viene impostato sulla temperatura specificata nel file di configurazione. Se le velocità non vengono fornite, non viene applicata alcuna modifica.

### [tmcXXXX]

I seguenti comandi sono disponibili quando una qualsiasi delle [tmcXXXX config section](Config_Reference.md#tmc-stepper-driver-configuration) è abilitata.

#### DUMP_TMC

`DUMP_TMC STEPPER=<name> [REGISTER=<name>]`: This command will read all TMC driver registers and report their values. If a REGISTER is provided, only the specified register will be dumped.

#### INIT_TMC

`INIT_TMC STEPPER=<nome>`: questo comando inizializzerà i registri TMC. Necessario per riattivare il driver se l'alimentazione al chip viene spenta e poi riaccesa.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: This will adjust the run and hold currents of the TMC driver. `HOLDCURRENT` is not applicable to tmc2660 drivers. When used on a driver which has the `globalscaler` field (tmc5160 and tmc2240), if StealthChop2 is used, the stepper must be held at standstill for >130ms so that the driver executes the AT#1 calibration.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value> VELOCITY=<value>`: This will alter the value of the specified register field of the TMC driver. This command is intended for low-level diagnostics and debugging only because changing the fields during run-time can lead to undesired and potentially dangerous behavior of your printer. Permanent changes should be made using the printer configuration file instead. No sanity checks are performed for the given values. A VELOCITY can also be specified instead of a VALUE. This velocity is converted to the 20bit TSTEP based value representation. Only use the VELOCITY argument for fields that represent velocities.

### [toolhead]

Il modulo toolhead viene caricato automaticamente.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<valore>] [ACCEL=<valore>] [ACCEL_TO_DECEL=<valore>] [SQUARE_CORNER_VELOCITY=<valore>]`: Modifica i limiti di velocità della stampante.

### [tuning_tower]

Il modulo tuning_tower viene caricato automaticamente.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<comando> PARAMETER=<nome> START=<valore> [SKIP=<valore>] [FACTOR=<valore> [BAND=<valore>]] | [STEP_DELTA=<valore> STEP_HEIGHT=<valore>]`: Uno strumento per regolare un parametro su ciascuna altezza Z durante una stampa. Lo strumento eseguirà il dato `COMMAND` con il dato `PARAMETER` assegnato a un valore che varia con `Z` secondo una formula. Usa `FACTOR` se utilizzerai un righello o calibri per misurare l'altezza Z del valore ottimale, o `STEP_DELTA` e `STEP_HEIGHT` se il modello della torre di regolazione ha bande di valori discreti come è comune con le torri della temperatura. Se viene specificato `SKIP=<valore>`, il processo di ottimizzazione non inizia finché non viene raggiunta l'altezza Z `<valore>`, e al di sotto di essa il valore sarà impostato su `START`; in questo caso, la `z_height` usata nelle formule seguenti è in realtà `max(z - skip, 0)`. Ci sono tre possibili combinazioni di opzioni:

- `FACTOR`: Il valore cambia a una velocità di `factor` per millimetro. La formula utilizzata è: `valore = inizio + fattore * z_altezza`. È possibile inserire l'altezza Z ottimale direttamente nella formula per determinare il valore del parametro ottimale.
- `FACTOR` e `BAND`: il valore cambia a una velocità media di `factor` per millimetro, ma in bande discrete in cui la regolazione verrà effettuata solo ogni `BAND` millimetri di altezza Z. La formula utilizzata è: `value = start + factor * ((floor(z_height / band) + .5) * band)`.
- `STEP_DELTA` e `STEP_HEIGHT`: il valore cambia di `STEP_DELTA` ogni `STEP_HEIGHT` millimetri. La formula utilizzata è: `value = start + step_delta * floor(z_height / step_height)`. Puoi semplicemente contare le bande o leggere le etichette della torre di tuning per determinare il valore ottimale.

### [virtual_sdcard]

Klipper supporta i seguenti comandi G-Code standard se la [sezione di configurazione di virtual_sdcard](Config_Reference.md#virtual_sdcard) è abilitata:

- Elenco scheda SD: `M20`
- Inizializza scheda SD: `M21`
- Selezionare il file SD: `M23 <nomefile>`
- Avvia/riprendi la stampa SD: `M24`
- Sospendi la stampa SD: `M25`
- Impostare la posizione SD: `M26 S<offset>`
- Riporta lo stato di stampa SD: `M27`

Inoltre, quando la sezione di configurazione "virtual_sdcard" è abilitata, sono disponibili i seguenti comandi estesi.

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<nomefile>`: carica un file e avvia la stampa SD.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`: Scarica il file e cancella lo stato SD.

### [z_thermal_adjust]

I seguenti comandi sono disponibili quando la [sezione z_thermal_adjust config](Config_Reference.md#z_thermal_adjust) è abilitata.

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<valore>] [REF_TEMP=<valore>]`: Abilita o disabilita la regolazione termica Z con `ENABLE`. La disabilitazione non rimuove alcuna regolazione già applicata, ma congela il valore di regolazione corrente - questo impedisce il movimento Z verso il basso potenzialmente pericoloso. La riattivazione può potenzialmente causare il movimento dell'utensile verso l'alto quando la regolazione viene aggiornata e applicata. `TEMP_COEFF` consente la regolazione in tempo reale del coefficiente di temperatura di regolazione (cioè il parametro di configurazione `TEMP_COEFF`). I valori `TEMP_COEFF` non vengono salvati nella configurazione. `REF_TEMP` sovrascrive manualmente la temperatura di riferimento tipicamente impostata durante l'homing (per l'uso, ad esempio, in routine di homing non standard) - verrà ripristinata automaticamente durante l'homing.

### [z_tilt]

I seguenti comandi sono disponibili quando la [sezione z_tilt config](Config_Reference.md#z_tilt) è abilitata.

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.
