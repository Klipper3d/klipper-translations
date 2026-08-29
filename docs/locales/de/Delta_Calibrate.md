# Deltakalibrierung

Dieses Dokument beschreibt das automatische Kalibrierungssystem von Klipper für "Delta"-Drucker.

Bei der Deltakalibrierung werden die Endanschlagspositionen des Druckturms, die Winkel des Druckturms, der Deltaradius und die Länge des Deltararms ermittelt. Diese Einstellungen steuern die Bewegung des Druckers auf einem Deltadrucker. Jeder dieser Parameter hat einen nicht offensichtlichen und nicht linearen Einfluss, und es ist schwierig, sie manuell zu kalibrieren. Im Gegensatz dazu kann der Software-Kalibrierungscode in nur wenigen Minuten hervorragende Ergebnisse liefern. Es ist keine spezielle Messhardware erforderlich.

Letztlich hängt die Delta-Kalibrierung von der Präzision der Endschalter an den Türmen ab. Wenn Sie Trinamic-Schrittmotortreiber verwenden, sollten Sie die Erkennung der [Endschalterphase](Endstop_Phase.md) aktivieren, um die Genauigkeit dieser Schalter zu verbessern.

## Automatische vs manuelle Proben

Klipper unterstützt die Kalibrierung der Delta-Parameter über ein manuelles Abtastverfahren oder über eine automatische Z-Sonde.

