# Features

Klipper ofereix diverses prestacions destacades:

* Moviment dels motors pas a pas d’alta precisió. Klipper utilitza un processador d’aplicacions (com una Raspberry Pi de baix cost) per calcular els moviments de la impressora. El processador d’aplicacions determina quan s’ha d’activar cada motor pas a pas, compila aquests esdeveniments, els transmet al microcontrolador i, a continuació, el microcontrolador executa cada esdeveniment en el moment sol·licitat. Cada esdeveniment dels motors pas a pas es programa amb una precisió de 25 microsegons o superior. El programari no utilitza estimacions cinemàtiques (com l’algoritme de Bresenham), sinó que calcula els temps precisos dels passos basant-se en la física de l’acceleració i la cinemàtica de la màquina. Un moviment més precís dels motors pas a pas proporciona un funcionament de la impressora més silenciós i estable.
* Rendiment líder de la seva categoria. Klipper és capaç d’assolir freqüències de passos elevades tant en microcontroladors nous com antics. Fins i tot els microcontroladors antics de 8 bits poden superar els 175.000 passos per segon. En els microcontroladors més recents, són possibles diversos milions de passos per segon. Les freqüències de passos més elevades permeten assolir velocitats d’impressió més altes. La temporització dels passos es manté precisa fins i tot a velocitats elevades, cosa que millora l’estabilitat general.
* Klipper supports printers with multiple micro-controllers. For example, one micro-controller could be used to control an extruder, while another controls the printer's heaters, while a third controls the rest of the printer. The Klipper host software implements clock synchronization to account for clock drift between micro-controllers. No special code is needed to enable multiple micro-controllers - it just requires a few extra lines in the config file.
* Configuration via simple config file. There's no need to reflash the micro-controller to change a setting. All of Klipper's configuration is stored in a standard config file which can be easily edited. This makes it easier to setup and maintain the hardware.
* Klipper supports "Smooth Pressure Advance" - a mechanism to account for the effects of pressure within an extruder. This reduces extruder "ooze" and improves the quality of print corners. Klipper's implementation does not introduce instantaneous extruder speed changes, which improves overall stability and robustness.
* Klipper supports "Input Shaping" to reduce the impact of vibrations on print quality. This can reduce or eliminate "ringing" (also known as "ghosting", "echoing", or "rippling") in prints. It may also allow one to obtain faster printing speeds while still maintaining high print quality.
* Klipper uses an "iterative solver" to calculate precise step times from simple kinematic equations. This makes porting Klipper to new types of robots easier and it keeps timing precise even with complex kinematics (no "line segmentation" is needed).
* Klipper és independent del maquinari. S’hauria d’obtenir la mateixa temporització precisa independentment del maquinari electrònic de baix nivell. El codi de microcontrolador de Klipper està dissenyat per seguir fidelment la planificació proporcionada pel programari amfitrió de Klipper (o avisar clarament l’usuari si no és capaç de fer-ho). Això facilita l’ús del maquinari disponible, l’actualització a maquinari nou i la confiança en el maquinari.
* Codi portable. Klipper funciona en ARM, AVR, PRU i altres microcontroladors. Les impressores existents d’estil «reprap» poden executar Klipper sense modificacions de maquinari: només cal afegir una Raspberry Pi. L’estructura interna de Klipper també facilita la compatibilitat amb altres arquitectures de microcontroladors.
* Codi més senzill. Klipper utilitza un llenguatge de molt alt nivell (Python) per a la major part del codi. Els algoritmes de cinemàtica, l’anàlisi del G-code, els algoritmes d’escalfament i de termistors, etc., estan escrits en Python. Això facilita el desenvolupament de noves funcionalitats.
* Custom programmable macros. New G-Code commands can be defined in the printer config file (no code changes are necessary). Those commands are programmable - allowing them to produce different actions depending on the state of the printer.
* Builtin API server. In addition to the standard G-Code interface, Klipper supports a rich JSON based application interface. This enables programmers to build external applications with detailed control of the printer.

## Additional features

Klipper supports many standard 3d printer features:

