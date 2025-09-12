# 共振补偿

Klipper支持输入整形（Input Shaping）——一种可以减少打印中振铃现象（也称为回声、重影或波纹）的技术。振铃是一种表面打印缺陷，通常表现为边缘等元素在打印表面上重复出现，形成微妙的“回声”：

|[振铃测试](img/ringing-test.jpg)|[3D小船](img/ringing-3dbenchy.jpg)|

振铃是由打印机在快速改变打印方向时产生的机械振动引起的。请注意，振铃通常有机械根源：打印机框架刚性不足、皮带不够紧或过于松软、机械部件对齐问题、移动质量过重等。这些因素应首先检查并尽可能修复。

[输入整形](https://en.wikipedia.org/wiki/Input_shaping)是一种开环控制技术，它创建一个能够抵消自身振动的指令信号。输入整形在启用前需要进行一些调校和测量。除了减少振铃外，输入整形通常还能降低打印机的整体振动和抖动，并可能提高Trinamic步进电机驱动器的stealthChop模式的可靠性。

## 调校

基本调校需要通过打印测试模型来测量打印机的振铃频率。

在切片软件中切片振铃测试模型，该模型可在
[docs/prints/ringing_tower.stl](prints/ringing_tower.stl) 找到：

* 建议层高为0.2或0.25毫米。
* 填充层和顶层可设置为0。
* 使用1-2个外壁，或者更好的是使用平滑花瓶模式（vase mode）并设置1-2毫米的底座。
* 外壁打印速度应足够高，大约80-100毫米/秒。
* 确保最小层时间**最多**为3秒。
* 确保切片软件中任何“动态加速度控制”功能已禁用。
* 不要旋转模型。模型背面有X和Y标记。请注意标记位置与打印机轴的不寻常对应关系——这不是错误。这些标记可在后续调校过程中用作参考，因为它们显示了测量结果对应的轴。

### 振铃频率

首先，测量**振铃频率**。

1. 如果`square_corner_velocity`参数已被更改，请将其恢复为5.0。使用输入整形时不建议增加该值，因为它可能导致零件过度平滑——最好使用更高的加速度值。
2. 通过发出以下命令禁用`minimum_cruise_ratio`功能：`SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
3. 禁用压力提前：`SET_PRESSURE_ADVANCE ADVANCE=0`
4. 如果已在`printer.cfg`中添加了`[input_shaper]`部分，请执行`SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0`命令。如果收到“未知命令”错误，此时可安全忽略并继续测量。
5. 执行命令：
   `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`
   基本上，我们通过设置不同的大加速度值来使振铃现象更明显。此命令将从1500 mm/sec²开始，每5毫米增加一次加速度：1500 mm/sec²、2000 mm/sec²、2500 mm/sec²，依此类推，直到最后一段达到7000 mm/sec²。
6. 使用建议参数切片并打印测试模型。
7. 如果振铃已清晰可见且您发现加速度对打印机过高（例如打印机剧烈抖动或开始丢步），可提前停止打印。
8. 使用模型背面的X和Y标记作为参考。X标记侧的测量结果应用于X轴*配置*，Y标记侧用于Y轴配置。测量X标记侧零件上几个振荡之间的距离*D*（单位：毫米），靠近凹口处测量，最好跳过第一个或前两个振荡。为更轻松地测量振荡间距，可先标记振荡位置，然后用尺子或卡尺测量标记间的距离：

    |[标记振铃](img/ringing-mark.jpg)|[测量振铃](img/ringing-measure.jpg)|

9. 计算测量距离*D*对应的振荡次数*N*。如果不确定如何计算振荡次数，请参考上图，其中显示了*N* = 6次振荡。
10. 计算X轴的振铃频率为 *V* &middot; *N* / *D* （赫兹），其中*V*是外壁打印速度（毫米/秒）。以上图为例，我们标记了6次振荡，测试模型以100毫米/秒的速度打印，因此频率为 100 * 6 / 12.14 ≈ 49.4 Hz。
11. 对Y标记侧也执行步骤(8)-(10)。

请注意，测试打印中的振铃应遵循弯曲凹口的模式，如上图所示。如果不遵循，则此缺陷实际上不是振铃，而是有其他来源——可能是机械问题或挤出机问题。应在启用和调校输入整形器之前先解决此问题。

如果测量不可靠（例如振荡间距不稳定），可能意味着打印机在同一轴上有多个共振频率。可以尝试遵循[振铃频率测量不可靠](#振铃频率测量不可靠)部分中描述的调校过程，仍可从输入整形技术中获益。

振铃频率可能取决于模型在构建板上的位置和Z高度，*尤其是在三角洲打印机上*；可以检查测试模型不同位置和不同高度的频率是否存在差异。如果存在这种情况，可以计算X和Y轴的平均振铃频率。

如果测得的振铃频率非常低（低于约20-25赫兹），建议在继续进行进一步输入整形调校之前，先考虑加固打印机或减轻移动质量——根据您的具体情况而定——然后重新测量频率。对于许多流行的打印机型号，通常已有一些解决方案可用。

请注意，如果对打印机进行了影响移动质量或改变系统刚度的更改，振铃频率可能会发生变化，例如：

* 在喷头安装、移除或更换了改变其质量的工具，例如为直驱挤出机更换了新的（更重或更轻的）步进电机或安装了新的热端，增加了重型风扇和风道等。
* 皮带被拉紧。
* 安装了增加框架刚性的附件。
* 在床甩式打印机上安装了不同的床或增加了玻璃等。

如果进行了此类更改，最好至少测量振铃频率以查看是否发生变化。

### 输入整形器配置

测量X轴和Y轴的振铃频率后，可以在`printer.cfg`中添加以下部分：
```
[input_shaper]
shaper_freq_x: ...  # 测试模型X标记的频率
shaper_freq_y: ...  # 测试模型Y标记的频率
```

以上图为例，我们得到 shaper_freq_x/y = 49.4。

### 选择输入整形器

Klipper支持几种输入整形器。它们在对共振频率测量误差的敏感性和在打印零件中引起的平滑程度方面有所不同。此外，像2HUMP_EI和3HUMP_EI这样的某些整形器通常不应与shaper_freq = 共振频率一起使用——它们的配置基于不同的考虑，旨在同时减少多个共振。

对于大多数打印机，推荐使用MZV或EI整形器。本节描述了选择它们之间的测试过程，并确定一些其他相关参数。

按如下方式打印振铃测试模型：

1. 重启固件：`RESTART`
2. 准备测试：`SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
3. 禁用压力提前：`SET_PRESSURE_ADVANCE ADVANCE=0`
4. 执行：`SET_INPUT_SHAPER SHAPER_TYPE=MZV`
5. 执行命令：
   `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`
6. 使用建议参数切片并打印测试模型。

如果此时看不到振铃，则推荐使用MZV整形器。

如果仍能看到一些振铃，请使用[振铃频率](#振铃频率)部分中描述的步骤(8)-(10)重新测量频率。如果频率与之前获得的值有显著差异，则需要更复杂的输入整形器配置。可以参考[输入整形器](#输入整形器)部分的技术细节。否则，继续下一步。

现在尝试EI输入整形器。要尝试它，请重复上述步骤(1)-(6)，但在步骤4中执行以下命令：
`SET_INPUT_SHAPER SHAPER_TYPE=EI`。

比较使用MZV和EI输入整形器的两次打印。如果EI显示的结果明显优于MZV，则使用EI整形器，否则优先选择MZV。请注意，EI整形器会在打印零件中引起更多平滑（详见下一节）。将`shaper_type: mzv`（或ei）参数添加到[input_shaper]部分，例如：
```
[input_shaper]
shaper_freq_x: ...
shaper_freq_y: ...
shaper_type: mzv
```

关于整形器选择的一些注意事项：

* EI整形器可能更适合床甩式打印机（如果共振频率和由此产生的平滑度允许）：随着更多耗材沉积在移动的床上，床的质量增加，共振频率会降低。由于EI整形器对共振频率变化更具鲁棒性，因此在打印大型零件时可能表现更好。
* 由于三角洲运动学的特性，构建体积不同部分的共振频率可能差异很大。因此，EI整形器可能比MZV或ZV更适合三角洲打印机，并应考虑使用。如果共振频率足够大（超过50-60赫兹），甚至可以尝试测试2HUMP_EI整形器（通过运行上述建议测试并使用`SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI`），但在启用之前请检查[下节](#选择max_accel)中的注意事项。

### 选择max_accel

您应该有上一步选择的整形器的打印测试（如果没有，请使用[建议参数](#调校)切片测试模型，禁用压力提前`SET_PRESSURE_ADVANCE ADVANCE=0`，并启用调校塔`TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`）。请注意，在非常高的加速度下，根据共振频率和选择的输入整形器（例如，EI整形器比MZV产生更多平滑），输入整形可能会导致零件过度平滑和圆角。因此，应选择合适的max_accel值以防止这种情况。另一个可能影响平滑度的参数是`square_corner_velocity`，因此不建议将其增加到默认的5毫米/秒以上，以防止增加平滑度。

为了选择合适的max_accel值，请检查所选输入整形器的模型。首先，注意在哪个加速度下振铃仍然很小——您对其感到满意。

接下来，检查平滑度。为此，测试模型在壁上有一个小间隙（0.15毫米）：

[测试间隙](img/smoothing-test.png)

随着加速度增加，平滑度也随之增加，实际打印中的间隙变宽：

[整形器平滑](img/shaper-smoothing.jpg)

在此图中，加速度从左到右增加，从3500 mm/sec²（从左数第五个条带）开始间隙开始变大。因此，为了避免过度平滑，本例中的良好max_accel值= 3000（mm/sec²）。

注意在您的测试打印中间隙仍然非常小时的加速度。如果在高加速度下看到凸起，但壁上完全没有间隙，这可能是由于禁用了压力提前，尤其是在Bowden挤出机上。如果是这种情况，可能需要启用PA重新打印。这也可能是耗材流量校准错误（过高）的结果，因此最好也检查一下。

选择两个加速度值（来自振铃和平滑度）中的较小值，并将其作为`max_accel`放入printer.cfg。

需要注意的是，特别是在低振铃频率下，EI整形器即使在较低加速度下也可能导致过度平滑。在这种情况下，MZV可能是更好的选择，因为它可能允许更高的加速度值。

在非常低的振铃频率（约25赫兹及以下）时，即使MZV整形器也可能产生过多平滑。如果是这种情况，您还可以尝试在[选择输入整形器](#选择输入整形器)部分中使用ZV整形器重复步骤，通过使用`SET_INPUT_SHAPER SHAPER_TYPE=ZV`命令。ZV整形器的平滑度应比MZV更小，但对测量振铃频率的误差更敏感。

另一个考虑因素是，如果共振频率太低（低于20-25赫兹），最好增加打印机刚度或减轻移动质量。否则，加速度和打印速度可能会因过多平滑而受到限制，而不是振铃。

### 精细调校共振频率

请注意，使用振铃测试模型测量共振频率的精度足以满足大多数用途，因此不建议进一步调校。如果您仍想尝试双重检查结果（例如，在使用所选输入整形器和之前测量的相同频率打印测试模型后仍看到一些振铃），可以遵循本节中的步骤。请注意，如果在启用[input_shaper]后在不同频率看到振铃，本节对此无帮助。

假设您已使用建议参数切片振铃模型，请对X和Y轴分别执行以下步骤：

1. 准备测试：`SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
2. 确保压力提前已禁用：`SET_PRESSURE_ADVANCE ADVANCE=0`
3. 执行：`SET_INPUT_SHAPER SHAPER_TYPE=ZV`
4. 从使用所选输入整形器的现有振铃测试模型中选择显示振铃足够清晰的加速度，并通过以下命令设置：`SET_VELOCITY_LIMIT ACCEL=...`
5. 计算`TUNING_TOWER`命令以调校`shaper_freq_x`参数所需的必要参数如下：start = shaper_freq_x * 83 / 132 和 factor = shaper_freq_x / 66，其中此处的`shaper_freq_x`是`printer.cfg`中的当前值。
6. 执行命令：
   `TUNING_TOWER COMMAND=SET_INPUT_SHAPER PARAMETER=SHAPER_FREQ_X START=start FACTOR=factor BAND=5`
   使用步骤(5)计算的`start`和`factor`值。
7. 打印测试模型。
8. 重置原始频率值：
   `SET_INPUT_SHAPER SHAPER_FREQ_X=...`。
9. 找到振铃最少的条带，并从底部开始数其编号（从1开始）。
10. 通过旧的 shaper_freq_x * (39 + 5 * #条带编号) / 66 计算新的shaper_freq_x值。

以相同方式对Y轴重复这些步骤，将X轴引用替换为Y轴（例如，在公式和`TUNING_TOWER`命令中将`shaper_freq_x`替换为`shaper_freq_y`）。

例如，假设您测量到某轴的振铃频率等于45赫兹。这给出`TUNING_TOWER`命令的start = 45 * 83 / 132 = 28.30 和 factor = 45 / 66 = 0.6818。现在假设打印测试模型后，从底部数第四个条带的振铃最少。这给出更新的shaper_freq_?值等于 45 * (39 + 5 * 4) / 66 ≈ 40.23。

计算出新的`shaper_freq_x`和`shaper_freq_y`参数后，您可以使用新的`shaper_freq_x`和`shaper_freq_y`值更新`printer.cfg`中的`[input_shaper]`部分。

### 压力提前

如果您使用压力提前，可能需要重新调校。按照[说明](Pressure_Advance.md#tuning-pressure-advance)找到新值，如果与之前不同。在调校压力提前之前确保重启Klipper。

### 振铃频率测量不可靠

如果您无法测量振铃频率，例如振荡间距不稳定，您仍可能利用输入整形技术，但结果可能不如正确测量频率时好，并且需要更多调校和打印测试模型。另一种可能性是购买并安装加速度计，并用它测量共振（参考[文档](Measuring_Resonances.md)了解所需硬件和设置过程）——但这需要一些压接和焊接。

调校时，在`printer.cfg`中添加空的`[input_shaper]`部分。然后，假设您已使用建议参数切片振铃模型，按如下方式打印测试模型3次。第一次打印前，运行

1. `RESTART`
2. `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
3. `SET_PRESSURE_ADVANCE ADVANCE=0`
4. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=60 SHAPER_FREQ_Y=60`
5. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

并打印模型。然后再次打印模型，但打印前运行

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=50 SHAPER_FREQ_Y=50`
2. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

然后第三次打印模型，但现在运行

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=40 SHAPER_FREQ_Y=40`
2. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

本质上，我们使用TUNING_TOWER和2HUMP_EI整形器，以60赫兹、50赫兹和40赫兹的shaper_freq打印振铃测试模型。

如果所有模型都没有显示出振铃改善，则不幸的是，输入整形技术似乎无法帮助您的情况。

否则，可能所有模型都显示无振铃，或有些显示振铃而有些不明显。选择显示振铃改善最明显且频率最高的测试模型。例如，如果40赫兹和50赫兹模型几乎无振铃，而60赫兹模型已显示更多振铃，则坚持使用50赫兹。

现在检查EI整形器在您的情况下是否足够好。根据选择的2HUMP_EI整形器频率选择EI整形器频率：

* 对于2HUMP_EI 60赫兹整形器，使用shaper_freq = 50赫兹的EI整形器。
* 对于2HUMP_EI 50赫兹整形器，使用shaper_freq = 40赫兹的EI整形器。
* 对于2HUMP_EI 40赫兹整形器，使用shaper_freq = 33赫兹的EI整形器。

现在再打印一次测试模型，运行

1. `SET_INPUT_SHAPER SHAPER_TYPE=EI SHAPER_FREQ_X=... SHAPER_FREQ_Y=...`
2. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

提供之前确定的shaper_freq_x=...和shaper_freq_y=...。

如果EI整形器显示与2HUMP_EI整形器非常相近的良好结果，则坚持使用EI整形器和之前确定的频率，否则使用相应频率的2HUMP_EI整形器。将结果添加到`printer.cfg`，例如
```
[input_shaper]
shaper_freq_x: 50
shaper_freq_y: 50
shaper_type: 2hump_ei
```

继续使用[选择max_accel](#选择max_accel)部分进行调校。

## 故障排除和常见问题

### 我无法获得可靠的共振频率测量

首先，确保这不是打印机的其他问题而非振铃。如果测量不可靠（例如振荡间距不稳定），可能意味着打印机在同一轴上有多个共振频率。可以尝试遵循[振铃频率测量不可靠](#振铃频率测量不可靠)部分中描述的调校过程，仍可从输入整形技术中获益。另一种可能性是安装加速度计，[测量](Measuring_Resonances.md)共振并使用这些测量结果自动调校输入整形器。

### 启用[input_shaper]后，我的打印件过度平滑且细节丢失

检查[选择max_accel](#选择max_accel)部分中的注意事项。如果共振频率低，不应设置过高的max_accel或增加square_corner_velocity参数。最好选择MZV甚至ZV输入整形器而非EI（或2HUMP_EI和3HUMP_EI整形器）。

### 成功打印一段时间无振铃后，振铃似乎又回来了

可能一段时间后共振频率发生了变化。例如，皮带张力可能已改变（皮带变松），等等。最好检查并重新测量[Ringing frequency](#ringing-frequency)部分中描述的振铃频率，并在必要时更新配置文件。

### 双滑车设置是否支持输入整形器？

是的。在这种情况下，应为每个滑车测量两次共振。例如，如果第二个（双）滑车安装在X轴上，可以为X轴为主滑车和双滑车设置不同的输入整形器。然而，Y轴的输入整形器应相同（因为最终该轴由一个或多个步进电机驱动，每个电机执行完全相同的步数）。为这种设置配置输入整形器的一种可能性是在`printer.cfg`中保持`[input_shaper]`部分为空，并额外定义`[delayed_gcode]`部分如下：
```
[input_shaper]
# 故意留空

[delayed_gcode init_shaper]
initial_duration: 0.1
gcode:
  SET_DUAL_CARRIAGE CARRIAGE=1
  SET_INPUT_SHAPER SHAPER_TYPE_X=<dual_carriage_shaper> SHAPER_FREQ_X=<dual_carriage_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
  SET_DUAL_CARRIAGE CARRIAGE=0
  SET_INPUT_SHAPER SHAPER_TYPE_X=<primary_carriage_shaper> SHAPER_FREQ_X=<primary_carriage_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
```
请注意，`SHAPER_TYPE_Y`和`SHAPER_FREQ_Y`在两个命令中应相同。也可以将类似代码段放入切片软件的启动g代码中，但这样整形器将在任何打印开始前不会启用。

请注意，输入整形器只需配置一次。后续通过`SET_DUAL_CARRIAGE`命令更改滑车或其模式将保留已配置的输入整形器参数。

### input_shaper会影响打印时间吗？

不会，`input_shaper`功能本身对打印时间几乎没有影响。然而，`max_accel`的值确实会影响（此参数的调校在[本节](#选择max_accel)中描述）。

## 技术细节

### 输入整形器

Klipper中使用的输入整形器相当标准，可以在描述相应整形器的文章中找到更深入的概述。本节包含对支持的输入整形器一些技术方面的简要概述。下表显示了每种整形器的一些（通常是近似的）参数。

| 输入 <br> 整形器 | 整形器 <br> 持续时间 | 振动减少20倍 <br> （5%振动容差） | 振动减少10倍 <br> （10%振动容差） |
|:--:|:--:|:--:|:--:|
| ZV | 0.5 / shaper_freq | 不适用 | ± 5% shaper_freq |
| MZV | 0.75 / shaper_freq | ± 4% shaper_freq | -10%...+15% shaper_freq |
| ZVD | 1 / shaper_freq | ± 15% shaper_freq | ± 22% shaper_freq |
| EI | 1 / shaper_freq | ± 20% shaper_freq | ± 25% shaper_freq |
| 2HUMP_EI | 1.5 / shaper_freq | ± 35% shaper_freq | ± 40 shaper_freq |
| 3HUMP_EI | 2 / shaper_freq | -45...+50% shaper_freq | -50%...+55% shaper_freq |

关于振动减少的说明：表中的值是近似的。如果知道打印机每个轴的阻尼比，可以更精确地配置整形器，从而在更宽的频率范围内减少共振。然而，阻尼比通常未知，且在没有特殊设备的情况下很难估算，因此Klipper默认使用0.1值，这是一个良好的通用值。表中的频率范围涵盖了该值周围许多不同的可能阻尼比（大约从0.05到0.2）。

另请注意，EI、2HUMP_EI和3HUMP_EI被调校为将振动减少到5%，因此10%振动容差的值仅作参考。

**如何使用此表：**

* 整形器持续时间影响零件的平滑度——持续时间越大，零件越平滑。这种依赖性不是线性的，但可以给出相同频率下哪些整形器“平滑”更多的感觉。按平滑度排序如下：ZV < MZV < ZVD ≈ EI < 2HUMP_EI < 3HUMP_EI。此外，很少实际将shaper_freq = 共振频率用于2HUMP_EI和3HUMP_EI整形器（它们应用于减少多个频率的振动）。
* 可以估计整形器减少振动的频率范围。例如，shaper_freq = 35赫兹的MZV将振动减少到5%的频率范围为[33.6, 36.4]赫兹。shaper_freq = 50赫兹的3HUMP_EI将振动减少到5%的范围为[27.5, 75]赫兹。
* 可以使用此表检查需要减少多个频率振动时应使用哪种整形器。例如，如果同一轴上有35赫兹和60赫兹的共振：a) EI整形器需要shaper_freq = 35 / (1 - 0.2) = 43.75赫兹，并将减少振动直到43.75 * (1 + 0.2) = 52.5赫兹，因此不足；b) 2HUMP_EI整形器需要shaper_freq = 35 / (1 - 0.35) = 53.85赫兹，并将减少振动直到53.85 * (1 + 0.35) = 72.7赫兹——因此这是可接受的配置。对于给定的整形器，始终尝试使用尽可能高的shaper_freq（可能留一些安全余量，因此本例中shaper_freq ≈ 50-52赫兹效果最佳），并尝试使用整形器持续时间尽可能小的整形器。
* 如果需要减少多个非常不同的频率（例如30赫兹和100赫兹）的振动，可能会发现上表提供的信息不足。在这种情况下，可以尝试使用更灵活的[scripts/graph_shaper.py](../scripts/graph_shaper.py)脚本。