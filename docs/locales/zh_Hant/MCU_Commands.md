# MCU命令

該文件介紹了Klipper上位機軟體發送到微控制器的，並由微處理器負責執行的底層命令。該文件不是這些命令的權威文件，也並未包含所有命令。

若想深入瞭解底層微處理器命令，該文件是不錯的入門材料。

關於命令的格式和傳輸的更多資訊，見[protocol](Protocol.md)檔案。這裡的命令是使用其 "printf "風格的語法描述的--對於那些不熟悉這種格式的人來說，只需注意在看到'%...'序列時，應該用一個實際的整數來代替。例如，"count=%c "的描述可以被替換為 "count=10"。請注意，那些被認為是 "enumerations "的參數（見上述協議檔案）採取的是一個字串值，對於微控制器來說，它被自動轉換為一個整數值。這在名為 "pin"（或後綴為"_pin"）的參數中很常見。

## 啟動命令

可能需要採取某些一次性的命令來配置微控制器及其片上外備。本節列出了可用於該目的的常用命令。與大多數微控制器的命令不同，這些命令在收到后立即執行，它們不需要任何特殊的設定。

常見的啟動命令：

* `set_digital_out pin=%u value=%c`：該命令立即將指定的引腳配置為數字輸出GPIO，並將其設定為低電平（value=0）或高電平（value=1）。這條命令對於配置LED的初始值和配置步進驅動器微步進引腳的初始值很有用。
* `set_pwm_out pin=%u cycle_ticks=%u value=%hu`：該命令將立即配置指定的引腳，使其使用硬體的脈寬調製（PWM）和給定的cycle_ticks。「cycle_ticks」是指每個通電和斷電週期應該持續的MCU時鐘數。cycle_ticks的值為1表示使用最短的週期時間。「value」參數在0-255之間，0表示完全關閉狀態，255表示完全開啟狀態。該命令對啟用CPU和噴嘴冷卻風扇很有用。

## 底層微控制器配置

微控制器中的大多數命令在成功呼叫之前需要進行初始設定。本節提供了一個配置過程的概述。本節和下面的章節適用於對Klipper的內部細節感興趣的開發者。

當主機第一次連線到微控制器時，它總是從獲得一個數據字典開始（更多資訊見[protocol](Protocol.md)）。獲得數據字典后，主機將檢查微控制器是否處於 "已配置 "狀態，如果不是，就進行配置。配置包括以下幾個階段：

* `get_config`：主機首先檢查微控制器是否已經被配置。微控制器用一個 "config "的響應資訊來回應這個命令。微控制器軟體在上電時總是以未配置的狀態啟動。在主機完成配置過程之前（通過發出finalize_config命令），它一直處於這種狀態。如果微控制器已經在前一個會話中進行了配置（並且配置了所需的設定），那麼主機就不需要進一步的操作，配置過程成功結束。
* `allocate_oids count=%c`：這條命令是用來通知微控制器主機所需的對象標識（oid）的最大數量。這條命令只有效一次。oid是分配給每個步進電機、每個限位開關和每個可排程的gpio引腳的一個整數標識。主機事先確定操作硬體所需的oid數量，並將其傳遞給微控制器，以便它可以分配足夠的記憶體來儲存從oid到內部對象的對映。
* `config_XXX oid=%c ...`：按照慣例，任何以 "config_"開頭的命令都會建立一個新的微控制器對象，並將給定的oid賦予它。例如，config_digital_out命令將把指定的引腳配置為數字輸出GPIO，並建立一個內部對象，主機可以用它來安排改變指定的GPIO的輸出。傳入config命令的oid參數由主機選擇，必須介於0和allocate_oids命令中提供的最大計數之間。config命令只能在微控制器不處於已配置狀態時（即在主機發送finalize_config之前）和allocate_oids命令被髮送之後執行。
* `finalize_config crc=%u`：finalize_config命令將微控制器從未配置狀態轉換為已配置狀態。傳遞給微控制器的crc參數被儲存起來，並在 "config "響應資訊中反饋給主機。按照慣例，主機對它所要求的配置採取32位的CRC，並在隨後的通訊會話開始時，檢查儲存在微控制器中的CRC是否與它所希望的CRC正確匹配。如果CRC不匹配，那麼主機就知道微控制器還沒有被配置到主機所希望的狀態。

### 常見的微控制器對像

