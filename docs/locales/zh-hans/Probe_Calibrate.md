# 探针校准

该文档介绍了如何在 Klipper 中校准自动 z 探针x，y 和 z 偏移。依据本文，用户可以简单地完成 `[probe]` 或 `[bltouch]` 段落的配置。

## 探针X/Y偏移校准

为校正X、Y偏移值，首先打开OctoPrint中的“控制（control）”子页面，进行三轴的归零，然后用OctoPrint内的手调按钮将喷嘴移动到热床的中央位置。

探针下方的热床上贴上一片美纹纸（或类似的薄片）。转到OctoPrint的“命令行（Terminal）”子页，输入PROBE 命令并回车：

```
PROBE
```

在探针正下方的美纹纸上，用记号笔标注探针触发的位置（或使用其他方法记录下探针触发时的物理位置）。

在命令行中输入`GET_POSITION`命令，回车，记录下此时打印头的XY位置。输出如下：

```
Recv: // toolhead: X:46.500000 Y:27.000000 Z:15.000000 E:0.000000
```

此时，我们可以知道探针触发的X坐标为46.5，Y坐标为27。

记录下上述的坐标后，在命令行使用一系列的 G1 命令，使喷嘴移动到热床的记号的正上方。例如：

```
G1 F300 X57 Y30 Z15
```

将喷嘴移动到X 57， Y 30上。当喷嘴的位置刚好位于几号上时，在命令行键入 `GET_POSITION` 获得此时喷嘴所在的坐标。

X偏移值为 `喷嘴X坐标值 - 探针X坐标值`， 类似地， Y偏移值为 `喷嘴Y坐标值 - 探针Y坐标值`。将上述数值更新到printer.cfg文件内，掀掉热床上的美纹纸/胶带，并重启Klipper以使设置生效。

## 探针Z偏移值校准

准确的探针 z 偏移(z_offset)是高质量打印的基础。z 偏移是探针触发时探针和喷嘴之间的高度差。Klipper 中的 `PROBE_CALIBRATE`（探针校准）工具可用于测量这个值——首先，该工具会运行一次自动探测以获取探针的 z 触发位置，然后需要手动调整Z坐标以获取喷嘴碰触到热床时的 z 高度。然后将根据这些测量值计算探针的 z 偏移。

Start by homing the printer and then move the head to a position near the center of the bed. Navigate to the OctoPrint terminal tab and run the `PROBE_CALIBRATE` command to start the tool.

This tool will perform an automatic probe, then lift the head, move the nozzle over the location of the probe point, and start the manual probe tool. If the nozzle does not move to a position above the automatic probe point, then `ABORT` the manual probe tool and perform the XY probe offset calibration described above.

