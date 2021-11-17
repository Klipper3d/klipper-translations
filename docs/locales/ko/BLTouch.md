# BL-Touch

## BL-Touch 연결

시작전 **주의** : BL-touch 핀을 맨손가락으로 만지지 않도록 하라. 왜냐하면 손가락 구리스(?)가 매우 예민하기 때문이다. 만일 만지게 된다면 핀이 구부러지거나 어떤것도 밀지 않도록 하기 위해 조심스럽게 다뤄라.

BL-touch 서보 연결선을 bltouch 문서와 MCU 문서에 있는 `control_pin`에 곱아라. 기본선을 사용한다면 세가닥 나와 있는 것중 노란색 선은 `control_pin` 이다. 두가닥 나와 있는 것중 흰색선은 `sensor_pin` 이다. 너의 배선연결에 따라 이 핀들을 설정할 필요가 있다. 대부분의 bltouch 장치들은 센서 핀(핀 이름앞에 "^"를 가진)상에 풀업이 필요하다. 예를 들면:

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

If the BL-Touch will be used to home the Z axis then set `endstop_pin: probe:z_virtual_endstop` and remove `position_endstop` in the `[stepper_z]` config section, then add a `[safe_z_home]` config section to raise the z axis, home the xy axes, move to the center of the bed, and home the z axis. For example:

```
[safe_z_home]
home_xy_position: 100,100 # Change coordinates to the center of your print bed
speed: 50
z_hop: 10                 # Move up 10mm
z_hop_speed: 5
```

safe_z_home 으로 z_hop 이동은 프로브 핀이 가장 낮은 위치에 있는 상태에서도 다른 어떤것에도 부딪히지 않을 정도로 충분히 높이 올려서 이동하도록 하는게 중요하다.

## 초기 테스트

동작하기 앞서 bltouch 가 정확한 높이로 설치되어 있는지를 확실히 하라, 핀이 들어간 상태에서 노즐위로 대략 2mm 는 올라와 있어야 한다

프린터를 켰을때, bltouch 프로브는 몇차례 핀이 내려왔다 올라갔다하면서 자체테스트를 진행한다. 자체 테스트를 마치면, 핀은 들어가고 빨간색 LED가 켜진다. 만약 테스트상에 에러가 발생하면, 예를 들어 핀이 나와야 하는데 들어간다거나 빨간색 불빛이 번쩍인다거나 하면, 프린터를 끄고 배선연결과 설정이 제대로 되어 있는지 체크하기 바란다.

만약 지금까지 잘 진행이 되었다면, 핀이 정확히 동작하는지 테스트할 차례이다. 먼저, 터미널에서 `BLTOUCH_DEBUG COMMAND=pin_down`를 실행시켜라. 그랬을때 프로브 핀이 아래로 내려가고 빨간색 불이 꺼지는지 확인하라. 만약 그렇게 되지 않는다면 배선연결과 설정을 다시 체크하기 바란다. 다음은 `BLTOUCH_DEBUG COMMAND=pin_up` 를 실행시켜 프로브 핀이 위로 동작하고 빨간색 led 가 다시 켜지는 것을 확인하라. 만일 불빛이 점멸한다면 동일한 문제가 있다는 뜻이다.

다음 단계는 센서 핀이 정확히 동작하는지 확인할 차례다. `BLTOUCH_DEBUG COMMAND=pin_down`를 실행하여 핀이 아래로 내려갔는지 보고, `BLTOUCH_DEBUG COMMAND=touch_mode` 과 `QUERY_PROBE`를 실행하여 해당 명령이 "probe: open" 를 보이는지 확인하라. 그리고 손톱을 이용해 조심스럽게 핀을 천천히 밀어올리고 `QUERY_PROBE` 명령을 다시 실행해보라. 그때 "probe: TRIGGERED"가 보이는지 확인하라. 만일 둘다 제대로된 정확한 메시지가 보이지 않는다면 배선연결과 설정을 다시 체크하기 바란다. 테스트가 끝나면 `BLTOUCH_DEBUG COMMAND=pin_up` 라고 입력하고 핀이 올라가는것을 확인하기 바란다.

