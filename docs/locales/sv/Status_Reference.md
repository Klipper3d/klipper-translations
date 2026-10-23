# Statusreferens

Det här dokumentet är en referens för skrivarstatusinformation som är tillgänglig i Klippers [makron](Command_Templates.md), [visningsfält](Config_Reference.md#display) och via [API-servern](API_Server.md).

Fälten i det här dokumentet kan ändras. Om ett attribut används bör [dokumentet om konfigurationsändringar](Config_Changes.md) granskas vid uppgradering av Klipper.

## angle

Följande information finns tillgänglig i objekten [angle some_name](Config_Reference.md#angle):

- `temperature`: Den senaste temperaturavläsningen i Celsius från en magnetisk tle5012b-Hall-sensor. Värdet är endast tillgängligt om vinkelsensorn är ett tle5012b-chip och mätningar pågår; annars rapporteras `None`.

## bed_mesh

Följande information finns tillgänglig i objektet [bed_mesh](Config_Reference.md#bed_mesh):

- `profile_name`, `mesh_min`, `mesh_max`, `probed_matrix`, `mesh_matrix`: Information om den aktiva bed_mesh-konfigurationen.
- `profiles`: Mängden av för närvarande definierade profiler, konfigurerade med BED_MESH_PROFILE.

## bed_screws

Följande information finns tillgänglig i objektet [bed_screws](Config_Reference.md#bed_screws):

- `is_active`: Returnerar True om verktyget för justering av bäddskruvar är aktivt.
- `state`: Tillståndet för verktyget för justering av bäddskruvar. Det är en av följande strängar: ”adjust”, ”fine”.
- `current_screw`: Indexet för den skruv som justeras.
- `accepted_screws`: Antalet godkända skruvar.

## canbus_stats

Följande information finns tillgänglig i objektet `canbus_stats some_mcu_name` (objektet är automatiskt tillgängligt om en mcu har konfigurerats att använda canbus):

- `rx_error`: Antalet mottagningsfel som upptäckts av mikrokontrollerns canbus-maskinvara.
- `tx_error`: Antalet sändningsfel som upptäckts av mikrokontrollerns canbus-maskinvara.
- `tx_retries`: Antalet sändningsförsök som gjordes om på grund av konkurrens om bussen eller fel.
- `bus_state`: Gränssnittets status, vanligen ”active” för en buss i normal drift, ”warn” för en buss med nyliga fel, ”passive” för en buss som inte längre sänder canbus-felramar eller ”off” för en buss som inte längre sänder eller tar emot meddelanden.

Observera att endast rp2XXX-mikrokontroller rapporterar ett `tx_retries`-fält som inte är noll, och att rp2XXX-mikrokontroller alltid rapporterar `tx_error` som noll och `bus_state` som ”active”.

## configfile

Följande information finns tillgänglig i objektet `configfile` (objektet är alltid tillgängligt):

- `settings.<section>.<option>`: Returnerar den angivna inställningen i konfigurationsfilen, eller standardvärdet, vid senaste programstart eller omstart. Inställningar som har ändrats under körning återspeglas inte här
- `config.<section>.<option>`: Returnerar den angivna råa inställningen i konfigurationsfilen, sådan som Klipper läste den vid senaste programstart eller omstart. Inställningar som har ändrats under körning återspeglas inte här. Alla värden returneras som strängar.
- `save_config_pending`: Returnerar true om det finns uppdateringar som kommandot `SAVE_CONFIG` kan spara på disk.
- `save_config_pending_items`: Innehåller de avsnitt och alternativ som har ändrats och som skulle sparas av `SAVE_CONFIG`.
- `warnings`: En lista över varningar om konfigurationsalternativ. Varje post i listan är en ordbok med fälten `type` och `message`, båda strängar. Ytterligare fält kan vara tillgängliga beroende på varningstypen.

## display_status

Följande information finns tillgänglig i objektet `display_status` (objektet är automatiskt tillgängligt om ett [display-konfigurationsavsnitt](Config_Reference.md#display) har definierats):

- `progress`: Förloppsvärdet från det senaste G-Code-kommandot `M73`, eller `virtual_sdcard.progress` om inget `M73` har tagits emot nyligen.
- `message`: Meddelandet i det senaste G-Code-kommandot `M117`.

## endstop_phase

Följande information finns tillgänglig i objektet [endstop_phase](Config_Reference.md#endstop_phase):

- `last_home.<stepper name>.phase`: Stegmotorns fas vid slutet av det senaste referenskörningsförsöket.
- `last_home.<stepper name>.phases`: Totala antalet tillgängliga faser i stegmotorn.
- `last_home.<stepper name>.mcu_position`: Stegmotorns position vid slutet av det senaste referenskörningsförsöket, så som den spåras av mikrokontrollern. Positionen är det totala antalet steg i framåtriktning minus det totala antalet steg i bakåtriktning sedan mikrokontrollern senast startades om.

## exclude_object

Följande information finns tillgänglig i objektet [exclude_object](Exclude_Object.md):

- `objects`: En array med kända objekt som tillhandahålls av kommandot `EXCLUDE_OBJECT_DEFINE`. Det är samma information som tillhandahålls av kommandot `EXCLUDE_OBJECT VERBOSE=1`. Fälten `center` och `polygon` finns bara om de angavs i ursprungliga `EXCLUDE_OBJECT_DEFINE`

   Här är ett JSON-exempel:

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

- `excluded_objects`: En array med strängar som listar namnen på uteslutna objekt.
- `current_object`: Namnet på objektet som skrivs ut för närvarande.

## extruder_stepper

Följande information finns tillgänglig för extruder_stepper-objekt, liksom för [extruder](Config_Reference.md#extruder)-objekt:

- `pressure_advance`: Det aktuella värdet för [tryckutjämning](Pressure_Advance.md).
- `smooth_time`: Den aktuella utjämningstiden för tryckutjämning.
- `motion_queue`: Namnet på den extruder som denna extruderstegmotor för närvarande är synkroniserad med. Detta rapporteras som `None` om extruderstegmotorn inte är kopplad till en extruder.

## fan

Följande information finns tillgänglig i objekten [fan](Config_Reference.md#fan), [heater_fan some_name](Config_Reference.md#heater_fan) och [controller_fan some_name](Config_Reference.md#controller_fan):

- `speed`: Fläkthastigheten som ett flyttal mellan 0.0 och 1.0.
- `rpm`: Uppmätt fläkthastighet i varv per minut om ett tachometer_pin har definierats för fläkten.

## filament_switch_sensor

Följande information finns tillgänglig i objekten [filament_switch_sensor some_name](Config_Reference.md#filament_switch_sensor):

- `enabled`: Returnerar True om brytarsensorn är aktiverad.
- `filament_detected`: Returnerar True om sensorn är i utlöst tillstånd.

## filament_motion_sensor

Följande information finns tillgänglig i objekten [filament_motion_sensor some_name](Config_Reference.md#filament_motion_sensor):

- `enabled`: Returnerar True om rörelsesensorn är aktiverad.
- `filament_detected`: Returnerar True om sensorn är i utlöst tillstånd.

## firmware_retraction

Följande information finns tillgänglig i objektet [firmware_retraction](Config_Reference.md#firmware_retraction):

- `retract_length`, `retract_speed`, `unretract_extra_length`, `unretract_speed`: Aktuella inställningar för modulen firmware_retraction. Inställningarna kan skilja sig från konfigurationsfilen om ett `SET_RETRACTION`-kommando ändrar dem.

## gcode

Följande information finns tillgänglig i objektet `gcode`:

- `commands`: Returnerar en lista över alla kommandon som för närvarande är tillgängliga. För varje kommando anges också en hjälpsträng om en sådan har definierats.

## gcode_button

Följande information finns tillgänglig i objekten [gcode_button some_name](Config_Reference.md#gcode_button):

- `state`: Knappens aktuella tillstånd, returnerat som ”PRESSED” eller ”RELEASED”

## gcode_macro

Följande information finns tillgänglig i objekten [gcode_macro some_name](Config_Reference.md#gcode_macro):

- `<variable>`: Det aktuella värdet för en [gcode_macro-variabel](Command_Templates.md#variables).

## gcode_move

Följande information finns tillgänglig i objektet `gcode_move` (objektet är alltid tillgängligt):

- `gcode_position`: Verktygshuvudets aktuella position relativt det aktuella G-Code-ursprunget. Det vill säga positioner som kan skickas direkt till ett `G1`-kommando. Värdet är kodat som en [koordinat](#accessing-coordinates).
- `position`: Verktygshuvudets senast kommenderade position med det koordinatsystem som anges i konfigurationsfilen. Värdet är kodat som en [koordinat](#accessing-coordinates).
- `homing_origin`: Ursprunget för gcode-koordinatsystemet, relativt koordinatsystemet som anges i konfigurationsfilen, som ska användas efter ett `G28`-kommando. Kommandot `SET_GCODE_OFFSET` kan ändra positionen. Värdet är kodat som en [koordinat](#accessing-coordinates).
- `speed`: Den senaste hastigheten som angavs i ett `G1`-kommando, i mm/s.
- `speed_factor`: ”Åsidosättningsfaktor för hastighet”, som anges med ett `M220`-kommando. Det är ett flyttal där 1.0 betyder att ingen åsidosättning görs och där till exempel 2.0 fördubblar den begärda hastigheten.
- `extrude_factor`: ”Åsidosättningsfaktor för extrudering”, som anges med ett `M221`-kommando. Det är ett flyttal där 1.0 betyder att ingen åsidosättning görs och där till exempel 2.0 fördubblar de begärda extruderingarna.
- `absolute_coordinates`: Returnerar True i absolut koordinatläge `G90`, annars False i relativt läge `G91`.
- `absolute_extrude`: Returnerar True i absolut extruderläge `M82`, annars False i relativt läge `M83`.
- `axis_map`: Tillhandahåller ett sätt att hitta koordinatkomponenten för ett visst G-Code-id som används i `G1`-kommandon. Se avsnittet [Åtkomst till koordinater](#accessing-coordinates) för mer information.

## hall_filament_width_sensor

Följande information finns tillgänglig i objektet [hall_filament_width_sensor](Config_Reference.md#hall_filament_width_sensor):

- alla poster från [filament_switch_sensor](Status_Reference.md#filament_switch_sensor)
- `is_active`: Returnerar True om sensorn är aktiv.
- `flow_compensation_enabled`: Returnerar True om flödeskompensering är aktiverad.
- `Diameter`: Returnerar den senaste breddavläsningen i mm om sensorn är aktiv, annars den nominella filamentdiametern.
- `Raw`: Sensorns senaste råa ADC-avläsning.

## heater

Följande information finns tillgänglig för värmarobjekt, exempelvis [extruder](Config_Reference.md#extruder), [heater_bed](Config_Reference.md#heater_bed) och [heater_generic](Config_Reference.md#heater_generic):

- `temperature`: Den senast rapporterade temperaturen i Celsius, som ett flyttal, för den angivna värmaren.
- `target`: Den aktuella måltemperaturen i Celsius, som ett flyttal, för den angivna värmaren.
- `power`: Den senaste inställningen av PWM-stiftet, ett värde mellan 0.0 och 1.0, som är kopplat till värmaren.
- `can_extrude`: Om extrudern kan extrudera, vilket definieras av `min_extrude_temp`; endast tillgängligt för [extruder](Config_Reference.md#extruder)

## heaters

Följande information finns tillgänglig i objektet `heaters` (objektet är tillgängligt om någon värmare har definierats):

- `available_heaters`: Returnerar en lista över alla tillgängliga värmare med deras fullständiga namn på konfigurationsavsnitt, till exempel `["extruder", "heater_bed", "heater_generic my_custom_heater"]`.
- `available_sensors`: Returnerar en lista över alla tillgängliga temperatursensorer med deras fullständiga namn på konfigurationsavsnitt, till exempel `["extruder", "heater_bed", "heater_generic my_custom_heater", "temperature_sensor electronics_temp"]`.
- `available_monitors`: Returnerar en lista över alla tillgängliga temperaturövervakare med deras fullständiga namn på konfigurationsavsnitt, till exempel `["tmc2240 stepper_x"]`. En temperatursensor är alltid tillgänglig för avläsning, men en temperaturövervakare kan saknas och returnerar då null.

## idle_timeout

Följande information finns tillgänglig i objektet [idle_timeout](Config_Reference.md#idle_timeout) (objektet är alltid tillgängligt):

- `state`: Skrivarens aktuella tillstånd, enligt modulen idle_timeout. Det är en av följande strängar: ”Idle”, ”Printing”, ”Ready”.
- `printing_time`: Tiden i sekunder som skrivaren har varit i tillståndet ”Printing”, enligt modulen idle_timeout.
- `idle_timeout`: Den aktuella tidsgränsen i sekunder för att vänta på att gcode ska utlösas, enligt [SET_IDLE_TIMEOUT](G-Codes.md#set_idle_timeout)

## led

Följande information finns tillgänglig för varje konfigurationsavsnitt `[led led_name]`, `[neopixel led_name]`, `[dotstar led_name]`, `[pca9533 led_name]` och `[pca9632 led_name]` som definierats i printer.cfg:

- `color_data`: En lista över färglistor som innehåller RGBW-värdena för en lysdiod i kedjan. Varje värde representeras som ett flyttal från 0,0 till 1,0. Varje färglista innehåller fyra poster, röd, grön, blå och vit, även om den underliggande lysdioden har färre färgkanaler. Det blå värdet, tredje posten i färglistan, för den andra neopixel-enheten i en kedja kan till exempel nås med `printer["neopixel <config_name>"].color_data[1][2]`.

## load_cell

Följande information finns tillgänglig för varje `[load_cell name]`:

- `is_calibrated`: True/False beroende på om lastcellen är kalibrerad.
- `counts_per_gram`: Antalet råa sensorräkningar som motsvarar 1 grams kraft.
- `reference_tare_counts`: Referensantalet råa sensorräkningar för kraften 0.
- `tare_counts`: Aktuellt antal råa sensorräkningar för kraften 0.
- `force_g`: Kraften i gram, beräknad som medelvärde över senaste avfrågningsperioden.
- `min_force_g`: Minsta kraften i gram under senaste avfrågningsperioden.
- `max_force_g`: Största kraften i gram under senaste avfrågningsperioden.
- `errors`: Antalet sensorfel som upptäckts sedan mätningarna senast startades.
- `overflows`: Antalet översvämningar i databufferten som upptäckts sedan mätningarna senast startades.
- `sample_rate`: Sensorns samplingsfrekvens i prov per sekund.

## load_cell_probe

Följande information finns tillgänglig för `[load_cell_probe]`:

- alla poster från [load_cell](Status_Reference.md#load_cell)
- alla poster från [probe](Status_Reference.md#probe)
- `endstop_tare_counts`: Lastcellssonden behåller ett taravärde oberoende av lastcellen. Det återställs i början av varje sondering.
- `last_trigger_time`: Tidsstämpel för den senaste referenskörningsutlösningen.
- `last_z_result`: Z-positionen från den senaste kontakten.
- `is_last_tap_valid`: True om resultatet från senaste kontakten är giltigt.

## manual_probe

Följande information finns tillgänglig i objektet `manual_probe`:

- `is_active`: Returnerar True om ett hjälpskript för manuell sondering är aktivt.
- `z_position`: Munstyckets aktuella höjd, så som skrivaren för närvarande uppfattar den.
- `z_position_lower`: Senaste sonderingsförsöket precis under den aktuella höjden.
- `z_position_upper`: Senaste sonderingsförsöket precis över den aktuella höjden.

## mcu

Följande information finns tillgänglig i objekten [mcu](Config_Reference.md#mcu) och [mcu some_name](Config_Reference.md#mcu-my_extra_mcu):

- `mcu_version`: Klipper-kodversionen som rapporteras av mikrokontrollern.
- `mcu_build_versions`: Information om byggverktygen som användes för att skapa mikrokontrollerkoden, enligt mikrokontrollern.
- `mcu_constants.<constant_name>`: Konstantvärden från kompileringstiden som rapporteras av mikrokontrollern. Tillgängliga konstantvärden kan skilja sig mellan mikrokontrollerarkitekturer och mellan kodversioner.
- `last_stats.<statistics_name>`: Statistik om anslutningen till mikrokontrollern.

## motion_report

Följande information finns tillgänglig i objektet `motion_report` (objektet är automatiskt tillgängligt om något stegmotorkonfigurationsavsnitt har definierats):

- `live_position`: Verktygshuvudets begärda position interpolerad till aktuell tidpunkt. Värdet är kodat som en [koordinat](#accessing-coordinates).
- `live_velocity`: Den begärda hastigheten för verktygshuvudet vid aktuell tidpunkt, i mm/s.
- `live_extruder_velocity`: Den begärda extruderhastigheten vid aktuell tidpunkt, i mm/s.

## output_pin

Följande information finns tillgänglig i objekten [output_pin some_name](Config_Reference.md#output_pin) och [pwm_tool some_name](Config_Reference.md#pwm_tool):

- `value`: Stiftets ”värde”, som anges med kommandot `SET_PIN`.

## palette2

Följande information finns tillgänglig i objektet [palette2](Config_Reference.md#palette2):

- `ping`: Den senast rapporterade Palette 2-pingen i procent.
- `remaining_load_length`: Vid start av en Palette 2-utskrift är detta mängden filament som ska matas in i extrudern.
- `is_splicing`: True när Palette 2 skarvar filament.

## pause_resume

Följande information finns tillgänglig i objektet [pause_resume](Config_Reference.md#pause_resume):

- `is_paused`: Returnerar true om ett PAUSE-kommando har körts utan motsvarande RESUME.

## print_stats

Följande information finns tillgänglig i objektet `print_stats` (objektet är automatiskt tillgängligt om ett [virtual_sdcard-konfigurationsavsnitt](Config_Reference.md#virtual_sdcard) har definierats):

- `filename`, `total_duration`, `print_duration`, `filament_used`, `state`, `message`: Uppskattad information om den aktuella utskriften när en virtual_sdcard-utskrift är aktiv.
- `info.total_layer`: Det totala lagervärdet från det senaste G-Code-kommandot `SET_PRINT_STATS_INFO TOTAL_LAYER=<value>`.
- `info.current_layer`: Det aktuella lagervärdet från det senaste G-Code-kommandot `SET_PRINT_STATS_INFO CURRENT_LAYER=<value>`.

## probe

Följande information finns tillgänglig i objektet [probe](Config_Reference.md#probe) (objektet är också tillgängligt om ett [bltouch-konfigurationsavsnitt](Config_Reference.md#bltouch) har definierats):

- `name`: Returnerar namnet på den sond som används.
- `last_query`: Returnerar True om sonden rapporterades som ”triggered” under det senaste QUERY_PROBE-kommandot. Om detta används i ett makro måste QUERY_PROBE, på grund av ordningen för mallexpansion, köras före makrot som innehåller denna referens.
- `last_probe_position`: Resultatet från det senaste kommandot `PROBE`. Värdet är kodat som en [koordinat](#accessing-coordinates). Sondmaskinvaran uppskattar att om verktygshuvudet kommenderas till XY-positionen `last_probe_position.x`,`last_probe_position.y` och sänks, skulle verktygshuvudets spets först komma i kontakt med bädden vid Z-höjden `last_probe_position.z`. Koordinaterna är relativa till ramen, det vill säga de använder koordinatsystemet som anges i konfigurationsfilen. Om detta används i ett makro måste kommandot `PROBE`, på grund av ordningen för mallexpansion, köras före makrot som innehåller denna referens.
- `last_z_result`: Det här värdet är föråldrat; det kommer att tas bort inom kort.

## pwm_cycle_time

Följande information finns tillgänglig i objekten [pwm_cycle_time some_name](Config_Reference.md#pwm_cycle_time):

- `value`: Stiftets ”värde”, som anges med kommandot `SET_PIN`.

## quad_gantry_level

Följande information finns tillgänglig i objektet `quad_gantry_level` (objektet är tillgängligt om quad_gantry_level har definierats):

- `applied`: True om portalnivelleringsprocessen har körts och slutförts.

## query_endstops

Följande information finns tillgänglig i objektet `query_endstops` (objektet är tillgängligt om något ändstopp har definierats):

- `last_query["<endstop>"]`: Returnerar True om det angivna ändstoppet rapporterades som ”triggered” under det senaste QUERY_ENDSTOP-kommandot. Om detta används i ett makro måste QUERY_ENDSTOP, på grund av ordningen för mallexpansion, köras före makrot som innehåller denna referens.

## screws_tilt_adjust

Följande information finns tillgänglig i objektet `screws_tilt_adjust`:

- `error`: Returnerar True om det senaste kommandot `SCREWS_TILT_CALCULATE` innehöll parametern `MAX_DEVIATION` och någon av de sonderade skruvpunkterna överskred angivet `MAX_DEVIATION`.
- `max_deviation`: Returnerar det senaste `MAX_DEVIATION`-värdet från det senaste kommandot `SCREWS_TILT_CALCULATE`.
- `results["<screw>"]`: En ordbok som innehåller följande nycklar:
   - `z`: Den uppmätta Z-höjden för skruvpositionen.
   - `sign`: En sträng som anger åt vilket håll skruven ska vridas för nödvändig justering: ”CW” för medurs eller ”CCW” för moturs.
   - `adjust`: Antalet skruvvarv för att justera skruven, angivet i formatet ”HH:MM”, där ”HH” är antalet hela skruvvarv och ”MM” antalet ”minuter på en urtavla” som motsvarar ett delvarv. Till exempel betyder ”01:15” att skruven ska vridas ett och ett kvarts varv.
   - `is_base`: Returnerar True om detta är basskruven.

## servo

Följande information finns tillgänglig i objekten [servo some_name](Config_Reference.md#servo):

- `printer["servo <config_name>"].value`: Den senaste inställningen av PWM-stiftet, ett värde mellan 0.0 och 1.0, som är kopplat till servot.

## skew_correction.py

Följande information finns tillgänglig i objektet `skew_correction` (objektet är tillgängligt om någon skew_correction har definierats):

- `current_profile_name`: Returnerar namnet på den aktuellt inlästa SKEW_PROFILE.

## stepper_enable

Följande information finns tillgänglig i objektet `stepper_enable` (objektet är tillgängligt om någon stegmotor har definierats):

- `steppers["<stepper>"]`: Returnerar True om den angivna stegmotorn är aktiverad.

## system_stats

Följande information finns tillgänglig i objektet `system_stats` (objektet är alltid tillgängligt):

- `sysload`, `cputime`, `memavail`: Information om värdoperativsystemet och processbelastningen.

## temperatursensorer

Följande information finns tillgänglig i

Objekten [bme280 config_section_name](Config_Reference.md#bmp280bme280bme680-temperature-sensor), [htu21d config_section_name](Config_Reference.md#htu21d-sensor), [sht3x config_section_name](Config_Reference.md#sht31-sensor), [lm75 config_section_name](Config_Reference.md#lm75-temperature-sensor), [temperature_host config_section_name](Config_Reference.md#host-temperature-sensor) och [temperature_combined config_section_name](Config_Reference.md#combined-temperature-sensor):

- `temperature`: Den senast avlästa temperaturen från sensorn.
- `humidity`, `pressure`, `gas`: De senast avlästa värdena från sensorn, endast på sensorerna bme280, htu21d, sht3x och lm75.

## temperature_fan

Följande information finns tillgänglig i objekten [temperature_fan some_name](Config_Reference.md#temperature_fan):

- `temperature`: Den senast avlästa temperaturen från sensorn.
- `target`: Fläktens måltemperatur.

## temperature_sensor

Följande information finns tillgänglig i objekten [temperature_sensor some_name](Config_Reference.md#temperature_sensor):

- `temperature`: Den senast avlästa temperaturen från sensorn.
- `measured_min_temp`, `measured_max_temp`: Den lägsta respektive högsta temperatur som sensorn har uppmätt sedan Klippers värdprogram senast startades om.

## TMC-drivrutiner

Följande information finns tillgänglig i objekt för [TMC-stegmotordrivrutiner](Config_Reference.md#tmc-stepper-driver-configuration), till exempel `[tmc2208 stepper_x]`:

- `mcu_phase_offset`: Mikrokontrollerns stegmotorposition som motsvarar drivrutinens ”nollfas”. Fältet kan vara null om fasförskjutningen inte är känd.
- `phase_offset_position`: Den ”kommenderade position” som motsvarar drivrutinens ”nollfas”. Fältet kan vara null om fasförskjutningen inte är känd.
- `drv_status`: Resultatet av den senaste frågan om drivrutinens status. Endast fält som inte är noll rapporteras. Fältet är null om drivrutinen inte är aktiverad och därför inte frågas ut periodiskt.
- `temperature`: Den interna temperatur som drivrutinen rapporterar. Fältet är null om drivrutinen inte är aktiverad eller inte stöder temperaturrapportering.
- `run_current`: Den aktuellt inställda körströmmen.
- `hold_current`: Den aktuellt inställda hållströmmen.

## toolhead

Följande information finns tillgänglig i objektet `toolhead` (objektet är alltid tillgängligt):

- `position`: Verktygshuvudets senast kommenderade position relativt koordinatsystemet som anges i konfigurationsfilen. Värdet är kodat som en [koordinat](#accessing-coordinates).
- `extruder`: Namnet på den extruder som är aktiv. I ett makro kan till exempel `printer[printer.toolhead.extruder].target` användas för att hämta måltemperaturen för den aktuella extrudern.
- `homed_axes`: De aktuella kartesiska axlar som anses vara i läget ”homed”. Det är en sträng som innehåller en eller flera av ”x”, ”y”, ”z”.
- `axis_minimum`, `axis_maximum`: Axelns rörelsegränser i mm efter referenskörning. Värdet är kodat som en [koordinat](#accessing-coordinates).
- För delta-skrivare är `cone_start_z` den maximala Z-höjden vid maximal radie (`printer.toolhead.cone_start_z`).
- `max_velocity`, `max_accel`, `minimum_cruise_ratio`, `square_corner_velocity`: De aktuella begränsningarna för utskrift som gäller. De kan skilja sig från konfigurationsfilens inställningar om ett `SET_VELOCITY_LIMIT`- eller `M204`-kommando ändrar dem under körning.
- `stalls`: Totala antalet gånger, sedan senaste omstarten, som skrivaren behövde pausas eftersom verktygshuvudet rörde sig snabbare än rörelser kunde läsas från G-Code-indatan.
- `extra_axes`: Tillhandahåller ett sätt att hitta koordinatkomponenten för extra axlar som är tillgängliga i vanliga rörelsekommandon av typen `G1`. Se avsnittet [Åtkomst till koordinater](#accessing-coordinates) för mer information.

## dual_carriage

Följande information finns tillgänglig i [dual_carriage](Config_Reference.md#dual_carriage) på en kartesisk, hybrid_corexy- eller hybrid_corexz-robot

- `carriage_0`: Läget för vagn 0. Möjliga värden är: ”INACTIVE” och ”PRIMARY”.
- `carriage_1`: Läget för vagn 1. Möjliga värden är: ”INACTIVE”, ”PRIMARY”, ”COPY” och ”MIRROR”.

I en `generic_cartesian`-kinematik finns följande information tillgänglig i `dual_carriage`:

- `carriages["<carriage>"]`: Läget för vagnen `<carriage>`. Möjliga värden är ”INACTIVE” och ”PRIMARY” för den primära vagnen samt ”INACTIVE”, ”PRIMARY”, ”COPY” och ”MIRROR” för den dubbla vagnen.

## virtual_sdcard

Följande information finns tillgänglig i objektet [virtual_sdcard](Config_Reference.md#virtual_sdcard):

- `is_active`: Returnerar True om en utskrift från fil för närvarande är aktiv.
- `progress`: En uppskattning av den aktuella utskriftens förlopp, baserad på filstorlek och filposition.
- `file_path`: En fullständig sökväg till den inlästa filen.
- `file_position`: Den aktuella positionen i byte för en aktiv utskrift.
- `file_size`: Filstorleken i byte för den inlästa filen.

## webhooks

Följande information finns tillgänglig i objektet `webhooks` (objektet är alltid tillgängligt):

- `state`: Returnerar en sträng som anger Klippers aktuella tillstånd. Möjliga värden är: ”ready”, ”startup”, ”shutdown”, ”error”.
- `state_message`: En läsbar sträng med ytterligare kontext om Klippers aktuella tillstånd.

## z_thermal_adjust

Följande information finns tillgänglig i objektet `z_thermal_adjust` (objektet är tillgängligt om [z_thermal_adjust](Config_Reference.md#z_thermal_adjust) har definierats).

- `enabled`: Returnerar True om justering är aktiverad.
- `temperature`: Aktuell utjämnad temperatur för den definierade sensorn. [degC]
- `measured_min_temp`: Lägsta uppmätta temperatur. [degC]
- `measured_max_temp`: Högsta uppmätta temperatur. [degC]
- `current_z_adjust`: Senast beräknade Z-justering [mm].
- `z_adjust_ref_temperature`: Aktuell referenstemperatur som används för beräkning av Z `current_z_adjust` [degC].

## z_tilt

Följande information finns tillgänglig i objektet `z_tilt` (objektet är tillgängligt om z_tilt har definierats):

- `applied`: True om Z-lutningsnivelleringen har körts och slutförts.

## Åtkomst till koordinater

Vissa statusfält tillhandahåller en ”koordinat”. För makroanvändare kan dessa fält nås med komponentnamn, till exempel `{printer.toolhead.position.x}`, där komponentnamnet kan vara ”x”, ”y” eller ”z”.

För utvecklare som använder Klippers API-server överförs dessa fält som en lista, till exempel: `{"toolhead": {"position": [1.0, 2.0, 3.0, 7.3, 19.2]}}`. Listans tre första komponenter motsvarar axlarna x, y och z.

En koordinat har vanligtvis minst 3 komponenter, x, y och z, men kan även ha ytterligare komponenter. Var försiktig vid åtkomst till ytterligare komponenter eftersom komponenternas ordning och antal kan ändras under körning.

Man kan använda `{printer.gcode_move.axis_map}` och/eller `{printer.toolhead.extra_axes}` för att fastställa antalet komponenter och deras ordning. För att till exempel komma åt komponenten ”E” kan `{printer.toolhead.position[printer.gcode_move.axis_map.E]}` användas. Om komponenten som hör till objektet ”extruder” ska hittas kan `{printer.toolhead.position[printer.toolhead.extra_axes.extruder]}` användas.
