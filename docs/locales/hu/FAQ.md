# Gyakran ismételt kérdések

1. [Hogyan adományozhatok a projektnek?](#hogyan-adomanyozhatok-a-projektnek)
1. [Hogyan számíthatom ki a rotation_distance konfigurációs paramétert?](#hogyan-szamitom-ki-a-rotation_distance-konfiguracios-parametert)
1. [Hol van a soros portom?](#hol-van-a-soros-portom)
1. [Amikor a mikrokontroller újraindítja az eszközt /dev/ttyUSB1-re változik](#a-mikrokontroller-ujrainditasakor-az-eszkoz-devttyusb1-re-valtozik)
1. [A "make flash" parancs nem működik](#a-make-flash-parancs-nem-mukodik)
1. [Hogyan változtathatom meg a soros port átviteli sebességét?](#hogyan-valtoztathatom-meg-a-soros-port-sebesseget)
1. [Futtathatom a Klippert máson is, mint egy Raspberry Pi 3?](#futtathatom-a-klippert-a-raspberry-pi-3-on-kivul-mason-is)
1. [Futtathatom a Klipper több példányát ugyanazon a gépen?](#futtathatom-a-klipper-tobb-peldanyat-ugyanazon-a-gepen)
1. [Muszáj az OctoPrintet használnom?](#muszaj-az-octoprintet-hasznalnom)
1. [Miért nem tudom mozgatni a léptetőt a nyomtató indítása előtt?](#miert-nem-tudom-mozgatni-a-leptetomotort-a-nyomtato-beallitasa-elott)
1. [Miért van a Z position_endstop 0.5-re állítva az alapértelmezett konfigurációban?](#miert-van-a-z-position_endstop-05-re-allitva-az-alapertelmezett-konfiguracioban)
1. [Átkonvertáltam a konfigurációmat Marlinból, és az X/Y tengelyek jól működnek, de a Z tengely kezdőpont felvételekor csak egy csikorgó zajt hallok](#atkonvertaltam-a-marlinbol-szarmazo-konfiguraciomat-es-az-xy-tengelyek-jol-mukodnek-de-a-z-tengely-kezdopont-filvetelekor-csikorgo-hangot-hallok)
1. [A TMC motorvezérlő kikapcsol a nyomtatás közepén](#a-tmc-motorvezerlo-kikapcsol-a-nyomtatas-kozben)
1. [Véletlenszerű "Elveszett a kommunikáció az MCU-val" hibák](#folyamatosan-kapok-elveszett-a-kommunikacio-az-mcu-val-hibakat)
1. [A Raspberry Pi újraindul nyomtatás közben](#a-raspberry-pi-folyamatosan-ujraindul-nyomtatas-kozben)
1. [Amikor beállítom `restart_method=command` az AVR készülékem újraindításkor csak lefagy](#amikor-beallitom-a-restart_methodcommand-az-avr-keszulekem-ujrainditaskor-egyszeruen-lefagy)
1. [A fűtőelemek bekapcsolva maradnak, ha a Raspberry Pi összeomlik?](#a-futoelemek-bekapcsolva-maradnak-ha-a-raspberry-pi-osszeomlik)
1. [Hogyan konvertálhatok egy Marlin tűszámot egy Klipper tűnévre?](#hogyan-alakithatok-at-egy-marlin-tu-szamot-klipper-tu-nevre)
1. [Az eszközömet egy adott típusú mikrokontroller tűhöz kell csatlakoztatnom?](#az-eszkozomet-egy-adott-tipusu-mikrokontroller-tuhoz-kell-csatlakoztatnom)
1. [Hogyan tudom törölni az M109/M190 "várakozás a hőmérsékletre" kérést?](#hogyan-tudom-torolni-az-m109m190-homersekletre-varni-kerest)
1. [Megtudhatom, hogy a nyomtató vesztett-e lépéseket?](#meg-tudom-allapitani-hogy-a-nyomtato-vesztett-e-lepeseket)
1. [Miért jelent hibát a Klipper? Elrontotta a nyomtatásomat!](#miert-jelent-hibat-a-klipper-elrontotta-a-nyomtatasomat)
1. [Hogyan frissíthetek a legújabb szoftverre?](#hogyan-frissithetek-a-legujabb-szoftverre)
1. [Hogyan távolítsam el a klippert?](#hogyan-tudom-eltavolitani-a-klippert)

## Hogyan adományozhatok a projektnek?

Köszönöm. Kevinnek van egy Patreon oldala: <https://www.patreon.com/koconnor>

## Hogyan számítom ki a rotation_distance konfigurációs paramétert?

Lásd a [forgási távolság dokumentumot](Rotation_Distance.md).

## Hol van a soros portom?

Az USB soros port megtalálásának általános módja az `ls /dev/serial/by-id/*` futtatása a gazdaszámítógép SSH termináljáról. Valószínűleg a következőhöz hasonló kimenetet fog eredményezni:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

A fenti parancsban található név stabil, és használható a konfigurációs fájlban és a mikrokontroller kódjának égetése során. Egy égetés parancs például így nézhet ki:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

és a frissített konfiguráció így nézhet ki:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Ügyeljen arra, hogy a fent lefuttatott "ls" parancsból másolja be a nevet, mivel a név minden nyomtatónál más lesz.

Ha több mikrovezérlőt használsz, és ezek nem rendelkeznek egyedi azonosítóval (ez gyakori a CH340 USB-chippel ellátott lapokon), akkor kövesd a fenti utasításokat a `ls /dev/serial/by-path/*` parancs használatával.

## A mikrokontroller újraindításakor az eszköz /dev/ttyUSB1-re változik

Kövesse a "[Hol van a soros portom?](#hol-van-a-soros-portom)" szakaszban található utasításokat, hogy ezt megakadályozza.

## A "make flash" parancs nem működik

A kód megpróbálja az eszközt az egyes platformok esetében legelterjedtebb módszerrel égetni. Sajnos az égetési módszerek között nagy eltérések vannak, így a "make flash" parancs nem biztos, hogy minden lapon működik.

Ha időszakos hiba van, vagy szabványos beállításod van, akkor ellenőrizd, hogy a Klipper nem fut-e égetés közben (sudo service klipper stop), győződj meg róla, hogy az OctoPrint nem próbál közvetlenül az eszközhöz csatlakozni (nyisd meg a weblapon a Kapcsolat lapot, és kattints a Kapcsolat megszakítása gombra, ha a soros port az eszközhöz van beállítva), és győződj meg róla, hogy a FLASH_DEVICE helyesen van beállítva a lapodhoz (lásd a fenti [kérdést](#hol-van-a-soros-portom)).

Ha azonban a "make flash" egyszerűen nem működik az alaplapján, akkor manuálisan kell égetnie. Nézze meg, hogy van-e a [config könyvtárban](../config) egy config fájl, amely konkrét utasításokat tartalmaz az eszköz égetésére. Ellenőrizze a kártya gyártójának dokumentációját is, hogy leírja-e, hogyan kell égetni az eszközt. Végül, lehetséges lehet, hogy manuálisan égessük az eszközt olyan eszközökkel, mint az "avrdude" vagy a "bossac" - további információkért lásd a [bootloader dokumentumot](Bootloaders.md).

## Hogyan változtathatom meg a soros port sebességét?

A Klipper ajánlott átviteli sebessége 250000. Ez az átviteli ráta jól működik minden olyan mikrokontroller kártyán, amelyet a Klipper támogat. Ha talált egy online útmutatót, amely más átviteli sebességet javasol, akkor hagyja figyelmen kívül az útmutatónak ezt a részét, és folytassa az alapértelmezett 250000 értékkel.

Ha mindenképpen meg akarja változtatni az átviteli sebességet, akkor az új sebességet a mikrokontrollerben kell beállítani (a **make menuconfig** alatt), és a frissített kódot le kell fordítani és be kell égetni a mikrokontrollerbe. A Klipper printer.cfg fájlt is frissíteni kell, hogy megfeleljen ennek az átviteli sebességnek (lásd a [konfigurációs hivatkozást](Config_Reference.md#mcu) a részleteket). Például:

```
[mcu]
baud: 250000
```

Az OctoPrint weboldalon feltüntetett átviteli sebesség nincs hatással a Klipper mikrokontroller belső átviteli sebességére. Klipper használatakor az OctoPrint átviteli sebességét mindig 250000-re állítsa be.

A Klipper mikrovezérlő átviteli sebessége nem függ a mikrovezérlő bootloader átviteli sebességétől. A [bootloader dokumentum](Bootloaders.md) további információkat tartalmaz a bootloaderekkel kapcsolatban.

## Futtathatom a Klippert a Raspberry Pi 3-on kívül máson is?

Az ajánlott hardver egy Raspberry Pi 2, Raspberry Pi 3 vagy Raspberry Pi 4.

A Klipper fut a Raspberry Pi 1-en és a Raspberry Pi Zero-n, de ezek a lapok nem tartalmaznak elegendő feldolgozási teljesítményt az OctoPrint jó futtatásához. Gyakori, hogy ezeken a lassabb gépeken a nyomtatás akadozik, amikor közvetlenül az OctoPrintből nyomtat. (Előfordulhat, hogy a nyomtató gyorsabban mozog, mint ahogy az OctoPrint a mozgásparancsokat el tudja küldeni.) Ha mindenképpen ezek közül a lassabb lapok közül valamelyiken szeretne futni, fontolja meg a "virtual_sdcard" funkció használatát nyomtatáskor (a részletekért lásd [konfigurációs hivatkozást](Config_Reference.md#virtual_sdcard)).

A Beaglebone-on való futtatáshoz lásd a [Beaglebone-specifikus telepítési utasításokat](Beaglebone.md).

A Klipper más gépeken is futott. A Klipper gazdagép szoftverhez csak Python szükséges, amely Linux (vagy hasonló) számítógépen fut. Ha azonban más gépen szeretné futtatni, akkor Linux adminisztrátori ismeretekre lesz szüksége az adott gép rendszerkövetelményeinek telepítéséhez. A szükséges Linux-adminisztrátori lépésekről további információt az [install-octopi.sh](../scripts/install-octopi.sh) szkriptben talál.

Ha a Klipper gazdagép szoftvert egy low-end chipen szeretné futtatni, akkor vegye figyelembe, hogy legalább egy "dupla pontosságú lebegőpontos" hardverrel rendelkező gépre van szükség.

Ha a Klipper gazdagép szoftvert egy megosztott általános célú asztali vagy szerver osztályú gépen szeretné futtatni, akkor vegye figyelembe, hogy a Klippernek vannak bizonyos valós idejű ütemezési követelményei. Ha a nyomtatás során a gazdaszámítógép egyidejűleg intenzív általános célú számítási feladatot is végez (például merevlemez defragmentálása, 3D renderelés, nagymértékű swapolás stb.), akkor a Klipper nyomtatási hibákat jelenthet.

Megjegyzés: Ha nem OctoPi-képet használsz, vedd figyelembe, hogy számos Linux-disztribúció engedélyez egy "ModemManager" (vagy hasonló) csomagot, amely megzavarhatja a soros kommunikációt. (Ami miatt a Klipper véletlenszerűnek tűnő "Elveszett a kommunikáció az MCU-val" hibákat jelenthet.) Ha a Klippert ilyen disztribúcióra telepíti, akkor lehet, hogy le kell tiltania ezt a csomagot.

## Futtathatom a Klipper több példányát ugyanazon a gépen?

Lehetséges a Klipper gazdagép szoftver több példányának futtatása, de ehhez Linux adminisztrátori ismeretekre van szükség. A Klipper telepítési szkriptek végül a következő Unix parancs futtatását eredményezik:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

A fenti parancs több példányban is futtatható, amennyiben minden példánynak saját nyomtató-konfigurációs fájlja, saját naplófájlja és saját pszeudo-tty-je van. Például:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

Ha ezt választja, akkor a szükséges indítási, leállítási és telepítési parancsfájlokat (ha vannak ilyenek) kell végrehajtania. Az [install-octopi.sh](../scripts/install-octopi.sh) szkript és a [klipper-start.sh](../scripts/klipper-start.sh) szkript hasznos lehet példaként.

## Muszáj az OctoPrintet használnom?

A Klipper szoftver nem függ az OctoPrint-től. Lehetséges alternatív szoftvereket használni a Klipper parancsok küldésére, de ehhez Linux adminisztrátori ismeretekre van szükség.

A Klipper létrehoz egy "virtuális soros portot" a "/tmp/printer" fájlon keresztül, és ezen keresztül emulál egy klasszikus 3D nyomtató soros interfészt. Általánosságban elmondható, hogy alternatív szoftverek is működhetnek a Klipperrel, amennyiben konfigurálhatóak úgy, hogy a "/tmp/printer" -t használják a nyomtató soros portjaként.

## Miért nem tudom mozgatni a léptetőmotort a nyomtató beállítása előtt?

A kód ezt azért teszi, hogy csökkentse annak esélyét, hogy a fejet véletlenül az ágyba vagy a falba ütköztesse. Miután a nyomtató kezdőponthoz ért, a szoftver megpróbálja ellenőrizni, hogy minden egyes mozgás a konfigurációs fájlban meghatározott position_min/max értéken belül van-e. Ha a motorok ki vannak kapcsolva (M84 vagy M18 parancs segítségével), akkor a motorokat a mozgás előtt újra be kell állítani.

Ha a fejet az OctoPrint segítségével történő nyomtatás törlése után szeretné elmozdítani, fontolja meg az OctoPrint törlési sorrendjének módosítását, hogy ezt megtegye Ön helyett. Ez az OctoPrintben a webböngészőn keresztül konfigurálható a következő menüpont alatt: Beállítások->GCODE szkriptek

Ha a nyomtatás befejezése után szeretné mozgatni a fejet, fontolja meg a kívánt mozgás hozzáadását a szeletelő "custom g-code" szakaszához.

Ha a nyomtatónak szüksége van további mozgatásra a kezdőpont felvételi folyamat részeként (vagy alapvetően nincs kezdőpont felvételi folyamat), akkor fontolja meg a safe_z_home vagy homing_override szakasz használatát a konfigurációs fájlban. Ha diagnosztikai vagy hibakeresési célokra kell mozgatni egy léptetőmotort, akkor fontolja meg egy force_move szakasz hozzáadását a konfigurációs fájlhoz. Lásd [konfigurációs hivatkozást](Config_Reference.md#testreszabott-kezdopont-felvetel) az ezen opciókkal kapcsolatos további részletekért.

## Miért van a Z position_endstop 0,5-re állítva az alapértelmezett konfigurációban?

A cartesian stílusú nyomtatók esetében a Z position_endstop megadja, hogy a fúvóka milyen messze van az ágytól, amikor a végállás működésbe lép. Ha lehetséges, ajánlott Z-max végállást használni, és az ágytól távolabb elhelyezni (mivel ez csökkenti az ágy ütközés lehetőségét). Ha azonban az ágy felé kell elindulni, akkor a végállást úgy kell beállítani, hogy akkor lépjen működésbe, amikor a fúvóka még mindig kis távolságra van az ágytól. Így a tengely homingolásakor a fúvóka még azelőtt megáll, hogy a fúvóka hozzáérne az ágyhoz. További információért lásd az [ágy szintezés dokumentumot](Bed_Level.md).

## Átkonvertáltam a Marlinból származó konfigurációmat, és az X/Y tengelyek jól működnek, de a Z tengely kezdőpont fílvételekor csikorgó hangot hallok

Rövid válasz: Először is ellenőrizze, hogy a [config check dokumentumban](Config_checks.md) leírtak szerint ellenőrizte-e a léptető konfigurációját. Ha a probléma továbbra is fennáll, próbálja meg csökkenteni a max_z_velocity értéket a nyomtató konfigurációjában.

Hosszú válasz: A gyakorlatban a Marlin jellemzően csak körülbelül 10000 lépés/másodperc sebességgel tud lépni. Ha olyan sebességgel kell mozognia, amely nagyobb lépésszámot igényel, akkor a Marlin általában csak olyan gyorsan lép, amilyen gyorsan csak tud. A Klipper sokkal nagyobb lépésszámot képes elérni, de a léptetőmotornak nem biztos, hogy elegendő nyomatéka van a nagyobb sebességű mozgáshoz. Tehát egy nagy áttételszámú vagy nagy mikrolépésszámú Z tengely esetében a ténylegesen elérhető max_z_sebesség kisebb lehet, mint ami a Marlinban be van állítva.

## A TMC motorvezérlő kikapcsol a nyomtatás közben

Ha a TMC2208 (vagy TMC2224) motorvezérlőt "standalone módban" használja, akkor győződjön meg róla, hogy a [Klipper legújabb verzióját](#hogyan-frissithetek-a-legujabb-szoftverre) használja. A TMC2208 "stealthchop" motorvezérlő problémájának megoldása 2020 március közepén került hozzá a Klipperhez.

## Folyamatosan kapok "Elveszett a kommunikáció az MCU-val" hibákat

Ezt általában a gazdagép és a mikrokontroller közötti USB-kapcsolat hardverhibái okozzák. Amit keresni kell:

- Használjon jó minőségű USB-kábelt a gazdagép és a mikrokontroller között. Győződjön meg róla, hogy a csatlakozók biztonságosan csatlakoznak.
- Ha Raspberry Pi-t használ, használjon [jó minőségű tápegységet](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply) a Raspberry Pi számára, és egy [jó minőségű USB-kábellel](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877) csatlakoztassa a tápegységet a Pihez. Ha az OctoPrint "feszültség alatt" figyelmeztetéseket kap, az a tápegységgel függ össze, és ezt meg kell javítani.
- Győződjön meg róla, hogy a nyomtató áramellátása nincs túlterhelve. (A mikrovezérlő USB-chip áramellátásának ingadozása a chip újraindítását eredményezheti.)
- Ellenőrizze, hogy a léptető, fűtő és egyéb nyomtatóvezetékek nem szakadtak vagy rongálódtak. (A nyomtató mozgása megterhelheti a hibás vezetéket, ami érintkezési hibákhoz, rövidzárlathoz vagy túlzott zajkeltéshez vezethet.)
- Jelentéseket kaptunk magas USB-zajról, amikor a nyomtató, és a gazdagép 5V-os tápellátása keveredik. (Ha azt tapasztalja, hogy a mikrokontroller bekapcsol, amikor a gazdagép tápellátása be van kapcsolva, vagy az USB-kábel be van dugva, akkor ez azt jelzi, hogy az 5V-os tápegységek keverednek.) Segíthet, ha úgy konfigurálja a mikrokontrollert, hogy csak az egyik forrásból származó áramot használja. (Alternatív megoldásként, ha a mikrokontroller lapja nem tudja konfigurálni az áramforrását, módosíthatunk egy USB-kábelt úgy, hogy az ne szállítson 5V-os áramot a gazdagép és a mikrokontroller között.)

## A Raspberry Pi folyamatosan újraindul nyomtatás közben

Ez valószínűleg a feszültségingadozások miatt van. Kövesse ugyanazokat a hibaelhárítási lépéseket az ["Elveszett kommunikáció az MCU-val"](#folyamatosan-kapok-elveszett-a-kommunikacio-az-mcu-val-hibakat) hiba esetén.

## Amikor beállítom a `restart_method=command` az AVR készülékem újraindításkor egyszerűen lefagy

Az AVR bootloader néhány régi verziójának ismert hibája van a watchdog esemény kezelésében. Ez általában akkor jelentkezik, ha a printer.cfg fájlban a restart_method beállítása "command". Amikor a hiba előfordul, az AVR eszköz nem reagál, amíg a tápellátást el nem veszik és újra be nem kapcsolják az eszközbe (a tápellátás vagy az állapotjelző LED-ek is többször villoghatnak, amíg a tápellátást el nem veszik).

A megoldás a "command" -tól eltérő restart_method használata, vagy egy frissített bootloader égetése az AVR eszközre. Egy új bootloader égetése egy egyszeri lépés, amelyhez általában külső programozóra van szükség - további részletekért lásd [Bootloaderek](Bootloaders.md) dokumentumot.

## A fűtőelemek bekapcsolva maradnak, ha a Raspberry Pi összeomlik?

A szoftvert úgy tervezték, hogy ezt megakadályozza. Ha a gazdagép egyszer engedélyezi a fűtőberendezést, a szoftverének 5 másodpercenként meg kell erősítenie az engedélyezést. Ha a mikrokontroller nem kap 5 másodpercenként megerősítést, akkor "leállítás" állapotba kerül, amelynek célja, hogy kikapcsolja az összes fűtőberendezést és léptetőmotort.

További részletekért lásd az [MCU-parancsok](MCU_Commands.md) dokumentumban található "config_digital_out" parancsot.

Ezenkívül a mikrovezérlő szoftver indításkor minden fűtőberendezéshez be van állítva egy minimális és maximális hőmérséklettartomány (a részletekért lásd a [konfigurációs hivatkozásban](Config_Reference.md#extruder) található min_temp és max_temp paramétereket). Ha a mikrokontroller azt érzékeli, hogy a hőmérséklet e tartományon kívül esik, akkor szintén "leállítás" állapotba lép.

A gazdaszoftver külön kódot is tartalmaz a fűtőelemek és a hőmérséklet-érzékelők helyes működésének ellenőrzésére. További részletekért lásd a [konfigurációs hivatkozás](Config_Reference.md#verify_heater) dokumentumot.

## Hogyan alakíthatok át egy Marlin tű számot Klipper tű névre?

Rövid válasz: [sample-aliases.cfg](../config/sample-aliases.cfg) fájlban található leképezés. Használja ezt a fájlt útmutatóként a tényleges mikrokontroller tű nevek megtalálásához. (Az is lehetséges, hogy a vonatkozó [board_pins](Config_Reference.md#board_pins) config szakaszt átmásolja a config fájljába, és használja az álneveket a configban, de előnyösebb a tényleges mikrokontroller tű nevek lefordítása és használata.) Vegye figyelembe, hogy a sample-aliases.cfg fájl olyan tű neveket használ, amelyek "ar" előtaggal kezdődnek "D" helyett (pl. az Arduino tű `D23` a Klipper álnév `ar23`) és az "analog" helyett "A" (pl. az Arduino tű `A14` a Klipper álnév `analog14`).

Hosszú válasz: Klipper a mikrokontroller által meghatározott szabványos tű neveket használja. Az Atmega chipeken ezek a hardveres tűk olyan neveket viselnek, mint `PA4`, `PC7`, vagy `PD2`.

Régen az Arduino projekt úgy döntött, hogy nem használja a szabványos hardverneveket, hanem saját, növekvő számokon alapuló tű neveket használ. Ezek az Arduino nevek általában úgy néznek ki, mint `D23` vagy `A14`. Ez egy szerencsétlen választás volt, amely sok zavart okozott. Különösen az Arduino tű-számok gyakran nem fordítják le ugyanazokat a hardveres neveket. Például a `D21` az `PD0` egy közös Arduino lapon, de `PC7` egy másik közös Arduino lapon.

A zavar elkerülése érdekében a Klipper alapkódja a mikrokontroller által meghatározott szabványos tű neveket használja.

## Az eszközömet egy adott típusú mikrokontroller tűhöz kell csatlakoztatnom?

Ez az eszköz típusától és a tű típusától függ:

ADC tűk (vagy analóg tűk): Termisztorok és hasonló "analóg" érzékelők esetén az eszközt a mikrokontroller egy "analóg" vagy "ADC" -képes tűjére kell csatlakoztatni. Ha a Klippert olyan tű használatára konfigurálja, amely nem analóg képes, a Klipper egy "Nem érvényes ADC tű" hibát fog jelenteni.

PWM tűk (vagy időzítő tűk): A Klipper alapértelmezés szerint nem használ hardveres PWM-et egyetlen eszköz esetében sem. Tehát általában a fűtőtesteket, ventilátorokat és hasonló eszközöket bármelyik általános célú IO tűre lehet vezetékezni. A ventilátorok és az output_pin eszközök azonban opcionálisan úgy konfigurálhatók, hogy `hardware_pwm: True` értéket használnak, amely esetben a mikrokontrollernek támogatnia kell a hardveres PWM-et a tűn (ellenkező esetben a Klipper egy "Not a valid PWM pin" hibát fog jelezni).

IRQ-tűk (vagy megszakítási tűk): A Klipper nem használ hardveres megszakításokat az IO tűkön, ezért soha nem szükséges egy eszközt ezen mikrokontroller tűk egyikére vezetni.

SPI-tűk: A hardveres SPI használatakor a tűket a mikrokontroller SPI-képes tűihez kell csatlakoztatni. A legtöbb eszköz azonban konfigurálható a "szoftveres SPI" használatára, amely esetben bármely általános célú IO-tű használható.

I2C tűk: I2C használatakor a tűket a mikrokontroller I2C-képes tűihez kell csatlakoztatni.

Más eszközök bármelyik általános célú IO tűre csatlakoztathatók. Például léptetők, fűtők, ventilátorok, Z-szondák, szervók, LED-ek, közös hd44780/st7920 LCD-kijelzők, a Trinamic UART vezérlővonal bármely általános célú IO-tűhöz csatlakoztatható.

## Hogyan tudom törölni az M109/M190 "hőmérsékletre várni" kérést?

Navigáljon az OctoPrint terminál fülre, és adjon ki egy M112 parancsot a terminálmezőben. Az M112 parancs hatására a Klipper "leállítás" állapotba kerül, és az OctoPrint megszakítja a kapcsolatot a Klipperrel. Navigáljon az OctoPrint csatlakozási területére, és kattintson a "Connect" gombra, hogy az OctoPrint újra csatlakozzon. Navigáljon vissza a terminál fülre, és adjon ki egy FIRMWARE_RESTART parancsot a Klipper hibaállapotának törléséhez. E műveletsor befejezése után az előző fűtéskérés törlődik, és új nyomtatás indítható.

## Meg tudom állapítani, hogy a nyomtató vesztett-e lépéseket?

Bizonyos értelemben igen. Indítsa el a nyomtatót, adjon ki egy `GET_POSITION` parancsot, indítsa el a nyomtatást, indítsa el újra, és adjon ki egy újabb `GET_POSITION` parancsot. Ezután hasonlítsa össze az `mcu:` sorban szereplő értékeket.

Ez hasznos lehet a beállítások, például a léptetőmotorok áramának, gyorsulásának és sebességének beállításához anélkül, hogy ténylegesen nyomtatnod kellene valamit és pazarolnod kellene a szálakat: csak futtass néhány nagy sebességű mozgást a `GET_POSITION` parancsok között.

Vegye figyelembe, hogy a végálláskapcsolók maguk is hajlamosak kissé eltérő pozícióban kioldani, így a néhány mikrolépésnyi különbség valószínűleg a végállás pontatlanságának eredménye. Maga a léptetőmotor csak 4 teljes lépésenként képes lépéseket veszíteni. (Tehát, ha 16 mikrolépést használunk, akkor a léptető egy elvesztett lépése azt eredményezi, hogy az "mcu:" lépésszámláló 64 mikrolépés többszörösével téved.)

## Miért jelent hibát a Klipper? Elrontotta a nyomtatásomat!

Rövid válasz: A nyomtatóink problémákat észlelnek, hogy a mögöttes problémát orvosolni lehessen, és kiváló minőségű nyomatokat kaphassunk. Semmiképpen sem szeretnénk, ha a nyomtatóink csendben rossz minőségű nyomatokat készítenének.

Hosszú válasz: A Klipper úgy lett megtervezve, hogy automatikusan megoldjon számos átmeneti problémát. Például automatikusan észleli a kommunikációs hibákat, és újratovábbítja azokat; előre ütemezi a műveleteket, és több rétegben puffereli a parancsokat, hogy még időszakos interferencia esetén is pontos időzítést tegyen lehetővé. Ha azonban a szoftver olyan hibát észlel, amelyből nem tud helyreállni, ha érvénytelen műveletre kap parancsot, vagy ha azt észleli, hogy reménytelenül képtelen végrehajtani a parancsolt feladatot, akkor a Klipper hibát jelent. Ezekben a helyzetekben nagy a kockázata annak, hogy rossz minőségű nyomtatás készül (vagy rosszabb). Reméljük, hogy a felhasználó figyelmeztetése lehetővé teszi számára, hogy megoldja a kiváltó problémát, és javítsa a nyomatok általános minőségét.

Van néhány kapcsolódó kérdés: Miért nem szünetelteti a Klipper a nyomtatást? Nem jelent figyelmeztetést helyette? A nyomtatás előtt nem ellenőrzi a hibákat? Figyelmen kívül hagyja a hibákat a felhasználó által begépelt parancsokban? stb. Jelenleg a Klipper a G-kód protokollt használva olvassa a parancsokat, és sajnos a G-kód parancsprotokoll nem elég rugalmas ahhoz, hogy ezek az alternatívák ma már praktikusak legyenek. A fejlesztők érdeklődnek a felhasználói élmény javítása iránt a rendellenes események során, de ez várhatóan jelentős infrastrukturális munkát igényel (beleértve a G-kódtól való eltávolodást).

## Hogyan frissíthetek a legújabb szoftverre?

A szoftver frissítésének első lépése a legfrissebb [konfigurációs változások](Config_Changes.md) dokumentum áttekintése. Alkalmanként olyan változások történnek a szoftverben, amelyek miatt a felhasználóknak frissíteniük kell a beállításaikat a szoftverfrissítés részeként. A frissítés előtt érdemes átnézni ezt a dokumentumot.

Ha készen áll a frissítésre, az általános módszer az, hogy SSH-t használunk a Raspberry Pi-n, és futtatjuk:

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

Ezután újrafordíthatjuk és égethetjük a mikrokontroller kódját. Például:

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

Azonban gyakran előfordul, hogy csak a gazdaszoftver változik. Ebben az esetben csak a gazdaszoftvert frissíthetjük és indíthatjuk újra:

```
cd ~/klipper
git pull
sudo service klipper restart
```

Ha e parancs használata után a szoftver arra figyelmeztet, hogy a mikrokontrollert újra kell égetni, vagy más szokatlan hiba lép fel, akkor kövesse a fent leírt teljes frissítési lépéseket.

Ha továbbra is fennállnak a hibák, akkor ellenőrizze a [konfigurációs változások](Config_Changes.md) dokumentumot, mivel lehet, hogy módosítani kell a nyomtató konfigurációját.

Ne feledje, hogy a RESTART és FIRMWARE_RESTART G-kód parancsok nem töltenek be új szoftvert a fenti "sudo service klipper restart" és "make flash" parancsok szükségesek a szoftverváltás érvénybe lépéséhez.

## Hogyan tudom eltávolítani a Klippert?

A firmware oldalon semmi különösnek nem kell történnie. Csak kövesse az új firmware égetési utasításait.

A Raspberry Pi oldalon egy eltávolító szkript elérhető a [scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh) alatt. Például:

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
