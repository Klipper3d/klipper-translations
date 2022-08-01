# Microcontrollore RPi

Questo documento descrive il processo di esecuzione di Klipper su un RPi e usa lo stesso RPi come mcu secondario.

## Perché usare RPi come MCU secondario?

Spesso gli MCU dedicati al controllo delle stampanti 3D hanno un numero limitato e preconfigurato di pin esposti per gestire le principali funzioni di stampa (resistenze termiche, estrusori, stepper...). L'utilizzo dell'RPi dove Klipper è installato come MCU secondario dà la possibilità di utilizzare direttamente i GPIO e i bus (i2c, spi) dell'RPi all'interno di klipper senza utilizzare plugin Octoprint (se utilizzati) o programmi esterni dando la possibilità di controllare tutto all'interno del GCODE di stampa.

**Attenzione**: Se la tua piattaforma è un *Beaglebone* e hai seguito correttamente i passi di installazione, la mcu linux è già installata e configurata per il tuo sistema.

## Installa lo script rc

Se si desidera utilizzare l'host come MCU secondario, il processo di klipper_mcu deve essere eseguito prima del processo klippy.

Dopo aver installato Klipper, installare lo script. eseguire:

```
cd ~/klipper/
sudo cp "./scripts/klipper-mcu-start.sh" /etc/init.d/klipper_mcu
sudo update-rc.d klipper_mcu defaults
```

## Creazione del codice del microcontrollore

Per compilare il codice del microcontrollore Klipper, iniziate configurandolo per il "processo Linux":

```
cd ~/klipper/
make menuconfig
```

Nel menu, impostate "Microcontroller Architecture" su "Linux process", poi salvate e uscite.

Per compilare e installare il nuovo codice del microcontrollore, eseguire:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Se klippy.log segnala un errore "Autorizzazione negata" quando si tenta di connettersi a `/tmp/klipper_host_mcu`, è necessario aggiungere l'utente al gruppo tty. Il seguente comando aggiungerà l'utente "pi" al gruppo tty:

```
sudo usermod -a -G tty pi
```

## Configurazione rimanente

Completare l'installazione configurando l'MCU secondario di Klipper seguendo le istruzioni in [RaspberryPi sample config](../config/sample-raspberry-pi.cfg) e [Multi MCU sample config](../config/sample-multi-mcu.cfg).

## Facoltativo: abilitazione di SPI

Assicurati che il driver SPI di Linux sia abilitato eseguendo `sudo raspi-config` e abilitando SPI nel menu "Opzioni di interfaccia".

## Opzionale: abilitazione di I2C

Assicurati che l'interfaccia Linux I2C sia abilitato eseguendo `sudo raspi-config` e abilitando I2C nel menu "Opzioni di interfaccia". Se si intende utilizzare I2C per l'accelerometro MPU, è anche necessario impostare il baud rate su 400000: aggiungendo/deselezionando `dtparam=i2c_arm=on,i2c_arm_baudrate=400000` in `/boot/config.txt` (o `/ boot/firmware/config.txt` in alcune distribuzioni).

## Opzionale: Identificare il gpiochip corretto

Su Raspberry Pi e su molti cloni i pin esposti sul GPIO appartengono al primo gpiochip. Possono quindi essere utilizzati su klipper semplicemente riferendoli con il nome `gpio0..n`. Tuttavia, ci sono casi in cui i pin esposti appartengono a gpiochip diversi dal primo. Ad esempio nel caso di alcuni modelli OrangePi o se viene utilizzato un Port Expander. In questi casi è utile utilizzare i comandi per accedere al *dispositivo a caratteri GPIO Linux* per verificarne la configurazione.

Per installare il *Linux GPIO character device - binary* su una distro basata su debian come octopi eseguire:

```
sudo apt-get install gpiod
```

Per controllare i gpiochip disponibili eseguire:

```
gpiodetect
```

Per verificare il numero di pin e la disponibilità dei pin:

```
gpioinfo
```

Il pin scelto può quindi essere utilizzato all'interno della configurazione come `gpiochip<n>/gpio<o>` dove **n** è il numero del chip visto dal comando `gpiodetect` e **o** è il numero di riga visto dal comando `gpioinfo`.

***Attenzione:*** solo i gpio contrassegnati come `inutilizzati` possono essere utilizzati. Non è possibile che una *linea* sia usata da più processi contemporaneamente.

Per esempio su un RPi 3B+ dove klipper usa il GPIO20 per un interruttore:

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

## Opzionale: Hardware PWM

I Raspberry Pi hanno due canali PWM (PWM0 e PWM1) che sono esposti sull'intestazione o, in caso contrario, possono essere instradati ai pin gpio esistenti. Il demone mcu Linux utilizza l'interfaccia sysfs pwmchip per controllare i dispositivi hardware pwm sugli host Linux. L'interfaccia sysfs pwm non è esposta per impostazione predefinita su un Raspberry e può essere attivata aggiungendo una riga a `/boot/config.txt`:

```
# Abilita l'interfaccia sysfs di pwmchip
dtoverlay=pwm,pin=12,func=4
```

Questo esempio abilita solo PWM0 e lo indirizza a gpio12. Se entrambi i canali PWM devono essere abilitati potete usare `pwm-2chan`.

L'overlay non espone la riga pwm sui sysfs all'avvio e deve essere esportata facendo eco al numero del canale pwm in `/sys/class/pwm/pwmchip0/export`:

```
echo 0 > /sys/class/pwm/pwmchip0/export
```

Questo creerà il dispositivo `/sys/class/pwm/pwmchip0/pwm0` nel filesystem. Il modo più semplice per farlo è aggiungerlo a `/etc/rc.local` prima della riga `exit 0`.

Con il sysfs a posto, potete ora utilizzare il canale o i canali pwm aggiungendo il seguente pezzo di configurazione al vostro `printer.cfg`:

```
[output_pin caselight]
pin: host:pwmchip0/pwm0
pwm: True
hardware_pwm: True
cycle_time: 0.000001
```

Questo aggiungerà il controllo pwm hardware a gpio12 sul Pi (perché l'overlay è stato configurato per instradare pwm0 a pin = 12).

PWM0 può essere indirizzato su gpio12 e gpio18, PWM1 può essere indirizzato su gpio13 e gpio19:

| PWM | gpio PIN | Func |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
