# Konfigurationsändringar

Det här dokumentet beskriver de senaste programvaruändringarna i konfigurationsfilen som inte är bakåtkompatibla. Det är klokt att läsa dokumentet när Klipper-programvaran uppgraderas.

Alla datum i det här dokumentet är ungefärliga.

## Ändringar

20260525: Den interna implementationen av `probe:z_virtual_endstop` har ändrats. De flesta användare märker ingen beteendeförändring. Tidigare var det tekniskt möjligt att blanda `probe:z_virtual_endstop` med andra typer av Z-ändstopp, men detta är inte längre giltigt.

20260501: Hanteringen av konfigurationsalternativet `tap_threshold` för `[probe_eddy_current]` och den tillhörande G-kodparametern `TAP_THRESHOLD` har ändrats. Värdet måste kalibreras om. Se [dokumentationen för Eddy-sonden](Eddy_Probe.md) för kalibreringsanvisningar.

20260408: Skriptet `lib/canboot/flash_can.py` har uppdaterats till den senaste versionen från [Katapult](https://github.com/Arksine/katapult) och har därför bytt namn till `lib/katapult/flashtool.py`. Om skriptet anropas direkt i stället för via befintliga Makefiles måste sökvägen ändras till `lib/katapult/flashtool.py`.

20260318: Konfigurationsalternativen `speed`, `lift_speed`, `samples`, `sample_retract_dist`, `samples_result`, `samples_tolerance` och `samples_tolerance_retries` för `[probe_eddy_current]` gäller inte längre sonderingskommandon som använder `METHOD=scan`, `METHOD=rapid_scan` eller `METHOD=tap`. För andra inställningar anger du motsvarande parameter `PROBE_SPEED`, `LIFT_SPEED`, `SAMPLES`, `SAMPLE_RETRACT_DIST`, `SAMPLES_RESULT`, `SAMPLES_TOLERANCE` eller `SAMPLES_TOLERANCE_RETRIES` i sonderingskommandot.

20260318: Konfigurationsalternativet `z_offset` för `[probe_eddy_current]` har bytt namn till `descend_z`. Användning av det gamla namnet är föråldrad och tas bort inom kort.

20260214: Parametern `STOP_ON_ENDSTOP` till G-kodkommandot `MANUAL_STEPPER` har ändrats. Se dokumentationen för [MANUAL_STEPPER](G-Codes.md#manual_stepper) för detaljer. Användning av de tidigare heltalsvärdena (-2, -1, 1, 2) är föråldrad och stödet tas bort inom kort.

20260207: Lågnivåbeteendet för I2C hos enheterna sx1509 och uc1701 har ändrats. Tidigare ledde ett I2C-fel till avstängning, medan I2C-fel vid kommunikation med dessa enheter nu endast skapar varningar i loggfilen.

20260109: Statusvärdet `{printer.probe.last_z_result}` är föråldrat och tas bort inom kort. Använd i stället `{printer.probe.last_probe_position}` och observera att detta nya värde redan har sondens konfigurerade XYZ-förskjutningar tillämpade.

20260109: G-kodkonsolens textutdata från `PROBE`, `PROBE_ACCURACY` och liknande kommandon har ändrats. Z-höjder rapporteras nu relativt den nominella bäddens Z-position i stället för relativt sondens konfigurerade `z_offset`. På samma sätt får mellanliggande konsolrapporter för sondens X och Y även sondens konfigurerade `x_offset` och `y_offset` tillämpade.

20260109: Modulen `[screws_tilt_adjust]` rapporterar nu statusvariabeln `{printer.screws_tilt_adjust.result.screw1.z}` med sondens `z_offset` tillämpad. Tidigare behövde sondens konfigurerade `z_offset` dras av för att hitta den absoluta Z-avvikelsen vid den aktuella skruvplatsen; nu ska `z_offset` inte tillämpas.

20251122: Alternativet `axis` har lagts till i avsnitt `[carriage <name>]` för kinematiken `generic_cartesian`, vilket tillåter godtyckliga namn på primära vagnar. Användare uppmuntras att uttryckligen ange alternativet `axis`.

20251106: Statusfälten `{printer.toolhead.position}`, `{printer.gcode_move.position}`, `{printer.gcode_move.gcode_position}` och `{printer.motion_report.live_position}` ändras. Koordinaterna innehöll tidigare alltid fyra komponenter, men kan nu innehålla fler. Komponenternas ordning och antal kan ändras under körning – se [statusreferensen](Status_Reference.md#accessing-coordinates) för viktig information. Åtkomst till koordinaterna i makron via accessoraren `.e` är föråldrad; använd till exempel `{printer.toolhead.position[printer.gcode_move.axis_map.E]}` i stället.

20251106: Statusfälten `{printer.gcode_move.homing_origin}`, `{printer.toolhead.axis_min}` och `{printer.toolhead.axis_max}` innehåller för närvarande fyra komponenter där den fjärde alltid är noll. Detta beteende är föråldrat. I framtiden kan koordinaterna innehålla endast tre komponenter. Mer information finns i [statusreferensen](Status_Reference.md#accessing-coordinates).

20251010: Under normal utskrift försöker kommandobearbetningen nu ligga en sekund före skrivarens rörelser (ned från två sekunder tidigare).

20251003: Stöd för det odokumenterade alternativet `max_stepper_error` i konfigurationsavsnittet `[printer]` har tagits bort.

20250916: Definitionerna av Input Shapers EI, 2HUMP_EI och 3HUMP_EI har uppdaterats. För bästa prestanda rekommenderas att Input Shaper kalibreras om, särskilt om någon av dessa varianter används.

20250811: Stöd för parametern `max_accel_to_decel` i konfigurationsavsnittet `[printer]` har tagits bort, liksom stöd för parametern `ACCEL_TO_DECEL` i kommandot `SET_VELOCITY_LIMIT`. Funktionerna var föråldrade sedan 20240313.

20250721: Modulerna `[pca9632]` och `[mcp4018]` accepterar inte längre alternativen `scl_pin` och `sda_pin`. Använd i stället `i2c_software_scl_pin` och `i2c_software_sda_pin`.

20250428: Maximalt `cycle_time` för PWM i `[output_pin]`, `[pwm_cycle_time]`, `[pwm_tool]` och liknande konfigurationsavsnitt är nu 3 sekunder (sänkt från 5 sekunder). `maximum_mcu_duration` i `[pwm_tool]` är nu också 3 sekunder.

20250418: Funktionen `STOP_ON_ENDSTOP` för `manual_stepper` kan nu ta kortare tid att slutföra. Tidigare väntade kommandot under hela den tid rörelsen möjligen kunde ta, även om ändstoppet utlöstes tidigare. Nu avslutas kommandot kort efter att ändstoppet har utlösts.

20250417: SPI-enheter som använder "software SPI" har nu en hastighetsgräns. Tidigare ignorerades `spi_speed` i konfigurationen och överföringshastigheten begränsades enbart av mikrokontrollerns bearbetningshastighet. Nu begränsas hastigheten av konfigurationsparametern `spi_speed` (den faktiska maskinvaruhastigheten är sannolikt lägre än det konfigurerade värdet på grund av programvaruoverhead).

20250411: Klipper v0.13.0 släpptes.

20250308: Parametern `AUTO` till kommandot `AXIS_TWIST_COMPENSATION_CALIBRATE` har tagits bort.

20250131: Alternativet `VARIABLE=<name>` i `SAVE_VARIABLE` kräver ett värde med gemener. Använd till exempel `extruder` i stället för blandade gemener och versaler i `Extruder` eller versaler i `EXTRUDER`. Om någon versal används utlöses ett fel.

20241203: Resonanstestet har ändrats för att omfatta långsamma sveprörelser. Ändringen kräver att testpunkterna har tillräckligt fritt utrymme i X/Y-planet (±30 mm från testpunkten bör räcka med standardinställningarna). Det nya testet bör vanligen ge exaktare och tillförlitligare resultat. Det tidigare testbeteendet kan dock återställas genom att lägga till alternativen `sweeping_period: 0` och `accel_per_hz: 75` i konfigurationsavsnittet `[resonance_tester]`.

20241201: I vissa fall kan Klipper ha ignorerat inledande tecken eller blanksteg i ett traditionellt G-kodkommando. Till exempel kan `99M123` ha tolkats som `M123` och `M 321` som `M321`. Klipper rapporterar nu dessa fall med varningen "Okänt kommando".

20241112: Alternativet `CHIPS=<chip_name>` i `TEST_RESONANCES` och `SHAPER_CALIBRATE` kräver att accelerometerkretsens fullständiga namn anges. Ange till exempel `adxl345 rpi` i stället för kortnamnet `rpi`.

20240912: Kommandona `SET_PIN`, `SET_SERVO`, `SET_FAN_SPEED`, `M106` och `M107` sammanställs nu. Tidigare kunde faktiska uppdateringar köas långt in i framtiden om många uppdateringar för samma objekt utfärdades snabbare än minsta schemaläggningstid (vanligen 100 ms). Om många uppdateringar nu utfärdas i snabb följd är det möjligt att endast den senaste begäran tillämpas. Om det tidigare beteendet krävs kan explicita fördröjningskommandon `G4` mellan uppdateringarna läggas till.

20240912: Stöd för parametrarna `maximum_mcu_duration` och `static_value` i konfigurationsavsnitt för `[output_pin]` har tagits bort. Alternativen har varit föråldrade sedan 20240123.

20240415: Parametern `on_error_gcode` i konfigurationsavsnittet `[virtual_sdcard]` har nu ett standardvärde. Om parametern inte anges får den nu standardvärdet `TURN_OFF_HEATERS`. Om det tidigare beteendet önskas (ingen standardåtgärd vid ett fel under en utskrift från `virtual_sdcard`) definierar du `on_error_gcode` med ett tomt värde.

20240313: Parametern `max_accel_to_decel` i konfigurationsavsnittet `[printer]` är föråldrad. Parametern `ACCEL_TO_DECEL` till kommandot `SET_VELOCITY_LIMIT` är föråldrad. Statusen `printer.toolhead.max_accel_to_decel` har tagits bort. Använd i stället [parametern `minimum_cruise_ratio`](./Config_Reference.md#printer). De föråldrade funktionerna tas bort inom kort och användning av dem under tiden kan ge subtilt annorlunda beteende.

20240215: Flera föråldrade funktioner har tagits bort. Användning av "NTC 100K beta 3950" som termistornamn har tagits bort (föråldrat sedan 20211110). Kommandona `SYNC_STEPPER_TO_EXTRUDER` och `SET_EXTRUDER_STEP_DISTANCE` har tagits bort, och extruderns konfigurationsalternativ `shared_heater` har tagits bort (föråldrat sedan 20220210). Alternativet `relative_reference_index` för `bed_mesh` har tagits bort (föråldrat sedan 20230619).

20240123: Parametern `CYCLE_TIME` till `SET_PIN` för `output_pin` har tagits bort. Använd den nya modulen [pwm_cycle_time](Config_Reference.md#pwm_cycle_time) om en PWM-pins cykeltid måste ändras dynamiskt.

20240123: Parametern `maximum_mcu_duration` för `output_pin` är föråldrad. Använd i stället ett konfigurationsavsnitt för [pwm_tool](Config_Reference.md#pwm_tool). Alternativet tas bort inom kort.

20240123: Parametern `static_value` för `output_pin` är föråldrad. Ersätt den med parametrarna `value` och `shutdown_value`. Alternativet tas bort inom kort.

20231216: The `[hall_filament_width_sensor]` is changed to trigger filament runout when the thickness of the filament exceeds `max_diameter`. The maximum diameter defaults to `default_nominal_filament_diameter + max_difference`. See [[hall_filament_width_sensor] configuration
reference](./Config_Reference.md#hall_filament_width_sensor) for more details.

20231207: Flera odokumenterade konfigurationsparametrar i avsnittet `[printer]` har tagits bort (parametrarna `buffer_time_low`, `buffer_time_high`, `buffer_time_start` och `move_flush_time`).

20231110: Klipper v0.12.0 släpptes.

20230826: Om `safe_distance` är satt till eller beräknas som 0 i `[dual_carriage]` inaktiveras vagnarnas närhetskontroller enligt dokumentationen. Användaren kan vilja konfigurera `safe_distance` uttryckligen för att förhindra att vagnarna av misstag kolliderar med varandra. Dessutom ändras referenskörningsordningen för den primära och den dubbla vagnen i vissa konfigurationer (när båda vagnarna referenskör i samma riktning; se [[dual_carriage] konfigurationsreferens](./Config_Reference.md#dual_carriage) för mer information).

20230810: Skriptet `flash-sdcard.sh` stöder nu båda varianterna av Bigtreetech SKR-3, STM32H743 och STM32H723. Den ursprungliga taggen `btt-skr-3` har därför bytt namn till antingen `btt-skr-3-h743` eller `btt-skr-3-h723`.

20230729: Den exporterade statusen för `dual_carriage` har ändrats. I stället för att exportera `mode` och `active_carriage` exporteras de enskilda lägena för varje vagn som `printer.dual_carriage.carriage_0` och `printer.dual_carriage.carriage_1`.

20230619: Alternativet `relative_reference_index` är föråldrat och har ersatts av `zero_reference_position`. Se [dokumentationen för bäddnät](./Bed_Mesh.md#the-deprecated-relative_reference_index) för hur konfigurationen uppdateras. I och med detta är `RELATIVE_REFERENCE_INDEX` inte längre tillgänglig som parameter till G-kodkommandot `BED_MESH_CALIBRATE`.

20230530: Standardfrekvensen för CAN-buss i `make menuconfig` är nu 1000000. Om CAN-buss med en annan frekvens krävs, välj "Enable extra low-level configuration options" och ange önskad "CAN bus speed" i `make menuconfig` när mikrokontrollern kompileras och flashas.

20230525: Kommandot `SHAPER_CALIBRATE` tillämpar omedelbart parametrar för Input Shaper om `[input_shaper]` redan var aktiverad.

20230407: Räknaren `stalled_bytes` i loggen och i fältet `printer.mcu.last_stats` har bytt namn till `upcoming_bytes`.

20230323: På tmc5160-drivrutiner är `multistep_filt` nu aktiverat som standard. Ange `driver_MULTISTEP_FILT: False` i tmc5160-konfigurationen för det tidigare beteendet.

20230304: Kommandot `SET_TMC_CURRENT` justerar nu korrekt registret `globalscaler` för drivrutiner som har det. Därmed försvinner begränsningen att strömmen för tmc5160 inte kunde höjas högre med `SET_TMC_CURRENT` än värdet `run_current` i konfigurationsfilen. Det har dock en bieffekt: efter att `SET_TMC_CURRENT` har körts måste stegmotorn hållas stilla i mer än 130 ms om StealthChop2 används, så att AT#1-kalibreringen utförs av drivrutinen.

20230202: Formatet för statusinformationen `printer.screws_tilt_adjust` har ändrats. Informationen lagras nu som en ordbok över skruvar med de resulterande mätningarna. Se [statusreferensen](Status_Reference.md#screws_tilt_adjust) för detaljer.

20230201: Modulen `[bed_mesh]` läser inte längre in profilen `default` vid start. Användare som använder profilen `default` rekommenderas att lägga till `BED_MESH_PROFILE LOAD=default` i sitt makro `START_PRINT` (eller i skivningsprogrammets konfiguration för "Start-G-kod" när det är tillämpligt).

20230103: Med skriptet `flash-sdcard.sh` går det nu att flasha båda varianterna av Bigtreetech SKR-2, STM32F407 och STM32F429. Detta innebär att den ursprungliga taggen `btt-skr2` nu har bytt namn till antingen `btt-skr-2-f407` eller `btt-skr-2-f429`.

20221128: Klipper v0.11.0 släpptes.

20221122: Tidigare kunde `z_hop` efter G28-referenskörning, med `safe_z_home`, gå i negativ Z-riktning. Nu utförs `z_hop` efter G28 endast om det ger ett positivt hopp, vilket motsvarar beteendet för `z_hop` före G28-referenskörning.

20220616: Tidigare gick det att flasha en rp2040 i uppstartsprogramläge genom att köra `make flash FLASH_DEVICE=first`. Motsvarande kommando är nu `make flash FLASH_DEVICE=2e8a:0003`.

20220612: Mikrokontrollern rp2040 har nu en lösning för USB-avvikelsen `rp2040-e5`. Detta bör göra inledande USB-anslutningar mer tillförlitliga. Det kan dock ändra beteendet för stiftet gpio15. Det är osannolikt att beteendeförändringen för gpio15 märks.

20220407: Konfigurationsalternativet `pid_integral_max` för `temperature_fan` har tagits bort (det föråldrades 20210612).

20220407: Standardfärgordningen för pca9632-LED är nu `RGBW`. Lägg till den uttryckliga inställningen `color_order: RBGW` i konfigurationsavsnittet för pca9632 för att få det tidigare beteendet.

20220330: Formatet för statusinformationen `printer.neopixel.color_data` för modulerna neopixel och dotstar har ändrats. Informationen lagras nu som en lista av färglistor (i stället för en lista av ordböcker). Se [statusreferensen](Status_Reference.md#led) för detaljer.

20220307: `M73` anger inte längre utskriftsförloppet till 0 om `P` saknas.

20220304: Det finns inte längre något standardvärde för parametern `extruder` i konfigurationsavsnitt för [extruder_stepper](Config_Reference.md#extruder_stepper). Ange uttryckligen `extruder: extruder` om stegmotorn vid start ska associeras med rörelsekön `extruder`.

20220210: Kommandot `SYNC_STEPPER_TO_EXTRUDER` är föråldrat; kommandot `SET_EXTRUDER_STEP_DISTANCE` är föråldrat; konfigurationsalternativet `shared_heater` för [extrudern](Config_Reference.md#extruder) är föråldrat. Funktionerna tas bort inom kort. Ersätt `SET_EXTRUDER_STEP_DISTANCE` med `SET_EXTRUDER_ROTATION_DISTANCE`. Ersätt `SYNC_STEPPER_TO_EXTRUDER` med `SYNC_EXTRUDER_MOTION`. Ersätt extruderkonfigurationsavsnitt som använder `shared_heater` med avsnitt för [extruder_stepper](Config_Reference.md#extruder_stepper) och uppdatera aktiveringsmakron till [SYNC_EXTRUDER_MOTION](G-Codes.md#sync_extruder_motion).

20220116: Beräkningskoden för `run_current` för tmc2130, tmc2208, tmc2209 och tmc2660 har ändrats. För vissa `run_current`-inställningar kan drivrutinerna nu konfigureras annorlunda. Den nya konfigurationen bör vara exaktare, men kan göra tidigare injustering av TMC-drivrutinen ogiltig.

20211230: Skripten för att justera Input Shaper (`scripts/calibrate_shaper.py` och `scripts/graph_accelerometer.py`) har migrerats till Python 3 som standard. Därför måste användare installera Python 3-versioner av vissa paket (till exempel `sudo apt install python3-numpy python3-matplotlib`) för att fortsätta använda skripten. Mer information finns under [Programvaruinstallation](Measuring_Resonances.md#software-installation). Alternativt kan skripten tillfälligt tvingas köras med Python 2 genom att Python 2-tolken anropas uttryckligen i konsolen: `python2 ~/klipper/scripts/calibrate_shaper.py ...`.

20211110: Temperatursensorn "NTC 100K beta 3950" är föråldrad. Sensorn tas bort inom kort. De flesta användare upplever temperatursensorn "Generic 3950" som mer exakt. För att fortsätta använda den äldre (vanligen mindre exakta) definitionen definierar du en anpassad [termistor](Config_Reference.md#thermistor) med `temperature1: 25`, `resistance1: 100000` och `beta: 3950`.

20211104: Alternativet "step pulse duration" i `make menuconfig` har tagits bort. Standardpulsbredden för TMC-drivrutiner som konfigurerats i UART- eller SPI-läge är nu 100 ns. En ny inställning, `step_pulse_duration`, i [stegmotorkonfigurationen](Config_Reference.md#stepper) ska anges för alla stegmotorer som behöver en anpassad pulsbredd.

20211102: Flera föråldrade funktioner har tagits bort. Stegmotoralternativet `step_distance` har tagits bort (föråldrat sedan 20201222). Sensoraliaset `rpi_temperature` har tagits bort (föråldrat sedan 20210219). MCU-alternativet `pin_map` har tagits bort (föråldrat sedan 20210325). Alternativet `default_parameter_<name>` för `gcode_macro` och makroåtkomst till kommandoparametrar på andra sätt än via pseudovariabeln `params` har tagits bort (föråldrat sedan 20210503). Värmaralternativet `pid_integral_max` har tagits bort (föråldrat sedan 20210612).

20210929: Klipper v0.10.0 släpptes.

20210903: Standardvärdet för [`smooth_time`](Config_Reference.md#extruder) för värmare har ändrats till 1 sekund (från 2 sekunder). För de flesta skrivare ger detta stabilare temperaturreglering.

20210830: Standardnamnet för adxl345 är nu `adxl345`. Standardparametern `CHIP` för `ACCELEROMETER_MEASURE` och `ACCELEROMETER_QUERY` är också `adxl345`.

20210830: Kommandot `ACCELEROMETER_MEASURE` för adxl345 stöder inte längre parametern `RATE`. Ändra frågefrekvensen genom att uppdatera `printer.cfg` och köra kommandot `RESTART`.

20210821: Flera konfigurationsinställningar i `printer.configfile.settings` rapporteras nu som listor i stället för råa strängar. Om den faktiska råa strängen önskas används `printer.configfile.config` i stället.

20210819: I vissa fall kan en referenskörning med `G28` avslutas i en position som nominellt ligger utanför det giltiga rörelseområdet. I sällsynta fall kan detta leda till förvirrande fel av typen "Rörelse utanför intervallet" efter referenskörning. Om detta inträffar ändrar du startskripten så att verktygshuvudet flyttas till en giltig position direkt efter referenskörningen.

20210814: De analoga pseudostiften på atmega168 och atmega328 har bytt namn från PE0/PE1 till PE2/PE3.

20210720: Ett avsnitt `controller_fan` övervakar nu alla stegmotorer som standard (inte bara de kinematiska stegmotorerna). Om det tidigare beteendet önskas, se konfigurationsalternativet `stepper` i [konfigurationsreferensen](Config_Reference.md#controller_fan).

20210703: Ett konfigurationsavsnitt `[samd_sercom]` måste nu ange den SERCOM-buss som konfigureras med alternativet `sercom`.

20210612: Konfigurationsalternativet `pid_integral_max` i avsnitten `heater` och `temperature_fan` är föråldrat. Alternativet tas bort inom kort.

20210503: The gcode_macro `default_parameter_<name>` config option is deprecated. Use the `params` pseudo-variable to access macro parameters. Other methods for accessing macro parameters will be removed in the near future. Most users can replace a `default_parameter_NAME: VALUE` config option with a line like the following in the start of the macro: ` {% set NAME = params.NAME|default(VALUE)|float %}`. See the [Command Templates
document](Command_Templates.md#macro-parameters) for examples.

20210430: Kommandot SET_VELOCITY_LIMIT (och M204) kan nu ange hastighet, acceleration och `square_corner_velocity` som är större än värdena i konfigurationsfilen.

20210325: Stödet för konfigurationsalternativet `pin_map` är föråldrat. Använd filen [sample-aliases.cfg](../config/sample-aliases.cfg) för att översätta till mikrokontrollerns verkliga stiftnamn. Konfigurationsalternativet `pin_map` tas bort inom kort.

20210313: Klippers stöd för mikrokontroller som kommunicerar via CAN-buss har ändrats. Om CAN-buss används måste alla mikrokontroller programmeras om och [Klipper-konfigurationen uppdateras](CANBUS.md).

20210310: Standardvärdet för `driver_SFILT` för TMC2660 har ändrats från 1 till 0.

20210227: TMC-stegmotordrivare i UART- eller SPI-läge avfrågas nu en gång per sekund när de är aktiverade. Om drivrutinen inte kan nås eller rapporterar ett fel går Klipper över till avstängt läge.

20210219: Modulen `rpi_temperature` har bytt namn till `temperature_host`. Ersätt varje förekomst av `sensor_type: rpi_temperature` med `sensor_type: temperature_host`. Sökvägen till temperaturfilen kan anges i konfigurationsvariabeln `sensor_path`. Namnet `rpi_temperature` är föråldrat och tas bort inom kort.

20210201: Kommandot `TEST_RESONANCES` inaktiverar nu Input Shaping om den tidigare var aktiverad (och aktiverar den igen efter testet). För att åsidosätta detta beteende och behålla Input Shaping aktiverad kan den extra parametern `INPUT_SHAPING=1` skickas till kommandot.

20210201: Kommandot `ACCELEROMETER_MEASURE` lägger nu till namnet på accelerometerkretsen i utdatafilens namn, om kretsen har fått ett namn i motsvarande avsnitt för `adxl345` i `printer.cfg`.

20201222: Inställningen `step_distance` i stegmotorns konfigurationsavsnitt är föråldrad. Konfigurationen bör uppdateras så att inställningen [`rotation_distance`](Rotation_Distance.md) används. Stödet för `step_distance` tas bort inom kort.

20201218: Inställningen `endstop_phase` i modulen `endstop_phase` har ersatts av `trigger_phase`. Om modulen för ändstoppsfaser används måste man konvertera till [`rotation_distance`](Rotation_Distance.md) och kalibrera om ändstoppsfaserna genom att köra kommandot `ENDSTOP_PHASE_CALIBRATE`.

20201218: Skrivare av typen roterande delta och polär måste nu ange `gear_ratio` för sina roterande stegmotorer och får inte längre ange parametern `step_distance`. Se [konfigurationsreferensen](Config_Reference.md#stepper) för formatet på den nya parametern `gear_ratio`.

20201213: Det är inte giltigt att ange en Z-`position_endstop` när `probe:z_virtual_endstop` används. Ett fel utlöses nu om en Z-`position_endstop` anges tillsammans med `probe:z_virtual_endstop`. Ta bort definitionen av Z-`position_endstop` för att åtgärda felet.

20201120: Konfigurationsavsnittet `[board_pins]` anger nu MCU-namnet i en uttrycklig parameter, `mcu:`. Om `board_pins` används för en sekundär MCU måste konfigurationen uppdateras med namnet. Se [konfigurationsreferensen](Config_Reference.md#board_pins) för mer information.

20201112: Tiden som rapporteras av `print_stats.print_duration` har ändrats. Tiden före den första upptäckta extruderingen räknas nu inte med.

20201029: Konfigurationsalternativet `color_order_GRB` för neopixel har tagits bort. Uppdatera vid behov konfigurationen så att det nya alternativet `color_order` anges som RGB, GRB, RGBW eller GRBW.

20201029: Alternativet `serial` i MCU-konfigurationsavsnittet har inte längre `/dev/ttyS0` som standard. I det sällsynta fall då `/dev/ttyS0` är den önskade seriella porten måste den anges uttryckligen.

20201020: Klipper v0.9.0 släpptes.

20200902: Beräkningen av resistans till temperatur för MAX31865-omvandlare har korrigerats så att den inte längre visar för lågt värde. Om du använder en sådan enhet bör utskriftstemperaturen och PID-inställningarna kalibreras om.

20200816: Objektet `printer.gcode` för G-kodmakron har bytt namn till `printer.gcode_move`. Flera odokumenterade variabler i `printer.toolhead` och `printer.gcode` har tagits bort. Se `docs/Command_Templates.md` för en lista över tillgängliga mallvariabler.

20200816: Systemet för G-kodmakron med `action_` har ändrats. Ersätt anrop till `printer.gcode.action_emergency_stop()` med `action_emergency_stop()`, `printer.gcode.action_respond_info()` med `action_respond_info()` och `printer.gcode.action_respond_error()` med `action_raise_error()`.

20200809: Menysystemet har skrivits om. Om menyn har anpassats måste den uppdateras till den nya konfigurationen. Se `config/example-menu.cfg` för konfigurationsinformation och `klippy/extras/display/menu.cfg` för exempel.

20200731: Beteendet för attributet `progress` som rapporteras av skrivarobjektet `virtual_sdcard` har ändrats. Förloppet återställs inte längre till 0 när en utskrift pausas. Det rapporteras nu alltid utifrån den interna filpositionen, eller 0 om ingen fil för närvarande är inläst.

20200725: Servons konfigurationsparameter `enable` och parametern `ENABLE` för SET_SERVO har tagits bort. Uppdatera makron så att `SET_SERVO SERVO=my_servo WIDTH=0` används för att inaktivera en servo.

20200608: LCD-skärmsstödet har ändrat namnet på vissa interna "glyfer". Om en anpassad skärmlayout har implementerats kan den behöva uppdateras till de senaste glyfnamnen (se `klippy/extras/display/display.cfg` för en lista över tillgängliga glyfer).

20200606: Stiftnamnen för Linux-MCU har ändrats. Stiften har nu namn i formen `gpiochip<chipid>/gpio<gpio>`. För gpiochip0 kan även den korta formen `gpio<gpio>` användas. Till exempel blir det som tidigare kallades `P20` nu `gpio20` eller `gpiochip0/gpio20`.

20200603: Standardlayouten för en 16×4-LCD visar inte längre beräknad återstående tid för en utskrift. (Endast förfluten tid visas.) Om det gamla beteendet önskas kan menyskärmen anpassas med informationen (se beskrivningen av `display_data` i `config/example-extras.cfg` för detaljer).

20200531: Standard-id för USB-leverantör/produkt är nu `0x1d50/0x614e`. De nya id-värdena är reserverade för Klipper (tack vare projektet openmoko). Ändringen bör inte kräva några konfigurationsändringar, men de nya id-värdena kan visas i systemloggar.

20200524: Standardvärdet för fältet `pwm_freq` i tmc5160 är nu noll (i stället för ett).

20200425: Kommandomallvariabeln `printer.heater` för `gcode_macro` har bytt namn till `printer.heaters`.

20200313: Standardlayouten för LCD på skrivare med flera extrudrar och en 16×4-skärm har ändrats. Layouten för en enda extruder är nu standard och visar den aktuella aktiva extrudern. Använd den tidigare skärmlayouten genom att ange `display_group: _multiextruder_16x4` i avsnittet `[display]` i filen `printer.cfg`.

20200308: Standardmenyalternativet `__test` har tagits bort. Om konfigurationsfilen har en anpassad meny måste alla hänvisningar till menyalternativet `__test` tas bort.

20200308: Menyalternativen "deck" och "card" har tagits bort. Anpassa layouten för en LCD-skärm med de nya konfigurationsavsnitten `display_data` (se `config/example-extras.cfg` för detaljer).

20200109: Modulen `bed_mesh` använder nu sondens plats för nätkonfigurationen. Därför har vissa konfigurationsalternativ bytt namn så att deras funktion beskrivs tydligare. För rektangulära bäddar har `min_point` respektive `max_point` bytt namn till `mesh_min` och `mesh_max`. För runda bäddar har `bed_radius` bytt namn till `mesh_radius`. Alternativet `mesh_origin` har också lagts till för runda bäddar. Observera att ändringarna även är inkompatibla med tidigare sparade nätprofiler. En inkompatibel profil ignoreras och schemaläggs för borttagning. Borttagningen slutförs med kommandot `SAVE_CONFIG`. Varje profil måste sedan kalibreras om.

20191218: Skärmkonfigurationsavsnittet stöder inte längre `lcd_type: st7567`. Använd i stället skärmtypen `uc1701`: ange `lcd_type: uc1701` och ändra `rs_pin: some_pin` till `rst_pin: some_pin`. Inställningen `contrast: 60` kan också behöva läggas till.

20191210: De inbyggda kommandona T0, T1, T2 osv. har tagits bort. Konfigurationsalternativen `activate_gcode` och `deactivate_gcode` för extrudern har tagits bort. Om kommandona och skripten behövs ska enskilda makron av typen `[gcode_macro T0]` definieras, som anropar kommandot `ACTIVATE_EXTRUDER`. Se `config/sample-idex.cfg` och `sample-multi-extruder.cfg` för exempel.

20191210: Stödet för kommandot M206 har tagits bort. Ersätt det med anrop till `SET_GCODE_OFFSET`. Om stöd för M206 behövs lägger du till ett konfigurationsavsnitt `[gcode_macro M206]` som anropar `SET_GCODE_OFFSET` (till exempel `SET_GCODE_OFFSET Z=-{params.Z}`).

20191202: Stödet för den odokumenterade parametern `S` till kommandot `G4` har tagits bort. Ersätt varje förekomst av S med standardparametern `P` (fördröjningen anges i millisekunder).

20191126: USB-namnen har ändrats på mikrokontroller med inbyggt USB-stöd. De använder nu som standard ett unikt krets-id där sådant finns. Om ett konfigurationsavsnitt `mcu` använder en `serial`-inställning som börjar med `/dev/serial/by-id/` kan konfigurationen behöva uppdateras. Kör `ls /dev/serial/by-id/*` i en SSH-terminal för att fastställa det nya id:t.

20191121: Parametern `pressure_advance_lookahead_time` har tagits bort. Se `example.cfg` för alternativa konfigurationsinställningar.

20191112: Funktionen för virtuell aktivering i TMC-stegmotordrivaren aktiveras nu automatiskt om stegmotorn saknar ett eget aktiveringsstift. Ta bort hänvisningar till `tmcXXXX:virtual_enable` från konfigurationen. Möjligheten att styra flera stift i stegmotorns `enable_pin`-konfiguration har tagits bort. Om flera stift behövs använder du ett konfigurationsavsnitt `multi_pin`.

20191107: Konfigurationsavsnittet för den primära extrudern måste anges som `extruder` och får inte längre anges som `extruder0`. Kommandomallar för G-kod som frågar efter extruderns status nås nu via `{printer.extruder}`.

20191021: Klipper v0.8.0 släpptes

20191003: Alternativet `move_to_previous` i `[safe_z_homing]` har nu `False` som standard. (Det hade i praktiken värdet `False` före 20190918.)

20190918: Alternativet `zhop` i `[safe_z_homing]` tillämpas alltid igen när referenskörningen för Z-axeln har slutförts. Anpassade skript som bygger på modulen kan behöva uppdateras.

20190806: Kommandot `SET_NEOPIXEL` har bytt namn till `SET_LED`.

20190726: Den digitala till analoga koden för mcp4728 har ändrats. Standard-`i2c_address` är nu `0x60` och spänningsreferensen är nu relativ till mcp4728:s interna referens på 2,048 volt.

20190710: Alternativet `z_hop` har tagits bort från konfigurationsavsnittet `[firmware_retract]`. Stödet för `z_hop` var ofullständigt och kunde orsaka felaktigt beteende i flera vanliga skivningsprogram.

20190710: De valfria parametrarna till kommandot `PROBE_ACCURACY` har ändrats. Makron eller skript som använder kommandot kan behöva uppdateras.

20190628: Alla konfigurationsalternativ har tagits bort från avsnittet `[skew_correction]`. Konfiguration av `skew_correction` görs nu via G-koden `SET_SKEW`. Se [Skjuvkompensation](Skew_Correction.md) för rekommenderad användning.

20190607: Parametrarna `variable_X` för `gcode_macro` (tillsammans med parametern `VALUE` för `SET_GCODE_VARIABLE`) tolkas nu som Python-litteraler. Om ett värde ska tilldelas en sträng måste värdet omslutas av citattecken så att det utvärderas som en sträng.

20190606: Konfigurationsalternativen `samples`, `samples_result` och `sample_retract_dist` har flyttats till konfigurationsavsnittet `probe`. De stöds inte längre i konfigurationsavsnitten `delta_calibrate`, `bed_tilt`, `bed_mesh`, `screws_tilt_adjust`, `z_tilt` eller `quad_gantry_level`.

20190528: Den magiska variabeln `status` vid mallutvärdering för `gcode_macro` har bytt namn till `printer`.

20190520: Kommandot `SET_GCODE_OFFSET` har ändrats; uppdatera G-kodmakron därefter. Kommandot tillämpar inte längre den begärda förskjutningen på nästa G1-kommando. Det gamla beteendet kan efterliknas med den nya parametern `MOVE=1`.

20190404: Python-paketen för värdprogramvaran har uppdaterats. Användare måste köra skriptet `~/klipper/scripts/install-octopi.sh` igen (eller på annat sätt uppgradera Python-beroendena om en standardinstallation av OctoPi inte används).

20190404: Parametrarna `i2c_bus` och `spi_bus` (i olika konfigurationsavsnitt) tar nu ett bussnamn i stället för ett nummer.

20190404: Konfigurationsparametrarna för sx1509 har ändrats. Parametern `address` heter nu `i2c_address` och måste anges som ett decimaltal. Där `0x3E` tidigare användes ska `62` anges.

20190328: Värdet `min_speed` i konfigurationen `[temperature_fan]` respekteras nu och fläkten körs alltid med den här hastigheten eller högre i PID-läge.

20190322: Standardvärdet för `driver_HEND` i konfigurationsavsnitten `[tmc2660]` har ändrats från 6 till 3. Fältet `driver_VSENSE` har tagits bort (det beräknas nu automatiskt utifrån `run_current`).

20190310: Konfigurationsavsnittet `[controller_fan]` kräver nu alltid ett namn (som `[controller_fan my_controller_fan]`).

20190308: Fältet `driver_BLANK_TIME_SELECT` i konfigurationsavsnitten `[tmc2130]` och `[tmc2208]` har bytt namn till `driver_TBL`.

20190308: Konfigurationsavsnittet `[tmc2660]` har ändrats. En ny konfigurationsparameter, `sense_resistor`, måste nu anges. Innebörden av flera parametrar av typen `driver_XXX` har ändrats.

20190228: Användare av SPI eller I2C på SAMD21-kort måste nu ange bussens stift via ett konfigurationsavsnitt `[samd_sercom]`.

20190224: Alternativet `bed_shape` har tagits bort från `bed_mesh`. Alternativet `radius` har bytt namn till `bed_radius`. Användare med runda bäddar bör ange alternativen `bed_radius` och `round_probe_count`.

20190107: Parametern `i2c_address` i konfigurationsavsnittet för mcp4451 har ändrats. Detta är en vanlig inställning på Smoothieboard. Det nya värdet är hälften av det gamla värdet (88 ska ändras till 44 och 90 till 45).

20181220: Klipper v0.7.0 släpptes
