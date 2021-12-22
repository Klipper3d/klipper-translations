# Bed leveling

打印床调平（有时也被称为 "bed tramming"）对于获得高质量的打印结果至关重要。错误"调平"的打印床会造成附着力差、"翘曲"，以及整个打印过程中的细微问题。本文档是在 Klipper 中进行调平的指南。

了解打印床调平的目标很重要。如果打印机在打印过程中被命令到`X0 Y0 Z10`的位置，那么目标是让打印机的喷嘴距离打印床正好10毫米。此外，如果打印机被命令到`X50 Z10`的位置，目标是在整个水平移动过程中，喷嘴与床面始终保持10毫米的准确距离。

为了获得良好的打印质量，打印机应进行校准，使Z轴距离的精度在约25微米（0.025毫米）。这是一个很小的距离，远小于典型人类头发的宽度。这个尺度是不能 "用眼睛 "来测量的。微妙的影响（如热膨胀）会影响这个尺度的测量。获得高精度的秘诀是使用一个可重复，高精度，并能够利用打印机自身运动系统的调平方法。

## 选择适当的校准机制

不同类型的打印机使用不同的方法来进行调平，但是所有这些方法最终都取决于“纸张测试“（如下所述）。特定类型打印机的实际调平过程在其他文档中有所描述。

在运行任何校准工具前，一定要执行在 [检查配置文档](Config_checks.md) 中 描述的检查步骤。在打印床调平前有必要验证打印机的基本运动。

对于带有“自动 Z 探针”的打印机，请务必按照 [探针校准](Probe_Calibrate.md) 文档中的说明先校准探针。对于三角洲结构的打印机，请参阅 [三角洲校准](Delta_Calibrate.md) 文档。对于带有打印床调平螺丝和传统 Z 限位的打印机，请参阅 [手动调平](Manual_Level.md) 文档。

在校准过程中，可能需要将打印机的Z `position_min`设置为一个负数（例如，`position_min = -2`）。即使在校准程序中，打印机也会执行边界检查。设置一个负数允许打印机在打印床的标称位置以下移动，这可以帮助确定实际床面位置。

## “A4纸测试法”

床调平的核心校准机制是"塞纸测试"。它涉及在打印床和喷嘴之间放置一张普通打印纸，然后将喷嘴控制到不同的Z高度，直到在来回移动纸张时感觉到适量的阻力。

即使你的打印机带有自动Z探针，理解塞纸测试依然很重要。为了保证探针的效果，它经常会需要校准。探针的校准机制也依赖塞纸测试。