本節列出了一些常用的配置命令。

* `config_digital_out oid=%c pin=%u value=%c default_value=%c max_duration=%u`：該命令為給定的GPIO'pin'建立一個內部微控制器對象。該引腳將被配置為數字輸出模式，並被設定為'value'指定的初始值（0為低，1為高）。建立一個digital_out對像允許主機在指定的時間內對指定引腳重新整理GPIO輸出狀態（見下面描述的queue_digital_out命令）。如果微控制器軟體進入關機模式，那麼所有配置的digital_out對像將被設定為'default_value'。max_duration "參數用於實現安全檢查--如果它是非零，那麼它代表主機可以將指定的GPIO設為非預設值而不需要重新整理的最大時鐘數。例如，如果default_value是0，max_duration是16000，那麼如果主機將gpio設定為1，它必須在16000個時鐘刻度內重新整理gpio引腳的輸出（為0或1）。這個安全功能可用於加熱器引腳，以確保主機不會啟用加熱器后離線。
* `config_pwm_out oid=%c pin=%u cycle_ticks=%u value=%hu default_value=%hu max_duration=%u`：該命令為基於硬體的PWM引腳建立一個內部對象，主機可以定期重新整理。它的用法與config_digital_out類似--參數說明見'set_pwm_out'和'config_digital_out'命令的描述。
* `config_analog_in oid=%c pin=%u`：該命令用於將一個引腳配置為模擬輸入採樣模式。一旦配置完成，就可以使用query_analog_in命令（見下文）以固定的時間間隔對該引腳進行採樣。
* `config_stepper oid=%c step_pin=%c dir_pin=%c invert_step=%c step_pulse_ticks=%u`：該命令建立一個內部步進器對象。'step_pin'和'dir_pin'參數分別指定步進和方向引腳；該命令將把它們配置為數字輸出模式。'invert_step'參數指定步進是發生在上升沿（invert_step=0）還是下降沿（invert_step=1）。'step_pulse_ticks'參數指定了步進脈衝的最小持續時間。如果MCU輸出常數 "STEPPER_BOTH_EDGE=1"，那麼設定step_pulse_ticks=0和invert_step=-1將設定在步進引腳的上升沿和下降沿都進行步進輸出。
* `config_endstop oid=%c pin=%c pull_up=%c stepper_count=%c` : 該命令建立一個內部的 "endstop"對象。它用於指定限位開關的引腳，並啟用 "homing "操作（見下面的endstop_home命令）。該命令將把指定的引腳配置為數字輸入模式。『pull_up』參數決定是否啟用硬體為引腳提供的上拉電阻（如果有的話）。『stepper_count』參數規定了在歸零操作中，該限位開關觸發器可能需要的最大步進數（見下文endstop_home）。
* `config_spi oid=%c bus=%u pin=%u mode=%u rate=%u shutdown_msg=%*s`：該命令建立了一個內部SPI對象。它與spi_transfer和spi_send命令一起使用（見下文）。"bus"標識了要使用的SPI匯流排（如果微控制器有一個以上的SPI匯流排可用）。"pin"指定了裝置的片選（CS）引腳。"mode"指定SPI模式（應該在0到3之間）。"rate "參數指定了SPI匯流排的速率（以每秒週期為單位）。最後，"shutdown_msg "是在微控制器進入關機狀態時向給定裝置發送的SPI命令。
* `config_spi_without_cs oid=%c bus=%u mode=%u rate=%u shutdown_msg=%*s` : 這個命令類似於config_spi，但是沒有CS引腳的定義。它對沒有晶片選擇線的SPI裝置很有用。

## 常用命令

本節列出了一些常用的執行時命令。對希望深入瞭解Klipper的開發者可能會感興趣。

