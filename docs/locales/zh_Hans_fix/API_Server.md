# API 服务器

本文档描述了 Klipper 的应用程序编程接口（API）。该接口允许外部应用程序查询和控制 Klipper 主机软件。

## 启用 API 套接字

为了使用 API 服务器，必须使用 `-a` 参数启动 klippy.py 主机软件。例如：
```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

这将导致主机软件创建一个 Unix 域套接字。然后，客户端可以在此套接字上打开连接并向 Klipper 发送命令。

请参阅 [Moonraker](https://github.com/Arksine/moonraker) 项目，这是一个流行的工具，可以将 HTTP 请求转发到 Klipper 的 API 服务器 Unix 域套接字。

## 请求格式

在套接字上发送和接收的消息是经过 JSON 编码的字符串，以 ASCII 0x03 字符结尾：
```
<json_object_1><0x03><json_object_2><0x03>...
```

Klipper 包含一个 `scripts/whconsole.py` 工具，可以执行上述消息封装。例如：
```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

该工具可以从标准输入读取一系列 JSON 命令，将其发送到 Klipper，并报告结果。该工具期望每个 JSON 命令位于单行上，并且在传输请求时会自动附加 0x03 终止符。（Klipper API 服务器没有换行要求。）

## API 协议

通信套接字上使用的命令协议受到 [json-rpc](https://www.jsonrpc.org/) 的启发。

一个请求可能如下所示：

`{"id": 123, "method": "info", "params": {}}`

而一个响应可能如下所示：

`{"id": 123, "result": {"state_message": "Printer is ready",
"klipper_path": "/home/pi/klipper", "config_file":
"/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6",
"hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4
(v7l)", "state": "ready", "python_path":
"/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}`

每个请求必须是一个 JSON 字典。（本文档使用 Python 术语“字典”来描述“JSON 对象”——即包含在 `{}` 内的键/值对映射。）

请求字典必须包含一个“method”参数，该参数是可用 Klipper “端点”的字符串名称。

请求字典可能包含一个“params”参数，该参数必须是字典类型。“params”向处理请求的 Klipper “端点”提供额外的参数信息。其内容特定于“端点”。

请求字典可能包含一个“id”参数，该参数可以是任何 JSON 类型。如果存在“id”，则 Klipper 将以包含该“id”的响应消息进行回复。如果省略“id”（或将其设置为 JSON “null”值），则 Klipper 不会提供任何响应。响应消息是包含“id”和“result”的 JSON 字典。“result”始终是一个字典——其内容特定于处理请求的“端点”。

如果请求处理导致错误，则响应消息将包含“error”字段而不是“result”字段。例如，请求：
`{"id": 123, "method": "gcode/script", "params": {"script": "G1
X200"}}`
可能会导致错误响应，例如：
`{"id": 123, "error": {"message": "Must home axis
first: 200.000 0.000 0.000 [0.000]", "error": "WebRequestError"}}`

Klipper 始终会按照接收请求的顺序开始处理请求。但是，某些请求可能不会立即完成，这可能导致相关响应相对于其他请求的响应无序发送。JSON 请求永远不会暂停后续 JSON 请求的处理。

## 订阅

某些 Klipper “端点”请求允许“订阅”未来的异步更新消息。

例如：

`{"id": 123, "method": "gcode/subscribe_output", "params":
{"response_template":{"key": 345}}}`

可能最初响应为：

`{"id": 123, "result": {}}`

并导致 Klipper 发送类似以下的未来消息：

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

订阅请求在请求的“params”字段中接受一个“response_template”字典。该“response_template”字典用作未来异步消息的模板——它可以包含任意的键/值对。在发送这些未来的异步消息时，Klipper 将向响应模板添加一个包含字典的“params”字段（其内容特定于“端点”），然后发送该模板。如果未提供“response_template”字段，则默认为空字典（`{}`）。

## 可用“端点”

按照惯例，Klipper “端点”采用 `<module_name>/<some_name>` 的形式。向“端点”发出请求时，必须在请求字典的“method”参数中设置完整名称（例如，`{"method"="gcode/restart"}`）。

### info

“info”端点用于从 Klipper 获取系统和版本信息。它也用于向 Klipper 提供客户端的版本信息。例如：
`{"id": 123, "method": "info", "params": { "client_info": { "version":
"v1"}}}`

如果存在，“client_info”参数必须是字典，但该字典可以包含任意内容。鼓励客户端在首次连接到 Klipper API 服务器时提供客户端名称及其软件版本。

### emergency_stop

“emergency_stop”端点用于指示 Klipper 过渡到“shutdown”状态。它的行为类似于 G-Code `M112` 命令。例如：
`{"id": 123, "method": "emergency_stop"}`

### register_remote_method

此端点允许客户端注册可以从 Klipper 调用的方法。成功时，它将返回一个空对象。

例如：
`{"id": 123, "method": "register_remote_method",
"params": {"response_template": {"action": "run_paneldue_beep"},
"remote_method": "paneldue_beep"}}`
将返回：
`{"id": 123, "result": {}}`

现在可以从 Klipper 调用远程方法 `paneldue_beep`。请注意，如果该方法需要参数，则应将其作为关键字参数提供。以下是如何从 gcode_macro 调用它的示例：
```
[gcode_macro PANELDUE_BEEP]
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

当执行 PANELDUE_BEEP gcode 宏时，Klipper 会通过套接字发送类似以下内容：
`{"action": "run_paneldue_beep",
"params": {"frequency": 300, "duration": 1.0}}`

### objects/list

此端点查询可查询的打印机“对象”列表（通过“objects/query”端点）。例如：
`{"id": 123, "method": "objects/list"}`
可能会返回：
`{"id": 123, "result": {"objects":
["webhooks", "configfile", "heaters", "gcode_move", "query_endstops",
"idle_timeout", "toolhead", "extruder"]}}`

### objects/query

此端点允许查询打印机对象的信息。例如：
`{"id": 123, "method": "objects/query", "params": {"objects":
{"toolhead": ["position"], "webhooks": null}}}`
可能会返回：
`{"id": 123, "result": {"status": {"webhooks": {"state": "ready",
"state_message": "Printer is ready"}, "toolhead": {"position":
[0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3051555.377933684}}`

请求中的“objects”参数必须是包含要查询的打印机对象的字典——键包含打印机对象名称，值为“null”（查询所有字段）或字段名称列表。

响应消息将包含一个“status”字段，该字段包含一个字典，其中包含查询到的信息——键包含打印机对象名称，值是包含其字段的字典。响应消息还将包含一个“eventtime”字段，其中包含查询时的时间戳。

可用字段在 [状态参考](Status_Reference.md) 文档中记录。

### objects/subscribe

此端点允许查询并订阅打印机对象的信息。端点请求和响应与“objects/query”端点相同。例如：
`{"id": 123, "method": "objects/subscribe", "params":
{"objects":{"toolhead": ["position"], "webhooks": ["state"]},
"response_template":{}}}`
可能会返回：
`{"id": 123, "result": {"status": {"webhooks": {"state": "ready"},
"toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}},
"eventtime": 3052153.382083195}}`
并导致后续异步消息，例如：
`{"params": {"status": {"webhooks": {"state": "shutdown"}},
"eventtime": 3052165.418815847}}`

### gcode/help

此端点允许查询具有帮助字符串定义的可用 G-Code 命令。例如：
`{"id": 123, "method": "gcode/help"}`
可能会返回：
`{"id": 123, "result": {"RESTORE_GCODE_STATE": "Restore a previously
saved G-Code state", "PID_CALIBRATE": "Run PID calibration test",
"QUERY_ADC": "Report the last value of an analog pin", ...}}`

### gcode/script

此端点允许运行一系列 G-Code 命令。例如：
`{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}`

如果提供的 G-Code 脚本引发错误，则会生成错误响应。但是，如果 G-Code 命令产生终端输出，则该终端输出不会在响应中提供。（使用“gcode/subscribe_output”端点获取 G-Code 终端输出。）

如果在收到此请求时正在处理 G-Code 命令，则提供的脚本将被排队。此延迟可能很大（例如，如果正在运行 G-Code 等待温度命令）。当脚本处理完全完成时，会发送 JSON 响应消息。

### gcode/restart

此端点允许请求重启——类似于运行 G-Code “RESTART” 命令。例如：
`{"id": 123, "method": "gcode/restart"}`

与“gcode/script”端点一样，此端点仅在任何待处理的 G-Code 命令完成后才完成。

### gcode/firmware_restart

这类似于“gcode/restart”端点——它实现了 G-Code “FIRMWARE_RESTART” 命令。例如：
`{"id": 123, "method": "gcode/firmware_restart"}`

与“gcode/script”端点一样，此端点仅在任何待处理的 G-Code 命令完成后才完成。

### gcode/subscribe_output

此端点用于订阅 Klipper 生成的 G-Code 终端消息。例如：
`{"id": 123, "method": "gcode/subscribe_output", "params":
{"response_template":{}}}`
稍后可能会产生异步消息，例如：
`{"params": {"response": "// Klipper state: Shutdown"}}`

此端点旨在通过“终端窗口”界面支持人机交互。不建议解析 G-Code 终端输出中的内容。使用“objects/subscribe”端点获取 Klipper 状态的更新。

### motion_report/dump_stepper

此端点用于订阅 Klipper 内部步进电机的 queue_step 命令流。获取这些低级运动更新可能对诊断和调试有用。使用此端点可能会增加 Klipper 的系统负载。

请求可能如下所示：
`{"id": 123, "method":"motion_report/dump_stepper",
"params": {"name": "stepper_x", "response_template": {}}}`
可能会返回：
`{"id": 123, "result": {"header": ["interval", "count", "add"]}}`
稍后可能会产生异步消息，例如：
`{"params": {"first_clock": 179601081, "first_time": 8.98,
"first_position": 0, "last_clock": 219686097, "last_time": 10.984,
"data": [[179601081, 1, 0], [29573, 2, -8685], [16230, 4, -1525],
[10559, 6, -160], [10000, 976, 0], [10000, 1000, 0], [10000, 1000, 0],
[10000, 1000, 0], [9855, 5, 187], [11632, 4, 1534], [20756, 2, 9442]]}}`

初始查询响应中的“header”字段用于描述后续“data”响应中的字段。

### motion_report/dump_trapq

此端点用于订阅 Klipper 内部的“梯形运动队列”。获取这些低级运动更新可能对诊断和调试有用。使用此端点可能会增加 Klipper 的系统负载。

请求可能如下所示：
`{"id": 123, "method": "motion_report/dump_trapq", "params":
{"name": "toolhead", "response_template":{}}}`
可能会返回：
`{"id": 1, "result": {"header": ["time", "duration",
"start_velocity", "acceleration", "start_position", "direction"]}}`
稍后可能会产生异步消息，例如：
`{"params": {"data": [[4.05, 1.0, 0.0, 0.0, [300.0, 0.0, 0.0],
[0.0, 0.0, 0.0]], [5.054, 0.001, 0.0, 3000.0, [300.0, 0.0, 0.0],
[-1.0, 0.0, 0.0]]]}}`

初始查询响应中的“header”字段用于描述后续“data”响应中的字段。

### adxl345/dump_adxl345

此端点用于订阅 ADXL345 加速度计数据。获取这些低级运动更新可能对诊断和调试有用。使用此端点可能会增加 Klipper 的系统负载。

请求可能如下所示：
`{"id": 123, "method":"adxl345/dump_adxl345",
"params": {"sensor": "adxl345", "response_template": {}}}`
可能会返回：
`{"id": 123,"result":{"header":["time","x_acceleration","y_acceleration",
"z_acceleration"]}}`
稍后可能会产生异步消息，例如：
`{"params":{"overflows":0,"data":[[3292.432935,-535.44309,-1529.8374,9561.4],
[3292.433256,-382.45935,-1606.32927,9561.48375]]}}`

初始查询响应中的“header”字段用于描述后续“data”响应中的字段。

### angle/dump_angle

此端点用于订阅[角度传感器数据](Config_Reference.md#angle)。获取这些低级运动更新可能对诊断和调试有用。使用此端点可能会增加 Klipper 的系统负载。

请求可能如下所示：
`{"id": 123, "method":"angle/dump_angle",
"params": {"sensor": "my_angle_sensor", "response_template": {}}}`
可能会返回：
`{"id": 123,"result":{"header":["time","angle"]}}`
稍后可能会产生异步消息，例如：
`{"params":{"position_offset":3.151562,"errors":0,
"data":[[1290.951905,-5063],[1290.952321,-5065]]}}`

初始查询响应中的“header”字段用于描述后续“data”响应中的字段。

### load_cell/dump_force

此端点用于订阅由 load_cell 产生的力数据。使用此端点可能会增加 Klipper 的系统负载。

请求可能如下所示：
`{"id": 123, "method":"load_cell/dump_force",
"params": {"sensor": "load_cell", "response_template": {}}}`
可能会返回：
`{"id": 123,"result":{"header":["time", "force (g)", "counts", "tare_counts"]}}`
稍后可能会产生异步消息，例如：
`{"params":{"data":[[3292.432935, 40.65, 562534, -234467]]}}`

初始查询响应中的“header”字段用于描述后续“data”响应中的字段。

### load_cell_probe/dump_taps

此端点用于订阅探针“tap”事件的详细信息。使用此端点可能会增加 Klipper 的系统负载。

请求可能如下所示：
`{"id": 123, "method":"load_cell/dump_force",
"params": {"sensor": "load_cell", "response_template": {}}}`
可能会返回：
`{"id": 123,"result":{"header":["probe_tap_event"]}}`
稍后可能会产生异步消息，例如：
```
{"params":{"tap":'{
   "time": [118032.28039, 118032.2834, ...],
   "force": [-459.4213119680034, -458.1640702543264, ...],
}}}
```

这些数据可用于渲染：
* 时间/力图

### pause_resume/cancel

此端点类似于运行“PRINT_CANCEL” G-Code 命令。例如：
`{"id": 123, "method": "pause_resume/cancel"}`

与“gcode/script”端点一样，此端点仅在任何待处理的 G-Code 命令完成后才完成。

### pause_resume/pause

此端点类似于运行“PAUSE” G-Code 命令。例如：
`{"id": 123, "method": "pause_resume/pause"}`

与“gcode/script”端点一样，此端点仅在任何待处理的 G-Code 命令完成后才完成。

### pause_resume/resume

此端点类似于运行“RESUME” G-Code 命令。例如：
`{"id": 123, "method": "pause_resume/resume"}`

与“gcode/script”端点一样，此端点仅在任何待处理的 G-Code 命令完成后才完成。

### query_endstops/status

此端点将查询活动的端点并返回其状态。例如：
`{"id": 123, "method": "query_endstops/status"}`
可能会返回：
`{"id": 123, "result": {"y": "open", "x": "open", "z": "TRIGGERED"}}`

与“gcode/script”端点一样，此端点仅在任何待处理的 G-Code 命令完成后才完成。

### bed_mesh/dump_mesh

转储当前网格和所有已保存配置文件的配置和状态。

例如：
`{"id": 123, "method": "bed_mesh/dump_mesh"}`

可能会返回：

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

`dump_mesh` 端点接受一个可选参数 `mesh_args`。此参数必须是一个对象，其键和值是 [BED_MESH_CALIBRATE](#bed_mesh_calibrate) 可用的参数。这将在返回结果之前使用提供的参数更新网格配置和探针点。除非希望在执行 `BED_MESH_CALIBRATE` 之前可视化探针点和/或行进路径，否则建议省略网格参数。