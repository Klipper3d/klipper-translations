# 運動學

該文件提供Klipper實現機械[運動學](https://en.wikipedia.org/wiki/Kinematics)控制的概述，以供 致力於完善Klipper的開發者 或 希望對自己的裝置的機械原理有進一步瞭解的愛好者 參考。

## 加速

Klipper總使用常加速度策略——列印頭的速度總是梯度變化到新的速度，而非使用速度突變的方式。Klipper著眼於列印件和列印頭之間的速度變化。離開擠出機的耗材十分脆弱，突然的移動速度和/或擠出流量突變可能會導致造成列印質量或床黏著能力的下降。甚至在無擠出時，如果列印頭和列印件頂端在同一水平面時，噴嘴的速度突變有可能對剛擠出的耗材進行剮蹭。限制列印頭相對於列印件的速度，可以減少剮蹭列印件的風險。

限制減速度也能減少步進電機丟步和炸機的狀況。Klipper通過限制列印頭的加速度來限制每個步進電機的力矩。限制列印頭的加速度自然也限制了移動列印頭的步進器的扭矩（反之則不一定）。

Klipper實現恒加速度控制，關鍵的方程如下：

```
velocity(time) = start_velocity + accel*time
```

## 梯形發生器

Klipper 使用傳統的"梯形發生器"來產生每個動作的運動--每個動作都有一個起始速度，先恒定的加速度加速到一個巡航速度，再以恒定的速度巡航，最後用恒定的加速度減速到終點速度。

![trapezoid](img/trapezoid.svg.png)

因為移動時的速度圖看起來像一個梯形，它被稱為 "梯形發生器"。

巡航速度總是大於等於起始和終端速度。加速度階段可能持續時間為0（如果起始速度等於巡航速度），巡航速度的持續時間也可為0（如果在加速結束后馬上進行減速），減速階段也能為0（如果終端速度等於巡航速度）。

![trapezoids](img/trapezoids.svg.png)

## 預計算（look-ahead）

拐角速度使用預計算系統進行處理。

考慮以下兩個在 XY 平面上的移動：

![corner](img/corner.svg.png)

在上述的狀況下，印表機可以在第一步時減速至停止，並在第二步開始時加速至巡航速度。但這種運動策略並不理想，完全減速和完全加速會大幅增加列印時間，同時擠出量會頻繁變動，從而導致列印質量的下降。

要解決這種情況，klipper引入了預計算機制，預先依次計算後續的數個移動，分析其中的拐角並確定合適的拐角速度。如果下一步的速度與現時的移動速度相近，則滑車速度僅會稍微減少。

![lookahead](img/lookahead.svg.png)

然而，如果下一步形成一個尖銳的拐角（滑車將在下一步進行近於反方向的移動），則只能採用一個很低的拐角速度。

![lookahead](img/lookahead-slow.svg.png)

結點速度使用“近似向心加速度”確定。最佳 [作者描述](https://onehossshay.wordpress.com/2011/09/24/improving_grbl_cornering_algorithm/)。但是，在 Klipper 中，通過指定 90° 角應具有的所需速度（“方形角速度”）來配置結點速度，並由此得出其他角度的結點速度。

預計算的關鍵方程：

```
end_velocity^2 = start_velocity^2 + 2*accel*move_distance
```

### 預計算結果平滑

Klipper 實現了一種用於平滑短距離之字形移動的機制。參考以下移動：

![zigzag](img/zigzag.svg.png)

在上述情況下，從加速到減速的頻繁變化會導致機器振動，從而對機器造成壓力並增加噪音。為了減少這種情況，Klipper 跟踪常規移動加速度以及虛擬“加速到減速”率。使用這個系統，這些短的“之字形”移動的最高速度被限制為平滑打印機運動：

![smoothed](img/smoothed.svg.png)

具體來說，代碼計算每次移動的速度，如果它被限制在這個虛擬的“加速到減速”率（默認情況下為正常加速率的一半）。在上圖中，灰色虛線表示第一步的虛擬加速度。如果使用此虛擬加速度無法達到其全巡航速度，則其最高速度將降低到在此虛擬加速度下可以達到的最大速度。對於大多數移動，限制將等於或高於移動的現有限制，並且不會引起行為變化。然而，對於短的之字形移動，這個限制會降低最高速度。請注意，它不會改變移動中的實際加速度 - 移動將繼續使用正常加速方案，直至其調整後的最高速度。

## 生成步驟

一旦前瞻過程完成，給定移動的打印頭移動是完全已知的（時間、開始位置、結束位置、每個點的速度），並且可以生成移動的步進時間。此過程在 Klipper 代碼中的“運動學類”中完成。在這些運動學類之外，一切都以毫米、秒和笛卡爾坐標空間為單位進行跟踪。運動學類的任務是將通用坐標系轉換為特定打印機的硬件細節。

Klipper 使用 [iterative solver](https://en.wikipedia.org/wiki/Root-finding_algorithm) 為每個步進器生成步進時間。該代碼包含計算每個時刻頭部理想XYZ坐標的公式，並且它具有根據這些XYZ坐標計算理想步進器位置的動作公式。通過這些公式，Klipper 可以確定步進器應該在每個步進位置的理想時間。然後在這些計算的時間安排給定的步驟。

確定在恆定加速度下移動應該行進多遠的關鍵公式是：

```
move_distance = (start_velocity + .5 * accel * move_time) * move_time
```

勻速動作的關鍵公式是：

```
move_distance = cruise_velocity * move_time
```

在給定移動距離的情況下，確定移動的XYZ坐標的關鍵公式是：

```
cartesian_x_position = start_x + move_distance * total_x_movement / total_movement
cartesian_y_position = start_y + move_distance * total_y_movement / total_movement
cartesian_z_position = start_z + move_distance * total_z_movement / total_movement
```

### XYZ 機型

為XYZ機型打印機生成執行動作是最簡單。每個軸上的動作與各XYZ空間直接相關。

關鍵公式：

```
stepper_x_position = cartesian_x_position
stepper_y_position = cartesian_y_position
stepper_z_position = cartesian_z_position
```

### CoreXY 機型

在 CoreXY 機器上生成動作只比基本的XYZ機型的打印機複雜一點。關鍵公式是：

```
stepper_a_position = cartesian_x_position + cartesian_y_position
stepper_b_position = cartesian_x_position - cartesian_y_position
stepper_z_position = cartesian_z_position
```

### 三角洲機型

三角洲機型的動作生成基於畢達哥拉斯定理：

```
stepper_position = (sqrt(arm_length^2
                         - (cartesian_x_position - tower_x_position)^2
                         - (cartesian_y_position - tower_y_position)^2)
                    + cartesian_z_position)
```

### 步進電機加速度限制

使用三角洲機型時，在XYZ空間中加速的動作可能需要特定步進電機上的加速度大於運動的加速度。當步進臂比垂直更水平並且運動線通過步進器塔附近時，可能會發生這種情況。儘管這些移動可能需要一個大於打印機配置的最大移動加速度的步進電機加速度，但該步進電機移動的有效質量會更小。因此，更高的步進加速度不會導致顯著更高的步進扭矩，因此被認為是無害的。

但是，為避免極端情況，Klipper 將步進加速度的最大上限設置為打印機配置的最大移動加速度的三倍。 （類似地，步進器的最大速度被限制為最大移動速度的三倍。）為了強制執行此限制，在構建包絡的最邊緣（步進器臂可能幾乎水平）的移動將具有較低的最大加速度和速度。

### 擠出機動作

Klipper 在其自己的動作類別中實現了擠出機動作。由於每個打印頭移動的時間和速度對於每次移動都是完全已知的，因此可以獨立於打印頭移動的步進時間計算來計算擠出機的步進時間。

基本的擠出機運動很容易計算。步時間生成使用與笛卡爾機器人相同的公式：

```
stepper_position = requested_e_position
```

### Pressure advance

實驗表明，除了基本的擠出機配方外，還可以改進擠出機的建模。在理想情況下，隨著擠出移動的進行，沿移動的每個點應沉積相同體積的細絲，並且移動後不應有擠出體積。不幸的是，通常會發現基本擠出配方會導致在擠出運動開始時離開擠出機的細絲太少，而在擠出結束後擠出過多的細絲。這通常被稱為"ooze"。

![ooze](img/ooze.svg.png)

"pressure advance"系統試圖通過使用不同型號的擠出機來解決這個問題。與其天真地相信每 mm^3 的長絲送入擠出機都會導致該量的 mm^3 立即離開擠出機，而是使用基於壓力的模型。當長絲被推入擠出機時壓力增加（如[胡克定律]（https://en.wikipedia.org/wiki/Hooke%27s_law）），擠出所需的壓力由通過噴嘴孔的流速決定（如 [Poiseuille 定律](https://en.wikipedia.org/wiki/Poiseuille_law)）。關鍵思想是燈絲、壓力和流量之間的關係可以使用線性係數進行建模：

```
pa_position = nominal_position + pressure_advance_coefficient * nominal_velocity
```

有關如何查找此壓力提前係數的信息，請參閱 [壓力提前](Pressure_Advance.md) 文檔。

基本的壓力提前公式會導致擠出機電機發生突然的速度變化。 Klipper 實現了擠出機運動的“平滑”以避免這種情況。

![pressure-advance](img/pressure-velocity.png)

上圖顯示了兩個擠壓移動的示例，它們之間的轉彎速度為非零。請注意，壓力推進系統會在加速過程中將額外的細絲推入擠出機。所需的燈絲流速越高，在加速過程中必須推入的燈絲越多以解決壓力問題。在機頭減速期間，額外的細絲縮回（擠出機將具有負速度）。

“平滑”是使用擠出機位置在一小段時間內的加權平均值來實現的（由 `pressure_advance_smooth_time` 配置參數指定）。這種平均可以跨越多個 g 代碼移動。請注意擠出機電機將如何在第一次擠出移動的標稱開始之前開始移動，並將在最後一次擠出移動的標稱結束後繼續移動。

"smoothed pressure advance"的關鍵公式：

```
smooth_pa_position(t) =
    ( definitive_integral(pa_position(x) * (smooth_time/2 - abs(t - x)) * dx,
                          from=t-smooth_time/2, to=t+smooth_time/2)
     / (smooth_time/2)^2 )
```
