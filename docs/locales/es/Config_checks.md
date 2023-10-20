# Verificación de Configuración

Este documento contiene una lista con los pasos para configurar el pin del archivo Klipper printer.cfg. Se recomienda ejecutarlos una vez que se hayan terminado los pasos en [instalación documentos](installation.md).

A lo largo de esta guía puede ser necesario hacer cambios en el archivo config Klipper. Es importante ejecutar el comando RESTART después de cada cambio en el susodicho archivo para asegurar que los cambios han tenido efecto (escriba "restart" en la pestaña del terminal Octoprint y pulse "Send"). Se recomienda también usar el comando STATUS después de cada RESTART para verificar que este archivo se ha cargado correctamente.

## Verifique la temperatura

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Verifica M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Verifique los calentadores

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Si la temperatura de la cama es también alta, haga el mismo test para la cama esta vez.

## Verifique el pin del motor de pasos

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Verifique el paro programado

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Si el final de carrera no cambia en absoluto, entonces generalmente indica que el final de carrera está conectado a un alfiler diferente. Sin embargo, puede requerir también un cambio a la configuración del levantado del alfiler (el '^' al comienzo del nombre de endstop_pin - la mayoría de las impresoras usarán un resistor de levantado y el '^' debería estar presente).

## Verificar el motor a pasos

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Si el motor a pasos no se mueve en absoluto, entonces verifique las configuraciones de "enable_pin" y "step_pin" para el motor a pasos. Si el motor a pasos se mueve pero no regresa a su posición original entonces verifique la configuración de "dir_pin". Si el motor a pasos oscila en una dirección incorrecta, entonces generalmente indica que la "dir_pin" para un eje necesita ser invertida. Esto puede hacerse con agregar un '!' a la "dir_pin" en el archivo de configuración de la impresora (o quitándole si ya esta ahí). Si el motor se mueve significativamente más o significativamente menos que un milímetro entonces verifique la configuración "rotation_distance".

Ejecute el test anterior para cada motor a pasos definido en el archivo de configuración. (Establezca el parámetro STEPPER del comando STEPPER_BUZZ al nombre de la sección de configuración que va a ser evaluada.) Si no hay un filamento en el extrusor entonces uno puede usar STEPPER_BUZZ para verificar la conectividad del motor (use STEPPER=extruder). De otra forma, es mejor el evaluar el motor del extrusor separadamente (ver la próxima sección).

Después de verificar todos los finales de carrera y verificar todos los motores a pasos, el mecanismo de guiado al inicio debería ser evaluado. Envíe un comando G28 para enviar al inicio todos los ejes. Quite la alimentación de poder de la impresora si no se guían al inicio adecuadamente. Repita los pasos de verificación de finales de carrera y de los motores a pasos si es necesario.

## Verificar el motor del extrusor

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Calibrar las configuraciones de PID

Klipper soporta [controladores PID](https://es.wikipedia.org/wiki/Controlador_PID) para el extrusor y calienta camas. Para usar este mecanismo de control, es necesario calibrar los ajustes PID en cada impresora (Los ajustes PID de otros firmwares y los de los archivos de configuracion de ejemplo trabajan pobremente).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

Cuando se complete la prueba de ajuste ejecute `SAVE_CONFIG` para actualizar el archivo printer.cfg con las nuevas configuraciones de PID.

Si la impresora está equipada con una cama de calefacción y soporta ser manejada por PWM (Modulación de Ancho de Pulsos) entonces es recomienda el usar control PID para la cama. (Cuando el calentador de cama es controlado usando el algoritmo PID, se puede prender y apagar diez veces por segundo, lo cual no puede ser adecuado para calentadores que utilicen un interruptor mecánico.) Un comando de calibración PID de cama típico es: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Pasos Siguientes

Esta guía pretende el ayudar con la verificación básica de las configuraciones del alfiler en el archivo de configuración de Klipper. Asegúrese de leer la guía de [nivelación de cama](Bed_Level.md). También vea el documento sobre [Rebanadores](Slicers.md) para información sobre el configurar un rebanador con Klipper.

Después de haber verificado que la impresión básica funciona, es una buena idea el considerar calibrar el [Avance de presión](Pressure_Advance.md).

Puede ser necesario el realizar otros tipos de calibración detallada de la impresora - un número de guías están disponibles en línea para ayudar con esto (por ejemplo, realice una búsqueda web de "calibración de impresora 3d"). Como un ejemplo, si experimenta el efecto llamado "ringing", puede probar seguir la guía de ajuste de la [Compensación de Resonancia](Resonance_Compensation.md).
