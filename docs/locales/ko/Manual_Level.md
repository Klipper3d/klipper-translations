# 수동 레벨링

이 문서는 Z 엔드스톱을 보정하고 BED 레벨링 나사를 조정하기 위한 도구에 대해 설명합니다.

## Z 엔드스톱 보정

정확한 Z 엔드스톱 위치는 고품질 인쇄물을 얻는 데 매우 중요합니다.

그러나 Z 엔드스톱 스위치 자체의 정확도가 제한 요소가 될 수 있습니다. Trinamic 스테퍼 모터 드라이버를 사용하는 경우 [endstop phase](Endstop_Phase.md) 감지를 활성화하여 스위치의 정확도를 높이는 것이 좋습니다.

Z 엔드스톱 보정을 수행하려면 프린터를 홈으로 이동하고 헤드가 BED 에서 최소 5mm 위에 있는 Z 위치로 이동하도록 명령하고 (아직 하지 않는 경우) 헤드가 중심 근처의 XY 위치로 이동하도록 명령합니다. BED 에서 OctoPrint 터미널 탭으로 이동하여 다음을 실행합니다:

```
Z_ENDSTOP_CALIBRATE
```

그런 다음 ["the paper test"](Bed_Level.md#the-paper-test) 에 설명된 단계에 따라 주어진 위치에서 노즐과 BED 사이의 실제 거리를 결정합니다. 이러한 단계가 완료되면 위치를 `ACCEPT` 하고 다음을 사용하여 구성 파일에 결과를 저장할 수 있습니다:

```
SAVE_CONFIG
```

BED 에서 Z축의 반대쪽 끝에 Z 엔드스톱 스위치를 사용하는 것이 좋습니다. (BED 에서 멀어지는 방향으로 귀환하는 것이 일반적으로 Z로 귀환하는 것이 항상 안전하므로 더 강력합니다.) 그러나 BED 를 향해 Homing 하는 경우 BED 위의 작은 거리(예: 0.5mm)가 트리거되도록 엔드스톱을 조정하는 것이 좋습니다. 거의 모든 엔드스톱 스위치는 트리거 포인트를 넘어 약간 떨어진 거리에서 안전하게 누를 수 있습니다. 이 작업이 완료되면 `Z_ENDSTOP_CALIBRATE` 명령이 Z position_endstop 에 대해 작은 양수 값(예: .5mm)을 나태내는 것을 알 수 있습니다. BED 에서 아직 약간의 거리가 있는 동안 엔드스톱을 트리거하면 의도하지 않은 BED 충돌의 위험이 줄어듭니다.

일부 프린터에는 물리적 엔드스톱 스위치의 위치를 수동으로 조정할 수 있는 기능이 있습니다. 그러나 Klipper 를 사용하여 소프트웨어에서 Z 엔드스톱 위치 지정을 수행하는 것이 좋습니다. 엔드스톱의 물리적 위치가 편리한 위치에 있으면 Z_ENDSTOP_CALIBRATE 를 실행하거나 구성 파일에서 Z position_endstop 을 수동으로 업데이트하여 추가 조정을 수행할 수 있습니다.

## BED 레벨링 나사 조정

BED 레벨링 나사로 BED 레벨링을 잘 하는 비결은 BED 레벨링 과정 자체에서 프린터의 고정밀 모션 시스템을 활용하는 것입니다. 이것은 노즐을 각 BED 나사 근처의 위치로 지정한 다음 BED 가 노즐에서 설정된 거리가 될 때까지 해당 나사를 조정하여 수행됩니다. Klipper에는 이를 지원하는 도구가 있습니다. 도구를 사용하려면 각 나사 XY 위치를 지정해야 합니다.

이것은 `[bed_screws]` config 섹션을 생성하여 수행됩니다. 예를 들어 다음과 유사할 수 있습니다:

```
[bed_screws]
screw1: 100,50
screw2: 100,150
screw3: 150,100
```

BED 나사가 BED 아래에 있는 경우 나사 바로 위에 XY 위치를 지정합니다. 나사가 BED 외부에 있으면 여전히 BED 범위 내에 있는 나사에 가장 가까운 XY 위치를 지정합니다.

config 파일이 준비되면 `RESTART`를 실행하여 해당 config 를 로드한 다음 다음을 실행하여 도구를 시작할 수 있습니다:

```
BED_SCREWS_ADJUST
```

이 도구는 프린터의 노즐을 각 나사 XY 위치로 이동한 다음 노즐을 Z=0 높이로 이동합니다. 이 시점에서 ["the paper test"](Bed_Level.md#the-paper-test) 를 사용하여 노즐 바로 아래의 BED 나사를 조정할 수 있습니다. 용지를 앞뒤로 밀 때 약간의 마찰이 있을 때까지 BED 나사를 조정합니다.

약간의 마찰이 느껴지도록 나사를 조정했으면 `ACCEPT` 또는 `ADJUSTED` 명령을 실행합니다. BED 나사를 조정해야 하는 경우 `ADJUSTED` 명령을 사용합니다 (일반적으로 나사 회전의 약 1/8 이상). 더이상 조정이 필요하지 않은 경우 `ACCEPT` 명령을 사용하십시오. 두 명령 모두 도구가 다음 나사로 진행하도록 합니다. ('ADJUSTED' 명령을 사용하면 도구가 BED 나사 조정의 추가 주기를 예약합니다. 모든 BED 나사가 더이상 조정이 필요하지 않은 것으로 확인되면 도구가 성공적으로 완료됩니다.) `ABORT` 명령을 사용하여 도구를 일찍 종료할 수 있습니다.

이 시스템은 프린터에 평평한 인쇄 표면(예: 유리)이 있고 직선 레일이 있을 때 가장 잘 작동합니다. BED 레벨링 도구가 성공적으로 완료되면 BED 인쇄할 준비가 되어야 합니다.

### 미세한 BED 나사 조정

프린터가 3개의 BED 나사를 사용하고 3개의 나사가 모두 BED 아래에 있는 경우 두 번째 "고정밀" BED 레벨링 단계를 수행할 수 있습니다. 이것은 각 BED 나사 조정으로 BED가 더 먼 거리를 이동하는 위치로 노즐을 명령하여 수행됩니다.

예를 들어 위치 A, B 및 C에 나사가 있는 BED를 생각할 수 있습니다:

![bed_screws](img/bed_screws.svg.png)

위치 C에서 BED 나사를 조정할 때마다 BED는 나머지 2개의 BED 나사 (여기서는 녹색 선으로 표시)에 의해 정의된 선을 따라 양쪽으로 기울어 집니다. 이 상황에서 C에서 BED 나사를 조정할 때마다 C에서 보다 D 위치에서 BED가 더 많이 움직입니다. 따라서 노즐이 위치 D에 있을 때 C 나사 조정을 개선할 수 있습니다.

이 기능을 활성화하려면 추가 노즐 좌표를 결정하고 config 파일에 추가해야 합니다. 예를 들어 다음과 같을 수 있습니다:

```
[bed_screws]
screw1: 100,50
screw1_fine_adjust: 0,0
screw2: 100,150
screw2_fine_adjust: 300,300
screw3: 150,100
screw3_fine_adjust: 0,100
```

이 기능이 활성화되면 `BED_SCREWS_ADJUST` 도구는 먼저 각 나사 위치 바로 위의 대략적인 조정을 요청하고 일단 수락되면 추가 위치에서 미세 조정을 요청합니다. 각 위치에서 `ACCEPT` 및 `ADJUSTED` 를 계속 사용합니다.

## BED 프로브를 사용하여 BED 레벨링 나사 조정

이것은 BED 프로브를 사용하여 BED 레벨을 보정하는 또 다른 방법입니다. 그것을 사용하려면 Z 프로브 (BL Touch, Inductive sensor 등)가 있어야 합니다.

이 기능을 활성화하려면 Z 프로브가 나사 위에 있도록 노즐 좌표를 결정한 다음 구성 파일에 추가합니다. 예를 들어 다음과 같을 수 있습니다:

```
[screws_tilt_adjust]
screw1: -5,30
screw1_name: front left screw
screw2: 155,30
screw2_name: front right screw
screw3: 155,190
screw3_name: rear right screw
screw4: -5,190
screw4_name: rear left screw
horizontal_move_z: 10.
speed: 50.
screw_thread: CW-M3
```

나사1은 항상 다른 기준점이므로 시스템은 나사1이 올바른 높이에 있다고 가정합니다. 항상 `G28`을 먼저 실행한 다음 `SCREWS_TILT_CALCULATE`를 실행하십시오. 다음과 유사한 출력이 생성되어야 합니다:

```
Send: G28
Recv: ok
Send: SCREWS_TILT_CALCULATE
Recv: // 01:20 means 1 full turn and 20 minutes, CW=clockwise, CCW=counter-clockwise
Recv: // front left screw (base) : x=-5.0, y=30.0, z=2.48750
Recv: // front right screw : x=155.0, y=30.0, z=2.36000 : adjust CW 01:15
Recv: // rear right screw : y=155.0, y=190.0, z=2.71500 : adjust CCW 00:50
Recv: // read left screw : x=-5.0, y=190.0, z=2.47250 : adjust CW 00:02
Recv: ok
```

이는 다음을 의미합니다:

- front left screw is the reference point you must not change it.
- front right screw must be turned clockwise 1 full turn and a quarter turn
- rear right screw must be turned counter-clockwise 50 minutes
- read left screw must be turned clockwise 2 minutes (not need it's ok)

BED가 수평이 될 때까지 이 과정을 여러 번 반복합니다. 일반적으로 6분 미만의 시간이 필요합니다.

핫엔드 측면에 장착된 프로브를 사용하는 경우(즉, X 또는 Y 오프셋이 있음) BED 기울기를 조정하면 기울어진 BED 에서 수행된 이전 프로브 교정이 무효화됩니다. 반드시 BED 나사를 조정한 후 [probe calibration](Probe_Calibrate.md) 을 실행하세요.

`MAX_DEVIATION` 매개변수는 저장된 BED MESH 가 사용될 때 BED 레벨이 MESH 가 생성되었을 때의 위치에서 너무 멀어지지 않았는지 확인하는 데 유용합니다. 예를 들어 메시가 로드되기 전에 슬라이서의 사용자 정의 start gcode에 `SCREWS_TILT_CALCULATE MAX_DEVIATION=0.01`을 추가할 수 있습니다. 구성된 제한(이 예에서는 0.01mm)을 초과하면 인쇄가 중단되어 사용자가 나사를 조정하고 인쇄를 다시 시작할 수 있습니다.

`DIRECTION` 매개변수는 BED 조정 나사를 한 방향으로만 돌릴 수 있는 경우에 유용합니다. 예를 들어, BED 를 올리거나 내리기 위해 한 방향으로만 돌릴 수 있는 가장 낮은 (또는 가장 높은) 위치에서 조이기 시작하는 나사가 있을 수 있습니다. 나사를 시계 방향으로만 돌릴 수 있다면 `SCREWS_TILT_CALCULATE DIRECTION=CW`를 실행합니다. 시계 반대 방향으로만 돌릴 수 있다면 `SCREWS_TILT_CALCULATE DIRECTION=CCW`를 실행하세요. 모든 나사를 주어진 방향으로 돌려 BED 가 수평을 이룰 수 있도록 적절한 기준점을 선택합니다.
