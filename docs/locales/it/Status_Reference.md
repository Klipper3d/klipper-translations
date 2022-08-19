# Status reference

Questo documento è un riferimento alle informazioni sullo stato della stampante disponibili in Klipper [macro](Command_Templates.md), [display fields](Config_Reference.md#display) e tramite [API Server](API_Server.md).

I campi in questo documento sono soggetti a modifiche: se si utilizza un attributo, assicurarsi di rivedere il [documento Modifiche alla configurazione](Config_Changes.md) durante l'aggiornamento del software Klipper.

## angle

Le seguenti informazioni sono disponibili negli oggetti [angle some_name](Config_Reference.md#angle):

- `temperature`: l'ultima lettura della temperatura (in gradi Celsius) da un sensore magnetico Hall tle5012b. Questo valore è disponibile solo se il sensore angolare è un chip tle5012b e se le misurazioni sono in corso (altrimenti segnala `None`).

## bed_mesh

Le seguenti informazioni sono disponibili in [bed_mesh](Config_Reference.md#bed_mesh):

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`: informazioni sulla bed_mesh attualmente attiva.
- `profiles`: l'insieme dei profili attualmente definiti come setup usando BED_MESH_PROFILE.

## bed_screws

Le seguenti informazioni sono disponibili nell'oggetto `Config_Reference.md#bed_screws`:

- `is_active`: Restituisce True se lo strumento di regolazione delle viti del letto è attualmente attivo.
- `state`: lo stato dello strumento di regolazione delle viti del piatto. È una delle seguenti stringhe: "adjust", "fine".
- `current_screw`: l'indice per la vite corrente in corso di regolazione.
- `accepted_screws`: il numero di viti accettate.

## configfile

Le seguenti informazioni sono disponibili nell'oggetto `configfile` (questo oggetto è sempre disponibile):

- `settings.<section>.<option>`: Restituisce l'impostazione del file di configurazione data (o il valore predefinito) durante l'ultimo avvio o riavvio del software. (Qualsiasi impostazione modificata in fase di esecuzione non si rifletterà qui.)
- `config.<section>.<option>`: Restituisce l'impostazione del file di configurazione non elaborato come letta da Klipper durante l'ultimo avvio o riavvio del software. (Qualsiasi impostazione modificata in fase di esecuzione non si rifletterà qui.) Tutti i valori vengono restituiti come stringhe.
- `save_config_pending`: Restituisce vero se ci sono aggiornamenti che un comando `SAVE_CONFIG` potrebbe rendere persistenti sul disco.
- `save_config_pending_items`: contiene le sezioni e le opzioni che sono state modificate e sarebbero mantenute da un `SAVE_CONFIG`.
- `warnings`: un elenco di avvisi sulle opzioni di configurazione. Ogni voce nell'elenco sarà un dizionario contenente un campo `type` e `message` (entrambe le stringhe). Ulteriori campi potrebbero essere disponibili a seconda del tipo di avviso.

## display_status

Le seguenti informazioni sono disponibili nell'oggetto `display_status` (questo oggetto è automaticamente disponibile se è definita una sezione di configurazione [display](Config_Reference.md#display)):

- `progress`: il valore di avanzamento dell'ultimo comando G-Code `M73` (o `virtual_sdcard.progress` se non è stato ricevuto alcun `M73` recente).
- `message`: il messaggio contenuto nell'ultimo comando G-Code `M117`.

## endstop_phase

Le seguenti informazioni sono disponibili nell'oggetto [endstop_phase](Config_Reference.md#endstop_phase):

- `last_home.<nome stepper>.phase`: La fase del motore passo-passo al termine dell'ultimo tentativo di home.
- `last_home.<stepper name>.phases`: il numero totale di fasi disponibili sul motore passo-passo.
- `last_home.<stepper name>.mcu_position`: la posizione (tracciata dal microcontrollore) del motore passo-passo alla fine dell'ultimo tentativo di home. La posizione è il numero totale di passi effettuati in avanti meno il numero totale di passi effettuati in senso inverso dall'ultimo riavvio del microcontrollore.

## exclude_object

Le seguenti informazioni sono disponibili nell'oggetto [exclude_object](Exclude_Object.md):


   - `objects`: un array di oggetti conosciuti come fornito dal comando `EXCLUDE_OBJECT_DEFINE`. Queste sono le stesse informazioni fornite dal comando `EXCLUDE_OBJECT VERBOSE=1`. I campi `center` e `polygon` saranno presenti solo se forniti nell'originale `EXCLUDE_OBJECT_DEFINE`Ecco un esempio JSON:

```
[
  {
    "polygon": [
      [ 156.25, 146.2511675 ],
      [ 156.25, 153.7488325 ],
      [ 163.75, 153.7488325 ],
      [ 163.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_2_COPY_0",
    "center": [ 160, 150 ]
  },
  {
    "polygon": [
      [ 146.25, 146.2511675 ],
      [ 146.25, 153.7488325 ],
      [ 153.75, 153.7488325 ],
      [ 153.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_1_COPY_0",
    "center": [ 150, 150 ]
  }
]
```

- `excluded_objects`: un array di stringhe che elenca i nomi degli oggetti esclusi.
- `current_object`: il nome dell'oggetto attualmente in fase di stampa.

## fan

Le seguenti informazioni sono disponibili negli oggetti [fan](Config_Reference.md#fan), [heater_fan some_name](Config_Reference.md#heater_fan) e [controller_fan some_name](Config_Reference.md#controller_fan):

- `speed`: La velocità della ventola come float tra 0.0 e 1.0.
- `rpm`: la velocità della ventola misurata in rotazioni al minuto se la ventola ha un pin tachimetro definito.

## filament_switch_sensor

Le seguenti informazioni sono disponibili negli oggetti [filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor):

- `enabled`: Restituisce True se il sensore interruttore è attualmente abilitato.
- `filament_detected`: restituisce True se il sensore è in uno stato attivato.

## filament_motion_sensor

Le seguenti informazioni sono disponibili negli oggetti [filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor):

- `abilitato`: Restituisce True se il sensore di movimento è attualmente abilitato.
- `filament_detected`: restituisce True se il sensore è in uno stato attivato.

## firmware_retraction

Le seguenti informazioni sono disponibili nell'oggetto [firmware_retraction](Config_Reference.md#firmware_retraction):

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`: le impostazioni correnti per il modulo firmware_retraction. Queste impostazioni possono differire dal file di configurazione se un comando `SET_RETRACTION` le altera.

## gcode_macro

Le seguenti informazioni sono disponibili negli oggetti [gcode_macro some_name](Config_Reference.md#gcode_macro):

- `<variabile>`: il valore corrente di una [variabile gcode_macro](Command_Templates.md#variables).

## gcode_move

Le seguenti informazioni sono disponibili nell'oggetto `gcode_move` (questo oggetto è sempre disponibile):

- `gcode_position`: la posizione corrente della testa di stampa rispetto all'origine del Gcode corrente. Cioè, posizioni che si potrebbero inviare direttamente a un comando `G1`. È possibile accedere ai componenti x, y, z ed e di questa posizione (ad esempio, `gcode_position.x`).
- `position`: l'ultima posizione comandata della testina utilizzando il sistema di coordinate specificato nel file di configurazione. È possibile accedere alle componenti x, y, z ed e di questa posizione (ad esempio, `position.x`).
- `homing_origin`: l'origine del sistema di coordinate gcode (relativo al sistema di coordinate specificato nel file di configurazione) da utilizzare dopo un comando `G28`. Il comando `SET_GCODE_OFFSET` può alterare questa posizione. È possibile accedere ai componenti x, y e z di questa posizione (ad esempio, `homing_origin.x`).
- `speed`: l'ultima velocità impostata in un comando `G1` (in mm/s).
- `speed_factor`: La"speed factor override" come impostato da un comando `M220`. Questo è un valore in virgola mobile tale che 1,0 significa nessun override e, ad esempio, 2,0 raddoppierebbe la velocità richiesta.
- `extrude_factor`: L'"extrude factor override" come impostato da un comando `M221`. Questo è un valore in virgola mobile tale che 1,0 significa nessun override ad esempio 2,0 raddoppierebbe le estrusioni richieste.
- `absolute_coordinates`: restituisce True se in modalità coordinate assolute `G90` o False se in modalità relativa `G91`.
- `absolute_extrude`: restituisce True se in modalità di estrusione assoluta `M82` o False se in modalità relativa `M83`.

## hall_filament_width_sensor

Le seguenti informazioni sono disponibili nell'oggetto [hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor):

- `is_active`: Restituisce True se il sensore è attualmente attivo.
- `Diameter`: l'ultima lettura dal sensore in mm.
- `Raw`: l'ultima lettura grezza dell'ADC dal sensore.

## Riscaldatore

Le seguenti informazioni sono disponibili per oggetti riscaldatore come [extruder](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed) e [heater_generic](Config_Reference.md#heater_generic):

- `temperature`: l'ultima temperatura riportata (in gradi Celsius come float) per il dato riscaldatore.
- `target`: la temperatura target attuale (in gradi Celsius come float) per il riscaldatore dato.
- `power`: l'ultima impostazione del pin PWM (un valore compreso tra 0.0 e 1.0) associato al riscaldatore.
- `can_extrude`: Se l'estrusore può estrudere (definito da `min_extrude_temp`), disponibile solo per [extruder](Config_Reference.md#extruder)

## Riscaldatori

Le seguenti informazioni sono disponibili nell'oggetto `heaters` (questo oggetto è disponibile se è definito un riscaldatore):

- `disponibili_riscaldatori`: restituisce un elenco di tutti i riscaldatori attualmente disponibili in base ai nomi completi delle sezioni di configurazione, ad es. `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `available_sensors`: restituisce un elenco di tutti i riscaldatori attualmente disponibili in base ai nomi completi delle sezioni di configurazione, ad es. `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.

## idle_timeout

Le seguenti informazioni sono disponibili nell'oggetto [idle_timeout](Config_Reference.md#idle_timeout) (questo oggetto è sempre disponibile):

- `state`: lo stato corrente della stampante monitorato dal modulo idle_timeout. È una delle seguenti stringhe: "Idle", "Printing", "Ready".
- `printing_time`: la quantità di tempo (in secondi) in cui la stampante è rimasta nello stato "Printing" (come tracciato dal modulo idle_timeout).

## led

Le seguenti informazioni sono disponibili per ogni sezione di configurazione `[led led_name]`, `[neopixel led_name]`, `[dotstar led_name]`, `[pca9533 led_name]` e `[pca9632 led_name]` definita in printer.cfg:

- `color_data`: un elenco di lista di colori contenenti i valori RGBW per ogni led nella catena. Ogni valore è rappresentato come un float da 0,0 a 1,0. Ciascuna lista di colori contiene 4 voci (rosso, verde, blu, bianco) anche se il LED sottostante supporta meno canali di colore. Ad esempio, è possibile accedere al valore blu (3° elemento nell'elenco dei colori) del secondo neopixel in una catena in `printer["neopixel <config_name>"].color_data[1][2]`.

## manual_probe

Le seguenti informazioni sono disponibili nell'oggetto `manual_probe`:

- `is_active`: Restituisce True se è attualmente attivo uno script di supporto per il rilevamento manuale.
- `z_position`: l'altezza corrente dell'ugello (come la sta attualmente interpretando la stampante).
- `z_position_lower`: ultimo tentativo di sonda appena inferiore all'altezza corrente.
- `z_position_upper`: ultimo tentativo di sonda appena maggiore dell'altezza corrente.

## mcu

Le seguenti informazioni sono disponibili negli oggetti [mcu](Config_Reference.md#mcu) e [mcu some_name](Config_Reference.md#mcu-my_extra_mcu):

- `mcu_version`: la versione del codice Klipper riportata dal microcontrollore.
- `mcu_build_versions`: informazioni sugli strumenti di compilazione utilizzati per generare il codice del microcontrollore (come riportato dal microcontrollore).
- `mcu_constants.<constant_name>`: Elenca le costanti di tempo riportate dal microcontrollore. Le costanti disponibili possono differire tra le architetture del microcontrollore e con ogni revisione del codice.
- `last_stats.<statistics_name>`: informazioni statistiche sulla connessione del microcontrollore.

## motion_report

Le seguenti informazioni sono disponibili nell'oggetto `motion_report` (questo oggetto è automaticamente disponibile se è definita una sezione di configurazione stepper):

- `live_position`: la posizione richiesta della testa di stampa interpolata all'ora corrente.
- `live_velocity`: la velocità della testa di stampa richiesta (in mm/s) al momento attuale.
- `live_extruder_velocity`: la velocità dell'estrusore richiesta (in mm/s) al momento attuale.

## output_pin

Le seguenti informazioni sono disponibili negli oggetti [output_pin some_name](Config_Reference.md#output_pin):

- `value`: Il "valore" del pin, come impostato da un comando `SET_PIN`.

## palette2

Le seguenti informazioni sono disponibili nell'oggetto [palette2](Config_Reference.md#palette2):

- `ping`: Valore dell'ultimo ping di Palette 2 riportato in percentuale.
- `remaining_load_length`: Quando si avvia una stampa della Palette 2, questa sarà la quantità di filamento da caricare nell'estrusore.
- `is_splicing`: Vero quando la Palette 2 sta giuntando il filamento.

## pause_resume

Le seguenti informazioni sono disponibili nell'oggetto [pause_resume](Config_Reference.md#pause_resume):

- `is_paused`: Restituisce vero se un comando PAUSE è stato eseguito senza un corrispondente RESUME.

## print_stats

Le seguenti informazioni sono disponibili nell'oggetto `print_stats` (questo oggetto è automaticamente disponibile se è definita una sezione di configurazione [virtual_sdcard](Config_Reference.md#virtual_sdcard)):

- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message`: informazioni stimate sulla stampa corrente quando è attiva una stampa da virtual_sdcard.

## probe

Le seguenti informazioni sono disponibili nell'oggetto [probe](Config_Reference.md#probe) (questo oggetto è disponibile anche se è definita una sezione di configurazione [bltouch](Config_Reference.md#bltouch)):

- `last_query`: Restituisce True se il probe è stato segnalato come "attivato" durante l'ultimo comando QUERY_PROBE. Nota, se questo viene utilizzato in una macro, a causa dell'ordine di espansione del modello, il comando QUERY_PROBE deve essere eseguito prima della macro contenente questo riferimento.
- `last_z_result`: Restituisce il valore del risultato Z dell'ultimo comando PROBE. Nota, se questo viene utilizzato in una macro, a causa dell'ordine di espansione del modello, il comando PROBE (o simile) deve essere eseguito prima della macro contenente questo riferimento.

## quad_gantry_level

Le seguenti informazioni sono disponibili nell'oggetto `quad_gantry_level` (questo oggetto è disponibile se quad_gantry_level è definito):

- `applied`: Vero se il processo di livellamento del gantry è stato eseguito e completato con successo.

## query_endstops

Le seguenti informazioni sono disponibili nell'oggetto `query_endstops` (questo oggetto è disponibile se è definito un finecorsa):

- `last_query["<endstop>"]`: Restituisce True se l'endstop specificato è stato segnalato come "attivato-triggered" durante l'ultimo comando QUERY_ENDSTOP. Nota, se questo viene utilizzato in una macro, a causa dell'ordine di espansione del modello, il comando QUERY_ENDSTOP deve essere eseguito prima della macro contenente questo riferimento.

## servo

Le seguenti informazioni sono disponibili negli oggetti [servo some_name](Config_Reference.md#servo):

- `printer["servo <config_name>"].value`: l'ultima impostazione del pin PWM (un valore compreso tra 0.0 e 1.0) associata al servo.

## system_stats

Le seguenti informazioni sono disponibili nell'oggetto `system_stats` (questo oggetto è sempre disponibile):

- `sysload`, `cputime`, `memavail`: informazioni sul sistema operativo del host e sul carico del processo.

## sensori di temperatura

Le seguenti informazioni sono disponibili in

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor) e [temperature_host config_section_name ](Config_Reference.md#host-temperature-sensor):

- `temperature`: l'ultima temperatura letta dal sensore.
- `humidity`, `pressure`, `gas`: gli ultimi valori letti dal sensore (solo sui sensori bme280, htu21d e lm75).

## temperature_fan

Le seguenti informazioni sono disponibili negli oggetti [temperature_fan some_name](Config_Reference.md#temperature_fan):

- `temperature`: l'ultima temperatura letta dal sensore.
- `target`: La temperatura target per la ventola.

## temperature_sensor

Le seguenti informazioni sono disponibili negli oggetti [temperature_sensor some_nome](Config_Reference.md#sensore_temperatura):

- `temperature`: l'ultima temperatura letta dal sensore.
- `measured_min_temp`, `measured_max_temp`: la temperatura più bassa e più alta vista dal sensore dall'ultimo riavvio del software host Klipper.

## driver tmc

Le seguenti informazioni sono disponibili negli oggetti [TMC stepper driver](Config_Reference.md#tmc-stepper-driver-configuration) (ad esempio, `[tmc2208 stepper_x]`):

- `mcu_phase_offset`: La posizione dello stepper del microcontrollore corrispondente alla fase "zero" del driver. Questo campo può essere nullo se l'offset di fase non è noto.
- `phase_offset_position`: La "posizione comandata" corrispondente alla fase "zero" del driver. Questo campo può essere nullo se l'offset di fase non è noto.
- `drv_status`: i risultati dell'ultima query sullo stato del driver. (Sono riportati solo i campi diversi da zero.) Questo campo sarà nullo se il driver non è abilitato (e quindi non viene interrogato periodicamente).
- `run_current`: La corrente di esecuzione attualmente impostata.
- `hold_current`: La corrente di mantenimento attualmente impostata.

## toolhead

The following information is available in the `toolhead` object (this object is always available):

- `position`: The last commanded position of the toolhead relative to the coordinate system specified in the config file. It is possible to access the x, y, z, and e components of this position (eg, `position.x`).
- `extruder`: il nome dell'estrusore attualmente attivo. Ad esempio, in una macro si potrebbe usare `printer[printer.toolhead.extruder].target` per ottenere la temperatura target dell'estrusore corrente.
- `homed_axes`: Gli assi cartesiani correnti considerati in uno stato "homed". Questa è una stringa contenente uno o più di "x", "y", "z".
- `axis_minimum`, `axis_maximum`: i limiti di corsa dell'asse (mm) dopo la corsa di homing. È possibile accedere alle componenti x, y, z di questo valore limite (ad es. `axis_minimum.x`, `axis_minimum.z`).
- `max_velocity`, `max_accel`, `max_accel_to_decel`, `square_corner_velocity`: gli attuali limiti di stampa in vigore. Questo può differire dalle impostazioni del file di configurazione se un comando `SET_VELOCITY_LIMIT` (o `M204`) le altera in fase di esecuzione.
- `stalls`: il numero totale di volte (dall'ultimo riavvio) che la stampante ha dovuto essere messa in pausa perché la testina si muoveva più velocemente di quanto fosse possibile leggere i movimenti dall'input del G-code.

## dual_carriage

Le seguenti informazioni sono disponibili in [dual_carriage](Config_Reference.md#dual_carriage) su una macchina hybrid_corexy o hybrid_corexz

- `mode`: la modalità corrente. I valori possibili sono: "FULL_CONTROL"
- `active_carriage`: il carrello attivo corrente. I valori possibili sono: "CARRIAGE_0", "CARRIAGE_1"

## virtual_sdcard

Le seguenti informazioni sono disponibili nell'oggetto [virtual_sdcard](Config_Reference.md#virtual_sdcard):

- `is_active`: Restituisce True se una stampa da file è attualmente attiva.
- `progress`: una stima dello stato di avanzamento della stampa corrente (in base alla dimensione del file e alla posizione del file).
- `file_path`: un percorso completo del file per il file attualmente caricato.
- `file_position`: la posizione corrente (in byte) di una stampa attiva.
- `file_size`: la dimensione (in byte) del file attualmente caricato.

## webhooks

Le seguenti informazioni sono disponibili nell'oggetto `webhooks` (questo oggetto è sempre disponibile):

- `state`: restituisce una stringa che indica lo stato corrente di Klipper. I valori possibili sono: "ready", "startup", "shutdown", "error".
- `state_message`: una stringa leggibile dall'uomo che fornisce un contesto aggiuntivo sullo stato corrente di Klipper.

## z_tilt

Le seguenti informazioni sono disponibili nell'oggetto `z_tilt` (questo oggetto è disponibile se z_tilt è definito):

- `applied`: Vero se il processo di livellamento z-tilt è stato eseguito e completato con successo.
