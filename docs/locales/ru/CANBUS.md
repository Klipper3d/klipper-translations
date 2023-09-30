# CANBUS

В этом документе описывается поддержка шины CAN Klipper.

## Оборудование устройства

Klipper currently supports CAN on stm32, SAME5x, and rp2040 chips. In addition, the micro-controller chip must be on a board that has a CAN transceiver.

Чтобы скомпилировать для CAN, запустите `make menuconfig` и выберите «CAN bus» в качестве интерфейса связи. Наконец, скомпилируйте код микроконтроллера и запишите его на целевую плату.

## Оборудование хоста

In order to use a CAN bus, it is necessary to have a host adapter. It is recommended to use a "USB to CAN adapter". There are many different USB to CAN adapters available from different manufacturers. When choosing one, we recommend verifying that the firmware can be updated on it. (Unfortunately, we've found some USB adapters run defective firmware and are locked down, so verify before purchasing.) Look for adapters that can run Klipper directly (in its "USB to CAN bridge mode") or that run the [candlelight firmware](https://github.com/candle-usb/candleLight_fw).

Также необходимо настроить операционную систему хоста на использование адаптера. Обычно это делается путем создания нового файла `/etc/network/interfaces.d/can0` со следующим содержимым:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ifconfig $IFACE txqueuelen 128
```

## Согласующие резисторы

Шина CAN должна иметь два резистора по 120 Ом между проводами CANH и CANL. В идеале по одному резистору, расположенному на каждом конце шины.

Note that some devices have a builtin 120 ohm resistor that can not be easily removed. Some devices do not include a resistor at all. Other devices have a mechanism to select the resistor (typically by connecting a "pin jumper"). Be sure to check the schematics of all devices on the CAN bus to verify that there are two and only two 120 Ohm resistors on the bus.

Чтобы проверить правильность резисторов, можно отключить питание принтера и с помощью мультиметра проверить сопротивление между проводами CANH и CANL ‐ он должен показывать ~60 Ом на правильно подключенной шине CAN.

## Поиск canbus_uuid для новых микроконтроллеров

Каждому микроконтроллеру на шине CAN присваивается уникальный идентификатор на основе заводского идентификатора микросхемы, закодированного в каждом микроконтроллере. Чтобы найти идентификатор каждого устройства микроконтроллера, убедитесь, что оборудование подключено правильно и подключено правильно, а затем запустите:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Если обнаружены неинициализированные устройства CAN, приведенная выше команда выдаст следующие строки:

```
Найден canbus_uuid=11aa22bb33cc, Приложение: Klipper
```

Каждое устройство будет иметь уникальный идентификатор. В приведенном выше примере `11aa22bb33cc` ‐ это «canbus_uuid» микроконтроллера.

Обратите внимание, что инструмент `canbus_query.py` сообщает только о неинициализированных устройствах — если Klipper (или аналогичный инструмент) настроит устройство, оно больше не будет отображаться в списке.

## Настройка клиперов

Обновите Klipper [конфигурацию mcu](Config_Reference.md#mcu), чтобы использовать шину CAN для связи с устройством, например:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## Режим моста USB-CAN

Some micro-controllers support selecting "USB to CAN bus bridge" mode during Klipper's "make menuconfig". This mode may allow one to use a micro-controller as both a "USB to CAN bus adapter" and as a Klipper node.

When Klipper uses this mode the micro-controller appears as a "USB CAN bus adapter" under Linux. The "Klipper bridge mcu" itself will appear as if it was on this CAN bus - it can be identified via `canbus_query.py` and it must be configured like other CAN bus Klipper nodes.

Несколько важных замечаний по использованию этого режима:

* Для связи с шиной необходимо настроить интерфейс `can0` (или аналогичный) в Linux. Однако Klipper игнорирует скорость шины CAN Linux и параметры синхронизации битов CAN-шины. В настоящее время частота шины CAN указывается во время «make menuconfig», а скорость шины, указанная в Linux, игнорируется.
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
