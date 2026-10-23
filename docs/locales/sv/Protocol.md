# Protokoll

Klippers meddelandeprotokoll används för lågnivåkommunikation mellan värdprogramvaran Klipper och Klippers mikrokontrollerprogramvara. På hög nivå kan protokollet ses som en serie kommando- och svarssträngar som komprimeras, överförs och sedan behandlas hos mottagaren. En exempelserie av kommandon i okomprimerat, läsbart format kan se ut så här:

```
set_digital_out pin=PA3 value=1
set_digital_out pin=PA7 value=1
schedule_digital_out oid=8 clock=4000000 value=0
queue_step oid=7 interval=7458 count=10 add=331
queue_step oid=7 interval=11717 count=4 add=1281
```

Se dokumentet [MCU-kommandon](MCU_Commands.md) för information om tillgängliga kommandon. Se dokumentet [felsökning](Debugging.md) för information om hur en G-kodfil översätts till motsvarande läsbara mikrokontrollerkommandon.

Den här sidan ger en övergripande beskrivning av själva Klippers meddelandeprotokoll. Den beskriver hur meddelanden deklareras, kodas i binärt format ("komprimeringsschemat") och överförs.

Protokollets mål är att möjliggöra en felfri kommunikationskanal mellan värden och mikrokontrollern, med låg latens, låg bandbredd och låg komplexitet för mikrokontrollern.

## Mikrokontrollergränssnitt

Klippers överföringsprotokoll kan ses som en [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call)-mekanism mellan mikrokontrollern och värden. Mikrokontrollerprogramvaran deklarerar de kommandon som värden kan anropa, tillsammans med de svarsmeddelanden den kan skapa. Värden använder informationen för att be mikrokontrollern utföra åtgärder och tolka resultaten.

### Deklarera kommandon

Mikrokontrollerprogramvaran deklarerar ett "kommando" med makrot DECL_COMMAND() i C-koden. Till exempel:

```
DECL_COMMAND(command_update_digital_out, "update_digital_out oid=%c value=%c");
```

Ovanstående deklarerar ett kommando med namnet "update_digital_out". Det gör det möjligt för värden att "anropa" kommandot, vilket gör att C-funktionen command_update_digital_out() körs i mikrokontrollern. Det anger också att kommandot har två heltalsparametrar. När C-koden command_update_digital_out() körs får den en matris med de två heltalen: det första motsvarar "oid" och det andra "value".

Parametrarna beskrivs vanligen med printf()-liknande syntax (till exempel "%u"). Formateringen motsvarar direkt den läsbara visningen av kommandon (till exempel "update_digital_out oid=7 value=1"). I exemplet ovan är "value=" ett parameternamn och "%c" anger att parametern är ett heltal. Internt används parameternamnet endast som dokumentation. I exemplet används även "%c" som dokumentation för att ange att det förväntade heltalet är 1 byte stort (den deklarerade heltalsstorleken påverkar inte tolkning eller kodning).

Mikrokontrollerbygget samlar in alla kommandon som deklareras med DECL_COMMAND(), fastställer deras parametrar och gör dem möjliga att anropa.

### Deklarera svar

Ett "svar" skapas för att skicka information från mikrokontrollern till värden. Dessa deklareras och överförs med C-makrot sendf(). Till exempel:

```
sendf("status clock=%u status=%c", sched_read_time(), sched_is_shutdown());
```

Ovanstående överför svarsmeddelandet "status" med två heltalsparametrar ("clock" och "status"). Mikrokontrollerbygget hittar automatiskt alla anrop till sendf() och skapar kodare för dem. Den första parametern till funktionen sendf() beskriver svaret och har samma format som kommandodeklarationer.

Värden kan registrera en återanropsfunktion för varje svar. Kommandon gör alltså att värden kan anropa C-funktioner i mikrokontrollern, och svar gör att mikrokontrollerprogramvaran kan anropa kod i värden.

Makrot sendf() ska endast anropas från kommando- eller aktivitetshanterare, och inte från avbrott eller tidtagare. Koden behöver inte utfärda sendf() som svar på ett mottaget kommando, antalet anrop är inte begränsat och sendf() kan anropas när som helst från en aktivitetshanterare.

#### Utmatningssvar

För att förenkla felsökningen finns även C-funktionen output(). Till exempel:

```
output("The value of %u is %s with size %u.", x, buf, buf_len);
```

Funktionen output() används på samma sätt som printf() och är avsedd att skapa och formatera godtyckliga meddelanden för människor.

### Deklarera uppräkningar

Uppräkningar gör det möjligt för värdkoden att använda strängidentifierare för parametrar som mikrokontrollern hanterar som heltal. De deklareras i mikrokontrollerkoden, till exempel:

```
DECL_ENUMERATION("spi_bus", "spi", 0);

DECL_ENUMERATION_RANGE("pin", "PC0", 16, 8);
```

