# 운동학

이 문서는 Klipper가 로봇 모션을 구현하는 방법에 대한 개요를 제공합니다 ([운동학](https://en.wikipedia.org/wiki/Kinematics)). 아래 내용은 Klipper 소프트웨어 작업에 관심이 있는 개발자와 기계의 역학을 더 잘 이해하는데 관심이 있는 사용자 모두에게 흥미로울 수 있습니다.

## 가속도

Klipper는 프린트 헤드가 속도를 변경할 때마다 일정한 가속을 합니다. 속도는 갑자기 급상승하지 않고 점진적으로 새로운 속도로 변경됩니다. Klipper는 항상 툴헤드와 인쇄물 사이에 가속을 적용합니다. 익스트루더를 떠나는 필라멘트는 매우 약할 수 있기 때문에 급격한 저크 및/또는 압출기 흐름 변화는 출력물의 품질과 베드 접착력을 저하시킵니다. 압출되지 않은 상태에서도 프린트 헤드가 프린트와 같은 높이에 있으면 헤드의 급격한 요동으로 최근에 출력된 필라멘트가 손상될 수 있습니다. 이 때 프린트 헤드의 속도 변경을 제한하면 출력이 실패할 위험이 줄어듭니다.

스테퍼 모터가 탈조하거나 기계에 과도한 스트레스를 주지 않도록 가속을 제한하는 것도 중요합니다. Klipper는 프린트 헤드의 가속을 제한함으로써 각 스테퍼의 토크를 제한합니다. 프린트 헤드에 가속을 적용하면 프린트 헤드를 움직이는 스테퍼의 토크도 자연스럽게 제한됩니다(반대의 경우가 항상 있는 것은 아닙니다).

Klipper는 일정한 가속을 구현합니다. 등가속도의 핵심 공식은 다음과 같습니다:

```
velocity(time) = start_velocity + accel*time
```

## 사다리꼴 생성기

Klipper는 기존의 "사다리꼴 생성기"를 사용하여 각 동작의 동작을 모델링합니다. 각 동작에는 시작 속도가 있고, 일정한 가속에서 순항 속도로 가속하고, 일정한 속도로 순항한 다음, 일정한 가속을 사용하여 끝 속도로 감속합니다.

![사다리꼴](img/trapezoid.svg.png)

움직임의 속도 다이어그램이 사다리꼴처럼 보이기 때문에 이것을 "사다리꼴 생성기" 이라고 합니다.

순항 속도는 항상 시작 속도와 끝 속도보다 크거나 같습니다. 가속 단계는 지속 시간이 0일 수 있고(시작 속도가 순항 속도와 동일한 경우) 순항 단계는 지속 시간이 0일 수 있으며(가속 후 즉시 감속이 시작되는 경우), 감속 단계는 0일 수 있습니다. 지속 시간(종료 속도가 순항 속도와 동일한 경우).

![사다리꼴](img/trapezoids.svg.png)

## 예측 (look-ahead)

"예측" 시스템은 움직임 사이의 코너링 속도를 결정하는 데 사용됩니다.

XY 평면에서 일어날 수 있는 다음 두 가지 이동을 생각해 보십시오:

![코너](img/corner.svg.png)

위의 상황에서 첫 번째 이동 후에 완전히 감속한 후 다음 이동을 시작할 때 완전히 가속하는 것도 가능하지만, 이런 모든 가속과 감속이 출력 시간을 크게 증가시키고 압출기 흐름의 빈번한 변화를 증가시키므로 이상적이지 않습니다. 또한 이로인해 인쇄 품질도 떨어질 수 있습니다.

이를 해결하기 위해 "예측" 메커니즘은 들어오는 여러 움직임을 대기열에 넣고 움직임 사이의 각도를 분석하여 두 움직임 사이의 "연결" 동안 얻을 수 있는 합리적인 속도를 결정합니다. 다음 움직임이 거의 같은 방향에 있으면 해드만 약간 느려지면 됩니다.

![예측](img/lookahead.svg.png)

그러나 다음 이동이 예각을 형성하는 경우(헤드가 다음 이동에서 거의 반대 방향으로 이동하게 됨) 작은 연결 속도만 허용됩니다.

![예측](img/lookahead-slow.svg.png)

연결 속도는 "approximated centripetal acceleration"를 사용하여 결정됩니다. [저자 설명](https://onehossshay.wordpress.com/2011/09/24/improving_grbl_cornering_algorithm/)을 참고. 그러나 Klipper에서 연결 속도는 90° 모서리가 가져야 하는 원하는 속도("정사각형 모서리 속도")를 지정하여 구성되며 다른 각도에 대한 접합 속도는 여기서 파생됩니다.

예측을 위한 핵심 공식:

```
end_velocity^2 = start_velocity^2 + 2*accel*move_distance
```

### 부드러운 예측 (Smoothed Look-ahed)

Klipper는 또한 짧은 "지그재그" 동작을 부드럽게 하는 메커니즘을 구현합니다. 다음 동작을 살펴보세요:

![지그재그](img/zigzag.svg.png)

위의 경우 가속에서 감속으로의 빈번한 변화는 기계를 진동시켜 기계에 스트레스를 일으키고 소음을 증가시킬 수 있습니다.이를 줄이기 위해 Klipper는 일반적인 이동 가속과 가상 "가속에서 감속" 비율을 모두 추적합니다. 이 시스템을 사용하면 이러한 짧은 "지그재그" 이동의 최고 속도는 프린터 동작을 부드럽게 하기 위해 제한됩니다:

![smoothed](img/smoothed.svg.png)

특히 코드는 이 가상 "가감속 가속" 비율 (기본적으로 정상 가속 비율의 절반)로 제한되는 경우 각 이동의 속도를 계산합니다. 위의 그림에서 회색 점선은 첫 번째 이동에 대한 가상 가속도를 나타냅니다. 이동이 이 가상 가속도를 사용하여 최대 순항 속도에 도달할 수 없는 경우 최고 속도는 이 가상 가속도에서 얻을 수 있는 최대 속도로 감소됩니다. 대부분의 동작에 대해 제한은 이동의 기존 제한 이상이며 동작의 변화가 생기지 않습니다. 그러나 짧은 지그재그 이동의 경우 이 제한으로 인해 최고 속도가 감소합니다. 이동 내 실제 가속은 변경되지 않습니다. 이동은 조정된 최고 속도까지 일반 가속 계획을 계속 사용합니다.

## step 생성

예측 프로세스가 완료되면 주어진 이동에 대한 프린트 헤드 이동이 완전히 정해지고 (시간, 시작 위치, 종료 위치, 각 지점의 속도) 이동에 대한 step 시간을 생성할 수 있습니다. 이 프로세스는 Klipper 코드의 "운동학 클래스" 내에서 수행됩니다. 이러한 운동학 클래스 외부에서 모든 것은 밀리미터, 초 및 데카르트 좌표 공간에서 추적됩니다. 일반 좌표계에서 특정 프린터의 하드웨어 특성으로 변환하는 것은 운동학 클래스의 작업입니다.

Klipper는 [iterative solver](https://en.wikipedia.org/wiki/Root-finding_algorithm) 를 사용하여 각 스테퍼에 대한 step 시간을 생성합니다. 코드에는 매순간 헤드의 이상적인 직교 좌표를 계산하는 공식이 포함되어 있으며 이러한 직교 좌표를 기반으로 이상적인 스테퍼 위치를 계산하는 운동학 공식이 있습니다.이 공식을 사용하여 Klipper는 스테퍼가 각 step 위치에 있어야 하는 이상적인 시간을 결정할 수 있습니다. 그런 다음 주어진 step이 계산된 시간에 스케줄링됩니다.

일정한 가속도에서 이동해야 하는 거리를 결정하는 핵심 공식은 다음과 같습니다:

```
move_distance = (start_velocity + .5 * accel * move_time) * move_time
```

등속 운동의 핵심 공식은 다음과 같습니다:

```
move_distance = cruise_velocity * move_time
```

이동 거리가 주어진 이동의 직교 좌표를 결정하는 주요 공식은 다음과 같습니다:

```
cartesian_x_position = start_x + move_distance * total_x_movement / total_movement
cartesian_y_position = start_y + move_distance * total_y_movement / total_movement
cartesian_z_position = start_z + move_distance * total_z_movement / total_movement
```

### 직교 로봇

직교 프린터에 대한 step을 생성하는 것이 가장 간단한 경우입니다. 각 축의 움직임은 데카르트 좌표계의 움직임과 직접 관련이 있습니다.

주요 공식:

```
stepper_x_position = cartesian_x_position
stepper_y_position = cartesian_y_position
stepper_z_position = cartesian_z_position
```

### 코어XY 로봇

CoreXY 기계에서 step을 생성하는 것은 기본 직교 로봇보다 약간 더 복잡합니다. 주요 공식은 다음과 같습니다:

```
stepper_a_position = cartesian_x_position + cartesian_y_position
stepper_b_position = cartesian_x_position - cartesian_y_position
stepper_z_position = cartesian_z_position
```

### 델타 로봇

델타 로봇의 step 생성은 피타고라스의 정리를 기반으로 합니다:

```
stepper_position = (sqrt(arm_length^2
                         - (cartesian_x_position - tower_x_position)^2
                         - (cartesian_y_position - tower_y_position)^2)
                    + cartesian_z_position)
```

### 스테퍼 모터 가속 제한

델타 운동학을 사용하면 직교 방식 운동학 가속도보다 더 큰 스테퍼 모터의 가속도를 요구할 수 있습니다. 이것은 스테퍼 암이 수직보다 수평이고 이동 선이 스테퍼 타워 근처를 지날 때 발생할 수 있습니다. 이러한 이동에는 프린터의 구성된 최대 이동 가속보다 더 큰 스테퍼 모터 가속이 필요할 수 있지만 해당 스테퍼에 의해 이동되는 유효 질량은 더 작습니다. 따라서 더 높은 스테퍼 가속은 훨씬 더 높은 스테퍼 토크를 초래하지 않으므로 무해한 것으로 간주됩니다.

그러나 극단적인 경우를 피하기 위해 Klipper는 프린터에 구성된 최대 이동 가속도의 3배로 스테퍼 가속에 대한 최대 상한을 적용합니다. (마찬가지로 스테퍼의 최대 속도는 최대 이동 속도의 3배로 제한됩니다.) 이 제한을 적용하기 위해 빌드 엔벨로프의 끝단 (스테퍼 암이 거의 수평일 수 있는 곳) 에서의 최대 가속도와 속도가 더 낮아집니다.

### 익스트루더 운동학

Klipper는 자체 운동학 클래스에서 익스트루더 동작을 구현합니다. 각 프린트 헤드 움직임의 타이밍과 속도는 이미 결정되었기 때문에 프린트 헤드 움직임의 step 시간 계산과 독립적으로 익스트루더의 step 시간을 계산할 수 있습니다.

기본적인 익스트루더 움직임은 계산하기 쉽습니다. step 시간 생성은 직교 로봇이 사용하는 것과 동일한 공식을 사용합니다:

```
stepper_position = requested_e_position
```

### Pressure advance

실험을 통해 기본 익스트루더 공식 이상으로 익스트루더의 모델링을 개선할 수 있음이 나타났습니다. 이상적인 경우 익스트루더 이동이 진행됨에 따라 각 지점에 동일한 부피의 필라멘트가 쌓여야 하며 이동 후 압출되는 부피가 없어야 합니다. 불행히도, 기본 익스트루더 공식으로 인해 이동이 시작될 때 익스트루더를 빠져나가는 필라멘트가 너무 적고 압출 종료 후에 과도한 필라멘트가 압출된다는 사실을 발견하는 것이 일반적입니다. 이것을 흔히 "ooze"라고 합니다.

![ooze](img/ooze.svg.png)

"pressure advance" 시스템은 익스트루더에 대해 다른 모델을 사용하여 이를 설명하려고 시도합니다. 익스트루더로 공급되는 필라멘트의 각 mm^3가 익스트루더에서 즉시 나오는 mm^3의 양을 초래할 것이라고 순진하게 믿는 대신 압력을 기반으로 한 모델을 사용합니다. 필라멘트가 익스트루더로 밀릴 때 압력이 증가하고 ([Hooke의 법칙](https://en.wikipedia.org/wiki/Hooke%27s_law)에서와 같이) 압출에 필요한 압력은 노즐 오리피스를 통한 유량에 의해 지배됩니다. ([Poiseuille의 법칙](https://en.wikipedia.org/wiki/Poiseuille_law) 에서와 같이). 핵심 아이디어는 필라멘트, 압력 및 유속 간의 관계를 선형 계수를 사용하여 모델링할 수 있다는 것입니다:

```
pa_position = nominal_position + pressure_advance_coefficient * nominal_velocity
```

이 압력 조절 계수를 찾는 방법에 대한 정보는 [pressure advance](Pressure_Advance.md) 문서를 참조하십시오.

기본 압력 조절 공식으로 인해 익스트루더 모터가 급격한 속도 변화를 일으킬 수 있습니다. Klipper는 이를 피하기 위해 익스트루더 움직임의 "smoothing"를 구현합니다.

![pressure-advance](img/pressure-velocity.png)

위의 그래프는 0이 아닌 코너링 속도가 있는 두 개의 돌출 움직임의 예를 보여줍니다. pressure advance 시스템은 가속 중에 추가 필라멘트를 압출기로 밀어 넣습니다. 원하는 필라멘트 유속이 높을수록 압력에 대응하기 위해 가속 중에 더 많은 필라멘트를 밀어 넣어야 합니다. 헤드 감속 중에 추가 필라멘트가 리트렉션 됩니다. (익스트루더는 음의 속도를 가짐).

"smoothing"은 짧은 기간 동안 익스트루더 위치의 가중 평균을 사용하여 구현됩니다 (`pressure_advance_smooth_time` config 매개변수로 결정됨). 이 평균화는 여러 g-code 이동에 걸쳐 있을 수 있습니다. 압출기 모터가 첫 번째 압출 이동의 시작 이전에 어떻게 움직이기 시작하고 마지막 압출 이동의 종료 후에도 계속 움직이는지 확인하십시오.

"smoothed pressure advance"의 핵심 공식:

```
smooth_pa_position(t) =
    ( definitive_integral(pa_position(x) * (smooth_time/2 - abs(t - x)) * dx,
                          from=t-smooth_time/2, to=t+smooth_time/2)
     / (smooth_time/2)^2 )
```
