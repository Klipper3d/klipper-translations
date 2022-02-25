# 偏斜校正

基於軟體的偏斜校正可以幫助解決印表機裝配不完全方形造成的尺寸不準確問題。請注意，如果您的印表機嚴重偏斜，強烈建議在應用基於軟體的校正之前，首先使用機械手段使印表機儘可能的方形。

## 列印一個校準物件

糾正偏斜的第一步是沿著你要糾正的平面列印一個[校準物件](https://www.thingiverse.com/thing:2563185/files)。還有一個[校準物件](https://www.thingiverse.com/thing:2972743)包括了一個模型中的所有平面。你需要旋轉這個物件，使角A朝向平面的原點。

不要在這次列印中應用傾斜校正。你可以通過從printer.cfg中刪除`[skew_correction]`模組或發送 `SET_SKEW CLEAR=1`G-Code 來實現。

## 進行測量

`[skew_correcton]` 模組需要三次對校準平面的測量值；從角 A 到角 C 的距離，從角 B 到角 D 的距離，以及從角 A 到角 D 的距離。當測量距離 AD 時，不包括一些測試物件的角上的平面。

![skew_lengths](img/skew_lengths.png)

## 配置偏斜

確保 `[skew_correction]` 已經在 printer.cfg 中。現在可以使用`SET_SKEW` G-Code 來配置 skew_correcton。例如，如果對 XY 平面測量的距離結果如下：

```
Length AC = 140.4
Length BD = 142.8
Length AD = 99.8
```

`SET_SKEW`可以配置 XY 平面的偏斜校正。

```
SET_SKEW XY=140.4,142.8,99.8
```

你也可以在 G程式碼中加入 XZ 和 YZ 的測量值：

```
SET_SKEW XY=140.4,142.8,99.8 XZ=141.6,141.4,99.8 YZ=142.4,140.5,99.5
```

`[skew_correction]` 模組也支援多配置管理，用法類似`[bed_mesh]`。在使用`SET_SKEW` G-Code 設定偏斜后，你可以使用`SKEW_PROFILE` G-Code來儲存偏斜配置：

```
SKEW_PROFILE SAVE=my_skew_profile
```

在執行這個命令之後，Klipper 會提示你發送 `SAVE_CONFIG` G-Code 來儲存配置。如果沒有名為`my_skew_profile`的配置，那麼一個新的配置將被建立。如果命名的配置檔案存在，它將被覆蓋。

儲存配置后，您可以載入它：

```
SKEW_PROFILE LOAD=my_skew_profile
```

也可以刪除舊的或過時的配置：

```
SKEW_PROFILE REMOVE=my_skew_profile
```

在刪除一個配置檔案后，Klipper 提示你發送 `SAVE_CONFIG` 以保留修改。

## 驗證修正

在配置了 skew_correction 之後，你可以在啟用修正的情況下重新列印校準物件。使用下面的 G-Code 來檢查每個平面的偏斜。其結果應該低於通過`GET_CURRENT_SKEW`報告的結果。

```
CALC_MEASURED_SKEW AC=<ad長度> BD=<bd長度> AD=<ad長度>
```

## 注意事項

由於偏斜校正的性質，建議之在歸位和任何型別的靠近列印區域邊緣的運動（如清除或噴嘴擦除）完成之後的開始列印 G-Code 中配置偏斜校正。您可以使用 `SET_SKEW` 或 `SKEW_PROFILE` G-Code 來完成此操作。還建議在結束列印 G-Code 中發出 `SET_SKEW CLEAR=1`。

請記住，`[skew_correction]`有可能產生一個會使列印頭在 X 和/或 Y 軸上超出印表機邊界的修正。建議在使用`[skew_correction]`時將列印物件遠離印表機邊緣。
