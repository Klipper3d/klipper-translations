# 调试

本文档描述了 Klipper 的一些调试工具。

## 运行回归测试

Klipper 主 GitHub 仓库使用 "github actions" 来运行一系列回归测试。在本地运行其中一些测试可能会很有用。

可以使用以下命令运行源代码“空白字符检查”：
```
./scripts/check_whitespace.sh
```

Klippy 回归测试套件需要来自多个平台的“数据字典”。获取它们的最简单方法是
[从 github 下载](https://github.com/Klipper3d/klipper/issues/1438)。
下载数据字典后，使用以下命令运行回归测试套件：
```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## 手动向微控制器发送命令

通常，主机 klippy.py 进程用于将 G 代码命令转换为 Klipper 微控制器命令。然而，也可以手动发送这些 MCU 命令（在 Klipper 源代码中标记为 DECL_COMMAND() 宏的函数）。为此，请运行：

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

在工具内使用 "HELP" 命令可获取有关其功能的更多信息。

提供了一些命令行选项。要了解更多信息，请运行：
`~/klippy-env/bin/python ./klippy/console.py --help`

## 将 G 代码文件转换为微控制器命令

Klippy 主机代码可以以批处理模式运行，以生成与 G 代码文件关联的底层微控制器命令。检查这些底层命令对于理解底层硬件的操作非常有用。在代码更改后比较微控制器命令的差异也很有用。

要以这种批处理模式运行 Klippy，需要一个一次性步骤来生成微控制器的“数据字典”。这通过编译微控制器代码来获得 **out/klipper.dict** 文件：

```
make menuconfig
make
```

完成上述操作后，就可以以批处理模式运行 Klippy
（有关构建 Python 虚拟环境和 printer.cfg 文件的步骤，请参阅[安装](Installation.md)）：

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

上述命令将生成一个包含二进制串行输出的文件 **test.serial**。可以使用以下命令将此输出转换为可读文本：

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

生成的文件 **test.txt** 包含微控制器命令的人类可读列表。

批处理模式会禁用某些响应/请求命令以实现其功能。因此，实际命令与上述输出之间会有一些差异。生成的数据对于测试和检查很有用；但不能用于发送到真实的微控制器。

## 运动分析和数据记录

Klipper 支持记录其内部运动历史，之后可以进行分析。要使用此功能，必须启用 [API 服务器](API_Server.md) 启动 Klipper。

数据记录通过 `data_logger.py` 工具启用。例如：
```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog
```

此命令将连接到 Klipper API 服务器，订阅状态和运动信息，并记录结果。会生成两个文件——一个压缩的数据文件和一个索引文件（例如，`mylog.json.gz` 和 `mylog.index.gz`）。启动记录后，可以完成打印和其他操作——记录将在后台继续。记录完成后，按 `ctrl-c` 退出 `data_logger.py` 工具。

可以使用 `motan_graph.py` 工具读取和绘制生成的文件。要在树莓派上生成图表，需要一次性安装 "matplotlib" 包：
```
sudo apt-get update
sudo apt-get install python-matplotlib
```
但是，将数据文件和 `scripts/motan/` 目录中的 Python 代码复制到桌面级计算机上可能更方便。只要机器上安装了较新版本的 [Python](https://python.org) 和 [Matplotlib](https://matplotlib.org/)，运动分析脚本就应该可以在任何机器上运行。

可以使用类似以下的命令生成图表：
```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

可以使用 `-g` 选项指定要绘制的数据集（它接受包含列表的 Python 字面量）。例如：
```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

可以使用 `-l` 选项查找可用数据集列表——例如：
```
~/klipper/scripts/motan/motan_graph.py -l
```

还可以为每个数据集指定 matplotlib 绘图选项：
```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```
提供了许多 matplotlib 选项；一些示例包括 "color"、"label"、"alpha" 和 "linestyle"。

`motan_graph.py` 工具支持其他几个命令行选项——使用 `--help` 选项查看列表。查看/修改 [motan_graph.py](../scripts/motan/motan_graph.py) 脚本本身也可能很方便。

`data_logger.py` 工具生成的原始数据日志遵循 [API 服务器](API_Server.md) 中描述的格式。可以使用类似以下的 Unix 命令检查数据：
`gunzip < mylog.json.gz | tr '\03' '\n' | less`

## 生成负载图表

Klippy 日志文件 (/tmp/klippy.log) 存储了有关带宽、微控制器负载和主机缓冲区负载的统计信息。在打印后绘制这些统计信息的图表可能很有用。

要生成图表，需要一次性安装 "matplotlib" 包：

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

然后可以使用以下命令生成图表：

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

然后可以查看生成的 **loadgraph.png** 文件。

可以生成不同的图表。要了解更多信息，请运行：
`~/klipper/scripts/graphstats.py --help`

## 从 klippy.log 文件中提取信息

Klippy 日志文件 (/tmp/klippy.log) 还包含调试信息。有一个 logextract.py 脚本在分析微控制器关机或类似问题时可能很有用。通常使用类似以下的命令运行：

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

该脚本将提取打印机配置文件并提取 MCU 关机信息。脚本会按时间戳重新排序 MCU 关机时的信息转储（如果存在），以帮助诊断因果场景。

## 使用 simulavr 进行测试

[simulavr](http://www.nongnu.org/simulavr/) 工具允许模拟 Atmel ATmega 微控制器。本节描述了如何通过 simulavr 运行测试 G 代码文件。建议在桌面级计算机（而不是树莓派）上运行，因为它需要大量 CPU 资源才能高效运行。

要使用 simulavr，请下载 simulavr 包并使用 Python 支持进行编译。请注意，构建系统可能需要安装一些包（例如 swig）才能构建 Python 模块。

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```
确保在上述编译后存在类似 **./build/pysimulavr/_pysimulavr.*.so** 的文件：
```
ls ./build/pysimulavr/_pysimulavr.*.so
```
此命令应报告一个特定文件（例如 **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**），而不是报错。

如果你使用的是基于 Debian 的系统（Debian、Ubuntu 等），可以安装以下包并生成用于 simulavr 系统范围安装的 *.deb 文件：
```
sudo apt update
sudo apt install g++ make cmake swig rst2pdf help2man texinfo
make cfgclean python debian
sudo dpkg -i build/debian/python3-simulavr*.deb
```

要为 simulavr 使用编译 Klipper，请运行：

```
cd /path/to/klipper
make menuconfig
```

并为 AVR atmega644p 编译微控制器软件，并选择 SIMULAVR 软件仿真支持。然后可以编译 Klipper（运行 `make`），再使用以下命令启动仿真：

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```
请注意，如果你已系统范围安装了 python3-simulavr，则无需设置 `PYTHONPATH`，可以直接运行模拟器：
```
./scripts/avrsim.py out/klipper.elf
```

然后，在另一个窗口中运行 simulavr 时，可以运行以下命令从文件（例如 "test.gcode"）读取 G 代码，使用 Klippy 处理它，并将其发送到在 simulavr 中运行的 Klipper（有关构建 Python 虚拟环境的步骤，请参阅[安装](Installation.md)）：

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### 将 simulavr 与 gtkwave 一起使用

simulavr 的一个有用功能是能够创建具有事件精确时间的信号波形生成文件。为此，请按照上述说明操作，但使用类似以下的命令行运行 avrsim.py：

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

上述命令将创建一个名为 **avrsim.vcd** 的文件，其中包含 PORTA 和 PORTC 上 GPIO 变化的信息。然后可以使用 gtkwave 查看：

```
gtkwave avrsim.vcd
```