# Verificación de Configuración

Este documento contiene una lista con los pasos para configurar el pin del archivo Klipper printer.cfg. Se recomienda ejecutarlos una vez que se hayan terminado los pasos en [instalación documentos](installation.md).

A lo largo de esta guía puede ser necesario hacer cambios en el archivo config Klipper. Es importante ejecutar el comando RESTART después de cada cambio en el susodicho archivo para asegurar que los cambios han tenido efecto (escriba "restart" en la pestaña del terminal Octoprint y pulse "Send"). Se recomienda también usar el comando STATUS después de cada RESTART para verificar que este archivo se ha cargado correctamente.

## Verifique la temperatura

Comience por verificar que las temperaturas se están notificando correctamente. Vaya a la sección del gráfico de temperatura en la interfaz de usuario. Verifique que la temperatura de la boquilla y la cama (si procede) están presentes y no están aumentando. Si está aumentando, desconecte la alimentación de la impresora. Si las temperaturas no son precisas, revise los ajustes "sensor_type" y "sensor_pin" para la boquilla y/o la cama.

## Verifica M112

Navegue a la consola de comandos y escribe un comando M112 en el cuadro de terminal. Este comando solicita que Klipper entre en un estado de "apagado". Se mostrará un error, que puede ser borrado con un comando FIRMWARE_RESTART en la consola de comandos. Octoprint también requerirá una reconexión. A continuación, vaya a la sección del gráfico de temperatura y compruebe que las temperaturas siguen actualizándose y que no están aumentando. Si las temperaturas están aumentando, desconecte la alimentación de la impresora.

## Verifique los calentadores

Navega hasta la sección del gráfico de temperatura y teclea 50 seguido de intro en la casilla de temperatura del extrusor/herramienta. La temperatura del extrusor en el gráfico debería empezar a aumentar (en unos 30 segundos más o menos). A continuación, ve al menú desplegable de temperatura del extrusor y selecciona "Apagar". Tras varios minutos, la temperatura debería volver a su valor inicial de temperatura ambiente. Si la temperatura no aumenta, verifique el ajuste "heater_pin" en la configuración.

Si la temperatura de la cama es también alta, haga el mismo test para la cama esta vez.

## Verifique el pin del motor de pasos

Compruebe que todos los ejes de la impresora pueden moverse manualmente con libertad (los motores paso a paso están desactivados). Si no es así, emita un comando M84 para desactivar los motores. Si alguno de los ejes sigue sin poder moverse libremente, verifique la configuración del "enable_pin" del motor paso a paso para el eje en cuestión. En la mayoría de los controladores de motores paso a paso, el pin de habilitación del motor es "activo bajo" y por lo tanto el pin de habilitación debe tener un "!" antes del pin (por ejemplo, "enable_pin: !PA1").

## Verifique el paro programado

Mueva manualmente todos los ejes de la impresora para que ninguno de ellos esté en contacto con un endstop. Envíe un comando QUERY_ENDSTOPS a través de la consola de comandos. Deberá responder con el estado actual de todos los endstops configurados y todos deberán reportar un estado de "abierto". Para cada una de las paradas finales, vuelva a ejecutar el comando QUERY_ENDSTOPS mientras activa manualmente la parada final. El comando QUERY_ENDSTOPS debe reportar el endstop como "TRIGGERED".

Si el endstop aparece invertido (indica "abierto" cuando se dispara y viceversa), añada un "!" a la definición del pin (por ejemplo, "endstop_pin: ^PA2"), o elimine el "!" si ya hay uno presente.

Si el final de carrera no cambia en absoluto, entonces generalmente indica que el final de carrera está conectado a un alfiler diferente. Sin embargo, puede requerir también un cambio a la configuración del levantado del alfiler (el '^' al comienzo del nombre de endstop_pin - la mayoría de las impresoras usarán un resistor de levantado y el '^' debería estar presente).

## Verificar el motor a pasos

Utilice el comando STEPPER_BUZZ para verificar la conectividad de cada motor paso a paso. Comienza posicionando manualmente el eje dado en un punto intermedio y luego ejecuta `STEPPER_BUZZ STEPPER=stepper_x` en la consola de comandos. El comando STEPPER_BUZZ hará que el motor paso a paso dado se mueva un milímetro en dirección positiva y luego volverá a su posición inicial. (Si el endstop se define en position_endstop=0 entonces al inicio de cada movimiento el stepper se alejará del endstop). Realizará esta oscilación diez veces.

