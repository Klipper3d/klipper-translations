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

Object definitions are named, to allow users to easily select an object to be excluded, and additional metadata may be provided to allow for graphical cancellation displays. Currently defined metadata includes a `CENTER` X,Y coordinate, and a `POLYGON` list of X,Y points representing a minimal outline of the object. This could be a simple bounding box, or a complicated hull for showing more detailed visualizations of the printed objects. Especially when gcode files include multiple parts with overlapping bounding regions, center points become hard to visually distinguish. `POLYGONS` must be a json-compatible array of point `[X,Y]` tuples without whitespace. Additional parameters will be saved as strings in the object definition and provided in status updates.

`EXCLUDE_OBJECT_DEFINE NAME=calibration_pyramid CENTER=50,50 POLYGON=[[40,40],[50,60],[60,40]]`

All available G-Code commands are documented in the [G-Code
Reference](./G-Codes.md#excludeobject)

## Status Information

The state of this module is provided to clients by the [exclude_object
status](Status_Reference.md#exclude_object).

The status is reset when:

- The Klipper firmware is restarted.
- There is a reset of the `[virtual_sdcard]`. Notably, this is reset by Klipper at the start of a print.
- When an `EXCLUDE_OBJECT_DEFINE RESET=1` command is issued.

The list of defined objects is represented in the `exclude_object.objects` status field. In a well defined gcode file, this will be done with `EXCLUDE_OBJECT_DEFINE` commands at the beginning of the file. This will provide clients with object names and coordinates so the UI can provide a graphical representation of the objects if desired.

As the print progresses, the `exclude_object.current_object` status field will be updated as Klipper processes `EXCLUDE_OBJECT_START` and `EXCLUDE_OBJECT_END` commands. The `current_object` field will be set even if the object has been excluded. Undefined objects marked with a `EXCLUDE_OBJECT_START` will be added to the known objects to assist in UI hinting, without any additional metadata.

As `EXCLUDE_OBJECT` commands are issued, the list of excluded objects is provided in the `exclude_object.excluded_objects` array. Since Klipper looks ahead to process upcoming gcode, there may be a delay between when the command is issued and when the status is updated.
