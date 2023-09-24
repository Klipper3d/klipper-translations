# slicer

Questo documento fornisce alcuni suggerimenti per configurare un'applicazione "slicer" da usare con Klipper. Gli slicer comuni usati con Klipper sono Slic3r, Cura, Simplify3D, ecc.

## Imposta il Gcode su variante Marlin

Molti slicer hanno un'opzione per configurare il "gusto G-Code" o G-Code flavor. L'impostazione predefinita è spesso "Marlin" e funziona bene con Klipper. L'impostazione "Smoothieware" funziona bene anche con Klipper.

## Klipper gcode_macro

Gli slicer spesso consentono di configurare le sequenze "Start G-Code" e "End G-Code". Spesso è invece conveniente definire macro personalizzate nel file di configurazione di Klipper, come ad esempio: `[gcode_macro START_PRINT]` e `[gcode_macro END_PRINT]`. Quindi puoi semplicemente eseguire START_PRINT e END_PRINT nella configurazione dello slicer. La definizione di queste azioni nella configurazione di Klipper può rendere più semplice modificare i passaggi iniziali e finali della stampante poiché le modifiche non richiedono il re-slicing.

Vedere [sample-macros.cfg](../config/sample-macros.cfg) ad esempio le macro START_PRINT e END_PRINT.

Vedere il [config reference](Config_Reference.md#gcode_macro) per i dettagli sulla definizione di una macro gcode.

## Impostazioni di retrazione di grandi dimensioni potrebbero richiedere la messa a punto di Klipper

La velocità massima e l'accelerazione dei movimenti di ritrazione sono controllate in Klipper dalle impostazioni di configurazione `max_extrude_only_velocity` e `max_extrude_only_accel`. Queste impostazioni hanno un valore predefinito che dovrebbe funzionare bene su molte stampanti. Tuttavia, se si è configurata una grande retrazione nello slicer (ad es. 5 mm o superiore), è possibile che limitino la velocità di retrazione desiderata.

Se si utilizza una grande retrazione, prendere in considerazione l'ottimizzazione di [pressure advance](Pressure_Advance.md) di Klipper. Altrimenti, se si scopre che la testa di stampa sembra "mettersi in pausa" durante la retrazione e il priming, allora considerare di definire esplicitamente `max_extrude_only_velocity` e `max_extrude_only_accel` nel file di configurazione di Klipper.

## Non abilitare "coasting" -costeggiando-

È probabile che la funzione "coasting" si traduca in stampe di scarsa qualità con Klipper. Prendi in considerazione l'utilizzo di [pressure advance](Pressure_Advance.md) di Klipper.

In particolare, se lo slicer cambia drasticamente la velocità di estrusione tra i movimenti, Klipper eseguirà la decelerazione e l'accelerazione tra i movimenti. È probabile che questo renda il blobbing peggiore, non migliore.

Al contrario, va bene (e spesso utile) utilizzare l'impostazione ritiro "retract" , l'impostazione pulire "wipe" e/o l'impostazione pulire alla retrazione "wipe on retract".

## Non utilizzare la "distanza di riavvio extra"- "extra restart distance"su Simplify3d

Questa impostazione può causare cambiamenti radicali alle velocità di estrusione che possono attivare il controllo della sezione trasversale di estrusione massima di Klipper. Prendi in considerazione l'utilizzo dell'[pressure advance](Pressure_Advance.md) di Klipper o della normale impostazione di retrazione Simplify3d.

## Disabilita "PreloadVE" su KISSlicer

Se si utilizza il software di slicing KISSlicer, impostare "PreloadVE" su zero. Prendi in considerazione l'utilizzo di [pressure advance](Pressure_Advance.md) di Klipper.

## Disattiva le impostazioni di "pressione dell'estrusore avanzata"-"advanced extruder pressure"

Alcune affettatrici pubblicizzano una capacità di "pressione dell'estrusore avanzata" - "advanced extruder pressure". Si consiglia di mantenere queste opzioni disabilitate quando si utilizza Klipper poiché è probabile che si traducano in stampe di scarsa qualità. Prendi in considerazione l'utilizzo di [pressure advance](Pressure_Advance.md) di Klipper.

In particolare, queste impostazioni dello slicer possono indicare al firmware di apportare modifiche alla velocità di estrusione nella speranza che il firmware si avvicini a tali richieste e che la stampante ottenga approssimativamente una pressione dell'estrusore desiderabile. Klipper, tuttavia, utilizza calcoli cinematici e tempi precisi. Quando a Klipper viene comandato di apportare modifiche significative alla velocità di estrusione, pianificherà le modifiche corrispondenti a velocità, accelerazione e movimento dell'estrusore, il che non è l'intento dello slicer. Lo slicer può anche comandare velocità di estrusione eccessive al punto da attivare il controllo della sezione trasversale di estrusione massima di Klipper.

Al contrario, va bene (e spesso utile) utilizzare l'impostazione ritiro "retract" , l'impostazione pulire "wipe" e/o l'impostazione pulire alla retrazione "wipe on retract".

## Macro START_PRINT

Quando si utilizza una macro START_PRINT o simile, a volte è utile passare i parametri dalle variabili dello slicer alla macro.

In Cura, per passare le temperature, verrebbe utilizzato il seguente gcode iniziale:

```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

Nei derivati di slic3r come PrusaSlicer e SuperSlicer, verrebbe utilizzato quanto segue:

```
START_PRINT EXTRUDER_TEMP=[first_layer_temperature] BED_TEMP=[first_layer_bed_temperature]
```

Si noti inoltre che questeislicer inseriranno i propri codici di riscaldamento quando determinate condizioni non vengono soddisfatte. In Cura, l'esistenza delle variabili `{material_bed_temperature_layer_0}` e `{material_print_temperature_layer_0}` è sufficiente per mitigare questo problema. Nei derivati slic3r, dovresti usare:

```
M140 S0
M104 S0
```

prima della chiamata della macro. Tieni inoltre presente che SuperSlicer ha un'opzione del pulsante "solo gcode personalizzato", che ottiene lo stesso risultato.

Un esempio di una macro START_PRINT che utilizza questi parametri può essere trovato in config/sample-macros.cfg
