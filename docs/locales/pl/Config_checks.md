# Configuration checks

Ten dokument zawiera listę kroków, które pomogą potwierdzić ustawienia pinów w pliku konfiguracyjnym klipper printer.cfg. Dobrym pomysłem jest wykonanie tych kroków po wykonaniu czynności opisanych w [installation document](Installation.md).

Podczas tego przewodnika może być konieczne wprowadzenie zmian w pliku konfiguracyjnym Klippera. Pamiętaj, aby wydać polecenie RESTART po każdej zmianie w pliku konfiguracyjnym, aby mieć pewność, że zmiana zacznie obowiązywać (wpisz „restart” w zakładce terminala Octoprint, a następnie kliknij „Wyślij”). Dobrym pomysłem jest również wydanie polecenia STATUS po każdym RESTARTU, aby sprawdzić, czy plik konfiguracyjny został pomyślnie załadowany.

## Sprawdź temperaturę

Zacznij od sprawdzenia, czy temperatury są prawidłowo raportowane. Przejdź do zakładki Temperatura Octoprint.

![octoprint-temperature](img/octoprint-temperature.png)

Sprawdź, czy temperatura dyszy i złoża (jeśli dotyczy) jest obecna i nie wzrasta. Jeśli rośnie, odłącz zasilanie od drukarki. Jeśli temperatury nie są dokładne, sprawdź ustawienia „sensor_type” i „sensor_pin” dla dyszy i/lub stołu.

## Sprawdź M112

Navigate to the Octoprint terminal tab and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause Octoprint to disconnect from Klipper - navigate to the Connection area and click on "Connect" to cause Octoprint to reconnect. Then navigate to the Octoprint temperature tab and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

Komenda M112 powoduje przejście Klippera w stan "shutdown". Opuszczenie tego stanu można wywołać komendą FIRMWARE_RESTART w zakładce terminala Octoprint.

## Sprawdź grzałki

Navigate to the Octoprint temperature tab and type in 50 followed by enter in the "Tool" temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the "Tool" temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

If the printer has a heated bed then perform the above test again with the bed.

## Sprawdź pin włączający silnik krokowy

Sprawdź, czy wszystkie osie drukarki można przesunąć ręcznie (przy wyłączonych silnikach krokowych). Jeśli nie, wyłącz silniki komendą M84. Jeśli któraś z osi nadal pozostanie aktywna, sprawdź konfigurację "enable_pin" danej osi. Większość sterowników silników krokowych ma pin enable aktywny przy niskim stanie dlatego w konfiguracji pin należy wstawić "!" przed nazwą pinu (np. enable_pin:!ar38").

## Sprawdź krańcówki

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the Octoprint terminal tab. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!ar3"), or remove the "!" if there is already one present.

If the endstop does not change at all then it generally indicates that the endstop is connected to a different pin. However, it may also require a change to the pullup setting of the pin (the '^' at the start of the endstop_pin name - most printers will use a pullup resistor and the '^' should be present).

## Verify stepper motors

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x`. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

If the stepper does not move at all, then verify the "enable_pin" and "step_pin" settings for the stepper. If the stepper motor moves but does not return to its original position then verify the "dir_pin" setting. If the stepper motor oscillates in an incorrect direction, then it generally indicates that the "dir_pin" for the axis needs to be inverted. This is done by adding a '!' to the "dir_pin" in the printer config file (or removing it if one is already there). If the motor moves significantly more or significantly less than one millimeter then verify the "rotation_distance" setting.

Uruchom powyższy test dla każdego silnika krokowego zdefiniowanego w pliku konfiguracyjnym. (Ustaw parametr STEPPER komendy STEPPER_BUZZ na nazwę sekcji konfiguracyjnej, która ma być testowana.) Jeśli w ekstruderze nie ma filamentu, można użyć STEPPER_BUZZ do weryfikacji połączenia silnika ekstrudera (użyj STEPPER=extruder). W przeciwnym razie najlepiej przetestować silnik ekstrudera osobno (patrz następna sekcja).

Po sprawdzeniu wszystkich ograniczników i sprawdzeniu wszystkich silników krokowych należy przetestować mechanizm samonaprowadzający. Wydaj polecenie G28, aby bazować wszystkie osie. Odłącz zasilanie od drukarki, jeśli nie działa prawidłowo. W razie potrzeby ponownie wykonaj kroki weryfikacji ogranicznika i silnika krokowego.

## Sprawdź silnik wytłaczarki

Aby przetestować silnik ekstrudera, konieczne będzie podgrzanie ekstrudera do temperatury drukowania. Przejdź do zakładki Octoprint temperature i wybierz temperaturę docelową z listy rozwijanej temperatury (lub ręcznie wprowadź odpowiednią temperaturę). Poczekaj, aż drukarka osiągnie żądaną temperaturę. Następnie przejdź do zakładki Octoprint control i kliknij przycisk „Extrude”. Sprawdź, czy silnik ekstrudera obraca się we właściwym kierunku. Jeśli tak nie jest, zapoznaj się ze wskazówkami rozwiązywania problemów w poprzedniej sekcji, aby potwierdzić ustawienia „enable_pin”, „step_pin” i „dir_pin” dla ekstrudera.

## Skalibruj ustawienia PID

Klipper obsługuje [PID control](https://en.wikipedia.org/wiki/PID_controller) dla ekstrudera i podgrzewaczy stołu. Aby skorzystać z tego mechanizmu sterującego, konieczne jest skalibrowanie ustawień PID na każdej drukarce. (Ustawienia PID znalezione w innych firmware lub w przykładowych plikach konfiguracyjnych często działają słabo.)

To calibrate the extruder, navigate to the OctoPrint terminal tab and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

At the completion of the tuning test run `SAVE_CONFIG` to update the printer.cfg file the new PID settings.

If the printer has a heated bed and it supports being driven by PWM (Pulse Width Modulation) then it is recommended to use PID control for the bed. (When the bed heater is controlled using the PID algorithm it may turn on and off ten times a second, which may not be suitable for heaters using a mechanical switch.) A typical bed PID calibration command is: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Next steps

This guide is intended to help with basic verification of pin settings in the Klipper configuration file. Be sure to read the [bed leveling](Bed_Level.md) guide. Also see the [Slicers](Slicers.md) document for information on configuring a slicer with Klipper.

After one has verified that basic printing works, it is a good idea to consider calibrating [pressure advance](Pressure_Advance.md).

It may be necessary to perform other types of detailed printer calibration - a number of guides are available online to help with this (for example, do a web search for "3d printer calibration"). As an example, if you experience the effect called ringing, you may try following [resonance compensation](Resonance_Compensation.md) tuning guide.
