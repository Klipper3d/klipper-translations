# Debugging

本文档描述了一些 Klipper 调试工具。

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

## Manually sending commands to the micro-controller

Normally, the host klippy.py process would be used to translate gcode commands to Klipper micro-controller commands. However, it's also possible to manually send these MCU commands (functions marked with the DECL_COMMAND() macro in the Klipper source code). To do so, run:

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

See the "HELP" command within the tool for more information on its functionality.

Some command-line options are available. For more information run: `~/klippy-env/bin/python ./klippy/console.py --help`

## 将G代码文件转换为微控制器命令

Klippy 主机代码可以在批处理模式下运行并生成G代码文件相应的低级微控制器命令。这些低级命令可以帮助了解低级硬件的操作和在修改代码后微控制器命令的差异。

要在批处理模式下运行 Klippy，需要首先生成微控制器的"数据字典"。通过编译微控制器代码来获得**out/klipper.dict**文件：

```
make menuconfig
make
```

完成上述操作后，可以在批处理模式下运行 Klipper（请参阅[安装](Installation.md)以了解构建 Python 虚拟环境(venv)和 printer.cfg 文件所需的步骤）：

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

## Generating load graphs

The Klippy log file (/tmp/klippy.log) stores statistics on bandwidth, micro-controller load, and host buffer load. It can be useful to graph these statistics after a print.

To generate a graph, a one time step is necessary to install the "matplotlib" package:

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Then graphs can be produced with:

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

One can then view the resulting **loadgraph.png** file.

Different graphs can be produced. For more information run: `~/klipper/scripts/graphstats.py --help`

## Extracting information from the klippy.log file

The Klippy log file (/tmp/klippy.log) also contains debugging information. There is a logextract.py script that may be useful when analyzing a micro-controller shutdown or similar problem. It is typically run with something like:

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

The script will extract the printer config file and will extract MCU shutdown information. The information dumps from an MCU shutdown (if present) will be reordered by timestamp to assist in diagnosing cause and effect scenarios.

## 用 simulavr 测试

The [simulavr](http://www.nongnu.org/simulavr/) tool enables one to simulate an Atmel ATmega micro-controller. This section describes how one can run test gcode files through simulavr. It is recommended to run this on a desktop class machine (not a Raspberry Pi) as it does require significant cpu to run efficiently.

To use simulavr, download the simulavr package and compile with python support:

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
./bootstrap
./configure --enable-python
make
```

Note that the build system may need to have some packages (such as swig) installed in order to build the python module. Make sure the file **src/python/_pysimulavr.so** is present after the above compilation.

To compile Klipper for use in simulavr, run:

```
cd /path/to/klipper
make menuconfig
```

and compile the micro-controller software for an AVR atmega644p and select SIMULAVR software emulation support. Then one can compile Klipper (run `make`) and then start the simulation with:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf
```

Then, with simulavr running in another window, one can run the following to read gcode from a file (eg, "test.gcode"), process it with Klippy, and send it to Klipper running in simulavr (see [installation](Installation.md) for the steps necessary to build the python virtual environment):

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### Using simulavr with gtkwave

One useful feature of simulavr is its ability to create signal wave generation files with the exact timing of events. To do this, follow the directions above, but run avrsim.py with a command-line like the following:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

The above would create a file **avrsim.vcd** with information on each change to the GPIOs on PORTA and PORTB. This could then be viewed using gtkwave with:

```
gtkwave avrsim.vcd
```
