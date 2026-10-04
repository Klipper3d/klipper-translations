# Rotationsavstånd

Stegmotordrivare i Klipper kräver parametern `rotation_distance` i varje [konfigurationssektion för stegmotorer](Config_Reference.md#stepper). `rotation_distance` är den sträcka som axeln förflyttas vid ett helt varv av stegmotorn. Det här dokumentet beskriver hur värdet konfigureras.

## Ta fram rotation_distance från steps_per_mm (eller step_distance)

Konstruktörerna av din 3D-skrivare beräknade ursprungligen `steps_per_mm` utifrån ett rotationsavstånd. Om du känner till steps_per_mm kan du använda denna allmänna formel för att ta fram det ursprungliga rotationsavståndet:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> / <steps_per_mm>
```

Eller, om du har en äldre Klipper-konfiguration och känner till parametern `step_distance`, kan du använda denna formel:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> * <step_distance>
```

Inställningen `<full_steps_per_rotation>` bestäms av stegmotortypen. De flesta stegmotorer är "1,8-gradersstegmotorer" och har därför 200 hela steg per varv (360 delat med 1,8 är 200). Vissa stegmotorer är "0,9-gradersstegmotorer" och har därmed 400 hela steg per varv. Andra stegmotorer är ovanliga. Om du är osäker ska du inte ange full_steps_per_rotation i konfigurationsfilen utan använda 200 i formeln ovan.

Inställningen `<microsteps>` bestäms av stegmotordrivaren. De flesta drivrutiner använder 16 mikrosteg. Om du är osäker anger du `microsteps: 16` i konfigurationen och använder 16 i formeln ovan.

Nästan alla skrivare bör ha ett heltalsvärde för `rotation_distance` på axlar av typen X, Y och Z. Om formeln ovan ger ett rotation_distance som ligger inom 0,01 från ett heltal avrundar du slutvärdet till det heltalet.

## Kalibrera rotation_distance för extrudrar

För en extruder är `rotation_distance` den sträcka som filamentet rör sig vid ett helt varv av stegmotorn. Det bästa sättet att få ett exakt värde är att använda metoden "mät och trimma".

Börja med en första uppskattning av rotationsavståndet. Den kan tas fram från [steps_per_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance) eller genom att [inspektera maskinvaran](#extruder).

Använd sedan följande metod för att "mäta och trimma":

1. Kontrollera att extrudern har filament, att hotend-enheten är uppvärmd till en lämplig temperatur och att skrivaren är redo att extrudera.
1. Markera filamentet med en penna ungefär 70 mm från extruderkroppens inmatning. Mät sedan det faktiska avståndet till markeringen så noggrant som möjligt med ett digitalt skjutmått. Anteckna det som `<initial_mark_distance>`.
1. Extrudera 50 mm filament med följande kommandosekvens: `G91` följt av `G1 E50 F60`. Anteckna 50 mm som `<requested_extrude_distance>`. Vänta tills extrudern har avslutat rörelsen (det tar ungefär 50 sekunder). Det är viktigt att använda den långsamma extruderingshastigheten i testet, eftersom en snabbare hastighet kan orsaka högt tryck i extrudern och snedvrida resultatet. (Använd inte "extruderingsknappen" i grafiska gränssnitt för testet eftersom de extruderar snabbt.)
1. Mät med det digitala skjutmåttet det nya avståndet mellan extruderkroppen och markeringen på filamentet. Anteckna det som `<subsequent_mark_distance>`. Beräkna sedan: `actual_extrude_distance = <initial_mark_distance> - <subsequent_mark_distance>`
1. Beräkna rotation_distance så här: `rotation_distance = <previous_rotation_distance> * <actual_extrude_distance> / <requested_extrude_distance>`. Avrunda det nya rotation_distance till tre decimaler.

Om actual_extrude_distance skiljer sig från requested_extrude_distance med mer än ungefär 2 mm är det lämpligt att utföra stegen ovan en andra gång.

Obs! Använd *inte* en metod av typen "mät och trimma" för att kalibrera axlar av typen X, Y eller Z. Metoden är inte tillräckligt exakt för dessa axlar och leder sannolikt till en sämre konfiguration. Vid behov kan dessa axlar i stället bestämmas genom att [mäta remmar, remskivor och gängstångsmaskinvara](#obtaining-rotation_distance-by-inspecting-the-hardware).

## Ta fram rotation_distance genom att inspektera maskinvaran

Det går att beräkna rotation_distance om du känner till stegmotorerna och skrivarens kinematik. Det kan vara användbart om steps_per_mm är okänt eller när du konstruerar en ny skrivare.

### Remdrivna axlar

Det är enkelt att beräkna rotation_distance för en linjär axel som använder rem och remskiva.

Fastställ först remtypen. De flesta skrivare använder en remdelning på 2 mm (det vill säga att varje tand på remmen ligger 2 mm från nästa). Räkna sedan antalet tänder på stegmotorns remskiva. rotation_distance beräknas därefter så här:

```
rotation_distance = <belt_pitch> * <number_of_teeth_on_pulley>
```

Om en skrivare till exempel har en 2 mm-rem och använder en remskiva med 20 tänder är rotationsavståndet 40.

### Axlar med gängstång

Det är enkelt att beräkna rotation_distance för vanliga gängstänger med följande formel:

```
rotation_distance = <screw_pitch> * <number_of_separate_threads>
```

Den vanliga "T8-gängstången" har till exempel ett rotationsavstånd på 8 (den har en stigning på 2 mm och 4 separata gängor).

Äldre skrivare med "gängade stänger" har bara en "gänga" på gängstången och därmed är rotationsavståndet skruvens stigning. (Skruvens stigning är avståndet mellan varje spår på skruven.) En metrisk M6-stång har till exempel rotationsavståndet 1 och en M8-stång rotationsavståndet 1,25.

### Extruder

Ett första rotationsavstånd för extrudrar kan tas fram genom att mäta diametern på den räfflade drivbulten som matar filamentet och använda följande formel: `rotation_distance = <diameter> * 3.14`

Om extrudern använder kugghjul behöver du också [fastställa och ange gear_ratio](#using-a-gear_ratio) för extrudern.

Det faktiska rotationsavståndet hos en extruder varierar mellan skrivare eftersom greppet från den räfflade drivbulten som greppar filamentet kan variera. Det kan till och med variera mellan filamentrullar. När ett första rotation_distance har tagits fram använder du [metoden mät och trimma](#calibrating-rotation_distance-on-extruders) för att få en mer exakt inställning.

## Använda gear_ratio

Att ange `gear_ratio` kan göra det enklare att konfigurera `rotation_distance` för stegmotorer med en växellåda (eller liknande) ansluten. De flesta stegmotorer har ingen växellåda – om du är osäker ska du inte ange `gear_ratio` i konfigurationen.

När `gear_ratio` anges motsvarar `rotation_distance` den sträcka som axeln förflyttas vid ett helt varv av växellådans sista kugghjul. Om du exempelvis använder en växellåda med utväxlingen "5:1" kan du beräkna rotation_distance med [kunskap om maskinvaran](#obtaining-rotation_distance-by-inspecting-the-hardware) och sedan lägga till `gear_ratio: 5:1` i konfigurationen.

För utväxling som genomförs med remmar och remskivor kan gear_ratio fastställas genom att räkna tänderna på remskivorna. Om en stegmotor med en 16-tandad remskiva driver nästa remskiva med 80 tänder använder du till exempel `gear_ratio: 80:16`. Du kan även öppna en vanlig växellåda från hyllan och räkna kugghjulen i den för att bekräfta utväxlingen.

Observera att en växellåda ibland kan ha en något annorlunda utväxling än den som anges i reklamen. De vanliga BMG-kugghjulen för extrudermotorer är ett exempel: de marknadsförs som "3:1" men använder i själva verket utväxlingen "50:17". (Att använda tandtal utan gemensam nämnare kan förbättra kugghjulens totala slitage eftersom tänderna inte alltid griper in på samma sätt vid varje varv.) Den vanliga "planetväxellådan 5,18:1" konfigureras mer exakt med `gear_ratio: 57:11`.

Om flera kugghjul används på en axel kan en kommaseparerad lista anges för gear_ratio. En växellåda med "5:1" som driver en 16-tandad till en 80-tandad remskiva kan till exempel använda `gear_ratio: 5:1, 80:16`.

I de flesta fall bör gear_ratio anges med heltal eftersom vanliga kugghjul och remskivor har ett helt antal tänder. När en rem driver en remskiva med friktion i stället för tänder kan det dock vara rimligt att använda ett flyttal i utväxlingen (t.ex. `gear_ratio: 107.237:16`).
