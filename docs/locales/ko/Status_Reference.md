# Status reference

이 문서는 Klipper [매크로](Command_Templates.md), [디스플레이 필드](Config_Reference.md#display) 및 [API 서버](API_Server.md)를 통해 사용할 수 있는 프린터 상태 정보에 대한 참조입니다.

이 문서의 필드는 변경될 수 있습니다. 속성을 사용하는 경우 Klipper 소프트웨어를 업그레이드할 때 [구성 변경 문서](Config_Changes.md)를 검토해야 합니다.

## bed_mesh

[bed_mesh](Config_Reference.md#bed_mesh) 개체에서 다음 정보를 사용할 수 있습니다:

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`: 현재 활성화된 bed_mesh에 대한 정보입니다.

## configfile

`configfile` 객체에서 다음 정보를 사용할 수 있습니다(이 객체는 항상 사용할 수 있음):

- `settings.<section>.<option>`: 마지막 소프트웨어 시작 또는 다시 시작 중에 지정된 구성 파일 설정(또는 기본값)을 반환합니다. (런타임에 변경된 설정은 여기에 반영되지 않습니다.)
- `config.<section>.<option>`: 마지막 소프트웨어 시작 또는 다시 시작 중에 Klipper가 읽은 대로 주어진 원시 구성 파일 설정을 반환합니다. (런타임에 변경된 설정은 여기에 반영되지 않습니다.) 모든 값은 문자열로 반환됩니다.

## display_status

다음 정보는 `display_status` 개체에서 사용할 수 있습니다 (이 개체는 [display](Config_Reference.md#display) 구성 섹션이 정의된 경우 자동으로 사용할 수 있음):

- `progress`: 마지막 `M73` G-Code 명령의 진행 값 (또는 최근 'M73'이 수신되지 않은 경우 `virtual_sdcard.progress` ).
- `message`: 마지막 `M117` G-Code 명령에 포함된 메시지입니다.

## endstop_phase

[endstop_phase](Config_Reference.md#endstop_phase) 개체에서 다음 정보를 사용할 수 있습니다:

- `last_home.<stepper name>.phase`: 마지막 홈 시도 종료 시 스테퍼 모터의 위상입니다.
- `last_home.<stepper name>.phases`: 스테퍼 모터에서 사용할 수 있는 총 위상 수입니다.
- `last_home.<stepper name>.mcu_position`: 마지막 홈 시도가 끝날 때 스테퍼 모터의 위치(마이크로 컨트롤러에 의해 추적됨)입니다. 위치는 마이크로 컨트롤러가 마지막으로 다시 시작된 이후 순방향으로 취한 총 단계 수에서 역방향으로 취한 총 단계 수를 뺀 것입니다.

## fan

다음 정보는 [fan](Config_Reference.md#fan), [heater_fan some_name](Config_Reference.md#heater_fan) 및 [controller_fan some_name](Config_Reference.md#controller_fan) 개체에서 사용할 수 있습니다:

- `speed`: 0.0에서 1.0 사이의 부동 소수점으로 팬 속도입니다.
- `rpm`: 팬에 tachometer_pin이 정의되어 있는 경우 측정된 팬 속도(분당 회전수).

## filament_switch_sensor

다음 정보는 [filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor) 개체에서 사용할 수 있습니다:

- `enabled`: 스위치 센서가 현재 활성화되어 있으면 True를 반환합니다.
- `filament_detected`: 센서가 트리거된 상태에 있으면 True를 반환합니다.

## filament_motion_sensor

다음 정보는 [filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor) 개체에서 사용할 수 있습니다:

- `enabled`: 모션 센서가 현재 활성화되어 있으면 True를 반환합니다.
- `filament_detected`: 센서가 트리거된 상태에 있으면 True를 반환합니다.

## firmware_retraction

[firmware_retraction](Config_Reference.md#firmware_retraction) 개체에서 다음 정보를 사용할 수 있습니다:

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`: Firmware_retraction 모듈의 현재 설정입니다. 이 설정은 `SET_RETRACTION` 명령이 변경하는 경우 구성 파일과 다를 수 있습니다.

## gcode_macro

다음 정보는 [gcode_macro some_name](Config_Reference.md#gcode_macro) 개체에서 사용할 수 있습니다:

- `<variable>`: [gcode_macro 변수](Command_Templates.md#variables)의 현재 값입니다.

## gcode_move

`gcode_move` 개체에서 다음 정보를 사용할 수 있습니다(이 개체는 항상 사용 가능):

- `gcode_position`: 현재 G-Code 원점을 기준으로 한 툴헤드의 현재 위치입니다. 즉, `G1` 명령에 직접 보낼 수 있는 위치입니다. 이 위치의 x, y, z, e 구성요소에 액세스하는 것이 가능합니다 (예: `gcode_position.x`).
- `position`: 구성 파일에 지정된 좌표계를 사용하여 도구 헤드의 마지막으로 명령된 위치입니다. 이 위치의 x, y, z 및 e 구성요소에 액세스하는 것이 가능합니다(예: `position.x`).
- `homing_origin`: `G28` 명령 이후에 사용할 gcode 좌표계(구성 파일에 지정된 좌표계에 상대적)의 원점입니다. `SET_GCODE_OFFSET` 명령은 이 위치를 변경할 수 있습니다. 이 위치의 x, y 및 z 구성요소(예: `homing_origin.x`)에 액세스할 수 있습니다.
- `speed`: `G1` 명령에서 마지막으로 설정한 속도(mm/s)입니다.
- `speed_factor`: `M220` 명령으로 설정한 "speed factor override"입니다. 1.0은 재정의가 없음을 의미하고 예를 들어 2.0은 요청된 속도의 두 배인 부동 소수점 값입니다.
- `extrude_factor`: `M221` 명령으로 설정한 "extrude factor override"입니다. 1.0은 재정의가 없음을 의미하고 예를 들어 2.0은 요청된 돌출을 두 배로 만드는 부동 소수점 값입니다.
- `absolute_coordinates`: 이것은 `G90` 절대 좌표 모드에 있으면 True를 반환하고 `G91` 상대 모드에 있으면 False를 반환합니다.
- `absolute_extrude`: 이것은 `M82` 절대 돌출 모드인 경우 True를 반환하고 `M83` 상대 모드인 경우 False를 반환합니다.

## hall_filament_width_sensor

[hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor) 개체에서 다음 정보를 사용할 수 있습니다:

- `is_active`: 센서가 현재 활성 상태이면 True를 반환합니다.
- `Diameter`, `Raw`: 센서에서 마지막으로 읽은 값입니다.

## heater

[extruder](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed) 및 [heater_generic](Config_Reference.md#heater_generic)과 같은 히터 개체에 대해 다음 정보를 사용할 수 있습니다:

- `temperature`: 지정된 히터에 대해 마지막으로 보고된 온도(섭씨 부동 소수점)입니다.
- `target`: 지정된 히터에 대한 현재 목표 온도 (섭씨 부동 소수점)입니다.
- `power`: 히터와 관련된 PWM 핀의 마지막 설정 (0.0에서 1.0 사이의 값).
- `can_extrude`: Extruder가 압출할 수 있는 경우 (`min_extrude_temp`로 정의), [extruder](Config_Reference.md#extruder)에만 사용 가능

## heaters

`heaters` 개체에서 다음 정보를 사용할 수 있습니다 (이 개체는 히터가 정의된 경우 사용할 수 있음):

- `available_heaters`: 전체 구성 섹션 이름별로 현재 사용 가능한 모든 히터 목록을 반환합니다. 예. `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `available_sensors`: 전체 구성 섹션 이름별로 현재 사용 가능한 모든 온도 센서 목록을 반환합니다. 예. `["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"]`.

## idle_timeout

다음 정보는 [idle_timeout](Config_Reference.md#idle_timeout) 개체에서 사용할 수 있습니다(이 개체는 항상 사용 가능):

- `state`: idle_timeout 모듈에서 추적한 프린터의 현재 상태입니다. "Idle", "Printing", "Ready" 문자열 중 하나입니다.
- `printing_time`: 프린터가 "인쇄 중" 상태에 있었던 시간(초)입니다 (idle_timeout 모듈에 의해 추적됨).

## mcu

다음 정보는 [mcu](Config_Reference.md#mcu) 및 [mcu some_name](Config_Reference.md#mcu-my_extra_mcu) 개체에서 사용할 수 있습니다:

- `mcu_version`: 마이크로 컨트롤러에서 보고한 Klipper 코드 버전입니다.
- `mcu_build_versions`: 마이크로 컨트롤러 코드를 생성하는 데 사용되는 빌드 도구에 대한 정보(마이크로 컨트롤러가 보고한 대로).
- `mcu_constants.<constant_name>`: 마이크로 컨트롤러에서 보고한 컴파일 시간 상수. 사용 가능한 상수는 마이크로 컨트롤러 아키텍처와 각 코드 개정판에 따라 다를 수 있습니다.
- `last_stats.<statistics_name>`: 마이크로 컨트롤러 연결에 대한 통계 정보입니다.

## motion_report

`motion_report` 개체에서 다음 정보를 사용할 수 있습니다 (이 개체는 스테퍼 구성 섹션이 정의된 경우 자동으로 사용할 수 있음):

- `live_position`: 현재 시간으로 보간된 요청된 toolhead 위치입니다.
- `live_velocity`: 현재 시간에 요청된 toolhead 속도(mm/s)입니다.
- `live_extruder_velocity`: 현재 시간에 요청된 압출기 속도(mm/s)입니다.

## output_pin

다음 정보는 [output_pin some_name](Config_Reference.md#output_pin) 개체에서 사용할 수 있습니다:

- `value`: `SET_PIN` 명령에 의해 설정된 핀의 "값".

## palette2

[palette2](Config_Reference.md#palette2) 개체에서 다음 정보를 사용할 수 있습니다:

- `ping`: 마지막으로 보고된 Palette 2 ping의 양(퍼센트)입니다.
- `remaining_load_length`: Palette 2 인쇄를 시작할 때 압출기에 로드할 필라멘트의 양이 됩니다.
- `is_splicing`: Palette 2가 필라멘트를 접합할 때 참입니다.

## pause_resume

[pause_resume](Config_Reference.md#pause_resume) 개체에서 다음 정보를 사용할 수 있습니다:

- `is_paused`: PAUSE 명령이 해당 RESUME 없이 실행된 경우 true를 반환합니다.

## print_stats

다음 정보는 `print_stats` 개체에서 사용할 수 있습니다 (이 개체는 [virtual_sdcard](Config_Reference.md#virtual_sdcard) 구성 섹션이 정의된 경우 자동으로 사용할 수 있음):

- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message`: virtual_sdcard 인쇄가 활성화된 경우 현재 인쇄에 대한 예상 정보입니다.

## probe

다음 정보는 [probe](Config_Reference.md#probe) 개체에서 사용할 수 있습니다(이 개체는 [bltouch](Config_Reference.md#bltouch) 구성 섹션이 정의된 경우에도 사용할 수 있음):

- `last_query`: 마지막 QUERY_PROBE 명령 동안 프로브가 "트리거된" 것으로 보고된 경우 True를 반환합니다. 이것이 매크로에서 사용되는 경우 템플릿 확장 순서로 인해 QUERY_PROBE 명령이 이 참조를 포함하는 매크로보다 먼저 실행되어야 합니다.
- `last_z_result`: 마지막 PROBE 명령의 Z 결과 값을 반환합니다. 이것이 매크로에서 사용되는 경우 템플릿 확장 순서로 인해 PROBE(또는 유사한) 명령이 이 참조를 포함하는 매크로보다 먼저 실행되어야 합니다.

## quad_gantry_level

다음 정보는 `quad_gantry_level` 개체에서 사용할 수 있습니다 (이 개체는 quad_gantry_level이 정의된 경우 사용할 수 있음):

- `applied`: 갠트리 레벨링 프로세스가 실행되고 성공적으로 완료된 경우 True입니다.

## query_endstops

`query_endstops` 개체에서 다음 정보를 사용할 수 있습니다 (이 개체는 endstop이 정의된 경우 사용할 수 있음):

- `last_query["<endstop>"]`: 지정된 엔드스톱이 마지막 QUERY_ENDSTOP 명령 중에 "트리거된" 것으로 보고된 경우 True를 반환합니다. 이것이 매크로에서 사용되는 경우 템플릿 확장 순서로 인해 QUERY_ENDSTOP 명령이 이 참조를 포함하는 매크로보다 먼저 실행되어야 합니다.

## servo

다음 정보는 [servo some_name](Config_Reference.md#servo) 개체에서 사용할 수 있습니다:

- `printer["servo <config_name>"].value`: 서보와 관련된 PWM 핀의 마지막 설정(0.0과 1.0 사이의 값).

## system_stats

다음 정보는 `system_stats` 개체에서 사용할 수 있습니다(이 개체는 항상 사용할 수 있음):

- `sysload`, `cputime`, `memavail`: 호스트 운영 체제 및 프로세스 로드에 대한 정보입니다.

## temperature sensors

다음 정보 사용할 수 있습니다

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor), 그리고 [temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) 객체에서:

- `temperature`: 센서에서 마지막으로 읽은 온도입니다.
- `humidity`, `pressure`, `gas`: 센서에서 마지막으로 읽은 값입니다 (bme280, htu21d 및 lm75 센서에만 해당).

## temperature_fan

다음 정보는 [temperature_fan some_name](Config_Reference.md#temperature_fan) 개체에서 사용할 수 있습니다:

- `temperature`: 센서에서 마지막으로 읽은 온도입니다.
- `temperature`: 센서에서 마지막으로 읽은 온도입니다.

## temperature_sensor

다음 정보는 [temperature_sensor some_name](Config_Reference.md#temperature_sensor) 개체에서 사용할 수 있습니다:

- `temperature`: 센서에서 마지막으로 읽은 온도입니다.
- `measured_min_temp`, `measured_max_temp`: Klipper 호스트 소프트웨어가 마지막으로 다시 시작된 이후 센서에 표시되는 최저 및 최고 온도입니다.

## toolhead

`toolhead` 개체에서 다음 정보를 사용할 수 있습니다(이 개체는 항상 사용 가능):

- `position`: 구성 파일에 지정된 좌표계에 상대적인 toolhead의 마지막 명령 위치입니다. 이 위치의 x, y, z 및 e 구성요소에 액세스하는 것이 가능합니다(예: `position.x`).
- `extruder`: 현재 활성 압출기의 이름입니다. 예를 들어 매크로에서 `printer[printer.toolhead.extruder].target`을 사용하여 현재 압출기의 목표 온도를 얻을 수 있습니다.
- `homed_axes`: "homed" 상태에 있는 것으로 간주되는 현재 직교 축입니다. "x", "y", "z" 중 하나 이상을 포함하는 문자열입니다.
- `axis_minimum`, `axis_maximum`: 원점 복귀 후 축 이동 한계(mm). 이 제한 값의 x, y, z 구성 요소에 액세스할 수 있습니다 (예: `axis_minimum.x`, `axis_maximum.z`).
- `max_velocity`, `max_accel`, `max_accel_to_decel`, `square_corner_velocity`: 유효한 현재 인쇄 제한입니다. 이는 `SET_VELOCITY_LIMIT`(또는 `M204`) 명령이 런타임에 변경하는 경우 구성 파일 설정과 다를 수 있습니다.
- `stalls`: toolhead가 G-Code 입력에서 읽을 수 있는 것보다 빠르게 이동하여 프린터를 일시 중지해야 했던 총 횟수(마지막 다시 시작한 이후).

## dual_carriage

다음 정보는 hybrid_corexy 또는 hybrid_corexz 로봇의 [dual_carriage](Config_Reference.md#dual_carriage)에서 확인할 수 있습니다

- `mode`: 현재 모드. 가능한 값은 "FULL_CONTROL"입니다
- `active_carriage`: 현재 활성 캐리지입니다. 가능한 값은 "CARRIAGE_0", "CARRIAGE_1"입니다

## virtual_sdcard

[virtual_sdcard](Config_Reference.md#virtual_sdcard) 개체에서 다음 정보를 사용할 수 있습니다:

- `is_active`: 파일에서 인쇄가 현재 활성화되어 있으면 True를 반환합니다.
- `progress`: 현재 인쇄 진행률 추정치(파일 크기 및 파일 위치 기반).
- `file_path`: 현재 로드된 파일의 전체 경로입니다.
- `file_path`: 현재 로드된 파일의 전체 경로입니다.
- `file_path`: 현재 로드된 파일의 전체 경로입니다.

## webhooks

`webhooks` 객체에서 다음 정보를 사용할 수 있습니다(이 객체는 항상 사용 가능):

- `state`: 현재 Klipper 상태를 나타내는 문자열을 반환합니다. 가능한 값은 "ready", "startup", "shutdown", "error"입니다.
- `state_message`: 현재 Klipper 상태에 대한 추가 컨텍스트를 제공하는 사람이 읽을 수 있는 문자열입니다.

## z_tilt

다음 정보는 `z_tilt` 개체에서 사용할 수 있습니다(이 개체는 z_tilt가 정의된 경우 사용할 수 있음):

- `applied`: z-tilt 레벨링 프로세스가 성공적으로 실행되고 완료된 경우 True 입니다.

## neopixel / dotstar

다음 정보는 printer.cfg 에 정의된 각 `[neopixel led_name]` 및 `[dotstar led_name]`에 대해 사용할 수 있습니다:

- `color_data`: 체인의 led에 대한 RGBW 값을 포함하는 각 개체가 있는 개체의 배열입니다. 모든 구성에 흰색 값이 포함되는 것은 아닙니다. 각 값은 0에서 1 사이의 부동 소수점으로 표시됩니다. 예를 들어 체인에서 두 번째 네오픽셀의 파란색 값은 `printer["neopixel <config_name>"].colordata[1].B` 에서 액세스할 수 있습니다.
