# Tryckutjämning

Detta dokument innehåller information om hur konfigurationsvariabeln "pressure advance" justeras för ett visst munstycke och filament. Funktionen för tryckutjämning kan bidra till att minska trådning. Mer information om hur tryckutjämning är implementerad finns i dokumentet [kinematik](Kinematics.md).

## Justera tryckutjämning

Tryckutjämning har två användbara funktioner: den minskar trådning under förflyttningar utan extrudering och minskar ansamlingar i hörn. Den här guiden använder den andra funktionen (att minska ansamlingar i hörn) för justeringen.

För att kalibrera tryckutjämning måste skrivaren vara konfigurerad och i drift, eftersom justeringstestet omfattar utskrift och granskning av ett testobjekt. Läs gärna hela dokumentet innan testet körs.

Använd en skivare för att skapa G-kod för den stora ihåliga fyrkanten i [docs/prints/square_tower.stl](prints/square_tower.stl). Använd hög hastighet (t.ex. 100 mm/s), noll utfyllnad och grov lagerhöjd (lagerhöjden bör vara cirka 75 % av munstyckets diameter). Kontrollera att all "dynamisk accelerationsstyrning" och sömmar av typen "scarf joint" är inaktiverade i skivaren.

Förbered testet genom att köra följande G-kod-kommando:

```
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
```

Kommandot får munstycket att färdas långsammare genom hörn för att betona effekterna av extrudertrycket. Kör sedan följande kommando för skrivare med direktdriven extruder:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

Använd följande för långa Bowden-extrudrar:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020
```

Skriv sedan ut objektet. När testutskriften är klar ser den ut så här:

![tuning_tower](img/tuning_tower.jpg)

Kommandot TUNING_TOWER ovan instruerar Klipper att ändra inställningen pressure_advance för varje utskriftslager. Högre lager i utskriften får ett större värde för pressure advance. Lager under det ideala värdet för pressure_advance får ansamlingar i hörnen, och lager över det ideala värdet kan ge rundade hörn och dålig extrudering före hörnet.

Utskriften kan avbrytas i förtid om hörnen inte längre skrivs ut väl; då undviker man att skriva ut lager som bevisligen ligger över det ideala värdet för pressure_advance.

Granska utskriften och använd sedan ett digitalt skjutmått för att hitta den höjd som ger hörn med bäst kvalitet. Välj vid tvekan en lägre höjd.

![tune_pa](img/tune_pa.jpg)

Värdet för pressure_advance kan sedan beräknas som `pressure_advance = <start> + <measured_height> * <factor>`. (Till exempel ger `0 + 12.90 * .020` värdet `.258`.)

Det går att välja egna inställningar för START och FACTOR om det underlättar att hitta det bästa värdet för pressure advance. Kör då kommandot TUNING_TOWER i början av varje testutskrift.

Typiska värden för pressure advance ligger mellan 0.050 och 1.000 (den övre delen vanligen endast för Bowden-extrudrar). Om tryckutjämning upp till 1.000 inte ger någon betydande förbättring är det osannolikt att funktionen förbättrar utskriftskvaliteten. Återgå då till en standardkonfiguration med tryckutjämning inaktiverad.

Även om den här justeringen direkt förbättrar hörnens kvalitet är det värt att komma ihåg att en väl inställd tryckutjämning också minskar trådning i hela utskriften.

När testet är klart anger du `pressure_advance = <calculated_value>` i avsnittet `[extruder]` i konfigurationsfilen och kör kommandot RESTART. RESTART rensar testtillståndet och återställer accelerations- och hörnhastigheterna till sina normala värden.

## Viktiga anmärkningar

* Värdet för pressure advance beror på extrudern, munstycket och filamentet. Filament från olika tillverkare eller med olika pigment kräver ofta avsevärt olika värden. Kalibrera därför tryckutjämning för varje skrivare och varje filamentrulle.
* Utskriftstemperatur och extruderingshastighet kan påverka pressure advance. Justera [extruderns rotation_distance](Rotation_Distance.md#calibrating-rotation_distance-on-extruders) och [munstyckstemperaturen](http://reprap.org/wiki/Triffid_Hunter%27s_Calibration_Guide#Nozzle_Temperature) innan tryckutjämning justeras.
* Testutskriften är utformad för hög extruderingshastighet men i övrigt "normala" skivarinställningar. En hög flödeshastighet erhålls med hög utskriftshastighet (t.ex. 100 mm/s) och grov lagerhöjd (vanligen cirka 75 % av munstyckets diameter). Övriga skivarinställningar bör ligga nära standardvärdena (t.ex. 2 eller 3 perimeterrader och normalt återdragningsavstånd). Det kan vara användbart att ge den yttre perimetern samma hastighet som resten av utskriften, men det är inget krav.
* Det är vanligt att testutskriften beter sig olika i varje hörn. Ofta lägger skivaren lagerbytet i ett av hörnen, vilket kan göra det hörnet avsevärt annorlunda än de övriga tre. Om det händer, ignorera det hörnet och justera pressure advance med de övriga tre hörnen. Även de återstående hörnen varierar ofta något. (Det kan bero på små skillnader i hur skrivarens ram reagerar på hörntagning i vissa riktningar.) Försök välja ett värde som fungerar väl för alla återstående hörn. Välj vid tvekan ett lägre värde för pressure advance.
* Om ett högt värde för pressure advance används (t.ex. över 0.200) kan extrudern börja hoppa när skrivaren återgår till normal acceleration. Systemet kompenserar för trycket genom att mata fram extra filament under accelerationen och dra tillbaka filamentet under inbromsningen. Vid hög acceleration och högt pressure advance-värde kanske extrudern inte har tillräckligt vridmoment för att mata den mängd filament som krävs. Använd då antingen lägre acceleration eller inaktivera tryckutjämning.
* När tryckutjämning har justerats i Klipper kan det ändå vara användbart att ange ett litet återdragningsvärde i skivaren (t.ex. 0.75 mm) och använda skivarens alternativ "torka vid återdragning", om det finns. Inställningarna kan bidra till att motverka trådning som orsakas av filamentets kohesion (filament som dras ut ur munstycket på grund av plastens vidhäftning). Vi rekommenderar att skivarens alternativ "Z-lyft vid återdragning" inaktiveras.
* Systemet för tryckutjämning ändrar inte verktygshuvudets tidsstyrning eller bana. En utskrift med tryckutjämning aktiverad tar lika lång tid som en utan. Tryckutjämning ändrar inte heller den totala mängd filament som extruderas under en utskrift. Funktionen ger extra extruderrörelser vid rörelsens acceleration och inbromsning. Ett mycket högt pressure advance-värde ger mycket stora extruderrörelser vid acceleration och inbromsning, och ingen konfigurationsinställning begränsar mängden sådana rörelser.
