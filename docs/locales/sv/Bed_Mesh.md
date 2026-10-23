# Bäddnät

Modulen Bed Mesh kan användas för att kompensera för ojämnheter i bäddens yta och ge ett bättre första lager över hela bädden. Programvarubaserad korrigering ger inte perfekta resultat, utan kan bara approximera bäddens form. Bed Mesh kan inte heller kompensera för mekaniska eller elektriska fel. Om en axel är sned eller sonden är inexakt får modulen bed_mesh inte korrekta resultat från sonderingen.

Innan nätkalibrering måste sondens Z-förskjutning vara kalibrerad. Om ett ändläge används för Z-homing måste även det kalibreras. Mer information finns i [Sondkalibrering](Probe_Calibrate.md) och Z_ENDSTOP_CALIBRATE i [Manuell nivåjustering](Manual_Level.md).

## Grundläggande konfiguration

### Rektangulära bäddar

Det här exemplet förutsätter en skrivare med en rektangulär bädd på 250 mm × 220 mm och en sond med X-förskjutningen 24 mm och Y-förskjutningen 5 mm.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `speed: 120` *Standardvärde: 50* Hastigheten som verktyget rör sig med mellan punkterna.
- `horizontal_move_z: 5` *Standardvärde: 5* Z-koordinaten som sonden höjs till innan den förflyttas mellan punkter.
- `mesh_min: 35, 6` *Krävs* Den första sonderade koordinaten, närmast origo. Koordinaten är relativ till sondens placering.
- `mesh_max: 240, 198` *Krävs* Den sonderade koordinat som ligger längst från origo. Det behöver inte vara den sista punkt som sonderas, eftersom sonderingen sker sicksackvis. Precis som `mesh_min` är koordinaten relativ till sondens placering.
- `probe_count: 5, 3` *Standardvärde: 3, 3* Antalet punkter som ska sonderas på varje axel, angivet som heltalsvärdena X, Y. I detta exempel sonderas 5 punkter längs X-axeln och 3 längs Y-axeln, totalt 15 punkter. Om ett kvadratiskt rutnät önskas, exempelvis 3x3, kan ett enda heltalsvärde som används för båda axlarna anges: `probe_count: 3`. Ett nät kräver minst probe_count 3 längs varje axel.

Illustrationen nedan visar hur alternativen `mesh_min`, `mesh_max` och `probe_count` används för att skapa sondpunkter. Pilarna visar sonderingens riktning, med början vid `mesh_min`. När sonden är vid `mesh_min` är munstycket vid (11, 1), och när sonden är vid `mesh_max` är munstycket vid (206, 193).

![bedmesh_rect_basic](img/bedmesh_rect_basic.svg)

### Runda bäddar

Det här exemplet förutsätter en skrivare med en rund bäddradie på 100 mm. Vi använder samma sondförskjutningar som i det rektangulära exemplet, 24 mm i X och 5 mm i Y.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius: 75` *Krävs* Radien i mm för det sonderade nätet, relativt `mesh_origin`. Observera att sondens förskjutningar begränsar nätets radie. I det här exemplet skulle en radie över 76 föra verktyget utanför skrivarens rörelseområde.
- `mesh_origin: 0, 0` *Standardvärde: 0, 0* Nätets mittpunkt. Koordinaten är relativ till sondens placering. Även om standardvärdet är 0, 0 kan det vara användbart att justera origo för att sondera en större del av bädden. Se illustrationen nedan.
- `round_probe_count: 5` *Standardvärde: 5* Ett heltalsvärde som anger högsta antalet sonderade punkter längs X- och Y-axlarna. Med "högsta" avses antalet punkter som sonderas längs nätets origo. Värdet måste vara udda eftersom nätets mittpunkt måste sonderas.

Illustrationen nedan visar hur de sonderade punkterna genereras. Som synes kan vi med `mesh_origin` satt till (-10, 0) ange en större nätradie på 85.

![bedmesh_round_basic](img/bedmesh_round_basic.svg)

## Avancerad konfiguration

Nedan förklaras de mer avancerade konfigurationsalternativen i detalj. Varje exempel bygger på den grundläggande konfigurationen för rektangulär bädd ovan. De avancerade alternativen fungerar på samma sätt för runda bäddar.

### Nätinterpolering

Det går att sampla den sonderade matrisen direkt med enkel bilinjär interpolation för att fastställa Z-värdena mellan de sonderade punkterna. Ofta är det dock användbart att interpolera ytterligare punkter med mer avancerade interpoleringsalgoritmer för att öka nätets täthet. Dessa algoritmer ger nätet krökning i ett försök att simulera bäddens materialegenskaper. Bed Mesh erbjuder Lagrange- och bikubisk interpolation.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
mesh_pps: 2, 3
algorithm: bicubic
bicubic_tension: 0.2
```

