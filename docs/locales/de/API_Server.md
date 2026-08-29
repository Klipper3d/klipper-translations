# API Server

Dieses Document beschreibt Klipper's Application Programmer Interface (API). Diese Schnittstelle ermöglicht es externen Anwendungen, die Host-Software von Klipper abzufragen und zu steuern.

## Aktivieren des API-Sockets

Um den API-Server zu nutzen, muss die klippy.py Host-Software mit dem Parameter `-a` gestartet werden. Zum Beispiel:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

Dies veranlasst die Host-Software, einen Unix Domain Socket zu erstellen. Ein Client kann dann eine Verbindung zu diesem Socket öffnen und Befehle an Klipper senden.

Siehe das Projekt [Moonraker](https://github.com/Arksine/moonraker), ein beliebtes Werkzeug, das HTTP-Anfragen an Klippers API-Server-Unix-Domain-Socket weiterleiten kann.

## Anfrageformat

Über den Socket gesendete und empfangene Nachrichten sind JSON-kodierte Strings, die mit einem ASCII-Zeichen 0x03 abgeschlossen werden:

```
<json_object_1><0x03><json_object_2><0x03>...
```

Klipper beinhaltet ein Tool `scripts/whconsole.py`, das die oben genannte Meldung einrahmen kann. Zum Beispiel:

```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

Dieses Werkzeug kann eine Reihe von JSON-Befehlen von stdin lesen, sie an Klipper senden und die Ergebnisse ausgeben. Das Werkzeug erwartet, dass jeder JSON-Befehl in einer einzigen Zeile steht, und es hängt beim Senden einer Anfrage automatisch den Terminator 0x03 an. (Der Klipper-API-Server erfordert keinen Zeilenumbruch.)

## API Protokoll

Das auf dem Kommunikations-Socket verwendete Befehlsprotokoll ist von [json-rpc](https://www.jsonrpc.org/) inspiriert.

Eine Anfrage könnte wie folgt aussehen:

`{"id": 123, "method": "info", "params": {}}`

und eine Antwort könnte wie folgt aussehen:

`{"id": 123, "result": {"state_message": "Printer is ready", "klipper_path": "/home/pi/klipper", "config_file": "/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6", "hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4 (v7l)", "state": "ready", "python_path": "/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}`

Jede Anfrage muss ein JSON-Dictionary sein. (Dieses Dokument verwendet den Python-Begriff "Dictionary", um ein "JSON-Objekt" zu beschreiben – eine Zuordnung von Schlüssel/Wert-Paaren innerhalb von `{}`.)

Das Anfrage-Dictionary muss einen Parameter "method" enthalten, der als Zeichenkette den Namen eines verfügbaren Klipper-"Endpunkts" angibt.

Das Anfrage-Dictionary darf einen Parameter "params" enthalten, der vom Typ Dictionary sein muss. Die "params" liefern zusätzliche Parameterinformationen an den Klipper-"Endpunkt", der die Anfrage bearbeitet. Ihr Inhalt ist spezifisch für den jeweiligen "Endpunkt".

Das Anfrage-Dictionary darf einen Parameter "id" enthalten, der von einem beliebigen JSON-Typ sein kann. Ist "id" vorhanden, antwortet Klipper auf die Anfrage mit einer Antwortnachricht, die diese "id" enthält. Wird "id" weggelassen (oder auf den JSON-Wert "null" gesetzt), sendet Klipper keine Antwort auf die Anfrage. Eine Antwortnachricht ist ein JSON-Dictionary, das "id" und "result" enthält. Das "result" ist immer ein Dictionary – sein Inhalt ist spezifisch für den "Endpunkt", der die Anfrage bearbeitet.

Führt die Verarbeitung einer Anfrage zu einem Fehler, so enthält die Antwortnachricht anstelle eines Feldes "result" ein Feld "error". Beispielsweise könnte die Anfrage `{"id": 123, "method": "gcode/script", "params": {"script": "G1 X200"}}` zu einer Fehlerantwort wie dieser führen: `{"id": 123, "error": {"message": "Must home axis first: 200.000 0.000 0.000 [0.000]", "error": "WebRequestError"}}`

Klipper beginnt die Verarbeitung von Anfragen stets in der Reihenfolge, in der sie eintreffen. Manche Anfragen werden jedoch nicht sofort abgeschlossen, wodurch die zugehörige Antwort gegenüber den Antworten anderer Anfragen in abweichender Reihenfolge gesendet werden kann. Eine JSON-Anfrage hält die Verarbeitung künftiger JSON-Anfragen niemals an.

## Abonnements

Bei einigen Klipper-"Endpunkt"-Anfragen lassen sich künftige asynchrone Aktualisierungsnachrichten "abonnieren".

Zum Beispiel:

`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{"key": 345}}}`

kann anfänglich reagieren mit:

`{"id": 123, "result": {}}`

und veranlassen Klipper, künftig Nachrichten der folgenden Art zu senden:

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

Eine Abonnement-Anfrage akzeptiert im Feld "params" der Anfrage ein Dictionary "response_template". Dieses "response_template"-Dictionary dient als Vorlage für künftige asynchrone Nachrichten – es darf beliebige Schlüssel/Wert-Paare enthalten. Beim Senden dieser künftigen asynchronen Nachrichten fügt Klipper der Antwortvorlage ein Feld "params" mit einem Dictionary hinzu, dessen Inhalt vom jeweiligen "Endpunkt" abhängt, und sendet dann diese Vorlage. Wird kein Feld "response_template" angegeben, so wird standardmäßig ein leeres Dictionary (`{}`) verwendet.

## Verfügbare "Endpunkte"

Klipper-"Endpunkte" haben üblicherweise die Form `<module_name>/<some_name>`. Bei einer Anfrage an einen "Endpunkt" muss der vollständige Name im Parameter "method" des Anfrage-Dictionaries angegeben werden (z. B. `{"method"="gcode/restart"}`).

### info

Der Endpunkt "info" dient dazu, System- und Versionsinformationen von Klipper abzurufen. Außerdem wird er verwendet, um Klipper die Versionsinformationen des Clients mitzuteilen. Zum Beispiel: `{"id": 123, "method": "info", "params": { "client_info": { "version": "v1"}}}`

Sofern vorhanden, muss der Parameter "client_info" ein Dictionary sein, dessen Inhalt jedoch beliebig sein darf. Clients wird empfohlen, beim ersten Verbinden mit dem Klipper-API-Server den Namen des Clients und dessen Softwareversion anzugeben.

### emergency_stop

Der Endpunkt "emergency_stop" weist Klipper an, in den Zustand "shutdown" zu wechseln. Er verhält sich ähnlich wie der G-Code-Befehl `M112`. Zum Beispiel: `{"id": 123, "method": "emergency_stop"}`

### register_remote_method

Dieser Endpunkt ermöglicht es Clients, Methoden zu registrieren, die von Klipper aus aufgerufen werden können. Bei Erfolg gibt er ein leeres Objekt zurück.

Zum Beispiel: `{"id": 123, "method": "register_remote_method", "params": {"response_template": {"action": "run_paneldue_beep"}, "remote_method": "paneldue_beep"}}` liefert: `{"id": 123, "result": {}}`

Die entfernte Methode `paneldue_beep` kann nun von Klipper aus aufgerufen werden. Beachten Sie, dass Parameter der Methode als Schlüsselwortargumente übergeben werden müssen. Nachfolgend ein Beispiel, wie sie aus einem gcode_macro aufgerufen werden kann:

```
[gcode_macro PANELDUE_BEEP]
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

Wird das G-Code-Makro PANELDUE_BEEP ausgeführt, sendet Klipper etwa Folgendes über den Socket: `{"action": "run_paneldue_beep", "params": {"frequency": 300, "duration": 1.0}}`

### objects/list

Dieser Endpunkt fragt die Liste der verfügbaren Drucker-"Objekte" ab, die abgefragt werden können (über den Endpunkt "objects/query"). Zum Beispiel könnte `{"id": 123, "method": "objects/list"}` Folgendes zurückgeben: `{"id": 123, "result": {"objects": ["webhooks", "configfile", "heaters", "gcode_move", "query_endstops", "idle_timeout", "toolhead", "extruder"]}}`

### objects/query

Dieser Endpunkt ermöglicht es, Informationen von Drucker-Objekten abzufragen. Zum Beispiel könnte `{"id": 123, "method": "objects/query", "params": {"objects": {"toolhead": ["position"], "webhooks": null}}}` Folgendes zurückgeben: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready", "state_message": "Printer is ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3051555.377933684}}`

Der Parameter "objects" in der Anfrage muss ein Dictionary mit den abzufragenden Drucker-Objekten sein - der Schlüssel enthält den Namen des Drucker-Objekts, und der Wert ist entweder "null" (um alle Felder abzufragen) oder eine Liste von Feldnamen.

Die Antwortnachricht enthält ein Feld "status" mit einem Dictionary der abgefragten Informationen - der Schlüssel enthält den Namen des Drucker-Objekts, und der Wert ist ein Dictionary mit dessen Feldern. Die Antwortnachricht enthält außerdem ein Feld "eventtime" mit dem Zeitstempel, zu dem die Abfrage erfolgte.

Verfügbare Felder sind im Dokument [Status-Referenz](Status_Reference.md) dokumentiert.

### objects/subscribe

Dieser Endpunkt ermöglicht es, Informationen von Drucker-Objekten abzufragen und anschließend zu abonnieren. Anfrage und Antwort dieses Endpunkts sind identisch mit denen des Endpunkts "objects/query". Zum Beispiel könnte `{"id": 123, "method": "objects/subscribe", "params": {"objects":{"toolhead": ["position"], "webhooks": ["state"]}, "response_template":{}}}` Folgendes zurückgeben: `{"id": 123, "result": {"status": {"webhooks": {"state": "ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3052153.382083195}}` und in der Folge zu asynchronen Nachrichten führen wie: `{"params": {"status": {"webhooks": {"state": "shutdown"}}, "eventtime": 3052165.418815847}}`

### gcode/help

Dieser Endpunkt ermöglicht es, verfügbare G-Code-Befehle abzufragen, für die ein Hilfetext definiert ist. Zum Beispiel könnte `{"id": 123, "method": "gcode/help"}` Folgendes zurückgeben: `{"id": 123, "result": {"RESTORE_GCODE_STATE": "Restore a previously saved G-Code state", "PID_CALIBRATE": "Run PID calibration test", "QUERY_ADC": "Report the last value of an analog pin", ...}}`

### gcode/script

Dieser Endpunkt ermöglicht es, eine Reihe von G-Code-Befehlen auszuführen. Zum Beispiel: `{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}`

Löst das übergebene G-Code-Skript einen Fehler aus, wird eine Fehlerantwort erzeugt. Erzeugt der G-Code-Befehl jedoch eine Terminalausgabe, wird diese nicht in der Antwort bereitgestellt. (Verwenden Sie den Endpunkt "gcode/subscribe_output", um G-Code-Terminalausgaben zu erhalten.)

Wird beim Eintreffen dieser Anfrage bereits ein G-Code-Befehl verarbeitet, wird das übergebene Skript in eine Warteschlange eingereiht. Diese Verzögerung kann erheblich sein (z. B. wenn gerade ein G-Code-Befehl zum Warten auf eine Temperatur läuft). Die JSON-Antwortnachricht wird gesendet, sobald die Verarbeitung des Skripts vollständig abgeschlossen ist.

### gcode/restart

Dieser Endpunkt ermöglicht es, einen Neustart anzufordern - er ähnelt der Ausführung des G-Code-Befehls "RESTART". Zum Beispiel: `{"id": 123, "method": "gcode/restart"}`

Wie beim Endpunkt "gcode/script" wird dieser Endpunkt erst abgeschlossen, nachdem alle ausstehenden G-Code-Befehle abgeschlossen wurden.

### gcode/firmware_restart

Dies ähnelt dem Endpunkt "gcode/restart" - er implementiert den G-Code-Befehl "FIRMWARE_RESTART". Zum Beispiel: `{"id": 123, "method": "gcode/firmware_restart"}`

Wie beim Endpunkt "gcode/script" wird dieser Endpunkt erst abgeschlossen, nachdem alle ausstehenden G-Code-Befehle abgeschlossen wurden.

### gcode/subscribe_output

Dieser Endpunkt dient zum Abonnieren von G-Code-Terminalnachrichten, die von Klipper erzeugt werden. Zum Beispiel könnte `{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{}}}` später zu asynchronen Nachrichten führen wie: `{"params": {"response": "// Klipper state: Shutdown"}}`

Dieser Endpunkt ist dafür gedacht, die menschliche Interaktion über eine "Terminal-Fenster"-Oberfläche zu unterstützen. Vom Parsen von Inhalten aus der G-Code-Terminalausgabe wird abgeraten. Verwenden Sie den Endpunkt "objects/subscribe", um Aktualisierungen zum Zustand von Klipper zu erhalten.

### motion_report/dump_stepper

Dieser Endpunkt dient zum Abonnieren des internen queue_step-Befehlsstroms von Klippers Schrittmotor-Warteschlange für einen Schrittmotor. Der Bezug dieser Low-Level-Bewegungsaktualisierungen kann für Diagnose- und Debugging-Zwecke nützlich sein. Die Nutzung dieses Endpunkts kann die Systemlast von Klipper erhöhen.

Eine Anfrage könnte etwa so aussehen: `{"id": 123, "method":"motion_report/dump_stepper", "params": {"name": "stepper_x", "response_template": {}}}` und könnte Folgendes zurückgeben: `{"id": 123, "result": {"header": ["interval", "count", "add"]}}` und später zu asynchronen Nachrichten führen wie: `{"params": {"first_clock": 179601081, "first_time": 8.98, "first_position": 0, "last_clock": 219686097, "last_time": 10.984, "data": [[179601081, 1, 0], [29573, 2, -8685], [16230, 4, -1525], [10559, 6, -160], [10000, 976, 0], [10000, 1000, 0], [10000, 1000, 0], [10000, 1000, 0], [9855, 5, 187], [11632, 4, 1534], [20756, 2, 9442]]}}`

Das Feld "header" in der ersten Abfrageantwort beschreibt die Felder, die in späteren "data"-Antworten enthalten sind.

### motion_report/dump_trapq

Dieser Endpunkt dient zum Abonnieren von Klippers interner "Trapez-Bewegungswarteschlange". Der Bezug dieser Low-Level-Bewegungsaktualisierungen kann für Diagnose- und Debugging-Zwecke nützlich sein. Die Nutzung dieses Endpunkts kann die Systemlast von Klipper erhöhen.

Eine Anfrage könnte etwa so aussehen: `{"id": 123, "method": "motion_report/dump_trapq", "params": {"name": "toolhead", "response_template":{}}}` und könnte Folgendes zurückgeben: `{"id": 1, "result": {"header": ["time", "duration", "start_velocity", "acceleration", "start_position", "direction"]}}` und später zu asynchronen Nachrichten führen wie: `{"params": {"data": [[4.05, 1.0, 0.0, 0.0, [300.0, 0.0, 0.0], [0.0, 0.0, 0.0]], [5.054, 0.001, 0.0, 3000.0, [300.0, 0.0, 0.0], [-1.0, 0.0, 0.0]]]}}`

Das Feld "header" in der ersten Abfrageantwort beschreibt die Felder, die in späteren "data"-Antworten enthalten sind.

### adxl345/dump_adxl345

Dieser Endpunkt dient zum Abonnieren von ADXL345-Beschleunigungssensordaten. Der Bezug dieser Low-Level-Bewegungsaktualisierungen kann für Diagnose- und Debugging-Zwecke nützlich sein. Die Nutzung dieses Endpunkts kann die Systemlast von Klipper erhöhen.

Eine Anfrage könnte etwa so aussehen: `{"id": 123, "method":"adxl345/dump_adxl345", "params": {"sensor": "adxl345", "response_template": {}}}` und könnte Folgendes zurückgeben: `{"id": 123,"result":{"header":["time","x_acceleration","y_acceleration", "z_acceleration"]}}` und später zu asynchronen Nachrichten führen wie: `{"params":{"overflows":0,"data":[[3292.432935,-535.44309,-1529.8374,9561.4], [3292.433256,-382.45935,-1606.32927,9561.48375]]}}`

Das Feld "header" in der ersten Abfrageantwort beschreibt die Felder, die in späteren "data"-Antworten enthalten sind.

### angle/dump_angle

Dieser Endpunkt dient zum Abonnieren von [Winkelsensordaten](Config_Reference.md#angle). Der Bezug dieser Low-Level-Bewegungsaktualisierungen kann für Diagnose- und Debugging-Zwecke nützlich sein. Die Nutzung dieses Endpunkts kann die Systemlast von Klipper erhöhen.

Eine Anfrage könnte etwa so aussehen: `{"id": 123, "method":"angle/dump_angle", "params": {"sensor": "my_angle_sensor", "response_template": {}}}` und könnte Folgendes zurückgeben: `{"id": 123,"result":{"header":["time","angle"]}}` und später zu asynchronen Nachrichten führen wie: `{"params":{"position_offset":3.151562,"errors":0, "data":[[1290.951905,-5063],[1290.952321,-5065]]}}`

Das Feld "header" in der ersten Abfrageantwort beschreibt die Felder, die in späteren "data"-Antworten enthalten sind.

### load_cell/dump_force

Dieser Endpunkt dient zum Abonnieren von Kraftdaten, die von einer load_cell erzeugt werden. Die Nutzung dieses Endpunkts kann die Systemlast von Klipper erhöhen.

Eine Anfrage könnte etwa so aussehen: `{"id": 123, "method":"load_cell/dump_force", "params": {"sensor": "load_cell", "response_template": {}}}` und könnte Folgendes zurückgeben: `{"id": 123,"result":{"header":["time", "force (g)", "counts", "tare_counts"]}}` und später zu asynchronen Nachrichten führen wie: `{"params":{"data":[[3292.432935, 40.65, 562534, -234467]]}}`

Das Feld "header" in der ersten Abfrageantwort beschreibt die Felder, die in späteren "data"-Antworten enthalten sind.

### load_cell_probe/dump_taps

Dieser Endpunkt dient zum Abonnieren von Details zu Sondierungs-"Tap"-Ereignissen. Die Nutzung dieses Endpunkts kann die Systemlast von Klipper erhöhen.

Eine Anfrage könnte etwa so aussehen: `{"id": 123, "method":"load_cell/dump_force", "params": {"sensor": "load_cell", "response_template": {}}}` und könnte Folgendes zurückgeben: `{"id": 123,"result":{"header":["probe_tap_event"]}}` und später zu asynchronen Nachrichten führen wie:

```
{"params":{"tap":'{
   "time": [118032.28039, 118032.2834, ...],
   "force": [-459.4213119680034, -458.1640702543264, ...],
}}}
```

Diese Daten können verwendet werden, um Folgendes darzustellen:

* Das Zeit-/Kraft-Diagramm

### pause_resume/cancel

Dieser Endpunkt ähnelt der Ausführung des G-Code-Befehls "PRINT_CANCEL". Zum Beispiel: `{"id": 123, "method": "pause_resume/cancel"}`

Wie beim Endpunkt "gcode/script" wird dieser Endpunkt erst abgeschlossen, nachdem alle ausstehenden G-Code-Befehle abgeschlossen wurden.

### pause_resume/pause

Dieser Endpunkt ähnelt der Ausführung des G-Code-Befehls "PAUSE". Zum Beispiel: `{"id": 123, "method": "pause_resume/pause"}`

Wie beim Endpunkt "gcode/script" wird dieser Endpunkt erst abgeschlossen, nachdem alle ausstehenden G-Code-Befehle abgeschlossen wurden.

### pause_resume/resume

Dieser Endpunkt ähnelt der Ausführung des G-Code-Befehls "RESUME". Zum Beispiel: `{"id": 123, "method": "pause_resume/resume"}`

Wie beim Endpunkt "gcode/script" wird dieser Endpunkt erst abgeschlossen, nachdem alle ausstehenden G-Code-Befehle abgeschlossen wurden.

### query_endstops/status

Dieser Endpunkt fragt die aktiven Endstops ab und gibt deren Status zurück. Zum Beispiel könnte `{"id": 123, "method": "query_endstops/status"}` Folgendes zurückgeben: `{"id": 123, "result": {"y": "open", "x": "open", "z": "TRIGGERED"}}`

Wie beim Endpunkt "gcode/script" wird dieser Endpunkt erst abgeschlossen, nachdem alle ausstehenden G-Code-Befehle abgeschlossen wurden.

### bed_mesh/dump_mesh

Gibt die Konfiguration und den Zustand des aktuellen Meshes sowie aller gespeicherten Profile aus.

Zum Beispiel: `{"id": 123, "method": "bed_mesh/dump_mesh"}`

könnte Folgendes zurückgeben:

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

Der Endpunkt `dump_mesh` nimmt einen optionalen Parameter `mesh_args` entgegen. Dieser Parameter muss ein Objekt sein, dessen Schlüssel und Werte den für [BED_MESH_CALIBRATE](#bed_mesh_calibrate) verfügbaren Parametern entsprechen. Damit werden die Mesh-Konfiguration und die Messpunkte anhand der übergebenen Parameter aktualisiert, bevor das Ergebnis zurückgegeben wird. Es empfiehlt sich, Mesh-Parameter wegzulassen, sofern Sie nicht die Messpunkte und/oder den Verfahrweg vor der Ausführung von `BED_MESH_CALIBRATE` sichtbar machen möchten.
