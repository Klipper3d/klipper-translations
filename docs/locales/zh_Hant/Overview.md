# 概述

歡迎使用Klipper文件。如果剛接觸Klipper，請從[特性](features.md)和[安裝](installation.md)文件開始閱讀。

## 概覽資訊

- [功能](Features.md)：Klipper 中的高級功能列表。
- [常見問題](FAQ.md)：常見問題。
- [發行版](Release.md)：Klipper 的版本發佈歷史。
- [配置更改](Config_Changes.md)：可能需要手動更新印表機配置檔案的軟體更改。
- [聯繫](Contact.md)：關於如何提交錯誤報告和聯繫 Klipper 開發者的資訊。

## 安裝和配置

- [安裝](Installation.md)：Klipper 安裝指南。
- [配置參考](Config_Reference.md)：配置參數說明。
   - [旋轉距離](Rotation_Distance.md)：計算旋轉距離(rotation_distance)步進參數。
- [檢查配置](Config_checks.md)：驗證配置檔案中的基本引腳設定。
- [列印床調平](Bed_Level.md)：Klipper 中關於「列印床調平」的資訊。
   - [三角洲校準](Delta_Calibrate.md)：校準三角洲結構。
   - [探針校準](Probe_Calibrate.md)：校準自動Z探針。
   - [BL-Touch](BLTouch.md)：配置「BL-Touch」Z 探針。
   - [手動調平](Manual_Level.md)：校準 Z 限位和調整熱床調平螺絲。
   - [床網](Bed_Mesh.md)：基於 XY 位置的列印床高度補償。
   - [限位相位](Endstop_Phase.md)：使用步進電機相位輔助 Z 限位定位。
- [共振補償](Resonance_Compensation.md)：減少列印震紋的工具。
   - [測量共振](Measuring_Resonances.md)：使用 adxl345 加速度計模組測量共振。
- [提前壓力](Pressure_Advance.md)：校準擠出機壓力。
- [G程式碼](G-Codes.md)：用於 Klipper 的G程式碼命令。
- [命令模板](Command_Templates.md)：G程式碼宏和條件判斷。
   - [狀態參考](Status_Reference.md)：可用於宏和類似功能的資訊。
- [TMC驅動](TMC_Drivers.md)：在 Klipper 中使用 Trinamic 步進電機驅動。
- [Multi-MCU Homing](Multi_MCU_Homing.md)：在歸位和探測時使用多個微處理器。
- [切片](Slicers.md)：為 Klipper 配置切片軟體。
- [偏斜校正](Skew_Correction.md)：調整不完全垂直的軸（不完美的方形）。
- [PWM 工具](Using_PWM_Tools.md)：關於如何使用 PWM 控制的工具，例如鐳射器或電鉆頭。
- [Exclude Object](Exclude_Object.md): The guide to the Exclude Objects implementation.

## 開發者文檔

- [程式碼概述](Code_Overview.md)：開發者應該從這個文件開始閱讀。
- [運動學](Kinematics.md)：關於 Klipper 如何實現運動的技術細節。
- [協議](Protocol.md)：主機和微控制器之間的低階通訊協議的資訊。
- [API 伺服器](API_Server.md)：關於 Klipper 的命令與控制 API 的資訊。
- [MCU 指令](MCU_Commands.md)：描述在微控制器軟體中實現的低階指令。
- [CAN 匯流排協議](CANBUS_protocol.md)：Klipper 的 CAN匯流排報文格式。
- [除錯](Debugging.md)：關於如何測試和除錯 Klipper。
- [基準測試](Benchmarks.md)：關於 Klipper 基準測試的方法。
- [貢獻](CONTRIBUTING.md)：有關如何向 Klipper 提交改進方法的資訊。
- [打包](Packaging.md)：有關於如何構建系統包的資訊。

## 設備特定文件

- [示列配置](Example_Configs.md)：有關於新增示列配置到 Klipper 的資訊。
- [SD卡更新](SDCard_Updates.md)：通過將韌體拷貝到SD卡中，再通過微控制器的SD卡槽來刷寫微控制器。
- [將樹莓派作為微控制器](RPi_microcontroller.md)：關於如何控制與樹莓派 GPIO 引腳連線的裝置。
- [Beaglebone](Beaglebone.md)：在 Beaglebone PRU 上執行 Klipper 的詳細資訊。
- [底層載入程式](Bootloaders.md)：有關於微控制器刷寫的開發者資訊。
- [CAN 匯流排](CANBUS.md)：有關於 Klipper 使用 CAN 匯流排的資訊。
- [TSL1401CL 耗材線徑感測器](TSL1401CL_Filament_Width_Sensor.md)
- [霍爾列印絲寬度感測器](Hall_Filament_Width_Sensor.md)
