# Objekte ausschließen

The `[exclude_object]` module allows Klipper to exclude objects while a print is in progress. To enable this feature include an [exclude_object config
section](Config_Reference.md#exclude_object) (also see the [command
reference](G-Codes.md#exclude-object) and [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.)

Im Gegensatz zu anderen 3D-Drucker-Firmware-Optionen verwendet ein Drucker, auf dem Klipper läuft, eine Reihe von Komponenten und die Benutzer haben eine Vielzahl an Optionen zur Auswahl. Um eine konsistente Benutzererfahrung zu bieten, wird das Modul `[exclude_object]` eine Art Vertrag oder API einrichten. Der Vertrag regelt den Inhalt der gcode-Datei, wie der interne Zustand des Moduls gesteuert wird und wie dieser Zustand den Clients zur Verfügung gestellt wird.

## Workflow-Übersicht

Ein typischer Workflow um eine Datei zu drucken kann so aussehen:

1. Das Slicen ist abgeschlossen und die Datei wird auf den Drucker geladen. Während des Uploads wird die Datei verarbeitet und `[exclude_object]` Marker werden hinzugefügt. Alternativ können Slicer diese Marker hinzufügen, sofern sie es unterstützen.
1. Wenn der Druck startet setzt Klipper den `[exclude_object]` [Status](Status_Reference.md#exclude_object) zurück.
1. Wenn Klipper den Block `EXCLUDE_OBJECT_DEFINE` verarbeitet, aktualisiert es den Status mit den bekannten Objekten und gibt ihn an Clients weiter.
1. Der Client kann diese Informationen nutzen, um dem Anwender eine Oberfläche zur Fortschrittsverfolgung anzuzeigen. Klipper aktualisiert den Status um das aktuell gedruckte Objekt, das der Client zu Anzeigezwecken verwenden kann.
1. Fordert der Anwender an, dass ein Objekt abgebrochen wird, gibt der Client einen Befehl `EXCLUDE_OBJECT NAME=<name>` an Klipper aus.
1. Verarbeitet Klipper den Befehl, fügt es das Objekt der Liste der ausgeschlossenen Objekte hinzu und aktualisiert den Status für den Client.
1. Der Client erhält den aktualisierten Status von Klipper und kann diese Informationen nutzen, um den Status des Objekts in der Benutzeroberfläche darzustellen.
1. Nach Abschluss des Drucks bleibt der Status von `[exclude_object]` verfügbar, bis eine andere Aktion ihn zurücksetzt.

## Die GCode Datei

Die spezielle G-Code-Verarbeitung, die zur Unterstützung des Ausschließens von Objekten notwendig ist, passt nicht zu den Kerndesignzielen von Klipper. Daher setzt dieses Modul voraus, dass die Datei verarbeitet wird, bevor sie zum Drucken an Klipper gesendet wird. Ein Post-Processing-Skript im Slicer oder eine Middleware, die die Datei beim Hochladen verarbeitet, sind zwei Möglichkeiten, die Datei für Klipper vorzubereiten. Ein Referenz-Post-Processing-Skript ist sowohl als ausführbares Programm als auch als Python-Bibliothek verfügbar, siehe [cancelobject-preprocessor](https://github.com/kageurufu/cancelobject-preprocessor).

### Objektdefinitionen

Der Befehl `EXCLUDE_OBJECT_DEFINE` dient dazu, eine Zusammenfassung jedes zu druckenden Objekts in der G-Code-Datei bereitzustellen. Er liefert eine Zusammenfassung eines Objekts in der Datei. Objekte müssen nicht definiert werden, um von anderen Befehlen referenziert werden zu können. Der Hauptzweck dieses Befehls besteht darin, der Benutzeroberfläche Informationen bereitzustellen, ohne die gesamte G-Code-Datei parsen zu müssen.

Objektdefinitionen sind benannt, damit Anwender leicht ein auszuschließendes Objekt auswählen können, und es können zusätzliche Metadaten bereitgestellt werden, um grafische Abbruchanzeigen zu ermöglichen. Aktuell definierte Metadaten umfassen eine `CENTER`-X,Y-Koordinate sowie eine `POLYGON`-Liste von X,Y-Punkten, die einen minimalen Umriss des Objekts darstellen. Dies kann eine einfache Bounding-Box sein oder eine komplexere Hülle für detailliertere Visualisierungen der gedruckten Objekte. Besonders wenn G-Code-Dateien mehrere Teile mit überlappenden Begrenzungsbereichen enthalten, werden Mittelpunkte visuell schwer unterscheidbar. `POLYGONS` muss ein JSON-kompatibles Array von Punkt-Tupeln `[X,Y]` ohne Leerzeichen sein. Zusätzliche Parameter werden als Strings in der Objektdefinition gespeichert und bei Statusaktualisierungen bereitgestellt.

`EXCLUDE_OBJECT_DEFINE NAME=calibration_pyramid CENTER=50,50 POLYGON=[[40,40],[50,60],[60,40]]`

All available G-Code commands are documented in the [G-Code
Reference](./G-Codes.md#excludeobject)

## Statusinformationen

The state of this module is provided to clients by the [exclude_object
status](Status_Reference.md#exclude_object).

Der Status wird zurückgesetzt, wenn:

- Die Klipper Firmware wird neu gestartet.
- Es gibt einen Reset von `[virtual_sdcard]`. Dieser wird insbesondere von Klipper zu Beginn eines Drucks durchgeführt.
- Wenn ein `EXCLUDE_OBJECT_DEFINE RESET=1` Befehl ausgeführt wird.

Die Liste der definierten Objekte wird im Statusfeld `exclude_object.objects` dargestellt. Bei einer gut aufgebauten G-Code-Datei geschieht dies über `EXCLUDE_OBJECT_DEFINE`-Befehle am Anfang der Datei. Dies liefert Clients Objektnamen und Koordinaten, sodass die Benutzeroberfläche bei Bedarf eine grafische Darstellung der Objekte bereitstellen kann.

Im Verlauf des Drucks wird das Statusfeld `exclude_object.current_object` aktualisiert, während Klipper die Befehle `EXCLUDE_OBJECT_START` und `EXCLUDE_OBJECT_END` verarbeitet. Das Feld `current_object` wird auch gesetzt, wenn das Objekt ausgeschlossen wurde. Undefinierte, mit `EXCLUDE_OBJECT_START` markierte Objekte werden ohne zusätzliche Metadaten den bekannten Objekten hinzugefügt, um die Benutzeroberfläche zu unterstützen.

Werden `EXCLUDE_OBJECT`-Befehle ausgegeben, wird die Liste der ausgeschlossenen Objekte im Array `exclude_object.excluded_objects` bereitgestellt. Da Klipper vorausschauend kommenden G-Code verarbeitet, kann es zu einer Verzögerung zwischen der Ausgabe des Befehls und der Aktualisierung des Status kommen.
