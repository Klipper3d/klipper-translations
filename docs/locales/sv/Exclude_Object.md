# Uteslut objekt

The `[exclude_object]` module allows Klipper to exclude objects while a print is in progress. To enable this feature include an [exclude_object config
section](Config_Reference.md#exclude_object) (also see the [command
reference](G-Codes.md#exclude-object) and [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.)

Till skillnad från andra alternativ för 3D-skrivarens fasta programvara använder en skrivare med Klipper en uppsättning komponenter, och användaren kan välja mellan många alternativ. För att ge en konsekvent användarupplevelse upprättar modulen `[exclude_object]` därför ett slags kontrakt eller API. Kontraktet omfattar innehållet i gcode-filen, hur modulens interna tillstånd styrs och hur tillståndet lämnas till klienter.

## Översikt över arbetsflödet

Ett typiskt arbetsflöde för utskrift av en fil kan se ut så här:

1. Skivningen slutförs och filen laddas upp för utskrift. Vid uppladdningen bearbetas filen och markörer för `[exclude_object]` läggs till. Alternativt kan skivningsprogram konfigureras för att skapa markörer för objektuteslutning direkt eller i ett eget förbearbetningssteg.
1. När utskriften startar återställer Klipper [statusen](Status_Reference.md#exclude_object) för `[exclude_object]`.
1. När Klipper bearbetar blocket `EXCLUDE_OBJECT_DEFINE` uppdaterar det statusen med de kända objekten och skickar den till klienter.
1. Klienten kan använda informationen för att visa ett användargränssnitt där förloppet kan följas. Klipper uppdaterar statusen så att den omfattar det objekt som skrivs ut, vilket klienten kan använda för visning.
1. Om användaren begär att ett objekt ska avbrytas skickar klienten kommandot `EXCLUDE_OBJECT NAME=<name>` till Klipper.
1. När Klipper bearbetar kommandot lägger det till objektet i listan över uteslutna objekt och uppdaterar klientens status.
1. Klienten tar emot den uppdaterade statusen från Klipper och kan använda informationen för att återspegla objektets status i användargränssnittet.
1. När utskriften är klar fortsätter statusen för `[exclude_object]` att vara tillgänglig tills en annan åtgärd återställer den.

## GCode-filen

Den särskilda gcode-bearbetning som krävs för att stödja objektuteslutning passar inte Klippers centrala designmål. Modulen kräver därför att filen bearbetas innan den skickas till Klipper för utskrift. Två sätt att förbereda filen för Klipper är att använda ett efterbearbetningsskript i skivningsprogrammet eller låta mellanprogramvara bearbeta filen vid uppladdning. Det finns ett referensskript för efterbearbetning, både som körbar fil och Python-bibliotek; se [cancelobject-preprocessor](https://github.com/kageurufu/cancelobject-preprocessor).

### Objektdefinitioner

Kommandot `EXCLUDE_OBJECT_DEFINE` används för att ge en sammanfattning av varje objekt i den gcode-fil som ska skrivas ut. Objekt behöver inte definieras för att kunna hänvisas till av andra kommandon. Huvudsyftet med kommandot är att ge användargränssnittet information utan att det behöver tolka hela gcode-filen.

Objektdefinitioner har namn så att användaren enkelt kan välja ett objekt som ska uteslutas. Ytterligare metadata kan lämnas för grafisk visning vid avbrott. Definierade metadata omfattar för närvarande en `CENTER`-koordinat X,Y och en `POLYGON`-lista med X,Y-punkter som beskriver objektets minsta kontur. Det kan vara en enkel begränsningsruta eller en mer komplicerad omslutning för mer detaljerad visualisering av utskrivna objekt. När gcode-filer innehåller flera delar med överlappande begränsningsområden blir särskilt mittpunkter svåra att skilja visuellt. `POLYGONS` måste vara en JSON-kompatibel matris med punkt-tuplerna `[X,Y]` utan blanksteg. Ytterligare parametrar sparas som strängar i objektdefinitionen och lämnas i statusuppdateringar.

`EXCLUDE_OBJECT_DEFINE NAME=calibration_pyramid CENTER=50,50 POLYGON=[[40,40],[50,60],[60,40]]`

All available G-Code commands are documented in the [G-Code
Reference](./G-Codes.md#excludeobject)

## Statusinformation

The state of this module is provided to clients by the [exclude_object
status](Status_Reference.md#exclude_object).

Statusen återställs när:

- Klippers fasta programvara startas om.
- `[virtual_sdcard]` återställs. Klipper återställer den särskilt när en utskrift startar.
- Kommandot `EXCLUDE_OBJECT_DEFINE RESET=1` utfärdas.

Listan över definierade objekt representeras i statusfältet `exclude_object.objects`. I en väldefinierad gcode-fil görs detta med kommandon `EXCLUDE_OBJECT_DEFINE` i början av filen. Då får klienterna objektnamn och koordinater så att användargränssnittet kan ge en grafisk representation av objekten vid behov.

Allteftersom utskriften fortskrider uppdateras statusfältet `exclude_object.current_object` när Klipper bearbetar kommandona `EXCLUDE_OBJECT_START` och `EXCLUDE_OBJECT_END`. Fältet `current_object` anges även om objektet har uteslutits. Odefinierade objekt som markeras med `EXCLUDE_OBJECT_START` läggs till bland de kända objekten för att hjälpa användargränssnittet med ledtrådar, utan ytterligare metadata.

När kommandon `EXCLUDE_OBJECT` utfärdas lämnas listan över uteslutna objekt i matrisen `exclude_object.excluded_objects`. Eftersom Klipper läser framåt för att bearbeta kommande gcode kan det uppstå en fördröjning mellan att kommandot utfärdas och att statusen uppdateras.
