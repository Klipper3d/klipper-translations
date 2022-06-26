# 安裝

本教程假定軟體將會在樹莓派上和 Octoprint 一起執行。推薦使用樹莓派2/3/4作為主機（關於其他裝置，請見[常見問題](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3)）。

## Obtain a Klipper Configuration File

Most Klipper settings are determined by a "printer configuration file" that will be stored on the Raspberry Pi. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

If there isn't an appropriate printer configuration file in the Klipper config directory then try searching the printer manufacturer's website to see if they have an appropriate Klipper configuration file.

If no configuration file for the printer can be found, but the type of printer control board is known, then look for an appropriate [config file](../config/) starting with a "generic-" prefix. These example printer board files should allow one to successfully complete the initial installation, but will require some customization to obtain full printer functionality.

It is also possible to define a new printer configuration from scratch. However, this requires significant technical knowledge about the printer and its electronics. It is recommended that most users start with an appropriate configuration file. If creating a new custom printer configuration file, then start with the closest example [config file](../config/) and use the Klipper [config reference](Config_Reference.md) for further information.

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

The comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) should describe the settings that need to be set during "make menuconfig". Open the file in a web browser or text editor and look for these instructions near the top of the file. Once the appropriate "menuconfig" settings have been configured, press "Q" to exit, and then "Y" to save. Then run:

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Otherwise, the following steps are often used to "flash" the printer control board. First, it is necessary to determine the serial port connected to the micro-controller. Run the following:

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

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the Raspberry Pi.

Arguably the easiest way to set the Klipper configuration file is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the Raspberry Pi via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

It's common for each printer to have its own unique name for the micro-controller. The name may change after flashing Klipper, so rerun these steps again even if they were already done when flashing. Run:

```
ls /dev/serial/by-id/*
```

它應該報告類似以下的內容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Then update the config file with the unique name. For example, update the `[mcu]` section to look something similar to:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the OctoPrint web terminal to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

When customizing the printer config file, it is not uncommon for Klipper to report a configuration error. If an error occurs, make any necessary corrections to the printer config file and issue "restart" until "status" reports the printer is ready.

Klipper通過OctoPrint終端標籤報告錯誤資訊。可以使用 "status "命令來重新報告錯誤資訊。預設的Klipper啟動指令碼也在**/tmp/klippy.log**中放置一個日誌，提供更詳細的資訊。

After Klipper reports that the printer is ready, proceed to the [config check document](Config_checks.md) to perform some basic checks on the definitions in the config file. See the main [documentation reference](Overview.md) for other information.
