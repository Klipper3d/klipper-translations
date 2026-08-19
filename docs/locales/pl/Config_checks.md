# Kontrola konfiguracji

Ten dokument zawiera listę kroków, które pomogą potwierdzić ustawienia pinów w pliku konfiguracyjnym Klipper printer.cfg. Dobrym pomysłem jest wykonanie tych kroków po wykonaniu czynności opisanych w [installation document](Installation.md).

Podczas tego przewodnika może być konieczne wprowadzenie zmian w pliku konfiguracyjnym Klippera. Pamiętaj, aby wydać polecenie RESTART po każdej zmianie w pliku konfiguracyjnym, aby mieć pewność, że zmiana zacznie obowiązywać (wpisz „restart” w zakładce terminala Octoprint, a następnie kliknij „Wyślij”). Dobrym pomysłem jest również wydanie polecenia STATUS po każdym RESTARTU, aby sprawdzić, czy plik konfiguracyjny został pomyślnie załadowany.

## Sprawdź temperaturę

Zacznij sprawdzając czy temperatury są poprawnie odczytywane. Przejdź do wykresu temperatur w interfejsie. Sprawdź czy temperatura dyszy i stołu grzewczego (jeżeli owy posiadamy) są odczytywane i nie wzrastają. Jeżeli wzrastają, odłącz drukarkę od prądu. Jeżeli temperatury nie są dokładne, sprawdź ustawienie "sensor_type" i "sensor_pin" dla dyszy i/lub stołu grzewczego.

## Sprawdź M112

Przejdź do zakładki Konsola i w polu tekstowym wykonaj polecenie M112. To polecenie wywołuje w Klipperze awaryjny stop, zatrzymując wszelkie działania. Spowoduje to wyświetlenie na ekranie błędu, który można usunąć komendą FIRMWARE_RESTART. Octoprint będzie również wymagał ponownego połączenia. Przejdź następnie do wykresu i zweryfikuj, czy temperatury nadal się aktualizują, oraz czy nie wzrastają. Jeśli temperatura ciągle wzrasta, odłącz zasilanie od drukarki.

## Sprawdź grzałki

W sekcji wykresu temperatur, w polu temperatury ekstrudera wpisz wartość 50 i zatwierdź Enter'em. Temperatura ekstrudera powinna zacząć rosnąć (w przeciągu ok. 30 sekund), co zostanie zobrazowane na wykresie. Następnie z listy rozwijanej przy wyborze temperatury wybierz opcję "Wyłącz". Po kilku minutach temperatura powinna zacząć powracać do temperatury otoczenia. Jeśli temperatura nie wzrosła po jej ustawieniu, zweryfikuj ustawienie "heater_pin" w sekcji ekstrudera w konfiguracji drukarki.

Jeśli drukarka ma podgrzewane łoże, wykonaj powyższy test ponownie z tym łożem.

## Sprawdź pin włączający silnik krokowy

Zweryfikuj, czy wszystkie osie mogą się poruszać swobodnie (silniki krokowe są wyłączone). Jeśli nie, wywołaj polecenie M84, aby wyłączyć silniki. Jeżeli jakakolwiek oś nadal nie porusza się swobodnie, sprawdź ustawienie "enable_pin" w konfiguracji dla danej osi. W przypadku większości popularnych silniczków krokowych ustawiony "enable_pin" powinien podawać bliskie zeru (lub zerowe) napięcie. Jeżeli jest inaczej, wstaw znak "!" przed "enable_pin" (np. "enable_pin: !PA1").

## Sprawdź krańcówki

Manualnie przesuń wszystkie osie, aby żadna z nich nie zwierała czujnika krańcowego. Wywołaj komendę QUERY_ENDSTOPS poprzez konsolę. Powinna ona zwrócić status wszystkich skonfigurowanych krańcówek, a status każdej z nich powinien być wskazany jako "OTWARTA". Dla każdej krańcówki wywołaj ponownie komendę QUERY_ENDSTOPS jednocześnie wyzwalając ją ręcznie. Komenda QUERY_ENDSTOPS powinna zwrócić wartość "ZWARTA".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!PA2"), or remove the "!" if there is already one present.

Jeżeli stan krańcówki nie zmienia się, to oznacza to, że jest ona podłączona do innego pinu. Jednak może również być wymagana zmiana ustawienia pullup dla tego pinu ('^' na początku nazwy endstop_pin - większość drukarek będzie używać rezystora pullup i '^' powinno to być zdefiniowane).

## Weryfikacja silników krokowych

Wywołaj komendę STEPPER_BUZZ, aby zweryfikować prawidłowość podłączenia każdego z silniczków krokowych. Rozpocznij, ustawiając manualnie każdą oś w pozycji środkowej, a następnie wywołaj komendę `STEPPER_BUZZ STEPPER=stepper_x` (dla osi X) w konsoli. Komenda STEPPER_BUZZ spowoduje ruch wskazanego silniczka o 1 mm w górę, a następnie powrót do pozycji wyjściowej. Jeżeli w konfiguracji drukarki punkt krańcowy zdefiniowano jako position_endstop=0, wtedy wraz z rozpoczęciem każdego ruchu testowego silniczek będzie "odsuwał się" od punktu krańcowego. Ruch testowy będzie automatycznie powtórzony 10 razy.

