# API 伺服器

該文件介紹Klipper的應用開發者介面（API）功能。該介面允許外部應用程式訪問和控制Klipper主機。

## 啟用API套接字

要啟用API伺服器，klipper.py執行時應加上 `-a` 參數。例如：

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -a /tmp/klippy_uds -l /tmp/klippy.log
```

上述操作會使主機建立一個Unix本地套接字。之後，客戶應用程式可以建立一個套接字鏈接，從而給Klipper發送命令。

See the [Moonraker](https://github.com/Arksine/moonraker) project for a popular tool that can forward HTTP requests to Klipper's API Server Unix Domain Socket.

## 請求格式

套接字進出的數據包應使用JSON編碼的字串，並以ASCII字元0x03作為結尾：

```
<json_object_1><0x03><json_object_2><0x03>...
```

Klipper使用`scripts/whconsole.py`的程式碼進行上述的數據幀打包。例如：

```
~/klipper/scripts/whconsole.py /tmp/klippy_uds
```

該工具會從stdin中讀取一系列的JSON命令，發送到Klipper執行，並將結果送出。該工具預設輸入的每條Json命令中不存在換行，並自動地在發送命令時在結尾附上0x03。（Klipper API伺服器沒有換行符要求。）

## API協議

套接字的命令協議受 [json-rpc](https://www.jsonrpc.org/) 啓發。

一個請求命令類似：

`{"id": 123, "method": "info", "params": {}}`

及一個反應將類似：

`{"id": 123, "result": {"state_message": "Printer is ready", "klipper_path": "/home/pi/klipper", "config_file": "/home/pi/printer.cfg", "software_version": "v0.8.0-823-g883b1cb6", "hostname": "octopi", "cpu_info": "4 core ARMv7 Processor rev 4 (v7l)", "state": "ready", "python_path": "/home/pi/klippy-env/bin/python", "log_file": "/tmp/klippy.log"}}`

每個請求應為一個JSON字典。（本文件使用Python中的術語「字典」描述以`{}`為邊界的「鍵-值」JSON對象。）

請求字典中必須包含一個」method」欄位，其值應包含一個可用的Klipper端點」endpoint」名稱字串。

請求字典可能包含」params」參數，並其值應為一個字典型別。」params」提供Klipper」endpoint」處理請求所需的額外數據，其內容依」endpoint」而定。

請求字典可能包含一個“id”參數，它可以是任何 JSON 類型。如果存在“id”，那麼 Klipper 將使用包含該“id”的響應消息來響應請求。如果省略“id”（或設置為 JSON“null”值），則 Klipper 不會對請求提供任何響應。響應消息是包含“id”和“result”的 JSON 字典。 “結果”始終是一個字典 - 它的內容特定於處理請求的“端點”。

如果處理的請求造成了錯誤，則響應訊息將包含"error"欄位，而不是"result"欄位。例如，請求： `{"id"： 123， "method"： "gcode/script"， "params"： {"script"： "G1 X200"}}` 可能會返回錯誤響應，例如： `{"id"： 123， "error"： {"message"： "Must home axis first： 200.000 0.000 0.000 [0.000]"， "error"： "WebRequestError"}}`

Klipper 會按照收到請求的順序依次處理請求。然而，一些請求可能不會立即完成，這可能會導致相關的響應與其他請求的響應不按順序發送。一個 JSON 請求永遠不會暫停對未來JSON 請求的處理。

## 訂閱

一些 Klipper 的"endpoint"可以以 "訂閱" 的形式接收未來的非同步更新訊息。

例如：

`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{"key": 345}}}`

可能會返回一個初始迴應：

`{"id": 123, "result": {}}`

並導致 Klipper 在未來發送類似於以下內容的訊息：

`{"params": {"response": "ok B:22.8 /0.0 T0:22.4 /0.0"}, "key": 345}`

訂閱請求接受請求的“params”字段中的“response_template”字典。該“response_template”字典用作未來異步消息的模板 - 它可能包含任意鍵/值對。當發送這些未來的異步消息時，Klipper 將在響應模板中添加一個包含具有“端點”特定內容的字典的“參數”字段，然後發送該模板。如果未提供“response_template”字段，則默認為空字典（`{}`）。

## 可用的“端點”

按照慣例，Klipper “端點”的格式為 `<module_name>/<some_name>`。向“端點”發出請求時，必須在請求字典的“方法”參數中設置全名（例如，`{"method"="gcode/restart"}`）。

### 信息

“info”端點用於從 Klipper 獲取系統和版本信息。它還用於向 Klipper 提供客戶端的版本信息。例如：`{"id": 123, "method": "info", "params": { "client_info": { "version": "v1"}}}`

如果存在，“client_info”參數必須是字典，但該字典可能具有任意內容。鼓勵客戶端在首次連接到 Klipper API 服務器時提供客戶端名稱及其軟件版本。

### emergency_stop

“emergency_stop”端點用於指示 Klipper 轉換到“關閉”狀態。它的行為類似於 G-Code `M112` 命令。例如：`{"id": 123, "method": "emergency_stop"}`

### register_remote_method

此端點允許客戶端註冊可以從 klipper 調用的方法。成功後將返回一個空對象。

例如：`{"id": 123, "method": "register_remote_method", "params": {"response_template": {"action": "run_paneldue_beep"}, "remote_method": "paneldue_beep"}}` 將返回：`{“id”：123，“結果”：{}}`

現在可以從 Klipper 調用遠程方法 `paneldue_beep`。請注意，如果該方法採用參數，則應將它們作為關鍵字參數提供。下面是如何從 gcode_macro 調用它的示例：

```
[gcode_macro PANELDUE_BEEP]
gcode:
  {action_call_remote_method("paneldue_beep", frequency=300, duration=1.0)}
