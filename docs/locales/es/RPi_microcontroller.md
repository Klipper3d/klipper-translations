# RPi microcontroller

Este documento describe el proceso de ejecutar Klipper en una RPi y utilizar la misma RPi como MCU secundaria.

## ¿Por qué utilizar RPi como MCU secundaria?

A menudo las MCUs dedicadas a controlar impresoras 3D tienen un número limitado y pre-configurado de pines expuestos para gestionar las principales funciones de impresión (resistencias térmicas, extrusores, steppers ...). Usando la RPi donde Klipper está instalado como MCU secundario da la posibilidad de usar directamente los GPIOs y los buses ( I2C, SPI) de la RPi dentro de Klipper sin usar plugins de Octoprint (si se usan) o programas externos dando la posibilidad de controlar todo dentro del GCODE de impresión.

**Atención**: Si tu plataforma es un *Beaglebone* y has seguido correctamente los pasos de instalación, la MCU con Linux ya está instalada y configurada para tu sistema.

## Install the rc script

Si quieres usar el host como MCU secundaria el proceso klipper_mcu debe ejecutarse antes que el proceso klippy.

Después de instalar Klipper, instale el script. Ejecútalo:

```
cd ~/klipper/
sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
sudo systemctl enable klipper-mcu.service
```

## Compilar el código del microcontrolador

Para compilar el código del microcontrolador Klipper, empieza por configurarlo para el "proceso Linux":

```
cd ~/klipper/
make menuconfig
```

En el menú, ajuste "Arquitectura del microcontrolador" a "Proceso Linux", luego guarde y salga.

Para compilar e instalar el nuevo código del microcontrolador, ejecute:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Si klippy.log reporta un error de "Permiso denegado" cuando intenta conectarse a `/tmp/klipper_host_mcu` entonces necesita agregar su usuario al grupo tty. El siguiente comando agregará el usuario "pi" al grupo tty:

```
sudo usermod -a -G tty pi
```

## Configuración restante

Complete la instalación configurando la MCU secundaria Klipper siguiendo las instrucciones de [RaspberryPi sample config](../config/sample-raspberry-pi.cfg) y [Multi MCU sample config](../config/sample-multi-mcu.cfg).

## Optional: Enabling SPI

Make sure the Linux SPI driver is enabled by running `sudo raspi-config` and enabling SPI under the "Interfacing options" menu.

## Optional: Enabling I2C

Make sure the Linux I2C driver is enabled by running `sudo raspi-config` and enabling I2C under the "Interfacing options" menu. If planning to use I2C for the MPU accelerometer, it is also required to set the baud rate to 400000 by: adding/uncommenting `dtparam=i2c_arm=on,i2c_arm_baudrate=400000` in `/boot/config.txt` (or `/boot/firmware/config.txt` in some distros).

## Opcional: Identificar el gpiochip correcto

On Raspberry Pi and on many clones the pins exposed on the GPIO belong to the first gpiochip. They can therefore be used on klipper simply by referring them with the name `gpio0..n`. However, there are cases in which the exposed pins belong to gpiochips other than the first. For example in the case of some OrangePi models or if a Port Expander is used. In these cases it is useful to use the commands to access the *Linux GPIO character device* to verify the configuration.

Para instalar el *Linux GPIO character device - binary* en una distro basada en debian como octopi ejecute:

```
sudo apt-get install gpiod
```

Para comprobar gpiochip disponibles ejecutar:

```
gpiodetect
```

Para comprobar el número de pin y la disponibilidad de pin ejecute:

```
gpioinfo
```

The chosen pin can thus be used within the configuration as `gpiochip<n>/gpio<o>` where **n** is the chip number as seen by the `gpiodetect` command and **o** is the line number seen by the`gpioinfo` command.

***Atención:*** sólo se pueden utilizar las gpio marcadas como `unused`. No es posible que una *pista* sea utilizada por múltiples procesos simultáneamente.

Por ejemplo en una RPi 3B+ donde Klipper usa el GPIO20 para un interruptor:

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

Raspberry Pi's have two PWM channels (PWM0 and PWM1) which are exposed on the header or if not, can be routed to existing gpio pins. The Linux mcu daemon uses the pwmchip sysfs interface to control hardware pwm devices on Linux hosts. The pwm sysfs interface is not exposed by default on a Raspberry and can be activated by adding a line to `/boot/config.txt`:

```
# Enable pwmchip sysfs interface
dtoverlay=pwm,pin=12,func=4
```

This example enables only PWM0 and routes it to gpio12. If both PWM channels need to be enabled you can use `pwm-2chan`.

The overlay does not expose the pwm line on sysfs on boot and needs to be exported by echo'ing the number of the pwm channel to `/sys/class/pwm/pwmchip0/export`:

```
echo 0 > /sys/class/pwm/pwmchip0/export
```

This will create device `/sys/class/pwm/pwmchip0/pwm0` in the filesystem. The easiest way to do this is by adding this to `/etc/rc.local` before the `exit 0` line.

With the sysfs in place, you can now use either the pwm channel(s) by adding the following piece of configuration to your `printer.cfg`:

```
[output_pin caselight]
pin: host:pwmchip0/pwm0
pwm: True
hardware_pwm: True
cycle_time: 0.000001
```

This will add hardware pwm control to gpio12 on the Pi (because the overlay was configured to route pwm0 to pin=12).

PWM0 can be routed to gpio12 and gpio18, PWM1 can be routed to gpio13 and gpio19:

| PWM | gpio PIN | Func |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
