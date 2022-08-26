# CANBUS 协议 (CANBUS protocol)

本文档描述了 Klipper 通过[CAN总线](https://en.wikipedia.org/wiki/CAN_bus)进行通信的协议。参见<CANBUS.md>了解如何在 Klipper 中配置 CAN 总线。

## 分配微控制器 ID (Micro-controller id assignment)

Klipper使用 CAN 2.0A 标准大小的 CAN Bus 包，是一个被限制在8 data bytes 和 11-bit CAN Bus 标识符。为了支持更高效的传输，每个微控制器 (micro-controller) 在运行时候去分配一个 1-byte 的CAN Bus nodeid (`canbus_nodeid`) 通常来说用于Klipper 的命令和响应通信。主机到微控制器的Klipper命令信息使用`canbus_nodeid * 2 + 256`的CAN总线ID，而从微控制器到主机的Klipper响应信息使用`canbus_nodeid * 2 + 256 + 1`。

每个微控制器出厂时都有一个用于ID分配的唯一的芯片标识符。这个标识符可以超过一个 CAN 数据包的长度，一个哈希函数会用出厂标识符生成一个唯一的 6 字节标识（`canbus_uuid`）。

## 管理消息

管理信息用于 ID 分配。从主机发送到微控制器的管理消息使用CAN总线的 ID `0x3f0`，而从微控制器发送到主机的消息使用CAN总线的 ID `0x3f1`。所有的微控制器都听从ID `0x3f0`上的消息；这个 ID 可以被认为是一个"广播地址"。

### CMD_QUERY_UNASSIGNED 消息

该命令查询所有尚未被分配 `canbus_nodeid` 的微控制器。未分配的微控制器将以 RESP_NEED_NODEID 响应消息进行回应。

CMD_QUERY_UNASSIGNED 消息格式是：`<1-byte message_id = 0x00>`

### CMD_SET_KLIPPER_NODEID 信息

这个命令根据微处理器给定的 `canbus_uuid` 给相应的微处理器分配一个 `canbus_nodeid`。

CMD_SET_KLIPPER_NODEID 消息的格式是：`<1-byte message_id = 0x01><6-byte canbus_uuid><1-byte canbus_nodeid>`

### RESP_NEED_NODEID 消息

RESP_NEED_NODEID 消息的格式是：`<1-byte message_id = 0x20><6-byte canbus_uuid><1-byte set_klipper_nodeid = 0x01>`

## 数据包

被 CMD_SET_KLIPPER_NODEID 命令分配了节点的微控制器可以接受和发送数据包。

带有节点接收 CAN 总线ID（`canbus_nodeid * 2 + 256`）的消息中的数据包被简单地添加到一个缓冲区，当一个完整的[mcu 协议消息](Protocol.md)被找到时，其内容会被解析和处理。数据被视为比特流（byte stream）- Klipper信息块的开头不需要与CAN bus的数据包开头对齐。

类似地，mcu 协议消息响应通过将消息数据插入到具有节点发送 CAN 总线 ID 的一个或多个数据包（`canbus_nodeid * 2 + 256 + 1`）并从微控制器发送到主机。