```

當執行 PANELDUE_BEEP gcode 宏時，Klipper 將通過套接字發送類似以下內容：`{"action": "run_paneldue_beep", "params": {"frequency": 300, "duration": 1.0}}`

### objects/list

該端點查詢可以查詢的可用打印機“對象”列表（通過“對象/查詢”端點）。例如：`{"id": 123, "method": "objects/list"}` 可能會返回：`{"id": 123, "result": {"objects": ["webhooks", "configfile" , “加熱器”, “gcode_move”, “query_endstops”, “idle_timeout”, “toolhead”, “extruder”]}}`

### objects/query

該端點允許從打印機對像中查詢信息。例如：`{"id": 123, "method": "objects/query", "params": {"objects": {"toolhead": ["position"], "webhooks": null}}}`可能返回：`{"id": 123, "result": {"status": {"webhooks": {"state": "ready", "state_message": "Printer is ready"}, "toolhead": { “位置”：[0.0, 0.0, 0.0, 0.0]}}，“事件時間”：3051555.377933684}}`

請求中的“objects”參數必須是包含要查詢的打印機對象的字典 - 鍵包含打印機對象名稱，值為“null”（查詢所有字段）或字段名稱列表。

響應消息將包含一個“狀態”字段，其中包含帶有查詢信息的字典 - 鍵包含打印機對象名稱，值是包含其字段的字典。響應消息還將包含一個“eventtime”字段，其中包含進行查詢時的時間戳。

可用字段記錄在 [Status Reference](Status_Reference.md) 文檔中。

### objects/subscribe

該端點允許查詢然後訂閱來自打印機對象的信息。端點請求和響應與“對象/查詢”端點相同。例如：`{"id": 123, "method": "objects/subscribe", "params": {"objects":{"toolhead": ["position"], "webhooks": ["state"] }, "response_template":{}}}` 可能返回：`{"id": 123, "result": {"status": {"webhooks": {"state": "ready"}, "toolhead": {"position": [0.0, 0.0, 0.0, 0.0]}}, "eventtime": 3052153.382083195}}` 並導致後續異步消息，例如：`{"params": {"status": {"webhooks": {“狀態”：“關機”}}，“事件時間”：3052165.418815847}}`

### gcode/help

該端點允許查詢已定義幫助字符串的可用 G 代碼命令。例如：`{"id": 123, "method": "gcode/help"}` 可能會返回：`{"id": 123, "result": {"RESTORE_GCODE_STATE": "恢復以前保存的 G-Code state", "PID_CALIBRATE": "運行 PID 校準測試", "QUERY_ADC": "報告模擬引腳的最後值", ...}}`

### gcode/script

該端點允許運行一系列 G 代碼命令。例如：`{"id": 123, "method": "gcode/script", "params": {"script": "G90"}}`

如果提供的 G 代碼腳本引發錯誤，則會生成錯誤響應。但是，如果 G 代碼命令產生終端輸出，則該終端輸出不會在響應中提供。 （使用“gcode/subscribe_output”端點獲取 G-Code 終端輸出。）

如果收到此請求時正在處理 G-Code 命令，則提供的腳本將排隊。這種延遲可能很明顯（例如，如果 G 代碼等待溫度命令正在運行）。當腳本處理完全完成時發送 JSON 響應消息。

### gcode/restart

該端點允許請求重新啟動 - 它類似於運行 G 代碼“RESTART”命令。例如：`{"id": 123, "method": "gcode/restart"}`

與“gcode/script”端點一樣，此端點僅在任何待處理的 G 代碼命令完成後才會完成。

### gcode/firmware_restart

這類似於“gcode/restart”端點——它實現了 G-Code“FIRMWARE_RESTART”命令。例如：`{"id": 123, "method": "gcode/firmware_restart"}`

與“gcode/script”端點一樣，此端點僅在任何待處理的 G 代碼命令完成後才會完成。

### gcode/subscribe_output

此端點用於訂閱由 Klipper 生成的 G-Code 終端消息。例如：`{"id": 123, "method": "gcode/subscribe_output", "params": {"response_template":{}}}` 可能稍後會產生異步消息，例如：`{"params": { "response": "// Klipper 狀態：關機"}}`

該端點旨在通過“終端窗口”界面支持人機交互。不鼓勵從 G 代碼終端輸出解析內容。使用“objects/subscribe”端點獲取 Klipper 狀態的更新。

### motion_report/dump_stepper

此端點用於為步進器訂閱 Klipper 的內部步進器 queue_step 命令流。獲取這些低級運動更新可能對診斷和調試有用。使用此端點可能會增加 Klipper 的系統負載。

一個請求可能看起來像：`{"id": 123, "method":"motion_report/dump_stepper", "params": {"name": "stepper_x", "response_template": {}}}` 並且可能返回： `{"id": 123, "result": {"header": ["interval", "count", "add"]}}` 之後可能會產生異步消息，例如：`{"params": {" first_clock”：179601081，“first_time”：8.98，“first_position”：0，“last_clock”：219686097，“last_time”：10.984，“data”：[[179601081, 1, 0], [29573, 2, -8685] , [16230, 4, -1525], [10559, 6, -160], [10000, 976, 0], [10000, 1000, 0], [10000, 1000, 0], [10000, 1000, 0] , [9855, 5, 187], [11632, 4, 1534], [20756, 2, 9442]]}}`

初始查詢響應中的“header”字段用於描述在以後的“data”響應中找到的字段。

### motion_report/dump_trapq

該端點用於訂閱 Klipper 的內部“梯形運動隊列”。獲取這些低級運動更新可能對診斷和調試有用。使用此端點可能會增加 Klipper 的系統負載。

一個請求可能看起來像：`{"id": 123, "method": "motion_report/dump_trapq", "params": {"name": "toolhead", "response_template":{}}}` 並且可能返回： `{"id": 1, "result": {"header": ["time", "duration", "start_velocity", "acceleration", "start_position", "direction"]}}` 並且以後可能會產生異步消息，例如：`{"params": {"data": [[4.05, 1.0, 0.0, 0.0, [300.0, 0.0, 0.0], [0.0, 0.0, 0.0]], [5.054, 0.001, 0.0, 3000.0 , [300.0, 0.0, 0.0], [-1.0, 0.0, 0.0]]]}}`

初始查詢響應中的“header”字段用於描述在以後的“data”響應中找到的字段。

### adxl345/dump_adxl345

該端點用於訂閱 ADXL345 加速度計數據。獲取這些低級運動更新可能對診斷和調試有用。使用此端點可能會增加 Klipper 的系統負載。

請求可能類似於：`{"id": 123, "method":"adxl345/dump_adxl345", "params": {"sensor": "adxl345", "response_template": {}}}` 並且可能返回： `{"id": 123,"result":{"header":["time","x_acceleration","y_acceleration", "z_acceleration"]}}` 並且可能稍後會產生異步消息，例如：`{"params ":{"溢出":0,"數據":[[3292.432935,-535.44309,-1529.8374,9561.4], [3292.433256,-382.45935,-1606.32927,9561.48375]}}`

初始查詢響應中的“header”字段用於描述在以後的“data”響應中找到的字段。

### angle/dump_angle

This endpoint is used to subscribe to [angle sensor data](Config_Reference.md#angle). Obtaining these low-level motion updates may be useful for diagnostic and debugging purposes. Using this endpoint may increase Klipper's system load.

A request may look like: `{"id": 123, "method":"angle/dump_angle", "params": {"sensor": "my_angle_sensor", "response_template": {}}}` and might return: `{"id": 123,"result":{"header":["time","angle"]}}` and might later produce asynchronous messages such as: `{"params":{"position_offset":3.151562,"errors":0, "data":[[1290.951905,-5063],[1290.952321,-5065]]}}`

初始查詢響應中的“header”字段用於描述在以後的“data”響應中找到的字段。

### pause_resume/cancel

此端點類似於運行“PRINT_CANCEL”G 代碼命令。例如：`{"id": 123, "method": "pause_resume/cancel"}`

與“gcode/script”端點一樣，此端點僅在任何待處理的 G 代碼命令完成後才會完成。

### pause_resume/pause

此端點類似於運行“PAUSE”G 代碼命令。例如：`{"id": 123, "method": "pause_resume/pause"}`

與“gcode/script”端點一樣，此端點僅在任何待處理的 G 代碼命令完成後才會完成。

### pause_resume/resume

此端點類似於運行“RESUME”G 代碼命令。例如：`{"id": 123, "method": "pause_resume/resume"}`

與“gcode/script”端點一樣，此端點僅在任何待處理的 G 代碼命令完成後才會完成。

### query_endstops/status

該端點將查詢活動端點並返回它們的狀態。例如：`{"id": 123, "method": "query_endstops/status"}` 可能返回：`{"id": 123, "result": {"y": "open", "x": “打開”，“z”：“觸發”}}`

與“gcode/script”端點一樣，此端點僅在任何待處理的 G 代碼命令完成後才會完成。
