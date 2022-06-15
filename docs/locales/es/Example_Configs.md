# Configuraciones de ejemplo

Este documento contiene pautas para contribuir una configuración de ejemplo de Klipper al repositorio de GitHub de Klipper (localizado en el [directorio de conifguración](../config/)).

Nótese que el [servidor de discusión de la comunidad de Klipper](https://community.klipper3d.org) es también un recurso útil para encontrar y compartir archivos de configuración.

## Pautas

1. Selecciona el prefijo del nombre del archivo de configuración apropiado:
   1. El prefijo `printer` es usado para impresoras comunes vendidas por los fabricantes principales.
   1. El prefijo `generic`es usado para una placa de impresión 3d que puede ser utilizada en varios tipos de impresoras.
   1. The `kit` prefix is for 3d printers that are assembled according to a widely used specification. These "kit" printers are generally distinct from normal "printers" in that they are not sold by a manufacturer.
   1. El prefijo `sample` es usado para "cachos" de configuración que uno puede copiar y pegar en el archivo de configuración principal.
   1. El prefijo `example` es usado para describir la cinemática de impresoras. Este tipo de configuración es típicamente añadido solamente junto a código para un nuevo tipo de cinemática de impresoras.
1. All configuration files must end in a `.cfg` suffix. The `printer` config files must end in a year followed by `.cfg` (eg, `-2019.cfg`). In this case, the year is an approximate year the given printer was sold.
1. No use espacios o caracteres especiales en el nombre del archivo de configuración. El nombre del archivo debería contener solamente los caracteres `A-Z`, `a-z`, `0-9`, `-`, y `.`.
1. Klipper must be able to start `printer`, `generic`, and `kit` example config file without error. These config files should be added to the [test/klippy/printers.test](../test/klippy/printers.test) regression test case. Add new config files to that test case in the appropriate section and in alphabetical order within that section.
1. The example configuration should be for the "stock" configuration of the printer. (There are too many "customized" configurations to track in the main Klipper repository.) Similarly, we only add example config files for printers, kits, and boards that have mainstream popularity (eg, there should be at least a 100 of them in active use). Consider using the [Klipper Community Discourse server](https://community.klipper3d.org) for other configs.
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. Do not specify `pressure_advance` in an example config, as that value is specific to the filament, not the printer hardware. Similarly, do not specify `max_extrude_only_velocity` nor `max_extrude_only_accel` settings.
   1. No especifique una sección de configuración que contenga una ruta o hardware en el anfitrión. Por ejemplo, no especifique ni la sección de configuración `[virtual_sdcard]` ni `[temperature_host]`.
   1. Solamente defina macros que utilicen funcionalidades específicas para la impresora dada o para definir códigos G que son comúnmente emitidos por los rebanadores configurados para dicha impresora.
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. Do not copy the field documentation into the example config files. (Doing so creates a maintenance burden as an update to the documentation would then require changing it in many places.)
   1. Example config files should not contain a "SAVE_CONFIG" section. If necessary, copy the relevant fields from the SAVE_CONFIG section to the appropriate section in the main config area.
   1. Use la sintaxis `campo: valor` en vez de `campo=valor`.
   1. When adding an extruder `rotation_distance` it is preferable to specify a `gear_ratio` if the extruder has a gearing mechanism. We expect the rotation_distance in the example configs to correlate with the circumference of the hobbed gear in the extruder - it is normally in the range of 20 to 35mm. When specifying a `gear_ratio` it is preferable to specify the actual gears on the mechanism (eg, prefer `gear_ratio: 80:20` over `gear_ratio: 4:1`). See the [rotation distance document](Rotation_Distance.md#using-a-gear_ratio) for more information.
   1. Evite definir valores de campos que estén puestos a su valor por defecto. Por ejemplo, uno no debería especificar `min_extrude_temp: 170` ya que ese ya es el valor por defecto.
   1. Donde sea posible, las líneas no deberían ser de más de 80 caracteres de largo.
   1. Avoid adding attribution or revision messages to the config files. (For example, avoid adding lines like "this file was created by ...".) Place attribution and change history in the git commit message.
1. No utilice ninguna funcionalidad obsoleta en la archivo de configuración de ejemplo.
1. Do not disable a default safety system in an example config file. For example, a config should not specify a custom `max_extrude_cross_section`. Do not enable debugging features. For example there should not be a `force_move` config section.
1. Todas las placas conocidas que Klipper soporta pueden usar la tasa de baudios por defecto que es 250000. No recomiende una tasa de baudios diferente en el archivo de configuración de ejemplo.

Example config files are submitted by creating a github "pull request". Please also follow the directions in the [contributing document](CONTRIBUTING.md).
