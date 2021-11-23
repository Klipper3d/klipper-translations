# 벤치마크

이 문서는 클리퍼의 벤치마크에 대한 내용이다.

## 마이크로 컨트롤러 벤치마크

이 섹션은 클리퍼 마이크로 컨트롤러의 step rate 벤치마크를 생성하는데 사용된 메카니즘에 대해 기술하고 있다.

벤치마크의 첫번째 목표는 소프트웨어안의 코딩 변화의 영향을 측정하는 일관된 메카니즘을 제공하는 것이다. 두번째 목표는 칩들 사이, 소프트웨어 플랫폼 사이의 성능비교를 위한 높은 레벨의 매트릭스를 제공하는 것이다.

Step rate 벤치마크는 하드웨어와 소프트웨어가 도달할 수 있는 최대 스텝 레이트를 찾도록 설계되어 있다. 이 벤치마크 스텝 레이트는 매일매일의 사용으로는 얻어질 수 없다. 왜냐하면 클리퍼는 mcu/host 커뮤니케이션, 온도 확인, 엔드스탑 체크 등의 실제 사용환경속에서 일어나는 다른 작업들도 행해야 하기 때문이다.

일반적으로, 벤치마크 테스트를 위한 핀들은 LED를 밝히거나 다른 무해한 핀들에서 선택되어진다. **벤치마크를 돌리기에 앞서 설정된 핀을 돌리는게 안전한지를 항상 먼저 확인해야 한다.** 벤치마크중에는 실제 스텝모터를 돌리는건 추천되지 않는다.

### 스텝 레이트 벤치마크 테스트

The test is performed using the console.py tool (described in <Debugging.md>). The micro-controller is configured for the particular hardware platform (see below) and then the following is cut-and-paste into the console.py terminal window:

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

위 코드는 세개의 스텝모터를 동시적으로 스텝핑하는 테스트를 진행한다. 위 코드를 실행시키면 "Rescheduled timer in the past" 혹은 "Stepper too far in past" 라는 에러가 나는데, 그것은 `ticks` 파라메터가 너무 낮다는 것을 말한다. (스텝핑 레이트가 너무 빠르다는 결과이다). 목표는 테스트를 성공적으로 마치는 안정적인 가장 낮은 ticks 파라메터의 셋팅을 찾는 것이다. 안정적인 값을 찾을때 까지 ticks 파라메터를 이등분 할 수 있어야 한다.

실패시 다음 테스트를 준비하기 위해 에러를 클리어 해야 하는데 다음에 나오는 명령어를 복붙해 사용하면 된다.:

```
clear_shutdown
```

To obtain the single stepper benchmarks, the same configuration sequence is used, but only the first block of the above test is cut-and-paste into the console.py window.

To produce the benchmarks found in the [Features](Features.md) document, the total number of steps per second is calculated by multiplying the number of active steppers with the nominal mcu frequency and dividing by the final ticks parameter. The results are rounded to the nearest K. For example, with three active steppers:

```
ECHO Test result is: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

The benchmarks are run with parameters suitable for TMC Drivers. For micro-controllers that support `STEPPER_BOTH_EDGE=1` (as reported in the `MCU config` line when console.py first starts) use `step_pulse_duration=0` and `invert_step=-1` to enable optimized stepping on both edges of the step pulse. For other micro-controllers use a `step_pulse_duration` corresponding to 100ns.

### AVR 스텝 레이트 벤치마크

다음에 나오는 설정 시퀀스는 AVR 칩에 적용된다.:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `avr-gcc (GCC) 5.4.0`. Both the 16Mhz and 20Mhz tests were run using simulavr configured for an atmega644p (previous tests have confirmed simulavr results match tests on both a 16Mhz at90usb and a 16Mhz atmega2560).

| avr | ticks |
| --- | --- |
| 한개의 스텝모터 | 102 |
| 세개의 스텝모터 | 486 |

### Arduino Due 스텝레이트 벤치마크

이어지는 설정 시퀀스는 Due 에서 사용되어진다. :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam3x8e | ticks |
| --- | --- |
| 한개의 스텝모터 | 66 |
| 세개의 스텝모터 | 257 |

### Duet Maestro 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 Duet Maestro에서 사용된다.:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam4s8c | ticks |
| --- | --- |
| 한개의 스텝모터 | 71 |
| 세개의 스텝모터 | 260 |

### Duet Wifi 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 Duet Wifi 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `gcc version 10.3.1 20210621 (release) (GNU Arm Embedded Toolchain 10.3-2021.07)`.

| sam4e8e | ticks |
| --- | --- |
| 한개의 스텝모터 | 48 |
| 세개의 스텝모터 | 215 |

### Beaglebone PRU 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 RPU 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `pru-gcc (GCC) 8.0.0 20170530 (experimental)`.

| pru | ticks |
| --- | --- |
| 한개의 스텝모터 | 231 |
| 세개의 스텝모터 | 847 |

### STM32F042 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 STM32F042 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f042 | ticks |
| --- | --- |
| 한개의 스텝모터 | 59 |
| 세개의 스텝모터 | 249 |

### STM32F103 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 STM32F103 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f103 | ticks |
| --- | --- |
| 한개의 스텝모터 | 61 |
| 세개의 스텝모터 | 264 |

### STM32F4 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 STM32F4 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. The STM32F407 results were obtained by running an STM32F407 binary on an STM32F446 (and thus using a 168Mhz clock).

| stm32f446 | ticks |
| --- | --- |
| 한개의 스텝모터 | 46 |
| 세개의 스텝모터 | 205 |

| stm32f407 | ticks |
| --- | --- |
| 한개의 스텝모터 | 46 |
| 세개의 스텝모터 | 205 |

### LPC176x 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 LPC176x 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. The 120Mhz LPC1769 results were obtained by overclocking an LPC1768 to 120Mhz.

| lpc1768 | ticks |
| --- | --- |
| 한개의 스텝모터 | 52 |
| 세개의 스텝모터 | 222 |

| lpc1769 | ticks |
| --- | --- |
| 한개의 스텝모터 | 51 |
| 세개의 스텝모터 | 222 |

### SAMD21 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 SAMD21 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` on a SAMD21G18 micro-controller.

