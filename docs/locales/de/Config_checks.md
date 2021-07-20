Dieses Dokument enthält eine Liste von Schritten, die bei der Bestätigung der Pin-Einstellungen in der Datei "Klipper printer.cfg" helfen. Es ist eine gute Idee, diese Schritte durchzugehen, nachdem Sie die Schritte im [Installationsdokument](Installation.md) ausgeführt haben.

Während dieser Anleitung kann es notwendig sein, Änderungen an der Klipper-Konfigurationsdatei vorzunehmen. Stellen Sie sicher, dass Sie nach jeder Änderung an der Konfigurationsdatei einen RESTART-Befehl erteilen, um sicherzustellen, dass die Änderung wirksam wird (geben Sie "restart" in der Octoprint-Terminal-Registerkarte ein und klicken Sie dann auf "Senden"). Es ist auch eine gute Idee, nach jedem RESTART einen STATUS-Befehl zu geben, um zu überprüfen, ob die Konfigurationsdatei erfolgreich geladen wurde.

### Prüfen der Temperatur

Beginnen Sie mit der Überprüfung, ob die Temperaturen korrekt gemeldet werden. Navigieren Sie zur Registerkarte "Octoprint-Temperatur".

![octoprint-temperature](img/octoprint-temperature.png)

Überprüfen Sie, ob die Temperatur der Düse und des Bettes (falls zutreffend) vorhanden ist und nicht ansteigt. Wenn sie ansteigt, trennen Sie den Drucker von der Stromversorgung. Wenn die Temperaturen nicht genau sind, überprüfen Sie die Einstellungen "sensor_type" und "sensor_pin" für die Düse und/oder das Bett.

### Überprüfen Sie M112

Navigieren Sie zur Registerkarte "Octoprint-Terminal" und geben Sie einen M112-Befehl in der Terminalbox ein. Dieser Befehl fordert Klipper auf, in einen "Shutdown"-Zustand zu gehen. Dies führt dazu, dass Octoprint die Verbindung zu Klipper trennt - navigieren Sie zum Bereich "Verbindung" und klicken Sie auf "Verbinden", damit Octoprint die Verbindung wieder aufnimmt. Navigieren Sie dann zur Registerkarte "Octoprint-Temperatur" und überprüfen Sie, ob die Temperaturen weiterhin aktualisiert werden und nicht ansteigen. Wenn die Temperaturen ansteigen, trennen Sie den Drucker von der Stromversorgung.

Der M112-Befehl veranlasst Klipper, in einen "Shutdown"-Zustand zu gehen. Um diesen Zustand zu löschen, geben Sie einen FIRMWARE_RESTART-Befehl in der Octoprint-Terminal-Registerkarte aus.

### Prüfen Sie die Heizungen

Navigieren Sie zur Registerkarte "Octoprint temperature" (Octoprint-Temperatur) und geben Sie im Feld "Tool" (Werkzeug) den Wert 50 gefolgt von der Eingabetaste ein. Die Extrudertemperatur in der Grafik sollte beginnen, sich zu erhöhen (innerhalb von etwa 30 Sekunden oder so). Gehen Sie dann zum Dropdown-Feld "Tool"-Temperatur und wählen Sie "Off". Nach einigen Minuten sollte die Temperatur auf den ursprünglichen Wert der Raumtemperatur zurückkehren. Wenn die Temperatur nicht ansteigt, überprüfen Sie die "heater_pin"-Einstellung in der Konfiguration.

Wenn der Drucker über ein beheiztes Bett verfügt, führen Sie den obigen Test erneut mit dem Bett durch.

### Schrittmotor-Freigabe-Pin verifizieren

