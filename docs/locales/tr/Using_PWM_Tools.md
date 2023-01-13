# PWM Araçlarını Kullanmak

Bu doküman, `output_pin` ve bazı makrolar kullanılarak PWM kontrollü bir lazerin veya spindle (freze) motorunun nasıl kurulacağını açıklar.

## Nasıl çalışıyor?

3D baskı kafasının fan pwm çıkışını yeniden kullanarak lazerleri veya spindle (freze) motorunu kontrol edebilirsiniz. Bu, örneğin E3D takım değiştirici veya kendi tasarımınız olan bir değiştirilebilir baskı kafası kullanıyorsanız kullanışlıdır. Genellikle, LaserWeb gibi CAM araçları, *spinde speed CW* (`M3 S[0-255]`), *spindle speed CCW* (`M4 S[0-255]`) ve *spindle stop* (`M5`) anlamına gelen `M3-M5` komutlarını kullanacak şekilde yapılandırılabilir.

**Uyarı:** Lazer kullanırken aklınıza gelebilecek tüm güvenlik önlemlerini alınız! Diyot lazerler genellikle ters bağlantılıdır. Bu, MCU yeniden başlatıldığında, MCU'nun yeniden başlaması için gereken süre boyunca lazerin *tamamen açık* olacağı anlamına gelir. İyi bir ölçüm için, lazere güç veriliyorsa gerekmedikçe lazerin bağlantısını kesmemeniz ve *her zaman* kullandığınız lazerin dalga boyuna uygun lazer gözlüğü takmanız önerilir. Ayrıca, ana makineniz veya MCU'nuz bir hatayla karşılaştığında aracın durması için bir güvenlik zaman aşımı süresi yapılandırmanız gerekmektedir.

Örnek ayarlar için, [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg)'u ziyaret ediniz.

## Mevcut Sınırlamalar

PWM güncellemelerinin ne sıklıkta gerçekleşebileceği konusunda bir sınır mevcuttur. Çok kesin olmakla birlikte, bir PWM güncellemesi yalnızca her 0,1 saniyede bir gerçekleşebilir ve raster gravür işleriniz için kullanılması imkansız bir değerdir. Ancak, bazı konularda ödün vermeniz gerekebilen bir [deneysel branch (dal)](https://github.com/Cirromulus/klipper/tree/laser_tool) mevcuttur. Uzun vadede bu özelliğin main-line Klipper'a entegre edilmesi planlanmaktadır.

## Komutlar

`M3/M4 S<value>` : PWM döngüsünü ayarlar. Kullanabileceğiniz değerler 0 ve 255 arasındadır. `M5` : PWM çıkışını kapalı konumdaki değere eşitler.

## Laserweb Ayarları

Eğer Laserweb kullanıyorsanız, ayarlarınız aşağıdaki gibi olmalıdır:

    GCODE START:
        M5            ; Lazeri durdur
        G21           ; Ölçü birimini mm'ye ayarla
        G90           ; Mutlak konumlandırma
        G0 Z0 F7000   ; Kesmeme hızını ayarla
    
    GCODE END:
        M5            ; Lazeri durdur
        G91           ; Göreceli konumlandırma
        G0 Z+20 F4000 ;
        G90           ; Mutlak konumlandırma
    
    GCODE HOMING:
        M5            ; Lazeri durdur
        G28           ; Tüm eksenleri hizala
    
    TOOL ON:
        M3 $INTENSITY
    
    TOOL OFF:
        M5            ; Lazeri durdur
    
    LASER INTENSITY:
        S
