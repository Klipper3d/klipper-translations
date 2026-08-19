# Hall filament-bredde sensor

Dette dokument beskriver Filament bredde sensor værts modulet. Hardwaren brugt til udvikling af dette modul er 2 stk. Hall Linære sensorer (ss49e for eksempel). Sensorer i modulet er monteret overfor hinanden. Derved arbejder de ud fra differentialet, med temperatur afvigelser der er ens for begge sensorer. Derfor skal der ikke tages højde for temperatur afvigelserne.

Du kan finde design på [Thingiverse](https://www.thingiverse.com/thing:4138933), en monteringsvideo er også tilgængelig på [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)

For at bruge en Hall filament-bredde sensor, kan du læse [Konfigurationsreference](Config_Reference.md#hall_filament_width_sensor) og [G-kode dokumentationen](G-Codes.md#hall_filament_width_sensor).

## Hvordan virker det?

Sensorerne genererer 2 analoge outputs baseret på den beregnede filament bredde. Summen af signalets styrke vil altid matche den målte filament bredde. Værts modulet overvåger signalet, og justerer ekstrusionen tilsvarende. Jeg har brugt aux2 stikket på et RAMPS-kort via analog11 og analog12 pins. Du kan bruge andre kort og andre pins.

## Skabelon for menu variabler

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

## Kalibrerings procedure

For at få de rå parametere kan du bruge menuen eller sende **QUERY_RAW_FILAMENT_WIDTH** kommandoen i Terminalen.

1. Indsæt først kalibrerings del (1,5mm) for at få første sensor værdi
1. Indsæt anden kalibrerings del (2,0mm) for at få anden sensor værdi
1. Gem sensor værdier i konfigurationsfilen `Raw_dia1` og `Raw_dia2`

## Sådan aktiveres sensoren

Som standard er sensoren deaktiveret ved opstart.

For at aktivere sensoren kan du sende **ENABLE_FILAMENT_WIDTH_SENSOR** kommandoen, eller indstil `enable` parameteren til `true`.

## Use as a runout switch only

By default, the sensor measures filament diameter and adjusts the extrusion multiplier to compensate for variations.

If you want to use the sensor as a runout switch only, set the `enable_flow_compensation` config parameter to `false`. In this mode, the sensor will only trigger runout events when filament is not detected, it will not modify the extrusion multiplier.

This is useful for printers where the filament sensor is not accurate enough for flow compensation but can reliably detect filament runout, or when printing with flexible filaments which have unstable diameter characteristics.

Issue **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=1** to enable flow compensation or **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=0** to disable it.

Note that disabling filament width compensation automatically resets the extrusion multiplier to 100%.

**QUERY_FILAMENT_WIDTH** includes the current state of flow compensation in its output.

## Logning

Som standard er diameter logning deaktiveret ved opstart.

Send **ENABLE_FILAMENT_WIDTH_LOG** kommandoen for at starte logning, og send **DISABLE_FILAMENT_WIDTH_LOG** kommandoen for at stoppe. For at aktivere ved opstart som standard, set parameteren: `logging` til `true`.

Filamentets diameter registreres ved hvert måle interval (10mm som standard).
