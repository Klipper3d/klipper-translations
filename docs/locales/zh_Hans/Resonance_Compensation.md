# 共振补偿

Klipper支持输入整形 -一种可以用来减少打印件上振纹（也被称为echo、ghosting或ripping）的技术。振纹是一种表面打印缺陷，通常在边角的位置表面重复出现，成为一种微妙的水波状纹路：

|![振纹测试](img/ringing-test.jpg)|![3D Benchy](img/ringing-3dbenchy.jpg)|

振纹是由打印机在快速改变打印方向时机械振动引起的。请注意，振纹通常源于机械方面的问题：打印机框架强度不足，皮带不够紧或太有弹性，机械部件的对准问题，移动质量大等。如果可能的话，应首先检查和解决这些问题。

[输入整形](https://en.wikipedia.org/wiki/Input_shaping)是一种开环控制技术，它通过生成一个控制信号来抵消自身的振动。输入整形在启用之前需要进行一些调整和测量。除了振纹之外，输入整形通常可以减少打印机的振动和摇晃，也可以提高 Trinamic 步进驱动器的StealthChop模式的可靠性。

## 调整

基本调谐需要通过打印测试模型来测量打印机的振铃频率。

将振纹测试模型切片，该模型可以在[docs/prints/ringing_tower.stl](prints/ringing_tower.stl)中找到，在切片软件中：

* 建议将层高为 0.2 或 0.25 毫米。
* 填充和顶层层数可以被设置为0。
* 使用1-2圈壁，使用1-2毫米厚底坐和花瓶模式(vasemode)的效果更好。
* 使用足够高的速度，大约80-100毫米/秒，用于**外部**周长（壁）。
* 确保最短的层耗时**最多是**3秒。
* 确保切片软件中禁用任何"动态加速度控制"功能。
* 不要转动模型。模型的背面标记了X和Y。注意这些标记与打印机轴线方向不相同--这不是一个错误。这些标记可以在以后的调整过程中作为参考，因为它们显示了测量结果对应的轴。

### 振纹频率

首先，测量**振纹频率**。

1. 如果“square_corner_velocity”参数已更改，请将其恢复到5.0。当使用输入整形器时，不建议增加它，因为它会导致零件更加平滑——最好使用更高的加速度值。
1. Increase `max_accel_to_decel` by issuing the following command: `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. Disable Pressure Advance: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. 如果你已经将`[input_shaper]`分段添加到print.cfg中，执行`SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0`命令。如果你得到"未知命令"错误，此时你可以安全地忽略它，继续进行测量。
1. Execute the command: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5` Basically, we try to make ringing more pronounced by setting different large values for acceleration. This command will increase the acceleration every 5 mm starting from 1500 mm/sec^2: 1500 mm/sec^2, 2000 mm/sec^2, 2500 mm/sec^2 and so forth up until 7000 mm/sec^2 at the last band.
1. 打印用建议的参数切片的测试模型。
1. 如果振纹清晰可见，并且发现加速度对你的打印机来说太高了（如打印机抖动太厉害或开始丢步），你可以提前停止打印。

   1. 使用模型后侧的XY标志作为校准的参考。X标志所在一侧的测量结果用于X轴的*配置*，而Y标志所在一侧则作为Y轴的配置。以X轴为例，测量X标志所在一侧的数个振纹周期的长度*D*（单位mm）：首先确定凹槽的位置，为了测量准确可以忽略最靠近凹槽的数个纹路，用记号笔标记起始和结束的数个振纹，然后用尺子或卡尺进行测量：|![标记振纹（Mark ringing）](img/ringing-mark.jpg)|![Measure ringing](img/ringing-measure.jpg)|
1. 数一数测量的距离*D*中有多少个振荡*D*。如果你不确定如何计算振荡，请参考上图，其中显示*N*=6次振荡。
1. 通过 *V* &middot; *N* / *D* (Hz) 计算振铃的频率，其中*V* 是外壁的加速度（mm/秒）。在上述例子中，我们标记了6个振纹，同时测试件是以100 mm/秒的速度进行印制，因此振动频率为100 * 6 / 12.14 ≈ 49.4 Hz。
1. Do (8) - (10) for Y mark as well.

请注意，测试打印件上的振纹应遵循弧形凹槽的模式，如上图所示。如果不是这样，那么这个缺陷就不是真正的振纹，而是有不同的原因--要么是机械问题，要么是挤出机问题。在启用和调整输入整形器之前，应该先解决这个问题。

如果打印机存在多个共振频率，那么测量的结果将变得不可靠，表现为振纹之间的距离不恒定。我们可以通过 [修正不可靠的共振频率测量（Unreliable measurements of ringing frequencies）](#unreliable-measurements-of-ringing-frequencies)章节的步骤进行修正，以发挥输入整形的效用。

振铃频率会基于工件在床上的位置和打印的Z高度而变化，这种情况在*三角洲打印机上*特为显著；我们可以通过检查工件的不同位置和高度上的振纹是否出现显著变化而确定。如果出现上述状况，可以通过计算不同位置的振铃频率，并基于x轴和y轴计算平均值。

如果测量到的振铃频率非常低（约低于20-25 Hz），则建议根据应用的目的，在进行进一步输入整形调试前，提高打印机框架的刚性，或减少动部件的质量。对大多主流打印机而言，上述改造的方式可简单搜索获得。

请注意，如果对打印机进行了改动，改变了移动质量或系统的刚度，共振（振纹）频率会发生变化。例如：

* 安装、移除、更换了一些在打印头上的工具，从而改变了其质量，例如，为近程挤出机更换一个新的（更重或更轻的）步进电机，或安装一个新的热端，增加一个带风道的重型风扇，等等。
* 同步带被拉紧。
* 安装了一些增加框架刚性的配件。
* 对平移热床式打印机而言，使用了不同的热床面板，或者加装了玻璃面板等操作。

如果进行了此类更改，则最好至少测量共振（振纹）频率以查看它们是否发生变化。

### 输入整形器配置

测量 X 和 Y 轴的共振频率后，您可以将以下分段中添加到 `printer.cfg`：

```
[input_shaper]
shaper_freq_x: ...  # frequency for the X mark of the test model
shaper_freq_y: ...  # frequency for the Y mark of the test model
```

对于上述例子，我们得到 shaper_freq_x/y = 49.4。

### 选择输入整形器

Klipper支持数种输入整形器。这些整形器之间的差异在于它们容许的共振频率测量误差和它们在打印件中产生的平滑度。请注意，一些整形器，例如2HUMP_EI和3HUMP_EI，不应与shaper_freq = 共振频率一起使用。它们应该被配置为同时减少多个不同的频率。

对于大多数打印机，推荐 MZV 或E I整形器。章节介绍了在它们之间进行选择，并找出其他一些相关参数的测试过程。

Print the ringing test model as follows:

1. Restart the firmware: `RESTART`
1. Prepare for test: `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. Disable Pressure Advance: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Execute: `SET_INPUT_SHAPER SHAPER_TYPE=MZV`
1. Execute the command: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`
1. 打印用建议的参数切片的测试模型。

如果你在这个位置没有看到振铃，那么推荐使用 MZV 整形器。

如果你确实看到一些振纹，使用[频率](#共振频率)部分描述的步骤(8)-(10)重新测量频率。如果频率与你之前得到的值有很大的不同，就需要一个更复杂的输入整形器配置。你可以参考[输入整形器](#input-shapers)部分的技术细节。否则，进入下一步：

Now try EI input shaper. To try it, repeat steps (1)-(6) from above, but executing at step 4 the following command instead: `SET_INPUT_SHAPER SHAPER_TYPE=EI`.

用MZV和EI输入整形器比较两个打印件。如果EI的结果明显好于MZV，则使用EI整形器，否则最好使用MZV。请注意，EI整形器将使打印件更加平滑（进一步的细节见下一节）。在[input_shaper]分段中添加`shaper_type: mzv`（或EI）参数，例如：

```
[input_shaper]
shaper_freq_x: ...
shaper_freq_y: ...
shaper_type: mzv
```

关于整形器选择的一些注意事项：

* EI 整形器可能更适用于平移热床的打印机（如果共振频率和由此产生的平滑度允许）：随着更多的耗材被打印到在移动的打印床上，床的质量增加，造成共振频率降低。由于 EI 整形器对共振频率的变化更为稳健，在打印大型部件时可能效果更好。
* 由于三角洲运动学的性质，共振频率在可打印范围内不同位置会有很大的不同。因此，EI整形器可以更好地适用于三角洲打印机，而不是MZV或ZV，应该考虑使用。如果共振频率足够大（超过50-60赫兹），那么甚至可以尝试测试2HUMP_EI整形器（通过运行上面建议的测试`SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI`），但在启用之前要检查[下面的章节](#selecting-max_accel)的注意事项。

### 选择 max_accel

You should have a printed test for the shaper you chose from the previous step (if you don't, print the test model sliced with the [suggested parameters](#tuning) with the pressure advance disabled `SET_PRESSURE_ADVANCE ADVANCE=0` and with the tuning tower enabled as `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`). Note that at very high accelerations, depending on the resonance frequency and the input shaper you chose (e.g. EI shaper creates more smoothing than MZV), input shaping may cause too much smoothing and rounding of the parts. So, max_accel should be chosen such as to prevent that. Another parameter that can impact smoothing is `square_corner_velocity`, so it is not advisable to increase it above the default 5 mm/sec to prevent increased smoothing.

为了选择合适的 max_accel 值，请检查使用所选输入整形器打印的模型。首先，记下加速度振纹仍然很小的位置—一个满意的高度。

接下来，检查平滑度。为了帮助做到这一点，测试模型的壁上有一个小缺口（0.15毫米）：

![测试间隙](img/smoothing-test.png)

随着加速度的增加，平滑度会同时增加，而打印件上的裂缝也会扩大：

![整形器平滑](img/shaper-smoothing.jpg)

在这张图中，加速度从左到右增加，裂缝从3500mm/s^2开始变宽（从左边开始数第5条条纹）。因此，在这种情况下，max_accel=3000（mm/sec^2）是一个可以避免过度平滑的值。

请注意记录下测试打印中的裂缝仍然非常小时的加速度。如果您看到凸起，但即使在高加速度下，壁上根本没有裂缝，可能是由于禁用了压力提前，特别是在远程挤出机上。如果是这种情况，您可能需要在启用压力提前的情况下重复打印。它也可能是由于校准错误（太高）的耗材流量造成的，因此最好也检查一下。

Choose the minimum out of the two acceleration values (from ringing and smoothing), and put it as `max_accel` into printer.cfg.

值得注意的，特别是在低振铃频率下，EI整形器甚至在较低的加速度下也会造成过多的平滑。在这种情况下，MZV 可能是更好的选择，因为它可能允许更高的加速度值。

在非常低的共振频率（大约25Hz及以下），即使是MZV整形器也可能产生过多的平滑。如果遇到这种情况，可以尝试用 ZV 整形器重复[选择输入整形器](#choosing-input-shaper)章节中的步骤，用`SET_INPUT_SHAPER SHAPER_TYPE=ZV` 命令代替。ZV整形器应该产生比MZV更少的平滑，但对测量共振频率中的误差更敏感。

另一个需要考虑的因素是，如果共振频率过低（低于20-25 Hz），则最好增加打印机的刚度或减少运动质量。否则，加速度和打印速度可能会受到过多的平滑限制而非共振。

### 微调共振频率

请注意，使用共振测试模型进行的共振频率测量的精度通常足够用于大多数目的，因此不建议进一步调整。如果您仍然想尝试再次检查您的结果（例如，如果您在打印与您之前测量的频率相同的输入整形器的测试模型后仍然看到某些振纹），您可以按照本节中的步骤操作。请注意，如果您在启用[input_shaper]后看到不同频率的振纹，本节将无法解决这个问题。

Assuming that you have sliced the ringing model with suggested parameters, complete the following steps for each of the axes X and Y:

1. Prepare for test: `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. Make sure Pressure Advance is disabled: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Execute: `SET_INPUT_SHAPER SHAPER_TYPE=ZV`
1. From the existing ringing test model with your chosen input shaper select the acceleration that shows ringing sufficiently well, and set it with: `SET_VELOCITY_LIMIT ACCEL=...`
1. 计算`TUNING_TOWER`命令所需的参数，以调整`shaper_freq_x`参数，如下：start = shaper_freq_x * 83 / 132 和 factor = shaper_freq_x / 66，其中`shaper_freq_x`是`printer.cfg`中的当前值。
1. Execute the command: `TUNING_TOWER COMMAND=SET_INPUT_SHAPER PARAMETER=SHAPER_FREQ_X START=start FACTOR=factor BAND=5` using `start` and `factor` values calculated at step (5).
1. 打印测试模型。
1. 重置原始频率值：`SET_INPUT_SHAPER SHAPER_FREQ_X=...`。
1. 找到振纹最少的条带，并从底部从1开始数它的高度。
1. 通过旧的 shaper_freq_x * (39 + 5 * #条带高度) / 66 计算新的 shaper_freq_x 值。

以相同的方式重复这些步骤，用Y轴替换X轴（例如，在公式和`TUNING_TOWER`命令中，用`shaper_freq_y`替换`shaper_freq_x`）。

假设你已测得其中一个轴的共振频率等于45 Hz。这给出了 `TUNING_TOWER` 命令的 start = 45 * 83 / 132 = 28.30 和 factor = 45 / 66 = 0.6818 值。现在，假设在打印测试模型后，从底部数起的第四个条带的振纹最少。这给出了更新后的 shaper_freq_? 值等于 45 * (39 + 5 * 4) / 66 ≈ 40.23。

在新的 `shaper_freq_x` 和 `shaper_freq_y` 参数计算完成后，你可以在 `printer.cfg` 的 `[input_shaper]` 分段中用新的 `shaper_freq_x` 和 `shaper_freq_y` 值更新。

### 压力提前

If you use Pressure Advance, it may need to be re-tuned. Follow the [instructions](Pressure_Advance.md#tuning-pressure-advance) to find the new value, if it differs from the previous one. Make sure to restart Klipper before tuning Pressure Advance.

### 不可靠的共振频率测量结果

如果你无法测量共振频率，例如，如果振荡之间的距离不稳定，你仍然可以利用输入整形技术，但结果可能不如使用频率的正确测量那样好，并且需要更多的调整和打印测试模型。注意，另一种可能的解决方法是购买并安装加速度计，并用它来测量共振（参考[文档](Measuring_Resonances.md)描述所需的硬件和设置过程）- 但这个选项需要压接和焊接一些连接器。

For tuning, add empty `[input_shaper]` section to your `printer.cfg`. Then, assuming that you have sliced the ringing model with suggested parameters, print the test model 3 times as follows. First time, prior to printing, run

1. `RESTART`
1. `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. `SET_PRESSURE_ADVANCE ADVANCE=0`
1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=60 SHAPER_FREQ_Y=60`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

然后打印模型。再次打印模型，但在打印之前运行

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=50 SHAPER_FREQ_Y=50`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

然后第三次打印模型，但是现在运行

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=40 SHAPER_FREQ_Y=40`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

本质上，我们正在使用 TUNING_TOWER 打印振纹测试模型，并使用 2HUMP_EI 整形器，整形器频率为60 Hz、50 Hz和40 Hz。

如果所有模型都没有在振纹方面显示出改进，那么很不幸，看起来输入整形技术无法帮助你的情况。

否则，可能所有模型都没有振纹，或者有些模型振纹，有些则没有那么明显。选择在振纹方面仍然表现出良好改进且频率最高的测试模型。例如，如果40 Hz和50 Hz的模型几乎没有振纹，而60 Hz的模型已经显示出更多的振纹，那么应当使用50 Hz。

现在检查EI整形器是否在您的情况下足够好。根据您选择的 2HUMP_EI 整形器的频率来选择 EI 整形器的频率：

* 对于2HUMP_EI整形器是 60 Hz 的，使用shaper_freq = 50 Hz的EI整形器。
* 对于2HUMP_EI整形器是 50 Hz 的，使用shaper_freq = 40 Hz的EI整形器。
* 对于2HUMP_EI整形器是 40 Hz 的，使用shaper_freq = 33 Hz的EI整形器。

现在再次打印测试模型，运行

1. `SET_INPUT_SHAPER SHAPER_TYPE=EI SHAPER_FREQ_X=... SHAPER_FREQ_Y=...`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

提供之前确定的shaper_freq_x=... 和 shaper_freq_y=...。

如果EI整形器显示的结果与2HUMP_EI整形器非常相似且很好，那么坚持使用EI整形器和之前确定的频率，否则使用相应频率的2HUMP_EI整形器。将结果添加到`printer.cfg`中，例如：

```
[input_shaper]
shaper_freq_x: 50
shaper_freq_y: 50
shaper_type: 2hump_ei
```

继续使用[选择最大加速度（Selecting max_accel）](#selecting-max_accel)章节进行调整。

## 故障排除和常见问题解答

### 我无法可靠地测量共振频率

首先，请确保不是打印机的其他问题而是共振。如果测量结果不可靠，可能是因为振荡之间的距离不稳定，可能是打印机在同一轴上具有多个共振频率。可以尝试按照[不可靠的共振频率测量](#不可靠的共振频率测量)章节所述的调整过程，仍然可以从输入整形技术中获益。另一个可能性是安装加速度计，[使用其测量](Measuring_Resonances.md)共振，并使用这些测量结果自动调整输入整形器。

### After enabling [input_shaper], I get too smoothed printed parts and fine details are lost

Check the considerations in [Selecting max_accel](#selecting-max_accel) section. If the resonance frequency is low, one should not set too high max_accel or increase square_corner_velocity parameters. It might also be better to choose MZV or even ZV input shapers over EI (or 2HUMP_EI and 3HUMP_EI shapers).

### After successfully printing for some time without ringing, it appears to come back

It is possible that after some time the resonance frequencies have changed. E.g. maybe the belts tension has changed (belts got more loose), etc. It is a good idea to check and re-measure the ringing frequencies as described in [Ringing frequency](#ringing-frequency) section and update your config file if necessary.

### Is dual carriage setup supported with input shapers?

There is no dedicated support for dual carriages with input shapers, but it does not mean this setup will not work. One should run the tuning twice for each of the carriages, and calculate the ringing frequencies for X and Y axes for each of the carriages independently. Then put the values for carriage 0 into [input_shaper] section, and change the values on the fly when changing carriages, e.g. as a part of some macro:

```
SET_DUAL_CARRIAGE CARRIAGE=1
SET_INPUT_SHAPER SHAPER_FREQ_X=... SHAPER_FREQ_Y=...
```

And similarly when switching back to carriage 0.

### Does input_shaper affect print time?

No, `input_shaper` feature has pretty much no impact on the print times by itself. However, the value of `max_accel` certainly does (tuning of this parameter described in [this section](#selecting-max_accel)).

## Technical details

### Input shapers

Input shapers used in Klipper are rather standard, and one can find more in-depth overview in the articles describing the corresponding shapers. This section contains a brief overview of some technical aspects of the supported input shapers. The table below shows some (usually approximate) parameters of each shaper.

| Input <br> shaper | Shaper <br> duration | Vibration reduction 20x <br> (5% vibration tolerance) | Vibration reduction 10x <br> (10% vibration tolerance) |
| :-: | :-: | :-: | :-: |
| ZV | 0.5 / shaper_freq | N/A | ± 5% shaper_freq |
| MZV | 0.75 / shaper_freq | ± 4% shaper_freq | -10%...+15% shaper_freq |
| ZVD | 1 / shaper_freq | ± 15% shaper_freq | ± 22% shaper_freq |
| EI | 1 / shaper_freq | ± 20% shaper_freq | ± 25% shaper_freq |
| 2HUMP_EI | 1.5 / shaper_freq | ± 35% shaper_freq | ± 40 shaper_freq |
| 3HUMP_EI | 2 / shaper_freq | -45...+50% shaper_freq | -50%...+55% shaper_freq |

A note on vibration reduction: the values in the table above are approximate. If the damping ratio of the printer is known for each axis, the shaper can be configured more precisely and it will then reduce the resonances in a bit wider range of frequencies. However, the damping ratio is usually unknown and is hard to estimate without a special equipment, so Klipper uses 0.1 value by default, which is a good all-round value. The frequency ranges in the table cover a number of different possible damping ratios around that value (approx. from 0.05 to 0.2).

Also note that EI, 2HUMP_EI, and 3HUMP_EI are tuned to reduce vibrations to 5%, so the values for 10% vibration tolerance are provided only for the reference.

**How to use this table:**

* “Shaper”持续时间会影响零件的平滑度——它越大，零件就越平滑。这种依赖性不是线性的，但可以让人感觉到哪些整形器在相同频率下更“平滑”。平滑排序如下：ZV<MZV<ZVD≈EI<2HUMP_EI<3HUMP_EI。此外，为整形器2HUMP_EI和3HUMP_EI设置shapper_freq＝谐振频率是不实际的（它们应该用于减少几个频率的振动）。
* 可以估计整形器减少振动的频率范围。例如，shapper_freq=35Hz的MZV将频率[33.6,36.4]Hz的振动降低到5%。shaper_freq=50 Hz的3HUMP_EI将[27.5，75]Hz范围内的振动降低到5%。
* 如果需要减少几个频率的振动，可以使用此表来检查应该使用哪个整形器。例如，如果在同一轴上有35Hz和60Hz的谐振：a）EI整形器需要shapper_freq=35/（1-0.2）=43.75Hz，并且它将减小谐振直到43.75*（1+0.2）=52.5Hz，所以这是不够的；b） 2HUMP_EI整形器需要shapper_freq=35/（1-0.35）=53.85 Hz，并且将减小振动直到53.85*（1+0.35）=72.7 Hz，因此这是可接受的配置。对于给定的整形器，始终尝试使用尽可能高的shapper_freq（可能有一些安全裕度，因此在本例中，shapper_freq≈50-52 Hz最有效），并尝试使用整形器持续时间尽可能短的整形器。
* 如果需要减少几个非常不同频率（例如，30Hz和100Hz）的振动，他们可能会发现上表没有提供足够的信息。在这种情况下，使用[scripts/graph_shaper.py]（../scripts/graph_sShaper.py）脚本可能会更幸运，因为它更灵活。