- `mesh_pps: 2, 3` *Standardvärde: 2, 2* Alternativet `mesh_pps` är en förkortning för Mesh Points Per Segment. Alternativet anger hur många punkter som ska interpoleras för varje segment längs X- och Y-axeln. Ett "segment" är avståndet mellan varje sonderad punkt. Precis som `probe_count` anges `mesh_pps` som ett heltalspar X, Y, men kan också anges som ett enda heltal som tillämpas på båda axlarna. I detta exempel finns 4 segment längs X-axeln och 2 längs Y-axeln. Det ger 8 interpolerade punkter längs X och 6 längs Y, vilket resulterar i ett nät på 13x9. Om mesh_pps sätts till 0 inaktiveras nätinterpolering och den sonderade matrisen samplas direkt.
- `algorithm: lagrange` *Standardvärde: lagrange* Algoritmen som används för att interpolera nätet. Kan vara `lagrange` eller `bicubic`. Lagrangeinterpolering begränsas till 6 sonderade punkter eftersom fler provpunkter tenderar att ge svängningar. Bikubisk interpolering kräver minst 4 sonderade punkter längs varje axel. Om färre än 4 punkter anges tvingas lagrange-provtagning. Om `mesh_pps` sätts till 0 ignoreras värdet eftersom ingen nätinterpolering görs.
- `bicubic_tension: 0.2` *Standardvärde: 0.2* Om alternativet `algorithm` är inställt på bicubic kan spänningsvärdet anges. Ju högre spänning, desto mer lutning interpoleras. Var försiktig vid justering eftersom högre värden också ger större översvängning, vilket kan ge interpolerade värden över eller under dina sonderade punkter.

Illustrationen nedan visar hur alternativen ovan används för att skapa ett interpolerat nät.

![bedmesh_interpolated](img/bedmesh_interpolated.svg)

### Uppdelning av rörelser

Bed Mesh fungerar genom att fånga upp G-kodens rörelsekommandon och tillämpa en transformering på deras Z-koordinat. Långa rörelser måste delas upp i mindre rörelser för att korrekt följa bäddens form. Alternativen nedan styr hur uppdelningen fungerar.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
move_check_distance: 5
split_delta_z: .025
```

- `move_check_distance: 5` *Standardvärde: 5* Minsta avstånd som kontrolleras för önskad förändring i Z innan en rörelse delas upp. I det här exemplet behandlas rörelser längre än 5 mm av algoritmen. Var femte mm görs en uppslagning av nätets Z-värde och jämförs med Z-värdet för föregående rörelse. Om skillnaden når tröskeln som anges av `split_delta_z` delas rörelsen upp och behandlingen fortsätter. Processen upprepas till rörelsens slut, där en slutlig justering tillämpas. För rörelser kortare än `move_check_distance` tillämpas korrekt Z-justering direkt utan behandling eller uppdelning.
- `split_delta_z: .025` *Standardvärde: .025* Som nämnts ovan är detta den minsta avvikelse som krävs för att dela upp en rörelse. I det här exemplet utlöser varje Z-värde med avvikelsen +/- .025 mm en uppdelning.

I allmänhet räcker standardvärdena för dessa alternativ; standardvärdet 5 mm för `move_check_distance` kan till och med vara mer än nödvändigt. En avancerad användare kan dock vilja experimentera med alternativen för att uppnå ett optimalt första lager.

### Utfasning av nät

När "fade" är aktiverat fasas Z-justeringen ut över ett avstånd som anges i konfigurationen. Det görs genom små ändringar av lagerhöjden, som ökas eller minskas beroende på bäddens form. När utfasningen är klar tillämpas inte längre Z-justering, så att utskriftens ovansida blir plan i stället för att följa bäddens form. Utfasning kan också ha oönskade effekter: om den sker för snabbt kan synliga artefakter uppstå på utskriften. Om bädden är kraftigt skev kan utfasningen dessutom krympa eller sträcka utskriftens Z-höjd. Den är därför avstängd som standard.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
fade_start: 1
fade_end: 10
fade_target: 0
```

