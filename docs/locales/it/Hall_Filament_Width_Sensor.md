# Sensore di Hall per larghezza del filamento

This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on two Hall linear sensors (ss49e for example). Sensors in the body are located on opposite sides. Principle of operation: two hall sensors work in differential mode, temperature drift same for sensor. Special temperature compensation not needed.

Puoi trovare i design su [Thingiverse](https://www.thingiverse.com/thing:4138933), un video di assemblaggio è disponibile anche su [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4 )

Per utilizzare il sensore di larghezza del filamento Hall, leggere [Config Reference](Config_Reference.md#hall_filament_width_sensor) e [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Come funziona?

Sensor generates two analog output based on calculated filament width. Sum of output voltage always equals to detected filament width. Host module monitors voltage changes and adjusts extrusion multiplier. I use the aux2 connector on a ramps-like board with the analog11 and analog12 pins. You can use different pins and different boards.

## Modello per variabili di menu

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## Procedura di calibrazione

Per ottenere il valore grezzo del sensore è possibile utilizzare la voce di menu o il comando **QUERY_RAW_FILAMENT_WIDTH** nel terminale.

1. Inserire la prima barra di calibrazione (dimensione 1,5 mm) ottenere il primo valore grezzo del sensore
1. Inserire la seconda barra di calibrazione (dimensione 2,0 mm) per ottenere il secondo valore grezzo del sensore
1. Salva i valori grezzi del sensore nel parametro di configurazione `Raw_dia1` e `Raw_dia2`

## Come abilitare il sensore

Per impostazione predefinita, il sensore è disabilitato all'accensione.

Per abilitare il sensore, emettere il comando **ENABLE_FILAMENT_WIDTH_SENSOR** o impostare il parametro `enable` su `true`.

## Registrazione

Per impostazione predefinita, la registrazione del diametro è disabilitata all'accensione.

Emettere il comando **ENABLE_FILAMENT_WIDTH_LOG** per avviare la registrazione ed emettere il comando **DISABLE_FILAMENT_WIDTH_LOG** per interrompere la registrazione. Per abilitare la registrazione all'accensione, impostare il parametro `logging` su `true`.

Il diametro del filamento viene registrato con un intervallo di misurazione (10 mm per impostazione predefinita).
