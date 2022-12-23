# Installation

Diese Anleitung geht davon aus, dass die Software auf einem Raspberry Pi Computer in Verbindung mit OctoPrint läuft. Es wird empfohlen, einen Raspberry Pi 2, 3 oder 4 als Host-Computer zu verwenden (siehe die [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) für andere Computer).

## Beziehen einer Klipper-Konfigurationsdatei

Die meisten Klipper-Einstellungen werden durch eine "Druckerkonfigurationsdatei" bestimmt, die auf dem Raspberry Pi gespeichert wird. Eine geeignete Konfigurationsdatei kann oft gefunden werden, indem man im Klipper [config-Verzeichnis](../config/) nach einer Datei sucht, die mit einem "printer-" Präfix beginnt und dem Zieldrucker entspricht. Die Klipper-Konfigurationsdatei enthält technische Informationen über den Drucker, die während der Installation benötigt werden.

Wenn es keine passende Druckerkonfigurationsdatei im Klipper-Konfigurationsverzeichnis gibt, versuchen Sie auf der Website des Druckerherstellers nach einer passenden Klipper-Konfigurationsdatei zu suchen.

Wenn keine Konfigurationsdatei für den Drucker gefunden werden kann, aber der Typ der Druckerplatine bekannt ist, dann suchen Sie nach einer entsprechenden [config-Datei](../config/), die mit einem "generic-"-Präfix beginnt. Mit diesen Beispieldateien für die Druckerkarte sollte die Erstinstallation erfolgreich abgeschlossen werden können, es sind jedoch einige Anpassungen erforderlich, um die volle Druckerfunktionalität zu erhalten.

Es ist auch möglich, eine neue Druckerkonfiguration von Grund auf zu definieren. Dies erfordert jedoch erhebliche technische Kenntnisse über den Drucker und seine Elektronik. Es wird empfohlen, dass die meisten Benutzer mit einer geeigneten Konfigurationsdatei beginnen. Wenn Sie eine neue benutzerdefinierte Druckerkonfigurationsdatei erstellen, beginnen Sie mit der nächstgelegenen Beispiel-[Konfigurationsdatei](../config/) und verwenden Sie die Klipper-[Konfigurationsreferenz](Config_Reference.md) für weitere Informationen.

## Vorbereiten eines Betriebssystem-Images

