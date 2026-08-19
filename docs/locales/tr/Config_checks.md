# Konfigürasyon denetimi

Bu doküman Klipper printer.cfg dosyasında bulunan pin ayarları için bir dizi adım içermektedir. Bu adımların [yükleme dokümanı](Installation.md) içinde yer alan adımları takip ettikten sonra izlenmesi tavsiye edilir.

Bu klavuz sırasında Klipper konfigürasyon dosyasında değişiklik yapılması gerekebilir. Konfigürasyon dosyasında yapılan her değişiklikten sonra RESTART komutunu vererek değişikliklerin etkin olduğundan emin olun (Octoprint terminal sekmesinde "restart" yazıp "Send" butonuna tıklayın). Her RESTART sonrasında STATUS komutunu çalıştırıp konfigürasyon dosyasının başarıyla okunduğunu doğrulamak iyi bir fikir olacaktır.

## Sıcaklığı doğrula

Sıcaklıkların doğru şekilde raporlandığını doğrulayarak işe başlayın. Kullanıcı arayüzünde sıcaklık grafiği bölümüne gidin. Nozül (besleme ucu) ve baskı yatağı (varsa) sıcaklığının mevcut olduğunu ve artmadığını doğrulayın. Artıyorsa, yazıcının gücünü kesin. Sıcaklıklar doğru değilse, nozül (besleme ucu) ve/veya baskı yatağı için "sensor_type" ve "sensor_pin" ayarlarını gözden geçirin.

## M112 doğrula

Komut konsoluna gidin ve terminal kutusunda bir M112 komutu girin. Bu komut Klipper'ın "kapanma" durumuna geçmesini talep eder. Komut konsolunda FIRMWARE_RESTART komutu ile temizlenebilen bir hata gösterilmesine neden olacaktır. Octoprint de yeniden bağlanmayı gerektirecektir. Ardından sıcaklık grafiği bölümüne gidin ve sıcaklıkların güncellenmeye devam ettiğini ve sıcaklıkların artmadığını doğrulayın. Sıcaklıklar artıyorsa yazıcının gücünü kesin.

## Isıtıcıları doğrula

Sıcaklık grafiği bölümüne gidin ve ekstrüder/alet sıcaklığı kutusuna 50 yazıp enter tuşuna basın. Grafikteki ekstrüder sıcaklığı artmaya başlamalıdır (yaklaşık 30 saniye içinde). Ardından ekstrüder sıcaklığı açılır menüsüne gidin ve "Kapalı" seçeneğini seçin. Birkaç dakika sonra sıcaklık ilk oda sıcaklığı değerine dönmeye başlamalıdır. Sıcaklık artmazsa, yapılandırmadaki "heater_pin" ayarını doğrulayın.

Yazıcı ısıtılmış bir baskı yatağına sahip ise yukarıdaki testi baskı yatağı ile tekrarlayın.

## Step motorun enable pinini doğrulayın

Yazıcının tüm eksenlerinin elle hareket edebildiğini doğrulayın (step motorlar devre dışı). Eğer öyle değilse, motorları devre dışı bırakmak için M84 komutu verin. Eğer eksenlerden herhangi biri hala serbestçe hareket edemiyorsa, ilgili eksen için stepper "enable_pin" yapılandırmasını doğrulayın. Çoğu ticari step motor sürücüsünde, motor etkinleştirme pin "aktif düşük" olduğundan, pinin önüne "!" işareti konmalıdır (örneğin, "enable_pin: !PA1").

## Sonlandırıcıları doğrula

Yazıcının tüm eksenlerini elle hareket ettirerek hiçbirinin endstop ile temas kurmadığından emin olun. Komut konsolundan QUERY_ENDSTOPS (Endstopları sorgulama) komutu gönderin. Tüm yapılandırılmış endstopların mevcut durumunu bildiren bir yanıt vermelidir ve hepsinin "açık" durumu bildirilmelidir. Her bir endstop için, QUERY_ENDSTOPS komutunu manuel olarak endstop'u tetikleyerek tekrar çalıştırın. QUERY_ENDSTOPS komutu endstop'u "TRIGGERED" (Tetiklendi) olarak bildirmelidir.

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!PA2"), or remove the "!" if there is already one present.

Sonlandırıcıda hiçbir değişiklik olmuyorsa bu genellikle sonlandırıcının başka bir pine bağlı olduğunu işaret eder. Ancak bu, pine ait pullup ayarının değiştirilmesini de gerektirebilir (endstop_pin isminin başındaki '^' - çoğu yazıcı bir pullup direnci kullanır ve '^' zaten bulunmalıdır).

## Step motorları doğrula