bltouch 컨트롤 핀과 센서핀 테스트를 마치고 나서, 측정 테스트를 할 차례가 된다. 하지만, 조금 다르게 할 것이다. 프로브 핀을 프린터 베드에 닿게 하는 것대신에, 손톱으로 터치할 것이다. 툴 헤드가 베드로부터 많이 떨어져 있도록 위치시켜놓고, `G28`(또는 만약 probe:z_virtual_endstop 을 사용하지 않는다면 `PROBE`)를 입력하라. 그리고 툴헤드가 아래로 내려오기 시작할 때까지 기다려라. 내려오기 시작하면 손톱으로 아주 천천히 핀을 건드려서 내려오는 움직임을 멈추도록 하라. 이것을 두번정도 해야할 것이다. 왜냐하면 기본 호밍 설정에서 두번 측정하도록 되어 있기 때문이다. 만약 핀을 건드리는데도 멈추지 않을때를 대비하여 프린터의 전원을 끌 준비를 하고 진행하도록 한다.

성공했다면, 다시 `G28` (또는 `PROBE`) 를 실행시켜라. 하지만 이번에는 손톱대신 원래 해야했던 베드를 터치하도록 하면 된다.

## bltouch 불량

bltouch 가 정상이 아닌 상태라면, 빨간색 불빛을 점멸할 것이다. 그럴 경우 아래 명령을 내려 강제적으로 그 상태를 벗어나게 할 수 있다. :

BLTOUCH_DEBUG COMMAND=reset

이것은 프로브가 나오는게 막혀서 캘리브레이션이 방해를 받게 되었을때 발생할 수 있다.

하지만, Bltouch가 더이상 자체 캘리브레이션을 할 수 없을때도 있다. 이건 상단 스크류의 위치가 잘못되어 있거나, 프로브핀 안쪽의 자석코어가 움직였을때 발생한다. 만일 위로 움직일때 스크류에 붙어버렸다면, 그 핀을 더이상 내릴 수 없을 때가 있다. 이럴 때는 스크류를 열어 볼펜을 이용해 제 위치로 조심스럽게 밀어내도록 하라. 핀이 뽑힌 위치에 떨어지도록 bltouch 안으로 핀을 다시 집어넣어라. 조심스럽게 무드볼트를 안으로 밀어넣도록 하라. 핀을 아래로 내리고 위로 올려서 빨간색 불빛이 켜지고 꺼지는 것을 통해 정확한 위치를 찾아야 한다. 이 작업을 할 때 `reset`, `pin_up` 그리고 `pin_down` 명령을 사용하라.

## BL-Touch 짝퉁

수많은 bltouch 짝퉁들이 기본 설정을 이용해 클리퍼상에서 정상적으로 작동한다. 하지만, 몇몇 짝둥제품은 `pin_up_reports_not_triggered` 혹은 `pin_up_touch_mode_reports_triggered`를 설정해야할 수도 있다.

중요! 먼저 다음 지시를 따르지 않고 `pin_up_reports_not_triggered` 나 `pin_up_touch_mode_reports_triggered` 을 False 로 설정하지 마십시오. 정품 bltouch에 이값들을 False 로 설정해서도 안됩니다. 잘못 False 로 셋팅하면 측정 시간을 증가시키고, 프린터를 손상시킬 위험이 증가할 수 있습니다.

