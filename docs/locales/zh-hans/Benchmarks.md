# 基准测试

这个文档解释了Klipper的基准测试

## 微控制器（Micro-controller）基准测试

本节描述了用于生成 Klipper 微控制器步进率（step rate）基准的机制。

Benchmarks的主要目标是提供一个一致的机制来衡量软件内编码变化的影响。次要目标是为比较芯片之间和软件平台之间的性能提供高水平的指标。

步进率(stepping rate)基准是为了找到硬件和软件可以达到的最大步进率。这个基准步进率在日常使用中是无法实现的，因为Klipper在任何实际使用中都需要执行其他任务（例如，MCU/主机通信、温度读取、限位检查）。

一般而言，基准测试的引脚被选择用于闪烁 LED 或其他安全引脚。 ** 在运行基准测试之前，始终验证驱动配置的引脚是安全的。** 不建议在基准测试期间驱动实际的步进器。

### 步进率基准测试

测试是使用console.py工具进行的（在<Debugging.md>中描述）。为特定的硬件平台配置微控制器（见下文），然后将以下内容剪切并粘贴到console.py终端窗口:

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

以上测试三个步进器同时步进。如果运行上述程序的结果是 "重新安排定时器在过去 "或 "步进器在过去太远 "的错误，则表明`ticks`参数太低（它导致步进速度太快）。我们的目标是找到能够可靠地导致成功完成测试的最低的ticks参数设置。应该可以将ticks参数一分为二，直到找到一个稳定的值。

在失败的情况下，可以复制和粘贴以下内容来清除错误，为下一次测试做准备。

```
clear_shutdown
```

为了获得单步和双步基准，使用相同的配置序列，但只将上述测试的第一个块（对于单步情况）或前两个块（对于双步情况）剪切并粘贴到console.py窗口。

为了产生Feature.md文件中的基准测试，每秒的总步数是通过将有源步进器的数量与标称的MCU频率相乘并除以最终的ticks参数来计算的。结果被四舍五入到最接近的K。例如，有三个激活的步进电机。

```
ECHO Test result is: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

可以使用 "步进脉冲持续时间 "为零的微控制器代码来运行基准测试（下面的表格将其报告为 "无延迟"）。这种配置被认为在实际使用中是有效的，当人们只使用Trinamic步进驱动器时。这些基准测试的结果没有在Feature.md文件中报告。

### AVR步进率基准测试

在AVR芯片上使用以下配置序列：

```
PINS arduino
allocate_oids count=3
config_stepper oid=0 step_pin=ar29 dir_pin=ar28 invert_step=0
config_stepper oid=1 step_pin=ar27 dir_pin=ar26 invert_step=0
config_stepper oid=2 step_pin=ar23 dir_pin=ar22 invert_step=0
finalize_config crc=0
```

测试最后在提交 `01d2183f` 上运行，gcc 版本为 `avr-gcc (GCC) 5.4.0`。 16Mhz 和 20Mhz 测试都是使用为 atmega644p 配置的 simulavr 运行的（之前的测试已经确认了 16Mhz at90usb 和 16Mhz atmega2560 上的 simulavr 结果匹配测试）。

| avr | ticks |
| --- | --- |
| 1 stepper | 104 |
| 2 stepper | 296 |
| 3 stepper | 472 |

### Arduino Due 的步速率基准测试

以下是在Due上使用的配置序列。

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=0
finalize_config crc=0
```

测试最后在提交 `8d4a5c16` 上运行，gcc 版本为 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0`。

| sam3x8e | ticks |
| --- | --- |
| 1 stepper | 388 |
| 2 stepper | 405 |
| 3 stepper | 576 |
| 1 stepper (无延迟) | 77 |
| 3 stepper (无延迟) | 299 |

### Duet Maestro 步进率基准测试

在Duet Maestro上使用以下配置序列。

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=0
finalize_config crc=0
```

