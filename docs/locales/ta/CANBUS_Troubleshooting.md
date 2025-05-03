# கான்பச் சரிசெய்தல்

இந்த ஆவணம் [கேன் பச்) (CANBUS.MD) ஐப் பயன்படுத்தும் போது தகவல்தொடர்பு சிக்கல்களை சரிசெய்தல் பற்றிய தகவல்களை வழங்குகிறது.

## பச் வயரிங் செய்யலாம்

தகவல்தொடர்பு சிக்கல்களை சரிசெய்வதற்கான முதல் படி கேன் பச் வயரிங் சரிபார்க்க வேண்டும்.

Be sure there are exactly two 120 Ohm [terminating
resistors](CANBUS.md#terminating-resistors) on the CAN bus. If the resistors are not properly installed then messages may not be able to be sent at all or the connection may have sporadic instability.

CAN மற்றும் CANL BUS வயரிங் ஒருவருக்கொருவர் முறுக்க வேண்டும். குறைந்தபட்சம், வயரிங் ஒவ்வொரு சில சென்டிமீட்டருக்கும் ஒரு திருப்பத்தைக் கொண்டிருக்க வேண்டும். பவர் கம்பிகளைச் சுற்றி கேன் மற்றும் கேன்ல் வயரிங் முறுக்குவதைத் தவிர்த்து, கேன் மற்றும் கேன்ல் கம்பிகளுக்கு இணையாக பயணிக்கும் பவர் கம்பிகள் அதே அளவு திருப்பங்களைக் கொண்டிருக்கவில்லை என்பதை உறுதிப்படுத்தவும்.

கேன் பச் வயரிங் இல் உள்ள அனைத்து செருகிகளும் கம்பி கிரிம்ப்களும் முழுமையாகப் பாதுகாக்கப்பட்டுள்ளனவா என்பதை சரிபார்க்கவும். அச்சுப்பொறி கருவியின் இயக்கம் பச் வயரிங் ஒரு மோசமான கம்பி கிரிம்ப் அல்லது பாதுகாப்பற்ற பிளக் இடைப்பட்ட தகவல்தொடர்பு பிழைகள் ஏற்படக்கூடும்.

## BYTES_INVALID கவுண்டரை அதிகரிக்க சரிபார்க்கவும்

அச்சுப்பொறி செயலில் இருக்கும்போது ஒரு நொடிக்கு ஒரு முறை `புள்ளிவிவரங்கள்` வரியை கிளிப்பர் பதிவு கோப்பு புகாரளிக்கும். இந்த "புள்ளிவிவரங்கள்" வரிகள் ஒவ்வொரு மைக்ரோ-கன்ட்ரோலருக்கும் `பைட்டுகள்_இன் வாலிட்` கவுண்டரைக் கொண்டிருக்கும். சாதாரண அச்சுப்பொறி செயல்பாட்டின் போது இந்த கவுண்டர் அதிகரிக்கக்கூடாது (மறுதொடக்கத்திற்குப் பிறகு கவுண்டர் பூச்சியமற்றவராக இருப்பது இயல்பானது, மேலும் கவுண்டர் ஒரு மாதத்திற்கு ஒரு முறை அல்லது அதற்கு மேல் அதிகரித்தால் அது கவலைக்குரியது அல்ல). சாதாரண அச்சிடலின் போது இந்த கவுண்டர் கேன் பச் மைக்ரோ-கன்ட்ரோலரில் அதிகரித்தால் (இது ஒவ்வொரு சில மணிநேரங்களுக்கும் அல்லது அடிக்கடி அதிகரிக்கிறது), இது கடுமையான பிரச்சினையின் அறிகுறியாகும்.

Incrementing `bytes_invalid` on a CAN bus connection is a symptom of reordered messages on the CAN bus. If seen, make sure to:

* Use a Linux kernel version 6.6.0 or later.
* If using a USB-to-CANBUS adapter running candlelight firmware, use v2.0 or later of candleLight_fw.
* If using Klipper's USB-to-CANBUS bridge mode, make sure the bridge node is flashed with Klipper v0.12.0 or later.

Reordered messages is a severe problem that must be fixed. It will result in unstable behavior and can lead to confusing errors at any part of a print. An incrementing `bytes_invalid` is not caused by wiring or similar hardware issues and can only be fixed by identifying and updating the faulty software.

Older versions of the Linux kernel had a bug in the gs_usb canbus driver code that could cause reordered canbus packets. The issue is thought to be fixed in [Linux commit 24bc41b4](https://github.com/torvalds/linux/commit/24bc41b4558347672a3db61009c339b1f5692169) which was released in v6.6.0. In some cases, older Linux versions may not show the problem (due to how hardware interrupts are configured), however if problems are seen the recommended solution is to upgrade to a newer kernel.

Older versions of candlelight firmware could reorder canbus packets, and the issue is thought to be fixed in [candlelight_fw commit 8b3a7b45](https://github.com/candle-usb/candleLight_fw/commit/8b3a7b4565a3c9521b762b154c94c72c5acb2bcf).

Older versions of Klipper's USB-to-CANBUS bridge code could incorrectly drop canbus messages. This is not as severe as reordering messages, but it should still be fixed. It is thought to be fixed with [Klipper PR #6175](https://github.com/Klipper3d/klipper/pull/6175).

## பொருத்தமான txquealen அமைப்பைப் பயன்படுத்தவும்

பச் போக்குவரத்தை நிர்வகிக்க கிளிப்பர் குறியீடு லினக்ச் கர்னலைப் பயன்படுத்துகிறது. இயல்பாக, கர்னல் வரிசையில் 10 மட்டுமே பாக்கெட்டுகளை அனுப்ப முடியும். அந்த அளவை அதிகரிக்க [CAN0 சாதனத்தை] (CANBUS.MD#ஓச்ட்-ஆர்ட்வேர்) `TxQuealen 128` உடன் கட்டமைக்க பரிந்துரைக்கப்படுகிறது.

கிளிப்பர் ஒரு பாக்கெட்டை அனுப்பி, லினக்ச் அதன் டிரான்ச்மிட் வரிசை இடத்தை நிரப்பியிருந்தால், லினக்ச் அந்த பாக்கெட்டை கைவிடுகிறது, மேலும் பின்வருவனவற்றைப் போன்ற செய்திகள் கிளிப்பர் பதிவில் தோன்றும்:

```
பிழை -1 இல் எழுத முடியும்: (105) இடையக இடம் கிடைக்கவில்லை
```

கிளிப்பர் அதன் சாதாரண பயன்பாட்டு நிலை செய்தி ரெட்ரான்ச்மிட் அமைப்பின் ஒரு பகுதியாக இழந்த செய்திகளை தானாகவே மீண்டும் அனுப்பும். எனவே, இந்த பதிவு செய்தி ஒரு எச்சரிக்கையாகும், மேலும் இது மீட்டெடுக்க முடியாத பிழையைக் குறிக்கவில்லை.

ஒரு முழுமையான கேன் பச் தோல்வி ஏற்பட்டால் (கேன் கம்பி பிரேக் போன்றவை) பின்னர் லினக்ச் கேன் பச்சில் எந்த செய்திகளையும் அனுப்ப முடியாது, மேலும் மேலே உள்ள செய்தியை கிளிப்பர் பதிவில் கண்டுபிடிப்பது பொதுவானது. இந்த வழக்கில், பதிவு செய்தி ஒரு பெரிய பிரச்சினையின் அறிகுறியாகும் (எந்த செய்திகளையும் கடத்த இயலாமை) மற்றும் இது லினக்ச் `TxQuealen` உடன் நேரடியாக தொடர்புடையது அல்ல.

லினக்ச் கட்டளை `ஐபி இணைப்பு காட்சி CAN0` ஐ இயக்குவதன் மூலம் தற்போதைய வரிசை அளவை ஒருவர் சரிபார்க்கலாம். இது `QLEN 128` துணுக்கை உட்பட ஒரு சில உரையைப் புகாரளிக்க வேண்டும். `QLEN 10` போன்ற ஒன்றை ஒருவர் பார்த்தால், CAN சாதனம் சரியாக கட்டமைக்கப்படவில்லை என்பதைக் குறிக்கிறது.

128 ஐ விட கணிசமாக பெரிய `txquealen` ஐப் பயன்படுத்த பரிந்துரைக்கப்படவில்லை. 1000000 அதிர்வெண்ணில் இயங்கும் ஒரு பச் பொதுவாக ஒரு கேன் பாக்கெட்டை அனுப்ப 120US ஐ எடுக்கும். இதனால் 128 பாக்கெட்டுகளின் வரிசை வடிகட்ட 15-20 மீட்டர் ஆகும். கணிசமாக பெரிய வரிசை செய்தி சுற்று-பயண நேரத்தில் அதிகப்படியான கூர்முனைகளை ஏற்படுத்தக்கூடும், இது மீட்டெடுக்க முடியாத பிழைகளுக்கு வழிவகுக்கும். மற்றொரு வழி, கிளிப்பரின் பயன்பாட்டு ரெட்ரான்ச்மிட் அமைப்பு லினக்ச் அதிகப்படியான பெரிய வரிசையை வடிகட்ட காத்திருக்க வேண்டியதில்லை என்றால் மிகவும் வலுவானது. இது இணைய ரவுட்டர்களில் [பஃபர் பிளாட்] (https://en.wikipedia.org/wiki/bufferbloat) இன் சிக்கலுக்கு ஒப்பானது.

சாதாரண சூழ்நிலைகளில் கிளிப்பர் MCU க்கு ~ 25 வரிசை இடங்களைப் பயன்படுத்தலாம் - பொதுவாக மறுபிரவேசங்களின் போது அதிக இடங்களைப் பயன்படுத்துகிறது. . 128 இன் பரிந்துரைக்கப்பட்ட மதிப்புக்கு மேலே. இருப்பினும், மேலே உள்ளபடி, அதிகப்படியான சுற்று-பயண நேர தாமதத்தைத் தவிர்க்க புதிய மதிப்பைத் தேர்ந்தெடுக்கும்போது கவனமாக இருக்க வேண்டும்.

## Use `canbus_query.py` only to identify nodes never previously seen

It is only valid to use the [`canbus_query.py` tool](CANBUS.md#finding-the-canbus_uuid-for-new-micro-controllers) to identify micro-controllers that have never been previously identified. Once all nodes on a bus are identified, record the resulting uuids in the printer.cfg, and avoid running the tool unnecessarily.

The tool is implemented using a low-level mechanism that can cause nodes to internally observe bus errors. These internal errors may result in communication interruptions and may result is some nodes disconnecting from the bus.

It is not valid to use the tool to "ping" if a node is connected. Do not run the tool during an active print.

## கேண்டம்ப் பதிவுகளைப் பெறுதல்

மைக்ரோ-கன்ட்ரோலருக்கு அனுப்பப்பட்ட மற்றும் அனுப்பப்பட்ட பச் செய்திகள் லினக்ச் கர்னால் கையாளப்படுகின்றன. பிழைத்திருத்த நோக்கங்களுக்காக இந்த செய்திகளை கர்னலில் இருந்து கைப்பற்ற முடியும். இந்த செய்திகளின் பதிவு நோயறிதலில் பயன்படலாம்.

லினக்ச் [CAN-UTILS] (https://github.com/linux-can/can-utils) கருவி பிடிப்பு மென்பொருளை வழங்குகிறது. இது பொதுவாக இயங்குவதன் மூலம் ஒரு கணினியில் நிறுவப்படுகிறது:

```
sudo apt-get புதுப்பிப்பு && sudo apt-get install கேன்-பயன்பாடுகள்
```

நிறுவப்பட்டதும், பின்வரும் கட்டளையுடன் ஒரு இடைமுகத்தில் அனைத்து பச் செய்திகளையும் கைப்பற்றலாம்:

```
candump -tz -ddex can0,#ffffffff> myCanlog
```

கிளிப்பரால் அனுப்பப்பட்ட மற்றும் பெறப்பட்ட ஒவ்வொரு மூல கேன் பச் செய்தியையும் காண, இதன் விளைவாக வரும் பதிவு கோப்பை (`மைன்லாக்` மேலே உள்ள எடுத்துக்காட்டில்) காணலாம். இந்த செய்திகளின் உள்ளடக்கத்தைப் புரிந்துகொள்வதற்கு கிளிப்பரின் [கான்பச் நெறிமுறை] (Canbus_protocol.md) மற்றும் கிளிப்பரின் [MCU கட்டளைகள்] (MCU_COMMANDS.MD) பற்றிய குறைந்த அளவிலான அறிவு தேவைப்படும்.

### கேண்டம்ப் பதிவில் கிளிப்பர் செய்திகளை பாகுபடுத்துதல்

கேண்டம்ப் பதிவில் உள்ள குறைந்த அளவிலான கிளிப்பர் மைக்ரோ-கன்ட்ரோலர் செய்திகளை அலசுவதற்கு ஒருவர் `parsecandump.py` கருவியைப் பயன்படுத்தலாம். இந்த கருவியைப் பயன்படுத்துவது ஒரு மேம்பட்ட தலைப்பு, இது கிளிப்பர் [MCU கட்டளைகள்] (MCU_COMMANDS.MD) பற்றிய அறிவு தேவைப்படுகிறது. உதாரணமாக:

```
./scripts/parsecandump.py mycanlog 108 ./out/klipper.dict
```

This tool produces output similar to the [parsedump
tool](Debugging.md#translating-gcode-files-to-micro-controller-commands). See the documentation for that tool for information on generating the Klipper micro-controller data dictionary.

In the above example, `108` is the [CAN bus
id](CANBUS_protocol.md#micro-controller-id-assignment). It is a hexadecimal number. The id `108` is assigned by Klipper to the first micro-controller. If the CAN bus has multiple micro-controllers on it, then the second micro-controller would be `10a`, the third would be `10c`, and so on.

`Parsecandump.py` கருவியைப் பயன்படுத்துவதற்காக` -tz -ddex` கட்டளை -வரி வாதங்களைப் பயன்படுத்தி (எடுத்துக்காட்டாக: `candump -tz -ddex can0,#ffffffff`) பயன்படுத்தி கேண்டம்ப் பதிவு தயாரிக்கப்பட வேண்டும்.

## கான்பச் வயரிங் மீது ஒரு வழக்கு பகுப்பாய்வியைப் பயன்படுத்துதல்

[சிக்ரோக் புல்வெவியூ] (https://sigrok.org/wiki/pulsyview) மென்பொருள் குறைந்த வழக்கு [லாசிக் அனலைசர்] (https://en.wikipedia.org/wiki/logic_analyzer) பச் சிக்னலிங். இது நிபுணர்களுக்கு ஆர்வமாக மட்டுமே இருக்கும் ஒரு மேம்பட்ட தலைப்பு.

ஒருவர் பெரும்பாலும் "யூ.எச்.பி லாசிக் அனலிசர்களை" $ 15 க்கு கீழ் காணலாம் (2023 வரை அமெரிக்க விலை நிர்ணயம்). இந்த சாதனங்கள் பெரும்பாலும் "சாலே லாசிக் குளோன்கள்" அல்லது "24 மெகா எர்ட்ச் 8 சேனல் யூ.எச்.பி லாசிக் அனலைசர்கள்" என பட்டியலிடப்பட்டுள்ளன.

!

"சாலே நகலி" லாசிக் பகுப்பாய்வியுடன் பல்ச்வியூவைப் பயன்படுத்தும் போது மேலே உள்ள படம் எடுக்கப்பட்டது. சிக்ரோக் மற்றும் புல்வெவியூ மென்பொருள் ஒரு டெச்க்டாப் கணினியில் நிறுவப்பட்டது (அது தனித்தனியாக தொகுக்கப்பட்டால் "FX2LAFW" ஃபார்ம்வேரையும் நிறுவவும்). லாசிக் அனலைசரில் உள்ள CH0 முள் CAN RX வரிக்கு அனுப்பப்பட்டது, CH1 முள் CAN TX முள் க்கு கம்பி செய்யப்பட்டது, மற்றும் GND GND க்கு கம்பி செய்யப்பட்டது. D0 மற்றும் D1 வரிகளை (சிவப்பு "ஆய்வு" படவுரு சென்டர் டாப் கருவிப்பட்டி) மட்டுமே காண்பிக்க பல்சேவியூ கட்டமைக்கப்பட்டது. மாதிரிகளின் எண்ணிக்கை 5 மில்லியனாக (சிறந்த கருவிப்பட்டி) அமைக்கப்பட்டது மற்றும் மாதிரி வீதம் 24 மெகா எர்ட்ச் (சிறந்த கருவிப்பட்டி) என அமைக்கப்பட்டது. கேன் டிகோடர் சேர்க்கப்பட்டது (மஞ்சள் மற்றும் பச்சை "குமிழி படவுரு" வலது மேல் கருவிப்பட்டி). டி 0 சேனல் ஆர்எக்ச் என பெயரிடப்பட்டு வீழ்ச்சி விளிம்பில் தூண்டுவதற்கு அமைக்கப்பட்டது (இடதுபுறத்தில் கருப்பு டி 0 லேபிளைக் சொடுக்கு செய்க). டி 1 சேனல் டிஎக்ச் என பெயரிடப்பட்டது (இடதுபுறத்தில் பிரவுன் டி 1 லேபிளைக் சொடுக்கு செய்க). CAN டிகோடர் 1MBIT வீதத்திற்கு கட்டமைக்கப்பட்டது (இடதுபுறத்தில் பச்சை கேன் லேபிளைக் சொடுக்கு செய்க). கேன் டிகோடர் காட்சியின் மேற்பகுதிக்கு நகர்த்தப்பட்டது (கிளிக் செய்து இழுக்க பச்சை கேன் லேபிள்). இறுதியாக, பிடிப்பு தொடங்கப்பட்டது (மேல் இடதுபுறத்தில் "ரன்" என்பதைக் சொடுக்கு செய்க) மற்றும் கேன் பச்சில் ஒரு பாக்கெட் அனுப்பப்பட்டது (`கேன்சென்ட் CAN0 123#1212121212`).

லாசிக் அனலைசர் பாக்கெட்டுகளைக் கைப்பற்றுவதற்கும் பிட் நேரத்தை சரிபார்க்கவும் ஒரு சுயாதீன கருவியை வழங்குகிறது.
