# Versioni

Storico delle versioni di Klipper. Vedi [installation](Installation.md) per informazioni sull'installazione di Klipper.

## Klipper 0.11.0

Available on 20221128. Major changes in this release:

* Trinamic stepper motor driver "step on both edges" optimization.
* Support for Python3. The Klipper host code will run with either Python2 or Python3.
* Enhanced CAN bus support. Support for CAN bus on rp2040, stm32g0, stm32h7, same51, and same54 chips. Support for "USB to CAN bus bridge" mode.
* Support for CanBoot bootloader.
* Support for mpu9250 and mpu6050 accelerometers.
* Improved error handling for max31856, max31855, max31865, and max6675 temperature sensors.
* It is now possible to configure LEDs to update during long running G-Code commands using LED "template" support.
* Several micro-controller improvements. New support for stm32h743, stm32h750, stm32l412, stm32g0b1, same70, same51, and same54 chips. Support for i2c reads on atsamd and stm32f0. Hardware pwm support on stm32. Linux mcu signal based event dispatch. New rp2040 support for "make flash", i2c, and rp2040-e5 USB errata.
* New modules added: angle, dac084S085, exclude_object, led, mpu9250, pca9632, smart_effector, z_thermal_adjust. New deltesian kinematics added. New dump_mcu tool added.
* Correzione di diversi bug e pulizia del codice.

## Klipper 0.10.0

Disponibile su 20210929. Principali modifiche in questa versione:

