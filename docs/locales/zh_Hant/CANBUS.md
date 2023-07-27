# CAN 匯流排

本文件描述了 Klipper 的 CAN 匯流排支援。

## 裝置硬體

Klipper currently supports CAN on stm32, SAME5x, and rp2040 chips. In addition, the micro-controller chip must be on a board that has a CAN transceiver.

要針對 CAN 進行編譯，請執行 ` make menuconfig`並選擇"CAN Bus"作為通訊介面。最後，編譯微控制器程式碼並將其刷寫到目標控制版上。

## 主機硬體

In order to use a CAN bus, it is necessary to have a host adapter. It is recommended to use a "USB to CAN adapter". There are many different USB to CAN adapters available from different manufacturers. When choosing one, we recommend verifying that the firmware can be updated on it. (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.) Look for adapters that can run Klipper directly (in its "USB to CAN bridge mode") or that run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

還需要將主機操作系統配置為使用適配器。通常可以通過建立一個名為 `/etc/network/interfaces.d/can0` 的新檔案來實現，該檔案包含以下內容：

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

## 終端電阻

CAN匯流排在 CANH 和 CANL 導線之間必須兩個 120 歐姆的電阻。理想情況下，匯流排的兩端各有一個電阻。

Note that some devices have a builtin 120 ohm resistor that can not be easily removed. Some devices do not include a resistor at all. Other devices have a mechanism to select the resistor (typically by connecting a "pin jumper"). Be sure to check the schematics of all devices on the CAN bus to verify that there are two and only two 120 Ohm resistors on the bus.

要測試電阻是否正確，先切斷印表機的電源，並用多用表檢查 CANH 和 CANL 線之間的阻值—在正確接線的 CAN 匯流排上，它應該報告大約60 歐姆。

## 尋找新微控制器的 canbus_uuid

CAN 匯流排上的每個微控制器都根據編碼到每個微控制器中的工廠晶片識別符號分配了一個唯一的 ID。要查詢每個微控制器裝置 ID，請確保硬體已正確供電和接線，然後執行：

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

如果檢測到未初始化的 CAN 裝置，上述命令將報告如下行：

```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

每個裝置將有一個獨特的識別符號。在上面的例子中，`11aa22bb33cc`是微控制器'的"canbus_uuid" 。

注意，`canbus_query.py` 工具只會只報告未初始化的裝置—如果Klipper（或類似工具）已經配置了裝置，那麼它不會在列表中。

## 配置 Klipper

更新Klipper的 [mcu 配置](Config_Reference.md#mcu)，以使用 CAN 匯流排與裝置通訊—例如：

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB轉CAN bus橋接模式

Some micro-controllers support selecting "USB to CAN bus bridge" mode during Klipper's "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if it was on this CAN bus - it can be identified via `canbus_query.py` and it must be configured like other CAN bus Klipper nodes.

使用此模式時的一些重要注意事項：

* 為了與總線通信，必須在 Linux 中配置 `can0`（或類似的）接口。但是，Klipper 忽略了 Linux CAN 總線速度和 CAN 總線位定時選項。目前，CAN 總線頻率在“make menuconfig”期間指定，Linux 中指定的總線速度被忽略。
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
