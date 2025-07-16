# 功能

Klipper 有幾個引人注目的功能：

* 高精度步進馬達運動。Klipper 利用應用處理器（例如低成本的 Raspberry Pi）來計算列印機的運動。應用處理器負責決定每個步進馬達的步進時機，將這些事件壓縮後傳輸到微控制器，然後由微控制器在請求的時間執行每個事件。每個步進事件的調度精度達到 25 微秒或更高。軟體不使用運動估算方法（如 Bresenham 演算法），而是基於加速度物理學和機器運動學的物理原理精確計算步進時間。更精確的步進電機運動能提供更安靜且穩定的列印機操作。
* 卓越的性能表現。Klipper 能夠在新舊微控制器上實現高步進速率。即使是舊的 8 位元微控制器也可以達到每秒 175K 步以上的速率，而在較新的微控制器上，則可以實現每秒數百萬步的速率。更高的步進速率允許更高的列印速度。即使在高速運行時，步進事件的計時仍保持精確，進一步提升整體穩定性。
* Klipper 支援帶有多個微控制器的印表機。例如，一個微控制器可以被用來控制擠出機，而另一個用來控制加熱器，並使用第三個來控制其他的印表機元件。Klipper 主機程式實現了時鐘同步，解決了微處理器之間的時鐘漂移。 啟用多個控制器只需要在配置檔案中新增幾行，不需要任何特殊程式碼。
* 通過簡單的配置檔案進行配置。修改設定不需要重新刷寫微控制器。Klipper 的所有配置都被儲存在一個易編輯的配置檔案中，大大減少了配置與維護硬體的難度。
* Klipper 支援「平滑提前壓力」--一種考慮了擠出機內壓力影響的機制。這項技術可以減少噴嘴溢料並改善轉角的列印質量。Klipper 的實現不會引入瞬間擠出機速度變化，改善了整體穩定性和穩健性。
* 支援使用「輸入整形」來減少振動對列印質量的影響。這項功能可以減少或消除列印件的「振紋(ringing)」（又名「ghosting」，「echoing」，或「rippling」）。在一些情況下它可以在保持列印質量的同時提高列印速度。
* Klipper 使用「迭代求解器」從簡單的運動學方程中計算精準的步進時間。這降低了移植Klipper到新的機械結構的難度並保證了精確的步進計時（而不需要「線段化」）。
* Klipper 與硬體無關。無論低階電子硬體為何，皆能獲得相同精確的計時。Klipper 的微控制器程式設計旨在忠實遵循 Klipper 主機軟體提供的計劃表（或在無法執行時顯著警告使用者）。這讓使用現有硬體、更換新硬體更加容易，同時也增強了對硬體的信心。
* 易移植的程式碼。Klipper 可以在 ARM、AVR，和PRU架構的微控制器上執行。現有的「reprap」類印表機不需要改動任何硬體就可以執行 Klipper，只需要加一個樹莓派。Klipper 的內部程式碼結構使它能夠被簡單的移植到其他架構。
* 簡潔的程式碼。大部分 Klipper 程式碼使用一個極高級程式語言（Python），這包括了運動演算法，G程式碼解析，加熱，溫度感測器演算法和其他，降低了開發新功能的難度。
* 自定義可程式設計指令碼。可以在印表機配置檔案中定義新的G程式碼命令（而不需要修改任何程式碼）。這些命令都是可程式設計的，可以能根據印表機的狀態做出不同的響應。
* 內建API伺服器。除了標準G程式碼介面，Klipper也支援富JSON API。使程式設計師能編寫對印表機進行精細控制的外接程式。

## 其他功能

Klipper 支援許多標準的 3d 印表機功能：

