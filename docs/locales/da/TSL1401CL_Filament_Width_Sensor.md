# TSL1401CL filament-bredde sensor

Dette dokument beskriver Filament-Bredde sensor værtsmodulet. Hardwaren brugt til udvikling af dette modul er baseret på TSL1401CL Linær sensor-array, men modulet kan bruges med alle sensorer der har analogt output. Du kan finde forskellige designs på: [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

For at bruge et sensor array som filament-bredde sensor, læs [Konfigurationsreferencen](Config_Reference.md#tsl1401cl_filament_width_sensor) og [G-Kode Dokumentationen](G-Codes.md#hall_filament_width_sensor).

## Hvordan virker det?

Sensoren producerer et analogt output baseret på beregnet filament-bredde. Output spændingen er altid lig med den målte bredde (f.eks. 1,65v, 1,70v, 3,0v). Værtsmodulet overvåger ændringerne i spændingen og justerer "Extrusion Multiplier".

## Note:

Sensoren måler som standard hver 10mm. Hvis nødvendigt kan dette frit ændres under ***MEASUREMENT_INTERVAL_MM*** parametren i **filament_width_sensor.py** filen.
