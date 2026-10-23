# Felsökning av CAN-bus

Detta dokument innehåller information om felsökning av kommunikationsproblem vid användning av [Klipper med CAN-bus](CANBUS.md).

## Kontrollera CAN-buskablage

Det första steget vid felsökning av kommunikationsproblem är att kontrollera CAN-buskablaget.

Be sure there are exactly two 120 Ohm [terminating
resistors](CANBUS.md#terminating-resistors) on the CAN bus. If the resistors are not properly installed then messages may not be able to be sent at all or the connection may have sporadic instability.

CANH- och CANL-ledarna ska vara tvinnade runt varandra. Kablaget bör minst ha en tvinning varannan eller var tredje centimeter. Undvik att tvinna CANH- och CANL-ledarna runt strömledningar, och se till att parallella strömledningar inte har lika många tvinningar.

Kontrollera att alla kontakter och kabelpressningar i CAN-buskablaget sitter ordentligt. Skrivarens verktygshuvud kan rycka i CAN-buskablaget, så en dålig kabelpressning eller lös kontakt kan orsaka intermittenta kommunikationsfel.

## Kontrollera om räknaren bytes_invalid ökar

Klippers loggfil rapporterar en `Stats`-rad en gång per sekund när skrivaren är aktiv. Dessa "Stats"-rader har en `bytes_invalid`-räknare för varje mikrokontroller. Räknaren ska inte öka vid normal skrivardrift (det är normalt att räknaren inte är noll efter RESTART, och det är inget problem om den ökar ungefär en gång i månaden). Om räknaren ökar för en CAN-busmikrokontroller under normal utskrift, var några timme eller oftare, tyder det på ett allvarligt problem.

En ökande `bytes_invalid` på en CAN-bussanslutning tyder på omordnade meddelanden på CAN-bussen. Om det inträffar, kontrollera följande:

* Använd Linux-kärnan version 6.6.0 eller senare.
* Om du använder en USB-till-CANBUS-adapter med candlelight-firmware ska du använda candleLight_fw v2.0 eller senare.
* Om du använder Klippers bryggläge USB-till-CANBUS ska bryggnoden vara flashad med Klipper v0.12.0 eller senare.

Omordnade meddelanden är ett allvarligt problem som måste åtgärdas. Det gör beteendet instabilt och kan orsaka svårtolkade fel var som helst under en utskrift. En ökande `bytes_invalid` beror inte på kablaget eller liknande maskinvarufel utan kan endast åtgärdas genom att identifiera och uppdatera den felaktiga programvaran.

Äldre Linux-kärnor hade ett fel i CAN-busdrivrutinen gs_usb som kunde orsaka omordnade CAN-buspaket. Felet anses vara åtgärdat i [Linux-commit 24bc41b4](https://github.com/torvalds/linux/commit/24bc41b4558347672a3db61009c339b1f5692169), som släpptes i v6.6.0. Äldre Linux-versioner kan i vissa fall dölja problemet beroende på hur maskinvaruavbrott är konfigurerade, men om problem uppstår är den rekommenderade lösningen att uppgradera kärnan.

Äldre versioner av candlelight-firmware kunde ordna om CAN-buspaket. Felet anses vara åtgärdat i [candlelight_fw-commit 8b3a7b45](https://github.com/candle-usb/candleLight_fw/commit/8b3a7b4565a3c9521b762b154c94c72c5acb2bcf).

Äldre versioner av Klippers bryggkod för USB-till-CANBUS kunde felaktigt släppa CAN-busmeddelanden. Det är inte lika allvarligt som omordnade meddelanden, men bör ändå åtgärdas. Felet anses vara åtgärdat i [Klipper-PR #6175](https://github.com/Klipper3d/klipper/pull/6175).

## Använd en lämplig txqueuelen-inställning

Klipper använder Linux-kärnan för att hantera CAN-busstrafik. Som standard köar kärnan endast tio CAN-sändpaket. Vi rekommenderar att du [konfigurerar can0-enheten](CANBUS.md#host-hardware) med `txqueuelen 128` för att öka köns storlek.

Om Klipper sänder ett paket när Linux sändkö är full kastar Linux paketet och följande typ av meddelande visas i Klippers logg:

```
Got error -1 in can write: (105)No buffer space available
```

Klipper sänder automatiskt om förlorade meddelanden som en del av sitt normala omsändningssystem på programnivå. Loggmeddelandet är alltså en varning och anger inte ett fel som inte kan återställas.

Vid ett totalt CAN-bussfel, exempelvis ett kabelbrott, kan Linux inte sända några meddelanden på CAN-bussen och meddelandet ovan syns ofta i Klippers logg. Då är loggmeddelandet ett symptom på ett större problem – att inga meddelanden kan sändas – och inte direkt kopplat till Linux `txqueuelen`.

Du kan kontrollera den aktuella köstorleken med Linux-kommandot `ip link show can0`. Utdata ska bland annat innehålla `qlen 128`. Om den i stället visar något som `qlen 10` har CAN-enheten inte konfigurerats korrekt.

Det rekommenderas inte att använda `txqueuelen` som är mycket större än 128. En CAN-buss med frekvensen 1 000 000 behöver normalt omkring 120 us för att sända ett CAN-paket. En kö med 128 paket töms därför på cirka 15–20 ms. En betydligt större kö kan ge kraftiga toppar i meddelandens tur-och-retur-tid, vilket kan leda till fel som inte kan återställas. Klippers omsändningssystem är mer robust när det inte behöver vänta på att Linux ska tömma en alltför stor kö med eventuellt inaktuella data. Detta motsvarar problemet med [bufferbloat](https://en.wikipedia.org/wiki/Bufferbloat) i internetroutrar.

Under normala förhållanden använder Klipper omkring 25 köplatser per MCU och använder vanligtvis fler endast vid omsändningar. Klipper-värden kan särskilt sända upp till 192 byte till varje Klipper-MCU innan den får ett kvitto. Om en CAN-buss har fem eller fler Klipper-MCU:er kan `txqueuelen` behöva ökas över det rekommenderade värdet 128. Välj dock värdet varsamt för att undvika hög latens för tur-och-retur-tid.

## Använd endast `canbus_query.py` för att identifiera tidigare okända noder

Det är endast giltigt att använda [verktyget `canbus_query.py`](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) för att identifiera mikrokontrollers som inte tidigare har identifierats. När alla noder på en buss är identifierade ska de resulterande uuid:erna sparas i printer.cfg; undvik sedan att köra verktyget i onödan.

Verktyget använder en mekanism på låg nivå som kan få noder att internt observera bussfel. Felen kan ge kommunikationsavbrott och leda till att vissa noder kopplas från bussen.

Det är inte giltigt att använda verktyget för att "pinga" en ansluten nod. Kör inte verktyget under en pågående utskrift.

## Hämta candump-loggar

CAN-busmeddelanden till och från mikrokontrollern hanteras av Linux-kärnan. Du kan fånga dessa meddelanden från kärnan för felsökning. En logg över meddelandena kan vara användbar vid diagnostik.

Linux-verktyget [can-utils](https://github.com/linux-can/can-utils) innehåller programvaran för insamling. Det installeras vanligen på datorn genom att köra:

```
sudo apt-get update && sudo apt-get install can-utils
```

När det är installerat kan du fånga alla CAN-busmeddelanden på ett gränssnitt med följande kommando:

```
candump -tz -Ddex can0,#FFFFFFFF > mycanlog
```

Du kan visa den resulterande loggfilen (`mycanlog` i exemplet ovan) för att se varje rått CAN-busmeddelande som Klipper skickade och tog emot. För att förstå innehållet krävs sannolikt kunskap på låg nivå om Klippers [CAN-busprotokoll](CANBUS_protocol.md) och [MCU-kommandon](MCU_Commands.md).

### Tolka Klipper-meddelanden i en candump-logg

Du kan använda verktyget `parsecandump.py` för att tolka Klippers mikrokontrollermeddelanden på låg nivå i en candump-logg. Verktyget är för avancerade användare och kräver kunskap om Klippers [MCU-kommandon](MCU_Commands.md). Exempel:

```
./scripts/parsecandump.py mycanlog 108 ./out/klipper.dict
```

This tool produces output similar to the [parsedump
tool](Debugging.md#translating-gcode-files-to-micro-controller-commands). See the documentation for that tool for information on generating the Klipper micro-controller data dictionary.

In the above example, `108` is the [CAN bus
id](CANBUS_protocol.md#micro-controller-id-assignment). It is a hexadecimal number. The id `108` is assigned by Klipper to the first micro-controller. If the CAN bus has multiple micro-controllers on it, then the second micro-controller would be `10a`, the third would be `10c`, and so on.

Candump-loggen måste skapas med kommandoradsargumenten `-tz -Ddex` (till exempel `candump -tz -Ddex can0,#FFFFFFFF`) för att kunna användas med `parsecandump.py`.

## Använda en logikanalysator på CAN-buskablaget

[Sigrok Pulseview](https://sigrok.org/wiki/PulseView) tillsammans med en billig [logikanalysator](https://en.wikipedia.org/wiki/Logic_analyzer) kan användas för att diagnostisera CAN-bussignaler. Detta är ett avancerat ämne som främst är relevant för experter.

Det går ofta att hitta "USB-logikanalysatorer" för mindre än 15 USD (amerikanskt pris 2023). De säljs ofta som "Saleae logic clones" eller "24 MHz 8 channel USB logic analyzers".

![pulseview-canbus](img/pulseview-canbus.png)

Bilden ovan togs när Pulseview användes med en logikanalysator av typen "Saleae clone". Sigrok och Pulseview installerades på en stationär dator (installera även firmwaret "fx2lafw" om det paketeras separat). Logikanalysatorns CH0-stift anslöts till CAN Rx-ledningen, CH1 till CAN Tx-ledningen och GND till GND. Pulseview konfigurerades för att endast visa D0- och D1-ledningarna (den röda ikonen "probe" mitt på det övre verktygsfältet). Antalet samplingar sattes till 5 miljoner och samplingshastigheten till 24 MHz, båda i det övre verktygsfältet. CAN-avkodaren lades till via den gula och gröna ikonen "bubble icon" högst upp till höger. D0-kanalen märktes RX och ställdes in för utlösning vid fallande flank (klicka på den svarta D0-etiketten till vänster). D1-kanalen märktes TX (klicka på den bruna D1-etiketten till vänster). CAN-avkodaren konfigurerades för 1 Mbit (klicka på den gröna CAN-etiketten till vänster) och flyttades högst upp i vyn genom att dra den gröna CAN-etiketten. Slutligen startades insamlingen genom att klicka på "Run" längst upp till vänster och ett paket sändes på CAN-bussen med `cansend can0 123#121212121212`.

Logikanalysatorn är ett oberoende verktyg för att fånga paket och kontrollera bittimingen.
