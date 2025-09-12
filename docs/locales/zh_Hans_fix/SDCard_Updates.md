# SD卡固件更新

如今许多流行的控制器板都配备有可通过SD卡更新固件的引导程序（bootloader）。尽管在许多情况下这非常方便，但这些引导程序通常没有其他更新固件的方式。如果你的控制板安装在难以接触的位置，或需要频繁更新固件，这可能会带来不便。在Klipper首次被刷入控制器后，可以通过SSH将新固件传输到SD卡并启动刷写过程。

## 典型升级流程

使用SD卡更新MCU固件的流程与其他方法类似。不同之处在于，不使用`make flash`命令，而是运行一个辅助脚本`flash-sdcard.sh`。例如，更新BigTreeTech SKR 1.3板卡的过程可能如下所示：
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

用户需要自行确定设备位置和板卡名称。如果需要为多个板卡刷写固件，应在重启Klipper服务之前，为每个板卡依次运行`flash-sdcard.sh`（或适当情况下使用`make flash`）。

可以使用以下命令列出支持的板卡：
```
./scripts/flash-sdcard.sh -l
```
如果未在列表中看到你的板卡，可能需要按照下方[板卡定义说明](#board-definitions)添加新的板卡定义。

## 高级用法

上述命令假定你的MCU以默认波特率250000连接，且固件位于`~/klipper/out/klipper.bin`。`flash-sdcard.sh`脚本提供了更改这些默认值的选项。所有选项均可通过帮助屏幕查看：
```
./scripts/flash-sdcard.sh -h
SD卡上传工具，用于Klipper

用法: flash_sdcard.sh [-h] [-l] [-c] [-b <baud>] [-f <firmware>]
                       <device> <board>

位置参数:
  <device>        设备串行端口
  <board>         板卡类型

可选参数:
  -h              显示此消息
  -l              列出可用板卡
  -c              仅执行刷写检查/验证（跳过上传）
  -b <baud>       串行波特率（默认为250000）
  -f <firmware>   klipper.bin文件路径
```

如果板卡刷写的固件使用了自定义波特率连接，可以通过指定`-b`选项进行升级：
```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

如果希望刷写一个不在默认位置的Klipper构建版本，可以通过指定`-f`选项实现：
```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

请注意，升级MKS Robin E3时，无需手动运行`update_mks_robin.py`并将生成的二进制文件提供给`flash-sdcard.sh`。此过程在上传过程中已自动完成。

`-c`选项用于执行检查或仅验证操作，以测试板卡是否正确运行指定的固件。此选项主要用于需要手动断电重启才能完成刷写过程的情况，例如使用SDIO模式而非SPI访问SD卡的引导程序。（见下方注意事项）但也可以随时用于验证刷入板卡的代码是否与你构建文件夹中的版本匹配，适用于任何支持的板卡。

## 注意事项

- 如引言所述，此方法仅适用于固件升级。首次刷写过程必须按照适用于你控制器板的说明手动完成。
- 虽然可以刷写一个更改了串行波特率或连接接口（例如从USB改为UART）的固件，但验证步骤总会失败，因为脚本将无法重新连接到MCU以验证当前版本。
- 仅支持使用SPI进行SD卡通信的板卡。使用SDIO的板卡，例如Flymaker Flyboard和MKS Robin Nano V1/V2，在SDIO模式下无法工作。然而，通常可以改用软件SPI模式刷写此类板卡。但如果板卡的引导程序仅使用SDIO模式访问SD卡，则必须对板卡和SD卡进行断电重启，以便模式能从SPI切换回SDIO以完成重新刷写。此类板卡应在定义时启用`skip_verify`，以跳过刷写后的验证步骤。然后在手动断电重启后，可以重新运行完全相同的`./scripts/flash-sdcard.sh`命令，但添加`-c`选项来完成检查/验证操作。示例请参见[使用SDIO的板卡刷写](#flashing-boards-that-use-sdio)。

## 板卡定义

大多数常见板卡都已支持，但如有需要，也可以添加新的板卡定义。板卡定义位于`~/klipper/scripts/spi_flash/board_defs.py`中。定义以字典形式存储，例如：
```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<其他定义>
}
```

可以指定以下字段：
- `mcu`: MCU类型。可通过运行`make menuconfig`配置构建后，执行`cat .config | grep CONFIG_MCU`获取。此字段为必填项。
- `spi_bus`: 连接到SD卡的SPI总线。应从板卡原理图中获取。此字段为必填项。
- `cs_pin`: 连接到SD卡的片选（Chip Select）引脚。应从板卡原理图中获取。此字段为必填项。
- `firmware_path`: 固件应传输到SD卡上的路径。默认为`firmware.bin`。
- `current_firmware_path`: 成功刷写后，重命名的固件文件在SD卡上的位置。默认为`firmware.cur`。
- `skip_verify`: 定义一个布尔值，告诉脚本在刷写过程中跳过固件验证步骤。默认为`False`。对于需要手动断电重启才能完成刷写的板卡，可设置为`True`。之后要验证固件，可再次运行脚本并加上`-c`选项执行验证步骤。[参见SDIO卡相关注意事项](#caveats)

如果需要使用软件SPI，则应将`spi_bus`字段设置为`swspi`，并指定以下附加字段：
- `spi_pins`: 应为3个以逗号分隔的引脚，按`miso,mosi,sclk`格式连接到SD卡。

需要软件SPI的情况极为罕见，通常仅限于存在设计错误的板卡，或通常仅支持SDIO模式的板卡。`btt-skr-pro`板卡定义是前者的示例，`btt-octopus-f446-v1`板卡定义是后者的示例。

在创建新板卡定义之前，应先检查现有板卡定义是否满足新板卡的必要条件。如果满足，可指定一个`BOARD_ALIAS`。例如，可添加以下别名，将`my-new-board`定义为`generic-lpc1768`的别名：
```python
BOARD_ALIASES = {
    ...<之前的别名>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

如果你需要一个新的板卡定义，但对上述流程不熟悉，建议在[Klipper Discord](Contact.md)中请求帮助。

## 使用SDIO的板卡刷写

[如注意事项中所述](#caveats)，其引导程序使用SDIO模式访问SD卡的板卡，需要对板卡特别是SD卡本身进行断电重启，以便从写入文件时使用的SPI模式切换回SDIO模式，从而使引导程序能将固件刷入板卡。这些板卡定义将使用`skip_verify`标志，该标志告诉刷写工具在将固件写入SD卡后停止，以便可以手动断电重启，并将验证步骤推迟到之后完成。

有两种场景——一种是树莓派（RPi）主机使用独立电源，另一种是树莓派主机与要刷写的主控板使用同一电源。区别在于是否需要在刷写完成后也关闭树莓派，然后重新`ssh`连接以执行验证步骤，还是可以立即进行验证。以下是两种场景的示例：

### 树莓派使用独立电源的SDIO编程

树莓派使用独立电源的典型会话如下所示。当然，你需要使用正确的设备路径和板卡名称：
```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
[[[在此处手动断电重启打印机板卡]]]
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

### 树莓派使用同一电源的SDIO编程

树莓派使用同一电源的典型会话如下所示。当然，你需要使用正确的设备路径和板卡名称：
```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
sudo shutdown -h now
[[[等待树莓派关机，然后断电重启并在重启后重新ssh连接到树莓派]]]
sudo service klipper stop
cd ~/klipper
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

在这种情况下，由于树莓派主机正在重启，这将重启`klipper`服务，因此在执行验证步骤前需要再次停止`klipper`，并在验证完成后重新启动它。

### SDIO到SPI引脚映射

如果你的板卡原理图使用SDIO连接SD卡，可以按照下表中的描述映射引脚，以确定在`board_defs.py`文件中分配的兼容软件SPI引脚：

| SD卡引脚 | Micro SD卡引脚 |  SDIO引脚名称   |   SPI引脚名称   |
| :---------: | :----------------: | :--------------: | :--------------: |
|      9      |         1          |       DATA2      |     None (PU)*   |
|      1      |         2          |      CD/DATA3    |        CS        |
|      2      |         3          |        CMD       |       MOSI       |
|      4      |         4          |    +3.3V (VDD)   |    +3.3V (VDD)   |
|      5      |         5          |        CLK       |       SCLK       |
|      3      |         6          |     GND (VSS)    |     GND (VSS)    |
|      7      |         7          |       DATA0      |       MISO       |
|      8      |         8          |       DATA1      |     None (PU)*   |
|     N/A     |         9          | Card Detect (CD) | Card Detect (CD) |
|      6      |        10          |       GND        |        GND       |

\* None (PU) 表示未使用的引脚，带有上拉电阻