* `set_digital_out_pwm_cycle oid=%c cycle_ticks=%u`：該命令將數字輸出引腳（由config_digital_out建立）配置為使用 "軟體PWM"。'cycle_ticks' 是PWM週期的時鐘數。因為輸出切換是在微控制器軟體中實現的，建議把'cycle_ticks'對應的時間設為10ms或更大。
* `queue_digital_out oid=%c clock=%u on_ticks=%u` : 這個命令將安排在設定的時鐘時間內改變數字輸出GPIO引腳。要使用這條命令，必須在微控制器配置過程中發出具有相同『oid』參數的'config_digital_out'命令。如果'set_digital_out_pwm_cycle'已經被呼叫，那麼'on_ticks'就是pwm週期的開啟時間（以時鐘數為單位）。否則，'on_ticks'應該是0（低電壓）或1（高電壓）。
* `queue_pwm_out oid=%c clock=%u value=%hu` ：安排改變一個硬體PWM輸出引腳。更多資訊請參考 'queue_digital_out' 和 'config_pwm_out' 命令。
* `query_analog_in oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u min_value=%hu max_value=%hu`：此命令設定了一個對模擬輸入的循環採樣。要使用這條命令，必須在微控制器配置時發出具有相同'oid'參數的 'config_analog_in '命令。採樣將從'clock'時間開始，它將每隔'rest_ticks'時鐘數報告獲得的值，'sample_count'是過量採樣次數，'sample_ticks'是在過量採樣之間暫停的時鐘數。"min_value "和 "max_value "參數實現了安全功能--微控制器軟體將驗證採樣值（在每次過採樣之後）總是在安全範圍內。這是為連線到控制加熱器的熱敏電阻的引腳而設計的--它可以用來檢查加熱器是否在一個溫度範圍內。
* `get_clock`：該命令使微控制器產生一個 "clock"響應訊息。主機每秒發送一次這個命令，以獲得微控制器的時鐘值，並估計主機和微控制器時鐘之間的漂移。它使主機能夠準確估計微控制器的時鐘。

### 步進器命令

* `queue_step oid=%c interval=%u count=%hu add=%hi`：該命令安排指定的步進電機輸出'count'個步數，'interval'是每步之間的時鐘數間隔。命令中的第一步與上一個步進輸出命令最後一步的時間間隔為'interval'個時鐘數。如果'add'不為零，那麼每步之後的間隔將以'add'的增量調整。該命令將給定的間隔/計數/增量序列附加到每個步進佇列中。在正常操作中，可能有數百個這樣的序列排隊。新的序列被新增到佇列的末尾，當每個序列完成了它的 'count'步數后它就從佇列的前面彈出去。這個系統允許微控制器將幾十萬步排入佇列--所有這些都有可靠且可預測的排程時序。
* `set_next_step_dir oid=%c dir=%c`：該命令指定了下一個queue_step命令將使用的dir_pin的值。
* `reset_step_clock oid=%c clock=%u`：通常情況下步進時序是相對於給定步進的上一步。這條命令重置了時鐘，使下一步是相對於提供的 'clock' 時間。通常主機只在列印開始時發送此命令。
* `stepper_get_position oid=%c`：該命令使微控制器產生一個 "stepper_position "響應訊息，其中包含步進器的當前位置。該位置是dir=1時產生的總步數減去dir=0時的總步數。
* `endstop_home oid=%c clock=%u sample_ticks=%u sample_count=%c rest_ticks=%u pin_value=%c`：該命令用於步進電機 "homing"操作。要使用這條命令，必須在微控制器配置過程中發出具有相同 'oid '參數的 'config_endstop '命令。當這個命令被呼叫時，微控制器將在每一個'rest_ticks'時鐘刻度上對限位開關引腳進行採樣，並檢查它的值是否等於'pin_value'。如果開關被觸發（並且以間隔'sample_ticks'為週期，額外持續'sample_count'次被觸發），那麼相關步進的運動佇列將被清除，步進將立即停止。主機使用該命令實現歸位–主機指示限位開關對限位開關的觸發進行採樣，然後發出一系列queue_step命令，使步進向限位移動。一旦步進電機撞到限位開關，檢測到觸發，運動就會停止並通知主機。

### 運動佇列

每個queue_step命令都利用了微控制器 "move queue "中的一個條目。這個佇列是在它收到 "finalize_config "命令時分配的，它在 "config "響應資訊中報告可用佇列條目的數量。

在發送queue_step命令之前，主機有責任確保佇列中有可用空間。這需要主機通過計算每個queue_step命令完成的時間並相應地安排新的queue_step命令來實現。

### SPI 命令

* `spi_transfer oid=%c data=%*s`：這條命令使微控制器向 'oid '指定的spi裝置發送 'data' ，並產生一個 "spi_transfer_response "的響應訊息，其中包括傳輸期間返回的數據。
* `spi_send oid=%c data=%*s`：這個命令與 "spi_transfer "類似，但它不產生 "spi_transfer_response "訊息。
