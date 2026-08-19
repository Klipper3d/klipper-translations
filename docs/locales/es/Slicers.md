# Rebanadores

Este documento provee algunas sugerencias para configurar una aplicación "slicer" para usar con Klipper. Algunos de los slicers mas comúnmente usados con Klipper son Slic3r, Cura, Simplify3D, etc.

## Establecer el tipo de código G en Marlin.

Muchas cortadoras tienen una opción para configurar el «G-Code flavor». El valor predeterminado suele ser «Marlin», que funciona bien con Klipper. La configuración «Smoothieware» también funciona bien con Klipper, Ahora ya se puede indicar «Klipper» como valor en diferentes laminadores.

## Klipper gcode_macro

Los cortadores suelen permitir configurar secuencias de «G-Code de inicio» y «G-Code de fin». A menudo resulta conveniente definir macros personalizadas en el archivo de configuración de Klipper, como por ejemplo: `[gcode_macro START_PRINT]` y `[gcode_macro END_PRINT]`. De este modo, basta con ejecutar START_PRINT y END_PRINT en la configuración del cortador. Definir estas acciones en la configuración de Klipper puede facilitar el ajuste de los pasos de inicio y finalización de la impresora, ya que los cambios no requieren volver a cortar.

Consulte [sample-macros.cfg](../config/sample-macros.cfg) para ver ejemplos de las macros START_PRINT y END_PRINT.

Consulte la [referencia de configuración](Config_Reference.md#gcode_macro) para obtener más información sobre cómo definir una macro gcode_macro.

## Large retraction settings may require tuning Klipper

The maximum speed and acceleration of retraction moves are controlled in Klipper by the `max_extrude_only_velocity` and `max_extrude_only_accel` config settings. These settings have a default value that should work well on many printers. However, if one has configured a large retraction in the slicer (eg, 5mm or greater) then one may find they limit the desired speed of retractions.

If using a large retraction, consider tuning Klipper's [pressure advance](Pressure_Advance.md) instead. Otherwise, if one finds the toolhead seems to "pause" during retraction and priming, then consider explicitly defining `max_extrude_only_velocity` and `max_extrude_only_accel` in the Klipper config file.

## Do not enable "coasting"

The "coasting" feature is likely to result in poor quality prints with Klipper. Consider using Klipper's [pressure advance](Pressure_Advance.md) instead.

Specifically, if the slicer dramatically changes the extrusion rate between moves then Klipper will perform deceleration and acceleration between moves. This is likely to make blobbing worse, not better.

In contrast, it is okay (and often helpful) to use a slicer's "retract" setting, "wipe" setting, and/or "wipe on retract" setting.

## Do not use "extra restart distance" on Simplify3d

This setting can cause dramatic changes to extrusion rates which can trigger Klipper's maximum extrusion cross-section check. Consider using Klipper's [pressure advance](Pressure_Advance.md) or the regular Simplify3d retract setting instead.

## Disable "PreloadVE" on KISSlicer

If using KISSlicer slicing software then set "PreloadVE" to zero. Consider using Klipper's [pressure advance](Pressure_Advance.md) instead.

## Disable any "advanced extruder pressure" settings

Some slicers advertise an "advanced extruder pressure" capability. It is recommended to keep these options disabled when using Klipper as they are likely to result in poor quality prints. Consider using Klipper's [pressure advance](Pressure_Advance.md) instead.

Specifically, these slicer settings can instruct the firmware to make wild changes to the extrusion rate in the hope that the firmware will approximate those requests and the printer will roughly obtain a desirable extruder pressure. Klipper, however, utilizes precise kinematic calculations and timing. When Klipper is commanded to make significant changes to the extrusion rate it will plan out the corresponding changes to velocity, acceleration, and extruder movement - which is not the slicer's intent. The slicer may even command excessive extrusion rates to the point that it triggers Klipper's maximum extrusion cross-section check.

In contrast, it is okay (and often helpful) to use a slicer's "retract" setting, "wipe" setting, and/or "wipe on retract" setting.

## START_PRINT macros

When using a START_PRINT macro or similar, it is useful to sometimes pass through parameters from the slicer variables to the macro.

In Cura, to pass through temperatures, the following start gcode would be used:

```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

In slic3r derivatives such as PrusaSlicer and SuperSlicer, the following would be used:

```
START_PRINT EXTRUDER_TEMP=[first_layer_temperature] BED_TEMP=[first_layer_bed_temperature]
```

Also note that these slicers will insert their own heating codes when certain conditions are not met. In Cura, the existence of the `{material_bed_temperature_layer_0}` and `{material_print_temperature_layer_0}` variables is enough to mitigate this. In slic3r derivatives, you would use:

```
M140 S0
M104 S0
```

before the macro call. Also note that SuperSlicer has a "custom gcode only" button option, which achieves the same outcome.

An example of a START_PRINT macro using these parameters can be found in config/sample-macros.cfg
