# Микроконтролер RPi

Този документ описва процеса на стартиране на Klipper на RPi и използване на същия RPi като вторичен mcu.

## Защо да използвате RPi като вторичен MCU?

Често MCU устройствата, предназначени за управление на 3D принтери, имат ограничен и предварително конфигуриран брой изводи за управление на основните функции за печат (термични резистори, екструдери, степери...). Използването на RPi, в който е инсталиран Klipper, като вторичен MCU дава възможност за директно използване на GPIO и шините (i2c, spi) на RPi в Klipper, без да се използват плъгини на Octoprint (ако се използват) или външни програми, което дава възможност за управление на всичко в рамките на GCODE за печат.

**Предупреждение**: Ако вашата платформа е *Beaglebone* и сте спазили правилно стъпките за инсталиране, Linux mcu вече е инсталиран и конфигуриран за вашата система.

## Инсталиране на скрипта rc

Ако искате да използвате хоста като вторичен MCU, процесът klipper_mcu трябва да се стартира преди процеса klippy.

След като инсталирате Klipper, инсталирайте скрипта. стартирайте:

```
cd ~/klipper/
sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
```

## Изграждане на кода на микроконтролера

За да компилирате кода на микроконтролера Klipper, започнете с конфигурирането му за "Linux процес":

```
cd ~/klipper/
make menuconfig
```

В менюто задайте "Microcontroller Architecture" (Архитектура на микроконтролера) на "Linux process", след което запазете и излезте.

За да сглобите и инсталирате новия код на микроконтролера, изпълнете:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Ако klippy.log съобщава за грешка "Permission denied" (отказ на разрешение) при опит за свързване към `/tmp/klipper_host_mcu`, тогава трябва да добавите своя потребител към групата tty. Следната команда ще добави потребителя "pi" към групата tty:

```
sudo usermod -a -G tty pi
```

## Остатъчна конфигурация

Завършете инсталацията, като конфигурирате вторичния MCU на Klipper, следвайки инструкциите в [RaspberryPi sample config](../config/sample-raspberry-pi.cfg) и [Multi MCU sample config](../config/sample-multi-mcu.cfg).

## По избор: Включване на SPI

Уверете се, че SPI драйверът на Linux е активиран, като стартирате `sudo raspi-config` и активирате SPI в менюто "Interfacing options".

## По избор: Включване на I2C

Уверете се, че драйверът I2C на Linux е активиран, като стартирате `sudo raspi-config` и активирате I2C в менюто "Interfacing options". Ако планирате да използвате I2C за акселерометъра на MPU, е необходимо също така да зададете скорост на предаване на данни 400000, като: добавите/отмените коментара на `dtparam=i2c_arm=on,i2c_arm_baudrate=400000` в `/boot/config.txt` (или `/boot/firmware/config.txt` в някои дистрибуции).

## По избор: Идентифицирайте правилния gpiochip

На Raspberry Pi и на много клонинги изложените на GPIO щифтове принадлежат на първия gpiochip. Поради това те могат да се използват в klipper просто като се посочат с името `gpio0..n`. Съществуват обаче случаи, при които изложените изводи принадлежат на gpioчипове, различни от първия. Например при някои модели OrangePi или ако се използва разширител на портове. В тези случаи е полезно да използвате командите за достъп до *Linux GPIO character device*, за да проверите конфигурацията.

За да инсталирате *Linux GPIO character device - binary* на базирана на Debian дистрибуция като octopi, стартирайте:

```
sudo apt-get install gpiod
```

За да проверите наличния gpiochip, стартирайте:

```
gpiodetect
```

За да проверите номера на пина и наличността на пина, тунирайте:

```
gpioinfo
```

Така избраният пин може да се използва в конфигурацията като `gpiochip<n>/gpio<o>`, където **n** е номерът на чипа, видян от командата `gpiodetect`, а **o** е номерът на линията, видян от командата `gpioinfo`.

***Предупреждение:*** могат да се използват само gpio, маркирани като `unused`. Не е възможно една *линия* да се използва от няколко процеса едновременно.

Например на RPi 3B+, където klipper използва GPIO20 за превключвател:

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

## По избор: Хардуерна ШИМ

Raspberry Pi имат два ШИМ канала (ШИМ0 и ШИМ1), които са изложени на хедъра или, ако не са, могат да бъдат насочени към съществуващи gpio щифтове. Демонът Linux mcu използва интерфейса pwmchip sysfs за управление на хардуерни pwm устройства на Linux хостове. Интерфейсът pwm sysfs не е достъпен по подразбиране на Raspberry и може да бъде активиран чрез добавяне на ред в `/boot/config.txt`:

```
# Enable pwmchip sysfs interface
dtoverlay=pwm,pin=12,func=4
```

Този пример активира само PWM0 и го насочва към gpio12. Ако трябва да се активират и двата ШИМ канала, можете да използвате `pwm-2chan`:

```
# Enable pwmchip sysfs interface
dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4
```

Този пример допълнително активира PWM1 и го насочва към gpio13.

Покритието не разкрива pwm линията в sysfs при зареждане и трябва да бъде експортирано чрез ехо на номера на pwm канала към `/sys/class/pwm/pwmchip0/export`. Това ще създаде устройство `/sys/class/pwm/pwmchip0/pwm0` във файловата система. Най-лесният начин да направите това е като добавите това в `/etc/rc.local` преди реда `exit 0`:

```
# Enable pwmchip sysfs interface
echo 0 > /sys/class/pwm/pwmchip0/export
```

Когато използвате двата ШИМ канала, номерът на втория канал също трябва да се повтори:

```
# Enable pwmchip sysfs interface
echo 0 > /sys/class/pwm/pwmchip0/export
echo 1 > /sys/class/pwm/pwmchip0/export
```

След като sysfs е на мястото си, вече можете да използвате pwm канала(ите), като добавите следната част от конфигурацията към вашия `printer.cfg`:

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

Това ще добави хардуерно управление на pwm към gpio12 и gpio13 на Pi (защото наслагването е конфигурирано да насочва pwm0 към pin=12 и pwm1 към pin=13).

PWM0 може да се насочи към gpio12 и gpio18, а PWM1 може да се насочи към gpio13 и gpio19:

| PWM | gpio PIN | FuncFunc |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
