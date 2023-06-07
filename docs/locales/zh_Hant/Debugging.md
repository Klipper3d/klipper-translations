# 除錯

本文件描述了一些 Klipper 除錯工具。

## 執行 regression 測試

主要的 Klipper GitHub 存儲庫使用"github actions"來運行一系列回歸測試。在本地運行其中一些測試可能很有用。

源代碼"whitespace check"可以運行：

```
./scripts/check_whitespace.sh
```

Klippy regression測試套件需要來自許多平台的"data dictionaries"。獲取它們的最簡單方法是[從 github 下載它們](https://github.com/Klipper3d/klipper/issues/1438)。下載"data dictionaries"後，使用以下命令運行regression套件：

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## 手動向微控制器發送命令

通常情況下，主機klippy.py程序會被用來將gcode命令翻譯成Klipper微控制器命令。然而，也可以手動發送這些MCU命令（Klipper原始碼中標有DECL_COMMAND()宏的函式）。要做到這一點，請執行：

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

請參閱該工具中的"HELP"命令，以獲得有關其功能的更多資訊。

一些命令列選項是可用的。更多資訊請執行：`~/klippy-env/bin/python ./klippy/console.py --help`

## 將G-Code檔案轉換為微控制器命令

Klippy 主機程式碼可以在批處理模式下執行並產生G程式碼檔案相應的低階微控制器命令。這些低階命令可以幫助瞭解低階硬體的操作和在修改程式碼后微控制器命令的差異。

要在批處理模式下執行 Klippy，需要首先產生微控制器的"數據字典"。通過編譯微控制器程式碼來獲得**out/klipper.dict**檔案：

```
make menuconfig
make
```

完成上述操作后，可以在批處理模式下執行 Klipper（請參閱[安裝](Installation.md)以瞭解構建 Python 虛擬環境(venv)和 printer.cfg 檔案所需的步驟）：

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

以上命令將產生一個包含二進制序列輸出的**test.serial**檔案。該檔案可以用以下方法翻譯成可讀文字：

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

產生的檔案 **test.txt** 包含可讀的微控制器命令列表。

爲了使批處理模式正常執行，一些響應和請求命令被禁用了。因此，實際命令和上述輸出之間會有一些差異。產生的數據可以用於測試和檢查，但是它不能被髮送到真正的微控制器。

## 動作分析和數據記錄

Klipper 支持記錄其內部運動歷史，以後可以對其進行分析。要使用此功能，必須在啟用 [API 服務器](API_Server.md) 的情況下啟動 Klipper。

使用 `data_logger.py` 工具啟用數據記錄。例如：

```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog
```

此命令將連接到 Klipper API 服務器，訂閱狀態和運動信息，並記錄結果。生成兩個文件 - 一個壓縮數據文件和一個索引文件（例如，`mylog.json.gz` 和 `mylog.index.gz`）。開始記錄後，可以完成打印和其他操作 - 記錄將在後台繼續。完成記錄後，點擊“ctrl-c”退出“data_logger.py”工具。

可以使用 `motan_graph.py` 工具讀取生成的文件並繪製圖形。要在 Raspberry Pi 上生成圖形，需要一步安裝“matplotlib”包：

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

但是，將數據文件與 `scripts/motan/` 目錄中的 Python 代碼一起復製到桌麵類機器可能更方便。運動分析腳本應該在任何安裝了最新版本的 [Python](https://python.org) 和 [Matplotlib](https://matplotlib.org/) 的機器上運行。

可以使用如下命令生成圖形：

```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

可以使用 `-g` 選項來指定要繪製的數據集（它需要一個包含列表列表的 Python 文字）。例如：

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

可以使用 `-l` 選項找到可用數據集的列表 - 例如：

```
~/klipper/scripts/motan/motan_graph.py -l
```

也可以為每個數據集指定 matplotlib 繪圖選項：

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```

許多 matplotlib 選項可用；一些例子是"color", "label", "alpha", and "linestyle"。

`motan_graph.py` 工具支持其他幾個命令行選項 - 使用 `--help` 選項查看列表。查看/修改 [motan_graph.py](../scripts/motan/motan_graph.py) 腳本本身也可能很方便。

`data_logger.py` 工俱生成的原始數據日誌遵循 [API 服務器](API_Server.md) 中描述的格式。使用 Unix 命令檢查數據可能很有用，如下所示：`gunzip < mylog.json.gz | tr '\03' '\n' | less`

## 產生負載圖

Klippy日誌檔案（/tmp/klippy.log）儲存了關於頻寬、微控制器負載和主機緩衝區負載的統計數據。在列印之後，繪製這些統計數字可能會很有用。

爲了產生圖形，有必要安裝"matplotlib"包：

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

然後可以使用以下方式產生圖形：

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

然後結果可以通過**loadgraph.png**檢視。

可以產生不同的圖表。更多資訊請執行：`~/klipper/scripts/graphstats.py --help`

## 從klippy.log檔案中提取資訊

Klippy的日誌檔案（/tmp/klippy.log）也包含除錯資訊。有一個logextract.py指令碼，在分析微控制器停機或類似問題時可能很有用。它通常是這樣執行的：

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

該腳本將提取打印機配置文件並將提取 MCU 關機信息。來自 MCU 關閉（如果存在）的信息轉儲將按時間戳重新排序，以幫助診斷因果場景。

## 用 simulavr 測試

[simulavr](http://www.nongnu.org/simulavr/)工具使人們可以模擬Atmel ATmega微控制器。本節描述瞭如何通過simulavr執行測試gcode檔案。建議在臺式機（而不是Raspberry Pi）上執行這個工具，因為它需要大量的cpu來有效執行。

要使用 simulavr，請下載 simulavr 包並使用 python 支持進行編譯。請注意，構建系統可能需要安裝一些包（例如 swig）才能構建 python 模塊。

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```

確保在上述編譯後存在 **./build/pysimulavr/_pysimulavr.*.so** 之類的文件：

```
ls ./build/pysimulavr/_pysimulavr.*.so
```

此命令應報告特定文件（例如 **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**）而不是錯誤。

如果您在基於 Debian 的系統（Debian、Ubuntu 等）上，您可以安裝以下軟件包並生成 *.deb 文件以在系統範圍內安裝 simulavr：

```
sudo apt update
sudo apt install g++ make cmake swig rst2pdf help2man texinfo
make cfgclean python debian
sudo dpkg -i build/debian/python3-simulavr*.deb
```

要編譯Klipper以便在simulavr中使用，請執行：

```
cd /path/to/klipper
make menuconfig
```

並為 AVR atmega644p 編譯微控制器軟件並選擇 SIMULAVR 軟件仿真支持。然後可以編譯 Klipper（運行 `make`）然後開始模擬：

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

注意，如果你已經安裝了python3-simulavr system-wide，你不需要設置`PYTHONPATH`，並且可以簡單地運行模擬器

```
./scripts/avrsim.py out/klipper.elf
```

然後，在另一個視窗中執行simulavr，可以執行以下內容，從一個檔案（例如，"test.gcode"）中讀取gcode，用Klippy處理它，並將其發送到simulavr中執行的Klipper（關於建立python虛擬環境的必要步驟，見[安裝](Installation.md)）:

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### 在gtkwave中使用simulavr

simulavr的一個有用的功能是它能夠建立具有準確事件時間的訊號波產生檔案。要做到這一點，請按照上面的指示，在命令列執行avrsim.py請使用：

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

以上將建立一個檔案**avrsim.vcd**，其中包括PORTA和PORTB上的GPIO的每個變化資訊。然後可以用gtkwave來檢視：

```
gtkwave avrsim.vcd
```
