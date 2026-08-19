# Configuration checks

Ĉi tiu dokumento provizas liston de agoj por certigi ke la kejlodifinoj en la dosiero printer.cfg de Klipero taŭgas. Estas bona ideo sekvi ilin post plenumi la agojn en la [installation document](Installation.md).

Dum sekvi ĉi tun gvidilon, estus necesa ŝanĝi la dosieron de ĝustiĝoj de Klipero. Sendu la ordonon RESTART post ĉiu ŝanĝo al la ĝustiĝoj por certigi ke la ŝanĝoj efektiviĝu (tajpu "restart" en la terminalo de Octoprint kaj klaku "sendi"). Ankaŭ estas bona ideo fari la ordonon STATUS post RESTART por kontroli ĉu la dosiero de ĝustiĝoj estis sukcese ŝarĝita.

## Kontroli temperaturon

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Kontroli M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Kontroli varmilojn

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Se la presilo havas varmigatan platon, faru la saman provon denove je la platon.

## Kontroli la kejlon por ŝalti motoron

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Kontroli limŝaltilojn

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^!PA2"), or remove the "!" if there is already one present.

Se la limŝaltilo ne ŝanĝiĝas iel ajn, tio plej ofte indikas ke la limŝaltilo estas konektata al alia kejlo. Tamen tio ankaŭ povas postuli ĝustigi la tipon de rezistilo de la kejlo (la '^' antaŭ la nomo de la kejlo de limŝaltilo - la plejmulto da presiloj uzas rezistilon de tiro kaj la '^' necesas).

## Kontroli motorojn

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Se la motoro neniel movas, kontrolu "enable_pin" kaj "step_pin" por ĝi. Se la motoro movas, sed ne reiras al sia unua loko, kontrolu "dir_pin". Se la motoro movas male, tio signifas plej ofte ke "dir_pin" por tiu motor devas esti maligata. Tio estas farata per meti '!' antaŭ la kejlonomo en la dosiero de ĝustiĝoj (aŭ forigi ĝin se jam estas skribita). Se la motoro movas rimarkinde pli aŭ malpli ol unu milimetro, kontrolu "rotation_distance".

Faru la saman provon je ĉiu motoro en la difinata en la dokumento de ĝustiĝoj. (Skribu la ĝustan motoron post STEPPER je la ordono STEPPER_BUZZ laŭ kiel estas nomata.) Se ne estas filamento en la puŝilo, oni povas uzi STEPPER_BUZZ por provi ĝin (uzu STEPPER=extruder). Alimaniere, estas pli bona provi la motoron de la puŝilo aparte (jen la sekvanta sekcio).

After verifying all endstops and verifying all stepper motors the homing mechanism should be tested. Issue a G28 command to home all axes. Remove power from the printer if it does not home properly. Rerun the endstop and stepper motor verification steps if necessary.

## Verify extruder motor

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Calibrate PID settings

Klipper supports [PID control](https://en.wikipedia.org/wiki/PID_controller) for the extruder and bed heaters. In order to use this control mechanism, it is necessary to calibrate the PID settings on each printer (PID settings found in other firmwares or in the example configuration files often work poorly).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

At the completion of the tuning test run `SAVE_CONFIG` to update the printer.cfg file the new PID settings.

If the printer has a heated bed and it supports being driven by PWM (Pulse Width Modulation) then it is recommended to use PID control for the bed. (When the bed heater is controlled using the PID algorithm it may turn on and off ten times a second, which may not be suitable for heaters using a mechanical switch.) A typical bed PID calibration command is: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Next steps

This guide is intended to help with basic verification of pin settings in the Klipper configuration file. Be sure to read the [bed leveling](Bed_Level.md) guide. Also see the [Slicers](Slicers.md) document for information on configuring a slicer with Klipper.

After one has verified that basic printing works, it is a good idea to consider calibrating [pressure advance](Pressure_Advance.md).

It may be necessary to perform other types of detailed printer calibration - a number of guides are available online to help with this (for example, do a web search for "3d printer calibration"). As an example, if you experience the effect called ringing, you may try following [resonance compensation](Resonance_Compensation.md) tuning guide.
