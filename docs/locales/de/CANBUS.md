# CANBUS

Diese Dokumentation beschreibt die Kompatibilität zwischen Klipper und Can bus.

## Geräte-Hardware

Klipper unterstützt derzeit CAN auf stm32, SAME5x und rp2040 Chips. Zusätzlich muss der Mikrocontrollerchip auf einer Platine sein, die einen CAN-Transceiver aufweist.

Um für CAN zu kompilieren, führen Sie `make menuconfig` aus und wählen Sie "CAN bus" als Kommunikationsschnittstelle. Schließlich kompilieren Sie den Mikrocontroller-Code und flashen ihn auf die Zielplatine.

## Host Hardware

Um einen CAN-Bus zu verwenden, wird ein Host-Adapter benötigt. Es wird empfohlen, einen "USB-zu-CAN-Adapter" zu verwenden. Es gibt viele verschiedene USB-zu-CAN-Adapter unterschiedlicher Hersteller. Bei der Auswahl empfehlen wir zu prüfen, ob sich die Firmware aktualisieren lässt. (Leider haben wir festgestellt, dass manche USB-Adapter mit fehlerhafter Firmware laufen und gesperrt sind - prüfen Sie dies daher vor dem Kauf.) Achten Sie auf Adapter, die Klipper direkt (im "USB-zu-CAN-Bridge-Modus") ausführen können, oder die die [candlelight-Firmware](https://github.com/candle-usb/candleLight_fw) verwenden.

Es ist auch notwendig, das Host-Betriebssystem für die Verwendung des Adapters zu konfigurieren. Dazu wird normalerweise eine neue Datei mit dem Pfad `/etc/network/interfaces.d/can0` mit folgendem Inhalt erstellt:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```

## Endwiderstände

Ein CAN-Bus sollte zwei 120-Ohm-Widerstände zwischen den CANH- und CANL-Leitungen haben. Idealerweise befindet sich jeweils ein Widerstand an jedem Enden des Busses.

Beachten Sie, dass manche Geräte über einen eingebauten 120-Ohm-Widerstand verfügen, der sich nicht ohne Weiteres entfernen lässt. Manche Geräte enthalten überhaupt keinen Widerstand. Andere Geräte verfügen über einen Mechanismus zur Auswahl des Widerstands (üblicherweise durch Setzen eines "Pin-Jumpers"). Prüfen Sie unbedingt die Schaltpläne aller Geräte am CAN-Bus, um sicherzustellen, dass sich genau zwei 120-Ohm-Widerstände am Bus befinden.

Um zu prüfen, ob die Widerstände korrekt sind, kann man die Stromversorgung des Druckers unterbrechen und mit einem Multimeter den Widerstand zwischen den CANH- und CANL-Drähten messen - bei einem korrekt verdrahteten CAN-Bus sollte er ~60 Ohm anzeigen.

## Suche nach der canbus_uuid für neue Mikrocontroller

Jedem Mikrocontroller auf dem CAN-Bus wird eine eindeutige Kennung zugewiesen, die auf der werkseitigen Chip-Kennung basiert. Diese ist in jedem Mikrocontroller fest kodiert ist. Um die Geräte-ID jedes Mikrocontrollers zu finden, stellen Sie sicher, dass die Hardware mit Strom versorgt und korrekt verdrahtet ist, und starten Sie dann:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Wenn nicht initialisierte CAN-Geräte erkannt werden, meldet der obige Befehl Zeilen wie folgt:

```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

Jedes Gerät hat eine eindeutige Kennung. Im obigen Beispiel ist `11aa22bb33cc` die "canbus_uuid" des Mikrocontrollers.

Beachten Sie, dass das Werkzeug `canbus_query.py` nur uninitialisierte Geräte meldet - wenn Klipper (oder ein ähnliches Werkzeug) das Gerät konfiguriert, erscheint es nicht mehr in der Liste.

## Klipper einstellen

Aktualisieren Sie die Klipper [mcu configuration](Config_Reference.md#mcu), um den CAN-Bus zur Kommunikation mit dem Gerät zu verwenden - zum Beispiel:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## USB zu CAN-Bus Brückenmodus

Manche Mikrocontroller unterstützen die Auswahl des Modus "USB-zu-CAN-Bus-Bridge" während Klippers "make menuconfig". Dieser Modus ermöglicht es, einen Mikrocontroller sowohl als "USB-zu-CAN-Bus-Adapter" als auch als Klipper-Knoten zu verwenden.

Verwendet Klipper diesen Modus, erscheint der Mikrocontroller unter Linux als "USB-CAN-Bus-Adapter". Der "Klipper-Bridge-MCU" selbst erscheint so, als befände er sich auf diesem CAN-Bus - er kann über `canbus_query.py` identifiziert werden und muss wie andere CAN-Bus-Klipper-Knoten konfiguriert werden.

Einige wichtige Hinweise bei der Verwendung dieses Modus:

* Es ist notwendig, die Schnittstelle `can0` (oder ähnlich) in Linux zu konfigurieren, um mit dem Bus zu kommunizieren. Die CAN-Bus-Geschwindigkeit und die Bit-Timing-Optionen des CAN-Bus unter Linux werden von Klipper jedoch ignoriert. Aktuell wird die CAN-Bus-Frequenz während "make menuconfig" festgelegt, und die unter Linux angegebene Busgeschwindigkeit wird ignoriert.
* Wird der "Bridge-MCU" zurückgesetzt, deaktiviert Linux die entsprechende `can0`-Schnittstelle. Um eine korrekte Verarbeitung der Befehle FIRMWARE_RESTART und RESTART sicherzustellen, wird empfohlen, `allow-hotplug` in der Datei `/etc/network/interfaces.d/can0` zu verwenden. Zum Beispiel:

```
allow-hotplug can0
iface can0 can static
    bitrate 1000000
    up ip link set $IFACE txqueuelen 128
```

* Der "Bridge-MCU" befindet sich nicht tatsächlich am CAN-Bus. Nachrichten von und zum Bridge-MCU werden von anderen Adaptern, die sich möglicherweise am CAN-Bus befinden, nicht gesehen.
* Die verfügbare Bandbreite sowohl zum "Bridge-MCU" selbst als auch zu allen Geräten am CAN-Bus wird effektiv durch die CAN-Bus-Frequenz begrenzt. Daher wird bei Verwendung des "USB-zu-CAN-Bus-Bridge-Modus" eine CAN-Bus-Frequenz von 1000000 empfohlen.
* Die Verwendung des USB-zu-CAN-Bridge-Modus ist nur dann sinnvoll, wenn ein funktionierender CAN-Bus mit mindestens einem weiteren Knoten (zusätzlich zum Bridge-Knoten selbst) vorhanden ist. Verwenden Sie eine Standard-USB-Konfiguration, wenn nur mit dem einzelnen USB-Gerät kommuniziert werden soll. Die Verwendung des USB-zu-CAN-Bridge-Modus ohne einen vollständig funktionierenden CAN-Bus (einschließlich Abschlusswiderständen und eines zusätzlichen Knotens) kann zu sporadischen Fehlern führen, selbst bei der Kommunikation mit dem Bridge-Knoten.
* Eine USB-zu-CAN-Bridge-Platine erscheint nicht als USB-Seriell-Gerät, sie wird beim Ausführen von `ls /dev/serial/by-id` nicht angezeigt und kann in Klippers printer.cfg-Datei nicht mit einem `serial:`-Parameter konfiguriert werden. Die Bridge-Platine erscheint als "USB-CAN-Adapter" und wird in der printer.cfg als [CAN-Knoten](#configuring-klipper) konfiguriert.

## Tipps zur Fehlerbehebung

Siehe das [CAN bus troubleshooting](CANBUS_Troubleshooting.md) Dokument.
