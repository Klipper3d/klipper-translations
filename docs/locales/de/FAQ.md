# Häufig gestellte Fragen

## Wie kann ich für das Projekt spenden?

Vielen Dank für Ihre Unterstützung. Informationen finden Sie auf der [Sponsorenseite](Sponsors.md).

## Wie berechne ich den Konfigurationsparameter rotation_distance?

Siehe das Dokument [rotation distance document](Rotation_Distance.md).

## Wo ist meine serielle Schnittstelle?

Die allgemeine Methode, einen seriellen USB-Anschluss zu finden, besteht darin, `ls /dev/serial/by-id/*` von einem ssh-Terminal auf dem Host-Rechner aus auszuführen. Dies wird wahrscheinlich eine ähnliche Ausgabe wie die folgende erzeugen:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Der im obigen Befehl gefundene Name ist stabil und es ist möglich, ihn in der Konfigurationsdatei und beim Flashen des Mikrocontroller-Codes zu verwenden. Ein Flash-Befehl könnte zum Beispiel so aussehen:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

und die aktualisierte Konfiguration könnte wie folgt aussehen:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Stellen Sie sicher, dass Sie den Namen aus dem Befehl "ls", den Sie oben ausgeführt haben, kopieren und einfügen, da der Name für jeden Drucker anders ist.

Wenn Sie mehrere Mikrocontroller verwenden und diese keine eindeutigen IDs haben (üblich bei Boards mit einem CH340-USB-Chip), folgen Sie den obigen Anweisungen und verwenden Sie stattdessen den Befehl `ls /dev/serial/by-path/*`.

## Wenn der Mikrocontroller neu startet, wechselt das Gerät zu /dev/ttyUSB1

Folgen Sie den Anweisungen im "[Wo ist meine serielle Schnittstelle?](#wheres-my-serial-port)" Abschnitt, um dies zu verhindern.

## Der Befehl "make flash" funktioniert nicht

Der Code versucht, das Gerät mit der gebräuchlichsten Methode für die jeweilige Plattform zu flashen. Leider gibt es viele Varianten bei Flash-Methoden, weshalb der Befehl "make flash" nicht unbedingt auf allen Boards funktioniert.

