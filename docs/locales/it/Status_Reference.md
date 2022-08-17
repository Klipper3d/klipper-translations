# Status reference

Questo documento è un riferimento alle informazioni sullo stato della stampante disponibili in Klipper [macro](Command_Templates.md), [display fields](Config_Reference.md#display) e tramite [API Server](API_Server.md).

I campi in questo documento sono soggetti a modifiche: se si utilizza un attributo, assicurarsi di rivedere il [documento Modifiche alla configurazione](Config_Changes.md) durante l'aggiornamento del software Klipper.

## angle

The following information is available in [angle some_name](Config_Reference.md#angle) objects:

- `temperature`: The last temperature reading (in Celsius) from a tle5012b magnetic hall sensor. This value is only available if the angle sensor is a tle5012b chip and if measurements are in progress (otherwise it reports `None`).

## bed_mesh

Le seguenti informazioni sono disponibili in [bed_mesh](Config_Reference.md#bed_mesh):

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`: informazioni sulla bed_mesh attualmente attiva.
- `profiles`: The set of currently defined profiles as setup using BED_MESH_PROFILE.

## configfile

Le seguenti informazioni sono disponibili nell'oggetto `configfile` (questo oggetto è sempre disponibile):

- `settings.<section>.<option>`: Restituisce l'impostazione del file di configurazione data (o il valore predefinito) durante l'ultimo avvio o riavvio del software. (Qualsiasi impostazione modificata in fase di esecuzione non si rifletterà qui.)
- `config.<section>.<option>`: Restituisce l'impostazione del file di configurazione non elaborato come letta da Klipper durante l'ultimo avvio o riavvio del software. (Qualsiasi impostazione modificata in fase di esecuzione non si rifletterà qui.) Tutti i valori vengono restituiti come stringhe.
- `save_config_pending`: Returns true if there are updates that a `SAVE_CONFIG` command may persist to disk.
- `save_config_pending_items`: Contains the sections and options that were changed and would be persisted by a `SAVE_CONFIG`.
- `warnings`: A list of warnings about config options. Each entry in the list will be a dictionary containing a `type` and `message` field (both strings). Additional fields may be available depending on the type of warning.

## display_status

Le seguenti informazioni sono disponibili nell'oggetto `display_status` (questo oggetto è automaticamente disponibile se è definita una sezione di configurazione [display](Config_Reference.md#display)):

- `progress`: il valore di avanzamento dell'ultimo comando G-Code `M73` (o `virtual_sdcard.progress` se non è stato ricevuto alcun `M73` recente).
- `message`: il messaggio contenuto nell'ultimo comando G-Code `M117`.

## endstop_phase

Le seguenti informazioni sono disponibili nell'oggetto [endstop_phase](Config_Reference.md#endstop_phase):

- `last_home.<nome stepper>.phase`: La fase del motore passo-passo al termine dell'ultimo tentativo di home.
- `last_home.<stepper name>.phases`: il numero totale di fasi disponibili sul motore passo-passo.
- `last_home.<stepper name>.mcu_position`: la posizione (tracciata dal microcontrollore) del motore passo-passo alla fine dell'ultimo tentativo di home. La posizione è il numero totale di passi effettuati in avanti meno il numero totale di passi effettuati in senso inverso dall'ultimo riavvio del microcontrollore.

## exclude_object

The following information is available in the [exclude_object](Exclude_Object.md) object:


   - `objects`: An array of the known objects as provided by the `EXCLUDE_OBJECT_DEFINE` command. This is the same information provided by the `EXCLUDE_OBJECT VERBOSE=1` command. The `center` and `polygon` fields will only be present if provided in the original `EXCLUDE_OBJECT_DEFINE`Here is a JSON sample:

```
[
  {
    "polygon": [
      [ 156.25, 146.2511675 ],
      [ 156.25, 153.7488325 ],
      [ 163.75, 153.7488325 ],
      [ 163.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_2_COPY_0",
    "center": [ 160, 150 ]
  },
  {
    "polygon": [
      [ 146.25, 146.2511675 ],
      [ 146.25, 153.7488325 ],
      [ 153.75, 153.7488325 ],
      [ 153.75, 146.2511675 ]
    ],
    "name": "CYLINDER_2_STL_ID_1_COPY_0",
    "center": [ 150, 150 ]
  }
]
```

- `excluded_objects`: An array of strings listing the names of excluded objects.
- `current_object`: The name of the object currently being printed.

## fan

Le seguenti informazioni sono disponibili negli oggetti [fan](Config_Reference.md#fan), [heater_fan some_name](Config_Reference.md#heater_fan) e [controller_fan some_name](Config_Reference.md#controller_fan):

- `speed`: La velocità della ventola come float tra 0.0 e 1.0.
- `rpm`: la velocità della ventola misurata in rotazioni al minuto se la ventola ha un pin tachimetro definito.

## filament_switch_sensor

Le seguenti informazioni sono disponibili negli oggetti [filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor):

- `enabled`: Restituisce True se il sensore interruttore è attualmente abilitato.
- `filament_detected`: restituisce True se il sensore è in uno stato attivato.

## filament_motion_sensor

Le seguenti informazioni sono disponibili negli oggetti [filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor):

- `abilitato`: Restituisce True se il sensore di movimento è attualmente abilitato.
- `filament_detected`: restituisce True se il sensore è in uno stato attivato.

## firmware_retraction

Le seguenti informazioni sono disponibili nell'oggetto [firmware_retraction](Config_Reference.md#firmware_retraction):

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`: The current settings for the firmware_retraction module. These settings may differ from the config file if a `SET_RETRACTION` command alters them.

## gcode_macro

The following information is available in [gcode_macro some_name](Config_Reference.md#gcode_macro) objects:

- `<variable>`: The current value of a [gcode_macro variable](Command_Templates.md#variables).

## gcode_move

The following information is available in the `gcode_move` object (this object is always available):

- `gcode_position`: The current position of the toolhead relative to the current G-Code origin. That is, positions that one might directly send to a `G1` command. It is possible to access the x, y, z, and e components of this position (eg, `gcode_position.x`).
- `position`: The last commanded position of the toolhead using the coordinate system specified in the config file. It is possible to access the x, y, z, and e components of this position (eg, `position.x`).
- `homing_origin`: The origin of the gcode coordinate system (relative to the coordinate system specified in the config file) to use after a `G28` command. The `SET_GCODE_OFFSET` command can alter this position. It is possible to access the x, y, and z components of this position (eg, `homing_origin.x`).
- `speed`: The last speed set in a `G1` command (in mm/s).
- `speed_factor`: The "speed factor override" as set by an `M220` command. This is a floating point value such that 1.0 means no override and, for example, 2.0 would double requested speed.
- `extrude_factor`: The "extrude factor override" as set by an `M221` command. This is a floating point value such that 1.0 means no override and, for example, 2.0 would double requested extrusions.
- `absolute_coordinates`: This returns True if in `G90` absolute coordinate mode or False if in `G91` relative mode.
- `absolute_extrude`: This returns True if in `M82` absolute extrude mode or False if in `M83` relative mode.

## hall_filament_width_sensor

The following information is available in the [hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor) object:

- `is_active`: Returns True if the sensor is currently active.
- `Diameter`: The last reading from the sensor in mm.
- `Raw`: The last raw ADC reading from the sensor.

## heater

The following information is available for heater objects such as [extruder](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed), and [heater_generic](Config_Reference.md#heater_generic):

- `temperature`: The last reported temperature (in Celsius as a float) for the given heater.
- `target`: The current target temperature (in Celsius as a float) for the given heater.
- `power`: The last setting of the PWM pin (a value between 0.0 and 1.0) associated with the heater.
- `can_extrude`: If extruder can extrude (defined by `min_extrude_temp`), available only for [extruder](Config_Reference.md#extruder)

## heaters

The following information is available in the `heaters` object (this object is available if any heater is defined):

- `available_heaters`: Returns a list of all currently available heaters by their full config section names, e.g. `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `available_sensors`: Returns a list of all currently available temperature sensors by their full config section names, e.g. `["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"]`.

## idle_timeout

The following information is available in the [idle_timeout](Config_Reference.md#idle_timeout) object (this object is always available):

- `state`: The current state of the printer as tracked by the idle_timeout module. It is one of the following strings: "Idle", "Printing", "Ready".
- `printing_time`: The amount of time (in seconds) the printer has been in the "Printing" state (as tracked by the idle_timeout module).

## led

The following information is available for each `[led led_name]`, `[neopixel led_name]`, `[dotstar led_name]`, `[pca9533 led_name]`, and `[pca9632 led_name]` config section defined in printer.cfg:

- `color_data`: A list of color lists containing the RGBW values for a led in the chain. Each value is represented as a float from 0.0 to 1.0. Each color list contains 4 items (red, green, blue, white) even if the underyling LED supports fewer color channels. For example, the blue value (3rd item in color list) of the second neopixel in a chain could be accessed at `printer["neopixel <config_name>"].color_data[1][2]`.

## manual_probe

The following information is available in the `manual_probe` object:

- `is_active`: Returns True if a manual probing helper script is currently active.
- `z_position`: The current height of the nozzle (as the printer currently understands it).
- `z_position_lower`: Last probe attempt just lower than the current height.
- `z_position_upper`: ultimo tentativo di sonda appena maggiore dell'altezza corrente.

## mcu

The following information is available in [mcu](Config_Reference.md#mcu) and [mcu some_name](Config_Reference.md#mcu-my_extra_mcu) objects:

- `mcu_version`: The Klipper code version reported by the micro-controller.
- `mcu_build_versions`: Information on the build tools used to generate the micro-controller code (as reported by the micro-controller).
- `mcu_constants.<constant_name>`: Compile time constants reported by the micro-controller. The available constants may differ between micro-controller architectures and with each code revision.
- `last_stats.<statistics_name>`: Statistics information on the micro-controller connection.

## motion_report

The following information is available in the `motion_report` object (this object is automatically available if any stepper config section is defined):

- `live_position`: The requested toolhead position interpolated to the current time.
- `live_velocity`: The requested toolhead velocity (in mm/s) at the current time.
- `live_extruder_velocity`: The requested extruder velocity (in mm/s) at the current time.

## output_pin

The following information is available in [output_pin some_name](Config_Reference.md#output_pin) objects:

- `value`: The "value" of the pin, as set by a `SET_PIN` command.

## palette2

The following information is available in the [palette2](Config_Reference.md#palette2) object:

- `ping`: Amount of the last reported Palette 2 ping in percent.
- `remaining_load_length`: When starting a Palette 2 print, this will be the amount of filament to load into the extruder.
- `is_splicing`: True when the Palette 2 is splicing filament.

## pause_resume

The following information is available in the [pause_resume](Config_Reference.md#pause_resume) object:

- `is_paused`: Returns true if a PAUSE command has been executed without a corresponding RESUME.

## print_stats

The following information is available in the `print_stats` object (this object is automatically available if a [virtual_sdcard](Config_Reference.md#virtual_sdcard) config section is defined):

- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message`: Estimated information about the current print when a virtual_sdcard print is active.

## probe

The following information is available in the [probe](Config_Reference.md#probe) object (this object is also available if a [bltouch](Config_Reference.md#bltouch) config section is defined):

- `last_query`: Returns True if the probe was reported as "triggered" during the last QUERY_PROBE command. Note, if this is used in a macro, due to the order of template expansion, the QUERY_PROBE command must be run prior to the macro containing this reference.
- `last_z_result`: Returns the Z result value of the last PROBE command. Note, if this is used in a macro, due to the order of template expansion, the PROBE (or similar) command must be run prior to the macro containing this reference.

## quad_gantry_level

The following information is available in the `quad_gantry_level` object (this object is available if quad_gantry_level is defined):

- `applied`: True if the gantry leveling process has been run and completed successfully.

## query_endstops

The following information is available in the `query_endstops` object (this object is available if any endstop is defined):

- `last_query["<endstop>"]`: Returns True if the given endstop was reported as "triggered" during the last QUERY_ENDSTOP command. Note, if this is used in a macro, due to the order of template expansion, the QUERY_ENDSTOP command must be run prior to the macro containing this reference.

## servo

The following information is available in [servo some_name](Config_Reference.md#servo) objects:

- `printer["servo <config_name>"].value`: The last setting of the PWM pin (a value between 0.0 and 1.0) associated with the servo.

## system_stats

The following information is available in the `system_stats` object (this object is always available):

- `sysload`, `cputime`, `memavail`: Information on the host operating system and process load.

## temperature sensors

The following information is available in

[bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor), and [temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) objects:

- `temperature`: The last read temperature from the sensor.
- `humidity`, `pressure`, `gas`: The last read values from the sensor (only on bme280, htu21d, and lm75 sensors).

## temperature_fan

The following information is available in [temperature_fan some_name](Config_Reference.md#temperature_fan) objects:

- `temperature`: The last read temperature from the sensor.
- `target`: The target temperature for the fan.

## temperature_sensor

The following information is available in [temperature_sensor some_name](Config_Reference.md#temperature_sensor) objects:

- `temperature`: The last read temperature from the sensor.
- `measured_min_temp`, `measured_max_temp`: The lowest and highest temperature seen by the sensor since the Klipper host software was last restarted.

## tmc drivers

The following information is available in [TMC stepper driver](Config_Reference.md#tmc-stepper-driver-configuration) objects (eg, `[tmc2208 stepper_x]`):

- `mcu_phase_offset`: The micro-controller stepper position corresponding with the driver's "zero" phase. This field may be null if the phase offset is not known.
- `phase_offset_position`: The "commanded position" corresponding to the driver's "zero" phase. This field may be null if the phase offset is not known.
- `drv_status`: The results of the last driver status query. (Only non-zero fields are reported.) This field will be null if the driver is not enabled (and thus is not periodically queried).
- `run_current`: The currently set run current.
- `hold_current`: The currently set hold current.

## toolhead

The following information is available in the `toolhead` object (this object is always available):

- `position`: The last commanded position of the toolhead relative to the coordinate system specified in the config file. It is possible to access the x, y, z, and e components of this position (eg, `position.x`).
- `extruder`: The name of the currently active extruder. For example, in a macro one could use `printer[printer.toolhead.extruder].target` to get the target temperature of the current extruder.
- `homed_axes`: The current cartesian axes considered to be in a "homed" state. This is a string containing one or more of "x", "y", "z".
- `axis_minimum`, `axis_maximum`: The axis travel limits (mm) after homing. It is possible to access the x, y, z components of this limit value (eg, `axis_minimum.x`, `axis_maximum.z`).
- `max_velocity`, `max_accel`, `max_accel_to_decel`, `square_corner_velocity`: The current printing limits that are in effect. This may differ from the config file settings if a `SET_VELOCITY_LIMIT` (or `M204`) command alters them at run-time.
- `stalls`: The total number of times (since the last restart) that the printer had to be paused because the toolhead moved faster than moves could be read from the G-Code input.

## dual_carriage

The following information is available in [dual_carriage](Config_Reference.md#dual_carriage) on a hybrid_corexy or hybrid_corexz robot

- `mode`: The current mode. Possible values are: "FULL_CONTROL"
- `active_carriage`: The current active carriage. Possible values are: "CARRIAGE_0", "CARRIAGE_1"

## virtual_sdcard

The following information is available in the [virtual_sdcard](Config_Reference.md#virtual_sdcard) object:

- `is_active`: Returns True if a print from file is currently active.
- `progress`: An estimate of the current print progress (based of file size and file position).
- `file_path`: A full path to the file of currently loaded file.
- `file_position`: The current position (in bytes) of an active print.
- `file_size`: The file size (in bytes) of currently loaded file.

## webhooks

The following information is available in the `webhooks` object (this object is always available):

- `state`: Returns a string indicating the current Klipper state. Possible values are: "ready", "startup", "shutdown", "error".
- `state_message`: A human readable string giving additional context on the current Klipper state.

## z_tilt

The following information is available in the `z_tilt` object (this object is available if z_tilt is defined):

- `applied`: True if the z-tilt leveling process has been run and completed successfully.
