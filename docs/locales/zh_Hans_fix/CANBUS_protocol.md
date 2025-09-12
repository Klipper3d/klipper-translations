# CANBUS 协议

本文档描述了 Klipper 用于通过 [CAN 总线](https://zh.wikipedia.org/wiki/CAN%E6%80%BB%E7%BA%BF) 进行通信的协议。有关使用 CAN 总线配置 Klipper 的信息，请参阅 [CANBUS.md](CANBUS.md)。

## 微控制器 ID 分配

Klipper 仅使用 CAN 2.0A 标准尺寸的 CAN 总线数据包，该数据包限制为 8 个数据字节和一个 11 位的 CAN 总线标识符。为了支持高效通信，每个微控制器在运行时都会被分配一个唯一的 1 字节 CAN 总线节点 ID (`canbus_nodeid`)，用于常规的 Klipper 命令和响应通信。从主机发送到微控制器的 Klipper 命令消息使用 CAN 总线 ID 为 `canbus_nodeid * 2 + 256`，而从微控制器发送到主机的 Klipper 响应消息使用 `canbus_nodeid * 2 + 256 + 1`。

每个微控制器都有一个出厂时分配的唯一芯片标识符，该标识符在 ID 分配期间使用。此标识符可能超过一个 CAN 数据包的长度，因此使用哈希函数从出厂 ID 生成一个唯一的 6 字节 ID (`canbus_uuid`)。

## 管理消息

管理消息用于 ID 分配。从主机发送到微控制器的管理消息使用 CAN 总线 ID `0x3f0`，而从微控制器发送到主机的消息使用 CAN 总线 ID `0x3f1`。所有微控制器都监听 ID `0x3f0` 上的消息；该 ID 可以被视为“广播地址”。

### CMD_QUERY_UNASSIGNED 消息

此命令查询所有尚未被分配 `canbus_nodeid` 的微控制器。未分配的微控制器将响应一个 RESP_NEED_NODEID 响应消息。

CMD_QUERY_UNASSIGNED 消息格式为：
`<1 字节 消息 ID = 0x00>`

### CMD_SET_KLIPPER_NODEID 消息

此命令为具有给定 `canbus_uuid` 的微控制器分配一个 `canbus_nodeid`。

CMD_SET_KLIPPER_NODEID 消息格式为：
`<1 字节 消息 ID = 0x01><6 字节 canbus_uuid><1 字节 canbus_nodeid>`

### RESP_NEED_NODEID 消息

RESP_NEED_NODEID 消息格式为：
`<1 字节 消息 ID = 0x20><6 字节 canbus_uuid><1 字节 set_klipper_nodeid = 0x01>`

## 数据包

通过 CMD_SET_KLIPPER_NODEID 命令分配了节点 ID 的微控制器可以发送和接收数据包。

使用节点的接收 CAN 总线 ID (`canbus_nodeid * 2 + 256`) 的消息中的数据包数据将简单地附加到缓冲区中，当找到完整的 [mcu 协议消息](Protocol.md) 时，其内容将被解析和处理。数据被视为字节流——Klipper 消息块的开始不需要与 CAN 总线数据包的开始对齐。

同样，mcu 协议消息响应通过将消息数据复制到一个或多个具有节点的发送 CAN 总线 ID (`canbus_nodeid * 2 + 256 + 1`) 的数据包中，从微控制器发送到主机。