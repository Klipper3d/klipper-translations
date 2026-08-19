# 压力传感器

这份文档描述了Klipper对于压力传感器的支持。压力传感器的基础功能包括读取受力数据，并且用于称量耗材等的物品。校准过的压力传感器是压力传感器探针的重要部分。

## 相关文档

* [load_cell 配置参考](Config_Reference.md#load_cell)
* [load_cellG-code命令](G-Codes.md#load_cell)
* [load_cell状态参考](Status_Reference.md#load_cell)

## 使用 `LOAD_CELL_DIAGNOSTIC`

当你第一次连接好压力传感器的时候，最好使用`LOAD_CELL_DIAGNOSTIC`来检测压力传感器的状态。这个工具会收集压力传感器10秒钟内的数据并且报告状态。

```
$ LOAD_CELL_DIAGNOSTIC
// Collecting load cell data for 10 seconds...
// Samples Collected: 3211
// Measured samples per second: 332.0
// Good samples: 3211, Saturated samples: 0, Unique values: 900
// Sample range: [4.01% to 4.02%]
// Sample range / sensor capacity: 0.00524%
```

你可以检查这些数据：

* 配置中的采样率应该接近'Measured samples per second'的值；否则，可能存在配置或接线问题。
* 'Saturated samples'的值应该为0。如果样本饱和，这意味着压力传感器检测到了超出量程的力。
* 'Unique values'应该等于'Samples Collected'的很大一部分。如果'Unique values'为1，这很有可能是接线问题。
* Tap or push on the sensor while `LOAD_CELL_DIAGNOSTIC` runs. If things are working correctly this should increase the 'Sample range'.

## 校准压力传感器

压力传感器是通过 `LOAD_CELL_CALIBRATE`校准的。这是一个交互式的校准工具，有三个步骤：

1. 首先，使用`TARE`命令来获得零点受力值。这是稍后应填入配置文件中`reference_tare_counts`的值。
1. 然后，向压力传感器施加一个已知大小的力（比如砝码），然后运行`CALIBRATE GRAMS=nnn`。在这步，将会计算得出`counts_per_gram`的值。参见[the next section](#applying-a-known-force-or-load)以获得更多建议。
1. 最后，使用 `ACCEPT`以保存结果。

你可以在校准中的任何时候使用 `ABORT`来取消校准流程。

### 施加一个已知的力

`CALIBRATE GRAMS=nnn`可以通过多种方式完成。如果你的压力传感器是在一个平台下（如热床或耗材架），最简单的做法是放置一个已知重量的物体，比如若干卷1KG的耗材。

如果你的压力传感器在工具头上，另一个方法可能更简单：将一个电子秤放在热床上，并缓慢降低工具头（或者升上热床，取决于你的打印机架构）来跟秤接触。你可以需要使用 `FORCE_MOVE`来实现。但是你也可能需要在电机关闭的情况下手动移动Z轴，直到工具头与电子秤接触。

一个较好的校准力度应该是接近压力传感器的最大标称值。 比如，如果你有一个5KG的压力传感器，使用一个5KG的负载来校准效果会比较好。这个方法对于床下的传感器更有效，因为有可以支撑重物的结构。对于工具头而言，这个负载数值可能无法在不损坏结构的前提下承受。但是，至少使用1KG的压力，大部分打印机都可以完美承受这个压力。

校准时，请留意回报的数值：

```
$ CALIBRATE GRAMS=555
// Calibration value: -2.78% (-59803108), Counts/gram: 73039.78739,
Total capacity: +/- 29.14Kg
```

`Total capacity`应该接近压力传感器的标称最大负载。如果这个数值比标称值大很多，可能设置了错误的增益或者传感器过于敏感。对于24位和32位的传感器，这不是一个关键问题，但是对于低位宽的传感器，这个问题会更重要。

## 读取受力数据

受力数据可以使用一个G-code命令来读取：

```
LOAD_CELL_READ
// 10.6g (1.94%)
```

数据是连续的，所以可以在宏中使用load_cell对象来读取：

```
{% set grams = printer.load_cell.force_g %}
```

这将提供过去一秒的平均受力数值，与温度传感器的原理类似。

## 给压力传感器归零（俗称去皮）

归零，有时称为去皮，会将当前压力传感器回报的数值设置为0。这在测量相对质量的时候较为有用，比如，在测量耗材质量时，使用 `LOAD_CELL_TARE`来将重量设置为0。这样，打印时，压力传感器会回报耗材被使用的重量（而不是整卷耗材的重量）。

```
LOAD_CELL_TARE
// Load cell tare value: 5.32% (445903)
```

目前的归零值会在打印机状态中回报，并可以在宏中读取。

```
{% set tare_counts = printer.load_cell.tare_counts %}
```

# 压力传感器探针

## 相关文档

* [load_cell_probe配置参考](Config_Reference.md#load_cell_probe)
* [load_cell_probe G-code命令](G-Codes.md#load_cell_probe)
* [load_cell_probe状态参考](Status_Reference.md#load_cell_probe)

## 压力传感器探针的安全问题

因为压力传感器使用喷嘴直接接触，所以当施加的力过于多，会有损坏打印机的风险。压力传感器探测系统有一系列的安全措施，来保证打印机不会由于工具头施加过多的力而损坏。理解这些安全措施很重要，因为大部分安全措施都会被错误的配置值而被规避。

#### 校准检查

每次归位时，load_cell_probe对象都会检查load_cell是否以校准。如果没有，归位将被停止并汇报错误：`!! Load Cell not calibrated`。

#### `counts_per_gram`

这个设置用于将原始传感器数据转换为克（g）。所有的安全限制数值都是克，对于使用者更方便。如果`counts_per_gram`设置不准确，可以轻易对工具头施加超过安全值的力。您永远都不应该猜测这个值。使用`LOAD_CELL_CALIBRATE` 来找到对于您的压力传感器的实际`counts_per_gram`数值。

#### `trigger_force`

这是归位过程中触发限位所需要的力。当归位时，限位会使用当前的读数进行归零操作。`trigger_force`是从这个归零后的值测量的。当探针与热床接触时，这个值总是会有部分超出，所以请设置相对保守的值，比如，100g的设置可能会导致工具头停止前最高350g的受力。这个“超出值”会随着探测时的`speed`（速度），较低的ADC采样率，或者[多MCU归位](Multi_MCU_Homing.md)而增长。

#### `reference_tare_counts`

这是在`LOAD_CELL_CALIBRATE`时设置的参考归零值。这个数值与`force_safety_limit`一起工作，用于限制工具头的最大受力。

#### `force_safety_limit（力安全限值）`

这是在探测过程中允许的，相对于`reference_tare_counts`的最大绝对受力。如果MCU发现这个受力大于这个值，打印机会被停止并报错`!! Load cell endstop: too much force!`。由多种方式可以出发这个保护措施：

第一个风险是选择过大的 `drift_filter_cutoff_frequency`值。这可能会导致偏移过滤器错误的过滤掉一个探针事件并继续归位移动。在这种情况下，`force_safety_limit`将会作为最后保护措施。

第二种情况是在一个位置重复探测。Klipper不会在单独的`PROBE`命令中收回探针。这可能导致探测结束时对工具头的受力。由于外部力在探测过程中可以非常大，`load_cell_probe`对象会在每次探测时归零受力值。如果您重复`PROBE`指令，load_cell_probe对象会将限位触发的力归零。多次循环这个过程会导致工具头上不断增加的力。 `force_safety_limit`会在这种情况不受控制时停止循环。

Another way this run-away can happen is damage to a strain gauge. If the metal part is permanently bent it will change the `reference_tare_counts` of the device. This puts the starting tare value much closer to the limit making it more likely to be violated. You want to be notified if this is happening because your hardware has been permanently damaged.

最后一种触发方式是温度变化。如果你的应变片被加热，它们的`reference_tare_counts`可能与室温下不同。这种情况下，适度增加`force_safety_limit`以允许温度变化。

#### 压力传感器限位的看门狗

当归位时，load_cell_endstop对象会在MCU上启动一个看门狗任务以监控传感器的读数。如果传感器在两个连续的采样周期中都没有发送数据，看门狗将会停止打印机并报错`!! LoadCell Endstop timed out waiting on ADC data`。

如果这发生了，很有可能ADC有问题。不可靠的打印机接地可能会导致问题。框架，电源外壳，以及打印机热床都应可靠地接地。你可能需要在框架的不同部位接地。阳极氧化的铝型材导电性能不佳，你可能需要打磨一个区域来连接地线以获得良好的电气接触。

#### Interpolation

To increase the precision of the probing result, the position of the first contact between nozzle and bed can be estimated by fitting a piecewise function to the measured data. The data will consist of two regions: while the nozzle is above the bed, the force will be constant (at the tare value). When the nozzle is in contact with the bed, the force will increase linearly with decreasing z position. A piecewise function is fitted to the data and the optimal z position of the split point is found by minimising the error squared. This enables a resolution finer than the distance between the sampling points and will also be less sensitive to noise.

Due to both physical and technical reasons, the interpolation uses data collected during an additional ascending movement after the initial descending move. The first 300ms of data collected during the ascending move will be used for the fit (this minimises the influence of tare drifts). The collected data must contain enough samples for the fit: at least 3 samples each below and above the contact point are required.

It is recommended to use a relatively high trigger force for the probe to have a strong enough signal. If you have too few samples below the contact point, try increasing the `trigger_force` or reducing the `lift_speed`. However, if the `lift_speed` is too small, there will be too few samples above the contact point due to the 300ms window.

The distance of the ascending move can be configured through the `sample_retract_dist` parameter.

## 压力传感器探针设置流程

这个部分覆盖了设置一个压力传感器探针的流程。

### 首先确认压力传感器

一个 `[load_cell_probe]`同时也是一个`[load_cell]`，与 `[load_cell]`有关的G-code命令同时都适用于 `[load_cell_probe]`。在尝试使用压力传感器探针前，先根据[校准压力传感器](Load_Cell.md#calibrating-a-load-cell)章节关于`CALIBRATE_LOAD_CELL` 的指引校准压力出啊干起，并使用`LOAD_CELL_DIAGNOSTIC`检查它的状态。

### 使用LOAD_CELL_TEST_TAP验证探针工作

在实际使用压力传感器用于探测前，使用`LOAD_CELL_TEST_TAP`指令来测试压力传感器探针的工作。这个命令检测轻触，就像PROBE命令，但是不移动Z轴。默认情况下，它会在测试结束前检测3次轻触。你有30秒的时间来进行每次轻触，如果没有检测到轻触，命令会超时结束。

如果测试失败，检查你的配置并运行 `LOAD_CELL_DIAGNOSTIC`来寻找问题。

压力传感器不支持`QUERY_ENDSTOPS`或 `QUERY_PROBE`指令。使用`LOAD_CELL_TEST_TAP`来在探测前测试功能。

### 建议探测温度

目前，我们推荐在归位和探测时将喷嘴温度保持在耗材会溢料的温度下。140摄氏度是一个不错的起始点。这个温度同时也不会伤害PEI构件表面。

溢料导致的喷嘴及热床污染是压力传感器探测错误的头号原因。Klipper目前没有检测低质量结果的通用解决方案。现有的代码会将低质量的探测结果作为有效的探测点。识别这些低质量结果是目前的研究方向。

目前，由于溢料污染，自动更换探测位置的功能还没有被Klipper支持。类似于`quad_gantry_level`的模块会反复在同一个坐标探测，即使前一次探测失败。

由于以上这些原因，极度不推荐在打印温度探测。

### 高温喷嘴保护

The Voron project has a great macro for protecting your print surface from the hot nozzle. See [Voron Tap's
`activate_gcode`](https://github.com/VoronDesign/Voron-Tap/blob/main/config/tap_klipper_instructions.md)

极度推荐在你的配置中使用类似的东西。

### 清理喷嘴

在探测前喷嘴应该是干净的。你可以手动清洁，你也可以安装一个喷嘴清洁器，并自动化这个流程。以下是一个推荐的序列：

1. 等到喷嘴加热到探测温度（比如`M109 S140`）
1. 归位机器(`G28`)
1. 在一个刷子上刮净喷嘴
1. 充分加热热床（使热床均热）
1. 进行探测任务（QGL，床网等）。

### 喷嘴热胀冷缩的温度补偿

如果在安全温度探测，喷嘴会在到达打印温度时略微膨胀。这将会导致喷嘴距离构件表面更近。可以使用[\[z_thermal_adjust\]](Config_Reference.md#z_thermal_adjust)来补偿。该补偿工具会补偿一系列打印温度，从PLA到PC。

#### 计算 `[z_thermal_adjust]`的`temp_coeff`

最简单的方法是在两个不同的温度测量。理想情况下，这应该涵盖打印温度的下限和上限（比如，180C和290C）。你可以在两个温度分别执行`PROBE_ACCURACY`并计算 `average z`的差值。

调整值即是喷嘴长度除以温度变化。比如。

```
temp_coeff = -0.05 / (290 - 180) = -0.00045455
```

预期的值应该是负值。正的`temp_coeff`会在加热时将喷嘴移的更近，而负值会将喷嘴移远。预期的行为是加热时将喷嘴移的更远。

#### 配置`[z_thermal_adjust]`

设置z_thermal_adjust使用 `extruder`作为温度来源。比如：

```
[z_thermal_adjust]
temp_coeff=-0.00045455
sensor_type: temperature_combined
sensor_list: extruder
combination_method: max
maximum_deviation: 999
min_temp: 0
max_temp: 400
max_z_adjustment: 0.1
```

## 对工具头压力传感器的连续归零过滤器

Klipper在MCU上实现了一个可配置的IIR过滤器来预防在探测时连续的归零。连续归零指的是0值随着外部因素（比如进料管或者温度变化）而变化。这是瞄准工具头传感器和动床结构开发的，这种结构会遭受大量外部因素的影响。

### 安装SciPy

过滤器的代码使用绝佳的[SciPy](https://scipy.org/)库基于配置值来计算过滤器的参数。

预编译的SciPi构建在32位Raspberry Pi上的Python 3可用。极度推荐32位+Python 3的组合，因为这可以流水线化你的安装流程。可以使用Python 2，但是安装过程将话费30+分钟，并且需要安装额外工具。

```bash
~/klippy-env/bin/pip install scipy
```

### 过滤器配置

过滤器的参数必须根据打印机正常工作时的偏移来决定。脚本中提供Jupyter Notebook，[filter_workbench.ipynb](../scripts/filter_workbench.ipynb)，用于提供详细的调查数据，基于真实数据和FFT。

### 过滤建议

对于那些只想要一个能用的过滤器的人，建议：

* 真正必须的选项是`drift_filter_cutoff_frequency`。一个保守的起始值是 `0.5`Hz。Prusa MK4在发货时使用`0.8`hz，Prusa XL发货时使用`11.2`hz。这可能是一个安全的实验范围。将这个值设置的过高会导致延迟触发，进而导致工具头受力过大。
* 将`trigger_fouce`保持在低位。过滤器的内部计数器将触发值接近0，所以较大的触发力度是不必须的。
* 将 `force_safety_limit`保持在保守的值。默认是2KG，应该可以保证工具头在实验时安全。如果你触发了这个限制，则`drift_filter_cutoff_frequency`可能过高。

## 对于压力传感器工具头板的建议

该部分讲述关于想要在工具头板上使用[load_cell_probe]的建议

### ADC传感器选择&工具头板开发建议

理想情况下，一个传感器应该满足以下要求：

* 至少24位带宽
* 使用SPI通信
* 有一根可以不通过SPI通信就可以确认准备就绪的引脚。这根引脚经常被称为"Data Ready"或者"DRDY"引脚。检查一根引脚比发送一次SPI闻询快得多。
* 有一个可编程的128级增益放大器。这样就无需单独的放大器了。
* 通过SPI来指示传感器是否重置。检测重置可以避免归位时的错误，并且在一开始就避免嘈杂的数据。这也可以帮助用户检测接地和接线问题。
* 一个可以在350Hz和2Khz之间选择的采样率。太高的采样率对于3D打印机并没有好处，因为打印头在高速移动的时候就能产生很多噪音。250hz以下的采样率需要更低的探测速率。这也会增加打印头的受力，因为在低采样率时触发延迟较高。比如，一个100Hz的压力传感器在1mm/s探测的时候，安全余量和一个500Hz在5mm/s探测的时候一样。
* 如果准备将压力传感器安装在床下，并且期望使用多个压力传感器，则应使用一款可以同时采样所有传感器的芯片。“多通道切换式”的多ADC实现方式需要一点时间来稳定读数，所以这类芯片在多传感器布置下不适用于探测用途。

在Klipper的 `bulk_sensor` 和 `load_cell_endstop`架构下，引入新传感器芯片的支持不是特别难。

### 5V电源滤波

强烈建议在ADC芯片上使用比制造商建议规格更大的电容。ADC芯片是为了低电气噪音环境设计的（比如电池供电）。传感器的制造商推荐的规格一般假定了一个纯净的电源环境。将他们推荐的电容规格视为下限。

3D打印机会在5V电源总线上产生大量电气噪音，这会严重影响传感器的精度。在一块由标准3D打印机电源供电的主板上测试压力传感器，保持步进电机激活，以模拟真实环境。测试之后再决定需要的滤波电容大小。

### 接地与接地层

模拟ADC芯片的部分组件对于电气噪音和静电极度敏感。放置在第一版层的较大接地层可以缓解噪声问题。将芯片安装在远离电源以及DCDC转换器的地方。电路板应有恰当的接地返回主DC电源。

### 对于HX711和HX717的额外提示

这些传感器因为低成本及其良好的供应链可得性而受欢迎。然而，这款传感器拥有一些缺点：

* HX71x传感器系列使用bit-bang通信，这会造成较高的MCU负载开销。使用SPI通信的传感器可以节省工具板CPU的运算资源。
* HX71x系列传感器没有与MCU通信重置事件的能力。Klipper 采用一种时序启发式方法来检测复位，但这并非理想方案。重置通常意味着线路连接或接地存在问题。
* 对于探测，强烈推荐HX717，由于它的采样率更高（320 vs HX711仅有80）。在使用HX711进行探测时，探测速度应限制为2mm/s。
* HX71x系列的采样率无法使用Klipper配置来设置。如果你有一个每秒10采样的传感器（极其常见），它需要更改物理配置（如配置电阻）才能以每秒80采样运行。
