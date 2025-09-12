# CANBUS 故障排除

本文档提供了在使用 [Klipper 与 CAN 总线](CANBUS.md) 时，排查通信问题的相关信息。

## 验证 CAN 总线接线

排查通信问题的第一步是验证 CAN 总线的接线。

确保 CAN 总线上**恰好有两个 120 欧姆**的[终端电阻](CANBUS.md#terminating-resistors)。如果未正确安装这些电阻，则消息可能完全无法发送，或连接可能出现间歇性不稳定。

CANH 和 CANL 总线的导线应相互扭绞。最低要求是每隔几厘米就有一个扭绞。避免将 CANH 和 CANL 导线与电源线扭绞在一起，并确保与 CANH 和 CANL 线路平行铺设的电源线不要有相同的扭绞密度。

请验证 CAN 总线上的所有插头和压接线是否均已牢固固定。打印机喷头的移动可能会晃动 CAN 总线线路，导致压接不良或插头松动，从而引起间歇性通信错误。

## 检查 `bytes_invalid` 计数器是否递增

当打印机处于活动状态时，Klipper 日志文件会每秒报告一次 `Stats` 行。这些“Stats”行会为每个微控制器提供一个 `bytes_invalid` 计数器。在正常打印机操作期间，该计数器不应递增（在 RESTART 后计数器非零是正常的，如果计数器每月递增一次或更少，也不必担心）。如果在正常打印期间（例如每几小时或更频繁地递增），CAN 总线微控制器上的此计数器递增，则表明存在严重问题。

在 CAN 总线连接上 `bytes_invalid` 计数器递增，是 CAN 总线上消息顺序错乱的症状。如果发现此现象，请务必：
* 使用 Linux 内核版本 6.6.0 或更高版本。
* 如果使用运行 candlelight 固件的 USB-to-CANBUS 适配器，请使用 candleLight_fw 的 v2.0 或更高版本。
* 如果使用 Klipper 的 USB-to-CANBUS 桥接模式，请确保桥接节点已刷入 Klipper v0.12.0 或更高版本。

消息顺序错乱是一个必须解决的严重问题。它会导致运行不稳定，并可能在打印的任何阶段引发令人困惑的错误。`bytes_invalid` 计数器递增并非由接线或类似硬件问题引起，只能通过识别并更新有缺陷的软件来解决。

较旧版本的 Linux 内核在 gs_usb canbus 驱动代码中存在一个错误，可能导致 canbus 数据包顺序错乱。该问题被认为已在 [Linux commit 24bc41b4](https://github.com/torvalds/linux/commit/24bc41b4558347672a3db61009c339b1f5692169) 中修复，该修复版本发布于 v6.6.0。在某些情况下，较旧的 Linux 版本可能不会显示此问题（由于硬件中断的配置方式），但如果出现问题，建议的解决方案是升级到更新的内核。

较旧版本的 candlelight 固件可能会对 canbus 数据包进行错误的重新排序，该问题被认为已在 [candlelight_fw commit 8b3a7b45](https://github.com/candle-usb/candleLight_fw/commit/8b3a7b4565a3c9521b762b154c94c72c5acb2bcf) 中修复。

较旧版本的 Klipper USB-to-CANBUS 桥接代码可能会错误地丢弃 canbus 消息。这不如消息重新排序严重，但仍应修复。该问题被认为已在 [Klipper PR #6175](https://github.com/Klipper3d/klipper/pull/6175) 中修复。

## 使用适当的 `txqueuelen` 设置

Klipper 代码使用 Linux 内核来管理 CAN 总线流量。默认情况下，内核仅会排队 10 个 CAN 发送数据包。建议[将 can0 设备](CANBUS.md#host-hardware)配置为 `txqueuelen 128` 以增加此队列大小。

如果 Klipper 发送一个数据包而 Linux 已填满其所有发送队列空间，则 Linux 将丢弃该数据包，并在 Klipper 日志中出现类似以下的消息：
```
Got error -1 in can write: (105)No buffer space available
```
Klipper 将作为其正常应用层消息重传系统的一部分自动重传丢失的消息。因此，此日志消息是一个警告，并不表示不可恢复的错误。

如果发生完整的 CAN 总线故障（例如 CAN 线断裂），则 Linux 将无法在 CAN 总线上传输任何消息，此时在 Klipper 日志中发现上述消息是很常见的。在这种情况下，日志消息是更大问题（无法传输任何消息）的症状，与 Linux `txqueuelen` 无直接关系。

可以通过运行 Linux 命令 `ip link show can0` 来检查当前队列大小。它应报告包括 `qlen 128` 的文本片段。如果看到类似 `qlen 10` 的内容，则表明 CAN 设备未正确配置。

不建议使用显著大于 128 的 `txqueuelen`。以 1000000 频率运行的 CAN 总线通常需要大约 120 微秒来传输一个 CAN 数据包。因此，128 个数据包的队列可能需要大约 15-20 毫秒才能清空。更大的队列可能会导致消息往返时间出现过度峰值，从而导致不可恢复的错误。换句话说，如果 Klipper 的应用重传系统不必等待 Linux 清理一个可能已过时的大量数据队列，则其鲁棒性会更强。这类似于互联网路由器上的 [bufferbloat](https://en.wikipedia.org/wiki/Bufferbloat) 问题。

在正常情况下，Klipper 可能每 MCU 使用约 25 个队列槽位——通常仅在重传期间使用更多槽位。（具体来说，Klipper 主机可能在收到来自该 MCU 的确认之前向每个 Klipper MCU 传输最多 192 字节。）如果单个 CAN 总线上有 5 个或更多 Klipper MCU，则可能需要将 `txqueuelen` 增加到推荐值 128 以上。然而，如上所述，在选择新值时应小心，以避免过高的往返时间延迟。

## 仅使用 `canbus_query.py` 识别从未见过的节点

仅当识别从未识别过的微控制器时，才应使用 [`canbus_query.py` 工具](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers)。一旦总线上所有节点都被识别，应将生成的 uuid 记录在 printer.cfg 中，并避免不必要地运行该工具。

该工具是使用一种低级机制实现的，可能导致节点内部观察到总线错误。这些内部错误可能导致通信中断，并可能导致某些节点从总线上断开。

使用该工具“ping”以检查节点是否连接是无效的。请勿在主动打印期间运行该工具。

## 获取 candump 日志

发送到微控制器和从微控制器接收的 CAN 总线消息由 Linux 内核处理。可以从此内核捕获这些消息以用于调试目的。这些消息的日志在诊断中可能很有用。

Linux [can-utils](https://github.com/linux-can/can-utils) 工具提供了捕获软件。通常通过运行以下命令在机器上安装：
```
sudo apt-get update && sudo apt-get install can-utils
```

安装后，可以使用以下命令获取接口上所有 CAN 总线消息的捕获：
```
candump -tz -Ddex can0,#FFFFFFFF > mycanlog
```

可以查看生成的日志文件（如上例中的 `mycanlog`），以查看 Klipper 发送和接收的每个原始 CAN 总线消息。理解这些消息的内容可能需要对 Klipper 的 [CANBUS 协议](CANBUS_protocol.md) 和 Klipper 的 [MCU 命令](MCU_Commands.md) 有底层知识。

### 解析 candump 日志中的 Klipper 消息

可以使用 `parsecandump.py` 工具解析 candump 日志中包含的低层 Klipper 微控制器消息。使用此工具是一个高级主题，需要了解 Klipper [MCU 命令](MCU_Commands.md)。例如：
```
./scripts/parsecandump.py mycanlog 108 ./out/klipper.dict
```

此工具产生的输出类似于 [parsedump 工具](Debugging.md#translating-gcode-files-to-micro-controller-commands)。有关生成 Klipper 微控制器数据字典的信息，请参阅该工具的文档。

在上述示例中，`108` 是 [CAN 总线 id](CANBUS_protocol.md#micro-controller-id-assignment)。它是一个十六进制数字。Klipper 将 id `108` 分配给第一个微控制器。如果 CAN 总线上有多个微控制器，则第二个微控制器为 `10a`，第三个为 `10c`，依此类推。

为了使用 `parsecandump.py` 工具，candump 日志必须使用 `-tz -Ddex` 命令行参数生成（例如：`candump -tz -Ddex can0,#FFFFFFFF`）。

## 在 canbus 线路上使用逻辑分析仪

[ Sigrok Pulseview ](https://sigrok.org/wiki/PulseView) 软件配合低成本 [逻辑分析仪](https://en.wikipedia.org/wiki/Logic_analyzer) 可用于诊断 CAN 总线信号。这是一个高级主题，可能仅对专家感兴趣。

人们通常可以找到价格低于 15 美元的“USB 逻辑分析仪”（2023 年美国定价）。这些设备通常被列为“Saleae 逻辑克隆”或“24MHz 8 通道 USB 逻辑分析仪”。

[pulseview-canbus](img/pulseview-canbus.png)

上图是在使用 Pulseview 和“Saleae 克隆”逻辑分析仪时拍摄的。Sigrok 和 Pulseview 软件已安装在台式机上（如果单独打包，也请安装“fx2lafw”固件）。逻辑分析仪的 CH0 引脚连接到 CAN Rx 线，CH1 引脚连接到 CAN Tx 引脚，GND 连接到 GND。Pulseview 被配置为仅显示 D0 和 D1 线（顶部工具栏中央红色“探针”图标）。样本数量设置为 500 万（顶部工具栏），采样率设置为 24MHz（顶部工具栏）。添加了 CAN 解码器（右上角工具栏的黄色和绿色“气泡图标”）。D0 通道被标记为 RX 并设置为在下降沿触发（单击左侧黑色 D0 标签）。D1 通道被标记为 TX（单击左侧棕色 D1 标签）。CAN 解码器被配置为 1Mbit 速率（单击左侧绿色 CAN 标签）。CAN 解码器被移动到显示顶部（单击并拖动绿色 CAN 标签）。最后，启动捕获（单击左上角的“Run”），并在 CAN 总线上发送一个数据包（`cansend can0 123#121212121212`）。

逻辑分析仪提供了一个独立的工具，用于捕获数据包并验证位定时。