# Sondenkalibrierung

Dieses Dokument beschreibt das Verfahren zur Kalibrierung der X-, Y- und Z-Versätze einer "automatischen Z-Sonde" in Klipper. Es ist für Benutzer nützlich, die einen Abschnitt `[probe]` oder `[bltouch]` in ihrer Konfigurationsdatei haben.

## Kalibrierung des X- und Y-Offsets zwischen Z Probe und Düse

Um den X- und Y-Versatz zu kalibrieren, wechseln Sie zur OctoPrint-Registerkarte "Steuerung", fahren Sie den Drucker in die Ausgangsposition und verwenden Sie dann die OctoPrint-Tasten, um den Druckkopf in eine Position nahe der Mitte des Druckbetts zu bewegen.

Kleben Sie ein Stück blaues Malerkrepp (oder Ähnliches) auf das Bett unterhalb der Sonde. Wechseln Sie zum OctoPrint-Reiter "Terminal" und setzen Sie einen PROBE-Befehl ab:

```
PROBE
```

Bringen Sie eine Markierung auf dem Klebeband direkt unterhalb der Sonde an (oder notieren Sie die Position auf dem Bett auf ähnliche Weise).

Setzen Sie einen `GET_POSITION`-Befehl ab und notieren Sie die von diesem Befehl gemeldete XY-Position des Druckkopfes. Wenn beispielsweise Folgendes angezeigt wird:

```
Recv: // toolhead: X:46.500000 Y:27.000000 Z:15.000000 E:0.000000
```

dann würde man eine X-Position der Sonde von 46.5 und eine Y-Position der Sonde von 27 notieren.

Nachdem Sie die Sondenposition notiert haben, setzen Sie eine Reihe von G1-Befehlen ab, bis sich die Düse direkt über der Markierung auf dem Bett befindet. Man könnte zum Beispiel Folgendes absetzen:

```
G1 F300 X57 Y30 Z15
```

um die Düse auf eine X-Position von 57 und eine Y-Position von 30 zu bewegen. Sobald Sie die Position direkt über der Markierung gefunden haben, verwenden Sie den `GET_POSITION`-Befehl, um diese Position auszugeben. Das ist die Düsenposition.

Der x_offset ist dann `nozzle_x_position - probe_x_position` und der y_offset entsprechend `nozzle_y_position - probe_y_position`. Aktualisieren Sie die Datei printer.cfg mit den ermittelten Werten, entfernen Sie das Klebeband bzw. die Markierungen vom Bett und setzen Sie anschließend einen `RESTART`-Befehl ab, damit die neuen Werte wirksam werden.

## Kalibrierung des Z-Offsets der Probe

Ein genauer z_offset der Sonde ist entscheidend für hochwertige Druckergebnisse. Der z_offset ist der Abstand zwischen Düse und Bett zum Zeitpunkt des Auslösens der Sonde. Mit dem Klipper-Werkzeug `PROBE_CALIBRATE` lässt sich dieser Wert ermitteln - es führt eine automatische Messung durch, um die Z-Auslöseposition der Sonde zu bestimmen, und startet anschließend eine manuelle Messung, um die Z-Höhe der Düse zu ermitteln. Der z_offset der Sonde wird dann aus diesen Messungen berechnet.

Beginnen Sie mit dem Homing des Druckers und bewegen Sie den Kopf anschließend in eine Position nahe der Bettmitte. Wechseln Sie zum OctoPrint-Terminal-Reiter und führen Sie den Befehl `PROBE_CALIBRATE` aus, um das Werkzeug zu starten.

Dieses Werkzeug führt eine automatische Messung durch, hebt anschließend den Kopf an, bewegt die Düse über die Position des Messpunktes und startet das manuelle Messwerkzeug. Falls sich die Düse nicht in eine Position über dem automatischen Messpunkt bewegt, brechen Sie das manuelle Messwerkzeug mit `ABORT` ab und führen Sie die oben beschriebene Kalibrierung des XY-Sondenversatzes durch.

