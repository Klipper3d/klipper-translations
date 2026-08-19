# Въвеждане на буутлоудъра

Klipper може да бъде инструктиран да рестартира в [Bootloader](Bootloaders.md) по един от следните начини:

## Запитване за буутлоудър

### Виртуален сериен

Ако се използва виртуален (USB-ACM) сериен порт, импулсирането на DTR при скорост 1200 бода ще изиска зареждане.

#### Python (with `flash_usb`)

Влизане в буутлоудъра с помощта на питон (чрез `flash_usb`):

```shell
> cd klipper/scripts
> python3 -c 'import flash_usb as u; u.enter_bootloader("<DEVICE>")'
Entering bootloader on <DEVICE>
```

Където `<DEVICE>` е вашето серийно устройство, например `/dev/serial.by-id/usb-Klipper[...]` или `/dev/ttyACM0`.

Обърнете внимание, че при неуспех няма да бъде отпечатан никакъв изход, а успехът се индикира с отпечатването на `Entering bootloader on <DEVICE>`.

#### Picocom

```shell
picocom -b 1200 <DEVICE>
<Ctrl-A><Ctrl-P>
```

Където `<DEVICE>` е вашето серийно устройство, например `/dev/serial.by-id/usb-Klipper[...]` или `/dev/ttyACM0`.

````<Ctrl-A><Ctrl-P>` означава задържане на `Ctrl`, натискане и освобождаване на `a`, натискане и освобождаване на `p`, след което освобождаване на `Ctrl`

### Физическа серия

If a physical serial port is being used on the MCU (even if a USB serial adapter is being used to connect to it), sending the string `<SPACE><FS><SPACE>Request Serial Bootloader!!<SPACE>~` requests the bootloader.

`<SPACE>` е буквален интервал ASCII, 0x20.

`<FS>` е ASCII файловият разделител, 0x1c.

Имайте предвид, че това не е валидно съобщение съгласно [MCU Protocol](Protocol.md#micro-controller-interface), но символите за синхронизация (`~``) все още се спазват.

Тъй като това съобщение трябва да бъде единственото в "блока", в който е получено, добавянето на допълнителен символ за синхронизация може да повиши надеждността, ако преди това други инструменти са имали достъп до серийния порт.

#### Shell

```shell
stty <BAUD> < /dev/<DEVICE>
echo $'~ \x1c Request Serial Bootloader!! ~' >> /dev/<DEVICE>
```

Където `<DEVICE>` е вашият сериен порт, например `/dev/ttyS0` или `/dev/serial/by-id/gpio-serial2`, и

`<BAUD>` е скоростта на предаване на серийния порт, например `115200`.

### CANBUS

Ако се използва CANBUS, специално съобщение [admin message](CANBUS_protocol.md#admin-messages) ще поиска зареждането на системата. Това съобщение ще бъде спазено, дори ако устройството вече има nodeid, и ще бъде обработено и ако mcu е изключен.

Този метод се прилага и за устройства, работещи в режим [CANBridge](CANBUS.md#usb-to-can-bus-bridge-mode).

#### Katapult's flashtool.py

```shell
python3 ./katapult/scripts/flashtool.py -i <CAN_IFACE> -u <UUID> -r
```

Където `<CAN_IFACE>` е интерфейсът на кутията, който трябва да се използва. Ако се използва `can0`, може да се пропуснат както `-i`, така и `<CAN_IFACE>`.

`<UUID>` е UUID на вашето CAN устройство.

Вижте документацията [CANBUS Documentation](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) за информация относно намирането на CAN UUID на вашите устройства.

## Влизане в буутлоудъра

Когато klipper получи една от горните заявки от bootloader:

Ако е наличен Katapult (по-рано известен като CANBoot), klipper ще поиска Katapult да остане активен при следващото зареждане, след което ще нулира MCU (следователно ще влезе в Katapult).

Ако Katapult не е наличен, klipper ще се опита да влезе в специфичен за платформата буутлоудър, като например DFU режима на STM32([вж. бележка](#stm32-dfu-warning)).

Накратко, Klipper ще рестартира в Katapult, ако е инсталиран, а след това в специфичен за хардуера буутлоудър, ако има такъв.

За подробности относно специфичните буутлоудъри за различните платформи вижте [Bootloaders](Bootloaders.md)

## Бележки

### Предупреждение за STM32 DFU

Обърнете внимание, че при някои платки, като Octopus Pro v1, влизането в режим DFU може да доведе до нежелани действия (например включване на нагревателя, докато сте в режим DFU). Препоръчително е да изключвате нагревателите и по друг начин да предотвратявате нежелани действия, когато използвате режим DFU. За повече подробности се обърнете към документацията за вашата платка.
