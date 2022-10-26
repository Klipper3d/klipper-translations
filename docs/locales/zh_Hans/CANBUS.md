# CAN 总线

本文档描述了 Klipper 的 CAN 总线支持。

## 硬件设备

Klipper currently supports CAN on stm32, same5x, and rp2040 chips. In addition, the micro-controller chip must be on a board that has a CAN transceiver.

要针对 CAN 进行编译，请运行 ` make menuconfig`并选择"CAN Bus"作为通信接口。最后，编译微控制器代码并将其刷写到目标控制版上。

## 主机硬件

为了使用 CAN 总线，主机需要一个适配器。目前有两种常见的选择：

1. 使用[Waveshare Raspberry Pi CAN hat](https://www.waveshare.com/rs485-can-hat.htm)或其众多克隆中的一个。
1. 使用一个USB CAN适配器（例如 <https://hacker-gadgets.com/product/cantact-usb-can-adapter/>）。有许多不同的USB到CAN适配器—当选择时，我们建议验证它是否能运行[candlelight 固件](https://github.com/candle-usb/candleLight_fw)。(不幸的是，我们发现一些USB适配器运行有缺陷的固件，并被锁死，所以在购买前要进行核实。）

还需要将主机操作系统配置为使用适配器。通常可以通过创建一个名为 `/etc/network/interfaces.d/can0` 的新文件来实现，该文件包含以下内容：

```
auto can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```

注意，"Raspberry Pi CAN hat" 需要额外[对 config.txt 进行修改](https://www.waveshare.com/wiki/RS485_CAN_HAT)。

## 终端电阻

CAN总线在 CANH 和 CANL 导线之间必须两个 120 欧姆的电阻。理想情况下，总线的两端各有一个电阻。

请注意，有些设备有一个内置的120欧姆电阻（例如，"Waveshare Raspberry Pi CAN hat"有一个难以拆除的贴片电阻）。有些设备根本不带有一个电阻。其他设备有一个选择电阻的机制（通常是一个跳线）。一定要检查 CAN 总线上所有设备的原理图，以确认总线上有两个而且只有两个120欧姆的电阻。

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

一些微控制器支持在 "make menuconfig "中选择 "USB 转 CAN 总线桥接"模式。这种模式可以把微控制器作为 "USB到CAN总线适配器"的同时作为Klipper节点使用。

当Klipper使用这种模式时，微控制器在 Linux 下会显示为一个 "USB CAN总线适配器"。“Klipper 桥接 mcu "本身将出现在这个CAN总线上--它可以通过`canbus_query.py` ，并像其他CAN总线Klipper节点一样被配置。它将与其他实际在CAN总线上的设备一起出现。

使用该模式时的一些重要注意事项：

* “桥接MCU” 实际上并不在CAN总线上。传入和传出的消息不会占用CAN总线上的带宽。因此位于CAN总线上的其他适配器无法看到MCU。
* 有必要在Linux中配置`can0` （或类似）接口，以便与总线通信。然而，Klipper 会忽略 Linux的CAN总线速度和 CAN 总线bit-timing选项。目前，CAN总线的频率需要在 "make menuconfig "中指定。Linux中指定的总线速度会被忽略。
* 每当 "bridge mcu "被重置时，Linux 将禁用相应的`can0` 接口。为了确保正确处理 FIRMWARE_RESTART 和 RESTART 命令，建议在`/etc/network/interfaces.d/can0` 文件中用`allow-hotplug` 替换`auto` 。例如：

```
allow-hotplug can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```
