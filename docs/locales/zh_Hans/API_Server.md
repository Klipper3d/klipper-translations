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

This endpoint allows one to request a restart - it is similar to running the G-Code "RESTART" command. For example: `{"id": 123, "method": "gcode/restart"}`

As with the "gcode/script" endpoint, this endpoint only completes after any pending G-Code commands complete.

### gcode/firmware_restart

This is similar to the "gcode/restart" endpoint - it implements the G-Code "FIRMWARE_RESTART" command. For example: `{"id": 123, "method": "gcode/firmware_restart"}`

As with the "gcode/script" endpoint, this endpoint only completes after any pending G-Code commands complete.

### gcode/subscribe_output

This endpoint is used to subscribe to G-Code terminal messages that are generated by Klipper. For example: `{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{}}}` might later produce asynchronous messages such as: `{"params": {"response": "// Klipper state: Shutdown"}}`

This endpoint is intended to support human interaction via a "terminal window" interface. Parsing content from the G-Code terminal output is discouraged. Use the "objects/subscribe" endpoint to obtain updates on Klipper's state.

### motion_report/dump_stepper

This endpoint is used to subscribe to Klipper's internal stepper queue_step command stream for a stepper. Obtaining these low-level motion updates may be useful for diagnostic and debugging purposes. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method":"motion_report/dump_stepper", "params": {"name": "stepper_x", "response_template": {}}}` and might return: `{"id": 123, "result": {"header": ["interval", "count", "add"]}}` and might later produce asynchronous messages such as: `{"params": {"first_clock": 179601081, "first_time": 8.98, "first_position": 0, "last_clock": 219686097, "last_time": 10.984, "data": [[179601081, 1, 0], [29573, 2, -8685], [16230, 4, -1525], [10559, 6, -160], [10000, 976, 0], [10000, 1000, 0], [10000, 1000, 0], [10000, 1000, 0], [9855, 5, 187], [11632, 4, 1534], [20756, 2, 9442]]}}`

The "header" field in the initial query response is used to describe the fields found in later "data" responses.

### motion_report/dump_trapq

This endpoint is used to subscribe to Klipper's internal "trapezoid motion queue". Obtaining these low-level motion updates may be useful for diagnostic and debugging purposes. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method": "motion_report/dump_trapq", "params": {"name": "toolhead", "response_template":{}}}` and might return: `{"id": 1, "result": {"header": ["time", "duration", "start_velocity", "acceleration", "start_position", "direction"]}}` and might later produce asynchronous messages such as: `{"params": {"data": [[4.05, 1.0, 0.0, 0.0, [300.0, 0.0, 0.0], [0.0, 0.0, 0.0]], [5.054, 0.001, 0.0, 3000.0, [300.0, 0.0, 0.0], [-1.0, 0.0, 0.0]]]}}`

The "header" field in the initial query response is used to describe the fields found in later "data" responses.

### adxl345/dump_adxl345

This endpoint is used to subscribe to ADXL345 accelerometer data. Obtaining these low-level motion updates may be useful for diagnostic and debugging purposes. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method":"adxl345/dump_adxl345", "params": {"sensor": "adxl345", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["time","x_acceleration","y_acceleration", "z_acceleration"]}}` and might later produce asynchronous messages such as: `{"params":{"overflows":0,"data":[[3292.432935,-535.44309,-1529.8374,9561.4], [3292.433256,-382.45935,-1606.32927,9561.48375]]}}`

The "header" field in the initial query response is used to describe the fields found in later "data" responses.

### angle/dump_angle

This endpoint is used to subscribe to [angle sensor data](Config_Reference.md#angle). Obtaining these low-level motion updates may be useful for diagnostic and debugging purposes. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method":"angle/dump_angle", "params": {"sensor": "my_angle_sensor", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["time","angle"]}}` and might later produce asynchronous messages such as: `{"params":{"position_offset":3.151562,"errors":0, "data":[[1290.951905,-5063],[1290.952321,-5065]]}}`

The "header" field in the initial query response is used to describe the fields found in later "data" responses.

### pause_resume/cancel

This endpoint is similar to running the "PRINT_CANCEL" G-Code command. For example: `{"id": 123, "method": "pause_resume/cancel"}`

As with the "gcode/script" endpoint, this endpoint only completes after any pending G-Code commands complete.

### pause_resume/pause

This endpoint is similar to running the "PAUSE" G-Code command. For example: `{"id": 123, "method": "pause_resume/pause"}`

As with the "gcode/script" endpoint, this endpoint only completes after any pending G-Code commands complete.

### pause_resume/resume

This endpoint is similar to running the "RESUME" G-Code command. For example: `{"id": 123, "method": "pause_resume/resume"}`

As with the "gcode/script" endpoint, this endpoint only completes after any pending G-Code commands complete.

### query_endstops/status

This endpoint will query the active endpoints and return their status. For example: `{"id": 123, "method": "query_endstops/status"}` might return: `{"id": 123, "result": {"y": "open", "x": "open", "z": "TRIGGERED"}}`

As with the "gcode/script" endpoint, this endpoint only completes after any pending G-Code commands complete.
