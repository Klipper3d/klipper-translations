# Rotationsdistanz

Schrittmotortreiber auf Klipper benötigen einen `rotation_distance`-Parameter in jedem [Stepper-Konfigurationsabschnitt](Config_Reference.md#stepper). Die `rotation_distance` ist die Strecke, um die sich die Achse mit einer vollen Umdrehung des Schrittmotors bewegt. Dieses Dokument beschreibt, wie man diesen Wert konfigurieren kann.

## Ermitteln der Rotationsdistanz aus steps_per_mm (oder step_distance)

Die Designer Ihres 3D-Druckers haben ursprünglich `steps_per_mm` aus einer Rotationsdistanz (rotation distance) berechnet. Wenn Sie die "steps_per_mm" kennen, ist es möglich, diese allgemeine Formel zu verwenden, um diese ursprüngliche Rotationsdistanz zu erhalten:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> / <steps_per_mm>
```

Falls Sie eine ältere Klipper-Konfiguration besitzen und den Parameter `step_distance` kennen, können Sie diese Formel verwenden:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> * <step_distance>
```

Die Einstellung `<full_steps_per_rotation>` richtet sich nach dem Typ des Schrittmotors. Die meisten Schrittmotoren sind "1,8-Grad-Schrittmotoren" und haben daher 200 Vollschritte pro Umdrehung (360 geteilt durch 1,8 ergibt 200). Manche Schrittmotoren sind "0,9-Grad-Schrittmotoren" und haben somit 400 Vollschritte pro Umdrehung. Andere Schrittmotoren sind selten. Im Zweifel setzen Sie full_steps_per_rotation nicht in der Konfigurationsdatei und verwenden 200 in der obigen Formel.

Die Einstellung `<microsteps>` richtet sich nach dem Schrittmotortreiber. Die meisten Treiber verwenden 16 Mikroschritte. Im Zweifel setzen Sie `microsteps: 16` in der Konfiguration und verwenden 16 in der obigen Formel.

Bei fast allen Druckern sollte `rotation_distance` für X-, Y- und Z-Achsen eine ganze Zahl ergeben. Ergibt die obige Formel eine rotation_distance, die innerhalb von 0,01 einer ganzen Zahl liegt, runden Sie den Endwert auf diese ganze Zahl.

## Kalibrierung von rotation_distance auf Extrudern

Bei einem Extruder ist `rotation_distance` die Strecke, die das Filament bei einer vollen Umdrehung des Schrittmotors zurücklegt. Der beste Weg, einen genauen Wert für diese Einstellung zu erhalten, ist ein "Messen-und-Anpassen"-Verfahren.

Beginnen Sie zunächst mit einem ersten Schätzwert für die rotation_distance. Diesen können Sie aus [steps_per_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance) oder durch [Untersuchen der Hardware](#extruder) ermitteln.

Verwenden Sie anschließend folgendes Verfahren zum "Messen und Anpassen":

1. Stellen Sie sicher, dass sich Filament im Extruder befindet, das Hotend auf eine geeignete Temperatur aufgeheizt ist und der Drucker bereit zum Extrudieren ist.
1. Markieren Sie mit einem Stift eine Stelle auf dem Filament etwa 70 mm vom Einlass des Extrudergehäuses entfernt. Messen Sie anschließend mit einer digitalen Schieblehre möglichst genau den tatsächlichen Abstand dieser Markierung. Notieren Sie diesen als `<initial_mark_distance>`.
1. Extrudieren Sie 50 mm Filament mit folgender Befehlsfolge: `G91`, gefolgt von `G1 E50 F60`. Notieren Sie 50 mm als `<requested_extrude_distance>`. Warten Sie, bis der Extruder die Bewegung abgeschlossen hat (dies dauert etwa 50 Sekunden). Es ist wichtig, für diesen Test die langsame Extrusionsrate zu verwenden, da eine schnellere Rate hohen Druck im Extruder verursachen kann, was die Ergebnisse verfälscht. (Verwenden Sie für diesen Test nicht die "Extrudieren"-Schaltfläche grafischer Frontends, da diese mit hoher Rate extrudieren.)
1. Messen Sie mit der digitalen Schieblehre den neuen Abstand zwischen dem Extrudergehäuse und der Markierung auf dem Filament. Notieren Sie diesen als `<subsequent_mark_distance>`. Berechnen Sie dann: `actual_extrude_distance = <initial_mark_distance> - <subsequent_mark_distance>`
1. Berechnen Sie rotation_distance als: `rotation_distance = <previous_rotation_distance> * <actual_extrude_distance> / <requested_extrude_distance>` Runden Sie den neuen rotation_distance-Wert auf drei Dezimalstellen.

Weicht actual_extrude_distance um mehr als etwa 2 mm von requested_extrude_distance ab, empfiehlt es sich, die obigen Schritte ein zweites Mal durchzuführen.

Hinweis: Verwenden Sie *kein* "Messen-und-Anpassen"-Verfahren zur Kalibrierung von X-, Y- oder Z-Achsen. Das "Messen-und-Anpassen"-Verfahren ist für diese Achsen nicht genau genug und führt wahrscheinlich zu einer schlechteren Konfiguration. Diese Achsen sollten stattdessen bei Bedarf durch [Vermessen von Riemen, Riemenscheiben und Leitspindel-Hardware](#obtaining-rotation_distance-by-inspecting-the-hardware) bestimmt werden.

## Ermittlung der rotation_distance durch Überprüfung der Hardware

Mit Kenntnis der Schrittmotoren und der Drucker-Kinematik lässt sich rotation_distance berechnen. Dies kann nützlich sein, wenn steps_per_mm nicht bekannt ist oder beim Entwurf eines neuen Druckers.

### Riemenangetriebene Achsen

Für eine lineare Achse mit Riemen und Riemenscheibe lässt sich rotation_distance leicht berechnen.

Bestimmen Sie zunächst den Riementyp. Die meisten Drucker verwenden einen Riemen mit 2 mm Teilung (d. h., jeder Zahn des Riemens liegt 2 mm vom nächsten entfernt). Zählen Sie dann die Anzahl der Zähne auf der Riemenscheibe des Schrittmotors. rotation_distance wird dann berechnet als:

```
rotation_distance = <belt_pitch> * <number_of_teeth_on_pulley>
```

Hat ein Drucker beispielsweise einen 2-mm-Riemen und verwendet eine Riemenscheibe mit 20 Zähnen, beträgt die rotation_distance 40.

### Achsen mit Leitspindel

Für gängige Leitspindeln lässt sich rotation_distance leicht mit folgender Formel berechnen:

```
rotation_distance = <screw_pitch> * <number_of_separate_threads>
```

Die gängige "T8-Leitspindel" hat beispielsweise eine rotation_distance von 8 (sie hat eine Steigung von 2 mm und 4 separate Gänge).

Ältere Drucker mit "Gewindestangen" haben nur einen "Gang" auf der Leitspindel, sodass die rotation_distance der Steigung der Schraube entspricht. (Die Schraubensteigung ist der Abstand zwischen den einzelnen Rillen der Schraube.) Eine metrische M6-Stange hat also beispielsweise eine rotation_distance von 1 und eine M8-Stange eine rotation_distance von 1,25.

### Extruder

Für Extruder lässt sich ein erster rotation_distance-Wert ermitteln, indem der Durchmesser der "gerändelten Schraube" (Hobbed Bolt) gemessen wird, die das Filament vorschiebt, und folgende Formel angewendet wird: `rotation_distance = <Durchmesser> * 3,14`

Verwendet der Extruder Zahnräder, muss zusätzlich das [gear_ratio bestimmt und gesetzt](#using-a-gear_ratio) werden.

Die tatsächliche rotation_distance eines Extruders variiert von Drucker zu Drucker, da der Griff der "gerändelten Schraube", die das Filament erfasst, unterschiedlich ausfallen kann. Sie kann sogar zwischen verschiedenen Filamentspulen variieren. Nach Ermittlung eines ersten rotation_distance-Werts verwenden Sie das [Messen-und-Anpassen-Verfahren](#calibrating-rotation_distance-on-extruders), um eine genauere Einstellung zu erhalten.

## Verwendung von gear_ratio

Das Setzen eines `gear_ratio` kann die Konfiguration der `rotation_distance` bei Schrittmotoren mit angeschlossenem Getriebe (oder Ähnlichem) erleichtern. Die meisten Schrittmotoren haben kein Getriebe - im Zweifel setzen Sie `gear_ratio` nicht in der Konfiguration.

Ist `gear_ratio` gesetzt, stellt `rotation_distance` die Strecke dar, die sich die Achse bei einer vollen Umdrehung des letzten Zahnrads im Getriebe bewegt. Verwendet man beispielsweise ein Getriebe mit einem Verhältnis von "5:1", könnte man die rotation_distance mit [Kenntnis der Hardware](#obtaining-rotation_distance-by-inspecting-the-hardware) berechnen und anschließend `gear_ratio: 5:1` zur Konfiguration hinzufügen.

Bei mit Riemen und Riemenscheiben umgesetzten Getrieben lässt sich das gear_ratio durch Zählen der Zähne auf den Riemenscheiben bestimmen. Treibt beispielsweise ein Schrittmotor mit einer 16-zähnigen Riemenscheibe die nächste Riemenscheibe mit 80 Zähnen an, würde man `gear_ratio: 80:16` verwenden. Man könnte sogar ein handelsübliches "Getriebe" öffnen und die Zähne darin zählen, um das Übersetzungsverhältnis zu bestätigen.

Beachten Sie, dass ein Getriebe manchmal ein leicht anderes Übersetzungsverhältnis hat, als angegeben. Die verbreiteten BMG-Extrudermotor-Zahnräder sind ein Beispiel dafür - sie werden als "3:1" beworben, verwenden aber tatsächlich eine "50:17"-Übersetzung. (Die Verwendung von Zähnezahlen ohne gemeinsamen Teiler kann den Zahnradverschleiß insgesamt verringern, da die Zähne bei jeder Umdrehung nicht immer auf dieselbe Weise ineinandergreifen.) Das verbreitete "5,18:1-Planetengetriebe" wird genauer mit `gear_ratio: 57:11` konfiguriert.

Werden auf einer Achse mehrere Zahnräder verwendet, kann für gear_ratio eine durch Kommas getrennte Liste angegeben werden. Ein "5:1"-Getriebe, das eine 16-zähnige mit einer 80-zähnigen Riemenscheibe antreibt, könnte beispielsweise `gear_ratio: 5:1, 80:16` verwenden.

In den meisten Fällen sollte gear_ratio mit ganzen Zahlen angegeben werden, da gängige Zahnräder und Riemenscheiben eine ganzzahlige Anzahl von Zähnen haben. Treibt jedoch ein Riemen eine Riemenscheibe über Reibung statt über Zähne an, kann es sinnvoll sein, eine Fließkommazahl im Übersetzungsverhältnis zu verwenden (z. B. `gear_ratio: 107.237:16`).
