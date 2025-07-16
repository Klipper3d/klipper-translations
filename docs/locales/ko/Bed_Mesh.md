# 베드 메쉬

The Bed Mesh module may be used to compensate for bed surface irregularities to achieve a better first layer across the entire bed. It should be noted that software based correction will not achieve perfect results, it can only approximate the shape of the bed. Bed Mesh also cannot compensate for mechanical and electrical issues. If an axis is skewed or a probe is not accurate then the bed_mesh module will not receive accurate results from the probing process.

Prior to Mesh Calibration you will need to be sure that your Probe's Z-Offset is calibrated. If using an endstop for Z homing it will need to be calibrated as well. See [Probe Calibrate](Probe_Calibrate.md) and Z_ENDSTOP_CALIBRATE in [Manual Level](Manual_Level.md) for more information.

## 기본 설정

### 사각 베드

이 예제는 250mm x 220mm 직사각형 베드를 가진 프린터를 가정하에 진행합니다. 그리고 레벨링센서(프로브)는 X오프셋 값 24mm, Y오프셋은 5mm 라고 가정합니다.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `speed: 120` *Default 값: 50* 포인트 사이를 이동하는 속도.
- `horizontal_move_z: 5` *Default 값: 5* 포인트 사이를 이동하기 전에 Z 축 방향으로 올라가는 높이.
- `mesh_min: 35, 6` *Required* The first probed coordinate, nearest to the origin. This coordinate is relative to the probe's location.
- `mesh_max: 240, 198` *Required* The probed coordinate farthest from the origin. This is not necessarily the last point probed, as the probing process occurs in a zig-zag fashion. As with `mesh_min`, this coordinate is relative to the probe's location.
- `probe_count: 5, 3` *Default Value: 3, 3* The number of points to probe on each axis, specified as X, Y integer values. In this example 5 points will be probed along the X axis, with 3 points along the Y axis, for a total of 15 probed points. Note that if you wanted a square grid, for example 3x3, this could be specified as a single integer value that is used for both axes, ie `probe_count: 3`. Note that a mesh requires a minimum probe_count of 3 along each axis.

아래 그림은 `mesh_min`, `mesh_max`, and `probe_count` 옵션이 어떻게 측정위치를 생성하시지를 나타낸 것이다. 화살표는 `mesh_min` 으로 부터 시작한 레벨측정 순서를 나타낸다. 참고로, 프로브가 `mesh_min` 위치일 때 노즐은 (11,1) 위치에 있게 되고, 프로브가 `mesh_max` 위치일 때 노즐은 (206,193)에 위치한다.

![bedmesh_rect_basic](img/bedmesh_rect_basic.svg)

### 원형 베드

