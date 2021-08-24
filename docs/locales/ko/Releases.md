# 릴리즈

Klipper 배포의 역사. Klipper 설치에 대한 정보는 [installation](Installation.md)을 참조하십시오.

## Klipper 0.9.0

20201020에 사용 가능. 이번 배포의 주요 변경 사항들:

* "Input Shaping" 지원 - 프린터 공명에 대응하는 메커니즘. 출력물의 "울림"을 감소시키거나 제거 할 수 있습니다.
* 새로운 "Smooth Pressure Advance" 시스템. 이것은 순간적인 속도 변화를 도입하지 않고 "압력 전진"을 개선한다. 그것은 "Tuning Tower"를 사용하여 압력 전진을 조정하는것도 가능합니다.
* 새로운 "webhooks" API 서버. 이것은 klipper에 대한 프로그래밍 가능한 JSON 인터페이스를 제공합니다.
* LCD 디스플레이와 메뉴는 Jinja2 템플릿 언어를 사용하여 구성할 수 있습니다.
* TMC2208 스테퍼 모터 드라이버는 klipper에서 "독립형" 모드로 사용될 수 있습니다.
* BL-Touch v3 지원이 개선되었습니다.
* USB 식별이 향상되었습니다. Klipper에는 이제 자체 USB 식별 코드를 가지고 있고, 마이크로 컨트롤러는 USB 식별 중 그들의 고유한 일련 번호를 보고할 수 있습니다.
* "Rotary Delta" 및 "CoreXZ" 프린터들에 대한 새로운 운동학적 지원.
* 마이크로 컨트롤러 개선: stm32f070 지원, stm32f207 지원, "Linux MCU"의 GPIO 핀 지원, stm32 "HID 부트로더" 지원, Chitu 부트로더 지원, MKS Robin 부트로더 지원.
* Python "쓰레기 수집" 이벤트 처리가 향상되었습니다.
* 많은 추가 모듈이 추가됨: adc_scaled, adxl345, bme280, display_status, extruder_stepper, fan_generic, Hall_filament_width_sensor, htu21d, homing_heaters, input_shaper, lm75, print_stats, resonance_tester, shaper_calibration, query_adc, graph_accelerometer, graph_extruder, graph_motion, graph_shaper, graph_temp_sensor, whconsole
* 여러 버그 수정 및 코드 정리.

### Klipper 0.9.1

20201028에서 사용 가능. 버그 수정만 포함된 배포.

## Klipper 0.8.0

20191021에서 사용 가능. 이번 배포의 주요 변경 사항:

* 새로운 G-Code 명령 템플릿 지원. 구성 파일의 G 코드는 이제 Jinja2 템플릿 언어로 평가됩니다.
* Trinamic 스테퍼 드라이버 개선 사항들:
   * TMC2209 및 TMC5160 드라이버에 대한 새로운 지원.
   * DUMP_TMC, SET_TMC_CURRENT 및 INIT_TMC G-Code 명령이 개선되었습니다.
   * 아날로그 mux로 다뤄지는 TMC UART 지원이 향상되었습니다.
* 향상된 호밍, 프로빙 및 베드 레벨링 지원:
   * 새로운 manual_probe, bed_screws, screws_tilt_adjust, skew_correction, safe_z_home 모듈들이 추가되었습니다.
   * 중앙값, 평균 및 재시도 논리가 포함된 다중 샘플 프로빙이 향상되었습니다.
   * BL-Touch, 프로브 교정, 엔드스톱 교정, 델타 캘리브레이션, 센서리스 원점 복귀 및 엔드스톱 위상 교정에 대한 문서 개선되었습니다.
   * 큰 Z축에 대한 원점 복귀 지원이 향상되었습니다.
* 많은 Klipper 마이크로 컨트롤러 개선 사항들:
   * Klipper 포팅: SAM3X8C, SAM4S8C, SAMD51, STM32F042, STM32F4
   * SAM3X, SAM4, STM32F4에서 새로운 USB CDC 드라이버 구현.
   * USB를 통해 깜박이는 Klipper에 대한 지원이 향상되었습니다.
   * 소프트웨어 SPI 지원.
   * LPC176x의 온도 필터링이 크게 향상되었습니다.
   * 초기 출력 핀 설정은 마이크로 컨트롤러에서 구성될 수 있습니다.
