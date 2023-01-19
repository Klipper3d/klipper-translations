# Liczne mikrokontrolery Homing i Probing

Klipper wspiera mechanizm homingu z endstopem podłączonym do jednego mikrokontrolera, podczas gdy jego silniki krokowe są na innym mikrokontrolerze. Ta obsługa jest określana jako "multi-mcu homing". Funkcja ta jest również wykorzystywana, gdy sonda Z znajduje się na innym mikrokontrolerze niż silniki krokowe Z.

Funkcja ta może być przydatna do uproszczenia okablowania, ponieważ wygodniejsze może być dołączenie ogranicznika krańcowego lub sondy do bliższego mikrokontrolera. Jednakże użycie tej funkcji może spowodować "przesterowanie" silników krokowych podczas operacji naprowadzania i sondowania.

The overshoot occurs due to possible message transmission delays between the micro-controller monitoring the endstop and the micro-controllers moving the stepper motors. The Klipper code is designed to limit this delay to no more than 25ms. (When multi-mcu homing is activated, the micro-controllers send periodic status messages and check that corresponding status messages are received within 25ms.)

Tak więc, na przykład, jeśli naprowadzanie odbywa się z prędkością 10mm/s, możliwe jest przekroczenie zakresu do 0.250mm (10mm/s * .025s == 0.250mm). Należy zachować ostrożność podczas konfigurowania naprowadzania za pomocą wielu modułów, aby uwzględnić ten rodzaj przekroczenia. Użycie wolniejszych prędkości naprowadzania lub sondowania może zredukować przekroczenie prędkości.

Stepper motor overshoot should not adversely impact the precision of the homing and probing procedure. The Klipper code will detect the overshoot and account for it in its calculations. However, it is important that the hardware design is capable of handling overshoot without causing damage to the machine.

Should Klipper detect a communication issue between micro-controllers during multi-mcu homing then it will raise a "Communication timeout during homing" error.

Note that an axis with multiple steppers (eg, `stepper_z` and `stepper_z1`) need to be on the same micro-controller in order to use multi-mcu homing. For example, if an endstop is on a separate micro-controller from `stepper_z` then `stepper_z1` must be on the same micro-controller as `stepper_z`.
