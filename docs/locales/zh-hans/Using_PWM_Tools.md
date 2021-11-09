# 使用 PWM 工具

该文档介绍如何配置 `output_pin` 和宏命令以实现使用 PWM 信号对激光器或主轴进行控制。

## 它如何运作？

通过重用打印头模型风扇(part fan)的PWM输出信号，我们可以实现对激光头或转轴的控制。对使用可更换打印头的设备，如E3D toolchanger 或其他DIY项目，这是十分有用的功能。通常，cam软件，例如LaserWeb，会使用`M3-M5`命令，它们分别是 主轴顺时针转速*spindle speed CW* (`M3 S[0-255]`)， 主轴逆时针转速*spindle speed CCW* (`M4 S[0-255]`) 和转轴停止 *spindle stop* (`M5`)。

**警告：** 在驱动激光器时，应采用一切可能的预防措施。二极管激光一般是使用反信号的，即当微控制器重启时，激光将会*全功率输出*，直至微处理器恢复正常运作。 慎重而言，建议在激光器上电期间*始终*佩戴合适波长的护目镜；并在不使用激光时对激光器断电。同时，应该为激光器设置安全定时，保证在上位机和微控制器发生错误时，激光器能自动停止。

有关示例配置，请参阅 [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg)。

## 电流限制

PWM脉冲发生的频率存在上限。尽管相当精确，但每隔0.1秒才能生成一个PWM脉冲，因而几乎无法用作光栅蚀刻。相对地，可使用以下[测试分支](https://github.com/Cirromulus/klipper/tree/laser_tool) 。它与主分支各有考量。长期计划中将上述功能加入到 Klipper 的主分支中。

## 命令

`M3/M4 S<值>` ：设置 PWM 占空比。占空比数值应在0和255之间。 `M5` : 停止 PWM 信号输出。

## LaserWeb 端配置

如果你使用的是 LaserWeb 软件，一个可用的配置为：

    GCODE START: 启动 G 代码
        M5            ; 停用激光
        G21           ; 使用mm作为单位
        G90           ; 使用绝对坐标
        G0 Z0 F7000   ; 设置空走速度
    
    GCODE END: 结束 G 代码
        M5            ; 停用激光
        G91           ; 使用相对坐标
        G0 Z+20 F4000 ;
        G90           ; 使用绝对坐标
    
    GCODE HOMING: 归零 G 代码
        M5            ; 停用激光
        G28           ; 全轴归零
    
    TOOL ON: 开启工具
        M3 $INTENSITY
    
    TOOL OFF: 关闭工具
        M5            ; 停用激光
    
    LASER INTENSITY: 激光强度
        S
