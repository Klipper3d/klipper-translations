# Áttekintés

Üdvözöljük a Klipper dokumentációjában. Ha még nem ismeri a Klippert, kezdje a [jellemzők](Features.md) és [telepítés](Installation.md) dokumentumokkal.

## Áttekintő információk

- [Jellemzők](Features.md): A Klipper jellemzőinek magas szintű listája.
- [GYIK](FAQ.md): Gyakran ismételt kérdések.
- [Kiadások](Releases.md): Klipper kiadások története.
- [Konfigurációs változások](Config_Changes.md): A legújabb szoftverváltozások, amelyek miatt a felhasználóknak frissíteniük kell a nyomtató konfigurációs fájlját.
- [Kapcsolat](Contact.md): Információk a hibajelentésekről és a Klipper fejlesztőivel való általános kommunikációról.

## Telepítés és Konfiguráció

- [Telepítés](Installation.md): Klipper telepítési útmutató.
- [Konfigurációs hivatkozás](Config_Reference.md): A konfigurációs paraméterek leírása.
   - [Rotációs távolság](Rotation_Distance.md): A rotation_distance léptető paraméter kiszámítása.
- [Konfigurációs ellenőrzések](Config_checks.md): Alapvető tűbeállítások ellenőrzése a konfigurációs fájlban.
- [Ágyszintezés](Bed_Level.md): Információ az "ágyszintezésről" a Klipperben.
   - [Delta kalibrálás](Delta_Calibrate.md): A delta kinematika kalibrálása.
   - [Szonda kalibrálása](Probe_Calibrate.md): Automatikus Z-szondák kalibrálása.
   - [BL-Touch](BLTouch.md): "BL-Touch" Z szonda konfigurálása.
   - [Kézi szintezés](Manual_Level.md): Z végállások kalibrálása (és hasonlók).
   - [Ágy háló](Bed_Mesh.md): X-Y-helyeken alapuló ágyszint-korrekció.
   - [Végállás fázis](Endstop_Phase.md): Z végállás pozícionálása lépéssegédlettel.
- [Rezonanciakompenzáció](Resonance_Compensation.md): Egy eszköz a nyomatok gyűrődésének (ringing) csökkentésére.
   - [Rezonanciák mérése](Measuring_Resonances.md): adxl345 gyorsulásmérő hardver használatával kapcsolatos információk a rezonancia méréséhez.
- [Nyomás előtolás](Pressure_Advance.md): Az extruder nyomásának kalibrálása.
- [G-kódok](G-Codes.md): Információk a Klipper által támogatott parancsokról.
- [Parancssablonok](Command_Templates.md): G-kód makrók és feltételes kiértékelés.
   - [Állapot referencia](Status_Reference.md): A makrók (és hasonlók) számára elérhető információk.
- [TMC Meghajtók](TMC_Drivers.md): Trinamic léptetőmotor-meghajtók használata Klipperrel.
- [Multi-MCU Kezdőpont](Multi_MCU_Homing.md): Kezdőpont felvétel és szintezés több mikrovezérlő használatával.
- [Szeletelők](Slicers.md): A „szeletelő” szoftverek konfigurálása a Klipper számára.
- [Ferdeség korrekció](Skew_Correction.md): A nem tökéletesen derékszögű tengelyek korrekciója.
- [PWM eszközök](Using_PWM_Tools.md): Útmutató a PWM vezérelt szerszámok, például lézerek vagy orsók használatához.

## Fejlesztői Dokumentáció

- [Kódáttekintés](Code_Overview.md): A fejlesztőknek először ezt kell elolvasniuk.
- [Kinematika](Kinematics.md): Technikai részletek arról, hogyan valósítja meg a Klipper a mozgást.
- [Protokoll](Protocol.md): A gazdagép és a mikrokontroller közötti alacsony szintű üzenetküldési protokollról szóló információk.
- [API-kiszolgáló](API_Server.md): Információ a Klipper parancs és vezérlő API-járól.
- [MCU-parancsok](MCU_Commands.md): A mikrokontroller szoftverében megvalósított alacsony szintű parancsok leírása.
- [CAN-busz protokoll](CANBUS_protocol.md): Klipper CAN-busz üzenetformátum.
- [Hibakeresés](Debugging.md): Klipper tesztelésével és hibakeresésével kapcsolatos információk.
- [Jelszintek](Benchmarks.md): Klipper jelszint módszerrel kapcsolatos információk.
- [Hozzájárulás](CONTRIBUTING.md): Információ arról, hogyan küldhetsz fejlesztéseket a Klipperhez.
- [Csomagolás](Packaging.md): Az operációs rendszer csomagjainak összeállításával kapcsolatos információk.

## Eszközspecifikus Dokumentumok

- [Példa konfigurációk](Example_Configs.md): Információ egy példa konfigurációs fájl Klipperhez való hozzáadásával kapcsolatban.
- [SD-kártya Frissítések](SDCard_Updates.md): Mikrokontroller égetése egy bináris állománynak a mikrokontroller SD-kártyára történő másolásával.
- [Raspberry Pi mint mikrokontroller](RPi_microcontroller.md): A Raspberry Pi GPIO-tűire csatlakoztatott eszközök vezérlésének részletei.
- [Beaglebone](Beaglebone.md): Klipper futtatásának részletei a Beaglebone PRU-n.
- [Bootloaderek](Bootloaders.md): Fejlesztői információk a mikrokontrollerek égetéséről.
- [CAN-busz](CANBUS.md): Információk a CAN-busz Klipperrel való használatáról.
- [TSL1401CL szálszélesség érzékelő](TSL1401CL_Filament_Width_Sensor.md)
- [Hall szálszélesség érzékelő](Hall_Filament_Width_Sensor.md)
