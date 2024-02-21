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

在CAN总线连接上递增`BYTES_INVALID`是CAN总线上消息重新排序的症状。消息重新排序有两个已知原因：

1. 用于USB CAN适配器的常用烛光固件的旧版本有一个错误，可能会导致消息重新排序。如果使用运行此固件的USB CAN适配器，则在观察到递增的`Bytes_Invalid`时，请确保更新到最新固件。
1. 已知一些用于嵌入式设备的Linux内核版本会对CAN总线消息进行重新排序。可能需要使用替代的Linux内核，或者使用支持不存在此问题的主流Linux内核的替代硬件。

重新排序的消息是一个必须解决的严重问题。这将导致行为不稳定，并可能导致打印的任何部分出现令人困惑的错误。

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
