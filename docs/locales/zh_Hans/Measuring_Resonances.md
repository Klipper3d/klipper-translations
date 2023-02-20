# 共振值测量

Klipper内建有ADXL345加速度传感器驱动，可用以测量打印机不同运动轴发生共振的频率，从而自动进行 [输入整形](Resonance_Compensation.md) 以实现共振补偿。注意使用ADXL345需要进行焊接和压线。ADXL345可以直接连接到树莓派，也可以连接到MCU的SPI总线（注意MCU有一定的性能需求）。

When sourcing ADXL345, be aware that there is a variety of different PCB board designs and different clones of them. Make sure that the board supports SPI mode (small number of boards appear to be hard-configured for I2C by pulling SDO to GND), and, if it is going to be connected to a 5V printer MCU, that it has a voltage regulator and a level shifter.

## 安装指南

### 接线

An ethernet cable with shielded twisted pairs (cat5e or better) is recommended for signal integrety over a long distance. If you still experience signal integrity issues (SPI/I2C errors), shorten the cable.

Connect ethernet cable shielding to the controller board/RPI ground.

***Double-check your wiring before powering up to prevent damaging your MCU/Raspberry Pi or the accelerometer.***

#### SPI Accelerometers

Suggested twisted pair order:

```
GND+MISO
3.3V+MOSI
SCLK+CS
```

##### ADXL345

**Note: Many MCUs will work with an ADXL345 in SPI mode(eg Pi Pico), wiring and configuration will vary according to your specific board and avaliable pins.**

我们需要将ADXL345连接到树莓派的SPI接口。注意，尽管ADXL345文档推荐使用I2C，但其数据吞吐能力不足，**不能**实现共振测量的要求。推荐的接线图为：

| ADXL345引脚 | 树莓派引脚 | 树莓派引脚名称 |
| :-: | :-: | :-: |
| 3V3 或 VCC | 01 | 3.3v 直流（DC）电源 |
| GND | 06 | 地（GND） |
| CS（芯片选定） | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

部分ADXL345开发板的Fritzing接线图如下：

![ADXL345-树莓派](img/adxl345-fritzing.png)

#### I2C Accelerometers

Suggested twisted pair order:

```
3.3V+SDA
GND+SCL
```

##### MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500

Alternatives to the ADXL345 are MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500. These accelerometers have been tested to work over I2C on the RPi or RP2040(pico) at 400kbaud.

Recommended connection scheme for I2C on the Raspberry Pi:

| MPU-9250 pin | 树莓派引脚 | 树莓派引脚名称 |
| :-: | :-: | :-: |
| VCC | 01 | 3.3v 直流（DC）电源 |
| GND | 09 | 地（GND） |
| SDA | 03 | GPIO02 (SDA1) |
| SCL | 05 | GPIO03 (SCL1) |

![MPU-9250 connected to RPI](img/mpu9250-PI-fritzing.png)

Recommended connection scheme for I2C(i2c0a) on the RP2040:

| MPU-9250 pin | RP2040 pin | 树莓派引脚名称 |
| :-: | :-: | :-: |
| VCC | 39 | 3v3 |
| GND | 38 | 地（GND） |
| SDA | 01 | GP0 (I2C0 SDA) |
| SCL | 02 | GP1 (I2C0 SCL) |

![MPU-9250 connected to PICO](img/mpu9250-PICO-fritzing.png)

### 固定加速度传感器

加速度传感器应固定在打印头上。应根据打印机的情况设计合适的固定件。推荐将加速度的测量轴与打印机运行轴的方向进行对齐。然而，如果轴对齐极其麻烦，可以将打印机的轴使用其他测量轴对齐，比如打印机+X对应传感器-X，甚至打印机+X对应传感器-Z等。

下面是ADXL345固定到SmartEffector的示例：

![ADXL345固定在SmartEffector](img/adxl345-mount.jpg)

