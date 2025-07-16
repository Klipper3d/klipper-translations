# 床网

床网模块可以用于补偿床面的不规则性，以实现更好的首层均一性。需要注意的是，基于软件的校正无法达到完美的结果，它只能近似地模拟床面的形状。床网模块也无法对机械和电气问题进行补偿。如果一个轴倾斜或探针不准确，那么床网模块将无法从探测过程中获得准确的结果。

在进行网格校准之前，需要先校准探针的 Z 偏移。如果使用限位开关进行Z轴定位，也需要对其进行校准。请参阅[探针校准](Probe_Calibrate.md)和[手动调平](Manual_Level.md)中的 Z_ENDSTOP_CALIBRATE 获取更多信息。

## 基本配置

### 矩形热床

此示例假定打印机具有 250 mm x 220 mm 矩形床和一个 x 偏移为 24 mm和 y 偏移为 5 mm的探针。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `speed: 120` *默认值：50* 探针在两个点之间移动的速度。
- `horizontal_move_z: 5` *默认值：5* 探针前往下一个点之前Z需要抬升的高度。
- `mesh_min: 35,6` *（必须存在）*第一个探测的坐标，距离原点最近。该坐标就是探针所在的位置。
- `mesh_max: 240, 198` *Required* The probed coordinate farthest from the origin. This is not necessarily the last point probed, as the probing process occurs in a zig-zag fashion. As with `mesh_min`, this coordinate is relative to the probe's location.
- `probe_count: 5, 3` *默认值：3, 3* 每个轴上要探测的点数，指定为 X, Y 整数值。 在本示例中，将沿 X 轴探测 5 个点，沿 Y 轴探测 3 个点，总共探测 15 个点。 请注意，如果您想要一个方形网格，例如 3x3，可以将指定其为一个整数值，比如 `probe_count: 3`。 请注意，网格需要沿每个轴的最小 probe_count 为3。

下图演示了如何使用 `mesh_min`、`mesh_max` 和 `probe_count` 选项来生成探测点。 箭头表示探测过程的运动方向，从“mesh_min”开始。 图中所示，当探针位于“mesh_min”时，喷嘴将位于 (11, 1)，当探针位于“mesh_max”时，喷嘴将位于 (206, 193)。

![矩形网床基本配置](img/bedmesh_rect_basic.svg)

### 圆形热床

