# 共振值測量

Klipper內建有ADXL345加速度感測器驅動，可用以測量印表機不同運動軸發生共振的頻率，從而自動進行 [輸入整形](Resonance_Compensation.md) 以實現共振補償。注意使用ADXL345需要進行焊接和壓線。ADXL345可以直接連線到樹莓派，也可以連線到MCU的SPI匯流排（注意MCU有一定的效能需求）。

採購 ADXL345 時，請注意有各種不同的 PCB 板設計和它們的不同克隆。確保電路板支持 SPI 模式（通過將 SDO 拉至 GND 來為 I2C 硬配置少數電路板），如果要連接到 5V 打印機 MCU，它有一個穩壓器和電平轉換器。

## 安裝指南

### 接線

我們需要將ADXL345連線到樹莓派的SPI介面。注意，儘管ADXL345文件推薦使用I2C，但其數據吞吐能力不足，**不能**實現共振測量的要求。推薦的接線圖為：

| ADXL345引腳 | 樹莓派引腳 | 樹莓派引腳名稱 |
| :-: | :-: | :-: |
| 3V3 或 VCC | 01 | 3.3v 直流（DC）電源 |
| GND | 06 | 地（GND） |
| CS（晶片選定） | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

部分ADXL345開發板的Fritzing接線圖如下：

![ADXL345-樹莓派](img/adxl345-fritzing.png)

為避免損害樹莓派或加速度感測器，請再三確認接線正確再對樹莓派上電。

### 固定加速度感測器

加速度感測器應固定在列印頭上。應根據印表機的情況設計合適的固定件。推薦將加速度的測量軸與印表機執行軸的方向進行對齊。然而，如果軸對齊極其麻煩，可以將印表機的軸使用其他測量軸對齊，比如印表機+X對應感測器-X，甚至印表機+X對應感測器-Z等。

下面是ADXL345固定到SmartEffector的示例：

![ADXL345固定在SmartEffector](img/adxl345-mount.jpg)

