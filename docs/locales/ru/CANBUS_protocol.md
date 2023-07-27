# CANBUS protocol

This document describes the protocol Klipper uses to communicate over [CAN bus](https://en.wikipedia.org/wiki/CAN_bus). See <CANBUS.md> for information on configuring Klipper with CAN bus.

## Идентификатор микроконтроллера

Klipper использует только пакеты CAN 2.0A стандартного размера, которые ограничены 8 байтами данных и 11-битным идентификатором шины CAN. Чтобы поддерживать эффективную связь, каждому микроконтроллеру во время выполнения присваивается уникальный 1-байтовый идентификатор узла шины CAN (`canbus_nodeid`) для общего трафика команд и ответов Klipper. Командные сообщения Klipper, идущие от хоста к микроконтроллеру, используют идентификатор шины CAN `canbus_nodeid * 2 + 256`, в то время как ответные сообщения Klipper от микроконтроллера к хосту используют `canbus_nodeid * 2 + 256 + 1 `.

Каждый микроконтроллер имеет присвоенный заводом уникальный идентификатор чипа, который используется при назначении идентификатора. Этот идентификатор может превышать длину одного пакета CAN, поэтому хэш-функция используется для генерации уникального 6-байтового идентификатора (`canbus_uuid`) из заводского идентификатора.

## Сообщения администратора

Для присвоения идентификатора используются сообщения администратора. Административные сообщения, передаваемые от хоста к микроконтроллеру, используют идентификатор CAN-шины `0x3f0`, а сообщения, передаваемые от микроконтроллера к хосту, - идентификатор CAN-шины `0x3f1`. Все микроконтроллеры прослушивают сообщения с идентификатором `0x3f0`; этот идентификатор можно рассматривать как "широковещательный адрес".

### CMD_QUERY_UNASSIGNED сообщение

Эта команда запрашивает все микроконтроллеры, которым еще не присвоен `canbus_nodeid`. В ответ на запрос микроконтроллеры, которым еще не присвоен `canbus_nodeid`, выдают сообщение RESP_NEED_NODEID.

The CMD_QUERY_UNASSIGNED message format is: `<1-byte message_id = 0x00>`

### CMD_SET_KLIPPER_NODEID message

This command assigns a `canbus_nodeid` to the micro-controller with a given `canbus_uuid`.

The CMD_SET_KLIPPER_NODEID message format is: `<1-byte message_id = 0x01><6-byte canbus_uuid><1-byte canbus_nodeid>`

### RESP_NEED_NODEID сообщение

The RESP_NEED_NODEID message format is: `<1-byte message_id = 0x20><6-byte canbus_uuid><1-byte set_klipper_nodeid = 0x01>`

## Data Packets

A micro-controller that has been assigned a nodeid via the CMD_SET_KLIPPER_NODEID command can send and receive data packets.

The packet data in messages using the node's receive CAN bus id (`canbus_nodeid * 2 + 256`) are simply appended to a buffer, and when a complete [mcu protocol message](Protocol.md) is found its contents are parsed and processed. The data is treated as a byte stream - there is no requirement for the start of a Klipper message block to align with the start of a CAN bus packet.

Similarly, mcu protocol message responses are sent from micro-controller to host by copying the message data into one or more packets with the node's transmit CAN bus id (`canbus_nodeid * 2 + 256 + 1`).
