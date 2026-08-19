# 설치

이 지침은 소프트웨어가 Klipper 호환 프런트 엔드를 실행하는 Linux 기반 호스트에서 실행됩니다. RSPC (Debian 기반 Linux 장치와 같은 SBC (작은 보드 컴퓨터) 호스트 시스템으로 사용됩니다 ([FAQ.MD # CAN-I-Run-Klipper-On-Ither-AT Raspberry-PI-3) 다른 옵션에 대해서는.

이 가이드 라인의 경우 호스트는 Linux 장치와 관련이 있으며 MCU는 프린터 보드에 관한 것입니다. SBC는 라즈베리 PI와 같은 소형 보드 컴퓨터의 용어입니다.

## lplper 구성 파일 가져 오기

대부분의 klipper 설정은 "프린터 구성 파일"프린터 .cfg에 의해 결정됩니다.이 호스트는 저장소입니다. 즉, LPPEPP [Config Directory] (./ config /)을 찾을 수 있습니다. 대상 프린터의 대상 프린터의 "프린터"접두사로 시작하는 파일의 파일을 찾을 수 있습니다. LPLPer 구성 파일에는 설치 중에 필요한 프린터에 대한 기술 정보가 들어 있습니다.

Klipper Config 디렉토리에 적절한 프린터 구성 파일이 없으면 프린터 제조업체의 웹 사이트를 검색하고 적절한 Klipper 구성 파일이 있는지 확인하십시오.

프린터에 대한 구성 파일이 없지만 프린터 제어 보드의 유형이 알려지고 적절한 [Config File] (Sigh / Change)이 시작됩니다. "일반"접두사로 시작하십시오.이 예제 프린터 보드 파일은 초기 설치를 성공적으로 완료 할 수 있으므로 전체 프린터 기능을 사용자 정의해야합니다.

또한 처음부터 새 프린터 구성을 정의 할 수도 있습니다. 그러나 이것은 프린터와 전자 제품에 대한 중요한 기술적 지식을 필요로합니다. 대부분의 사용자가 적절한 구성 파일로 시작하는 것이 좋습니다. 새 사용자 정의 프린터 구성 파일을 작성한 경우 가장 가까운 예제 [COPNAL FILE] (STUNG /)을 시작하고 lppper [Config Reference] (Config_Reference.md)를 사용하여 자세한 내용은 "only.reference.md를 사용하십시오.

## lpipper와 상호 작용

Klipper는 3D 프린터 펌웨어이므로 상호 작용할 수있는 방법이 필요합니다.

현재 최상의 선택은 [Moonraker Web API](https://moonraker.readthedocs.io/)를 통해 정보를 검색하는 프런트 엔드이며 [opToprint](https://octoprint.org/)을 사용하여 lpipper를 제어 할 수 있습니다.

선택은 사용하는 최대 값이지만 기본값은 모든 경우에 동일합니다. 정보와 연구 정보에 사용할 수있는 옵션을 공부할 수 있습니다.

## SBC의 OS 이미지 가져 오기

SBC 사용을 위해 Klipper에 대한 OS 이미지를 얻는 방법에는 여러 가지가 있습니다. 그것은 가장 끝없는 프런트 엔드의 의도에 달려 있습니다.이 SBC 보드의 일부 제조업체는 자신의 klipper center 이미지를 제공합니다.

두 개의 주 Moonracer 기반 프런트 엔드는 [FoudiD] (https://docs.fluidd.xyz/) 및 [MainSail] (https://docs.mainsail.xyz/) 이후에 후자가 설치된 이미지가 있습니다. "MainSailos"] (https://docs-os.mainsail.xyz/), 이는 Raspberry PI 및 일부 Orangepi 변형에 대한 옵션을 갖습니다.

흐름은 키아프 설치 및 업데이트 도우미 (Kiauh) (아래 지침의 조건 목록)을 통해 설치할 수 있습니다.

OcToprint는 인기있는 Octopi 이미지 또는 Kiaih를 통해 설치할 수 있습니다.이 프로세스는 <octoprint.md>에 설명되어 있습니다.

## 기아를 통해 설치

일반적으로 SBC, 예를 들어 UxUntu Server의 x86 리눅스 장치에서 기본 이미지로 시작됩니다. Klipper 함수를 중지 할 수있는 특정 도우미 프로그램에 따라 데스크탑 변형이 권장되지 않고 일부 프린터 보드에 대한 마스킹을 마스킹합니다.

Kiaih는 데비안의 형태를 작동시키는 다양한 Linux 기반 시스템에 연결된 프로그램을 연결하는 데 사용할 수 있습니다. 자세한 내용은 https://github.com/dw-0/kiauhh에서 찾을 수 있습니다

## 건물과 번쩍이는 마이크로 제어기

마이크로 컨트롤러 코드를 컴파일하려면 호스트 장치에서 이러한 명령을 실행하십시오:

```
cd ~/klipper/
make menuconfig
```

[프린터 구성 파일] (#44-klipper-configuration-file)의 맨 위에있는 의견은 "ManueCenfigf"메서드 중에 설정 해야하는 설정을 설명해야합니다. 웹 브라우저 또는 텍스트 편집기에서 파일을 열고 파일의 맨 위로 지침을 찾으십시오. 적절한 "menuconfig"설정이 구성되면 "Q"를 눌러 저장하고 "Y"를 저장하려면 "QUEND를 누릅니다.

```
make
```

[프린터 구성 파일] (#4-klipper-configuration-file)의 상단의 주석이 "프랑스 제어 보드"에 최종 이미지를 깜박임을 맞춤 설정 한 경우 사용자를 수행 한 다음 해당 단계를 수행 한 다음 [OcToprint] 구성 (# 구성) oCToprint-use-lpipper를 참조하십시오.

그렇지 않으면 다음 단계가 프린터 제어 보드를 "플래시"로 사용하는 데 사용됩니다. 먼저 마이크로 컨트롤러에 연결된 직렬 포트를 결정해야합니다. 다음을 실행하십시오:

```
ls /dev/serial/by-id/*
```

다음과 같은 것을보고해야합니다 :

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

각 프린터는 고유 한 직렬 포트 이름을 갖는 것에 공통적입니다.이 고유 한 이름은 마이크로 컨트롤러를 깜박일 때 사용할 것입니다. 위의 출력 위의 여러 줄이 있습니다. 그렇다면 마이크로 컨트롤러에 해당하는 행을 선택하십시오. 많은 항목이 나열되고 선택하면 항목을 해제 한 다음 명령을 해제 한 다음 명령을 해제 한 다음 파일을 인쇄 보드 (예 : FAQ.MD # 내 직렬 포트를 제공 해야하는 경우)를 보내려면 명령을 해제 한 다음 파일을 보낸 다음 FAQ.MD # 내 위치를 사용하십시오.) 자세한 내용은 메일 요청을 참조하십시오.

STM32 또는 클론 칩이있는 일반 마이크로 컨트롤러의 경우 LPC 칩 및 기타 SD 카드를 통해 특정 필드 플래시가 필요합니다.

이 방법을 가진 번쩍이는 때, 인쇄 널이 주인에 USB도 연결되지 않다는 것을 확인하는 것이 중요합니다, 몇몇 널이 널에 힘 뒤를 먹이고 사건에서 섬광을 멈출 수 있기 때문에.

SD 카드를 사용하는 대부분의 인쇄 보드는 SD 카드가 제자리에있을 때 신성한 플래시 루프 보호를 구현합니다. 두 가지 일반적인 방법이 있습니다.

파일 이름 (보통 "재고) : 필요 :"

이 보드는 플래시가 깜박이기 때문에 동일한 파일의 재생을 업데이트하고 업데이트하지 않습니다 (예 : firmware1.bin, firmware2.bin 등).

자동 파일 이름 (대개 시장 시장 인쇄 보드)을 교체하십시오.

다른 보드는 일반적으로 Firmare.bin과 함께 사용되지만 Firmare와 동일한 파일 이름을 사용할 수 있지만 깜박이는 보드가 파일을 firmware.cur로 변경하기 전에 펌웨어가 성공적으로 깜박이고 다음 시작에서 다시 깜박입니다.

깜박이기 전에 보드가 있는지 확인하십시오.

Atmega 칩을 사용하는 일반적인 마이크로 컨트롤러의 경우, 예를 들어 2560으로 코드는 다음과 유사한 것으로 깜박일 수 있습니다.

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

반드시 프린터의 고유한 시리얼 포트 이름으로 FLASH_DEVICE를 업데이트해야 합니다.

RP2040 칩을 사용하는 일반적인 마이크로 컨트롤러의 경우 코드는 다음과 같은 무언가로 깜박일 수 있습니다

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

이 작동 전에 RP2040 칩을 부팅 모드로 넣어야하는 것이 중요합니다.

## Klipper 구성 중

다음 단계는 [프린터 구성 파일](#4-klipper-configuration-file)을 호스트에 복사하는 것입니다.

압축 된 Concavelent 커넥터 파일은 Mainsail 또는 Futualded 내부 편집기를 사용하는 것입니다. 이렇게하면 구성 예제 및 프린터를 열 수 있습니다.

다른 옵션은 "SCP"및 / 또는 SFTP "프로토콜을 통해 파일 편집을 지원하는 데스크탑 편집기를 사용합니다. 이것은 예를 들어 메모장 ++, WinSCP 및 사이버 듀크를 지원하는 자유롭게 사용 가능한 도구입니다. 프린터 구성 파일을 편집기에로드하고 PI 사용자의 홈 디렉토리의"printer.cfg "라는 파일로 저장하십시오.

또는 하나의 SSH를 통해 호스트에서 파일을 복사하고 편집 할 수 있습니다. 프린터 구성 파일 이름을 명령하는 데 다음을 수집 할 수 있습니다.

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

각 프린터에는 마이크로 컨트롤러의 고유 한 이름이 있으므로 깜박임이 깜박일 수 있으면 다시 변경할 수 있으므로 이미 깜박일 때 수행 한 경우이 단계를 다시 실행할 수 있습니다. 실행 :

```
ls /dev/serial/by-id/*
```

다음과 같은 것을보고해야합니다 :

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

그런 다음 구성 파일을 고유 한 이름으로 업데이트하십시오. 예를 들어, "MCU] 섹션을 업데이트하고 다음을 참조하십시오.

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

파일을 만들고 편집 한 후 명령 콘솔에서 "restart"명령을 실행하여 구성을로드해야합니다. "상태"명령은 Klipper Config 파일이 성공적으로 읽고 프린터가 성공적으로 읽고 구성된 경우 프린터가 준비됩니다.

프린터 구성 파일을 사용자 정의 할 때 Klipper는 구성 오류를보고하기 위해 희소하지 않습니다. 오류가 발생하면 프린터 구성 파일에 필요한 수정을 수행하고 "프롬프트"를 준비 할 때까지 "다시 시작"을 실행하십시오.

Klipper는 명령 콘솔 및 원활한 및 마우스 팝업을 통해 오류 메시지를보고합니다. "상태"명령을 사용하여 오류 메시지를 다시 열 수 있습니다. 논리적으로`~ / printer_data / logs / klippy.log '를 로그온합니다.

Klipper가 프린터가 준비되었음을보고하면 [Config Check Document] (Config_checks.md)로 진행하여 구성 파일의 정의에 대한 기본 검사를 수행하십시오. 기본적인 [설명서 참조 (overview.md)를 참조하십시오.
