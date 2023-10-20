# Überprüfung der Konfiguration

Dieses Dokument enthält eine Liste von Schritten, die bei der Bestätigung der Pin-Einstellungen in der Klipper printer.cfg-Datei helfen. Es ist eine gute Idee, diese Schritte durchzugehen, nachdem Sie die Schritte im [Installationsdokument](Installation.md) ausgeführt haben.

Während dieser Anleitung kann es notwendig sein, Änderungen an der Klipper-Konfigurationsdatei vorzunehmen. Stellen Sie sicher, dass Sie nach jeder Änderung an der Konfigurationsdatei einen RESTART-Befehl erteilen, um sicherzustellen, dass die Änderung wirksam wird (geben Sie "restart" in der Octoprint-Terminal-Registerkarte ein und klicken Sie dann auf "Senden"). Es ist auch eine gute Idee, nach jedem RESTART einen STATUS-Befehl zu geben, um zu überprüfen, ob die Konfigurationsdatei erfolgreich geladen wurde.

## Prüfen der Temperatur

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Überprüfen Sie M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Prüfen Sie die Heizelemente

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Wenn der Drucker über ein beheiztes Bett verfügt, führen Sie den obigen Test erneut mit dem Bett durch.

## Schrittmotor-Freigabe-Pin verifizieren

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Endstopps verifizieren

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Wenn sich der Endstop überhaupt nicht ändert, deutet dies im Allgemeinen darauf hin, dass der Endstop an einen anderen Pin angeschlossen ist. Es kann jedoch auch eine Änderung der Pullup-Einstellung des Pins erforderlich sein (das '^' am Anfang des endstop_pin-Namens - die meisten Drucker verwenden einen Pullup-Widerstand und das '^' sollte vorhanden sein).

## Schrittmotoren überprüfen

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Wenn sich der Schrittmotor überhaupt nicht bewegt, dann überprüfen Sie die Einstellungen "enable_pin" und "step_pin" für den Schrittmotor. Wenn sich der Schrittmotor bewegt, aber nicht in seine ursprüngliche Position zurückkehrt, überprüfen Sie die Einstellung von "dir_pin". Wenn der Schrittmotor in eine falsche Richtung schwingt, deutet dies in der Regel darauf hin, dass der "dir_pin" für die Achse invertiert werden muss. Dies geschieht durch Hinzufügen eines '!' zum "dir_pin" in der Druckerkonfigurationsdatei (oder durch Entfernen, falls dort bereits eines vorhanden ist). Wenn sich der Motor deutlich mehr oder deutlich weniger als einen Millimeter bewegt, überprüfen Sie die Einstellung "rotation_distance".

Führen Sie den obigen Test für jeden in der Config-Datei definierten Schrittmotor durch. (Setzen Sie den Parameter STEPPER des Befehls STEPPER_BUZZ auf den Namen des Konfigurationsabschnitts, der getestet werden soll.) Wenn sich kein Filament im Extruder befindet, kann man STEPPER_BUZZ verwenden, um die Konnektivität des Extrudermotors zu überprüfen (verwenden Sie STEPPER=extruder). Andernfalls ist es am besten, den Extrudermotor separat zu testen (siehe den nächsten Abschnitt).

Nach der Verifizierung aller Endanschläge und der Verifizierung aller Schrittmotoren sollte der Referenziermechanismus getestet werden. Geben Sie einen G28-Befehl aus, um alle Achsen zu referenzieren. Trennen Sie den Drucker von der Stromversorgung, wenn er nicht ordnungsgemäß referenziert. Führen Sie die Schritte zur Überprüfung der Endanschläge und Schrittmotoren erneut durch, falls erforderlich.

## Prüfen Sie den Extrudermotor

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## PID-Einstellungen kalibrieren

Klipper unterstützt die [PID-Regelung](https://de.wikipedia.org/wiki/Regler#PID-Regler) für den Extruder und die Bettheizungen. Um diesen Regelungsmechanismus zu nutzen, ist es notwendig, die PID-Einstellungen auf jedem Drucker zu kalibrieren (PID-Einstellungen, die in anderen Programmen oder in den Beispielkonfigurationsdateien gefunden wurden, funktionieren oft schlecht).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

Führen Sie nach Abschluss des Abstimmungstests `SAVE_CONFIG` aus, um die Datei printer.cfg mit den neuen PID-Einstellungen zu aktualisieren.

Wenn der Drucker über ein beheiztes Bett verfügt und die Ansteuerung durch PWM (Pulsweitenmodulation) unterstützt, wird empfohlen, eine PID-Regelung für das Bett zu verwenden. (Wenn die Bettheizung mit dem PID-Algorithmus gesteuert wird, schaltet sie möglicherweise zehnmal pro Sekunde ein und aus, was für Heizungen mit einem mechanischen Schalter möglicherweise nicht geeignet ist). Ein typischer PID-Kalibrierungsbefehl für das Bett lautet: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Nächste Schritte

Diese Anleitung soll bei der grundlegenden Überprüfung der Pin-Einstellungen in der Klipper-Konfigurationsdatei helfen. Lesen Sie unbedingt die Anleitung [Bed leveling](Bed_Level.md). Lesen Sie auch das Dokument [Slicers](Slicers.md) für Informationen zur Konfiguration eines Slicers mit Klipper.

Nachdem man sich vergewissert hat, dass das drucken grundlegend funktioniert, sollte man eine Kalibrierung des [Druck im Materialvorschub](Pressure_Advance.md) in Betracht ziehen.

Es kann notwendig sein, andere Arten der detaillierten Druckerkalibrierung durchzuführen - eine Reihe von Anleitungen sind online verfügbar, um dabei zu helfen (führen Sie z. B. eine Websuche nach "3d printer calibration" durch). Wenn Sie z. B. den Effekt "Klingeln" feststellen, können Sie versuchen, die Abstimmungsanleitung [Resonanzkompensation](Resonance_Compensation.md) zu befolgen.
