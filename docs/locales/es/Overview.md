# Visión de conjunto

Le damos la bienvenida a la documentación de Klipper. Si recién comienza a utilizar Klipper, comience leyendo los documentos [Funcionalidades](Features.md) e [Instalación](Installation.md).

## Información general

- [Funcionalidades](Features.md): una lista general de prestaciones de Klipper.
- [Preguntas frecuentes](FAQ.md): cuestiones que surgen a menudo.
- [Versiones](Releases.md): el histórico de versiones de Klipper.
- [Cambios en la configuración](Config_Changes.md): modificaciones recientes del sóftwer que pueden requerir actualizaciones en los archivos de configuración de las impresoras de los usuarios.
- [Contacto](Contact.md): información para informar de defectos y comunicarse en general con los desarrolladores de Klipper.

## Instalación y configuración

- [Instalación](Installation.md): guía para instalar Klipper.
- [Referencia de configuración](Config_Reference.md): descripción de los parámetros de configuración.
   - [Rotation Distance](Rotation_Distance.md): Calculating the rotation_distance stepper parameter.
- [Config checks](Config_checks.md): Verify basic pin settings in the config file.
- [Bed level](Bed_Level.md): Information on "bed leveling" in Klipper.
   - [Delta calibrate](Delta_Calibrate.md): Calibration of delta kinematics.
   - [Probe calibrate](Probe_Calibrate.md): Calibration of automatic Z probes.
   - [BL-Touch](BLTouch.md): Configure a "BL-Touch" Z probe.
   - [Manual level](Manual_Level.md): Calibration of Z endstops (and similar).
   - [Bed Mesh](Bed_Mesh.md): Bed height correction based on XY locations.
   - [Endstop phase](Endstop_Phase.md): Stepper assisted Z endstop positioning.
- [Resonance compensation](Resonance_Compensation.md): A tool to reduce ringing in prints.
   - [Measuring resonances](Measuring_Resonances.md): Information on using adxl345 accelerometer hardware to measure resonance.
- [Pressure advance](Pressure_Advance.md): Calibrate extruder pressure.
- [Códigos G](G-Codes.md): información relativa a las órdenes que Klipper admite.
- [Command Templates](Command_Templates.md): G-Code macros and conditional evaluation.
   - [Status Reference](Status_Reference.md): Information available to macros (and similar).
- [TMC Drivers](TMC_Drivers.md): Using Trinamic stepper motor drivers with Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing and probing using multiple micro-controllers.
- [Slicers](Slicers.md): Configure "slicer" software for Klipper.
- [Skew correction](Skew_Correction.md): Adjustments for axes not perfectly square.
- [PWM tools](Using_PWM_Tools.md): Guide on how to use PWM controlled tools such as lasers or spindles.

## Documentación para desarrolladores

- [Visión de conjunto del código](Code_Overview.md): lectura primordial para desarrolladores.
- [Kinematics](Kinematics.md): Technical details on how Klipper implements motion.
- [Protocolo](Protocol.md): información sobre el protocolo de mensajería de bajo nivel que hay entre el anfitrión y el microcontrolador.
- [Servidor de API](API_Server.md): información relativa a la API de órdenes y control de Klipper.
- [Órdenes de MCU](MCU_Commands.md): una descripción de las órdenes de bajo nivel que incluye el sóftwer del microcontrolador.
- [Protocolo de bus CAN](CANBUS_protocol.md): el formato de mensajes de bus CAN de Klipper.
- [Depuración](Debugging.md): información sobre cómo poner a prueba y depurar Klipper.
- [Benchmarks](Benchmarks.md): Information on the Klipper benchmark method.
- [Contribuir](CONTRIBUTING.md): información para enviar mejoras a Klipper.
- [Empaquetamiento](Packaging.md): información sobre la creación de paquetes para sistemas operativos.

## Documentos específicos de un dispositivo

- [Example configs](Example_Configs.md): Information on adding an example config file to Klipper.
- [SDCard Updates](SDCard_Updates.md): Flash a micro-controller by copying a binary to an sdcard in the micro-controller.
- [Raspberry Pi as Micro-controller](RPi_microcontroller.md): Details for controlling devices wired to the GPIO pins of a Raspberry Pi.
- [Beaglebone](Beaglebone.md): Details for running Klipper on the Beaglebone PRU.
- [Bootloaders](Bootloaders.md): Developer information on micro-controller flashing.
- [Bus CAN](CANBUS.md): información para utilizar un bus CAN con Klipper.
- [TSL1401CL filament width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall filament width sensor](Hall_Filament_Width_Sensor.md)