本示例假设打印机配备的圆床半径为 100 mm。 我们将使用与矩形网床示例相同的探针偏移来演示，X 偏移为 24 mm，Y 偏移为 5 mm。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius: 75` *必须配置* 探测网格范围的半径（单位：mm），相对于 `mesh_origin`。 请注意，探针的偏移会限制网格半径的大小。 在此示例中，大于 76 mm的半径会将打印头移动到打印机的范围之外。
- `mesh_origin: 0, 0` *默认值：0, 0* 探测网格的中心点。 该坐标相对于探针的位置。 虽然默认值为 0,0，但如果希望探测床的边角可以修改该值。 请参阅下图。
- `round_probe_count: 5` *默认值： 5* 这是一个整数值，用于限制沿 X 轴和 Y 轴的最大探测点数。 “最大”是指沿网格原点探测的点数。 该值必须是奇数，因为需要探测网格的中心。

下面的插图展示了如何生成探测点。如您所见，将 `mesh_origin` 设置为 (-10, 0) 允许我们指定更大的网格半径为 85。

![圆形网床基本配置](img/bedmesh_round_basic.svg)

## 高级配置

下面详细解释了更高级的配置选项。 每个示例都将建立在上面显示的基本矩形床配置之上。 每个高级选项都以相同的方式应用于圆床。

### 网格插值

虽然可以直接使用简单的双线性插值来对探测矩阵进行采样，以确定探测点之间的 Z 值，但通常使用更高级的插值算法来插值额外的点，以增加网格密度，效果通常很好。这些算法会向网格添加曲率，试图模拟床的材料属性。床网提供拉格朗日和双三次插值来实现这一点。

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

- `mesh_pps: 2,3` *默认值：2,2*`mesh_pps` 选项是每段的网格点数的简写。 此选项指定沿 x 轴和 y 轴为每个线段插值的点数。 “段”被视为每个探测点之间的间隔。 与 `probe_count` 一样，`mesh_pps` 可以是 X, Y 整数对，也可以是同时应用于两个轴的单个整数。 在此示例中，沿 X 轴有 4 个线段，沿 Y 轴有 2 个线段。 这计算为沿 X 的 8 个插值点，沿 Y 的 6 个插值点，从而产生 13x8 网格。 请注意，如果 mesh_pps 设置为 0，则禁用网格插值，并且将直接对探测网格进行采样。
- `algorithm: lagrange` *默认值：lagrange* 用于插入网格的算法。 可能是 `lagrange` or `bicubic`。 拉格朗日插值最多为 6 个探测点，因为大量样本容易发生振荡。 双三次插值要求沿每个轴至少有 4 个探测点，如果指定的点少于 4 个，则强制拉格朗日采样。 如果 `mesh_pps` 设置为 0，则该值将被忽略，因为没有进行网格插值。
- `bicubic_tension: 0.2` *默认值：0.2* 双三次插值的张力值。如果`algorithm` 选项设置为双三次，则可以指定张力值。 张力越高，内插的斜率越大。 调整时要小心，因为较高的值也会产生更多的过冲，这将导致插值高于或低于探测点。

下图显示了如何使用上述选项生成网格插值。

![网床插值](img/bedmesh_interpolated.svg)

### 移动拆分

床网的工作原理是拦截 G 代码移动命令并对其 Z 坐标进行变换。长的移动必须被分割成较小的移动以正确地遵循床的形状。下面的选项可以控制分割的行为。

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

- `move_check_distance: 5` *默认值：5* 在执行拆分之前检查 Z 中需要变化的最小距离。 在此示例中，算法将遍历超过 5 毫米的移动。 每 5mm 将查找一次网格的Z ，并将其与前一次移动的 Z 值进行比较。 如果三角洲满足 `split_delta_z` 设置的阈值，则移动将被拆分并继续遍历。 重复此过程，直到到达移动结束处，在此将应用最终调整。 比 `move_check_distance` 短的移动将正确的 Z 调整直接应用于移动，无需遍历或拆分。
- `split_delta_z: .025` *默认值：.025* 如上所述，这是触发移动拆分所需的最小偏差。 在上面的示例中，任何偏差为 +/- .025 mm的 Z 值都将触发拆分。

通常这些选项的默认值已经足够了，事实上 `move_check_distance` 的默认值 5mm 可能过于保守。但是，高级用户可能希望尝试这些选项，以获取最佳的第一层效果。

### 网格淡出

启用“网格淡出”后，Z 轴的调整将在配置中定义的距离范围内逐步消失。 这是通过对层高进行小幅调整来实现的，根据床的形状增加或减少。 网格淡出完成后，不再使用 Z 调整，使打印的表面是平坦的而不是床弯曲的形状。 网格淡出也可能会产生一些不良表现，如果网格淡出过快，可能会导致打印件上出现可见的瑕疵（伪影）。 此外，如果您的床明显变形，网格淡出会缩小或拉伸打印件的 Z 高度。 因此，默认情况下禁用网格淡出。

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

- `fade_start: 1` *默认值：1* 开始网格淡出的值，在设定的fade_start值之后逐步停止调整Z的高度。 建议在打印几层之后再开始淡出层高。
- `fade_end: 10` *默认值：0* 网格淡出完成的 Z 高度。 如果此值低于`fade_start`，则禁用网格淡出。 该值可以根据打印表面的弯曲程度进行调整。 明显弯曲的表面应该在将网格淡出的距离长。 接近平坦的表面可能能够降低该值以更快地逐步淘汰。 如果对 `fade_start` 使用默认值 1，则 10mm 是一个合理的值。
- `fade_target: 0` *默认值：网格的平均 Z 值* `fade_target` 可以被视为在淡化完成后应用于整个床面的额外 Z 偏移量。一般来说，我们希望这个值为 0，但有些情况下不应该是这样的。例如，假设您在床上的归位位置是一个异常值，比床面的平均探测高度低 0.2 毫米。如果 `fade_target` 为 0，淡化将会使整个床面平均降低 0.2 毫米。通过将 `fade_target` 设置为 0.2，淡化区域将会提高到 0.2 毫米，但是，床面的其余部分将保持原大小。通常最好将 `fade_target` 留在配置中，以便使用网格的平均高度，但是如果您想在床面的特定部分上打印，则可能需要手动调整淡化目标。

### 配置零点参考位置

Many probes are susceptible to "drift", ie: inaccuracies in probing introduced by heat or interference. This can make calculating the probe's z-offset challenging, particularly at different bed temperatures. As such, some printers use an endstop for homing the Z axis and a probe for calibrating the mesh. In this configuration it is possible offset the mesh so that the (X, Y) `reference position` applies zero adjustment. The `reference postion` should be the location on the bed where a [Z_ENDSTOP_CALIBRATE](./Manual_Level.md#calibrating-a-z-endstop) paper test is performed. The bed_mesh module provides the `zero_reference_position` option for specifying this coordinate:

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
zero_reference_position: 125, 110
probe_count: 5, 3
```

