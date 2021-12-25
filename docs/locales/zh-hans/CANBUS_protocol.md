# CANBUS 协议

本文档描述了 Klipper 通过[CAN总线](https://en.wikipedia.org/wiki/CAN_bus)进行通信的协议。参见<CANBUS.md>了解如何在 Klipper 中配置 CAN 总线。

## 微控制器 ID 分配

Klipper使用 CAN 2.0A 标准尺寸的 CAN 总线数据包，它被限制在8个数据字节和一个11位的CAN总线标识。为了保证高效的通信，每个微控制器在运行时被分配一个唯一的 1 字节的CAN总线节点 ID（`canbus_nodeid`）用于一般的 Klipper 命令和响应通信。从主机到微控制器的 Klipper 命令信息使用`canbus_nodeid * 2 + 256` 的CAN总线 ID，而从微控制器到主机的 Klipper 响应信息使用`canbus_nodeid * 2 + 256 + 1`。

每个微控制器出厂时都有一个用于ID分配的唯一的芯片标识符。这个标识符可以超过一个 CAN 数据包的长度，一个哈希函数会用出厂标识符生成一个唯一的 6 字节标识（`canbus_uuid`）。

## 管理消息

管理信息用于 ID 分配。从主机发送到微控制器的管理消息使用CAN总线的 ID `0x3f0`，而从微控制器发送到主机的消息使用CAN总线的 ID `0x3f1`。所有的微控制器都听从ID `0x3f0`上的消息；这个 ID 可以被认为是一个"广播地址"。

### CMD_QUERY_UNASSIGNED 消息

该命令查询所有尚未被分配 `canbus_nodeid` 的微控制器。未分配的微控制器将以 RESP_NEED_NODEID 响应消息进行回应。

CMD_QUERY_UNASSIGNED 消息格式是：`<1-byte message_id = 0x00>`

### CMD_SET_NODEID 消息

这个命令根据微处理器给定的 `canbus_uuid` 给相应的微处理器分配一个 `canbus_nodeid`。

CMD_SET_NODEID消息格式是：`<1字节message_id = 0x01><6字节canbus_uuid><1字节canbus_nodeid>`

### RESP_NEED_NODEID 消息

RESP_NEED_NODEID消息格式为：`<1字节message_id = 0x20><6字节canbus_uuid>`

## 数据包

通过 CMD_SET_NODEID 命令分配了节点 ID 的微控制器可以发送和接收数据包。

带有节点接收 CAN 总线ID（`canbus_nodeid * 2 + 256`）的消息中的数据包被简单地添加到一个缓冲区，当一个完整的[mcu 协议消息](Protocol.md)被找到时，其内容会被解析和处理。数据被视为一个字节流-- Klipper 消息块的开始位置与CAN总线数据包的开始位置不需要对齐。

类似地，mcu 协议消息响应通过将消息数据插入到具有节点发送 CAN 总线 ID 的一个或多个数据包（`canbus_nodeid * 2 + 256 + 1`）并从微控制器发送到主机。
