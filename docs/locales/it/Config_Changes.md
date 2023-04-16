# Modifiche alla configurazione

Questo documento copre le modifiche software recenti al file di configurazione che non sono compatibili con le versioni precedenti. È una buona idea rivedere questo documento durante l'aggiornamento del software Klipper.

Tutte le date in questo documento sono approssimative.

## Cambiamenti

20230304: The `SET_TMC_CURRENT` command now properly adjusts the globalscaler register for drivers that have it. This removes a limitation where on tmc5160, the currents could not be raised higher with `SET_TMC_CURRENT` than the `run_current` value set in the config file. However, this has a side effect: After running `SET_TMC_CURRENT`, the stepper must be held at standstill for >130ms in case StealthChop2 is used so that the AT#1 calibration gets executed by the driver.

20230202: The format of the `printer.screws_tilt_adjust` status information has changed. The information is now stored as a dictionary of screws with the resulting measurements. See the [status reference](Status_Reference.md#screws_tilt_adjust) for details.

20230201: Il modulo `[bed_mesh]` non carica più il profilo `default` all'avvio. Si consiglia agli utenti che usano il profilo `default` di aggiungere `BED_MESH_PROFILE LOAD=default` alla loro macro `START_PRINT` (o alla configurazione "Start G-Code" del loro slicer quando applicabile).

20230103: Ora è possibile con lo script flash-sdcard.sh eseguire il flashing di entrambe le varianti di Bigtreetech SKR-2, STM32F407 e STM32F429. Ciò significa che il tag originale di btt-skr2 ora è cambiato in btt-skr-2-f407 o btt-skr-2-f429.

20221128: rilascio di Klipper v0.11.0.

20221122: In precedenza, con safe_z_home, era possibile che z_hop dopo l'homing g28 andasse nella direzione z negativa. Ora, uno z_hop viene eseguito dopo g28 solo se risulta in un hop positivo, rispecchiando il comportamento dello z_hop che si verifica prima dell'homing g28.

20220616: in precedenza era possibile eseguire il flashing di un rp2040 in modalità bootloader eseguendo `make flash FLASH_DEVICE=first`. Il comando equivalente è ora `make flash FLASH_DEVICE=2e8a:0003`.

20220612: Il microcontrollore rp2040 ora ha una soluzione alternativa per l'errata USB "rp2040-e5". Ciò dovrebbe rendere più affidabili le connessioni USB iniziali. Tuttavia, potrebbe comportare un cambiamento nel comportamento del pin gpio15. È improbabile che il cambiamento di comportamento di gpio15 sia evidente.

20220407: l'opzione di configurazione temperature_fan `pid_integral_max` è stata rimossa (era deprecata su 20210612).

20220407: L'ordine dei colori predefinito per i LED pca9632 è ora "RGBW". Aggiungi un'impostazione esplicita `color_order: RBGW` alla sezione di configurazione di pca9632 per ottenere il comportamento precedente.

20220330: Il formato delle informazioni di stato `printer.neopixel.color_data` per i moduli neopixel e dotstar è cambiato. Le informazioni sono ora memorizzate come un elenco di elenchi di colori (invece di un elenco di dizionari). Per i dettagli, vedere il [riferimento dello stato](Status_Reference.md#led).

20220307: `M73` non imposterà più l'avanzamento della stampa su 0 se manca `P`.

20220304: Non esiste più un valore predefinito per il parametro `extruder` delle sezioni di configurazione [extruder_stepper](Config_Reference.md#extruder_stepper). Se lo si desidera, specificare esplicitamente `extruder: extruder` per associare il motore passo-passo alla coda di movimento "estrusore" all'avvio.

20220210: Il comando `SYNC_STEPPER_TO_EXTRUDER` è deprecato; il comando `SET_EXTRUDER_STEP_DISTANCE` è deprecato; l'opzione di configurazione [extruder](Config_Reference.md#extruder) `shared_heater` è deprecata. Queste funzionalità verranno rimosse nel prossimo futuro. Sostituisci `SET_EXTRUDER_STEP_DISTANCE` con `SET_EXTRUDER_ROTATION_DISTANCE`. Sostituisci `SYNC_STEPPER_TO_EXTRUDER` con `SYNC_EXTRUDER_MOTION`. Sostituisci le sezioni di configurazione dell'estrusore usando `shared_heater` con le sezioni di configurazione [extruder_stepper](Config_Reference.md#extruder_stepper) e aggiorna le macro di attivazione per usare [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion).

20220116: Il codice di calcolo della `run_current` per tmc2130, tmc2208, tmc2209 e tmc2660 è cambiato. Per alcune impostazioni di `run_current` i driver possono ora essere configurati in modo diverso. Questa nuova configurazione dovrebbe essere più accurata, ma potrebbe invalidare la precedente ottimizzazione del driver tmc.

20211230: Gli script per ottimizzare l'input shaper (`scripts/calibrate_shaper.py` e `scripts/graph_accelerometer.py`) sono stati migrati per utilizzare Python3 per impostazione predefinita. Di conseguenza, gli utenti devono installare le versioni Python3 di determinati pacchetti (ad esempio `sudo apt install python3-numpy python3-matplotlib`) per continuare a utilizzare questi script. Per maggiori dettagli, fare riferimento a [Installazione del software](Measuring_Resonances.md#software-installation). In alternativa, gli utenti possono forzare temporaneamente l'esecuzione di questi script in Python 2 chiamando esplicitamente l'interprete Python2 nella console: `python2 ~/klipper/scripts/calibrate_shaper.py ...`

20211110: Il sensore di temperatura "NTC 100K beta 3950" è obsoleto. Questo sensore verrà rimosso nel prossimo futuro. La maggior parte degli utenti troverà il sensore di temperatura "Generico 3950" più accurato. Per continuare a utilizzare la definizione precedente (in genere meno accurata), definire un [termistore](Config_Reference.md#thermistor) personalizzato con `temperature1: 25`, `resistance1: 100000` e `beta: 3950`.

20211104: L'opzione "step pulse duration" in "make menuconfig" è stata rimossa. La durata del passaggio predefinita per i driver TMC configurati in modalità UART o SPI è ora di 100 ns. Una nuova impostazione `step_pulse_duration` nella [sezione stepper config](Config_Reference.md#stepper) dovrebbe essere impostata per tutti gli stepper che necessitano di una durata dell'impulso personalizzata.

20211102: diverse funzionalità deprecate sono state rimosse. L'opzione stepper `step_distance` è stata rimossa (obsoleta nel 20201222). L'alias del sensore `rpi_temperature` è stato rimosso (obsoleto il 20210219). L'opzione mcu `pin_map` è stata rimossa (deprecata su 20210325). La gcode_macro `default_parameter_<name>` e l'accesso macro ai parametri dei comandi diversi dalla pseudo-variabile `params` sono stati rimossi (deprecato in 20210503). L'opzione del riscaldatore `pid_integral_max` è stata rimossa (obsoleta il 20210612).

20210929: Klipper v0.10.0 rilasciato.

20210903: Il valore predefinito [`smooth_time`](Config_Reference.md#extruder) per i riscaldatori è cambiato in 1 secondo (da 2 secondi). Per la maggior parte delle stampanti ciò si tradurrà in un controllo della temperatura più stabile.

20210830: il nome adxl345 predefinito è ora "adxl345". Il parametro CHIP predefinito per `ACCELEROMETER_MEASURE` e `ACCELEROMETER_QUERY` ora è "adxl345".

20210830: il comando adxl345 ACCELEROMETER_MEASURE non supporta più un parametro RATE. Per modificare la frequenza delle query, aggiornare il file printer.cfg ed eseguire un comando RESTART.

20210821: Diverse impostazioni di configurazione in `printer.configfile.settings` verranno ora riportate come elenchi anziché come stringhe grezze. Se si desidera la stringa grezza effettiva, utilizzare invece `printer.configfile.config`.

20210819: In alcuni casi, un movimento di riferimento `G28` può terminare in una posizione che è nominalmente al di fuori dell'intervallo di movimento valido. In rare situazioni ciò può causare errori di "spostamento fuori portata" confusi dopo l'homing. In tal caso, modificare gli script di avvio per spostare la testa utensile in una posizione valida subito dopo l'homing.

20210814: Gli pseudo-pin solo analogici su atmega168 e atmega328 sono stati rinominati da PE0/PE1 a PE2/PE3.

20210720: una sezione controller_fan ora monitora tutti i motori passo-passo per impostazione predefinita (non solo i motori passo-passo cinematici). Se si desidera il comportamento precedente, vedere l'opzione di configurazione `stepper` nel [riferimento di configurazione](Config_Reference.md#controller_fan).

20210703: Una sezione di configurazione `samd_sercom` deve ora specificare il bus sercom che sta configurando tramite l'opzione `sercom`.

20210612: L'opzione di configurazione `pid_integral_max` nelle sezioni riscaldatore e temperature_fan è obsoleta. L'opzione verrà rimossa nel prossimo futuro.

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430: il comando SET_VELOCITY_LIMIT (e M204) ora può impostare una velocità, un'accelerazione e una square_corner_velocity maggiori dei valori specificati nel file di configurazione.

20210325: il supporto per l'opzione di configurazione `pin_map` è deprecato. Utilizzare il file [sample-aliases.cfg](../config/sample-aliases.cfg) per tradurre i nomi dei pin del microcontroller effettivi. L'opzione di configurazione `pin_map` verrà rimossa nel prossimo futuro.

20210313: Il supporto di Klipper per i microcontrollori che comunicano con il bus CAN è cambiato. Se si utilizza il bus CAN, è necessario eseguire nuovamente il flashing di tutti i microcontrollori e la [configurazione di Klipper deve essere aggiornata](CANBUS.md).

20210310: Il valore predefinito TMC2660 per driver_SFILT è stato modificato da 1 a 0.

20210227: I driver del motore passo-passo TMC in modalità UART o SPI ora vengono interrogati una volta al secondo ogni volta che sono abilitati - se il driver non può essere contattato o se il driver segnala un errore, Klipper passerà allo stato di spegnimento.

20210219: Il modulo `rpi_temperature` è stato rinominato in `temperature_host`. Sostituisci tutte le occorrenze di `sensor_type: rpi_temperature` con `sensor_type: temperature_host`. Il percorso del file di temperatura può essere specificato nella variabile di configurazione `sensor_path`. Il nome `rpi_temperature` è deprecato e verrà rimosso nel prossimo futuro.

20210201: Il comando `TEST_RESONANCES` ora disabiliterà l'input shaping se era stato precedentemente abilitato (e lo riattiverà dopo il test). Per ignorare questo comportamento e mantenere abilitato lo shaping dell'input, è possibile passare un parametro aggiuntivo `INPUT_SHAPING=1` al comando.

20210201: Il comando `ACCELEROMETER_MEASURE` aggiungerà ora il nome del chip dell'accelerometro al nome del file di output se al chip è stato assegnato un nome nella corrispondente sezione adxl345 di printer.cfg.

20201222: L'impostazione `step_distance` nelle sezioni di configurazione dello stepper è obsoleta. Si consiglia di aggiornare la configurazione per utilizzare l'impostazione [`rotation_distance`](Rotation_Distance.md). Il supporto per `step_distance` verrà rimosso nel prossimo futuro.

20201218: L'impostazione `endstop_phase` nel modulo endstop_phase è stata sostituita con `trigger_phase`. Se si utilizza il modulo fasi endstop, sarà necessario convertire in [`rotation_distance`](Rotation_Distance.md) e ricalibrare eventuali fasi endstop eseguendo il comando ENDSTOP_PHASE_CALIBRATE.

20201218: le stampanti rotanti delta e polari ora devono specificare un `gear_ratio` per i loro stepper rotanti e potrebbero non specificare più un parametro `step_distance`. Vedere il [riferimento di configurazione](Config_Reference.md#stepper) per il formato del nuovo parametro gear_ratio.

20201213: Non è valido specificare una Z "position_endstop" quando si utilizza "probe:z_virtual_endstop". Verrà ora generato un errore se viene specificata una Z "position_endstop" con "probe:z_virtual_endstop". Rimuovere la definizione Z "position_endstop" per correggere l'errore.

20201120: La sezione di configurazione `[board_pins]` ora specifica il nome mcu in un parametro esplicito `mcu:`. Se si utilizza board_pins per un mcu secondario, è necessario aggiornare la configurazione per specificare quel nome. Vedere il [riferimento di configurazione](Config_Reference.md#board_pins) per ulteriori dettagli.

20201112: Il tempo riportato da `print_stats.print_duration` è cambiato. La durata precedente alla prima estrusione rilevata è ora esclusa.

20201029: L'opzione di configurazione `color_order_GRB` di neopixel è stata rimossa. Se necessario, aggiorna la configurazione per impostare la nuova opzione `color_order` su RGB, GRB, RGBW o GRBW.

20201029: L'opzione seriale nella sezione di configurazione di mcu non è più impostata su /dev/ttyS0. Nella rara situazione in cui /dev/ttyS0 è la porta seriale desiderata, deve essere specificata esplicitamente.

20201020: Klipper v0.9.0 rilasciato.

20200902: Il calcolo della resistenza-to-temperatura dell'RTD per i convertitori MAX31865 è stato corretto in modo che non fosse basso. Se si utilizza un dispositivo di questo tipo, è necessario ricalibrare la temperatura di stampa e le impostazioni PID.

20200816: L'oggetto `printer.gcode` della macro gcode è stato rinominato in `printer.gcode_move`. Diverse variabili non documentate in `printer.toolhead` e `printer.gcode` sono state rimosse. Vedere docs/Command_Templates.md per un elenco delle variabili di modello disponibili.

20200816: Il sistema "action_" della macro gcode è cambiato. Sostituisci tutte le chiamate a `printer.gcode.action_emergency_stop()` con `action_emergency_stop()`, `printer.gcode.action_respond_info()` con `action_respond_info()` e `printer.gcode.action_respond_error()` con `action_raise_error( )`.

20200809: Il sistema di menu è stato riscritto. Se il menu è stato personalizzato sarà necessario aggiornare alla nuova configurazione. Vedere config/example-menu.cfg per i dettagli di configurazione e vedere klippy/extras/display/menu.cfg per esempi.

20200731: Il comportamento dell'attributo `progress` riportato dall'oggetto stampante `virtual_sdcard` è cambiato. L'avanzamento non viene più reimpostato su 0 quando una stampa viene sospesa. Ora riporterà sempre lo stato di avanzamento in base alla posizione interna del file o 0 se nessun file è attualmente caricato.

20200725: Il parametro di configurazione servo `enable` e il parametro SET_SERVO `ENABLE` sono stati rimossi. Aggiorna qualsiasi macro per usare `SET_SERVO SERVO=my_servo WIDTH=0` per disabilitare un servo.

20200608: Il supporto del display LCD ha cambiato il nome di alcuni "glifi" interni. Se è stato implementato un layout di visualizzazione personalizzato, potrebbe essere necessario aggiornare ai nomi dei glifi più recenti (consultare klippy/extras/display/display.cfg per un elenco dei glifi disponibili).

20200606: i nomi dei pin su Linux Mcu sono cambiati. I pin ora hanno nomi nella forma `gpiochip<chipid>/gpio<gpio>`. Per gpiochip0 puoi anche usare un breve `gpio<gpio>`. Ad esempio, ciò che prima veniva chiamato `P20` ora diventa `gpio20` o `gpiochip0/gpio20`.

20200603: il layout LCD 16x4 predefinito non mostrerà più il tempo rimanente stimato in una stampa. (Verrà mostrato solo il tempo trascorso.) Se si desidera il vecchio comportamento, è possibile personalizzare la visualizzazione del menu con tali informazioni (vedere la descrizione di display_data in config/example-extras.cfg per i dettagli).

20200531: l'ID prodotto/fornitore USB predefinito è ora 0x1d50/0x614e. Questi nuovi ID sono riservati a Klipper (grazie al progetto openmoko). Questa modifica non dovrebbe richiedere alcuna modifica alla configurazione, ma i nuovi ID potrebbero essere visualizzati nei registri di sistema.

20200524: Il valore predefinito per il campo tmc5160 pwm_freq è ora zero (anziché uno).

20200425: La variabile del modello di comando gcode_macro `printer.heater` è stata rinominata `printer.heaters`.

20200313: Il layout lcd predefinito per le stampanti multiestrusore con schermo 16x4 è cambiato. Il layout dello schermo del singolo estrusore è ora quello predefinito e mostrerà l'estrusore attualmente attivo. Per utilizzare il layout di visualizzazione precedente, impostare "display_group: _multiextruder_16x4" nella sezione [display] del file printer.cfg.

20200308: La voce di menu predefinita `__test` è stata rimossa. Se il file di configurazione ha un menu personalizzato, assicurati di rimuovere tutti i riferimenti a questa voce di menu `__test`.

20200308: le opzioni del menu "deck" e "card" sono state rimosse. Per personalizzare il layout di uno schermo lcd utilizzare le nuove sezioni display_data config (vedi config/example-extras.cfg per i dettagli).

20200109: Il modulo bed_mesh ora fa riferimento alla posizione della sonda per la configurazione della mesh. Pertanto, alcune opzioni di configurazione sono state rinominate per riflettere in modo più accurato la funzionalità prevista. Per i piatti rettangolari, `min_point` e `max_point` sono stati rinominati rispettivamente in `mesh_min` e `mesh_max`. Per i piatti rotondi, `bed_radius` è stato rinominato in `mesh_radius`. È stata aggiunta anche una nuova opzione `mesh_origin` per i piatti rotondi. Si noti che queste modifiche sono anche incompatibili con i profili mesh salvati in precedenza. Se viene rilevato un profilo incompatibile, verrà ignorato e pianificato per la rimozione. Il processo di rimozione può essere completato emettendo il comando SAVE_CONFIG. L'utente dovrà ricalibrare ogni profilo.

20191218: la sezione di configurazione del display non supporta più "lcd_type: st7567". Usa invece il tipo di visualizzazione "uc1701" - imposta "lcd_type: uc1701" e cambia "rs_pin: some_pin" in "rst_pin: some_pin". Potrebbe anche essere necessario aggiungere un'impostazione di configurazione "contrasto: 60".

20191210: I comandi integrati T0, T1, T2, ... sono stati rimossi. Le opzioni di configurazione activate_gcode e deactivate_gcode dell'estrusore sono state rimosse. Se questi comandi (e script) sono necessari, definire le singole macro di stile [gcode_macro T0] che chiamano il comando ACTIVATE_EXTRUDER. Vedere i file config/sample-idex.cfg e sample-multi-extruder.cfg per esempi.

20191210: il supporto per il comando M206 è stato rimosso. Sostituisci con chiamate a SET_GCODE_OFFSET. Se è necessario il supporto per M206, aggiungere una sezione di configurazione [gcode_macro M206] che richiami SET_GCODE_OFFSET. (Ad esempio "SET_GCODE_OFFSET Z=-{params.Z}".)

20191202: il supporto per il parametro "S" non documentato del comando "G4" è stato rimosso. Sostituire eventuali occorrenze di S con il parametro "P" standard (il ritardo specificato in millisecondi).

20191126: i nomi USB sono cambiati sui microcontrollori con supporto USB nativo. Ora usano un ID chip univoco per impostazione predefinita (ove disponibile). Se una sezione di configurazione "mcu" utilizza un'impostazione "serial" che inizia con "/dev/serial/by-id/", potrebbe essere necessario aggiornare la configurazione. Esegui "ls /dev/serial/by-id/*" in un terminale ssh per determinare il nuovo ID.

20191121: il parametro pressure_advance_lookahead_time è stato rimosso. Vedere example.cfg per impostazioni di configurazione alternative.

20191112: la funzionalità di abilitazione virtuale del driver stepper tmc è ora abilitata automaticamente se lo stepper non dispone di un pin di abilitazione stepper dedicato. Rimuovere i riferimenti a tmcXXXX:virtual_enable dal file config. La possibilità di controllare più pin nella configurazione stepper enable_pin è stata rimossa. Se sono necessari più pin, utilizzare una sezione di configurazione multi_pin.

20191107: La sezione di configurazione dell'estrusore primario deve essere specificata come "extruder" e non può più essere specificata come "extruder0". I modelli di comando Gcode che richiedono lo stato dell'estrusore sono ora accessibili tramite "{printer.extruder}".

20191021: Klipper v0.8.0 rilasciato

20191003: L'opzione move_to_previous in [safe_z_homing] ora è impostata su False. (Era effettivamente Falso prima del 20190918.)

20190918: L'opzione zhop in [safe_z_homing] viene sempre riapplicata dopo il completamento dell'homing dell'asse Z. Ciò potrebbe richiedere agli utenti di aggiornare gli script personalizzati basati su questo modulo.

20190806: Il comando SET_NEOPIXEL è stato rinominato in SET_LED.

20190726: il codice del dac mcp4728 è cambiato. L'indirizzo i2c predefinito è ora 0x60 e il riferimento di tensione è ora relativo al riferimento interno di 2,048 volt del mcp4728.

20190710: l'opzione z_hop è stata rimossa dalla sezione di configurazione [firmware_retract]. Il supporto z_hop era incompleto e potrebbe causare un comportamento errato con diversi filtri dei dati comuni.

20190710: I parametri opzionali del comando PROBE_ACCURACY sono stati modificati. Potrebbe essere necessario aggiornare eventuali macro o script che utilizzano quel comando.

20190628: tutte le opzioni di configurazione sono state rimosse dalla sezione [skew_correction]. La configurazione per skew_correction viene ora eseguita tramite il gcode SET_SKEW. Vedere [Correzione inclinazione](Correzione_inclinazione.md) per l'utilizzo consigliato.

20190607: I parametri "variable_X" di gcode_macro (insieme al parametro VALUE di SET_GCODE_VARIABLE) vengono ora analizzati come valori literals di Python. Se è necessario assegnare un valore a una stringa, racchiudere il valore tra virgolette in modo che venga valutato come una stringa.

20190606: le opzioni di configurazione "samples", "samples_result" e "sample_retract_dist" sono state spostate nella sezione di configurazione "probe". Queste opzioni non sono più supportate nelle sezioni di configurazione "delta_calibrate", "bed_tilt", "bed_mesh", "screws_tilt_adjust", "z_tilt" o "quad_gantry_level".

20190528: La variabile magica "status" nella valutazione del modello gcode_macro è stata rinominata "printer".

20190520: Il comando SET_GCODE_OFFSET è stato modificato; aggiorna tutte le macro del codice g di conseguenza. Il comando non applicherà più l'offset richiesto al successivo comando G1. Il vecchio comportamento può essere approssimato utilizzando il nuovo parametro "MOVE=1".

20190404: i pacchetti software host Python sono stati aggiornati. Gli utenti dovranno eseguire nuovamente lo script ~/klipper/scripts/install-octopi.sh (o in altro modo aggiornare le dipendenze di Python se non si utilizza un'installazione OctoPi standard).

20190404: I parametri i2c_bus e spi_bus (in varie sezioni di configurazione) ora prendono un nome bus anziché un numero.

20190404: I parametri di configurazione sx1509 sono stati modificati. Il parametro 'address' ora è 'i2c_address' e deve essere specificato come numero decimale. Dove 0x3E è stato utilizzato in precedenza, specificare 62.

20190328: Il valore min_speed nella configurazione [temperature_fan] verrà ora rispettato e la ventola funzionerà sempre a questa velocità o superiore in modalità PID.

20190322: il valore predefinito per "driver_HEND" nelle sezioni di configurazione [tmc2660] è stato modificato da 6 a 3. Il campo "driver_VSENSE" è stato rimosso (ora viene calcolato automaticamente da run_current).

20190310: La sezione di configurazione [controller_fan] ora prende sempre un nome (come [controller_fan my_controller_fan]).

20190308: Il campo "driver_BLANK_TIME_SELECT" nelle sezioni di configurazione [tmc2130] e [tmc2208] è stato rinominato in "driver_TBL".

20190308: la sezione di configurazione [tmc2660] è stata modificata. Ora deve essere fornito un nuovo parametro di configurazione sense_resistor. Il significato di molti dei parametri driver_XXX è cambiato.

20190228: gli utenti di SPI o I2C su schede SAMD21 devono ora specificare i pin del bus tramite una sezione di configurazione [samd_sercom].

20190224: l'opzione bed_shape è stata rimossa da bed_mesh. L'opzione raggio è stata rinominata bed_radius. Gli utenti con letti rotondi dovrebbero fornire le opzioni bed_radius e round_probe_count.

20190107: il parametro i2c_address nella sezione di configurazione mcp4451 è stato modificato. Questa è un'impostazione comune su Smoothieboards. Il nuovo valore è la metà del vecchio valore (88 dovrebbe essere cambiato in 44 e 90 dovrebbe essere cambiato in 45).

20181220: Klipper v0.7.0 rilasciato