몇몇 짝퉁 제품은 클리퍼의 내부적인 센서인증테스트를 진행할 수 없습니다. 이 제품들로 호밍이나 프로빙을 시도하면 클리퍼에서 "BLTouch failed to verify sensor state" 결과를 내보내게 됩니다. 만일 이런게 발생하면, [initial tests section](#initial-tests) 에 기록된 내용을 따라 수동으로 센서핀이 제대로 잘 잘동하는지를 단계별로 진행해야 한다. 만약, 그 테스트 중에 `QUERY_PROBE` 명령은 기대했던 동작하고, "BLTouch failed to verify sensor state" 에러는 계속 보인다면, 클리퍼 설정파일에서 `pin_up_touch_mode_reports_triggered` 값을 False 로 셋팅해야 할 수도 있다.

드물지만 오래된 짝퉁 제품들중에 성공적으로 프로브를 올려도 제대로 보고가 안되는게 있다. 이 제품들은 호밍이나 프로밍 시도후에 "BLTouch failed to raise probe" 에러를 보일것이다. 그렇다면 이런 제품들에 대해 베드를 헤드와 멀찍이 떨어뜨린 상태에서 `BLTOUCH_DEBUG COMMAND=pin_down` 를 실행시켜 핀이 아래로 내려가는 것을 확인하고, `QUERY_PROBE`를 실행하여 "probe: open" 상태임을 확인하고, `BLTOUCH_DEBUG COMMAND=pin_up`를 실행시켜 핀이 위로 올라가는 것을 확인하라. 그리고 마지막으로 `QUERY_PROBE`를 실행시켜라. 만약 핀이 위에 머물러 있다면, 이 제품은 에러상태에 들어가지 않는다. 그리고 첫 쿼리가 "probe: open"을 내고 두번째 쿼리가 "probe: TRIGGERED"를 내었다면 클리퍼 설정파일에서 `pin_up_reports_not_triggered`을 False 로 셋팅해야 함을 의미한다.

## BL-Touch v3

몇몇 Bltouch v3.0 과 v3.1 제품들은 프린터 설정파일에서 `probe_with_touch_mode` 설정이 필요할 수도 있다.

만약 Bltouch 3.0 에서 신호선을 엔드스탑핀(노이즈 필터링 캐패시턴트가 연결된)에 연결했다면 호밍과 프로빙시에 지속적으로 신호를 보낼 수 없을 수도 있다. 만일 [initial tests section](#initial-tests) 에서 `QUERY_PROBE` 명령이 기대한 결과를 내면서도 툴헤드가 G28/PROBE 명령동안 매번 멈추지 않는다면 이 문제의 원인일 수 있다. 이를 피하는 방법으론 설정파일에서 `probe_with_touch_mode: True` 로 셋팅하는 것이다.

Bltouch v3.1 은 성공적인 프로브 시도후에 부정확하게 에러상태에 빠질 수 있다. 증상으로는 프로브가 베드에 성공적으로 닿고 나서 몇초동안 간헐적으로 불빛이 깜빡인다. 클리퍼는 자동으로 이 에러를 해결하고, 일반적으로는 큰 해가없다. 하지만, 이 이슈를 피하기 위해 설정파일에서 `probe_with_touch_mode`를 셋팅해주는게 좋을 것이다.

중요! 몇몇 짝퉁 제품과 Bltouch v2.0(혹은 이전버전)은 `probe_with_touch_mode` 을 True 로 셋팅해두었을때 정확도가 감소할 수도 있다. 또한 이 값을 True 로 하는 것은 프로브 밀어내는 시간을 증가시킬 수도 있다. 만약 이 짝퉁이나 이전 bltouch 제품에서 이 값을 설정한다면 이 값을 셋팅하기 전과 후에 정확도 테스트를 반드시 해보기 바란다. (테스트는 `PROBE_ACCURACY` 명령을 사용하라).

## 핀을 넣지 않고 다중측정하기

기본적으로 클리퍼는 각 측정지점에서 측정을 시작할 때 프로브를 밀어내고 당기고 한다. 이 반복된 밀어내고 당기고의 과정은 많은 측정포인트를 지닌 캘리브레이션 시퀀스에서 전체 시간을 증가시키게 된다. 클리퍼는 연속된 측정포인트 사이의 이동시 프로브가 나온 상태에서 이동하게 할 수 있다. 이것은 전체 측정 시간을 줄일 수 있는 방법이다. 이 모드는 설정파일에서 `stow_on_each_sample` 값을 False 로 설정하면 사용가능하다.

중요! `stow_on_each_sample` 를 False 로 설정은 프로브가 나온 상태에서 툴이 수평이동하게 만들 수 있다. 따라서 이값을 False 로 셋팅하기 앞서 모든 프로빙 과정에서 충분한 Z 간격을 확보하는지 반드시 확인하기 바란다. 만일 Z 간격이 충분치 않다면 수평이동시 핀이 장애물을 만나 부러지거나 잘못된 측정에 의해 프린터에 손상을 가져올 수도 있으니 주의하자.

중요! `stow_on_each_sample` 를 False 로 설정하면 `probe_with_touch_mode`는 True 로 해둘것을 추천한다. 몇몇 짝퉁 제품은 `probe_with_touch_mode` 이 셋팅되어 있지 않으면 연속된 베드 컨택을 감지하지 못할 수도 있다. 모든 제품에서 이 두 셋팅을 조합해 사용하면 제품의 신호를 단순화하여 전체적인 안정성을 높일 수 있을 것이다.

하지만, 일부 짝퉁 제품과 BLtouch v2.0 이하의 제품은 `probe_with_touch_mode` 를 True 로 셋팅했을때 정확도가 떨어질 수도 있다. 이 제품들을 사용한다면 `probe_with_touch_mode` 을 셋팅하기 전과 후에 정확도 테스트를 해보는 것은 좋겠다. (테스트는 `PROBE_ACCURACY` 명령을 사용하라).

## Bltouch 오프셋 캘리브레이션

x_offset, y_offset, 그리고 z_offset 설정 파라메터들을 셋팅하기 위해 [Probe Calibrate](Probe_Calibrate.md)의 지시사항을 따르도록 하라.

Z offset 은 1mm 가깝게 하는 것이 좋다. 만약 그 값이 아니라면 1mm 가 되도록 조정을 위해 프로브를 위나 아래로 이동시키면 된다. 이렇게 하면 노즐이 베드를 찍기 전에 작동하면서도 간혹 있을 수 있는 노즐에 붙은 필라멘트나 휘어진 베드가 측정에는 영향을 미치지 않을 것이다. 그러나 동시에 프로브가 당겨진 위치에서 가능하면 노즐 위쪽에 있어 프린트된 파츠를 건드리지 않도록 하고 싶을 것이다. 만약 프로브 장착 위치가 바뀐다면 프로브 캘리브레이션 과정은 다시 진행되어야 한다.

## BL-Touch 아웃풋 모드


   * Bltouch V3.0 은 5V 나 OPEN-DRAIN 아웃풋 모드 셋팅을 지원한다. Bltouch V3.1 은 이 두가지를 지원한다. 그러나 또한 내부 EEPROM 내에 이것을 저장할수도 있다. 만일 컨트롤러 보드가 5V 모드의 고정된 5V 하이로직 레벨이 필요하다면, 프린터 설정파일의 [bltouch]섹션에 있는 'set_output_mode' 파라메터의 값을 "5V" 로 셋팅하면 된다.*** 오직 컨트롤러 보드의 입력 라인이 5V tolerant 일때 5V 모드를 사용하라. 이는 Bltouch 버전의 기본 설정이 OPEN-DRAIN 모드이기 때문이다. 잠재적으로 당신의 큰트롤러 보드 CPU를 손상시킬지도 모른다. ***

   그런고로 : 만약 컨트롤러 보드가 5V 모드를 필요로 하고 입력 신호선이 5V tolerant 이라면, 그리고 또 만약

   - Bltouch Smart V3.0 을 쓴다면, 'set_output_mode: 5V' 파라메터를 매번 시작할 때 셋팅해줄 필요가 있다. 왜냐하면 프로브는 셋팅을 기억할 수 없기 때문이다.
   - Bltouch Smart V3.1 을 쓴다면, 선택지가 있다. 'set_output_mode: 5V' 를 쓰거나 수동으로 한번 'BLTOUCH_STORE MODE=5V' 명령을 사용하고 그 모드를 저장하는 것이다. 이때는 'set_output_mode:' 를 사용하지 않는다.
   - 그밖의 다른 프로브를 쓴다면 : 일부 프로브는 회로보드에 끊을 수 있는 선이 있거나 점퍼를 가지고 있다. 이것을 통해 영구적으로 출력모드를 셋팅할 수 있다. 그 경우에는 'set_output_mode' 파라메터를 완전히 제거하도록 하라.
만일 V3.1을 사용한다면 EEPROM 이 마모되지 않도록 하기 위해 출력모드 저장을 자동화 하거나 반복하지 않도록 하라. Bltouch EEPROM 은 약 100,000번 업데이트까지 가능하다. 하루에 100번 저장을 한다면 마모되기 전까지 약 3년을 쓸 수 있다. 따라서 V3.1의 출력모드 저장기능은 복잡한 작업을 하는 사람을 위해 디자인 된 것이다. (공장초기값은 안전한 OPEN DRAIN 모드이다) 그리고, 반복적으로 슬라이서나 매크로등에 의해 사용되는 용도로는 적합지 않다. 그것은 프로브를 프린터 전장부에 처음으로 적용하여 사용할 때 사용할것을 권한다.
