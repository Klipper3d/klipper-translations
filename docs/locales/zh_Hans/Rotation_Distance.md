# 旋转距离

Klipper 上的步进电机驱动器在每个 [步进配置部分](Config_Reference.md#stepper) 中都需要一个 `rotation_distance` 参数。 `rotation_distance` 是步进电机旋转一整圈时轴移动的距离。本文档描述了如何配置此值。

## 从step_per_mm（或step_distance）获取旋转距离

你的 3D 打印机的设计师最初从旋转距离计算 `steps_per_mm `。如果您知道steps_per_mm，则可以使用此通用公式获得原始旋转距离：

```
rotation_distance = <full_steps_per_rotation> * <microsteps> / <steps_per_mm>
```

或者，如果你有一个旧版本的Klipper配置并知道`step_distance`参数，你可以使用这个公式：

```
rotation_distance = <full_steps_per_rotation> * <microsteps> * <step_distance>
```

`<full_steps_per_rotation>` 设置由步进电机的类型决定。大多数步进电机是“1.8 度步进电机”，因此每转 200 步（360 除以 1.8 等于 200）。一些步进电机是“0.9 度步进电机”，因此每转有 400 整步。其他步进电机很少见。如果不确定，请不要在配置文件中设置 full_steps_per_rotation 并在上面的公式中使用 200。

`<microsteps>`设置由取决于步进电机驱动型号。大多数驱动使用 16 个微步。如果不确定，请在配置中设置 `microsteps: 16`，并在上面的公式中使用 16。

Almost all printers should have a whole number for `rotation_distance` on X, Y, and Z type axes. If the above formula results in a rotation_distance that is within .01 of a whole number then round the final value to that whole_number.

## 校准挤出机的 rotation_distance

在挤出机上，`rotation_distance`是指步进电机旋转一圈后，耗材所走的距离。获得这一设置准确值的最好方法是使用"测量并修正"的方法。

从一个初始的旋转距离猜测值开始。可以通过[steps_per_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance)或者通过[检查硬件](#extruder)来。

然后根据以下程序执行"测量和修正"：

1. 首先确保挤出机里有耗材，热端被加热到适当的温度，并且打印机准备好挤出。
1. 用记号笔在离挤出机入口约70毫米的位置上对耗材做一个标记。然后用数字卡尺尽可能精确地测量该标记的实际距离。将此记为`<initial_mark_distance> `。
1. Extrude 50mm of filament with the following command sequence: `G91` followed by `G1 E50 F60`. Note 50mm as `<requested_extrude_distance>`. Wait for the extruder to finish the move (it will take about 50 seconds). It is important to use the slow extrusion rate for this test as a faster rate can cause high pressure in the extruder which will skew the results. (Do not use the "extrude button" on graphical front-ends for this test as they extrude at a fast rate.)
1. 使用数显卡尺测量挤出机主体与耗材上的标记之间的新距离。请注意该距离是 `<subsequent_mark_distance>`。然后计算：`actual_extrude_distance = <initial_mark_distance> - <subsequent_mark_distance>`
1. 计算running_distance为：`rotation_distance = <previous_rotation_distance> * <actual_extrude_distance> / <request_extrude_distance>`。将新的 rotation_distance 取整到小数点后3位。

如果实际挤出的距离与请求挤出的距离相差超过2毫米，那么最好再执行一次上述步骤。

注意：*不要*使用"测量并修正"类的方法来校准x、y或z类型的轴。对于这些轴来说，"测量和修剪"方法不够精确，而且可能会导致更糟糕的配置。相反，如果需要，这些轴可以通过[j检查皮带、滑轮和丝杆](#obtaining-rotation_distance-by-inspecting-the-hardware)来确定。

## 通过检查硬件获得旋转距离

有了步进电机和打印机运动学方面的信息，就可以计算旋转距离。如果不知道每毫米的步数，或者正在设计一台新的打印机，这可能有帮助。

### 皮带驱动的轴

计算使用皮带和滑轮的直线轴的旋转距离很简单。

首先确定皮带的类型。大多数打印机使用2毫米的皮带间距（也就是说，皮带上的每个齿相距2毫米）。然后计算步进电机滑轮上的齿数。然后计算出rotation_distance （旋转距离）为：

```
rotation_distance = <belt_pitch> * <number_of_teeth_on_pulley>
```

例如，如果一台打印机有一条2毫米间距的皮带并使用一个20齿的皮带轮，那么旋转距离为40。

### 使用丝杆的轴

使用以下公式可以简单的计算出常见的旋转距离：

```
rotation_distance = <screw_pitch> * <number_of_separate_threads>
```

例如，常见的"T8丝杆"的旋转距离为8（它的间距为2mm，有4个独立的螺纹）。

老式打印机的"螺纹杆"在导螺杆上只有一个"螺纹"，因此旋转距离是螺杆的间距。(例如，M6公制杆的旋转距离为1，M8杆的旋转距离为1.25。

### 挤出机

It's possible to obtain an initial rotation distance for extruders by measuring the diameter of the "hobbed bolt" that pushes the filament and using the following formula: `rotation_distance = <diameter> * 3.14`

如果挤出机使用齿轮，则还需要[确定和设置挤出机的齿轮比](#using-a-gear_ratio)。

The actual rotation distance on an extruder will vary from printer to printer, because the grip of the "hobbed bolt" that engages the filament can vary. It can even vary between filament spools. After obtaining an initial rotation_distance, use the [measure and trim procedure](#calibrating-rotation_distance-on-extruders) to obtain a more accurate setting.

## 使用 gear_ratio（齿轮比）

设置`gear_ratio`可以简化`rotation_distance`在有齿轮箱（或类似）连接的步进电机的配置。大多数步进电机没有齿轮箱--如果不确定，就不要在配置中设置`gear_ratio`。

当`gear_ratio`被设置时，`rotation_distance`代表轴在齿轮箱上的最后一个齿轮旋转一圈时的移动距离。例如，如果一个人正在使用一个具有"5:1"比率的齿轮箱，那么他可以用[对硬件的了解](#obtaining-rotation_distance-by-inspecting-the-hardware)来计算旋转距离，然后将`gear_ratio: 5:1`加入配置中。

For gearing implemented with belts and pulleys, it is possible to determine the gear_ratio by counting the teeth on the pulleys. For example, if a stepper with a 16 toothed pulley drives the next pulley with 80 teeth then one would use `gear_ratio: 80:16`. Indeed, one could open a common off the shelf "gear box" and count the teeth in it to confirm its gear ratio.

Note that sometimes a gearbox will have a slightly different gear ratio than what it is advertised as. The common BMG extruder motor gears are an example of this - they are advertised as "3:1" but actually use "50:17" gearing. (Using teeth numbers without a common denominator may improve overall gear wear as the teeth don't always mesh the same way with each revolution.) The common "5.18:1 planetary gearbox", is more accurately configured with `gear_ratio: 57:11`.

如果一个轴上使用了多个齿轮，那么在 gear_ratio 中填写一个逗号分隔的列表。例如，一个"5:1"齿轮箱驱动一个16齿的皮带轮到80齿的皮带轮，可以使用`gear_ratio: 5:1, 80:16`。

在大多数情况下，gear_ratio 应该用整数来定义，因为普通的齿轮和皮带轮上只有整数的齿。然而，在皮带利用摩擦力而不是齿来驱动皮带轮的情况下，在齿轮比中使用一个浮点数可能是有意义的（例如，`gear_ratio: 107.237:16`）。
