# Bäddnivellering

Bäddnivellering (kallas ibland även "bäddtramming") är avgörande för utskrifter av hög kvalitet. Om bädden inte är korrekt nivellerad kan det leda till dålig vidhäftning mot bädden, "skevning" och svårupptäckta problem genom hela utskriften. Det här dokumentet är en vägledning till bäddnivellering i Klipper.

Det är viktigt att förstå målet med bäddnivellering. Om skrivaren under en utskrift beordras till positionen `X0 Y0 Z10` är målet att skrivarens munstycke ska befinna sig exakt 10 mm från bädden. Om skrivaren sedan beordras till positionen `X50 Z10` är målet dessutom att munstycket behåller exakt 10 mm avstånd från bädden under hela den horisontella rörelsen.

För utskrifter av god kvalitet ska skrivaren kalibreras så att Z-avstånd är exakta inom ungefär 25 mikrometer (0,025 mm). Det är ett litet avstånd – avsevärt mindre än bredden på ett vanligt människohår. Den här skalan kan inte mätas "med ögat". Små effekter, såsom värmeutvidgning, påverkar mätningar i den här skalan. Hemligheten bakom hög precision är att använda en repeterbar process och en nivelleringsmetod som utnyttjar skrivarens eget rörelsesystems höga precision.

## Välj lämplig kalibreringsmetod

Olika skrivartyper använder olika metoder för bäddnivellering. Alla bygger i slutänden på "papperstestet" (som beskrivs nedan). Den faktiska processen för en viss skrivartyp beskrivs dock i andra dokument.

Innan något av dessa kalibreringsverktyg körs ska du utföra kontrollerna i dokumentet om [konfigurationskontroller](Config_checks.md). Skrivarens grundläggande rörelser måste verifieras före bäddnivellering.

För skrivare med en "automatisk Z-sond" ska sonden kalibreras enligt anvisningarna i dokumentet [Sondkalibrering](Probe_Calibrate.md). För deltaskrivare, se dokumentet [Deltakalibrering](Delta_Calibrate.md). För skrivare med bäddskruvar och traditionella Z-ändstopp, se dokumentet [Manuell nivellering](Manual_Level.md).

Under kalibreringen kan skrivarens Z `position_min` behöva anges till ett negativt tal (t.ex. `position_min = -2`). Skrivaren tillämpar gränskontroller även under kalibreringsrutiner. Ett negativt tal gör att skrivaren kan flytta sig under bäddens nominella position, vilket kan hjälpa när den faktiska bäddpositionen ska fastställas.

## Papperstestet

Den främsta metoden för bäddkalibrering är "papperstestet". Det innebär att ett vanligt kopieringspapper placeras mellan skrivarens bädd och munstycke och att munstycket sedan flyttas till olika Z-höjder tills du känner ett litet motstånd när papperet förs fram och tillbaka.

Det är viktigt att förstå "papperstestet" även om du har en "automatisk Z-sond". Sonden behöver ofta kalibreras för att ge bra resultat. Den kalibreringen görs med detta "papperstest".

Klipp till en liten rektangulär pappersbit med en sax (t.ex. 5 × 3 cm) för att utföra papperstestet. Papperet har normalt en tjocklek på omkring 100 mikrometer (0,100 mm). (Papperets exakta tjocklek är inte avgörande.)

Det första steget i papperstestet är att kontrollera skrivarens munstycke och bädd. Kontrollera att det inte finns plast eller annat skräp på munstycket eller bädden.

**Kontrollera munstycket och bädden så att ingen plast finns kvar!**

Om du alltid skriver ut på en viss tejp eller utskriftsyta kan papperstestet utföras med tejpen eller ytan på plats. Observera dock att tejpen har en egen tjocklek och att olika tejper (eller andra utskriftsytor) påverkar Z-mätningarna. Kör papperstestet på nytt för att mäta varje yttyp som används.

Om det finns plast på munstycket värmer du extrudern och använder en metallpincett för att ta bort plasten. Vänta tills extrudern har svalnat helt till rumstemperatur innan du fortsätter med papperstestet. Medan munstycket svalnar använder du metallpincetten för att ta bort eventuell plast som sipprar ut.

**Utför alltid papperstestet när både munstycke och bädd har rumstemperatur!**

När munstycket värms upp ändras dess position i förhållande till bädden på grund av värmeutvidgning. Denna värmeutvidgning är vanligen omkring 100 mikrometer, ungefär samma tjocklek som ett vanligt skrivarpapper. Den exakta värmeutvidgningen är inte avgörande, precis som papperets exakta tjocklek inte är avgörande. Utgå från att de två är lika stora (se nedan en metod för att fastställa skillnaden mellan avstånden).

Det kan verka märkligt att kalibrera avståndet vid rumstemperatur när målet är ett jämnt avstånd vid uppvärmning. Men om du kalibrerar med upphettat munstycke fastnar ofta små mängder smält plast på papperet, vilket ändrar det upplevda motståndet. Det gör det svårare att få en bra kalibrering. Kalibrering när bädden eller munstycket är varmt ökar också risken för brännskador betydligt. Värmeutvidgningen är stabil och kan därför enkelt tas med senare i kalibreringsprocessen.

**Använd ett automatiserat verktyg för att fastställa exakta Z-höjder!**