Her bir step motorun bağlantısını doğrulamak için STEPPER_BUZZ komutunu kullanın. Verilen ekseni manuel olarak orta noktaya yerleştirerek başlayın ve ardından komut konsolunda `STEPPER_BUZZ STEPPER=stepper_x` çalıştırın. STEPPER_BUZZ komutu, verilen step motoru pozitif yönde bir milimetre hareket ettirdikten sonra başlangıç konumuna geri döndürür. (Endstop, position_endstop=0 olarak tanımlanmışsa, her hareketin başında step motoru endstop'tan uzaklaşacaktır.) Bu osilasyonu on kez gerçekleştirecektir.

Step motor hiç hareket etmez ise motorun "enable_pin" ve "step_pin" ayarlarını doğrulayın. Step motor hareket eder ama orjinal pozisyonuna dönmez ise "dir_pin" ayarını doğrulayın. Motor yanlış bir yönde salınım yaparsa bu genellikle o eksene ait "dir_pin" değerinin ters çevrilmesi gerektiğini işaret eder. Yazıcı konfigürasyon dosyasındaki "dir_pin" değerine "!" eklenerek (veya zaten var ise silinerek) bu işlem gerçekleştirilir. Motor bir milimetreden önemli ölçüde az veya fazla hareket ederse "rotation_distance" ayarını doğrulayın.

Yukarıdaki testi konfigürasyon dosyasında tanımlanan her step motor için çalıştır. (STEPPER_BUZZ komutundaki STEPPER parametresininin değerini test edilecek konfigürasyon bölümünün adı yapın.) Ekstrüderde filaman yok ise STEPPER_BUZZ komutunu ekstrüder motoru bağlantısını doğrulamak için kullanabilirsiniz (STEPPER=extruder yapın). Aksi halde, en iyisi ekstrüder motorunu ayrıca test etmektir (bir sonraki bölüme bakınız).

Bütün sonlandırıcılar ve step motorlar doğrulandıktan sonra hedef arama mekanizması test edilmelidir. Bütün eksenleri hedeflemek için G28 komutunu çalıştırın. Hedefleme doğru yapılmıyorsa yazıcıyı güçten çekin. Gerekirse sonlandırıcı ve step motor doğrulama adımlarını yeniden çalıştırın.

## Ekstrüder motorunu doğrula

Ekstruder motorunu test etmek için ekstruder'ı bir yazdırma sıcaklığına ısıtmanız gerekecektir. Sıcaklık grafiği bölümüne gidin ve sıcaklık açılır listesinden bir hedef sıcaklık seçin (veya uygun bir sıcaklık manuel olarak girin). Yazıcının istenen sıcaklığa ulaşmasını bekleyin. Daha sonra komut konsoluna gidin ve "Extrude" (Ekstrüde) düğmesine tıklayın. Ekstruder motorunun doğru yönde döndüğünü doğrulayın. Eğer öyle değilse, önceki bölümdeki sorun giderme ipuçlarına bakın, ekstruder için "enable_pin", "step_pin" ve "dir_pin" ayarlarını doğrulamak için.

## PID kalibrasyon ayarları

Klipper, ekstrüder ve baskı yatağı ısıtıcıları için [PID kontrolünü](https://en.wikipedia.org/wiki/PID_controller) destekler. Bu kontrol mekanizmasını kullanmak için PID ayarları her yazıcı için ayrıca kalibre edilmelidir (diğer aygıt yazılımlarında veya örnek konfigürasyon dosyalarında bulunan PID ayarları genellikle kötü bir performans sergiler).

Ekstrüderi kalibre etmek için komut konsoluna gidin ve PID_CALIBRATE komutunu çalıştırın. Örneğin: `PID_CALIBRATE HEATER=extruder TARGET=170`

Yeni PID ayarlarını printer.cfg dosyasına yazmak için ayar testi bitiminde `SAVE_CONFIG` komutunu çalıştırın.

Yazıcı ısıtılmış bir baskı yatağına sahipse ve PWM (Pulse Width Modulation) ile sürülmeyi destekliyorsa baskı yatağı için PID kontrolü kullanılması önerilir. (Baskı yatağı ısıtıcısı bir PID algoritması ile kontrol ediliyorsa saniyede on kere açılıp kapanabilir, bu durum mekanik anahtar kullanan ısıtıcılar için uygun olmayabilir.) Tipik bir baskı yatağı PID kalibrasyonu komutu şu şekildedir: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Sonraki adımlar

Bu kılavuz, Klipper konfigürasyon dosyasındaki pin ayarlarının temel doğrulamasına yardımcı olmayı amaçlamaktadır. [Yatak düzeyleme](Bed_Level.md) kılavuzunu mutlaka okuyunuz. Ayrıca Klipper ile dilimleyici yapılandırma hakkında bilgi sahibi olmak için [Dilimleyiciler](Slicers.md) dokümanına bakınız.

Temel yazdırma işleminin çalıştığı doğrulandıktan sonra [basınç avansını](Pressure_Advance.md) kalibre etmeyi değerlendirmek iyi bir fikir olacaktır.

Başka detaylı yazıcı kalibrasyonu tiplerinin uygulanmasına ihtiyaç duyulabilir - bu konuda destek alınabilecek online kılavuzlar mevcuttur (mesela, webde şunu aratın: "üç boyutlu yazıcı kalibrasyonu"). Örnek olarak, ringing denen etki ile karşılaşırsanız [rezonans dengeleme](Resonance_Compensation.md) ayar kılavuzunu takip edebilirsiniz.