I det första exemplet definierar makrot DECL_ENUMERATION() en uppräkning för alla kommando-/svarsmeddelanden med parameternamnet "spi_bus" eller ett parameternamn med suffixet "_spi_bus". För dessa parametrar är strängen "spi" ett giltigt värde och överförs med heltalsvärdet noll.

Det går även att deklarera ett uppräkningsintervall. I det andra exemplet skulle parametern "pin" (eller en parameter med suffixet "_pin") acceptera PC0, PC1, PC2, …, PC7 som giltiga värden. Strängarna överförs med heltalen 16, 17, 18, …, 23.

### Deklarera konstanter

Konstanter kan också exporteras. Till exempel följande:

```
DECL_CONSTANT("SERIAL_BAUD", 250000);
```

skulle exportera en konstant med namnet "SERIAL_BAUD" och värdet 250000 från mikrokontrollern till värden. Det går även att deklarera en konstant som är en sträng, till exempel:

```
DECL_CONSTANT_STR("MCU", "pru");
```

## Meddelandekodning på låg nivå

För att uppnå RPC-mekanismen ovan kodas varje kommando och svar i binärt format för överföring. Det här avsnittet beskriver överföringssystemet.

### Meddelandeblock

Alla data som skickas från värden till mikrokontrollern och tvärtom finns i "meddelandeblock". Ett meddelandeblock har ett huvud på två byte och en slutdel på tre byte. Formatet för ett meddelandeblock är:

```
<1 byte length><1 byte sequence><n-byte content><2 byte crc><1 byte sync>
```

Längdbyten innehåller antalet byte i meddelandeblocket, inklusive huvudets och slutdelens byte (minsta meddelandelängd är alltså 5 byte). Den maximala blocklängden är för närvarande 64 byte. Sekvensbyten innehåller ett 4-bitars sekvensnummer i de låga bitarna, och de höga bitarna innehåller alltid 0x10 (de höga bitarna är reserverade för framtida användning). Innehållsbyten kan innehålla godtyckliga data; formatet beskrivs i nästa avsnitt. CRC-byten innehåller 16-bitars CCITT-[CRC](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) för blocket, inklusive huvudets byte men exklusive slutdelens byte. Synkbyten är 0x7e.

