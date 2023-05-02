# Frequently Asked Questions

## ¿Cómo puedo donar al proyecto?

Thank you for your support. See the [Sponsors page](Sponsors.md) for information.

## ¿Cómo calculo el parámetro de configuración rotation_distance?

Ojee el [documento sobre la distancia de rotación](Rotation_Distance.md).

## ¿Dónde está mi puerto serial?

La principal manera de encontrar un puerto serial USB es ejecutar `ls /dev/serial/by-id/*`desde una terminal ssh en la máquina inquilina. Seguramente devuelva lo siguiente por pantalla:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

El nombre devuelto por el comando anterior es estable y es posible utilizarlo en el fichero de configuración y mientras se flashee el código del microcontrolador. Por ejemplo, un comando de flasheo posiblemente parezca similar a esto:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

y la configuración actualizada luciría así:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Asegúrate de copiar y pegar el nombre desde el comando "ls" que has ejecutado antes ya que el nombre será diferente para cada impresora.

Si estás usando múltiples microcontroladores y no tiene identificadores únicos (común en placas con chips CH340 USB) entonces sigue las indicaciones de arriba utilizando el comando `ls /dev/serial/by-path/*`en este caso.

## Cuando el microcontrolador se reinicia el dispositivo cambia a /dev/ttyUSB1

Sigue las indicaciones en la sección "[¿Dónde está mi puerto serial?](#wheres-my-serial-port)" para evitar que esto ocurra.

## El comando "make flash" no funciona

El código intenta «flashear» el dispositivo utilizando el método más común para cada plataforma. Desafortunadamente, hay un bastante disparidad entre métodos, así que el comando "make flash" puedo no funcionar en todas las placas.

