# 자주 묻는 질문

## 어떻게 깡통과 나는 영사기를 위해 기부하십니까?

감사에 대한 지원합니다. 볼[스폰서 페이지](스폰서가 있습니다.md)에 대한 정보입니다.

## 돌리기_거리는 어떻게 계산합니까?

이 문서를 [돌리기 거리 문서](Rotation_Distance.md) 보십시오.

## 내 직렬 항구는 어디에 있습니까?

범용직렬공용승합차 직렬항구를 찾는 일반적인 방법은 숙주체계의 보안 껍데기 종단점에서 다음의 명령을 실행하십시오. `ls /dev/serial/by-id/*`. 그럼 다음과 같이 나옵니다:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

위 명령에서 찾은 이름을 사용해서 구성설정 서류에 적을 수도 있고 작은제어자에 물고기 올려주기 할때도 사용됩니다. 예를 들어 반짝이다 명령은 다음과 같이 사용할 수 있습니다:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

그리고 config 파일을 보면 아래와 같이 mcu 항목이 작성되어 있습니다:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

이름은 각 프린터에 대해 다를 것입니다 "ls" 명령에서 이름을 복사하고 붙여야합니다.

여러 개의 마이크로 컨트롤러를 사용하고 있다면 고유 한 ids가 없습니다 (CH340 USB 칩 보드에서 데모) 그런 다음 명령 `ls /dev/serial/by-path/*`를 사용하여 위의 방향을 따르십시오.

## Micro-controller가 /dev/ttyUSB1에 디바이스 변경을 다시 시작합니다

링크의 지침을 따르면 "[내 시리얼 포트는 어디에 있습니까?](#내-시리얼-포트는-어디에-있습니까)" 문제 해결이 가능합니다.

## "make flash"는 일을 그만뒀습니다

코드는 각 플랫폼의 가장 일반적인 방법을 사용하여 장치를 플래시하려고합니다. 불행히도, 번쩍이는 방법에 있는 variance의 많음이 있습니다, 그래서 "make flash" 명령은 모든 널에 작동하지 않을지도 모릅니다.

이 웹 사이트는 귀하가 웹 사이트를 탐색하는 동안 귀하의 경험을 향상시키기 위해 쿠키를 사용합니다. 이 쿠키들 중에서 필요에 따라 분류 된 쿠키는 웹 사이트의 기본적인 기능을 수행하는 데 필수적이므로 브라우저에 저장됩니다. 또한이 웹 사이트의 사용 방식을 분석하고 이해하는 데 도움이되는 제 3 자 과자를 사용합니다. 이 쿠키는 당신들의 동의하에 만 브라우저에 저장됩니다. 이러한 쿠키 중 일부를 선택 해제하면 검색 환경에 영향을 미칠 수 있습니다.

그러나 "플래시"가 널을 위해 작동하지 않는 경우에, 당신은 수동으로 섬광을 필요로 할 것입니다. [config 디렉토리](../config)의 설정 파일이 있는 경우, 디바이스를 번쩍이는 특정 지침을 참조하십시오. 또한, 보드 제조업체의 문서를 확인하여 장치를 플래시하는 방법을 설명합니다. 마지막으로, 수동으로 "avrdude"또는 "bossac"과 같은 도구를 사용하여 장치를 깜박일 수 있습니다 - 추가 정보를 위해 [bootloader document] (Bootloaders.md)를 참조하십시오.

## 어떻게 직렬 배드 속도를 변경합니까?

Klipper의 권장 보드율은 250000입니다. 이 보드율은 Klipper가 지원하는 모든 마이크로 컨트롤러 보드에서 잘 작동합니다. 온라인 가이드를 발견하면 다른 배율 추천, 그리고 가이드의 일부가 무시하고 250000의 기본 값으로 계속.

