# TMC 驱动程序

本文档提供了在 Klipper 中使用 Trinamic 步进电机驱动器的 SPI/UART 模式的相关信息。

Klipper 也可以在驱动器的“独立模式”下使用 Trinamic 驱动器。然而，在这种模式下，无需特殊的 Klipper 配置，并且本文档中讨论的高级 Klipper 功能将不可用。

除了本文档外，请务必查阅 [TMC 驱动器配置参考](Config_Reference.md#tmc-stepper-driver-configuration)。

## 调整电机电流

更高的驱动器电流可提高定位精度和扭矩。然而，更高的电流也会增加步进电机和步进电机驱动器产生的热量。如果步进电机驱动器过热，它将自行禁用，Klipper 将报告错误。如果步进电机过热，它会失去扭矩和定位精度。（如果温度非常高，还可能熔化与其或附近连接的塑料部件。）

作为一般调谐技巧，只要步进电机不会过热且步进电机驱动器不报告警告或错误，就倾向于使用更高的电流值。通常，步进电机感觉温热是可以的，但不应热到触摸时感到疼痛。

## 建议不要指定 `hold_current`

如果配置了 `hold_current`，则 TMC 驱动器可以在检测到步进电机未移动时降低流向步进电机的电流。然而，改变电机电流本身可能会引入电机运动。这可能是由于步进电机内部的“齿槽力”（转子中的永磁体被定子中的铁齿吸引）或由于轴滑块上的外部力引起的。

大多数步进电机在正常打印期间减少电流不会获得显著的好处，因为很少有打印移动会使步进电机空闲足够长的时间以激活 `hold_current` 功能。而且，不太可能希望为那些确实使步进电机空闲足够长时间的少数打印移动引入细微的打印瑕疵。

如果希望在打印启动例程期间降低电机电流，则考虑在 [START_PRINT 宏](Slicers.md#klipper-gcode_macro) 中发出 [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) 命令，在正常打印移动之前和之后调整电流。

一些打印机具有专用的 Z 轴电机，在正常打印移动期间处于空闲状态（无 bed_mesh、无 bed_tilt、无 Z skew_correction、无“花瓶模式”打印等），可能会发现 Z 轴电机在使用 `hold_current` 时运行更凉爽。如果实施此功能，则务必考虑在调平床、探测床、探头校准和类似操作期间这种类型的非指令性 Z 轴移动。还应相应地校准 `driver_TPOWERDOWN` 和 `driver_IHOLDDELAY`。如果不确定，建议不要指定 `hold_current`。

## 设置“spreadCycle”与“stealthChop”模式

默认情况下，Klipper 将 TMC 驱动器置于“spreadCycle”模式。如果驱动器支持“stealthChop”，则可以通过在 TMC 配置部分添加 `stealthchop_threshold: 999999` 来启用它。

通常，spreadCycle 模式比 stealthChop 模式提供更大的扭矩和更高的定位精度。然而，stealthChop 模式在某些打印机上可能产生显著更低的可听噪声。

比较模式的测试表明，在恒定速度移动期间使用 stealthChop 模式时，“位置滞后”增加了约 75% 的全步长（例如，在旋转距离为 40mm、每转 200 步的打印机上，恒定速度移动的位置偏差增加了约 0.150mm）。然而，这种“到达请求位置的延迟”可能不会表现为显著的打印缺陷，用户可能更喜欢 stealthChop 模式的静音行为。

建议始终使用“spreadCycle”模式（不指定 `stealthchop_threshold`）或始终使用“stealthChop”模式（将 `stealthchop_threshold` 设置为 999999）。不幸的是，当电机处于非零速度时，如果模式发生变化，驱动器通常会产生不良和混淆的结果。

请注意，`stealthchop_threshold` 配置选项不会影响无传感器归位，因为 Klipper 在无传感器归位操作期间会自动将 TMC 驱动器切换到适当的模式。

## TMC 插值设置引入微小位置偏差

TMC 驱动器的 `interpolate` 设置可能会减少打印机移动时的可听噪声，但代价是引入微小的系统性位置误差。这种系统性位置误差源于驱动器执行 Klipper 发送给它的“步进”指令的延迟。在恒定速度移动期间，这种延迟导致的位置误差接近于配置的微步的一半（更准确地说，误差是半个微步距离减去 512 分之一个全步距离）。例如，在旋转距离为 40mm、每转 200 步、16 微步的轴上，恒定速度移动期间引入的系统性误差约为 0.006mm。

为了获得最佳定位精度，考虑使用 spreadCycle 模式并禁用插值（在 TMC 驱动器配置中设置 `interpolate: False`）。这样配置后，可以增加 `microstep` 设置以减少步进电机移动时的可听噪声。通常，`64` 或 `128` 的微步设置将具有与插值相似的可听噪声，并且不会引入系统性位置误差。

如果使用 stealthChop 模式，则插值引起的位置不准确性相对于 stealthChop 模式引入的位置不准确性来说很小。因此，在 stealthChop 模式下，调整插值被认为没有用处，可以将插值保持在其默认状态。

## 无传感器归位

无传感器归位允许在没有物理限位开关的情况下对轴进行归位。相反，轴上的滑块被移动到机械极限，使步进电机失步。步进驱动器检测到失步并向控制 MCU（Klipper）指示，通过切换一个引脚。Klipper 可以使用此信息作为该轴的限位开关。

本指南涵盖为您的（笛卡尔）打印机的 X 轴设置无传感器归位。然而，它与其他所有轴（需要限位开关的轴）的工作方式相同。您应该一次为一个轴进行配置和调谐。

### 限制

确保您的机械部件能够承受滑块反复撞击轴极限的负载。特别是丝杠可能会产生很大的力。通过将喷嘴撞击打印表面来对 Z 轴进行归位可能不是一个好主意。为了获得最佳效果，请验证轴滑块将牢固地接触轴极限。

此外，无传感器归位可能对您的打印机来说不够准确。虽然在笛卡尔机器上对 X 和 Y 轴进行归位可以很好地工作，但对 Z 轴进行归位通常不够准确，可能导致第一层高度不一致。由于缺乏准确性，不建议对 delta 打印机进行无传感器归位。

此外，步进驱动器的失速检测取决于电机上的机械负载、电机电流和电机温度（线圈电阻）。

无传感器归位在中等电机速度下效果最佳。对于非常慢的速度（小于 10 RPM），电机不会产生显著的反电动势，TMC 无法可靠地检测电机失速。此外，在非常高的速度下，电机的反电动势接近电机的供电电压，因此 TMC 无法再检测失速。建议查看您特定 TMC 的数据手册。您还可以在那里找到有关此设置限制的更多详细信息。

### 先决条件

使用无传感器归位需要一些先决条件：

1. 支持 stallGuard 的 TMC 步进电机驱动器（tmc2130、tmc2209、tmc2660 或 tmc5160）。
2. TMC 驱动器的 SPI / UART 接口连接到微控制器（独立模式不起作用）。
3. TMC 驱动器的适当“DIAG”或“SG_TST”引脚连接到微控制器。
4. 必须运行 [配置检查](Config_checks.md) 文档中的步骤，以确认步进电机已正确配置和工作。

### 调谐

此处描述的过程有六个主要步骤：

1. 选择归位速度。
2. 配置 `printer.cfg` 文件以启用无传感器归位。
3. 找到成功归位的最高灵敏度的 stallguard 设置。
4. 找到成功单次触碰归位的最低灵敏度的 stallguard 设置。
5. 使用所需的 stallguard 设置更新 `printer.cfg`。
6. 创建或更新 `printer.cfg` 宏以一致地归位。

#### 选择归位速度

归位速度在执行无传感器归位时是一个重要的选择。理想情况下使用较慢的归位速度，以便滑块在接触轨道末端时不会对框架施加过大的力。然而，TMC 驱动器在非常慢的速度下无法可靠地检测失速。

归位速度的一个良好起点是步进电机每两秒完成一次完整旋转。对于许多轴，这将是 `rotation_distance` 除以二。例如：
```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### 为无传感器归位配置 printer.cfg

必须将 `stepper_x` 配置部分中的 `homing_retract_dist` 设置为零，以禁用第二次归位移动。使用无传感器归位时，第二次归位尝试没有价值，它不会可靠地工作，并且会混淆调谐过程。

确保在配置的 TMC 驱动器部分中未指定 `hold_current` 设置。（如果设置了 hold_current，则在接触后，电机停止，而滑块被压在轨道末端，此时降低该位置的电流可能会导致滑块移动 - 这会导致性能不佳并混淆调谐过程。）

需要配置无传感器归位引脚并配置初始“stallguard”设置。X 轴的 tmc2209 示例配置可能如下所示：
```
[tmc2209 stepper_x]
diag_pin: ^PA1      # 设置为连接到 TMC DIAG 引脚的 MCU 引脚
driver_SGTHRS: 255  # 255 是最敏感值，0 是最不敏感值
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

tmc2130 或 tmc5160 配置示例可能如下所示：
```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # 连接到 TMC DIAG1 引脚的引脚（或使用 diag0_pin / DIAG0 引脚）
driver_SGT: -64  # -64 是最敏感值，63 是最不敏感值
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

tmc2660 配置示例可能如下所示：
```
[tmc2660 stepper_x]
driver_SGT: -64     # -64 是最敏感值，63 是最不敏感值
...

[stepper_x]
endstop_pin: ^PA1   # 连接到 TMC SG_TST 引脚的引脚
homing_retract_dist: 0
...
```

上面的示例仅显示了与无传感器归位相关的设置。有关所有可用选项，请参阅 [配置参考](Config_Reference.md#tmc-stepper-driver-configuration)。

#### 找到成功归位的最高灵敏度

将滑块放置在轨道中心附近。使用 SET_TMC_FIELD 命令设置最高灵敏度。对于 tmc2209：
```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```
对于 tmc2130、tmc5160 和 tmc2660：
```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

然后发出 `G28 X0` 命令，并验证轴根本不移动或迅速停止移动。如果轴没有停止，则发出 `M112` 以停止打印机 - 某些地方的 diag/sg_tst 引脚接线或配置不正确，必须在继续之前纠正。

接下来，持续降低 `VALUE` 设置的灵敏度，并再次运行 `SET_TMC_FIELD` `G28 X0` 命令，以找到导致滑块成功移动到限位开关并停止的最高灵敏度。（对于 tmc2209 驱动器，这将是降低 SGTHRS，对于其他驱动器，这将是增加 sgt。）确保每次尝试都从滑块靠近轨道中心开始（如果需要，发出 `M84`，然后手动将滑块移动到中心）。应该能够找到可靠归位的最高灵敏度（更高灵敏度的设置会导致小移动或无移动）。将找到的值记为 *maximum_sensitivity*。（如果在没有任何滑块移动的情况下获得最小可能灵敏度（SGTHRS=0 或 sgt=63），则某些地方的 diag/sg_tst 引脚接线或配置不正确，必须在继续之前纠正。）

在搜索最大灵敏度时，跳到不同的 VALUE 设置（以便对 VALUE 参数进行二分法）可能会很方便。如果这样做，请准备好发出 `M112` 命令以停止打印机，因为灵敏度非常低的设置可能会导致轴反复“撞击”轨道末端。

确保每次归位尝试之间等待几秒钟。TMC 驱动器检测到失速后，可能需要一点时间来清除其内部指示器并能够检测另一次失速。

在这些调谐测试期间，如果 `G28 X0` 命令没有完全移动到轴极限，则在发出任何常规移动命令（例如 `G1`）时要小心。Klipper 将没有滑块位置的正确理解，移动命令可能会导致不良和混淆的结果。

#### 找到单次触碰归位的最低灵敏度

使用找到的 *maximum_sensitivity* 值归位时，轴应移动到轨道末端并停止，且为“单次触碰” - 即，不应有“咔嗒”或“撞击”声。（如果在最大灵敏度下有撞击或咔嗒声，则归位速度可能太低，驱动器电流可能太低，或无传感器归位可能不是该轴的好选择。）

下一步是再次将滑块移动到轨道中心附近的位置，降低灵敏度，并运行 `SET_TMC_FIELD` `G28 X0` 命令 - 现在的目标是找到仍然导致滑块成功单次触碰归位的最低灵敏度。也就是说，它在接触轨道末端时不会“撞击”或“咔嗒”。将找到的值记为 *minimum_sensitivity*。

#### 使用灵敏度值更新 printer.cfg

在找到 *maximum_sensitivity* 和 *minimum_sensitivity* 后，使用计算器计算推荐灵敏度为 *minimum_sensitivity + (maximum_sensitivity - minimum_sensitivity)/3*。推荐的灵敏度应在最小值和最大值之间，但略接近最小值。将最终值四舍五入到最接近的整数。

对于 tmc2209，在配置中将其设置为 `driver_SGTHRS`，对于其他 TMC 驱动器，在配置中将其设置为 `driver_SGT`。

如果 *maximum_sensitivity* 和 *minimum_sensitivity* 之间的范围很小（例如，小于 5），则可能导致归位不稳定。更快的归位速度可能会增加范围并使操作更稳定。

请注意，如果对驱动器电流、归位速度或打印机硬件进行了任何更改，则需要再次运行调谐过程。

#### 归位时使用宏

无传感器归位完成后，滑块将被压在轨道末端，步进电机将在滑块移开之前对框架施加力。创建一个宏来归位轴并立即将滑块从轨道末端移开是个好主意。

宏在开始无传感器归位之前至少暂停 2 秒钟（或以其他方式确保过去 2 秒内步进电机没有移动）是个好主意。如果没有延迟，驱动器的内部失速标志可能仍然从之前的移动中设置。

该宏在归位前设置驱动器电流并在滑块移开后设置新电流也可能有用。

示例宏可能如下所示：
```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # 为无传感器归位设置电流
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # 暂停以确保驱动器失速标志已清除
    G4 P2000
    # 归位
    G28 X0
    # 移开
    G90
    G1 X5 F1200
    # 设置打印期间的电流
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

生成的宏可以从 [homing_override 配置部分](Config_Reference.md#homing_override) 或从 [START_PRINT 宏](Slicers.md#klipper-gcode_macro) 调用。

请注意，如果归位期间的驱动器电流发生变化，则应再次运行调谐过程。

### CoreXY 上无传感器归位的提示

可以在 CoreXY 打印机的 X 和 Y 滑块上使用无传感器归位。Klipper 使用 `[stepper_x]` 步进电机在归位 X 滑块时检测失速，并使用 `[stepper_y]` 步进电机在归位 Y 滑块时检测失速。

使用上述调谐指南找到每个滑块的适当“失速灵敏度”，但请注意以下限制：
1. 在 CoreXY 上使用无传感器归位时，确保两个步进电机都没有配置 `hold_current`。
2. 调谐时，确保每次归位尝试前 X 和 Y 滑块都靠近其轨道中心。
3. 调谐完成后，在归位 X 和 Y 时，使用宏确保一个轴首先归位，然后将该滑块从轴极限移开，暂停至少 2 秒钟，然后开始另一个滑块的归位。从轴极限移开可避免在一个轴被压在轴极限时归位另一个轴（这可能会使失速检测偏斜）。暂停是必要的，以确保在再次归位前驱动器的失速标志已清除。

示例 CoreXY 归位宏可能如下所示：
```
[gcode_macro HOME]
gcode:
    G90
    # 归位 Z
    G28 Z0
    G1 Z10 F1200
    # 归位 Y
    G28 Y0
    G1 Y5 F1200
    # 归位 X
    G4 P2000
    G28 X0
    G1 X5 F1200
```

## 查询和诊断驱动器设置

`[DUMP_TMC 命令](G-Codes.md#dump_tmc) 在配置和诊断驱动器时是一个有用的工具。它将报告 Klipper 配置的所有字段以及可以从驱动器查询的所有字段。

所有报告的字段都在每个驱动器的 Trinamic 数据手册中定义。这些数据手册可以在 [Trinamic 网站](https://www.trinamic.com/) 上找到。获取并查看驱动器的 Trinamic 数据手册以解释 DUMP_TMC 的结果。

## 配置 driver_XXX 设置

Klipper 支持使用 `driver_XXX` 设置配置许多低级驱动器字段。[TMC 驱动器配置参考](Config_Reference.md#tmc-stepper-driver-configuration) 列出了每种类型驱动器可用的完整字段列表。

此外，几乎所有字段都可以使用 [SET_TMC_FIELD 命令](G-Codes.md#set_tmc_field) 在运行时修改。

每个字段都在每个驱动器的 Trinamic 数据手册中定义。这些数据手册可以在 [Trinamic 网站](https://www.trinamic.com/) 上找到。

请注意，Trinamic 数据手册有时会使用术语混淆高级设置（如“磁滞结束”）与低级字段值（例如“HEND”）。在 Klipper 中，`driver_XXX` 和 SET_TMC_FIELD 始终设置实际写入驱动器的低级字段值。因此，例如，如果 Trinamic 数据手册说明必须将值 3 写入 HEND 字段以获得“磁滞结束”为 0，则设置 `driver_HEND=3` 以获得高级值 0。

## 常见问题

### 我可以在带有压力提前的挤出机上使用 stealthChop 模式吗？

许多人成功地在 Klipper 的压力提前中使用“stealthChop”模式。Klipper 实现了 [平滑压力提前](Kinematics.md#pressure-advance)，不会引入任何瞬时速度变化。

然而，“stealthChop”模式可能会产生较低的电机扭矩和/或产生更高的电机热量。它可能或可能不适合您的特定打印机。

### 我不断收到“Unable to read tmc uart 'stepper_x' register IFCNT”错误？

当 Klipper 无法与 tmc2208 或 tmc2209 驱动器通信时会发生这种情况。

确保电机电源已启用，因为步进电机驱动器通常需要电机电源才能与微控制器通信。

如果在首次刷写 Klipper 后发生此错误，则步进驱动器可能先前被编程为与 Klipper 不兼容的状态。要重置状态，请从打印机上移除所有电源几秒钟（物理上拔下 USB 和电源插头）。

否则，此错误通常是由于 UART 引脚接线不正确或 Klipper 的 UART 引脚设置配置不正确。

### 我不断收到“Unable to write tmc spi 'stepper_x' register ...”错误？

当 Klipper 无法与 tmc2130 或 tmc5160 驱动器通信时会发生这种情况。

确保电机电源已启用，因为步进电机驱动器通常需要电机电源才能与微控制器通信。

否则，此错误通常是由于 SPI 接线不正确、Klipper 的 SPI 设置配置不正确，或 SPI 总线上设备配置不完整。

请注意，如果驱动器在与其他多个设备共享的 SPI 总线上，则务必在 Klipper 中完全配置该共享 SPI 总线上的每个设备。如果共享 SPI 总线上的设备未配置，则它可能会错误地响应非预期的命令，并破坏到目标设备的通信。如果共享 SPI 总线上有无法在 Klipper 中配置的设备，则使用 [static_digital_output 配置部分](Config_Reference.md#static_digital_output) 将未使用设备的 CS 引脚设置为高电平（使其不会尝试使用 SPI 总线）。电路板的原理图通常是查找 SPI 总线上有哪些设备及其相关引脚的有用参考。

### 为什么我收到“TMC reports error: ...”错误？

此类错误表示 TMC 驱动器检测到问题并已禁用自身。也就是说，驱动器停止保持其位置并忽略移动命令。如果 Klipper 检测到活动驱动器已禁用自身，它将使打印机进入“关闭”状态。

也有可能由于 SPI 错误导致 **TMC 报告错误** 关闭，从而阻止与驱动器的通信（在 tmc2130、tmc5160 或 tmc2660 上）。如果发生这种情况，报告的驱动器状态通常显示为 `00000000` 或 `ffffffff` - 例如：`TMC reports error: DRV_STATUS: ffffffff ...` OR `TMC reports error: READRSP@RDSEL2: 00000000 ...`。此类故障可能是由于 SPI 接线问题或 TMC 驱动器自重置或故障。

一些常见错误及诊断技巧：

#### TMC 报告错误：`... ot=1(OvertempError!)`

这表示电机驱动器因过热而禁用自身。典型解决方案是降低步进电机电流，增加步进电机驱动器的冷却，和/或增加步进电机的冷却。

#### TMC 报告错误：`... ShortToGND` OR `ShortToSupply`

这表示驱动器因检测到通过驱动器的电流非常高而禁用自身。这可能表示步进电机的电线松动或短路，或步进电机内部短路。

如果使用 stealthChop 模式且 TMC 驱动器无法准确预测电机的机械负载，也可能发生此错误。（如果驱动器做出不良预测，则可能向电机发送过多电流并触发其自身的过流检测。）要测试这一点，请禁用 stealthChop 模式并检查错误是否继续发生。

#### TMC 报告错误：`... reset=1(Reset)` OR `CS_ACTUAL=0(Reset?)` OR `SE=0(Reset?)`

这表示驱动器在打印中途重置了自身。这可能是由于电压或接线问题。

#### TMC 报告错误：`... uv_cp=1(Undervoltage!)`

这表示驱动器检测到欠压事件并已禁用自身。这可能是由于接线或电源问题。

### 如何调谐驱动器上的 spreadCycle/coolStep 等模式？

[Trinamic 网站](https://www.trinamic.com/) 提供了配置驱动器的指南。这些指南通常技术性强、级别低，可能需要专用硬件。尽管如此，它们是最佳信息来源。