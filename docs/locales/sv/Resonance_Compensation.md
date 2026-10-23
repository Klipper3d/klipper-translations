# Resonanskompensering

Klipper stöder Input Shaping, en teknik som kan användas för att minska ringning (även kallat ekon, ghosting eller rippling) i utskrifter. Ringning är ett ytdefekt vid utskrift där exempelvis kanter upprepar sig på den utskrivna ytan som ett diskret "eko":

|![Ringningstest](img/ringing-test.jpg)|![3D Benchy](img/ringing-3dbenchy.jpg)|

Ringning orsakas av mekaniska vibrationer i skrivaren vid snabba riktningsändringar. Observera att ringning vanligen har mekaniska orsaker: en skrivarstomme som inte är tillräckligt styv, lösa eller alltför elastiska remmar, inriktningsproblem i mekaniska delar, stor rörlig massa med mera. Dessa bör om möjligt kontrolleras och åtgärdas först.

[Input Shaping](https://en.wikipedia.org/wiki/Input_shaping) är en öppenstyrningsteknik som skapar en styrsignal som motverkar sina egna vibrationer. Input Shaping kräver viss justering och mätning innan den kan aktiveras. Utöver ringning minskar Input Shaping vanligtvis även skrivarens vibrationer och skakningar i allmänhet och kan också förbättra tillförlitligheten för läget stealthChop i Trinamics stegmotordrivare.

## Justering

Grundläggande justering kräver att skrivarens ringningsfrekvenser mäts genom att skriva ut en testmodell.

Skiva modellen för ringningstest, som finns i [docs/prints/ringing_tower.stl](prints/ringing_tower.stl), i skivningsprogrammet:

* Rekommenderad lagerhöjd är 0,2 eller 0,25 mm.
* Fyllning och topplager kan ställas in på 0.
* Använd 1–2 skal, eller ännu hellre jämnt vasläge med 1–2 mm bas.
* Använd tillräckligt hög hastighet, omkring 80–100 mm/s, för **yttre** skal.
* Kontrollera att minsta lagertid är **högst** 3 sekunder.
* Kontrollera att eventuell "dynamisk accelerationsstyrning" är inaktiverad i skivningsprogrammet.
* Vrid inte modellen. Den har X- och Y-markeringar på baksidan. Observera att markeringarnas placering i förhållande till skrivarens axlar är ovanlig; det är inget fel. Markeringarna kan senare användas som referens under justeringen eftersom de visar vilken axel mätningarna avser.

### Ringningsfrekvens

Mät först **ringningsfrekvensen**.

1. Om parametern `square_corner_velocity` har ändrats, återställ den till 5,0. Den bör inte höjas när input shaper används eftersom det kan ge mer utjämning i delarna; det är bättre att använda ett högre accelerationsvärde i stället.
1. Inaktivera funktionen `minimum_cruise_ratio` med följande kommando: `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. Inaktivera Pressure Advance: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Om du redan har lagt till avsnittet `[input_shaper]` i printer.cfg kör du kommandot `SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0`. Om felet "Okänt kommando" visas kan du utan risk ignorera det just nu och fortsätta med mätningarna.
1. Kör kommandot: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`. Syftet är att göra ringningen tydligare genom att använda olika höga accelerationsvärden. Kommandot ökar accelerationen var femte mm, från 1 500 mm/s^2: 1 500 mm/s^2, 2 000 mm/s^2, 2 500 mm/s^2 och så vidare upp till 7 000 mm/s^2 i det sista bandet.
1. Skriv ut testmodellen som skivats med de föreslagna parametrarna.
1. Du kan avbryta utskriften tidigare om ringningen syns tydligt och accelerationen blir för hög för skrivaren (till exempel om skrivaren skakar för mycket eller börjar tappa steg).
1. Använd X- och Y-markeringarna på modellens baksida som referens. Mätningarna från sidan med X-markeringen används för *konfigurationen* av X-axeln och mätningarna från Y-markeringen för Y-axeln. Mät avståndet *D* (i mm) mellan flera svängningar på delen med X-markeringen, nära urtagen; hoppa helst över den första eller de första två svängningarna. Markera först svängningarna och mät sedan avståndet mellan markeringarna med en linjal eller ett skjutmått för att göra mätningen enklare:

   |![Markera ringning](img/ringing-mark.jpg)|![Mät ringning](img/ringing-measure.jpg)|
1. Räkna hur många svängningar *N* som det uppmätta avståndet *D* motsvarar. Om du är osäker på hur svängningarna ska räknas kan du se bilden ovan, där *N* = 6 svängningar.
1. Beräkna ringningsfrekvensen för X-axeln som *V* &middot; *N* / *D* (Hz), där *V* är hastigheten för yttre perimetrar (mm/s). I exemplet ovan markerade vi 6 svängningar och testet skrevs ut med hastigheten 100 mm/s. Frekvensen är alltså 100 * 6 / 12,14 ≈ 49,4 Hz.
1. Gör även steg (8)–(10) för Y-markeringen.

Observera att ringningen på testutskriften ska följa mönstret från de böjda urtagen, som på bilden ovan. Om den inte gör det är felet inte verklig ringning utan har en annan orsak, antingen mekanisk eller i extrudern. Felet bör åtgärdas innan input shaping aktiveras och justeras.

Om mätningarna är otillförlitliga, exempelvis för att avståndet mellan svängningarna inte är stabilt, kan skrivaren ha flera resonansfrekvenser på samma axel. Du kan i stället försöka följa justeringsprocessen i avsnittet [Otillförlitliga mätningar av ringningsfrekvenser](#unreliable-measurements-of-ringing-frequencies) och ändå få nytta av input shaping.

Ringningsfrekvensen kan bero på modellens position på byggplattan och på Z-höjden, *särskilt på deltaskrivare*. Kontrollera om frekvenserna skiljer sig åt vid olika positioner längs testmodellens sidor och på olika höjder. Om så är fallet kan du beräkna genomsnittliga ringningsfrekvenser för X- och Y-axlarna.

Om den uppmätta ringningsfrekvensen är mycket låg (under cirka 20–25 Hz) kan det vara klokt att göra skrivaren styvare eller minska den rörliga massan, beroende på vad som passar din skrivare, innan input shaping justeras vidare. Mät sedan frekvenserna på nytt. För många populära skrivarmodeller finns redan lösningar.

Observera att ringningsfrekvenserna kan ändras när ändringar görs på skrivaren som påverkar den rörliga massan eller systemets styvhet, exempelvis:

* Verktyg på skrivhuvudet installeras, tas bort eller byts ut så att dess massa ändras, till exempel när en ny (tyngre eller lättare) stegmotor för en direkt-extruder eller ett nytt hotend installeras, en tung fläkt med luftkanal läggs till och så vidare.
* Remmarna spänns.
* Tillbehör som ökar ramens styvhet installeras.
* En annan byggplatta monteras på en skrivare med rörlig bädd, glas läggs till och så vidare.

När sådana ändringar görs är det klokt att åtminstone mäta ringningsfrekvenserna för att se om de har förändrats.

### Konfiguration av input shaper

När ringningsfrekvenserna för X- och Y-axlarna har mätts kan du lägga till följande avsnitt i `printer.cfg`:

```
[input_shaper]
shaper_freq_x: ...  # frequency for the X mark of the test model
shaper_freq_y: ...  # frequency for the Y mark of the test model
```

I exemplet ovan blir shaper_freq_x/y = 49,4.

### Välja input shaper

Klipper har stöd för flera input shapers. De skiljer sig åt i känslighet för fel vid bestämning av resonansfrekvensen och hur mycket utjämning de orsakar i utskrivna delar. Vissa shapers, som 2HUMP_EI och 3HUMP_EI, bör normalt inte användas med shaper_freq = resonansfrekvensen. De konfigureras utifrån andra överväganden för att minska flera resonanser samtidigt.

För de flesta skrivare kan antingen MZV- eller EI-shapers rekommenderas. I det här avsnittet beskrivs en testmetod för att välja mellan dem och fastställa några andra relaterade parametrar.

Skriv ut ringningstestmodellen så här:

1. Starta om den inbyggda programvaran: `RESTART`
1. Förbered testet: `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. Inaktivera Pressure Advance: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Kör: `SET_INPUT_SHAPER SHAPER_TYPE=MZV`
1. Kör kommandot: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`
1. Skriv ut testmodellen som skivats med de föreslagna parametrarna.

Om du inte ser någon ringning vid det här laget kan MZV-shaper rekommenderas.

Om du ser viss ringning, mät frekvenserna igen enligt steg (8)–(10) i avsnittet [Ringningsfrekvens](#ringing-frequency). Om frekvenserna skiljer sig mycket från de värden du fått tidigare behövs en mer komplex konfiguration av input shaper. Se avsnittet Tekniska detaljer om [Input shapers](#input-shapers). Annars fortsätter du till nästa steg.

Prova nu EI-shaper. Upprepa steg (1)–(6) ovan, men kör följande kommando i steg 4 i stället: `SET_INPUT_SHAPER SHAPER_TYPE=EI`.

Jämför två utskrifter, en med MZV- och en med EI-input shaper. Om EI ger märkbart bättre resultat än MZV använder du EI, annars föredras MZV. Observera att EI ger mer utjämning i utskrivna delar (se nästa avsnitt för mer information). Lägg till parametern `shaper_type: mzv` (eller ei) i avsnittet [input_shaper], exempelvis:

```
[input_shaper]
shaper_freq_x: ...
shaper_freq_y: ...
shaper_type: mzv
```

Några kommentarer om valet av shaper:

* EI-shaper kan passa bättre för skrivare med rörlig bädd, om resonansfrekvensen och den resulterande utjämningen tillåter det. När mer filament läggs på den rörliga bädden ökar bäddens massa och resonansfrekvensen minskar. Eftersom EI-shaper är mer tålig mot förändringar i resonansfrekvensen kan den fungera bättre vid utskrift av stora delar.
* På grund av deltakinematikens natur kan resonansfrekvenserna skilja sig mycket mellan olika delar av byggvolymen. EI-shaper kan därför passa bättre för deltaskrivare än MZV eller ZV och bör övervägas. Om resonansfrekvensen är tillräckligt hög (över 50–60 Hz) kan du till och med försöka testa 2HUMP_EI-shaper genom att köra testet ovan med `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI`. Läs dock rekommendationerna i [avsnittet nedan](#selecting-max_accel) innan den aktiveras.

### Välja max_accel

Du ska ha en utskriven testmodell för den shaper du valde i föregående steg. Om du saknar den skriver du ut testmodellen med [föreslagna parametrar](#tuning), med Pressure Advance avstängt (`SET_PRESSURE_ADVANCE ADVANCE=0`) och tuning tower aktiverat som `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`. Vid mycket höga accelerationer kan input shaping, beroende på resonansfrekvensen och vald input shaper (EI ger till exempel mer utjämning än MZV), ge för mycket utjämning och avrundning av delarna. Välj därför max_accel så att detta undviks. Parametern `square_corner_velocity` kan också påverka utjämningen; höj den inte över standardvärdet 5 mm/s för att undvika mer utjämning.

För att välja ett lämpligt värde för max_accel granskar du modellen för den valda input shaper. Notera först vid vilken acceleration ringningen fortfarande är så liten att du accepterar den.

Kontrollera sedan utjämningen. Testmodellen har en liten öppning i väggen (0,15 mm) som hjälp för detta:

![Testöppning](img/smoothing-test.png)

När accelerationen ökar ökar också utjämningen och den verkliga öppningen i utskriften blir bredare:

![Utjämning från shaper](img/shaper-smoothing.jpg)

På den här bilden ökar accelerationen från vänster till höger och öppningen börjar växa vid 3 500 mm/s^2 (det femte bandet från vänster). I det här fallet är därför max_accel = 3 000 (mm/s^2) ett lämpligt värde för att undvika för kraftig utjämning.

Notera accelerationen när öppningen fortfarande är mycket liten på din testutskrift. Om du ser utbuktningar men ingen öppning alls i väggen, även vid hög acceleration, kan Pressure Advance vara avstängt, särskilt för Bowden-extrudrar. Då kan du behöva upprepa utskriften med PA aktiverat. Det kan också bero på ett felkalibrerat (för högt) filamentflöde, vilket också bör kontrolleras.

Välj det lägsta av de två accelerationsvärdena (från ringning och utjämning) och ange det som `max_accel` i printer.cfg.

Särskilt vid låga ringningsfrekvenser kan EI-shaper ge för kraftig utjämning även vid lägre acceleration. I så fall kan MZV vara ett bättre val eftersom den kan tillåta högre accelerationsvärden.

Vid mycket låga ringningsfrekvenser (cirka 25 Hz och lägre) kan även MZV-shaper ge för kraftig utjämning. Då kan du försöka upprepa stegen i avsnittet [Välja input shaper](#choosing-input-shaper) med ZV-shaper genom att i stället använda kommandot `SET_INPUT_SHAPER SHAPER_TYPE=ZV`. ZV-shaper bör ge ännu mindre utjämning än MZV, men är känsligare för fel vid mätning av ringningsfrekvenserna.

En annan aspekt är att om resonansfrekvensen är för låg (under 20–25 Hz) kan det vara klokt att öka skrivarens styvhet eller minska den rörliga massan. Annars kan accelerationen och utskriftshastigheten begränsas av för kraftig utjämning i stället för ringning.

### Finjustera resonansfrekvenser

Observera att noggrannheten hos resonansfrekvensmätningarna med ringningstestmodellen räcker för de flesta ändamål, så ytterligare justering rekommenderas inte. Om du ändå vill dubbelkontrollera resultatet (till exempel om du fortfarande ser ringning efter att ha skrivit ut en testmodell med en valfri input shaper och samma frekvenser som du mätt tidigare) kan du följa stegen i detta avsnitt. Om du ser ringning vid andra frekvenser efter att [input_shaper] har aktiverats hjälper inte det här avsnittet.

Förutsatt att ringningsmodellen har skivats med föreslagna parametrar utför du följande steg för var och en av X- och Y-axlarna:

1. Förbered testet: `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. Kontrollera att Pressure Advance är inaktiverat: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Kör: `SET_INPUT_SHAPER SHAPER_TYPE=ZV`
1. Välj den acceleration i den befintliga ringningstestmodellen med den valda input shaper som visar ringningen tillräckligt tydligt och ställ in den med: `SET_VELOCITY_LIMIT ACCEL=...`
1. Beräkna parametrarna som behövs för kommandot `TUNING_TOWER` för att justera parametern `shaper_freq_x`: start = shaper_freq_x * 83 / 132 och factor = shaper_freq_x / 66, där `shaper_freq_x` är det aktuella värdet i `printer.cfg`.
1. Kör kommandot `TUNING_TOWER COMMAND=SET_INPUT_SHAPER PARAMETER=SHAPER_FREQ_X START=start FACTOR=factor BAND=5` med värdena `start` och `factor` som beräknades i steg (5).
1. Skriv ut testmodellen.
1. Återställ det ursprungliga frekvensvärdet: `SET_INPUT_SHAPER SHAPER_FREQ_X=...`.
1. Hitta bandet med minst ringning och räkna dess nummer från botten, med 1 som första nummer.
1. Beräkna det nya värdet för shaper_freq_x som gamla shaper_freq_x * (39 + 5 * bandnummer) / 66.

Upprepa stegen på samma sätt för Y-axeln och ersätt hänvisningar till X-axeln med Y-axeln (ersätt till exempel `shaper_freq_x` med `shaper_freq_y` i formlerna och i kommandot `TUNING_TOWER`).

Anta till exempel att ringningsfrekvensen för en av axlarna har mätts till 45 Hz. Då blir start = 45 * 83 / 132 = 28,30 och factor = 45 / 66 = 0,6818 för kommandot `TUNING_TOWER`. Anta sedan att det fjärde bandet från botten har minst ringning efter att testmodellen skrivits ut. Det uppdaterade värdet för shaper_freq_? blir då 45 * (39 + 5 * 4) / 66 ≈ 40,23.

När de nya parametrarna `shaper_freq_x` och `shaper_freq_y` har beräknats kan du uppdatera avsnittet `[input_shaper]` i `printer.cfg` med de nya värdena.

### Pressure Advance

Om du använder Pressure Advance kan den behöva justeras på nytt. Följ [anvisningarna](Pressure_Advance.md#tuning-pressure-advance) för att hitta det nya värdet om det skiljer sig från det tidigare. Starta om Klipper innan du justerar Pressure Advance.

### Otillförlitliga mätningar av ringningsfrekvenser

Om du inte kan mäta ringningsfrekvenserna, till exempel om avståndet mellan svängningarna inte är stabilt, kan du ändå använda input shaping. Resultatet blir dock kanske inte lika bra som med korrekta frekvensmätningar och kräver mer justering och utskrift av testmodellen. Ett annat alternativ är att köpa och installera en accelerometer och mäta resonanserna med den (se [dokumentationen](Measuring_Resonances.md) om nödvändig maskinvara och konfiguration), men det kräver krimpning och lödning.

Lägg till ett tomt avsnitt `[input_shaper]` i `printer.cfg` för justeringen. Förutsatt att ringningsmodellen har skivats med föreslagna parametrar skriver du sedan ut testmodellen tre gånger enligt följande. Kör före den första utskriften

1. `RESTART`
1. `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. `SET_PRESSURE_ADVANCE ADVANCE=0`
1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=60 SHAPER_FREQ_Y=60`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

och skriv ut modellen. Skriv sedan ut modellen igen, men kör före utskriften i stället

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=50 SHAPER_FREQ_Y=50`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

Skriv sedan ut modellen en tredje gång, men kör nu

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=40 SHAPER_FREQ_Y=40`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

I praktiken skriver vi ut ringningstestmodellen med TUNING_TOWER och 2HUMP_EI-shaper med shaper_freq = 60 Hz, 50 Hz och 40 Hz.

Om ingen av modellerna visar förbättrad ringning kan input shaping tyvärr inte hjälpa i ditt fall.

Annars kan alla modeller vara fria från ringning, eller så visar vissa mer ringning än andra. Välj testmodellen med den högsta frekvens som fortfarande visar en bra förbättring av ringningen. Om modellerna med 40 Hz och 50 Hz exempelvis nästan saknar ringning, medan modellen med 60 Hz redan visar mer, väljer du 50 Hz.

Kontrollera nu om EI-shaper är tillräckligt bra för din skrivare. Välj frekvensen för EI-shaper utifrån frekvensen för den 2HUMP_EI-shaper du valde:

* För 2HUMP_EI-shaper på 60 Hz använder du EI-shaper med shaper_freq = 50 Hz.
* För 2HUMP_EI-shaper på 50 Hz använder du EI-shaper med shaper_freq = 40 Hz.
* För 2HUMP_EI-shaper på 40 Hz använder du EI-shaper med shaper_freq = 33 Hz.

Skriv nu ut testmodellen en gång till och kör

1. `SET_INPUT_SHAPER SHAPER_TYPE=EI SHAPER_FREQ_X=... SHAPER_FREQ_Y=...`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

med shaper_freq_x=... och shaper_freq_y=... som fastställdes tidigare.

Om EI-shaper visar lika bra resultat som 2HUMP_EI-shaper använder du EI-shaper och den tidigare fastställda frekvensen. Annars använder du 2HUMP_EI-shaper med motsvarande frekvens. Lägg till resultatet i `printer.cfg`, exempelvis

```
[input_shaper]
shaper_freq_x: 50
shaper_freq_y: 50
shaper_type: 2hump_ei
```

Fortsätt justeringen i avsnittet [Välja max_accel](#selecting-max_accel).

## Felsökning och vanliga frågor

### Jag kan inte få tillförlitliga mätningar av resonansfrekvenser

Kontrollera först att det verkligen är ringning och inte något annat problem med skrivaren. Om mätningarna är otillförlitliga, exempelvis för att avståndet mellan svängningarna inte är stabilt, kan skrivaren ha flera resonansfrekvenser på samma axel. Du kan försöka följa justeringsprocessen i avsnittet [Otillförlitliga mätningar av ringningsfrekvenser](#unreliable-measurements-of-ringing-frequencies) och ändå få nytta av input shaping. Ett annat alternativ är att installera en accelerometer, [mäta](Measuring_Resonances.md) resonanserna med den och automatiskt justera input shaper utifrån mätresultaten.

### Efter att [input_shaper] har aktiverats blir utskrivna delar för utjämnade och fina detaljer försvinner

Se över rekommendationerna i avsnittet [Välja max_accel](#selecting-max_accel). Om resonansfrekvensen är låg bör max_accel inte sättas för högt och parametrarna square_corner_velocity inte ökas. Det kan också vara bättre att välja MZV- eller till och med ZV-shaper i stället för EI (eller 2HUMP_EI- och 3HUMP_EI-shaper).

### Efter en tids lyckad utskrift utan ringning verkar den komma tillbaka

Resonansfrekvenserna kan ha förändrats efter en tid. Till exempel kan remspänningen ha ändrats (remmarna har blivit lösare). Kontrollera och mät ringningsfrekvenserna igen enligt avsnittet [Ringningsfrekvens](#ringing-frequency), och uppdatera konfigurationsfilen vid behov.

### Har input shapers stöd för konfiguration med två vagnar?

Ja. I så fall bör resonanserna mätas två gånger för varje vagn. Om den andra (dubbla) vagnen till exempel är monterad på X-axeln kan olika input shapers ställas in för X-axeln för den primära respektive den dubbla vagnen. Input shaper för Y-axeln ska dock vara samma för båda vagnarna (axeln drivs slutligen av en eller flera stegmotorer som beordras att utföra exakt samma steg). Ett sätt att konfigurera input shaper för sådana uppsättningar är att lämna avsnittet `[input_shaper]` tomt och dessutom definiera avsnittet `[delayed_gcode]` i `printer.cfg` så här:

```
[input_shaper]
# Intentionally empty

[delayed_gcode init_shaper]
initial_duration: 0.1
gcode:
  SET_DUAL_CARRIAGE CARRIAGE=1
  SET_INPUT_SHAPER SHAPER_TYPE_X=<dual_carriage_shaper> SHAPER_FREQ_X=<dual_carriage_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
  SET_DUAL_CARRIAGE CARRIAGE=0
  SET_INPUT_SHAPER SHAPER_TYPE_X=<primary_carriage_shaper> SHAPER_FREQ_X=<primary_carriage_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
```

Användare av `generic_cartesian`-kinematik ska dock ange vagnarnas namn i parametern `CARRIAGE=` för `SET_DUAL_CARRIAGE` i stället för deras nummer. Observera att `SHAPER_TYPE_Y` och `SHAPER_FREQ_Y` ska vara samma i båda kommandona. Om en input shaper ska konfigureras för Z-axeln ska dess parametrar ingå i båda kommandona `SET_INPUT_SHAPER`.

Utöver `delayed_gcode` går det att lägga en liknande kodsnutt i start-G-code i skivningsprogrammet, men då aktiveras shaper först när en utskrift startas.

Observera att input shaper bara behöver konfigureras en gång. Senare ändringar av vagnarna eller deras lägen med kommandot `SET_DUAL_CARRIAGE` behåller de konfigurerade parametrarna för input shaper.

### Påverkar input_shaper utskriftstiden?

Nej, funktionen `input_shaper` påverkar i stort sett inte utskriftstiden i sig. Värdet för `max_accel` påverkar däremot tiden (justering av parametern beskrivs i [det här avsnittet](#selecting-max_accel)).

### Ska jag aktivera och justera input shaper för Z-axeln?

De flesta användare ser sannolikt inga direkta förbättringar av utskriftskvaliteten, till skillnad från med X- och Y-shapers. Användare av deltaskrivare, skrivare med flygande portal eller skrivare med tunga rörliga bäddar kan däremot öka de kinematiska gränserna `max_z_accel` och `max_z_velocity` och därmed få snabbare Z-rörelser. Det kan vara särskilt användbart för verktygsväxlare och när Z-hop är aktiverat i skivningsprogrammet. Efter att Z input shaper har aktiverats hör många användare också att Z-axeln arbetar mjukare, vilket kan göra skrivaren behagligare att använda och något förlänga livslängden på Z-axelns delar.

## Tekniska detaljer

### Input shapers

Det här avsnittet ger en kort översikt över några tekniska aspekter av de input shapers som stöds. Input shapers i Klipper är ganska standardmässiga, med undantag för MZV. Mer ingående beskrivningar finns i artiklarna om respektive shaper.

MZV står för en Modified-ZV-input shaper. Den klassiska definitionen av ZV-shaper utgår från två pulser och den totala varaktigheten `t` lika med 1/2 av den dämpade svängningsperioden `Td`. Det går dock att konstruera en generaliserad form av ZV-input shaper med `n >= 3` pulser och en godtycklig total varaktighet `t >= 0.5 * Td` (där det högsta möjliga `t` beror på värdet för `n`), se till exempel SNA-ZV- och MIS-ZV-input shapers. De kan ses som specialfall av den mer generaliserade implementeringen av MZV-input shaper i Klipper. Standardparametrarna för MZV i Klipper är `n=3`, `t=0.75` (av `Td`). Den här shapern utformades som ett mellanting mellan ZV och ZVD: den ger bättre vibrationsdämpning än ZV när de fastställda (uppmätta) shaper-parametrarna avviker från vad skrivaren faktiskt behöver, och mindre utjämning än ZVD. Dess varaktighet `t=0.75`, exakt mellan ZV (`t=0.5` av `Td`) och ZVD (`t=1` av `Td`), fungerar väl för många verkliga 3D-skrivare. Erfarna användare kan ändra standardparametrarna för MZV-input shaper och prova andra varianter som kan fungera bättre för deras specifika skrivare. Sådana icke-standardvarianter anges exempelvis som `mzv(n=3,t=0.8)` eller `mzv(n=5,t=1.1)` i avsnittet `[input_shaper]`, som parameter till `SET_INPUT_SHAPER` eller till skriptet `~/klipper/scripts/calibrate_shaper.py`, exempelvis `--shapers='2hump_ei,3hump_ei,mzv(n=6,t=1.0)'`. De egna shaper-parametrarna stöds också av skriptet `~/klipper/scripts/graph_shaper.py`, till exempel med parametern `--shaper='mzv(n=3,t=0.6666666666)'`.

Tabellen nedan visar några, vanligen ungefärliga, parametrar för varje shaper med standardparametrar.

| Input <br> shaper | Shaperns <br> varaktighet | Vibrationsminskning 20× <br> (5 % vibrationstolerans) | Vibrationsminskning 10× <br> (10 % vibrationstolerans) |
| :-: | :-: | :-: | :-: |
| ZV | 0,5 / shaper_freq | Ej tillämpligt | ± 5 % shaper_freq |
| MZV | 0,75 / shaper_freq | ± 4 % shaper_freq | -10 % … +15 % shaper_freq |
| ZVD | 1 / shaper_freq | ± 15 % shaper_freq | ± 22 % shaper_freq |
| EI | 1 / shaper_freq | ± 20 % shaper_freq | ± 25 % shaper_freq |
| 2HUMP_EI | 1,5 / shaper_freq | -40 … +45 % shaper_freq | -45 … +50 % shaper_freq |
| 3HUMP_EI | 2 / shaper_freq | -50 … +60 % shaper_freq | -55 % … +65 % shaper_freq |

En anmärkning om vibrationsminskning: värdena i tabellen ovan är ungefärliga. Om skrivarens dämpningsförhållande är känt för varje axel kan shapern konfigureras mer exakt och då minska resonanserna inom ett något bredare frekvensområde. Dämpningsförhållandet är dock vanligen okänt och svårt att uppskatta utan specialutrustning. Klipper använder därför standardvärdet 0,1, som fungerar bra generellt. Frekvensområdena i tabellen täcker flera möjliga dämpningsförhållanden omkring detta värde (ungefär från 0,075 till 0,15).

Observera också att EI, 2HUMP_EI och 3HUMP_EI är justerade för att minska vibrationerna till 5 %, så värdena för 10 % vibrationstolerans anges endast som referens. En användare kan dock ange önskad vibrationstolerans för EI-input shaper på samma sätt som för MZV-input shaper, till exempel `ei(v_tol=0.02)` eller `ei(v_tol=0.1)`. Då blir området för vibrationsminskning annorlunda.

**Så här använder du tabellen:**

* Shaperns varaktighet påverkar utjämningen i delarna: ju längre den är, desto jämnare blir delarna. Sambandet är inte linjärt, men ger en uppfattning om vilka shapers som ger mer utjämning vid samma frekvens. Ordningen för utjämning är: ZV < MZV < ZVD ≈ EI < 2HUMP_EI < 3HUMP_EI. Det är dessutom sällan praktiskt att sätta shaper_freq = resonansfrekvensen för 2HUMP_EI och 3HUMP_EI (de bör användas för att minska vibrationer vid flera frekvenser).
* Du kan uppskatta frekvensområdet där shaper minskar vibrationerna. MZV med shaper_freq = 35 Hz minskar till exempel vibrationerna till 5 % för frekvenserna [33,6, 36,4] Hz. 3HUMP_EI med shaper_freq = 50 Hz minskar vibrationerna till 5 % i området [27,5, 75] Hz.
* Använd tabellen för att avgöra vilken shaper som bör användas om vibrationer måste minskas vid flera frekvenser. Om en axel till exempel har resonanser vid 35 Hz och 60 Hz: a) EI-shaper behöver ha shaper_freq = 35 / (1 - 0.2) = 43,75 Hz och minskar resonanserna till 43,75 * (1 + 0.2) = 52,5 Hz, vilket inte räcker; b) 2HUMP_EI-shaper behöver ha shaper_freq = 35 / (1 - 0.4) = 58,3 Hz och minskar vibrationerna till 58,3 * (1 + 0.45) = 84,5 Hz, vilket är en godtagbar konfiguration. Försök alltid använda så hög shaper_freq som möjligt för en given shaper, gärna med en viss säkerhetsmarginal. I detta exempel skulle shaper_freq ≈ 55 Hz fungera bäst. Försök också använda en shaper med så kort varaktighet som möjligt.
* Om vibrationer behöver minskas vid flera mycket olika frekvenser (exempelvis 30 Hz och 100 Hz) kan tabellen ovan vara otillräcklig. Då kan skriptet [scripts/graph_shaper.py](../scripts/graph_shaper.py), som är mer flexibelt, fungera bättre.
