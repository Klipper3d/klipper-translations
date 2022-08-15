# Server API

Questo documento descrive l'Application Programmer Interface (API) di Klipper. Questa interfaccia consente alle applicazioni esterne di interrogare e controllare il software host Klipper.

## Abilitazione del socket API

Per utilizzare il server API, il software host klippy.py deve essere avviato con il parametro `-a`. Per esempio:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

Ciò fa sì che il software host crei un socket di dominio Unix. Un client può quindi aprire una connessione su quel socket e inviare comandi a Klipper.

Consulta il progetto [Moonraker](https://github.com/Arksine/moonraker) per uno strumento popolare in grado di inoltrare richieste HTTP all'API Server Unix Domain Socket di Klipper.

## Formato richiesta

I messaggi inviati e ricevuti sul socket sono stringhe codificate JSON terminate da un carattere ASCII 0x03:

```
<json_object_1><0x03><json_object_2><0x03>...
```

Klipper contiene uno strumento `scripts/whconsole.py` che può eseguire il framing dei messaggi sopra. Per esempio:

```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

Questo strumento può leggere una serie di comandi JSON da stdin, inviarli a Klipper e riportare i risultati. Lo strumento prevede che ogni comando JSON si trovi su una singola riga e aggiungerà automaticamente il terminatore 0x03 durante la trasmissione di una richiesta. (Il server dell'API Klipper non ha un requisito di newline.)

## Protocollo API

Il protocollo dei comandi utilizzato sul socket di comunicazione è ispirato a [json-rpc](https://www.jsonrpc.org/).

Una richiesta potrebbe essere simile a:

`{"id": 123, "method": "info", "params": {}}`

e una risposta potrebbe essere simile a:

`{"id": 123, "result": {"state_message": "Printer is ready", "klipper_path": "/home/pi/klipper", "config_file": "/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6", "hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4 (v7l)", "state": "ready", "python_path": "/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}`

Ogni richiesta deve essere un dizionario JSON. (Questo documento usa il termine Python "dizionario" per descrivere un "oggetto JSON" - una mappatura di coppie chiave/valore contenute in `{}`.)

Il dizionario di richiesta deve contenere un parametro "method" che è il nome stringa di un "endpoint" di Klipper disponibile.

Il dizionario della richiesta può contenere un parametro "params" che deve essere di tipo dizionario. I "parametri" forniscono ulteriori informazioni sui parametri all'"endpoint" di Klipper che gestisce la richiesta. Il suo contenuto è specifico dell'"endpoint".

Il dizionario delle richieste può contenere un parametro "id" che può essere di qualsiasi tipo JSON. Se è presente "id", Klipper risponderà alla richiesta con un messaggio di risposta contenente tale "id". Se "id" viene omesso (o impostato su un valore JSON "null"), Klipper non fornirà alcuna risposta alla richiesta. Un messaggio di risposta è un dizionario JSON contenente "id" e "result". Il "risultato" è sempre un dizionario: i suoi contenuti sono specifici dell'"endpoint" che gestisce la richiesta.

Se l'elaborazione di una richiesta genera un errore, il messaggio di risposta conterrà un campo "errore" anziché un campo "risultato". Ad esempio, la richiesta: `{"id": 123, "method": "gcode/script", "params": {"script": "G1 X200"}}` potrebbe generare una risposta di errore come: ` {"id": 123, "error": {"message": "Deve prima posizionare l'asse: 200.000 0.000 0.000 [0.000]", "error": "WebRequestError"}}`

Klipper inizierà sempre a elaborare le richieste nell'ordine in cui sono state ricevute. Tuttavia, alcune richieste potrebbero non essere completate immediatamente, il che potrebbe causare l'invio di una risposta associata non conforme rispetto alle risposte di altre richieste. Una richiesta JSON non sospenderà mai l'elaborazione di future richieste JSON.

## Sottoscrizioni

Alcune richieste di "endpoint" di Klipper consentono di "iscriversi" a futuri messaggi di aggiornamento asincrono.

Per esempio:

`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{"key": 345}}}`

inizialmente può rispondere con:

`{"id": 123, "result": {}}`

e fare in modo che Klipper invii messaggi futuri simili a:

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

Una richiesta di sottoscrizione accetta un dizionario "response_template" nel campo "params" della richiesta. Quel dizionario "response_template" viene utilizzato come modello per futuri messaggi asincroni: può contenere coppie chiave/valore arbitrarie. Quando invierà questi futuri messaggi asincroni, Klipper aggiungerà un campo "params" contenente un dizionario con contenuti specifici per "endpoint" al modello di risposta e quindi invierà quel modello. Se non viene fornito un campo "response_template", il valore predefinito è un dizionario vuoto (`{}`).

## "endpoint" disponibili

Per convenzione, gli "endpoint" di Klipper sono nella forma `<module_name>/<some_name>`. Quando si effettua una richiesta a un "endpoint", il nome completo deve essere impostato nel parametro "method" del dizionario di richiesta (ad esempio, `{"method"="gcode/restart"}`).

### info

L'endpoint "info" viene utilizzato per ottenere informazioni sul sistema e sulla versione da Klipper. Viene anche utilizzato per fornire a Klipper le informazioni sulla versione del client. Ad esempio: `{"id": 123, "method": "info", "params": { "client_info": { "version": "v1"}}}`

Se presente, il parametro "client_info" deve essere un dizionario, ma quel dizionario potrebbe avere contenuti arbitrari. I clienti sono incoraggiati a fornire il nome del client e la sua versione del software quando si connettono per la prima volta al server dell'API Klipper.

### emergency_stop

L'endpoint "emergency_stop" viene utilizzato per indicare a Klipper di passare allo stato di "spegnimento". Si comporta in modo simile al comando G-Code `M112`. Ad esempio: `{"id": 123, "method": "emergency_stop"}`

### register_remote_method

Questo endpoint consente ai client di registrare metodi che possono essere chiamati da klipper. Restituirà un oggetto vuoto in caso di successo.

Per esempio: `{"id": 123, "method": "register_remote_method", "params": {"response_template": {"action": "run_paneldue_beep"}, "remote_method": "paneldue_beep"}}` will return: `{"id": 123, "result": {}}`

Il metodo remoto `paneldue_beep` ora può essere chiamato da Klipper. Nota che se il metodo accetta parametri, dovrebbero essere forniti come argomenti di parole chiave. Di seguito è riportato un esempio di come può essere chiamato da una gcode_macro:

```
[gcode_macro PANELDUE_BEEP]
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

Quando viene eseguita la macro gcode PANELDUE_BEEP, Klipper invia qualcosa di simile al seguente tramite il socket: `{"action": "run_paneldue_beep", "params": {"frequency": 300, "duration": 1.0}}`

### oggetti/elenco

Questo endpoint interroga l'elenco degli "oggetti" della stampante disponibili che è possibile interrogare (tramite l'endpoint "objects/query"). Ad esempio: `{"id": 123, "method": "objects/list"}` potrebbe restituire: `{"id": 123, "result": {"objects": ["webhooks", "configfile" , "heaters", "gcode_move", "query_endstops", "idle_timeout", "toolhead", "extruder"]}}`

### oggetti/interrogazione

Questo endpoint consente di interrogare informazioni da oggetti. Ad esempio: `{"id": 123, "method": "objects/query", "params": {"objects": {"toolhead": ["position"], "webhooks": null}}}` potrebbe restituire: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready", "state_message": "Printer is ready"}, "toolhead": { "position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3051555.377933684}}`

Il parametro "objects" nella richiesta deve essere un dizionario contenente gli oggetti stampante che devono essere interrogati - la chiave contiene il nome dell'oggetto stampante e il valore è "null" (per interrogare tutti i campi) o un elenco di nomi di campo.

Il messaggio di risposta conterrà un campo "status" contenente un dizionario con le informazioni richieste: la chiave contiene il nome dell'oggetto stampante e il valore è un dizionario contenente i suoi campi. Il messaggio di risposta conterrà anche un campo "eventtime" contenente il timestamp da quando è stata eseguita la query.

I campi disponibili sono documentati nel documento [Status Reference](Status_Reference.md).

### oggetti/subscribe

Questo endpoint consente di eseguire query e quindi iscriversi alle informazioni dagli oggetti stampante. La richiesta e la risposta dell'endpoint sono identiche all'endpoint "objects/query". Ad esempio: `{"id": 123, "method": "objects/subscribe", "params": {"objects":{"toolhead": ["position"], "webhooks": ["state"] }, "response_template":{}}}` potrebbe restituire: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3052153.382083195}}` e generare messaggi asincroni successivi come: `{"params": {"status": {"webhooks": {"state": "shutdown"}}, "eventtime": 3052165.418815847}}`

### gcode/help

Questo endpoint consente di interrogare i comandi G-Code disponibili che hanno una stringa di aiuto definita. Ad esempio: `{"id": 123, "method": "gcode/help"}` potrebbe restituire: `{"id": 123, "result": {"RESTORE_GCODE_STATE": "Restore a previously saved G-Code state", "PID_CALIBRATE": "Run PID calibration test", "QUERY_ADC": "Report the last value of an analog pin", ...}}`

### gcode/script

Questo endpoint consente di eseguire una serie di comandi G-Code. Ad esempio: `{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}`

Se lo script G-Code fornito genera un errore, allora viene generata una risposta di errore. Tuttavia, se il comando G-Code produce un output del terminale, tale output del terminale non viene fornito nella risposta. (Utilizzare l'endpoint "gcode/subscribe_output" per ottenere l'output del terminale G-Code.)

Se c'è un comando G-Code in elaborazione quando viene ricevuta questa richiesta, lo script fornito verrà messo in coda. Questo ritardo potrebbe essere significativo (ad esempio, se è in esecuzione un comando di attesa del codice G per la temperatura). Il messaggio di risposta JSON viene inviato al completamento dell'elaborazione dello script.

### gcode/restart

Questo endpoint consente di richiedere un riavvio: è simile all'esecuzione del comando "RESTART" del codice G. Ad esempio: `{"id": 123, "method": "gcode/restart"}`

Come con l'endpoint "gcode/script", questo endpoint viene completato solo dopo il completamento di tutti i comandi G-Code in sospeso.

### gcode/firmware_restart

Questo è simile all'endpoint "gcode/restart": implementa il comando G-Code "FIRMWARE_RESTART". Ad esempio: `{"id": 123, "method": "gcode/firmware_restart"}`

Come con l'endpoint "gcode/script", questo endpoint viene completato solo dopo il completamento di tutti i comandi G-Code in sospeso.

### gcode/subscribe_output

Questo endpoint viene utilizzato per iscriversi ai messaggi del terminale G-Code generati da Klipper. Ad esempio: `{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{}}}` potrebbe in seguito produrre messaggi asincroni come: `{"params": { "response": "// Klipper state: Shutdown"}}`

Questo endpoint ha lo scopo di supportare l'interazione umana tramite un'interfaccia "finestra di terminale". L'analisi del contenuto dall'output del terminale G-Code è sconsigliata. Usa l'endpoint "objects/subscribe" per ottenere aggiornamenti sullo stato di Klipper.

### motion_report/dump_stepper

Questo endpoint viene utilizzato per iscriversi al flusso di comandi queue_step interno di Klipper per uno stepper. L'ottenimento di questi aggiornamenti di movimento di basso livello può essere utile per scopi diagnostici e di debug. L'utilizzo di questo endpoint può aumentare il carico di sistema di Klipper.

Una richiesta può essere simile a: `{"id": 123, "method":"motion_report/dump_stepper", "params": {"name": "stepper_x", "response_template": {}}}` e potrebbe restituire: `{"id": 123, "result": {"header": ["interval", "count", "add"]}}` e potrebbe in seguito produrre messaggi asincroni come: `{"params": {" first_clock": 179601081, "first_time": 8.98, "first_position": 0, "last_clock": 219686097, "last_time": 10.984, "data": [[179601081, 1, 0], [29573, 2, -8685] , [16230, 4, -1525], [10559, 6, -160], [10000, 976, 0], [10000, 1000, 0], [10000, 1000, 0], [10000, 1000, 0] , [9855, 5, 187], [11632, 4, 1534], [20756, 2, 9442]]}}`

Il campo "intestazione" nella risposta alla query iniziale viene utilizzato per descrivere i campi trovati nelle risposte "dati" successive.

### motion_report/dump_trapq

Questo endpoint viene utilizzato per iscriversi alla "coda di movimento trapezoidale" interna di Klipper. L'ottenimento di questi aggiornamenti di movimento di basso livello può essere utile per scopi diagnostici e di debug. L'utilizzo di questo endpoint può aumentare il carico di sistema di Klipper.

Una richiesta può essere simile a: `{"id": 123, "method": "motion_report/dump_trapq", "params": {"name": "toolhead", "response_template":{}}}` e potrebbe restituire: `{"id": 1, "result": {"header": ["time", "duration", "start_velocity", "acceleration", "start_position", "direction"]}}` e potrebbero in seguito produrre messaggi asincroni quali: `{"params": {"data": [[4.05, 1.0, 0.0, 0.0, [300.0, 0.0, 0.0], [0.0, 0.0, 0.0]], [5.054, 0.001, 0.0, 3000.0 , [300.0, 0.0, 0.0], [-1.0, 0.0, 0.0]]]}}`

Il campo "intestazione" nella risposta alla query iniziale viene utilizzato per descrivere i campi trovati nelle risposte "dati" successive.

### adxl345/dump_adxl345

Questo endpoint viene utilizzato per la sottoscrizione ai dati dell'accelerometro ADXL345. L'ottenimento di questi aggiornamenti di movimento di basso livello può essere utile per scopi diagnostici e di debug. L'utilizzo di questo endpoint può aumentare il carico di sistema di Klipper.

Una richiesta può essere simile a: `{"id": 123, "method":"adxl345/dump_adxl345", "params": {"sensor": "adxl345", "response_template": {}}}` e potrebbe restituire: `{"id": 123,"result":{"header":["time","x_acceleration","y_acceleration", "z_acceleration"]}}` e potrebbe in seguito produrre messaggi asincroni come: `{"params ":{"overflow":0,"data":[[3292.432935,-535.44309,-1529.8374,9561.4], [3292.433256,-382.45935,-1606.32927,9561.48375]]}}`

Il campo "intestazione" nella risposta alla query iniziale viene utilizzato per descrivere i campi trovati nelle risposte "dati" successive.

### angle/dump_angle

Questo endpoint viene utilizzato per iscriversi a [dati del sensore angolare](Config_Reference.md#angle). L'ottenimento di questi aggiornamenti di movimento di basso livello può essere utile per scopi diagnostici e di debug. L'utilizzo di questo endpoint può aumentare il carico di sistema di Klipper.

Una richiesta può essere simile a: `{"id": 123, "method":"angle/dump_angle", "params": {"sensor": "my_angle_sensor", "response_template": {}}}` e potrebbe restituire: `{"id": 123,"result":{"header":["time","angle"]}}` e potrebbe in seguito produrre messaggi asincroni come: `{"params":{"position_offset":3.151562 ,"errori":0, "dati":[[1290.951905,-5063],[1290.952321,-5065]]}}`

Il campo "intestazione" nella risposta alla query iniziale viene utilizzato per descrivere i campi trovati nelle risposte "dati" successive.

### pause_resume/cancel

Questo endpoint è simile all'esecuzione del comando G-Code "PRINT_CANCEL". Ad esempio: `{"id": 123, "method": "pause_resume/cancel"}`

Come con l'endpoint "gcode/script", questo endpoint viene completato solo dopo il completamento di tutti i comandi G-Code in sospeso.

### pause_resume/pause

Questo endpoint è simile all'esecuzione del comando G-Code "PAUSE". Ad esempio: `{"id": 123, "method": "pause_resume/pause"}`

Come con l'endpoint "gcode/script", questo endpoint viene completato solo dopo il completamento di tutti i comandi G-Code in sospeso.

### pause_resume/resume

Questo endpoint è simile all'esecuzione del comando G-Code "RESUME". Ad esempio: `{"id": 123, "method": "pause_resume/resume"}`

Come con l'endpoint "gcode/script", questo endpoint viene completato solo dopo il completamento di tutti i comandi G-Code in sospeso.

### query_endstops/status

Questo endpoint eseguirà una query sugli endpoint attivi e restituirà il loro stato. Ad esempio: `{"id": 123, "method": "query_endstops/status"}` potrebbe restituire: `{"id": 123, "result": {"y": "open", "x": "aperto", "z": "TRIGGERED"}}`

Come con l'endpoint "gcode/script", questo endpoint viene completato solo dopo il completamento di tutti i comandi G-Code in sospeso.
