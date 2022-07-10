# 手动调平

本文介绍了用于校准Z限位和对打印床调品螺丝进行调整的工具。

## 校准 Z 限位

准确的 Z 轴限位位置对于获得高质量打印至关重要。

请注意，Z 限位开关本身的精度限制了调平的精度。如果使用 Trinamic 步进电机驱动，那么可以考虑启用[限位相位](Endstop_Phase.md)检测以提高开关的精度。

要进行Z轴限位校准，请归位打印机，命令打印头移动到离床身至少5毫米的Z轴位置（如果还没有），命令打印头移动到靠近床身中心的XY位置，然后到OctoPrint终端中并且运行：

```
Z_ENDSTOP_CALIBRATE
```

塞纸测试然后按照["塞纸测试"](Bed_Level.md#the-paper-test)描述的步骤，确定喷嘴和床身在给定位置的实际距离。一旦这些步骤完成，就可以`ACCEPT`该位置，并将结果保存到配置文件中：

```
SAVE_CONFIG
```

最好是在Z轴与加热床面之间使用Z限位开关（远离床面的限位开关更加稳定安全，因为这样的话，Z轴的原点通常是安全的）。然而，如果必须向加热床归位，建议调整限位开关，使其在加热床床面上方一小段距离（例如0.5毫米）触发。几乎所有的限位开关都可以在触发点以外的一小段距离安全地压下。当这样做时，你会发现`Z_ENDSTOP_CALIBRATE`命令输出一个小的正值（比如0.5毫米）的Z限位位置。

某些打印机能够手动调整限位开关的物理位置，但是建议使用 Klipper 在软件中执行 Z 限位定位-在将限位的物理位置固定于方便微调的位置，就可以通过运行 Z_ENDSTOP_CALIBRATE 或通过手动更新配置文件中的 Z position_endstop 来进行进一步的调整。

## 调整打印调平螺丝

使用打印床调平螺丝获得平整打印床的秘诀是在床身调平过程中利用打印机高精度的运动系统，通过将喷嘴命令到每个调平螺丝附近的位置，然后调整该螺丝直到床与喷嘴保持固定的距离。Klipper 的一个内置工具可以协助解决这个问题。为了使用该工具，必须指定每个螺丝的XY坐标。

这是通过创建一个`[bed_screws]`配置部分来实现的。例如，它可能看起来类似于以下内容:

```
[bed_screws]
screw1: 100, 50
screw2: 100, 150
screw3: 150, 100
```

如果床头调平螺丝在床下，则指定调平螺丝正上方的XY位置。如果螺钉在床身外，则指定一个最接近调平螺丝的XY位置，但仍在床身的范围内。

一旦配置文件准备好了，运行`RESTART`来加载该配置，然后就可以通过运行以下命令使用工具:

```
BED_SCREWS_ADJUST
```

这个工具将把打印机的喷嘴移动到每个调平螺丝的XY位置，然后把喷嘴移动到Z=0的高度。在这一点上，可以使用"纸张测试"来直接调整喷嘴下方的热床调平螺母。参见["纸张测试"](Bed_Level.md#the-paper-test)中描述的信息，但要调整的是热床螺母而不是指定喷头到不同的高度。调整热床调平螺母，直到来回推送纸张时有少量的摩擦。

一旦螺丝被调整到可以感觉到少量的摩擦，运行`ACCEPT`或者`ADJUSTED`命令。如果床身螺丝需要调整（通常是任何超过1/8圈的转动），使用`ADJUSTED`命令。如果没有必要进行重大调整，则使用`ACCEPT`命令。这两条命令都会使工具进入下一个螺丝。(当使用`ADJUSTED`命令时，工具将安排一个额外的床身螺钉调整周期；当所有热床调平螺丝被确认不需要任何重大调整时，工具成功完成。)也可以使用`ABORT`命令来提前退出工具。

这个系统在打印机有一个平整的打印表面（如玻璃）并有笔直的导轨时效果最好。在成功完成打印床调平工具后，热床应该准备好进行打印。

### 细颗粒热床调平螺丝调整

如果打印机使用三个热床调平螺丝，并且所有三个调平螺丝都在热床下面，那么就有可能执行第二个"高精度"热床调平步骤。这是通过命令喷头到热床当在每次调整床身时移动较大距离的位置来实现的。

例如，考虑一张在A B C位置有螺丝的打印平台：

![bed_screws](img/bed_screws.svg.png)

在位于C位置的螺丝每次调整间，打印床/打印头将沿着由其余两个螺丝定义的坐标摆锤摆动（此处显示为绿线）。在这种情况下，每次调整C处的床螺钉都会使打印床在位置D处移动比在C处移动更多的量。因此，可以通过将喷嘴置于D位置进行对C位置螺丝的精确调整。

要启用此功能，需要定义额外的喷嘴坐标并将其添加到配置文件中。例如：

```
[bed_screws]
screw1: 100, 50
screw1_fine_adjust: 0, 0
screw2: 100, 150
screw2_fine_adjust: 300, 300
screw3: 150, 100
screw3_fine_adjust: 0, 100
```

当此功能被启用时，`BED_SCREWS_ADJUST`工具将先提示在每个螺钉位置正上方进行粗调，一旦这些被接受，它将提示在其他位置进行细调。继续在每个位置使用`ACCEPT`和`ADJUSTED`。

## 使用打印床探针调整打印床调平螺丝

这是用打印床探头调平的另一种方法。要使用它，你必须有一个Z探针（BL Touch，电感式传感器等）。

要启用该功能，先要确定喷嘴坐标，使Z探头位于螺丝上方，然后将其添加到配置文件中。例如，它可能看起来像：

```
[screws_tilt_adjust]
screw1: -5, 30
screw1_name: front left screw
screw2: 155, 30
screw2_name: front right screw
screw3: 155, 190
screw3_name: rear right screw
screw4: -5, 190
screw4_name: rear left screw
horizontal_move_z: 10.
speed: 50.
screw_thread: CW-M3
```

The screw1 is always the reference point for the others, so the system assumes that screw1 is at the correct height. Always run `G28` first and then run `SCREWS_TILT_CALCULATE` - it should produce output similar to:

```
Send: G28
Recv: ok
Send: SCREWS_TILT_CALCULATE
Recv: // 01:20 means 1 full turn and 20 minutes, CW=clockwise, CCW=counter-clockwise
Recv: // front left screw (base) : x=-5.0, y=30.0, z=2.48750
Recv: // front right screw : x=155.0, y=30.0, z=2.36000 : adjust CW 01:15
Recv: // rear right screw : y=155.0, y=190.0, z=2.71500 : adjust CCW 00:50
Recv: // read left screw : x=-5.0, y=190.0, z=2.47250 : adjust CW 00:02
Recv: ok
```

这意味着：

- front left screw is the reference point you must not change it.
- front right screw must be turned clockwise 1 full turn and a quarter turn
- rear right screw must be turned counter-clockwise 50 minutes
- rear left screw must be turned clockwise 2 minutes (not need it's ok)

Note that "minutes" refers to "minutes of a clock face". So, for example, 15 minutes is a quarter of a full turn.

重复这个过程几次，直到打印床变得足够水平--通常情况下，这意味着所有的位置需要的调整都小于6分钟。

如果使用安装在热端侧面的探头（即它有一个X或Y偏移），那么请注意，调整床身倾斜度将使以前在倾斜的床身下进行的任何探针校准失效。一定要在调整打印床螺丝后运行[探针校准](Probe_Calibrate.md)。

The `MAX_DEVIATION` parameter is useful when a saved bed mesh is used, to ensure that the bed level has not drifted too far from where it was when the mesh was created. For example, `SCREWS_TILT_CALCULATE MAX_DEVIATION=0.01` can be added to the custom start gcode of the slicer before the mesh is loaded. It will abort the print if the configured limit is exceeded (0.01mm in this example), giving the user a chance to adjust the screws and restart the print.

The `DIRECTION` parameter is useful if you can turn your bed adjustment screws in one direction only. For example, you might have screws that start tightened in their lowest (or highest) possible position, which can only be turned in a single direction, to raise (or lower) the bed. If you can only turn the screws clockwise, run `SCREWS_TILT_CALCULATE DIRECTION=CW`. If you can only turn them counter-clockwise, run `SCREWS_TILT_CALCULATE DIRECTION=CCW`. A suitable reference point will be chosen such that the bed can be leveled by turning all the screws in the given direction.