Stellen Sie sicher, dass sich alle Druckerachsen manuell frei bewegen können (die Schrittmotoren sind deaktiviert). Wenn nicht, geben Sie einen M84-Befehl aus, um die Motoren zu deaktivieren. Wenn sich eine der Achsen immer noch nicht frei bewegen kann, überprüfen Sie die Stepper-Konfiguration "enable_pin" für die angegebene Achse. Bei den meisten Handelsüblichen Schrittmotortreibern ist der Motoraktivierungspin "aktiv niedrig" und daher sollte der Aktivierungsstift vor dem Stift ein "!" haben (z. B. "enable_pin: !ar38").

### Endstopps verifizieren

Bewegen Sie alle Druckerachsen manuell so, dass keine von ihnen mit einem Endanschlag in Kontakt ist. Senden Sie einen QUERY_ENDSTOPS-Befehl über das Octoprint-Terminalregister. Er sollte mit dem aktuellen Status aller konfigurierten Endstops antworten und sie sollten alle den Status "offen" melden. Führen Sie für jeden der Endstopps den Befehl QUERY_ENDSTOPS erneut aus, während Sie den Endstopp manuell auslösen. Der QUERY_ENDSTOPS-Befehl sollte den Endstopp als "TRIGGERED" melden.

Wenn der Endstopp invertiert erscheint (er meldet "offen", wenn er ausgelöst wird und umgekehrt), fügen Sie der Pin-Definition ein "!" hinzu (z. B. "endstop_pin: ^!ar3"), oder entfernen Sie das "!", wenn bereits eines vorhanden ist.

Wenn sich der Endstop überhaupt nicht ändert, deutet dies im Allgemeinen darauf hin, dass der Endstop an einen anderen Pin angeschlossen ist. Es kann jedoch auch eine Änderung der Pullup-Einstellung des Pins erforderlich sein (das '^' am Anfang des endstop_pin-Namens - die meisten Drucker verwenden einen Pullup-Widerstand und das '^' sollte vorhanden sein).

### Schrittmotoren überprüfen

Verwenden Sie den Befehl STEPPER_BUZZ, um die Konnektivität der einzelnen Schrittmotoren zu überprüfen. Beginnen Sie mit der manuellen Positionierung der angegebenen Achse auf einen mittleren Punkt und führen Sie dann `STEPPER_BUZZ STEPPER=stepper_x` aus. Der Befehl STEPPER_BUZZ bewirkt, dass sich der angegebene Schrittmotor einen Millimeter in eine positive Richtung bewegt und dann in seine Ausgangsposition zurückkehrt. (Wenn der Endanschlag mit position_endstop=0 definiert ist, bewegt sich der Stepper zu Beginn jeder Bewegung vom Endanschlag weg). Diese Oszillation wird zehnmal durchgeführt.

Wenn sich der Schrittmotor überhaupt nicht bewegt, dann überprüfen Sie die Einstellungen "enable_pin" und "step_pin" für den Schrittmotor. Wenn sich der Schrittmotor bewegt, aber nicht in seine ursprüngliche Position zurückkehrt, überprüfen Sie die Einstellung von "dir_pin". Wenn der Schrittmotor in eine falsche Richtung schwingt, deutet dies in der Regel darauf hin, dass der "dir_pin" für die Achse invertiert werden muss. Dies geschieht durch Hinzufügen eines '!' zum "dir_pin" in der Druckerkonfigurationsdatei (oder durch Entfernen, falls dort bereits eines vorhanden ist). Wenn sich der Motor deutlich mehr oder deutlich weniger als einen Millimeter bewegt, überprüfen Sie die Einstellung "rotation_distance".

Führen Sie den obigen Test für jeden in der Config-Datei definierten Schrittmotor durch. (Setzen Sie den Parameter STEPPER des Befehls STEPPER_BUZZ auf den Namen des Konfigurationsabschnitts, der getestet werden soll.) Wenn sich kein Filament im Extruder befindet, kann man STEPPER_BUZZ verwenden, um die Konnektivität des Extrudermotors zu überprüfen (verwenden Sie STEPPER=extruder). Andernfalls ist es am besten, den Extrudermotor separat zu testen (siehe den nächsten Abschnitt).

