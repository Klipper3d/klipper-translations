# Configuration checks

Dit document bevat een lijst met stappen om de pin-instellingen in printer.cfg te bevestigen. Het is belangrijk om deze stappen door te lopen in het [installatiedocument](Installation.md).

Tijdens het volgen van deze handleiding zijn mogelijk wijzigingen in het configuratiebestand nodig. Zorg ervoor dat u na elke wijzigingen een HERSTART-commando geeft om wijzigingen door te voeren (of type "restart" in de Octoprint-terminal en klik op "Send"). Het is handig om na elke herstart een STATUS-commando te geven om te zien of wijzigingen zijn doorgevoerd.

## Controleer temperatuur

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Controleer M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Controleer verwarming elementen

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Als de printer een verwarmd bed heeft doe de bovenstaande test opnieuw met het bed.

## Controleer stappenmotor ingeschakeld pin

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Controleer eindstoppen

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!PA2"), or remove the "!" if there is already one present.

If the endstop does not change at all then it generally indicates that the endstop is connected to a different pin. However, it may also require a change to the pullup setting of the pin (the '^' at the start of the endstop_pin name - most printers will use a pullup resistor and the '^' should be present).

## Verifieer stappenmotors

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

If the stepper does not move at all, then verify the "enable_pin" and "step_pin" settings for the stepper. If the stepper motor moves but does not return to its original position then verify the "dir_pin" setting. If the stepper motor oscillates in an incorrect direction, then it generally indicates that the "dir_pin" for the axis needs to be inverted. This is done by adding a '!' to the "dir_pin" in the printer config file (or removing it if one is already there). If the motor moves significantly more or significantly less than one millimeter then verify the "rotation_distance" setting.

Draai de voorgaande test voor elke stappenmotor zoals gedefinieerd in het configuratiebestand. (Stel de STEPPER-parameters van het STEPPER_BUZZ-commando in op de naam zoals gebruikt in het configuratiebestand.) Als er geen filament geladen is, kan STEPPER_BUZZ ook gebruikt worden voor de extrudermotor (gebruik STEPPER=extruder). Test anders de extrudermotor afzonderlijk (zie de volgende sectie).

Na het verifiëren van alle eindstops en het controleren van alle steppermotoren, moet het homingmechanisme worden getest. Geef een G28-opdracht om alle assen te home. Verwijder de stroom van de printer als het niet correct homet. Voer indien nodig de verificatiestappen voor de eindstops en steppermotoren opnieuw uit.

## Verifieer extrudermotor

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Kalibreer PID-instellingen

Klipper supports [PID control](https://en.wikipedia.org/wiki/PID_controller) for the extruder and bed heaters. In order to use this control mechanism, it is necessary to calibrate the PID settings on each printer (PID settings found in other firmwares or in the example configuration files often work poorly).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

Draai `SAVE_CONFIG` na het afronden van de tuning test om printer.cfg te updaten naar de nieuwe PID-instellingen.

If the printer has a heated bed and it supports being driven by PWM (Pulse Width Modulation) then it is recommended to use PID control for the bed. (When the bed heater is controlled using the PID algorithm it may turn on and off ten times a second, which may not be suitable for heaters using a mechanical switch.) A typical bed PID calibration command is: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Volgende stappen

This guide is intended to help with basic verification of pin settings in the Klipper configuration file. Be sure to read the [bed leveling](Bed_Level.md) guide. Also see the [Slicers](Slicers.md) document for information on configuring a slicer with Klipper.

After one has verified that basic printing works, it is a good idea to consider calibrating [pressure advance](Pressure_Advance.md).

It may be necessary to perform other types of detailed printer calibration - a number of guides are available online to help with this (for example, do a web search for "3d printer calibration"). As an example, if you experience the effect called ringing, you may try following [resonance compensation](Resonance_Compensation.md) tuning guide.