* 多種網頁介面可供選擇。可搭配 Mainsail、Fluidd、OctoPrint 等介面使用。這使得可以透過一般網頁瀏覽器控制列印機。同一台執行 Klipper 的 Raspberry Pi 也可以執行這些網頁介面。
* 標準 G 程式碼支援。支援由常見「切片軟體」（SuperSlicer、Cura、PrusaSlicer 等）產生的通用 G 程式碼命令。
* 支援多擠出機。包括對共享熱端的擠出機（多進一出）和多頭（IDEX）的支援。
* 支援多種列印機架構，包括直線式 (Cartesian)、三角洲式 (Delta)、CoreXY、CoreXZ、混合式 CoreXY、混合式 CoreXZ、Deltesian、旋轉三角洲式 (Rotary Delta)、極座標式 (Polar) 以及纜繩式 (Cable Winch) 列印機。
* Automatic bed leveling support. Klipper can be configured for basic bed tilt detection or full mesh bed leveling. The bed mesh can be customized to the print size (adaptive bed mesh). If the bed uses multiple Z steppers then Klipper can also level by independently manipulating the Z steppers. Most Z height probes are supported, including BL-Touch probes and servo activated probes. Probes may be calibrated for axis twist compensation. If using an "eddy current probe" then one can utilize fast bed mesh scanning,
* 支援自動delta校準。校準工具可以進行基本的高度校準，以及增強的X和Y尺寸校準。校準可以用Z型高度探頭或通過手動探測來完成。
* 列印時支援“排除物件”。當啟用此模組時，可在多件列印中僅取消指定的單一物件。
* Support for common temperature sensors (eg, common thermistors, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20, AHT10, SHT3x, and LM75). Custom thermistors and custom analog temperature sensors can also be configured. One can monitor the internal micro-controller temperature sensor and the internal temperature sensor of a Raspberry Pi.
* 預設啟用基本加熱器保護。
* Support for standard fans, nozzle fans, and temperature controlled fans. No need to keep fans running when the printer is idle. Fan speed can be monitored on fans that have a tachometer. One can assign a "math formula" to a fan for automatic fan speed updating.
* 支援運行時配置 TMC2130、TMC2208/TMC2224、TMC2209、TMC2660 和 TMC5160 步進馬達驅動器。此外，也支援透過 AD5206、DAC084S085、MCP4451、MCP4728、MCP4018 和 PWM 腳位對傳統步進驅動器進行電流控制。
* 支援直接連線到印表機的普通LCD顯示器。還提供了一個預設的菜單。顯示器和菜單的內容可以通過配置檔案完全定製。
* 恒定加速和「look-ahead」（前瞻）支援。所有印表機移動將從靜止逐漸加速到巡航速度，然後減速回到靜止。對傳入的 G 程式碼移動命令流進行排隊和分析 - 將優化類似方向上的移動之間的加速度，以減少列印停頓並改善整體列印時間。
* Klipper 實現了一種「步進相位限位」演算法，可以提高典型限位開關的精度。如果調整得當，它可以提高列印件首層和列印床的附著力。
* 支援列印絲存在感測器、列印絲運動感測器和列印絲寬度感測器。
* Support for measuring and recording acceleration using adxl345, mpu9250, mpu6050, lis2dw12, lis3dh, and icm20948 accelerometers.
* 支援限制短距離「之」字形移動的最高速度，以減少印表機的振動和噪音。更多資訊見[運動學](Kinematics.md)文件。
* 許多常見的印表機都有樣本配置檔案。檢視[配置資料夾](../config/)中的列表。

要開始使用Klipper，請閱讀[安裝](Installation.md)指南。

## 步速基準測試

下面是步進效能測試的結果。顯示的數字代表了微控制器上每秒的總步數。

| 微控制器 | 1個活躍步進電機 | 3個步進器活躍 |
| --- | --- | --- |
| 16Mhz AVR | 157K | 99K |
| 20Mhz AVR | 196K | 123K |
| SAMD21 | 686K | 471K |
| STM32F042 | 814K | 578K |
| Beaglebone 可程式設計實時單元 | 866K | 708K |
| STM32G0B1 | 1103K | 790K |
| STM32F103 | 1180K | 818K |
| SAM3X8E | 1273K | 981K |
| SAM4S8C | 1690K | 1385K |
| LPC1768 | 1923K | 1351K |
| LPC1769 | 2353K | 1622K |
| SAM4E8E | 2500K | 1674K |
| SAMD51 | 3077K | 1885K |
| AR100 | 3529K | 2507K |
| STM32G431 | 3617K | 2452K |
| STM32F407 | 3652K | 2459K |
| STM32F446 | 3913K | 2634K |
| RP2040 | 4000K | 2571K |
| RP2350 | 4167K | 2663K |
| SAME70 | 6667K | 4737K |
| STM32H723 | 7429K | 8619K |

如果不確定特定板上的微控制器，請找到適當的 [配置文件](../config/)，並在該文件頂部的註釋中查找微控制器名稱。

關於基準測試的更多詳細資訊可在[基準測試文件](Benchmarks.md)中找到。
