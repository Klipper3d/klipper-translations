# Kinematik

Detta dokument ger en översikt över hur Klipper implementerar robotrörelser ([kinematik](https://en.wikipedia.org/wiki/Kinematics)). Innehållet kan vara intressant både för utvecklare som vill arbeta med Klipper-programvaran och för användare som vill förstå sina maskiners mekanik bättre.

## Acceleration

Klipper använder konstant acceleration när skrivarhuvudet ändrar hastighet: hastigheten ändras gradvis i stället för genom ett plötsligt ryck. Klipper tillämpar alltid acceleration mellan verktygshuvudet och utskriften. Filamentet som lämnar extrudern kan vara mycket skört; snabba ryck och ändringar av extruderflödet leder till dålig kvalitet och dålig bäddvidhäftning. Även utan extrudering kan snabba ryck i huvudet störa nyligen deponerat filament om skrivarhuvudet är på samma nivå som utskriften. Begränsade hastighetsändringar för skrivarhuvudet minskar risken att störa utskriften.

Det är också viktigt att begränsa accelerationen så att stegmotorerna inte tappar steg eller belastar maskinen för hårt. Klipper begränsar vridmomentet för varje stegmotor genom att begränsa skrivarhuvudets acceleration. Att begränsa accelerationen vid skrivarhuvudet begränsar naturligt även vridmomentet hos de stegmotorer som flyttar skrivarhuvudet, men det omvända är inte alltid sant.

Klipper använder konstant acceleration. Nyckelformeln för konstant acceleration är:

```
velocity(time) = start_velocity + accel*time
```

## Trapetsgenerator

Klipper använder en traditionell "trapetsgenerator" för att modellera varje rörelse. Varje rörelse har en starthastighet, accelererar med konstant acceleration till en marschhastighet, fortsätter med konstant hastighet och bromsar sedan med konstant acceleration till sluthastigheten.

![trapezoid](img/trapezoid.svg.png)

Den kallas "trapetsgenerator" eftersom rörelsens hastighetsdiagram ser ut som en trapets.

Marschhastigheten är alltid större än eller lika med både start- och sluthastigheten. Accelerationsfasen kan ha noll varaktighet om starthastigheten är lika med marschhastigheten, marschfasen kan ha noll varaktighet om rörelsen börjar bromsa direkt efter accelerationen och/eller bromsfasen kan ha noll varaktighet om sluthastigheten är lika med marschhastigheten.

![trapezoids](img/trapezoids.svg.png)

## Framåtblick

Systemet för "framåtblick" används för att bestämma kurvhastigheter mellan rörelser.

Betrakta följande två rörelser i ett XY-plan:

![corner](img/corner.svg.png)

I situationen ovan går det att bromsa helt efter den första rörelsen och sedan accelerera helt i början av nästa rörelse, men det är inte idealiskt. All denna acceleration och inbromsning skulle öka utskriftstiden kraftigt, och de täta ändringarna av extruderflödet skulle ge dålig utskriftskvalitet.

För att lösa detta köar mekanismen för "framåtblick" flera inkommande rörelser och analyserar vinklarna mellan dem för att bestämma en rimlig hastighet i "övergången" mellan två rörelser. Om nästa rörelse går nästan i samma riktning behöver huvudet bara sakta ned lite, om alls.

![lookahead](img/lookahead.svg.png)

Om nästa rörelse däremot bildar en spetsig vinkel – huvudet kommer nästan att röra sig i motsatt riktning i nästa rörelse – tillåts endast en låg övergångshastighet.

![lookahead](img/lookahead-slow.svg.png)

Övergångshastigheterna bestäms med "approximerad centripetalacceleration". Detta [beskrivs bäst av upphovspersonen](https://onehossshay.wordpress.com/2011/09/24/improving_grbl_cornering_algorithm/). I Klipper konfigureras dock övergångshastigheterna genom att ange önskad hastighet i ett 90°-hörn ("square corner velocity"); hastigheterna för andra vinklar härleds från den.

Nyckelformel för framåtblick:

```
end_velocity^2 = start_velocity^2 + 2*accel*move_distance
```

### Minsta marschförhållande

Klipper har även en mekanism som jämnar ut rörelserna vid korta "sicksack"-rörelser. Betrakta följande rörelser:

![zigzag](img/zigzag.svg.png)

I exemplet ovan kan de täta växlingarna från acceleration till inbromsning få maskinen att vibrera, vilket belastar maskinen och ökar ljudnivån. Klipper har en mekanism som ser till att det alltid finns en viss rörelse med marschhastighet mellan acceleration och inbromsning. Det görs genom att sänka topphastigheten för vissa rörelser, eller följder av rörelser, så att en minsta sträcka färdas med marschhastighet i förhållande till sträckan under acceleration och inbromsning.

Klipper implementerar funktionen genom att följa både en vanlig rörelseacceleration och en virtuell hastighet för "acceleration till inbromsning":

![smoothed](img/smoothed.svg.png)

Koden beräknar närmare bestämt vilken hastighet varje rörelse skulle ha om den begränsades till denna virtuella hastighet för "acceleration till inbromsning". I bilden ovan representerar de streckade grå linjerna den virtuella accelerationshastigheten för den första rörelsen. Om en rörelse inte kan nå full marschhastighet med denna virtuella accelerationshastighet sänks dess topphastighet till den högsta hastighet den kan uppnå med den virtuella hastigheten.

För de flesta rörelser ligger gränsen vid eller över rörelsens befintliga gränser, så inget beteende förändras. För korta sicksackrörelser sänker gränsen dock topphastigheten. Den ändrar inte den faktiska accelerationen inom rörelsen; rörelsen fortsätter att använda det vanliga accelerationssystemet upp till sin justerade topphastighet.

## Generera steg

När framåtblicksprocessen är klar är skrivarhuvudets rörelse för den aktuella förflyttningen helt känd – tid, startposition, slutposition och hastighet i varje punkt – och stegtiderna kan genereras. Detta sker i Klipper-kodens "kinematiska klasser". Utanför dessa klasser följs allt i millimeter, sekunder och kartesiskt koordinatutrymme. De kinematiska klassernas uppgift är att omvandla det generiska koordinatsystemet till den aktuella skrivarens maskinvaruspecifika egenskaper.

Klipper använder en [iterativ lösare](https://en.wikipedia.org/wiki/Root-finding_algorithm) för att generera stegtider för varje stegmotor. Koden innehåller formler för att beräkna huvudets ideala kartesiska koordinater vid varje tidpunkt och kinematiska formler för att beräkna idealiska stegmotorpositioner utifrån dessa koordinater. Med formlerna kan Klipper fastställa den ideala tidpunkten då stegmotorn ska vara i varje stegposition. Stegen schemaläggs sedan vid de beräknade tidpunkterna.

Nyckelformeln för att avgöra hur långt en rörelse ska färdas under konstant acceleration är:

```
move_distance = (start_velocity + .5 * accel * move_time) * move_time
```

och nyckelformeln för rörelse med konstant hastighet är:

```
move_distance = cruise_velocity * move_time
```

Nyckelformlerna för att bestämma en rörelses kartesiska koordinat utifrån rörelsens längd är:

```
cartesian_x_position = start_x + move_distance * total_x_movement / total_movement
cartesian_y_position = start_y + move_distance * total_y_movement / total_movement
cartesian_z_position = start_z + move_distance * total_z_movement / total_movement
```

### Kartesiska robotar

Steggenerering för kartesiska skrivare är det enklaste fallet. Rörelsen på varje axel är direkt kopplad till rörelsen i kartesiskt utrymme.

Nyckelformler:

```
stepper_x_position = cartesian_x_position
stepper_y_position = cartesian_y_position
stepper_z_position = cartesian_z_position
```

### CoreXY-robotar

Steggenerering på en CoreXY-maskin är bara något mer komplex än för grundläggande kartesiska robotar. Nyckelformlerna är:

```
stepper_a_position = cartesian_x_position + cartesian_y_position
stepper_b_position = cartesian_x_position - cartesian_y_position
stepper_z_position = cartesian_z_position
```

### Deltarobotar

Steggenerering på en deltarobot baseras på Pythagoras sats:

```
stepper_position = (sqrt(arm_length^2
                         - (cartesian_x_position - tower_x_position)^2
                         - (cartesian_y_position - tower_y_position)^2)
                    + cartesian_z_position)
```

### Accelerationsgränser för stegmotorer

Med delta-kinematik kan en rörelse som accelererar i kartesiskt utrymme kräva högre acceleration av en viss stegmotor än rörelsens acceleration. Detta kan inträffa när en stegmotorarm är mer horisontell än vertikal och rörelselinjen passerar nära stegmotorns torn. Även om sådana rörelser kan kräva högre stegmotoracceleration än skrivarens högsta konfigurerade rörelseacceleration, är den effektiva massa som flyttas av stegmotorn mindre. Den högre stegmotoraccelerationen ger därför inte ett väsentligt högre vridmoment och betraktas som ofarlig.

För att undvika extrema fall tillämpar Klipper dock ett tak för stegmotoraccelerationen på tre gånger skrivarens konfigurerade högsta rörelseacceleration. På samma sätt begränsas stegmotorns högsta hastighet till tre gånger den högsta rörelsehastigheten. För att tillämpa gränsen får rörelser längst ut i byggvolymen, där en stegmotorarm kan vara nästan horisontell, lägre högsta acceleration och hastighet.

### Extruderkinematik

Klipper implementerar extruderrörelsen i en egen kinematisk klass. Eftersom tidpunkten och hastigheten för varje skrivarhuvudrörelse är helt kända för varje förflyttning kan stegtiderna för extrudern beräknas oberoende av stegtidsberäkningarna för skrivarhuvudets rörelse.

Grundläggande extruderrörelse är enkel att beräkna. Genereringen av stegtider använder samma formler som kartesiska robotar använder:

```
stepper_position = requested_e_position
```

### Tryckutjämning

Experiment har visat att extrudermodelleringen kan förbättras utöver den grundläggande extruderformeln. I idealfallet ska samma filamentvolym deponeras i varje punkt längs rörelsen och ingen volym extruderas efter rörelsen. I praktiken leder de grundläggande extruderingsformlerna ofta till att för lite filament lämnar extrudern i början av extruderingsrörelser och att överskottsfilament extruderas efter att extruderingen har avslutats. Detta kallas ofta "efterflytning".

![ooze](img/ooze.svg.png)

Systemet för "tryckutjämning" försöker ta hänsyn till detta med en annan modell för extrudern. I stället för att naivt anta att varje mm^3 filament som matas in i extrudern omedelbart ger samma mängd mm^3 ut ur extrudern används en tryckbaserad modell. Trycket ökar när filament trycks in i extrudern, som i [Hookes lag](https://en.wikipedia.org/wiki/Hooke%27s_law), och det tryck som behövs för extrudering bestäms främst av flödeshastigheten genom munstyckets öppning, som i [Poiseuilles lag](https://en.wikipedia.org/wiki/Poiseuille_law). Grundidén är att relationen mellan filament, tryck och flödeshastighet kan modelleras med en linjär koefficient:

```
pa_position = nominal_position + pressure_advance_coefficient * nominal_velocity
```

Se dokumentet om [tryckutjämning](Pressure_Advance.md) för information om hur denna tryckutjämningskoefficient fastställs.

Den grundläggande formeln för tryckutjämning kan få extrudermotorn att ändra hastighet plötsligt. Klipper använder "utjämning" av extruderrörelsen för att undvika detta.

![pressure-advance](img/pressure-velocity.png)

Diagrammet ovan visar två exempel på extruderingsrörelser med en kurvhastighet som inte är noll mellan dem. Observera att systemet för tryckutjämning gör att extra filament trycks in i extrudern under accelerationen. Ju högre önskat filamentflöde, desto mer filament måste matas in under accelerationen för att kompensera för trycket. När huvudet bromsar dras det extra filamentet tillbaka; extrudern får då negativ hastighet.

"Utjämningen" implementeras med ett viktat medelvärde av extruderns position över en kort tidsperiod, enligt konfigurationsparametern `pressure_advance_smooth_time`. Medelvärdesbildningen kan omfatta flera G-kodsrörelser. Observera att extrudermotorn börjar röra sig före den nominella starten av den första extruderingsrörelsen och fortsätter efter det nominella slutet av den sista.

Nyckelformel för "utjämnad tryckutjämning":

```
smooth_pa_position(t) =
    ( definitive_integral(pa_position(x) * (smooth_time/2 - abs(t - x)) * dx,
                          from=t-smooth_time/2, to=t+smooth_time/2)
     / (smooth_time/2)^2 )
```
