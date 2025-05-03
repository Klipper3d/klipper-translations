# Funktionen

Klipper hat viele überzeugende Funktionen:

* High precision stepper movement. Klipper utilizes an application processor (such as a low-cost Raspberry Pi) when calculating printer movements. The application processor determines when to step each stepper motor, it compresses those events, transmits them to the micro-controller, and then the micro-controller executes each event at the requested time. Each stepper event is scheduled with a precision of 25 micro-seconds or better. The software does not use kinematic estimations (such as the Bresenham algorithm) - instead it calculates precise step times based on the physics of acceleration and the physics of the machine kinematics. More precise stepper movement provides quieter and more stable printer operation.
* Best in class performance. Klipper is able to achieve high stepping rates on both new and old micro-controllers. Even old 8-bit micro-controllers can obtain rates over 175K steps per second. On more recent micro-controllers, several million steps per second are possible. Higher stepper rates enable higher print velocities. The stepper event timing remains precise even at high speeds which improves overall stability.
* Klipper unterstützt Drucker mit mehreren Mikrocontrollern. Beispielsweise könnte ein Mikrocontroller einen Extruder steuern und ein anderer die Heizelemente, während ein Dritter die restlichen Funktionen des Druckers steuert. Die Klipper Host-Anwendung synchronisiert den Takt der Mikrocontroller, um Taktschwankungen zwischen Mikrocontrollern auszugleichen. Um mehrere Mikrocontroller zu verwenden müssen lediglich einige Zeilen in der Konfigurationsdatei eingefügt werden.
* Konfiguration über eine einfache Konfigurationsdatei. Es besteht keine Notwendigkeit, den Mikrocontroller neu zu flashen, um eine Einstellung zu ändern. Die gesamte Konfiguration von Klipper wird in einer Standard-Konfigurationsdatei gespeichert, die einfach bearbeitet werden kann. Das macht die Einrichtung und Wartung der Hardware einfacher.
* Klipper unterstützt "Smooth Pressure Advance" - einen Mechanismus, der die Auswirkungen von Druck innerhalb eines Extruders berücksichtigt. Dadurch wird das "Oozing " des Extruders reduziert und die Qualität der Druckecken verbessert. Die Implementierung von Klipper führt nicht zu sofortigen Änderungen der Extrudergeschwindigkeit, was die Gesamtstabilität und Robustheit verbessert.
* Klipper unterstützt "Input Shaping", um die Auswirkungen von Vibrationen auf die Druckqualität zu reduzieren. Dies kann "Ringing" (auch bekannt als "Ghosting", "Echoing" oder "Rippling") in Drucken reduzieren oder eliminieren. Es kann auch eine höhere Druckgeschwindigkeit bei gleichbleibender Druckqualität ermöglichen.
* Klipper verwendet einen "iterative solver", um präzise Schrittzeiten aus einfachen kinematischen Gleichungen zu berechnen. Das macht die Portierung von Klipper auf neue Robotertypen einfacher und die Zeitmessung bleibt auch bei komplexer Kinematik präzise (es ist keine "Liniensegmentierung" erforderlich).
* Klipper is hardware agnostic. One should get the same precise timing independent of the low-level electronics hardware. The Klipper micro-controller code is designed to faithfully follow the schedule provided by the Klipper host software (or prominently alert the user if it is unable to). This makes it easier to use available hardware, to upgrade to new hardware, and to have confidence in the hardware.
* Tragbarer Code. Klipper funktioniert auf ARM-, AVR- und PRU-basierten Mikrocontrollern. Bestehende Drucker im "Reprap"-Stil können Klipper ohne Hardware-Modifikation betreiben - fügen Sie einfach einen Raspberry Pi hinzu. Das interne Code-Layout von Klipper macht es einfacher, auch andere Mikrocontroller-Architekturen zu unterstützen.
* Einfacherer Code. Klipper verwendet Python für den Großteil des Codes. Die Kinematik-Algorithmen, das Parsen des G-Codes, die Heiz- und Thermistor-Algorithmen usw. sind alle in Python geschrieben. Das macht es einfacher, neue Funktionen zu entwickeln.
* Benutzerdefinierte programmierbare Makros. Neue G-Code-Befehle können in der Druckerkonfigurationsdatei definiert werden (es sind keine Codeänderungen erforderlich). Diese Befehle sind programmierbar, so dass sie je nach Zustand des Druckers unterschiedliche Aktionen auslösen können.
* Eingebauter API-Server. Zusätzlich zur Standard-G-Code-Schnittstelle unterstützt Klipper eine umfangreiche JSON-basierte Anwendungsschnittstelle. Dies ermöglicht es Programmierern, externe Anwendungen mit detaillierter Kontrolle über den Drucker zu erstellen.

## Zusätzliche Funktionen

Klipper unterstützt viele Standard-3D-Druckerfunktionen:

