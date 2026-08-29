# Bett Nivellierung

Die Bettnivellierung (auch als "Bettbewegung" bezeichnet) ist entscheidend, um qualitativ hochwertige Drucke zu erhalten. Wenn ein Bett nicht richtig "nivelliert" ist, kann dies zu schlechter Betthaftung, "Verziehen" und subtilen Problemen während des gesamten Drucks führen. Dieses Dokument dient als Leitfaden für die Durchführung der Bettnivellierung in Klipper.

Es ist wichtig, das Ziel der Bettnivellierung zu verstehen. Wenn der Drucker während eines Druckvorgangs in eine Position `X0 Y0 Z10` befohlen wird, dann ist es das Ziel, dass die Düse des Druckers genau 10 mm vom Druckerbett entfernt ist. Sollte der Drucker dann auf eine Position von `X50 Z10` angewiesen werden, besteht das Ziel darin, dass die Düse während der gesamten horizontalen Bewegung einen genauen Abstand von 10 mm vom Bett einhält.

Um qualitativ hochwertige Drucke zu erhalten, sollte der Drucker so kalibriert werden, dass die Z-Abstände auf etwa 25 Mikrometer (0,025 mm) genau sind. Dies ist ein kleiner Abstand - deutlich kleiner als die Breite eines typischen menschlichen Haares. Diese Größenordnung kann nicht "mit dem Auge" gemessen werden. Feine Effekte (wie Wärmeausdehnung) wirken sich auf Messungen dieser Größenordnung aus. Das Geheimnis einer hohen Genauigkeit besteht darin, einen wiederholbaren Prozess zu verwenden und eine Nivellierungsmethode zu verwenden, welche die hohe Genauigkeit des eigenen Bewegungssystems des Druckers nutzt.

## Wählen Sie den geeigneten Kalibrierungsvorgang

Unterschiedliche Druckertypen verwenden unterschiedliche Methoden zum Durchführen einer Bettnivellierung. Alle hängen letztendlich vom "Papiertest" ab (unten beschrieben). Der eigentliche Vorgang für einen bestimmten Druckertyp ist jedoch in den anderen Dokumenten beschrieben.

Bevor Sie eines dieser Kalibrierungstools ausführen, führen Sie unbedingt die im [config check document](Config_checks.md) beschriebenen Prüfungen durch. Es ist notwendig, die grundlegende Druckerbewegung zu überprüfen, bevor Sie die Bettnivellierung durchführen.

Bei Druckern mit einer "automatischen Z-Sonde" müssen Sie die Sonde gemäß den Anweisungen im Dokument [Probe Calibrate](Probe_Calibrate.md) kalibrieren. Informationen zu Deltadruckern finden Sie im Dokument [Delta Calibrate](Delta_Calibrate.md). Informationen zu Druckern mit Bettschrauben und herkömmlichen Z-Endschaltern finden Sie im Dokument [Manual Level](Manual_Level.md).

Während der Kalibrierung kann es notwendig sein dem `position_min` Parameter der Z-Achse einen negativen Wert zuzuweisen (z.B. `position_min = -2`). Auch während eines Kalibrierungsvorgangs schränkt der Drucker die Bewegungsfreiheit gemäß der konfigurierten Grenzen ein. Ein negativer Wert erlaubt es dem Drucker sich unter die nominale Höhe des Druckbettes zu bewegen, was bei der Ermittlung der tatsächlichen Position des Druckbettes hilfreich sein kann.

## Der "Papiertest"

Der "Papiertest" ist der primäre Test zur Kalibrierung der Höhe des Druckbettes. Ein gewöhnliches "Kopierpapier" wird zwischen dem Druckbett und der Düse platziert und die Düse so lange entlang der Z-Achse bewegt bis beim Hin- und Herbewegen des Papiers Reibung zwischen dem Papier und der Düse festgestellt werden kann.

Die Kenntis des "Papiertests" ist wichtig, selbst wenn der Drucker einen "automatischen Z Sonde" besitzt. Der Z Sonde selbst muss kalibriert werden um gute Ergebnisse zu erhalten. Diese Kalbirierung wird mithilfe des "Papiertests" durchgeführt.

Um den Papiertest durchzuführen, schneiden Sie mit einer Schere ein kleines rechteckiges Stück Papier zu (z. B. 5x3 cm). Das Papier hat üblicherweise eine Dicke von etwa 100 Mikrometern (0,100 mm). (Die genaue Dicke des Papiers ist nicht entscheidend.)

Der erste Schritt des Papiertests besteht in der Kontrolle der Düse und des Druckbetts des Druckers. Stellen sie sicher, dass keine Plastikreste oder andere Verschmutzungen an der Düse oder auf dem Bett vorhanden sind.

