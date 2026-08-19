# 使用 PWM 工具

This document describes how to setup a PWM-controlled laser or spindle using `pwm_tool` and some macros.

## 它如何運作？

通過重用列印頭模型風扇(part fan)的PWM輸出訊號，我們可以實現對鐳射頭或轉軸的控制。對使用可更換列印頭的裝置，如E3D toolchanger 或其他DIY專案，這是十分有用的功能。通常，cam軟體，例如LaserWeb，會使用`M3-M5`命令，它們分別是 主軸順時針轉速*spindle speed CW* (`M3 S[0-255]`)， 主軸逆時針轉速*spindle speed CCW* (`M4 S[0-255]`) 和轉軸停止 *spindle stop* (`M5`)。

**警告：** 在驅動鐳射器時，應採用一切可能的預防措施。二極管鐳射一般是使用反訊號的，即當微控制器重啟時，鐳射將會*全功率輸出*，直至微處理器恢復正常運作。 慎重而言，建議在鐳射器上電期間*始終*佩戴合適波長的護目鏡；並在不使用鐳射時對鐳射器斷電。同時，應該為鐳射器設定安全定時，保證在上位機和微控制器發生錯誤時，鐳射器能自動停止。

有關示例配置，請參閱 [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg)。

## 命令

`M3/M4 S<值>` ：設定 PWM 占空比。占空比數值應在0和255之間。 `M5` : 停止 PWM 訊號輸出。

## LaserWeb 端配置

如果你使用的是 LaserWeb 軟體，一個可用的配置為：

    GCODE START: 啟動 G 程式碼
        M5            ; 停用鐳射
        G21           ; 使用mm作為單位
        G90           ; 使用絕對座標
        G0 Z0 F7000   ; 設定空走速度
    
    GCODE END: 結束 G 程式碼
        M5            ; 停用鐳射
        G91           ; 使用相對座標
        G0 Z+20 F4000 ;
        G90           ; 使用絕對座標
    
    GCODE HOMING: 歸零 G 程式碼
        M5            ; 停用鐳射
        G28           ; 全軸歸零
    
    TOOL ON: 開啟工具
        M3 $INTENSITY
    
    TOOL OFF: 關閉工具
        M5            ; 停用鐳射
    
    LASER INTENSITY: 鐳射強度
        S
