# Kontrola konfiguracji

Ten dokument zawiera listę kroków, które pomogą potwierdzić ustawienia pinów w pliku konfiguracyjnym Klipper printer.cfg. Dobrym pomysłem jest wykonanie tych kroków po wykonaniu czynności opisanych w [installation document](Installation.md).

Podczas tego przewodnika może być konieczne wprowadzenie zmian w pliku konfiguracyjnym Klippera. Pamiętaj, aby wydać polecenie RESTART po każdej zmianie w pliku konfiguracyjnym, aby mieć pewność, że zmiana zacznie obowiązywać (wpisz „restart” w zakładce terminala Octoprint, a następnie kliknij „Wyślij”). Dobrym pomysłem jest również wydanie polecenia STATUS po każdym RESTARTU, aby sprawdzić, czy plik konfiguracyjny został pomyślnie załadowany.

## Sprawdź temperaturę

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Sprawdź M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Sprawdź grzałki

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Jeśli drukarka ma podgrzewane łoże, wykonaj powyższy test ponownie z tym łożem.

## Sprawdź pin włączający silnik krokowy

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Sprawdź krańcówki

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Jeżeli stan krańcówki nie zmienia się, to oznacza to, że jest ona podłączona do innego pinu. Jednak może również być wymagana zmiana ustawienia pullup dla tego pinu ('^' na początku nazwy endstop_pin - większość drukarek będzie używać rezystora pullup i '^' powinno to być zdefiniowane).

## Weryfikacja silników krokowych

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Jeśli stepper nie porusza się w ogóle, to następnie sprawdc ustawienia "enable_pin" i "step_pin" dla steppera. Jeśli silnik krokowy porusza się, ale nie powraca do pozycji wyjściowej, należy sprawdzić ustawienie "dir_pin". Jeśli silnik krokowy oscyluje w niewłaściwym kierunku, oznacza to z reguły, że "dir_pin" dla osi musi zostać odwrócony. W tym celu należy dodać znak "!" do "dir_pin" w pliku konfiguracyjnym drukarki (lub usunąć go, jeśli już tam jest). Jeśli silnik porusza się znacznie więcej lub znacznie mniej niż jeden milimetr, należy sprawdzić ustawienie "rotation_distance".

Uruchom powyższy test dla każdego silnika krokowego zdefiniowanego w pliku konfiguracyjnym. (Ustaw parametr STEPPER komendy STEPPER_BUZZ na nazwę sekcji konfiguracyjnej, która ma być testowana.) Jeśli w ekstruderze nie ma filamentu, można użyć STEPPER_BUZZ do weryfikacji połączenia silnika ekstrudera (użyj STEPPER=extruder). W przeciwnym razie najlepiej przetestować silnik ekstrudera osobno (patrz następna sekcja).

Po sprawdzeniu wszystkich ograniczników i sprawdzeniu wszystkich silników krokowych należy przetestować mechanizm samonaprowadzający. Wydaj polecenie G28, aby bazować wszystkie osie. Odłącz zasilanie od drukarki, jeśli nie działa prawidłowo. W razie potrzeby ponownie wykonaj kroki weryfikacji ogranicznika i silnika krokowego.

## Sprawdź silnik wytłaczarki

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Skalibruj ustawienia PID

Klipper obsługuje [sterowanie PID](https://en.wikipedia.org/wiki/PID_controller) dla ekstrudera i grzałek stołu. Aby użyć tego mechanizmu sterowania, konieczne jest skalibrowanie ustawień PID na każdej drukarce (ustawienia PID znalezione w innych firmware'ach lub w przykładowych plikach konfiguracyjnych często działają słabo).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

Po zakończeniu testu dostrajania uruchom `SAVE_CONFIG`, aby zaktualizować plik printer.cfg o nowemu ustawienia PID.

Jeśli drukarka ma podgrzewane łoże i obsługuje ono sterowanie PWM (modulacja szerokości impulsu), zaleca się stosowanie sterowania PID dla łoża. (Gdy podgrzewacz łoża jest sterowany za pomocą algorytmu PID, może on włączać się i wyłączać dziesięć razy na sekundę, co może nie być odpowiednie dla podgrzewaczy wykorzystujących przełącznik mechaniczny). Typowa komenda kalibracji PID łóżka to: `PID_CALIBRATE HEATER=heater_bed TARGET=60`.

## Następne kroki

Ten dokument ma na celu pomóc w podstawowej weryfikacji ustawień pinów w pliku konfiguracyjnym Klippera. Należy zapoznać się z przewodnikiem [Bed Leveling](Bed_Level.md). Zobacz także dokument [Slicers](Slicers.md), aby uzyskać informacje na temat konfigurowania slicera za pomocą programu Klipper.

Po sprawdzeniu, że podstawowe drukowanie działa, warto rozważyć kalibrację [pressure advance](Pressure_Advance.md).

Może być konieczne przeprowadzenie innych rodzajów szczegółowej kalibracji drukarki - w sieci dostępnych jest wiele poradników, które w tym pomogą (na przykład wyszukaj w Internecie hasło "3d printer calibration"). Na przykład, jeśli doświadczasz efektu zwanego dzwonieniem, możesz spróbować zastosować się do instrukcji strojenia [Kompensacja rezonansu](Resonance_Compensation.md).