Beginnen Sie mit der Installation von [OctoPi](https://github.com/guysoft/OctoPi) auf dem Raspberry Pi Computer. Verwenden Sie OctoPi v0.17.0 oder höher - siehe [OctoPi releases](https://github.com/guysoft/OctoPi/releases) für Versionsinformationen. Stellen Sie sicher, dass OctoPi bootet und dass der OctoPrint-Webserver funktioniert. Nachdem Sie sich mit der OctoPrint-Webseite verbunden haben, folgen Sie der Aufforderung, OctoPrint auf v1.4.2 oder höher zu aktualisieren.

Nach der Installation von OctoPi und der Aktualisierung von OctoPrint müssen Sie sich per ssh in den Zielrechner einwählen, um einige Systembefehle auszuführen. Wenn Sie einen Linux- oder MacOS-Desktop verwenden, sollte die "ssh"-Software bereits auf dem Desktop installiert sein. Für andere Desktops gibt es kostenlose ssh-Clients (z. B. [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Verwenden Sie das ssh-Dienstprogramm, um sich mit dem Raspberry Pi zu verbinden (ssh pi@octopi -- Passwort ist "raspberry") und führen Sie die folgenden Befehle aus:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

Die obigen Schritte laden Klipper herunter, installieren einige Systemabhängigkeiten, richten Klipper so ein, dass es beim Systemstart ausgeführt wird, und starten die Klipper-Hostsoftware. Dies erfordert eine Internetverbindung und kann einige Minuten in Anspruch nehmen.

## Kompilieren und Flashen des Mikrocontrollers

Um den Code des Mikrocontrollers zu kompilieren, führen Sie zunächst diese Befehle auf dem Raspberry Pi aus:

```
cd ~/klipper/
make menuconfig
```

Die Kommentare am Anfang der [Druckerkonfigurationsdatei](#obtain-a-klipper-configuration-file) sollten die Einstellungen beschreiben, die während "make menuconfig" gesetzt werden müssen. Öffnen Sie die Datei in einem Webbrowser oder Texteditor und suchen Sie nach diesen Anweisungen am Anfang der Datei. Sobald Sie die entsprechenden "menuconfig"-Einstellungen vorgenommen haben, drücken Sie "Q" zum Beenden und dann "Y" zum Speichern. Führen Sie dann aus:

```
make
```

Wenn die Kommentare am Anfang der [Druckerkonfigurationsdatei](#obtain-a-klipper-configuration-file) benutzerdefinierte Schritte zum "Flashen" des endgültigen images auf die Druckerkontrollkarte beschreiben, dann befolgen Sie diese Schritte und fahren Sie dann mit der [Konfiguration von OctoPrint](#configuring-octoprint-to-use-klipper) fort.

Andernfalls werden die folgenden Schritte häufig zum "Flashen" der Druckersteuerplatine verwendet. Zunächst muss die an den Mikrocontroller angeschlossene serielle Schnittstelle ermittelt werden. Führen Sie die folgenden Schritte aus:

```
ls /dev/serial/by-id/*
```

Es sollte etwas ähnliches wie das Folgende gemeldet werden:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Es ist üblich, dass jeder Drucker einen eigenen, eindeutigen Namen für den seriellen Anschluss hat. Dieser eindeutige Name wird beim Flashen des Mikrocontrollers verwendet. Es ist möglich, dass es mehrere Zeilen in der obigen Ausgabe gibt - wenn dies der Fall ist, wählen Sie die Zeile, die dem Mikrocontroller entspricht (siehe [FAQ](FAQ.md#wheres-my-serial-port) für weitere Informationen).

Bei gängigen Mikrocontrollern kann der Code mit einer ähnlichen Methode geflasht werden:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Stellen Sie sicher, dass Sie FLASH_DEVICE mit dem eindeutigen Namen des seriellen Anschlusses des Druckers aktualisieren.

Wenn Sie zum ersten Mal flashen, stellen Sie sicher, dass OctoPrint nicht direkt mit dem Drucker verbunden ist (klicken Sie auf der OctoPrint-Webseite im Abschnitt "Verbindung" auf "Trennen").

## OctoPrint für die Verwendung von Klipper konfigurieren

Der OctoPrint-Webserver muss für die Kommunikation mit der Klipper-Host-Software konfiguriert werden. Melden Sie sich mit einem Webbrowser auf der OctoPrint-Webseite an und konfigurieren Sie dann die folgenden Punkte:

Navigieren Sie zur Registerkarte "Einstellungen" (das Schraubenschlüssel-Symbol oben auf der Seite). Fügen Sie unter "Serielle Verbindung" in "Zusätzliche serielle Schnittstellen" "/tmp/printer" hinzu. Klicken Sie dann auf "Speichern".

Gehen Sie erneut auf die Registerkarte "Einstellungen" und ändern Sie unter "Serielle Verbindung" die Einstellung "Serieller Anschluss" in "/tmp/printer".

Navigieren Sie auf der Registerkarte "Einstellungen" zur Unterregisterkarte "Verhalten" und wählen Sie die Option "Laufende Drucke abbrechen, aber mit dem Drucker verbunden bleiben". Klicken Sie auf "Speichern".

Vergewissern Sie sich auf der Hauptseite unter dem Abschnitt "Verbindung" (oben links auf der Seite), dass der "Serial Port" auf "/tmp/printer" eingestellt ist, und klicken Sie auf "Verbinden". (Wenn "/tmp/printer" nicht zur Auswahl steht, versuchen Sie, die Seite neu zu laden).

Sobald die Verbindung hergestellt ist, navigieren Sie zur Registerkarte "Terminal" und geben Sie "status" (ohne Anführungszeichen) in das Befehlseingabefeld ein und klicken Sie auf "Senden". Das Terminalfenster wird wahrscheinlich melden, dass ein Fehler beim Öffnen der Konfigurationsdatei aufgetreten ist - das bedeutet, dass OctoPrint erfolgreich mit Klipper kommuniziert. Fahren Sie mit dem nächsten Abschnitt fort.

## Klipper einstellen

Der nächste Schritt besteht darin, die [Druckerkonfigurationsdatei](#obtain-a-klipper-configuration-file) auf den Raspberry Pi zu kopieren.

Der wohl einfachste Weg, die Klipper-Konfigurationsdatei zu bearbeiten, ist die Verwendung eines Desktop-Editors, der das Bearbeiten von Dateien über die Protokolle "scp" und/oder "sftp" unterstützt. Es gibt frei verfügbare Tools, die dies unterstützen (z.B. Notepad++, WinSCP und Cyberduck). Laden Sie die Druckerkonfigurationsdatei in den Editor und speichern Sie sie dann als Datei mit dem Namen "printer.cfg" im Home-Verzeichnis des Pi-Benutzers (z. B. /home/pi/printer.cfg).

Alternativ kann man die Datei auch direkt auf den Raspberry Pi kopieren und per ssh bearbeiten. Das kann etwa wie folgt aussehen (stellen Sie sicher, dass Sie den Befehl aktualisieren, um den entsprechenden Dateinamen für die Druckerkonfiguration zu verwenden):

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

Nach dem Erstellen und Bearbeiten der Datei muss im OctoPrint-Webterminal ein "Neustart"-Befehl eingegeben werden, um die Konfiguration zu laden. Ein "Status"-Befehl meldet, dass der Drucker bereit ist, wenn die Klipper-Konfigurationsdatei erfolgreich gelesen und der Mikrocontroller erfolgreich gefunden und konfiguriert wurde.

Beim Anpassen der Druckerkonfigurationsdatei kommt es nicht selten vor, dass Klipper einen Konfigurationsfehler meldet. Wenn ein Fehler auftritt, nehmen Sie die erforderlichen Korrekturen an der Druckerkonfigurationsdatei vor und führen Sie einen Neustart durch, bis "Status" meldet, dass der Drucker bereit ist.

Klipper meldet Fehlermeldungen über die OctoPrint-Terminal-Registerkarte. Der Befehl "status" kann verwendet werden, um Fehlermeldungen erneut zu melden. Das Standard-Startskript von Klipper legt außerdem ein Protokoll in **/tmp/klippy.log** an, das detailliertere Informationen enthält.

Nachdem Klipper meldet, dass der Drucker bereit ist, fahren Sie mit dem Dokument [config check document](Config_checks.md) fort, um einige grundlegende Prüfungen der Definitionen in der Konfigurationsdatei durchzuführen. Weitere Informationen finden Sie in der [Dokumentationsreferenz](Overview.md).
