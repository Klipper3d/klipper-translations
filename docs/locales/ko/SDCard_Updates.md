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

usage: flash_sdcard.sh [-h] [-l] [-c] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -c              run flash check/verify only (skip upload)
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

The `-c` option is used to perform a check or verify-only operation to test if the board is running the specified firmware correctly. This option is primarily intended for cases where a manual power-cycle is necessary to complete the flashing procedure, such as with bootloaders that use SDIO mode instead of SPI to access their SD Cards. (See Caveats below) But, it can also be used anytime to verify if the code flashed into the board matches the version in your build folder on any supported board.

## 주의 사항

- 소개에서 언급했듯이 이 방법은 펌웨어 업그레이드에만 적용됩니다. 초기 깜박임 절차는 컨트롤러 보드에 적용되는 지침에 따라 수동으로 수행해야 합니다.
- 직렬 전송 또는 연결 인터페이스를 변경하는 빌드를 플래시할 수 있지만 (예: USB에서 UART로) 스크립트가 현재 버전을 확인하기 위해 MCU에 다시 연결할 수 없기 때문에 항상 확인이 실패합니다.
- Only boards that use SPI for SD Card communication are supported. Boards that use SDIO, such as the Flymaker Flyboard and MKS Robin Nano V1/V2, will not work in SDIO mode. However, it's usually possible to flash such boards using Software SPI mode instead. But if the board's bootloader only uses SDIO mode to access the SD Card, a power-cycle of the board and SD Card will be necessary so that the mode can switch from SPI back to SDIO to complete reflashing. Such boards should be defined with `skip_verify` enabled to skip the verify step immediately after flashing. Then after the manual power-cycle, you can rerun the exact same `./scripts/flash-sdcard.sh` command, but add the `-c` option to complete the check/verify operation. See [Flashing Boards that use SDIO](#flashing-boards-that-use-sdio) for examples.

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

- `mcu`: The mcu type. This can be retrieved after configuring the build via `make menuconfig` by running `cat .config | grep CONFIG_MCU`. This field is required.
- `spi_bus`: The SPI bus connected to the SD Card. This should be retrieved from the board's schematic. This field is required.
- `cs_pin`: The Chip Select Pin connected to the SD Card. This should be retrieved from the board schematic. This field is required.
- `firmware_path`: 펌웨어가 전송되어야 하는 SD 카드의 경로입니다. 기본값은 'firmware.bin'입니다.
- `current_firmware_path`: The path on the SD Card where the renamed firmware file is located after a successful flash. The default is `firmware.cur`.
- `skip_verify`: This defines a boolean value which tells the scripts to skip the firmware verification step during the flashing process. The default is `False`. It can be set to `True` for boards that require a manual power-cycle to complete flashing. To verify the firmware afterward, run the script again with the `-c` option to perform the verification step. [See caveats with SDIO cards](#caveats)

If software SPI is required, the `spi_bus` field should be set to `swspi` and the following additional field should be specified:

- `spi_pins`: `miso,mosi,sclk` 형식으로 SD 카드에 연결된 3개의 쉼표로 구분된 핀이어야 합니다.

It should be exceedingly rare that Software SPI is necessary, typically only boards with design errors or boards that normally only support SDIO mode for their SD Card will require it. The `btt-skr-pro` board definition provides an example of the former, and the `btt-octopus-f446-v1` board definition provides an example of the latter.

새 보드 정의를 만들기 전에 기존 보드 정의가 새 보드에 필요한 기준을 충족하는지 확인해야 합니다. 이 경우 `BOARD_ALIAS`를 지정할 수 있습니다. 예를 들어 다음 별칭을 추가하여 `my-new-board`를 `generic-lpc1768`의 별칭으로 지정할 수 있습니다:

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

새로운 보드 정의가 필요하고 위에 설명된 절차가 불편하시다면 [Klipper Community Discord](Contact.md#discord)에서 요청하는 것이 좋습니다.

## Flashing Boards that use SDIO

[As mentioned in the Caveats](#caveats), boards whose bootloader uses SDIO mode to access their SD Card require a power-cycle of the board, and specifically the SD Card itself, in order to switch from the SPI Mode used while writing the file to the SD Card back to SDIO mode for the bootloader to flash it into the board. These board definitions will use the `skip_verify` flag, which tells the flashing tool to stop after writing the firmware to the SD Card so that the board can be manually power-cycled and the verification step deferred until that's complete.

There are two scenarios -- one with the RPi Host running on a separate power supply and the other when the RPi Host is running on the same power supply as the main board being flashed. The difference is whether or not it's necessary to also shutdown the RPi and then `ssh` again after the flashing is complete in order to do the verification step, or if the verification can be done immediately. Here's examples of the two scenarios:

### SDIO Programming with RPi on Separate Power Supply

A typical session with the RPi on a Separate Power Supply looks like the following. You will, of course, need to use your proper device path and board name:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
[[[manually power-cycle the printer board here when instructed]]]
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

### SDIO Programming with RPi on the Same Power Supply

A typical session with the RPi on the Same Power Supply looks like the following. You will, of course, need to use your proper device path and board name:

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
sudo shutdown -h now
[[[wait for the RPi to shutdown, then power-cycle and ssh again to the RPi when it restarts]]]
sudo service klipper stop
cd ~/klipper
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

In this case, since the RPi Host is being restarted, which will restart the `klipper` service, it's necessary to stop `klipper` again before doing the verification step and restart it after verification is complete.

### SDIO to SPI Pin Mapping

If your board's schematic uses SDIO for its SD Card, you can map the pins as described in the chart below to determine the compatible Software SPI pins to assign in the `board_defs.py` file:

| SD Card Pin | Micro SD Card Pin | SDIO Pin Name | SPI Pin Name |
| :-: | :-: | :-: | :-: |
| 9 | 1 | DATA2 | None (PU)* |
| 1 | 2 | CD/DATA3 | CS |
| 2 | 3 | CMD | MOSI |
| 4 | 4 | +3.3V (VDD) | +3.3V (VDD) |
| 5 | 5 | CLK | SCLK |
| 3 | 6 | GND (VSS) | GND (VSS) |
| 7 | 7 | DATA0 | MISO |
| 8 | 8 | DATA1 | None (PU)* |
| N/A | 9 | Card Detect (CD) | Card Detect (CD) |
| 6 | 10 | GND | GND |

\* None (PU) indicates an unused pin with a pull-up resistor
