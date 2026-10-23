# Skivningsprogram

Detta dokument ger några tips om hur ett skivningsprogram konfigureras för användning med Klipper. Vanliga skivningsprogram med Klipper är Slic3r, Cura, Simplify3D med flera.

## Ställ in G-Code-variant på Marlin

Många skivningsprogram har ett alternativ för att ställa in G-Code-variant. Standardvärdet är ofta Marlin, och det fungerar bra med Klipper. Inställningen Smoothieware fungerar också bra med Klipper.

## Klipper gcode_macro

Skivningsprogram låter ofta användaren ställa in sekvenserna Start G-Code och End G-Code. Det är ofta praktiskt att i stället definiera egna makron i Klippers konfigurationsfil, till exempel `[gcode_macro START_PRINT]` och `[gcode_macro END_PRINT]`. Då kan START_PRINT och END_PRINT köras i skivningsprogrammets konfiguration. När åtgärderna definieras i Klippers konfiguration blir det enklare att justera skrivarens start- och slutsteg eftersom ändringar inte kräver ny skivning.

Se [sample-macros.cfg](../config/sample-macros.cfg) för exempel på makron för START_PRINT och END_PRINT.

Se [konfigurationsreferensen](Config_Reference.md#gcode_macro) för information om hur en gcode_macro definieras.

## Stora inställningar för indragning kan kräva justering av Klipper

Maxhastighet och maxacceleration för indragningsrörelser styrs i Klipper av konfigurationsinställningarna `max_extrude_only_velocity` och `max_extrude_only_accel`. Inställningarna har standardvärden som bör fungera bra på många skrivare. Om en stor indragning har ställts in i skivningsprogrammet, till exempel 5 mm eller mer, kan de dock begränsa önskad indragningshastighet.

Om en stor indragning används bör Klippers [tryckutjämning](Pressure_Advance.md) justeras i stället. Om skrivhuvudet verkar pausa under indragning och återmatning kan `max_extrude_only_velocity` och `max_extrude_only_accel` också uttryckligen definieras i Klippers konfigurationsfil.

## Aktivera inte coasting

Funktionen coasting ger sannolikt utskrifter av dålig kvalitet med Klipper. Överväg att använda Klippers [tryckutjämning](Pressure_Advance.md) i stället.

Om skivningsprogrammet ändrar extruderingshastigheten drastiskt mellan rörelser bromsar och accelererar Klipper mellan rörelserna. Detta gör sannolikt klumpbildning värre, inte bättre.

Däremot går det bra, och är ofta hjälpsamt, att använda skivningsprogrammets inställning retract, wipe och/eller wipe on retract.

## Använd inte extra restart distance i Simplify3D

Inställningen kan orsaka kraftiga ändringar av extruderingshastigheten, vilket kan utlösa Klippers kontroll av maximal extruderingstvärsnittsyta. Överväg att använda Klippers [tryckutjämning](Pressure_Advance.md) eller Simplify3D:s vanliga inställning för indragning i stället.

## Inaktivera PreloadVE i KISSlicer

Om skivningsprogrammet KISSlicer används ska PreloadVE ställas in på noll. Överväg att använda Klippers [tryckutjämning](Pressure_Advance.md) i stället.

## Inaktivera alla inställningar för avancerat extrudertryck

Vissa skivningsprogram erbjuder en funktion för avancerat extrudertryck. Dessa alternativ bör hållas inaktiverade med Klipper eftersom de sannolikt ger utskrifter av dålig kvalitet. Överväg att använda Klippers [tryckutjämning](Pressure_Advance.md) i stället.

Dessa inställningar i skivningsprogrammet kan särskilt instruera den fasta programvaran att göra kraftiga ändringar av extruderingshastigheten i hopp om att den ska approximera begäran och skrivaren ungefär ska få önskat extrudertryck. Klipper använder däremot exakta kinematiska beräkningar och tidssättning. När Klipper får ett kommando om betydande ändringar av extruderingshastigheten planerar det motsvarande ändringar av hastighet, acceleration och extruderrörelse, vilket inte är skivningsprogrammets avsikt. Skivningsprogrammet kan till och med beordra så höga extruderingshastigheter att Klippers kontroll av maximal extruderingstvärsnittsyta utlöses.

Däremot går det bra, och är ofta hjälpsamt, att använda skivningsprogrammets inställning retract, wipe och/eller wipe on retract.

## Makron för START_PRINT

Vid användning av ett START_PRINT-makro eller liknande är det ibland praktiskt att föra vidare parametrar från skivningsprogrammets variabler till makrot.

I Cura används följande start-gcode för att föra vidare temperaturer:

```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

I Slic3r-derivat som PrusaSlicer och SuperSlicer används följande:

```
START_PRINT EXTRUDER_TEMP=[first_layer_temperature] BED_TEMP=[first_layer_bed_temperature]
```

Observera även att dessa skivningsprogram lägger in egna värmekoder när vissa villkor inte är uppfyllda. I Cura räcker förekomsten av variablerna `{material_bed_temperature_layer_0}` och `{material_print_temperature_layer_0}` för att motverka detta. I Slic3r-derivat används följande:

```
M140 S0
M104 S0
```

före makroanropet. Observera även att SuperSlicer har ett knappläge för custom gcode only, vilket ger samma resultat.

Ett exempel på ett START_PRINT-makro som använder parametrarna finns i config/sample-macros.cfg
