# SD-kortsuppdateringar

Många populära styrkort levereras i dag med en starthanterare som kan uppdatera fast programvara via SD-kort. Det är praktiskt i många situationer, men dessa starthanterare erbjuder vanligen inget annat sätt att uppdatera den fasta programvaran. Det kan vara besvärligt om kortet är monterat på en svåråtkomlig plats eller om den fasta programvaran måste uppdateras ofta. När Klipper först har flashats till en styrenhet kan ny fast programvara överföras till SD-kortet och flashningsproceduren startas via SSH.

## Typisk uppdateringsprocedur

Proceduren för att uppdatera MCU:ns fasta programvara med SD-kort liknar andra metoder. I stället för `make flash` måste hjälpskriptet `flash-sdcard.sh` köras. Uppdatering av en BigTreeTech SKR 1.3 kan exempelvis se ut så här:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-skr-v1.3
sudo service klipper start
```

Det är användarens ansvar att fastställa enhetens sökväg och kortets namn. Om flera kort måste flashas ska `flash-sdcard.sh`, eller `make flash` när det är lämpligt, köras för varje kort innan Klipper-tjänsten startas om.

Kort som stöds kan listas med följande kommando:

```
./scripts/flash-sdcard.sh -l
```

Om kortet inte visas i listan kan en ny kortdefinition behöva läggas till enligt [beskrivningen nedan](#board-definitions).

## Avancerad användning

Kommandona ovan förutsätter att MCU:n ansluter med standardhastigheten 250000 baud och att den fasta programvaran finns i `~/klipper/out/klipper.bin`. Skriptet `flash-sdcard.sh` har alternativ för att ändra dessa standardvärden. Alla alternativ visas på hjälpskärmen:

```
./scripts/flash-sdcard.sh -h
SD Card upload utility for Klipper

usage: flash_sdcard.sh [-h] [-l] [-c] [-s] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -c              run flash check/verify only (skip upload)
  -s              use fast SPI speed (4MHz)
  -b <baud>       serial baud rate (default is 250000)
  -f <firmware>   path to klipper.bin
```

Om kortet är flashat med fast programvara som ansluter med en anpassad baudhastighet kan den uppdateras genom att ange alternativet `-b`:

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

Om en Klipper-byggning som finns på en annan plats än standardplatsen ska flashas kan det göras genom att ange alternativet `-f`:

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

Vid uppdatering av en MKS Robin E3 behöver `update_mks_robin.py` inte köras manuellt och den resulterande binärfilen inte heller anges till `flash-sdcard.sh`. Proceduren automatiseras under uppladdningen.

Alternativet `-c` används för att utföra en kontroll eller enbart verifiering, för att testa om kortet kör den angivna fasta programvaran korrekt. Det är främst avsett för fall där en manuell strömcykel krävs för att slutföra flashningen, exempelvis när starthanteraren använder SDIO-läge i stället för SPI för att komma åt SD-kortet. Se varningarna nedan. Det kan också användas när som helst för att kontrollera om koden som flashats till kortet stämmer med versionen i byggmappen på ett kort som stöds.

## Misslyckad initiering

Vissa SD-kort kan misslyckas med initiering vid SPI-standardhastigheten 400 kHz. I den situationen går det att använda `-s` för att driva SPI-kringutrustningen med 4 MHz. Till exempel:

```
./scripts/flash-sdcard.sh -s /dev/ttyACM0 btt-skr-v1.3
```

Om enheten fortfarande inte kan initieras beror felet inte på hastigheten, utan sannolikt på ett av följande förhållanden:

- SD-kortet är felaktigt formaterat. Det måste vara `fat` eller `fat32`.
- Försök att initiera ett kort med SPI-gränssnittet som redan har initierats över SDIO.
- SD-kortet har gått sönder eller är skadat.

## Begränsningar

- Som nämnts i inledningen fungerar denna metod endast för uppdatering av fast programvara. Den första flashningen måste göras manuellt enligt instruktionerna för ditt styrkort.
- Det går att flasha en byggning som ändrar seriell baudhastighet eller anslutningsgränssnitt, till exempel från USB till UART, men verifieringen misslyckas alltid eftersom skriptet inte kan återansluta till MCU:n för att kontrollera den aktuella versionen.
- Endast kort som använder SPI för kommunikation med SD-kortet stöds. Kort som använder SDIO, exempelvis Flymaker Flyboard och MKS Robin Nano V1/V2, fungerar inte i SDIO-läge. Sådana kort kan dock vanligen flashas med SPI-läget i programvara. Om kortets starthanterare endast använder SDIO-läge för att komma åt SD-kortet krävs en strömcykel för både kortet och SD-kortet, så att läget kan växla från SPI tillbaka till SDIO för att slutföra flashningen. Sådana kort ska definieras med `skip_verify` aktiverat så att verifieringssteget hoppas över direkt efter flashningen. Efter den manuella strömcykeln kan exakt samma kommando `./scripts/flash-sdcard.sh` köras igen med alternativet `-c` för att slutföra kontrollen eller verifieringen. Se [Flasha kort som använder SDIO](#flashing-boards-that-use-sdio) för exempel.

## Kortdefinitioner

De vanligaste korten bör redan finnas tillgängliga, men vid behov går det att lägga till en ny kortdefinition. Kortdefinitionerna finns i `~/klipper/scripts/spi_flash/board_defs.py`. Definitionerna lagras i en ordbok, till exempel:

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<further definitions>
}
```

