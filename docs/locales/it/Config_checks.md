# Controlli della configurazione

Questo documento fornisce una lista di step per confermare le impostazioni dei pin nel file printer.cfg di Klipper. È una buona idea eseguire questi passi dopo aver seguito i passi nel [documento di installazione](Installation.md).

In alcuni passaggi di questa guida, potrebbe essere necessario modificare il file di configurazione di Klipper. Assicuratevi di dare il comando RESTART, dopo ogni modifica al file di configurazione, per accertarsi che le modifiche abbiano effetto(scrivere "restart" nella scheda del terminale di Octoprint e cliccare su INVIA). E' anche consigliabile utilizzare il comando STATUS, dopo ogni RESTART, per verificare che il file di configurazione sia stato caricato correttamente.

## Verifica delle temperature

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Verifica M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Verifica i riscaldatori

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Se la stampante ha il piatto riscaldato, eseguire nuovamente il test indicato in precedenza ma per il piatto.

## Verifica il pin di abilitazione del motore passo-passo

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Verifica i finecorsa

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Se il segnale del finecorsa non cambia , può significare che il fine corsa è collegato a un pin diverso. Tuttavia, potrebbe essere necessaria una modifica all'impostazione pullup del pin (il '^' all'inizio del istruzione "endstop_pin".La maggior parte delle stampanti utilizzano un resistore pullup e l'istruzione '^' dovrebbe essere presente).

## Verifica dei motori passo-passo

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Se il motore passo-passo non si muove , verifica le impostazioni "enable_pin" e "step_pin" sul driver. Se il motore passo-passo si muove ma non torna nella sua posizione originale, verificare l'impostazione "dir_pin". Se il motore passo-passo oscilla in una direzione errata, generalmente sta a significare che è necessario invertire il "dir_pin" del l'asse. Questo viene fatto aggiungendo un istruzione '!' alla "dir_pin" nel file di configurazione della stampante (o rimuovendolo se ne esiste già presente). Se il motore passo-passo si muove di più o di meno di un millimetro, verificare l'impostazione "rotation_distance".

Eseguire il test sopra descritto per ogni motore passo-passo definito nel file di configurazione. (Impostare il parametro STEPPER del comando STEPPER_BUZZ sul nome della sezione di configurazione da testare.) Se non è presente il filamento nell'estrusore, è possibile utilizzare STEPPER_BUZZ per verificare la connessione del motore dell'estrusore (usare STEPPER=estrusore). In caso contrario, è meglio testare il motore dell'estrusore per conto suo (vedere la sezione successiva).

Dopo aver verificato tutti i finecorsa e aver verificato tutti i motori passo-passo, è necessario testare il sistema di homing. Scrivere un comando G28 per portare a home tutti gli assi. Rimuovere l'alimentazione dalla stampante se l'istruzione non funziona correttamente. Se necessario, ripetere i passaggi di verifica del finecorsa e del motore passo-passo.

## Verifica il motore dell'estrusore

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Calibrare le impostazioni del PID

Klipper supporta il sistema [controllo PID](https://en.wikipedia.org/wiki/PID_controller) per iriscaldatori dell'estrusore e del piatto. Per utilizzare questo sistema di controllo, è necessario calibrare le impostazioni PID su ciascuna stampante (le impostazioni PID presenti in altri firmware o nei file di configurazione di esempio spesso funzionano male).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

Al termine del test di ottimizzazione, eseguire l'istruzione `SAVE_CONFIG` per aggiornare il file printer.cfg con le nuove impostazioni PID.

Se la stampante ha un piatto riscaldato ed è dotato di azionamento con funzione PWM (Pulse Width Modulation), si consiglia di utilizzare il controllo PID anche per il piatto. (Quando il riscaldatore del piatto è controllato utilizzando l'algoritmo PID, potrebbe accendersi e spegnersi dieci volte al secondo, il che potrebbe non essere adatto per i riscaldatori che utilizzano un relè elettromeccanico.) Un tipico comando per calibrazione PID del piatto è: `PID_CALIBRATE HEATER=heater_bed TARGET= 60`

## Passi sucessivi

Questa guida ha lo scopo di aiutare la verifica delle impostazioni di base riferite ai pin presenti nel file di configurazione di Klipper. Assicurati di leggere la guida [bed leveling](Bed_Level.md). Consulta anche il documento [Slicers](Slicers.md) per informazioni sulla configurazione di un software slicer con Klipper.

Dopo aver verificato che la stampa di base funziona, è una buona prassi procedere con la calibrazione [avanzamento pressione](Pressure_Advance.md).

Potrebbe essere necessario eseguire altri tipi di calibrazione di dettaglio in riferimento alla stampante: sono disponibili numerose guide online per questo scopo (ad esempio, eseguire una ricerca sul Web per "calibrazione della stampante 3d"). Ad esempio, se si verifica l'effetto chiamato risonanza, è possibile provare a seguire la calibrazione tramite l'istruzione [compensazione della risonanza](Resonance_Compensation.md).
