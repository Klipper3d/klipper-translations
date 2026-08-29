# Druckvorschub

Dieses Dokument enthält Informationen zur Einstellung der Konfigurationsvariablen "Druckvorschub" für eine bestimmte Düse und ein bestimmtes Filament. Die Druckvoreilung kann bei der Reduzierung von Schlamm hilfreich sein. Weitere Informationen darüber, wie der Druckvorschub implementiert ist, finden Sie im Dokument [kinematics](Kinematics.md).

## Einstellung des "Pressure Advance" Feature's

Druckvorschub (Pressure Advance) hat zwei nützliche Funktionen - es reduziert das Auslaufen (Ooze) während der Bewegungen ohne Extrusion und verringert das Blobbing (Verklumpen) in Kurven. Diese Anleitung verwendet die zweite Funktion (Verringerung von Blobbing in Kurven) als Mechanismus zum Einstellen.

Um Pressure Advance zu kalibrieren, muss der Drucker konfiguriert und betriebsbereit sein, da der Kalibriertest das Drucken und Untersuchen eines Testobjekts beinhaltet. Es empfiehlt sich, dieses Dokument vor Durchführung des Tests vollständig zu lesen.

Verwenden Sie einen Slicer, um G-Code für das große hohle Quadrat unter [docs/prints/square_tower.stl](prints/square_tower.stl) zu erzeugen. Verwenden Sie eine hohe Geschwindigkeit (z. B. 100 mm/s), keine Füllung und eine grobe Schichthöhe (die Schichthöhe sollte etwa 75% des Düsendurchmessers betragen). Stellen Sie sicher, dass "dynamische Beschleunigungssteuerung" und "Scarf-Joint"-Nähte im Slicer deaktiviert sind.

Bereiten Sie den Test vor, indem Sie folgenden G-Code-Befehl ausgeben:

```
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
```

Dieser Befehl lässt die Düse an Ecken langsamer fahren, um die Effekte des Extruderdrucks zu betonen. Führen Sie anschließend bei Druckern mit Direktantrieb-Extruder folgenden Befehl aus:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

