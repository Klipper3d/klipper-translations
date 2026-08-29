# Installation

Diese Anleitung geht davon aus, dass die Software auf einem Linux-basierten Host läuft, auf dem ein Klipper-kompatibles Frontend ausgeführt wird. Es wird empfohlen, als Host-Rechner einen SBC (Small Board Computer) wie einen Raspberry Pi oder ein Debian-basiertes Linux-Gerät zu verwenden (weitere Optionen finden Sie in den [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)).

Für die Zwecke dieser Anleitung bezieht sich „Host“ auf das Linux-Gerät und „MCU“ auf die Druckerplatine. SBC bezeichnet den Begriff Small Board Computer, wie etwa den Raspberry Pi.

## Beziehen einer Klipper-Konfigurationsdatei

Die meisten Klipper-Einstellungen werden durch eine "Drucker-Konfigurationsdatei" printer.cfg festgelegt, die auf dem Host gespeichert wird. Eine passende Konfigurationsdatei findet sich häufig im Klipper-[Konfigurationsverzeichnis](../config/) - suchen Sie nach einer Datei mit dem Präfix "printer-", die zum jeweiligen Zieldrucker passt. Die Klipper-Konfigurationsdatei enthält technische Informationen zum Drucker, die während der Installation benötigt werden.

Wenn es keine passende Druckerkonfigurationsdatei im Klipper-Konfigurationsverzeichnis gibt, versuchen Sie auf der Website des Druckerherstellers nach einer passenden Klipper-Konfigurationsdatei zu suchen.

Wenn keine Konfigurationsdatei für den Drucker gefunden werden kann, aber der Typ der Druckerplatine bekannt ist, dann suchen Sie nach einer entsprechenden [config-Datei](../config/), die mit einem "generic-"-Präfix beginnt. Mit diesen Beispieldateien für die Druckerkarte sollte die Erstinstallation erfolgreich abgeschlossen werden können, es sind jedoch einige Anpassungen erforderlich, um die volle Druckerfunktionalität zu erhalten.

Es ist auch möglich, eine neue Druckerkonfiguration von Grund auf zu definieren. Dies erfordert jedoch erhebliche technische Kenntnisse über den Drucker und seine Elektronik. Es wird empfohlen, dass die meisten Benutzer mit einer geeigneten Konfigurationsdatei beginnen. Wenn Sie eine neue benutzerdefinierte Druckerkonfigurationsdatei erstellen, beginnen Sie mit der nächstgelegenen Beispiel-[Konfigurationsdatei](../config/) und verwenden Sie die Klipper-[Konfigurationsreferenz](Config_Reference.md) für weitere Informationen.

## Interaktion mit Klipper

Klipper ist eine 3D-Drucker-Firmware und benötigt daher eine Möglichkeit für den Anwender, mit ihr zu interagieren.

