# Configuration checks

Este documento contiene una lista con los pasos para configurar el pin del archivo Klipper printer.cfg. Se recomienda ejecutarlos una vez que se hayan terminado los pasos en [instalación documentos](installation.md).

A lo largo de esta guía puede ser necesario hacer cambios en el archivo config Klipper. Es importante ejecutar el comando RESTART después de cada cambio en el susodicho archivo para asegurar que los cambios han tenido efecto (escriba "restart" en la pestaña del terminal Octoprint y pulse "Send"). Se recomienda también usar el comando STATUS después de cada RESTART para verificar que este archivo se ha cargado correctamente.

## Verifique la temperatura

Comienza verificando que la temperatura se ha guardado correctamente. Navega a la pestaña de temperatura Octoprint.

![octoprint-temperature](img/octoprint-temperature.png)

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

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!ar3"), or remove the "!" if there is already one present.

If the endstop does not change at all then it generally indicates that the endstop is connected to a different pin. However, it may also require a change to the pullup setting of the pin (the '^' at the start of the endstop_pin name - most printers will use a pullup resistor and the '^' should be present).

## Verify stepper motors

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x`. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

If the stepper does not move at all, then verify the "enable_pin" and "step_pin" settings for the stepper. If the stepper motor moves but does not return to its original position then verify the "dir_pin" setting. If the stepper motor oscillates in an incorrect direction, then it generally indicates that the "dir_pin" for the axis needs to be inverted. This is done by adding a '!' to the "dir_pin" in the printer config file (or removing it if one is already there). If the motor moves significantly more or significantly less than one millimeter then verify the "rotation_distance" setting.

Run the above test for each stepper motor defined in the config file. (Set the STEPPER parameter of the STEPPER_BUZZ command to the name of the config section that is to be tested.) If there is no filament in the extruder then one can use STEPPER_BUZZ to verify the extruder motor connectivity (use STEPPER=extruder). Otherwise, it's best to test the extruder motor separately (see the next section).

After verifying all endstops and verifying all stepper motors the homing mechanism should be tested. Issue a G28 command to home all axes. Remove power from the printer if it does not home properly. Rerun the endstop and stepper motor verification steps if necessary.

## Verify extruder motor

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the Octoprint temperature tab and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the Octoprint control tab and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Calibrate PID settings

Klipper supports [PID control](https://en.wikipedia.org/wiki/PID_controller) for the extruder and bed heaters. In order to use this control mechanism it is necessary to calibrate the PID settings on each printer. (PID settings found in other firmwares or in the example configuration files often work poorly.)

To calibrate the extruder, navigate to the OctoPrint terminal tab and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

At the completion of the tuning test run `SAVE_CONFIG` to update the printer.cfg file the new PID settings.

If the printer has a heated bed and it supports being driven by PWM (Pulse Width Modulation) then it is recommended to use PID control for the bed. (When the bed heater is controlled using the PID algorithm it may turn on and off ten times a second, which may not be suitable for heaters using a mechanical switch.) A typical bed PID calibration command is: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Next steps

This guide is intended to help with basic verification of pin settings in the Klipper configuration file. Be sure to read the [bed leveling](Bed_Level.md) guide. Also see the [Slicers](Slicers.md) document for information on configuring a slicer with Klipper.

After one has verified that basic printing works, it is a good idea to consider calibrating [pressure advance](Pressure_Advance.md).

It may be necessary to perform other types of detailed printer calibration - a number of guides are available online to help with this (for example, do a web search for "3d printer calibration"). As an example, if you experience the effect called ringing, you may try following [resonance compensation](Resonance_Compensation.md) tuning guide.
