# BL-Touch

## 连接BL-Touch

**警告**在你开始前！：避免用你的手指接触BL-TOUCH针，因为它对手指的油脂相当敏感。如果你真的触摸它请非常轻的去触碰，以避免弯曲或推动任何东西。

根据BL-TOUCH文件或你的MCU文件，将BL-TOUCH的 "servo"引脚连接到`control_pin`。使用原来的接线，三联的黄线是`control_pin`，一对的白线是`sensor_pin`。你需要根据你的布线来配置这些引脚。大多数BL-TOUCH设备要求在传感器引脚上有一个上拉（引脚名称前加"^"）。比如说：

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

If the BL-Touch will be used to home the Z axis then set `endstop_pin: probe:z_virtual_endstop` and remove `position_endstop` in the `[stepper_z]` config section, then add a `[safe_z_home]` config section to raise the z axis, home the xy axes, move to the center of the bed, and home the z axis. For example:

```
[safe_z_home]
home_xy_position: 100,100 # Change coordinates to the center of your print bed
speed: 50
z_hop: 10                 # Move up 10mm
z_hop_speed: 5
```

重要的是，safe_z_home 中的 z_hop 运动足够高，即使探针恰好处于最低状态，探针也不会碰到任何东西。

## 初次调试

在开始到下一个部分之前，请检查 BL-Touch 是否安装在正确的高度，当探针收起时候，探针应该在喷头上2mm的位置

当启动打印机电源的时候，BL-Touch 探针会执行自检并上下移动探针几次。自检完成后，探针会处于收回状态，探头上的红色 LED 应亮起。如果出现任何错误，例如探头呈红色闪烁或者探针伸出而不是收回，请关闭打印机电源并检查接线和配置。

如果以上看起来不错，是时候测试控制引脚是否正常工作了。首先在打印机终端中运行 `BLTOUCH_DEBUG COMMAND=pin_down`。确认探针伸出并且探头上的红色 LED 熄灭。如果没有，请再次检查打印机的接线和配置。接下来在打印机终端输入 `BLTOUCH_DEBUG COMMAND=pin_up`，验证引脚是否向上移动，并且红灯再次亮起。如果它闪烁，则说明存在问题。

下一步是确认传感器引脚是否正常工作。运行`BLTOUCH_DEBUG COMMAND=pin_down`，确认引脚向下移动，运行`BLTOUCH_DEBUG COMMAND=touch_mode`，运行`QUERY_PROBE`，确认命令报告 "probe: open"。然后用手指轻轻地将针头向上推，再次运行`QUERY_PROBE`。确认该命令的报告是"probe: TRIGGERED"。如果没有返回正确的信息，那么请再次检查你的接线和配置。在这个测试完成后，运行`BLTOUCH_DEBUG COMMAND=pin_up`并验证引脚是否向上移动。

在完成BL-TOUCH控制针和传感器针的测试后，现在是测试探针的时候了，但有一个转折。不要让探测针接触打印床，而是让它接触你手指。将工具头放在离床面较远的地方，发出`G28`（或`PROBE`，如果不使用probe:z_virtual_endstop），等待工具头开始向下移动，然后用手非常轻地触摸针脚，停止移动。你可能要做两次，因为默认的归位配置会探测两次。如果你触摸针脚时它没有停止，请关闭打印机电源。

如果成功了，再做一次`G28`（或`PROBE`），但是这次要触碰到热床。

## BL-Touch 出现问题

BL-Touch状态不一致的时候，它就会开始闪烁红色。可以通过以下命令强制它离开此状态：

BLTOUCH_DEBUG COMMAND=reset

如果其校准被阻止伸出的探针中断，则可能会发生这种情况。

但是，BL-TOUCH也可能无法再进行自我校准。如果它上面的螺丝处于错误的位置，或者探针内的磁芯移动了，就会发生这种情况。如果它移动了，以至于粘在了螺丝上，它可能无法再降低其针脚。有了这种行为，你需要打开螺丝，用圆珠笔将其轻轻推回原位。将销钉重新插入BL-TOUCH，使其落入拔出的位置。小心地将无头螺钉重新调整到位。你需要找到正确的位置，使其能够降低和提高销钉，并且红灯打开和关闭。使用`reset`、`pin_up`和`pin_down`命令来实现。

## BL-Touch "clones"

许多BL-TOUCH "clone "设备使用默认配置可以与Klipper正常工作。然而，一些 "clone"的设备可能需要配置`pin_up_reports_not_triggered`或`pin_up_touch_mode_reports_triggered`。

重要!在没有遵循这些指示之前，不要把 `pin_up_reports_not_triggered` 或 `pin_up_touch_mode_reports_triggered` 配置为 False。不要在BL-TOUCH上把这两样东西配置为False。不正确地将这些设置为 "False"会增加探测时间，并会增加损坏打印机的风险。

