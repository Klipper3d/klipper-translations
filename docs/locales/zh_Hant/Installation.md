# 安裝

本教程假定軟體將會在樹莓派上和 Octoprint 一起執行。推薦使用樹莓派2/3/4作為主機（關於其他裝置，請見[常見問題](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)）。

## 獲取 Klipper 配置文件

大多數 Klipper 設置由將存儲在 Raspberry Pi 上的“打印機配置文件”確定。通常可以通過在 Klipper [config directory](../config/) 中查找以與目標打印機對應的“printer-”前綴開頭的文件來找到適當的配置文件。 Klipper 配置文件包含安裝期間需要的有關打印機的技術信息。

如果 Klipper 配置目錄中沒有合適的打印機配置文件，請嘗試搜索打印機製造商的網站，看看他們是否有合適的 Klipper 配置文件。

如果找不到打印機的配置文件，但打印機控制板的類型已知，則查找以“generic-”前綴開頭的合適的 [config file](../config/)。這些示例打印機板文件應該允許您成功完成初始安裝，但需要進行一些自定義才能獲得完整的打印機功能。

也可以從頭開始定義新的打印機配置。但是，這需要有關打印機及其電子設備的大量技術知識。建議大多數用戶從適當的配置文件開始。如果創建新的自定義打印機配置文件，請從最接近的示例 [config file](../config/) 開始，並使用 Klipper [config reference](Config_Reference.md) 獲取更多信息。

## 準備作業系統映象

先在樹莓派上安裝 [OctoPi](https://github.com/guysoft/OctoPi)。請使用OctoPi v0.17.0或更高版本，檢視 [Octopi 發行版](https://github.com/guysoft/OctoPi/releases)來獲取最新發布版本。安裝完系統后，請先驗證 OctoPi 能正常啟動，並且 OctoPrint 網路伺服器正常執行。連線到 OctoPrint 網頁后，按照提示將 OctoPrint 更新到v1.4.2或更高版本。

在安裝 OctoPi 和升級 OctoPrint后，用 ssh 進入目標裝置，以執行少量的系統命令。如果使用Linux或MacOS系統，那麼 "ssh"軟體應該已經預裝在系統上。有一些免費的ssh客戶端可用於其他操作系統（例如，[PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)）。使用ssh工具連線到Raspberry Pi（ssh pi@octopi --密碼是 "raspberry"），並執行以下命令：

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

以上將會下載 Klipper 、安裝一些系統依賴、設定 Klipper 在系統啟動時執行並啟動Klipper 主機程式。這將需要網際網路連線以及可能需要幾分鐘時間才能完成。

## 構建和刷寫微控制器

在編譯微控制器程式碼之前，首先在樹莓派上執行這些命令：

```
cd ~/klipper/
make menuconfig
```

[打印機配置文件](#obtain-a-klipper-configuration-file) 頂部的註釋應描述“make menuconfig”期間需要設置的設置。在網絡瀏覽器或文本編輯器中打開文件，然後在文件頂部附近查找這些說明。一旦配置了適當的“menuconfig”設置，按“Q”退出，然後按“Y”保存。然後運行：

```
make
```

如果 [打印機配置文件](#obtain-a-klipper-configuration-file) 頂部的註釋描述了將最終圖像“閃爍”到打印機控制板的自定義步驟，則按照這些步驟操作，然後繼續 [配置OctoPrint](#configuring-octoprint-to-use-klipper)。

否則，通常使用以下步驟來“刷新”打印機控制板。首先，需要確定連接到微控制器的串口。運行以下命令：

```
ls /dev/serial/by-id/*
```

它應該報告類似以下的內容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

通常每一個印表機都有自己獨特的串列埠名，這個獨特串列埠名將會在刷寫微處理器時用到。在上述輸出中可能有多行。如果是這樣的話選擇與微控制器相應的 (檢視[FAQ](FAQ.md#wheres-my-serial-port)瞭解更多資訊).

對於常見的微控制器，可以用類似以下的方法來刷寫韌體：

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

請務必用印表機的唯一串列埠名稱來更新 FLASH_DEVICE 參數。

第一次刷寫時要確保 OctoPrint 沒有直接連線到印表機（在 OctoPrint 網頁的 "連線 "分段中點選 "斷開連線"）。

## 為Klipper配置 OctoPrint

OctoPrint網路伺服器需要進行配置，以便與Klipper host 軟體進行通訊。使用網路瀏覽器，登錄到OctoPrint網頁，然後配置以下專案：

導航到 "設定 "（頁面頂部的扳手圖示）。在 "序列連線 "下的 "附加串列埠 "中新增"/tmp/printer"。然後點選 "儲存"。

再次進入 "設定"，在 "序列連線" 下將 "串列埠" 設定改為"/tmp/printer"。

在 "設定 "中，瀏覽到 "Behavior "子選項卡，選擇 "取消任何正在進行的列印，但保持與印表機的連線 "選項。點選 "儲存"。

在主頁上，在 "連線 "部分（在頁面的左上方），確保 "串列埠 "被設定為"/tmp/printer"，然後點選 "連線"。(如果"/tmp/printer "不是一個可用的選擇，那麼試著重新載入頁面)

連線后，導航到 "終端 "選項卡，在命令輸入框中輸入 "status"（不帶引號），然後點選 "發送"。終端視窗可能會報告在打開配置檔案時出現了錯誤--這意味著 OctoPrint 與 Klipper 成功地進行了通訊。繼續下一部分。

## 配置 Klipper

下一步是將[打印機配置文件](#obtain-a-klipper-configuration-file)複製到樹莓派。

可以說設置 Klipper 配置文件的最簡單方法是使用支持通過“scp”和/或“sftp”協議編輯文件的桌面編輯器。有支持此功能的免費工具（例如，Notepad++、WinSCP 和 Cyberduck）。在編輯器中加載打印機配置文件，然後將其保存為 pi 用戶主目錄中名為“printer.cfg”的文件（即 /home/pi/printer.cfg）。

或者，也可以通過 ssh 直接在 Raspberry Pi 上複製和編輯文件。這可能類似於以下內容（確保更新命令以使用適當的打印機配置文件名）：

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

每台打印機都有自己獨特的微控制器名稱是很常見的。刷新 Klipper 後名稱可能會更改，因此即使在刷新時已經完成這些步驟，也要重新運行這些步驟。執行：

```
ls /dev/serial/by-id/*
```

它應該報告類似以下的內容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

然後使用唯一名稱更新配置文件。例如，更新 `[mcu]` 部分，使其看起來類似於：

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

建立和編輯文件後，需要在 OctoPrint Web 終端中發出“重新啟動”命令以加載配置。如果成功讀取 Klipper 配置文件並且成功找到並配置了微控制器，則“狀態”命令將報告打印機已準備就緒。

在自定義打印機配置文件時，Klipper 報告配置錯誤的情況並不少見。如果發生錯誤，請對打印機配置文件進行任何必要的更正並發出“restart”，直到“status”報告打印機已準備好。

Klipper通過OctoPrint終端標籤報告錯誤資訊。可以使用 "status "命令來重新報告錯誤資訊。預設的Klipper啟動指令碼也在**/tmp/klippy.log**中放置一個日誌，提供更詳細的資訊。

在 Klipper 報告打印機準備就緒後，進入 [配置檢查文檔](Config_checks.md) 對配置文件中的定義進行一些基本檢查。有關其他信息，請參閱主要 [文檔參考](Overview.md)。
