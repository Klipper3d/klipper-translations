# 引导加载程序条目

可以通过以下方式之一指示Klipper重新启动到[BootLoader](Bootloaders.md)：

## 请求引导加载程序

### 虚拟串口

如果正在使用虚拟(USB-ACM)串口，则在波特率为1200的情况下使用脉冲DTR将请求引导加载程序。

#### Python (with `flash_usb`)

要使用python进入引导加载程序(使用`flash_usb`)：

```shell
>CD Klipper/scripts。
> python3 -c 'import flash_usb as u; u.enter_bootloader("<DEVICE>")'
正在进入<设备>上的引导加载程序
```

其中`<Device>`为您的串口设备，如`/dev/seral.by-id/usb-klipper[...]`或`/dev/ttyACM0`

请注意，如果失败，则不会打印任何输出，并通过打印`Enting BootLoader on<Device>`来表示成功。

#### Picocom

```shell
picocom -b 1200 <DEVICE>
<Ctrl-A><Ctrl-P>
```

其中`<Device>`为您的串口设备，如`/dev/seral.by-id/usb-klipper[...]`或`/dev/ttyACM0`

`<Ctrl-A><Ctrl-P>`表示按住`Ctrl`，按住并松开`a`，按住并松开`p`，然后松开`Ctrl`

### 物理序列

如果MCU上正在使用物理串口(即使使用USB串口适配器连接)，则发送字符串`<space><FS><space>RequestSerial BootLoader！！<space>~`。

`<space>`是ASCII文字空格，0x20。

`<FS>`是ASCII文件分隔符0x1c。

请注意，根据[MCU Protocol](Protocol.md#micro-controller-interface)，，这不是一个有效的消息，但仍然尊重同步字符(`~`)。

由于该消息必须是接收该消息的“块”中的唯一内容，如果其他工具先前正在访问该串口，则添加额外的同步字符前缀可以提高可靠性。

#### Shell

```shell
stty <BAUD> < /dev/<DEVICE>
echo $'~ \x1c请求串行引导加载器!! ~' >> /dev/<DEVICE>
```

其中`<Device>`为您的串口，如`/dev/ttyS0`或`/dev/Serial/by-id/gpio-Serial2`，以及

`<波特>`为串口的波特率，如`115200`。

### CAN 总线

如果正在使用CanBus，则会有一个特殊的[管理消息](canbus_Protocol.md#admin-Messages)请求引导加载程序。即使设备已经具有节点ID，也会考虑此消息，并且如果MCU关闭，也会处理此消息。

此方法也适用于在[CANBridge](CANBUS.md#usb-to-can-bus-bridge-mode)模式下运行的设备。

#### Katapult's flashtool.py

```shell
python3 ./katapult/scripts/flashtool.py -i <CAN_IFACE> -u <UUID> -r
```

其中`<CAN_iFace>`是要使用的CAN接口。如果使用`can0`，则可以省略`-i`和`<can_iFace>`。

`<uuid>`是您的CAN设备的uuid。

有关查找设备的CAN UUID的信息，请参阅[CAN Bus Documentation](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers)。

## 进入引导加载程序

当Klipper收到上述引导加载程序请求之一时：

如果Katapult(以前称为CANBoot)可用，Klipper将请求Katapult在下一次启动时保持活动状态，然后重置MCU(因此进入Katapult)。

如果Katapult不可用，Klipper将尝试进入特定于平台的引导加载程序，例如STM32的S DFU模式([参见备注](#stm32-dfu-warning))。

简而言之，Klipper将重新引导到Katapult(如果已安装)，然后重新引导到特定于硬件的引导程序(如果可用)。

关于各种平台上的具体BootLoader的详细信息，请参阅[BootLoader](Bootloaders.md)

## 笔记

### STM32 DFU警告

请注意，在某些主板上，如Octopus Pro v1，进入DFU模式可能会导致不必要的操作(如在DFU模式下为加热器供电)。建议在使用DFU模式时断开加热器，否则将防止不必要的操作。有关更多详细信息，请参阅您的主板文档。
