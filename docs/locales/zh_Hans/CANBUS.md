# CAN 总线

本文档描述了 Klipper 的 CAN 总线支持。

## 硬件设备

Klipper currently supports CAN on stm32, SAME5x, and rp2040 chips. In addition, the micro-controller chip must be on a board that has a CAN transceiver.

要针对 CAN 进行编译，请运行 ` make menuconfig`并选择"CAN Bus"作为通信接口。最后，编译微控制器代码并将其刷写到目标控制版上。

## 主机硬件

In order to use a CAN bus, it is necessary to have a host adapter. It is recommended to use a "USB to CAN adapter". There are many different USB to CAN adapters available from different manufacturers. When choosing one, we recommend verifying that the firmware can be updated on it. (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.) Look for adapters that can run Klipper directly (in its "USB to CAN bridge mode") or that run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

还需要将主机操作系统配置为使用适配器。通常可以通过创建一个名为 `/etc/network/interfaces.d/can0` 的新文件来实现，该文件包含以下内容：

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

## 终端电阻

CAN总线在 CANH 和 CANL 导线之间必须两个 120 欧姆的电阻。理想情况下，总线的两端各有一个电阻。

Note that some devices have a builtin 120 ohm resistor that can not be easily removed. Some devices do not include a resistor at all. Other devices have a mechanism to select the resistor (typically by connecting a "pin jumper"). Be sure to check the schematics of all devices on the CAN bus to verify that there are two and only two 120 Ohm resistors on the bus.

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

Some micro-controllers support selecting "USB to CAN bus bridge" mode during Klipper's "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if it was on this CAN bus - it can be identified via `canbus_query.py` and it must be configured like other CAN bus Klipper nodes.

使用该模式时的一些重要注意事项：

* 有必要在Linux中配置`can0` （或类似）接口，以便与总线通信。然而，Klipper 会忽略 Linux的CAN总线速度和 CAN 总线bit-timing选项。目前，CAN总线的频率需要在 "make menuconfig "中指定。Linux中指定的总线速度会被忽略。
* Whenever the "bridge mcu" is reset, Linux will disable the corresponding `can0` interface. To ensure proper handling of FIRMWARE_RESTART and RESTART commands, it is recommended to use `allow-hotplug` in the `/etc/network/interfaces.d/can0` file. For example:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

* The "bridge mcu" is not actually on the CAN bus. Messages to and from the bridge mcu will not be seen by other adapters that may be on the CAN bus.

   * The available bandwidth to both the "bridge mcu" itself and all devices on the CAN bus is effectively limited by the CAN bus frequency. As a result, it is recommended to use a CAN bus frequency of 1000000 when using "USB to CAN bus bridge mode".Even at a CAN bus frequency of 1000000, there may not be sufficient bandwidth to run a `SHAPER_CALIBRATE` test if both the XY steppers and the accelerometer all communicate via a single "USB to CAN bus" interface.
* A USB to CAN bridge board will not appear as a USB serial device, it will not show up when running `ls /dev/serial/by-id`, and it can not be configured in Klipper's printer.cfg file with a `serial:` parameter. The bridge board appears as a "USB CAN adapter" and it is configured in the printer.cfg as a [CAN node](#configuring-klipper).

## Tips for troubleshooting

See the [CAN bus troubleshooting](CANBUS_Troubleshooting.md) document.
