# Entrée du bootloader

Klipper redémarrer dans un [Bootloader](Bootloaders.md) de l'une des manières suivantes :

## Demande du bootloader

### Série virtuel

If a virtual (USB-ACM) serial port is in use, pulsing DTR while at 1200 baud will request the bootloader.

#### Python (with `flash_usb`)

Pour accéder au bootloader en utilisant python (en utilisant `flash_usb`) :

```shell
> cd klipper/scripts
> python3 -c 'import flash_usb as u; u.enter_bootloader("<DEVICE>")'
Entering bootloader on <DEVICE>
```

Où `<DEVICE>` est votre périphérique série, tel que `/dev/serial.by-id/usb-Klipper[...]` ou `/dev/ttyACM0`

Notez que si cela échoue, rien ne sera affiché, une opération réussie est indiqué en affichant `Entering bootloader on <DEVICE>`.

#### Picocom

```shell
picocom -b 1200 <DEVICE>
<Ctrl-A><Ctrl-P>
```

Où `<DEVICE>` est votre périphérique série, tel que `/dev/serial.by-id/usb-Klipper[...]` ou `/dev/ttyACM0`

`<Ctrl-A><Ctrl-P>` means holding `Ctrl`, pressing and releasing `a`, pressing and releasing `p`, then releasing `Ctrl`

### Série physique

If a physical serial port is being used on the MCU (even if a USB serial adapter is being used to connect to it), sending the string `<SPACE><FS><SPACE>Request Serial Bootloader!!<SPACE>~`.

`<SPACE>` is an ASCII literal space, 0x20.

`<FS>` is the ASCII File Separator, 0x1c.

Note that this is not a valid message as per the [MCU Protocol](Protocol.md#micro-controller-interface), but sync characters(`~`) are still respected.

Because this message must be the only thing in the "block" it is received in, prefixing an extra sync character can increase reliability if other tools were previously accessing the serial port.

#### Shell

```shell
stty <BAUD> < /dev/<DEVICE>
echo $'~ \x1c Request Serial Bootloader!! ~' >> /dev/<DEVICE>
```

Where `<DEVICE>` is your serial port, such as `/dev/ttyS0`, or `/dev/serial/by-id/gpio-serial2`, and

`<BAUD>` is the baud rate of the serial port, such as `115200`.

### BUS CAN

If CANBUS is in use, a special [admin message](CANBUS_protocol.md#admin-messages) will request the bootloader. This message will be respected even if the device already has a nodeid, and will also be processed if the mcu is shutdown.

This method also applies to devices operating in [CANBridge](CANBUS.md#usb-to-can-bus-bridge-mode) mode.

#### Katapult's flashtool.py

```shell
python3 ./katapult/scripts/flashtool.py -i <CAN_IFACE> -u <UUID> -r
```

Where `<CAN_IFACE>` is the can interface to use. If using `can0`, both the `-i` and `<CAN_IFACE>` may be omitted.

`<UUID>` is the UUID of your CAN device.

See the [CANBUS Documentation](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) for information on finding the CAN UUID of your devices.

## Entering the bootloader

When klipper receives one of the above bootloader requests:

If Katapult (formerly known as CANBoot) is available, klipper will request that Katapult stay active on the next boot, then reset the MCU (therefore entering Katapult).

If Katapult is not available, klipper will then try to enter a platform-specific bootloader, such as STM32's DFU mode([see note](#stm32-dfu-warning)).

In short, Klipper will reboot to Katapult if installed, then a hardware specific bootloader if available.

For details about the specific bootloaders on various platforms see [Bootloaders](Bootloaders.md)

## Notes

### STM32 DFU Warning

Note that on some boards, like the Octopus Pro v1, entering DFU mode can cause undesired actions (such as powering the heater while in DFU mode). It is recommended to disconnect heaters, and otherwise prevent undesired operations when using DFU mode. Consult the documentation for your board for more details.