一些 "clone"设备无法执行Klipper的内部传感器验证测试。在这些设备上，尝试归位或探测会导致Klipper报告 "BLTouch failed to verify sensor state"的错误。如果发生这种情况，那么请手动运行步骤，确认传感器引脚工作，如[初次调试](#initial-tests)所述。如果该测试中的`QUERY_PROBE`命令总是产生预期的结果，而 "BLTouch failed to verify sensor state "错误仍然发生，那么可能需要在Klipper配置文件中把`pin_up_touch_mode_reports_triggered`设为False。

少数旧的 "clone"设备无法报告它们何时成功地提高了它们的探头。在这些设备上，Klipper会在每次回家或探测尝试后报告一个 "BLTouch failed to raise probe "的错误。可以对这些设备进行测试--将磁头从床头移开，运行`BLTOUCH_DEBUG COMMAND=pin_down`，确认引脚已经向下移动，运行`QUERY_PROBE`，确认命令报告 "probe:open"，运行`BLTOUCH_DEBUG COMMAND=pin_up`，验证引脚已经上移，并运行`QUERY_PROBE`。如果引脚保持向上，设备没有进入错误状态，并且第一个查询报告 "probe: open"，而第二个查询报告 "probe:TRIGGERED"，那么它表明`pin_up_reports_not_triggered`应该在Klipper配置文件中被设置为False。

## BL-Touch v3

一些BL-Touch v3.0和BL-Touch 3.1设备可能需要在打印机配置文件中配置`probe_with_touch_mode`。

如果BL-TOUCH v3.0的信号线连接到一个末端停止引脚（有一个噪音过滤电容），那么BL-TOUCH v3.0可能无法在归位和探测期间持续发送信号。如果[初次调试](#initial-tests)中的`QUERY_PROBE`命令总是产生预期的结果，但在G28/PROBE命令期间，工具头并不总是停止，那么就表明有这个问题。一个变通的办法是在`probe_with_touch_mode:True`在配置文件中。

BL-TOUCH v3.1在尝试探测成功后可能会错误地进入错误状态。其症状是BL-TOUCH v3.1在成功接触床铺后，偶尔会有灯光闪烁，持续几秒钟。Klipper应该自动清除这个错误，一般来说是没有问题的。当然你可以在配置文件中设置`probe_with_touch_mode`以此避免这个问题。

重要!当`probe_with_touch_mode`被设置为True时，一些 "clone"设备和BL-Touch v2.0（及更早）可能会降低精度。将此设置为True也会增加部署探针的时间。如果在 "克隆 "或更早的BL-TOUCH设备上配置这个值，一定要在设置这个值之前和之后测试探头的准确性（使用`PROBE_ACCURACY`命令进行测试）。

## 无收起多次探测

默认情况下，Klipper将在每次探测尝试开始时部署探针，然后在之后收起探针。这种重复部署和收起探头的做法可能会增加涉及许多探头测量的校准序列的总时间。Klipper支持在连续的探测之间留下探头，这可以减少探测的总时间。通过在配置文件中把`stow_on_each_sample`配置为False，可以启用这种模式。

重要!将`Stow_on_each_sample`设置为False可能导致Klipper在测头展开时进行水平刀头运动。在将此值设置为 "False"之前，请确保所有探测操作都有足够的Z间隙。如果没有足够的间隙，那么水平移动可能会导致针卡在障碍物上并且导致打印机损坏。

重要!当使用`stow_on_each_sample`配置为False时，建议使用`probe_with_touch_mode`配置为True。如果没有设置`probe_with_touch_mode`，一些 "clone"设备可能检测不到后续的床位接触。在所有的设备上，使用这两个设置的组合可以简化设备的信号传递，从而提高整体稳定性。

但是请注意，当`probe_with_touch_mode`设置为True时，一些 "clone"设备和BL-Touch v2.0（以及更早）可能会降低精度。在这些设备上，最好在设置`probe_with_touch_mode`之前和之后测试探头的准确性（使用`PROBE_ACCURACY`命令来测试）。

## BL-TOUCH偏移校准

按照[Probe Calibrate](Probe_Calibrate.md)指南中的指示来设置x_offset、y_offset和z_offset配置参数。

确认Z轴偏移量接近1mm是个好主意。如果不是，那么你可能要将探头向上或向下移动来解决这个问题。你想让它在喷嘴碰到床面之前很好地触发，这样可能出现的卡丝或扭曲的床面就不会影响任何探测动作。但与此同时，你希望缩回的位置尽可能高于喷嘴，以避免它接触到打印件。如果对探针位置进行了调整，然后重新运行探针校准步骤。

## BL-Touch输出模式


   * BL-TOUCH V3.0支持设置5V或OPEN-DRAIN输出模式，BL-TOUCH V3.1也支持，但也可以在其内部EEPROM中存储。如果你的控制器板需要5V模式的固定5V高逻辑电平，你可以把打印机配置文件[bltouch]部分的'set_output_mode'参数设置为 "5V"。*** 只有在你的控制器板的输入线能容忍5V时才使用5V模式。这就是为什么这些BL-TOUCH版本的默认配置是OPEN-DRAIN模式。你有可能损坏你的控制器板的CPU ***

   因此。如果一个控制器板需要5V模式，并且它的输入信号线是5V的，并且如果

   - 你有一个BL-TOUCH Smart V3.0，你需要使用'set_output_mode:5V'参数，以确保每次启动时的这一设置，因为探头不能记住所需的设置。
   - 如果你有一台BL-TOUCH Smart V3.1，你可以选择使用'set_output_mode:5V "或者通过手动使用 "BLTOUCH_STORE MODE=5V "命令，而不是使用参数 "set_output_mode: "来存储模式。
   - 你有一些其他的探头。有些探头在电路板上有一个需要切的或者需要设置一个跳线，以便（永久）设置输出模式。在这种情况下，完全省略 "set_output_mode "参数。
如果你有一个V3.1，不要自动或重复存储输出模式，以避免磨损探头的EEPROM。BLTouch EEPROM可用于约100.000次更新。每天存储100次，在磨损之前，加起来大约可以运行3年。因此，在V3.1中存储输出模式被供应商设计成一个复杂的操作（出厂默认值是一个 safe OPEN DRAIN 模式），不适合由任何切片软件、宏或其他东西重复发出，最好仅在首次将探头放到到打印机电子设备时使用。

