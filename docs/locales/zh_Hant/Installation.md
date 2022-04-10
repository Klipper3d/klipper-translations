# 安裝

本教程假定軟體將會在樹莓派上和 Octoprint 一起執行。推薦使用樹莓派2/3/4作為主機（關於其他裝置，請見[常見問題](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)）。

Klipper 目前支援多種基於 Atmel ATmega 微控制器、[基於 ARM 微控制器](Features.md#step-benchmarks) 和基於 [Beaglebone 可程式設計實時單元](Beaglebone.md) 的印表機。

## 準備操作系統映象

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

選擇恰當的微控制器並複查提供的其他選項。配置好后，執行：

```
make
```

必須先確定連線到微控制器的串列埠。對於通過 USB 連線的微控制器，執行以下命令：

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

Klipper 配置儲存在樹莓派上的一個文字檔案中。請檢視在[config資料夾](../config/)中的配置示例。[配置參考](Config_Reference.md)中有配置參數的文件。

可以說，更新Klipper configuration 檔案的最簡單方法是使用一個支援通過 "scp "或 "sftp "協議編輯檔案的桌面編輯器。有一些免費的工具支援這個功能（例如，Notepad++、WinSCP和Cyberduck）。使用其中一個配置檔案的例子作為起點，並將其儲存為pi使用者的主目錄中名為 "printer.cfg "的檔案（例如，/home/pi/printer.cfg）。

另外，也可以通過ssh在Raspberry Pi上直接複製和編輯該檔案。比如說：

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

確保你檢查和更新每一個設定並且與硬體相符合。

通常每臺印表機都有自己獨特的微控制器名稱。刷寫Klipper后這個名字可能會改變，所以重新執行`ls /dev/serial/by-id/*`命令，然後用這個唯一的名字更新配置檔案。例如，更新"[mcu]"部分，看起來類似於:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

在建立和編輯該檔案后，有必要在OctoPrint網路終端發出 "restart"命令去重新載入config。"status" 命令將報告印表機已準備就緒。在初始設定期間出現配置錯誤是很正常的。更新印表機配置檔案併發出 "restart"命令，直到 "狀態 "報告印表機已準備就緒。

Klipper通過OctoPrint終端標籤報告錯誤資訊。可以使用 "status "命令來重新報告錯誤資訊。預設的Klipper啟動指令碼也在**/tmp/klippy.log**中放置一個日誌，提供更詳細的資訊。

除此之外常見的g-code命令之外，Klipper還支援一些擴充套件命令"status "和 "restart "就是這些命令的例子。使用 "help "命令可以獲得其他擴充套件命令的列表。

在Klipper反饋印表機已經準備好后，進入[config check document](Config_checks.md)對配置檔案中的引腳定義進行一些基本檢查。

## 聯繫開發者

請務必檢視[FAQ](FAQ.md)，瞭解一些常見問題的答案。請參閱[聯繫頁面](Contact.md)來報告一個錯誤或聯繫開發者。
