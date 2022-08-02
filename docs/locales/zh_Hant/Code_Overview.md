# 程式碼總覽

本文件將描述Klipper的程式碼總體結構和程式碼流。

## 資料夾結構

**src/**包含微控制器的C原始碼。其中**src/atsam/**, **src/atsamd/**, **src/avr/**, **src/linux/**, **src/lpc176x/**, **src/pru/**, and **src/stm32/** 為對應微處理器架構的原始碼。 **src/simulator/** 包含有用於交叉編譯、測試目標微處理器的程式碼。**src/generic/**為對不同架構均有用的程式碼。編譯"board/somefile.h"時，編譯器會優先使用 架構特定的目錄 (即src/avr/somefile.h)隨後找尋通用目錄(即 src/generic/somefile.h)。

**klippy/**目錄包含了上位機軟體。軟體大部分由Python實現，同時**klippy/chelper/** 目錄包含了由C實現的有用程式碼。**klippy/kinematics/**目錄包含機械運動學的實現程式碼。**klippy/extras/** 目錄包含了上位機的擴建模組("modules")。

**lib/**包含了構建必須的第三方庫程式碼。

**config/**包含了印表機配置的實例檔案。

**scripts/**目錄包含了編譯微控制器程式碼時有用的指令碼。

**test/**目錄包含了自動測試示例。

在編譯過程重，編譯器會構建**out/**目錄。該目錄包含構建時的臨時檔案。對於AVR架構，編譯器輸出的為**out/klipper.elf.hex**，而對ARM架構則為**out/klipper.bin**。

## 微處理器的程式碼流

微控制器的程式碼從對應架構的程式碼(即**src/avr/main.c**)開始執行，前述程式碼會持續呼叫**src/sched.c**中的 sched_main() 函式。sched_main() 程式碼會先執行經 DECL_INIT() 宏標註的所有函式。之後它將不斷重複執行由 DECL_TASK() 宏所標註的函式。

其中一個主要的任務函式為**src/command.c** 中的command_dispatch()。上述函式經由微處理器特定的 輸入/輸出 程式碼呼叫(即**src/avr/serial.c**, **src/generic/serial_irq.c**)，並執行輸入流中的命令所對應的命令函式。命令函式通過 DECL_COMMAND() 宏進行定義 (詳情參照[協議](Protocol.md) 文件)。

任務”功能的長時間延遲會導致其他“任務”的調度抖動 - 超過 100us 的延遲可能會變得很明顯，超過 500us 的延遲可能會導致命令重傳，超過 100ms 的延遲可能會導致看門狗重新啟動。）這些功能將工作安排在通過安排計時器的特定時間。

定時函式通過呼叫sched_add_timer() (即 **src/sched.c**)方法進行註冊。排程器會在設定的時間點對註冊的函式進行呼叫。定時器中斷會在微處理器架構特定的初始化處理器中處理(例如 **src/avr/timer.c**)，該程式碼會呼叫 **src/sched.c**中的sched_timer_dispatch()。通過定時器中斷執行註冊的定時函式。定時函式總在中斷禁用下執行。定時函式應總能在數微秒內完成。在定時函式結束時，該函式可對自身進行重新定時。

如果事件中拋出錯誤， 程式碼可呼叫shutdown()（**src/sched.c**中的sched_shutdown()）。呼叫shutdown()會導致所有標記為DECL_SHUTDOWN()宏的函式被執行。shutdown()總是在禁用中斷的情況下執行。

微控制器的大部分功能涉及到通用輸入輸出引腳（GPIO）的操作。爲了從高級任務程式碼中抽像出特定架構底層程式碼，所有的GPIO事件都在特定架構的包裝器中實現（如，**src/avr/gpio.c**）。程式碼使用gcc的"-flto -fwhole-program "來優化編譯，以實現行內函數的高效能交叉編譯，大多數微小的GPIO操作函式內聯到它們的呼叫器中，使用這些GPIO將沒有任何執行時成本。

## 程式碼總覽

上位機程式（klippy）執行在廉價計算機（如 樹莓派）上，配搭mcu使用。該程式的主要程式語言為Python，同時部分功能通過CFFI在C語言上實現。

上位機程式通過** klippy/klippy.py**初始化。該檔案會讀取命令列參數，打開印表機的設定檔案，實例化印表機的主要模組，並啟用串列埠通訊。G程式碼命令的執行則通過 **klippy/gcode.py**中的 process_commands() 方法實現。此程式碼將G程式碼轉化為印表機的對象呼叫，它將頻繁地將G程式碼命令轉化為微控制器的行動指令（通過微控制器程式碼中的 DECL_COMMAND 進行聲明）。

Klippy上位機程式包含四個程序。主執行緒用於處理輸入的G程式碼命令。第二執行緒通過串列埠實現底層IO的處理（程式碼位於 **klippy/chelper/serialqueue.c **以C語言實現）。第三執行緒則通過Python程式碼處理微控制器返回的資訊（參照 klippy/serialhdl.py）。第四執行緒則負責將Debug資訊寫入到日誌檔案(見 **klippy/queuelogger.py**)，由此，其他執行緒的執行將不會阻塞日誌的寫入。

## 典型運動命令的程式碼流

典型的印表機運動始於klipper上位機接收到"G1"命令，並在微控制器發出對應的步進脈衝結束。本節將簡述典型運動命令的程式碼流。[運動學](Kinematics.md)文件將更為細緻的描述運動的機械原理。

* 移動命令的處理始於gcode.py，該程式碼將G程式碼轉化為內部呼叫。G1命令將呼叫klippy/extras/gcode_move.py中的cmd_G1()函式。gcode_move.py中的程式碼將處理 原點變換（G92），絕對座標模式（G90）和單位變換（如F6000=100mm/s）。一個移動命令的處理路徑為：`_process_data() -> _process_commands() -> cmd_G1()`。最終將呼叫ToolHead類的方法實現移動 `cmd_G1() -> ToolHead.move()`。
* ToolHead類（位於toolhead.py）處理「前瞻」行為和記錄列印的時間點。移動命令的程式碼路徑為 `ToolHead.move() -> MoveQueue.add_move() -> MoveQueue.flush() -> Move.set_junction() -> ToolHead._process_moves()`。
   * ToolHead.move()將建立一個Move()對像實例，其中將包含移動的參數（在笛卡爾空間中，並這些參數以mm和s為單位）。
   * kinematics類將檢查每個運動命令（`ToolHead.move() -> kin.check_move()`）。各種kinematics類存放于 klippy/kinematics/ 目錄。check_move()能在運動命令不合理時拋出錯誤。如果 check_move()成功，這意味著印表機必定能完成運動命令。
   * MoveQueue.add_move()將一個move實例新增到「前瞻」佇列。
   * MoveQueue.flush()將進行每次運動 起始和結束 速度。
   * Move.set_junction()實現移動的「梯形加減速（trapezoid generator）」。「梯形加減速」將每次移動拆分為三部分：恒加速度加速階段、恒速度階段、恒加速度減速階段。所有移動均含有上述三個階段，但單個階段的持續時間可能為0。
   * 當ToolHead._process_moves()被呼叫時，一次移動的所有要素均已就緒——移動的起始位置、結束位置、加速度、起始/巡航/結束速度、以及起始/巡航/結束的距離。所有資訊以笛卡爾座標的形式儲存在Move()實例中，單位為mm和s。
* Klipper使用[迭代求解](https://en.wikipedia.org/wiki/Root-finding_algorithm)的方式產生步進電機的每步的時長。爲了提高效率，步進脈衝時間是以C語言程式碼產生。一個運動先經過「梯形運動佇列化」 ：`ToolHead._process_moves() -> trapq_append()` (位於 klippy/chelper/trapq.c)，然後產生步進時間 `ToolHead._process_moves() -> ToolHead._update_move_time() -> MCU_Stepper.generate_steps() -> itersolve_generate_steps() -> itersolve_gen_steps_range()` (位於 klippy/chelper/itersolve.c)。迭代求解器通過一個時間-位置方程計算出步進時間。求解時通過「假定」時間點，以時間-位置方程計算出下一步的位置。如果計算結果與實際需求的下一步位置一致，假定值將用於實際運動；否則，通過計算結果對「假定時間」進行修正，並進行下一次試算。這種反饋方式會使迭代快速收斂。運動學所使用的時間-位置函式位於 klippy/chelper/ 目錄 (例如, kin_cart.c, kin_corexy.c, kin_delta.c, kin_extruder.c)。
* 需要注意，擠出機有獨特的運動學模型，使用`ToolHead._process_moves() -> PrinterExtruder.move()`類繼續寧處理。儘管擠出機使用了獨立的Move()類，由於Move() 實例包含了實際運動的時間，並且脈衝時間的裝置是定時發送到微控制器上，因此由擠出機類產生的步進運動將與列印頭的運動同步。
* 當迭代計算器計算出步進時長后，計算結果將被置於一個陣列中：`itersolve_gen_steps_range() -> stepcompress_append()` (位於 klippy/chelper/stepcompress.c)。陣列(結構體 stepcompress.queue)儲存每一步對應的微處理器時鐘計數器時間。上述的「微處理器計數器」的值指的是微處理器硬體上的計數器——其值基於微處理器最後一次上電而定。
* 接下來重要的是，對步進數據進行壓縮： `stepcompress_flush() -> compress_bisect_add()` (位於 klippy/chelper/stepcompress.c)。上述程式碼將基於前述的 步進時間列表 產生和編碼一系列的微控制器"queue_step"（佇列步進）命令。這些"queue_step"命令將被佇列化，優先處理，併發送到微控制器中（上位機通過 stepcompress.c:steppersync；下位機通過serialqueue.c:serialqueue)）。
* 在微控制器，queue_step命令將經由 src/command.c 處理。改程式碼將對命令進行解釋，並呼叫 `command_queue_step()`。command_queue_step()（位於src/stepper.c）將每個queue_step命令的參數附加到對應的步進佇列中。正常執行下，一「步」將在其執行前100ms被解釋並加入佇列。最後通過 `stepper_event()`結束步進事件的產生。該程式碼會基於queue_step命令的參數產生步進脈衝，並安排下一次步進脈衝產生的時間。硬體定時器發出中斷，在設定的事件呼叫相應的stepper_event。queue_step命令的參數包含「間隔」、「計數」、「增量」。總體而言，stepper_event()將執行下列內容，「記錄時間」: `do_step(); next_wake_time = last_wake_time + interval; interval += add;`

上面的運動過程看似十分複雜。然而，真正需要注意的只有ToolHead（列印頭） 和 kinematic （運動學）類，上述兩個類的程式碼確定了運動執行和定時。剩下的程式碼僅用於處理通訊和管道的問題。

## 新增上位機模組

Klippy上位機的主程式能對模組進行熱載入。如果設定檔案中出現了類似"[my_module]" 的欄位名，程式會自動嘗試載入 klippy/extras/my_module.py 檔案內的模組。Klipper推薦使用上述方式擴充套件Klipper功能。

新增模組的最簡單的方式是參照已有的模組 - 下面將以 **klippy/extras/servo.py **作為例子。

下面是另一些有用的資訊：

* 模組的運作起始於模組級別的`load_config()`函式（針對形如 [my_module] 的配置塊）或`load_config_prefix()`（對 [my_module my_name] 配置塊）。該方法將接受一個 "config" 對象並必須返回一個與目標功能相關的新"printer object"。
* 在建立新"printer object"的實例時，可以使用"config"對像讀取配置檔案中相應配置塊中的資訊。此時可使用 `config.get()`，`config.getfloat()`， `config.getint()`等方法。應確保所需的參數在 "printer object" 構建階段時完成讀取。如果使用者參數沒有在該階段完成讀取，程式將認為這是配置中的錯字，並拋出異常。
* 使用 `config.get_printer()` 方法獲取主"printer"類的引用。該"printer"類儲存了所有實例化了的"printer objects"的引用。使用`printer.lookup_object()`方法獲取其他"printer objects"的引用。幾乎全部的功能（包括運動控制模組）都包裝為"printer objects"。需要注意的是，當一個新模組實例化的時候，並非所有其他的"printer objects"均已完成實例化。其中"gcode"和"pins"模組總是可用，但對於其他模組最好推遲查詢。
* 如果程式碼需要在其他"printer objects"發起事件（event）時被呼叫，可通過`printer.register_event_handler()`註冊事件處理函式。每個事件的名稱是一個字串，按照慣例，它是引發該事件的主要源模組的名稱，以及正在發生的動作的簡短名稱（例如，"klippy:connect"）。傳遞給事件處理函式的參數因處理函式而異（異常處理和執行環境也是如此）。常見的兩種起始事件為：
   * klippy:connect - 該事件在所有 "printer objects" 實例化后發起。它通常用於查詢其他"printer objects"，覈實配置，並與mcu進行初始握手。
   * klippy:ready - 該事件在所有connect處理程式成功地完成後發起。它意味著印表機轉為等待常規指令的待命狀態。不應在該回調函式中拋出異常。
* 如果使用者配置中存在錯誤，應在`load_config()`或連線事件（connect event）中拋出異常。使用 `raise config.error("my error")` 或 `raise printer.config_error("my error")` 進行告警。
* 使用"pins"模組對微控制器的引腳進行定義，例如`printer.lookup_object("pins").setup_pin("pwm", config.get("my_pin"))`。此後，執行時，可通過返回的對象對針腳進行控制。
* 如果印表機對像中定義了 `get_status()` 方法，則在模組中可以通過[宏](Command_Templates.md)或[API服務](API_Server.md)輸出[狀態資訊](Status_Reference.md)。 `get_status()` 必須返回一個Python字典對象，其鍵需要為字串，而值應為整形、浮點數、列表、字典、True、False或者None。元組（或命名元組）也可以作為值（它們在API服務中將被視為列表）。列表和字典的輸出值必須為「不可變的（immutable）」，即在函式內，如果 `get_status()` 需要輸出上述型別的實例，則需要新建或者進行深層複製，否則API服務會識別出輸出值中的內容變更。
* 如果模組需要使用系統時鐘或外部檔案描述符，可通過`printer.get_reactor()`對獲取全域性事件反應器進行訪問（event reactor）。通過該反應器類可以部署定時器，等待檔案描述符輸入，或者「掛起」上位機程式。
* 不應使用全域性變數。全部狀態量應儲存于 "printer objects"，並通過 `load_config()`進行訪問。否則，RESTART命令的行為將無法預測。同樣，任何在執行時打開的外部檔案（或套接字），應在"klippy:disconnect"的事件內註冊相應的回撥函式進行關閉。
* 應避免訪問其他"printer objects"私有對象屬性（或呼叫命名以下劃線開始的方法）。遵循這一方式可方便之後的變更。
* 推薦在類的工廠函式中將所有成員變數實例化（即避免使用Python的動態變動成員變數的功能）。
* 若一Python變數存放有一浮點數，那麼建議該變數應總賦予浮點型別的量，並僅使用浮點數常量進行值運算（並絕不使用整形常數進行運算）。例如，應使用`self.speed = 1.`而非`self.speed = 1`，並以`self.speed = 2. * x` 替代 ` self.speed = 2 *x`。一致地使用浮點值可以避免Python型別轉換中難以除錯的怪異現象。
* 若需向 klipper 母分支提交模組的程式碼，請在模組程式碼的頭部加入版權聲明。詳請參考已有模組的格式。

## 增加新運動學模型

本節將提供為Klipper增加新運動學模型的提示。這需要對目標運動學方程有深入的瞭解。這同時需要一定的軟件開發技巧——儘管人們應該只需要更新上位機軟體。

步驟：

1. 開始應研究 "[移動命令的程式碼流](#code-flow-of-a-move-command)" 章節和 [動力學文件](Kinematics.md).
1. 參考位於klippy/kinematics/目錄已有的運動學類。動力學類旨在將一個笛卡爾座標系中的運動轉化為各個步進電機的運動。建議複製已有的程式碼，並在其基礎上進行修改。
1. 若需要的運動學方程未被Klipper涵蓋，則應使用C語言實現新動力學體系中各個步進電機的位置方程（見klippy/chelper/，如kin_cart.c, kin_corexy.c, and kin_delta.c）。位置方程中應呼叫`move_get_coord()`以將運動的時間點（單位 ：秒）轉化為對應的笛卡爾座標位置（單位：毫米），進而計算目標步進電機運動目標位置（單位：毫米）。
1. 在新的運動學類中實現`calc_position`方法。該方法將通過各個步進電機的位置計算笛卡爾座標系下的列印頭位置；同時該方法通常只在回零和z探測時使用，因此無需過分追求效率。
1. 之後實現`check_move()`, `get_status()`, `get_steppers()`, `home()`, `set_position()`方法。這些函式用於特定的運動學檢查。在開發的初期，可以直接使用已有程式碼。
1. 新增測試實例。建立一個G程式碼檔案，其中包含一系列的運動命令用於測試新增的運動學模型。 按照[除錯文件](Debugging.md)將該G程式碼檔案轉換為微控制器命令。在遭遇困難狀況和檢查數據傳遞相當有用。

## 移植到新的微控制器

該節將介紹將Klipper微控制器程式碼移植到新架構時的一些提示。該操作將需要對嵌入式開發有一定的認識並應有目標微控制器的開發平臺。

步驟：

1. 首先應確定移植所需的第三方庫。常見的例子為「CMSIS」包裝器和廠商的「HAL」庫。全部第三方程式碼應遵循或相容GNU GPLv3協議。第三方程式碼應提交到Klipper的/lib資料夾。更新lib/README註明第三方庫的獲取途徑和更新時間。推薦不改變內容，直接將程式碼複製到Klipper，但如果需要進行變更，應將所做的修改列在lib/README檔案中。
1. 在src/下新建一個新架構的子目錄，並建立對應的初始Kconfig和Makefile。以已有的架構作為模版，其中src/simulator給出了微控制器架構的基本需求。
1. 首要任務是在目標印表機主板上實現通訊。這是增加支援中最難的一步，實現該功能后一切將闊然開朗。在開荒時，一般使用序列匯流排進行開發，因為通常序列匯流排已於應用和控制。在此階段，可大量使用 src/generic/ 目錄中的中的輔助程式碼（可參考 src/simulator/Makefile 中如何將上述程式碼加入構建）。同時，需要在這階段完成 timer_read_time() 的定義（用於獲取現時系統時鐘），但無需完全實現定時中斷功能。
1. 依照[除錯文件](Debugging.md)熟悉console.py工具，並使用該工具覈實微控制器的連線。該工具將底層微控制器通訊協議轉換為可讀形式。
1. 增加對硬體中斷的定時器排程的支援。參見 Klipper [commit 970831ee](https://github.com/Klipper3d/klipper/commit/970831ee0d3b91897196e92270d98b2a3067427f)，作為針對LPC176x架構的步驟1-5的例子。
1. 提供基本的 GPIO 輸入和輸出支援。參見 Klipper [commit c78b9076](https://github.com/Klipper3d/klipper/commit/c78b90767f19c9e8510c3155b89fb7ad64ca3c54) 作為一個例子。
1. 啟動其他外圍裝置-參閱Klipper提交[65613aed](https://github.com/Klipper3d/klipper/commit/65613aeddfb9ef86905cb1dade9e773a02ef3c27)，[c812a40a](https://github.com/Klipper3d/klipper/commit/c812a40a3782415e454b04bf7bd2158a6f0ec8b5)，和[c381d03a](https://github.com/Klipper3d/klipper/commit/c381d03aad5c3ee761169b7c7bced519cc14da29)的例子。
1. 在config/目錄新建一個配置事例，並使用Klipper.py的主程式進行設定。
1. 考慮在test/目錄加入構建測試的事例。

還有一些tips：

1. 避免使用「C位段」（C bitfield）訪問IO暫存器；應使用直接對32位、16位和8位的整數讀寫代替。C語言規範中沒有對位段操作進行清晰定義（例如端序、字佈局等），且在IO操作時使用C段位讀寫，將難以確定具體進行了何種IO操作。
1. IO暫存器操作時應使用顯式賦值，避免使用「讀-改-寫」。也就是說，如果在一個IO暫存器中更新一個欄位，而其他欄位的值是已知的，那麼最好是顯式地寫入暫存器的全部內容。顯式寫入產生的程式碼更小，更快，更容易除錯。

## 座標系變換

內部而言，Klipper使用笛卡爾座標系追蹤列印頭的位置，其座標系設定相對於設定檔案中的座標系而變化。因此，KIlipper的執行在絕大部分情況下都不會變換座標系。如果使用者進行原點的變換（如執行`G92`命令），Klipper會將後續命令轉化到原始座標系上進行執行。

然而，在部分情況下，需要獲取其他座標系中列印頭的位置。Klipper提供數種工具以實現上述功能。執行GET_POSITION可以獲得上述數據，如：

```
Send: GET_POSITION
Recv: // mcu: stepper_a:-2060 stepper_b:-1169 stepper_c:-1613
Recv: // stepper: stepper_a:457.254159 stepper_b:466.085669 stepper_c:465.382132
Recv: // kinematic: X:8.339144 Y:-3.131558 Z:233.347121
Recv: // toolhead: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode base: X:0.000000 Y:0.000000 Z:0.000000 E:0.000000
Recv: // gcode homing: X:0.000000 Y:0.000000 Z:0.000000
```

「微控制器位置」（`stepper.get_mcu_position()`）是微控制器最後一次重置后執行的「正向」步數總數 - 「負向」步數總數的值。如果裝置處於機械運動時，該方法將返回包含運動緩衝區中的位置值，但不包含預計佇列中的運動值。

「步進電機」部分（`stepper.get_commanded_position()`）是運動學模型中記錄的特定步進電機位置。通常是對應軌道的相對於設定中的position_endstop設定值的滑車位置（單位為毫米，但部分設定中使用的是弧度單位而非線性單位）。如果在機械運動時觸發上述程式碼，則返回的值為微控制器中快取的位置，而不包含預計佇列（look-ahead queue）中的預計位置。可使用`toolhead.flush_step_generation()`或`toolhead.wati_moves()`呼叫完全重新整理預計佇列和步進脈衝產生程式碼。

運動學位置（`kin.cal_position()`）是在笛卡爾座標上的，衍生於步進電機位置的，相對於設定檔案中position_endstop值的位置。由於步進電機的解析度原因，這可能與請求的笛卡爾座標值不一致。如果在機械運動時觸發上述程式碼，則返回的值為微控制器中快取的位置，而不包含預計佇列（look-ahead queue）中的預計位置。可使用`toolhead.flush_step_generation()`或`toolhead.wati_moves()`呼叫完全重新整理預計佇列和步進脈衝產生程式碼。

列印頭位置（`toolhead.get_position()`）是最後的運動請求對應的，相對於設定檔案限位位置的，笛卡爾座標上的列印頭位置。如果在機械運動時觸發上述程式碼，那麼返回值會依據請求運動序列中的運動終點給出（儘管buffer中的運動還沒由步進電機觸發）。

G程式碼位置時最後一次位置請求命令（`G1`或`G0`）對應的，在笛卡爾座標系中相對設定檔案中的設定原點的相對位置。這可能與「列印頭位置」不一致，這是因為G程式碼修正的影響（比如床網，床傾角修正，調平螺母修正）。這也會因為G程式碼原點變更（如`G92`，`SET_GCODE_OFFSET`，`M221`）而導致返回值跟最後一次`G1`命令請求的位置不一致。`Ｍ114`命令（`gcode_move.get_status()[』gcode_position』]`）會返回現時G程式碼相對於此時的G程式碼原點的位置。

G程式碼基準是笛卡爾座標系中相對於設定檔案中的設定原點的相對位置。諸如`G92`，`SET_GCODE_OFFSET`和`M221`會改變的返回值。

G程式碼回零點是在`G28`命令執行后G程式碼原點。同樣，該位置是笛卡爾座標系中，相對於設定檔案原點的位置。`SET_GCODE_OFFSET`命令會改變該值。

## 定時

該節將描述Klipper如何處理時鐘，定時和時間戳。Klipper通過提前安排需要執行的行為事件從而執行動作。例如，要啟動風扇，程式碼需要安排GPIO針腳在100ms后變化。程式碼立即執行動作反而是罕見的狀況。因此，Klipper的正確執行離不開對時間的精確處理。

Klipper內部使用三種不同的時間：

* 系統時間（System time）。系統時間使用系統的單調時鐘。這是一個以秒為單位儲存的浮點數，在系統啟動后開始累計。系統時鐘的用途有限，通常只會在與操作系統進行互動時使用。在上位機中，系統時間儲存在*eventtime*或*curtime*變數中。
* 列印時間（Print time）。列印時間會與主微控制器時鐘同步（在「[MCU]」設定段中定義的微控制器。）這是一個以秒為單位儲存的浮點數，並在主微控制最後一次啟動后開始從0累加。通過乘以設定的微控制器頻率，可以獲得主微控制器內部硬體時鐘值。上層應用可以通過列印時間計算幾乎所有物理行為（比如列印頭運動，加熱器變動等）。在上位機程式碼中，列印時間通常儲存在*print_time*和*move_time*變數中。
* MCU時鐘，是各個微控制內部的硬體時鐘累加器。它是基於微控制器設定頻率為速率進行累加的，以整形儲存的值。上位機軟體將軟體內部時間轉換為mcu時間並將命令傳輸到微控制器上。微控制程式碼僅在時鐘跳動時更新和追蹤時間。在上位機程式碼中，時鐘值以64位整形記錄，而微控制程式碼則使用32位整形。在上位機程式碼中，時鐘通常以*clock*或*tick*變數儲存。

不同時鐘格式的轉換主要在**klipper/clocksync.py**中實現。

在檢查程式碼時需要注意：

* 32位和64位時鐘：爲了降低頻寬消耗和提高微控制器效率，微控制器時鐘使用32位整形進行追蹤。在微控制器程式碼中對比兩個時鐘時，應保持呼叫`time_is_before`以確定整形時鐘沒有出現溢出的情況。上位機軟體通過將微控制器最後一次返回的時間戳累加到主機程式碼時鐘的高位地址中，以實現32位時鐘到64位時鐘的轉換，由於來自微控制器的資訊不可能來自2^31個時間刻度的過去或未來，因此時間轉換不會出現錯誤。主機通過簡單截斷高位中的值，實現64位到32位的轉換。爲了確保轉換沒有歧義，**klippy/chelper/serialqueque.c**程式碼會快取資訊直到程式碼目標時間的2^31個時間刻度內。
* 複數微控制器的情況：上位機軟體支援單體印表機使用複數微控制器。此時，各微控制器的「微控制器時鐘」將被分開記錄。clocksync.py處理微處理器之間的時間飄變，方法在「列印時間」和「微處理器時間」的轉換方法上修改得出。在次要微處理上，微處理器頻率被用於上述處理，並通過持續測量漂變對次要微控制器頻率進行更新。
