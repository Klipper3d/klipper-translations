# 벤치마크

이 문서는 클리퍼의 벤치마크에 대한 내용이다.

## 마이크로 컨트롤러 벤치마크

이 섹션은 클리퍼 마이크로 컨트롤러의 step rate 벤치마크를 생성하는데 사용된 메카니즘에 대해 기술하고 있다.

벤치마크의 첫번째 목표는 소프트웨어안의 코딩 변화의 영향을 측정하는 일관된 메카니즘을 제공하는 것이다. 두번째 목표는 칩들 사이, 소프트웨어 플랫폼 사이의 성능비교를 위한 높은 레벨의 매트릭스를 제공하는 것이다.

Step rate 벤치마크는 하드웨어와 소프트웨어가 도달할 수 있는 최대 스텝 레이트를 찾도록 설계되어 있다. 이 벤치마크 스텝 레이트는 매일매일의 사용으로는 얻어질 수 없다. 왜냐하면 클리퍼는 mcu/host 커뮤니케이션, 온도 확인, 엔드스탑 체크 등의 실제 사용환경속에서 일어나는 다른 작업들도 행해야 하기 때문이다.

일반적으로, 벤치마크 테스트를 위한 핀들은 LED를 밝히거나 다른 무해한 핀들에서 선택되어진다. **벤치마크를 돌리기에 앞서 설정된 핀을 돌리는게 안전한지를 항상 먼저 확인해야 한다.** 벤치마크중에는 실제 스텝모터를 돌리는건 추천되지 않는다.

### 스텝 레이트 벤치마크 테스트

The test is performed using the console.py tool (described in [Debugging.md]). The micro-controller is configured for the particular hardware platform (see below) and then the following is cut-and-paste into the console.py terminal window:

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

싱글 스텝모터나 듀얼 스텝모터의 벤치마크값을 얻기 위해서도 동일한 설정 시퀀스를 사용하면 된다. 단지, 위 테스트에 나오는 첫번째 블록(싱글 스텝퍼의 경우), 처음나오는 두개의 블록(듀얼 스텝퍼의 경우)을 console.py 창에 복붙 하면 된다.

Features.md 문서에 있는 벤치마크들을 생성하기 위해서, 초당 전체 스텝수는 명목상의 mcu 주파수와 활성 스텝모터의 수를 곱하고 최종 tick 파라메터로 나누어 계산되어진다. 결과는 가장 가까운 K 로 반올림된다. 예를 들어 세개의 스텝모터라면 :

```
ECHO Test result is: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

벤치마크는 zero(아래 테이블을 통해 보면 이것은 delay 가 없음을 나타낸다)의 "step pulse duration"을 사용하여 컴파일된 마이크로 컨트롤러로 돌려야 한다. 이 설정은 TMC 드라이버를 사용할때에만 실제세상의 사용에 유용하다고 믿어진다. 이 벤치마크 결과들은 Features.md 문서에 기록되지 않는다.

### AVR 스텝 레이트 벤치마크

다음에 나오는 설정 시퀀스는 AVR 칩에 적용된다.:

```
PINS arduino
allocate_oids count=3
config_stepper oid=0 step_pin=ar29 dir_pin=ar28 invert_step=0
config_stepper oid=1 step_pin=ar27 dir_pin=ar26 invert_step=0
config_stepper oid=2 step_pin=ar23 dir_pin=ar22 invert_step=0
finalize_config crc=0
```

테스트는 gcc의 `avr-gcc(GCC) 5.4.0` 버전을 사용하여 `01d2183f` 커밋상에서 최종적으로 돌려졌다. 16Mhz 와 20Mhz 테스트 모두 atmega644p를 위해 설정된 simulavr을 사용해 돌려졌다. (앞선 테스트들에서 simulavr 결과가 16Mhz at90usb 와 16Mhz atmega2560 에서 테스트한 값과 같음을 확인했습니다).

| avr | ticks |
| --- | --- |
| 한개의 스텝모터 | 104 |
| 두개의 스텝모터 | 296 |
| 세개의 스텝모터 | 472 |

### Arduino Due 스텝레이트 벤치마크

이어지는 설정 시퀀스는 Due 에서 사용되어진다. :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=0
finalize_config crc=0
```

테스트는 gcc의 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0` 버전에서 `8d4a5c16` 커밋상에 마지막으로 실행되었다.

| sam3x8e | ticks |
| --- | --- |
| 한개의 스텝모터 | 388 |
| 두개의 스텝모터 | 405 |
| 세개의 스텝모터 | 576 |
| 한개의 스텝모터 (delay 없음) | 77 |
| 세개의 스텝모터 (delay 없음) | 299 |

### Duet Maestro 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 Duet Maestro에서 사용된다.:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=0
finalize_config crc=0
```

