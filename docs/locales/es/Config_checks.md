# Verificación de Configuración

Este documento contiene una lista con los pasos para configurar el pin del archivo Klipper printer.cfg. Se recomienda ejecutarlos una vez que se hayan terminado los pasos en [instalación documentos](installation.md).

A lo largo de esta guía puede ser necesario hacer cambios en el archivo config Klipper. Es importante ejecutar el comando RESTART después de cada cambio en el susodicho archivo para asegurar que los cambios han tenido efecto (escriba "restart" en la pestaña del terminal Octoprint y pulse "Send"). Se recomienda también usar el comando STATUS después de cada RESTART para verificar que este archivo se ha cargado correctamente.

## Verifique la temperatura

Comienza verificando que la temperatura se ha guardado correctamente. Navega a la pestaña de temperatura Octoprint.

![temperatura-octoprint](img/octoprint-temperature.png)

Verifique que la temperatura de la boquilla y la cama (si es necesario) están presentes y no están aumentando. Si están aumentando, desconecte la impresora. Si la temperatura no es exacta, revise los ajustes del "sensor_type" y del "sensor_pin" para la boquilla y/o cama.

## Verifica M112

Navegue a la pestaña con el terminal Octoprint and lance el comando M112. Este comando le pide a Klipper ir al estado "shutdown". Hará que Octoprint se desconecte de Klipper - navegue al área de conección y pulse en "Connect" para hacer que Octoprint se conecte. Después de esto, vaya de nuevo a la pestaña de temperatura de Octoprint y compruebe que la temperatura se sigue actualizando y no aumenta. Si la temperature incrementara, desconecte la impresora.

El comando M112 hace que Klipper se vaya al estado de "shutdown". Para salir de este estado, lance el comando FIRMWARE_RESTART en la pestaña con el terminal Octoprint.

## Verifique los calentadores

Abra la pestaña de la temperatura de octoprint y escriba 50 seguido de la tecla retorno en el recuadro de la temperatura "Tool". La temperatura de la extrusora en el gráfico debería incrementar (en un intervalo de 30 segundos). Después vaya al menú desplegable de "Tool" y seleccione "Off". La temperatura debería comenzar a disminuir a la temperatura ambiente trás unos minutos. Si la temperatura no incrementara revise los ajustes del "heater-pin" en el config.

Si la temperatura de la cama es también alta, haga el mismo test para la cama esta vez.

## Verifique el pin del motor de pasos

Verifique que los ejes de la impresora se pueden mover libremente (los motores de pasos están desactivados). Si no, lance el comando M84 para desactivar los motores. Si alguno de los ejes no puede moverse libremente, entonces verifique la configuración del "enable_pin" para el eje en cuestión. La mayoría de los drivers para motores de pasos tienen el pin enable en "active low" y por lo tanto el pin debería tener una "!" antes del pin (por ejemplo, "enable_pin:!ar38").

## Verifique el paro programado

Mueve todos los ejes de la impresora de manera que ninguno de ellos este en contacto con un interruptor de límite. Lanza el comando QUERY_ENDSTOPS usando la pestaña del terminal Octoprint. El terminal debería mostrar el estado actual de los interruptor de límite configurados y deberían tener el estado "open". Para cada uno de estos interruptores, ejecute el comando QUERY_ENDSTOP a la vez que fuerce el interruptor de límite manualmente. El comando QUERY_ENDSTOPS debería mostrar "TRIGGERED".

Si el final de carrera aparece invertido (reporta "abierto" cuando se acciona y vice-versa) entonces agregue un "!" a la definición del alfiler (por ejemplo "endstop_pin: ^!ar3"), o quite el "!" si ya se estaba presente.

Si el final de carrera no cambia en absoluto, entonces generalmente indica que el final de carrera está conectado a un alfiler diferente. Sin embargo, puede requerir también un cambio a la configuración del levantado del alfiler (el '^' al comienzo del nombre de endstop_pin - la mayoría de las impresoras usarán un resistor de levantado y el '^' debería estar presente).

## Verificar el motor a pasos

Use el comando STEPPER_BUZZ para verificar la conectividad de cada motor de pasos. Comience por posicionar manualmente el eje dado a un punto medio y entonces ejecute `STEPPER_BUZZ STEPPER=stepper_x`. El comando STEPPER_BUZZ causará que el motor a pasos dado se mueva un milímetro en una dirección positiva y después retornará a su posición inicial. (Si el final de carrera es definido en position_endstop=0 entonces al comienzo de cada movimiento el motor a pasos se alejará de el final de carrera.) Realizará esta oscilación diez veces.

