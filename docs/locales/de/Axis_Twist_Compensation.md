# Kompensation der Achsenverdrehung

Dieses Dokument beschreibt das Modul `[axis_twist_compensation]`.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Dieses Modul verwendet manuelle Messungen durch den Benutzer, um die Ergebnisse des Tasters zu korrigieren. Beachten Sie, dass bei einer deutlich verdrehten Achse dringend empfohlen wird, diese zuerst mechanisch zu korrigieren, bevor Softwarekorrekturen angewendet werden.

**Warnung**: Dieses Modul ist noch nicht mit andockbaren Tastern kompatibel und versucht bei der Verwendung, das Bett abzutasten, ohne den Taster anzudocken.

## Überblick über die Verwendung der Kompensation

> **Tipp:** Stellen Sie sicher, dass die [X- und Y-Offsets des Tasters](Config_Reference.md#probe) korrekt gesetzt sind, da sie die Kalibrierung stark beeinflussen.

### Grundlegende Verwendung: Kalibrierung der X-Achse

1. Führen Sie nach der Einrichtung des Moduls `[axis_twist_compensation]` Folgendes aus:

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

Dieser Befehl kalibriert standardmäßig die X-Achse.

- Der Kalibrierassistent fordert Sie auf, den Z-Offset des Tasters an mehreren Punkten entlang des Betts zu messen.
- Standardmäßig verwendet die Kalibrierung 3 Punkte, Sie können jedoch mit der folgenden Option eine andere Anzahl angeben: `SAMPLE_COUNT=<value>`

1. **Z-Offset anpassen:** Stellen Sie nach Abschluss der Kalibrierung sicher, dass Sie [Ihren Z-Offset anpassen](Probe_Calibrate.md#calibrating-probe-z-offset).
1. **Bettnivellierung durchführen:** Verwenden Sie nach Bedarf tasterbasierte Vorgänge, wie zum Beispiel:

- [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust)
- [Z Tilt Adjust](G-Codes.md#z_tilt_adjust)

1. **Einrichtung abschließen:**

- Referenzieren Sie alle Achsen und führen Sie bei Bedarf ein [Bed Mesh](Bed_Mesh.md) aus.
- Führen Sie einen Testdruck durch und nehmen Sie bei Bedarf anschließend eine [Feinabstimmung](Axis_Twist_Compensation.md#fine-tuning) vor.

### Für die Kalibrierung der Y-Achse

Der Kalibriervorgang für die Y-Achse verläuft ähnlich wie für die X-Achse. Verwenden Sie zur Kalibrierung der Y-Achse:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

Dies führt Sie durch denselben Messvorgang wie bei der X-Achse.

> **Tipp:** Betttemperatur sowie Temperatur und Größe der Düse scheinen keinen Einfluss auf den Kalibriervorgang zu haben.

## [axis_twist_compensation] Einrichtung und Befehle

Konfigurationsoptionen für `[axis_twist_compensation]` finden Sie in der [Konfigurationsreferenz](Config_Reference.md#axis_twist_compensation).

Befehle für `[axis_twist_compensation]` finden Sie in der [G-Codes-Referenz](G-Codes.md#axis_twist_compensation)
