# Überprüfung der Konfiguration

Dieses Dokument enthält eine Liste von Schritten, die bei der Bestätigung der Pin-Einstellungen in der Klipper printer.cfg-Datei helfen. Es ist eine gute Idee, diese Schritte durchzugehen, nachdem Sie die Schritte im [Installationsdokument](Installation.md) ausgeführt haben.

Während dieser Anleitung kann es notwendig sein, Änderungen an der Klipper-Konfigurationsdatei vorzunehmen. Stellen Sie sicher, dass Sie nach jeder Änderung an der Konfigurationsdatei einen RESTART-Befehl erteilen, um sicherzustellen, dass die Änderung wirksam wird (geben Sie "restart" in der Octoprint-Terminal-Registerkarte ein und klicken Sie dann auf "Senden"). Es ist auch eine gute Idee, nach jedem RESTART einen STATUS-Befehl zu geben, um zu überprüfen, ob die Konfigurationsdatei erfolgreich geladen wurde.

## Prüfen der Temperatur

Beginnen Sie damit, zu überprüfen, ob die Temperaturen ordnungsgemäß gemeldet werden. Navigieren Sie zum Abschnitt Temperaturdiagramm in der Benutzeroberfläche. Stellen Sie sicher, dass die Temperatur der Düse und des Betts (falls zutreffend) vorhanden ist und nicht ansteigt. Falls sie ansteigt, trennen Sie die Stromzufuhr zum Drucker. Wenn die Temperaturen nicht korrekt sind, überprüfen Sie die Einstellungen für "sensor_type" und "sensor_pin" für die Düse und/oder das Bett.

## Überprüfen Sie M112

Navigieren Sie zur Befehlskonsole und geben Sie einen M112-Befehl im Terminalfeld ein. Dieser Befehl fordert Klipper auf, in den "Abschalt"-Zustand zu wechseln. Dadurch wird ein Fehler angezeigt, der mit einem FIRMWARE_RESTART-Befehl in der Befehlskonsole behoben werden kann. Octoprint erfordert ebenfalls eine Neuverbindung. Navigieren Sie dann zum Temperaturdiagrammabschnitt und überprüfen Sie, ob die Temperaturen weiterhin aktualisiert werden und die Temperaturen nicht steigen. Wenn die Temperaturen steigen, entfernen Sie die Stromversorgung vom Drucker.

## Prüfen Sie die Heizelemente

Navigieren Sie zum Abschnitt Temperaturgraph und geben Sie 50 ein, gefolgt von der Eingabetaste im Extruder/Werkzeugtemperaturfeld ein. Die Extruder Temperatur im Diagramm sollte anfangen zu steigen (innerhalb von etwa 30 Sekunden oder so). Gehen Sie dann zum Extruder-Temperatur-Dropdown-Feld und wählen Sie "Aus". Nach einigen Minuten sollte die Temperatur wieder auf ihren ursprünglichen Raumtemperaturwert zurückkehren. Wenn die Temperatur nicht ansteigt, überprüfen Sie die Einstellung des "Heater_Pin" im Konfigurationsmenü.

Wenn der Drucker über ein beheiztes Bett verfügt, führen Sie den obigen Test erneut mit dem Bett durch.

## Stepper Freigabe-Pin verifizieren

Stellen Sie sicher, dass alle Achsen des Druckers manuell frei bewegt werden können (die Schrittmotoren sind deaktiviert). Wenn nicht, geben Sie einen M84-Befehl heraus, um die Motoren zu deaktivieren. Falls eine der Achsen immer noch nicht frei bewegt werden kann, überprüfen Sie die Konfiguration des Schrittmotor-"enable_pin" für die betreffende Achse. Bei den meisten handelsüblichen Schrittmotortreibern ist der Motoraktivierungsstift "aktiviert niedrig", daher sollte der Aktivierungsstift ein "!" vor dem Stift haben (zum Beispiel "enable_pin: !PA1").

## Endstopps überprüfen

Bewegen Sie manuell alle Druckerachsen, damit keine von ihnen mit einem Endstop in Kontakt stehen. Senden Sie über die Befehlskonsole ein ''QUERY_ENDSTOPS'' Befehl. Es sollte den aktuellen Zustand aller konfigurierten Endstops zurückgeben und sie sollten alle einen Zustand von "offen" melden. Führen Sie für jeden Endstop erneut den ''QUERY_ENDSTOPS'' Befehl aus, während Sie den Endstop manuell auslösen. Der QUERY_ENDSTOPS-Befehl sollte den Endstop als "AUSGELÖST" melden.

Wenn der Endanschlag invertiert erscheint (es wird "offen" gemeldet, wenn er ausgelöst wird, und umgekehrt), fügen Sie dann der Stiftdefinition ein "!" hinzu (zum Beispiel "endstop_pin: ^PA2"), oder entfernen Sie das "!", wenn bereits eins vorhanden ist.

Wenn sich der Endstop überhaupt nicht ändert, deutet dies im Allgemeinen darauf hin, dass der Endstop an einen anderen Pin angeschlossen ist. Es kann jedoch auch eine Änderung der Pullup-Einstellung des Pins erforderlich sein (das '^' am Anfang des endstop_pin-Namens - die meisten Drucker verwenden einen Pullup-Widerstand und das '^' sollte vorhanden sein).

## Schrittmotoren überprüfen

