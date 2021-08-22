# 개요

Klipper 에 오신것을 환영합니다. Klipper를 처음 사용하는 경우라면 [features](Features.md) 및 [installation](Installation.md) 문서부터 시작하십시오.

## 개요 정보

- [특징들](Features.md): Klipper의 상위 수준 기능 목록.
- [자주하는 질문](FAQ.md): 자주 묻는 질문.
- [릴리즈 정보](Releases.md): 클리퍼 릴리즈 히스토리.
- [Config changes](Config_Changes.md): 사용자가 프린터 config 파일을 업데이트해야 할 수 있는 최근 소프트웨어 변경 사항.
- [연락처](Contact.md): 버그 보고 및 Klipper 개발자와의 일반적인 커뮤니케이션에 대한 정보.

## 설치 및 설정

- [설치](Installation.md): 클리퍼 설치 안내입니다.
- [Config Reference](Config_Reference.md): config 매개변수에 대한 설명.
   - [Rotation Distance](Rotation_Distance.md): rotation_distance 스테퍼 모터 매개변수 계산.
- [Config checks](Config_checks.md): cofnig 파일에서 기본 핀 설정 확인.
- [베드 레벨링](Bed_Level.md): Klipper의 "베드 레벨링"에 대한 정보.
   - [델타 캘리브레이션](Delta_Calibrate.md): 델타 방식 프린터 교정.
   - [프로브 캘리브레이션](Probe_Calibrate.md): 자동 Z 프로브 교정.
   - [BL-Touch](BLTouch.md): "BL-Touch" Z 프로브를 구성합니다.
   - [수동 레벨링](Manual_Level.md): Z 엔드스톱(및 유사)의 보정.
   - [베드 메쉬](Bed_Mesh.md): XY 위치를 기반으로 한 BED 높이 보정.
   - [Endstop phase](Endstop_Phase.md): 스테퍼 지원 Z 엔드스톱 포지셔닝.
- [Resonance compensation](Resonance_Compensation.md): 인쇄물에서 물결을 줄이는 도구.
   - [Measuring resonances](Measuring_Resonances.md): 공진을 측정하기 위해 adxl345 가속도계 하드웨어를 사용하는 방법에 대한 정보.
- [Pressure advance](Pressure_Advance.md): 익스트루더 압출 보정.
- [슬라이서](Slicers.md): Klipper용 "슬라이서" 소프트웨어 구성.
- [Command Templates](Command_Templates.md): G-Code 매크로 및 조건부 평가.
   - [Status Reference](Status_Reference.md): 매크로(및 유사)에 사용할 수 있는 정보.
- [TMC 드라이버](TMC_Drivers.md): Klipper와 함께 Trinamic 스테퍼 모터 드라이버 사용.
- [Skew correction](skew_correction.md): 축 틀어짐 보정.
- [PWM tools](Using_PWM_Tools.md): 레이저 또는 스핀들과 같은 PWM 제어 도구를 사용하는 방법에 대한 안내.
- [G-Codes](G-Codes.md): Klipper에서 지원하는 G-Code 대한 정보.

## 개발자 문서

- [코딩 개요](Code_Overview.md): 개발자라면 읽어야 하는 문서.
- [Kinematics](Kinematics.md): Klipper가 모션을 구현하는 방법에 대한 기술 세부 정보.
- [프로토콜](Protocol.md): 호스트와 마이크로 컨트롤러 간의 저수준 메시징 프로토콜에 대한 정보.
- [API 서버](API_Server.md): Klipper의 명령 및 제어 API에 대한 정보.
- [MCU 명령어](MCU_Commands.md): 마이크로 컨트롤러 소프트웨어에 구현된 저수준 명령에 대한 설명.
- [캔버스 프로토콜](CANBUS_protocol.md): Klipper CAN 버스 메시지 형식.
- [디버깅](Debugging.md): Klipper를 테스트하고 디버그하는 방법에 대한 정보.
- [벤치마크](Benchmarks.md): Klipper 벤치마크 방법에 대한 정보.
- [기여](CONTRIBUTING.md): 개선 사항을 Klipper에 제출하는 방법에 대한 정보.
- [패키징](Packaging.md): OS 패키지 빌드에 대한 정보.

## 기기별 문서

- [config 예제](Example_Configs.md): 예제 config 파일을 Klipper에 추가하는 방법에 대한 정보.
- [SDCard 업데이트](SDCard_Updates.md): sdcard 에 바이너리를 복사하여 마이크로 컨트롤러 펌웨어 업데이르 하는 방법.
- [Raspberry Pi as Micro-controller](RPi_microcontroller.md): Raspberry Pi의 GPIO 핀에 연결된 장치 제어에 대한 세부 정보.
- [Beaglebone](beaglebone.md): Beaglebone PRU에서 Klipper를 실행하는 방법에 대한 세부 정보.
- [브트로더](Bootloaders.md): 마이크로 컨트롤러 펌업에 대한 개발자 정보.
- [캔버스](CANBUS.md): Klipper에서 CAN 버스를 사용하는 방법에 대한 정보.
- [TSL1401CL filament width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [홀 필라멘트 너비 센서](HallFilamentWidthSensor.md)
