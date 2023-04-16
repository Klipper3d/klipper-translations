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
Klipper SD卡上传工具

usage: flash_sdcard.sh [-h] [-l] [-c] [-b <波特率>] [-f <固件>]
                       <设备> <控制板>

位置参数：
  <设备>        设备串口
  <控制板>         控制板类型

可选参数：
  -h              显示此信息
  -l              列出可用控制板
  -c              进行闪存检查/仅验证（跳过上传）
  -b <波特率>      串口波特率 (默认为250000)
  -f <firmware>   klipper.bin文件路径
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

`-c` 选项用于执行检查或只验证的操作，以测试控制板是否正确运行指定的固件。这个选项主要是针对需要手动断电来完成刷写程序的情况，比如使用SDIO模式而不是SPI来访问SD卡的引导程序。(见下面的注意事项）但是，它也可以在任何时候用来验证在任何支持的板子上刷入板子的固件是否与你的构建文件夹中的版本一致。

## 注意事项

- 如介绍中所述，此方法仅适用于升级固件。 初始刷鞋程序必须按照适用于您的控制器板的说明手动完成。
- 虽然可以刷新更改串行波特率或连接接口（即：从 USB 到 UART）的构建，但验证终将失败，因为脚本将无法重新连接到 MCU 以验证当前版本。
- 只支持使用SPI进行SD卡通信的控制板。使用SDIO的控制，如Flymaker Flyboard和MKS Robin Nano V1/V2，将不能在SDIO模式下工作。然而，通常可以使用软件 SPI 模式来刷写这种板子。但是如果板子的 bootloader 只支持使用SDIO模式来访问SD卡，就需要对板子和SD卡进行电源循环，以便模式可以从SPI切换回SDIO来完成重新刷写。这样的板子应该在定义时启用`skip_verify` ，以便在刷写后立即跳过验证步骤。然后在手动断电后，你可以重新运行完全相同的`./scripts/flash-sdcard.sh` 命令，但加入`-c` 选项来完成检查/验证操作。请参阅[刷写使用SDIO的控制板](#flashing-boards-that-use-sdio)以了解实例。

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
- `spi_bus`：连接到 SD 卡的 SPI 总线。 这应该可以在控制板的原理图中找到。 此字段是必需的。
- `cs_pin`：连接到 SD 卡的芯片选择引脚。 可以在控制板的原理图中找到。 此字段是必需的。
- `firmware_path`：SD 卡上固件应传输的路径。 默认是`firmware.bin`。
- `current_firmware_path` ：刷写成功后，SD卡上重命名的固件文件所在的路径。默认是`firmware.cur` 。
- `skip_verify`: 定义了一个布尔值，它告诉脚本在刷写过程中跳过固件验证步骤。默认值是`False` 。对于需要手动断电才能完成刷写的控制板，它可以被设置为`True` 。要想在之后验证固件，可以用`-c` 选项再次运行脚本来执行验证步骤。[参见SDIO卡的注意事项](#caveats)

如果需要软件 SPI，`spi_bus` 字段应设置为 `swspi`，并应指定以下附加字段：

- `spi_pins`：这应该是 3 个逗号分隔的引脚，以 `miso,mosi,sclk` 的格式连接到 SD 卡。

通常只有设计错误或只支持SD卡的SDIO模式的控制板才会需要软件SPI，这种情况极为罕见。`btt-skr-pro` 控制板定义提供了前者的例子，`btt-octopus-f446-v1` 控制板定义提供了后者的例子。

在创建新板定义之前，应检查现有板定义是否满足新板所需的标准。 如果是这种情况，可以指定`BOARD_ALIAS`。 例如，可以添加以下别名来指定“my-new-board”作为“generic-lpc1768”的别名：

```python
BOARD_ALIASES = {
    ...<原先的别名>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

如果您需要一个新的电路板定义并且您对上述过程感到不舒服，建议您在 [Klipper Community Discord](Contact.md#discord) 中请求一个。

## 刷写使用SDIO的控制板

[正如在注意事项中提到的那样](#caveats)，引导程序使用SDIO模式访问它们的SD卡的控制板需要对控制板进行电源循环，特别是SD卡本身，以便从将文件写入SD卡时使用的SPI模式切换回SDIO模式，以便引导程序将其刷写到板子上。这些板子的定义将使用`skip_verify` 标志，它告诉刷写工具在将固件写入SD卡后停止，以便控制板可以手动断电并推迟验证步骤直到完成。

有两种情况 - 一种是RPi主机在独立电源上运行，另一种是RPi主机与被刷写的主板在同一电源上运行。区别在于是否有必要同时关闭RPi，然后在刷写完成后再次`ssh` ，以进行验证步骤，或者是否可以立即进行验证。下面是这两种情况的例子：

### RPi有独立的电源时进行SDIO刷写

使用独立电源的RPi的典型流程看起来像下面这样。当然，你需要使用适当的设备路径和控制板名称：

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
[[[在提示时手动重启打印机控制板]]]
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

### 对与RPi在同一电源上的主板进行SDIO刷写

RPI和控制板在同一电源上的典型会话看起来像下面这样。当然，你需要使用正确的设备路径和控制板名称：

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
sudo shutdown -h now
[[[等RPI关机后，断电重启后再次 ssh 连接到 RPi]]]
sudo service klipper stop
cd ~/klipper
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

在这种情况下，由于RPi主机被重新启动，这将重新启动`klipper` 服务，所以有必要在做验证步骤之前再次停止`klipper` ，并在验证完成后重新启动服务。

### SDIO到SPI引脚映射

如果你的控制板原理图显示它使用SDIO的SD卡，你可以按照下图描述的方式映射引脚，以确定在`board_defs.py` 文件中分配的兼容的软件SPI引脚：

| SD 卡引脚 | MicroSD卡引脚 | SDIO 引脚名称 | SPI引脚名称 |
| :-: | :-: | :-: | :-: |
| 9 | 1 | DATA2 | None (PU)* |
| 1 | 2 | CD/DATA3 | CS |
| 2 | 3 | CMD | MOSI |
| 4 | 4 | +3.3V (VDD) | +3.3V (VDD) |
| 5 | 5 | CLK | SCLK |
| 3 | 6 | GND (VSS) | GND (VSS) |
| 7 | 7 | DATA0 | MISO |
| 8 | 8 | DATA1 | None (PU)* |
| N/A | 9 | 卡片检测 (CD) | 卡片检测 (CD) |
| 6 | 10 | GND | GND |

\* None (PU)表示有上拉电阻的未使用引脚
