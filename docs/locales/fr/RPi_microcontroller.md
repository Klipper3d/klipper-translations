# Microcontrôleur RPi

Ce document décrit le processus via lequel il est possible de lancer Klipper sur un Raspberry Pi et d'utiliser le même Raspberry Pi comme mcu secondaire.

## Pourquoi utiliser un RPi comme microcontrôleur secondaire ?

Souvent les microcontrôleurs dédiés au contrôle des imprimantes 3D disposent d'un nombre limité et pré-configuré de broches exposées pour gérer les principales fonctions d'impression (résistances thermiques, extrudeuses, steppers...). L'utilisation du RPi où Klipper est installé en tant que MCU secondaire donne la possibilité d'utiliser directement les GPIO et les bus (i2c, spi) du RPi à l'intérieur de klipper sans utiliser de plugins Octoprint (le cas échéant) ou de programmes externes donnant la possibilité de tout contrôler à l'intérieur l'impression GCODE.

**Avertissement** : Si votre plate-forme est un *Beaglebone* et que vous avez correctement suivi les étapes d'installation, le mcu linux est déjà installé et configuré pour votre système.

## Installer le script rc

Si vous souhaitez utiliser l'hôte comme MCU secondaire, le processus klipper_mcu doit s'exécuter avant le processus klippy.

Après avoir installé Klipper, installez le script. Executez :

```
cd ~/klipper/
sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
```

## Construire le code du microcontrôleur

Pour compiler le code du micro-contrôleur Klipper, commencez par le configurer pour le "Linux process" :

```
cd ~/klipper/
make menuconfig
```

Dans le menu, définissez "Architecture du microcontrôleur" sur "Processus Linux", puis enregistrez et quittez.

Pour compiler et installer le nouveau code du microcontrôleur, exécutez :

```
sudo service klipper stop
make flash
sudo service klipper start
```

Si klippy.log signale une erreur "Autorisation refusée" lors de la tentative de connexion à `/tmp/klipper_host_mcu`, vous devez ajouter votre utilisateur au groupe tty. La commande suivante ajoutera l'utilisateur "pi" au groupe tty :

```
sudo usermod -a -G tty pi
```

## Configuration restante

Terminez l'installation en configurant le MCU secondaire de Klipper en suivant les instructions dans [RaspberryPi exemlple de configuration](../config/sample-raspberry-pi.cfg) et [Exemples de configuration Multi MCU](../config/sample-multi-mcu.cfg).

## Facultatif : Activer SPI

Assurez-vous que le pilote SPI Linux est activé en exécutant `sudo raspi-config` et en activant SPI dans le menu « Options d’interface ».

## Facultatif : Activer I2C

Assurez-vous que le pilote Linux I2C est activé en exécutant `sudo raspi-config` et en activant I2C dans le menu "Interfacing options". Si vous prévoyez d'utiliser I2C pour l'accéléromètre MPU, il est également nécessaire de définir le débit en bauds sur 400 000 en : ajoutant/décommentant `dtparam=i2c_arm=on,i2c_arm_baudrate=400000` dans `/boot/config. txt` (ou `/boot/firmware/config.txt` dans certaines distributions).

## Facultatif : identifiez la bonne puce gpio

Sur Raspberry Pi et sur de nombreux clones, les broches disponibles sur le connecteur GPIO appartiennent à la première puce gpio. Ils peuvent donc être utilisés sur klipper simplement en les référençant avec le nom `gpio0..n`. Cependant, il existe des cas dans lesquels les broches disponibles appartiennent à des puces gpio autres que la première. Par exemple dans le cas de certains modèles OrangePi ou si un "Port Expander" est utilisé. Dans ces cas, il est utile d'utiliser les commandes pour accéder au *Périphérique de caractères GPIO Linux* pour vérifier la configuration.

Pour installer le périphérique de caractères *Linux GPIO - binaire * sur une distribution basée sur Debian comme Octopi, exécutez :

```
sudo apt-get install gpiod
```

Pour vérifier la puce gpio disponible exécutez :

```
gpiodetect
```

Pour vérifier la numérotation des broches du connecteur GPIO et leur disponibilité, exécutez :

```
gpioinfo
```

La broche choisie peut donc être utilisée dans la configuration comme `gpiochip<n>/gpio<o>` où **n** est le numéro de puce tel qu'il est vu par la commande `gpiodetect` et **o** est le numéro de ligne vu par la commande `gpioinfo`.

***Avertissement :*** seul les broches gpio marquées comme `inutilisées` peuvent être utilisées. Il n'est pas possible qu'une *ligne* soit utilisée par plusieurs processus simultanément.

Par exemple sur un RPi 3B+ où klipper utilise le GPIO20 comme un interrupteur :

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

## Facultatif : PWM matériel

Les Raspberry Pi ont deux canaux PWM (PWM0 et PWM1) qui sont disponibles sur le connecteur ou, sinon, peuvent être redirigés vers des broches gpio existantes. Le service mcu Linux utilise l'interface pwmchip sysfs pour contrôler les périphériques matériels pwm sur les hôtes Linux. L'interface pwm sysfs n'est pas disponible par défaut sur un Raspberry et peut être activée en ajoutant une ligne à `/boot/config.txt` :

```
# Activer l'interface pwmchip sysfs 
dtoverlay=pwm,pin=12,func=4
```

This example enables only PWM0 and routes it to gpio12. If both PWM channels need to be enabled you can use `pwm-2chan`:

```
# Enable pwmchip sysfs interface
dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4
```

This example additionally enables PWM1 and routes it to gpio13.

The overlay does not expose the pwm line on sysfs on boot and needs to be exported by echo'ing the number of the pwm channel to `/sys/class/pwm/pwmchip0/export`. This will create device `/sys/class/pwm/pwmchip0/pwm0` in the filesystem. The easiest way to do this is by adding this to `/etc/rc.local` before the `exit 0` line:

```
# Enable pwmchip sysfs interface
echo 0 > /sys/class/pwm/pwmchip0/export
```

When using both PWM channels, the number of the second channel needs to be echo'd as well:

```
# Enable pwmchip sysfs interface
echo 0 > /sys/class/pwm/pwmchip0/export
echo 1 > /sys/class/pwm/pwmchip0/export
```

Avec le sysfs en place, vous pouvez maintenant utiliser l'un ou l'autre des canaux pwm en ajoutant la configuration suivante à votre `printer.cfg` :

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

This will add hardware pwm control to gpio12 and gpio13 on the Pi (because the overlay was configured to route pwm0 to pin=12 and pwm1 to pin=13).

PWM0 peut être redirigé vers gpio12 et gpio18, PWM1 peut être redirigé vers gpio13 et gpio19 :

| PWM (Modulation en Largeur d'Impulsion) | Broche gpio | Func |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