**Kontrollieren sie die Düse und das Druckbett um sicherzustellen, dass keine Plastikreste vorhanden sind!**

Drucken Sie stets auf einem bestimmten Klebeband oder einer bestimmten Druckoberfläche, können Sie den Papiertest mit diesem Klebeband/dieser Oberfläche durchführen. Beachten Sie jedoch, dass das Klebeband selbst eine Dicke besitzt und unterschiedliche Klebebänder (oder andere Druckoberflächen) die Z-Messungen beeinflussen. Führen Sie den Papiertest für jede verwendete Oberflächenart erneut durch.

Falls Plastikreste an der Düse vorhanden sind, heizen sie die Düse auf und verwenden sie eine Metallpinzette, um Reste zu entfernen. Warten Sie, bis die Düse wieder vollständig auf Zimmertemperatur abgekühlt ist, bevor sie mit dem Papiertest fortfahren. Während die Düse abkühlt, verwenden sie die Metallpinzette um weitere Plastikreste, die evtl. auslaufen, zu entfernen.

**Führen sie den Papiertest nur durch wenn sich Druckdüse und Druckbett auf Zimmertemperatur befinden!**

Wenn die Düse aufgeheizt wird, ändert sich ihre Position (relativ zum Bett) aufgrund thermischer Ausdehnung. Diese thermische Ausdehnung beträgt typischerweise etwa 100 Mikrometer, was ungefähr der Dicke eines typischen Blatts Druckerpapier entspricht. Das genaue Ausmaß der thermischen Ausdehnung ist nicht entscheidend, ebenso wenig wie die exakte Dicke des Papiers. Gehen Sie zunächst von der Annahme aus, dass beide gleich groß sind (siehe unten für eine Methode, um den Unterschied zwischen beiden Werten zu bestimmen).

Es mag komisch vorkommen, den Abstand bei Zimmertemperatur zu kalibrieren, obwohl das Ziel ein reproduzierbarer Abstand im aufgeheizten Zustand ist. Wird die Kalbrierung jedoch im aufgeheizten Zustand durchgeführt, können kleine Mengen an geschmolzenem Plastik auf dem Papier zurückbleiben, was die gefühlte Menge Reibung beeinflussen kann. Eine Kalbrierung mit aufgeheizter Düse und Druckbett erhöht außerdem das Risiko für Brandverletzungen. Die Wärmeausdehnung ist konstant, daher ist es sehr einfach sie später im Kalibrierungsprozess zu berücksichtigen.

**Benutzen sie ein automatisiertes Werkzeug, um die genaue Z-Höhe festzustellen!**