* Supporto per "Homing multi-MCU". È ora possibile collegare un motore passo-passo e il relativo fine corsa a microcontrollori separati. Ciò semplifica il cablaggio delle sonde Z sulle "schede portautensili".
* Klipper ora ha un [Community Discord Server](https://discord.klipper3d.org) e un [Community Discourse Server](https://community.klipper3d.org).
* Il [sito Web di Klipper](https://www.klipper3d.org) ora utilizza l'infrastruttura "mkdocs". Esiste anche un progetto [Klipper Translations](https://github.com/Klipper3d/klipper-translations).
* Supporto automatizzato per il flashing del firmware tramite sdcard su molte schede.
* Nuovo supporto cinematico per le stampanti "Hybrid CoreXY" e "Hybrid CoreXZ".
* Klipper ora usa `rotation_distance` per configurare le distanze di viaggio del motore passo-passo.
* Il codice host principale di Klipper ora può comunicare direttamente con i microcontrollori utilizzando il bus CAN.
* Nuovo sistema di "analisi del movimento". Gli aggiornamenti di movimento interni di Klipper e i risultati dei sensori possono essere tracciati e registrati per l'analisi.
* I driver per motori passo-passo Trinamic sono ora costantemente monitorati per rilevare eventuali condizioni di errore.
* Supporto per il microcontrollore rp2040 (schede Raspberry Pi Pico).
* Il sistema "make menuconfig" ora utilizza kconfiglib.
* Molti moduli aggiuntivi aggiunti: ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu
* Correzione di diversi bug e pulizia del codice.

## Klipper 0.9.0

Disponibile su 20201020. Modifiche principali in questa versione:

* Supporto per "Input Shaping" - un meccanismo per contrastare la risonanza della stampante. Può ridurre o eliminare il "ringing" nelle stampe.
* Nuovo sistema "Smooth Pressure Advance". Questo implementa "Pressure Advance" senza introdurre variazioni di velocità istantanee. Ora è anche possibile regolare l'anticipo della pressione utilizzando un metodo "Tuning Tower".
* Nuovo server API "webhook". Ciò fornisce un'interfaccia JSON programmabile a Klipper.
* Il display LCD e il menu sono ora configurabili utilizzando la lingua del modello Jinja2.
* I driver per motori passo-passo TMC2208 possono ora essere utilizzati in modalità "standalone" con Klipper.
* Supporto BL-Touch v3 migliorato.
* Identificazione USB migliorata. Klipper ora ha il proprio codice di identificazione USB e i microcontrollori possono ora riportare i loro numeri di serie univoci durante l'identificazione USB.
* Nuovo supporto cinematico per stampanti "Rotary Delta" e "CoreXZ".
* Miglioramenti del microcontrollore: supporto per stm32f070, supporto per stm32f207, supporto per pin GPIO su "Linux MCU", supporto per "bootloader HID" stm32, supporto per bootloader Chitu, supporto per bootloader MKS Robin.
* Gestione migliorata degli eventi di "garbage collection" di Python.
* Molti moduli aggiuntivi aggiunti: adc_scaled, adxl345, bme280, display_status, extruder_stepper, fan_generic, hall_filament_width_sensor, htu21d, homing_heaters, input_shaper, lm75, print_stats, resonance_tester, shaper_calibrate, query_adc, graph_accelerometer, graph_extruder, graph_motion, graph_shaper, graph_temp_sensor, whconsole
* Correzione di diversi bug e pulizia del codice.

### Klipper 0.9.1

Disponibile su 20201028. Versione contenente solo correzioni di bug.

## Klipper 0.8.0

Disponibile su 20191021. Modifiche principali in questa versione:

* Nuovo supporto per il modello dei comandi G-Code. Il G-Code nel file di configurazione viene ora valutato con il linguaggio dei template Jinja2.
* Miglioramenti ai driver per stepper Trinamic:
   * Nuovo supporto per i driver TMC2209 e TMC5160.
   * Migliorati i comandi G-Code DUMP_TMC, SET_TMC_CURRENT e INIT_TMC.
   * Supporto migliorato per la gestione di TMC UART con un mux analogico.
* Supporto migliorato per homing, sonda e livellamento del piatto:
   * Aggiunti nuovi moduli manual_probe, bed_screws, Screws_tilt_adjust, skew_correction, safe_z_home.
   * Sondaggio multi-campione migliorato con logica mediana, media e tentativi.
   * Documentazione migliorata per BL-Touch, calibrazione della sonda, calibrazione endstop, calibrazione delta, homing sensorless e calibrazione della fase finecorsa.
   * Supporto della corsa di riferimento migliorato su un asse Z grande.
* Molti miglioramenti del microcontrollore Klipper:
   * Klipper portato su: SAM3X8C, SAM4S8C, SAMD51, STM32F042, STM32F4
   * Nuove implementazioni del driver CDC USB su SAM3X, SAM4, STM32F4.
   * Supporto avanzato per il flashing di Klipper su USB.
   * Supporto SPI software.
   * Filtraggio della temperatura notevolmente migliorato sull'LPC176x.
   * Le impostazioni dei pin di uscita possono essere configurate nel microcontrollore.
* Nuovo sito web con la documentazione di Klipper: http://klipper3d.org/
   * Klipper ora ha un logo.
* Supporto sperimentale alla cinematica polare e "cable winch".
* Il file di configurazione ora può includere altri file di configurazione.
* Molti moduli aggiuntivi aggiunti: board_pins, controller_fan, delay_gcode, dotstar, filament_switch_sensor, firmware_retraction, gcode_arcs, gcode_button, heater_generic, manual_stepper, mcp4018, mcp4728, neopixel, pause_resume, respond, temperature_sensor tsl1401cl_filament_width_sensor, tuning_tower
* Molti comandi aggiuntivi aggiunti: RESTORE_GCODE_STATE, SAVE_GCODE_STATE, SET_GCODE_VARIABLE, SET_HEATER_TEMPERATURE, SET_IDLE_TIMEOUT, SET_TEMPERATURE_FAN_TARGET
* Correzione di diversi bug e pulizia del codice.

## Klipper 0.7.0

Disponibile su 20181220. Modifiche principali in questa versione:

* Klipper ora supporta il livellamento del piatto "mesh"
* Nuovo supporto per la calibrazione delta "potenziata" (calibra le dimensioni x/y di stampa su stampanti delta)
* Supporto per la configurazione a runtime dei driver per motori passo-passo Trinamic (tmc2130, tmc2208, tmc2660)
* Migliorato il supporto del sensore di temperatura: MAX6675, MAX31855, MAX31856, MAX31865, termistori personalizzati, sensori stile pt100 comuni
* Diversi nuovi moduli: temperature_fan, sx1509, force_move, mcp4451, z_tilt, quad_gantry_level, endstop_phase, bltouch
* Aggiunti diversi nuovi comandi: SAVE_CONFIG, SET_PRESSURE_ADVANCE, SET_GCODE_OFFSET, SET_VELOCITY_LIMIT, STEPPER_BUZZ, TURN_OFF_HEATERS, M204, macro g-code personalizzate
* Supporto display LCD esteso:
   * Supporto per i menu a runtime
   * Nuove icone di visualizzazione
   * Supporto per i display "uc1701" e "ssd1306"
* Supporto per microcontrollore aggiuntivo:
   * Klipper portato su: LPC176x (Smoothieboards), SAM4E8E (Duet2), SAMD21 (Arduino Zero), STM32F103 (dispositivi "blue pill"), atmega32u4
   * Nuovo driver USB CDC generico implementato su AVR, LPC176x, SAMD21 e STM32F103
   * Miglioramenti delle prestazioni sui processori ARM
* Il codice della cinematica è stato riscritto per utilizzare un "risolutore iterativo"
* Nuovi test case automatici per il software host Klipper
* Molti nuovi file di configurazione di esempio per le stampanti standard comuni
* Aggiornamenti della documentazione per bootloader, benchmarking, porting del microcontroller, controlli di configurazione, mappatura dei pin, impostazioni dello slicer, packaging e altro ancora
* Diverse correzioni di bug e pulizia del codice

## Klipper 0.6.0

Disponibile su 20180331. Modifiche principali in questa versione:

* Controlli avanzati dei guasti hardware del riscaldatore e del termistore
* Supporto per sonde Z
* Supporto iniziale per la calibrazione automatica dei parametri sulle delta (tramite un nuovo comando delta_calibrate)
* Supporto iniziale per la compensazione dell'inclinazione del piatto (tramite il comando bed_tilt_calibrate)
* Supporto iniziale per "homing sicuro" e di homing overrides
* Supporto iniziale per la visualizzazione dello stato sui display RepRapDiscount stile 2004 e 12864
* Nuovi miglioramenti multi-estrusore:
   * Supporto per riscaldatori condivisi
   * Supporto iniziale per carrelli doppi
* Supporto per la configurazione di più stepper per asse (ad es. doppia Z)
* Supporto per pin di output digitali e pwm personalizzati (con un nuovo comando SET_PIN)
* Supporto iniziale per una "sdcard virtuale" che consente di stampare direttamente da Klipper (aiuta su macchine troppo lente per eseguire bene OctoPrint)
* Supporto per impostare diverse lunghezze del braccio su ciascuna torre di una delta
* Supporto per i comandi G-Code M220/M221 (override del fattore di velocità/override del fattore di estrusione)
* Diversi aggiornamenti della documentazione:
   * Molti nuovi file di configurazione di esempio per le stampanti standard comuni
   * Nuovo esempio di configurazione di MCU multipli
   * Nuovo esempio di configurazione del sensore bltouch
   * Nuove FAQ, controllo della configurazione e documenti G-Code
* Supporto iniziale per test di integrazione continui su tutti i commit di github
* Diverse correzioni di bug e pulizia del codice

## Klipper 0.5.0

Disponibile su 20171025. Modifiche principali in questa versione:

* Supporto per stampanti con più estrusori.
* Supporto iniziale per l'esecuzione su Beaglebone PRU. Supporto iniziale per la scheda Replicape.
* Supporto iniziale per l'esecuzione del codice del microcontrollore in un processo Linux in tempo reale.
* Supporto per microcontrollori multipli. (Ad esempio, si potrebbe controllare un estrusore con un microcontrollore e il resto della stampante con un altro.) La sincronizzazione dell'orologio del software è implementata per coordinare le azioni tra i microcontrollori.
* Miglioramenti delle prestazioni stepper (AVR da 20 Mhz fino a 189.000 passi al secondo).
* Supporto per il controllo dei servocomandi e supporto per la definizione delle ventole di raffreddamento degli ugelli.
* Diverse correzioni di bug e pulizia del codice

## Klipper 0.4.0

Disponibile su 20170503. Modifiche principali in questa versione:

* Installazione migliorata su macchine Raspberry Pi. La maggior parte dell'installazione è ora basata su script.
* Supporto per la cinematica corexy
* Aggiornamenti della documentazione: nuovo documento Cinematica, nuova guida all'ottimizzazione di Pressure Advance, nuovi file di configurazione di esempio e altro ancora
* Miglioramenti delle prestazioni dello stepper (AVR da 20 Mhz su 175.000 passi al secondo, Arduino Due oltre 460.000)
* Supporto per il ripristino automatico del microcontrollore. Supporto per il ripristino tramite l'attivazione dell'alimentazione USB su Raspberry Pi.
* L'algoritmo di avanzamento della pressione ora funziona con il look-ahead per ridurre le variazioni di pressione in curva.
* Supporto per limitare la velocità massima di brevi movimenti a zigzag
* Supporto per sensori AD595
* Diverse correzioni di bug e pulizia del codice

## Klipper 0.3.0

Disponibile su 20161223. Modifiche principali in questa versione:

* Documentazione migliorata
* Supporto per robot con cinematica delta
* Supporto per microcontrollore Arduino Due (ARM cortex-M3)
* Supporto USB per microcontrollori basati su AVR
* Supporto per l'algoritmo di "pressure advance": riduce la trasudazione durante le stampe.
* Nuova funzione "stopper phased based" - consente una maggiore precisione sull'homing.
* Supporto per comandi "extended g-code" come "help", "restart" e "status".
* Supporto per ricaricare la configurazione di Klipper e riavviare il software host emettendo un comando di "restart" dal terminale.
* Miglioramenti delle prestazioni stepper (AVR da 20 Mhz fino a 158.000 passi al secondo).
* Segnalazione errori migliorata. La maggior parte degli errori ora viene mostrata tramite il terminale insieme all'aiuto su come risolverli.
* Diverse correzioni di bug e pulizia del codice

## Klipper 0.2.0

Rilascio iniziale di Klipper. Disponibile su 20160525. Le principali funzionalità disponibili nella versione iniziale includono:

* Supporto di base per stampanti cartesiane (stepper, estrusore, piatto riscaldato, ventola di raffreddamento).
* Supporto per i comandi g-code comuni. Supporto per interfacciarsi con OctoPrint.
* Accelerazione e gestione lookahead
* Supporto per microcontrollori AVR tramite porte seriali standard
