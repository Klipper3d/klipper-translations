# 测量共振频率

Klipper 内置支持 ADXL345、MPU-9250、LIS2DW 和 LIS3DH 兼容的加速度计，可用于测量打印机在不同轴上的共振频率，并自动调整[输入整形器](Resonance_Compensation.md)以补偿共振。请注意，使用加速度计需要一些焊接和压接操作。ADXL345 可以连接到树莓派或 MCU 板的 SPI 接口（需要足够快的速度）。MPU 系列可以直接连接到树莓派的 I2C 接口，或连接到支持 400kbit/s *快速模式* 的 MCU 板的 I2C 接口。LIS2DW 和 LIS3DH 可以通过 SPI 或 I2C 连接，注意事项与上述相同。

在采购加速度计时，请注意存在多种不同的 PCB 板设计和不同的克隆版本。如果要将其连接到 5V 打印机 MCU，请确保其具有稳压器和电平转换器。

对于 ADXL345，请确保该板支持 SPI 模式（少数板似乎通过将 SDO 拉低到 GND 而硬配置为 I2C）。

对于 MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500/ICM20948 和 LIS2DW/LIS3DH，也存在多种板设计和克隆版本，其 I2C 上拉电阻各不相同，可能需要额外补充。

## 支持 Klipper I2C *快速模式* 的 MCU

| MCU 系列 | 已测试的 MCU | 支持的 MCU |
|:--:|:--|:--|
| 树莓派 | 3B+, Pico | 3A, 3A+, 3B, 4 |
| AVR ATmega | ATmega328p | ATmega32u4, ATmega128, ATmega168, ATmega328, ATmega644p, ATmega1280, ATmega1284, ATmega2560 |
| AVR AT90 | - | AT90usb646, AT90usb1286 |
| SAMD | SAMC21G18 | SAMC21G18, SAMD21G18, SAMD21E18, SAMD21J18, SAMD21E15, SAMD51G19, SAMD51J19, SAMD51N19, SAMD51P20, SAME51J19, SAME51N19, SAME54P20 |

## 安装说明

### 接线

建议使用带屏蔽双绞线的以太网电缆（cat5e 或更高）以保证长距离信号完整性。如果仍然遇到信号完整性问题（SPI/I2C 错误）：

- 使用数字万用表仔细检查接线：
  - 关闭电源时检查连接是否正确（通断性）
  - 检查电源和地线电压是否正确
