# Nivelación de la cama

El nivelado de la base (aveces tambien llamado "bed tramming") es un proceso critico para obtener impresiones de gran calidad. Si la base no esta correctamente "nivelada" puede producirse una mala adherencia, "warping" (despegue de las esquinas) asi como problemas sutiles durante la impresion. Este documento sirve como una guia para realizar el nivelado de la base en Klipper.

Es importante entender el objetivo de la nivelacion de la base. Si a la impresora le es comandado ir a la posicion `X0 Y0 Z10` durante una impresion, el objetivo de la boquilla es quedar exactamente a 10mm sobre la base de la impresora. Por lo que, si a la impresora le es comandado ir la posicion `X50 Z10` el objetivo es que la boquilla se mantenga a una distancia exacta de 10mm sobre la base durante todo el movimiento horizontal.

Para obtener impresiones de buena calidad, la impresora debe estar calibrada para que las distancias Z tengan una precisión de unas 25 micras (.025mm). Esta es una distancia pequeña - significativamente menor que el ancho de un cabello humano. Esta escala no puede medirse "a ojo". Los efectos sutiles (como la expansión térmica) afectan a las mediciones a esta escala. El secreto para conseguir una gran precisión es utilizar un proceso repetible y utilizar un método de nivelación que aproveche la alta precisión del sistema de movimiento de la propia impresora.

## Elija el mecanismo de calibración apropiado

Los distintos tipos de impresoras utilizan diferentes métodos para realizar la nivelación de la cama. Todos ellos dependen, en última instancia, de la "prueba del papel" (descrita a continuación). Sin embargo, el proceso para algun tipo particular de impresora se describe en otros documentos.

Antes de ejecutar cualquiera de estas herramientas de calibración, asegúrese de realizar las comprobaciones descritas en el documento [Verificación de la configuración](Config_checks.md). Es necesario verificar el movimiento básico de la impresora antes de realizar la nivelación de la cama.

Para las impresoras con una "sensor Z automático", asegúrese de calibrar el sensor siguiendo las instrucciones del documento [Probe Calibrate](Probe_Calibrate.md). Para las impresoras delta, consulte el documento [Delta Calibrate](Delta_Calibrate.md). Para impresoras con tornillos en la base y finales de carrera tradicionales en el eje Z, consulte el documento [Manual Level](Manual_Level.md).

Durante la calibración puede ser necesario ajustar la `position_min` Z de la impresora a un número negativo (por ejemplo, `position_min = -2`). La impresora aplica las comprobaciones de límites incluso durante las rutinas de calibración. Establecer un número negativo permite que la impresora se mueva por debajo de la posición nominal de la base, lo que puede ayudar a intentar determinar la posición real de la base.

## La "prueba del papel"

El principal mecanismo de calibración de la cama es la "prueba de papel". Consiste en colocar un trozo regular de "papel de fotocopiadora" entre la cama y la boquilla de la impresora, y luego comandar la boquilla a diferentes alturas Z hasta que uno sienta una pequeña cantidad de fricción al empujar el papel hacia adelante y hacia atrás.

Es importante entender la "prueba del papel" aunque se tenga un "sensor Z automático". A menudo es necesario calibrar el propio sensor para obtener buenos resultados. Esa calibración del sensor se realiza mediante esta "prueba de papel".

Para realizar la prueba del papel, corte un pequeño trozo rectangular de papel usando un par de tijeras (por ejemplo de 5x3 centímetros). El papel normalmente tiene un grosor alrededor de 100 micras (0.1 milímetros). (El grosor exacto del papel no es crucial.)

El primer paso de la prueba del papel es inspeccionar la boquilla y la base de la impresora. Asegúrese de que no hay plástico (u otros residuos) en la boquilla o en la base.

**¡Inspeccione la boquilla y la base para asegurarse de que no hay plástico!**

Si uno siempre imprime en una cinta en particular o en una superficie de impresión entonces puede realizar la prueba del papel con esa cinta/superficie en su lugar. Sin embargo, nótese que esa cinta en sí misma y otras cintas (o cualquier otra superficie de impresión) afectarán las medidas de Z. Esté seguro de repetir el test del papel para medir cada tipo de superficie que esté en uso.

Si hay plástico en la boquilla, caliente el extrusor y utilize una pinza metálica para eliminar ese plástico. Espere a que el extrusor se enfríe a temperatura ambiente antes de continuar con la prueba del papel. Mientras se enfría la boquilla, utiliza las pinzas metálicas para eliminar el plástico que pueda gotear.

**¡Realice siempre la prueba del papel cuando tanto la boquilla como la base se encuentren a temperatura ambiente!**

Cuando la boquilla es calentada, su exposición (relativa a la cama) cambia debido a la expansión térmica. Esta expansión térmica es típicamente alrededor de 100 micras, lo cual es alrededor del mismo grosor que un trozo de papel típico para impresión. La cantidad exacta de expansión térmica no es crucial, al igual que el grosor exacto del papel no lo es. Comience con la suposición de que ambos son iguales (vea a continuación un método para determinar la diferencia entre ambas distancias).

Puede parecer extraño calibrar la distancia a temperatura ambiente cuando el objetivo es tener una distancia consistente cuando se calienta. Sin embargo, si se calibra cuando la boquilla se calienta, esta tiende a filtrar pequeñas cantidades de plástico fundido sobre el papel, lo que cambia la cantidad de fricción que se siente. Esto hace más difícil conseguir una buena calibración. Calibrar mientras la cama/boquilla está caliente también aumenta en gran medida el riesgo de quemarse. La cantidad de expansión térmica es estable, por lo que se puede tener en cuenta fácilmente más adelante en el proceso de calibración.

