本文档提供了与 Klipper 一起使用的切片软件的一些配置技巧。 Klipper 常用的切片软件有 Slic3r、Cura、Simplify3D 等。

# 将 G-Code 风格设置为 Marlin

很多切片软件可以设置“G代码风格”选项。Klipper 兼容通常的默认值“Marlin”。Klipper 也兼容“Smoothieware”设置。

# Klipper gcode_macro

Slicers will often allow one to configure "Start G-Code" and "End G-Code"
sequences. It is often convenient to define custom macros in the Klipper config
file instead - such as: `[gcode_macro START_PRINT]` and `[gcode_macro END_PRINT]`.
Then one can just run START_PRINT and END_PRINT in the slicer's configuration.
Defining these actions in the Klipper configuration may make it easier to tweak
the printer's start and end steps as changes do not require re-slicing.

参见[sample-macros.cfg](../config/sample-macros.cfg)中的START_PRINT 和END_PRINT 宏实例。

参见[配置参考](Config_Reference.md#gcode_macro)中关于定义gcode_macro的细节。

# 设置一个大回抽可能需要先调整Klipper

The maximum speed and acceleration of retraction moves are controlled in Klipper
by the `max_extrude_only_velocity` and `max_extrude_only_accel` config settings.
These settings have a default value that should work well on many printers.
However, if one has configured a large retraction in the slicer (eg, 5mm or
greater) then one may find they limit the desired speed of retractions.

如果你正在使用一个大的回抽，考虑调优Klipper的[提前压力](Pressure_Advance.md)来代替。否则你可能会发现打印头在回抽和priming,
then consider explicitly defining `max_extrude_only_velocity` and
`max_extrude_only_accel` in the Klipper config file.

# 不要启用“滑行(coasting)”

和Klipper 一起使用“滑行(coasting)”功能可能会导致打印质量不佳。考虑使用 Klipper 的
[提前压力](Pressure_Advance.md)功能替代。

Specifically, if the slicer dramatically changes the extrusion rate between
moves then Klipper will perform deceleration and acceleration between moves.
This is likely to make blobbing worse, not better.

In contrast, it is okay (and often helpful) to use a slicer's "retract" setting,
"wipe" setting, and/or "wipe on retract" setting.

# 不要在Simplify3d上使用“额外重启距离（extra restart distance）”

This setting can cause dramatic changes to extrusion rates which can trigger
Klipper's maximum extrusion cross-section check. Consider using Klipper's
[pressure advance](Pressure_Advance.md) or the regular Simplify3d retract
setting instead.

# 在 KISSlicer 上禁用“PreloadVE”

If using KISSlicer slicing software then set "PreloadVE" to zero. Consider using
Klipper's [pressure advance](Pressure_Advance.md) instead.

# 禁用任何"提前挤出压力"的设置

Some slicers advertise an "advanced extruder pressure" capability. It is
recommended to keep these options disabled when using Klipper as they are likely
to result in poor quality prints. Consider using Klipper's [pressure
advance](Pressure_Advance.md) instead.

Specifically, these slicer settings can instruct the firmware to make wild
changes to the extrusion rate in the hope that the firmware will approximate
those requests and the printer will roughly obtain a desirable extruder
pressure. Klipper, however, utilizes precise kinematic calculations and timing.
When Klipper is commanded to make significant changes to the extrusion rate it
will plan out the corresponding changes to velocity, acceleration, and extruder
movement - which is not the slicer's intent. The slicer may even command
excessive extrusion rates to the point that it triggers Klipper's maximum
extrusion cross-section check.

In contrast, it is okay (and often helpful) to use a slicer's "retract" setting,
"wipe" setting, and/or "wipe on retract" setting.
