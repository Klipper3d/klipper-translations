# BL-Touch

## Verbindung zum BL Touch

Eine **Warnung**, bevor Sie beginnen: Vermeiden Sie es, den BL-Touch-Stift mit bloßen Fingern zu berühren, da er sehr empfindlich auf Fingerfett reagiert. Und wenn Sie ihn doch berühren, seien Sie sehr vorsichtig, um nichts zu verbiegen oder zu drücken.

Verbinden Sie den BL-Touch "Servo"-Anschluss mit einem `control_pin` gemäß der BL-Touch Dokumentation oder Ihrer MCU Dokumentation. Bei der Originalverdrahtung ist der gelbe Draht des Dreifachsteckers der `control_pin` und der weiße Draht des Paares ist der `sensor_pin`. Sie müssen diese Pins entsprechend Ihrer Verdrahtung konfigurieren. Die meisten BL-Touch-Geräte erfordern einen Pullup am Sensor-Pin (stellen Sie dem Pin-Namen ein "^" voran). Zum Beispiel:

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

Wenn der BL-Touch zum Homen der Z-Achse verwendet werden soll, setzen Sie `endstop_pin: probe:z_virtual_endstop` und entfernen Sie `position_endstop` im Konfigurationsabschnitt `[stepper_z]`; fügen Sie anschließend einen Abschnitt `[safe_z_home]` hinzu, um die Z-Achse anzuheben, die XY-Achsen zu homen, in die Bettmitte zu fahren und die Z-Achse zu homen. Zum Beispiel:

```
[safe_z_home]
home_xy_position: 100, 100 # Change coordinates to the center of your print bed
speed: 50
z_hop: 10                 # Move up 10mm
z_hop_speed: 5
```

Es ist wichtig, dass die z_hop-Bewegung in safe_z_home hoch genug ist, damit die Sonde nichts trifft, auch wenn der Sondenstift zufällig in seinem niedrigsten Zustand ist.

## Erste Tests

Bevor Sie fortfahren, vergewissern Sie sich, dass der BL-Touch in der richtigen Höhe montiert ist. Der Stift sollte sich im eingefahrenen Zustand etwa 2 mm über der Düse befinden

Wenn Sie den Drucker einschalten, sollte die BL-Touch-Sonde einen Selbsttest durchführen und den Stift ein paar Mal auf und ab bewegen. Sobald der Selbsttest abgeschlossen ist, sollte der Stift zurückgezogen werden und die rote LED an der Sonde dauerhaft leuchten. Sollten Fehler auftreten, z. B. wenn die Sonde rot blinkt oder der Stift nach unten statt nach oben zeigt, schalten Sie den Drucker aus und überprüfen Sie die Verkabelung und Konfiguration.

Wenn das alles gut aussieht, ist es an der Zeit, zu testen, ob der kontrollpin richtig funktioniert. Führen Sie zunächst `BLTOUCH_DEBUG COMMAND=pin_down` in Ihrem Druckerterminal aus. Vergewissern Sie sich, dass sich der Stift nach unten bewegt und dass die rote LED auf der Sonde erlischt. Falls nicht, überprüfen Sie Ihre Verkabelung und Konfiguration erneut. Geben Sie als Nächstes einen `BLTOUCH_DEBUG COMMAND=pin_up` ein und überprüfen Sie, ob sich der Stift nach oben bewegt und die rote Lampe wieder aufleuchtet. Wenn es blinkt, liegt ein Problem vor.

