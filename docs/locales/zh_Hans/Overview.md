# 概述

欢迎使用Klipper文档。如果刚接触Klipper，请从[特性](features.md)和[安装](installation.md)文档开始阅读。

## 概览信息

- [功能](Features.md)：Klipper 中的高级功能列表。
- [常见问题](FAQ.md)：常见问题。
- [发行版](Release.md)：Klipper 的版本发布历史。
- [配置更改](Config_Changes.md)：可能需要手动更新打印机配置文件的软件更改。
- [联系](Contact.md)：关于如何提交错误报告和联系 Klipper 开发者的信息。

## 安装和配置

- [安装](Installation.md)：Klipper 安装指南。
   - [Octoprint](OctoPrint.md): OctoPrint 安装 Klipper 指南。
- [配置参考](Config_Reference.md)：配置参数说明。
   - [旋转距离](Rotation_Distance.md)：计算旋转距离(rotation_distance)步进参数。
- [检查配置](Config_checks.md)：验证配置文件中的基本引脚设置。
- [打印床调平](Bed_Level.md)：Klipper 中关于“打印床调平”的信息。
   - [三角洲校准](Delta_Calibrate.md)：校准三角洲结构。
   - [探针校准](Probe_Calibrate.md)：校准自动Z探针。
   - [BL-Touch](BLTouch.md)：配置“BL-Touch”Z 探针。
   - [手动调平](Manual_Level.md)：校准 Z 限位和调整热床调平螺丝。
   - [床网](Bed_Mesh.md)：基于 XY 位置的打印床高度补偿。
   - [限位相位](Endstop_Phase.md)：使用步进电机相位辅助 Z 限位定位。
   - [Axis Twist Compensation](Axis_Twist_Compensation.md): 用于补偿X轴装配问题导致的探针读数异常。
- [共振补偿](Resonance_Compensation.md)：减少打印震纹的工具。
   - [测量共振](Measuring_Resonances.md)：使用 adxl345 加速度计模块测量共振。
- [压力提前](Pressure_Advance.md)：校准挤出机压力。
- [G代码](G-Codes.md)：用于 Klipper 的G代码命令。
- [命令模板](Command_Templates.md)：G代码宏和条件判断。
   - [状态参考](Status_Reference.md)：可用于宏和类似功能的信息。
- [TMC驱动](TMC_Drivers.md)：在 Klipper 中使用 Trinamic 步进电机驱动。
- [Multi-MCU Homing](Multi_MCU_Homing.md)：在归位和探测时使用多个微处理器。
- [切片](Slicers.md)：为 Klipper 配置切片软件。
- [偏斜校正](Skew_Correction.md)：调整不完全垂直的轴（不完美的方形）。
- [PWM 工具](Using_PWM_Tools.md)：关于如何使用 PWM 控制的工具，例如激光器或电钻头。
- [排除对象](Exclude_Object.md)：排除对象实现的指南。

## 开发者文档

- [代码概述](Code_Overview.md)：开发者应该从这个文档开始阅读。
- [运动学](Kinematics.md)：关于 Klipper 如何实现运动的技术细节。
- [协议](Protocol.md)：主机和微控制器之间的低级通信协议的信息。
- [API 服务器](API_Server.md)：关于 Klipper 的命令与控制 API 的信息。
- [MCU 指令](MCU_Commands.md)：描述在微控制器软件中实现的低级指令。
- [CAN 总线协议](CANBUS_protocol.md)：Klipper 的 CAN总线报文格式。
- [调试](Debugging.md)：关于如何测试和调试 Klipper。
- [基准测试](Benchmarks.md)：关于 Klipper 基准测试的方法。
- [贡献](CONTRIBUTING.md)：有关如何向 Klipper 提交改进方法的信息。
- [打包](Packaging.md)：有关于如何构建系统包的信息。

## 设备特定文档

- [示列配置](Example_Configs.md)：有关于添加示列配置到 Klipper 的信息。
- [SD卡更新](SDCard_Updates.md)：通过将固件拷贝到SD卡中，再通过微控制器的SD卡槽来刷写微控制器。
- [将树莓派作为微控制器](RPi_microcontroller.md)：关于如何控制与树莓派 GPIO 引脚连接的设备。
- [Beaglebone](Beaglebone.md)：在 Beaglebone PRU 上运行 Klipper 的详细信息。
- [底层引导程序](Bootloaders.md)：有关于微控制器刷写的开发者信息。
- [进入 Bootloader](Bootloader_Entry.md): 调用引导加载程序。
- [CAN 总线](CANBUS.md)：有关于 Klipper 使用 CAN 总线的信息。
   - [CAN bus 故障排除](CANBUS_Troubleshooting.md): CAN bus的故障排除指南。
- [TSL1401CL 耗材线径传感器](TSL1401CL_Filament_Width_Sensor.md)
- [霍尔耗材宽度传感器](Hall_Filament_Width_Sensor.md)
- [Eddy 涡流感应探针](Eddy_Probe.md)
- [Load Cells](Load_Cell.md)
