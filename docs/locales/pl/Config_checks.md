# Kontrola konfiguracji

Ten dokument zawiera listę kroków, które pomogą potwierdzić ustawienia pinów w pliku konfiguracyjnym klipper printer.cfg. Dobrym pomysłem jest wykonanie tych kroków po wykonaniu czynności opisanych w [installation document](Installation.md).

Podczas tego przewodnika może być konieczne wprowadzenie zmian w pliku konfiguracyjnym Klippera. Pamiętaj, aby wydać polecenie RESTART po każdej zmianie w pliku konfiguracyjnym, aby mieć pewność, że zmiana zacznie obowiązywać (wpisz „restart” w zakładce terminala Octoprint, a następnie kliknij „Wyślij”). Dobrym pomysłem jest również wydanie polecenia STATUS po każdym RESTARTU, aby sprawdzić, czy plik konfiguracyjny został pomyślnie załadowany.

## Sprawdź temperaturę

Zacznij od sprawdzenia, czy temperatury są prawidłowo raportowane. Przejdź do zakładki Temperatura Octoprint.

![octoprint-temperature](img/octoprint-temperature.png)

Sprawdź, czy temperatura dyszy i złoża (jeśli dotyczy) jest obecna i nie wzrasta. Jeśli rośnie, odłącz zasilanie od drukarki. Jeśli temperatury nie rosnie, sprawdź ustawienia „sensor_type” i „sensor_pin” dla dyszy i/lub stołu.

## Sprawdź M112

Przejść do karty terminala Octoprint i wyday polecenie M112 w oknie terminala. To polecenie żąda, aby Klipper przeszedł w stan "wyłączenia". Spowoduje odłączenie się ze urządzenia Octoprint od urządzenia Klipper - przejść do obszaru Połączenie i klikni "Połącz", aby spowodować ponowne połączenie się z urządzeniem Octoprint. Następnie przejść do karty Temperatura Octoprint i sprawdzić, czy temperatury są nadal aktualizowane i czy nie wzrastają. Jeśli temperatury wzrastają, odłączyć zasilanie od drukarki.

Komenda M112 powoduje przejście Klippera w stan "shutdown". Opuszczenie tego stanu można wywołać komendą FIRMWARE_RESTART w zakładce terminala Octoprint.

## Sprawdź grzałki

Przejść do zakładki Octoprint temperature i wpisai 50 w polu temperatury "Tool". Temperatura ekstrudera na wykresie powinna zacząć wzrastać (w ciągu około 30 sekund lub tak). Następnie przechodzimy do rozwijanego pola temperatury "Tool" i wybieramy "Off". Po kilku minutach temperatura powinna zacząć wracać do początkowej wartości temperatury pokojowej. Jeśli temperatura nie wzrasta, należy sprawdzić ustawienie "heater_pin" w konfiguracji.

Jeśli drukarka ma podgrzewane łoże, wykonaj powyższy test ponownie z tym łożem.

## Sprawdź pin włączający silnik krokowy