테스트는 gcc의 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0` 버전에서 `8d4a5c16` 커밋상에 마지막으로 실행되었다.

| sam4s8c | ticks |
| --- | --- |
| 한개의 스텝모터 | 527 |
| 두개의 스텝모터 | 535 |
| 세개의 스텝모터 | 638 |
| 한개의 스텝모터 (delay 없음) | 70 |
| 세개의 스텝모터 (delay 없음) | 254 |

### Duet Wifi 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 Duet Wifi 에서 사용된다:

```
allocate_oids count=4
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=0
config_stepper oid=3 step_pin=PD5 dir_pin=PA1 invert_step=0
finalize_config crc=0
```

테스트는 gcc의 `arm-none-eabi-gcc 7.3.1 20180622 (release) [ARM/embedded-7-branch revision 261907]` 버전에서 `59a60d68` 커밋상에 마지막으로 실행되었다.

| sam4e8e | ticks |
| --- | --- |
| 한개의 스텝모터 | 519 |
| 두개의 스텝모터 | 520 |
| 세개의 스텝모터 | 525 |
| 네개의 스텝모터 | 703 |

### Beaglebone PRU 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 RPU 에서 사용된다:

```
PINS beaglebone
allocate_oids count=3
config_stepper oid=0 step_pin=P8_13 dir_pin=P8_12 invert_step=0
config_stepper oid=1 step_pin=P8_15 dir_pin=P8_14 invert_step=0
config_stepper oid=2 step_pin=P8_19 dir_pin=P8_18 invert_step=0
finalize_config crc=0
```

테스트는 gcc의 `pru-gcc (GCC) 8.0.0 20170530 (experimental)` 버전에서 `b161a69e` 커밋상에 마지막으로 실행되었다.

| pru | ticks |
| --- | --- |
| 한개의 스텝모터 | 861 |
| 두개의 스텝모터 | 853 |
| 세개의 스텝모터 | 883 |

### STM32F042 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 STM32F042 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=0
finalize_config crc=0
```

테스트는 gcc의 `arm-none-eabi-gcc (Fedora 9.2.0-1.fc30) 9.2.0` 버전에서 `0b0c47c5` 커밋상에 마지막으로 실행되었다.

| stm32f042 | ticks |
| --- | --- |
| 한개의 스텝모터 | 247 |
| 두개의 스텝모터 | 328 |
| 세개의 스텝모터 | 558 |

### STM32F103 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 STM32F103 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=0
finalize_config crc=0
```

테스트는 gcc의 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0` 버전에서 `8d4a5c16` 커밋상에 마지막으로 실행되었다.

| stm32f103 | ticks |
| --- | --- |
| 한개의 스텝모터 | 347 |
| 두개의 스텝모터 | 372 |
| 세개의 스텝모터 | 600 |
| 한개의 스텝모터 (delay 없음) | 71 |
| 세개의 스텝모터 (delay 없음) | 288 |

### STM32F4 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 STM32F4 에서 사용된다:

```
allocate_oids count=4
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=0
config_stepper oid=3 step_pin=PB3 dir_pin=PB8 invert_step=0
finalize_config crc=0
```

테스트는 gcc의 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0` 버전에서 `8d4a5c16` 커밋상에 마지막으로 실행되었다. STM32F407 결과는 STM32F446에서 STM32F407 바이너리를 실행하여 얻은 것입니다(따라서 168Mhz 클록 사용).

| stm32f446 | ticks |
| --- | --- |
| 한개의 스텝모터 | 757 |
| 두개의 스텝모터 | 761 |
| 세개의 스텝모터 | 757 |
| 네개의 스텝모터 | 767 |
| 한개의 스텝모터 (delay 없음) | 51 |
| 세개의 스텝모터 (delay 없음) | 226 |

| stm32f407 | ticks |
| --- | --- |
| 한개의 스텝모터 | 709 |
| 두개의 스텝모터 | 714 |
| 세개의 스텝모터 | 709 |
| 네개의 스텝모터 | 729 |
| 한개의 스텝모터 (delay 없음) | 52 |
| 세개의 스텝모터 (delay 없음) | 226 |

### LPC176x 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 LPC176x 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=0
finalize_config crc=0
```

