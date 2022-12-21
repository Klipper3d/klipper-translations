# 版本發佈

Klipper版本發佈歷史。如何安裝Klipper，請檢視[installation](Installation.md)。

## Klipper 0.11.0

Available on 20221128. Major changes in this release:

* Trinamic stepper motor driver "step on both edges" optimization.
* Support for Python3. The Klipper host code will run with either Python2 or Python3.
* Enhanced CAN bus support. Support for CAN bus on rp2040, stm32g0, stm32h7, same51, and same54 chips. Support for "USB to CAN bus bridge" mode.
* Support for CanBoot bootloader.
* Support for mpu9250 and mpu6050 accelerometers.
* Improved error handling for max31856, max31855, max31865, and max6675 temperature sensors.
* It is now possible to configure LEDs to update during long running G-Code commands using LED "template" support.
* Several micro-controller improvements. New support for stm32h743, stm32h750, stm32l412, stm32g0b1, same70, same51, and same54 chips. Support for i2c reads on atsamd and stm32f0. Hardware pwm support on stm32. Linux mcu signal based event dispatch. New rp2040 support for "make flash", i2c, and rp2040-e5 USB errata.
* New modules added: angle, dac084S085, exclude_object, led, mpu9250, pca9632, smart_effector, z_thermal_adjust. New deltesian kinematics added. New dump_mcu tool added.
* 幾個錯誤的修復和程式碼的清理。

## Klipper 0.10.0

在20210929發佈，此版本的主要更新：

