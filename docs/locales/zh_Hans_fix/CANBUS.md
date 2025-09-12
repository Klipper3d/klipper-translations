# CAN总线

本文档描述了Klipper的CAN总线支持。

## 设备硬件

目前，Klipper在stm32、SAME5x和rp2040芯片上支持CAN。此外，微控制器芯片必须位于带有CAN收发器的板子上。

要为CAN编译，请运行`make menuconfig`并选择“CAN bus”作为通信接口。最后，编译微控制器代码并将其刷入目标板。

### 章节一
• 选择适合的微控制器硬件
• 编译微控制器代码
• 将代码刷入目标板

## 主机硬件

为了使用CAN总线，需要有一个主机适配器。建议使用“USB到CAN适配器”。有许多不同制造商提供的USB到CAN适配器。在选择时，我们建议验证固件是否可以更新。（不幸的是，我们发现有些USB适配器运行有缺陷的固件且被锁定，因此购买前请确认。）寻找可以直接运行Klipper（在其“USB到CAN桥模式”下）或运行[candlelight固件](https://github.com/candle-usb/candleLight_fw)的适配器。

还需要配置主机操作系统以使用适配器。通常通过创建一个名为`/etc/network/interfaces.d/can0`的新文件来完成，内容如下：
```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```

### 章节二
• 选择合适的USB到CAN适配器
• 配置主机操作系统以使用适配器

## 终端电阻

CAN总线上应在CANH和CANL线之间放置两个120欧姆的电阻。理想情况下，在总线的两端各放置一个电阻。

请注意，某些设备内置了一个无法轻易移除的120欧姆电阻。有些设备根本不包括电阻。其他设备有机制可以选择电阻（通常通过连接“引脚跳线”）。务必检查CAN总线上所有设备的原理图，以确认总线上有两个且仅有两个120欧姆的电阻。

要测试电阻是否正确，可以在断开打印机电源后使用万用表检查CANH和CANL线之间的电阻 - 正确接线的CAN总线应报告约60欧姆。

### 章节三
• 在CANH和CANL线之间安装两个120欧姆电阻
• 使用万用表进行测试

## 查找新微控制器的canbus_uuid

每个CAN总线上的微控制器根据每个微控制器中编码的工厂芯片标识符分配唯一的ID。要查找每个微控制器设备ID，请确保硬件已正确供电和连线，然后运行：
```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

如果检测到未初始化的CAN设备，上述命令将报告如下行：
```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

每个设备都有一个唯一的标识符。在上面的例子中，`11aa22bb33cc`是微控制器的“canbus_uuid”。

注意：`canbus_query.py`工具仅报告未初始化的设备 - 如果Klipper（或类似工具）配置了设备，则它将不再出现在列表中。

### 章节四
• 使用`canbus_query.py`查找新微控制器的canbus_uuid
• 更新Klipper配置以使用canbus_uuid

## 配置Klipper

更新Klipper [mcu配置](Config_Reference.md#mcu)以使用CAN总线与设备通信 - 例如：
```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB到CAN总线桥模式

一些微控制器支持在Klipper的“make menuconfig”期间选择“USB到CAN总线桥”模式。这种模式可能允许将一个微控制器既用作“USB到CAN总线适配器”，又用作Klipper节点。

当Klipper使用此模式时，微控制器在Linux下表现为“USB CAN总线适配器”。 “Klipper桥接mcu”本身会显示为位于该CAN总线上 - 可以通过`canbus_query.py`识别，并且必须像其他CAN总线Klipper节点一样进行配置。

使用此模式时的一些重要注意事项：

* 必须配置Linux中的`can0`（或类似的）接口以便与总线通信。但是，Linux CAN总线速度和CAN总线比特计时选项被Klipper忽略。当前，CAN总线频率是在“make menuconfig”期间指定的，而Linux中指定的总线速度被忽略。

* 每当“桥接mcu”重置时，Linux将禁用相应的`can0`接口。为确保正确处理FIRMWARE_RESTART和RESTART命令，建议在`/etc/network/interfaces.d/can0`文件中使用`allow-hotplug`。例如：
```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```