# BL-Touch

## 连接 BL-Touch

开始前的一个**警告**：请避免用手指直接触摸 BL-Touch 的探针针脚，因为它对指纹油污非常敏感。如果确实碰到了，请务必轻柔操作，避免弯曲或推动任何部件。

根据 BL-Touch 的文档或您的 MCU 文档，将 BL-Touch 的“伺服”连接器连接到 `control_pin`。使用原始接线时，三根线中的黄色线是 `control_pin`，两根线中的白色线是 `sensor_pin`。您需要根据实际接线配置这些引脚。大多数 BL-Touch 设备要求在传感器引脚上启用上拉电阻（在引脚名称前加“^”）。例如：

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

如果 BL-Touch 将用于 Z 轴归位，则在 `[stepper_z]` 配置部分中设置 `endstop_pin: probe:z_virtual_endstop` 并移除 `position_endstop`，然后添加一个 `[safe_z_home]` 配置部分，以提升 Z 轴、对 XY 轴进行归位、移动到打印床中心，再对 Z 轴进行归位。例如：

```
[safe_z_home]
home_xy_position: 100, 100 # 将坐标更改为您的打印床中心
speed: 50
z_hop: 10                 # 上升 10mm
z_hop_speed: 5
```

重要的是，`safe_z_home` 中的 z_hop 移动距离必须足够高，以确保即使探针针脚处于最低状态时也不会碰到任何物体。

## 初始测试

在继续之前，请确认 BL-Touch 已安装在正确高度，针脚在收回状态下应比喷嘴高出约 2mm。

当您打开打印机时，BL-Touch 探针应执行自检，并将针脚上下移动几次。自检完成后，针脚应处于收回状态，且探针上的红灯应亮起。如果出现任何错误（例如探针红灯闪烁或针脚未收回而是向下），请关闭打印机并检查接线和配置。

如果上述情况正常，现在可以测试控制引脚是否工作正常。首先在打印机终端中运行 `BLTOUCH_DEBUG COMMAND=pin_down`。确认针脚向下移动且探针上的红灯熄灭。如果没有，请再次检查接线和配置。接着运行 `BLTOUCH_DEBUG COMMAND=pin_up`，确认针脚向上移动，且红灯重新亮起。如果红灯闪烁，则说明存在问题。

