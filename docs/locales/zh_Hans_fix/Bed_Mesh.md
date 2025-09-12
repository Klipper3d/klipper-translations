# 床网校准 (Bed Mesh)

床网校准（Bed Mesh）模块可用于补偿打印床表面的不平整，从而在整个打印床上实现更好的第一层效果。需要注意的是，基于软件的校正无法达到完美的效果，它只能近似模拟打印床的形状。床网校准也无法补偿机械或电气问题。如果某个轴歪斜或探针不准确，那么床网校准模块将无法从探测过程中获得准确的结果。

在进行网格校准之前，您需要确保探针的Z偏移量已校准。如果使用限位开关进行Z轴归零，则也需要对其进行校准。有关更多信息，请参阅[探针校准](Probe_Calibrate.md)和[手动调平](Manual_Level.md)中的Z_ENDSTOP_CALIBRATE。

## 基本配置

### 矩形打印床
此示例假设一台打印机具有250毫米 x 220毫米的矩形打印床，探针的X偏移量为24毫米，Y偏移量为5毫米。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `speed: 120`\
  _默认值: 50_\
  工具在各点之间移动的速度。

- `horizontal_move_z: 5`\
  _默认值: 5_\
  探针在各点之间移动前上升到的Z坐标。

- `mesh_min: 35, 6`\
  _必需_\
  第一个探测坐标，最靠近原点。该坐标相对于探针的位置。

- `mesh_max: 240, 198`\
  _必需_\
  距离原点最远的探测坐标。这不一定是最后一个探测点，因为探测过程以之字形方式进行。与`mesh_min`一样，该坐标相对于探针的位置。

- `probe_count: 5, 3`\
  _默认值: 3, 3_\
  每个轴上要探测的点数，指定为X、Y整数值。在此示例中，X轴上将探测5个点，Y轴上探测3个点，总共15个探测点。请注意，如果您想要一个方形网格，例如3x3，可以指定为单个整数值，用于两个轴，即`probe_count: 3`。请注意，网格要求每个轴上的最小探测点数为3。

下图说明了`mesh_min`、`mesh_max`和`probe_count`选项如何用于生成探测点。箭头表示探测过程的方向，从`mesh_min`开始。作为参考，当探针位于`mesh_min`时，喷嘴将位于(11, 1)，当探针位于`mesh_max`时，喷嘴将位于(206, 193)。

[bedmesh_rect_basic](img/bedmesh_rect_basic.svg)

### 圆形打印床
此示例假设一台打印机配备半径为100毫米的圆形打印床。我们将使用与矩形示例相同的探针偏移量，X轴24毫米，Y轴5毫米。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius: 75`\
  _必需_\
  探测网格的半径（毫米），相对于`mesh_origin`。请注意，探针的偏移量限制了网格半径的大小。在此示例中，半径大于76将使工具超出打印机的范围。

- `mesh_origin: 0, 0`\
  _默认值: 0, 0_\
  网格的中心点。该坐标相对于探针的位置。虽然默认值是0, 0，但调整原点可能有助于探测打印床的更大区域。见下图。

- `round_probe_count: 5`\
  _默认值: 5_\
  这是一个整数值，定义X轴和Y轴上探测点的最大数量。所谓“最大”，是指沿网格原点探测的点数。此值必须为奇数，因为要求探测网格的中心。

下图显示了探测点是如何生成的。如您所见，将`mesh_origin`设置为(-10, 0)允许我们指定更大的网格半径85。

[bedmesh_round_basic](img/bedmesh_round_basic.svg)

## 高级配置

以下详细解释了更高级的配置选项。每个示例都基于上面显示的基本矩形打印床配置。所有高级选项同样适用于圆形打印床。

### 网格插值

虽然可以直接使用简单的双线性插值对探测矩阵进行采样，以确定探测点之间的Z值，但通常使用更高级的插值算法来插值额外的点，以增加网格密度。这些算法为网格添加曲率，试图模拟打印床的材料特性。床网校准提供拉格朗日和双三次插值来实现这一点。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
mesh_pps: 2, 3
algorithm: bicubic
bicubic_tension: 0.2
```