Formatet för meddelandeblocket är inspirerat av [HDLC](https://en.wikipedia.org/wiki/High-Level_Data_Link_Control)-ramar. Precis som i HDLC kan blocket valfritt innehålla ett extra synktecken i början. Till skillnad från HDLC är ett synktecken inte begränsat till inramningen utan kan förekomma i blockets innehåll.

### Meddelandeblockets innehåll

Varje meddelandeblock som skickas från värden till mikrokontrollern innehåller noll eller fler meddelandekommandon. Varje kommando börjar med ett [variabel-längd-tal](#variable-length-quantities) (VLQ)-kodat heltalsbaserat kommando-id, följt av noll eller fler VLQ-parametrar för kommandot.

Som exempel kan följande fyra kommandon placeras i ett enda meddelandeblock:

```
update_digital_out oid=6 value=1
update_digital_out oid=5 value=0
get_config
get_clock
```

och kodas till följande åtta VLQ-heltal:

```
<id_update_digital_out><6><1><id_update_digital_out><5><0><id_get_config><id_get_clock>
```

För att koda och tolka meddelandeinnehållet måste värden och mikrokontrollern vara överens om kommando-id:n och antalet parametrar för varje kommando. I exemplet ovan vet därför båda att "id_update_digital_out" alltid följs av två parametrar, och att "id_get_config" och "id_get_clock" har noll parametrar. Värden och mikrokontrollern delar en "dataordlista" som kopplar kommandobeskrivningar (till exempel "update_digital_out oid=%c value=%c") till deras heltalsbaserade kommando-id:n. Vid databehandlingen vet tolken hur många VLQ-kodade parametrar som ska förväntas efter ett givet kommando-id.

Meddelandeinnehållet i block som skickas från mikrokontrollern till värden följer samma format. Identifierarna i dessa meddelanden är "svars-id:n", men har samma funktion och följer samma kodningsregler. I praktiken innehåller meddelandeblock från mikrokontrollern till värden aldrig fler än ett svar i blockinnehållet.

#### Tal med variabel längd

Se [Wikipedia-artikeln](https://en.wikipedia.org/wiki/Variable-length_quantity) för mer information om det allmänna formatet för VLQ-kodade heltal. Klipper använder ett kodningsschema som stöder både positiva och negativa heltal. Heltal nära noll kräver färre byte vid kodning, och positiva heltal kräver vanligtvis färre byte än negativa heltal. Tabellen nedan visar hur många byte varje heltal kräver vid kodning:

| Heltal | Kodad storlek |
| --- | --- |
| -32 .. 95 | 1 |
| -4096 .. 12287 | 2 |
| -524288 .. 1572863 | 3 |
| -67108864 .. 201326591 | 4 |
| -2147483648 .. 4294967295 | 5 |

#### Strängar med variabel längd

Som ett undantag från kodningsreglerna ovan kodas en parameter för ett kommando eller svar som är en dynamisk sträng inte som ett enkelt VLQ-heltal. I stället kodas den genom att längden överförs som ett VLQ-kodat heltal, följt av själva innehållet:

```
<VLQ encoded length><n-byte contents>
```

Kommandobeskrivningarna i dataordlistan låter både värden och mikrokontrollern veta vilka kommandoparametrar som använder enkel VLQ-kodning och vilka som använder strängkodning.

## Dataordlista

För att meningsfull kommunikation ska kunna upprättas mellan mikrokontrollern och värden måste båda sidor vara överens om en "dataordlista". Den innehåller heltalsidentifierarna för kommandon och svar tillsammans med deras beskrivningar.

Mikrokontrollerbygget använder innehållet i makrona DECL_COMMAND() och sendf() för att skapa dataordlistan. Bygget tilldelar automatiskt unika identifierare till varje kommando och svar. Systemet gör att både värd- och mikrokontrollerkoden kan använda beskrivande, läsbara namn utan att använda mer än minimal bandbredd.

Värden frågar efter dataordlistan när den först ansluter till mikrokontrollern. När den har hämtat dataordlistan från mikrokontrollern används den för att koda alla kommandon och tolka alla svar från mikrokontrollern. Värden måste därför hantera en dynamisk dataordlista. För att hålla mikrokontrollerprogramvaran enkel använder mikrokontrollern däremot alltid sin statiska, inbyggda dataordlista.

Dataordlistan efterfrågas genom att skicka "identify"-kommandon till mikrokontrollern. Mikrokontrollern svarar på varje identify-kommando med ett "identify_response"-meddelande. Eftersom dessa två kommandon behövs innan dataordlistan kan hämtas är deras heltals-id:n och parametertyper hårdkodade i både mikrokontrollern och värden. Svars-id:t för "identify_response" är 0 och kommando-id:t för "identify" är 1. Bortsett från de hårdkodade id:na deklareras och överförs identify-kommandot och dess svar på samma sätt som andra kommandon och svar. Inga andra kommandon eller svar är hårdkodade.

Formatet för den överförda dataordlistan är en zlib-komprimerad JSON-sträng. Mikrokontrollerbygget skapar strängen, komprimerar den och lagrar den i textavsnittet av mikrokontrollerns flashminne. Dataordlistan kan vara mycket större än maximal blockstorlek, så värden hämtar den genom att skicka flera identify-kommandon som efterfrågar successiva delar av dataordlistan. När alla delar har hämtats sammanfogar värden dem, packar upp data och tolkar innehållet.

Utöver information om kommunikationsprotokollet innehåller dataordlistan även programvaruversionen, uppräkningar (enligt DECL_ENUMERATION) och konstanter (enligt DECL_CONSTANT).

## Meddelandeflöde

Meddelandekommandon från värden till mikrokontrollern är avsedda att vara felfria. Mikrokontrollern kontrollerar CRC och sekvensnummer i varje meddelandeblock för att säkerställa att kommandona är korrekta och i rätt ordning. Mikrokontrollern behandlar alltid block i ordning; om den tar emot ett block i fel ordning förkastar den det och andra block i fel ordning tills block med korrekt sekvensering tas emot.

Värdkoden på låg nivå har ett automatiskt omsändningssystem för förlorade eller skadade block som skickas till mikrokontrollern. För att stödja detta skickar mikrokontrollern ett "ack-meddelandeblock" efter varje korrekt mottaget block. Värden ställer in en tidsgräns efter att ha skickat varje block och sänder om det om tidsgränsen löper ut utan ett motsvarande "ack". Om mikrokontrollern upptäcker ett skadat block eller ett block i fel ordning kan den dessutom skicka ett "nak-meddelandeblock" för att påskynda omsändningen.

Ett "ack" är ett meddelandeblock med tomt innehåll (det vill säga ett block på 5 byte) och ett sekvensnummer som är större än det senast mottagna värdsekvensnumret. Ett "nak" är ett block med tomt innehåll och ett sekvensnummer som är mindre än det senast mottagna värdsekvensnumret.

Protokollet har ett överföringssystem med ett "fönster", så att värden kan ha många utestående meddelandeblock under överföring samtidigt. (Detta utöver de många kommandon som kan finnas i ett visst block.) Det möjliggör maximal bandbreddsanvändning även vid överföringslatens. Mekanismerna för tidsgräns, omsändning, fönster och ack är inspirerade av motsvarande mekanismer i [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol).

I den andra riktningen är meddelandeblock från mikrokontrollern till värden avsedda att vara felfria, men överföringen garanteras inte. (Svar ska inte vara skadade, men kan saknas.) Detta håller implementationen i mikrokontrollern enkel. Det finns inget automatiskt omsändningssystem för svar; koden på hög nivå måste kunna hantera ett enstaka saknat svar, vanligen genom att efterfråga innehållet igen eller upprätta en återkommande schemalagd överföring av svar. Sekvensnumret i block som skickas till värden är alltid ett större än det senaste mottagna sekvensnumret för block från värden. Det används inte för att följa sekvenser av svarsblock.