Verwenden Sie das STEPPER_BUZZ-Befehl, um die Konnektivität jedes Schrittmotors zu überprüfen. Beginnen Sie damit, die gegebene Achse manuell auf einen Mittelpunkt zu positionieren, und führen Sie dann `STEPPER_BUZZ STEPPER=stepper_x` in der Befehlskonsole aus. Der STEPPER_BUZZ-Befehl lässt den angegebenen Schrittmotor einen Millimeter in positive Richtung bewegen, bevor er zu seiner Ausgangsposition zurückkehrt. (Wenn der Endanschlag bei position_endstop=0 definiert ist, bewegt sich der Schrittmotor zu Beginn jeder Bewegung weg vom Endanschlag.) Dies wird zehnmal ausgeführt.

Wenn sich der Schrittmotor überhaupt nicht bewegt, dann überprüfen Sie die Einstellungen "enable_pin" und "step_pin" für den Schrittmotor. Wenn sich der Schrittmotor bewegt, aber nicht in seine ursprüngliche Position zurückkehrt, überprüfen Sie die Einstellung von "dir_pin". Wenn sich der Schrittmotor in eine falsche Richtung bewegt, deutet dies in der Regel darauf hin, dass der "dir_pin" für die Achse invertiert werden muss. Dies geschieht durch Hinzufügen eines '!' zum "dir_pin" in der Druckerkonfigurationsdatei (oder durch Entfernen, falls dort bereits eines vorhanden ist). Wenn sich der Motor deutlich mehr oder deutlich weniger als einen Millimeter bewegt, überprüfen Sie die Einstellung "rotation_distance".

Führen Sie den obigen Test für jeden in der Config-Datei definierten Schrittmotor durch. (Setzen Sie den Parameter STEPPER des Befehls STEPPER_BUZZ auf den Namen des Konfigurationsabschnitts, der getestet werden soll.) Wenn sich kein Filament im Extruder befindet, kann man STEPPER_BUZZ verwenden, um die Konnektivität des Extrudermotors zu überprüfen (verwenden Sie STEPPER=extruder). Andernfalls ist es am besten, den Extrudermotor separat zu testen (siehe den nächsten Abschnitt).

Nach der Verifizierung aller Endanschläge und der Verifizierung aller Schrittmotoren sollte der Referenziermechanismus getestet werden. Geben Sie einen G28-Befehl aus, um alle Achsen zu referenzieren. Trennen Sie den Drucker von der Stromversorgung, wenn er nicht ordnungsgemäß referenziert. Führen Sie die Schritte zur Überprüfung der Endanschläge und Schrittmotoren erneut durch, falls erforderlich.

## Prüfen Sie den Extrudermotor

Um den Extruder-Motor zu testen, muss der Extruder auf eine Drucktemperatur erhitzt werden. Navigieren Sie zum Temperaturgraphenabschnitt und wählen Sie eine Zieltemperatur aus dem Temperatur-Dropdown-Feld aus (oder geben Sie manuell eine passende Temperatur ein). Warten Sie, bis der Drucker die gewünschte Temperatur erreicht hat. Navigieren Sie dann zur Befehlskonsole und klicken Sie auf die Schaltfläche "Extrude". Stellen Sie sicher, dass sich der Extruder-Motor in die richtige Richtung dreht. Wenn nicht, sehen Sie sich die Problembehebungstipps im vorherigen Abschnitt an, um die Einstellungen für "enable_pin", "step_pin" und "dir_pin" für den Extruder zu bestätigen.

## PID-Einstellungen kalibrieren

Klipper unterstützt die [PID-Regelung](https://de.wikipedia.org/wiki/Regler#PID-Regler) für den Extruder und die Bettheizungen. Um diesen Regelungsmechanismus zu nutzen, ist es notwendig, die PID-Einstellungen auf jedem Drucker zu kalibrieren (PID-Einstellungen, die in anderen Programmen oder in den Beispielkonfigurationsdateien gefunden wurden, funktionieren oft schlecht).

Um den Extruder zu kalibrieren, navigieren Sie zur Befehlskonsole und führen Sie den PID_CALIBRATE-Befehl aus. Zum Beispiel: `PID_CALIBRATE HEATER=Extruder TARGET=170`

Führen Sie nach Abschluss des Abstimmungstests `SAVE_CONFIG` aus, um die Datei printer.cfg mit den neuen PID-Einstellungen zu aktualisieren.

Wenn der Drucker über ein beheiztes Bett verfügt und die Ansteuerung durch PWM (Pulsweitenmodulation) unterstützt, ist es empfohlen, eine PID-Regelung für das Bett zu verwenden. (Wenn die Bettheizung mit dem PID-Algorithmus gesteuert wird, schaltet sie möglicherweise zehnmal pro Sekunde ein und aus, was für Heizungen mit einem mechanischen Schalter möglicherweise nicht geeignet ist). Ein typischer PID-Kalibrierungsbefehl für das Bett lautet: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Nächste Schritte

Diese Anleitung soll bei der grundlegenden Überprüfung der Pin-Einstellungen in der Klipper-Konfigurationsdatei helfen. Lesen Sie unbedingt die Anleitung [Bed leveling](Bed_Level.md). Lesen Sie auch das Dokument [Slicers](Slicers.md) für Informationen zur Konfiguration eines Slicers mit Klipper.

Nachdem man sich vergewissert hat, dass das Drucken grundlegend funktioniert, sollte man eine Kalibrierung des [Druckes im Materialvorschub](Pressure_Advance.md) in Betracht ziehen.

Es kann notwendig sein, andere Arten der detaillierten Druckerkalibrierung durchzuführen - eine Reihe von Anleitungen sind online verfügbar, um dabei zu helfen (führen Sie z. B. eine Websuche nach "3d printer calibration" durch). Wenn Sie z. B. den sogenannten "Ringing"-Effekt feststellen, können Sie versuchen, die Abstimmungsanleitung [Resonanzkompensation](Resonance_Compensation.md) zu befolgen.
