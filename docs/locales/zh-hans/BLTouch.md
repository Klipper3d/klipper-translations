# BL-Touch

## 连接到 BL-Touch

**警告！**：在你开始前请避免用你的手指接触 BL-Touch 的探针，因为它对手指的油脂相当敏感。如果你真的触摸需要触碰它，请尽可能小心，以避免弯曲或推动任何东西。

根据 BL-Touch 文档或你使用的 MCU 的文档，将 BL-TOUCH 的 "servo"引脚连接到 `control_pin`。使用原装连接线，三根线中的黄线是`control_pin`，两根线中的白线是`sensor_pin`。你需要根据你的接线来配置这些引脚。大多数 BL-Touch 设备要求在传感器引脚上有一个上拉电阻（引脚名称前加"^"）。例如：

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

如果 BL-Touch 将用于 Z 轴归位，则设置 `endstop_pin:probe:z_virtual_endstop` 并删除 `[stepper_z]` 配置分段中的 `position_endstop`，然后添加一个 `[safe_z_home]` 配置分段来先提升 z 轴，并归位 xy 轴，再移动到床的中心，并归位 z 轴。例如：

```
[safe_z_home]
home_xy_position: 100,100 # 修改坐标为打印床的中心位置
speed: 50
z_hop: 10                 # 向上移动 10mm
z_hop_speed: 5
```

重要的是，safe_z_home 中的 z_hop 运动需要足够高以保证即使探针恰好处于最低状态，也不会发生碰撞。

## 初始测试

在继续前，请检查 BL-Touch 是否安装在正确的高度，探针在收起时应该在喷头上大约2mm的位置

启动打印机时，BL-Touch 探针会执行自检并上下移动探针几次。自检完成后，探针会处于收回状态，探头上的红色 LED 在此时应亮起。如果有错误，例如探头呈红色闪烁或者探针伸出而不是收回，请关闭打印机并检查接线和配置。

如果以上都没有问题，就可以测试 control 引脚是否正常工作了。首先在打印机终端中运行 `BLTOUCH_DEBUG COMMAND=pin_down`。确认探针伸出并且探头上的红色 LED 熄灭。如果没有，请再次检查打印机的接线和配置。接下来在打印机终端输入 `BLTOUCH_DEBUG COMMAND=pin_up`，确认探针向上移动了，并且红灯再次亮起。如果它闪烁，则说明存在问题。

下一步是确认 sensor 引脚是否正常工作。运行`BLTOUCH_DEBUG COMMAND=pin_down`，确认引脚向下移动，运行`BLTOUCH_DEBUG COMMAND=touch_mode`，运行`QUERY_PROBE`，确认命令报告 "probe: open"。然后用手指轻轻地将针头向上推，再次运行`QUERY_PROBE`。确认该命令的报告是"probe: TRIGGERED"。如果没有返回正确的信息，那么请再次检查你的接线和配置。在这个测试完成后，运行`BLTOUCH_DEBUG COMMAND=pin_up`并验证引脚是否向上移动。

在完成 BL-TOUCH contro 引脚和 sensor 引脚的测试后，现在是测试探针的时候了，但有一个技巧。不要让探针接触打印床，而是让它接触你手指甲。将打印头移动到离床面较远的位置，发送`G28`（如果不使用probe:z_virtual_endstop，发送`PROBE`），等待工具头开始向下移动，然后用手指甲轻轻地触摸针脚来停止移动。你可能要做两次，因为默认的归位配置会探测两次。如果你触摸探针时它没有停止，请立即关闭打印机电源。

如果成功了，再做一次`G28`（或`PROBE`），但是这次让它触碰到热床。

## BL-Touch 坏了

当 BL-Touch 在不一致状态时，它就会开始闪烁红色。可以通过以下命令强制它离开此状态：

BLTOUCH_DEBUG COMMAND=reset

这种情况可能会在校准中被阻止伸出的探针中断时出现。

