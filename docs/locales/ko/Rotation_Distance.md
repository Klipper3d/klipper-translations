# Rotation distance

Klipper의 스테퍼 모터 드라이버는 각 [스테퍼 구성 섹션](Config_Reference.md#stepper) 에 `rotation_distance` 매개변수가 필요합니다. 'rotation_distance'는 스테퍼 모터가 완전히 1회전할 때 축이 이동하는 거리의 양입니다. 이 문서에서는 이 값을 구성하는 방법을 설명합니다.

## steps_per_mm(또는 step_distance)에서 rotation_distance 가져오기

3d 프린터의 설계자는 원래 회전 거리에서 `steps_per_mm`를 계산했습니다. steps_per_mm를 알고 있다면 이 일반 공식을 사용하여 원래 회전 거리를 얻을 수 있습니다:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> / <steps_per_mm>
```

또는 이전 Klipper 구성이 있고 `step_distance` 매개변수를 알고 있는 경우 다음 공식을 사용할 수 있습니다:

```
rotation_distance = <full_steps_per_rotation> * <microsteps> * <step_distance>
```

`<full_steps_per_rotation>` 설정은 스테퍼 모터의 유형에 따라 결정됩니다. 대부분의 스테퍼 모터는 "1.8도 스테퍼"이므로 회전당 200개의 전체 단계가 있습니다 (360을 1.8로 나눈 값은 200). 일부 스테퍼 모터는 "0.9도 스테퍼"이므로 회전당 400개의 전체 단계가 있습니다. 다른 스테퍼 모터는 드뭅니다. 확실하지 않은 경우 구성 파일에서 full_steps_per_rotation을 설정하지 말고 위의 공식에서 200을 사용하십시오.

`<microsteps>` 설정은 스테퍼 모터 드라이버에 의해 결정됩니다. 대부분의 드라이버는 16개의 마이크로스텝을 사용합니다. 확실하지 않은 경우 구성에서 'microsteps: 16'을 설정하고 위 공식에서 16을 사용합니다.

거의 모든 프린터에는 x, y 및 z 유형 축의 `rotation_distance` 에 대한 정수가 있어야 합니다. 위 수식으로 인해 회전 거리가 정수의 0.01 이내이면 최종 값을 해당 정수로 반올림합니다.

## 압출기에서 rotation_distance 보정

압출기에서 `rotation_distance` 는 스테퍼 모터가 1회전하는 동안 필라멘트가 이동하는 거리입니다. 이 설정에 대한 정확한 값을 얻는 가장 좋은 방법은 "측정 및 다듬기" 절차를 사용하는 것입니다.

먼저 회전 거리에 대한 초기 추측으로 시작합니다. 이것은 [steps_per_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance) 또는 [하드웨어 검사](#extruder)에서 얻을 수 있습니다.

다음 절차를 사용하여 "측정 및 다듬기"를 수행합니다:

1. 압출기에 필라멘트가 있고 핫엔드가 적절한 온도로 가열되고 프린터가 압출할 준비가 되었는지 확인합니다.
1. Extruder 본체의 흡입구에서 약 70mm 지점에 필라멘트에 마커를 사용하여 표시를 합니다. 그런 다음 디지털 캘리퍼스를 사용하여 해당 표시의 실제 거리를 가능한 한 정확하게 측정합니다. 이것을 `<initial_mark_distance>`로 기록하십시오.
1. 'G91' 다음에 'G1 E50 F60' 명령 순서로 필라멘트 50mm를 압출합니다. 50mm를 `<requested_extrude_distance>`로 기록합니다. 압출기가 이동을 마칠 때까지 기다립니다(약 50초 소요).
1. 디지털 캘리퍼스를 사용하여 압출기 본체와 필라멘트 표시 사이의 새로운 거리를 측정합니다. 이것을 `<subsequent_mark_distance>`로 기록하십시오. 그런 다음 다음을 계산합니다: `actual_extrude_distance = <initial_mark_distance> - <subsequent_mark_distance>`
1. 다음과 같이 rotation_distance를 계산합니다: `rotation_distance = <previous_rotation_distance> * <actual_extrude_distance> / <requested_extrude_distance>` 새 rotation_distance를 소수점 이하 세 자리로 반올림합니다.

real_extrude_distance가 requests_extrude_distance와 약 2mm 이상 차이가 나는 경우 위의 단계를 두 번째로 수행하는 것이 좋습니다.

참고: x, y 또는 z 유형 축을 보정하기 위해 "측정 및 자르기" 유형의 방법을 *사용하지 마십시오*. "측정 및 다듬기" 방법은 해당 축에 대해 충분히 정확하지 않으며 구성이 더 나빠질 수 있습니다. 대신 필요한 경우 [벨트, 풀리 및 리드 스크류 하드웨어 측정](#obtaining-rotation_distance-by-inspecting-the-hardware) 을 통해 해당 축을 결정할 수 있습니다.

## 하드웨어 검사를 통해 rotation_distance 얻기

스테퍼 모터 및 프린터 운동학에 대한 지식으로 rotation_distance를 계산할 수 있습니다. 이것은 steps_per_mm를 알 수 없거나 새 프린터를 설계하는 경우에 유용할 수 있습니다.

### 벨트 구동 축

벨트와 풀리를 사용하는 선형 축에 대한 회전 거리를 쉽게 계산할 수 있습니다.

먼저 벨트 유형을 결정하십시오. 대부분의 프린터는 2mm 벨트 피치를 사용합니다(즉, 벨트의 각 톱니가 2mm 떨어져 있음). 그런 다음 스테퍼 모터 풀리의 톱니 수를 세십시오. 그러면 rotation_distance가 다음과 같이 계산됩니다:

```
rotation_distance = <belt_pitch> * <number_of_teeth_on_pulley>
```

예를 들어 프린터에 2mm 벨트가 있고 톱니가 20개인 풀리를 사용하는 경우 회전 거리는 40입니다.

### 리드 스크류가 있는 축

다음 공식을 사용하여 일반 리드 나사의 회전 거리를 쉽게 계산할 수 있습니다:

```
rotation_distance = <screw_pitch> * <number_of_separate_threads>
```

예를 들어, 일반적인 "T8 리드스크류"는 회전 거리가 8입니다 (피치 2mm이고 별도의 나사산 4개 있음).

"나사산 막대"가 있는 구형 프린터에는 리드 나사에 하나의 "나사산"만 있으므로 회전 거리는 나사의 피치입니다. (나사 피치는 나사의 각 홈 사이의 거리입니다.) 예를 들어, M6 미터법 막대의 회전 거리가 1이고 M8 막대의 회전 거리가 1.25입니다.

### 압출기

필라멘트를 밀어내는 "호브 볼트"의 직경을 측정하고 다음 공식을 사용하여 압출기의 초기 회전 거리를 얻을 수 있습니다: `rotation_distance = <직경> * 3.14`

압출기가 기어를 사용하는 경우 압출기에 대한 [기어 비율을 결정하고 설정](#using-a-gear_ratio)도 필요합니다.

필라멘트와 맞물리는 "호브 볼트"의 그립이 다를 수 있기 때문에 압출기의 실제 회전 거리는 프린터마다 다릅니다. 필라멘트 스풀 간에도 다를 수 있습니다. 초기 회전 거리를 구한 후 [측정 및 다듬기 절차](#calibrating-rotation_distance-on-extruders)를 사용하여 보다 정확한 설정을 얻으십시오.

## gear_ratio 사용

`gear_ratio` 를 설정하면 기어 박스(또는 이와 유사한 것)가 연결된 스테퍼에서 `rotation_distance` 를 더 쉽게 구성할 수 있습니다. 대부분의 스테퍼에는 기어 박스가 없습니다. 확실하지 않은 경우 구성에서 'gear_ratio'를 설정하지 마십시오.

`gear_ratio` 가 설정되면 ` rotation_distance` 는 기어 박스의 최종 기어가 한 바퀴 완전히 회전할 때 축이 이동하는 거리를 나타냅니다. 예를 들어 "5:1" 비율의 기어박스를 사용하는 경우 [하드웨어 지식](#obtaining-rotation_distance-by-inspecting-the-hardware)으로 회전 거리를 계산한 다음 ` gear_ratio: 5:1`을 구성에 적용합니다.

벨트와 풀리로 구현된 기어링의 경우 풀리의 톱니를 계산하여 gear_ratio 를 결정할 수 있습니다. 예를 들어 16개의 톱니가 있는 도르래가 있는 스테퍼가 80개의 톱니가 있는 다음 풀리를 구동하는 경우 `기어 비율: 80:16` 을 사용합니다. 실제로, 선반 "기어 박스" 에서 공통 기성품을 열고 기어비를 확인하기 위해 그 안에 있는 톱니 수를 세어 볼 수 있습니다.

때때로 기어박스는 광고된 것과 약간 다른 기어비를 가질 수 있습니다. 일반적인 BMG 압출기 모터 기어가 이에 대한 예입니다. "3:1"로 광고되지만 실제로는 "50:17" 기어링을 사용합니다. (공통 분모 없이 톱니 수를 사용하면 톱니가 회전할 때마다 항상 같은 방식으로 맞물리는 것이 아니므로 전체 기어 마모를 개선할 수 있습니다.) 공통 "5.18:1 유성 기어박스"는 `gear_ratio: 57:11 `로 더 정확하게 구성됩니다.

대부분의 경우 gear_ratio는 일반 기어와 풀리에 정수의 톱니가 있으므로 정수로 정의해야 합니다. 그러나 벨트가 톱니 대신 마찰을 사용하여 풀리를 구동하는 경우 기어비에 부동 소수점 숫자를 사용하는 것이 합리적일 수 있습니다 (예: `gear_ratio: 107.237:16`).

대부분의 경우 gear_ratio는 일반 기어와 풀리에 정수의 톱니가 있으므로 정수로 정의해야 합니다. 그러나 벨트가 톱니 대신 마찰을 사용하여 풀리를 구동하는 경우 기어비에 부동 소수점 숫자를 사용하는 것이 합리적일 수 있습니다(예: `gear_ratio: 107.237:16`).
