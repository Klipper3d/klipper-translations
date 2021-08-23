# CANBUS

이 문서는 Klipper의 CAN bus 지원에 대해 설명합니다.

## 장치 하드웨어

Klipper는 현재 stm32 칩에서만 CAN을 지원합니다. 또한 마이크로 컨트롤러 칩은 CAN을 지원해야 하며 CAN 트랜시버가 보드에 있어야 합니다.

CAN용으로 컴파일하려면 "make menuconfig"를 실행하고 communication interface에서 "CAN bus"를 선택하십시오. 마지막으로 마이크로 컨트롤러 코드를 컴파일하고 대상 보드에 플래시합니다.

## Host Hardware

CAN bus를 사용하려면, 호스트 어댑터가 필요합니다. 현재까지 두 가지 일반적인 옵션이 있습니다 :

1. [Waveshare Raspberry Pi CAN hat](https://www.waveshare.com/rs485-can-hat.htm) 을 사용하거나, 다른 클론제품을 사용합니다.
1. Use a USB CAN adapter (for example <https://hacker-gadgets.com/product/cantact-usb-can-adapter/>). There are many different USB to CAN adapters available - when choosing one, we recommend verifying it can run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw). (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.)

또한 어댑터를 사용하도록 호스트 운영 체제를 구성해야 합니다. 이것은 일반적으로 다음과 같이 `/etc/network/interfaces.d/can0` 이라는 새 파일을 생성하여 수행됩니다:

```
auto can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```

Note : "Raspberry Pi CAN hat"도 마찬가지로 [changes to config.txt](https://www.waveshare.com/wiki/RS485_CAN_HAT) 변경이 필요합니다.

## 종단 저항

CAN bus 에는 CANH와 CANL 와이어 사이에 2개의 120옴 저항이 있어야 합니다. 이상적으로는 각 끝에 하나의 저항이 있습니다.

일부 장치에는 120옴 저항이 내장되어 있습니다.(예: "Waveshare Raspberry Pi CAN 모자"에는 쉽게 제거할 수 없는 저항이 납땜되어 있음). 일부 장치에는 저항이 전혀 포함되어 있지 않습니다. 다른 장치에는 저항을 선택하는 메커니즘이 있습니다(일반적으로 "핀 점퍼"로 연결). CAN bus에 있는 모든 장치의 회로도를 확인하여 2개의 120 Ohm 저항이 있는지 확인하십시오.

저항이 올바른지 테스트하기 위해 프린터의 전원을 끄고 멀티미터를 사용하여 CANH와 CANL 와이어 사이의 저항을 확인할 수 있습니다. 올바르게 배선된 CAN bus에서 ~60옴이 나와야 합니다.

## 새로운 마이크로 컨트롤러를 위한 canbus_uuid 찾기

CAN bus의 각 마이크로 컨트롤러에는 각 마이크로 컨트롤러에 인코딩된 공장 칩 식별자를 기반으로 고유한 ID가 할당됩니다. 각 마이크로 컨트롤러 장치 ID를 찾으려면 하드웨어에 전원이 공급되고 올바르게 연결되었는지 확인한 후 다음을 실행합니다:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

초기화되지 않은 CAN 장치가 감지되면 위의 명령 후 다음과 같은 행을 보여줍니다 :

```
Found canbus_uuid=11aa22bb33cc
```

각 장치에는 고유한 식별자가 있습니다. 위의 예에서는 `11aa22bb33cc`가 마이크로 컨트롤러의 "canbus_uuid"입니다.

`canbus_query.py `도구는 초기화되지 않은 장치만 보고합니다. 만약 Klipper(또는 유사한 도구)가 장치를 구성하면 더 이상 목록에 나타나지 않습니다.

## Klipper 설정

장치와 통신하기 위해 CAN bus를 사용하도록 Klipper [mcu configuration](Config_Reference.md#mcu) 을 업데이트합니다. 예를 들면 다음과 같습니다:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```
