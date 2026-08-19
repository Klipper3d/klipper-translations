# நிலை குறிப்பு

இந்த ஆவணம் கிளிப்பர் [மேக்ரோக்கள்] (கட்டளை_டெம்ப்ளேட்ச்.எம்டி), [காட்சி புலங்கள்] (config_reference.md#காட்சி), மற்றும் [API சேவையகம்] (API_SERVER.MD) வழியாக கிடைக்கும் அச்சுப்பொறி நிலை தகவல்களின் குறிப்பு ஆகும்.

இந்த ஆவணத்தில் உள்ள புலங்கள் மாற்றத்திற்கு உட்பட்டவை - ஒரு பண்புக்கூறு பயன்படுத்தினால், கிளிப்பர் மென்பொருளை மேம்படுத்தும் போது [கட்டமைப்பு மாற்றங்கள் ஆவணத்தை] (config_changes.md) மதிப்பாய்வு செய்ய வேண்டும்.

## கோணம்

பின்வரும் தகவல்கள் [goll some_name] (config_reference.md#கோணம்) பொருள்களில் கிடைக்கின்றன:

- `வெப்பநிலை`: TLE5012B காந்த மண்டப சென்சாரிலிருந்து கடைசி வெப்பநிலை வாசிப்பு (செல்சியசில்). கோண சென்சார் ஒரு TLE5012B சிப்பாக இருந்தால் மட்டுமே இந்த மதிப்பு கிடைக்கும் மற்றும் அளவீடுகள் செயலில் இருந்தால் (இல்லையெனில் அது `எதுவுமில்லை 'என்று புகாரளிக்கிறது).

## bed_mesh

பின்வரும் தகவல்கள் [bed_mesh] (config_reference.md#bed_mesh) பொருளில் கிடைக்கின்றன:

- `சுயவிவரம்_நாம்`,` mesh_min`, `mesh_max`,` probed_matrix`, `mesh_matrix`: தற்போது செயலில் உள்ள படுக்கை_மெச் பற்றிய செய்தி.
- `சுயவிவரங்கள்`: BED_MESH_PROFILE ஐப் பயன்படுத்தி தற்போது வரையறுக்கப்பட்ட சுயவிவரங்களின் தொகுப்பு.

## BED_SCREWS

The following information is available in the [bed_screws](Config_Reference.md#bed_screws) object:

- `is_active`: படுக்கை திருகுகள் சரிசெய்தல் கருவி தற்போது செயலில் இருந்தால் உண்மை.
- `மாநிலம்`: படுக்கை திருகுகள் சரிசெய்தல் கருவி நிலை. இது பின்வரும் சரங்களில் ஒன்றாகும்: "சரிசெய்யவும்", "நன்றாக".
- `Current_screw`: தற்போதைய திருகு சரிசெய்யப்படும் குறியீடு.
- `ஏற்றுக்கொள்ளப்பட்ட_சக்கிகள்`: ஏற்றுக்கொள்ளப்பட்ட திருகுகளின் எண்ணிக்கை.

## canbus_stats

The following information is available in the `canbus_stats some_mcu_name` object (this object is automatically available if an mcu is configured to use canbus):

- `rx_error`: The number of receive errors detected by the micro-controller canbus hardware.
- `tx_error`: The number of transmit errors detected by the micro-controller canbus hardware.
- `tx_retries`: The number of transmit attempts that were retried due to bus contention or errors.
- `bus_state`: The status of the interface (typically "active" for a bus in normal operation, "warn" for a bus with recent errors, "passive" for a bus that will no longer transmit canbus error frames, or "off" for a bus that will no longer transmit or receive messages).

Note that only the rp2XXX micro-controllers report a non-zero `tx_retries` field and the rp2XXX micro-controllers always report `tx_error` as zero and `bus_state` as "active".

## கட்டமைப்பு

பின்வரும் தகவல்கள் `கட்டமைப்பு` பொருளில் கிடைக்கின்றன (இந்த பொருள் எப்போதும் கிடைக்கும்):

- `அமைப்புகள். <ction>. (ரன் நேரத்தில் மாற்றப்பட்ட எந்த அமைப்புகளும் இங்கே பிரதிபலிக்காது.)
- `கட்டமைப்பு. <ction>. (ரன் நேரத்தில் மாற்றப்பட்ட எந்த அமைப்புகளும் இங்கே பிரதிபலிக்காது.) அனைத்து மதிப்புகளும் சரங்களாக திருப்பித் தரப்படுகின்றன.
- `save_config_pending`:` save_config` கட்டளை வட்டுக்கு தொடரும் புதுப்பிப்புகள் இருந்தால் உண்மை என்பதைத் தருகிறது.
- `save_config_pending_items`: மாற்றப்பட்ட பிரிவுகள் மற்றும் விருப்பங்கள் உள்ளன, மேலும் அவை` save_config` ஆல் தொடரப்படும்.
- `எச்சரிக்கைகள்`: கட்டமைப்பு விருப்பங்களைப் பற்றிய எச்சரிக்கைகளின் பட்டியல். பட்டியலில் உள்ள ஒவ்வொரு நுழைவும் `வகை` மற்றும்` செய்தி` புலம் (இரண்டு சரங்களும்) கொண்ட அகராதியாக இருக்கும். எச்சரிக்கை வகையைப் பொறுத்து கூடுதல் புலங்கள் கிடைக்கக்கூடும்.

## display_status

பின்வரும் தகவல்கள் `டிச்ப்ளே_ச்டேட்டச்` பொருளில் கிடைக்கின்றன (ஒரு [காட்சி] (config_reference.md#காட்சி) கட்டமைப்பு பிரிவு வரையறுக்கப்பட்டால் இந்த பொருள் தானாகவே கிடைக்கும்):

- `முன்னேற்றம்`: கடைசி` M73` சி-குறியீட்டு கட்டளையின் முன்னேற்ற மதிப்பு (அல்லது `மெய்நிகர்_ச்ட்கார்ட்.பிரெச்` சமீபத்திய` எம் 73` பெறவில்லை என்றால்).
- `செய்தி`: கடைசி` M117` சி-குறியீட்டு கட்டளையில் உள்ள செய்தி.

## endstop_phase

பின்வரும் தகவல்கள் [endstop_phase] (config_reference.md#endstop_phase) பொருளில் கிடைக்கின்றன:

- `லாச்ட்_ஓம். <ச்டெப்பர் பெயர்> .பேச்`: கடைசி வீட்டு முயற்சியின் முடிவில் ச்டெப்பர் மோட்டரின் கட்டம்.
- `லாச்ட்_ஓம். <ச்டெப்பர் பெயர்> .பேச்கள்`: ச்டெப்பர் மோட்டரில் கிடைக்கும் மொத்த கட்டங்களின் எண்ணிக்கை.
- `லாச்ட்_ஓம். <ச்டெப்பர் பெயர்> .mcu_position`: கடைசி வீட்டு முயற்சியின் முடிவில் ச்டெப்பர் மோட்டரின் நிலை (மைக்ரோ-கன்ட்ரோலரால் கண்காணிக்கப்பட்டது). மைக்ரோ-கன்ட்ரோலர் கடைசியாக மறுதொடக்கம் செய்யப்பட்டதிலிருந்து தலைகீழ் திசையில் எடுக்கப்பட்ட மொத்த நடவடிக்கைகளின் எண்ணிக்கையை கழித்தல் முன்னோக்கி திசையில் எடுக்கப்பட்ட மொத்த நடவடிக்கைகளின் எண்ணிக்கை இந்த நிலை.

## விலக்கு_ஆப்செக்ட்

பின்வரும் தகவல்கள் [excalude_object] (excolude_object.md) பொருளில் கிடைக்கின்றன:

- `பொருள்கள்`:` விலக்கு_ஆப்செக்ட்_ டெஃபைன்` கட்டளையால் வழங்கப்பட்ட அறியப்பட்ட பொருள்களின் வரிசை. `விலக்கு_ஆப்செக்ட் VERBOSE = 1` கட்டளை வழங்கிய அதே செய்தி இது. அசல் `விலக்கு_ஆப்செக்ட்_ டிஃபைன்` இல் வழங்கப்பட்டால் மட்டுமே` மையம்` மற்றும் `பலகோணம்` புலங்கள் இருக்கும்

   இங்கே ஒரு சாதொபொகு மாதிரி:

```
[[
 {
 "பலகோணம்": [
 [156.25, 146.2511675],
 [156.25, 153.7488325],
 [163.75, 153.7488325],
 [163.75, 146.2511675]
 ],
 "பெயர்": "சிலிண்டர்_2_STL_ID_2_COPY_0",
 "மையம்": [160, 150]
 },
 {
 "பலகோணம்": [
 [146.25, 146.2511675],
 [146.25, 153.7488325],
 [153.75, 153.7488325],
 [153.75, 146.2511675]
 ],
 "பெயர்": "சிலிண்டர்_2_STL_ID_1_COPY_0",
 "மையம்": [150, 150]
 }
 ]]
```

- `விலக்கப்பட்ட_ஆப்செக்ட்ச்`: விலக்கப்பட்ட பொருட்களின் பெயர்களை பட்டியலிடும் சரங்களின் வரிசை.
- `நடப்பு_ஆப்செக்ட்`: தற்போது அச்சிடப்பட்ட பொருளின் பெயர்.

## எக்ச்ட்ரூடர் ச்டெப்பர்

எக்ச்ட்ரூடர்_ச்டெப்பர் பொருள்களுக்கு (அத்துடன் [எக்ச்ட்ரூடர்] (config_reference.md#எக்ச்ட்ரூடர்) பொருள்களுக்கு பின்வரும் தகவல்கள் கிடைக்கின்றன):

- `pression_advance`: தற்போதைய [அழுத்தம் அட்வான்ச்] (pression_advance.md) மதிப்பு.
- `sley_time`: தற்போதைய அழுத்தம் மென்மையான நேரம்.
- `மோசன்_க்யூ`: இந்த எக்ச்ட்ரூடர் ச்டெப்பர் தற்போது ஒத்திசைக்கப்பட்ட எக்ச்ட்ரூடரின் பெயர். எக்ச்ட்ரூடர் ச்டெப்பர் தற்போது ஒரு எக்ச்ட்ரூடருடன் தொடர்புடையதாக இல்லாவிட்டால் இது `எதுவுமில்லை 'என்று தெரிவிக்கப்படுகிறது.

## விசிறி

பின்வரும் தகவல்கள் [fan] (config_reference.md#fan), [heter_fan சில_நேம்] (config_reference.md#heter_fan) மற்றும் [controlter_fan சில_நேம்] (config_reference.md#controlter_fan) பொருள்கள்:

- `வேகம்`: சுவைஞர் விரைவு 0.0 முதல் 1.0 வரை மிதவையாக இருக்கும்.
- `ஆர்.பி.எம்.

## Filament_switch_sensor

பின்வரும் தகவல்கள் [Filament_switch_sensor some_name] (config_reference.md#filemation_switch_sensor) பொருள்கள்:

- `இயக்கப்பட்டது`: ச்விட்ச் சென்சார் தற்போது இயக்கப்பட்டிருந்தால் உண்மை.
- `filemation_detected`: சென்சார் தூண்டப்பட்ட நிலையில் இருந்தால் உண்மை.

## Filament_motion_sensor

பின்வரும் தகவல்கள் [Filament_motion_sensor some_name] (config_reference.md#filament_motion_sensor) பொருள்கள்:

- `இயக்கப்பட்டது`: மோசன் சென்சார் தற்போது இயக்கப்பட்டிருந்தால் உண்மை.
- `filemation_detected`: சென்சார் தூண்டப்பட்ட நிலையில் இருந்தால் உண்மை.

## firmware_retraction

பின்வரும் தகவல்கள் [firmware_retraction] (config_reference.md#firmware_retraction) பொருளில் கிடைக்கின்றன:

- `retact_length`,` retact_speed`, `UnorRectact_extra_length`,` Unertract_speed`: firmware_retraction தொகுதிக்கான தற்போதைய அமைப்புகள். `Set_retraction` கட்டளை அவற்றை மாற்றினால் இந்த அமைப்புகள் கட்டமைப்பு கோப்பிலிருந்து வேறுபடலாம்.

## gcode

The following information is available in the `gcode` object:

- `commands`: Returns a list of all currently available commands. For each command, if a help string is defined it will also be provided.

## gcode_button

பின்வரும் தகவல்கள் [gcode_button some_name] (config_reference.md#gcode_button) பொருள்கள்:

- `மாநிலம்`: தற்போதைய பொத்தான் நிலை" அழுத்தியது "அல்லது" வெளியிடப்பட்டது "என திரும்பியது

## gcode_macro

பின்வரும் தகவல்கள் [gcode_macro some_name] (config_reference.md#gcode_macro) பொருள்கள்:

- `<yasion>`: ஒரு [gcode_macro மாறி] இன் தற்போதைய மதிப்பு (Command_templates.md#மாறிகள்).

## gcode_move

பின்வரும் தகவல்கள் `gcode_move` பொருளில் கிடைக்கின்றன (இந்த பொருள் எப்போதும் கிடைக்கும்):

- `gcode_position`: The current position of the toolhead relative to the current G-Code origin. That is, positions that one might directly send to a `G1` command. This value is encoded as a [coordinate](#accessing-coordinates).
- `position`: The last commanded position of the toolhead using the coordinate system specified in the config file. This value is encoded as a [coordinate](#accessing-coordinates).
- `homing_origin`: The origin of the gcode coordinate system (relative to the coordinate system specified in the config file) to use after a `G28` command. The `SET_GCODE_OFFSET` command can alter this position. This value is encoded as a [coordinate](#accessing-coordinates).
- `வேகம்`: கடைசி வேகம்` ஐயா 1` கட்டளையில் (மிமீ/வி இல்) அமைக்கப்பட்டுள்ளது.
- `SPEED_FACTOR`:` M220` கட்டளையால் அமைக்கப்பட்டுள்ள "வேக காரணி மேலெழுதல்". இது ஒரு மிதக்கும் புள்ளி மதிப்பாகும், அதாவது 1.0 என்பது மேலெழுதும் இல்லை, எடுத்துக்காட்டாக, 2.0 கோரப்பட்ட வேகத்தை இருமுறை செய்யும்.
- `எக்ச்ட்ரூட்_ஃபாக்டர்`:` எம் 221` கட்டளையால் அமைக்கப்பட்டுள்ளபடி "எக்ச்ட்ரூட் காரணி மேலெழுதல்". இது ஒரு மிதக்கும் புள்ளி மதிப்பாகும், அதாவது 1.0 என்பது மேலெழுதும் இல்லை, எடுத்துக்காட்டாக, 2.0 கோரப்பட்ட வெளியேற்றங்களை இருமுறை செய்யும்.
- `முழுமையான_கோர்டேட்ச்`:` G90` முழுமையான ஒருங்கிணைப்பு பயன்முறையில் இருந்தால் அல்லது `G91` உறவினர் பயன்முறையில் இருந்தால் இது உண்மையாக இருந்தால் இது உண்மை.
- `முழுமையான எக்ச்ட்ரூட்`:` M82` முழுமையான எக்ச்ட்ரூட் பயன்முறையில் இருந்தால் அல்லது `M83` உறவினர் பயன்முறையில் இருந்தால் இது உண்மையாக இருந்தால் இது உண்மை.
- `axis_map`: Provides a mechanism for finding the coordinate component for a given G-Code id that is used in `G1` commands. See the [Accessing Coordinates](#accessing-coordinates) section for details.

## ஆல்_பிலமென்ட்_விட்_சென்சர்

பின்வரும் தகவல்கள் [hall_filament_width_sensor] (config_reference.md#hall_filament_width_sensor) பொருள்:

- all items from [filament_switch_sensor](Status_Reference.md#filament_switch_sensor)
- `is_active`: சென்சார் தற்போது செயலில் இருந்தால் உண்மை.
- `flow_compensation_enabled`: Returns True if flow compensation is enabled.
- `Diameter`: Returns the last width reading in mm if the sensor is active or the nominal filament diameter if it is not.
- `ரா`: சென்சாரிலிருந்து கடைசி மூல ஏடிசி வாசிப்பு.

## ஈட்டர்

[எக்ச்ட்ரூடர்] (config_reference.md#எக்ச்ட்ரூடர்), [ஈட்டர்_பெட்] (config_reference.md#heter_bed), மற்றும் [heter_generic] (config_reference.md#heter_generic) போன்ற ஈட்டர் பொருள்களுக்கு பின்வரும் தகவல்கள் கிடைக்கின்றன:

- `வெப்பநிலை`: கொடுக்கப்பட்ட ஈட்டருக்கு கடைசியாக அறிவிக்கப்பட்ட வெப்பநிலை (செல்சியசில் ஒரு மிதவை).
- `இலக்கு`: கொடுக்கப்பட்ட ஈட்டருக்கான தற்போதைய இலக்கு வெப்பநிலை (செல்சியசில் ஒரு மிதவை).
- `பவர்`: ஈட்டருடன் தொடர்புடைய PWM முள் (0.0 மற்றும் 1.0 க்கு இடையிலான மதிப்பு) கடைசி அமைப்பு.
- `can_extrude`: எக்ச்ட்ரூடர் எக்ச்ட்ரூட் செய்ய முடிந்தால் (` min_extrude_temp` ஆல் வரையறுக்கப்படுகிறது), [எக்ச்ட்ரூடர்] க்கு மட்டுமே கிடைக்கும் (config_reference.md#extruder)

## ஈட்டர்கள்

பின்வரும் தகவல்கள் `ஈட்டர்கள்` பொருளில் கிடைக்கின்றன (ஏதேனும் ஈட்டர் வரையறுக்கப்பட்டால் இந்த பொருள் கிடைக்கும்):

- `கிடைக்கும்_ஈட்டர்ச்`: தற்போது கிடைக்கக்கூடிய அனைத்து ஈட்டர்களின் பட்டியலையும் அவற்றின் முழு கட்டமைப்பு பிரிவு பெயர்களால் வழங்குகிறது, எ.கா. `[" எக்ச்ட்ரூடர் "," ஈட்டர்_பெட் "," ஈட்டர்_செனெரிக் மை_கச்டம்_ஈட்டர் "]`.
- `கிடைக்கக்கூடிய_சென்சர்கள்`: தற்போது கிடைக்கக்கூடிய அனைத்து வெப்பநிலை சென்சார்களின் பட்டியலை அவற்றின் முழு கட்டமைப்பு பிரிவு பெயர்களால் வழங்குகிறது, எ.கா. `[" எக்ச்ட்ரூடர் "," ஈட்டர்_பெட் "," ஈட்டர்_செனெரிக் மை_கச்டம்_ஈட்டர் "," வெப்பநிலை_சென்சர் எலெக்ட்ரானிக்ச்_டெம்ப் "]`.
- `கிடைக்கக்கூடிய_மோனிட்டர்கள்`: தற்போது கிடைக்கக்கூடிய அனைத்து வெப்பநிலை மானிட்டர்களின் பட்டியலை அவற்றின் முழு கட்டமைப்பு பிரிவு பெயர்களால் வழங்குகிறது, எ.கா. `[" TMC2240 STEPPER_X "]`. வெப்பநிலை சென்சார் எப்போதும் படிக்க கிடைக்கும்போது, வெப்பநிலை மானிட்டர் கிடைக்காமல் போகலாம், அத்தகைய விசயத்தில் பூச்யத்தைத் தரும்.

## idle_timeout

பின்வரும் தகவல்கள் [idle_timeout] (config_reference.md#idle_timeout) பொருளில் கிடைக்கின்றன (இந்த பொருள் எப்போதும் கிடைக்கும்):

- `மாநிலம்`: idle_timeout தொகுதி மூலம் கண்காணிக்கப்பட்ட அச்சுப்பொறியின் தற்போதைய நிலை. இது பின்வரும் சரங்களில் ஒன்றாகும்: "செயலற்ற", "அச்சிடுதல்", "தயாராக".
- `printing_time`: அச்சுப்பொறி" அச்சிடுதல் "நிலையில் உள்ளது (செயலற்ற_TIMEOUT தொகுதி மூலம் கண்காணிக்கப்பட்டபடி) அச்சுப்பொறி.
- `idle_timeout`: The current 'timeout' (in seconds) to wait for the gcode to be triggered. (as set by [SET_IDLE_TIMEOUT](G-Codes.md#set_idle_timeout))

## எல்.ஈ.டி

ஒவ்வொரு `[எல்.ஈ.டி எல்.ஈ.டி_நேம்]`, `[நியோபிக்சல் லெட்_நேம்]`, `[டாட்ச்டார் லெட்_நேம்]`, `[பி.சி.ஏ 9533 லெட்_நேம்]`, மற்றும் `[பி.சி.ஏ 9632 லெட்_நேம்]` அச்சுப்பொறி.

- `color_data`: A list of color lists containing the RGBW values for a led in the chain. Each value is represented as a float from 0.0 to 1.0. Each color list contains 4 items (red, green, blue, white) even if the underlying LED supports fewer color channels. For example, the blue value (3rd item in color list) of the second neopixel in a chain could be accessed at `printer["neopixel <config_name>"].color_data[1][2]`.

## load_cell

The following information is available for each `[load_cell name]`:

- `is_calibrated`: True/False whether the load cell is calibrated.
- `counts_per_gram`: The number of raw sensor counts that equals 1 gram of force.
- `reference_tare_counts`: The reference number of raw sensor counts for 0 force.
- `tare_counts`: The current number of raw sensor counts for 0 force.
- `force_g`: The force in grams, averaged over the last polling period.
- `min_force_g`: The minimum force in grams, over the last polling period.
- `max_force_g`: The maximum force in grams, over the last polling period.
- `errors`: The number of sensor errors detected since the last start of measurements.
- `overflows`: The number of data buffer overflows detected since the last start of measurements.
- `sample_rate`: The sensor's sample rate in samples per second.

## load_cell_probe

The following information is available for `[load_cell_probe]`:

- all items from [load_cell](Status_Reference.md#load_cell)
- all items from [probe](Status_Reference.md#probe)
- `endstop_tare_counts`: The load cell probe keeps a tare value independent of the load cell. This is re-set at the start of each probe.
- `last_trigger_time`: Timestamp of the last homing trigger.
- `last_z_result`: The Z position result of the last tap.
- `is_last_tap_valid`: True if the last tap result is valid.

## கையேடு_ப்ரோப்

பின்வரும் தகவல்கள் `கையேடு_ப்ரோப்` பொருளில் கிடைக்கின்றன:

- `is_active`: ஒரு கையேடு ஆய்வு உதவி ச்கிரிப்ட் தற்போது செயலில் இருந்தால் உண்மையை அளிக்கிறது.
- `z_position`: முனை தற்போதைய உயரம் (அச்சுப்பொறி தற்போது அதைப் புரிந்துகொள்வது போல).
- `z_position_lower`: கடைசி ஆய்வு முயற்சி தற்போதைய உயரத்தை விடக் குறைவாக உள்ளது.
- `z_position_upper`: தற்போதைய உயரத்தை விட கடைசி ஆய்வு முயற்சி.

## MCU

பின்வரும் தகவல்கள் [MCU] (config_reference.md#mcu) மற்றும் [MCU some_name] (config_reference.md#mcu-my_extra_mcu) பொருள்களில் கிடைக்கின்றன:

- `MCU_VERSION`: மைக்ரோ-கன்ட்ரோலரால் அறிவிக்கப்பட்ட கிளிப்பர் குறியீடு பதிப்பு.
- `mcu_build_versions`: மைக்ரோ-கன்ட்ரோலர் குறியீட்டை உருவாக்க பயன்படுத்தப்படும் உருவாக்க கருவிகள் பற்றிய தகவல்கள் (மைக்ரோ-கன்ட்ரோலரால் அறிவிக்கப்பட்டபடி).
- `MCU_Constants. <nountth_name>`: மைக்ரோ-கன்ட்ரோலரால் அறிவிக்கப்பட்ட நேர மாறிலிகளை தொகுக்கவும். கிடைக்கக்கூடிய மாறிலிகள் மைக்ரோ-கட்டுப்பாட்டு கட்டமைப்புகளுக்கும் ஒவ்வொரு குறியீடு திருத்தத்திற்கும் இடையில் வேறுபடலாம்.
- `கடைசி புள்ளிவிவரங்கள். <புள்ளிவிவர பெயர்>`: மைக்ரோகண்ட்ரோலர் இணைப்பு குறித்த புள்ளிவிவர செய்தி.

## இயக்கம்_ அறிக்கை

பின்வரும் தகவல்கள் `Mation_Report` பொருளில் கிடைக்கின்றன (ஏதேனும் ச்டெப்பர் கட்டமைப்பு பிரிவு வரையறுக்கப்பட்டால் இந்த பொருள் தானாகவே கிடைக்கும்):

- `live_position`: The requested toolhead position interpolated to the current time. This value is encoded as a [coordinate](#accessing-coordinates).
- `லைவ்_வெலோசிட்டி`: தற்போதைய நேரத்தில் கோரப்பட்ட கருவி தலை விரைவு (மிமீ/வி இல்).
- `லைவ்_எக்ச்ட்ரூடர்_வெலோசிட்டி`: தற்போதைய நேரத்தில் கோரப்பட்ட எக்ச்ட்ரூடர் விரைவு (மிமீ/வி இல்).

## output_pin

The following information is available in [output_pin some_name](Config_Reference.md#output_pin) and [pwm_tool some_name](Config_Reference.md#pwm_tool) objects:

- `மதிப்பு`: முள்" மதிப்பு ",` set_pin` கட்டளையால் அமைக்கப்பட்டுள்ளது.

## தட்டு 2

பின்வரும் தகவல்கள் [தட்டு 2] (config_reference.md#தட்டு 2) பொருளில் கிடைக்கின்றன:

- `பிங்`: கடைசியாக அறிவிக்கப்பட்ட தட்டு 2 பிங் விழுக்காடு.
- `மீதமுள்ள_ லோட்_எங்`: தட்டு 2 அச்சிடும்போது, இது எக்ச்ட்ரூடரில் ஏற்றப்படுவதற்கான இழைகளின் அளவு.
- `is_splicing`: தட்டு 2 ஃபிலிமென்ட் பிரிக்கும் போது உண்மை.

## pause_resume

பின்வரும் தகவல்கள் [pause_resume] (config_reference.md#pause_resume) பொருளில் கிடைக்கின்றன:

- `is_paused`: இடைநிறுத்த கட்டளை அதனுடன் தொடர்புடைய விண்ணப்பம் இல்லாமல் செயல்படுத்தப்பட்டால் உண்மை.

## print_stats

பின்வரும் தகவல்கள் `print_stats` பொருளில் கிடைக்கின்றன (ஒரு [மெய்நிகர்_ச்ட்கார்டு] (config_reference.md#virtual_sdcard) கட்டமைப்பு பிரிவு வரையறுக்கப்பட்டால் இந்த பொருள் தானாகவே கிடைக்கும்):

- `FileName`,` Total_duration`, `print_duration`,` filament_used`, `state`,` செய்தி`: மெய்நிகர்_ச்ட்கார்ட் அச்சு செயலில் இருக்கும்போது தற்போதைய அச்சு பற்றிய மதிப்பிடப்பட்ட தகவல்கள்.
- `info.total_layer`: கடைசி` set_print_stats_info மொத்த_லேயர் = <மதிப்பு> `சி-குறியீட்டு கட்டளை.
- `info.current_layer`: கடைசி` set_print_stats_info current_layer = <மதிப்பு> `சி-குறியீட்டு கட்டளை.

## தேட்டி

பின்வரும் தகவல்கள் [ஆய்வு] (config_reference.md#ஆய்வு) பொருளில் கிடைக்கின்றன (ஒரு [bltouch] (config_reference.md#bltouch) கட்டமைப்பு பிரிவு வரையறுக்கப்பட்டால் இந்த பொருள் கிடைக்கும்):

- `பெயர்`: பயன்பாட்டில் உள்ள ஆய்வின் பெயரை வழங்குகிறது.
- `last_query`: கடைசி வினவல்_ புரோப் கட்டளையின் போது ஆய்வு" தூண்டப்பட்டதாக "அறிவிக்கப்பட்டால் உண்மை. குறிப்பு, இது ஒரு மேக்ரோவில் பயன்படுத்தப்பட்டால், வார்ப்புரு விரிவாக்கத்தின் வரிசை காரணமாக, இந்த குறிப்பைக் கொண்ட மேக்ரோவுக்கு முன் வினவல்_பிரக கட்டளை இயக்கப்பட வேண்டும்.
- `last_probe_position`: The results of the last `PROBE` command. This value is encoded as a [coordinate](#accessing-coordinates). The probe hardware estimates that if one were to command the toolhead to XY position `last_probe_position.x`,`last_probe_position.y` and descend then the tip of the toolhead would first contact the bed at a Z height of `last_probe_position.z`. These coordinates are relative to the frame (that is, they use the coordinate system specified in the config file). Note, if this is used in a macro, due to the order of template expansion, the `PROBE` command must be run prior to the macro containing this reference.
- `last_z_result`: This value is deprecated; it will be removed in the near future.

## PWM_CYCLE_TIME

பின்வரும் தகவல்கள் [pwm_cycle_time some_name] (config_reference.md#pwm_cycle_time) பொருள்கள்:

- `மதிப்பு`: முள்" மதிப்பு ",` set_pin` கட்டளையால் அமைக்கப்பட்டுள்ளது.

## குவாட்_கான்ட்ரி_லெவல்

பின்வரும் தகவல்கள் `Quat_gantry_level` பொருளில் கிடைக்கின்றன (குவாட்_கான்ட்ரி_லெவல் வரையறுக்கப்பட்டால் இந்த பொருள் கிடைக்கும்):

- `பயன்பாடு`: கேன்ட்ரி லெவலிங் செயல்முறை இயக்கப்பட்டு வெற்றிகரமாக முடிக்கப்பட்டிருந்தால் உண்மை.

## query_endstops

பின்வரும் தகவல்கள் `Query_endstops` பொருளில் கிடைக்கின்றன (ஏதேனும் எண்ட்ச்டாப் வரையறுக்கப்பட்டால் இந்த பொருள் கிடைக்கும்):

- `லாச்ட்_க்யூரி [" <endstop> "]`: கடைசி வினவல்_எண்ட்ச்டாப் கட்டளையின் போது கொடுக்கப்பட்ட எண்ட்ச்டாப் "தூண்டப்பட்டதாக" புகாரளிக்கப்பட்டால் உண்மை. குறிப்பு, இது ஒரு மேக்ரோவில் பயன்படுத்தப்பட்டால், வார்ப்புரு விரிவாக்கத்தின் வரிசை காரணமாக, இந்த குறிப்பைக் கொண்ட மேக்ரோவுக்கு முன் வினவல்_எண்ட்ச்டாப் கட்டளை இயக்கப்பட வேண்டும்.

## திருகுகள்_TILT_ADJUST

பின்வரும் தகவல்கள் `ச்க்ரூச்_பில்ட்_அட்சச்ட்` பொருளில் கிடைக்கின்றன:

- `பிழை`: மிக சமீபத்திய` ச்க்ரூச்_பில்ட்_கால்குலேட்` கட்டளை `மேக்ச்_டீவ்சன்` அளவுருவை உள்ளடக்கியிருந்தால் உண்மை மற்றும் ஆய்வு செய்யப்பட்ட திருகு புள்ளிகள் ஏதேனும் குறிப்பிட்ட` மேக்ச்_டெவியேசன்` ஐ மீறிவிட்டால் உண்மை.
- `MAX_DEVIATION`: மிக சமீபத்திய` திருகுகள்_பில்ட்_கால்குலேட்` கட்டளையின் கடைசி `அதிகபட்சம்_டீவியேசன்` மதிப்பைத் தரவும்.
- `முடிவுகள் [" <crue> "]`: பின்வரும் விசைகளைக் கொண்ட ஒரு அகராதி:
   - `Z`: திருகு இருப்பிடத்தின் அளவிடப்பட்ட சட் உயரம்.
   - `கையொப்பம்`: தேவையான சரிசெய்தலுக்காக திருகு திரும்புவதற்கான திசையைக் குறிப்பிடும் ஒரு சரம். கடிகார திசையில் "சி.டபிள்யூ" அல்லது எதிரெதிர் திசையில் "சி.சி.டபிள்யூ".
   - `சரிசெய்யவும்`: திருகு சரிசெய்ய திருகுகளின் எண்ணிக்கை" HH: மிமீ "வடிவத்தில் கொடுக்கப்பட்டுள்ளது, அங்கு" HH "என்பது முழு திருகு திருப்பங்களின் எண்ணிக்கை மற்றும்" மிமீ "என்பது" ஒரு கடிகார முகத்தின் நிமிடங்களின் "எண்ணிக்கை ஒரு பகுதி திருகு திருப்பத்தைக் குறிக்கும். (எ.கா. "01:15" என்பது திருகு ஒன்று மற்றும் கால் புரட்சிகளை மாற்றுவதாகும்.)
   - `is_base`: இது அடிப்படை திருகு என்றால் உண்மையை அளிக்கிறது.

## சர்வோ

பின்வரும் தகவல்கள் [servo some_name] (config_reference.md#servo) பொருள்களில் கிடைக்கின்றன:

- `அச்சுப்பொறி [" சர்வோ <config_name> "]. மதிப்பு`: சர்வோவுடன் தொடர்புடைய PWM முள் (0.0 மற்றும் 1.0 க்கு இடையிலான மதிப்பு) கடைசி அமைப்பு.

## skew_correction.py

The following information is available in the `skew_correction` object (this object is available if any skew_correction is defined):

- `current_profile_name`: Returns the name of the currently loaded SKEW_PROFILE.

## stepper_enable

பின்வரும் தகவல்கள் `stepper_enable` பொருளில் கிடைக்கின்றன (ஏதேனும் ச்டெப்பர் வரையறுக்கப்பட்டால் இந்த பொருள் கிடைக்கும்):

- `ச்டெப்பர்கள் [" <ச்டெப்பர்> "]`: கொடுக்கப்பட்ட ச்டெப்பர் இயக்கப்பட்டிருந்தால் உண்மையை அளிக்கிறது.

## system_stats

பின்வரும் தகவல்கள் `system_stats` பொருளில் கிடைக்கின்றன (இந்த பொருள் எப்போதும் கிடைக்கும்):

- `sysload`,` cputime`, `Memavail`: புரவலன் இயக்க முறைமை மற்றும் செயல்முறை சுமை பற்றிய செய்தி.

## வெப்பநிலை சென்சார்கள்

பின்வரும் தகவல்கள் கிடைக்கின்றன

. lm75 config_section_name] (config_reference .md#lm75-வெப்பநிலை-சென்சார்), [வெப்பநிலை_ஓச்ட் config_section_name] (config_reference.md#ஓச்ட்-டெம்பரேச்சர்-சென்சார்) மற்றும் [வெப்பநிலை_கம்ப் செய்யப்பட்ட config_section_name] (config_reference.md#ஒருங்கிணைந்த-செம்பரேச்சர்-சென்சார்) பொருள்கள்:

- `வெப்பநிலை`: சென்சாரிலிருந்து கடைசி வாசிப்பு வெப்பநிலை.
- `ஈரப்பதம்`,` அழுத்தம்`, `வாயு`: சென்சாரிலிருந்து கடைசி வாசிப்பு மதிப்புகள் (BME280, HTU21D, SHT3X மற்றும் LM75 சென்சார்களில் மட்டுமே).

## வெப்பநிலை_பான்

பின்வரும் தகவல்கள் [வெப்பநிலை_பான் சில_பெயர்] (config_reference.md#வெப்பநிலை_பான்) பொருள்களில் கிடைக்கின்றன:

- `வெப்பநிலை`: சென்சாரிலிருந்து கடைசி வாசிப்பு வெப்பநிலை.
- `இலக்கு`: விசிறியின் இலக்கு வெப்பநிலை.

## வெப்பநிலை_சென்சர்

பின்வரும் தகவல்கள் [வெப்பநிலை_சென்சர் சில_பெயர்] (config_reference.md#வெப்பநிலை_சென்சர்) பொருள்களில் கிடைக்கின்றன:

- `வெப்பநிலை`: சென்சாரிலிருந்து கடைசி வாசிப்பு வெப்பநிலை.
- `அளவிடப்பட்ட_மின்_டெம்ப்`,` அளவிடப்பட்ட_மாக்ச்_டெம்ப்`: கிளிப்பர் புரவலன் மென்பொருள் கடைசியாக மறுதொடக்கம் செய்யப்பட்டதிலிருந்து சென்சார் பார்த்த மிகக் குறைந்த மற்றும் மிக உயர்ந்த வெப்பநிலை.

## டி.எம்.சி இயக்கிகள்

பின்வரும் தகவல்கள் [TMC ச்டெப்பர் டிரைவர்] (config_reference.md#tmc- ச்டெப்பர்-டிரைவர்-உள்ளமைவு) பொருள்கள் (எ.கா.

- `MCU_PHASE_OFFSET`: டிரைவரின்" சுழிய "கட்டத்துடன் தொடர்புடைய மைக்ரோ-கன்ட்ரோலர் ச்டெப்பர் நிலை. கட்ட ஆஃப்செட் தெரியாவிட்டால் இந்த புலம் பூச்யமாக இருக்கலாம்.
- `fack_offset_position`: ஓட்டுநரின்" பூச்சியம் "கட்டத்துடன் தொடர்புடைய" கட்டளையிடப்பட்ட நிலை ". கட்ட ஆஃப்செட் தெரியாவிட்டால் இந்த புலம் பூச்யமாக இருக்கலாம்.
- `drv_status`: கடைசி இயக்கி நிலை வினவலின் முடிவுகள். .
- `வெப்பநிலை`: இயக்கி அறிவித்த உள் வெப்பநிலை. இயக்கி இயக்கப்பட்டிருந்தால் அல்லது இயக்கி வெப்பநிலை அறிக்கையை ஆதரிக்காவிட்டால் இந்த புலம் பூச்யமாக இருக்கும்.
- `ரன்_கரண்ட்`: தற்போது அமைக்கப்பட்ட ரன் மின்னோட்டம்.
- `Hold_Current`: தற்போது அமைக்கப்பட்ட ஓல்ட் மின்னோட்டம்.

## கருவி

பின்வரும் தகவல்கள் `கருவிஎட்` பொருளில் கிடைக்கின்றன (இந்த பொருள் எப்போதும் கிடைக்கும்):

- `position`: The last commanded position of the toolhead relative to the coordinate system specified in the config file. This value is encoded as a [coordinate](#accessing-coordinates).
- `எக்ச்ட்ரூடர்`: தற்போது செயலில் உள்ள எக்ச்ட்ரூடரின் பெயர். எடுத்துக்காட்டாக, ஒரு மேக்ரோவில் `அச்சுப்பொறி [அச்சுப்பொறி.
- `ஓமட்_அக்ச்`: தற்போதைய கார்ட்டீசியன் அச்சுகள்" வீட்டு "நிலையில் இருப்பதாகக் கருதப்படுகின்றன. இது ஒன்று அல்லது அதற்கு மேற்பட்ட "எக்ச்", "ஒய்", "சட்" கொண்ட ஒரு சரம்.
- `axis_minimum`, `axis_maximum`: The axis travel limits (mm) after homing. This value is encoded as a [coordinate](#accessing-coordinates).
- டெல்டா அச்சுப்பொறிகளுக்கு `cone_start_z` என்பது அதிகபட்ச ஆரம் (` printor.toolhead.cone_start_z`) அதிகபட்ச சட் உயரம்.
- `max_velocity`,` max_accel`, `MINTER_CRUISE_RATIO`,` Sken_corner_velocity`: நடைமுறையில் இருக்கும் தற்போதைய அச்சிடும் வரம்புகள். ஒரு `set_velocity_limit` (அல்லது` M204`) கட்டளை அவற்றை ரன் நேரத்தில் மாற்றினால் இது கட்டமைப்பு கோப்பு அமைப்புகளிலிருந்து வேறுபடலாம்.
- `ச்டால்கள்`: அச்சுப்பொறியை இடைநிறுத்த வேண்டிய மொத்த நேரங்கள் (கடைசி மறுதொடக்கம் முதல்), ஏனெனில் சி-கோட் உள்ளீட்டிலிருந்து நகர்வுகளை விட வேகமாக நகர்ந்த கருவிஎட்டு நகர்ந்தது.
- `extra_axes`: Provides a mechanism for finding the coordinate component for extra axes available in standard `G1` type move commands. See the [Accessing Coordinates](#accessing-coordinates) section for details.

## dual_carriage

பின்வரும் தகவல்கள் ஒரு கார்ட்டீசியன், ஐப்ரிட்_கோரெக்சி அல்லது ஐப்ரிட்_கோரெக்ச் ரோபோவில் [டூயல்_ காரேச்] (config_reference.md#dual_carriage) இல் கிடைக்கின்றன

- `வண்டி_0`: வண்டியின் பயன்முறை 0. சாத்தியமான மதிப்புகள்:" செயலற்ற "மற்றும்" முதன்மை ".
- `வண்டி_1`: வண்டியின் முறை 1. சாத்தியமான மதிப்புகள்:" செயலற்ற "," முதன்மை "," நகல் "மற்றும்" கண்ணாடி ".

On a `generic_cartesian` kinematic, the following information is available in `dual_carriage`:

- `carriages["<carriage>"]`: The mode of the carriage `<carriage>`. Possible values are "INACTIVE" and "PRIMARY" for the primary carriage and "INACTIVE", "PRIMARY", "COPY", and "MIRROR" for the dual carriage.

## மெய்நிகர்_ச்ட்கார்ட்

பின்வரும் தகவல்கள் [மெய்நிகர்_ச்ட்கார்டு] (config_reference.md#virtual_sdcard) பொருளில் கிடைக்கின்றன:

- `is_active`: கோப்பிலிருந்து ஒரு அச்சு தற்போது செயலில் இருந்தால் உண்மை.
- `முன்னேற்றம்`: தற்போதைய அச்சு முன்னேற்றத்தின் மதிப்பீடு (கோப்பு அளவு மற்றும் கோப்பு நிலையின் அடிப்படையில்).
- `file_path`: தற்போது ஏற்றப்பட்ட கோப்பின் கோப்புக்கு முழு பாதை.
- `file_position`: செயலில் உள்ள அச்சின் தற்போதைய நிலை (பைட்டுகளில்).
- `file_size`: தற்போது ஏற்றப்பட்ட கோப்பின் கோப்பு அளவு (பைட்டுகளில்).

## வெப்ஊக்ச்

பின்வரும் தகவல்கள் `வெப்ஊக்ச்` பொருளில் கிடைக்கின்றன (இந்த பொருள் எப்போதும் கிடைக்கும்):

- `மாநிலம்`: தற்போதைய கிளிப்பர் நிலையைக் குறிக்கும் ஒரு சரத்தை வழங்குகிறது. சாத்தியமான மதிப்புகள்: "தயாராக", "தொடக்க", "பணிநிறுத்தம்", "பிழை".
- `state_message`: தற்போதைய கிளிப்பர் நிலையில் கூடுதல் சூழலைக் கொடுக்கும் மனித படிக்கக்கூடிய சரம்.

## z_thermal_adjust

பின்வரும் தகவல்கள் `z_thermal_adjust` பொருளில் கிடைக்கின்றன ([z_thermal_adjust] (config_reference.md#z_thermal_adjust) வரையறுக்கப்பட்டால் இந்த பொருள் கிடைக்கிறது).

- `இயக்கப்பட்டது`: சரிசெய்தல் இயக்கப்பட்டிருந்தால் உண்மை.
- `வெப்பநிலை`: வரையறுக்கப்பட்ட சென்சாரின் தற்போதைய (மென்மையான) வெப்பநிலை. [DEGC]
- `அளவிடப்பட்ட_மின்_டெம்ப்`: குறைந்தபட்ச அளவிடப்பட்ட வெப்பநிலை. [DEGC]
- `அளவிடப்பட்ட_மாக்ச்_டெம்ப்`: அதிகபட்ச அளவிடப்பட்ட வெப்பநிலை. [DEGC]
- `Current_Z_ADJUST`: கடைசியாக கணக்கிடப்பட்ட சட் சரிசெய்தல் [மிமீ].
- `Z_ADJUST_REF_TEMPERATURE`: Z` Current_Z_ADJUST` [DEGC] கணக்கிட பயன்படுத்தப்படும் தற்போதைய குறிப்பு வெப்பநிலை.

## z_tilt

பின்வரும் தகவல்கள் `z_tilt` பொருளில் கிடைக்கின்றன (z_tilt வரையறுக்கப்பட்டால் இந்த பொருள் கிடைக்கும்):

- `பயன்பாடு`: Z-tilt சமநிலை செயல்முறை இயக்கப்பட்டு வெற்றிகரமாக முடிக்கப்பட்டிருந்தால் உண்மை.

## Accessing Coordinates

Some status fields provide a "coordinate". For macro users these fields may be accessed by component name (eg,`{printer.toolhead.position.x}`), where the component name may be "x", "y", or "z".

For developers using the Klipper API Server these fields are transmitted as a list - for example: `{"toolhead": {"position": [1.0, 2.0, 3.0, 7.3, 19.2]}}` . The first three components of the list correspond with the x, y, and z axes.

A coordinate will typically have at least 3 components (x, y, and z), however there may also be additional components. Care should be taken when accessing any of these additional components as the ordering and number of components may change at run-time.

One may use `{printer.gcode_move.axis_map}` and/or `{printer.toolhead.extra_axes}` to determine the number of components and the ordering of components. For example, to access the "E" component one could use `{printer.toolhead.position[printer.gcode_move.axis_map.E]}`. Or, if one wanted to find the component associated with the "extruder" object, one could use `{printer.toolhead.position[printer.toolhead.extra_axes.extruder]}`.