但是，BL-TOUCH 也有可能无法再进行自我校准。这种情况会在它上面的螺丝处于错误的位置，或者探针内的磁芯移动之后出现。如果它移动了，以至于卡在了螺丝上，它可能无法再降低其探针。这种情况需要你打开螺丝并用圆珠笔将其轻轻推回原位。将探针重新插入BL-TOUCH，使其落入原来的位置。小心地将无头螺钉重新调整到位。你需要找到正确的位置，使其能够降低和提高探针，并且红灯打开和关闭。使用`reset`、`pin_up`和`pin_down`命令来实现。

## BL-Touch 的克隆（3D-Touch）

许多克隆的 BL-TOUCH 设备使用默认配置可以与 Klipper 正常工作。然而，一些克隆的设备可能需要配置`pin_up_reports_not_triggered`或`pin_up_touch_mode_reports_triggered`。

注意！在没有遵循这些指示之前，不要把 `pin_up_reports_not_triggered` 或 `pin_up_touch_mode_reports_triggered` 配置为 False。不要在正版 BL-Touch 上把这两个参数配置为False。错误地将这些设置为 "False"会增加探测时间和损坏打印机的风险。

一些克隆设备无法执行 Klipper 的内部传感器验证测试。在这些设备上，尝试归位或探测会导致 Klipper 报告 "BLTouch failed to verify sensor state" 错误。如果发生这种情况，那么请手动运行这些步骤以确认 sensor 引脚正确，如[初次调试](#initial-tests)所述。如果该测试中的`QUERY_PROBE`命令总是产生符合预期的结果，而 "BLTouch failed to verify sensor state "错误仍然发生，那么可能需要在Klipper配置文件中把`pin_up_touch_mode_reports_triggered`设为False。

少数老版本克隆设备无法报告它们何时成功地抬升了它们的探针。在这些设备上，Klipper 会在每次归位或探测尝试后报告一个 "BLTouch failed to raise probe "的错误。可以对这些设备进行测试--将探针从打印床移开，运行`BLTOUCH_DEBUG COMMAND=pin_down`，确认探针已经向下移动，运行`QUERY_PROBE`，确认命令报告 "probe:open"，运行`BLTOUCH_DEBUG COMMAND=pin_up`，确认探针已经抬升，并运行`QUERY_PROBE`。如果探针保持抬升，设备没有进入错误状态，且第一个查询报告 "probe: open"，而第二个查询报告 "probe:TRIGGERED"，那么它表明`pin_up_reports_not_triggered`应该在Klipper配置文件中被设置为False。

## BL-Touch v3

一些 BL-Touch v3.0 和BL-Touch 3.1 设备可能需要在打印机配置文件中配置`probe_with_touch_mode`。

如果BL-TOUCH v3.0的信号线连接到一个限位引脚（有一个噪音过滤电容），那么BL-TOUCH v3.0可能无法在归位和探测期间持续发送信号。如果[初次调试](#initial-tests)中的`QUERY_PROBE`命令总是产生预期的结果，但在G28/PROBE命令期间，工具头并不总是停止，那么就表明有这个问题。一个变通的办法是在在配置文件中设置`probe_with_touch_mode:True`。

BL-TOUCH v3.1 可能会在尝试探测成功后错误地进入错误状态。其症状是 BL-TOUCH v3.1 在成功接触打印床后，偶尔会有灯光闪烁，持续几秒钟。Klipper 应该会自动清除这个错误，一般来说是没有问题的。当然你可以在配置文件中设置`probe_with_touch_mode`来避免这个问题。

注意！当 `probe_with_touch_mode` 被设置为 True 时，一些 克隆设备和BL-Touch v2.0（及更早）可能会降低精度。将此设置为 True 也会增加部署探针的时间。如果在 克隆 或更早的BL-Touch设备上配置这个值，一定要在设置这个值之前和之后测试探针的准确性（使用`PROBE_ACCURACY`命令进行测试）。

## 无收起多次探测

默认情况下，Klipper 会在每次探测尝试开始时部署探针，然后在之后收起探针。这种重复部署和收起探针的做法可能会增加涉及许多探针测量的校准序列的总耗时。Klipper 支持在连续的探测之间不收起探针，这可以减少探测的总耗时。可以通过在配置文件中把 `stow_on_each_sample` 配置为 False 来启用这个模式。

注意！将 `Stow_on_each_sample` 设置为 False 可能导致 Klipper 在探针放下时进行水平的打印头运动。在将此值设置为 "False"之前，请确保所有探测操作都有足够的Z间隙。如果没有足够的间隙，那么水平移动可能会导致探针卡在障碍物上并且导致打印机损坏。

注意！当配置`stow_on_each_sample`为False时，建议将`probe_with_touch_mode`配置为 True。如果没有设置`probe_with_touch_mode`，一些克隆的设备可能检测不到后续和打印床的接触。在所有的设备上，使用这两个设置的组合可以简化设备的信号传递，从而提高整体稳定性。

但是请注意，当`probe_with_touch_mode`设置为True时，一些克隆设备和BL-Touch v2.0（以及更早）可能会降低精度。在这些设备上，最好在设置`probe_with_touch_mode`之前和之后测试探针的准确性（使用`PROBE_ACCURACY`命令来测试）。

## 校准 BL-Touch 的偏移

按照[探针校准](Probe_Calibrate.md)指南中的指示来设置x_offset、y_offset和z_offset配置参数。

最好确认 Z 轴偏移量接近 1 mm。如果不是，那么你可能希望将探头向上或向下移动来解决这个问题。你需要让它在喷嘴碰到床面之前可以很好的触发，这样可能出现的残留耗材或扭曲的床面就不会影响任何探测动作。但与此同时，收回的位置最好尽可能高于喷嘴，以避免它接触到打印件。如果对探针位置进行了调整，需要在调整后重新运行探针校准步骤。

## BL-Touch 输出模式


   * BL-Touch V3.0支持设置 5V 或 OPEN-DRAIN 输出模式，BL-TOUCH V3.1也支持，但它也可以在其内部 EEPROM 中存储这个设置。如果你的控制主板需要 5V 模式的固定 5V 高逻辑电平，你可以把打印机配置文件[bltouch]部分的 'set_output_mode' 参数设置为 "5V"。*** 只在你的控制主板的输入线路可以容忍5V时使用 5V 模式。这就是为什么这些 BL-Touch 版本的默认配置是OPEN-DRAIN模式。你有可能损坏你的控制主板上的MCU ***

   因此。如果一个控制主板需要 5V 模式，并且它的输入信号线是 5V 的，并且如果

   - 你有一个 BL-TOUCH Smart V3.0，你需要使用 'set_output_mode:5V' 参数，以确保每次启动时的应用这一设置，因为探针不能记住所需的设置。
   - 如果你有一个 BL-Touch Smart V3.1，你可以选择使用 'set_output_mode:5V " 或者通过手动使用 "BLTOUCH_STORE MODE=5V "命令，而不是使用参数 "set_output_mode: "来存储模式。
   - 如果你有一些其他的探针。有些探针在电路板上有一个需要切除的线路或者需要设置的一个跳线，以便（永久）设置输出模式。在这种情况下，完全省略 "set_output_mode "参数。
如果你有一个 V3.1，不要自动或重复存储输出模式，以避免磨损探针的 EEPROM。BLTouch 的 EEPROM可用于约100.000次更新。每天存储100次，在磨损之前，加起来大约可以运行3年。因此，在 V3.1 中存储输出模式被供应商设计成一个复杂的操作（出厂默认值是一个 safe OPEN DRAIN 模式），不适合由任何切片软件、宏或其他东西重复发出，最好仅在首次将探针添加到到打印机电子设备时使用。
