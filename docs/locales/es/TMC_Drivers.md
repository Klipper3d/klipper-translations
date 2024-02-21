# TMC drivers

Este documento provee información para utilizar el controlador de Trinamic para motor de paso a paso en modo SPI/UART en Klipper.

Klipper también puede usar controladores Trinamic en su "modo independiente" (“standalone-mode” en inglés). Sin embargo, cuando los controladores están en este modo, Klipper no necesita una configuración especial y las funciones avanzadas de Klipper exploradas en este documento no están disponibles.

Además de este documento, asegúrese de revisar la [referencia de configuración del controlador TMC](Config_Reference.md#tmc-stepper-driver-configuration).

## Tuning motor current

A higher driver current increases positional accuracy and torque. However, a higher current also increases the heat produced by the stepper motor and the stepper motor driver. If the stepper motor driver gets too hot it will disable itself and Klipper will report an error. If the stepper motor gets too hot, it loses torque and positional accuracy. (If it gets very hot it may also melt plastic parts attached to it or near it.)

As a general tuning tip, prefer higher current values as long as the stepper motor does not get too hot and the stepper motor driver does not report warnings or errors. In general, it is okay for the stepper motor to feel warm, but it should not become so hot that it is painful to touch.

## Prefer to not specify a hold_current

If one configures a `hold_current` then the TMC driver can reduce current to the stepper motor when it detects that the stepper is not moving. However, changing motor current may itself introduce motor movement. This may occur due to "detent forces" within the stepper motor (the permanent magnet in the rotor pulls towards the iron teeth in the stator) or due to external forces on the axis carriage.

Most stepper motors will not obtain a significant benefit to reducing current during normal prints, because few printing moves will leave a stepper motor idle for sufficiently long to activate the `hold_current` feature. And, it is unlikely that one would want to introduce subtle print artifacts to the few printing moves that do leave a stepper idle sufficiently long.

If one wishes to reduce current to motors during print start routines, then consider issuing [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) commands in a [START_PRINT macro](Slicers.md#klipper-gcode_macro) to adjust the current before and after normal printing moves.

Some printers with dedicated Z motors that are idle during normal printing moves (no bed_mesh, no bed_tilt, no Z skew_correction, no "vase mode" prints, etc.) may find that Z motors do run cooler with a `hold_current`. If implementing this then be sure to take into account this type of uncommanded Z axis movement during bed leveling, bed probing, probe calibration, and similar. The `driver_TPOWERDOWN` and `driver_IHOLDDELAY` should also be calibrated accordingly. If unsure, prefer to not specify a `hold_current`.

## Setting "spreadCycle" vs "stealthChop" Mode

By default, Klipper places the TMC drivers in "spreadCycle" mode. If the driver supports "stealthChop" then it can be enabled by adding `stealthchop_threshold: 999999` to the TMC config section.

In general, spreadCycle mode provides greater torque and greater positional accuracy than stealthChop mode. However, stealthChop mode may produce significantly lower audible noise on some printers.

Tests comparing modes have shown an increased "positional lag" of around 75% of a full-step during constant velocity moves when using stealthChop mode (for example, on a printer with 40mm rotation_distance and 200 steps_per_rotation, position deviation of constant speed moves increased by ~0.150mm). However, this "delay in obtaining the requested position" may not manifest as a significant print defect and one may prefer the quieter behavior of stealthChop mode.

It is recommended to always use "spreadCycle" mode (by not specifying `stealthchop_threshold`) or to always use "stealthChop" mode (by setting `stealthchop_threshold` to 999999). Unfortunately, the drivers often produce poor and confusing results if the mode changes while the motor is at a non-zero velocity.

## TMC interpolate setting introduces small position deviation

The TMC driver `interpolate` setting may reduce the audible noise of printer movement at the cost of introducing a small systemic positional error. This systemic positional error results from the driver's delay in executing "steps" that Klipper sends it. During constant velocity moves, this delay results in a positional error of nearly half a configured microstep (more precisely, the error is half a microstep distance minus a 512th of a full step distance). For example, on an axis with a 40mm rotation_distance, 200 steps_per_rotation, and 16 microsteps, the systemic error introduced during constant velocity moves is ~0.006mm.

For best positional accuracy consider using spreadCycle mode and disable interpolation (set `interpolate: False` in the TMC driver config). When configured this way, one may increase the `microstep` setting to reduce audible noise during stepper movement. Typically, a microstep setting of `64` or `128` will have similar audible noise as interpolation, and do so without introducing a systemic positional error.

If using stealthChop mode then the positional inaccuracy from interpolation is small relative to the positional inaccuracy introduced from stealthChop mode. Therefore tuning interpolation is not considered useful when in stealthChop mode, and one can leave interpolation in its default state.

## Proceso de localización de la boquilla sin sensor

El proceso de localización de la boquilla sin sensor ("Sensorless Homing" en inglés) permite determinar el punto donde la boquilla de la impresora se encuentra en un eje sin la necesidad de un interruptor de límite físico. En su lugar, el carruaje en el eje se mueve hacia el límite mecánico haciendo que el motor paso a paso pierda pasos. El controlador del motor paso a paso detecta los pasos perdidos y alterna un pin para indicar la perdida al microcontrolador (“MCU”) dominante (Klipper). Klipper puede utilizar esta información como el punto de parada final para el eje.

Esta guía cubre la configuración del proceso de localización de la boquilla sin sensor para el eje X de su impresora (cartesiana). Sin embargo, funciona igual con todos los demás ejes (que requieren parada final). Debe configurarlo y afinarlo para un eje a la vez.

### Limitaciones

Asegúrese de que sus componentes mecánicos sean capaces de manejar la carga del carruaje chocando contra el límite del eje repetidamente. Especialmente los husillos pues podrían generar mucha fuerza. Posicionar un eje Z golpeando la boquilla contra la superficie de impresión puede que no sea una buena idea. Para obtener los mejores resultados, verifique que el carruaje del eje va hacer un contacto firme con el límite del eje.

Además, es posible que el proceso de localización de la boquilla sin sensor no sea lo suficientemente preciso para su impresora. Mientras el proceso de localización de la boquilla de los ejes X e Y en una máquina cartesiana puede funcionar bien, el mismo proceso en el eje Z generalmente no es lo suficientemente preciso y puede resultar en que la primera capa tenga una altura inconsistente. No es aconsejable completar el proceso de localización de la boquilla sin un sensor en una impresora delta debido a la falta de precisión.

Además, la habilidad de detectar cuando el motor se detiene (“stall detection” en inglés) que se encuentra en el controlador del motor paso a paso depende de la carga mecánica en el motor, la corriente del motor y la temperatura del motor (resistencia de la bobina).

El proceso de retorno a casa sin sensor funciona mejor a velocidades de "motor medias. Para velocidades bien bajas (menos de 10 r.p.m.) el motor no genera suficiente fuerza contraelectromotriz (CEMF por sus siglas en inglés) y el controlador (“TMC” por sus siglas en inglés) no puede detectar con confiabilidad cuando el motor se detiene. Además, a velocidades muy altas, el CEMF del motor se acerca al voltaje de alimentación del motor, así es que el TMC ya no puede detectar los paros del motor. Se recomienda que revise la hoja de datos de su TMC específico. Allí también encontrará mas detalles sobre las limitaciones de esta configuración.

### Prerequisitos

Se necesitan algunos prerequisitos para utilizar le proceso de localización de la boquilla sin sensor:

1. A stallGuard capable TMC stepper driver (tmc2130, tmc2209, tmc2660, or tmc5160).
1. El interfaz SPI / UART del controlador TMC conectado al microcontrolador (el modo autónomo no funciona).
1. El pin “DIAG” o “SG_TST” apropiado del controlador TMC conectado al microcontrolador.
1. Los pasos en el documento [comprobaciones de configuración](Config_checks.md) tienen que ejecutarse para confirmar que los motores paso a paso están configurados y funcionando correctamente.

### Afinamiento

El procedimiento descrito aquí tiene seis pasos principales:

1. Escoja una velocidad para el proceso de localización de la boquilla.
1. Configure el archivo `printer.cfg` para habilitar el proceso de localización de la boquilla sin sensor.
1. Encuentre el ajuste del “stallguard” con la mayor sensibilidad que complete el proceso de localización de la boquilla con éxito.
1. Encuentre el ajuste del “stallguard” con la menor sensibilidad que complete el proceso de localización de la boquilla con un solo toque.
1. Actualice `printer.cfg` con la configuración de “stallguard” deseada.
1. Cree o actualice los macros de `printer.cfg` para completar el proceso de localización de la boquilla de forma consistente.

#### Escoja una velocidad para el proceso de localización de la boquilla

La velocidad del proceso de localización de la boquilla sin sensor es una elección importante cuando se va a ejecutar el proceso. Completar el proceso a baja velocidad es preferible para evitar que el carruaje ejerza una fuerza excesiva en el armazón cuando haga contacto con el extremo del riel. Sin embargo, a bajas velocidades, los controladores TMC no pueden detectar de forma fiable cuando el motor se detiene.

Un buen punto de partida para la velocidad del proceso de localización de la boquilla es que el motor paso a paso complete una rotación cada dos segundos. Para muchos ejes esta será la ‘distancia de rotación’ (`rotation_distance` en inglés) dividida por dos. Por ejemplo:

```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### Configure printer.cfg para el proceso de localización de la boquilla sin sensor

El ajuste `homing_retract_dist` debe inicializarse a cero en la sección de configuración `stepper_x` para desactivar el segundo movimiento del proceso de localización de la boquilla. El segundo intento del proceso no añade valor cuando se usa el proceso de localización de la boquilla sin sensor, pues no trabajará de forma fiable y confundirá el proceso de afinamiento.

Asegúrese de que el ajuste `hold_current` no está especificado en la sección del controlador TMC de la configuración. (Si `hold_current` está inicializado, entonces después de hacer contacto, el motor se detendrá mientras el carruaje está presionado contra el extremo del riel y una reducción de corriente mientras está en esa posición puede hacer que el carruaje se mueva, lo que resultaría en un rendimiento deficiente y confundiría el proceso de afinamiento).

Es necesario configurar los pines del proceso de localización de la boquilla sin sensor y configurar los ajustes iniciales de "stallguard". Aquí sigue un ejemplo de como la configuración de un tmc2209 para el eje X podría ser:

```
[tmc2209 stepper_x]
diag_pin: ^PA1      # Set to MCU pin connected to TMC DIAG pin
driver_SGTHRS: 255  # 255 is most sensitive value, 0 is least sensitive
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

El siguiente ejemplo demuestra una posible configuración para el tmc2130 o el tmc5160:

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # Pin connected to TMC DIAG1 pin (or use diag0_pin / DIAG0 pin)
driver_SGT: -64  # -64 is most sensitive value, 63 is least sensitive
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Aquí sigue un ejemplo de como se podría configurar el tmc2660:

```
[tmc2660 stepper_x]
driver_SGT: -64     # -64 is most sensitive value, 63 is least sensitive
...

[stepper_x]
endstop_pin: ^PA1   # Pin connected to TMC SG_TST pin
homing_retract_dist: 0
...
```

Los ejemplos anteriores solo muestran configuraciones específicas para la localización de la boquilla sin sensor. Consulte la [referencia de configuración] (Config_Reference.md#tmc-stepper-driver-configuration) para conocer todas las opciones disponibles.

#### Encuentre la configuración de sensibilidad más alta para una localización exitosa

Coloque el carruaje cerca del centro del riel. Utilice el comando SET_TMC_FIELD para establecer la sensibilidad más alta. Para el tmc2209:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

Para el tmc2130, el tmc5160, y el tmc2660:

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

Then issue a `G28 X0` command and verify the axis does not move at all or quickly stops moving. If the axis does not stop, then issue an `M112` to halt the printer - something is not correct with the diag/sg_tst pin wiring or configuration and it must be corrected before continuing.

A continuación, disminuya continuamente la sensibilidad del ajuste `VALUE` y ejecute los comandos `SET_TMC_FIELD` y `G28 X0` nuevamente para encontrar la más alta sensibilidad que resulte en que el carruaje se mueva exitosamente hasta su casa y se detenga. (Para los controladores tmc2209 esto será disminuir SGTHRS, para otros controladores será aumentar sgt.) Asegúrese de empezar cada intento con el carruaje cerca del centro del riel (si es necesario emita `M84` y luego mueva manualmente el carruaje al centro). Debería ser posible encontrar la sensibilidad más alta que localice la boquilla de forma fiable (los ajustes con mayor sensibilidad dan como resultado un movimiento pequeño o nulo). Apunte el valor encontrado como *maximum_sensitivity*. (Si la sensibilidad mínima posible (SGTHRS=0 o sgt =63) se obtiene sin ningún movimiento del carruaje, entonces hay algún error con el cableado o la configuración de los pines diag/sg_tst y debe corregirse antes de continuar).

Al buscar la sensibilidad_máxima (“maximum_sensitivity” en inglés), puede ser conveniente saltar a un ajuste diferente de VALUE (para dividir en dos el parámetro VALUE). Si hace esto, entonces prepárese para emitir un comando `M112` para detener la impresora, ya que un ajuste con una sensibilidad muy baja puede causar que el eje "golpee" repetidamente contra el extremo del riel.

Asegúrese de esperar un par de segundos entre cada intento del proceso de localización de la boquilla. Después de que el controlador TMC detecta una parada, puede tardar un poco en despejar su indicador interno y ser capaz de detectar otra parada.

Durante estas pruebas de afinamiento, si un comando `G28 X0` no causa que el carruaje se mueva hasta el límite del eje, tenga cuidado al emitir cualquier comando de movimiento regular (por ejemplo, `G1`). Klipper no tendrá una comprensión correcta de la posición del carruaje y un comando de movimiento puede causar resultados indeseables y confusos.

#### Encuentre la sensibilidad más baja que complete el proceso de localización de la boquilla con un solo toque

Cuando ejecutando el proceso de localización de la boquilla con el valor de *maximum_sensitivity* encontrado, el eje debe moverse hasta el extremo del riel y detenerse con un "solo toque", es decir, no debe haber un sonido de “click” o “golpeteo”. (Si hay un sonido de golpeteo o clic cuando se usa el valor de maximum_sensitivity, entonces el valor de homing_speed puede ser demasiado bajo, la corriente del controlador puede ser demasiado baja o el proceso de localización de la boquilla sin sensor puede no ser una buena opción para el eje).

El próximo paso es volver a mover continuamente el carruaje a una posición cerca del centro del riel, disminuir la sensibilidad, y ejecutar los comandos `SET_TMC_FIELD` y `G28 X0`; el objetivo ahora es encontrar la sensibilidad más baja que aún resulte en que el carruaje complete con éxito el proceso de localización de la boquilla con un “solo toque”. Es decir, no “golpea” ni hace “clic” cuando entra en contacto con el extremo del riel. Apunte el valor encontrado como *minimum_sensitivity*.

#### Actualizando printer.cfg con el valor de sensibilidad

Después de encontrar *maximum_sensitivity* y *minimum_sensitivity*, use una calculadora para obtener la sensibilidad recomendada como *minimum_sensitivity + (maximum_sensitivity - minimum_sensitivity)/3*. La sensibilidad recomendada debe estar en el rango entre el mínimo y el máximo, pero ligeramente más cerca del mínimo. Redondee el valor final al valor entero más cercano.

Para el tmc2209 establezca esto en la configuración como `driver_SGTHRS` y para los otros controladores TMC establezca esto en la configuración como `driver_SGT`.

Si el rango entre *maximum_sensitivity* y *minimum_sensitivity*. encontrado es corto (por ejemplo inferior a 5) entonces puede resultar en un proceso de localización de la boquilla inestable. Una velocidad para el proceso de localización de la boquilla más rápida puede aumentar el intervalo y hacer que la operación sea más estable.

Tenga en cuenta que si se realiza algún cambio en la corriente del controlador, la velocidad del proceso de localización de la boquilla o se realiza un cambio notable en el hardware de la impresora, será necesario ejecutar el proceso de afinamiento nuevamente.

#### Usando macros cuando se ejecuta el proceso de localización de la boquilla

Después de que el proceso de localización de la boquilla sin sensor complete, el carruaje se presionará contra el extremo del riel y el motor de paso a paso ejercerá una fuerza sobre el armazón hasta que el carruaje sea alejado. Así es que, es una buena idea crear un macro para ejecutar el proceso de localización de la boquilla e inmediatamente el carruaje del extremo del riel.

También es una buena idea que el macro haga una pausa de por lo menos 2 segundos antes de empezar el proceso de localización de la boquilla sin sensor (o de lo contrario asegúrese de que no haya habido movimiento en el motor de paso a paso durante 2 segundos). Sin la pausa, es posible que el indicador interno de parada del controlador se mantenga inicializado basado en un movimiento anterior.

It can also be useful to have that macro set the driver current before homing and set a new current after the carriage has moved away.

Un ejemplo de un macro podría ser algo así como:

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # Set current for sensorless homing
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # Pause to ensure driver stall flag is clear
    G4 P2000
    # Home
    G28 X0
    # Move away
    G90
    G1 X5 F1200
    # Set current during print
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

El macro resultante se puede llamar desde la [sección de configuración homing_override](Config_Reference.md#homing_override) o desde un [macro START_PRINT](Slicers.md#klipper-gcode_macro).

Tenga en cuenta que si se cambia la corriente del controlador durante el proceso de localización de la boquilla, entonces el proceso de afinamiento debe ejecutarse de nuevo.

### Consejos para el proceso de localización de la boquilla sin sensor en CoreXY

Es posible utilizar el proceso de localización de la boquilla sin sensor en los carruajes X e Y de una impresora CoreXY. Klipper usa la definición `[stepper_x]` para detectar los detenimientos del motor paso a paso mientras se ejecuta el proceso de localización de la boquilla en el carruaje X y usa la definición `[stepper_y]` para detectar los detenimientos del motor paso a paso mientras se ejecuta el proceso de localización de la boquilla en el carruaje Y.

Utilice la guía de afinamiento descrita anteriormente para encontrar la “sensibilidad a detenimientos”, “stall sensitivity” en inglés, adecuada para cada carruaje, pero tenga en cuenta las siguientes restricciones:

1. When using sensorless homing on CoreXY, make sure there is no `hold_current` configured for either stepper.
1. Mientras afina, asegúrese de que los carruajes X e Y estén cerca del centro de sus rieles antes de cada intento de ejecutar el proceso de localización de la boquilla.
1. Después de completar el afinamiento, cuando se ejecute el proceso de localización de la boquilla para tanto X como Y, use macros para asegurarse de que se completen los siguientes cuatro pasos en orden: un eje complete el proceso primero; entonces se aleje ese carruaje del extremo del eje; haya una pausa de al menos 2 segundos, y entonces comience el proceso en el otro carruaje. El alejamiento del eje previene que el proceso de localización de la boquilla de un eje se ejecute mientras que el otro este presionado contra el extremo del eje (lo que podría distorsionar la detección de detenimientos). La pausa es necesaria para asegurarse que el indicador de parada del controlador este despejado antes de ejecutar el proceso de localización de la boquilla nuevamente.

An example CoreXY homing macro might look like:

```
[gcode_macro HOME]
gcode:
    G90
    # Home Z
    G28 Z0
    G1 Z10 F1200
    # Home Y
    G28 Y0
    G1 Y5 F1200
    # Home X
    G4 P2000
    G28 X0
    G1 X5 F1200
```

## Consultando y diagnosticando los ajustes del controlador

The `[DUMP_TMC command](G-Codes.md#dump_tmc) is a useful tool when configuring and diagnosing the drivers. It will report all fields configured by Klipper as well as all fields that can be queried from the driver.

Todos los campos declarados se definen en la hoja de datos de Trinamic para cada controlador. Estas hojas de datos se pueden encontrar en el [sitio web de Trinamic](https://www.trinamic.com/). Obtenga y revise la hoja de datos del conductor publicada por Trinamic para interpretar los resultados de DUMP_TMC.

## Configurado los ajustes de driver_XXX

Klipper admite la configuración de muchos campos de bajo nivel utilizando los ajustes disponibles en la sección `driver_XXX` del controlador. La [referencia de configuración del controlador TMC](Config_Reference.md#tmc-stepper-driver-configuration) tiene la lista completa de campos disponibles para cada tipo de controlador.

In addition, almost all fields can be modified at run-time using the [SET_TMC_FIELD command](G-Codes.md#set_tmc_field).

Cada uno de estos campos se define en la hoja de datos de Trinamic para cada controlador. Estas hojas de datos se pueden encontrar en el [sitio web de Trinamic](https://www.trinamic.com/).

Tenga en cuenta que las hojas de datos de Trinamic a veces usan una redacción que puede confundir una ajuste de alto nivel (como "hysteresis end") con un valor para un campo de bajo nivel (por ejemplo, "HEND"). En Klipper, `driver_XXX` y SET_TMC_FIELD siempre establecen el valor del campo de bajo nivel que realmente se escribe en el controlador. Entonces, por ejemplo, si la hoja de datos Trinamic establece que se debe escribir un valor de 3 en el campo HEND para obtener un "final de histéresis" (“hysteresis end” en inglés) de 0, establezca `driver_HEND=3` para obtener el valor de alto nivel de 0.

## <strong>Preguntas más frecuentes</strong>

### Can I use stealthChop mode on an extruder with pressure advance?

Many people successfully use "stealthChop" mode with Klipper's pressure advance. Klipper implements [smooth pressure advance](Kinematics.md#pressure-advance) which does not introduce any instantaneous velocity changes.

However, "stealthChop" mode may produce lower motor torque and/or produce higher motor heat. It may or may not be an adequate mode for your particular printer.

### I keep getting "Unable to read tmc uart 'stepper_x' register IFCNT" errors?

This occurs when Klipper is unable to communicate with a tmc2208 or tmc2209 driver.

Make sure that the motor power is enabled, as the stepper motor driver generally needs motor power before it can communicate with the micro-controller.

If this error occurs after flashing Klipper for the first time, then the stepper driver may have been previously programmed in a state that is not compatible with Klipper. To reset the state, remove all power from the printer for several seconds (physically unplug both USB and power plugs).

Otherwise, this error is typically the result of incorrect UART pin wiring or an incorrect Klipper configuration of the UART pin settings.

### I keep getting "Unable to write tmc spi 'stepper_x' register ..." errors?

This occurs when Klipper is unable to communicate with a tmc2130 or tmc5160 driver.

Make sure that the motor power is enabled, as the stepper motor driver generally needs motor power before it can communicate with the micro-controller.

Otherwise, this error is typically the result of incorrect SPI wiring, an incorrect Klipper configuration of the SPI settings, or an incomplete configuration of devices on an SPI bus.

Note that if the driver is on a shared SPI bus with multiple devices then be sure to fully configure every device on that shared SPI bus in Klipper. If a device on a shared SPI bus is not configured, then it may incorrectly respond to commands not intended for it and corrupt the communication to the intended device. If there is a device on a shared SPI bus that can not be configured in Klipper, then use a [static_digital_output config section](Config_Reference.md#static_digital_output) to set the CS pin of the unused device high (so that it will not attempt to use the SPI bus). The board's schematic is often a useful reference for finding which devices are on an SPI bus and their associated pins.

### Why did I get a "TMC reports error: ..." error?

This type of error indicates the TMC driver detected a problem and has disabled itself. That is, the driver stopped holding its position and ignored movement commands. If Klipper detects that an active driver has disabled itself, it will transition the printer into a "shutdown" state.

It's also possible that a **TMC reports error** shutdown occurs due to SPI errors that prevent communication with the driver (on tmc2130, tmc5160, or tmc2660). If this occurs, it's common for the reported driver status to show `00000000` or `ffffffff` - for example: `TMC reports error: DRV_STATUS: ffffffff ...` OR `TMC reports error: READRSP@RDSEL2: 00000000 ...`. Such a failure may be due to an SPI wiring problem or may be due to a self-reset or failure of the TMC driver.

Some common errors and tips for diagnosing them:

#### TMC reports error: `... ot=1(OvertempError!)`

This indicates the motor driver disabled itself because it became too hot. Typical solutions are to decrease the stepper motor current, increase cooling on the stepper motor driver, and/or increase cooling on the stepper motor.

#### TMC reports error: `... ShortToGND` OR `ShortToSupply`

This indicates the driver has disabled itself because it detected very high current passing through the driver. This may indicate a loose or shorted wire to the stepper motor or within the stepper motor itself.

This error may also occur if using stealthChop mode and the TMC driver is not able to accurately predict the mechanical load of the motor. (If the driver makes a poor prediction then it may send too much current through the motor and trigger its own over-current detection.) To test this, disable stealthChop mode and check if the errors continue to occur.

#### TMC reports error: `... reset=1(Reset)` OR `CS_ACTUAL=0(Reset?)` OR `SE=0(Reset?)`

This indicates that the driver has reset itself mid-print. This may be due to voltage or wiring issues.

#### TMC reports error: `... uv_cp=1(Undervoltage!)`

This indicates the driver has detected a low-voltage event and has disabled itself. This may be due to wiring or power supply issues.

### How do I tune spreadCycle/coolStep/etc. mode on my drivers?

The [Trinamic website](https://www.trinamic.com/) has guides on configuring the drivers. These guides are often technical, low-level, and may require specialized hardware. Regardless, they are the best source of information.
