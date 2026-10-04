# Sondkalibrering

Detta dokument beskriver metoden för att kalibrera X-, Y- och Z-förskjutningarna för en automatisk Z-sond i Klipper. Det är användbart för användare som har avsnittet `[probe]` eller `[bltouch]` i konfigurationsfilen.

## Kalibrera sondens X- och Y-förskjutningar

För att kalibrera X- och Y-förskjutningen går du till fliken Control i OctoPrint, hemkör skrivaren och använder sedan OctoPrints knappar för stegvis förflyttning för att flytta huvudet till en plats nära bäddens mitt.

Placera en bit blå maskeringstejp eller liknande på bädden under sonden. Gå till fliken Terminal i OctoPrint och utfärda kommandot PROBE:

```
PROBE
```

Markera tejpen direkt under sonden, eller använd en liknande metod för att notera platsen på bädden.

Utfärda kommandot `GET_POSITION` och anteckna verktygshuvudets XY-position som kommandot rapporterar. Om följande visas:

```
Recv: // toolhead: X:46.500000 Y:27.000000 Z:15.000000 E:0.000000
```

antecknas alltså sondens X-position som 46,5 och Y-position som 27.

När sondpositionen har antecknats utfärdar du en serie G1-kommandon tills munstycket befinner sig direkt ovanför markeringen på bädden. Du kan till exempel utfärda:

```
G1 F300 X57 Y30 Z15
```

för att flytta munstycket till X-position 57 och Y-position 30. När en position direkt ovanför markeringen har hittats använder du kommandot `GET_POSITION` för att rapportera den positionen. Detta är munstyckets position.

x_offset är då `nozzle_x_position - probe_x_position`, och y_offset är på motsvarande sätt `nozzle_y_position - probe_y_position`. Uppdatera filen printer.cfg med värdena, ta bort tejpen/markeringarna från bädden och utfärda sedan kommandot `RESTART` så att de nya värdena börjar gälla.

## Kalibrera sondens Z-förskjutning

Ett korrekt z_offset för sonden är avgörande för utskrifter av hög kvalitet. z_offset är avståndet mellan munstycket och bädden när sonden löser ut. Verktyget `PROBE_CALIBRATE` i Klipper kan användas för att få fram värdet: det utför en automatisk sondering för att mäta sondens Z-utlösningsposition och startar sedan manuell sondering för att få munstyckets Z-höjd. Sondens z_offset beräknas sedan från mätningarna.

Börja med att hemköra skrivaren och flytta sedan huvudet till en plats nära bäddens mitt. Gå till terminalfliken i OctoPrint och kör kommandot `PROBE_CALIBRATE` för att starta verktyget.

Verktyget utför automatisk sondering, lyfter sedan huvudet, flyttar munstycket över sondpunktens plats och startar verktyget för manuell sondering. Om munstycket inte flyttas till en position ovanför den automatiska sondpunkten ska verktyget för manuell sondering avbrytas med `ABORT`; utför sedan kalibreringen av XY-förskjutningen som beskrivs ovan.

