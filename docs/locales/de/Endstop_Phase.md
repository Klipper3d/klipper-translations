# Endstop Phase

Dieses Dokument beschreibt das Stepper-phasenangepasste Endstoppsystem von Klipper. Diese Funktionalität kann die Genauigkeit herkömmlicher Endstoppschalter verbessern. Dies ist am nützlichsten, wenn Sie einen Trinamic-Schrittmotortreiber mit Laufzeitkonfiguration verwenden.

Ein typischer Endlagenschalter hat eine Genauigkeit von etwa 100 Mikrometern. (Bei jeder Referenzfahrt einer Achse kann der Schalter etwas früher oder etwas später auslösen.) Obwohl dies ein relativ kleiner Fehler ist, kann er zu unerwünschten Artefakten führen. Insbesondere beim Druck der ersten Schicht eines Objekts kann sich diese Positionsabweichung bemerkbar machen. Im Gegensatz dazu können typische Schrittmotoren eine wesentlich höhere Präzision erreichen.

Das Endschaltermechanismus mit justierbarer Stepper-Phase kann die Präzision der Endschalter durch die Präzision der Schrittmotoren verbessern. Ein Schrittmotor bewegt sich durch das Durchlaufen einer Serie von Phasen, bis er vier "volle Schritte" abgeschlossen hat. Ein Schrittmotor mit 16 Mikroschritten hätte also 64 Phasen und würde sich beim Bewegen in positiver Richtung durch die Phasen bewegen: 0, 1, 2, ... 61, 62, 63, 0, 1, 2 usw. Entscheidend ist, dass der Schrittmotor an einer bestimmten Position auf einer linearen Führung immer in derselben Schrittmotorphase sein sollte. Wenn also der Endschalter ausgelöst wird, sollte der Schrittmotor, der diese Achse kontrolliert, immer in derselben Schrittmotorphase sein. Das Endstop-Phasensystem von Klipper kombiniert die Schrittmotorphase mit dem Endschaltertrigger, um die Genauigkeit des Endschalters zu verbessern.

Um diese Funktion zu nutzen, muss die Phase des Schrittmotors identifiziert werden können. Werden Trinamic-TMC2130-, TMC2208-, TMC2224- oder TMC2660-Treiber im Laufzeit-Konfigurationsmodus verwendet (d. h. nicht im Standalone-Modus), kann Klipper die Schrittmotorphase vom Treiber abfragen. (Dieses System kann auch mit herkömmlichen Schrittmotortreibern verwendet werden, sofern sich die Schrittmotortreiber zuverlässig zurücksetzen lassen - Details siehe unten.)

## Kalibrierung der Endanschlagsphasen

Werden Trinamic-Schrittmotortreiber mit Laufzeitkonfiguration verwendet, können die Endstop-Phasen mit dem Befehl ENDSTOP_PHASE_CALIBRATE kalibriert werden. Fügen Sie dazu zunächst Folgendes zur Konfigurationsdatei hinzu:

```
[endstop_phase]
```

Führen Sie anschließend einen RESTART des Druckers durch und führen Sie einen `G28`-Befehl gefolgt von einem `ENDSTOP_PHASE_CALIBRATE`-Befehl aus. Bewegen Sie den Werkzeugkopf anschließend an eine neue Position und führen Sie `G28` erneut aus. Bewegen Sie den Werkzeugkopf an mehrere unterschiedliche Positionen und führen Sie `G28` jeweils erneut aus. Führen Sie mindestens fünf `G28`-Befehle aus.

Nach Durchführung des Obigen meldet der Befehl `ENDSTOP_PHASE_CALIBRATE` häufig dieselbe (oder nahezu dieselbe) Phase für den Schrittmotor. Diese Phase kann in der Konfigurationsdatei gespeichert werden, sodass alle künftigen G28-Befehle diese Phase verwenden. (So erhält Klipper bei künftigen Homing-Vorgängen dieselbe Position, selbst wenn der Endstop etwas früher oder etwas später auslöst.)

Um die Endstop-Phase für einen bestimmten Schrittmotor zu speichern, führen Sie etwa Folgendes aus:

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Führen Sie das oben Genannte für alle Schrittmotoren aus, die Sie speichern möchten. Üblicherweise wird dies bei kartesischen und CoreXY-Druckern für stepper_z verwendet, sowie bei Delta-Druckern für stepper_a, stepper_b und stepper_c. Führen Sie abschließend Folgendes aus, um die Konfigurationsdatei mit den Daten zu aktualisieren:

