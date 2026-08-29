# Slicer

Dieses Dokument enthält einige Tipps zum Konfigurieren einer "Slicer"-Anwendung für die Verwendung mit Klipper. Übliche Slicer, die mit Klipper verwendet werden, sind Slic3r, Cura, Simplify3D usw.

## Setzen Sie den G-Code Flavor auf Marlin

Viele Slicer haben eine Option zur Konfiguration des "G-Code Flavor". Die Standardeinstellung ist häufig "Marlin" und das funktioniert problemlos mit Klipper. Die Einstellung "Smoothieware" funktioniert ebenfalls problemlos mit Klipper.

## Klipper gcode_macro

Slicer erlauben es oft, "Start-G-Code"- und "End-G-Code"-Sequenzen zu konfigurieren. Häufig ist es praktischer, stattdessen benutzerdefinierte Makros in der Klipper-Konfigurationsdatei zu definieren - etwa: `[gcode_macro START_PRINT]` und `[gcode_macro END_PRINT]`. Anschließend genügt es, START_PRINT und END_PRINT in der Slicer-Konfiguration aufzurufen. Das Definieren dieser Aktionen in der Klipper-Konfiguration kann das Anpassen der Start- und Endschritte des Druckers erleichtern, da Änderungen kein erneutes Slicen erfordern.

Siehe [sample-macros.cfg](../config/sample-macros.cfg) z.B. START_PRINT und END_PRINT Makros.

Details zur Definition eines gcode_macro finden Sie in der [Konfigurationsreferenz](Config_Reference.md#gcode_macro).

## Große Retraction-Einstellungen können eine Anpassung von Klipper erfordern

Die maximale Geschwindigkeit und Beschleunigung von Retraction-Bewegungen wird in Klipper über die Konfigurationsparameter `max_extrude_only_velocity` und `max_extrude_only_accel` gesteuert. Diese Einstellungen haben einen Standardwert, der bei vielen Druckern gut funktionieren sollte. Wurde im Slicer jedoch eine große Retraction konfiguriert (z. B. 5 mm oder mehr), kann es sein, dass diese Werte die gewünschte Retraction-Geschwindigkeit begrenzen.

Bei Verwendung einer großen Retraction sollten Sie stattdessen erwägen, Klippers [Pressure Advance](Pressure_Advance.md) zu kalibrieren. Scheint der Werkzeugkopf während Retraction und Priming zu "pausieren", sollten Sie in Erwägung ziehen, `max_extrude_only_velocity` und `max_extrude_only_accel` explizit in der Klipper-Konfigurationsdatei zu definieren.

## "coasting" Nicht aktivieren

Die "Coasting"-Funktion führt bei Klipper wahrscheinlich zu einer schlechten Druckqualität. Erwägen Sie stattdessen die Verwendung von Klippers [Pressure Advance](Pressure_Advance.md).

Ändert der Slicer die Extrusionsrate zwischen Bewegungen drastisch, führt Klipper zwischen den Bewegungen eine Verzögerung und Beschleunigung durch. Dies verschlimmert Wulstbildung (Blobbing) eher, als sie zu verbessern.

Im Gegensatz dazu ist es unbedenklich (und oft hilfreich), die "Retract"-, "Wipe"- und/oder "Wipe on Retract"-Einstellung eines Slicers zu verwenden.

## Verwenden Sie in Simplify3d nicht die Option "extra restart distance"

Diese Einstellung kann drastische Änderungen der Extrusionsrate verursachen, die Klippers Prüfung des maximalen Extrusionsquerschnitts auslösen können. Erwägen Sie stattdessen die Verwendung von Klippers [Pressure Advance](Pressure_Advance.md) oder der regulären Retraction-Einstellung von Simplify3d.

## "PreloadVE" im KISSlicer deaktivieren

Verwenden Sie die Slicing-Software KISSlicer, setzen Sie "PreloadVE" auf null. Erwägen Sie stattdessen die Verwendung von Klippers [Pressure Advance](Pressure_Advance.md).

## Deaktivieren Sie alle "advanced extruder pressure" Einstellungen

Manche Slicer bewerben eine Funktion für "erweiterten Extruderdruck". Es wird empfohlen, diese Optionen bei Verwendung von Klipper deaktiviert zu lassen, da sie wahrscheinlich zu schlechter Druckqualität führen. Erwägen Sie stattdessen die Verwendung von Klippers [Pressure Advance](Pressure_Advance.md).

Konkret können diese Slicer-Einstellungen die Firmware anweisen, drastische Änderungen an der Extrusionsrate vorzunehmen, in der Hoffnung, dass die Firmware diese Anfragen annähert und der Drucker näherungsweise den gewünschten Extruderdruck erreicht. Klipper nutzt jedoch präzise kinematische Berechnungen und Timing. Wird Klipper angewiesen, die Extrusionsrate erheblich zu ändern, plant es die entsprechenden Änderungen an Geschwindigkeit, Beschleunigung und Extruderbewegung - was nicht der Absicht des Slicers entspricht. Der Slicer kann sogar übermäßige Extrusionsraten anfordern, sodass Klippers Prüfung des maximalen Extrusionsquerschnitts ausgelöst wird.

Im Gegensatz dazu ist es unbedenklich (und oft hilfreich), die "Retract"-, "Wipe"- und/oder "Wipe on Retract"-Einstellung eines Slicers zu verwenden.

## START_PRINT Makros

Bei Verwendung eines START_PRINT-Makros oder Ähnlichem ist es manchmal nützlich, Slicer-Variablen als Parameter an das Makro weiterzugeben.

In Cura würde für die Weitergabe von Temperaturen folgender Start-G-Code verwendet:

```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

Bei slic3r-Derivaten wie PrusaSlicer und SuperSlicer würde Folgendes verwendet:

```
START_PRINT EXTRUDER_TEMP=[first_layer_temperature] BED_TEMP=[first_layer_bed_temperature]
```

Beachten Sie außerdem, dass diese Slicer eigene Heizbefehle einfügen, wenn bestimmte Bedingungen nicht erfüllt sind. In Cura genügt das Vorhandensein der Variablen `{material_bed_temperature_layer_0}` und `{material_print_temperature_layer_0}`, um dies zu vermeiden. Bei slic3r-Derivaten würde Folgendes verwendet:

```
M140 S0
M104 S0
```

vor dem Makroaufruf. Beachten Sie außerdem, dass SuperSlicer über eine Option "nur benutzerdefinierter G-Code" verfügt, die dasselbe Ergebnis erzielt.

An example of a START_PRINT macro using these parameters can be found in config/sample-macros.cfg
