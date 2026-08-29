# Protokoll

Das Klipper-Messaging-Protokoll wird für die Low-Level-Kommunikation zwischen der Klipper-Host-Software und der Klipper-Mikrocontroller-Software verwendet. Auf hoher Ebene kann man sich das Protokoll als eine Reihe von Befehls- und Antwortzeichenfolgen vorstellen, die komprimiert, übertragen und dann auf der Empfängerseite verarbeitet werden. Eine beispielhafte Reihe von Befehlen in unkomprimiertem, für Menschen lesbarem Format könnte folgendermaßen aussehen:

```
set_digital_out pin=PA3 value=1
set_digital_out pin=PA7 value=1
schedule_digital_out oid=8 clock=4000000 value=0
queue_step oid=7 interval=7458 count=10 add=331
queue_step oid=7 interval=11717 count=4 add=1281
```

Siehe das Dokument [mcu commands](MCU_Commands.md) für Informationen zu den verfügbaren Befehlen. Siehe das Dokument [debugging](Debugging.md) für Informationen darüber, wie eine G-Code-Datei in die entsprechenden menschenlesbaren Mikrocontroller-Befehle übersetzt werden kann.

Diese Seite enthält eine allgemeine Beschreibung des Klipper-Nachrichtenprotokolls selbst. Sie beschreibt, wie Nachrichten deklariert, im Binärformat kodiert (das "Kompressionsschema") und übertragen werden.

Das Ziel des Protokolls ist es, einen fehlerfreien Kommunikationskanal zwischen Host und Mikrocontroller zu ermöglichen, der geringe Latenz, geringe Bandbreite und geringe Komplexität für den Mikrocontroller aufweist.

## Mikrocontroller Schnittstelle

Das Klipper-Übertragungsprotokoll kann als [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call)-Mechanismus zwischen Mikrocontroller und Host verstanden werden. Die Mikrocontroller-Software deklariert die Befehle, die der Host aufrufen kann, sowie die Antwortnachrichten, die sie erzeugen kann. Der Host nutzt diese Informationen, um den Mikrocontroller zu Aktionen zu veranlassen und die Ergebnisse zu interpretieren.

### Befehle festlegen

Die Mikrocontroller-Software deklariert einen „command“ mit dem Makro DECL_COMMAND() im C-Code. Zum Beispiel:

```
DECL_COMMAND(command_update_digital_out, "update_digital_out oid=%c value=%c");
```

Das Obige deklariert einen Befehl namens „update_digital_out“. Damit kann der Host diesen Befehl „aufrufen“, was dazu führt, dass die C-Funktion command_update_digital_out() im Mikrocontroller ausgeführt wird. Das Obige zeigt außerdem, dass der Befehl zwei Ganzzahl-Parameter erwartet. Wenn der C-Code command_update_digital_out() ausgeführt wird, erhält er ein Array mit diesen beiden Ganzzahlen - die erste entspricht 'oid', die zweite 'value'.

Im Allgemeinen werden die Parameter in printf()-artiger Syntax beschrieben (z. B. „%u“). Die Formatierung entspricht direkt der menschenlesbaren Darstellung der Befehle (z. B. „update_digital_out oid=7 value=1“). Im obigen Beispiel ist „value=“ ein Parametername und „%c“ gibt an, dass der Parameter eine Ganzzahl ist. Intern dient der Parametername nur der Dokumentation. In diesem Beispiel dient auch „%c“ nur der Dokumentation und gibt an, dass die erwartete Ganzzahl 1 Byte groß ist (die deklarierte Ganzzahlgröße hat keinen Einfluss auf Parsing oder Kodierung).

Der Mikrocontroller-Build sammelt alle mit DECL_COMMAND() deklarierten Befehle, ermittelt deren Parameter und sorgt dafür, dass sie aufrufbar sind.

### Antworten deklarieren