* Diverses interfícies web disponibles. Funciona amb Mainsail, Fluidd, OctoPrint i altres. Això permet controlar la impressora mitjançant un navegador web convencional. La mateixa Raspberry Pi que executa Klipper també pot executar la interfície web.
* Standard G-Code support. Common g-code commands that are produced by typical "slicers" (SuperSlicer, Cura, PrusaSlicer, etc.) are supported.
* Support for multiple extruders. Extruders with shared heaters and extruders on independent carriages (IDEX) are also supported.
* Suport per a impressores de tipus cartesiana, delta, CoreXY, CoreXZ, Hybrid-CoreXY, Hybrid-CoreXZ, Deltesian, delta rotativa, polar i cabrestant de cables.
* Suport per a l’anivellament automàtic de la base d'impressió. Klipper es pot configurar per detectar una inclinació bàsica de la base o per fer un anivellament complet mitjançant una malla. La malla de la base es pot adaptar a la mida de la impressió (malla adaptativa). Si la base utilitza diversos motors pas a pas a l'eix Z, Klipper també pot anivellar-la ajustant els motors Z de manera independent. S’admeten la majoria de sondes d’alçada Z, incloses les sondes BL-Touch i les sondes accionades per servo. Les sondes es poden calibrar per compensar la torsió dels eixos. Si s’utilitza una «sonda de corrents de Foucault» (eddy current), es pot aprofitar l’escaneig ràpid de la malla de la base.
* Automatic delta calibration support. The calibration tool can perform basic height calibration as well as an enhanced X and Y dimension calibration. The calibration can be done with a Z height probe or via manual probing.
* Suport d'exclusió d'objectes durant la impressió. Quan es configura, aquest mòdul permet cancel·lar només un objecte en una impressió amb diverses peces.
* Suport per als sensors de temperatura habituals (p. ex., termistors comuns, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20, AHT1X, AHT2X, AHT3X, SHT3x i LM75). També es poden configurar termistors personalitzats i sensors de temperatura analògics personalitzats. Es pot supervisar el sensor de temperatura intern del microcontrolador i el sensor de temperatura intern d’una Raspberry Pi.
* Basic thermal heater protection enabled by default.
* Suport per a ventiladors estàndard, ventiladors del broquet i ventiladors controlats per temperatura. No cal mantenir els ventiladors en funcionament quan la impressora està inactiva. La velocitat dels ventiladors es pot supervisar en els que disposen de tacòmetre. Es pot assignar una «fórmula matemàtica» a un ventilador per actualitzar-ne automàticament la velocitat.
* Support for run-time configuration of TMC2130, TMC2208/TMC2224, TMC2209, TMC2240, TMC2660, TMC5160, and TMC5262 stepper motor drivers. There is also support for current control of traditional stepper drivers via AD5206, DAC084S085, MCP4451, MCP4728, MCP4018, and PWM pins.
* Support for common LCD displays attached directly to the printer. A default menu is also available. The contents of the display and menu can be fully customized via the config file.
* Constant acceleration and "look-ahead" support. All printer moves will gradually accelerate from standstill to cruising speed and then decelerate back to a standstill. The incoming stream of G-Code movement commands are queued and analyzed - the acceleration between movements in a similar direction will be optimized to reduce print stalls and improve overall print time.
* Klipper implements a "stepper phase endstop" algorithm that can improve the accuracy of typical endstop switches. When properly tuned it can improve a print's first layer bed adhesion.
* Support for filament presence sensors, filament motion sensors, and filament width sensors.
* Suport per mesurar i registrar l’acceleració mitjançant els acceleròmetres ADXL345, MPU9250, MPU6050, LIS2DW12, LIS3DH i ICM20948.
* Suport per limitar la velocitat màxima dels moviments curts en «zig-zag» per reduir les vibracions i el soroll de la impressora. Consulta el document sobre [kinematics](Kinematics.md) per obtenir més informació.
* Hi ha fitxers de configuració d’exemple disponibles per a moltes impressores habituals. Consulta [config directory](../config/) per obtenir-ne un llistat.

To get started with Klipper, read the [installation](Installation.md) guide.

## Step Benchmarks

Below are the results of stepper performance tests. The numbers shown represent total number of steps per second on the micro-controller.

| Micro-controller | 1 stepper active | 3 steppers active |
| --- | --- | --- |
| 16Mhz AVR | 157K | 99K |
| 20Mhz AVR | 196K | 123K |
| SAMD21 | 686K | 471K |
| STM32F042 | 814K | 578K |
| Beaglebone PRU | 866K | 708K |
| STM32G0B1 | 1103K | 790K |
| STM32F103 | 1180K | 818K |
| SAM3X8E | 1273K | 981K |
| SAM4S8C | 1690K | 1385K |
| LPC1768 | 1923K | 1351K |
| LPC1769 | 2353K | 1622K |
| SAM4E8E | 2500K | 1674K |
| SAMD51 | 3077K | 1885K |
| AR100 | 3529K | 2507K |
| STM32G431 | 3617K | 2452K |
| STM32F407 | 3652K | 2459K |
| STM32F446 | 3913K | 2634K |
| RP2040 | 4000K | 2571K |
| RP2350 | 4167K | 2663K |
| SAME70 | 6667K | 4737K |
| STM32H723 | 7429K | 8619K |

If unsure of the micro-controller on a particular board, find the appropriate [config file](../config/), and look for the micro-controller name in the comments at the top of that file.

Further details on the benchmarks are available in the [Benchmarks document](Benchmarks.md).
