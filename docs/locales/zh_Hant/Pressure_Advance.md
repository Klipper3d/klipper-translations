# Pressure advance

本文件提供了關於調整特定噴嘴和耗材「pressure advance」配置變數的方法。pressure advance功能可以減少漏料。關於如何實現pressure advance的更多資訊，見[運動學](Kinematics.md)檔案。

## 調整pressure advance

Pressure advance有兩個作用 - 它可以減少非擠出移動過程中的溢料和減少轉彎時的凸起。本指南使用第二個功能（減少轉彎過程中的凸起）作為優化機制。

爲了校準pressure advance，印表機必須已經配置完成並可以正常工作。因為調優測試涉及列印和檢查測試對象。在執行測試之前，最好完整閱讀本文件。

使用切片器為 [docs/prints/square_tower.stl](prints/square_tower.stl) 中的大空心正方形生成 g 代碼。使用高速（例如，100 毫米/秒）、零填充和粗層高度（層高應約為噴嘴直徑的 75%）。確保在切片器中禁用任何“動態加速控制”。

通過發出以下 G-Code命令為測試做準備：

```
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
```

此命令使噴嘴通過角落的速度變慢，以強調擠出機壓力的影響。然後對於帶有直接驅動擠出機的打印機，運行命令：

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

遠程擠出機，請使用：

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020
```

然後打印對象。完全打印後，測試打印看起來像：

![tuning_tower](img/tuning_tower.jpg)

上面的 TUNING_TOWER 命令指示 Klipper 更改打印的每一層的 pressure_advance 設置。打印中的較高層將設置較大的pressure advance值。低於理想 pressure_advance 設置的圖層在拐角處會出現斑點，而高於理想設置的圖層可能會導致圓角和導致拐角處的擠壓不良。

如果觀察到角落不再打印良好，則可以提前取消打印（因此可以避免打印已知高於理想 pressure_advance 值的層）。

檢查打印，然後使用數字卡尺找到具有最佳質量角的高度。如有疑問，請選擇較低的高度。

![tune_pa](img/tune_pa.jpg)

然後可以將 pressure_advance 值計算為`pressure_advance = <start> + <measured_height> * <factor>`。 （例如，`0 + 12.90 * .020` 將是 `.258`。）

如果有助於確定最佳pressure advance設置，則可以為 START 和 FACTOR 選擇自定義設置。執行此操作時，請務必在每次測試打印開始時發出 TUNING_TOWER 命令。

典型的pressure advance值在 0.050 和 1.000 之間（高端通常只有鮑登擠出機）。如果壓力推進高達 1.000 沒有顯著改善，則壓力推進不太可能提高打印質量。在禁用pressure advance的情況下返回默認配置。

雖然這種調整練習直接提高了角落的質量，但值得記住的是，良好的pressure advance配置也可以減少整個打印過程中的滲出。

完成此測試後，在配置文件的 `[extruder]` 部分中設置 `pressure_advance = <calculated_value>` 並發出 RESTART 命令。 RESTART 命令將清除測試狀態並將加速度和轉彎速度恢復到正常值。

## 重要提示

* Pressure advance值取決於擠出機、噴嘴和細絲。來自不同製造商或具有不同顏料的長絲通常需要顯著不同的pressure advance值。因此，應該校準每台打印機上的pressure advance量以及每根燈絲捲軸。
* 印刷溫度和擠出速率會影響pressure advance。請務必在調整pressure advance之前調整 [擠出機旋轉距離](Rotation_Distance.md#calibrating-rotation_distance-on-extruders) 和 [噴嘴溫度](http://reprap.org/wiki/Triffid_Hunter%27s_Calibration_Guide#Nozzle_Temperature)。
* 測試打印設計為以高擠出機流速運行，但否則為“正常”切片機設置。通過使用高打印速度（例如，100mm/s）和粗層高度（通常約為噴嘴直徑的 75%）獲得高流速。其他切片器設置應與其默認設置相似（例如，2 或 3 行的周長，正常的縮回量）。將外部周邊速度設置為與打印的其餘部分相同的速度可能很有用，但這不是必需的。
* 測試打印在每個角落顯示不同的行為是很常見的。通常，切片器會安排在一個角落更改圖層，這可能導致該角落與其餘三個角落明顯不同。如果發生這種情況，則忽略該角並使用其他三個角調整壓力推進。其餘的角也有輕微的變化也是很常見的。 （這可能是由於打印機框架對某些方向的拐角的反應存在微小差異。）嘗試選擇一個適用於所有剩餘拐角的值。如果有疑問，請選擇較低的pressure advance值。
* 如果使用高壓提前值（例如，超過 0.200），則可能會發現擠出機在返回到打印機的正常加速度時會跳動。壓力推進系統通過在加速期間推入額外的燈絲並在減速期間縮回該燈絲來解釋壓力。在高加速度和高壓推進下，擠出機可能沒有足夠的扭矩來推動所需的長絲。如果發生這種情況，請使用較低的加速度值或禁用pressure advance。
* 一旦在 Klipper 中調整了pressure advance，在切片器中配置一個小的縮回值（例如 0.75 毫米）並使用切片器的“縮回時擦除選項”（如果可用）可能仍然有用。這些切片器設置可能有助於抵消由細絲內聚（由於塑料的粘性而從噴嘴中拉出細絲）引起的滲出。建議禁用切片器的“縮回時的 z-lift”選項。
* 壓力推進系統不會改變工具頭的時間或路徑。啟用壓力推進的打印將花費與沒有壓力推進的打印相同的時間。pressure advance也不會改變打印過程中擠出的長絲總量。在移動加速和減速過程中，pressure advance會導致額外的擠出機移動。非常高的pressure advance設置將導致擠出機在加速和減速過程中移動非常大，並且沒有配置設置對移動量進行限制。
