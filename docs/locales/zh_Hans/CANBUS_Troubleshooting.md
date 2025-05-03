# CanBus故障排除

本文档提供了使用[Klipper with CAN Bus](CANBUS.md)时通信问题的故障排除信息。

## 验证CAN总线布线

排除通信故障的第一步是验证CAN总线布线。

Be sure there are exactly two 120 Ohm [terminating
resistors](CANBUS.md#terminating-resistors) on the CAN bus. If the resistors are not properly installed then messages may not be able to be sent at all or the connection may have sporadic instability.

CANH和CANL母线应相互缠绕。至少，电线每隔几厘米就应该有一次绞合。避免将CANH和CALL电线缠绕在电源线周围，并确保平行于CANH和CALL电线的电源线没有相同的扭转量。

确认CAN总线接线上的所有插头和线夹都已完全固定。打印机刀头的移动可能会挤压CAN总线布线，导致不良的线缆卷曲或未固定的插头，从而导致间歇性通信错误。

## 检查递增BYTES_INVALID计数器

当打印机处于活动状态时，Klipper日志文件将每秒报告一次`Stats‘行。对于每个微控制器，这些“Stat”行都将有一个`bytes_valid`计数器。在正常的打印机操作期间，此计数器不应递增(重新启动后计数器为非零值是正常的，如果计数器每月递增一次也无关紧要)。如果在正常打印过程中，CAN Bus微控制器上的此计数器增加(每隔几个小时或更频繁地增加一次)，则表示存在严重问题。

Incrementing `bytes_invalid` on a CAN bus connection is a symptom of reordered messages on the CAN bus. If seen, make sure to:

* Use a Linux kernel version 6.6.0 or later.
* If using a USB-to-CANBUS adapter running candlelight firmware, use v2.0 or later of candleLight_fw.
* If using Klipper's USB-to-CANBUS bridge mode, make sure the bridge node is flashed with Klipper v0.12.0 or later.

Reordered messages is a severe problem that must be fixed. It will result in unstable behavior and can lead to confusing errors at any part of a print. An incrementing `bytes_invalid` is not caused by wiring or similar hardware issues and can only be fixed by identifying and updating the faulty software.

Older versions of the Linux kernel had a bug in the gs_usb canbus driver code that could cause reordered canbus packets. The issue is thought to be fixed in [Linux commit 24bc41b4](https://github.com/torvalds/linux/commit/24bc41b4558347672a3db61009c339b1f5692169) which was released in v6.6.0. In some cases, older Linux versions may not show the problem (due to how hardware interrupts are configured), however if problems are seen the recommended solution is to upgrade to a newer kernel.

Older versions of candlelight firmware could reorder canbus packets, and the issue is thought to be fixed in [candlelight_fw commit 8b3a7b45](https://github.com/candle-usb/candleLight_fw/commit/8b3a7b4565a3c9521b762b154c94c72c5acb2bcf).

Older versions of Klipper's USB-to-CANBUS bridge code could incorrectly drop canbus messages. This is not as severe as reordering messages, but it should still be fixed. It is thought to be fixed with [Klipper PR #6175](https://github.com/Klipper3d/klipper/pull/6175).

## 使用适当的 txqueuelen 设置

Klipper 代码使用 Linux 内核来管理 CAN 总线流量。默认情况下，内核只会排队 10 个 CAN 传输数据包。建议使用 `txqueuelen 128` [配置 can0 设备](CANBUS.md#host-hardware) 来增加该大小。

如果 Klipper 传输了一个数据包，而 Linux 已经填满了其所有的传输队列空间，那么 Linux 将丢弃该数据包，并且 Klipper 日志中将出现如下消息：

```
Got error -1 in can write: (105)No buffer space available
```

作为其正常应用程序级消息重传系统的一部分，Klipper 将自动重传丢失的消息。因此，此日志消息是警告，并不表示不可恢复的错误。

如果发生 CAN 总线完全故障（例如 CAN 线路断线），则 Linux 将无法在 CAN 总线上传输任何消息，并且通常会在 Klipper 日志中找到上述消息。在这种情况下，日志消息是更大问题的征兆（无法传输任何消息），与 Linux `txqueuelen` 没有直接关系。

可以通过运行 Linux 命令“ip link show can0”来检查当前队列大小。它应该会报告一堆文本，包括代码片段“qlen 128”。如果看到类似“qlen 10”的内容，则表明 CAN 设备尚未正确配置。

不建议使用明显大于 128 的 `txqueuelen`。以 1000000 频率运行的 CAN 总线通常需要大约 120us 来传输 CAN 数据包。因此，128 个数据包的队列可能需要大约 15-20ms 才能耗尽。大得多的队列可能会导致消息往返时间出现过度峰值，从而导致无法恢复的错误。换句话说，如果 Klipper 的应用程序重传系统不必等待 Linux 耗尽可能过时的过大队列，它会更加强大。这类似于互联网路由器上的 [bufferbloat](https://en.wikipedia.org/wiki/Bufferbloat) 问题。

在正常情况下，Klipper 可能每个 MCU 使用约 25 个队列槽 - 通常仅在重传期间使用更多槽。（具体而言，Klipper 主机可能向每个 Klipper MCU 传输最多 192 个字节，然后才会收到该 MCU 的确认。）如果单个 CAN 总线上有 5 个或更多 Klipper MCU，则可能需要将`txqueuelen`增加到建议值 128 以上。但是，如上所述，选择新值时应小心谨慎，以避免过长的往返时间延迟。

## Use `canbus_query.py` only to identify nodes never previously seen

It is only valid to use the [`canbus_query.py` tool](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) to identify micro-controllers that have never been previously identified. Once all nodes on a bus are identified, record the resulting uuids in the printer.cfg, and avoid running the tool unnecessarily.

The tool is implemented using a low-level mechanism that can cause nodes to internally observe bus errors. These internal errors may result in communication interruptions and may result is some nodes disconnecting from the bus.

It is not valid to use the tool to "ping" if a node is connected. Do not run the tool during an active print.

## 获取candump日志

向微控制器发送和从微控制器发送的CAN总线消息由Linux内核处理。出于调试目的，可以从内核捕获这些消息。这些消息的日志可能在诊断中有用。

Linux[can-utils](https://github.com/linux-can/can-utils)工具提供了捕获软件。通常通过运行以下命令将其安装在计算机上：

```
sudo apt-get update && sudo apt-get install can-utils
```

安装后，可使用以下命令捕获接口上的所有CAN总线消息：

```
candump -tz -Ddex can0,#FFFFFFFF > mycanlog
```

用户可以查看生成的日志文件(上例中的`mycanlog`)，以查看Klipper发送和接收的每个原始CAN总线消息。要理解这些消息的内容，可能需要对Klipper的[CanBus协议](CanBus_Protocol.md)和Klipper的[MCU命令](mcu_Commands.md)有较低层次的了解。

### 分析candump日志中的Klipper消息

用户可以使用`parsecandump.py`工具来解析烛光日志中包含的低级Klipper微控制器消息。使用此工具是一个高级主题，需要具备Klipper[MCU命令](MCU_Commands.md)的知识。例如：

```
./scripts/parsecandump.py mycanlog 108 ./out/klipper.dict
```

This tool produces output similar to the [parsedump
tool](Debugging.md#translating-gcode-files-to-micro-controller-commands). See the documentation for that tool for information on generating the Klipper micro-controller data dictionary.

In the above example, `108` is the [CAN bus
id](CANBUS_protocol.md#micro-controller-id-assignment). It is a hexadecimal number. The id `108` is assigned by Klipper to the first micro-controller. If the CAN bus has multiple micro-controllers on it, then the second micro-controller would be `10a`, the third would be `10c`, and so on.

要使用`parsecandump.py`工具，必须使用`-tz-Ddex`命令行参数(例如：`andump-tz-DDEX can0，#FFFFFFF`)生成坎通普日志。

## 在CanBus接线上使用逻辑分析仪

[Sigrok Pulseview](https://sigrok.org/wiki/PulseView)软件和低成本的[逻辑分析](https://en.wikipedia.org/wiki/Logic_analyzer)]可用于诊断CAN总线信号。这是一个可能只有专家才感兴趣的高级话题。

人们经常可以找到价格低于15美元的“USB逻辑分析仪”(截至2023年美国定价)。这些设备通常被列为“Saleae逻辑克隆”或“24 MHz 8通道USB逻辑分析仪”。

![pulseview-canbus](img/pulseview-canbus.png)

上图是在使用Pulseview和“Saleae Clone”逻辑分析仪时拍摄的。Sigrok和Pulseview软件安装在台式计算机上(如果单独打包，还应安装“fx2lafw”固件)。逻辑分析仪上的CH0引脚被布线到CAN Rx线路，CH1引脚被布线到CAN Tx引脚，GND被布线到GND。Pulseview配置为仅显示D0和D1线(红色“探头”图标中央顶部工具栏)。采样数设置为500万(顶部工具栏)，采样率设置为24 Mhz(顶部工具栏)。添加了CAN解码器(右上工具栏黄绿相间的“气泡图标”)。D0通道被标记为RX并设置为在下降沿触发(点击左侧的黑色D0标签)。将d1通道标记为Tx(点击左侧棕色的d1标签)。CAN解码器配置为1Mbit速率(点击左侧绿色的CAN标签)。CAN解码器被移到显示屏顶部(单击并拖动绿色的CAN标签)。最后，开始捕获(点击左上角的“Run”(运行))，并在CAN总线上传输一个包(`cansend can0 123#121212121212`)。

逻辑分析器提供了用于捕获数据包和验证位时序的独立工具。
