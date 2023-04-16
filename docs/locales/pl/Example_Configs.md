# Przykładowe konfiguracje

Ten dokument zawiera wytyczne dotyczące przekazywania przykładowej konfiguracji Klippera do repozytorium github Klipper (znajdującego się w katalogu [config](../config/)).

Zauważ, że [Serwer Klipper Community Discourse](https://community.klipper3d.org) jest również użytecznym zasobem do znajdowania i udostępniania plików konfiguracyjnych.

## Wskazówki

1. Wybrać odpowiedni prefiks nazwy pliku konfiguracyjnego:
   1. Przedrostek `drukarka` jest używany w przypadku drukarek seryjnych sprzedawanych przez głównego producenta.
   1. Przedrostek `ogólny` jest używany w przypadku płytki drukarki 3D, która może być używana w wielu różnych typach drukarek.
   1. Przedrostek `kit` dotyczy drukarek 3D, które są montowane zgodnie z szeroko stosowaną specyfikacją. Te „zestawy” drukarek zasadniczo różnią się od zwykłych „drukarek” tym, że nie są sprzedawane przez producenta.
   1. Przedrostek `sample` jest używany do „fragmentów” konfiguracji, które można skopiować i wkleić do głównego pliku konfiguracyjnego.
   1. Przedrostek `example` jest używany do opisu kinematyki drukarki. Ten typ konfiguracji jest zwykle dodawany tylko wraz z kodem dla nowego typu kinematyki drukarki.
1. Wszystkie pliki konfiguracyjne muszą kończyć się przyrostkiem `.cfg`. Pliki konfiguracyjne `drukarki` muszą kończyć się po roku, po którym następuje `.cfg` (np. `-2019.cfg`). W tym przypadku rok jest przybliżonym rokiem sprzedaży danej drukarki.
1. W nazwie pliku konfiguracyjnego nie należy stosować spacji lub znaków specjalnych. Nazwa pliku powinna zawierać tylko znaki `A-Z`, `a-z`, `0-9`, `-`, oraz `.`.
1. Klipper musi być w stanie uruchomić bez błędu drukarkę `` , `generic`, oraz `zestaw` przykładowy plik konfiguracyjny. Te pliki config powinny być dodane do przypadku testowego regresji [test/klippy/printers.test](../test/klippy/printers.test). Dodaj nowe pliki config do tego przypadku testowego w odpowiedniej sekcji i w porządku alfabetycznym wewnątrz tej sekcji.
1. Przykładowa konfiguracja powinna dotyczyć konfiguracji „seryjnej” drukarki. (Istnieje zbyt wiele „niestandardowych” konfiguracji, aby można je było śledzić w głównym repozytorium Klipper.) Podobnie, dodajemy tylko przykładowe pliki konfiguracyjne dla drukarek, zestawów i płyt głównych, które są popularne (np. powinno ich być co najmniej 100 w aktywne korzystanie). Rozważ użycie [serwera Klipper Community Discourse](https://community.klipper3d.org) dla innych konfiguracji.
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. Nie określaj `pressure_advance` w przykładowej konfiguracji, ponieważ ta wartość jest specyficzna dla filamentu, a nie dla sprzętu drukarki. Podobnie, nie określaj ustawień `max_extrude_only_velocity` ani `max_extrude_only_accel`.
   1. Nie określaj sekcji konfiguracji zawierającej ścieżkę hosta lub sprzęt hosta. Na przykład nie określaj sekcji konfiguracji `[virtual_sdcard]` ani `[temperature_host]`.
   1. Definiuj tylko makra, które wykorzystują funkcjonalność specyficzną dla danej drukarki lub definiuj g-kody, które są powszechnie emitowane przez slicery skonfigurowane dla danej drukarki.
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. Nie kopiuj dokumentacji pola do przykładowych plików konfiguracyjnych. (Stwarza to obciążenie konserwacyjne, ponieważ aktualizacja dokumentacji wymagałaby zmiany w wielu miejscach).
   1. Przykładowe pliki konfiguracyjne nie powinny zawierać sekcji „SAVE_CONFIG”. W razie potrzeby skopiuj odpowiednie pola z sekcji SAVE_CONFIG do odpowiedniej sekcji w głównym obszarze konfiguracji.
   1. Użyj składni `field: value` zamiast `field=value`.
   1. Podczas dodawania ekstrudera `rotation_distance` zaleca się określenie `gear_ratio`, jeśli ekstruder ma mechanizm zębaty. Oczekujemy, że odległość_obrotu w przykładowych konfiguracjach będzie skorelowana z obwodem koła zębatego w ekstruderze - zwykle mieści się w zakresie od 20 do 35 mm. Podczas określania `gear_ratio` preferowane jest określenie rzeczywistych biegów mechanizmu (np. preferuj `gear_ratio: 80:20` zamiast `gear_ratio: 4:1`). Zobacz [dokument odległości obrotu](Rotation_Distance.md#using-a-gear_ratio), aby uzyskać więcej informacji.
   1. Unikaj definiowania wartości pól, które są ustawione na ich domyślną wartość. Na przykład, nie należy określać `min_extrude_temp: 170` ponieważ jest to już wartość domyślna.
   1. Tam, gdzie to możliwe, linie nie powinny przekraczać 80 kolumn.
   1. Unikaj dodawania wiadomości o atrybucji lub rewizji do plików konfiguracyjnych. (Na przykład unikaj dodawania linii takich jak "ten plik został utworzony przez ..."). Umieść atrybucję i historię zmian w wiadomości git commit.
1. Nie używaj żadnych przestarzałych funkcji w przykładowym pliku konfiguracyjnym.
1. Nie należy wyłączać domyślnego systemu bezpieczeństwa w przykładowym pliku konfiguracyjnym. Na przykład, config nie powinien określać niestandardowego `max_extrude_cross_section`. Nie włączaj funkcji debugowania. Na przykład nie powinna istnieć sekcja konfiguracyjna `force_move`.
1. Wszystkie znane karty obsługiwane przez Klipper mogą używać domyślnej szybkości transmisji szeregowej 250000. Nie zalecaj innej szybkości transmisji w przykładowym pliku konfiguracyjnym.

Przykładowe pliki konfiguracyjne są przesyłane poprzez utworzenie githubowego "pull request". Proszę również postępować zgodnie ze wskazówkami zawartymi w dokumencie [contributing document](CONTRIBUTING.md).