- `fade_start: 1` *Standardvärde: 1* Z-höjden där utfasning av justeringen ska börja. Det är klokt att skriva ut några lager innan utfasningen startar.
- `fade_end: 10` *Standardvärde: 0* Z-höjden där utfasningen ska vara klar. Om värdet är lägre än `fade_start` inaktiveras utfasningen. Värdet kan justeras beroende på hur skev utskriftsytan är. En kraftigt skev yta bör fasas ut över en längre sträcka, medan en nästan plan yta kan använda ett lägre värde för snabbare utfasning. 10 mm är ett rimligt startvärde när standardvärdet 1 används för `fade_start`.
- `fade_target: 0` *Standardvärde: nätets genomsnittliga Z-värde* `fade_target` kan ses som en ytterligare Z-förskjutning som tillämpas på hela bädden när utfasningen är klar. Vanligtvis bör värdet vara 0, men ibland bör det inte vara det. Anta till exempel att homing-positionen på bädden avviker och ligger 0,2 mm lägre än bäddens genomsnittligt sonderade höjd. Om `fade_target` är 0 krymper utfasningen utskriften med i genomsnitt 0,2 mm över bädden. Om `fade_target` sätts till 0,2 expanderar det hemkörda området med 0,2 mm, medan resten av bädden får rätt mått. Det är vanligen bäst att utelämna `fade_target` ur konfigurationen så att nätets genomsnittliga höjd används, men utfasningsmålet kan justeras manuellt om utskrift ska ske på en viss del av bädden.

### Konfigurera nollreferenspositionen