- `mesh_pps: 2, 3`\
  _默认值: 2, 2_\
  `mesh_pps`选项是“每段网格点数”的缩写。此选项指定在X轴和Y轴的每个段上要插值的点数。将“段”视为每个探测点之间的空间。与`probe_count`一样，`mesh_pps`指定为X、Y整数对，也可以指定为应用于两个轴的单个整数。在此示例中，X轴上有4个段，Y轴上有2个段。这计算出X轴上有8个插值点，Y轴上有6个插值点，结果为13x9的网格。请注意，如果`mesh_pps`设置为0，则禁用网格插值，直接对探测矩阵进行采样。

- `algorithm: lagrange`\
  _默认值: lagrange_\
  用于插值网格的算法。可以是`lagrange`或`bicubic`。拉格朗日插值最多限制为6个探测点，因为样本数量较大时容易发生振荡。双三次插值要求每个轴上至少有4个探测点，如果指定的点数少于4个，则强制使用拉格朗日采样。如果`mesh_pps`设置为0，则忽略此值，因为不进行网格插值。

- `bicubic_tension: 0.2`\
  _默认值: 0.2_\
  如果`algorithm`选项设置为双三次，则可以指定张力值。张力越高，插值的斜率越大。调整时要小心，因为较高的值也会产生更多的过冲，导致插值的值高于或低于您的探测点。

下图显示了上述选项如何用于生成插值网格。

[bedmesh_interpolated](img/bedmesh_interpolated.svg)

### 移动分割

床网校准通过拦截G代码移动命令并对它们的Z坐标应用变换来工作。长移动必须分割成较小的移动，以正确跟随打印床的形状。以下选项控制分割行为。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
move_check_distance: 5
split_delta_z: .025
```

- `move_check_distance: 5`\
  _默认值: 5_\
  在执行分割之前，检查所需Z变化的最小距离。在此示例中，长于5毫米的移动将由算法遍历。每5毫米进行一次网格Z查找，将其与前一次移动的Z值进行比较。如果差值达到`split_delta_z`设置的阈值，移动将被分割，遍历将继续。此过程重复直到移动结束，在终点处应用最终调整。短于`move_check_distance`的移动直接在移动上应用正确的Z调整，无需遍历或分割。

- `split_delta_z: .025`\
  _默认值: .025_\
  如上所述，这是触发移动分割所需的最小偏差。在此示例中，任何偏差为+/- .025毫米的Z值都将触发分割。

通常，这些选项的默认值是足够的，事实上，`move_check_distance`的默认值5毫米可能有些过度。然而，高级用户可能希望尝试这些选项，以挤出最佳的第一层效果。

### 网格淡出

启用“淡出”后，Z调整将在配置定义的距离内逐渐减少。这是通过应用小的层高调整来实现的，根据打印床的形状增加或减少。当淡出完成后，不再应用Z调整，允许打印顶部平坦，而不是镜像打印床的形状。淡出也可能有一些不良特征，如果淡出太快，可能会在打印件上产生可见的伪影。此外，如果您的打印床明显扭曲，淡出可能会缩短或拉伸打印的Z高度。因此，默认情况下禁用淡出。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
fade_start: 1
fade_end: 10
fade_target: 0
```

- `fade_start: 1`\
  _默认值: 1_\
  开始逐渐减少调整的Z高度。最好在打好几层后再开始淡出过程。

- `fade_end: 10`\
  _默认值: 0_\
  淡出应完成的Z高度。如果此值低于`fade_start`，则禁用淡出。此值可以根据打印表面的扭曲程度进行调整。严重扭曲的表面应在较长的距离内淡出。接近平坦的表面可以减小此值，以更快地淡出。如果`fade_start`使用默认值1，则10毫米是一个合理的起始值。

