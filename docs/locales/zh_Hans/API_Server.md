# API 服务器

该文档介绍Klipper的应用开发者接口（API）功能。该接口允许外部应用程序访问和控制Klipper主机。

## 启用API套接字

要启用API服务器，klipper.py运行时应加上 `-a` 参数。例如：

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

上述操作会使主机创建一个Unix本地套接字。之后，客户应用程序可以创建一个套接字链接，从而给Klipper发送命令。

参见[Moonraker](https://github.com/Arksine/moonraker)项目，该项目是一个流行的工具，可以将HTTP请求转发到Klipper的API服务器Unix域插座。

## 请求格式

套接字进出的数据包应使用JSON编码的字符串，并以ASCII字符0x03作为结尾：

```
<json_object_1><0x03><json_object_2><0x03>...
```

Klipper使用`scripts/whconsole.py`的代码进行上述的数据帧打包。例如：

```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

该工具会从stdin中读取一系列的JSON命令，发送到Klipper执行，并将结果送出。该工具默认输入的每条Json命令中不存在换行，并自动地在发送命令时在结尾附上0x03。（Klipper API服务器没有换行符要求。）

## API协议

套接字的命令协议受 [json-rpc](https://www.jsonrpc.org/) 启发。

一个请求命令类似：

`{"id": 123, "method": "info", "params": {}}`

一个回应帧类似：

`{"id": 123, "result": {"state_message": "Printer is ready", "klipper_path": "/home/pi/klipper", "config_file": "/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6", "hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4 (v7l)", "state": "ready", "python_path": "/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}`

每个请求应为一个JSON字典。（本文档使用Python中的术语“字典”描述以`{}`为边界的“键-值”JSON对象。）

请求字典中必须包含一个”method”字段，其值应包含一个可用的Klipper端点”endpoint”名称字符串。

请求字典可能包含”params”参数，并其值应为一个字典类型。”params”提供Klipper”endpoint”处理请求所需的额外数据，其内容依”endpoint”而定。

请求的字典可以包含一个可以是任何 JSON类型的"id"参数。如果"id"存在，那么 Klipper 将用一个包含该"id"的响应信息来回应请求。如果"id"被省略（或设置为 JSON 的 "null" 值），那么 Klipper 将不会对该请求进行任何响应。响应信息是一个 包含 "id" 和 "result"的 JSON 字典。"result"总是一个字典--它的内容是特定于处理请求的"endstop"。

如果处理的请求造成了错误，则响应消息将包含"error"字段，而不是"result"字段。例如，请求： `{"id"： 123， "method"： "gcode/script"， "params"： {"script"： "G1 X200"}}` 可能会返回错误响应，例如： `{"id"： 123， "error"： {"message"： "Must home axis first： 200.000 0.000 0.000 [0.000]"， "error"： "WebRequestError"}}`

Klipper 会按照收到请求的顺序依次处理请求。然而，一些请求可能不会立即完成，这可能会导致相关的响应与其他请求的响应不按顺序发送。一个 JSON 请求永远不会暂停对未来JSON 请求的处理。

## 订阅（Subscriptions）

一些 Klipper 的"endpoint"可以以 "订阅" 的形式接收未来的异步更新消息。

例如：

`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{"key": 345}}}`

可能会返回一个初始回应：

`{"id": 123, "result": {}}`

并导致 Klipper 在未来发送类似于以下内容的消息：

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

订阅请求接受请求的“params”字段中的“response_template”字典。“response_template”字典被用作未来异步消息的模板——它可能包含任意的键/值对。当发送这些未来的异步消息时，Klipper将在响应模板中添加一个“params”字段，该字段包含一个具有“端点”特定内容的字典，然后发送该模板。如果没有提供“response_template”字段，则默认为空字典（`{}`）。

## 可用的"endpoint"

按照惯例，Klipper“端点”的形式为“<module_name>/<some_name>'”。当向“端点”发出请求时，必须在请求字典的“方法”参数中设置全名（例如，`{“方法”=“gcode/restart”}`）。

### info

“info” 用于从Klipper获取系统和版本信息。同时也被用来向Klipper提供客户端的版本信息。比如说`{"id": 123, "method": "info", "params": { "client_info": { "version": "v1"}}}`

如果存在，“client_info”参数必须是一个字典，但该字典可能具有任意内容。鼓励客户端在首次连接到Klipper API服务器时提供客户端名称及其软件版本。

### emergency_stop

"emergency_stop"端点用于指示 Klipper 过渡到 "shutdown"状态。它的行为类似于 G 代码 "M112 "命令。例如：`{"id"： 123, "method"： "emergency_stop"}`

### register_remote_method

该端点允许客户端注册可从 klipper 调用的方法。成功后将返回一个空对象。

例如：`{“id”：123，“method”：“register_remote_method”，“params”：{“response_template”：｛“action”：“run_paneldue_deep”}，“remote_method“：”paneldue_beep`

现在可以从Klipper调用远程方法 `paneldue_beep`。请注意，如果方法采用参数，则应将它们作为关键字参数提供。以下是如何从gcode_macro调用它的示例：

```
[gcode_macro PANELDUE_BEEP]
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

当PANELDUE_BEEP gcode宏被执行时，Klipper将通过套接字发送类似以下内容：`{"action": "run_paneldue_beep", "params": {"frequency": 300, "duration": 1.0}}`

### objects/list

该端点查询可用打印机“对象”的列表，可以查询（通过“对象/查询”端点）。例如：`｛“id”：123，“method”：“objects/list”｝`可能返回： `{"id": 123, "result": {"objects": ["webhooks", "configfile", "heaters", "gcode_move", "query_endstops", "idle_timeout", "toolhead", "extruder"]}}`

### objects/query

这个endpoint允许从打印机对象中查询信息。比如说：`{"id": 123, "method": "objects/query", "params": {"objects": {"toolhead": ["position"], "webhooks": null}}}` 可能返回。`{"id": 123, "result": {"status": {"webhooks": {"state": "ready", "state_message": "Printer is ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3051555.377933684}}`

请求中的 "objects "参数必须是一个包含要查询的打印机对象的字典 - 键包含打印机对象名称，值是 "null"（查询所有字段）或一个字段名的列表。

响应消息将包含一个 "status "字段，其中包含一个包含查询信息的字典 - 键包含打印机对象名称，值是一个包含其字段的字典。响应消息还将包含一个 "eventtime "字段，其中包含从查询开始的时间戳。

[Status Reference](Status_Reference.md) 文档中定义了可用字段。

### objects/subscribe

这个endpoint允许查询，然后subscribe打印机对象的信息。端点的请求和响应与 "objects/query" endpoint相同。例如。`"id": 123, "method": "objects/subscribe", "params": {"objects":{"toolhead": ["position"], "webhooks": ["state"]}, "response_template":{}}}` 可能返回：`{"id": 123, "result": {"status": {"webhooks": {"state": "ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3052153.382083195}}` ，并导致随后的异步消息，例如：`{"params": {"status": {"webhooks": {"state": "shutdown"}}, "eventtime": 3052165.418815847}}`

### gcode/help

这个endpoint允许查询有定义帮助字符串的可用G-Code命令。例如：`{"id": 123, "method": "gcode/help"}` 可能返回：`{"id": 123, "result": {"RESTORE_GCODE_STATE": "Restore a previously saved G-Code state", "PID_CALIBRATE": "Run PID calibration test", "QUERY_ADC": "Report the last value of an analog pin", ...}}`

### gcode/script

这个endpoint允许运行一系列的G代码命令。比如说：`{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}`

如果提供的G-Code脚本产生了错误，那么就会产生一个错误响应。然而，如果G-Code命令产生了终端输出，则该终端输出不会在响应中提供。(使用 "gcode/subscribe_output " endpoint 来获取G-Code终端输出。）

如果在收到这个请求时有一个G-Code命令正在处理，那么所提供的脚本将被排队。这个延迟可能很严重（例如，如果一个G-Code等待温度的命令正在运行）。当脚本的处理完全完成时，将发送JSON响应信息。

### gcode/restart

该端点允许用户请求重新启动-它类似于运行G-Code“重新启动”命令。例如：`{“id”：123，“方法”：“gcode/Restart”}`

与“gcode/脚本”终结点一样，该终结点只有在所有挂起的G-Code命令完成后才会完成。

### gcode/firmware_restart

这类似于“GCODE/RESTART”端点-它实现G-Code“Firmware_Restart”命令。例如：`{“id”：123，“方法”：“gcode/Firmware_Restart”}`

与“gcode/脚本”终结点一样，该终结点只有在所有挂起的G-Code命令完成后才会完成。

### GCODE/订阅输出

此端点用于订阅由Klipper生成的G-Code终端消息。例如：`{“id”：123，“Method”：“gcode/SUBSCRIBE_OUTPUT”，“PARAMS”：{“RESPONSE_TEMPLATE”：{}`以后可能会产生异步消息，如：`{“PARAMS”：{“RESPONSE”：“//Klipper STATE：Shutdown”}}`

该端点旨在通过“终端窗口”界面支持人类交互。不鼓励解析来自G-Code终端输出的内容。使用“对象/订阅”终结点获取Klipper状态的更新。

### motion_report/dump_stepper

此终结点用于订阅Klipper的内部Steper Queue_Step命令流以获取Steper。获取这些低级运动更新对于诊断和调试目的可能有用。使用此终结点可能会增加Klipper的系统负载。

请求可以看起来类似于：`{“id”：123，“method”：“Motion_report/Dump_Steper”，“pars”{“name”：“Steper_x”，“Response_Template”：{}`，并且可以返回：`{“id”：123，“Result”：{“Header”[“Interval”，“count”，“Add”]}}`，并且可以稍后产生诸如：`{“paras”：{“first_lock”：179601081，“First_Time”：8.98，“First_Position”：0，“Last_Clock”：219686097，“Last_Time”：10.984，“DATA”：[[179601081，1，0]，[29573，2，-8685]，[16230，4-1525]，[10559，6，-160]，[10000,976，0]，[10000,1000，0]，[10000,1000，0]，[10000,1000，0]，[10.984,1000，0]，[9855，5，187]，[11632，4,1534]，[20756，2,9442]}}`

初始查询响应中的“Header”字段用于描述在随后的“数据”响应中找到的字段。

### 运动_报告/转储_陷阱

该端点用于订阅Klipper内部的“梯形运动队列”。获取这些低级运动更新对于诊断和调试目的可能有用。使用此终结点可能会增加Klipper的系统负载。

请求可能类似于：`{“id”：123，“method”：“Motion_report/ump_trapq”，“pars”：{“name”：“工具头”，“Response_Template”：{}`，并可能返回：`{“id”：1，“Result”：{“Header”：[“time”，“时长”，“Start_Velace”，“Acceleration”，“Start_Position”，并可能在以后产生异步消息，如：`{“参数”：{“数据”：[[4.05.0，1.0，0.0，0.0，[300.0，0.0，0.0]，[0.0，0.0,3000.0]，[5.054，0.001，0.0,3000.0，[300.0，0.0，0.0]，[-1.0，0.0，0.0]]}}`

初始查询响应中的“Header”字段用于描述在随后的“数据”响应中找到的字段。

### adxl345/dump_adxl345

该端点用于订阅ADXL345加速度计数据。获取这些低级运动更新对于诊断和调试目的可能有用。使用此终结点可能会增加Klipper的系统负载。

请求可以看起来类似于：`{“id”：123，“method”：“adxl345/ump_adxl345”，“params”：{“ensor”：“adxl345”，“Response_Template”：{}`，并且可以返回：`{“id”：123，“Result”：{“Header”：[“time”，“x_acceleration”，“y_acceleration”，“z_acceleration”]}}`，并且稍后可能产生诸如：`{“params”：{“overflow”：0，“数据”：[[3292.432935，-535.44309，-1529.8374,9561.4]，[3292.433256，-382.45935，-1606.32927,9561.48375]]}}`

初始查询响应中的“Header”字段用于描述在随后的“数据”响应中找到的字段。

### 角/转储角

该端点用于订阅[角度传感器数据](Config_Reference.md#Angel)。获取这些低级运动更新对于诊断和调试目的可能有用。使用此终结点可能会增加Klipper的系统负载。

请求可能类似于：`{“id”：123，“方法”：“角度/转储_角度”，“参数”：{“传感器”：“我的角度_传感器”，“响应模板”：{}`，并且可能返回：`{“id”：123，“结果”：{“标题”：[“时间”，“角度”]}}`，并且可能稍后产生诸如：`{“参数”：{“位置偏移量”：3.151562，“错误”：0,“data”：[[1290.951905，-5063]，[1290.952321，-5065]}}`

初始查询响应中的“Header”字段用于描述在随后的“数据”响应中找到的字段。

### load_cell/dump_force

This endpoint is used to subscribe to force data produced by a load_cell. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method":"load_cell/dump_force", "params": {"sensor": "load_cell", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["time", "force (g)", "counts", "tare_counts"]}}` and might later produce asynchronous messages such as: `{"params":{"data":[[3292.432935, 40.65, 562534, -234467]]}}`

初始查询响应中的“Header”字段用于描述在随后的“数据”响应中找到的字段。

### load_cell_probe/dump_taps

This endpoint is used to subscribe to details of probing "tap" events. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method":"load_cell/dump_force", "params": {"sensor": "load_cell", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["probe_tap_event"]}}` and might later produce asynchronous messages such as:

```
{"params":{"tap":'{
   "time": [118032.28039, 118032.2834, ...],
   "force": [-459.4213119680034, -458.1640702543264, ...],
}}}
```

This data can be used to render:

* The time/force graph

### 暂停_继续/取消

该端点类似于运行“PRINT_CANCEL”G-Code命令。例如：`{“id”：123，“方法”：“PAUSE_RESUME/Cancel”}`

与“gcode/脚本”终结点一样，该终结点只有在所有挂起的G-Code命令完成后才会完成。

### 暂停_恢复/暂停

此终结点类似于运行“暂停”G-Code命令。例如：`{“id”：123，“方法”：“PAUSE_RESUME/PAUSE”}`

与“gcode/脚本”终结点一样，该终结点只有在所有挂起的G-Code命令完成后才会完成。

### 暂停_恢复/恢复

此终结点类似于运行“Resume”G-Code命令。例如：`{“id”：123，“方法”：“PAUSE_RESUME/RESUME”}`

与“gcode/脚本”终结点一样，该终结点只有在所有挂起的G-Code命令完成后才会完成。

### 查询_结束停止/状态

此终结点将查询活动终结点并返回其状态。例如：`{“id”：123，“Method”：“Query_endstopks/Status”}`可能返回：`{“id”：123，“Result”：{“y”：“Open”，“x”：“Open”，“z”：“Trigated”}`

与“gcode/脚本”终结点一样，该终结点只有在所有挂起的G-Code命令完成后才会完成。

### bed_mesh/dump_mesh

Dumps the configuration and state for the current mesh and all saved profiles.

For example: `{"id": 123, "method": "bed_mesh/dump_mesh"}`

might return:

```
{
    "current_mesh": {
        "name": "eddy-scan-test",
        "probed_matrix": [...],
        "mesh_matrix": [...],
        "mesh_params": {
            "x_count": 9,
            "y_count": 9,
            "mesh_x_pps": 2,
            "mesh_y_pps": 2,
            "algo": "bicubic",
            "tension": 0.5,
            "min_x": 20,
            "max_x": 330,
            "min_y": 30,
            "max_y": 320
        }
    },
    "profiles": {
        "default": {
            "points": [...],
            "mesh_params": {
                "min_x": 20,
                "max_x": 330,
                "min_y": 30,
                "max_y": 320,
                "x_count": 9,
                "y_count": 9,
                "mesh_x_pps": 2,
                "mesh_y_pps": 2,
                "algo": "bicubic",
                "tension": 0.5
            }
        },
        "eddy-scan-test": {
            "points": [...],
            "mesh_params": {
                "x_count": 9,
                "y_count": 9,
                "mesh_x_pps": 2,
                "mesh_y_pps": 2,
                "algo": "bicubic",
                "tension": 0.5,
                "min_x": 20,
                "max_x": 330,
                "min_y": 30,
                "max_y": 320
            }
        },
        "eddy-rapid-test": {
            "points": [...],
            "mesh_params": {
                "x_count": 9,
                "y_count": 9,
                "mesh_x_pps": 2,
                "mesh_y_pps": 2,
                "algo": "bicubic",
                "tension": 0.5,
                "min_x": 20,
                "max_x": 330,
                "min_y": 30,
                "max_y": 320
            }
        }
    },
    "calibration": {
        "points": [...],
        "config": {
            "x_count": 9,
            "y_count": 9,
            "mesh_x_pps": 2,
            "mesh_y_pps": 2,
            "algo": "bicubic",
            "tension": 0.5,
            "mesh_min": [
                20,
                30
            ],
            "mesh_max": [
                330,
                320
            ],
            "origin": null,
            "radius": null
        },
        "probe_path": [...],
        "rapid_path": [...]
    },
    "probe_offsets": [
        0,
        25,
        0.5
    ],
    "axis_minimum": [
        0,
        0,
        -5,
        0
    ],
    "axis_maximum": [
        351,
        358,
        330,
        0
    ]
}
```

The `dump_mesh` endpoint takes one optional parameter, `mesh_args`. This parameter must be an object, where the keys and values are parameters available to [BED_MESH_CALIBRATE](#bed_mesh_calibrate). This will update the mesh configuration and probe points using the supplied parameters prior to returning the result. It is recommended to omit mesh parameters unless it is desired to visualize the probe points and/or travel path before performing `BED_MESH_CALIBRATE`.