Aktuell sind die besten Optionen Frontends, die Informationen über die [Moonraker-Web-API](https://moonraker.readthedocs.io/) abrufen; alternativ gibt es auch die Möglichkeit, [OctoPrint](https://octoprint.org/) zur Steuerung von Klipper zu verwenden.

Die Wahl liegt beim Anwender, welche Option verwendet wird - das zugrunde liegende Klipper ist in allen Fällen dasselbe. Wir ermutigen Anwender, die verfügbaren Optionen zu prüfen und eine informierte Entscheidung zu treffen.

## Ein OS-Image für SBCs beschaffen

Es gibt viele Möglichkeiten, ein OS-Image für die Verwendung von Klipper auf einem SBC zu erhalten; die meisten hängen davon ab, welches Frontend Sie verwenden möchten. Einige Hersteller dieser SBC-Platinen stellen auch eigene, auf Klipper zugeschnittene Images bereit.

Die beiden wichtigsten Moonraker-basierten Frontends sind [Fluidd](https://docs.fluidd.xyz/) und [Mainsail](https://docs.mainsail.xyz/); letzteres verfügt über ein vorgefertigtes Installations-Image ["MainsailOS"](https://docs-os.mainsail.xyz/), das für den Raspberry Pi und einige OrangePi-Varianten verfügbar ist.

Fluidd kann über KIAUH (Klipper Install And Update Helper) installiert werden, das weiter unten erläutert wird und ein Drittanbieter-Installer für alles rund um Klipper ist.

OctoPrint kann über das beliebte OctoPi-Image oder über KIAUH installiert werden; dieser Vorgang wird in <OctoPrint.md> erläutert

## Installation über KIAUH

Normalerweise beginnen Sie mit einem Basis-Image für Ihren SBC, zum Beispiel RPiOS Lite, oder bei einem x86-Linux-Gerät mit Ubuntu Server. Bitte beachten Sie, dass Desktop-Varianten aufgrund bestimmter Hilfsprogramme, die manche Klipper-Funktionen stören oder sogar den Zugriff auf einige Druckerplatinen blockieren können, nicht empfohlen werden.

Mit KIAUH lassen sich Klipper und die zugehörigen Programme auf einer Vielzahl von Linux-basierten Systemen installieren, die auf Debian basieren. Weitere Informationen finden Sie unter https://github.com/dw-0/kiauh

## Kompilieren und Flashen des Mikrocontrollers

Um den Mikrocontroller-Code zu kompilieren, führen Sie zunächst diese Befehle auf Ihrem Host-Gerät aus:

```
cd ~/klipper/
make menuconfig
```

Die Kommentare am Anfang der [Druckerkonfigurationsdatei](#obtain-a-klipper-configuration-file) sollten die Einstellungen beschreiben, die während "make menuconfig" gesetzt werden müssen. Öffnen Sie die Datei in einem Webbrowser oder Texteditor und suchen Sie nach diesen Anweisungen am Anfang der Datei. Sobald Sie die entsprechenden "menuconfig"-Einstellungen vorgenommen haben, drücken Sie "Q" zum Beenden und dann "Y" zum Speichern. Führen Sie dann aus:

```
make
```

Beschreiben die Kommentare am Anfang der [Drucker-Konfigurationsdatei](#obtain-a-klipper-configuration-file) benutzerdefinierte Schritte zum "Flashen" des finalen Images auf die Druckersteuerplatine, folgen Sie diesen Schritten und fahren Sie anschließend mit [Konfiguration von OctoPrint](#configuring-octoprint-to-use-klipper) fort.

Andernfalls werden die folgenden Schritte häufig zum "Flashen" der Druckersteuerplatine verwendet. Zunächst muss die an den Mikrocontroller angeschlossene serielle Schnittstelle ermittelt werden. Führen Sie die folgenden Schritte aus:

```
ls /dev/serial/by-id/*
```

Es sollte etwas ähnliches wie das Folgende gemeldet werden:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Es ist üblich, dass jeder Drucker einen eigenen, eindeutigen Namen für den seriellen Port hat. Dieser eindeutige Name wird beim Flashen des Mikrocontrollers verwendet. Es ist möglich, dass die obige Ausgabe mehrere Zeilen enthält - wählen Sie in diesem Fall die Zeile, die dem Mikrocontroller entspricht. Werden viele Einträge aufgelistet und ist die Auswahl mehrdeutig, trennen Sie die Platine und führen Sie den Befehl erneut aus - der fehlende Eintrag ist Ihre Druckerplatine (weitere Informationen finden Sie in den [FAQ](FAQ.md#wheres-my-serial-port)).

Bei gängigen Mikrocontrollern mit STM32- oder Klon-Chips, LPC-Chips und anderen ist es üblich, dass diese zunächst über eine SD-Karte mit Klipper geflasht werden müssen.

Beim Flashen mit dieser Methode ist es wichtig, sicherzustellen, dass die Druckerplatine nicht per USB mit dem Host verbunden ist, da einige Platinen dadurch Strom zur Platine zurückspeisen können, was ein Flashen verhindert.

Bitte beachten Sie, dass die meisten Druckerplatinen, die SD-Karten zum Flashen verwenden, eine Art Schutz vor Flash-Schleifen implementieren, falls die SD-Karte eingesteckt bleibt. Es gibt zwei gängige Methoden:

Dateinamensänderung erforderlich (üblicherweise bei "Stock"-Druckerplatinen):

Diese Platinen erfordern, dass die Firmware-Datei bei jedem Flash-Vorgang einen anderen Namen erhält (zum Beispiel firmware1.bin, firmware2.bin usw.). Verwenden Sie erneut denselben Dateinamen, ignoriert die Platine diesen möglicherweise und aktualisiert sich nicht.

Automatische Dateiumbenennung (üblicherweise bei Nachrüst-Druckerplatinen):

Andere Platinen erlauben die Verwendung desselben Dateinamens, üblicherweise firmware.bin, benennen die Datei nach dem Flashen jedoch in firmware.cur um. Dies zeigt an, dass die Firmware erfolgreich geflasht wurde, und verhindert, dass sie beim nächsten Start erneut geflasht wird.

Prüfen Sie vor dem Flashen, welches Verhalten Ihre Platine zeigt.

Bei gängigen Mikrocontrollern mit Atmega-Chips, zum Beispiel dem 2560, kann der Code mit etwas Ähnlichem wie folgt geflasht werden:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Stellen Sie sicher, dass Sie FLASH_DEVICE mit dem eindeutigen Namen des seriellen Anschlusses des Druckers aktualisieren.

Bei gängigen Mikrocontrollern mit RP2040-Chips kann der Code mit etwas Ähnlichem wie folgt geflasht werden:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

Wichtig zu beachten ist, dass RP2040-Chips vor diesem Vorgang möglicherweise in den Boot-Modus versetzt werden müssen.

## Klipper einstellen

Der nächste Schritt besteht darin, die [Drucker-Konfigurationsdatei](#obtain-a-klipper-configuration-file) auf den Host zu kopieren.

Der wohl einfachste Weg, die Klipper-Konfigurationsdatei einzurichten, ist die Verwendung der eingebauten Editoren in Mainsail oder Fluidd. Damit kann der Anwender die Konfigurationsbeispiele öffnen und als printer.cfg speichern.

Eine weitere Möglichkeit ist die Verwendung eines Desktop-Editors, der das Bearbeiten von Dateien über die Protokolle "scp" und/oder "sftp" unterstützt. Es gibt frei verfügbare Werkzeuge, die dies unterstützen (z. B. Notepad++, WinSCP und Cyberduck). Laden Sie die Drucker-Konfigurationsdatei im Editor und speichern Sie sie anschließend als Datei mit dem Namen "printer.cfg" im Home-Verzeichnis des pi-Benutzers (also /home/pi/printer.cfg).

Alternativ kann die Datei auch direkt auf dem Host über SSH kopiert und bearbeitet werden. Das könnte etwa so aussehen (achten Sie darauf, den Befehl mit dem passenden Namen der Drucker-Konfigurationsdatei anzupassen):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Es ist üblich, dass jeder Drucker seinen eigenen, eindeutigen Namen für den Mikrocontroller hat. Der Name kann sich nach dem Flashen von Klipper ändern, also führen Sie diese Schritte erneut aus, auch wenn sie bereits beim Flashen durchgeführt wurden. Ausführen:

```
ls /dev/serial/by-id/*
```

Es sollte etwas ähnliches wie das Folgende gemeldet werden:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Dann aktualisieren Sie die Konfigurationsdatei mit dem eindeutigen Namen. Aktualisieren Sie zum Beispiel den Abschnitt `[mcu]` so, dass er in etwa so aussieht:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Nach dem Erstellen und Bearbeiten der Datei muss in der Befehlskonsole ein "restart"-Befehl ausgeführt werden, um die Konfiguration zu laden. Ein "status"-Befehl meldet, dass der Drucker bereit ist, sofern die Klipper-Konfigurationsdatei erfolgreich gelesen und der Mikrocontroller erfolgreich gefunden und konfiguriert wurde.

Beim Anpassen der Druckerkonfigurationsdatei kommt es nicht selten vor, dass Klipper einen Konfigurationsfehler meldet. Wenn ein Fehler auftritt, nehmen Sie die erforderlichen Korrekturen an der Druckerkonfigurationsdatei vor und führen Sie einen Neustart durch, bis "Status" meldet, dass der Drucker bereit ist.

Klipper meldet Fehlermeldungen über die Befehlskonsole sowie über Pop-ups in Fluidd und Mainsail. Mit dem Befehl "status" lassen sich Fehlermeldungen erneut ausgeben. Ein Log ist verfügbar, üblicherweise unter `~/printer_data/logs/klippy.log`.

Nachdem Klipper meldet, dass der Drucker bereit ist, fahren Sie mit dem Dokument [config check document](Config_checks.md) fort, um einige grundlegende Prüfungen der Definitionen in der Konfigurationsdatei durchzuführen. Weitere Informationen finden Sie in der [Dokumentationsreferenz](Overview.md).
