# Statusreferenz

Dieses Dokument ist eine Referenz für Druckerstatusinformationen, die in Klipper [Makros](Command_Templates.md), [Anzeigefelder](Config_Reference.md#display) und über den [API-Server](API_Server.md) verfügbar sind.

Die Felder in diesem Dokument können sich ändern - wenn Sie ein Attribut verwenden, stellen Sie sicher, dass Sie das [Config Changes document](Config_Changes.md) lesen, wenn Sie die Klipper Software aktualisieren.

## angle

Die folgenden Informationen sind in den Objekten [angle some_name](Config_Reference.md#angle) verfügbar:

- `temperature`: Der letzte Temperaturmesswert (in Grad Celsius) eines magnetischen tle5012b-Hallsensors. Dieser Wert ist nur verfügbar, wenn der Winkelsensor ein tle5012b-Chip ist und Messungen laufen (andernfalls wird `None` gemeldet).

## bed_mesh

Die folgenden Informationen sind im Objekt [bed_mesh](Config_Reference.md#bed_mesh) verfügbar:

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`: Informationen zum aktuell aktiven bed_mesh.
- `profiles`: Die Menge der aktuell definierten Profile, wie sie mit BED_MESH_PROFILE eingerichtet wurden.

## bed_screws

Die folgenden Informationen sind im Objekt [bed_screws](Config_Reference.md#bed_screws) verfügbar:

- `is_active`: Gibt True zurück, wenn das Werkzeug zur Justierung der Bettschrauben aktuell aktiv ist.
- `state`: Der Zustand des Werkzeugs zur Justierung der Bettschrauben. Es ist eine der folgenden Zeichenketten: "adjust", "fine".
- `current_screw`: Der Index der aktuell justierten Schraube.
- `accepted_screws`: Die Anzahl der akzeptierten Schrauben.

## canbus_stats

Die folgenden Informationen sind im Objekt `canbus_stats some_mcu_name` verfügbar (dieses Objekt ist automatisch verfügbar, wenn ein Mikrocontroller für die Nutzung von CANbus konfiguriert ist):

- `rx_error`: Die Anzahl der von der CANbus-Hardware des Mikrocontrollers erkannten Empfangsfehler.
- `tx_error`: Die Anzahl der von der CANbus-Hardware des Mikrocontrollers erkannten Sendefehler.
- `tx_retries`: Die Anzahl der Sendeversuche, die aufgrund von Buskonflikten oder Fehlern wiederholt wurden.
- `bus_state`: Der Zustand der Schnittstelle (typischerweise "active" für einen Bus im Normalbetrieb, "warn" für einen Bus mit kürzlich aufgetretenen Fehlern, "passive" für einen Bus, der keine CANbus-Fehlerframes mehr sendet, oder "off" für einen Bus, der keine Nachrichten mehr sendet oder empfängt).

Beachten Sie, dass nur die rp2XXX-Mikrocontroller ein von null verschiedenes Feld `tx_retries` melden und dass die rp2XXX-Mikrocontroller `tx_error` immer als null und `bus_state` immer als "active" melden.

## Konfigurationsdatei

Die folgenden Informationen sind im Objekt `configfile` verfügbar (dieses Objekt ist immer verfügbar):

- `settings.<section>.<option>`: Gibt die angegebene Einstellung aus der Konfigurationsdatei (oder deren Standardwert) zum Zeitpunkt des letzten Starts bzw. Neustarts der Software zurück. (Zur Laufzeit geänderte Einstellungen werden hier nicht berücksichtigt.)
- `config.<section>.<option>`: Gibt die angegebene Roh-Einstellung der Konfigurationsdatei zurück, wie sie von Klipper beim letzten Start bzw. Neustart der Software gelesen wurde. (Zur Laufzeit geänderte Einstellungen werden hier nicht berücksichtigt.) Alle Werte werden als Zeichenketten zurückgegeben.
- `save_config_pending`: Gibt True zurück, wenn Änderungen vorliegen, die ein `SAVE_CONFIG`-Befehl auf die Festplatte schreiben kann.
- `save_config_pending_items`: Enthält die Abschnitte und Optionen, die geändert wurden und durch ein `SAVE_CONFIG` dauerhaft gespeichert würden.
- `warnings`: Eine Liste von Warnungen zu Konfigurationsoptionen. Jeder Eintrag der Liste ist ein Dictionary mit den Feldern `type` und `message` (beides Zeichenketten). Je nach Art der Warnung können weitere Felder verfügbar sein.

## display_status

Die folgenden Informationen sind im Objekt `display_status` verfügbar (dieses Objekt ist automatisch verfügbar, wenn ein [display](Config_Reference.md#display) Konfigurationsabschnitt definiert ist):

- `progress`: Der Fortschrittswert des letzten `M73` G-Code-Befehls (oder `virtual_sdcard.progress`, wenn kein `M73` kürzlich empfangen wurde).
- `message`: Die im letzten `M117` G-Code-Befehl enthaltene Nachricht.

## endstop_phase

Die folgenden Informationen sind im Objekt [endstop_phase](Config_Reference.md#endstop_phase) verfügbar:

- `last_home.<stepper name>.phase`: Die Phase des Schrittmotors am Ende des letzten Homing-Versuchs.
- `last_home.<stepper name>.phases`: Die Gesamtzahl der am Schrittmotor verfügbaren Phasen.
- `last_home.<stepper name>.mcu_position`: Die Position des Schrittmotors (wie vom Mikrocontroller verfolgt) am Ende des letzten Homing-Versuchs. Die Position ist die Gesamtzahl der Schritte in Vorwärtsrichtung abzüglich der Gesamtzahl der Schritte in Rückwärtsrichtung seit dem letzten Neustart des Mikrocontrollers.

## exclude_object

Die folgenden Informationen sind im Objekt [exclude_object](Exclude_Object.md) verfügbar:

- `objects`: Ein Array der bekannten Objekte, wie sie durch den Befehl `EXCLUDE_OBJECT_DEFINE` bereitgestellt wurden. Dies sind dieselben Informationen, die der Befehl `EXCLUDE_OBJECT VERBOSE=1` liefert. Die Felder `center` und `polygon` sind nur vorhanden, wenn sie im ursprünglichen `EXCLUDE_OBJECT_DEFINE` angegeben wurden

   Hier ist eine JSON Beispiel:

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

- `excluded_objects`: Ein Array von Zeichenketten mit den Namen der ausgeschlossenen Objekte.
- `current_object`: Der Name des aktuell gedruckten Objekts.

## extruder_stepper

Die folgenden Informationen sind für extruder_stepper-Objekte (sowie für [extruder](Config_Reference.md#extruder)-Objekte) verfügbar:

- `pressure_advance`: Der aktuelle [pressure advance](Pressure_Advance.md) Wert.
- `smooth_time`: Die aktuelle Glättungszeit des Pressure Advance.
- `motion_queue`: Der Name des Extruders, mit dem dieser extruder_stepper aktuell synchronisiert ist. Wird als `None` gemeldet, wenn der extruder_stepper derzeit keinem Extruder zugeordnet ist.

## fan

Die folgenden Informationen sind in den Objekten [fan](Config_Reference.md#fan), [heater_fan some_name](Config_Reference.md#heater_fan) und [controller_fan some_name](Config_Reference.md#controller_fan) verfügbar:

- `speed`: Die Lüfterdrehzahl als Gleitkommazahl zwischen 0.0 und 1.0.
- `rpm`: Die gemessene Lüfterdrehzahl in Umdrehungen pro Minute, sofern für den Lüfter ein tachometer_pin definiert ist.

## filament_switch_sensor

Die folgenden Informationen sind in den Objekten [filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor) verfügbar:

- `enabled`: Gibt True zurück, wenn der Schaltsensor aktuell aktiviert ist.
- `filament_detected`: Gibt True zurück, wenn sich der Sensor im ausgelösten Zustand befindet.

## filament_motion_sensor

Die folgenden Informationen sind in den Objekten [filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor) verfügbar:

- `enabled`: Gibt True zurück, wenn der Bewegungssensor aktuell aktiviert ist.
- `filament_detected`: Gibt True zurück, wenn sich der Sensor im ausgelösten Zustand befindet.

## firmware_retraction

Die folgenden Informationen sind im Objekt [firmware_retraction](Config_Reference.md#firmware_retraction) verfügbar:

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`: Die aktuellen Einstellungen des firmware_retraction-Moduls. Diese Einstellungen können von der Konfigurationsdatei abweichen, wenn sie durch einen `SET_RETRACTION`-Befehl geändert wurden.

## gcode

The following information is available in the `gcode` object:

- `commands`: Returns a list of all currently available commands. For each command, if a help string is defined it will also be provided.

## gcode_button

Die folgenden Informationen sind in den Objekten [gcode_button some_name](Config_Reference.md#gcode_button) verfügbar:

- `state`: Der aktuelle Zustand der Taste, zurückgegeben als "PRESSED" oder "RELEASED"

## gcode_macro

Die folgenden Informationen sind in den Objekten [gcode_macro some_name](Config_Reference.md#gcode_macro) verfügbar:

- `<variable>`: Der aktuelle Wert von [gcode_macro variable](Command_Templates.md#variables).

## gcode_move

Die folgenden Informationen sind im Objekt `gcode_move` verfügbar (dieses Objekt ist immer verfügbar):

- `gcode_position`: The current position of the toolhead relative to the current G-Code origin. That is, positions that one might directly send to a `G1` command. This value is encoded as a [coordinate](#accessing-coordinates).
- `position`: The last commanded position of the toolhead using the coordinate system specified in the config file. This value is encoded as a [coordinate](#accessing-coordinates).
- `homing_origin`: The origin of the gcode coordinate system (relative to the coordinate system specified in the config file) to use after a `G28` command. The `SET_GCODE_OFFSET` command can alter this position. This value is encoded as a [coordinate](#accessing-coordinates).
- `speed`: Die zuletzt in einem `G1`-Befehl gesetzte Geschwindigkeit (in mm/s).
- `speed_factor`: Die durch einen `M220`-Befehl gesetzte "Geschwindigkeitsübersteuerung". Dies ist eine Gleitkommazahl, wobei 1.0 keine Übersteuerung bedeutet und beispielsweise 2.0 die angeforderte Geschwindigkeit verdoppeln würde.
- `extrude_factor`: Die durch einen `M221`-Befehl gesetzte "Extrusionsübersteuerung". Dies ist eine Gleitkommazahl, wobei 1.0 keine Übersteuerung bedeutet und beispielsweise 2.0 die angeforderte Extrusion verdoppeln würde.
- `absolute_coordinates`: Gibt True zurück, wenn der absolute Koordinatenmodus `G90` aktiv ist, oder False im relativen Modus `G91`.
- `absolute_extrude`: Gibt True zurück, wenn der absolute Extrusionsmodus `M82` aktiv ist, oder False im relativen Modus `M83`.
- `axis_map`: Provides a mechanism for finding the coordinate component for a given G-Code id that is used in `G1` commands. See the [Accessing Coordinates](#accessing-coordinates) section for details.

## hall_filament_width_sensor

Die folgenden Informationen sind im Objekt [hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor) verfügbar:

- alle Einträge aus [filament_switch_sensor](Status_Reference.md#filament_switch_sensor)
- `is_active`: Gibt True zurück, wenn der Sensor aktuell aktiv ist.
- `flow_compensation_enabled`: Returns True if flow compensation is enabled.
- `Diameter`: Returns the last width reading in mm if the sensor is active or the nominal filament diameter if it is not.
- `Raw`: Der letzte ADC-Rohwert des Sensors.

## heater

Die folgenden Informationen sind für Heizungsobjekte wie [extruder](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed) und [heater_generic](Config_Reference.md#heater_generic) verfügbar:

- `temperature`: Die zuletzt gemeldete Temperatur (als Gleitkommazahl in Grad Celsius) der jeweiligen Heizung.
- `target`: Die aktuelle Zieltemperatur (als Gleitkommazahl in Grad Celsius) der jeweiligen Heizung.
- `power`: Die letzte Einstellung des mit der Heizung verbundenen PWM-Pins (ein Wert zwischen 0.0 und 1.0).
- `can_extrude`: Ob der Extruder extrudieren kann (festgelegt durch `min_extrude_temp`), nur verfügbar für [extruder](Config_Reference.md#extruder)

## heaters

Die folgenden Informationen sind im Objekt `heaters` verfügbar (dieses Objekt ist verfügbar, wenn eine Heizung definiert ist):

- `available_heaters`: Gibt eine Liste aller aktuell verfügbaren Heizungen anhand ihrer vollständigen Konfigurationsabschnittsnamen zurück, z. B. `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `available_sensors`: Gibt eine Liste aller aktuell verfügbaren Temperatursensoren anhand ihrer vollständigen Konfigurationsabschnittsnamen zurück, z. B. `["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"]`.
- `available_monitors`: Gibt eine Liste aller aktuell verfügbaren Temperaturmonitore anhand ihrer vollständigen Konfigurationsabschnittsnamen zurück, z. B. `["tmc2240 stepper_x"]`. Während ein Temperatursensor immer ausgelesen werden kann, ist ein Temperaturmonitor unter Umständen nicht verfügbar und gibt in diesem Fall null zurück.

## idle_timeout

Die folgenden Informationen sind im Objekt [idle_timeout](Config_Reference.md#idle_timeout) verfügbar (dieses Objekt ist immer verfügbar):

- `state`: Der aktuelle Zustand des Druckers, wie ihn das idle_timeout-Modul verfolgt. Es ist eine der folgenden Zeichenketten: "Idle", "Printing", "Ready".
- `printing_time`: Die Zeitspanne (in Sekunden), die sich der Drucker im Zustand "Printing" befunden hat (wie vom idle_timeout-Modul verfolgt).
- `idle_timeout`: The current 'timeout' (in seconds) to wait for the gcode to be triggered. (as set by [SET_IDLE_TIMEOUT](G-Codes.md#set_idle_timeout))

## led

Die folgenden Informationen sind für jeden in printer.cfg definierten Konfigurationsabschnitt `[led led_name]`, `[neopixel led_name]`, `[dotstar led_name]`, `[pca9533 led_name]` und `[pca9632 led_name]` verfügbar:

- `color_data`: A list of color lists containing the RGBW values for a led in the chain. Each value is represented as a float from 0.0 to 1.0. Each color list contains 4 items (red, green, blue, white) even if the underlying LED supports fewer color channels. For example, the blue value (3rd item in color list) of the second neopixel in a chain could be accessed at `printer["neopixel <config_name>"].color_data[1][2]`.

## load_cell

Die folgenden Informationen sind für jedes `[load_cell name]` verfügbar:

- `is_calibrated`: True/False whether the load cell is calibrated.
- `counts_per_gram`: The number of raw sensor counts that equals 1 gram of force.
- `reference_tare_counts`: The reference number of raw sensor counts for 0 force.
- `tare_counts`: The current number of raw sensor counts for 0 force.
- `force_g`: The force in grams, averaged over the last polling period.
- `min_force_g`: The minimum force in grams, over the last polling period.
- `max_force_g`: The maximum force in grams, over the last polling period.
- `errors`: The number of sensor errors detected since the last start of measurements.
- `overflows`: The number of data buffer overflows detected since the last start of measurements.
- `sample_rate`: The sensor's sample rate in samples per second.

## load_cell_probe

Die folgenden Informationen sind für `[load_cell_probe]` verfügbar:

- alle Einträge aus [load_cell](Status_Reference.md#load_cell)
- alle Einträge aus [probe](Status_Reference.md#probe)
- `endstop_tare_counts`: The load cell probe keeps a tare value independent of the load cell. This is re-set at the start of each probe.
- `last_trigger_time`: Timestamp of the last homing trigger.
- `last_z_result`: The Z position result of the last tap.
- `is_last_tap_valid`: True if the last tap result is valid.

## manual_probe

Die folgenden Informationen sind im Objekt `manual_probe` verfügbar:

- `is_active`: Gibt True zurück, wenn aktuell ein Hilfsskript zum manuellen Abtasten aktiv ist.
- `z_position`: Die aktuelle Höhe der Düse (so wie der Drucker sie derzeit annimmt).
- `z_position_lower`: Letzter Abtastversuch knapp unterhalb der aktuellen Höhe.
- `z_position_upper`: Letzter Abtastversuch knapp oberhalb der aktuellen Höhe.

## mcu

Die folgenden Informationen sind in den Objekten [mcu](Config_Reference.md#mcu) und [mcu some_name](Config_Reference.md#mcu-my_extra_mcu) verfügbar:

- `mcu_version`: Die vom Mikrocontroller gemeldete Version des Klipper-Codes.
- `mcu_build_versions`: Informationen über die Build-Werkzeuge, mit denen der Mikrocontroller-Code erzeugt wurde (wie vom Mikrocontroller gemeldet).
- `mcu_constants.<constant_name>`: Vom Mikrocontroller gemeldete Kompilierzeit-Konstanten. Die verfügbaren Konstanten können sich zwischen Mikrocontroller-Architekturen und mit jeder Code-Revision unterscheiden.
- `last_stats.<statistics_name>`: Statistikinformationen über die Mikrocontroller Verbindung.

## motion_report

Die folgenden Informationen sind im Objekt `motion_report` verfügbar (dieses Objekt ist automatisch verfügbar, wenn ein Schrittmotor-Konfigurationsabschnitt definiert ist):

- `live_position`: The requested toolhead position interpolated to the current time. This value is encoded as a [coordinate](#accessing-coordinates).
- `live_velocity`: Die angefragte Geschwindigkeit des Druckkopfs (in mm/s) zum aktuellen Zeitpunkt.
- `live_extruder_velocity`: Die angefragte Extrudergeschwindigkeit (in mm/s) zum aktuellen Zeitpunkt.

## output_pin

The following information is available in [output_pin some_name](Config_Reference.md#output_pin) and [pwm_tool some_name](Config_Reference.md#pwm_tool) objects:

- `value`: Der "Wert" des Pins, wie er durch einen `SET_PIN`-Befehl gesetzt wurde.

## palette2

Die folgenden Informationen sind im Objekt [palette2](Config_Reference.md#palette2) verfügbar:

- `ping`: Wert des zuletzt gemeldeten Palette-2-Pings in Prozent.
- `remaining_load_length`: Beim Start eines Palette-2-Drucks ist dies die Menge an Filament, die in den Extruder geladen werden muss.
- `is_splicing`: True, wenn die Palette 2 gerade Filament spleißt.

## pause_resume

Die folgenden Informationen sind im Objekt [pause_resume](Config_Reference.md#pause_resume) verfügbar:

- `is_paused`: Gibt True zurück, wenn ein PAUSE-Befehl ohne zugehörigen RESUME-Befehl ausgeführt wurde.

## print_stats

Die folgenden Informationen sind im Objekt `print_stats` verfügbar (dieses Objekt ist automatisch verfügbar, wenn ein [virtual_sdcard](Config_Reference.md#virtual_sdcard) Konfigurationsabschnitt definiert ist):

- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message`: Geschätzte Informationen zum aktuellen Druck, während ein virtual_sdcard-Druck aktiv ist.
- `info.total_layer`: Der Wert für die Gesamtzahl der Schichten aus dem letzten `SET_PRINT_STATS_INFO TOTAL_LAYER=<value>` G-Code-Befehl.
- `info.current_layer`: Der Wert für die aktuelle Schicht aus dem letzten `SET_PRINT_STATS_INFO CURRENT_LAYER=<value>` G-Code-Befehl.

## probe

Die folgenden Informationen sind im Objekt [probe](Config_Reference.md#probe) verfügbar (dieses Objekt ist auch verfügbar, wenn ein [bltouch](Config_Reference.md#bltouch) Konfigurationsabschnitt definiert ist):

- `name`: Gibt den Namen der verwendeten Sonde zurück.
- `last_query`: Gibt True zurück, wenn die Sonde während des letzten QUERY_PROBE-Befehls als "ausgelöst" gemeldet wurde. Hinweis: Wird dies in einem Makro verwendet, muss der QUERY_PROBE-Befehl aufgrund der Reihenfolge der Template-Expansion vor dem Makro ausgeführt werden, das diese Referenz enthält.
- `last_probe_position`: The results of the last `PROBE` command. This value is encoded as a [coordinate](#accessing-coordinates). The probe hardware estimates that if one were to command the toolhead to XY position `last_probe_position.x`,`last_probe_position.y` and descend then the tip of the toolhead would first contact the bed at a Z height of `last_probe_position.z`. These coordinates are relative to the frame (that is, they use the coordinate system specified in the config file). Note, if this is used in a macro, due to the order of template expansion, the `PROBE` command must be run prior to the macro containing this reference.
- `last_z_result`: This value is deprecated; it will be removed in the near future.

## pwm_cycle_time

Die folgenden Informationen sind in den Objekten [pwm_cycle_time some_name](Config_Reference.md#pwm_cycle_time) verfügbar:

- `value`: Der "Wert" des Pins, wie er durch einen `SET_PIN`-Befehl gesetzt wurde.

## quad_gantry_level

Die folgenden Informationen sind im Objekt `quad_gantry_level` verfügbar (dieses Objekt ist verfügbar, wenn quad_gantry_level definiert ist):

- `applied`: True, wenn der Nivelliervorgang des Portals ausgeführt und erfolgreich abgeschlossen wurde.

## query_endstops

Die folgenden Informationen sind im Objekt `query_endstops` verfügbar (dieses Objekt ist verfügbar, wenn ein Endschalter definiert ist):

- `last_query["<endstop>"]`: Gibt True zurück, wenn der angegebene Endschalter während des letzten QUERY_ENDSTOP-Befehls als "ausgelöst" gemeldet wurde. Hinweis: Wird dies in einem Makro verwendet, muss der QUERY_ENDSTOP-Befehl aufgrund der Reihenfolge der Template-Expansion vor dem Makro ausgeführt werden, das diese Referenz enthält.

## screws_tilt_adjust

Die folgenden Informationen sind im Objekt `screws_tilt_adjust` verfügbar:

- `error`: Gibt True zurück, wenn der letzte `SCREWS_TILT_CALCULATE`-Befehl den Parameter `MAX_DEVIATION` enthielt und einer der abgetasteten Schraubpunkte die angegebene `MAX_DEVIATION` überschritten hat.
- `max_deviation`: Gibt den letzten `MAX_DEVIATION`-Wert des jüngsten `SCREWS_TILT_CALCULATE`-Befehls zurück.
- `results["<screw>"]`: Ein Dictionary mit den folgenden Schlüsseln:
   - `z`: Die gemessene Z-Höhe an der Schraubenposition.
   - `sign`: Eine Zeichenkette, die die Drehrichtung für die notwendige Justierung angibt. Entweder "CW" für im Uhrzeigersinn oder "CCW" für gegen den Uhrzeigersinn.
   - `adjust`: Die Anzahl der Schraubendrehungen zur Justierung der Schraube, angegeben im Format "HH:MM", wobei "HH" die Anzahl der vollen Schraubendrehungen und "MM" die "Minuten auf einem Zifferblatt" für eine Teildrehung angibt. (Zum Beispiel würde "01:15" bedeuten, die Schraube um eineinviertel Umdrehungen zu drehen.)
   - `is_base`: Gibt True zurück, wenn dies die Basisschraube ist.

## servo

Die folgenden Informationen sind in den Objekten [servo some_name](Config_Reference.md#servo) verfügbar:

- `printer["servo <config_name>"].value`: Die letzte Einstellung des mit dem Servo verbundenen PWM-Pins (ein Wert zwischen 0.0 und 1.0).

## skew_correction.py

Die folgenden Informationen sind im Objekt `skew_correction` verfügbar (dieses Objekt ist verfügbar, wenn eine skew_correction definiert ist):

- `current_profile_name`: Gibt den Namen des aktuell geladenen SKEW_PROFILE zurück.

## stepper_enable

Die folgenden Informationen sind im Objekt `stepper_enable` verfügbar (dieses Objekt ist verfügbar, wenn ein Schrittmotor definiert ist):

- `steppers["<stepper>"]`: Gibt True zurück, wenn der angegebene Schrittmotor aktiviert ist.

## system_stats

Die folgenden Informationen sind im Objekt `system_stats` verfügbar (dieses Objekt ist immer verfügbar):

- `sysload`, `cputime`, `memavail`: Informationen zum Betriebssystem des Hosts und zur Prozesslast.

## Temperatur Sensoren

Folgende Informationen sind verfügbar in

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [sht3x config_section_name](Config_Reference.md#sht31-sensor), [lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor), [temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) und [temperature_combined config_section_name](Config_Reference.md#combined-temperature-sensor) Objekte:

- `temperature`: Die letzte vom Sensor gelesene Temperatur.
- `humidity`, `pressure`, `gas`: Die zuletzt vom Sensor gelesenen Werte (nur bei bme280-, htu21d-, sht3x- und lm75-Sensoren).

## temperature_fan

Die folgenden Informationen sind in den Objekten [temperature_fan some_name](Config_Reference.md#temperature_fan) verfügbar:

- `temperature`: Die letzte vom Sensor gelesene Temperatur.
- `target`: Die Zieltemperatur für den Lüfter.

## temperature_sensor

Die folgenden Informationen sind in den Objekten [temperature_sensor some_name](Config_Reference.md#temperature_sensor) verfügbar:

- `temperature`: Die letzte vom Sensor gelesene Temperatur.
- `measured_min_temp`, `measured_max_temp`: Die niedrigste und die höchste vom Sensor gemessene Temperatur seit dem letzten Neustart der Klipper-Host-Software.

## tmc treiber

Die folgenden Informationen sind in den Objekten der [TMC-Schrittmotortreiber](Config_Reference.md#tmc-stepper-driver-configuration) verfügbar (z. B. `[tmc2208 stepper_x]`):

- `mcu_phase_offset`: Die Schrittmotorposition des Mikrocontrollers, die der "Null"-Phase des Treibers entspricht. Dieses Feld kann null sein, wenn der Phasenversatz nicht bekannt ist.
- `phase_offset_position`: Die "angefragte Position", die der "Null"-Phase des Treibers entspricht. Dieses Feld kann null sein, wenn der Phasenversatz nicht bekannt ist.
- `drv_status`: Die Ergebnisse der letzten Statusabfrage des Treibers. (Es werden nur Felder ungleich null gemeldet.) Dieses Feld ist null, wenn der Treiber nicht aktiviert ist (und daher nicht regelmäßig abgefragt wird).
- `temperature`: Die vom Treiber gemeldete interne Temperatur. Dieses Feld ist null, wenn der Treiber nicht aktiviert ist oder wenn der Treiber keine Temperaturmeldung unterstützt.
- `run_current`: Der aktuell eingestellte Betriebsstrom.
- `hold_current`: Der aktuell eingestellte Haltestrom.

## toolhead

Die folgenden Informationen sind im Objekt `toolhead` verfügbar (dieses Objekt ist immer verfügbar):

- `position`: The last commanded position of the toolhead relative to the coordinate system specified in the config file. This value is encoded as a [coordinate](#accessing-coordinates).
- `extruder`: Der Name des aktuell aktiven Extruders. In einem Makro könnte man beispielsweise `printer[printer.toolhead.extruder].target` verwenden, um die Zieltemperatur des aktuellen Extruders zu erhalten.
- `homed_axes`: Die kartesischen Achsen, die aktuell als "gehomt" gelten. Dies ist eine Zeichenkette, die eines oder mehrere der Zeichen "x", "y", "z" enthält.
- `axis_minimum`, `axis_maximum`: The axis travel limits (mm) after homing. This value is encoded as a [coordinate](#accessing-coordinates).
- Bei Delta-Druckern ist `cone_start_z` die maximale Z-Höhe beim maximalen Radius (`printer.toolhead.cone_start_z`).
- `max_velocity`, `max_accel`, `minimum_cruise_ratio`, `square_corner_velocity`: Die aktuell wirksamen Druckgrenzwerte. Diese können von den Einstellungen der Konfigurationsdatei abweichen, wenn ein `SET_VELOCITY_LIMIT`-Befehl (oder `M204`) sie zur Laufzeit ändert.
- `stalls`: Die Gesamtzahl der Fälle (seit dem letzten Neustart), in denen der Drucker angehalten werden musste, weil sich der Druckkopf schneller bewegte, als Bewegungen aus der G-Code-Eingabe gelesen werden konnten.
- `extra_axes`: Provides a mechanism for finding the coordinate component for extra axes available in standard `G1` type move commands. See the [Accessing Coordinates](#accessing-coordinates) section for details.

## dual_carriage

Die folgenden Informationen sind in [dual_carriage](Config_Reference.md#dual_carriage) bei einem kartesischen, hybrid_corexy- oder hybrid_corexz-Drucker verfügbar

- `carriage_0`: Der Modus von Schlitten 0. Mögliche Werte sind: "INACTIVE" und "PRIMARY".
- `carriage_1`: Der Modus von Schlitten 1. Mögliche Werte sind: "INACTIVE", "PRIMARY", "COPY" und "MIRROR".

Bei einer `generic_cartesian`-Kinematik sind die folgenden Informationen in `dual_carriage` verfügbar:

- `carriages["<carriage>"]`: Der Modus des Schlittens `<carriage>`. Mögliche Werte sind "INACTIVE" und "PRIMARY" für den primären Schlitten sowie "INACTIVE", "PRIMARY", "COPY" und "MIRROR" für den zweiten Schlitten.

## virtual_sdcard

Die folgenden Informationen sind im Objekt [virtual_sdcard](Config_Reference.md#virtual_sdcard) verfügbar:

- `is_active`: Gibt True zurück, wenn aktuell ein Druck aus einer Datei aktiv ist.
- `progress`: Eine Schätzung des aktuellen Druckfortschritts (basierend auf Dateigröße und Dateiposition).
- `file_path`: Der vollständige Pfad zur aktuell geladenen Datei.
- `file_position`: Die aktuelle Position (in Bytes) eines laufenden Drucks.
- `file_size`: Die Dateigröße (in Bytes) der aktuell geladenen Datei.

## webhooks

Die folgenden Informationen sind im Objekt `webhooks` verfügbar (dieses Objekt ist immer verfügbar):

- `state`: Gibt eine Zeichenkette zurück, die den aktuellen Klipper-Zustand angibt. Mögliche Werte sind: "ready", "startup", "shutdown", "error".
- `state_message`: Eine für Menschen lesbare Zeichenkette mit zusätzlichem Kontext zum aktuellen Klipper-Zustand.

## z_thermal_adjust

Die folgenden Informationen sind im Objekt `z_thermal_adjust` verfügbar (dieses Objekt ist verfügbar, wenn [z_thermal_adjust](Config_Reference.md#z_thermal_adjust) definiert ist).

- `enabled`: Gibt True zurück, wenn die Anpassung aktiviert ist.
- `temperature`: Aktuelle (geglättete) Temperatur des definierten Sensors. [degC]
- `measured_min_temp`: Minimal gemessene Temperatur. [degC]
- `measured_max_temp`: Maximal gemessene Temperatur. [degC]
- `current_z_adjust`: Zuletzt berechnete Z-Anpassung [mm].
- `z_adjust_ref_temperature`: Aktuelle Referenztemperatur, die zur Berechnung von `current_z_adjust` verwendet wird [degC].

## z_tilt

Die folgenden Informationen sind im Objekt `z_tilt` verfügbar (dieses Objekt ist verfügbar, wenn z_tilt definiert ist):

- `applied`: True, wenn der Z-Tilt-Nivelliervorgang ausgeführt und erfolgreich abgeschlossen wurde.

## Accessing Coordinates

Some status fields provide a "coordinate". For macro users these fields may be accessed by component name (eg,`{printer.toolhead.position.x}`), where the component name may be "x", "y", or "z".

For developers using the Klipper API Server these fields are transmitted as a list - for example: `{"toolhead": {"position": [1.0, 2.0, 3.0, 7.3, 19.2]}}` . The first three components of the list correspond with the x, y, and z axes.

A coordinate will typically have at least 3 components (x, y, and z), however there may also be additional components. Care should be taken when accessing any of these additional components as the ordering and number of components may change at run-time.

One may use `{printer.gcode_move.axis_map}` and/or `{printer.toolhead.extra_axes}` to determine the number of components and the ordering of components. For example, to access the "E" component one could use `{printer.toolhead.position[printer.gcode_move.axis_map.E]}`. Or, if one wanted to find the component associated with the "extruder" object, one could use `{printer.toolhead.position[printer.toolhead.extra_axes.extruder]}`.
