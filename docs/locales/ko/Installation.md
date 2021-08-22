# 설치

이 문서는 OctoPrint가 Raspberry Pi 에서 실행된다고 가정합니다. Raspberry Pi 2, 3 또는 4를 사용하는 것이 좋습니다 ([FAQ](FAQ.md#Raspberry-Pi-3-이외의-다른-기기에서-Klipper를-실행할-수-있습니까) 참조).

Klipper는 현재 다양한 Atmel ATmega 기반 마이크로 컨트롤러, [ARM based micro-controllers](Features.md#step-benchmarks) 및 [Beaglebone PRU](beaglebone.md) 기반 프린터를 지원합니다.

## 설치 이미지 준비

Raspberry Pi에 [OctoPi](https://github.com/guysoft/OctoPi) 를 설치하여 시작합니다. OctoPi v0.17.0 이상을 사용하십시오. 릴리스 정보는 [octopi releases](https://github.com/guysoft/OctoPi/releases) 릴리스를 참조하십시오. OctoPi가 부팅되고 OctoPrint 웹 서버가 작동하는지 확인해야 합니다. OctoPrint 웹 페이지에 연결한 후 화면의 지시에 따라 OctoPrint를 v1.4.2 이상으로 업그레이드하십시오.

OctoPi를 설치하고 OctoPrint를 업그레이드한 후 몇 가지 시스템 명령을 실행하려면 대상 시스템에 ssh해야 합니다. Linux 또는 MacOS 데스크탑을 사용하는 경우 "ssh" 소프트웨어가 이미 설치되어 있어야 합니다. 윈도우 OS 에서는 [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/) 처럼 무료로 사용할 수 있는 ssh 클라이언트가 있습니다. ssh 유틸리티를 사용하여 Raspberry Pi(ssh pi@octpi -- 암호는 "raspberry")에 연결하고 다음 명령을 실행합니다:

```
git clone https://github.com/KevinOConnor/klipper
./klipper/scripts/install-octopi.sh
```

위의 내용은 Klipper를 다운로드하고, 시스템에 필요한 패키지를 설치하고, 시스템 시작 시 Klipper 가 자동으로 실행되도록 설정하고, Klipper 호스트 소프트웨어를 시작합니다. 인터넷 연결이 필요하며 완료하는 데 몇 분 정도 걸릴 수 있습니다.

## 컴파일 및 펌웨어 업로드

마이크로 컨트롤러 코드를 컴파일하려면 먼저 Raspberry Pi에서 다음 명령을 실행하십시오:

```
cd ~/klipper/
make menuconfig
```

적절한 마이크로 컨트롤러를 선택하고 제공된 다른 옵션을 검토하십시오. 구성이 완료되면 다음을 실행합니다:

```
make
```

마이크로 컨트롤러에 연결된 시리얼 포트를 결정해야 합니다. USB를 통해 연결하는 마이크로 컨트롤러의 경우 다음을 실행합니다:

```
ls /dev/serial/by-id/*
```

그럼 다음과 비슷한 결과물을 얻을 수 있습니다:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

각 프린터에는 고유한 시리얼 포트 이름이 있는 것이 일반적입니다. 이 고유한 이름은 마이크로 컨트롤러에 펌웨어 업로드 할때 사용됩니다. 위의 출력에 여러 줄이 있을 수 있습니다. 그렇다면 마이크로 컨트롤러에 해당하는 줄을 선택하십시오 (자세한 내용은 [FAQ](내-시리얼-포트는-어디에-있습니까) 참조).

일반적인 마이크로 컨트롤러의 경우 다음과 유사한 명령어를 사용하여 펌웨어 업로드 할 수 있습니다:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

반드시 프린터의 고유한 시리얼 포트 이름으로 FLASH_DEVICE를 업데이트해야 합니다.

처음 펌업 할 때 OctoPrint가 프린터에 직접 연결되어 있지 않은지 확인하십시오 (OctoPrint 웹 페이지의 "Connection" 섹션에서 "Disconnect" 클릭).

## Klipper 를 사용하기 위한 Octoprint 설정

OctoPrint 웹 서버는 Klipper 호스트 소프트웨어와 통신하도록 구성해야 합니다. 웹 브라우저를 사용하여 OctoPrint 웹 페이지에 로그인한 후 다음 항목을 구성합니다:

설정 탭(페이지 상단의 렌치 아이콘)으로 이동합니다. "Additional serial ports"의 "Serial Connection"에서 "/tmp/printer"를 추가합니다. 그런 다음 "Save"를 클릭하십시오.

설정 탭으로 다시 들어가 "Serial Connection"에서 "Serial Port" 설정을 "/tmp/printer"로 변경합니다.

설정 탭에서 "Behavior" 하위 탭으로 이동하여 "Cancel any ongoing prints but stay connected to the printer" 옵션을 선택합니다. "Save"를 클릭합니다.

메인 페이지의 "Connection" 섹션(페이지 왼쪽 상단)에서 "Serial Port"가 "/tmp/printer"로 설정되어 있는지 확인하고 "Connect"을 클릭합니다. ("/tmp/printer"를 선택할 수 없는 경우 페이지를 다시 로드해 보십시오.)

일단 연결되면 "Terminal" 탭으로 이동하여 명령 입력 상자에 "status" (따옴표 제외)를 입력하고 "Send"를 클릭합니다. 터미널 창은 config 파일을 여는 동안 오류가 발생했다고 보고할 것입니다. 이는 OctoPrint가 Klipper와 성공적으로 통신하고 있음을 의미합니다. 다음 섹션으로 이동합니다.

## Klipper 설정

Klipper 구성은 Raspberry Pi의 텍스트 파일에 저장됩니다. [config directory](../config/) 있는 예제 구성 파일을 살펴보십시오. [config reference](Config_Reference.md)에는 config 매개변수에 대한 문서가 포함되어 있습니다.

논란의 여지 없이 Klipper 구성 파일을 업데이트하는 가장 쉬운 방법은 "scp" 및/또는 "sftp" 프로토콜을 통한 파일 편집을 지원하는 데스크탑 편집기를 사용하는 것입니다. 이를 지원하는 무료 도구가 있습니다(예: Notepad++, WinSCP 및 Cyberduck). 예제 구성 파일 중 하나를 시작점으로 사용하고 pi 사용자의 홈 디렉토리(즉, /home/pi/printer.cfg)에 "printer.cfg"라는 파일로 저장합니다.

또는 ssh를 통해 Raspberry Pi에서 직접 파일을 복사하고 편집할 수도 있습니다. 예를 들면 다음과 같습니다:

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

printer.cfg 파일 내용을 하드웨어에 적합한 각 설정을 검토하고 업데이트하십시오.

각 프린터마다 마이크로 컨트롤러에 대해 고유한 이름이 있는 것이 일반적입니다. Klipper 플래싱 후에 이름이 변경될 수 있으므로 `ls /dev/serial/by-id/*` 명령을 다시 실행한 다음 구성 파일을 고유한 이름으로 업데이트하십시오. 예를 들어 `[mcu]` 섹션을 다음과 유사하게 업데이트합니다:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

파일을 만들고 편집한 후 config 를 로드하려면 OctoPrint 웹 terminal 탭에서 "restart" 명령을 실행해야 합니다. "status" 명령은 Klipper 구성 파일을 성공적으로 읽고 마이크로 컨트롤러를 성공적으로 찾아서 구성한 경우 프린터가 준비되었음을 보고합니다. 초기 설정 중에 구성 오류가 발생하는 것은 드문 일이 아닙니다. 프린터 구성 파일을 업데이트하고 "status"에서 프린터가 준비되었다고 보고할 때까지 "restart"을 실행하십시오.

Klipper는 OctoPrint terminal 탭을 통해 오류 메시지를 보고합니다. "status" 명령을 사용하여 오류 메시지를 다시 보고할 수 있습니다. Klipper 시작 스크립트는 **/tmp/klippy.log**를 통해 자세한 정보를 제공합니다.

추가로 일반적인 gcode 명령 외에도 Klipper는 몇 가지 확장 명령을 지원합니다. "status" 및 "restart"는 이러한 명령의 예입니다. "help" 명령을 사용하여 다른 확장 명령을 확인하십시오.

Klipper가 프린터가 준비되었다고 보고한 후 [config check document](Config_checks.md)로 이동하여 config 파일의 핀 정의에 대한 몇 가지 기본 검사를 수행합니다.

## 개발자에게 문의

몇 가지 일반적인 질문에 대한 답변은 [FAQ](FAQ.md)를 참조하십시오. 버그를 보고하거나 개발자에게 연락하려면 [contact page](Contact.md)를 참조하세요.
