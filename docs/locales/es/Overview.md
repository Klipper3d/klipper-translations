# Visión de conjunto

Bienvenido a la documentación de Klipper. Si eres nuevo con Klipper, comienza por leer los documentos [Funcionalidades](Features.md) e [Instalación](Installation.md).

## Información general

- [Funcionalidades](Features.md): Una lista detallada de las funcionalidades de Klipper.
- [Preguntas frecuentes](FAQ.md): Preguntas más frecuentes.
- [Versiones](Releases.md): El historial de versiones de Klipper.
- [Cambios en la configuración](Config_Changes.md): Modificaciones recientes del software que pueden requerir que el usuario tenga que actualizar el archivo de configuración de su impresora.
- [Contacto](Contact.md): Información sobre cómo reportar errores o comunicarse con los desarrolladores de Klipper.

## Instalación y configuración

- [Instalación](Installation.md): Guía de instalación de Klipper.
- [Referencias para la Configuración](Config_Reference.md): Descripción de los parámetros de la configuración.
   - [Distancia de Rotación](Rotation_Distance.md): Cómo calcular el parámetro de pasos distancia_de_rotacion.
- [Validación de configuración](Config_checks.md): Verificar las configuraciónes básicas del PIN en el archivo de configuración.
- [Nivel de la cama](Bed_Level.md): Información sobre la "nivelación de la cama" en Klipper.
   - [Calibración delta](Delta_Calibrate.md): Calibración de la cinemática delta.
   - [Calibración de la sonda](Probe_Calibrate.md): Calibración de sondas Z automáticas.
   - [BL-Touch](BLTouch.md): Configura una sonda Z "BL-Touch".
   - [Nivel manual](Manual_Level.md): Calibración de paradas finales de Z (y similares).
   - [Cama de malla](Bed_Mesh.md): Corrección de la altura de la cama basada en las coordenadas XY.
   - [Fase de parada final](Endstop_Phase.md): Posicionamiento del tope Z asistido por pasos.
- [Compensación de resonancia](Resonance_Compensation.md): Una herramienta para reducir las irregularidades en las impresiones.
   - [Resonancias de medida](Measuring_Resonances.md): Información sobre el uso del acelerómetro adxl345 para medir la resonancia.
- [Avance de presión](Pressure_Advance.md): Calibrar la presión del extrusor.
- [Códigos G](G-Codes.md): información relativa a las órdenes que Klipper admite.
- [Plantillas de comandos](Command_Templates.md): Macros de código G y evaluación condicional.
   - [Referencia de estado](Status_Reference.md): Información disponible para las macros (y similares).
- [Drivers de TMC](TMC_Drivers.md): Usando los drivers del motor de pasos trinámicos con Klipper.
- [Busqueda de blancos con varias MCU](Multi_MCU_Homing.md): Búsqueda y sondea usando varios micro controladores.
- [Rebanadores](Slicers.md): Configuración del software de "rebanadores" para Klipper.
- [Corrección de sesgos](Skew_Correction.md): Ajustes para los ejes que no estén perfectamente cuadrados.
- [Herramientas PWM](Using_PWM_Tools.md): Guía de uso de herramientas controladas mediante PWM como son los láseres y ejes.

## Documentación para desarrolladores

- [Visión de conjunto del código](Code_Overview.md): lectura primordial para desarrolladores.
- [Cinematica](Kinematics.md): Detalles tecnicos sobre como Klipper implementa el movimiento.
- [Protocolo](Protocol.md): información sobre el protocolo de mensajería de bajo nivel que hay entre el anfitrión y el microcontrolador.
- [Servidor de API](API_Server.md): información relativa a la API de órdenes y control de Klipper.
- [Órdenes de MCU](MCU_Commands.md): una descripción de las órdenes de bajo nivel que incluye el sóftwer del microcontrolador.
- [Protocolo de bus CAN](CANBUS_protocol.md): el formato de mensajes de bus CAN de Klipper.
- [Depuración](Debugging.md): información sobre cómo poner a prueba y depurar Klipper.
- [Puntos de referencia](Benchmarks.md): Información sobre el método de referencia de Klipper.
- [Contribuir](CONTRIBUTING.md): información para enviar mejoras a Klipper.
- [Empaquetamiento](Packaging.md): información sobre la creación de paquetes para sistemas operativos.

## Documentos específicos de un dispositivo

- [Ejemplos de configuración](Example_Configs.md): Información sobre la adición de una configuración de ejemplo a Klipper.
- [Actualizaciones de la tarjeta SD](SDCard_Updates.md): Flashear un micro controlador mediante la copia de un binario a una tarjeta SD en el micro controlador.
- [Raspberry PI como un micro controlador](RPI_microcontroller.md): Detalles para controlar dispositivos cableados a los pines GPIO de la Raspberry Pi.
- [Beaglebone](Beaglebone.md): Detalles para correr Klipper en la PRU de Beaglebone.
- [Cargadores de arranque](Bootloaders.md): Información para desarrolladores sobre el flasheo de microcontroladores.
- [Bus CAN](CANBUS.md): información para utilizar un bus CAN con Klipper.
- [Sensor de anchura del filamento TSL1401CL](TSL1401CL_Filament_Width_Sensor.md)
- [Sensor de anchura del filamento Hall](Hall_Filament_Width_Sensor.md)
