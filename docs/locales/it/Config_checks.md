# Controlli della configurazione

Questo documento fornisce una lista di step per confermare le impostazioni dei pin nel file printer.cfg di Klipper. È una buona idea eseguire questi passi dopo aver seguito i passi nel [documento di installazione](Installation.md).

In alcuni passaggi di questa guida, potrebbe essere necessario modificare il file di configurazione di Klipper. Assicuratevi di dare il comando RESTART, dopo ogni modifica al file di configurazione, per accertarsi che le modifiche abbiano effetto(scrivere "restart" nella scheda del terminale di Octoprint e cliccare su INVIA). E' anche consigliabile utilizzare il comando STATUS, dopo ogni RESTART, per verificare che il file di configurazione sia stato caricato correttamente.

## Verifica delle temperature

Iniziare verificando che le temperature siano correttamente riportate. Navigare alla scheda temperature di Octoprint.

eseguire l'istruzione ![octoprint-temperature](img/octoprint-temperature.png)

Verificare che la temperatura dell'ugello e del piatto(se presente) siano presenti e non stiano aumentando. Se stessero aumentando staccare l'alimentazione alla stampante. Se le temperature non sono precise, rivedere le impostazioni "sensor_type" e "sensor_pin" per l'ugello e/o il piatto.

## Verifica M112

Da terminale dare il comando M112. Questo comando richiede a Klipper di porsi in uno stato di spengnimento. Questo causerà la disconnessione di Octoprint da Klipper - selezionate il menu connessione e premete il pulsante "Connetti" per riconnettere Octoprint. Selezionate poi la scheda temperatura e verificate che le temperature si stiano aggiornando e che non stiano aumentando. Se stanno aumentando, staccate l'alimentazione della stampante.

Il comando M112 mette Klipper in uno stato di spegnimento. Per farlo uscire da questo stato, dare il comando FIRMWARE_RESTART sempre da terminale di Octoprint.

## Verifica i riscaldatori

Passare alla pagina della temperatura su Octoprint . Nella casella della temperatura "Tool", digitare 50 seguito dal tasto enter .La temperatura dell'estrusore indicata nel grafico, dovrebbe iniziare ad aumentare (entro 30 secondi circa). Quindi vai alla casella a scorrimento della temperatura "Tool" e seleziona "Off". Dopo alcuni minuti la temperatura dovrebbe tornare al valore di temperatura ambiente iniziale. Se la temperatura non aumenta, verifica l'impostazione "heater_pin" nella configurazione.

Se la stampante ha il piatto riscaldato, eseguire nuovamente il test indicato in precedenza ma per il piatto.

## Verifica il pin di abilitazione del motore passo-passo

Verificare che tutti gli assi della stampante possano muoversi manualmente in modo libero (con i motori passo-passo sono disabilitati). In caso contrario, inserire un comando M84 per disabilitare i motori. Se uno degli assi non può ancora muoversi in modo libero, verificare la configurazione "enable_pin" del driver del motore passo-passo corrispondente. Sulla maggior parte dei driver per motori passo-passo, il pin di abilitazione del motore è "attivo basso" e quindi il pin di abilitazione dovrebbe avere un "!" prima del pin (ad esempio, "enable_pin: !ar38").

## Verifica i finecorsa

Spostare manualmente tutti gli assi della stampante in modo che nessuno di essi sia a contatto con un finecorsa. Invia un comando QUERY_ENDSTOPS tramite il terminale di Octoprint. Dovrebbe visualizzare lo stato corrente di tutti i finecorsa configurati e gli stessi dovrebbero essere nello stato di "aperto". Per ciascuno degli finecorsa, eseguire nuovamente il comando QUERY_ENDSTOPS mentre si attiva manualmente il finecorsa corrispondente, dovrebbe rispondere con "TRIGGERED".

Se il finecorsa è invertito (viene indicato "aperto" quando è attivato e viceversa), aggiungere un "!" alla definizione del pin (ad esempio, "endstop_pin: ^!ar3"), oppure togliere "!" se invece è presente.

Se il segnale del finecorsa non cambia , può significare che il fine corsa è collegato a un pin diverso. Tuttavia, potrebbe essere necessaria una modifica all'impostazione pullup del pin (il '^' all'inizio del istruzione "endstop_pin".La maggior parte delle stampanti utilizzano un resistore pullup e l'istruzione '^' dovrebbe essere presente).

## Verifica dei motori passo-passo

