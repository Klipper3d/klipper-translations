# 구성 확인

이 문서는 Klipper printer.cfg 파일에서 핀 설정을 확인하는 데 도움이 되는 단계 목록을 제공합니다. [installation document](Installation.md)의 단계를 수행한 후 이 단계를 실행하는 것이 좋습니다.

이 가이드를 진행하는 동안 Klipper 구성 파일을 변경해야 할 수도 있습니다. 구성 파일을 변경할 때마다 RESTART 명령을 실행하여 변경 사항이 적용되도록 하십시오(Octoprint 터미널 탭에 "restart"를 입력한 다음 "보내기"를 클릭하십시오). 구성 파일이 성공적으로 로드되었는지 확인하기 위해 모든 RESTART 후에 STATUS 명령을 실행하는 것도 좋은 방법입니다.

## 온도 확인

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## M112 확인

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## 히터 확인

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

프린터에 히팅 베드가 있는 경우 베드를 사용하여 위의 테스트를 다시 수행하십시오.

## 스테퍼 모터 enable pin 확인

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## endstops 확인

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

endstop이 전혀 변경되지 않으면 일반적으로 endstop이 다른 핀에 연결되었음을 나타냅니다. 핀의 풀업 설정을 변경해야 할 수도 있습니다. (endstop_pin 이름 시작 부분의 '^' - 대부분의 프린터는 풀업 저항을 사용하며 '^'이 있어야 함).

## 스테퍼 모터 확인

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

스테퍼 모터가 전혀 움직이지 않으면 "enable_pin" 및 "step_pin" 설정을 확인하십시오. 스테퍼 모터가 움직이지만 원래 위치로 돌아가지 않으면 "dir_pin" 설정을 확인하십시오. 스테퍼 모터가 잘못된 방향으로 진동하는 경우 일반적으로 축의 "dir_pin"을 반전해야 함을 나타냅니다. 이것은 프린터 구성 파일의 "dir_pin"에'!'를 추가하면 됩니다. (또는 이미 있는 경우 제거). 모터가 1밀리미터보다 훨씬 많거나 훨씬 적게 움직이는 경우 "rotation_distance" 설정을 확인하십시오.

구성 파일에 정의된 각 스테퍼 모터에 대해 위의 테스트를 실행합니다. (STEPPER_BUZZ 명령의 STEPPER 매개변수를 테스트할 구성 섹션의 이름으로 설정합니다.) 압출기에 필라멘트가 없으면 STEPPER_BUZZ를 사용하여 압출기 모터 연결을 확인할 수 있습니다(STEPPER=extruder 사용). 아니면, 압출기 모터를 별도로 테스트하는 것이 가장 좋습니다.(다음 섹션 참조).

모든 endstop을 확인하고 모든 스테퍼 모터를 확인한 후 원점 복귀 메커니즘을 테스트해야 합니다. 모든 축을 홈으로 이동하려면 G28 명령을 실행하십시오. 홈으로 가지 않으면 프린터에서 전원을 제거하십시오. endstop 및 스테퍼 모터 확인 단계를 다시 실행합니다.

## 압출기 모터 확인

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## PID 설정 보정

클리퍼는 압출기 및 베드 히터에 대해 [PID 제어](https://en.wikipedia.org/wiki/PID_controller)를 지원합니다. 이 제어 메커니즘을 사용하려면 각 프린터의 PID 설정을 보정해야 합니다(다른 펌웨어 또는 예제 구성 파일에서 찾은 PID 설정은 종종 제대로 작동하지 않음).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

조정 테스트가 완료되면 `SAVE_CONFIG`를 실행하여 printer.cfg 파일을 업데이트하여 새 PID 설정을 업데이트합니다.

프린터에 히팅베드가 있고 PWM(Pulse Width Modulation) 구동을 지원하는 경우 베드에 PID 제어를 사용하는 것이 좋습니다. (베드 히터가 PID 알고리즘을 사용하여 제어될 경우 1초에 10번씩 켜지고 꺼질 수 있으므로 기계식 스위치를 사용하는 히터에는 적합하지 않을 수 있습니다.) 일반적인 베드 PID 교정 명령은 다음과 같습니다: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## 다음 단계

이 가이드는 Klipper 구성 파일의 핀 설정에 대한 기본적인 확인을 돕기 위한 것입니다. [bed leveling](Bed_Level.md) 가이드를 반드시 읽어주세요. 또한 Klipper로 슬라이서를 구성하는 방법에 대한 정보는 [Slicers](Slicers.md) 문서를 참조하십시오.

기본 인쇄가 작동하는지 확인한 후 [pressure advance](Pressure_Advance.md)보정을 고려하는 것이 좋습니다.

다른 유형의 자세한 프린터 보정을 수행해야 할 수도 있습니다. 이를 돕기 위해 온라인에서 여러 가이드를 사용할 수 있습니다(예: "3d 프린터 보정"에 대한 웹 검색 수행). 예를 들어 링잉(ringing)이라는 효과가 발생한다면 [resonance compensation](Resonance_Compensation.md) 튜닝 가이드를 따라 해보시면 됩니다.
