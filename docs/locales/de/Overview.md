# Overview

Willkommen auf der Klipper-Dokumentationsseite! Wenn Klipper für dich neu ist, starte doch einfach mit den [features](Features.md) und [installation](Installation.md) Dokumenten.

## Übersicht

- [Features](Features.md): Eine grobe Übersicht über die Features von Klipper.
- [FAQ](FAQ.md): Häufig gestellte Fragen.
- [Releases](Releases.md): Veröffentlichungshistorie von Klipper.
- [Config changes](Config_Changes.md): Die neuesten Änderungen, die potentielle Änderungen an der Konfigurationsdatei des Druckers auslösen können.
- [Contact](Contact.md): Kontaktinformationen bei Fehlern oder Anfragen an die Klipper-Entwickler.

## Installation and Configuration

- [Installation](Installation.md): Anleitung zur Installation von Klipper.
- [Config Reference](Config_Reference.md): Beschreibung der Einstellmöglichkeiten.
   - [Rotation Distance](Rotation_Distance.md): Berechnung des Schrittmotor-Parameters rotation_distance.
- [Config checks](Config_checks.md): Überprüfung der grundlegenden Pin-Einstellungen in der Konfigurationsdatei.
- [Bed level](Bed_Level.md): Information on "bed leveling" in Klipper.
   - [Delta calibrate](Delta_Calibrate.md): Kalibrierung der Delta-Kinematik.
   - [Probe calibrate](Probe_Calibrate.md): Kalibrierung von automatischen Z-Sonden.
   - [BL-Touch](BLTouch.md): Configure a "BL-Touch" Z probe.
   - [Manual level](Manual_Level.md): Calibration of Z endstops (and similar).
   - [Bed Mesh](Bed_Mesh.md): Bed height correction based on XY locations.
   - [Endstop phase](Endstop_Phase.md): Stepper assisted Z endstop positioning.
- [Resonance compensation](Resonance_Compensation.md): A tool to reduce ringing in prints.
   - [Measuring resonances](Measuring_Resonances.md): Information on using adxl345 accelerometer hardware to measure resonance.
- [Pressure advance](Pressure_Advance.md): Calibrate extruder pressure.
- [Slicers](Slicers.md): Configure "slicer" software for Klipper.
- [Command Templates](Command_Templates.md): G-Code macros and conditional evaluation.
   - [Status Reference](Status_Reference.md): Information available to macros (and similar).
- [TMC Drivers](TMC_Drivers.md): Using Trinamic stepper motor drivers with Klipper.
- [Skew correction](skew_correction.md): Adjustments for axes not perfectly square.
- [PWM tools](Using_PWM_Tools.md): Guide on how to use PWM controlled tools such as lasers or spindles.
- [G-Codes](G-Codes.md): Information on commands supported by Klipper.

## Developer Documentation

- [Code overview](Code_Overview.md): Developers should read this first.
- [Kinematics](Kinematics.md): Technical details on how Klipper implements motion.
- [Protocol](Protocol.md): Information on the low-level messaging protocol between host and micro-controller.
- [API Server](API_Server.md): Information on Klipper's command and control API.
- [MCU commands](MCU_Commands.md): A description of low-level commands implemented in the micro-controller software.
- [CAN bus protocol](CANBUS_protocol.md): Klipper CAN bus message format.
- [Debugging](Debugging.md): Information on how to test and debug Klipper.
- [Benchmarks](Benchmarks.md): Information on the Klipper benchmark method.
- [Contributing](CONTRIBUTING.md): Information on how to submit improvements to Klipper.
- [Packaging](Packaging.md): Information on building OS packages.

## Device Specific Documents

- [Example configs](Example_Configs.md): Information on adding an example config file to Klipper.
- [SDCard Updates](SDCard_Updates.md): Flash a micro-controller by copying a binary to an sdcard in the micro-controller.
- [Raspberry Pi as Micro-controller](RPi_microcontroller.md): Details for controlling devices wired to the GPIO pins of a Raspberry Pi.
- [Beaglebone](beaglebone.md): Details for running Klipper on the Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Developer information on micro-controller flashing.
- [CAN bus](CANBUS.md): Information on using CAN bus with Klipper.
- [TSL1401CL filament width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](HallFilamentWidthSensor.md)
