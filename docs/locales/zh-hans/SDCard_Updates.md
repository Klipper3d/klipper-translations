当今许多流行的控制器板都带有能够通过 SD 卡更新固件的引导加载程序。 虽然这在很多情况下都很方便，但这些引导加载程序通常不提供其他方式来更新固件。 如果您的电路板安装在很难插入SD卡的位置或者您需要经常更新固件，这可能会很麻烦。 在 Klipper 最初刷入控制器后，可以将新固件通过网络传输到 SD 卡并通过 ssh 启动刷写过程。

# 典型的升级程序

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

# 高级用法

上述命令假设您的 MCU 以默认波特率 250000 连接并且固件位于`~/klipper/out/klipper.bin`。 `flash-sdcard.sh` 脚本提供了更改这些默认值的选项。 所有选项都可以通过帮助画面查看：

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

如果您的电路板使用以自定义波特率连接的固件刷新，则可以通过指定 `-b` 选项进行升级：

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

如果您希望闪存位于默认位置以外的其他位置的 Klipper 构建，可以通过指定 `-f` 选项来完成：

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

请注意，升级 MKS Robin E3 时，无需手动运行 `update_mks_robin.py` 并将生成的二进制文件提供给 `flash-sdcard.sh`。 此过程在上传过程中自动执行。

# 注意事项

- 如介绍中所述，此方法仅适用于升级固件。 初始刷鞋程序必须按照适用于您的控制器板的说明手动完成。
- 虽然可以刷新更改串行波特率或连接接口（即：从 USB 到 UART）的构建，但验证终将失败，因为脚本将无法重新连接到 MCU 以验证当前版本。
- 仅支持使用 SPI 进行 SD 卡通信的板。 使用 SDIO 的板，例如 Flymaker Flyboard 和 MKS Robin Nano V1/V2，将无法工作。

# 电路板定义

大多数常见的电路板都应该可用，但如有必要，可以添加新的电路板定义。 板定义位于`~/klipper/scripts/spi_flash/board_defs.py`。 定义存储在字典中，例如：

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

可以指定以下字段：

- `mcu`: The mcu type. This can be retrevied after configuring the build via `make menuconfig` by running `cat .config | grep CONFIG_MCU`. This field is required.
- `spi_bus`：连接到 SD 卡的 SPI 总线。 这应该从电路板的原理图中检索。 此字段是必需的。
- `cs_pin`：连接到 SD 卡的芯片选择引脚。 这应该从电路板原理图中检索。 此字段是必需的。
- `firmware_path`：SD 卡上固件应传输的路径。 默认是`firmware.bin`。
- `current_firmware_path` 成功刷新后重命名的固件文件所在的 SD 卡上的路径。 默认是`firmware.cur`。

如果需要软件 SPI，`spi_bus` 字段应设置为 `swspi`，并应指定以下附加字段：

- `spi_pins`：这应该是 3 个逗号分隔的引脚，以 `miso,mosi,sclk` 的格式连接到 SD 卡。

软件 SPI 是必要的应该是非常罕见的，通常只有设计错误的板才会需要它。 `btt-skr-pro` 板定义提供了一个示例。

在创建新板定义之前，应检查现有板定义是否满足新板所需的标准。 如果是这种情况，可以指定`BOARD_ALIAS`。 例如，可以添加以下别名来指定“my-new-board”作为“generic-lpc1768”的别名：

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

如果您需要一个新的电路板定义并且您对上述过程感到不舒服，建议您在 [Klipper Community Discord](Contact.md#discord) 中请求一个。
