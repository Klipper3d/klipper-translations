# 配置示例

本文档包含向 Klipper Github 仓库（位于[config directory](../config/)）贡献 Klipper 配置示例的指南。

请注意 [Klipper Community Discourse server](https://community.klipper3d.org) 也可以用来寻找和分享配置文件。

## 准则

1. 选择适当的配置文件名前缀：
   1. `printer`前缀用于主流制造商出售的打印机。
   1. `generic`前缀用于通用3D打印机主板。
   1. `kit`的前缀用于按照公开规范组装的3D打印机（例如Voron V2.4）。这些 "套件 "打印机通常与普通的打印机不同在它们通常不被制造商销售。
   1. `sample`前缀用于可以被复制到主配置文件中的配置 "片段"。
   1. `example`前缀是用来描述打印机运动学。这种类型的配置通常只与新类型的打印机运动学的代码一起添加。
1. 所有的配置文件必须以`.cfg`后缀结尾。`printer`配置文件必须以`.cfg`结尾（例如，`2019.cfg`）。在这种情况下，年份是对应打印机的大致发售年份。
1. 不要在配置文件名中使用空格或特殊字符。文件名应该只包含字符`A-Z`, `a-z`, `0-9`, `-`, 和`.`。
1. `printer`, `generic`, 和 `kit` 示例配置文件必须保证 Klipper 能够正常启动而不出错。这些配置文件应该被添加到 [test/klippy/printers.test](../test/klippy/printers.test) 回归测试用例中。将新的配置文件添加到该测试用例的适当部分，并按该部分的字母顺序排列。
1. 该配置示例应该是打印机的 "stock "配置。(在klipper的仓库中有太多定制的配置。)同样地，我们只为具有主流流行性的打印机、套件和板子添加配置文件的例子（至少应该有100个正在使用中）。考虑使用[Klipper Community Discourse server](https://community.klipper3d.org)进行其他配置。
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. 不要在配置示例中指定`pressure_advance`，因为该值是针对耗材的，而不是打印机硬件。同样，不要指定`max_extrude_only_velocity`或`max_extrude_only_accel`设置。
   1. 不要指定一个包含主机路径或主机硬件的配置部分。例如，不要指定`[virtual_sdcard]`或`[temperature_host]`配置部分。
   1. 只为利用特定打印机功能，或特定打印机配置的切片软件通常发出的G代码定义宏。
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. 不要将字段文档复制到示例配置文件中。（这样做会造成维护方面的负担，因为对文档的更新需要在很多地方进行修改。）
   1. 配置文件的例子不应包含 "SAVE_CONFIG "部分。如果有必要，把SAVE_CONFIG部分的相关字段复制到主配置区的适当部分。
   1. 使用`field: value`的语法，而不要使用`field=value`。
   1. 当设定一个挤出机的`rotation_distance`时，如果挤出机有一个齿轮机构，最好指定`gear_ratio`。我们希望示例配置中的旋转距离与挤出轮的周长相关--它通常在20到35毫米之间。当指定`gear_ratio`时，最好指定机构上的实际齿轮齿数（例如，优先选择`gear_ratio: 80:20`而不是`gear_ratio: 4:1`）。参见[旋转距离文档](Rotation_Distance.md#using-a-gear_ratio)以获得更多信息。
   1. 避免定义那些被设置为默认值的字段值。例如，不应该指定`min_extrude_temp: 170`，因为这已经是默认值。
   1. 在可能的情况下，行数不应超过80列。
   1. 避免在配置文件中添加归属或修订信息。例如，避免添加类似 "此文件由......创建 "的行。）将归属和修改历史放在git提交信息中。
1. 不要在示例配置文件中使用任何已废弃的功能。
1. 不要在示例配置文件中禁用默认安全系统。例如，一个配置不应该指定一个自定义的 `max_extrude_cross_section`。不要启用调试功能。例如，不应该有一个 `force_move` 配置部分。
1. Klipper支持的所有已知板子都可以使用默认的串行波特率250000。不推荐使用不同的波特率在示例文件中。

通过创建github "pull request "来提交配置文件示例。也请遵循[contribution document](CONTRIBUTING.md)中的指示。
