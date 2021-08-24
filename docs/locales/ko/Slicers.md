# Slicers

이 문서는 Klipper와 함께 사용할 "슬라이서" 애플리케이션을 구성하기 위한 몇 가지 팁을 제공합니다. Klipper와 함께 사용되는 일반적인 슬라이서는 Slic3r, Cura, Simplify3D 등입니다.

## G-Code flavor를 Marlin로 설정

많은 슬라이서에는 "G-Code flavor"를 구성하는 옵션이 있습니다. 기본값은 종종 "Marlin"이며 Klipper와도 잘 작동합니다. "Smoothieware" 설정도 Klipper에서도 잘 작동합니다.

## Klipper gcode_macro

슬라이서는 종종 "G 코드 시작" 및 "G 코드 종료" 시퀀스를 구성할 수 있습니다. 대신 Klipper 구성 파일에서 `[gcode_macro START_PRINT]` 및 `[gcode_macro END_PRINT]`와 같은 사용자 정의 매크로를 정의하는 것이 편리한 경우가 많습니다. 그런 다음 슬라이서 구성에서 START_PRINT 및 END_PRINT를 실행할 수 있습니다. Klipper 구성에서 이러한 작업을 정의하면 변경 시 다시 슬라이싱할 필요가 없으므로 프린터의 시작 및 종료 단계를 더 쉽게 조정할 수 있습니다.

예를 들어 [sample-macros.cfg](../config/sample-macros.cfg)를 참조하십시오. START_PRINT 및 END_PRINT 매크로.

gcode_macro 정의에 대한 자세한 내용은 [config reference](Config_Reference.md#gcode_macro) 를 참조하십시오.

## 큰 retraction 설정은 Klipper 조정이 필요할 수 있습니다

Retraction 동작의 최대 속도와 가속도는 Klipper에서 `max_extrude_only_velocity` 및 `max_extrude_only_accel` 구성 설정에 의해 제어됩니다. 이러한 설정에는 많은 프린터에서 잘 작동하는 기본값이 있습니다. 그러나 슬라이서에서 큰 tretraction을 구성한 경우(예: 5mm 이상) 원하는 후퇴 속도를 제한할 수 있습니다.

큰 retraction을 사용하는 경우 대신 Klipper의 [압력 전진](Pressure_Advance.md) 조정을 고려하십시오. 그렇지 않고 공구 헤드가 retraction 및 priming 중에 "일시 중지"되는 것으로 보인다면 Klipper 구성 파일에서 `max_extrude_only_velocity` 및 `max_extrude_only_accel`을 명시적으로 정의하는 것을 고려하십시오.

## "coasting" 을 활성화하지 마십시오

"coasting" 기능으로 인해 Klipper에서 인쇄 품질이 떨어질 수 있습니다. 대신 Klipper의 [압력 전진](Pressure_Advance.md) 사용을 고려하십시오.

특히, 슬라이서가 이동 사이의 extrusion 속도를 크게 변경하면 Klipper는 이동 사이에 감속 및 가속을 수행합니다. 이것은 blobbing을 더 낫게 만드는 것이 아니라 더 나쁘게 만들 가능성이 있습니다.

대조적으로, 슬라이서의 "retract" 설정, "wipe" 설정 및/또는 "retract 시 wipe" 설정을 사용하는 것이 좋습니다(그리고 종종 도움이 됩니다).

## Simplify3d에서 "extra restart distance"를 사용하지 마십시오

이 설정은 Klipper의 최대 압출 단면 검사를 트리거할 수 있는 extrusion rates에 극적인 변화를 일으킬 수 있습니다. 대신 Klipper의 [pressure advance](Pressure_Advance.md) 또는 일반 Simplify3d retract setting을 사용하는 것이 좋습니다.

## KISSlicer에서 "PreloadVE" 비활성화

KISSlicer 슬라이싱 소프트웨어를 사용하는 경우 "PreloadVE"를 0으로 설정하십시오. 대신 Klipper의 [pressure advance](Pressure_Advance.md) 사용을 고려하십시오.

## "고급 압출기 압력" 설정 비활성화

일부 슬라이서는 "고급 압출기 압력" 기능을 광고합니다. Klipper를 사용할 때는 이러한 옵션을 사용하지 않는 것이 좋습니다. 인쇄 품질이 떨어질 수 있기 때문입니다. 대신 Klipper의 [pressure advance](Pressure_Advance.md) 사용을 고려하십시오.

특히, 이러한 슬라이서 설정은 펌웨어가 이러한 요청에 근접하고 프린터가 대략적으로 원하는 압출기 압력을 얻을 것이라는 희망으로 extrusion rate를 크게 변경하도록 펌웨어에 지시할 수 있습니다. 그러나 Klipper는 정확한 운동학적 계산과 타이밍을 활용합니다. Klipper가 extrusion rate를 크게 변경하라는 명령을 받으면 속도, 가속도 및 압출기 움직임에 대한 해당 변경을 계획합니다. 이는 슬라이서의 의도가 아닙니다. 슬라이서는 Klipper의 최대 압출 단면 검사를 트리거하는 지점까지 과도한 extrusion rate를 명령할 수도 있습니다.

대조적으로, 슬라이서의 "retract" 설정, "wipe" 설정 및/또는 "retract 시 wipe" 설정을 사용하는 것이 좋습니다(그리고 종종 도움이 됩니다).
