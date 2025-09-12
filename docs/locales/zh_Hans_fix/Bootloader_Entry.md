# 引导加载程序入口

可以通过以下一种方式指示Klipper重启并进入[引导加载程序](Bootloaders.md)：

## 请求引导加载程序

### 虚拟串行端口

如果使用的是虚拟（USB-ACM）串行端口，在1200波特率下脉冲DTR信号即可请求引导加载程序。

#### 使用Python（通过`flash_usb`）

使用Python（通过`flash_usb`）进入引导加载程序：

```shell
> cd klipper/scripts
> python3 -c 'import flash_usb as u; u.enter_bootloader("<DEVICE>")'
Entering bootloader on <DEVICE>
```

其中 `<DEVICE>` 是您的串行设备，例如 `/dev/serial.by-id/usb-Klipper[...]` 或 `/dev/ttyACM0`。

注意：如果此操作失败，将不会打印任何输出；成功时会显示 `Entering bootloader on <DEVICE>`。

#### 使用Picocom

```shell
picocom -b 1200 <DEVICE>
<Ctrl-A><Ctrl-P>
```

其中 `<DEVICE>` 是您的串行设备，例如 `/dev/serial.by-id/usb-Klipper[...]` 或 `/dev/ttyACM0`。

`<Ctrl-A><Ctrl-P>` 表示：按住 `Ctrl` 键，依次按下并释放 `a` 键和 `p` 键，然后松开 `Ctrl` 键。

### 物理串行端口

如果MCU上使用的是物理串行端口（即使使用USB串行适配器连接），发送字符串 `<SPACE><FS><SPACE>Request Serial Bootloader!!<SPACE>~` 可请求引导加载程序。

`<SPACE>` 是ASCII空格字符，0x20。

`<FS>` 是ASCII文件分隔符，0x1c。

注意：根据[MCU协议](Protocol.md#micro-controller-interface)，此消息本身是无效的，但同步字符（`~`）仍然会被识别。

由于此消息必须是其所在“数据块”中唯一的内容，如果之前有其他工具访问过串行端口，可以在前面添加一个额外的同步字符以提高可靠性。

#### Shell命令

```shell
stty <BAUD> < /dev/<DEVICE>
echo $'~ \x1c Request Serial Bootloader!! ~' >> /dev/<DEVICE>
```

其中 `<DEVICE>` 是您的串行端口，例如 `/dev/ttyS0` 或 `/dev/serial/by-id/gpio-serial2`，

`<BAUD>` 是串行端口的波特率，例如 `115200`。

### CAN总线

如果使用CAN总线，一个特殊的[管理消息](CANBUS_protocol.md#admin-messages)将请求引导加载程序。即使设备已有节点ID，此消息也会被接受，并且即使MCU已关闭也会被处理。

此方法也适用于以[CAN桥接](CANBUS.md#usb-to-can-bus-bridge-mode)模式运行的设备。

#### Katapult的flashtool.py

```shell
python3 ./katapult/scripts/flashtool.py -i <CAN_IFACE> -u <UUID> -r
```

其中 `<CAN_IFACE>` 是要使用的CAN接口。如果使用 `can0`，可以省略 `-i` 和 `<CAN_IFACE>` 参数。

`<UUID>` 是您的CAN设备的UUID。

有关查找设备CAN UUID的信息，请参阅[CAN总线文档](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers)。

## 进入引导加载程序

当Klipper收到上述任一引导加载程序请求时：

如果安装了Katapult（原名CANBoot），Klipper将请求Katapult在下次启动时保持活动状态，然后重置MCU（从而进入Katapult）。

如果未安装Katapult，Klipper将尝试进入特定于平台的引导加载程序，例如STM32的DFU模式（[见注释](#stm32-dfu-warning)）。

简而言之，如果安装了Katapult，Klipper将重启进入Katapult；否则将尝试进入特定于硬件的引导加载程序。

有关各种平台上特定引导加载程序的详细信息，请参阅[引导加载程序](Bootloaders.md)。

## 注意事项

### STM32 DFU警告

请注意，在某些主板上（如Octopus Pro v1），进入DFU模式可能会导致意外操作（例如在DFU模式下为加热器供电）。建议在使用DFU模式时断开加热器连接，并采取其他措施防止意外操作。请查阅您主板的文档以获取更多详细信息。