Klipper har flera hjälpskript (t.ex. MANUAL_PROBE, Z_ENDSTOP_CALIBRATE, PROBE_CALIBRATE och DELTA_CALIBRATE). Se [dokumenten ovan](#choose-the-appropriate-calibration-mechanism) för att välja ett av dem.

Kör lämpligt kommando i OctoPrints terminalfönster. Skriptet uppmanar dig till åtgärder i terminalutmatningen från OctoPrint. Det ser ungefär ut så här:

```
Recv: // Starting manual Z probe. Use TESTZ to adjust position.
Recv: // Finish with ACCEPT or ABORT command.
Recv: // Z position: ?????? --> 5.000 <-- ??????
```

Munstyckets aktuella höjd (så som skrivaren för närvarande uppfattar den) visas mellan "--> <--". Siffran till höger är höjden från det senaste sondförsöket som var större än den aktuella höjden, och siffran till vänster är det senaste sondförsöket som var mindre än den aktuella höjden (eller ?????? om inget försök har gjorts).

Placera papperet mellan munstycket och bädden. Det kan vara praktiskt att vika ett hörn av papperet så att det blir lättare att hålla i. (Försök att inte trycka ned bädden när papperet förs fram och tillbaka.)

![paper-test](img/paper-test.jpg)

Använd kommandot TESTZ för att be munstycket flytta närmare papperet. Till exempel:

```
TESTZ Z=-.1
```

Kommandot TESTZ flyttar munstycket ett relativt avstånd från dess aktuella position. (`Z=-.1` ber alltså munstycket flytta 0,1 mm närmare bädden.) När munstycket har stannat för du papperet fram och tillbaka för att kontrollera om munstycket har kontakt med papperet och känna motståndet. Fortsätt att utfärda TESTZ-kommandon tills du känner ett litet motstånd med papperet.

Om motståndet är för stort kan du använda ett positivt Z-värde för att flytta upp munstycket. Du kan även använda `TESTZ Z=+` eller `TESTZ Z=-` för att "halvera" den senaste positionen, det vill säga flytta till en position mitt emellan två positioner. Om du till exempel fick följande uppmaning från ett TESTZ-kommando:

```
Recv: // Z position: 0.130 --> 0.230 <-- 0.280
```

Då flyttar `TESTZ Z=-` munstycket till Z-positionen 0.180 (mitt emellan 0.130 och 0.230). Funktionen kan användas för att snabbt begränsa sökningen till ett konsekvent motstånd. Du kan även använda `Z=++` och `Z=--` för att gå direkt tillbaka till en tidigare mätning – efter uppmaningen ovan flyttar till exempel `TESTZ Z=--` munstycket till Z-positionen 0.130.

När du har hittat ett litet motstånd kör du kommandot ACCEPT:

```
ACCEPT
```

Det godkänner den angivna Z-höjden och fortsätter med det aktuella kalibreringsverktyget.

Den exakta mängden motstånd är inte avgörande, precis som varken värmeutvidgningen eller papperets exakta tjocklek är avgörande. Försök bara att få samma mängd motstånd varje gång testet körs.

Om något går fel under testet kan du använda kommandot `ABORT` för att avsluta kalibreringsverktyget.

## Fastställa värmeutvidgning

När bäddnivelleringen har utförts kan du beräkna ett mer exakt värde för den samlade effekten av "värmeutvidgning", "papperets tjocklek" och "motståndet som känns under papperstestet".

Den här beräkningen behövs normalt inte eftersom de flesta användare får bra resultat med det enkla "papperstestet".

Det enklaste sättet att göra beräkningen är att skriva ut ett testobjekt med raka väggar på alla sidor. Den stora ihåliga kvadraten i [docs/prints/square.stl](prints/square.stl) kan användas för detta. När objektet skivas ska skivningsprogrammet använda samma lagerhöjd och extruderingsbredder för första lagret som för alla efterföljande lager. Använd en grov lagerhöjd (lagerhöjden bör vara omkring 75 % av munstyckets diameter) och använd inte brim eller raft.

Skriv ut testobjektet, vänta tills det har svalnat och ta bort det från bädden. Granska objektets nedersta lager. (Det kan också vara användbart att dra ett finger eller en nagel längs underkanten.) Om det nedersta lagret buktar ut något längs alla objektets sidor tyder det på att munstycket var något närmare bädden än det borde ha varit. Du kan då använda `SET_GCODE_OFFSET Z=+.010` för att öka höjden. Vid efterföljande utskrifter kan du kontrollera detta beteende och justera ytterligare vid behov. Justeringar av denna typ ligger vanligen på tiotals mikrometer (0,010 mm).

Om det nedersta lagret konsekvent ser smalare ut än efterföljande lager kan du använda kommandot SET_GCODE_OFFSET för att göra en negativ Z-justering. Om du är osäker kan du minska Z-justeringen tills utskrifternas nedersta lager får en liten utbuktning och sedan backa tills den försvinner.

Det enklaste sättet att tillämpa önskad Z-justering är att skapa ett START_PRINT-G-code-makro, låta skivningsprogrammet anropa makrot vid starten av varje utskrift och lägga till ett SET_GCODE_OFFSET-kommando i makrot. Mer information finns i dokumentet [skivningsprogram](Slicers.md).
