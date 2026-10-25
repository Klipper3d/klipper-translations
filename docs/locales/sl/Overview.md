# Pregled

Dobrodošli v dokumentaciji za Klipper. Če Klipper uporabljate prvič, začnite z dokumentoma o [funkcijah](Features.md) in [namestitvi](Installation.md).

## Splošne informacije

- [Funkcije](Features.md): Pregleden seznam funkcij v Klipperju.
- [Pogosta vprašanja](FAQ.md): Odgovori na pogosta vprašanja.
- [Izdaje](Releases.md): Zgodovina izdaj Klipperja.
- [Spremembe konfiguracije](Config_Changes.md): Nedavne spremembe programske opreme, ki lahko zahtevajo posodobitev konfiguracijske datoteke tiskalnika.
- [Stik](Contact.md): Informacije o prijavi napak in splošni komunikaciji z razvijalci Klipperja.

## Namestitev in konfiguracija

- [Namestitev](Installation.md): Navodila za namestitev Klipperja.
   - [OctoPrint](OctoPrint.md): Vodnik za namestitev OctoPrinta s Klipperjem.
- [Referenca konfiguracije](Config_Reference.md): Opis konfiguracijskih parametrov.
   - [Rotacijska razdalja](Rotation_Distance.md): Izračun parametra rotation_distance za koračne motorje.
- [Preverjanje konfiguracije](Config_checks.md): Preverjanje osnovnih nastavitev pinov v konfiguracijski datoteki.
- [Poravnava mize](Bed_Level.md): Informacije o »poravnavi mize« v Klipperju.
   - [Kalibracija delte](Delta_Calibrate.md): Kalibracija delta kinematike.
   - [Kalibracija sonde](Probe_Calibrate.md): Kalibracija samodejnih Z-sond.
   - [BL-Touch](BLTouch.md): Konfiguracija Z-sonde »BL-Touch«.
   - [Ročna poravnava](Manual_Level.md): Kalibracija končnih stikal Z (in podobno).
   - [Mreža mize](Bed_Mesh.md): Popravek višine mize na podlagi lokacij XY.
   - [Faza končnega stikala](Endstop_Phase.md): Pozicioniranje končnega stikala Z s pomočjo koračnega motorja.
   - [Kompenzacija zasuka osi](Axis_Twist_Compensation.md): Orodje za kompenzacijo nenatančnih odčitkov sonde zaradi zasuka v X-mostu.
- [Kompenzacija resonanc](Resonance_Compensation.md): Orodje za zmanjšanje zvonjenja na tiskih.
   - [Merjenje resonanc](Measuring_Resonances.md): Informacije o uporabi pospeškomera adxl345 za merjenje resonanc.
- [Predtisk tlaka](Pressure_Advance.md): Kalibracija tlaka v ekstruderju.
- [G-kode](G-Codes.md): Informacije o ukazih, ki jih podpira Klipper.
- [Predloge ukazov](Command_Templates.md): Makroji G-kode in pogojno izvajanje.
   - [Referenca stanja](Status_Reference.md): Informacije, ki so na voljo makrojem (in podobno).
- [Gonilniki TMC](TMC_Drivers.md): Uporaba gonilnikov koračnih motorjev Trinamic s Klipperjem.
- [Nuliranje z več MKE](Multi_MCU_Homing.md): Nuliranje in sondiranje z uporabo več mikrokrmilnikov.
- [Rezalniki](Slicers.md): Konfiguracija programske opreme za rezanje za Klipper.
- [Popravek poševnosti](Skew_Correction.md): Prilagoditve za osi, ki niso popolnoma pravokotne.
- [Orodja PWM](Using_PWM_Tools.md): Navodila za uporabo orodij, krmiljenih s PWM, kot so laserji ali vretena.
- [Izključitev predmeta](Exclude_Object.md): Vodnik za implementacijo funkcije »Izključitev predmetov«.

## Dokumentacija za razvijalce

- [Pregled kode](Code_Overview.md): Razvijalci najprej preberite to.
- [Kinematika](Kinematics.md): Tehnične podrobnosti o tem, kako Klipper izvaja gibanje.
- [Protokol](Protocol.md): Informacije o nizkonivojskem protokolu za sporočanje med gostiteljem in mikrokrmilnikom.
- [API strežnik](API_Server.md): Informacije o Klipperjevem API-ju za ukaze in nadzor.
- [Ukazi MKE](MCU_Commands.md): Opis nizkonivojskih ukazov, implementiranih v programski opremi mikrokrmilnika.
- [Protokol vodila CAN](CANBUS_protocol.md): Format sporočil vodila CAN v Klipperju.
- [Odpravljanje napak](Debugging.md): Informacije o testiranju in odpravljanju napak v Klipperju.
- [Primerjalni testi](Benchmarks.md): Informacije o metodi primerjalnih testov Klipper.
- [Sodelovanje](CONTRIBUTING.md): Informacije o tem, kako oddati izboljšave za Klipper.
- [Pakiranje](Packaging.md): Informacije o gradnji paketov za operacijske sisteme.

## Dokumenti za specifične naprave

- [Primeri konfiguracij](Example_Configs.md): Informacije o dodajanju primerov konfiguracijskih datotek v Klipper.
- [Posodobitve prek kartice SD](SDCard_Updates.md): Programiranje mikrokrmilnika s kopiranjem binarne datoteke na kartico SD v mikrokrmilniku.
- [Raspberry Pi kot mikrokrmilnik](RPi_microcontroller.md): Podrobnosti o krmiljenju naprav, povezanih na pine GPIO na Raspberry Pi.
- [Beaglebone](Beaglebone.md): Podrobnosti o poganjanju Klipperja na Beaglebone PRU.
- [Zagonski nalagalniki](Bootloaders.md): Informacije za razvijalce o programiranju mikrokrmilnikov.
- [Vstop v zagonski nalagalnik](Bootloader_Entry.md): Zahteva za zagonski nalagalnik.
- [Vodilo CAN](CANBUS.md): Informacije o uporabi vodila CAN s Klipperjem.
   - [Odpravljanje težav na vodilu CAN](CANBUS_Troubleshooting.md): Nasveti za odpravljanje težav z vodilom CAN.
- [Senzor širine filamenta TSL1401CL](TSL1401CL_Filament_Width_Sensor.md)
- [Hallov senzor širine filamenta](Hall_Filament_Width_Sensor.md)
- [Induktivna sonda na vrtinčne tokove](Eddy_Probe.md)
- [Merilne celice](Load_Cell.md)