- `fade_target: 0`\
  _默认值: 网格的平均Z值_\
  `fade_target`可以被认为是淡出完成后应用于整个打印床的额外Z偏移。一般来说，我们希望此值为0，但在某些情况下不应如此。例如，假设您在打印床上的归零位置是一个异常值，它比网格的平均探测高度低0.2毫米。如果`fade_target`为0，淡出将平均在打印床上缩小0.2毫米。通过将`fade_target`设置为0.2，归零区域将扩大0.2毫米，然而，打印床的其余部分将准确尺寸。通常，最好将`fade_target`留在配置之外，以便使用网格的平均高度，但在想要在打印床的特定部分打印时，可能需要手动调整淡出目标。

### 配置零参考位置

许多探针容易受到“漂移”影响，即由热量或干扰引起的探测不准确性。这使得计算探针的z偏移量具有挑战性，特别是在不同的打印床温度下。因此，一些打印机使用限位开关来归零Z轴，使用探针来校准网格。在这种配置中，可以偏移网格，使(X, Y) `参考位置`应用零调整。`参考位置`应该是打印床上进行[Z_ENDSTOP_CALIBRATE](./Manual_Level.md#calibrating-a-z-endstop)纸张测试的位置。bed_mesh模块提供了`zero_reference_position`选项来指定此坐标：

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
zero_reference_position: 125, 110
probe_count: 5, 3
```
- `zero_reference_position: `\
  _默认值: 无（禁用）_\
  `zero_reference_position`期望一个(X, Y)坐标，匹配上述`参考位置`的描述。如果坐标位于网格内，则网格将被偏移，使参考位置应用零调整。如果坐标位于网格外，则在校准后探测该坐标，使用得到的z值作为z偏移量。请注意，如果需要探针，此坐标不得位于指定为`faulty_region`的位置。

### 故障区域

由于特定位置的“故障”，打印床的某些区域在探测时可能会报告不准确的结果。最好的例子是带有集成磁铁系列的打印床，用于固定可拆卸的钢板。在这些磁铁及其周围区域的磁场可能会导致电感探针在比正常情况下更高或更低的距离触发，导致网格在这些位置不能准确表示表面。**注意：这不应与探针位置偏差混淆，探针位置偏差在整个打印床上产生不准确的结果。**

可以配置`faulty_region`选项来补偿这种影响。如果生成的点位于故障区域内，床网校准将尝试在该区域的边界上探测最多4个点。这些探测值将被平均并插入网格中，作为生成的(X, Y)坐标处的Z值。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
faulty_region_1_min: 130.0, 0.0
faulty_region_1_max: 145.0, 40.0
faulty_region_2_min: 225.0, 0.0
faulty_region_2_max: 250.0, 25.0
faulty_region_3_min: 165.0, 95.0
faulty_region_3_max: 205.0, 110.0
faulty_region_4_min: 30.0, 170.0
faulty_region_4_max: 45.0, 210.0
```

- `faulty_region_{1...99}_min`\
  `faulty_region_{1..99}_max`\
  _默认值: 无（禁用）_\
  故障区域的定义方式类似于网格本身，其中必须为每个区域指定最小和最大(X, Y)坐标。故障区域可以延伸到网格之外，但生成的替代点将始终在网格边界内。没有两个区域可以重叠。

下图说明了当生成的点位于故障区域内时，如何生成替代点。所示区域与上面的示例配置相匹配。替代点及其坐标以绿色标识。

[bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

### 自适应网格

自适应床网校准是一种通过仅探测被打印对象使用的打印床区域来加快床网生成速度的方法。使用时，该方法将根据定义的打印对象所占据的区域自动调整网格参数。

自适应网格区域将根据所有定义的打印对象边界的区域计算，覆盖每个对象，包括配置中定义的任何边距。区域计算后，探测点的数量将根据默认网格区域和自适应网格区域的比率按比例缩小。为了说明这一点，考虑以下示例：

对于一个150毫米x150毫米的打印床，`mesh_min`设置为`25,25`，`mesh_max`设置为`125,125`，默认网格区域是一个100毫米x100毫米的正方形。自适应网格区域为`50,50`意味着自适应区域和默认网格区域之间的比率为`0.5x0.5`。

如果`bed_mesh`配置将`probe_count`指定为`7x7`，则自适应床网将使用4x4探测点（7 * 0.5向上取整）。

[adaptive_bedmesh](img/adaptive_bed_mesh.svg)

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
adaptive_margin: 5
```

- `adaptive_margin` \
  _默认值: 0_ \
  在定义的对象使用的打印床区域周围添加的边距（毫米）。下图显示了`adaptive_margin`为5毫米的自适应床网区域。自适应网格区域（绿色区域）计算为使用的打印床区域（蓝色区域）加上定义的边距。

  [adaptive_bedmesh_margin](img/adaptive_bed_mesh_margin.svg)

本质上，自适应床网使用正在打印的G代码文件定义的对象。因此，预计每个G代码文件将生成一个探测打印床不同区域的网格。因此，不应重用自适应床网。如果使用自适应网格，期望为每次打印生成一个新的网格。

同样重要的是要考虑，自适应床网最适合那些通常可以探测整个打印床并实现最大方差小于或等于1层高度的机器。具有机械问题的机器，通常通过全床网格进行补偿，在尝试**网格区域外**的打印移动时可能会产生不良结果。如果全床网格的方差大于1层高度，在使用自适应床网并尝试网格区域外的打印移动时必须谨慎。

## 表面扫描

一些探针，例如[涡流探针](./Eddy_Probe.md)，能够“扫描”打印床的表面。也就是说，这些探针可以在采样之间不抬起工具的情况下对网格进行采样。要激活扫描模式，应在`BED_MESH_CALIBRATE` gcode命令中传递`METHOD=scan`或`METHOD=rapid_scan`探针参数。

### 扫描高度

扫描高度由`[bed_mesh]`中的`horizontal_move_z`选项设置。此外，它可以通过`BED_MESH_CALIBRATE` gcode命令中的`HORIZONTAL_MOVE_Z`参数提供。

扫描高度必须足够低以避免扫描错误。通常，2毫米的高度（即`HORIZONTAL_MOVE_Z=2`）应该工作良好，前提是探针正确安装。

需要注意的是，如果探针高于表面超过4毫米，则结果将无效。因此，对于表面偏差严重或极端倾斜且未校正的打印床，无法进行扫描。

### 快速（连续）扫描

进行`rapid_scan`时，应注意结果会有一些误差。这种误差应该足够低，对于大面积打印和合理厚的层高来说是有用的。某些探针可能比其他探针更容易出错。

不建议在快速模式下扫描“密集”网格。快速扫描引入的一些误差可能是传感器的高斯噪声，密集网格会反映这种噪声（即会出现峰值和谷值）。

床网校准将尝试优化行进路径，根据配置提供最佳可能的结果。这包括在采集样本时避开故障区域，以及在改变方向时“超出”网格。这种超调可以改善网格边缘的采样，但它要求网格以允许工具在网格外移动的方式进行配置。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5
scan_overshoot: 8
```

- `scan_overshoot`
  _默认值: 0（禁用）_\
  网格外可用的最大行进距离（毫米）。对于矩形打印床，这适用于X轴上的行进，对于圆形打印床，它适用于整个半径。工具必须能够行进指定的网格外距离。此值用于在执行“快速扫描”时优化行进路径。可指定的最小值为1。默认值为无超调。

如果没有配置扫描超调，则不会对方向变化应用行进路径优化。

## 床网校准 G代码

### 校准

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic | scan | rapid_scan] \
[<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] \
[ADAPTIVE_MARGIN=<value>]`\
_默认配置文件:  default_\
_默认方法:  如果检测到探针则为自动，否则为手动_ \
_默认自适应: 0_ \
_默认自适应边距: 0_

启动床网校准的探测过程。

当命令完成时，网格将立即可以使用，并保存到由`PROFILE`参数指定的配置文件中，如果未指定则为`default`。`METHOD`参数取以下值之一：

- `METHOD=manual`: 使用喷嘴和纸张测试启用手动探测
- `METHOD=automatic`:  自动（标准）探测。这是默认值。
- `METHOD=scan`: 启用表面扫描。工具将在每个位置暂停以收集样本。
- `METHOD=rapid_scan`: 启用连续表面扫描。

当选择`manual`以外的探测方法时，XY位置会自动调整以包含X和/或Y偏移。

可以指定网格参数以修改探测区域。以下参数可用：

- 矩形打印床（笛卡尔）：
  - `MESH_MIN`
  - `MESH_MAX`
  - `PROBE_COUNT`
- 圆形打印床（三角洲）：
  - `MESH_RADIUS`
  - `MESH_ORIGIN`
  - `ROUND_PROBE_COUNT`
- 所有打印床：
  - `MESH_PPS`
  - `ALGORITHM`
  - `ADAPTIVE`
  - `ADAPTIVE_MARGIN`

有关每个参数如何应用于网格的详细信息，请参阅上面的配置文档。

### 配置文件

`BED_MESH_PROFILE SAVE=<name> LOAD=<name> REMOVE=<name>`

在执行BED_MESH_CALIBRATE后，可以将当前网格状态保存到命名的配置文件中。这使得可以在不重新探测打印床的情况下加载网格。使用`BED_MESH_PROFILE SAVE=<name>`保存配置文件后，可以执行`SAVE_CONFIG` gcode将配置文件写入printer.cfg。

通过执行`BED_MESH_PROFILE LOAD=<name>`可以加载配置文件。

需要注意的是，每次发生BED_MESH_CALIBRATE时，当前状态都会自动保存到_default_配置文件中。可以通过以下方式删除_default_配置文件：

`BED_MESH_PROFILE REMOVE=default`

任何其他保存的配置文件都可以以相同的方式删除，将_default_替换为您要删除的命名配置文件。

#### 加载默认配置文件

以前版本的`bed_mesh`总是在启动时加载名为_default_的配置文件（如果存在）。这种行为已被移除，以便用户确定何时加载配置文件。如果用户希望加载`default`配置文件，建议将`BED_MESH_PROFILE LOAD=default`添加到他们的`START_PRINT`宏或切片软件的“启动G代码”配置中，视情况而定。

请注意，如果在`START_PRINT`宏或切片软件的“启动G代码”中使用`BED_MESH_CALIBRATE`生成新网格，则不需要这样做，可能会产生意外结果，特别是使用自适应网格时。

或者，可以通过`[delayed_gcode]`恢复在启动时加载配置文件的旧行为：

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### 输出

`BED_MESH_OUTPUT PGP=[0 | 1]`

将当前网格状态输出到终端。请注意，网格本身会输出

PGP参数是“打印生成点”的缩写。如果设置了`PGP=1`，生成的探测点将输出到终端：

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (11.0, 1.0) | (35.0, 6.0)
// 1 | (62.2, 1.0) | (86.2, 6.0)
// 2 | (113.5, 1.0) | (137.5, 6.0)
// 3 | (164.8, 1.0) | (188.8, 6.0)
// 4 | (216.0, 1.0) | (240.0, 6.0)
// 5 | (216.0, 97.0) | (240.0, 102.0)
// 6 | (164.8, 97.0) | (188.8, 102.0)
// 7 | (113.5, 97.0) | (137.5, 102.0)
// 8 | (62.2, 97.0) | (86.2, 102.0)
// 9 | (11.0, 97.0) | (35.0, 102.0)
// 10 | (11.0, 193.0) | (35.0, 198.0)
// 11 | (62.2, 193.0) | (86.2, 198.0)
// 12 | (113.5, 193.0) | (137.5, 198.0)
// 13 | (164.8, 193.0) | (188.8, 198.0)
// 14 | (216.0, 193.0) | (240.0, 198.0)
```

“Tool Adjusted”点指每个点的喷嘴位置，“Probe”点指探针位置。请注意，手动探测时，“Probe”点指工具和喷嘴位置。

### 清除网格状态

`BED_MESH_CLEAR`

此gcode可用于清除内部网格状态。

### 应用X/Y偏移

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value>]`

这对于具有多个独立挤出机的打印机很有用，因为在换工具后需要偏移来产生正确的Z调整。偏移应相对于主挤出机指定。也就是说，如果次级挤出机安装在主挤出机右侧，应指定正X偏移；如果次级挤出机安装在主挤出机“后面”，应指定正Y偏移；如果次级挤出机的喷嘴在主挤出机之上，应指定正ZFADE偏移。

请注意，ZFADE偏移*不*直接应用额外调整。它旨在补偿[网格淡出](#mesh-fade)启用时的`gcode offset`。例如，如果次级挤出机高于主挤出机且需要负gcode偏移，即`SET_GCODE_OFFSET Z=-.2`，则可以在`bed_mesh`中用`BED_MESH_OFFSET ZFADE=.2`来补偿。

## 床网校准 Webhooks API

### 转储网格数据

`{"id": 123, "method": "bed_mesh/dump_mesh"}`

转储当前网格和所有已保存配置文件的配置和状态。

`dump_mesh`端点接受一个可选参数`mesh_args`。此参数必须是一个对象，其键和值是[BED_MESH_CALIBRATE](#bed_mesh_calibrate)可用的参数。这将在返回结果之前使用提供的参数更新网格配置和探测点。除非希望在执行`BED_MESH_CALIBRATE`之前可视化探测点和/或行进路径，否则建议省略网格参数。

## 可视化和分析

大多数用户可能会发现，像Mainsail、Fluidd和Octoprint这样的应用程序中包含的可视化工具足以进行基本分析。然而，Klipper的`scripts`文件夹包含`graph_mesh.py`脚本，可用于执行额外的可视化和更详细的分析，特别是对于调试硬件或`bed_mesh`产生的结果很有用：

```
usage: graph_mesh.py [-h] {list,plot,analyze,dump} ...