Följande fält kan anges:

- `mcu`: MCU-typen. Den kan hämtas efter att byggningen har konfigurerats via `make menuconfig` genom att köra `cat .config | grep CONFIG_MCU`. Fältet krävs.
- `spi_bus`: SPI-bussen som är ansluten till SD-kortet. Den ska hämtas från kortets schema. Fältet krävs.
- `cs_pin`: Chip Select-stiftet som är anslutet till SD-kortet. Det ska hämtas från kortets schema. Fältet krävs.
- `firmware_path`: Sökvägen på SD-kortet dit den fasta programvaran ska överföras. Standardvärdet är `firmware.bin`.
- `current_firmware_path`: Sökvägen på SD-kortet där den omdöpta fasta programvarufilen finns efter lyckad flashning. Standardvärdet är `firmware.cur`.
- `skip_verify`: Anger ett booleskt värde som talar om för skripten att hoppa över steget för verifiering av fast programvara under flashningen. Standardvärdet är `False`. Det kan sättas till `True` för kort som kräver en manuell strömcykel för att slutföra flashningen. För att verifiera den fasta programvaran efteråt kör du skriptet igen med alternativet `-c`. [Se varningar för SDIO-kort](#caveats)

Om SPI i programvara krävs ska fältet `spi_bus` sättas till `swspi` och följande ytterligare fält anges:

- `spi_pins`: Tre kommaavgränsade stift som är anslutna till SD-kortet, i formatet `miso,mosi,sclk`.

Det bör vara mycket ovanligt att SPI i programvara behövs. Normalt krävs det bara av kort med konstruktionsfel eller kort som vanligen endast stöder SDIO-läge för SD-kortet. Kortdefinitionen `btt-skr-pro` visar det förstnämnda och `btt-octopus-f446-v1` det sistnämnda.

Innan en ny kortdefinition skapas bör du kontrollera om en befintlig definition uppfyller kraven för det nya kortet. I så fall kan `BOARD_ALIAS` anges. Följande alias kan till exempel läggas till för att ange `my-new-board` som alias för `generic-lpc1768`:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Om du behöver en ny kortdefinition och inte är bekväm med proceduren ovan rekommenderas att du begär en i [Klipper Discord](Contact.md).

## Flasha kort som använder SDIO

Som [nämnts i varningarna](#caveats) kräver kort vars starthanterare använder SDIO-läge för att komma åt SD-kortet en strömcykel för kortet och särskilt för själva SD-kortet. Det behövs för att växla från SPI-läget, som används när filen skrivs till SD-kortet, tillbaka till SDIO-läge så att starthanteraren kan flasha in den på kortet. Dessa kortdefinitioner använder flaggan `skip_verify`, som gör att flashningsverktyget stannar efter att den fasta programvaran skrivits till SD-kortet så att kortet kan strömcyklas manuellt och verifieringssteget skjuts upp tills det är klart.

Det finns två scenarier: ett där RPi-värden körs med en separat strömförsörjning och ett där RPi-värden körs med samma strömförsörjning som huvudkortet som flashas. Skillnaden är om RPi också måste stängas av och sedan anslutas med `ssh` igen efter flashningen för att verifiera, eller om verifieringen kan göras direkt. Här är exempel på de två scenarierna:

### SDIO-programmering med RPi på separat strömförsörjning

En typisk session med RPi på separat strömförsörjning ser ut så här. Du måste naturligtvis använda rätt enhetssökväg och kortnamn:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
[[[manually power-cycle the printer board here when instructed]]]
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

### SDIO-programmering med RPi på samma strömförsörjning

En typisk session med RPi på samma strömförsörjning ser ut så här. Du måste naturligtvis använda rätt enhetssökväg och kortnamn:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
sudo shutdown -h now
[[[wait for the RPi to shutdown, then power-cycle and ssh again to the RPi when it restarts]]]
sudo service klipper stop
cd ~/klipper
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

I detta fall startas RPi-värden om, vilket även startar om tjänsten `klipper`. Därför måste `klipper` stoppas igen före verifieringssteget och startas om när verifieringen är klar.

### Mappning från SDIO- till SPI-stift

Om kortets schema använder SDIO för SD-kortet kan stiften mappas enligt tabellen nedan för att fastställa kompatibla SPI-stift i programvara, som ska anges i filen `board_defs.py`:

| SD-kortsstift | MicroSD-kortsstift | SDIO-stiftnamn | SPI-stiftnamn |
| :-: | :-: | :-: | :-: |
| 9 | 1 | DATA2 | Ingen (PU)* |
| 1 | 2 | CD/DATA3 | CS |
| 2 | 3 | CMD | MOSI |
| 4 | 4 | +3,3 V (VDD) | +3,3 V (VDD) |
| 5 | 5 | CLK | SCLK |
| 3 | 6 | GND (VSS) | GND (VSS) |
| 7 | 7 | DATA0 | MISO |
| 8 | 8 | DATA1 | Ingen (PU)* |
| Ej tillämpligt | 9 | Kortavkänning (CD) | Kortavkänning (CD) |
| 6 | 10 | GND | GND |

\* Ingen (PU) anger ett oanvänt stift med pullup-motstånd
