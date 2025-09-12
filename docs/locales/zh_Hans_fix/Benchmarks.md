# 基准测试

本文档描述了Klipper的基准测试。

## 微控制器基准测试

本节描述用于生成Klipper微控制器步进速率基准测试的机制。

基准测试的主要目标是提供一种一致的机制，用于衡量软件中编码更改的影响。次要目标是为不同芯片和不同软件平台之间的性能比较提供高级指标。

步进速率基准测试旨在找出硬件和软件所能达到的最大步进速率。在日常使用中，此基准测试的步进速率是无法实现的，因为在任何实际使用场景中，Klipper都需要执行其他任务（例如，MCU/主机通信、温度读取、限位开关检查）。

通常，基准测试使用的引脚被选择为闪烁LED或其他无害的引脚。**在运行基准测试之前，务必验证驱动所配置的引脚是安全的。** 不建议在基准测试期间驱动实际的步进电机。

### 步进速率基准测试

测试使用console.py工具（在[Debugging.md](Debugging.md)中描述）进行。微控制器根据特定的硬件平台进行配置（见下文），然后将以下内容剪切并粘贴到console.py终端窗口中：
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

上述测试同时进行三个步进电机的步进。如果运行上述测试导致出现“Rescheduled timer in the past”（计划的定时器在过去）或“Stepper too far in past”（步进器在过去太远）错误，则表明`ticks`参数过低（导致步进速率过快）。目标是找到能够可靠地成功完成测试的最低`ticks`参数值。可以通过二分法调整`ticks`参数直到找到稳定值。

测试失败时，可以复制粘贴以下命令以清除错误，为下一次测试做准备：
```
clear_shutdown
```

要获得单个步进电机的基准测试，使用相同的配置序列，但仅将上述测试的第一块内容剪切并粘贴到console.py窗口中。

为了生成[Features](Features.md)文档中的基准测试结果，总的每秒步数通过活动步进电机数量乘以MCU标称频率再除以最终的`ticks`参数来计算。结果四舍五入到最接近的千位（K）。例如，三个活动的步进电机：
```
ECHO Test result is: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

基准测试使用适合TMC驱动器的参数运行。对于支持`STEPPER_BOTH_EDGE=1`（在console.py启动时“MCU config”行中报告）的微控制器，使用`step_pulse_duration=0`和`invert_step=-1`以在步进脉冲的两个边沿上启用优化步进。对于其他微控制器，使用对应100ns的`step_pulse_duration`。

### AVR步进速率基准测试

在AVR芯片上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`avr-gcc (GCC) 5.4.0`。16MHz和20MHz的测试均使用为atmega644p配置的simulavr运行（先前的测试已确认simulavr结果与16MHz的at90usb和16MHz的atmega2560上的测试结果一致）。

| avr              | ticks |
| ---------------- | ----- |
| 1 stepper        | 102   |
| 3 stepper        | 486   |

### Arduino Due步进速率基准测试

在Due上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| sam3x8e              | ticks |
| -------------------- | ----- |
| 1 stepper            | 66    |
| 3 stepper            | 257   |

### Duet Maestro步进速率基准测试

在Duet Maestro上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| sam4s8c              | ticks |
| -------------------- | ----- |
| 1 stepper            | 71    |
| 3 stepper            | 260   |

### Duet Wifi步进速率基准测试

在Duet Wifi上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`gcc version 10.3.1 20210621 (release) (GNU Arm Embedded Toolchain 10.3-2021.07)`。

| sam4e8e          | ticks |
| ---------------- | ----- |
| 1 stepper        | 48    |
| 3 stepper        | 215   |

### Beaglebone PRU步进速率基准测试

在PRU上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`pru-gcc (GCC) 8.0.0 20170530 (experimental)`。

| pru              | ticks |
| ---------------- | ----- |
| 1 stepper        | 231   |
| 3 stepper        | 847   |

### STM32F042步进速率基准测试

在STM32F042上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| stm32f042        | ticks |
| ---------------- | ----- |
| 1 stepper        | 59    |
| 3 stepper        | 249   |

### STM32F103步进速率基准测试

在STM32F103上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| stm32f103            | ticks |
| -------------------- | ----- |
| 1 stepper            | 61    |
| 3 stepper            | 264   |

### STM32F4步进速率基准测试

在STM32F4上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。STM32F407的结果是通过在STM32F446上运行STM32F407的二进制文件获得的（因此使用168MHz时钟）。

| stm32f446            | ticks |
| -------------------- | ----- |
| 1 stepper            | 46    |
| 3 stepper            | 205   |

| stm32f407            | ticks |
| -------------------- | ----- |
| 1 stepper            | 46    |
| 3 stepper            | 205   |

### STM32H7步进速率基准测试

在STM32H723上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PA13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=52
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=52
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=52
finalize_config crc=0
```

测试最后一次在提交`554ae78d`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0`。

| stm32h723            | ticks |
| -------------------- | ----- |
| 1 stepper            | 70    |
| 3 stepper            | 181   |

### STM32G0B1步进速率基准测试

在STM32G0B1上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PB13 dir_pin=PB12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB10 dir_pin=PB2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB0 dir_pin=PC5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`247cd753`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。

| stm32g0b1        | ticks |
| ---------------- | ----- |
| 1 stepper        | 58    |
| 3 stepper        | 243   |

### STM32G4步进速率基准测试

在STM32G431上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PA0 dir_pin=PB5 invert_step=-1 step_pulse_ticks=17
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=17
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=17
finalize_config crc=0
```

