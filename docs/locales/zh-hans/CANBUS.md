# CANBUS

本文档描述了 Klipper 的 CAN 总线支持。

## 设备硬件

Klipper目前只支持 stm32 芯片的CAN。此外，微控制器芯片必须支持 CAN，而且你使用的主板必须有 CAN 收发器。

要为 CAN 编译固件，请运行“make menuconfig”并选择“CAN bus”作为通信接口。最后，编译微控制器代码并将其刷写到目标板上。

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
Found canbus_uuid=11aa22bb33cc
```

每个设备将有一个独特的标识符。在上面的例子中，`11aa22bb33cc`是微控制器'的"canbus_uuid" 。

注意，`canbus_query.py` 工具只会只报告未初始化的设备—如果Klipper（或类似工具）已经配置了设备，那么它不会在列表中。

## 配置 Klipper

更新Klipper的 [mcu 配置](Config_Reference.md#mcu)，以使用 CAN 总线与设备通信—例如：

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```