Klipper stellt einige Hilfe-Skripte zur Verfügung (z.b. MANUAL_PROBE, Z_ENDSTOP_CALIBRATE, PROBE_CALIBRATE, DELTA_CALIBRATE). Prüfen sie die [obige](#choose-the-appropriate-calibration-mechanism) Dokumentation um das passende Skript auszuwählen.

Führen sie das passende Kommando im Octoprint Terminal Fenster aus. Das Skript bittet dann um Benutzereingaben im OctoPrint Terminal. Die Ausgabe wird ähnlich dem Folgenden aussehen:

```
Recv: // Starting manual Z probe. Use TESTZ to adjust position.
Recv: // Finish with ACCEPT or ABORT command.
Recv: // Z position: ?????? --> 5.000 <-- ??????
```

Die aktuelle Höhe der Düse (so wie sie der Drucker derzeit versteht) wird zwischen den Zeichen "--> <--" angezeigt. Die Zahl rechts ist die Höhe des letzten Antastversuchs, der gerade größer als die aktuelle Höhe war, und links ist der letzte Antastversuch, der kleiner als die aktuelle Höhe war (oder ??????, wenn kein Versuch gemacht wurde).

Legen Sie das Papier zwischen Düse und Bett. Es kann hilfreich sein, eine Ecke des Papiers zu falten, damit es leichter zu greifen ist. (Versuchen Sie, beim Hin- und Herbewegen des Papiers nicht auf das Bett zu drücken.)

![paper-test](img/paper-test.jpg)

Verwenden Sie den Befehl TESTZ, um die Düse aufzufordern, sich dem Papier zu nähern. Zum Beispiel:

```
TESTZ Z=-.1
```

Der Befehl TESTZ verschiebt die Düse um eine relative Entfernung von der aktuellen Position der Düse. (Mit `Z=-.1` wird die Düse also aufgefordert, sich um 0,1 mm näher an das Bett heranzubewegen.) Nachdem die Düse die Bewegung gestoppt hat, schieben Sie das Papier hin und her, um zu prüfen, ob die Düse mit dem Papier in Kontakt ist und um die Reibung zu spüren. Führen Sie die TESTZ-Befehle so lange aus, bis Sie beim Testen mit dem Papier eine geringe Reibung spüren.

Wenn zu viel Reibung festgestellt wird, kann man einen positiven Z-Wert verwenden, um die Düse nach oben zu bewegen. Es ist auch möglich, `TESTZ Z=+` oder `TESTZ Z=-` zu verwenden, um die letzte Position zu "halbieren" - d.h. eine Position auf halbem Weg zwischen zwei Positionen anzufahren. Zum Beispiel, wenn man die folgende Aufforderung von einem TESTZ-Befehl erhält:

```
Recv: // Z position: 0.130 --> 0.230 <-- 0.280
```

Ein `TESTZ Z=-` würde die Düse dann auf eine Z-Position von 0,180 bewegen (auf halbem Weg zwischen 0,130 und 0,230). Mit dieser Funktion lässt sich schnell eine gleichbleibende Reibung eingrenzen. Es ist außerdem möglich, mit `Z=++` und `Z=--` direkt zu einer früheren Messung zurückzukehren - nach der obigen Aufforderung würde beispielsweise ein Befehl `TESTZ Z=--` die Düse auf eine Z-Position von 0,130 bewegen.

Sobald Sie eine geringe Reibung feststellen, führen Sie den Befehl ACCEPT aus:

```
ACCEPT
```

Dadurch wird die angegebene Z-Höhe übernommen, und das jeweilige Kalibrierwerkzeug wird fortgesetzt.

Die genaue Menge an spürbarer Reibung ist nicht entscheidend, ebenso wenig wie das genaue Ausmaß der thermischen Ausdehnung oder die exakte Dicke des Papiers. Versuchen Sie lediglich, bei jeder Durchführung des Tests dieselbe Reibung zu erzielen.

Geht während des Tests etwas schief, kann der Befehl `ABORT` verwendet werden, um das Kalibrierwerkzeug zu beenden.

## Ermittlung der thermischen Ausdehnung

Nach erfolgreicher Bettnivellierung kann anschließend ein genauerer Wert für den kombinierten Einfluss von "thermischer Ausdehnung", "Papierdicke" und "während des Papiertests spürbarer Reibung" berechnet werden.

Diese Art der Berechnung ist im Allgemeinen nicht notwendig, da die meisten Anwender mit dem einfachen "Papiertest" gute Ergebnisse erzielen.

Am einfachsten lässt sich diese Berechnung durchführen, indem ein Testobjekt mit geraden Wänden auf allen Seiten gedruckt wird. Dafür kann das große hohle Quadrat unter [docs/prints/square.stl](prints/square.stl) verwendet werden. Stellen Sie beim Slicen sicher, dass der Slicer für die erste Ebene dieselbe Schichthöhe und Extrusionsbreite verwendet wie für alle folgenden Schichten. Verwenden Sie eine grobe Schichthöhe (die Schichthöhe sollte etwa 75% des Düsendurchmessers betragen) und verwenden Sie keinen Rand (Brim) oder Floß (Raft).

Drucken Sie das Testobjekt, lassen Sie es abkühlen und entfernen Sie es vom Bett. Untersuchen Sie die unterste Schicht des Objekts. (Es kann außerdem hilfreich sein, mit einem Finger oder Fingernagel an der unteren Kante entlangzufahren.) Wölbt sich die unterste Schicht an allen Seiten des Objekts leicht nach außen, deutet dies darauf hin, dass die Düse etwas zu nah am Bett war. Sie können den Befehl `SET_GCODE_OFFSET Z=+.010` ausgeben, um die Höhe zu erhöhen. Bei nachfolgenden Drucken können Sie dieses Verhalten weiter beobachten und bei Bedarf nachjustieren. Anpassungen dieser Art liegen typischerweise im Bereich von einigen 10 Mikrometern (0,010 mm).

Erscheint die unterste Schicht durchgehend schmaler als die folgenden Schichten, kann mit dem Befehl SET_GCODE_OFFSET eine negative Z-Anpassung vorgenommen werden. Im Zweifelsfall können Sie die Z-Anpassung verringern, bis die unterste Schicht der Drucke eine leichte Wölbung zeigt, und dann wieder zurücknehmen, bis diese verschwindet.

Am einfachsten lässt sich die gewünschte Z-Anpassung anwenden, indem ein START_PRINT-G-Code-Makro erstellt wird, der Slicer so eingerichtet wird, dass er dieses Makro zu Beginn jedes Drucks aufruft, und diesem Makro ein SET_GCODE_OFFSET-Befehl hinzugefügt wird. Weitere Details finden Sie im Dokument [Slicer](Slicers.md).
