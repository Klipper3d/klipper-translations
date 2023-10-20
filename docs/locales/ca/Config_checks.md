# Verificació de la configuració

Aquest document conté una llista amb els passos per configurar el pin del fitxer Klipper printer.cfg. Es recomana executar-los un cop acabats els passos a [instal·lació documents](installation.md).

Al llarg d'aquesta guia pot ser necessari fer canvis al fitxer config Klipper. És important executar l'ordre RESTART després de cada canvi a l'arxiu esmentat per assegurar que els canvis han tingut efecte (escriviu "restart" a la pestanya del terminal Octoprint i premeu "Send"). Es recomana també utilitzar l'ordre STATUS després de cada RESTART per verificar que aquest fitxer s'ha carregat correctament.

## Verificar la temperatura

Start by verifying that temperatures are being properly reported. Navigate to the temperature graph section in the user interface. Verify that the temperature of the nozzle and bed (if applicable) are present and not increasing. If it is increasing, remove power from the printer. If the temperatures are not accurate, review the "sensor_type" and "sensor_pin" settings for the nozzle and/or bed.

## Verificar M112

Navigate to the command console and issue an M112 command in the terminal box. This command requests Klipper to go into a "shutdown" state. It will cause an error to show, which can be cleared with a FIRMWARE_RESTART command in the command console. Octoprint will also require a reconnect. Then navigate to the temperature graph section and verify that temperatures continue to update and the temperatures are not increasing. If temperatures are increasing, remove power from the printer.

## Verificar els calentadors

Navigate to the temperature graph section and type in 50 followed by enter in the extruder/tool temperature box. The extruder temperature in the graph should start to increase (within about 30 seconds or so). Then go to the extruder temperature drop-down box and select "Off". After several minutes the temperature should start to return to its initial room temperature value. If the temperature does not increase then verify the "heater_pin" setting in the config.

Si la impressora disposa de llit calent, executa l’anterior comprovació amb el llit calent tambè.

## Verificar el pin ENABLE del motor pas a pas

Verify that all of the printer axes can manually move freely (the stepper motors are disabled). If not, issue an M84 command to disable the motors. If any of the axes still can not move freely, then verify the stepper "enable_pin" configuration for the given axis. On most commodity stepper motor drivers, the motor enable pin is "active low" and therefore the enable pin should have a "!" before the pin (for example, "enable_pin: !PA1").

## Verificar els finals de carrera

Manually move all the printer axes so that none of them are in contact with an endstop. Send a QUERY_ENDSTOPS command via the command console. It should respond with the current state of all of the configured endstops and they should all report a state of "open". For each of the endstops, rerun the QUERY_ENDSTOPS command while manually triggering the endstop. The QUERY_ENDSTOPS command should report the endstop as "TRIGGERED".

If the endstop appears inverted (it reports "open" when triggered and vice-versa) then add a "!" to the pin definition (for example, "endstop_pin: ^PA2"), or remove the "!" if there is already one present.

Si l’estat del sensor no canvia mai, normalment indica que el sensor donat s’ha connectat a un altre pin. Tant mateix , cal tenir present que moltes impressores fan servir una resistència “pullup” que implica que el valor de endstop_pin ha d’estar precedit pel caràcter ‘^' per canviar el valor d’aquest paràmetre.

## Verificar els motors pas a pas

Use the STEPPER_BUZZ command to verify the connectivity of each stepper motor. Start by manually positioning the given axis to a midway point and then run `STEPPER_BUZZ STEPPER=stepper_x` in the command console. The STEPPER_BUZZ command will cause the given stepper to move one millimeter in a positive direction and then it will return to its starting position. (If the endstop is defined at position_endstop=0 then at the start of each movement the stepper will move away from the endstop.) It will perform this oscillation ten times.

