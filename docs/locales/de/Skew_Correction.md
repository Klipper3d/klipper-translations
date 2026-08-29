# Schräglagenkorrektur

Die softwarebasierte Schräglagenkorrektur kann helfen, Maßungenauigkeiten zu beheben, die sich aus einem nicht perfekt rechtwinkligen zusammenbau ergeben. Beachten Sie, dass es bei einer erheblichen Schräglage Ihres Druckers dringend empfohlen wird, den Drucker zunächst mit mechanischen Mitteln so rechtwinklig wie möglich zu machen, bevor Sie die softwarebasierte Korrektur anwenden.

## Drucken Sie ein Kalibrierungsobjekt

Der erste Schritt zur Korrektur von Achsverdrehung besteht darin, ein [Kalibrierobjekt](https://www.thingiverse.com/thing:2563185/files) entlang der zu korrigierenden Ebene zu drucken. Es gibt außerdem ein [Kalibrierobjekt](https://www.thingiverse.com/thing:2972743), das alle Ebenen in einem Modell vereint. Das Objekt sollte so ausgerichtet sein, dass Ecke A zum Ursprung der Ebene zeigt.

Stellen Sie sicher, dass während dieses Drucks keine Verzerrungskorrektur angewendet wird. Sie können dazu entweder das Modul `[skew_correction]` aus der printer.cfg entfernen oder einen G-Code `SET_SKEW CLEAR=1` ausgeben.

## Führen Sie Ihre Messungen durch

Das Modul `[skew_correction]` benötigt für jede zu korrigierende Ebene 3 Messwerte: die Länge von Ecke A zu Ecke C, die Länge von Ecke B zu Ecke D und die Länge von Ecke A zu Ecke D. Beziehen Sie beim Messen der Länge AD die abgeflachten Stellen an den Ecken, die manche Testobjekte aufweisen, nicht mit ein.

![skew_lengths](img/skew_lengths.png)

## Konfigurieren Sie Ihre Schräglage

Stellen Sie sicher, dass `[skew_correction]` in der printer.cfg enthalten ist. Sie können nun den G-Code `SET_SKEW` verwenden, um skew_correction zu konfigurieren. Wenn zum Beispiel Ihre entlang XY gemessenen Längen wie folgt lauten:

```
Length AC = 140.4
Length BD = 142.8
Length AD = 99.8
```

Mit `SET_SKEW` lässt sich die Verzerrungskorrektur für die XY-Ebene konfigurieren.

```
SET_SKEW XY=140.4,142.8,99.8
```

Sie können dem G-Code auch Messwerte für XZ und YZ hinzufügen:

```
SET_SKEW XY=140.4,142.8,99.8 XZ=141.6,141.4,99.8 YZ=142.4,140.5,99.5
```

Das Modul `[skew_correction]` unterstützt außerdem eine Profilverwaltung ähnlich wie `[bed_mesh]`. Nachdem Sie die Verzerrung mit dem G-Code `SET_SKEW` festgelegt haben, können Sie sie mit dem G-Code `SKEW_PROFILE` speichern:

```
SKEW_PROFILE SAVE=my_skew_profile
```

Nach diesem Befehl werden Sie aufgefordert, einen `SAVE_CONFIG`-G-Code auszugeben, um das Profil dauerhaft zu speichern. Existiert kein Profil namens `my_skew_profile`, wird ein neues Profil erstellt. Existiert das benannte Profil bereits, wird es überschrieben.

Sobald Sie ein gespeichertes Profil haben, können Sie es laden:

```
SKEW_PROFILE LOAD=my_skew_profile
```

Es ist außerdem möglich, ein altes oder veraltetes Profil zu entfernen:

```
SKEW_PROFILE REMOVE=my_skew_profile
```

Nach dem Entfernen eines Profils werden Sie aufgefordert, `SAVE_CONFIG` auszugeben, damit diese Änderung dauerhaft übernommen wird.

## Überprüfung Ihrer Korrektur

Sobald skew_correction konfiguriert wurde, können Sie das Kalibrierteil mit aktivierter Korrektur erneut drucken. Verwenden Sie folgenden G-Code, um die Verzerrung auf jeder Ebene zu prüfen. Die Ergebnisse sollten niedriger ausfallen als die über `GET_CURRENT_SKEW` gemeldeten Werte.

```
CALC_MEASURED_SKEW AC=<ac_length> BD=<bd_length> AD=<ad_length>
```

## Einschränkungen

Aufgrund der Funktionsweise der Verzerrungskorrektur wird empfohlen, die Verzerrung in Ihrem Start-G-Code zu konfigurieren, nach dem Homing und nach jeder Bewegung, die in die Nähe des Randes des Druckbereichs führt, etwa beim Purge oder Düsenwischen. Verwenden Sie dazu die G-Codes `SET_SKEW` oder `SKEW_PROFILE`. Es wird außerdem empfohlen, in Ihrem End-G-Code ein `SET_SKEW CLEAR=1` auszugeben.

Beachten Sie, dass `[skew_correction]` möglicherweise eine Korrektur erzeugt, die das Werkzeug über die Grenzen des Druckers auf der X- und/oder Y-Achse hinausbewegt. Es wird empfohlen, Teile bei Verwendung von `[skew_correction]` mit Abstand zu den Rändern anzuordnen.
