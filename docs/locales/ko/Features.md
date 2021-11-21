# Features

Klipper 에는 다음과 같이 몇가지 매력적인 기능이 있습니다:

* 고정밀 스테퍼 동작. Klipper 는 3D 프린터의 움직임을 계산할 때 라즈베리파이 같은 저렴한 애플리케이션 프로세서를 활용합니다. 애플리케이션 프로세서는 각 스테퍼 모터를 언제 움직여야 하는지 결정하고 해당 이벤트를 압축하여 마이크로 컨트롤러에 전송한 다음 마이크로 컨트롤러가 요청된 시간에 각 이벤트를 실행합니다. 각 스테퍼 이벤트는 25 마이크로초 이상의 정밀도로 스케줄링 됩니다. 소프트웨어는 운동학적 추정(예: Bresenham 알고리즘)을 사용하지 않습니다. 대신 가속 물리학 및 기계 운동학 물리학을 기반으로 정확한 단계 시간을 계산합니다. 더 정밀한 스테퍼 움직임은 더 조용하고 안정적인 프린터 작동으로 이어집니다.
* Best in class performance. Klipper is able to achieve high stepping rates on both new and old micro-controllers. Even old 8bit micro-controllers can obtain rates over 175K steps per second. On more recent micro-controllers, several million steps per second are possible. Higher stepper rates enable higher print velocities. The stepper event timing remains precise even at high speeds which improves overall stability.
* Klipper는 다수개의 마이크로 컨트롤러가 있는 프린터를 지원합니다. 예를 들어, 하나의 마이크로 컨트롤러는 익스트루더를 제어하는데 사용되고 다른 하나는 프린터의 히터를 제어하고 세 번째는 나머지 프린터를 제어하는데 사용할 수 있습니다. Klipper 호스트 소프트웨어는 마이크로 컨트롤러간의 클럭 드리프트를 계산하기 위해 클록 동기화를 구현합니다.여러 마이크로 컨트롤러를 활성화하는데 특별한 코드는 필요하지 않습니다. 구성 파일에 몇 줄만 추가하면 됩니다.
* 간단한 config 파일을 통한 구성. 설정을 변경하기 위해 마이크로 컨트롤러를 다시 펌웨어 업데이트할 필요가 없습니다. Klipper의 모든 구성은 쉽게 편집할 수 있는 표준 config 파일에 저장됩니다. 이렇게 하면 하드웨어를 더 쉽게 설정하고 유지 관리할 수 있습니다.
* Klipper는 익스트루더 내에 압력의 영향을 설명하는 메커니즘인 "Smooth Pressure Advance"를 지원합니다. 이것은 익스트루더의 "노즐 흘러내림" 을 줄이고 인쇄 모서리의 품질을 향상시킵니다. Klipper의 구현은 전반적인 안정성과 견고성을 향상시키는 즉각적인 익스트루더 속도 변경을 도입하지 않습니다.
* Klipper는 인쇄 품질에 대한 진동의 영향을 줄이기 위해 "Input Shaping"을 지원합니다. 이렇게 하면 인쇄물에서 "진동형 무늬" ("고스팅", "에코잉" 또는 "리플링"이라고도 함)을 줄이거나 제거할 수 있습니다. 또한 높은 인쇄 품질을 유지하면서 더 빠른 인쇄 속도를 얻을 수 있습니다.
* Klipper는 "iterative solver"를 사용하여 간단한 운동 방정식에서 정확한 단계 시간을 계산합니다. 이를 통해 Klipper를 새로운 유형의 로봇에 쉽게 이식할 수 있으며 복잡한 운동학에서도 정확한 타이밍을 유지할 수 있습니다("Line segmentation" 이 필요하지 않음).
* 이식 가능한 코드. Klipper는 ARM, AVR 및 PRU 기반 마이크로 컨트롤러에서 작동합니다. 기존 "reprap" 스타일 프린터는 하드웨어 수정 없이 Klipper를 실행할 수 있습니다. Raspberry Pi를 추가하기만 하면 됩니다. Klipper의 내부 코드 레이아웃을 통해 다른 마이크로 컨트롤러 아키텍처도 쉽게 지원할 수 있습니다.
* 더 간단한 코드. Klipper는 대부분의 코드에 대해 매우 높은 수준의 언어(Python)를 사용합니다. 운동학 알고리즘, gcode 해석, 가열 및 온도센서 알고리즘 등은 모두 Python으로 작성되었습니다. 이를 통해 새로운 기능을 더 쉽게 개발할 수 있습니다.
* 사용자 정의 가능한 매크로. 새로운 gcode 명령을 프린터 구성 파일에서 정의할 수 있습니다 (코드 변경이 필요하지 않음). 이러한 명령은 프로그래밍할 수 있으므로 프린터 상태에 따라 다른 작업을 생성할 수 있습니다.
* 내장 API 서버. 표준 gcode 인터페이스 외에도 Klipper는 풍부한 JSON 기반 애플리케이션 인터페이스를 지원합니다. 이를 통해 프로그래머는 프린터를 세부적으로 제어하여 외부 응용 프로그램을 구축할 수 있습니다.

## Additional features

Klipper는 다양한 표준 3D 프린터 기능을 지원합니다:

