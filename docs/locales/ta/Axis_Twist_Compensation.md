# அச்சு திருப்ப இழப்பீடு

This document describes the `[axis_twist_compensation]` module.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

இந்த தொகுதி ஆய்வின் முடிவுகளை சரிசெய்ய பயனரின் கையேடு அளவீடுகளைப் பயன்படுத்துகிறது. உங்கள் அச்சு கணிசமாக முறுக்கப்பட்டால், மென்பொருள் திருத்தங்களைப் பயன்படுத்துவதற்கு முன்பு அதை சரிசெய்ய முதலில் இயந்திர வழிமுறைகளைப் பயன்படுத்த பரிந்துரைக்கப்படுகிறது என்பதை நினைவில் கொள்க.

** எச்சரிக்கை **: இந்த தொகுதி இன்னும் கப்பல்துறை ஆய்வுகளுடன் பொருந்தவில்லை, மேலும் நீங்கள் அதைப் பயன்படுத்தினால் அதை இணைக்காமல் படுக்கையை ஆய்வு செய்ய முயற்சிக்கும்.

## இழப்பீட்டு பயன்பாட்டின் கண்ணோட்டம்

> ** உதவிக்குறிப்பு: ** [ஆய்வு ஃச் மற்றும் ஒய் ஆஃப்செட்டுகள்] (config_reference.md#ஆய்வு) அளவுத்திருத்தத்தை பெரிதும் பாதிக்கும்போது சரியாக அமைக்கப்படுவதை உறுதிசெய்க.

### Basic Usage: X-Axis Calibration

1. After setting up the `[axis_twist_compensation]` module, run:

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

This command will calibrate the X-axis by default.

- The calibration wizard will prompt you to measure the probe Z offset at several points along the bed.
- By default, the calibration uses 3 points, but you can specify a different number with the option: `SAMPLE_COUNT=<value>`

1. **Adjust Your Z Offset:** After completing the calibration, be sure to [adjust your Z offset](Probe_Calibrate.md#calibrating-probe-z-offset).
1. **Perform Bed Leveling Operations:** Use probe-based operations as needed, such as:

- [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust)
- [Z Tilt Adjust](G-Codes.md#z_tilt_adjust)

1. **Finalize the Setup:**

- Home all axes, and perform a [Bed Mesh](Bed_Mesh.md) if necessary.
- Run a test print, followed by any [fine-tuning](Axis_Twist_Compensation.md#fine-tuning) if needed.

### For Y-Axis Calibration

The calibration process for the Y-axis is similar to the X-axis. To calibrate the Y-axis, use:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

This will guide you through the same measuring process as for the X-axis.

> ** உதவிக்குறிப்பு: ** படுக்கை வெப்பநிலை மற்றும் முனை வெப்பநிலை மற்றும் அளவு அளவுத்திருத்த செயல்முறைக்கு செல்வாக்கு இருப்பதாகத் தெரியவில்லை.

## [AXIS_TWIST_COMPENSATION] அமைப்பு மற்றும் கட்டளைகள்

Configuration options for `[axis_twist_compensation]` can be found in the [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Commands for `[axis_twist_compensation]` can be found in the [G-Codes Reference](G-Codes.md#axis_twist_compensation)
