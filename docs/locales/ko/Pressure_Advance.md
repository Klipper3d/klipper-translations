# Pressure advance

이 문서는 특정 노즐 및 필라멘트에 대한 "Pressure advance" config 변수 조정에 대한 정보를 제공합니다. pressure advance 기능은 ooze (노즐 흘러내림) 를 줄이는 데 도움이 될 수 있습니다. pressure advance 가 구현되는 방법에 대한 자세한 내용은 [kinematics](Kinematics.md) 문서를 참조하십시오.

## pressure advance 튜닝

Pressure advance 는 두 가지 유용한 작업을 수행합니다. 즉, 출력하지 않는 움직임 동안 노즐 흘러내림을 줄이고 코너링 중에 얼룩을 줄입니다. 이 가이드는 튜닝을 위한 메커니즘으로 두 번째 기능(코너링 중 얼룩 감소)을 사용합니다.

튜닝 테스트에는 개체의 인쇄 및 검사가 포함되므로 pressure advance 를 보정하려면 프린터를 구성하고 작동해야 합니다. 테스트를 실행하기 전에 이 문서를 완전히 읽는 것이 좋습니다.

슬라이서를 사용하여 [docs/prints/square_tower.stl](prints/square_tower.stl) 에 있는 큰 속이 빈 사각형에 대한 g-code 를 생성합니다. high speed (예: 100mm/s), zero infill 및 coarse layer height (레이어 높이는 노즐 직경의 약 75% 여야 함) 를 사용합니다.

다음 G-Code 명령을 실행하여 테스트를 준비합니다:

```
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
```

이 명령은 노즐이 코너를 통과하는 속도를 줄여 익스트루더 압력의 영향을 줍니다. 그런 다음 직결식 익스트루더가 있는 프린터의 경우 다음 명령을 실행합니다:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

