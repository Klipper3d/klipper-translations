# RPi 微控制器

這個文件描述了在RPi上執行Klipper的過程，並使用相同的RPi作為輔助MCU。

## 為什麼使用RPi作為輔助MCU？

通常情況下，專門用於控制3D印表機的MCU有有限的、預先配置好的引腳來管理主要的列印功能（熱敏電阻、擠出機、步進器...）。使用安裝了Klipper的RPi作為輔助MCU，可以直接使用klipper內的GPIO和RPi的匯流排（i2c，spi），而不需要使用Octoprint外掛（如果使用的話）或外部程式，從而能夠控制列印GCODE內的一切。

**警告**。如果你的平臺是*Beaglebone*，並且你已經正確地按照安裝步驟進行了安裝，那麼linux mcu已經為你的系統安裝和配置了。

## 安裝 rc 指令碼

如果你想把主機作為一個輔助MCU，klipper_mcu程序必須在klippy程序之前執行。

安裝 Klipper 后，執行以下命令來安裝指令碼：

```
cd ~/klipper/
sudo cp "./scripts/klipper-mcu-start.sh" /etc/init.d/klipper_mcu
sudo update-rc.d klipper_mcu defaults
```

## 構建微控制器程式碼

要編譯的 Klipper 微控制器程式碼，需要先將編譯配置設定為「Linux Process」：

```
cd ~/klipper/
make menuconfig
```

在菜單中，設定「Microcontroller Archetecture」（微控制器架構）為「Linux Process」（Linux 程序），然後儲存(save)並退出(exit)。

要構建和安裝新的微控制器程式碼，請執行：

```
sudo service klipper stop
make flash
sudo service klipper start
```

如果klippy.log在試圖連線到`/tmp/klipper_host_mcu`時輸出 "Permission denied" 錯誤，那麼你需要將你的使用者新增到tty使用者組。下面的命令將把 "pi "使用者新增到tty使用者組中：

```
sudo usermod -a -G tty pi
```

## 剩餘的配置

按照[RaspberryPi 參考配置](../config/sample-raspberry-pi.cfg)和[多微控制器參考配置](../config/sample-multi-mcu.cfg)中的說明配置Klipper 二級微控制器來完成安裝。

## 可選：啟用 SPI

通過執行`sudo raspi-config` 后的 "Interfacing options"菜單中啟用 SPI 以確保Linux SPI 驅動已啟用。

## 可選步驟：識別正確的 gpiochip

在樹莓派和許多克隆上，暴露在 GPIO 上的引腳屬於第一個 gpiochip。因此，它們只需用`gpio0...n`的名字來引用就可以在 Klipper 上直接使用。然而，在有些情況下，暴露的引腳不屬於第一個 gpiochip。例如，在使用一些 OrangePi 型號時或者使用了埠擴充套件器。在這些情況下，使用命令訪問 *Linux GPIO character device* 來驗證實際配置。

要在基於 Debian 的發行版（如 OctoPi）上安裝 *Linux GPIO character device - binary*，請執行：

```
sudo apt-get install gpiod
```

要檢查可用的gpiochip，請執行：

```
gpiodetect
```

要檢查針腳編號和針腳可用性，請執行：

```
gpioinfo
```

因此，所選引腳可以在配置中可以通過 `gpiochip<n>/gpio<o>`引用，其中 **n** 是由 `gpiodetect` 命令看到的晶片編號**o** 是 ` gpioinfo` 命令看到的行號。

***警告：***只有標記為`unused`的 gpio 才可以被使用。一條*線路*不可能被多個程序同時使用。

例如，在樹莓派 3B+上 將GPIO20作為 Klipper 的一個開關：

