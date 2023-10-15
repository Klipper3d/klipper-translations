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
   - [BL-Touch](BLTouch.md): Bir "BL-Touch" Z probu yapılandırın.
   - [Manuel seviye](Manual_Level.md): Z uç duraklarının (ve benzeri) kalibrasyonu.
   - [Bed Mesh](Bed_Mesh.md): XY konumlarına dayalı yatak yüksekliği düzeltmesi.
   - [Son durdurma aşaması](Endstop_Phase.md): Kademeli destekli Z uç durdurma konumlandırması.
- [Rezonans telafisi](Resonance_Compensation.md): Baskılardaki çınlamayı azaltan bir araç.
   - [Rezonansların ölçülmesi](Measuring_Resonances.md): Rezonansı ölçmek için adxl345 ivmeölçer donanımının kullanılmasına ilişkin bilgiler.
- [Basınç ilerlemesi](Pressure_Advance.md): Ekstruder basıncını kalibre edin.
- [G-Codes](G-Codes.md): Klipper tarafından desteklenen komutlara ilişkin bilgiler.
- [Komut Şablonları](Command_Templates.md): G Kodu makroları ve koşullu değerlendirme.
   - [Durum Referansı](Status_Reference.md): Makrolar (ve benzerleri) tarafından kullanılabilen bilgiler.
- [TMC Drivers](TMC_Drivers.md): Klipper ile Trinamic step motor sürücülerini kullanma.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing and probing using multiple micro-controllers.
- [Dilimleyiciler](Slicers.md): Klipper için "dilimleyici" yazılımını yapılandırın.
- [Skew correction](Skew_Correction.md): Adjustments for axes not perfectly square.
- [PWM araçları](Using_PWM_Tools.md): Lazerler veya iş milleri gibi PWM kontrollü araçların nasıl kullanılacağına ilişkin kılavuz.
- [Exclude Object](Exclude_Object.md): The guide to the Exclude Objects implementation.

## Geliştirici Belgeleri

- [Koda genel bakış](Code_Overview.md): Geliştiriciler önce bunu okumalıdır.
- [Kinematics](Kinematics.md): Klipper'ın hareketi nasıl uyguladığına ilişkin teknik ayrıntılar.
- [Protokol](Protocol.md): Ana bilgisayar ile mikro denetleyici arasındaki düşük düzey mesajlaşma protokolü hakkında bilgi.
- [API Sunucusu](API_Server.md): Klipper'ın komut ve kontrol API'si hakkında bilgi.
- [MCU komutları](MCU_Commands.md): Mikro denetleyici yazılımında uygulanan düşük seviyeli komutların açıklaması.
- [CAN veri yolu protokolü](CANBUS_protocol.md): Klipper CAN veri yolu mesaj formatı.
- [Hata Ayıklama](Debugging.md): Klipper'ın nasıl test edileceği ve hata ayıklanacağı hakkında bilgi.
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
   - [CAN bus troubleshooting](CANBUS_Troubleshooting.md): Tips for troubleshooting CAN bus.
- [TSL1401CL filament width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](Hall_Filament_Width_Sensor.md)
