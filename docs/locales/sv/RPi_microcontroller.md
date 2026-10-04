# RPi-mikrokontroller

Det här dokumentet beskriver hur Klipper körs på en RPi och hur samma RPi används som sekundär MCU.

## Varför använda RPi som sekundär MCU?

MCU:er som styr 3D-skrivare har ofta ett begränsat och förkonfigurerat antal exponerade stift för huvudfunktionerna, som termistorer, extrudrar och stegmotorer. Genom att använda den RPi där Klipper är installerat som sekundär MCU kan Klipper använda RPi:ns GPIO och bussar (I2C, SPI) direkt, utan OctoPrint-insticksmoduler eller externa program, och styra allt från utskriftens G-kod.

**Varning:** Om plattformen är en *Beaglebone* och installationsstegen har följts korrekt är Linux-MCU:n redan installerad och konfigurerad för systemet.

## Installera rc-skriptet

Om värden ska användas som sekundär MCU måste processen `klipper_mcu` köras före processen `klippy`.

Installera skriptet efter att Klipper har installerats. Kör:

```
cd ~/klipper/
sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
```

## Bygga mikrokontrollerkoden

Konfigurera först Klippers mikrokontrollerkod för "Linux process" för att kompilera den:

```
cd ~/klipper/
make menuconfig
```

Ställ in "Microcontroller Architecture" på "Linux process", spara och avsluta.

Kör följande för att bygga och installera den nya mikrokontrollerkoden:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Om klippy.log rapporterar felet "Permission denied" när den ansluter till `/tmp/klipper_host_mcu` måste användaren läggas till i gruppen tty. Följande kommando lägger till användaren "pi" i gruppen tty:

```
sudo usermod -a -G tty pi
```

## Återstående konfiguration

Slutför installationen genom att konfigurera Klippers sekundära MCU enligt [exempelkonfigurationen för Raspberry Pi](../config/sample-raspberry-pi.cfg) och [exempelkonfigurationen för flera MCU:er](../config/sample-multi-mcu.cfg).

## Valfritt: Aktivera SPI

Kontrollera att Linux SPI-drivrutinen är aktiverad genom att köra `sudo raspi-config` och aktivera SPI i menyn "Interfacing options".

## Valfritt: Aktivera I2C

Kontrollera att Linux I2C-drivrutinen är aktiverad genom att köra `sudo raspi-config` och aktivera I2C i menyn "Interfacing options". Om I2C ska användas för MPU-accelerometern måste även överföringshastigheten ställas in på 400000 genom att lägga till eller avkommentera `dtparam=i2c_arm=on,i2c_arm_baudrate=400000` i `/boot/config.txt` (eller `/boot/firmware/config.txt` i vissa distributioner).

## Valfritt: Identifiera rätt gpiochip

På Raspberry Pi och många kloner tillhör GPIO-stiften normalt det första gpiochipet. De kan därför användas i Klipper som `gpio0..n`. I vissa fall tillhör stiften andra gpiochip, exempelvis på vissa OrangePi-modeller eller vid användning av en portexpander. Använd då kommandona för *Linux GPIO character device* för att kontrollera konfigurationen.

Kör följande för att installera *Linux GPIO character device - binary* på en Debian-baserad distribution som OctoPi:

```
sudo apt-get install gpiod
```

Kör följande för att kontrollera tillgängliga gpiochip:

```
gpiodetect
```

Kör följande för att kontrollera stiftnummer och stiftets tillgänglighet:

```
gpioinfo
```

Det valda stiftet kan sedan användas i konfigurationen som `gpiochip<n>/gpio<o>`, där **n** är chipnumret som visas av `gpiodetect` och **o** är radnumret som visas av `gpioinfo`.

***Varning:*** Endast GPIO som är markerade som `unused` kan användas. En *line* kan inte användas av flera processer samtidigt.

Exempel på en RPi 3B+ där Klipper använder GPIO20 för en brytare:

