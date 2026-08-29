# Befehlsvorlagen

Dieses Dokument enthält Informationen zur Implementierung von G-Code-Befehlssequenzen in gcode_macro (und ähnlichen) Konfigurationsabschnitten.

## G-Code Makro-Benennung

Die Groß- und Kleinschreibung spielt für den G-Code-Makronamen keine Rolle - MY_MACRO und my_macro werden gleich ausgewertet und können sowohl in Groß- als auch in Kleinschreibung aufgerufen werden. Wenn im Makronamen Zahlen verwendet werden, müssen diese am Ende des Namens stehen (z. B. ist TEST_MACRO25 gültig, MACRO25_TEST3 jedoch nicht).

## Formatierung von G-Code in der Konfigurationsdatei

Beim Definieren eines Makros in der Konfigurationsdatei ist die Einrückung wichtig. Um eine mehrzeilige G-Code-Sequenz anzugeben, muss jede Zeile korrekt eingerückt sein. Zum Beispiel:

```
[gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

Beachten Sie, dass die Konfigurationsoption `gcode:` stets am Zeilenanfang beginnt, während die nachfolgenden Zeilen des G-Code-Makros nie am Zeilenanfang beginnen.

## Fügen Sie eine Beschreibung zu Ihrem Makro hinzu

Zur besseren Kennzeichnung der Funktion kann eine kurze Beschreibung ergänzt werden. Fügen Sie `description:` mit einem kurzen Text zur Beschreibung der Funktion hinzu. Ohne Angabe lautet der Standardwert "G-Code macro". Zum Beispiel:

```
[gcode_macro blink_led]
description: Blink my_led one time
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
```

Das Terminal zeigt die Beschreibung an, wenn Sie den Befehl `HELP` oder die Autovervollständigung verwenden.

## Speichern/Wiederherstellen des Status für G-Code Bewegungen

Leider kann die G-Code-Befehlssprache in der Anwendung anspruchsvoll sein. Der übliche Mechanismus zum Bewegen des Druckkopfes ist der Befehl `G1` (der Befehl `G0` ist ein Alias für `G1` und kann gleichbedeutend verwendet werden). Dieser Befehl stützt sich jedoch auf den "G-Code-Parserzustand", der durch `M82`, `M83`, `G90`, `G91`, `G92` und vorangegangene `G1`-Befehle festgelegt wurde. Beim Erstellen eines G-Code-Makros ist es ratsam, den G-Code-Parserzustand vor dem Absetzen eines `G1`-Befehls stets explizit zu setzen. (Andernfalls besteht das Risiko, dass der `G1`-Befehl eine unerwünschte Bewegung anfordert.)

Eine gängige Vorgehensweise dafür ist, die `G1`-Bewegungen in `SAVE_GCODE_STATE`, `G91` und `RESTORE_GCODE_STATE` einzuschließen. Zum Beispiel:

```
[gcode_macro MOVE_UP]
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state
  G91
  G1 Z10 F300
  RESTORE_GCODE_STATE NAME=my_move_up_state
```

Der Befehl `G91` versetzt den G-Code-Parserzustand in den "relativen Bewegungsmodus", und der Befehl `RESTORE_GCODE_STATE` stellt den Zustand wieder her, der vor dem Eintritt in das Makro bestand. Geben Sie im ersten `G1`-Befehl unbedingt eine explizite Geschwindigkeit an (über den Parameter `F`).

## Auswertung von Vorlagen

Der Konfigurationsabschnitt `gcode:` eines gcode_macro wird mit der Vorlagensprache Jinja2 ausgewertet. Ausdrücke lassen sich zur Laufzeit auswerten, indem man sie in `{ }` einschließt; bedingte Anweisungen werden in `{% %}` eingeschlossen. Weitere Informationen zur Syntax finden Sie in der [Jinja2-Dokumentation](http://jinja.pocoo.org/docs/2.10/templates/).

Ein Beispiel für ein komplexes Makro:

```
[gcode_macro clean_nozzle]
gcode:
  {% set wipe_count = 8 %}
  SAVE_GCODE_STATE NAME=clean_nozzle_state
  G90
  G0 Z15 F300
  {% for wipe in range(wipe_count) %}
    {% for coordinate in [(275, 4),(235, 4)] %}
      G0 X{coordinate[0]} Y{coordinate[1] + 0.25 * wipe} Z9.7 F12000
    {% endfor %}
  {% endfor %}
  RESTORE_GCODE_STATE NAME=clean_nozzle_state
