# 설치

이 지침은 소프트웨어가 OctoPrint와 함께 Raspberry Pi 컴퓨터에서 실행된다고 가정합니다. Raspberry Pi 2, 3 또는 4 컴퓨터를 호스트 컴퓨터로 사용하는 것이 좋습니다(다른 기기에 대해서는 [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) 참조).

## Obtain a Klipper Configuration File

Most Klipper settings are determined by a "printer configuration file" that will be stored on the Raspberry Pi. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

If there isn't an appropriate printer configuration file in the Klipper config directory then try searching the printer manufacturer's website to see if they have an appropriate Klipper configuration file.

If no configuration file for the printer can be found, but the type of printer control board is known, then look for an appropriate [config file](../config/) starting with a "generic-" prefix. These example printer board files should allow one to successfully complete the initial installation, but will require some customization to obtain full printer functionality.

It is also possible to define a new printer configuration from scratch. However, this requires significant technical knowledge about the printer and its electronics. It is recommended that most users start with an appropriate configuration file. If creating a new custom printer configuration file, then start with the closest example [config file](../config/) and use the Klipper [config reference](Config_Reference.md) for further information.

## OS 이미지 준비

Raspberry Pi 컴퓨터에 [OctoPi](https://github.com/guysoft/OctoPi)를 설치하여 시작합니다. OctoPi v0.17.0 이상 사용 - 릴리스 정보는 [OctoPi 릴리스](https://github.com/guysoft/OctoPi/releases)를 참조하십시오. OctoPi가 부팅되고 OctoPrint 웹 서버가 작동하는지 확인해야 합니다. OctoPrint 웹 페이지에 연결한 후 화면의 지시에 따라 OctoPrint를 v1.4.2 이상으로 업그레이드하십시오.

OctoPi를 설치하고 OctoPrint를 업그레이드한 후, 소수의 시스템 명령을 실행하려면 대상 머신에 ssh해야 합니다. Linux 또는 MacOS 데스크탑을 사용하는 경우 "ssh" 소프트웨어가 데스크탑에 이미 설치되어 있어야 합니다. 다른 데스크톱에서 사용할 수 있는 무료 ssh 클라이언트가 있습니다(예: [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). ssh 유틸리티를 사용하여 Raspberry Pi(ssh pi@octpi -- 암호는 "raspberry")에 연결하고 다음 명령을 실행합니다:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

위의 내용은 Klipper를 다운로드하고, 일부 시스템 종속성을 설치하고, 시스템 시작 시 실행되도록 Klipper를 설정하고, Klipper 호스트 소프트웨어를 시작합니다. 인터넷 연결이 필요하며 완료하는 데 몇 분이 소요될 수 있습니다.

## 마이크로 컨트롤러 빌드 및 플래싱

마이크로 컨트롤러 코드를 컴파일하려면 먼저 Raspberry Pi에서 다음 명령을 실행하십시오:

```
cd ~/klipper/
make menuconfig
```

The comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) should describe the settings that need to be set during "make menuconfig". Open the file in a web browser or text editor and look for these instructions near the top of the file. Once the appropriate "menuconfig" settings have been configured, press "Q" to exit, and then "Y" to save. Then run:

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Otherwise, the following steps are often used to "flash" the printer control board. First, it is necessary to determine the serial port connected to the micro-controller. Run the following:

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

## Klipper를 사용하도록 OctoPrint 구성중

OctoPrint 웹 서버는 Klipper 호스트 소프트웨어와 통신하도록 구성해야 합니다. 웹 브라우저를 사용하여 OctoPrint 웹 페이지에 로그인한 후 다음 항목을 구성합니다:

설정 탭(페이지 상단의 렌치 아이콘)으로 이동합니다. "추가 직렬 포트"의 "직렬 연결"에서 "/tmp/printer"를 추가합니다. 그런 다음 "저장"을 클릭하십시오.

설정 탭으로 다시 들어가 "직렬 연결"에서 "직렬 포트" 설정을 "/tmp/printer"로 변경하십시오.

설정 탭에서 "동작" 하위 탭으로 이동하여 "진행 중인 인쇄를 취소하지만 프린터에 연결된 상태로 유지" 옵션을 선택합니다. "저장"을 클릭합니다.

메인 페이지의 "연결" 섹션(페이지 왼쪽 상단)에서 "직렬 포트"가 "/tmp/printer"로 설정되어 있는지 확인하고 "연결"을 클릭합니다. ("/tmp/printer"를 선택할 수 없는 경우 페이지를 다시 로드해 보십시오.)

연결되면 "터미널" 탭으로 이동하여 명령 입력 상자에 "상태"(따옴표 제외)를 입력하고 "보내기"를 클릭합니다. 터미널 창은 구성 파일을 여는 동안 오류가 발생했다고 보고할 것입니다. 이는 OctoPrint가 Klipper와 성공적으로 통신하고 있음을 의미합니다. 다음 섹션으로 이동합니다.

## Klipper 구성 중

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the Raspberry Pi.

Arguably the easiest way to set the Klipper configuration file is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the Raspberry Pi via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

It's common for each printer to have its own unique name for the micro-controller. The name may change after flashing Klipper, so rerun these steps again even if they were already done when flashing. Run:

```
ls /dev/serial/by-id/*
```

그럼 다음과 비슷한 결과물을 얻을 수 있습니다:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Then update the config file with the unique name. For example, update the `[mcu]` section to look something similar to:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the OctoPrint web terminal to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

When customizing the printer config file, it is not uncommon for Klipper to report a configuration error. If an error occurs, make any necessary corrections to the printer config file and issue "restart" until "status" reports the printer is ready.

Klipper는 OctoPrint terminal 탭을 통해 오류 메시지를 보고합니다. "status" 명령을 사용하여 오류 메시지를 다시 보고할 수 있습니다. Klipper 시작 스크립트는 **/tmp/klippy.log**를 통해 자세한 정보를 제공합니다.

After Klipper reports that the printer is ready, proceed to the [config check document](Config_checks.md) to perform some basic checks on the definitions in the config file. See the main [documentation reference](Overview.md) for other information.