* Mehrere Web-Schnittstellen verfügbar. Funktioniert mit Mainsail, Fluidd, OctoPrint und anderen. Dadurch kann der Drucker über einen normalen Webbrowser gesteuert werden. Derselbe Raspberry Pi, auf dem Klipper läuft, kann auch die Weboberfläche ausführen.
* Standard-G-Code-Unterstützung. Gängige G-Code-Befehle, die von typischen "Slicern" (SuperSlicer, Cura, PrusaSlicer, etc.) erzeugt werden, werden unterstützt.
* Unterstützung für mehrere Extruder. Extruder mit geteilten Heizelementen und Extruder auf unabhängigen Schlitten (IDEX) werden ebenfalls unterstützt.
* Unterstützung für cartesian, delta, corexy, corexz, hybrid-corexy, hybrid-corexz, deltesian, rotary delta, polar, und cable winch style Drucker.
* Automatic bed leveling support. Klipper can be configured for basic bed tilt detection or full mesh bed leveling. The bed mesh can be customized to the print size (adaptive bed mesh). If the bed uses multiple Z steppers then Klipper can also level by independently manipulating the Z steppers. Most Z height probes are supported, including BL-Touch probes and servo activated probes. Probes may be calibrated for axis twist compensation. If using an "eddy current probe" then one can utilize fast bed mesh scanning,
* Automatic delta calibration support. The calibration tool can perform basic height calibration as well as an enhanced X and Y dimension calibration. The calibration can be done with a Z height probe or via manual probing.
* Run-time "exclude object" support. When configured, this module may facilitate canceling of just one object in a multi-part print.
* Support for common temperature sensors (eg, common thermistors, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20, AHT10, SHT3x, and LM75). Custom thermistors and custom analog temperature sensors can also be configured. One can monitor the internal micro-controller temperature sensor and the internal temperature sensor of a Raspberry Pi.
* Einfache Schutzfunktion für Heizelemente, standardmäßig aktiviert.
* Support for standard fans, nozzle fans, and temperature controlled fans. No need to keep fans running when the printer is idle. Fan speed can be monitored on fans that have a tachometer. One can assign a "math formula" to a fan for automatic fan speed updating.
* Support for run-time configuration of TMC2130, TMC2208/TMC2224, TMC2209, TMC2660, and TMC5160 stepper motor drivers. There is also support for current control of traditional stepper drivers via AD5206, DAC084S085, MCP4451, MCP4728, MCP4018, and PWM pins.
* Unterstützung für gängige LCD-Displays, die direkt an den Drucker angeschlossen werden. Ein Standardmenü ist ebenfalls verfügbar. Der Inhalt der Anzeige und des Menüs kann über die Konfigurationsdatei vollständig angepasst werden.
* Constant acceleration and "look-ahead" support. All printer moves will gradually accelerate from standstill to cruising speed and then decelerate back to a standstill. The incoming stream of G-Code movement commands are queued and analyzed - the acceleration between movements in a similar direction will be optimized to reduce print stalls and improve overall print time.
* Klipper implementiert einen "Stepper-Phase-Endstop"-Algorithmus, der die Genauigkeit typischer Endstop-Schalter verbessern kann. Wenn er richtig eingestellt ist, kann er die Haftung der ersten Schicht des Druckbetts verbessern.
* Support for filament presence sensors, filament motion sensors, and filament width sensors.
* Support for measuring and recording acceleration using adxl345, mpu9250, mpu6050, lis2dw12, lis3dh, and icm20948 accelerometers.
* Unterstützung für die Begrenzung der Höchstgeschwindigkeit von kurzen "Zickzack"-Bewegungen, um Druckervibrationen und Geräusche zu reduzieren. Weitere Informationen finden Sie im Dokument [kinematics](Kinematics.md).
* Für viele gängige Drucker sind Beispielkonfigurationsdateien verfügbar. Eine Liste finden Sie im [config-Verzeichnis](../config/).

Um mit Klipper zu beginnen, lesen Sie die [installation](Installation.md) Anleitung.

## Schritt Benchmarks

Nachfolgend sind die Ergebnisse der Stepper-Leistungstests aufgeführt. Die angegebenen Zahlen stellen die Gesamtzahl der Schritte pro Sekunde auf dem Mikrocontroller dar.

| Mikrocontroller | 1 Schrittmotor aktiv | 3 Schrittmotoren aktiv |
| --- | --- | --- |
| 16Mhz AVR | 157K | 99K |
| 20Mhz AVR | 196K | 123K |
| SAMD21 | 686K | 471K |
| STM32F042 | 814K | 578K |
| Beaglebone PRU | 866K | 708K |
| STM32G0B1 | 1103K | 790K |
| STM32F103 | 1180K | 818K |
| SAM3X8E | 1273K | 981K |
| SAM4S8C | 1690K | 1385K |
| LPC1768 | 1923K | 1351K |
| LPC1769 | 2353K | 1622K |
| SAM4E8E | 2500K | 1674K |
| SAMD51 | 3077K | 1885K |
| AR100 | 3529K | 2507K |
| STM32F407 | 3652K | 2459K |
| STM32F446 | 3913K | 2634K |
| RP2040 | 4000K | 2571K |
| RP2350 | 4167K | 2663K |
| SAME70 | 6667K | 4737K |
| STM32H723 | 7429K | 8619K |

Wenn Sie sich nicht sicher sind, welcher Mikrocontroller auf einem bestimmten Board installiert ist, suchen Sie die entsprechende [config-Datei](../config/) und suchen Sie den Namen des Mikrocontrollers in den Kommentaren am Anfang der Datei.

Weitere Einzelheiten zu den Benchmarks finden Sie im Dokument [Benchmarks](Benchmarks.md).
