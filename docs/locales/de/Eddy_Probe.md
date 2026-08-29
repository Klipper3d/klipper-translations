# Induktive Wirbelstromsonde

Dieses Dokument beschreibt die Unterstützung induktiver [Wirbelstrom-Sonden](https://en.wikipedia.org/wiki/Eddy_current) in Klipper.

Diese Sonden erkennen das Bett, indem sie die [Resonanzfrequenz](https://en.wikipedia.org/wiki/Resonance) einer Spule im Sensor messen. Je näher sich diese Spule an einem Metallbett befindet, desto höher ist die Resonanzfrequenz der Spule. Die Frequenzmessungen lassen sich somit nutzen, um den Abstand zwischen Sensor und Bett abzuschätzen.

## Messverfahren

Anders als herkömmliche Bettsonden unterstützt ein Wirbelstromsensor vier verschiedene Messverfahren: Standard, "scan", "rapid_scan" und "tap". Die verschiedenen Verfahren werden aktiviert, indem den Sondenbefehlen ein Parameter `METHOD=xxx` übergeben wird (zum Beispiel `PROBE METHOD=tap`). Jedes Verfahren hat Vor- und Nachteile, die im Folgenden beschrieben werden.

### Standard-Messverfahren

Das Standard-Messverfahren verhält sich am ehesten wie eine herkömmliche Bettsonde. Der Druckkopf fährt zum Bett hinab, bis der Sensor erkennt, dass er sich nahe am Bett befindet; anschließend werden an der angehaltenen Position mehrere Sensormessungen vorgenommen, um den Abstand zwischen Sensor und Bett abzuschätzen. Dieses Messverfahren wird aktiviert, indem bei Sondenbefehlen kein `METHOD`-Parameter angegeben wird (z. B. ein einfacher `PROBE`-Befehl).

Vorteile:

* Es ist das vielseitigste Messverfahren. Es bietet eine gute Präzision bei hoher Flexibilität.
* Es kann aus vielen Ausgangspositionen des Druckkopfs verwendet werden. Es muss sichergestellt sein, dass die XY-Position des Druckkopfs den Sensor über dem Metallbett positioniert; ansonsten besteht Flexibilität hinsichtlich der genauen Starthöhe.

Nachteile:

* Die Messergebnisse unterliegen thermischer Drift. Die von der Sonde gemeldeten Abstände beziehen sich auf die während der ersten Kalibrierung (mittels `PROBE_EDDY_CURRENT_CALIBRATE`) gemessenen Abstände, und die Ergebnisse können beeinträchtigt werden, wenn die Messung bei einer anderen Temperatur erfolgt. Änderungen der Temperatur des Betts, der Sensorspule, der Sensorelektronik oder von Metall in der Nähe des Sensors können sich jeweils auf die Ergebnisse auswirken. Der Einfluss ist gering (im Mikrometerbereich), aber die geforderte Genauigkeit einer Bettsonde ist ebenfalls gering (ebenfalls im Mikrometerbereich). Für beste Ergebnisse wird empfohlen, die Kalibrierung und die anschließenden Messungen bei gleichbleibender Temperatur durchzuführen.

Wann zu verwenden:

Dies ist das Standard-Messverfahren und wird für die meisten Messvorgänge empfohlen. Insbesondere ist es das empfohlene Verfahren für Werkzeuge zur Bettausrichtung wie `QUAD_GANTRY_LEVEL`, `Z_TILT_ADJUST`, `SCREWS_TILT_CALCULATE`, `DELTA_CALIBRATE` und ähnliche.

### Messverfahren "scan"

Das Messverfahren "scan" ähnelt dem Standardverfahren, allerdings fährt die Sonde nicht zum Bett hinab. Stattdessen erfasst die Sonde Messwerte an der aktuellen Z-Position, um den Abstand zwischen Sensor und Bett abzuschätzen. Es ist nützlich für `BED_MESH_CALIBRATE`, da das gesamte Bett allein mit horizontalen Bewegungen abgetastet werden kann.

Vorteile:

* Die Z-Position ändert sich während der Messung nicht, und die Wahrscheinlichkeit, dass Spiel der Z-Schrittmotoren (und Ähnliches) die Messungen beeinflusst, ist geringer. Das kann besonders nützlich sein, wenn nur relative Z-Höhenmessungen gewünscht sind (z. B. bei Verwendung von `zero_reference_position` mit `BED_MESH_CALIBRATE`).
* Ein vollständiger Bettscan kann weniger Zeit in Anspruch nehmen als das Standardverfahren.

Nachteile:

* Das Bett muss nahezu parallel zu den XY-Achsen des Druckers verlaufen, und es dürfen keine großen Abweichungen der Betthöhe vorliegen. Für brauchbare Ergebnisse muss der Bettscan mit einem niedrigen `HORIZONTAL_MOVE_Z` ausgeführt werden, damit der Sensor während des gesamten Scans nahe am Bett bleibt. (Je geringer der Abstand, desto genauer die Ergebnisse.) In der Praxis erfordert das, dass der Abstand zwischen Düse und Bett nicht mehr als etwa einen Millimeter beträgt; bei diesen Abständen können nennenswerte Bettabweichungen zu einer Kollision von Düse und Bett während der horizontalen Bewegung führen.
* Das Verfahren "scan" weist dieselben Nachteile hinsichtlich thermischer Drift auf wie das Standardverfahren. Für beste Ergebnisse wird empfohlen, die Kalibrierung und die anschließenden Messungen bei gleichbleibender Temperatur durchzuführen.

Wann zu verwenden:

Das Verfahren "scan" wird typischerweise bei der Kalibrierung des Bett-Meshes verwendet. Es wird empfohlen, vor einem Bettscan stets zu überprüfen, ob das Bett parallel zu den XY-Achsen des Druckers verläuft. Je nach Druckerhardware kann dazu ein automatisiertes Werkzeug mit dem Standard-Messverfahren genutzt werden, zum Beispiel: `QUAD_GANTRY_LEVEL RETRY_TOLERANCE=0.250`, `Z_TILT_ADJUST RETRY_TOLERANCE=0.250` oder `SCREWS_TILT_CALCULATION MAX_TOLERANCE=0.250`.

Ein Bett-Mesh kann anschließend etwa mit `BED_MESH_CALIBRATE METHOD=scan HORIZONTAL_MOVE_Z=1` erstellt werden.

### Messverfahren "rapid_scan"

Das Messverfahren "rapid_scan" ähnelt stark dem Verfahren "scan", allerdings hält die Sonde an den einzelnen Messpunkten nicht an. Stattdessen werden Messwerte, die während der horizontalen Bewegung nahe jedem Messpunkt erfasst werden, zur Abschätzung des Abstands zwischen Sensor und Bett verwendet.

Vorteile:

* Ein vollständiger Bett-Scan mit "rapid_scan" kann etwas schneller sein als die Methode "scan".
* Ansonsten hat es dieselben Vorteile wie die Methode "scan".

Nachteile:

* Die Ergebnisse eines "rapid_scan" können weniger genau sein als die der Methode "scan".
* Dieselben Nachteile wie bei "scan"-Sonden (Bett muss parallel sein, thermische Drift).

Wann zu verwenden:

Ein "rapid_scan" kann nützlich sein, wenn ein großer, detaillierter Bed-Mesh-Scan zu Diagnosezwecken durchgeführt wird. In diesem Fall kann die verkürzte Scan-Zeit den möglichen Genauigkeitsverlust aufwiegen.

Für den normalen Druckbetrieb wird für beste Genauigkeit und minimale zusätzliche Sondierungszeit im Allgemeinen ein Bed Mesh mit der regulären Methode "scan" bevorzugt.

Sobald sichergestellt ist, dass das Bett parallel zu den XY-Schienen ausgerichtet ist, kann ein schneller Bed-Mesh-Scan mit etwas wie `BED_MESH_CALIBRATE METHOD=rapid_scan HORIZONTAL_MOVE_Z=1` durchgeführt werden.

### Sondierungsmethode "tap"

Bei der Sondierung mit "tap" senkt sich der Werkzeugkopf ab, bis die Düse das Bett berührt. Anschließend wird die Düse wieder vom Bett abgehoben, und die Sensormesswerte während der Hebebewegung werden analysiert, um den Punkt zu bestimmen, an dem sich die Düse vom Bett löst.

Vorteile:

* Die Sondierungsergebnisse werden durch den tatsächlichen Kontaktpunkt zwischen Düse und Bett bestimmt, statt durch indirekte Messungen zwischen Sensor und Bett. Dies kann besonders nützlich sein, wenn häufig Düsen gewechselt werden, da die Ergebnisse die Geometrie der aktuellen Düse berücksichtigen.
* Eine "tap"-Sondierung hat nicht die thermischen Driftprobleme der anderen Sondierungsmethoden. Die Hauptsonden-Kalibrierung wird bei Tap-Sondierungen nicht verwendet, sodass die Temperaturen zwischen der ursprünglichen Kalibrierung und späterer Sondierung nicht nachverfolgt werden müssen.
* Ungenauigkeiten durch "Achsverdrehung" (Twist) spielen bei Tap-Sondierungen eine geringere Rolle, da es keinen XY-Sondenversatz gibt, der ausgeglichen werden müsste. Dennoch muss sichergestellt werden, dass die XY-Position des Werkzeugkopfs vor der Tap-Sondierung sowohl Düse als auch Sensor über dem Bett platziert.

Nachteile:

* Vor der Tap-Sondierung müssen sowohl Düse als auch Bett sauber sein. Filamentreste an der Düse oder Verunreinigungen auf dem Bett können die Sondierungsergebnisse erheblich verfälschen.
* Vor Beginn jedes "tap"-Sondierungsversuchs muss sichergestellt werden, dass die Düse etwa 3-20 mm vom Bett entfernt ist. Startet die Düse zu nahe am Bett, wird der Kontakt möglicherweise nicht erkannt, was zu einer unkontrollierten Kollision zwischen Düse und Bett führen kann. Startet die Düse zu weit vom Bett entfernt, sind die Sensormesswerte ungenau, und ein Tap-Versuch kann fehlschlagen oder ungenaue Ergebnisse liefern.
* Die Druckerhardware muss es der Düse ermöglichen, das Bett vollständig zu berühren. Es dürfen keine Endschalter oder Schlittenanschläge vorhanden sein, die vor der Düse mit dem Bett in Kontakt kommen.
* Es muss sichergestellt werden, dass die Düsentemperatur für das Bett nicht zu hoch ist. Eine zu hohe Temperatur könnte beispielsweise die PEI-Beschichtung mancher Betten zum Schmelzen bringen.

Wann zu verwenden:

Eine "tap"-Sondierung wird oft als ein Schritt innerhalb eines mehrstufigen Homing-/Nivellierungsprozesses verwendet, um die aktuelle Düsengeometrie zu berücksichtigen und Fehler durch thermische Drift zu reduzieren. So könnte man beispielsweise ein Makro einsetzen, das homt, `Z_TILT_ADJUST` mit der Standard-Sondierungsmethode aufruft, den Drucker auf eine mittlere Temperatur aufheizt, die Düse durch wiederholtes Abwischen an einer Bürste reinigt, eine "tap"-Sondierung durchführt, die Tap-Ergebnisse mit `SET_KINEMATIC_POSITION` übernimmt, `BED_MESH_CALIBRATE` unter Verwendung einer `zero_reference_position` ausführt und den Drucker anschließend auf normale Drucktemperatur bringt. Die konkreten Schritte zur Nutzung einer "tap"-Sondierung hängen stark von der jeweiligen Druckerhardware ab.

Eine "tap"-Sondierung kann mit etwas wie `PROBE METHOD=tap` gestartet werden.

## Konfiguration

Um eine Wirbelstromsonde (Eddy Current Probe) zu konfigurieren, deklarieren Sie zunächst einen [probe_eddy_current-Konfigurationsabschnitt](Config_Reference.md#probe_eddy_current) in der Datei printer.cfg. Es wird empfohlen, `descend_z` auf 0,5 mm zu setzen. Üblicherweise benötigt der Sensor einen `x_offset` und `y_offset`. Sind diese Werte nicht bekannt, sollten sie während der ersten Kalibrierung geschätzt werden.

Starten Sie anschließend den Drucker neu und fahren Sie mit den folgenden Kalibrierungsschritten fort.

### Kalibrierung des Treiberstroms

Der erste Schritt der Kalibrierung besteht darin, den passenden DRIVE_CURRENT für den Sensor zu ermitteln. Führen Sie ein Homing des Druckers durch und verfahren Sie den Druckkopf so, dass sich der Sensor nahe der Bettmitte und etwa 20 mm über dem Bett befindet. Setzen Sie dann den Befehl `LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` ab. Wenn der Konfigurationsabschnitt beispielsweise `[probe_eddy_current my_eddy_probe]` heißt, würde man `LDC_CALIBRATE_DRIVE_CURRENT CHIP=my_eddy_probe` ausführen. Dieser Befehl sollte in wenigen Sekunden abgeschlossen sein. Setzen Sie danach einen `SAVE_CONFIG`-Befehl ab, um die Ergebnisse in der printer.cfg zu speichern und neu zu starten.

### Kalibrierung der Z-Höhen

Der zweite Schritt der Kalibrierung besteht darin, die Sensormesswerte den entsprechenden Z-Höhen zuzuordnen. Homen Sie den Drucker und bewegen Sie den Werkzeugkopf so, dass sich die Düse nahe der Bettmitte befindet. Führen Sie dann den Befehl `PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe` aus. Sobald das Werkzeug startet, folgen Sie den unter ["dem Papiertest"](Bed_Level.md#the-paper-test) beschriebenen Schritten, um den tatsächlichen Abstand zwischen Düse und Bett an der jeweiligen Stelle zu bestimmen. Sind diese Schritte abgeschlossen, kann die Position mit `ACCEPT` bestätigt werden. Das Werkzeug bewegt den Werkzeugkopf anschließend so, dass sich der Sensor über der Stelle befindet, an der zuvor die Düse war, und führt eine Reihe von Bewegungen aus, um den Sensor den Z-Positionen zuzuordnen. Dies dauert einige Minuten. Nach Abschluss gibt das Werkzeug die Sensor-Leistungsdaten aus:

```
probe_eddy_current: noise 0.000642mm, MAD_Hz=11.314 in 2525 queries
Total frequency range: 45000.012 Hz
z: 0.250 # noise 0.000200mm, MAD_Hz=11.000
z: 0.530 # noise 0.000300mm, MAD_Hz=12.000
z: 1.010 # noise 0.000400mm, MAD_Hz=14.000
z: 2.010 # noise 0.000600mm, MAD_Hz=12.000
z: 3.010 # noise 0.000700mm, MAD_Hz=9.000
```

Führen Sie den Befehl `SAVE_CONFIG` aus, um die Ergebnisse in der printer.cfg zu speichern, und starten Sie neu.

Nach der ersten Kalibrierung ist es ratsam zu überprüfen, ob `x_offset` und `y_offset` korrekt sind. Folgen Sie dazu den Schritten zum [Kalibrieren der X- und Y-Offsets der Sonde](Probe_Calibrate.md#calibrating-probe-x-and-y-offsets). Wenn `x_offset` oder `y_offset` geändert werden, führen Sie anschließend unbedingt den Befehl `PROBE_EDDY_CURRENT_CALIBRATE` (wie oben beschrieben) aus.

Beachten Sie, dass Wirbelstromsensoren anfällig für "thermische Drift" sind. Das bedeutet, Temperaturänderungen können zu Änderungen der gemeldeten Z-Höhe führen. Sowohl Änderungen der Betttemperatur als auch der Sensorhardware-Temperatur können die Ergebnisse beeinflussen. Für beste Ergebnisse sollten daher die hier durchgeführte Kalibrierung und die anschließende Sondierung, die diese Kalibrierung nutzt, bei derselben Temperatur erfolgen.

### Tap-Kalibrierung

Um "tap"-Sondierung nutzen zu können, müssen einige Parameter konfiguriert werden.

Es muss möglich sein, den Werkzeugkopf unterhalb der nominellen Bettebene zu bewegen. Dies geschieht typischerweise, indem `position_min: -1` im Konfigurationsabschnitt `[stepper_z]` der printer.cfg gesetzt wird (oder eine ähnliche Einstellung wie `minimum_z_position`, je nach Kinematik). Dies ist notwendig, um sicherzustellen, dass die Düse fest mit dem Bett in Kontakt gebracht werden kann. Außerdem wird so sichergestellt, dass die Düse das Bett berührt, bevor sonst mit dem Abbremsen begonnen würde.

Außerdem muss ein Parameter `tap_threshold` konfiguriert werden. Dieser Parameter bestimmt, wann die Abwärtsbewegung des Werkzeugkopfs während einer "tap"-Sondierung gestoppt werden soll. Ein zu großer Wert könnte dazu führen, dass ein Düse-Bett-Kontakt nicht erkannt wird, was zu einer unkontrollierten Kollision der Düse mit dem Bett führen könnte. Ein zu kleiner Wert könnte dazu führen, dass ein "tap"-Sondierungsversuch stoppt, bevor das Bett berührt wird, was zu Sondierungsfehlern oder ungenauen Ergebnissen führen kann.

Mit dem Befehl `PROBE_EDDY_CURRENT_TAP_CALIBRATE` kann ein geeigneter `tap_threshold`-Wert konfiguriert werden. Dieses Werkzeug kann nach Abschluss der Hauptkalibrierung `PROBE_EDDY_CURRENT_CALIBRATE` ausgeführt werden. Befolgen Sie diese Schritte, um `tap_threshold` zu kalibrieren:

1. Stellen Sie sicher, dass Düse und Bett sauber sind. Aktivieren Sie den Drucker, homen Sie ihn, bewegen Sie den Werkzeugkopf in die Nähe der Bettmitte und stellen Sie sicher, dass die Düse zwischen 3 und 10 Millimeter vom Bett entfernt ist.
1. Der nächste Schritt besteht darin, die Düse mit dem Bett in Kontakt zu bringen. Dieser Vorgang birgt stets gewisse Risiken. Seien Sie daher bereit, einen Nothalt (`M112`) auszulösen, falls die Sondierungsbewegung nach dem Kontakt mit dem Bett nicht stoppt. Wenn Sie bereit sind, geben Sie folgenden Befehl ein: `PROBE_EDDY_CURRENT_TAP_CALIBRATE TAP=guess`. Dieser Befehl analysiert die während der Hauptsonden-Kalibrierung erfassten Daten, um eine erste grobe Schätzung für den tap_threshold-Wert vorzunehmen, und führt anschließend die entsprechende "tap"-Sondierung durch. Im Idealfall lässt der obige Befehl die Sonde absinken, bis sie das Bett berührt, hebt sie wieder ab und meldet dann ein gültiges Sondierungsergebnis. Falls nicht, lesen Sie die Absätze am Ende dieses Abschnitts zur Fehlerbehebung. War der Versuch erfolgreich, fahren Sie mit dem nächsten Schritt fort.
1. Der nächste Schritt besteht darin, eine weitere Tap-Sondierung mit einer "verfeinerten" Schwellenwerteinstellung durchzuführen. Das Werkzeug nutzt dabei Informationen aus einer zuvor erfolgreichen Tap-Sondierung, um diesen verbesserten Schwellenwert zu bestimmen. Stellen Sie sicher, dass sich die Düse nahe der Bettmitte befindet und zwischen 3 und 10 mm über dem Bett liegt, seien Sie bereit für einen Nothalt, und führen Sie dann folgenden Befehl aus: `PROBE_EDDY_CURRENT_TAP_CALIBRATE TAP=refine`. Idealerweise gelingt auch dieser Befehl; falls nicht, lesen Sie die Absätze am Ende dieses Abschnitts zur Fehlerbehebung. War der Versuch erfolgreich, fahren Sie mit dem nächsten Schritt fort.
1. Ist die Sondierung mit dem verfeinerten Schwellenwert erfolgreich, besteht der nächste Test darin zu prüfen, ob sie über mehrere Sondierungsversuche hinweg stabil bleibt. Stellen Sie sicher, dass sich die Düse nahe der Bettmitte befindet und zwischen 3 und 10 mm über dem Bett liegt, seien Sie bereit für einen Nothalt, und führen Sie dann folgenden Befehl aus: `PROBE_EDDY_CURRENT_TAP_CALIBRATE TAP=verify`. Dieser Befehl sondiert das Bett fünfmal hintereinander. Idealerweise gelingt auch dieser Befehl; falls nicht, lesen Sie die Absätze am Ende dieses Abschnitts zur Fehlerbehebung. War der Versuch erfolgreich, fahren Sie mit dem nächsten Schritt fort.
1. Sind alle obigen Schritte erfolgreich, kann mit dem Befehl `SAVE_CONFIG` der Parameter "tap_threshold" in der Datei printer.cfg gespeichert werden. Die Kalibrierung sollte damit abgeschlossen sein.

War einer der obigen Schritte nicht erfolgreich, ist möglicherweise eine manuelle Fehlerbehebung und Bestimmung eines geeigneten `tap_threshold`-Werts erforderlich. Dies geschieht durch Befehle der Form: `PROBE METHOD=tap TAP_THRESHOLD=<Wert>`, wobei `<Wert>` ein zu testender Schwellenwert ist.

Generell gilt: Stoppt ein Sondierungsversuch, bevor das Bett berührt wird, deutet dies darauf hin, dass der angegebene `TAP_THRESHOLD`-Parameter zu niedrig ist. Erhöhen Sie ihn um etwa 10% und versuchen Sie es erneut. Stoppt ein Sondierungsversuch umgekehrt nach dem Kontakt mit dem Bett nicht, deutet dies darauf hin, dass `TAP_THRESHOLD` zu hoch ist. Erwägen Sie, den versuchten Wert zu halbieren.

Ist das automatische Kalibrierungswerkzeug bereits in der anfänglichen "guess"-Phase fehlgeschlagen, kann der vom Werkzeug gemeldete tap_threshold-Wert als Ausgangspunkt für manuelle Versuche verwendet werden. Sobald ein erfolgreicher Sondierungsversuch abgeschlossen ist, kann man zu den oben beschriebenen Hauptschritten zurückkehren und bei der "refine"-Phase fortfahren.

### Erste Kalibrierung beim Homing mit Sonde durchführen

Es ist möglich, eine Wirbelstromsonde zum Homen einer Z-Achse zu verwenden. Setzen Sie dazu im Konfigurationsabschnitt `[stepper_z]` die Option `endstop_pin` auf `probe:z_virtual_endstop`.

Um mit einer Eddy-Sonde zu homen, muss die Sonde zunächst über den Befehl `PROBE_EDDY_CURRENT_CALIBRATE` kalibriert werden. Dieser Befehl setzt jedoch voraus, dass der Drucker zuvor bereits gehomt wurde.

Mit den folgenden Schritten lässt sich diese zirkuläre Abhängigkeit bei der allerersten Kalibrierung umgehen:

1. Definieren Sie einen `[probe_eddy_current]`-Konfigurationsabschnitt in der Datei printer.cfg wie im [Konfigurationsabschnitt](#configuration) beschrieben.
1. Stellen Sie sicher, dass ein [Force-Move](Config_Reference.md#force_move)-Abschnitt definiert ist und dass dessen Option `enable_force_move` vorhanden und auf true gesetzt ist.
1. Verstellen Sie die Schlitten manuell so, dass sich der Werkzeugkopf nahe der Bettmitte und etwa 20 mm vom Bett entfernt befindet. Geben Sie die Befehle `LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` und `SAVE_CONFIG` wie im [Abschnitt zur Kalibrierung des Treiberstroms](#calibrating-drive-current) beschrieben ein.
1. Bewegen Sie den Werkzeugkopf manuell so, dass er etwa 20 mm vom Bett entfernt ist, und homen Sie die X- und Y-Achse des Druckers. Dies geschieht typischerweise mit dem Befehl `G28 X0 Y0`. Fahren Sie die X- und Y-Position des Werkzeugkopfs so, dass er sich etwa über der Bettmitte befindet. Dies geschieht typischerweise mit einem Befehl wie `G1 X50 Y50` (mit den für den jeweiligen Drucker passenden XY-Werten).
1. Justieren Sie das Bett bei Bedarf manuell so, dass es relativ zu den XY-Schlitten des Werkzeugkopfs weitgehend eben liegt. Justieren Sie den Z-Schlitten manuell so, dass die Düse etwa 20 mm vom Bett entfernt ist, und geben Sie den Befehl `SET_STEPPER_ENABLE STEPPER=stepper_z` ein. Geben Sie dann den Befehl `SET_KINEMATIC_POSITION Z=25` und anschließend `PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe` ein. Wichtig: Nach Eingabe dieser Befehle kann sich der Drucker in Z-Richtung bewegen, kennt jedoch die tatsächliche Z-Position nicht. Es muss darauf geachtet werden, Bewegungsbefehle zu vermeiden, die dazu führen könnten, dass der Werkzeugkopf in das Bett hinabfährt.
1. Schließen Sie die Eddy-Sonden-Kalibrierung wie im [Abschnitt zur Kalibrierung der Z-Höhen](#calibrating-z-heights) beschrieben ab. Geben Sie nach Abschluss den Befehl `SAVE_CONFIG` ein.

Diese Schritte werden nur benötigt, um eine erste Konfiguration zu erhalten. Muss `PROBE_EDDY_CURRENT_CALIBRATE` künftig erneut ausgeführt werden, sollte dies über den normalen Mechanismus möglich sein, sobald diese erste Konfiguration vorliegt.

## Kalibrierung der thermischen Drift

Wie alle induktiven Sonden unterliegen Wirbelstromsonden einer erheblichen thermischen Drift. Wenn die Wirbelstromsonde über einen Temperatursensor an der Spule verfügt, kann ein `[temperature_probe]` konfiguriert werden, um die Spulentemperatur zu melden und die softwareseitige Driftkompensation zu aktivieren. Um eine Temperatursonde mit einer Wirbelstromsonde zu verknüpfen, muss der Abschnitt `[temperature_probe]` denselben Namen wie der Abschnitt `[probe_eddy_current]` tragen. Zum Beispiel:

```
[probe_eddy_current my_probe]
# eddy probe configuration...

[temperature_probe my_probe]
# temperature probe configuration...
```

Weitere Einzelheiten zur Konfiguration eines `temperature_probe` finden Sie in der [Konfigurationsreferenz](Config_Reference.md#temperature_probe). Es empfiehlt sich, die Optionen `calibration_position`, `calibration_extruder_temp`, `extruder_heating_z` und `calibration_bed_temp` zu konfigurieren, da dadurch einige der unten beschriebenen Schritte automatisiert werden. Wenn der zu kalibrierende Drucker eingehaust ist, wird dringend empfohlen, die Option `max_validation_temp` auf einen Wert zwischen 100 und 120 zu setzen.

Hersteller von Wirbelstromsonden bieten unter Umständen eine werkseitige Driftkalibrierung an, die manuell in die Option `drift_calibration` des Abschnitts `[probe_eddy_current]` eingetragen werden kann. Ist dies nicht der Fall oder liefert die werkseitige Kalibrierung auf Ihrem System keine guten Ergebnisse, bietet das Modul `temperature_probe` über den G-Code-Befehl `TEMPERATURE_PROBE_CALIBRATE` ein manuelles Kalibrierverfahren an.

Vor der Durchführung der Kalibrierung sollte der Benutzer eine Vorstellung davon haben, welche maximale Spulentemperatur die Temperatursonde erreichen kann. Diese Temperatur sollte für den Parameter `TARGET` des Befehls `TEMPERATURE_PROBE_CALIBRATE` verwendet werden. Ziel ist es, über den größtmöglichen Temperaturbereich zu kalibrieren; daher ist es wünschenswert, mit kaltem Drucker zu beginnen und mit der Spule bei ihrer maximal erreichbaren Temperatur abzuschließen.

Sobald ein `[temperature_probe]` konfiguriert ist, können die folgenden Schritte zur Kalibrierung der thermischen Drift ausgeführt werden:

- Die Sonde muss mit `PROBE_EDDY_CURRENT_CALIBRATE` kalibriert werden, wenn ein `[temperature_probe]` konfiguriert und verknüpft ist. Dabei wird die Temperatur während der Kalibrierung erfasst, was für die Kompensation der thermischen Drift erforderlich ist.
- Stellen Sie sicher, dass die Düse frei von Rückständen und Filament ist.
- Bett, Düse und Sondenspule sollten vor der Kalibrierung kalt sein.
- Die folgenden Schritte sind erforderlich, wenn die Optionen `calibration_position`, `calibration_extruder_temp` und `extruder_heating_z` in `[temperature_probe]` **NICHT** konfiguriert sind:
   - Verfahren Sie das Werkzeug in die Mitte des Betts. Z sollte 30 mm oder mehr über dem Bett liegen.
   - Heizen Sie den Extruder auf eine Temperatur oberhalb der maximal sicheren Betttemperatur auf. 150–170 °C sollten für die meisten Konfigurationen ausreichen. Das Aufheizen des Extruders dient dazu, eine Ausdehnung der Düse während der Kalibrierung zu vermeiden.
   - Wenn sich die Extrudertemperatur stabilisiert hat, fahren Sie die Z-Achse auf etwa 1 mm über dem Bett herunter.
- Starten Sie die Driftkalibrierung. Wenn die Sonde `my_probe` heißt und die maximal erreichbare Sondentemperatur 80 °C beträgt, lautet der passende G-Code-Befehl `TEMPERATURE_PROBE_CALIBRATE PROBE=my_probe TARGET=80`. Sofern konfiguriert, fährt das Werkzeug zu den durch `calibration_position` angegebenen X/Y-Koordinaten und zu dem durch `extruder_heating_z` angegebenen Z-Wert. Nach dem Aufheizen des Extruders auf die angegebene Temperatur fährt das Werkzeug zu dem in `calibration_position` angegebenen Z-Wert.
- Das Verfahren fordert eine manuelle Messung an. Führen Sie die manuelle Messung mit dem Papiertest durch und bestätigen Sie mit `ACCEPT`. Die Kalibrierung nimmt die erste Messreihe mit der Sonde auf und parkt die Sonde anschließend in der Aufheizposition.
- Wenn `calibration_bed_temp` **NICHT** konfiguriert ist, heizen Sie das Bett auf die maximal sichere Temperatur auf. Andernfalls wird dieser Schritt automatisch ausgeführt.
- Standardmäßig fordert das Kalibrierverfahren alle 2 °C eine manuelle Messung an, bis `TARGET` erreicht ist. Die Temperaturdifferenz zwischen den Messungen lässt sich über den Parameter `STEP` in `TEMPERATURE_PROBE_CALIBRATE` anpassen. Beim Festlegen eines eigenen `STEP`-Werts ist Vorsicht geboten: Ein zu hoher Wert führt zu einer zu geringen Anzahl an Messungen und damit zu einer schlechten Kalibrierung.
- Während der Driftkalibrierung stehen die folgenden zusätzlichen G-Code-Befehle zur Verfügung:
   - Mit `TEMPERATURE_PROBE_NEXT` kann eine neue Messung erzwungen werden, bevor die Schrittdifferenz erreicht ist.
   - Mit `TEMPERATURE_PROBE_COMPLETE` kann die Kalibrierung abgeschlossen werden, bevor `TARGET` erreicht ist.
   - Mit `ABORT` kann die Kalibrierung beendet und die Ergebnisse verworfen werden.
- Wenn die Kalibrierung abgeschlossen ist, speichern Sie die Driftkalibrierung mit `SAVE_CONFIG`.

Wie man erkennen kann, ist das oben beschriebene Kalibrierverfahren anspruchsvoller und zeitaufwendiger als die meisten anderen Verfahren. Es kann Übung und mehrere Anläufe erfordern, um eine optimale Kalibrierung zu erreichen.

## Fehlerbeschreibung

Mögliche Homing-Fehler und Maßnahmen:

- Sensorfehler
   - Für detaillierte Fehlerinformationen die Logs prüfen
- Eddy-I2C-STATUS/DATA-Fehler.
   - Lose Verkabelung prüfen.
   - Software-I2C versuchen / I2C-Rate verringern
- Ungültige gelesene Daten
   - Wie bei I2C

Mögliche Sensorfehler und Maßnahmen:

- Frequenz außerhalb des gültigen Hard-Bereichs
   - Frequenzkonfiguration prüfen
   - Hardwarefehler
- Frequenz außerhalb des gültigen Soft-Bereichs
   - Frequenzkonfiguration prüfen
- Zeitüberschreitung des Konvertierungs-Watchdogs
   - Hardwarefehler

Warnmeldungen zu niedriger/hoher Amplitude können bedeuten:

- Sensor zu nah am Bett
- Sensor zu weit vom Bett entfernt
- Höhere Temperatur als bei der aktuellen Kalibrierung
- Kondensator fehlt

Bei manchen Sensoren lässt sich der Amplitudenwarnhinweis nicht vollständig vermeiden.

Sie können versuchen, die `LDC_CALIBRATE_DRIVE_CURRENT`-Kalibrierung bei Betriebstemperatur zu wiederholen oder `reg_drive_current` um 1-2 gegenüber dem kalibrierten Wert zu erhöhen.

Im Allgemeinen ist dies vergleichbar mit einer Motorkontrollleuchte. Es kann auf ein Problem hindeuten.
