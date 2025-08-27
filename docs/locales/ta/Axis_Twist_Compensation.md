# அச்சு திருப்ப இழப்பீடு

இந்த ஆவணம் `[axis_twist_compensation]` தொகுதியை விவரிக்கிறது.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

இந்த தொகுதி ஆய்வின் முடிவுகளை சரிசெய்ய பயனரின் கையேடு அளவீடுகளைப் பயன்படுத்துகிறது. உங்கள் அச்சு கணிசமாக முறுக்கப்பட்டால், மென்பொருள் திருத்தங்களைப் பயன்படுத்துவதற்கு முன்பு அதை சரிசெய்ய முதலில் இயந்திர வழிமுறைகளைப் பயன்படுத்த பரிந்துரைக்கப்படுகிறது என்பதை நினைவில் கொள்க.

** எச்சரிக்கை **: இந்த தொகுதி இன்னும் கப்பல்துறை ஆய்வுகளுடன் பொருந்தவில்லை, மேலும் நீங்கள் அதைப் பயன்படுத்தினால் அதை இணைக்காமல் படுக்கையை ஆய்வு செய்ய முயற்சிக்கும்.

## இழப்பீட்டு பயன்பாட்டின் கண்ணோட்டம்

> ** உதவிக்குறிப்பு: ** [ஆய்வு ஃச் மற்றும் ஒய் ஆஃப்செட்டுகள்](Config_Reference.md#probe) அளவுத்திருத்தத்தை பெரிதும் பாதிக்கும்போது சரியாக அமைக்கப்படுவதை உறுதிசெய்க.

### அடிப்படை பயன்பாடு: X-அச்சு அளவுத்திருத்தம்

1. `[axis_twist_compensation]` தொகுதியை அமைத்தபிறகு, இயக்கவும்:

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

இந்தக் கட்டளை முன்னிருப்பாக X- அச்சை அளவீடு செய்யும்.

- அளவுத்திருத்த வழிகாட்டி, படுக்கையில் பல புள்ளிகளில் ஆய்வு Z ஆஃப்செட்டை அளவிட உங்களைத் தூண்டும்.
- இயல்பாக, அளவுத்திருத்தம் 3 புள்ளிகளைப் பயன்படுத்துகிறது, ஆனால் நீங்கள் `SAMPLE_COUNT=<value>` என்ற விருப்பத்துடன் வேறு எண்ணைக் குறிப்பிடலாம்

1. **உங்கள் Z ஆஃப்செட்டை சரிசெய்யவும்:** அளவுத்திருத்தத்தை முடித்த பிறகு, [உங்கள் Z ஆஃப்செட்டை சரிசெய்யவும்](Probe_Calibrate.md#calibrating-probe-z-offset) என்பதை உறுதிப்படுத்திக் கொள்ளுங்கள்.
1. **படுக்கை சமன்படுத்தும் செயல்பாடுகளைச் செய்யுங்கள்:** தேவைக்கேற்ப ஆய்வு அடிப்படையிலான செயல்பாடுகளைப் பயன்படுத்தவும், அவை:

- [திருகுகள் சாய்வு சரிசெய்தல்](G-Codes.md#screws_tilt_adjust)
- [Z சாய்வு சரிசெய்தல்](G-Codes.md#z_tilt_adjust)

1. **அமைப்பை முடிக்கவும்:**

- தேவைப்பட்டால், அனைத்து அச்சுகளையும் முகப்பு செய்து, [Bed Mesh](Bed_Mesh.md) செய்யவும்.
- தேவைப்பட்டால், ஒரு சோதனை அச்சை இயக்கவும், அதைத் தொடர்ந்து ஏதேனும் [fine-tuning](Axis_Twist_Compensation.md#fine-tuning) செய்யவும்.

### Y-அச்சு அளவுத்திருத்தத்திற்கு

Y-அச்சுக்கான அளவுத்திருத்த செயல்முறை X-அச்சுக்கு ஒத்ததாகும். Y-அச்சை அளவீடு செய்ய, பயன்படுத்தவும்:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

இது X- அச்சைப் போலவே அதே அளவீட்டு செயல்முறையின் மூலம் உங்களை வழிநடத்தும்.

> ** உதவிக்குறிப்பு: ** படுக்கை வெப்பநிலை மற்றும் முனை வெப்பநிலை மற்றும் அளவு அளவுத்திருத்த செயல்முறைக்கு செல்வாக்கு இருப்பதாகத் தெரியவில்லை.

## [AXIS_TWIST_COMPENSATION] அமைப்பு மற்றும் கட்டளைகள்

`[axis_twist_compensation]` க்கான உள்ளமைவு விருப்பங்களை [உள்ளமைவு குறிப்பு](Configuration_Reference.md#axis_twist_compensation) இல் காணலாம்.

`[axis_twist_compensation]` க்கான கட்டளைகளை [G-Codes Reference](G-Codes.md#axis_twist_compensation) இல் காணலாம்
