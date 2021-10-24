# RPi microcontroller

이 문서는 RPi에서 Klipper를 실행하는 프로세스를 설명하며 보조 MCU와 동일한 RPi를 사용합니다.

## 보조 MCU로 RPi 를 사용하는 이유?

주 인쇄 기능들(열저항기, 압출기, 스텝모터 등)의 관리를 위해서 종종 3D프린터를 제어를 담당하는 MCU는 사전 구성된 제한적 핀수를 가지고 있습니다. Klipper가 보조 MCU로 설치된 RPi를 사용하면 Octoprint 플러그인(사용되는 경우) 또는 인쇄 GCODE 내에서 모든 것을 제어할 수 있는 기능을 제공하는 외부 프로그램을 사용하지 않고 Klipper 내부에서 RPi의 GPIO 및 버스(i2c, spi)를 직접 사용할 수 있는 가능성을 제공합니다.

**경고**: 당신의 플랫폼이 *Beaglebone*이고 설치 단계를 올바르게 따랐다면 linux mcu가 이미 시스템에 설치 및 구성되어 있는 것입니다.

## rc 스크립트 설치

호스트를 보조 MCU로 사용하려면 klipper_mcu 프로세스가 klippy 프로세스보다 먼저 실행되어야 합니다.

Klipper를 설치한 후 스크립트를 설치합니다. 다음을 실행합니다:

```
cd ~/klipper/
sudo cp "./scripts/klipper-mcu-start.sh" /etc/init.d/klipper_mcu
sudo update-rc.d klipper_mcu defaults
```

## SPI 활성화

sudo raspi-config를 실행하고 "인터페이싱 옵션" 메뉴에서 SPI를 활성화하여 Linux SPI 드라이버가 활성화되어 있는지 확인합니다.

## 마이크로 컨트롤러 코드를 빌드하기

Klipper 마이크로 컨트롤러 코드를 컴파일하려면 "리눅스 프로세스"를 위한 그 코드 구성부터 시작합니다:

```
cd ~/klipper/
make menuconfig
```

메뉴에서 "마이크로 컨트롤러 아키텍쳐"를 "리눅스 프로세스"로 설정한 다음 저장하고 종료합니다.

새로운 마이크로 컨트롤러 코드를 빌드하고 설치하기 위해 다음을 실행시킵니다. :

```
sudo service klipper stop
make flash
sudo service klipper start
```

`/tmp/klipper_host_mcu`에 연결을 시도할 때 klippy.log가 "권한 거부됨" 에러를 보고하는 경우 tty 그룹에 당신을 사용자에 추가해야 합니다. 다음 명령은 "pi" 사용자를 tty 그룹에 추가합니다:

```
sudo usermod -a -G tty pi
```

## 나머지 설정

[RaspberryPi 샘플 구성](../config/sample-raspberry-pi.cfg) 및 [멀티 MCU 샘플 구성](../config/sample-multi-mcu.cfg)의 지침에 따라 Klipper 보조 MCU를 구성하여 설치 완료합니다.

## 선택 사항: 올바른 gpiochip 식별

Rasperry 및 많은 클론에서 GPIO에 노출된 핀은 첫 번째 gpiochip에 속합니다. 따라서 `gpio0..n`이라는 이름으로 참조하기만 하면 Klipper에서 사용할 수 있습니다. 다만, 노출된 핀이 1차 이외의 gpiochip에 속하는 경우가 있습니다. 예를들어 일부 OrangePi 모델의 경우 또는 포트 확장기가 사용되는 경우. 이러한 경우 명령을 사용하여 *Linux GPIO 문자 장치* 에 액세스하여 구성을 확인하는 것이 유용합니다.

octopi와 같은 데비안 기반 배포판에 *Linux GPIO 문자 장치 - 바이너리* 를 설치하려면 다음을 실행합니다:

```
sudo apt-get install gpiod
```

사용 가능한 gpiochip 확인하려면 다음을 실행합니다:

```
gpiodetect
```

핀 번호와 핀 가용성 확인하려면 다음을 실행합니다:

```
gpioinfo
```

따라서 선택한 핀은 구성 내에서 `gpiochip<n>/gpio<o>`로 사용할 수 있습니다. 여기서 **n**은 `gpiodetect` 명령으로 볼 수 있는 칩 번호이고 **o**는 `gpioinfo` 명령으로 볼 수 라인 번호입니다.

**경고:** `unused` 로 표시된 gpio만 사용할 수 있습니다. 여러 프로세스에서 동시에 *line* 을 사용할 수 없습니다.

예를 들어 RPi 3B+에서 Klipper는 스위치로 GPIO20를 이용합니다:

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

## 옵션: 하드웨어 PWM

Raspberry Pi에는 헤더에 노출되거나 그렇지 않은 경우 기존 gpio 핀으로 라우팅될 수 있는 두 개의 PWM 채널(PWM0 및 PWM1)을 가지고 있습니다. 리눅스 mcu 데몬은 리눅스 호스트의 하드웨어 pwm 장치들을 제어하기 위한 pwmchip sysfs 인터페이스를 사용합니다. pwm sysfs 인터페이스는 기본적으로 라즈베리에서 노출되지 않으며 `/boot/config.txt` 에 다음 행을 추가하여 활성화할 수 있습니다:

```
# Enable pwmchip sysfs interface
dtoverlay=pwm,pin=12,func=4
```

이 예에서는 PWM0만 활성화하고 이를 gpio12로 라우팅합니다. 두 PWM 채널을 모두 활성화해야 하는 경우 `pwm-2chan` 을 사용할 수 있습니다.

오버레이는 부팅 시 sysfs의 pwm 라인을 노출하지 않으며 pwm 채널 번호를 `/sys/class/pwm/pwmchip0/export` 로 에코하여 내보내야 합니다:

```
echo 0 > /sys/class/pwm/pwmchip0/export
```

그러면 파일 시스템에 `/sys/class/pwm/pwmchip0/pwm0` 장치가 생성됩니다. 이것을 하는 가장 쉬운 방법은 `exit 0` 행 앞에 `/etc/rc.local` 에 이것을 추가하는 것입니다.

sysfs가 있으면 이제 다음 구성을 `printer.cfg`에 추가하여 pwm 채널을 사용할 수 있습니다:

```
[output_pin caselight]
pin: host:pwmchip0/pwm0
pwm: True
hardware_pwm: True
cycle_time: 0.000001
```

그러면 Pi의 하드웨어 pwm 제어가 gpio12에 추가됩니다(오버레이가 pwm0을 pin=12로 라우팅하도록 구성되었기 때문).

PWM0 can be routed to gpio12 and gpio18, PWM1 can be routed to gpio13 and gpio19:

| PWM | gpio PIN | Func |
| --- | --- | --- |
| 0 | 12 | 4 |
| 0 | 18 | 2 |
| 1 | 13 | 4 |
| 1 | 19 | 2 |
