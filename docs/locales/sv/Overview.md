# Översikt

Välkommen till Klippers dokumentation. Om du är ny med Klipper börjar du med dokumenten [funktioner](Features.md) och [installation](Installation.md).

## Översiktsinformation

- [Funktioner](Features.md): En övergripande lista över funktionerna i Klipper.
- [Vanliga frågor](FAQ.md): Vanliga frågor och svar.
- [Utgåvor](Releases.md): Klippers utgåvehistorik.
- [Konfigurationsändringar](Config_Changes.md): Nyliga programändringar som kan kräva att användaren uppdaterar skrivarens konfigurationsfil.
- [Kontakt](Contact.md): Information om felrapportering och allmän kommunikation med Klippers utvecklare.

## Installation och konfiguration

- [Installation](Installation.md): Guide till installation av Klipper.
   - [OctoPrint](OctoPrint.md): Guide till installation av OctoPrint med Klipper.
- [Konfigurationsreferens](Config_Reference.md): Beskrivning av konfigurationsparametrar.
   - [Rotationsavstånd](Rotation_Distance.md): Beräkning av stegmotorparametern rotation_distance.
- [Konfigurationskontroller](Config_checks.md): Kontrollera grundläggande stiftinställningar i konfigurationsfilen.
- [Bäddnivellering](Bed_Level.md): Information om bäddnivellering i Klipper.
   - [Deltakalibrering](Delta_Calibrate.md): Kalibrering av delta-kinematik.
   - [Sondkalibrering](Probe_Calibrate.md): Kalibrering av automatiska Z-sonder.
   - [BL-Touch](BLTouch.md): Konfigurera en BL-Touch-Z-sond.
   - [Manuell nivåjustering](Manual_Level.md): Kalibrering av Z-ändstopp och liknande.
   - [Bäddrutnät](Bed_Mesh.md): Korrigering av bäddhöjden utifrån XY-positioner.
   - [Ändstoppsfas](Endstop_Phase.md): Stegmotorassisterad positionering av Z-ändstopp.
   - [Kompensering för axelvridning](Axis_Twist_Compensation.md): Ett verktyg för att kompensera felaktiga sondavläsningar på grund av vridning i X-bryggan.
- [Resonanskompensering](Resonance_Compensation.md): Ett verktyg för att minska ringningar i utskrifter.
   - [Mäta resonanser](Measuring_Resonances.md): Information om att använda accelerometerhårdvara av typen ADXL345 för att mäta resonans.
- [Tryckutjämning](Pressure_Advance.md): Kalibrera extruderns tryck.
- [G-koder](G-Codes.md): Information om kommandon som stöds av Klipper.
- [Kommandomallar](Command_Templates.md): G-kodsmakron och villkorsutvärdering.
   - [Statusreferens](Status_Reference.md): Information som är tillgänglig för makron och liknande.
- [TMC-drivrutiner](TMC_Drivers.md): Använda Trinamics stegmotordrivrutiner med Klipper.
- [Ändlägeskörning med flera MCU:er](Multi_MCU_Homing.md): Ändlägeskörning och sondering med flera mikrostyrenheter.
- [Skivningsprogram](Slicers.md): Konfigurera skivningsprogram för Klipper.
- [Skevhetskorrigering](Skew_Correction.md): Justeringar för axlar som inte är helt vinkelräta.
- [PWM-verktyg](Using_PWM_Tools.md): Guide för användning av PWM-styrda verktyg, till exempel lasrar eller spindlar.
- [Uteslut objekt](Exclude_Object.md): Guide till implementeringen av uteslutning av objekt.

## Utvecklardokumentation

- [Kodöversikt](Code_Overview.md): Utvecklare bör läsa detta först.
- [Kinematik](Kinematics.md): Tekniska detaljer om hur Klipper implementerar rörelse.
- [Protokoll](Protocol.md): Information om lågnivåprotokollet för meddelanden mellan värddator och mikrostyrenhet.
- [API-server](API_Server.md): Information om Klippers API för kommandon och styrning.
- [MCU-kommandon](MCU_Commands.md): En beskrivning av lågnivåkommandon som implementeras i mikrostyrenhetens programvara.
- [CAN-bussprotokoll](CANBUS_protocol.md): Klippers meddelandeformat för CAN-buss.
- [Felsökning](Debugging.md): Information om hur du testar och felsöker Klipper.
- [Prestandatester](Benchmarks.md): Information om Klippers metod för prestandatester.
- [Bidra](CONTRIBUTING.md): Information om hur du skickar in förbättringar till Klipper.
- [Paketering](Packaging.md): Information om att bygga operativsystemspaket.

## Enhetsspecifika dokument

- [Exempelkonfigurationer](Example_Configs.md): Information om att lägga till en exempelkonfigurationsfil i Klipper.
- [SD-kortsuppdateringar](SDCard_Updates.md): Flasha en mikrostyrenhet genom att kopiera en binärfil till ett SD-kort i mikrostyrenheten.
- [Raspberry Pi som mikrostyrenhet](RPi_microcontroller.md): Detaljer om att styra enheter som är anslutna till GPIO-stiften på en Raspberry Pi.
- [BeagleBone](Beaglebone.md): Detaljer om att köra Klipper på BeagleBone-PRU:n.
- [Starthanterare](Bootloaders.md): Utvecklarinformation om flashning av mikrostyrenheter.
- [Start av starthanteraren](Bootloader_Entry.md): Begär starthanteraren.
- [CAN-buss](CANBUS.md): Information om att använda CAN-buss med Klipper.
   - [CAN-bussfelsökning](CANBUS_Troubleshooting.md): Tips för felsökning av CAN-buss.
- [TSL1401CL-filamentbreddssensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall-sensor för filamentbredd](Hall_Filament_Width_Sensor.md)
- [Induktiv virvelströmssond](Eddy_Probe.md)
- [Lastceller](Load_Cell.md)
