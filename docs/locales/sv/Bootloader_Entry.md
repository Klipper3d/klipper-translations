# Starta startladdaren

Klipper kan instrueras att starta om till en [startladdare](Bootloaders.md) på ett av följande sätt:

## Begära startladdaren

### Virtuell seriell port

Om en virtuell seriell USB-ACM-port används begärs startladdaren genom en DTR-puls vid 1200 baud.

#### Python (med `flash_usb`)

Starta startladdaren med Python och `flash_usb` så här:

```shell
> cd klipper/scripts
> python3 -c 'import flash_usb as u; u.enter_bootloader("<DEVICE>")'
Entering bootloader on <DEVICE>
```

Där `<DEVICE>` är den seriella enheten, till exempel `/dev/serial.by-id/usb-Klipper[...]` eller `/dev/ttyACM0`

Observera att ingenting skrivs ut om detta misslyckas. En lyckad åtgärd indikeras av `Entering bootloader on <DEVICE>`.

#### Picocom

```shell
picocom -b 1200 <DEVICE>
<Ctrl-A><Ctrl-P>
```

Där `<DEVICE>` är den seriella enheten, till exempel `/dev/serial.by-id/usb-Klipper[...]` eller `/dev/ttyACM0`

`<Ctrl-A><Ctrl-P>` betyder att du håller ned `Ctrl`, trycker ned och släpper `a`, trycker ned och släpper `p` och sedan släpper `Ctrl`

### Fysisk seriell port

Om en fysisk seriell port används på MCU:n, även om en USB-serieadapter används för anslutningen, begär strängen `<SPACE><FS><SPACE>Request Serial Bootloader!!<SPACE>~` startladdaren.

`<SPACE>` är ett bokstavligt ASCII-mellanslag, 0x20.

`<FS>` är ASCII-tecknet File Separator, 0x1c.

Observera att detta inte är ett giltigt meddelande enligt [MCU-protokollet](Protocol.md#micro-controller-interface), men synktecken (`~`) respekteras ändå.

Eftersom meddelandet måste vara det enda i det block där det tas emot kan ett extra synktecken som prefix öka tillförlitligheten om andra verktyg tidigare har använt den seriella porten.

#### Skal

```shell
stty <BAUD> < /dev/<DEVICE>
echo $'~ \x1c Request Serial Bootloader!! ~' >> /dev/<DEVICE>
```

Där `<DEVICE>` är den seriella porten, till exempel `/dev/ttyS0` eller `/dev/serial/by-id/gpio-serial2`, och

`<BAUD>` är överföringshastigheten för den seriella porten, till exempel `115200`.

### CANBUS

Om CANBUS används begär ett särskilt [administrationsmeddelande](CANBUS_protocol.md#admin-messages) startladdaren. Meddelandet respekteras även om enheten redan har ett nodeid och behandlas också om MCU:n är avstängd.

Metoden gäller även enheter som körs i läget [CANBridge](CANBUS.md#usb-to-can-bus-bridge-mode).

#### Katapults flashtool.py

```shell
python3 ./katapult/scripts/flashtool.py -i <CAN_IFACE> -u <UUID> -r
```

Där `<CAN_IFACE>` är CAN-gränssnittet som ska användas. Om `can0` används kan både `-i` och `<CAN_IFACE>` utelämnas.

`<UUID>` är UUID:t för CAN-enheten.

Se [CANBUS-dokumentationen](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) för information om hur du hittar enheternas CAN-UUID.

## Starta startladdaren

När Klipper tar emot någon av startladdningsbegärandena ovan:

Om Katapult, tidigare CANBoot, är tillgänglig begär Klipper att Katapult förblir aktiv vid nästa uppstart och återställer sedan MCU:n, vilket startar Katapult.

Om Katapult inte är tillgänglig försöker Klipper starta en plattformsspecifik startladdare, till exempel STM32:s DFU-läge (se [anmärkningen](#stm32-dfu-warning)).

Kort sagt startar Klipper om till Katapult om den är installerad, annars till en maskinvaruspecifik startladdare om en sådan finns.

Information om de specifika startladdarna för olika plattformar finns i [Startladdare](Bootloaders.md)

## Anmärkningar

### Varning för STM32 DFU

Observera att på vissa kort, som Octopus Pro v1, kan DFU-läget orsaka oönskade åtgärder, till exempel att värmaren får ström. Vi rekommenderar att koppla från värmarna och i övrigt förhindra oönskade åtgärder vid användning av DFU-läge. Läs dokumentationen för kortet för mer information.
