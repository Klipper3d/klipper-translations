# Homing und Probing mit mehreren Mikrocontrollern

Klipper unterstützt einen Mechanismus für das Homen mit einem Endstopp, welcher an einen Mikrocontroller angeschlossen ist, während die Steppermotoren an einen anderen Mikrocontroller angeschlossen sind. Diese Unterstützung wird "multi-mcu homing" genannt. Dieses Feature wird ebenfalls benutzt, wenn eine Z-Sonde an einem anderen Mikrocontroller angeschlossen ist, als die dazugehörigen Z-Steppermotoren.

Dieses Feature kann zur Vereinfachung der Verkabelung nützlich sein, da es einfacher sein könnte, einen Endstopp oder eine Sonde an einen näheren Mikrocontroller anzuschließen. Dieses Feature kann allerdings zum "overshoot" der Steppermotoren beim Homing und Probing führen.

Der "overshoot" wird ausgelöst durch die eventuelle Verzögerung der Nachrichtenübertragung zwischen dem überwachenden Mikrocontroller und dem Mikrocontroller, welcher die Steppermotoren antreibt. Der Klipper-Code ist so entworfen, dass diese Verzögerung auf maximal 25ms reduziert wird. (Wenn Multi-MCU Homing aktiviert ist, sendet der Mikrocontroller periodische Statusnachrichten und prüft, dass diese innerhalb von 25ms empfangen werden.)

So, for example, if homing at 10mm/s then it is possible for an overshoot of up to 0.250mm (10mm/s * .025s == 0.250mm). Care should be taken when configuring multi-mcu homing to account for this type of overshoot. Using slower homing or probing speeds can reduce the overshoot.

Stepper motor overshoot should not adversely impact the precision of the homing and probing procedure. The Klipper code will detect the overshoot and account for it in its calculations. However, it is important that the hardware design is capable of handling overshoot without causing damage to the machine.

Should Klipper detect a communication issue between micro-controllers during multi-mcu homing then it will raise a "Communication timeout during homing" error.

Note that an axis with multiple steppers (eg, `stepper_z` and `stepper_z1`) need to be on the same micro-controller in order to use multi-mcu homing. For example, if an endstop is on a separate micro-controller from `stepper_z` then `stepper_z1` must be on the same micro-controller as `stepper_z`.