- 仅适用于 I2C：
  - 检查 SCL 和 SDA 线路对 3.3V 的电阻是否在 900 欧姆到 1.8K 范围内
  - 有关完整技术细节，请参阅 [I2C 总线规范和用户手册 UM10204 第 7 章](https://www.pololu.com/file/0J435/UM10204.pdf) 中的 *快速模式*
- 缩短电缆

仅将网线屏蔽层连接到 MCU 板/树莓派的地线。

***在通电前务必仔细检查接线，以防止损坏您的 MCU/树莓派或加速度计。***

### SPI 加速度计

建议的三对双绞线顺序：

```
GND+MISO
3.3V+MOSI
SCLK+CS
```

请注意，与电缆屏蔽层不同，GND 必须两端都连接。

#### ADXL345

##### 直接连接到树莓派

**注意：许多 MCU 可以与 ADXL345 在 SPI 模式下工作（例如 Pi Pico），接线和配置将根据您的特定板和可用引脚而有所不同。**

您需要通过 SPI 将 ADXL345 连接到树莓派。请注意，ADXL345 文档中建议的 I2C 连接速度太低，**将无法工作**。推荐的连接方案：

| ADXL345 引脚 | RPi 引脚 | RPi 引脚名称 |
|:--:|:--:|:--:|
| 3V3 (或 VCC) | 01 | 3.3V 直流电源 |
| GND | 06 | 地线 |
| CS | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

部分 ADXL345 板的 Fritzing 接线图：

[ADXL345-Rpi](img/adxl345-fritzing.png)

##### 使用树莓派 Pico

您可以将 ADXL345 连接到树莓派 Pico，然后通过 USB 将 Pico 连接到树莓派。这使得在其他 Klipper 设备上重用加速度计变得容易，因为您可以使用 USB 而不是 GPIO 连接。Pico 的处理能力不强，因此请确保它只运行加速度计而不执行其他任务。

为避免损坏您的 RPi，请确保仅将 ADXL345 连接到 3.3V。根据板的布局，可能存在电平转换器，这会使 5V 对您的 RPi 危险。

| ADXL345 引脚 | Pico 引脚 | Pico 引脚名称 |
|:--:|:--:|:--:|
| 3V3 (或 VCC) | 36 | 3.3V 直流电源 |
| GND | 38 | 地线 |
| CS | 2 | GP1 (SPI0_CSn) |
| SDO | 1 | GP0 (SPI0_RX) |
| SDA | 5 | GP3 (SPI0_TX) |
| SCL | 4 | GP2 (SPI0_SCK) |

部分 ADXL345 板的接线图：

[ADXL345-Pico](img/adxl345-pico.png)

### I2C 加速度计

建议的三对双绞线顺序（首选）：

```
3.3V+GND
SDA+GND
SCL+GND
```

或两对：

```
3.3V+SDA
GND+SCL
```

请注意，与电缆屏蔽层不同，任何 GND 都应两端连接。

#### MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500/ICM20948

这些加速度计已在树莓派、RP2040（Pico）和 AVR 上通过 I2C 以 400kbit/s（*快速模式*）测试工作。一些 MPU 加速度计模块包含上拉电阻，但有些为 10K 太大，必须更换或用更小的并联电阻补充。

树莓派上 I2C 的推荐连接方案：

| MPU-9250 引脚 | RPi 引脚 | RPi 引脚名称 |
|:--:|:--:|:--:|
| VCC | 01 | 3.3v 直流电源 |
| GND | 09 | 地线 |
| SDA | 03 | GPIO02 (SDA1) |
| SCL | 05 | GPIO03 (SCL1) |

树莓派在 SCL 和 SDA 上内置了 1.8K 上拉电阻。

[MPU-9250 连接到 Pi](img/mpu9250-PI-fritzing.png)

RP2040 上 I2C (i2c0a) 的推荐连接方案：

| MPU-9250 引脚 | RP2040 引脚 | RP2040 引脚名称 |
|:--:|:--:|:--:|
| VCC | 36 | 3v3 |
| GND | 38 | 地线 |
| SDA | 01 | GP0 (I2C0 SDA) |
| SCL | 02 | GP1 (I2C0 SCL) |

Pico 不包含任何内置 I2C 上拉电阻。

[MPU-9250 连接到 Pico](img/mpu9250-PICO-fritzing.png)

##### AVR ATmega328P Arduino Nano 上 I2C(TWI) 的推荐连接方案：

| MPU-9250 引脚 | Atmega328P TQFP32 引脚 | Atmega328P 引脚名称 | Arduino Nano 引脚 |
|:--:|:--:|:--:|:--:|
| VCC | 39 | - | - |
| GND | 38 | 地线 | GND |
| SDA | 27 | SDA | A4 |
| SCL | 28 | SCL | A5 |

Arduino Nano 不包含任何内置上拉电阻，也没有 3.3V 电源引脚。

### 安装加速度计

加速度计必须安装在工具头上。您需要为自己 3D 打印机设计合适的安装支架。最好将加速度计的轴与打印机的轴对齐（但如果更方便，轴可以互换——即无需将 X 轴与 X 轴对齐等——即使加速度计的 Z 轴是打印机的 X 轴等，也可以正常工作）。

在 SmartEffector 上安装 ADXL345 的示例：

[ADXL345 on SmartEffector](img/adxl345-mount.jpg)

请注意，在床摆式打印机上，您必须设计两个支架：一个用于工具头，一个用于床，并运行两次测量。有关更多详细信息，请参见相应[部分](#bed-slinger-printers)。

**注意：** 请确保加速度计及其固定螺丝不接触打印机的任何金属部件。基本上，支架的设计必须确保加速度计与打印机框架之间的电气隔离。如果不确保这一点，可能会在系统中产生接地回路，从而损坏电子设备。

### 软件安装

请注意，共振测量和整形器自动校准需要额外的软件依赖项，默认情况下未安装。首先，在您的树莓派上运行以下命令：
```
sudo apt update
sudo apt install python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev
```

接下来，为了在 Klipper 环境中安装 NumPy，请运行命令：
```
~/klippy-env/bin/pip install -v "numpy<1.26"
```
请注意，根据 CPU 性能，这可能需要*大量*时间，最多可达 10-20 分钟。请耐心等待安装完成。在某些情况下，如果板载 RAM 太少，安装可能会失败，您需要启用交换空间。另外请注意强制版本，因为较新版本的 NumPy 可能有某些 Klipper Python 环境无法满足的要求。

安装完成后，请检查以下命令是否没有错误：
```
~/klippy-env/bin/python -c 'import numpy;'
```
正确的输出应该只是一行空白。

#### 配置带 RPi 的 ADXL345

首先，检查并遵循[RPi 微控制器文档](RPi_microcontroller.md)中的说明，在树莓派上设置“linux mcu”。这将配置在您的 Pi 上运行的第二个 Klipper 实例。

通过运行 `sudo raspi-config` 并在“接口选项”菜单中启用 SPI，确保启用了 Linux SPI 驱动程序。

将以下内容添加到 printer.cfg 文件中：

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # 一个示例
```
建议从 1 个探测点开始，位于打印床中间，略高于床面。

#### 配置带 Pi Pico 的 ADXL345

##### 刷写 Pico 固件

在您的树莓派上，为 Pico 编译固件。

```
cd ~/klipper
make clean
make menuconfig
```
[Pico menuconfig](img/klipper_pico_menuconfig.png)

现在，按住 Pico 上的 `BOOTSEL` 按钮，通过 USB 将 Pico 连接到树莓派。编译并刷写固件。
```
make flash FLASH_DEVICE=first
```

如果失败，您将被告知要使用哪个 `FLASH_DEVICE`。在此示例中，即 ```make flash FLASH_DEVICE=2e8a:0003```。
[确定刷写设备](img/flash_rp2040_FLASH_DEVICE.png)

##### 配置连接

Pico 现在将使用新固件重新启动，并应显示为串行设备。使用 `ls /dev/serial/by-id/*` 找到 pico 串行设备。现在您可以添加一个包含以下设置的 `adxl.cfg` 文件：

```
[mcu adxl]
# 将 <mySerial> 更改为上面找到的任何内容。例如，
# usb-Klipper_rp2040_E661640843545B2E-if00
serial: /dev/serial/by-id/usb-Klipper_rp2040_<mySerial>

[adxl345]
cs_pin: adxl:gpio1
spi_bus: spi0a
axes_map: x,z,y

[resonance_tester]
accel_chip: adxl345
probe_points:
    # 打印床中间略上方的某个位置
    147,154, 20

[output_pin power_mode] # 提高电源稳定性
pin: adxl:gpio23
```

如果如上所示在单独的文件中设置 ADXL345 配置，您还需要修改 `printer.cfg` 文件以包含此内容：

```
[include adxl.cfg] # 断开加速度计时注释掉此行
```

通过 `RESTART` 命令重启 Klipper。

#### 通过 SPI 配置 LIS2DW 系列

```
[mcu lis]
# 将 <mySerial> 更改为上面找到的任何内容。例如，
# usb-Klipper_rp2040_E661640843545B2E-if00
serial: /dev/serial/by-id/usb-Klipper_rp2040_<mySerial>

[lis2dw]
cs_pin: lis:gpio1
spi_bus: spi0a
axes_map: x,z,y

[resonance_tester]
accel_chip: lis2dw
probe_points:
    # 打印床中间略上方的某个位置
    147,154, 20
```

#### 使用 RPi 配置 MPU-6000/9000 系列

确保启用 Linux I2C 驱动程序并将波特率设置为 400000（有关更多详细信息，请参见 [启用 I2C](RPi_microcontroller.md#optional-enabling-i2c) 部分）。然后，将以下内容添加到 printer.cfg：

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[mpu9250]
i2c_mcu: rpi
i2c_bus: i2c.1

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # 一个示例
```
如果您使用的是 ICM20948，请将 "mpu9250" 实例替换为 "icm20948"。

#### 使用 Pico 配置 MPU-9520 兼容设备

Pico I2C 默认设置为 400000。只需将以下内容添加到 printer.cfg：

```
[mcu pico]
serial: /dev/serial/by-id/<your Pico's serial ID>

[mpu9250]
i2c_mcu: pico
i2c_bus: i2c0a

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # 一个示例

[static_digital_output pico_3V3pwm] # 提高电源稳定性
pins: pico:gpio23
```
如果您使用的是 ICM20948，请将 "mpu9250" 实例替换为 "icm20948"。

#### 使用 AVR 配置 MPU-9520 兼容设备

AVR I2C 将由 mpu9250 选项设置为 400000。只需将以下内容添加到 printer.cfg：

```
[mcu nano]
serial: /dev/serial/by-id/<your nano's serial ID>

[mpu9250]
i2c_mcu: nano

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # 一个示例
```
如果您使用的是 ICM20948，请将 "mpu9250" 实例替换为 "icm20948"。

通过 `RESTART` 命令重启 Klipper。

## 测量共振

### 检查设置

现在您可以测试连接。

- 对于“非床摆式”（例如一个加速度计），在 Octoprint 中输入 `ACCELEROMETER_QUERY`
- 对于“床摆式”（例如多个加速度计），输入 `ACCELEROMETER_QUERY CHIP=<chip>`，其中 `<chip>` 是输入的芯片名称，例如 `CHIP=bed`（参见：[床摆式](#bed-slinger-printers)）以查询所有已安装的加速度计芯片。

您应该看到加速度计的当前测量值，包括自由落体加速度，例如
```
Recv: // adxl345 values (x, y, z): 470.719200, 941.438400, 9728.196800
```

如果您收到类似 `Invalid adxl345 id (got xx vs e5)` 的错误，其中 `xx` 是其他 ID，请立即重试。这是 SPI 初始化的问题。如果仍然收到错误，表明 ADXL345 连接有问题或传感器故障。请仔细检查电源、接线（是否与示意图匹配，是否有导线断裂或松动等）以及焊接质量。

**如果您使用的是 MPU-9250 兼容加速度计并且显示为 `mpu-unknown`，请谨慎使用！它们可能是翻新芯片！**

接下来，在 Octoprint 中尝试运行 `MEASURE_AXES_NOISE`，您应该得到加速度计各轴噪声的基线数值（应在 ~1-100 范围内）。轴噪声过高（例如 1000 及以上）可能表明传感器问题、电源问题或 3D 打印机上风扇不平衡且噪音过大。

### 测量共振

现在您可以进行一些实际测试。运行以下命令：
```
TEST_RESONANCES AXIS=X
```
请注意，这将在 X 轴上产生振动。它还会禁用之前启用的输入整形器，因为在启用输入整形器的情况下运行共振测试是无效的。

**注意！** 首次运行时务必观察打印机，以确保振动不会过于剧烈（可以使用 `M112` 命令在紧急情况下中止测试；希望不会出现这种情况）。如果振动确实变得太强，您可以尝试在 `[resonance_tester]` 部分指定低于默认值的 `accel_per_hz` 参数，例如
```
[resonance_tester]
accel_chip: adxl345
accel_per_hz: 50  # 默认为 75
probe_points: ...
```

如果 X 轴工作正常，也运行 Y 轴：
```
TEST_RESONANCES AXIS=Y
```
这将生成 2 个 CSV 文件（`/tmp/resonances_x_*.csv` 和 `/tmp/resonances_y_*.csv`）。这些文件可以在树莓派上使用独立脚本处理。该脚本旨在为每个测量轴运行单个 CSV 文件，尽管如果您希望平均结果，也可以使用多个 CSV 文件。平均结果可能很有用，例如，如果在多个测试点进行了共振测试。如果您不希望平均结果，请删除多余的 CSV 文件。
```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```
该脚本将生成包含频率响应的图表 `/tmp/shaper_calibrate_x.png` 和 `/tmp/shaper_calibrate_y.png`。您还将获得每个输入整形器的建议频率，以及为您的设置推荐的输入整形器。例如：

[Resonances](img/calibrate-y.png)
```
Fitted shaper 'zv' frequency = 34.4 Hz (vibrations = 4.0%, smoothing ~= 0.132)
To avoid too much smoothing with 'zv', suggested max_accel <= 4500 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 0.0%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 41.4 Hz (vibrations = 0.0%, smoothing ~= 0.188)
To avoid too much smoothing with 'ei', suggested max_accel <= 3200 mm/sec^2
Fitted shaper '2hump_ei' frequency = 51.8 Hz (vibrations = 0.0%, smoothing ~= 0.201)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 61.8 Hz (vibrations = 0.0%, smoothing ~= 0.215)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2800 mm/sec^2
Recommended shaper is mzv @ 34.6 Hz
```

建议的配置可以添加到 `printer.cfg` 的 `[input_shaper]` 部分，例如：
```
[input_shaper]
shaper_freq_x: ...
shaper_type_x: ...
shaper_freq_y: 34.6
shaper_type_y: mzv

[printer]
max_accel: 3000  # 不应超过 X 和 Y 轴的估计 max_accel
```
或者您可以根据生成的图表自己选择其他配置：图表上的功率谱密度峰值对应于打印机的共振频率。

请注意，您也可以直接从 Klipper [运行](#input-shaper-auto-calibration) 输入整形器自动校准，这可能很方便，例如用于输入整形器[重新校准](#input-shaper-re-calibration)。

### 床摆式打印机

如果您的打印机是床摆式打印机，您需要在测量 X 和 Y 轴共振时改变加速度计的位置：将加速度计安装在工具头上测量 X 轴共振，安装在床面上测量 Y 轴共振（典型的床摆式打印机设置）。

但是，您也可以同时连接两个加速度计，尽管 ADXL345 必须连接到不同的板（例如，连接到 RPi 和打印机 MCU 板），或连接到同一板上的两个不同物理 SPI 接口（很少可用）。然后可以按以下方式配置：

```
[adxl345 hotend]
# 假设 `hotend` 芯片连接到 RPi
cs_pin: rpi:None

[adxl345 bed]
# 假设 `bed` 芯片连接到打印机 MCU 板
cs_pin: ...  # 打印机板 SPI 片选 (CS) 引脚

[resonance_tester]
# 假设床摆式打印机的典型设置
accel_chip_x: adxl345 hotend
accel_chip_y: adxl345 bed
probe_points: ...
```

两个 MPUs 可以共享一个 I2C 总线，但它们**不能**同时测量，因为 400kbit/s I2C 总线不够快。一个必须将其 AD0 引脚拉低到 0V（地址 104），另一个必须将其 AD0 引脚拉高到 3.3V（地址 105）：

```
[mpu9250 hotend]
i2c_mcu: rpi
i2c_bus: i2c.1
i2c_address: 104 # 此 MPU 的 AD0 引脚被拉低

[mpu9250 bed]
i2c_mcu: rpi
i2c_bus: i2c.1
i2c_address: 105 # 此 MPU 的 AD0 引脚被拉高

[resonance_tester]
# 假设床摆式打印机的典型设置
accel_chip_x: mpu9250 hotend
accel_chip_y: mpu9250 bed
probe_points: ...
```
[在将两个 MPU 连接到总线之前，先分别测试每个 MPU 以便于调试。]

然后命令 `TEST_RESONANCES AXIS=X` 和 `TEST_RESONANCES AXIS=Y` 将为每个轴使用正确的加速度计。

### 最大平滑度

请记住，输入整形器可能会在零件中产生一些平滑效果。由 `calibrate_shaper.py` 脚本或 `SHAPER_CALIBRATE` 命令执行的输入整形器自动调试图不加剧平滑效果，但同时试图最小化剩余振动。有时它们可能会为整形器频率做出次优选择，或者您可能只是希望在零件中减少平滑度，以换取更大的剩余振动。在这种情况下，您可以请求限制输入整形器的最大平滑度。

让我们考虑以下自动调优结果：

[Resonances](img/calibrate-x.png)
```
Fitted shaper 'zv' frequency = 57.8 Hz (vibrations = 20.3%, smoothing ~= 0.053)
To avoid too much smoothing with 'zv', suggested max_accel <= 13000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.8 Hz (vibrations = 3.6%, smoothing ~= 0.168)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3600 mm/sec^2
Fitted shaper 'ei' frequency = 48.8 Hz (vibrations = 4.9%, smoothing ~= 0.135)
To avoid too much smoothing with 'ei', suggested max_accel <= 4400 mm/sec^2
Fitted shaper '2hump_ei' frequency = 45.2 Hz (vibrations = 0.1%, smoothing ~= 0.264)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2200 mm/sec^2
Fitted shaper '3hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.356)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 1500 mm/sec^2
Recommended shaper is 2hump_ei @ 45.2 Hz
```
请注意，报告的 `smoothing` 值是一些抽象的预测值。这些值可用于比较不同配置：值越高，整形器产生的平滑度越大。然而，这些平滑度分数并不代表任何真实的平滑度衡量标准，因为实际平滑度取决于 [`max_accel`](#selecting-max-accel) 和 `square_corner_velocity` 参数。因此，您应该打印一些测试件，以查看所选配置究竟会产生多少平滑度。

在上面的示例中，建议的整形器参数还不错，但如果您希望在 X 轴上获得更少的平滑度怎么办？您可以尝试使用以下命令限制最大整形器平滑度：
```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```
这将平滑度限制在 0.2 分数。现在您可能会得到以下结果：

[Resonances](img/calibrate-x-max-smoothing.png)
```
Fitted shaper 'zv' frequency = 55.4 Hz (vibrations = 19.7%, smoothing ~= 0.057)
To avoid too much smoothing with 'zv', suggested max_accel <= 12000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 3.6%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 48.2 Hz (vibrations = 4.8%, smoothing ~= 0.139)
To avoid too much smoothing with 'ei', suggested max_accel <= 4300 mm/sec^2
Fitted shaper '2hump_ei' frequency = 52.0 Hz (vibrations = 2.7%, smoothing ~= 0.200)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 72.6 Hz (vibrations = 1.4%, smoothing ~= 0.155)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 3900 mm/sec^2
Recommended shaper is 3hump_ei @ 72.6 Hz
```

如果您与之前建议的参数进行比较，振动会稍大一些，但平滑度明显小于之前，允许更大的最大加速度。

在决定选择哪个 `max_smoothing` 参数时，您可以使用试错法。尝试几个不同的值，看看得到什么结果。请注意，输入整形器产生的实际平滑度主要取决于打印机的最低共振频率：最低共振频率越高，平滑度越小。因此，如果您要求脚本找到输入整形器的不切实际小平滑度配置，将以最低共振频率处的振铃增加为代价（这通常在打印件中也更明显）。因此，请始终仔细检查脚本报告的预期剩余振动，并确保它们不会太高。

请注意，如果您为两个轴都选择了合适的 `max_smoothing` 值，可以将其存储在 `printer.cfg` 中
```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # 一个示例
```
然后，如果您将来使用 Klipper 命令 `SHAPER_CALIBRATE` [重新运行](#input-shaper-re-calibration) 输入整形器自动调优，它将使用存储的 `max_smoothing` 值作为参考。

### 选择 max_accel

由于输入整形器可能会在零件中产生一些平滑效果，尤其是在高加速度下，您仍需要选择一个不会在打印零件中产生过多平滑的 `max_accel` 值。校准脚本提供了 `max_accel` 参数的估计值，该值不应产生过多平滑。请注意，校准脚本显示的 `max_accel` 只是理论上整形器仍能工作而不产生过多平滑的最大值。这绝不是建议将此加速度用于打印。您的打印机能够承受的最大加速度取决于其机械特性和所用步进电机的最大扭矩。因此，建议在 `[printer]` 部分设置 `max_accel`，该值不超过 X 和 Y 轴的估计值，可能还需要一些保守的安全裕度。

或者，遵循输入整形器调优指南的[此部分](Resonance_Compensation.md#selecting-max_accel)并打印测试模型以实验性地选择 `max_accel` 参数。

同样的注意事项适用于使用 `SHAPER_CALIBRATE` 命令的输入整形器[自动校准](#input-shaper-auto-calibration)：在自动校准后仍需要选择正确的 `max_accel` 值，建议的加速度限制不会自动应用。

请记住，没有过多平滑的最大加速度取决于 `square_corner_velocity`。一般建议不要从默认值 5.0 更改它，这也是 `calibrate_shaper.py` 脚本默认使用的值。如果您确实更改了它，您应该通过传递 `--square_corner_velocity=...` 参数通知脚本，例如
```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --square_corner_velocity=10.0
```
以便它可以正确计算最大加速度建议。请注意，`SHAPER_CALIBRATE` 命令已经考虑了配置的 `square_corner_velocity` 参数，无需显式指定。

如果您正在进行整形器重新校准，并且建议的整形器配置报告的平滑度与上次校准时几乎相同，则可以跳过此步骤。

### 共振频率的不可靠测量

有时，共振测量可能会产生虚假结果，导致对输入整形器的错误建议。这可能是由多种原因引起的，包括在工具头上运行风扇、加速度计位置不正确或安装不牢固、或机械问题如皮带松动或轴卡滞等。请记住，所有风扇在共振测试期间都应关闭，特别是噪音大的风扇，并且加速度计应牢固地安装在相应的移动部件上（例如，在床摆式打印机上安装在床本身上，或安装在打印机本身的挤出机上而不是滑车上，有些人将加速度计安装在喷嘴上会得到更好的结果）。至于机械问题，用户应检查移动轴是否存在任何可修复的故障（例如，线性导轨清洁和润滑，V 槽轮张力正确调整）。如果以上方法都无效，用户可以尝试从生成列表中选择其他整形器，而不是默认推荐的那个。

### 测试自定义轴

`TEST_RESONANCES` 命令支持自定义轴。虽然这对于输入整形器校准不太有用，但它可用于深入研究打印机共振，并检查例如皮带张力。

要检查 CoreXY 打印机的皮带张力，请执行
```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```
并使用 `graph_accelerometer.py` 处理生成的文件，例如
```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```
这将生成 `/tmp/resonances.png` 比较共振。

对于默认塔架位置的 Delta 打印机（塔 A ~= 210 度，B ~= 330 度，C ~= 90 度），执行
```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```
然后使用相同的命令
```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```
生成 `/tmp/resonances.png` 比较共振。

## 输入整形器自动校准

除了手动选择输入整形器功能的适当参数外，还可以直接从 Klipper 运行输入整形器的自动调优。通过 Octoprint 终端运行以下命令：
```
SHAPER_CALIBRATE
```

这将为两个轴运行完整测试，并为频率响应和建议的输入整形器生成 csv 输出（默认为 `/tmp/calibration_data_*.csv`）。您还将在 Octoprint 控制台上获得每个输入整形器的建议频率，以及为您的设置推荐的输入整形器。例如：

```
Calculating the best input shaper parameters for y axis
Fitted shaper 'zv' frequency = 39.0 Hz (vibrations = 13.2%, smoothing ~= 0.105)
To avoid too much smoothing with 'zv', suggested max_accel <= 5900 mm/sec^2
Fitted shaper 'mzv' frequency = 36.8 Hz (vibrations = 1.7%, smoothing ~= 0.150)
To avoid too much smoothing with 'mzv', suggested max_accel <= 4000 mm/sec^2
Fitted shaper 'ei' frequency = 36.6 Hz (vibrations = 2.2%, smoothing ~= 0.240)
To avoid too much smoothing with 'ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '2hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.234)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '3hump_ei' frequency = 59.0 Hz (vibrations = 0.0%, smoothing ~= 0.235)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2500 mm/sec^2
Recommended shaper_type_y = mzv, shaper_freq_y = 36.8 Hz
```
如果您同意建议的参数，现在可以执行 `SAVE_CONFIG` 保存它们并重启 Klipper。请注意，这不会更新 `[printer]` 部分的 `max_accel` 值。您应手动更新它，遵循 [选择 max_accel](#selecting-max_accel) 部分的考虑。

如果您的打印机是床摆式打印机，您可以指定要测试的轴，以便在测试之间更改加速度计安装点（默认情况下对两个轴都进行测试）：
```
SHAPER_CALIBRATE AXIS=Y
```

您可以在校准每个轴后两次执行 `SAVE_CONFIG`。

但是，如果您同时连接了两个加速度计，只需运行 `SHAPER_CALIBRATE` 而不指定轴，即可一次性校准两个轴的输入整形器。

### 输入整形器重新校准

`SHAPER_CALIBRATE` 命令也可用于将来重新校准输入整形器，特别是如果对可能影响其运动学的打印机进行了更改。您可以使用 `SHAPER_CALIBRATE` 命令重新运行完整校准，或通过提供 `AXIS=` 参数将自动校准限制在单个轴上，例如
```
SHAPER_CALIBRATE AXIS=X
```

**警告！** 不建议非常频繁地运行整形器自动校准（例如在每次打印前或每天）。为了确定共振频率，自动校准会在每个轴上产生强烈的振动。通常，3D 打印机并非设计用于长时间暴露在接近共振频率的振动中。这样做可能会增加打印机部件的磨损并缩短其使用寿命。还有部分零件松动或脱落的风险增加。每次自动调优后，请始终检查打印机的所有部件（包括通常不移动的部件）是否牢固固定。

此外，由于测量中存在一些噪声，调优结果在一次校准运行和另一次之间可能会略有不同。尽管如此，预计噪声不会对打印质量产生太大影响。然而，仍建议仔细检查建议的参数，并在使用它们之前打印一些测试件以确认它们是好的。

## 加速度计数据的离线处理

可以生成原始加速度计数据并在离线（例如在主机上）处理，例如查找共振。为此，请通过 Octoprint 终端运行以下命令：
```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```
忽略 `SET_INPUT_SHAPER` 命令的任何错误。对于 `TEST_RESONANCES` 命令，请指定所需的测试轴。原始数据将写入 RPi 上的 `/tmp` 目录。

还可以通过在一些正常打印机活动期间两次运行 `ACCELEROMETER_MEASURE` 命令来获取原始数据——第一次启动测量，第二次停止测量并写入输出文件。有关更多详细信息，请参阅 [G-Codes](G-Codes.md#adxl345)。

数据可以稍后由以下脚本处理：`scripts/graph_accelerometer.py` 和 `scripts/calibrate_shaper.py`。它们都接受一个或多个原始 csv 文件作为输入，具体取决于模式。graph_accelerometer.py 脚本支持多种操作模式：

* 绘制原始加速度计数据（使用 `-r` 参数），仅支持 1 个输入；
* 绘制频率响应（无需额外参数），如果指定了多个输入，则计算平均频率响应；
* 比较多个输入之间的频率响应（使用 `-c` 参数）；您还可以通过 `-a x`、`-a y` 或 `-a z` 参数指定要考虑的加速度计轴（如果未指定，则使用所有轴的振动总和）；
* 绘制频谱图（使用 `-s` 参数），仅支持 1 个输入；您还可以通过 `-a x`、`-a y` 或 `-a z` 参数指定要考虑的加速度计轴（如果未指定，则使用所有轴的振动总和）。

请注意，graph_accelerometer.py 脚本仅支持 raw_data\*.csv 文件，不支持 resonances\*.csv 或 calibration_data\*.csv 文件。

例如，
```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```
将绘制多个 `/tmp/raw_data_x_*.csv` 文件在 Z 轴上的比较图到 `/tmp/resonances_x.png` 文件。

shaper_calibrate.py 脚本接受 1 个或多个输入，可以运行输入整形器的自动调优并建议适用于所有提供输入的最佳参数。它将建议的参数打印到控制台，如果提供 `-o output.png` 参数，还可以生成图表，或如果指定 `-c output.csv` 参数，生成 CSV 文件。

为 shaper_calibrate.py 脚本提供多个输入可能在运行输入整形器的高级调优时很有用，例如：

* 在床摆式打印机上，第一次将加速度计安装在工具头上，第二次安装在床面上，运行 `TEST_RESONANCES AXIS=X OUTPUT=raw_data`（和 `Y` 轴），以检测轴交叉共振并尝试用输入整形器消除它们。
* 在床摆式打印机上，使用玻璃床和磁性表面（较轻）两次运行 `TEST_RESONANCES AXIS=Y OUTPUT=raw_data`，以找到适用于任何打印表面配置的输入整形器参数。
* 组合来自多个测试点的共振数据。
* 组合来自 2 个轴的共振数据（例如，在床摆式打印机上，从 X 和 Y 轴共振配置 X 轴 input_shaper，以在喷嘴在 X 轴方向移动时“抓住”打印件时消除*床*的振动）。