Sprawdź, czy wszystkie osie drukarki można przesunąć ręcznie (przy wyłączonych silnikach krokowych). Jeśli nie, wyłącz silniki komendą M84. Jeśli któraś z osi nadal pozostanie aktywna, sprawdź konfigurację "enable_pin" danej osi. Większość sterowników silników krokowych ma pin enable aktywny przy niskim stanie dlatego w konfiguracji pin należy wstawić "!" przed nazwą pinu (np. enable_pin:!ar38").

## Sprawdź krańcówki

Ręcznie przesunąć wszystkie osie drukarki tak, aby żadna z nich nie stykała się z ogranicznikiem krańcowym. Wysłać polecenie QUERY_ENDSTOPS przez kartę terminala Octoprint. Powinno ono odpowiedzieć podając aktualny stan wszystkich skonfigurowanych ograniczników krańcowych i wszystkie powinny zgłaszać stan "otwarty". Dla każdego z tych punktów końcowych ponownie uruchomić polecenie QUERY_ENDSTOPS, ręcznie wyzwalając punkt końcowy. Polecenie QUERY_ENDSTOPS powinno zgłaszać wyłącznik krańcowy jako "TRIGGERED" (wyzwolony).

Jeśli endstop wydaje się odwrócony (zgłasza "otwarty", gdy jest wyzwolony i odwrotnie), to dodaj "!" do definicji pinu (na przykład, "endstop_pin: ^!ar3"), lub usuń "!", jeśli już jest obecny.

Jeżeli endstop w ogóle się nie zmienia, to generalnie oznacza to, że endstop jest podłączony do innego pinu. Jednak może to również wymagać zmiany ustawienia pullup dla tego pinu ('^' na początku nazwy endstop_pin - większość drukarek będzie używać rezystora pullup i '^' powinno być obecne).

## Weryfikacja silników krokowych

Użyj komendy STEPPER_BUZZ aby zweryfikować łączność każdego silnika krokowego. Zacznij od ręcznego ustawienia danej osi w punkcie środkowym, a następnie uruchom `STEPPER_BUZZ STEPPER=stepper_x`. Komenda STEPPER_BUZZ spowoduje, że dany krokowiec przesunie się o jeden milimetr w kierunku dodatnim, a następnie powróci do pozycji wyjściowej. (Jeśli endstop jest zdefiniowany na position_endstop=0 to na początku każdego ruchu stepper odsunie się od endstopu). Oscylacja ta zostanie wykonana dziesięć razy.

Jeśli stepper nie porusza się w ogóle, to następnie sprawdc ustawienia "enable_pin" i "step_pin" dla steppera. Jeśli silnik krokowy porusza się, ale nie powraca do pozycji wyjściowej, należy sprawdzić ustawienie "dir_pin". Jeśli silnik krokowy oscyluje w niewłaściwym kierunku, oznacza to z reguły, że "dir_pin" dla osi musi zostać odwrócony. W tym celu należy dodać znak "!" do "dir_pin" w pliku konfiguracyjnym drukarki (lub usunąć go, jeśli już tam jest). Jeśli silnik porusza się znacznie więcej lub znacznie mniej niż jeden milimetr, należy sprawdzić ustawienie "rotation_distance".

Uruchom powyższy test dla każdego silnika krokowego zdefiniowanego w pliku konfiguracyjnym. (Ustaw parametr STEPPER komendy STEPPER_BUZZ na nazwę sekcji konfiguracyjnej, która ma być testowana.) Jeśli w ekstruderze nie ma filamentu, można użyć STEPPER_BUZZ do weryfikacji połączenia silnika ekstrudera (użyj STEPPER=extruder). W przeciwnym razie najlepiej przetestować silnik ekstrudera osobno (patrz następna sekcja).

Po sprawdzeniu wszystkich ograniczników i sprawdzeniu wszystkich silników krokowych należy przetestować mechanizm samonaprowadzający. Wydaj polecenie G28, aby bazować wszystkie osie. Odłącz zasilanie od drukarki, jeśli nie działa prawidłowo. W razie potrzeby ponownie wykonaj kroki weryfikacji ogranicznika i silnika krokowego.

## Sprawdź silnik wytłaczarki

Aby przetestować silnik ekstrudera, konieczne będzie podgrzanie ekstrudera do temperatury drukowania. Przejdź do zakładki Octoprint temperature i wybierz temperaturę docelową z listy rozwijanej temperatury (lub ręcznie wprowadź odpowiednią temperaturę). Poczekaj, aż drukarka osiągnie żądaną temperaturę. Następnie przejdź do zakładki Octoprint control i kliknij przycisk „Extrude”. Sprawdź, czy silnik ekstrudera obraca się we właściwym kierunku. Jeśli tak nie jest, zapoznaj się ze wskazówkami rozwiązywania problemów w poprzedniej sekcji, aby potwierdzić ustawienia „enable_pin”, „step_pin” i „dir_pin” dla ekstrudera.

## Skalibruj ustawienia PID

Klipper obsługuje [PID control](https://en.wikipedia.org/wiki/PID_controller) dla ekstrudera i podgrzewaczy stołu. Aby skorzystać z tego mechanizmu sterującego, konieczne jest skalibrowanie ustawień PID na każdej drukarce. (Ustawienia PID znalezione w innych firmware lub w przykładowych plikach konfiguracyjnych często działają słabo.)

Aby skalibrować ekstruder, przejdź do zakładki terminala OctoPrint i uruchom polecenie PID_CALIBRATE. Na przykład: `PID_CALIBRATE HEATER=extruder TARGET=170`.`

Po zakończeniu testu dostrajania uruchom `SAVE_CONFIG`, aby zaktualizować plik printer.cfg o nowemu ustawienia PID.

Jeśli drukarka ma podgrzewane łoże i obsługuje ono sterowanie PWM (modulacja szerokości impulsu), zaleca się stosowanie sterowania PID dla łoża. (Gdy podgrzewacz łoża jest sterowany za pomocą algorytmu PID, może on włączać się i wyłączać dziesięć razy na sekundę, co może nie być odpowiednie dla podgrzewaczy wykorzystujących przełącznik mechaniczny). Typowa komenda kalibracji PID łóżka to: `PID_CALIBRATE HEATER=heater_bed TARGET=60`.

## Następne kroki

Ten dokument ma na celu pomóc w podstawowej weryfikacji ustawień pinów w pliku konfiguracyjnym Klippera. Należy zapoznać się z przewodnikiem [Bed Leveling](Bed_Level.md). Zobacz także dokument [Slicers](Slicers.md), aby uzyskać informacje na temat konfigurowania slicera za pomocą programu Klipper.

Po sprawdzeniu, że podstawowe drukowanie działa, warto rozważyć kalibrację [pressure advance] (Pressure_Advance.md).

Może być konieczne przeprowadzenie innych rodzajów szczegółowej kalibracji drukarki - w sieci dostępnych jest wiele poradników, które w tym pomogą (na przykład wyszukaj w Internecie hasło "3d printer calibration"). Na przykład, jeśli doświadczasz efektu zwanego dzwonieniem, możesz spróbować zastosować się do instrukcji strojenia [Kompensacja rezonansu](Resonance_Compensation.md).
