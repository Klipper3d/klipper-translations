# Lastceller

Det här dokumentet beskriver Klippers stöd för lastceller. Grundläggande lastcellsfunktioner kan läsa kraftdata och väga exempelvis filament. En kalibrerad kraftsensor är en viktig del av en lastcellsbaserad prob.

## Relaterad dokumentation

* [Konfigurationsreferens för load_cell](Config_Reference.md#load_cell)
* [G-kodkommandon för load_cell](G-Codes.md#load_cell)
* [Statusreferens för load_cell](Status_Reference.md#load_cell)

## Använda `LOAD_CELL_DIAGNOSTIC`

När du ansluter en lastcell första gången bör du kontrollera problem genom att köra `LOAD_CELL_DIAGNOSTIC`. Verktyget samlar data från lastcellen under 10 sekunder och rapporterar statistik:

```
$ LOAD_CELL_DIAGNOSTIC
// Collecting load cell data for 10 seconds...
// Samples Collected: 3211
// Measured samples per second: 332.0
// Good samples: 3211, Saturated samples: 0, Unique values: 900
// Sample range: [4.01% to 4.02%]
// Sample range / sensor capacity: 0.00524%
```

Saker du kan kontrollera med dessa data:

* Sensorns konfigurerade samplingsfrekvens bör ligga nära värdet "Measured samples per second". Om den inte gör det kan det finnas ett konfigurations- eller kabelproblem.
* "Saturated samples" ska vara 0. Mättade sampel innebär att lastcellen utsätts för mer kraft än den kan mäta.
* "Unique values" bör vara en stor andel av "Samples Collected". Om "Unique values" är 1 är det mycket sannolikt ett kabelproblem.
* Knacka på eller tryck på sensorn medan `LOAD_CELL_DIAGNOSTIC` körs. Om allt fungerar korrekt ska "Sample range" öka.

## Kalibrera en lastcell

Lastceller kalibreras med kommandot `LOAD_CELL_CALIBRATE`. Det är ett interaktivt kalibreringsverktyg som leder dig genom tre steg:

1. Använd först kommandot `TARE` för att fastställa nollkraftsvärdet. Det är konfigurationsvärdet `reference_tare_counts`.
1. Applicera sedan en känd belastning eller kraft på lastcellen och kör `CALIBRATE GRAMS=nnn`. Då beräknas värdet `counts_per_gram`. Se [nästa avsnitt](#applying-a-known-force-or-load) för förslag på hur detta görs.
1. Använd slutligen kommandot `ACCEPT` för att spara resultaten.

Du kan när som helst avbryta kalibreringen med `ABORT`.

### Applicera en känd kraft eller belastning

Steget `CALIBRATE GRAMS=nnn` kan utföras på flera sätt. Om lastcellen sitter under en plattform, till exempel bädden eller en filamenthållare, är det ofta enklast att lägga en känd massa på plattformen, exempelvis ett par filamentrullar på 1 kg.

Om lastcellen sitter i skrivarens verktygshuvud är en annan metod enklare. Placera en digitalvåg på skrivarens bädd och sänk verktygshuvudet försiktigt mot vågen, eller höj bädden mot verktygshuvudet om bädden rör sig. Du kan möjligen använda `FORCE_MOVE`, men oftast måste Z-axeln flyttas manuellt med motorerna avstängda tills verktygshuvudet trycker mot vågen.

En bra kalibreringskraft är helst en stor andel av lastcellens nominella kapacitet. En lastcell på 5 kg kalibreras idealiskt med en massa på 5 kg. Det kan fungera väl för sensorer under bädden som måste bära mycket vikt. För prober i verktygshuvudet kan den belastningen skada bädden eller verktygshuvudet. Försök använda minst 1 kg kraft; de flesta skrivare bör tåla det utan problem.

Notera värdena som rapporteras vid kalibrering noggrant:

```
$ CALIBRATE GRAMS=555
// Calibration value: -2.78% (-59803108), Counts/gram: 73039.78739,
Total capacity: +/- 29.14Kg
```

`Total capacity` ska ligga nära lastcellens teoretiska kapacitet utifrån sensorns kapacitet. Om värdet är mycket större kan en högre förstärkning ha använts i sensorn eller en känsligare lastcell behövas. Detta är mindre kritiskt för 32- och 24-bitars sensorer men betydligt viktigare för sensorer med låg bitbredd.

## Läsa kraftdata

Kraftdata kan läsas med ett G-kodkommando:

```
LOAD_CELL_READ
// 10.6g (1.94%)
```

Data läses också kontinuerligt och kan hämtas från skrivarobjektet `load_cell` i ett makro:

```
{% set grams = printer.load_cell.force_g %}
```

Detta ger en genomsnittlig kraft under den senaste sekunden, på samma sätt som temperatursensorer fungerar.

## Tarera en lastcell

Tarering, ibland kallad nollställning, ställer in den aktuella vikt som rapporteras av load_cell till 0. Det är användbart för mätning i förhållande till en känd vikt. Vid mätning av en filamentrulle ställer `LOAD_CELL_TARE` exempelvis vikten till 0. När filament sedan skrivs ut rapporterar load_cell vikten av det använda filamentet.

```
LOAD_CELL_TARE
// Load cell tare value: 5.32% (445903)
```

Det aktuella tareringsvärdet rapporteras i skrivarens status och kan läsas i ett makro:

```
{% set tare_counts = printer.load_cell.tare_counts %}
```

# Lastcellsprober

## Relaterad dokumentation

* [Konfigurationsreferens för load_cell_probe](Config_Reference.md#load_cell_probe)
* [G-kodkommandon för load_cell_probe](G-Codes.md#load_cell_probe)
* [Statusreferens för load_cell_probe](Status_Reference.md#load_cell_probe)

## Säkerhet för lastcellsprob

Eftersom lastceller är prober med direktkontakt med munstycket riskerar skrivaren att skadas om för stor kraft används. Lastcellsprobens system har flera säkerhetskontroller som försöker skydda maskinen från överdriven kraft på verktygshuvudet. Det är viktigt att förstå dem, eftersom dåligt valda konfigurationsvärden kan kringgå de flesta.

#### Kalibreringskontroll

Vid varje start av en nollställningsrörelse kontrollerar load_cell_probe att lastcellen är kalibrerad. Annars stoppas rörelsen med felet `!! Load Cell not calibrated`.

#### `counts_per_gram`

Den här inställningen omvandlar råa sensorräkningar till gram. Alla säkerhetsgränser anges i gram. Om `counts_per_gram` inte är korrekt kan den säkra kraften på verktygshuvudet lätt överskridas. Gissa aldrig detta värde; använd `LOAD_CELL_CALIBRATE` för att fastställa lastcellens faktiska `counts_per_gram`.

#### `trigger_force`

Detta är kraften i gram som får ändstoppet att stoppa nollställningsrörelsen. När rörelsen startar tarerar ändstoppet sig självt med lastcellens aktuella avläsning. `trigger_force` mäts från detta tareringsvärde. Värdet överskrids alltid något när proben kolliderar med bädden, så var försiktig. En inställning på 100 g kan exempelvis ge en toppkraft på 350 g innan verktygshuvudet stannar. Överskridandet ökar vid högre `speed`, låg ADC-samplingsfrekvens eller [nollställning med flera MCU:er](Multi_MCU_Homing.md).

#### `reference_tare_counts`

Detta är grundvärdet för tarering som sätts av `LOAD_CELL_CALIBRATE`. Värdet samverkar med `force_safety_limit` för att begränsa den högsta kraften på verktygshuvudet.

#### `force_safety_limit`

Detta är den största absoluta kraft, relativt `reference_tare_counts`, som proben tillåter vid nollställning eller sondering. Om MCU:n ser att kraften överskrids stängs skrivaren av med felet `!! Load cell endstop: too much force!`. Det finns flera sätt detta kan utlösas på:

Den första risken som detta skyddar mot är att välja ett för stort värde för `drift_filter_cutoff_frequency`. Då kan driftfiltret filtrera bort en sondhändelse och låta nollställningsrörelsen fortsätta. I så fall fungerar `force_safety_limit` som ett reservskydd.

Det andra problemet är att sondera upprepade gånger på samma plats. Klipper drar inte tillbaka proben vid ett enstaka `PROBE`-kommando. Det kan lämna kraft på verktygshuvudet efter sonderingscykeln. Eftersom externa krafter kan variera kraftigt mellan platser tarerar `load_cell_probe` före varje sondning. Om du upprepar `PROBE` tareras ändstoppet vid den aktuella kraften. Flera cykler ökar kraften på verktygshuvudet; `force_safety_limit` hindrar cykeln från att löpa okontrollerat.

Ett annat sätt som den okontrollerade rörelsen kan uppstå är skada på en töjningsgivare. Om metalldelen böjs permanent ändras enhetens `reference_tare_counts`. Det för startvärdet närmare gränsen och gör överskridande mer sannolikt. Du bör få en varning om detta eftersom maskinvaran har skadats permanent.

Den sista utlösningsorsaken är temperaturförändringar. Om töjningsgivarna värms upp kan `reference_tare_counts` skilja sig mycket mellan omgivnings- och driftstemperatur. Då kan `force_safety_limit` behöva höjas för att ta hänsyn till termiska förändringar.

#### Lastcellsändstoppets övervakningsuppgift

Vid nollställning startar load_cell_endstop en uppgift på MCU:n som följer mätningar från sensorn. Om sensorn inte skickar mätningar under två samplingsperioder stänger övervakaren av skrivaren med felet `!! LoadCell Endstop timed out waiting on ADC data`.

Om detta händer är den troligaste orsaken ett fel från ADC:n. Otillräcklig jordning kan vara grundorsaken. Ramen, nätaggregatets hölje och skrivarens bädd ska vara anslutna till jord. Ramen kan behöva jordas på flera platser. Anodiserade aluminiumprofiler leder inte elektricitet väl; området där jordledaren fästs kan behöva slipas för god elektrisk kontakt.

#### Interpolering

För att öka sonderingsresultatets precision kan positionen för första kontakten mellan munstycke och bädd uppskattas genom att anpassa en styckvis funktion till mätdata. Ovanför bädden är kraften konstant vid tareringsvärdet; vid kontakt ökar kraften linjärt när Z-positionen minskar. Delningspunktens optimala Z-position fås genom att minimera kvadratfelet. Det ger en upplösning finare än avståndet mellan samplingspunkterna och mindre känslighet för brus.

Av fysiska och tekniska skäl använder interpoleringen data från en extra uppåtgående rörelse efter den inledande nedåtgående rörelsen. De första 300 ms av data från uppåtrörelsen används för anpassningen, vilket minimerar påverkan av tareringsdrift. Det krävs minst tre sampel både under och över kontaktpunkten.

En relativt hög utlösningskraft rekommenderas för att proben ska få en tillräckligt stark signal. Om det finns för få sampel under kontaktpunkten kan `trigger_force` höjas eller `lift_speed` sänkas. Om `lift_speed` är för låg blir det dock för få sampel ovanför kontaktpunkten på grund av fönstret på 300 ms.

Avståndet för den uppåtgående rörelsen kan konfigureras med parametern `sample_retract_dist`.

## Konfigurera lastcellsproben

Det här avsnittet beskriver hur en lastcellsprob tas i drift.

### Kontrollera lastcellen först

En `[load_cell_probe]` är också en `[load_cell]`, och G-kodkommandon för `[load_cell]` fungerar med `[load_cell_probe]`. Innan du använder en lastcellsprob ska du följa anvisningarna för [kalibrering av lastcellen](Load_Cell.md#calibrating-a-load-cell) med `CALIBRATE_LOAD_CELL` och kontrollera funktionen med `LOAD_CELL_DIAGNOSTIC`.

### Kontrollera probfunktionen med LOAD_CELL_TEST_TAP

Använd `LOAD_CELL_TEST_TAP` för att testa lastcellsproben innan du faktiskt sonderar med den. Kommandot upptäcker knackningar, precis som PROBE, men rör inte Z-axeln. Som standard lyssnar det efter tre knackningar före testets slut. Du har 30 sekunder för varje knackning; om inga upptäcks går kommandot ut.

Om testet misslyckas ska du noggrant kontrollera konfigurationen och `LOAD_CELL_DIAGNOSTIC` efter problem.

Lastcellsprober stöder inte `QUERY_ENDSTOPS` eller `QUERY_PROBE`. Använd `LOAD_CELL_TEST_TAP` för att testa funktionen före sondering.

### Rekommenderad sonderingstemperatur

Vi rekommenderar för närvarande att munstyckstemperaturen hålls under den nivå där filament börjar sippra ut vid nollställning och sondering. 140 °C är en bra utgångspunkt och temperaturen är också tillräckligt låg för att inte märka PEI-byggytor.

Smuts på munstycke och bädd från utsipprande filament är den främsta källan till sonderingsfel med lastcellsproben. Klipper saknar ännu ett universellt sätt att upptäcka knackningar av låg kvalitet orsakade av filamentspill. Den befintliga koden kan bedöma en knackning som giltig trots låg kvalitet. Klassificering av sådana knackningar är ett aktivt forskningsområde.

Klipper saknar också stöd för att flytta en sondpunkt om platsen har smutsats ned av utsipprande filament. Moduler som `quad_gantry_level` sonderar samma koordinater upprepade gånger även om en sondering tidigare misslyckades där.

Med tanke på ovanstående rekommenderas det starkt att inte sondera vid utskriftstemperaturer.

### Skydd mot varmt munstycke

The Voron project has a great macro for protecting your print surface from the hot nozzle. See [Voron Tap's
`activate_gcode`](https://github.com/VoronDesign/Voron-Tap/blob/main/config/tap_klipper_instructions.md)

Det rekommenderas starkt att lägga till något liknande i din konfiguration.

### Rengöring av munstycket

Munstycket ska vara rent före sondering. Det kan göras manuellt före varje utskrift eller automatiseras med en munstycksskrubb. Här är en rekommenderad följd:

1. Vänta tills munstycket har värmts till sonderingstemperatur, till exempel `M109 S140`
1. Nollställ maskinen (`G28`)
1. Skrubba munstycket mot en borste
1. Värm upp bädden till termisk jämvikt
1. Utför sonderingsuppgifter: QGL, bäddnät osv.

### Temperaturkompensation för munstyckets utvidgning

Om du sonderar vid en säker temperatur utvidgas munstycket efter uppvärmning till utskriftstemperatur. Munstycket blir längre och kommer närmare utskriftsytan. Detta kan kompenseras med [[z_thermal_adjust]](Config_Reference.md#z_thermal_adjust). Justeringen fungerar för utskriftstemperaturer från PLA till PC.

#### Beräkna `temp_coeff` för `[z_thermal_adjust]`

Det enklaste sättet är att mäta vid två olika temperaturer, helst den övre och undre gränsen för utskriftstemperaturintervallet, till exempel 180 °C och 290 °C. Kör `PROBE_ACCURACY` vid båda temperaturerna och beräkna sedan skillnaden mellan `average z`.

Justeringsvärdet är ändringen i munstyckslängd dividerad med temperaturändringen, till exempel:

```
temp_coeff = -0.05 / (290 - 180) = -0.00045455
```

Det förväntade resultatet är ett negativt tal. Positiva `temp_coeff`-värden flyttar munstycket närmare bädden och negativa värden flyttar det längre bort. Munstycket behöver normalt flyttas längre bort när det blir längre av värmen.

#### Konfigurera `[z_thermal_adjust]`

Ställ in z_thermal_adjust så att `extruder` används som källa för temperaturdata, till exempel:

```
[z_thermal_adjust]
temp_coeff=-0.00045455
sensor_type: temperature_combined
sensor_list: extruder
combination_method: max
maximum_deviation: 999
min_temp: 0
max_temp: 400
max_z_adjustment: 0.1
```

## Kontinuerliga tareringsfilter för lastceller i verktygshuvudet

Klipper implementerar ett konfigurerbart IIR-filter på MCU:n för kontinuerlig tarering av lastcellen under sondering. Kontinuerlig tarering innebär att nollvärdet följer drift som orsakas av externa faktorer som bowdenslangar och temperaturförändringar. Det är avsett för sensorer i verktygshuvudet och rörliga bäddar som påverkas av många yttre krafter under sondering.

### Installera SciPy

Filterkoden använder biblioteket [SciPy](https://scipy.org/) för att beräkna filterkoefficienterna utifrån värdena i konfigurationen.

Förkompilerade SciPy-versioner finns för Python 3 på 32-bitars Raspberry Pi-system. 32 bitar med Python 3 rekommenderas starkt eftersom installationen blir enklare. Det fungerar med Python 2, men installationen kan ta mer än 30 minuter och kräva ytterligare verktyg.

```bash
~/klippy-env/bin/pip install scipy
```

### Filterarbetsbänk

Filterparametrarna bör väljas utifrån den drift som syns på skrivaren vid normal drift. En Jupyter-anteckningsbok, [filter_workbench.ipynb](../scripts/filter_workbench.ipynb), finns i scripts för detaljerad analys med verkliga insamlade data och FFT:er.

### Filterförslag

För dig som bara försöker få ett filter att fungera följer här några förslag:

* Det enda nödvändiga alternativet är `drift_filter_cutoff_frequency`. Ett försiktigt startvärde är `0.5` Hz. Prusa levererade MK4 med `0.8` Hz och XL med `11.2` Hz, vilket sannolikt är ett säkert intervall att experimentera inom. Höj bara värdet tills normal drift från bowdenslangens kraft elimineras. Ett för högt värde ger långsam utlösning och överdriven kraft genom verktygshuvudet.
* Håll `trigger_force` låg. Standardvärdet är `75` g. Driftfiltret håller det interna gramvärdet nära 0, så en hög utlösningskraft behövs inte.
* Håll `force_safety_limit` på ett försiktigt värde. Standardvärdet är 2 kg och bör skydda verktygshuvudet under experiment. Om gränsen nås kan `drift_filter_cutoff_frequency` vara för hög.

## Förslag för verktygskort med lastcell

Det här avsnittet innehåller förslag för dem som utvecklar verktygshuvudkort med stöd för [load_cell_probe].

### Val av ADC-sensor och råd för kortutveckling

Idealt sett uppfyller en sensor dessa kriterier:

* Minst 24 bitar bred
* Använd SPI-kommunikation
* Har ett stift som kan indikera att ett sampel är klart utan SPI-kommunikation. Det kallas ofta stiftet "data ready" eller "DRDY". Att kontrollera ett stift är mycket snabbare än en SPI-fråga.
* Har en programmerbar förstärkningsinställning på 128 för förstärkaren. Detta bör eliminera behovet av en separat förstärkare.
* Indikerar via SPI om sensorn har återställts. Att upptäcka återställningar undviker tidsfel vid nollställning och brusiga data vid uppstart. Det kan också hjälpa användare att hitta kabel- och jordningsproblem.
* En valbar samplingsfrekvens mellan 350 Hz och 2 kHz. Mycket höga samplingsfrekvenser är inte fördelaktiga i 3D-skrivare eftersom de ger mycket brus vid snabba rörelser. Frekvenser under 250 Hz kräver långsammare sondering och ökar kraften på verktygshuvudet genom längre fördröjning mellan mätningar. En sensor på 500 Hz som rör sig med 5 mm/s har exempelvis samma säkerhetsfaktor som en sensor på 100 Hz som rör sig med endast 1 mm/s.
* Vid konstruktion för tillämpningar under bädden, där flera lastceller ska mätas, använd en krets som kan sampla alla ingångar samtidigt. Multiplexade ADC:er som kräver kanalbyte behöver flera sampel för stabilisering efter varje byte och passar därför inte för sondering.

Att implementera stöd för ett nytt sensorkrets är inte särskilt svårt med Klippers infrastruktur `bulk_sensor` och `load_cell_endstop`.

### Filtrering av 5 V-matning

Det rekommenderas starkt att använda större kondensatorer än ADC-kretstillverkaren anger. ADC-kretsar är normalt avsedda för miljöer med lågt brus, som batteridrivna enheter. Sensortillverkarnas tillämpningsanvisningar förutsätter oftast en tyst matning; betrakta deras kondensatorvärden som minimivärden.

3D-skrivare ger mycket brus på 5 V-bussen, vilket kan förstöra sensorns noggrannhet. Testa sensorn på kortet med ett typiskt 3D-skrivarnätaggregat och aktiva stegmotordrivare innan du väljer storlek på utjämningskondensatorer.

### Jordning och jordplan

Analoga ADC-kretsar innehåller komponenter som är mycket känsliga för brus och ESD. Ett stort jordplan på kortets första lager under kretsen kan hjälpa mot brus. Håll kretsen borta från kraftdelar och DC/DC-omvandlare. Kortet ska ha korrekt jordning tillbaka till likspänningsmatningen.

### Anmärkningar om HX711 och HX717

Sensorn är populär på grund av låg kostnad och god tillgänglighet i leveranskedjan. Den har dock vissa nackdelar:

* HX71x-sensorerna använder bit-bang-kommunikation som belastar MCU:n mycket. En sensor med SPI-kommunikation skulle spara resurser på verktygskortets CPU.
* HX71x saknar ett sätt att kommunicera återställningshändelser till MCU:n. Klipper upptäcker återställningar med en tidsheuristik, men det är inte idealiskt. Återställningar tyder på problem med kablage eller jordning.
* För sonderingsanvändning rekommenderas HX717 starkt på grund av högre samplingsfrekvens, 320 jämfört med 80. Sonderingshastigheten för HX711 bör begränsas till mindre än 2 mm/s.
* Samplingsfrekvensen för HX71x kan inte ställas in i Klippers konfiguration. Om du har sensorns 10 SPS-version, som är vanligt spridd, måste den kopplas om fysiskt för att köras vid 80 SPS.