下一步是确认传感器引脚是否正常工作。运行 `BLTOUCH_DEBUG COMMAND=pin_down`，确认针脚向下移动，然后运行 `BLTOUCH_DEBUG COMMAND=touch_mode`，再运行 `QUERY_PROBE`，确认命令返回“probe: open”。然后用手指指甲轻轻向上推动针脚，再次运行 `QUERY_PROBE`，确认命令返回“probe: TRIGGERED”。如果任一查询未返回正确信息，通常表示接线或配置有误（尽管某些[克隆版本](#bl-touch克隆)可能需要特殊处理）。完成此测试后，运行 `BLTOUCH_DEBUG COMMAND=pin_up`，确认针脚向上收回。

完成 BL-Touch 控制引脚和传感器引脚测试后，现在可以测试探针功能，但这里有个小技巧：不要让探针针脚接触打印床，而是让它接触您的手指指甲。将打印头移动到远离打印床的位置，发出 `G28` 命令（如果未使用 `probe:z_virtual_endstop`，则使用 `PROBE`），等待打印头开始向下移动，然后用指甲轻轻触碰针脚使其停止。由于默认的归位配置会进行两次探测，您可能需要重复此操作两次。如果触碰针脚后打印头未停止，请准备立即关闭打印机。

如果上述操作成功，请再进行一次 `G28`（或 `PROBE`），但这次让它正常接触打印床。

## BL-Touch 出现故障

当 BL-Touch 进入不稳定状态时，红灯会开始闪烁。您可以通过发送以下命令强制其退出该状态：

 BLTOUCH_DEBUG COMMAND=reset

如果探针被阻碍无法伸出，导致校准中断，就可能发生这种情况。

然而，BL-Touch 也可能无法再自行校准。这通常是因为顶部的螺丝位置不正确，或探针针脚内的磁芯发生了位移。如果磁芯向上移动并粘附在螺丝上，它可能就无法再降低针脚。遇到这种情况时，需要拧开螺丝，用圆珠笔轻轻将磁芯推回原位。将针脚重新插入 BL-Touch，使其处于伸出位置。然后小心地重新调整无头螺丝的位置，找到合适的位置，使其既能升降针脚，又能使红灯正常亮灭。使用 `reset`、`pin_up` 和 `pin_down` 命令来实现此调整。

## BL-Touch “克隆”版本

许多 BL-Touch “克隆”设备可以使用默认配置在 Klipper 上正常工作。然而，某些“克隆”设备可能不支持 `QUERY_PROBE` 命令，或需要配置 `pin_up_reports_not_triggered` 或 `pin_up_touch_mode_reports_triggered` 参数。

重要！在未遵循以下说明的情况下，切勿将 `pin_up_reports_not_triggered` 或 `pin_up_touch_mode_reports_triggered` 设置为 False。切勿在真正的 BL-Touch 上将这两个参数设置为 False。错误地将其设为 False 可能会增加探测时间，并增加损坏打印机的风险。

某些“克隆”设备不支持 `touch_mode`，因此 `QUERY_PROBE` 命令无法工作。尽管如此，仍有可能使用这些设备进行探测和归位。对于这些设备，在[初始测试](#初始测试)中的 `QUERY_PROBE` 命令将不会成功，但后续的 `G28`（或 `PROBE`）测试会成功。只要不使用 `QUERY_PROBE` 命令且不启用 `probe_with_touch_mode` 功能，就可能可以在 Klipper 中使用这些“克隆”设备。

某些“克隆”设备无法执行 Klipper 内部的传感器状态验证测试。对于这些设备，尝试归位或探测时，Klipper 可能会报告“BLTouch failed to verify sensor state”（BLTouch 无法验证传感器状态）错误。如果发生这种情况，请手动执行[初始测试部分](#初始测试)中描述的步骤，以确认传感器引脚是否正常工作。如果该测试中的 `QUERY_PROBE` 命令始终产生预期结果，但仍出现“BLTouch failed to verify sensor state”错误，则可能需要在 Klipper 配置文件中将 `pin_up_touch_mode_reports_triggered` 设置为 False。

少数旧款“克隆”设备无法报告其探针已成功升起。对于这些设备，每次归位或探测尝试后，Klipper 都会报告“BLTouch failed to raise probe”（BLTouch 无法升起探针）错误。您可以测试这些设备——将打印头移动到远离打印床的位置，运行 `BLTOUCH_DEBUG COMMAND=pin_down`，确认针脚已向下移动，运行 `QUERY_PROBE`，确认命令返回“probe: open”，运行 `BLTOUCH_DEBUG COMMAND=pin_up`，确认针脚已向上移动，再运行 `QUERY_PROBE`。如果针脚保持在上方，设备未进入错误状态，且第一次查询返回“probe: open”，而第二次查询返回“probe: TRIGGERED”，则表明应在 Klipper 配置文件中将 `pin_up_reports_not_triggered` 设置为 False。

## BL-Touch v3

某些 BL-Touch v3.0 和 BL-Touch 3.1 设备可能需要在打印机配置文件中配置 `probe_with_touch_mode`。

如果 BL-Touch v3.0 的信号线连接到一个带有噪声滤波电容的限位开关引脚，则 BL-Touch v3.0 可能在归位和探测期间无法持续发送信号。如果[初始测试部分](#初始测试)中的 `QUERY_PROBE` 命令始终产生预期结果，但打印头在 G28/PROBE 命令期间并非总是停止，则表明存在此问题。解决方法是在配置文件中设置 `probe_with_touch_mode: True`。

BL-Touch v3.1 可能在成功探测后错误地进入错误状态。症状是 BL-Touch v3.1 在成功接触打印床后，红灯偶尔会闪烁几秒钟。Klipper 应会自动清除此错误，通常无害。但是，您可以在配置文件中设置 `probe_with_touch_mode` 以避免此问题。

重要！某些“克隆”设备和 BL-Touch v2.0（及更早版本）在将 `probe_with_touch_mode` 设置为 True 时，精度可能会降低。将此值设为 True 还会增加探针部署所需的时间。如果在“克隆”或较旧的 BL-Touch 设备上配置此值，请务必在设置前后测试探针精度（使用 `PROBE_ACCURACY` 命令进行测试）。

## 多次探测无需收起

默认情况下，Klipper 会在每次探测尝试开始时部署探针，结束后再将其收起。这种反复部署和收起探针的操作可能会增加涉及大量探测测量的校准序列的总时间。Klipper 支持在连续探测之间保持探针处于部署状态，从而减少探测总时间。通过在配置文件中将 `stow_on_each_sample` 设置为 False 来启用此模式。

重要！将 `stow_on_each_sample` 设置为 False 可能导致 Klipper 在探针部署状态下进行水平打印头移动。在将此值设置为 False 之前，请务必确认所有探测操作都有足够的 Z 轴间隙。如果间隙不足，水平移动可能导致针脚卡住障碍物，从而损坏打印机。

重要！建议在使用 `stow_on_each_sample` 设置为 False 时，同时将 `probe_with_touch_mode` 配置为 True。某些“克隆”设备如果未设置 `probe_with_touch_mode`，可能无法检测到后续的床面接触。对于所有设备，同时使用这两个设置可以简化设备信号，从而提高整体稳定性。

但请注意，某些“克隆”设备和 BL-Touch v2.0（及更早版本）在将 `probe_with_touch_mode` 设置为 True 时，精度可能会降低。对于这些设备，建议在设置 `probe_with_touch_mode` 前后测试探针精度（使用 `PROBE_ACCURACY` 命令进行测试）。

## 校准 BL-Touch 偏移量

请按照[探针校准](Probe_Calibrate.md)指南中的说明设置 x_offset、y_offset 和 z_offset 配置参数。

建议验证 Z 偏移量是否接近 1mm。如果不是，则可能需要上下移动探针来修正。您希望它在喷嘴接触打印床之前就触发，以避免残留的丝材或翘曲的打印床影响探测操作。但同时，您也希望收回位置尽可能高于喷嘴，以避免其触碰到打印件。如果调整了探针位置，则需要重新运行探针校准步骤。

## BL-Touch 输出模式

* BL-Touch V3.0 支持设置 5V 或 OPEN-DRAIN 输出模式，BL-Touch V3.1 也支持此功能，且还能将其存储在内部 EEPROM 中。如果您的控制器板需要 5V 模式的固定 5V 高电平逻辑，则可以在打印机配置文件的 `[bltouch]` 部分中将 'set_output_mode' 参数设置为 "5V"。

  *** 仅当您的控制器板输入线支持 5V 耐压时才使用 5V 模式。这就是为什么这些 BL-Touch 版本的默认配置是 OPEN-DRAIN 模式。否则可能会损坏您的控制器板 CPU ***

  因此：
  如果控制器板需要 5V 模式，并且其输入信号线支持 5V 耐压，并且

  - 您使用的是 BL-Touch Smart V3.0，则需要使用 'set_output_mode: 5V' 参数，以确保每次启动时都应用此设置，因为探针无法记住所需设置。
  - 您使用的是 BL-Touch Smart V3.1，则可以选择使用 'set_output_mode: 5V'，或通过手动使用 'BLTOUCH_STORE MODE=5V' 命令一次性存储模式，并且不使用 'set_output_mode:' 参数。
  - 您使用的是其他探针：某些探针在电路板上有可切割的走线或跳线，用于（永久）设置输出模式。在这种情况下，请完全省略 'set_output_mode' 参数。

  如果您使用的是 V3.1，请勿自动化或重复存储输出模式，以免磨损探针的 EEPROM。BLTouch EEPROM 的寿命约为 100,000 次更新。每天存储 100 次，大约 3 年就会耗尽寿命。因此，厂商设计 V3.1 的存储输出模式为复杂操作（出厂默认为安全的 OPEN DRAIN 模式），不适合由任何切片软件、宏或其他程序反复调用，最好仅在首次将探针集成到打印机电子系统时使用一次。