```

### Makro Parameter

Häufig ist es nützlich, die beim Aufruf an das Makro übergebenen Parameter auszuwerten. Diese Parameter stehen über die Pseudo-Variable `params` zur Verfügung. Wenn das Makro:

```
[gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
```

beispielsweise als `SET_PERCENT VALUE=.2` aufgerufen würde, ergäbe es `M117 Now at 20%`. Beachten Sie, dass Parameternamen bei der Auswertung im Makro stets in Großbuchstaben vorliegen und immer als Zeichenketten übergeben werden. Für Berechnungen müssen sie explizit in Ganzzahlen oder Gleitkommazahlen umgewandelt werden.

Es ist üblich, die Jinja2-Direktive `set` zu verwenden, um einen Standardwert für einen Parameter zu nutzen und das Ergebnis einem lokalen Namen zuzuweisen. Zum Beispiel:

```
[gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp}
```

### Die Variable "rawparams"

Auf die vollständigen, nicht geparsten Parameter des laufenden Makros kann über die Pseudo-Variable `rawparams` zugegriffen werden.

Beachten Sie, dass dabei auch alle Kommentare enthalten sind, die Teil des ursprünglichen Befehls waren.

Ein Beispiel dafür, wie sich der Befehl `M117` mithilfe von `rawparams` überschreiben lässt, finden Sie in der Datei [sample-macros.cfg](../config/sample-macros.cfg).

### Die "printer" Variable

Über die Pseudo-Variable `printer` lässt sich der aktuelle Zustand des Druckers auswerten (und verändern). Zum Beispiel:

```
[gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
```

Die verfügbaren Felder sind im Dokument [Statusreferenz](Status_Reference.md) definiert.

Wichtig! Makros werden zunächst vollständig ausgewertet und erst danach werden die resultierenden Befehle ausgeführt. Setzt ein Makro einen Befehl ab, der den Zustand des Druckers verändert, ist das Ergebnis dieser Zustandsänderung während der Auswertung des Makros nicht sichtbar. Das kann auch zu subtilem Verhalten führen, wenn ein Makro Befehle erzeugt, die andere Makros aufrufen, da das aufgerufene Makro erst zum Zeitpunkt seines Aufrufs ausgewertet wird (also nach der vollständigen Auswertung des aufrufenden Makros).

Per Konvention ist der unmittelbar auf `printer` folgende Name der Name eines Konfigurationsabschnitts. So verweist zum Beispiel `printer.fan` auf das Lüfterobjekt, das durch den Konfigurationsabschnitt `[fan]` erzeugt wurde. Von dieser Regel gibt es einige Ausnahmen - insbesondere die Objekte `gcode_move` und `toolhead`. Enthält der Konfigurationsabschnitt Leerzeichen, kann man über den Accessor `[ ]` darauf zugreifen - zum Beispiel: `printer["generic_heater my_chamber_heater"].temperature`.

Beachten Sie, dass die Jinja2-Direktive `set` einem Objekt in der `printer`-Hierarchie einen lokalen Namen zuweisen kann. Das kann Makros lesbarer machen und Tipparbeit sparen. Zum Beispiel:

```
[gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
```

## Aktionen

Es stehen einige Befehle zur Verfügung, die den Zustand des Druckers verändern können. So würde zum Beispiel `{ action_emergency_stop() }` den Drucker in den Abschaltzustand versetzen. Beachten Sie, dass diese Aktionen zum Zeitpunkt der Auswertung des Makros ausgeführt werden, was deutlich vor der Ausführung der erzeugten G-Code-Befehle liegen kann.

Verfügbare "action" Befehle:

- `action_respond_info(msg)`: Schreibt die angegebene Nachricht `msg` auf das Pseudo-Terminal /tmp/printer. Jede Zeile von `msg` wird mit dem Präfix "// " gesendet.
- `action_raise_error(msg)`: Bricht das aktuelle Makro (und alle aufrufenden Makros) ab und schreibt die angegebene Nachricht `msg` auf das Pseudo-Terminal /tmp/printer. Die erste Zeile von `msg` wird mit dem Präfix "!! " gesendet, nachfolgende Zeilen mit dem Präfix "// ".
- `action_emergency_stop(msg)`: Versetzt den Drucker in den Abschaltzustand. Der Parameter `msg` ist optional; er kann nützlich sein, um den Grund für die Abschaltung zu beschreiben.
- `action_call_remote_method(method_name)`: Ruft eine von einem entfernten Client registrierte Methode auf. Erwartet die Methode Parameter, sollten diese als Schlüsselwortargumente übergeben werden, also: `action_call_remote_method("print_stuff", my_arg="hello_world")`

## Variablen

Der Befehl SET_GCODE_VARIABLE kann nützlich sein, um Zustände zwischen Makroaufrufen zu speichern. Variablennamen dürfen keine Großbuchstaben enthalten. Zum Beispiel:

```
[gcode_macro start_probe]
variable_bed_temp: 0
gcode:
  # Save target temperature to bed_temp variable
  SET_GCODE_VARIABLE MACRO=start_probe VARIABLE=bed_temp VALUE={printer.heater_bed.target}
  # Disable bed heater
  M140
  # Perform probe
  PROBE
  # Call finish_probe macro at completion of probe
  finish_probe

[gcode_macro finish_probe]
gcode:
  # Restore temperature
  M140 S{printer["gcode_macro start_probe"].bed_temp}
```

Berücksichtigen Sie bei der Verwendung von SET_GCODE_VARIABLE unbedingt das zeitliche Verhältnis von Makroauswertung und Befehlsausführung.

## Verzögerte Gcodes

Mit der Konfigurationsoption [delayed_gcode] lässt sich eine verzögerte G-Code-Sequenz ausführen:

```
[delayed_gcode clear_display]
gcode:
  M117

[gcode_macro load_filament]
gcode:
 G91
 G1 E50
 G90
 M400
 M117 Load Complete!
 UPDATE_DELAYED_GCODE ID=clear_display DURATION=10
```

Wenn das obige Makro `load_filament` ausgeführt wird, zeigt es nach Abschluss der Extrusion die Meldung "Load Complete!" an. Die letzte G-Code-Zeile aktiviert das delayed_gcode "clear_display", das zur Ausführung in 10 Sekunden eingeplant wird.

Mit der Konfigurationsoption `initial_duration` lässt sich ein delayed_gcode beim Start des Druckers ausführen. Der Countdown beginnt, sobald der Drucker den Zustand "ready" erreicht. Das folgende delayed_gcode wird zum Beispiel 5 Sekunden nach Betriebsbereitschaft des Druckers ausgeführt und initialisiert das Display mit der Meldung "Welcome!":

```
[delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
```

Ein verzögertes G-Code kann sich wiederholen, indem es sich in der Option gcode selbst neu setzt:

```
[delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
```

Das obige delayed_gcode sendet alle 2 Sekunden "// Extruder Temp: [ex0_temp]" an OctoPrint. Es lässt sich mit folgendem G-Code abbrechen:

```
UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
```

## Menüvorlagen

Ist ein [display-Konfigurationsabschnitt](Config_Reference.md#display) aktiviert, lässt sich das Menü über [menu](Config_Reference.md#menu)-Konfigurationsabschnitte anpassen.

In Menüvorlagen stehen die folgenden schreibgeschützten Attribute zur Verfügung:

* `menu.width` - Elementbreite (Anzahl der Anzeigespalten)
* `menu.ns` - Namensraum des Elements
* `menu.event` - Name des Ereignisses, das das Skript ausgelöst hat
* `menu.input` - Eingabewert, nur im Kontext eines Eingabeskripts verfügbar

In Menüvorlagen stehen die folgenden Aktionen zur Verfügung:

* `menu.back(force, update)`: führt den Menübefehl "zurück" aus, mit den optionalen booleschen Parametern `<force>` und `<update>`.
   * Ist `<force>` auf True gesetzt, wird zusätzlich der Bearbeitungsmodus beendet. Der Standardwert ist False.
   * Ist `<update>` auf False gesetzt, werden die Einträge des übergeordneten Containers nicht aktualisiert. Der Standardwert ist True.
* `menu.exit(force)` - führt den Menübefehl "beenden" aus, mit dem optionalen booleschen Parameter `<force>`, Standardwert False.
   * Ist `<force>` auf True gesetzt, wird zusätzlich der Bearbeitungsmodus beendet. Der Standardwert ist False.

## Variablen auf Festplatte speichern

Ist ein [save_variables-Konfigurationsabschnitt](Config_Reference.md#save_variables) aktiviert, lässt sich mit `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>` eine Variable auf der Festplatte speichern, sodass sie über Neustarts hinweg verfügbar bleibt. Alle gespeicherten Variablen werden beim Start in das Dictionary `printer.save_variables.variables` geladen und können in G-Code-Makros verwendet werden. Um übermäßig lange Zeilen zu vermeiden, können Sie am Anfang des Makros Folgendes einfügen:

```
{% set svv = printer.save_variables.variables %}
```

Als Beispiel ließe sich damit der Zustand eines 2-in-1-out-Hotends speichern und beim Start eines Drucks sicherstellen, dass der aktive Extruder verwendet wird statt T0:

```
[gcode_macro T1]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder1
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder1"'

[gcode_macro T0]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder"'

[gcode_macro START_GCODE]
gcode:
  {% set svv = printer.save_variables.variables %}
  ACTIVATE_EXTRUDER extruder={svv.currentextruder}
```