测试最后在提交 `8d4a5c16` 上运行，gcc 版本为 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0`。

| sam4s8c | ticks |
| --- | --- |
| 1 stepper | 527 |
| 2 stepper | 535 |
| 3 stepper | 638 |
| 1 stepper (无延迟) | 70 |
| 3 stepper (无延迟) | 254 |

### Duet Wifi 步进率基准测试

在Duet Wifi上使用以下配置序列。

```
allocate_oids count=4
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=0
config_stepper oid=3 step_pin=PD5 dir_pin=PA1 invert_step=0
finalize_config crc=0
```

测试最后在提交 `59a60d68` gcc 版本`arm-none-eabi-gcc 7.3.1 20180622 (release) [ARM/embedded-7-branch revision 261907]`.

| sam4e8e | ticks |
| --- | --- |
| 1 stepper | 519 |
| 2 stepper | 520 |
| 3 stepper | 525 |
| 4 stepper | 703 |

### Beaglebone PRU 步进率基准测试

在PRU上使用以下配置序列：

```
PINS beaglebone
allocate_oids count=3
config_stepper oid=0 step_pin=P8_13 dir_pin=P8_12 invert_step=0
config_stepper oid=1 step_pin=P8_15 dir_pin=P8_14 invert_step=0
config_stepper oid=2 step_pin=P8_19 dir_pin=P8_18 invert_step=0
finalize_config crc=0
```

测试最后在提交 `b161a69e` 上运行，gcc 版本为 `pru-gcc (GCC) 8.0.0 20170530 (experimental)`。

| pru | ticks |
| --- | --- |
| 1 stepper | 861 |
| 2 stepper | 853 |
| 3 stepper | 883 |

### STM32F042 步进率基准测试

在STM32F042上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=0
finalize_config crc=0
```

测试最后在提交 `0b0c47c5` 上运行，gcc 版本为 `arm-none-eabi-gcc (Fedora 9.2.0-1.fc30) 9.2.0`。

| stm32f042 | ticks |
| --- | --- |
| 1 stepper | 247 |
| 2 stepper | 328 |
| 3 stepper | 558 |

### STM32F103 步速率基准测试

在STM32F103上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=0
finalize_config crc=0
```

测试最后在提交 `8d4a5c16` 上运行，gcc 版本为 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0`。

| stm32f103 | ticks |
| --- | --- |
| 1 stepper | 347 |
| 2 stepper | 372 |
| 3 stepper | 600 |
| 1 stepper (无延迟) | 71 |
| 3 stepper (无延迟) | 288 |

### STM32F4 步进率基准测试

在STM32F4上使用以下配置序列：

```
allocate_oids count=4
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=0
config_stepper oid=3 step_pin=PB3 dir_pin=PB8 invert_step=0
finalize_config crc=0
```

测试最后在提交 `8d4a5c16` 上运行，gcc 版本为 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0`。 STM32F407 结果是通过在 STM32F446 上运行 STM32F407 二进制文件获得的（因此使用 168Mhz 时钟）。

| stm32f446 | ticks |
| --- | --- |
| 1 stepper | 757 |
| 2 stepper | 761 |
| 3 stepper | 757 |
| 4 stepper | 767 |
| 1 stepper (无延迟) | 51 |
| 3 stepper (无延迟) | 226 |

| stm32f407 | ticks |
| --- | --- |
| 1 stepper | 709 |
| 2 stepper | 714 |
| 3 stepper | 709 |
| 4 stepper | 729 |
| 1 stepper (无延迟) | 52 |
| 3 stepper (无延迟) | 226 |

### LPC176x 步进率基准测试

在LPC176x上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=0
finalize_config crc=0
```

测试最后在提交 `8d4a5c16` 上运行，gcc 版本为 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0`。 120Mhz LPC1769 结果是通过将 LPC1768 超频到 120Mhz 获得的。

| lpc1768 | ticks |
| --- | --- |
| 1 stepper | 448 |
| 2 stepper | 450 |
| 3 stepper | 523 |
| 1 stepper (无延迟) | 56 |
| 3 stepper (无延迟) | 240 |

| lpc1769 | ticks |
| --- | --- |
| 1 stepper | 525 |
| 2 stepper | 526 |
| 3 stepper | 545 |
| 1 stepper (无延迟) | 56 |
| 3 stepper (无延迟) | 240 |

### SAMD21 步速率基准测试

在SAMD21上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=0
finalize_config crc=0
```

该测试最后在提交`8d4a5c16`上运行，gcc版本为`arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0`，在SAMD21G18微控制器上。

