# Controladores TMC

Este documento provee información para utilizar el controlador de Trinamic para motor de paso a paso en modo SPI/UART en Klipper.

Klipper también puede usar controladores Trinamic en su "modo independiente" (“standalone-mode” en inglés). Sin embargo, cuando los controladores están en este modo, Klipper no necesita una configuración especial y las funciones avanzadas de Klipper exploradas en este documento no están disponibles.

Además de este documento, asegúrese de revisar la [referencia de configuración del controlador TMC](Config_Reference.md#tmc-stepper-driver-configuration).

## Afinando la corriente del motor

Aumentar la corriente del controlador causa un aumento en la precisión posicional y en el par de torsión. Sin embargo, la corriente más alta también aumenta el calor producido por el motor de paso a paso y su controlador. Si el controlador del motor paso a paso se calienta demasiado, se desactivará de forma autónoma y Klipper informará de un error. Si el motor paso a paso se calienta demasiado, pierde par de torsión y precisión posicional. (Si se calienta mucho, también puede derretir las piezas de plástico unidas a él o cerca de él).

Como consejo de afinamiento general, prefiera valores de corriente más altos siempre que el motor paso a paso no se caliente demasiado y el controlador del motor paso a paso no comunique advertencias o errores. En general, está bien que el motor de paso a paso se sienta caliente, pero no debe calentarse tanto que sea doloroso al tocar.

## Es preferible no especificar “hold_current”

Si se configura una corriente de mantenimiento usando el ajuste `hold_current`, entonces el controlador TMC puede reducir la corriente al motor de paso a paso cuando detecta que el motor no se está moviendo. Sin embargo, un cambio a la corriente del motor por sí solo puede causar que el motor se mueva. Esto puede ocurrir debido a "fuerzas de retención" dentro del motor de paso a paso (el imán permanente en el rotor tira hacia los dientes de hierro en el estátor) o debido a fuerzas externas en el carruaje del eje.

La mayoría de los motores de paso a paso no obtendrán un beneficio significativo como resultado de reducir la corriente durante las impresiones normales, porque pocos movimientos de impresión dejarían el motor de paso a paso inactivo durante el tiempo suficiente para activar la función `hold_current`. Además, es poco probable que uno quiera introducir artefactos de impresión sutiles a los pocos movimientos de impresión que dejan al motor de paso a paso inactivo el tiempo suficiente.

Si desea reducir la corriente a los motores durante las rutinas de inicio de impresión, considere emitir los comandos [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) en un [macro START_PRINT](Slicers.md#klipper-gcode_macro) para ajustar la corriente antes y después de los movimientos normales de impresión.

Algunas impresoras con motores Z dedicados que están inactivos durante los movimientos de impresión normales (sin bed_mesh, sin bed_tilt, sin Z skew_correction, sin impresiones en "modo jarrón" (“vase mode” en inglés), etc.) pueden encontrar que los motores Z funcionan a temperaturas más bajas cuando se usa `hold_current`. Si implementa esto, asegúrese de tener en cuenta este tipo de movimiento no ordenado del eje Z durante la nivelación de la cama, el sondeo de la cama, la calibración de la sonda y similares. El `driver_TPOWERDOWN` y el `driver_IHOLDDELAY` también deben calibrarse en consecuencia. Si no está seguro, prefiera no especificar `hold_current`.

## Configurando el modo "spreadCycle" vs. "stealthChop"

De forma predeterminada, Klipper coloca los controladores TMC en modo "spreadCycle". Si el controlador es compatible con “stealthChop”, se puede habilitar añadiendo `stealthchop_threshold: 999999` a la sección de configuración de TMC.

En general, el modo spreadCycle proporciona un mayor par de torsión y una mayor precisión posicional que el modo stealthChop. Sin embargo, el modo stealthChop puede producir un ruido audible significativamente menor en algunas impresoras.

Las pruebas que comparan los modos han mostrado un aumento del "retraso posicional" (“positional lag” en inglés) de alrededor del 75 % de un paso completo durante los movimientos de velocidad constante cuando se utiliza el modo stealthChop (por ejemplo, en una impresora con 40 mm de distancia de rotación (“rotation_distance” en inglés) y 200 pasos por rotación (“steps_per_rotation” en inglés) la desviación de posición de los movimientos de velocidad constante aumentó por ~ 0,150 mm). Sin embargo, este "retraso en obtener la posición solicitada" puede no manifestarse como un defecto de impresión significativo y uno puede preferir el comportamiento más silencioso del modo stealthChop.

Se recomienda utilizar siempre el modo "spreadCycle" (al no especificar `stealthchop_threshold`) o utilizar siempre el modo "stealthChop" (ajustando `stealthchop_threshold` a 999999). Desafortunadamente, los controladores a menudo producen resultados pobres y confusos si el modo cambia mientras el motor está a una velocidad distinta de cero.

## El ajuste interpolación del controlador TMC introduce una pequeña desviación de posición

El ajuste "interpolación" (`interpolate` en inglés) del controlador TMC puede reducir el ruido audible creado por el movimiento de la impresora a costa de introducir un pequeño error de posición sistémico. Este error posicional sistémico es el resultado del retraso del controlador en ejecutar los "pasos" que Klipper le envía. Durante los movimientos de velocidad constante, este retraso da como resultado un error de posición de casi la mitad de un micropaso configurado (más precisamente, el error es la mitad de la distancia de un micropaso menos 1/512 parte de la distancia de un paso completo). Por ejemplo, en un eje con una distancia de rotación de 40 mm, 200 pasos por rotación y 16 micropasos, el error sistémico introducido durante los movimientos de velocidad constante es de ~ 0,006 mm.

Para una mejor precisión posicional, considere usar el modo spreadCycle y deshabilitar la interpolación (especifique `interpolate: False` en la configuración del controlador TMC). Cuando se configura de esta manera, se puede aumentar el valor del parámetro `microstep` para reducir el ruido audible durante el movimiento del motor de paso a paso. Por lo general, especificar un valor de `64` o `128` en el parámetro "microstep" causará un ruido audible similar al de la interpolación, y lo hará sin introducir un error de posición sistémico.

Si utiliza el modo stealthChop entonces la inexactitud posicional debido a la interpolación es pequeña en relación con la inexactitud posicional introducida por el modo stealthChop. Por lo tanto, afinar la interpolación no se considera útil cuando se está utilizando el modo stealthChop, y se puede dejar la interpolación en su estado predeterminado.

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

1. Un controlador de motor de paso a paso TMC compatible con stallGuard (tmc2130, tmc2209, tmc2660, o tmc5160).
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
diag_pin: ^PA1      # Ajustar a pin de MCU conectado a pin de TMC DIAG
driver_SGTHRS: 255  # 255 es el valor más sensible, 0 es el menos sensible
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

El siguiente ejemplo demuestra una posible configuración para el tmc2130 o el tmc5160:

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # Pin conectado al pin TMC DIAG1 (o use diag0_pin / DIAG0 pin)
driver_SGT: -64  # -64 es el valor más sensible, 63 es el menos sensible
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Aquí sigue un ejemplo de como se podría configurar el tmc2660:

```
[tmc2660 stepper_x]
driver_SGT: -64     # -64 es el valor más sensible, 63 es el menos sensible
...

[stepper_x]
endstop_pin: ^PA1   # PIN conectado al PIN TMC SG_TST
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

Entonces, ejecute un comando `G28 X0` y verifique que el eje no se mueve en absoluto o que se detiene rápidamente. Si el eje no se detiene, emita un `M112` para detener la impresora porque algo esta incorrecto en el cableado o la configuración del pin diag/sg_tst y debe corregirse antes de continuar.

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

También puede ser útil que ese macro establezca la corriente del controlador antes de ejecutar el proceso de localización de la boquilla y entonces establecer una nueva corriente después de que el carruaje se haya alejado.

Un ejemplo de un macro podría ser algo así como:

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # Establezca la corriente para el proceso de localización de la boquilla sin sensor
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # Una pausa para asegurar que el indicador de parada esta despejadoEjecute el proceso de localización de la boquilla
    G4 P2000
    # Ejecute el proceso de localización de la boquilla
    G28 X0
    # Alejar
    G90
    G1 X5 F1200
    # Establezca la corriente usada durante la impresión
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

El macro resultante se puede llamar desde la [sección de configuración homing_override](Config_Reference.md#homing_override) o desde un [macro START_PRINT](Slicers.md#klipper-gcode_macro).

Tenga en cuenta que si se cambia la corriente del controlador durante el proceso de localización de la boquilla, entonces el proceso de afinamiento debe ejecutarse de nuevo.

### Consejos para el proceso de localización de la boquilla sin sensor en CoreXY

Es posible utilizar el proceso de localización de la boquilla sin sensor en los carruajes X e Y de una impresora CoreXY. Klipper usa la definición `[stepper_x]` para detectar los detenimientos del motor paso a paso mientras se ejecuta el proceso de localización de la boquilla en el carruaje X y usa la definición `[stepper_y]` para detectar los detenimientos del motor paso a paso mientras se ejecuta el proceso de localización de la boquilla en el carruaje Y.

Utilice la guía de afinamiento descrita anteriormente para encontrar la “sensibilidad a detenimientos”, “stall sensitivity” en inglés, adecuada para cada carruaje, pero tenga en cuenta las siguientes restricciones:

1. Cuando utilice el proceso de localización de la boquilla sin sensor en CoreXY, asegúrese de que no haya una corriente de mantenimiento (`hold_current` en inglés) configurada para ninguno de los motores de paso a paso.
1. Mientras afina, asegúrese de que los carruajes X e Y estén cerca del centro de sus rieles antes de cada intento de ejecutar el proceso de localización de la boquilla.
1. Después de completar el afinamiento, cuando se ejecute el proceso de localización de la boquilla para tanto X como Y, use macros para asegurarse de que se completen los siguientes cuatro pasos en orden: un eje complete el proceso primero; entonces se aleje ese carruaje del extremo del eje; haya una pausa de al menos 2 segundos, y entonces comience el proceso en el otro carruaje. El alejamiento del eje previene que el proceso de localización de la boquilla de un eje se ejecute mientras que el otro este presionado contra el extremo del eje (lo que podría distorsionar la detección de detenimientos). La pausa es necesaria para asegurarse que el indicador de parada del controlador este despejado antes de ejecutar el proceso de localización de la boquilla nuevamente.

Un ejemplo de un macro para ejecutar el proceso de localización de la boquilla en una impresora CoreXY podría ser:

```
[gcode_macro HOME]
gcode:
    G90
    # Ejecute el proceso de localización de la boquilla en el eje Z
    G28 Z0
    G1 Z10 F1200
    # Ejecute el proceso de localización de la boquilla en el eje Y
    G28 Y0
    G1 Y5 F1200
    # Ejecute el proceso de localización de la boquilla en el eje X
    G4 P2000
    G28 X0
    G1 X5 F1200
```

## Consultando y diagnosticando los ajustes del controlador

El `[comando DUMP_TMC](G-Codes.md#dump_tmc) es una herramienta útil a la hora de configurar y diagnosticar los controladores. Informará de todos los campos configurados por Klipper así como de todos los campos que se puedan consultar desde el controlador.

Todos los campos declarados se definen en la hoja de datos de Trinamic para cada controlador. Estas hojas de datos se pueden encontrar en el [sitio web de Trinamic](https://www.trinamic.com/). Obtenga y revise la hoja de datos del conductor publicada por Trinamic para interpretar los resultados de DUMP_TMC.

## Configurado los ajustes de driver_XXX

Klipper admite la configuración de muchos campos de bajo nivel utilizando los ajustes disponibles en la sección `driver_XXX` del controlador. La [referencia de configuración del controlador TMC](Config_Reference.md#tmc-stepper-driver-configuration) tiene la lista completa de campos disponibles para cada tipo de controlador.

Además, casi todos los campos se pueden modificar al tiempo de ejecución utilizando el [comando SET_TMC_FIELD](G-Codes.md#set_tmc_field).

Cada uno de estos campos se define en la hoja de datos de Trinamic para cada controlador. Estas hojas de datos se pueden encontrar en el [sitio web de Trinamic](https://www.trinamic.com/).

Tenga en cuenta que las hojas de datos de Trinamic a veces usan una redacción que puede confundir una ajuste de alto nivel (como "hysteresis end") con un valor para un campo de bajo nivel (por ejemplo, "HEND"). En Klipper, `driver_XXX` y SET_TMC_FIELD siempre establecen el valor del campo de bajo nivel que realmente se escribe en el controlador. Entonces, por ejemplo, si la hoja de datos Trinamic establece que se debe escribir un valor de 3 en el campo HEND para obtener un "final de histéresis" (“hysteresis end” en inglés) de 0, establezca `driver_HEND=3` para obtener el valor de alto nivel de 0.

## <strong>Preguntas más frecuentes</strong>

### ¿Puedo usar el modo stealthChop en un extrusor con avance de presión (“pressure advance” en inglés)?

Muchas personas utilizan con éxito el modo "stealthChop" con el avance de presión de Klipper. Klipper implementa [avance de presión fluido](Kinematics.md#pressure-advance) que no introduce ningún cambio de velocidad instantáneo.

Sin embargo, el modo “stealthChop” puede causar que el par de torsión sea más bajo y/o causar que el motor produzca más calor. Puede o no ser un modo adecuado para su impresora en particular.

### ¿Sigo recibiendo errores de “No se puede leer el registro IFCNT del tmc uart ‘stepper_x’” (“Unable to read tmc uart 'stepper_x' register IFCNT” en inglés)?

Esto ocurre cuando Klipper no puede comunicarse con un controlador tmc2208 o tmc2209.

Asegúrese de que la motor esté energizado, ya que el controlador del motor paso a paso generalmente necesita tener energía antes de poder comunicarse con el microcontrolador.

Si este error ocurre después de actualizar por flash (“flashing” en inglés) a Klipper por primera vez, entonces el controlador del motor paso a paso puede haber sido programado previamente en un estado que no es compatible con Klipper. Para reinicializar el estado, desconecte toda fuente de energía de la impresora por varios segundos (desconecte físicamente tanto el USB como los enchufes).

De lo contrario, este error suele ser el resultado de un cableado incorrecto del pin UART o una configuración incorrecta de Klipper de los ajustes del pin UART.

### ¿Sigo recibiendo errores de "No se puede escribir al registro 'stepper_x' del tmc spi..." (“Unable to write tmc spi 'stepper_x' register ...” en inglés)?

Esto ocurre cuando Klipper no puede comunicarse con un controlador tmc2130 o tmc5160.

Asegúrese de que la motor esté energizado, ya que el controlador del motor paso a paso generalmente necesita tener energía antes de poder comunicarse con el microcontrolador.

De lo contrario, este error suele ser el resultado de un cableado incorrecto en el bus SPI (del inglés Serial Peripheral Inerface), de errores en la configuración de los ajustes del bus SPI en Klipper o una configuración incompleta de los dispositivos en un bus SPI.

Tenga en cuenta que si el controlador está en un bus SPI compartido con varios dispositivos, debe asegurarse de configurar completamente todos los dispositivos en ese bus SPI compartido en Klipper. Si un dispositivo en un bus SPI compartido no está configurado, puede responder incorrectamente a comandos no destinados a él y corromper la comunicación con el dispositivo previsto. Si hay un dispositivo en un bus SPI compartido que no se puede configurar en Klipper, entonces use una [sección de configuración static_digital_output](Config_Reference.md#static_digital_output) para ajustar el pin CS del dispositivo no utilizado a alto (para que no intente usar el bus SPI). El esquema de la placa es a menudo una referencia útil para encontrar qué dispositivos están en un bus SPI y sus pines asociados.

### ¿Por qué recibí un error "TMC reports error: ..."?

Este tipo de error indica que el controlador TMC detectó un problema y se ha desactivado a sí mismo. Es decir, el controlador dejó de mantener su posición e ignoró los comandos de movimiento. Si Klipper detecta que un controlador activo se ha desactivado a sí mismo, hará que la impresora pase a un estado de "apagado".

También es posible que ocurra un apagado del tipo **TMC informa de un error** (“**TMC reports error**” en inglés) debido a errores del bus SPI que impidan la comunicación con el controlador (en tmc2130, tmc5160, o tmc2660). Si esto ocurre, es común que el estado del controlador reportado muestre `00000000` o `ffffffff`, por ejemplo: `TMC informa de un error: DRV_STATUS: ffffffff ...` (`TMC reports error: DRV_STATUS: ffffffff ...` en inglés) O `TMC informa de un error: READRSP@RDSEL2: 00000000 ...` (`TMC reports error: READRSP@RDSEL2: 00000000 ...` en inglés). Tal falla puede deberse a un problema con el cableado del SPI o puede deberse a un reinicio automático o una falla del controlador TMC.

Algunos errores comunes y consejos para diagnosticarlos:

#### TMC informa de un error: `... ot=1(OvertempError!)`

Esto indica que el controlador del motor se desactivó de forma autónoma porque se calentó demasiado. Las soluciones típicas son disminuir la corriente del motor paso a paso, aumentar la refrigeración en el controlador del motor paso a paso y/o aumentar la refrigeración en el motor paso a paso.

#### TMC informa de error: `... ShortToGND` O `ShortToSupply`

Esto indica que el controlador se ha desactivado a sí mismo porque detectó una corriente muy alta que pasaba a través de él. Esto puede indicar un cable suelto o en cortocircuito al motor paso a paso o dentro del propio motor paso a paso.

Este error también puede ocurrir si se está utilizando el modo stealthChop y el controlador TMC no puede predecir con precisión la carga mecánica del motor. (Si el controlador hace una predicción deficiente, puede enviar demasiada corriente a través del motor y desencadenar su propia detección de sobrecorriente.) Para probar esto, deshabilite el modo stealthChop y verifique si los errores continúan ocurriendo.

#### TMC informa error: `... reset=1(Reset)` OR `CS_ACTUAL=0(Reset?)` O `SE=0(Reset?)`

Esto indica que el controlador se ha reiniciado de forma autónoma a mitad de la impresión. Esto puede deberse a problemas de voltaje o de cableado.

#### TMC informa de error: `... uv_cp=1(Undervoltage!)`

Esto indica que el controlador ha detectado un evento de bajo voltaje y se ha desactivado a sí mismo. Esto puede deberse a problemas con el cableado o la fuente de alimentación.

### ¿Cómo afino el modo spreadCycle/coolStep/etc. en mis controladores?

El [sitio web de Trinamic](https://www.trinamic.com/) tiene guías sobre la configuración de los controladores. Estas guías suelen ser técnicas, de bajo nivel y pueden requerir hardware especializado. En cualquier caso, son la mejor fuente de información.