테스트는 gcc의 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0` 버전으로 `8d4a5c16` 커밋상에 마지막으로 실행되었다. 120Mhz LPC1769 결과는 LPC1768을 120MHz 로 오버클럭킹해서 얻은 것이다.

| lpc1768 | ticks |
| --- | --- |
| 한개의 스텝모터 | 448 |
| 두개의 스텝모터 | 450 |
| 세개의 스텝모터 | 523 |
| 한개의 스텝모터 (delay 없음) | 56 |
| 세개의 스텝모터 (delay 없음) | 240 |

| lpc1769 | ticks |
| --- | --- |
| 한개의 스텝모터 | 525 |
| 두개의 스텝모터 | 526 |
| 세개의 스텝모터 | 545 |
| 한개의 스텝모터 (delay 없음) | 56 |
| 세개의 스텝모터 (delay 없음) | 240 |

### SAMD21 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 SAMD21 에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=0
finalize_config crc=0
```

테스트는 SAMD21G18 마이크로 컨트롤러에서 gcc의 `arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0` 버전으로 `8d4a5c16` 커밋상에 마지막으로 실행되었다.

| samd21 | ticks |
| --- | --- |
| 한개의 스텝모터 | 277 |
| 두개의 스텝모터 | 410 |
| 세개의 스텝모터 | 664 |
| 한개의 스텝모터 (delay 없음) | 83 |
| 세개의 스텝모터 (delay 없음) | 321 |

### SAMD51 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 SAMD51 에서 사용된다:

```
allocate_oids count=5
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=0
config_stepper oid=3 step_pin=PA22 dir_pin=PA18 invert_step=0
config_stepper oid=4 step_pin=PA23 dir_pin=PA17 invert_step=0
finalize_config crc=0
```

테스트는 SAMD51J19A 마이크로 컨트롤러에서 gcc의 `arm-none-eabi-gcc (Fedora 9.2.0-1.fc30) 9.2.0` 버전으로 `524ebbc7` 커밋상에 마지막으로 실행되었다.

| samd51 | ticks |
| --- | --- |
| 한개의 스텝모터 | 516 |
| 두개의 스텝모터 | 520 |
| 세개의 스텝모터 | 520 |
| 네개의 스텝모터 | 631 |
| 한개의 스테모터 (200Mhz) | 839 |
| 두개의 스테모터 (200Mhz) | 838 |
| 세개의 스테모터 (200Mhz) | 838 |
| 네개의 스테모터 (200Mhz) | 838 |
| 다섯개의 스테모터 (200Mhz) | 891 |
| 한개의 스텝모터 (delay 없음) | 42 |
| 세개의 스텝모터 (delay 없음) | 194 |

### RP2040 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 RP2040 에서 사용된다:

```
allocate_oids count=4
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=0
config_stepper oid=3 step_pin=gpio28 dir_pin=gpio6 invert_step=0
finalize_config crc=0
```

테스트는 라즈베리파이 피코 보드에서 gcc의 `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`버전으로 `c5667193` 커밋상에 마지막으로 실행되었다.

| rp2040 | ticks |
| --- | --- |
| 한개의 스텝모터 | 52 |
| 두개의 스텝모터 | 52 |
| 세개의 스텝모터 | 52 |
| 네개의 스텝모터 | 66 |
| 한개의 스텝모터 (delay 없음) | 5 |
| 세개의 스텝모터 (delay 없음) | 22 |

### Linux MCU 스텝 레이트 벤치마크

이어지는 설정 시퀀스는 라즈베리파이에서 사용된다:

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio7 invert_step=0
finalize_config crc=0
```

테스트는 라즈베리파이 3(revision a22082)에서 gcc의 `gcc(Raspbian 6.3.0-18+rpi1+deb9u1) 6.3.0 20170516` 버전으로 `db0fb5d5` 커밋상에 마지막으로 실행되었다.

| Linux (RPi3) | ticks |
| --- | --- |
| 한개의 스텝모터 | 349 |
| 두개의 스텝모터 | 350 |
| 세개의 스텝모터 | 400 |

## 명령 디스패치 벤치마크

The command dispatch benchmark tests how many "dummy" commands the micro-controller can process. It is primarily a test of the hardware communication mechanism. The test is run using the console.py tool (described in [Debugging.md]). The following is cut-and-paste into the console.py terminal window:

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

It is possible to run timing tests on the host software using the "batch mode" processing mechanism (described in [Debugging.md]). This is typically done by choosing a large and complex G-Code file and timing how long it takes for the host software to process it. For example:

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
