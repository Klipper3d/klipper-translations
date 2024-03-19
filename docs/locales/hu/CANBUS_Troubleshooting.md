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

A `bytes_invalid` növekedése egy CAN-busz kapcsolaton a CAN-buszon lévő átrendezett üzenetek tünete. Az újrarendezett üzeneteknek két ismert oka van:

1. Az USB CAN-adapterek népszerű candlight_firmware-jének régi verzióiban volt egy hiba, amely átrendezett üzeneteket okozhatott. Ha ilyen firmware-t futtató USB CAN adaptert használsz, akkor mindenképpen frissítsd a legújabb firmware-re, ha a `bytes_invalid` növekedését észleled.
1. Néhány beágyazott eszközökhöz készült Linux kernelről ismert, hogy átrendezi a CAN-busz üzeneteket. Szükség lehet egy alternatív Linux kernel használatára, vagy olyan alternatív hardverek használatára, amelyek támogatják a mainstream Linux kerneleket, amelyek nem mutatják ezt a problémát.

Az átrendezett üzenetek súlyos problémát jelentenek, amelyet orvosolni kell. Ez instabil viselkedést eredményez, és zavaró hibákhoz vezethet a nyomtatás bármelyik részénél.

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
