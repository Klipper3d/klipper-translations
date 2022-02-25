# 除錯

本文件描述了一些 Klipper 除錯工具。

## Running the regression tests

The main Klipper GitHub repository uses "github actions" to run a series of regression tests. It can be useful to run some of these tests locally.

The source code "whitespace check" can be run with:

```
./scripts/check_whitespace.sh
```

The Klippy regression test suite requires "data dictionaries" from many platforms. The easiest way to obtain them is to [download them from github](https://github.com/Klipper3d/klipper/issues/1438). Once the data dictionaries are downloaded, use the following to run the regression suite:

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

## 將G程式碼檔案轉換為微控制器命令

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

## Motion analysis and data logging

Klipper supports logging its internal motion history, which can be later analyzed. To use this feature, Klipper must be started with the [API Server](API_Server.md) enabled.

Data logging is enabled with the `data_logger.py` tool. For example:

```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog
```

This command will connect to the Klipper API Server, subscribe to status and motion information, and log the results. Two files are generated - a compressed data file and an index file (eg, `mylog.json.gz` and `mylog.index.gz`). After starting the logging, it is possible to complete prints and other actions - the logging will continue in the background. When done logging, hit `ctrl-c` to exit from the `data_logger.py` tool.

The resulting files can be read and graphed using the `motan_graph.py` tool. To generate graphs on a Raspberry Pi, a one time step is necessary to install the "matplotlib" package:

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

However, it may be more convenient to copy the data files to a desktop class machine along with the Python code in the `scripts/motan/` directory. The motion analysis scripts should run on any machine with a recent version of [Python](https://python.org) and [Matplotlib](https://matplotlib.org/) installed.

Graphs can be generated with a command like the following:

```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

One can use the `-g` option to specify the datasets to graph (it takes a Python literal containing a list of lists). For example:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

The list of available datasets can be found using the `-l` option - for example:

```
~/klipper/scripts/motan/motan_graph.py -l
```

It is also possible to specify matplotlib plot options for each dataset:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```

Many matplotlib options are available; some examples are "color", "label", "alpha", and "linestyle".

The `motan_graph.py` tool supports several other command-line options - use the `--help` option to see a list. It may also be convenient to view/modify the [motan_graph.py](../scripts/motan/motan_graph.py) script itself.

The raw data logs produced by the `data_logger.py` tool follow the format described in the [API Server](API_Server.md). It may be useful to inspect the data with a Unix command like the following: `gunzip < mylog.json.gz | tr '\03' '\n' | less`

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

The script will extract the printer config file and will extract MCU shutdown information. The information dumps from an MCU shutdown (if present) will be reordered by timestamp to assist in diagnosing cause and effect scenarios.

## 用 simulavr 測試

[simulavr](http://www.nongnu.org/simulavr/)工具使人們可以模擬Atmel ATmega微控制器。本節描述瞭如何通過simulavr執行測試gcode檔案。建議在臺式機（而不是Raspberry Pi）上執行這個工具，因為它需要大量的cpu來有效執行。

To use simulavr, download the simulavr package and compile with python support. Note that the build system may need to have some packages (such as swig) installed in order to build the python module.

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```

Make sure a file like **./build/pysimulavr/_pysimulavr.*.so** is present after the above compilation:

```
ls ./build/pysimulavr/_pysimulavr.*.so
```

This commmand should report a specific file (e.g. **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**) and not an error.

If you are on a Debian-based system (Debian, Ubuntu, etc.) you can install the following packages and generate *.deb files for system-wide installation of simulavr:

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

and compile the micro-controller software for an AVR atmega644p and select SIMULAVR software emulation support. Then one can compile Klipper (run `make`) and then start the simulation with:

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

Note that if you have installed python3-simulavr system-wide, you do not need to set `PYTHONPATH`, and can simply run the simulator as

```
./scripts/avrsim.py out/klipper.elf
```

然後，在另一個視窗中執行simulavr，可以執行以下內容，從一個檔案（例如，"test.gcode"）中讀取gcode，用Klippy處理它，並將其發送到simulavr中執行的Klipper（關於建立python虛擬環境的必要步驟，見[安裝](Installation.md)）。

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