Nach der Verifizierung aller Endanschläge und der Verifizierung aller Schrittmotoren sollte der Referenziermechanismus getestet werden. Geben Sie einen G28-Befehl aus, um alle Achsen zu referenzieren. Trennen Sie den Drucker von der Stromversorgung, wenn er nicht ordnungsgemäß referenziert. Führen Sie die Schritte zur Überprüfung der Endanschläge und Schrittmotoren erneut durch, falls erforderlich.

### Prüfen Sie den Extrudermotor

Um den Extrudermotor zu testen, muss der Extruder auf eine Drucktemperatur erhitzen. Navigieren Sie zur Registerkarte Octoprint-Temperatur und wählen Sie eine Zieltemperatur aus dem Dropdown-Feld Temperatur aus (oder geben Sie manuell eine geeignete Temperatur ein). Warten Sie, bis der Drucker die gewünschte Temperatur erreicht hat. Navigieren Sie dann zur Registerkarte Octoprint-Steuerelement und klicken Sie auf die Schaltfläche "Extrudieren". Stellen Sie sicher, dass sich der Extrudermotor in die richtige Richtung dreht. Wenn dies nicht der Fall ist, lesen Sie die Tipps zur Fehlerbehebung im vorherigen Abschnitt, um die Einstellungen "enable_pin", "step_pin" und "dir_pin" für den Extruder zu bestätigen.

### PID-Einstellungen kalibrieren

Klipper unterstützt die [PID-Regelung] (https://en.wikipedia.org/wiki/PID_controller) für den Extruder und die Bettheizungen. Um diesen Regelungsmechanismus zu nutzen, ist es notwendig, die PID-Einstellungen an jedem Drucker zu kalibrieren. (PID-Einstellungen, die in anderen Firmwares oder in den Beispielkonfigurationsdateien gefunden werden, funktionieren oft schlecht).

Um den Extruder zu kalibrieren, navigieren Sie zur Registerkarte OctoPrint-Terminal und führen Sie den Befehl PID_CALIBRATE aus. Zum Beispiel: `PID_CALIBRATE HEATER=extruder TARGET=170`

Führen Sie nach Abschluss des Abstimmungstests `SAVE_CONFIG` aus, um die Datei printer.cfg mit den neuen PID-Einstellungen zu aktualisieren.

Wenn der Drucker über ein beheiztes Bett verfügt und die Ansteuerung durch PWM (Pulsweitenmodulation) unterstützt, wird empfohlen, eine PID-Regelung für das Bett zu verwenden. (Wenn die Bettheizung mit dem PID-Algorithmus gesteuert wird, schaltet sie möglicherweise zehnmal pro Sekunde ein und aus, was für Heizungen mit einem mechanischen Schalter möglicherweise nicht geeignet ist). Ein typischer PID-Kalibrierungsbefehl für das Bett lautet: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

### Nächste Schritte

Diese Anleitung soll bei der grundlegenden Überprüfung der Pin-Einstellungen in der Klipper-Konfigurationsdatei helfen. Lesen Sie unbedingt die Anleitung [Bed leveling](Bed_Level.md). Lesen Sie auch das Dokument [Slicers](Slicers.md) für Informationen zur Konfiguration eines Slicers mit Klipper.

Nachdem man sich vergewissert hat, dass der Grunddruck funktioniert, sollte man eine Kalibrierung der [Druckweiterschaltung](Pressure_Advance.md) in Betracht ziehen.

Es kann notwendig sein, andere Arten der detaillierten Druckerkalibrierung durchzuführen - eine Reihe von Anleitungen sind online verfügbar, um dabei zu helfen (führen Sie z. B. eine Websuche nach "3d printer calibration" durch). Wenn Sie z. B. den Effekt "Klingeln" feststellen, können Sie versuchen, die Abstimmungsanleitung [Resonanzkompensation](Resonance_Compensation.md) zu befolgen.
