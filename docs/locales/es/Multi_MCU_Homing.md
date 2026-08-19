# Posicionamiento y sondeo con múltiples microcontroladores

Klipper admite un mecanismo para el retorno al origen con un final de carrera conectado a un microcontrolador, mientras que sus motores paso a paso se encuentran en un microcontrolador diferente. Esta compatibilidad se denomina «retorno al origen multimcu». Esta función también se utiliza cuando una sonda Z se encuentra en un microcontrolador diferente al de los motores paso a paso Z.

Esta función puede ser útil para simplificar el cableado, ya que puede resultar más conveniente conectar un final de carrera o una sonda a un microcontrolador más cercano. Sin embargo, el uso de esta función puede provocar un «exceso de velocidad(overshoot)» de los motores paso a paso durante las operaciones de retorno al origen y sondeo.

El sobrepasamiento se produce debido a posibles retrasos en la transmisión de mensajes entre el microcontrolador que supervisa el final de carrera y los microcontroladores que mueven los motores paso a paso. El código Klipper está diseñado para limitar este retraso a no más de 25 ms. (Cuando se activa el retorno al origen multi-mcu, los microcontroladores envían mensajes de estado periódicos y comprueban que los mensajes de estado correspondientes se reciben en un plazo de 25 ms).

Así, por ejemplo, si el retorno al origen se realiza a 10 mm/s, es posible que se produzca un sobreimpulso de hasta 0,250 mm (10 mm/s * 0,025 s == 0,250 mm). Se debe tener cuidado al configurar el retorno al origen con múltiples MCU para tener en cuenta este tipo de sobreimpulso. El uso de velocidades de retorno al origen o de sondeo más lentas puede reducir el sobreimpulso.

El sobreimpulso del motor paso a paso no debería afectar negativamente a la precisión del procedimiento de retorno al origen y sondeo. El código Klipper detectará el sobreimpulso y lo tendrá en cuenta en sus cálculos. Sin embargo, es importante que el diseño del hardware sea capaz de gestionar el sobreimpulso sin causar daños a la máquina.

In order to use this "multi-mcu homing" capability the hardware must have predictably low latency between the host computer and all of the micro-controllers. Typically the round-trip time must be consistently less than 10ms. High latency (even for short periods) is likely to result in homing failures.

Should high latency result in a failure (or if some other communication issue is detected) then Klipper will raise a "Communication timeout during homing" error.

Note that an axis with multiple steppers (eg, `stepper_z` and `stepper_z1`) need to be on the same micro-controller in order to use multi-mcu homing. For example, if an endstop is on a separate micro-controller from `stepper_z` then `stepper_z1` must be on the same micro-controller as `stepper_z`.
