# Features

A Klipper számos lenyűgöző tulajdonsággal rendelkezik:

* Nagy pontosságú léptető mozgás. A Klipper egy alkalmazásprocesszort (például egy olcsó Raspberry Pi-t) használ a nyomtató mozgásának kiszámításához. Az alkalmazásprocesszor határozza meg, hogy mikor lépjenek az egyes léptetőmotorok, tömöríti ezeket az eseményeket, továbbítja őket a mikrokontrollerhez, majd a mikrokontroller végrehajtja az eseményeket a kért időpontban. Minden egyes léptetőmozgást 25 mikroszekundumos vagy annál jobb pontossággal ütemezünk. A szoftver nem használ kinematikai becsléseket (mint például a Bresenham-algoritmus). Ehelyett a gyorsulás fizikája és a gép kinematikájának fizikája alapján számítja ki a pontos lépésidőket. A pontosabb léptetőmozgás a nyomtató csendesebb és stabilabb működését eredményezi.
* Best in class performance. Klipper is able to achieve high stepping rates on both new and old micro-controllers. Even old 8bit micro-controllers can obtain rates over 175K steps per second. On more recent micro-controllers, several million steps per second are possible. Higher stepper rates enable higher print velocities. The stepper event timing remains precise even at high speeds which improves overall stability.
* A Klipper támogatja a több mikrovezérlővel rendelkező nyomtatókat. Például egy mikrokontroller használható az extruder vezérlésére, míg egy másik a nyomtató fűtőberendezését, míg egy harmadik a nyomtató többi részét vezérli. A Klipper gazdaszoftver órajel-szinkronizációt valósít meg a mikrovezérlők közötti órajel-eltolódás figyelembevétele érdekében. A több mikrovezérlő engedélyezéséhez nincs szükség külön kódra - csak néhány extra sorra a konfigurációs fájlban.
* Konfiguráció egyszerű konfigurációs fájlon keresztül. Nincs szükség a mikrokontroller újrafrissítésére a beállítások megváltoztatásához. Az összes Klipper konfiguráció egy szabványos konfigurációs fájlban van tárolva, amely könnyen szerkeszthető. Ez megkönnyíti a hardver beállítását és karbantartását.
* A Klipper támogatja a "Smooth Pressure Advance" - egy olyan mechanizmust, amely figyelembe veszi a nyomást az extruderben. Ez csökkenti az extruder "szivárgását" és javítja a nyomtatási sarkok minőségét. A Klipper beavatkozása nem vezet be pillanatnyi extruder sebességváltozást, ami javítja az általános stabilitást és robusztusságot.
* A Klipper támogatja az "Input Shaping" funkciót a rezgések nyomtatási minőségre gyakorolt hatásának csökkentése érdekében. Ez csökkentheti vagy kiküszöbölheti a "gyűrődést" (más néven "szellemkép", "visszhang" vagy "hullámzás") a nyomatokon. Lehetővé teheti a gyorsabb nyomtatási sebesség elérését is, miközben a nyomtatás minősége továbbra is magas marad.
* A Klipper egy "interaktív megoldást" használ a pontos lépésidők kiszámításához egyszerű kinematikai egyenletekből. Ez megkönnyíti a Klipper átültetését új típusú robotokra, és az időzítést még összetett kinematika esetén is pontosan tartja (nincs szükség "vonalszegmentálásra").
* Átvihető kód. A Klipper ARM, AVR és PRU alapú mikrovezérlőkön is működik. A meglévő "RepRap" stílusú nyomtatók hardveres módosítás nélkül futtathatják a Klippert. Csak egy Raspberry Pi-t kell hozzáadni. A Klipper belső kódelrendezése megkönnyíti más mikrokontroller-architektúrák támogatását is.
* Egyszerűbb kód. A Klipper egy nagyon magas szintű nyelvet (Python) használ a legtöbb kódhoz. A kinematikai algoritmusok, a G-kód elemzése, a fűtési és termisztor algoritmusok stb. mind Pythonban íródnak. Ez megkönnyíti az új funkciók fejlesztését is.
* Egyéni programozható makrók. Új G-kód parancsok definiálhatók a nyomtató konfigurációs fájljában (nincs szükség kódmódosításra). Ezek a parancsok programozhatók lehetővé téve, hogy a nyomtató állapotától függően különböző műveleteket hajtsanak végre.
* Beépített API-kiszolgáló. A Klipper a szabványos G-kódos interfész mellett egy gazdag JSON-alapú alkalmazási felületet is támogat. Ez lehetővé teszi a programozók számára, hogy külső alkalmazásokat készítsenek a nyomtató részletes vezérlésével.

## További jellemzők

A Klipper számos szabványos 3D nyomtató funkciót támogat:

