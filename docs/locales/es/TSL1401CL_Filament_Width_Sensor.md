# sensor de anchura del filamento TSL1401CL

Este documento describe el módulo anfitrión del sensor de anchura del filamento. El hardware usado para desarrollar este módulo anfitrión está basado en el conjunto de sensores lineares TSL1401CL pero puede funcionar con cualquier otro conjunto de sensores que tenga una salida analógica. Puede encontrar diseños en [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

Para usar un conjunto de sensores como un sensor de anchura del filamento, léase la [Referencia de Configuración](Config_Reference.md#tsl1401cl_filament_width_sensor) y la [Documentación de Códigos G](G-Codes.md#hall_filament_width_sensor).

## Cómo funciona?

El sensor genera una salida analógica basada en la anchura calculada del filamento. El voltaje de salida siempre equivale a la anchura calculada del filamento (por ejemplo, 1.65V, 1.7V, 3V). El módulo anfitrión monitorea los cambios de voltaje y ajusta el multiplicador de extrusión.

## Nota:

Las lecturas del sensor son realizadas con intervalos de 10 milímetros por defecto. Si es necesario es usted libre de cambiar esta configuración editando el parámetro ***MEASUREMENT_INTERVAL_MM*** localizado en el archivo **filament_width_sensor.py**.
