# 旋轉距離

Klipper 上的步進電機驅動器在每個 [步進配置部分](Config_Reference.md#stepper) 中都需要一個 `rotation_distance` 參數。 `rotation_distance` 是步進電機旋轉一整圈時軸移動的距離。本文件描述瞭如何配置此值。

## 從step_per_mm（或step_distance）獲取旋轉距離

你的 3D 印表機的設計師最初從旋轉距離計算 `steps_per_mm `。如果您知道steps_per_mm，則可以使用此通用公式獲得原始旋轉距離：

```
rotation_distance = <full_steps_per_rotation> * <microsteps> / <steps_per_mm>
```

或者，如果你有一個舊版本的Klipper配置並知道`step_distance`參數，你可以使用這個公式：

```
rotation_distance = <full_steps_per_rotation> * <microsteps> * <step_distance>
```

`<full_steps_per_rotation>` 設定由步進電機的型別決定。大多數步進電機是「1.8 度步進電機」，因此每轉 200 步（360 除以 1.8 等於 200）。一些步進電機是「0.9 度步進電機」，因此每轉有 400 整步。其他步進電機很少見。如果不確定，請不要在配置檔案中設定 full_steps_per_rotation 並在上面的公式中使用 200。

`<microsteps>`設定由取決於步進電機驅動型號。大多數驅動使用 16 個微步。如果不確定，請在配置中設定 `microsteps: 16`，並在上面的公式中使用 16。

幾乎所有印表機都應該在 X、Y 和 Z 型軸上具有「rotation_distance」整數。如果上述公式導致rotation_distance在整數的 .01 範圍內，則將最終值捨入為該whole_number。

## 校準擠出機的 rotation_distance

在擠出機上，`rotation_distance`是指步進電機旋轉一圈後，耗材所走的距離。獲得這一設定準確值的最好方法是使用"測量並修正"的方法。

從一個初始的旋轉距離猜測值開始。可以通過[steps_per_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance)或者通過[檢查硬體](#extruder)來。

然後根據以下程式執行"測量和修正"：

1. 首先確保擠出機里有耗材，熱端被加熱到適當的溫度，並且印表機準備好擠出。
1. 用記號筆在離擠出機入口約70毫米的位置上對耗材做一個標記。然後用數字卡尺儘可能精確地測量該標記的實際距離。將此記為`<initial_mark_distance> `。
1. 用以下命令序列擠出50mm長絲：「G91」，後跟「G1 E50 F60」。。注50mm為<requested_extrude_distance>』。等待擠出機完成移動（大約需要50秒）。在此測試中使用緩慢的擠出速率非常重要，因為較快的速率會導致擠出機中的高壓，從而扭曲結果。（請勿在圖形前端使用"拉伸按鈕"進行此測試，因為它們以快速的速度拉伸。
1. 使用數顯示卡尺測量擠出機主體與耗材上的標記之間的新距離。請注意該距離是 `<subsequent_mark_distance>`。然後計算：`actual_extrude_distance = <initial_mark_distance> - <subsequent_mark_distance>`
1. 計算running_distance為：`rotation_distance = <previous_rotation_distance> * <actual_extrude_distance> / <request_extrude_distance>`。將新的 rotation_distance 取整到小數點後3位。

如果實際擠出的距離與請求擠出的距離相差超過2毫米，那麼最好再執行一次上述步驟。

注意：*不要*使用"測量並修正"類的方法來校準x、y或z型別的軸。對於這些軸來說，"測量和修剪"方法不夠精確，而且可能會導致更糟糕的配置。相反，如果需要，這些軸可以通過[j檢查皮帶、滑輪和絲桿](#obtaining-rotation_distance-by-inspecting-the-hardware)來確定。

## 通過檢查硬體獲得旋轉距離

有了步進電機和印表機運動學方面的資訊，就可以計算旋轉距離。如果不知道每毫米的步數，或者正在設計一臺新的印表機，這可能有幫助。

### 皮帶驅動的軸

計算使用皮帶和滑輪的直線軸的旋轉距離很簡單。

首先確定皮帶的型別。大多數印表機使用2毫米的皮帶間距（也就是說，皮帶上的每個齒相距2毫米）。然後計算步進電機滑輪上的齒數。然後計算出rotation_distance （旋轉距離）為：

```
rotation_distance = <belt_pitch> * <number_of_teeth_on_pulley>
```

例如，如果一臺印表機有一條2毫米間距的皮帶並使用一個20齒的皮帶輪，那麼旋轉距離為40。

### 使用絲桿的軸

使用以下公式可以簡單的計算出常見的旋轉距離：

```
rotation_distance = <screw_pitch> * <number_of_separate_threads>
```

例如，常見的"T8絲桿"的旋轉距離為8（它的間距為2mm，有4個獨立的螺紋）。

老式印表機的"螺紋桿"在導螺桿上只有一個"螺紋"，因此旋轉距離是螺桿的間距。(例如，M6公制桿的旋轉距離為1，M8桿的旋轉距離為1.25。

### 擠出機

通過測量推動印絲的「滾齒螺栓」的直徑並使用以下公式，可以獲得擠出機的初始旋轉距離：「rotation_distance = <diameter> * 3.14」

如果擠出機使用齒輪，則還需要[確定和設定擠出機的齒輪比](#using-a-gear_ratio)。

擠出機上的實際旋轉距離因印表機而異，因為咬合印絲的「滾齒螺栓」的抓地力可能會有所不同。它甚至可以在印絲線軸之間變化。獲得初始rotation_distance後，使用[測量和修剪程式](#calibrating-rotation_distance-on-extruders) 以獲得更準確的設置。

## 使用 gear_ratio（齒輪比）

設定`gear_ratio`可以簡化`rotation_distance`在有齒輪箱（或類似）連線的步進電機的配置。大多數步進電機沒有齒輪箱--如果不確定，就不要在配置中設定`gear_ratio`。

當`gear_ratio`被設定時，`rotation_distance`代表軸在齒輪箱上的最後一個齒輪旋轉一圈時的移動距離。例如，如果一個人正在使用一個具有"5:1"比率的齒輪箱，那麼他可以用[對硬體的瞭解](#obtaining-rotation_distance-by-inspecting-the-hardware)來計算旋轉距離，然後將`gear_ratio: 5:1`加入配置中。

對於使用皮帶和皮帶輪實現的傳動裝置，可以通過計算皮帶輪上的齒來確定gear_ratio。例如，如果帶有16齒滑輪的步進器驅動下一個具有80齒的滑輪，那麼將使用"gear_ratio：80：16"。事實上，人們可以打開一個普通的現成「齒輪箱」，並計算其中的齒數以確認其齒輪比。

請注意，有時變速箱的齒輪比與宣傳的齒輪比略有不同。常見的BMG擠出機電機齒輪就是一個例子 - 它們被宣傳為"3：1"，但實際上使用"50：17"傳動裝置。（使用沒有公分母的齒數可以改善整體齒輪磨損，因為齒在每次旋轉時並不總是以相同的方式啮合。常見的"5.18：1行星齒輪箱"，更準確地配置了"gear_ratio：57：11"。

如果一個軸上使用了多個齒輪，那麼在 gear_ratio 中填寫一個逗號分隔的列表。例如，一個"5:1"齒輪箱驅動一個16齒的皮帶輪到80齒的皮帶輪，可以使用`gear_ratio: 5:1, 80:16`。

在大多數情況下，gear_ratio 應該用整數來定義，因為普通的齒輪和皮帶輪上只有整數的齒。然而，在皮帶利用摩擦力而不是齒來驅動皮帶輪的情況下，在齒輪比中使用一個浮點數可能是有意義的（例如，`gear_ratio: 107.237:16`）。
