# Konfigürasyon denetimi

Bu doküman Klipper printer.cfg dosyasında bulunan pin ayarları için bir dizi adım içermektedir. Bu adımların [yükleme dokümanı](Installation.md) içinde yer alan adımları takip ettikten sonra izlenmesi tavsiye edilir.

Bu klavuz sırasında Klipper konfigürasyon dosyasında değişiklik yapılması gerekebilir. Konfigürasyon dosyasında yapılan her değişiklikten sonra RESTART komutunu vererek değişikliklerin etkin olduğundan emin olun (Octoprint terminal sekmesinde "restart" yazıp "Send" butonuna tıklayın). Her RESTART sonrasında STATUS komutunu çalıştırıp konfigürasyon dosyasının başarıyla okunduğunu doğrulamak iyi bir fikir olacaktır.

## Sıcaklığı doğrula

Sıcaklıkların düzgün bir şekilde raporlandığını doğrulamak ile başlayın. Octoprint sıcaklık sekmesine gidin.

![octoprint-sicaklik](img/octoprint-temperature.png)

Besleme ucu ve (varsa) baskı yatağına ait sıcaklıkların mevcut olduğunu ve değerlerinin artmadığını doğrulayın. Eğer artıyorsa, yazıcının gücünü kesin. Sıcaklıklar doğru değil ise, besleme ucu ve/veya baskı yatağının "sensor_type" ve "sensor_pin" ayarlarını gözden geçirin.

## M112 doğrula

Octoprint terminal sekmesine gidin ve M112 komutunu çalıştırın. Bu komut, Klipper'ın "kapalı" konuma geçmesini isteyecektir. Komut, Octoprint'in Klipper ile olan bağlantısının kopmasına sebep olacaktır - Bağlantı kısmına gidip "Bağlan" üzerine tıklayarak Octoprint'in bağlantıyı yeniden kurmasını sağlayın. Daha sonra, Octoprint sıcaklık sekmesine giderek sıcaklıkların güncellendiğini ve artmadığını doğrulayın. Sıcaklıklar artıyor ise yazıcının gücünü kesin.

M112 komutu Klipper'ın "kapalı" konuma geçmesine sebep olur. Bu konumdan çıkmak için, Octoprint terminal sekmesinde FIRMWARE_RESTART komutunu çalıştırın.

## Isıtıcıları doğrula

Octoprint sıcaklık sekmesine gidin ve "Araç" sıcaklık kutucuğuna 50 değerini girip Enter tuşuna basın. Grafikteki ekstrüder sıcaklığı (30 saniye gibi bir süre içinde) artmaya başlayacaktır. Daha sonra, "Araç" sıcaklığı açılır kutusuna gidip "Kapalı" seçeneğini seçin. Birkaç dakika içinde, sıcaklık en baştaki oda sıcaklığı değerine dönmeye başlayacaktır. Sıcaklık artmaz ise konfigürasyondaki "heater_pin" ayarını doğrulayın.

Yazıcı ısıtılmış bir baskı yatağına sahip ise yukarıdaki testi baskı yatağı ile tekrarlayın.

## Step motorun enable pinini doğrulayın

Yazıcının bütün eksenlerinin el ile serbestçe hareket ettirilebildiğini (step motorların kapalı olduğunu) doğrulayın. Değilse, M84 komutunu çalıştırarak motorları devre dışı bırakın. Eğer eksenlerden herhangi biri hala hareket ettirilemiyorsa ilgili eksenin step motoruna ait "enable_pin" konfigürasyonunu doğrulayın. Step motor sürücülerinin çoğunda enable pini "active low"dur, dolayısıyla enable pininin başında "!" bulunmalıdır (örneğin, "enable_pin: !ar38").

## Sonlandırıcıları doğrula

Sonlandırıcılar ile temasta olmamalarını sağlamak için yazıcının bütün eksenlerini el ile konumlandırın. Octoprint terminal sekmesinde QUERY_ENDSTOPS komutunu çalıştırın. Konfigüre edilmiş bütün sonlandırıcılara ait durum bilgisi dönecektir ve hepsinin durumu "açık" olmalıdır. Her bir sonlandırıcı için, sonlandırıcıyı el ile tetiklerken QUERY_ENDSTOPS komutunu çalıştırın. QUERY_ENDSTOPS komutu sonlandırıcı durumunu "TETİKLENDİ" olarak gösterecektir.

Sonlandırıcı ters olarak görünüyorsa (tetiklendiğinde "açık" görünüyorsa veya tam tersi) pin tanımına "!" ekleyin (örneğin, "endstop_pin: ^!ar3") veya zaten bir "!" var ise onu silin.

Sonlandırıcıda hiçbir değişiklik olmuyorsa bu genellikle sonlandırıcının başka bir pine bağlı olduğunu işaret eder. Ancak bu, pine ait pullup ayarının değiştirilmesini de gerektirebilir (endstop_pin isminin başındaki '^' - çoğu yazıcı bir pullup direnci kullanır ve '^' zaten bulunmalıdır).

## Step motorları doğrula

