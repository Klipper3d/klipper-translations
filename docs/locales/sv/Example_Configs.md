# Exempelkonfigurationer

Det här dokumentet innehåller riktlinjer för att bidra med en exempelkonfiguration för Klipper till Klippers GitHub-förråd, som finns i [konfigurationskatalogen](../config/).

[Klippers Community Discourse-server](https://community.klipper3d.org) är också en användbar resurs för att hitta och dela konfigurationsfiler.

## Riktlinjer

1. Välj lämpligt prefix för konfigurationsfilens namn:
   1. Prefixet `printer` används för standardskrivare som säljs av en etablerad tillverkare.
   1. Prefixet `generic` används för 3D-skrivarkort som kan användas i många olika typer av skrivare.
   1. Prefixet `kit` används för 3D-skrivare som monteras enligt en välanvänd specifikation. Sådana "kit"-skrivare skiljer sig från vanliga "skrivare" genom att de inte säljs av en tillverkare.
   1. Prefixet `sample` används för konfigurations"utdrag" som kan kopieras och klistras in i huvudkonfigurationsfilen.
   1. Prefixet `example` används för att beskriva skrivarens kinematik. Den här typen av konfiguration läggs normalt bara till tillsammans med kod för en ny typ av skrivarkinematik.
1. Alla konfigurationsfiler måste sluta med `.cfg`. Konfigurationsfiler med `printer` måste sluta med ett årtal följt av `.cfg`, till exempel `-2019.cfg`. Årtalet är ungefär det år då skrivaren såldes.
1. Använd inte blanksteg eller specialtecken i konfigurationsfilens namn. Filnamnet får endast innehålla `A-Z`, `a-z`, `0-9`, `-` och `.`.
1. Klipper måste kunna starta exempelkonfigurationsfilerna `printer`, `generic` och `kit` utan fel. Lägg till dem i regressionstestet [test/klippy/printers.test](../test/klippy/printers.test), i rätt avsnitt och i alfabetisk ordning.
1. Exempelkonfigurationen ska motsvara skrivarens standardkonfiguration. Endast skrivare, kit och kort med etablerad användning läggs till; använd Discourse-servern för andra konfigurationer.
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. Ange inte `pressure_advance` i en exempelkonfiguration, eftersom värdet är specifikt för filamentet och inte skrivarens maskinvara. Ange inte heller `max_extrude_only_velocity` eller `max_extrude_only_accel`.
   1. Ange inte en konfigurationsdel som innehåller värdsökväg eller värdmaskinvara, till exempel `[virtual_sdcard]` eller `[temperature_host]`.
   1. Definiera endast makron som använder funktioner specifika för skrivaren eller G-kod som vanligtvis genereras av skivningsprogram konfigurerade för skrivaren.
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. Kopiera inte fältdokumentationen till exempelkonfigurationsfilerna. Det skapar ett underhållsarbete eftersom en dokumentationsuppdatering då måste göras på många platser.
   1. Exempelkonfigurationsfiler ska inte innehålla avsnittet "SAVE_CONFIG". Kopiera vid behov relevanta fält från SAVE_CONFIG till lämpligt avsnitt i huvudkonfigurationsområdet.
   1. Använd syntaxen `field: value` i stället för `field=value`.
   1. När en extruders `rotation_distance` läggs till är det bättre att ange en `gear_ratio` om extrudern har utväxling. I exempelkonfigurationerna förväntas rotation_distance motsvara omkretsen på extruderns räfflade drivhjul, normalt 20–35 mm. Ange de faktiska kugghjulen, exempelvis `gear_ratio: 80:20` hellre än `gear_ratio: 4:1`. Se [dokumentet om rotationsavstånd](Rotation_Distance.md#using-a-gear_ratio).
   1. Undvik att definiera fältvärden som redan har sitt standardvärde. Ange till exempel inte `min_extrude_temp: 170`, eftersom det redan är standardvärdet.
   1. Rader bör om möjligt inte överskrida 80 kolumner.
   1. Undvik att lägga till upphovs- eller revisionsmeddelanden i konfigurationsfilerna, till exempel "this file was created by ...". Lägg i stället upphovsuppgift och ändringshistorik i Git-commitmeddelandet.
1. Använd inte funktioner som är föråldrade i exempelkonfigurationsfilen.
1. Inaktivera inte ett standardsäkerhetssystem i en exempelkonfigurationsfil. Ange till exempel inte ett eget `max_extrude_cross_section`. Aktivera inte felsökningsfunktioner; det ska exempelvis inte finnas något `force_move`-avsnitt.
1. Alla kända kort som Klipper stöder kan använda den seriella standardhastigheten 250000 baud. Rekommendera inte en annan hastighet i en exempelkonfigurationsfil.

Exempelkonfigurationsfiler skickas in genom att skapa en GitHub-"pull request". Följ även anvisningarna i [bidragsdokumentet](CONTRIBUTING.md).
