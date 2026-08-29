# TMC Treiber

Dieses Dokument enthält Informationen zur Verwendung von Trinamic-Schrittmotortreibern im SPI/UART-Modus auf Klipper.

Klipper kann die Trinamic-Treiber auch in ihrem "Standalone-Modus" verwenden. Wenn sich die Treiber jedoch in diesem Modus befinden, ist keine spezielle Klipper-Konfiguration erforderlich und die in diesem Dokument besprochenen erweiterten Klipper-Funktionen sind nicht verfügbar.

Zusätzlich zu diesem Dokument sollten Sie auch die [TMC driver config reference](Config_Reference.md#tmc-stepper-driver-configuration) lesen.

## Motorstrom abstimmen (Tunen)

Ein höherer Treiberstrom erhöht die Positioniergenauigkeit und das Drehmoment. Ein höherer Strom erhöht jedoch auch die vom Schrittmotor und dem Schrittmotortreiber erzeugte Wärme. Wenn der Schrittmotortreiber zu heiß wird, schaltet er sich ab und Klipper meldet einen Fehler. Wenn der Schrittmotor zu heiß wird, verliert er an Drehmoment und Positioniergenauigkeit. (Wenn er sehr heiß wird, kann er auch Kunststoffteile schmelzen, die an ihm oder in seiner Nähe angebracht sind.)

Als allgemeiner Tuning-Tipp sollten Sie höhere Stromwerte bevorzugen, solange der Schrittmotor nicht zu heiß wird und der Schrittmotortreiber keine Warnungen oder Fehler meldet. Im Allgemeinen ist es in Ordnung, wenn sich der Schrittmotor warm anfühlt, aber er sollte nicht so heiß werden, dass es schmerzhaft ist, ihn zu berühren.

## Vorzugsweise keinen Haltestrom angeben

Wird `hold_current` konfiguriert, kann der TMC-Treiber den Strom zum Schrittmotor reduzieren, sobald er erkennt, dass sich der Schrittmotor nicht bewegt. Eine Änderung des Motorstroms kann jedoch selbst eine Motorbewegung auslösen. Dies kann durch "Rastmomente" (Detent Forces) im Schrittmotor geschehen (der Permanentmagnet im Rotor wird zu den Eisenzähnen im Stator gezogen) oder durch externe Kräfte auf den Achsschlitten.

Bei den meisten Schrittmotoren bringt eine Stromreduzierung während normaler Drucke keinen nennenswerten Vorteil, da nur wenige Druckbewegungen einen Schrittmotor lange genug im Leerlauf lassen, um die `hold_current`-Funktion zu aktivieren. Zudem ist es unwahrscheinlich, dass man bei den wenigen Bewegungen, die einen Schrittmotor tatsächlich ausreichend lange im Leerlauf lassen, subtile Druckartefakte in Kauf nehmen möchte.

Möchten Sie den Motorstrom während der Druckstart-Routinen reduzieren, können Sie in einem [START_PRINT-Makro](Slicers.md#klipper-gcode_macro) [SET_TMC_CURRENT](G-Codes.md#set_tmc_current)-Befehle ausgeben, um den Strom vor und nach den normalen Druckbewegungen anzupassen.

Bei manchen Druckern mit dedizierten Z-Motoren, die während normaler Druckbewegungen im Leerlauf sind (kein bed_mesh, kein bed_tilt, keine Z-skew_correction, keine Drucke im "Vasenmodus" usw.), kann `hold_current` dazu führen, dass die Z-Motoren kühler laufen. Wird dies implementiert, sollte diese Art unkommandierter Z-Achsenbewegung während Bettnivellierung, Bettsondierung, Sondenkalibrierung und Ähnlichem berücksichtigt werden. Auch `driver_TPOWERDOWN` und `driver_IHOLDDELAY` sollten entsprechend kalibriert werden. Im Zweifelsfall sollte auf die Angabe von `hold_current` verzichtet werden.

## Einstellung "spreadCycle" vs "stealthChop" Modus

Standardmäßig setzt Klipper die TMC-Treiber in den "spreadCycle"-Modus. Wenn der Treiber "stealthChop" unterstützt, kann er durch Hinzufügen von `stealthchop_threshold: 999999`in den TMC-Konfigurationsabschnitt einfügt.

Im Allgemeinen bietet der spreadCycle-Modus ein höheres Drehmoment und eine höhere Positionsgenauigkeit als der stealthChop-Modus. Der stealthChop-Modus kann jedoch bei manchen Druckern zu einer deutlich geringeren Geräuschentwicklung führen.

Tests, die die Modi vergleichen, haben bei Bewegungen mit konstanter Geschwindigkeit im stealthChop-Modus einen erhöhten "Positionsverzug" von etwa 75% eines Vollschritts gezeigt (bei einem Drucker mit 40 mm rotation_distance und 200 steps_per_rotation erhöhte sich die Positionsabweichung bei Bewegungen mit konstanter Geschwindigkeit beispielsweise um ca. 0,150 mm). Diese "Verzögerung beim Erreichen der angeforderten Position" muss sich jedoch nicht als deutlicher Druckfehler bemerkbar machen, sodass das leisere Verhalten des stealthChop-Modus bevorzugt werden kann.

Es wird empfohlen, immer den "spreadCycle"-Modus zu verwenden (indem `stealthchop_threshold` nicht angegeben wird) oder immer den "stealthChop"-Modus (indem `stealthchop_threshold` auf 999999 gesetzt wird). Leider liefern die Treiber oft schlechte und verwirrende Ergebnisse, wenn sich der Modus ändert, während der Motor eine Geschwindigkeit ungleich Null hat.

Beachten Sie, dass die Konfigurationsoption `stealthchop_threshold` das sensorlose Homing nicht beeinflusst, da Klipper den TMC-Treiber während sensorloser Homing-Vorgänge automatisch in einen geeigneten Modus versetzt.

## Die TMC interpolate einstellung führt zu geringen Positionsabweichungen

Die `interpolate`-Einstellung des TMC-Treibers kann die Geräuschentwicklung der Druckerbewegung verringern, auf Kosten eines kleinen systematischen Positionsfehlers. Dieser systematische Positionsfehler entsteht durch die Verzögerung, mit der der Treiber die von Klipper gesendeten "Schritte" ausführt. Bei Bewegungen mit konstanter Geschwindigkeit führt diese Verzögerung zu einem Positionsfehler von nahezu einem halben konfigurierten Mikroschritt (genauer gesagt entspricht der Fehler einem halben Mikroschritt abzüglich eines 512tel eines Vollschritts). Bei einer Achse mit 40 mm rotation_distance, 200 steps_per_rotation und 16 Mikroschritten beträgt der bei Bewegungen mit konstanter Geschwindigkeit entstehende systematische Fehler beispielsweise ca. 0,006 mm.

Für die beste Positionsgenauigkeit sollten Sie den spreadCycle-Modus verwenden und die Interpolation deaktivieren (setzen Sie `interpolate: False` in der TMC-Treiberkonfiguration). Bei dieser Konfiguration kann die `microstep`-Einstellung erhöht werden, um die Geräuschentwicklung bei Schrittmotorbewegungen zu verringern. Üblicherweise erzeugt eine microstep-Einstellung von `64` oder `128` eine ähnlich geringe Geräuschentwicklung wie die Interpolation, jedoch ohne einen systematischen Positionsfehler zu verursachen.

Bei Verwendung des stealthChop-Modus ist die durch Interpolation verursachte Positionsungenauigkeit gering im Vergleich zur durch den stealthChop-Modus selbst verursachten Positionsungenauigkeit. Eine Anpassung der Interpolation gilt daher im stealthChop-Modus als nicht sinnvoll, und die Interpolation kann in ihrem Standardzustand belassen werden.

## Sensorloses Homing

Sensorloses Homing ermöglicht das Einrichten einer Achse ohne die Notwendigkeit eines physischen Endschalters. Stattdessen wird der Schlitten an der Achse in den mechanischen Anschlag bewegt, wodurch der Schrittmotor Schritte verliert. Der Schrittmotortreiber erfasst die verlorenen Schritte und gibt dies an die steuernde MCU (Klipper) weiter, indem er einen Pin umschaltet. Diese Informationen können von Klipper als Endanschlag für die Achse verwendet werden.

Dieser Leitfaden beschreibt die Einrichtung von sensorlosem Homing für die X-Achse Ihres (kartesischen) Druckers. Es funktioniert jedoch genauso mit allen anderen Achsen (die einen Endanschlag benötigen). Sie sollten es für eine Achse nach der anderen konfigurieren und abstimmen.

### Beschränkungen (Begriff bezieht sich auf Beschränkungen, Grenzen oder Einschränkungen)

Stellen Sie sicher, dass Ihre mechanischen Komponenten die Belastung aushalten können, wenn der Wagen wiederholt an die Grenze der Achse stößt. Insbesondere können Gewindestangen viel Kraft erzeugen. Es ist möglicherweise keine gute Idee, eine Z-Achse zu homen, indem die Düse gegen die Druckoberfläche stößt. Für beste Ergebnisse überprüfen Sie, ob der Achskarren fest mit der Achsgrenze in Kontakt kommen wird.

Darüber hinaus ist das sensorlose Homing möglicherweise nicht genau genug für Ihren Drucker. Während das Anfahren der X- und Y-Achsen auf einer kartesischen Maschine gut funktionieren kann, ist das Anfahren der Z-Achse im Allgemeinen nicht genau genug und kann zu einer inkonsistenten Höhe der ersten Schicht führen. Das sensorlose Homing eines Delta-Druckers ist aufgrund mangelnder Genauigkeit nicht ratsam.

Darüber hinaus hängt die Stalldetektion des Schrittmotortreibers von der mechanischen Last am Motor, dem Motorenstrom und der Motortemperatur (Spulenwiderstand) ab.

Sensorloses Homing funktioniert am besten bei mittleren Motorgeschwindigkeiten. Bei sehr langsamen Geschwindigkeiten (weniger als 10 U/min) erzeugt der Motor keine signifikante Gegen-EMK und die TMC kann Motorstillstände nicht zuverlässig erkennen. Darüber hinaus nähert sich bei sehr hohen Geschwindigkeiten die Gegen-EMK des Motors der Versorgungsspannung des Motors an, sodass die TMC keine Stillstände mehr erkennen kann. Es wird empfohlen, einen Blick in das Datenblatt Ihrer spezifischen TMCs zu werfen. Dort finden Sie auch weitere Details zu den Einschränkungen dieses Setups.

### Voraussetzungen

Einige Voraussetzungen sind erforderlich, um das sensorlose Homing zu verwenden:

1. Ein stallGuard-fähiger TMC-Schrittmachertreiber (tmc2130, tmc2209, tmc2660 oder tmc5160).
1. SPI / UART-Schnittstelle des TMC-Treibers mit Mikrocontroller verdrahtet (Stand-alone-Modus funktioniert nicht).
1. Der entsprechende "DIAG"- oder "SG_TST"-Pin des TMC-Treibers ist mit dem Mikrocontroller verbunden.
1. Die Schritte im Dokument [config checks](Config_checks.md) müssen ausgeführt werden, um sicherzustellen, dass die Schrittmotoren konfiguriert sind und ordnungsgemäß funktionieren.

### Abstimmung (Tuning)

Das hier beschriebene Verfahren umfasst sechs Hauptschritte:

1. Wählen Sie eine Referenzfahrtgeschwindigkeit.
1. Konfigurieren Sie die Datei `printer.cfg`, um die sensorlose Referenzfahrt zu aktivieren.
1. Finden Sie die Einstellung des Stallwächters mit der höchsten Empfindlichkeit, die erfolgreich zu Hause ist.
1. Finden Sie die Einstellung des Stallwächters mit der geringsten Empfindlichkeit, die mit einer einzigen Berührung zum Erfolg führt.
1. Aktualisieren Sie die Datei `printer.cfg` mit der gewünschten Stallguard-Einstellung.
1. Erstellen oder aktualisieren Sie Makros in der Datei `printer.cfg`, um sie konsistent zu verwenden.

#### Geschwindigkeit der Referenzfahrt wählen

Die Referenzfahrtgeschwindigkeit ist ein wichtiger Faktor bei der sensorlosen Referenzfahrt. Es ist wünschenswert, eine langsame Referenzfahrtgeschwindigkeit zu verwenden, damit der Wagen keine übermäßige Kraft auf den Rahmen ausübt, wenn er das Ende der Schiene berührt. Allerdings können die TMC-Treiber bei sehr langsamen Geschwindigkeiten einen Strömungsabriss nicht zuverlässig erkennen.

Ein guter Ausgangspunkt für die Referenzfahrtgeschwindigkeit ist, dass der Schrittmotor alle zwei Sekunden eine volle Umdrehung macht. Bei vielen Achsen ist dies der `Rotation_distance` geteilt durch zwei. Zum Beispiel:

```
[stepper_x]
rotation_distance: 40
homing_speed:20
in English schrreiben
```

#### Konfigurieren sie die printer.cfg für die sensorlose Referenzfahrt

Die Einstellung `homing_retract_dist` muss im Konfigurationsabschnitt `stepper_x` auf Null gesetzt werden, um die zweite Referenzfahrt zu deaktivieren. Der zweite Referenzfahrtversuch ist bei sensorloser Referenzfahrt nicht sinnvoll, funktioniert nicht zuverlässig und verwirrt den Abstimmungsprozess.

Vergewissern Sie sich, dass in der TMC-Treiber-Sektion der Konfiguration keine `hold_current`-Einstellung angegeben ist (wenn eine hold_current-Einstellung vorgenommen wird, stoppt der Motor, nachdem der Kontakt hergestellt wurde, während der Schlitten gegen das Ende der Schiene gedrückt wird, und eine Reduzierung des Stroms in dieser Position kann dazu führen, dass sich der Schlitten bewegt - das führt zu einer schlechten Leistung und verwirrt den Abstimmungsprozess.)

Es ist notwendig, die Pins für die sensorlose Referenzfahrt zu konfigurieren und die anfänglichen "stallguard"-Einstellungen zu konfigurieren. Eine tmc2209 Beispielkonfiguration für eine X-Achse könnte wie folgt aussehen:

```
[tmc2209 stepper_x]
diag_pin: ^PA1 # Einstellung auf MCU-Pin, der mit dem TMC DIAG-Pin verbunden ist
driver_SGTHRS: 255 # 255 ist der empfindlichste Wert, 0 der am wenigsten empfindliche
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Eine tmc2130- oder tmc5160-Konfiguration könnte beispielsweise so aussehen:

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # Pin verbunden mit TMC DIAG1 Pin (oder diag0_pin / DIAG0 Pin verwenden)
driver_SGT: -64 # -64 ist der empfindlichste Wert, 63 der unempfindlichste
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Eine Beispielkonfiguration des tmc2660 könnte wie folgt aussehen:

```
[tmc2660 stepper_x]
driver_SGT: -64 # -64 ist der empfindlichste Wert, 63 ist am wenigsten empfindlich
...

[stepper_x]
endstop_pin: ^PA1 # Pin verbunden mit TMC SG_TST Pin
homing_retract_dist: 0
...
```

Die obigen Beispiele zeigen nur die Einstellungen für die sensorlose Referenzfahrt. Siehe die [config reference](Config_Reference.md#tmc-stepper-driver-configuration) für alle verfügbaren Optionen.

#### Finden Sie die höchste Empfindlichkeit, für eine erfolgreiche Referenzfahrt

Platzieren Sie den Schlitten in der Nähe der Mitte der Schiene. Verwenden Sie den Befehl SET_TMC_FIELD, um die höchste Empfindlichkeit einzustellen. Für tmc2209:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

Für tmc2130, tmc5160, und tmc2660:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

Geben Sie anschließend einen Befehl `G28 X0` aus und prüfen Sie, dass sich die Achse überhaupt nicht bewegt oder schnell zum Stillstand kommt. Stoppt die Achse nicht, geben Sie ein `M112` aus, um den Drucker anzuhalten - dann stimmt etwas mit der Verkabelung oder Konfiguration des diag/sg_tst-Pins nicht, und dies muss vor dem Fortfahren korrigiert werden.

Verringern Sie dann kontinuierlich die Empfindlichkeit der `VALUE` Einstellung und führen Sie die `SET_TMC_FIELD` `G28 X0`-Befehle erneut aus, um die höchste Empfindlichkeit zu finden, die dazu führt, dass der Schlitten erfolgreich bis zum Endanschlag fährt und anhält. (Bei tmc2209-Treibern ist dies die Verringerung von SGTHRS, bei anderen Treibern die Erhöhung von sgt). Stellen Sie sicher, dass Sie jeden Versuch mit dem Wagen in der Nähe der Mitte der Schiene beginnen (geben Sie bei Bedarf `M84` aus und bewegen Sie den Wagen dann manuell in die Mitte). Es sollte möglich sein, die höchste Empfindlichkeit zu finden, die zuverlässig funktioniert (Einstellungen mit höherer Empfindlichkeit führen zu geringer oder keiner Bewegung). Notieren Sie den gefundenen Wert als *maximum_sensitivity*. (Wenn die kleinstmögliche Empfindlichkeit (SGTHRS=0 oder sgt=63) erreicht wird, ohne dass sich der Schlitten bewegt, stimmt etwas mit der Verdrahtung oder Konfiguration des diag/sg_tst-Pins nicht und muss korrigiert werden, bevor Sie fortfahren.)

Bei der Suche nach der maximalen Empfindlichkeit kann es sinnvoll sein, zu verschiedenen VALUE-Einstellungen zu springen (um den VALUE-Parameter zu halbieren). Wenn Sie dies tun, sollten Sie darauf vorbereitet sein, einen `M112`Befehl zu erteilen, um den Drucker anzuhalten, da eine Einstellung mit einer sehr niedrigen Empfindlichkeit dazu führen kann, dass die Achse wiederholt gegen das Ende der Schiene "knallt".

Achten Sie darauf, dass Sie zwischen den einzelnen Referenzfahrtversuchen ein paar Sekunden warten. Nachdem der TMC-Treiber einen Strömungsabriss erkannt hat, kann es einige Zeit dauern, bis er seine interne Anzeige löscht und in der Lage ist, einen weiteren Strömungsabriss zu erkennen.

Wenn während dieser Abstimmungstests ein `G28 X0`-Befehl nicht bis zur Achsengrenze fährt, dann seien Sie vorsichtig mit der Ausgabe von regulären Fahrbefehlen (z.B. `G1`). Klipper kann die Position des Schlittens nicht richtig einschätzen und ein Fahrbefehl kann zu unerwünschten und verwirrenden Ergebnissen führen.

#### Finden Sie die niedrigste Empfindlichkeit, für die Home Berührung

Bei der Referenzfahrt mit dem gefundenen Wert *maximum_sensitivity* sollte sich die Achse bis zum Ende der Schiene bewegen und mit einer "einzigen Berührung" stoppen - das heißt, es sollte kein "Klicken" oder "Knallen" zu hören sein. (Wenn bei maximaler_Empfindlichkeit ein Knall- oder Klickgeräusch zu hören ist, ist die Referenzfahrtgeschwindigkeit möglicherweise zu niedrig, der Treiberstrom zu gering oder die sensorlose Referenzfahrt ist keine gute Wahl für die Achse.)

Der nächste Schritt besteht darin, den Schlitten wieder kontinuierlich in eine Position nahe der Mitte der Schiene zu bewegen, die Empfindlichkeit zu verringern und die Befehle `SET_TMC_FIELD` `G28 X0` auszuführen - das Ziel ist nun, die niedrigste Empfindlichkeit zu finden, die immer noch dazu führt, dass der Schlitten mit einer "einzigen Berührung" erfolgreich referenziert. Das heißt, er "knallt" oder "klickt" nicht, wenn er das Ende der Schiene berührt. Notieren Sie den gefundenen Wert als *minimum_sensitivity*.

#### printer.cfg mit Empfindlichkeitswert aktualisieren

Nachdem Sie *maximale_Empfindlichkeit* und *minimale_Empfindlichkeit* ermittelt haben, verwenden Sie einen Taschenrechner, um die empfohlene Empfindlichkeit als *minimale_Empfindlichkeit + (maximale_Empfindlichkeit - minimale_Empfindlichkeit)/3* zu berechnen. Die empfohlene Empfindlichkeit sollte im Bereich zwischen dem Minimum und dem Maximum liegen, aber etwas näher am Minimum. Runden Sie den endgültigen Wert auf den nächsten ganzzahligen Wert.

Für tmc2209 setzen Sie dies in der Konfiguration als `driver_SGTHRS`, für andere TMC-Treiber setzen Sie dies in der Konfiguration als `driver_SGT`.

Wenn der Bereich zwischen *maximum_sensitivity* und *minimum_sensitivity* klein ist (z. B. weniger als 5), kann dies zu einer instabilen Referenzfahrt führen. Eine schnellere Referenzfahrtgeschwindigkeit kann den Bereich vergrößern und den Betrieb stabiler machen.

Beachten Sie, dass bei Änderungen des Treiberstroms, der Referenzfahrtgeschwindigkeit oder bei wesentlichen Änderungen an der Druckerhardware der Abstimmungsprozess erneut durchgeführt werden muss.

#### Verwenden sie Macros für die Referenzfahrt

Nach Abschluss der sensorlosen Referenzfahrt wird der Schlitten gegen das Ende der Schiene gedrückt und der Stepper übt eine Kraft auf den Rahmen aus, bis der Schlitten weggefahren ist. Es ist eine gute Idee, ein Makro zu erstellen, um die Achse zu referenzieren und den Schlitten sofort vom Ende der Schiene weg zu bewegen.

Es ist ratsam, dass das Makro vor dem Start der sensorlosen Referenzfahrt mindestens 2 Sekunden pausiert (oder auf andere Weise sicherstellt, dass der Stepper 2 Sekunden lang nicht bewegt wurde). Ohne eine Verzögerung ist es möglich, dass das interne "stall"-Flag des Treibers noch von einer vorherigen Bewegung gesetzt ist.

Es kann außerdem nützlich sein, in diesem Makro den Treiberstrom vor dem Homing zu setzen und nach dem Wegfahren des Schlittens einen neuen Strom festzulegen.

Ein Beispielmakro könnte so aussehen:

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # Set current for sensorless homing
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # Pause to ensure driver stall flag is clear
    G4 P2000
    # Home
    G28 X0
    # Move away
    G90
    G1 X5 F1200
    # Set current during print
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

Das resultierende Makro kann von einem [homing_override config section](Config_Reference.md#homing_override) oder von einem [START_PRINT macro](Slicers.md#klipper-gcode_macro) aufgerufen werden.

Wenn der Treiberstrom während der Referenzfahrt geändert wird, sollte der Abstimmungsprozess erneut durchgeführt werden.

### Tipps zur sensorlosen Referenzfahrt mit CoreXY

Es ist möglich, die sensorlose Referenzfahrt auf den X- und Y-Schlitten eines CoreXY-Druckers zu verwenden. Klipper verwendet den `[stepper_x]` Stepper, um bei der Referenzfahrt des X-Schlittens einen Stillstand zu erkennen, und den `[stepper_y]` Stepper, um bei der Referenzfahrt des Y-Schlittens einen Stillstand zu erkennen.

Verwenden Sie die oben beschriebene Abstimmungsanleitung, um die geeignete "Überzieh-Empfindlichkeit" für jeden Wagen zu finden, aber beachten Sie die folgenden Einschränkungen:

1. Bei Verwendung von sensorlosen Homing auf CoreXY, stellen Sie sicher, dass kein `hold_current` für die Stepper konfiguriert wurde.
1. Vergewissern Sie sich bei der Einstellung, dass sich sowohl der X- als auch der Y-Wagen vor jedem Startversuch in der Mitte ihrer Schienen befinden.
1. Verwenden Sie nach Abschluss der Abstimmung bei der Referenzfahrt von X und Y Makros, um sicherzustellen, dass zuerst eine Achse referenziert wird, bewegen Sie dann diesen Schlitten von der Achsengrenze weg, halten Sie mindestens 2 Sekunden lang inne und starten Sie dann die Referenzfahrt des anderen Schlittens. Durch die Bewegung von der Achse weg wird vermieden, dass eine Achse referenziert wird, während die andere gegen die Achsengrenze gedrückt wird (was die Erkennung des Stillstands verfälschen könnte). Die Pause ist notwendig, um sicherzustellen, dass das Blockierflag des Fahrers vor der erneuten Referenzfahrt gelöscht wird.

Ein CoreXY Homing-Makro könnte beispielsweise so aussehen:

```
[gcode_macro HOME]
gcode:
    G90
    # Home Z
    G28 Z0
    G1 Z10 F1200
    # Home Y
    G28 Y0
    G1 Y5 F1200
    # Home X
    G4 P2000
    G28 X0
    G1 X5 F1200
```

## Abfrage und Diagnose der Treibereinstellungen

Der Befehl [DUMP_TMC](G-Codes.md#dump_tmc) ist ein nützliches Werkzeug bei der Konfiguration und Diagnose der Treiber. Er meldet alle von Klipper konfigurierten Felder sowie alle Felder, die vom Treiber abgefragt werden können.

Alle angegebenen Felder sind im Trinamic-Datenblatt für jeden Treiber definiert. Diese Datenblätter finden Sie auf der [Trinamic-Website](https://www.trinamic.com/). Besorgen Sie sich das Trinamic Datenblatt für den Treiber und prüfen Sie es, um die Ergebnisse von DUMP_TMC zu interpretieren.

## Konfigurieren der Einstellungen von driver_XXX

Klipper unterstützt die Konfiguration vieler Low-Level-Treiberfelder mit `driver_XXX` Einstellungen. Die [TMC driver config reference](Config_Reference.md#tmc-stepper-driver-configuration) enthält die vollständige Liste der Felder, die für jede Art von Treiber verfügbar sind.

Zudem lassen sich fast alle Felder zur Laufzeit mit dem Befehl [SET_TMC_FIELD](G-Codes.md#set_tmc_field) ändern.

Jedes dieser Felder ist im Trinamic Datenblatt für jeden Treiber definiert. Diese Datenblätter finden Sie auf der [Trinamic website](https://www.trinamic.com/).

Beachten Sie, dass in den Datenblättern von Trinamic manchmal Formulierungen verwendet werden, die eine High-Level-Einstellung (z. B. "Hysteresis End") mit einem Low-Level-Feldwert (z. B. "HEND") verwechseln können. In Klipper setzen `driver_XXX` und SET_TMC_FIELD immer den Low-Level-Feldwert, der tatsächlich in den Treiber geschrieben wird. Wenn also zum Beispiel das Trinamic-Datenblatt besagt, dass ein Wert von 3 in das HEND-Feld geschrieben werden muss, um ein "Hysterese-Ende" von 0 zu erhalten, dann setzen Sie `driver_HEND=3`, um den High-Level-Wert von 0 zu erhalten.

## Allgemeine Fragen

### Kann ich den stealthChop-Modus bei einem Extruder mit Druckvorschub(PA) verwenden?

Viele Leute verwenden erfolgreich den "stealthChop"-Modus mit dem Druckvorschub(PA) von Klipper. Klipper implementiert [smooth pressure advance](Kinematics.md#pressure-advance), was keine momentanen Geschwindigkeitsänderungen mit sich bringt.

Der "stealthChop"-Modus kann jedoch ein geringeres Motordrehmoment und/oder eine höhere Motorwärme erzeugen. Dieser Modus kann für Ihren speziellen Drucker geeignet sein, muss es aber nicht.

### Ich erhalte ständig die Fehlermeldung "Unable to read tmc uart 'stepper_x' register IFCNT"?

Dies tritt auf, wenn Klipper nicht in der Lage ist, mit einem tmc2208 oder tmc2209 Treiber zu kommunizieren.

Vergewissern Sie sich, dass die Motorspannung eingeschaltet ist, da der Schrittmotortreiber in der Regel Motorspannung benötigt, bevor er mit dem Mikrocontroller kommunizieren kann.

Wenn dieser Fehler nach dem ersten Flashen von Klipper auftritt, kann es sein, dass der Steppertreiber zuvor in einem Zustand programmiert wurde, der nicht mit Klipper kompatibel ist. Um den Status zurückzusetzen, trennen Sie den Drucker für einige Sekunden von der Stromversorgung (ziehen Sie sowohl den USB- als auch den Netzstecker).

Andernfalls ist dieser Fehler typischerweise das Ergebnis einer falschen UART-Pin-Verdrahtung oder einer falschen Klipper-Konfiguration der UART-Pin-Einstellungen.

### Andernfalls ist dieser Fehler typischerweise das Ergebnis einer falschen UART-Pin-Verkabelung oder einer falschen Klipper-Konfiguration der UART-Pin-Einstellungen.I keep getting "Unable to write tmc spi 'stepper_x' register ..." errors?

Dies tritt auf, wenn Klipper nicht mit einem tmc2130 oder tmc5160 Treiber kommunizieren kann.

Vergewissern Sie sich, dass die Motorspannung eingeschaltet ist, da der Schrittmotortreiber in der Regel Motorspannung benötigt, bevor er mit dem Mikrocontroller kommunizieren kann.

Andernfalls ist dieser Fehler typischerweise das Ergebnis einer falschen SPI-Verdrahtung, einer falschen Klipper-Konfiguration der SPI-Einstellungen oder einer unvollständigen Konfiguration von Geräten auf einem SPI-Bus.

Beachten Sie, dass, wenn der Treiber auf einem gemeinsamen SPI-Bus mit mehreren Geräten ist, stellen Sie sicher, dass Sie jedes Gerät auf diesem gemeinsamen SPI-Bus in Klipper vollständig konfigurieren. Wenn ein Gerät auf einem gemeinsam genutzten SPI-Bus nicht konfiguriert ist, kann es fälschlicherweise auf Befehle reagieren, die nicht für es bestimmt sind, und die Kommunikation mit dem vorgesehenen Gerät stören. Wenn es ein Gerät auf einem gemeinsamen SPI-Bus gibt, das nicht in Klipper konfiguriert werden kann, dann verwenden Sie einen [static_digital_output config section](Config_Reference.md#static_digital_output), um den CS-Pin des unbenutzten Geräts auf High zu setzen (so dass es nicht versucht, den SPI-Bus zu benutzen). Der Schaltplan des Boards ist oft eine nützliche Referenz, um herauszufinden, welche Geräte an einem SPI-Bus angeschlossen sind und welche Pins ihnen zugeordnet sind.

### Warum erhielt ich die Fehlermeldung "TMC meldet Fehler: ..."?

Diese Art von Fehler zeigt an, dass der TMC-Treiber ein Problem erkannt und sich selbst deaktiviert hat. Das heißt, der Treiber hat aufgehört, seine Position zu halten und ignoriert Bewegungsbefehle. Wenn Klipper feststellt, dass ein aktiver Treiber sich selbst deaktiviert hat, wird der Drucker in einen "Shutdown"-Zustand versetzt.

Es ist auch möglich, dass ein **TMC meldet Fehler** Shutdown aufgrund von SPI-Fehlern auftritt, welche die Kommunikation mit dem Treiber verhindern oder Stöhren (bei tmc2130, tmc5160 oder tmc2660). Wenn dies geschieht, zeigt der gemeldete Treiberstatus üblicherweise `00000000` oder `ffffffff` zum Beispiel: `TMC reports error: DRV_STATUS: ffffffff ...` ODER `TMC meldet Fehler: READRSP@RDSEL2: 00000000 ...`. Ein solcher Fehler kann auf ein SPI Verdrahtungsproblem, auf einen Selbst Reset oder einen Fehler des TMC Treibers zurückzuführen sein.

Einige häufige Fehler und Tipps zu deren Diagnose:

#### TMC meldet Fehler: `... ot=1(OvertempError!)`

Dies bedeutet, dass sich der Motortreiber selbst deaktiviert hat, weil er zu heiß geworden ist. Typische Lösungen sind die Verringerung des Schrittmotorstroms, die Erhöhung der Kühlung des Schrittmotortreibers und/oder die Erhöhung der Kühlung des Schrittmotors.

#### TMC meldet Fehler: `... ShortToGND` ODER `ShortToSupply`

Dies bedeutet, dass der Treiber sich selbst deaktiviert hat, weil er einen sehr hohen Stromfluss durch den Treiber festgestellt hat. Dies kann auf ein loses oder kurzgeschlossenes Kabel zum Schrittmotor oder im Schrittmotor selbst hinweisen.

Dieser Fehler kann auch auftreten, wenn Sie den StealthChop-Modus verwenden und der TMC-Treiber die mechanische Belastung des Motors nicht genau vorhersagen kann. (Wenn der Treiber eine schlechte Vorhersage macht, kann er zu viel Strom durch den Motor schicken und seine eigene Überstromerkennung auslösen.) Um dies zu testen, deaktivieren Sie den StealthChop-Modus und prüfen Sie, ob die Fehler weiterhin auftreten.

#### TMC meldet Fehler: `... reset=1(Reset)` ODER `CS_ACTUAL=0(Reset?)` ODER `SE=0(Reset?)`

Dies bedeutet, dass sich der Treiber mitten im Druckvorgang zurückgesetzt hat. Dies kann auf Spannungs- oder Verdrahtungsprobleme zurückzuführen sein.

#### TMC meldet Fehler: `... uv_cp=1(Unterspannung!)`

Dies zeigt an, dass der Treiber ein Unterspannungsereignis erkannt und sich selbst deaktiviert hat. Dies kann auf Verdrahtungs- oder Stromversorgungsprobleme zurückzuführen sein.

### Wie stelle ich den spreadCycle/coolStep/etc.-Modus für meine Treiber ein?

Auf der [Trinamic-Website](https://www.trinamic.com/) finden Sie Anleitungen zur Konfiguration der Treiber. Diese Anleitungen sind oft technisch anspruchsvoll und können spezielle Hardware erfordern. Unabhängig davon sind sie die beste Informationsquelle.
