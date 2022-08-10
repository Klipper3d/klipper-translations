# TMC drivers

Questo documento fornisce informazioni sull'utilizzo dei driver Trinamic per motori stepper in modalità SPI/UART su Klipper.

Klipper può anche utilizzare i driver Trinamic nella loro "modalità standalone". Tuttavia, quando i driver sono in questa modalità, non è necessaria alcuna configurazione speciale di Klipper e le funzionalità avanzate di Klipper discusse in questo documento non sono disponibili.

Oltre a questo documento, assicurati di rivedere il [riferimento alla configurazione del driver TMC](Config_Reference.md#tmc-stepper-driver-configuration).

## Tuning motor current

A higher driver current increases positional accuracy and torque. However, a higher current also increases the heat produced by the stepper motor and the stepper motor driver. If the stepper motor driver gets too hot it will disable itself and Klipper will report an error. If the stepper motor gets too hot, it loses torque and positional accuracy. (If it gets very hot it may also melt plastic parts attached to it or near it.)

As a general tuning tip, prefer higher current values as long as the stepper motor does not get too hot and the stepper motor driver does not report warnings or errors. In general, it is okay for the stepper motor to feel warm, but it should not become so hot that it is painful to touch.

## Prefer to not specify a hold_current

If one configures a `hold_current` then the TMC driver can reduce current to the stepper motor when it detects that the stepper is not moving. However, changing motor current may itself introduce motor movement. This may occur due to "detent forces" within the stepper motor (the permanent magnet in the rotor pulls towards the iron teeth in the stator) or due to external forces on the axis carriage.

Most stepper motors will not obtain a significant benefit to reducing current during normal prints, because few printing moves will leave a stepper motor idle for sufficiently long to activate the `hold_current` feature. And, it is unlikely that one would want to introduce subtle print artifacts to the few printing moves that do leave a stepper idle sufficiently long.

If one wishes to reduce current to motors during print start routines, then consider issuing [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) commands in a [START_PRINT macro](Slicers.md#klipper-gcode_macro) to adjust the current before and after normal printing moves.

Some printers with dedicated Z motors that are idle during normal printing moves (no bed_mesh, no bed_tilt, no Z skew_correction, no "vase mode" prints, etc.) may find that Z motors do run cooler with a `hold_current`. If implementing this then be sure to take into account this type of uncommanded Z axis movement during bed leveling, bed probing, probe calibration, and similar. The `driver_TPOWERDOWN` and `driver_IHOLDDELAY` should also be calibrated accordingly. If unsure, prefer to not specify a `hold_current`.

## Setting "spreadCycle" vs "stealthChop" Mode

By default, Klipper places the TMC drivers in "spreadCycle" mode. If the driver supports "stealthChop" then it can be enabled by adding `stealthchop_threshold: 999999` to the TMC config section.

In general, spreadCycle mode provides greater torque and greater positional accuracy than stealthChop mode. However, stealthChop mode may produce significantly lower audible noise on some printers.

Tests comparing modes have shown an increased "positional lag" of around 75% of a full-step during constant velocity moves when using stealthChop mode (for example, on a printer with 40mm rotation_distance and 200 steps_per_rotation, position deviation of constant speed moves increased by ~0.150mm). However, this "delay in obtaining the requested position" may not manifest as a significant print defect and one may prefer the quieter behavior of stealthChop mode.

It is recommended to always use "spreadCycle" mode (by not specifying `stealthchop_threshold`) or to always use "stealthChop" mode (by setting `stealthchop_threshold` to 999999). Unfortunately, the drivers often produce poor and confusing results if the mode changes while the motor is at a non-zero velocity.

## TMC interpolate setting introduces small position deviation

The TMC driver `interpolate` setting may reduce the audible noise of printer movement at the cost of introducing a small systemic positional error. This systemic positional error results from the driver's delay in executing "steps" that Klipper sends it. During constant velocity moves, this delay results in a positional error of nearly half a configured microstep (more precisely, the error is half a microstep distance minus a 512th of a full step distance). For example, on an axis with a 40mm rotation_distance, 200 steps_per_rotation, and 16 microsteps, the systemic error introduced during constant velocity moves is ~0.006mm.

For best positional accuracy consider using spreadCycle mode and disable interpolation (set `interpolate: False` in the TMC driver config). When configured this way, one may increase the `microstep` setting to reduce audible noise during stepper movement. Typically, a microstep setting of `64` or `128` will have similar audible noise as interpolation, and do so without introducing a systemic positional error.

If using stealthChop mode then the positional inaccuracy from interpolation is small relative to the positional inaccuracy introduced from stealthChop mode. Therefore tuning interpolation is not considered useful when in stealthChop mode, and one can leave interpolation in its default state.

## Homing Sensorless

L'homing senza sensori consente di posizionare un asse senza la necessità di un finecorsa fisico. Invece, il carrello sull'asse viene spostato nel finecorsa meccanico facendo perdere passi al motore passo-passo. Il driver stepper rileva i passi persi e lo indica all'MCU di controllo (Klipper) attivando un pin. Queste informazioni possono essere utilizzate da Klipper come fine corsa per l'asse.

Questa guida illustra l'impostazione dell'homing sensorless per l'asse X della stampante (cartesiana). Tuttavia, funziona allo stesso modo con tutti gli altri assi (che richiedono un fine corsa). Dovresti configurarlo e sintonizzarlo per un asse alla volta.

### Limitazioni

Assicurati che i tuoi componenti meccanici siano in grado di sopportare il carico del carrello che urta ripetutamente il limite dell'asse. Soprattutto le viti di comando potrebbero generare molta forza. L'homing di un asse Z facendo urtare l'ugello sulla superficie di stampa potrebbe non essere una buona idea. Per ottenere i migliori risultati, verificare che il carrello dell'asse stabilisca un contatto stabile con il limite dell'asse.

Inoltre, l'homing sensorless potrebbe non essere sufficientemente preciso per la tua stampante. Sebbene l'homing degli assi X e Y su una macchina cartesiana possa funzionare bene, l'homing dell'asse Z in genere non è sufficientemente preciso e può comportare un'altezza del primo strato incoerente. L'homing di una stampante delta sensorless non è consigliabile a causa della mancanza di precisione.

Inoltre, il rilevamento dello stallo del driver passo-passo dipende dal carico meccanico sul motore, dalla corrente del motore e dalla temperatura del motore (resistenza della bobina).

L'homing sensorless funziona meglio a velocità medie del motore. Per velocità molto basse (inferiori a 10 giri/min) il motore non genera una significativa EMF di ritorno e il TMC non è in grado di rilevare in modo affidabile gli stalli del motore. Inoltre, a velocità molto elevate, l'EMF di ritorno del motore si avvicina alla tensione di alimentazione del motore, quindi il TMC non è più in grado di rilevare gli stalli. Si consiglia di dare un'occhiata alla scheda tecnica del proprio TMC specifico. Lì puoi anche trovare maggiori dettagli sulle limitazioni di questa configurazione.

### Prerequisiti

Sono necessari alcuni prerequisiti per utilizzare l'homing sensorless:

1. A stallGuard capable TMC stepper driver (tmc2130, tmc2209, tmc2660, or tmc5160).
1. Interfaccia SPI/UART del driver TMC cablata al microcontrollore (la modalità stand-alone non funziona).
1. Il pin "DIAG" o "SG_TST" appropriato del driver TMC collegato al microcontrollore.
1. I passaggi nel documento [config checks](Config_checks.md) devono essere eseguiti per confermare che i motori passo-passo siano configurati e funzionino correttamente.

### Messa a punto

La procedura qui descritta prevede sei passaggi principali:

1. Scegli una velocità di homing.
1. Configura il file `printer.cfg` per abilitare l'homing sensorless.
1. Trova l'impostazione stallguard con la massima sensibilità che funziona con successo.
1. Trova l'impostazione stallguard con la sensibilità più bassa che effettua homing con successo con un solo tocco.
1. Aggiorna il `printer.cfg` con l'impostazione di stallguard desiderata.
1. Crea o aggiorna le macro `printer.cfg` per homing in modo coerente.

#### Scegli la velocità di homing

La velocità di homing è una scelta importante quando si esegue l'homing senza sensori. È consigliabile utilizzare una velocità di riferimento bassa in modo che il carrello non eserciti una forza eccessiva sul telaio quando entra in contatto con l'estremità della rotaia. Tuttavia, i driver TMC non sono in grado di rilevare in modo affidabile uno stallo a velocità molto basse.

Un buon punto di partenza per la velocità di homing è che il motore passo-passo esegua una rotazione completa ogni due secondi. Per molti assi questa sarà la `rotation_distance` divisa per due. Per esempio:

```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### Configura printer.cfg per l'homing sensorless

L'impostazione `homing_retract_dist` deve essere impostata su zero nella sezione di configurazione `stepper_x` per disabilitare il secondo movimento di homing. Il secondo tentativo di homing non aggiunge valore quando si utilizza l'homing sensorless, non funzionerà in modo affidabile e confonderà il processo di ottimizzazione.

Assicurati che un'impostazione `hold_current` non sia specificata nella sezione del driver TMC del file config. (Se viene impostata una hold_current, dopo che è stato stabilito il contatto, il motore si arresta mentre il carrello viene premuto contro l'estremità del binario e la riduzione della corrente mentre si trova in quella posizione può causare il movimento del carrello, il che si traduce in prestazioni scadenti e confonde il processo di regolazione.)

È necessario configurare i pin di homing sensorless e configurare le impostazioni iniziali di "stallguard". Una configurazione di esempio tmc2209 per un asse X potrebbe essere simile a:

```
[tmc2209 stepper_x]
diag_pin: ^PA1      # Set to MCU pin connected to TMC DIAG pin
driver_SGTHRS: 255  # 255 is most sensitive value, 0 is least sensitive
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Un esempio di configurazione tmc2130 o tmc5160 potrebbe essere simile a:

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # Pin connected to TMC DIAG1 pin (or use diag0_pin / DIAG0 pin)
driver_SGT: -64  # -64 is most sensitive value, 63 is least sensitive
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Un esempio di configurazione di tmc2660 potrebbe essere simile a:

```
[tmc2660 stepper_x]
driver_SGT: -64     # -64 is most sensitive value, 63 is least sensitive
...

[stepper_x]
endstop_pin: ^PA1   # Pin connected to TMC SG_TST pin
homing_retract_dist: 0
...
```

Gli esempi sopra mostrano solo le impostazioni specifiche per l'homing sensorless. Vedere il [riferimento alla configurazione](Config_Reference.md#tmc-stepper-driver-configuration) per tutte le opzioni disponibili.

#### Trova la massima sensibilità che porta a homing con successo

Posizionare il carrello vicino al centro del binario. Utilizzare il comando SET_TMC_FIELD per impostare la sensibilità più alta. Per tmc2209:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

Per tmc2130, tmc5160 e tmc2660:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

Quindi emettere un comando `G28 X0` e verificare che l'asse non si muova affatto. Se l'asse si muove, emettere un `M112` per fermare la stampante - qualcosa non è corretto con il cablaggio o la configurazione del pin diag/sg_tst e deve essere corretto prima di continuare.

Quindi, diminuire progressivamente la sensibilità dell'impostazione `VALUE` ed eseguire nuovamente i comandi `SET_TMC_FIELD` `G28 X0` per trovare la sensibilità più alta che fa sì che il carrello si muova con successo fino all'arresto e si arresti. (Per i driver tmc2209 questo diminuirà SGTHRS, per altri conducenti aumenterà il sgt.) Assicurati di iniziare ogni tentativo con il carrello vicino al centro del binario (se necessario, emetti `M84` e quindi sposta manualmente il carrello sul centro). Dovrebbe essere possibile trovare la sensibilità più alta che si adatta in modo affidabile (le impostazioni con una sensibilità più alta comportano movimenti piccoli o nulli). Nota il valore trovato come *sensibilità_massima*. (Se si ottiene la sensibilità minima possibile (SGTHRS=0 o sgt=63) senza alcun movimento del carrello, allora qualcosa non è corretto con il cablaggio o la configurazione dei pin diag/sg_tst e deve essere corretto prima di continuare.)

Quando si cerca la sensibilità_massima, può essere conveniente passare a diverse impostazioni VALUE (in modo da dividere in due il parametro VALUE). In tal caso, prepararsi a emettere un comando `M112` per arrestare la stampante, poiché un'impostazione con una sensibilità molto bassa potrebbe far "sbattere" ripetutamente l'asse contro l'estremità del binario.

Assicurati di attendere un paio di secondi tra ogni tentativo di homing. Dopo che il driver TMC ha rilevato uno stallo, potrebbe volerci un po' di tempo per cancellare il suo indicatore interno ed essere in grado di rilevare un altro stallo.

Durante questi test di ottimizzazione, se un comando `G28 X0` non si sposta fino al limite dell'asse, prestare attenzione nell'emettere qualsiasi comando di movimento regolare (ad es. `G1`). Klipper non avrà una corretta comprensione della posizione del carrello e un comando di spostamento potrebbe causare risultati indesiderati e confusi.

#### Trova la sensibilità più bassa che porta a homing con un solo tocco

Quando si effettua l'homing con il valore *maximum_sensitivity* trovato, l'asse dovrebbe spostarsi all'estremità del binario e fermarsi con un "tocco singolo", ovvero non dovrebbe esserci un "clic" o un "sbattere". (Se c'è un suono che sbatte o scatta alla sensibilità_massima, allora la velocità di riferimento potrebbe essere troppo bassa, la corrente del driver potrebbe essere troppo bassa o la corsa di riferimento senza sensore potrebbe non essere una buona scelta per l'asse.)

Il passo successivo è spostare di nuovo continuamente il carrello in una posizione vicino al centro della rotaia, diminuire la sensibilità ed eseguire i comandi `SET_TMC_FIELD` `G28 X0` - l'obiettivo ora è trovare la sensibilità più bassa che risulti ancora nel la carrozza torna con successo al punto di riferimento con un "tocco singolo". Cioè, non "sbatte" o "clic" quando viene a contatto con l'estremità del binario. Nota il valore trovato come *sensibilità_minima*.

#### Aggiorna printer.cfg con il valore della sensibilità

After finding *maximum_sensitivity* and *minimum_sensitivity*, use a calculator to obtain the recommend sensitivity as *minimum_sensitivity + (maximum_sensitivity - minimum_sensitivity)/3*. The recommended sensitivity should be in the range between the minimum and maximum, but slightly closer to the minimum. Round the final value to the nearest integer value.

For tmc2209 set this in the config as `driver_SGTHRS`, for other TMC drivers set this in the config as `driver_SGT`.

If the range between *maximum_sensitivity* and *minimum_sensitivity* is small (eg, less than 5) then it may result in unstable homing. A faster homing speed may increase the range and make the operation more stable.

Note that if any change is made to driver current, homing speed, or a notable change is made to the printer hardware, then it will be necessary to run the tuning process again.

#### Using Macros when Homing

After sensorless homing completes the carriage will be pressed against the end of the rail and the stepper will exert a force on the frame until the carriage is moved away. It is a good idea to create a macro to home the axis and immediately move the carriage away from the end of the rail.

It is a good idea for the macro to pause at least 2 seconds prior to starting sensorless homing (or otherwise ensure that there has been no movement on the stepper for 2 seconds). Without a delay it is possible for the driver's internal stall flag to still be set from a previous move.

It can also be useful to have that macro set the driver current before homing and set a new current after the carriage has moved away.

An example macro might look something like:

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # Set current for sensorless homing
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # Pause to ensure driver stall flag is clear
    G4 P2000
    # Home
    G28 X0
    # Move away
    G90
    G1 X5 F1200
    # Set current during print
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

The resulting macro can be called from a [homing_override config section](Config_Reference.md#homing_override) or from a [START_PRINT macro](Slicers.md#klipper-gcode_macro).

Note that if the driver current during homing is changed, then the tuning process should be run again.

### Tips for sensorless homing on CoreXY

It is possible to use sensorless homing on the X and Y carriages of a CoreXY printer. Klipper uses the `[stepper_x]` stepper to detect stalls when homing the X carriage and uses the `[stepper_y]` stepper to detect stalls when homing the Y carriage.

Use the tuning guide described above to find the appropriate "stall sensitivity" for each carriage, but be aware of the following restrictions:

1. When using sensorless homing on CoreXY, make sure there is no `hold_current` configured for either stepper.
1. While tuning, make sure both the X and Y carriages are near the center of their rails before each home attempt.
1. After tuning is complete, when homing both X and Y, use macros to ensure that one axis is homed first, then move that carriage away from the axis limit, pause for at least 2 seconds, and then start the homing of the other carriage. The move away from the axis avoids homing one axis while the other is pressed against the axis limit (which may skew the stall detection). The pause is necessary to ensure the driver's stall flag is cleared prior to homing again.

## Querying and diagnosing driver settings

The `[DUMP_TMC command](G-Codes.md#dump_tmc) is a useful tool when configuring and diagnosing the drivers. It will report all fields configured by Klipper as well as all fields that can be queried from the driver.

All of the reported fields are defined in the Trinamic datasheet for each driver. These datasheets can be found on the [Trinamic website](https://www.trinamic.com/). Obtain and review the Trinamic datasheet for the driver to interpret the results of DUMP_TMC.

## Configuring driver_XXX settings

Klipper supports configuring many low-level driver fields using `driver_XXX` settings. The [TMC driver config reference](Config_Reference.md#tmc-stepper-driver-configuration) has the full list of fields available for each type of driver.

In addition, almost all fields can be modified at run-time using the [SET_TMC_FIELD command](G-Codes.md#set_tmc_field).

Each of these fields is defined in the Trinamic datasheet for each driver. These datasheets can be found on the [Trinamic website](https://www.trinamic.com/).

Note that the Trinamic datasheets sometime use wording that can confuse a high-level setting (such as "hysteresis end") with a low-level field value (eg, "HEND"). In Klipper, `driver_XXX` and SET_TMC_FIELD always set the low-level field value that is actually written to the driver. So, for example, if the Trinamic datasheet states that a value of 3 must be written to the HEND field to obtain a "hysteresis end" of 0, then set `driver_HEND=3` to obtain the high-level value of 0.

## Common Questions

### Can I use stealthChop mode on an extruder with pressure advance?

Many people successfully use "stealthChop" mode with Klipper's pressure advance. Klipper implements [smooth pressure advance](Kinematics.md#pressure-advance) which does not introduce any instantaneous velocity changes.

However, "stealthChop" mode may produce lower motor torque and/or produce higher motor heat. It may or may not be an adequate mode for your particular printer.

### I keep getting "Unable to read tmc uart 'stepper_x' register IFCNT" errors?

This occurs when Klipper is unable to communicate with a tmc2208 or tmc2209 driver.

Make sure that the motor power is enabled, as the stepper motor driver generally needs motor power before it can communicate with the micro-controller.

If this error occurs after flashing Klipper for the first time, then the stepper driver may have been previously programmed in a state that is not compatible with Klipper. To reset the state, remove all power from the printer for several seconds (physically unplug both USB and power plugs).

Otherwise, this error is typically the result of incorrect UART pin wiring or an incorrect Klipper configuration of the UART pin settings.

### I keep getting "Unable to write tmc spi 'stepper_x' register ..." errors?

This occurs when Klipper is unable to communicate with a tmc2130 or tmc5160 driver.

Make sure that the motor power is enabled, as the stepper motor driver generally needs motor power before it can communicate with the micro-controller.

Otherwise, this error is typically the result of incorrect SPI wiring, an incorrect Klipper configuration of the SPI settings, or an incomplete configuration of devices on an SPI bus.

Note that if the driver is on a shared SPI bus with multiple devices then be sure to fully configure every device on that shared SPI bus in Klipper. If a device on a shared SPI bus is not configured, then it may incorrectly respond to commands not intended for it and corrupt the communication to the intended device. If there is a device on a shared SPI bus that can not be configured in Klipper, then use a [static_digital_output config section](Config_Reference.md#static_digital_output) to set the CS pin of the unused device high (so that it will not attempt to use the SPI bus). The board's schematic is often a useful reference for finding which devices are on an SPI bus and their associated pins.

### Why did I get a "TMC reports error: ..." error?

This type of error indicates the TMC driver detected a problem and has disabled itself. That is, the driver stopped holding its position and ignored movement commands. If Klipper detects that an active driver has disabled itself, it will transition the printer into a "shutdown" state.

It's also possible that a **TMC reports error** shutdown occurs due to SPI errors that prevent communication with the driver (on tmc2130, tmc5160, or tmc2660). If this occurs, it's common for the reported driver status to show `00000000` or `ffffffff` - for example: `TMC reports error: DRV_STATUS: ffffffff ...` OR `TMC reports error: READRSP@RDSEL2: 00000000 ...`. Such a failure may be due to an SPI wiring problem or may be due to a self-reset or failure of the TMC driver.

Some common errors and tips for diagnosing them:

#### TMC reports error: `... ot=1(OvertempError!)`

This indicates the motor driver disabled itself because it became too hot. Typical solutions are to decrease the stepper motor current, increase cooling on the stepper motor driver, and/or increase cooling on the stepper motor.

#### TMC reports error: `... ShortToGND` OR `LowSideShort`

This indicates the driver has disabled itself because it detected very high current passing through the driver. This may indicate a loose or shorted wire to the stepper motor or within the stepper motor itself.

This error may also occur if using stealthChop mode and the TMC driver is not able to accurately predict the mechanical load of the motor. (If the driver makes a poor prediction then it may send too much current through the motor and trigger its own over-current detection.) To test this, disable stealthChop mode and check if the errors continue to occur.

#### TMC reports error: `... reset=1(Reset)` OR `CS_ACTUAL=0(Reset?)` OR `SE=0(Reset?)`

This indicates that the driver has reset itself mid-print. This may be due to voltage or wiring issues.

#### TMC reports error: `... uv_cp=1(Undervoltage!)`

This indicates the driver has detected a low-voltage event and has disabled itself. This may be due to wiring or power supply issues.

### How do I tune spreadCycle/coolStep/etc. mode on my drivers?

The [Trinamic website](https://www.trinamic.com/) has guides on configuring the drivers. These guides are often technical, low-level, and may require specialized hardware. Regardless, they are the best source of information.
