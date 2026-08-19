# CANBUS protocol

This document describes the protocol Klipper uses to communicate over [CAN bus](https://en.wikipedia.org/wiki/CAN_bus). See <CANBUS.md> for information on configuring Klipper with CAN bus.

## Asignación de identificadores de microcontroladores

Klipper utiliza únicamente paquetes de bus CAN de tamaño estándar CAN 2.0A, que están limitados a 8 bytes de datos y un identificador de bus CAN de 11 bits. Para permitir una comunicación eficiente, a cada microcontrolador se le asigna en tiempo de ejecución un identificador de nodo de bus CAN único de 1 byte (`canbus_nodeid`) para el tráfico general de comandos y respuestas de Klipper. Los mensajes de comando de Klipper que van del host al microcontrolador utilizan el identificador de bus CAN de `canbus_nodeid * 2 + 256`, mientras que los mensajes de respuesta de Klipper del microcontrolador al host utilizan `canbus_nodeid * 2 + 256 + 1`.

Cada microcontrolador tiene un identificador de chip único asignado de fábrica que se utiliza durante la asignación de identificadores. Este identificador puede superar la longitud de un paquete CAN, por lo que se utiliza una función hash para generar un identificador único de 6 bytes (`canbus_uuid`) a partir del identificador de fábrica.

## Mensajes del administrador

Los mensajes de administración se utilizan para la asignación de identificadores. Los mensajes de administración enviados desde el host al microcontrolador utilizan el identificador de bus CAN «0x3f0», y los mensajes enviados desde el microcontrolador al host utilizan el identificador de bus CAN «0x3f1». Todos los microcontroladores escuchan los mensajes con el identificador «0x3f0», que puede considerarse como una «dirección de difusión».

### Mensaje CMD_QUERY_UNASSIGNED

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
