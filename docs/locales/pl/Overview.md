# Przegląd

Witaj w dokumentacji Klipper. Jeśli jesteś nowy, zapoznaj się z [funkcjami](Features.md) i [instalacją](Installation.md).

## Ogólne informacje

- [Funkcje](Features.md): Szczegółowa lista funkcji w Klipperze.
- [FAQ](FAQ.md): Często zadawane pytania.
- [Wydania](Releases.md): Historia wydań Klippera.
- [Zmiany konfiguracji](Config_Changes.md): Ostatnie zmiany w oprogramowaniu, które mogą wymagać od użytkowników zaktualizowania pliku konfiguracyjnego drukarki.
- [Kontakt](Contact.md): Informacje na temat zgłaszania błędów i ogólnej komunikacji z deweloperami Klippera.

## Instalacja i konfiguracja

- [Instalacja](Installation.md): Przewodnik po instalacji Klippera.
- [Odniesienie do konfiguracji](Config_Reference.md): Opis parametrów konfiguracji.
   - [Odległość obrotu](Rotation_Distance.md): Obliczanie parametru krokowego rotation_distance.
- [Kontrola konfiguracji](Config_checks.md): Weryfikacja podstawowych ustawień pinów w pliku konfiguracyjnym.
- [Poziomowanie stołu](Bed_Level.md): Informacje na temat "poziomowania stołu" w Klipperze.
   - [Kalibracja delta](Delta_Calibrate.md): Kalibracja kinematyki delta.
   - [Kalibracja sondy](Probe_Calibrate.md): Kalibracja automatycznych sond Z.
   - [BL-Touch](BLTouch.md): Konfiguracja sondy Z typu "BL-Touch".
   - [Ręczne poziomowanie](Manual_Level.md): Kalibracja krańcówek Z (i podobnych).
   - [Siatka stołu](Bed_Mesh.md): Korekcja wysokości stołu na podstawie lokalizacji XY.
   - [Faza krańcówki](Endstop_Phase.md): Pozycjonowanie krańcówki Z ze wspomaganiem krokowym.
   - [Kompensacja skrętu osi](Axis_Twist_Compensation.md): Narzędzie do kompensacji niedokładnych odczytów sondy spowodowanych skręceniem suwnicy osi X.
- [Kompensacja rezonansu](Resonance_Compensation.md): Narzędzie do kompensacji rezonansu drukarki podczas druku.
   - [Pomiar rezonansów](Measuring_Resonances.md): Informacje na temat używania sprzętowego akcelerometru adxl345 do pomiaru rezonansu.
- [Pressure Advance](Pressure_Advance.md): Kalibracja ciśnienia wytłaczarki filamentu.
- [Kody G](G-Codes.md): Informacje o poleceniach obsługiwanych przez Klippera.
- [Szablony poleceń](Command_Templates.md): Makra kodu G i ocena warunkowa.
   - [Referencje statusu](Status_Reference.md): Informacje o makrach (i podobnych).
- [Sterowniki TMC](TMC_Drivers.md): Używanie sterowników silników krokowych Trinamic z Klipperem.
- [Bazowanie MultiMCU](Multi_MCU_Homing.md): Bazowanie i sondowanie przy użyciu wielu mikrokontrolerów.
- [Slicery](Slicers.md): Konfiguracja oprogramowania "slicer" dla Klippera.
- [Korekta przekrzywienia](Skew_Correction.md): Korekty dla osi, które nie są idealnie prostopadłe.
- [Narzędzia PWM](Using_PWM_Tools.md): Przewodnik po tym, jak korzystać z narzędzi sterowanych PWM, takich jak lasery lub wrzeciona.
- [Wykluczanie obiektów](Exclude_Object.md): Przewodnik po implementacji wykluczania obiektów (Exclude Objects).

## Dokumentacja dla programistów

- [Przegląd kodu](Code_Overview.md): Deweloperzy powinni przeczytać to w pierwszej kolejności.
- [Kinematyka](Kinematics.md): Szczegóły techniczne dotyczące sposobu, w jaki Klipper implementuje ruch.
- [Protokół](Protocol.md): Informacje na temat niskopoziomowego protokołu przesyłania wiadomości między hostem a mikrokontrolerem.
- [Serwer API](API_Server.md): Informacje na temat interfejsu API poleceń i sterowania Klippera.
- [Polecenia MCU](MCU_Commands.md): Opis niskopoziomowych poleceń zaimplementowanych w oprogramowaniu mikrokontrolera.
- [Protokół magistrali CAN](CANBUS_protocol.md): Format wiadomości magistrali CAN Klippera.
- [Debugowanie](Debugowanie.md): Informacje na temat testowania i debugowania Klippera.
- [Benchmarki](Benchmarks.md): Informacje na temat metody benchmarku Klippera.
- [Współtworzenie](CONTRIBUTING.md): Informacje o tym, jak dodawać ulepszenia do Klippera.
- [Pakowanie](Packaging.md): Informacje na temat budowania pakietów systemu operacyjnego.

## Dokumenty specyfikacyjne urządzenia

- [Przykładowe konfiguracje](Example_Configs.md): Informacje na temat dodawania przykładowego pliku konfiguracyjnego do Klippera.
- [Aktualizacje kartą SD](SDCard_Updates.md): Programowanie mikrokontrolera poprzez skopiowanie pliku binarnego na kartę SD w mikrokontrolerze.
- [Raspberry Pi jako mikrokontroler](RPi_microcontroller.md): Szczegóły dotyczące sterowania urządzeniami podłączonymi do pinów GPIO Raspberry Pi.
- [Beaglebone](Beaglebone.md): Szczegóły dotyczące uruchamiania Klippera na Beaglebone PRU.
- [Bootloadery](Bootloaders.md): Informacje dla programistów dotyczące programowania mikrokontrolerów.
- [Bootloader Entry](Bootloader_Entry.md): Requesting the bootloader.
- [Magistrala CAN](CANBUS.md): Informacje na temat korzystania z magistrali CAN z Klipperem.
   - [Rozwiązywanie problemów CAN](CANBUS_Troubleshooting.md): Wskazówki dotyczące rozwiązywania problemów z magistralą CAN.
- [Czujnik szerokości filamentu TSL1401CL](TSL1401CL_Filament_Width_Sensor.md)
- [Czujnik szerokości filamentu Halla](Hall_Filament_Width_Sensor.md)
