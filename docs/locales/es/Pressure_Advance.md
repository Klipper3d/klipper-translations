# Avance de presión

Este documento provee información sobre el ajuste de variable de configuración "avance de presión" para un rociador y filamento particular. La función "avance de presión" puede ser de ayuda en la reducción del rezumado. Para más información acerca de cómo "avance de presión" está implementada, vea el documento de [cinemática](Kinematics.md).

## Ajustando del avance de presión

El Avance de presión hace dos cosas útiles - reduce el rezumado durante movimientos no extrudentes y reduce el goteo durante el esquinado. Esta guía usa la segunda característica (reducir el goteo durante el esquinado) como un mecanismo para el ajuste.

Para calibrar el avance de presión la impresora debe ser configurada y estar operacional, ya que la prueba de ajuste involucra imprimir e inspeccionar un objeto de prueba. Es una buena idea el leer este documento en su totalidad previo al ejecutar la prueba.

Use un rebanador para generar el código G para el cuadrado grande hueco que se encuentra en [docs/prints/square_tower.stl](prints/square_tower.stl). Use una velocidad alta (e.g. 100mm/s), cero relleno, y una altura de capa gruesa (la altura de capa debería estar entorno del 75% del diámetro del rociador). Asegúrese de que cualquier "control de aceleración dinámica" está deshabilitado en el rebanador.

Prepare para la prueba mediante el envío del siguiente comando en código G:

```
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
```

Este comando hace que el rociador recorra de forma más lenta por las esquinas para enfatizar los efectos de la presión de extrusión. Entonces, para impresoras con un extrusor de manejo directo, ejecute el comando:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

Para extrusores de Bowden utilice:

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020
```

Entonces imprima el objeto. Cuando este totalmente impresa, la prueba de impresión debería asemejarse a:

![tuning_tower](img/tuning_tower.jpg)

El comando TUNING_TOWER precedente instruye a Klipper de alterar la configuración de Avance de presión en cada capa de la impresión. Las capas más altas en la impresión tendrán establecido un Avance de presión más alto.

Uno puede cancelar la impresión tempranamente si observa que las esquinas no se están imprimiendo bien (y por ende se puede evitar imprimir capas que ya se sepa que estén por encima del valor ideal de Avance de presión).

Inspeccione la impresión y entonces use calibres digitales para encontrar la altura que tienen las esquinas de mejor calidad. En la duda, prefiera una altura menor.

![tune_pa](img/tune_pa.jpg)

El Avance de presión (pressure_advance) puede ser calculado como `pressure_advance = <comienzo> + <altura_medida> * <factor>`. (Por ejemplo, `0 + 12.90 * .020` sería `.258`.)

Es posible elegir configuraciones personalizadas para START y FACTOR si eso ayuda a identificar la mejor configuración de Avance de presión. Cuando se haga esto, esté seguro de enviar el comando TUNING_TOWER al comienzo de cada prueba de impresión.

Los valores típicos de Avance de presión se encuentran entre 0.050 y 1.000 (el extremo superior usualmente corresponde a los extrusores Bowden). Si no hay una mejora significativa con un Avance de presión al 1.000, entonces el Avance de presión es improbable que mejore la calidad de las impresiones. Retorne a la configuración por defecto con el Avance de presión deshabilitado.

Si bien este ejercicio del ajuste mejora directamente la calidad de las esquinas, vale recordar que una buena configuraciónde Avance de presión también reduce el rezumado durante toda la impresión.

En la finalización de esta prueba, establezca `pressure_advance = <valor_calculado>` en la sección `[extruder]` del archivo de configuración y envíe un comando RESTART. El comando RESTART quitará el estado de prueba y retornará la las velocidades de aceleración y esquinado a sus valores normales.

## Notas Importantes

* El valor del Avance de presión es dependiente del extrusor, el rociador y el filamento. Es común que para filamentos de diferentes fabricantes o con diferentes pigmentos se requiera valores diferentes de Avance de presión. Entonces, uno debería calibrar el Avance de presión en cada impresora y cada bobina de filamento.
* La temperatura de impresión y los tasas de extrusión pueden impactar el Avance de presión. Asegúrese de ajustar la [distancia de rotación (rotation_distance) del extrusor](Rotation_Distance.md#calibrating-rotation_distance-on-extruders) y la [temperatura del rociador](http://reprap.org/wiki/Triffid_Hunter%27s_Calibration_Guide#Nozzle_Temperature) antes de ajustar Avance de presión.
* La prueba de impresión está designada para correr con una tasa alta de flujo de extrusor, pero con configuraciones "normales" para el rebanador. Una tasa alta de flujo se obtiene usando una velocidad alta de impresión (e.g. 100 mm/s) y una altura gruesa de capa (típicamente alrededor del 75% del diámetro del rociador). Otras configuraciones del rebanador deberían ser similar a sus valores por defect (e.g. perímetros de 2 o 3 líneas, cantidad normal de retracción). Puede ser útil el establecer la velocidad externa de perímetro a la misma velocidad que el resto de impresión, pero no es un requerimiento.
* Es común para la prueba de impresión el mostrar comportamientos diferentes en cada esquina. Comúnmente el rebanador dispondrá el cambio de capas en una esquina lo que puede resultar en que la misma sea significativamente diferente de las restantes tres. Si esto ocurre, entonces ignore la esquina y ajuste Avance de presión usando las otras tres esquinas. Es también común para las esquinas restantes el variar ligeramente. (Esto puede ocurrir debido a pequeñas diferencias en cómo el marco de la impresora reacciona al esquinado en determinadas direcciones.) Intente elegir un valor que funcione bien para todas las restantes esquinas. En la duda, prefiera un valor menor de Avance de presión.
* Si un valor alto de Avance de presión (e.g. sobre 0.200) es usado, entonces uno puede encontrar que el extrusor omite cuando retorna a la aceleración normal de la impresora. El sistema de Avance de presión considera la presión mediante un empuje extra del filamentos durante la aceleración y retractando ese filamento durante la desaceleración. Con una alta aceleración y con un alto Avance de presión el extrusor puede no tener suficiente esfuerzo de torsión (torque) para empujar el filamento requerido. Si esto ocurre, o bien use un valor más bajo de aceleración o desactive el Avance de presión.
* Una vez que el Avance de presión ha sido ajustado en Klipper, puede ser todavía útil el configurar un valor pequeño de retracción en el rebanador (e.g. 0.75 mm) y el utilizar la opción de "limpiar cuando se retrae" si está disponible. Esas configuraciones de rebanador puede ayudar a contrarrestar el rezumando causado por la cohesión del filamento (el filamento se ha salido del rociador debido a lo pegajoso del plástico). Se recomienda el deshabilitar la opción de "subir-z cuando se retrae".
* El sistema de Avance de presión no cambia el tiempo o camino del cabezal. Una impresión con el Avance de presión habilitado tomará la misma cantidad de tiempo que una sin la misma. El Avance de presión también no cambia la cantidad total del filamento extrudido durante una impresión. El Avance de presión produce un movimiento extra del extrusor durante la aceleración y desaceleración. Una configuración muy alta de Avance de presión resultará en una muy grande cantidad de movimiento del extrusor durante la aceleración y desaceleración, y ninguna opción de configuración pone un límite sobre la cantidad de ese movimiento.