```
$ gpiodetect
gpiochip0 [pinctrl-bcm2835] (54 lines)
gpiochip1 [raspberrypi-exp-gpio] (8 lines)

$ gpioinfo
gpiochip0 - 54 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       unused   input  active-high
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
        line   8:      unnamed       unused   input  active-high
        line   9:      unnamed       unused   input  active-high
        line  10:      unnamed       unused   input  active-high
        line  11:      unnamed       unused   input  active-high
        line  12:      unnamed       unused   input  active-high
        line  13:      unnamed       unused   input  active-high
        line  14:      unnamed       unused   input  active-high
        line  15:      unnamed       unused   input  active-high
        line  16:      unnamed       unused   input  active-high
        line  17:      unnamed       unused   input  active-high
        line  18:      unnamed       unused   input  active-high
        line  19:      unnamed       unused   input  active-high
        line  20:      unnamed    "klipper"  output  active-high [used]
        line  21:      unnamed       unused   input  active-high
        line  22:      unnamed       unused   input  active-high
        line  23:      unnamed       unused   input  active-high
        line  24:      unnamed       unused   input  active-high
        line  25:      unnamed       unused   input  active-high
        line  26:      unnamed       unused   input  active-high
        line  27:      unnamed       unused   input  active-high
        line  28:      unnamed       unused   input  active-high
        line  29:      unnamed       "led0"  output  active-high [used]
        line  30:      unnamed       unused   input  active-high
        line  31:      unnamed       unused   input  active-high
        line  32:      unnamed       unused   input  active-high
        line  33:      unnamed       unused   input  active-high
        line  34:      unnamed       unused   input  active-high
        line  35:      unnamed       unused   input  active-high
        line  36:      unnamed       unused   input  active-high
        line  37:      unnamed       unused   input  active-high
        line  38:      unnamed       unused   input  active-high
        line  39:      unnamed       unused   input  active-high
        line  40:      unnamed       unused   input  active-high
        line  41:      unnamed       unused   input  active-high
        line  42:      unnamed       unused   input  active-high
        line  43:      unnamed       unused   input  active-high
        line  44:      unnamed       unused   input  active-high
        line  45:      unnamed       unused   input  active-high
        line  46:      unnamed       unused   input  active-high
        line  47:      unnamed       unused   input  active-high
        line  48:      unnamed       unused   input  active-high
        line  49:      unnamed       unused   input  active-high
        line  50:      unnamed       unused   input  active-high
        line  51:      unnamed       unused   input  active-high
        line  52:      unnamed       unused   input  active-high
        line  53:      unnamed       unused   input  active-high
gpiochip1 - 8 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       "led1"  output   active-low [used]
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
```

## 可選功能：硬體 PWM

樹莓派有兩個PWM通道（PWM0和PWM1），它們通常暴露在header中上，如果沒有，可以路由到現有的 gpio 引腳。Linux mcu 守護程式使用 pwmchip sysfs 介面來控制 Linux 主機上的硬體 PWM 裝置。pwm sysfs 介面在樹莓上預設是隱藏的，可以通過在`/boot/config.txt`中加入一行設定來啟用：

```
# 啟用 pwmchip sysfs 介面
dtoverlay=pwm,pin=12,func=4
```

此示例僅啟用 PWM0 並將其路由到 gpio12。如果需要同時啟用兩個 PWM 通道，則可以使用 `pwm-2chan`。

overlay 在啟動時不會在 sysfs 上暴露出 PWM 線路，需要通過echo將 PWM 通道的編號導出到 `/sys/class/pwm/pwmchip0/export`：

```
echo 0 > /sys/class/pwm/pwmchip0/export
```

這將在檔案系統中建立裝置`/sys/class/pwm/kwmchip0/pwm0`。最簡單的方法是在`/etc/rc.local`的`exit 0`行之前新增這行。

有了 sysfs，現在可以通過將以下配置新增到 `printer.cfg` 來使用 PWM 通道：

```
[output_pin caselight]
pin: host:pwmchip0/pwm0
pwm: True
hardware_pwm: True
cycle_time: 0.000001
```

這將為樹莓派上的 gpio12 引腳新增硬體 PWM 控制（因為overlay被配置為將 pwm0 路由到 pin=12）。

PWM0 可以被路由到 gpio12 和 gpio18，PWM1 可以被路由到 gpio13 和 gpio19：

| PWM | GPIO 引腳 | 功能 |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