Einige Delta-Druckerbausätze werden mit automatischen Z-Sonden geliefert, die nicht ausreichend genau sind (insbesondere können kleine Unterschiede in der Armlänge zu einer Neigung des Effektors führen, die eine automatische Messung verfälscht). Wenn Sie eine automatische Sonde verwenden, [kalibrieren Sie zuerst die Sonde](Probe_Calibrate.md) und prüfen Sie anschließend auf eine [positionsabhängige Abweichung der Sonde](Probe_Calibrate.md#location-bias-check). Weist die automatische Sonde eine Abweichung von mehr als 25 Mikrometern (.025 mm) auf, verwenden Sie stattdessen das manuelle Abtasten. Manuelles Abtasten dauert nur wenige Minuten und beseitigt den durch die Sonde eingebrachten Fehler.

Wenn Sie eine Sonde verwenden, die seitlich am Hotend montiert ist (die also einen X- oder Y-Versatz hat), beachten Sie, dass eine Delta-Kalibrierung die Ergebnisse der Sondenkalibrierung ungültig macht. Derartige Sonden sind für den Einsatz an einem Delta-Drucker selten geeignet (da bereits eine geringe Neigung des Effektors zu einer positionsabhängigen Abweichung der Sonde führt). Wenn Sie die Sonde dennoch verwenden, führen Sie die Sondenkalibrierung nach jeder Delta-Kalibrierung erneut durch.

## Einfache Delta Kalibrierung

Klipper verfügt über den Befehl DELTA_CALIBRATE, der eine grundlegende Delta-Kalibrierung durchführen kann. Dieser Befehl tastet sieben verschiedene Punkte auf dem Bett ab und berechnet neue Werte für die Turmwinkel, die Turm-Endschalter und den Delta-Radius.

Um diese Kalibrierung durchzuführen, müssen die anfänglichen Delta-Parameter (Armlängen, Radius und Endschalterpositionen) angegeben werden und auf wenige Millimeter genau sein. Die meisten Delta-Druckerbausätze liefern diese Parameter mit - konfigurieren Sie den Drucker mit diesen Ausgangswerten und führen Sie anschließend wie unten beschrieben den Befehl DELTA_CALIBRATE aus. Sind keine Vorgabewerte verfügbar, suchen Sie online nach einer Anleitung zur Delta-Kalibrierung, die einen grundlegenden Ausgangspunkt liefert.

Während der Delta-Kalibrierung kann es notwendig sein, dass der Drucker unterhalb der Ebene abtastet, die sonst als Bettebene gilt. Üblicherweise erlaubt man dies während der Kalibrierung, indem man die Konfiguration so anpasst, dass für den Drucker `minimum_z_position=-5` gilt. (Nach Abschluss der Kalibrierung kann diese Einstellung wieder aus der Konfiguration entfernt werden.)

Es gibt zwei Möglichkeiten, das Abtasten durchzuführen - manuelles Abtasten (`DELTA_CALIBRATE METHOD=manual`) und automatisches Abtasten (`DELTA_CALIBRATE`). Beim manuellen Verfahren fährt der Kopf nahe an das Bett und wartet dann darauf, dass der Benutzer die unter ["Der Papiertest"](Bed_Level.md#the-paper-test) beschriebenen Schritte ausführt, um den tatsächlichen Abstand zwischen Düse und Bett an der jeweiligen Position zu bestimmen.

Um die grundlegende Messung durchzuführen, stellen Sie sicher, dass in der Konfiguration ein Abschnitt [delta_calibrate] definiert ist, und führen Sie dann das Werkzeug aus:

```
G28
DELTA_CALIBRATE METHOD=manual
```

Nach dem Abtasten der sieben Punkte werden neue Delta-Parameter berechnet. Speichern und übernehmen Sie diese Parameter mit folgendem Befehl:

```
SAVE_CONFIG
```

Die grundlegende Kalibrierung sollte Delta-Parameter liefern, die für einfache Drucke genau genug sind. Wenn es sich um einen neuen Drucker handelt, ist dies ein guter Zeitpunkt, um einige einfache Objekte zu drucken und die grundsätzliche Funktion zu überprüfen.

## Verbesserte Delta Kalibrierung

Die grundlegende Delta-Kalibrierung berechnet die Delta-Parameter in der Regel so gut, dass die Düse den richtigen Abstand zum Bett hat. Sie versucht jedoch nicht, die Maßhaltigkeit in X und Y zu kalibrieren. Es ist sinnvoll, eine erweiterte Delta-Kalibrierung durchzuführen, um die Maßhaltigkeit zu überprüfen.

Dieses Kalibrierverfahren erfordert das Drucken eines Testobjekts und das Vermessen von Teilen dieses Testobjekts mit einem digitalen Messschieber.

Vor einer erweiterten Delta-Kalibrierung muss die grundlegende Delta-Kalibrierung (über den Befehl DELTA_CALIBRATE) durchgeführt und das Ergebnis (über den Befehl SAVE_CONFIG) gespeichert werden. Stellen Sie sicher, dass es seit der letzten grundlegenden Delta-Kalibrierung keine nennenswerte Änderung an Druckerkonfiguration oder Hardware gegeben hat (führen Sie im Zweifelsfall die [grundlegende Delta-Kalibrierung](#basic-delta-calibration) einschließlich SAVE_CONFIG unmittelbar vor dem Druck des unten beschriebenen Testobjekts erneut aus).

Erzeugen Sie mit einem Slicer G-Code aus der Datei [docs/prints/calibrate_size.stl](prints/calibrate_size.stl). Slicen Sie das Objekt mit niedriger Geschwindigkeit (z. B. 40 mm/s). Verwenden Sie für das Objekt nach Möglichkeit einen steifen Kunststoff (etwa PLA). Das Objekt hat einen Durchmesser von 140 mm. Ist das für den Drucker zu groß, kann man es verkleinern (achten Sie darauf, die X- und die Y-Achse gleichmäßig zu skalieren). Unterstützt der Drucker deutlich größere Drucke, kann dieses Objekt auch vergrößert werden. Eine größere Ausführung kann die Messgenauigkeit verbessern, gute Bettadhäsion ist jedoch wichtiger als eine größere Druckgröße.

Drucken Sie das Testobjekt und warten Sie, bis es vollständig abgekühlt ist. Die im Folgenden beschriebenen Befehle müssen mit denselben Druckereinstellungen ausgeführt werden, mit denen das Kalibrierobjekt gedruckt wurde (führen Sie zwischen Drucken und Messen kein DELTA_CALIBRATE aus und nehmen Sie nichts vor, was die Druckerkonfiguration verändern würde).

Führen Sie die nachfolgend beschriebenen Messungen nach Möglichkeit durch, während das Objekt noch am Druckbett haftet. Löst sich das Teil vom Bett, ist das jedoch kein Problem - vermeiden Sie lediglich, das Objekt beim Messen zu verbiegen.

Messen Sie zunächst den Abstand zwischen der mittleren Säule und der Säule neben der Beschriftung "A" (die außerdem in Richtung des Turms "A" zeigen sollte).

![delta-a-distance](img/delta-a-distance.jpg)

Gehen Sie dann gegen den Uhrzeigersinn vor und messen Sie die Abstände zwischen der mittleren Säule und den übrigen Säulen (Abstand von der Mitte zur Säule gegenüber der Beschriftung C, Abstand von der Mitte zur Säule mit der Beschriftung B usw.).

![delta_cal_e_step1](img/delta_cal_e_step1.png)

Geben Sie diese Parameter als kommagetrennte Liste von Gleitkommazahlen in Klipper ein:

```
DELTA_ANALYZE CENTER_DISTS=<a_dist>,<far_c_dist>,<b_dist>,<far_a_dist>,<c_dist>,<far_b_dist>
```

Geben Sie die Werte ohne Leerzeichen an.

Messen Sie anschließend den Abstand zwischen der Säule A und der Säule gegenüber der Beschriftung C.

![delta-ab-distance](img/delta-outer-distance.jpg)

Gehen Sie dann gegen den Uhrzeigersinn vor und messen Sie den Abstand von der Säule gegenüber C zur Säule B, den Abstand zwischen der Säule B und der Säule gegenüber A und so weiter.

![delta_cal_e_step2](img/delta_cal_e_step2.png)

Geben Sie diese Parameter in Klipper ein:

```
DELTA_ANALYZE OUTER_DISTS=<a_to_far_c>,<far_c_to_b>,<b_to_far_a>,<far_a_to_c>,<c_to_far_b>,<far_b_to_a>
```

An dieser Stelle können Sie das Objekt vom Bett lösen. Die letzten Messungen betreffen die Säulen selbst. Messen Sie die Größe der mittleren Säule entlang der Speiche A, dann entlang der Speiche B und dann entlang der Speiche C.

![delta-a-pillar](img/delta-a-pillar.jpg)

![delta_cal_e_step3](img/delta_cal_e_step3.png)

Geben Sie diese in Klipper ein:

```
DELTA_ANALYZE CENTER_PILLAR_WIDTHS=<a>,<b>,<c>
```

Die letzten Messungen betreffen die äußeren Säulen. Messen Sie zunächst die Abmessung der Säule A entlang der Linie von A zur Säule gegenüber C.

![delta-ab-pillar](img/delta-outer-pillar.jpg)

Gehen Sie dann gegen den Uhrzeigersinn vor und messen Sie die übrigen äußeren Säulen (Säule gegenüber C entlang der Linie zu B, Säule B entlang der Linie zur Säule gegenüber A usw.).

![delta_cal_e_step4](img/delta_cal_e_step4.png)

Und geben Sie diese in Klipper ein:

```
DELTA_ANALYZE OUTER_PILLAR_WIDTHS=<a>,<far_c>,<b>,<far_a>,<c>,<far_b>
```

Wurde das Objekt kleiner oder größer skaliert, geben Sie den beim Slicen verwendeten Skalierungsfaktor an:

```
DELTA_ANALYZE SCALE=1.0
```

(Ein Skalierungswert von 2.0 würde bedeuten, dass das Objekt doppelt so groß ist wie im Original, 0.5 wäre halb so groß wie im Original.)

Führen Sie abschließend die erweiterte Delta-Kalibrierung aus:

```
DELTA_ANALYZE CALIBRATE=extended
```

Die Ausführung dieses Befehls kann mehrere Minuten dauern. Nach Abschluss berechnet er aktualisierte Delta-Parameter (Delta-Radius, Turmwinkel, Endschalterpositionen und Armlängen). Verwenden Sie den Befehl SAVE_CONFIG, um die Einstellungen zu speichern und zu übernehmen:

```
SAVE_CONFIG
```

Der Befehl SAVE_CONFIG speichert sowohl die aktualisierten Delta-Parameter als auch die Informationen aus den Abstandsmessungen. Künftige DELTA_CALIBRATE-Befehle nutzen diese Abstandsinformationen ebenfalls. Versuchen Sie nicht, die rohen Abstandsmessungen nach dem Ausführen von SAVE_CONFIG erneut einzugeben, da dieser Befehl die Druckerkonfiguration verändert und die Rohmesswerte damit nicht mehr gültig sind.

### Zusätzliche Hinweise

* Weist der Delta-Drucker eine gute Maßhaltigkeit auf, sollte der Abstand zwischen zwei beliebigen Säulen etwa 74 mm und die Breite jeder Säule etwa 9 mm betragen. (Genauer gesagt ist das Ziel, dass der Abstand zwischen zwei beliebigen Säulen abzüglich der Breite einer Säule exakt 65 mm beträgt.) Liegt eine Maßabweichung am Bauteil vor, berechnet die Routine DELTA_ANALYZE neue Delta-Parameter unter Verwendung sowohl der Abstandsmessungen als auch der vorherigen Höhenmessungen aus dem letzten DELTA_CALIBRATE-Befehl.
* DELTA_ANALYZE kann Delta-Parameter liefern, die überraschend wirken. So können zum Beispiel Armlängen vorgeschlagen werden, die nicht den tatsächlichen Armlängen des Druckers entsprechen. Tests haben dennoch gezeigt, dass DELTA_ANALYZE häufig bessere Ergebnisse liefert. Es wird angenommen, dass die berechneten Delta-Parameter geringfügige Fehler an anderer Stelle der Hardware ausgleichen können. Kleine Unterschiede in der Armlänge können zum Beispiel zu einer Neigung des Effektors führen, und ein Teil dieser Neigung lässt sich durch Anpassen der Armlängenparameter ausgleichen.

## Bed Mesh an einem Delta-Drucker verwenden

Es ist möglich, [Bed Mesh](Bed_Mesh.md) an einem Delta-Drucker zu verwenden. Wichtig ist jedoch, vor dem Aktivieren eines Bed Mesh eine gute Delta-Kalibrierung zu erreichen. Ein Bed Mesh bei schlechter Delta-Kalibrierung führt zu verwirrenden und schlechten Ergebnissen.

Beachten Sie, dass eine Delta-Kalibrierung jedes zuvor erstellte Bed Mesh ungültig macht. Führen Sie nach einer neuen Delta-Kalibrierung unbedingt BED_MESH_CALIBRATE erneut aus.
