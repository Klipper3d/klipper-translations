# Sensore TSL1401CL di larghezza del filamento

Questo documento descrive il modulo host del sensore di larghezza del filamento (Filament Width Sensor). L'hardware utilizzato per lo sviluppo di questo modulo host si basa sull'array di sensori lineari TSL1401CL, ma può funzionare con qualsiasi array di sensori dotato di uscita analogica. Puoi trovare design su [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

Per utilizzare un array di sensori come sensore di larghezza del filamento, leggere [Config Reference](Config_Reference.md#tsl1401cl_filament_width_sensor) e [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Come funziona?

Il sensore genera un'uscita analogica in base alla larghezza calcolata del filamento. La tensione di uscita è sempre uguale alla larghezza del filamento rilevata (es. 1.65v, 1.70v, 3.0v). Il modulo host monitora le variazioni di tensione e regola il moltiplicatore di estrusione.

## Note:

Letture del sensore eseguite con intervalli di 10 mm predefiniti Se necessario, sei libero di modificare questa impostazione modificando il parametro ***MEASUREMENT_INTERVAL_MM*** nel file **filament_width_sensor.py**.