Once the manual probe tool starts, follow the steps described at ["the paper test"](Bed_Level.md#the-paper-test)) to determine the actual distance between the nozzle and bed at the given location. Once those steps are complete one can `ACCEPT` the position and save the results to the config file with:

```
SAVE_CONFIG
```

Note that if a change is made to the printer's motion system, hotend position, or probe location then it will invalidate the results of PROBE_CALIBRATE.

If the probe has an X or Y offset and the bed tilt is changed (eg, by adjusting bed screws, running DELTA_CALIBRATE, running Z_TILT_ADJUST, running QUAD_GANTRY_LEVEL, or similar) then it will invalidate the results of PROBE_CALIBRATE. After making any of the above adjustments it will be necessary to run PROBE_CALIBRATE again.

If the results of PROBE_CALIBRATE are invalidated, then any previous [bed mesh](Bed_Mesh.md) results that were obtained using the probe are also invalidated - it will be necessary to rerun BED_MESH_CALIBRATE after recalibrating the probe.

## 重复性测试

After calibrating the probe X, Y, and Z offsets it is a good idea to verify that the probe provides repeatable results. Start by homing the printer and then move the head to a position near the center of the bed. Navigate to the OctoPrint terminal tab and run the `PROBE_ACCURACY` command.

This command will run the probe ten times and produce output similar to the following:

```
Recv: // probe accuracy: at X:0.000 Y:0.000 Z:10.000
Recv: // and read 10 times with speed of 5 mm/s
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe accuracy results: maximum 2.519448, minimum 2.506948, range 0.012500, average 2.513198, median 2.513198, standard deviation 0.006250
```

Ideally the tool will report an identical maximum and minimum value. (That is, ideally the probe obtains an identical result on all ten probes.) However, it's normal for the minimum and maximum values to differ by one Z "step distance" or up to 5 microns (.005mm). A "step distance" is `rotation_distance/(full_steps_per_rotation*microsteps)`. The distance between the minimum and the maximum value is called the range. So, in the above example, since the printer uses a Z step distance of .0125, a range of 0.012500 would be considered normal.

If the results of the test show a range value that is greater than 25 microns (.025mm) then the probe does not have sufficient accuracy for typical bed leveling procedures. It may be possible to tune the probe speed and/or probe start height to improve the repeatability of the probe. The `PROBE_ACCURACY` command allows one to run tests with different parameters to see their impact - see the [G-Codes document](G-Codes.md) for further details. If the probe generally obtains repeatable results but has an occasional outlier, then it may be possible to account for that by using multiple samples on each probe - read the description of the probe `samples` config parameters in the [config reference](Config_Reference.md#probe) for more details.

If new probe speed, samples count, or other settings are needed, then update the printer.cfg file and issue a `RESTART` command. If so, it is a good idea to [calibrate the z_offset](#calibrating-probe-z-offset) again. If repeatable results can not be obtained then don't use the probe for bed leveling. Klipper has several manual probing tools that can be used instead - see the [Bed Level document](Bed_Level.md) for further details.

## 局部偏差确定

一些探针可能具有与位置相关的系统性偏差。比如，由于探针安装失误，探针沿Y轴移动会产生倾斜，那么探针在沿Y轴进行测量得出的结果会存在偏差。

上述状况往往出现在三角洲打印机上，然而，所有打印机均有可能发生上述状况。

我们可以在不同的XY位置上使用`PROBE_CALIBRATE`命令测量z_offset来确定位置偏差。理想情况下，z_offset在任意位置均为同一读值。

对于三角洲打印机，请尝试依次在靠近A柱、B柱和C柱的位置测量z_offset。对于龙门、corexy或类似结构打印机，尝试在热床的四个角进行z_offset的测量。

在进行上述测试前，应先按照本文档的开头部分对X、Y、Z的偏移值进行校准，然后对打印机进行归零，并将探针移动到首个目标XY位置。按照[探针Z偏移值校准](#探针Z偏移值校准)的步骤，运行`PROBE_CALIBRATE`，重复多次`TESTZ`命令，并在喷嘴触床时使用 `ACCEPT`命令，但是**切勿使用 `SAVE_CONFIG`**。手动记下此时的z_offset 。之后将探针移动到其他XY位置，重复上述的`PROBE_CALIBRATE`步骤，并分别记下z_offset。

如果上述方法中测出的最大z_offset 和最小z_offset 之间的差值大于25微米（.025mm），则该探针不适用于常规的热床调平。此时应参照 [热床调平](Bed_Level.md) 文档的手动调平部分进行调平。

## 温度偏差

对于多种形式的探针，在不同的温度下工作均具有一定的系统性偏差。比如，在高温下，探针可能总是在更低的高度下触发。

针对这种偏差，建议在恒定的温度下进行热床调平。即，要么总是在室温下进行床网测量，要么总要在工作温度下进行。无论采取哪种方案，都推荐在达到目标温度数分钟后再进行测量，以便打印机始终处于目标温度。

要测量温度偏差，首先确保打印机处于室温，对三轴进行归零，然后将打印头移动到热床中央，运行`PROBE_ACCURACY`命令。记下此时的读数。之后，在不归零或关闭电机的情况下，加热喷嘴和热床到工作温度，并再次运行`PROBE_ACCURACY`。理想情况下，两次探针测量会得出相同的结果。但若温度偏差存在，建议每次达到工作温度后再进行测量。