| SAMD21 | ticks |
| --- | --- |
| 1 stepper | 277 |
| 2 stepper | 410 |
| 3 stepper | 664 |
| 1 stepper (无延迟) | 83 |
| 3 stepper (无延迟) | 321 |

### SAMD51 步速率基准测试

在SAMD51上使用以下配置序列：

```
allocate_oids count=5
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=0
config_stepper oid=3 step_pin=PA22 dir_pin=PA18 invert_step=0
config_stepper oid=4 step_pin=PA23 dir_pin=PA17 invert_step=0
finalize_config crc=0
```

该测试最后在提交`524ebbc7`上运行，gcc版本为`arm-none-eabi-gcc (Fedora 9.2.0-1.fc30) 9.2.0`，在SAMD51J19A微控制器上。

| SAMD51 | ticks |
| --- | --- |
| 1 stepper | 516 |
| 2 stepper | 520 |
| 3 stepper | 520 |
| 4 stepper | 631 |
| 1 stepper (200Mhz) | 839 |
| 2 stepper (200Mhz) | 838 |
| 3 stepper (200Mhz) | 838 |
| 4 stepper (200Mhz) | 838 |
| 5 stepper (200Mhz) | 891 |
| 1 stepper (无延迟) | 42 |
| 3 stepper (无延迟) | 194 |

### RP2040 步速率基准测试

RP2040 上使用以下配置序列：

```
allocate_oids count=4
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=0
config_stepper oid=3 step_pin=gpio28 dir_pin=gpio6 invert_step=0
finalize_config crc=0
```

该测试最后是在提交`c5667193`上运行的，gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`，在Raspberry Pi Pico板上。

| rp2040 | ticks |
| --- | --- |
| 1 stepper | 52 |
| 2 stepper | 52 |
| 3 stepper | 52 |
| 4 stepper | 66 |
| 1 stepper (无延迟) | 5 |
| 3 stepper (无延迟) | 22 |

### Linux MCU 步速率基准测试

树莓派上使用以下配置序列：

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio7 invert_step=0
finalize_config crc=0
```

该测试最后是在提交`db0fb5d5`上运行的，gcc版本为`gcc（Raspbian 6.3.0-18+rpi1+deb9u1）6.3.0 20170516`，在Raspberry Pi 3（revision a22082）。

| Linux (RPi3) | ticks |
| --- | --- |
| 1 stepper | 349 |
| 2 stepper | 350 |
| 3 stepper | 400 |

## Command dispatch 基准测试

命令调度基准测试微控制器可以处理多少个 "dummy"命令。它主要是对硬件通信机制的测试。该测试使用console.py工具（在<Debugging.md>中描述）运行。以下是剪切并粘贴到console.py终端窗口的内容:

```
DELAY {clock + 2*freq} get_uptime
FLOOD 100000 0.0 debug_nop
get_uptime
```

当测试完成后，确定两个 "正常运行时间 "响应信息中报告的时钟之间的差异。然后，每秒钟的总命令数是`100000 * mcu_frequency / clock_diff`。

注意，这个测试可能会使Raspberry Pi的USB/CPU容量达到饱和。如果在Raspberry Pi、Beaglebone或类似的主机上运行，那么要增加延迟（例如，`DELAY {clock + 20*freq} get_uptime`）。在适用的情况下，下面的基准是用控制台.py在桌面类机器上运行，设备通过高速集线器连接。

| MCU | Rate | Build | Build compiler |
| --- | --- | --- | --- |
| stm32f042 (CAN) | 18K | c105adc8 | arm-none-eabi-gcc (GNU Tools 7-2018-q3-update) 7.3.1 |
| atmega2560 (串行总线) | 23K | b161a69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (串行总线) | 23K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| at90usb1286 (USB) | 75K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| samd21 (USB) | 223K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| PRU（共享内存） | 260K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (experimental) |
| stm32f103 (USB) | 355K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB) | 534K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB) | 628K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB) | 870K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 873K | c5667193 | arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0 |

## Host 基准测试

可以使用“批处理模式”处理机制（在 <Debugging.md> 中描述）在主机软件上运行时序测试。这通常是通过选择一个大而复杂的 G 代码文件并计时主机软件处理它所需的时间来完成的。例如：

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
