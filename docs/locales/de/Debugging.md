# Fehlersuche

Dieses Dokument beschreibt einige der Klipper-Debugging-Werkzeuge.

## Durchführung der Regressionstests

Das Haupt-GitHub-Repository von Klipper verwendet "GitHub Actions", um eine Reihe von Regressionstests auszuführen. Es kann nützlich sein, einige dieser Tests lokal auszuführen.

Die "Whitespace-Prüfung" des Quellcodes kann wie folgt ausgeführt werden:

```
./scripts/check_whitespace.sh
```

Die Klippy-Regressionstestsuite benötigt "Datenwörterbücher" von vielen Plattformen. Am einfachsten erhalten Sie diese, indem Sie sie [von GitHub herunterladen](https://github.com/Klipper3d/klipper/issues/1438). Sobald die Datenwörterbücher heruntergeladen sind, führen Sie Folgendes aus, um die Regressionssuite auszuführen:

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## Befehle manuell an den Mikrocontroller senden

Normalerweise übersetzt der Host-Prozess klippy.py G-Code-Befehle in Klipper-Mikrocontroller-Befehle. Es ist jedoch auch möglich, diese MCU-Befehle (Funktionen, die im Klipper-Quellcode mit dem Makro DECL_COMMAND() markiert sind) manuell zu senden. Führen Sie dazu aus:

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

Weitere Informationen zur Funktionsweise finden Sie im Befehl "HELP" innerhalb des Werkzeugs.

Einige Kommandozeilenoptionen sind verfügbar. Weitere Informationen erhalten Sie mit: `~/klippy-env/bin/python ./klippy/console.py --help`

## Übersetzen von Gcode-Dateien in Mikrocontroller-Befehle

Der Klippy-Hostcode kann im Batch-Modus ausgeführt werden, um die auf eine gcode-Datei bezogenen Low-Level-Microcontroller-Befehle zu generieren. Das Untersuchen dieser Low-Level-Befehle ist nützlich, wenn man versucht, das Verhalten der Low-Level-Hardware zu verstehen. Es kann auch nützlich sein, um den Unterschied in den Microcontroller-Befehlen nach einer Code-Änderung zu vergleichen.

Um Klippy in diesem Batch-Modus auszuführen, ist ein einmaliger Schritt zur Erzeugung des "Datenwörterbuchs" des Mikrocontrollers notwendig. Dies geschieht durch Kompilieren des Mikrocontroller-Codes, um die Datei **out/klipper.dict** zu erhalten:

```
make menuconfig
make
```

Sobald dies erledigt ist, kann Klipper im Batch-Modus ausgeführt werden (siehe [Installation](Installation.md) für die notwendigen Schritte zum Erstellen der Python-Virtual-Environment und einer printer.cfg-Datei):

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

Das Obige erzeugt eine Datei **test.serial** mit der binären seriellen Ausgabe. Diese Ausgabe kann wie folgt in lesbaren Text übersetzt werden:

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

Die resultierende Datei **test.txt** enthält eine menschenlesbare Liste von Mikrocontroller-Befehlen.

Der Batch-Modus deaktiviert bestimmte Antwort-/Anfragebefehle, um funktionieren zu können. Dadurch gibt es einige Unterschiede zwischen den tatsächlichen Befehlen und der obigen Ausgabe. Die erzeugten Daten sind für Tests und Inspektion nützlich; sie eignen sich jedoch nicht dazu, an einen echten Mikrocontroller gesendet zu werden.

## Bewegungsanalyse und Datenerfassung

Klipper unterstützt die Protokollierung seiner internen Bewegungshistorie, die später analysiert werden kann. Um diese Funktion zu nutzen, muss Klipper mit aktiviertem [API-Server](API_Server.md) gestartet werden.

Die Datenprotokollierung wird mit dem Werkzeug `data_logger.py` aktiviert. Zum Beispiel:

```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog -s '*'
```

Dieser Befehl verbindet sich mit dem Klipper-API-Server, abonniert Status- und Bewegungsinformationen und protokolliert die Ergebnisse. Es werden zwei Dateien erzeugt - eine komprimierte Datendatei und eine Indexdatei (z. B. `mylog.json.gz` und `mylog.index.gz`). Nach dem Start der Protokollierung können Drucke und andere Aktionen abgeschlossen werden - die Protokollierung läuft im Hintergrund weiter. Ist die Protokollierung abgeschlossen, drücken Sie `Strg+C`, um das Werkzeug `data_logger.py` zu beenden.

Die resultierenden Dateien können mit dem Werkzeug `motan_graph.py` gelesen und grafisch dargestellt werden. Um auf einem Raspberry Pi Diagramme zu erzeugen, ist einmalig die Installation des Pakets "matplotlib" notwendig:

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Es kann jedoch praktischer sein, die Datendateien zusammen mit dem Python-Code im Verzeichnis `scripts/motan/` auf einen Desktop-Rechner zu kopieren. Die Bewegungsanalyse-Skripte sollten auf jedem Rechner mit einer aktuellen Version von [Python](https://python.org) und [Matplotlib](https://matplotlib.org/) laufen.

Diagramme können mit einem Befehl wie dem folgenden erzeugt werden:

```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

Mit der Option `-g` können die darzustellenden Datensätze angegeben werden (sie erwartet ein Python-Literal mit einer Liste von Listen). Zum Beispiel:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

Die Liste der verfügbaren Datensätze lässt sich mit der Option `-l` ermitteln - zum Beispiel:

```
~/klipper/scripts/motan/motan_graph.py -l
```

Es ist auch möglich, für jeden Datensatz matplotlib-Plot-Optionen anzugeben:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```

Viele matplotlib-Optionen sind verfügbar; einige Beispiele sind "color", "label", "alpha" und "linestyle".

Das Werkzeug `motan_graph.py` unterstützt mehrere weitere Kommandozeilenoptionen - verwenden Sie die Option `--help`, um eine Liste anzuzeigen. Es kann außerdem praktisch sein, das Skript [motan_graph.py](../scripts/motan/motan_graph.py) selbst anzusehen bzw. anzupassen.

Die von `data_logger.py` erzeugten Rohdatenprotokolle folgen dem im [API-Server](API_Server.md) beschriebenen Format. Es kann nützlich sein, die Daten mit einem Unix-Befehl wie dem folgenden zu untersuchen: `gunzip < mylog.json.gz | tr '\03' '\n' | less`

## Erzeugung von Lastdiagrammen

Die Klippy-Logdatei (/tmp/klippy.log) speichert Statistiken zu Bandbreite, Mikrocontroller-Auslastung und Host-Pufferauslastung. Es kann nützlich sein, diese Statistiken nach einem Druck grafisch darzustellen.

Um ein Diagramm zu erzeugen, ist einmalig die Installation des Pakets "matplotlib" notwendig:

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Danach können Diagramme erstellt werden mit:

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

Die resultierende Datei **loadgraph.png** kann anschließend betrachtet werden.

Es lassen sich verschiedene Diagramme erzeugen. Weitere Informationen erhalten Sie mit: `~/klipper/scripts/graphstats.py --help`

## Informationen aus der klippy.log Datei auslesen

Die Klippy-Logdatei (/tmp/klippy.log) enthält außerdem Debugging-Informationen. Es gibt ein Skript logextract.py, das bei der Analyse eines Mikrocontroller-Shutdowns oder ähnlicher Probleme nützlich sein kann. Es wird typischerweise etwa wie folgt ausgeführt:

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

Das Skript extrahiert die Drucker-Konfigurationsdatei sowie Informationen zum MCU-Shutdown. Die Dumps der MCU-Shutdown-Informationen (falls vorhanden) werden nach Zeitstempel neu sortiert, um bei der Diagnose von Ursache-Wirkungs-Szenarien zu helfen.

## Testen mit simulavr

Das Werkzeug [simulavr](http://www.nongnu.org/simulavr/) ermöglicht es, einen Atmel-ATmega-Mikrocontroller zu simulieren. Dieser Abschnitt beschreibt, wie sich G-Code-Testdateien durch simulavr laufen lassen. Es wird empfohlen, dies auf einem Desktop-Rechner auszuführen (nicht auf einem Raspberry Pi), da für einen effizienten Ablauf erhebliche CPU-Leistung benötigt wird.

Um simulavr zu verwenden, laden Sie das simulavr-Paket herunter und kompilieren Sie es mit Python-Unterstützung. Beachten Sie, dass für den Build-Prozess möglicherweise einige Pakete (wie swig) installiert sein müssen, um das Python-Modul zu erstellen.

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```

Stellen Sie sicher, dass nach der obigen Kompilierung eine Datei wie **./build/pysimulavr/_pysimulavr.*.so** vorhanden ist:

```
ls ./build/pysimulavr/_pysimulavr.*.so
```

Dieser Befehl sollte eine bestimmte Datei melden (z. B. **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**) und keinen Fehler.

Wenn Sie ein Debian-basiertes System (Debian, Ubuntu usw.) verwenden, können Sie die folgenden Pakete installieren und *.deb-Dateien für eine systemweite Installation von simulavr erzeugen:

```
sudo apt update
sudo apt install g++ make cmake swig rst2pdf help2man texinfo
make cfgclean python debian
sudo dpkg -i build/debian/python3-simulavr*.deb
```

Um Klipper für die Verwendung mit simulavr zu kompilieren, führen Sie aus:

```
cd /path/to/klipper
make menuconfig
```

und kompilieren Sie die Mikrocontroller-Software für einen AVR ATmega644p und wählen Sie die SIMULAVR-Softwareemulationsunterstützung aus. Anschließend kann Klipper kompiliert werden (führen Sie `make` aus), und die Simulation kann gestartet werden mit:

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

Beachten Sie: Wenn Sie python3-simulavr systemweit installiert haben, müssen Sie `PYTHONPATH` nicht setzen und können den Simulator einfach ausführen als

```
./scripts/avrsim.py out/klipper.elf
```

Läuft simulavr dann in einem anderen Fenster, kann Folgendes ausgeführt werden, um G-Code aus einer Datei zu lesen (z. B. "test.gcode"), ihn mit Klippy zu verarbeiten und an das in simulavr laufende Klipper zu senden (siehe [Installation](Installation.md) für die notwendigen Schritte zum Erstellen der Python-Virtual-Environment):

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### Verwendung von simulavr mit gtkwave

Eine nützliche Funktion von simulavr ist die Möglichkeit, Signalverlaufsdateien mit dem exakten Timing von Ereignissen zu erzeugen. Folgen Sie dazu den obigen Anweisungen, führen Sie avrsim.py jedoch mit einer Kommandozeile wie der folgenden aus:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

Das Obige würde eine Datei **avrsim.vcd** mit Informationen zu jeder Änderung an den GPIOs auf PORTA und PORTB erzeugen. Diese kann anschließend mit gtkwave betrachtet werden:

```
gtkwave avrsim.vcd
```
