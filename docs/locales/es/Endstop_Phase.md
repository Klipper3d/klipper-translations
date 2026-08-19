# Fase final

Este documento describe como usa klipper el sistema de finales de carrera por medio de la fase del motor paso a paso. Esta funcionalidad puede mejorar la precisión de los finales de carrera tradicionales. Es más útil cuando se utiliza un controlador de motor paso a paso Trinamic que tiene configuración en tiempo de ejecución.

Un interruptor de fin de carrera típico tiene una precisión de alrededor de 100 micras. (Cada vez que un eje se posiciona en su origen, el interruptor puede activarse ligeramente antes o ligeramente después). Aunque se trata de un error relativamente pequeño, puede dar lugar a artefactos no deseados. En particular, esta desviación posicional puede ser notable al imprimir la primera capa de un objeto. Por el contrario, los motores paso a paso típicos pueden obtener una precisión significativamente mayor.

El mecanismo de fin de carrera ajustado por fases del motor paso a paso puede utilizar la precisión de los motores paso a paso para mejorar la precisión de los interruptores de fin de carrera. Un motor paso a paso se mueve recorriendo una serie de fases hasta completar cuatro «pasos completos». Por lo tanto, un motor paso a paso que utilice 16 micropasos tendría 64 fases y, al moverse en dirección positiva, recorrería las fases: 0, 1, 2, ... 61, 62, 63, 0, 1, 2, etc. Es fundamental que, cuando el motor paso a paso se encuentre en una posición determinada en un raíl lineal, siempre esté en la misma fase del motor paso a paso. Por lo tanto, cuando un carro activa el interruptor de fin de carrera, el motor paso a paso que controla ese carro siempre debe estar en la misma fase del motor paso a paso. El sistema de fase de fin de carrera de Klipper combina la fase del motor paso a paso con el activador de fin de carrera para mejorar la precisión del fin de carrera.

Para poder utilizar esta funcionalidad, es necesario poder identificar la fase del motor paso a paso. Si se utilizan controladores Trinamic TMC2130, TMC2208, TMC2224 o TMC2660 en modo de configuración en tiempo de ejecución (es decir, no en modo autónomo), Klipper puede consultar la fase del motor paso a paso desde el controlador. (También es posible utilizar este sistema en controladores de motores paso a paso tradicionales si se pueden reiniciar de forma fiable los controladores de motores paso a paso; consulte más abajo para obtener más detalles).

## Calibración de las fases de fin de carrera

Si se utilizan controladores de motor paso a paso Trinamic con configuración en tiempo de ejecución, se pueden calibrar las fases de fin de carrera utilizando el comando ENDSTOP_PHASE_CALIBRATE. Comience añadiendo lo siguiente al archivo de configuración:

```
[endstop_phase]
```

Then RESTART the printer and run a `G28` command followed by an `ENDSTOP_PHASE_CALIBRATE` command. Then move the toolhead to a new location and run `G28` again. Try moving the toolhead to several different locations and rerun `G28` from each position. Run at least five `G28` commands.

After performing the above, the `ENDSTOP_PHASE_CALIBRATE` command will often report the same (or nearly the same) phase for the stepper. This phase can be saved in the config file so that all future G28 commands use that phase. (So, in future homing operations, Klipper will obtain the same position even if the endstop triggers a little earlier or a little later.)

To save the endstop phase for a particular stepper motor, run something like the following:

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Run the above for all the steppers one wishes to save. Typically, one would use this on stepper_z for cartesian and corexy printers, and for stepper_a, stepper_b, and stepper_c on delta printers. Finally, run the following to update the configuration file with the data:

```
SAVE_CONFIG
```

### Additional notes

* This feature is most useful on delta printers and on the Z endstop of cartesian/corexy printers. It is possible to use this feature on the XY endstops of cartesian printers, but that isn't particularly useful as a minor error in X/Y endstop position is unlikely to impact print quality. It is not valid to use this feature on the XY endstops of corexy printers (as the XY position is not determined by a single stepper on corexy kinematics). It is not valid to use this feature on a printer using a "probe:z_virtual_endstop" Z endstop (as the stepper phase is only stable if the endstop is at a static location on a rail).
* After calibrating the endstop phase, if the endstop is later moved or adjusted then it will be necessary to recalibrate the endstop. Remove the calibration data from the config file and rerun the steps above.
* In order to use this system the endstop must be accurate enough to identify the stepper position within two "full steps". So, for example, if a stepper is using 16 micro-steps with a step distance of 0.005mm then the endstop must have an accuracy of at least 0.160mm. If one gets "Endstop stepper_z incorrect phase" type error messages than in may be due to an endstop that is not sufficiently accurate. If recalibration does not help then disable endstop phase adjustments by removing them from the config file.
* If one is using a traditional stepper controlled Z axis (as on a cartesian or corexy printer) along with traditional bed leveling screws then it is also possible to use this system to arrange for each print layer to be performed on a "full step" boundary. To enable this feature be sure the G-Code slicer is configured with a layer height that is a multiple of a "full step", manually enable the endstop_align_zero option in the endstop_phase config section (see [config reference](Config_Reference.md#endstop_phase) for further details), and then re-level the bed screws.
* It is possible to use this system with traditional (non-Trinamic) stepper motor drivers. However, doing this requires making sure that the stepper motor drivers are reset every time the micro-controller is reset. (If the two are always reset together then Klipper can determine the stepper phase by tracking the total number of steps it has commanded the stepper to move.) Currently, the only way to do this reliably is if both the micro-controller and stepper motor drivers are powered solely from USB and that USB power is provided from a host running on a Raspberry Pi. In this situation one can specify an mcu config with "restart_method: rpi_usb" - that option will arrange for the micro-controller to always be reset via a USB power reset, which would arrange for both the micro-controller and stepper motor drivers to be reset together. If using this mechanism, one would then need to manually configure the "trigger_phase" config sections (see [config reference](Config_Reference.md#endstop_phase) for the details).
