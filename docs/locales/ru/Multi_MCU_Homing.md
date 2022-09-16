# Самонаведение и зондирование с несколькими микроконтроллерами

Klipper поддерживает механизм самонаведения с концевым упором, подключенным к одному микроконтроллеру, в то время как его шаговые двигатели подключены к другому микроконтроллеру. Эта поддержка называется "самонаведением с несколькими микроконтроллерами". Эта функция также используется, когда Z-зонд находится на другом микроконтроллере, чем Z-шаговые двигатели.

Эта функция может быть полезна для упрощения подключения, так как может быть удобнее присоединить концевой упор или зонд к более близкому микроконтроллеру. Однако использование этой функции может привести к "перерегулированию" шаговых двигателей во время операций наведения и зондирования.

Превышение происходит из-за возможных задержек передачи сообщений между микроконтроллером, контролирующим конечный упор, и микроконтроллерами, приводящими в движение шаговые двигатели. Код Клиппера предназначен для ограничения этой задержки не более чем на 25 мс. (Когда активировано самонаведение с несколькими микроконтроллерами, микроконтроллеры периодически отправляют сообщения о состоянии и проверяют, что соответствующие сообщения о состоянии получены в течение 25 мс.)

So, for example, if homing at 10mm/s then it is possible for an overshoot of up to 0.250mm (10mm/s * .025s == 0.250mm). Care should be taken when configuring multi-mcu homing to account for this type of overshoot. Using slower homing or probing speeds can reduce the overshoot.

Stepper motor overshoot should not adversely impact the precision of the homing and probing procedure. The Klipper code will detect the overshoot and account for it in its calculations. However, it is important that the hardware design is capable of handling overshoot without causing damage to the machine.

Should Klipper detect a communication issue between micro-controllers during multi-mcu homing then it will raise a "Communication timeout during homing" error.

Note that an axis with multiple steppers (eg, `stepper_z` and `stepper_z1`) need to be on the same micro-controller in order to use multi-mcu homing. For example, if an endstop is on a separate micro-controller from `stepper_z` then `stepper_z1` must be on the same micro-controller as `stepper_z`.
