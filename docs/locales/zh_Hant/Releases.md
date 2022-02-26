# 版本發佈

Klipper版本發佈歷史。如何安裝Klipper，請檢視[installation](Installation.md)。

## Klipper 0.10.0

在20210929發佈，此版本的主要更新：

* Support for "Multi-MCU Homing". It is now possible for a stepper motor and its endstop to be wired to separate micro-controllers. This simplifies wiring of Z probes on "toolhead boards".
* Klipper 現在有一個 [Community Discord Server](https://discord.klipper3d.org) 和一個 [Community Discourse Server](https://community.klipper3d.org)。
* The [Klipper website](https://www.klipper3d.org) now uses the "mkdocs" infrastructure. There is also a [Klipper Translations](https://github.com/Klipper3d/klipper-translations) project.
* 在許多板上通過 sdcard 自動支持刷新固件。
* New kinematic support for "Hybrid CoreXY" and "Hybrid CoreXZ" printers.
* Klipper 現在使用 `rotation_distance` 來配置步進電機的行程距離。
* The main Klipper host code can now directly communicate with micro-controllers using CAN bus.
* New "motion analysis" system. Klipper's internal motion updates and sensor results can be tracked and logged for analysis.
* Trinamic stepper motor drivers are now continuously monitored for error conditions.
* 支持 rp2040 微控制器（Raspberry Pi Pico 板）。
* The "make menuconfig" system now utilizes kconfiglib.
* Many additional modules added: ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu
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
* 對 "Rotary Delta "和 "CoreXZ "印表機的新運動學支援。
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
   * Improved support for TMC UART handling with an analog mux.
* 改進的歸位、探測和床校平支持：
   * New manual_probe, bed_screws, screws_tilt_adjust, skew_correction, safe_z_home modules added.
   * 使用中值、平均和重試邏輯增強多樣本探測。
   * Improved documentation for BL-Touch, probe calibration, endstop calibration, delta calibration, sensorless homing, and endstop phase calibration.
   * 改進了大 Z 軸上的歸位支持。
* 許多 Klipper 微控制器改進：
   * Klipper 移植到：SAM3X8C、SAM4S8C、SAMD51、STM32F042、STM32F4
   * 在 SAM3X、SAM4、STM32F4 上實現新的 USB CDC 驅動程序。
   * 增強了對通過 USB 刷新 Klipper 的支持。
   * 軟件 SPI 支援。
   * 大大改進了 LPC176x 上的溫度過濾。
   * 早期的輸出引腳設置可以在微控制器中進行配置。
* 帶有 Klipper 文檔的新網站：http://klipper3d.org/
   * Klipper 現在有了一個標誌。
* 對polar和“cable winch”運動學作實驗性支持。
* 配置文件現在可以包含其他配置文件。
* Many additional modules added: board_pins, controller_fan, delayed_gcode, dotstar, filament_switch_sensor, firmware_retraction, gcode_arcs, gcode_button, heater_generic, manual_stepper, mcp4018, mcp4728, neopixel, pause_resume, respond, temperature_sensor tsl1401cl_filament_width_sensor, tuning_tower
* 添加了許多附加命令：RESTORE_GCODE_STATE、SAVE_GCODE_STATE、SET_GCODE_VARIABLE、SET_HEATER_TEMPERATURE、SET_IDLE_TIMEOUT、SET_TEMPERATURE_FAN_TARGET
* 幾個錯誤的修復和程式碼的清理。

## Klipper 0.7.0

在20181220發佈。此版本的主要更新：

* Klipper 現在支持“網狀”床調平
* 對三角機型的強化校準的新支持（校準三角機型打印機上的打印 x/y 尺寸）
* Support for run-time configuration of Trinamic stepper motor drivers (tmc2130, tmc2208, tmc2660)
* Improved temperature sensor support: MAX6675, MAX31855, MAX31856, MAX31865, custom thermistors, common pt100 style sensors
* Several new modules: temperature_fan, sx1509, force_move, mcp4451, z_tilt, quad_gantry_level, endstop_phase, bltouch
* Several new commands added: SAVE_CONFIG, SET_PRESSURE_ADVANCE, SET_GCODE_OFFSET, SET_VELOCITY_LIMIT, STEPPER_BUZZ, TURN_OFF_HEATERS, M204, custom g-code macros
* 擴充的 LCD 顯示支援：
   * Support for run-time menus
   * 新的顯示圖標
   * 支援“uc1701”和“ssd1306”顯示屏
* 支援更多的微控制器:
   * Klipper 移植到：LPC176x (Smoothieboards), SAM4E8E (Duet2), SAMD21 (Arduino Zero), STM32F103 ("Blue pill" devices), atmega32u4
   * 在 AVR、LPC176x、SAMD21 和 STM32F103 上實現的新通用 USB CDC 驅動程序
   * 對ARM 處理器的性能改進
* The kinematics code was rewritten to use an "iterative solver"
* Klipper 主機軟件的新自動測試用例
* 常見的現成打印機的許多新示例配置文件
* 引導加載程序、基準測試、微控制器移植、配置檢查、引腳映射、切片器設置、封裝等的文檔更新
* 幾個錯誤修復和代碼清理

## Klipper 0.6.0

在20180331發佈。此版本的主要更新：

* 增強的加熱器和熱敏電阻硬件故障檢查
* 支援 Z 探頭
* 對三角機型的自動參數校準作初步支持（通過新的 delta_calibrate 命令）
* Initial support for bed tilt compensation (via bed_tilt_calibrate command)
* Initial support for "safe homing" and homing overrides
* 初步支持在 RepRapDiscount 樣式 2004 和 12864 顯示屏上顯示狀態
* 新增對多擠出機支援的改善：
   * 支援共享加熱頭
   * Initial support for dual carriages
* Support for configuring multiple steppers per axis (eg, dual Z)
* Support for custom digital and pwm output pins (with a new SET_PIN command)
* Initial support for a "virtual sdcard" that allows printing directly from Klipper (helps on machines too slow to run OctoPrint well)
* Support for setting different arm lengths on each tower of a delta
* 支持 G-Code M220/M221 命令 (speed factor override / extrude factor override)
* 幾個文檔更新：
   * 常見的現成打印機的許多新示例配置文件
   * New multiple MCU config example
   * 新的 bltouch 傳感器配置示例
   * 新的常見問題解答、配置檢查和 G-Code文件檔
* Initial support for continuous integration testing on all github commits
* 幾個錯誤修復和代碼清理

## Klipper 0.5.0

在20171025發佈。此版本的主要更新：

* 支援具有多個擠出機的打印機。
* Initial support for running on the Beaglebone PRU. Initial support for the Replicape board.
* Initial support for running the micro-controller code in a real-time Linux process.
* Support for multiple micro-controllers. (For example, one could control an extruder with one micro-controller and the rest of the printer with another.) Software clock synchronization is implemented to coordinate actions between micro-controllers.
* Stepper performance improvements (20Mhz AVRs up to 189K steps per second).
* Support for controlling servos and support for defining nozzle cooling fans.
* 幾個錯誤修復和代碼清理

## Klipper 0.4.0

在20170503發佈。此版本的主要更新：

* Improved installation on Raspberry Pi machines. Most of the install is now scripted.
* Support for corexy kinematics
* 文檔更新：新的運動學文檔、新的 Pressure Advance 調整指南、新的示例配置文件等
* Stepper performance improvements (20Mhz AVRs over 175K steps per second, Arduino Due over 460K)
* Support for automatic micro-controller resets. Support for resets via toggling USB power on Raspberry Pi.
* The pressure advance algorithm now works with look-ahead to reduce pressure changes during cornering.
* 支援限制短之字形移動的最高速度
* 支援 AD595 傳感器
* 幾個錯誤修復和代碼清理

## Klipper 0.3.0

在20161223發佈。此版本的主要更新：

* 改進的文件檔
* 支持具有 三角機型的機器
* 支持 Arduino Due 微控制器 (ARM cortex-M3)
* 支持基於 USB 的 AVR 微控制器
* 支持“pressure advance" 算法 - 它減少了打印過程中的滲出。
* 新的“基於步進相控的限位器”功能 - 可實現更高精度的限位器歸位。
* Support for "extended g-code" commands such as "help", "restart", and "status".
* Support for reloading the Klipper config and restarting the host software by issuing a "restart" command from the terminal.
* Stepper performance improvements (20Mhz AVRs up to 158K steps per second).
* Improved error reporting. Most errors now shown via the terminal along with help on how to resolve.
* 幾個錯誤修復和代碼清理

## Klipper 0.2.0

Initial release of Klipper. Available on 20160525. Major features available in the initial release include:

* 對獨立XY打印機（步進機、擠出機、加熱床、冷卻風扇）的基本支持。
* Support for common g-code commands. Support for interfacing with OctoPrint.
* 加速和前瞻處理
* 通過標準串行端口支援 AVR 微控制器
