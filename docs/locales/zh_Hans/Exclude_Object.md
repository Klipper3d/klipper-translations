# 排除对象

The `[exclude_object]` module allows Klipper to exclude objects while a print is in progress. To enable this feature include an [exclude_object config
section](Config_Reference.md#exclude_object) (also see the [command
reference](G-Codes.md#exclude-object) and [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.)

与其他3D打印机固件选项不同，运行 Klipper 的打印机提供了一套允许用户选择许多选项的组件。因此，为了提供一致的用户体验，`[exclude_object]`模块将建立一个标准或类似的API。标准涵盖了g代码文件的内容，模块的内部状态如何被控制，以及该状态如何被提供给用户。

## 工作流程概述

打印文件的一个典型工作流可能如下所示：

1. 切片完成后，文件被上传并用于打印。在上传过程中，文件被处理，`[exclude_object]`标记被添加到该文件。另外，切片软件可以被配置为原生支持生成对象排除的标记，或者在它自己的预处理步骤中进行。
1. 当打印开始时，Klipper将重置`[exclude_object]`[状态](Status_Reference.md#exclude_object)。
1. 当 Klipper 处理`EXCLUDE_OBJECT_DEFINE`块时，它将使用已知对象更新状态并将其传递给客户端。
1. 客户端可以使用该信息向用户呈现 UI，以便跟踪进度。Klipper 将更新状态以包含客户端可用于显示目的的当前打印对象。
1. 如果用户要求取消一个对象，客户端将向Klipper发出`EXCLUDE_OBJECT NAME=<名称>`命令。
1. 当 Klipper 处理该命令时，它将把该对象添加到排除对象的列表中，并为客户更新状态。
1. 客户端将从 Klipper 接收更新的状态，并可以使用该信息在UI中反映对象的状态。
1. 当打印完成后，`[exclude_object]`状态将继续可用，直到另一个动作将其重置。

## G代码文件

支持排除对象所需的专门的G代码处理并不符合Klipper'的核心设计目标。因此，本模块要求在将文件发送到Klipper进行打印之前对其进行处理。为Klipper排除对象修改G代码可以通过切片软件中使用后处理脚本或让中间层软件在上传时处理文件达成。[cancelobject-preprocessor](https://github.com/kageurufu/cancelobject-preprocessor)是一个参考后处理脚本，它可以1被当作可执行文件或python库。

### 对象定义

`EXCLUDE_OBJECT_DEFINE` 命令用于提供gcode文件中每个要打印的对象的摘要。提供文件中一个对象的摘要。对象被其他命令引用时不需要被定义。这个命令的主要目的是向UI提供信息，而不需要解析整个gcode文件。

对象定义会被命名，以方便用户选择要排除的对象，并且可以提供额外的元数据以允许图形化的显示取消。目前定义的元数据包括一个`CENTER`（中心）X,Y坐标，以及一个`POLYGON` X,Y点的列表代表对象的最小轮廓。这可以是一个简单的边界框，也可以是一个复杂的几何体，用于显示打印对象的更详细的可视化信息。特别是当G代码文件包括具有重叠边界区域的多个实体时，中心点在视觉上会变得难以区分。`POLYGONS` 必须是一个与json兼容的点数组`[X,Y]` 图元，没有空格。额外的参数将被保存为对象定义中的字符串，并在状态更新中提供。

`EXCLUDE_OBJECT_DEFINE NAME=calibration_pyramid CENTER=50,50 POLYGON=[[40,40],[50,60],[60,40]]`

All available G-Code commands are documented in the [G-Code
Reference](./G-Codes.md#excludeobject)

## 状态信息

The state of this module is provided to clients by the [exclude_object
status](Status_Reference.md#exclude_object).

在以下情况下会重置状态：

- Klipper固件被重新启动。
- `[virtual_sdcard]` 的重置。值得注意的是，这是由Klipper在打印开始时重置的。
- 当发出`EXCLUDE_OBJECT_DEFINE RESET=1` 命令时。

定义的对象列表在`exclude_object.object` 状态域中。在一个定义良好的G代码文件中，这一步会被用`EXCLUDE_OBJECT_DEFINE` 命令完成。这将为客户端提供对象的名称和坐标，因此如果需要，用户界面可以提供对象的图形表示。

随着打印的进行，`exclude_object.current_object` 状态字段将随着Klipper处理`EXCLUDE_OBJECT_START` 和`EXCLUDE_OBJECT_END` 命令而被更新。`current_object` 字段将被设置，即使该对象已经被排除。用`EXCLUDE_OBJECT_START` 标记的未定义对象将被添加到已知对象中，以协助UI提示，而没有任何额外的元数据。

当`EXCLUDE_OBJECT` 命令被发出时，被排除的对象会被包含在在`exclude_object.excludes_objects` 数组中。由于Klipper会提前处理即将执行的G代码，在命令发出和状态更新之间可能会有延迟。
