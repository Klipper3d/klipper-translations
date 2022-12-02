# Kiadás

A Klipper kiadások története. A Klipper telepítésével kapcsolatos információkért lásd a [telepítés](Installation.md) dokumentumot.

## Klipper 0.10.0

Elérhető a 20210929. Fontosabb változások ebben a kiadásban:

* A "Multi-MCU Homing" támogatása. Mostantól lehetőség van arra, hogy egy léptetőmotor és a végállás külön mikrovezérlőkhöz legyen csatlakoztatva. Ez leegyszerűsíti a Z-érzékelők kábelezését a "nyomtatófejen".
* Klipper mostantól rendelkezik egy [Közösségi Discord Szerver](https://discord.klipper3d.org) és egy [Közösségi Társalgó Szerver](https://community.klipper3d.org)-rel.
* A [Klipper weboldal](https://www.klipper3d.org) mostantól az "mkdocs" infrastruktúrát használja. Létezik egy [Klipper Fordítások](https://github.com/Klipper3d/klipper-translations) projekt is.
* Automatizált támogatás a firmware SDkártyán keresztüli égetéséhez számos lapon.
* Új kinematikai támogatás a "Hybrid CoreXY" és "Hybrid CoreXZ" nyomtatókhoz.
* A Klipper mostantól a `rotation_distance` funkciót használja a léptetőmotorok mozgási távolságának beállításához.
* A Klipper fő gazdakódja mostantól közvetlenül kommunikálhat a mikrovezérlőkkel a CAN-buszon keresztül.
* Új "mozgáselemző" rendszer. A Klipper 'belső mozgásfrissítések és az érzékelő eredményei nyomon követhetők és naplózhatók elemzés céljából.
* A Trinamic léptetőmotor-meghajtókat mostantól folyamatosan ellenőrzik a hibaállapotok szempontjából.
* Az rp2040 mikrokontroller támogatása (Raspberry Pi Pico lapok).
* A "make menuconfig" rendszer mostantól a kconfiglib-et használja.
* Hozzáadva számos további modul: ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu
* Számos hibajavítás és kódtisztítás.

## Klipper 0.9.0

Elérhető a 20201020. Főbb változások ebben a kiadásban:

* Az "Input Shaping" a nyomtató rezonanciájának ellensúlyozására szolgáló mechanizmus támogatása. Csökkentheti vagy megszüntetheti a "gyűrődést" a nyomatokon.
* Új "Smooth Pressure Advance" rendszer. Ezt a "Pressure Advance" rendszer a pillanatnyi sebesség változások bevezetése nélkül valósítja meg. Mostantól lehetőség van a nyomás előtolás beállítására is a "Tuning Tower" módszerrel.
* Új "webhooks" API-kiszolgáló. Ez egy programozható JSON interfészt biztosít a Klipperhez.
* Az LCD kijelző és a menü mostantól a Jinja2 sablonnyelv segítségével konfigurálható.
* A TMC2208 léptetőmotor-meghajtók mostantól "standalone" üzemmódban is használhatók a Klipperrel.
* Továbbfejlesztett BL-Touch v3 támogatás.
* Javított USB-azonosítás. A Klipper mostantól saját USB-azonosító kóddal rendelkezik, és a mikrovezérlők mostantól az USB-azonosítás során jelenthetik egyedi sorozatszámukat.
* Új kinematikai támogatás a "Rotary Delta" és "CoreXZ" nyomtatókhoz.
* Mikrovezérlő fejlesztések: az STM32F070 támogatása, az STM32F207 támogatása, a GPIO tűk támogatása a "Linux MCU" rendszeren, STM32 "HID bootloader" támogatás, Chitu bootloader támogatás, MKS Robin bootloader támogatás.
* A Python "szemétgyűjtési" események jobb kezelése.
* Számos további modul lett hozzáadva: adc_scaled, adxl345, bme280, display_status, extruder_stepper, fan_generic, hall_filament_width_sensor, htu21d, homing_heaters, input_shaper, lm75, print_stats, resonance_tester, shaper_calibrate, query_adc, graph_accelerometer, graph_extruder, graph_motion, graph_shaper, graph_temp_sensor, whconsole
* Számos hibajavítás és kódtisztítás.

### Klipper 0.9.1

Elérhető a 20201028. Csak hibajavításokat tartalmazó kiadás.

## Klipper 0.8.0

Elérhető a 20191021. Főbb változások ebben a kiadásban:

* Új G-kód parancssablon támogatás. A konfigurációs fájlban lévő G-kódot mostantól a Jinja2 sablonnyelvvel értékeli ki a rendszer.
* A Trinamic léptető meghajtók javítása:
   * Új támogatás a TMC2209 és TMC5160 illesztőprogramokhoz.
   * Továbbfejlesztett DUMP_TMC, SET_TMC_CURRENT és INIT_TMC G-kód parancsok.
   * Javított támogatás a TMC UART kezeléséhez analóg mux-al.
* Javított célmeghatározás, mérés és tárgyasztal szintezési támogatás:
   * Új manual_probe, bed_screws, screws_tilt_adjust, skew_correction, safe_z_home modulok hozzáadása.
   * Továbbfejlesztett többmintás mérés mediánnal, átlagolással és újrapróbálási logikával.
   * Javított dokumentáció a BL-Touch, a szondakalibrálás, a végállás kalibrálás, a delta kalibrálás, az érzékelő nélküli kezdőpont és a végállás fázis kalibrálásához.
   * Továbbfejlesztett kezdőpont támogatás a Z tengelyen.
* Számos Klipper mikrokontroller fejlesztés:
   * Klipper portolva: SAM3X8C, SAM4S8C, SAMD51, STM32F042, STM32F4
   * Új USB CDC-illesztőprogramok SAM3X, SAM4, STM32F4 rendszerekhez.
   * Továbbfejlesztett támogatás a Klipper USB-n keresztül történő égetéséhez.
   * Szoftveres SPI-támogatás.
   * Jelentősen javult a hőmérséklet-szűrés az LPC176x-en.
   * A korai kimeneti érintkezők beállításai a mikrovezérlőben konfigurálhatók.
* Új weboldal a Klipper dokumentációval: http://klipper3d.org/
   * A Klippernek már van logója.
* A poláris és a "kábelcsörlő" kinematika kísérleti alátámasztása.
* A konfigurációs fájl mostantól más konfigurációs fájlokat is tartalmazhat.
* Számos további modul hozzá lett adva: board_pins, controller_fan, delayed_gcode, dotstar, filament_switch_sensor, firmware_retraction, gcode_arcs, gcode_button, heater_generic, manual_stepper, mcp4018, mcp4728, neopixel, pause_resume, respond, temperature_sensor tsl1401cl_filament_width_sensor, tuning_tower
* Számos további parancsot adtunk hozzá: RESTORE_GCODE_STATE, SAVE_GCODE_STATE, SET_GCODE_VARIABLE, SET_HEATER_TEMPERATURE, SET_IDLE_TIMEOUT, SET_TEMPERATURE_FAN_TARGET
* Számos hibajavítás és kódtisztítás.

## Klipper 0.7.0

Elérhető a 20181220. Főbb változások a kiadásban:

* A Klipper mostantól támogatja a "háló" tárgyasztal szintezés állítást
* Új támogatás a "továbbfejlesztett" delta kalibrációhoz (kalibráld a nyomtatás x/y méreteit delta nyomtatókon)
* A Trinamic léptetőmotor-meghajtók (tmc2130, tmc2208, tmc2660) futásidejű konfigurációjának támogatása
* Javított hőmérséklet-érzékelő támogatás: MAX6675, MAX31855, MAX31856, MAX31865, egyedi termisztorok, általános PT100 típusú érzékelők
* Számos új modul: temperature_fan, sx1509, force_move, mcp4451, z_tilt, quad_gantry_level, endstop_phase, bltouch
* Számos új parancs hozzáadása: SAVE_CONFIG, SET_PRESSURE_ADVANCE, SET_GCODE_OFFSET, SET_VELOCITY_LIMIT, STEPPER_BUZZ, TURN_OFF_HEATERS, M204, egyedi G-kód makrók
* Kibővített LCD-kijelző támogatás:
   * Futásidejű menük támogatása
   * Új kijelző ikonok
   * A "uc1701" és "ssd1306" kijelzők támogatása
* További mikrokontroller támogatás:
   * Klipper portolva: LPC176x (Smoothieboards), SAM4E8E (Duet2), SAMD21 (Arduino Zero), STM32F103 ("Blue pill" eszközök), atmega32u4
   * Új generikus USB CDC vezérlő implementálva AVR, LPC176x, SAMD21 és STM32F103 platformokra
   * Teljesítményjavulás ARM processzorokon
* A kinematikai kódot átírtuk, hogy egy "iteratív megoldót" használjon
* Új automatikus tesztelési esetek a Klipper gazdagép szoftverhez
* Számos új példa konfigurációs fájl a szokásos nyomtatókhoz
* Dokumentációfrissítések rendszerbetöltőkhöz, teljesítményértékeléshez, mikrovezérlő portoláshoz, konfigurációs ellenőrzésekhez, tű hozzárendeléshez, szeletelőbeállításokhoz, csomagoláshoz és egyebekhez
* Számos hibajavítás és kódtisztítás

## Klipper 0.6.0

Elérhető a 20180331. Főbb változások ebben a kiadásban:

* Továbbfejlesztett fűtőberendezés és termisztor hardverhiba ellenőrzések
* Z-szondák támogatása
* A delták automatikus paraméterkalibrálásának kezdeti támogatása (egy új delta_calibrate parancson keresztül)
* A tárgyasztal dőléskiegyenlítésének kezdeti támogatása (a bed_tilt_calibrate paranccsal)
* A "biztonságos kezdőpont" és a kezdőpont felülbírálásának kezdeti támogatása
* Kezdeti támogatás az állapot megjelenítéséhez a RepRapDiscount 2004 és 12864 stílusú kijelzőkön
* Új multi-extruder fejlesztések:
   * A megosztott fűtőtestek támogatása
   * Kezdeti támogatás kettős kocsikhoz
* Több léptető tengelyenkénti konfigurálásának támogatása (pl. kettős Z)
* Egyedi digitális és PWM kimeneti tűk támogatása (új SET_PIN paranccsal)
* Kezdeti támogatás egy "virtuális SDcard" számára, amely lehetővé teszi a nyomtatást közvetlenül a Klipper-ről (segít a túl lassú gépeken, hogy az OctoPrint jól fusson)
* Különböző karhosszúságok beállításának támogatása a delta minden egyes tornyán
* A G-kód M220/M221 parancsok támogatása (sebességtényező felülbírálása / extrudálási tényező felülbírálása)
* Számos dokumentáció frissítés:
   * Számos új példa konfigurációs fájl a szokásos nyomtatókhoz
   * Új több MCU konfigurációs példa
   * Új BL-Touch érzékelő konfigurációs példa
   * Új GYIK, konfigurációs ellenőrzés és G-kód dokumentumok
* Kezdeti támogatás a folyamatos integráció teszteléséhez az összes végleges GitHub fejlesztésben
* Számos hibajavítás és kódtisztítás

## Klipper 0.5.0

Elérhető a 20171025. Főbb változások ebben a kiadásban:

* Több extruder-el rendelkező nyomtatók támogatása.
* Kezdeti támogatás a Beaglebone PRU-n való futtatáshoz. Kezdeti támogatás a Replicape alaplaphoz.
* Kezdeti támogatás a mikrokontroller kódjának valós idejű Linux-folyamatban történő futtatásához.
* Több mikrovezérlő támogatása. (Például egy extruder vezérelhető egy mikrokontrollerrel, a nyomtató többi része pedig egy másikkal.) A mikrovezérlők közötti műveletek összehangolásához szoftveres órajel-szinkronizálás van implementálva.
* Léptető teljesítményének javítása (20Mhz-es AVR-ek akár 189K lépés/másodpercig).
* Támogatás a szervók vezérléséhez és a fejhűtő ventilátorok meghatározásához.
* Számos hibajavítás és kódtisztítás

## Klipper 0.4.0

Elérhető a 20170503. Főbb változások ebben a kiadásban:

* Javított telepítés Raspberry Pi gépekre. A telepítés nagy része most már szkriptelt.
* A corexy kinematika támogatása
* Dokumentáció frissítések: Új Kinematika dokumentum, új Pressure Advance tuning útmutató, új példa konfigurációs fájlok, stb
* Léptető teljesítmény javulása (20Mhz AVR több mint 175K lépés/másodperc, Arduino Due több mint 460K)
* A mikrokontroller automatikus visszaállításának támogatása. A Raspberry Pi USB tápellátásának kapcsolásával történő visszaállítás támogatása.
* A nyomás előtolás algoritmus mostantól look-ahead funkcióval működik, hogy csökkentse a kanyarodás közbeni nyomásváltozásokat.
* A rövid cikcakk mozgások maximális sebességének korlátozása
* AD595 érzékelők támogatása
* Számos hibajavítás és kódtisztítás

## Klipper 0.3.0

Elérhető a 20161223. Főbb változások ebben a kiadásban:

* Javított dokumentáció
* Delta kinematikai robotok támogatása
* Arduino Due mikrokontroller támogatása (ARM cortex-M3)
* USB alapú AVR mikrovezérlők támogatása
* Támogatás a "nyomás előtolás" algoritmushoz - ez csökkenti a nyomatok során keletkező szivárgást.
* Új "léptetőfázis-alapú végállás" funkció - nagyobb pontosságot tesz lehetővé a kezdőpont végállásában.
* A "kiterjesztett G-kód" parancsok támogatása, mint például a "help", "restart" és "status".
* A Klipper konfiguráció újratöltésének és a gazdaszoftver újraindításának támogatása a "restart" parancs terminálból történő kiadásával.
* Lépegető teljesítményének javítása (20Mhz-es AVR-ek akár 158K lépés/másodpercig).
* Javított hibajelentés. A legtöbb hiba mostantól a terminálon keresztül jelenik meg, a megoldásra vonatkozó segítséggel együtt.
* Számos hibajavítás és kódtisztítás

## Klipper 0.2.0

A Klipper első kiadása. Elérhető a 20160525. A kezdeti kiadásban elérhető főbb funkciók a következők:

* Alapvető támogatás cartesian nyomtatókhoz (stepperek, extruder, fűtött tárgyasztal, hűtőventilátor).
* A gyakori G-kód parancsok támogatása. Az OctoPrint interfész támogatása.
* Gyorsulás és előretekintő kezelés
* AVR mikrovezérlők támogatása szabványos soros portokon keresztül