Många sonder är känsliga för "drift", det vill säga felaktigheter vid sondering som orsakas av värme eller störningar. Det kan göra det svårt att beräkna sondens Z-förskjutning, särskilt vid olika bäddtemperaturer. Därför använder vissa skrivare ett ändläge för homing av Z-axeln och en sond för att kalibrera nätet. I denna konfiguration kan nätet förskjutas så att `referenspositionen` (X, Y) inte justeras. `Referenspositionen` ska vara den plats på bädden där ett papperstest med [Z_ENDSTOP_CALIBRATE](./Manual_Level.md#calibrating-a-z-endstop) utförs. Modulen bed_mesh tillhandahåller alternativet `zero_reference_position` för att ange denna koordinat:

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
zero_reference_position: 125, 110
probe_count: 5, 3
```

- `zero_reference_position: ` *Standardvärde: None (inaktiverad)* `zero_reference_position` förväntar sig en koordinat (X, Y) som motsvarar den `referensposition` som beskrivs ovan. Om koordinaten ligger inom nätet förskjuts nätet så att referenspositionen inte justeras. Om koordinaten ligger utanför nätet sonderas den efter kalibreringen och det resulterande Z-värdet används som Z-förskjutning. Koordinaten får inte ligga på en plats som angetts som `faulty_region` om en sond behövs.

### Felaktiga områden

Vissa områden på en bädd kan ge felaktiga resultat vid sondering på grund av ett "fel" på specifika platser. Ett vanligt exempel är bäddar med serier av inbyggda magneter som håller löstagbara stålplåtar på plats. Magnetfältet vid och omkring magneterna kan göra att en induktiv sond löser ut på ett högre eller lägre avstånd än annars, vilket ger ett nät som inte korrekt återger ytan på dessa platser. **Observera: detta får inte förväxlas med positionsbias för sonden, som ger felaktiga resultat över hela bädden.**

Alternativen `faulty_region` kan konfigureras för att kompensera för denna effekt. Om en skapad punkt ligger i ett felaktigt område försöker Bed Mesh sondera upp till fyra punkter vid områdets gränser. De sonderade värdena beräknas som medelvärde och läggs in i nätet som Z-värde vid den skapade (X, Y)-koordinaten.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
faulty_region_1_min: 130.0, 0.0
faulty_region_1_max: 145.0, 40.0
faulty_region_2_min: 225.0, 0.0
faulty_region_2_max: 250.0, 25.0
faulty_region_3_min: 165.0, 95.0
faulty_region_3_max: 205.0, 110.0
faulty_region_4_min: 30.0, 170.0
faulty_region_4_max: 45.0, 210.0
```

- `faulty_region_{1...99}_min` `faulty_region_{1..99}_max` *Standardvärde: None (inaktiverat)* Felaktiga områden definieras på samma sätt som nätet: minsta och största (X, Y)-koordinat ska anges för varje område. Ett felaktigt område kan sträcka sig utanför ett nät, men de alternativa punkter som skapas ligger alltid inom nätets gräns. Två områden får inte överlappa varandra.

Bilden nedan visar hur ersättningspunkter skapas när en skapad punkt ligger inom ett felaktigt område. De visade områdena motsvarar dem i exempelkonfigurationen ovan. Ersättningspunkterna och deras koordinater är markerade med grönt.

![bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

### Adaptiva nät

Adaptiv bäddnätsmätning snabbar upp skapandet av bäddnät genom att endast sondera det bäddområde som används av de objekt som skrivs ut. Metoden justerar automatiskt nätparametrarna utifrån det område som de definierade utskriftsobjekten upptar.

Det anpassade nätområdet beräknas utifrån området som avgränsas av alla definierade utskriftsobjekt, så att det täcker varje objekt och eventuella marginaler i konfigurationen. När området beräknats skalas antalet sondpunkter ned enligt förhållandet mellan standardnätets område och det anpassade nätområdet. Följande exempel illustrerar detta:

För en bädd på 150 mm × 150 mm med `mesh_min` satt till `25,25` och `mesh_max` satt till `125,125` är standardnätets område en kvadrat på 100 mm × 100 mm. Ett anpassat nätområde på `50,50` innebär förhållandet `0,5 × 0,5` mellan det anpassade området och standardnätets område.

Om konfigurationen `bed_mesh` anger `probe_count` som `7x7`, använder det anpassade bäddnätet 4x4 sonderingspunkter (7 × 0,5 avrundat uppåt).

![adaptivt_baddnat](img/adaptive_bed_mesh.svg)

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
adaptive_margin: 5
```

- `adaptive_margin` *Standardvärde: 0* Marginalen (i mm) som läggs till runt det bäddområde som används av de definierade objekten. Diagrammet nedan visar det anpassade bäddnätområdet med `adaptive_margin` på 5 mm. Det anpassade nätområdet (grönt) beräknas som det använda bäddområdet (blått) plus den angivna marginalen.

   ![marginal_for_adaptivt_baddnat](img/adaptive_bed_mesh_margin.svg)

Adaptiva bäddnät använder av naturen objekten som definieras av den G-kodfil som skrivs ut. Därför förväntas varje G-kodfil skapa ett nät som sonderar ett annat område av skrivarbädden. Adaptiva bäddnät bör därför inte återanvändas. Ett nytt nät ska genereras för varje utskrift när adaptiv mätning används.

Det är också viktigt att tänka på att adaptiv bäddnätsmätning fungerar bäst på maskiner som normalt kan sondera hela bädden och uppnå en maximal avvikelse som är högst en lagerhöjd. Maskiner med mekaniska problem som ett helt bäddnät normalt kompenserar för kan ge oönskade resultat när utskriftsrörelser utförs **utanför** det sonderade området. Om ett helt bäddnät har en avvikelse som är större än en lagerhöjd måste adaptiva bäddnät användas försiktigt när utskriften rör sig utanför nätområdet.

## Ytskanningar

Vissa sonder, exempelvis [virvelströmssonden](./Eddy_Probe.md), kan "skanna" bäddens yta. Det vill säga, sonderna kan sampla ett nät utan att verktyget lyfts mellan provtagningarna. För att aktivera skanningsläge ska sondparametern `METHOD=scan` eller `METHOD=rapid_scan` skickas i G-kodkommandot `BED_MESH_CALIBRATE`.

### Skanningshöjd

Skanningshöjden anges med alternativet `horizontal_move_z` i `[bed_mesh]`. Den kan också anges i G-kodkommandot `BED_MESH_CALIBRATE` med parametern `HORIZONTAL_MOVE_Z`.

Skanningshöjden måste vara tillräckligt låg för att undvika skanningsfel. Vanligtvis fungerar en höjd på 2 mm (det vill säga `HORIZONTAL_MOVE_Z=2`) bra, förutsatt att sonden är korrekt monterad.

Observera att resultaten blir ogiltiga om sonden befinner sig mer än 4 mm över ytan. Skanning är alltså inte möjlig på bäddar med stora ytavvikelser eller med extrem lutning som inte har korrigerats.

### Snabb skanning (kontinuerlig)

Vid `rapid_scan` bör man tänka på att resultaten innehåller en viss mängd fel. Felet bör vara tillräckligt litet för att vara användbart på stora utskriftsområden med rimligt tjocka lagerhöjder. Vissa sonder kan vara mer felbenägna än andra.

Snabbläge rekommenderas inte för att skanna ett "tätt" nät. En del av de fel som uppstår vid en snabbsökning kan vara gaussiskt brus från sensorn, och ett tätt nät återger detta brus (det vill säga toppar och dalar).

Bed Mesh försöker optimera förflyttningsvägen för bästa möjliga resultat utifrån konfigurationen. Det omfattar att undvika felaktiga områden vid provtagning och att "köra förbi" nätet vid riktningsändringar. Denna överkörning förbättrar provtagningen vid nätets kanter, men kräver att nätet är konfigurerat så att verktyget kan röra sig utanför nätet.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5
scan_overshoot: 8
```

- `scan_overshoot` *Standardvärde: 0 (inaktiverat)* Den maximala rörelsen (i mm) som är tillgänglig utanför nätet. För rektangulära bäddar gäller detta rörelse längs X-axeln och för runda bäddar gäller det hela radien. Verktyget måste kunna röra sig den angivna sträckan utanför nätet. Värdet används för att optimera förflyttningsvägen vid en "rapid scan". Det minsta tillåtna värdet är 1. Standardvärdet är ingen överkörning.

Om ingen överkörning för skanning har konfigurerats tillämpas inte optimering av förflyttningsvägen vid riktningsändringar.

## Bed Mesh-G-koder

### Kalibrering

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic | scan | rapid_scan] \ [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] \ [ADAPTIVE_MARGIN=<value>]` *Standardprofil: default* *Standardmetod: automatic om en sond upptäcks, annars manual* *Adaptiv standardinställning: 0* *Standardmarginal för adaptiv mätning: 0*

Startar sonderingsproceduren för Bed Mesh-kalibrering.

Nätet är genast klart att använda när kommandot slutförs och sparas i den profil som anges med parametern `PROFILE`, eller i `default` om ingen anges. Parametern `METHOD` kan ha ett av följande värden:

- `METHOD=manual`: aktiverar manuell sondering med munstycket och papperstestet
- `METHOD=automatic`: Automatisk (standard) sondering. Detta är standard.
- `METHOD=scan`: Aktiverar ytskanning. Verktyget pausar över varje position för att samla in ett prov.
- `METHOD=rapid_scan`: Aktiverar kontinuerlig ytskanning.

XY-positioner justeras automatiskt för att inkludera X- och/eller Y-förskjutningarna när en annan sonderingsmetod än `manual` väljs.

Nätparametrar kan anges för att ändra det sonderade området. Följande parametrar är tillgängliga:

- Rektangulära bäddar (kartesiska):
   - `MESH_MIN`
   - `MESH_MAX`
   - `PROBE_COUNT`
- Runda bäddar (delta):
   - `MESH_RADIUS`
   - `MESH_ORIGIN`
   - `ROUND_PROBE_COUNT`
- Alla bäddar:
   - `MESH_PPS`
   - `ALGORITHM`
   - `ADAPTIVE`
   - `ADAPTIVE_MARGIN`

Se konfigurationsdokumentationen ovan för information om hur varje parameter tillämpas på nätet.

### Profiler

`BED_MESH_PROFILE SAVE=<name> LOAD=<name> REMOVE=<name>`

När BED_MESH_CALIBRATE har körts kan nätets aktuella tillstånd sparas i en namngiven profil. Då kan nätet läsas in utan att bädden sonderas igen. Efter att en profil sparats med `BED_MESH_PROFILE SAVE=<name>` kan G-koden `SAVE_CONFIG` köras för att skriva profilen till printer.cfg.

Profiler kan läsas in genom att köra `BED_MESH_PROFILE LOAD=<name>`.

Observera att det aktuella tillståndet automatiskt sparas i profilen *default* varje gång BED_MESH_CALIBRATE körs. Profilen *default* kan tas bort så här:

`BED_MESH_PROFILE REMOVE=default`

Alla andra sparade profiler kan tas bort på samma sätt genom att ersätta *default* med namnet på profilen som ska tas bort.

#### Läser in standardprofilen

Tidigare versioner av `bed_mesh` läste alltid in profilen *default* vid start, om den fanns. Detta beteende har tagits bort så att användaren kan avgöra när en profil läses in. Om profilen `default` ska läsas in, rekommenderas att lägga till `BED_MESH_PROFILE LOAD=default` i antingen makrot `START_PRINT` eller skivningsprogrammets konfiguration för "Start G-Code", beroende på vad som är tillämpligt.

Observera att detta inte krävs om ett nytt nät genereras med `BED_MESH_CALIBRATE` i makrot `START_PRINT` eller skivningsprogrammets "Start G-Code", och det kan ge oväntade resultat, särskilt vid adaptiv nätmätning.

Alternativt kan det gamla beteendet, att läsa in en profil vid start, återställas med en `[delayed_gcode]`:

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### Utdata

`BED_MESH_OUTPUT PGP=[0 | 1]`

Skriver ut nätets aktuella tillstånd i terminalen. Observera att själva nätet skrivs ut

Parametern PGP är en förkortning av "Print Generated Points". Om `PGP=1` anges skrivs de skapade sonderingspunkterna ut i terminalen:

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (11.0, 1.0) | (35.0, 6.0)
// 1 | (62.2, 1.0) | (86.2, 6.0)
// 2 | (113.5, 1.0) | (137.5, 6.0)
// 3 | (164.8, 1.0) | (188.8, 6.0)
// 4 | (216.0, 1.0) | (240.0, 6.0)
// 5 | (216.0, 97.0) | (240.0, 102.0)
// 6 | (164.8, 97.0) | (188.8, 102.0)
// 7 | (113.5, 97.0) | (137.5, 102.0)
// 8 | (62.2, 97.0) | (86.2, 102.0)
// 9 | (11.0, 97.0) | (35.0, 102.0)
// 10 | (11.0, 193.0) | (35.0, 198.0)
// 11 | (62.2, 193.0) | (86.2, 198.0)
// 12 | (113.5, 193.0) | (137.5, 198.0)
// 13 | (164.8, 193.0) | (188.8, 198.0)
// 14 | (216.0, 193.0) | (240.0, 198.0)
```

Punkterna "Tool Adjusted" avser munstyckets position för varje punkt och punkterna "Probe" avser sondens position. Observera att vid manuell sondering avser "Probe" både verktygets och munstyckets position.

### Rensa nätets tillstånd

`BED_MESH_CLEAR`

Den här G-koden kan användas för att rensa nätets interna tillstånd.

### Tillämpa X/Y-förskjutningar

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value>]`

Detta är användbart för skrivare med flera oberoende extrudrar, eftersom en förskjutning behövs för korrekt Z-justering efter ett verktygsbyte. Förskjutningar ska anges i förhållande till den primära extrudern. En positiv X-förskjutning ska alltså anges om den sekundära extrudern är monterad till höger om den primära, en positiv Y-förskjutning om den sekundära extrudern är monterad "bakom" den primära och en positiv ZFADE-förskjutning om den sekundära extruderns munstycke ligger över den primära extruderns.

Observera att en ZFADE-förskjutning *INTE* tillämpar ytterligare justering direkt. Den är avsedd att kompensera för en `gcode offset` när [nätutfasning](#mesh-fade) är aktiverad. Om en sekundär extruder till exempel är högre än den primära och behöver en negativ G-kodförskjutning, exempelvis `SET_GCODE_OFFSET Z=-.2`, kan detta tas med i `bed_mesh` med `BED_MESH_OFFSET ZFADE=.2`.

## Webhook-API:er för Bed Mesh

### Dumpar nätdata

`{"id": 123, "method": "bed_mesh/dump_mesh"}`

Dumpa konfigurationen och tillståndet för den aktuella nätmodellen och alla sparade profiler.

Endpointen `dump_mesh` tar en valfri parameter, `mesh_args`. Parametern måste vara ett objekt vars nycklar och värden är parametrar som är tillgängliga för [BED_MESH_CALIBRATE](#bed_mesh_calibrate). Detta uppdaterar nätmodellens konfiguration och avsökningspunkterna med de angivna parametrarna innan resultatet returneras. Nätmodellens parametrar bör utelämnas om du inte vill visualisera avsökningspunkterna och/eller förflyttningsvägen före `BED_MESH_CALIBRATE`.

## Visualisering och analys

De flesta användare finner sannolikt att visualiseringarna i program som Mainsail, Fluidd och Octoprint räcker för grundläggande analys. Klippers mapp `scripts` innehåller dock skriptet `graph_mesh.py`, som kan användas för ytterligare visualiseringar och mer detaljerad analys. Det är särskilt användbart för felsökning av maskinvara eller resultat från `bed_mesh`:

```
usage: graph_mesh.py [-h] {list,plot,analyze,dump} ...

