# 配置檢查

本文件提供了一系列幫助驗證 Klipper printer.cfg 檔案中的引腳設定的步驟。推薦在完成[安裝文件](Installation.md) 中的步驟后執行本文件中的步驟。

在執行此指南的過程中，可能需要修改 Klipper 的配置檔案。請務必在每次修改配置檔案后發送 RESTART 命令，以確保修改成功生效（在 Octoprint 終端標籤中輸入 "RESTART"（重啟），然後點選 "Send"（發送））。在每次重啟之後最好再發出一次 STATUS （狀態）命令，以驗證配置檔案是否成功載入。

## 驗證溫度

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## 驗證 M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## 驗證加熱器

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

如果印表機帶有熱床，則用熱床重複上述測試。

## 驗證步進電機 enable（啟用）引腳

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## 驗證限位開關

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

如果限位狀態根本沒有變化，則通常表示限位器連線到不同的引腳。 但是，它也可能表示需要更改引腳的上拉設定（endstop_pin 名稱開頭的「^」 - 大多數印表機需要使用上拉電阻並且應該存在「^」）。

## 驗證步進電機

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

如果步進電機根本不動，則需要驗證步進驅動的「enable_pin」和「step_pin」設定。 如果步進電機移動但沒有返回其原始位置，則需要驗證「dir_pin」設定。 如果步進電機的振盪方向不正確，則通常表示需要反轉驅動的「dir_pin」。 即通過新增「!」 到印表機配置檔案中的「dir_pin」設定來完成（如果已經存在"!"，則將其刪除）。 如果電機移動明顯大於或小於一毫米，則需要驗證「rotation_distance」設定。

對配置檔案中定義的每個步進電機執行上述測試。 （將 STEPPER_BUZZ 命令的 STEPPER 參數設定為要測試的配置部分的名稱。）如果擠出機中沒有耗材，也可以使用 STEPPER_BUZZ 驗證擠出機電機的接線（使用 STEPPER=extruder）。 否則，最好單獨測試擠出機電機（參見下一節）。

在驗證完所有限位器和所有步進電機后，應測試歸位機制。 發出 G28 命令以歸位所有軸。 如果印表機不能正常歸位，請斷開印表機電源。 然後，重新執行限位器和步進電機驗證流程。

## 驗證擠出機電機

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## 校準 PID 設定

Klipper支援擠出機和熱床加熱器的[PID控制](https://en.wikipedia.org/wiki/PID_controller)。爲了使用這種控制機制，必須對每臺印表機的 PID 參數進行校準（在其他韌體或示例配置檔案中找到的 PID 設定往往效果不佳）。

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

調整測試完成後，執行 `SAVE_CONFIG` 以儲存新PID設定到printer.cfg檔案。

如果印表機有加熱床，並且支援PWM（脈寬調製）驅動，那麼建議對加熱床使用PID控制。 （當使用 PID 演算法控制床加熱器時，它可能每秒打開和關閉十次，這可能不適用于使用機械開關的加熱器。）一般的熱床 PID 校準命令是：`PID_CALIBRATE HEATER=heater_bed TARGET= 60`

## 下一步

本指南旨在幫助對 Klipper 配置檔案中的引腳設定進行基本驗證。 請務必閱讀 [床位調平](Bed_Level.md) 指南。 另請參閱 [Slicers](Slicers.md) 文件，瞭解有關使用 Klipper 配置切片器的資訊。

在驗證基本列印工作后，最好考慮校準 [壓力提前](Pressure_Advance.md)。

可能需要執行其他型別的詳細印表機校準 - 網路上提供了許多指南來幫助解決此問題（例如，在網路上搜索「3d 印表機校準」）。 例如，如果您遇到稱為振鈴的效果，您可以嘗試遵循 [共振補償](Resonance_Compensation.md) 調諧指南。