Jeśli stepper nie porusza się w ogóle, sprawdź poprawność ustawienia parametrów "enable_pin" i "step_pin" dla danego steppera. Jeśli silnik krokowy porusza się, ale nie powraca do pozycji wyjściowej, należy sprawdzić ustawienie "dir_pin". Jeśli silnik krokowy oscyluje w niewłaściwym kierunku, oznacza to z reguły, że "dir_pin" dla osi musi zostać odwrócony. W tym celu należy dodać znak "!" do "dir_pin" w pliku konfiguracyjnym drukarki (lub usunąć go, jeśli już tam jest). Jeśli silnik porusza się znacznie więcej lub znacznie mniej niż jeden milimetr, należy sprawdzić ustawienie "rotation_distance".

Uruchom powyższy test dla każdego silnika krokowego zdefiniowanego w pliku konfiguracyjnym. (Ustaw parametr STEPPER komendy STEPPER_BUZZ na nazwę sekcji konfiguracyjnej, która ma być testowana.) Jeśli w ekstruderze nie ma filamentu, można użyć STEPPER_BUZZ do weryfikacji połączenia silnika ekstrudera (użyj STEPPER=extruder). W przeciwnym razie najlepiej przetestować silnik ekstrudera osobno (patrz następna sekcja).

Po sprawdzeniu wszystkich ograniczników i sprawdzeniu wszystkich silników krokowych należy przetestować mechanizm samonaprowadzający. Wydaj polecenie G28, aby bazować wszystkie osie. Odłącz zasilanie od drukarki, jeśli nie działa prawidłowo. W razie potrzeby ponownie wykonaj kroki weryfikacji ogranicznika i silnika krokowego.

## Sprawdź silnik wytłaczarki

Aby przetestować działanie ekstrudera, niezbędne jest jego nagrzanie do temperatury roboczej. Przejdź do sekcji z wykresem temperatur, w polu Ekstruder z listy rozwijanej wybierz docelową temperaturę (lub wpisz ją ręcznie) i zatwierdź Enter'em. Poczekaj, aż ekstruder osiągnie zadaną temperaturę. Następnie wciśnij przycisk "Extrude". Zweryfikuj, czy silniczek ekstrudera obraca się w prawidłową stronę. Jeżeli nie, przejrzyj wskazówki z poprzedniego kroku, sprawdzając ustawienie "enable_pin", "step_pin" oraz "dir_pin" w sekcji ekstrudera.

## Skalibruj ustawienia PID

Klipper obsługuje [sterowanie PID](https://en.wikipedia.org/wiki/PID_controller) dla ekstrudera i grzałek stołu. Aby użyć tego mechanizmu sterowania, konieczne jest skalibrowanie ustawień PID na każdej drukarce (ustawienia PID znalezione w innych firmware'ach lub w przykładowych plikach konfiguracyjnych często działają słabo).

Aby skalibrować ekstruder, przejdź do konsoli i wywołaj komendę PID_CALIBRATE (np. `PID_CALIBRATE HEATER=extruder TARGET=170`)

Po zakończeniu testu dostrajania uruchom `SAVE_CONFIG`, aby zaktualizować plik printer.cfg o nowemu ustawienia PID.

Jeśli drukarka ma podgrzewane łoże i obsługuje ono sterowanie PWM (modulacja szerokości impulsu), zaleca się stosowanie sterowania PID dla łoża. (Gdy podgrzewacz łoża jest sterowany za pomocą algorytmu PID, może on włączać się i wyłączać dziesięć razy na sekundę, co może nie być odpowiednie dla podgrzewaczy wykorzystujących przełącznik mechaniczny). Typowa komenda kalibracji PID łóżka to: `PID_CALIBRATE HEATER=heater_bed TARGET=60`.

## Następne kroki

Ten dokument ma na celu pomóc w podstawowej weryfikacji ustawień pinów w pliku konfiguracyjnym Klippera. Należy zapoznać się z przewodnikiem [Bed Leveling](Bed_Level.md). Zobacz także dokument [Slicers](Slicers.md), aby uzyskać informacje na temat konfigurowania slicera za pomocą programu Klipper.

Po sprawdzeniu, że podstawowe drukowanie działa, warto rozważyć kalibrację [pressure advance](Pressure_Advance.md).

Może być konieczne przeprowadzenie innych rodzajów szczegółowej kalibracji drukarki - w sieci dostępnych jest wiele poradników, które w tym pomogą (na przykład wyszukaj w Internecie hasło "3d printer calibration"). Na przykład, jeśli doświadczasz efektu zwanego dzwonieniem, możesz spróbować zastosować się do instrukcji strojenia [Kompensacja rezonansu](Resonance_Compensation.md).
