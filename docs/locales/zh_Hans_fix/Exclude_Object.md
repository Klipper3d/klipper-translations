# 排除对象

`[exclude_object]` 模块允许 Klipper 在打印过程中排除指定对象。要启用此功能，请在配置文件中添加一个 `[exclude_object]` 配置节（另请参阅 [命令参考](G-Codes.md#exclude-object) 以及 [sample-macros.cfg](../config/sample-macros.cfg) 文件，其中包含一个与 Marlin/RepRapFirmware 兼容的 M486 G-Code 宏）。

与其他 3D 打印机固件选项不同，运行 Klipper 的打印机集成了多种组件，用户拥有广泛的选择。因此，为了提供一致的用户体验，`[exclude_object]` 模块将建立一种契约或类似 API 的机制。该契约涵盖 G-Code 文件的内容、模块内部状态的控制方式，以及如何将该状态提供给客户端。

## 工作流程概览
打印文件的典型工作流程可能如下所示：
1.  切片完成，文件上传准备打印。在上传过程中，文件被处理，并在其中添加 `[exclude_object]` 标记。或者，也可以配置切片软件原生生成对象排除标记，或通过预处理步骤完成。
2.  打印开始时，Klipper 将重置 `[exclude_object]` 的 [状态](Status_Reference.md#exclude_object)。
3.  当 Klipper 处理 `EXCLUDE_OBJECT_DEFINE` 块时，它会使用已知对象更新状态，并将信息传递给客户端。
4.  客户端可以利用这些信息向用户呈现用户界面（UI），以便跟踪打印进度。Klipper 会更新状态，包含当前正在打印的对象，客户端可用此信息进行显示。
5.  如果用户请求取消某个对象，客户端将向 Klipper 发送 `EXCLUDE_OBJECT NAME=<name>` 命令。
6.  当 Klipper 处理该命令时，会将该对象添加到排除对象列表中，并更新客户端的状态。
7.  客户端将收到 Klipper 发送的更新状态，并可利用该信息在 UI 中反映对象的状态。
8.  打印完成后，`[exclude_object]` 状态将继续保留，直到其他操作将其重置。

## G-Code 文件
支持排除对象所需的特殊 G-Code 处理不符合 Klipper 的核心设计目标。因此，此模块要求在将文件发送给 Klipper 打印之前对其进行预处理。可以在切片软件中使用后处理脚本，或在上传时由中间件处理文件，这两种方式都可以为 Klipper 准备文件。一个参考的后处理脚本以可执行文件和 Python 库的形式提供，详见 [cancelobject-preprocessor](https://github.com/kageurufu/cancelobject-preprocessor)。

### 对象定义

`EXCLUDE_OBJECT_DEFINE` 命令用于向将要打印的 G-Code 文件中的每个对象提供摘要信息。该命令提供文件中对象的摘要。对象无需预先定义即可被其他命令引用。此命令的主要目的是向 UI 提供信息，而无需解析整个 G-Code 文件。

对象定义具有名称，以便用户能轻松选择要排除的对象，并可提供额外的元数据以支持图形化取消显示。当前定义的元数据包括一个 `CENTER` X,Y 坐标，以及一个 `POLYGON` X,Y 点列表，表示对象的最小轮廓。这可以是一个简单的边界框，也可以是一个复杂的轮廓，用于更详细地可视化打印对象。特别是当 G-Code 文件包含多个具有重叠边界区域的部件时，中心点在视觉上难以区分。`POLYGONS` 必须是符合 JSON 格式的 `[X,Y]` 坐标元组数组，且不包含空格。其他参数将作为字符串保存在对象定义中，并在状态更新时提供。

`EXCLUDE_OBJECT_DEFINE NAME=calibration_pyramid CENTER=50,50 POLYGON=[[40,40],[50,60],[60,40]]`

所有可用的 G-Code 命令均在 [G-Code 参考文档](./G-Codes.md#excludeobject) 中有详细说明。

## 状态信息
该模块的状态通过 [exclude_object 状态](Status_Reference.md#exclude_object) 提供给客户端。

在以下情况下，状态将被重置：
-   Klipper 固件重启时。
-   `[virtual_sdcard]` 被重置时。值得注意的是，Klipper 在打印开始时会重置此状态。
-   当发出 `EXCLUDE_OBJECT_DEFINE RESET=1` 命令时。

已定义对象的列表在 `exclude_object.objects` 状态字段中表示。在一个定义良好的 G-Code 文件中，这些信息通常在文件开头通过 `EXCLUDE_OBJECT_DEFINE` 命令完成。这将向客户端提供对象名称和坐标，以便 UI 可根据需要提供对象的图形化表示。

随着打印的进行，当 Klipper 处理 `EXCLUDE_OBJECT_START` 和 `EXCLUDE_OBJECT_END` 命令时，`exclude_object.current_object` 状态字段将被更新。即使对象已被排除，`current_object` 字段也会被设置。由 `EXCLUDE_OBJECT_START` 标记的未定义对象将被添加到已知对象列表中，以辅助 UI 提示，但不包含额外的元数据。

当发出 `EXCLUDE_OBJECT` 命令时，被排除对象的列表将在 `exclude_object.excluded_objects` 数组中提供。由于 Klipper 会预读处理接下来的 G-Code，因此在发出命令和状态更新之间可能存在延迟。