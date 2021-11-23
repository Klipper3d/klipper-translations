# Übersicht

Willkommen auf der Klipper-Dokumentationsseite! Wenn Klipper für dich neu ist, starte doch einfach mit den [Features](Features.md) und den [Installations-Dokumenten](Installation.md).

## Übersicht

- [Features](Features.md): Eine grobe Übersicht über die Features von Klipper.
- [FAQ](FAQ.md): Häufig gestellte Fragen.
- [Releases](Releases.md): Veröffentlichungshistorie von Klipper.
- [Config changes](Config_Changes.md): Die neuesten Änderungen, die potentielle Änderungen an der Konfigurationsdatei des Druckers auslösen können.
- [Contact](Contact.md): Kontaktinformationen bei Fehlern oder Anfragen an die Klipper-Entwickler.

## Installation und Konfiguration

- [Installation](Installation.md): Anleitung zur Installation von Klipper.
- [Config Reference](Config_Reference.md): Beschreibung der Einstellmöglichkeiten.
   - [Rotation Distance](Rotation_Distance.md): Berechnung des Schrittmotor-Parameters rotation_distance.
- [Config checks](Config_checks.md): Überprüfung der grundlegenden Pin-Einstellungen in der Konfigurationsdatei.
- [Bed level](Bed_Level.md): Informationen über "bed leveling" in Klipper.
   - [Delta calibrate](Delta_Calibrate.md): Kalibrierung der Delta-Kinematik.
   - [Probe calibrate](Probe_Calibrate.md): Kalibrierung von automatischen Z-Sonden.
   - [BL-Touch](BLTouch.md): Einrichten einer "BL-Touch" Z-Sonde.
   - [Manuelles Leveln](Manual_Level.md): Kalibrierung der Z-Endstopps (und ähnlichem).
   - [Bed Mesh](Bed_Mesh.md): Betthöhenkorrektion basierend auf XY Koordinaten.
   - [Endstop phase](Endstop_Phase.md): Z-Endstopp-Positionierung mithilfe von Steppermotoren.
- [Resonance compensation](Resonance_Compensation.md): Ein Werkzeug zum reduzieren von Ringing in Drucken.
   - [Measuring resonances](Measuring_Resonances.md): Informationen über das Verwenden von adxl345-Beschleunigungssensoren um Resonanz zu messen.
- [Pressure advance](Pressure_Advance.md): Extruder-Druck kalibrieren.
- [G-Codes](G-Codes.md): Informationen zu unterstützten Kommandos in Klipper.
- [Command Templates](Command_Templates.md): G-Code Makros und bedingte Evaluierung.
   - [Status Reference](Status_Reference.md): Informationen zu verfügbaren Makros (und ähnlichem).
- [TMC Drivers](TMC_Drivers.md): Trinamic-Steppermotor-Treiber mit Klipper verwenden.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing und Probing mithilfe mehrerer Mikrocontroller.
- [Slicers](Slicers.md): "Slicer"-Software für Klipper einrichten.
- [Skew correction](Skew_Correction.md): Adjustments for axes not perfectly square.
- [PWM tools](Using_PWM_Tools.md): Anleitung zum Verwenden von PWM-gesteuerten Werkzeugen (bspw. Laser oder Spindeln).

## Entwicklerdokumentation

- [Code overview](Code_Overview.md): Entwickler sollten dies zuerst lesen.
- [Kinematics](Kinematics.md): Technische Details zur Implementierung von Bewegungen in Klipper.
- [Protocol](Protocol.md): Informationen über das low-level Nachrichtenprotokoll zwischen Host und Mikrocontroller.
- [API Server](API_Server.md): Informationen über Klipper's Kommando- und Steuerungs-API.
- [MCU commands](MCU_Commands.md): Eine Beschreibung von low-level Kommandos, die in der Mikrocontroller-Software implementiert sind.
- [CAN bus protocol](CANBUS_protocol.md): Klipper's CAN-Bus Nachrichtenformat.
- [Debugging](Debugging.md): Informationen über das Testen und Debuggen von Klipper.
- [Benchmarks](Benchmarks.md): Informationen über die Klipper Benchmark-Methode.
- [Contributing](CONTRIBUTING.md): Informationen über das Einreichen von Verbesserungen von Klipper.
- [Packaging](Packaging.md): Informationen über das Kompilieren von Betriebssystem-Paketen.

## Geräteabhängige Dokumente

- [Example configs](Example_Configs.md): Informationen über das Hinzufügen von Beispiel-Konfigurationsdateien zu Klipper.
- [SDCard Updates](SDCard_Updates.md): Den Mikrocontroller flashen, indem man eine Firmwaredatei auf die SD-Karte kopiert.
- [Raspberry Pi als Mikrocontroller](RPi_microcontroller.md): Details über die Steuerung von Geräten, welche an die Raspberry Pi GPIO-Pins angeschlossen sind.
- [Beaglebone](Beaglebone.md): Details for running Klipper on the Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Entwicklerinformationen über das Flashen von Mikrocontrollern.
- [CAN bus](CANBUS.md): Informationen über die Verwendung des CAN-Bus mit Klipper.
- [TSL1401CL Filamentbreitensensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](Hall_Filament_Width_Sensor.md)