Sobald das manuelle Messwerkzeug gestartet ist, folgen Sie den Schritten unter ["Der Papiertest"](Bed_Level.md#the-paper-test), um den tatsächlichen Abstand zwischen Düse und Bett an der jeweiligen Position zu bestimmen. Nach Abschluss dieser Schritte können Sie die Position mit `ACCEPT` übernehmen und die Ergebnisse mit folgendem Befehl in der Konfigurationsdatei speichern:

```
SAVE_CONFIG
```

Beachten Sie, dass eine Änderung am Bewegungssystem des Druckers, an der Hotend-Position oder an der Position der Sonde die Ergebnisse von PROBE_CALIBRATE ungültig macht.

Wenn die Sonde einen X- oder Y-Versatz besitzt und die Bettneigung verändert wird (z. B. durch Verstellen der Bettschrauben, durch Ausführen von DELTA_CALIBRATE, Z_TILT_ADJUST, QUAD_GANTRY_LEVEL oder Ähnlichem), werden die Ergebnisse von PROBE_CALIBRATE ungültig. Nach einer dieser Anpassungen ist es notwendig, PROBE_CALIBRATE erneut auszuführen.

Wenn die Ergebnisse von PROBE_CALIBRATE ungültig werden, dann werden auch alle zuvor mit der Sonde ermittelten [Bed-Mesh](Bed_Mesh.md)-Ergebnisse ungültig - nach der Neukalibrierung der Sonde muss BED_MESH_CALIBRATE erneut ausgeführt werden.

## Überprüfung der Wiederholbarkeit

Nach der Kalibrierung der X-, Y- und Z-Versätze der Sonde ist es sinnvoll, zu überprüfen, ob die Sonde reproduzierbare Ergebnisse liefert. Beginnen Sie mit dem Homing des Druckers und bewegen Sie den Kopf anschließend in eine Position nahe der Bettmitte. Wechseln Sie zum OctoPrint-Terminal-Reiter und führen Sie den Befehl `PROBE_ACCURACY` aus.

Dieser Befehl führt die Messung zehnmal durch und erzeugt eine Ausgabe ähnlich der folgenden:

```
Recv: // probe accuracy: at X:0.000 Y:0.000 Z:10.000
Recv: // and read 10 times with speed of 5 mm/s
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe accuracy results: maximum 2.519448, minimum 2.506948, range 0.012500, average 2.513198, median 2.513198, standard deviation 0.006250
```

Idealerweise meldet das Werkzeug einen identischen Maximal- und Minimalwert. (Das heißt, im Idealfall erzielt die Sonde bei allen zehn Messungen ein identisches Ergebnis.) Es ist jedoch normal, dass Minimal- und Maximalwert um eine Z-"Schrittdistanz" oder bis zu 5 Mikrometer (.005 mm) voneinander abweichen. Eine "Schrittdistanz" ist `rotation_distance/(full_steps_per_rotation*microsteps)`. Der Abstand zwischen Minimal- und Maximalwert wird als Spanne (range) bezeichnet. Da der Drucker im obigen Beispiel eine Z-Schrittdistanz von .0125 verwendet, wäre eine Spanne von 0.012500 als normal anzusehen.

Wenn die Testergebnisse eine Spanne von mehr als 25 Mikrometern (.025 mm) zeigen, besitzt die Sonde nicht die für übliche Bettleveling-Verfahren erforderliche Genauigkeit. Unter Umständen lässt sich die Reproduzierbarkeit der Sonde durch Anpassen der Messgeschwindigkeit und/oder der Starthöhe der Messung verbessern. Mit dem Befehl `PROBE_ACCURACY` können Tests mit unterschiedlichen Parametern durchgeführt werden, um deren Auswirkung zu beurteilen - weitere Einzelheiten finden Sie im [Dokument G-Codes](G-Codes.md#probe_accuracy). Wenn die Sonde grundsätzlich reproduzierbare Ergebnisse liefert, aber gelegentlich Ausreißer auftreten, lässt sich dies möglicherweise durch mehrere Messproben je Messpunkt ausgleichen - lesen Sie dazu die Beschreibung der Konfigurationsparameter `samples` der Sonde in der [Konfigurationsreferenz](Config_Reference.md#probe).

Falls eine neue Messgeschwindigkeit, eine andere Anzahl von Messproben oder andere Einstellungen erforderlich sind, aktualisieren Sie die Datei printer.cfg und setzen Sie einen `RESTART`-Befehl ab. In diesem Fall ist es sinnvoll, den [z_offset erneut zu kalibrieren](#calibrating-probe-z-offset). Wenn sich keine reproduzierbaren Ergebnisse erzielen lassen, verwenden Sie die Sonde nicht für das Bettleveling. Klipper bietet stattdessen mehrere Werkzeuge zum manuellen Abtasten - weitere Einzelheiten finden Sie im [Dokument Bed Level](Bed_Level.md).

## Prüfung auf positionsabhängige Abweichung

Manche Sonden weisen eine systematische Abweichung auf, die die Messergebnisse an bestimmten Druckkopfpositionen verfälscht. Wenn sich zum Beispiel die Sondenhalterung bei einer Bewegung entlang der Y-Achse leicht neigt, kann dies dazu führen, dass die Sonde an unterschiedlichen Y-Positionen verfälschte Ergebnisse meldet.

Dies ist ein häufiges Problem bei Sonden an Delta-Druckern, es kann jedoch bei allen Druckern auftreten.

Eine positionsabhängige Abweichung lässt sich prüfen, indem man mit dem Befehl `PROBE_CALIBRATE` den z_offset der Sonde an verschiedenen X- und Y-Positionen misst. Idealerweise wäre der z_offset der Sonde an jeder Position des Druckers ein konstanter Wert.

Messen Sie bei Delta-Druckern den z_offset an einer Position nahe dem Turm A, an einer Position nahe dem Turm B und an einer Position nahe dem Turm C. Bei kartesischen, CoreXY- und ähnlichen Druckern messen Sie den z_offset an Positionen nahe den vier Ecken des Betts.

Kalibrieren Sie vor Beginn dieses Tests zunächst die X-, Y- und Z-Versätze der Sonde wie am Anfang dieses Dokuments beschrieben. Führen Sie anschließend das Homing des Druckers durch und fahren Sie die erste XY-Position an. Folgen Sie den Schritten unter [Kalibrieren des Z-Versatzes der Sonde](#calibrating-probe-z-offset), um die Befehle `PROBE_CALIBRATE`, `TESTZ` und `ACCEPT` auszuführen, führen Sie jedoch kein `SAVE_CONFIG` aus. Notieren Sie den gemeldeten z_offset. Fahren Sie dann die übrigen XY-Positionen an, wiederholen Sie diese `PROBE_CALIBRATE`-Schritte und notieren Sie den jeweils gemeldeten z_offset.

Wenn die Differenz zwischen dem kleinsten und dem größten gemeldeten z_offset mehr als 25 Mikrometer (.025 mm) beträgt, ist die Sonde für übliche Bettleveling-Verfahren nicht geeignet. Alternativen zum manuellen Abtasten finden Sie im [Dokument Bed Level](Bed_Level.md).

## Temperaturverzerrung

Viele Sonden weisen bei Messungen bei unterschiedlichen Temperaturen eine systematische Abweichung auf. So kann die Sonde beispielsweise bei höherer Temperatur durchgängig bei einer geringeren Höhe auslösen.

Es wird empfohlen, die Bettleveling-Werkzeuge bei einer gleichbleibenden Temperatur auszuführen, um diese Abweichung zu berücksichtigen. Führen Sie die Werkzeuge also zum Beispiel entweder immer bei Raumtemperatur aus oder immer, nachdem der Drucker eine gleichbleibende Drucktemperatur erreicht hat. In beiden Fällen ist es sinnvoll, nach Erreichen der gewünschten Temperatur mehrere Minuten zu warten, damit sich die Druckermechanik gleichmäßig auf die gewünschte Temperatur einstellt.

Um auf eine temperaturabhängige Abweichung zu prüfen, beginnen Sie mit dem Drucker bei Raumtemperatur, führen Sie das Homing durch, bewegen Sie den Kopf in eine Position nahe der Bettmitte und führen Sie den Befehl `PROBE_ACCURACY` aus. Notieren Sie die Ergebnisse. Heizen Sie anschließend - ohne erneutes Homing und ohne die Schrittmotoren zu deaktivieren - Düse und Bett des Druckers auf Drucktemperatur auf und führen Sie den Befehl `PROBE_ACCURACY` erneut aus. Idealerweise meldet der Befehl identische Ergebnisse. Achten Sie wie oben beschrieben darauf, die Sonde stets bei gleichbleibender Temperatur zu verwenden, falls sie eine temperaturabhängige Abweichung aufweist.
