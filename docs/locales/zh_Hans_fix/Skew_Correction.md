# 斜度校正

基于软件的斜度校正可以帮助解决由于打印机装配不完全方正而导致的尺寸不准确问题。请注意，如果您的打印机存在明显的斜度，强烈建议首先通过机械手段尽可能将打印机调整为方正，然后再应用基于软件的校正。

## 打印校准件

校正斜度的第一步是沿着您想要校正的平面打印一个[校准件](https://www.thingiverse.com/thing:2563185/files)。也有一个[校准件](https://www.thingiverse.com/thing:2972743)，它在一个模型中包含了所有平面。您需要将校准件的方向摆放正确，使角A朝向该平面的原点。

确保在此打印过程中未应用任何斜度校正。您可以通过从`printer.cfg`中移除`[skew_correction]`模块，或发出`SET_SKEW CLEAR=1` G代码来实现。

## 进行测量

`[skew_correction]`模块要求对每个您想要校正的平面进行3次测量：从角A到角C的长度、从角B到角D的长度，以及从角A到角D的长度。测量AD长度时，请勿包含某些测试件角上提供的平面部分。

[skew_lengths](img/skew_lengths.png)

## 配置您的斜度

确保`[skew_correction]`已在`printer.cfg`中。现在您可以使用`SET_SKEW` G代码来配置斜度校正。例如，如果在XY平面上测得的长度如下：

```
长度 AC = 140.4
长度 BD = 142.8
长度 AD = 99.8
```

可以使用`SET_SKEW`为XY平面配置斜度校正。

```
SET_SKEW XY=140.4,142.8,99.8
```

您也可以在G代码中添加XZ和YZ的测量值：

```
SET_SKEW XY=140.4,142.8,99.8 XZ=141.6,141.4,99.8 YZ=142.4,140.5,99.5
```

`[skew_correction]`模块还支持类似于`[bed_mesh]`的配置文件管理。在使用`SET_SKEW` G代码设置斜度后，您可以使用`SKEW_PROFILE` G代码来保存它：

```
SKEW_PROFILE SAVE=my_skew_profile
```

执行此命令后，系统会提示您发出`SAVE_CONFIG` G代码，以将配置文件保存到持久存储中。如果不存在名为`my_skew_profile`的配置文件，则会创建一个新配置文件。如果命名的配置文件已存在，则会被覆盖。

一旦保存了配置文件，您就可以加载它：

```
SKEW_PROFILE LOAD=my_skew_profile
```

也可以删除一个旧的或过时的配置文件：

```
SKEW_PROFILE REMOVE=my_skew_profile
```

删除配置文件后，系统会提示您发出`SAVE_CONFIG`以使此更改持久化。

## 验证您的校正

配置斜度校正后，您可以重新打印校准件，并启用校正功能。使用以下G代码检查每个平面上的斜度。结果应低于`GET_CURRENT_SKEW`报告的数值。

```
CALC_MEASURED_SKEW AC=<ac_length> BD=<bd_length> AD=<ad_length>
```

## 注意事项

由于斜度校正的性质，建议在启动G代码中配置斜度，即在回零以及任何靠近打印区域边缘移动（如喷嘴清理或擦拭）之后进行。您可以使用`SET_SKEW`或`SKEW_PROFILE` G代码来实现这一点。同样，建议在结束G代码中发出`SET_SKEW CLEAR=1`。

请记住，`[skew_correction]`有可能生成一个使工具在X和/或Y轴上超出打印机边界的校正值。因此，建议在使用`[skew_correction]`时，将打印件远离边缘放置。