Im nächsten Schritt ist zu bestätigen, dass der Sensorstift korrekt arbeitet. Führen Sie `BLTOUCH_DEBUG COMMAND=pin_down` aus, prüfen Sie, ob sich der Stift nach unten bewegt, führen Sie `BLTOUCH_DEBUG COMMAND=touch_mode` aus, führen Sie `QUERY_PROBE` aus und prüfen Sie, ob der Befehl "probe: open" meldet. Drücken Sie dann den Stift mit dem Fingernagel vorsichtig ein Stück nach oben und führen Sie erneut `QUERY_PROBE` aus. Prüfen Sie, ob der Befehl "probe: TRIGGERED" meldet. Meldet eine der beiden Abfragen nicht die richtige Meldung, deutet das üblicherweise auf eine falsche Verkabelung oder Konfiguration hin (wobei manche [Klone](#bl-touch-clones) eine besondere Behandlung erfordern können). Führen Sie zum Abschluss dieses Tests `BLTOUCH_DEBUG COMMAND=pin_up` aus und prüfen Sie, ob sich der Stift nach oben bewegt.

Nachdem Sie die Tests für den BL-Touch-Control Pin und den Sensorstift erfolgreich abgeschlossen haben, ist es nun an der Zeit, die Abtastung zu testen, allerdings mit einer anderen Methode. Anstatt den Taststift das Druckbett berühren zu lassen, lassen Sie ihn den Nagel Ihres Fingers berühren. Positionieren Sie den Werkzeugkopf weit vom Druckbett entfernt, geben Sie ein `G28` aus (oder `PROBE`, wenn Sie nicht probe:z_virtual_endstop verwenden), warten Sie, bis der Werkzeugkopf beginnt, sich nach unten zu bewegen, und stoppen Sie die Bewegung, indem Sie den Stift ganz sanft mit Ihrem Nagel berühren. Möglicherweise müssen Sie dies zweimal tun, da die Standardkonfiguration für die Referenzpunktfahrt zweimal testet. Bereiten Sie sich darauf vor, den Drucker auszuschalten, wenn er nicht stoppen sollte sobald Sie den Stift berühren.

Wenn das erfolgreich war, machen Sie ein weiteres `G28` (oder `PROBE`), aber diesmal lassen Sie es das Bett berühren, wie im normalen Betrieb.

## BL-Touch defekt

Sobald sich der BL-Touch in einem inkonsistenten Zustand befindet, beginnt er rot zu blinken. Sie können ihn mit folgendem Befehl zwingen, diesen Zustand zu verlassen:

BLTOUCH_DEBUG COMMAND=reset

Das kann passieren, wenn seine Kalibrierung dadurch unterbrochen wird, dass das Ausfahren des Stifts blockiert ist.

Der BL-Touch kann sich unter Umständen aber auch gar nicht mehr selbst kalibrieren. Das tritt auf, wenn die Schraube an seiner Oberseite in der falschen Position steht oder sich der Magnetkern im Sondenstift verschoben hat. Hat er sich nach oben verschoben, sodass er an der Schraube haftet, kann der Stift möglicherweise nicht mehr abgesenkt werden. Bei diesem Verhalten müssen Sie die Schraube herausdrehen und den Kern mit einem Kugelschreiber vorsichtig zurück in seine Lage schieben. Setzen Sie den Stift so in den BL-Touch ein, dass er in die ausgefahrene Position fällt. Drehen Sie die Madenschraube vorsichtig wieder ein. Sie müssen die richtige Position finden, in der der Stift abgesenkt und angehoben werden kann und das rote Licht an- und ausgeht. Verwenden Sie dafür die Befehle `reset`, `pin_up` und `pin_down`.

## BL-Touch "Nachbauten"

Viele BL-Touch-"Klon"-Geräte funktionieren mit Klipper in der Standardkonfiguration einwandfrei. Manche "Klon"-Geräte unterstützen jedoch den Befehl `QUERY_PROBE` nicht, und bei manchen "Klon"-Geräten kann die Konfiguration von `pin_up_reports_not_triggered` oder `pin_up_touch_mode_reports_triggered` erforderlich sein.

Wichtig! Setzen Sie `pin_up_reports_not_triggered` oder `pin_up_touch_mode_reports_triggered` nicht auf False, ohne zuvor diese Anweisungen befolgt zu haben. Setzen Sie keinen dieser Werte bei einem originalen BL-Touch auf False. Ein fälschliches Setzen auf False kann die Messdauer verlängern und das Risiko einer Beschädigung des Druckers erhöhen.

Manche "Klon"-Geräte unterstützen `touch_mode` nicht, weshalb der Befehl `QUERY_PROBE` nicht funktioniert. Trotzdem kann es möglich sein, mit diesen Geräten Messungen und Homing durchzuführen. Bei diesen Geräten schlägt der Befehl `QUERY_PROBE` in den [ersten Tests](#initial-tests) fehl, der anschließende Test mit `G28` (oder `PROBE`) gelingt jedoch. Der Einsatz dieser "Klon"-Geräte mit Klipper kann möglich sein, sofern man den Befehl `QUERY_PROBE` nicht nutzt und die Funktion `probe_with_touch_mode` nicht aktiviert.

Einige "Klon"-Geräte können Klippers internen Sensorprüftest nicht bestehen. Bei diesen Geräten können Homing- oder Messversuche dazu führen, dass Klipper den Fehler "BLTouch failed to verify sensor state" meldet. Tritt dies auf, führen Sie die Schritte zur Überprüfung des Sensorstifts manuell aus, wie im [Abschnitt zu den ersten Tests](#initial-tests) beschrieben. Liefern die `QUERY_PROBE`-Befehle in diesem Test stets die erwarteten Ergebnisse und treten weiterhin Fehler "BLTouch failed to verify sensor state" auf, kann es notwendig sein, `pin_up_touch_mode_reports_triggered` in der Klipper-Konfigurationsdatei auf False zu setzen.

Eine geringe Zahl alter "Klon"-Geräte kann nicht melden, wenn sie ihren Sondenstift erfolgreich angehoben haben. Bei diesen Geräten meldet Klipper nach jedem Homing- oder Messversuch den Fehler "BLTouch failed to raise probe". Man kann auf solche Geräte prüfen: Fahren Sie den Kopf weit vom Bett weg, führen Sie `BLTOUCH_DEBUG COMMAND=pin_down` aus, prüfen Sie, ob sich der Stift abgesenkt hat, führen Sie `QUERY_PROBE` aus, prüfen Sie, ob dieser Befehl "probe: open" meldet, führen Sie `BLTOUCH_DEBUG COMMAND=pin_up` aus, prüfen Sie, ob sich der Stift angehoben hat, und führen Sie `QUERY_PROBE` aus. Bleibt der Stift oben, geht das Gerät nicht in einen Fehlerzustand und meldet die erste Abfrage "probe: open", während die zweite Abfrage "probe: TRIGGERED" meldet, so deutet das darauf hin, dass `pin_up_reports_not_triggered` in der Klipper-Konfigurationsdatei auf False gesetzt werden sollte.

## BL-Touch v3

Bei manchen Geräten BL-Touch v3.0 und BL-Touch 3.1 kann es erforderlich sein, `probe_with_touch_mode` in der Druckerkonfigurationsdatei zu konfigurieren.

Wenn die Signalleitung des BL-Touch v3.0 an einen Endschalter-Pin (mit einem Kondensator zur Störunterdrückung) angeschlossen ist, kann der BL-Touch v3.0 unter Umständen während Homing und Messung kein zuverlässiges Signal senden. Liefern die `QUERY_PROBE`-Befehle im [Abschnitt zu den ersten Tests](#initial-tests) stets die erwarteten Ergebnisse, hält der Druckkopf bei G28/PROBE-Befehlen aber nicht immer an, so deutet das auf dieses Problem hin. Als Abhilfe setzen Sie `probe_with_touch_mode: True` in der Konfigurationsdatei.

Der BL-Touch v3.1 kann nach einem erfolgreichen Messvorgang fälschlich in einen Fehlerzustand gehen. Symptom ist ein gelegentliches Blinken des BL-Touch v3.1 über einige Sekunden, nachdem er das Bett erfolgreich berührt hat. Klipper sollte diesen Fehler automatisch löschen; er ist in der Regel unbedenklich. Man kann jedoch `probe_with_touch_mode` in der Konfigurationsdatei setzen, um dieses Problem zu vermeiden.

Wichtig! Einige "Klon"-Geräte sowie der BL-Touch v2.0 (und früher) können eine geringere Genauigkeit aufweisen, wenn `probe_with_touch_mode` auf True gesetzt ist. Das Setzen auf True verlängert außerdem die Zeit, die zum Ausfahren der Sonde benötigt wird. Wenn Sie diesen Wert an einem "Klon" oder einem älteren BL-Touch-Gerät konfigurieren, prüfen Sie die Messgenauigkeit unbedingt vor und nach dem Setzen (verwenden Sie dafür den Befehl `PROBE_ACCURACY`).

## Mehrfachmessung ohne Einfahren

Standardmäßig fährt Klipper die Sonde zu Beginn jedes Messvorgangs aus und anschließend wieder ein. Dieses wiederholte Aus- und Einfahren der Sonde kann die Gesamtdauer von Kalibriersequenzen mit vielen Messungen verlängern. Klipper unterstützt es, die Sonde zwischen aufeinanderfolgenden Messungen ausgefahren zu lassen, was die Gesamtdauer der Messung verkürzen kann. Dieser Modus wird aktiviert, indem `stow_on_each_sample` in der Konfigurationsdatei auf False gesetzt wird.

Wichtig! Wenn `stow_on_each_sample` auf False gesetzt wird, kann Klipper horizontale Bewegungen des Druckkopfes ausführen, während die Sonde ausgefahren ist. Stellen Sie sicher, dass alle Messvorgänge ausreichend Z-Freiraum haben, bevor Sie diesen Wert auf False setzen. Bei unzureichendem Freiraum kann eine horizontale Bewegung dazu führen, dass der Stift an einem Hindernis hängen bleibt und der Drucker beschädigt wird.

Wichtig! Es wird empfohlen, `probe_with_touch_mode` auf True zu setzen, wenn `stow_on_each_sample` auf False gesetzt ist. Manche "Klon"-Geräte erkennen einen erneuten Bettkontakt möglicherweise nicht, wenn `probe_with_touch_mode` nicht gesetzt ist. Bei allen Geräten vereinfacht die Kombination dieser beiden Einstellungen die Signalisierung des Geräts, was die Gesamtstabilität verbessern kann.

Beachten Sie jedoch, dass einige "Klon"-Geräte sowie der BL-Touch v2.0 (und früher) eine geringere Genauigkeit aufweisen können, wenn `probe_with_touch_mode` auf True gesetzt ist. Bei diesen Geräten ist es sinnvoll, die Messgenauigkeit vor und nach dem Setzen von `probe_with_touch_mode` zu prüfen (verwenden Sie dafür den Befehl `PROBE_ACCURACY`).

## Kalibrierung des BL-Touch Offsets

Folgen Sie den Anweisungen in der Anleitung [Probe Calibrate](Probe_Calibrate.md), um die Konfigurationsparameter x_offset, y_offset und z_offset festzulegen.

Es ist sinnvoll zu überprüfen, ob der Z-Versatz nahe bei 1 mm liegt. Ist das nicht der Fall, sollten Sie die Sonde nach oben oder unten versetzen, um das zu korrigieren. Sie soll deutlich auslösen, bevor die Düse das Bett berührt, damit anhaftendes Filament oder ein verzogenes Bett den Messvorgang nicht beeinträchtigen. Gleichzeitig soll die eingefahrene Position möglichst weit über der Düse liegen, damit die Sonde keine gedruckten Teile berührt. Wird die Position der Sonde verändert, führen Sie die Schritte zur Sondenkalibrierung erneut aus.

## BL-Touch Ausgabemodus

* Ein BL-Touch V3.0 unterstützt die Einstellung eines 5-V- oder Open-Drain-Ausgangsmodus; ein BL-Touch V3.1 unterstützt dies ebenfalls, kann die Einstellung aber zusätzlich in seinem internen EEPROM speichern. Wenn Ihre Controllerplatine den festen High-Pegel von 5 V des 5-V-Modus benötigt, können Sie den Parameter 'set_output_mode' im Abschnitt [bltouch] der Druckerkonfigurationsdatei auf "5V" setzen.

   *** Verwenden Sie den 5-V-Modus nur, wenn die Eingangsleitung Ihrer Controllerplatine 5 V verträgt. Aus diesem Grund ist bei diesen BL-Touch-Versionen der Open-Drain-Modus voreingestellt. Andernfalls könnten Sie die CPU Ihrer Controllerplatine beschädigen ***

   Also: Wenn eine Controllerplatine den 5-V-Modus BENÖTIGT UND ihre Eingangssignalleitung 5 V verträgt UND wenn

   - Sie einen BL-Touch Smart V3.0 haben, müssen Sie den Parameter 'set_output_mode: 5V' verwenden, um diese Einstellung bei jedem Start sicherzustellen, da sich die Sonde die benötigte Einstellung nicht merken kann.
   - Sie einen BL-Touch Smart V3.1 haben, haben Sie die Wahl: Entweder Sie verwenden 'set_output_mode: 5V' oder Sie speichern den Modus einmalig manuell mit dem Befehl 'BLTOUCH_STORE MODE=5V' und verwenden den Parameter 'set_output_mode:' NICHT.
   - Sie eine andere Sonde haben: Manche Sonden besitzen auf der Platine eine Leiterbahn zum Auftrennen oder einen Jumper zum Setzen, um den Ausgangsmodus (dauerhaft) festzulegen. Lassen Sie in diesem Fall den Parameter 'set_output_mode' vollständig weg.
Wenn Sie eine V3.1 haben, automatisieren oder wiederholen Sie das Speichern des Ausgangsmodus nicht, um das EEPROM der Sonde nicht zu verschleißen. Das EEPROM des BLTouch ist für etwa 100.000 Schreibvorgänge ausgelegt. Bei 100 Speichervorgängen pro Tag entspräche das etwa 3 Jahren Betrieb bis zum Verschleiß. Das Speichern des Ausgangsmodus in einer V3.1 wurde vom Hersteller daher bewusst als aufwendiger Vorgang gestaltet (Werkseinstellung ist der sichere Open-Drain-Modus) und eignet sich nicht dafür, wiederholt von einem Slicer, einem Makro oder Ähnlichem abgesetzt zu werden; vorzugsweise wird es nur bei der erstmaligen Integration der Sonde in die Elektronik eines Druckers verwendet.
