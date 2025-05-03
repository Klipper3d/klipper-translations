# Veröffentlichungen

Historie der Klipper-Versionen. Bitte lesen Sie [installation](Installation.md) für Informationen zur Installation von Klipper.

## Klipper 0.13.0

Available on 20250411. Major changes in this release:

* New "sweeping vibrations" resonance testing mechanism for input shaper.
* Fans and GPIO pins can now be assigned a formula (via Jinja2 "templates").
* The bed_mesh code now supports "adaptive bed mesh". The area probed can be adjusted for the size of the print.
* A new `minimum_cruise_ratio` kinematic parameter has been added (it replaces the previous `max_accel_to_decel` parameter).
* Several new sensors added:
   * Support for ldc1612 "eddy" current sensors. This includes probing support, fast "scan" probing, and temperature calibration.
   * New support for "load cell" measurements. Support for connecting these load cells to hx71x and ads1220 ADC sensors.
   * Support for BMP180, BMP388, and SHT3x temperature sensors. Support for measuring temperature with ADS1x1x ADC chips.
   * New lis3dh and icm20948 accelerometer support.
   * Support for mt6816 and mt6826s "hall angle" sensors.
* New micro-controller improvements:
   * New support for rp2350 micro-controllers.
   * Existing rp2040 chips now run at 200MHz (up from 125Mhz).
   * The micro-controller code can now define many more commands (up to 16384 from 128).
* Other modules added: aip31068_spi, canbus_stats, error_mcu, garbage_collection, pwm_cycle_time, pwm_tool, garbage_collection.
* Mehrere Fehlerkorrekturen und Code-Bereinigungen.

## Klipper 0.12.0

Available on 20231110. Major changes in this release:

* Support for COPY and MIRROR modes on IDEX printers.
* Several micro-controller improvements:
   * Support for new ar100 and hc32f460 architectures.
   * Support for stm32f7, stm32g0b0, stm32g07x, stm32g4, stm32h723, n32g45x, samc21, and samd21j18 chip variants.
   * Improved DFU and Katapult reboot handling.
   * Improved performance on USB to CANbus bridge mode.
   * Improved performance on "linux mcu".
   * New support for software based i2c.
* New hardware support for tmc2240 stepper motor drivers, lis2dw12 accelerometers, and aht10 temperature sensors.
* New axis_twist_compensation and temperature_combined modules added.
* New support for gcode arcs in XY, XZ, and YZ planes.
* Mehrere Fehlerkorrekturen und Code-Bereinigungen.

## Klipper 0.11.0

Verfügbar ab 28.11.2022. Wichtige Änderungen in dieser Version:

* Optimierung des Trinamic Schrittmotortreibers "step on both edges".
* Unterstützung für Python3. Der Klipper-Host-Code läuft entweder mit Python2 oder Python3.
* Verbesserte CAN Bus-Unterstützung. Unterstützung für CAN Bus auf rp2040, stm32g0, stm32h7, same51 und same54 Chips. Unterstützung für den Modus "USB zu CAN Bus Brücke".
* Unterstützung für CanBoot Bootloader.
* Unterstützung für mpu9250 und mpu6050 Beschleunigungsmesser.
* Verbesserte Fehlerbehandlung für max31856, max31855, max31865 und max6675 Temperatursensoren.
* Es ist jetzt möglich, LEDs so zu konfigurieren, dass sie bei lang laufenden G-Code-Befehlen aktualisiert werden, indem LED "Vorlagen" unterstützt werden.
* Verschiedene Verbesserungen bei Mikrocontrollern. Neue Unterstützung für stm32h743, stm32h750, stm32l412, stm32g0b1, same70, same51, und same54 Chips. Unterstützung für i2c Lesevorgänge auf atsamd und stm32f0. Hardware pwm Unterstützung auf stm32. Linux mcu signalbasierter Ereignisversand. Neue rp2040 Unterstützung für "make flash", i2c und rp2040-e5 USB errata.
* Neue Module hinzugefügt: angle, dac084S085, exclude_object, led, mpu9250, pca9632, smart_effector, z_thermal_adjust. Neue deltesische Kinematik hinzugefügt. Neues Werkzeug dump_mcu hinzugefügt.
* Mehrere Fehlerkorrekturen und Code-Bereinigungen.