| samd21 | ticks |
| --- | --- |
| 한개의 스텝모터 | 70 |
| 세개의 스텝모터 | 306 |

### SAMD51 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 SAMD51 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` on a SAMD51J19A micro-controller.

| samd51 | ticks |
| --- | --- |
| 한개의 스텝모터 | 39 |
| 세개의 스텝모터 | 191 |
| 한개의 스테모터 (200Mhz) | 39 |
| 세개의 스테모터 (200Mhz) | 181 |

### RP2040 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 RP2040 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` on a Raspberry Pi Pico board.

| rp2040 | ticks |
| --- | --- |
| 한개의 스텝모터 | 5 |
| 세개의 스텝모터 | 22 |

### Linux MCU 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 라즈베리파이에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
finalize_config crc=0
```

The test was last run on commit `59314d99` with gcc version `gcc (Raspbian 8.3.0-6+rpi1) 8.3.0` on a Raspberry Pi 3 (revision a02082). It was difficult to get stable results in this benchmark.

| Linux (RPi3) | ticks |
| --- | --- |
| 한개의 스텝모터 | 160 |
| 세개의 스텝모터 | 380 |

## 명령 디스패치 벤치마크

The command dispatch benchmark tests how many "dummy" commands the micro-controller can process. It is primarily a test of the hardware communication mechanism. The test is run using the console.py tool (described in <Debugging.md>). The following is cut-and-paste into the console.py terminal window:

```
DELAY {clock + 2*freq} get_uptime
FLOOD 100000 0.0 debug_nop
get_uptime
```

테스트를 마쳤을때 두개의 "업타임" 응답메시지들에 보고된 클락사이의 차이를 결정하라. 초당 전체 명령의 수는 `100000 * mcu_frequency / clock_diff` 이다.

이 테스트는 라즈베리파이의 USB/CPU 용량을 포화시킬지도 있음을 기억하라. 만약 라즈베리파이, 비글본, 혹은 유사한 호스트 컴퓨터를 사용한다면 딜레이를 높여라 (예, `DELAY {clock + 20*freq} get_uptime`). 해당되는 경우 아래의 벤치마크는 고속 허브를 통해 연결된 장치가 있는 데스크톱 클래스 시스템에서 실행되는 console.py에 대한 것입니다.

| MCU | Rate | Build | Build compiler |
| --- | --- | --- | --- |
| stm32f042 (CAN) | 18K | c105adc8 | arm-none-eabi-gcc (GNU Tools 7-2018-q3-update) 7.3.1 |
| atmega2560 (serial) | 23K | b161a69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (serial) | 23K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| at90usb1286 (USB) | 75K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| samd21 (USB) | 223K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| pru (shared memory) | 260K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (experimental) |
| stm32f103 (USB) | 355K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB) | 534K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB) | 628K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB) | 870K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 873K | c5667193 | arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0 |

## 호스트 벤치마크

It is possible to run timing tests on the host software using the "batch mode" processing mechanism (described in <Debugging.md>). This is typically done by choosing a large and complex G-Code file and timing how long it takes for the host software to process it. For example:

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
