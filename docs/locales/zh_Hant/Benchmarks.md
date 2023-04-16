# 基準測試

這個文件解釋了Klipper的基準測試。

## 微控制器（Micro-controller）基準測試

本節描述了用於產生 Klipper 微控制器步進率（step rate）基準的機制。

基準的主要目標是提供一個一致的機制，用於測量軟體中編碼更改的影響。次要目標是提供高級別指標，用於比較晶片和軟件平臺之間的效能。

步進率(stepping rate)基準是爲了找到硬體和軟體可以達到的最大步進率。這個基準步進率在日常使用中是無法實現的，因為Klipper在任何實際使用中都需要執行其他任務（例如，MCU/主機通訊、溫度讀取、限位檢查）。

一般而言，基準測試的引腳被選擇用於閃爍 LED 或其他安全引腳。 ** 在執行基準測試之前，始終驗證驅動配置的引腳是安全的。** 不建議在基準測試期間驅動實際的步進器。

### 步進率基準測試

測試是使用console.py工具進行的（在<Debugging.md>中描述）。為特定的硬件平臺配置微控制器（見下文），然後將以下內容剪下並貼上到console.py終端視窗:

```
SET start_clock {clock+freq}
SET ticks 1000

reset_step_clock oid=0 clock={start_clock}
set_next_step_dir oid=0 dir=0
queue_step oid=0 interval={ticks} count=60000 add=0
set_next_step_dir oid=0 dir=1
queue_step oid=0 interval=3000 count=1 add=0

reset_step_clock oid=1 clock={start_clock}
set_next_step_dir oid=1 dir=0
queue_step oid=1 interval={ticks} count=60000 add=0
set_next_step_dir oid=1 dir=1
queue_step oid=1 interval=3000 count=1 add=0

reset_step_clock oid=2 clock={start_clock}
set_next_step_dir oid=2 dir=0
queue_step oid=2 interval={ticks} count=60000 add=0
set_next_step_dir oid=2 dir=1
queue_step oid=2 interval=3000 count=1 add=0
```

以上測試三個步進器同時步進。如果執行上述程式的結果是 "重新安排定時器在過去 "或 "步進器在過去太遠 "的錯誤，則表明`ticks`參數太低（它導致步進速度太快）。我們的目標是找到能夠可靠地導致成功完成測試的最低的ticks參數設定。應該可以將ticks參數一分為二，直到找到一個穩定的值。

在失敗的情況下，可以複製和貼上以下內容來清除錯誤，為下一次測試做準備：

```
clear_shutdown
```

爲了獲得單一步進電機的基準測試，使用了相同的配置序列，但只將上述測試的第一塊剪下並貼上到 console.py 視窗。

爲了產生 [功能](Features.md) 文件中的基準測試結果，每秒總步數的計算方法是將活動步進器的數量與標稱 mcu 頻率相乘，然後除以最終的 ticks 參數。結果四捨五入到最接近的 K。例如，使用三個活動步進器：

```
ECHO Test result is: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

基準的執行參數必須和 TMC 驅動相匹配。對於支援 `STEPPER_BOTH_EDGE=1` 的微控制器（控制檯啟動時`MCU config`行中會報告）使用 `step_pulse_duration=0` 和 `invert_step=-1` 來啟用步進脈衝的兩邊上的優化。對於其他微控制器，使用對應 100ns 的 `step_pulse_duration`。

### AVR步進率基準測試

在AVR晶片上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
finalize_config crc=0
```

該測試最後一次執行使用了提交 `59314d99` 與 gcc 版本 `avr-gcc （GCC） 5.4.0`。16Mhz 和 20Mhz 測試都使用了按 atmega644p 配置的 simulavr 執行（以前的測試已經確認了16Mhz at90usb 和16Mhz atmega2560 的實際效能與 simulavr 結果相似）。

| avr | ticks |
| --- | --- |
| 1個步進電機 | 102 |
| 3個步進電機 | 486 |

### Arduino Due 的步速率基準測試

以下是在Due上使用的配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