이 예제는 베드의 반지름이 100mm 인 원형 베드를 가진 프린터를 가정하에 진행합니다. 그리고 레벨링센서(프로브)는 직사각형 때의 예제와 마찬가지로 X오프셋 값 24mm, Y오프셋은 5mm 라고 가정합니다.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius: 75` *필수* `mesh_origin`에 상대적인 값으로 측정메쉬의 반지름을 mm 단위로 표시한다. 프로브 오프셋이 메쉬 반지름의 크기를 제한합니다. 이 예제에서는 76보다 큰 반지름은 프린터의 가용반경을 넘어 동작하게 될 것입니다.
- `mesh_origin: 0, 0` *Default Value: 0, 0* The center point of the mesh. This coordinate is relative to the probe's location. While the default is 0, 0, it may be useful to adjust the origin in an effort to probe a larger portion of the bed. See the illustration below.
- `round_probe_count: 5` *Default 값: 5* 이 값은 X, Y 축에 따라 레벨링 측정을 할 최대 포인트수를 정수값으로 나타낸다. "최대"값이라 함은 메쉬 원점을 따라 측정하는 포인트수를 뜻한다. 메쉬의 중심을 측정할 수 있도록 하기 위해 이 값은 홀수여야 한다.

The illustration below shows how the probed points are generated. As you can see, setting the `mesh_origin` to (-10, 0) allows us to specify a larger mesh radius of 85.

![bedmesh_round_basic](img/bedmesh_round_basic.svg)

## 고급설정

보다 고급설정을 위한 자세한 옵션에 대한 설명을 아래에 이어가도록 한다. 각 예제는 위에 언급했던 직사각형 베드를 가진 프린터를 기준으로 하겠다. 각 고급옵션들은 원형베드에서도 동일한 방법으로 적용될 수 있다.

### 메쉬 인터폴레이션

While its possible to sample the probed matrix directly using simple bi-linear interpolation to determine the Z-Values between probed points, it is often useful to interpolate extra points using more advanced interpolation algorithms to increase mesh density. These algorithms add curvature to the mesh, attempting to simulate the material properties of the bed. Bed Mesh offers lagrange and bicubic interpolation to accomplish this.

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

- `mesh_pps: 2, 3` *Default Value: 2, 2* The `mesh_pps` option is shorthand for Mesh Points Per Segment. This option specifies how many points to interpolate for each segment along the X and Y axes. Consider a 'segment' to be the space between each probed point. Like `probe_count`, `mesh_pps` is specified as an X, Y integer pair, and also may be specified a single integer that is applied to both axes. In this example there are 4 segments along the X axis and 2 segments along the Y axis. This evaluates to 8 interpolated points along X, 6 interpolated points along Y, which results in a 13x8 mesh. Note that if mesh_pps is set to 0 then mesh interpolation is disabled and the probed matrix will be sampled directly.
- `algorithm: lagrange` *Default 값: lagrange* 메쉬를 인터폴레이션 하는데 사용되는 알고리즘. `lagrange` 와 `bicubic` 를 선택해줄 수 있다. 라그랑지 인터폴레이션은 6개의 측정 포인트로 제한됩니다. 왜냐하면 진동이 더 큰수의 샘플로 발생하기 때문입니다. Bicubic 인터폴레이션은 각축을 따라 최소 4개의 측정 포인트가 필요합니다. 만약 4개 이하의 값이 주어지면 라그랑지 샘플링이 강제로 적용됩니다. 만약 `mesh_pps` 를 0 으로 설정하면 이 값은 무시되며 어떤 메쉬 인터폴레이션도 실행되지 않습니다.
- `bicubic_tension: 0.2` *Default 값: 0.2* 만약 `algorithm` 옵션이 bicubic 이면 tension 값 설정이 가능합니다. 더 높은 텐션값을 적용할 수록 더 많은 경사가 인터폴레이션될 것입니다. 이 값을 설정할 때 주의하십시오. 값이 커질 수록 또한 더 많은 오버슛이 발생합니다. 이 오버슛은 당신이 측정한 포인트보다 더 높거나 낮은 인터폴레이션 값을 내놓을 것입니다.

아래 그림은 위에 사용된 옵션들이 어떻게 인터폴레이션 메쉬를 구성하는지를 나타낸다.

![bedmesh_interpolated](img/bedmesh_interpolated.svg)

### 이동 스플리팅

Bed Mesh works by intercepting gcode move commands and applying a transform to their Z coordinate. Long moves must be split into smaller moves to correctly follow the shape of the bed. The options below control the splitting behavior.

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

- `move_check_distance: 5` *Default 값: 5* 이동분할을 하기 전 Z 방향의 필요변화를 체크하기 위한 최소한의 거리 예를 들어, 5mm 이상의 이동은 알고리즘에 의해 이동하게 될 것이다. 5mm 마다 메쉬에 대한 Z lookup 이 발생하고, 이전 이동에서의 Z 값과 비교할 것이다. 만약 델타 프린터가 `split_delta_z`에 의해 쓰레시홀드를 직면하게 되면, 이동은 분할되고 이어질 것이다. 이 과정은 이동의 끝에 이르기까지 계속반복될 것이다. 그리고 그 끝점에서 마지막 값이 적용될 것이다. `move_check_distance` 보다 짧은 이동은 분할없이 이전이동의 최종 Z 값이 곧바로 적용되어 이동하게 된다.
- `split_delta_z: .025` *Default 값: .025* 위에 언급된바와 같이 이것은 이동 분할 여부를 판단할 때 요구되는 최소한의 편차값이다. 이 예제에서는, +/- 0.025mm 의 편차를 가지는 Z 값은 분할이 될 것이다.

Generally the default values for these options are sufficient, in fact the default value of 5mm for the `move_check_distance` may be overkill. However an advanced user may wish to experiment with these options in an effort to squeeze out the optimal first layer.

### 메쉬 페이드

"fade" 가 실행되면 Z 보정은 설정에서 정해놓은 거리 이상으로 올라가면 서서히 사라지게 된다. 이는 베드 모양에 따라 증가 혹은 감소하면서 레이어 높이가 올라가며 작은 보정이 적용된다. 페이드가 끝마치면, Z 보정은 더이상 진행되지 않는다. 그리고 프린팅의 최종 Top면은 베드의 모양보다 훨씬 더 평평하게 될 것이다. 페이드는 좀 별로인 특징도 가지고 있다. 만약 너무 빨리 페이드하게 되면 프린팅에 눈에 띄는 불량이 형성될 수 있다. 또한, 베드가 심각하게 휘어 있는 상태였다면 페이드는 출력물의 Z 높이를 줄이거나 늘리게 할 수도 있다. 그런 이유로 페이드는 꺼져 있는게 기본설정이다.

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

- `fade_start: 1` *Default 값: 1* 보정 효과가 서서히 없어지는 시작높이. 서너개의 레이어를 출력하고 페이드 과정을 시작하는 것이 좋다.
- `fade_end: 10` *Default 값: 0* 페이드 효과를 마치는 높이. 만약 이 값이 `fade_start`보다 작다면 페이드는 꺼지게 된다. 이 값은 프린터 베드표면이 얼마나 휘어있느냐에 따라 값을 정해주면 된다. 아주 심각하게 휘어 있는 베드라면 좀더 두껍게 페이드 아웃을 진행해줘야 한다. 거의 평면에 가까운 베드라면 보다 빨리 보정이 완료되도록 이 값을 줄이면 되겠다. 만약 `fade_start`로 1을 지정했다면 10mm 값은 적당한 값이라 하겠다.
- `fade_target: 0` *Default Value: The average Z value of the mesh* The `fade_target` can be thought of as an additional Z offset applied to the entire bed after fade completes. Generally speaking we would like this value to be 0, however there are circumstances where it should not be. For example, lets assume your homing position on the bed is an outlier, its .2 mm lower than the average probed height of the bed. If the `fade_target` is 0, fade will shrink the print by an average of .2 mm across the bed. By setting the `fade_target` to .2, the homed area will expand by .2 mm, however, the rest of the bed will be accurately sized. Generally its a good idea to leave `fade_target` out of the configuration so the average height of the mesh is used, however it may be desirable to manually adjust the fade target if one wants to print on a specific portion of the bed.

### Configuring the zero reference position

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

- `zero_reference_position: ` *Default Value: None (disabled)* The `zero_reference_position` expects an (X, Y) coordinate matching that of the `reference position` described above. If the coordinate lies within the mesh then the mesh will be offset so the reference position applies zero adjustment. If the coordinate lies outside of the mesh then the coordinate will be probed after calibration, with the resulting z-value used as the z-offset. Note that this coordinate must NOT be in a location specified as a `faulty_region` if a probe is necessary.

#### The deprecated relative_reference_index

Existing configurations using the `relative_reference_index` option must be updated to use the `zero_reference_position`. The response to the [BED_MESH_OUTPUT PGP=1](#output) gcode command will include the (X, Y) coordinate associated with the index; this position may be used as the value for the `zero_reference_position`. The output will look similar to the following:

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

*Note: The above output is also printed in `klippy.log` during initialization.*

Using the example above we see that the `relative_reference_index` is printed along with its coordinate. Thus the `zero_reference_position` is `131.5, 108`.

### 결함 영역

베드 특정위치에 결함이 있는 상태에서 레벨 측정이 되었을때 어떤 위치가 부정확한 결과를 내는 곳인지 레포팅 하는것이 가능하다. 이에 대한 가장 좋은 예는 쉽게 제거할 수 있는 자석스틸시트를 사용한 베드에서 찾아볼 수 있다. 이 자석들 주변에 형성된 자기장은 인덕티브 방식의 프로브로 하여금 높이를 더 높거나 낮게 측정되게 만들 수 있다. 결과적으로 자석이 있는 표면에서는 부정확한 측정 결과를 얻게 된다. **주의: 이것을 전체 베드상에서 부정확한결과를 초래하는 프로브의 지역별 편차와 헷갈리지 말아야 한다.**

`faulty_region` 옵션은 이 영향을 보상하기 위해 설정할 수 있다. 형성된 지점이 결함 영역안에 놓인다면 베드 메쉬는 이 지역경계에 4 지점을 측정하게 될 것이다. 이렇게 측정된 값의 평균치를 얻고, 생성된 X,Y 좌표계에 메쉬의 Z 값으로 입력되게 된다.

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

- `faulty_region_{1...99}_min` `faulty_region_{1..99}_max` *Default 값: None (해제됨)* 결함영역은 메쉬위치와 같은 방식으로 정의된다. 즉, 최소/최대 (X, Y) 좌표가 각 영역별로 설정된다. 결함영역은 메쉬 바깥으로 확장될 수도 있다. 그러나, 생성된 대체포인트 들은 항상 메쉬 경계 안에 있게 될 것이다. 어떤 두개의 영역도 겹칠 수는 없다.

아래 그림은 측정해야할 메쉬 좌표가 결함영역안에 들어갈 때 어떤 대체포인트를 이용해 측정되는지를 나타낸 그림이다. 아래 그림에 나타난 좌표들은 위 예시에 정의된 위치좌표를 사용했다. 대체 포인트와 좌표값은 초록색으로 표시해두었다.

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

## 베드 메쉬 Gcode

### 캘리브레이션

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic | scan | rapid_scan] \ [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] \ [ADAPTIVE_MARGIN=<value>]` *Default Profile: default* *Default Method: automatic if a probe is detected, otherwise manual*  *Default Adaptive: 0*  *Default Adaptive Margin: 0*