Für lange Bowden-Extruder verwenden Sie:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020
```

Drucken Sie anschließend das Objekt. Vollständig gedruckt sieht der Testdruck etwa so aus:

![tuning_tower](img/tuning_tower.jpg)

Der obige TUNING_TOWER-Befehl weist Klipper an, die pressure_advance-Einstellung bei jeder Schicht des Drucks zu ändern. Höhere Schichten im Druck erhalten einen größeren pressure_advance-Wert. Schichten unterhalb der idealen pressure_advance-Einstellung weisen Wulste an den Ecken auf, während Schichten oberhalb der idealen Einstellung zu abgerundeten Ecken und schlechter Extrusion im Bereich vor der Ecke führen können.

Der Druck kann vorzeitig abgebrochen werden, wenn zu beobachten ist, dass die Ecken nicht mehr gut gedruckt werden (so lassen sich Schichten vermeiden, die bekanntermaßen über dem idealen pressure_advance-Wert liegen).

Untersuchen Sie den Druck und ermitteln Sie mit einer digitalen Schieblehre die Höhe mit den qualitativ besten Ecken. Bevorzugen Sie im Zweifelsfall eine niedrigere Höhe.

![tune_pa](img/tune_pa.jpg)

Der pressure_advance-Wert kann dann als `pressure_advance = <start> + <measured_height> * <factor>` berechnet werden. (Zum Beispiel würde `0 + 12.90 * .020` gleich `.258` ergeben.)

Es ist möglich, benutzerdefinierte Werte für START und FACTOR zu wählen, falls dies dabei hilft, die beste Pressure-Advance-Einstellung zu ermitteln. Achten Sie in diesem Fall darauf, den TUNING_TOWER-Befehl zu Beginn jedes Testdrucks auszugeben.

Typische Pressure-Advance-Werte liegen zwischen 0,050 und 1,000 (der obere Bereich üblicherweise nur bei Bowden-Extrudern). Zeigt sich bei einem Pressure-Advance-Wert bis 1,000 keine wesentliche Verbesserung, wird Pressure Advance die Druckqualität wahrscheinlich nicht verbessern. Kehren Sie in diesem Fall zu einer Standardkonfiguration mit deaktiviertem Pressure Advance zurück.

Auch wenn diese Kalibrierübung direkt die Qualität der Ecken verbessert, lohnt es sich zu bedenken, dass eine gute Pressure-Advance-Konfiguration zudem das Fadenziehen (Oozing) über den gesamten Druck hinweg reduziert.

Setzen Sie nach Abschluss dieses Tests `pressure_advance = <calculated_value>` im Abschnitt `[extruder]` der Konfigurationsdatei und geben Sie einen RESTART-Befehl aus. Der RESTART-Befehl löscht den Teststatus und setzt Beschleunigung und Kurvengeschwindigkeiten auf ihre normalen Werte zurück.

## Wichtige Hinweise

* Der Pressure-Advance-Wert hängt vom Extruder, der Düse und dem Filament ab. Es kommt häufig vor, dass Filamente unterschiedlicher Hersteller oder mit unterschiedlicher Pigmentierung deutlich unterschiedliche Pressure-Advance-Werte benötigen. Daher sollte Pressure Advance für jeden Drucker und für jede Filamentspule kalibriert werden.
* Drucktemperatur und Extrusionsrate können Pressure Advance beeinflussen. Kalibrieren Sie unbedingt zunächst die [Extruder-rotation_distance](Rotation_Distance.md#calibrating-rotation_distance-on-extruders) und die [Düsentemperatur](http://reprap.org/wiki/Triffid_Hunter%27s_Calibration_Guide#Nozzle_Temperature), bevor Sie Pressure Advance kalibrieren.
* Der Testdruck ist für eine hohe Extruder-Flussrate ausgelegt, ansonsten jedoch mit "normalen" Slicer-Einstellungen. Eine hohe Flussrate wird durch eine hohe Druckgeschwindigkeit (z. B. 100 mm/s) und eine grobe Schichthöhe erreicht (typischerweise etwa 75% des Düsendurchmessers). Andere Slicer-Einstellungen sollten in etwa ihren Standardwerten entsprechen (z. B. 2 oder 3 Umfangslinien, normale Retraction-Menge). Es kann sinnvoll sein, die Geschwindigkeit des äußeren Umfangs auf dieselbe Geschwindigkeit wie den restlichen Druck zu setzen, dies ist jedoch keine Voraussetzung.
* Es kommt häufig vor, dass der Testdruck an jeder Ecke unterschiedliches Verhalten zeigt. Oft ändert der Slicer den Schichtwechsel an einer Ecke, wodurch sich diese Ecke deutlich von den übrigen drei Ecken unterscheiden kann. Tritt dies auf, ignorieren Sie diese Ecke und kalibrieren Sie Pressure Advance anhand der anderen drei Ecken. Auch bei den übrigen Ecken kommt es häufig zu leichten Abweichungen. (Dies kann durch kleine Unterschiede darin entstehen, wie der Rahmen des Druckers auf Kurvenfahrten in bestimmten Richtungen reagiert.) Versuchen Sie, einen Wert zu wählen, der für alle übrigen Ecken gut funktioniert. Bevorzugen Sie im Zweifelsfall einen niedrigeren Pressure-Advance-Wert.
* Wird ein hoher Pressure-Advance-Wert verwendet (z. B. über 0,200), kann es vorkommen, dass der Extruder beim Zurückkehren zur normalen Beschleunigung des Druckers Schritte verliert. Das Pressure-Advance-System berücksichtigt den Druck, indem während der Beschleunigung zusätzliches Filament vorgeschoben und während der Verzögerung wieder zurückgezogen wird. Bei hoher Beschleunigung und hohem Pressure Advance verfügt der Extruder möglicherweise nicht über genug Drehmoment, um das benötigte Filament zu fördern. Tritt dies auf, verwenden Sie entweder einen niedrigeren Beschleunigungswert oder deaktivieren Sie Pressure Advance.
* Ist Pressure Advance in Klipper kalibriert, kann es dennoch sinnvoll sein, im Slicer einen kleinen Retraction-Wert zu konfigurieren (z. B. 0,75 mm) und, falls verfügbar, die "Wipe on Retract"-Option des Slicers zu nutzen. Diese Slicer-Einstellungen können helfen, Fadenziehen (Oozing) durch die Kohäsion des Filaments (aus der Düse gezogenes Filament aufgrund der Klebrigkeit des Kunststoffs) entgegenzuwirken. Es wird empfohlen, die Option "Z-Lift bei Retraction" des Slicers zu deaktivieren.
* Das Pressure-Advance-System ändert weder das Timing noch den Pfad des Werkzeugkopfs. Ein Druck mit aktiviertem Pressure Advance benötigt dieselbe Zeit wie ein Druck ohne Pressure Advance. Pressure Advance ändert auch nicht die insgesamt während eines Drucks extrudierte Filamentmenge. Pressure Advance führt während der Beschleunigung und Verzögerung von Bewegungen zu zusätzlicher Extruderbewegung. Ein sehr hoher Pressure-Advance-Wert führt zu einer sehr großen Extruderbewegung während Beschleunigung und Verzögerung, und keine Konfigurationseinstellung begrenzt den Umfang dieser Bewegung.