为了进行塞纸测试，先用剪刀剪下一小块长方形的纸条（例如，5x3厘米）。打印纸的厚度一般为100微米（0.100mm）左右。(纸条的确切宽度并不重要.）

纸张测试的第一步是检查打印机的喷嘴和打印床。确保喷嘴和打印床面上没有塑料（或其他杂物）。

**请仔细检查喷嘴和床面，确保没有残留塑料存在！**

如果总是在一种胶带或床面上打印，可以在该胶带或床面上直接进行纸张测试。请注意，胶带本身有厚度，不同的胶带（或任何其他床面）将影响 Z 的测量。请确保用塞纸测试测量每一种使用的床面。

如果喷嘴上残留了塑料，需要先加热挤出头并用金属镊子把这些塑料去除。等到挤出机完全冷却到室温后，再继续进行纸张测试。当喷嘴正在冷却时，使用金属镊子去除任何可能漏出的塑料。

**只在喷嘴和打印床都处于室温的情况下进行塞纸测试！**

When the nozzle is heated, its position (relative to the bed) changes due to thermal expansion. This thermal expansion is typically around a 100 microns, which is about the same width as a typical piece of printer paper. The exact amount of thermal expansion isn't crucial, just as the exact width of the paper isn't crucial. Start with the assumption that the two are equal (see below for a method of determining the difference between the two widths).

It may seem odd to calibrate the distance at room temperature when the goal is to have a consistent distance when heated. However, if one calibrates when the nozzle is heated, it tends to impart small amounts of molten plastic on to the paper, which changes the amount of friction felt. That makes it harder to get a good calibration. Calibrating while the bed/nozzle is hot also greatly increases the risk of burning oneself. The amount of thermal expansion is stable, so it is easily accounted for later in the calibration process.

**使用自动化工具来确定精确的 Z 高度！**

Klipper has several helper scripts available (eg, MANUAL_PROBE, Z_ENDSTOP_CALIBRATE, PROBE_CALIBRATE, DELTA_CALIBRATE). See the documents [described above](#choose-the-appropriate-calibration-mechanism) to choose one of them.

在OctoPrint终端窗口中运行适当的命令。该脚本将在OctoPrint终端输出中提示用户互动。以下是一个例子：

```
Recv: // Starting manual Z probe. Use TESTZ to adjust position.
Recv: // Finish with ACCEPT or ABORT command.
Recv: // Z position: ?????? --> 5.000 <-- ??????
```

The current height of the nozzle (as the printer currently understands it) is shown between the "--> <--". The number to the right is the height of the last probe attempt just greater than the current height, and to the left is the last probe attempt less than the current height (or ?????? if no attempt has been made).

Place the paper between the nozzle and bed. It can be useful to fold a corner of the paper so that it is easier to grab. (Try not to push down on the bed when moving the paper back and forth.)

![paper-test](img/paper-test.jpg)

Use the TESTZ command to request the nozzle to move closer to the paper. For example:

```
TESTZ Z=-.1
```

The TESTZ command will move the nozzle a relative distance from the nozzle's current position. (So, `Z=-.1` requests the nozzle to move closer to the bed by .1mm.) After the nozzle stops moving, push the paper back and forth to check if the nozzle is in contact with the paper and to feel the amount of friction. Continue issuing TESTZ commands until one feels a small amount of friction when testing with the paper.

If too much friction is found then one can use a positive Z value to move the nozzle up. It is also possible to use `TESTZ Z=+` or `TESTZ Z=-` to "bisect" the last position - that is to move to a position half way between two positions. For example, if one received the following prompt from a TESTZ command:

```
Recv: // Z position: 0.130 --> 0.230 <-- 0.280
```

Then a `TESTZ Z=-` would move the nozzle to a Z position of 0.180 (half way between 0.130 and 0.230). One can use this feature to help rapidly narrow down to a consistent friction. It is also possible to use `Z=++` and `Z=--` to return directly to a past measurement - for example, after the above prompt a `TESTZ Z=--` command would move the nozzle to a Z position of 0.130.

After finding a small amount of friction run the ACCEPT command:

```
ACCEPT
```

This will accept the given Z height and proceed with the given calibration tool.

The exact amount of friction felt isn't crucial, just as the amount of thermal expansion and exact width of the paper isn't crucial. Just try to obtain the same amount of friction each time one runs the test.

If something goes wrong during the test, one can use the `ABORT` command to exit the calibration tool.

## Determining Thermal Expansion

After successfully performing bed leveling, one may go on to calculate a more precise value for the combined impact of "thermal expansion", "width of the paper", and "amount of friction felt during the paper test".

This type of calculation is generally not needed as most users find the simple "paper test" provides good results.

The easiest way to make this calculation is to print a test object that has straight walls on all sides. The large hollow square found in [docs/prints/square.stl](prints/square.stl) can be used for this. When slicing the object, make sure the slicer uses the same layer height and extrusion widths for the first level that it does for all subsequent layers. Use a coarse layer height (the layer height should be around 75% of the nozzle diameter) and do not use a brim or raft.

Print the test object, wait for it to cool, and remove it from the bed. Inspect the lowest layer of the object. (It may also be useful to run a finger or nail along the bottom edge.) If one finds the bottom layer bulges out slightly along all sides of the object then it indicates the nozzle was slightly closer to the bed then it should be. One can issue a `SET_GCODE_OFFSET Z=+.010` command to increase the height. In subsequent prints one can inspect for this behavior and make further adjustment as needed. Adjustments of this type are typically in 10s of microns (.010mm).

If the bottom layer consistently appears narrower than subsequent layers then one can use the SET_GCODE_OFFSET command to make a negative Z adjustment. If one is unsure, then one can decrease the Z adjustment until the bottom layer of prints exhibit a small bulge, and then back-off until it disappears.

The easiest way to apply the desired Z adjustment is to create a START_PRINT g-code macro, arrange for the slicer to call that macro during the start of each print, and add a SET_GCODE_OFFSET command to that macro. See the [slicers](Slicers.md) document for further details.
