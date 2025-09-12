# Delta校准

本文档描述了Klipper为“Delta”类型打印机提供的自动校准系统。

Delta校准涉及确定塔柱限位开关的位置、塔柱角度、Delta半径以及连杆臂长度。这些参数控制着Delta打印机的运动。每个参数都会以非直观且非线性的方式产生影响，因此手动校准非常困难。相比之下，软件校准代码只需几分钟即可提供出色的结果，且无需特殊的探针硬件。

最终，Delta校准的精度依赖于塔柱限位开关的精度。如果使用Trinamic步进电机驱动器，请考虑启用[限位相位](Endstop_Phase.md)检测功能，以提高这些开关的准确性。

## 自动与手动探针

Klipper支持通过手动探针方法或自动Z探针来校准Delta参数。

许多Delta打印机套件配备的自动Z探针并不足够精确（具体来说，连杆臂长度的微小差异可能导致动平台倾斜，从而影响自动探针的准确性）。如果使用自动探针，请先[校准探针](Probe_Calibrate.md)，然后检查[探针位置偏差](Probe_Calibrate.md#location-bias-check)。如果自动探针的偏差超过25微米（0.025毫米），则应改用手动探针。手动探针只需几分钟，且能消除探针引入的误差。

如果探针安装在热端侧面（即具有X或Y偏移），请注意执行Delta校准会使得之前的探针校准结果失效。这类探针通常不太适合用于Delta打印机（因为动平台的轻微倾斜会导致探针位置偏差）。如果仍要使用此类探针，则在任何Delta校准后务必重新运行探针校准。

## 基础Delta校准

Klipper提供了`DELTA_CALIBRATE`命令，可用于执行基础Delta校准。该命令会探测打印平台上的七个不同点，并计算塔柱角度、塔柱限位开关位置和Delta半径的新值。

要执行此校准，必须提供初始的Delta参数（连杆臂长度、半径和限位开关位置），且这些参数的精度应在几毫米以内。大多数Delta打印机套件都会提供这些参数——使用这些初始默认值配置打印机，然后按照下文所述运行`DELTA_CALIBRATE`命令。如果没有可用的默认值，请在线搜索Delta校准指南，以获取基本的起始点。

在校准过程中，打印机可能需要探测到通常认为的平台平面以下的位置。通常可以通过更新配置文件，将打印机的`minimum_z_position=-5`来允许此操作。（校准完成后，可以从配置中移除此设置。）

有两种方式进行探测——手动探测（`DELTA_CALIBRATE METHOD=manual`）和自动探测（`DELTA_CALIBRATE`）。手动探测方法会将打印头移动到靠近平台的位置，然后等待用户按照["纸张测试"](Bed_Level.md#the-paper-test)中的步骤，确定喷嘴与平台在该位置的实际距离。

要执行基础校准，请确保配置文件中已定义了[delta_calibrate]部分，然后运行以下命令：
```
G28
DELTA_CALIBRATE METHOD=manual
```
探测七个点后，将计算出新的Delta参数。通过运行以下命令保存并应用这些参数：
```
SAVE_CONFIG
```

基础校准应能提供足够精确的Delta参数，以满足基本打印需求。如果是新打印机，此时可以打印一些基本物体，验证整体功能。

## 增强型Delta校准

基础Delta校准通常能很好地计算出使喷嘴与平台保持正确距离的Delta参数。但它不会尝试校准X和Y方向的尺寸精度。建议执行增强型Delta校准以验证尺寸精度。

此校准过程需要打印一个测试物体，并使用数字卡尺测量该物体的某些部分。

在执行增强型Delta校准之前，必须先运行基础Delta校准（通过`DELTA_CALIBRATE`命令）并保存结果（通过`SAVE_CONFIG`命令）。确保自上次基础Delta校准以来，打印机的配置或硬件没有发生明显变化（如果不确定，请在打印下文所述的测试物体之前，重新运行[基础Delta校准](#basic-delta-calibration)，包括`SAVE_CONFIG`）。

使用切片软件从[docs/prints/calibrate_size.stl](prints/calibrate_size.stl)文件生成G代码。以较慢的速度（例如40mm/s）切片该物体。如果可能，请使用刚性较强的塑料（如PLA）。该物体的直径为140mm。如果这对打印机来说太大，可以将其缩小（但务必均匀缩放X和Y轴）。如果打印机支持更大的打印尺寸，也可以增大该物体的尺寸。更大的尺寸可以提高测量精度，但良好的打印附着力比更大的打印尺寸更重要。

打印测试物体并等待其完全冷却。下文所述的命令必须使用与打印校准物体时相同的打印机设置运行（在打印和测量之间不要运行`DELTA_CALIBRATE`，或进行任何会改变打印机配置的操作）。

如果可能，请在物体仍附着在打印平台时进行下文所述的测量，但如果部件从平台上脱落也不必担心——只需在测量时尽量避免弯曲物体即可。

首先，测量中心支柱与标有“A”标签的支柱之间的距离（该标签也应指向“A”塔柱）。

[delta-a-distance](img/delta-a-distance.jpg)

然后逆时针方向，测量中心支柱与其他支柱之间的距离（中心到“C”标签对面的支柱的距离，中心到“B”标签支柱的距离，等等）。

[delta_cal_e_step1](img/delta_cal_e_step1.png)

将这些参数以逗号分隔的浮点数列表形式输入Klipper：
```
DELTA_ANALYZE CENTER_DISTS=<a_dist>,<far_c_dist>,<b_dist>,<far_a_dist>,<c_dist>,<far_b_dist>
```
输入值时不要在它们之间加空格。

然后测量“A”支柱与“C”标签对面的支柱之间的距离。

[delta-ab-distance](img/delta-outer-distance.jpg)

然后逆时针方向，测量“C”对面的支柱到“B”支柱的距离，“B”支柱到“A”对面的支柱的距离，依此类推。

[delta_cal_e_step2](img/delta_cal_e_step2.png)

将这些参数输入Klipper：
```
DELTA_ANALYZE OUTER_DISTS=<a_to_far_c>,<far_c_to_b>,<b_to_far_a>,<far_a_to_c>,<c_to_far_b>,<far_b_to_a>
```

此时可以将物体从平台上取下。最后的测量对象是支柱本身。沿“A”辐条方向测量中心支柱的尺寸，然后是“B”辐条，最后是“C”辐条。

[delta-a-pillar](img/delta-a-pillar.jpg)

[delta_cal_e_step3](img/delta_cal_e_step3.png)

将它们输入Klipper：
```
DELTA_ANALYZE CENTER_PILLAR_WIDTHS=<a>,<b>,<c>
```

最后测量外侧支柱。首先沿从“A”到“C”对面支柱的连线方向测量“A”支柱的尺寸。

[delta-ab-pillar](img/delta-outer-pillar.jpg)

然后逆时针方向测量其余外侧支柱（“C”对面的支柱沿到“B”的连线方向，“B”支柱沿到“A”对面支柱的连线方向，等等）。

[delta_cal_e_step4](img/delta_cal_e_step4.png)

并将它们输入Klipper：
```
DELTA_ANALYZE OUTER_PILLAR_WIDTHS=<a>,<far_c>,<b>,<far_a>,<c>,<far_b>
```

如果物体被缩放到更小或更大的尺寸，请提供切片时使用的缩放比例：
```
DELTA_ANALYZE SCALE=1.0
```
（缩放值2.0表示物体是原始尺寸的两倍，0.5表示是原始尺寸的一半。）

最后，通过运行以下命令执行增强型Delta校准：
```
DELTA_ANALYZE CALIBRATE=extended
```
此命令可能需要几分钟才能完成。完成后，它将计算更新的Delta参数（Delta半径、塔柱角度、限位开关位置和连杆臂长度）。使用`SAVE_CONFIG`命令保存并应用这些设置：
```
SAVE_CONFIG
```

`SAVE_CONFIG`命令将同时保存更新的Delta参数和距离测量信息。未来的`DELTA_CALIBRATE`命令也将使用此距离信息。请不要在运行`SAVE_CONFIG`后尝试重新输入原始距离测量值，因为此命令会更改打印机配置，原始测量值将不再适用。

### 其他注意事项

* 如果Delta打印机具有良好的尺寸精度，则任意两个支柱之间的距离应约为74mm，每个支柱的宽度应约为9mm。（具体来说，目标是任意两个支柱之间的距离减去其中一个支柱的宽度恰好为65mm。）如果零件存在尺寸不准确的情况，`DELTA_ANALYZE`程序将结合距离测量值和上次`DELTA_CALIBRATE`命令的高度测量值，计算出新的Delta参数。

* `DELTA_ANALYZE`可能会产生令人惊讶的Delta参数。例如，它建议的连杆臂长度可能与打印机的实际连杆臂长度不匹配。尽管如此，测试表明`DELTA_ANALYZE`通常能产生更优的结果。据信，计算出的Delta参数能够补偿硬件其他部分的微小误差。例如，连杆臂长度的微小差异可能导致动平台倾斜，而通过调整连杆臂长度参数可以部分补偿这种倾斜。

## 在Delta打印机上使用床网（Bed Mesh）

可以在Delta打印机上使用[床网](Bed_Mesh.md)。但在启用床网之前，必须先获得良好的Delta校准。在Delta校准不佳的情况下运行床网会产生混乱且效果差的结果。

请注意，执行Delta校准会使之前获得的任何床网数据失效。在执行新的Delta校准后，务必重新运行`BED_MESH_CALIBRATE`。