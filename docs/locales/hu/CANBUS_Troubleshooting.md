# CANBUS Hibaelhárítás

Ez a dokumentum információt ad a hibaelhárítás kommunikációs problémáiról a [Klipper és CAN bus](CANBUS.md) használatakor.

## CAN-busz vezetékek ellenőrzése

A kommunikációs problémák hibaelhárításának első lépése a CAN-busz vezetékeinek ellenőrzése.

Be sure there are exactly two 120 Ohm [terminating
resistors](CANBUS.md#terminating-resistors) on the CAN bus. If the resistors are not properly installed then messages may not be able to be sent at all or the connection may have sporadic instability.

A CANH és a CANL buszvezetékeknek csavart érpároknak kell lennie. Vagy legalább pár centiméterenként csavarni kell az érpárokat. Kerüld el a CANH és a CANL vezetékek erős áramú vezetékekkel való kapcsolatát. Kerüld el és biztosítsd, hogy az erős áramú vezetékek, amelyek párhuzamosan futnak a CANH és a CANL vezetékekkel ne rendelkeznek azonos mennyiségű érpár csavarással.

Ellenőrizd, hogy a CAN-busz kábelezésén lévő összes csatlakozó és vezetékrögzítő jól van rögzítve. A nyomtatófej mozgása megrázhatja a CAN-busz vezetékeit, ami egy rosszul rögzített vagy rögzítetlen csatlakozó miatt időszakos kommunikációs hibákat okozhat.

## A bytes_invalid számláló növelésének ellenőrzése

A Klipper naplófájl másodpercenként egyszer jelent egy `Stats` sort, amikor a nyomtató aktív. Ezek a "Stats" sorok minden mikrokontroller esetében tartalmaznak egy `bytes_invalid` számlálót. Ennek a számlálónak nem szabad növekednie a nyomtató normál működése során (normális, hogy a számláló nem nulla az újraindítás után, és nem jelent gondot, ha a számláló havonta egyszer növekszik). Ha ez a számláló egy CAN-buszos mikrovezérlőn normál nyomtatás közben növekszik (néhány óránként vagy gyakrabban), akkor az súlyos problémára utal.

Incrementing `bytes_invalid` on a CAN bus connection is a symptom of reordered messages on the CAN bus. If seen, make sure to:

* Use a Linux kernel version 6.6.0 or later.
* If using a USB-to-CANBUS adapter running candlelight firmware, use v2.0 or later of candleLight_fw.
* If using Klipper's USB-to-CANBUS bridge mode, make sure the bridge node is flashed with Klipper v0.12.0 or later.

Reordered messages is a severe problem that must be fixed. It will result in unstable behavior and can lead to confusing errors at any part of a print. An incrementing `bytes_invalid` is not caused by wiring or similar hardware issues and can only be fixed by identifying and updating the faulty software.

Older versions of the Linux kernel had a bug in the gs_usb canbus driver code that could cause reordered canbus packets. The issue is thought to be fixed in [Linux commit 24bc41b4](https://github.com/torvalds/linux/commit/24bc41b4558347672a3db61009c339b1f5692169) which was released in v6.6.0. In some cases, older Linux versions may not show the problem (due to how hardware interrupts are configured), however if problems are seen the recommended solution is to upgrade to a newer kernel.

Older versions of candlelight firmware could reorder canbus packets, and the issue is thought to be fixed in [candlelight_fw commit 8b3a7b45](https://github.com/candle-usb/candleLight_fw/commit/8b3a7b4565a3c9521b762b154c94c72c5acb2bcf).

Older versions of Klipper's USB-to-CANBUS bridge code could incorrectly drop canbus messages. This is not as severe as reordering messages, but it should still be fixed. It is thought to be fixed with [Klipper PR #6175](https://github.com/Klipper3d/klipper/pull/6175).

## Használj megfelelő txqueuelen beállítást

A Klipper kód a Linux kernelt használja a CAN-busz forgalom kezelésére. Alapértelmezés szerint a kernel csak 10 CAN átviteli csomagot állít sorba. Ajánlott [a can0 eszköz konfigurálása](CANBUS.md#host-hardware) `txqueuelen 128`-val, hogy növeld ezt a méretet.

Ha a Klipper továbbít egy csomagot, és a Linux betöltötte az összes átviteli várólistát, akkor a Linux eldobja a csomagot, és a Klipper naplójában a következő üzenetek jelennek meg:

```
Hiba -1 CAN írásban: (105)Nincs szabad pufferterület
```

A Klipper automatikusan továbbítja az elveszett üzeneteket a normál alkalmazásszintű üzenetek újraküldési rendszerének részeként. Ez a naplóüzenet tehát figyelmeztetés, és nem jelez helyrehozhatatlan hibát.

Ha a CAN-busz teljes meghibásodása következik be (pl. CAN vezetékszakadás), akkor a Linux nem tud üzeneteket továbbítani a CAN-buszon, és a Klipper naplójában gyakran megjelenik a fenti üzenet. Ebben az esetben a naplóüzenet egy nagyobb probléma (az üzenetek továbbításának képtelensége) tünete, és nem kapcsolódik közvetlenül a Linux `txqueuelen`-hez.

Az aktuális várólista méretét a Linux `ip link show can0` parancs futtatásával ellenőrizhetjük. A parancsnak egy csomó szöveget kell kiírnia, köztük a `qlen 128` szalagot. Ha valami olyasmit látunk, mint `qlen 10`, akkor az azt jelzi, hogy a CAN-eszköz nincs megfelelően konfigurálva.

Nem ajánlott 128-nál lényegesen nagyobb `txqueuelen` értéket használni. Egy 1000000-ós frekvencián futó CAN-buszon egy CAN-csomag továbbítása általában körülbelül 120 másodpercig tart. Így egy 128 csomagból álló sor valószínűleg 15-20 ms-ig tart, amíg a sor kiürül. Egy lényegesen nagyobb várólista az üzenetek átfutási idejében túlzott kiugrásokat okozhat, ami helyrehozhatatlan hibákhoz vezethet. Másképp fogalmazva, a Klipper alkalmazás újraküldési rendszere robusztusabb, ha nem kell megvárnia, hogy a Linuxnak ki kelljen ürítenie egy túl nagy, esetleg elavult adatokat tartalmazó várólistát. Ez analóg a [bufferbloat](https://en.wikipedia.org/wiki/Bufferbloat) problémájával az internetes útválasztókon.

Normál körülmények között a Klipper MCU-nként ~25 várólistahelyet használhat - jellemzően csak az újratovábbítások során használ több helyet. (Konkrétan, a Klipper gazdagép legfeljebb 192 bájtot küldhet minden Klipper MCU-nak, mielőtt nyugtát kapna az adott MCU-tól). Ha egy CAN-buszon 5 vagy több Klipper MCU van, akkor szükséges lehet a `txqueuelen` értéket a 128-as ajánlott érték fölé emelni. A fentiekhez hasonlóan azonban az új érték kiválasztásakor óvatosan kell eljárni, hogy elkerülhető legyen a túlzott körutazási késleltetés.

## Use `canbus_query.py` only to identify nodes never previously seen

It is only valid to use the [`canbus_query.py` tool](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) to identify micro-controllers that have never been previously identified. Once all nodes on a bus are identified, record the resulting uuids in the printer.cfg, and avoid running the tool unnecessarily.

The tool is implemented using a low-level mechanism that can cause nodes to internally observe bus errors. These internal errors may result in communication interruptions and may result is some nodes disconnecting from the bus.

It is not valid to use the tool to "ping" if a node is connected. Do not run the tool during an active print.

## Candump naplók beszerzése

A mikrokontrollerhez küldött és onnan érkező CAN-busz üzeneteket a Linux kernel kezeli. Lehetőség van arra, hogy ezeket az üzeneteket a kernelből hibakeresés céljából rögzítsük. Ezen üzenetek naplózása hasznos lehet a diagnosztikában.

A Linux [can-utils](https://github.com/linux-can/can-utils) eszköz biztosítja a rögzítő szoftvert. Ezt általában a következő futtatásával telepíthetjük a gépre:

```
sudo apt-get update && sudo apt-get install can-utils
```

A telepítés után a következő paranccsal az összes CAN-busz üzenetet rögzíthetjük egy interfészen:

```
candump -tz -Ddex can0,#FFFFFFFF > mycanlog
```

A kapott naplófájlban (a fenti példában a `mycanlog`) megtekinthetjük a Klipper által küldött és fogadott minden egyes nyers CAN-busz üzenetet. Ezen üzenetek tartalmának megértéséhez valószínűleg a Klipper [CANBUS protokoll](CANBUS_protocol.md) és a Klipper [MCU parancsok](MCU_Commands.md) alacsony szintű ismerete szükséges.

### Klipper üzenetek elemzése a candump naplóban

A `parsecandump.py` eszközt használhatjuk a candump naplóban található alacsony szintű Klipper mikrokontroller üzenetek elemzésére. Ennek az eszköznek a használata haladó témakör, amelyhez a Klipper [MCU parancsok](MCU_Commands.md) ismerete szükséges. Például:

```
./scripts/parsecandump.py mycanlog 108 ./out/klipper.dict
```

This tool produces output similar to the [parsedump
tool](Debugging.md#translating-gcode-files-to-micro-controller-commands). See the documentation for that tool for information on generating the Klipper micro-controller data dictionary.

In the above example, `108` is the [CAN bus
id](CANBUS_protocol.md#micro-controller-id-assignment). It is a hexadecimal number. The id `108` is assigned by Klipper to the first micro-controller. If the CAN bus has multiple micro-controllers on it, then the second micro-controller would be `10a`, the third would be `10c`, and so on.

A candump naplót a `-tz -Ddex` parancssori argumentummal kell létrehozni (például: `candump -tz -Ddex can0,#FFFFFFFFFFFF`) a `parsecandump.py` eszköz használatához.

## Logikai analizátor használata a canbus kábelezésen

A [Sigrok Pulseview](https://sigrok.org/wiki/PulseView) szoftver egy olcsó [logikai analizátorral](https://en.wikipedia.org/wiki/Logic_analyzer) együtt hasznos lehet a CAN-busz jelátvitelének diagnosztizálásához. Ez egy haladó téma, amely valószínűleg csak a szakértők számára érdekes.

Gyakran találhatunk "USB logikai analizátorokat" 15 dollár alatti áron (amerikai árképzés 2023-tól). Ezek az eszközök gyakran "Saleae logic clones" vagy "24MHz-es 8 csatornás USB logikai analizátorok" néven szerepelnek.

![pulseview-canbus](img/pulseview-canbus.png)

A fenti kép a Pulseview használata közben készült egy "Saleae klón" logikai analizátorral. A Sigrok és a Pulseview szoftver egy asztali gépre lett telepítve (telepítsd az "fx2lafw" firmware-t is, ha az külön csomagban van). A logikai analizátor CH0 tűjét a CAN Rx tűre, a CH1 tűt a CAN Tx tűre, a GND-t pedig a GND-re vezettük. A Pulseview-t úgy konfiguráltuk, hogy csak a D0 és D1 vonalakat jelenítse meg (piros "szonda" ikon középső felső eszköztár). A minták számát 5 millióra (felső eszköztár), a mintavételi sebességet pedig 24Mhz-re (felső eszköztár) állítottuk be. A CAN dekódert hozzáadtuk (sárga és zöld "buborék ikon" jobb felső eszköztár). A D0 csatornát RX-ként jelöltük meg, és úgy állítottuk be, hogy csökkenő élre triggereljen (kattintsunk a bal oldali fekete D0 címkére). A D1 csatornát TX-ként jelöltük (kattintsunk a bal oldali barna D1 címkére). A CAN dekódert 1Mbit sebességre konfiguráltuk (kattints a bal oldali zöld CAN címkére). A CAN dekóder a kijelző tetejére került (kattints és húzd a zöld CAN címkét). Végül elindítottuk a rögzítést (kattintsunk a bal felső sarokban lévő "Run" gombra), és egy csomagot továbbítottunk a CAN-buszon (`cansend can0 123#121212121212`).

A logikai analizátor független eszközt biztosít a csomagok rögzítéséhez és a bitek időzítésének ellenőrzéséhez.
