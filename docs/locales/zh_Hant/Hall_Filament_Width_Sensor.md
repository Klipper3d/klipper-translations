# 霍爾耗材線徑感測器

本檔案介紹了耗材寬度感測器的主機模組。用於開發該主機模組的硬體基於兩個霍爾線性感測器（例如，ss49e）。裝置內的兩個感測器位於兩側。工作原理：兩個霍爾感測器以差分模式工作，由於感測器的溫度漂移相同。不需要特殊的溫度補償。

你可以在[Thingiverse](https://www.thingiverse.com/thing:4138933)上找到設計，在[Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)上也有一個裝配視訊

要使用霍爾耗材線徑感測器，請閱讀[配置參考](Config_Reference.md#hall_filament_width_sensor)和[G-Code 文件](G-Codes.md#hall_filament_width_sensor)。

## 它如何運作？

感測器根據兩個模擬輸出計算出耗材直徑。檢測到的電壓之和始終對應耗材寬度。主機模組監測電壓變化並調整擠出倍率。我在類似ramps的控制板上使用aux2聯結器的 analog11和analog12引腳，你也可以使用不同的引腳和不同的控制板。

## 菜單變數模板

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## 校準程式

要獲得原始感測器值，你可以使用菜單中的選項或在終端發送**QUERY_RAW_FILAMENT_WIDTH**命令。

1. 插入第一根校準棒（1.5毫米直徑），並得到第一個原始感測器值
1. 插入第二根校準棒（2.0毫米直徑），並得到第二個原始感測器值
1. 在配置參數`Raw_dia1`和`Raw_dia2`中寫入原始感測器值

## 如何啟用感測器

感測器在開機時預設被禁用。

要啟用感測器，發送**ENABLE_FILAMENT_WIDTH_SENSOR**命令或將`enable`參數改為`true`。

## 記錄

直徑記錄在開機時預設被禁用。

發送**ENABLE_FILAMENT_WIDTH_LOG**命令開始記錄，發送**DISABLE_FILAMENT_WIDTH_LOG**命令停止記錄。如果想在開機時啟用日誌記錄，請將`logging`配置參數設定為`true`。

每個測量間隔都會記錄耗材直徑（預設為10毫米）。