STEPPER_BUZZ komutunu kullanarak step motorların bağlantısını doğrulayın. Belirlenen ekseni el ile orta bir noktada konumlandırıp `STEPPER_BUZZ STEPPER=stepper_x` komutunu çalıştırarak başlayın. STEPPER_BUZZ komutu, ilgili step motorun pozitif yönde bir milimetre hareket edip başlangıç noktasına geri gelmesine sebep olacaktır. (Sonlandırıcı position_endstop=0 konumunda tanımlanmış ise her hareket başlangıcında step motor sonlandırıcıdan uzaklaşacaktır.) Bu salınım hareketini on kere tekrarlayacaktır.

Step motor hiç hareket etmez ise motorun "enable_pin" ve "step_pin" ayarlarını doğrulayın. Step motor hareket eder ama orjinal pozisyonuna dönmez ise "dir_pin" ayarını doğrulayın. Motor yanlış bir yönde salınım yaparsa bu genellikle o eksene ait "dir_pin" değerinin ters çevrilmesi gerektiğini işaret eder. Yazıcı konfigürasyon dosyasındaki "dir_pin" değerine "!" eklenerek (veya zaten var ise silinerek) bu işlem gerçekleştirilir. Motor bir milimetreden önemli ölçüde az veya fazla hareket ederse "rotation_distance" ayarını doğrulayın.

Yukarıdaki testi konfigürasyon dosyasında tanımlanan her step motor için çalıştır. (STEPPER_BUZZ komutundaki STEPPER parametresininin değerini test edilecek konfigürasyon bölümünün adı yapın.) Ekstrüderde filaman yok ise STEPPER_BUZZ komutunu ekstrüder motoru bağlantısını doğrulamak için kullanabilirsiniz (STEPPER=extruder yapın). Aksi halde, en iyisi ekstrüder motorunu ayrıca test etmektir (bir sonraki bölüme bakınız).

Bütün sonlandırıcılar ve step motorlar doğrulandıktan sonra hedef arama mekanizması test edilmelidir. Bütün eksenleri hedeflemek için G28 komutunu çalıştırın. Hedefleme doğru yapılmıyorsa yazıcıyı güçten çekin. Gerekirse sonlandırıcı ve step motor doğrulama adımlarını yeniden çalıştırın.

## Ekstrüder motorunu doğrula

Ekstrüder motorunu test etmek için ekstrüderi bir yazdırma sıcaklığına ulaştırmak gerekmektedir. Octoprint sıcaklık sekmesine gidin ve sıcaklık açılır kutusundan bir hedef sıcaklık seçin (veya el ile uygun bir sıcaklık girin). Yazıcının istenen sıcaklığa ulaşmasını bekleyin. Daha sonra, Octoprint kontrol sekmesine gidin ve "Çıkar" butonuna basın. Ekstrüder motorunun doğru yönde döndüğünü doğrulayın. Değilse, ekstrüderin "enable_pin", "step_pin" ve "dir_pin" ayarlarını onaylamak için bir önceki bölümdeki sorun giderme ipuçlarına bakın.

## PID kalibrasyon ayarları

Klipper, ekstrüder ve baskı yatağı ısıtıcıları için [PID kontrolünü](https://en.wikipedia.org/wiki/PID_controller) destekler. Bu kontrol mekanizmasını kullanmak için PID ayarları her yazıcı için ayrıca kalibre edilmelidir (diğer aygıt yazılımlarında veya örnek konfigürasyon dosyalarında bulunan PID ayarları genellikle kötü bir performans sergiler).

Ekstrüderi kalibre etmek için OctoPrint terminal sekmesine gidin ve PID_CALIBRATE komutunu çalıştırın. Örneğin: `PID_CALIBRATE HEATER=extruder TARGET=170`

Yeni PID ayarlarını printer.cfg dosyasına yazmak için ayar testi bitiminde `SAVE_CONFIG` komutunu çalıştırın.

Yazıcı ısıtılmış bir baskı yatağına sahipse ve PWM (Pulse Width Modulation) ile sürülmeyi destekliyorsa baskı yatağı için PID kontrolü kullanılması önerilir. (Baskı yatağı ısıtıcısı bir PID algoritması ile kontrol ediliyorsa saniyede on kere açılıp kapanabilir, bu durum mekanik anahtar kullanan ısıtıcılar için uygun olmayabilir.) Tipik bir baskı yatağı PID kalibrasyonu komutu şu şekildedir: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Sonraki adımlar

Bu kılavuz, Klipper konfigürasyon dosyasındaki pin ayarlarının temel doğrulamasına yardımcı olmayı amaçlamaktadır. [Yatak düzeyleme](Bed_Level.md) kılavuzunu mutlaka okuyunuz. Ayrıca Klipper ile dilimleyici yapılandırma hakkında bilgi sahibi olmak için [Dilimleyiciler](Slicers.md) dokümanına bakınız.

Temel yazdırma işleminin çalıştığı doğrulandıktan sonra [basınç avansını](Pressure_Advance.md) kalibre etmeyi değerlendirmek iyi bir fikir olacaktır.

Başka detaylı yazıcı kalibrasyonu tiplerinin uygulanmasına ihtiyaç duyulabilir - bu konuda destek alınabilecek online kılavuzlar mevcuttur (mesela, webde şunu aratın: "üç boyutlu yazıcı kalibrasyonu"). Örnek olarak, ringing denen etki ile karşılaşırsanız [rezonans dengeleme](Resonance_Compensation.md) ayar kılavuzunu takip edebilirsiniz.
