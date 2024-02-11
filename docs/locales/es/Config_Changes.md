# Cambios de Configuración

Este documento cubre los cambios recientes al software en el archivo de configuración que no son compatible con previas versiones. Es una buena idea revisar este documento cuando se vaya a actualizar el software de Klipper.

Todas las fechas en este archivo son aproximadas.

## Cambios

20230826: Si `safe_distance` está activado o se calcula a 0 en `[dual_carriage]`, los chequeos de proximidad de los carruajes seran desactivados de acuerdo con la documentación. Es posible que un usuario desee configurar `safe_distance` explícitamente para evitar choques accidentales entre los carruajes. Además, el orden del proceso de retorno a casa de los carruajes principales y secundarios ha cambiado en algunas configuraciones (ciertas configuraciones cuando ambos carruajes estan restornando a casa en la misma dirección, vea [[dual_carriage] configuration reference](./Config_Reference.md#dual_carriage) para más detalles).

20230810: El programa flash-sdcard.sh ahora apoya las dos variantes del Bigtreetech SKR-3: STM32H743 y STM32H723. Para esto, la etiqueta original btt-skr-3 ahora a cambiado a ser btt-skr-3-h743 o btt-skr-3-h723.

20230729: El estado exportado para `dual_carriage` ha cambiado. En lugar de exportar `mode` y `active_carriage`, los modos individuales para cada carruaje se exportan como `printer.dual_carriage.carriage_0` y `printer.dual_carriage.carriage_1`.

20230619: La opción `relative_reference_index` se descontinuó y sustituida por la opción `zero_reference_position`. Consulte [Bed Mesh Documentation](./Bed_Mesh.md#the-deprecated-relative_reference_index) para obtener detalles de cómo actualizar la configuración. Con la descontinuación, `RELATIVE_REFERENCE_INDEX` ya no esta disponible como un parámetro para el comando de gcode `BED_MESH_CALIBRATE`.

20230530: La frequencia predeterminada del canbus en "make menuconfig" es ahora 1000000. Si esta usando canbus y es necesario usar canbus con otra frequencia, asegúrese de seleccionar "Enable extra low-level configuration options" y especifique la "CAN bus speed" deseada en "make menuconfig" al compilar y reprogramar el microcontrolador.

20230525: El comando `SHAPER_CALIBRATE` aplica inmediatamente los parámetros de los diferentes métodos de combinar señales de entrada con el propósito de minimizar las vibraciones causadas por el movimiento de la impresora ("input shaping" en inglés) si `[input_shaper]` está ya activado.

20230407: El nombre del contador `stalled_bytes`en la bitácora y en el campo `printer.mcu.last_stats` cambió a `upcoming_bytes`.

20230323: En los controladores del tmc5160 `multistep_fit` esta ahora activado de manera predeterminada. Asigne `driver_MULTISTEP_FILT: False` en la configuración del tmc5160 para el comportamiento anterior.

20230304: El comando `SET_TMC_CURRENT` ahora ajusta correctamente el registro globalscaler para los controladores que lo tienen. Esto elimina una limitación de los tmc5160 donde el `SET_TMC_CURRENT`no podía aumentar las corrientes más alto que el valor de `run_current` establecido en el archivo de configuración. Sin embargo, esto tiene un efecto secundario: después de correr el `SET_TMC_CURRENT`, el motor paso a paso debe mantenerse parado durante >130 ms en caso de que se use StealthChop2 para que el controlador ejecute la calibración AT#1.

20230202: El formato de la información de estado `printer.screws_tilt_adjust` ha cambiado. La información se almacena ahora como un diccionario de tornillos con las medidas resultantes. Vea el [status reference](Status_Reference.md#screws_tilt_adjust) para más detalles.

20230201: El módulo `[bed_mesh]` ya no carga el perfil `default` durante la sequencia de inicio. Se recomienda que los usuarios que utilizan el perfil `default` añadan `BED_MESH_PROFILE LOAD=default` a su macro `START_PRINT` (o a la configuración "Start G-Code" de su cortador cuando corresponda).

20230103: Ahora es posible utilizar el programa flash-sdcard.sh para reprogramar ambas variantes del Bigtreetech SKR-2: STM32F407 and STM32F429. Esto significa que la etiqueta original de btt-skr2 ahora ha cambiado a btt-skr-2-f407 o btt-skr-2-f429.

20221128: La versión v0.11.0 de Klipper se lanzó.

20221122: Anteriormente, con safe_z_home, era posible que el z_hop fuera en la dirección z negativa después del proceso de retorno a casa g28. Ahora, un z_hop solamente se realiza después del g28 cuando resulta en un brinco positivo, reflejando el comportamiento del z_hop que ocurre antes del proceso de retorno a casa g28.

20220616: Anteriormente era posible borrar y reprogramar ("flash") el microchip rp2040 en modo de gestor de arranque ejecutando `make flash FLASH_DEVICE=first`. El comando equivalente es ahora `make flash FLASH_DEVICE=2e8a:0003`.

20220612: El microcontrolador rp2040 ahora tiene una solución temporal para la errata del USB "rp2040-e5". Esto debería hacer que las conexiones USB iniciales sean más fiables. Sin embargo, puede resultar en un cambio en el comportamiento del pin gpio15. Es poco probable que el cambio en comportamiento del gpio15 sea notable.

20220407: La opción de configuración `pid_integral_max` de temperature_fan se eliminó (fue discontinuada en 20210612).

20220407: El orden de color predeterminado para los LEDs del pca9632 ahora es "RGBW". Añada el parámetro explícito `color_order: RBGW` a la sección de configuración del pca9632 para obtener el comportamiento anterior.

20220330: El formato de la información de estado del `printer.neopixel.color_data` para los módulos neopixel y dotstar ha cambiado. La información ahora se almacena como una lista de listas de colores (en lugar de una lista de diccionarios). Vea [status reference](Status_Reference.md#led) para más detalles.

20220307: El `M73` ya no establecerá el progreso de la impresión a 0 si falta `P`.

20220304: Ya no hay un valor predeterminado para el parámetro `extruder` de las secciones de configuración [extruder_stepper](Config_Reference.md#extruder_stepper). Si lo desea, especifique `extruder: extruder` explícitamente para asociar el motor paso a paso con la cola de movimientos del "extrusor" durante la secuencia de inicio.

20220210: El comando `SYNC_STEPPER_TO_EXTRUDER` está discontinuado; el comando `SET_EXTRUDER_STEP_DISTANCE` está discontinuado; la opción de configuración [extruder](Config_Reference.md#extruder) `shared_heater` está discontinuada. Estos atributos se eliminarán en un futuro cercano. Reemplace `SET_EXTRUDER_STEP_DISTANCE` con `SET_EXTRUDER_ROTATION_DISTANCE`. Reemplace `SYNC_STEPPER_TO_EXTRUDER` con `SYNC_EXTRUDER_MOTION`. Reemplace las secciones de configuración del extrusor que esten usando `shared_heater` con las secciones de configuración de [extruder_stepper](Config_Reference.md#extruder_stepper) y actualice cualquier macro de activación para usar [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion).

20220116: El código para calcular `run_current` en los motores: tmc2130, tmc2208, tmc2209 y tmc2130 ha cambiado. Ahora, algunos parámetros de configuración de `run_current` pueden ser configurados de manera diferente. Esta nueva configuración debería ser más precisa, pero puede invalidar la afinación anterior del controlador del tmc.

20211230: Los programas (`scripts/calibrate_shaper.py` y `scripts/graph_accelerometer.py`) usados para afinar los diferentes métodos de combinar las señales de entrada con el próposito de minimizar las vibraciones causadas por el movimiento de la impresora, ("input shaping" en inglés), se migraron para usar Python3 de forma predeterminada. Como resultado, los usuarios deben instalar las versiones en Python3 de ciertos paquetes (por ejemplo, `sudo apt install python3-numpy python3-matplotlib`) para continuar usando estos programas. Para obtener más detalles consulte[Software installation](Measuring_Resonances.md#software-installation). Alternativamente, los usuarios pueden forzar temporalmente la ejecución de estos programas usando Python2 llamando explícitamente al intérprete de Python2 en la consola: `python2 ~/klipper/scripts/calibrate_shaper.py ...`.

20211110: El sensor de temperatura "NTC 100K beta 3950" está descontinuado. Este sensor se removera en un futuro cercano. La mayoría de los usuarios encontrarán el sensor de temperatura "Generic 3950" más preciso. Para continuar usando la definición anterior (generalmente menos precisa), defina un [thermistor](Config_Reference.md#thermistor) personalizado con `temperature1: 25`, `resistance1: 100000` y `beta: 3950`.

20211104: Se eliminó la opción "step pulse duration" en "make menuconfig". La duración de paso predeterminada para los controladores TMC configurados en modo UART y SPI es ahora 100 ns. Se debe establecer una nueva configuración de `step_pulse_duration` en [stepper config section](Config_Reference.md#stepper) para todos los motores paso a paso que necesitan una duración de pulso personalizada.

20211102: Se han eliminado varias funcionalidades obsoletas. La opción del motor paso a paso `step_distance` se eliminó (obsoleta en 20201222). El alias del sensor `rpi_temperature` se eliminó (obsoleto en 20210219). La opción `pin_map` del mcu se removió (obsoleta en 20210325). Se removieron el parámetro `default_parameter_<name>` del gcode_macro y el acceso de macros a parámetros de comando que no sean a través de la pseudovariable `params` (obsoletos en 20210503). La opción del calentador `pid_integral_max` se eleminó (obsoleta en 20210612).

20210929: La versión v0.10.0 de Klipper se lanzó.

20210903: El [`smooth_time`](Config_Reference.md#extruder) predeterminado para los calentadores ha cambiado a 1 segundo (de 2 segundos). Para la mayoría de impresoras, esto va a resultar en un control de temperatura más estable.

20210830: El nombre predeterminado del adxl345 es ahora "adxl345". El parámetro CHIP predeterminado para el `ACCELEROMETER_MEASURE` y `ACCELEROMETER_QUERY` ahora también es "adxl345".

20210830: El comando ACCELEROMETER_MEASURE del adxl345 ya no admite un parámetro RATE. Para modificar el ritmo de consultas, actualize el archivo printer.cfg y ejecute un comando RESTART.

20210821: Varios parámetros de configuración en `printer.configfile.settings` ahora se informarán como listas en vez de cadenas sin procesar. Si desea la cadena sin procesar actual, use `printer.configfile.config` en su lugar.

20210819: En algunos casos, un movimiento de retorno a casa `G28` puede terminar en una posición que está nominalmente fuera del intervalo de movimiento válido. En raras ocasiones esto puede resultar en errores confusos de "Move out of range" depués de completar el proceso de retorno a casa. Si esto ocurre, cambie los programas de inicio para mover el cabezal a una posición válida inmediatamente después del proceso de retorno a casa.

20210814: Los nombres de los pseudo-pines analógicos en el atmega168 y el atmega328 han cambiado de PE0/PE1 a PE2/PE3.

20210720: Una sección de controller_fan ahora supervisa de manera predeterminada todos los motores paso a paso (no solamente los motores paso a paso cinemáticos). Si se desea el comportamiento anterior, vea la opción de configuración `stepper` en [config reference](Config_Reference.md#controller_fan).

20210703: Ahora, es necesario que una sección de configuración de `samd_sercom` especifique el bus de sercom que esta configurando a través de la opción`sercom`.

20210612: El parámetro de configuración `pid_integral_max` en las secciones (heater) y (temperature_fan) están en desuso. Este parámetro será eliminado próximamente.

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430: El comando SET_VELOCITY_LIMIT (y M204) puede que no establezcan una velocidad, aceleración y square_corner_velocity más grande que la especificada en los valores del archivo de configuración.

20210325: El parámetro de configuración `pin_map`está en desuso. Use el archivo [sample-aliases.cfg](../config/sample-aliases.cfg) para traducir a los nombres actuales de los pines del microcontrolador. El parámetro de configuración `pin_map` será eliminado próximamente.

20210313: El soporte de Klipper para microcontroladores que se comunican con un bus CAN ha cambiado. Si se usa el bus CAN, todos los microcontroladores deben ser reprogramados y la [configuración de Klipper debe ser actualizada](CANBUS.md).

20210310: La configuración por defecto de TMC2660 para el controlador driver_SFILT ha sido cambiada de 1 a 0.

20210227: Los controladores del motor paso a paso TMC en modos UART o SPI ahora son añadidos a la cola una vez por segundo cuando son activados · si no se puede establecer comunicación con el controlador o si éste reporta un error, Klipper cambiará a un estado de apagado.

20210219: El módulo `rpi_temperature` ha sido renombrado como `temperature_host`. Sustituya cualquier definición declarada como `sensor_type: rpi_temperature` por `sensor_type: temperature_host`. La ruta al archivo de configuración de temperatura puede ser especificada en la variable de configuración `sensor_path`. El nombre del módulo `rpi_temperature` está en desuso y será eliminado próximamente.

20210201: El comando `TEST_RESONANCES` ahora deshabilitará la configuración de entrada si ha sido previamente habilitada (y reestablézcala despues de la prueba). Para sobreescribir el método y mantener la configuración de entrada activada, puede añadir un parámetro adicional declarado como `INPUT_SHAPING=1` al comando.

20210201: El comando `ACCELEROMETER_MEASURE` ahora añadira el nombre del chip del acelerómetro al nombre del archivo de salida si el chip fue nombrado en la sección correspondiente del archivo printer.cfg adxl345.

20201222: El parámetro de configuración `step_distance` en la sección de configuración del motor paso a paso esta en desuso. Se aconseja que se actualize la configuración para usar el parámetro [`Rotation_distance`](Rotation_Distance.md). La asistencia con el parámetro `step_distance` sera discontinuada en el futuro cercano.

20201218: El parámetro `endstop_phase` en el módulo endstop_phase a sido reemplazado con `trigger_phase`. Si se esta usando el módulo de fases del mecanismo de final de carrera va a ser necesario convertir a [`rotation_distance`](Rotation_Distance.md) y volver a calibrar cualquier fase del mecanismo de final de carrera usando el comando ENDSTOP_PHASE_CALIBRATE.

20201218: Las impresoras delta y polar ahora necesitan especificar un `gear_ratio` para sus mecanismos de paso a paso rotativo y ya no pueden especificar un parámetro de `step_distance`. Vea el [config reference](Config_Reference.md#stepper) para el formato del nuevo parámetro gear_ratio.

20201213: No es válido especificar un "position_endstop" Z al usar "probe:z_virtual_endstop". Un error aparecerá de ahora en adelante si se especifica un "position_endstop" Z con "probe:z_virtual_endstop". Remueva la definición de "position_endstop" Z para arreglar el error.

20201120: La sección de configuración de `[board_pins]` ahora especifica el nombre del microcontrolador ("mcu") en un parámetro explícito `mcu:`. Si esta usando board_pins para un mcu secundario, entonces tendrá que actualizar la configuración para especificar ese nombre. Vea [config reference](Config_Reference.md#board_pins) para más detalles.

20201112: El tiempo reportado por `print_stats.print_duration` ha cambiado. El tiempo que ha transcurrido antes de la primera extrusión está ahora excluido.

20201029: Se ha removido la opción de configuración del neopixel `color_order_GRB`. Si es necesario, actualice la configuración para establecer la nueva opción de `color_order` a RGB, GRB, RGBW, o GRBW.

20201029: La opción serial en la sección de configuración del microcontrolador ("mcu") dejo de ser predeterminada a el valor /dev/ttyS0. En la rara situación donde /dev/ttyS0 es el puerto serial deseado, debe de especificarse explícitamente.

20201020: La version v0.9.0 de Klipper salió.

20200902: El cálculo de la proporción de la resistencia a la temperatura de los detectores de temperatura de la resistencia (RTD) para los convertidores MAX31865 ha sido corregido para no leer bajo. Si está usando este tipo de dispositivo, debería volver a calibrar la temperature de impresión y la configuración de los controladores proporcional-integral-derivativa (PID).

20200816: El objeto del macro de gcode `printer.gcode` ha sido renombrado a `printer.gcode_move`. Se han removido diversas variables indocumentadas en `printer.toolhear` y `printer.gcode`. Vea docs/Command_Templates.md para una lista de las variables disponibles en las plantillas.

20200816: El sistema del macro gcode "action_" ha cambiado. Reemplace cualquier llamada a `printer.gcode.action_emergency_stop()` con `action_emergency_stop()`, `printer.gcode.action_respond_info()` con `action_respond_info()`, y `printer.gcode.action_respond_error()` con `action_raise_error()`.

20200809: El sistema de menús se reescribió. Si el menú se ha personalizado entonces será necesario actualizarlo a la nueva configuración. Vea detalles de la configuración en config/example-menu.cfg y vea ejemplos en klippy/extras/display/menu.cfg.

20200731: El comportamiento del atributo `progress` reportado por el objeto de la impresora `virtual_sdcard` ha cambiado. El progreso ya no reinicia a 0 cuando se pausa una impresión. Ahora, el progreso se reportará basado en la posición dentro del archivo o 0 cuando no hay un archivo cargado.

20200725: El parámetro de configuración del servo `enable` y el parámetro SET_SERVO `ENABLE` han sido removidos. Actualice cualquier macro con `SET_SERVO SERVO=my_servo WITDH=0`para desactivar un servo.

20200608: El grupo de sostenimiento de los visualizadores LCD ha cambiado el nombre the algunos "glifos" internos. Si se ha implementado un diseño personalizado, podría ser necesario actualizar el diseño con los nombres de glifos más recientes (vea klippy/extras/display/display.cfg para una lista de los glifos disponibles).

20200606: Los nombres de los pines en el microcontrolador ("mcu") de linux han cambiado. Los nombres de los pines ahora tienen la forma: `gpiochip<chipid>/gpio<gpio>`. Para el gpiochip0 también puede usar la forma corta `gpio<gpio>`. Por ejemplo, a lo que previamente se refería como `P20` ahora se convierte en `gpio20` o `gpiochip0/gpio20`.

20200603: El diseño predeterminado del LCD 16x4 ya no va a indicar el tiempo estimado que queda en un trabajo de impresión. (Solamente va a indicar el tiempo que a transcurrido). Si se desea el comportamiento previo se puede personalizar la pantalla del menú con esa información (vea la descripción de display_data en config/example-extras.cfg para más detalles).

20200531: El número de identificación ("id") predeterminado del vendedor/producto USB ahora es 0x1d50/0x614e. Estos nuevos números de identificación están reservados para Klipper (gracias al proyecto openmoko). Este cambio no debe requerir ningún cambio a la configuración, pero los nuevos números de identificación podrían aparecer en registro del sistema.

20200524: El valor predeterminado para el campo pwm_freq del tmc5160 es ahora zero (en vez de uno).

20200425: El nombre de la variable `printer.heater` de la plantilla de comando gcode_macro se cambió a `printer.heaters`.

20200313: El diseño predeterminado del lcd para impresoras multiextrusor con pantallas 16x4 ha cambiado. El diseño de pantalla para un solo extrusor es ahora el predeterminado y mostrará el extrusor actualmente activo. Para usar el diseño de pantalla anterior escoja "display_group:_multiextruder_16x4" en la sección [display] del archivo printer.cfg.

20200308: Se eliminó el elemento predeterminado `_test` del menú. Si el archivo de configuración contiene un menú personalizado, asegúrese de remover todas las referencias al elemento del menú `_test`.

20200308: Se eliminaron las opciones del menú "deck" y "card". Use las nuevas secciones de configuración display_data para personalizar el diseño de una pantalla lcd (vea config/example-extras.cfg para los detalles).

20200109: El módulo bed_mesh ahora hace referencia a la posición de la sonda para la configuración de la malla. Por lo tanto, algunas de la opciones de configuración tienen un nuevo nombre que refleja con más exactitud su propósito. Para camas rectangulares, `min_point` y `max_point` ahora se llaman `mesh_min` y `mesh_max` respectivamente. Para camas redondas, `bed_radius` cambió de nombre a `mesh_radius`. Adicionalmente, una nueva opción, `mesh_origin` se añadió para las camas redondas. Noten que estos cambios también son incompatibles con perfiles de malla previamente guardados. Si se detecta un perfil incompatible sera ignorado y programado para ser removido. El proceso de removimiento puede ser completado usando el comando SAVE_CONFIG. El usuario tendrá que volver a calibrar cada perfil.

20191218: La sección de configuración de la pantalla ha cesado de sostener el "lcd_type: st7567". En su lugar, use el tipo de pantalla "uc1701" - asigne el "lcd_type: uc1701" y cambie el "rs_pin: some_pin" a "rst_pin: some_pin". También, puede ser necesario añadir el parámetro de configuración "contrast: 60".

20191210: Los comandos incorporados T0, T1, T2, ... han sido removidos. Las opciones de configuración activate_gcode y deactivate_gcode han sido removidas. Si se necesitan estos comandos (y programas) entonces defina macros de estilo individual [gcode_macro T0] que llamen al comando ACTIVATE_EXTRUDER. Vea ejemplos en los archivos: config/sample-idex.cfg y sample-multi-extruder.cfg.

20191210: Se ha eliminado el sostenimiento para el comando M206. Reemplazar con llamadas a SET_GCODE_OFFSET. Si se necesita sostenimiento para el M206, añada una sección de configuración [gcode_macro M206] que llame a SET_GCODE_OFFSET. (Por ejemplo, "SET_GCODE_OFFSET Z=-{params.Z}").

20191202: Se ha eliminado el sostenimiento para el parámetro indocumentado "S" del comando “G4”. Reemplace cualquier ocurrencia de S con el parámetro estándar "P" (el retardo especificado en milisegundos).

20191126: Los nombres de USB han cambiado en los microcontroladores que tienen sostenimiento nativo para USB. Ahora, de manera predeterminada, usan una identificación de chip única (donde esté disponible). Si una sección de configuración del microcontrolador "mcu" usa una configuración "serial" que comienza con "/dev/serial/by-id/" puede ser necesario actualizar la configuración. Ejecute "ls /dev/serial/by-id/*" en un terminal ssh para determinar la nueva identificación.

20191121: Se ha eliminado el parámetro pressure_advance_lookahead_time. Consulte example.cfg para conocer los parámetros de configuración alternativos.

20191112: La capacidad de habilitación virtual del controlador tmc para el motor paso a paso ahora se habilita automáticamente si el motor no tiene un pin the habilitación paso a paso dedicado. Elimine las referencias a tmcXXXX:virtual_enable de la configuración. Se ha eliminado la capacidad de controlar varios pines en la configuración enable_pin del motor paso a paso. Si se necesitan varios pines utilice una sección de configuración multi_pin.

20191107: La sección de configuración del extrusor principal debe especificarse como "extruder" y ya no puede especificarse como "extruder0". Ahora se accede a las plantillas de comando Gcode que consultan el estado del extrusor a través de "{printer.extruder}".

20191021: Ha salido la versión v0.8.0 de Klipper

20191003: Ahora, la opción move_to_previous en [safe_z_homing] es preestablecida como Falso. (Era efectivamente Falso antes de 20190918.)

20190918: La opción zhop en [safe_z_homing] siempre se vuelve a aplicar después de completar el proceso de retorno a casa en el eje Z. Esto podría requerir que los usuarios actualicen los programas personalizados basados en este módulo.

20190806: El comando SET_NEOPIXEL ha cambiado de nombre a SET_LED.

20190726: El código para convertir de digital-a-analógico del mcp4728 ha cambiado. El valor predeterminado para el i2c_address ahora es 0x60 y el voltaje de referencia es ahora relativo a la referencia interna de 2.048 vatios del mcp4728.

20190710: Se removió la opción z_hop de la sección de configuración [firmware_retract]. El sostenimiento de z_hop estaba incompleto y podría causar un comportamiento incorrecto con varios cortadores comunes.

20190710: Los parámetros opcionales del comando PROBE_ACCURACY han cambiado. Puede que sea necesario actualizar cualquier macro o programas que usen ese comando.

20190628: Se eliminaron todas las opciones de configuración de la sección [skew_correction]. La configuración para skew_correction ahora se realiza a través del gcode SET_SKEW. Vea [Skew Correction](Skew_Correction.md) para recomendaciones de uso.

20190607: Los parámetros "variable_X" de gcode_macro (junto con el parámetro VALUE de SET_GCODE_VARIABLE) ahora se analizan como literales de Python. Si es necesario asignar una cadena a un valor entonces envuelva el valor entre comillas para que se evalúe como una cadena.

20190606: Las siguientes opciones de configuración: "sample", "samples_result" y "sample_retract_dist", se han movido al la sección de configuración "probe". Estas opciones ya no son válidas en las siguientes secciones de configuración: "delta_calibrate", "bed_tilt", "bed_mesh", "screws_tilt_adjust", "z_tilt" o "quad__gantry_level".

20190528: El nombre de la variable mágica "status" en la evaluación de la plantilla gcode_macro ha cambiado a "printer".

20190520: El comando SET__GCODE_OFFSET ha cambiado; actualice cualquier macros de g-code como corresponde. El comando ya no aplicará el desplazamiento solicitado al siguiente comando G1. El comportamiento anterior se puede aproximar utilizando el nuevo parámetro "MOVE=1".

20190404: Se actualizaron los paquetes de software del Python host. Los usuarios deberán volver a correr el programa ~/klipper/scripts/install-octopi.sh (o actualizar la dependencias de Python si no se utiliza una instalación estándar de OctoPi).

20190404: Los parámetros i2c_bus y spi_bus (en varias secciones de configuración) ahora toman un nombre de bus en lugar de un número.

20190404: Los parámetros de configuración del sx1509 han cambiado. El parámetro 'address' es ahora 'i2c_address' y debe especificarse como un número decimal. Donde se haya utilizado anteriormente 0x3E, especifique 62.

20190328: Ahora se respetará el valor min_speed en la configuración [temperature_fan] y el abanico siempre funcionará a esta o más alta velocidad cuando en el modo PID.

20190322: El valor predeterminado para el "driver_HEND" en las secciones de configuración del [tmc2660] se cambió de 6 a 3. El campo "driver_VSENSE" se eliminó (ahora se calcula automáticamente de run__current).

20190310: La sección de configuración del [controller_fan] ahora siempre toma un nombre (como [controller_fan my_controller_fan]).

20190308: El campo "driver__BLANK_TIME_SELECT" en las secciones de configuración del [tmc2130] y del [tmc2208] han cambiado de nombre a "driver_TBL".

20190308: La sección de configuración del [tmc2660] ha cambiado. Ahora se require proveer un nuevo parámetro de configuración sense__resistor. El significado de varios de los parámetros driver_XXX ha cambiado.

20190228: Los usuarios de SPI o I2C en las placas SAMD21 ahora deben especificar los pines del bus a través de una sección de configuración [samd_sercom].

20190224: La opción bed_shape se eliminó de bed_mesh. El nombre de la opción del radio se cambió a bed_radius. Usuarios con camas redondas deben proveer las opciones de bed_radius y round_probe_count.

20190107: El parámetro i2c_address en la sección de configuración del mcp4451 cambió. Este parámetro se utiliza comúnmente en Smoothieboards. El nuevo valor es la mitad del valor anterior (88 debe cambiarse a 44 y 90 debe cambiarse a 45).

20181220: La versión v0.7.0 de Klipper se lanzó
