# CANBUS

이 문서는 Klipper의 CAN bus 지원에 대해 설명합니다.

## 장치 하드웨어

Klipper currently supports CAN on stm32, SAME5x, and rp2040 chips. In addition, the micro-controller chip must be on a board that has a CAN transceiver.

To compile for CAN, run `make menuconfig` and select "CAN bus" as the communication interface. Finally, compile the micro-controller code and flash it to the target board.

## Host Hardware

In order to use a CAN bus, it is necessary to have a host adapter. It is recommended to use a "USB to CAN adapter". There are many different USB to CAN adapters available from different manufacturers. When choosing one, we recommend verifying that the firmware can be updated on it. (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.) Look for adapters that can run Klipper directly (in its "USB to CAN bridge mode") or that run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

또한 어댑터를 사용하도록 호스트 운영 체제를 구성해야 합니다. 이것은 일반적으로 다음과 같이 `/etc/network/interfaces.d/can0` 이라는 새 파일을 생성하여 수행됩니다:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

## 종단 저항

CAN bus 에는 CANH와 CANL 와이어 사이에 2개의 120옴 저항이 있어야 합니다. 이상적으로는 각 끝에 하나의 저항이 있습니다.

Note that some devices have a builtin 120 ohm resistor that can not be easily removed. Some devices do not include a resistor at all. Other devices have a mechanism to select the resistor (typically by connecting a "pin jumper"). Be sure to check the schematics of all devices on the CAN bus to verify that there are two and only two 120 Ohm resistors on the bus.

저항이 올바른지 테스트하기 위해 프린터의 전원을 끄고 멀티미터를 사용하여 CANH와 CANL 와이어 사이의 저항을 확인할 수 있습니다. 올바르게 배선된 CAN bus에서 ~60옴이 나와야 합니다.

## 새로운 마이크로 컨트롤러를 위한 canbus_uuid 찾기

CAN bus의 각 마이크로 컨트롤러에는 각 마이크로 컨트롤러에 인코딩된 공장 칩 식별자를 기반으로 고유한 ID가 할당됩니다. 각 마이크로 컨트롤러 장치 ID를 찾으려면 하드웨어에 전원이 공급되고 올바르게 연결되었는지 확인한 후 다음을 실행합니다:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

초기화되지 않은 CAN 장치가 감지되면 위의 명령 후 다음과 같은 행을 보여줍니다 :

```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

각 장치에는 고유한 식별자가 있습니다. 위의 예에서는 `11aa22bb33cc`가 마이크로 컨트롤러의 "canbus_uuid"입니다.

`canbus_query.py `도구는 초기화되지 않은 장치만 보고합니다. 만약 Klipper(또는 유사한 도구)가 장치를 구성하면 더 이상 목록에 나타나지 않습니다.

## Klipper 구성 중

장치와 통신하기 위해 CAN bus를 사용하도록 Klipper [mcu configuration](Config_Reference.md#mcu) 을 업데이트합니다. 예를 들면 다음과 같습니다:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB to CAN bus bridge mode

Some micro-controllers support selecting "USB to CAN bus bridge" mode during Klipper's "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if it was on this CAN bus - it can be identified via `canbus_query.py` and it must be configured like other CAN bus Klipper nodes.

Some important notes when using this mode:

* It is necessary to configure the `can0` (or similar) interface in Linux in order to communicate with the bus. However, Linux CAN bus speed and CAN bus bit-timing options are ignored by Klipper. Currently, the CAN bus frequency is specified during "make menuconfig" and the bus speed specified in Linux is ignored.
* Whenever the "bridge mcu" is reset, Linux will disable the corresponding `can0` interface. To ensure proper handling of FIRMWARE_RESTART and RESTART commands, it is recommended to use `allow-hotplug` in the `/etc/network/interfaces.d/can0` file. For example:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

* The "bridge mcu" is not actually on the CAN bus. Messages to and from the bridge mcu will not be seen by other adapters that may be on the CAN bus.

   * The available bandwidth to both the "bridge mcu" itself and all devices on the CAN bus is effectively limited by the CAN bus frequency. As a result, it is recommended to use a CAN bus frequency of 1000000 when using "USB to CAN bus bridge mode".Even at a CAN bus frequency of 1000000, there may not be sufficient bandwidth to run a `SHAPER_CALIBRATE` test if both the XY steppers and the accelerometer all communicate via a single "USB to CAN bus" interface.
* A USB to CAN bridge board will not appear as a USB serial device, it will not show up when running `ls /dev/serial/by-id`, and it can not be configured in Klipper's printer.cfg file with a `serial:` parameter. The bridge board appears as a "USB CAN adapter" and it is configured in the printer.cfg as a [CAN node](#configuring-klipper).

## Tips for troubleshooting

See the [CAN bus troubleshooting](CANBUS_Troubleshooting.md) document.
