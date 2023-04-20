# Bed leveling

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

In order to perform the paper test, cut a small rectangular piece of paper using a pair of scissors (eg, 5x3 cm). The paper generally has a thickness of around 100 microns (0.100mm). (The exact thickness of the paper isn't crucial.)

Der erste Schritt des Papiertests besteht in der Kontrolle der Düse und des Druckbetts des Druckers. Stellen sie sicher dass keine Plastikreste oder andere Verschmutzungen an der Düse oder auf dem Bett vorhanden sind.

**Kontrollieren sie die Düse und das Druckbett um sicherzustellen dass keine Plastikreste vorhanden sind!**

If one always prints on a particular tape or printing surface then one may perform the paper test with that tape/surface in place. However, note that tape itself has a thickness and different tapes (or any other printing surface) will impact Z measurements. Be sure to rerun the paper test to measure each type of surface that is in use.

Falls Plastikreste an der Düse vorhanden sind, heizen sie die Düse auf und verwenden sie eine Metallpinzette um Reste zu entfernen. Warten sie bis die Düse wieder vollständig auf Zimmertemperatur abgekühlt ist bevor sie mit dem Papiertest fortfahren. Während die Düse abkühlt, verwenden sie die Metallpinzette um weitere Plastikreste, die evtl. auslaufen, zu entfernen.

**Führen sie den Papiertest nur durch wenn sich Druckdüse und Druckbett auf Zimmertemperatur befinden!**

When the nozzle is heated, its position (relative to the bed) changes due to thermal expansion. This thermal expansion is typically around a 100 microns, which is about the same thickness as a typical piece of printer paper. The exact amount of thermal expansion isn't crucial, just as the exact thickness of the paper isn't crucial. Start with the assumption that the two are equal (see below for a method of determining the difference between the two distances).

Es mag komisch vorkommen den Abstand bei Zimmertemperatur zu kalibrieren, obwohl das Ziel ein reproduzierbarer Abstand im aufgeheizten Zustand ist. Wird die Kalbrierung jedoch im aufgeheizten Zustand durchgeführt, können kleine Mengen an geschmolzenem Plastik auf dem Papier zurückbleiben, was die gefühlte Menge Reibung beeinflussen kann. Eine Kalbrierung mit aufgeheizter Düse und Druckbett erhöht außerdem das Risiko für Brandverletzungen. Die Wärmeausdehnung ist konstant, daher ist es sehr einfach sie später im Kalibrierungsprozess zu berücksichtigen.

**Benutzen sie ein automatisiertes Werkzeug um die genaue Z Höhe festzustellen!**

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

Then a `TESTZ Z=-` would move the nozzle to a Z position of 0.180 (half way between 0.130 and 0.230). One can use this feature to help rapidly narrow down to a consistent friction. It is also possible to use `Z=++` and `Z=--` to return directly to a past measurement - for example, after the above prompt a `TESTZ Z=--` command would move the nozzle to a Z position of 0.130.

After finding a small amount of friction run the ACCEPT command:

```
ACCEPT
```

This will accept the given Z height and proceed with the given calibration tool.

The exact amount of friction felt isn't crucial, just as the amount of thermal expansion and exact width of the paper isn't crucial. Just try to obtain the same amount of friction each time one runs the test.

If something goes wrong during the test, one can use the `ABORT` command to exit the calibration tool.

## Determining Thermal Expansion

After successfully performing bed leveling, one may go on to calculate a more precise value for the combined impact of "thermal expansion", "thickness of the paper", and "amount of friction felt during the paper test".

This type of calculation is generally not needed as most users find the simple "paper test" provides good results.

The easiest way to make this calculation is to print a test object that has straight walls on all sides. The large hollow square found in [docs/prints/square.stl](prints/square.stl) can be used for this. When slicing the object, make sure the slicer uses the same layer height and extrusion widths for the first level that it does for all subsequent layers. Use a coarse layer height (the layer height should be around 75% of the nozzle diameter) and do not use a brim or raft.

Print the test object, wait for it to cool, and remove it from the bed. Inspect the lowest layer of the object. (It may also be useful to run a finger or nail along the bottom edge.) If one finds the bottom layer bulges out slightly along all sides of the object then it indicates the nozzle was slightly closer to the bed then it should be. One can issue a `SET_GCODE_OFFSET Z=+.010` command to increase the height. In subsequent prints one can inspect for this behavior and make further adjustment as needed. Adjustments of this type are typically in 10s of microns (.010mm).

If the bottom layer consistently appears narrower than subsequent layers then one can use the SET_GCODE_OFFSET command to make a negative Z adjustment. If one is unsure, then one can decrease the Z adjustment until the bottom layer of prints exhibit a small bulge, and then back-off until it disappears.

The easiest way to apply the desired Z adjustment is to create a START_PRINT g-code macro, arrange for the slicer to call that macro during the start of each print, and add a SET_GCODE_OFFSET command to that macro. See the [slicers](Slicers.md) document for further details.
