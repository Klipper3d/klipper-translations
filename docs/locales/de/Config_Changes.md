# Konfigurationsänderungen

Dieses Dokument behandelt die jüngsten Softwareänderungen an der Konfigurationsdatei, die nicht abwärtskompatibel sind. Es ist eine gute Idee, dieses Dokument zu lesen, wenn Sie die Klipper-Software aktualisieren.

Alle Daten in diesem Dokument sind ungefähre Angaben.

## Änderungen

20260525: Die interne Implementierung von "probe:z_virtual_endstop" hat sich geändert. Die meisten Benutzer werden keine Verhaltensänderung feststellen. Bisher war es technisch möglich, "probe:z_virtual_endstop" mit anderen Arten von Z-Endschaltern zu kombinieren; dieses Verhalten ist nicht mehr zulässig.

20260501: Die Behandlung der `[probe_eddy_current]`-Konfigurationsoption `tap_threshold` und des zugehörigen G-Code-Parameters `TAP_THRESHOLD` hat sich geändert. Der Wert muss neu kalibriert werden. Eine Anleitung zur Kalibrierung finden Sie in der [Dokumentation zur Wirbelstromsonde](Eddy_Probe.md).

20260408: Das Skript `lib/canboot/flash_can.py` wurde auf die aktuelle Version aus [Katapult](https://github.com/Arksine/katapult) aktualisiert und dabei in `lib/katapult/flashtool.py` umbenannt. Wenn Sie dieses Skript direkt aufrufen, statt die vorhandenen Makefiles zu verwenden, müssen Sie den Pfad zum Skript auf `lib/katapult/flashtool.py` ändern.

20260318: Die `[probe_eddy_current]`-Konfigurationsoptionen `speed`, `lift_speed`, `samples`, `sample_retract_dist`, `samples_result`, `samples_tolerance` und `samples_tolerance_retries` gelten nicht mehr für Messbefehle mit `METHOD=scan`, `METHOD=rapid_scan` oder `METHOD=tap`. Um abweichende Einstellungen zu verwenden, übergeben Sie dem Messbefehl den entsprechenden Parameter `PROBE_SPEED`, `LIFT_SPEED`, `SAMPLES`, `SAMPLE_RETRACT_DIST`, `SAMPLES_RESULT`, `SAMPLES_TOLERANCE` bzw. `SAMPLES_TOLERANCE_RETRIES`.

20260318: Die `[probe_eddy_current]`-Konfigurationsoption `z_offset` wurde in `descend_z` umbenannt. Die Verwendung des alten Namens ist veraltet und wird in naher Zukunft entfernt.

20260214: Der Parameter `STOP_ON_ENDSTOP` des G-Code-Befehls `MANUAL_STEPPER` hat sich geändert. Einzelheiten finden Sie in der Dokumentation zu [MANUAL_STEPPER](G-Codes.md#manual_stepper). Die Verwendung der bisherigen Ganzzahlwerte (-2, -1, 1, 2) ist veraltet und die Unterstützung wird in naher Zukunft entfernt.

20260207: Das Low-Level-I2C-Verhalten von sx1509- und uc1701-Geräten hat sich geändert. Bisher führte ein I2C-Fehler zu einer Abschaltung; nun erzeugen I2C-Fehler bei der Kommunikation mit diesen Geräten lediglich Warnungen in der Protokolldatei.

20260109: Der Statuswert `{printer.probe.last_z_result}` ist veraltet; er wird in naher Zukunft entfernt. Verwenden Sie stattdessen `{printer.probe.last_probe_position}` und beachten Sie, dass bei diesem neuen Wert die konfigurierten XYZ-Versätze der Sonde bereits berücksichtigt sind.

20260109: Die Textausgabe der Befehle `PROBE`, `PROBE_ACCURACY` und ähnlicher Befehle in der G-Code-Konsole hat sich geändert. Z-Höhen werden nun relativ zur nominellen Z-Position des Betts gemeldet statt relativ zum konfigurierten `z_offset` der Sonde. Ebenso werden bei den Zwischenausgaben der X- und Y-Werte in der Konsole die konfigurierten Versätze `x_offset` und `y_offset` der Sonde berücksichtigt.

20260109: Das Modul `[screws_tilt_adjust]` meldet die Statusvariable `{printer.screws_tilt_adjust.result.screw1.z}` nun mit berücksichtigtem `z_offset` der Sonde. Das heißt: Bisher musste man den konfigurierten `z_offset` der Sonde abziehen, um die absolute Z-Abweichung an der jeweiligen Schraubenposition zu erhalten - nun darf der `z_offset` nicht mehr angewendet werden.

20251122: Den Abschnitten `[carriage <name>]` der `generic_cartesian`-Kinematik wurde eine Option `axis` hinzugefügt, die beliebige Namen für primäre Schlitten erlaubt. Benutzern wird empfohlen, die Option `axis` nun explizit anzugeben.

20251106: Die Statusfelder `{printer.toolhead.position}`, `{printer.gcode_move.position}`, `{printer.gcode_move.gcode_position}` und `{printer.motion_report.live_position}` ändern sich. Diese Koordinaten enthielten bisher stets vier Komponenten, können nun aber zusätzliche Komponenten enthalten. Reihenfolge und Anzahl der Komponenten können sich zur Laufzeit ändern - wichtige Einzelheiten finden Sie in der [Statusreferenz](Status_Reference.md#accessing-coordinates). Der Zugriff auf diese Koordinaten in Makros über den Accessor ".e" ist veraltet - verwenden Sie stattdessen etwas wie `{printer.toolhead.position[printer.gcode_move.axis_map.E]}`.

20251106: Die Statusfelder `{printer.gcode_move.homing_origin}`, `{printer.toolhead.axis_min}` und `{printer.toolhead.axis_max}` enthalten derzeit vier Komponenten, wobei die vierte Komponente stets null ist. Dieses Verhalten ist veraltet. Künftig können diese Koordinaten nur noch drei Komponenten enthalten. Weitere Informationen finden Sie in der [Statusreferenz](Status_Reference.md#accessing-coordinates).

20251010: Während des normalen Druckens versucht die Befehlsverarbeitung nun, der Druckerbewegung eine Sekunde vorauszulaufen (reduziert von bisher zwei Sekunden).

20251003: Die Unterstützung für die undokumentierte Option `max_stepper_error` im Konfigurationsabschnitt `[printer]` wurde entfernt.

20250916: Die Definitionen der Input Shaper EI, 2HUMP_EI und 3HUMP_EI wurden aktualisiert. Für optimale Ergebnisse wird empfohlen, die Input Shaper neu zu kalibrieren, insbesondere wenn einer dieser Shaper derzeit verwendet wird.

20250811: Die Unterstützung für den Parameter `max_accel_to_decel` im Konfigurationsabschnitt `[printer]` sowie für den Parameter `ACCEL_TO_DECEL` im Befehl `SET_VELOCITY_LIMIT` wurde entfernt. Diese Funktionen waren seit 20240313 veraltet.

20250721: Die Module `[pca9632]` und `[mcp4018]` akzeptieren die Optionen `scl_pin` und `sda_pin` nicht mehr. Verwenden Sie stattdessen `i2c_software_scl_pin` und `i2c_software_sda_pin`.

20250428: Die maximale `cycle_time` für PWM-Abschnitte `[output_pin]`, `[pwm_cycle_time]`, `[pwm_tool]` und ähnliche beträgt nun 3 Sekunden (reduziert von 5 Sekunden). Auch `maximum_mcu_duration` in `[pwm_tool]` beträgt nun 3 Sekunden.

20250418: Die Funktion `STOP_ON_ENDSTOP` von manual_stepper kann nun weniger Zeit bis zum Abschluss benötigen. Bisher wartete der Befehl die gesamte mögliche Dauer der Bewegung ab, selbst wenn der Endschalter früher auslöste. Nun endet der Befehl kurz nach dem Auslösen des Endschalters.

20250417: SPI-Geräte mit "Software-SPI" werden nun in der Rate begrenzt. Bisher wurde die `spi_speed` aus der Konfiguration ignoriert und die Übertragungsgeschwindigkeit war nur durch die Verarbeitungsgeschwindigkeit des Mikrocontrollers begrenzt. Nun werden die Geschwindigkeiten durch den Konfigurationsparameter `spi_speed` begrenzt (die tatsächlichen Hardwaregeschwindigkeiten liegen aufgrund des Software-Overheads wahrscheinlich unter dem konfigurierten Wert).

20250411: Klipper v0.13.0 veröffentlicht.

20250308: Der Parameter `AUTO` des Befehls `AXIS_TWIST_COMPENSATION_CALIBRATE` wurde entfernt.

20250131: Die Option `VARIABLE=<name>` in `SAVE_VARIABLE` erfordert einen Wert in Kleinbuchstaben. Zum Beispiel `extruder` statt `Extruder` in gemischter Schreibweise oder `EXTRUDER` in Großbuchstaben. Die Verwendung eines Großbuchstabens löst einen Fehler aus.

20241203: Der Resonanztest wurde um langsame Sweep-Bewegungen erweitert. Diese Änderung setzt voraus, dass die Testpunkte in der X-/Y-Ebene etwas Freiraum haben (bei den Standardeinstellungen sollten +/- 30 mm um den Testpunkt genügen). Der neue Test liefert in der Regel genauere und zuverlässigere Ergebnisse. Bei Bedarf lässt sich das bisherige Testverhalten jedoch wiederherstellen, indem dem Konfigurationsabschnitt `[resonance_tester]` die Optionen `sweeping_period: 0` und `accel_per_hz: 75` hinzugefügt werden.

20241201: In manchen Fällen hat Klipper führende Zeichen oder Leerzeichen in einem klassischen G-Code-Befehl ignoriert. So wurde "99M123" möglicherweise als "M123" und "M 321" als "M321" interpretiert. Klipper meldet diese Fälle nun mit der Warnung "Unknown command".

20241112: Die Option `CHIPS=<chip_name>` in `TEST_RESONANCES` und `SHAPER_CALIBRATE` erfordert die Angabe der vollständigen Namen der Beschleunigungssensor-Chips. Zum Beispiel `adxl345 rpi` statt des Kurznamens `rpi`.

20240912: Die Befehle `SET_PIN`, `SET_SERVO`, `SET_FAN_SPEED`, `M106` und `M107` werden nun zusammengefasst. Wurden bisher viele Aktualisierungen desselben Objekts schneller abgesetzt als die minimale Planungszeit (typischerweise 100 ms), konnten die tatsächlichen Aktualisierungen weit in die Zukunft eingereiht werden. Werden nun viele Aktualisierungen in schneller Folge abgesetzt, kann es sein, dass nur die letzte Anforderung angewendet wird. Wird das bisherige Verhalten benötigt, fügen Sie zwischen den Aktualisierungen explizite `G4`-Verzögerungsbefehle ein.

20240912: Die Unterstützung für die Parameter `maximum_mcu_duration` und `static_value` in `[output_pin]`-Konfigurationsabschnitten wurde entfernt. Diese Optionen waren seit 20240123 veraltet.

20240415: Der Parameter `on_error_gcode` im Konfigurationsabschnitt `[virtual_sdcard]` hat nun einen Standardwert. Wird dieser Parameter nicht angegeben, lautet der Standardwert nun `TURN_OFF_HEATERS`. Wird das bisherige Verhalten gewünscht (bei einem Fehler während eines virtual_sdcard-Drucks keine Standardaktion ausführen), definieren Sie `on_error_gcode` mit einem leeren Wert.

20240313: Der Parameter `max_accel_to_decel` im Konfigurationsabschnitt `[printer]` ist veraltet. Der Parameter `ACCEL_TO_DECEL` des Befehls `SET_VELOCITY_LIMIT` ist veraltet. Der Status `printer.toolhead.max_accel_to_decel` wurde entfernt. Verwenden Sie stattdessen den [Parameter minimum_cruise_ratio](./Config_Reference.md#printer). Die veralteten Funktionen werden in naher Zukunft entfernt; ihre Verwendung in der Zwischenzeit kann zu leicht abweichendem Verhalten führen.

20240215: Mehrere veraltete Funktionen wurden entfernt. Die Verwendung von "NTC 100K beta 3950" als Thermistorname wurde entfernt (veraltet seit 20211110). Die Befehle `SYNC_STEPPER_TO_EXTRUDER` und `SET_EXTRUDER_STEP_DISTANCE` wurden entfernt, ebenso die Extruder-Konfigurationsoption `shared_heater` (veraltet seit 20220210). Die bed_mesh-Option `relative_reference_index` wurde entfernt (veraltet seit 20230619).

20240123: Der Parameter CYCLE_TIME des Befehls SET_PIN für output_pin wurde entfernt. Verwenden Sie das neue Modul [pwm_cycle_time](Config_Reference.md#pwm_cycle_time), wenn die Zykluszeit eines PWM-Pins dynamisch geändert werden muss.

20240123: Der output_pin-Parameter `maximum_mcu_duration` ist veraltet. Verwenden Sie stattdessen einen [pwm_tool-Konfigurationsabschnitt](Config_Reference.md#pwm_tool). Die Option wird in naher Zukunft entfernt.

20240123: Der output_pin-Parameter `static_value` ist veraltet. Ersetzen Sie ihn durch die Parameter `value` und `shutdown_value`. Die Option wird in naher Zukunft entfernt.

20231216: The `[hall_filament_width_sensor]` is changed to trigger filament runout when the thickness of the filament exceeds `max_diameter`. The maximum diameter defaults to `default_nominal_filament_diameter + max_difference`. See [[hall_filament_width_sensor] configuration
reference](./Config_Reference.md#hall_filament_width_sensor) for more details.

20231207: Mehrere undokumentierte Konfigurationsparameter im Abschnitt `[printer]` wurden entfernt (die Parameter buffer_time_low, buffer_time_high, buffer_time_start und move_flush_time).

10.11.2023: Klipper v0.12.0 veröffentlicht.

20230826: Wenn `safe_distance` in `[dual_carriage]` auf 0 gesetzt oder zu 0 berechnet wird, werden die Abstandsprüfungen zwischen den Schlitten laut Dokumentation deaktiviert. Es kann sinnvoll sein, `safe_distance` explizit zu konfigurieren, um versehentliche Kollisionen der Schlitten untereinander zu verhindern. Zusätzlich ändert sich in manchen Konfigurationen die Homing-Reihenfolge von primärem und zweitem Schlitten (bestimmte Konfigurationen, in denen beide Schlitten in dieselbe Richtung homen; weitere Einzelheiten siehe [Konfigurationsreferenz [dual_carriage]](./Config_Reference.md#dual_carriage)).

20230810: Das Skript flash-sdcard.sh unterstützt nun beide Varianten des Bigtreetech SKR-3, STM32H743 und STM32H723. Das bisherige Tag btt-skr-3 heißt daher nun entweder btt-skr-3-h743 oder btt-skr-3-h723.

20230729: Der exportierte Status für `dual_carriage` hat sich geändert. Statt `mode` und `active_carriage` werden die einzelnen Modi der beiden Schlitten als `printer.dual_carriage.carriage_0` und `printer.dual_carriage.carriage_1` exportiert.

20230619: Die Option `relative_reference_index` ist veraltet und wurde durch die Option `zero_reference_position` ersetzt. Einzelheiten zur Anpassung der Konfiguration finden Sie in der [Bed-Mesh-Dokumentation](./Bed_Mesh.md#the-deprecated-relative_reference_index). Mit dieser Abkündigung steht `RELATIVE_REFERENCE_INDEX` nicht mehr als Parameter des G-Code-Befehls `BED_MESH_CALIBRATE` zur Verfügung.

20230530: Die Standard-CAN-Bus-Frequenz in "make menuconfig" beträgt nun 1000000. Wird CAN-Bus mit einer anderen Frequenz benötigt, wählen Sie beim Kompilieren und Flashen des Mikrocontrollers unbedingt "Enable extra low-level configuration options" und geben Sie die gewünschte "CAN bus speed" in "make menuconfig" an.

20230525: Der Befehl `SHAPER_CALIBRATE` wendet die Input-Shaper-Parameter nun sofort an, sofern `[input_shaper]` bereits aktiviert war.

20230407: Der Zähler `stalled_bytes` im Protokoll und im Feld `printer.mcu.last_stats` wurde in `upcoming_bytes` umbenannt.

20230323: Bei tmc5160-Treibern ist `multistep_filt` nun standardmäßig aktiviert. Setzen Sie `driver_MULTISTEP_FILT: False` in der tmc5160-Konfiguration, um das bisherige Verhalten zu erhalten.

20230304: Der Befehl `SET_TMC_CURRENT` passt nun bei Treibern, die darüber verfügen, das Register globalscaler korrekt an. Damit entfällt die Einschränkung, dass sich die Ströme beim tmc5160 mit `SET_TMC_CURRENT` nicht über den in der Konfigurationsdatei gesetzten Wert `run_current` hinaus erhöhen ließen. Das hat jedoch einen Nebeneffekt: Nach dem Ausführen von `SET_TMC_CURRENT` muss der Schrittmotor bei Verwendung von StealthChop2 mehr als 130 ms im Stillstand gehalten werden, damit der Treiber die AT#1-Kalibrierung durchführt.

20230202: Das Format der Statusinformation `printer.screws_tilt_adjust` hat sich geändert. Die Information wird nun als Dictionary der Schrauben mit den zugehörigen Messwerten gespeichert. Einzelheiten finden Sie in der [Statusreferenz](Status_Reference.md#screws_tilt_adjust).

20230201: Das Modul `[bed_mesh]` lädt beim Start nicht mehr das Profil `default`. Benutzern, die das Profil `default` verwenden, wird empfohlen, `BED_MESH_PROFILE LOAD=default` in ihr Makro `START_PRINT` aufzunehmen (oder gegebenenfalls in die Konfiguration "Start G-Code" ihres Slicers).

20230103: Mit dem Skript flash-sdcard.sh lassen sich nun beide Varianten des Bigtreetech SKR-2 flashen, STM32F407 und STM32F429. Das bisherige Tag btt-skr2 heißt daher nun entweder btt-skr-2-f407 oder btt-skr-2-f429.

28.11.2022: Klipper v0.11.0 veröffentlicht.

20221122: Bisher konnte es bei safe_z_home vorkommen, dass der z_hop nach dem G28-Homing in negativer Z-Richtung erfolgte. Nun wird ein z_hop nach G28 nur dann ausgeführt, wenn er zu einer positiven Anhebung führt - entsprechend dem Verhalten des z_hop, der vor dem G28-Homing erfolgt.

20220616: Bisher war es möglich, einen rp2040 im Bootloader-Modus mit `make flash FLASH_DEVICE=first` zu flashen. Der entsprechende Befehl lautet nun `make flash FLASH_DEVICE=2e8a:0003`.

20220612: Der Mikrocontroller rp2040 enthält nun eine Umgehung für die USB-Errata "rp2040-e5". Dadurch sollten erste USB-Verbindungen zuverlässiger zustande kommen. Es kann jedoch zu einem geänderten Verhalten des Pins gpio15 kommen. Es ist unwahrscheinlich, dass diese Verhaltensänderung bei gpio15 bemerkbar ist.

20220407: Die temperature_fan-Konfigurationsoption `pid_integral_max` wurde entfernt (sie war seit 20210612 veraltet).

20220407: Die Standard-Farbreihenfolge für pca9632-LEDs lautet nun "RGBW". Fügen Sie dem pca9632-Konfigurationsabschnitt eine explizite Einstellung `color_order: RBGW` hinzu, um das bisherige Verhalten zu erhalten.

20220330: Das Format der Statusinformation `printer.neopixel.color_data` für die Module neopixel und dotstar hat sich geändert. Die Information wird nun als Liste von Farblisten gespeichert (statt als Liste von Dictionaries). Einzelheiten finden Sie in der [Statusreferenz](Status_Reference.md#led).

20220307: `M73` setzt den Druckfortschritt nicht mehr auf 0, wenn `P` fehlt.

20220304: Für den Parameter `extruder` in [extruder_stepper](Config_Reference.md#extruder_stepper)-Konfigurationsabschnitten gibt es keinen Standardwert mehr. Geben Sie bei Bedarf explizit `extruder: extruder` an, um den Schrittmotor beim Start der Bewegungswarteschlange "extruder" zuzuordnen.

20220210: Der Befehl `SYNC_STEPPER_TO_EXTRUDER` ist veraltet; der Befehl `SET_EXTRUDER_STEP_DISTANCE` ist veraltet; die [extruder](Config_Reference.md#extruder)-Konfigurationsoption `shared_heater` ist veraltet. Diese Funktionen werden in naher Zukunft entfernt. Ersetzen Sie `SET_EXTRUDER_STEP_DISTANCE` durch `SET_EXTRUDER_ROTATION_DISTANCE`. Ersetzen Sie `SYNC_STEPPER_TO_EXTRUDER` durch `SYNC_EXTRUDER_MOTION`. Ersetzen Sie Extruder-Konfigurationsabschnitte mit `shared_heater` durch [extruder_stepper](Config_Reference.md#extruder_stepper)-Abschnitte und passen Sie Aktivierungsmakros auf [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion) an.

20220116: Der Code zur Berechnung von `run_current` bei tmc2130, tmc2208, tmc2209 und tmc2660 hat sich geändert. Bei manchen `run_current`-Einstellungen werden die Treiber nun anders konfiguriert. Diese neue Konfiguration sollte genauer sein, kann jedoch eine bisherige Abstimmung der TMC-Treiber ungültig machen.

20211230: Die Skripte zur Abstimmung des Input Shapers (`scripts/calibrate_shaper.py` und `scripts/graph_accelerometer.py`) wurden auf Python 3 als Standard umgestellt. Benutzer müssen daher Python-3-Versionen bestimmter Pakete installieren (z. B. `sudo apt install python3-numpy python3-matplotlib`), um diese Skripte weiterhin zu verwenden. Weitere Einzelheiten finden Sie unter [Softwareinstallation](Measuring_Resonances.md#software-installation). Alternativ können Benutzer die Ausführung dieser Skripte vorübergehend unter Python 2 erzwingen, indem sie den Python-2-Interpreter in der Konsole explizit aufrufen: `python2 ~/klipper/scripts/calibrate_shaper.py ...`

20211110: Der Temperatursensor "NTC 100K beta 3950" ist veraltet. Dieser Sensor wird in naher Zukunft entfernt. Für die meisten Benutzer ist der Temperatursensor "Generic 3950" genauer. Um die ältere (in der Regel ungenauere) Definition weiterhin zu verwenden, definieren Sie einen benutzerdefinierten [Thermistor](Config_Reference.md#thermistor) mit `temperature1: 25`, `resistance1: 100000` und `beta: 3950`.

20211104: Die Option "step pulse duration" in "make menuconfig" wurde entfernt. Die Standard-Schrittdauer für TMC-Treiber im UART- oder SPI-Modus beträgt nun 100 ns. Für alle Schrittmotoren, die eine abweichende Impulsdauer benötigen, sollte die neue Einstellung `step_pulse_duration` im [Schrittmotor-Konfigurationsabschnitt](Config_Reference.md#stepper) gesetzt werden.

20211102: Mehrere veraltete Funktionen wurden entfernt. Die Schrittmotoroption `step_distance` wurde entfernt (veraltet seit 20201222). Der Sensor-Alias `rpi_temperature` wurde entfernt (veraltet seit 20210219). Die MCU-Option `pin_map` wurde entfernt (veraltet seit 20210325). Die gcode_macro-Option `default_parameter_<name>` sowie der Zugriff auf Befehlsparameter in Makros auf anderem Weg als über die Pseudo-Variable `params` wurden entfernt (veraltet seit 20210503). Die Heizungsoption `pid_integral_max` wurde entfernt (veraltet seit 20210612).

29.09.2021: Klipper v0.10.0 veröffentlicht.

20210903: Der Standardwert für [`smooth_time`](Config_Reference.md#extruder) bei Heizungen wurde auf 1 Sekunde geändert (von 2 Sekunden). Bei den meisten Druckern führt das zu einer stabileren Temperaturregelung.

20210830: Der Standardname für den adxl345 lautet nun "adxl345". Der Standardwert des Parameters CHIP für `ACCELEROMETER_MEASURE` und `ACCELEROMETER_QUERY` lautet nun ebenfalls "adxl345".

20210830: Der Befehl ACCELEROMETER_MEASURE des adxl345 unterstützt den Parameter RATE nicht mehr. Um die Abfragerate zu ändern, passen Sie die Datei printer.cfg an und setzen Sie einen RESTART-Befehl ab.

20210821: Mehrere Konfigurationseinstellungen in `printer.configfile.settings` werden nun als Listen statt als reine Zeichenketten gemeldet. Wird die tatsächliche Rohzeichenkette benötigt, verwenden Sie stattdessen `printer.configfile.config`.

20210819: In manchen Fällen kann eine `G28`-Homing-Bewegung an einer Position enden, die nominell außerhalb des gültigen Bewegungsbereichs liegt. In seltenen Fällen kann dies nach dem Homing zu verwirrenden Fehlern "Move out of range" führen. Ändern Sie in diesem Fall Ihre Startskripte so, dass der Druckkopf unmittelbar nach dem Homing an eine gültige Position gefahren wird.

20210814: Die rein analogen Pseudo-Pins auf dem atmega168 und atmega328 wurden von PE0/PE1 in PE2/PE3 umbenannt.

20210720: Ein controller_fan-Abschnitt überwacht nun standardmäßig alle Schrittmotoren (nicht nur die kinematischen Schrittmotoren). Wird das bisherige Verhalten gewünscht, siehe die Konfigurationsoption `stepper` in der [Konfigurationsreferenz](Config_Reference.md#controller_fan).

20210703: Ein Konfigurationsabschnitt `samd_sercom` muss den von ihm konfigurierten Sercom-Bus nun über die Option `sercom` angeben.

20210612: Die Konfigurationsoption `pid_integral_max` in heater- und temperature_fan-Abschnitten ist veraltet. Die Option wird in naher Zukunft entfernt.

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430: Der Befehl SET_VELOCITY_LIMIT (und M204) kann nun eine Geschwindigkeit, Beschleunigung und square_corner_velocity setzen, die größer sind als die in der Konfigurationsdatei angegebenen Werte.

20210325: Die Unterstützung für die Konfigurationsoption `pin_map` ist veraltet. Verwenden Sie die Datei [sample-aliases.cfg](../config/sample-aliases.cfg), um auf die tatsächlichen Pin-Namen des Mikrocontrollers zu übersetzen. Die Konfigurationsoption `pin_map` wird in naher Zukunft entfernt.

20210313: Klippers Unterstützung für Mikrocontroller, die über CAN-Bus kommunizieren, hat sich geändert. Bei Verwendung von CAN-Bus müssen alle Mikrocontroller neu geflasht und die [Klipper-Konfiguration muss aktualisiert werden](CANBUS.md).

20210310: Der Standardwert für driver_SFILT beim TMC2660 wurde von 1 auf 0 geändert.

20210227: TMC-Schrittmotortreiber im UART- oder SPI-Modus werden nun einmal pro Sekunde abgefragt, solange sie aktiviert sind - kann der Treiber nicht erreicht werden oder meldet er einen Fehler, geht Klipper in den Abschaltzustand über.

20210219: Das Modul `rpi_temperature` wurde in `temperature_host` umbenannt. Ersetzen Sie alle Vorkommen von `sensor_type: rpi_temperature` durch `sensor_type: temperature_host`. Der Pfad zur Temperaturdatei kann in der Konfigurationsvariablen `sensor_path` angegeben werden. Der Name `rpi_temperature` ist veraltet und wird in naher Zukunft entfernt.

20210201: Der Befehl `TEST_RESONANCES` deaktiviert nun das Input Shaping, sofern es zuvor aktiviert war (und aktiviert es nach dem Test wieder). Um dieses Verhalten zu überschreiben und das Input Shaping aktiviert zu lassen, kann dem Befehl der zusätzliche Parameter `INPUT_SHAPING=1` übergeben werden.

20210201: Der `ACCELEROMETER_MEASURE` Befehl fügt nun den Namen des Beschleunigungssensors dem Dateinamen hinzu, wenn der Chip in der dazugehörigen ADXL345 Konfigurations Sektion innerhalb der printer.cfg Datei einen Namen zugewiesen bekommen hat.

20201222: Die Einstellung `step_distance` in den Schrittmotor-Konfigurationsabschnitten ist veraltet. Es wird empfohlen, die Konfiguration auf die Einstellung [`rotation_distance`](Rotation_Distance.md) umzustellen. Die Unterstützung für `step_distance` wird in naher Zukunft entfernt.

20201218: Die `endstop_phase` Einstellungen im endstop_phase Modul wurden gegen `trigger_phase` ersetzt. Sobald das endstop Phase Modul genutzt wird, ist es notwendig auf [`rotation_distance`](Rotation_Distance.md) zu konvertieren und eine neu Kalibrierung aller Endschalter Phasen mit dem Befehl ENDSTOP_PHASE_CALIBRATE durchzuführen.

20201218: Rotary-Delta- und Polardrucker müssen für ihre rotatorischen Schrittmotoren nun ein `gear_ratio` angeben und dürfen keinen Parameter `step_distance` mehr angeben. Das Format des neuen Parameters gear_ratio finden Sie in der [Konfigurationsreferenz](Config_Reference.md#stepper).

20201213: Es ist nicht zulässig, bei Verwendung von "probe:z_virtual_endstop" einen Z-"position_endstop" anzugeben. Wird ein Z-"position_endstop" zusammen mit "probe:z_virtual_endstop" angegeben, wird nun ein Fehler ausgelöst. Entfernen Sie die Definition des Z-"position_endstop", um den Fehler zu beheben.

20201120: Der Konfigurationsabschnitt `[board_pins]` gibt den MCU-Namen nun in einem expliziten Parameter `mcu:` an. Wird board_pins für einen zweiten MCU verwendet, muss die Konfiguration angepasst werden, um diesen Namen anzugeben. Weitere Einzelheiten finden Sie in der [Konfigurationsreferenz](Config_Reference.md#board_pins).

20201112: Die von `print_stats.print_duration` gemeldete Zeit hat sich geändert. Die Dauer vor der ersten erkannten Extrusion wird nun ausgeschlossen.

20201029: Die Neopixel-Konfigurationsoption `color_order_GRB` wurde entfernt. Passen Sie die Konfiguration gegebenenfalls an und setzen Sie die neue Option `color_order` auf RGB, GRB, RGBW oder GRBW.

20201029: Die Option serial im Konfigurationsabschnitt mcu hat nicht mehr den Standardwert /dev/ttyS0. In dem seltenen Fall, dass /dev/ttyS0 der gewünschte serielle Port ist, muss er explizit angegeben werden.

20.10.2020: Klipper v0.9.0 veröffentlicht.

20200902: Die Berechnung von Widerstand zu Temperatur für RTDs bei MAX31865-Wandlern wurde korrigiert, sodass sie nicht mehr zu niedrig ausfällt. Wenn Sie ein solches Gerät verwenden, sollten Sie Ihre Drucktemperatur und die PID-Einstellungen neu kalibrieren.

20200816: Das G-Code-Makro-Objekt `printer.gcode` wurde in `printer.gcode_move` umbenannt. Mehrere undokumentierte Variablen in `printer.toolhead` und `printer.gcode` wurden entfernt. Eine Liste der verfügbaren Vorlagenvariablen finden Sie in docs/Command_Templates.md.

20200816: Das "action_"-System für G-Code-Makros hat sich geändert. Ersetzen Sie alle Aufrufe von `printer.gcode.action_emergency_stop()` durch `action_emergency_stop()`, `printer.gcode.action_respond_info()` durch `action_respond_info()` und `printer.gcode.action_respond_error()` durch `action_raise_error()`.

20200809: Das Menüsystem wurde neu geschrieben. Wurde das Menü angepasst, ist eine Umstellung auf die neue Konfiguration erforderlich. Konfigurationsdetails finden Sie in config/example-menu.cfg, Beispiele in klippy/extras/display/menu.cfg.

20200731: Das Verhalten des vom Druckerobjekt `virtual_sdcard` gemeldeten Attributs `progress` hat sich geändert. Der Fortschritt wird beim Pausieren eines Drucks nicht mehr auf 0 zurückgesetzt. Er wird nun stets anhand der internen Dateiposition gemeldet, bzw. als 0, wenn derzeit keine Datei geladen ist.

20200725: Der Servo-Konfigurationsparameter `enable` und der SET_SERVO-Parameter `ENABLE` wurden entfernt. Passen Sie Makros so an, dass sie `SET_SERVO SERVO=my_servo WIDTH=0` verwenden, um einen Servo zu deaktivieren.

20200608: In der LCD-Display-Unterstützung wurden die Namen einiger interner "Glyphen" geändert. Wurde ein eigenes Display-Layout umgesetzt, kann eine Anpassung an die neuen Glyphennamen erforderlich sein (eine Liste der verfügbaren Glyphen finden Sie in klippy/extras/display/display.cfg).

20200606: Die Pin-Namen am Linux-MCU haben sich geändert. Pins haben nun Namen der Form `gpiochip<chipid>/gpio<gpio>`. Für gpiochip0 kann auch die Kurzform `gpio<gpio>` verwendet werden. Was zuvor beispielsweise als `P20` bezeichnet wurde, heißt nun `gpio20` oder `gpiochip0/gpio20`.

20200603: Das Standard-Layout für 16x4-LCDs zeigt die geschätzte Restzeit eines Drucks nicht mehr an. (Es wird nur noch die verstrichene Zeit angezeigt.) Wird das alte Verhalten gewünscht, kann man die Menüanzeige um diese Information erweitern (Einzelheiten siehe die Beschreibung von display_data in config/example-extras.cfg).

20200531: Die Standard-USB-Vendor-/Product-ID lautet nun 0x1d50/0x614e. Diese neuen IDs sind für Klipper reserviert (mit Dank an das openmoko-Projekt). Diese Änderung sollte keine Konfigurationsanpassungen erfordern, die neuen IDs können jedoch in Systemprotokollen auftauchen.

20200524: Der Standardwert des Feldes pwm_freq beim tmc5160 ist nun null (statt eins).

20200425: Die Vorlagenvariable `printer.heater` für gcode_macro-Befehle wurde in `printer.heaters` umbenannt.

20200313: Das Standard-LCD-Layout für Drucker mit mehreren Extrudern und 16x4-Display hat sich geändert. Das Layout für einen einzelnen Extruder ist nun Standard und zeigt den aktuell aktiven Extruder an. Um das bisherige Anzeigelayout zu verwenden, setzen Sie "display_group: _multiextruder_16x4" im Abschnitt [display] der Datei printer.cfg.

20200308: Der Standard-Menüeintrag `__test` wurde entfernt. Enthält die Konfigurationsdatei ein eigenes Menü, entfernen Sie unbedingt alle Verweise auf diesen Menüeintrag `__test`.

20200308: Die Menüoptionen "deck" und "card" wurden entfernt. Um das Layout eines LCD-Bildschirms anzupassen, verwenden Sie die neuen Konfigurationsabschnitte display_data (Einzelheiten siehe config/example-extras.cfg).

20200109: Das Modul bed_mesh bezieht sich für die Mesh-Konfiguration nun auf die Position der Sonde. Daher wurden einige Konfigurationsoptionen umbenannt, um ihre Funktion treffender wiederzugeben. Bei rechteckigen Betten wurden `min_point` und `max_point` in `mesh_min` bzw. `mesh_max` umbenannt. Bei runden Betten wurde `bed_radius` in `mesh_radius` umbenannt. Für runde Betten wurde außerdem eine neue Option `mesh_origin` ergänzt. Beachten Sie, dass diese Änderungen auch mit zuvor gespeicherten Mesh-Profilen unvereinbar sind. Wird ein unvereinbares Profil erkannt, wird es ignoriert und zur Entfernung vorgemerkt. Der Entfernungsvorgang lässt sich durch Absetzen des Befehls SAVE_CONFIG abschließen. Der Benutzer muss jedes Profil neu kalibrieren.

20191218: Der Konfigurationsabschnitt display unterstützt "lcd_type: st7567" nicht mehr. Verwenden Sie stattdessen den Displaytyp "uc1701" - setzen Sie "lcd_type: uc1701" und ändern Sie "rs_pin: some_pin" in "rst_pin: some_pin". Unter Umständen ist zusätzlich die Konfigurationseinstellung "contrast: 60" erforderlich.

20191210: Die eingebauten Befehle T0, T1, T2, ... wurden entfernt. Die Extruder-Konfigurationsoptionen activate_gcode und deactivate_gcode wurden entfernt. Werden diese Befehle (und Skripte) benötigt, definieren Sie einzelne Makros im Stil von [gcode_macro T0], die den Befehl ACTIVATE_EXTRUDER aufrufen. Beispiele finden Sie in den Dateien config/sample-idex.cfg und sample-multi-extruder.cfg.

20191210: Die Unterstützung für den Befehl M206 wurde entfernt. Ersetzen Sie ihn durch Aufrufe von SET_GCODE_OFFSET. Wird Unterstützung für M206 benötigt, fügen Sie einen Konfigurationsabschnitt [gcode_macro M206] hinzu, der SET_GCODE_OFFSET aufruft. (Zum Beispiel "SET_GCODE_OFFSET Z=-{params.Z}".)

20191202: Die Unterstützung für den undokumentierten Parameter "S" des Befehls "G4" wurde entfernt. Ersetzen Sie alle Vorkommen von S durch den Standardparameter "P" (die Verzögerung in Millisekunden).

20191126: Die USB-Namen haben sich bei Mikrocontrollern mit nativer USB-Unterstützung geändert. Sie verwenden nun standardmäßig eine eindeutige Chip-ID (sofern verfügbar). Verwendet ein Konfigurationsabschnitt "mcu" eine Einstellung "serial", die mit "/dev/serial/by-id/" beginnt, kann eine Anpassung der Konfiguration erforderlich sein. Führen Sie in einem SSH-Terminal "ls /dev/serial/by-id/*" aus, um die neue ID zu ermitteln.

20191121: Der Parameter pressure_advance_lookahead_time wurde entfernt. Alternative Konfigurationseinstellungen finden Sie in example.cfg.

20191112: Die virtuelle Enable-Funktion der TMC-Schrittmotortreiber wird nun automatisch aktiviert, wenn der Schrittmotor keinen eigenen Enable-Pin besitzt. Entfernen Sie Verweise auf tmcXXXX:virtual_enable aus der Konfiguration. Die Möglichkeit, in enable_pin eines Schrittmotors mehrere Pins zu steuern, wurde entfernt. Werden mehrere Pins benötigt, verwenden Sie einen Konfigurationsabschnitt multi_pin.

20191107: Der primäre Extruder-Konfigurationsabschnitt muss als "extruder" angegeben werden und darf nicht mehr als "extruder0" angegeben werden. G-Code-Befehlsvorlagen, die den Extruderstatus abfragen, greifen nun über "{printer.extruder}" darauf zu.

21.10.2019: Klipper v0.8.0 veröffentlicht

20191003: Die Option move_to_previous in [safe_z_homing] hat nun den Standardwert False. (Vor dem 20190918 war sie faktisch False.)

20190918: Die Option zhop in [safe_z_homing] wird nach Abschluss des Z-Achsen-Homings stets erneut angewendet. Dies kann es erforderlich machen, dass Benutzer eigene Skripte anpassen, die auf diesem Modul beruhen.

20190806: Der Befehl SET_NEOPIXEL wurde in SET_LED umbenannt.

20190726: Der Code für den Digital-Analog-Wandler mcp4728 hat sich geändert. Die Standard-i2c_address lautet nun 0x60 und die Referenzspannung bezieht sich nun auf die interne 2,048-Volt-Referenz des mcp4728.

20190710: Die Option z_hop wurde aus dem Konfigurationsabschnitt [firmware_retract] entfernt. Die z_hop-Unterstützung war unvollständig und konnte bei mehreren verbreiteten Slicern zu fehlerhaftem Verhalten führen.

20190710: Die optionalen Parameter des Befehls PROBE_ACCURACY haben sich geändert. Unter Umständen müssen Makros oder Skripte angepasst werden, die diesen Befehl verwenden.

20190628: Alle Konfigurationsoptionen wurden aus dem Abschnitt [skew_correction] entfernt. Die Konfiguration von skew_correction erfolgt nun über den G-Code SET_SKEW. Empfehlungen zur Verwendung finden Sie unter [Skew Correction](Skew_Correction.md).

20190607: Die Parameter "variable_X" von gcode_macro (sowie der Parameter VALUE von SET_GCODE_VARIABLE) werden nun als Python-Literale ausgewertet. Soll einem Wert eine Zeichenkette zugewiesen werden, setzen Sie den Wert in Anführungszeichen, damit er als Zeichenkette ausgewertet wird.

20190606: Die Konfigurationsoptionen "samples", "samples_result" und "sample_retract_dist" wurden in den Konfigurationsabschnitt "probe" verschoben. Diese Optionen werden in den Abschnitten "delta_calibrate", "bed_tilt", "bed_mesh", "screws_tilt_adjust", "z_tilt" und "quad_gantry_level" nicht mehr unterstützt.

20190528: Die magische Variable "status" bei der Auswertung von gcode_macro-Vorlagen wurde in "printer" umbenannt.

20190520: Der Befehl SET_GCODE_OFFSET hat sich geändert; passen Sie G-Code-Makros entsprechend an. Der Befehl wendet den angeforderten Versatz nicht mehr auf den nächsten G1-Befehl an. Das alte Verhalten lässt sich näherungsweise über den neuen Parameter "MOVE=1" erreichen.

20190404: Die Python-Pakete der Host-Software wurden aktualisiert. Benutzer müssen das Skript ~/klipper/scripts/install-octopi.sh erneut ausführen (oder die Python-Abhängigkeiten anderweitig aktualisieren, sofern keine Standard-OctoPi-Installation verwendet wird).

20190404: Die Parameter i2c_bus und spi_bus (in verschiedenen Konfigurationsabschnitten) erwarten nun einen Busnamen statt einer Nummer.

20190404: Die Konfigurationsparameter des sx1509 haben sich geändert. Der Parameter 'address' heißt nun 'i2c_address' und muss als Dezimalzahl angegeben werden. Wo zuvor 0x3E verwendet wurde, geben Sie 62 an.

20190328: Der Wert min_speed in der Konfiguration [temperature_fan] wird nun berücksichtigt; der Lüfter läuft im PID-Modus stets mit dieser oder einer höheren Drehzahl.

20190322: Der Standardwert für "driver_HEND" in [tmc2660]-Konfigurationsabschnitten wurde von 6 auf 3 geändert. Das Feld "driver_VSENSE" wurde entfernt (es wird nun automatisch aus run_current berechnet).

20190310: Der Konfigurationsabschnitt [controller_fan] erwartet nun stets einen Namen (etwa [controller_fan my_controller_fan]).

20190308: Das Feld "driver_BLANK_TIME_SELECT" in den Konfigurationsabschnitten [tmc2130] und [tmc2208] wurde in "driver_TBL" umbenannt.

20190308: Der Konfigurationsabschnitt [tmc2660] hat sich geändert. Es muss nun ein neuer Konfigurationsparameter sense_resistor angegeben werden. Die Bedeutung mehrerer driver_XXX-Parameter hat sich geändert.

20190228: Benutzer von SPI oder I2C auf SAMD21-Platinen müssen die Bus-Pins nun über einen Konfigurationsabschnitt [samd_sercom] angeben.

20190224: Die Option bed_shape wurde aus bed_mesh entfernt. Die Option radius wurde in bed_radius umbenannt. Benutzer mit runden Betten sollten die Optionen bed_radius und round_probe_count angeben.

20190107: Der Parameter i2c_address im Konfigurationsabschnitt mcp4451 hat sich geändert. Dies ist eine übliche Einstellung auf Smoothieboards. Der neue Wert ist die Hälfte des alten Werts (aus 88 wird 44, aus 90 wird 45).

20.12.2018: Klipper v0.7.0 veröffentlicht
