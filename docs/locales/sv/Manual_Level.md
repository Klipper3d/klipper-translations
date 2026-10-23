# Manuell nivellering

Det här dokumentet beskriver verktyg för att kalibrera ett Z-ändstopp och justera bäddens nivelleringsskruvar.

## Kalibrera ett Z-ändstopp

En exakt position för Z-ändstoppet är avgörande för utskrifter av hög kvalitet.

Observera dock att själva Z-ändstoppsbrytarens precision kan vara en begränsande faktor. Om du använder stegmotordrivare från Trinamic kan du överväga att aktivera identifiering av [ändstoppsfas](Endstop_Phase.md) för att förbättra brytarens precision.

Kalibrera Z-ändstoppet genom att referensköra skrivaren, beordra huvudet att flytta till en Z-position minst fem millimeter över bädden (om det inte redan är där), beordra huvudet till en XY-position nära bäddens mitt och gå sedan till terminalfliken i OctoPrint och kör:

```
Z_ENDSTOP_CALIBRATE
```

Följ sedan stegen i ["papperstestet"](Bed_Level.md#the-paper-test) för att fastställa det faktiska avståndet mellan munstycke och bädd på den aktuella platsen. När stegen är klara kan du `ACCEPT`-godkänna positionen och spara resultatet i konfigurationsfilen med:

```
SAVE_CONFIG
```

Det är bäst att använda en Z-ändstoppsbrytare i motsatt ände av Z-axeln från bädden. (Referenskörning bort från bädden är robustare, eftersom det då normalt alltid är säkert att referensköra Z.) Om du däremot måste referensköra mot bädden rekommenderas att ändstoppet justeras så att det aktiveras en liten bit (t.ex. 0,5 mm) ovanför bädden. Nästan alla ändstoppsbrytare kan tryckas in en liten sträcka förbi aktiveringspunkten utan risk. Då bör kommandot `Z_ENDSTOP_CALIBRATE` rapportera ett litet positivt värde (t.ex. 0,5 mm) för Z `position_endstop`. Om ändstoppet aktiveras medan det fortfarande finns ett avstånd till bädden minskar risken för oavsiktliga kollisioner med bädden.

På vissa skrivare går det att justera den fysiska ändstoppsbrytarens läge manuellt. Det rekommenderas dock att Z-ändstoppets positionering görs i programvara med Klipper: när ändstoppet sitter på en lämplig fysisk plats kan ytterligare justeringar göras genom att köra `Z_ENDSTOP_CALIBRATE` eller genom att uppdatera Z `position_endstop` manuellt i konfigurationsfilen.

## Justera bäddens nivelleringsskruvar

Nyckeln till god bäddnivellering med nivelleringsskruvar är att utnyttja skrivarens högprecisa rörelsesystem under själva nivelleringsprocessen. Det görs genom att flytta munstycket till en position nära varje bäddskruv och sedan justera skruven tills bädden har ett angivet avstånd från munstycket. Klipper har ett verktyg som hjälper till med detta. För att använda verktyget måste XY-positionen för varje skruv anges.

Det görs genom att skapa en `[bed_screws]`-sektion i konfigurationen. Den kan exempelvis se ut så här:

```
[bed_screws]
screw1: 100, 50
screw2: 100, 150
screw3: 150, 100
```

Om en bäddskruv sitter under bädden anger du XY-positionen direkt ovanför skruven. Om skruven sitter utanför bädden anger du den XY-position som är närmast skruven men fortfarande inom bäddens område.

När konfigurationsfilen är klar kör du `RESTART` för att läsa in den och startar sedan verktyget med:

```
BED_SCREWS_ADJUST
```

Verktyget flyttar skrivarens munstycke till varje skruvs XY-position och flyttar sedan munstycket till höjden Z=0. Där kan du använda papperstestet för att justera bäddskruven direkt under munstycket. Se informationen i ["papperstestet"](Bed_Level.md#the-paper-test), men justera bäddskruven i stället för att flytta munstycket till olika höjder. Justera skruven tills det känns ett litet motstånd när du för papperet fram och tillbaka.

När skruven är justerad så att ett litet motstånd känns kör du antingen `ACCEPT` eller `ADJUSTED`. Använd `ADJUSTED` om bäddskruven behövde justeras (vanligen mer än ungefär en åttondels varv). Använd `ACCEPT` om ingen betydande justering behövs. Båda kommandona gör att verktyget går vidare till nästa skruv. (När `ADJUSTED` används schemalägger verktyget ytterligare en omgång med justeringar; verktyget är klart när alla bäddskruvar har kontrollerats och inte behöver någon betydande justering.) Med `ABORT` kan du avsluta verktyget i förtid.

Systemet fungerar bäst när skrivaren har en plan utskriftsyta (till exempel glas) och raka skenor. När bäddnivelleringsverktyget är klart bör bädden vara redo för utskrift.

### Finjustering av bäddskruvar

Om skrivaren använder tre bäddskruvar och samtliga sitter under bädden kan det gå att utföra ett andra, högprecist nivelleringssteg. Det görs genom att flytta munstycket till platser där bädden rör sig längre vid varje justering av en bäddskruv.

Anta till exempel att bädden har skruvar vid positionerna A, B och C:

![bed_screws](img/bed_screws.svg.png)

För varje justering av bäddskruven vid position C svänger bädden längs en hävarm som definieras av de två återstående bäddskruvarna (visas här som en grön linje). I denna situation flyttar varje justering av skruven vid C bädden vid position D mer än direkt vid C. Det går därför att förbättra justeringen av C-skruven när munstycket står vid position D.

För att aktivera funktionen fastställer du de extra munstyckskoordinaterna och lägger till dem i konfigurationsfilen. Den kan exempelvis se ut så här:

```
[bed_screws]
screw1: 100, 50
screw1_fine_adjust: 0, 0
screw2: 100, 150
screw2_fine_adjust: 300, 300
screw3: 150, 100
screw3_fine_adjust: 0, 100
```

När funktionen är aktiverad ber verktyget `BED_SCREWS_ADJUST` först om grova justeringar direkt över varje skruvposition och, när de har godkänts, om finjusteringar på de extra platserna. Fortsätt att använda `ACCEPT` och `ADJUSTED` vid varje position.

## Justera bäddens nivelleringsskruvar med bäddsonden

Detta är ett annat sätt att kalibrera bäddnivån med en bäddsond. För att använda det måste du ha en Z-sond (BLTouch, induktiv givare osv.).

För att aktivera funktionen fastställer du munstyckskoordinaterna så att Z-sonden befinner sig över skruvarna och lägger sedan till dem i konfigurationsfilen. Den kan exempelvis se ut så här:

```
[screws_tilt_adjust]
screw1: -5, 30
screw1_name: front left screw
screw2: 155, 30
screw2_name: front right screw
screw3: 155, 190
screw3_name: rear right screw
screw4: -5, 190
screw4_name: rear left screw
horizontal_move_z: 10.
speed: 50.
screw_thread: CW-M3
```

Skruv 1 är alltid referenspunkten för de andra, så systemet förutsätter att skruv 1 har rätt höjd. Kör alltid först `G28` och sedan `SCREWS_TILT_CALCULATE` – resultatet bör likna följande:

```
Send: G28
Recv: ok
Send: SCREWS_TILT_CALCULATE
Recv: // 01:20 means 1 full turn and 20 minutes, CW=clockwise, CCW=counter-clockwise
Recv: // front left screw (base) : x=-5.0, y=30.0, z=2.48750
Recv: // front right screw : x=155.0, y=30.0, z=2.36000 : adjust CW 01:15
Recv: // rear right screw : y=155.0, y=190.0, z=2.71500 : adjust CCW 00:50
Recv: // read left screw : x=-5.0, y=190.0, z=2.47250 : adjust CW 00:02
Recv: ok
```

Detta innebär att:

- den främre vänstra skruven är referenspunkten och får inte ändras.
- den främre högra skruven ska vridas ett helt varv och en fjärdedels varv medurs
- den bakre högra skruven ska vridas 50 minuter moturs
- den bakre vänstra skruven ska vridas 2 minuter medurs (ingen justering behövs, det är okej)

Observera att "minuter" avser minuter på en urtavla. Exempelvis är 15 minuter en fjärdedels varv.

Upprepa processen flera gånger tills bädden är väl nivellerad – normalt när alla justeringar är under 6 minuter.

Om du använder en sond som är monterad vid sidan av hotend-enheten (alltså har en X- eller Y-offset) ska du tänka på att justering av bäddens lutning gör tidigare sondkalibrering som gjorts med en lutande bädd ogiltig. Kör [sondkalibrering](Probe_Calibrate.md) efter att bäddskruvarna har justerats.

Parametern `MAX_DEVIATION` är användbar när ett sparat bäddnät används, för att säkerställa att bäddnivån inte har förändrats för mycket sedan nätet skapades. Exempelvis kan `SCREWS_TILT_CALCULATE MAX_DEVIATION=0.01` läggas till i skivningsprogrammets anpassade start-G-Code innan nätet läses in. Utskriften avbryts om den angivna gränsen överskrids (0,01 mm i detta exempel), så att användaren kan justera skruvarna och starta om utskriften.

Parametern `DIRECTION` är användbar om bäddens justerskruvar endast kan vridas åt ett håll. Du kan till exempel ha skruvar som börjar åtdragna i sitt lägsta (eller högsta) möjliga läge och bara kan vridas åt ett håll för att höja (eller sänka) bädden. Om skruvarna bara kan vridas medurs kör du `SCREWS_TILT_CALCULATE DIRECTION=CW`. Om de bara kan vridas moturs kör du `SCREWS_TILT_CALCULATE DIRECTION=CCW`. En lämplig referenspunkt väljs så att bädden kan nivelleras genom att alla skruvar vrids åt det angivna hållet.