Si el motor no es belluga res, verificar els valors de "enable_pin" i "step_pin" per a aquest motor. Si el motor es belluga però no retorna a la posició inicial, verificar el calor de "dir_pin". Si el motor oscil·la en una direcció incorrecta, generalment indicarà que el valor de "dir_pin" per a aquest axis està invertit. Per a això afegir "!" al valor de "dir_pin" o remoure'l en cas que hi sigui.

Si el motor no mostra cap activitat, verificar que la configuració de “enable_pin” i “step_pin” siguin els correctes per al motor. En cas que el motor es mogui però no retorni s la seva posició inicial, verificar la configuració del paràmetre “dir_pin”. Si el motor oscil·la en direccions incorrectes, indicarà que s’ha de canviar el valor de “dir_pin” per invertir el sentit de l’eix. Per això s’ha d’afegir, o suprimir en cas que hi sigui, el modificador “!” a l’inici del valor del pin. En el cas que el motor es mogui més d’1mm o menys mogui per excés o per defecte d’una forma significant, s’haurà de revisar el valor del paràmetre “rotation_distance”.

Despeés d’haver verificat el bon funcionament dels sensors de final de carrera i dels motors s’ha de verificar el mecanisme d’anada a l’inici (homing). Per això, enviar el comandament G28 per inicialitzar tots els eixos. En cas que la seqüència no s’inicïi correctament, desendollar el corrent de la impressora. Tornar a verificar els sensors de final de carrera i el moviment dels motors si és necessari.

## Verificar el motor de l’extrussor

To test the extruder motor it will be necessary to heat the extruder to a printing temperature. Navigate to the temperature graph section and select a target temperature from the temperature drop-down box (or manually enter an appropriate temperature). Wait for the printer to reach the desired temperature. Then navigate to the command console and click the "Extrude" button. Verify that the extruder motor turns in the correct direction. If it does not, see the troubleshooting tips in the previous section to confirm the "enable_pin", "step_pin", and "dir_pin" settings for the extruder.

## Calibrar les configuracions del PID

Klipper suporta [controladores PID](https://ca.wikipedia.org/wiki/Proporcional_integral_derivatiu) per al fusor i el llit calent. Per tal de poder fer servir aquest algoritme és necessari calibrar els valors PID de cada impressora (valors PID trobats a altres firmware o a les configuracions d'exemple solen donar resultats molt pobres).

To calibrate the extruder, navigate to the command console and run the PID_CALIBRATE command. For example: `PID_CALIBRATE HEATER=extruder TARGET=170`

En acabar el procés de calibració envia el comandament `SAVE_CONFIG` per actualitzar el fitxer printer.cfg amb els nous valors de PID.

Si la impressora disposa de llit calent i permet ser governat mitjançant PWM (Modulació d'amplada de pulsos) aleshores es recomana fer servir el control PID per al llit calent. (Quan el llit calent s'acciona mitjançant l'algoritme PID pot ser que s'activi i desactivi el corrent 10 cops per segon, cosa. la qual no pot ser suportada per escalfadors connectats a un relé mecànic.) Un comandament típic per a fer el calibratge del llit calent sol ser: `PID_CALIBRATE HEATER=heater_bed TARGET=60`

## Següents passos

La intenció d'aquesta guia és ajudar a verificar que la assignació de pins al fitxer de configuració del Klipper és correcte. S'ha de llegir també la guia [Nivellar el llit](Bed_Level.md). Llegir també la guia [Slicers](Slicers.md) per entendre com configurar el programa de llescat amb el Klipper.

Després de verificar que la impressió bàsica funciona correctament, és una bona idea el fet de considerar de calibrar [Previsió de pressió](Pressure_Advance.md).

Pot ser necessari haver de fer altres tipus de ajustaments més detallats - hi ha disponibles en línia una serie de guies per abordar aquests aspectes (com a exemple, cercar "calibrar impressora 3d"). Per exemple, si es presenta l'efecte 'ringing' (repetició) a les peces impreses, pots triar de seguir la guia [Compensació de ressonància](Resonance_Compensation.md) per ajustar els paràmetres necessaris.