보우덴 방식의 경우 다음을 사용하십시오:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020
```

그런 다음 개체를 인쇄합니다. 완전히 인쇄되면 테스트 인쇄는 다음과 같습니다:

![tuning_tower](img/tuning_tower.jpg)

위의 TUNING_TOWER 명령은 Klipper가 인쇄물의 각 레이어에서 pressure_advance 설정을 변경하도록 지시합니다. 인쇄물의 레이어가 높을수록 pressure_advance 값이 더 크게 설정됩니다. 이상적인 pressure_advance 설정 아래의 레이어는 모서리에 얼룩이 생기고 이상적인 설정 위의 레이어는 모서리가 둥글고 모서리까지 돌출되지 않게 될 수 있습니다.

모서리가 정상적으로 출력되지 않는다면 인쇄를 일찍 취소할 수 있습니다 (이후에 이상적인 pressure_advance 값보다 높은 것으로 알려진 레이어 인쇄를 피할 수 있습니다).

인쇄물을 검사한 다음 디지털 캘리퍼스를 사용하여 모서리 품질이 가장 좋은 높이를 찾습니다. 확실하지 않은 경우 낮은 높이를 선택하세요.

![tune_pa](img/tune_pa.jpg)

pressure_advance 값은 `pressure_advance = <start> + <measured_height> * <factor>` 로 계산할 수 있습니다. (예를 들어 '0 + 12.90 * .020'은 '.258'이 됩니다.)

최상의 pressure advance 설정을 하기위해 START 및 FACTOR에 대한 사용자 지정 설정을 할 수 있습니다. 이 작업을 수행할 때 각 테스트 인쇄를 시작할 때 TUNING_TOWER 명령을 실행해야 합니다.

일반적인 pressure advance 값은 0.050에서 1.000 사이입니다 (보우덴 압출기에서만 가장 높은 값). 최대 1.000 까지의 pressure advance 으로 유의미한 개선이 없으면 pressure advance 로 인해 인쇄 품질이 향상되지 않을 것입니다. 그러면 pressure advance 비활성화된 기본 구성으로 돌아갑니다.

이 튜닝 연습은 모서리의 품질을 직접적으로 향상시키지만 좋은 pressure advance 또한 인쇄물 전체에 노즐 흘러내림을 감소시킨다는 점에서 가치가 있습니다.

이 테스트가 완료되면 구성 파일의 `[extruder]` 섹션에서 `pressure_advance = <calculated_value>`를 설정하고 RESTART 명령을 실행합니다. RESTART 명령은 테스트 상태를 지우고 가속 및 코너링 속도를 정상 값으로 되돌립니다.

## 중요 참고 사항

* Pressure advance 값은 extruder, 노즐 및 필라멘트에 따라 다릅니다. 다른 제조사의 필라멘트나 다른 안료의 필라멘트는 상당히 다른 pressure advance 값을 요구하는 것이 일반적입니다. 따라서 프린터와 필라멘트 가 변경되면 pressure advance을 보정해야 합니다.
* 인쇄 온도와 압출 속도는 pressure advance 에 영향을 줄 수 있습니다. Pressure advance 를 조정하기 전에 [extruder rotation_distance](Rotation_Distance.md#calibrating-rotation_distance-on-extruders) 및 [nozzle temperature](http://reprap.org/wiki/Triffid_Hunter%27s_Calibration_Guide#Nozzle_Temperature) 를 조정해야 합니다.
* 테스트 인쇄는 높은 extruder 유속으로 실행되도록 설계되었지만 그렇지 않은 경우 "normal" 슬라이서 설정입니다. 높은 인쇄 속도(예: 100mm/s) 와 coarse layer height (일반적으로 노즐 직경의 약 75%)를 사용하여 높은 유량을 얻을 수 있습니다. 다른 슬라이서 설정은 기본값과 유사해야 합니다 (예: 2 또는 3 라인의 둘레, nomal retraction amount). 외부 둘레 속도를 나머지 인쇄물과 같은 속도로 설정하는 것이 유용할 수 있지만 필수 사항은 아닙니다.
* 테스트 인쇄는 각 모서리에서 다른 동작을 보이는 것이 일반적입니다. 종종 슬라이서는 한 모서리에서 레이어를 변경하도록 정렬하여 해당 모서리가 나머지 세 모서리와 크게 다를 수 있습니다. (제봉선 설정) 이 경우 해당 모서리를 무시하고 다른 세 모서리를 사용하여 pressure advance 을 조정하십시오. 나머지 모서리도 약간씩 달라지는 것이 일반적입니다. (이는 특정 방향의 코너링에 프린터 프레임이 반응하는 방식의 작은 차이로 인해 발생할 수 있습니다.) 나머지 모든 모서리에 잘 맞는 값을 선택하십시오. 확실하지 않은 경우 더 낮은 pressure advance 값을 선택하십시오.
* 높은 pressure advance 값(예: 0.200 이상)이 사용되면 프린터의 정상 가속으로 돌아갈 때 익스트루더가 탈조되는 것을 발견할 수 있습니다. 높은 가속도와 높은 pressure advance 으로 익스트루더는 필요한 필라멘트를 밀어내기에 충분한 토크가 부족할 수 있습니다. 이 경우 더 낮은 가속 값을 사용하거나 pressure advance 을 비활성화하십시오.
* Klipper에서 pressure advance 이 튜닝 되면 슬라이서에서 small retract 값(예: 0.75mm) 을 구성하고 가능한 경우 슬라이서의 "wipe on retract option" 을 활용하는 것이 여전히 유용할 수 있습니다. 이러한 슬라이서 설정은 필라멘트 응고 (플라스틱의 끈적거림으로 인해 노즐에서 필라멘트가 빠져나옴) 으로 인한 스며나오는 것을 방지하는 데 도움이 될 수 있습니다. 슬라이서의 "z-lift on retract" 옵션을 비활성화하는 것이 좋습니다.
* Pressure advance 시스템은 툴 헤드의 타이밍이나 경로를 변경하지 않습니다. pressure advance 가 활성화된 인쇄는 pressure advance 이 없는 인쇄와 같은 시간이 걸립니다. pressure advance 은 또한 인쇄 중에 압출되는 필라멘트의 총량을 변경하지 않습니다. pressure advance 로 인해 이동 가속 및 감속 중에 익스트루더가 추가로 이동합니다. 매우 높은 pressure advance 설정은 가속 및 감속 중에 매우 많은 양의 압출기 이동을 초래하며 구성 설정은 해당 이동량에 제한을 두지 않습니다.
