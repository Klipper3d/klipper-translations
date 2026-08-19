# எடி தற்போதைய தூண்டல் ஆய்வு

This document describes the support for [eddy current](https://en.wikipedia.org/wiki/Eddy_current) inductive probes in Klipper.

These probes detect the bed by measuring the [resonant frequency](https://en.wikipedia.org/wiki/Resonance) of a coil within the sensor. The closer that coil is to a metal bed the higher the coil's resonant frequency. The frequency measurements can thus be used to estimate the distance between sensor and bed.

## Probing mechanisms

Unlike traditional bed probes an eddy current sensor supports four different methods of probing: default, "scan", "rapid_scan", and "tap". The different probing methods are activated by passing a `METHOD=xxx` parameter to probe commands (for example, `PROBE METHOD=tap`). Each probing method has advantages and disadvantages as described below.

### Default probing method

The default probing method behaves most like a traditional bed probe. The toolhead descends toward the bed until the sensor detects that it is near the bed and then several sensor measurements are taken at the halted position to estimate the distance between sensor and bed. This probing mechanism is activated by not specifying a `METHOD` parameter on probe type commands (eg, a bare `PROBE` command).

Advantages:

* It is the most general purpose probing method. It provides good precision with good flexibility.
* Can be used in many starting toolhead positions. It is necessary to ensure that the toolhead XY position places the sensor over the metal bed, but otherwise there is flexibility in the exact starting height.

Disadvantages:

* The probe results are subject to thermal drift. Distances reported by the probe correlate to distances measured during initial calibration (via `PROBE_EDDY_CURRENT_CALIBRATE`) and the results may be impacted if probing is run at a different temperature. Changes to the temperature of the bed, sensor coil, sensor electronics, or any metal near the sensor can all impact the results. The impact is small (think microns), but the acceptable precision for a bed probe is also small (again think microns). For best results, it is recommended to run the calibration and subsequent probes at a consistent temperature.

When to use:

This is the default probing method, and it is recommended for most probing actions. In particular, it is the recommended probe type for bed alignment tools such as `QUAD_GANTRY_LEVEL`, `Z_TILT_ADJUST`, `SCREWS_TILT_CALCULATE`, `DELTA_CALIBRATE`, and similar.

### "scan" probing method

The "scan" probing method is similar to the default method, except the probe does not descend towards the bed. Instead, the probe gathers sensor measurements at the current Z position to estimate the distance between sensor and bed. It is useful for `BED_MESH_CALIBRATE` as the entire bed can be scanned with only horizontal movements.

Advantages:

* The Z position does not change during probing and there is less chance for Z stepper backlash (and similar) to impact measurements. This can be particularly useful when only relative Z height measurements are desired (eg, when using `zero_reference_position` with `BED_MESH_CALIBRATE`).
* A full bed scan may take less time than the default method.

Disadvantages:

* The bed must be nearly parallel to the printer XY rails and there must not be any large deviations in bed height. For acceptable results the bed scanning must be run with a low `HORIZONTAL_MOVE_Z` so that the sensor remains close to the bed during the entire bed scan. (The smaller the distance the more accurate the results.) In practice, this requires that the distance between nozzle and bed be no more than about a millimeter, and at these distances any notable bed deviations could result in a nozzle/bed collision during horizontal movement.
* The "scan" method has the same thermal drift disadvantages described for the default method. For best results, it is recommended to run the calibration and subsequent probes at a consistent temperature.

When to use:

The "scan" method is typically used during bed mesh calibration. It is recommended to always verify the bed is parallel to the printer XY rails prior to performing a bed scan. Depending on the printer hardware, one may use an automated tool utilizing the default probing method to verify the bed is parallel - for example: `QUAD_GANTRY_LEVEL RETRY_TOLERANCE=0.250`, `Z_TILT_ADJUST RETRY_TOLERANCE=0.250`, or `SCREWS_TILT_CALCULATION MAX_TOLERANCE=0.250`.

A bed mesh can then be run with something similar to `BED_MESH_CALIBRATE METHOD=scan HORIZONTAL_MOVE_Z=1`.

### "rapid_scan" probing method

The "rapid_scan" probing method is very similar to the "scan" method, except the probe does not pause at each point to be measured. Instead, measurements taken during horizontal movement near each probing point are used to estimate the distance between sensor and bed.

Advantages:

* A "rapid_scan" full bed scan may be slightly faster than the "scan" method.
* Otherwise, it has the same advantages as the "scan" method.

Disadvantages:

* The results of a "rapid_scan" may be less accurate than the "scan" method.
* Same disadvantages as "scan" probes (bed must be parallel and thermal drift).

When to use:

A "rapid_scan" may be useful when performing a large detailed bed mesh scan for diagnostic purposes. In this situation, the reduced scanning time may outweigh the possible loss of accuracy.

For normal printing, a bed mesh using the regular "scan" method is generally preferred for best accuracy and minimal additional probing time.

Once the bed is verified to be parallel to the XY rails then one can run a rapid bed mesh scan with something similar to `BED_MESH_CALIBRATE METHOD=rapid_scan HORIZONTAL_MOVE_Z=1`.

### "tap" probing method

During "tap" probing, the toolhead descends until the nozzle makes contact with the bed, the nozzle is then lifted away from the bed, and sensor measurements during the lifting movement are analyzed to determine the location where the nozzle breaks contact with the bed.

Advantages:

* The probe results are determined by the actual point of contact between nozzle and bed instead of indirect measurements between sensor and bed. This can be particularly useful if one changes nozzles frequently, as the results will take into account the geometry of the current nozzle.
* A "tap" probe does not have the thermal drift issues associated with the other probing methods. The main probe calibration is not utilized during tap probes, and thus one does not need to track temperatures between initial calibration and subsequent probing.
* Axis "twist" inaccuracies are less of an issue during tap probes as there is no XY probe offset to compensate for. However, one must still ensure the toolhead XY position places both the nozzle and sensor above the bed prior to tap probing.

Disadvantages:

* One must ensure both the nozzle and bed are clean prior to tap probing. Any filament on the nozzle or debris on the bed may significantly skew the probe results.
* One must ensure that the nozzle is around 3-20mm away from the bed prior to starting each "tap" probe attempt. If the nozzle starts too close to the bed then contact may not be detected which could result in an uncontrolled nozzle/bed crash. If the nozzle starts very far from the bed then sensor measurements are not accurate and a tap attempt may fail or provide inaccurate results.
* The printer hardware must allow the nozzle to fully make contact with the bed. There must not be any limit switches or carriage stops that make contact prior to the nozzle contacting the bed.
* One must ensure that the nozzle temperature is not too high for the bed. A too high temperature could melt the PEI coatings on some beds, for example.

When to use:

A "tap" probe is often used as one step during a multi-step homing/leveling process to account for the current nozzle geometry and to reduce errors associated with thermal drift. For example, one might deploy a macro that homes, calls `Z_TILT_ADJUST` with default probe method, heats the printer to an intermediate temperature, cleans the nozzle by repeatedly wiping it over a brush, performs a "tap" probe, uses `SET_KINEMATIC_POSITION` with the tap results, runs `BED_MESH_CALIBRATE` while utilizing a `zero_reference_position`, and then brings the printer to normal printing temperature. The actual steps to utilize a "tap" probe depend heavily on the specific printer hardware.

A "tap" probe may be initiated with something like `PROBE METHOD=tap`.

## Configuration

To configure an eddy current probe, start by declaring a [probe_eddy_current config section](Config_Reference.md#probe_eddy_current) in the printer.cfg file. It is recommended to set `descend_z` to 0.5mm. It is typical for the sensor to require an `x_offset` and `y_offset`. If these values are not known, one should estimate the values during initial calibration.

Then restart the printer and proceed to the following calibration steps.

### Calibrating drive current

அளவுத்திருத்தத்தின் முதல் படி சென்சாருக்கு பொருத்தமான டிரைவ்_கரண்ட் தீர்மானிக்க வேண்டும். அச்சுப்பொறியை வைத்து, கருவியின் தலைக்கு செல்லவும், இதனால் சென்சார் படுக்கையின் மையத்திற்கு அருகில் இருக்கும், மேலும் படுக்கைக்கு மேலே 20 மிமீ இருக்கும். பின்னர் ஒரு `LDC_CALIBRATE_DRIVE_CURRENT CHIP = <config_name>` கட்டளை. எடுத்துக்காட்டாக, கட்டமைப்பு பிரிவுக்கு `[probe_eddy_current my_eddy_probe] என்று பெயரிடப்பட்டிருந்தால், ஒருவர்` ldc_calibrate_drive_current chip = my_eddy_probe` ஐ இயக்குவார். இந்த கட்டளை சில நொடிகளில் முடிக்க வேண்டும். அது முடிந்ததும், முடிவுகளை அச்சுப்பொறியில் சேமித்து மறுதொடக்கம் செய்ய `save_config` கட்டளையை வழங்கவும்.

### Calibrating Z heights

The second step in calibration is to correlate the sensor readings to the corresponding Z heights. Home the printer and navigate the toolhead so that the nozzle is near the center of the bed. Then run a `PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe` command. Once the tool starts, follow the steps described at ["the paper test"](Bed_Level.md#the-paper-test) to determine the actual distance between the nozzle and bed at the given location. Once those steps are complete one can `ACCEPT` the position. The tool will then move the toolhead so that the sensor is above the point where the nozzle used to be and run a series of movements to correlate the sensor to Z positions. This will take a couple of minutes. After the tool completes it will output the sensor performance data:

```
probe_eddy_current: noise 0.000642mm, MAD_Hz=11.314 in 2525 queries
Total frequency range: 45000.012 Hz
z: 0.250 # noise 0.000200mm, MAD_Hz=11.000
z: 0.530 # noise 0.000300mm, MAD_Hz=12.000
z: 1.010 # noise 0.000400mm, MAD_Hz=14.000
z: 2.010 # noise 0.000600mm, MAD_Hz=12.000
z: 3.010 # noise 0.000700mm, MAD_Hz=9.000
```

issue a `SAVE_CONFIG` command to save the results to the printer.cfg and restart.

ஆரம்ப அளவுத்திருத்தத்திற்குப் பிறகு, `x_offset` மற்றும்` y_offset` ஆகியோர் துல்லியமானவர்கள் என்பதை சரிபார்க்க இது ஒரு நல்ல யோசனையாகும். [ஆய்வு ஃச் மற்றும் ஒய் ஆஃப்செட்களை](Probe_Calibrate.md#calibrating-probe-x-and-y-offsets) அளவீடு செய்வதற்கான படிகளைப் பின்பற்றவும். `X_offset` அல்லது` y_offset` மாற்றியமைக்கப்பட்டால், மாற்றத்தைச் செய்தபின் `probe_eddy_current_calibrate` கட்டளையை (மேலே விவரிக்கப்பட்டுள்ளபடி) இயக்க மறக்காதீர்கள்.

Note that eddy current sensors are susceptible to "thermal drift". That is, changes in temperature can result in changes in reported Z height. Changes in either the bed surface temperature or sensor hardware temperature can alter the results. Therefore, for best results the calibration done here and the subsequent probing that utilizes that calibration should be done at the same temperature.

### Tap calibration

In order to utilize "tap" probing it is necessary to configure some parameters.

It must be possible to command the toolhead below the nominal plane of the bed. This is typically done by setting `position_min: -1` in the `[stepper_z]` config section of the printer.cfg (or similar setting, such as `minimum_z_position`, depending on the kinematics). This is necessary to ensure the nozzle can be commanded to firmly contact the bed. This is also to ensure the nozzle makes contact with the bed before it would otherwise be commanded to start deceleration.

It is also necessary to configure a `tap_threshold` parameter. This parameter determines when downward toolhead movement during a "tap" probe should be halted. A value too large could result in a nozzle/bed contact not detected, which could result in the nozzle crashing uncontrollably into the bed. A value too small could result in a "tap" probe attempt halting before making contact with the bed, which could result in probing errors or inaccurate probe results.

The `PROBE_EDDY_CURRENT_TAP_CALIBRATE` command can be used to configure an appropriate `tap_threshold` value. This tool may be run after completing the main `PROBE_EDDY_CURRENT_CALIBRATE` calibration. Follow these steps to calibrate `tap_threshold`:

1. Verify that both the nozzle and bed are clean. Enable the printer, home the printer, move the toolhead to a position near the center of the bed, and make sure the nozzle is between 3 - 10 millimeters from the bed.
1. The next step involves commanding the nozzle to make contact with the bed. This process always has some risks, so be prepared to issue an emergency halt (`M112`) if the probing descent does not stop after contacting the bed. When ready issue the following command: `PROBE_EDDY_CURRENT_TAP_CALIBRATE TAP=guess` This command analyzes the data found during the main probe calibration to make an initial coarse guess for the tap_threshold value and it then performs the corresponding "tap" probe. Ideally the above command will cause the probe to descend until it hits the bed, lift away from the bed, and then report a valid probe result. If not, see the paragraphs at the end of this section to troubleshoot. If the attempt was successful then continue to the next step.
1. The next step is to run another tap probe with a "refined" threshold setting. The tool utilizes information gathered during a previous successful tap probe to determine this improved threshold. Make sure that the nozzle is near the center of the bed, that it is between 3 - 10mm above the bed, be ready to issue an emergency halt, and then run the following command: `PROBE_EDDY_CURRENT_TAP_CALIBRATE TAP=refine` Ideally this command will also succeed; if not, see the paragraphs at the end of this section to troubleshoot. If the attempt was successful then continue to the next step.
1. If probing with the refined threshold is successful then the next test is to verify that it is stable over multiple probe attempts. Make sure that the nozzle is near the center of the bed, that it is between 3 - 10mm above the bed, be ready to issue an emergency halt, and then run the following command: `PROBE_EDDY_CURRENT_TAP_CALIBRATE TAP=verify` This command will probe the bed five times in a row. Ideally the above command will also succeed; if not, see the paragraphs at the end of this section to troubleshoot. If the attempt was successful then continue to the next step.
1. If all of the above steps are successful then one can issue a `SAVE_CONFIG` command to save the "tap_threshold" parameter to the printer.cfg file. Calibration should now be complete.

If any of the steps above did not succeed then it may be necessary to troubleshoot and manually determine an appropriate `tap_threshold`. This is done by running commands of the form: `PROBE METHOD=tap TAP_THRESHOLD=<value>` Where `<value>` is a threshold to test.

In general, if a probe attempt halts before making contact with the bed, then this indicates that the provided `TAP_THRESHOLD` parameter is too low. Try increasing it by about 10% and retry. Similarly, if a probe attempt does not halt after making contact with the bed then it indicates that `TAP_THRESHOLD` is too high. Consider decreasing the attempted value in half.

If the automated calibration tool failed during the initial "guess" stage, then one can use the tap_threshold value reported by the tool as a starting point for manual attempts. Once a successful probe attempt is completed then one can return to the main steps described above starting at the "refine" stage.

### Performing initial calibration when homing with probe

It is possible to use an eddy current probe to home a Z axis. To use this process, set the `[stepper_z]` config section `endstop_pin` to `probe:z_virtual_endstop`.

In order to home with an eddy probe it is necessary to first calibrate the probe via the `PROBE_EDDY_CURRENT_CALIBRATE` command. However, that command requires that the printer be homed first.

The following steps may be used to avoid this circular dependency for the very first calibration:

1. Define a `[probe_eddy_current]` config section in the printer.cfg file as described in the [configuration section](#configuration).
1. Make sure a [force move](Config_Reference.md#force_move) section is defined and ensure its `enable_force_move` option is present and set to true.
1. Manually adjust the carriages so that the toolhead is near the center of the bed and roughly 20mm away from the bed. Issue `LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` and `SAVE_CONFIG` commands as described in the [calibrating drive current section](#calibrating-drive-current).
1. Manually move the toolhead so that it is roughly 20mm away from the bed and home the printer's X and Y axes. This is typically done with a `G28 X0 Y0` command. Command the toolhead X and Y position so that the toolhead is roughly over the center of the bed. This is typically done with a command like `G1 X50 Y50` (using appropriate XY values for the printer).
1. Manually adjust the bed so that it is mostly flat relative to the toolhead XY carriages (if necessary). Manually adjust the Z carriage so that the nozzle is roughly 20mm from the bed and issue a `SET_STEPPER_ENABLE STEPPER=stepper_z` command. Issue a `SET_KINEMATIC_POSITION Z=25` command followed by a `PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe` command. Important - after issuing these commands the printer will be able to move in the Z direction, but it does not know the actual Z position. Care must be taken to avoid movement requests that may cause the toolhead to descend into the bed.
1. Complete the eddy probe calibration as described in the [calibrating z heights section](#calibrating-z-heights). Issue a `SAVE_CONFIG` command upon completion.

These steps are only needed to obtain an initial configuration. If one needs to rerun `PROBE_EDDY_CURRENT_CALIBRATE` in the future then the normal mechanism should be possible once this initial configuration is available.

## வெப்ப சறுக்கல் அளவுத்திருத்தம்

அனைத்து தூண்டல் ஆய்வுகளையும் போலவே, எடி தற்போதைய ஆய்வுகள் குறிப்பிடத்தக்க வெப்ப சறுக்கலுக்கு உட்பட்டவை. எடி ஆய்வில் சுருளில் வெப்பநிலை சென்சார் இருந்தால், சுருள் வெப்பநிலையைப் புகாரளிப்பதற்கும் மென்பொருள் சறுக்கல் இழப்பீட்டை இயக்குவதற்கும் `[வெப்பநிலை_பிரோப்]` உள்ளமைக்க முடியும். வெப்பநிலை ஆய்வை எடி மின்னோட்ட ஆய்வுடன் இணைக்க `[வெப்பநிலை_பிரோப்]` பிரிவு `[probe_eddy_current]` பிரிவுடன் ஒரு பெயரைப் பகிர வேண்டும். உதாரணமாக:

```
[probe_eddy_current my_probe]
 # எடி ஆய்வு உள்ளமைவு ...

 [வெப்பநிலை_ப்ரோப் மை_பிரோப்]
 # வெப்பநிலை ஆய்வு உள்ளமைவு ...
```

`temperature_probe` ஐ எவ்வாறு கட்டமைப்பது என்பது பற்றிய கூடுதல் விவரங்களுக்கு [configuration reference](Config_Reference.md#temperature_probe) ஐப் பார்க்கவும். `calibration_position`, `calibration_extruder_temp`, `calibration_heating_z` மற்றும் `calibration_bed_temp` விருப்பங்களை உள்ளமைக்க அறிவுறுத்தப்படுகிறது, ஏனெனில் அவ்வாறு செய்வது கீழே கோடிட்டுக் காட்டப்பட்டுள்ள சில படிகளை தானியக்கமாக்கும். அளவீடு செய்யப்பட வேண்டிய அச்சுப்பொறி இணைக்கப்பட்டிருந்தால், `max_validation_temp` விருப்பத்தை 100 மற்றும் 120 க்கு இடையில் ஒரு மதிப்புக்கு அமைக்க கடுமையாக பரிந்துரைக்கப்படுகிறது.

எடி ஆய்வு உற்பத்தியாளர்கள் ஒரு பங்கு சறுக்கல் அளவுத்திருத்தத்தை வழங்கலாம், இது `[probe_eddy_current]` பிரிவின் `சறுக்கல்_காலிபிரேசன்` விருப்பத்தில் கைமுறையாக சேர்க்கப்படலாம். அவை அவ்வாறு செய்யாவிட்டால், அல்லது பங்கு அளவுத்திருத்தம் உங்கள் கணினியில் சிறப்பாக செயல்படவில்லை என்றால், `வெப்பநிலை_பிரோப்` தொகுதி` வெப்பநிலை_பிரோப்_லிபிரேட்` சிகோட் கட்டளை வழியாக ஒரு கையேடு அளவுத்திருத்த நடைமுறையை வழங்குகிறது.

அளவுத்திருத்தத்தை செய்வதற்கு முன், பயனருக்கு அதிகபட்ச அடையக்கூடிய வெப்பநிலை ஆய்வு சுருள் வெப்பநிலை என்ன என்பதைப் பற்றிய ஒரு சிந்தனை இருக்க வேண்டும். இந்த வெப்பநிலை `வெப்பநிலை_பிரோப்_லிபிரேட்` கட்டளையின்` இலக்கு` அளவுருவை அமைக்க பயன்படுத்தப்பட வேண்டும். சாத்தியமான பரந்த வெப்பநிலை வரம்பில் அளவீடு செய்வதே குறிக்கோள், இதனால் அச்சுப்பொறி குளிர்ச்சியுடன் தொடங்கவும், அதை அடையக்கூடிய அதிகபட்ச வெப்பநிலையில் சுருளுடன் முடிக்கவும் விரும்பத்தக்கது.

`[வெப்பநிலை_பிரோப்]` கட்டமைக்கப்பட்டவுடன், வெப்ப சறுக்கல் அளவுத்திருத்தத்தை செய்ய பின்வரும் படிகள் எடுக்கப்படலாம்:

- ஒரு `[வெப்பநிலை_பிரோப்]` கட்டமைக்கப்பட்டு இணைக்கப்படும்போது `probe_eddy_current_calibrate` ஐப் பயன்படுத்தி ஆய்வு அளவீடு செய்யப்பட வேண்டும். இது வெப்ப சறுக்கல் இழப்பீடு செய்ய தேவையான அளவுத்திருத்தத்தின் போது வெப்பநிலையைப் பிடிக்கிறது.
- முனை குப்பைகள் மற்றும் இழை இல்லாதது என்பதை உறுதிப்படுத்திக் கொள்ளுங்கள்.
- அளவுத்திருத்தத்திற்கு முன் படுக்கை, முனை மற்றும் ஆய்வு சுருள் குளிர்ச்சியாக இருக்க வேண்டும்.
- `அளவுத்திருத்த_போசிசன்`,` அளவுத்திருத்த_எக்ச்ட்ரூட்_டெம்ப்`, மற்றும் `[வெப்பநிலை_பிரோப்]` இல் `எக்ச்ட்ரூடர்_ஈடிங்_இச்` விருப்பங்கள் இருந்தால் பின்வரும் படிகள் தேவைப்படுகின்றன ** ** கட்டமைக்கப்பட்டவை:
   - கருவியை படுக்கையின் மையத்திற்கு நகர்த்தவும். சட் படுக்கைக்கு மேலே 30 மிமீ+ இருக்க வேண்டும்.
   - அதிகபட்ச பாதுகாப்பான படுக்கை வெப்பநிலைக்கு மேலே வெப்பநிலைக்கு எக்ச்ட்ரூடரை சூடாக்கவும். 150-170 சி பெரும்பாலான உள்ளமைவுகளுக்கு போதுமானதாக இருக்க வேண்டும். எக்ச்ட்ரூடரை சூடாக்குவதன் நோக்கம் அளவுத்திருத்தத்தின் போது முனை விரிவாக்கத்தைத் தவிர்ப்பது.
   - எக்ச்ட்ரூடர் வெப்பநிலை குடியேறியதும், சட் அச்சை படுக்கைக்கு மேலே 1 மிமீ வரை நகர்த்தவும்.
- சறுக்கல் அளவுத்திருத்தத்தைத் தொடங்குங்கள். ஆய்வின் பெயர் `my_probe` மற்றும் நாம் அடையக்கூடிய அதிகபட்ச ஆய்வு வெப்பநிலை 80c என்றால், பொருத்தமான GCODE கட்டளை` வெப்பநிலை_பிரோப்_கலிப்ரேட் ஆய்வு = my_probe target = 80` ஆகும். கட்டமைக்கப்பட்டால், கருவி ஃச், ஒய் ஒருங்கிணைப்பு `அளவுத்திருத்த_போசிசன்` மற்றும்` எக்ச்ட்ரூடர்_ஈடிங்_இசட்` ஆல் குறிப்பிடப்பட்ட சட் மதிப்பு ஆகியவற்றிற்கு நகரும். குறிப்பிட்ட வெப்பநிலைக்கு எக்ச்ட்ரூடரை சூடாக்கிய பிறகு, கருவி `காலிபிரேசன்_போசிசன்` ஆல் குறிப்பிடப்பட்ட சட் மதிப்புக்கு நகரும்.
- செயல்முறை ஒரு கையேடு ஆய்வைக் கோரும். காகித சோதனையுடன் கையேடு ஆய்வு செய்து `ஏற்றுக்கொள்`. அளவுத்திருத்த செயல்முறை முதல் மாதிரிகளை ஆய்வுடன் எடுத்து, பின்னர் வெப்பமூட்டும் நிலையில் ஆய்வை நிறுத்தும்.
- `அளவுத்திருத்த_பெட்_டெம்ப்` என்றால் ** ** கட்டமைக்கப்பட்ட கட்டமைக்கப்பட்டிருந்தால், படுக்கை வெப்பத்தை அதிகபட்ச பாதுகாப்பான வெப்பநிலைக்கு இயக்கவும். இல்லையெனில் இந்த படி தானாக செய்யப்படும்.
- இயல்பாகவே அளவுத்திருத்த செயல்முறை `இலக்கு` அடையும் வரை மாதிரிகளுக்கு இடையில் ஒவ்வொரு 2 சி கையேடு ஆய்வைக் கோரும். `STEP` அளவுருவை` வெப்பநிலை_பிரோப்_கலிபிரேட்` அமைப்பதன் மூலம் மாதிரிகளுக்கு இடையிலான வெப்பநிலை டெல்டாவைத் தனிப்பயனாக்கலாம். தனிப்பயன் `படி` மதிப்பை அமைக்கும் போது கவனமாக இருக்க வேண்டும், மிக உயர்ந்த மதிப்பு மிகக் குறைவான மாதிரிகளைக் கோரலாம், இதன் விளைவாக மோசமான அளவுத்திருத்தம் ஏற்படுகிறது.
- சறுக்கல் அளவுத்திருத்தத்தின் போது பின்வரும் கூடுதல் GCODE கட்டளைகள் கிடைக்கின்றன:
   - டெல்டாவை அடைவதற்கு முன்பு புதிய மாதிரியை கட்டாயப்படுத்த `வெப்பநிலை_பிரோப்_நெக்ச்ட்` பயன்படுத்தப்படலாம்.
   - `இலக்கு` அடைவதற்கு முன்னர் அளவுத்திருத்தத்தை முடிக்க` வெப்பநிலை_பிரோப்_ கமோப்லெட்` பயன்படுத்தப்படலாம்.
   - `கருக்கலைப்பு` அளவுத்திருத்தத்தை முடிவுக்குக் கொண்டுவரவும் முடிவுகளை நிராகரிக்கவும் பயன்படுத்தப்படலாம்.
- அளவுத்திருத்தம் முடிந்ததும் சறுக்கல் அளவுத்திருத்தத்தை சேமிக்க `save_config` ஐப் பயன்படுத்தவும்.

ஒருவர் முடிவுக்கு வருவது போல், மேலே குறிப்பிட்டுள்ள அளவுத்திருத்த செயல்முறை மற்ற நடைமுறைகளை விட மிகவும் சவாலானது மற்றும் நேரத்தை எடுத்துக்கொள்வது. இதற்கு பயிற்சி மற்றும் உகந்த அளவுத்திருத்தத்தை அடைய பல முயற்சிகள் தேவைப்படலாம்.

## Errors description

Possible homing errors and actionables:

- Sensor error
   - Check logs for detailed error
- Eddy I2C STATUS/DATA error.
   - Check loose wiring.
   - Try software I2C/decrease I2C rate
- Invalid read data
   - Same as I2C

Possible sensor errors and actionables:

- Frequency over valid hard range
   - Check frequency configuration
   - Hardware fault
- Frequency over valid soft range
   - Check frequency configuration
- Conversion Watchdog timeout
   - Hardware fault

Amplitude Low/High warning messages can mean:

- Sensor close to the bed
- Sensor far from the bed
- Higher temperature than was at the current calibration
- Capacitor missing

On some sensors, it is not possible to completely avoid amplitude warning indicator.

You can try to redo the `LDC_CALIBRATE_DRIVE_CURRENT` calibration at work temperature or increase `reg_drive_current` by 1-2 from the calibrated value.

Generally, it is like an engine check light. It may indicate an issue.
