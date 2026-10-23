# TMC-drivrutiner

Detta dokument innehåller information om hur Trinamic-stegmotordrivrutiner används i SPI-/UART-läge med Klipper.

Klipper kan även använda Trinamic-drivrutiner i deras ”fristående läge”. När drivrutinerna är i detta läge krävs dock ingen särskild Klipper-konfiguration och de avancerade Klipper-funktioner som beskrivs i dokumentet är inte tillgängliga.

Utöver detta dokument bör du läsa [konfigurationsreferensen för TMC-drivrutiner](Config_Reference.md#tmc-stepper-driver-configuration).

## Trimning av motorström

Högre drivström ger bättre positionsnoggrannhet och vridmoment. Högre ström ökar dock även värmen som alstras av stegmotorn och stegmotordrivern. Om stegmotordrivern blir för varm stänger den av sig själv och Klipper rapporterar ett fel. Om stegmotorn blir för varm förlorar den vridmoment och positionsnoggrannhet. Om den blir mycket varm kan den också smälta plastdelar som sitter på eller nära den

Som allmänt trimningstips bör högre strömvärden föredras så länge stegmotorn inte blir för varm och stegmotordrivern inte rapporterar varningar eller fel. Det är i allmänhet okej att stegmotorn känns varm, men den ska inte bli så varm att det gör ont att röra vid den.

## Undvik helst att ange hold_current

Om `hold_current` konfigureras kan TMC-drivrutinen minska strömmen till stegmotorn när den upptäcker att motorn inte rör sig. En ändring av motorströmmen kan dock i sig orsaka en motorrörelse. Det kan inträffa på grund av ”kuggkrafter” inuti stegmotorn, där rotorns permanentmagnet dras mot statorns järntänder, eller på grund av yttre krafter på axelvagnen.

De flesta stegmotorer får ingen betydande nytta av minskad ström under vanliga utskrifter, eftersom få utskriftsrörelser lämnar en stegmotor stilla tillräckligt länge för att funktionen `hold_current` ska aktiveras. Det är också osannolikt att man vill riskera diskreta utskriftsartefakter i de få rörelser som lämnar en stegmotor stilla tillräckligt länge.

Om motorernas ström ska minskas under skrivarens startrutiner kan du överväga att köra kommandon av typen [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) i ett [START_PRINT-makro](Slicers.md#klipper-gcode_macro) för att justera strömmen före och efter vanliga utskriftsrörelser.

Vissa skrivare med separata Z-motorer som är stilla under vanliga utskriftsrörelser, utan bed_mesh, bed_tilt, Z skew_correction, ”vasläge” och så vidare, kan få svalare Z-motorer med `hold_current`. Om detta används måste den här typen av oavsiktlig Z-axelrörelse beaktas vid bäddnivellering, bäddsondering, sondkalibrering och liknande. `driver_TPOWERDOWN` och `driver_IHOLDDELAY` ska också kalibreras efter detta. Om du är osäker ska `hold_current` inte anges.

## Ställa in läget ”spreadCycle” respektive ”stealthChop”

Som standard använder Klipper läget ”spreadCycle” för TMC-drivrutiner. Om drivrutinen har stöd för ”stealthChop” kan det aktiveras genom att lägga till `stealthchop_threshold: 999999` i TMC-konfigurationsavsnittet.

I allmänhet ger läget spreadCycle större vridmoment och bättre positionsnoggrannhet än läget stealthChop. Läget stealthChop kan dock ge avsevärt lägre hörbart ljud på vissa skrivare.

Tester som jämför lägena har visat en ökad ”positionsfördröjning” på ungefär 75 % av ett helt steg under rörelser med konstant hastighet vid läget stealthChop. På en skrivare med 40 mm rotation_distance och 200 steps_per_rotation ökade till exempel positionsavvikelsen vid rörelser med konstant hastighet med ungefär 0,150 mm. Denna ”fördröjning innan den begärda positionen nås” behöver dock inte ge ett betydande utskriftsfel, och det tystare beteendet hos stealthChop kan vara att föredra.

Vi rekommenderar att alltid använda antingen ”spreadCycle”, genom att inte ange `stealthchop_threshold`, eller ”stealthChop”, genom att ange `stealthchop_threshold` till 999999. Drivrutinerna ger tyvärr ofta dåliga och svårtolkade resultat om läget växlar medan motorns hastighet inte är noll.

Observera att konfigurationsalternativet `stealthchop_threshold` inte påverkar sensorlös referenskörning, eftersom Klipper automatiskt växlar TMC-drivrutinen till ett lämpligt läge under sensorlösa referenskörningar.

## TMC-inställningen interpolate ger en liten positionsavvikelse

TMC-drivrutinens inställning `interpolate` kan minska ljudet från skrivarens rörelser, men medför ett litet systematiskt positionsfel. Felet beror på drivrutinens fördröjning när den utför de ”steg” som Klipper skickar. Vid rörelser med konstant hastighet ger fördröjningen ett positionsfel på nära en halv konfigurerad mikrostegring, närmare bestämt en halv mikrostegrings sträcka minus en 512-del av ett helt stegs sträcka. På en axel med 40 mm rotation_distance, 200 steps_per_rotation och 16 microsteps är det systematiska felet vid rörelser med konstant hastighet till exempel ungefär 0,006 mm.

För bästa positionsnoggrannhet bör du överväga läget spreadCycle och inaktivera interpolering, med `interpolate: False` i TMC-drivrutinens konfiguration. I den konfigurationen kan inställningen `microstep` höjas för att minska ljudet från stegmotorns rörelser. Vanligen ger `64` eller `128` mikrostegringar ungefär samma ljudnivå som interpolering, men utan att införa ett systematiskt positionsfel.

Vid läget stealthChop är interpoleringens positionsfel litet jämfört med positionsfelet som stealthChop medför. Det anses därför inte meningsfullt att trimma interpolering i läget stealthChop, utan interpolering kan behållas i sitt standardläge.

## Sensorlös referenskörning

Sensorlös referenskörning gör det möjligt att referensköra en axel utan en fysisk ändstoppsbrytare. I stället flyttas vagnens axel mot den mekaniska gränsen så att stegmotorn förlorar steg. Stegmotordrivrutinen känner av stegförlusten och signalerar den till den styrande MCU:n (Klipper) genom att växla ett stift. Informationen kan användas av Klipper som ändstopp för axeln.

Guiden beskriver hur sensorlös referenskörning ställs in för den kartesiska skrivarens X-axel. Den fungerar på samma sätt för alla andra axlar som kräver ett ändstopp. Konfigurera och justera en axel i taget.

### Begränsningar

Kontrollera att de mekaniska komponenterna tål belastningen när vagnen upprepade gånger kör in i axelns gräns. Särskilt kulskruvar kan generera mycket kraft. Det är kanske inte lämpligt att referensköra en Z-axel genom att köra munstycket mot utskriftsytan. Bäst resultat fås om axelvagnen får fast kontakt med axelns gräns.

Sensorlös referenskörning kanske inte heller är tillräckligt noggrann för skrivaren. Referenskörning av X- och Y-axlar på en kartesisk maskin kan fungera väl, men Z-axeln blir vanligtvis inte tillräckligt exakt och kan ge inkonsekvent höjd för första lagret. Det rekommenderas inte att referensköra en deltaskrivare sensorlöst på grund av bristande noggrannhet.

Stegmotordrivrutinens stallavkänning beror dessutom på motorns mekaniska belastning, motorströmmen och motortemperaturen (spolresistansen).

Sensorlös referenskörning fungerar bäst vid medelhöga motorhastigheter. Vid mycket låga hastigheter (under 10 varv/min) genererar motorn inte tillräcklig mot-EMK och TMC:n kan inte pålitligt upptäcka motorstopp. Vid mycket höga hastigheter närmar sig motorns mot-EMK motorns matningsspänning, och TMC:n kan då inte längre upptäcka stopp. Läs databladet för din specifika TMC. Där finns ytterligare information om begränsningarna.

### Förutsättningar

Några förutsättningar krävs för att använda sensorlös referenskörning:

1. En TMC-stegmotordrivrutin med stöd för stallGuard, tmc2130, tmc2209, tmc2660 eller tmc5160.
1. TMC-drivrutinens SPI-/UART-gränssnitt är anslutet till mikrokontrollern (fristående läge fungerar inte).
1. Lämpligt ”DIAG”- eller ”SG_TST”-stift på TMC-drivrutinen är anslutet till mikrokontrollern.
1. Stegen i dokumentet [konfigurationskontroller](Config_checks.md) måste köras för att bekräfta att stegmotorerna är konfigurerade och fungerar korrekt.

### Justering

Proceduren som beskrivs här har sex huvudsteg:

1. Välj en referenskörningshastighet.
1. Konfigurera filen `printer.cfg` för att aktivera sensorlös referenskörning.
1. Hitta den stallguard-inställning med högst känslighet som referenskör korrekt.
1. Hitta den stallguard-inställning med lägst känslighet som referenskör korrekt med en enda kontakt.
1. Uppdatera `printer.cfg` med önskad stallguard-inställning.
1. Skapa eller uppdatera makron i `printer.cfg` för konsekvent referenskörning.

#### Välj referenskörningshastighet

Referenskörningshastigheten är ett viktigt val vid sensorlös referenskörning. En långsam referenskörningshastighet är önskvärd så att vagnen inte utövar alltför stor kraft på ramen när den når rälsens ände. TMC-drivrutinerna kan dock inte pålitligt upptäcka ett stopp vid mycket låga hastigheter.

En bra utgångspunkt är att stegmotorn gör ett helt varv varannan sekund. För många axlar blir detta `rotation_distance` delat med två. Exempel:

```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### Konfigurera printer.cfg för sensorlös referenskörning

Inställningen `homing_retract_dist` måste sättas till noll i konfigurationsavsnittet `stepper_x` för att inaktivera den andra referenskörningen. Det andra referenskörningsförsöket tillför inget vid sensorlös referenskörning, fungerar inte tillförlitligt och förvirrar justeringsprocessen.

Kontrollera att inställningen `hold_current` inte anges i konfigurationsavsnittet för TMC-drivrutinen. (Om hold_current anges stannar motorn efter kontakt medan vagnen pressas mot rälsens ände. Minskad ström i detta läge kan få vagnen att röra sig, vilket ger dålig prestanda och förvirrar justeringsprocessen.)

Det är nödvändigt att konfigurera stiften för sensorlös referenskörning och initiala ”stallguard”-inställningar. En exempelkonfiguration av tmc2209 för en X-axel kan se ut så här:

```
[tmc2209 stepper_x]
diag_pin: ^PA1      # Set to MCU pin connected to TMC DIAG pin
driver_SGTHRS: 255  # 255 is most sensitive value, 0 is least sensitive
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

En exempelkonfiguration av tmc2130 eller tmc5160 kan se ut så här:

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # Pin connected to TMC DIAG1 pin (or use diag0_pin / DIAG0 pin)
driver_SGT: -64  # -64 is most sensitive value, 63 is least sensitive
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

En exempelkonfiguration av tmc2660 kan se ut så här:

```
[tmc2660 stepper_x]
driver_SGT: -64     # -64 is most sensitive value, 63 is least sensitive
...

[stepper_x]
endstop_pin: ^PA1   # Pin connected to TMC SG_TST pin
homing_retract_dist: 0
...
```

Exemplen ovan visar bara inställningar som är specifika för sensorlös referenskörning. Se [konfigurationsreferensen](Config_Reference.md#tmc-stepper-driver-configuration) för alla tillgängliga alternativ.

#### Hitta högsta känslighet som referenskör korrekt

Placera vagnen nära rälsens mitt. Använd kommandot SET_TMC_FIELD för att ange högsta känslighet. För tmc2209:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

För tmc2130, tmc5160 och tmc2660:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

Kör sedan kommandot `G28 X0` och kontrollera att axeln inte rör sig alls eller snabbt slutar röra sig. Om axeln inte stannar kör du `M112` för att stoppa skrivaren. Något är då fel med kabeldragningen eller konfigurationen för diag/sg_tst-stiftet och måste rättas innan du fortsätter.

Minska sedan fortlöpande känsligheten för inställningen `VALUE` och kör kommandona `SET_TMC_FIELD` och `G28 X0` igen för att hitta den högsta känslighet som gör att vagnen kan köra hela vägen till ändstoppet och stanna. (För tmc2209-drivrutiner innebär det att SGTHRS minskas; för andra drivrutiner ökas sgt.) Börja varje försök med vagnen nära rälsens mitt (kör vid behov `M84` och flytta sedan vagnen manuellt till mitten). Det ska vara möjligt att hitta den högsta känslighet som referenskör tillförlitligt (inställningar med högre känslighet ger liten eller ingen rörelse). Anteckna värdet som *maximum_sensitivity*. (Om minsta möjliga känslighet, SGTHRS=0 eller sgt=63, nås utan någon vagnrörelse är något fel med DIAG-/SG_TST-stiftets kabeldragning eller konfiguration. Det måste rättas innan du fortsätter.)

När maximum_sensitivity söks kan det vara praktiskt att hoppa mellan olika VALUE-inställningar för att halvera sökrymden för VALUE-parametern. Om du gör det ska du vara beredd att köra kommandot `M112` för att stoppa skrivaren, eftersom en inställning med mycket låg känslighet kan få axeln att upprepade gånger ”slå” i rälsens ände.

Vänta några sekunder mellan varje referenskörningsförsök. När TMC-drivrutinen har upptäckt ett stopp kan det ta en stund innan den rensar sin interna indikator och kan upptäcka nästa stopp.

Om kommandot `G28 X0` under dessa justeringstester inte flyttar hela vägen till axelns gräns ska du vara försiktig med att köra vanliga rörelsekommandon (t.ex. `G1`). Klipper har då inte korrekt information om vagnens position, och ett rörelsekommando kan ge oönskade och förvirrande resultat.

#### Hitta lägsta känslighet som referenskör med en kontakt

När referenskörning görs med det funna värdet *maximum_sensitivity* ska axeln röra sig till rälsens ände och stanna med en ”enda kontakt”, utan klickande eller slagande ljud. (Om det hörs slagande eller klickande ljud vid maximum_sensitivity kan homing_speed vara för låg, drivrutinsströmmen för låg eller sensorlös referenskörning vara olämplig för axeln.)

Nästa steg är att åter flytta vagnen nära rälsens mitt, minska känsligheten och köra `SET_TMC_FIELD` och `G28 X0`. Målet är nu att hitta den lägsta känslighet som fortfarande gör att vagnen referenskör korrekt med en ”enda kontakt”, utan att slå eller klicka vid kontakt med rälsens ände. Anteckna värdet som *minimum_sensitivity*.

#### Uppdatera printer.cfg med känslighetsvärde

När *maximum_sensitivity* och *minimum_sensitivity* har hittats använder du en kalkylator för att få den rekommenderade känsligheten: *minimum_sensitivity + (maximum_sensitivity - minimum_sensitivity)/3*. Den rekommenderade känsligheten ska ligga mellan minimi- och maximivärdet, men något närmare minimivärdet. Avrunda slutvärdet till närmaste heltal.

För tmc2209 anger du detta som `driver_SGTHRS` i konfigurationen. För övriga TMC-drivrutiner använder du `driver_SGT`.

Om intervallet mellan *maximum_sensitivity* och *minimum_sensitivity* är litet (t.ex. mindre än 5) kan referenskörningen bli instabil. En högre referenskörningshastighet kan öka intervallet och göra funktionen stabilare.

Observera att justeringsprocessen måste köras igen om drivrutinsströmmen, referenskörningshastigheten eller skrivarens maskinvara ändras väsentligt.

#### Använda makron vid referenskörning

Efter att sensorlös referenskörning är klar trycks vagnen mot rälsens ände och stegmotorn belastar ramen tills vagnen flyttas därifrån. Det är lämpligt att skapa ett makro som referenskör axeln och omedelbart flyttar vagnen bort från rälsens ände.

Det är lämpligt att makrot väntar minst 2 sekunder innan sensorlös referenskörning inleds (eller på annat sätt säkerställer att stegmotorn inte har rört sig på 2 sekunder). Utan fördröjning kan drivrutinens interna blockeringsflagga fortfarande vara satt från en tidigare rörelse.

Det kan också vara användbart att låta makrot ställa in drivrutinens ström före referenskörning och ange en ny ström efter att vagnen har flyttats bort.

Ett exempel på ett makro kan se ut så här:

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # Set current for sensorless homing
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # Pause to ensure driver stall flag is clear
    G4 P2000
    # Home
    G28 X0
    # Move away
    G90
    G1 X5 F1200
    # Set current during print
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

Det färdiga makrot kan anropas från ett [konfigurationsavsnitt för homing_override](Config_Reference.md#homing_override) eller från ett [START_PRINT-makro](Slicers.md#klipper-gcode_macro).

Observera att trimningsprocessen bör köras igen om drivrutinens ström ändras under referenskörningen.

### Tips för sensorlös referenskörning på CoreXY

Sensorlös referenskörning kan användas för X- och Y-vagnarna på en CoreXY-skrivare. Klipper använder stegmotorn `[stepper_x]` för att upptäcka blockeringar när X-vagnen referenskörs och `[stepper_y]` när Y-vagnen referenskörs.

Använd trimningsguiden ovan för att hitta lämplig ”blockeringskänslighet” för varje vagn, men beakta följande begränsningar:

1. Vid sensorlös referenskörning på CoreXY ska du kontrollera att `hold_current` inte är konfigurerat för någon av stegmotorerna.
1. Kontrollera under trimningen att både X- och Y-vagnen befinner sig nära mitten av sina skenor före varje referenskörningsförsök.
1. När trimningen är klar ska makron användas vid referenskörning av både X och Y för att först referensköra en axel, sedan flytta vagnen bort från axelgränsen, vänta minst 2 sekunder och därefter starta referenskörning av den andra axeln. Förflyttningen från axelgränsen förhindrar att en axel referenskörs medan den andra trycks mot sin axelgräns, vilket kan ge felaktig blockeringsdetektering. Pausen krävs för att säkerställa att drivrutinens blockeringsflagga rensas före nästa referenskörning.

Ett exempel på ett CoreXY-makro för referenskörning kan se ut så här:

```
[gcode_macro HOME]
gcode:
    G90
    # Home Z
    G28 Z0
    G1 Z10 F1200
    # Home Y
    G28 Y0
    G1 Y5 F1200
    # Home X
    G4 P2000
    G28 X0
    G1 X5 F1200
```

## Fråga efter och felsök drivrutinsinställningar

Kommandot [DUMP_TMC](G-Codes.md#dump_tmc) är ett användbart verktyg vid konfigurering och felsökning av drivrutiner. Det rapporterar alla fält som Klipper har konfigurerat och alla fält som kan frågas ut från drivrutinen.

Alla rapporterade fält definieras i Trinamics datablad för respektive drivrutin. Databladen finns på [Trinamics webbplats](https://www.trinamic.com/). Hämta och granska Trinamics datablad för drivrutinen för att tolka resultatet från DUMP_TMC.

## Konfigurera driver_XXX-inställningar

Klipper har stöd för att konfigurera många lågnivåfält i drivrutinen med inställningar av typen `driver_XXX`. [Konfigurationsreferensen för TMC-drivrutiner](Config_Reference.md#tmc-stepper-driver-configuration) innehåller en fullständig lista över fälten som är tillgängliga för varje drivrutinstyp.

Dessutom kan nästan alla fält ändras under körning med kommandot [SET_TMC_FIELD](G-Codes.md#set_tmc_field).

Alla dessa fält definieras i Trinamics datablad för respektive drivrutin. Databladen finns på [Trinamics webbplats](https://www.trinamic.com/).

Observera att Trinamics datablad ibland använder formuleringar som kan förväxla en inställning på hög nivå, exempelvis ”hysteresis end”, med ett fältvärde på låg nivå, exempelvis ”HEND”. I Klipper anger `driver_XXX` och SET_TMC_FIELD alltid lågnivåfältets värde, det vill säga värdet som faktiskt skrivs till drivrutinen. Om Trinamics datablad till exempel anger att värdet 3 ska skrivas till HEND-fältet för att få ”hysteresis end” 0, ska `driver_HEND=3` anges för att få värdet 0 på hög nivå.

## Vanliga frågor

### Kan jag använda läget stealthChop på en extruder med pressure advance?

Många använder framgångsrikt läget ”stealthChop” tillsammans med Klippers pressure advance. Klipper implementerar [mjuk pressure advance](Kinematics.md#pressure-advance), som inte orsakar några momentana hastighetsändringar.

Läget ”stealthChop” kan dock ge lägre motorvridmoment och/eller mer värme i motorn. Det kan vara ett lämpligt läge för just din skrivare, men behöver inte vara det.

### Jag får ständigt felet ”Unable to read tmc uart 'stepper_x' register IFCNT”?

Detta inträffar när Klipper inte kan kommunicera med en tmc2208- eller tmc2209-drivrutin.

Kontrollera att motorströmmen är aktiverad, eftersom stegmotordrivern normalt behöver motorström för att kunna kommunicera med mikrokontrollern.

Om felet inträffar efter att Klipper har flashats för första gången kan stegmotordrivern tidigare ha programmerats till ett tillstånd som inte är kompatibelt med Klipper. Återställ tillståndet genom att koppla bort all ström från skrivaren i några sekunder, både USB- och strömkabeln.

I annat fall beror felet vanligen på felkopplade UART-stift eller felaktiga inställningar för UART-stiften i Klipper.

### Jag får ständigt felet ”Unable to write tmc spi 'stepper_x' register ...”?

Detta inträffar när Klipper inte kan kommunicera med en tmc2130- eller tmc5160-drivrutin.

Kontrollera att motorströmmen är aktiverad, eftersom stegmotordrivern normalt behöver motorström för att kunna kommunicera med mikrokontrollern.

I annat fall beror felet vanligen på felkopplad SPI, felaktiga SPI-inställningar i Klipper eller en ofullständig konfiguration av enheter på en SPI-buss.

Observera att om drivrutinen delar SPI-buss med flera enheter måste varje enhet på den delade SPI-bussen konfigureras fullständigt i Klipper. Om en enhet på en delad SPI-buss inte är konfigurerad kan den felaktigt svara på kommandon som inte är avsedda för den och störa kommunikationen med den avsedda enheten. Om en enhet på den delade SPI-bussen inte kan konfigureras i Klipper använder du ett [konfigurationsavsnitt för static_digital_output](Config_Reference.md#static_digital_output) för att sätta den oanvända enhetens CS-stift högt, så att den inte försöker använda SPI-bussen. Kortets kretsschema är ofta användbart för att hitta enheterna på en SPI-buss och deras tillhörande stift.

### Varför fick jag felet ”TMC reports error: ...”?

Den här typen av fel innebär att TMC-drivrutinen har upptäckt ett problem och stängt av sig själv. Drivrutinen slutar alltså hålla sin position och ignorerar rörelsekommandon. Om Klipper upptäcker att en aktiv drivrutin har stängt av sig själv försätts skrivaren i läget ”shutdown”.

En avstängning med **TMC reports error** kan också uppstå på grund av SPI-fel som förhindrar kommunikation med drivrutinen, på tmc2130, tmc5160 eller tmc2660. När detta inträffar visar den rapporterade drivrutinsstatusen ofta `00000000` eller `ffffffff`, till exempel: `TMC reports error: DRV_STATUS: ffffffff ...` ELLER `TMC reports error: READRSP@RDSEL2: 00000000 ...`. Felet kan bero på ett SPI-kopplingsproblem eller på att TMC-drivrutinen har återställts eller gått sönder.

Några vanliga fel och tips för att felsöka dem:

#### TMC reports error: `... ot=1(OvertempError!)`

Detta innebär att motordrivern stängde av sig själv eftersom den blev för varm. Vanliga åtgärder är att minska stegmotorströmmen, förbättra kylningen av stegmotordrivern och/eller förbättra kylningen av stegmotorn.

#### TMC reports error: `... ShortToGND` ELLER `ShortToSupply`

Detta innebär att drivrutinen stängde av sig själv eftersom den upptäckte mycket hög ström genom drivrutinen. Det kan tyda på en lös eller kortsluten ledning till stegmotorn eller inne i själva stegmotorn.

Felet kan även inträffa i läget stealthChop om TMC-drivrutinen inte kan förutsäga motorns mekaniska belastning tillräckligt noggrant. Om drivrutinen gör en dålig förutsägelse kan den skicka för hög ström genom motorn och utlösa sin egen överströmsdetektering. Testa detta genom att inaktivera läget stealthChop och kontrollera om felen kvarstår.

#### TMC reports error: `... reset=1(Reset)` ELLER `CS_ACTUAL=0(Reset?)` ELLER `SE=0(Reset?)`

Detta innebär att drivrutinen återställde sig själv mitt under en utskrift. Det kan bero på problem med spänning eller kablage.

#### TMC reports error: `... uv_cp=1(Undervoltage!)`

Detta innebär att drivrutinen upptäckte en händelse med låg spänning och stängde av sig själv. Det kan bero på problem med kablage eller strömförsörjning.

### Hur trimmar jag läget spreadCycle/coolStep/osv. för mina drivrutiner?

[Trinamics webbplats](https://www.trinamic.com/) innehåller guider för konfigurering av drivrutinerna. Guiderna är ofta tekniska, på låg nivå och kan kräva specialiserad maskinvara. De är ändå den bästa informationskällan.
