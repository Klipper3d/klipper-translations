# 压力提前

本文档提供了关于调整特定喷嘴和耗材“压力提前”配置变量的方法。压力提前功能可以减少漏料。关于如何实现压力提前的更多信息，见[运动学](Kinematics.md)文件。

## 调整压力提前

压力提前有两个作用 - 它可以减少非挤出移动过程中的溢料和减少转弯时的凸起。本指南使用第二个功能（减少转弯过程中的凸起）作为优化机制。

为了校准压力提前，打印机必须已经配置完成并可以正常工作。因为调优测试涉及打印和检查测试对象。在运行测试之前，最好完整阅读本文档。

Use a slicer to generate g-code for the large hollow square found in [docs/prints/square_tower.stl](prints/square_tower.stl). Use a high speed (eg, 100mm/s), zero infill, and a coarse layer height (the layer height should be around 75% of the nozzle diameter). Make sure any "dynamic acceleration control" and "scarf joint" seams are disabled in the slicer.

在打印G-Code前输入下面的命令：

```
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
```

上述命令将使喷嘴在打印转角时减速，从而显著增加转角时挤出的压力。接着，如果您使用的是近程挤出结构，请输入下面的命令：

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

使用远程挤出的话，则输入：

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020
```

接着，开始打印。打印后的测试模型将如下图：

![测试塔](img/tuning_tower.jpg)

上面的调试塔（TUNING_TOWER）G-Code将会使Klipper在打印每一层时逐渐改变压力提前（pressure_advance）的设定值。打印的高度越高，压力提前的设置值越大。在理想的压力提前设定值以下的层，将会在转角出现过度挤出，出现塑料团块；而在理想值之上的层则会出现挤出不足，乃至转角缺失。

您可以在转角出现严重缺失的时候停止打印作业（从而避免继续测试不合理的压力提前设定值）。

观察打印件，然后用游标卡尺量度转角质量最佳的层对应的高度。如果不能确定哪里最佳，请优先选择较小的高度。

![对高度进行测量](img/tune_pa.jpg)

压力提前的设定值可以通过`pressure_advance = <start> + <measured_height> * <factor>`进行计算，如测出的最优层高（measured_height）为12.9 mm，测试起始点（start）为0 mm，增量（factor）为0.02，则计算结果为（ `0 + 12.90 *.020=0.258`。）

为获得最佳的压力提前设定值，您可以自定义 起始高度（START）和增量（FACTOR）。切记在开始打印前通过调试塔（TUNING_TOWER）命令设置测试值。

典型压力提前的设置值在0.050到1.000之间（较大数值的一则一般出现在远程挤出结构上）。如果压力提前设置值大于1.000而打印质量没有改善，则应考虑关闭压力提前以避免其他打印问题。

调试压力提前值不单单直接改善转角处的打印质量，同时也有利于减少打印中的溢料/过度挤出现象。

完成测试后，在配置中的`[extruder]`节中加入`pressure_advance = <calculated_value>`（其中`calculated_value`为前述测试计算出的数值），保存并使用 RESTART 命令重启Klipper以应用配置。同时RESTART会重置转角速度设置并取消压力提前值的逐层变化的设置。

## 重要提示

* 压力提前的设置值与挤出结构，喷嘴和耗材息息相关。对于不同厂商的耗材，或同一厂商的不同颜色/批次的耗材都会出现压力提前值显著不同的状况。因此，建议在更换耗材后重新校准压力提前值。
* 打印温度和打印速度会显著影响压力提前设置。因此请确保在完成[挤出距离校准（extruder rotation_distance）](Rotation_Distance.md#calibrating-rotation_distance-on-extruders) 和 [喷嘴温度校准（nozzle temperature）](http://reprap.org/wiki/Triffid_Hunter%27s_Calibration_Guide#Nozzle_Temperature)后进行压力提前校准。
* 测试模型被设计用于高挤出量下的测试，而非使用“常规”的切片设置。大挤出量能通过使用高打印速度获得（如100 mm/s）和高层高（典型值为75%的喷嘴直径）。其他切片设置可使用常规数值（如使用2~3壁厚，常规的回抽值）。推荐将外壁打印速度设置成与中间层相同，尽管这样设置并非必要。
* 测试件的四角出现质量不一的情况非常常见。这是因为通常切片软件会将变层的动作安排在转角上，这将使变层所在的转角与其他三个显著不同。如果出现这种现象，可以忽略变层所在的转角而测量其他三个。同时其他三个转角也可能存在轻微的差异（而这种差异往往来源于打印机框架对不同转角运动出现不同的响应）。推荐尝试使用令三个转角同时获得较高质量的设定值。如果举棋不定，建议使用较低的压力提前设定值。
* 若设置了一个较高的压力提前设置值，一般为大于0.200，在正常加速度下工作，挤出机可能出现丢步/跳步现象。压力提前系统是通过在加速时挤出更多的耗材，减速时通过回抽减少挤出量来控制喷嘴压力。在使用高加速度和高压力提前设置值下，挤出机或许不能提供足够的扭矩以挤出耗材。如果出现上述状况，建议降低加速度或停用压力提前。
* 当完成了Klipper的压力提前设置后，推荐在切片时适当减少回抽距离（如0.75 mm）并开启“回抽期间进行擦嘴”的设置。该设置可以应对耗材粘连造成的溢料（喷嘴内的耗材因塑料的粘性被挤出的耗材抽出）。同时建议关闭切片软件中的“回抽时抬嘴”功能。
* 压力提前系统将不会改变滑车运行的时间点和路径。因此使用压力提前进行打印的工件会跟不使用压力提前的工件消耗同样的打印时间。压力提前也不会增加或减少工件打印所需的耗材量。压力提前只会影响挤出机加减速时的运动行为。高压力提前设置值会使挤出机加减速时出现非常大的挤出机运动量。暂时，Klipper配置文件中没有任何设置对压力提前的额外挤出机运动进行设限。
