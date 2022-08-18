# CANBUS protocol

This document describes the protocol Klipper uses to communicate over [CAN bus](https://en.wikipedia.org/wiki/CAN_bus). See <CANBUS.md> for information on configuring Klipper with CAN bus.

## Przypisanie id mikrokontrolera

Klipper używa tylko pakietów magistrali CAN 2.0A o standardowym rozmiarze, które są ograniczone do 8 bajtów danych i 11-bitowego identyfikatora magistrali CAN. W celu wspierania wydajnej komunikacji, każdy mikrokontroler ma przypisany w czasie pracy unikalny 1-bajtowy identyfikator węzła magistrali CAN (`canbus_nodeid`) dla ogólnego ruchu poleceń i odpowiedzi Klippera. Wiadomości komend Klippera idące od hosta do mikrokontrolera używają id magistrali CAN `canbus_nodeid * 2 + 256`, podczas gdy wiadomości odpowiedzi Klippera od mikrokontrolera do hosta używają `canbus_nodeid * 2 + 256 + 1`.

Każdy mikrokontroler ma fabrycznie przypisany unikalny identyfikator układu, który jest używany podczas przypisywania id. Ten identyfikator może przekroczyć długość jednego pakietu CAN, więc funkcja hashująca jest używana do generowania unikalnego 6-bajtowego id (`canbus_uuid`) z fabrycznego id.

## Admin messages

Admin messages are used for id assignment. Admin messages sent from host to micro-controller use the CAN bus id `0x3f0` and messages sent from micro-controller to host use the CAN bus id `0x3f1`. All micro-controllers listen to messages on id `0x3f0`; that id can be thought of as a "broadcast address".

### CMD_QUERY_UNASSIGNED message

This command queries all micro-controllers that have not yet been assigned a `canbus_nodeid`. Unassigned micro-controllers will respond with a RESP_NEED_NODEID response message.

The CMD_QUERY_UNASSIGNED message format is: `<1-byte message_id = 0x00>`

### CMD_SET_KLIPPER_NODEID message

This command assigns a `canbus_nodeid` to the micro-controller with a given `canbus_uuid`.

The CMD_SET_KLIPPER_NODEID message format is: `<1-byte message_id = 0x01><6-byte canbus_uuid><1-byte canbus_nodeid>`

### RESP_NEED_NODEID message

The RESP_NEED_NODEID message format is: `<1-byte message_id = 0x20><6-byte canbus_uuid><1-byte set_klipper_nodeid = 0x01>`

## Data Packets

A micro-controller that has been assigned a nodeid via the CMD_SET_KLIPPER_NODEID command can send and receive data packets.

The packet data in messages using the node's receive CAN bus id (`canbus_nodeid * 2 + 256`) are simply appended to a buffer, and when a complete [mcu protocol message](Protocol.md) is found its contents are parsed and processed. The data is treated as a byte stream - there is no requirement for the start of a Klipper message block to align with the start of a CAN bus packet.

Similarly, mcu protocol message responses are sent from micro-controller to host by copying the message data into one or more packets with the node's transmit CAN bus id (`canbus_nodeid * 2 + 256 + 1`).