Graph Bed Mesh Data

positional arguments:
  {list,plot,analyze,dump}
    list                List available plot types
    plot                Plot a specified type
    analyze             Perform analysis on mesh data
    dump                Dump API response to json file

options:
  -h, --help            show this help message and exit
```

### Förutsättningar

Precis som de flesta diagramverktyg som Klipper tillhandahåller kräver `graph_mesh.py` Python-beroendena `matplotlib` och `numpy`. Anslutning till Klipper via Moonrakers WebSocket kräver dessutom Python-beroendet `websockets`. Alla visualiseringar kan skrivas till en `svg`-fil, men de flesta visualiseringar som `graph_mesh.py` erbjuder visas bäst i läget för direkt förhandsvisning på en stationär dator. Exempelvis kan 3D-visualiseringarna roteras och zoomas i förhandsvisningsläget, och vägvisualiseringarna kan valfritt animeras där.

### Ritar nätdata

Verktyget `graph_mesh.py` kan rita flera typer av visualiseringar. Tillgängliga typer visas med `graph_mesh.py list`:

```
graph_mesh.py list
points    Plot original generated points
path      Plot probe travel path
rapid     Plot rapid scan travel path
probedz   Plot probed Z values
meshz     Plot mesh Z values
overlay   Plots the current probed mesh overlaid with a profile
delta     Plots the delta between current probed mesh and a profile
```

Flera alternativ är tillgängliga när visualiseringar ritas:

```
usage: graph_mesh.py plot [-h] [-a] [-s] [-p PROFILE_NAME] [-o OUTPUT] <plot type> <input>