Si el motor a pasos no se mueve en absoluto, entonces verifique las configuraciones de "enable_pin" y "step_pin" para el motor a pasos. Si el motor a pasos se mueve pero no regresa a su posición original entonces verifique la configuración de "dir_pin". Si el motor a pasos oscila en una dirección incorrecta, entonces generalmente indica que la "dir_pin" para un eje necesita ser invertida. Esto puede hacerse con agregar un '!' a la "dir_pin" en el archivo de configuración de la impresora (o quitándole si ya esta ahí). Si el motor se mueve significativamente más o significativamente menos que un milímetro entonces verifique la configuración "rotation_distance".

Ejecute el test anterior para cada motor a pasos definido en el archivo de configuración. (Establezca el parámetro STEPPER del comando STEPPER_BUZZ al nombre de la sección de configuración que va a ser evaluada.) Si no hay un filamento en el extrusor entonces uno puede usar STEPPER_BUZZ para verificar la conectividad del motor (use STEPPER=extruder). De otra forma, es mejor el evaluar el motor del extrusor separadamente (ver la próxima sección).

Después de verificar todos los finales de carrera y verificar todos los motores a pasos, el mecanismo de guiado al inicio debería ser evaluado. Envíe un comando G28 para enviar al inicio todos los ejes. Quite la alimentación de poder de la impresora si no se guían al inicio adecuadamente. Repita los pasos de verificación de finales de carrera y de los motores a pasos si es necesario.

## Verificar el motor del extrusor

Para probar el motor del extrusor será necesario calentarlo a una temperatura de impresión. Navegue hasta la sección del gráfico de temperatura y seleccione una temperatura objetivo en el cuadro desplegable de temperatura (o introduzca manualmente una temperatura adecuada). Espera a que la impresora alcance la temperatura deseada. A continuación, vaya a la consola de comandos y haga clic en el botón "Extrusión". Comprueba que el motor del extrusor gira en la dirección correcta. Si no lo hace, consulta los consejos de solución de problemas de la sección anterior para confirmar los ajustes "enable_pin", "step_pin" y "dir_pin" del extrusor.

## Calibrar las configuraciones de PID

Klipper soporta [controladores PID](https://es.wikipedia.org/wiki/Controlador_PID) para el extrusor y calienta camas. Para usar este mecanismo de control, es necesario calibrar los ajustes PID en cada impresora (Los ajustes PID de otros firmwares y los de los archivos de configuracion de ejemplo trabajan pobremente).

Para calibrar el extrusor, navega a la consola de comandos y ejecuta el comando PID_CALIBRATE. Por ejemplo: `PID_CALIBRATE HEATER=extruder TARGET=170`

Cuando se complete la prueba de ajuste ejecute `SAVE_CONFIG` para actualizar el archivo printer.cfg con las nuevas configuraciones de PID.

Si la impresora está equipada con una cama de calefacción y soporta ser manejada por PWM (Modulación de Ancho de Pulsos) entonces es recomienda el usar control PID para la cama. (Cuando el calentador de cama es controlado usando el algoritmo PID, se puede prender y apagar diez veces por segundo, lo cual no puede ser adecuado para calentadores que utilicen un interruptor mecánico.) Un comando de calibración PID de cama típico es: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Pasos Siguientes

Esta guía pretende el ayudar con la verificación básica de las configuraciones del alfiler en el archivo de configuración de Klipper. Asegúrese de leer la guía de [nivelación de cama](Bed_Level.md). También vea el documento sobre [Rebanadores](Slicers.md) para información sobre el configurar un rebanador con Klipper.

Después de haber verificado que la impresión básica funciona, es una buena idea el considerar calibrar el [Avance de presión](Pressure_Advance.md).

Puede ser necesario el realizar otros tipos de calibración detallada de la impresora - un número de guías están disponibles en línea para ayudar con esto (por ejemplo, realice una búsqueda web de "calibración de impresora 3d"). Como un ejemplo, si experimenta el efecto llamado "ringing", puede probar seguir la guía de ajuste de la [Compensación de Resonancia](Resonance_Compensation.md).
