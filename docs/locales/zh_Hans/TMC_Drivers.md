# TMC 驱动器

这个文档提供了在Klipper上以SPI/UART模式使用Trinamic步进电机驱动器的信息。

Klipper也可以在其 "standalone mode"下使用Trinamic驱动。然而，当驱动处于这种模式时，不需要特殊的Klipper配置，本文件中讨论的高级Klipper功能也无法使用。

除了这份文档，请务必查看[TMC驱动配置参考](Config_Reference.md#tmc-stepper-driver-configuration).

## 调整电机电流

较高的驱动电流可以提高定位精度和扭矩。然而，较高的电流也会增加步进电机和步进电机驱动器产生的热量。如果步进电机驱动器太热，它就会自行失效，Klipper会报告错误。如果步进电机太热，它将失去扭矩和位置精度。(如果它变得非常热，还可能融化连接在它身上或附近的塑料部件。）

作为一般的调整建议，只要步进电机不会太热，并且步进电机驱动器不会报告警告或错误，就可以选择更高的电流值。一般来说，步进电机感到温热是可以接受的，但不应该热到触摸起来很烫手。

## 倾向于不指定保持电流（hold_current）

如果配置了 `hold_current` ，那么TMC驱动器可以在检测到步进电机没有移动时会减少步进电机的电流。然而，改变电机电流本身可能会引起电机转动。这可能是由于步进电机内部的 "阻滞力"（转子中的永久磁铁拉向定子中的铁齿）或轴滑车上的外力造成的。

对于大多数步进电机，在正常的打印过程中减少电流不会带来显著的好处，因为很少有打印动作会让步进电机空闲足够长的时间来激活 `hold_current`（保持电流）功能。而且，你也不会希望在少数使步进电机空闲足够长的时间的打印动作中引入小的打印瑕疵。

如果希望在打印预热时减少电机的电流，那么可以考虑在[START_PRINT宏](Slicers.md#klipper-gcode_macro)中写入[SET_TMC_CURRENT](G-Code.md#set_tmc_current)命令，在正常打印开始前后调整电流。

一些打印机的专用Z轴电机在正常的打印动作中是空闲的（没有床网（bed_mesh），没有床面倾斜（bed_tilt），没有Z轴倾斜校正（skew_correction），没有 "花瓶模式 （vase mode）"打印，等等），可能会发现Z轴电机在 `hold_current`的情况下确实运行得比较冷。如果实现了这一点，那么一定要考虑到在床面调平、床面探测、探针校准等过程中这种非指令性的Z轴运动。 `driver_TPOWERDOWN`和 `driver_IHOLDDELAY`也应该进行相应的校准。如果不确定，最好不要指定 `hold_current`。

## 设置 "spreadCycle "与 "stealthChop "模式

默认情况下，Klipper将TMC驱动置于 "spreadCycle "模式。如果驱动程序支持 "stealthChop"，那么可以通过添加`stealthchop_threshold: 999999`到TMC的配置部分。

一般来说，spreadCycle模式比stealthChop模式提供更大的扭矩和更高的定位精度。然而，在某些打印机上，stealthChop 模式显著降低可听到的噪音。

对两个模式的比较测试显示，在使用stealthChop模式时，恒速移动过程时有大约为一个整步75%的"位置滞后 "（例如，在一台旋转距离（rotation_distance ）为40mm、每圈200步（steps_per_rotation）的打印机上，恒速移动的位置偏差增加了约0.150mm）。然而，这种 "获得所需位置的延迟 "可能不会表现为明显的打印缺陷，大多数人可能更喜欢stealthChop模式更安静的打印。

建议总是使用 "spreadCycle "模式（通过不指定`stealthchop_threshold`）或总是使用 "stealthChop "模式（通过设置`stealthchop_threshold`为99999）。不幸的是，如果在电机处于非零速度时改变模式，驱动器往往会产生糟糕和混乱的结果。

Note that the `stealthchop_threshold` config option does not impact sensorless homing as Klipper automatically switches the TMC driver to an appropriate mode during sensorless homing operations.

## TMC插值设置引入了微小的位置偏差

TMC驱动程序的 `interpolate` 设置可以减少打印机运动的噪音，但代价是引入一个小的系统位置误差。这个系统性的位置误差是由驱动器在执行Klipper发送的 "步骤 "时的延迟造成的。在恒速移动过程中，这种延迟导致了将近一半的配置微步的位置误差（更准确地说，误差是一半的微步距离减去512分之一的整步距离）。例如，在一个旋转距离（rotation_distance）为40毫米、每圈200步（steps_per_rotation）、16微步的轴上，在恒速移动过程中引入的系统误差是~0.006毫米。

为了获得最佳的定位精度，可以考虑使用spreadCycle模式，并禁用插值（在TMC驱动配置中设置`interpolate: False` ）。当以这种方式配置时，可以增加`microstep`设置，以减少步进运动中的噪音。通常情况下，微步设置为`64`或`128`会有类似于插值的噪音水平，而且不会引入系统性的位置误差。

如果使用stealthChop模式，那么相对于从stealthChop模式引入的位置不精确性，插值的位置不精确性很小。因此，在stealthChop 模式下，调整插值是没有用的，可以将插值设置再其默认状态。

## 无限位归零

无传感器归位允许在不需要物理限位开关的情况下将一个轴归位。相反，轴上的滑车接触机械限位后，使步进电机失去步长。步进驱动器感应到失去的步数，并通过切换一个引脚向控制的微控制器（Klipper）告知这一点。该信息可被 Klipper 用作轴的限位。

本指南介绍了如何设置（笛卡尔）打印机的X轴无传感器归位。这个方法也适合其他轴（需要一个限位）。每次应该只对一个轴进行配置和调整。

### 限制

要确保你的机械部件能够承受滑车反复撞向轴的限位的负载。特别是丝杠可能会产生很大的力。通过将喷嘴撞向打印表面来确定Z轴的位置可能不是一个好主意。为了获得最佳效果，请确认轴滑车将与轴的限位紧密接触。

此外，无传感器归位对你的打印机来说可能不够精确。虽然笛卡尔机器上的X和Y轴归位可以很好地工作，但Z轴的归位通常不够准确，可能会导致第一层高度不一致。由于精度低，不建议在delta 打印机上使用无传感器的归位。

此外，步进驱动器的失速检测取决于电机的机械负载、电机电流和电机温度（线圈电阻）。

无传感器归位在电机中速时效果最好。对于非常慢的速度（小于10RPM），电机不会产生明显的反电磁场，TMC芯片不能可靠地检测到电机停顿。此外，在非常高的速度下，电机的反向电动势接近电机的电源电压，所以TMC芯片也检测不到停顿。建议你看看一下对应的TMC芯片数据手册。在手册中还可以找到更多关于这种设置的限制的细节。

### 前提条件

使用无传感器归位，需要一些前提条件：

1. 一个具有stallGuard功能的TMC步进驱动器（TMC2130、TMC2209、TMC2660或TMC5160）。
1. 需要TMC驱动器的SPI / UART接口与微控制器连接（stand-alone 模式不行）。
1. 需要把TMC驱动器的 "DIAG "或 "SG_TST "引脚连接到微控制器。
1. 必须按照[配置检查](Config_checks.md)文件中的步骤来确认步进电机的配置和运转正常。

### 调整

调整过程有六个主要步骤：

1. 选择一个归位速度。
1. 配置`printer.cfg`文件以启用无传感器归位。
1. 找到有最高灵敏度的stallguard设置，确保其成功找到零点位置。
1. 找到有最低灵敏度的stallguard 设置，确保只需轻轻一碰就能成功归零。
1. 更新`printer.cfg`，加入所需的stallguard设置。
1. 创建或更新 `printer.cfg `宏确保稳定归位（home）。

#### 选择归位速度

执行无传感器归位时，归位速度是一个重要参数。最好使用较慢的归位速度，以便滑车在与轨道限位接触时不会对框架施加过多的力。然而，TMC驱动器在非常慢的速度下并不能可靠地检测到失速。

归位速度的最佳调整起点是步进电机每两秒转一圈。对于许多轴，这就是将是 `rotation_distance` 除以2。例如：

```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### 为无传感器归位配置printer.cfg

在`stepper_x` 配置部分， `homing_retract_dist` 设置必须被设为零，以禁用第二次归位动作。在使用无传感器归位时，第二次归位尝试不会提高精度，也不会可靠地工作，而且会扰乱调整过程。

确保在配置的TMC驱动部分没有指定 `hold_current`的设置。（如果设置了hold_current，那么在接触后，当滑车撞到轨道末端时，电机就会停止，在这个位置上减少电流可能会导致滑车移动--这将导致归位性能不佳，并会扰乱调整过程。）

需要配置无传感器归位引脚，并配置初始 "stallguard "设置。一个用于X轴的tmc2209示例配置如下：

```
[tmc2209 stepper_x]
diag_pin: ^PA1      # 设置MCU引脚连接到TMC的DIAG引脚
driver_SGTHRS: 255  # 255是最敏感的值，0是最不敏感的值
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

用于tmc2130或tmc5160配置的例子如下：

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 #  连接到TMC的DIAG1引脚(或使用diag0_pin / DIAG0引脚)
driver_SGT: -64  # -64是最敏感的值，63是最不敏感的值
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

用于tmc2660配置的例子如下：

```
[tmc2660 stepper_x]
driver_SGT: -64     # -64是最敏感的值，63是最不敏感的值
...

[stepper_x]
endstop_pin: ^PA1   # 与TMC SG_TST引脚相连的引脚
homing_retract_dist: 0
...
```

上面的例子只显示了针对无传感器归位的设置。所有可用选项请参见[配置参考](Config_Reference.md#tmc-stepper-driver-configuration)。

#### 找到能成功归位的最高的敏感度设定

将滑车放在靠近轨道中心的位置。使用SET_TMC_FIELD命令来设置最高灵敏度。对于tmc2209：

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

对于tmc2130, tmc5160, and tmc2660:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

然后发出`G28 X0` 命令，确认x轴完全不动或者迅速停止移动。如果没有停止移动，则立即发出`M112`，停止打印机 - diag/sg_tst 引脚的接线或配置可能有错误，必须在继续之前予以纠正。

接下来，不断降低 `VALUE` 设置的灵敏度，并再次运行 `SET_TMC_FIELD`和`G28 X0` 命令，找到能使使滑车成功地一直移动到端点并停止的最高的灵敏度。(对于TMC2209驱动，调整是减少 SGTHRS，对于其他驱动，调整是增加 sgt)。确保每次尝试都在轨道中心附近开始（如果需要，发出`M84`，然后手动将滑车移到中心）。该方法应该可以找到可靠归位的最高灵敏度（更高的灵敏度设置会导致滑车只动一小段或完全不动）。注意找到的值为*maximum_sensitivity*。(如果在最低灵敏度（SGTHRS=0或sgt=63）下滑车也不动，那么diag/sg_tst 引脚的接线或配置可能有问题，必须在继续后面操作前予以修正。）

在寻找最大灵敏度时，更方便的是跳到不同的VALUE设置（比如将VALUE参数的一半）。如果这样做，请准备好发出 `M112`命令以停止打印机，因为灵敏度很低的设置可能会导致轴反复 "撞 "到导轨的末端。

请确保在每次归位尝试之间等待几秒钟。在TMC驱动程序检测到失速后，它可能需要一点时间来清除其内部指示器，才能够检测到下一次失速。

在调整测试中，如果`G28 X0`命令不能完全移动到轴的极限位置，那么在发出任何常规移动命令（例如，`G1`）时要小心。Klipper将不能正确定位滑块的位置，移动命令可能会导致非预期和混乱的结果。

#### 找到最低的灵敏度，只需一次接触就能归位

当用找到的*最大灵敏度*值归位时，轴应该移动到轨道的末端并 "single touch（一触即停）"--也就是说，不应该有 "咔嚓 "或 "砰 "的声音。(如果在最大灵敏度下有撞击或点击声，那么归位速度可能太低，驱动电流可能太低，或者该轴可能不适合用无传感器归位。）

下一步是再次持续移动滑块到靠近轨道中心的位置，降低灵敏度，并运行`SET_TMC_FIELD`和`G28 X0`命令 - 这次的目标是找到最低的灵敏度，仍能使滑块成功地 "一触即停"归位。也就是说，当接触到轨道的末端时，它不会发出"砰 "或 "咔"的声音。注意找到的值是*minimum_sensitivity*。

#### 更新printer.cfg中的灵敏度值

在找到*maximum_sensitivity*和*minimum_sensitivity*后，计算得到推荐的灵敏度为 *minimum_sensitivity +(maximum_sensitivity-minimum_sensitivity)/3*。推荐的灵敏度应该在最小值和最大值之间，但略微接近最小值。将最终值四舍五入到最近的整数值。

对于TMC2209，在配置中设置`driver_SGTHRS`，对于其他TMC驱动，在配置中设置`driver_SGT`。

如果*maximum_sensitivity*和*minimum_sensitivity*之间的范围很小（例如，小于5），那么可能导致不稳定的归位。更快的归位速度可以扩大范围，使操作更加稳定。

请注意，如果对驱动电流、归位速度做了任何改变，或者对打印机硬件做了明显的改变，那么就需要再次运行这个调整过程。

#### 归位时使用宏

在无传感器归位完成后，滑车将顶到导轨的末端，步进器将持续对框架施加力，直到滑车移开。最好创建一个宏来使轴归位，并立即将小车从轨道的末端移开。

在开始无传感器归位之前，宏最好暂停至少2秒（或确保步进在2秒内没有移动）。如果没有延迟，驱动器的内部失速标志有可能在之前的移动中被设置了。

使用宏在归位前设置驱动电流，并在滑车移开后设置新的电流，也会很有用。

一个宏的例子如下：

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # 为无传感器归位设置电流
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # 暂停，以确保驱动器失速标志被清除
    G4 P2000
    # 归位
    G28 X0
    # 移开
    G90
    G1 X5 F1200
    # 打印过程中设置电流
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

产生的宏可以从[homing_override配置部分](Config_Reference.md#homing_override)或[START_PRINT宏](Slicers.md#klipper-gcode_macro)中调用。

请注意，如果归位期间的驱动电流发生变化，则应重新运行调整过程。

### 在CoreXY上进行无传感器归位的技巧

可以在CoreXY打印机的X和Y行车上使用无传感器归位。Klipper使用`[stepper_x]`步进器来检测X滑车归位时的失速，使用`[stepper_y]`步进器来检测Y滑车归位时的失速。

使用上述的调谐指南，为每个滑车找到合适的 "失速灵敏度"，但要注意以下限制：

1. 当在CoreXY上使用无传感器归位时，确保没有为任何一个步进电机配置`hold_current`。
1. 在调整时，确保X和Y车架在每次归位尝试前都接近其轨道的中心。
1. 调整完成后，当X和Y轴归位时，使用宏来确保一个轴首先被归位，然后将该滑车远离轴的极限，停顿至少2秒，然后开始另一个滑车的归位。远离轴端点的移动可以避免一个轴被归位，而另一个轴顶在轴的极限上（这可能使失速检测发生偏差）。暂停是必要的，以确保驱动器的失速标志在再次归位之前被清除。

CoreXY 归位宏示例：

```
[gcode_macro HOME]
gcode:
    G90
    # 归位Z
    G28 Z0
    G1 Z10 F1200
    # 归位Y
    G28 Y0
    G1 Y5 F1200
    # 归位X
    G4 P2000
    G28 X0
    G1 X5 F1200
```

## 查询和诊断驱动程序设置

`[DUMP_TMC 命令](G-Code.md#dump_tmc)是配置和诊断驱动程序的有效工具。它将报告所有由Klipper配置的字段，以及所有可以从驱动中查询到的字段。

所有报告的字段都定义在驱动器的Trinamic数据手册中。这些数据表可以在[Trinamic网站](https://www.trinamic.com/)上找到。请获取并查看驱动器的Trinamic数据手册来解释DUMP_TMC的结果。

## 配置driver_XXX设置

Klipper支持使用`driver_XXX`设置来配置许多底层驱动程序字段。[TMC驱动配置参考](Config_Reference.md#tmc-stepper-driver-configuration)有每种类型的驱动可用字段的完整列表。

此外，几乎所有的字段都可以在运行时使用[SET_TMC_FIELD命令](G-Codes.md#set_tmc_field)进行修改。

每一个字段都在驱动器的Trinamic数据手册中有定义。这些数据表可以在[Trinamic网站](https://www.trinamic.com/)上找到。

请注意，Trinamic的数据表中，有时一些词可能导致在高层设置（如 "hysteresis end"）和底层字段值（如 "HEND"）的混乱。在Klipper中，`driver_XXX`和SET_TMC_FIELD总是设置实际写入驱动器的底层次字段值。例如，如果Trinamic的数据表指出，需要将3的值写入HEND字段，以使得 "hysteresis end"等于0，那么设置`driver_HEND=3`使得高层获得0的值。

## 常见问题

### 我可以在有压力推进（pressure advance）的挤出机上使用stealthChop 模式吗？

许多人成功地在 "stealthChop "模式下使用了Klipper的压力推进。Klipper实现了[平滑压力推进](Kinematics.md#pressure-advance)，它不会引入任何瞬时速度变化。

然而，"stealthChop "模式可能导致较低的电机扭矩和/或产生较高的电机热量。对于你的特定打印机来说，它可能是也可能不是一个合适的模式。

### 我一直得到 "Unable to read tmc uart 'stepper_x' register IFCNT "的错误？

这种情况发生在Klipper无法与tmc2208或tmc2209驱动通信时。

确保电机电源启用，因为步进电机驱动器在与微控制器通信之前一般需要确保电机先上电。

如果这个错误是在第一次刷写Klipper后发生的，那么步进驱动器可能处在一个状态，此状态与刚刚写入的Klipper不兼容。要重置该状态，请将打印机的所有电源拔掉几秒钟（物理上拔掉USB插头和电源插头）。

否则，这种错误通常是由于UART引脚接线不正确或Klipper配置的UART引脚设置不正确造成的。

### 我一直得到 "Unable to write tmc spi 'stepper_x' register ..."的错误？

当Klipper无法与tmc2130或tmc5160驱动通信时就会出现这种情况。

确保电机电源启用，因为步进电机驱动器在与微控制器通信之前一般需要确保电机先上电。

否则，这种错误通常是由于SPI接线不正确、Klipper对SPI设置的配置不正确或SPI总线上的设备配置不完整造成的。

请注意，如果驱动器是在挂多个设备共享的SPI总线上，那么一定要在Klipper中完全配置该共享SPI总线上的每个设备。如果共享SPI总线上的一个设备没有被配置，那么它可能会错误地响应不是为它准备的命令，并破坏与目标设备的通信。如果在共享的SPI总线上有不能在Klipper中配置的设备，那么使用[static_digital_output config section](Config_Reference.md#static_digital_output)将未使用的设备的CS引脚设置为高电平（这样它就不会试图使用SPI总线）。电路板的原理图通常是一个有用的参考，原理图上可以找到哪些设备挂在SPI总线上以及它们的相关引脚。

### 为什么我得到一个 "TMC reports error: ..."错误？

这类型的错误表明TMC驱动器检测到了一个问题，并且已经自我禁用。也就是说，驱动器已经停止了保持位置，并忽略了移动命令。如果Klipper检测到一个激活的驱动器已经自我禁用，它就会把打印机切换到 "关闭 "状态。

也有可能由于SPI错误导致无法与驱动器通信而发生**TMC reports error**导致的关机（在tmc2130、tmc5160或tmc2660上）。如果发生这种情况，报告的驱动器状态通常会显示 "00000000 "或 "ffffff"--例如：`TMC reports error: DRV_STATUS: ffffffff ...`或者`TMC reports error: READRSP@RDSEL2: 00000000 ...`。这样的故障可能是由于SPI的接线问题，也可能是由于TMC驱动器的自复位或故障导致的。

一些常见的错误和诊断的技巧：

#### TMC 报告错误： `... ot=1(OvertempError!)`

这表明电机驱动器因温度过高而自我禁用。典型的解决方案是降低步进电机的电流，增加步进电机驱动器的冷却，和/或增加步进电机的冷却。

#### TMC 报告错误：`... ShortToGND`（接地短路）或 `ShortToSupply`（与电源短路）

这表明驱动器已自行禁用，因为它检测到通过驱动器的电流非常高。这可能表明连接到步进电机或者部件电机内部的电线松动或短路了。

如果使用stealthChop模式，并且TMC驱动器不能准确地预测电机的机械负载，也可能发生这种错误。(如果驱动器预测不准确，那么它可能输出过高电流到电机，并触发自己的过电流检测)。要测试这个，请禁用stealthChop模式，再检查错误是否继续发生。

#### TMC报告错误：`... reset=1(Reset)` 或`CS_ACTUAL=0(Reset?)` 或`SE=0(Reset?)`

这表明驱动器在打印过程中自我复位。这可能是由于电压或接线问题导致的。

#### TMC 报告错误： `... uv_cp=1(Undervoltage!)`

这表明驱动器检测到了一个电压低事件，并已自行禁用。这可能是由于接线或电源问题导致的。

### 我如何在我的驱动器上调整 spreadCycle/coolStep等模式？

[Trinamic网站](https://www.trinamic.com/)有关于配置驱动程序的指南。这些指南通常是专业、底层且可能需要专用的硬件。不管怎么说，它们是最好的信息来源。
