# Voorbeeld configuraties

Dit document bevat richtlijnen voor het toevoegen van een voorbeeld van een Klipper-configuratie aan de Klipper github-repository (te vinden in de [configuratiefolder](../config/)).

Merk op dat de [Klipper Community Discourse server](https://community.klipper3d.org) ook een nuttige bron is voor het vinden en delen van configuratiebestanden.

## Richtlijnen

1. Selecteer het juiste voorvoegsel van de configuratiebestandsnaam:
   1. Het voorvoegsel `printer` wordt gebruikt voor standaardprinters die worden verkocht door een reguliere fabrikant.
   1. Het voorvoegsel `generic` wordt gebruikt voor een 3D-printerkaart die in veel verschillende soorten printers kan worden gebruikt.
   1. Het voorvoegsel `kit` is voor 3D-printers die zijn samengesteld volgens een veelgebruikte specificatie. Deze "kit"-printers onderscheiden zich over het algemeen van normale "printers" doordat ze niet door een fabrikant worden verkocht.
   1. Het voorvoegsel `sample` wordt gebruikt voor configuratie-"fragmenten" (snippets) die men kan kopiëren en plakken in het hoofdconfiguratiebestand.
   1. Het voorvoegsel `example` wordt gebruikt om de kinematica van de printer te beschrijven. Dit type configuratie wordt meestal alleen toegevoegd samen met code voor een nieuw type printerkinematica.
1. Alle configuratiebestanden moeten eindigen op een `.cfg`-achtervoegsel. De `printer` configuratiebestanden moeten eindigen in een jaar gevolgd door `.cfg` (bijv. `-2019.cfg`). In dit geval is het jaar bij benadering het jaar waarin de printer is verkocht.
1. Gebruik geen spaties of speciale tekens in de configuratiebestandsnaam. De bestandsnaam mag alleen de tekens `A-Z`, `a-z`, `0-9`, `-` en `.` bevatten.
1. Klipper moet het configuratiebestand `printer`, `generiek` en `kit` zonder fouten kunnen starten. Deze configuratiebestanden moeten worden toegevoegd aan de [test/klippy/printers.test](../test/klippy/printers.test) regressietestcase. Voeg nieuwe configuratiebestanden toe aan die testcase in de juiste sectie en in alfabetische volgorde binnen die sectie.
1. De voorbeeldconfiguratie moet voor de "generieke" -configuratie van de printer zijn. (Er zijn te veel "aangepaste" configuraties om bij te houden in de hoofdrepository van Klipper.) Evenzo voegen we alleen voorbeeldconfiguratiebestanden toe voor printers, kits en boards die algemeen populair zijn (er zouden er bijvoorbeeld minstens 100 moeten zijn in actief gebruik). Overweeg om de [Klipper Community Discourse server](https://community.klipper3d.org) te gebruiken voor andere configuraties.
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. Specificeer `pressure_advance` niet in een voorbeeldconfiguratie, aangezien die waarde specifiek is voor het filament, niet voor de printerhardware. Geef op dezelfde manier geen `max_extrude_only_velocity`- of `max_extrude_only_accel`-instellingen op.
   1. Geef geen configuratiesectie op die een hostpad of hosthardware bevat. Geef bijvoorbeeld geen `[virtual_sdcard]` of `[temperature_host]` configuratiesecties op.
   1. Definieer alleen macro's die functionaliteit gebruiken die specifiek is voor de bepaalde printer of om g-codes te definiëren die gewoonlijk worden ingevoegd door slicers die voor de bepaalde printer zijn geconfigureerd.
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. Kopieer de velddocumentatie niet naar de voorbeeldconfiguratiebestanden. (Als u dit wel doet, ontstaat er een onderhoudslast, aangezien een update van de documentatie deze dan op veel plaatsen zou moeten wijzigen.)
   1. Voorbeeldconfiguratiebestanden mogen geen "SAVE_CONFIG"-sectie bevatten. Kopieer indien nodig de relevante velden van de SAVE_CONFIG-sectie naar de juiste sectie in het hoofdconfiguratiegebied.
   1. Gebruik `field: value` syntaxis in plaats van `field=value`.
   1. Bij het toevoegen van een extruder `rotation_distance` verdient het de voorkeur om een `gear_ratio` op te geven als de extruder een tandwielmechanisme heeft. We verwachten dat de rotation_distance in de voorbeeldconfiguraties correleert met de omtrek van het gekarteld-tandwiel in de extruder - normaal gesproken ligt deze tussen de 20 en 35 mm. Bij het specificeren van een `overbrengingsverhouding` verdient het de voorkeur om de daadwerkelijke versnellingen op het mechanisme te specificeren (geef bijvoorbeeld de voorkeur aan `overbrengingsverhouding: 80:20` boven `overbrengingsverhouding: 4:1`). Zie het document [rotatieafstand](Rotation_Distance.md#using-a-gear_ratio) voor meer informatie.
   1. Vermijd het definiëren van veldwaarden die zijn ingesteld op hun standaardwaarde. Men zou bijvoorbeeld niet `min_extrude_temp: 170` moeten specificeren, aangezien dat al de standaardwaarde is.
   1. Waar mogelijk mogen regels niet langer zijn dan 80 tekens.
   1. Voeg geen attributie- of revisieberichten toe aan de configuratiebestanden. (Vermijd bijvoorbeeld het toevoegen van regels als "dit bestand is gemaakt door ...".) Plaats attributie- en wijzigingsgeschiedenis in het git commit-bericht.
1. Gebruik geen verouderde parameters (features) in het voorbeeldconfiguratiebestand.
1. Schakel een standaard veiligheidssysteem niet uit in een voorbeeldconfiguratiebestand. Een configuratie mag bijvoorbeeld geen aangepaste `max_extrude_cross_section` specificeren. Schakel foutopsporingsfuncties niet in. Er zou bijvoorbeeld geen `force_move` configuratiesectie moeten zijn.
1. Alle bekende boards die Klipper ondersteunt, kunnen de standaard seriële baudrate van 250000 gebruiken. Het is niet aan te raden om een andere baudrate in een voorbeeldconfiguratiebestand te gebruiken.

Voorbeeldconfiguratiebestanden worden ingediend door een github "pull request" te maken. Volg ook de aanwijzingen in het [bijdragende document](CONTRIBUTING.md).
