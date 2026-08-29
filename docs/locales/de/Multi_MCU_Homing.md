# Homing und Probing mit mehreren Mikrocontrollern

Klipper unterstützt einen Mechanismus für das Homen mit einem Endstopp, welcher an einen Mikrocontroller angeschlossen ist, während die Steppermotoren an einen anderen Mikrocontroller angeschlossen sind. Diese Unterstützung wird "multi-mcu homing" genannt. Dieses Feature wird ebenfalls benutzt, wenn eine Z-Sonde an einem anderen Mikrocontroller angeschlossen ist, als die dazugehörigen Z-Steppermotoren.

Dieses Feature kann zur Vereinfachung der Verkabelung nützlich sein, da es einfacher sein könnte, einen Endstopp oder eine Sonde an einen näheren Mikrocontroller anzuschließen. Dieses Feature kann allerdings zum "overshoot" der Steppermotoren beim Homing und Probing führen.

Der "overshoot" wird ausgelöst durch die eventuelle Verzögerung der Nachrichtenübertragung zwischen dem überwachenden Mikrocontroller und dem Mikrocontroller, welcher die Steppermotoren antreibt. Der Klipper-Code ist so entworfen, dass diese Verzögerung auf maximal 25ms reduziert wird. (Wenn Multi-MCU Homing aktiviert ist, sendet der Mikrocontroller periodische Statusnachrichten und prüft, dass diese innerhalb von 25ms empfangen werden.)

Wird beispielsweise mit 10 mm/s gehomt, ist ein Überschwingen von bis zu 0,250 mm möglich (10 mm/s * 0,025 s == 0,250 mm). Bei der Konfiguration von Multi-MCU-Homing sollte diese Art von Überschwingen berücksichtigt werden. Langsamere Homing- oder Sondiergeschwindigkeiten können das Überschwingen verringern.

Ein Überschwingen des Schrittmotors sollte die Präzision des Homing- und Sondiervorgangs nicht beeinträchtigen. Der Klipper-Code erkennt das Überschwingen und berücksichtigt es in seinen Berechnungen. Es ist jedoch wichtig, dass das Hardware-Design in der Lage ist, ein Überschwingen zu bewältigen, ohne die Maschine zu beschädigen.

Um diese Funktion des "Multi-MCU-Homings" nutzen zu können, muss die Hardware eine verlässlich niedrige Latenz zwischen dem Host-Computer und allen Mikrocontrollern aufweisen. Üblicherweise muss die Round-Trip-Zeit durchgehend unter 10 ms liegen. Eine hohe Latenz (selbst für kurze Zeiträume) führt wahrscheinlich zu Homing-Fehlern.

Sollte die hohe Latenzzeit zu einem Fehler führen (oder wenn ein anderes Kommunikationsproblem festgestellt wird), wird Klipper einen Fehler "Communication timeout during homing" melden.

Beachten Sie, dass eine Achse mit mehreren Schrittmotoren (z. B. `stepper_z` und `stepper_z1`) sich auf demselben Mikrocontroller befinden muss, um Multi-MCU-Homing verwenden zu können. Befindet sich ein Endstop beispielsweise auf einem anderen Mikrocontroller als `stepper_z`, muss `stepper_z1` auf demselben Mikrocontroller wie `stepper_z` sein.
