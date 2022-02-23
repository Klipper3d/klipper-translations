# TSL1401CL 耗材寬度感測器

本文件描述了耗材寬度感測器主機模組。用於開發此主機模組的硬體基於 TSL1401CL 線性感測器陣列，但該模組可以與任何具有模擬輸出的感測器陣列一起使用。您可以在 [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor) 找到可用的設計。

要使用基於感測器陣列的耗材寬度感測器，請參閱[配置參考](Config_Reference.md#tsl1401cl_filament_width_sensor)和[G-Code documentation](G-Code.md#hall_filament_width_sensor)。

## 它如何運作？

根據感測器產生模擬輸出計算的耗材寬度。檢測到的耗材寬度和輸出電壓相對應（例如：1.65v、1.70v、3.0v）。主機模組監測電壓變化並調整擠出倍率。

## 注意：

預設以 10 毫米的間隔對感測器進行讀數。如果需要，可以通過編輯 **filament_width_sensor.py** 檔案中的 ***MEASUREMENT_INTERVAL_MM*** 檔案中的參數來改變這一設定。