När verktyget för manuell sondering startar följer du stegen i [papperstestet](Bed_Level.md#the-paper-test) för att fastställa det verkliga avståndet mellan munstycke och bädd på den aktuella platsen. När stegen är klara kan positionen godtas med `ACCEPT` och resultaten sparas i konfigurationsfilen med:

```
SAVE_CONFIG
```

Observera att en ändring av skrivarens rörelsesystem, hotend-position eller sondplats gör resultatet från PROBE_CALIBRATE ogiltigt.

Om sonden har X- eller Y-förskjutning och bäddens lutning ändras, till exempel genom justering av bäddskruvar, körning av DELTA_CALIBRATE, Z_TILT_ADJUST eller QUAD_GANTRY_LEVEL, blir resultatet från PROBE_CALIBRATE ogiltigt. Efter en sådan justering måste PROBE_CALIBRATE köras igen.

Om resultaten från PROBE_CALIBRATE blir ogiltiga blir även tidigare resultat för [bäddrutnät](Bed_Mesh.md) som erhållits med sonden ogiltiga. Kör därför BED_MESH_CALIBRATE igen efter omkalibrering av sonden.

## Kontroll av repeterbarhet

Efter kalibrering av sondens X-, Y- och Z-förskjutningar är det lämpligt att kontrollera att sonden ger repeterbara resultat. Börja med att hemköra skrivaren och flytta huvudet till en plats nära bäddens mitt. Gå till terminalfliken i OctoPrint och kör kommandot `PROBE_ACCURACY`.

Kommandot kör sonden tio gånger och ger utdata som liknar följande:

```
Recv: // probe accuracy: at X:0.000 Y:0.000 Z:10.000
Recv: // and read 10 times with speed of 5 mm/s
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe accuracy results: maximum 2.519448, minimum 2.506948, range 0.012500, average 2.513198, median 2.513198, standard deviation 0.006250
```

Helst rapporterar verktyget identiska maximi- och minimivärden, alltså samma resultat för alla tio sonderingar. Det är dock normalt att minimi- och maximivärdena skiljer sig med ett Z-stegavstånd eller upp till 5 mikrometer (0,005 mm). Ett stegavstånd är `rotation_distance/(full_steps_per_rotation*microsteps)`. Avståndet mellan minimi- och maximivärdet kallas spann. I exemplet ovan, där skrivaren använder Z-stegavståndet 0,0125, betraktas ett spann på 0,012500 som normalt.

Om testresultaten visar ett spann större än 25 mikrometer (0,025 mm) har sonden inte tillräcklig noggrannhet för vanliga rutiner för bäddnivellering. Sondhastighet och/eller starthöjd kan kanske justeras för bättre repeterbarhet. Med `PROBE_ACCURACY` kan tester köras med olika parametrar; se [G-Code-dokumentet](G-Codes.md#probe_accuracy). Om resultaten normalt är repeterbara men ibland har ett avvikande värde kan flera prover per sondering hjälpa; läs om konfigurationsparametern `samples` i [konfigurationsreferensen](Config_Reference.md#probe).

Om en ny sondhastighet, ett nytt antal prover eller andra inställningar behövs uppdaterar du printer.cfg och utfärdar kommandot `RESTART`. Därefter är det lämpligt att [kalibrera z_offset](#calibrating-probe-z-offset) igen. Om repeterbara resultat inte kan fås ska sonden inte användas för bäddnivellering. Klipper har flera verktyg för manuell sondering; se [Bäddnivellering](Bed_Level.md).

## Kontroll av platsberoende avvikelse

Vissa sonder kan ha en systematisk avvikelse som förvanskar resultaten vid vissa verktygshuvudslägen. Om sondfästet till exempel lutar lite vid rörelse längs Y-axeln kan sonden rapportera skeva resultat vid olika Y-positioner.

Problemet är vanligt för sonder på deltaskrivare, men kan förekomma på alla skrivare.

Kontrollera en platsberoende avvikelse genom att använda `PROBE_CALIBRATE` för att mäta sondens z_offset på olika X- och Y-positioner. Helst ska z_offset vara konstant överallt på skrivaren.

På deltaskrivare bör z_offset mätas nära A-, B- och C-tornen. På kartesiska, CoreXY och liknande skrivare mäts den nära bäddens fyra hörn.

Före testet kalibrerar du först sondens X-, Y- och Z-förskjutningar enligt början av dokumentet. Hemkör sedan skrivaren och gå till den första XY-positionen. Följ stegen i [kalibrera sondens Z-förskjutning](#calibrating-probe-z-offset): kör `PROBE_CALIBRATE`, `TESTZ` och `ACCEPT`, men kör inte `SAVE_CONFIG`. Anteckna det rapporterade z_offset. Gå sedan till övriga XY-positioner, upprepa stegen och anteckna z_offset.

Om skillnaden mellan minsta och största rapporterade z_offset är större än 25 mikrometer (0,025 mm) är sonden inte lämplig för vanliga rutiner för bäddnivellering. Se [Bäddnivellering](Bed_Level.md) för manuella alternativ.

## Temperaturberoende avvikelse

Många sonder har en systematisk avvikelse vid olika temperaturer. Sonden kan exempelvis konsekvent lösa ut på lägre höjd vid högre temperatur.

Kör verktygen för bäddnivellering vid en jämn temperatur för att ta hänsyn till avvikelsen. Kör dem exempelvis alltid när skrivaren har rumstemperatur eller alltid när den har nått en jämn utskriftstemperatur. Vänta i båda fallen några minuter efter att önskad temperatur nåtts, så att skrivarens mekanik hinner få jämn temperatur.

För att kontrollera en temperaturberoende avvikelse börjar du med skrivaren vid rumstemperatur, hemkör den, flyttar huvudet nära bäddens mitt och kör `PROBE_ACCURACY`. Anteckna resultatet. Utan att hemköra eller inaktivera stegmotorerna värmer du sedan munstycke och bädd till utskriftstemperatur och kör `PROBE_ACCURACY` igen. Helst är resultaten identiska. Om sonden har temperaturberoende avvikelse måste den alltid användas vid en jämn temperatur.
