# Örvényáramú induktív szonda

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

A kalibrálás első lépése az érzékelő megfelelő DRIVE_CURRENT értékének meghatározása. Állítsd be a nyomtatót, és navigáld a nyomtatófejet úgy, hogy az érzékelő az ágy közepéhez közel, az ágy felett kb. 20 mm-re legyen. Ezután add ki az `LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` parancsot. Ha például a konfigurációs szakasz neve `[probe_eddy_current my_eddy_probe]`, akkor az `LDC_CALIBRATE_DRIVE_CURRENT CHIP=my_eddy_probe` parancsot kell futtatni. Ez a parancs néhány másodperc alatt befejeződik. Miután befejeződött, adj ki egy `SAVE_CONFIG` parancsot az eredmények mentéséhez a printer.cfg fájlba, és indítsd újra.

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

A kezdeti kalibrálás után érdemes ellenőrizni, hogy az `x_offset` és `y_offset` értékek pontosak-e. Kövesd a [szonda X- és Y-eltolásának kalibrálása](Probe_Calibrate.md#calibrating-probe-x-and-y-offsets) lépéseit. Ha az `x_offset` vagy az `y_offset` értéket módosítod, akkor a módosítás után feltétlenül futtasd a `PROBE_EDDY_CURRENT_CALIBRATE` parancsot (a fent leírtak szerint).

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

## Termikus elhajlás kalibrálása

Mint minden induktív szondánál, az örvényáramú szondáknál is jelentős a termikus elhajlás. Ha az örvényáramú szonda a tekercsen hőmérséklet-érzékelővel rendelkezik, akkor lehetőség van egy `[temperature_probe]-t konfigurálni a tekercs hőmérsékletének jelentésére és a szoftveres hajláskompenzáció engedélyezésére. A hőmérsékletmérő szonda és az örvényáramú szonda összekapcsolásához a `[temperature_probe]` szakasszal közös nevet kell adnia a `[probe_eddy_current]` szakasznak. Például:

```
[probe_eddy_current my_probe]
# eddy probe configuration...

[temperature_probe my_probe]
# temperature probe configuration...
```

A [konfigurációs hivatkozás](Config_Reference.md#temperature_probe) további részleteket tartalmaz a `temperature_probe` konfigurálásáról. Javasoljuk a `calibration_position`, `calibration_extruder_temp`, `extruder_heating_z` és `calibration_bed_temp` opciók konfigurálását, mivel ez automatizálja az alább ismertetett lépések egy részét. Ha a kalibrálandó nyomtató zárt, erősen ajánlott a `max_validation_temp` opciót 100 és 120 közötti értékre állítani.

Az örvényszondák gyártói kínálhatnak készleten lévő elhajlás kalibrációt, amelyet manuálisan hozzá lehet adni a `[probe_eddy_current]` szakasz `drift_calibration` opciójához. Ha nem, vagy ha a készletkalibráció nem működik jól a rendszereden, a `temperature_probe` modul a `TEMPERATURE_PROBE_CALIBRATE` G-kód parancs segítségével manuális kalibrálási eljárást kínál.

A kalibrálás elvégzése előtt a felhasználónak tudnia kell, hogy mi a maximálisan elérhető hőmérsékletű szondatekercs hőmérséklete. Ezt a hőmérsékletet kell használni a `TEMPERATURE_PROBE_CALIBRATE` parancs `TARGET` paraméterének beállításához. A cél a lehető legszélesebb hőmérséklet-tartományban történő kalibrálás, ezért ajánlatos, hogy hidegen kezdjük, és a tekercset a maximálisan elérhető hőmérsékleten fejezzük be a kalibrálást.

Miután a `[temperature_probe]`-t konfiguráltuk, a következő lépésekkel végezhető el a termikus elhajlás kalibrálás:

- A szondát a `PROBE_EDDY_CURRENT_CALIBRATE` használatával kell kalibrálni, amikor a `[temperature_probe]`-t konfiguráljuk és összekapcsoljuk. Ez rögzíti a hőmérsékletet a kalibrálás során, ami a termikus elhajlás kompenzáció elvégzéséhez szükséges.
- Győződj meg róla, hogy a fúvóka mentes a törmeléktől és a szálaktól.
- Az ágynak, a fúvókának és a szondatekercsnek hidegnek kell lennie a kalibrálás előtt.
- A következő lépésekre akkor van szükség, ha a `[temperature_probe]`-ban a `calibration_position`, `calibration_extruder_temp` és `extruder_heating_z` opciók **NINCSENEK** beállítva:
   - Vidd a nyomtatófejet az ágy közepére. A Z-nek az ágy felett 30 mm-nél nagyobb magasságban kell lennie.
   - Fűtsd fel az extrudert a maximális biztonságos ágyhőmérséklet feletti hőmérsékletre. A legtöbb konfigurációhoz 150-170C elegendőnek kell lennie. Az extruder felmelegítésének célja a fúvóka tágulásának elkerülése a kalibrálás során.
   - Amikor az extruder hőmérséklete beállt, mozgasd a Z tengelyt körülbelül 1 mm-rel az ágy fölé.
- Elhajlás kalibrálás megkezdése. Ha a szonda neve `my_probe` és a maximálisan elérhető szondahőmérséklet 80C, a megfelelő G-kód parancs a `TEMPERATURE_PROBE_CALIBRATE PROBE=my_probe TARGET=80`. Ha beállítjuk, a nyomtatófejet a `calibration_position` által megadott X-Y koordinátára, akkor az `extruder_heating_z` által megadott Z értékre fog mozogni. Miután az extruder a megadott hőmérsékletre melegedett, a szerszám a `calibration_position ` által megadott Z értékre mozog.
- Az eljárás kézi szondát fog kérni. Végezd el a kézi mérést a papírteszttel és az `ACCEPT` gombbal. A kalibrálási eljárás a szondával elvégzi az első mintasorozatot, majd a szondát a fűtési pozícióban leállítja.
- Ha a `calibration_bed_temp` értéke **NINCSEN** beállítva, kapcsold be az ágy fűtését a maximális biztonságos hőmérsékletre. Ellenkező esetben ez a lépés automatikusan végrehajtásra kerül.
- Alapértelmezés szerint a kalibrációs eljárás a minták között 2C-nként kézi szondát kér, amíg a `TARGET` el nem éri a célt. A minták közötti hőmérséklet-különbség testre szabható a `TEMPERATURE_PROBE_CALIBRATE` paraméter `STEP` beállításával. Az egyéni `STEP` érték beállításakor óvatosan kell eljárni, a túl magas érték túl kevés mintát kérhet, ami rossz kalibrációt eredményezhet.
- Az elhajlás kalibrálás során a következő további G-kód parancsok állnak rendelkezésre:
   - A `TEMPERATURE_PROBE_NEXT` használható egy új minta kényszerítésére a lépés delta elérése előtt.
   - A `TEMPERATURE_PROBE_COMPLETE` használható a kalibrálás befejezéséhez a `TARGET` elérése előtt.
   - Az `ABORT` a kalibrálás befejezéséhez és az eredmények elvetéséhez használható.
- Ha a kalibrálás befejeződött, használd a `SAVE_CONFIG` funkciót az elhajlás kalibrálás tárolásához.

Amint arra következtethetünk, a fent vázolt kalibrációs folyamat nagyobb kihívást jelent és időigényesebb, mint a legtöbb más eljárás. Az optimális kalibrálás eléréséhez gyakorlatra és többszöri próbálkozásra lehet szükség.

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
