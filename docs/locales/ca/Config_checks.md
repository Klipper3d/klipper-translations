# Configuration checks

Aquest document conté una llista amb els passos per configurar el pin del fitxer Klipper printer.cfg. Es recomana executar-los un cop acabats els passos a [instal·lació documents](installation.md).

Al llarg d'aquesta guia pot ser necessari fer canvis al fitxer config Klipper. És important executar l'ordre RESTART després de cada canvi a l'arxiu esmentat per assegurar que els canvis han tingut efecte (escriviu "restart" a la pestanya del terminal Octoprint i premeu "Send"). Es recomana també utilitzar l'ordre STATUS després de cada RESTART per verificar que aquest fitxer s'ha carregat correctament.

## Verificar la temperatura

Comença verificant que la temperatura s'ha desat correctament. Navega a la pestanya de temperatura Octoprint.

![temperatura-octoprint](img/octoprint-temperature.png)

Verificar que la temperatura del fusor i el llit (si és aplicable ) són presents i no estan augmentant. Si augmenten, desconnecteu la impressora. Si la temperatura no és exacta, reviseu els ajustaments del "sensor_type" i del "sensor_pin" per al fusor i/o llit.

## Verificar M112

Navegar a la pestanya terminal de l’Octoprint i executar l'ordre M112 al camp de la terminal. Aquesta ordre fa que Klipper s’apagui i que l’Octoprint es desconnecti - navegar a l'àrea de connexió i fer clic a "Connect" per tal que Octoprint es connecti de nou. Després d'això, navegar de nou a la pestanya de temperatura d'Octoprint i comprovar que la temperatura segueix actualitzant-se i no augmenta. Si la temperatura augmenta, desconnecteu la impressora.

L’ordre M112 provoca que Klipper entri en un estat d’apagada. Per arreglar-ho, escriu l’ordre FIRMWARE_RESTART al la pestanya de terminal d’Octoprint

## Verificar els calentadors

Navegar fins la pestanya de temperatura de l’Octoprint i al camp corresponent a l’eina posar 50 seguit de la tecla de retorn. La gràfica de temperatura del fusor ha de començar a incrementar (en uns 30 segons aproximadament). Després, de la llista desplegable corresponent a l’eina, seleccionar l’opció “OFF”. Passats uns minuts, la temperatura ha de començar a tornar a la temperatura ambient. En cas que la temperatura no incrementi, verificar el valor de “heater_pin” al fitxer de configuració

Si la impressora disposa de llit calent, executa l’anterior comprovació amb el llit calent tambè.

## Verificar el pin ENABLE del motor pas a pas

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !ar38").

## Verify endstops

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the Octoprint terminal tab. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

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

Klipper supports [PID control](https://en.wikipedia.org/wiki/PID_controller) for the extruder and bed heaters. In order to use this control mechanism, it is necessary to calibrate the PID settings on each printer (PID settings found in other firmwares or in the example configuration files often work poorly).

To calibrate the extruder, navigate to the OctoPrint terminal tab and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

At the completion of the tuning test run `SAVE_CONFIG` to update the printer.cfg file the new PID settings.

If the printer has a heated bed and it supports being driven by PWM (Pulse Width Modulation) then it is recommended to use PID control for the bed. (When the bed heater is controlled using the PID algorithm it may turn on and off ten times a second, which may not be suitable for heaters using a mechanical switch.) A typical bed PID calibration command is: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Next steps

This guide is intended to help with basic verification of pin settings in the Klipper configuration file. Be sure to read the [bed leveling](Bed_Level.md) guide. Also see the [Slicers](Slicers.md) document for information on configuring a slicer with Klipper.

After one has verified that basic printing works, it is a good idea to consider calibrating [pressure advance](Pressure_Advance.md).

It may be necessary to perform other types of detailed printer calibration - a number of guides are available online to help with this (for example, do a web search for "3d printer calibration"). As an example, if you experience the effect called ringing, you may try following [resonance compensation](Resonance_Compensation.md) tuning guide.
