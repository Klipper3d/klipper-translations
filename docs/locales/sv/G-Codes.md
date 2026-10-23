# G-koder

Detta dokument beskriver de kommandon som Klipper har stöd för. Dessa kommandon kan anges på terminalfliken i OctoPrint.

## G-kodskommandon

Klipper har stöd för följande vanliga G-kodskommandon:

- Förflyttning (G0 eller G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- Dröjsmål: `G4 P<milliseconds>`
- Flytta till origo: `G28 [X] [Y] [Z]`
- Stäng av motorer: `M18` eller `M84`
- Vänta tills aktuella förflyttningar är klara: `M400`
- Använd absoluta/relativa avstånd för extrudering: `M82`, `M83`
- Använd absoluta/relativa koordinater: `G90`, `G91`
- Ange position: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- Ange åsidosättningsprocent för hastighetsfaktor: `M220 S<percent>`
- Ange åsidosättningsprocent för extruderingsfaktor: `M221 S<percent>`
- Ange acceleration: `M204 S<value>` ELLER `M204 P<value> T<value>`
   - Obs: Om S inte anges och både P och T anges, ställs accelerationen in på det minsta av P och T. Om endast P eller T anges har kommandot ingen verkan.
- Hämta extrudertemperatur: `M105`
- Ange extrudertemperatur: `M104 [T<index>] [S<temperature>]`
- Ange extrudertemperatur och vänta: `M109 [T<index>] S<temperature>`
   - Obs: M109 väntar alltid på att temperaturen stabiliseras vid det begärda värdet
- Ange bäddtemperatur: `M140 [S<temperature>]`
- Ange bäddtemperatur och vänta: `M190 S<temperature>`
   - Obs: M190 väntar alltid på att temperaturen stabiliseras vid det begärda värdet
- Ange fläkthastighet: `M106 S<value>`
- Stäng av fläkten: `M107`
- Nödstopp: `M112`
- Hämta aktuell position: `M114`
- Hämta firmwareversion: `M115`

Mer information om ovanstående kommandon finns i [RepRap G-Code-dokumentationen](http://reprap.org/wiki/G-code).

Klippers mål är att stödja G-kodskommandon som skapas av vanliga program från tredje part (t.ex. OctoPrint, Printrun, Slic3r och Cura) i deras standardkonfigurationer. Målet är inte att stödja alla möjliga G-kodskommandon. I stället föredrar Klipper läsbara [”utökade G-kodskommandon”](#additional-commands). På samma sätt är G-kodsutdata i terminalen endast avsedd att vara läsbar för människor – se [API Server-dokumentet](API_Server.md) om Klipper ska styras från extern programvara.

Om ett mindre vanligt G-kodskommando behövs kan det vara möjligt att implementera det med ett anpassat [gcode_macro-konfigurationsavsnitt](Config_Reference.md#gcode_macro). Det kan till exempel användas för att implementera: `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1` osv.

## Ytterligare kommandon

Klipper använder ”utökade” G-kodskommandon för allmän konfiguration och status. Dessa utökade kommandon följer alla ett liknande format – de börjar med ett kommandonamn och kan följas av en eller flera parametrar. Till exempel: `SET_SERVO SERVO=myservo ANGLE=5.3`. I detta dokument visas kommandon och parametrar med versaler, men de är inte skiftlägeskänsliga. (Alltså kör ”SET_SERVO” och ”set_servo” samma kommando.)

Detta avsnitt är organiserat efter Klipper-modulnamn, som vanligen följer avsnittsnamnen i [skrivarkonfigurationsfilen](Config_Reference.md). Observera att vissa moduler läses in automatiskt.

### [adxl345]

Följande kommandon är tillgängliga när ett [adxl345-konfigurationsavsnitt](Config_Reference.md#adxl345) är aktiverat.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: Startar accelerometermätningar med begärt antal prover per sekund. Om CHIP inte anges används ”adxl345” som standard. Kommandot fungerar i start-/stoppläge: första körningen startar mätningarna och nästa körning stoppar dem. Mätresultaten skrivs till filen `/tmp/adxl345-<chip>-<name>.csv`, där `<chip>` är namnet på accelerometerkretsen (`my_chip_name` från `[adxl345 my_chip_name]`) och `<name>` är den valfria NAME-parametern. Om NAME inte anges används aktuell tid i formatet ”YYYYMMDD_HHMMSS”. Om accelerometern saknar namn i sitt konfigurationsavsnitt (endast `[adxl345]`) skapas inte delen `<chip>` av filnamnet.

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: Hämtar aktuellt värde från accelerometern. Om CHIP inte anges används ”adxl345” som standard. Om RATE inte anges används standardvärdet. Kommandot är användbart för att testa anslutningen till ADXL345-accelerometern: ett av de returnerade värdena bör vara en fritt fall-acceleration (± visst brus från kretsen).

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`: Hämtar ADXL345-registret ”register” (t.ex. 44 eller 0x2C). Kan vara användbart för felsökning.

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<register> VAL=<value>`: Skriver rått ”value” till registret ”register”. Både ”value” och ”register” kan vara heltal i decimal- eller hexadecimalform. Använd med försiktighet och se databladet för ADXL345 som referens.

### [angle]

Följande kommandon är tillgängliga när ett [angle-konfigurationsavsnitt](Config_Reference.md#angle) är aktiverat.

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<chip_name>`: Utför vinkelkalibrering på den angivna sensorn (det måste finnas ett `[angle chip_name]`-konfigurationsavsnitt med en angiven `stepper`-parameter). VIKTIGT – verktyget beordrar stegmotorn att flytta utan att kontrollera normala kinematiska gränser. Helst ska motorn kopplas loss från skrivarens vagn före kalibrering. Om stegmotorn inte kan kopplas loss från skrivaren ska du kontrollera att vagnen befinner sig nära mitten av sin skena innan kalibreringen startas. (Stegmotorn kan rotera två hela varv framåt eller bakåt under testet.) Kör `SAVE_CONFIG` efter testet för att spara kalibreringsdata i konfigurationsfilen. För att använda verktyget måste Python-paketet ”numpy” vara installerat (se [dokumentet om resonansmätning](Measuring_Resonances.md#software-installation) för mer information).

#### ANGLE_CHIP_CALIBRATE

`ANGLE_CHIP_CALIBRATE CHIP=<chip_name>`: Utför intern sensorkalibrering, om den är implementerad (MT6826S/MT6835).

- **MT68XX**: Motorn ska kopplas bort från alla skrivarvagnar före kalibreringen. Efter kalibreringen ska sensorn återställas genom att strömmen kopplas bort.

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: Hämtar sensorregistret ”register” (t.ex. 44 eller 0x2C). Kan vara användbart för felsökning. Finns endast för tle5012b-kretsar.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: Skriver rått ”value” till registret ”register”. Både ”value” och ”register” kan vara heltal i decimal- eller hexadecimalform. Använd med försiktighet och se sensorns datablad som referens. Finns endast för tle5012b-kretsar.

### [axis_twist_compensation]

The following commands are available when the [axis_twist_compensation config
section](Config_Reference.md#axis_twist_compensation) is enabled.

#### AXIS_TWIST_COMPENSATION_CALIBRATE

`AXIS_TWIST_COMPENSATION_CALIBRATE [AXIS=<X|Y>] [SAMPLE_COUNT=<value>]`

Kalibrerar kompensation för axelvridning genom att ange målaxeln eller aktivera automatisk kalibrering.

- **AXIS:** Ange axeln (`X` eller `Y`) vars vridningskompensation ska kalibreras. Om den inte anges används `'X'` som standard.

### [bed_mesh]

Följande kommandon är tillgängliga när ett [bed_mesh-konfigurationsavsnitt](Config_Reference.md#bed_mesh) är aktiverat (se även [guiden för bäddnät](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [PROFILE=<name>] [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=1] [ADAPTIVE_MARGIN=<value>]`: Kommandot mäter bädden med genererade punkter enligt parametrarna i konfigurationen. Därefter genereras ett nät och Z-rörelsen justeras enligt nätet. Nätet aktiveras direkt när `BED_MESH_CALIBRATE` har slutförts och sparas i profilen som anges av `PROFILE`, eller i `default` om den inte anges. Om ADAPTIVE=1 anges börjar profilnamnet med `adaptive-` och bör inte sparas för återanvändning. Se PROBE för information om valfria mätparametrar. Om METHOD=manual anges aktiveras verktyget för manuell mätning. Det valfria värdet `HORIZONTAL_MOVE_Z` åsidosätter `horizontal_move_z` i konfigurationsfilen. Om ADAPTIVE=1 anges används objekten i G-kodsfilen som skrivs ut för att avgränsa mätområdet. Det valfria värdet `ADAPTIVE_MARGIN` åsidosätter `adaptive_margin` i konfigurationsfilen.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`: Detta kommando skriver ut aktuella Z-värden från sonderingen och aktuella nätvärden till terminalen. Om PGP=1 anges skrivs de X- och Y-koordinater som skapas av bed_mesh, tillsammans med motsvarande index, ut till terminalen.

#### BED_MESH_MAP

`BED_MESH_MAP`: I likhet med BED_MESH_OUTPUT skriver detta kommando ut nätets aktuella tillstånd till terminalen. I stället för att skriva ut värdena i läsbar form serialiseras tillståndet i JSON-format. Det gör det möjligt för OctoPrint-insticksmoduler att enkelt fånga data och skapa höjdkartor som motsvarar bäddens yta.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: Detta kommando rensar nätet och tar bort alla Z-justeringar. Det rekommenderas att lägga till detta i slut-G-koden.

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<name> SAVE=<name> REMOVE=<name>`: Detta kommando tillhandahåller profilhantering för nättillståndet. LOAD återställer nättillståndet från profilen som matchar angivet namn. SAVE sparar aktuellt nättillstånd i en profil som matchar angivet namn. REMOVE tar bort profilen som matchar angivet namn från beständigt minne. Observera att G-koden SAVE_CONFIG måste köras efter SAVE- eller REMOVE-operationer för att göra ändringarna i beständigt minne permanenta.

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value]`: Tillämpar X-, Y- och/eller ZFADE-förskjutningar vid uppslag i bäddnätet. Det är användbart för skrivare med oberoende extrudrar, eftersom en förskjutning behövs för korrekt Z-justering efter verktygsbyte. Observera att en ZFADE-förskjutning inte direkt tillämpar ytterligare Z-justering, utan används för att korrigera beräkningen av `fade` när en `gcode offset` har tillämpats på Z-axeln.

### [bed_screws]

Följande kommandon är tillgängliga när ett [bed_screws-konfigurationsavsnitt](Config_Reference.md#bed_screws) är aktiverat (se även [guiden för manuell nivåjustering](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`: Detta kommando startar verktyget för justering av bäddskruvar. Munstycket flyttas till olika platser (enligt konfigurationsfilen), så att du kan justera bäddskruvarna så att bädden har ett konstant avstånd från munstycket.

### [bed_tilt]

Följande kommandon är tillgängliga när ett [bed_tilt-konfigurationsavsnitt](Config_Reference.md#bed_tilt) är aktiverat.

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Kommandot mäter punkterna som anges i konfigurationen och rekommenderar sedan uppdaterade X- och Y-justeringar för bäddens lutning. Se kommandot PROBE för information om de valfria mätparametrarna. Om METHOD=manual anges aktiveras verktyget för manuell mätning. Se kommandot MANUAL_PROBE ovan för ytterligare kommandon som är tillgängliga när verktyget är aktivt. Det valfria värdet `HORIZONTAL_MOVE_Z` åsidosätter alternativet `horizontal_move_z` i konfigurationsfilen.

### [bltouch]

Följande kommando är tillgängligt när ett [bltouch-konfigurationsavsnitt](Config_Reference.md#bltouch) är aktiverat (se även [BL-Touch-guiden](BLTouch.md)).

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<command>`: Skickar ett kommando till BLTouch. Det kan vara användbart för felsökning. Tillgängliga kommandon är: `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`. En BL-Touch V3.0 eller V3.1 kan också ha stöd för kommandona `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store`.

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>`: Lagrar ett utgångsläge i EEPROM på en BLTouch V3.1. Tillgängliga output_modes är: `5V`, `OD`

### [configfile]

Modulen configfile läses in automatiskt.

#### SAVE_CONFIG

`SAVE_CONFIG`: Detta kommando skriver över huvudfilen för skrivarkonfigurationen och startar om värdprogrammet. Det används tillsammans med andra kalibreringskommandon för att lagra resultaten från kalibreringstester.

### [delayed_gcode]

Följande kommando aktiveras om ett [delayed_gcode-konfigurationsavsnitt](Config_Reference.md#delayed_gcode) har aktiverats (se även [mallguiden](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: Uppdaterar fördröjningstiden för den identifierade [delayed_gcode] och startar timern för G-kodskörning. Värdet 0 avbryter en väntande fördröjd G-kod innan den körs.

### [delta_calibrate]

Följande kommandon är tillgängliga när ett [delta_calibrate-konfigurationsavsnitt](Config_Reference.md#linear-delta-kinematics) är aktiverat (se även [guiden för delta-kalibrering](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Kommandot mäter sju punkter på bädden och rekommenderar sedan uppdaterade ändstoppspositioner, tornvinklar och radie. Se kommandot PROBE för information om de valfria mätparametrarna. Om METHOD=manual anges aktiveras verktyget för manuell mätning. Se kommandot MANUAL_PROBE ovan för ytterligare kommandon som är tillgängliga när verktyget är aktivt. Det valfria värdet `HORIZONTAL_MOVE_Z` åsidosätter alternativet `horizontal_move_z` i konfigurationsfilen.

#### DELTA_ANALYZE

`DELTA_ANALYZE`: Detta kommando används vid utökad delta-kalibrering. Se [Delta Calibrate](Delta_Calibrate.md) för mer information.

### [display]

Följande kommando är tillgängligt när ett [display-konfigurationsavsnitt](Config_Reference.md#gcode_macro) är aktiverat.

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`: Ange den aktiva visningsgruppen för en LCD-skärm. Det gör det möjligt att definiera flera grupper av visningsdata i konfigurationen, t.ex. `[display_data <group> <elementname>]`, och växla mellan dem med detta utökade G-kodskommando. Om DISPLAY inte anges används ”display” (den primära skärmen) som standard.

### [display_status]

Modulen display_status läses in automatiskt om ett [display-konfigurationsavsnitt](Config_Reference.md#display) är aktiverat. Den tillhandahåller följande vanliga G-kodskommandon:

- Visa meddelande: `M117 <message>`
- Ange byggprocent: `M73 P<percent>`

Följande utökade G-kodskommando tillhandahålls också:

- `SET_DISPLAY_TEXT MSG=<message>`: Utför motsvarigheten till M117 och anger `MSG` som aktuellt visningsmeddelande. Om `MSG` utelämnas rensas visningen.

### [dual_carriage]

Följande kommando är tillgängligt när ett [dual_carriage-konfigurationsavsnitt](Config_Reference.md#dual_carriage) är aktiverat.

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=<carriage> [MODE=[PRIMARY|COPY|MIRROR|INACTIVE]]`: Ändrar läget för den angivna vagnen. Om `MODE` inte anges används `PRIMARY`. `<carriage>` måste referera till en definierad primär eller dubbel vagn för kinematiken `generic_cartesian` eller vara 0 (primär vagn) eller 1 (dubbel vagn) för övrig IDEX-kompatibel kinematik. Läget `PRIMARY` inaktiverar alla andra vagnar på samma axel och gör att den angivna vagnen utför följande G-kodsförflyttningar oförändrat. Innan `COPY` eller `MIRROR` aktiveras för en vagn måste en annan vagn vara aktiverad som `PRIMARY` på samma axel. I dessa lägen följer vagnen efterföljande G-kodsförflyttningar och kopierar relativa förflyttningar (`COPY`) eller utför dem i motsatt spegelriktning (`MIRROR`). `INACTIVE` inaktiverar vagnen och gör att den ignorerar fortsatta G-kodsförflyttningar. Observera att avaktivering av den primära vagnen på axeln inte inaktiverar andra vagnar i `COPY`- eller `MIRROR`-läge. Det kan användas för att stoppa utskrift av en misslyckad del med ett verktyg och parkera verktyget för att undvika kollisioner med en ofärdig del. Se denna [exempelkonfiguration](../config/sample-corexyuv.cfg) för makroexempel.

#### SAVE_DUAL_CARRIAGE_STATE

`SAVE_DUAL_CARRIAGE_STATE [NAME=<state_name>]`: Sparar de dubbla vagnarnas aktuella positioner och lägen. Att spara och återställa DUAL_CARRIAGE-tillståndet kan vara användbart i skript och makron samt i åsidosättningar av referenskörningsrutiner. Om NAME anges kan det sparade tillståndet få ett namn. Om NAME inte anges används "default".

#### RESTORE_DUAL_CARRIAGE_STATE

`RESTORE_DUAL_CARRIAGE_STATE [NAME=<state_name>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: Återställer tidigare sparade tillstånd för alla dubbla vagnar och deras primära vagnar. Kommandot återställer vagnarnas lägen och flyttar dem till de tidigare sparade positionerna, om inte "MOVE=0" anges. Om positioner återställs och "MOVE_SPEED" anges flyttas vagnarna högst med den angivna hastigheten (i mm/s); annars används referenskörningshastigheten för respektive vagn som referens. Observera att vagnarna återställer sina positioner endast längs sina egna axlar, vilket kan krävas för att korrekt återställa COPY- och MIRROR-läge för den dubbla vagnen. Kommandot uppdaterar dessutom Klippers verktygshuvudposition för varje axel med dubbla vagnar: den sätts så att den motsvarar den faktiska positionen för axelns aktiva primära vagn eller, om axeln saknar sparad primär vagn, till axelpositionen när `SAVE_DUAL_CARRIAGE_STATE` kördes.

### [endstop_phase]

Följande kommandon är tillgängliga när ett [endstop_phase-konfigurationsavsnitt](Config_Reference.md#endstop_phase) är aktiverat (se även [guiden för ändlägesfas](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]`: Om ingen STEPPER-parameter anges rapporterar kommandot statistik om ändlägesstegmotorfaser vid tidigare referenskörningar. När en STEPPER-parameter anges ordnar kommandot så att den angivna fasinställningen för ändläget skrivs till konfigurationsfilen (tillsammans med kommandot SAVE_CONFIG).

### [exclude_object]

Följande kommandon är tillgängliga när ett [exclude_object-konfigurationsavsnitt](Config_Reference.md#exclude_object) är aktiverat (se även [guiden för att utesluta objekt](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=object_name] [CURRENT=1] [RESET=1]`: Utan parametrar returneras en lista över alla objekt som för närvarande är uteslutna.

När parametern `NAME` anges utesluts det namngivna objektet från utskriften.

När parametern `CURRENT` anges utesluts aktuellt objekt från utskriften.

När parametern `RESET` anges rensas listan över uteslutna objekt. Om `NAME` också anges återställs endast det namngivna objektet. Detta **kan** orsaka utskriftsfel om lager redan har hoppats över.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=object_name [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`: Tillhandahåller en sammanfattning av ett objekt i filen.

Utan angivna parametrar listas de definierade objekt som Klipper känner till. Returnerar en lista med strängar, om inte parametern `JSON` anges; då returneras objektdetaljer i JSON-format.

När parametern `NAME` inkluderas definieras ett objekt som ska uteslutas.

- `NAME`: Denna parameter krävs. Den är identifieraren som används av andra kommandon i modulen.
- `CENTER`: En X,Y-koordinat för objektet.
- `POLYGON`: En matris med X,Y-koordinater som utgör objektets kontur.

När parametern `RESET` anges rensas alla definierade objekt och modulen `[exclude_object]` återställs.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=object_name`: Kommandot tar parametern `NAME` och markerar starten på G-koden för ett objekt i aktuellt lager.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=object_name]`: Markerar slutet på objektets G-kod för lagret. Det paras med `EXCLUDE_OBJECT_START`. Parametern `NAME` är valfri och varnar endast när angivet namn inte matchar aktuellt objekt.

### [extruder]

Följande kommandon är tillgängliga om ett [extruder-konfigurationsavsnitt](Config_Reference.md#extruder) är aktiverat:

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<config_name>`: I en skrivare med flera [extruder-konfigurationsavsnitt](Config_Reference.md#extruder) ändrar detta kommando aktiv hotend.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Ange parametrar för tryckutjämning för en extruderstegmotor (enligt definition i ett [extruder-](Config_Reference.md#extruder) eller [extruder_stepper-konfigurationsavsnitt](Config_Reference.md#extruder_stepper)). Om EXTRUDER inte anges används stegmotorn som definieras i den aktiva hotend som standard.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: Ange ett nytt värde för den angivna extruderstegmotorns ”rotationsavstånd” (enligt definition i ett [extruder-](Config_Reference.md#extruder) eller [extruder_stepper-konfigurationsavsnitt](Config_Reference.md#extruder_stepper)). Om rotationsavståndet är negativt inverteras stegmotorns rörelse (i förhållande till stegmotorriktningen som anges i konfigurationsfilen). Ändrade inställningar behålls inte vid återställning av Klipper. Använd med försiktighet: små ändringar kan ge för högt tryck mellan extruder och hotend. Utför korrekt kalibrering med filament före användning. Om värdet DISTANCE inte anges returnerar kommandot aktuellt rotationsavstånd.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<name> MOTION_QUEUE=<name>`: Kommandot gör att stegmotorn som anges av EXTRUDER (enligt definition i ett [extruder-](Config_Reference.md#extruder) eller [extruder_stepper-konfigurationsavsnitt](Config_Reference.md#extruder_stepper)) synkroniseras med rörelsen för en extruder som anges av MOTION_QUEUE (enligt definition i ett [extruder-konfigurationsavsnitt](Config_Reference.md#extruder)). Om MOTION_QUEUE är en tom sträng synkroniseras stegmotorn bort från alla extruderrörelser.

### [fan_generic]

Följande kommando är tillgängligt när ett [fan_generic-konfigurationsavsnitt](Config_Reference.md#fan_generic) är aktiverat.

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<speed>`: Detta kommando anger fläktens hastighet. ”speed” måste vara mellan 0,0 och 1,0.

`SET_FAN_SPEED FAN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: Om `TEMPLATE` anges tilldelas en [display_template](Config_Reference.md#display_template) till den angivna fläkten. Om exempelvis konfigurationsavsnittet `[display_template my_fan_template]` har definierats kan `TEMPLATE=my_fan_template` tilldelas här. display_template ska skapa en sträng som innehåller ett flyttal med önskat värde. Mallen utvärderas fortlöpande och fläkten ställs automatiskt in på den resulterande hastigheten. Parametrar för display_template kan anges för användning vid mallutvärderingen (parametrar tolkas som Python-litteraler). Om TEMPLATE är en tom sträng rensar kommandot en tidigare mall som tilldelats stiftet (därefter kan `SET_FAN_SPEED` användas för att hantera värdena direkt).

### [filament_switch_sensor]

Följande kommando är tillgängligt när ett [filament_switch_sensor](Config_Reference.md#filament_switch_sensor)- eller [filament_motion_sensor](Config_Reference.md#filament_motion_sensor)-konfigurationsavsnitt är aktiverat.

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`: Hämtar filamentsensorns aktuella status. De data som visas i terminalen beror på sensortypen som definierats i konfigurationen.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]`: Slår på eller av filamentsensorn. Om ENABLE sätts till 0 inaktiveras filamentsensorn, och om den sätts till 1 aktiveras den.

### [firmware_retraction]

Följande vanliga G-kodskommandon är tillgängliga när ett [firmware_retraction-konfigurationsavsnitt](Config_Reference.md#firmware_retraction) är aktiverat. Kommandona gör det möjligt att använda firmwareindragning som finns i många skivningsprogram för att minska trådbildning vid förflyttningar utan extrudering från en del av utskriften till en annan. Korrekt konfigurerad tryckutjämning minskar längden på den indragning som krävs.

- `G10`: Drar in extrudern med aktuellt konfigurerade parametrar.
- `G11`: Matar ut extrudern igen med aktuellt konfigurerade parametrar.

Följande ytterligare kommandon är också tillgängliga.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>]`: Justera parametrarna för firmwareindragning. RETRACT_LENGTH bestämmer hur mycket filament som ska dras in och matas ut igen. Indragningshastigheten justeras via RETRACT_SPEED och sätts vanligen relativt högt. Hastigheten för utmatning efter indragning justeras via UNRETRACT_SPEED och är inte särskilt kritisk, men ofta lägre än RETRACT_SPEED. I vissa fall är det användbart att lägga till en liten extra längd vid utmatning efter indragning; detta anges med UNRETRACT_EXTRA_LENGTH. SET_RETRACTION anges vanligen som del av skivningsprogrammets konfiguration per filament, eftersom olika filament kräver olika parameterinställningar.

#### GET_RETRACTION

`GET_RETRACTION`: Hämtar aktuella parametrar för firmwareindragning och visar dem i terminalen.

### [force_move]

Modulen force_move läses in automatiskt, men vissa kommandon kräver att `enable_force_move` anges i [skrivarkonfigurationen](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<config_name>`: Flytta den angivna stegmotorn en mm framåt och sedan en mm bakåt, upprepat 10 gånger. Detta är ett diagnostikverktyg som hjälper till att verifiera stegmotorns anslutning.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]`: Detta kommando flyttar med tvång den angivna stegmotorn det angivna avståndet (i mm) med den angivna konstanta hastigheten (i mm/s). Om ACCEL anges och är större än noll används den angivna accelerationen (i mm/s^2); annars utförs ingen acceleration. Inga gränskontroller eller kinematiska uppdateringar görs och andra parallella stegmotorer på en axel flyttas inte. Var försiktig: ett felaktigt kommando kan orsaka skador! Kommandot placerar nästan säkert kinematiken på låg nivå i ett felaktigt tillstånd; kör G28 efteråt för att återställa kinematiken. Kommandot är avsett för diagnostik och felsökning på låg nivå.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] [SET_HOMED=<[X][Y][Z]>] [CLEAR_HOMED=<[X][Y][Z]>]`: Tvingar den underliggande kinematikkoden att betrakta verktygshuvudet som placerat på den angivna kartesiska positionen och att ange eller rensa referenskörningsstatus. Detta är ett kommando för diagnostik och felsökning; använd SET_GCODE_OFFSET och/eller G92 för vanliga axelomvandlingar. En felaktig eller ogiltig position kan leda till interna programvarufel.

Parametrarna `X`, `Y` och `Z` används för att ändra positionsspårningen på låg kinematiknivå. Om någon av parametrarna inte anges ändras inte positionen. Exempelvis innebär `SET_KINEMATIC_POSITION Z=10` att alla axlar sätts som referenskörda, den interna Z-positionen sätts till 10 och X- och Y-positionerna lämnas oförändrade. Ändring av den interna positionsspårningen beror inte på den interna referenskörningsstatusen: positionen kan ändras både för referenskörda och icke referenskörda axlar, och på samma sätt kan en axels referenskörningsstatus anges eller rensas utan att dess interna position ändras.

Parametern `SET_HOMED` är som standard `XYZ`, vilket instruerar kinematiken att betrakta alla axlar som referenskörda. Ett ensamt kommando `SET_KINEMATIC_POSITION` gör att alla axlar betraktas som referenskörda utan att deras aktuella position ändras. Om referenskörda axlars status inte ska ändras tilldelas `SET_HOMED` en tom sträng, exempelvis: `SET_KINEMATIC_POSITION SET_HOMED= X=10`. Det går också att begära att en enskild axel betraktas som referenskörd (t.ex. `SET_HOMED=X`), men observera att icke-kartesisk kinematik (som deltakinematik) kanske inte stöder att enskilda axlar anges som referenskörda.

Parametern `CLEAR_HOMED` instruerar kinematiken att betrakta de angivna axlarna som icke referenskörda. `CLEAR_HOMED=XYZ` innebär exempelvis att alla axlar betraktas som icke referenskörda och därför måste referensköras före förflyttning. Standardvärdet är `SET_HOMED=XYZ` även om `CLEAR_HOMED` används, så kommandot `SET_KINEMATIC_POSITION CLEAR_HOMED=Z` gör X och Y referenskörda och rensar referenskörningsstatusen för Z. Använd `SET_KINEMATIC_POSITION SET_HOMED= CLEAR_HOMED=Z` om endast Z:s referenskörningsstatus ska rensas. Om en axel inte anges i vare sig `SET_HOMED` eller `CLEAR_HOMED` ändras inte dess referenskörningsstatus, och om den anges i båda har `CLEAR_HOMED` företräde. Det går att begära att en enskild axel rensas, men med icke-kartesisk kinematik (som deltakinematik) kan det medföra att även andra axlars referenskörningsstatus rensas. Observera att parametern `CLEAR` för närvarande är ett alias för `CLEAR_HOMED`, men aliaset kommer att tas bort i framtiden.

### [gcode]

Modulen gcode läses in automatiskt.

#### RESTART

`RESTART`: Gör att värdprogrammet läser in sin konfiguration på nytt och utför en intern återställning. Kommandot rensar inte feltillstånd i mikrokontrollern (se FIRMWARE_RESTART) och läser inte heller in ny programvara (se [FAQ](FAQ.md#how-do-i-upgrade-to-the-latest-software)).

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`: Liknar kommandot RESTART, men rensar också alla feltillstånd i mikrokontrollern.

#### STATUS

`STATUS`: Rapportera status för Klippers värdprogram.

#### HELP

`HELP`: Rapportera listan över tillgängliga utökade G-kodskommandon.

### [gcode_arcs]

Följande vanliga G-kodskommandon är tillgängliga om ett [gcode_arcs-konfigurationsavsnitt](Config_Reference.md#gcode_arcs) är aktiverat:

- Bågrörelse medurs (G2), bågrörelse moturs (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`
- Val av bågplan: G17 (XY-plan), G18 (XZ-plan), G19 (YZ-plan)

### [gcode_macro]

Följande kommando är tillgängligt när ett [gcode_macro-konfigurationsavsnitt](Config_Reference.md#gcode_macro) är aktiverat (se även [guiden för kommandomallar](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`: Kommandot gör det möjligt att ändra värdet för en gcode_macro-variabel under körning. Det angivna VALUE tolkas som en Python-literal.

### [gcode_move]

Modulen gcode_move läses in automatiskt.

#### GET_POSITION

`GET_POSITION`: Returnera information om verktygshuvudets aktuella plats. Se utvecklardokumentationen för [GET_POSITION-utdata](Code_Overview.md#coordinate-systems) för mer information.

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Ange en positionsförskjutning som ska tillämpas på framtida G-kodskommandon. Detta används ofta för att virtuellt ändra bäddens Z-förskjutning eller för att ange XY-förskjutningar för munstycket vid byte av extruder. Om till exempel ”SET_GCODE_OFFSET Z=0.2” skickas, läggs 0,2 mm till Z-höjden för framtida G-kodsförflyttningar. Om parametrar av typen X_ADJUST används läggs justeringen till en befintlig förskjutning (t.ex. ger ”SET_GCODE_OFFSET Z=-0.2” följt av ”SET_GCODE_OFFSET Z_ADJUST=0.3” en total Z-förskjutning på 0,1). Om ”MOVE=1” anges utförs en förflyttning av verktygshuvudet för att tillämpa förskjutningen (annars får förskjutningen verkan vid nästa absoluta G-kodsförflyttning som anger den aktuella axeln). Om ”MOVE_SPEED” anges utförs förflyttningen av verktygshuvudet med den angivna hastigheten (i mm/s); annars används senast angivna G-kodshastighet.

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<state_name>]`: Spara aktuellt tillstånd för tolkningen av G-kodkoordinater. Att spara och återställa G-kodstillståndet är användbart i skript och makron. Kommandot sparar aktuellt absolut koordinatläge för G-kod (G90/G91), absolut extruderläge (M82/M83), origo (G92), förskjutning (SET_GCODE_OFFSET), hastighetsåsidosättning (M220), extruderåsidosättning (M221), förflyttningshastighet, aktuell XYZ-position och relativ E-position för extrudern. Om NAME anges kan det sparade tillståndet ges det angivna namnet. Om NAME inte anges används ”default”.

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Återställ ett tillstånd som tidigare sparats med SAVE_GCODE_STATE. Om ”MOVE=1” anges utförs en förflyttning av verktygshuvudet tillbaka till föregående XYZ-position. Om ”MOVE_SPEED” anges utförs förflyttningen av verktygshuvudet med den angivna hastigheten (i mm/s); annars används den återställda G-kodshastigheten.

### [generic_cartesian]

Kommandona i detta avsnitt blir automatiskt tillgängliga när `kinematics: generic_cartesian` anges som skrivarens kinematik.

#### SET_STEPPER_CARRIAGES

`SET_STEPPER_CARRIAGES STEPPER=<stepper_name> CARRIAGES=<carriages> [DISABLE_CHECKS=[0|1]]`: Anger eller uppdaterar stegmotorvagnarna. `<stepper_name>` måste referera till en befintlig stegmotor i `printer.cfg`, och `<carriages>` beskriver vagnarna som stegmotorn flyttar. Se [Generic Cartesian Kinematics](Config_Reference.md#generic-cartesian-kinematics) för en mer detaljerad beskrivning av parametern `carriages` i stegmotorns konfigurationsavsnitt. Observera att kommandot endast kan ändra vagnarnas koefficienter eller tecken; användaren kan inte lägga till eller ta bort vagnar som stegmotorn styr.

`SET_STEPPER_CARRIAGES` är ett avancerat verktyg och bör användas med yttersta försiktighet, eftersom felaktig konfiguration kan skada skrivaren fysiskt.

Observera att `SET_STEPPER_CARRIAGES` utför vissa interna valideringar av den nya skrivarkinematiken efter ändringen. Om ett problem upptäcks kan skrivarkinematiken lämnas i ett ogiltigt tillstånd. Om `SET_STEPPER_CARRIAGES` rapporterar ett fel är det därför osäkert att köra andra G-kodskommandon. Inspektera felmeddelandet och åtgärda problemet eller återställ manuellt den tidigare stegmotorkonfigurationen.

Eftersom `SET_STEPPER_CARRIAGES` bara kan uppdatera konfigurationen för en stegmotor åt gången kan vissa ändringsföljder ge ogiltiga mellanliggande kinematikkonfigurationer, även om slutkonfigurationen är giltig. I sådana fall kan användaren skicka parametern `DISABLE_CHECKS=1` till alla kommandon utom det sista för att inaktivera mellanliggande kontroller. Om exempelvis `stepper a` och `stepper b` från början har vagnarna `carriage_x-carriage_y` respektive `carriage_x+carriage_y` gör följande kommandoordning det möjligt att i praktiken byta vagnstyrning: `SET_STEPPER_CARRIAGES STEPPER=a CARRIAGES=carriage_x+carriage_y DISABLE_CHECKS=1` och `SET_STEPPER_CARRIAGES STEPPER=b CARRIAGES=carriage_x-carriage_y`, medan det slutliga kinematiktillståndet fortfarande valideras.

### [hall_filament_width_sensor]

Följande kommandon är tillgängliga när ett [tsl1401cl-konfigurationsavsnitt för filamentbreddssensor](Config_Reference.md#tsl1401cl_filament_width_sensor) eller ett [hall-filamentbreddssensorkonfigurationsavsnitt](Config_Reference.md#hall_filament_width_sensor) är aktiverat (se även [TSLl401CL-filamentbreddssensor](TSL1401CL_Filament_Width_Sensor.md) och [Hall-filamentbreddssensor](Hall_Filament_Width_Sensor.md)):

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`: Returnerar den aktuella uppmätta filamentbredden, tillståndet för breddsensorn, tillståndet för filamentsensorn och tillståndet för flödeskompenseringen.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`: Rensar alla sensoravläsningar. Användbart efter filamentbyte. Återställer flödeshastigheten till 100 %.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`: Stänger av filamentbreddsensorn och slutar använda den för flödeskompensering. Återställer flödeshastigheten till 100 %.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR [FLOW_COMPENSATION=[0|1]`: Slår på filamentbreddsensorn och aktiverar eller inaktiverar flödeskompensering. Om `FLOW_COMPENSATION` inte anges behålls det aktuella tillståndet för flödeskompensering.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`: Returnera aktuella avläsningar från ADC-kanalen och rått sensorvärde för kalibreringspunkter.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`: Aktivera loggning av diameter.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`: Inaktivera loggning av diameter.

### [heaters]

Modulen heaters läses in automatiskt om en värmare är definierad i konfigurationsfilen.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`: Stäng av alla värmare.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Vänta tills den angivna temperatursensorn är vid eller över angivet MINIMUM och/eller vid eller under angivet MAXIMUM.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<heater_name> [TARGET=<target_temperature>]`: Anger måltemperaturen för en värmare. Om ingen måltemperatur anges är målet 0.

### [idle_timeout]

Modulen idle_timeout läses in automatiskt.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: Gör det möjligt för användaren att ange tidsgränsen för inaktivitet (i sekunder).

### [input_shaper]

Följande kommando aktiveras om ett [input_shaper-konfigurationsavsnitt](Config_Reference.md#input_shaper) har aktiverats (se även [guiden för resonanskompensering](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [SHAPER_FREQ_Y=<shaper_freq_z>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [DAMPING_RATIO_Z=<damping_ratio_z>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>] [SHAPER_TYPE_Z=<shaper_type_z>]`: Ändrar parametrar för input shaper. Observera att parametern SHAPER_TYPE återställer input shaper för alla axlar även om olika shaper-typer har konfigurerats i avsnittet [input_shaper]. SHAPER_TYPE kan inte användas tillsammans med parametrarna SHAPER_TYPE_X, SHAPER_TYPE_Y och SHAPER_TYPE_Z. Se [konfigurationsreferensen](Config_Reference.md#input_shaper) för mer information om varje parameter.

### [led]

Följande kommando är tillgängligt när något av [led-konfigurationsavsnitten](Config_Reference.md#leds) är aktiverat.

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: Anger LED-utmatningen. Varje färg-`<value>` måste vara mellan 0,0 och 1,0. Alternativet WHITE är endast giltigt för RGBW-lysdioder. Om lysdioden stöder flera kretsar i en kedja kan INDEX anges för att ändra färgen för endast den angivna kretsen (1 för den första, 2 för den andra osv.). Om INDEX inte anges ställs alla lysdioder i kedjan in på den angivna färgen. Om TRANSMIT=0 anges verkställs färgändringen först vid nästa SET_LED-kommando som inte anger TRANSMIT=0; det kan vara användbart tillsammans med INDEX för att samla flera uppdateringar i en kedja. Som standard synkroniserar SET_LED sina ändringar med andra pågående G-kodskommandon. Det kan ge oönskat beteende om lysdioder ställs in när skrivaren inte skriver ut, eftersom tidsgränsen för inaktivitet då återställs. Om noggrann tidsinställning inte behövs kan SYNC=0 anges för att tillämpa ändringarna utan att återställa tidsgränsen för inaktivitet.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: Tilldelar en [display_template](Config_Reference.md#display_template) till en angiven [LED](Config_Reference.md#leds). Om exempelvis konfigurationsavsnittet `[display_template my_led_template]` har definierats kan `TEMPLATE=my_led_template` tilldelas här. display_template ska skapa en kommaseparerad sträng med fyra flyttal som motsvarar inställningar för röd, grön, blå och vit färg. Mallen utvärderas fortlöpande och lysdioden ställs automatiskt in på de resulterande färgerna. Parametrar för display_template kan anges för användning vid mallutvärderingen (parametrar tolkas som Python-litteraler). Om INDEX inte anges tilldelas mallen till alla kretsar i LED-kedjan, annars uppdateras endast kretsen med angivet index. Om TEMPLATE är en tom sträng rensar kommandot en tidigare mall som tilldelats LED:en (därefter kan `SET_LED` användas för att hantera färginställningarna direkt).

### [load_cell]

Följande kommandon är aktiverade om ett [load_cell-konfigurationsavsnitt](Config_Reference.md#load_cell) har aktiverats.

### LOAD_CELL_DIAGNOSTIC

`LOAD_CELL_DIAGNOSTIC [LOAD_CELL=<config_name>]`: Kommandot samlar in lastcellsdata under 10 sekunder och rapporterar statistik som kan hjälpa dig att kontrollera att lastcellen fungerar korrekt. Kommandot kan köras med både kalibrerade och okalibrerade lastceller.

### LOAD_CELL_CALIBRATE

`LOAD_CELL_CALIBRATE [LOAD_CELL=<config_name>]`: Startar det vägledda kalibreringsverktyget. Kalibreringen består av tre steg:

1. Först tar du bort all belastning från lastcellen och kör kommandot `TARE`
1. Därefter lägger du en känd belastning på lastcellen och kör kommandot `CALIBRATE GRAMS=nnn`
1. Använd slutligen kommandot `ACCEPT` för att spara resultaten

Du kan när som helst avbryta kalibreringen med `ABORT`.

### LOAD_CELL_TARE

`LOAD_CELL_TARE [LOAD_CELL=<config_name>]`: Fungerar precis som taraknappen på en digital våg. Den aktuella råavläsningen från lastcellen sätts som nollpunktsreferens. Svaret är procentandelen av sensorns mätområde som lästes av och råvärdet i antal. Om lastcellen är kalibrerad rapporteras också kraften i gram.

### LOAD_CELL_READ load_cell="name"

`LOAD_CELL_READ [LOAD_CELL=<config_name>]`: Kommandot läser av lastcellen. Svaret är procentandelen av sensorns mätområde som lästes av och råvärdet i antal. Om lastcellen är kalibrerad rapporteras också kraften i gram.

### [load_cell_probe]

Kommandona nedan är aktiverade om ett [load_cell-konfigurationsavsnitt](Config_Reference.md#load_cell_probe) har aktiverats.

Dessutom accepterar kommandon som utför mätningar, såsom [`PROBE`](#probe), [`PROBE_ACCURACY`](#probe_accuracy) och [`BED_MESH_CALIBRATE`](#bed_mesh_calibrate), ytterligare parametrar om `[load_cell_probe]` är definierad. Parametrarna åsidosätter motsvarande inställningar i konfigurationen [`[load_cell_probe]`](./Config_Reference.md#load_cell_probe):

- `FORCE_SAFETY_LIMIT=<grams>`
- `TRIGGER_FORCE=<grams>`
- `DRIFT_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `DRIFT_FILTER_DELAY=<1|2>`
- `BUZZ_FILTER_CUTOFF_FREQUENCY=<frequency_hz>`
- `BUZZ_FILTER_DELAY=<1|2>`
- `NOTCH_FILTER_FREQUENCIES=<list of frequency_hz>`
- `NOTCH_FILTER_QUALITY=<quality>`
- `TARE_TIME=<seconds>`

### LOAD_CELL_TEST_TAP

`LOAD_CELL_TEST_TAP [TAPS=<taps>] [TIMEOUT=<timeout>]`: Kör en testrutin som rapporterar knackningar på lastcellen. Verktygshuvudet flyttas inte, men lastcellssonden känner av knackningar som vid mätning. Det kan användas som en rimlighetskontroll av att sonden fungerar. Verktyget ersätter QUERY_ENDSTOPS och QUERY_PROBE för lastcellssonder.

- `TAPS`: antalet knackningar som verktyget förväntar sig
- `TIMEOOUT`: tiden i sekunder som verktyget väntar på varje knackning innan det avbryter.

### [manual_probe]

Modulen manual_probe läses in automatiskt.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`: Kör ett hjälpskript som är användbart för att mäta munstyckets höjd på en viss plats. Om SPEED anges bestämmer det hastigheten för TESTZ-kommandon (standardvärdet är 5 mm/s). Under en manuell sondering finns följande ytterligare kommandon:

- `ACCEPT`: Detta kommando accepterar den aktuella Z-positionen och avslutar det manuella sonderingsverktyget.
- `ABORT`: Detta kommando avslutar det manuella sonderingsverktyget.
- `TESTZ Z=<value>`: Detta kommando flyttar munstycket uppåt eller nedåt med värdet som anges i ”value”. Till exempel flyttar `TESTZ Z=-.1` munstycket 0,1 mm nedåt, medan `TESTZ Z=.1` flyttar munstycket 0,1 mm uppåt. Värdet kan också vara `+`, `-`, `++` eller `--` för att flytta munstycket uppåt eller nedåt ett belopp i förhållande till tidigare försök.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: Kör ett hjälpskript som är användbart för att kalibrera en inställning för Z position_endstop. Se kommandot MANUAL_PROBE för information om parametrarna och ytterligare kommandon som är tillgängliga medan verktyget är aktivt.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`: Ta aktuell Z-förskjutning för G-kod (dvs. mikrostegning) och subtrahera den från stepper_z endstop_position. Detta gör ett ofta använt värde för mikrostegning permanent. Kräver `SAVE_CONFIG` för att börja gälla.

### [manual_stepper]

Följande kommando är tillgängligt när ett [manual_stepper-konfigurationsavsnitt](Config_Reference.md#manual_stepper) är aktiverat.

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos>] [SYNC=0]]`: Ändrar stegmotorns tillstånd. Använd parametern ENABLE för att aktivera eller inaktivera stegmotorn. Använd SET_POSITION för att tvinga stegmotorn att anta att den befinner sig på den angivna positionen. Använd MOVE för att begära en förflyttning till den angivna positionen. Om SPEED och/eller ACCEL anges används de angivna värdena i stället för standardvärdena i konfigurationsfilen. Om ACCEL är noll utförs ingen acceleration. Normalt schemaläggs framtida G-kodskommandon efter att stegmotorförflyttningen är klar, men om en manuell stegmotorförflyttning använder SYNC=0 kan framtida G-kodsrörelsekommandon köras parallellt med stegmotorförflyttningen.

`MANUAL_STEPPER STEPPER=config_name [SPEED=<speed>] [ACCEL=<accel>] MOVE=<pos> STOP_ON_ENDSTOP=<check_type>`: Om STOP_ON_ENDSTOP anges avslutas förflyttningen tidigt om en ändstoppshändelse inträffar. Parametern `STOP_ON_ENDSTOP` kan sättas till något av följande värden:

* `probe`: Förflyttningen stoppas när ändstoppet rapporterar utlöst.
* `home`: Förflyttningen stoppas när ändstoppet rapporterar utlöst och manual_stepper:s slutposition sätts så att utlösningspositionen motsvarar positionen som anges i parametern `MOVE`.
* `inverted_probe`, `inverted_home`: Som ovan, men förflyttningen stoppas när ändstoppet rapporterar att det inte är utlöst.
* `try_probe`, `try_inverted_probe`, `try_home`, `try_inverted_home`: Som ovan, men inget fel rapporteras om förflyttningen slutförs utan att en ändstoppshändelse avbryter den i förtid.

`MANUAL_STEPPER STEPPER=config_name GCODE_AXIS=[A-Z] [LIMIT_VELOCITY=<velocity>] [LIMIT_ACCEL=<accel>] [INSTANTANEOUS_CORNER_VELOCITY=<velocity>]`: Om parametern `GCODE_AXIS` anges konfigureras stegmotorn som en extra axel för `G1`-förflyttningar. Om exempelvis `MANUAL_STEPPER ... GCODE_AXIS=R` körs kan kommandon som `G1 X10 Y20 R30` användas för att flytta stegmotorn. Förflyttningarna sker synkront med verktygshuvudets XYZ-förflyttningar. När motorn associeras med en `GCODE_AXIS` går det inte längre att begära förflyttning med ovanstående `MANUAL_STEPPER`-kommando. Stegmotorn kan avregistreras med `MANUAL_STEPPER ... GCODE_AXIS=` för att återgå till manuell styrning. Parametrarna `LIMIT_VELOCITY` och `LIMIT_ACCEL` kan begränsa hastigheten för `G1`-förflyttningar som annars skulle överskrida angivna hastighets- eller accelerationsgränser. `INSTANTANEOUS_CORNER_VELOCITY` anger motorns högsta momentana hastighetsändring (mm/s) i korsningen mellan två förflyttningar (standard är 1 mm/s).

### [mcp4018]

Följande kommando är tillgängligt när ett [mcp4018-konfigurationsavsnitt](Config_Reference.md#mcp4018) är aktiverat.

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: Detta kommando ändrar digipotens aktuella värde. Värdet bör vanligen vara mellan 0,0 och 1,0, om inte en ”scale” har definierats i konfigurationen. När ”scale” har definierats bör värdet vara mellan 0,0 och ”scale”.

### [output_pin]

Följande kommando är tillgängligt när ett [output_pin-konfigurationsavsnitt](Config_Reference.md#output_pin) eller [pwm_tool-konfigurationsavsnitt](Config_Reference.md#pwm_tool) är aktiverat.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value>`: Anger stiftet till det angivna utmatningsvärdet `VALUE`. VALUE ska vara 0 eller 1 för ”digitala” utmatningsstift. För PWM-stift ska ett värde mellan 0,0 och 1,0 anges, eller mellan 0,0 och `scale` om en skala har konfigurerats i konfigurationsavsnittet output_pin.

`SET_PIN PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: Om `TEMPLATE` anges tilldelas en [display_template](Config_Reference.md#display_template) till det angivna stiftet. Om exempelvis konfigurationsavsnittet `[display_template my_pin_template]` har definierats kan `TEMPLATE=my_pin_template` tilldelas här. display_template ska skapa en sträng som innehåller ett flyttal med önskat värde. Mallen utvärderas fortlöpande och stiftet ställs automatiskt in på det resulterande värdet. Parametrar för display_template kan anges för användning vid mallutvärderingen (parametrar tolkas som Python-litteraler). Om TEMPLATE är en tom sträng rensar kommandot en tidigare mall som tilldelats stiftet (därefter kan `SET_PIN` användas för att hantera värdena direkt).

### [palette2]

Följande kommandon är tillgängliga när ett [palette2-konfigurationsavsnitt](Config_Reference.md#palette2) är aktiverat.

Palette-utskrifter fungerar genom att bädda in särskilda OCodes (Omega Codes) i G-kodsfilen:

- `O1`…`O32`: Dessa koder läses från G-kodsströmmen, behandlas av denna modul och skickas till Palette 2-enheten.

Följande ytterligare kommandon är också tillgängliga.

#### PALETTE_CONNECT

`PALETTE_CONNECT`: Detta kommando initierar anslutningen till Palette 2.

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`: Detta kommando kopplar från Palette 2.

#### PALETTE_CLEAR

`PALETTE_CLEAR`: Detta kommando instruerar Palette 2 att rensa alla in- och utmatningsbanor från filament.

#### PALETTE_CUT

`PALETTE_CUT`: Detta kommando instruerar Palette 2 att skära av filamentet som för närvarande är laddat i skarvkärnan.

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`: Detta kommando startar Smart Load-sekvensen på Palette 2. Filament laddas automatiskt genom att extruderas det avstånd som kalibrerats på enheten för skrivaren, och Palette 2 meddelas när laddningen är klar. Kommandot motsvarar att trycka på **Smart Load** direkt på Palette 2-skärmen efter att filamentet har laddats.

### [pause_resume]

Följande kommandon är tillgängliga när [pause_resume-konfigurationsavsnittet](Config_Reference.md#pause_resume) är aktiverat:

#### PAUSE

`PAUSE`: Pausar den aktuella utskriften. Den aktuella positionen sparas för återställning vid återupptagning.

#### RESUME

`RESUME [VELOCITY=<value>]`: Återupptar utskriften efter en paus och återställer först den tidigare sparade positionen. Parametern VELOCITY bestämmer hastigheten som verktyget ska återgå till den ursprungliga sparade positionen med.

#### CLEAR_PAUSE

`CLEAR_PAUSE`: Rensar aktuellt pausat tillstånd utan att återuppta utskriften. Detta är användbart om du bestämmer dig för att avbryta en utskrift efter PAUSE. Det rekommenderas att lägga till detta i start-G-koden så att paustillståndet är nytt för varje utskrift.

#### CANCEL_PRINT

`CANCEL_PRINT`: Avbryter den aktuella utskriften.

### [pid_calibrate]

Modulen pid_calibrate läses in automatiskt om en värmare är definierad i konfigurationsfilen.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`: Utför ett PID-kalibreringstest. Den angivna värmaren aktiveras tills den angivna måltemperaturen uppnås och stängs sedan av och på under flera cykler. Om parametern WRITE_FILE är aktiverad skapas filen /tmp/heattest.txt med en logg över alla temperaturprover från testet.

### [print_stats]

Modulen print_stats läses in automatiskt.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>] [CURRENT_LAYER= <current_layer>]`: Skicka information från skivningsprogrammet, såsom aktuellt och totalt lager, till Klipper. Lägg till `SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>]` i skivningsprogrammets start-G-kod och `SET_PRINT_STATS_INFO [CURRENT_LAYER= <current_layer>]` i G-kodsavsnittet för lagerbyte för att skicka lagerinformation till Klipper.

### [probe]

Följande kommandon är tillgängliga när ett [probe-konfigurationsavsnitt](Config_Reference.md#probe) eller ett [bltouch-konfigurationsavsnitt](Config_Reference.md#bltouch) är aktiverat (se även [guiden för sondkalibrering](Probe_Calibrate.md)).

#### PROBE

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`: Flytta munstycket nedåt tills sonden utlöses. Om någon av de valfria parametrarna anges åsidosätter de motsvarande inställning i [sondkonfigurationsavsnittet](Config_Reference.md#probe).

#### QUERY_PROBE

`QUERY_PROBE`: Rapportera sondens aktuella status (”utlöst” eller ”öppen”).

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`: Beräkna högsta, lägsta, medelvärde, median och standardavvikelse för flera sondprover. Som standard tas 10 SAMPLES. I övrigt använder de valfria parametrarna motsvarande inställning i sondkonfigurationsavsnittet som standard.

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>]`: Kör ett hjälpskript som är användbart för att kalibrera sondens z_offset. Se kommandot PROBE för information om valfria sondparametrar. Se MANUAL_PROBE för information om parametern SPEED och ytterligare kommandon som är tillgängliga medan verktyget är aktivt. Observera att PROBE_CALIBRATE använder hastighetsvariabeln för att flytta i både XY- och Z-riktning.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`: Ta aktuell Z-förskjutning för G-kod (dvs. mikrostegning) och subtrahera den från sondens z_offset. Detta gör ett ofta använt värde för mikrostegning permanent. Kräver `SAVE_CONFIG` för att börja gälla.

### [probe_eddy_current]

Kommandona nedan är tillgängliga när ett [probe_eddy_current-konfigurationsavsnitt](Config_Reference.md#probe_eddy_current) är aktiverat.

Dessutom accepterar kommandon som utför mätningar, såsom [`PROBE`](#probe), [`PROBE_ACCURACY`](#probe_accuracy) och [`BED_MESH_CALIBRATE`](#bed_mesh_calibrate), ytterligare parametrar om avsnittet `[probe_eddy_current]` är definierat:

- `METHOD=<scan|rapid_scan|tap>`: Ändrar mätmekanismen:
   - `METHOD=scan`: Verktygshuvudet sänks inte. I stället pausar det kort ovanför varje målplats och returnerar den uppmätta höjden där.
   - `METHOD=rapid_scan`: Verktygshuvudet sänks inte och pausar inte vid varje målplats. Det returnerade värdet är den uppmätta höjden ungefär när verktygshuvudet befann sig nära varje målposition.
   - `METHOD=tap`: Verktygshuvudet sänks tills munstycket får kontakt med bädden. Metoden är endast tillgänglig om `tap_threshold` anges i konfigurationsavsnittet `[probe_eddy_current]`.
   - standard: Om ingen `METHOD`-parameter anges sänks verktygshuvudet som standard tills sensorn upptäcker att avståndet till bädden är lika med eller mindre än parametern `z_offset` i konfigurationsavsnittet `[probe_eddy_current]`.
- `SAMPLE_TIME=<time>`: Vid mätning med `METHOD=scan` anger detta tiden (i sekunder) att pausa vid varje målpunkt. Med `METHOD=rapid_scan` anger det mättidsfönstret vid varje mål. Om det inte anges är standardvärdet 0,100 (100 ms).
- `TAP_THRESHOLD=<value>`: Åsidosätter `tap_threshold` i konfigurationsavsnittet `[probe_eddy_current]` vid mätning med `METHOD=tap`.

Kommandot `Z_OFFSET_APPLY_PROBE` utökas också för att stödja parametern `METHOD=tap`. När ingen METHOD-parameter anges ändrar kommandot `Z_OFFSET_APPLY_PROBE` sondkalibreringen så att den aktuella Z G-kodsförskjutningen tillämpas på framtida `scan`-, `rapid_scan`- och standardmätningar. Om `METHOD=tap` anges tillämpas ändringen i stället på `tap_z_offset`, så att framtida `tap`-mätningar uppdateras med den aktuella Z G-kodsförskjutningen.

#### PROBE_EDDY_CURRENT_CALIBRATE

`PROBE_EDDY_CURRENT_CALIBRATE CHIP=<config_name>`: Startar ett verktyg som kalibrerar sensorns resonansfrekvenser mot motsvarande Z-höjder. Verktyget tar några minuter att slutföra. Använd SAVE_CONFIG efteråt för att lagra resultatet i filen printer.cfg.

#### PROBE_EDDY_CURRENT_TAP_CALIBRATE

`PROBE_EDDY_CURRENT_TAP_CALIBRATE [TAP=guess|refine|verify]`: Startar ett verktyg som kan kalibrera sondens parameter ”tap_threshold”. Se [dokumentationen om virvelströmssonden](Eddy_Probe.md#tap-calibration) för mer information.

#### LDC_CALIBRATE_DRIVE_CURRENT

`LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>`: Verktyget kalibrerar registret DRIVE_CURRENT0 för ldc1612. Innan verktyget används ska sensorn flyttas så att den är nära bäddens mitt och ungefär 20 mm ovanför bäddytan. Kör kommandot för att fastställa ett lämpligt DRIVE_CURRENT för sensorn. Använd sedan SAVE_CONFIG för att lagra den nya inställningen i konfigurationsfilen printer.cfg.

### [pwm_cycle_time]

Följande kommando är tillgängligt när ett [pwm_cycle_time-konfigurationsavsnitt](Config_Reference.md#pwm_cycle_time) är aktiverat.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: Kommandot fungerar på samma sätt som SET_PIN-kommandon för [output_pin](#output_pin). Här går det att ange en explicit cykeltid med parametern CYCLE_TIME (i sekunder). Observera att parametern CYCLE_TIME inte sparas mellan SET_PIN-kommandon (ett SET_PIN-kommando utan explicit CYCLE_TIME använder `cycle_time` som anges i konfigurationsavsnittet pwm_cycle_time).

### [quad_gantry_level]

Följande kommandon är tillgängliga när ett [quad_gantry_level-konfigurationsavsnitt](Config_Reference.md#quad_gantry_level) är aktiverat.

#### QUAD_GANTRY_LEVEL

`QUAD_GANTRY_LEVEL [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Kommandot mäter punkterna som anges i konfigurationen och utför sedan oberoende justeringar för varje Z-stegmotor för att kompensera för lutning. Se kommandot PROBE för information om de valfria mätparametrarna. De valfria värdena `RETRIES`, `RETRY_TOLERANCE` och `HORIZONTAL_MOVE_Z` åsidosätter motsvarande alternativ i konfigurationsfilen.

### [query_adc]

Modulen query_adc läses in automatiskt.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]`: Rapportera det senaste analoga värdet som togs emot för ett konfigurerat analogt stift. Om NAME inte anges rapporteras en lista över tillgängliga ADC-namn. Om PULLUP anges (som ett värde i ohm) rapporteras det råa analoga värdet tillsammans med motsvarande resistans givet denna pullup.

### [query_endstops]

Modulen query_endstops läses in automatiskt. Följande vanliga G-kodskommandon är tillgängliga, men de rekommenderas inte:

- Hämta ändlägesstatus: `M119` (använd QUERY_ENDSTOPS i stället.)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`: Avsök axlarnas ändlägen och rapportera om de är ”utlösta” eller ”öppna”. Kommandot används vanligen för att kontrollera att ett ändläge fungerar korrekt.

### [resonance_tester]

Följande kommandon är tillgängliga när ett [resonance_tester-konfigurationsavsnitt](Config_Reference.md#resonance_tester) är aktiverat (se även [guiden för resonansmätning](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: Mäter och matar ut brus för samtliga axlar på alla aktiverade accelerometerkretsar.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> [OUTPUT=<resonances,raw_data>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [POINT=x,y,z] [INPUT_SHAPING=<0:1>]`: Kör resonanstestet vid alla konfigurerade mätpunkter för den begärda ”axis” och mäter accelerationen med accelerometerkretsarna som konfigurerats för respektive axel. ”axis” kan vara X, Y eller Z eller ange en valfri riktning som `AXIS=dx,dy[,dz]`, där dx, dy och dz är flyttal som definierar en riktningsvektor (t.ex. `AXIS=X`, `AXIS=Y` eller `AXIS=1,-1` för diagonal riktning i XY-planet eller `AXIS=0,1,1` för en riktning i YZ-planet). Observera att `AXIS=dx,dy` och `AXIS=-dx,-dy` är likvärdiga. `chip_name` kan vara en eller flera konfigurerade accelerometerkretsar, avgränsade med kommatecken, exempelvis `CHIPS="adxl345, adxl345 rpi"`. Om POINT anges åsidosätts mätpunkterna som konfigurerats i `[resonance_tester]`. Om `INPUT_SHAPING=0` anges eller inte anges (standard) inaktiveras input shaping för resonanstestet, eftersom ett resonanstest inte får köras med input shaper aktiverad. Parametern `OUTPUT` är en kommaseparerad lista över utmatningar som skrivs. Om `raw_data` begärs skrivs rå accelerometerdata till en eller flera filer `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` (delen `<point>_` skapas bara om fler än en mätpunkt är konfigurerad eller POINT anges). Om `resonances` anges beräknas frekvenssvaret över alla mätpunkter och skrivs till filen `/tmp/resonances_<axis>_<name>.csv`. Om OUTPUT inte anges används `resonances` som standard, och NAME får den aktuella tiden i formatet "YYYYMMDD_HHMMSS".

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>][HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [MAX_SMOOTHING=<max_smoothing>] [INPUT_SHAPING=<0:1>]`: Kör, på samma sätt som `TEST_RESONANCES`, det konfigurerade resonanstestet och försöker hitta optimala parametrar för input shaper på den begärda axeln (eller både X- och Y-axeln om parametern `AXIS` inte anges). Om `MAX_SMOOTHING` inte anges hämtas värdet från avsnittet `[resonance_tester]`; standardvärdet är odefinierat. Mer information om funktionen finns i avsnittet [Max smoothing](Measuring_Resonances.md#max-smoothing) i guiden för resonansmätning. Resultaten från justeringen skrivs ut till konsolen, och frekvenssvaren samt värdena för de olika input shaper-varianterna skrivs till CSV-filerna `/tmp/calibration_data_<axis>_<name>.csv`. Om NAME inte anges används den aktuella tiden i formatet "YYYYMMDD_HHMMSS". Observera att de föreslagna input shaper-parametrarna kan sparas i konfigurationen med kommandot `SAVE_CONFIG`, och om `[input_shaper]` redan aktiverats börjar parametrarna gälla omedelbart.

### [respond]

Följande vanliga G-kodskommandon är tillgängliga när ett [respond-konfigurationsavsnitt](Config_Reference.md#respond) är aktiverat:

- `M118 <message>`: Ekar meddelandet med det konfigurerade standardprefixet (eller `echo: ` om inget prefix är konfigurerat).

Följande ytterligare kommandon är också tillgängliga.

#### RESPOND

- `RESPOND MSG="<message>"`: Ekar meddelandet med det konfigurerade standardprefixet (eller `echo: ` om inget prefix är konfigurerat).
- `RESPOND TYPE=echo MSG="<message>"`: Ekar meddelandet med prefixet `echo: `.
- `RESPOND TYPE=echo_no_space MSG="<message>"`: Ekar meddelandet med `echo:` utan blanksteg mellan prefix och meddelande, vilket är användbart för kompatibilitet med vissa OctoPrint-insticksmoduler som förväntar sig mycket specifik formatering.
- `RESPOND TYPE=command MSG="<message>"`: Ekar meddelandet med prefixet `// `. OctoPrint kan konfigureras för att svara på dessa meddelanden (t.ex. `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<message>"`: Ekar meddelandet med prefixet `!! `.
- `RESPOND PREFIX=<prefix> MSG="<message>"`: Ekar meddelandet med prefixet `<prefix>`. (Parametern `PREFIX` har företräde framför parametern `TYPE`.)

### [save_variables]

Följande kommando aktiveras om ett [save_variables-konfigurationsavsnitt](Config_Reference.md#save_variables) har aktiverats.

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`: Sparar variabeln på disk så att den kan användas efter omstarter. VARIABLE måste skrivas med små bokstäver. Alla lagrade variabler läses in i dict-objektet `printer.save_variables.variables` vid start och kan användas i G-kodsmakron. VALUE tolkas som en Python-litteral.

### [screws_tilt_adjust]

Följande kommandon är tillgängliga när ett [screws_tilt_adjust-konfigurationsavsnitt](Config_Reference.md#screws_tilt_adjust) är aktiverat (se även [guiden för manuell nivåjustering](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Kommandot startar verktyget för justering av bäddskruvar. Det flyttar munstycket till olika platser (enligt konfigurationsfilen), mäter Z-höjden och beräknar hur många rattvarv som krävs för att justera bäddnivån. Om DIRECTION anges utförs alla rattvarv i samma riktning: medurs (CW) eller moturs (CCW). Se kommandot PROBE för information om de valfria mätparametrarna. VIKTIGT: Du MÅSTE alltid köra G28 innan du använder detta kommando. Om MAX_DEVIATION anges ger kommandot ett G-kodsfel om skillnaden mellan en skruvhöjd och bashöjden är större än det angivna värdet. Det valfria värdet `HORIZONTAL_MOVE_Z` åsidosätter alternativet `horizontal_move_z` i konfigurationsfilen.

### [sdcard_loop]

När ett [sdcard_loop-konfigurationsavsnitt](Config_Reference.md#sdcard_loop) är aktiverat finns följande utökade kommandon tillgängliga.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`: Starta en upprepad sektion i SD-utskriften. Antalet 0 anger att sektionen ska upprepas obegränsat.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: Avsluta en upprepad sektion i SD-utskriften.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: Slutför befintliga slingor utan fler iterationer.

### [servo]

Följande kommandon är tillgängliga när ett [servo-konfigurationsavsnitt](Config_Reference.md#servo) är aktiverat.

#### SET_SERVO

`SET_SERVO SERVO=config_name [ANGLE=<degrees> | WIDTH=<seconds>]`: Ange servopositionen till den angivna vinkeln (i grader) eller pulsbredden (i sekunder). Använd `WIDTH=0` för att inaktivera servoutdata.

### [skew_correction]

Följande kommandon är tillgängliga när ett [skew_correction-konfigurationsavsnitt](Config_Reference.md#skew_correction) är aktiverat (se även guiden [Skew Correction](Skew_Correction.md)).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`: Konfigurerar modulen [skew_correction] med mätningar (i mm) från en kalibreringsutskrift. Mätningar kan anges för valfri kombination av plan; plan som inte anges behåller sina aktuella värden. Om `CLEAR=1` anges inaktiveras all skevhetskorrigering.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: Rapporterar skrivarens aktuella skevhet för varje plan, både i radianer och grader. Skevheten beräknas från parametrar som anges via G-koden `SET_SKEW`.

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>]`: Beräknar och rapporterar skevheten (i radianer och grader) utifrån en uppmätt utskrift. Detta kan vara användbart för att bestämma skrivarens aktuella skevhet efter att korrigering har tillämpats. Det kan också vara användbart före korrigering för att avgöra om skevhetskorrigering behövs. Se [Skew Correction](Skew_Correction.md) för information om kalibreringsobjekt och mätningar för skevhet.

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<name>] [SAVE=<name>] [REMOVE=<name>]`: Profilhantering för skew_correction. LOAD återställer skevhetstillståndet från profilen som matchar angivet namn. SAVE sparar aktuellt skevhetstillstånd i en profil som matchar angivet namn. REMOVE tar bort profilen som matchar angivet namn från beständigt minne. Observera att G-koden SAVE_CONFIG måste köras efter SAVE- eller REMOVE-operationer för att göra ändringarna i beständigt minne permanenta.

### [smart_effector]

Flera kommandon är tillgängliga när ett [smart_effector-konfigurationsavsnitt](Config_Reference.md#smart_effector) är aktiverat. Läs den officiella dokumentationen för Smart Effector på [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer) innan Smart Effector-parametrarna ändras. Se också [guiden för sondkalibrering](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<sensitivity>] [ACCEL=<accel>] [RECOVERY_TIME=<time>]`: Ange parametrarna för Smart Effector. När `SENSITIVITY` anges skrivs motsvarande värde till SmartEffector-EEPROM (kräver att `control_pin` anges). Godtagbara värden för `<sensitivity>` är 0–255 och standardvärdet är 50. Lägre värden kräver mindre kontaktkraft från munstycket för utlösning (men ger högre risk för felaktig utlösning på grund av vibrationer under sondering), medan högre värden minskar felaktiga utlösningar (men kräver större kontaktkraft). Eftersom känsligheten skrivs till EEPROM bevaras den efter avstängning och behöver därför inte konfigureras vid varje uppstart av skrivaren. `ACCEL` och `RECOVERY_TIME` gör det möjligt att åsidosätta motsvarande parametrar under körning; se [konfigurationsavsnittet](Config_Reference.md#smart_effector) för Smart Effector för mer information.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`: Återställer Smart Effector-känsligheten till fabriksinställningarna. Kräver att `control_pin` anges i konfigurationsavsnittet.

### [stepper_enable]

Modulen stepper_enable läses in automatiskt.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<config_name> ENABLE=[0|1]`: Aktivera eller inaktivera endast den angivna stegmotorn. Detta är ett diagnostik- och felsökningsverktyg och måste användas med försiktighet. Att inaktivera en axelmotor återställer inte referenskörningsinformationen. Att manuellt flytta en inaktiverad stegmotor kan göra att maskinen kör motorn utanför säkra gränser. Detta kan skada axelkomponenter, hot ends och utskriftsytan.

### [temperature_fan]

Följande kommando är tillgängligt när ett [temperature_fan-konfigurationsavsnitt](Config_Reference.md#temperature_fan) är aktiverat.

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>] [max_speed=<max_speed>]`: Anger måltemperaturen för en temperature_fan. Om inget mål anges används temperaturen som anges i konfigurationsfilen. Om hastigheter inte anges görs ingen ändring.

### [temperature_probe]

Följande kommandon är tillgängliga när ett [temperature_probe-konfigurationsavsnitt](Config_Reference.md#temperature_probe) är aktiverat.

#### TEMPERATURE_PROBE_CALIBRATE

`TEMPERATURE_PROBE_CALIBRATE [PROBE=<probe name>] [TARGET=<value>] [STEP=<value>] [METHOD=<method>]`: Startar kalibrering av temperaturdrift för virvelströmsbaserade sonder. `TARGET` är måltemperaturen för det sista provet. När temperaturen som registreras under ett prov överskrider `TARGET` slutförs kalibreringen. Parametern `STEP` anger temperaturskillnaden (i C) mellan prover. När ett prov har tagits används denna skillnad för att schemalägga ett anrop till `TEMPERATURE_PROBE_NEXT`. Standardvärdet för `STEP` är 2. `METHOD` stöder endast `tap`; om den anges automatiseras mätningen.

#### TEMPERATURE_PROBE_NEXT

`TEMPERATURE_PROBE_NEXT`: När kalibreringen har startat körs kommandot för att ta nästa prov. Det schemaläggs automatiskt när differensen som anges av `STEP` har nåtts, men kan också köras manuellt för att tvinga fram ett nytt prov. Kommandot är endast tillgängligt under kalibrering.

#### TEMPERATURE_PROBE_COMPLETE:

`TEMPERATURE_PROBE_COMPLETE`: Kan användas för att avsluta kalibreringen och spara aktuellt resultat innan temperaturen `TARGET` har nåtts. Kommandot är endast tillgängligt under kalibrering.

#### ABORT

`ABORT`: Avbryter kalibreringsprocessen och förkastar aktuella resultat. Kommandot är endast tillgängligt under driftkalibrering.

### TEMPERATURE_PROBE_ENABLE

`TEMPERATURE_PROBE_ENABLE ENABLE=[0|1]`: Aktiverar eller inaktiverar kompensation för temperaturdrift. Om ENABLE sätts till 0 inaktiveras driftkompensation, och om det sätts till 1 aktiveras den.

### [tmcXXXX]

Följande kommandon är tillgängliga när något av [tmcXXXX-konfigurationsavsnitten](Config_Reference.md#tmc-stepper-driver-configuration) är aktiverat.

#### DUMP_TMC

`DUMP_TMC STEPPER=<name> [REGISTER=<name>]`: Kommandot läser alla TMC-drivrutinsregister och rapporterar deras värden. Om REGISTER anges dumpas endast det angivna registret.

#### INIT_TMC

`INIT_TMC STEPPER=<name>`: Detta kommando initierar TMC-registren. Krävs för att återaktivera drivrutinen om kretsens ström stängs av och sedan slås på igen.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: Justerar TMC-drivrutinens kör- och hållströmmar. `HOLDCURRENT` gäller inte tmc2660-drivrutiner. När kommandot används med en drivrutin som har fältet `globalscaler` (tmc5160 och tmc2240) och StealthChop2 används, måste stegmotorn hållas stilla i mer än 130 ms så att drivrutinen utför AT#1-kalibreringen.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value> VELOCITY=<value>`: Ändrar värdet för det angivna registerfältet i TMC-drivrutinen. Kommandot är endast avsett för diagnostik och felsökning på låg nivå, eftersom fältändringar under körning kan leda till oönskat och potentiellt farligt skrivarbeteende. Beständiga ändringar ska i stället göras i skrivarens konfigurationsfil. Inga rimlighetskontroller utförs för de angivna värdena. VELOCITY kan också anges i stället för VALUE. Denna hastighet omvandlas till 20-bitarsvärdet för TSTEP. Använd endast argumentet VELOCITY för fält som representerar hastigheter.

### [toolhead]

Modulen toolhead läses in automatiskt.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [MINIMUM_CRUISE_RATIO=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: Kommandot kan ändra hastighetsgränserna som anges i skrivarens konfigurationsfil. Se [skrivarkonfigurationsavsnittet](Config_Reference.md#printer) för en beskrivning av varje parameter.

### [tuning_tower]

Modulen tuning_tower läses in automatiskt.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<command> PARAMETER=<name> START=<value> [SKIP=<value>] [FACTOR=<value> [BAND=<value>]] | [STEP_DELTA=<value> STEP_HEIGHT=<value>]`: Ett verktyg för att justera en parameter vid varje Z-höjd under en utskrift. Verktyget kör angivet `COMMAND` med angivet `PARAMETER` tilldelat ett värde som varierar med `Z` enligt en formel. Använd `FACTOR` om du ska använda en linjal eller skjutmått för att mäta Z-höjden för det optimala värdet, eller `STEP_DELTA` och `STEP_HEIGHT` om modellen för justeringstornet har band med diskreta värden, vilket är vanligt för temperaturtorn. Om `SKIP=<value>` anges börjar justeringsprocessen först när Z-höjden `<value>` nås, och under den höjden sätts värdet till `START`; i detta fall är `z_height` i formlerna nedan egentligen `max(z - skip, 0)`. Det finns tre möjliga kombinationer av alternativ:

- `FACTOR`: Värdet ändras med hastigheten `factor` per millimeter. Formeln som används är: `value = start + factor * z_height`. Du kan ange den optimala Z-höjden direkt i formeln för att fastställa det optimala parametervärdet.
- `FACTOR` och `BAND`: Värdet ändras med en genomsnittlig hastighet på `factor` per millimeter, men i diskreta band där justeringen endast görs för varje `BAND` millimeter Z-höjd. Formeln som används är: `value = start + factor * ((floor(z_height / band) + .5) * band)`.
- `STEP_DELTA` och `STEP_HEIGHT`: Värdet ändras med `STEP_DELTA` för varje `STEP_HEIGHT` millimeter. Formeln som används är: `value = start + step_delta * floor(z_height / step_height)`. Du kan helt enkelt räkna band eller läsa etiketterna på justeringstornet för att fastställa det optimala värdet.

### [virtual_sdcard]

Klipper har stöd för följande vanliga G-kodskommandon om ett [virtual_sdcard-konfigurationsavsnitt](Config_Reference.md#virtual_sdcard) är aktiverat:

- Lista SD-kort: `M20`
- Initiera SD-kort: `M21`
- Välj SD-fil: `M23 <filename>`
- Starta/återuppta SD-utskrift: `M24`
- Pausa SD-utskrift: `M25`
- Ange SD-position: `M26 S<offset>`
- Rapportera status för SD-utskrift: `M27`

Dessutom finns följande utökade kommandon när konfigurationsavsnittet ”virtual_sdcard” är aktiverat.

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<filename>`: Läs in en fil och starta SD-utskrift.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`: Ta bort filen och rensa SD-tillståndet.

### [z_thermal_adjust]

Följande kommandon är tillgängliga när ett [z_thermal_adjust-konfigurationsavsnitt](Config_Reference.md#z_thermal_adjust) är aktiverat.

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<value>] [REF_TEMP=<value>]`: Aktivera eller inaktivera termisk Z-justering med `ENABLE`. Inaktivering tar inte bort en justering som redan har tillämpats, utan fryser det aktuella justeringsvärdet – vilket förhindrar en potentiellt osäker Z-rörelse nedåt. Återaktivering kan orsaka en rörelse av verktyget uppåt när justeringen uppdateras och tillämpas. `TEMP_COEFF` tillåter justering under körning av temperaturkoefficienten (dvs. konfigurationsparametern `TEMP_COEFF`). Värden för `TEMP_COEFF` sparas inte i konfigurationen. `REF_TEMP` åsidosätter manuellt referenstemperaturen som vanligtvis anges vid referenskörning (t.ex. vid icke-standardiserade referenskörningsrutiner) och återställs automatiskt vid referenskörning.

### [z_tilt]

Följande kommandon är tillgängliga när ett [z_tilt-konfigurationsavsnitt](Config_Reference.md#z_tilt) är aktiverat.

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Kommandot mäter punkterna som anges i konfigurationen och utför sedan oberoende justeringar för varje Z-stegmotor för att kompensera för lutning. Se kommandot PROBE för information om de valfria mätparametrarna. De valfria värdena `RETRIES`, `RETRY_TOLERANCE` och `HORIZONTAL_MOVE_Z` åsidosätter motsvarande alternativ i konfigurationsfilen.
