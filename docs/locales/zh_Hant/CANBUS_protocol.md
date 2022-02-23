# CANBUS 協議

本文件描述了 Klipper 通過[CAN匯流排](https://en.wikipedia.org/wiki/CAN_bus)進行通訊的協議。參見<CANBUS.md>瞭解如何在 Klipper 中配置 CAN 匯流排。

## 微控制器 ID 分配

Klipper使用 CAN 2.0A 標準尺寸的 CAN 匯流排數據包，它被限制在8個數據位元組和一個11位的CAN匯流排標識。爲了保證高效的通訊，每個微控制器在執行時被分配一個唯一的 1 位元組的CAN匯流排節點 ID（`canbus_nodeid`）用於一般的 Klipper 命令和響應通訊。從主機到微控制器的 Klipper 命令資訊使用`canbus_nodeid * 2 + 256` 的CAN匯流排 ID，而從微控制器到主機的 Klipper 響應資訊使用`canbus_nodeid * 2 + 256 + 1`。

每個微控制器出廠時都有一個用於ID分配的唯一的晶片識別符號。這個識別符號可以超過一個 CAN 數據包的長度，一個雜湊函式會用出廠識別符號產生一個唯一的 6 位元組標識（`canbus_uuid`）。

## 管理訊息

管理資訊用於 ID 分配。從主機發送到微控制器的管理訊息使用CAN匯流排的 ID `0x3f0`，而從微控制器發送到主機的訊息使用CAN匯流排的 ID `0x3f1`。所有的微控制器都聽從ID `0x3f0`上的訊息；這個 ID 可以被認為是一個"廣播地址"。

### CMD_QUERY_UNASSIGNED 訊息

該命令查詢所有尚未被分配 `canbus_nodeid` 的微控制器。未分配的微控制器將以 RESP_NEED_NODEID 響應訊息進行迴應。

CMD_QUERY_UNASSIGNED 訊息格式是：`<1-byte message_id = 0x00>`

### CMD_SET_NODEID 訊息

這個命令根據微處理器給定的 `canbus_uuid` 給相應的微處理器分配一個 `canbus_nodeid`。

CMD_SET_NODEID訊息格式是：`<1位元組message_id = 0x01><6位元組canbus_uuid><1位元組canbus_nodeid>`

### RESP_NEED_NODEID 訊息

RESP_NEED_NODEID訊息格式為：`<1位元組message_id = 0x20><6位元組canbus_uuid>`

## 數據包

通過 CMD_SET_NODEID 命令分配了節點 ID 的微控制器可以發送和接收數據包。

帶有節點接收 CAN 匯流排ID（`canbus_nodeid * 2 + 256`）的訊息中的數據包被簡單地新增到一個緩衝區，當一個完整的[mcu 協議訊息](Protocol.md)被找到時，其內容會被解析和處理。數據被視為一個位元組流-- Klipper 訊息塊的開始位置與CAN匯流排數據包的開始位置不需要對齊。

類似地，mcu 協議訊息響應通過將訊息數據插入到具有節點發送 CAN 匯流排 ID 的一個或多個數據包（`canbus_nodeid * 2 + 256 + 1`）並從微控制器發送到主機。