Utilizzare il comando STEPPER_BUZZ per verificare le connessioni di ciascun motore passo-passo. Inizia posizionando manualmente in un punto intermedio dell'asse, quindi esegui l'istruzione `STEPPER_BUZZ STEPPER=stepper_x`. Il comando STEPPER_BUZZ farà muovere il motore passo-passo di un millimetro in direzione avanti e poi tornerà in posizione iniziale. (Se il finecorsa è definito come position_endstop=0, all'inizio di ogni movimento lo motore passo-passo si allontanerà dal finecorsa.) Eseguirà questa movimento oscillatorio per dieci volte.

Se il motore passo-passo non si muove , verifica le impostazioni "enable_pin" e "step_pin" sul driver. Se il motore passo-passo si muove ma non torna nella sua posizione originale, verificare l'impostazione "dir_pin". Se il motore passo-passo oscilla in una direzione errata, generalmente sta a significare che è necessario invertire il "dir_pin" del l'asse. Questo viene fatto aggiungendo un istruzione '!' alla "dir_pin" nel file di configurazione della stampante (o rimuovendolo se ne esiste già presente). Se il motore passo-passo si muove di più o di meno di un millimetro, verificare l'impostazione "rotation_distance".

Eseguire il test sopra descritto per ogni motore passo-passo definito nel file di configurazione. (Impostare il parametro STEPPER del comando STEPPER_BUZZ sul nome della sezione di configurazione da testare.) Se non è presente il filamento nell'estrusore, è possibile utilizzare STEPPER_BUZZ per verificare la connessione del motore dell'estrusore (usare STEPPER=estrusore). In caso contrario, è meglio testare il motore dell'estrusore per conto suo (vedere la sezione successiva).

Dopo aver verificato tutti i finecorsa e aver verificato tutti i motori passo-passo, è necessario testare il sistema di homing. Scrivere un comando G28 per portare a home tutti gli assi. Rimuovere l'alimentazione dalla stampante se l'istruzione non funziona correttamente. Se necessario, ripetere i passaggi di verifica del finecorsa e del motore passo-passo.

## Verifica il motore dell'estrusore

Per testare il motore dell'estrusore sarà necessario riscaldare l'estrusore alla temperatura di stampa. Passare alla pagina della temperatura Octoprint e selezionare una temperatura di target nel menù a tendina della temperatura (o inserire manualmente una temperatura opportuna). Attendere che la stampante raggiunga la temperatura desiderata. Quindi vai alla pagina di controllo di Octoprint e fai clic sul pulsante "Estrudi". Verificare che il motore dell'estrusore giri nella direzione corretta. In caso contrario, vedere i suggerimenti per la risoluzione dei problemi nella sezione precedente per verificare le impostazioni "enable_pin", "step_pin" e "dir_pin" per l'estrusore.

## Calibrare le impostazioni del PID

Klipper supporta il sistema [controllo PID](https://en.wikipedia.org/wiki/PID_controller) per iriscaldatori dell'estrusore e del piatto. Per utilizzare questo sistema di controllo, è necessario calibrare le impostazioni PID su ciascuna stampante (le impostazioni PID presenti in altri firmware o nei file di configurazione di esempio spesso funzionano male).

Per calibrare il PID dell'estrusore, accedere alla pagina del terminale OctoPrint ed eseguire il comando PID_CALIBRATE. Ad esempio: `PID_CALIBRATE HEATER=estrusore TARGET=170`

Al termine del test di ottimizzazione, eseguire l'istruzione `SAVE_CONFIG` per aggiornare il file printer.cfg con le nuove impostazioni PID.

Se la stampante ha un piatto riscaldato ed è dotato di azionamento con funzione PWM (Pulse Width Modulation), si consiglia di utilizzare il controllo PID anche per il piatto. (Quando il riscaldatore del piatto è controllato utilizzando l'algoritmo PID, potrebbe accendersi e spegnersi dieci volte al secondo, il che potrebbe non essere adatto per i riscaldatori che utilizzano un relè elettromeccanico.) Un tipico comando per calibrazione PID del piatto è: `PID_CALIBRATE HEATER=heater_bed TARGET= 60`

## Passi sucessivi

Questa guida ha lo scopo di aiutare la verifica delle impostazioni di base riferite ai pin presenti nel file di configurazione di Klipper. Assicurati di leggere la guida [bed leveling](Bed_Level.md). Consulta anche il documento [Slicers](Slicers.md) per informazioni sulla configurazione di un software slicer con Klipper.

Dopo aver verificato che la stampa di base funziona, è una buona prassi procedere con la calibrazione [avanzamento pressione](Pressure_Advance.md).

Potrebbe essere necessario eseguire altri tipi di calibrazione di dettaglio in riferimento alla stampante: sono disponibili numerose guide online per questo scopo (ad esempio, eseguire una ricerca sul Web per "calibrazione della stampante 3d"). Ad esempio, se si verifica l'effetto chiamato risonanza, è possibile provare a seguire la calibrazione tramite l'istruzione [compensazione della risonanza](Resonance_Compensation.md).
