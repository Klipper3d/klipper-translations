# Overblik

Velkommen til Klippers dokumentation. Hvis du er ny her, anbefales det at starte med [funktioner](Features.md) og [installation](Installation.md) dokumenterne.

## Informationsoverblik

- [Funktioner](Features.md): En udførlig liste over funktionerne i Klipper.
- [OSS](FAQ.md): Ofte Stillede Spørgsmål.
- [Udgivelser](Releases.md): Historik over Klipper-udgivelser.
- [Konfigurationsændringer](Config_Changes.md): Nylige ændringer af softwaren, der kan kræve at brugeren opdaterer sin printers konfigurationsfil.
- [Kontakt](Contact.md): Information om rapportering af fejl, samt generel kommunikation med Klippers udviklere.

## Installation og konfigurering

- [Installation](Installation.md): Vejledning til installation af Klipper.
   - [Octoprint](Octoprint.md): Guide til installering af Octoprint med Klipper.
- [Konfigurations reference](Config_Reference.md): Beskrivelse af parametre der kan konfigureres.
   - [Rotationsdistance](Rotation_Distance.md): Beregning af Rotationsdistance parameteren.
- [Konfigurationstjek](Config_checks.md): Verificér basale pinouts i konfigurationsfilen.
- [Byggeplade nivellering](Bed_Level.md): Information om "nivellering af byggeplade" i Klipper.
   - [Delta kalibrering](Delta_Calibrate.md): Kalibrering af Delta-printere.
   - [Probekalibrering](Probe_Calibrate.md): Kalibrering af automatiske Z prober.
   - [BL-Touch](BLTouch.md): Konfigurering af "BL-Touch" probe.
   - [Manuel nivellering](Manual_Level.md): Kalibrering af Z endestop (og lignende).
   - [Nivelleringsgitter](Bed_Mesh.md): Nivellering af byggepladen baseret på X/Y positioner.
   - [Endestop fase](Endstop_Phase.md): Z endestop ved brug af stepper-motor.
   - [Kompensering af Akse-rotation](Axis_Twist_Compensation.md): Værktøj til brug for kompensering af upræcise målinger grundet rotation i X-aksen.
- [Resonans kompensering](Resonance_Compensation.md): Et værktøj til reduktion af vibrationsartefakter under print.
   - [Måling af resonans](Measuring_Resonances.md): Information om brug af adxl345 accelerometer hardware til måling af resonans.
- [Pressure advance](Pressure_Advance.md): Kalibrering af trykket i dyssen.
- [G-koder](G-Codes.md): Information om kommandoer der understøttes af Klipper.
- [Kommandoskabeloner](Command_Templates.md): G-Code makroer og betinget evaluering.
   - [Status Reference](Status_Reference.md): Informationer til brug i makroer (og lignende).
- [TMC Drivere](TMC_Drivers.md): Brug af Trinamic stepper motor drivere med Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing og nivellering ved brug af flere mcu'er.
- [Slicere](Slicers.md): Konfiguration af slicer-software til brug med Klipper.
- [korrektion af skævhed](Skew_Correction.md): Justering af akser der ikke løber 100% vinkelret.
- [PWM værktøjer](Using_PWM_Tools.md): Vejledning om brug af PWM (Pulse Width Modulation) værktøjer, som Lasere og fræsespindler.
- [Ekskludér objekt](Exclude_Object.md): Vejledning om implementering af Ekskludér objekt funktionen.

## Udvikler-dokumentation

- [Kode overblik](Code_Overview.md): Udviklere bør læse dette først.
- [Kinematik](Kinematics.md): Tekniske detaljer om hvordan Klipper implementerer bevægelser.
- [Protokol](Protocol.md): Information om Lav-niveau beskedprotokollen mellem vært og mcu.
- [API Server](API_Server.md): Information om Klippers Kommando og kontrol API.
- [MCU kommandoer](MCU_Commands.md): En beskrivelse om lav-niveau kommandoer implementeret i mcu-softwaren.
- [CAN-bus protokol](CANBUS_protocol.md): Klippers CAN-bus besked format.
- [Fejlfinding](Debugging.md): Information om test og fejlfinding af Klipper.
- [Benchmark](Benchmarks.md): Information om Klippers benchmark metode.
- [Bidragelse](CONTRIBUTING.md): Information om indsending af bidrag/forbedringer til Klipper.
- [Pakning/Bundling](Packaging.md): Information om opbygning af OS-pakker.

## Enheds-specifikke dokumenter

- [Konfigurationseksempler](Example_Configs.md): Information om tilføjelse af Konfigurationseksempler til Klipper.
- [SD-kort opdateringer](SDCard_Updates.md): Flash en mcu ved at kopiere en binær fil til kortet i mcu'en.
- [Raspberry Pi som mcu](RPi_microcontroller.md): Detaljer om styring af enheder forbundet til Rasperry Pis GPIO pins.
- [Beaglebone](Beaglebone.md): Detaljer for kørsel af Klipper på Beaglebone PRU.
- [Bootloadere](Bootloaders.md): Udvikler-information om flash af mcu.
- [Bootloader Kald](Bootloader_Entry.md): Anmodning til bootloader.
- [CAN-bus](CANBUS.md): Information om brug af CAN-bus med Klipper.
   - [CAN-bus fejlfinding](CANBUS_Troubleshooting.md): Tips til fejlfinding af CAN-bus.
- [TSL1401CL filament bredde sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament-bredde sensor](Hall_Filament_Width_Sensor.md)
- [Eddy Current Inductive probe](Eddy_Probe.md)