測試最後在提交 `59314d99` 上執行，gcc 版本為 `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| sam3x8e | ticks |
| --- | --- |
| 1個步進電機 | 66 |
| 3個步進電機 | 257 |

### Duet Maestro 步進率基準測試

在Duet Maestro上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

測試最後在提交 `59314d99` 上執行，gcc 版本為 `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| sam4s8c | ticks |
| --- | --- |
| 1個步進電機 | 71 |
| 3個步進電機 | 260 |

### Duet Wifi 步進率基準測試

在Duet Wifi上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

測試最後在提交 `59314d99` 上執行，gcc 版本 `gcc 版本 10.3.1 20210621（發佈版） (GNU Arm Embedded Toolchain 10.3-2021.07)`。

| sam4e8e | ticks |
| --- | --- |
| 1個步進電機 | 48 |
| 3個步進電機 | 215 |

### Beaglebone PRU 步進率基準測試

在PRU上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
finalize_config crc=0
```

測試最後在提交 `59314d99` 上執行，gcc 版本為 `pru-gcc (GCC) 8.0.0 20170530（實驗版）`。

| 可程式設計實時單元 | ticks |
| --- | --- |
| 1個步進電機 | 231 |
| 3個步進電機 | 847 |

### STM32F042 步進率基準測試

在STM32F042上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

測試最後在提交 `59314d99` 上執行，gcc 版本為 `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| stm32f042 | ticks |
| --- | --- |
| 1個步進電機 | 59 |
| 3個步進電機 | 249 |

### STM32F103 步速率基準測試

在STM32F103上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

測試最後在提交 `59314d99` 上執行，gcc 版本為 `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| stm32f103 | ticks |
| --- | --- |
| 1個步進電機 | 61 |
| 3個步進電機 | 264 |

### STM32F4 步進率基準測試

在STM32F4上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

該測試最後一次執行使用了提交`59314d99`，gcc版本`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。STM32F407 的結果是通過在 STM32F446 上執行 STM32F407 二進制檔案得到的（因此時鐘是 168Mhz ）。

| stm32f446 | ticks |
| --- | --- |
| 1個步進電機 | 46 |
| 3個步進電機 | 205 |

| stm32f407 | ticks |
| --- | --- |
| 1個步進電機 | 46 |
| 3個步進電機 | 205 |

### STM32H7 step rate benchmark

The following configuration sequence is used on a STM32H743VIT6:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD4 dir_pin=PD3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA15 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PE2 dir_pin=PE3 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `00191b5c` with gcc version `arm-none-eabi-gcc (15:8-2019-q3-1+b1) 8.3.1 20190703 (release) [gcc-8-branch revision 273027]`.

| stm32h7 | ticks |
| --- | --- |
| 1個步進電機 | 44 |
| 3個步進電機 | 198 |

### STM32G0B1 步速率基準測試

在 STM32G0B1 上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB13 dir_pin=PB12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB10 dir_pin=PB2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB0 dir_pin=PC5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

