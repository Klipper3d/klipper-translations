# İlk Bakış

Klipper dökümantasyonuna hoş geldiniz. Eğer Klipper'de yeni iseniz , [özellikler](Features.md) ve [kurulum](Installation.md) ile başlayabilirsiniz.

## Genel Bakış

- [Özellikler](Features.md): Klipper'ın sahip olduğu yüksek-seviye özellikler listesi.
- [SSS](FAQ.md): Sıklıkla sorulan sorular.
- [Sürümler](Releases.md): Klipper sürümleri.
- [Yapı değişiklikleri](Config_Changes.md): Kullanıcıların yazıcı yapılandırma dosyasını değiştirmelerini gerektirebilecek son yazılım değişiklikleri.
- [İletişim](Contact.md): Hata raporlama ve Klipper geliştiricileri ile genel iletişim hakkında bilgiler.

## Kurulum ve Yapılandırma

- [Kurulum](Installation.md): Klipper'ı indirmek için kılavuz.
   - [Octoprint](OctoPrint.md): Guide to installing Octoprint with Klipper.
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
   - [Axis Twist Compensation](Axis_Twist_Compensation.md): A tool to compensate for inaccurate probe readings due to twist in X gantry.
- [Rezonans telafisi](Resonance_Compensation.md): Baskılardaki çınlamayı azaltan bir araç.
   - [Rezonansların ölçülmesi](Measuring_Resonances.md): Rezonansı ölçmek için adxl345 ivmeölçer donanımının kullanılmasına ilişkin bilgiler.
- [Basınç ilerlemesi](Pressure_Advance.md): Ekstruder basıncını kalibre edin.
- [G-Codes](G-Codes.md): Klipper tarafından desteklenen komutlara ilişkin bilgiler.
- [Komut Şablonları](Command_Templates.md): G Kodu makroları ve koşullu değerlendirme.
   - [Durum Referansı](Status_Reference.md): Makrolar (ve benzerleri) tarafından kullanılabilen bilgiler.
- [TMC Drivers](TMC_Drivers.md): Klipper ile Trinamic step motor sürücülerini kullanma.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing and probing using multiple micro-controllers.
- [Dilimleyiciler](Slicers.md): Klipper için "dilimleyici" yazılımını yapılandırın.
- [Eğim düzetme](Skew_Correction.md): Tamamen kare olmayan eksenler için ayarlamalar.
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
- [Benchmarklar](Benchmarks.md): Klipper kıyaslama yöntemi hakkında bilgi.
- [Katkıda Bulunmak](CONTRIBUTING.md): Klipper'a iyileştirmelerin nasıl gönderileceği hakkında bilgi.
- [Paketleme](Packaging.md): İS paketleri oluşturma üzerine bilgilendirme.

## Cihaza Özgü Belgeler

- [Örnek yapılandırmalar](Example_Configs.md): Klipper'a örnek bir yapılandırma dosyası ekleme üzerine bilgilendirme.
- [SDCard Güncellemeleri](SDCard_Updates.md): Bir mikro-denetleyiciyi, sdcard içine bir ikili dosya (binary) kopyalayarak flashlama.
- [Mikro denetleyici olarak Raspberry Pi](RPi_microcontroller.md): Bir Raspberry Pi üzerindeki GPIO pinlerine bağlı cihazları kontrol etmek için ayrıntılar.
- [Beaglebone](Beaglebone.md): Klipper'ı Beaglebone PRU üzerinde çalıştırmak için ayrıntılar.
- [Önyükleyiciler](Bootloaders.md): Mikro denetleyici flashlama hakkında geliştirici bilgilendirmesi.
- [Bootloader Entry](Bootloader_Entry.md): Requesting the bootloader.
- [CAN veri yolu](CANBUS.md): Klipper ile CAN veri yolu kullanımı üzerine bilgilendirme.
   - [CAN bus troubleshooting](CANBUS_Troubleshooting.md): Tips for troubleshooting CAN bus.
- [TSL1401CL filament genişlik sensörü](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](Hall_Filament_Width_Sensor.md)
- [Eddy Current Inductive probe](Eddy_Probe.md)
- [Load Cells](Load_Cell.md)
