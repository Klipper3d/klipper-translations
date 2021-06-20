Este documento describe algunas de las herramientas de depuración de Klipper.

# Convertir archivos gcode en órdenes de microcontrolador

El código anfitrión de Klippy puede ejecutarse en modo por lotes para producir
las órdenes de microcontrolador de bajo nivel asociadas con un archivo gcode.
Resulta útil inspeccionar estas órdenes de bajo nivel para entender las acciones
del hárdwer de bajo nivel. También puede ser provechoso para comparar la
diferencia en las órdenes de microcontrolador tras efectuar una modificación en
el código.

To run Klippy in this batch mode, there is a one time step necessary to generate
the micro-controller "data dictionary". This is done by compiling the micro-
controller code to obtain the **out/klipper.dict** file:

```
make menuconfig
make
```

Una vez se haya llevado a cabo lo anterior, será posible ejecutar Klipper en
modo por lotes (en [Instalación](Installation.md) encontrará los pasos
necesarios para compilar el entorno virtual de Python y un archivo printer.cfg):

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

Lo anterior producirá un archivo, **test.serial**, con la salida en serie
binaria. Esta salida puede transformarse en texto legible mediante:

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

El archivo resultante, **test.txt**, contiene una lista legible por humanos de
órdenes del microcontrolador.

El modo por lotes desactiva determinadas órdenes de respuesta/petición para
poder funcionar. Por consiguiente, habrá algunas diferencias entre las órdenes
reales y la salida anterior. Los datos generados son útiles para efectuar
pruebas e inspecciones; no lo son para su envío a un microcontrolador real.

# Puesta a prueba con simulavr

La herramienta [simulavr](http://www.nongnu.org/simulavr/) le permite simular un
microcontrolador ATmega de Atmel. Esta sección describe el procedimiento para
ejecutar archivos gcode de prueba a través de simulavr. Es recomendable ejecutar
esto en un PC de escritorio de categoría (no un Raspberry Pi), puesto que
necesitará cuantiosos recursos de CPU para funcionar eficientemente.

Para utilizar simulavr, descargue el paquete de simulavr y compílelo con
compatibilidad con Python:

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
./bootstrap
./configure --enable-python
make
```

Observe que el sistema de generación podría necesitar que algunos paquetes (como
swig) estén instalados para generar el módulo de Python. Asegúrese de que el
archivo **src/python/_pysimulavr.so** exista luego de efectuar la compilación
anterior.

Para compilar Klipper para su uso en simulavr, ejecute:

```
cd /patch/to/klipper
make menuconfig
```

y compile el programa del microcontrolador para un atmega644p de AVR, defina la
frecuencia de MCU a 20 Mhz y seleccione la compatibilidad de emulación del
programa SIMULAVR. Ahora es posible compilar Klipper (ejecute `make`) e iniciar
la simulación con:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py -m atmega644 -s 20000000 -b 250000 out/klipper.elf
```

Then, with simulavr running in another window, one can run the following to read
gcode from a file (eg, "test.gcode"), process it with Klippy, and send it to
Klipper running in simulavr (see [installation](Installation.md) for the steps
necessary to build the python virtual environment):

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

## Utilizar simulavr con gtkwave

Una prestación útil de simulavr es su capacidad de crear archivos de generación
de ondas de señal con la cadencia exacta de los sucesos. Para hacerlo, siga las
instrucciones anteriores, pero ejecute avrsim.py con una línea de órdenes como
esta:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py -m atmega644 -s 20000000 -b 250000 out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

The above would create a file **avrsim.vcd** with information on each change to
the GPIOs on PORTA and PORTB. This could then be viewed using gtkwave with:

```
gtkwave avrsim.vcd
```

# Enviar órdenes al microcontrolador manualmente

Normally, the host klippy.py process would be used to translate gcode commands
to Klipper micro-controller commands. However, it's also possible to manually
send these MCU commands (functions marked with the DECL_COMMAND() macro in the
Klipper source code). To do so, run:

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

See the "HELP" command within the tool for more information on its
functionality.

Tiene a su disposición algunas opciones de línea de órdenes. Para obtener más
información al respecto, ejecute: `~/klippy-env/bin/python ./klippy/console.py --help`

# Generar gráficos de carga

El archivo de registro de Klippy (/tmp/klippy.log) almacena estadísticas sobre
anchura de banda, carga sobre el microcontrolador y carga sobre el búfer del
anfitrión. Puede resultar útil graficar estas estadísticas luego de mostrarlas.

To generate a graph, a one time step is necessary to install the "matplotlib"
package:

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Ahora, será posible generar gráficos con:

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

Tras lo anterior, será posible visualizar el archivo resultante,
**loadgraph.png**.

Es posible producir diferentes gráficos. Para más información, ejecute:
`~/klipper/scripts/graphstats.py --help`

# Extraer información desde el archivo klippy.log

El archivo de registro de Klippy (/tmp/klippy.log) contiene además información
para la depuración. Hay una secuencia de órdenes, logextract.py, que puede
resultar útil al momento de analizar problemas de apagado del microcontrolador o
similares. Normalmente se ejecuta con algo como:

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

La secuencia de órdenes extraerá el archivo de configuración de la impresora y
los datos de apagado de MCU. Los volcados de información de un apagado de MCU
(si existen) se reordenarán por fecha y hora para ayudar a diagnosticar
escenarios de causa y efecto.

# Ejecutar las pruebas antirregresiones

The main Klipper GitHub repository uses "github actions" to run a series of
regression tests. It can be useful to run some of these tests locally.

The source code "whitespace check" can be run with:

```
./scripts/check_whitespace.sh
```

The Klippy regression test suite requires "data dictionaries" from many
platforms. The easiest way to obtain them is to [download them from
github](https://github.com/KevinOConnor/klipper/issues/1438). Once the data
dictionaries are downloaded, use the following to run the regression suite:

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```
