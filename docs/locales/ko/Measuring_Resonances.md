# 공진 측정

Klipper는 다양한 축에 대한 프린터의 공진 주파수를 측정하는 데 사용할 수 있는 ADXL345 가속도계를 기본적으로 지원하고 공진을 보상하기 위해 [input shapers](Resonance_Compensation.md) 를 자동 조정합니다. ADXL345 를 사용하려면 약간의 납땜 및 압착이 필요합니다. ADXL345는 Raspberry Pi에 직접 연결하거나 MCU 보드의 SPI 인터페이스에 연결할 수 있습니다 (빠른 속도가 필요하기 때문에).

ADLX345를 구입할 때 다양한 PCB 보드 디자인과 다양한 복제품이 있다는 점에 유의하십시오. 보드가 SPI 모드를 지원하는지 확인하십시오 (어떤 보드는 SDO 를 GND 로 당겨서 I2C 에 대해 하드 구성되어 있는 것으로 나타남). 그리고 5V 프린터 MCU 에 연결하려는 경우 전압 레귤레이터 및 레벨 시프터가 필요할 수 있습니다.

## 설치 방법

### 배선

SPI 를 통해 ADXL345 를 Raspberry Pi에 연결해야 합니다. ADXL345 문서에서 제안하는 I2C 연결은 처리량이 너무 낮아 **작동하지 않습니다**. 권장 연결 방식:

| ADXL345 핀 | RPi 핀 | RPi 핀 이름 |
| :-: | :-: | :-: |
| 3V3 (또는 VCC) | 01 | 3.3v 직류 전원 |
| GND | 06 | Ground |
| CS | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

ADXL345 보드에 대한 Fritzing 배선 다이어그램:

![ADXL345-Rpi](img/adxl345-fritzing.png)

Raspberry Pi 또는 가속도계의 손상을 방지하기 위해 Raspberry Pi의 전원을 켜기 전에 배선을 다시 확인하십시오.

### 가속도계 장착

가속도계는 툴헤드에 부착되어야 합니다. 자신의 3D 프린터에 맞는 적절한 마운트를 설계해야 합니다. 가속도계의 축을 프린터의 축과 정렬하는 것이 좋습니다 (그러나 더 편리하게 만들면 축을 바꿀 수 있습니다. 즉, X축을 X와 정렬할 필요가 없습니다. Z축이 다음과 같아도 괜찮습니다. 가속도계는 프린터의 X축 등).

SmartEffector 에 ADXL345 를 장착하는 예:

![ADXL345 on SmartEffector](img/adxl345-mount.jpg)

