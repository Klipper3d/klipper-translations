# Zellen laden

Dieses Dokument beschreibt die Unterstützung von Wägezellen in Klipper. Grundlegender Funktionsumfang kann das erfassen einer statischen Gewichtskraft sein, oder als Beispiel das erfassen des aktuellen Gewichts der Filament Spule. Der richtig kalibrierte Kraftsensor ist die Grundlage für die korrekte Funktion und Erfassung der Wägezelle.

## Zugehörige Dokumentation

* [load_cell Konfigurationsreferenz](Config_Reference.md#load_cell)
* [load_cell G-Code-Befehle](G-Codes.md#load_cell)
* [load_cell Statusreferenz](Status_Reference.md#load_cell)

## Verwendung von `LOAD_CELL_DIAGNOSTIC`

Wenn Sie eine Wägezelle zum ersten Mal anschließen, ist es empfehlenswert, mit `LOAD_CELL_DIAGNOSTIC` nach Problemen zu suchen. Dieses Werkzeug sammelt 10 Sekunden lang Daten von der Wägezelle und gibt eine Statistik aus:

```
$ LOAD_CELL_DIAGNOSTIC
// Collecting load cell data for 10 seconds...
// Samples Collected: 3211
// Measured samples per second: 332.0
// Good samples: 3211, Saturated samples: 0, Unique values: 900
// Sample range: [4.01% to 4.02%]
// Sample range / sensor capacity: 0.00524%
```

Was Sie anhand dieser Daten prüfen können:

* Die konfigurierte Abtastrate des Sensors sollte nahe am Wert 'Measured samples per second' liegen. Ist dies nicht der Fall, liegt möglicherweise ein Konfigurations- oder Verdrahtungsproblem vor.
* 'Saturated samples' sollte 0 sein. Gesättigte Messwerte bedeuten, dass auf die Wägezelle eine größere Kraft wirkt, als sie messen kann.
* 'Unique values' sollte einen großen Prozentsatz des Wertes 'Samples Collected' ausmachen. Wenn 'Unique values' gleich 1 ist, liegt sehr wahrscheinlich ein Verdrahtungsproblem vor.
* Tippen oder drücken Sie leicht auf den Sensor, während `LOAD_CELL_DIAGNOSTIC` läuft. Funktioniert alles korrekt, sollte sich dadurch der 'Sample range'-Wert erhöhen.

## Kalibrieren einer Wägezelle

Wägezellen werden mit dem Befehl `LOAD_CELL_CALIBRATE` kalibriert. Dabei handelt es sich um ein interaktives Kalibrierwerkzeug, das Sie durch einen dreistufigen Prozess führt:

1. Ermitteln Sie zunächst mit dem Befehl `TARE` den Nullkraftwert. Dies ist der Konfigurationswert `reference_tare_counts`.
1. Als Nächstes bringen Sie eine bekannte Last bzw. Kraft auf die Wägezelle auf und führen den Befehl `CALIBRATE GRAMS=nnn` aus. Daraus wird der Wert `counts_per_gram` berechnet. Im [nächsten Abschnitt](#applying-a-known-force-or-load) finden Sie einige Vorschläge, wie Sie dabei vorgehen können.
1. Speichern Sie die Ergebnisse abschließend mit dem Befehl `ACCEPT`.

Sie können den Kalibriervorgang jederzeit mit `ABORT` abbrechen.

### Aufbringen einer bekannten Kraft oder Last

Der Schritt `CALIBRATE GRAMS=nnn` lässt sich auf verschiedene Weise durchführen. Befindet sich Ihre Wägezelle unter einer Plattform wie einem Bett oder einer Filamenthalterung, ist es womöglich am einfachsten, eine bekannte Masse auf die Plattform zu legen. Sie könnten zum Beispiel ein paar 1-kg-Filamentspulen verwenden.

Sitzt Ihre Wägezelle im Druckkopf des Druckers, ist ein anderer Ansatz einfacher. Stellen Sie eine digitale Waage auf das Druckbett und senken Sie den Druckkopf vorsichtig auf die Waage ab (oder fahren Sie das Bett in den Druckkopf, falls sich Ihr Bett bewegt). Möglicherweise gelingt dies mit dem Befehl `FORCE_MOVE`. Wahrscheinlicher ist jedoch, dass Sie die Z-Achse bei ausgeschalteten Motoren von Hand bewegen müssen, bis der Druckkopf auf die Waage drückt.

Eine gute Kalibrierkraft wäre idealerweise ein großer Prozentsatz der Nennkapazität der Wägezelle. Bei einer 5-kg-Wägezelle würden Sie idealerweise mit einer Masse von 5 kg kalibrieren. Bei Sensoren unter dem Bett, die viel Gewicht tragen müssen, funktioniert das gut. Bei Sonden im Druckkopf ist dies möglicherweise eine Last, die Ihr Druckbett oder Druckkopf nicht ohne Schaden verträgt. Versuchen Sie, mindestens 1 kg Kraft aufzubringen; die meisten Drucker sollten das problemlos vertragen.

Achten Sie beim Kalibrieren genau auf die ausgegebenen Werte:

```
$ CALIBRATE GRAMS=555
// Calibration value: -2.78% (-59803108), Counts/gram: 73039.78739,
Total capacity: +/- 29.14Kg
```

Die `Total capacity` sollte nahe an der theoretischen Nennlast der Wägezelle liegen, die sich aus der Kapazität des Sensors ergibt. Ist sie deutlich größer, hätten Sie eine höhere Verstärkungseinstellung im Sensor oder eine empfindlichere Wägezelle verwenden können. Bei 32-Bit- und 24-Bit-Sensoren ist dies weniger kritisch, bei Sensoren mit geringer Bitbreite dagegen deutlich wichtiger.

## Kraftdaten auslesen

Kraftdaten können mit einem G-Code-Befehl ausgelesen werden:

```
LOAD_CELL_READ
// 10.6g (1.94%)
```

Die Daten werden außerdem fortlaufend eingelesen und können in einem Makro aus dem Druckerobjekt load_cell abgerufen werden:

```
{% set grams = printer.load_cell.force_g %}
```

Dies liefert einen Mittelwert der Kraft über die letzte Sekunde, ähnlich wie bei Temperatursensoren.

## Tarieren einer Wägezelle

Beim Tarieren, manchmal auch Nullstellen genannt, wird das aktuell von load_cell gemeldete Gewicht auf 0 gesetzt. Das ist nützlich, um relativ zu einem bekannten Gewicht zu messen. Beim Messen einer Filamentspule setzt `LOAD_CELL_TARE` das Gewicht beispielsweise auf 0. Während gedruckt wird, meldet load_cell dann das Gewicht des verbrauchten Filaments.

```
LOAD_CELL_TARE
// Load cell tare value: 5.32% (445903)
```

Der aktuelle Tara-Wert wird im Status des Druckers gemeldet und kann in einem Makro ausgelesen werden:

```
{% set tare_counts = printer.load_cell.tare_counts %}
```

# Wägezellen-Sonden

## Zugehörige Dokumentation

* [load_cell_probe Konfigurationsreferenz](Config_Reference.md#load_cell_probe)
* [load_cell_probe G-Code-Befehle](G-Codes.md#load_cell_probe)
* [load_cell_probe Statusreferenz](Status_Reference.md#load_cell_probe)

## Sicherheit der Wägezellen-Sonde

Da Wägezellen Sonden mit direktem Düsenkontakt sind, besteht die Gefahr von Schäden an Ihrem Drucker, wenn zu viel Kraft aufgewendet wird. Das Wägezellen-Sondensystem enthält mehrere Sicherheitsprüfungen, die Ihre Maschine vor übermäßiger Krafteinwirkung auf den Druckkopf schützen sollen. Es ist wichtig zu verstehen, welche das sind und wie sie funktionieren, da Sie die meisten davon durch schlecht gewählte Konfigurationswerte außer Kraft setzen können.

#### Kalibrierprüfung

Bei jedem Start einer Referenzfahrt prüft load_cell_probe, ob die load_cell kalibriert ist. Ist das nicht der Fall, wird die Bewegung mit der Fehlermeldung `!! Load Cell not calibrated` abgebrochen.

#### `counts_per_gram`

Mit dieser Einstellung werden rohe Sensorzählwerte in Gramm umgerechnet. Alle Sicherheitsgrenzen sind zu Ihrer Bequemlichkeit in Gramm angegeben. Ist die Einstellung `counts_per_gram` nicht genau, können Sie die sichere Kraft am Druckkopf leicht überschreiten. Sie sollten diesen Wert niemals schätzen. Ermitteln Sie den tatsächlichen `counts_per_gram`-Wert Ihrer Wägezelle mit `LOAD_CELL_CALIBRATE`.

#### `trigger_force`

Dies ist die Kraft in Gramm, die den Endschalter auslöst und die Referenzfahrt stoppt. Beim Start einer Referenzfahrt tariert sich der Endschalter mit dem aktuellen Messwert der Wägezelle. `trigger_force` wird ausgehend von diesem Tara-Wert gemessen. Beim Auftreffen der Sonde auf das Bett kommt es immer zu einer gewissen Überschreitung dieses Wertes, wählen Sie ihn daher konservativ. Eine Einstellung von 100 g kann zum Beispiel zu einer Spitzenkraft von 350 g führen, bevor der Druckkopf stoppt. Diese Überschreitung nimmt mit höherer Abtastgeschwindigkeit (`speed`), einer niedrigen ADC-Abtastrate oder bei [Multi-MCU-Homing](Multi_MCU_Homing.md) zu.

#### `reference_tare_counts`

Dies ist der Basis-Tara-Wert, der von `LOAD_CELL_CALIBRATE` gesetzt wird. Zusammen mit `force_safety_limit` begrenzt dieser Wert die maximale Kraft auf den Druckkopf.

#### `force_safety_limit`

Dies ist die maximale absolute Kraft relativ zu `reference_tare_counts`, die die Sonde beim Referenzieren oder Abtasten zulässt. Stellt der Mikrocontroller eine Überschreitung dieser Kraft fest, schaltet er den Drucker mit der Fehlermeldung `!! Load cell endstop: too much force!` ab. Dies kann auf verschiedene Weise ausgelöst werden:

Das erste Risiko, gegen das dies schützt, ist die Wahl eines zu großen Wertes für `drift_filter_cutoff_frequency`. Dadurch kann der Driftfilter ein Sondenereignis herausfiltern und die Referenzfahrt fortsetzen. In diesem Fall dient `force_safety_limit` als Rückfallschutz.

Das zweite Problem ist wiederholtes Abtasten an derselben Stelle. Klipper zieht die Sonde bei einem einzelnen `PROBE`-Befehl nicht zurück. Dadurch kann am Ende eines Abtastzyklus Kraft auf den Druckkopf wirken. Da externe Kräfte zwischen den Abtastpositionen stark schwanken können, führt `load_cell_probe` vor jedem Abtastvorgang ein Tarieren durch. Wiederholen Sie den `PROBE`-Befehl, tariert load_cell_probe den Endschalter bei der aktuell anliegenden Kraft. Mehrere solcher Zyklen führen zu einer immer weiter steigenden Kraft auf den Druckkopf. `force_safety_limit` verhindert, dass dieser Kreislauf außer Kontrolle gerät.

Ein weiterer Weg, wie dieses Durchgehen (Run-away) auftreten kann, ist eine Beschädigung eines Dehnungsmessstreifens. Ist das Metallteil dauerhaft verbogen, ändert sich dadurch der `reference_tare_counts`-Wert des Geräts. Dies bringt den Start-Tara-Wert deutlich näher an die Grenze heran, wodurch eine Überschreitung wahrscheinlicher wird. Sie sollten benachrichtigt werden, wenn dies geschieht, da Ihre Hardware dann dauerhaft beschädigt wurde.

Der letzte Weg, wie dies ausgelöst werden kann, sind Temperaturänderungen. Wenn Ihre Dehnungsmessstreifen erwärmt werden, können ihre `reference_tare_counts` bei Umgebungstemperatur stark von denen bei Betriebstemperatur abweichen. In diesem Fall müssen Sie möglicherweise `force_safety_limit` erhöhen, um thermische Änderungen zu berücksichtigen.

#### Load-Cell-Endstop-Watchdog-Task

Beim Homing startet der load_cell_endstop eine Task auf dem MCU, um die vom Sensor eintreffenden Messungen zu verfolgen. Sendet der Sensor über 2 Abtastperioden keine Messungen, fährt der Watchdog den Drucker mit dem Fehler `!! LoadCell Endstop timed out waiting on ADC data` herunter.

Tritt dies auf, ist die wahrscheinlichste Ursache ein Fehler des ADC. Eine unzureichende Erdung Ihres Druckers kann die Grundursache sein. Rahmen, Netzteilgehäuse und Druckbett sollten alle mit der Erde verbunden sein. Möglicherweise müssen Sie den Rahmen an mehreren Stellen erden. Eloxierte Aluminiumprofile leiten Strom nur schlecht. Eventuell müssen Sie die Stelle, an der das Erdungskabel befestigt wird, anschleifen, um einen guten elektrischen Kontakt herzustellen.

#### Interpolation

Um die Präzision des Sondierungsergebnisses zu erhöhen, kann die Position des ersten Kontakts zwischen Düse und Bett durch Anpassen einer stückweisen Funktion an die gemessenen Daten geschätzt werden. Die Daten bestehen aus zwei Bereichen: Solange sich die Düse über dem Bett befindet, bleibt die Kraft konstant (beim Tara-Wert). Sobald die Düse das Bett berührt, steigt die Kraft mit abnehmender Z-Position linear an. An die Daten wird eine stückweise Funktion angepasst, und die optimale Z-Position des Übergangspunkts wird durch Minimierung des quadratischen Fehlers ermittelt. Dies ermöglicht eine feinere Auflösung als der Abstand zwischen den Abtastpunkten und macht das Ergebnis zudem weniger anfällig für Rauschen.

Aus physikalischen wie technischen Gründen nutzt die Interpolation Daten, die während einer zusätzlichen Aufwärtsbewegung nach der anfänglichen Abwärtsbewegung erfasst werden. Die ersten 300 ms der während der Aufwärtsbewegung erfassten Daten werden für die Anpassung verwendet (dies minimiert den Einfluss von Tara-Drift). Die erfassten Daten müssen genügend Abtastwerte für die Anpassung enthalten: Es werden mindestens 3 Abtastwerte jeweils unterhalb und oberhalb des Kontaktpunkts benötigt.

Es wird empfohlen, für die Sonde eine relativ hohe Auslösekraft zu verwenden, um ein ausreichend starkes Signal zu erhalten. Wenn Sie zu wenige Abtastwerte unterhalb des Kontaktpunkts haben, versuchen Sie, `trigger_force` zu erhöhen oder `lift_speed` zu verringern. Ist `lift_speed` jedoch zu gering, gibt es aufgrund des 300-ms-Fensters zu wenige Abtastwerte oberhalb des Kontaktpunkts.

Die Distanz der Aufwärtsbewegung kann über den Parameter `sample_retract_dist` konfiguriert werden.

## Einrichtung der Load-Cell-Sonde

Dieser Abschnitt behandelt den Prozess der Inbetriebnahme einer Load-Cell-Sonde.

### Zunächst die Load Cell überprüfen

Eine `[load_cell_probe]` ist auch eine `[load_cell]`, und G-Code-Befehle, die sich auf `[load_cell]` beziehen, funktionieren auch mit `[load_cell_probe]`. Bevor Sie versuchen, eine Load-Cell-Sonde zu verwenden, befolgen Sie die Anleitung zum [Kalibrieren der Load Cell](Load_Cell.md#calibrating-a-load-cell) mit `CALIBRATE_LOAD_CELL` und prüfen Sie deren Funktion mit `LOAD_CELL_DIAGNOSTIC`.

### Sondenfunktion mit LOAD_CELL_TEST_TAP überprüfen

Verwenden Sie den Befehl `LOAD_CELL_TEST_TAP`, um die Funktion der Load-Cell-Sonde zu testen, bevor Sie tatsächlich damit sondieren. Dieser Befehl erkennt Tipp-Ereignisse, ähnlich wie der Befehl PROBE, bewegt jedoch nicht die Z-Achse. Standardmäßig wartet er auf 3 Tipp-Ereignisse, bevor der Test beendet wird. Sie haben 30 Sekunden Zeit für jedes Tippen; werden keine Tipp-Ereignisse erkannt, läuft der Befehl in ein Timeout.

Schlägt dieser Test fehl, überprüfen Sie sorgfältig Ihre Konfiguration und `LOAD_CELL_DIAGNOSTIC` auf mögliche Probleme.

Load-Cell-Sonden unterstützen die Befehle `QUERY_ENDSTOPS` oder `QUERY_PROBE` nicht. Verwenden Sie `LOAD_CELL_TEST_TAP`, um die Funktion vor dem Sondieren zu testen.

### Empfohlene Sondierungstemperatur

Aktuell wird empfohlen, die Düsentemperatur unterhalb des Niveaus zu halten, bei dem Filament beim Homing und Sondieren austritt (Oozing). 140°C ist ein guter Ausgangswert. Diese Temperatur ist außerdem niedrig genug, um PEI-Druckoberflächen nicht zu beschädigen.

Verschmutzung von Düse und Druckbett durch austretendes Filament ist die häufigste Fehlerursache bei der Load-Cell-Sonde. Klipper verfügt noch nicht über eine universelle Methode, um Tipp-Ereignisse schlechter Qualität durch Filament-Oozing zu erkennen. Der bestehende Code kann ein Tipp-Ereignis fälschlich als gültig einstufen, obwohl es von schlechter Qualität ist. Die Klassifizierung solcher minderwertigen Tipp-Ereignisse ist Gegenstand aktiver Forschung.

Klipper unterstützt außerdem nicht das erneute Verschieben eines Sondierungspunkts, falls die Stelle durch Filament-Oozing verunreinigt wurde. Module wie `quad_gantry_level` sondieren wiederholt dieselben Koordinaten, selbst wenn eine Sondierung dort zuvor fehlgeschlagen ist.

Angesichts dessen wird dringend empfohlen, nicht bei Drucktemperaturen zu sondieren.

### Schutz vor der heißen Düse

The Voron project has a great macro for protecting your print surface from the hot nozzle. See [Voron Tap's
`activate_gcode`](https://github.com/VoronDesign/Voron-Tap/blob/main/config/tap_klipper_instructions.md)

Es wird dringend empfohlen, Ihrer Konfiguration etwas Ähnliches hinzuzufügen.

### Düsenreinigung

Vor dem Sondieren sollte die Düse sauber sein. Sie können dies manuell vor jedem Druck erledigen. Sie können auch eine Düsenbürste einbauen und den Vorgang automatisieren. Hier eine vorgeschlagene Ablaufreihenfolge:

1. Warten, bis die Düse auf Sondierungstemperatur aufgeheizt ist (z. B. `M109 S140`)
1. Maschine homen (`G28`)
1. Düse an einer Bürste abstreifen
1. Druckbett aufheizen und warten lassen (Heat Soak)
1. Sondierungsaufgaben durchführen: QGL, Bed Mesh usw.

### Temperaturkompensation für Düsenwachstum

Wenn Sie bei einer sicheren Temperatur sondieren, dehnt sich die Düse nach dem Aufheizen auf Drucktemperatur aus. Dadurch wird die Düse länger und rückt näher an die Druckoberfläche heran. Sie können dies mit [[z_thermal_adjust]](Config_Reference.md#z_thermal_adjust) kompensieren. Diese Anpassung funktioniert über einen Bereich von Drucktemperaturen von PLA bis PC.

#### Berechnung von `temp_coeff` für `[z_thermal_adjust]`

Am einfachsten messen Sie dies bei 2 unterschiedlichen Temperaturen. Idealerweise sollten dies die Ober- und Untergrenze des Drucktemperaturbereichs sein, z. B. 180°C und 290°C. Sie können bei beiden Temperaturen eine `PROBE_ACCURACY` durchführen und anschließend die Differenz des `average z`-Werts beider Messungen berechnen.

Der Anpassungswert ist die Änderung der Düsenlänge geteilt durch die Temperaturänderung, z. B.

```
temp_coeff = -0.05 / (290 - 180) = -0.00045455
```

Das erwartete Ergebnis ist eine negative Zahl. Positive Werte für `temp_coeff` bewegen die Düse näher zum Bett, negative Werte bewegen sie weiter weg. Da die Düse im heißen Zustand länger wird, muss sie in der Regel weiter vom Bett wegbewegt werden.

#### `[z_thermal_adjust]` konfigurieren

Richten Sie z_thermal_adjust so ein, dass es den `extruder` als Quelle für die Temperaturdaten referenziert, z. B.:

```
[z_thermal_adjust]
temp_coeff=-0.00045455
sensor_type: temperature_combined
sensor_list: extruder
combination_method: max
maximum_deviation: 999
min_temp: 0
max_temp: 400
max_z_adjustment: 0.1
```

## Kontinuierliche Tara-Filter für Werkzeugkopf-Load-Cells

Klipper implementiert einen konfigurierbaren IIR-Filter auf dem MCU, um während des Sondierens eine kontinuierliche Tarierung der Load Cell zu ermöglichen. Kontinuierliche Tarierung bedeutet, dass sich der 0-Wert mit der durch äußere Faktoren wie Bowden-Schläuche und thermische Änderungen verursachten Drift mitbewegt. Dies ist auf Werkzeugkopfsensoren und bewegte Betten ausgerichtet, die während des Sondierens vielen sich ändernden äußeren Kräften ausgesetzt sind.

### SciPy installieren

Der Filtercode verwendet die ausgezeichnete Bibliothek [SciPy](https://scipy.org/), um die Filterkoeffizienten anhand der in die Konfiguration eingetragenen Werte zu berechnen.

Vorkompilierte SciPy-Builds sind für Python 3 auf 32-Bit-Raspberry-Pi-Systemen verfügbar. 32 Bit + Python 3 wird dringend empfohlen, da dies die Installation deutlich vereinfacht. Es funktioniert auch mit Python 2, die Installation kann dann jedoch über 30 Minuten dauern und die Installation zusätzlicher Werkzeuge erfordern.

```bash
~/klippy-env/bin/pip install scipy
```

### Filter-Workbench

Die Filterparameter sollten anhand der im Normalbetrieb des Druckers beobachteten Drift ausgewählt werden. Ein Jupyter-Notebook wird in scripts bereitgestellt, [filter_workbench.ipynb](../scripts/filter_workbench.ipynb), um eine detaillierte Untersuchung mit real erfassten Daten und FFTs durchzuführen.

### Empfehlungen zur Filterung

Für alle, die einfach nur einen funktionierenden Filter einrichten möchten, gelten folgende Empfehlungen:

* Die einzig unverzichtbare Option ist `drift_filter_cutoff_frequency`. Ein vorsichtiger Startwert ist `0.5` Hz. Prusa lieferte den MK4 mit einer Einstellung von `0.8` Hz aus, den XL mit `11.2` Hz. Das ist wahrscheinlich ein sicherer Bereich zum Experimentieren. Dieser Wert sollte nur so weit erhöht werden, bis die normale, durch die Kraft des Bowden-Schlauchs verursachte Drift beseitigt ist. Wird dieser Wert zu hoch eingestellt, führt dies zu langsamem Auslösen und übermäßiger Kraftbelastung des Werkzeugkopfs.
* Halten Sie `trigger_force` niedrig. Der Standardwert ist `75` g. Der Drift-Filter hält den internen Gramm-Wert sehr nahe bei 0, sodass keine große Auslösekraft benötigt wird.
* Halten Sie `force_safety_limit` auf einem konservativen Wert. Der Standardwert beträgt 2 kg und sollte Ihren Werkzeugkopf während des Experimentierens schützen. Erreichen Sie dieses Limit, ist der Wert für `drift_filter_cutoff_frequency` möglicherweise zu hoch.

## Empfehlungen für Load-Cell-Toolboards

Dieser Abschnitt behandelt Empfehlungen für Entwickler von Werkzeugkopf-Platinen, die [load_cell_probe] unterstützen möchten

### ADC-Sensorauswahl & Hinweise zur Platinenentwicklung

Idealerweise sollte ein Sensor folgende Kriterien erfüllen:

* Mindestens 24 Bit breit
* SPI-Kommunikation verwenden
* Verfügt über einen Pin, mit dem die Bereitschaft einer Abtastung ohne SPI-Kommunikation signalisiert werden kann. Dies wird oft als "Data Ready"- oder "DRDY"-Pin bezeichnet. Das Prüfen eines Pins ist deutlich schneller als eine SPI-Abfrage.
* Verfügt über eine programmierbare Verstärkereinstellung (Gain) von 128. Dies sollte die Notwendigkeit eines separaten Verstärkers überflüssig machen.
* Zeigt per SPI an, wenn der Sensor zurückgesetzt wurde. Das Erkennen von Resets vermeidet Timing-Fehler beim Homing sowie die Verwendung verrauschter Daten beim Start. Es kann Anwendern zudem helfen, Verkabelungs- und Erdungsprobleme aufzuspüren.
* Eine wählbare Abtastrate zwischen 350 Hz und 2 kHz. Sehr hohe Abtastraten erweisen sich in unseren 3D-Druckern nicht als vorteilhaft, da sie bei schnellen Bewegungen sehr viel Rauschen erzeugen. Abtastraten unter 250 Hz erfordern langsamere Sondierungsgeschwindigkeiten. Sie erhöhen zudem die Kraft auf den Werkzeugkopf durch längere Verzögerungen zwischen den Messungen. Ein 500-Hz-Sensor, der sich mit 5 mm/s bewegt, hat beispielsweise denselben Sicherheitsfaktor wie ein 100-Hz-Sensor, der sich nur mit 1 mm/s bewegt.
* Wenn Sie für Unter-Bett-Anwendungen entwerfen und mehrere Load Cells erfassen möchten, verwenden Sie einen Chip, der alle seine Eingänge gleichzeitig abtasten kann. Multiplex-ADCs, die ein Umschalten der Kanäle erfordern, benötigen nach jedem Kanalwechsel eine Einschwingzeit von mehreren Abtastungen und sind daher für Sondierungsanwendungen ungeeignet.

Die Unterstützung eines neuen Sensorchips zu implementieren ist mit Klippers `bulk_sensor`- und `load_cell_endstop`-Infrastruktur nicht besonders schwierig.

### 5V-Spannungsfilterung

Es wird dringend empfohlen, größere Kondensatoren zu verwenden, als vom Hersteller des ADC-Chips angegeben. ADC-Chips sind meist für rauscharme Umgebungen wie batteriebetriebene Geräte ausgelegt. Die von Sensorherstellern vorgeschlagenen Application Notes gehen im Allgemeinen von einer ruhigen Stromversorgung aus. Betrachten Sie deren vorgeschlagene Kondensatorwerte als Minimum.

3D-Drucker erzeugen enorme Mengen an Störungen auf dem 5V-Bus, was die Genauigkeit des Sensors ruinieren kann. Testen Sie den Sensor auf der Platine mit einem typischen 3D-Drucker-Netzteil und aktiven Schrittmotortreibern, bevor Sie sich für Glättungskondensatorgrößen entscheiden.

### Erdung & Massefläche

Analoge ADC-Chips enthalten Komponenten, die sehr anfällig für Rauschen und ESD sind. Eine große Massefläche auf der ersten Platinenlage unter dem Chip kann gegen Rauschen helfen. Halten Sie den Chip von Leistungsteilen und DC-DC-Wandlern fern. Die Platine sollte eine ordnungsgemäße Erdung zurück zur DC-Versorgung besitzen.

### Hinweise zu HX711 und HX717

Dieser Sensor ist aufgrund seiner niedrigen Kosten und guten Verfügbarkeit in der Lieferkette beliebt. Allerdings hat dieser Sensor einige Nachteile:

* Die HX71x-Sensoren nutzen Bit-Bang-Kommunikation, was einen hohen Overhead auf dem MCU verursacht. Ein Sensor mit SPI-Kommunikation würde Ressourcen auf der CPU des Toolboards sparen.
* Dem HX71x fehlt eine Möglichkeit, Reset-Ereignisse an das MCU zu melden. Klipper erkennt Resets mit einer Timing-Heuristik, was jedoch nicht ideal ist. Resets deuten auf ein Verkabelungs- oder Erdungsproblem hin.
* Für Sondierungsanwendungen wird die HX717-Version aufgrund ihrer höheren Abtastrate (320 statt 80) dringend bevorzugt. Die Sondierungsgeschwindigkeit sollte beim HX711 auf unter 2 mm/s begrenzt werden.
* Die Abtastrate des HX71x kann nicht über Klippers Konfiguration eingestellt werden. Wenn Sie die (weit verbreitete) 10SPS-Version des Sensors besitzen, muss dieser physisch umverdrahtet werden, um mit 80SPS zu laufen.
