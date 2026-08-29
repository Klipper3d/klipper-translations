# CANBUS Protokoll

Dieses Dokument beschreibt das Protokoll, das Klipper für die Kommunikation über den [CAN-Bus](https://de.wikipedia.org/wiki/Controller_Area_Network) verwendet. Informationen zur Konfiguration von Klipper mit CAN-Bus finden Sie unter <CANBUS.md>.

## Mikrocontroller-ID-Zuweisung

Klipper verwendet nur CAN 2.0A Standard-CAN-Bus-Pakete, die auf 8 Datenbytes und einen 11-Bit-CAN-Bus-Identifier begrenzt sind. Um eine effiziente Kommunikation zu unterstützen, wird jedem Mikrocontroller während der Laufzeit eine eindeutige 1-Byte-CAN-Bus-Nodeid (`canbus_nodeid`) für den allgemeinen Klipper-Befehls- und Antwortverkehr zugewiesen. Klipper-Befehlsnachrichten, die vom Host zum Mikrocontroller gehen, verwenden die CAN-Bus-ID `canbus_nodeid * 2 + 256`, während Klipper-Antwortnachrichten vom Mikrocontroller zum Host `canbus_nodeid * 2 + 256 + 1` verwenden.

Jeder Mikro-Kontroller hat eine vom Hersteller eindeutige Chipidentifizierung, die bei der Vergabe der Id genutzt wird. Diese Chipidentifizierung kann länger als ein CAN Packet sein, weshalb diese gehasht wird um eine 6 byte lange (`canbus_uuid`) aus der Chipid zu erhalten.

## Admin Nachrichten

Admin-Nachrichten dienen der ID-Zuweisung. Vom Host an den Mikrocontroller gesendete Admin-Nachrichten verwenden die CAN-Bus-ID `0x3f0`, vom Mikrocontroller an den Host gesendete Nachrichten die CAN-Bus-ID `0x3f1`. Alle Mikrocontroller hören auf Nachrichten mit der ID `0x3f0`; diese ID kann als "Broadcast-Adresse" verstanden werden.

### CMD_QUERY_UNASSIGNED Nachricht

Dieser Befehl fragt alle Mikrocontroller ab, denen noch keine `canbus_nodeid` zugewiesen wurde. Nicht zugewiesene Mikrocontroller antworten mit einer Antwortnachricht RESP_NEED_NODEID.

Das CMD_QUERY_UNASSIGNED Nachrichtenformat ist: `<1-byte message_id = 0x00>`

### CMD_SET_KLIPPER_NODEID Nachricht

Dieser Befehl weist dem Mikrocontroller mit einer bestimmten `canbus_uuid` eine`canbus_nodeid` zu.

Das Nachrichtenformat von CMD_SET_KLIPPER_NODEID lautet: `<1-byte message_id = 0x01><6-byte canbus_uuid><1-byte canbus_nodeid>`

### RESP_NEED_NODEID Nachricht

Das Nachrichtenformat von RESP_NEED_NODEID lautet: `<1-byte message_id = 0x20><6-byte canbus_uuid><1-byte set_klipper_nodeid = 0x01>`

## Datenpakete

Ein Mikrocontroller, dem über den Befehl CMD_SET_KLIPPER_NODEID eine nodeid zugewiesen wurde, kann Datenpakete senden und empfangen.

Die Paketdaten von Nachrichten, die die Empfangs-CAN-Bus-ID des Knotens (`canbus_nodeid * 2 + 256`) verwenden, werden schlicht an einen Puffer angehängt; sobald ein vollständiger [MCU-Protokollnachrichtenblock](Protocol.md) gefunden ist, wird dessen Inhalt geparst und verarbeitet. Die Daten werden als Bytestrom behandelt - der Beginn eines Klipper-Nachrichtenblocks muss nicht mit dem Beginn eines CAN-Bus-Pakets zusammenfallen.

Ebenso werden Antworten auf MCU-Protokollnachrichten vom Mikrocontroller an den Host gesendet, indem die Nachrichtendaten in ein oder mehrere Pakete mit der Sende-CAN-Bus-ID des Knotens (`canbus_nodeid * 2 + 256 + 1`) kopiert werden.