* Octoprint와 함께 작동합니다. 이를 통해 웹 브라우저를 사용하여 프린터를 제어할 수 있습니다. Raspberry Pi 에서도 Klipper 와 Octoprint를 실행할 수 있습니다.
* Standard G-Code support. Common g-code commands that are produced by typical "slicers" (SuperSlicer, Cura, PrusaSlicer, etc.) are supported.
* 멀티 익스트루더를 지원합니다. 히터를 공유하는 익스트루더 방식 및 독립 캐리지 상의 익스트루더(IDEX) 방식도 지원됩니다.
* Support for cartesian, delta, corexy, corexz, hybrid-corexy, hybrid-corexz, rotary delta, polar, and cable winch style printers.
* 오토 베드 레벨링 지원. Klipper는 기본적으로 베드 기울기 감지 또는 전체 메쉬 베드 레벨링을 위해 구성할 수 있습니다. 여러 개의 Z축 스테퍼 모터를 사용하는 경우 Klipper는 각각의 Z축 모터를 독립적으로 조작하여 수평을 맞출 수도 있습니다. BL-Touch 프로브 및 서보 활성화 프로브를 포함하여 대부분의 Z 높이 프로브가 지원됩니다.
* 오토 델타 캘리브레이션 지원. 자동으로 델타 프린터의 높이 보정과 향상된 X 및 Y 치수 보정을 수행할 수 있습니다. 보정은 Z 높이 프로브 또는 수동 프로빙을 통해 수행할 수 있습니다.
* Support for common temperature sensors (eg, common thermistors, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20, and LM75). Custom thermistors and custom analog temperature sensors can also be configured. One can monitor the internal micro-controller temperature sensor and the internal temperature sensor of a Raspberry Pi.
* 온도 안전장치 기본적으로 thermal protection 이 활성화되어 있습니다.
* Support for standard fans, nozzle fans, and temperature controlled fans. No need to keep fans running when the printer is idle. Fan speed can be monitored on fans that have a tachometer.
* TMC2130, TMC2208/TMC2224, TMC2209, TMC2660 및 TMC5160 스테퍼 모터 드라이버의 런타임 구성 지원. AD5206, MCP4451, MCP4728, MCP4018 및 PWM 핀을 통한 기존 스테퍼 드라이버의 전류 제어도 지원합니다.
* 프린터에 직접 연결된 일반 LCD 디스플레이를 지원합니다. 기본 메뉴도 있습니다. 디스플레이 및 메뉴의 내용은 config 파일을 통해 완전히 사용자가 정의할 수 있습니다.
* 일정한 가속 및 "look-ahead" 지원. 모든 프린터의 이동은 정지 상태에서 점차 가속되었다가 다시 정지 상태로 감속됩니다. 읽어들이는 gcode 는 순서대로 쌓이고 분석됩니다. 같은 방향으로 이동 할때는 가/감속을 하지 않고 인쇄 시간을 개선하기 위해 최적화됩니다.
* 스테퍼 위상 엔드스톱 지원. Klipper는 일반적인 엔드스톱 스위치의 정확도를 향상시킬 수 있는 "스테퍼 위상 엔드스톱" 알고리즘을 구현합니다. 적절히 튜닝하면 첫 레이어 베드 접착력을 향상시킬 수 있습니다.
* Support for filament presence sensors, filament motion sensors, and filament width sensors.
* adxl345 가속도계를 사용한 가속도 측정 및 기록 지원.
* 짧은 "지그재그" 이동의 최고 속도 제한을 지원하여 프린터 진동과 소음을 줄입니다. 자세한 내용은 [kinematics](Kinematics.md) 문서를 참조하십시오.
* 다양한 프린터를 지원하기 위해 sample config 파일을 제공합니다. [config directory](../config/) 디렉토리를 확인하십시오.

Klipper를 시작하려면 [설치](Installation.md) 가이드를 읽으십시오.

## Step Benchmarks

다음은 스테퍼 모터의 성능 테스트 결과입니다. 표시된 숫자는 마이크로 컨트롤러에서 초당 총 스텝수를 나타냅니다.

| Micro-controller | 1 stepper active | 3 steppers active |
| --- | --- | --- |
| 16Mhz AVR | 157K | 99K |
| 20Mhz AVR | 196K | 123K |
| Arduino Zero (SAMD21) | 686K | 471K |
| STM32F042 | 814K | 578K |
| Beaglebone PRU | 866K | 708K |
| "Blue Pill" (STM32F103) | 1180K | 818K |
| Arduino Due (SAM3X8E) | 1273K | 981K |
| Duet2 Maestro (SAM4S8C) | 1690K | 1385K |
| Smoothieboard (LPC1768) | 1923K | 1351K |
| Smoothieboard (LPC1769) | 2353K | 1622K |
| Raspberry Pi Pico (RP2040) | 2400K | 1636K |
| Duet2 Wifi/Eth (SAM4E8E) | 2500K | 1674K |
| Adafruit Metro M4 (SAMD51) | 3077K | 1885K |
| BigTreeTech SKR Pro (STM32F407) | 3652K | 2459K |
| Fysetc Spider (STM32F446) | 3913K | 2634K |

Further details on the benchmarks are available in the [Benchmarks document](Benchmarks.md).
