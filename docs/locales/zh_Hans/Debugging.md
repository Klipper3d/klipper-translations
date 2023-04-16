# 调试

本文档描述了一些 Klipper 调试工具。

## 运行回归测试

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

This command should report a specific file (e.g. **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**) and not an error.

If you are on a Debian-based system (Debian, Ubuntu, etc.) you can install the following packages and generate *.deb files for system-wide installation of simulavr:

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

and compile the micro-controller software for an AVR atmega644p and select SIMULAVR software emulation support. Then one can compile Klipper (run `make`) and then start the simulation with:

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

Note that if you have installed python3-simulavr system-wide, you do not need to set `PYTHONPATH`, and can simply run the simulator as

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