测试最后一次在提交`cfa48fe3`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0`。

| stm32g431        | ticks |
| ---------------- | ----- |
| 1 stepper        | 47    |
| 3 stepper        | 208   |

### LPC176x步进速率基准测试

在LPC176x上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`。120MHz的LPC1769结果是通过将LPC1768超频至120MHz获得的。

| lpc1768              | ticks |
| -------------------- | ----- |
| 1 stepper            | 52    |
| 3 stepper            | 222   |

| lpc1769              | ticks |
| -------------------- | ----- |
| 1 stepper            | 51    |
| 3 stepper            | 222   |

### SAMD21步进速率基准测试

在SAMD21上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`，在SAMD21G18微控制器上进行。

| samd21               | ticks |
| -------------------- | ----- |
| 1 stepper            | 70    |
| 3 stepper            | 306   |

### SAMD51步进速率基准测试

在SAMD51上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`，在SAMD51J19A微控制器上进行。

| samd51               | ticks |
| -------------------- | ----- |
| 1 stepper            | 39    |
| 3 stepper            | 191   |
| 1 stepper (200Mhz)   | 39    |
| 3 stepper (200Mhz)   | 181   |

### SAME70步进速率基准测试

在SAME70上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PC18 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC16 dir_pin=PD10 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC28 dir_pin=PA4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`34e9ea55`上运行，使用的gcc版本为`arm-none-eabi-gcc (NixOS 10.3-2021.10) 10.3.1`，在SAME70Q20B微控制器上进行。

| same70               | ticks |
| -------------------- | ----- |
| 1 stepper            | 45    |
| 3 stepper            | 190   |

### AR100步进速率基准测试

在AR100 CPU（全志A64）上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=PL10 dir_pin=PE14 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PL11 dir_pin=PE15 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PL12 dir_pin=PE16 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`b7978d37`上运行，使用的gcc版本为`or1k-linux-musl-gcc (GCC) 9.2.0`，在全志A64-H微控制器上进行。

| AR100 R_PIO          | ticks |
| -------------------- | ----- |
| 1 stepper            | 85    |
| 3 stepper            | 359   |

### RPxxxx步进速率基准测试

在RP2040和RP2350上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

测试最后一次在提交`14c105b8`上运行，使用的gcc版本为`arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0`，在树莓派Pico和Pico 2开发板上进行。

| rp2040 (*)           | ticks |
| -------------------- | ----- |
| 1 stepper            | 3     |
| 3 stepper            | 14    |

| rp2350               | ticks |
| -------------------- | ----- |
| 1 stepper            | 36    |
| 3 stepper            | 169   |

(*) 注意，报告的rp2040 ticks是相对于12MHz的调度定时器，不对应其200MHz的内部ARM处理速率。预计3个调度tick对应约42个ARM核心周期，14个调度tick对应约225个ARM核心周期。

### Linux MCU步进速率基准测试

在树莓派上使用以下配置序列：
```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
finalize_config crc=0
```

测试最后一次在提交`59314d99`上运行，使用的gcc版本为`gcc (Raspbian 8.3.0-6+rpi1) 8.3.0`，在树莓派3（版本a02082）上进行。在此基准测试中很难获得稳定的结果。

| Linux (RPi3)         | ticks |
| -------------------- | ----- |
| 1 stepper            | 160   |
| 3 stepper            | 380   |

## 命令分发基准测试

命令分发基准测试测试微控制器可以处理多少“虚拟”命令。它主要是对硬件通信机制的测试。测试使用console.py工具（在[Debugging.md](Debugging.md)中描述）运行。以下内容剪切并粘贴到console.py终端窗口中：
```
DELAY {clock + 2*freq} get_uptime
FLOOD 100000 0.0 debug_nop
get_uptime
```

当测试完成时，确定两个“uptime”响应消息中报告的时钟之间的差异。每秒总命令数为`100000 * mcu_frequency / clock_diff`。

USB测试可能会超过树莓派的CPU容量。如果在树莓派、Beaglebone或类似的主机计算机上运行，则增加延迟（例如，`DELAY {clock + 20*freq} get_uptime`）。适用时，以下基准测试是在桌面级机器上运行console.py，并通过超高速集线器连接设备。

CAN总线测试可能会使树莓派的USB主机控制器饱和（当通过标准的gs_usb USB转CAN总线适配器测试时）。适用时，以下CAN总线基准测试是在桌面级机器上运行console.py，并通过超高速USB集线器连接USB转CAN总线适配器。

| MCU                 | 速率 | 构建版本    | 构建编译器      |
| ------------------- | ---- | -------- | ------------------- |
| atmega2560 (串行) |  23K | b161a69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (串行)    |  23K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| rp2350 (CAN)        |  59K | 17b8ce4c | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| at90usb1286 (USB)   |  75K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| ar100 (串行)      | 138K | 08d037c6 | or1k-linux-musl-gcc 9.3.0 |
| samd21 (USB)        | 223K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| pru (共享内存) | 260K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (experimental) |
| stm32f103 (USB)     | 355K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB)       | 418K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB)       | 534K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB)       | 628K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB)       | 650K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB)        | 864K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB)     | 870K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB)        | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| rp2350 (USB)        | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |

## 主机基准测试

可以使用“批处理”处理机制（在[Debugging.md](Debugging.md)中描述）在主机软件上运行定时测试。这通常通过选择一个大而复杂的G代码文件，并计时主机软件处理它需要多长时间来完成。例如：
```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```