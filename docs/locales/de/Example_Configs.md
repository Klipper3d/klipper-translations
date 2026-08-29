# Beispielkonfigurationen

Dieses Dokument enthält Richtlinien für das Einbringen einer Klipper-Beispielkonfiguration in das Klipper-Github-Repository (zu finden im [config-Verzeichnis](../config/)).

Beachten Sie, dass der [Klipper Community Discourse Server](https://community.klipper3d.org) auch eine nützliche Ressource ist, um Konfigurationsdateien zu finden und zu teilen.

## Richtlinien

1. Wählen Sie das passende Präfix für den Konfigurationsdateinamen:
   1. Das Präfix `printer` wird für Seriendrucker verwendet, die von einem etablierten Hersteller vertrieben werden.
   1. Das Präfix `generic` wird für eine 3D-Druckerplatine verwendet, die in vielen unterschiedlichen Druckertypen eingesetzt werden kann.
   1. Das Präfix `kit` steht für 3D-Drucker, die nach einer weit verbreiteten Spezifikation aufgebaut werden. Diese "Kit"-Drucker unterscheiden sich in der Regel dadurch von normalen "Druckern", dass sie nicht von einem Hersteller vertrieben werden.
   1. Das Präfix `sample` wird für Konfigurationsschnipsel verwendet, die man in die Hauptkonfigurationsdatei kopieren kann.
   1. Das Präfix `example` dient der Beschreibung von Druckerkinematiken. Diese Art von Konfiguration wird üblicherweise nur zusammen mit dem Code für eine neue Art von Druckerkinematik ergänzt.
1. Alle Konfigurationsdateien müssen auf `.cfg` enden. Die `printer`-Konfigurationsdateien müssen auf eine Jahreszahl gefolgt von `.cfg` enden (z. B. `-2019.cfg`). Die Jahreszahl gibt dabei ungefähr das Jahr an, in dem der jeweilige Drucker verkauft wurde.
1. Verwenden Sie im Konfigurationsdateinamen keine Leerzeichen oder Sonderzeichen. Der Dateiname sollte ausschließlich die Zeichen `A-Z`, `a-z`, `0-9`, `-` und `.` enthalten.
1. Klipper muss Beispielkonfigurationsdateien der Typen `printer`, `generic` und `kit` fehlerfrei starten können. Diese Konfigurationsdateien sollten dem Regressionstestfall [test/klippy/printers.test](../test/klippy/printers.test) hinzugefügt werden. Fügen Sie neue Konfigurationsdateien diesem Testfall im passenden Abschnitt und dort in alphabetischer Reihenfolge hinzu.
1. Die Beispielkonfiguration sollte die "Serienkonfiguration" des Druckers abbilden. (Es gibt zu viele "angepasste" Konfigurationen, um sie im Haupt-Repository von Klipper zu pflegen.) Ebenso nehmen wir nur Beispielkonfigurationen für Drucker, Kits und Platinen auf, die eine breite Verbreitung haben (es sollten also mindestens 100 davon aktiv im Einsatz sein). Für andere Konfigurationen bietet sich der [Klipper Community Discourse Server](https://community.klipper3d.org) an.
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. Geben Sie in einer Beispielkonfiguration kein `pressure_advance` an, da dieser Wert vom Filament abhängt und nicht von der Druckerhardware. Geben Sie ebenso keine Einstellungen `max_extrude_only_velocity` oder `max_extrude_only_accel` an.
   1. Geben Sie keinen Konfigurationsabschnitt an, der einen Pfad oder Hardware des Hosts enthält. Geben Sie zum Beispiel keine Abschnitte `[virtual_sdcard]` oder `[temperature_host]` an.
   1. Definieren Sie nur Makros, die Funktionen nutzen, die für den betreffenden Drucker spezifisch sind, oder die G-Codes abbilden, die von für diesen Drucker konfigurierten Slicern üblicherweise gesendet werden.
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. Kopieren Sie die Dokumentation der Felder nicht in die Beispielkonfigurationsdateien. (Das würde einen Wartungsaufwand erzeugen, da eine Aktualisierung der Dokumentation dann an vielen Stellen nachgezogen werden müsste.)
   1. Beispielkonfigurationsdateien sollten keinen Abschnitt "SAVE_CONFIG" enthalten. Kopieren Sie bei Bedarf die betreffenden Felder aus dem SAVE_CONFIG-Abschnitt in den passenden Abschnitt des Hauptkonfigurationsbereichs.
   1. Verwenden Sie die Syntax `field: value` anstelle von `field=value`.
   1. Beim Angeben eines `rotation_distance` für den Extruder ist es vorzuziehen, ein `gear_ratio` anzugeben, sofern der Extruder ein Getriebe besitzt. Wir erwarten, dass der rotation_distance in den Beispielkonfigurationen dem Umfang des gerändelten Förderrads im Extruder entspricht - üblicherweise liegt er im Bereich von 20 bis 35 mm. Beim Angeben eines `gear_ratio` ist es vorzuziehen, die tatsächlichen Zahnräder des Getriebes anzugeben (also `gear_ratio: 80:20` statt `gear_ratio: 4:1`). Weitere Informationen finden Sie im [Dokument zur Rotationsdistanz](Rotation_Distance.md#using-a-gear_ratio).
   1. Vermeiden Sie es, Feldwerte anzugeben, die dem Standardwert entsprechen. So sollte man zum Beispiel `min_extrude_temp: 170` nicht angeben, da dies bereits der Standardwert ist.
   1. Wenn möglich, sollten die Zeilen nicht länger als 80 Spalten sein.
   1. Vermeiden Sie es, Urheberangaben oder Änderungshinweise in die Konfigurationsdateien aufzunehmen. (Vermeiden Sie zum Beispiel Zeilen wie "diese Datei wurde erstellt von ...".) Urheberangaben und Änderungshistorie gehören in die Git-Commit-Nachricht.
1. Verwenden Sie in der Beispielkonfigurationsdatei keine veralteten Funktionen.
1. Deaktivieren Sie in einer Beispielkonfigurationsdatei kein standardmäßiges Sicherheitssystem. So sollte eine Konfiguration zum Beispiel keinen abweichenden `max_extrude_cross_section` angeben. Aktivieren Sie keine Debugging-Funktionen. Es sollte zum Beispiel keinen Abschnitt `force_move` geben.
1. Alle bekannten von Klipper unterstützten Platinen können die Standard-Baudrate von 250000 verwenden. Empfehlen Sie in einer Beispielkonfigurationsdatei keine andere Baudrate.

Beispielkonfigurationsdateien werden durch das Erstellen eines GitHub Pull Requests eingereicht. Befolgen Sie dabei bitte auch die Hinweise im [Dokument zum Mitwirken](CONTRIBUTING.md).
