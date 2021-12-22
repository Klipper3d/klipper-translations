# TMC 드라이버

이 문서는 Klipper의 SPI/UART 모드에서 Trinamic 스테퍼 모터 드라이버를 사용하는 방법에 대한 정보를 제공합니다.

Klipper는 "standalone mode"에서 Trinamic 드라이버를 사용할 수도 있습니다. 그러나 드라이버가 이 모드에 있으면 특별한 Klipper 구성이 필요하지 않으며 이 문서에서 설명하는 고급 Klipper 기능을 사용할 수 없습니다.

이 문서 외에 [TMC 드라이버 구성 참조](Config_Reference.md#tmc-stepper-driver-configuration)를 반드시 검토하십시오.

## Tuning motor current

A higher driver current increases positional accuracy and torque. However, a higher current also increases the heat produced by the stepper motor and the stepper motor driver. If the stepper motor driver gets too hot it will disable itself and Klipper will report an error. If the stepper motor gets too hot, it loses torque and positional accuracy. (If it gets very hot it may also melt plastic parts attached to it or near it.)

As a general tuning tip, prefer higher current values as long as the stepper motor does not get too hot and the stepper motor driver does not report warnings or errors. In general, it is okay for the stepper motor to feel warm, but it should not become so hot that it is painful to touch.

## Prefer to not specify a hold_current

If one configures a `hold_current` then the TMC driver can reduce current to the stepper motor when it detects that the stepper is not moving. However, changing motor current may itself introduce motor movement. This may occur due to "detent forces" within the stepper motor (the permanent magnet in the rotor pulls towards the iron teeth in the stator) or due to external forces on the axis carriage.

Most stepper motors will not obtain a significant benefit to reducing current during normal prints, because few printing moves will leave a stepper motor idle for sufficiently long to activate the `hold_current` feature. And, it is unlikely that one would want to introduce subtle print artifacts to the few printing moves that do leave a stepper idle sufficiently long.

If one wishes to reduce current to motors during print start routines, then consider issuing [SET_TMC_CURRENT](G-Codes.md#tmc-stepper-drivers) commands in a [START_PRINT macro](Slicers.md#klipper-gcode_macro) to adjust the current before and after normal printing moves.

Some printers with dedicated Z motors that are idle during normal printing moves (no bed_mesh, no bed_tilt, no Z skew_correction, no "vase mode" prints, etc.) may find that Z motors do run cooler with a `hold_current`. If implementing this then be sure to take into account this type of uncommanded Z axis movement during bed leveling, bed probing, probe calibration, and similar. The `driver_TPOWERDOWN` and `driver_IHOLDDELAY` should also be calibrated accordingly. If unsure, prefer to not specify a `hold_current`.

## Setting "spreadCycle" vs "stealthChop" Mode

By default, Klipper places the TMC drivers in "spreadCycle" mode. If the driver supports "stealthChop" then it can be enabled by adding `stealthchop_threshold: 999999` to the TMC config section.

In general, spreadCycle mode provides greater torque and greater positional accuracy than stealthChop mode. However, stealthChop mode may produce significantly lower audible noise on some printers.

Tests comparing modes have shown an increased "positional lag" of around 75% of a full-step during constant velocity moves when using stealthChop mode (for example, on a printer with 40mm rotation_distance and 200 steps_per_rotation, position deviation of constant speed moves increased by ~0.150mm). However, this "delay in obtaining the requested position" may not manifest as a significant print defect and one may prefer the quieter behavior of stealthChop mode.

It is recommended to always use "spreadCycle" mode (by not specifying `stealthchop_threshold`) or to always use "stealthChop" mode (by setting `stealthchop_threshold` to 999999). Unfortunately, the drivers often produce poor and confusing results if the mode changes while the motor is at a non-zero velocity.

## TMC interpolate setting introduces small position deviation

The TMC driver `interpolate` setting may reduce the audible noise of printer movement at the cost of introducing a small systemic positional error. This systemic positional error results from the driver's delay in executing "steps" that Klipper sends it. During constant velocity moves, this delay results in a positional error of nearly half a configured microstep (more precisely, the error is half a microstep distance minus a 512th of a full step distance). For example, on an axis with a 40mm rotation_distance, 200 steps_per_rotation, and 16 microsteps, the systemic error introduced during constant velocity moves is ~0.006mm.

For best positional accuracy consider using spreadCycle mode and disable interpolation (set `interpolate: False` in the TMC driver config). When configured this way, one may increase the `microstep` setting to reduce audible noise during stepper movement. Typically, a microstep setting of `64` or `128` will have similar audible noise as interpolation, and do so without introducing a systemic positional error.

If using stealthChop mode then the positional inaccuracy from interpolation is small relative to the positional inaccuracy introduced from stealthChop mode. Therefore tuning interpolation is not considered useful when in stealthChop mode, and one can leave interpolation in its default state.

## 센서리스 원점복귀

센서리스 원점복귀는 물리적 리미트 스위치 없이도 축을 원점복귀할 수 있습니다. 대신 축의 캐리지가 기계적 한계지점으로 이동되어 스테퍼 모터가 step제어가 풀리게 됩니다. 스테퍼 드라이버는 손실된 단계를 감지하고 핀을 토글하여 제어 MCU(Klipper)에 이를 표시합니다. 이 정보는 Klipper에서 축의 끝점으로 사용할 수 있습니다.

이 가이드는 (직교) 프린터의 X 축에 대한 센서리스 원점 복귀 설정을 다룹니다. 그러나 다른 모든 축(끝 정지가 필요한 축)과 동일하게 작동합니다. 한 번에 하나의 축에 대해 구성하고 조정해야 합니다.

### 제한사항

기계 구성 요소가 축의 한계에 반복적으로 부딪치는 캐리지의 하중을 처리할 수 있는지 확인하십시오. 특히 리드스크류는 많은 힘을 발생시킬 수 있습니다. 노즐을 인쇄 표면에 부딪혀 Z축의 원점 복귀는 좋은 생각이 아닐 수 있습니다. 최상의 결과를 얻으려면 축 캐리지가 축 제한에 단단히 닿는지 확인하십시오.

또한 센서리스 원점 복귀는 프린터에 대해 충분히 정확하지 않을 수 있습니다. 직교 기계에서 X 및 Y 축의 귀환은 잘 작동할 수 있지만 Z 축의 귀환은 일반적으로 충분히 정확하지 않으며 일관되지 않은 첫 번째 레이어 높이를 초래할 수 있습니다. 센서가 없는 델타 프린터의 원점 복귀는 정확도가 떨어지므로 권장하지 않습니다.

또한 스테퍼 드라이버의 stall 감지는 모터의 기계적 부하, 모터 전류 및 모터 온도(코일 저항)에 따라 달라집니다.

센서리스 원점 복귀는 모터의 적절한 속도에서 가장 잘 작동합니다. 매우 느린 속도(10RPM 미만)의 경우 모터는 상당한 역기전력을 생성하지 않으며 TMC는 모터 stall을 안정적으로 감지할 수 없습니다. 또한 매우 빠른 속도에서 모터의 역기전력이 모터의 공급 전압에 접근하므로 TMC는 더 이상 stall을 감지할수 없습니다. TMC의 데이터시트를 살펴보는 것이 좋습니다. 여기에서 이 설정의 제한 사항에 대한 자세한 내용도 찾을 수 있습니다.

### 전제조건

센서리스 원점 복귀를 사용하려면 몇 가지 전제 조건이 필요합니다:

1. A stallGuard capable TMC stepper driver (tmc2130, tmc2209, tmc2660, or tmc5160).
1. 마이크로 컨트롤러에 연결된 TMC 드라이버의 SPI/UART 인터페이스 (stand-alone 모드는 작동하지 않음).
1. 마이크로 컨트롤러에 연결된 TMC 드라이버의 적절한 "DIAG" 또는 "SG_TST" 핀.
1. [구성 검사](Config_checks.md) 문서의 단계를 실행하여 스테퍼 모터가 구성되고 제대로 작동하는지 확인해야 합니다.

### 조정

여기에 설명된 절차에는 6가지 주요 단계가 있습니다:

1. 원점 복귀 속도를 선택합니다.
1. 센서리스 원점 복귀를 활성화하도록 `printer.cfg` 파일을 구성합니다.
1. 성공적으로 홈에 도달하는 가장 높은 민감도의 stallguard 설정을 찾으십시오.
1. 한번의 터치로 성공적으로 홈으로 돌아가는 최저 민감도의 stallguard 설정을 찾으십시오.
1. 원하는 stallguard 설정으로 `printer.cfg`를 업데이트하십시오.
1. 일관되게 홈에 대한 `printer.cfg` 매크로를 생성하거나 업데이트합니다.

#### 원점복귀 속도 선택

원점복귀 속도는 센서리스 원점복귀를 수행할 때 중요한 선택입니다. 레일 끝부분에 닿을 때 캐리지가 프레임에 과도한 힘을 가하지 않도록 느린 원점복귀 속도를 사용하는 것이 바람직합니다. 그러나 TMC 드라이버는 매우 느린 속도에서는 stall을 안정적으로 감지할 수 없습니다.

원점복귀 속도의 좋은 시작점은 스테퍼 모터가 2초마다 완전히 회전하는 것입니다. 많은 축의 경우 이는 `rotation_distance`를 2로 나눈 값입니다. 예를 들어:

```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### 센서리스 원점복귀를 위해 printer.cfg 구성

두 번째 원점복귀 이동을 비활성화하려면 `stepper_x` 구성 섹션에서 `homing_retract_dist` 설정은 0으로 설정해야 합니다. 두 번째 원점복귀 시도는 센서리스 원점복귀를 사용할 때 설정값을 추가하지 않으며 안정적으로 작동하지 않으며 튜닝 프로세스를 혼란스럽게 합니다.

config의 TMC 드라이버 섹션에 `hold_current` 설정이 지정되지 않았는지 확인하십시오. (hold_current가 설정되면 접촉 후 캐리지가 레일의 끝 부분에 대해 눌러지는 동안 모터가 정지하고 해당 위치에서 전류를 줄이면 캐리지가 움직일 수 있습니다. 이는 성능이 저하 및 튜닝과정 혼란을 초래할 수 있습니다.)

센서리스 귀환 핀을 구성하고 초기 "stallguard" 설정을 구성해야 합니다. X축에 대한 tmc2209 예제 구성은 다음과 같습니다:

```
[tmc2209 stepper_x]
diag_pin: ^PA1      # Set to MCU pin connected to TMC DIAG pin
driver_SGTHRS: 255  # 255 is most sensitive value, 0 is least sensitive
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

tmc2130 또는 tmc5160 구성의 예는 다음과 같습니다:

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # Pin connected to TMC DIAG1 pin (or use diag0_pin / DIAG0 pin)
driver_SGT: -64  # -64 is most sensitive value, 63 is least sensitive
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

tmc2660 구성의 예는 다음과 같습니다:

```
[tmc2660 stepper_x]
driver_SGT: -64     # -64 is most sensitive value, 63 is least sensitive
...

[stepper_x]
endstop_pin: ^PA1   # Pin connected to TMC SG_TST pin
homing_retract_dist: 0
...
```

위의 예는 센서리스 원점복귀와 관련된 설정만 보여줍니다. 사용 가능한 모든 옵션은 [구성 참조](Config_Reference.md#tmc-stepper-driver-configuration) 를 참조하세요.

#### 원점복귀에 가장 높은 민감도 성공적으로 찾기

레일 중앙 근처에 캐리지를 놓습니다. SET_TMC_FIELD 명령을 사용하여 가장 높은 민감도를 설정합니다. tmc2209의 경우:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

tmc2130, tmc5160 및 tmc2660의 경우:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

그런 다음 `G28 X0` 명령을 실행하고 축이 전혀 움직이지 않는지 확인합니다. 축이 움직이면 `M112`를 실행하여 프린터를 중지합니다. diag/sg_tst 핀 배선 또는 구성이 올바르지 않으므로 계속하기 전에 수정해야 합니다.

다음으로 `VALUE` 설정의 감도를 지속적으로 낮추고 `SET_TMC_FIELD` `G28 X0` 명령을 다시 실행하여 캐리지가 엔드스톱까지 성공적으로 이동하고 정지하게 하는 가장 높은 감도를 찾습니다. (tmc2209 드라이버의 경우 SGTHRS가 감소하고 다른 드라이버의 경우 sgt가 증가합니다.) 각 시도를 레일 중앙 근처에서 시작해야 합니다(필요한 경우 `M84`를 발행한 다음 캐리지를 수동으로 센터). 가장 높은 감도를 안정적으로 찾을 수 있어야 합니다(감도가 높은 설정은 움직임이 적거나 없음). 발견된 값을 *maximum_sensitivity*로 기록합니다. (캐리지 이동 없이 가능한 최소 감도(SGTHRS=0 또는 sgt=63)를 얻은 경우 diag/sg_tst 핀 배선 또는 구성에 문제가 있는 것이므로 계속하기 전에 수정해야 합니다.)

maximum_sensitivity를 검색할 때 다른 VALUE 설정으로 이동하는 것이 편리할 수 있습니다(VALUE 매개변수를 이등분하기 위해). 이 작업을 수행하는 경우 `M112` 명령을 실행하여 프린터를 중지할 준비를 하십시오. 매우 낮은 감도로 설정하면 축이 레일 끝에 반복적으로 "쿵"할 수 있기 때문입니다.

각 원점복귀 시도 사이에 몇 초 정도 기다려야 합니다. TMC 드라이버가 stall을 감지한 후 내부 표시기를 지우고 다른 stall을 감지할 수 있을 때까지 약간의 시간이 걸릴 수 있습니다.

이러한 튜닝 테스트 중에 `G28 X0` 명령이 축 제한까지 완전히 이동하지 않으면 일반 이동 명령(예: `G1`)을 실행할 때 주의하십시오. Klipper는 캐리지 위치를 올바르게 이해하지 못하며 이동 명령은 바람직하지 않고 혼란스러운 결과를 초래할 수 있습니다.

#### 원터치로 원점복귀에 가장 낮은 민감도 찾기

찾은 *maximum_sensitivity* 값으로 원점 복귀할 때 축은 레일 끝으로 이동하고 "한 번의 터치"로 정지해야 합니다. 즉, "딸깍" 또는 "쿵" 소리가 없어야 합니다. (max_sensitivity에서 두드리는 소리나 딸깍하는 소리가 나면 homing_speed가 너무 낮거나 드라이버 전류가 너무 낮거나 센서리스 homing이 축에 적합한 선택이 아닐 수 있습니다.)

다음 단계는 캐리지를 계속해서 레일 중앙 근처의 위치로 이동하고 민감도를 낮추고 `SET_TMC_FIELD` `G28 X0` 명령을 실행하는 것입니다. 이제 목표는 여전히 캐리지가 "한 번의 터치"로 성공적으로 원점 복귀할 수 있는 가장 낮은 민감도를 찾는 것입니다. 즉, 레일 끝부분에 닿았을 때 "쾅"하거나 "딸깍"하지 않습니다. 발견된 값을 *minimum_sensitivity*로 기록합니다.

#### 민감도 값으로 printer.cfg 업데이트

*maximum_sensitivity* 및 *minimum_sensitivity*를 찾은 후 계산기를 사용하여 권장 민감도를 *minimum_sensitivity + (maximum_sensitivity - minimum_sensitivity)/3*로 구합니다. 권장 민감도는 최소값과 최대값 사이의 범위에 있어야 하지만 최소값에 약간 더 가깝습니다. 최종 값을 가장 가까운 정수 값으로 반올림합니다.

tmc2209의 경우 구성에서 `driver_SGTHRS`로 설정하고 다른 TMC 드라이버의 경우 구성에서 `driver_SGT`로 설정합니다.

*maximum_sensitivity*와 *minimum_sensitivity* 사이의 범위가 작으면(예: 5 미만) 불안정한 원점 복귀가 발생할 수 있습니다. 원점복귀 속도가 빠를수록 범위가 넓어지고 안정적인 작동이 가능합니다.

드라이버 전류, 원점복귀 속도가 변경되거나 프린터 하드웨어가 눈에 띄게 변경되면 조정 프로세스를 다시 실행해야 합니다.

#### 원점 복귀 시 매크로 사용

센서리스 원점복귀가 완료되면 캐리지가 레일의 끝 부분에 대해 눌려지고 스테퍼는 캐리지가 멀리 이동할 때까지 프레임에 힘을 가합니다. 축을 홈으로 이동하고 즉시 캐리지를 레일 끝에서 멀리 이동하는 매크로를 만드는 것이 좋습니다.

센서리스 원점복귀를 시작하기 최소 2초 전에 매크로를 일시 중지하는 것이 좋습니다(또는 2초 동안 스테퍼에서 움직임이 없는지 확인). 지연 없이 드라이버의 내부 stall flag가 이전 이동에서 계속 설정될 수 있습니다.

It can also be useful to have that macro set the driver current before homing and set a new current after the carriage has moved away.

예제 매크로는 다음과 같습니다:

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # Set current for sensorless homing
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # Pause to ensure driver stall flag is clear
    G4 P2000
    # Home
    G28 X0
    # Move away
    G90
    G1 X5 F1200
    # Set current during print
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

결과 매크로는 [homing_override 구성 섹션](Config_Reference.md#homing_override) 또는 [START_PRINT 매크로](Slicers.md#klipper-gcode_macro)에서 호출할 수 있습니다.

원점복귀 중 드라이버 전류가 변경되면 튜닝 프로세스를 다시 실행해야 합니다.

### CoreXY에서 센서리스 원점복귀를 위한 팁

CoreXY 프린터의 X 및 Y 캐리지에서 센서리스 원점복귀를 사용할 수 있습니다. Klipper는 `[stepper_x]` 스테퍼를 사용하여 X 캐리지를 원점복귀할 때 stall을 감지하고 `[stepper_y]` 스테퍼를 사용하여 Y 캐리지를 원점복귀할 때 stall을 감지합니다.

위에서 설명한 조정 가이드를 사용하여 각 캐리지에 적절한 "stall 민감도"를 찾으십시오. 단, 다음 제한 사항에 유의하십시오:

1. When using sensorless homing on CoreXY, make sure there is no `hold_current` configured for either stepper.
1. 조정하는 동안 각 원점복귀 시도 전에 X 및 Y 캐리지가 레일 중앙 근처에 있는지 확인하십시오.
1. 조정이 완료된 후 X와 Y를 모두 원점복귀시킬 때 매크로를 사용하여 한 축이 먼저 원점복귀되도록 한 다음 해당 캐리지를 축 제한에서 멀리 이동하고 최소 2초 동안 일시 중지한 다음 다른 캐리지의 원점복귀를 시작합니다. 축에서 멀어지면 다른 축이 축 제한에 대해 눌러지는 동안 한 축의 원점복귀를 방지합니다 (스톨 감지가 왜곡될 수 있음). 다시 원점복귀하기 전에 드라이버의 stall flag가 지워지도록 하려면 일시 중지가 필요합니다.

## 드라이버 설정 쿼리 및 진단

\`[DUMP_TMC 명령](G-Codes.md#tmc-stepper-drivers)은 드라이버를 구성하고 진단할 때 유용한 도구입니다. Klipper가 구성한 모든 필드와 드라이버에서 쿼리할 수 있는 모든 필드를 보고합니다.

보고된 모든 필드는 각 드라이버에 대한 Trinamic 데이터시트에 정의되어 있습니다. 이 데이터시트는 [Trinamic 웹사이트](https://www.trinamic.com/)에서 찾을 수 있습니다. 드라이버가 DUMP_TMC의 결과를 해석할 수 있도록 Trinamic 데이터시트를 구하고 검토하십시오.

## driver_XXX 설정 구성

Klipper는 `driver_XXX` 설정을 사용하여 많은 하위 수준 드라이버 필드 구성을 지원합니다. [TMC 드라이버 구성 참조](Config_Reference.md#tmc-stepper-driver-configuration)에는 각 드라이버 유형에 사용할 수 있는 전체 필드 목록이 있습니다.

또한 [SET_TMC_FIELD 명령](G-Codes.md#tmc-stepper-drivers)을 사용하여 런타임 시 거의 모든 필드를 수정할 수 있습니다.

이러한 각 필드는 각 드라이버에 대한 Trinamic 데이터시트에 정의되어 있습니다. 이 데이터시트는 [Trinamic 웹사이트](https://www.trinamic.com/)에서 찾을 수 있습니다.

Trinamic 데이터시트는 때때로 높은 수준의 설정(예: "hysteresis end")과 낮은 수준의 필드 값(예: "HEND")을 혼동할 수 있는 문구를 사용합니다. Klipper에서 `driver_XXX`와 SET_TMC_FIELD는 항상 실제로 드라이버에 기록되는 하위 수준 필드 값을 설정합니다. 따라서 예를 들어 Trinamic 데이터시트에 "hysteresis end" 0을 얻기 위해 값 3을 HEND 필드에 기록해야 한다고 명시되어 있으면 `driver_HEND=3`을 설정하여 상위 수준 값 0을 얻습니다.

## 일반적인 질문

### Can I use stealthChop mode on an extruder with pressure advance?

Many people successfully use "stealthChop" mode with Klipper's pressure advance. Klipper implements [smooth pressure advance](Kinematics.md#pressure-advance) which does not introduce any instantaneous velocity changes.

However, "stealthChop" mode may produce lower motor torque and/or produce higher motor heat. It may or may not be an adequate mode for your particular printer.

### "Unable to read tmc uart 'stepper_x' register IFCNT" 오류가 계속 발생합니까?

이것은 Klipper가 tmc2208 또는 tmc2209 드라이버와 통신할 수 없을 때 발생합니다.

스테퍼 모터 드라이버는 일반적으로 마이크로 컨트롤러와 통신하기 전에 모터 전원이 필요하므로 모터 전원이 활성화되어 있는지 확인하십시오.

이 오류가 Klipper를 처음 깜박인 후 발생하면 스테퍼 드라이버가 이전에 Klipper와 호환되지 않는 상태로 프로그래밍되었을 수 있습니다. 상태를 재설정하려면 몇 초 동안 프린터에서 모든 전원을 제거하십시오(USB와 전원 플러그를 모두 물리적으로 분리).

그렇지 않으면 이 오류는 일반적으로 잘못된 UART 핀 배선 또는 UART 핀 설정의 잘못된 Klipper 구성의 결과입니다.

### "Unable to write tmc spi 'stepper_x' register ..." 오류가 계속 발생합니까?

이것은 Klipper가 tmc2130 또는 tmc5160 드라이버와 통신할 수 없을 때 발생합니다.

스테퍼 모터 드라이버는 일반적으로 마이크로 컨트롤러와 통신하기 전에 모터 전원이 필요하므로 모터 전원이 활성화되어 있는지 확인하십시오.

그렇지 않으면 이 오류는 일반적으로 잘못된 SPI 배선, SPI 설정의 잘못된 Klipper 구성 또는 SPI 버스의 장치 구성이 불완전한 결과입니다.

드라이버가 여러 장치가 있는 공유 SPI 버스에 있는 경우 Klipper에서 해당 공유 SPI 버스의 모든 장치를 완전히 구성해야 합니다. 공유 SPI 버스의 장치가 구성되지 않은 경우 의도하지 않은 명령에 잘못 응답하고 의도한 장치에 대한 통신이 손상될 수 있습니다. Klipper에서 구성할 수 없는 공유 SPI 버스에 장치가 있는 경우 [static_digital_output config 섹션](Config_Reference.md#static_digital_output)을 사용하여 사용하지 않는 장치의 CS 핀을 높음으로 설정합니다. SPI 버스를 사용하기 위해 보드의 회로도는 SPI 버스 및 관련 핀에 있는 장치를 찾는 데 유용한 참조가 되는 경우가 많습니다.

### "TMC 보고서 오류: ..." 오류가 발생한 이유는 무엇입니까?

이 유형의 오류는 TMC 드라이버가 문제를 감지하고 자체적으로 비활성화 되었음을 나타냅니다. 즉, 드라이버가 위치 유지를 중지하고 이동 명령을 무시했습니다. Klipper는 활성 드라이버가 자체적으로 비활성화되었음을 감지하면 프린터를 "shutdown" 상태로 전환합니다.

드라이버와의 통신을 방해하는 SPI 오류로 인해 **TMC가 오류 보고** 종료가 발생할 수도 있습니다(tmc2130, tmc5160 또는 tmc2660에서). 이 경우 보고된 드라이버 상태가 `00000000` 또는 `ffffffff`로 표시되는 것이 일반적입니다. 예: `TMC 보고 오류: DRV_STATUS: ffffffff ...' 또는 `TMC 보고 오류: READRSP@RDSEL2: 00000000 ... `. 이러한 오류는 SPI 배선 문제로 인한 것일 수도 있고 자체 재설정 또는 TMC 드라이버의 오류로 인한 것일 수도 있습니다.

몇 가지 일반적인 오류 및 진단 팁:

#### TMC reports error: `... ot=1(OvertempError!)`

This indicates the motor driver disabled itself because it became too hot. Typical solutions are to decrease the stepper motor current, increase cooling on the stepper motor driver, and/or increase cooling on the stepper motor.

#### TMC reports error: `... ShortToGND` OR `LowSideShort`

This indicates the driver has disabled itself because it detected very high current passing through the driver. This may indicate a loose or shorted wire to the stepper motor or within the stepper motor itself.

This error may also occur if using stealthChop mode and the TMC driver is not able to accurately predict the mechanical load of the motor. (If the driver makes a poor prediction then it may send too much current through the motor and trigger its own over-current detection.) To test this, disable stealthChop mode and check if the errors continue to occur.

#### TMC reports error: `... reset=1(Reset)` OR `CS_ACTUAL=0(Reset?)` OR `SE=0(Reset?)`

This indicates that the driver has reset itself mid-print. This may be due to voltage or wiring issues.

#### TMC reports error: `... uv_cp=1(Undervoltage!)`

This indicates the driver has detected a low-voltage event and has disabled itself. This may be due to wiring or power supply issues.

### How do I tune spreadCycle/coolStep/etc. mode on my drivers?

[Trinamic 웹사이트](https://www.trinamic.com/)에는 드라이버 구성에 대한 가이드가 있습니다. 이 가이드는 종종 기술적이고 낮은 수준이며 특수 하드웨어가 필요할 수 있습니다. 그럼에도 불구하고 그들은 최고의 정보 소스입니다.