```
SAVE_CONFIG
```

### Zusätzliche Hinweise

* Diese Funktion ist besonders nützlich bei Delta-Druckern und beim Z-Endstop von kartesischen/CoreXY-Druckern. Sie kann auch bei den XY-Endstops kartesischer Drucker verwendet werden, ist dort jedoch wenig sinnvoll, da ein geringer Fehler in der X/Y-Endstop-Position die Druckqualität kaum beeinträchtigt. Bei den XY-Endstops von CoreXY-Druckern ist die Verwendung dieser Funktion nicht zulässig (da die XY-Position bei CoreXY-Kinematik nicht durch einen einzelnen Schrittmotor bestimmt wird). Ebenso ist die Verwendung dieser Funktion bei einem Drucker mit einem "probe:z_virtual_endstop"-Z-Endstop nicht zulässig (da die Schrittmotorphase nur stabil ist, wenn sich der Endstop an einer statischen Position auf einer Schiene befindet).
* Wird der Endstop nach der Kalibrierung der Endstop-Phase später bewegt oder angepasst, muss der Endstop neu kalibriert werden. Entfernen Sie die Kalibrierdaten aus der Konfigurationsdatei und wiederholen Sie die obigen Schritte.
* Um dieses System zu nutzen, muss der Endstop genau genug sein, um die Schrittmotorposition innerhalb von zwei "Vollschritten" zu identifizieren. Verwendet ein Schrittmotor beispielsweise 16 Mikroschritte mit einer Schrittweite von 0,005 mm, muss der Endstop eine Genauigkeit von mindestens 0,160 mm aufweisen. Erhalten Sie Fehlermeldungen der Art "Endstop stepper_z incorrect phase", kann dies an einem nicht ausreichend genauen Endstop liegen. Hilft eine erneute Kalibrierung nicht, deaktivieren Sie die Endstop-Phasenanpassung, indem Sie sie aus der Konfigurationsdatei entfernen.
* Wird eine herkömmlich mit Schrittmotor gesteuerte Z-Achse verwendet (wie bei kartesischen oder CoreXY-Druckern) zusammen mit herkömmlichen Bettnivellierschrauben, kann dieses System auch genutzt werden, um jede Druckschicht auf einer "Vollschritt"-Grenze auszuführen. Um diese Funktion zu aktivieren, stellen Sie sicher, dass der G-Code-Slicer mit einer Schichthöhe konfiguriert ist, die ein Vielfaches eines "Vollschritts" ist, aktivieren Sie manuell die Option endstop_align_zero im Konfigurationsabschnitt endstop_phase (weitere Details siehe [Konfigurationsreferenz](Config_Reference.md#endstop_phase)), und nivellieren Sie anschließend die Bettschrauben erneut.
* Dieses System kann auch mit herkömmlichen (nicht-Trinamic) Schrittmotortreibern verwendet werden. Dies erfordert jedoch, dass die Schrittmotortreiber jedes Mal zurückgesetzt werden, wenn der Mikrocontroller zurückgesetzt wird. (Werden beide stets gemeinsam zurückgesetzt, kann Klipper die Schrittmotorphase ermitteln, indem es die Gesamtzahl der angeforderten Schritte nachverfolgt.) Derzeit ist dies zuverlässig nur möglich, wenn sowohl Mikrocontroller als auch Schrittmotortreiber ausschließlich über USB mit Strom versorgt werden und diese USB-Stromversorgung von einem auf einem Raspberry Pi laufenden Host bereitgestellt wird. In diesem Fall kann in der MCU-Konfiguration "restart_method: rpi_usb" angegeben werden - diese Option sorgt dafür, dass der Mikrocontroller stets über einen USB-Stromreset zurückgesetzt wird, wodurch Mikrocontroller und Schrittmotortreiber gemeinsam zurückgesetzt werden. Bei Verwendung dieses Mechanismus müssen die Konfigurationsabschnitte "trigger_phase" manuell konfiguriert werden (Details siehe [Konfigurationsreferenz](Config_Reference.md#endstop_phase)).