Graph Bed Mesh Data

positional arguments:
  {list,plot,analyze,dump}
    list                List available plot types
    plot                Plot a specified type
    analyze             Perform analysis on mesh data
    dump                Dump API response to json file

options:
  -h, --help            show this help message and exit
```

### 先决条件

与Klipper提供的大多数绘图工具一样，`graph_mesh.py`需要`matplotlib`和`numpy` python依赖项。此外，通过Moonraker的websocket连接Klipper需要`websockets` python依赖项。虽然所有可视化都可以输出到`svg`文件，但`graph_mesh.py`提供的大多数可视化在桌面级PC的实时预览模式下查看效果更好。例如，3D可视化可以在预览模式下旋转和缩放，路径可视化可以选择在预览模式下动画显示。

### 绘制网格数据

`graph_mesh.py`工具可以绘制几种类型的可视化。可用类型可以通过运行`graph_mesh.py list`显示：

```
graph_mesh.py list
points    Plot original generated points
path      Plot probe travel path
rapid     Plot rapid scan travel path
probedz   Plot probed Z values
meshz     Plot mesh Z values
overlay   Plots the current probed mesh overlaid with a profile
delta     Plots the delta between current probed mesh and a profile
```

绘制可视化时有几个选项可用：

```
usage: graph_mesh.py plot [-h] [-a] [-s] [-p PROFILE_NAME] [-o OUTPUT] <plot type> <input>

