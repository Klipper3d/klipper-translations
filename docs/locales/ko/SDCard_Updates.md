# SDCard updates

오늘날 널리 사용되는 많은 컨트롤러 보드에는 SD 카드를 통해 펌웨어를 업데이트할 수 있는 부트로더가 함께 제공됩니다. 이는 많은 상황에서 편리하지만 일반적으로 이러한 부트로더는 펌웨어를 업데이트하는 다른 방법을 제공하지 않습니다. 보드가 접근하기 어려운 위치에 장착되어 있거나 펌웨어를 자주 업데이트해야 하는 경우 이는 골칫거리가 될 수 있습니다. Klipper가 처음에 컨트롤러에 플래시된 후 새 펌웨어를 SD 카드로 전송하고 ssh를 통해 flashing 절차를 시작할 수 있습니다.

## 일반적인 업그레이드 절차

SD 카드를 사용하여 MCU 펌웨어를 업데이트하는 절차는 다른 방법과 유사합니다. `make flash`를 사용하는 대신 `flash-sdcard.sh` 도우미 스크립트를 실행해야 합니다. BigTreeTech SKR 1.3 업데이트는 다음과 같습니다:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-skr-v1.3
sudo service klipper start
```

장치 위치와 보드 이름을 결정하는 것은 사용자의 몫입니다. 사용자가 여러 보드를 플래시해야 하는 경우 Klipper 서비스를 다시 시작하기 전에 각 보드에 대해 `flash-sdcard.sh`(또는 적절한 경우 `make flash')를 실행해야 합니다.

지원되는 보드는 다음 명령으로 나열할 수 있습니다:

```
./scripts/flash-sdcard.sh -l
```

보드가 나열되지 않으면 [아래 설명](#board-definitions)과 같이 새 보드 정의를 추가해야 할 수 있습니다.

## 고급 사용법

위의 명령은 MCU가 기본 전송 속도 250000으로 연결되고 펌웨어가 `~/klipper/out/klipper.bin`에 있다고 가정합니다. `flash-sdcard.sh` 스크립트는 이러한 기본값을 변경하기 위한 옵션을 제공합니다. 모든 옵션은 도움말 화면에서 볼 수 있습니다:

```
./scripts/flash-sdcard.sh -h
SD Card upload utility for Klipper

usage: flash_sdcard.sh [-h] [-l] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -b <baud>       serial baud rate (default is 250000)
  -f <firmware>   path to klipper.bin
```

보드가 사용자 정의 전송 속도로 연결되는 펌웨어로 플래시되면 `-b` 옵션을 지정하여 업그레이드할 수 있습니다:

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

기본 위치가 아닌 다른 위치에 있는 Klipper 빌드를 플래시하려면 `-f` 옵션을 지정하여 수행할 수 있습니다:

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

MKS Robin E3를 업그레이드할 때 `update_mks_robin.py`를 수동으로 실행하고 결과 바이너리를 `flash-sdcard.sh`에 제공할 필요가 없습니다. 이 절차는 업로드 과정에서 자동화됩니다.

## 주의 사항

- 소개에서 언급했듯이 이 방법은 펌웨어 업그레이드에만 적용됩니다. 초기 깜박임 절차는 컨트롤러 보드에 적용되는 지침에 따라 수동으로 수행해야 합니다.
- 직렬 전송 또는 연결 인터페이스를 변경하는 빌드를 플래시할 수 있지만 (예: USB에서 UART로) 스크립트가 현재 버전을 확인하기 위해 MCU에 다시 연결할 수 없기 때문에 항상 확인이 실패합니다.
- SD 카드 통신을 위해 SPI를 사용하는 보드만 지원됩니다. Flymaker Flyboard 및 MKS Robin Nano V1/V2와 같이 SDIO를 사용하는 보드는 작동하지 않습니다.

## 보드 정의

대부분의 공통 보드를 사용할 수 있어야 하지만 필요한 경우 새 보드 정의를 추가할 수 있습니다. 보드 정의는 `~/klipper/scripts/spi_flash/board_defs.py`에 있습니다. 정의는 사전에 저장됩니다. 예를 들면 다음과 같습니다:

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<further definitions>
}
```

다음 필드를 지정할 수 있습니다:

- `mcu`: MCU 유형입니다. 이것은 `cat .config | grep CONFIG_MCU` 실행하여 `make menuconfig`로 그 빌드를 구성한 후 복구할 수 있습니다. 이 필드는 필수입니다.
- `spi_bus`: SD 카드에 연결된 SPI 버스입니다. 이것은 보드의 회로도에서 가져와야 합니다. 이 필드는 필수입니다.
- `cs_pin`: SD 카드에 연결된 칩 선택 핀입니다. 이것은 보드 회로도에서 검색해야 합니다. 이 필드는 필수입니다.
- `firmware_path`: 펌웨어가 전송되어야 하는 SD 카드의 경로입니다. 기본값은 'firmware.bin'입니다.
- `current_firmware_path` 플래시 성공 후 이름이 변경된 펌웨어 파일이 있는 SD 카드의 경로입니다. 기본값은 'firmware.cur'입니다.

소프트웨어 SPI가 필요한 경우 `spi_bus` 필드를 `swspi`로 설정하고 다음 추가 필드를 지정해야 합니다:

- `spi_pins`: `miso,mosi,sclk` 형식으로 SD 카드에 연결된 3개의 쉼표로 구분된 핀이어야 합니다.

소프트웨어 SPI가 필요한 경우는 극히 드물며 일반적으로 설계 오류가 있는 보드에만 필요합니다. `btt-skr-pro` 보드 정의는 예를 제공합니다.

새 보드 정의를 만들기 전에 기존 보드 정의가 새 보드에 필요한 기준을 충족하는지 확인해야 합니다. 이 경우 `BOARD_ALIAS`를 지정할 수 있습니다. 예를 들어 다음 별칭을 추가하여 `my-new-board`를 `generic-lpc1768`의 별칭으로 지정할 수 있습니다:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

새로운 보드 정의가 필요하고 위에 설명된 절차가 불편하시다면 [Klipper Community Discord](Contact.md#discord)에서 요청하는 것이 좋습니다.
