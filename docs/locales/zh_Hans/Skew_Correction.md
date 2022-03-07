# 偏斜校正

基于软件的偏斜校正可以帮助解决打印机装配不完全方形造成的尺寸不准确问题。请注意，如果您的打印机严重偏斜，强烈建议在应用基于软件的校正之前，首先使用机械手段使打印机尽可能的方形。

## 打印一个校准物件

纠正偏斜的第一步是沿着你要纠正的平面打印一个[校准物件](https://www.thingiverse.com/thing:2563185/files)。还有一个[校准物件](https://www.thingiverse.com/thing:2972743)包括了一个模型中的所有平面。你需要旋转这个物件，使角A朝向平面的原点。

不要在这次打印中应用倾斜校正。你可以通过从printer.cfg中删除`[skew_correction]`模块或发送 `SET_SKEW CLEAR=1`G-Code 来实现。

## 进行测量

`[skew_correcton]` 模块需要三次对校准平面的测量值；从角 A 到角 C 的距离，从角 B 到角 D 的距离，以及从角 A 到角 D 的距离。当测量距离 AD 时，不包括一些测试物件的角上的平面。

![skew_lengths](img/skew_lengths.png)

## 配置偏斜

确保 `[skew_correction]` 已经在 printer.cfg 中。现在可以使用`SET_SKEW` G-Code 来配置 skew_correcton。例如，如果对 XY 平面测量的距离结果如下：

```
Length AC = 140.4
Length BD = 142.8
Length AD = 99.8
```

`SET_SKEW`可以配置 XY 平面的偏斜校正。

```
SET_SKEW XY=140.4,142.8,99.8
```

你也可以在 G代码中加入 XZ 和 YZ 的测量值：

```
SET_SKEW XY=140.4,142.8,99.8 XZ=141.6,141.4,99.8 YZ=142.4,140.5,99.5
```

`[skew_correction]` 模块也支持多配置管理，用法类似`[bed_mesh]`。在使用`SET_SKEW` G-Code 设置偏斜后，你可以使用`SKEW_PROFILE` G-Code来保存偏斜配置：

```
SKEW_PROFILE SAVE=my_skew_profile
```

在执行这个命令之后，Klipper 会提示你发送 `SAVE_CONFIG` G-Code 来保存配置。如果没有名为`my_skew_profile`的配置，那么一个新的配置将被创建。如果命名的配置文件存在，它将被覆盖。

保存配置后，您可以加载它：

```
SKEW_PROFILE LOAD=my_skew_profile
```

也可以删除旧的或过时的配置：

```
SKEW_PROFILE REMOVE=my_skew_profile
```

在删除一个配置文件后，Klipper 提示你发送 `SAVE_CONFIG` 以保留修改。

## 验证修正

在配置了 skew_correction 之后，你可以在启用修正的情况下重新打印校准物件。使用下面的 G-Code 来检查每个平面的偏斜。其结果应该低于通过`GET_CURRENT_SKEW`报告的结果。

```
CALC_MEASURED_SKEW AC=<ad长度> BD=<bd长度> AD=<ad长度>
```

## 注意事项

由于偏斜校正的性质，建议之在归位和任何类型的靠近打印区域边缘的运动（如清除或喷嘴擦除）完成之后的开始打印 G-Code 中配置偏斜校正。您可以使用 `SET_SKEW` 或 `SKEW_PROFILE` G-Code 来完成此操作。还建议在结束打印 G-Code 中发出 `SET_SKEW CLEAR=1`。

请记住，`[skew_correction]`有可能产生一个会使打印头在 X 和/或 Y 轴上超出打印机边界的修正。建议在使用`[skew_correction]`时将打印物件远离打印机边缘。
