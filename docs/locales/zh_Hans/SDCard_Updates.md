# 通过SD卡更新

当今许多流行的控制器板都带有能够通过 SD 卡更新固件的引导加载程序。 虽然这在很多情况下都很方便，但这些引导加载程序通常不提供其他方式来更新固件。 如果您的电路板安装在很难插入SD卡的位置或者您需要经常更新固件，这可能会很麻烦。 在 Klipper 最初刷入控制器后，可以将新固件通过网络传输到 SD 卡并通过 ssh 启动刷写过程。

## 典型的升级程序

使用 SD 卡更新 MCU 固件的过程与其他方法类似。 不需要使用`make flash`，而是需要运行一个辅助脚本`flash-sdcard.sh`。 更新 BigTreeTech SKR 1.3 可能如下所示：

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

由用户决定设备位置和电路板名称。 如果用户需要刷新多个板，在重新启动 Klipper 服务之前，应该为每个板运行 `flash-sdcard.sh`（或`make flash`，如果合适）。

可以使用以下命令列出支持的微控制器板：

```
./scripts/flash-sdcard.sh -l
```

如果您没有看到您的电路板列出，则可能需要添加一个新的电路板定义[如下所述](#board-definitions)。

## 高级用法

上述命令假设您的 MCU 以默认波特率 250000 连接并且固件位于`~/klipper/out/klipper.bin`。 `flash-sdcard.sh` 脚本提供了更改这些默认值的选项。 所有选项都可以通过帮助画面查看：

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

如果您的电路板使用以自定义波特率连接的固件刷新，则可以通过指定 `-b` 选项进行升级：

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

如果您希望闪存位于默认位置以外的其他位置的 Klipper 构建，可以通过指定 `-f` 选项来完成：

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

请注意，升级 MKS Robin E3 时，无需手动运行 `update_mks_robin.py` 并将生成的二进制文件提供给 `flash-sdcard.sh`。 此过程在上传过程中自动执行。

The `-c` option is used to perform a check or verify-only operation to test if the board is running the specified firmware correctly. This option is primarily intended for cases where a manual power-cycle is necessary to complete the flashing procedure, such as with bootloaders that use SDIO mode instead of SPI to access their SD Cards. (See Caveats below) But, it can also be used anytime to verify if the code flashed into the board matches the version in your build folder on any supported board.

## 注意事项

- 如介绍中所述，此方法仅适用于升级固件。 初始刷鞋程序必须按照适用于您的控制器板的说明手动完成。
- 虽然可以刷新更改串行波特率或连接接口（即：从 USB 到 UART）的构建，但验证终将失败，因为脚本将无法重新连接到 MCU 以验证当前版本。
- Only boards that use SPI for SD Card communication are supported. Boards that use SDIO, such as the Flymaker Flyboard and MKS Robin Nano V1/V2, will not work in SDIO mode. However, it's usually possible to flash such boards using Software SPI mode instead. But if the board's bootloader only uses SDIO mode to access the SD Card, a power-cycle of the board and SD Card will be necessary so that the mode can switch from SPI back to SDIO to complete reflashing. Such boards should be defined with `skip_verify` enabled to skip the verify step immediately after flashing. Then after the manual power-cycle, you can rerun the exact same `./scripts/flash-sdcard.sh` command, but add the `-c` option to complete the check/verify operation. See [Flashing Boards that use SDIO](#flashing-boards-that-use-sdio) for examples.

## 电路板定义

大多数常见的电路板都应该可用，但如有必要，可以添加新的电路板定义。 板定义位于`~/klipper/scripts/spi_flash/board_defs.py`。 定义存储在字典中，例如：

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<更多定义>
}
```

可以指定以下字段：

- `mcu`：微控制器类型。这可以在使用`make menuconfig`配置构建配置后通过运行`cat .config | grep CONFIG_MCU`获取。 此字段是必需的。
- `spi_bus`：连接到 SD 卡的 SPI 总线。 这应该从电路板的原理图中检索。 此字段是必需的。
- `cs_pin`：连接到 SD 卡的芯片选择引脚。 这应该从电路板原理图中检索。 此字段是必需的。
- `firmware_path`：SD 卡上固件应传输的路径。 默认是`firmware.bin`。
- `current_firmware_path`: The path on the SD Card where the renamed firmware file is located after a successful flash. The default is `firmware.cur`.
- `skip_verify`: This defines a boolean value which tells the scripts to skip the firmware verification step during the flashing process. The default is `False`. It can be set to `True` for boards that require a manual power-cycle to complete flashing. To verify the firmware afterward, run the script again with the `-c` option to perform the verification step. [See caveats with SDIO cards](#caveats)

If software SPI is required, the `spi_bus` field should be set to `swspi` and the following additional field should be specified:

- `spi_pins`：这应该是 3 个逗号分隔的引脚，以 `miso,mosi,sclk` 的格式连接到 SD 卡。

It should be exceedingly rare that Software SPI is necessary, typically only boards with design errors or boards that normally only support SDIO mode for their SD Card will require it. The `btt-skr-pro` board definition provides an example of the former, and the `btt-octopus-f446-v1` board definition provides an example of the latter.

在创建新板定义之前，应检查现有板定义是否满足新板所需的标准。 如果是这种情况，可以指定`BOARD_ALIAS`。 例如，可以添加以下别名来指定“my-new-board”作为“generic-lpc1768”的别名：

```python
BOARD_ALIASES = {
    ...<原先的别名>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

如果您需要一个新的电路板定义并且您对上述过程感到不舒服，建议您在 [Klipper Community Discord](Contact.md#discord) 中请求一个。

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