- `ZERO_REFERENCE_POSITION：`*默认值：无(禁用)*`ZERO_REFERENCE_POSITION`期望(X，Y)坐标与上面描述的`参考位置`匹配。如果坐标位于网格内，则网格将偏移，因此参考位置应用零点调整。如果坐标位于网格之外，则将在校准后探测该坐标，并将生成的z值用作z偏移。请注意，如果需要探测，则此坐标不能位于指定为`FAULTY_REGION`的位置。

#### 不推荐使用的Relative_Reference_Index

使用`Relative_Reference_index`选项的现有配置必须更新为使用`ZERO_REFERENCE_Position`。对[BED_MESH_OUTPUT PGP=1](#output)GCODE命令的响应将包括与索引相关的(X，Y)坐标；该位置可用`ZERO_REFERENCE_POSITION`的值。输出将如下所示：

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (1.0, 1.0) | (24.0, 6.0)
// 1 | (36.7, 1.0) | (59.7, 6.0)
// 2 | (72.3, 1.0) | (95.3, 6.0)
// 3 | (108.0, 1.0) | (131.0, 6.0)
... (additional generated points)
// bed_mesh: relative_reference_index 24 is (131.5, 108.0)
```

*注意：上述输出在初始化时也会打印在`klippy.log`中。*

在上面的例子中，我们看到`Relative_Reference_index`与它的坐标一起打印。因此，`ZERO_REFERENCE_Position`是`131.5,108`。

### 故障区域

由于特定位置的“故障”，热床的某些区域在探测时可能会报告不准确的结果。 最好的例子是带有用弹簧钢板的磁铁热床。 这些磁铁处和周围的磁场可能干扰探针触发的高度，从而导致网格无法准确表示这些位置的表面。 **注意：不要与探头位置偏差导致探测结果不准确的结果混淆。**

可以配置 `faulty_region` 选项来避免这种影响。 如果生成的点位于故障区域内，热床网格将尝试在该区域的边界处探测最多 4 个点。 这些探测的平均值将插入网床中作为生成的 (X, Y) 坐标处的 Z 值。

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

- `faulty_region_{1...99}_min` `faulty_region_{1...99}_max` *默认值：None （无）(disabled（禁用）)* 故障区域的定义方式类似床网本身，必须为每个区域指定最小和最大（X, Y）坐标。一个故障区域可以延伸到网格之外，但是产生的替代探测点总是在网格的边界内。两个区域不可以重叠。

下面的图片说明了当一个生成的探测点位于一个故障区域内时，如何生成替代探测点。所显示的区域与上述样本配置中的区域一致。替代点和它们的坐标以绿色标识。

![bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

### Adaptive Meshes

Adaptive bed meshing is a way to speed up the bed mesh generation by only probing the area of the bed used by the objects being printed. When used, the method will automatically adjust the mesh parameters based on the area occupied by the defined print objects.

The adapted mesh area will be computed from the area defined by the boundaries of all the defined print objects so it covers every object, including any margins defined in the configuration. After the area is computed, the number of probe points will be scaled down based on the ratio of the default mesh area and the adapted mesh area. To illustrate this consider the following example:

For a 150mmx150mm bed with `mesh_min` set to `25,25` and `mesh_max` set to `125,125`, the default mesh area is a 100mmx100mm square. An adapted mesh area of `50,50` means a ratio of `0.5x0.5` between the adapted area and default mesh area.

If the `bed_mesh` configuration specified `probe_count` as `7x7`, the adapted bed mesh will use 4x4 probe points (7 * 0.5 rounded up).

![adaptive_bedmesh](img/adaptive_bed_mesh.svg)

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
adaptive_margin: 5
```

- `adaptive_margin`  *Default Value: 0*  Margin (in mm) to add around the area of the bed used by the defined objects. The diagram below shows the adapted bed mesh area with an `adaptive_margin` of 5mm. The adapted mesh area (area in green) is computed as the used bed area (area in blue) plus the defined margin.

   ![adaptive_bedmesh_margin](img/adaptive_bed_mesh_margin.svg)

By nature, adaptive bed meshes use the objects defined by the Gcode file being printed. Therefore, it is expected that each Gcode file will generate a mesh that probes a different area of the print bed. Therefore, adapted bed meshes should not be re-used. The expectation is that a new mesh will be generated for each print if adaptive meshing is used.

It is also important to consider that adaptive bed meshing is best used on machines that can normally probe the entire bed and achieve a maximum variance less than or equal to 1 layer height. Machines with mechanical issues that a full bed mesh normally compensates for may have undesirable results when attempting print moves **outside** of the probed area. If a full bed mesh has a variance greater than 1 layer height, caution must be taken when using adaptive bed meshes and attempting print moves outside of the meshed area.

## Surface Scans

Some probes, such as the [Eddy Current Probe](./Eddy_Probe.md), are capable of "scanning" the surface of the bed. That is, these probes can sample a mesh without lifting the tool between samples. To activate scanning mode, the `METHOD=scan` or `METHOD=rapid_scan` probe parameter should be passed in the `BED_MESH_CALIBRATE` gcode command.

### Scan Height

The scan height is set by the `horizontal_move_z` option in `[bed_mesh]`. In addition it can be supplied with the `BED_MESH_CALIBRATE` gcode command via the `HORIZONTAL_MOVE_Z` parameter.

The scan height must be sufficiently low to avoid scanning errors. Typically a height of 2mm (ie: `HORIZONTAL_MOVE_Z=2`) should work well, presuming that the probe is mounted correctly.

It should be noted that if the probe is more than 4mm above the surface then the results will be invalid. Thus, scanning is not possible on beds with severe surface deviation or beds with extreme tilt that hasn't been corrected.

### Rapid (Continuous) Scanning

When performing a `rapid_scan` one should keep in mind that the results will have some amount of error. This error should be low enough to be useful on large print areas with reasonably thick layer heights. Some probes may be more prone to error than others.

It is not recommended that rapid mode be used to scan a "dense" mesh. Some of the error introduced during a rapid scan may be gaussian noise from the sensor, and a dense mesh will reflect this noise (ie: there will be peaks and valleys).

Bed Mesh will attempt to optimize the travel path to provide the best possible result based on the configuration. This includes avoiding faulty regions when collecting samples and "overshooting" the mesh when changing direction. This overshoot improves sampling at the edges of a mesh, however it requires that the mesh be configured in a way that allows the tool to travel outside of the mesh.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5
scan_overshoot: 8
```

- `scan_overshoot` *Default Value: 0 (disabled)* The maximum amount of travel (in mm) available outside of the mesh. For rectangular beds this applies to travel on the X axis, and for round beds it applies to the entire radius. The tool must be able to travel the amount specified outside of the mesh. This value is used to optimize the travel path when performing a "rapid scan". The minimum value that may be specified is 1. The default is no overshoot.

If no scan overshoot is configured then travel path optimization will not be applied to changes in direction.

## 床网 G代码

### 校准

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic | scan | rapid_scan] \ [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] \ [ADAPTIVE_MARGIN=<value>]` *Default Profile: default* *Default Method: automatic if a probe is detected, otherwise manual*  *Default Adaptive: 0*  *Default Adaptive Margin: 0*

启动床网校准的探测程序。

The mesh will be immediately ready to use when the command completes and saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. The `METHOD` parameter takes one of the following values:

- `METHOD=manual`: enables manual probing using the nozzle and the paper test
- `METHOD=automatic`: Automatic (standard) probing. This is the default.
- `METHOD=scan`: Enables surface scanning. The tool will pause over each position to collect a sample.
- `METHOD=rapid_scan`: Enables continuous surface scanning.

XY positions are automatically adjusted to include the X and/or Y offsets when a probing method other than `manual` is selected.

可以通过指定网格参数来修改探测区域。以下参数可用：

- 矩形打印床（笛卡尔 Cartesian）：
   - `MESH_MIN`
   - `MESH_MAX`
   - `PROBE_COUNT`
- 圆形打印床（三角洲 delta）：
   - `MESH_RADIUS`
   - `MESH_ORIGIN`
   - `ROUND_PROBE_COUNT`
- 全部打印床：
   - `MESH_PPS`
   - `ALGORITHM`
   - `ADAPTIVE`
   - `ADAPTIVE_MARGIN`

有关在网格中使用的配置参数详见配置文档。

### 配置

`BED_MESH_PROFILE SAVE=<名称> LOAD=<名称> REMOVE=<名称>`

在执行 BED_MESH_CALIBRATE 后，可以将当前网格状态保存到一个命名的配置中。这样不需要重新探测打印床就可以载入一个网格。在使用`BED_MESH_PROFILE SAVE=<名称>`保存了一个配置文件后，可以执行`SAVE_CONFIG` G代码将配置写入 printer.cfg。

可以通过运行 `BED_MESH_PROFILE LOAD=<名称>` 来载入配置。

需要注意的是，每次进行 BED_MESH_CALIBRATE 时，当前状态会自动保存到 *default* 配置文件中。可以按以下方式删除 *default* 配置文件：

`BED_MESH_PROFILE REMOVE=default`

任何其他保存的配置也可以用相同的方式删除，用你想删除的配置名称替换*default*。

#### 加载默认配置文件

以前版本的`bed_mesh`如果(default)默认配置存在，则始终在启动时加载名为*default*的配置文件。现已删除此行为，以允许用户确定何时加载配置文件。如果用户希望加载`default`配置文件，则建议将 `BED_MESH_PROFILE LOAD=default` 添加到其 `START_PRINT` 宏或其切片软件的“启动 G代码”配置中，视情况而定。

Note that this is not required if a new mesh is generated with `BED_MESH_CALIBRATE` in the `START_PRINT` macro or the slicer's "Start G-Code" and may produce unexpected results, especially with adaptive meshing.

或者可以通过添加`[delayed_gcode]`恢复在启动时加载配置文件的旧行为：

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### 输出

`BED_MESH_OUTPUT PGP=[0 | 1]`

将当前网格状态输出到终端。请注意，输出的是网格本身

PGP 参数是“打印生成的点”的简写。如果设置了`PGP=1`，生成的探测点将输出到终端：

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

"Tool Adjusted"（工具调整）点指每个点的喷嘴位置，"Probe"（探针）点指探头位置。请注意，手动探测时"Probe"（探针）点时将同时指工具和喷嘴位置。

### 清除网格状态

`BED_MESH_CLEAR`

此 gcode 可用于清除内部网格状态。

### 应用X/Y偏移量

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value>]`

This is useful for printers with multiple independent extruders, as an offset is necessary to produce correct Z adjustment after a tool change. Offsets should be specified relative to the primary extruder. That is, a positive X offset should be specified if the secondary extruder is mounted to the right of the primary extruder, a positive Y offset should be specified if the secondary extruder is mounted "behind" the primary extruder, and a positive ZFADE offset should be specified if the secondary extruder's nozzle is above the primary extruder's.

Note that a ZFADE offset does *NOT* directly apply additional adjustment. It is intended to compensate for a `gcode offset` when [mesh fade](#mesh-fade) is enabled. For example, if a secondary extruder is higher than the primary and needs a negative gcode offset, ie: `SET_GCODE_OFFSET Z=-.2`, it can be accounted for in `bed_mesh` with `BED_MESH_OFFSET ZFADE=.2`.

## Bed Mesh Webhooks APIs

### Dumping mesh data

`{"id": 123, "method": "bed_mesh/dump_mesh"}`

Dumps the configuration and state for the current mesh and all saved profiles.

The `dump_mesh` endpoint takes one optional parameter, `mesh_args`. This parameter must be an object, where the keys and values are parameters available to [BED_MESH_CALIBRATE](#bed_mesh_calibrate). This will update the mesh configuration and probe points using the supplied parameters prior to returning the result. It is recommended to omit mesh parameters unless it is desired to visualize the probe points and/or travel path before performing `BED_MESH_CALIBRATE`.

## Visualization and analysis

Most users will likely find that the visualizers included with applications such as Mainsail, Fluidd, and Octoprint are sufficient for basic analysis. However, Klipper's `scripts` folder contains the `graph_mesh.py` script that may be used to perform additional visualizations and more detailed analysis, particularly useful for debugging hardware or the results produced by `bed_mesh`:

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

### Pre-requisites

Like most graphing tools provided by Klipper, `graph_mesh.py` requires the `matplotlib` and `numpy` python dependencies. In addition, connecting to Klipper via Moonraker's websocket requires the `websockets` python dependency. While all visualizations can be output to an `svg` file, most of the visualizations offered by `graph_mesh.py` are better viewed in live preview mode on a desktop class PC. For example, the 3D visualizations may be rotated and zoomed in preview mode, and the path visualizations can optionally be animated in preview mode.

### Plotting Mesh data

The `graph_mesh.py` tool can plot several types of visualizations. Available types can be shown by running `graph_mesh.py list`:

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

Several options are available when plotting visualizations:

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

Below is a description of each argument:

- `plot type`: A required positional argument designating the type of visualization to generate. Must be one of the types output by the `graph_mesh.py list` command.
- `input`: A required positional argument containing a path or url to the input source. This must be one of the following:
   - A path to Klipper's Unix Domain Socket
   - A url to an instance of Moonraker
   - A path to a json file produced by `graph_mesh.py dump <input>`
- `-a`: Optional animation for the `path` and `rapid` visualization types. Animations only apply to a live preview.
- `-s`: Optionally scales a plot using the `axis_minimum` and `axis_maximum` values reported by Klipper's `toolhead` object when the dump file was generated.
- `-p`: A profile name that may be specified when generating the `probedz` 3D mesh visualization. When generating an `overlay` or `delta` visualization this argument must be provided.
- `-o`: An optional file path indicating that the script should save the visualization to this location rather than run in preview mode. Images are saved in `svg` format.

For example, to plot an animated rapid path, connecting via Klipper's unix socket:

```
graph_mesh.py plot -a rapid ~/printer_data/comms/klippy.sock
```

Or to plot a 3d visualization of the mesh, connecting via Moonraker:

```
graph_mesh.py plot meshz http://my-printer.local
```

### Bed Mesh Analysis

The `graph_mesh.py` tool may also be used to perform an analysis on the data provided by the [bed_mesh/dump_mesh](#dumping-mesh-data) API:

```
graph_mesh.py analyze <input>
```

As with the `plot` command, the `<input>` must be a path to Klipper's unix socket, a URL to an instance of Moonraker, or a path to a json file generated by the dump command.

To begin, the analysis will perform various checks on the points and probe paths generated by `bed_mesh` at the time of the dump. This includes the following:

- The number of probe points generated, without any additions
- The number of probe points generated including any points generated as the result faulty regions and/or a configured zero reference position.
- The number of probe points generated when performing a rapid scan.
- The total number of moves generated for a rapid scan.
- A validation that the probe points generated for a rapid scan are identical to the probe points generated for a standard probing procedure.
- A "backtracking" check for both the standard probe path and a rapid scan path. Backtracking can be defined as moving to the same position more than once during the probing procedure. Backtracking should never occur during a standard probe. Faulty regions *can* result in backtracking during a rapid scan in an attempt to avoid entering a faulty region when approaching or leaving a probe location, however should never occur otherwise.

Next each probed mesh present in the dump will by analyzed, beginning with the mesh loaded at the time of the dump (if present) and followed by any saved profiles. The following data is extracted:

- Mesh shape (Min X,Y, Max X,Y Probe Count)
- Mesh Z range, (Minimum Z, Maximum Z)
- Mean Z value in the mesh
- Standard Deviation of the Z values in the Mesh

In addition to the above, a delta analysis is performed between meshes with the same shape, reporting the following:

- The range of the delta between to meshes (Minimum and Maximum)
- The mean delta
- Standard Deviation of the delta
- The absolute maximum difference
- The absolute mean

### Save mesh data to a file

The `dump` command may be used to save the response to a file which can be shared for analysis when troubleshooting:

```
graph_mesh.py dump -o <output file name> <input>
```

The `<input>` should be a path to Klipper's unix socket or a URL to an instance of Moonraker. The `-o` option may be used to specify the path to the output file. If omitted, the file will be saved in the working directory, with a file name in the following format:

`klipper-bedmesh-{year}{month}{day}{hour}{minute}{second}.json`
