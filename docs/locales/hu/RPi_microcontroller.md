# RPi mikrokontroller

Ez a dokumentum leírja a Klipper futtatásának folyamatát egy RPi-n, és ugyanazt az RPi-t használja másodlagos MCU-ként.

## Miért érdemes az RPi-t másodlagos MCU-ként használni?

A 3D nyomtatók vezérlésére szolgáló MCU-k gyakran korlátozott és előre konfigurált számú szabad kimenettel rendelkeznek a fő nyomtatási funkciók (hőellenállások, extruderek, léptetők stb.) kezelésére. Az RPi használata, ahol a Klipper másodlagos MCU-ként van telepítve, lehetővé teszi a GPIO-k és az RPi kimeneteinek (I2C, SPI) közvetlen használatát a klipperben anélkül, hogy Octoprint bővítményeket (ha van ilyen) vagy külső programokat használva, amelyek lehetővé teszik, hogy mindent vezéreljen a Klipper-en belül a nyomtatási G-kód.

**Figyelmeztetés**: Ha a te platformod egy *Beaglebone*, és helyesen követted a telepítés lépéseit, a Linux MCU már telepítve és konfigurálva van a rendszeredhez.

## Az rc szkript telepítése

Ha a gazdagépet másodlagos MCU-ként szeretné használni, a klipper_mcu folyamatnak a klippy folyamat előtt kell futnia.

A Klipper telepítése után telepítse a szkriptet. run:

```
cd ~/klipper/
sudo cp "./scripts/klipper-mcu-start.sh" /etc/init.d/klipper_mcu
sudo update-rc.d klipper_mcu defaults
```

## A mikrokontroller kódjának elkészítése

A Klipper mikrokontroller kódjának lefordításához kezd a "Linux folyamat" konfigurálásával:

```
cd ~/klipper/
make menuconfig
```

A menüben állítsd be a "Mikrokontroller architektúra" értéket "Linux process,"-re, majd mentsd és lépj ki.

Az új mikrokontroller kódjának elkészítéséhez és telepítéséhez futtassa a következőt:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Ha a klippy.log a `/tmp/klipper_host_mcu`-hoz való kapcsolódási kísérletnél "Permission denied" hibát jelez, akkor a felhasználót hozzá kell adnia a tty csoporthoz. A következő parancs hozzáadja a "pi" felhasználót a tty csoporthoz:

```
sudo usermod -a -G tty pi
```

## Hátralevő konfiguráció

Fejezze be a telepítést a Klipper másodlagos MCU konfigurálásával a [RaspberryPi minta konfiguráció](../config/sample-raspberry-pi.cfg) és a [Multi MCU minta konfiguráció](../config/sample-multi-mcu.cfg) utasításai szerint.

## Választható: SPI engedélyezése

Győződjünk meg róla, hogy a Linux SPI-illesztőprogram engedélyezve van a `sudo raspi-config` futtatásával és az SPI engedélyezésével az "Interfacing options" menüben.

## Választható: I2C engedélyezése

Győződjünk meg róla, hogy a Linux I2C illesztőprogram engedélyezve van a `sudo raspi-config` futtatásával és az I2C engedélyezésével az "Interfacing options" menüben. Ha az MPU gyorsulásmérőjének I2C használatát tervezzük, akkor a átviteli sebességet is 400000-re kell állítani a következő módon: `dtparam=i2c_arm=on,i2c_arm_baudrate=400000` hozzáadása/elhagyása a `/boot/config-ban.txt` (vagy `/boot/firmware/config.txt` néhány disztróban).

## Választható: A megfelelő GPIO chip azonosítása

A Raspberry Pi-n és sok klónon a GPIO-n látható tűk az első GPIO chiphez tartoznak. Ezért a klipperben egyszerűen úgy használhatók, hogy a `gpio0..n` névvel hivatkozunk rájuk. Vannak azonban olyan esetek, amikor a kitett tűk az elsőtől eltérő GPIO chipekhez tartoznak. Például egyes OrangePi modellek esetében, vagy ha Port Expander-t használunk. Ezekben az esetekben hasznos a *Linux GPIO karakteres eszköz *Linux GPIO eszköz* elérésére szolgáló parancsok használata a konfiguráció ellenőrzéséhez.

A *Linux GPIO character device - binary* telepítéséhez egy debian alapú disztribúció kell, mint például az octopi. Futtassa:

```
sudo apt-get install gpiod
```

A rendelkezésre álló GPIO chip ellenőrzéséhez futtassa:

```
gpiodetect
```

A tű számának és a tű elérhetőségének ellenőrzésére futtassa:

```
gpioinfo
```

A kiválasztott tű így a konfiguráción belül `gpiochip<n>/gpio<o> néven használható;` ahol **n** a `gpiodetect` által látott chipszám parancs által látott sorszám, és **o** a`gpioinfo` parancs által látott sorszám.

**Figyelmeztetés:** csak `unused` jelöléssel rendelkező GPIO használható. A *line* nem használható egyszerre több folyamatban.

Például egy RPi 3B+, ahol a klipper használja a GPIO20-at, egy kapcsoló:

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

## Választható: Hardveres PWM

A Raspberry Pi két PWM csatornával (PWM0 és PWM1) rendelkezik, amelyek a fejlécen láthatók, vagy ha nem, akkor a meglévő GPIO érintkezőkhöz irányíthatók. A Linux mcu démon a pwmchip sysfs interfészt használja a hardveres PWM eszközök vezérlésére a Linux gazdagépeken. A PWM sysfs interfész alapértelmezés szerint nincs kitéve a Raspberry-n, és a `/boot/config.txt` egy sor hozzáadásával aktiválható:

```
# A pwmchip sysfs felület engedélyezése
dtoverlay=pwm,pin=12,func=4
```

Ez a példa csak a PWM0-t engedélyezi, és a GPIO12-re irányítja. Ha mindkét PWM csatornát engedélyezni kell, használhatod a `pwm-2chan` parancsot.

Az átfedés nem teszi ki a PWM sort a sysfs-en a rendszerindításkor, és azt a PWM csatorna számát a `/sys/class/pwm/pwmchip0/export` echo'ing-be kell exportálni:

```
echo 0 > /sys/class/pwm/pwmchip0/export
```

Ez létrehozza a `/sys/class/pwm/pwmchip0/pwm0` eszközt a fájlrendszerben. A legegyszerűbb, ha ezt a `/etc/rc.local` sor előtt az `exit 0` sorba írjuk be.

Ha a sysfs a helyén van, akkor most már használhatod a PWM csatornát vagy csatornákat, ha a következő konfigurációt hozzáadod a `printer.cfg` fájlhoz:

```
[output_pin caselight]
pin: host:pwmchip0/pwm0
pwm: True
hardware_pwm: True
cycle_time: 0.000001
```

Ez hozzáadja a hardveres PWM vezérlést a Pi GPIO12-höz (mivel az átfedés úgy volt konfigurálva, hogy a PWM0-t a pin=12-re irányítsa).

A PWM0 a GPIO12 és a GPIO18 a PWM1 a GPIO13 és a GPIO19 felé irányítható:

| PWM | gpio PIN | Func |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
