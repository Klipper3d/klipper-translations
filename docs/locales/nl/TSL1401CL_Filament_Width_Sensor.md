# TSL1401CL filamentdiametersensor

Dit document beschrijft de filamentdiametersensor-hostmodule. De gebruikte hardware voor de ontwikkeling van deze hostmodule is gebaseerd op de TSL1401CL-sensor maar werkt met elke sensor van dit type met analoge output. U kunt het ontwerp vinden op [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

Lees [configreferenties](Config_Reference.md#tsl1401cl_filament_width_sensor) en de [G-code documentatie](G-Codes.md#hall_filament_width_sensor) om deze sensor te gebruiken.

## Hoe werkt het?

De sensor genereert een analoge output gebaseerd op de berekende filamentdiameter. De uitgangsvoltage is altijd gelijk aan de gemeten diameter (bijv. 1,75v, 3,00v). De hostmodule meet de spanning en past daar zijn vermenigvuldigingsfactor op aan.

## Let op:

De metingen worden gedaan bij een standaard interval van 10 mm. Dit kan gewijzigd worden door de instelling ***MEASUREMENT_INTERVAL_MM*** in **filament_width_sensor.py** aan te passen.
