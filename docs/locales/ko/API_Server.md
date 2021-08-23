# API 서버

이 문서는 클리퍼 API 에 대해 기술하고 있습니다. 이 인터페이스는 외부 어플리케이션을 쿼리할 수 있게 해주고 클리퍼 호스트 소프트웨어를 조정할 수 있게 해줍니다.

## API Socket 활성화

API 서버를 사용하기 위해서, klippy.py 호스트 소프트웨어가 `-a` 파라메터와 함께 시작되어야 합니다. 예를 들어:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

이는 호스트 소프트웨어가 Unix Domain Socket 을 생성하도록 하며 그 이후 클라이언트가 그 Socket의 연결을 오픈하고, 클리퍼에서 명령을 보낼 수 있습니다.

## 요청 포맷

소켓에 보내지고 수신된 메시지들은 JSON 인코딩된 문자열입니다. 이 문자열들은 ASCII 0x03 문자로 종료됩니다:

```
<json_object_1><0x03><json_object_2><0x03>...
```

Klipper 는 `scripts/whconsole.py` 도구를 포함하고 있습니다.이 도구는 상위 메시지 프레이밍을 수행할 수 있습니다. 예를 들어 :

```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

이 도구는 stdin 으로부터 연속된 JSON 명령어들을 읽을 수 있습니다. 또한 그 읽은 명령어들을 Klipper 로 보내고 결과를 보고할 수 있습니다. 그 도구는 각 JSON 명령을 한줄로 인식하며 요청을 보낼때 자동으로 0x03 종료자를 추가할 것입니다. (Klipper API 서버는 newline 요청을 가지고 있지 않습니다.)

## API 프로토콜

통신소켓에 사용된 명령 프로토콜은 [json-rpc](https://www.jsonrpc.org/) 에 영감을 받았습니다.

요청은 다음과 같은 형식입니다 :

`{"id": 123, "method": "info", "params": {}}`

그리고 응답값은 아래와 같은 유형입니다 :

`{"id": 123, "result": {"state_message": "Printer is ready", "klipper_path": "/home/pi/klipper", "config_file": "/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6", "hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4 (v7l)", "state": "ready", "python_path": "/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}2`

각 요청은 JSON 딕셔너리여야 합니다. (이 문서는 "JSON object" - key/value 쌍은 `{}`를 포함하여 맵핑 - 를 표현하기 위해 파이썬 용어 사전을 사용합니다.)

요청 딕셔너리는 "method" 파라메터를 반드시 포함해야 합니다. 이 파라메터는 사용가능한 Klipper "endpoint"의 문자열 이름입니다.

요청 딕셔너리는 "params" 파라메터를 포함할 수 있습니다. 이 파라메터는 반드시 딕셔너리 타입이어야 합니다. "params" 는 클리퍼 "endpoint"가 요청을 다룰 수 있도록 추가적인 파라메터를 제공합니다. 그 내용은 "endpoint"에 특정됩니다.

요청 딕셔너리는 "id" 파라메터를 포함할 수 있습니다. 이 파라메터는 JSON 타입이 될 수 있습니다. 만일 "id" 가 존재한다면 클리퍼는 "id"를 포함한 응답 메시지와 함께 요청에 응답할 것입니다. 민일 "id" 가 생략되어 있다면 (혹은 JSON "null"값이 셋팅되어 있다면) 클리퍼는 요청에 대해 어떤 응답도 제공하지 않을 것입니다.
응답 메시지는 "id" 와 "result" 를 포함한 JSON 딕셔너리입니다. "result" 는 항상 딕셔너리 입니다. 그것의 내용은 요청을 다루는 "endpoint"에 특정됩니다.

만일 요청한 프로세싱이 오류면, 응답메시지는 "result" 필드 대신에 "error" 필드를 포함할 것입니다. 예를 들어, 다음과 같은 요청이 들어가면 : `{"id": 123, "method": "gcode/script", "params": {"script": "G1 X200"}}` 이런 에러메시지의 결과를 냅니다 : `{"id": 123, "error": {"message": "Must home axis first: 200.000 0.000 0.000 [0.000]", "error": "WebRequestError"}}`

클리퍼는 항상 받은 순서대로 요청 프로세싱을 시작합니다. 하지만 몇몇 요청들은 즉각 완료되지 않을 수 있습니다. 이로인해 관련응답이 다른 요청에 대한 응답순서를 벗어날 수도 있습니다. JSON 요청은 절대로 미래의 JSON 요청의 프로세싱을 중단시키지 않을 것입니다.

## 구독

몇몇 클리퍼의 "endpoint" 요청들은 미래의 비동기적인 업데이트 메시지를 나타내줍니다.

예를 들면:

`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{"key": 345}}}`

이것은 기본적으로 다음과 같이 응답합니다:

`{"id": 123, "result": {}}`

그리고, 클리퍼로 하여금 다음과 같은 미래 메시지들을 보내게 합니다:

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

메시지출력 요청은 "params" 필드 요청에 "response_template" 딕셔너리를 받아들입니다. "response_template" 딕셔너리는 미래 비동기 메시지를 위한 템플릿으로 사용됩니다. 그것은 임의의 키/값 쌍을 포함할 수 있습니다. 이러한 미래 비동기 메시지들을 보내려 할 때 클리퍼는 응답 템플릿에 "endpoint" 특정 딕셔너리 내용을 포함하고 있는 "params" 필드를 더할 것입니다. 그리고, 그 템플릿을 보내게 됩니다. 만약 "response_template" 필드가 제공되지 않는다면 빈 딕셔너리 (`{}`) 를 디폴트로 보내게 됩니다.

## 사용가능한 "endpoints"

관행적으로 클리퍼 "endpoints"는 `<module_name>/<some_name>` 형식으로 이뤄집니다. "endpoint" 에 요청을 하고자 할 때, full name 은 요청 딕셔너리의 "method" 파라메터에 셋팅되어 있어야만 합니다. (예, `{"method"="gcode/restart"}`).

### 정보

"info" endpoint 는 클리퍼로 부터 시스템과 버전 정보를 가져올 수 있습니다. 또한 클리퍼에 클라이언트 버전 정보르 제공하는데도 사용될 수 있습니다. 예시 : `{"id": 123, "method": "info", "params": { "client_info": { "version": "v1"}}}`

만일 정보가 존재한다면, "client_info" 파라메터는 딕셔너리여야만 합니다. 그러나 그 딕셔너리는 임의의 내용들을 가질 수 있습니다. 클라이언트는 처음 클리퍼 API 서버와 연결될 때 클라이언트의 이름이나 소프트웨어 버전을 제공할 수 있습니다.

### 비상정지

"emergency_stop" endpoint 는 클리퍼가 "shutdown" 상태로 가도록 지시하는데 사용합니다. 그것은 `M112` gcode 와 비슷하게 행동합니다. 예시 : `{"id": 123, "method": "emergency_stop"}`

### 레지스터 원격 메쏘드

이 endpoint 는 클라이언트가 클리퍼로부터 불려지 수 있도록 메쏘드를 등록하게 해줍니다. 이는 성공시 비어있는 객체를 반환합니다.

예시 : `{"id": 123, "method": "register_remote_method", "params": {"response_template": {"action": "run_paneldue_beep"}, "remote_method": "paneldue_beep"}}` 반환값 :`{"id": 123, "result": {}}`

원격 메쏘드 `paneldue_beep` 는 클리퍼로 부터 불려질 수 있습니다. 만일 메쏘드가 파라메터들을 가지게 되면 그것들은 키워드 아규먼트들로써 제공될 수 있음을 기억하십시오. 아래 어떻게 gcode 메크로에서 불러올 수 있는지에 대한 예시가 있습니다. :

```
[gcode_macro PANELDUE_BEEP] 
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

PANELDUE_BEEP gcode 매크로가 실행되면 클리퍼는 소켓위에 아래와 같은 것을 내보낼 것이다.: `{"action": "run_paneldue_beep", "params": {"frequency": 300, "duration": 1.0}}`

### 객체/리스트

이 endpoint는 쿼리할 수 있는 사용가능한 프린터 "objects"객체들의 리스트를 쿼리합니다. ("objects/query" endpoint 를 통하여). 예를 들면: `{"id": 123, "method": "objects/list"}` 이것은 다음과 같은 결과를 돌려줄 것입니다.: `{"id": 123, "result": {"objects": ["webhooks", "configfile", "heaters", "gcode_move", "query_endstops", "idle_timeout", "toolhead", "extruder"]}}`

### 객체/쿼리

이 endpoint 는 프린터 객체들로 부터 정보를 쿼리할 수 있게 해줍니다. 예를 들어: `{"id": 123, "method": "objects/query", "params": {"objects": {"toolhead": ["position"], "webhooks": null}}}` 이렇게 입력하면, 다음과 같은 값을 돌려줍니다. : `{"id": 123, "result": {"status": {"webhooks": {"state": "ready", "state_message": "Printer is ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3051555.377933684}}`

요청에 들어 있는 "objects" 파라메터는 쿼리되어질 수 있는 프린터 객체를 포함하고 있는 딕셔너리여야 합니다. - 핵심 포함요소는 프린터 객체 이름과 키값이 "null" 이거나 필드 이름의 리스트여야 합니다.

응답 메시지는 쿼리된 정보를 가지고 있는 딕셔너리에 포함된 "status" 필드를 포함할 것입니다. 프린터 이름을 포함해야 하며 그 값은 그것을 포함하고 있는 딕셔너리입니다. 응답 메시지는 또한 쿼리가 가져와질때의 타임스탬프를 포함한 "eventtime"필드를 포함할 것입니다.

가능한 필드들은 다음 문서에 있습니다. [Status Reference](Status_Reference.md) 문서.

### 객체/서브스크라이브

이 endpoint 는 프린터 객체로 부터 정보를 쿼리하고 서브스크라이브 할 수 있게 해줍니다. 이 endpoint 의 요청과 응답은 "objects/query" endpoint 와 동일합니다. 예를 들어 : `{"id": 123, "method": "objects/subscribe", "params": {"objects":{"toolhead": ["position"], "webhooks": ["state"]}, "response_template":{}}}` 이것은 다음을 돌려줄 것입니다. : `{"id": 123, "result": {"status": {"webhooks": {"state": "ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3052153.382083195}}` 그리고 다음과 같은 연속된 비동기형 메시지를 내보내줄 것입니다. `{"params": {"status": {"webhooks": {"state": "shutdown"}}, "eventtime": 3052165.418815847}}`

### gcode/도움말

이 endpoint 는 정의된 help 문자열을 가지고 있는 가능한 G-Code 명령을 쿼리할 수 있게 해줍니다. 예를 들어 : `{"id": 123, "method": "gcode/help"}` 이것은 다음을 돌려줄 것입니다.: `{"id": 123, "result": {"RESTORE_GCODE_STATE": "Restore a previously saved G-Code state", "PID_CALIBRATE": "Run PID calibration test", "QUERY_ADC": "Report the last value of an analog pin", ...}}`

### gcode/스크립트

이 endpoint 는 일련의 G-code 명령어들을 실행할 수 있게 해줍니다. 예를들어 : `{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}`

만일 제공된 G-code 스크립트가 에러를 내면, 에러응답이 생성됩니다. 그러나 만일 G-code 명령이 터미널 결과값을 생성해내면 그 터미널 결과값은 응답값으로 제공되지 않습니다. (G-code 터미널 결과값을 얻고자 한다면 "gcode/subscribe_output" endpoint 를 사용하십시오)

만일 요청이 받아들여졌을때 프로세싱되는 G-code 명령이 있다면, 제공된 스크립트는 순서를 기다리게 될 것이다. 이 지연은 매우 중요할 수 있다. (예를 들어 온도 명령을 기다리는 G-code 가 작동될 때와 같이 말이다) JSON 응답 메시지는 스크립트의 프로세싱을 완전히 끝마쳤을때 보내진다.

### gcode/재시작

이 endpoint 는 재시작 요청을 수행할 수 있게 해준다. 이것은 "RESTART" G-Code 명령 실행과 유사하다. 예를 들면 : `{"id": 123, "method": "gcode/restart"}`

"gcode/script" endpoint 와 같이 사용할 때 이 endpoint 는 지연된 G-Code 명령들이 완료된 후에만 오직 끝마칠 수 있다.

### gcode/펌웨어 재실행

이것은 "gcode/restart" endpoint 와 유사하다. - 그것도 "FIRMWARE_RESTART" G-Code 명령을 수행합니다. 예를 들면 : `{"id": 123, "method": "gcode/firmware_restart"}`

"gcode/script" endpoint 와 같이 사용할 때 이 endpoint 는 지연된 G-Code 명령들이 완료된 후에만 오직 끝마칠 수 있다.

### gcode/서브스크라이브_출력

이 endpoint 는 클리퍼에 의해 생성된 G-code 터미널 메시지를 표시할 때 사용됩니다. 예를 들어 : `{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{}}}` 이것은 후에 다음과 같은 비동기형 메시지를 내보낼 수 있습니다. : `{"params": {"response": "// Klipper state: Shutdown"}}`

이 endpoint 는 터미널창 인터페이스를 통해 인간과 상호작용을 하도록 도와줄 수 있게 합니다. G-code 터미널 출력으로 부터의 파싱 내용은 낙담케(?) 된다. 클리퍼 상태에 대한 업데이트 내용을 얻고자 할 때는 "objects/subscribe" endpoint 를 사용하라.

### 멈춤_재개/취소

이 endpoint 는 "PRINT_CANCEL" G-Code 명령을 실행하는 것과 유사하다. 예를 들어 : `{"id": 123, "method": "pause_resume/cancel"}`

"gcode/script" endpoint 와 같이 사용할 때 이 endpoint 는 지연된 G-Code 명령들이 완료된 후에만 오직 끝마칠 수 있다.

### 멈춤_재개/멈춤

이 endpoint 는 "PAUSE" G-Code 명령을 실행하는 것과 유사하다. 예를 들어 : `{"id": 123, "method": "pause_resume/pause"}`

"gcode/script" endpoint 와 같이 사용할 때 이 endpoint 는 지연된 G-Code 명령들이 완료된 후에만 오직 끝마칠 수 있다.

### 멈춤_재개/재개

이 endpoint 는 "RESUME" G-Code 명령을 실행하는 것과 유사하다. 예를 들어 : `{"id": 123, "method": "pause_resume/resume"}`

"gcode/script" endpoint 와 같이 사용할 때 이 endpoint 는 지연된 G-Code 명령들이 완료된 후에만 오직 끝마칠 수 있다.

### 쿼리_엔드스탑/상태

이 endpoint 는 실행 endpoint들을 쿼리하고 그들의 상태를 반환해줄것이다. 예를 들어 : `{"id": 123, "method": "query_endstops/status"}` 이것은 다음을 반환할 것이다. : `{"id": 123, "result": {"y": "open", "x": "open", "z": "TRIGGERED"}}`

"gcode/script" endpoint 와 같이 사용할 때 이 endpoint 는 지연된 G-Code 명령들이 완료된 후에만 오직 끝마칠 수 있다.