Um Informationen vom Mikrocontroller an den Host zu senden, wird eine „response“ erzeugt. Diese werden mit dem C-Makro sendf() sowohl deklariert als auch übertragen. Zum Beispiel:

```
sendf("status clock=%u status=%c", sched_read_time(), sched_is_shutdown());
```

Das Obige überträgt eine „status“-Antwortnachricht, die zwei Ganzzahl-Parameter enthält („clock“ und „status“). Der Mikrocontroller-Build findet automatisch alle sendf()-Aufrufe und erzeugt dafür Kodierer. Der erste Parameter der Funktion sendf() beschreibt die Antwort und hat dasselbe Format wie Befehlsdeklarationen.

Der Host kann für jede Antwort eine Callback-Funktion registrieren. Im Ergebnis erlauben Befehle dem Host also, C-Funktionen im Mikrocontroller aufzurufen, und Antworten erlauben der Mikrocontroller-Software, Code auf dem Host aufzurufen.

Das Makro sendf() sollte nur aus Befehls- oder Task-Handlern heraus aufgerufen werden und nicht aus Interrupts oder Timern. Der Code muss nicht auf einen empfangenen Befehl mit einem sendf() antworten, die Anzahl der sendf()-Aufrufe ist nicht begrenzt, und sendf() darf jederzeit aus einem Task-Handler aufgerufen werden.

#### Ausgabe-Antworten

Zur Vereinfachung des Debuggens gibt es außerdem eine C-Funktion output(). Zum Beispiel:

```
output("The value of %u is %s with size %u.", x, buf, buf_len);
```

Die Funktion output() wird ähnlich wie printf() verwendet - sie ist dazu gedacht, beliebige Nachrichten für menschliche Leser zu erzeugen und zu formatieren.

### Aufzählungen deklarieren

Aufzählungen erlauben es dem Host-Code, Zeichenketten-Bezeichner für Parameter zu verwenden, die der Mikrocontroller als Ganzzahlen verarbeitet. Sie werden im Mikrocontroller-Code deklariert - zum Beispiel:

```
DECL_ENUMERATION("spi_bus", "spi", 0);

DECL_ENUMERATION_RANGE("pin", "PC0", 16, 8);
```

Im ersten Beispiel definiert das Makro DECL_ENUMERATION() eine Aufzählung für jede Befehls-/Antwortnachricht mit einem Parameternamen „spi_bus“ oder einem Parameternamen mit der Endung „_spi_bus“. Für diese Parameter ist die Zeichenkette „spi“ ein gültiger Wert und wird mit dem Ganzzahlwert null übertragen.

Es ist auch möglich, einen Aufzählungsbereich zu deklarieren. Im zweiten Beispiel würde ein Parameter „pin“ (oder ein beliebiger Parameter mit der Endung „_pin“) PC0, PC1, PC2, ..., PC7 als gültige Werte akzeptieren. Die Zeichenketten werden mit den Ganzzahlen 16, 17, 18, ..., 23 übertragen.

### Konstanten deklarieren

Auch Konstanten können exportiert werden. Zum Beispiel würde Folgendes:

```
DECL_CONSTANT("SERIAL_BAUD", 250000);
```

eine Konstante namens „SERIAL_BAUD“ mit dem Wert 250000 vom Mikrocontroller zum Host exportieren. Es ist auch möglich, eine Konstante zu deklarieren, die eine Zeichenkette ist - zum Beispiel:

```
DECL_CONSTANT_STR("MCU", "pru");
```

## Low-Level Nachrichtenkodierung

Um den oben beschriebenen RPC-Mechanismus umzusetzen, wird jeder Befehl und jede Antwort für die Übertragung in ein Binärformat kodiert. Dieser Abschnitt beschreibt das Übertragungssystem.

### Nachrichtenblöcke

Alle Daten, die vom Host zum Mikrocontroller und umgekehrt gesendet werden, sind in „Nachrichtenblöcken“ enthalten. Ein Nachrichtenblock hat einen zwei Byte langen Header und einen drei Byte langen Trailer. Das Format eines Nachrichtenblocks ist:

```
<1 byte length><1 byte sequence><n-byte content><2 byte crc><1 byte sync>
```

Das Längen-Byte enthält die Anzahl der Bytes im Nachrichtenblock einschließlich der Header- und Trailer-Bytes (die minimale Nachrichtenlänge beträgt somit 5 Bytes). Die maximale Länge eines Nachrichtenblocks beträgt derzeit 64 Bytes. Das Sequenz-Byte enthält in den niederwertigen Bits eine 4-Bit-Sequenznummer, die höherwertigen Bits enthalten stets 0x10 (die höherwertigen Bits sind für zukünftige Verwendung reserviert). Die Inhalts-Bytes enthalten beliebige Daten, deren Format im folgenden Abschnitt beschrieben wird. Die CRC-Bytes enthalten eine 16-Bit-CCITT-[CRC](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) des Nachrichtenblocks einschließlich der Header-Bytes, aber ohne die Trailer-Bytes. Das Sync-Byte ist 0x7e.

Das Format des Nachrichtenblocks ist von [HDLC](https://en.wikipedia.org/wiki/High-Level_Data_Link_Control)-Nachrichtenrahmen inspiriert. Wie bei HDLC darf der Nachrichtenblock optional ein zusätzliches Sync-Zeichen am Blockanfang enthalten. Anders als bei HDLC ist ein Sync-Zeichen nicht ausschließlich dem Rahmen vorbehalten und kann auch im Inhalt des Nachrichtenblocks vorkommen.

### Inhalt des Nachrichtenblocks

Jeder vom Host zum Mikrocontroller gesendete Nachrichtenblock enthält in seinem Inhalt eine Folge von null oder mehr Nachrichtenbefehlen. Jeder Befehl beginnt mit einer als [Variable Length Quantity](#variable-length-quantities) (VLQ) kodierten Ganzzahl-Befehls-ID, gefolgt von null oder mehr VLQ-Parametern für den jeweiligen Befehl.

Als Beispiel könnten die folgenden vier Befehle in einem einzigen Nachrichtenblock platziert werden:

```
update_digital_out oid=6 value=1
update_digital_out oid=5 value=0
get_config
get_clock
```

und in die folgenden acht VLQ-Ganzzahlen kodiert werden:

```
<id_update_digital_out><6><1><id_update_digital_out><5><0><id_get_config><id_get_clock>
```

Um den Nachrichteninhalt zu kodieren und zu parsen, müssen sich Host und Mikrocontroller über die Befehls-IDs und die Anzahl der Parameter jedes Befehls einig sein. Im obigen Beispiel wüssten also sowohl Host als auch Mikrocontroller, dass auf „id_update_digital_out“ immer zwei Parameter folgen und dass „id_get_config“ und „id_get_clock“ keine Parameter haben. Host und Mikrocontroller teilen sich ein „Data Dictionary“, das die Befehlsbeschreibungen (z. B. „update_digital_out oid=%c value=%c“) ihren ganzzahligen Befehls-IDs zuordnet. Beim Verarbeiten der Daten weiß der Parser, dass nach einer bestimmten Befehls-ID eine bestimmte Anzahl VLQ-kodierter Parameter zu erwarten ist.

Der Nachrichteninhalt von Blöcken, die vom Mikrocontroller zum Host gesendet werden, folgt demselben Format. Die Bezeichner in diesen Nachrichten sind „Antwort-IDs“, aber sie erfüllen denselben Zweck und folgen denselben Kodierungsregeln. In der Praxis enthalten Nachrichtenblöcke, die vom Mikrocontroller zum Host gesendet werden, nie mehr als eine Antwort im Blockinhalt.

#### Mengen mit variabler Länge

Weitere Informationen zum allgemeinen Format VLQ-kodierter Ganzzahlen finden Sie im [Wikipedia-Artikel](https://en.wikipedia.org/wiki/Variable-length_quantity). Klipper verwendet ein Kodierungsschema, das sowohl positive als auch negative Ganzzahlen unterstützt. Ganzzahlen nahe null benötigen weniger Bytes, und positive Ganzzahlen werden typischerweise mit weniger Bytes kodiert als negative. Die folgende Tabelle zeigt, wie viele Bytes jede Ganzzahl zur Kodierung benötigt:

| Ganzzahl | Kodierte Größe |
| --- | --- |
| -32 .. 95 | 1 |
| -4096 .. 12287 | 2 |
| -524288 .. 1572863 | 3 |
| -67108864 .. 201326591 | 4 |
| -2147483648 .. 4294967295 | 5 |

#### Zeichenketten variabler Länge

Als Ausnahme von den obigen Kodierungsregeln gilt: Ist ein Parameter eines Befehls oder einer Antwort eine dynamische Zeichenkette, so wird dieser Parameter nicht als einfache VLQ-Ganzzahl kodiert. Stattdessen wird er kodiert, indem die Länge als VLQ-kodierte Ganzzahl übertragen wird, gefolgt vom Inhalt selbst:

```
<VLQ encoded length><n-byte contents>
```

Die im Data Dictionary enthaltenen Befehlsbeschreibungen erlauben es sowohl dem Host als auch dem Mikrocontroller zu wissen, welche Befehlsparameter einfache VLQ-Kodierung und welche Zeichenketten-Kodierung verwenden.

## Daten Wörterbuch

Damit eine sinnvolle Kommunikation zwischen Mikrocontroller und Host zustande kommt, müssen sich beide Seiten auf ein „Data Dictionary“ einigen. Dieses Data Dictionary enthält die ganzzahligen Bezeichner für Befehle und Antworten zusammen mit deren Beschreibungen.

Der Mikrocontroller-Build verwendet den Inhalt der Makros DECL_COMMAND() und sendf(), um das Data Dictionary zu erzeugen. Der Build weist jedem Befehl und jeder Antwort automatisch eindeutige Bezeichner zu. Dieses System erlaubt es sowohl dem Host- als auch dem Mikrocontroller-Code, nahtlos beschreibende, menschenlesbare Namen zu verwenden und dennoch minimale Bandbreite zu nutzen.

Der Host fragt das Data Dictionary ab, wenn er sich erstmals mit dem Mikrocontroller verbindet. Sobald der Host das Data Dictionary vom Mikrocontroller heruntergeladen hat, verwendet er es, um alle Befehle zu kodieren und alle Antworten des Mikrocontrollers zu parsen. Der Host muss daher ein dynamisches Data Dictionary handhaben. Um die Mikrocontroller-Software einfach zu halten, verwendet der Mikrocontroller jedoch immer sein statisches (einkompiliertes) Data Dictionary.

Das Data Dictionary wird abgefragt, indem „identify“-Befehle an den Mikrocontroller gesendet werden. Der Mikrocontroller antwortet auf jeden identify-Befehl mit einer „identify_response“-Nachricht. Da diese beiden Befehle vor dem Erhalt des Data Dictionary benötigt werden, sind ihre ganzzahligen IDs und Parametertypen sowohl im Mikrocontroller als auch im Host fest einkodiert. Die Antwort-ID von „identify_response“ ist 0, die Befehls-ID von „identify“ ist 1. Abgesehen von den fest einkodierten IDs werden der identify-Befehl und seine Antwort genauso deklariert und übertragen wie andere Befehle und Antworten. Kein anderer Befehl und keine andere Antwort ist fest einkodiert.

Das Format des übertragenen Data Dictionary selbst ist eine zlib-komprimierte JSON-Zeichenkette. Der Build-Prozess des Mikrocontrollers erzeugt die Zeichenkette, komprimiert sie und legt sie im Text-Abschnitt des Mikrocontroller-Flash ab. Das Data Dictionary kann deutlich größer sein als die maximale Nachrichtenblockgröße - der Host lädt es herunter, indem er mehrere identify-Befehle sendet, die aufeinanderfolgende Teile des Data Dictionary anfordern. Sobald alle Teile vorliegen, setzt der Host sie zusammen, dekomprimiert die Daten und parst den Inhalt.

Zusätzlich zu Informationen über das Kommunikationsprotokoll enthält das Data Dictionary auch die Softwareversion, Aufzählungen (wie durch DECL_ENUMERATION definiert) und Konstanten (wie durch DECL_CONSTANT definiert).

## Nachrichtenfluss

Nachrichtenbefehle, die vom Host zum Mikrocontroller gesendet werden, sollen fehlerfrei sein. Der Mikrocontroller prüft CRC und Sequenznummern in jedem Nachrichtenblock, um sicherzustellen, dass die Befehle korrekt und in der richtigen Reihenfolge sind. Der Mikrocontroller verarbeitet Nachrichtenblöcke immer in der richtigen Reihenfolge - empfängt er einen Block außer der Reihe, verwirft er ihn und alle weiteren Blöcke außer der Reihe, bis er Blöcke mit der korrekten Reihenfolge empfängt.

Der Low-Level-Host-Code implementiert ein System zur automatischen Neuübertragung für verlorene und beschädigte Nachrichtenblöcke, die an den Mikrocontroller gesendet werden. Dazu überträgt der Mikrocontroller nach jedem erfolgreich empfangenen Nachrichtenblock einen „Ack-Nachrichtenblock“. Der Host setzt nach dem Senden jedes Blocks eine Zeitüberschreitung und überträgt erneut, falls diese abläuft, ohne dass ein entsprechendes „Ack“ empfangen wurde. Erkennt der Mikrocontroller zusätzlich einen beschädigten oder außer der Reihe empfangenen Block, kann er einen „Nak-Nachrichtenblock“ senden, um eine schnelle Neuübertragung zu ermöglichen.

Ein „Ack“ ist ein Nachrichtenblock mit leerem Inhalt (also ein 5 Byte großer Nachrichtenblock) und einer Sequenznummer, die größer ist als die zuletzt empfangene Host-Sequenznummer. Ein „Nak“ ist ein Nachrichtenblock mit leerem Inhalt und einer Sequenznummer, die kleiner ist als die zuletzt empfangene Host-Sequenznummer.

Das Protokoll ermöglicht ein „Fenster“-Übertragungssystem, sodass der Host viele Nachrichtenblöcke gleichzeitig unterwegs haben kann. (Dies gilt zusätzlich zu den vielen Befehlen, die in einem einzelnen Nachrichtenblock enthalten sein können.) Das erlaubt maximale Bandbreitenausnutzung selbst bei Übertragungslatenz. Die Mechanismen für Zeitüberschreitung, Neuübertragung, Fenster und Ack sind von ähnlichen Mechanismen in [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) inspiriert.

In der Gegenrichtung sind Nachrichtenblöcke, die vom Mikrocontroller zum Host gesendet werden, zwar fehlerfrei ausgelegt, ihre Übertragung ist aber nicht garantiert. (Antworten sollten nicht beschädigt sein, können aber verloren gehen.) Das dient dazu, die Implementierung im Mikrocontroller einfach zu halten. Es gibt kein System zur automatischen Neuübertragung von Antworten - vom High-Level-Code wird erwartet, dass er eine gelegentlich fehlende Antwort verkraftet (üblicherweise indem der Inhalt erneut angefordert oder ein wiederkehrender Zeitplan für die Antwortübertragung eingerichtet wird). Das Sequenznummernfeld in Nachrichtenblöcken, die an den Host gesendet werden, ist stets um eins größer als die zuletzt empfangene Sequenznummer der vom Host empfangenen Nachrichtenblöcke. Es wird nicht dazu verwendet, Sequenzen von Antwort-Nachrichtenblöcken nachzuverfolgen.