* 支援“多MCU歸位”。現在可以將步進電機及其限位器連接到單獨的微控制器。這簡化了"toolhead boards"上 Z 探頭的接線。
* Klipper 現在有一個 [Community Discord Server](https://discord.klipper3d.org) 和一個 [Community Discourse Server](https://community.klipper3d.org)。
* [Klipper 網站](https://www.klipper3d.org) 現在使用“mkdocs”基礎架構。還有一個 [Klipper Translations](https://github.com/Klipper3d/klipper-translations) 項目。
* 在許多板上通過 sdcard 自動支援刷新固件。
* 對“Hybrid CoreXY”和“Hybrid CoreXZ”打印機的新機型支援。
* Klipper 現在使用 `rotation_distance` 來配置步進電機的行程距離。
* Klipper 主代碼現在可以使用 CANBUS直接與微控制器通信。
* 新的"motion analysis"系統。可以跟踪和記錄 Klipper 的內部運動更新和傳感器結果以供分析。
* Trinamic 步進電機驅動器現在可以連續監控錯誤情況。
* 支援 rp2040 微控制器（Raspberry Pi Pico 板）。
* “make menuconfig”系統現在使用 kconfiglib。
* 添加了許多附加模塊：ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu
* 幾個錯誤的修復和程式碼的清理。

## Klipper 0.9.0

在20201020發佈，此版本的主要更新：

* 支援使用「Input Shaping」功能 - 此功能主要作用是抵消印表機共振。它可以減少甚至消除列印中產生的「ringing」振紋。
* 「Smooth Pressure Advance」全新的擠出演算法機制。這實現了「Pressure Advance」(列印擠出）同時不會引起擠出速度瞬間的改變，相反會變得更加平滑。現在也可以使用「Tuning Tower」方法來調整「Pressure Advance」(列印擠出）。
* 「webhooks」全新的API 伺服器。 這次 Klipper 新增了可程式設計的 JSON 介面。
* 現在可以使用 Jinja2 模板語言配置 LCD 顯示和菜單。
* 現在TMC2208 步進電機驅動器可以在 Klipper系統中 使用「standalone」模式。
* 支援並優化使用BL-Touch v3 。
* 改進了USB識別。Klipper現在有自己的USB識別程式碼，微控制器現在可以在USB識別期間報告其唯一的序列號。
* 對 "旋轉三角洲"和 "CoreXZ "機型印表機的支援。
* 微控制器的改進：支援stm32f070，支援stm32f207，支援 "Linux MCU "的GPIO引腳，支援stm32 "HID啟動載入程式"，支援Chitu啟動載入程式，支援MKS Robin啟動載入程式。
* 改進了對Python "垃圾收集 "事件的處理。
* 增加了許多額外的模組：adc_scaled, adxl345, bme280, display_status, extruder_stepper, fan_generic, hall_filament_width_sensor, htu21d, homing_heaters, input_shaper, lm75, print_stats, resonance_tester, shaper_calibrate, query_adc, graph_accelerometer, graph_extruder, graph_motion, graph_shaper, graph_temp_sensor, whconsole
* 幾個錯誤的修復和程式碼的清理。

### Klipper 0.9.1

在20201028發佈。只包含錯誤修復。

## Klipper 0.8.0

在20191021發佈。此版本的主要更新：

* 新的G-Code命令模板支援。配置檔案中的G-Code現在可以用Jinja2模板語言進行編寫。
* 對Trinamic步進驅動器的改進：
   * 新增對TMC2209和TMC5160驅動器的支援。
   * 改進了 DUMP_TMC、SET_TMC_CURRENT 和 INIT_TMC G-Code 命令。
   * 通過模擬多路復用器改進了對 TMC UART 處理的支援。
* 改進的歸位、探測和床校平支援：
   * 添加了新的 manual_probe、bed_screws、screw_tilt_adjust、skew_correction、safe_z_home 模塊。
   * 使用中值、平均和重試邏輯增強多樣本探測。
   * 改進了 BL-Touch、探頭校準、停止校準、增量校準、無傳感器歸位和停止相位校準的文檔。
   * 改進了大 Z 軸上的歸位支援。
* 許多 Klipper 微控制器改進：
   * Klipper 移植到：SAM3X8C、SAM4S8C、SAMD51、STM32F042、STM32F4
   * 在 SAM3X、SAM4、STM32F4 上實現新的 USB CDC 驅動程序。
   * 增強了對通過 USB 刷新 Klipper 的支援。
   * 軟件 SPI 支援。
   * 大大改進了 LPC176x 上的溫度過濾。
   * 早期的輸出引腳設置可以在微控制器中進行配置。
* 帶有 Klipper 文檔的新網站：http://klipper3d.org/
   * Klipper 現在有了一個標誌。
* 對polar和“cable winch”機型作實驗性支援。
* 配置文件現在可以包含其他配置文件。
* 添加了許多附加模塊：board_pins、controller_fan、delayed_gcode、dotstar、filament_switch_sensor、firmware_retraction、gcode_arcs、gcode_button、heater_generic、manual_stepper、mcp4018、mcp4728、neopixel、pause_resume、response、temperature_sensor tsl1401cl_filament_width_sensor、tuning_tower
* 添加了許多附加命令：RESTORE_GCODE_STATE、SAVE_GCODE_STATE、SET_GCODE_VARIABLE、SET_HEATER_TEMPERATURE、SET_IDLE_TIMEOUT、SET_TEMPERATURE_FAN_TARGET
* 幾個錯誤的修復和程式碼的清理。

## Klipper 0.7.0

在20181220發佈。此版本的主要更新：

* Klipper 現在支援“網狀”床調平
* 對三角機型的強化校準的新支援（校準三角機型打印機上的打印 x/y 尺寸）
* 支援 Trinamic 步進電機驅動器（tmc2130、tmc2208、tmc2660）的運行時配置
* 改進的溫度傳感器支援：MAX6675、MAX31855、MAX31856、MAX31865、定制熱敏電阻、通用 pt100 型傳感器
* 幾個新模塊：temperature_fan、sx1509、force_move、mcp4451、z_tilt、quad_gantry_level、endstop_phase、bltouch
* 添加了幾個新命令：SAVE_CONFIG、SET_PRESSURE_ADVANCE、SET_GCODE_OFFSET、SET_VELOCITY_LIMIT、STEPPER_BUZZ、TURN_OFF_HEATERS、M204、自定義 G-Code
* 擴充的 LCD 顯示支援：
   * 支援即時建立的菜單
   * 新的顯示圖標
   * 支援“uc1701”和“ssd1306”顯示屏
* 支援更多的微控制器:
   * Klipper 移植到：LPC176x (Smoothieboards), SAM4E8E (Duet2), SAMD21 (Arduino Zero), STM32F103 ("Blue pill" devices), atmega32u4
   * 在 AVR、LPC176x、SAMD21 和 STM32F103 上實現的新通用 USB CDC 驅動程序
   * 對ARM 處理器的性能改進
* 重寫動作代碼,轉用"iterative solver"
* Klipper 主機軟件的新自動測試用例
* 常見的現成打印機的許多新示例配置文件
* 引導加載程序、基準測試、微控制器移植、配置檢查、引腳映射、切片器設置、封裝等的文檔更新
* 幾個錯誤修復和代碼清理

## Klipper 0.6.0

在20180331發佈。此版本的主要更新：

* 增強的加熱器和熱敏電阻硬件故障檢查
* 支援 Z 探頭
* 對三角機型的自動參數校準作初步支援（通過新的 delta_calibrate 命令）
* 對床傾斜補償的初始支援（通過 bed_tilt_calibrate 命令）
* 對"safe homing"和歸位覆蓋的初始支援
* 初步支援在 RepRapDiscount 樣式 2004 和 12864 顯示屏上顯示狀態
* 新增對多擠出機支援的改善：
   * 支援共享加熱頭
   * 對雙步進的初步支援
* 支援為每個軸配置多個步進器（例如 : 雙 Z）
* 支援自定義數字和 pwm 輸出引腳（使用新的 SET_PIN 命令）
* 最初支援允許直接從 Klipper 打印的“虛擬 sdcard”（有助於機器速度太慢而無法很好地運行 OctoPrint）
* 支援在三角洲機型的每個柱上設置不同的印臂長度
* 支援 G-Code M220/M221 命令 (speed factor override / extrude factor override)
* 幾個文檔更新：
   * 常見的現成打印機的許多新示例配置文件
   * 新增多 MCU 配置示例
   * 新的 bltouch 傳感器配置示例
   * 新的常見問題解答、配置檢查和 G-Code文件檔
* 對所有 github 提交的持續集成測試的初始支援
* 幾個錯誤修復和代碼清理

## Klipper 0.5.0

在20171025發佈。此版本的主要更新：

* 支援具有多個擠出機的打印機。
* 最初支援在 Beaglebone PRU 上運行。對複制板的初始支援。
* 初步支援在實時 Linux 進程中運行微控制器代碼。
* 支援多個微控制器。 （例如，可以用一個微控制器控制擠出機，而用另一個微控制器控制打印機的其餘部分。）實現軟件時鐘同步以協調微控制器之間的動作。
* 步進器性能改進（20Mhz AVR 高達每秒 189K 步）。
* 支援控制舵機，支援定義噴嘴冷卻風扇。
* 幾個錯誤修復和代碼清理

## Klipper 0.4.0

在20170503發佈。此版本的主要更新：

* 改進了 Raspberry Pi 機器上的安裝。現在大部分安裝都是腳本化的。
* 支援 corexy 機型
* 文檔更新：新的機型文檔、新的 Pressure Advance 調整指南、新的示例配置文件等
* 步進器性能改進（20Mhz AVR 每秒超過 175K 步，Arduino Due 超過 460K）
* 支援自動微控制器復位。支援通過在 Raspberry Pi 上切換 USB 電源進行重置。
* pressure advance算法現在與前瞻一起使用，以減少轉彎過程中的壓力變化。
* 支援限制短之字形移動的最高速度
* 支援 AD595 傳感器
* 幾個錯誤修復和代碼清理

## Klipper 0.3.0

在20161223發佈。此版本的主要更新：

* 改進的文件檔
* 支援具有 三角機型的機器
* 支援 Arduino Due 微控制器 (ARM cortex-M3)
* 支援基於 USB 的 AVR 微控制器
* 支援“pressure advance" 算法 - 它減少了打印過程中的滲出。
* 新的“基於步進相控的限位器”功能 - 可實現更高精度的限位器歸位。
* 支援“擴展 G-Code”命令，例如“help”、“restart”和“status”。
* 支援通過從終端發出“重新啟動”命令來重新加載 Klipper 配置並重新啟動主機軟件。
* 步進器性能改進（20Mhz AVR 高達每秒 158K 步）。
* 改進的錯誤報告。現在通過終端顯示大多數錯誤以及如何解決的幫助。
* 幾個錯誤修復和代碼清理

## Klipper 0.2.0

Klipper 的初始版本。在 20160525 上可用。初始版本中提供的主要功能包括：

* 對獨立XY打印機（步進機、擠出機、加熱床、冷卻風扇）的基本支援。
* 支援常見的 G-Code命令。支援與 OctoPrint 的接口。
* 加速和前瞻處理
* 通過標準串行端口支援 AVR 微控制器