Si el motor a pasos no se mueve en absoluto, entonces verifique las configuraciones de "enable_pin" y "step_pin" para el motor a pasos. Si el motor a pasos se mueve pero no regresa a su posición original entonces verifique la configuración de "dir_pin". Si el motor a pasos oscila en una dirección incorrecta, entonces generalmente indica que la "dir_pin" para un eje necesita ser invertida. Esto puede hacerse con agregar un '!' a la "dir_pin" en el archivo de configuración de la impresora (o quitándole si ya esta ahí). Si el motor se mueve significativamente más o significativamente menos que un milímetro entonces verifique la configuración "rotation_distance".

Ejecute el test anterior para cada motor a pasos definido en el archivo de configuración. (Establezca el parámetro STEPPER del comando STEPPER_BUZZ al nombre de la sección de configuración que va a ser evaluada.) Si no hay un filamento en el extrusor entonces uno puede usar STEPPER_BUZZ para verificar la conectividad del motor (use STEPPER=extruder). De otra forma, es mejor el evaluar el motor del extrusor separadamente (ver la próxima sección).

Después de verificar todos los finales de carrera y verificar todos los motores a pasos, el mecanismo de guiado al inicio debería ser evaluado. Envíe un comando G28 para enviar al inicio todos los ejes. Quite la alimentación de poder de la impresora si no se guían al inicio adecuadamente. Repita los pasos de verificación de finales de carrera y de los motores a pasos si es necesario.

## Verificar el motor del extrusor

Para probar el motor del extrusor será necesario el calentar el extrusor a una temperatura de impresión. Navegue hasta la pestaña de temperatura de Octoprint y seleccione una temperatura objetivo en el cuadro desplegable de temperatura (o ingrese manualmente una temperatura apropiada). Espere a que la impresora alcance la temperatura deseada. Entonces navegue hacia la pesaña de control Octoprint y haga clic en el botón "Extrude". Verifique que el motor del extrusor gira en la dirección correcta. Si no lo hace, vea las sugerencia de resolución de problemas en la sección anterior para confirmar las configuraciones de "enable_pin", "step_pin" y "dir_pin" para el extrusor.

## Calibrar las configuraciones de PID

Klipper soporta [control PID](https://en.wikipedia.org/wiki/PID_controller) para el extrusor y los calentadores de cama. Para usar este mecanismo de control es necesario el calibrar las configuraciones de PID en cada impresora. (Las configuraciones de PID que se encuentran en otros firmwares o en los archivos de configuración de ejemplo usualmente funcionan mal.)

Para calibrar el extrusor, navegue hasta la pestaña de terminal OctoPrint y ejecute el comando PID_CALIBRATE. Por ejemplo: `PID_CALIBRATE HEATER=extruder TARGET=170`

Cuando se complete la prueba de ajuste ejecute `SAVE_CONFIG` para actualizar el archivo printer.cfg con las nuevas configuraciones de PID.

Si la impresora está equipada con una cama de calefacción y soporta ser manejada por PWM (Modulación de Ancho de Pulsos) entonces es recomienda el usar control PID para la cama. (Cuando el calentador de cama es controlado usando el algoritmo PID, se puede prender y apagar diez veces por segundo, lo cual no puede ser adecuado para calentadores que utilicen un interruptor mecánico.) Un comando de calibración PID de cama típico es: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Pasos Siguientes

Esta guía pretende el ayudar con la verificación básica de las configuraciones del alfiler en el archivo de configuración de Klipper. Asegúrese de leer la guía de [nivelación de cama](Bed_Level.md). También vea el documento sobre [Rebanadores](Slicers.md) para información sobre el configurar un rebanador con Klipper.

Después de haber verificado que la impresión básica funciona, es una buena idea el considerar calibrar el [Avance de presión](Pressure_Advance.md).

Puede ser necesario el realizar otros tipos de calibración detallada de la impresora - un número de guías están disponibles en línea para ayudar con esto (por ejemplo, realice una búsqueda web de "calibración de impresora 3d"). Como un ejemplo, si experimenta el efecto llamado "ringing", puede probar seguir la guía de ajuste de la [Compensación de Resonancia](Resonance_Compensation.md).
