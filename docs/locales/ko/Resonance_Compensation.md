# 공진 보상

Klipper는 인쇄물에서 ringing(echoing, ghosting 또는 rippling 이라고도 함)을 줄이는 데 사용할 수 있는 기술인 입력 성형(input shaping)을 지원합니다. 일반적으로 가장자리와 같은 요소들이 인쇄된 표면에서 미묘한 'echo'로 반복될때 Ringing은 표면 인쇄 결함이 있습니다:

|![Ringing test](img/ringing-test.jpg)|![3D Benchy](img/ringing-3dbenchy.jpg)|

Ringing은 인쇄 방향의 급격한 변화로 인한 프린터의 기계적 진동으로 인해 발생합니다. 링잉은 일반적으로 기계적 원인들을 가지고 있습니다: 강건성이 불충분한 프린터 프레임, 단단하지 않거나 너무 탄력 있는 벨트, 기계 부품의 정렬 문제, 무거운 이동 물체 등등. 가능하면 먼저 확인하고 고정해야 합니다.

[Input shaping](https://en.wikipedia.org/wiki/Input_shaping)은 자체 진동을 취소하는 명령 신호를 생성하는 개방 루프 제어 기술입니다. Input shaping을 활성화하려면 약간의 조정과 측정이 필요합니다. Ringing 외에도 Input shaping은 일반적으로 프린터의 진동과 흔들림을 줄이고 Trinamic 스테퍼 드라이버의 stealthChop 모드의 안정성을 향상시킬 수 있습니다.

## 조정

기본 조정을 위해서는 프린터의 ringing 빈도를 측정하고 `printer.cfg` 파일에 몇 가지 매개변수를 추가해야 합니다.

[docs/prints/ringing_tower.stl](prints/ringing_tower.stl) 에 있는 ringing 테스트 모델을 슬라이서에서 슬라이스합니다:

* 권장 레이어 높이는 0.2 또는 0.25mm입니다.
* 채우기 및 상단 레이어는 0으로 설정할 수 있습니다.
* 1-2개의 둘레를 사용하거나 1-2mm 베이스를 갖는 부드러운 꽃병 모드를 사용하는 것이 좋습니다.
* **외부** 주변에 대해 약 80-100mm/초의 충분히 빠른 속도를 사용합니다.
* 최소 레이어 시간이 **최대** 3초인지 확인합니다.
* 슬라이서에서 "동적 가속 제어"가 비활성화되어 있는지 확인합니다.
* 모델을 돌리지 마십시오. 모델 뒷면에 X 및 Y 표시가 있습니다. 표시의 비정상적인 위치와 프린터 축에 유의하십시오. 이는 오류가 아닙니다. 표시는 측정값에 해당하는 축을 보여주기 때문에 나중에 조정 프로세스에서 참조로 사용될 수 있습니다.

### Ringing 빈도

먼저 **rining 주파수**를 측정합니다.

1. `printer.cfg`의 `max_accel` 및 `max_accel_to_decel` 매개변수를 7000으로 늘립니다. 이는 조저에만 필요하며 해당 [섹션](#selecting-max_accel)에서 더 적절한 값이 선택됩니다.
1. `square_corner_velocity` 매개변수가 변경되었으면 다시 5.0으로 되돌립니다. Input shaper를 사용할 때 이 값을 늘리는 것은 부품에 더 많은 스무딩을 유발할 수 있으므로 권장하지 않습니다. 대신 더 높은 가속도 값을 사용하는 것이 좋습니다.
1. 펌웨어를 다시 시작하십시오: `RESTART`.
1. Pressure Advance 비활성화: `SET_PRESSURE_ADVANCE ADVANCE=0`.
1. Printer.cfg에 `[input_shaper]` 섹션을 이미 추가한 경우 `SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0` 명령어를 실행합니다. "Unknown command" 오류가 발생하면 안전하게 이 오류를 무시하고 측정을 계속할 수 있습니다.
1. 명령을 실행 `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1250 FACTOR=100 BAND=5`. 기본적으로 우리는 가속도에 대해 다른 큰 값을 설정하여 ringing을 더 두드러지게 하려고 합니다. 이 명령은 1500mm/sec^2에서 시작하여 5mm마다 가속도를 증가시킵니다: 1500mm/sec^2, 2000mm/sec^2, 2500mm/sec^2 등등 마지막 밴드에서 7000mm/sec^2까지.
1. 제안된 매개변수로 슬라이스된 테스트 모델을 출력합니다.
1. Ringing이 명확하게 보이고 프린터에 대한 가속도가 너무 높은 경우(예: 프린터가 너무 많이 흔들리거나 단계를 건너뛰기 시작하는 경우) 인쇄 출력을 중지할 수 있습니다.

   1. 참조를 위해 모델 뒷면의 X 및 Y 표시를 이용합니다. X 표시가 있는 쪽의 측정은 X축 *구성*에 사용하고 Y 표시는 Y축 구성에 사용해야 합니다. 노치 근처에서 X 표시가 있는 부품의 여러 진동 사이의 거리 *D*(mm)를 측정합니다. 가급적이면 첫 번째 진동 또는 두 번을 건너뜁니다. 진동 사이의 거리를 더 쉽게 측정하려면 먼저 진동을 표시한 다음 눈금자 또는 캘리퍼스로 표시 사이의 거리를 측정합니다:|![Mark ringing](img/ringing-mark.jpg)|![Measure ringing](img/ringing-measure.jpg)|
1. 측정 거리 *D*가 해당하는 진동수 *N*를 측정합니다. 진동수를 세는 방법을 잘 모르는 경우 *N* = 6 진동수를 표시하는 위의 그림을 참조합니다.
1. *V* &middot; *N* / *D*(Hz) 수식을 이용하여 X축의 ringing 주파수를 게산합니다. 여기서 *V*는 outer perimeters 속도(mm/sec)입니다. 위의 예에서 우리는 6개의 진동수를 표시했고 테스트는 100mm/sec 속도로 인쇄되었으므로 주파수는 100 * 6 / 12.14 ≈ 49.4Hz입니다.
1. 마찬가지로 Y 표시에 대해서도 (9) - (11)을 수행합니다.

테스트 인쇄에서 ringing은 위의 그림과 같이 구부러진 노치의 패턴을 따라야 합니다. 그렇지 않은 경우 이 결함은 실제로 rining이 아니라 다른 원인(기계적 문제 또는 압출기 문제)이 있는 것입니다. Input shapers를 활성화하고 조정하기 전에 이 원인은 먼저 해결되어야 합니다.

진동 사이의 거리가 안정적이지 않아 측정이 신뢰할 수 없는 경우라면 프린터가 동일한 축에 여러 공진 주파수를 가지고 있음을 의미할 수 있습니다. 대신 [Unreliable measurements of ringing frequencies](#unreliable-measurements-of-ringing-frequencies) 섹션에 설명된 조정 프로세스를 따르고 input shaping 기술에서 무언가를 얻을 수 있습니다.

Ringing 빈도는 빌드플레이트 내 모델의 위치와 Z 높이, *특히 델타 프린터*에 따라 달라질 수 있습니다. 테스트 모델의 측면을 따라 다른 위치와 높이에서 주파수 차이가 있는지 확인할 수 있습니다. 이 경우 X 및 Y 축에 대한 평균 ringing 주파수를 계산할 수 있습니다.

측정된 ringing 주파수가 매우 낮은 경우라면(약 20-25Hz 미만), 추가 input shaping 조정하고 주파수를 다시 측정전에 적용 가능한 사항에 따라 프린터를 강화하거나 이동 물체를 줄이는 데 투자하는 것이 좋습니다. 많은 인기 있는 프린터 모델의 경우 이미 사용 가능한 솔루션이 있는 경우가 많습니다.

프린터가 이동 물체에 영향을 미치거나 시스템의 강성을 변경하는 경우 rining 주파수가 변경될 수 있습니다. 예를 들면 다음과 같습니다:

* 일부 도구는 물체를 변경하는 toolhead에 설치, 제거 또는 교체됩니다. 예를들어 직접 압출기용 새로운(더 무겁거나 가벼운) 스테퍼 모터 또는 새로운 핫엔드 설치되거나, 덕트가 있는 무거운 팬 추가되거나 등.
* 벨트가 조여져 있습니다.
* 프레임 강성을 높이기 위해 일부 애드온이 설치됩니다.
* bed-slinger 프린터에 다른 베드를 설치하거나 유리를 추가하는 등.

이러한 변경이 이루어지면 주파수가 변경되었는지 최소한 rining을 측정하는 것이 좋습니다.

### Input shaper 구성

X축과 Y축의 ringing 주파수를 측정한 후 `printer.cfg`에 다음 섹션을 추가할 수 있습니다:

```
[input_shaper]
shaper_freq_x: ...  # frequency for the X mark of the test model
shaper_freq_y: ...  # frequency for the Y mark of the test model
```

위의 예에서 shaper_freq_x/y = 49.4를 얻습니다.

### Input shaper 선택

Klipper는 여러 input shapers를 지원합니다. 공진 주파수를 결정하는 오류에 대한 민감도와 인쇄된 부품에서 발생하는 smoothing 정도에 따라 input shapers 다릅니다. 또한 2HUMP_EI 및 3HUMP_EI와 같은 일부 shapers는 일반적으로 shaper_freq = 공진 주파수와 함께 사용하면 안 됩니다. 한 번에 여러 공진을 줄이기 위해 shapers 서로 다른 고려 사항에서 구성됩니다.

대부분의 프린터에는 MZV 또는 EI shapers가 권장됩니다. 이 섹션에서는 이들 중에서 선택하고 몇 가지 다른 관련 매개변수를 이해하기 위한 테스트 프로세스를 설명합니다.

Ringing 테스트 모델을 다음과 같이 인쇄합니다(이미 shaper_freq_x/y가 설정되고 max_accel/max_accel_to_decel이 printer.cfg 파일에서 7000으로 증가했다고 가정):

1. 펌웨어를 다시 시작하십시오: `RESTART`.
1. Pressure Advance 비활성화: `SET_PRESSURE_ADVANCE ADVANCE=0`.
1. `SET_INPUT_SHAPER SHAPER_TYPE=MZV`를 실행합니다.
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1250 FACTOR=100 BAND=5`. 를 실행합니다.
1. 제안된 매개변수로 슬라이스된 테스트 모델을 출력합니다.

이 시점에서 ringing 이 보이지 않으면 MZV shaper 사용을 권장할 수 있습니다.

Ringing이 보이면 [링잉 주파수](#ringing-frequency) 섹션에 설명된 단계 (8)-(10)을 사용하여 주파수를 다시 측정합니다. 주파수가 이전에 얻은 값과 크게 다른 경우 더 복잡한 input shaper 구성이 필요합니다. [Input shapers](#input-shapers) 섹션의 기술적 세부 사항을 참조할 수 있습니다.그렇지 않으면 다음 단계로 진행하십시오.

이제 EI input shaper를 사용해 보십시오. 이를 시도하려면 위의 (1)-(5) 단계를 반복하되 3단계에서 다음 명령을 대신 실행하세요: `SET_INPUT_SHAPER SHAPER_TYPE=EI`.

MZV 및 EI input shaper로 두 개의 인쇄물을 비교합니다. EI가 MZV보다 눈에 띄게 더 나은 결과를 보이면 EI shaper를 사용하고, 그렇지 않으면 MZV를 선호합니다. EI shaper는 인쇄된 부분을 더 매끄럽게 만듭니다(자세한 내용은 다음 섹션 참조). `shaper_type: mzv` (또는 ei) 매개변수를 [input_shaper] 섹션에 추가합니다. 예:

```
[input_shaper]
shaper_freq_x: ...
shaper_freq_y: ...
shaper_type: mzv
```

Shaper 선택에 대한 몇 가지 참고 사항:

* EI shaper는 베드 슬링거 프린터에 더 적합할 수 있습니다(공진 주파수 및 결과적인 smoothing 이 허용되는 경우): 더 많은 필라멘트가 움직이는 베드에 적층됨에 따라 베드의 질량이 증가하고 공진 주파수가 감소합니다. EI shaper는 공진 주파수 변화에 더 강하기 때문에 큰 부품을 인쇄할 때 더 잘 작동할 수 있습니다.
* 델타 운동학의 특성으로 인해 공진 주파수는 빌드 볼륨의 다른 부분에서 많이 다를 수 있습니다. 따라서 EI shaper는 MZV나 ZV보다 델타 프린터에 더 적합할 수 있으므로 사용을 고려해야 합니다. 공진 주파수가 충분히 큰 경우(50-60Hz 이상), 2HUMP_EI 셰이퍼를 테스트할 수도 있지만 (위의 제안된 테스트를 `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI`로 실행하여) 활성화하기 전에 [아래 섹션](#selecting-max_accel)에서 고려 사항을 확인하십시오.

### max_accel 선택

이전 단계에서 선택한 shaper에 대한 인쇄된 테스트가 있어야 합니다 (그렇지 않은 경우 pressure advance 이 비활성화된 `SET_PRESSURE_ADVANCE ADVANCE=0` 및 tuning tower는 `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1250 FACTOR=100 BAND=5` 로 활성화된 테스트모델 [suggested parameters](#tuning) 을 출력하세요). 매우 높은 가속도에서 공진 주파수와 선택한 input shaper 따라(예: EI shaper는 MZV보다 더 매끄럽게 생성) input shaping은 부품을 너무 많이 매끄럽게 하고 파트를 둥글게 할 수 있습니다. 따라서 이를 방지하기 위해 max_accel을 선택해야 합니다. 스무딩에 영향을 줄 수 있는 또 다른 매개변수는 `square_corner_velocity`이므로 smoothing 증가를 방지하기 위해 기본값인 5mm/sec 이상으로 높이는 것은 권장하지 않습니다.

적절한 max_accel 값을 선택하려면 선택한 input shaper에 대한 모델을 검사합니다. 먼저 가속도 ringing이 여전히 작은지 확인하십시오.

다음으로 smoothing을 확인합니다. 이를 돕기 위해 테스트 모델은 벽에 작은 틈(0.15mm)이 있습니다:

![Test gap](img/smoothing-test.png)

가속도가 증가함에 따라 smoothing도 증가하고 인쇄물의 실제 틈이 넓어집니다:

![Shaper smoothing](img/shaper-smoothing.jpg)

이 그림에서 가속도는 왼쪽에서 오른쪽으로 증가하며 3500mm/sec^2(왼쪽에서 5번째 밴드) 부터 간격이 커지기 시작합니다. 따라서 이 경우 과도한 smoothing을 피하기 위해 max_accel = 3000(mm/sec^2)는 적절한 값입니다.

테스트 인쇄에서 틈이 여전히 매우 작을 때 가속도에 유의하십시오. 팽창이 보이지만 높은 가속에서도 벽에 틈이 전혀 없다면 특히 Bowden 압출기에서 비활성화된 Pressure Advance 때문일 수 있습니다. 이 경우 PA가 활성화된 상태에서 인쇄를 반복해야 할 수도 있습니다. 또한 잘못 보정된(너무 높은) 필라멘트 흐름의 결과일 수 있으므로 이것도 확인하는 것이 좋습니다.

Choose the minimum out of the two acceleration values (from ringing and smoothing), and put it as max_accel into printer.cfg (you can delete max_accel_to_decel or revert it to the old value).

참고로, 특히 낮은 ringing 주파수에서 EI shaper가 더 낮은 가속에서도 너무 많은 smoothing을 유발할 수 있습니다. 이 경우 더 높은 가속도 값을 허용할 수 있으므로 MZV가 더 나은 선택일 수 있습니다.

매우 낮은 ringing 주파수(~25Hz 이하)에서는 MZV shaper라도 너무 많은 smoothing을 생성할 수 있습니다. 이 경우 `SET_INPUT_SHAPER SHAPER_TYPE=ZV` 명령어를 대신 사용하여 ZV shaper로 [Choosing input shaper](#choosing-input-shaper) 섹션의 단계를 반복할 수도 있습니다. ZV shaper는 MZV보다 smoothing이 훨씬 낮아야 하지만 ringing 주파수를 측정할 때 오류에 더 민감합니다.

매우 낮은 ringing 주파수(~25Hz 이하)에서는 MZV shaper라도 너무 많은 smoothing을 생성할 수 있습니다. 이 경우 'SET_INPUT_SHAPER SHAPER_TYPE=ZV' 명령어를 대신 사용하여 ZV shaper로 [input shaper 선택](#choosing-input-shaper) 섹션의 단계를 반복할 수도 있습니다. ZV shaper는 MZV보다 smoothing이 훨씬 낮아야 하지만 ringing 주파수를 측정할 때 오류에 더 민감합니다.

### Fine-tuning resonance frequencies

Ringing 테스트 모델을 사용하는 공진 주파수 측정의 정밀도는 대부분의 목적에 충분하므로 추가 조정은 권장되지 않습니다. 여전히 결과를 다시 확인하려는 경우(예: 이전에 측정한 것과 동일한 주파수로 선택한 input shaper를 사용하여 테스트 모델을 인쇄한 후에도 약간의 ringing이 있는 경우) 이 섹션의 단계를 따를 수 있습니다. [input_shaper]를 활성화한 후 다른 주파수에서 ringing이 표시되는 경우 이 섹션은 도움이 되지 않습니다.

제안된 매개변수로 ringing 모델을 슬라이스하고 `printer.cfg`의 `max_accel` 및 `max_accel_to_decel` 매개변수를 이미 7000으로 증가했다고 가정하고 X 및 Y 축 각각에 대해 다음 단계를 완료하십시오:

1. Pressure Advance이 비활성화되어 있는지 확인하십시오: `SET_PRESSURE_ADVANCE ADVANCE=0`.
1. 다음을 실행합니다: `SET_INPUT_SHAPER SHAPER_TYPE=ZV`.
1. 선택한 input shaper가 있는 기존 rining 테스트 모델에서 rining을 충분히 잘 보여주는 가속도를 선택하고 다음과 같이 설정합니다: `SET_VELOCITY_LIMIT ACCEL=...`.
1. `shaper_freq_x` 매개변수를 조정하기 위해 `TUNING_TOWER` 명령에 필요한 매개변수를 다음과 같이 계산합니다. start = shaper_freq_x * 83 / 132 및 factor = shaper_freq_x / 66, 여기서 `shaper_freq_x`는 `printer.cfg`의 현재 값입니다.
1. 단계 (4)에서 계산된 `start` 및 `factor` 값을 사용하여 명령어를 실행합니다: `TUNING_TOWER COMMAND=SET_INPUT_SHAPER PARAMETER=SHAPER_FREQ_X START=start FACTOR=factor BAND=5`.
1. 테스트 모델을 인쇄합니다.
1. 원래 주파수 값을 재설정합니다: `SET_INPUT_SHAPER SHAPER_FREQ_X=...`.
1. 가장 적은 rining 밴드를 찾아 그 아래에서 1부터 숫자를 센다.
1. 이전 shaper_freq_x * (39 + 5 * #band-number) / 66 를 통해 새로운 shaper_freq_x 값을 계산합니다.

같은 방식으로 Y축에 대해 이 단계를 반복하여 X축에 대한 참조를 Y축으로 바꿉니다(예: 수식 및 `TUNING_TOWER` 명령에서 `shaper_freq_x`를 `shaper_freq_y`로 교체).

예를 들어 축 중 하나에 대해 45Hz와 동일한 벨소리 주파수를 측정했다고 가정해 보겠습니다. 이것은 `TUNING_TOWER` 명령에 대해 start = 45 * 83 / 132 = 28.30 1 및 factor = 45 / 66 = 0.6818 값을 제공합니다. 이제 테스트 모델을 인쇄한 후 아래쪽에서 네 번째 밴드가 가장 적은 rining 을 제공한다고 가정해 보겠습니다. 업데이트된 shaper_freq_? 값은 * (39 + 5 * 4) / 66 ≈ 40.23 와 같습니다.

새로운 `shaper_freq_x` 및 `shaper_freq_y` 매개변수가 모두 계산된 후 `printer.cfg`의 `[input_shaper]` 섹션을 새로운 `shaper_freq_x` 및 `shaper_freq_y` 값으로 업데이트할 수 있습니다.

이 섹션을 마친 후 `printer.cfg`의 `max_accel` 및 `max_accel_to_decel` 매개변수에 대한 변경 사항을 되돌리는 것을 잊지 마십시오.

### Pressure Advance

Pressure Advance를 사용하면 다시 조정되어야 할 수 있습니다. 이전 값과 다른 경우[instructions](Pressure_Advance.md#tuning-pressure-advance)에 따라 새 값을 찾습니다. `printer.cfg`에서 `max_accel` 및 `max_accel_to_decel` 매개변수의 원래 값을 복원하고 Pressure Advance를 조정하기 전에 Klipper를 다시 시작해야 합니다.

### Unreliable measurements of ringing frequencies

Ringing 주파수를 측정할 수 없는 경우, 예를 들어 진동 사이의 거리가 안정적이지 않은 경우에도 input shaping 기술을 사용할 수 있지만 결과는 주파수를 적절하게 측정하는 것만큼 좋지 않을 수 있으며 테스트 모델을 약간 더 조정하고 인쇄해야 합니다. 또 다른 가능성은 가속도계를 구입하여 설치하고 공진을 측정하는 것입니다 (필요한 하드웨어 및 설정 프로세스를 설명하는 [docs](Measuring_Resonances.md) 참조) - 그러나 이 옵션은 약간의 압착 및 납땜이 필요합니다.

조정을 위해 `printer.cfg`에 빈 `[input_shaper]` 섹션을 추가합니다. 그런 다음 제안된 매개변수로 벨소리 모델을 슬라이스하고 `printer.cfg`의 `max_accel` 및 `max_accel_to_decel` 매개변수를 이미 7000 으로 증가했다고 가정하고 다음과 같이 테스트 모델을 3회 인쇄합니다. 처음으로 인쇄하기 전에 다음을 실행합니다

1. `RESTART`
1. `SET_PRESSURE_ADVANCE ADVANCE=0`.
1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=60 SHAPER_FREQ_Y=60`.
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1250 FACTOR=100 BAND=5`.

모델을 인쇄합니다. 그런 다음 다시 모델을 인쇄하지만 인쇄하기 전에 다음을 실행합니다

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=50 SHAPER_FREQ_Y=50`.
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1250 FACTOR=100 BAND=5`.

그런 다음 세 번째로 모델을 인쇄하기전에 다음을 실행합니다

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=40 SHAPER_FREQ_Y=40`.
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1250 FACTOR=100 BAND=5`.

기본적으로 shaper_freq = 60Hz, 50Hz 및 40Hz인 2HUMP_EI shaper를 사용하여 TUNING_TOWER로 rining 테스트 모델을 인쇄하고 있습니다.

어떤 모델도 rining 개선을 나타내지 않는다면 불행히도 input shaping 기술이 귀하의 경우에 도움이 될 수 없는 것 같습니다.

그렇지 않으면 모든 모델에서 ringing 보이지 않거나 일부 모델에서는 rining이 표시되고 일부는 그렇지 않을 수 있습니다. 여전히 rining이 개선된 가장 높은 주파수의 테스트 모델을 선택하십시오. 예를 들어, 40Hz 및 50Hz 모델에서 rining이 거의 나타나지 않고 60Hz 모델에서 이미 rining이 더 많이 나타나는 경우 50Hz를 사용합니다.

이제 EI shaper가 귀하의 경우에 충분할지 확인하십시오. 선택한 2HUMP_EI shaper의 주파수를 기반으로 EI shaper 주파수를 선택합니다:

* 2HUMP_EI 60Hz shaper의 경우 shaper_freq = 50Hz인 EI shaper를 사용합니다.
* 2HUMP_EI 50Hz shaper의 경우 shaper_freq = 40Hz인 EI shaper를 사용합니다.
* 2HUMP_EI 40Hz shaper의 경우 shaper_freq = 33Hz인 EI shaper를 사용합니다.

이제 테스트 모델을 한 번 더 인쇄하여 실행합니다

1. `SET_INPUT_SHAPER SHAPER_TYPE=EI SHAPER_FREQ_X=... SHAPER_FREQ_Y=...`.
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1250 FACTOR=100 BAND=5`.

이전에 결정된 shaper_freq_x=... 및 shaper_freq_y=...를 제공합니다.

EI shaper가 2HUMP_EI shaper와 매우 유사한 좋은 결과를 보인다면 EI shaper와 이전에 결정된 주파수를 고수하고, 그렇지 않으면 해당 주파수와 함께 2HUMP_EI shaper를 사용합니다. 결과를 `printer.cfg`에 추가합니다.

```
[input_shaper]
shaper_freq_x: 50
shaper_freq_y: 50
shaper_type: 2hump_ei
```

[max_accel 선택](#selecting-max_accel) 섹션으로 튜닝을 계속합니다.

## 문제해결 및 FAQ

### 공진 주파수의 신뢰할 만한 측정을 얻을 수 없습니다

먼저 ringing 대신 프린터에 다른 문제가 없는지 확인합니다. 진동 사이의 거리가 안정적이지 않아 측정이 신뢰할 수 없는 경우 프린터가 동일한 축에 여러 공진 주파수를 가지고 있음을 의미할 수 있습니다. [rining 주파수의 신뢰할 수 없는 측정](#unreliable-measurements-of-ringing-frequencies) 섹션에 설명된 조정 프로세스를 따르고도 여전히 input shaping 기술에서 무언가를 얻을 수 있습니다. 또 다른 가능성은 가속도계를 설치하여 공진을 [측정](Measuring_Resonances.md)하고 이러한 측정 결과를 사용하여 input shaper를 자동 조정하는 것입니다.

### [input_shaper] 를 활성화한 후 인쇄된 부분이 너무 매끄럽고 인쇄된 세부적인 부분이 손실됩니다

[max_accel 선택](#selecting-max_accel) 섹션에서 고려 사항을 확인하십시오. 공진 주파수가 낮으면 max_accel을 너무 높게 설정하거나 square_corner_velocity 매개변수를 증가시키지 않아야 합니다. EI(또는 2HUMP_EI 및 3HUMP_EI 셰이퍼)보다 MZV 또는 ZV input shaper를 선택하는 것이 더 나을 수도 있습니다.

### Ringing 없이 일정 시간동안 성공적으로 인쇄한 후 ringing 현상이 다시 나타나는 것처럼 보입니다

얼마 후 공진 주파수가 변경되었을 수 있습니다. 예를 들어 벨트 장력이 변경되었을 수 있습니다(벨트가 더 느슨해짐) 등. [Ringing frequency](#ringing-frequency) 섹션에 설명된 대로 울리는 주파수를 확인후 다시 측정하고 필요한 경우 구성 파일을 업데이트하는 것이 좋습니다.

### Input shapers에서 이중 캐리지 설정이 지원됩니까?

Input shpaer가 있는 이중 캐리지에 대한 전용 지원은 없지만 이 설정이 작동하지 않는다는 의미는 아닙니다. 각 캐리지에 대해 튜닝을 두 번 실행하고 각 캐리지에 대해 독립적으로 X 및 Y 축에 대한 ringing 주파수를 계산해야 합니다. 그런 다음 캐리지 0의 값을 [input_shaper] 섹션에 입력하고 캐리지를 변경할 때 값을 즉시 변경합니다. 예. 일부 매크로의 일부로:

```
SET_DUAL_CARRIAGE CARRIAGE=1
SET_INPUT_SHAPER SHAPER_FREQ_X=... SHAPER_FREQ_Y=...
```

캐리지 0으로 다시 전환할 때도 마찬가지입니다.

### input_shaper가 인쇄 시간에 영향을 줍니까?

아니요, 'input_shaper' 기능 자체는 인쇄 시간에 거의 영향을 미치지 않습니다. 그러나 `max_accel`의 값은 확실히 영향을 미칩니다.([이 섹션](#selecting-max_accel)에 설명된 이 매개변수의 조정).

## 기술적 세부 사항

### Input shapers

Klipper에서 사용되는 input shapers는 다소 표준적이며 해당 shapers를 설명하는 문서에서 더 자세한 개요를 찾을 수 있습니다. 이 섹션에는 지원되는 input shapers의 일부 기술적인 측면에 대한 간략한 개요가 포함되어 있습니다. 아래 표는 각 shpaer의 일부(대개 대략적인) 매개변수를 보여줍니다.

| Input <br> shaper | Shaper <br> duration | Vibration reduction 20x <br> (5% vibration tolerance) | Vibration reduction 10x <br> (10% vibration tolerance) |
| :-: | :-: | :-: | :-: |
| ZV | 0.5 / shaper_freq | N/A | ± 5% shaper_freq |
| MZV | 0.75 / shaper_freq | ± 4% shaper_freq | -10%...+15% shaper_freq |
| ZVD | 1 / shaper_freq | ± 15% shaper_freq | ± 22% shaper_freq |
| EI | 1 / shaper_freq | ± 20% shaper_freq | ± 25% shaper_freq |
| 2HUMP_EI | 1.5 / shaper_freq | ± 35% shaper_freq | ± 40 shaper_freq |
| 3HUMP_EI | 2 / shaper_freq | -45...+50% shaper_freq | -50%...+55% shaper_freq |

진동 감소에 대한 참고 사항: 위 표의 값은 대략적인 값입니다. 프린터의 감쇠비가 각 축에 대해 알려지면 shaper를 더 정확하게 구성할 수 있으며 그러면 좀 더 넓은 범위의 주파수에서 공진을 줄일 수 있습니다. 그러나 감쇠비는 일반적으로 알려지지 않고 특별한 장비 없이는 추정하기 어렵기 때문에 Klipper는 기본적으로 0.1 값을 사용하며 이는 좋은 만능 값입니다. 표의 주파수 범위는 해당 값(약 0.05 ~ 0.2) 주변에서 가능한 다양한 감쇠비를 포함합니다.

또한 EI, 2HUMP_EI 및 3HUMP_EI는 진동을 5%로 줄이도록 조정되었으며,따라서 10% 진동 허용 오차 값은 참고용으로만 제공됩니다.

**이 표를 사용하는 방법:**

* Shaper 지속 시간은 부품의 smoothing에 영향을 줍니다. 크기가 클수록 부품이 더 부드러워집니다. 이 종속성은 선형이 아니지만 동일한 주파수에 대해 어떤 shapers가 더 '매끄러운' 느낌을 줄 수 있습니다. Smoothing에 의한 순서는 다음과 같습니다: ZV < MZV < ZVD ≈ EI < 2HUMP_EI < 3HUMP_EI. 또한 shapers 2HUMP_EI 및 3HUMP_EI에 대해 shaper_freq = 공진 주파수를 설정하는 것은 거의 실용적이지 않습니다(여러 주파수에 대한 진동을 줄이는 데 사용해야 함).
* Shaper가 진동을 줄이는 주파수 범위를 추정할 수 있습니다. 예를 들어 shaper_freq = 35Hz인 MZV는 주파수 [33.6, 36.4]Hz에 대해 진동을 5%로 줄입니다. shaper_freq = 50Hz인 3HUMP_EI는 [27.5, 75]Hz 범위에서 진동을 5%로 줄입니다.
* 이 표를 사용하여 여러 주파수에서 진동을 줄여야 하는 경우 사용해야 하는 shaper를 확인할 수 있습니다. 예를 들어, 동일한 축에서 35Hz와 60Hz에서 공진이 있는 경우: a) EI shaper는 shaper_freq = 35 / (1 - 0.2) = 43.75Hz를 가져야 하며 43.75 * (1 + 0.2) = 52.5Hz까지 공진을 감소시키므로 충분하지 않습니다; b) 2HUMP_EI shaper는 shaper_freq = 35 / (1 - 0.35) = 53.85Hz를 가져야 하며 53.85 * (1 + 0.35) = 72.7Hz까지 진동을 감소시키므로 이것이 허용되는 구성입니다. 항상 주어진 shaper에 대해 가능한 한 높은 shaper_freq를 사용하려고 시도하고 (아마도 약간의 안전 여유가 있으므로 이 예에서는 shaper_freq ≈ 50-52Hz가 가장 잘 작동함) shaper 지속 시간이 가능한 짧은 shaper를 사용하려고 합니다.
* 매우 다른 여러 주파수(예: 30Hz 및 100Hz)에서 진동을 줄여야 하는 경우 위의 표가 충분한 정보를 제공하지 않는다는 것을 알 수 있습니다. 이 경우 더 유연한 [scripts/graph_shaper.py](../scripts/graph_shaper.py) 스크립트를 사용하면 더 운이 좋을 수 있습니다.
