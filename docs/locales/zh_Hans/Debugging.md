# 调试

本文档描述了一些 Klipper 调试工具。

## 运行回归测试

Klipper GitHub主存储库使用“GitHub操作”来运行一系列回归测试。在本地运行其中一些测试可能很有用。

源代码“whitespace check(空白检查)”可以使用以下代码运行：

```
./scripts/check_whitespace.sh
```

Klippy回归测试套件需要来自多个平台的“数据字典”。获取它们的最简单方法是[从github](https://github.com/Klipper3d/klipper/issues/1438).下载它们。下载数据字典后，使用以下命令运行回归套件：

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## 手动向微控制器发送命令

通常情况下，主机klippy.py进程会被用来将gcode命令翻译成Klipper微控制器命令。然而，也可以手动发送这些MCU命令（Klipper源代码中标有DECL_COMMAND()宏的函数）。要做到这一点，请运行：

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

请参阅该工具中的"HELP"命令，以获得有关其功能的更多信息。

一些命令行选项是可用的。更多信息请运行：`~/klippy-env/bin/python ./klippy/console.py --help`

## 将G代码文件转换为微控制器命令

Klippy 主机代码可以在批处理模式下运行并生成G代码文件相应的低级微控制器命令。这些低级命令可以帮助了解低级硬件的操作和在修改代码后微控制器命令的差异。

要在批处理模式下运行 Klippy，需要首先生成微控制器的"数据字典"。通过编译微控制器代码来获得**out/klipper.dict**文件：

```
make menuconfig
make
```

完成上述操作后，可以在批处理模式下运行 Klipper（请参考[安装](Installation.md)以了解构建 Python 虚拟环境(venv)和 printer.cfg 文件所需的步骤）：

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

以上命令将生成一个包含二进制串行输出的**test.serial**文件。该文件可以用以下方法翻译成可读文本：

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

生成的文件 **test.txt** 包含可读的微控制器命令列表。

为了使批处理模式正常运行，一些响应和请求命令被禁用了。因此，实际命令和上述输出之间会有一些差异。生成的数据可以用于测试和检查，但是它不能被发送到真正的微控制器。

## 运动分析和数据记录

Klipper支持记录其内部运动历史，稍后可以对其进行分析。若要使用此功能，Klipper必须在启用[API服务器](API_Server.md)的情况下启动。

使用 `data_logger.py` 工具启用数据日志记录。例如：

```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog
```

此命令将连接到Klipper API服务器，订阅状态和运动信息，并记录结果。生成两个文件-一个压缩数据文件和一个索引文件（例如`mylog.json.gz`和`mylog.index.gz`）。启动日志记录后，可以完成打印和其他操作-日志记录将在后台继续。完成日志记录后，点击 `ctrl-c`退出 `data_logger.py` 工具。

可以使用`motan_graph.py`工具读取生成的文件并绘制成图形。要在Raspberry PI上生成图形，需要一个时间步骤来安装“matplotlib”包：

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

但是，将数据文件与`scripts/motan/`目录中的Python代码一起复制到台式机上可能会更方便。运动分析脚本应在安装了最新版本的[PYTHON](https://python.org))和[Matplotlib](https://matplotlib.org/))的任何计算机上运行。

可以使用如下所示的命令生成图形：

```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

可以使用`-g`选项来指定要绘制图形的数据集(它接受一个包含列表的列表Python文字)。例如：

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

可用数据集的列表可以使用 `-l` 选项找到，例如：

```
~/klipper/scripts/motan/motan_graph.py -l
```

还可以为每个数据集指定matplotlib绘图选项：

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```

有许多matplotlib选项可用；例如“颜色”、“标签”、“阿尔法”和“线条样式”。

`motan_graph.py`工具支持其他几个命令行选项--使用`--help`选项查看列表。查看/修改[motan_graph.py](../scripts/motan/motan_graph.py)脚本本身可能也很方便。

`data_logger.py`工具产生的原始数据日志遵循[API服务器](API_Server.md)中描述的格式。使用如下所示的Unix命令检查数据可能很有用：`GunZip<mylog.json.gz|tr‘\03’\n‘|less`

## 生成负载图

Klippy日志文件（/tmp/klippy.log）存储了关于带宽、微控制器负载和主机缓冲区负载的统计数据。在打印之后，绘制这些统计数字可能会很有用。

为了生成图形，有必要安装"matplotlib"包：

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

然后可以使用以下方式生成图形：

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

然后结果可以通过**loadgraph.png**查看。

可以产生不同的图表。更多信息请运行：`~/klipper/scripts/graphstats.py --help`

## 从klippy.log文件中提取信息

Klippy的日志文件（/tmp/klippy.log）也包含调试信息。有一个logextract.py脚本，在分析微控制器停机或类似问题时可能很有用。它通常是这样运行的：

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

该脚本将提取打印机的配置文件，并提取 MCU 的关闭信息。来自 MCU 关闭的信息转储（如果存在的话）将按时间戳重新排序，以协助诊断因果关系的情况。

## 使用 simulavr 测试

[simulavr](http://www.nongnu.org/simulavr/)工具可以模拟 Atmel ATmega 微控制器。本章描述了如何通过simulavr运行测试gcode文件。由于该工具需要大量cpu资源，建议在台式机（而不是树莓派）上运行。

要使用Simavr，请下载Simavr包并在支持Python的情况下进行编译。请注意，构建系统可能需要安装一些包(如SWIG)才能构建Python模块。

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```

确保在上述编译后存在类似**./Build/pysimavr/_pysimavr.*.so**的文件：

```
ls ./build/pysimulavr/_pysimulavr.*.so
```

此命令应报告特定文件(例如**./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**)，而不是错误)。

如果您使用的是基于Debian的系统(Debian、Ubuntu等)。您可以安装以下程序包并生成*.deb文件，以便在系统范围内安装simavr：

```
sudo apt update
sudo apt install g++ make cmake swig rst2pdf help2man texinfo
make cfgclean python debian
sudo dpkg -i build/debian/python3-simulavr*.deb
```

要编译Klipper以便在simulavr中使用，请运行：

```
cd /path/to/klipper
make menuconfig
```

并针对AVR atmega644P编写了微控制器软件，并选择了SIMULAVR软件仿真支持。然后可以编译Klipper(运行`make`)，然后使用以下命令开始模拟：

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

请注意，如果您已经在系统范围内安装了python3-simavr，则不需要设置`PYTHONPATH`，只需将其作为模拟器

```
./scripts/avrsim.py out/klipper.elf
```

然后，在另一个窗口中运行simulavr，可以运行以下内容，从一个文件（例如，"test.gcode"）中读取gcode，用Klippy处理它，并将其发送到simulavr中运行的Klipper（关于建立python虚拟环境的必要步骤，见[安装](Installation.md)）：

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### 在gtkwave中使用simulavr

simulavr的一个有用的功能是它能够创建具有准确事件时间的信号波生成文件。要做到这一点，请按照上面的指示，在命令行运行avrsim.py请使用：

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

以上将创建一个文件**avrsim.vcd**，其中包括PORTA和PORTB上的GPIO的每个变化信息。然后可以用gtkwave来查看：

```
gtkwave avrsim.vcd
```
