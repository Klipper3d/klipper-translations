# CANBUS 프로토콜

This document describes the protocol Klipper uses to communicate over [CAN bus](https://en.wikipedia.org/wiki/CAN_bus). See <CANBUS.md> for information on configuring Klipper with CAN bus.

## 마이크로 컨트롤러 ID 할당

Klipper는 8 데이터 바이트와 11비트 CAN bus identifier로 제한되는 CAN 2.0A 표준 크기 CAN bus 패킷만 사용합니다. 효율적인 통신을 지원하기 위해 각 마이크로 컨트롤러에는 일반 Klipper 명령 및 응답 트래픽에 대해 고유한 1바이트 CAN bus 노드 ID(`canbus_nodeid`)가 런타임에 할당됩니다. 호스트에서 마이크로 컨트롤러로 가는 Klipper 명령 메시지는 `canbus_nodeid * 2 + 256`의 CAN bus ID를 사용하는 반면, 마이크로 컨트롤러에서 호스트로 가는 Klipper 응답 메시지는 `canbus_nodeid * 2 + 256 + 1`을 사용합니다.

각 마이크로 컨트롤러에는 ID 할당 중에 사용되는 공장 할당 고유 칩 식별자가 있습니다. 이 식별자는 하나의 CAN 패킷 길이를 초과할 수 있으므로 해시 함수를 사용하여 공장 ID에서 고유한 6바이트 ID(`canbus_uuid`)를 생성합니다.

## 관리자 메시지

관리자 메시지는 ID 할당에 사용됩니다. 호스트에서 마이크로 컨트롤러로 전송된 관리자 메시지는 CAN bus ID `0x3f0`을 사용하고 마이크로 컨트롤러에서 호스트로 전송되는 메시지는 CAN bus ID`0x3f1`을 사용합니다. 모든 마이크로 컨트롤러는 id `0x3f0`의 메시지를 수신합니다. 이 id는 "브로드캐스트 주소"로 생각할 수 있습니다.

### CMD_QUERY_UNASSIGNED 메시지

이 명령은 아직 `canbus_nodeid`가 할당되지 않은 모든 마이크로 컨트롤러를 나타냅니다. 할당되지 않은 마이크로 컨트롤러는 RESP_NEED_NODEID 응답 메시지로 응답합니다.

CMD_QUERY_UNASSIGNED 메시지 형식은 다음과 같습니다: `<1-byte message_id = 0x00>`

### CMD_SET_NODEID 메시지

이 명령은`canbus_uuid`가 지정된 마이크로 컨트롤러에 `canbus_nodeid`를 할당합니다.

CMD_SET_NODEID 메시지 형식은 다음과 같습니다: `<1-byte message_id = 0x01><6-byte canbus_uuid><1-byte canbus_nodeid>`

### RESP_NEED_NODEID 메시지

RESP_NEED_NODEID 메시지 형식은 다음과 같습니다: `<1-byte message_id = 0x20><6-byte canbus_uuid>`

## 데이터 패킷

CMD_SET_NODEID 명령을 통해 nodeid가 할당된 마이크로 컨트롤러는 데이터 패킷을 보내고 받을 수 있습니다.

노드의 수신 CAN bus ID(`canbus_nodeid * 2 + 256`)를 사용하는 메시지의 패킷 데이터는 단순히 버퍼에 추가되고 완전한 [mcu protocol message](Protocol.md) 가 발견되면 해당 내용을 구문 분석하고 처리합니다. 데이터는 바이트 스트림으로 처리됩니다 - CAN bus 패킷의 시작과 정렬하기 위해 Klipper 메시지 블록의 시작에 대한 요구 사항은 없습니다.

유사하게, mcu 프로토콜 메시지 응답은 노드의 전송 CAN bus ID(`canbus_nodeid * 2 + 256 + 1`)와 함께 메시지 데이터를 하나 이상의 패킷으로 복사하여 마이크로 컨트롤러에서 호스트로 전송됩니다.
