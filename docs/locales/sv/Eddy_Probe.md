# Induktiv Eddy-strömsprob

Det här dokumentet beskriver Klippers stöd för induktiva [Eddy-strömsprober](https://en.wikipedia.org/wiki/Eddy_current).

Proberna detekterar bädden genom att mäta den [resonanta frekvensen](https://en.wikipedia.org/wiki/Resonance) hos en spole i sensorn. Ju närmare spolen är en metallbädd, desto högre blir spolens resonanta frekvens. Frekvensmätningarna kan därför användas för att uppskatta avståndet mellan sensor och bädd.

## Sonderingsmetoder

Till skillnad från traditionella bäddprober stöder en Eddy-strömssensor fyra olika sonderingsmetoder: standard, "scan", "rapid_scan" och "tap". Metoderna aktiveras genom att skicka parametern `METHOD=xxx` till sonderingskommandon (till exempel `PROBE METHOD=tap`). Varje metod har de fördelar och nackdelar som beskrivs nedan.

### Standardmetod för sondering

Standardmetoden för sondering fungerar mest som en traditionell bäddprob. Verktygshuvudet sänks mot bädden tills sensorn upptäcker att den är nära bädden. Därefter tas flera sensormätningar i det stoppade läget för att uppskatta avståndet mellan sensor och bädd. Mekanismen aktiveras genom att inte ange parametern `METHOD` i sonderingskommandon (till exempel ett ensamt `PROBE`-kommando).

Fördelar:

* Detta är den mest allmänna sonderingsmetoden. Den ger god precision och god flexibilitet.
* Den kan användas från många startpositioner för verktygshuvudet. Kontrollera att verktygshuvudets XY-position placerar sensorn över metallbädden, men i övrigt kan den exakta starthöjden väljas fritt.

Nackdelar:

* Probresultaten påverkas av termisk drift. Avstånden som proben rapporterar motsvarar avstånd som mättes under den första kalibreringen (med `PROBE_EDDY_CURRENT_CALIBRATE`) och resultatet kan påverkas om sonderingen görs vid en annan temperatur. Förändringar i temperaturen hos bädden, sensorns spole, sensorelektroniken eller metall nära sensorn kan alla påverka resultatet. Effekten är liten (mikrometer), men den godtagbara precisionen för en bäddprob är också liten (återigen mikrometer). För bästa resultat bör kalibreringen och efterföljande sonderingar göras vid en jämn temperatur.

När den bör användas:

Detta är standardmetoden för sondering och rekommenderas för de flesta sonderingsåtgärder. Den rekommenderas särskilt för bäddjusteringsverktyg som `QUAD_GANTRY_LEVEL`, `Z_TILT_ADJUST`, `SCREWS_TILT_CALCULATE`, `DELTA_CALIBRATE` och liknande.

### Sonderingsmetoden "scan"

Sonderingsmetoden "scan" liknar standardmetoden, men proben sänks inte mot bädden. I stället samlar proben sensormätningar vid den aktuella Z-positionen för att uppskatta avståndet mellan sensor och bädd. Den är användbar för `BED_MESH_CALIBRATE`, eftersom hela bädden kan avsökas med enbart horisontella rörelser.

Fördelar:

* Z-positionen ändras inte under sonderingen, och risken är mindre att glapp i Z-stegmotorn (och liknande) påverkar mätningarna. Detta kan vara särskilt användbart när endast relativa Z-höjdmätningar önskas (till exempel med `zero_reference_position` tillsammans med `BED_MESH_CALIBRATE`).
* En fullständig bäddavsökning kan gå snabbare än standardmetoden.

Nackdelar:

* Bädden måste vara nästan parallell med skrivarens XY-skenor och det får inte finnas några stora avvikelser i bäddhöjden. För godtagbara resultat måste bäddavsökningen köras med lågt `HORIZONTAL_MOVE_Z`, så att sensorn förblir nära bädden under hela avsökningen. (Ju mindre avstånd, desto noggrannare resultat.) I praktiken får avståndet mellan munstycke och bädd inte vara mer än ungefär en millimeter. Vid dessa avstånd kan märkbara bäddavvikelser orsaka en kollision mellan munstycke och bädd under horisontell rörelse.
* Metoden "scan" har samma nackdelar med termisk drift som beskrivs för standardmetoden. För bästa resultat bör kalibreringen och efterföljande sonderingar göras vid en jämn temperatur.

När den bör användas:

Metoden "scan" används vanligtvis vid kalibrering av bäddnät. Kontrollera alltid att bädden är parallell med skrivarens XY-skenor före en bäddavsökning. Beroende på skrivarens maskinvara kan ett automatiserat verktyg som använder standardmetoden kontrollera parallelliteten, till exempel: `QUAD_GANTRY_LEVEL RETRY_TOLERANCE=0.250`, `Z_TILT_ADJUST RETRY_TOLERANCE=0.250` eller `SCREWS_TILT_CALCULATION MAX_TOLERANCE=0.250`.

Ett bäddnät kan sedan köras med exempelvis `BED_MESH_CALIBRATE METHOD=scan HORIZONTAL_MOVE_Z=1`.

### Sonderingsmetoden "rapid_scan"

Sonderingsmetoden "rapid_scan" liknar metoden "scan", men proben stannar inte vid varje mätpunkt. I stället används mätningar under den horisontella rörelsen nära varje sonderingspunkt för att uppskatta avståndet mellan sensor och bädd.

Fördelar:

* En fullständig bäddavsökning med "rapid_scan" kan vara något snabbare än metoden "scan".
* I övrigt har den samma fördelar som metoden "scan".

Nackdelar:

* Resultaten från "rapid_scan" kan vara mindre exakta än från metoden "scan".
* Samma nackdelar som prober med "scan" (bädden måste vara parallell och termisk drift förekommer).

När den bör användas:

"rapid_scan" kan vara användbar vid en stor, detaljerad bäddnätsavsökning för diagnostik. I den situationen kan den kortare avsökningstiden väga upp den möjliga försämringen av noggrannheten.

För normal utskrift föredras i allmänhet ett bäddnät med den vanliga metoden "scan", för bästa noggrannhet och kortast extra sonderingstid.

När bädden har kontrollerats vara parallell med XY-skenorna kan en snabb bäddnätsavsökning köras med exempelvis `BED_MESH_CALIBRATE METHOD=rapid_scan HORIZONTAL_MOVE_Z=1`.

### Sonderingsmetoden "tap"

Vid "tap"-sondering sänks verktygshuvudet tills munstycket får kontakt med bädden. Munstycket lyfts sedan från bädden och sensormätningar under lyftrörelsen analyseras för att bestämma den punkt där munstycket lämnar kontakten med bädden.

Fördelar:

* Probresultaten bestäms av den faktiska kontaktpunkten mellan munstycke och bädd, i stället för indirekta mätningar mellan sensor och bädd. Det kan vara särskilt användbart om munstycken byts ofta, eftersom resultatet då tar hänsyn till det aktuella munstyckets geometri.
* En "tap"-prob har inte problemen med termisk drift som hör till de andra sonderingsmetoderna. Huvudkalibreringen används inte vid tap-sondering, och temperaturer behöver därför inte följas mellan första kalibreringen och efterföljande sondering.
* Axelns "twist"-fel är mindre problematiska vid tap-sondering, eftersom ingen XY-förskjutning för proben behöver kompenseras. Kontrollera ändå att verktygshuvudets XY-position placerar både munstycket och sensorn över bädden före tap-sondering.

Nackdelar:

* Kontrollera att både munstycket och bädden är rena före tap-sondering. Filament på munstycket eller smuts på bädden kan kraftigt snedvrida probresultaten.
* Kontrollera att munstycket är ungefär 3–20 mm från bädden innan varje "tap"-sonderingsförsök. Om munstycket börjar för nära bädden kan kontakt missas, vilket kan orsaka en okontrollerad krasch mellan munstycke och bädd. Om munstycket börjar mycket långt från bädden blir sensormätningarna inte exakta och försöket kan misslyckas eller ge felaktigt resultat.
* Skrivarens maskinvara måste låta munstycket få full kontakt med bädden. Det får inte finnas ändlägesbrytare eller vagnstopp som får kontakt innan munstycket når bädden.
* Kontrollera att munstyckets temperatur inte är för hög för bädden. En för hög temperatur kan till exempel smälta PEI-beläggningen på vissa bäddar.

När den bör användas:

En "tap"-prob används ofta som ett steg i en flerstegsprocess för hemställning/nivellering, för att ta hänsyn till munstyckets aktuella geometri och minska fel från termisk drift. En makro kan exempelvis hemställa, köra `Z_TILT_ADJUST` med standardsondering, värma skrivaren till en mellanliggande temperatur, rengöra munstycket genom att upprepade gånger torka av det mot en borste, utföra en "tap"-sondering, använda `SET_KINEMATIC_POSITION` med resultatet, köra `BED_MESH_CALIBRATE` med `zero_reference_position` och därefter värma skrivaren till normal utskriftstemperatur. De faktiska stegen beror i hög grad på den specifika skrivarens maskinvara.

En "tap"-sondering kan startas med exempelvis `PROBE METHOD=tap`.

## Konfiguration

För att konfigurera en Eddy-strömsprob börjar du med att ange ett [konfigurationsavsnitt för probe_eddy_current](Config_Reference.md#probe_eddy_current) i filen printer.cfg. Vi rekommenderar `descend_z` satt till 0,5 mm. Sensorn behöver vanligtvis `x_offset` och `y_offset`. Om värdena inte är kända bör de uppskattas under den första kalibreringen.

Starta sedan om skrivaren och fortsätt med följande kalibreringssteg.

### Kalibrering av drivström

Det första steget i kalibreringen är att fastställa lämpligt DRIVE_CURRENT för sensorn. Hemställ skrivaren och flytta verktygshuvudet så att sensorn är nära bäddens mitt och ungefär 20 mm ovanför bädden. Kör sedan kommandot `LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>`. Om konfigurationsavsnittet till exempel heter `[probe_eddy_current my_eddy_probe]` kör du `LDC_CALIBRATE_DRIVE_CURRENT CHIP=my_eddy_probe`. Kommandot bör bli klart inom några sekunder. Kör därefter `SAVE_CONFIG` för att spara resultatet i printer.cfg och starta om.

### Kalibrering av Z-höjder

Det andra kalibreringssteget är att koppla ihop sensoravläsningarna med motsvarande Z-höjder. Hemställ skrivaren och flytta verktygshuvudet så att munstycket är nära bäddens mitt. Kör sedan kommandot `PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe`. När verktyget startar följer du stegen i ["papperstestet"](Bed_Level.md#the-paper-test) för att bestämma det faktiska avståndet mellan munstycke och bädd på platsen. När stegen är klara kan positionen godtas med `ACCEPT`. Verktyget flyttar sedan verktygshuvudet så att sensorn hamnar ovanför punkten där munstycket stod och kör en serie rörelser för att koppla sensorn till Z-positioner. Detta tar några minuter. När verktyget är klart skrivs data om sensorns prestanda ut:

```
probe_eddy_current: noise 0.000642mm, MAD_Hz=11.314 in 2525 queries
Total frequency range: 45000.012 Hz
z: 0.250 # noise 0.000200mm, MAD_Hz=11.000
z: 0.530 # noise 0.000300mm, MAD_Hz=12.000
z: 1.010 # noise 0.000400mm, MAD_Hz=14.000
z: 2.010 # noise 0.000600mm, MAD_Hz=12.000
z: 3.010 # noise 0.000700mm, MAD_Hz=9.000
```

Kör `SAVE_CONFIG` för att spara resultatet i printer.cfg och starta om.

Efter den första kalibreringen är det lämpligt att kontrollera att `x_offset` och `y_offset` är korrekta. Följ anvisningarna för att [kalibrera probens X- och Y-förskjutningar](Probe_Calibrate.md#calibrating-probe-x-and-y-offsets). Om `x_offset` eller `y_offset` ändras måste du köra kommandot `PROBE_EDDY_CURRENT_CALIBRATE` (enligt beskrivningen ovan) efter ändringen.

Observera att Eddy-strömssensorer är känsliga för "termisk drift". Temperaturförändringar kan alltså ändra den rapporterade Z-höjden. Ändringar i temperaturen på antingen bäddytan eller sensorns maskinvara kan ändra resultatet. För bästa resultat ska kalibreringen här och den efterföljande sonderingen som använder kalibreringen göras vid samma temperatur.

### Tap-kalibrering

För att använda "tap"-sondering måste vissa parametrar konfigureras.

Det måste gå att kommendera verktygshuvudet under bäddens nominella plan. Det görs normalt genom att ange `position_min: -1` i konfigurationsavsnittet `[stepper_z]` i printer.cfg (eller en liknande inställning, exempelvis `minimum_z_position`, beroende på kinematiken). Detta krävs för att munstycket ska kunna kommenderas att få fast kontakt med bädden och för att munstycket ska nå bädden innan rörelsen annars skulle börja bromsa.

Parametern `tap_threshold` måste också konfigureras. Den avgör när nedåtgående rörelse av verktygshuvudet under en "tap"-sondering ska stoppas. Ett för stort värde kan göra att kontakt mellan munstycke och bädd inte upptäcks, vilket kan få munstycket att okontrollerat krascha in i bädden. Ett för litet värde kan i stället stoppa försöket innan munstycket rör bädden och ge sonderingsfel eller felaktiga resultat.

Kommandot `PROBE_EDDY_CURRENT_TAP_CALIBRATE` kan användas för att konfigurera ett lämpligt värde för `tap_threshold`. Verktyget kan köras efter huvudkalibreringen `PROBE_EDDY_CURRENT_CALIBRATE`. Följ dessa steg för att kalibrera `tap_threshold`:

1. Kontrollera att både munstycket och bädden är rena. Aktivera och hemställ skrivaren, flytta verktygshuvudet till en position nära bäddens mitt och kontrollera att munstycket är 3–10 millimeter från bädden.
1. Nästa steg innebär att munstycket kommenderas att få kontakt med bädden. Processen innebär alltid viss risk, så var beredd att göra ett nödstopp (`M112`) om nedstigningen inte stannar efter kontakt med bädden. Kör när du är redo: `PROBE_EDDY_CURRENT_TAP_CALIBRATE TAP=guess`. Kommandot analyserar data från huvudkalibreringen för att göra en första grov uppskattning av `tap_threshold` och utför sedan motsvarande "tap"-sondering. Helst sänks proben tills den träffar bädden, lyfts från bädden och rapporterar ett giltigt sonderingsresultat. Se styckena i slutet av avsnittet om felsökning om detta inte lyckas. Om försöket lyckas fortsätter du till nästa steg.
1. Nästa steg är att köra ytterligare en tap-sondering med ett "förfinat" tröskelvärde. Verktyget använder information från en tidigare lyckad tap-sondering för att fastställa det förbättrade värdet. Kontrollera att munstycket är nära bäddens mitt och 3–10 mm ovanför bädden, var beredd att göra ett nödstopp och kör sedan `PROBE_EDDY_CURRENT_TAP_CALIBRATE TAP=refine`. Även detta kommando bör lyckas; se styckena i slutet av avsnittet om felsökning om det inte gör det. Fortsätt annars till nästa steg.
1. Om sonderingen med förfinat tröskelvärde lyckas ska nästa test kontrollera att det är stabilt vid flera sonderingsförsök. Kontrollera att munstycket är nära bäddens mitt och 3–10 mm ovanför bädden, var beredd att göra ett nödstopp och kör sedan `PROBE_EDDY_CURRENT_TAP_CALIBRATE TAP=verify`. Kommandot sonderar bädden fem gånger i följd. Kommandot bör lyckas; se styckena i slutet av avsnittet om felsökning om det inte gör det. Fortsätt annars till nästa steg.
1. Om samtliga steg ovan lyckas kan `SAVE_CONFIG` köras för att spara parametern "tap_threshold" i printer.cfg. Kalibreringen bör nu vara klar.

Om något av stegen ovan inte lyckades kan det vara nödvändigt att felsöka och fastställa ett lämpligt `tap_threshold` manuellt. Det görs genom att köra kommandon av formen `PROBE METHOD=tap TAP_THRESHOLD=<value>`, där `<value>` är ett tröskelvärde som ska testas.

Om ett sonderingsförsök i allmänhet stannar innan kontakt med bädden betyder det att angivna `TAP_THRESHOLD` är för låg. Öka den med ungefär 10 % och försök igen. Om försöket däremot inte stannar efter kontakt med bädden är `TAP_THRESHOLD` för hög. Överväg att halvera värdet.

Om det automatiska kalibreringsverktyget misslyckades i det första steget "guess" kan det `tap_threshold`-värde som verktyget rapporterar användas som startpunkt för manuella försök. När ett sonderingsförsök har lyckats kan huvudstegen ovan återupptas vid steget "refine".

### Utföra första kalibrering vid hemställning med prob

Det går att använda en Eddy-strömsprob för att hemställa en Z-axel. För att använda detta anger du `endstop_pin` i konfigurationsavsnittet `[stepper_z]` som `probe:z_virtual_endstop`.

För att hemställa med en Eddy-prob måste proben först kalibreras med kommandot `PROBE_EDDY_CURRENT_CALIBRATE`. Det kommandot kräver dock att skrivaren först har hemställts.

Följande steg kan användas för att undvika detta cirkelberoende vid den första kalibreringen:

1. Definiera ett konfigurationsavsnitt `[probe_eddy_current]` i printer.cfg enligt [konfigurationsavsnittet](#configuration).
1. Kontrollera att ett avsnitt för [tvingad rörelse](Config_Reference.md#force_move) är definierat och att alternativet `enable_force_move` finns och är satt till true.
1. Justera manuellt vagnarna så att verktygshuvudet är nära bäddens mitt och ungefär 20 mm från bädden. Kör kommandona `LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` och `SAVE_CONFIG` enligt [avsnittet om kalibrering av drivström](#calibrating-drive-current).
1. Flytta manuellt verktygshuvudet till ungefär 20 mm från bädden och hemställ skrivarens X- och Y-axel. Det görs normalt med `G28 X0 Y0`. Kommendera sedan verktygshuvudets X- och Y-position så att det hamnar ungefär över bäddens mitt, vanligen med ett kommando som `G1 X50 Y50` (med XY-värden som passar skrivaren).
1. Justera manuellt bädden så att den är i huvudsak plan i förhållande till verktygshuvudets XY-vagnar (vid behov). Justera Z-vagnen manuellt så att munstycket är ungefär 20 mm från bädden och kör `SET_STEPPER_ENABLE STEPPER=stepper_z`. Kör sedan `SET_KINEMATIC_POSITION Z=25`, följt av `PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe`. Viktigt: efter dessa kommandon kan skrivaren röra sig i Z-led, men den känner inte till den faktiska Z-positionen. Undvik rörelsekommandon som kan få verktygshuvudet att sänkas ned i bädden.
1. Slutför Eddy-probkalibreringen enligt [avsnittet om kalibrering av Z-höjder](#calibrating-z-heights). Kör `SAVE_CONFIG` när den är klar.

Dessa steg behövs endast för den första konfigurationen. Om `PROBE_EDDY_CURRENT_CALIBRATE` behöver köras på nytt i framtiden bör den vanliga mekanismen fungera när den första konfigurationen finns på plats.

## Kalibrering av termisk drift

Precis som alla induktiva prober påverkas Eddy-strömsprober av betydande termisk drift. Om Eddy-proben har en temperatursensor på spolen går det att konfigurera en `[temperature_probe]` som rapporterar spolens temperatur och aktiverar programvarukompensation för drift. För att koppla en temperaturprob till en Eddy-strömsprob måste avsnittet `[temperature_probe]` ha samma namn som avsnittet `[probe_eddy_current]`. Till exempel:

```
[probe_eddy_current my_probe]
# eddy probe configuration...

[temperature_probe my_probe]
# temperature probe configuration...
```

Mer information om hur `temperature_probe` konfigureras finns i [konfigurationsreferensen](Config_Reference.md#temperature_probe). Det rekommenderas att konfigurera alternativen `calibration_position`, `calibration_extruder_temp`, `extruder_heating_z` och `calibration_bed_temp`, eftersom detta automatiserar några av stegen nedan. Om skrivaren som ska kalibreras är inbyggd rekommenderas starkt att ange `max_validation_temp` till ett värde mellan 100 och 120.

Tillverkare av Eddy-prober kan erbjuda en standardkalibrering för drift som kan läggas till manuellt i alternativet `drift_calibration` i avsnittet `[probe_eddy_current]`. Om de inte gör det, eller om standardkalibreringen inte fungerar bra i systemet, erbjuder modulen `temperature_probe` en manuell kalibreringsprocedur via G-code-kommandot `TEMPERATURE_PROBE_CALIBRATE`.

Innan kalibreringen görs bör användaren känna till den högsta temperatur som temperaturprobens spole kan uppnå. Denna temperatur ska användas för att ange parametern `TARGET` i kommandot `TEMPERATURE_PROBE_CALIBRATE`. Målet är att kalibrera över ett så brett temperaturintervall som möjligt; börja därför med kall skrivare och avsluta med spolen vid högsta möjliga temperatur.

När en `[temperature_probe]` har konfigurerats kan följande steg användas för att kalibrera termisk drift:

- Proben måste kalibreras med `PROBE_EDDY_CURRENT_CALIBRATE` när en `[temperature_probe]` är konfigurerad och kopplad. Då registreras temperaturen under kalibreringen, vilket krävs för kompensation av termisk drift.
- Kontrollera att munstycket är fritt från smuts och filament.
- Bädden, munstycket och probspolen ska vara kalla före kalibreringen.
- Följande steg krävs om alternativen `calibration_position`, `calibration_extruder_temp` och `extruder_heating_z` i `[temperature_probe]` **INTE** är konfigurerade:
   - Flytta verktygshuvudet till bäddens mitt. Z ska vara minst 30 mm ovanför bädden.
   - Värm extrudern till en temperatur över bäddens högsta säkra temperatur. 150–170 °C bör räcka för de flesta konfigurationer. Extrudern värms för att undvika att munstycket expanderar under kalibreringen.
   - När extruderns temperatur har stabiliserats flyttar du ned Z-axeln till ungefär 1 mm ovanför bädden.
- Starta driftkalibreringen. Om proben heter `my_probe` och den högsta uppnåeliga probtemperaturen är 80 °C är lämpligt G-code-kommando `TEMPERATURE_PROBE_CALIBRATE PROBE=my_probe TARGET=80`. Om den är konfigurerad flyttas verktygshuvudet till X,Y-koordinaten som anges av `calibration_position` och till Z-värdet som anges av `extruder_heating_z`. Efter att extrudern har värmts till den angivna temperaturen flyttas verktygshuvudet till Z-värdet som anges av `calibration_position`.
- Proceduren begär en manuell sondering. Utför den manuella sonderingen med papperstestet och `ACCEPT`. Kalibreringsproceduren tar den första uppsättningen prover med proben och parkerar sedan proben i uppvärmningspositionen.
- Om `calibration_bed_temp` **INTE** är konfigurerad ska bäddvärmen slås på till högsta säkra temperatur. Annars utförs steget automatiskt.
- Som standard begär kalibreringsproceduren en manuell sondering för varje 2 °C mellan prover tills `TARGET` nås. Temperaturskillnaden mellan prover kan anpassas med parametern `STEP` i `TEMPERATURE_PROBE_CALIBRATE`. Var försiktig med ett eget `STEP`-värde: ett för högt värde kan ge för få prover och därmed en dålig kalibrering.
- Följande ytterligare G-code-kommandon kan användas under driftkalibreringen:
   - `TEMPERATURE_PROBE_NEXT` kan användas för att tvinga fram ett nytt prov innan stegskillnaden har nåtts.
   - `TEMPERATURE_PROBE_COMPLETE` kan användas för att slutföra kalibreringen innan `TARGET` har nåtts.
   - `ABORT` kan användas för att avbryta kalibreringen och förkasta resultatet.
- När kalibreringen är klar använder du `SAVE_CONFIG` för att spara driftkalibreringen.

Som framgår är kalibreringsprocessen ovan svårare och mer tidskrävande än de flesta andra procedurer. Den kan kräva övning och flera försök för att uppnå optimal kalibrering.

## Felbeskrivning

Möjliga hemställningsfel och åtgärder:

- Sensorfel
   - Kontrollera loggarna för detaljerat fel
- Eddy I2C STATUS/DATA-fel.
   - Kontrollera lösa kablar.
   - Prova programvaru-I2C/minska I2C-hastigheten
- Ogiltiga läsdata
   - Samma som för I2C

Möjliga sensorfel och åtgärder:

- Frekvens utanför giltigt hårt intervall
   - Kontrollera frekvenskonfigurationen
   - Maskinvarufel
- Frekvens utanför giltigt mjukt intervall
   - Kontrollera frekvenskonfigurationen
- Tidsgräns för konverteringsvakthund
   - Maskinvarufel

Varningsmeddelanden om låg/hög amplitud kan betyda:

- Sensorn är nära bädden
- Sensorn är långt från bädden
- Högre temperatur än vid den aktuella kalibreringen
- Kondensator saknas

På vissa sensorer går det inte att helt undvika amplitudvarningsindikatorn.

Du kan försöka göra om kalibreringen `LDC_CALIBRATE_DRIVE_CURRENT` vid drifttemperatur eller öka `reg_drive_current` med 1–2 från det kalibrerade värdet.

I allmänhet fungerar den som en motorvarningslampa. Den kan indikera ett problem.
