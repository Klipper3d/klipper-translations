# 切片軟體

本文件提供了與 Klipper 一起使用的一些切片軟體配置技巧。 Klipper 常用的切片軟體有 Slic3r、Cura、Simplify3D 等。

## 將 G-Code 風格設定為 Marlin

很多切片軟體可以設定「G程式碼風格」選項。Klipper支援通常預設的「Marlin」；Klipper 也相容「Smoothieware」風格。

## Klipper gcode_macro

切片軟體通常可以配置一個"開始G程式碼 "(Start G-Code)和 "結束G程式碼 "(End G-Code)序列。但在 Klipper 配置檔案中定義自定義宏通常更簡便，例如：`[gcode_macro START_PRINT]` 和 `[gcode_macro END_PRINT]` 。然後就可以在切片軟體的配置中使用 START_PRINT 和 END_PRINT 。在 Klipper 的配置中定義這些動作可能會簡化印表機的開始和結束步驟的配置，因為修改不需要重新切片。

參見[sample-macros.cfg](../config/sample-macros.cfg)中的示例 START_PRINT 和END_PRINT 宏。

參見[配置參考](Config_Reference.md#gcode_macro)中關於定義 gcode_macro 的細節。

## 大的回抽值可能意味著需要調優 Klipper

在Klipper中，回抽的最大速度和加速度由 `max_extrude_only_velocity` 和 `max_extrude_only_accel` 參數控制。在大多數印表機上這些參數的預設值應該能很好地工作。然而，如果切片軟體中配置了一個大的回抽值(例如，5毫米或更大)，可能會發現期望的回抽速度受到了限制。

如果你正在使用一個大的回抽值，考慮調優 Klipper 的[提前壓力](Pressure_Advance.md)來代替。否則你可能會發現列印頭在回抽和啟動時暫停，此時可以考慮在 Klipper 配置檔案中設定`max_extrude_only_velocity`和`max_extrude_only_accel`參數來解決這個問題。

## 不要啟用「滑行(coasting)」

和Klipper 一起使用「滑行(coasting)」功能可能會導致列印質量不佳。考慮使用 Klipper 的[提前壓力](Pressure_Advance.md)功能替代。

具體來說，如果切片軟體在移動之間大幅改變擠出率，那麼 Klipper 將在移動之間進行減速和加速。這更可能會造成更多的擠出顆粒(blobbing)，而不是更少。

相反，使用切片軟體的"回抽"、"擦拭 "和/或 "縮回時擦拭 "設定通常是有益的。

## 不要在 Simplify3d 上使用「額外重啟距離(extra restart distance)」

這個設定會導致擠出速度的劇烈變化，從而觸發 Klipper 的最大擠出截面檢查。考慮使用 Klipper 的[提前](Pressure_Advance.md)或 Simplify3d 的常規回抽設定來代替。

## 在 KISSlicer 上禁用「PreloadVE」

如果使用 KISSlicer 切片軟體，那麼需要把 "PreloadVE "設為0並考慮使用Klipper的[提前壓力](Pressure_Advance.md)代替。

## 禁用任何"提前擠出壓力"的設定

一些切片軟體宣傳有 "高級擠出機壓力調整 "的功能。建議在使用 Klipper 時禁用這些功能，因為它們很可能會降低列印質量。考慮使用 Klipper 的[壓力提前](Pressure_Advance.md)代替。

具體來說，這些切片軟體的設定產生的命令會韌體對擠出率進行劇烈的改變，希望韌體能接近這些請求值，使印表機獲得一個大致理想的擠出機壓力。然而，Klipper利用精確的運動學計算和計時。當Klipper被命令對擠出率進行重大改變時，它將計劃出速度、加速度和擠出機運動的相應變化--這不是切片軟體的意圖。切片軟體甚至可能產生過大的擠出速度，以至於觸發Klipper的最大擠出截面檢查。

相反，使用切片軟體的"回抽"、"擦拭 "和/或 "縮回時擦拭 "設定通常是有益的。
