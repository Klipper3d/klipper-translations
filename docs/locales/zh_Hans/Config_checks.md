# 配置检查

本文档提供了一系列帮助验证 Klipper printer.cfg 文件中的引脚设置的步骤。推荐在完成[安装文档](Installation.md) 中的步骤后执行本文档中的步骤。

在执行此指南的过程中，可能需要修改 Klipper 的配置文件。请务必在每次修改配置文件后发送 RESTART 命令，以确保修改成功生效（在 Octoprint 终端标签中输入 "RESTART"（重启），然后点击 "Send"（发送））。在每次重启之后最好再发出一次 STATUS （状态）命令，以验证配置文件是否成功加载。

## 验证温度

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## 验证 M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## 验证加热器

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

如果打印机带有热床，则用热床重复上述测试。

## 验证步进电机 enable（启用）引脚

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## 验证限位开关

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

如果限位状态根本没有变化，则通常表示限位器连接到不同的引脚。 但是，它也可能表示需要更改引脚的上拉设置（endstop_pin 名称开头的“^” - 大多数打印机需要使用上拉电阻并且应该存在“^”）。

## 验证步进电机

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

如果步进电机根本不动，则需要验证步进驱动的“enable_pin”和“step_pin”设置。 如果步进电机移动但没有返回其原始位置，则需要验证“dir_pin”设置。 如果步进电机的振荡方向不正确，则通常表示需要反转驱动的“dir_pin”。 即通过添加“!” 到打印机配置文件中的“dir_pin”设置来完成（如果已经存在"!"，则将其删除）。 如果电机移动明显大于或小于一毫米，则需要验证“rotation_distance”设置。

对配置文件中定义的每个步进电机运行上述测试。 （将 STEPPER_BUZZ 命令的 STEPPER 参数设置为要测试的配置部分的名称。）如果挤出机中没有耗材，也可以使用 STEPPER_BUZZ 验证挤出机电机的接线（使用 STEPPER=extruder）。 否则，最好单独测试挤出机电机（参见下一节）。

在验证完所有限位器和所有步进电机后，应测试归位机制。 发出 G28 命令以归位所有轴。 如果打印机不能正常归位，请断开打印机电源。 然后，重新执行限位器和步进电机验证流程。

## 验证挤出机电机

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## 校准 PID 设置

Klipper支持挤出机和热床加热器的[PID控制](https://en.wikipedia.org/wiki/PID_controller)。为了使用这种控制机制，必须对每台打印机的 PID 参数进行校准（在其他固件或示例配置文件中找到的 PID 设置往往效果不佳）。

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

调整测试完成后，运行 `SAVE_CONFIG` 以保存新PID设置到printer.cfg文件。

如果打印机有加热床，并且支持PWM（脉宽调制）驱动，那么建议对加热床使用PID控制。 （当使用 PID 算法控制床加热器时，它可能每秒打开和关闭十次，这可能不适用于使用机械开关的加热器。）一般的热床 PID 校准命令是：`PID_CALIBRATE HEATER=heater_bed TARGET=60`

## 下一步

本指南旨在帮助对 Klipper 配置文件中的引脚设置进行基本验证。 请务必阅读 [床位调平](Bed_Level.md) 指南。 另请参阅 [切片软件](Slicers.md) 文档，了解有关使用 Klipper 配置切片软件的信息。

在验证基本打印工作后，最好考虑校准 [压力提前](Pressure_Advance.md)。

可能需要执行其他类型的详细打印机校准 - 网络上提供了许多指南来帮助解决此问题（例如，在网络上搜索“3d 打印机校准”）。 例如，如果您遇到称为振铃的效果，您可以尝试遵循 [共振补偿](Resonance_Compensation.md) 调谐指南。