## Klipper 0.10.0

Verfügbar ab 29.09.2021. Wichtige Änderungen in dieser Version:

* Unterstützung für "Multi-MCU Homing". Es ist jetzt möglich, einen Schrittmotor und seinen Endanschlag mit separaten Mikrocontrollern zu verdrahten. Dies vereinfacht die Verdrahtung von Z Proben auf sogenannten "toolhead boards".
* Klipper hat jetzt einen [Community Discord Server](https://discord.klipper3d.org) und einen [Community Discourse Server](https://community.klipper3d.org).
* Die [Klipper-Webseite](https://www.klipper3d.org) verwendet jetzt die "mkdocs"-Infrastruktur. Es gibt auch ein [Klipper Übersetzungs](https://github.com/Klipper3d/klipper-translations) Projekt.
* Automatische Unterstützung für das Flashen von Firmware über SD-Karten auf vielen Boards.
* Neue kinematische Unterstützung für "Hybrid CoreXY" und "Hybrid CoreXZ" Drucker.
* Klipper verwendet nun `rotation_distance` um die Fahrwege der Schrittmotoren zu konfigurieren.
* Der Klipper Hauptcode kann nun direkt mit Mikrocontrollern über CAN-Bus kommunizieren.
* Neues "motion analysis" System. Klippers interne Bewegungsaktualisierungen und Sensorergebnisse können verfolgt und zur Analyse aufgezeichnet werden.
* Trinamic Schrittmotortreiber werden nun kontinuierlich auf Fehlerzustände überwacht.
* Unterstützung für den Mikrocontroller rp2040 (Raspberry Pi Pico Boards).
* Das "make menuconfig" System verwendet jetzt kconfiglib.
* Viele zusätzliche Module hinzugefügt: ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu
* Mehrere Fehlerkorrekturen und Code-Bereinigungen.

## Klipper 0.9.0

Verfügbar ab 20201020. Bedeutende Änderungen in diesem Release:

* Unterstützung für "Input Shaping" ein Mechanismus, der Druckerresonanzen entgegenwirkt. Er kann das sogenannte"ringing" in Drucken reduzieren oder beseitigen.
* Neues "Smooth Pressure Advance" System. Damit wird "Pressure Advance" ohne unmittelbare Geschwindigkeitsänderungen implementiert. Es ist jetzt auch möglich, "Pressure Advance" mit einer "Tuning Tower" Methode abzustimmen.
* Neuer "webhooks" API Server. Dieser bietet eine programmierbare JSON-Schnittstelle zu Klipper.
* Die LCD-Anzeige und das Menü sind jetzt mit der Vorlagensprache Jinja2 konfigurierbar.
* Die TMC2208 Schrittmotortreiber können jetzt im "standalone" Modus mit Klipper verwendet werden.
* Verbesserte BL-Touch v3-Unterstützung.
* Verbesserte USB-Identifikation. Klipper hat jetzt seinen eigenen USB-Identifikationscode und Mikrocontroller können jetzt ihre eindeutigen Seriennummern während der USB-Identifikation melden.
* Neue kinematische Unterstützung für "Rotary Delta" und "CoreXZ" Drucker.
* Mikrocontroller Verbesserungen: Unterstützung für stm32f070, Unterstützung für stm32f207, Unterstützung für GPIO Pins auf "Linux MCU", stm32 "HID Bootloader" Unterstützung, Chitu Bootloader Unterstützung, MKS Robin Bootloader Unterstützung.
* Verbesserte Behandlung von Python-"garbage collection" Ereignissen.
* Viele weitere Module hinzugefügt: adc_scaled, adxl345, bme280, display_status, extruder_stepper, fan_generic, hall_filament_width_sensor, htu21d, homing_heaters, input_shaper, lm75, print_stats, resonance_tester, shaper_calibrate, query_adc, graph_accelerometer, graph_extruder, graph_motion, graph_shaper, graph_temp_sensor, whconsole
* Mehrere Fehlerkorrekturen und Code-Bereinigungen.

### Klipper 0.9.1

Verfügbar ab 28.10.2020. Diese Version enthält nur Fehlerkorrekturen.

## Klipper 0.8.0

Verfügbar ab 21.10.2019. Wichtige Änderungen in dieser Version:

* Neue Unterstützung für G-Code Befehlsvorlagen. G-Code in der Konfigurationsdatei wird jetzt mit der Jinja2 Vorlagensprache ausgewertet.
* Verbesserungen an Trinamic Schritttreibern:
   * Neue Unterstützung für TMC2209 und TMC5160 Treiber.
   * Verbesserte  DUMP_TMC, SET_TMC_CURRENT, und INIT_TMC G-Code Befehle.
   * Verbesserte Unterstützung für die Handhabung von TMC UART mit einem analogen mux.
* Verbessertes "homing", "probing", und "bed leveling" unterstützung :
   * Neue Module manual_probe, bed_screws, screws_tilt_adjust, skew_correction, safe_z_home hinzugefügt.
   * Verbessertes "multi-sample probing" mit Median-, Durchschnitts- und Wiederholungslogik.
   * Verbesserte Dokumentation für BL-Touch, probe Kalibrierung, Endstop Kalibrierung, Delta Kalibrierung, Sensorloses homing und Endstop Phasenkalibrierung.
   * Verbesserte "homing" auf einer großen Z-Achse.
* Viele Klipper Mikrocontroller Verbesserungen:
   * Klipper portiert auf: SAM3X8C, SAM4S8C, SAMD51, STM32F042, STM32F4
   * Neue USB CDC Treiber Implementierungen auf SAM3X, SAM4, STM32F4.
   * Verbesserte Unterstützung für das Flashen von Klipper über USB.
   * Software SPI-Unterstützung.
   * Deutlich verbesserte Temperaturfilterung für LPC176x.
   * Ausgangs Pin Einstellungen können im Mikrocontroller konfiguriert werden.
* Neue Webseite mit der Klipper-Dokumentation: http://klipper3d.org/
   * Klipper hat jetzt ein Logo.
* Experimentelle Unterstützung für "polar" und "Kabelwinden" Kinematik.
* Die config Datei kann jetzt andere config Dateien enthalten.
* Viele weitere Module hinzugefügt: board_pins, controller_fan, delayed_gcode, dotstar, filament_switch_sensor, firmware_retraction, gcode_arcs, gcode_button, heater_generic, manual_stepper, mcp4018, mcp4728, neopixel, pause_resume, respond, temperature_sensor tsl1401cl_filament_width_sensor, tuning_tower
* Viele weitere Befehle wurden hinzugefügt: RESTORE_GCODE_STATE, SAVE_GCODE_STATE, SET_GCODE_VARIABLE, SET_HEATER_TEMPERATURE, SET_IDLE_TIMEOUT, SET_TEMPERATURE_FAN_TARGET
* Mehrere Fehlerkorrekturen und Code-Bereinigungen.

## Klipper 0.7.0

Verfügbar ab 20.12.2018. Wichtige Änderungen in dieser Version:

* Klipper unterstützt jetzt "mesh" Bett Nivellierung
* Neue Unterstützung für "verbesserte" Delta Kalibrierung (kalibriert Druck x/y Dimensionen auf Delta-Drucker)
* Unterstützung für die Laufzeitkonfiguration von Trinamic Schrittmotortreibern (tmc2130, tmc2208, tmc2660)
* Verbesserte Unterstützung von Temperatursensoren: MAX6675, MAX31855, MAX31856, MAX31865, benutzerdefinierte Thermistoren, gängige pt100-Sensoren
* Mehrere neue Module: temperature_fan, sx1509, force_move, mcp4451, z_tilt, quad_gantry_level, endstop_phase, bltouch
* Mehrere neue Befehle hinzugefügt: SAVE_CONFIG, SET_PRESSURE_ADVANCE, SET_GCODE_OFFSET, SET_VELOCITY_LIMIT, STEPPER_BUZZ, TURN_OFF_HEATERS, M204, benutzerdefinierte G-Code Makros
* Erweiterte LCD-Anzeigen Unterstützung:
   * Unterstützung für Laufzeitmenüs
   * Neue Anzeigensymbole
   * Unterstützung für "uc1701" und "ssd1306" Displays
* Zusätzliche Mikrocontroller Unterstützung:
   * Klipper portiert auf: LPC176x (Smoothieboards), SAM4E8E (Duet2), SAMD21 (Arduino Zero), STM32F103 ("Blue pill" Geräte), atmega32u4
   * Neue generische USB CDC Treiber implementiert auf AVR, LPC176x, SAMD21 und STM32F103
   * Leistungsverbesserungen auf ARM-Prozessoren
* Der Kinematik Code wurde umgeschrieben, um einen "iterativen Problemlöser" zu verwenden.
* Neue automatische Testverfahren für die Klipper-Host-Software
* Viele neue Beispiel Konfigurationsdateien für handelsübliche Drucker
* Aktualisierte Dokumentation für Bootloader, Benchmarking, Portierung von Mikrocontrollern, Konfigurationsprüfungen, Pin Mapping, Slicer-Einstellungen, "packaging" und mehr
* Verschiedene Fehlerbehebungen und Codebereinigungen

## Klipper 0.6.0

Verfügbar ab 31.03.2018. Wichtige Änderungen in dieser Version:

* Verbesserte Hardware Fehlerprüfung für Heizelemente und Temperatursensoren
* Unterstützung für Z Sonden (Z probes)
* Erstmalige Unterstützung für die automatische Parameterkalibrierung für Delta Drucker (über einen neuen Befehl delta_calibrate)
* Erstmalige Unterstützung für die Kompensation der Bettneigung (über den Befehl bed_tilt_calibrate)
* Erstmalige Unterstützung von "safe homing" und "homing overrides"
* Erstmalige Unterstützung für die Anzeige des Status auf "RepRapDiscount" Displays in der Ausführung 2004 und 12864
* Neue Multiextruder Verbesserungen:
   * Unterstützung für gemeinsame Heizelemente
   * Erstmalige Unterstützung für Doppelwagen (dual carriages)
* Unterstützung für die Konfiguration von mehreren Schrittmotoren pro Achse (z.B. Dual Z)
* Unterstützung für benutzerdefinierte digitale und pwm Ausgangspins (mit einem neuen SET_PIN Befehl)
* Erstmalige Unterstützung für eine "virtuelle SD-Karte", die das Drucken direkt von Klipper aus ermöglicht (hilft auf Rechnern, die zu langsam sind, um OctoPrint auszuführen)
* Unterstützung für die Einstellung unterschiedlicher "Armlängen" der einzelnen Säulen eines Deltas Druckers
* Unterstützung für G-Code M220/M221 Befehle (speed factor override / extrude factor override)
* Mehrere Dokumentations Updates:
   * Viele neue Beispiel Konfigurationsdateien für handelsübliche Drucker
   * Neues Beispiel für die Konfiguration mehrerer MCUs
   * Neues Beispiel für die Konfiguration des bltouch-Sensors
   * Neues FAQ, Konfigurationsprüfung und G-Code-Dokumente
* Erstmalige Unterstützung für kontinuierliche Integrationstests für alle Github Beiträge
* Verschiedene Fehlerbehebungen und Codebereinigungen

## Klipper 0.5.0

Verfügbar ab 25.10.2017. Wichtige Änderungen in dieser Version:

* Unterstützung für Drucker mit mehreren Extrudern.
* Erstmalige Unterstützung für den Betrieb auf Beaglebone PRU. Erstmalige Unterstützung für das Replicape-Board.
* Erstmalige Unterstützung für die Ausführung des Mikrocontroller Codes in einem Echtzeit Linux-Prozess.
* Unterstützung für mehrere Mikrocontroller. (Zum Beispiel könnte man einen Extruder mit einem Mikrocontroller und den Rest des Druckers mit einem anderen steuern). Software Taktsynchronisierung ist implementiert, um Aktionen zwischen Mikrocontrollern zu koordinieren.
* Verbesserte Schrittmotorenleistung (20Mhz AVRs mit bis zu 189K Schritten pro Sekunde).
* Unterstützung für die Steuerung von Servos und Unterstützung für die Einrichtung von Düsenlüftern.
* Verschiedene Fehlerbehebungen und Codebereinigungen

## Klipper 0.4.0

Verfügbar ab 03.05.2017. Wichtige Änderungen in dieser Version:

* Verbesserte Installation auf Raspberry Pi Maschinen. Der größte Teil der Installation ist jetzt skriptgesteuert.
* Unterstützung für corexy Kinematik
* Aktualisierte Dokumentation: Neues Kinematik Dokument, neue Pressure Advance Tuning Anleitung, neue Beispiel Konfigurationsdateien und mehr
* Verbesserung der Schrittmotorenleistung (20Mhz AVRs über 175K Schritte pro Sekunde, Arduino Due über 460K)
* Unterstützung für automatische Mikrocontroller Resets. Unterstützung für Resets durch Umschalten der USB Stromversorgung am Raspberry Pi.
* Der Algorithmus für "pressure advance" arbeitet jetzt mit "look-ahead", um Druckschwankungen bei Kurvenfahrten zu reduzieren.
* Unterstützung für die Begrenzung der Höchstgeschwindigkeit von kurzen Zickzack-Bewegungen
* Unterstützung für AD595 Sensoren
* Verschiedene Fehlerbehebungen und Codebereinigungen

## Klipper 0.3.0

Verfügbar ab 23.12.2016. Wichtige Änderungen in dieser Version:

* Verbesserte Dokumentation
* Unterstützung für Roboter mit Delta-Kinematik
* Unterstützung für Arduino Mikrocontroller (ARM cortex-M3)
* Unterstützung für USB basierte AVR-Mikrocontroller
* Unterstützung für den Algorithmus "pressure advance" - er reduziert das herausquellen während des Drucks.
* Neue Funktion "stepper phased based endstop" - ermöglicht eine höhere Präzision bei der Ansteuerung des Endstopps.
* Unterstützung für "erweiterte g-code" Befehle wie "help", "restart", und "status".
* Unterstützung für das Neuladen der Klipper Konfiguration und den Neustart der Host Software durch einen "restart" Befehl vom Terminal aus.
* Verbesserte Schrittmotorenleistung (20Mhz AVRs bis zu 158K Schritte pro Sekunde).
* Verbesserte Fehlermeldungen. Die meisten Fehler werden jetzt über das Terminal angezeigt, zusammen mit Hinweisen zur Behebung.
* Verschiedene Fehlerbehebungen und Codebereinigungen

## Klipper 0.2.0

Erste Veröffentlichung von Klipper. Verfügbar ab 25.05.2016. Zu den wichtigsten Funktionen der ersten Version gehören:

* Grundlegende Unterstützung für kartesische Drucker (Stepper, Extruder, Heizbett, Kühlgebläse).
* Unterstützung für gängige G-Code Befehle. Unterstützung für die Verbindung mit OctoPrint.
* Beschleunigung und Handhabung von Lookahead
* Unterstützung für AVR-Mikrocontroller über serielle Standardschnittstellen