* Együttműködik az Octoprint-tel. Ez lehetővé teszi a nyomtató vezérlését egy hagyományos webböngészővel. Ugyanaz a Raspberry Pi, amelyen a Klipper fut, képes az Octoprint futtatására is.
* Standard G-Code support. Common g-code commands that are produced by typical "slicers" (SuperSlicer, Cura, PrusaSlicer, etc.) are supported.
* Több extruder támogatása. A közös fűtőberendezéssel rendelkező extrudereket és a független kocsikon (IDEX) lévő extrudereket is támogatják.
* Support for cartesian, delta, corexy, corexz, hybrid-corexy, hybrid-corexz, rotary delta, polar, and cable winch style printers.
* Automatikus ágyszintező támogatás. A Klipper konfigurálható alapszintű ágydőlés-érzékelésre vagy teljes hálós ágyszintezésre. Ha az ágy több Z steppert használ, akkor a Klipper a Z stepperek független manipulálásával is képes szintezni. A legtöbb Z magasságmérő szonda támogatott, beleértve a BL-Touch szondákat és a szervómotoros szondákat is.
* Automatikus delta kalibráció támogatása. A kalibráló eszköz alapvető magassági kalibrálást, valamint továbbfejlesztett X és Y dimenzió kalibrálást végezhet. A kalibrálás elvégezhető Z magasságmérővel vagy kézi szintezővel.
* Support for common temperature sensors (eg, common thermistors, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20, and LM75). Custom thermistors and custom analog temperature sensors can also be configured. One can monitor the internal micro-controller temperature sensor and the internal temperature sensor of a Raspberry Pi.
* Alapértelmezés szerint a fűtésvédelem engedélyezett.
* Support for standard fans, nozzle fans, and temperature controlled fans. No need to keep fans running when the printer is idle. Fan speed can be monitored on fans that have a tachometer.
* A TMC2130, TMC2208/TMC2224, TMC2209, TMC2660 és TMC5160 léptetőmotor-meghajtók futásidejű konfigurációjának támogatása. A hagyományos léptetőmotor-meghajtók AD5206, MCP4451, MCP4728, MCP4018 és PWM-csapokon keresztül történő áramszabályozásának támogatása is biztosított.
* Közvetlenül a nyomtatóhoz csatlakoztatott általános LCD-kijelzők támogatása. Egy alapértelmezett menü is rendelkezésre áll. A kijelző és a menü tartalma a konfigurációs fájlon keresztül teljesen testreszabható.
* Állandó gyorsulás és "look-ahead" támogatás. Minden mozgás fokozatosan gyorsul fel álló helyzetből utazósebességre, majd lassul vissza álló helyzetbe. A beérkező G-kódos mozgásparancsok sorba kerülnek és elemzik őket. A hasonló irányú mozgások közötti gyorsulás optimalizálva lesz a nyomtatási hibák csökkentése és a teljes nyomtatási idő javítása érdekében.
* A Klipper egy olyan "léptetőfázis végállás" algoritmust valósít meg, amely javíthatja a tipikus végálláskapcsolók pontosságát. Megfelelő beállítás esetén javíthatja a nyomtatás első réteg ágyhoz tapadását.
* Support for filament presence sensors, filament motion sensors, and filament width sensors.
* A rezgések mérésének és rögzítésének támogatása adxl345 gyorsulásmérővel.
* Support for limiting the top speed of short "zigzag" moves to reduce printer vibration and noise. See the [kinematics](Kinematics.md) document for more information.
* Sample configuration files are available for many common printers. Check the [config directory](../config/) for a list.

To get started with Klipper, read the [installation](Installation.md) guide.

## Step Benchmarks

Below are the results of stepper performance tests. The numbers shown represent total number of steps per second on the micro-controller.

| Micro-controller | 1 stepper active | 3 steppers active |
| --- | --- | --- |
| 16Mhz AVR | 157K | 99K |
| 20Mhz AVR | 196K | 123K |
| Arduino Zero (SAMD21) | 686K | 471K |
| STM32F042 | 814K | 578K |
| Beaglebone PRU | 866K | 708K |
| STM32G0B1 | 1103K | 790K |
| "Blue Pill" (STM32F103) | 1180K | 818K |
| Arduino Due (SAM3X8E) | 1273K | 981K |
| Duet2 Maestro (SAM4S8C) | 1690K | 1385K |
| Smoothieboard (LPC1768) | 1923K | 1351K |
| Smoothieboard (LPC1769) | 2353K | 1622K |
| Raspberry Pi Pico (RP2040) | 2400K | 1636K |
| Duet2 Wifi/Eth (SAM4E8E) | 2500K | 1674K |
| Adafruit Metro M4 (SAMD51) | 3077K | 1885K |
| BigTreeTech SKR Pro (STM32F407) | 3652K | 2459K |
| Fysetc Spider (STM32F446) | 3913K | 2634K |

Further details on the benchmarks are available in the [Benchmarks document](Benchmarks.md).
