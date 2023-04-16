# Overview

Klipper dökümantasyonuna hoş geldiniz. Eğer Klipper'e yeni iseniz , [özellikler](Features.md) ve [kurulum](Installation.md) ile başlayabilirsiniz.

## Genel Bakış Bilgileri

- [Özellikler](Features.md): Klipper'ın sahip olduğu yüksek-seviye özellikler listesi.
- [SSS](FAQ.md): Sıklıkla sorulan sorular.
- [Sürümler](Releases.md): Klipper sürümleri.
- [Yapı değişiklikleri](Config_Changes.md): Kullanıcıların yazıcı yapılandırma dosyasını değiştirmelerini gerektirebilecek son yazılım değişiklikleri.
- [İletişim](Contact.md): Hata raporlama ve Klipper geliştiricileri ile genel iletişim hakkında bilgiler.

## Installation and Configuration

- [Kurulum](Installation.md): Klipper'ı indirmek için kılavuz.
- [Yapı Referansları](Config_Reference.md): Yapılandırma değişkenlerinin açıklamaları.
   - [Dönüş Mesafesi](Rotation_Distance.md): Step motor parametresi rotation_distance hesaplaması.
- [Konfigürasyon gözden geçirme](Config_checks.md): Konfigürasyon dosyasındaki temel pin ayarlarını doğrulayın.
- [Baskı yatağı düzeyi](Bed_Level.md): Klipper'da "baskı yatağı düzeyleme" hakkında bilgi.
   - [Delta ayarı](Delta_Calibrate.md): Delta kinematik kalibrasyonu.
   - [Probe ayarı](Probe_Calibrate.md): Otomatik Z probe'larının kalibrasyonu.
   - [BL-Touch](BLTouch.md): Configure a "BL-Touch" Z probe.
   - [Manual level](Manual_Level.md): Calibration of Z endstops (and similar).
   - [Bed Mesh](Bed_Mesh.md): Bed height correction based on XY locations.
   - [Endstop phase](Endstop_Phase.md): Stepper assisted Z endstop positioning.
- [Resonance compensation](Resonance_Compensation.md): A tool to reduce ringing in prints.
   - [Measuring resonances](Measuring_Resonances.md): Information on using adxl345 accelerometer hardware to measure resonance.
- [Pressure advance](Pressure_Advance.md): Calibrate extruder pressure.
- [G-Codes](G-Codes.md): Information on commands supported by Klipper.
- [Command Templates](Command_Templates.md): G-Code macros and conditional evaluation.
   - [Status Reference](Status_Reference.md): Information available to macros (and similar).
- [TMC Drivers](TMC_Drivers.md): Using Trinamic stepper motor drivers with Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing and probing using multiple micro-controllers.
- [Slicers](Slicers.md): Configure "slicer" software for Klipper.
- [Skew correction](Skew_Correction.md): Adjustments for axes not perfectly square.
- [PWM tools](Using_PWM_Tools.md): Guide on how to use PWM controlled tools such as lasers or spindles.
- [Exclude Object](Exclude_Object.md): The guide to the Exclude Objects implementation.

## Developer Documentation

- [Code overview](Code_Overview.md): Developers should read this first.
- [Kinematics](Kinematics.md): Technical details on how Klipper implements motion.
- [Protokol](Protocol.md): Ana bilgisayar ile mikro denetleyici arasındaki düşük düzey mesajlaşma protokolü hakkında bilgi.
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
- [Beaglebone](Beaglebone.md): Details for running Klipper on the Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Developer information on micro-controller flashing.
- [CAN bus](CANBUS.md): Information on using CAN bus with Klipper.
- [TSL1401CL filament width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](Hall_Filament_Width_Sensor.md)