```
$ gpiodetect
gpiochip0 [pinctrl-bcm2835] (54 lines)
gpiochip1 [raspberrypi-exp-gpio] (8 lines)

$ gpioinfo
gpiochip0 - 54 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       unused   input  active-high
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
        line   8:      unnamed       unused   input  active-high
        line   9:      unnamed       unused   input  active-high
        line  10:      unnamed       unused   input  active-high
        line  11:      unnamed       unused   input  active-high
        line  12:      unnamed       unused   input  active-high
        line  13:      unnamed       unused   input  active-high
        line  14:      unnamed       unused   input  active-high
        line  15:      unnamed       unused   input  active-high
        line  16:      unnamed       unused   input  active-high
        line  17:      unnamed       unused   input  active-high
        line  18:      unnamed       unused   input  active-high
        line  19:      unnamed       unused   input  active-high
        line  20:      unnamed    "klipper"  output  active-high [used]
        line  21:      unnamed       unused   input  active-high
        line  22:      unnamed       unused   input  active-high
        line  23:      unnamed       unused   input  active-high
        line  24:      unnamed       unused   input  active-high
        line  25:      unnamed       unused   input  active-high
        line  26:      unnamed       unused   input  active-high
        line  27:      unnamed       unused   input  active-high
        line  28:      unnamed       unused   input  active-high
        line  29:      unnamed       "led0"  output  active-high [used]
        line  30:      unnamed       unused   input  active-high
        line  31:      unnamed       unused   input  active-high
        line  32:      unnamed       unused   input  active-high
        line  33:      unnamed       unused   input  active-high
        line  34:      unnamed       unused   input  active-high
        line  35:      unnamed       unused   input  active-high
        line  36:      unnamed       unused   input  active-high
        line  37:      unnamed       unused   input  active-high
        line  38:      unnamed       unused   input  active-high
        line  39:      unnamed       unused   input  active-high
        line  40:      unnamed       unused   input  active-high
        line  41:      unnamed       unused   input  active-high
        line  42:      unnamed       unused   input  active-high
        line  43:      unnamed       unused   input  active-high
        line  44:      unnamed       unused   input  active-high
        line  45:      unnamed       unused   input  active-high
        line  46:      unnamed       unused   input  active-high
        line  47:      unnamed       unused   input  active-high
        line  48:      unnamed       unused   input  active-high
        line  49:      unnamed       unused   input  active-high
        line  50:      unnamed       unused   input  active-high
        line  51:      unnamed       unused   input  active-high
        line  52:      unnamed       unused   input  active-high
        line  53:      unnamed       unused   input  active-high
gpiochip1 - 8 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       "led1"  output   active-low [used]
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
```

## Valfritt: Maskinvaru-PWM

Raspberry Pi har två PWM-kanaler, PWM0 och PWM1, som är exponerade på stifthuvudet eller kan ledas till befintliga GPIO-stift. Linux-MCU-demonen använder pwmchip-sysfs-gränssnittet för att styra maskinvaru-PWM på Linux-värdar. PWM-sysfs-gränssnittet är inte exponerat som standard på Raspberry Pi men kan aktiveras genom att lägga till en rad i `/boot/config.txt`:

```
# Enable pwmchip sysfs interface
dtoverlay=pwm,pin=12,func=4
```

Det här exemplet aktiverar endast PWM0 och leder den till gpio12. Om båda PWM-kanalerna behöver aktiveras kan `pwm-2chan` användas:

```
# Enable pwmchip sysfs interface
dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4
```

Det här exemplet aktiverar även PWM1 och leder den till gpio13.

Överlägget exponerar inte PWM-raden i sysfs vid uppstart utan den måste exporteras genom att PWM-kanalens nummer skickas med echo till `/sys/class/pwm/pwmchip0/export`. Då skapas enheten `/sys/class/pwm/pwmchip0/pwm0` i filsystemet. Det enklaste är att lägga till följande i `/etc/rc.local` före raden `exit 0`:

```
# Enable pwmchip sysfs interface
echo 0 > /sys/class/pwm/pwmchip0/export
```

När båda PWM-kanalerna används måste även numret på den andra kanalen skickas med echo:

```
# Enable pwmchip sysfs interface
echo 0 > /sys/class/pwm/pwmchip0/export
echo 1 > /sys/class/pwm/pwmchip0/export
```

När sysfs finns på plats kan du använda PWM-kanalerna genom att lägga till följande konfiguration i `printer.cfg`:

```
[output_pin caselight]
pin: host:pwmchip0/pwm0
pwm: True
hardware_pwm: True
cycle_time: 0.000001

[output_pin beeper]
pin: host:pwmchip0/pwm1
pwm: True
hardware_pwm: True
value: 0
shutdown_value: 0
cycle_time: 0.0005
```

Det här lägger till maskinvaru-PWM-styrning för gpio12 och gpio13 på Pi, eftersom överlägget konfigurerades för att leda pwm0 till pin=12 och pwm1 till pin=13.

PWM0 kan ledas till gpio12 och gpio18, och PWM1 till gpio13 och gpio19:

| PWM | GPIO-stift | Funktion |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