BED Slingers 프린터에서 하나는 2개의 마운트를 설계해야 합니다. 하나는 헤드용, 다른 하나는 베드용이고 측정을 두 번 실행합니다. 자세한 내용은 해당 [section](#bed-slinger-printers) 을 참조하세요.

**주의:** 가속도계와 이를 고정하는 나사가 프린터의 금속 부분에 닿지 않도록 하십시오. 기본적으로 마운트는 프린터 프레임에서 가속도계의 전기적 절연을 보장하도록 설계되어야 합니다. 시스템에 접지가 되지 않으면 전자장치를 손상시킬 수 있습니다.

### 소프트웨어 설치

공진 측정 및 셰이퍼 자동 보정에는 기본적으로 설치가 필요한 소프트웨어가 있습니다. 먼저 Raspberry Pi에서 다음 명령을 실행해야 합니다:

```
~/klippy-env/bin/pip install -v numpy
```

`numpy` 패키지를 설치합니다. CPU 성능에 따라 최대 10-20분까지 *많은* 시간이 소요될 수 있습니다. 인내심을 갖고 설치가 완료될 때까지 기다리십시오. 경우에 따라 보드에 RAM이 너무 적으면 설치에 실패할 수 있으며 스왑을 활성화해야 합니다.

그런 다음 동일한 명령을 사용하여 설치 하십시오:

```
sudo apt update
sudo apt install python-numpy python-matplotlib
```

이후 [RPi Microcontroller document](RPi_microcontroller.md) 의 지시사항에 따라 라즈베리파이에 "linux mcu"를 설정합니다.

`sudo raspi-config` 를 실행하고 "Interfacing options" 메뉴에서 SPI를 활성화하여 Linux SPI 드라이버가 활성화되어 있는지 확인합니다.

다음을 printer.cfg 파일에 추가합니다:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None

[resonance_tester]
accel_chip: adxl345
probe_points:
    100,100,20  # an example
```

프린터 BED 중간, 약간 위에서 프로브 포인트 1개로 시작하는 것이 좋습니다.

`RESTART` 명령을 통해 Klipper를 다시 시작하십시오.

## 공진 측정

### 설정 확인

이제 연결을 테스트할 수 있습니다.

- "non bed-slingers"(예: 가속도계 1개) 의 경운 Octoprint에 `ACCELEROMETER_QUERY` 를 입력하세요
- "bed-slingers" (예: 둘 이상의 가속도계) 의 경우 `ACCELERROMETER_QUERY CHIP=<chip>`을 입력합니다. 여기서 `<chip>`은 입력된 칩의 이름입니다. 예: 설치된 가속도 칩에 대해 `CHIP=bed`(참조: [bed-slinger](#bed-slinger-printers)).

자유 낙하 가속도를 포함하여 가속도계의 현재 측정값이 표시되어야 합니다. 예는 아래와 같습니다.

```
Recv: // adxl345 values (x, y, z): 470.719200, 941.438400, 9728.196800
```

`Invalid adxl345 id (got xx vs e5)` 와 같은 오류가 발생하면 (여기서 'xx'는 다른 ID임) ADXL345의 연결 문제 또는 센서 결함을 나타냅니다. 전원, 배선(회로도와 일치하는지, 와이어가 끊어지거나 느슨하지 않은지 등) 및 납땜 품질을 다시 확인하십시오.

다음으로 Octoprint에서 `MEASURE_AXES_NOISE`를 실행해 보십시오. 축의 가속도계 노이즈에 대한 기준 수치를 얻어야 합니다 (~1-100 범위 어딘가에 있어야 함). 너무 높은 축 노이즈(예: 1000개 이상)는 센서 문제, 전원 문제 또는 3D 프린터의 너무 시끄러운 팬이 원인일 수 있습니다.

### 공진 측정

이제 실제 테스트를 실행할 수 있습니다. 다음 명령을 실행합니다:

```
TEST_RESONANCES AXIS=X
```

X축에 진동을 생성합니다. 또한 입력 셰이퍼가 활성화된 상태에서 공진 테스트를 실행하는 것이 유효하지 않기 때문에 이전에 활성화된 경우 입력 셰이핑을 비활성화합니다.

**주의!** 진동이 너무 심하지 않도록 프린터를 처음 관찰해야 합니다('M112' 명령은 비상시 테스트를 중단하는 데 사용할 수 있습니다. 그러나 이것은 자주 사용되지 않았으면 합니다). 진동이 너무 강해지면 `[resonance_tester]` 섹션에서 `accel_per_hz` 매개변수의 기본값보다 낮은 값을 지정할 수 있습니다. 예를 들어.

```
[resonance_tester]
accel_chip: adxl345
accel_per_hz: 50  # default is 75
probe_points: ...
```

X축에 대해 작동하는 경우 Y축에 대해서도 실행합니다:

```
TEST_RESONANCES AXIS=Y
```

이렇게 하면 2개의 CSV 파일 (`/tmp/resonances_x_*.csv` 및 `/tmp/resonances_y_*.csv`) 이 생성됩니다. This will generate 2 CSV files (`/tmp/resonances_x_*.csv` and `/tmp/resonances_y_*.csv`). 이 파일들은 Raspberry Pi 에서 독립 실행형 스크립트로 처리할 수 있습니다. 그렇게 하려면 다음 명령을 실행하십시오:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

이 스크립트는 주파수 응답과 함께 `/tmp/shaper_calibration_x.png` 및 `/tmp/shaper_calibration_y.png` 차트를 생성합니다. 또한 각 입력 셰이퍼에 대해 제안된 주파수와 설정에 권장되는 입력 셰이퍼를 얻을 수 있습니다. 예를 들어:

![Resonances](img/calibrate-y.png)

```
Fitted shaper 'zv' frequency = 34.4 Hz (vibrations = 4.0%, smoothing ~= 0.132)
To avoid too much smoothing with 'zv', suggested max_accel <= 4500 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 0.0%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 41.4 Hz (vibrations = 0.0%, smoothing ~= 0.188)
To avoid too much smoothing with 'ei', suggested max_accel <= 3200 mm/sec^2
Fitted shaper '2hump_ei' frequency = 51.8 Hz (vibrations = 0.0%, smoothing ~= 0.201)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 61.8 Hz (vibrations = 0.0%, smoothing ~= 0.215)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2800 mm/sec^2
Recommended shaper is mzv @ 34.6 Hz
```

제안된 구성은 `printer.cfg`의 `[input_shaper]` 섹션에 추가할 수 있습니다. 예:

```
[input_shaper]
shaper_freq_x: ...
shaper_type_x: ...
shaper_freq_y: 34.6
shaper_type_y: mzv

[printer]
max_accel: 3000  # should not exceed the estimated max_accel for X and Y axes
```

또는 생성된 차트를 기반으로 다른 구성을 직접 선택할 수 있습니다. 차트의 전력 스펙트럼 밀도 피크는 프린터의 공진 주파수에 해당합니다.

Klipper에서 [directly](#input-shaper-auto-calibration) 입력 셰이퍼 자동 보정을 실행하는게 편리할 수 있습니다, 예를 들어 입력 셰이퍼의 경우 [re-calibration](#input-shaper-re-calibration) 을 사용합니다.

### Bed-slinger 프린터

프린터가 bed slinger 프린터인 경우 X축과 Y축 측정 사이에 가속도계의 위치를 변경해야 합니다. 툴 헤드에 부착된 가속도계로 X축의 공명과 Y축의 공진을 측정합니다. BED (일반적인 bed slinger 설정).

그러나 두 개의 가속도계를 동시에 연결할 수도 있지만 서로 다른 보드(예: RPi 및 프린터 MCU 보드)에 연결하거나 동일한 보드에 있는 두 개의 서로 다른 물리적 SPI 인터페이스(드물게 사용 가능)에 연결해야 합니다. 그런 다음 다음과 같은 방식으로 구성할 수 있습니다:

```
[adxl345 hotend]
# Assuming `hotend` chip is connected to an RPi
cs_pin: rpi:None

[adxl345 bed]
# Assuming `bed` chip is connected to a printer MCU board
cs_pin: ...  # Printer board SPI chip select (CS) pin

[resonance_tester]
# Assuming the typical setup of the bed slinger printer
accel_chip_x: adxl345 hotend
accel_chip_y: adxl345 bed
probe_points: ...
```

그런 다음 `TEST_RESONANCES AXIS=X` 및 `TEST_RESONANCES AXIS=Y` 명령을 각 축 가속도계에 사용합니다.

### Max smoothing

입력 셰이퍼는 부분에 약간의 smoothing을 생성할 수 있습니다. `calibration_shaper.py` 스크립트 또는 `SHAPER_CALIBRATE` 명령에 의해 수행되는 입력 셰이퍼의 자동 조정은 smoothing을 악화시키지 않으려고 시도합니다, 그러나 동시에 그들은 결과적인 진동을 최소화하려고 노력합니다. 때때로 그들은 셰이퍼 주파수의 차선책을 선택하거나 더 큰 잔여 진동을 희생시키면서 부품의 smoothing을 줄이는 것을 선호할 수 있습니다. 이러한 경우 입력 셰이퍼에서 최대 스무딩을 제한하도록 요청할 수 있습니다.

자동 튜닝의 결과를 다음과 같이 가정해 보겠습니다:

![Resonances](img/calibrate-x.png)

```
Fitted shaper 'zv' frequency = 57.8 Hz (vibrations = 20.3%, smoothing ~= 0.053)
To avoid too much smoothing with 'zv', suggested max_accel <= 13000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.8 Hz (vibrations = 3.6%, smoothing ~= 0.168)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3600 mm/sec^2
Fitted shaper 'ei' frequency = 48.8 Hz (vibrations = 4.9%, smoothing ~= 0.135)
To avoid too much smoothing with 'ei', suggested max_accel <= 4400 mm/sec^2
Fitted shaper '2hump_ei' frequency = 45.2 Hz (vibrations = 0.1%, smoothing ~= 0.264)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2200 mm/sec^2
Fitted shaper '3hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.356)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 1500 mm/sec^2
Recommended shaper is 2hump_ei @ 45.2 Hz
```

보고된 `smoothing` 값은 일부 추상적으로 투영 값입니다. 이 값은 다양한 구성을 비교하는 데 사용할 수 있습니다. 값이 높을수록 셰이퍼가 더 부드럽게 만듭니다. 그러나 이러한 smoothing 점수는 smoothing 의 실제 측정을 나타내지 않습니다. 실제 smoothing 은 [`max_accel`](#selecting-max-accel) 및 `square_corner_velocity` 매개변수에 의존하기 때문입니다. 따라서 선택한 구성이 정확히 얼마나 스무딩을 생성하는지 확인하려면 몇 가지 테스트 인쇄를 인쇄해야 합니다.

위의 예에서 제안된 셰이퍼 매개변수는 나쁘지 않지만 만약 X축에서 스무딩을 줄이고 싶다면? 다음 명령을 사용하여 최대 셰이퍼 smoothing 을 제한할 수 있습니다:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```

smoothing을 0.2 점수로 제한합니다. 이제 다음과 같은 결과를 얻을 수 있습니다:

![Resonances](img/calibrate-x-max-smoothing.png)

```
Fitted shaper 'zv' frequency = 55.4 Hz (vibrations = 19.7%, smoothing ~= 0.057)
To avoid too much smoothing with 'zv', suggested max_accel <= 12000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 3.6%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 48.2 Hz (vibrations = 4.8%, smoothing ~= 0.139)
To avoid too much smoothing with 'ei', suggested max_accel <= 4300 mm/sec^2
Fitted shaper '2hump_ei' frequency = 52.0 Hz (vibrations = 2.7%, smoothing ~= 0.200)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 72.6 Hz (vibrations = 1.4%, smoothing ~= 0.155)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 3900 mm/sec^2
Recommended shaper is 3hump_ei @ 72.6 Hz
```

앞서 제안한 파라미터와 비교하면 진동은 조금 더 크지만 이전보다 스무딩이 현저히 작아 최대 가속도가 더 커졌습니다.

선택할 `max_smoothing` 매개변수를 결정할 때 시행착오를 거칠 수 있습니다. 몇 가지 다른 값을 시도하고 어떤 결과를 얻을 수 있는지 확인하십시오. 입력 셰이퍼에 의해 생성된 실제 smoothing 은 주로 프린터의 가장 낮은 공진 주파수에 따라 달라집니다. 가장 낮은 공진의 주파수가 높을수록 smoothing이 작아집니다. 따라서 비현실적으로 작은 smoothing 으로 입력 셰이퍼의 구성을 찾도록 스크립트를 요청하는 경우 가장 낮은 공명 주파수(일반적으로 인쇄물에서도 더 두드러지게 나타남) 에서 링잉이 증가하게 됩니다. 따라서 스크립트에서 보고한 예상 잔여 진동을 항상 다시 확인하고 너무 높지 않은지 확인하십시오.

두 축에 대해 좋은 `max_smoothing` 값을 선택했다면 `printer.cfg`에 다음과 같이 저장할 수 있습니다

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # an example
```

그런 다음 나중에 `SHAPER_CALIBRATE` Klipper 명령을 사용하여 입력 shaper 자동 튜닝을 [rerun](#input-shaper-re-calibration) 실행하면 저장된 `max_smoothing` 값을 참조로 사용합니다.

### max_accel 선택

입력 셰이퍼는 특히 높은 가속에서 부품에 약간의 smoothing 을 생성할 수 있으므로 인쇄된 부품에 너무 많은 smoothing 을 생성하지 않는 'max_accel' 값을 선택해야 합니다. 보정 스크립트는 smoothing을 너무 많이 생성하지 않아야 하는 'max_accel' 매개변수에 대한 추정치를 제공합니다. 보정 스크립트에 의해 표시되는 'max_accel'은 각 셰이퍼가 너무 많은 smoothing 을 생성하지 않고 여전히 작동할 수 있는 이론적인 최대값일 뿐입니다. 인쇄를 위해 이 가속을 설정하는 것은 결코 권장되지 않습니다. 프린터가 유지할 수 있는 최대 가속도는 기계적 특성과 사용된 스테퍼 모터의 최대 토크에 따라 다릅니다. 따라서 `[printer]` 섹션에서 `max_accel` 을 X 및 Y축의 예상 값을 초과하지 않도록 설정하는 것이 좋습니다. 약간의 보수적인 안전 제한이 있을 수 있습니다.

또는 입력 셰이퍼 튜닝 가이드의 [this](Resonance_Compensation.md#selecting-max_accel) 부분을 따르고 테스트 모델을 인쇄하여 `max_accel` 매개변수를 실험적으로 선택합니다.

동일한 알림이 `SHAPER_CALIBRATE` 명령을 사용하여 입력 셰이퍼 [auto-calibration](#input-shaper-auto-calibration) 에 적용됩니다: 자동 보정 후에도 올바른 `max_accel` 값을 선택해야 하며 제안된 가속 제한은 자동으로 적용되지 않습니다.

만약 셰이퍼 재보정을 수행하고 제안된 셰이퍼 구성에 대해 보고된 smoothing 이 이전 보정 중에 얻은 것과 거의 동일한 경우 이 단계를 건너뛸 수 있습니다.

### 사용자 정의 축 테스트

`TEST_RESONANCES` 명령은 사용자 지정 축을 지원합니다. 이것은 입력 셰이퍼 보정에 실제로 유용하지 않지만 프린터 공진을 심층적으로 연구하고 예를 들어 벨트 장력을 확인하는 데 사용할 수 있습니다.

CoreXY 프린터의 벨트 장력을 확인하려면 다음을 실행하십시오

```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```

생성된 파일을 처리하기 위해 `graph_accelerometer.py`를 사용합니다, 예들들어.

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

이것은 공명을 비교하는 `/tmp/resonances.png`를 생성합니다.

기본 타워 배치(타워 A ~= 210도, B ~= 330도 및 C ~= 90도)가 있는 Delta 프린터의 경우 다음을 실행합니다

```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```

그런 다음 동일한 명령을 사용하십시오

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

그러면 공명을 비교하는 `/tmp/resonances.png`를 생성합니다.

## 사용자 정의 축 테스트

입력 셰이퍼 기능에 대한 적절한 매개변수를 수동으로 선택하는 것 외에도 Klipper에서 직접 입력 셰이퍼에 대한 자동 조정을 실행할 수도 있습니다. Octoprint 터미널을 통해 다음 명령을 실행합니다:

```
SHAPER_CALIBRATE
```

그러면 두 축에 대한 전체 테스트가 실행되고 주파수 응답 및 제안된 입력 셰이퍼에 대한 csv 출력 (기본적으로 `/tmp/calibration_data_*.csv`) 이 생성됩니다. 또한 Octoprint 콘솔에서 각 입력 셰이퍼에 대해 제안된 주파수와 설정에 권장되는 입력 셰이퍼를 얻을 수 있습니다. 예를 들어:

```
Calculating the best input shaper parameters for y axis
Fitted shaper 'zv' frequency = 39.0 Hz (vibrations = 13.2%, smoothing ~= 0.105)
To avoid too much smoothing with 'zv', suggested max_accel <= 5900 mm/sec^2
Fitted shaper 'mzv' frequency = 36.8 Hz (vibrations = 1.7%, smoothing ~= 0.150)
To avoid too much smoothing with 'mzv', suggested max_accel <= 4000 mm/sec^2
Fitted shaper 'ei' frequency = 36.6 Hz (vibrations = 2.2%, smoothing ~= 0.240)
To avoid too much smoothing with 'ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '2hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.234)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '3hump_ei' frequency = 59.0 Hz (vibrations = 0.0%, smoothing ~= 0.235)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2500 mm/sec^2
Recommended shaper_type_y = mzv, shaper_freq_y = 36.8 Hz
```

제안된 매개변수에 동의하면 지금 `SAVE_CONFIG` 를 실행하여 저장하고 Klipper를 다시 시작할 수 있습니다. 이것은 `[printer]` 섹션의 `max_accel` 값을 업데이트하지 않습니다. [Selecting max_accel](#selecting-max_accel) 섹션을 수동으로 업데이트해야 합니다.

프린터가 bed slinger 프린터인 경우 테스트할 축을 지정할 수 있으므로 테스트 사이에 가속도계 장착 지점을 변경할 수 있습니다 (기본적으로 테스트는 두 축 모두에 대해 수행됨):

```
SHAPER_CALIBRATE AXIS=Y
```

각 축을 보정한 후 `SAVE_CONFIG`를 두 번 실행할 수 있습니다.

그러나 두 개의 가속도계를 동시에 연결한 경우 축을 지정하지 않고 `SHAPER_CALIBRATE`를 실행하여 두 축에 대한 입력 셰이퍼를 한 번에 보정하기만 하면 됩니다.

### Input Shaper 재보정

`SHAPER_CALIBRATE` 명령은 향후 입력 셰이퍼를 다시 보정하는 데 사용할 수도 있습니다. 특히 운동학에 영향을 줄 수 있는 프린터 변경 사항이 있는 경우 더욱 그렇습니다. `SHAPER_CALIBRATE` 명령을 사용하여 전체 보정을 다시 실행하거나 다음과 같이 `AXIS=` 매개변수를 제공하여 자동 보정을 단일 축으로 제한할 수 있습니다

```
SHAPER_CALIBRATE AXIS=X
```

**경고!** 셰이퍼 자동 보정을 매우 자주 실행하지 않는 것이 좋습니다 (예: 인쇄할 때마다 또는 매일). 공진 주파수를 결정하기 위해 자동 보정은 각 축에 집중적인 진동을 생성합니다. 일반적으로 3D 프린터는 공진 주파수 근처의 진동에 장기간 노출되는 것을 견디도록 설계되지 않았습니다. 그렇게 하면 프린터 구성 요소의 마모가 증가하고 수명이 단축될 수 있습니다. 또한 일부 부품이 풀리거나 느슨해질 위험이 증가합니다. 각 자동 조정 후에 프린터의 모든 부품 (일반적으로 움직이지 않는 부품 포함) 이 제자리에 단단히 고정되어 있는지 항상 확인하십시오.

또한 측정의 일부 노이즈로 인해 조정 결과가 교정 실행마다 약간 다를 수 있습니다. 그러나 노이즈가 인쇄 품질에 너무 많은 영향을 줄 것으로 예상되지는 않습니다. 그러나 여전히 제안된 매개변수를 다시 확인하고 테스트 인쇄물을 인쇄하여 사용하기 전에 양호한지 확인하는 것이 좋습니다.

## 가속도계 데이터의 오프라인 처리

예를 들어 공진을 찾기 위해 원시 가속도계 데이터를 생성하고 오프라인으로(예: 호스트 머신에서) 처리할 수 있습니다. 그렇게 하려면 Octoprint 터미널을 통해 다음 명령을 실행하십시오:

```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```

`SET_INPUT_SHAPER` 명령에 대한 오류를 무시합니다. `TEST_RESONANCES` 명령의 경우 원하는 테스트 축을 지정합니다. 원시 데이터는 RPi의 `/tmp` 디렉토리에 기록됩니다.

원시 데이터는 정상적인 프린터 활동 중에 `ACCELEROMETER_MEASURE` 명령을 두 번 실행하여 얻을 수도 있습니다. 먼저 측정을 시작한 다음 측정을 중지하고 출력 파일을 작성합니다. 자세한 내용은 [G-Codes](G-Codes.md#adxl345-accelerometer-commands) 를 참조하세요.

데이터는 나중에 다음 스크립트로 처리할 수 있습니다: `scripts/graph_accelerometer.py` 및 `scripts/calibrate_shaper.py`. 둘 다 모드에 따라 하나 또는 여러 개의 원시 csv 파일을 입력으로 허용합니다. graph_accelerometer.py 스크립트는 여러 작동 모드를 지원합니다:

* 원시 가속도계 데이터 플로팅(`-r` 매개변수 사용), 1개의 입력만 지원됩니다;
* 주파수 응답을 플로팅(추가 매개변수가 필요하지 않음), 다중 입력이 지정된 경우 평균 주파수 응답이 계산됩니다;
* 여러 입력 간의 주파수 응답 비교(`-c` 매개변수 사용) `-a x`, `-a y` 또는 `-a z` 매개변수를 통해 고려할 가속도계 축을 추가로 지정할 수 있습니다(지정되지 않은 경우 모든 축의 진동 합계가 사용됨);
* 스펙트로그램 플로팅(`-s` 매개변수 사용), 1개의 입력만 지원됩니다. `-a x`, `-a y` 또는 `-a z` 매개변수를 통해 고려할 가속도계 축을 추가로 지정할 수 있습니다(지정되지 않은 경우 모든 축의 진동 합계가 사용됨).

graph_accelerometer.py 스크립트는 raw_data\*.csv 파일만 지원하고 resonances\*.csv 또는 calibration_data\*.csv 파일은 지원하지 않습니다.

예를 들어,

```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```

Z 축에 대한 여러 `/tmp/raw_data_x_*.csv` 파일을 `/tmp/resonances_x.png` 파일과 비교하여 플롯합니다.

shaper_calibration.py 스크립트는 하나 이상의 입력을 허용하고 입력 shaper의 자동 조정을 실행할 수 있고 제공된 모든 입력에 대해 잘 작동하는 최상의 매개변수를 제안할 수 있습니다. 제안된 매개변수를 콘솔에 출력하고 `-o output.png` 매개변수가 제공된 경우 차트를 추가로 생성하거나 `-c output.csv` 매개변수가 지정된 경우 CSV 파일을 생성할 수 있습니다.

shaper_calibration.py 스크립트에 여러 입력을 제공하면 입력 셰이퍼의 일부 고급 조정을 실행하는 경우 유용할 수 있습니다. 예를 들면 다음과 같습니다:

* 처음에는 툴 헤드에 가속도계가 부착된 bed slinger 프린터에서 단일 축에 대해 `TEST_RESONANCES AXIS=X OUTPUT=raw_data`(및 `Y` 축)를 두 번 실행하고 두 번째로 베드에 가속도계를 부착한 순서대로 실행 축 교차 공명을 감지하고 입력 셰이퍼로 취소하려고 시도합니다.
* 유리 베드와 자성 표면 (더 가벼움)이 있는 bed slinger에서 `TEST_RESONANCES AXIS=Y OUTPUT=raw_data`를 두 번 실행하여 모든 인쇄 표면 구성에 잘 작동하는 입력 셰이퍼 매개변수를 찾습니다.
* 여러 테스트 지점의 공진 데이터 결합.
* 2축의 공명 데이터 결합 (예: bed slinger 프린터에서 X축과 Y축 모두에서 X축 input_shaper 를 구성하는 공진은 X축 방향으로 이동할 때 노즐이 인쇄물을 '치는' 경우 *BED* 의 진동을 취소하기 위해 공진).