positional arguments:
  <plot type>           Type of data to graph
  <input>               Path/url to Klipper Socket or path to json file

options:
  -h, --help            show this help message and exit
  -a, --animate         Animate paths in live preview
  -s, --scale-plot      Use axis limits reported by Klipper to scale plot X/Y
  -p PROFILE_NAME, --profile-name PROFILE_NAME
                        Optional name of a profile to plot for 'probedz'
  -o OUTPUT, --output OUTPUT
                        Output file path
```

Nedan följer en beskrivning av varje argument:

- `plot type`: Ett obligatoriskt positionsargument som anger vilken typ av visualisering som ska genereras. Måste vara en av de typer som kommandot `graph_mesh.py list` visar.
- `input`: Ett obligatoriskt positionsargument med en sökväg eller URL till indatakällan. Det måste vara ett av följande:
   - En sökväg till Klippers Unix-domänsocket
   - En URL till en Moonraker-instans
   - En sökväg till en JSON-fil som skapats med `graph_mesh.py dump <input>`
- `-a`: Valfri animering för visualiseringstyperna `path` och `rapid`. Animeringar gäller bara i en direkt förhandsvisning.
- `-s`: Skalar valfritt ett diagram med värdena `axis_minimum` och `axis_maximum` som Klippers objekt `toolhead` rapporterade när dumpfilen skapades.
- `-p`: Ett profilnamn som kan anges när 3D-nätvisualiseringen `probedz` genereras. Vid generering av visualiseringen `overlay` eller `delta` måste detta argument anges.
- `-o`: En valfri filsökväg som anger att skriptet ska spara visualiseringen där i stället för att köras i förhandsvisningsläge. Bilder sparas i formatet `svg`.

För att till exempel rita en animerad snabb väg, med anslutning via Klippers Unix-socket:

```
graph_mesh.py plot -a rapid ~/printer_data/comms/klippy.sock
```

Eller för att rita en 3D-visualisering av nätet via Moonraker:

```
graph_mesh.py plot meshz http://my-printer.local
```

### Bed Mesh-analys

Verktyget `graph_mesh.py` kan också användas för att analysera data från API:t [bed_mesh/dump_mesh](#dumping-mesh-data):

```
graph_mesh.py analyze <input>
```

Precis som för kommandot `plot` måste `<input>` vara en sökväg till Klippers Unix-socket, en URL till en Moonraker-instans eller en sökväg till en JSON-fil som skapats med dumpkommandot.

Först utför analysen olika kontroller av de punkter och sonderingsvägar som `bed_mesh` genererade vid dumpningen. Detta omfattar följande:

- Antalet genererade sonderingspunkter, utan tillägg
- Antalet genererade sonderingspunkter, inklusive punkter som genererats på grund av felaktiga områden och/eller en konfigurerad nollreferensposition.
- Antalet sonderingspunkter som genereras vid en snabb skanning.
- Det totala antalet rörelser som genereras för en snabb skanning.
- En kontroll att sonderingspunkterna från en snabb skanning är identiska med de sonderingspunkter som genereras av ett vanligt sonderingsförfarande.
- En kontroll av "återgång" för både den vanliga sonderingsvägen och en snabbskanningsväg. Återgång innebär att samma position besöks mer än en gång under sonderingen. Återgång får aldrig ske under en vanlig sondering. Felaktiga områden *kan* orsaka återgång under en snabb skanning för att undvika att ett felaktigt område passeras på väg till eller från en sondposition, men ska annars aldrig förekomma.

Därefter analyseras varje sonderat nät i dumpen, med början i nätet som var inläst vid dumpningen (om det finns) och sedan alla sparade profiler. Följande data extraheras:

- Nätets form (min. X,Y, max. X,Y, antal sonderingspunkter)
- Nätets Z-intervall (minsta Z, största Z)
- Genomsnittligt Z-värde i nätet
- Standardavvikelse för Z-värdena i nätet

Utöver ovanstående utförs en deltaanalys mellan nät med samma form, som rapporterar följande:

- Deltats intervall mellan två nät (minimum och maximum)
- Medelvärdet för delta
- Deltats standardavvikelse
- Den absoluta största skillnaden
- Det absoluta medelvärdet

### Spara nätdata till en fil

Kommandot `dump` kan användas för att spara svaret i en fil som kan delas för analys vid felsökning:

```
graph_mesh.py dump -o <output file name> <input>
```

`<input>` ska vara en sökväg till Klippers Unix-socket eller en URL till en Moonraker-instans. Alternativet `-o` kan användas för att ange sökvägen till utdatafilen. Om det utelämnas sparas filen i arbetskatalogen med ett filnamn i följande format:

`klipper-bedmesh-{year}{month}{day}{hour}{minute}{second}.json`