* Klipper 문서가 있는 새 웹사이트: http://klipper3d.org/
   * 이제 Klipper에 로고가 있습니다.
* Polar 및 "cable winch" 운동학에 대한 실험적 지원.
* 이제 구성 파일에 다른 구성 파일이 포함될 수 있습니다.
* 많은 추가 모듈이 추가되었습니다: board_pins, controller_fan, delay_gcode, dotstar, filament_switch_sensor, firmware_retraction, gcode_arcs, gcode_button, heater_generic, manual_stepper, mcp4018, mcp4728, 네오픽셀, pause_resume, 응답, temperature_sensor tsl1401cl_filament_width_sensor,tuning_tower
* 많은 추가 명령어들이 추가되었습니다: RESTORE_GCODE_STATE, SAVE_GCODE_STATE, SET_GCODE_VARIABLE, SET_HEATER_TEMPERATURE, SET_IDLE_TIMEOUT, SET_TEMPERATURE_FAN_TARGET
* 여러 버그 수정 및 코드 정리.

## Klipper 0.7.0

20181220에서 사용 가능. 이번 배포의 주요 변경 사항:

* Klipper는 이제 "메쉬" 베드 레벨링을 지원합니다
* "향상된" 델타 보정에 대한 새로운 지원(델타 프린터의 인쇄 x/y를 보정합니다)
* Trinamic 스테퍼 모터 드라이버의 런타임 구성 지원 (tmc2130, tmc2208, tmc2660)
* 향상된 온도 센서 지원: MAX6675, MAX31855, MAX31856, MAX31865, 맞춤형 서미스터, 일반 pt100 스타일 센서들
* 몇 가지 새로운 모듈들: temperature_fan, sx1509, force_move, mcp4451, z_tilt, quad_gantry_level, endstop_phase, bltouch
* 몇 가지 새로운 명령이 추가됨: SAVE_CONFIG, SET_PRESSURE_ADVANCE, SET_GCODE_OFFSET, SET_VELOCITY_LIMIT, STEPPER_BUZZ, TURN_OFF_HEATERS, M204, custom g-code macros
* 확장된 LCD 디스플레이 지원:
   * 런타임 메뉴 지원
   * 새로운 디스플레이 아이콘들
   * "uc1701" 및 "ssd1306" 디스플레이 지원
* 추가 마이크로 컨트롤러 지원:
   * Klipper 포팅: LPC176x (Smoothieboards), SAM4E8E (Duet2), SAMD21 (Arduino Zero), STM32F103 ("Blue pill" devices), atmega32u4
   * AVR, LPC176x, SAMD21, and STM32F103에 대해 구현된 새로운 일반 USB CDC 드라이버
   * ARM 프로세서의 성능 향상
* 운동학 코드는 "iterative solver"를 사용하도록 다시 작성되었습니다
* Klipper 호스트 소프트웨어를 위한 새로운 자동 테스트 케이스
* 일반적인 기성 프린터에 대한 많은 새로운 예제 구성 파일
* 부트로더, 벤치마킹, 마이크로 컨트롤러 포팅, 구성 검사, 핀 매핑, 슬라이서 설정, 패키징 등에 대한 문서 업데이트
* 여러 버그 수정 및 코드 정리

## Klipper 0.6.0

20180331에서 사용 가능. 이번 배포의 주요 변경 사항:

* 향상된 히터 및 서미스터 하드웨어 오류 검사
* Z 프로브 지원
* 델타에 대한 자동 매개변수 교정에 대한 초기 지원 (새로운 delta_calibration 명령을 통해)
* 베드 기울기 보정에 대한 초기 지원(bed_tilt_calibration 명령을 통해)
* "safe homing" 및 귀환 재정의에 대한 초기 지원
* RepRapDiscount 스타일 2004 및 12864 디스플레이에서 상태 표시에 대한 초기 지원
* 새로운 다중 압출기 개선 사항:
   * 공유 히터 지원
   * 이중 캐리지에 대한 초기 지원
* 축당 여러 스테퍼 구성 지원(예: 이중 Z)
* 사용자 디지털 및 pwm 출력 핀 지원(새로운 SET_PIN 명령어로)
* Klipper에서 직접 인쇄할 수 있는 "가상 sdcard"에 대한 초기 지원 (OctoPrint를 제대로 실행하기에는 너무 느린 장비들에 도움이 됨)
* 델타의 각 타워에 서로 다른 암 길이 설정 지원
* G-Code M220/M221 명령어 지원(속도 계수 재정의/압출 계수 재정의)
* 여러 문서 업데이트:
   * 일반적인 기성 프린터에 대한 많은 새로운 예제 구성 파일
   * 새로운 다중 MCU 구성 예제
   * 새로운 bltouch 센서 구성 예제
   * 새로운 FAQ, 구성 확인 및 G-Code 문서
