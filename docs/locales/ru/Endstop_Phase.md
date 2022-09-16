# Фаза Endstop

В этом документе описывается система концевого упора Klipper с регулировкой ступенчатой фазы. Эта функциональность может повысить точность традиционных конечных выключателей. Это наиболее полезно при использовании драйвера шагового двигателя Trinamic, который имеет конфигурацию во время выполнения.

Типичный концевой выключатель имеет точность около 100 микрон. (Каждый раз, когда ось устанавливается на место, переключатель может срабатывать немного раньше или немного позже.) Хотя это относительно небольшая ошибка, она может привести к нежелательным артефактам. В частности, это позиционное отклонение может быть заметно при печати первого слоя объекта. В отличие от этого, обычные шаговые двигатели могут обеспечить значительно более высокую точность.

Механизм концевого выключателя с регулируемой фазой шага может использовать точность шаговых двигателей для повышения точности концевых выключателей. Шаговый двигатель движется циклически через ряд фаз, пока не завершит четыре "полных шага". Таким образом, шаговый двигатель, использующий 16 микрошагов, будет иметь 64 фазы, и при движении в положительном направлении он будет циклически проходить через фазы: 0, 1, 2, ... 61, 62, 63, 0, 1, 2, и т.д. Важно отметить, что когда шаговый двигатель находится в определенном положении на линейном рельсе, он всегда должен находиться в одной и той же фазе шага. Таким образом, когда каретка приводит в действие концевой выключатель, шаговый двигатель, управляющий этой кареткой, всегда должен находиться в одной и той же фазе шагового двигателя. Система endstop phase от Klipper сочетает в себе шаговую фазу с триггером endstop для повышения точности endstop.

Для того, чтобы использовать эту функциональность, необходимо иметь возможность идентифицировать фазу шагового двигателя. Если кто-то использует драйверы Trinamic TMC2130, TMC2208, TMC2224 или TMC2660 в режиме конфигурации во время выполнения (т.Е. не в автономном режиме), то Klipper может запросить шаговую фазу у драйвера. (Также возможно использовать эту систему на традиционных шаговых драйверах, если можно надежно сбросить шаговые драйверы - подробности см. Ниже.)

## Calibrating endstop phases

If using Trinamic stepper motor drivers with run-time configuration then one can calibrate the endstop phases using the ENDSTOP_PHASE_CALIBRATE command. Start by adding the following to the config file:

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