메드 메쉬 캘리브레이션을 위해 프로빙 과정을 초기화하라.

The mesh will be immediately ready to use when the command completes and saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. The `METHOD` parameter takes one of the following values:

- `METHOD=manual`: enables manual probing using the nozzle and the paper test
- `METHOD=automatic`: Automatic (standard) probing. This is the default.
- `METHOD=scan`: Enables surface scanning. The tool will pause over each position to collect a sample.
- `METHOD=rapid_scan`: Enables continuous surface scanning.

XY positions are automatically adjusted to include the X and/or Y offsets when a probing method other than `manual` is selected.

측정된 영역을 수정하기 위해 메쉬 파라메터를 설정하는것이 가능하다. 아래 방법을 사용하면 된다. :

- 사각형 베드 (카테시안):
   - `MESH_MIN`
   - `MESH_MAX`
   - `PROBE_COUNT`
- 원형 베드 (델타):
   - `MESH_RADIUS`
   - `MESH_ORIGIN`
   - `ROUND_PROBE_COUNT`
- 모든 베드:
   - `MESH_PPS`
   - `ALGORITHM`
   - `ADAPTIVE`
   - `ADAPTIVE_MARGIN`

See the configuration documentation above for details on how each parameter applies to the mesh.

### 프로필

`BED_MESH_PROFILE SAVE=<name> LOAD=<name> REMOVE=<name>`

