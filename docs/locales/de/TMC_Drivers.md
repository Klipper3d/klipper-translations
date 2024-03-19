# TMC Treiber

Dieses Dokument enthält Informationen zur Verwendung von Trinamic-Schrittmotortreibern im SPI/UART-Modus auf Klipper.

Klipper kann die Trinamic-Treiber auch in ihrem "Standalone-Modus" verwenden. Wenn sich die Treiber jedoch in diesem Modus befinden, ist keine spezielle Klipper-Konfiguration erforderlich und die in diesem Dokument besprochenen erweiterten Klipper-Funktionen sind nicht verfügbar.

Neben diesem Dokument sollten Sie sich die [TMC-Treiberkonfigurationsreferenz](Config_Reference.md#tmc-stepper-driver-configuration) ansehen.

## Motorstrom abstimmen (Tunen)

Ein höherer Treiberstrom erhöht die Positioniergenauigkeit und das Drehmoment. Ein höherer Strom erhöht jedoch auch die vom Schrittmotor und dem Schrittmotortreiber erzeugte Wärme. Wenn der Schrittmotortreiber zu heiß wird, schaltet er sich ab und Klipper meldet einen Fehler. Wenn der Schrittmotor zu heiß wird, verliert er an Drehmoment und Positioniergenauigkeit. (Wenn er sehr heiß wird, kann er auch Kunststoffteile schmelzen, die an ihm oder in seiner Nähe angebracht sind.)

Als allgemeiner Tuning-Tipp sollten Sie höhere Stromwerte bevorzugen, solange der Schrittmotor nicht zu heiß wird und der Schrittmotortreiber keine Warnungen oder Fehler meldet. Im Allgemeinen ist es in Ordnung, wenn sich der Schrittmotor warm anfühlt, aber er sollte nicht so heiß werden, dass es schmerzhaft ist, ihn zu berühren.

## Vorzugsweise keinen Haltestrom angeben

If one configures a `hold_current` then the TMC driver can reduce current to the stepper motor when it detects that the stepper is not moving. However, changing motor current may itself introduce motor movement. This may occur due to "detent forces" within the stepper motor (the permanent magnet in the rotor pulls towards the iron teeth in the stator) or due to external forces on the axis carriage.

Most stepper motors will not obtain a significant benefit to reducing current during normal prints, because few printing moves will leave a stepper motor idle for sufficiently long to activate the `hold_current` feature. And, it is unlikely that one would want to introduce subtle print artifacts to the few printing moves that do leave a stepper idle sufficiently long.

If one wishes to reduce current to motors during print start routines, then consider issuing [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) commands in a [START_PRINT macro](Slicers.md#klipper-gcode_macro) to adjust the current before and after normal printing moves.

Some printers with dedicated Z motors that are idle during normal printing moves (no bed_mesh, no bed_tilt, no Z skew_correction, no "vase mode" prints, etc.) may find that Z motors do run cooler with a `hold_current`. If implementing this then be sure to take into account this type of uncommanded Z axis movement during bed leveling, bed probing, probe calibration, and similar. The `driver_TPOWERDOWN` and `driver_IHOLDDELAY` should also be calibrated accordingly. If unsure, prefer to not specify a `hold_current`.

## Setting "spreadCycle" vs "stealthChop" Mode

Standardmäßig setzt Klipper die TMC-Treiber in den "spreadCycle"-Modus. Wenn der Treiber "stealthChop" unterstützt, kann er durch Hinzufügen von `stealthchop_threshold: 999999`in den TMC-Konfigurationsabschnitt einfügt.

In general, spreadCycle mode provides greater torque and greater positional accuracy than stealthChop mode. However, stealthChop mode may produce significantly lower audible noise on some printers.

Tests comparing modes have shown an increased "positional lag" of around 75% of a full-step during constant velocity moves when using stealthChop mode (for example, on a printer with 40mm rotation_distance and 200 steps_per_rotation, position deviation of constant speed moves increased by ~0.150mm). However, this "delay in obtaining the requested position" may not manifest as a significant print defect and one may prefer the quieter behavior of stealthChop mode.

Es wird empfohlen, immer den "spreadCycle"-Modus zu verwenden (indem `stealthchop_threshold` nicht angegeben wird) oder immer den "stealthChop"-Modus (indem `stealthchop_threshold` auf 999999 gesetzt wird). Leider liefern die Treiber oft schlechte und verwirrende Ergebnisse, wenn sich der Modus ändert, während der Motor eine Geschwindigkeit ungleich Null hat.

## TMC interpolate setting introduces small position deviation

The TMC driver `interpolate` setting may reduce the audible noise of printer movement at the cost of introducing a small systemic positional error. This systemic positional error results from the driver's delay in executing "steps" that Klipper sends it. During constant velocity moves, this delay results in a positional error of nearly half a configured microstep (more precisely, the error is half a microstep distance minus a 512th of a full step distance). For example, on an axis with a 40mm rotation_distance, 200 steps_per_rotation, and 16 microsteps, the systemic error introduced during constant velocity moves is ~0.006mm.

For best positional accuracy consider using spreadCycle mode and disable interpolation (set `interpolate: False` in the TMC driver config). When configured this way, one may increase the `microstep` setting to reduce audible noise during stepper movement. Typically, a microstep setting of `64` or `128` will have similar audible noise as interpolation, and do so without introducing a systemic positional error.

If using stealthChop mode then the positional inaccuracy from interpolation is small relative to the positional inaccuracy introduced from stealthChop mode. Therefore tuning interpolation is not considered useful when in stealthChop mode, and one can leave interpolation in its default state.

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

Vergewissern Sie sich, dass in der TMC-Treiber-Sektion der Konfiguration keine `hold_current`-Einstellung angegeben ist (wenn eine hold_current-Einstellung vorgenommen wird, stoppt der Motor, nachdem der Kontakt hergestellt wurde, während der Schlitten gegen das Ende der Schiene gedrückt wird, und eine Reduzierung des Stroms in dieser Position kann dazu führen, dass sich der Schlitten bewegt - das führt zu einer schlechten Leistung und verwirrt den Abstimmungsprozess).

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

Then issue a `G28 X0` command and verify the axis does not move at all or quickly stops moving. If the axis does not stop, then issue an `M112` to halt the printer - something is not correct with the diag/sg_tst pin wiring or configuration and it must be corrected before continuing.

Verringern Sie dann kontinuierlich die Empfindlichkeit der `VALUE` Einstellung und führen Sie die `SET_TMC_FIELD` `G28 X0`-Befehle erneut aus, um die höchste Empfindlichkeit zu finden, die dazu führt, dass der Schlitten erfolgreich bis zum Endanschlag fährt und anhält. (Bei tmc2209-Treibern ist dies die Verringerung von SGTHRS, bei anderen Treibern die Erhöhung von sgt). Stellen Sie sicher, dass Sie jeden Versuch mit dem Wagen in der Nähe der Mitte der Schiene beginnen (geben Sie bei Bedarf `M84` aus und bewegen Sie den Wagen dann manuell in die Mitte). Es sollte möglich sein, die höchste Empfindlichkeit zu finden, die zuverlässig funktioniert (Einstellungen mit höherer Empfindlichkeit führen zu geringer oder keiner Bewegung). Notieren Sie den gefundenen Wert als *maximum_sensitivity*. (Wenn die kleinstmögliche Empfindlichkeit (SGTHRS=0 oder sgt=63) erreicht wird, ohne dass sich der Schlitten bewegt, stimmt etwas mit der Verdrahtung oder Konfiguration des diag/sg_tst-Pins nicht und muss korrigiert werden, bevor Sie fortfahren).

Bei der Suche nach der maximalen Empfindlichkeit kann es sinnvoll sein, zu verschiedenen VALUE-Einstellungen zu springen (um den VALUE-Parameter zu halbieren). Wenn Sie dies tun, sollten Sie darauf vorbereitet sein, einen `M112`Befehl zu erteilen, um den Drucker anzuhalten, da eine Einstellung mit einer sehr niedrigen Empfindlichkeit dazu führen kann, dass die Achse wiederholt gegen das Ende der Schiene "knallt".

Achten Sie darauf, dass Sie zwischen den einzelnen Referenzfahrtversuchen ein paar Sekunden warten. Nachdem der TMC-Treiber einen Strömungsabriss erkannt hat, kann es einige Zeit dauern, bis er seine interne Anzeige löscht und in der Lage ist, einen weiteren Strömungsabriss zu erkennen.

Wenn während dieser Abstimmungstests ein `G28 X0`-Befehl nicht bis zur Achsengrenze fährt, dann seien Sie vorsichtig mit der Ausgabe von regulären Fahrbefehlen (z.B. `G1`). Klipper kann die Position des Schlittens nicht richtig einschätzen und ein Fahrbefehl kann zu unerwünschten und verwirrenden Ergebnissen führen.

#### Finden Sie die niedrigste Empfindlichkeit, für die Home Berührung

Bei der Referenzfahrt mit dem gefundenen Wert *maximum_sensitivity* sollte sich die Achse bis zum Ende der Schiene bewegen und mit einer "einzigen Berührung" stoppen - das heißt, es sollte kein "Klicken" oder "Knallen" zu hören sein. (Wenn bei maximaler_Empfindlichkeit ein Knall- oder Klickgeräusch zu hören ist, ist die Referenzfahrtgeschwindigkeit möglicherweise zu niedrig, der Treiberstrom zu gering oder die sensorlose Referenzfahrt ist keine gute Wahl für die Achse).

Der nächste Schritt besteht darin, den Schlitten wieder kontinuierlich in eine Position nahe der Mitte der Schiene zu bewegen, die Empfindlichkeit zu verringern und die Befehle `SET_TMC_FIELD` `G28 X0` auszuführen - das Ziel ist nun, die niedrigste Empfindlichkeit zu finden, die immer noch dazu führt, dass der Schlitten mit einer "einzigen Berührung" erfolgreich referenziert. Das heißt, er "knallt" oder "klickt" nicht, wenn er das Ende der Schiene berührt. Notieren Sie den gefundenen Wert als *minimum_sensitivity*.

#### printer.cfg mit Empfindlichkeitswert aktualisieren

Nachdem Sie *maximale_Empfindlichkeit* und *minimale_Empfindlichkeit* ermittelt haben, verwenden Sie einen Taschenrechner, um die empfohlene Empfindlichkeit als *minimale_Empfindlichkeit + (maximale_Empfindlichkeit - minimale_Empfindlichkeit)/3* zu berechnen. Die empfohlene Empfindlichkeit sollte im Bereich zwischen dem Minimum und dem Maximum liegen, aber etwas näher am Minimum. Runden Sie den endgültigen Wert auf den nächsten ganzzahligen Wert.

Für tmc2209 setzen Sie dies in der Konfiguration als `driver_SGTHRS`, für andere TMC-Treiber setzen Sie dies in der Konfiguration als `driver_SGT`.

Wenn der Bereich zwischen *maximum_sensitivity* und *minimum_sensitivity* klein ist (z. B. weniger als 5), kann dies zu einer instabilen Referenzfahrt führen. Eine schnellere Referenzfahrtgeschwindigkeit kann den Bereich vergrößern und den Betrieb stabiler machen.

Beachten Sie, dass bei Änderungen des Treiberstroms, der Referenzfahrtgeschwindigkeit oder bei wesentlichen Änderungen an der Druckerhardware der Abstimmungsprozess erneut durchgeführt werden muss.

#### Verwenden sie Macros für die Referenzfahrt

Nach Abschluss der sensorlosen Referenzfahrt wird der Schlitten gegen das Ende der Schiene gedrückt und der Stepper übt eine Kraft auf den Rahmen aus, bis der Schlitten weggefahren ist. Es ist eine gute Idee, ein Makro zu erstellen, um die Achse zu referenzieren und den Schlitten sofort vom Ende der Schiene weg zu bewegen.

Es ist ratsam, dass das Makro vor dem Start der sensorlosen Referenzfahrt mindestens 2 Sekunden pausiert (oder auf andere Weise sicherstellt, dass der Stepper 2 Sekunden lang nicht bewegt wurde). Ohne eine Verzögerung ist es möglich, dass das interne "stall"-Flag des Treibers noch von einer vorherigen Bewegung gesetzt ist.

It can also be useful to have that macro set the driver current before homing and set a new current after the carriage has moved away.

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

1. When using sensorless homing on CoreXY, make sure there is no `hold_current` configured for either stepper.
1. Vergewissern Sie sich bei der Einstellung, dass sich sowohl der X- als auch der Y-Wagen vor jedem Startversuch in der Mitte ihrer Schienen befinden.
1. Verwenden Sie nach Abschluss der Abstimmung bei der Referenzfahrt von X und Y Makros, um sicherzustellen, dass zuerst eine Achse referenziert wird, bewegen Sie dann diesen Schlitten von der Achsengrenze weg, halten Sie mindestens 2 Sekunden lang inne und starten Sie dann die Referenzfahrt des anderen Schlittens. Durch die Bewegung von der Achse weg wird vermieden, dass eine Achse referenziert wird, während die andere gegen die Achsengrenze gedrückt wird (was die Erkennung des Stillstands verfälschen könnte). Die Pause ist notwendig, um sicherzustellen, dass das Blockierflag des Fahrers vor der erneuten Referenzfahrt gelöscht wird.

An example CoreXY homing macro might look like:

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

The `[DUMP_TMC command](G-Codes.md#dump_tmc) is a useful tool when configuring and diagnosing the drivers. It will report all fields configured by Klipper as well as all fields that can be queried from the driver.

Alle angegebenen Felder sind im Trinamic-Datenblatt für jeden Treiber definiert. Diese Datenblätter finden Sie auf der [Trinamic-Website] (https://www.trinamic.com/). Besorgen Sie sich das Trinamic Datenblatt für den Treiber und prüfen Sie es, um die Ergebnisse von DUMP_TMC zu interpretieren.

## Konfigurieren der Einstellungen von driver_XXX

Klipper unterstützt die Konfiguration vieler Low-Level-Treiberfelder mit `driver_XXX` Einstellungen. Die [TMC driver config reference](Config_Reference.md#tmc-stepper-driver-configuration) enthält die vollständige Liste der Felder, die für jede Art von Treiber verfügbar sind.

In addition, almost all fields can be modified at run-time using the [SET_TMC_FIELD command](G-Codes.md#set_tmc_field).

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

Es ist auch möglich, dass ein **TMC meldet Fehler** Shutdown aufgrund von SPI-Fehlern auftritt, die die Kommunikation mit dem Treiber verhindern (bei tmc2130, tmc5160 oder tmc2660). Wenn dies geschieht, zeigt der gemeldete Treiberstatus üblicherweise `00000000` oder `ffffffff` zum Beispiel: `TMC reports error: DRV_STATUS: ffffffff ...` ODER `TMC meldet Fehler: READRSP@RDSEL2: 00000000 ...`. Ein solcher Fehler kann auf ein SPI Verdrahtungsproblem oder auf einen Selbst Reset oder einen Fehler des TMCTreibers zurückzuführen sein.

Einige häufige Fehler und Tipps zu deren Diagnose:

#### TMC meldet Fehler: `... ot=1(OvertempError!)`

Dies bedeutet, dass sich der Motortreiber selbst deaktiviert hat, weil er zu heiß geworden ist. Typische Lösungen sind die Verringerung des Schrittmotorstroms, die Erhöhung der Kühlung des Schrittmotortreibers und/oder die Erhöhung der Kühlung des Schrittmotors.

#### TMC reports error: `... ShortToGND` OR `ShortToSupply`

Dies bedeutet, dass der Treiber sich selbst deaktiviert hat, weil er einen sehr hohen Stromfluss durch den Treiber festgestellt hat. Dies kann auf ein loses oder kurzgeschlossenes Kabel zum Schrittmotor oder im Schrittmotor selbst hinweisen.

Dieser Fehler kann auch auftreten, wenn Sie den StealthChop-Modus verwenden und der TMC-Treiber die mechanische Belastung des Motors nicht genau vorhersagen kann. (Wenn der Treiber eine schlechte Vorhersage macht, kann er zu viel Strom durch den Motor schicken und seine eigene Überstromerkennung auslösen.) Um dies zu testen, deaktivieren Sie den StealthChop-Modus und prüfen Sie, ob die Fehler weiterhin auftreten.

#### TMC meldet Fehler: `... reset=1(Reset)` ODER `CS_ACTUAL=0(Reset?)` ODER `SE=0(Reset?)`

Dies bedeutet, dass sich der Treiber mitten im Druckvorgang zurückgesetzt hat. Dies kann auf Spannungs- oder Verdrahtungsprobleme zurückzuführen sein.

#### TMC meldet Fehler: `... uv_cp=1(Unterspannung!)`

Dies zeigt an, dass der Treiber ein Unterspannungsereignis erkannt und sich selbst deaktiviert hat. Dies kann auf Verdrahtungs- oder Stromversorgungsprobleme zurückzuführen sein.

### Wie stelle ich den spreadCycle/coolStep/etc.-Modus für meine Treiber ein?

Auf der [Trinamic-Website](https://www.trinamic.com/) finden Sie Anleitungen zur Konfiguration der Treiber. Diese Anleitungen sind oft technisch anspruchsvoll und können spezielle Hardware erfordern. Unabhängig davon sind sie die beste Informationsquelle.
