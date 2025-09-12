# 概述

欢迎来到Klipper文档。如果是初次接触Klipper，请从[功能](Features.md)和[安装](Installation.md)文档开始。

## 概述信息

- [功能](Features.md)：Klipper功能的高级列表。
- [常见问题](FAQ.md)：常见问题解答。
- [版本发布](Releases.md)：Klipper版本发布历史。
- [配置变更](Config_Changes.md)：可能需要用户更新其打印机配置文件的近期软件变更。
- [联系](Contact.md)：关于错误报告以及与Klipper开发者进行一般沟通的信息。

## 安装与配置

- [安装](Installation.md)：安装Klipper的指南。
  - [Octoprint](OctoPrint.md)：安装带有Klipper的Octoprint的指南。
- [配置参考](Config_Reference.md)：配置参数的描述。
  - [旋转距离](Rotation_Distance.md)：计算步进电机的rotation_distance参数。
- [配置检查](Config_checks.md)：验证配置文件中的基本引脚设置。
- [调平](Bed_Level.md)：关于Klipper中“床面调平”的信息。
  - [Delta校准](Delta_Calibrate.md)：Delta运动学的校准。
  - [探针校准](Probe_Calibrate.md)：自动Z探针的校准。
  - [BL-Touch](BLTouch.md)：配置“BL-Touch”Z探针。
  - [手动调平](Manual_Level.md)：Z限位开关（及类似装置）的校准。
  - [网格调平](Bed_Mesh.md)：基于XY位置的床面高度校正。
  - [限位相位](Endstop_Phase.md)：步进电机辅助的Z限位定位。
  - [轴扭曲补偿](Axis_Twist_Compensation.md)：用于补偿因X横梁扭曲而导致探针读数不准确的工具。
- [共振补偿](Resonance_Compensation.md)：减少打印中振纹的工具。
  - [测量共振](Measuring_Resonances.md)：使用adxl345加速度计硬件测量共振的信息。
- [压力提前](Pressure_Advance.md)：校准挤出机压力。
- [G代码](G-Codes.md)：Klipper支持的命令信息。
- [命令模板](Command_Templates.md)：G代码宏和条件求值。
  - [状态参考](Status_Reference.md)：宏（及类似功能）可用的信息。
- [TMC驱动](TMC_Drivers.md)：在Klipper中使用Trinamic步进电机驱动器。
- [多MCU回零](Multi_MCU_Homing.md)：使用多个微控制器进行回零和探测。
- [切片软件](Slicers.md)：为Klipper配置“切片软件”。
- [斜度校正](Skew_Correction.md)：对不完全垂直的轴进行调整。
- [PWM工具](Using_PWM_Tools.md)：如何使用PWM控制工具（如激光或主轴）的指南。
- [排除对象](Exclude_Object.md)：排除对象功能的指南。

## 开发者文档

- [代码概述](Code_Overview.md)：开发者应首先阅读此文档。
- [运动学](Kinematics.md)：Klipper实现运动的技术细节。
- [协议](Protocol.md)：主机与微控制器之间底层消息协议的信息。
- [API服务器](API_Server.md)：Klipper命令与控制API的信息。
- [MCU命令](MCU_Commands.md)：微控制器软件中实现的底层命令描述。
- [CAN总线协议](CANBUS_protocol.md)：Klipper CAN总线消息格式。
- [调试](Debugging.md)：如何测试和调试Klipper的信息。
- [基准测试](Benchmarks.md)：Klipper基准测试方法的信息。
- [贡献](CONTRIBUTING.md)：如何向Klipper提交改进的信息。
- [打包](Packaging.md)：构建操作系统包的信息。

## 特定设备文档

- [示例配置](Example_Configs.md)：向Klipper添加示例配置文件的信息。
- [SD卡更新](SDCard_Updates.md)：通过将二进制文件复制到微控制器的SD卡来刷写微控制器。
- [树莓派作为微控制器](RPi_microcontroller.md)：控制连接到树莓派GPIO引脚设备的详细信息。
- [Beaglebone](Beaglebone.md)：在Beaglebone PRU上运行Klipper的详细信息。
- [引导加载程序](Bootloaders.md)：微控制器刷写相关的开发者信息。
- [引导加载程序入口](Bootloader_Entry.md)：请求进入引导加载程序。
- [CAN总线](CANBUS.md)：在Klipper中使用CAN总线的信息。
  - [CAN总线故障排除](CANBUS_Troubleshooting.md)：CAN总线故障排除技巧。
- [TSL1401CL耗材宽度传感器](TSL1401CL_Filament_Width_Sensor.md)
- [霍尔效应耗材宽度传感器](Hall_Filament_Width_Sensor.md)
- [涡流电感探头](Eddy_Probe.md)
- [称重传感器](Load_Cell.md)