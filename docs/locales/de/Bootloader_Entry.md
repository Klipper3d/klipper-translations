# Bootloader-Eintrag

Klipper kann auf eine der folgenden Arten zum Neustart in einen [Bootloader](Bootloaders.md) angewiesen werden:

## Den Bootloader anfordern

### Virtuell Seriell

Wird ein virtueller (USB-ACM) serieller Port verwendet, fordert das kurzzeitige Pulsen von DTR bei 1200 Baud den Bootloader an.

#### Python (mit `flash_usb`)

Um den Bootloader mit Python aufzurufen (über `flash_usb`):

```shell
> cd klipper/scripts
> python3 -c 'import flash_usb as u; u.enter_bootloader("<DEVICE>")'
Entering bootloader on <DEVICE>
```

Dabei ist `<DEVICE>` Ihr serielles Gerät, zum Beispiel `/dev/serial.by-id/usb-Klipper[...]` oder `/dev/ttyACM0`

Beachten Sie: Schlägt dies fehl, wird keine Ausgabe angezeigt; Erfolg wird durch die Ausgabe `Entering bootloader on <DEVICE>` angezeigt.

#### Picocom

```shell
picocom -b 1200 <DEVICE>
<Ctrl-A><Ctrl-P>
```

Dabei ist `<DEVICE>` Ihr serielles Gerät, zum Beispiel `/dev/serial.by-id/usb-Klipper[...]` oder `/dev/ttyACM0`

`<Strg-A><Strg-P>` bedeutet: `Strg` gedrückt halten, `a` drücken und loslassen, `p` drücken und loslassen, dann `Strg` loslassen

### Physisch Seriell

Wird am MCU ein physischer serieller Port verwendet (auch wenn zur Verbindung ein USB-Serial-Adapter zum Einsatz kommt), fordert das Senden der Zeichenkette `<LEERZEICHEN><FS><LEERZEICHEN>Request Serial Bootloader!!<LEERZEICHEN>~` den Bootloader an.

`<LEERZEICHEN>` ist ein wörtliches ASCII-Leerzeichen, 0x20.

`<FS>` ist das ASCII-File-Separator-Zeichen, 0x1c.

Beachten Sie, dass dies gemäß dem [MCU-Protokoll](Protocol.md#micro-controller-interface) keine gültige Nachricht ist, Synchronisationszeichen (`~`) jedoch weiterhin beachtet werden.

Da diese Nachricht das Einzige sein muss, was in dem "Block" empfangen wird, in dem sie eintrifft, kann das Voranstellen eines zusätzlichen Synchronisationszeichens die Zuverlässigkeit erhöhen, falls zuvor andere Werkzeuge auf den seriellen Port zugegriffen haben.

#### Shell

```shell
stty <BAUD> < /dev/<DEVICE>
echo $'~ \x1c Request Serial Bootloader!! ~' >> /dev/<DEVICE>
```

Dabei ist `<DEVICE>` Ihr serieller Port, zum Beispiel `/dev/ttyS0` oder `/dev/serial/by-id/gpio-serial2`, und

`<BAUD>` ist die Baudrate des seriellen Ports, zum Beispiel `115200`.

### CANBUS

Wird CANBUS verwendet, fordert eine spezielle [Admin-Nachricht](CANBUS_protocol.md#admin-messages) den Bootloader an. Diese Nachricht wird auch dann beachtet, wenn das Gerät bereits eine Node-ID besitzt, und wird auch verarbeitet, wenn der MCU heruntergefahren ist.

Diese Methode gilt auch für Geräte, die im Modus [CANBridge](CANBUS.md#usb-to-can-bus-bridge-mode) betrieben werden.

#### Katapult's flashtool.py

```shell
python3 ./katapult/scripts/flashtool.py -i <CAN_IFACE> -u <UUID> -r
```

Dabei ist `<CAN_IFACE>` die zu verwendende CAN-Schnittstelle. Bei Verwendung von `can0` können sowohl `-i` als auch `<CAN_IFACE>` weggelassen werden.

`<UUID>` ist die UUID Ihres CAN-Geräts.

Informationen zum Ermitteln der CAN-UUID Ihrer Geräte finden Sie in der [CANBUS-Dokumentation](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers).

## Öffnen des Bootloaders

Empfängt Klipper eine der obigen Bootloader-Anfragen:

Ist Katapult (früher als CANBoot bekannt) verfügbar, fordert Klipper an, dass Katapult beim nächsten Start aktiv bleibt, und setzt anschließend den MCU zurück (wodurch Katapult aufgerufen wird).

Ist Katapult nicht verfügbar, versucht Klipper anschließend, einen plattformspezifischen Bootloader aufzurufen, etwa den DFU-Modus von STM32 ([siehe Hinweis](#stm32-dfu-warning)).

Kurz gesagt: Klipper startet, falls installiert, in Katapult neu, andernfalls in einen hardwarespezifischen Bootloader, sofern verfügbar.

Details zu den spezifischen Bootloadern der verschiedenen Plattformen finden Sie unter [Bootloaders](Bootloaders.md)

## Anmerkungen

### STM32 DFU Warnung

Beachten Sie, dass bei manchen Platinen, wie dem Octopus Pro v1, das Aufrufen des DFU-Modus unerwünschte Aktionen auslösen kann (z. B. das Einschalten der Heizung im DFU-Modus). Es wird empfohlen, Heizungen zu trennen und andere unerwünschte Vorgänge zu verhindern, wenn der DFU-Modus verwendet wird. Weitere Details finden Sie in der Dokumentation Ihrer Platine.
