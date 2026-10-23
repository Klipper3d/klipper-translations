# Felsökning

Det här dokumentet beskriver några av Klippers felsökningsverktyg.

## Köra regressionstesterna

Klippers huvudsakliga GitHub-förråd använder "GitHub Actions" för att köra en serie regressionstester. Det kan vara användbart att köra några av testerna lokalt.

Källkodens "kontroll av blanksteg" kan köras med:

```
./scripts/check_whitespace.sh
```

Klippys regressionstestsamling kräver "dataordlistor" från många plattformar. Det enklaste sättet att få dem är att [hämta dem från GitHub](https://github.com/Klipper3d/klipper/issues/1438). När dataordlistorna har hämtats använder du följande för att köra regressionstesterna:

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## Skicka kommandon manuellt till mikrokontrollern

Normalt används värdprocessen klippy.py för att översätta gcode-kommandon till Klipper-kommandon för mikrokontrollern. Det går dock även att skicka dessa MCU-kommandon manuellt (funktioner som är markerade med makrot DECL_COMMAND() i Klippers källkod). Kör då:

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

Se kommandot "HELP" i verktyget för mer information om dess funktioner.

Flera kommandoradsalternativ är tillgängliga. Kör `~/klippy-env/bin/python ./klippy/console.py --help` för mer information.

## Översätta gcode-filer till mikrokontrollerkommandon

Klippys värdkod kan köras i batchläge för att skapa de mikrokontrollerkommandon på låg nivå som hör till en gcode-fil. Att granska dessa kommandon är användbart när du vill förstå hur maskinvaran på låg nivå fungerar. Det kan även vara användbart att jämföra skillnaden i mikrokontrollerkommandon efter en kodändring.

För att köra Klippy i batchläge krävs först ett engångssteg för att skapa mikrokontrollerns "dataordlista". Kompilera mikrokontrollerkoden för att få filen **out/klipper.dict**:

```
make menuconfig
make
```

När detta är gjort kan Klipper köras i batchläge (se [installation](Installation.md) för stegen som krävs för att skapa den virtuella Python-miljön och en printer.cfg-fil):

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

Ovanstående skapar filen **test.serial** med binära seriella utdata. Dessa utdata kan översättas till läsbar text med:

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

Den resulterande filen **test.txt** innehåller en människoläsbar lista över mikrokontrollerkommandon.

Batchläget inaktiverar vissa svars- och begärandekommandon för att fungera. Därför finns vissa skillnader mellan verkliga kommandon och utdata ovan. De skapade data är användbara för testning och granskning, men inte för att skicka till en verklig mikrokontroller.

## Rörelseanalys och dataloggning

Klipper kan logga sin interna rörelsehistorik, som sedan kan analyseras. För att använda funktionen måste Klipper startas med [API Server](API_Server.md) aktiverad.

Dataloggning aktiveras med verktyget `data_logger.py`. Till exempel:

```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog -s '*'
```

Kommandot ansluter till Klipper API Server, prenumererar på status- och rörelseinformation och loggar resultatet. Två filer skapas: en komprimerad datafil och en indexfil (till exempel `mylog.json.gz` och `mylog.index.gz`). Efter att loggningen har startats kan utskrifter och andra åtgärder genomföras; loggningen fortsätter i bakgrunden. Tryck på `ctrl-c` för att avsluta `data_logger.py` när loggningen är klar.

De resulterande filerna kan läsas och visualiseras med verktyget `motan_graph.py`. För att skapa diagram på en Raspberry Pi krävs ett engångssteg för att installera paketet "matplotlib":

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Det kan dock vara smidigare att kopiera datafilerna till en stationär dator, tillsammans med Python-koden i katalogen `scripts/motan/`. Rörelseanalyskripten bör kunna köras på en dator med en aktuell version av [Python](https://python.org) och [Matplotlib](https://matplotlib.org/) installerad.

Diagram kan skapas med ett kommando som följande:

```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

Alternativet `-g` kan användas för att ange de datamängder som ska ritas upp (det tar en Python-literal med en lista av listor). Till exempel:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

Listan över tillgängliga datamängder visas med alternativet `-l`, till exempel:

```
~/klipper/scripts/motan/motan_graph.py -l
```

Det går även att ange ritningsalternativ för matplotlib för varje datamängd:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```

Många alternativ för matplotlib är tillgängliga, till exempel "color", "label", "alpha" och "linestyle".

Verktyget `motan_graph.py` har flera andra kommandoradsalternativ; använd alternativet `--help` för att se en lista. Det kan också vara praktiskt att visa eller ändra själva skriptet [motan_graph.py](../scripts/motan/motan_graph.py).

Rådata-loggarna som skapas av `data_logger.py` följer formatet som beskrivs i [API Server](API_Server.md). Det kan vara användbart att granska data med ett Unix-kommando som följande: `gunzip < mylog.json.gz | tr '\03' '\n' | less`

## Skapa belastningsdiagram

Klippys loggfil (/tmp/klippy.log) lagrar statistik om bandbredd, mikrokontrollerbelastning och värdbuffertbelastning. Det kan vara användbart att rita diagram över statistiken efter en utskrift.

För att skapa ett diagram krävs ett engångssteg för att installera paketet "matplotlib":

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Diagram kan sedan skapas med:

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

Därefter kan den resulterande filen **loadgraph.png** visas.

Olika diagram kan skapas. Kör `~/klipper/scripts/graphstats.py --help` för mer information.

## Hämta information från filen klippy.log

Klippys loggfil (/tmp/klippy.log) innehåller även felsökningsinformation. Skriptet logextract.py kan vara användbart när en avstängning av en mikrokontroller eller ett liknande problem analyseras. Det körs normalt ungefär så här:

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

Skriptet hämtar skrivarens konfigurationsfil och MCU-information om avstängning. Informationsdumpar från en MCU-avstängning (om sådana finns) sorteras om efter tidsstämpel för att underlätta felsökning av orsak och verkan.

## Testning med simulavr

Verktyget [simulavr](http://www.nongnu.org/simulavr/) gör det möjligt att simulera en Atmel ATmega-mikrokontroller. Det här avsnittet beskriver hur testgcode-filer kan köras genom simulavr. Kör det helst på en stationär dator (inte en Raspberry Pi), eftersom effektiv körning kräver betydande processorkraft.

Hämta paketet simulavr och kompilera med Python-stöd för att använda simulavr. Observera att byggsystemet kan behöva ha vissa paket (som swig) installerade för att kunna bygga Python-modulen.

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```

Kontrollera att en fil som **./build/pysimulavr/_pysimulavr.*.so** finns efter kompileringen ovan:

```
ls ./build/pysimulavr/_pysimulavr.*.so
```

Kommandot bör rapportera en specifik fil (till exempel **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**) och inte ett fel.

På ett Debian-baserat system (Debian, Ubuntu osv.) kan följande paket installeras och *.deb-filer skapas för systemomfattande installation av simulavr:

```
sudo apt update
sudo apt install g++ make cmake swig rst2pdf help2man texinfo
make cfgclean python debian
sudo dpkg -i build/debian/python3-simulavr*.deb
```

Kör följande för att kompilera Klipper för användning med simulavr:

```
cd /path/to/klipper
make menuconfig
```

och kompilera mikrokontrollerprogramvaran för en AVR atmega644p samt välj stöd för programvaruemuleringen SIMULAVR. Kompilera sedan Klipper (kör `make`) och starta simuleringen med:

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

Observera att om python3-simulavr har installerats systemomfattande behöver du inte ange `PYTHONPATH` och kan köra simulatorn direkt som

```
./scripts/avrsim.py out/klipper.elf
```

När simulavr körs i ett annat fönster kan följande användas för att läsa gcode från en fil (till exempel "test.gcode"), bearbeta den med Klippy och skicka den till Klipper som körs i simulavr (se [installation](Installation.md) för stegen som krävs för att skapa den virtuella Python-miljön):

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### Använda simulavr med gtkwave

En användbar funktion i simulavr är möjligheten att skapa signalkurvfiler med exakt tidsangivelse för händelser. Följ anvisningarna ovan, men kör avrsim.py med en kommandorad som följande:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

Ovanstående skapar filen **avrsim.vcd** med information om varje ändring av GPIO:er på PORTA och PORTB. Den kan sedan visas i gtkwave med:

```
gtkwave avrsim.vcd
```
