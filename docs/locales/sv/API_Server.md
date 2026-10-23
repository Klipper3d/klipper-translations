# API-server

Dokumentet beskriver Klippers programmeringsgränssnitt (API). Gränssnittet gör det möjligt för externa program att fråga och styra Klippers värdprogramvara.

## Aktivera API-socketen

För att använda API-servern måste värdprogramvaran klippy.py startas med parametern `-a`. Exempelvis:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

Då skapar värdprogramvaran en Unix-domänsocket. En klient kan sedan öppna en anslutning till socketen och skicka kommandon till Klipper.

Se projektet [Moonraker](https://github.com/Arksine/moonraker) för ett populärt verktyg som kan vidarebefordra HTTP-begäranden till Klippers Unix-domänsocket för API-servern.

## Begärandeformat

Meddelanden som skickas och tas emot via socketen är JSON-kodade strängar som avslutas med ASCII-tecknet 0x03:

```
<json_object_1><0x03><json_object_2><0x03>...
```

Klipper innehåller verktyget `scripts/whconsole.py`, som kan utföra ovanstående meddelandeinramning. Exempelvis:

```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

Verktyget kan läsa en serie JSON-kommandon från stdin, skicka dem till Klipper och rapportera resultaten. Det förväntar sig att varje JSON-kommando står på en enda rad och lägger automatiskt till avgränsaren 0x03 när en begäran skickas. (Klippers API-server kräver inte radbrytningar.)

## API-protokoll

Kommandoprotokollet som används på kommunikationssocketen är inspirerat av [json-rpc](https://www.jsonrpc.org/).

En begäran kan se ut så här:

`{"id": 123, "method": "info", "params": {}}`

och ett svar kan se ut så här:

`{"id": 123, "result": {"state_message": "Printer is ready", "klipper_path": "/home/pi/klipper", "config_file": "/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6", "hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4 (v7l)", "state": "ready", "python_path": "/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}`

Varje begäran måste vara ett JSON-objekt. (I det här dokumentet används Pythons term "dictionary" för att beskriva ett "JSON-objekt" – en mappning av nyckel/värde-par inom `{}`.)

Begärans objekt måste innehålla parametern "method", som är strängnamnet på en tillgänglig Klipper-"endpoint".

Begärans objekt kan innehålla parametern "params", som måste vara av objekttyp. "params" ger ytterligare parameterinformation till Klipper-"endpointen" som hanterar begäran. Dess innehåll är specifikt för "endpointen".

Begärans objekt kan innehålla parametern "id", som kan vara av valfri JSON-typ. Om "id" finns svarar Klipper på begäran med ett svarsmeddelande som innehåller detta "id". Om "id" utelämnas (eller sätts till JSON-värdet "null") ger Klipper inget svar på begäran. Ett svarsmeddelande är ett JSON-objekt som innehåller "id" och "result". "result" är alltid ett objekt – dess innehåll är specifikt för "endpointen" som hanterar begäran.

Om behandlingen av en begäran resulterar i ett fel innehåller svarsmeddelandet fältet "error" i stället för fältet "result". Till exempel kan begäran: `{"id": 123, "method": "gcode/script", "params": {"script": "G1 X200"}}` resultera i ett felsvar som: `{"id": 123, "error": {"message": "Must home axis first: 200.000 0.000 0.000 [0.000]", "error": "WebRequestError"}}`

Klipper börjar alltid behandla begäranden i den ordning de tas emot. Vissa begäranden kan dock dröja med att slutföras, vilket kan göra att deras svar skickas i en annan ordning än svaren på andra begäranden. En JSON-begäran pausar aldrig behandlingen av framtida JSON-begäranden.

## Prenumerationer

Vissa Klipper-begäranden till "endpoints" gör det möjligt att "prenumerera" på framtida asynkrona uppdateringsmeddelanden.

Exempelvis:

`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{"key": 345}}}`

kan först svara med:

`{"id": 123, "result": {}}`

och få Klipper att skicka framtida meddelanden som liknar:

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

En prenumerationsbegäran accepterar ett "response_template"-objekt i begärans "params"-fält. Objektet "response_template" används som mall för framtida asynkrona meddelanden och kan innehålla godtyckliga nyckel/värde-par. När dessa framtida asynkrona meddelanden skickas lägger Klipper till fältet "params", med ett objekt vars innehåll är specifikt för "endpointen", i svarsmallen och skickar sedan mallen. Om fältet "response_template" inte anges används som standard ett tomt objekt (`{}`).

## Tillgängliga "endpoints"

Enligt konvention har Klipper-"endpoints" formen `<module_name>/<some_name>`. När en begäran görs till en "endpoint" måste det fullständiga namnet anges i parametern "method" i begärans objekt (t.ex. `{"method"="gcode/restart"}`).

### info

"info"-endpointen används för att hämta system- och versionsinformation från Klipper. Den används också för att ge Klipper klientens versionsinformation. Exempelvis: `{"id": 123, "method": "info", "params": { "client_info": { "version": "v1"}}}`

Om parametern "client_info" finns måste den vara ett objekt, men objektet kan ha godtyckligt innehåll. Klienter rekommenderas att ange klientens namn och programvaruversion när de först ansluter till Klippers API-server.

### emergency_stop

"emergency_stop"-endpointen används för att instruera Klipper att övergå till läget "shutdown". Den fungerar på liknande sätt som G-kodkommandot `M112`. Exempelvis: `{"id": 123, "method": "emergency_stop"}`

### register_remote_method

Den här endpointen låter klienter registrera metoder som kan anropas från Klipper. Vid lyckat resultat returneras ett tomt objekt.

Exempelvis returnerar `{"id": 123, "method": "register_remote_method", "params": {"response_template": {"action": "run_paneldue_beep"}, "remote_method": "paneldue_beep"}}` följande: `{"id": 123, "result": {}}`

Fjärrmetoden `paneldue_beep` kan nu anropas från Klipper. Observera att om metoden tar parametrar ska de anges som nyckelordsargument. Nedan följer ett exempel på hur den kan anropas från en gcode_macro:

```
[gcode_macro PANELDUE_BEEP]
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

När gcode-makrot PANELDUE_BEEP körs skickar Klipper något i stil med följande via socketen: `{"action": "run_paneldue_beep", "params": {"frequency": 300, "duration": 1.0}}`

### objects/list

Den här endpointen frågar efter listan över tillgängliga skrivarobjekt som kan frågas efter (via endpointen "objects/query"). Exempelvis kan `{"id": 123, "method": "objects/list"}` returnera: `{"id": 123, "result": {"objects": ["webhooks", "configfile", "heaters", "gcode_move", "query_endstops", "idle_timeout", "toolhead", "extruder"]}}`

### objects/query

Den här endpointen gör det möjligt att fråga efter information från skrivarobjekt. Exempelvis kan `{"id": 123, "method": "objects/query", "params": {"objects": {"toolhead": ["position"], "webhooks": null}}}` returnera: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready", "state_message": "Printer is ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3051555.377933684}}`

Parametern "objects" i begäran måste vara ett objekt som innehåller de skrivarobjekt som ska frågas efter. Nyckeln innehåller skrivarobjektets namn och värdet är antingen "null" (för att fråga efter alla fält) eller en lista med fältnamn.

Svarsmeddelandet innehåller fältet "status" med ett objekt som innehåller den efterfrågade informationen. Nyckeln innehåller skrivarobjektets namn och värdet är ett objekt med dess fält. Svarsmeddelandet innehåller även fältet "eventtime" med tidsstämpeln för när frågan gjordes.

Tillgängliga fält dokumenteras i [statusreferensen](Status_Reference.md).

### objects/subscribe

Den här endpointen gör det möjligt att först fråga efter och sedan prenumerera på information från skrivarobjekt. Endpointens begäran och svar är identiska med "objects/query". Exempelvis kan `{"id": 123, "method": "objects/subscribe", "params": {"objects":{"toolhead": ["position"], "webhooks": ["state"]}, "response_template":{}}}` returnera: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3052153.382083195}}` och resultera i efterföljande asynkrona meddelanden som: `{"params": {"status": {"webhooks": {"state": "shutdown"}}, "eventtime": 3052165.418815847}}`

### gcode/help

Den här endpointen gör det möjligt att fråga efter tillgängliga G-kodkommandon som har en definierad hjälptext. Exempelvis kan `{"id": 123, "method": "gcode/help"}` returnera: `{"id": 123, "result": {"RESTORE_GCODE_STATE": "Restore a previously saved G-Code state", "PID_CALIBRATE": "Run PID calibration test", "QUERY_ADC": "Report the last value of an analog pin", ...}}`

### gcode/script

Den här endpointen gör det möjligt att köra en serie G-kodkommandon. Exempelvis: `{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}`

Om det angivna G-kodskriptet ger upphov till ett fel genereras ett felsvar. Om G-kodkommandot däremot ger terminalutdata inkluderas dessa inte i svaret. (Använd endpointen "gcode/subscribe_output" för att hämta G-kodens terminalutdata.)

Om ett G-kodkommando behandlas när den här begäran tas emot köas det angivna skriptet. Fördröjningen kan bli betydande (t.ex. om ett G-kodkommando som väntar på temperatur körs). JSON-svarsmeddelandet skickas när behandlingen av skriptet är helt klar.

### gcode/restart

Den här endpointen gör det möjligt att begära en omstart. Den motsvarar ungefär G-kodkommandot "RESTART". Exempelvis: `{"id": 123, "method": "gcode/restart"}`

Precis som endpointen "gcode/script" slutförs den här endpointen först när alla väntande G-kodkommandon har slutförts.

### gcode/firmware_restart

Detta liknar endpointen "gcode/restart" och implementerar G-kodkommandot "FIRMWARE_RESTART". Exempelvis: `{"id": 123, "method": "gcode/firmware_restart"}`

Precis som endpointen "gcode/script" slutförs den här endpointen först när alla väntande G-kodkommandon har slutförts.

### gcode/subscribe_output

Den här endpointen används för att prenumerera på G-kodens terminalmeddelanden som Klipper genererar. Exempelvis kan `{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{}}}` senare generera asynkrona meddelanden som: `{"params": {"response": "// Klipper state: Shutdown"}}`

Den här endpointen är avsedd att stödja mänsklig interaktion via ett gränssnitt med "terminalfönster". Det avråds från att tolka innehåll i G-kodens terminalutdata. Använd endpointen "objects/subscribe" för att få uppdateringar om Klippers tillstånd.

### motion_report/dump_stepper

Den här endpointen används för att prenumerera på Klippers interna kommandoflöde queue_step för en stegmotor. Dessa rörelseuppdateringar på låg nivå kan vara användbara för diagnostik och felsökning. Användning av endpointen kan öka Klippers systembelastning.

En begäran kan se ut så här: `{"id": 123, "method":"motion_report/dump_stepper", "params": {"name": "stepper_x", "response_template": {}}}` och kan returnera: `{"id": 123, "result": {"header": ["interval", "count", "add"]}}`. Den kan senare generera asynkrona meddelanden som: `{"params": {"first_clock": 179601081, "first_time": 8.98, "first_position": 0, "last_clock": 219686097, "last_time": 10.984, "data": [[179601081, 1, 0], [29573, 2, -8685], [16230, 4, -1525], [10559, 6, -160], [10000, 976, 0], [10000, 1000, 0], [10000, 1000, 0], [10000, 1000, 0], [9855, 5, 187], [11632, 4, 1534], [20756, 2, 9442]]}}`

Fältet "header" i svaret på den första frågan används för att beskriva fälten i senare "data"-svar.

### motion_report/dump_trapq

Den här endpointen används för att prenumerera på Klippers interna "trapezoidal motion queue". Dessa rörelseuppdateringar på låg nivå kan vara användbara för diagnostik och felsökning. Användning av endpointen kan öka Klippers systembelastning.

En begäran kan se ut så här: `{"id": 123, "method": "motion_report/dump_trapq", "params": {"name": "toolhead", "response_template":{}}}` och kan returnera: `{"id": 1, "result": {"header": ["time", "duration", "start_velocity", "acceleration", "start_position", "direction"]}}`. Den kan senare generera asynkrona meddelanden som: `{"params": {"data": [[4.05, 1.0, 0.0, 0.0, [300.0, 0.0, 0.0], [0.0, 0.0, 0.0]], [5.054, 0.001, 0.0, 3000.0, [300.0, 0.0, 0.0], [-1.0, 0.0, 0.0]]]}}`

Fältet "header" i svaret på den första frågan används för att beskriva fälten i senare "data"-svar.

### adxl345/dump_adxl345

Den här endpointen används för att prenumerera på accelerometerdata från ADXL345. Dessa rörelseuppdateringar på låg nivå kan vara användbara för diagnostik och felsökning. Användning av endpointen kan öka Klippers systembelastning.

En begäran kan se ut så här: `{"id": 123, "method":"adxl345/dump_adxl345", "params": {"sensor": "adxl345", "response_template": {}}}` och kan returnera: `{"id": 123,"result":{"header":["time","x_acceleration","y_acceleration", "z_acceleration"]}}`. Den kan senare generera asynkrona meddelanden som: `{"params":{"overflows":0,"data":[[3292.432935,-535.44309,-1529.8374,9561.4], [3292.433256,-382.45935,-1606.32927,9561.48375]]}}`

Fältet "header" i svaret på den första frågan används för att beskriva fälten i senare "data"-svar.

### angle/dump_angle

Den här endpointen används för att prenumerera på [vinkelgivardata](Config_Reference.md#angle). Dessa rörelseuppdateringar på låg nivå kan vara användbara för diagnostik och felsökning. Användning av endpointen kan öka Klippers systembelastning.

En begäran kan se ut så här: `{"id": 123, "method":"angle/dump_angle", "params": {"sensor": "my_angle_sensor", "response_template": {}}}` och kan returnera: `{"id": 123,"result":{"header":["time","angle"]}}`. Den kan senare generera asynkrona meddelanden som: `{"params":{"position_offset":3.151562,"errors":0, "data":[[1290.951905,-5063],[1290.952321,-5065]]}}`

Fältet "header" i svaret på den första frågan används för att beskriva fälten i senare "data"-svar.

### load_cell/dump_force

Den här endpointen används för att prenumerera på kraftdata som produceras av en lastcell. Användning av endpointen kan öka Klippers systembelastning.

En begäran kan se ut så här: `{"id": 123, "method":"load_cell/dump_force", "params": {"sensor": "load_cell", "response_template": {}}}` och kan returnera: `{"id": 123,"result":{"header":["time", "force (g)", "counts", "tare_counts"]}}`. Den kan senare generera asynkrona meddelanden som: `{"params":{"data":[[3292.432935, 40.65, 562534, -234467]]}}`

Fältet "header" i svaret på den första frågan används för att beskriva fälten i senare "data"-svar.

### load_cell_probe/dump_taps

Den här endpointen används för att prenumerera på detaljer om avsökningshändelser av typen "tap". Användning av endpointen kan öka Klippers systembelastning.

En begäran kan se ut så här: `{"id": 123, "method":"load_cell/dump_force", "params": {"sensor": "load_cell", "response_template": {}}}` och kan returnera: `{"id": 123,"result":{"header":["probe_tap_event"]}}`. Den kan senare generera asynkrona meddelanden som:

```
{"params":{"tap":'{
   "time": [118032.28039, 118032.2834, ...],
   "force": [-459.4213119680034, -458.1640702543264, ...],
}}}
```

Dessa data kan användas för att rita:

* Tids-/kraftdiagrammet

### pause_resume/cancel

Den här endpointen liknar körning av G-kodkommandot "PRINT_CANCEL". Exempelvis: `{"id": 123, "method": "pause_resume/cancel"}`

Precis som endpointen "gcode/script" slutförs den här endpointen först när alla väntande G-kodkommandon har slutförts.

### pause_resume/pause

Den här endpointen liknar körning av G-kodkommandot "PAUSE". Exempelvis: `{"id": 123, "method": "pause_resume/pause"}`

Precis som endpointen "gcode/script" slutförs den här endpointen först när alla väntande G-kodkommandon har slutförts.

### pause_resume/resume

Den här endpointen liknar körning av G-kodkommandot "RESUME". Exempelvis: `{"id": 123, "method": "pause_resume/resume"}`

Precis som endpointen "gcode/script" slutförs den här endpointen först när alla väntande G-kodkommandon har slutförts.

### query_endstops/status

Den här endpointen frågar efter aktiva ändlägesendpoints och returnerar deras status. Exempelvis kan `{"id": 123, "method": "query_endstops/status"}` returnera: `{"id": 123, "result": {"y": "open", "x": "open", "z": "TRIGGERED"}}`

Precis som endpointen "gcode/script" slutförs den här endpointen först när alla väntande G-kodkommandon har slutförts.

### bed_mesh/dump_mesh

Dumpa konfigurationen och tillståndet för den aktuella nätmodellen och alla sparade profiler.

Exempelvis: `{"id": 123, "method": "bed_mesh/dump_mesh"}`

kan returnera:

```
{
    "current_mesh": {
        "name": "eddy-scan-test",
        "probed_matrix": [...],
        "mesh_matrix": [...],
        "mesh_params": {
            "x_count": 9,
            "y_count": 9,
            "mesh_x_pps": 2,
            "mesh_y_pps": 2,
            "algo": "bicubic",
            "tension": 0.5,
            "min_x": 20,
            "max_x": 330,
            "min_y": 30,
            "max_y": 320
        }
    },
    "profiles": {
        "default": {
            "points": [...],
            "mesh_params": {
                "min_x": 20,
                "max_x": 330,
                "min_y": 30,
                "max_y": 320,
                "x_count": 9,
                "y_count": 9,
                "mesh_x_pps": 2,
                "mesh_y_pps": 2,
                "algo": "bicubic",
                "tension": 0.5
            }
        },
        "eddy-scan-test": {
            "points": [...],
            "mesh_params": {
                "x_count": 9,
                "y_count": 9,
                "mesh_x_pps": 2,
                "mesh_y_pps": 2,
                "algo": "bicubic",
                "tension": 0.5,
                "min_x": 20,
                "max_x": 330,
                "min_y": 30,
                "max_y": 320
            }
        },
        "eddy-rapid-test": {
            "points": [...],
            "mesh_params": {
                "x_count": 9,
                "y_count": 9,
                "mesh_x_pps": 2,
                "mesh_y_pps": 2,
                "algo": "bicubic",
                "tension": 0.5,
                "min_x": 20,
                "max_x": 330,
                "min_y": 30,
                "max_y": 320
            }
        }
    },
    "calibration": {
        "points": [...],
        "config": {
            "x_count": 9,
            "y_count": 9,
            "mesh_x_pps": 2,
            "mesh_y_pps": 2,
            "algo": "bicubic",
            "tension": 0.5,
            "mesh_min": [
                20,
                30
            ],
            "mesh_max": [
                330,
                320
            ],
            "origin": null,
            "radius": null
        },
        "probe_path": [...],
        "rapid_path": [...]
    },
    "probe_offsets": [
        0,
        25,
        0.5
    ],
    "axis_minimum": [
        0,
        0,
        -5,
        0
    ],
    "axis_maximum": [
        351,
        358,
        330,
        0
    ]
}
```

Endpointen `dump_mesh` tar en valfri parameter, `mesh_args`. Parametern måste vara ett objekt vars nycklar och värden är parametrar som är tillgängliga för [BED_MESH_CALIBRATE](#bed_mesh_calibrate). Detta uppdaterar nätmodellens konfiguration och avsökningspunkterna med de angivna parametrarna innan resultatet returneras. Nätmodellens parametrar bör utelämnas om du inte vill visualisera avsökningspunkterna och/eller förflyttningsvägen före `BED_MESH_CALIBRATE`.