After a BED_MESH_CALIBRATE has been performed, it is possible to save the current mesh state into a named profile. This makes it possible to load a mesh without re-probing the bed. After a profile has been saved using `BED_MESH_PROFILE SAVE=<name>` the `SAVE_CONFIG` gcode may be executed to write the profile to printer.cfg.

Profiles can be loaded by executing `BED_MESH_PROFILE LOAD=<name>`.

It should be noted that each time a BED_MESH_CALIBRATE occurs, the current state is automatically saved to the *default* profile. The *default* profile can be removed as follows:

`BED_MESH_PROFILE REMOVE=default`

어떤 다른 저장된 프로필도 같은 방식으로 삭제될 수 있다. 그저 제거하기 원하는 프로필 이름을 *default* 대신에 써넣으면 된다.

#### Loading the default profile

Previous versions of `bed_mesh` always loaded the profile named *default* on startup if it was present. This behavior has been removed in favor of allowing the user to determine when a profile is loaded. If a user wishes to load the `default` profile it is recommended to add `BED_MESH_PROFILE LOAD=default` to either their `START_PRINT` macro or their slicer's "Start G-Code" configuration, whichever is applicable.

Note that this is not required if a new mesh is generated with `BED_MESH_CALIBRATE` in the `START_PRINT` macro or the slicer's "Start G-Code" and may produce unexpected results, especially with adaptive meshing.

Alternatively the old behavior of loading a profile at startup can be restored with a `[delayed_gcode]`:

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### 결과출력

`BED_MESH_OUTPUT PGP=[0 | 1]`

현재 메쉬 측정상태를 터미널에 출력한다. 메쉬 그자체가 출력됨을 기억하라

PGP 파라메터는 "Print Generated Points"의 줄임말이다. 만약 `PGP=1` 이렇게 셋팅을 하면, 생성된 측정 포인트들은 터미널에 위치결과를 내보낼 것이다.:

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

"Tool Adjusted" 포인트는 각 포인트에 대한 노즐의 위치를 말한다. 그리고 "Probe" 포인트는 프로브의 위치를 말한다. 수동으로 측정을 한다면, "Probe" 포인트는 노즐위치를 뜻함을 기억하라.

### 메쉬 상태 제거

`BED_MESH_CLEAR`

이 gcode 는 내부 메쉬 상태를 삭제하기 위해 사용된다.

### X/Y 오프셋을 적용

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