* 모든 github 커밋에 대한 지속적인 통합 테스트를 위한 초기 지원
* 여러 버그 수정 및 코드 정리

## Klipper 0.5.0

20171025에서 사용 가능. 이번 배포의 주요 변경 사항:

* 여러 압출기들을 갖는 프린터 지원.
* Beaglebone PRU에서 실행하기 위한 초기 지원. Replicape 보드에 대한 초기 지원.
* 실시간 Linux 프로세스에서 마이크로 컨트롤러 코드를 실행하기 위한 초기 지원.
* 여러 마이크로 컨트롤러를 지원합니다. (예를 들어, 하나의 마이크로 컨트롤러로 압출기를 제어하고 다른 마이크로 컨트롤러로 나머지 프린터를 제어할 수 있습니다.) 소프트웨어 클록 동기화는 마이크로 컨트롤러 간의 작업을 조정하기 위해 구현됩니다.
* 스테퍼 성능 향상(20Mhz AVRs over 189K steps per second).
* 서보 제어 지원 및 노즐 냉각 팬 정의 지원.
* 여러 버그 수정 및 코드 정리

## Klipper 0.4.0

20170503에서 사용 가능. 이번 배포의 주요 변경 사항:

* Raspberry Pi 머신에서 설치가 개선되었습니다. 이제 대부분의 설치가 스크립트로 작성됩니다.
* corexy 운동학 지원
* 문서 업데이트: 새로운 Kinematics 문서, 새로운 Pressure Advance 조정 가이드, 새로운 예제 구성 파일 등
* 스테퍼 성능 향상 (20Mhz AVRs over 175K steps per second, Arduino Due over 460K)
* 자동 마이크로 컨트롤러 재설정 지원. Raspberry Pi에서 USB 전원 전환을 통한 재설정 지원.
* 압력 진행 알고리즘은 이제 코너링 중 압력 변화를 줄이기 위해 미리보기와 함께 작동합니다.
* 짧은 지그재그 이동의 최고 속도 제한 지원
* AD595 센서 지원
* 여러 버그 수정 및 코드 정리

## Klipper 0.3.0

20161223에서 사용 가능. 이번 배포의 주요 변경 사항:

* 개선된 문서
* 델타 운동학이 있는 로봇 지원
* Arduino Due 마이크로 컨트롤러(ARM cortex-M3) 지원
* USB 기반 AVR 마이크로 컨트롤러 지원
* "압력 진행" 알고리즘 지원 - 인쇄 중 노즐 흘러내림을 줄입니다.
* 새로운 "스테퍼 단계 기반 엔드스톱" 기능 - 엔드스톱 원점 복귀에서 더 높은 정밀도를 가능하게 합니다.
* "help", "restart" 및 "status"와 같은 "확장된 g-code" 명령 지원. 터미널에서 "다시 시작" 명령을 실행하여 Klipper 구성을 다시 로드하고 호스트 소프트웨어를 다시 시작하도록 지원합니다.
* 스테퍼 성능 개선 (20Mhz AVRs up to 158K steps per second).
* 향상된 오류 보고. 어떻게 해결해야하는 방법에 대한 도움말과 함께 대부분의 오류가 터미널을 통해 표시됩니다.
* 향상된 오류 보고. 어떻게 해결해야하는 방법에 대한 도움말과 함께 대부분의 오류가 터미널을 통해 표시됩니다.
* 여러 버그 수정 및 코드 정리

## Klipper 0.2.0

Klipper의 초기 릴리스. 20160525에서 사용 가능. 초기 배포에서 사용할 수 있는 주요 기능은 다음과 같습니다:

* 직교형 프린터에 대한 기본 지원(스테퍼, 압출기, 히팅 베드, 냉각 팬).
* 일반적인 g-code 명령을 지원. OctoPrint와의 인터페이스 지원.
* 가속 및 예견 처리
* 표준 직렬 포트를 통한 AVR 마이크로 컨트롤러 지원
