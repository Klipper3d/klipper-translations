# RPi Mikrocontroller

Dieses Dokument beschreibt den Prozess, Klipper auf einem Raspberry Pi laufen zu lassen und denselben Raspberry Pi als sekundäre Steuerung zu verwenden.

## Warum sollte man den Raspberry Pi als zweite MCU verwenden?

Oft haben die MCU's der 3D Drucker nur eine begrenzte Anzahl an Ein und Ausgängen um die grundlegenden Funktionalitäten (Thermistoren, Extruder, Schrittmotor...) dieser zu steuern. Den Raspberry pi als sekundäre MCU zu nutzen erlaubt es die GPIOs und verwendbaren Buse wie (i2c, spi) direkt in Klipper zu verwenden ohne auf Plugins in Octoprint (falls verwendet) Zurückgreifen zu müssen, oder andere Programme über GCODE befehle diese zu verwenden.

**Warnung**: Wenn Ihre Plattform ein *Beaglebone* ist und Sie die Installationsschritte korrekt befolgt haben, ist die Linux-MCU bereits installiert und für Ihr System konfiguriert.

## Installieren Sie das rc Skript

Wenn Sie den Host als sekundäre MCU verwenden wollen, muss der klipper_mcu Prozess vor dem klippy Prozess laufen.

Nach der Installation von Klipper installieren Sie das Skript. Führen sie dafür folgenden Befehl aus:

```
cd ~/klipper/
sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
```

## Erstellung des Mikrocontroller Codes

Um den Code des Klipper Mikrocontrollers zu kompilieren, müssen Sie ihn zunächst für den "Linux-Prozess" konfigurieren:

```
cd ~/klipper/
make menuconfig
```

Stellen Sie im Menü "Microcontroller Architecture" auf "Linux process", speichern und beenden Sie das Programm.

Um den neuen Mikrocontroller-Code zu erzeugen und zu installieren, führen Sie aus:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Wenn klippy.log einen "Permission denied" Fehler meldet, wenn Sie versuchen, sich mit `/tmp/klipper_host_mcu` zu verbinden, dann müssen Sie Ihren Benutzer zu der tty Gruppe hinzufügen. Der folgende Befehl fügt den Benutzer "pi" zur tty Gruppe hinzu:

```
sudo usermod -a -G tty pi
```

## Restliche Konfiguration

Schließen Sie die Installation ab, indem Sie die sekundäre Klipper MCU gemäß den Anweisungen in [RaspberryPi sample config](../config/sample-raspberry-pi.cfg) und [Multi MCU sample config](../config/sample-multi-mcu.cfg) konfigurieren.

## Optional: SPI aktivieren

Vergewissern Sie sich, dass der Linux-SPI-Treiber aktiviert ist, indem Sie `sudo raspi-config` ausführen und SPI im Menü "Interfacing options" aktivieren.

## Optional: I2C aktivieren

Stellen Sie sicher, dass der Linux I2C-Treiber aktiviert ist, indem Sie `sudo raspi-config` ausführen und I2C im Menü "Interfacing options" aktivieren. Wenn Sie I2C für den MPU Beschleunigungsmesser verwenden möchten, müssen Sie auch die Baudrate auf 400000 einstellen, indem Sie `dtparam=i2c_arm=on,i2c_arm_baudrate=400000` in `/boot/config.txt` (oder `/boot/firmware/config.txt` in einigen Distributionen) hinzufügen/entfernen.

## Optional: Den richtigen Gpiochip identifizieren

On Raspberry Pi and on many clones the pins exposed on the GPIO belong to the first gpiochip. They can therefore be used on klipper simply by referring them with the name `gpio0..n`. However, there are cases in which the exposed pins belong to gpiochips other than the first. For example in the case of some OrangePi models or if a Port Expander is used. In these cases it is useful to use the commands to access the *Linux GPIO character device* to verify the configuration.

Um das *Linux GPIO character device - binary* auf einer debian basierten Distribution wie octopi zu installieren, führen Sie aus:

```
sudo apt-get install gpiod
```

Um den verfügbaren gpiochip zu testen, führen Sie aus:

```
gpiodetect
```

Überprüfen Sie die Pin Nummer und die Verfügbarkeit der Pins:

```
gpioinfo
```

The chosen pin can thus be used within the configuration as `gpiochip<n>/gpio<o>` where **n** is the chip number as seen by the `gpiodetect` command and **o** is the line number seen by the` gpioinfo` command.

***Warnung:*** nur als `unused` markierte gpio können verwendet werden. Es ist nicht möglich, dass eine *Leitung* von mehreren Prozessen gleichzeitig verwendet wird.

Zum Beispiel auf einem RPi 3B+, wo Klipper den GPIO20 für einen Schalter verwendet:

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

## Optional: Hardware PWM

Raspberry Pi's haben zwei PWM Kanäle (PWM0 und PWM1), die auf dem Header freigelegt sind oder, falls nicht, auf bestehende gpio Pins geroutet werden können. Der Linux mcu Daemon verwendet die pwmchip sysfs Schnittstelle, um Hardware PWM-Geräte auf Linux Hosts zu steuern. Die pwm sysfs Schnittstelle ist auf einem Raspberry standardmäßig nicht verfügbar und kann durch Hinzufügen einer Zeile in `/boot/config.txt` aktiviert werden:

```
# Aktivieren der pwmchip sysfs Schnittstelle
dtoverlay=pwm,pin=12,func=4
```

Dieses Beispiel aktiviert nur PWM0 und leitet es an gpio12. Wenn beide PWM-Kanäle aktiviert werden müssen, können Sie `pwm-2chan` verwenden:

```
# Aktivieren der pwmchip sysfs Schnittstelle
dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4
```

In diesem Beispiel wird zusätzlich PWM1 aktiviert und an gpio13 geleitet.

Das Overlay legt die pwm Zeile auf sysfs beim Booten nicht frei und muss durch Echo'ing der Nummer des pwm Kanals nach '/sys/class/pwm/pwmchip0/export' exportiert werden. Dadurch wird das Gerät '/sys/class/pwm/pwmchip0/pwm0' im Dateisystem erstellt. Der einfachste Weg dies zu tun ist, indem Folgendes, vor die Zeile 'exit 0' in der datei '/etc/rc.local' eingefügt wird:

```
# Aktivieren der pwmchip sysfs Schnittstelle
echo 0 > /sys/class/pwm/pwmchip0/export
```

Wenn Sie beide PWM Kanäle verwenden, muss die Nummer des zweiten Kanals ebenfalls mit einem Echo versehen werden:

```
# Aktivieren der pwmchip sysfs Schnittstelle
echo 0 > /sys/class/pwm/pwmchip0/export
echo 1 > /sys/class/pwm/pwmchip0/export
```

Nachdem die sysfs eingerichtet ist, können Sie nun entweder den/die pwm-Kanal/Kanäle verwenden, indem Sie den folgenden Teil der Konfiguration zu Ihrer `printer.cfg` hinzufügen:

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

Dies fügt Hardware Pwm-Steuerung zu gpio12 und gpio13 auf dem Pi hinzu (weil das Overlay so konfiguriert wurde, dass pwm0 zu pin=12 und pwm1 zu pin=13 geleitet wird).

PWM0 kann auf gpio12 und gpio18 geroutet werden, PWM1 kann auf gpio13 und gpio19 geroutet werden:

| PWM | gpio PIN | Funktion |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
