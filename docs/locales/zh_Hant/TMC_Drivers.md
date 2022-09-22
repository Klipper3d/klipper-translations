# TMC 驅動器

這個文件提供了在Klipper上以SPI/UART模式使用Trinamic步進電機驅動器的資訊。

Klipper也可以在其 "standalone mode"下使用Trinamic驅動。然而，當驅動處於這種模式時，不需要特殊的Klipper配置，本檔案中討論的高級Klipper功能也無法使用。

除了這份文件，請務必檢視[TMC驅動配置參考](Config_Reference.md#tmc-stepper-driver-configuration).

## 調整電機電流

較高的驅動電流可以提高定位精度和扭矩。然而，較高的電流也會增加步進電機和步進電機驅動器產生的熱量。如果步進電機驅動器太熱，它就會自行失效，Klipper會報告錯誤。如果步進電機太熱，它將失去扭矩和位置精度。(如果它變得非常熱，還可能融化連線在它身上或附近的塑料部件。）

作為一般的調整建議，只要步進電機不會太熱，並且步進電機驅動器不會報告警告或錯誤，就可以選擇更高的電流值。一般來說，步進電機感到溫熱是可以接受的，但不應該熱到觸控起來很燙手。

## 傾向於不指定保持電流（hold_current）

如果配置了 `hold_current` ，那麼TMC驅動器可以在檢測到步進電機沒有移動時會減少步進電機的電流。然而，改變電機電流本身可能會引起電機轉動。這可能是由於步進電機內部的 "阻滯力"（轉子中的永久磁鐵拉向定子中的鐵齒）或軸滑車上的外力造成的。

對於大多數步進電機，在正常的列印過程中減少電流不會帶來顯著的好處，因為很少有列印動作會讓步進電機空閑足夠長的時間來啟用 `hold_current`（保持電流）功能。而且，你也不會希望在少數使步進電機空閑足夠長的時間的列印動作中引入小的列印瑕疵。

如果希望在列印預熱時減少電機的電流，那麼可以考慮在[START_PRINT宏](Slicers.md#klipper-gcode_macro)中寫入[SET_TMC_CURRENT](G-Code.md#set_tmc_current)命令，在正常列印開始前後調整電流。

一些印表機的專用Z軸電機在正常的列印動作中是空閑的（沒有床網（bed_mesh），沒有床面傾斜（bed_tilt），沒有Z軸傾斜校正（skew_correction），沒有 "花瓶模式 （vase mode）"列印，等等），可能會發現Z軸電機在 `hold_current`的情況下確實執行得比較冷。如果實現了這一點，那麼一定要考慮到在床面調平、床面探測、探針校準等過程中這種非指令性的Z軸運動。 `driver_TPOWERDOWN`和 `driver_IHOLDDELAY`也應該進行相應的校準。如果不確定，最好不要指定 `hold_current`。

## 設定 "spreadCycle "與 "stealthChop "模式

預設情況下，Klipper將TMC驅動置於 "spreadCycle "模式。如果驅動程式支援 "stealthChop"，那麼可以通過新增`stealthchop_threshold: 999999`到TMC的配置部分。

一般來說，spreadCycle模式比stealthChop模式提供更大的扭矩和更高的定位精度。然而，在某些印表機上，stealthChop 模式顯著降低可聽到的噪音。

比較模式的測試表明，在使用stealthChop模式時，在恒速移動過程中，"位置滯後 "增加了約為整步的75%（例如，在一臺旋轉距離（rotation_distance ）為40mm、每圈200步（steps_per_rotation）的印表機上，恒速移動的位置偏差增加了約0.150mm）。然而，這種 "獲得所需位置的延遲 "可能不會表現爲明顯的列印缺陷，人們可能更喜歡stealthChop模式帶來的更安靜的列印。

建議總是使用 "spreadCycle "模式（通過不指定`stealthchop_threshold`）或總是使用 "stealthChop "模式（通過設定`stealthchop_threshold`為99999）。不幸的是，如果在電機處於非零速度時改變模式，驅動器往往會產生糟糕和混亂的結果。

## TMC插值設定引入了微小的位置偏差

TMC驅動程式的 `interpolate` 設定可以減少印表機運動的噪音，但代價是引入一個小的系統位置誤差。這個系統性的位置誤差是由驅動器在執行Klipper發送的 "步驟 "時的延遲造成的。在恒速移動過程中，這種延遲導致了將近一半的配置微步的位置誤差（更準確地說，誤差是一半的微步距離減去512分之一的整步距離）。例如，在一個旋轉距離（rotation_distance）為40毫米、每圈200步（steps_per_rotation）、16微步的軸上，在恒速移動過程中引入的系統誤差是~0.006毫米。

爲了獲得最佳的定位精度，可以考慮使用spreadCycle模式，並禁用插值（在TMC驅動配置中設定`interpolate: False` ）。當以這種方式配置時，可以增加`microstep`設定，以減少步進運動中的噪音。通常情況下，微步設定為`64`或`128`會有類似於插值的噪音水平，而且不會引入系統性的位置誤差。

如果使用stealthChop模式，那麼相對於從stealthChop模式引入的位置不精確性，插值的位置不精確性很小。因此，在stealthChop 模式下，調整插值是沒有用的，可以將插值設定再其預設狀態。

## 無限位歸零

無感測器歸位允許在不需要物理限位開關的情況下將一個軸歸位。相反，軸上的滑車接觸機械限位后，使步進電機失去步長。步進驅動器感應到失去的步數，並通過切換一個引腳向控制的微控制器（Klipper）告知這一點。該資訊可被 Klipper 用作軸的限位。

本指南介紹瞭如何設定（笛卡爾）印表機的X軸無感測器歸位。這個方法也適合其他軸（需要一個限位）。每次應該只對一個軸進行配置和調整。

### 限制

要確保你的機械部件能夠承受滑車反覆撞向軸的限位的負載。特別是絲槓可能會產生很大的力。通過將噴嘴撞向列印表面來確定Z軸的位置可能不是一個好主意。爲了獲得最佳效果，請確認軸滑車將與軸的限位緊密接觸。

此外，無感測器歸位對你的印表機來說可能不夠精確。雖然笛卡爾機器上的X和Y軸歸位可以很好地工作，但Z軸的歸位通常不夠準確，可能會導致第一層高度不一致。由於精度低，不建議在delta 印表機上使用無感測器的歸位。

此外，步進驅動器的失速檢測取決於電機的機械負載、電機電流和電機溫度（線圈電阻）。

無感測器歸位在電機中速時效果最好。對於非常慢的速度（小於10RPM），電機不會產生明顯的反電磁場，TMC晶片不能可靠地檢測到電機停頓。此外，在非常高的速度下，電機的反向電動勢接近電機的電源電壓，所以TMC晶片也檢測不到停頓。建議你看看一下對應的TMC晶片數據手冊。在手冊中還可以找到更多關於這種設定的限制的細節。

### 前提條件

使用無感測器歸位，需要一些前提條件：

1. 一個具有stallGuard功能的TMC步進驅動器（TMC2130、TMC2209、TMC2660或TMC5160）。
1. 需要TMC驅動器的SPI / UART介面與微控制器連線（stand-alone 模式不行）。
1. 需要把TMC驅動器的 "DIAG "或 "SG_TST "引腳連線到微控制器。
1. 必須按照[配置檢查](Config_checks.md)檔案中的步驟來確認步進電機的配置和運轉正常。

### 調整

調整過程有六個主要步驟：

1. 選擇一個歸位速度。
1. 配置`printer.cfg`檔案以啟用無感測器歸位。
1. 找到有最高靈敏度的stallguard設定，確保其成功找到零點位置。
1. 找到有最低靈敏度的stallguard 設定，確保只需輕輕一碰就能成功歸零。
1. 更新`printer.cfg`，加入所需的stallguard設定。
1. 建立或更新 `printer.cfg `宏確保穩定歸位（home）。

#### 選擇歸位速度

執行無感測器歸位時，歸位速度是一個重要參數。最好使用較慢的歸位速度，以便滑車在與軌道限位接觸時不會對框架施加過多的力。然而，TMC驅動器在非常慢的速度下並不能可靠地檢測到失速。

歸位速度的最佳調整起點是步進電機每兩秒轉一圈。對於許多軸，這就是將是 `rotation_distance` 除以2。例如：

```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### 為無感測器歸位配置printer.cfg

在`stepper_x` 配置部分， `homing_retract_dist` 設定必須被設為零，以禁用第二次歸位動作。在使用無感測器歸位時，第二次歸位嘗試不會提高精度，也不會可靠地工作，而且會擾亂調整過程。

確保在配置的TMC驅動部分沒有指定 `hold_current`的設定。（如果設定了hold_current，那麼在接觸后，當滑車撞到軌道末端時，電機就會停止，在這個位置上減少電流可能會導致滑車移動--這將導致歸位效能不佳，並會擾亂調整過程。）

需要配置無感測器歸位引腳，並配置初始 "stallguard "設定。一個用於X軸的tmc2209示例配置如下：

```
[tmc2209 stepper_x]
diag_pin: ^PA1      # 設定MCU引腳連線到TMC的DIAG引腳
driver_SGTHRS: 255  # 255是最敏感的值，0是最不敏感的值
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

用於tmc2130或tmc5160配置的例子如下：

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 #  連線到TMC的DIAG1引腳(或使用diag0_pin / DIAG0引腳)
driver_SGT: -64  # -64是最敏感的值，63是最不敏感的值
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

用於tmc2660配置的例子如下：

```
[tmc2660 stepper_x]
driver_SGT: -64     # -64是最敏感的值，63是最不敏感的值
...

[stepper_x]
endstop_pin: ^PA1   # 與TMC SG_TST引腳相連的引腳
homing_retract_dist: 0
...
```

上面的例子只顯示了針對無感測器歸位的設定。所有可用選項請參見[配置參考](Config_Reference.md#tmc-stepper-driver-configuration)。

#### 找到能成功歸位的最高的敏感度設定

將滑車放在靠近軌道中心的位置。使用SET_TMC_FIELD命令來設定最高靈敏度。對於tmc2209：

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

對於tmc2130, tmc5160, and tmc2660:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

Then issue a `G28 X0` command and verify the axis does not move at all or quickly stops moving. If the axis does not stop, then issue an `M112` to halt the printer - something is not correct with the diag/sg_tst pin wiring or configuration and it must be corrected before continuing.

接下來，不斷降低 `VALUE` 設定的靈敏度，並再次執行 `SET_TMC_FIELD`和`G28 X0` 命令，找到能使使滑車成功地一直移動到端點並停止的最高的靈敏度。(對於TMC2209驅動，調整是減少 SGTHRS，對於其他驅動，調整是增加 sgt)。確保每次嘗試都在軌道中心附近開始（如果需要，發出`M84`，然後手動將滑車移到中心）。該方法應該可以找到可靠歸位的最高靈敏度（更高的靈敏度設定會導致滑車只動一小段或完全不動）。注意找到的值為*maximum_sensitivity*。(如果在最低靈敏度（SGTHRS=0或sgt=63）下滑車也不動，那麼diag/sg_tst 引腳的接線或配置可能有問題，必須在繼續後面操作前予以修正。）

在尋找最大靈敏度時，更方便的是跳到不同的VALUE設定（比如將VALUE參數的一半）。如果這樣做，請準備好發出 `M112`命令以停止印表機，因為靈敏度很低的設定可能會導致軸反覆 "撞 "到導軌的末端。

請確保在每次歸位嘗試之間等待幾秒鐘。在TMC驅動程式檢測到失速后，它可能需要一點時間來清除其內部指示器，才能夠檢測到下一次失速。

在調整測試中，如果`G28 X0`命令不能完全移動到軸的極限位置，那麼在發出任何常規移動命令（例如，`G1`）時要小心。Klipper將不能正確定位滑塊的位置，移動命令可能會導致非預期和混亂的結果。

#### 找到最低的靈敏度，只需一次接觸就能歸位

當用找到的*最大靈敏度*值歸位時，軸應該移動到軌道的末端並 "single touch（一觸即停）"--也就是說，不應該有 "咔嚓 "或 "砰 "的聲音。(如果在最大靈敏度下有撞擊或點選聲，那麼歸位速度可能太低，驅動電流可能太低，或者該軸可能不適合用無感測器歸位。）

下一步是再次持續移動滑塊到靠近軌道中心的位置，降低靈敏度，並執行`SET_TMC_FIELD`和`G28 X0`命令 - 這次的目標是找到最低的靈敏度，仍能使滑塊成功地 "一觸即停"歸位。也就是說，當接觸到軌道的末端時，它不會發出"砰 "或 "咔"的聲音。注意找到的值是*minimum_sensitivity*。

#### 更新printer.cfg中的靈敏度值

在找到*maximum_sensitivity*和*minimum_sensitivity*后，計算得到推薦的靈敏度為 *minimum_sensitivity +(maximum_sensitivity-minimum_sensitivity)/3*。推薦的靈敏度應該在最小值和最大值之間，但略微接近最小值。將最終值四捨五入到最近的整數值。

對於TMC2209，在配置中設定`driver_SGTHRS`，對於其他TMC驅動，在配置中設定`driver_SGT`。

如果*maximum_sensitivity*和*minimum_sensitivity*之間的範圍很小（例如，小於5），那麼可能導致不穩定的歸位。更快的歸位速度可以擴大範圍，使操作更加穩定。

請注意，如果對驅動電流、歸位速度做了任何改變，或者對印表機硬體做了明顯的改變，那麼就需要再次執行這個調整過程。

#### 歸位時使用宏

在無感測器歸位完成後，滑車將頂到導軌的末端，步進器將持續對框架施加力，直到滑車移開。最好建立一個宏來使軸歸位，並立即將小車從軌道的末端移開。

在開始無感測器歸位之前，宏最好暫停至少2秒（或確保步進在2秒內沒有移動）。如果沒有延遲，驅動器的內部失速標誌有可能在之前的移動中被設定了。

使用宏在歸位前設定驅動電流，並在滑車移開後設置新的電流，也會很有用。

一個宏的例子如下：

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # 為無感測器歸位設定電流
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # 暫停，以確保驅動器失速標誌被清除
    G4 P2000
    # 歸位
    G28 X0
    # 移開
    G90
    G1 X5 F1200
    # 列印過程中設定電流
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

產生的宏可以從[homing_override配置部分](Config_Reference.md#homing_override)或[START_PRINT宏](Slicers.md#klipper-gcode_macro)中呼叫。

請注意，如果歸位期間的驅動電流發生變化，則應重新執行調整過程。

### 在CoreXY上進行無感測器歸位的技巧

可以在CoreXY印表機的X和Y行車上使用無感測器歸位。Klipper使用`[stepper_x]`步進器來檢測X滑車歸位時的失速，使用`[stepper_y]`步進器來檢測Y滑車歸位時的失速。

使用上述的調諧指南，為每個滑車找到合適的 "失速靈敏度"，但要注意以下限制：

1. 當在CoreXY上使用無感測器歸位時，確保沒有為任何一個步進電機配置`hold_current`。
1. 在調整時，確保X和Y車架在每次歸位嘗試前都接近其軌道的中心。
1. 調整完成後，當X和Y軸歸位時，使用宏來確保一個軸首先被歸位，然後將該滑車遠離軸的極限，停頓至少2秒，然後開始另一個滑車的歸位。遠離軸端點的移動可以避免一個軸被歸位，而另一個軸頂在軸的極限上（這可能使失速檢測發生偏差）。暫停是必要的，以確保驅動器的失速標誌在再次歸位之前被清除。

An example CoreXY homing macro might look like:

```
[gcode_macro HOME]
gcode:
    G90
    # Home Z
    G28 Z0
    G1 Z10 F1200
    # Home Y
    G28 Y0
    G1 Y5 F1200
    # Home X
    G4 P2000
    G28 X0
    G1 X5 F1200
```

## 查詢和診斷驅動程式設定

\`[DUMP_TMC 命令](G-Code.md#dump_tmc)是配置和診斷驅動程式的有效工具。它將報告所有由Klipper配置的欄位，以及所有可以從驅動中查詢到的欄位。

所有報告的欄位都定義在驅動器的Trinamic數據手冊中。這些數據表可以在[Trinamic網站](https://www.trinamic.com/)上找到。請獲取並檢視驅動器的Trinamic數據手冊來解釋DUMP_TMC的結果。

## 配置driver_XXX設定

Klipper支援使用`driver_XXX`設定來配置許多底層驅動程式欄位。[TMC驅動配置參考](Config_Reference.md#tmc-stepper-driver-configuration)有每種型別的驅動可用欄位的完整列表。

此外，幾乎所有的欄位都可以在執行時使用[SET_TMC_FIELD命令](G-Codes.md#set_tmc_field)進行修改。

每一個欄位都在驅動器的Trinamic數據手冊中有定義。這些數據表可以在[Trinamic網站](https://www.trinamic.com/)上找到。

請注意，Trinamic的數據表中，有時一些詞可能導致在高層設定（如 "hysteresis end"）和底層欄位值（如 "HEND"）的混亂。在Klipper中，`driver_XXX`和SET_TMC_FIELD總是設定實際寫入驅動器的底層次欄位值。例如，如果Trinamic的數據表指出，需要將3的值寫入HEND欄位，以使得 "hysteresis end"等於0，那麼設定`driver_HEND=3`使得高層獲得0的值。

## 常見問題

### 我可以在有壓力推進（pressure advance）的擠出機上使用stealthChop 模式嗎？

許多人成功地在 "stealthChop "模式下使用了Klipper的壓力推進。Klipper實現了[平滑壓力推進](Kinematics.md#pressure-advance)，它不會引入任何瞬時速度變化。

然而，"stealthChop "模式可能導致較低的電機扭矩和/或產生較高的電機熱量。對於你的特定印表機來說，它可能是也可能不是一個合適的模式。

### 我一直得到 "Unable to read tmc uart 'stepper_x' register IFCNT "的錯誤？

這種情況發生在Klipper無法與tmc2208或tmc2209驅動通訊時。

確保電機電源啟用，因為步進電機驅動器在與微控制器通訊之前一般需要確保電機先上電。

如果這個錯誤是在第一次刷寫Klipper后發生的，那麼步進驅動器可能處在一個狀態，此狀態與剛剛寫入的Klipper不相容。要重置該狀態，請將印表機的所有電源拔掉幾秒鐘（物理上拔掉USB插頭和電源插頭）。

否則，這種錯誤通常是由於UART引腳接線不正確或Klipper配置的UART引腳設定不正確造成的。

### 我一直得到 "Unable to write tmc spi 'stepper_x' register ..."的錯誤？

當Klipper無法與tmc2130或tmc5160驅動通訊時就會出現這種情況。

確保電機電源啟用，因為步進電機驅動器在與微控制器通訊之前一般需要確保電機先上電。

否則，這種錯誤通常是由於SPI接線不正確、Klipper對SPI設定的配置不正確或SPI匯流排上的裝置配置不完整造成的。

請注意，如果驅動器是在掛多個裝置共享的SPI匯流排上，那麼一定要在Klipper中完全配置該共享SPI匯流排上的每個裝置。如果共享SPI匯流排上的一個裝置沒有被配置，那麼它可能會錯誤地響應不是為它準備的命令，並破壞與目標裝置的通訊。如果在共享的SPI匯流排上有不能在Klipper中配置的裝置，那麼使用[static_digital_output config section](Config_Reference.md#static_digital_output)將未使用的裝置的CS引腳設定為高電平（這樣它就不會試圖使用SPI匯流排）。電路板的原理圖通常是一個有用的參考，原理圖上可以找到哪些裝置掛在SPI匯流排上以及它們的相關引腳。

### 為什麼我得到一個 "TMC reports error: ..."錯誤？

這型別的錯誤表明TMC驅動器檢測到了一個問題，並且已經自我禁用。也就是說，驅動器已經停止了保持位置，並忽略了移動命令。如果Klipper檢測到一個啟用的驅動器已經自我禁用，它就會把印表機切換到 "關閉 "狀態。

也有可能由於SPI錯誤導致無法與驅動器通訊而發生**TMC reports error**導致的關機（在tmc2130、tmc5160或tmc2660上）。如果發生這種情況，報告的驅動器狀態通常會顯示 "00000000 "或 "ffffff"--例如：`TMC reports error: DRV_STATUS: ffffffff ...`或者`TMC reports error: READRSP@RDSEL2: 00000000 ...`。這樣的故障可能是由於SPI的接線問題，也可能是由於TMC驅動器的自復位或故障導致的。

一些常見的錯誤和診斷的技巧：

#### TMC 報告錯誤： `... ot=1(OvertempError!)`

這表明電機驅動器因溫度過高而自我禁用。典型的解決方案是降低步進電機的電流，增加步進電機驅動器的冷卻，和/或增加步進電機的冷卻。

#### TMC 報告錯誤: `... ShortToGND` 或著 `LowSideShort`

這表明驅動器已自行禁用，因為它檢測到通過驅動器的電流非常高。這可能表明連線到步進電機或者部件電機內部的電線鬆動或短路了。

如果使用stealthChop模式，並且TMC驅動器不能準確地預測電機的機械負載，也可能發生這種錯誤。(如果驅動器預測不準確，那麼它可能輸出過高電流到電機，並觸發自己的過電流檢測)。要測試這個，請禁用stealthChop模式，再檢查錯誤是否繼續發生。

#### TMC報告錯誤：`... reset=1(Reset)` 或`CS_ACTUAL=0(Reset?)` 或`SE=0(Reset?)`

這表明驅動器在列印過程中自我復位。這可能是由於電壓或接線問題導致的。

#### TMC 報告錯誤： `... uv_cp=1(Undervoltage!)`

這表明驅動器檢測到了一個電壓低事件，並已自行禁用。這可能是由於接線或電源問題導致的。

### 我如何在我的驅動器上調整 spreadCycle/coolStep等模式？

[Trinamic網站](https://www.trinamic.com/)有關於配置驅動程式的指南。這些指南通常是專業、底層且可能需要專用的硬體。不管怎麼說，它們是最好的資訊來源。