positional arguments:
  <plot type>           Type of data to graph
  <input>               Path/url to Klipper Socket or path to json file

options:
  -h, --help            show this help message and exit
  -a, --animate         Animate paths in live preview
  -s, --scale-plot      Use axis limits reported by Klipper to scale plot X/Y
  -p PROFILE_NAME, --profile-name PROFILE_NAME
                        Optional name of a profile to plot for 'probedz'
  -o OUTPUT, --output OUTPUT
                        Output file path
```

以下是每个参数的描述：

- `plot type`: 一个必需的位置参数，指定要生成的可视化类型。必须是`graph_mesh.py list`命令输出的类型之一。
- `input`: 一个必需的位置参数，包含输入源的路径或url。这必须是以下之一：
  - Klipper的Unix域套接字路径
  - Moonraker实例的url
  - `graph_mesh.py dump <input>`生成的json文件路径
- `-a`: 为`path`和`rapid`可视化类型提供可选动画。动画仅适用于实时预览。
- `-s`: 可选地使用dump文件生成时Klipper的`toolhead`对象报告的`axis_minimum`和`axis_maximum`值来缩放绘图X/Y。
- `-p`: 生成`probedz` 3D网格可视化时可以指定的配置文件名称。生成`overlay`或`delta`可视化时必须提供此参数。
- `-o`: 一个可选的文件路径，指示脚本应将可视化保存到此位置而不是以预览模式运行。图像以`svg`格式保存。

例如，要绘制动画快速路径，通过Klipper的unix套接字连接：

```
graph_mesh.py plot -a rapid ~/printer_data/comms/klippy.sock
```

或通过Moonraker绘制网格的3d可视化：

```
graph_mesh.py plot meshz http://my-printer.local
```

### 床网校准分析

`graph_mesh.py`工具也可用于对[bed_mesh/dump_mesh](#dumping-mesh-data) API提供的数据执行分析：

```
graph_mesh.py analyze <input>
```

与`plot`命令一样，`<input>`必须是Klipper的unix套接字路径、Moonraker实例的URL或由dump命令生成的json文件路径。

开始时，分析将对转储时`bed_mesh`生成的点和探测路径执行各种检查。这包括以下内容：

- 生成的探测点数量，不包括任何添加
- 生成的探测点数量，包括因故障区域和/或配置的零参考位置而生成的任何点。
- 执行快速扫描时生成的探测点数量。
- 快速扫描生成的总移动数。
- 验证快速扫描生成的探测点是否与标准探测过程生成的探测点相同。
- 对标准探测路径和快速扫描路径进行“回溯”检查。回溯可以定义为在探测过程中多次移动到同一位置。标准探测中不应发生回溯。故障区域*可以*在快速扫描期间导致回溯，以尝试在接近或离开探测位置时避免进入故障区域，但其他情况下不应发生。

接下来，将分析转储中存在的每个探测网格，从转储时加载的网格（如果存在）开始，然后是任何保存的配置文件。提取以下数据：

- 网格形状（最小X,Y，最大X,Y 探测点数）
- 网格Z范围，（最小Z，最大Z）
- 网格中的平均Z值
- 网格中Z值的标准偏差

除了上述内容外，还对相同形状的网格进行delta分析，报告以下内容：
- 两个网格之间delta的范围（最小值和最大值）
- 平均delta
- delta的标准偏差
- 绝对最大差值
- 绝对平均值

### 将网格数据保存到文件

`dump`命令可用于将响应保存到文件中，以便在故障排除时共享进行分析：

```
graph_mesh.py dump -o <output file name> <input>
```

`<input>`应该是Klipper的unix套接字路径或Moonraker实例的URL。`-o`选项可用于指定输出文件的路径。如果省略，文件将保存在工作目录中，文件名格式如下：

`klipper-bedmesh-{year}{month}{day}{hour}{minute}{second}.json`