測試最後在提交 `247cd753` 上執行，gcc 版本為 `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| stm32g0b1 | ticks |
| --- | --- |
| 1個步進電機 | 58 |
| 3個步進電機 | 243 |

### LPC176x 步進率基準測試

在LPC176x上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

該測試最後一次執行使用了提交 `59314d99`，gcc 版本 `arm-none-eabi-gcc （Fedora 10.2.0-4.fc34） 10.2.0`。120Mhz LPC1769 的結果是通過將 LPC1768 超頻到 120Mhz 而獲得的。

| lpc1768 | ticks |
| --- | --- |
| 1個步進電機 | 52 |
| 3個步進電機 | 222 |

| lpc1769 | ticks |
| --- | --- |
| 1個步進電機 | 51 |
| 3個步進電機 | 222 |

### SAMD21 步速率基準測試

在SAMD21上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

該測試最後一次執行使用了提交 `59314d99`，gcc 版本 `arm-none-eabi-gcc （Fedora 10.2.0-4.fc34） 10.2.0` 在 SAMD21G18 微控制器上。

| SAMD21 | ticks |
| --- | --- |
| 1個步進電機 | 70 |
| 3個步進電機 | 306 |

### SAMD51 步速率基準測試

在SAMD51上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

該測試最後一次執行使用了提交 `59314d99` 與 gcc 版本 `arm-none-eabi-gcc （Fedora 10.2.0-4.fc34） 10.2.0` 在 SAMD51J19A 微控制器上執行的。

| SAMD51 | ticks |
| --- | --- |
| 1個步進電機 | 39 |
| 3個步進電機 | 191 |
| 1 stepper (200Mhz) | 39 |
| 3 stepper (200Mhz) | 181 |

### AR100 step rate benchmark

The following configuration sequence is used on AR100 CPU (Allwinner A64):

```
allocate_oids count=3
config_stepper oid=0 step_pin=PL10 dir_pin=PE14 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PL11 dir_pin=PE15 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PL12 dir_pin=PE16 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `08d037c6` with gcc version `or1k-linux-musl-gcc (GCC) 9.2.0` on an Allwinner A64-H micro-controller.

| AR100 R_PIO | ticks |
| --- | --- |
| 1個步進電機 | 85 |
| 3個步進電機 | 359 |

### RP2040 步速率基準測試

RP2040 上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

該測試最後一次在 Raspberry Pi Pico 板上使用 gcc 版本 `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`和提交 `59314d99` 執行。

| rp2040 | ticks |
| --- | --- |
| 1個步進電機 | 5 |
| 3個步進電機 | 22 |

### Linux MCU 步速率基準測試

樹莓派上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
finalize_config crc=0
```

該測試最後一次執行使用了提交 `59314d99` 與 gcc 版本 `gcc （Raspbian 8.3.0-6+rpi1） 8.3.0` 在 Raspberry Pi 3 （修訂版 a02082） 上執行。在這個基準測試中很難獲得穩定的結果。

| Linux (RPi3) | ticks |
| --- | --- |
| 1個步進電機 | 160 |
| 3個步進電機 | 380 |

## Command dispatch 基準測試

命令排程基準測試微控制器可以處理多少個 "dummy"命令。它主要是對硬體通訊機制的測試。該測試使用console.py工具（在<Debugging.md>中描述）執行。以下是剪下並貼上到console.py終端視窗的內容:

```
DELAY {clock + 2*freq} get_uptime
FLOOD 100000 0.0 debug_nop
get_uptime
```

當測試完成後，確定兩個 "正常執行時間 "響應資訊中報告的時鐘之間的差異。然後，每秒鐘的總命令數是`100000 * mcu_frequency / clock_diff`。

注意，這個測試可能會使Raspberry Pi的USB/CPU容量達到飽和。如果在Raspberry Pi、Beaglebone或類似的主機上執行，那麼要增加延遲（例如，`DELAY {clock + 20*freq} get_uptime`）。在適用的情況下，下面的基準是用控制檯.py在桌面類機器上執行，裝置通過高速集線器連線。

| MCU | Rate | Build | Build compiler |
| --- | --- | --- | --- |
| stm32f042 (CAN) | 18K | c105adc8 | arm-none-eabi-gcc (GNU Tools 7-2018-q3-update) 7.3.1 |
| atmega2560 (序列匯流排) | 23K | b161a69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (序列匯流排) | 23K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| at90usb1286 (USB) | 75K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| ar100 (serial) | 138K | 08d037c6 | or1k-linux-musl-gcc 9.3.0 |
| samd21 (USB) | 223K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| PRU（共享記憶體） | 260K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (experimental) |
| stm32f103 (USB) | 355K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB) | 534K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB) | 628K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB) | 870K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 873K | c5667193 | arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0 |

## Host 基準測試

可以使用「批處理模式」處理機制（在 <Debugging.md> 中描述）在主機軟體上執行時序測試。這通常是通過選擇一個大而複雜的 G 程式碼檔案並計時主機軟體處理它所需的時間來完成的。例如：

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
