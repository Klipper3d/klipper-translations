# CAN 总线

本文档描述了 Klipper 的 CAN 总线支持。

## 硬件设备

Klipper目前支持STM32、SAME5x和rp2040芯片上的CAN。此外，微控制器芯片必须位于具有CAN收发器的板上。

要针对 CAN 进行编译，请运行 ` make menuconfig`并选择"CAN Bus"作为通信接口。最后，编译微控制器代码并将其刷写到目标控制版上。

## 主机硬件

为了使用CAN总线，必须有一个主机适配器。建议使用“USB转CAN适配器”。不同的制造商提供了许多不同的USB转CAN适配器。在选择其中一个时，我们建议验证是否可以在其上更新固件。(不幸的是，我们发现一些USB适配器运行有缺陷的固件并被锁定，因此请在购买之前进行验证。)。寻找可以直接运行Klipper的适配器(在其“USB to CAN桥模式”下)或运行[Candlellight firmware](https://github.com/candle-usb/candleLight_fw).

还需要将主机操作系统配置为使用适配器。通常可以通过创建一个名为 `/etc/network/interfaces.d/can0` 的新文件来实现，该文件包含以下内容：

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```

## 终端电阻

CAN总线在 CANH 和 CANL 导线之间必须两个 120 欧姆的电阻。理想情况下，总线的两端各有一个电阻。

请注意，有些器件内置了120欧姆的电阻，不易拆卸。有些器件根本不包括电阻器。其他设备具有选择电阻的机制(通常通过连接“引脚跳线”)。务必检查CAN总线上所有器件的原理图，以验证该总线上是否有且只有两个120欧姆电阻。

要测试电阻是否正确，先切断打印机的电源，并用多用表检查 CANH 和 CANL 线之间的阻值—在正确接线的 CAN 总线上，它应该报告大约60 欧姆。

## 寻找新微控制器的 canbus_uuid

CAN 总线上的每个微控制器都根据编码到每个微控制器中的工厂芯片标识符分配了一个唯一的 ID。要查找每个微控制器设备 ID，请确保硬件已正确供电和接线，然后运行：

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

如果检测到未初始化的 CAN 设备，上述命令将报告如下行：

```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

每个设备将有一个独特的标识符。在上面的例子中，`11aa22bb33cc`是微控制器'的"canbus_uuid" 。

注意，`canbus_query.py` 工具只会只报告未初始化的设备—如果Klipper（或类似工具）已经配置了设备，那么它不会在列表中。

## 配置 Klipper

更新Klipper的 [mcu 配置](Config_Reference.md#mcu)，以使用 CAN 总线与设备通信—例如：

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB转CAN总线桥接模式

有些微控制器支持在Klipper的“make menuconfig”中选择“USB to CAN bus bridge” 模式。该模式可使微控制器既可用作“USB转CAN总线适配器”并且同时作为Klipper节点。

当Klipper使用此模式时，微控制器在Linux下显示为“USB CAN Bus Adapter”。“Klipper网桥MCU”本身看起来就像在此CAN总线上一样-它可以通过`canbus_query.py`识别，并且必须像其他CAN Bus Klipper节点一样进行配置。

使用该模式时的一些重要注意事项：

* 有必要在Linux中配置`can0` （或类似）接口，以便与总线通信。然而，Klipper 会忽略 Linux的CAN总线速度和 CAN 总线bit-timing选项。目前，CAN总线的频率需要在 "make menuconfig "中指定。Linux中指定的总线速度会被忽略。
* 每当桥接MCU重置时，Linux都会关闭相应的`can0`接口。为了确保Firmware_Restart和Restart命令的正确处理，建议使用`/etc/network/interfaces.d/can0`文件中的`Allow-hotplug`。例如：

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```

* “桥接MCU”实际上并不在CAN总线上。可能位于CAN总线上的其他适配器不会看到进出桥接器MCU的消息。
* “桥式MCU”本身和CAN总线上的所有设备的可用带宽都受到CAN总线频率的有效限制。因此，在使用“USB转CAN总线桥模式”时，建议使用1000000的CAN总线频率。
* It is only valid to use USB to CAN bridge mode if there is a functioning CAN bus with at least one other node available (in addition to the bridge node itself). Use a standard USB configuration if the goal is to communicate only with the single USB device. Using USB to CAN bridge mode without a fully functioning CAN bus (including terminating resistors and an additional node) may result in sporadic errors even when communicating with the bridge node.
* USB转CAN桥板不会显示为USB串口设备，也不会在运行`ls/dev/Serial/by-id`时出现，也不能在Klipper的printer.cfg文件中使用`Serial：`参数进行配置。桥接板显示为“USB CAN适配器”，并在printer.cfg中配置为[CAN节点](#configuring-klipper)。

## 故障排除提示

参见[CAN Bus故障排除](CanBus_Troublrouoting.md)文档。