버드 비율을 어쨌든 변경하려면 새로운 비율은 마이크로 제어기 (**make menuconfig**])에서 구성되어야하며 업데이트 된 코드는 마이크로 제어기에 컴파일하고 깜박입니다. Klipper Printer.cfg 파일은 baud rate ([config reference](Config_Reference.md#mcu)와 일치하도록 업데이트되어야 합니다. 예시를 위합니다:

```
[mcu]
baud: 250000
```

OctoPrint 웹 페이지에 표시된 보드율은 내부 Klipper 마이크로 제어기 보드율에 영향을 미치지 않습니다. 항상 Klipper를 사용할 때 OctoPrint baud rate를 250000로 설정합니다.

Klipper micro-controller baud rate는 micro-controller의 bootloader의 보드율과 관련이 없습니다. bootloaders에 대한 추가 정보를 위해 [bootloader document](Bootloaders.md)를 참조하십시오.

## 나는 Raspberry Pi 3보다 다른 무언가에 Klipper를 실행할 수 있습니까?

The recommended hardware is a Raspberry Pi Zero2w, Raspberry Pi 3, Raspberry Pi 4 or Raspberry Pi 5. Klipper will also run on other SBC devices as well as x86 hardware, as described below.

Klipper will run on a Raspberry Pi 1, 2 and on the Raspberry Pi Zero1, but these boards don't have enough processing power to run Klipper well. It is common for print stalls to occur on these slower machines when printing (The printer may move faster than Klipper can send movement commands.) It is not reccomended to run Klipper on these older machines.

Beaglebone에서 실행하려면 [Beaglebone 특정 설치 지침](Beaglebone.md)을 참조하십시오.

Klipper는 다른 기계에서 실행되었습니다. Klipper 호스트 소프트웨어는 Linux(또는 이와 유사한) 컴퓨터에서 Python을 실행해야 합니다. 그러나 다른 기계에서 실행하려면 특정 기계에 대한 시스템 우선 순위를 설치하는 Linux 관리자 지식이 필요합니다. 필요한 Linux 관리자 단계에 대한 자세한 내용은 [install-octopi.sh](../scripts/install-octopi.sh) 스크립트를 참조하십시오.

낮은끝 칩에 Klipper 숙주소프트웨어를 실행하려는 경우, "double Precision Floating point" 하드웨어가 필요합니다.

Klipper Host 소프트웨어를 공유 범용 데스크톱 또는 서버 클래스 기계에서 실행하려는 경우 Klipper는 실시간 스케줄링 요구 사항을 가지고 있음을 유의하십시오. 인쇄 중에는 호스트 컴퓨터도 집중적 범용 컴퓨팅 작업을 수행 (예 : 하드 드라이브, 3d 렌더링, 무거운 스왑, 등), 그런 다음 Klipper가 인쇄 오류를보고 할 수 있습니다.

참고 : OctoPi 이미지를 사용하지 않는 경우 여러 Linux 배포가 직렬 통신을 방해 할 수있는 "ModemManager"(또는 이와 유사한) 패키지를 활성화하는 인식이됩니다. (Klipper가 MCU와 같은 랜덤 "Lost Communication with MCU" 오류를보고 할 수 있습니다.) 이 배포 중 하나에 Klipper를 설치하면 패키지를 비활성화 할 수 있습니다.

## 같은 호스트 기계에서 Klipper의 여러 인스턴스를 실행할 수 있습니까?

Klipper 호스트 소프트웨어의 여러 인스턴스를 실행할 수 있지만 그렇게 하려면 Linux 관리자 지식이 필요합니다. Klipper 설치 스크립트는 궁극적으로 다음 Unix 명령이 실행되도록 합니다:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

하나의 위의 명령의 여러 인스턴스를 실행할 수 있습니다. 각 인스턴스는 자체 프린터 구성 파일, 자체 로그 파일, 그리고 그것의 자신의 가짜 tty. 예를 들면:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

이 작업을 수행하려면 필요한 시작, 중지 및 설치 스크립트를 구현해야합니다 (모든 경우). [install-octopi.sh](../scripts/install-octopi.sh) 스크립트와 [klipper-start.sh](../scripts/klipper-start.sh) 스크립트는 예로 유용할 수 있습니다.

## OctoPrint를 사용해야 합니까?

Klipper 소프트웨어는 OctoPrint에 의존하지 않습니다. 대체 소프트웨어를 사용하여 Klipper에 명령을 보낼 수 있지만 그렇게 하려면 Linux 관리자 지식이 필요합니다.

Klipper는 "/tmp/printer" 파일을 통해 "virtual serial port"를 만들고 그 파일을 통해 고전적인 3d-printer serial interface를 에뮬레이션합니다. 일반적으로 대체 소프트웨어는 프린터 직렬 포트에 "/tmp/printer"를 사용할 수 있도록 구성 할 수 있기 때문에 Klipper와 함께 작동 할 수 있습니다.

## 왜 프린터를 연마하기 전에 스테퍼를 이동할 수 없습니까?

이 코드는 실수로 머리를 침대 또는 벽으로 박는 명령의 기회를 줄일 수 있습니다. 프린터가 설치되면 각 이동을 확인하는 소프트웨어 시도는 config 파일에서 정의된 position_min/max 안에 있습니다. 모터가 비활성화되면 (M84 또는 M18 명령을 통해) 다음 모터가 다시 이동하기 전에 당신을 가정해야합니다.

OctoPrint를 통해 인쇄를 취소 한 후 머리를 저쪽으로 이동하려면 OctoPrint 취소 순서변경하십시오. 아래 홍바틀를 통해 OctoPrint에서 구성됩니다. 설정->GCODE 스크립트

인쇄 공습 후 머리를 이동하려면 슬라이서의 "custom g-code"섹션에 원하는 움직임을 추가해야합니다.

프린터가 귀환 프로세스 자체의 일부로 추가 이동이 필요하면 (또는 기본적으로 homing 프로세스가 없습니다) 다음 config 파일에서 safe_z_home 또는 homing_override 섹션을 사용하여 고려하십시오. 진단 또는 디버깅 목적으로 당신의 머리를 디버거로 이동해야 하는 경우, config 파일에 force_move 섹션을 추가해야 합니다. 이 옵션에 대한 자세한 내용은 [config reference](Config_Reference.md#customized_homing)를 참조하십시오.

## 왜 Z position_endstop은 기본 설정에서 0.5로 설정되십니까?

Cartesian 스타일 프린터의 Z position_endstop은 엔드 스톱 트리거가 될 때 노즐이 침대에서 얼마나 멀리 있는지 지정합니다. 가능한 경우, Z-max endstop을 사용 하 여 침대에서 멀리 홈을 사용 하는 것이 좋습니다 (이 때문에 침대 충돌에 대 한 잠재력을 감소). 그러나, 침대를 향해 가정해야 할 경우, 그것은 endstop에 위치하는 것이 좋습니다 그래서 노즐이 여전히 침대에서 작은 거리에있을 때 트리거. 이 방법, 축을 귀환시킬때, 그것은 노즐이 침대를 만지기전에 중지합니다. 더 많은 정보를 위해 [bed Level document](Bed_Level.md)를 참조하십시오.

## 나는 Marlin과 X/Y axes 일 벌금에서 나의 구성을 개조했습니다, 그러나 Z 축선을 귀환할때 나는 다만 삐걱삐걱 소음을 얻습니다

짧은 대답들: 먼저, [config check document](Config_checks.md)에 설명된 스테퍼 구성을 확인합니다. 문제가 발생하면 프린터 구성에서 max_z_velocity 설정이 줄어듭니다.

긴 대답: 연습 Marlin은 일반적으로 초당 약 10000 단계의 속도로 진행할 수 있습니다. 더 높은 단계 비율을 필요로 하는 속도에 이동할 것을 요구된 경우에, Marlin는 그것으로 일반적으로 다만 단계 일 것입니다. Klipper는 매우 높은 단계 속도를 달성할수있지만 스테퍼 모터는 더 높은 속도로 이동하기 위해 충분한 토크가 없습니다. 따라서, 높은 기어링 비율 또는 높은 마이크로 스텝을 가진 Z 축선을 위해 실제적인 얻은 max_z_velocity는 Marlin에서 형성된 것 보다는 더 작을지도 모릅니다.

## 나의 TMC 모터 운전사는 인쇄의 중간에서 끕니다

TMC2208 (또는 TMC2224) 드라이버를 사용하는 경우 "독립 모드"를 사용하여 [Klipper의 최신 버전](#how-do-i-upgrade-to-the-latest-software)를 사용하십시오. TMC2208 "stealthchop" 드라이버 문제는 2020 년 3 월 중순에 Klipper에 추가되었습니다.

## 나는 임의 "MCU와의 통신을 밀어" 오류

이것은 주인 기계와 마이크로 제어기 사이 USB 연결에 기계설비 과실에 의해 통용됩니다. 볼 수있는 것들 :

- 주인 기계와 마이크로 제어기 사이 좋은 품질 USB 케이블을 사용하십시오. 플러그는 안전하다고 느낍니다.
- 을 사용하는 경우 라즈베리 파이,사용하는[좋은 품질의 전원 공급 장치](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply)한 라즈베리 파이 사용하여[좋은 품질의 USB 케이블](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877)연결하는 전원 공급 장치를 Pi. 면"저전압"경고에서 OctoPrint,이와 관련 전원 공급 장치에 고정되어야 합니다.
- 프린터의 전력 공급이 과부하되지 않다는 것을 확인하십시오. (마이크로 제어기의 USB 칩에 전력 변동은 그 칩의 재설정에서 발생할 수 있습니다.)
- 스테퍼, 히터 및 기타 프린터 와이어를 검증하거나 파쇄하지 않습니다. (인쇄기 운동은 접촉을 잃고, 간결하고, 과도한 소음을 생성하는 결함 철사에 긴장을 둘지도 모릅니다.)
- 프린터의 전력 공급과 주인의 5V 전력 공급 둘 다 섞일 때 높은 USB 소음의 보고가 있었습니다. (마이크로 제어기 전원이 프린터의 전원 공급 장치가 켜져 있거나 USB 케이블이 플러그 인 경우 5V 전원 공급 장치가 뒤죽박죽 있음을 알 수 있습니다.) 마이크로 컨트롤러를 구성하는 데 도움이 될 수 있습니다. (단, 마이크로 컨트롤러 보드가 전원을 구성 할 수없는 경우, 하나는 호스트와 마이크로 컨트롤러 사이의 5V 전원을 수행하지 않는 USB 케이블을 수정할 수 있습니다.)

## 내 라즈베리 Pi는 인쇄 중 재부팅 유지

이것은 전압 변동에 가장 가능성이 있습니다. ["MCU와의 통신"](#i-keep-getting-random-lost-communication-with-mcu-errors) 오류에 대한 동일한 문제 해결 단계를 따르십시오.

## When I set`restart_method=명령`내 AVR 장치에서 다시 시작

AVR bootloader의 일부 오래된 버전은 watchdog 행사 취급에 알려진 버그가 있습니다. 일반적으로 print.cfg 파일이 restart_method가 "command"로 설정되었을 때 나타납니다. 버그가 발생했을 때, AVR 장치는 전원이 제거 될 때까지 반응하지 않을 것입니다 (전력 또는 상태 LED는 전원이 제거 될 때까지 반복적으로 깜박일 수도 있습니다).

Workaround는 "command" 이외의 재시작_method를 사용하거나 AVR 장치에 업데이트 된 bootloader를 깜박입니다. 새로운 bootloader를 번쩍이는 것은 일반적으로 외부 프로그래머를 필요로 하는 1 시간 단계입니다 - 자세한 내용은 [Bootloaders] (Bootloaders.md)를 참조하십시오.

## 히터가 라즈베리 파이가 충돌하면 남아 있습니까?

The software has been designed to prevent that. Once the host enables a heater, the host software needs to confirm that enablement every 3 seconds. If the micro-controller does not receive a confirmation every 3 seconds it goes into a "shutdown" state which is designed to turn off all heaters and stepper motors.

[MCU commands](MCU_Commands.md) 문서에서 "config_digital_out" 명령을 참조하십시오.

또한 마이크로 컨트롤러 소프트웨어는 시작시 각 히터의 최소 및 최대 온도 범위로 구성됩니다 ([config reference](Config_Reference.md#extruder)의 min_temp 및 max_temp 매개 변수를 참조하십시오). micro-controller가 온도가 그 범위 밖에 있다는 것을 감지하면 "shutdown"상태를 입력합니다.

별도의 호스트 소프트웨어는 히터 및 온도 센서가 제대로 작동하도록 코드를 구현합니다. 자세한 내용은 [config reference](Config_Reference.md#verify_heater)를 참조하십시오.

## Marlin 핀 번호를 Klipper 핀 이름으로 변환하는 방법은 무엇입니까?

짧은 대답: mapping은 [sample-aliases.cfg](../config/sample-aliases.cfg) 파일에서 사용할 수 있습니다. 실제 마이크로 컨트롤러 핀 이름을 찾는 가이드로 파일 사용. (그것은 또한 관련 [board_pins](Config_Reference.md#board_pins) 구성 섹션을 구성 파일로 복사하고 구성에서 별명을 사용하지만 실제 마이크로 컨트롤러 핀 이름을 번역하고 사용할 수 있습니다.) Sample-aliases.cfg 파일은 "D" 대신 "ar"를 접두사로 시작하는 핀 이름을 사용합니다 (예 : Arduino 핀 ` D23`는 Klipper alias `ar23`) 및 "A" 대신 "analog"(예 : Arduino 핀 `A14`는 Klipper alias `입니다.

긴 대답: Klipper는 micro-controller에 의해 정의된 표준 핀 이름을 사용합니다. Atmega 칩에서이 하드웨어 핀은 `PA4`, `PC7`, 또는 `PD2`와 같은 이름이 있습니다.

오래 전, Arduino 프로젝트는 증가 번호에 근거를 둔 그들의 자신의 핀 이름의 호의에 있는 표준 기계설비 이름을 피하기 위하여 결정했습니다 - 이 Arduino 이름은 일반적으로 ` D23` 또는 ` A14` 같이 보입니다. 이것은 혼란의 중대한 거래에 지도한 불행한 선택이었습니다. 특히 Arduino 핀 번호는 종종 같은 하드웨어 이름을 번역하지 않습니다. 예를 들어, `D21`는 `PD0`이며, 일반적인 Arduino 보드에 `PC7`입니다.

이 혼란을 방지하기 위해 코어 Klipper 코드는 마이크로 제어기에 의해 정의 된 표준 핀 이름을 사용합니다.

## 마이크로 컨트롤러 핀의 특정 유형에 내 장치를 와이어해야 합니까?

그것은 장치의 유형과 핀의 유형에 달려 있습니다:

ADC 핀 (또는 아날로그 핀): rmistors와 유사한 “analog” 감지기를 위해, 장치는 마이크로 관제사에 “analog” 또는 “ADC” 가능한 핀에 타전되어야 합니다. Klipper를 구성하면 아날로그가 불가능한 핀을 사용하려면 Klipper는 " 유효한 ADC 핀" 오류를보고합니다.

PWM 핀 (또는 타이머 핀): Klipper는 모든 장치에서 기본적으로 하드웨어 PWM를 사용하지 않습니다. 그래서, 일반적으로, 하나는 와이어 히터, 팬, 어떤 범용 IO 핀에 유사한 장치 수 있습니다. 그러나 팬과 output_pin 장치는 선택적으로 `hardware_pwm : True`를 사용하여 구성 될 수 있으며 마이크로 컨트롤러가 핀에 하드웨어 PWM을 지원해야합니다 (다른 방향으로, Klipper는 "유효한 PWM 핀" 오류를보고합니다).

IRQ 핀 (또는 Interrupt 핀): Klipper는 IO 핀에 하드웨어 중단을 사용하지 않습니다. 따라서이 마이크로 컨트롤러 핀 중 하나에 장치를 와이어 할 필요가 없습니다.

SPI 핀: 하드웨어 SPI를 사용하면 마이크로 컨트롤러의 SPI 가능 핀에 핀을 와이어해야합니다. 그러나 대부분의 장치는 "software SPI"를 사용할 수 있습니다.

I2C 핀: I2C를 사용할 때 마이크로 컨트롤러의 I2C 가능한 핀에 핀을 와이어해야합니다.

다른 장치는 어떤 다목적 IO 핀에 타전될지도 모릅니다. 예를 들면, 댄서, 히이터, 팬, Z 조사, 자동 귀환 제어 장치, LEDs, 일반적인 hd44780/st7920 LCD 디스플레이를 위해, Trinamic UART 통제 선은 어떤 다목적 IO 핀든지에 타전될지도 모릅니다.

## M109/M190 “온도” 요청을 취소하는 방법?

OctoPrint 터미널 탭으로 이동하고 터미널 박스에서 M112 명령을 발급합니다. M112 명령은 Klipper가 "shutdown"상태로 입력하고 Klipper에서 분리하는 OctoPrint를 일으킬 것입니다. OctoPrint 연결 영역으로 이동하고 "Connect"를 클릭하여 OctoPrint를 다시 연결하십시오. 터미널 탭으로 돌아가서 FIRMWARE_ 발행 RESTART 명령은 Klipper 오류 상태를 삭제합니다. 이 시퀀스를 마친 후, 이전의 난방 요청이 취소되고 새로운 인쇄가 시작될 수 있습니다.

## 프린터가 잃어버린 단계인지 알 수 있습니까?

그런데, 예. 홈 프린터, `GET_POSITION` 명령을 발급, 인쇄를 실행, 다시 가정하고 또 다른 `GET_POSITION`을 발행. 그런 다음 `mcu : ` 라인의 값을 비교하십시오.

실제로 뭔가와 폐기물 필라멘트를 인쇄하지 않고 스테퍼 모터 전류, 가속 및 속도와 같은 설정을 조정하는 데 도움이 될 수 있습니다. 그냥 `GET_POSITION` 명령 사이에 일부 고속 이동을 실행.

Endstop 스위치는 약간 다른 위치에 트리거하는 경향이 있으므로, microsteps의 쌍의 차이는 endstop inaccuracies의 결과가 될 것입니다. 스테퍼 모터 자체는 4 개의 전체 단계의 증가에서 단계를 잃을 수 있습니다. (단, 16 마이크로 스텝을 사용한다면, 스텝퍼의 손실 단계는 "mcu:" 단계 카운터는 64 마이크로 스텝의 여러에 의해 해제됩니다.)

## 왜 Klipper 보고서 오류가 있습니까? 나는 내 인쇄를 잃었다!

짧은 대답: 우리는 우리의 인쇄 기계가 문제를 검출하는지 알고 싶습니다 그래서 underlying 문제점은 조정될 수 있고 우리는 중대한 질 인쇄를 얻어서 좋습니다. 우리는 절대적으로 저품질 인쇄를 생성하기 위하여 우리의 인쇄 기계를 원하지 않습니다.

긴 대답: Klipper는 자동적으로 많은 일시적인 문제를 해결하기 위하여 설계되었습니다. 예를 들어, 자동으로 통신 오류를 감지하고 재전송됩니다. 다중 레이어의 사전 및 버퍼 명령을 실행하여 간헐적 간섭과도 정확한 타이밍을 가능하게합니다. 그러나, 소프트웨어가에서 복구 할 수없는 오류를 감지해야, 그것이 잘못된 동작을 수행하기 위해 명령 된 경우, 또는 그것이 명령 된 작업을 수행 할 수없는 경우, Klipper는 오류를보고합니다. 이러한 상황에서는 낮은 품질의 인쇄 (또는 악화)를 생산하는 높은 위험이 있습니다. 사용자를 경고하는 것은 그(것)들을 강화하고 그(것)들의 인쇄의 전반적인 품질을 향상시키기 위하여 권한을 부여할 것입니다.

몇몇 관련 질문은 있습니다: 왜 Klipper가 대신 인쇄를 일시 중지하지 않습니까? 대신 경고를보고? 인쇄 전에 오류를 검사? 사용자 타입의 명령에 오류를 무시합니까? 기타 현재 Klipper는 G-Code 프로토콜을 사용하여 명령을 읽고, 불행히도 G-Code 명령 프로토콜은 오늘 이러한 대안을 만들기에 충분하지 않습니다. 비정상적인 이벤트 기간 동안 사용자 경험을 개선하는 개발자가 있지만, G-Code에서 비동기적 인프라 작업을 필요로 할 것으로 예상됩니다.

## 어떻게 최신 소프트웨어로 업그레이드합니까?

소프트웨어를 업그레이드하는 첫 단계는 최신 [config changes](Config_Changes.md) 문서를 검토하는 것입니다. 때때로 변경은 사용자가 소프트웨어 업그레이드의 일부로 설정을 업데이트하는 소프트웨어에 사용됩니다. 업그레이드하기 전에 이 문서를 검토하는 좋은 아이디어입니다.

할 때 준비하는 업그레이드는,일반적인 방법은 ssh 로 Raspberry Pi 및 실행:

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

다음 중 하나를 다시 컴파일할 수 있습 및 플래시 마이크로 컨트롤러 코드입니다. 예를 들어:

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

그러나,그것은 종종 경우에는 호스트 소프트웨어 변경합니다. 이 경우에 한 업데이트 할 수 있고 다시 시작 단지 호스트 소프트웨어와 함께:

```
cd ~/klipper
git pull
sudo service klipper restart
```

는 경우에 한 후 이것을 사용하기 소프트웨어에 대해 경고가 필요하여 재 플래시 마이크로 컨트롤러 또는 다른 비정상적인 오류가 발생한 후 전체 업그레이드는 단계를 설명한다.

오류가 지속되면 프린터 config 를 수정해야 할 수 있으므로 [config changes](Config_Changes.md)를 다시 확인하십시오.

참고는 다시 시작하고 FIRMWARE_RESTART g-코드는 명령어가 로드되지 않는 새로운 소프트웨어-소프트웨어"위 sudo 서비스 klipper 는 다시 시작"와"flash"명령에 필요한 소프트웨어 변경 내용이 적용됩니다.

## 을 어떻게 삭제하나요 klipper 는?

에서 확고한 상품 결국,어떤 것은 특별한 일이 필요합니다. 그냥 따라 깜박이는 방향에 대한 새로운 회사이 있는 소프트웨어입니다.

라즈베리 파이 쪽에서 제거 스크립트는 [scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh) 를 사용할 수 있습니다. 예를 들어:

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
