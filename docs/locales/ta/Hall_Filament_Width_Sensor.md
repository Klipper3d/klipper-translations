# ஆல் ஃபிலமென்ட் அகல சென்சார்

இந்த ஆவணம் இழை அகல சென்சார் புரவலன் தொகுதியை விவரிக்கிறது. இந்த புரவலன் தொகுதியை உருவாக்கப் பயன்படுத்தப்படும் வன்பொருள் இரண்டு ஆல் நேரியல் சென்சார்களை அடிப்படையாகக் கொண்டது (எடுத்துக்காட்டாக SS49E). உடலில் உள்ள சென்சார்கள் எதிர் பக்கங்களில் அமைந்துள்ளன. செயல்பாட்டின் கொள்கை: இரண்டு ஆல் சென்சார்கள் வேறுபட்ட பயன்முறையில் வேலை செய்கின்றன, சென்சாருக்கு வெப்பநிலை சறுக்கல். சிறப்பு வெப்பநிலை இழப்பீடு தேவையில்லை.

[Inceverse] (https://www.thingiverse.com/thing:4138933) இல் நீங்கள் வடிவமைப்புகளைக் காணலாம், ஒரு பேரவை வீடியோ [YouTube] (https://www.youtube.com/watch?v=tdo9tme8vp4 இல் கிடைக்கிறது )

ஆல் ஃபிலமென்ட் அகலம் சென்சார் பயன்படுத்த, [கட்டமைப்பு குறிப்பு] (config_reference.md#hall_filament_width_sensor) மற்றும் [g-code ஆவணம்] (g- codes.md#hall_filament_width_sensor) படிக்கவும்.

## இது எவ்வாறு செயல்படுகிறது?

கணக்கிடப்பட்ட இழை அகலத்தின் அடிப்படையில் சென்சார் இரண்டு அனலாக் வெளியீட்டை உருவாக்குகிறது. வெளியீட்டு மின்னழுத்தத்தின் தொகை எப்போதும் கண்டறியப்பட்ட இழை அகலத்திற்கு சமம். புரவலன் தொகுதி மின்னழுத்த மாற்றங்களை கண்காணிக்கிறது மற்றும் வெளியேற்ற பெருக்கியை சரிசெய்கிறது. அனலாக் 11 மற்றும் அனலாக் 12 ஊசிகளுடன் வளைவு போன்ற பலகையில் AUX2 இணைப்பியைப் பயன்படுத்துகிறேன். நீங்கள் வெவ்வேறு ஊசிகளையும் வெவ்வேறு பலகைகளையும் பயன்படுத்தலாம்.

## பட்டியல் மாறிகள் வார்ப்புரு

```
.
 வகை: கட்டளை
 இயக்கு: அச்சுப்பொறியில் {'hall_filament_width_sensor'
 பெயர்: தியா: {' % .2f' % அச்சுப்பொறி
 அட்டவணை: 0

 .
 வகை: கட்டளை
 இயக்கு: அச்சுப்பொறியில் {'hall_filament_width_sensor'
 பெயர்: ரா: {' % 4.0f' % அச்சுப்பொறி.ஆல்_பிலமென்ட்_விட்_சென்சர்.ரா}
 அட்டவணை: 1
```

## அளவுத்திருத்த செயல்முறை

மூல சென்சார் மதிப்பைப் பெற நீங்கள் பட்டியல் உருப்படி அல்லது ** Query_raw_filament_width ** முனையத்தில் கட்டளை பயன்படுத்தலாம்.

1. முதல் அளவுத்திருத்த தடியைச் செருகவும் (1.5 மிமீ அளவு) முதல் மூல சென்சார் மதிப்பைப் பெறுங்கள்
1. இரண்டாவது அளவுத்திருத்த தடியைச் செருகவும் (2.0 மிமீ அளவு) இரண்டாவது மூல சென்சார் மதிப்பைப் பெறுங்கள்
1. மூல சென்சார் மதிப்புகளை `RAW_DIA1` மற்றும்` RAW_DIA2` ஆகியவற்றில் சேமிக்கவும்

## சென்சாரை எவ்வாறு இயக்குவது

இயல்பாக, சென்சார் பவர்-ஆன் முடக்கப்பட்டுள்ளது.

சென்சாரை இயக்க, வெளியீடு ** enable_filament_width_sensor ** கட்டளை அல்லது `இயக்கு` அளவுருவை` உண்மை` என அமைக்கவும்.

## Use as a runout switch only

By default, the sensor measures filament diameter and adjusts the extrusion multiplier to compensate for variations.

If you want to use the sensor as a runout switch only, set the `enable_flow_compensation` config parameter to `false`. In this mode, the sensor will only trigger runout events when filament is not detected, it will not modify the extrusion multiplier.

This is useful for printers where the filament sensor is not accurate enough for flow compensation but can reliably detect filament runout, or when printing with flexible filaments which have unstable diameter characteristics.

Issue **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=1** to enable flow compensation or **ENABLE_FILAMENT_WIDTH_SENSOR FLOW_COMPENSATION=0** to disable it.

Note that disabling filament width compensation automatically resets the extrusion multiplier to 100%.

**QUERY_FILAMENT_WIDTH** includes the current state of flow compensation in its output.

## பதிவு

இயல்பாக, பவர்-ஆன் இல் விட்டம் பதிவு முடக்கப்பட்டுள்ளது.

வெளியீடு ** enable_filament_width_log ** உள்நுழைவைத் தொடங்கவும் வெளியிடவும் கட்டளை ** உள்நுழைவதை நிறுத்த கட்டளை. பவர்-ஆன் உள்நுழைவை இயக்க, `லாக்கிங்` அளவுருவை` உண்மை` என அமைக்கவும்.

ஒவ்வொரு அளவீட்டு இடைவெளியிலும் (இயல்பாக 10 மிமீ) இழை விட்டம் உள்நுழைந்துள்ளது.
