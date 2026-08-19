# CANBUS Protokoll

This document describes the protocol Klipper uses to communicate over [CAN bus](https://en.wikipedia.org/wiki/CAN_bus). See <CANBUS.md> for information on configuring Klipper with CAN bus.

## Mikrocontroller-ID-Zuweisung

Klipper verwendet nur CAN 2.0A Standard-CAN-Bus-Pakete, die auf 8 Datenbytes und einen 11-Bit-CAN-Bus-Identifier begrenzt sind. Um eine effiziente Kommunikation zu unterstützen, wird jedem Mikrocontroller während der Laufzeit eine eindeutige 1-Byte-CAN-Bus-Nodeid (`canbus_nodeid`) für den allgemeinen Klipper-Befehls- und Antwortverkehr zugewiesen. Klipper-Befehlsnachrichten, die vom Host zum Mikrocontroller gehen, verwenden die CAN-Bus-ID `canbus_nodeid * 2 + 256`, während Klipper-Antwortnachrichten vom Mikrocontroller zum Host `canbus_nodeid * 2 + 256 + 1` verwenden.

Jeder Mikro-Kontroller hat eine vom Hersteller eindeutige Chipidentifizierung, die bei der Vergabe der Id genutzt wird. Diese Chipidentifizierung kann länger als ein CAN Packet sein, weshalb diese gehasht wird um eine 6 byte lange (`canbus_uuid`) aus der Chipid zu erhalten.

## Admin Nachrichten

Admin messages are used for id assignment. Admin messages sent from host to micro-controller use the CAN bus id `0x3f0` and messages sent from micro-controller to host use the CAN bus id `0x3f1`. All micro-controllers listen to messages on id `0x3f0`; that id can be thought of as a "broadcast address".

### CMD_QUERY_UNASSIGNED Nachricht

This command queries all micro-controllers that have not yet been assigned a `canbus_nodeid`. Unassigned micro-controllers will respond with a RESP_NEED_NODEID response message.

Das CMD_QUERY_UNASSIGNED Nachrichtenformat ist: `<1-byte message_id = 0x00>`

### CMD_SET_KLIPPER_NODEID Nachricht

Dieser Befehl weist dem Mikrocontroller mit einer bestimmten `canbus_uuid` eine`canbus_nodeid` zu.

The CMD_SET_KLIPPER_NODEID message format is: `<1-byte message_id = 0x01><6-byte canbus_uuid><1-byte canbus_nodeid>`

### RESP_NEED_NODEID Nachricht

The RESP_NEED_NODEID message format is: `<1-byte message_id = 0x20><6-byte canbus_uuid><1-byte set_klipper_nodeid = 0x01>`

## Datenpakete

A micro-controller that has been assigned a nodeid via the CMD_SET_KLIPPER_NODEID command can send and receive data packets.

The packet data in messages using the node's receive CAN bus id (`canbus_nodeid * 2 + 256`) are simply appended to a buffer, and when a complete [mcu protocol message](Protocol.md) is found its contents are parsed and processed. The data is treated as a byte stream - there is no requirement for the start of a Klipper message block to align with the start of a CAN bus packet.

Similarly, mcu protocol message responses are sent from micro-controller to host by copying the message data into one or more packets with the node's transmit CAN bus id (`canbus_nodeid * 2 + 256 + 1`).
