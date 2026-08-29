# G-Codes

Dieses Dokument beschreibt die von Klipper unterstützten Befehle. Dies sind Befehle, die man auf der OctoPrint Registerkarte Terminals eingeben kann.

## G-code Befehle

Klipper unterstützt die unten aufgelisteten G-Code Befehle:

- Bewegung (G0 oder G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- Dwell: `G4 P<milliseconds>`
- Zum Nullpunkt fahren: `G28 [X] [Y] [Z]`
- Motoren abschalten: `M18` oder `M84`
- Abwarten, bis die aktuellen Bewegungen beendet sind: `M400`
- Absolute/relative Abstände für die Extrusion verwenden: `M82`, `M83`
- Absolute/relative Koordinaten verwenden: `G90`, `G91`
- Position festlegen: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- Prozentuale Überschreibung des Geschwindigkeitsfaktors einstellen: `M220 S<percent>`
- Prozentuale Überschreibung des Extrusionsfaktors einstellen: `M221 S<percent>`
- Beschleunigung setzen: `M204 S<value>` ODER `M204 P<value> T<value>`
   - Hinweis: Wird S nicht angegeben und sind sowohl P als auch T angegeben, so wird die Beschleunigung auf das Minimum von P und T gesetzt. Ist nur P oder nur T angegeben, hat der Befehl keine Wirkung.
- Extrudertemperatur anzeigen: `M105`
- Extrudertemperatur einstellen: `M104 [T<index>] [S<temperature>]`
- Extruder-Temperatur setzen und warten: `M109 [T<index>] S<temperature>`
   - Hinweis: M109 wartet immer, bis sich die Temperatur auf dem angeforderten Wert eingependelt hat
- Druckbetttemperatur einstellen: `M140 [S<temperature>]`
- Betttemperatur einstellen und abwarten: `M190 S<temperature>`
   - Hinweis: M190 wartet immer, bis sich die Temperatur auf dem angeforderten Wert eingependelt hat
- Lüftergeschwindigkeit einstellen: `M106 S<value>`
- Lüfter ausschalten: `M107`
- Notausschalter: `M112`
- Aktuelle Position anzeigen: `M114`
- Firmware Version anzeigen: `M115`

Weitere Einzelheiten zu den oben genannten Befehlen finden Sie in der [RepRap-G-Code-Dokumentation](http://reprap.org/wiki/G-code).

Klipper hat zum Ziel, die G-Code-Befehle zu unterstützen, die von verbreiteter Drittanbietersoftware (z. B. OctoPrint, Printrun, Slic3r, Cura usw.) in deren Standardkonfiguration erzeugt werden. Es ist nicht das Ziel, jeden denkbaren G-Code-Befehl zu unterstützen. Klipper setzt stattdessen auf gut lesbare ["erweiterte G-Code-Befehle"](#additional-commands). Ebenso ist die G-Code-Terminalausgabe ausschließlich für die Lesbarkeit durch Menschen gedacht – wenn Sie Klipper aus externer Software heraus steuern möchten, siehe das [Dokument zum API-Server](API_Server.md).

Wenn Sie einen weniger verbreiteten G-Code-Befehl benötigen, lässt er sich unter Umständen mit einem eigenen [gcode_macro-Konfigurationsabschnitt](Config_Reference.md#gcode_macro) umsetzen. So könnte man damit beispielsweise `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1` usw. implementieren.

## Weitere Befehle

Klipper verwendet "erweiterte" G-Code-Befehle für die allgemeine Konfiguration und Statusabfrage. Diese erweiterten Befehle folgen alle einem ähnlichen Format: Sie beginnen mit einem Befehlsnamen, auf den ein oder mehrere Parameter folgen können. Zum Beispiel: `SET_SERVO SERVO=myservo ANGLE=5.3`. In diesem Dokument werden Befehle und Parameter in Großbuchstaben dargestellt, sie sind jedoch nicht case-sensitiv. ("SET_SERVO" und "set_servo" führen also denselben Befehl aus.)

Dieser Abschnitt ist nach Klipper-Modulnamen gegliedert, die in der Regel den Abschnittsnamen aus der [Druckerkonfigurationsdatei](Config_Reference.md) entsprechen. Beachten Sie, dass einige Module automatisch geladen werden.

### [adxl345]

Die folgenden Befehle stehen zur Verfügung, wenn ein [adxl345-Konfigurationsabschnitt](Config_Reference.md#adxl345) aktiviert ist.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: Startet Beschleunigungsmessungen mit der angeforderten Anzahl von Messwerten pro Sekunde. Wird CHIP nicht angegeben, gilt standardmäßig "adxl345". Der Befehl arbeitet im Start-Stopp-Modus: Beim ersten Aufruf startet er die Messungen, beim nächsten Aufruf stoppt er sie. Die Messergebnisse werden in eine Datei namens `/tmp/adxl345-<chip>-<name>.csv` geschrieben, wobei `<chip>` der Name des Beschleunigungssensor-Chips ist (`my_chip_name` aus `[adxl345 my_chip_name]`) und `<name>` dem optionalen Parameter NAME entspricht. Wird NAME nicht angegeben, wird standardmäßig die aktuelle Zeit im Format "YYYYMMDD_HHMMSS" verwendet. Hat der Beschleunigungssensor in seinem Konfigurationsabschnitt keinen Namen (einfach `[adxl345]`), entfällt der Teil `<chip>` im Dateinamen.

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: Fragt den aktuellen Wert des Beschleunigungssensors ab. Wird CHIP nicht angegeben, gilt standardmäßig "adxl345". Wird RATE nicht angegeben, wird der Standardwert verwendet. Dieser Befehl eignet sich, um die Verbindung zum ADXL345-Beschleunigungssensor zu testen: Einer der zurückgegebenen Werte sollte der Erdbeschleunigung entsprechen (zuzüglich/abzüglich eines gewissen Rauschens des Chips).

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`: queries ADXL345 register "register" (e.g. 44 or 0x2C). Kann für Debugging Zwecke nützlich sein

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<register> VAL=<value>`: Schreibt den Rohwert "value" in ein Register "register". Sowohl "value" als auch "register" können eine dezimale oder hexadezimale Ganzzahl sein. Verwenden Sie es mit Vorsicht und konsultieren Sie das Datenblatt des ADXL345 für weitere Informationen.

### [angle]

Die folgenden Befehle stehen zur Verfügung, wenn ein [angle-Konfigurationsabschnitt](Config_Reference.md#angle) aktiviert ist.

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<chip_name>`: Führt eine Winkelkalibrierung für den angegebenen Sensor durch (es muss einen Konfigurationsabschnitt `[angle chip_name]` geben, in dem ein `stepper`-Parameter angegeben ist). WICHTIG: Dieses Werkzeug lässt den Schrittmotor verfahren, ohne die üblichen kinematischen Grenzen zu prüfen. Idealerweise sollte der Motor vor der Kalibrierung von jedem Druckerschlitten getrennt werden. Lässt sich der Schrittmotor nicht vom Drucker trennen, achten Sie darauf, dass sich der Schlitten vor dem Start der Kalibrierung nahe der Mitte seiner Schiene befindet. (Der Schrittmotor kann sich während dieses Tests um zwei volle Umdrehungen vorwärts oder rückwärts bewegen.) Verwenden Sie nach Abschluss des Tests den Befehl `SAVE_CONFIG`, um die Kalibrierdaten in die Konfigurationsdatei zu schreiben. Für dieses Werkzeug muss das Python-Paket "numpy" installiert sein (weitere Informationen finden Sie im [Dokument zum Messen von Resonanzen](Measuring_Resonances.md#software-installation)).

#### ANGLE_CHIP_CALIBRATE

`ANGLE_CHIP_CALIBRATE CHIP=<chip_name>`: Führt die interne Sensorkalibrierung durch, sofern implementiert (MT6826S/MT6835).

- **MT68XX**: Der Motor sollte vor der Durchführung der Kalibrierung von jeglichem Druckerschlitten getrennt werden. Nach der Kalibrierung sollte der Sensor durch Trennen der Stromversorgung zurückgesetzt werden.

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: Fragt das Sensorregister "register" ab (z. B. 44 oder 0x2C). Das kann zu Debugging-Zwecken nützlich sein. Nur für tle5012b-Chips verfügbar.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: Schreibt den Rohwert "value" in das Register "register". Sowohl "value" als auch "register" können eine dezimale oder hexadezimale Ganzzahl sein. Mit Vorsicht verwenden und im Datenblatt des Sensors nachschlagen. Nur für tle5012b-Chips verfügbar.

### [axis_twist_compensation]

The following commands are available when the [axis_twist_compensation config
section](Config_Reference.md#axis_twist_compensation) is enabled.

#### AXIS_TWIST_COMPENSATION_CALIBRATE

`AXIS_TWIST_COMPENSATION_CALIBRATE [AXIS=<X|Y>] [SAMPLE_COUNT=<value>]`

Kalibriert die Kompensation der Achsenverdrehung, indem die Zielachse angegeben oder die automatische Kalibrierung aktiviert wird.

- **AXIS:** Legt die Achse (`X` oder `Y`) fest, für die die Verdrehungskompensation kalibriert wird. Wird sie nicht angegeben, lautet der Standardwert `'X'`.

### [bed_mesh]

Die folgenden Befehle stehen zur Verfügung, wenn der [bed_mesh-Konfigurationsabschnitt](Config_Reference.md#bed_mesh) aktiviert ist (siehe auch die [Bed-Mesh-Anleitung](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [PROFILE=<name>] [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=1] [ADAPTIVE_MARGIN=<value>]`: Dieser Befehl sondiert das Bett anhand der in der Konfiguration angegebenen, generierten Punkte. Nach der Sondierung wird ein Mesh erzeugt und die Z-Bewegung entsprechend diesem Mesh angepasst. Das Mesh ist unmittelbar nach erfolgreichem Abschluss von `BED_MESH_CALIBRATE` aktiv. Das Mesh wird in einem durch den Parameter `PROFILE` angegebenen Profil gespeichert, oder in `default`, falls nicht angegeben. Wird ADAPTIVE=1 angegeben, beginnt der Profilname mit `adaptive-` und sollte nicht zur Wiederverwendung gespeichert werden. Details zu den optionalen Sondierungsparametern finden Sie beim Befehl PROBE. Wird METHOD=manual angegeben, wird das manuelle Sondierungswerkzeug aktiviert - siehe den obigen Befehl MANUAL_PROBE für Details zu den zusätzlichen Befehlen, die während der Aktivität dieses Werkzeugs verfügbar sind. Der optionale Wert `HORIZONTAL_MOVE_Z` überschreibt die in der Konfigurationsdatei angegebene Option `horizontal_move_z`. Wird ADAPTIVE=1 angegeben, werden die im gedruckten G-Code definierten Objekte verwendet, um den sondierten Bereich festzulegen. Der optionale Wert `ADAPTIVE_MARGIN` überschreibt die in der Konfigurationsdatei angegebene Option `adaptive_margin`.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`: Dieser Befehl gibt die aktuell abgetasteten Z-Werte sowie die aktuellen Mesh-Werte im Terminal aus. Wird PGP=1 angegeben, werden zusätzlich die von bed_mesh erzeugten X- und Y-Koordinaten samt zugehöriger Indizes im Terminal ausgegeben.

#### BED_MESH_MAP

`BED_MESH_MAP`: Wie BED_MESH_OUTPUT gibt dieser Befehl den aktuellen Zustand des Meshes im Terminal aus. Statt die Werte in einem menschenlesbaren Format auszugeben, wird der Zustand im JSON-Format serialisiert. Dadurch können OctoPrint-Plugins die Daten einfach erfassen und Höhenkarten erzeugen, die die Bettoberfläche annähern.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: Dieser Befehl löscht das Mesh und entfernt sämtliche Z-Anpassungen. Es empfiehlt sich, ihn in den End-G-Code aufzunehmen.

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<name> SAVE=<name> REMOVE=<name>`: Dieser Befehl bietet eine Profilverwaltung für den Mesh-Zustand. LOAD stellt den Mesh-Zustand aus dem Profil mit dem angegebenen Namen wieder her. SAVE speichert den aktuellen Mesh-Zustand in einem Profil mit dem angegebenen Namen. REMOVE löscht das Profil mit dem angegebenen Namen aus dem persistenten Speicher. Beachten Sie, dass nach SAVE- oder REMOVE-Vorgängen der G-Code SAVE_CONFIG ausgeführt werden muss, damit die Änderungen im persistenten Speicher dauerhaft übernommen werden.

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value]`: Wendet X-, Y- und/oder ZFADE-Versätze auf die Mesh-Abfrage an. Dies ist bei Druckern mit unabhängigen Extrudern nützlich, da nach einem Werkzeugwechsel ein Versatz erforderlich ist, um die korrekte Z-Anpassung zu erzielen. Beachten Sie, dass ein ZFADE-Versatz keine zusätzliche Z-Anpassung direkt bewirkt; er dient dazu, die `fade`-Berechnung zu korrigieren, wenn ein `gcode offset` auf die Z-Achse angewendet wurde.

### [bed_screws]

Die folgenden Befehle stehen zur Verfügung, wenn der [bed_screws-Konfigurationsabschnitt](Config_Reference.md#bed_screws) aktiviert ist (siehe auch die [Anleitung zum manuellen Nivellieren](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`: Dieser Befehl startet das Werkzeug zum Justieren der Bettschrauben. Es fährt die Düse an verschiedene Positionen (wie in der Konfigurationsdatei festgelegt) und ermöglicht es, die Bettschrauben so einzustellen, dass das Bett überall den gleichen Abstand zur Düse hat.

### [bed_tilt]

Die folgenden Befehle stehen zur Verfügung, wenn der [bed_tilt-Konfigurationsabschnitt](Config_Reference.md#bed_tilt) aktiviert ist.

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Dieser Befehl tastet die in der Konfiguration angegebenen Punkte ab und empfiehlt anschließend aktualisierte Neigungsanpassungen für X und Y. Details zu den optionalen Sondenparametern finden Sie beim Befehl PROBE. Wird METHOD=manual angegeben, wird das manuelle Abtastwerkzeug aktiviert – Einzelheiten zu den zusätzlichen Befehlen, die bei aktivem Werkzeug zur Verfügung stehen, finden Sie oben beim Befehl MANUAL_PROBE. Der optionale Wert `HORIZONTAL_MOVE_Z` überschreibt die in der Konfigurationsdatei angegebene Option `horizontal_move_z`.

### [bltouch]

Der folgende Befehl steht zur Verfügung, wenn ein [bltouch-Konfigurationsabschnitt](Config_Reference.md#bltouch) aktiviert ist (siehe auch die [BL-Touch-Anleitung](BLTouch.md)).

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<command>`: Sendet einen Befehl an den BLTouch. Das kann zur Fehlersuche nützlich sein. Verfügbare Befehle sind: `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`. Ein BL-Touch V3.0 oder V3.1 unterstützt möglicherweise zusätzlich die Befehle `set_5V_output_mode`, `set_OD_output_mode` und `output_mode_store`.

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`: Speichert einen Ausgabemodus im EEPROM eines BLTouch V3.1. Verfügbare output_modes sind: `5V`, `OD`

### [configfile]

Das configfile Modul wird automatisch geladen.

#### SAVE_CONFIG

`SAVE_CONFIG`: Dieser Befehl überschreibt die Hauptkonfigurationsdatei des Druckers und startet die Host-Software neu. Er wird zusammen mit anderen Kalibrierbefehlen verwendet, um die Ergebnisse von Kalibriertests zu speichern.

### [delayed_gcode]

Der folgende Befehl ist verfügbar, wenn ein [delayed_gcode-Konfigurationsabschnitt](Config_Reference.md#delayed_gcode) aktiviert wurde (siehe auch die [Vorlagen-Anleitung](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: Aktualisiert die Verzögerungsdauer für den angegebenen [delayed_gcode] und startet den Timer für die G-Code-Ausführung. Der Wert 0 verhindert die Ausführung eines anstehenden verzögerten G-Codes.

### [delta_calibrate]

Die folgenden Befehle stehen zur Verfügung, wenn der [delta_calibrate-Konfigurationsabschnitt](Config_Reference.md#linear-delta-kinematics) aktiviert ist (siehe auch die [Anleitung zur Delta-Kalibrierung](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Dieser Befehl tastet sieben Punkte auf dem Bett ab und empfiehlt aktualisierte Endschalterpositionen, Turmwinkel und Radius. Details zu den optionalen Sondenparametern finden Sie beim Befehl PROBE. Wird METHOD=manual angegeben, wird das manuelle Abtastwerkzeug aktiviert – Einzelheiten zu den zusätzlichen Befehlen, die bei aktivem Werkzeug zur Verfügung stehen, finden Sie oben beim Befehl MANUAL_PROBE. Der optionale Wert `HORIZONTAL_MOVE_Z` überschreibt die in der Konfigurationsdatei angegebene Option `horizontal_move_z`.

#### DELTA_ANALYZE

`DELTA_ANALYZE`: Dieser Befehl wird bei der erweiterten Delta-Kalibrierung verwendet. Einzelheiten finden Sie unter [Delta Calibrate](Delta_Calibrate.md).

### [display]

Der folgende Befehl steht zur Verfügung, wenn ein [display-Konfigurationsabschnitt](Config_Reference.md#gcode_macro) aktiviert ist.

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`: Legt die aktive Anzeigegruppe eines LCD-Displays fest. Damit lassen sich in der Konfiguration mehrere Anzeigedatengruppen definieren, z. B. `[display_data <group> <elementname>]`, zwischen denen mit diesem erweiterten G-Code-Befehl umgeschaltet werden kann. Wird DISPLAY nicht angegeben, gilt standardmäßig "display" (das primäre Display).

### [display_status]

Das Modul display_status wird automatisch geladen, wenn ein [display-Konfigurationsabschnitt](Config_Reference.md#display) aktiviert ist. Es stellt die folgenden Standard-G-Code-Befehle bereit:

- Nachricht anzeigen: `M117 <Nachricht >`
- Baufortschritt in Prozent setzen: `M73 P<percent>`

Außerdem gibt es den folgenden erweiterten G-Code-Befehl:

- `SET_DISPLAY_TEXT MSG=<message>`: Führt das Äquivalent zu M117 aus und setzt das übergebene `MSG` als aktuelle Displaynachricht. Wird `MSG` weggelassen, wird das Display geleert.

### [dual_carriage]

Der folgende Befehl steht zur Verfügung, wenn der [dual_carriage-Konfigurationsabschnitt](Config_Reference.md#dual_carriage) aktiviert ist.

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=<carriage> [MODE=[PRIMARY|COPY|MIRROR|INACTIVE]]`: Dieser Befehl ändert den Modus des angegebenen Schlittens. Wird kein `MODE` angegeben, ist `PRIMARY` der Standardwert. `<carriage>` muss auf einen definierten primären oder Dual-Schlitten für `generic_cartesian`-Kinematik verweisen oder bei allen anderen IDEX-unterstützenden Kinematiken 0 (für den primären Schlitten) oder 1 (für den Dual-Schlitten) sein. Das Setzen des Modus auf `PRIMARY` deaktiviert alle anderen Schlitten derselben Achse und lässt den angegebenen Schlitten nachfolgende G-Code-Bewegungsbefehle unverändert ausführen. Bevor der Modus `COPY` oder `MIRROR` für einen Schlitten aktiviert wird, muss ein anderer Schlitten auf derselben Achse als `PRIMARY` aktiviert sein. In einem dieser beiden Modi folgt der Schlitten den nachfolgenden G-Code-Bewegungen und kopiert entweder relative Bewegungen (im Modus `COPY`) oder führt sie in entgegengesetzter (gespiegelter) Richtung aus (im Modus `MIRROR`). Das Setzen des Modus auf `INACTIVE` deaktiviert den Schlitten und lässt ihn weitere G-Code-Bewegungen ignorieren. Beachten Sie, dass das Deaktivieren des primären Schlittens einer Achse andere im Modus `COPY` oder `MIRROR` arbeitende Schlitten nicht deaktiviert; dies kann genutzt werden, um den Druck eines fehlgeschlagenen Teils mit einem beliebigen Werkzeug zu stoppen und dieses Werkzeug zu parken, um Kollisionen mit einem unvollendeten Teil zu vermeiden - siehe diese [Beispielkonfiguration](../config/sample-corexyuv.cfg) für Makrobeispiele.

#### SAVE_DUAL_CARRIAGE_STATE

`SAVE_DUAL_CARRIAGE_STATE [NAME=<state_name>]`: Speichert die aktuellen Positionen der beiden Schlitten sowie deren Modi. Das Speichern und Wiederherstellen des DUAL_CARRIAGE-Zustands kann in Skripten und Makros sowie in überschriebenen Homing-Routinen nützlich sein. Wird NAME angegeben, kann der gespeicherte Zustand mit der angegebenen Zeichenkette benannt werden. Wird NAME nicht angegeben, lautet der Standardwert "default".

#### RESTORE_DUAL_CARRIAGE_STATE

`RESTORE_DUAL_CARRIAGE_STATE [NAME=<state_name>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: Stellt die zuvor gespeicherten Zustände aller Dual-Schlitten und ihrer primären Schlitten wieder her. Dieser Befehl stellt die Modi der Schlitten wieder her und bewegt sie an ihre zuvor gespeicherten Positionen, sofern nicht "MOVE=0" angegeben ist. Werden Positionen wiederhergestellt und ist "MOVE_SPEED" angegeben, bewegen sich die Schlitten mit höchstens der angegebenen Geschwindigkeit (in mm/s); andernfalls dienen die Homing-Geschwindigkeiten der jeweiligen Schlitten als Referenz. Beachten Sie, dass die Schlitten ihre Positionen nur entlang ihrer eigenen Achsen wiederherstellen, was notwendig sein kann, um den COPY- und MIRROR-Modus des Dual-Schlittens korrekt wiederherzustellen. Zusätzlich aktualisiert dieser Befehl die Klipper-Werkzeugkopfposition für jede Achse mit Dual-Schlitten: Sie wird auf die tatsächliche Position des aktivierten primären Schlittens einer Achse gesetzt, oder, falls eine Achse keinen gespeicherten primären Schlitten hat, auf die Achsposition zum Zeitpunkt des Aufrufs von `SAVE_DUAL_CARRIAGE_STATE`.

### [endstop_phase]

Die folgenden Befehle stehen zur Verfügung, wenn ein [endstop_phase-Konfigurationsabschnitt](Config_Reference.md#endstop_phase) aktiviert ist (siehe auch die [Anleitung zur Endschalterphase](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]`: Wird kein STEPPER-Parameter angegeben, meldet dieser Befehl Statistiken zu den Schrittmotorphasen an den Endschaltern während der vergangenen Homing-Vorgänge. Wird ein STEPPER-Parameter angegeben, sorgt der Befehl dafür, dass die ermittelte Endschalter-Phaseneinstellung in die Konfigurationsdatei geschrieben wird (zusammen mit dem Befehl SAVE_CONFIG).

### [exclude_object]

Die folgenden Befehle stehen zur Verfügung, wenn ein [exclude_object-Konfigurationsabschnitt](Config_Reference.md#exclude_object) aktiviert ist (siehe auch die [Anleitung zu Exclude Object](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=object_name] [CURRENT=1] [RESET=1]`: Ohne Parameter gibt dieser Befehl eine Liste aller derzeit ausgeschlossenen Objekte zurück.

Wenn der Parameter `NAME` angegeben wird, wird das benannte Objekt vom Druck ausgeschlossen.

Wenn der Parameter `CURRENT` angegeben wird, wird das aktuelle Objekt vom Druck ausgeschlossen.

Wenn der Parameter `RESET` angegeben wird, wird die Liste der ausgeschlossenen Objekte geleert. Wird zusätzlich `NAME` angegeben, so wird nur das benannte Objekt zurückgesetzt. Dies **kann** zu fehlerhaften Drucken führen, wenn bereits Schichten übersprungen wurden.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=object_name [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`: Liefert eine Zusammenfassung eines Objekts in der Datei.

Ohne angegebene Parameter werden die Klipper bekannten definierten Objekte aufgelistet. Gibt eine Liste von Zeichenketten zurück, sofern nicht der Parameter `JSON` angegeben wird; in diesem Fall werden die Objektdetails im JSON-Format zurückgegeben.

Wenn der Parameter `NAME` enthalten ist, definiert dies ein Objekt, das ausgeschlossen werden kann.

- `NAME`: Dieser Parameter ist erforderlich. Er ist der Bezeichner, der von anderen Befehlen dieses Moduls verwendet wird.
- `CENTER`: Eine X,Y-Koordinate für das Objekt.
- `POLYGON`: Ein Array von X,Y-Koordinaten, die einen Umriss des Objekts beschreiben.

Wenn der Parameter `RESET` angegeben wird, werden alle definierten Objekte gelöscht und das Modul `[exclude_object]` wird zurückgesetzt.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=object_name`: Dieser Befehl erwartet einen Parameter `NAME` und kennzeichnet den Beginn des G-Codes für ein Objekt auf der aktuellen Schicht.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=object_name]`: Kennzeichnet das Ende des G-Codes des Objekts für die Schicht. Er bildet ein Paar mit `EXCLUDE_OBJECT_START`. Ein Parameter `NAME` ist optional und führt lediglich zu einer Warnung, wenn der angegebene Name nicht mit dem aktuellen Objekt übereinstimmt.

### [extruder]

Die folgenden Befehle stehen zur Verfügung, wenn ein [extruder-Konfigurationsabschnitt](Config_Reference.md#extruder) aktiviert ist:

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: Bei einem Drucker mit mehreren [extruder](Config_Reference.md#extruder)-Konfigurationsabschnitten wechselt dieser Befehl das aktive Hotend.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Setzt die Pressure-Advance-Parameter eines Extruder-Schrittmotors (wie in einem Konfigurationsabschnitt [extruder](Config_Reference.md#extruder) oder [extruder_stepper](Config_Reference.md#extruder_stepper) definiert). Wird EXTRUDER nicht angegeben, wird standardmäßig der im aktiven Hotend definierte Schrittmotor verwendet.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: Setzt einen neuen Wert für die "rotation distance" des angegebenen Extruder-Schrittmotors (wie in einem Konfigurationsabschnitt [extruder](Config_Reference.md#extruder) oder [extruder_stepper](Config_Reference.md#extruder_stepper) definiert). Ist die Rotationsdistanz eine negative Zahl, wird die Bewegung des Schrittmotors invertiert (relativ zur in der Konfigurationsdatei angegebenen Motorrichtung). Geänderte Einstellungen bleiben nach einem Klipper-Reset nicht erhalten. Verwenden Sie dies mit Vorsicht, da kleine Änderungen zu übermäßigem Druck zwischen Extruder und Hotend führen können. Führen Sie vor der Verwendung eine ordnungsgemäße Kalibrierung mit Filament durch. Wird kein Wert für 'DISTANCE' angegeben, gibt dieser Befehl die aktuelle Rotationsdistanz zurück.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<name> MOTION_QUEUE=<name>`: Dieser Befehl bewirkt, dass der durch EXTRUDER angegebene Schrittmotor (wie in einem Konfigurationsabschnitt [extruder](Config_Reference.md#extruder) oder [extruder_stepper](Config_Reference.md#extruder_stepper) definiert) mit der Bewegung des durch MOTION_QUEUE angegebenen Extruders (wie in einem Konfigurationsabschnitt [extruder](Config_Reference.md#extruder) definiert) synchronisiert wird. Ist MOTION_QUEUE eine leere Zeichenkette, wird der Schrittmotor von jeglicher Extruderbewegung entkoppelt.

### [fan_generic]

Der folgende Befehl steht zur Verfügung, wenn ein [fan_generic-Konfigurationsabschnitt](Config_Reference.md#fan_generic) aktiviert ist.

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<speed>` Dieser Befehl legt die Drehzahl eines Lüfters fest. "speed" muss zwischen 0.0 und 1.0 liegen.

`SET_FAN_SPEED FAN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: Wird `TEMPLATE` angegeben, weist dies dem jeweiligen Lüfter ein [display_template](Config_Reference.md#display_template) zu. Wurde beispielsweise ein Konfigurationsabschnitt `[display_template my_fan_template]` definiert, könnte hier `TEMPLATE=my_fan_template` zugewiesen werden. Das display_template sollte eine Zeichenkette mit einer Fließkommazahl des gewünschten Werts erzeugen. Das Template wird fortlaufend ausgewertet, und der Lüfter wird automatisch auf die resultierende Geschwindigkeit gesetzt. Für die Template-Auswertung können display_template-Parameter gesetzt werden (die Parameter werden als Python-Literale interpretiert). Ist TEMPLATE ein leerer String, löscht dieser Befehl ein zuvor dem Pin zugewiesenes Template (die Werte können dann über `SET_FAN_SPEED`-Befehle direkt verwaltet werden).

### [filament_switch_sensor]

Der folgende Befehl steht zur Verfügung, wenn ein Konfigurationsabschnitt [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) oder [filament_motion_sensor](Config_Reference.md#filament_motion_sensor) aktiviert ist.

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`: Fragt den aktuellen Status des Filamentsensors ab. Welche Daten im Terminal angezeigt werden, hängt vom in der Konfiguration festgelegten Sensortyp ab.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]`: Schaltet den Filamentsensor ein oder aus. Bei ENABLE=0 wird der Filamentsensor deaktiviert, bei 1 aktiviert.

### [firmware_retraction]

Die folgenden Standard-G-Code-Befehle stehen zur Verfügung, wenn der [firmware_retraction-Konfigurationsabschnitt](Config_Reference.md#firmware_retraction) aktiviert ist. Mit diesen Befehlen können Sie die in vielen Slicern verfügbare Firmware-Retract-Funktion nutzen, um Fadenziehen bei Bewegungen ohne Extrusion von einem Teil des Drucks zum nächsten zu verringern. Ein passend konfigurierter Pressure Advance verkürzt die erforderliche Einzugslänge.

- `G10`: Zieht das Filament im Extruder mit den aktuell konfigurierten Parametern ein.
- `G11`: Schiebt das Filament im Extruder mit den aktuell konfigurierten Parametern wieder vor.

Die folgenden weiteren Befehle sind ebenfalls verfügbar.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>]`: Passt die Parameter an, die für den Firmware-Retract verwendet werden. RETRACT_LENGTH bestimmt die Filamentlänge, die eingezogen und wieder ausgegeben wird. Die Einzugsgeschwindigkeit wird über RETRACT_SPEED eingestellt und üblicherweise recht hoch gewählt. Die Geschwindigkeit beim Zurückschieben wird über UNRETRACT_SPEED eingestellt und ist nicht besonders kritisch, liegt aber häufig unter RETRACT_SPEED. In manchen Fällen ist es sinnvoll, beim Zurückschieben eine kleine zusätzliche Länge zu ergänzen; diese wird über UNRETRACT_EXTRA_LENGTH festgelegt. SET_RETRACTION wird üblicherweise im Rahmen der filamentspezifischen Slicer-Konfiguration gesetzt, da unterschiedliche Filamente unterschiedliche Parameterwerte erfordern.

#### GET_RETRACTION

`GET_RETRACTION`: Fragt die aktuell für den Firmware-Retract verwendeten Parameter ab und zeigt sie im Terminal an.

### [force_move]

Das Modul force_move wird automatisch geladen, einige Befehle erfordern jedoch das Setzen von `enable_force_move` in der [Druckerkonfiguration](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<config_name>`: Bewegt den angegebenen Schrittmotor einen Millimeter vorwärts und anschließend einen Millimeter rückwärts, insgesamt zehnmal. Dies ist ein Diagnosewerkzeug, mit dem sich die Anbindung eines Schrittmotors überprüfen lässt.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]`: Dieser Befehl bewegt den angegebenen Schrittmotor zwangsweise um die angegebene Strecke (in mm) mit der angegebenen konstanten Geschwindigkeit (in mm/s). Wird ACCEL angegeben und ist größer als null, wird die angegebene Beschleunigung (in mm/s^2) verwendet; andernfalls findet keine Beschleunigung statt. Es werden keine Grenzwerte geprüft, keine kinematischen Aktualisierungen vorgenommen, und weitere parallele Schrittmotoren einer Achse werden nicht mitbewegt. Seien Sie vorsichtig, denn ein falscher Befehl kann Schäden verursachen! Die Verwendung dieses Befehls versetzt die Low-Level-Kinematik fast sicher in einen falschen Zustand; setzen Sie anschließend ein G28 ab, um die Kinematik zurückzusetzen. Dieser Befehl ist für Low-Level-Diagnose und Debugging gedacht.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] [SET_HOMED=<[X][Y][Z]>] [CLEAR_HOMED=<[X][Y][Z]>]`: Zwingt den Low-Level-Kinematikcode dazu anzunehmen, dass sich der Druckkopf an der angegebenen kartesischen Position befindet, und setzt bzw. löscht den Homing-Status. Dies ist ein Diagnose- und Debugging-Befehl; verwenden Sie für reguläre Achsentransformationen SET_GCODE_OFFSET und/oder G92. Das Setzen einer falschen oder ungültigen Position kann zu internen Softwarefehlern führen.

Die Parameter `X`, `Y` und `Z` dienen dazu, die Low-Level-Positionsverfolgung der Kinematik zu verändern. Wird einer dieser Parameter nicht gesetzt, bleibt die entsprechende Position unverändert – beispielsweise würde `SET_KINEMATIC_POSITION Z=10` alle Achsen als gehomt kennzeichnen, die interne Z-Position auf 10 setzen und die X- und Y-Positionen unverändert lassen. Das Ändern der internen Positionsverfolgung ist unabhängig vom internen Homing-Status – man kann die Position sowohl für gehomte als auch für nicht gehomte Achsen ändern und ebenso den Homing-Status einer Achse setzen oder löschen, ohne ihre interne Position zu verändern.

Der Parameter `SET_HOMED` lautet standardmäßig `XYZ`, wodurch die Kinematik alle Achsen als gehomt betrachtet. Ein Befehl `SET_KINEMATIC_POSITION` ohne weitere Angaben führt dazu, dass alle Achsen als gehomt gelten (ohne die aktuelle Position zu ändern). Ist es nicht erwünscht, den Zustand der gehomten Achsen zu ändern, so weisen Sie `SET_HOMED` eine leere Zeichenkette zu – zum Beispiel: `SET_KINEMATIC_POSITION SET_HOMED= X=10`. Es ist auch möglich, eine einzelne Achse als gehomt zu kennzeichnen (z. B. `SET_HOMED=X`); beachten Sie jedoch, dass nicht-kartesische Kinematiken (etwa Delta-Kinematiken) das Setzen einer einzelnen Achse als gehomt möglicherweise nicht unterstützen.

Der Parameter `CLEAR_HOMED` weist die Kinematik an, die angegebenen Achsen als nicht gehomt zu betrachten. Beispielsweise würde `CLEAR_HOMED=XYZ` bewirken, dass alle Achsen als nicht gehomt gelten (und somit vor einer Bewegung auf diesen Achsen ein Homing erforderlich ist). Der Standardwert ist `SET_HOMED=XYZ`, selbst wenn `CLEAR_HOMED` vorhanden ist; der Befehl `SET_KINEMATIC_POSITION CLEAR_HOMED=Z` setzt daher X und Y als gehomt und löscht den Homing-Status für Z. Verwenden Sie `SET_KINEMATIC_POSITION SET_HOMED= CLEAR_HOMED=Z`, wenn nur der Homing-Status von Z gelöscht werden soll. Wird eine Achse weder in `SET_HOMED` noch in `CLEAR_HOMED` angegeben, bleibt ihr Homing-Status unverändert; wird sie in beiden angegeben, hat `CLEAR_HOMED` Vorrang. Es ist möglich, das Löschen einer einzelnen Achse anzufordern, jedoch kann dies bei nicht-kartesischen Kinematiken (etwa Delta-Kinematiken) dazu führen, dass der Homing-Status weiterer Achsen gelöscht wird. Beachten Sie, dass der Parameter `CLEAR` derzeit ein Alias für den Parameter `CLEAR_HOMED` ist, dieser Alias jedoch künftig entfernt wird.

### [gcode]

Das gcode Modul wird automatisch geladen.

#### RESTART

`RESTART`: Veranlasst die Host-Software, ihre Konfiguration neu zu laden und einen internen Reset durchzuführen. Dieser Befehl löscht weder den Fehlerzustand des Mikrocontrollers (siehe FIRMWARE_RESTART) noch lädt er neue Software (siehe [die FAQ](FAQ.md#how-do-i-upgrade-to-the-latest-software)).

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`: Ähnlich wie der Befehl RESTART, löscht zusätzlich jedoch auch einen etwaigen Fehlerzustand des Mikrocontrollers.

#### STATUS

`STATUS`: Bericht über den Status der Klipper-Hostsoftware.

#### HELP

`HELP`: Zeigt die Liste der verfügbaren erweiterten G-Code Befehle.

### [gcode_arcs]

Die folgenden Standard-G-Code-Befehle stehen zur Verfügung, wenn ein [gcode_arcs-Konfigurationsabschnitt](Config_Reference.md#gcode_arcs) aktiviert ist:

- Kreisbewegung im Uhrzeigersinn (G2), Kreisbewegung gegen den Uhrzeigersinn (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`
- Auswahl der Kreisebene: G17 (XY-Ebene), G18 (XZ-Ebene), G19 (YZ-Ebene)

### [gcode_macro]

Der folgende Befehl steht zur Verfügung, wenn ein [gcode_macro-Konfigurationsabschnitt](Config_Reference.md#gcode_macro) aktiviert ist (siehe auch die [Anleitung zu Befehlsvorlagen](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`: Mit diesem Befehl lässt sich der Wert einer gcode_macro-Variablen zur Laufzeit ändern. Der angegebene VALUE wird als Python-Literal ausgewertet.

### [gcode_move]

Das gcode_move Modul wird automatisch geladen.

#### GET_POSITION

`GET_POSITION`: Gibt Informationen zur aktuellen Position des Druckkopfs zurück. Weitere Informationen finden Sie in der Entwicklerdokumentation zur [GET_POSITION-Ausgabe](Code_Overview.md#coordinate-systems).

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Legt einen Positionsversatz fest, der auf künftige G-Code-Befehle angewendet wird. Dies wird häufig genutzt, um den Z-Bettversatz virtuell zu ändern oder um beim Wechsel des Extruders XY-Versätze der Düse zu setzen. Wird beispielsweise "SET_GCODE_OFFSET Z=0.2" gesendet, werden künftige G-Code-Bewegungen um 0,2 mm in der Z-Höhe angehoben. Werden Parameter im Stil von X_ADJUST verwendet, wird die Anpassung zu einem bereits bestehenden Versatz addiert (z. B. ergäbe "SET_GCODE_OFFSET Z=-0.2" gefolgt von "SET_GCODE_OFFSET Z_ADJUST=0.3" einen Gesamt-Z-Versatz von 0.1). Wird "MOVE=1" angegeben, wird eine Druckkopfbewegung ausgeführt, um den angegebenen Versatz anzuwenden (andernfalls wird der Versatz bei der nächsten absoluten G-Code-Bewegung wirksam, die die betreffende Achse angibt). Wird "MOVE_SPEED" angegeben, erfolgt die Druckkopfbewegung mit der angegebenen Geschwindigkeit (in mm/s); andernfalls wird die zuletzt angegebene G-Code-Geschwindigkeit verwendet.

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<state_name>]`: Speichert den aktuellen Zustand der G-Code-Koordinatenauswertung. Das Speichern und Wiederherstellen des G-Code-Zustands ist in Skripten und Makros nützlich. Dieser Befehl speichert den aktuellen absoluten G-Code-Koordinatenmodus (G90/G91), den absoluten Extrusionsmodus (M82/M83), den Ursprung (G92), den Versatz (SET_GCODE_OFFSET), die Geschwindigkeitsübersteuerung (M220), die Extruder-Übersteuerung (M221), die Bewegungsgeschwindigkeit, die aktuelle XYZ-Position sowie die relative Extruder-Position "E". Wird NAME angegeben, kann der gespeicherte Zustand mit der angegebenen Zeichenkette benannt werden. Ohne NAME wird "default" verwendet.

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Stellt einen zuvor mit SAVE_GCODE_STATE gespeicherten Zustand wieder her. Wird "MOVE=1" angegeben, wird eine Druckkopfbewegung ausgeführt, um zur vorherigen XYZ-Position zurückzukehren. Wird "MOVE_SPEED" angegeben, erfolgt die Druckkopfbewegung mit der angegebenen Geschwindigkeit (in mm/s); andernfalls wird die wiederhergestellte G-Code-Geschwindigkeit verwendet.

### [generic_cartesian]

Die Befehle in diesem Abschnitt sind automatisch verfügbar, wenn `kinematics: generic_cartesian` als Drucker-Kinematik angegeben ist.

#### SET_STEPPER_CARRIAGES

`SET_STEPPER_CARRIAGES STEPPER=<stepper_name> CARRIAGES=<carriages> [DISABLE_CHECKS=[0|1]]`: Legt die Schlitten (Carriages) eines Schrittmotors fest oder aktualisiert sie. `<stepper_name>` muss auf einen in der printer.cfg definierten, existierenden Schrittmotor verweisen, und `<carriages>` beschreibt die Schlitten, die der Schrittmotor bewegt. Eine ausführlichere Übersicht über den Parameter `carriages` im Konfigurationsabschnitt des Schrittmotors finden Sie unter [Generic Cartesian Kinematics](Config_Reference.md#generic-cartesian-kinematics). Beachten Sie, dass mit diesem Befehl nur die Koeffizienten oder Vorzeichen der Schlitten geändert werden können, ein Anwender kann jedoch keine Schlitten hinzufügen oder entfernen, die der Schrittmotor steuert.

`SET_STEPPER_CARRIAGES` ist ein fortgeschrittenes Werkzeug, und dem Anwender wird äußerste Vorsicht bei dessen Verwendung nahegelegt, da eine falsche Konfiguration den Drucker physisch beschädigen kann.

Beachten Sie, dass `SET_STEPPER_CARRIAGES` nach der Änderung bestimmte interne Prüfungen der neuen Drucker-Kinematik durchführt. Beachten Sie, dass die Drucker-Kinematik bei erkannten Problemen in einem ungültigen Zustand verbleiben kann. Das bedeutet: Meldet `SET_STEPPER_CARRIAGES` einen Fehler, ist es unsicher, weitere G-Code-Befehle auszugeben. Der Anwender muss die Fehlermeldung prüfen und entweder das Problem beheben oder die vorherige Konfiguration der Schrittmotoren manuell wiederherstellen.

Da `SET_STEPPER_CARRIAGES` jeweils nur die Konfiguration eines einzelnen Schrittmotors aktualisieren kann, können manche Änderungsabfolgen zu ungültigen Zwischenzuständen der Kinematik führen, selbst wenn die endgültige Konfiguration gültig ist. In solchen Fällen kann ein Anwender bei allen bis auf den letzten Befehl den Parameter `DISABLE_CHECKS=1` übergeben, um die Zwischenprüfungen zu deaktivieren. Haben `stepper a` und `stepper b` beispielsweise anfangs die Schlitten `carriage_x-carriage_y` bzw. `carriage_x+carriage_y`, lässt sich mit folgender Befehlsfolge die Schlittensteuerung effektiv tauschen: `SET_STEPPER_CARRIAGES STEPPER=a CARRIAGES=carriage_x+carriage_y DISABLE_CHECKS=1` und `SET_STEPPER_CARRIAGES STEPPER=b CARRIAGES=carriage_x-carriage_y`, wobei der endgültige Kinematikzustand weiterhin validiert wird.

### [hall_filament_width_sensor]

Die folgenden Befehle stehen zur Verfügung, wenn der Konfigurationsabschnitt [tsl1401cl filament width sensor](Config_Reference.md#tsl1401cl_filament_width_sensor) oder [hall filament width sensor](Config_Reference.md#hall_filament_width_sensor) aktiviert ist (siehe auch [TSLl401CL Filament Width Sensor](TSL1401CL_Filament_Width_Sensor.md) und [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)):

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`: Gibt die aktuell gemessene Filamentbreite, den Zustand des Breitensensors, den Zustand des Filamentsensors sowie den Zustand der Durchflusskompensation zurück.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`: Löscht alle Sensormesswerte. Hilfreich nach einem Filamentwechsel. Setzt die Flussrate auf 100% zurück.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`: Schaltet den Filamentbreitensensor aus und verwendet ihn nicht mehr für die Durchflusskompensation. Setzt die Flussrate auf 100% zurück.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR [FLOW_COMPENSATION=[0|1]`: Schaltet den Filamentbreitensensor ein und aktiviert oder deaktiviert die Durchflusskompensation. Wird `FLOW_COMPENSATION` nicht angegeben, bleibt der aktuelle Zustand der Durchflusskompensation erhalten.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`: Gibt die aktuellen Messwerte des ADC-Kanals sowie den ROH-Sensorwert für Kalibrierpunkte zurück.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`: Durchmesserprotokollierung einschalten.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`:  Schaltet die Protokollierung des Durchmessers aus.

### [heaters]

Das Modul heaters wird automatisch geladen, wenn in der Konfigurationsdatei eine Heizung definiert ist.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`: Schaltet alle Heizelemente aus.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Wartet, bis der angegebene Temperatursensor den angegebenen MINIMUM-Wert erreicht oder überschreitet und/oder den angegebenen MAXIMUM-Wert erreicht oder unterschreitet.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<heater_name> [TARGET=<target_temperature>]`: Setzt die Zieltemperatur für eine Heizung. Wird keine Zieltemperatur angegeben, ist das Ziel 0.

### [idle_timeout]

Das idle_timeout Modul wird automatisch geladen.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: Ermöglicht es, das Leerlauf-Timeout (in Sekunden) festzulegen.

### [input_shaper]

Der folgende Befehl ist verfügbar, wenn ein [input_shaper-Konfigurationsabschnitt](Config_Reference.md#input_shaper) aktiviert wurde (siehe auch die [Anleitung zur Resonanzkompensation](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [SHAPER_FREQ_Y=<shaper_freq_z>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [DAMPING_RATIO_Z=<damping_ratio_z>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>] [SHAPER_TYPE_Z=<shaper_type_z>]`: Ändert die Input-Shaper-Parameter. Beachten Sie, dass der Parameter SHAPER_TYPE den Input Shaper für alle Achsen zurücksetzt, selbst wenn im Abschnitt [input_shaper] unterschiedliche Shaper-Typen konfiguriert wurden. SHAPER_TYPE kann nicht zusammen mit SHAPER_TYPE_X, SHAPER_TYPE_Y oder SHAPER_TYPE_Z verwendet werden. Weitere Details zu diesen Parametern finden Sie in der [Konfigurationsreferenz](Config_Reference.md#input_shaper).

### [led]

Der folgende Befehl steht zur Verfügung, wenn einer der [led-Konfigurationsabschnitte](Config_Reference.md#leds) aktiviert ist.

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: Legt die LED-Ausgabe fest. Jeder Farbwert `<value>` muss zwischen 0.0 und 1.0 liegen. Die Option WHITE ist nur bei RGBW-LEDs gültig. Unterstützt die LED mehrere Chips in einer Daisy-Chain, kann mit INDEX gezielt die Farbe eines einzelnen Chips geändert werden (1 für den ersten Chip, 2 für den zweiten usw.). Wird INDEX nicht angegeben, werden alle LEDs der Daisy-Chain auf die angegebene Farbe gesetzt. Wird TRANSMIT=0 angegeben, wird die Farbänderung erst mit dem nächsten SET_LED-Befehl wirksam, der nicht TRANSMIT=0 angibt; in Kombination mit dem Parameter INDEX lassen sich so mehrere Aktualisierungen einer Daisy-Chain bündeln. Standardmäßig synchronisiert der Befehl SET_LED seine Änderungen mit anderen laufenden G-Code-Befehlen. Das kann zu unerwünschtem Verhalten führen, wenn LEDs gesetzt werden, während der Drucker nicht druckt, da dabei das Leerlauf-Timeout zurückgesetzt wird. Ist ein exaktes Timing nicht erforderlich, kann mit dem optionalen Parameter SYNC=0 die Änderung angewendet werden, ohne das Leerlauf-Timeout zurückzusetzen.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: Weist einer [LED](Config_Reference.md#leds) ein [display_template](Config_Reference.md#display_template) zu. Hat man beispielsweise einen Konfigurationsabschnitt `[display_template my_led_template]` definiert, kann man hier `TEMPLATE=my_led_template` angeben. Das display_template sollte eine durch Kommas getrennte Zeichenkette mit vier Fließkommazahlen erzeugen, die den Farbeinstellungen für Rot, Grün, Blau und Weiß entsprechen. Die Vorlage wird fortlaufend ausgewertet und die LED automatisch auf die resultierenden Farben gesetzt. Es lassen sich display_template-Parameter angeben, die bei der Auswertung der Vorlage verwendet werden (Parameter werden als Python-Literale ausgewertet). Wird INDEX nicht angegeben, wird die Vorlage auf alle Chips der Daisy-Chain der LED angewendet, andernfalls nur auf den Chip mit dem angegebenen Index. Ist TEMPLATE eine leere Zeichenkette, löscht dieser Befehl eine zuvor zugewiesene Vorlage (die Farbeinstellungen der LED lassen sich dann wieder über `SET_LED`-Befehle verwalten).

### [load_cell]

Die folgenden Befehle sind aktiviert, wenn ein [load_cell-Konfigurationsabschnitt](Config_Reference.md#load_cell) aktiviert wurde.

### LOAD_CELL_DIAGNOSTIC

`LOAD_CELL_DIAGNOSTIC [LOAD_CELL=<config_name>]`: Dieser Befehl erfasst 10 Sekunden lang Daten der Wägezelle und meldet Statistiken, mit denen Sie die ordnungsgemäße Funktion der Wägezelle überprüfen können. Dieser Befehl kann sowohl bei kalibrierten als auch bei nicht kalibrierten Wägezellen ausgeführt werden.

### LOAD_CELL_CALIBRATE

`LOAD_CELL_CALIBRATE [LOAD_CELL=<config_name>]`: Startet das geführte Kalibrierungswerkzeug. Die Kalibrierung erfolgt in 3 Schritten:

1. Zuerst entlasten Sie die Wägezelle vollständig und führen den Befehl `TARE` aus
1. Als Nächstes legen Sie eine bekannte Last an die Load Cell an und führen den Befehl `CALIBRATE GRAMS=nnn` aus
1. Verwenden Sie abschließend den Befehl `ACCEPT`, um die Ergebnisse zu speichern

Sie können den Kalibriervorgang jederzeit mit `ABORT` abbrechen.

### LOAD_CELL_TARE

`LOAD_CELL_TARE [LOAD_CELL=<config_name>]`: Dies funktioniert genau wie die Tara-Taste einer digitalen Waage. Der aktuelle Rohmesswert der Load Cell wird als Nullpunkt-Referenzwert festgelegt. Die Antwort enthält den gelesenen Prozentsatz des Sensorbereichs sowie den Rohwert in Counts. Ist die Load Cell kalibriert, wird zusätzlich eine Kraft in Gramm gemeldet.

### LOAD_CELL_READ load_cell="name"

`LOAD_CELL_READ [LOAD_CELL=<config_name>]`: Dieser Befehl liest einen Messwert von der Load Cell. Die Antwort enthält den gelesenen Prozentsatz des Sensorbereichs sowie den Rohwert in Counts. Ist die Load Cell kalibriert, wird zusätzlich eine Kraft in Gramm gemeldet.

### [load_cell_probe]

Die folgenden Befehle sind aktiviert, wenn ein [load_cell-Konfigurationsabschnitt](Config_Reference.md#load_cell_probe) aktiviert wurde.

Zusätzlich akzeptieren Befehle, die Sondierungen durchführen, wie [`PROBE`](#probe), [`PROBE_ACCURACY`](#probe_accuracy), [`BED_MESH_CALIBRATE`](#bed_mesh_calibrate) usw., zusätzliche Parameter, wenn eine `[load_cell_probe]` definiert ist. Diese Parameter überschreiben die entsprechenden Einstellungen aus der Konfiguration [`[load_cell_probe]`](./Config_Reference.md#load_cell_probe):

- `FORCE_SAFETY_LIMIT=<grams>`
- `TRIGGER_FORCE=<grams>`
- `DRIFT_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `DRIFT_FILTER_DELAY=<1|2>`
- `BUZZ_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `BUZZ_FILTER_DELAY=<1|2>`
- `NOTCH_FILTER_FREQUENCIES=<list of frequency_hz>`
- `NOTCH_FILTER_QUALITY=<quality>`
- `TARE_TIME=<seconds>`

### LOAD_CELL_TEST_TAP

`LOAD_CELL_TEST_TAP [TAPS=<taps>] [TIMEOUT=<timeout>]`: Führt eine Testroutine aus, die Tipp-Ereignisse (Taps) an der Load Cell meldet. Der Werkzeugkopf bewegt sich dabei nicht, aber die Load-Cell-Sonde erkennt Tipp-Ereignisse genau wie beim Sondieren. Dies kann als Plausibilitätsprüfung verwendet werden, um sicherzustellen, dass die Sonde funktioniert. Dieses Werkzeug ersetzt QUERY_ENDSTOPS und QUERY_PROBE für Load-Cell-Sonden.

- `TAPS`: die Anzahl der vom Werkzeug erwarteten Tipp-Ereignisse
- `TIMEOOUT`: die Zeit in Sekunden, die das Werkzeug auf jedes Tipp-Ereignis wartet, bevor abgebrochen wird.

### [manual_probe]

Das manual_probe Modul wird automatisch geladen.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`: Startet ein Hilfsskript, mit dem sich die Höhe der Düse an einer bestimmten Position messen lässt. Wird SPEED angegeben, legt dies die Geschwindigkeit der TESTZ-Befehle fest (Standard ist 5 mm/s). Während einer manuellen Messung stehen zusätzlich die folgenden Befehle zur Verfügung:

- `ACCEPT`: Dieser Befehl akzeptiert die aktuelle Z-Position und beendet das manuelle Ausrichtungstool.
- `ABORT`: Dieser Befehl bricht das manuelle Bettleveling ab.
- `TESTZ Z=<value>`: Dieser Befehl bewegt die Düse um den in "value" angegebenen Betrag nach oben oder unten. So bewegt `TESTZ Z=-.1` die Düse um 0,1 mm nach unten, während `TESTZ Z=.1` sie um 0,1 mm nach oben bewegt. Der Wert kann auch `+`, `-`, `++` oder `--` sein, um die Düse relativ zu den vorherigen Versuchen nach oben oder unten zu bewegen.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: Startet ein Hilfsskript, mit dem sich die Konfigurationseinstellung position_endstop für Z kalibrieren lässt. Einzelheiten zu den Parametern und zu den weiteren Befehlen, die bei aktivem Werkzeug zur Verfügung stehen, finden Sie beim Befehl MANUAL_PROBE.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`: Übernimmt den aktuellen Z-G-Code-Versatz (auch Babystepping genannt) und zieht ihn von der endstop_position des stepper_z ab. Damit lässt sich ein häufig verwendeter Babystepping-Wert dauerhaft übernehmen. Erfordert ein `SAVE_CONFIG`, um wirksam zu werden.

### [manual_stepper]

Der folgende Befehl steht zur Verfügung, wenn ein [manual_stepper-Konfigurationsabschnitt](Config_Reference.md#manual_stepper) aktiviert ist.

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos>] [SYNC=0]]`: Dieser Befehl ändert den Zustand des Schrittmotors. Verwenden Sie den Parameter ENABLE, um den Schrittmotor zu aktivieren/deaktivieren. Verwenden Sie den Parameter SET_POSITION, damit der Schrittmotor annimmt, sich an der angegebenen Position zu befinden. Verwenden Sie den Parameter MOVE, um eine Bewegung zur angegebenen Position anzufordern. Werden SPEED und/oder ACCEL angegeben, werden diese Werte anstelle der in der Konfigurationsdatei angegebenen Standardwerte verwendet. Wird ein ACCEL von null angegeben, erfolgt keine Beschleunigung. Normalerweise werden künftige G-Code-Befehle erst nach Abschluss der Schrittmotorbewegung ausgeführt; verwendet eine manuelle Schrittmotorbewegung jedoch SYNC=0, können künftige G-Code-Bewegungsbefehle parallel zur Schrittmotorbewegung ausgeführt werden.

`MANUAL_STEPPER STEPPER=config_name [SPEED=<speed>] [ACCEL=<accel>] MOVE=<pos> STOP_ON_ENDSTOP=<check_type>`: Wird STOP_ON_ENDSTOP angegeben, endet die Bewegung vorzeitig, sobald ein Endstop-Ereignis auftritt. Der Parameter `STOP_ON_ENDSTOP` kann auf einen der folgenden Werte gesetzt werden:

* `probe`: Die Bewegung stoppt, sobald der Endstop einen ausgelösten Zustand meldet.
* `home`: Die Bewegung stoppt, sobald der Endstop einen ausgelösten Zustand meldet, und die Endposition des manual_stepper wird so gesetzt, dass die Auslöseposition mit der im Parameter `MOVE` angegebenen Position übereinstimmt.
* `inverted_probe`, `inverted_home`: Wie oben, jedoch stoppt die Bewegung, sobald der Endstop einen nicht ausgelösten Zustand meldet.
* `try_probe`, `try_inverted_probe`, `try_home`, `try_inverted_home`: Wie oben, jedoch wird kein Fehler gemeldet, wenn die Bewegung vollständig abgeschlossen wird, ohne dass ein Endstop-Ereignis sie vorzeitig stoppt.

`MANUAL_STEPPER STEPPER=config_name GCODE_AXIS=[A-Z] [LIMIT_VELOCITY=<velocity>] [LIMIT_ACCEL=<accel>] [INSTANTANEOUS_CORNER_VELOCITY=<velocity>]`: Wird der Parameter `GCODE_AXIS` angegeben, konfiguriert dies den Schrittmotor als zusätzliche Achse für `G1`-Bewegungsbefehle. Wird beispielsweise ein Befehl `MANUAL_STEPPER ... GCODE_AXIS=R` ausgeführt, können anschließend Befehle wie `G1 X10 Y20 R30` verwendet werden, um den Schrittmotor zu bewegen. Die resultierenden Bewegungen erfolgen synchron zu den zugehörigen XYZ-Werkzeugkopfbewegungen. Ist der Motor mit einer `GCODE_AXIS` verknüpft, können Bewegungen nicht mehr über den obigen Befehl `MANUAL_STEPPER` ausgegeben werden - der Schrittmotor kann mit einem Befehl `MANUAL_STEPPER ... GCODE_AXIS=` abgemeldet werden, um die manuelle Steuerung des Motors wiederherzustellen. Mit den Parametern `LIMIT_VELOCITY` und `LIMIT_ACCEL` lässt sich die Geschwindigkeit von `G1`-Bewegungen reduzieren, falls diese Bewegungen eine Geschwindigkeit oder Beschleunigung über den angegebenen Grenzwerten zur Folge hätten. `INSTANTANEOUS_CORNER_VELOCITY` legt die maximale unmittelbare Geschwindigkeitsänderung (in mm/s) des Motors am Übergang zweier Bewegungen fest (Standardwert ist 1 mm/s).

### [mcp4018]

Der folgende Befehl ist verfügbar, wenn ein [mcp4018-Konfigurationsabschnitt](Config_Reference.md#mcp4018) aktiviert ist.

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: Dieser Befehl ändert den aktuellen Wert des Digipots. Dieser Wert sollte üblicherweise zwischen 0.0 und 1.0 liegen, sofern in der Konfiguration kein 'scale' definiert ist. Ist 'scale' definiert, sollte der Wert zwischen 0.0 und 'scale' liegen.

### [output_pin]

Der folgende Befehl ist verfügbar, wenn ein [output_pin-Konfigurationsabschnitt](Config_Reference.md#output_pin) oder [pwm_tool-Konfigurationsabschnitt](Config_Reference.md#pwm_tool) aktiviert ist.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value>`: Setzt den Pin auf den angegebenen Ausgabewert `VALUE`. VALUE sollte für "digitale" Ausgangspins 0 oder 1 sein. Für PWM-Pins setzen Sie einen Wert zwischen 0.0 und 1.0 bzw. zwischen 0.0 und `scale`, wenn im Konfigurationsabschnitt output_pin eine Skalierung konfiguriert ist.

`SET_PIN PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: Wird `TEMPLATE` angegeben, so wird dem angegebenen Pin ein [display_template](Config_Reference.md#display_template) zugewiesen. Hätte man beispielsweise einen Konfigurationsabschnitt `[display_template my_pin_template]` definiert, könnte man hier `TEMPLATE=my_pin_template` zuweisen. Das display_template sollte eine Zeichenkette erzeugen, die eine Fließkommazahl mit dem gewünschten Wert enthält. Die Vorlage wird fortlaufend ausgewertet und der Pin automatisch auf den resultierenden Wert gesetzt. Man kann display_template-Parameter setzen, die bei der Auswertung der Vorlage verwendet werden (die Parameter werden als Python-Literale interpretiert). Ist TEMPLATE eine leere Zeichenkette, entfernt dieser Befehl jede zuvor dem Pin zugewiesene Vorlage (anschließend können die Werte wieder direkt mit `SET_PIN`-Befehlen verwaltet werden).

### [palette2]

Die folgenden Befehle stehen zur Verfügung, wenn der [palette2-Konfigurationsabschnitt](Config_Reference.md#palette2) aktiviert ist.

Palette-Drucke funktionieren, indem spezielle OCodes (Omega Codes) in die G-Code-Datei eingebettet werden:

- `O1`...`O32`: Diese Codes werden aus dem G-Code-Strom gelesen, von diesem Modul verarbeitet und an das Palette-2-Gerät weitergereicht.

Die folgenden weiteren Befehle sind ebenfalls verfügbar.

#### PALETTE_CONNECT

`PALETTE_CONNECT`: Dieser Befehl stellt die Verbindung zum Palette 2 her.

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`: Dieser Befehl trennt die Verbindung zum Palette 2.

#### PALETTE_CLEAR

`PALETTE_CLEAR`: Dieser Befehl weist den Palette 2 an, sämtliche Ein- und Ausgangspfade von Filament zu leeren.

#### PALETTE_CUT

`PALETTE_CUT`: Dieser Befehl weist den Palette 2 an, das aktuell im Splice-Core befindliche Filament zu schneiden.

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`: Dieser Befehl startet die Smart-Load-Sequenz am Palette 2. Das Filament wird automatisch geladen, indem es über die am Gerät für den Drucker kalibrierte Strecke extrudiert wird; nach Abschluss des Ladevorgangs wird der Palette 2 entsprechend informiert. Dieser Befehl entspricht dem Drücken von **Smart Load** direkt am Bildschirm des Palette 2, nachdem das Filament geladen wurde.

### [pause_resume]

Die folgenden Befehle stehen zur Verfügung, wenn der [pause_resume-Konfigurationsabschnitt](Config_Reference.md#pause_resume) aktiviert ist:

#### PAUSE

`PAUSE`: Pausiert den aktuellen Druck. Die aktuelle Position wird gespeichert, um sie beim Fortsetzen wiederherzustellen.

#### RESUME

`RESUME [VELOCITY=<value>]`: Setzt den Druck nach einer Pause fort und stellt zunächst die zuvor gespeicherte Position wieder her. Der Parameter VELOCITY legt fest, mit welcher Geschwindigkeit das Werkzeug zur ursprünglich gespeicherten Position zurückkehren soll.

#### CLEAR_PAUSE

`CLEAR_PAUSE`: Hebt den aktuellen Pausenzustand auf, ohne den Druck fortzusetzen. Das ist nützlich, wenn man sich nach einem PAUSE entscheidet, den Druck abzubrechen. Es empfiehlt sich, diesen Befehl in den Start-G-Code aufzunehmen, damit der Pausenzustand für jeden Druck sauber initialisiert ist.

#### CANCEL_PRINT

`CANCEL_PRINT`: Bricht den aktuellen Druckvorgang ab.

### [pid_calibrate]

Das Modul pid_calibrate wird automatisch geladen, wenn in der Konfigurationsdatei eine Heizung definiert ist.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`: Führt einen PID-Kalibriertest durch. Die angegebene Heizung wird eingeschaltet, bis die angegebene Zieltemperatur erreicht ist; anschließend wird die Heizung für mehrere Zyklen aus- und eingeschaltet. Ist der Parameter WRITE_FILE aktiviert, wird die Datei /tmp/heattest.txt mit einem Protokoll aller während des Tests erfassten Temperaturmesswerte angelegt.

### [print_stats]

Das print_stats Modul wird automatisch geladen.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>] [CURRENT_LAYER= <current_layer>]`: Übergibt Slicer-Informationen wie aktuelle Schicht und Gesamtschichtzahl an Klipper. Fügen Sie `SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>]` in den Start-G-Code-Abschnitt Ihres Slicers ein und `SET_PRINT_STATS_INFO [CURRENT_LAYER= <current_layer>]` in den G-Code-Abschnitt für den Schichtwechsel, um Schichtinformationen von Ihrem Slicer an Klipper zu übergeben.

### [probe]

Die folgenden Befehle stehen zur Verfügung, wenn ein [probe-Konfigurationsabschnitt](Config_Reference.md#probe) oder ein [bltouch-Konfigurationsabschnitt](Config_Reference.md#bltouch) aktiviert ist (siehe auch die [Anleitung zur Sondenkalibrierung](Probe_Calibrate.md)).

#### PROBE

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`: Bewegt die Düse nach unten, bis die Sonde auslöst. Werden optionale Parameter angegeben, überschreiben sie die jeweils entsprechende Einstellung im [probe-Konfigurationsabschnitt](Config_Reference.md#probe).

#### QUERY_PROBE

`QUERY_PROBE`: Meldet den aktuellen Status der Sonde ("triggered" oder "open").

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`: Berechnet Maximum, Minimum, Mittelwert, Median und Standardabweichung mehrerer Messungen der Sonde. Standardmäßig werden 10 SAMPLES aufgenommen. Ansonsten entsprechen die optionalen Parameter standardmäßig ihrer jeweiligen Einstellung im probe-Konfigurationsabschnitt.

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>]`: Startet ein Hilfsskript, mit dem sich der z_offset der Sonde kalibrieren lässt. Einzelheiten zu den optionalen Sondenparametern finden Sie beim Befehl PROBE. Einzelheiten zum Parameter SPEED und zu den weiteren Befehlen, die bei aktivem Werkzeug zur Verfügung stehen, finden Sie beim Befehl MANUAL_PROBE. Beachten Sie, dass PROBE_CALIBRATE die Variable speed sowohl für Bewegungen in XY-Richtung als auch in Z verwendet.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`: Übernimmt den aktuellen Z-G-Code-Versatz (auch Babystepping genannt) und zieht ihn vom z_offset der Sonde ab. Damit lässt sich ein häufig verwendeter Babystepping-Wert dauerhaft übernehmen. Erfordert ein `SAVE_CONFIG`, um wirksam zu werden.

### [probe_eddy_current]

Die folgenden Befehle sind verfügbar, wenn ein [probe_eddy_current-Konfigurationsabschnitt](Config_Reference.md#probe_eddy_current) aktiviert ist.

Zusätzlich akzeptieren Befehle, die Sondierungen durchführen, wie [`PROBE`](#probe), [`PROBE_ACCURACY`](#probe_accuracy), [`BED_MESH_CALIBRATE`](#bed_mesh_calibrate) usw., zusätzliche Parameter, wenn ein Abschnitt `[probe_eddy_current]` definiert ist:

- `METHOD=<scan|rapid_scan|tap>`: Dies ändert den Sondierungsmechanismus:
   - `METHOD=scan`: Der Werkzeugkopf senkt sich nicht ab. Stattdessen pausiert der Werkzeugkopf kurz über jeder Zielposition und gibt die dort gemessene Höhe zurück.
   - `METHOD=rapid_scan`: Der Werkzeugkopf senkt sich nicht ab und pausiert nicht an jeder Zielposition. Der zurückgegebene Wert ist die gemessene Höhe zu dem Zeitpunkt, an dem sich der Werkzeugkopf jeweils nahe der Zielposition befand.
   - `METHOD=tap`: Der Werkzeugkopf senkt sich ab, bis die Düse das Bett berührt. Diese Methode ist nur verfügbar, wenn im Konfigurationsabschnitt `[probe_eddy_current]` `tap_threshold` angegeben ist.
   - Standard: Ist kein Parameter `METHOD` angegeben, senkt sich der Werkzeugkopf standardmäßig so lange ab, bis der Sensor erkennt, dass der Abstand zum Bett den im Konfigurationsabschnitt `[probe_eddy_current]` angegebenen Parameter `z_offset` erreicht oder unterschreitet.
- `SAMPLE_TIME=<time>`: Bei Sondierung mit `METHOD=scan` gibt dies die Zeit (in Sekunden) an, die an jedem Zielpunkt pausiert wird. Bei `METHOD=rapid_scan` gibt dies das Messzeitfenster an jedem Ziel an. Falls nicht angegeben, beträgt der Standardwert 0,100 (also 100 ms).
- `TAP_THRESHOLD=<value>`: Dies überschreibt den im Konfigurationsabschnitt `[probe_eddy_current]` angegebenen `tap_threshold` bei Sondierung mit `METHOD=tap`.

Der Befehl `Z_OFFSET_APPLY_PROBE` wurde außerdem um die Unterstützung des Parameters `METHOD=tap` erweitert. Wird kein METHOD-Parameter angegeben, passt der Befehl `Z_OFFSET_APPLY_PROBE` die Sondenkalibrierung so an, dass der aktuelle Z-G-Code-Offset auf künftige `scan`-, `rapid_scan`- und Standard-Sondierungen angewendet wird. Wird `METHOD=tap` angegeben, wendet der Befehl die Änderung stattdessen auf `tap_z_offset` an, sodass künftige `tap`-Sondierungen den aktuellen Z-G-Code-Offset verwenden.

#### PROBE_EDDY_CURRENT_CALIBRATE

`PROBE_EDDY_CURRENT_CALIBRATE CHIP=<config_name>`: Startet ein Werkzeug, das die Resonanzfrequenzen des Sensors den entsprechenden Z-Höhen zuordnet. Das Werkzeug benötigt einige Minuten. Verwenden Sie nach Abschluss den Befehl SAVE_CONFIG, um die Ergebnisse in der Datei printer.cfg zu speichern.

#### PROBE_EDDY_CURRENT_TAP_CALIBRATE

`PROBE_EDDY_CURRENT_TAP_CALIBRATE [TAP=guess|refine|verify]`: Startet ein Werkzeug, mit dem der Parameter "tap_threshold" der Sonde kalibriert werden kann. Details finden Sie in der [Eddy-Probe-Dokumentation](Eddy_Probe.md#tap-calibration).

#### LDC_CALIBRATE_DRIVE_CURRENT

`LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` Dieses Werkzeug kalibriert das Register DRIVE_CURRENT0 des ldc1612. Bewegen Sie den Sensor vor der Verwendung dieses Werkzeugs so, dass er sich nahe der Bettmitte und etwa 20 mm über der Bettoberfläche befindet. Führen Sie diesen Befehl aus, um einen geeigneten DRIVE_CURRENT für den Sensor zu ermitteln. Verwenden Sie nach dem Ausführen dieses Befehls den Befehl SAVE_CONFIG, um die neue Einstellung in der Konfigurationsdatei printer.cfg zu speichern.

### [pwm_cycle_time]

Der folgende Befehl ist verfügbar, wenn ein [pwm_cycle_time-Konfigurationsabschnitt](Config_Reference.md#pwm_cycle_time) aktiviert ist.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: Dieser Befehl funktioniert ähnlich wie die SET_PIN-Befehle von [output_pin](#output_pin). Der Befehl unterstützt hier zusätzlich das Setzen einer expliziten Zykluszeit über den Parameter CYCLE_TIME (in Sekunden angegeben). Beachten Sie, dass der Parameter CYCLE_TIME nicht zwischen SET_PIN-Befehlen gespeichert wird (jeder SET_PIN-Befehl ohne expliziten CYCLE_TIME-Parameter verwendet die im Konfigurationsabschnitt pwm_cycle_time angegebene `cycle_time`).

### [quad_gantry_level]

Die folgenden Befehle sind verfügbar, wenn der [quad_gantry_level-Konfigurationsabschnitt](Config_Reference.md#quad_gantry_level) aktiviert ist.

#### QUAD_GANTRY_LEVEL

`QUAD_GANTRY_LEVEL [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Dieser Befehl tastet die in der Konfiguration angegebenen Punkte ab und nimmt anschließend unabhängige Anpassungen an jedem Z-Schrittmotor vor, um die Neigung auszugleichen. Details zu den optionalen Sondenparametern finden Sie beim Befehl PROBE. Die optionalen Werte `RETRIES`, `RETRY_TOLERANCE` und `HORIZONTAL_MOVE_Z` überschreiben die in der Konfigurationsdatei angegebenen Optionen.

### [query_adc]

Das query_adc Modul wird automatisch geladen.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]`: Meldet den zuletzt empfangenen Analogwert für einen konfigurierten Analogpin. Wird NAME nicht angegeben, wird die Liste der verfügbaren ADC-Namen ausgegeben. Wird PULLUP angegeben (als Wert in Ohm), so werden der Rohanalogwert sowie der bei diesem Pullup entsprechende Widerstand gemeldet.

### [query_endstops]

Das Modul query_endstops wird automatisch geladen. Die folgenden Standard-G-Code-Befehle sind derzeit verfügbar, ihre Verwendung wird jedoch nicht empfohlen:

- Endschalter-Status abfragen: `M119` (Verwenden Sie stattdessen QUERY_ENDSTOPS.)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`: Tastet die Achsen-Endschalter ab und meldet, ob sie "triggered" (ausgelöst) oder "open" (offen) sind. Dieser Befehl wird üblicherweise verwendet, um zu prüfen, ob ein Endschalter korrekt funktioniert.

### [resonance_tester]

Die folgenden Befehle stehen zur Verfügung, wenn ein [resonance_tester-Konfigurationsabschnitt](Config_Reference.md#resonance_tester) aktiviert ist (siehe auch die [Anleitung zum Messen von Resonanzen](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: Misst das Rauschen für alle Achsen aller aktivierten Beschleunigungssensor-Chips und gibt es aus.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> [OUTPUT=<resonances,raw_data>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [POINT=x,y,z] [INPUT_SHAPING=<0:1>]`: Führt den Resonanztest an allen konfigurierten Sondierungspunkten für die angeforderte "axis" aus und misst die Beschleunigung mit den für die jeweilige Achse konfigurierten Beschleunigungssensor-Chips. "axis" kann X, Y oder Z sein, oder eine beliebige Richtung als `AXIS=dx,dy[,dz]` angeben, wobei dx, dy, dz Fließkommazahlen sind, die einen Richtungsvektor definieren (z. B. `AXIS=X`, `AXIS=Y`, oder `AXIS=1,-1` für eine diagonale Richtung in der XY-Ebene, oder `AXIS=0,1,1` für eine Richtung in der YZ-Ebene). Beachten Sie, dass `AXIS=dx,dy` und `AXIS=-dx,-dy` gleichwertig sind. `chip_name` kann einen oder mehrere konfigurierte Beschleunigungssensor-Chips angeben, durch Komma getrennt, zum Beispiel `CHIPS="adxl345, adxl345 rpi"`. Ist POINT angegeben, überschreibt dies die in `[resonance_tester]` konfigurierten Punkte. Ist `INPUT_SHAPING=0` oder nicht gesetzt (Standard), wird Input Shaping für den Resonanztest deaktiviert, da es nicht zulässig ist, den Resonanztest bei aktiviertem Input Shaper auszuführen. Der Parameter `OUTPUT` ist eine durch Komma getrennte Liste der zu schreibenden Ausgaben. Wird `raw_data` angefordert, werden die Rohdaten des Beschleunigungssensors in eine Datei oder eine Reihe von Dateien `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` geschrieben (der Namensteil `<point>_` wird nur erzeugt, wenn mehr als 1 Sondierungspunkt konfiguriert ist oder POINT angegeben wurde). Ist `resonances` angegeben, wird die Frequenzantwort (über alle Sondierungspunkte hinweg) berechnet und in die Datei `/tmp/resonances_<axis>_<name>.csv` geschrieben. Ist nichts angegeben, ist der Standardwert für OUTPUT `resonances`, und NAME wird standardmäßig auf die aktuelle Zeit im Format "YYYYMMDD_HHMMSS" gesetzt.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>][HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [MAX_SMOOTHING=<max_smoothing>] [INPUT_SHAPING=<0:1>]`: Führt ähnlich wie `TEST_RESONANCES` den Resonanztest wie konfiguriert aus und versucht, die optimalen Parameter für den Input Shaper der angeforderten Achse zu ermitteln (bzw. für beide Achsen X und Y, wenn der Parameter `AXIS` nicht gesetzt ist). Ist `MAX_SMOOTHING` nicht gesetzt, wird der Wert aus dem Abschnitt `[resonance_tester]` übernommen, wobei er standardmäßig nicht gesetzt ist. Weitere Informationen zur Verwendung dieser Funktion finden Sie im Abschnitt [Max smoothing](Measuring_Resonances.md#max-smoothing) der Anleitung zum Messen von Resonanzen. Die Ergebnisse der Abstimmung werden auf der Konsole ausgegeben, und die Frequenzgänge sowie die Werte der verschiedenen Input Shaper werden in eine oder mehrere CSV-Dateien `/tmp/calibration_data_<axis>_<name>.csv` geschrieben. Sofern nicht anders angegeben, entspricht NAME standardmäßig der aktuellen Zeit im Format "YYYYMMDD_HHMMSS". Beachten Sie, dass die vorgeschlagenen Input-Shaper-Parameter mit dem Befehl `SAVE_CONFIG` dauerhaft in der Konfiguration gespeichert werden können, und dass diese Parameter sofort wirksam werden, wenn `[input_shaper]` bereits zuvor aktiviert war.

### [respond]

Die folgenden Standard-G-Code-Befehle stehen zur Verfügung, wenn der [respond-Konfigurationsabschnitt](Config_Reference.md#respond) aktiviert ist:

- `M118 <message>`: Gibt die Nachricht aus, vorangestellt der konfigurierte Standardpräfix (oder `echo: `, wenn kein Präfix konfiguriert ist).

Die folgenden weiteren Befehle sind ebenfalls verfügbar.

#### RESPOND

- `RESPOND MSG="<message>"`: Gibt die Nachricht aus, vorangestellt der konfigurierte Standardpräfix (oder `echo: `, wenn kein Präfix konfiguriert ist).
- `RESPOND TYPE=echo MSG="<message>"`: Gibt die Nachricht aus, vorangestellt `echo: `.
- `RESPOND TYPE=echo_no_space MSG="<message>"`: Gibt die Nachricht mit vorangestelltem `echo:` aus, ohne Leerzeichen zwischen Präfix und Nachricht – hilfreich für die Kompatibilität mit manchen OctoPrint-Plugins, die ein sehr spezifisches Format erwarten.
- `RESPOND TYPE=command MSG="<message>"`: Gibt die Nachricht aus, vorangestellt `// `. OctoPrint kann so konfiguriert werden, dass es auf diese Nachrichten reagiert (z. B. `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<message>"`: Gibt die Nachricht aus, vorangestellt `!! `.
- `RESPOND PREFIX=<prefix> MSG="<message>"`: Gibt die Nachricht aus, vorangestellt `<prefix>`. (Der Parameter `PREFIX` hat Vorrang vor dem Parameter `TYPE`.)

### [save_variables]

Der folgende Befehl ist verfügbar, wenn ein [save_variables-Konfigurationsabschnitt](Config_Reference.md#save_variables) aktiviert wurde.

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`: Speichert die Variable auf der Festplatte, sodass sie über Neustarts hinweg verwendet werden kann. VARIABLE muss kleingeschrieben sein. Alle gespeicherten Variablen werden beim Start in das Dict `printer.save_variables.variables` geladen und können in G-Code-Makros verwendet werden. Der angegebene VALUE wird als Python-Literal ausgewertet.

### [screws_tilt_adjust]

Die folgenden Befehle stehen zur Verfügung, wenn der [screws_tilt_adjust-Konfigurationsabschnitt](Config_Reference.md#screws_tilt_adjust) aktiviert ist (siehe auch die [Anleitung zum manuellen Nivellieren](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Dieser Befehl ruft das Werkzeug zur Einstellung der Bettschrauben auf. Er fährt die Düse an verschiedene Positionen (wie in der Konfigurationsdatei definiert), tastet die Z-Höhe ab und berechnet die Anzahl der Umdrehungen der Rändelschrauben, um das Bett auszurichten. Wird DIRECTION angegeben, erfolgen alle Schraubendrehungen in derselben Richtung, im Uhrzeigersinn (CW) oder gegen den Uhrzeigersinn (CCW). Details zu den optionalen Sondenparametern finden Sie beim Befehl PROBE. WICHTIG: Sie MÜSSEN vor der Verwendung dieses Befehls stets ein G28 ausführen. Wird MAX_DEVIATION angegeben, löst der Befehl einen G-Code-Fehler aus, wenn eine Abweichung der Schraubenhöhe relativ zur Basisschraubenhöhe größer als der angegebene Wert ist. Der optionale Wert `HORIZONTAL_MOVE_Z` überschreibt die in der Konfigurationsdatei angegebene Option `horizontal_move_z`.

### [sdcard_loop]

Wenn der [sdcard_loop-Konfigurationsabschnitt](Config_Reference.md#sdcard_loop) aktiviert ist, stehen die folgenden erweiterten Befehle zur Verfügung.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`: Beginnt einen Schleifenabschnitt im SD-Druck. Ein Zählwert von 0 bedeutet, dass der Abschnitt unbegrenzt wiederholt werden soll.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: Beendet einen Schleifenabschnitt im SD-Druck.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: Schließt bestehende Schleifen ohne weitere Durchläufe ab.

### [servo]

Die folgenden Befehle stehen zur Verfügung, wenn ein [servo-Konfigurationsabschnitt](Config_Reference.md#servo) aktiviert ist.

#### SET_SERVO

`SET_SERVO SERVO=config_name [ANGLE=<degrees> | WIDTH=<seconds>]`: Setzt die Servoposition auf den angegebenen Winkel (in Grad) oder die angegebene Pulsbreite (in Sekunden). Mit `WIDTH=0` wird der Servoausgang deaktiviert.

### [skew_correction]

Die folgenden Befehle stehen zur Verfügung, wenn der [skew_correction-Konfigurationsabschnitt](Config_Reference.md#skew_correction) aktiviert ist (siehe auch die Anleitung [Skew Correction](Skew_Correction.md)).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`: Konfiguriert das Modul [skew_correction] mit Messwerten (in mm) aus einem Kalibrierdruck. Es können Messwerte für beliebige Kombinationen von Ebenen eingegeben werden; nicht eingegebene Ebenen behalten ihren aktuellen Wert. Wird `CLEAR=1` angegeben, wird die gesamte Schrägheitskorrektur deaktiviert.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: Meldet die aktuelle Schrägheit des Druckers für jede Ebene, sowohl in Radiant als auch in Grad. Die Schrägheit wird anhand der Parameter berechnet, die über den G-Code `SET_SKEW` angegeben wurden.

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>]`: Berechnet die Schrägheit (in Radiant und Grad) anhand eines gemessenen Drucks und gibt sie aus. Das kann nützlich sein, um die aktuelle Schrägheit des Druckers nach angewendeter Korrektur zu bestimmen. Ebenso kann es vor der Korrektur nützlich sein, um festzustellen, ob eine Schrägheitskorrektur überhaupt nötig ist. Einzelheiten zu Kalibrierobjekten und Messungen finden Sie unter [Skew Correction](Skew_Correction.md).

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<name>] [SAVE=<name>] [REMOVE=<name>]`: Profilverwaltung für skew_correction. LOAD stellt den Schrägheitszustand aus dem Profil mit dem angegebenen Namen wieder her. SAVE speichert den aktuellen Schrägheitszustand in einem Profil mit dem angegebenen Namen. REMOVE löscht das Profil mit dem angegebenen Namen aus dem persistenten Speicher. Beachten Sie, dass nach SAVE- oder REMOVE-Vorgängen der G-Code SAVE_CONFIG ausgeführt werden muss, damit die Änderungen im persistenten Speicher dauerhaft übernommen werden.

### [smart_effector]

Wenn ein [smart_effector-Konfigurationsabschnitt](Config_Reference.md#smart_effector) aktiviert ist, stehen mehrere Befehle zur Verfügung. Lesen Sie unbedingt die offizielle Dokumentation zum Smart Effector im [Duet3D-Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer), bevor Sie die Parameter des Smart Effector ändern. Beachten Sie außerdem die [Anleitung zur Sondenkalibrierung](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<sensitivity>] [ACCEL=<accel>] [RECOVERY_TIME=<time>]`: Setzt die Parameter des Smart Effector. Wird `SENSITIVITY` angegeben, wird der jeweilige Wert in das EEPROM des SmartEffector geschrieben (dafür muss `control_pin` angegeben sein). Zulässige `<sensitivity>`-Werte sind 0..255, der Standardwert ist 50. Niedrigere Werte erfordern eine geringere Kontaktkraft der Düse zum Auslösen (allerdings steigt das Risiko von Fehlauslösungen durch Vibrationen während der Messung), höhere Werte verringern Fehlauslösungen (erfordern aber eine größere Kontaktkraft). Da die Empfindlichkeit ins EEPROM geschrieben wird, bleibt sie nach dem Abschalten erhalten und muss nicht bei jedem Druckerstart neu konfiguriert werden. Mit `ACCEL` und `RECOVERY_TIME` lassen sich die entsprechenden Parameter zur Laufzeit übersteuern; weitere Informationen zu diesen Parametern finden Sie im [Konfigurationsabschnitt](Config_Reference.md#smart_effector) des Smart Effector.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`: Setzt die Empfindlichkeit des Smart Effector auf die Werkseinstellungen zurück. Erfordert, dass `control_pin` im Konfigurationsabschnitt angegeben ist.

### [stepper_enable]

Das stepper_enable Modul wird automatisch geladen.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<config_name> ENABLE=[0|1]`: Aktiviert oder deaktiviert ausschließlich den angegebenen Schrittmotor. Dies ist ein Diagnose- und Debugging-Werkzeug und muss mit Vorsicht verwendet werden. Das Deaktivieren eines Achsmotors setzt die Homing-Informationen nicht zurück. Wird ein deaktivierter Schrittmotor von Hand bewegt, kann die Maschine den Motor anschließend außerhalb sicherer Grenzen betreiben. Das kann zu Schäden an Achskomponenten, Hotends und der Druckoberfläche führen.

### [temperature_fan]

Der folgende Befehl steht zur Verfügung, wenn ein [temperature_fan-Konfigurationsabschnitt](Config_Reference.md#temperature_fan) aktiviert ist.

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>] [max_speed=<max_speed>]`: Setzt die Zieltemperatur für einen temperature_fan. Wird kein Ziel angegeben, wird es auf die in der Konfigurationsdatei angegebene Temperatur gesetzt. Werden keine Geschwindigkeiten angegeben, erfolgt keine Änderung.

### [temperature_probe]

Die folgenden Befehle sind verfügbar, wenn ein [temperature_probe-Konfigurationsabschnitt](Config_Reference.md#temperature_probe) aktiviert ist.

#### TEMPERATURE_PROBE_CALIBRATE

`TEMPERATURE_PROBE_CALIBRATE [PROBE=<probe name>] [TARGET=<value>] [STEP=<value>] [METHOD=<method>]`: Startet die Sondendrift-Kalibrierung für auf Wirbelstrom basierende Sonden. `TARGET` ist eine Zieltemperatur für die letzte Messung. Überschreitet die während einer Messung erfasste Temperatur `TARGET`, wird die Kalibrierung abgeschlossen. Der Parameter `STEP` legt das Temperaturdelta (in °C) zwischen den Messungen fest. Nach jeder Messung wird dieses Delta verwendet, um einen Aufruf von `TEMPERATURE_PROBE_NEXT` zu planen. Der Standardwert für `STEP` ist 2. `METHOD` unterstützt nur die Option `tap`; ist sie angegeben, erfolgt die Sondierung automatisiert.

#### TEMPERATURE_PROBE_NEXT

`TEMPERATURE_PROBE_NEXT`: Nachdem die Kalibrierung begonnen hat, wird dieser Befehl ausgeführt, um die nächste Messung vorzunehmen. Er wird automatisch ausgeführt, sobald die durch `STEP` angegebene Differenz erreicht ist; es ist jedoch auch möglich, diesen Befehl manuell auszuführen, um eine neue Messung zu erzwingen. Dieser Befehl ist nur während der Kalibrierung verfügbar.

#### TEMPERATURE_PROBE_COMPLETE:

`TEMPERATURE_PROBE_COMPLETE`: Kann verwendet werden, um die Kalibrierung zu beenden und das aktuelle Ergebnis zu speichern, bevor die `TARGET`-Temperatur erreicht ist. Dieser Befehl ist nur während der Kalibrierung verfügbar.

#### ABORT

`ABBRUCH`: Bricht den Kalibrierungsprozess ab und verwirft die aktuellen Ergebnisse. Dieser Befehl ist nur während der Driftkalibrierung verfügbar.

### TEMPERATURE_PROBE_ENABLE

`TEMPERATURE_PROBE_ENABLE ENABLE=[0|1]`: Schaltet die Kompensation der Temperaturdrift ein oder aus. Ist ENABLE auf 0 gesetzt, wird die Driftkompensation deaktiviert, bei 1 wird sie aktiviert.

### [tmcXXXX]

Die folgenden Befehle stehen zur Verfügung, wenn einer der [tmcXXXX-Konfigurationsabschnitte](Config_Reference.md#tmc-stepper-driver-configuration) aktiviert ist.

#### DUMP_TMC

`DUMP_TMC STEPPER=<name> [REGISTER=<name>]`: Dieser Befehl liest alle Register des TMC-Treibers aus und meldet deren Werte. Wird ein REGISTER angegeben, wird nur das angegebene Register ausgegeben.

#### INIT_TMC

`INIT_TMC STEPPER=<name>`: Dieser Befehl initialisiert die TMC-Register. Er wird benötigt, um den Treiber wieder zu aktivieren, nachdem die Versorgungsspannung des Chips aus- und wieder eingeschaltet wurde.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: Damit werden der Betriebs- und der Haltestrom des TMC-Treibers angepasst. `HOLDCURRENT` ist für tmc2660-Treiber nicht anwendbar. Bei Verwendung mit einem Treiber, der das Feld `globalscaler` besitzt (tmc5160 und tmc2240), muss der Schrittmotor bei Verwendung von StealthChop2 länger als 130 ms im Stillstand gehalten werden, damit der Treiber die AT#1-Kalibrierung ausführt.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value> VELOCITY=<value>`: Damit wird der Wert des angegebenen Registerfelds des TMC-Treibers verändert. Dieser Befehl ist ausschließlich für Low-Level-Diagnose und Fehlersuche vorgesehen, da das Ändern der Felder zur Laufzeit zu unerwünschtem und potenziell gefährlichem Verhalten Ihres Druckers führen kann. Dauerhafte Änderungen sollten stattdessen in der Druckerkonfigurationsdatei vorgenommen werden. Für die angegebenen Werte werden keine Plausibilitätsprüfungen durchgeführt. Anstelle von VALUE kann auch eine VELOCITY angegeben werden. Diese Geschwindigkeit wird in die 20-Bit-TSTEP-basierte Wertdarstellung umgerechnet. Verwenden Sie das Argument VELOCITY nur für Felder, die Geschwindigkeiten darstellen.

### [toolhead]

Das toolhead Modul wird automatisch geladen.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [MINIMUM_CRUISE_RATIO=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: Dieser Befehl kann die in der Druckerkonfigurationsdatei angegebenen Geschwindigkeitsgrenzen ändern. Eine Beschreibung der einzelnen Parameter finden Sie im [Konfigurationsabschnitt printer](Config_Reference.md#printer).

### [tuning_tower]

Das tuning_tower Modul wird automatisch geladen.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<command> PARAMETER=<name> START=<value> [SKIP=<value>] [FACTOR=<value> [BAND=<value>]] | [STEP_DELTA=<value> STEP_HEIGHT=<value>]`: Ein Werkzeug zum Abstimmen eines Parameters auf jeder Z-Höhe während eines Drucks. Das Werkzeug führt den angegebenen `COMMAND` aus, wobei dem angegebenen `PARAMETER` ein Wert zugewiesen wird, der sich nach einer Formel mit `Z` verändert. Verwenden Sie `FACTOR`, wenn Sie die Z-Höhe des optimalen Werts mit einem Lineal oder einer Schieblehre messen möchten, oder `STEP_DELTA` und `STEP_HEIGHT`, wenn das Modell des Tuning-Towers Bänder mit diskreten Werten aufweist, wie es bei Temperaturtürmen üblich ist. Wird `SKIP=<value>` angegeben, beginnt der Abstimmvorgang erst, wenn die Z-Höhe `<value>` erreicht ist; darunter wird der Wert auf `START` gesetzt. In diesem Fall ist die in den folgenden Formeln verwendete `z_height` tatsächlich `max(z - skip, 0)`. Es gibt drei mögliche Kombinationen der Optionen:

- `FACTOR`: Der Wert ändert sich um `factor` pro Millimeter. Verwendete Formel: `value = start + factor * z_height`. Sie können die optimale Z-Höhe direkt in die Formel einsetzen, um den optimalen Parameterwert zu bestimmen.
- `FACTOR` und `BAND`: Der Wert ändert sich im Mittel um `factor` pro Millimeter, jedoch in diskreten Bändern, sodass die Anpassung nur alle `BAND` Millimeter Z-Höhe erfolgt. Verwendete Formel: `value = start + factor * ((floor(z_height / band) + .5) * band)`.
- `STEP_DELTA` und `STEP_HEIGHT`: Der Wert ändert sich um `STEP_DELTA` alle `STEP_HEIGHT` Millimeter. Verwendete Formel: `value = start + step_delta * floor(z_height / step_height)`. Sie können einfach die Bänder abzählen oder die Beschriftungen des Tuning-Towers ablesen, um den optimalen Wert zu bestimmen.

### [virtual_sdcard]

[virtual_sdcard config section](Config_Reference.md#virtual_sdcard) wenn das eingerichtet ist unterstützt Klipper die festen G-Code Befehle:

- SD-Karte auflisten: `M20`
- SD-Karte initialisieren: `M21`
- SD-Karten Datei auswählen: `M23 <filename>`
- SD-Karten Druck starten/fortsetzen: `M24`
- SD-Karten Druck anhalten: `M25`
- SD-Karten Position einstellen: `M26 S<offset>`
- SD-Karten Druckstatus anzeigen: `M27`

Zusätzlich stehen die weiteren Befehle zur Verfügung wenn der Konfigurationsabschnitt "virtual_sdcard" aktiviert ist.

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<filename>`: Lädt eine Datei und startet den SD-Druck.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`: Datei zurücksetzen und SD Status löschen.

### [z_thermal_adjust]

Die folgenden Befehle sind verfügbar, wenn der [z_thermal_adjust-Konfigurationsabschnitt](Config_Reference.md#z_thermal_adjust) aktiviert ist.

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<value>] [REF_TEMP=<value>]`: Aktiviert oder deaktiviert die thermische Z-Anpassung mit `ENABLE`. Beim Deaktivieren wird eine bereits angewendete Anpassung nicht entfernt, sondern der aktuelle Anpassungswert eingefroren – dies verhindert potenziell unsichere Abwärtsbewegungen in Z. Ein erneutes Aktivieren kann eine Aufwärtsbewegung des Werkzeugs verursachen, wenn die Anpassung aktualisiert und angewendet wird. `TEMP_COEFF` ermöglicht das Feinabstimmen des Temperaturkoeffizienten der Anpassung zur Laufzeit (d. h. des Konfigurationsparameters `TEMP_COEFF`). `TEMP_COEFF`-Werte werden nicht in der Konfiguration gespeichert. `REF_TEMP` überschreibt manuell die Referenztemperatur, die üblicherweise beim Homing gesetzt wird (zur Verwendung z. B. in nicht standardmäßigen Homing-Routinen) – sie wird beim Homing automatisch zurückgesetzt.

### [z_tilt]

Die folgenden Befehle stehen zur Verfügung, wenn der [z_tilt-Konfigurationsabschnitt](Config_Reference.md#z_tilt) aktiviert ist.

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Dieser Befehl tastet die in der Konfiguration angegebenen Punkte ab und nimmt anschließend unabhängige Anpassungen an jedem Z-Schrittmotor vor, um die Neigung auszugleichen. Details zu den optionalen Sondenparametern finden Sie beim Befehl PROBE. Die optionalen Werte `RETRIES`, `RETRY_TOLERANCE` und `HORIZONTAL_MOVE_Z` überschreiben die in der Konfigurationsdatei angegebenen Optionen.