Wenn der Fehler sporadisch auftritt oder Sie einen Standardaufbau verwenden, prüfen Sie noch einmal, dass Klipper während des Flashens nicht läuft (sudo service klipper stop), stellen Sie sicher, dass OctoPrint nicht versucht, sich direkt mit dem Gerät zu verbinden (öffnen Sie den Reiter Connection auf der Weboberfläche und klicken Sie auf Disconnect, falls der serielle Port auf das Gerät eingestellt ist), und vergewissern Sie sich, dass FLASH_DEVICE für Ihre Platine korrekt gesetzt ist (siehe die [Frage weiter oben](#wheres-my-serial-port)).

Wenn "make flash" für Ihre Platine jedoch schlicht nicht funktioniert, müssen Sie manuell flashen. Prüfen Sie, ob es im [Konfigurationsverzeichnis](../config) eine Konfigurationsdatei mit spezifischen Anweisungen zum Flashen des Geräts gibt. Sehen Sie außerdem in der Dokumentation des Platinenherstellers nach, ob dort das Flashen beschrieben wird. Schließlich lässt sich das Gerät unter Umständen manuell mit Werkzeugen wie "avrdude" oder "bossac" flashen - weitere Informationen finden Sie im [Bootloader-Dokument](Bootloaders.md).

## Wie ändere ich die Serielle Baudrate?

Die empfohlene Baudrate für Klipper ist 250000. Diese Baudrate funktioniert zuverlässig auf allen micro-controller Platinen die Klipper unterstützen. Wenn du in einer online Anleitung erine Empfehlung für eine andere Baudrate findest, ignoriere diese und benutze die standard Baudrate: 250000.

Wenn Sie die Baudrate dennoch ändern möchten, muss die neue Rate im Mikrocontroller konfiguriert (während **make menuconfig**) und der aktualisierte Code kompiliert und auf den Mikrocontroller geflasht werden. Außerdem muss die Klipper-Datei printer.cfg an diese Baudrate angepasst werden (Einzelheiten siehe [Konfigurationsreferenz](Config_Reference.md#mcu)). Zum Beispiel:

```
[mcu]
baud: 250000
```

Die auf der OctoPrint-Webseite angezeigte Baudrate hat keinen Einfluss auf die interne Baudrate des Klipper-Mikrocontrollers. Stellen Sie immer die Baudrate von OctoPrint auf 250000 ein, wenn Sie Klipper verwenden.

Die Baudrate des Klipper-Mikrocontrollers hat nichts mit der Baudrate des Bootloaders des Mikrocontrollers zu tun. Weitere Informationen zu Bootloadern finden Sie im [Bootloader-Dokument](Bootloaders.md).

## Funktioniert Klipper auf anderen Geräten, außer dem Raspberry Pi 3?

Empfohlen werden ein Raspberry Pi Zero 2 W, ein Raspberry Pi 3, ein Raspberry Pi 4 oder ein Raspberry Pi 5. Klipper läuft, wie nachfolgend beschrieben, auch auf anderen SBC-Geräten sowie auf x86-Hardware.

Klipper läuft auf einem Raspberry Pi 1, 2 und auf dem Raspberry Pi Zero 1, doch diese Platinen haben nicht genügend Rechenleistung, um Klipper gut zu betreiben. Auf diesen langsameren Maschinen kommt es beim Drucken häufig zu Stockungen (der Drucker bewegt sich unter Umständen schneller, als Klipper Bewegungsbefehle senden kann). Der Betrieb von Klipper auf diesen älteren Maschinen wird nicht empfohlen.

Für den Betrieb auf dem Beaglebone siehe die [Beaglebone-spezifische Installationsanleitung](Beaglebone.md).

Klipper wurde bereits auf anderen Maschinen betrieben. Die Klipper-Host-Software benötigt lediglich Python auf einem Linux-Rechner (oder einem vergleichbaren System). Wenn Sie sie jedoch auf einer anderen Maschine betreiben möchten, benötigen Sie Linux-Administrationskenntnisse, um die Systemvoraussetzungen für diese Maschine einzurichten. Weitere Informationen zu den erforderlichen Administrationsschritten unter Linux finden Sie im Skript [install-octopi.sh](../scripts/install-octopi.sh).

Wenn Sie die Klipper-Host-Software auf einem leistungsschwachen Chip betreiben möchten, beachten Sie, dass mindestens eine Maschine mit Hardware für "doppelt genaue Gleitkommaarithmetik" erforderlich ist.

Wenn Sie die Klipper-Host-Software auf einem gemeinsam genutzten Allzweck-Desktop oder einer Server-Maschine betreiben möchten, beachten Sie, dass Klipper bestimmte Echtzeitanforderungen an die Ablaufplanung stellt. Führt der Host-Rechner während eines Drucks zusätzlich eine rechenintensive Allzweckaufgabe aus (etwa das Defragmentieren einer Festplatte, 3D-Rendering, starkes Swapping usw.), kann dies dazu führen, dass Klipper Druckfehler meldet.

Hinweis: Wenn Sie kein OctoPi-Image verwenden, beachten Sie, dass mehrere Linux-Distributionen ein Paket "ModemManager" (oder Ähnliches) aktivieren, das die serielle Kommunikation stören kann. (Das kann dazu führen, dass Klipper scheinbar zufällige Fehler "Lost communication with MCU" meldet.) Wenn Sie Klipper auf einer solchen Distribution installieren, müssen Sie dieses Paket unter Umständen deaktivieren.

## Kann ich mehrere Instanzen von Klipper auf dem gleichen Hostsystem ausführen?

Es ist möglich, mehrere Instanzen der Klipper-Host-Software auszuführen, dies erfordert jedoch Kenntnisse in der Linux-Administration. Die Klipper-Installationscripts führen schließlich den folgenden Unix-Befehl aus:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

Man kann mehrere Instanzen des obigen Befehls ausführen, solange jede Instanz ihre eigene Druckerkonfigurationsdatei, ihre eigene Protokolldatei und ihr eigenes Pseudo-TTY besitzt. Zum Beispiel:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

Wenn Sie sich dafür entscheiden, müssen Sie die notwendigen Start-, Stopp- und Installationsskripte (sofern erforderlich) selbst umsetzen. Die Skripte [install-octopi.sh](../scripts/install-octopi.sh) und [klipper-start.sh](../scripts/klipper-start.sh) können dabei als Beispiel dienen.

## Muss ich OctoPrint benutzen?

Die Klipper-Software ist nicht von OctoPrint abhängig. Es ist möglich, eine alternative Software zu verwenden, um Befehle an Klipper zu senden, jedoch erfordert dies Kenntnisse in der Linux-Administration.

Klipper erzeugt über die Datei "/tmp/printer" einen "virtuellen seriellen Port" und emuliert darüber eine klassische serielle 3D-Drucker-Schnittstelle. Grundsätzlich kann alternative Software mit Klipper zusammenarbeiten, solange sie sich so konfigurieren lässt, dass sie "/tmp/printer" als seriellen Port des Druckers verwendet.

## Warum kann ich den Schrittmotor nicht bewegen, bevor ich den Drucker in die Ausgangsposition bringe?

Der Code tut dies, um das Risiko zu verringern, dass der Kopf versehentlich in das Bett oder gegen eine Wand gefahren wird. Sobald der Drucker gehomt ist, versucht die Software zu überprüfen, ob jede Bewegung innerhalb der in der Konfigurationsdatei definierten Werte position_min/max liegt. Werden die Motoren deaktiviert (über einen M84- oder M18-Befehl), müssen sie vor einer Bewegung erneut gehomt werden.

Wenn Sie den Kopf nach dem Abbrechen eines Drucks über OctoPrint bewegen möchten, passen Sie am besten die Abbruchsequenz von OctoPrint entsprechend an. Sie wird in OctoPrint über den Webbrowser konfiguriert unter: Settings->GCODE Scripts

Wenn Sie den Kopf nach Abschluss eines Drucks bewegen möchten, fügen Sie die gewünschte Bewegung am besten dem Abschnitt "custom g-code" Ihres Slicers hinzu.

Wenn der Drucker im Rahmen des Homing-Vorgangs selbst eine zusätzliche Bewegung benötigt (oder grundsätzlich über keinen Homing-Vorgang verfügt), verwenden Sie am besten einen Abschnitt safe_z_home oder homing_override in der Konfigurationsdatei. Wenn Sie einen Schrittmotor zu Diagnose- oder Debugging-Zwecken bewegen müssen, fügen Sie der Konfigurationsdatei am besten einen Abschnitt force_move hinzu. Weitere Einzelheiten zu diesen Optionen finden Sie in der [Konfigurationsreferenz](Config_Reference.md#customized_homing).

## Warum ist der Z-position_endstop in den Standardkonfigurationen auf 0.5 gesetzt?

Bei Druckern kartesischer Bauart gibt der Z-position_endstop an, wie weit die Düse beim Auslösen des Endschalters vom Bett entfernt ist. Nach Möglichkeit wird empfohlen, einen Z-Max-Endschalter zu verwenden und vom Bett weg zu homen (da dies das Risiko von Kollisionen mit dem Bett verringert). Muss jedoch in Richtung Bett gehomt werden, wird empfohlen, den Endschalter so zu positionieren, dass er auslöst, während die Düse noch einen kleinen Abstand zum Bett hat. So stoppt die Achse beim Homing, bevor die Düse das Bett berührt. Weitere Informationen finden Sie im [Dokument Bed Level](Bed_Level.md).

## Ich habe meine Konfiguration von Marlin übernommen und die X-/Y-Achsen funktionieren einwandfrei, aber beim Homing der Z-Achse höre ich nur ein kreischendes Geräusch

Kurze Antwort: Stellen Sie zunächst sicher, dass Sie die Schrittmotorkonfiguration wie im [Dokument zur Konfigurationsprüfung](Config_checks.md) beschrieben überprüft haben. Besteht das Problem weiterhin, verringern Sie die Einstellung max_z_velocity in der Druckerkonfiguration.

Lange Antwort: In der Praxis kann Marlin üblicherweise nur mit etwa 10000 Schritten pro Sekunde takten. Wird eine Geschwindigkeit angefordert, die eine höhere Schrittrate erfordern würde, taktet Marlin in der Regel einfach so schnell wie möglich. Klipper erreicht deutlich höhere Schrittraten, der Schrittmotor hat jedoch möglicherweise nicht genügend Drehmoment, um sich mit höherer Geschwindigkeit zu bewegen. Bei einer Z-Achse mit hohem Übersetzungsverhältnis oder hoher Microstep-Einstellung kann die tatsächlich erreichbare max_z_velocity daher kleiner sein als der in Marlin konfigurierte Wert.

## Mein TMC-Motortreiber schaltet sich mitten im Druck ab

Wenn Sie den Treiber TMC2208 (oder TMC2224) im "Standalone-Modus" verwenden, achten Sie darauf, die [aktuelle Version von Klipper](#how-do-i-upgrade-to-the-latest-software) einzusetzen. Eine Umgehung für ein Problem mit dem "Stealthchop"-Modus des TMC2208 wurde Mitte März 2020 in Klipper aufgenommen.

## Ich erhalte immer wieder zufällige Fehler "Lost communication with MCU"

Ursache sind häufig Hardwarefehler auf der USB-Verbindung zwischen Host-Rechner und Mikrocontroller. Achten Sie auf Folgendes:

- Verwenden Sie ein hochwertiges USB-Kabel zwischen Host-Rechner und Mikrocontroller. Achten Sie darauf, dass die Stecker fest sitzen.
- Wenn Sie einen Raspberry Pi verwenden, setzen Sie ein [hochwertiges Netzteil](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply) für den Raspberry Pi ein und verbinden Sie dieses Netzteil über ein [hochwertiges USB-Kabel](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877) mit dem Pi. Wenn Sie von OctoPrint Warnungen wegen "under voltage" erhalten, hängt das mit der Stromversorgung zusammen und muss behoben werden.
- Stellen Sie sicher, dass das Netzteil des Druckers nicht überlastet ist. (Spannungsschwankungen am USB-Chip des Mikrocontrollers können zu Resets dieses Chips führen.)
- Überprüfen Sie, ob Schrittmotor-, Heizungs- und andere Druckerkabel nicht gequetscht oder ausgefranst sind. (Bewegungen des Druckers können ein fehlerhaftes Kabel belasten, sodass es den Kontakt verliert, kurzzeitig einen Kurzschluss verursacht oder starkes Rauschen erzeugt.)
- Es gibt Berichte über starkes USB-Rauschen, wenn das Netzteil des Druckers und die 5-V-Versorgung des Hosts vermischt werden. (Wenn Sie feststellen, dass sich der Mikrocontroller sowohl bei eingeschaltetem Druckernetzteil als auch bei eingestecktem USB-Kabel einschaltet, deutet das darauf hin, dass die 5-V-Versorgungen vermischt sind.) Es kann helfen, den Mikrocontroller so zu konfigurieren, dass er nur aus einer Quelle versorgt wird. (Alternativ kann man, wenn die Mikrocontroller-Platine ihre Spannungsquelle nicht konfigurieren kann, ein USB-Kabel so modifizieren, dass es keine 5-V-Versorgung zwischen Host und Mikrocontroller führt.)

## Mein Raspberry Pi startet während des Druckens immer wieder neu

Ursache sind höchstwahrscheinlich Spannungsschwankungen. Führen Sie dieselben Schritte zur Fehlersuche durch wie bei einem Fehler ["Lost communication with MCU"](#i-keep-getting-random-lost-communication-with-mcu-errors).

## Wenn ich `restart_method=command` setze, bleibt mein AVR-Gerät bei einem Neustart einfach hängen

Einige alte Versionen des AVR-Bootloaders haben einen bekannten Fehler bei der Behandlung von Watchdog-Ereignissen. Dieser tritt typischerweise auf, wenn in der Datei printer.cfg restart_method auf "command" gesetzt ist. Tritt der Fehler auf, reagiert das AVR-Gerät nicht mehr, bis die Stromversorgung getrennt und wieder hergestellt wird (die Power- oder Status-LEDs können außerdem wiederholt blinken, bis die Stromversorgung getrennt wird).

Als Abhilfe verwenden Sie eine andere restart_method als "command" oder flashen einen aktualisierten Bootloader auf das AVR-Gerät. Das Flashen eines neuen Bootloaders ist ein einmaliger Schritt, der üblicherweise einen externen Programmieradapter erfordert - weitere Einzelheiten finden Sie unter [Bootloaders](Bootloaders.md).

## Bleiben die Heizungen eingeschaltet, wenn der Raspberry Pi abstürzt?

Die Software wurde so ausgelegt, dass dies verhindert wird. Sobald der Host eine Heizung aktiviert, muss die Host-Software diese Aktivierung alle 3 Sekunden bestätigen. Erhält der Mikrocontroller nicht alle 3 Sekunden eine Bestätigung, geht er in einen "shutdown"-Zustand, der darauf ausgelegt ist, alle Heizungen und Schrittmotoren abzuschalten.

Weitere Einzelheiten finden Sie beim Befehl "config_digital_out" im Dokument [MCU-Befehle](MCU_Commands.md).

Darüber hinaus wird die Mikrocontroller-Software beim Start für jede Heizung mit einem minimalen und maximalen Temperaturbereich konfiguriert (Einzelheiten siehe die Parameter min_temp und max_temp in der [Konfigurationsreferenz](Config_Reference.md#extruder)). Stellt der Mikrocontroller fest, dass die Temperatur außerhalb dieses Bereichs liegt, geht er ebenfalls in den Zustand "shutdown".

Unabhängig davon enthält auch die Host-Software Code, der prüft, ob Heizungen und Temperatursensoren korrekt funktionieren. Weitere Einzelheiten finden Sie in der [Konfigurationsreferenz](Config_Reference.md#verify_heater).

## Wie wandle ich eine Marlin-Pin-Nummer in einen Klipper-Pin-Namen um?

Kurze Antwort: Eine Zuordnung finden Sie in der Datei [sample-aliases.cfg](../config/sample-aliases.cfg). Nutzen Sie diese Datei als Leitfaden, um die tatsächlichen Pin-Namen des Mikrocontrollers zu ermitteln. (Es ist auch möglich, den betreffenden Konfigurationsabschnitt [board_pins](Config_Reference.md#board_pins) in Ihre Konfigurationsdatei zu kopieren und die Aliase in Ihrer Konfiguration zu verwenden; vorzuziehen ist jedoch, die tatsächlichen Pin-Namen des Mikrocontrollers zu übersetzen und zu verwenden.) Beachten Sie, dass die Datei sample-aliases.cfg Pin-Namen mit dem Präfix "ar" statt "D" verwendet (z. B. ist der Arduino-Pin `D23` der Klipper-Alias `ar23`) und das Präfix "analog" statt "A" (z. B. ist der Arduino-Pin `A14` der Klipper-Alias `analog14`).

Lange Antwort: Klipper verwendet die vom Mikrocontroller definierten Standard-Pin-Namen. Auf den Atmega-Chips haben diese Hardware-Pins Namen wie `PA4`, `PC7` oder `PD2`.

Vor langer Zeit entschied sich das Arduino-Projekt dagegen, die Standard-Hardwarenamen zu verwenden, und führte stattdessen eigene, fortlaufend nummerierte Pin-Namen ein - diese Arduino-Namen sehen üblicherweise aus wie `D23` oder `A14`. Das war eine unglückliche Entscheidung, die zu erheblicher Verwirrung geführt hat. Insbesondere lassen sich die Arduino-Pin-Nummern häufig nicht auf dieselben Hardwarenamen übertragen. So ist `D21` auf einer verbreiteten Arduino-Platine `PD0`, auf einer anderen verbreiteten Arduino-Platine jedoch `PC7`.

Um diese Verwirrung zu vermeiden, verwendet der Kern-Code von Klipper die vom Mikrocontroller definierten Standard-Pin-Namen.

## Muss ich mein Gerät an einen bestimmten Typ von Mikrocontroller-Pin anschließen?

Das hängt vom Gerätetyp und vom Pin-Typ ab:

ADC-Pins (oder Analog-Pins): Thermistoren und ähnliche "analoge" Sensoren müssen an einen "analogen" bzw. ADC-fähigen Pin des Mikrocontrollers angeschlossen werden. Wenn Sie Klipper so konfigurieren, dass ein nicht analogfähiger Pin verwendet wird, meldet Klipper den Fehler "Not a valid ADC pin".

PWM-Pins (oder Timer-Pins): Klipper verwendet standardmäßig für kein Gerät hardwarebasierte PWM. Grundsätzlich können Heizungen, Lüfter und ähnliche Geräte daher an jeden universellen IO-Pin angeschlossen werden. Lüfter und output_pin-Geräte können jedoch optional mit `hardware_pwm: True` konfiguriert werden; in diesem Fall muss der Mikrocontroller an diesem Pin hardwarebasierte PWM unterstützen (andernfalls meldet Klipper den Fehler "Not a valid PWM pin").

IRQ-Pins (oder Interrupt-Pins): Klipper nutzt keine Hardware-Interrupts an IO-Pins, daher ist es nie erforderlich, ein Gerät an einen dieser Mikrocontroller-Pins anzuschließen.

SPI-Pins: Bei Verwendung von Hardware-SPI müssen die Leitungen an die SPI-fähigen Pins des Mikrocontrollers angeschlossen werden. Die meisten Geräte lassen sich jedoch für "Software-SPI" konfigurieren; in diesem Fall können beliebige universelle IO-Pins verwendet werden.

I2C-Pins: Bei Verwendung von I2C müssen die Leitungen an die I2C-fähigen Pins des Mikrocontrollers angeschlossen werden.

Andere Geräte können an jeden universellen IO-Pin angeschlossen werden. So können zum Beispiel Schrittmotoren, Heizungen, Lüfter, Z-Sonden, Servos, LEDs, übliche hd44780-/st7920-LCD-Displays und die UART-Steuerleitung von Trinamic-Treibern an jeden universellen IO-Pin angeschlossen werden.

## Wie breche ich eine "Warten auf Temperatur"-Anforderung durch M109/M190 ab?

Wechseln Sie zum OctoPrint-Terminal-Reiter und setzen Sie im Terminalfeld einen M112-Befehl ab. Der M112-Befehl versetzt Klipper in den Zustand "shutdown" und führt dazu, dass OctoPrint die Verbindung zu Klipper trennt. Wechseln Sie zum Verbindungsbereich von OctoPrint und klicken Sie auf "Connect", damit OctoPrint sich erneut verbindet. Wechseln Sie zurück zum Terminal-Reiter und setzen Sie einen FIRMWARE_RESTART-Befehl ab, um den Fehlerzustand von Klipper zu löschen. Nach diesem Ablauf ist die vorherige Heizanforderung abgebrochen und ein neuer Druck kann gestartet werden.

## Kann ich feststellen, ob der Drucker Schritte verloren hat?

In gewisser Weise ja. Homen Sie den Drucker, setzen Sie einen `GET_POSITION`-Befehl ab, führen Sie Ihren Druck aus, homen Sie erneut und setzen Sie ein weiteres `GET_POSITION` ab. Vergleichen Sie anschließend die Werte in der Zeile `mcu:`.

Das kann hilfreich sein, um Einstellungen wie Schrittmotorströme, Beschleunigungen und Geschwindigkeiten abzustimmen, ohne tatsächlich etwas drucken und Filament verschwenden zu müssen: Führen Sie einfach zwischen den `GET_POSITION`-Befehlen einige Bewegungen mit hoher Geschwindigkeit aus.

Beachten Sie, dass Endschalter selbst dazu neigen, an leicht unterschiedlichen Positionen auszulösen; eine Abweichung von wenigen Microsteps ist daher vermutlich auf Ungenauigkeiten der Endschalter zurückzuführen. Ein Schrittmotor selbst kann Schritte nur in Vielfachen von 4 Vollschritten verlieren. (Verwendet man also 16 Microsteps, würde ein verlorener Schritt am Schrittmotor dazu führen, dass der Schrittzähler "mcu:" um ein Vielfaches von 64 Microsteps abweicht.)

## Warum meldet Klipper Fehler? Mein Druck ist dadurch verloren gegangen!

Kurze Antwort: Wir möchten wissen, ob unsere Drucker ein Problem erkennen, damit die zugrunde liegende Ursache behoben werden kann und wir Drucke in hervorragender Qualität erhalten. Wir möchten auf keinen Fall, dass unsere Drucker stillschweigend Drucke minderer Qualität produzieren.

Lange Antwort: Klipper ist so konstruiert, dass es viele vorübergehende Probleme automatisch umgeht. So erkennt es zum Beispiel Kommunikationsfehler selbstständig und überträgt erneut; es plant Aktionen im Voraus und puffert Befehle auf mehreren Ebenen, um auch bei zeitweiligen Störungen ein präzises Timing zu ermöglichen. Erkennt die Software jedoch einen Fehler, von dem sie sich nicht erholen kann, wird sie zu einer ungültigen Aktion aufgefordert oder stellt sie fest, dass sie die aufgetragene Aufgabe aussichtslos nicht ausführen kann, meldet Klipper einen Fehler. In diesen Situationen besteht ein hohes Risiko, einen Druck minderer Qualität (oder Schlimmeres) zu erzeugen. Die Hoffnung ist, dass der Hinweis den Benutzer in die Lage versetzt, die zugrunde liegende Ursache zu beheben und die Gesamtqualität seiner Drucke zu verbessern.

Dazu gibt es einige verwandte Fragen: Warum pausiert Klipper den Druck nicht stattdessen? Warum meldet es keine Warnung? Warum prüft es nicht vor dem Druck auf Fehler? Warum ignoriert es keine Fehler in vom Benutzer eingegebenen Befehlen? usw. Derzeit liest Klipper Befehle über das G-Code-Protokoll, und leider ist das G-Code-Befehlsprotokoll nicht flexibel genug, um diese Alternativen heute praktikabel zu machen. Unter den Entwicklern besteht Interesse daran, das Nutzererlebnis bei unnormalen Ereignissen zu verbessern; es ist jedoch zu erwarten, dass dies erhebliche Arbeit an der Infrastruktur erfordert (einschließlich einer Abkehr von G-Code).

## Wie kann ich ein Upgrade auf die neueste Softwareversion durchführen?

Der erste Schritt bei einer Software-Aktualisierung besteht darin, das aktuelle Dokument zu den [Konfigurationsänderungen](Config_Changes.md) durchzusehen. Gelegentlich werden Änderungen an der Software vorgenommen, die es erforderlich machen, dass Benutzer im Rahmen der Aktualisierung ihre Einstellungen anpassen. Es ist ratsam, dieses Dokument vor der Aktualisierung zu lesen.

Wenn Sie zur Aktualisierung bereit sind, lautet das übliche Vorgehen: per SSH auf den Raspberry Pi verbinden und ausführen:

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

Anschließend kann man den Mikrocontroller-Code neu kompilieren und flashen. Zum Beispiel:

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

Häufig ändert sich jedoch nur die Host-Software. In diesem Fall kann man ausschließlich die Host-Software aktualisieren und neu starten mit:

```
cd ~/klipper
git pull
sudo service klipper restart
```

Wenn die Software nach Verwendung dieser Abkürzung darauf hinweist, dass der Mikrocontroller neu geflasht werden muss, oder ein anderer ungewöhnlicher Fehler auftritt, führen Sie die oben beschriebenen vollständigen Aktualisierungsschritte durch.

Bestehen weiterhin Fehler, prüfen Sie erneut das Dokument zu den [Konfigurationsänderungen](Config_Changes.md), da Sie möglicherweise die Druckerkonfiguration anpassen müssen.

Beachten Sie, dass die G-Code-Befehle RESTART und FIRMWARE_RESTART keine neue Software laden - damit eine Softwareänderung wirksam wird, sind die oben genannten Befehle "sudo service klipper restart" und "make flash" erforderlich.

## Wie deinstalliere ich Klipper?

Auf Firmware-Seite ist nichts Besonderes erforderlich. Folgen Sie einfach der Flash-Anleitung für die neue Firmware.

Auf Seiten des Raspberry Pi steht ein Deinstallationsskript unter [scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh) zur Verfügung. Zum Beispiel:

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