**¡Usa una herramienta automatizada para determinar las alturas precisas en Z!**

Klipper dispone de varios scripts de ayuda (por ejemplo, MANUAL_PROBE, Z_ENDSTOP_CALIBRATE, PROBE_CALIBRATE, DELTA_CALIBRATE). Consulte los documentos [described above](#elegir-el-mecanismo-de-calibración-apropiado) para elegir uno de ellos.

Ejecute el comando correspondiente en la ventana del terminal OctoPrint. El script solicitará la interacción del usuario en la salida del terminal OctoPrint. Tendrá un aspecto similar al siguiente:

```
Recv: // Starting manual Z probe. Use TESTZ to adjust position.
Recv: // Finish with ACCEPT or ABORT command.
Recv: // Z position: ?????? --> 5.000 <-- ??????
```

La altura actual de la boquilla (tal y como lo entiende la impresora en ese momento) se muestra entre los "--> <--". El número a la derecha es la altura del último intento de sondeo justo mayor que la altura actual, y a la izquierda es el último intento de sondeo menor que la altura actual (o ?????? si no se ha hecho ningún intento).

Coloque el papel entre la boquilla y la base. Puede ser útil doblar una esquina del papel para que sea más fácil de agarrar. (Procura no empujar hacia abajo la base cuando muevas el papel hacia delante y hacia atrás.)

![paper-test](img/paper-test.jpg)

Utilize el comando TESTZ para comandar a la boquilla a moverse más cerca del papel. Por ejemplo:

```
TESTZ Z=-.1
```

El comando TESTZ moverá la boquilla una distancia relativa desde la posición actual de la boquilla. (Así, `Z=-.1` comanda que la boquilla se acerque a la cama en 0,1mm). Después de que la boquilla deje de moverse, empuje el papel hacia adelante y hacia atrás para comprobar si la boquilla está en contacto con el papel y para sentir la cantidad de fricción. Continúe emitiendo comandos TESTZ hasta que se sienta una pequeña cantidad de fricción al probar con el papel.

Si se encuentra demasiada fricción, se puede utilizar un valor Z positivo para mover la boquilla hacia arriba. También es posible utilizar `TESTZ Z=+` o `TESTZ Z=-` para "bifurcar" la última posición - es decir, para moverse a una posición a medio camino entre dos posiciones. Por ejemplo, si uno recibe la siguiente indicación de un comando `TESTZ`:

```
Recv: // Z position: 0.130 --> 0.230 <-- 0.280
```

Entonces un `TESTZ Z=-` movería la boquilla a una posición Z de 0,180 (a medio camino entre 0,130 y 0,230). Se puede utilizar esta función para ayudar a reducir rápidamente a una fricción consistente. También es posible utilizar `Z=++` y `Z=--` para volver directamente a una medición pasada - por ejemplo, después de la indicación anterior un comando `TESTZ Z=--` movería la boquilla a una posición Z de 0.130.

Después de encontrar una pequeña cantidad de fricción envíe el comando ACEPTAR :

```
ACEPTAR
```

Esto aceptará la altura en Z dada y continuara con la herramienta de calibración.

La cantidad exacta de fricción no es crucial, al igual que la cantidad de expansión térmica y la anchura exacta del papel no son cruciales. Sólo hay que intentar obtener la misma cantidad de fricción cada vez que se realiza la prueba.

Si algo va mal durante la prueba, se puede utilizar el comando `ABORT` para salir de la herramienta de calibración.

## Determinando la Expansión Térmica

Tras haber realizado la nivelación de la cama con éxito, uno puede proceder a calcular un valor más preciso para el impacto combinado de la "expansión térmica", "grosor del papel", y "cantidad de fricción sentida durante la prueba del papel".

Este tipo de cálculos no son normalmente necesarios ya que la mayoría de usuarios encuentran que el simple "test de papel" da buenos resultados.

La manera más sencilla de realizar este cálculo es imprimir un objeto de prueba que tiene paredes rectas en todos los lados. Podemos usar el gran cuadrado hueco encontrado en [docs/prints/square.stl](prints/square.stl) para ello. Al rebanar el objeto, asegúrese de que el rebanador usa la misma altura de capa y anchura de extrusión tanto para el primer nivel como para las subsiguientes capas. Usa una altura de capa gruesa (la altura de la capa debería ser alrededor de un 75% del diámetro de la boquilla) y no uses un borde o balsa.

Imprime el objeto de prueba, espera que se enfríe, y quítalo de la cama. Inspecciona la capa más baja del objeto. (También puede ser útil recorrer el dedo o un clavo a lo largo del eje inferior.) Si encuentras que la capa inferior se hincha al rededor de todos los lados del objeto, esto indica que la boquilla estaba levemente mas cerca de la cama de lo que debería. Puedes utilizar el comando `SET_GCODE_OFFSET Z=+.010` para incrementar la altura. En las impresiones subsecuentes puedes analizar este comportamiento y realizar ajustes adicionales según sean necesarios. Ajustes de este tipo son típicamente en decenas de micras (.010 milímetros).

Si la capa inferior aparece consecuentemente más estrecha que las capa subsecuentes entonces puedes usar el comando SET_GCODE_OFFSET para realizar un ajuste negativo a Z. Si no estás seguro, puedes disminuir el ajuste de Z hasta que la capa inferior de las impresiones muestre un pequeño bulto, y entonces apartarse hasta que desaparezca.

La forma más sencilla de aplicar el ajuste Z deseado es crear una macro g-code START_PRINT, hacer los arreglos para que el rebanador llame a la macro durante el inicio de cada impresión, y añadir un comando SET_GCODE_OFFSET a la macro. Héchale un ojo al documento [rebanadores](Slicers.md) para más detalles.
