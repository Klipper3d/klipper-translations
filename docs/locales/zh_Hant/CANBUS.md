# CAN 匯流排

本文件描述了 Klipper 的 CAN 匯流排支援。

## 裝置硬體

Klipper目前只支援 stm32 晶片的CAN。此外，微控制器晶片必須支援 CAN，而且你使用的主板必須有 CAN 收發器。

要針對 CAN 進行編譯，請執行 ` make menuconfig`並選擇"CAN Bus"作為通訊介面。最後，編譯微控制器程式碼並將其刷寫到目標控制版上。

## 主機硬體

爲了使用 CAN 匯流排，主機需要一個適配器。目前有兩種常見的選擇：

1. 使用[Waveshare Raspberry Pi CAN hat](https://www.waveshare.com/rs485-can-hat.htm)或其眾多克隆中的一個。
1. 使用一個USB CAN適配器（例如 <https://hacker-gadgets.com/product/cantact-usb-can-adapter/>）。有許多不同的USB到CAN適配器—當選擇時，我們建議驗證它是否能執行[candlelight 韌體](https://github.com/candle-usb/candleLight_fw)。(不幸的是，我們發現一些USB適配器執行有缺陷的韌體，並被鎖死，所以在購買前要進行覈實。）

還需要將主機操作系統配置為使用適配器。通常可以通過建立一個名為 `/etc/network/interfaces.d/can0` 的新檔案來實現，該檔案包含以下內容：

```
auto can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```

注意，"Raspberry Pi CAN hat" 需要額外[對 config.txt 進行修改](https://www.waveshare.com/wiki/RS485_CAN_HAT)。

## 終端電阻

CAN匯流排在 CANH 和 CANL 導線之間必須兩個 120 歐姆的電阻。理想情況下，匯流排的兩端各有一個電阻。

請注意，有些裝置有一個內建的120歐姆電阻（例如，"Waveshare Raspberry Pi CAN hat"有一個難以拆除的貼片電阻）。有些裝置根本不帶有一個電阻。其他裝置有一個選擇電阻的機制（通常是一個跳線）。一定要檢查 CAN 匯流排上所有裝置的原理圖，以確認匯流排上有兩個而且只有兩個120歐姆的電阻。

要測試電阻是否正確，先切斷印表機的電源，並用多用表檢查 CANH 和 CANL 線之間的阻值—在正確接線的 CAN 匯流排上，它應該報告大約60 歐姆。

## 尋找新微控制器的 canbus_uuid

CAN 匯流排上的每個微控制器都根據編碼到每個微控制器中的工廠晶片識別符號分配了一個唯一的 ID。要查詢每個微控制器裝置 ID，請確保硬體已正確供電和接線，然後執行：

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

如果檢測到未初始化的 CAN 裝置，上述命令將報告如下行：

```
Found canbus_uuid=11aa22bb33cc
```

每個裝置將有一個獨特的識別符號。在上面的例子中，`11aa22bb33cc`是微控制器'的"canbus_uuid" 。

注意，`canbus_query.py` 工具只會只報告未初始化的裝置—如果Klipper（或類似工具）已經配置了裝置，那麼它不會在列表中。

## 配置 Klipper

更新Klipper的 [mcu 配置](Config_Reference.md#mcu)，以使用 CAN 匯流排與裝置通訊—例如：

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```
