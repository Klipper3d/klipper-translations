# Bootloader belépés

Klipper utasítható, hogy újraindítsa a [Bootloadert](Bootloaders.md) az alábbi módok egyikében:

## A bootloader kérése

### Virtuális sorozat

Ha virtuális (USB-ACM) soros port van használatban, a DTR pulzálása 1200 baud mellett kéri a rendszerbetöltőt.

#### Python (with `flash_usb`)

Belépés a bootloader-be python segítségével (using `flash_usb`):

```shell
> cd klipper/scripts
> python3 -c 'import flash_usb as u; u.enter_bootloader("<DEVICE>")'
Bootloader belépése a <DEVICE> rendszeren
```

Ahol `<DEVICE>` a soros eszköz, például `/dev/serial.by-id/usb-Klipper[...]` vagy `/dev/ttyACM0`

Vedd figyelembe, hogy ha ez nem sikerül, nem jelenik meg a kimenet, a sikert az `Entering bootloader on <DEVICE>` kiírása jelzi.

#### Picocom

```shell
picocom -b 1200 <DEVICE>
<Ctrl-A><Ctrl-P>
```

Ahol `<DEVICE>` a soros eszköz, például `/dev/serial.by-id/usb-Klipper[...]` vagy `/dev/ttyACM0`

`<Ctrl-A><Ctrl-P>` azt jelenti, hogy lenyomva tartjuk a "Ctrl"-t, megnyomjuk és elengedjük az "a"-t, megnyomjuk és elengedjük a "p"-t, majd elengedjük a "Ctrl"-t

### Fizikai sorszám

Ha az MCU-n fizikai soros portot használunk (még akkor is, ha USB soros adaptert használunk a csatlakozáshoz), akkor a `<SPACE><FS><SPACE>Request Serial Bootloader!!<SPACE>~` karakterlánc elküldése szükséges.

A `<SPACE>` egy ASCII szóköz, 0x20.

A `<FS>` az ASCII fájlelválasztó, 0x1c.

Vedd figyelembe, hogy ez nem érvényes üzenet az [MCU protokoll](Protocol.md#micro-controller-interface) szerint, de a szinkronizáló karaktereket (`~`) továbbra is tiszteletben kell tartani.

Mivel ennek az üzenetnek kell lennie az egyetlen dolognak abban a "blokkban", amelyben érkezik, egy extra szinkronizáló karakter előtaggal növelheted a megbízhatóságot, ha korábban más eszközök is hozzáfértek a soros porthoz.

#### Parancsértelmező

```shell
stty <BAUD> < /dev/<DEVICE>
echo $'~ \x1c Request Serial Bootloader!! ~' >> /dev/<DEVICE>
```

Ahol `<DEVICE>` a Te soros portod, például `/dev/ttyS0`, vagy `/dev/serial/by-id/gpio-serial2` és

`<BAUD>` a soros port buszsebessége, például `115200`.

### CANBUS

Ha a CANBUS használatban van, egy speciális [admin üzenet](CANBUS_protocol.md#admin-messages) kéri a bootloadert. Ezt az üzenetet akkor is figyelembe veszi, ha az eszköznek már van nodeid-ja, és akkor is feldolgozza, ha az MCU le van kapcsolva.

Ez a módszer a [CANBridge](CANBUS.md#usb-to-can-bus-bridge-mode) üzemmódban működő eszközökre is vonatkozik.

#### Katapult flashtool.py

```shell
python3 ./katapult/scripts/flashtool.py -i <CAN_IFACE> -u <UUID> -r
```

Ahol `<CAN_IFACE>` a használni kívánt can-interfész. Ha a `can0`-t használjuk, az `-i` és a `<CAN_IFACE>` is elhagyható.

A `<UUID>` a CAN-eszköz UUID-je.

Lásd a [CANBUS dokumentáció](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) című dokumentumot az eszközök CAN UUID-jének megtalálására vonatkozó információkért.

## Belépés a bootloaderbe

Amikor a klipper megkapja a fenti bootloader kérések egyikét:

Ha a Katapult (korábbi nevén CANBoot) elérhető, a klipper kérni fogja, hogy a Katapult maradjon aktív a következő indításkor, majd visszaállítja az MCU-t (ezért belép a Katapultba).

Ha a Katapult nem elérhető, akkor a klipper megpróbál egy platform-specifikus bootloaderbe belépni, például az STM32 DFU módjába([lásd megjegyzés](#stm32-dfu-warning)).

Röviden, a Klipper újraindítja a Katapultot, ha telepítve van, majd egy hardver-specifikus bootloadert, ha rendelkezésre áll.

A különböző platformok speciális bootloadereiről részletesen lásd [Bootloaderek](Bootloaders.md)

## Megjegyzések

### STM32 DFU Figyelmeztetés

Ne feledd, hogy néhány lapon, mint például az Octopus Pro v1, a DFU módba való belépés nem kívánt műveleteket okozhat (például a fűtőberendezés bekapcsolása DFU módban). Javasoljuk, hogy a DFU mód használatakor a fűtőberendezéseket kapcsold ki, és más módon akadályozd meg a nemkívánatos műveleteket. További részletekért olvasd el az alaplap dokumentációját.
