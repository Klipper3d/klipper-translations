# Overview

Vítejte v dokumentaci ke Klipperu. Pokud s Klipprem začínáte, začněte s dokumenty [features](Features.md) a [installation](Installation.md)

## Přehled informací

- [Funkce](Features.md): Seznam funkcí Klipperu na vysoké úrovni.
- [FAQ](FAQ.md): Často kladené otázky.
- [Releases](Releases.md): Historie vydání Klipperu.
- [Změny konfigurace](Config_Changes.md): Aktuální změny softwaru, které mohou vyžadovat aktualizaci konfiguračního souboru tiskárny.
- [Contact](Contact.md): Informace o hlášení chyb a obecné komunikaci s vývojáři aplikace Klipper.

## Instalace a konfigurace

- [Installation](Installation.md): Průvodce instalací Klipperu.
- [Config Reference](Config_Reference.md): Popis konfiguračních parametrů.
   - [Rotation Distance](Rotation_Distance.md): Výpočet parametru rotation_distance krokového motoru.
- [Config checks](Config_checks.md): Ověřte základní nastavení pinů v konfiguračním souboru.
- [Bed level](Bed_Level.md): Informace o "bed leveling" v Klipperu.
   - [Delta calibrate](Delta_Calibrate.md): Kalibrace delta kinematiky.
   - [Probe calibrate](Probe_Calibrate.md): Automatická kalibrace Z sondy.
   - [BL-Touch](BLTouch.md): Kalibrace "BL-Touch" Z sondy.
   - [Manual level](Manual_Level.md): Kalibrace koncových spínačů osy Z (a podobně).
   - [Bed Mesh](Bed_Mesh.md): Korekce výšky lože na základě polohy XY.
   - [Endstop phase](Endstop_Phase.md): Polohování koncového dorazu Z s asistencí krokového motoru.
- [Resonance compensation](Resonance_Compensation.md): Nástroj pro snížení zvonění u výtisků.
   - [Měření rezonancí](Measuring_Resonances.md): Informace o použití akcelerometru adxl345 k měření rezonancí.
- [Pressure advance](Pressure_Advance.md): Kalibrace tlaku extrudéru.
- [G-Codes](G-Codes.md): Information on commands supported by Klipper.
- [Šablony příkazů](Command_Templates.md): G-kód makra a podmíněné vyhodnocování.
   - [Status Reference](Status_Reference.md): Informace dostupné pro makra (a podobné).
- [TMC Drivers](TMC_Drivers.md): Použití ovladačů krokových motorů Trinamic s Klipperem.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing and probing using multiple micro-controllers.
- [Slicers](Slicers.md): Konfigurace softwaru "slicer" pro Klipper.
- [Skew correction](Skew_Correction.md): Adjustments for axes not perfectly square.
- [Nástroje PWM](Using_PWM_Tools.md): Příručka k používání nástrojů řízených PWM, jako jsou lasery nebo vřetena.
- [Exclude Object](Exclude_Object.md): The guide to the Exclude Objecs implementation.

## Dokumentace pro vývojáře

- [Code overview](Code_Overview.md): Toto by si vývojáři měli přečíst nejdříve.
- [Kinematics](Kinematics.md): Technické detaily jak Klipper implementuje pohyb.
- [Protocol](Protocol.md): Informace o nízkoúrovňovém předávacím protokolu mezi hostitelem a mikrokontrolerem.
- [API Server](API_Server.md): Information on Klipper's command and control API.
- [MCU commands](MCU_Commands.md): A description of low-level commands implemented in the micro-controller software.
- [CAN bus protocol](CANBUS_protocol.md): Klipper CAN bus message format.
- [Debugging](Debugging.md): Information on how to test and debug Klipper.
- [Benchmarks](Benchmarks.md): Information on the Klipper benchmark method.
- [Contributing](CONTRIBUTING.md): Information on how to submit improvements to Klipper.
- [Packaging](Packaging.md): Information on building OS packages.

## Dokumenty specifické pro zařízení

- [Example configs](Example_Configs.md): Information on adding an example config file to Klipper.
- [SDCard Updates](SDCard_Updates.md): Flash a micro-controller by copying a binary to an sdcard in the micro-controller.
- [Raspberry Pi as Micro-controller](RPi_microcontroller.md): Details for controlling devices wired to the GPIO pins of a Raspberry Pi.
- [Beaglebone](Beaglebone.md): Details for running Klipper on the Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Developer information on micro-controller flashing.
- [CAN bus](CANBUS.md): Information on using CAN bus with Klipper.
- [TSL1401CL filament width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](Hall_Filament_Width_Sensor.md)