注意，滑床式印表機需要設計兩個固定件：一個安裝于列印頭，另一個用於熱床，並進行兩次測量。詳見 [對應分節](#bed-slinger-printers)。

**注意**：務必確保加速度感測器和任何螺絲都不應該接觸到印表機的金屬部分。緊韌體必須設計成在加速度感測器和印表機框體間形成電氣絕緣。錯誤的設計可能會形成短路，從而損毀電氣元件。

### 軟體設定

共振測量和自動整形校正需要額外的依賴項，這些依賴在Klipper安裝時未作部署，因此，需要在樹莓派上執行下面的命令：

```
~/klippy-env/bin/pip install -v numpy
```

安裝`numpy`包。numpy需要在安裝時進行編譯。編譯時間據主機的CPU算力而異，需要*耗費大量時間*，最大可至半小時（PiZero），請耐心等待編譯安裝完成。少部分情況下，主機的RAM不足會導致安裝失敗，需要開啟swap功能以實現安裝。

接下來，運行以下命令來安裝其他依賴項：

```
sudo apt update
sudo apt install python3-numpy python3-matplotlib
```

之後，參考[樹莓派作為微控制器文件](RPi_microcontroller.md)的指引完成「LINUX微處理器」的設定。

通過執行`sudo raspi-config` 后的 "Interfacing options"菜單中啟用 SPI 以確保Linux SPI 驅動已啟用。

在printer.cfg附上下面的內容：

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # an example
```

建議在測試開始前，用探針在熱床中央進行一次探測，觸發后稍微上移。

通過`RESTART`命令重啟Klipper。

## 測量共振值

### 檢查設定

首先測試加速度感測器的連線。

- 對於只有一個加速度感測器的情況，在Octoprint，輸入`ACCELEROMETER_QUERY`（遍歷已連線的加速度感測器）
- 對於「滑動床」（即有多個加速度感測器），輸入`ACCELEROMETER_QUERY CHIP=<chip>`，其中`<chip>`是設定文件中的加速度感測器命名，例如 `CHIP=bed`(參見：[bed-slinger](#bed-slinger-printers))。

畫面將輸出加速度感測器的讀值，板子自由落體加速度，例如：

```
Recv: // adxl345 values (x, y, z): 470.719200, 941.438400, 9728.196800
```

如果輸出類似 `Invalid adxl345 id (got xx vs e5)`，其中'xx'為e5以外ID，這表示出現連線問題（如，連線錯誤、線纜電阻過大、干擾等），或感測器錯誤（如，殘次感測器 或 錯誤的感測器）。請在此檢查電源，接線（再三確定接線正確，沒有破損、鬆動的電線）或焊接問題。

下一步，在Octoprint中輸入 `MEASURE_AXES_NOISE`，之後將會顯示各個軸的基準測量噪聲（其值應在1-100之間）。如果軸的噪聲極高（例如 1000 或更高）可能意味著3D印表機上存在感測器問題、電源問題或不平衡的風扇。

### 測量共振值

現在可以執行進行實測。執行以下命令:

```
TEST_RESONANCES AXIS=X
```

注意，這將在X軸上產生振動。如果之前啟用了輸入整形，它也將禁用輸入整形，因為在啟用輸入整形的情況下執行共振測試是無效的。

**注意！**請確保第一次執行時時刻觀察印表機，以確保振動不會太劇烈（`M112`命令可以在緊急情況下中止測試；但願不會到這一步）。如果振動確實太強烈，你可以嘗試在`[Resonance_tester]`分段中為`accel_per_hz`參數指定一個低於預設值的值，例如:

```
[resonance_tester]
accel_chip: adxl345
accel_per_hz: 50  # default is 75
probe_points: ...
```

如果它適用於 X 軸，則也可以為 Y 軸執行：

```
TEST_RESONANCES AXIS=Y
```

這將生成 2 個 CSV 文件（`/tmp/resonances_x_*.csv` 和 `/tmp/resonances_y_*.csv`）。可以使用 Raspberry Pi 上的獨立腳本處理這些文件。為此，請運行以下命令：

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

該腳本將生成帶有頻率響應的圖表`/tmp/shaper_calibrate_x.png`和`/tmp/shaper_calibrate_y.png`。您還將獲得每個輸入整形器的建議頻率，以及為您的設置推薦的輸入整形器。例如：

![Resonances](img/calibrate-y.png)

```
Fitted shaper 'zv' frequency = 34.4 Hz (vibrations = 4.0%, smoothing ~= 0.132)
To avoid too much smoothing with 'zv', suggested max_accel <= 4500 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 0.0%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 41.4 Hz (vibrations = 0.0%, smoothing ~= 0.188)
To avoid too much smoothing with 'ei', suggested max_accel <= 3200 mm/sec^2
Fitted shaper '2hump_ei' frequency = 51.8 Hz (vibrations = 0.0%, smoothing ~= 0.201)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 61.8 Hz (vibrations = 0.0%, smoothing ~= 0.215)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2800 mm/sec^2
Recommended shaper is mzv @ 34.6 Hz
```

建議的配置可以添加到 `printer.cfg` 的 `[input_shaper]` 部分，例如：

```
[input_shaper]
shaper_freq_x: ...
shaper_type_x: ...
shaper_freq_y: 34.6
shaper_type_y: mzv

[printer]
max_accel: 3000  # should not exceed the estimated max_accel for X and Y axes
```

或者您可以根據生成的圖表自行選擇其他配置：圖表上功率譜密度的峰值對應於打印機的共振頻率。

請注意，您也可以從 Klipper [直接](#input-shaper-auto-calibration) 運行輸入整形器自動校準，例如，對於輸入整形器 [re-calibration](#input-shaper-re -校準）。

### Bed-slinger打印機

如果您的打印機是拋床打印機，您將需要在 X 軸和 Y 軸測量值之間更改加速度計的位置：用連接到工具頭的加速度計測量 X 軸的共振和 Y 軸的共振 - 到床（通常的床吊具設置）。

但是，您也可以同時連接兩個加速度計，儘管它們必須連接到不同的板（例如，連接到 RPi 和打印機 MCU 板），或者連接到同一板上的兩個不同的物理 SPI 接口（很少可用）。然後可以通過以下方式配置它們：

```
[adxl345 hotend]
# Assuming `hotend` chip is connected to an RPi
cs_pin: rpi:None

[adxl345 bed]
# Assuming `bed` chip is connected to a printer MCU board
cs_pin: ...  # Printer board SPI chip select (CS) pin

[resonance_tester]
# Assuming the typical setup of the bed slinger printer
accel_chip_x: adxl345 hotend
accel_chip_y: adxl345 bed
probe_points: ...
```

然後命令 `TEST_RESONANCES AXIS=X` 和 `TEST_RESONANCES AXIS=Y` 將為每個軸使用正確的加速度計。

### 最大平滑度

請記住，輸入整形器可以在部分中創建一些平滑。由 `calibrate_shaper.py` 腳本或 `SHAPER_CALIBRATE` 命令執行的輸入整形器的自動調整試圖不加劇平滑，但同時它們試圖最小化產生的振動。有時他們可以對整形器頻率做出次優選擇，或者您可能只是希望以較大的剩余振動為代價來減少零件的平滑度。在這些情況下，您可以請求限制輸入整形器的最大平滑。

讓我們考慮以下自動調整的結果：

![Resonances](img/calibrate-x.png)

```
Fitted shaper 'zv' frequency = 57.8 Hz (vibrations = 20.3%, smoothing ~= 0.053)
To avoid too much smoothing with 'zv', suggested max_accel <= 13000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.8 Hz (vibrations = 3.6%, smoothing ~= 0.168)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3600 mm/sec^2
Fitted shaper 'ei' frequency = 48.8 Hz (vibrations = 4.9%, smoothing ~= 0.135)
To avoid too much smoothing with 'ei', suggested max_accel <= 4400 mm/sec^2
Fitted shaper '2hump_ei' frequency = 45.2 Hz (vibrations = 0.1%, smoothing ~= 0.264)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2200 mm/sec^2
Fitted shaper '3hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.356)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 1500 mm/sec^2
Recommended shaper is 2hump_ei @ 45.2 Hz
```

請注意，報告的“平滑”值是一些抽象的投影值。這些值可用於比較不同的配置：值越高，整形器將創建的平滑度越高。然而，這些平滑分數並不代表任何真正的平滑度量，因為實際的平滑取決於 [`max_accel`](#selecting-max-accel) 和 `square_corner_velocity` 參數。因此，您應該打印一些測試打印，以查看所選配置創建的平滑程度。

在上面的示例中，建議的 shaper 參數還不錯，但是如果您想在 X 軸上獲得更少的平滑度怎麼辦？您可以嘗試使用以下命令限制最大整形器平滑：

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```

這將平滑限制為 0.2 分。現在您可以得到以下結果：

![Resonances](img/calibrate-x-max-smoothing.png)

```
Fitted shaper 'zv' frequency = 55.4 Hz (vibrations = 19.7%, smoothing ~= 0.057)
To avoid too much smoothing with 'zv', suggested max_accel <= 12000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 3.6%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 48.2 Hz (vibrations = 4.8%, smoothing ~= 0.139)
To avoid too much smoothing with 'ei', suggested max_accel <= 4300 mm/sec^2
Fitted shaper '2hump_ei' frequency = 52.0 Hz (vibrations = 2.7%, smoothing ~= 0.200)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 72.6 Hz (vibrations = 1.4%, smoothing ~= 0.155)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 3900 mm/sec^2
Recommended shaper is 3hump_ei @ 72.6 Hz
```

如果與之前建議的參數進行比較，振動會更大一些，但平滑度比之前要小得多，從而允許更大的最大加速度。

在決定選擇哪個 `max_smoothing` 參數時，您可以使用試錯法。嘗試幾個不同的值，看看你會得到什麼結果。請注意，輸入整形器產生的實際平滑主要取決於打印機的最低諧振頻率：最低諧振頻率越高 - 平滑越小。因此，如果您要求腳本找到具有不切實際的小平滑的輸入整形器的配置，則將以增加最低共振頻率處的振鈴為代價（通常在印刷品中也更明顯可見）。因此，請務必仔細檢查腳本報告的預計剩余振動，並確保它們不會太高。

請注意，如果您為兩個軸都選擇了一個好的 `max_smoothing` 值，則可以將其存儲在 `printer.cfg` 中

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # an example
```

然後，如果您將來使用 `SHAPER_CALIBRATE` Klipper 命令 [重新運行](#input-shaper-re-calibration) 輸入整形器自動調整，它將使用存儲的 `max_smoothing` 值作為參考。

### 選擇 max_accel

由於輸入整形器可以在零件中創建一些平滑，尤其是在高加速度時，您仍然需要選擇不會在打印零件中創建太多平滑的“max_accel”值。校準腳本提供了“max_accel”參數的估計值，該參數不應產生過多的平滑。請注意，校準腳本顯示的“max_accel”只是理論上的最大值，在該最大值時，各個整形器仍然能夠工作而不會產生過多的平滑。絕對不建議為打印設置此加速。您的打印機能夠承受的最大加速度取決於其機械性能和所用步進電機的最大扭矩。因此，建議在 `[printer]` 部分設置不超過 X 和 Y 軸的估計值的 `max_accel`，可能有一些保守的安全餘量。

或者，按照輸入整形器調整指南的 [this](Resonance_Compensation.md#selecting-max_accel) 部分並打印測試模型以實驗性地選擇“max_accel”參數。

相同的注意事項適用於使用 `SHAPER_CALIBRATE` 命令的輸入整形器 [auto-calibration](#input-shaper-auto-calibration)：自動校准後仍然需要選擇正確的 `max_accel` 值，建議加速度限制不會自動應用。

如果您正在重新校準整形器，並且建議的整形器配置報告的平滑度與您在之前校準期間得到的幾乎相同，則可以跳過此步驟。

### 測試自定義軸

`TEST_RESONANCES` 命令支持自定義軸。雖然這對於輸入整形器校準並不是很有用，但它可用於深入研究打印機共振並檢查皮帶張力等。

要檢查 CoreXY 打印機上的皮帶張力，請執行

```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```

並使用 `graph_accelerometer.py` 處理生成的文件，例如

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

以產生`/tmp/resonances.png`，對比共振的數據。

對標準構型的三角洲印表機（A塔210°，B塔330°，C塔~90°），執行

```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```

然後使用同樣的命令

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

以產生`/tmp/resonances.png`，對比共振的數據。

## 輸入整形器自動校準

除了為輸入整形器功能手動選擇適當的參數外，還可以直接從 Klipper 運行輸入整形器的自動調整。通過 Octoprint 終端運行以下命令：

```
SHAPER_CALIBRATE
```

這將為兩個軸運行完整測試，並為頻率響應和建議的輸入整形器生成 csv 輸出（默認為`/tmp/calibration_data_*.csv`）。您還將在 Octoprint 控制台上獲得每個輸入整形器的建議頻率，以及為您的設置推薦的輸入整形器。例如：

```
Calculating the best input shaper parameters for y axis # 正在計算y軸的最佳輸入整形參數
Fitted shaper 'zv' frequency = 39.0 Hz (vibrations = 13.2%, smoothing ~= 0.105) # 擬合整形「zv」
To avoid too much smoothing with 'zv', suggested max_accel <= 5900 mm/sec^2 # 為避免使用「zv」方法產生過度平滑，建議最大加速度<=5900 mm/sec^2
Fitted shaper 'mzv' frequency = 36.8 Hz (vibrations = 1.7%, smoothing ~= 0.150) # 擬合整形「mzv」
To avoid too much smoothing with 'mzv', suggested max_accel <= 4000 mm/sec^2 # 為避免使用「mzv」方法產生過度平滑，建議最大加速度<=4000 mm/sec^2
Fitted shaper 'ei' frequency = 36.6 Hz (vibrations = 2.2%, smoothing ~= 0.240) # 擬合整形「ei」
To avoid too much smoothing with 'ei', suggested max_accel <= 2500 mm/sec^2 # 為避免使用「ei」方法產生過度平滑，建議最大加速度<=2500 mm/sec^2
Fitted shaper '2hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.234) # 擬合整形「2hump_ei」
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2500 mm/sec^2 # 為避免使用「2hump_ei」方法產生過度平滑，建議最大加速度<=2500 mm/sec^2
Fitted shaper '3hump_ei' frequency = 59.0 Hz (vibrations = 0.0%, smoothing ~= 0.235) # 擬合整形「3hump_ei」
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2500 mm/sec^2 # 為避免使用「3hump_ei」方法產生過度平滑，建議最大加速度<=2500 mm/sec^2
Recommended shaper_type_y = mzv, shaper_freq_y = 36.8 Hz # 建議shaper_type_y = mzv, shaper_freq_y = 36.8 Hz
```

如果您同意建議的參數，您現在可以執行 `SAVE_CONFIG` 來保存它們並重新啟動 Klipper。請注意，這不會更新 `[printer]` 部分中的 `max_accel` 值。您應該按照 [Selecting max_accel](#selecting-max_accel) 部分中的注意事項手動更新它。

如果您的打印機是拋床打印機，您可以指定要測試的軸，以便您可以在測試之間更改加速度計安裝點（默認情況下，兩個軸都執行測試）：

```
SHAPER_CALIBRATE AXIS=Y
```

您可以在校準每個軸之後執行兩次“SAVE_CONFIG”。

但是，如果您同時連接兩個加速度計，您只需運行“SHAPER_CALIBRATE”，而無需指定一個軸來一次性校準兩個軸的輸入整形器。

### 輸入整形器重新校準

`SHAPER_CALIBRATE` 命令也可用於將來重新校準輸入整形器，尤其是在對打印機進行一些可能影響其運動學的更改時。可以使用“SHAPER_CALIBRATE”命令重新運行完整校準，或者通過提供“AXIS=”參數將自動校準限制在單個軸上，例如

```
SHAPER_CALIBRATE AXIS=X
```

**警告！**不建議非常頻繁地運行成型機自動校準（例如，在每次打印之前或每天）。為了確定共振頻率，自動校準會在每個軸上產生強烈的振動。通常，3D 打印機的設計不能承受長時間暴露於共振頻率附近的振動。這樣做可能會增加打印機組件的磨損並縮短其使用壽命。某些零件擰鬆或鬆動的風險也會增加。每次自動調整後，請務必檢查打印機的所有部件（包括通常不會移動的部件）是否牢固地固定到位。

此外，由於測量中的一些噪聲，調諧結果可能會從一次校準運行到另一次校準運行略有不同。不過，預計噪音不會對打印質量產生太大影響。但是，仍然建議仔細檢查建議的參數，並在使用前打印一些測試打印以確認它們是好的。

## 加速度計數據的離線處理

可以生成原始加速度計數據並離線處理（例如在主機上），例如尋找共振。為此，請通過 Octoprint 終端運行以下命令：

```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```

忽略 `SET_INPUT_SHAPER` 命令的任何錯誤。對於 `TEST_RESONANCES` 命令，指定所需的測試軸。原始數據將被寫入 RPi 上的 `/tmp` 目錄。

原始數據也可以通過在一些正常的打印機活動期間運行命令“ACCELEROMETER_MEASURE”命令兩次來獲得 - 首先開始測量，然後停止測量並寫入輸出文件。詳情請參閱 [G-Codes](G-Codes.md#adxl345)

稍後可以通過以下腳本處理數據：`scripts/graph_accelerometer.py` 和 `scripts/calibrate_shaper.py`。根據模式，它們都接受一個或多個原始 csv 文件作為輸入。 graph_accelerometer.py 腳本支持多種操作模式：

* 繪製原始加速度計數據（使用 `-r` 參數），僅支持 1 個輸入;
* 繪製頻率響應（不需要額外的參數），如果指定了多個輸入，則計算平均頻率響應；
* 比較幾個輸入之間的頻率響應（使用“-c”參數）；您還可以通過“-a x”、“-a y”或“-a z”參數指定要考慮的加速度計軸（如果未指定，則使用所有軸的振動總和）；
* 繪製頻譜圖（使用 `-s` 參數），僅支持 1 個輸入；您還可以通過“-a x”、“-a y”或“-a z”參數指定要考慮的加速度計軸（如果未指定，則使用所有軸的振動總和）。

請注意，graph_accelerometer.py 腳本僅支持 raw_data\*.csv 文件，而不支持 resions\*.csv 或calibration_data\*.csv 文件。

例如:

```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```

將繪製 Z 軸的幾個 `/tmp/raw_data_x_*.csv` 文件與 `/tmp/resonances_x.png` 文件的比較。

shaper_calibrate.py 腳本接受 1 個或多個輸入，並且可以運行輸入整形器的自動調整，並建議適用於所有提供的輸入的最佳參數。它將建議的參數打印到控制台，如果提供了 `-o output.png` 參數，它還可以生成圖表，如果指定了 `-c output.csv` 參數，則可以生成 CSV 文件。

如果運行輸入整形器的一些高級調整，為 shaper_calibrate.py 腳本提供幾個輸入可能很有用，例如：

* 在第一次將加速度計連接到工具頭上，第二次將加速度計按順序連接到床身的情況下，在床吊具打印機上為單個軸運行兩次“TEST_RESONANCES AXIS=X OUTPUT=raw_data”（和“Y”軸）檢測軸交叉共振並嘗試使用輸入整形器消除它們。
* 在帶有玻璃床和磁性表面（更輕）的床吊具上運行兩次“TEST_RESONANCES AXIS=Y OUTPUT=raw_data”，以找到適用於任何打印表面配置的輸入整形器參數。
* 結合來自多個測試點的共振數據。
* 結合來自 2 軸的共振數據（例如，在床拋投打印機上配置 X 軸 input_shaper 從 X 軸和 Y 軸共振以消除*床*的振動，以防噴嘴在 X 軸方向移動時“捕捉”打印）。
