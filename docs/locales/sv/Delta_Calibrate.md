# Deltakalibrering

Detta dokument beskriver Klippers automatiska kalibreringssystem för skrivare av "delta"-typ.

Deltakalibrering innebär att fastställa tornens ändstoppspositioner och vinklar, deltaradien och deltarmarnas längder. Dessa inställningar styr skrivarens rörelser på en deltaskrivare. Var och en av parametrarna har en svåröverblickbar och icke-linjär påverkan, och de är svåra att kalibrera manuellt. Kalibreringskoden i programvaran kan däremot ge utmärkta resultat på bara några minuter. Ingen särskild probningsmaskinvara krävs.

I slutänden beror deltakalibreringen på precisionen hos tornens ändstoppsbrytare. Om Trinamic-drivrutiner för stegmotorer används bör du överväga att aktivera detektering av [ändstoppsfas](Endstop_Phase.md) för att förbättra brytarnas precision.

## Automatisk eller manuell probning

Klipper stöder kalibrering av deltaparametrarna med en manuell probningsmetod eller en automatisk Z-sond.

Flera deltaskrivarsatser levereras med automatiska Z-sonder som inte är tillräckligt noggranna (särskilt eftersom små skillnader i armlängd kan få effektorn att luta, vilket kan förvränga en automatisk sond). Om du använder en automatisk sond ska du först [kalibrera sonden](Probe_Calibrate.md) och sedan kontrollera om den har en [positionsförskjutning](Probe_Calibrate.md#location-bias-check). Om den automatiska sonden har en förskjutning på mer än 25 mikrometer (0,025 mm) ska du i stället använda manuell probning. Manuell probning tar bara några minuter och eliminerar de fel som sonden inför.

Om du använder en sond som är monterad på sidan av hotenden (det vill säga har en X- eller Y-förskjutning) ska du tänka på att deltakalibrering gör resultatet av sondkalibreringen ogiltigt. Den här typen av sonder lämpar sig sällan för en deltaskrivare, eftersom även en liten lutning av effektorn orsakar en positionsförskjutning. Om du ändå använder sonden måste sondkalibreringen köras igen efter varje deltakalibrering.

## Grundläggande deltakalibrering

Klipper har kommandot DELTA_CALIBRATE, som kan utföra grundläggande deltakalibrering. Kommandot provar sju olika punkter på bädden och beräknar nya värden för tornens vinklar, tornens ändstopp och deltaradien.

För att utföra denna kalibrering måste de ursprungliga deltaparametrarna – armlängder, radie och ändstoppspositioner – anges, och de bör vara korrekta inom några millimeter. De flesta deltaskrivarsatser tillhandahåller dessa parametrar. Konfigurera skrivaren med dessa initiala standardvärden och kör sedan kommandot DELTA_CALIBRATE enligt beskrivningen nedan. Om standardvärden saknas kan du söka efter en guide för deltakalibrering på nätet som ger en grundläggande utgångspunkt.

Under deltakalibreringen kan skrivaren behöva prova under det som annars skulle betraktas som bäddens plan. Det är normalt att tillåta detta under kalibreringen genom att uppdatera konfigurationen så att skrivaren har `minimum_z_position=-5`. (När kalibreringen är klar kan inställningen tas bort ur konfigurationen.)

Det finns två sätt att utföra probningen: manuell probning (`DELTA_CALIBRATE METHOD=manual`) och automatisk probning (`DELTA_CALIBRATE`). Vid manuell probning flyttas huvudet nära bädden, varefter användaren följer stegen i ["papperstestet"](Bed_Level.md#the-paper-test) för att fastställa det faktiska avståndet mellan munstycket och bädden på den angivna platsen.

För att utföra den grundläggande probningen ska du kontrollera att konfigurationen innehåller avsnittet [delta_calibrate] och sedan köra verktyget:

```
G28
DELTA_CALIBRATE METHOD=manual
```

Efter probningen av de sju punkterna beräknas nya deltaparametrar. Spara och tillämpa parametrarna genom att köra:

```
SAVE_CONFIG
```

Den grundläggande kalibreringen bör ge deltaparametrar som är tillräckligt korrekta för grundläggande utskrift. Om detta är en ny skrivare är det ett bra tillfälle att skriva ut några enkla objekt och kontrollera den allmänna funktionen.

## Utökad deltakalibrering

Den grundläggande deltakalibreringen beräknar normalt deltaparametrar väl, så att munstycket har rätt avstånd till bädden. Den försöker dock inte kalibrera dimensionsnoggrannheten i X- och Y-led. Det är därför klokt att utföra en utökad deltakalibrering för att kontrollera dimensionsnoggrannheten.

Denna kalibreringsprocedur kräver att ett testobjekt skrivs ut och att delar av objektet mäts med ett digitalt skjutmått.

Innan en utökad deltakalibrering körs måste den grundläggande deltakalibreringen utföras med kommandot DELTA_CALIBRATE och resultatet sparas med kommandot SAVE_CONFIG. Kontrollera att skrivarens konfiguration och maskinvara inte har ändrats märkbart sedan den senaste grundläggande deltakalibreringen. (Om du är osäker ska du köra [den grundläggande deltakalibreringen](#basic-delta-calibration) igen, inklusive SAVE_CONFIG, strax innan testobjektet nedan skrivs ut.)

Använd en slicer för att skapa G-kod från filen [docs/prints/calibrate_size.stl](prints/calibrate_size.stl). Skiva objektet med låg hastighet (till exempel 40 mm/s). Använd om möjligt en styv plast, exempelvis PLA, till objektet. Objektets diameter är 140 mm. Om det är för stort för skrivaren kan det skalas ned, men se till att skala både X- och Y-axeln lika mycket. Om skrivaren stöder betydligt större utskrifter kan objektet också förstoras. En större storlek kan förbättra mätnoggrannheten, men god vidhäftning mot bädden är viktigare än större utskriftsstorlek.

Skriv ut testobjektet och vänta tills det har svalnat helt. Kommandona nedan måste köras med samma skrivarinställningar som användes för att skriva ut kalibreringsobjektet. Kör inte DELTA_CALIBRATE mellan utskrift och mätning och gör inte heller något som annars skulle ändra skrivarens konfiguration.

Utför om möjligt mätningarna nedan medan objektet fortfarande sitter fast på utskriftsbädden. Oroa dig dock inte om delen lossnar från bädden – försök bara att undvika att böja objektet när mätningarna utförs.

Börja med att mäta avståndet mellan mittpelaren och pelaren bredvid märkningen "A" (som också ska peka mot "A"-tornet).

![delta-a-distance](img/delta-a-distance.jpg)

Gå sedan motsols och mät avstånden mellan mittpelaren och de andra pelarna: avståndet från mitten till pelaren mittemot C-märkningen, avståndet från mitten till pelaren med B-märkningen och så vidare.

![delta_cal_e_step1](img/delta_cal_e_step1.png)

Ange dessa parametrar i Klipper som en kommaavgränsad lista med flyttal:

```
DELTA_ANALYZE CENTER_DISTS=<a_dist>,<far_c_dist>,<b_dist>,<far_a_dist>,<c_dist>,<far_b_dist>
```

Ange värdena utan mellanslag mellan dem.

Mät sedan avståndet mellan A-pelaren och pelaren mittemot C-märkningen.

![delta-ab-distance](img/delta-outer-distance.jpg)

Gå sedan motsols och mät avståndet mellan pelaren mittemot C och B-pelaren, avståndet mellan B-pelaren och pelaren mittemot A och så vidare.

![delta_cal_e_step2](img/delta_cal_e_step2.png)

Ange dessa parametrar i Klipper:

```
DELTA_ANALYZE OUTER_DISTS=<a_to_far_c>,<far_c_to_b>,<b_to_far_a>,<far_a_to_c>,<c_to_far_b>,<far_b_to_a>
```

Nu kan objektet tas bort från bädden. De sista mätningarna gäller själva pelarna. Mät mittpelarens storlek längs A-ekern, sedan längs B-ekern och därefter längs C-ekern.

![delta-a-pillar](img/delta-a-pillar.jpg)

![delta_cal_e_step3](img/delta_cal_e_step3.png)

Ange dem i Klipper:

```
DELTA_ANALYZE CENTER_PILLAR_WIDTHS=<a>,<b>,<c>
```

De sista mätningarna gäller de yttre pelarna. Börja med att mäta A-pelarens längd längs linjen från A till pelaren mittemot C.

![delta-ab-pillar](img/delta-outer-pillar.jpg)

Gå sedan motsols och mät de återstående yttre pelarna: pelaren mittemot C längs linjen till B, B-pelaren längs linjen till pelaren mittemot A och så vidare.

![delta_cal_e_step4](img/delta_cal_e_step4.png)

Ange dem sedan i Klipper:

```
DELTA_ANALYZE OUTER_PILLAR_WIDTHS=<a>,<far_c>,<b>,<far_a>,<c>,<far_b>
```

Om objektet skalades till en mindre eller större storlek ska du ange den skalfaktor som användes när objektet skivades:

```
DELTA_ANALYZE SCALE=1.0
```

(Ett skalvärde på 2,0 innebär att objektet är dubbelt så stort som ursprungligen, medan 0,5 innebär att det är hälften så stort.)

Utför slutligen den utökade deltakalibreringen genom att köra:

```
DELTA_ANALYZE CALIBRATE=extended
```

Detta kommando kan ta flera minuter att slutföra. När det är klart beräknas uppdaterade deltaparametrar – deltaradie, tornvinklar, ändstoppspositioner och armlängder. Använd kommandot SAVE_CONFIG för att spara och tillämpa inställningarna:

```
SAVE_CONFIG
```

Kommandot SAVE_CONFIG sparar både de uppdaterade deltaparametrarna och informationen från avståndsmätningarna. Framtida DELTA_CALIBRATE-kommandon använder också denna avståndsinformation. Försök inte ange de råa avståndsmätningarna på nytt efter att SAVE_CONFIG har körts, eftersom kommandot ändrar skrivarens konfiguration och de råa mätningarna då inte längre gäller.

### Ytterligare anmärkningar

* Om deltaskrivaren har god dimensionsnoggrannhet bör avståndet mellan två valfria pelare vara omkring 74 mm och bredden på varje pelare omkring 9 mm. Målet är närmare bestämt att avståndet mellan två pelare minus bredden på en av pelarna ska vara exakt 65 mm. Om delen har ett dimensionsfel beräknar rutinen DELTA_ANALYZE nya deltaparametrar med både avståndsmätningarna och de tidigare höjdmätningarna från det senaste kommandot DELTA_CALIBRATE.
* DELTA_ANALYZE kan ge oväntade deltaparametrar. Den kan till exempel föreslå armlängder som inte stämmer med skrivarens faktiska armlängder. Trots det har tester visat att DELTA_ANALYZE ofta ger bättre resultat. De beräknade deltaparametrarna tros kunna kompensera för små fel på andra håll i maskinvaran. Små skillnader i armlängd kan exempelvis göra att effektorn lutar, och en del av den lutningen kan kompenseras genom att justera armlängdsparametrarna.

## Använda bäddnät på en deltaskrivare

Det går att använda [bäddnät](Bed_Mesh.md) på en deltaskrivare. Det är dock viktigt att få till en god deltakalibrering innan ett bäddnät aktiveras. Ett bäddnät med dålig deltakalibrering ger förvirrande och bristfälliga resultat.

Observera att deltakalibrering gör ett tidigare framtaget bäddnät ogiltigt. Kör därför BED_MESH_CALIBRATE igen efter en ny deltakalibrering.