Si está experimentando un fallo intermitente o tiene una configuración estándar, debe asegurarse de comprobar que Klipper no esté ejecutándose cuando se actualice(sudo service klipper stop), asegúrese de que OctoPrint no esté intentando conectarse directamente al dispositivo ( abra la pestaña de Conexión en la página web y haga click en Desconectar si el puerto serie está configurado en el dispositivo), y asegúrese de que FLASH_DEVICE esté correctamente configurado para su placa(vea [pregunta anterior](#wheres·my·serial·port)).

Sin embargo, si "make flash" no funciona para su placa, necesitará flashearla manualmente. Mire si existe un archivo de configuración en el [directorio de configuracion](../config) con instrucciones específicas para flashear el dispositivo. Compruebe también la documentación del fabricante de la placa para ver si describe como flashear el dispositivo. Por último, puede intentar flashear manualmente el dispositivo utilizando herramientas como "avrdude" o "bossac" · revise el [documento del bootloader](Bootloaders.md) para obtener información adicional.

## ¿Cómo cambio la tasa de baudios del puerto de serie?

La tasa de baudios recomendada para Klipper es 250000. Ésta tasa funciona bien con todas las placas con microcontroladores que Klipper soporta. Si ha encontrado una guía online que recomienda una tasa de baudios diferente, entonces ignore esta parte the la guía y continúe con la tasa por defecto de 250000.

Si desea cambiar la velocidad en baudios de todos modos, entonces la nueva velocidad tendrá que ser configurada en el micro-controlador (durante **make menuconfig**) y ese código actualizado tendrá que ser compilado y flasheado al microcontrolador. El archivo Klipper printer.cfg también necesitará ser actualizado para que coincida con esa tasa de baudios (ver la [referencia de configuración](Config_Reference.md#mcu) para más detalles). Por ejemplo:

```
[mcu]
baud: 250000
```

La tasa de baudios mostrada en la página web de OctoPrint no tiene ningún impacto en la tasa de baudios interna del microcontrolador Klipper. Ajuste siempre la velocidad en baudios de OctoPrint a 250000 cuando utilice Klipper.

La tasa de baudios del micro-controlador Klipper no está relacionada con la tasa de baudios del gestor de arranque del microcontrolador. Consulte el [documento del gestor de arranque](Bootloaders.md) para obtener información adicional sobre los gestores de arranque.

## ¿Puedo ejecutar Klipper en algo distinto a una Raspberry Pi 3?

El hardware recomendado son las Raspberry Pi 2, Raspberry Pi 3 y Raspberry Pi 4.

Klipper es capaz de ejecutarse en una Raspberry Pi 1 y en la Raspberry Pi Zero, pero este tipo de placas no tienen el suficiente poder de cómputo como para ejecutar OctoPrint correctamente. Es común que las impresiones se detenga en máquinas más lentas cuando se imprime directamente desde OctoPrint. (La impresora podría moverse más rápido de lo que OctoPrint sería capaz de enviar los comandos de movimiento.) Si deseas ejecutarlo en uno de estos dispositivos igualmente, considera utilizar la característica «virtual_sdcard» cuando imprimas (ver la [configuración de referencia](Config_Reference.md#virtual_sdcard) para más detalles).

For running on the Beaglebone, see the [Beaglebone specific installation instructions](Beaglebone.md).

Klipper has been run on other machines. The Klipper host software only requires Python running on a Linux (or similar) computer. However, if you wish to run it on a different machine you will need Linux admin knowledge to install the system prerequisites for that particular machine. See the [install-octopi.sh](../scripts/install-octopi.sh) script for further information on the necessary Linux admin steps.

Si desea ejecutar el software anfitrión Klipper en un chip de gama baja, tenga en cuenta que, como mínimo, se requiere una máquina con hardware de "coma flotante de doble precisión".

Si desea ejecutar Klipper en un ordenador de sobremesa o servidor compartido, tenga en cuenta que Klipper tiene algunos requisitos de programación en tiempo real. Si, durante una impresión, el ordenador anfitrión también realiza una tarea intensiva de computación de propósito general (como desfragmentar un disco duro, renderizado 3D, intercambio pesado, etc.), entonces puede causar que Klipper reporte errores de impresión.

Nota: Si no está usando una imagen OctoPi, tenga en cuenta que varias distribuciones de Linux habilitan un paquete "ModemManager" (o similar) que puede interrumpir la comunicación serie. (Lo que puede causar que Klipper reporte errores aparentemente aleatorios "Lost communication with MCU"). Si instala Klipper en una de estas distribuciones puede que necesite deshabilitar ese paquete.

## ¿Puedo ejecutar múltiples instancias de Klipper en la misma máquina?

Es posible ejecutar varias instancias del software anfitrión Klipper, pero para ello se requieren conocimientos de administración de Linux. Los scripts de instalación de Klipper hacen que se ejecute el siguiente comando Unix:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

Se pueden ejecutar varias instancias del comando anterior siempre que cada instancia tenga su propio archivo de configuración de impresora, su propio archivo de registro y su propio pseudotty. Por ejemplo:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

Si elige hacer esto, necesitará implementar los scripts de inicio, parada e instalación necesarios (si los hay). El script [install-octopi.sh](../scripts/install-octopi.sh) y el script [klipper-start.sh](../scripts/klipper-start.sh) pueden ser útiles como ejemplos.

## ¿Tengo que utilizar OctoPrint?

El software Klipper no depende de OctoPrint. Es posible utilizar software alternativo para enviar comandos a Klipper, pero hacerlo requiere conocimientos de administración de Linux.

Klipper crea un "puerto serie virtual" a través del archivo "/tmp/printer", y emula una interfaz serie clásica de impresora 3d a través de ese archivo. En general, los programas alternativos pueden funcionar con Klipper siempre que puedan configurarse para utilizar "/tmp/printer" para el puerto serie de la impresora.

## ¿Por qué no puedo mover el stepper antes de localizar la impresora?

The code does this to reduce the chance of accidentally commanding the head into the bed or a wall. Once the printer is homed the software attempts to verify each move is within the position_min/max defined in the config file. If the motors are disabled (via an M84 or M18 command) then the motors will need to be homed again prior to movement.

If you want to move the head after canceling a print via OctoPrint, consider changing the OctoPrint cancel sequence to do that for you. It's configured in OctoPrint via a web browser under: Settings->GCODE Scripts

If you want to move the head after a print finishes, consider adding the desired movement to the "custom g-code" section of your slicer.

If the printer requires some additional movement as part of the homing process itself (or fundamentally does not have a homing process) then consider using a safe_z_home or homing_override section in the config file. If you need to move a stepper for diagnostic or debugging purposes then consider adding a force_move section to the config file. See [config reference](Config_Reference.md#customized_homing) for further details on these options.

## Why is the Z position_endstop set to 0.5 in the default configs?

For cartesian style printers the Z position_endstop specifies how far the nozzle is from the bed when the endstop triggers. If possible, it is recommended to use a Z-max endstop and home away from the bed (as this reduces the potential for bed collisions). However, if one must home towards the bed then it is recommended to position the endstop so it triggers when the nozzle is still a small distance away from the bed. This way, when homing the axis, it will stop before the nozzle touches the bed. See the [bed level document](Bed_Level.md) for more information.

## I converted my config from Marlin and the X/Y axes work fine, but I just get a screeching noise when homing the Z axis

Short answer: First, make sure you have verified the stepper configuration as described in the [config check document](Config_checks.md). If the problem persists, try reducing the max_z_velocity setting in the printer config.

Long answer: In practice Marlin can typically only step at a rate of around 10000 steps per second. If it is requested to move at a speed that would require a higher step rate then Marlin will generally just step as fast as it can. Klipper is able to achieve much higher step rates, but the stepper motor may not have sufficient torque to move at a higher speed. So, for a Z axis with a high gearing ratio or high microsteps setting the actual obtainable max_z_velocity may be smaller than what is configured in Marlin.

## My TMC motor driver turns off in the middle of a print

If using the TMC2208 (or TMC2224) driver in "standalone mode" then make sure to use the [latest version of Klipper](#how-do-i-upgrade-to-the-latest-software). A workaround for a TMC2208 "stealthchop" driver problem was added to Klipper in mid-March of 2020.

## I keep getting random "Lost communication with MCU" errors

This is commonly caused by hardware errors on the USB connection between the host machine and the micro-controller. Things to look for:

- Use a good quality USB cable between the host machine and micro-controller. Make sure the plugs are secure.
- If using a Raspberry Pi, use a [good quality power supply](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply) for the Raspberry Pi and use a [good quality USB cable](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877) to connect that power supply to the Pi. If you get "under voltage" warnings from OctoPrint, this is related to the power supply and it must be fixed.
- Make sure the printer's power supply is not being overloaded. (Power fluctuations to the micro-controller's USB chip may result in resets of that chip.)
- Verify stepper, heater, and other printer wires are not crimped or frayed. (Printer movement may place stress on a faulty wire causing it to lose contact, briefly short, or generate excessive noise.)
- There have been reports of high USB noise when both the printer's power supply and the host's 5V power supply are mixed. (If you find that the micro-controller powers on when either the printer's power supply is on or the USB cable is plugged in, then it indicates the 5V power supplies are being mixed.) It may help to configure the micro-controller to use power from only one source. (Alternatively, if the micro-controller board can not configure its power source, one may modify a USB cable so that it does not carry 5V power between the host and micro-controller.)

## My Raspberry Pi keeps rebooting during prints

This is most likely do to voltage fluctuations. Follow the same troubleshooting steps for a ["Lost communication with MCU"](#i-keep-getting-random-lost-communication-with-mcu-errors) error.

## When I set `restart_method=command` my AVR device just hangs on a restart

Some old versions of the AVR bootloader have a known bug in watchdog event handling. This typically manifests when the printer.cfg file has restart_method set to "command". When the bug occurs, the AVR device will be unresponsive until power is removed and reapplied to the device (the power or status LEDs may also blink repeatedly until the power is removed).

The workaround is to use a restart_method other than "command" or to flash an updated bootloader to the AVR device. Flashing a new bootloader is a one time step that typically requires an external programmer - see [Bootloaders](Bootloaders.md) for further details.

## Will the heaters be left on if the Raspberry Pi crashes?

The software has been designed to prevent that. Once the host enables a heater, the host software needs to confirm that enablement every 5 seconds. If the micro-controller does not receive a confirmation every 5 seconds it goes into a "shutdown" state which is designed to turn off all heaters and stepper motors.

See the "config_digital_out" command in the [MCU commands](MCU_Commands.md) document for further details.

In addition, the micro-controller software is configured with a minimum and maximum temperature range for each heater at startup (see the min_temp and max_temp parameters in the [config reference](Config_Reference.md#extruder) for details). If the micro-controller detects that the temperature is outside of that range then it will also enter a "shutdown" state.

Separately, the host software also implements code to check that heaters and temperature sensors are functioning correctly. See the [config reference](Config_Reference.md#verify_heater) for further details.

## How do I convert a Marlin pin number to a Klipper pin name?

Short answer: A mapping is available in the [sample-aliases.cfg](../config/sample-aliases.cfg) file. Use that file as a guide to finding the actual micro-controller pin names. (It is also possible to copy the relevant [board_pins](Config_Reference.md#board_pins) config section into your config file and use the aliases in your config, but it is preferable to translate and use the actual micro-controller pin names.) Note that the sample-aliases.cfg file uses pin names that start with the prefix "ar" instead of "D" (eg, Arduino pin `D23` is Klipper alias `ar23`) and the prefix "analog" instead of "A" (eg, Arduino pin `A14` is Klipper alias `analog14`).

Long answer: Klipper uses the standard pin names defined by the micro-controller. On the Atmega chips these hardware pins have names like `PA4`, `PC7`, or `PD2`.

Long ago, the Arduino project decided to avoid using the standard hardware names in favor of their own pin names based on incrementing numbers - these Arduino names generally look like `D23` or `A14`. This was an unfortunate choice that has lead to a great deal of confusion. In particular the Arduino pin numbers frequently don't translate to the same hardware names. For example, `D21` is `PD0` on one common Arduino board, but is `PC7` on another common Arduino board.

To avoid this confusion, the core Klipper code uses the standard pin names defined by the micro-controller.

## Do I have to wire my device to a specific type of micro-controller pin?

It depends on the type of device and type of pin:

ADC pins (or Analog pins): For thermistors and similar "analog" sensors, the device must be wired to an "analog" or "ADC" capable pin on the micro-controller. If you configure Klipper to use a pin that is not analog capable, Klipper will report a "Not a valid ADC pin" error.

PWM pins (or Timer pins): Klipper does not use hardware PWM by default for any device. So, in general, one may wire heaters, fans, and similar devices to any general purpose IO pin. However, fans and output_pin devices may be optionally configured to use `hardware_pwm: True`, in which case the micro-controller must support hardware PWM on the pin (otherwise, Klipper will report a "Not a valid PWM pin" error).

IRQ pins (or Interrupt pins): Klipper does not use hardware interrupts on IO pins, so it is never necessary to wire a device to one of these micro-controller pins.

SPI pins: When using hardware SPI it is necessary to wire the pins to the micro-controller's SPI capable pins. However, most devices can be configured to use "software SPI", in which case any general purpose IO pins may be used.

I2C pins: When using I2C it is necessary to wire the pins to the micro-controller's I2C capable pins.

Other devices may be wired to any general purpose IO pin. For example, steppers, heaters, fans, Z probes, servos, LEDs, common hd44780/st7920 LCD displays, the Trinamic UART control line may be wired to any general purpose IO pin.

## How do I cancel an M109/M190 "wait for temperature" request?

Navigate to the OctoPrint terminal tab and issue an M112 command in the terminal box. The M112 command will cause Klipper to enter into a "shutdown" state, and it will cause OctoPrint to disconnect from Klipper. Navigate to the OctoPrint connection area and click on "Connect" to cause OctoPrint to reconnect. Navigate back to the terminal tab and issue a FIRMWARE_RESTART command to clear the Klipper error state. After completing this sequence, the previous heating request will be canceled and a new print may be started.

## Can I find out whether the printer has lost steps?

In a way, yes. Home the printer, issue a `GET_POSITION` command, run your print, home again and issue another `GET_POSITION`. Then compare the values in the `mcu:` line.

This might be helpful to tune settings like stepper motor currents, accelerations and speeds without needing to actually print something and waste filament: just run some high-speed moves in between the `GET_POSITION` commands.

Note that endstop switches themselves tend to trigger at slightly different positions, so a difference of a couple of microsteps is likely the result of endstop inaccuracies. A stepper motor itself can only lose steps in increments of 4 full steps. (So, if one is using 16 microsteps, then a lost step on the stepper would result in the "mcu:" step counter being off by a multiple of 64 microsteps.)

## Why does Klipper report errors? I lost my print!

Short answer: We want to know if our printers detect a problem so that the underlying issue can be fixed and we can obtain great quality prints. We definitely do not want our printers to silently produce low quality prints.

Long answer: Klipper has been engineered to automatically workaround many transient problems. For example, it automatically detects communication errors and will retransmit; it schedules actions in advance and buffers commands at multiple layers to enable precise timing even with intermittent interference. However, should the software detect an error that it can not recover from, if it is commanded to take an invalid action, or if it detects it is hopelessly unable to perform its commanded task, then Klipper will report an error. In these situations there is a high risk of producing a low-quality print (or worse). It is hoped that alerting the user will empower them to fix the underlying issue and improve the overall quality of their prints.

There are some related questions: Why doesn't Klipper pause the print instead? Report a warning instead? Check for errors before the print? Ignore errors in user typed commands? etc? Currently Klipper reads commands using the G-Code protocol, and unfortunately the G-Code command protocol is not flexible enough to make these alternatives practical today. There is developer interest in improving the user experience during abnormal events, but it is expected that will require notable infrastructure work (including a shift away from G-Code).

## How do I upgrade to the latest software?

The first step to upgrading the software is to review the latest [config changes](Config_Changes.md) document. On occasion, changes are made to the software that require users to update their settings as part of a software upgrade. It is a good idea to review this document prior to upgrading.

When ready to upgrade, the general method is to ssh into the Raspberry Pi and run:

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

Then one can recompile and flash the micro-controller code. For example:

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

However, it's often the case that only the host software changes. In this case, one can update and restart just the host software with:

```
cd ~/klipper
git pull
sudo service klipper restart
```

If after using this shortcut the software warns about needing to reflash the micro-controller or some other unusual error occurs, then follow the full upgrade steps outlined above.

If any errors persist then double check the [config changes](Config_Changes.md) document, as you may need to modify the printer configuration.

Note that the RESTART and FIRMWARE_RESTART g-code commands do not load new software - the above "sudo service klipper restart" and "make flash" commands are needed for a software change to take effect.

## How do I uninstall Klipper?

On the firmware end, nothing special needs to happen. Just follow the flashing directions for the new firmware.

On the raspberry pi end, an uninstall script is available in [scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh). For example:

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
