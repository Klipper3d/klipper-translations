# CANBUS-Fehlerbehebung

Dieses Dokument enthält Informationen zur Behebung von Kommunikationsproblemen bei der Verwendung von [Klipper mit CAN-Bus](CANBUS.md).

## CAN-Bus-Verkabelung überprüfen

Der erste Schritt bei der Fehlerbehebung von Kommunikationsproblemen besteht darin, die CAN-Bus-Verkabelung zu überprüfen.

Be sure there are exactly two 120 Ohm [terminating
resistors](CANBUS.md#terminating-resistors) on the CAN bus. If the resistors are not properly installed then messages may not be able to be sent at all or the connection may have sporadic instability.

Die CANH- und CANL-Busverkabelung sollte umeinander verdrillt sein. Die Verkabelung sollte mindestens alle paar Zentimeter eine Verdrillung aufweisen. Vermeiden Sie es, CANH- und CANL-Leitungen um Stromkabel zu verdrillen, und stellen Sie sicher, dass parallel zu CANH und CANL verlaufende Stromkabel nicht dieselbe Anzahl an Verdrillungen aufweisen.

Stellen Sie sicher, dass alle Stecker und Aderendhülsen an der CAN-Bus-Verkabelung fest sitzen. Bewegungen des Druckerwerkzeugkopfs können die CAN-Bus-Verkabelung erschüttern, sodass eine schlechte Crimpverbindung oder ein lockerer Stecker zu sporadischen Kommunikationsfehlern führen kann.

## Auf steigenden bytes_invalid-Zähler prüfen

Die Klipper-Logdatei meldet einmal pro Sekunde eine `Stats`-Zeile, wenn der Drucker aktiv ist. Diese "Stats"-Zeilen enthalten für jeden Mikrocontroller einen Zähler `bytes_invalid`. Dieser Zähler sollte sich während des normalen Druckerbetriebs nicht erhöhen (es ist normal, dass der Zähler nach einem RESTART ungleich null ist, und es ist unbedenklich, wenn sich der Zähler etwa einmal im Monat erhöht). Erhöht sich dieser Zähler bei einem CAN-Bus-Mikrocontroller während des normalen Druckens (mehrmals pro Stunde oder häufiger), deutet dies auf ein schwerwiegendes Problem hin.

Incrementing `bytes_invalid` on a CAN bus connection is a symptom of reordered messages on the CAN bus. If seen, make sure to:

* Use a Linux kernel version 6.6.0 or later.
* If using a USB-to-CANBUS adapter running candlelight firmware, use v2.0 or later of candleLight_fw.
* If using Klipper's USB-to-CANBUS bridge mode, make sure the bridge node is flashed with Klipper v0.12.0 or later.

Reordered messages is a severe problem that must be fixed. It will result in unstable behavior and can lead to confusing errors at any part of a print. An incrementing `bytes_invalid` is not caused by wiring or similar hardware issues and can only be fixed by identifying and updating the faulty software.

Older versions of the Linux kernel had a bug in the gs_usb canbus driver code that could cause reordered canbus packets. The issue is thought to be fixed in [Linux commit 24bc41b4](https://github.com/torvalds/linux/commit/24bc41b4558347672a3db61009c339b1f5692169) which was released in v6.6.0. In some cases, older Linux versions may not show the problem (due to how hardware interrupts are configured), however if problems are seen the recommended solution is to upgrade to a newer kernel.

Older versions of candlelight firmware could reorder canbus packets, and the issue is thought to be fixed in [candlelight_fw commit 8b3a7b45](https://github.com/candle-usb/candleLight_fw/commit/8b3a7b4565a3c9521b762b154c94c72c5acb2bcf).

Older versions of Klipper's USB-to-CANBUS bridge code could incorrectly drop canbus messages. This is not as severe as reordering messages, but it should still be fixed. It is thought to be fixed with [Klipper PR #6175](https://github.com/Klipper3d/klipper/pull/6175).

## Eine geeignete txqueuelen-Einstellung verwenden

Der Klipper-Code nutzt den Linux-Kernel, um den CAN-Bus-Verkehr zu verwalten. Standardmäßig puffert der Kernel nur 10 CAN-Sendepakete. Es wird empfohlen, das [can0-Gerät zu konfigurieren](CANBUS.md#host-hardware) mit `txqueuelen 128`, um diese Größe zu erhöhen.

Sendet Klipper ein Paket und hat Linux seinen gesamten Sendepuffer bereits belegt, verwirft Linux dieses Paket, und im Klipper-Log erscheinen Meldungen wie die folgende:

```
Got error -1 in can write: (105)No buffer space available
```

Klipper überträgt verlorene Nachrichten im Rahmen seines normalen Nachrichten-Wiederholungssystems auf Anwendungsebene automatisch erneut. Diese Log-Meldung ist daher eine Warnung und weist nicht auf einen nicht behebbaren Fehler hin.

Kommt es zu einem vollständigen CAN-Bus-Ausfall (etwa durch einen Kabelbruch), kann Linux keinerlei Nachrichten mehr über den CAN-Bus senden, und die obige Meldung erscheint dann häufig im Klipper-Log. In diesem Fall ist die Log-Meldung ein Symptom eines größeren Problems (die Unfähigkeit, überhaupt Nachrichten zu senden) und steht nicht direkt mit dem Linux-`txqueuelen` in Zusammenhang.

Die aktuelle Puffergröße kann mit dem Linux-Befehl `ip link show can0` überprüft werden. Er sollte unter anderem den Textausschnitt `qlen 128` ausgeben. Erscheint stattdessen etwa `qlen 10`, deutet dies darauf hin, dass das CAN-Gerät nicht korrekt konfiguriert wurde.

Es wird nicht empfohlen, ein `txqueuelen` deutlich größer als 128 zu verwenden. Ein CAN-Bus mit einer Frequenz von 1000000 benötigt üblicherweise etwa 120 µs, um ein CAN-Paket zu übertragen. Eine Warteschlange mit 128 Paketen benötigt daher voraussichtlich etwa 15-20 ms, um geleert zu werden. Eine deutlich größere Warteschlange könnte zu übermäßigen Spitzen bei der Round-Trip-Zeit von Nachrichten führen, was wiederum zu nicht behebbaren Fehlern führen könnte. Anders ausgedrückt: Klippers Wiederholungssystem auf Anwendungsebene ist robuster, wenn es nicht darauf warten muss, dass Linux eine übermäßig große Warteschlange mit möglicherweise veralteten Daten leert. Dies ist vergleichbar mit dem Problem des [Bufferbloat](https://en.wikipedia.org/wiki/Bufferbloat) bei Internet-Routern.

Unter normalen Umständen nutzt Klipper pro MCU etwa 25 Warteschlangenplätze - üblicherweise werden nur bei erneuten Übertragungen mehr Plätze genutzt. (Genauer gesagt kann der Klipper-Host bis zu 192 Byte an jeden Klipper-MCU senden, bevor er von diesem MCU eine Bestätigung erhält.) Befinden sich 5 oder mehr Klipper-MCUs an einem einzelnen CAN-Bus, kann es notwendig sein, `txqueuelen` über den empfohlenen Wert von 128 zu erhöhen. Wie oben beschrieben sollte jedoch bei der Wahl eines neuen Werts darauf geachtet werden, eine übermäßige Round-Trip-Latenz zu vermeiden.

## Use `canbus_query.py` only to identify nodes never previously seen

It is only valid to use the [`canbus_query.py` tool](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) to identify micro-controllers that have never been previously identified. Once all nodes on a bus are identified, record the resulting uuids in the printer.cfg, and avoid running the tool unnecessarily.

The tool is implemented using a low-level mechanism that can cause nodes to internally observe bus errors. These internal errors may result in communication interruptions and may result is some nodes disconnecting from the bus.

It is not valid to use the tool to "ping" if a node is connected. Do not run the tool during an active print.

## candump Protokolle Abrufen

Die an den Mikrocontroller gesendeten und von ihm empfangenen CAN-Bus-Nachrichten werden vom Linux-Kernel verwaltet. Es ist möglich, diese Nachrichten zu Diagnosezwecken vom Kernel aus zu erfassen. Ein Protokoll dieser Nachrichten kann für die Diagnose nützlich sein.

Das Linux-Werkzeug [can-utils](https://github.com/linux-can/can-utils) stellt die Erfassungssoftware bereit. Es wird auf einem Rechner üblicherweise wie folgt installiert:

```
sudo apt-get update && sudo apt-get install can-utils
```

Nach der Installation kann mit folgendem Befehl eine Aufzeichnung aller CAN-Bus-Nachrichten auf einer Schnittstelle erstellt werden:

```
candump -tz -Ddex can0,#FFFFFFFF > mycanlog
```

Die resultierende Protokolldatei (im obigen Beispiel `mycanlog`) kann eingesehen werden, um jede von Klipper gesendete und empfangene rohe CAN-Bus-Nachricht zu sehen. Um den Inhalt dieser Nachrichten zu verstehen, sind in der Regel Low-Level-Kenntnisse von Klippers [CANBUS-Protokoll](CANBUS_protocol.md) und Klippers [MCU-Befehlen](MCU_Commands.md) erforderlich.

### Klipper-Nachrichten in einem candump-Log parsen

Mit dem Werkzeug `parsecandump.py` lassen sich die in einem candump-Log enthaltenen Low-Level-Nachrichten des Klipper-Mikrocontrollers parsen. Die Verwendung dieses Werkzeugs ist ein fortgeschrittenes Thema, das Kenntnisse der Klipper-[MCU-Befehle](MCU_Commands.md) voraussetzt. Zum Beispiel:

```
./scripts/parsecandump.py mycanlog 108 ./out/klipper.dict
```

This tool produces output similar to the [parsedump
tool](Debugging.md#translating-gcode-files-to-micro-controller-commands). See the documentation for that tool for information on generating the Klipper micro-controller data dictionary.

In the above example, `108` is the [CAN bus
id](CANBUS_protocol.md#micro-controller-id-assignment). It is a hexadecimal number. The id `108` is assigned by Klipper to the first micro-controller. If the CAN bus has multiple micro-controllers on it, then the second micro-controller would be `10a`, the third would be `10c`, and so on.

Das candump-Log muss mit den Kommandozeilenargumenten `-tz -Ddex` erzeugt werden (zum Beispiel: `candump -tz -Ddex can0,#FFFFFFFF`), um das Werkzeug `parsecandump.py` verwenden zu können.

## Verwendung eines Logic-Analyzers an der CAN-Bus-Verkabelung

Die Software [Sigrok Pulseview](https://sigrok.org/wiki/PulseView) zusammen mit einem kostengünstigen [Logic-Analyzer](https://en.wikipedia.org/wiki/Logic_analyzer) kann bei der Diagnose der CAN-Bus-Signalisierung nützlich sein. Dies ist ein fortgeschrittenes Thema, das wahrscheinlich nur für Experten von Interesse ist.

Häufig lassen sich "USB-Logic-Analyzer" für unter 15 $ finden (Preise für die USA, Stand 2023). Diese Geräte werden oft als "Saleae-Logic-Klone" oder als "24-MHz-8-Kanal-USB-Logic-Analyzer" angeboten.

![pulseview-canbus](img/pulseview-canbus.png)

Das obige Bild wurde mit Pulseview und einem "Saleae-Klon"-Logic-Analyzer aufgenommen. Die Software Sigrok und Pulseview wurde auf einem Desktop-Rechner installiert (installieren Sie auch die Firmware "fx2lafw", falls diese separat verpackt ist). Der Pin CH0 am Logic-Analyzer wurde mit der CAN-Rx-Leitung verbunden, der Pin CH1 mit dem CAN-Tx-Pin, und GND wurde mit GND verbunden. Pulseview wurde so konfiguriert, dass nur die Leitungen D0 und D1 angezeigt werden (rotes "Sonden"-Symbol mittig oben in der Werkzeugleiste). Die Anzahl der Abtastungen wurde auf 5 Millionen gesetzt (obere Werkzeugleiste), und die Abtastrate wurde auf 24 MHz gesetzt (obere Werkzeugleiste). Der CAN-Decoder wurde hinzugefügt (gelbes und grünes "Blasen-Symbol" rechts oben in der Werkzeugleiste). Der Kanal D0 wurde als RX beschriftet und so eingestellt, dass er bei einer fallenden Flanke auslöst (Klick auf das schwarze D0-Label links). Der Kanal D1 wurde als TX beschriftet (Klick auf das braune D1-Label links). Der CAN-Decoder wurde auf eine Rate von 1 MBit konfiguriert (Klick auf das grüne CAN-Label links). Der CAN-Decoder wurde an die Spitze der Anzeige verschoben (Klicken und Ziehen des grünen CAN-Labels). Abschließend wurde die Aufzeichnung gestartet (Klick auf "Run" oben links), und ein Paket wurde auf dem CAN-Bus gesendet (`cansend can0 123#121212121212`).

Der Logic-Analyzer bietet ein unabhängiges Werkzeug zur Paketerfassung und zur Überprüfung des Bit-Timings.
