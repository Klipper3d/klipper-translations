# CANBUS

Diese Dokumentation beschreibt die Kompatibilität zwischen Klipper und Can bus.

## Geräte-Hardware

Klipper unterstützt zur Zeit nur CAN von STM32 Microprozessoren. Außerdem muss der Mikrocontroller-Chip CAN unterstützen und sich auf einer Platine befinden, die über einen CAN-Transceiver verfügt.

Um für CAN zu kompilieren, führen Sie `make menuconfig` aus und wählen Sie "CAN bus" als Kommunikationsschnittstelle. Schließlich kompilieren Sie den Mikrocontroller-Code und flashen ihn auf die Zielplatine.

## Host Hardware

Um einen CAN-Bus nutzen zu können, ist ein Host-Adapter erforderlich. Derzeit gibt es zwei gängige Optionen:

1. Verwenden Sie einen [Waveshare Raspberry Pi CAN hat](https://www.waveshare.com/rs485-can-hat.htm) oder einen seiner vielen Klone.
1. Verwenden Sie einen USB-CAN-Adapter (zum Beispiel <https://hacker-gadgets.com/product/cantact-usb-can-adapter/>). Es gibt viele verschiedene USB-zu-CAN-Adapter - wenn Sie einen auswählen, empfehlen wir Ihnen zu überprüfen, ob er die [Candlelight-Firmware](https://github.com/candle-usb/candleLight_fw) ausführen kann. (Leider haben wir festgestellt, dass einige USB-Adapter mit fehlerhafter Firmware laufen und gesperrt sind, also überprüfen Sie das vor dem Kauf).

Es ist auch notwendig, das Host-Betriebssystem für die Verwendung des Adapters zu konfigurieren. Dazu wird normalerweise eine neue Datei mit dem Pfad `/etc/network/interfaces.d/can0` mit folgendem Inhalt erstellt:

```
auto can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```

Beachten Sie, dass der "Raspberry Pi CAN hat" auch [Änderungen an der config.txt](https://www.waveshare.com/wiki/RS485_CAN_HAT) erfordert.

## Endwiderstände

Ein CAN-Bus sollte zwei 120-Ohm-Widerstände zwischen den CANH- und CANL-Leitungen haben. Idealerweise befindet sich jeweils ein Widerstand an jedem Enden des Busses.

Beachten Sie, dass einige Geräte einen eingebauten 120-Ohm-Widerstand haben (z. B. hat der "Waveshare Raspberry Pi CAN hat" einen angelöteten Widerstand, der nicht einfach entfernt werden kann). Einige Geräte wiederum haben überhaupt keinen Widerstand. Andere Geräte verfügen über einen Mechanismus zur Auswahl des Widerstands (typischerweise durch Verbinden eines "Pin-Jumpers"). Überprüfen Sie unbedingt die Schaltpläne aller Geräte am CAN-Bus, um sicherzustellen, dass sich zwei und nur zwei 120-Ohm-Widerstände auf dem Bus befinden.

Um zu prüfen, ob die Widerstände korrekt sind, kann man die Stromversorgung des Druckers unterbrechen und mit einem Multimeter den Widerstand zwischen den CANH- und CANL-Drähten messen - bei einem korrekt verdrahteten CAN-Bus sollte er ~60 Ohm anzeigen.

## Suche nach der canbus_uuid für neue Mikrocontroller

Jedem Mikrocontroller auf dem CAN-Bus wird eine eindeutige Kennung zugewiesen, die auf der werkseitigen Chip-Kennung basiert. Diese ist in jedem Mikrocontroller fest kodiert ist. Um die Geräte-ID jedes Mikrocontrollers zu finden, stellen Sie sicher, dass die Hardware mit Strom versorgt und korrekt verdrahtet ist, und starten Sie dann:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Wenn nicht initialisierte CAN-Geräte erkannt werden, meldet der obige Befehl Zeilen wie folgt:

```
Found canbus_uuid=11aa22bb33cc
```

Jedes Gerät hat eine eindeutige Kennung. Im obigen Beispiel ist `11aa22bb33cc` die "canbus_uuid" des Mikrocontrollers.

Beachten Sie, dass das Werkzeug `canbus_query.py` nur uninitialisierte Geräte meldet - wenn Klipper (oder ein ähnliches Werkzeug) das Gerät konfiguriert, erscheint es nicht mehr in der Liste.

## Klipper einstellen

Aktualisieren Sie die Klipper [mcu configuration](Config_Reference.md#mcu), um den CAN-Bus zur Kommunikation mit dem Gerät zu verwenden - zum Beispiel:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```
