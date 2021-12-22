# Debugging

Este documento describe algunas de las herramientas de depuración de Klipper.

## Ejecutar las pruebas antirregresiones

El repositorio principal de Klipper en GitHub utiliza «acciones de GitHub» para ejecutar una serie de pruebas antirregresiones. Puede ser provechoso ejecutar algunas de estas pruebas de manera local.

La «comprobación de espacios en blanco» del código fuente puede ejecutarse de esta manera:

```
./scripts/check_whitespace.sh
```

The Klippy regression test suite requires "data dictionaries" from many platforms. The easiest way to obtain them is to [download them from github](https://github.com/Klipper3d/klipper/issues/1438). Once the data dictionaries are downloaded, use the following to run the regression suite:

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## Enviar órdenes al microcontrolador manualmente

Normally, the host klippy.py process would be used to translate gcode commands to Klipper micro-controller commands. However, it's also possible to manually send these MCU commands (functions marked with the DECL_COMMAND() macro in the Klipper source code). To do so, run:

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

Vea la orden «HELP» de la herramienta para obtener información sobre sus funcionalidades.

Tiene a su disposición algunas opciones de línea de órdenes. Para obtener más información al respecto, ejecute: `~/klippy-env/bin/python ./klippy/console.py --help`

## Convertir archivos gcode en órdenes de microcontrolador

El código anfitrión de Klippy puede ejecutarse en modo por lotes para producir las órdenes de microcontrolador de bajo nivel asociadas con un archivo gcode. Resulta útil inspeccionar estas órdenes de bajo nivel para entender las acciones del hárdwer de bajo nivel. También puede ser provechoso para comparar la diferencia en las órdenes de microcontrolador tras efectuar una modificación en el código.

Para ejecutar Klippy en esta modalidad por lotes, existe un paso que debe llevarse a cabo una vez para generar el «diccionario de datos» del microcontrolador. Este consiste en compilar el código del microcontrolador para obtener el archivo **out/klipper.dict**:

```
make menuconfig
make
```

Una vez se haya llevado a cabo lo anterior, será posible ejecutar Klipper en modo por lotes (en [Instalación](Installation.md) encontrará los pasos necesarios para compilar el entorno virtual de Python y un archivo printer.cfg):

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

Lo anterior producirá un archivo, **test.serial**, con la salida en serie binaria. Esta salida puede transformarse en texto legible mediante:

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

El archivo resultante, **test.txt**, contiene una lista legible por humanos de órdenes del microcontrolador.

El modo por lotes desactiva determinadas órdenes de respuesta/petición para poder funcionar. Por consiguiente, habrá algunas diferencias entre las órdenes reales y la salida anterior. Los datos generados son útiles para efectuar pruebas e inspecciones; no lo son para su envío a un microcontrolador real.

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

## Generar gráficos de carga

El archivo de registro de Klippy (/tmp/klippy.log) almacena estadísticas sobre anchura de banda, carga sobre el microcontrolador y carga sobre el búfer del anfitrión. Puede resultar útil graficar estas estadísticas luego de mostrarlas.

Para generar un gráfico, hace falta efectuar una vez este paso para instalar el paquete «matplotlib»:

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Ahora, será posible generar gráficos con:

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

Tras lo anterior, será posible visualizar el archivo resultante, **loadgraph.png**.

Es posible producir diferentes gráficos. Para más información, ejecute: `~/klipper/scripts/graphstats.py --help`

## Extraer información desde el archivo klippy.log

El archivo de registro de Klippy (/tmp/klippy.log) contiene además información para la depuración. Hay una secuencia de órdenes, logextract.py, que puede resultar útil al momento de analizar problemas de apagado del microcontrolador o similares. Normalmente se ejecuta con algo como:

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

La secuencia de órdenes extraerá el archivo de configuración de la impresora y los datos de apagado de MCU. Los volcados de información de un apagado de MCU (si existen) se reordenarán por fecha y hora para ayudar a diagnosticar escenarios de causa y efecto.

## Puesta a prueba con simulavr

La herramienta [simulavr](http://www.nongnu.org/simulavr/) le permite simular un microcontrolador ATmega de Atmel. Esta sección describe el procedimiento para ejecutar archivos gcode de prueba a través de simulavr. Es recomendable ejecutar esto en un PC de escritorio de categoría (no un Raspberry Pi), puesto que necesitará cuantiosos recursos de CPU para funcionar eficientemente.

Para utilizar simulavr, descargue el paquete de simulavr y compílelo con compatibilidad con Python:

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
./bootstrap
./configure --enable-python
make
```

Observe que el sistema de generación podría necesitar que algunos paquetes (como swig) estén instalados para generar el módulo de Python. Asegúrese de que el archivo **src/python/_pysimulavr.so** exista luego de efectuar la compilación anterior.

Para compilar Klipper para su uso en simulavr, ejecute:

```
cd /path/to/klipper
make menuconfig
```

and compile the micro-controller software for an AVR atmega644p and select SIMULAVR software emulation support. Then one can compile Klipper (run `make`) and then start the simulation with:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf
```

Acto seguido, teniendo simulavr en ejecución en otra ventana, es posible ejecutar lo siguiente para leer gcode a partir de un archivo (p. ej., «test.gcode»), procesarlo con Klippy y enviarlo al Klipper que se ejecuta dentro de simulavr (vea [Instalación](Installation.md) para obtener los pasos necesarios para generar el entorno virtual de Python):

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### Utilizar simulavr con gtkwave

Una prestación útil de simulavr es su capacidad de crear archivos de generación de ondas de señal con la cadencia exacta de los sucesos. Para hacerlo, siga las instrucciones anteriores, pero ejecute avrsim.py con una línea de órdenes como esta:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

The above would create a file **avrsim.vcd** with information on each change to the GPIOs on PORTA and PORTB. This could then be viewed using gtkwave with:

```
gtkwave avrsim.vcd
```
