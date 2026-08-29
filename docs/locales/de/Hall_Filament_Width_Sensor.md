# Filament-Dicken Hallsensor

Dieses Dokument beschreibt das Host-Modul für den Filamentbreitensensor. Die für die Entwicklung dieses Host-Moduls verwendete Hardware basiert auf zwei linearen Hall-Sensoren (zum Beispiel ss49e). Die Sensoren befinden sich auf gegenüberliegenden Seiten des Gehäuses. Funktionsprinzip: Beide Hall-Sensoren arbeiten im Differenzmodus, die Temperaturdrift ist bei beiden Sensoren identisch. Eine spezielle Temperaturkompensation ist daher nicht erforderlich.

Entwürfe finden Sie auf [Thingiverse](https://www.thingiverse.com/thing:4138933); ein Montagevideo ist außerdem auf [YouTube](https://www.youtube.com/watch?v=TDO9tME8vp4) verfügbar

Um den Hall-Filamentbreitensensor zu verwenden, lesen Sie die [Konfigurationsreferenz](Config_Reference.md#hall_filament_width_sensor) und die [G-Code-Dokumentation](G-Codes.md#hall_filament_width_sensor).

## Wie funktioniert das?

Der Sensor erzeugt zwei analoge Ausgänge basierend auf dem berechneten Filamentdurchmesser. Die Summe der Ausgangsspannungen entspricht stets dem erkannten Filamentdurchmesser. Das Host-Modul überwacht die Spannungsänderungen und passt den Extrusionsmultiplikator an. Verwendet wird beispielsweise der aux2-Anschluss auf einer RAMPS-ähnlichen Platine mit den Pins analog11 und analog12. Sie können auch andere Pins und andere Platinen verwenden.

## Vorlage für Menü Variablen

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## Kalibrierungs Prozedur

Um den Rohsensorwert zu erhalten, können Sie den Menüpunkt oder den Befehl **QUERY_RAW_FILAMENT_WIDTH** im Terminal verwenden.

1. Ersten Kalibrierstab einführen (1,5 mm Größe), ersten Rohsensorwert ermitteln
1. Zweiten Kalibrierstab einführen (2,0 mm Größe), zweiten Rohsensorwert ermitteln
1. Rohsensorwerte in den Konfigurationsparametern `Raw_dia1` und `Raw_dia2` speichern

## So aktivieren Sie den Sensor

Standardmäßig ist der Sensor beim Einschalten deaktiviert.

Um den Sensor zu aktivieren, geben Sie den Befehl **ENABLE_FILAMENT_WIDTH_SENSOR** aus oder setzen Sie den Parameter `enable` auf `true`.

## Nur als Runout-Schalter verwenden

Standardmäßig misst der Sensor den Filamentdurchmesser und passt den Extrusionsmultiplikator an, um Schwankungen auszugleichen.

Möchten Sie den Sensor ausschließlich als Runout-Schalter verwenden, setzen Sie den Konfigurationsparameter `enable_flow_compensation` auf `false`. In diesem Modus löst der Sensor nur dann Runout-Ereignisse aus, wenn kein Filament erkannt wird, verändert jedoch nicht den Extrusionsmultiplikator.

Dies ist nützlich für Drucker, bei denen der Filamentsensor für eine Durchflusskompensation nicht genau genug ist, aber zuverlässig ein Filament-Runout erkennen kann, oder beim Drucken mit flexiblen Filamenten mit instabilen Durchmessereigenschaften.

Geben Sie **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=1** aus, um die Durchflusskompensation zu aktivieren, oder **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=0**, um sie zu deaktivieren.

Beachten Sie, dass das Deaktivieren der Filamentbreitenkompensation den Extrusionsmultiplikator automatisch auf 100% zurücksetzt.

**QUERY_FILAMENT_WIDTH** enthält in seiner Ausgabe auch den aktuellen Status der Durchflusskompensation.

## Protokollierung

Standardmäßig ist die Durchmesseraufzeichnung beim Einschalten deaktiviert.

Geben Sie den Befehl **ENABLE_FILAMENT_WIDTH_LOG** aus, um die Protokollierung zu starten, und **DISABLE_FILAMENT_WIDTH_LOG**, um sie zu stoppen. Um die Protokollierung beim Einschalten zu aktivieren, setzen Sie den Parameter `logging` auf `true`.

Der Filamentdurchmesser wird bei jedem Messintervall protokolliert (standardmäßig 10 mm).