注意，滑床式打印机需要设计两个固定件：一个安装于打印头，另一个用于热床，并进行两次测量。详见 [对应分节](#bed-slinger-printers)。

**注意！**：务必确保加速度传感器和任何螺丝都不应该接触到打印机的金属部分。紧固件必须设计成在加速度传感器和打印机框体间形成电气绝缘。错误的设计可能会形成短路，从而损坏电气元件。

### 软件设置

Note that resonance measurements and shaper auto-calibration require additional software dependencies not installed by default. First, run on your Raspberry Pi the following commands:

```
sudo apt update
sudo apt install python3-numpy python3-matplotlib libatlas-base-dev
```

Next, in order to install NumPy in the Klipper environment, run the command:

```
~/klippy-env/bin/pip install -v numpy
```

Note that, depending on the performance of the CPU, it may take *a lot* of time, up to 10-20 minutes. Be patient and wait for the completion of the installation. On some occasions, if the board has too little RAM the installation may fail and you will need to enable swap.

之后，参考[树莓派作为微控制器文档](RPi_microcontroller.md)的指引完成“LINUX微处理器”的设置。

#### Configure ADXL345 With RPi

通过运行`sudo raspi-config` 后的 "Interfacing options"菜单中启用 SPI 以确保Linux SPI 驱动已启用。

在printer.cfg中添加以下内容：

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # an example
```

建议在测试开始前，用探针在热床中央进行一次探测，触发后稍微上移。

#### Configure MPU-6000/9000 series With RPi

Make sure the Linux I2C driver is enabled and the baud rate is set to 400000 (see [Enabling I2C](RPi_microcontroller.md#optional-enabling-i2c) section for more details). Then, add the following to the printer.cfg:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[mpu9250]
i2c_mcu: rpi
i2c_bus: i2c.1

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # an example
```

#### Configure MPU-6000/9000 series With PICO

PICO I2C is set to 400000 on default. Simply add the following to the printer.cfg:

```
[mcu pico]
serial: /dev/serial/by-id/<your PICO's serial ID>

[mpu9250]
i2c_mcu: pico
i2c_bus: i2c1a

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # an example

[static_digital_output pico_3V3pwm] # Improve power stability
pin: pico:gpio23
```

通过`RESTART`命令重启Klipper。

## 测量共振值

### 检查设置

首先测试加速度传感器的连接。

- 对于只有一个加速度传感器的情况，在Octoprint，输入`ACCELEROMETER_QUERY`（检查已连接的加速度传感器状态）
- 对于“滑动床”（即有多个加速度传感器），输入`ACCELEROMETER_QUERY CHIP=<chip>`，其中`<chip>`是设置文档中的加速度传感器命名，例如 `CHIP=bed`(参见：[bed-slinger](#bed-slinger-printers))。

你应该会看到来自加速度计的当前测量值，包括自由落体（free-fall）的加速度，比如说。

```
Recv: // adxl345 values (x, y, z): 470.719200, 941.438400, 9728.196800
```

如果输出类似 `Invalid adxl345 id (got xx vs e5)`，其中'xx'为e5以外ID，这表示出现连接问题（如，连接错误、线缆电阻过大、干扰等），或传感器错误（如，残次传感器 或 错误的传感器）。请在此检查电源，接线（再三确定接线正确，没有破损、松动的电线）或焊接问题。

**If you are using MPU-6000/9000 series accelerometer and it show up as `mpu-unknown`, use with caution! They are probably refurbished chips!**

下一步，在Octoprint中输入 `MEASURE_AXES_NOISE`，之后将会显示各个轴的基准测量噪声（其值应在1-100之间）。如果轴的噪声极高（例如 1000 或更高）可能意味着3D打印机上存在传感器问题、电源问题或不平衡的风扇。

### 测量共振值

现在可以运行进行实测。运行以下命令:

```
TEST_RESONANCES AXIS=X
```

注意，这将在X轴上产生振动。如果之前启用了输入整形（input shaping ），它也将禁用输入整形，因为在启用输入整形的情况下运行共振测试是无效的。

**注意！**请确保第一次运行时时刻观察打印机，以确保振动不会太剧烈（`M112`命令可以在紧急情况下中止测试；但愿不会到这一步）。如果振动确实太强烈，你可以尝试在`[Resonance_tester]`分段中为`accel_per_hz`参数指定一个低于默认值的值，比如说。

```
[resonance_tester]
accel_chip: adxl345
accel_per_hz: 50  # default is 75
probe_points: ...
```

如果它适用于 X 轴，则也可以为 Y 轴运行：

```
TEST_RESONANCES AXIS=Y
```

This will generate 2 CSV files (`/tmp/resonances_x_*.csv` and `/tmp/resonances_y_*.csv`). These files can be processed with the stand-alone script on a Raspberry Pi. To do that, run the following commands:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

此脚本将生成频率响应的图表 `/tmp/shaper_calibrate_x.png` 和 `/tmp/shaper_calibrate_y.png`。它还会给出每个输入整形器的建议频率，以及推荐的输入整形器。例如：

![共振](img/calibrate-y.png)

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

推荐的配置可以添加到`[input_shaper]`的`printer.cfg`分段中，例如：

```
[input_shaper]
shaper_freq_x: ...
shaper_type_x: ...
shaper_freq_y: 34.6
shaper_type_y: mzv

[printer]
max_accel: 3000  # should not exceed the estimated max_accel for X and Y axes
```

也可以根据生成的图表自己选择一些其他配置：图表上的功率谱密度的峰值对应于打印机的共振频率。

请注意，可以[直接](#input-shaper-auto-calibration)在Klipper中运行输入整形器自动校准，这可能更方便，例如，对于输入整形器[重新校准](#input-shaper-re-calibration)。

### 平行于喷嘴移动打印床的打印机

如果打印机的打印床可以平行于喷嘴移动，测量X和Y轴时需要改变加速度计的安装位置。安装加速度计到打印头以测量X轴共振，安装到打印床以测量Y轴（该类打印机的常见配置）。

也可以同时连接两个加速度计，尽管它们必须连接到不同的主板（例如，连接到树莓派和MCU），或者连接到同一板上两个不同的物理SPI接口（大多数情况下不可用）。然后可以按以下方式配置它们：

```
[adxl345 hotend]
# Assuming `hotend` chip is connected to an RPi
cs_pin: rpi:None

[adxl345 bed]
# Assuming `bed` chip is connected to a printer MCU board
cs_pin: ...  # Printer board SPI chip select (CS) pin

[resonance_tester]
# Assuming the typical setup of the bed slinger printer
accel_chip_x: adxl345 hotend
accel_chip_y: adxl345 bed
probe_points: ...
```

然后，命令`TEST_RESONANCES AXIS=X`和`TEST_RESONANCES AXIS=Y`会使用每个轴相应的加速度计。

### 最大平滑度

请注意，输入整形器会在使一些打印的路径被平滑。由执行`calibrate_shaper.py`脚本或`SHAPER_CALIBRATE`命令自动得出的输入整形器会尽量不加剧平滑的同时试图最小化产生的振动。脚本可能会得出不是最优的整形器的频率，或者你可能希望以更强的剩余振动为代价来减少平滑度。在这些情况下，可以要求脚本限制输入整形器的最大平滑度。

参考以下自动调谐结果：

![共振](img/calibrate-x.png)

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

请注意，报告的 `smoothing `（平滑）值是抽象的预测值。这些值可用于比较不同的配置：值越高，整形器造成的平滑度就越高。但是，这些平滑值并不表示任何实际的平滑度的量，因为实际的平滑取决于[`max_accel`](#selecting-max-accel)和`square_corner_velocity`参数。因此，如果希望了解所选配置造成的实际平滑效果，需要打印一些测试件。

在上面的示例中，脚本给出了不错的整形器参数建议，但是如果想在 X 轴上减少平滑度，就需要尝试使用以下命令限制脚本挑选参数时的整形器平滑值极限：

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```

这将平滑值限制在0.2。现在可以得到以下结果：

![共振](img/calibrate-x-max-smoothing.png)

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

新的参数与之前的建议比，振动要大一些，但平滑度明显比之前小，允许打印时更高的极限加速度。

在选择 `max_smoothing` 参数时，可以使用试错的方法。试试几个不同的值并对比得到的结果。请注意，输入整形器产生的实际平滑效果主要取决于打印机的最低谐振频率：最低谐振的频率越高，平滑效果越小。因此，如果要求脚本找到一个具有不切实际小平滑度的输入整形器配置，它将以增加最低共振频率的振纹为代价（通常，这在打印件中比平滑产生的影响更明显）。因此，一定要仔细检查脚本所报告的预计剩余振动，确保它们不会太高。

注意，如果为两个轴选择了一个相同的 `max_smoothing` 值，可以把它存储在 `printer.cfg` 为

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # an example
```

如果在将来使用`SHAPER_CALIBRATE` Klipper命令[重新运行](#input-shaper-re-calibration)输入整形器自动调谐，它将使用存储的`max_smoothing` 值作为参考。

### 选择 max_accel

由于输入整形器会在打印件中产生一些平滑，特别是在高加速时，选择一个不会产生过多平滑的`max_accel` 依然很重要校准脚本为`max_accel` 参数提供了一个不应该产生过多平滑的估计值。请注意，由校准脚本显示的`max_accel` 只是一个理论上的最大值，在这个值上，各自的整形器仍然能够工作而不产生过多的平滑。这决不是建议设置的打印加速度。你的打印机能够承受的最大加速度取决于它的机械性能和所用步进电机的最大扭矩。因此，建议在`[printer]` 部分设置`max_accel` 时不要超过X轴和Y轴的估计值，并保守一些。

或者，按照[这个](Resonance_Compensation.md#selecting-max_accel)章节的输入整形器调整指南，打印测试模型，通过实验选择`max_accel` 参数。

同样的通知也适用于带有`SHAPER_CALIBRATE` 命令的输入整形器[自动校准](#input-shaper-auto-calibration)：在自动校准后仍需选择正确的`max_accel` 值，建议的加速度限制将不会被自动应用。

如果重新校准一个整形器，并且建议的整形器配置的报告平滑度与你在以前的校准中得到的几乎相同，这个步骤可以被跳过。

### 自定义测试轴

`TEST_RESONANCES` command supports custom axes. While this is not really useful for input shaper calibration, it can be used to study printer resonances in-depth and to check, for example, belt tension.

To check the belt tension on CoreXY printers, execute

```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```

and use `graph_accelerometer.py` to process the generated files, e.g.

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

以生成`/tmp/resonances.png`，对比共振的数据。

对标准构型的三角洲打印机（A塔~210°，B塔~330°，C塔~90°），执行

```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```

然后使用同样的命令

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

以生成`/tmp/resonances.png`，对比共振的数据。

## 输入整形器自动校准

除了为输入整形器功能手动选择适当的参数外，还可以直接从Klipper运行输入整形器的自动调谐。通过Octoprint终端运行以下命令：

```
SHAPER_CALIBRATE
```

这将为两个轴运行完整的测试，并生成用于频率响应和建议的输入整形器的csv输出（默认为`/tmp/calibration_data_*.csv` ）。在Octoprint中会提示控制台每个输入整形器的建议频率，以及为这台打印机推荐的输入整形器。例如：

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

如果认同建议的参数，现在可以执行`SAVE_CONFIG` 来保存设置并重新启动Klipper。 请注意，这不会更新`[printer]` 分段中的`max_accel`值。应该按照[选择max_accel](#selecting-max_accel)章节中的注意事项手动更新它。

如果你的打印机热床水平移动，可以选择测试的轴，这样就可以在测试之间改变加速度计的安装点（默认情况下，测试会同时对两个轴一起进行）：

```
SHAPER_CALIBRATE AXIS=Y
```

可以在校准每个轴之后执行`SAVE_CONFIG`。

然而，如果同时连接了两个加速度计，只需要运行`SHAPER_CALIBRATE` ，而不指定轴，就可以一次性校准两个轴的输入整形器。

### 重新校准输入整形器

`SHAPER_CALIBRATE` 命令也可以用来在将来重新校准输入整形器，特别是当打印机发生了一些可能影响其运动学的变化时。可以使用`SHAPER_CALIBRATE` 命令重新进行全面校准，或者通过提供`AXIS=` 参数将自动校准限制在一个轴上，例如

```
SHAPER_CALIBRATE AXIS=X
```

**警告！ **不建议非常频繁地运行成型机自动校准（例如，在每次打印之前或每天）。为了确定共振频率，自动校准会在每个轴上产生强烈的振动。通常，3D 打印机的设计不能承受长时间暴露于共振频率附近的振动。这样做可能会增加打印机组件的磨损并缩短其使用寿命。某些零件拧松或松动的风险也会增加。每次自动调整后，请务必检查打印机的所有部件（包括通常不会移动的部件）是否牢固地固定到位。

此外，由于测量中的一些噪音，每次校准得到的调谐结果会略有不同。不过，这些噪音一般不会对打印质量产生太大影响。然而，我们仍然建议仔细检查建议的参数，并在使用前打印一些测试件以确认它们是正确的。

## 离线处理加速计数据

It is possible to generate the raw accelerometer data and process it offline (e.g. on a host machine), for example to find resonances. In order to do so, run the following commands via Octoprint terminal:

```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```

ignoring any errors for `SET_INPUT_SHAPER` command. For `TEST_RESONANCES` command, specify the desired test axis. The raw data will be written into `/tmp` directory on the RPi.

The raw data can also be obtained by running the command `ACCELEROMETER_MEASURE` command twice during some normal printer activity - first to start the measurements, and then to stop them and write the output file. Refer to [G-Codes](G-Codes.md#adxl345) for more details.

The data can be processed later by the following scripts: `scripts/graph_accelerometer.py` and `scripts/calibrate_shaper.py`. Both of them accept one or several raw csv files as the input depending on the mode. The graph_accelerometer.py script supports several modes of operation:

* plotting raw accelerometer data (use `-r` parameter), only 1 input is supported;
* plotting a frequency response (no extra parameters required), if multiple inputs are specified, the average frequency response is computed;
* comparison of the frequency response between several inputs (use `-c` parameter); you can additionally specify which accelerometer axis to consider via `-a x`, `-a y` or `-a z` parameter (if none specified, the sum of vibrations for all axes is used);
* plotting the spectrogram (use `-s` parameter), only 1 input is supported; you can additionally specify which accelerometer axis to consider via `-a x`, `-a y` or `-a z` parameter (if none specified, the sum of vibrations for all axes is used).

Note that graph_accelerometer.py script supports only the raw_data\*.csv files and not resonances\*.csv or calibration_data\*.csv files.

For example,

```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```

will plot the comparison of several `/tmp/raw_data_x_*.csv` files for Z axis to `/tmp/resonances_x.png` file.

The shaper_calibrate.py script accepts 1 or several inputs and can run automatic tuning of the input shaper and suggest the best parameters that work well for all provided inputs. It prints the suggested parameters to the console, and can additionally generate the chart if `-o output.png` parameter is provided, or the CSV file if `-c output.csv` parameter is specified.

Providing several inputs to shaper_calibrate.py script can be useful if running some advanced tuning of the input shapers, for example:

* Running `TEST_RESONANCES AXIS=X OUTPUT=raw_data` (and `Y` axis) for a single axis twice on a bed slinger printer with the accelerometer attached to the toolhead the first time, and the accelerometer attached to the bed the second time in order to detect axes cross-resonances and attempt to cancel them with input shapers.
* Running `TEST_RESONANCES AXIS=Y OUTPUT=raw_data` twice on a bed slinger with a glass bed and a magnetic surfaces (which is lighter) to find the input shaper parameters that work well for any print surface configuration.
* Combining the resonance data from multiple test points.
* Combining the resonance data from 2 axis (e.g. on a bed slinger printer to configure X-axis input_shaper from both X and Y axes resonances to cancel vibrations of the *bed* in case the nozzle 'catches' a print when moving in X axis direction).
