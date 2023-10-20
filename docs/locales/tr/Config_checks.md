# Konfigürasyon denetimi

Bu doküman Klipper printer.cfg dosyasında bulunan pin ayarları için bir dizi adım içermektedir. Bu adımların [yükleme dokümanı](Installation.md) içinde yer alan adımları takip ettikten sonra izlenmesi tavsiye edilir.

Bu klavuz sırasında Klipper konfigürasyon dosyasında değişiklik yapılması gerekebilir. Konfigürasyon dosyasında yapılan her değişiklikten sonra RESTART komutunu vererek değişikliklerin etkin olduğundan emin olun (Octoprint terminal sekmesinde "restart" yazıp "Send" butonuna tıklayın). Her RESTART sonrasında STATUS komutunu çalıştırıp konfigürasyon dosyasının başarıyla okunduğunu doğrulamak iyi bir fikir olacaktır.

## Sıcaklığı doğrula

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## M112 doğrula

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Isıtıcıları doğrula

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Yazıcı ısıtılmış bir baskı yatağına sahip ise yukarıdaki testi baskı yatağı ile tekrarlayın.

## Step motorun enable pinini doğrulayın

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Sonlandırıcıları doğrula

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Sonlandırıcıda hiçbir değişiklik olmuyorsa bu genellikle sonlandırıcının başka bir pine bağlı olduğunu işaret eder. Ancak bu, pine ait pullup ayarının değiştirilmesini de gerektirebilir (endstop_pin isminin başındaki '^' - çoğu yazıcı bir pullup direnci kullanır ve '^' zaten bulunmalıdır).

## Step motorları doğrula

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Step motor hiç hareket etmez ise motorun "enable_pin" ve "step_pin" ayarlarını doğrulayın. Step motor hareket eder ama orjinal pozisyonuna dönmez ise "dir_pin" ayarını doğrulayın. Motor yanlış bir yönde salınım yaparsa bu genellikle o eksene ait "dir_pin" değerinin ters çevrilmesi gerektiğini işaret eder. Yazıcı konfigürasyon dosyasındaki "dir_pin" değerine "!" eklenerek (veya zaten var ise silinerek) bu işlem gerçekleştirilir. Motor bir milimetreden önemli ölçüde az veya fazla hareket ederse "rotation_distance" ayarını doğrulayın.

Yukarıdaki testi konfigürasyon dosyasında tanımlanan her step motor için çalıştır. (STEPPER_BUZZ komutundaki STEPPER parametresininin değerini test edilecek konfigürasyon bölümünün adı yapın.) Ekstrüderde filaman yok ise STEPPER_BUZZ komutunu ekstrüder motoru bağlantısını doğrulamak için kullanabilirsiniz (STEPPER=extruder yapın). Aksi halde, en iyisi ekstrüder motorunu ayrıca test etmektir (bir sonraki bölüme bakınız).

Bütün sonlandırıcılar ve step motorlar doğrulandıktan sonra hedef arama mekanizması test edilmelidir. Bütün eksenleri hedeflemek için G28 komutunu çalıştırın. Hedefleme doğru yapılmıyorsa yazıcıyı güçten çekin. Gerekirse sonlandırıcı ve step motor doğrulama adımlarını yeniden çalıştırın.

## Ekstrüder motorunu doğrula

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## PID kalibrasyon ayarları

Klipper, ekstrüder ve baskı yatağı ısıtıcıları için [PID kontrolünü](https://en.wikipedia.org/wiki/PID_controller) destekler. Bu kontrol mekanizmasını kullanmak için PID ayarları her yazıcı için ayrıca kalibre edilmelidir (diğer aygıt yazılımlarında veya örnek konfigürasyon dosyalarında bulunan PID ayarları genellikle kötü bir performans sergiler).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

Yeni PID ayarlarını printer.cfg dosyasına yazmak için ayar testi bitiminde `SAVE_CONFIG` komutunu çalıştırın.

Yazıcı ısıtılmış bir baskı yatağına sahipse ve PWM (Pulse Width Modulation) ile sürülmeyi destekliyorsa baskı yatağı için PID kontrolü kullanılması önerilir. (Baskı yatağı ısıtıcısı bir PID algoritması ile kontrol ediliyorsa saniyede on kere açılıp kapanabilir, bu durum mekanik anahtar kullanan ısıtıcılar için uygun olmayabilir.) Tipik bir baskı yatağı PID kalibrasyonu komutu şu şekildedir: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Sonraki adımlar

Bu kılavuz, Klipper konfigürasyon dosyasındaki pin ayarlarının temel doğrulamasına yardımcı olmayı amaçlamaktadır. [Yatak düzeyleme](Bed_Level.md) kılavuzunu mutlaka okuyunuz. Ayrıca Klipper ile dilimleyici yapılandırma hakkında bilgi sahibi olmak için [Dilimleyiciler](Slicers.md) dokümanına bakınız.

Temel yazdırma işleminin çalıştığı doğrulandıktan sonra [basınç avansını](Pressure_Advance.md) kalibre etmeyi değerlendirmek iyi bir fikir olacaktır.

Başka detaylı yazıcı kalibrasyonu tiplerinin uygulanmasına ihtiyaç duyulabilir - bu konuda destek alınabilecek online kılavuzlar mevcuttur (mesela, webde şunu aratın: "üç boyutlu yazıcı kalibrasyonu"). Örnek olarak, ringing denen etki ile karşılaşırsanız [rezonans dengeleme](Resonance_Compensation.md) ayar kılavuzunu takip edebilirsiniz.
