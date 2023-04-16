# 通過SD卡更新

當今許多流行的控制器板都帶有能夠通過 SD 卡更新韌體的引導載入程式。 雖然這在很多情況下都很方便，但這些引導載入程式通常不提供其他方式來更新韌體。 如果您的電路板安裝在很難插入SD卡的位置或者您需要經常更新韌體，這可能會很麻煩。 在 Klipper 最初刷入控制器后，可以將新韌體通過網路傳輸到 SD 卡並通過 ssh 啟動刷寫過程。

## 典型的升級程式

使用 SD 卡更新 MCU 韌體的過程與其他方法類似。 不需要使用`make flash`，而是需要執行一個輔助指令碼`flash-sdcard.sh`。 更新 BigTreeTech SKR 1.3 可能如下所示：

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

由使用者決定裝置位置和電路板名稱。 如果使用者需要重新整理多個板，在重新啟動 Klipper 服務之前，應該為每個板執行 `flash-sdcard.sh`（或`make flash`，如果合適）。

可以使用以下命令列出支援的微控制器板：

```
./scripts/flash-sdcard.sh -l
```

如果您沒有看到您的電路板列出，則可能需要新增一個新的電路板定義[如下所述](#board-definitions)。

## 高級用法

上述命令假設您的 MCU 以預設波特率 250000 連線並且韌體位於`~/klipper/out/klipper.bin`。 `flash-sdcard.sh` 指令碼提供了更改這些預設值的選項。 所有選項都可以通過幫助畫面檢視：

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

如果您的電路板使用以自定義波特率連線的韌體重新整理，則可以通過指定 `-b` 選項進行升級：

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

如果您希望快閃記憶體位於預設位置以外的其他位置的 Klipper 構建，可以通過指定 `-f` 選項來完成：

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

請注意，升級 MKS Robin E3 時，無需手動執行 `update_mks_robin.py` 並將產生的二進制檔案提供給 `flash-sdcard.sh`。 此過程在上傳過程中自動執行。

The `-c` option is used to perform a check or verify-only operation to test if the board is running the specified firmware correctly. This option is primarily intended for cases where a manual power-cycle is necessary to complete the flashing procedure, such as with bootloaders that use SDIO mode instead of SPI to access their SD Cards. (See Caveats below) But, it can also be used anytime to verify if the code flashed into the board matches the version in your build folder on any supported board.

## 注意事項

- 如介紹中所述，此方法僅適用於升級韌體。 初始刷鞋程式必須按照適用於您的控制器板的說明手動完成。
- 雖然可以重新整理更改序列波特率或連線介面（即：從 USB 到 UART）的構建，但驗證終將失敗，因為指令碼將無法重新連線到 MCU 以驗證目前版本。
- Only boards that use SPI for SD Card communication are supported. Boards that use SDIO, such as the Flymaker Flyboard and MKS Robin Nano V1/V2, will not work in SDIO mode. However, it's usually possible to flash such boards using Software SPI mode instead. But if the board's bootloader only uses SDIO mode to access the SD Card, a power-cycle of the board and SD Card will be necessary so that the mode can switch from SPI back to SDIO to complete reflashing. Such boards should be defined with `skip_verify` enabled to skip the verify step immediately after flashing. Then after the manual power-cycle, you can rerun the exact same `./scripts/flash-sdcard.sh` command, but add the `-c` option to complete the check/verify operation. See [Flashing Boards that use SDIO](#flashing-boards-that-use-sdio) for examples.

## 電路板定義

大多數常見的電路板都應該可用，但如有必要，可以新增新的電路板定義。 板定義位於`~/klipper/scripts/spi_flash/board_defs.py`。 定義儲存在字典中，例如：

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<更多定義>
}
```

可以指定以下欄位：

- `mcu`: The mcu type. This can be retrieved after configuring the build via `make menuconfig` by running `cat .config | grep CONFIG_MCU`. This field is required.
- `spi_bus`: The SPI bus connected to the SD Card. This should be retrieved from the board's schematic. This field is required.
- `cs_pin`: The Chip Select Pin connected to the SD Card. This should be retrieved from the board schematic. This field is required.
- `firmware_path`：SD 卡上韌體應傳輸的路徑。 預設是`firmware.bin`。
- `current_firmware_path`: The path on the SD Card where the renamed firmware file is located after a successful flash. The default is `firmware.cur`.
- `skip_verify`: This defines a boolean value which tells the scripts to skip the firmware verification step during the flashing process. The default is `False`. It can be set to `True` for boards that require a manual power-cycle to complete flashing. To verify the firmware afterward, run the script again with the `-c` option to perform the verification step. [See caveats with SDIO cards](#caveats)

If software SPI is required, the `spi_bus` field should be set to `swspi` and the following additional field should be specified:

- `spi_pins`：這應該是 3 個逗號分隔的引腳，以 `miso,mosi,sclk` 的格式連線到 SD 卡。

It should be exceedingly rare that Software SPI is necessary, typically only boards with design errors or boards that normally only support SDIO mode for their SD Card will require it. The `btt-skr-pro` board definition provides an example of the former, and the `btt-octopus-f446-v1` board definition provides an example of the latter.

在建立新板定義之前，應檢查現有板定義是否滿足新板所需的標準。 如果是這種情況，可以指定`BOARD_ALIAS`。 例如，可以新增以下別名來指定「my-new-board」作為「generic-lpc1768」的別名：

```python
BOARD_ALIASES = {
    ...<原先的別名>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

如果您需要一個新的電路板定義並且您對上述過程感到不舒服，建議您在 [Klipper Community Discord](Contact.md#discord) 中請求一個。

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
