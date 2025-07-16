# வரையறைகள்

இந்த ஆவணம் கிளிப்பர் வரையறைகளை விவரிக்கிறது.

## மைக்ரோ-கண்ட்ரோலர் வரையறைகள்

கிளிப்பர் மைக்ரோ-கன்ட்ரோலர் படி வீத வரையறைகளை உருவாக்க பயன்படும் பொறிமுறையை இந்த பிரிவு விவரிக்கிறது.

மென்பொருளுக்குள் குறியீட்டு மாற்றங்களின் தாக்கத்தை அளவிடுவதற்கான ஒரு நிலையான பொறிமுறையை வழங்குவதே வரையறைகளின் முதன்மை குறிக்கோள். சில்லுகள் மற்றும் மென்பொருள் தளங்களுக்கு இடையில் செயல்திறனை ஒப்பிடுவதற்கான உயர் மட்ட அளவீடுகளை வழங்குவதே இரண்டாம் நிலை குறிக்கோள்.

வன்பொருள் மற்றும் மென்பொருள் அடையக்கூடிய அதிகபட்ச படிநிலை விகிதத்தைக் கண்டறிய படி வீத அளவுகோல் வடிவமைக்கப்பட்டுள்ளது. எந்தவொரு நிச உலக பயன்பாட்டிலும் கிளிப்பர் பிற பணிகளை (எ.கா., எம்.சி.யு/ஓச்ட் செய்தி தொடர்பு, வெப்பநிலை வாசிப்பு, எண்ட்ச்டாப் சோதனை) செய்ய வேண்டியிருப்பதால் இந்த பெஞ்ச்மார்க் படிநிலை விகிதம் அன்றாட பயன்பாட்டில் அடைய முடியாது.

பொதுவாக, பெஞ்ச்மார்க் சோதனைகளுக்கான ஊசிகள் ஃபிளாச் எல்.ஈ.டிக்கள் அல்லது பிற தீங்கற்ற ஊசிகளுக்கு தேர்ந்தெடுக்கப்படுகின்றன. ** ஒரு அளவுகோலை இயக்குவதற்கு முன்பு கட்டமைக்கப்பட்ட ஊசிகளை ஓட்டுவது பாதுகாப்பானது என்பதை எப்போதும் சரிபார்க்கவும். ** ஒரு அளவுகோலின் போது உண்மையான ச்டெப்பரை இயக்க பரிந்துரைக்கப்படவில்லை.

### படி வீத அளவுகோல் சோதனை

சோதனை Console.py கருவியைப் பயன்படுத்தி செய்யப்படுகிறது (<பிழைத்திருத்தம். Md> இல் விவரிக்கப்பட்டுள்ளது). மைக்ரோ-கண்ட்ரோலர் குறிப்பிட்ட வன்பொருள் தளத்திற்காக கட்டமைக்கப்பட்டுள்ளது (கீழே காண்க) பின்னர் பின்வருபவை கன்சோலில் வெட்டப்பட்ட மற்றும் ஒட்டுதல்.

```
START_CLOCK {CLACK+FREQ}
 உண்ணி 1000 ஐ அமைக்கவும்

 Reset_step_clock oid = 0 கடிகாரம் = {start_clock}
 set_next_step_dir oid = 0 அடைவு = 0
 queue_step oid = 0 இடைவெளி = {ticks} எண்ணிக்கை = 60000 சேர் = 0
 set_next_step_dir oid = 0 அடைவு = 1
 queue_step oid = 0 இடைவெளி = 3000 எண்ணிக்கை = 1 கூட்டு = 0

 Reset_step_clock oid = 1 கடிகாரம் = {start_clock}
 set_next_step_dir oid = 1 அடைவு = 0
 queue_step oid = 1 இடைவெளி = {ticks} எண்ணிக்கை = 60000 சேர் = 0
 set_next_step_dir oid = 1 அடைவு = 1
 queue_step oid = 1 இடைவெளி = 3000 எண்ணிக்கை = 1 கூட்டு = 0

 Reset_step_clock oid = 2 கடிகாரம் = {start_clock}
 set_next_step_dir oid = 2 அடைவு = 0
 queue_step oid = 2 இடைவெளி = {ticks} எண்ணிக்கை = 60000 சேர் = 0
 set_next_step_dir oid = 2 அடைவு = 1
 queue_step oid = 2 இடைவெளி = 3000 எண்ணிக்கை = 1 கூட்டு = 0
```

மேலே உள்ள மூன்று ச்டெப்பர்கள் ஒரே நேரத்தில் அடியெடுத்து வைக்கின்றன. மேற்கண்ட முடிவுகளை "கடந்த காலத்தில் மறுசீரமைக்கப்பட்ட டைமரில்" அல்லது "கடந்த காலங்களில் ச்டெப்பர்" பிழையில் இயக்கினால், அது `உண்ணி` அளவுரு மிகக் குறைவாக இருப்பதைக் குறிக்கிறது (இது ஒரு படி விகிதத்தில் மிக வேகமாக இருக்கும்). சோதனையை வெற்றிகரமாக முடிக்க நம்பத்தகுந்த வகையில் முடிவடையும் உண்ணி அளவுருவின் மிகக் குறைந்த அமைப்பைக் கண்டுபிடிப்பதே குறிக்கோள். நிலையான மதிப்பு காணப்படும் வரை உண்ணி அளவுருவை பிளவுபடுத்த முடியும்.

தோல்வியில், அடுத்த சோதனைக்கான தயாரிப்பில் பிழையை அழிக்க ஒருவர் பின்வருவனவற்றை நகலெடுத்து ஒட்டலாம்:

```
clear_shutdown
```

ஒற்றை ச்டெப்பர் வரையறைகளைப் பெற, அதே உள்ளமைவு வரிசை பயன்படுத்தப்படுகிறது, ஆனால் மேலே உள்ள சோதனையின் முதல் தொகுதி மட்டுமே கன்சோல்.பை சாளரத்தில் வெட்டப்பட்டு ஒட்டுகிறது.

[அம்சங்கள்] (அம்சங்கள்] (அம்சங்கள். முடிவுகள் அருகிலுள்ள கே. க்கு வட்டமானவை. எடுத்துக்காட்டாக, மூன்று செயலில் உள்ள ச்டெப்பர்களுடன்:

```
எதிரொலி சோதனை முடிவு: {" % .0fk" % (3. * Freq / decks / 1000.)}
```

டி.எம்.சி டிரைவர்களுக்கு ஏற்ற அளவுருக்கள் மூலம் வரையறைகள் இயக்கப்படுகின்றன. `Stepper_both_edge = 1` (கன்சோல்.பை முதலில் தொடங்கும் போது` MCU கட்டமைப்பு` வரியில் தெரிவிக்கப்பட்டுள்ளபடி) ஆதரிக்கும் மைக்ரோ-கன்ட்ரோலர்களுக்கு `Step_pulse_duration = 0` மற்றும்` Invert_step = -1` ஆகியவற்றைப் பயன்படுத்தவும் படி துடிப்பு. பிற மைக்ரோ-கன்ட்ரோலர்களுக்கு 100ns உடன் தொடர்புடைய `Step_pulse_duration` ஐப் பயன்படுத்தவும்.

### ஏ.வி.ஆர் படி வீத அளவுகோல்

ஏ.வி.ஆர் சில்லுகளில் பின்வரும் உள்ளமைவு வரிசை பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pa5 dir_pin = pa4 invert_step = 0 step_pules_ticks = 32
 config_stepper oid = 1 step_pin = pa3 dir_pin = pa2 invert_step = 0 step_pules_ticks = 32
 config_stepper oid = 2 step_pin = pc7 dir_pin = pc6 invert_step = 0 step_pules_ticks = 32
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

சி.சி.சி பதிப்பு `ஏ.வி.ஆர்-சி.சி.சி (சி.சி.சி) 5.4.0` உடன்` 59314D99` இல் சோதனை கடைசியாக இயக்கப்பட்டது. 16 மெகா எர்ட்ச் மற்றும் 20 மெகா எர்ட்ச் சோதனைகள் இரண்டும் ATMEGA644P க்காக கட்டமைக்கப்பட்ட சிமுலாவ்ஆரைப் பயன்படுத்தி இயக்கப்பட்டன (முந்தைய சோதனைகள் 16 மெகா எர்ட்ச் AT90USB மற்றும் 16 மெகா எர்ட்ச் Atmega2560 இரண்டிலும் சிமுலாவர் முடிவுகள் போட்டி சோதனைகளை உறுதிப்படுத்தியுள்ளன.

| ஏ.வி.ஆர் | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 102 |
| 3 ச்டெப்பர் | 486 |

### Arduino காரணமாக படி வீத அளவுகோல்

பின்வரும் உள்ளமைவு வரிசை வரவிருப்பதில் பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pb27 dir_pin = pa21 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pb26 dir_pin = pc30 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pa21 dir_pin = pc30 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

இந்த சோதனை கடைசியாக GCC பதிப்பு `ARM-NONE-EABI-GCC (ஃபெடோரா 10.2.0-4.FC34) 10.2.0` உடன்` 59314D99` இல் இயக்கப்பட்டது.

| SAM3X8E | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 66 |
| 3 ச்டெப்பர் | 257 |

### டூயட் மேச்ட்ரோ படி வீத அளவுகோல்

டூயட் மேச்ட்ரோவில் பின்வரும் உள்ளமைவு வரிசை பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pc26 dir_pin = pc18 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pc26 dir_pin = pa8 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pc26 dir_pin = pb4 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

இந்த சோதனை கடைசியாக GCC பதிப்பு `ARM-NONE-EABI-GCC (ஃபெடோரா 10.2.0-4.FC34) 10.2.0` உடன்` 59314D99` இல் இயக்கப்பட்டது.

| SAM4S8C | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 71 |
| 3 ச்டெப்பர் | 260 |

### டூயட் வைஃபை படி வீத அளவுகோல்

டூயட் வைஃபை மீது பின்வரும் உள்ளமைவு வரிசை பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pd6 dir_pin = pd11 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pd7 dir_pin = pd12 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pd8 dir_pin = pd13 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

சி.சி.சி பதிப்பு `சி.சி.சி பதிப்பு 10.3.1 20210621 (வெளியீடு) (குனு கை உட்பொதிக்கப்பட்ட கருவித்தொகுப்பு 10.3-2021.07)` உடன் சோதனை `59314D99` இல் கடைசியாக இயக்கப்பட்டது.

| sam4e8e | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 48 |
| 3 ச்டெப்பர் | 215 |

### பீகல்போன் ப்ரூ படி வீத அளவுகோல்

PRU இல் பின்வரும் உள்ளமைவு வரிசை பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = gpio0_23 dir_pin = gpio1_12 invert_step = 0 step_pulse_ticks = 20
 config_stepper oid = 1 step_pin = gpio1_15 dir_pin = gpio0_26 invert_step = 0 step_pulse_ticks = 20
 config_stepper oid = 2 step_pin = gpio0_22 dir_pin = gpio2_1 invert_step = 0 step_pules_ticks = 20
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

இந்த சோதனை கடைசியாக GCC பதிப்பு `PRU-GCC (GCC) 8.0.0 20170530 (சோதனை)` உடன் `59314D99` இல் இயக்கப்பட்டது.

| ப்ரூ | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 231 |
| 3 ச்டெப்பர் | 847 |

### STM32F042 படி வீத அளவுகோல்

பின்வரும் உள்ளமைவு வரிசை STM32F042 இல் பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pa1 dir_pin = pa2 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pa3 dir_pin = pa2 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pb8 dir_pin = pa2 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

இந்த சோதனை கடைசியாக GCC பதிப்பு `ARM-NONE-EABI-GCC (ஃபெடோரா 10.2.0-4.FC34) 10.2.0` உடன்` 59314D99` இல் இயக்கப்பட்டது.

| STM32F042 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 59 |
| 3 ச்டெப்பர் | 249 |

### STM32F103 படி வீத அளவுகோல்

பின்வரும் உள்ளமைவு வரிசை STM32F103 இல் பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pc13 dir_pin = pb5 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pb3 dir_pin = pb6 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pa4 dir_pin = pb7 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

இந்த சோதனை கடைசியாக GCC பதிப்பு `ARM-NONE-EABI-GCC (ஃபெடோரா 10.2.0-4.FC34) 10.2.0` உடன்` 59314D99` இல் இயக்கப்பட்டது.

| STM32F103 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 61 |
| 3 ச்டெப்பர் | 264 |

### STM32F4 படி வீத அளவுகோல்

பின்வரும் உள்ளமைவு வரிசை STM32F4 இல் பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pa5 dir_pin = pb5 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pb2 dir_pin = pb6 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pb3 dir_pin = pb7 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

இந்த சோதனை கடைசியாக GCC பதிப்பு `ARM-NONE-EABI-GCC (ஃபெடோரா 10.2.0-4.FC34) 10.2.0` உடன்` 59314D99` இல் இயக்கப்பட்டது. STM32F407 முடிவுகள் STM32F407 பைனரியை ஒரு STM32F446 இல் இயக்குவதன் மூலம் பெறப்பட்டன (இதனால் 168MHz கடிகாரத்தைப் பயன்படுத்துகிறது).

| STM32F446 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 46 |
| 3 ச்டெப்பர் | 205 |

| நான் 407 கேட்பேன் | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 46 |
| 3 ச்டெப்பர் | 205 |

### STM32H7 படி வீத அளவுகோல்

The following configuration sequence is used on STM32H723:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=52
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=52
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=52
finalize_config crc=0
```

The test was last run on commit `554ae78d` with gcc version `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0`.

| stm32h723 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 70 |
| 3 ச்டெப்பர் | 181 |

### STM32G0B1 படி வீத அளவுகோல்

பின்வரும் உள்ளமைவு வரிசை STM32G0B1 இல் பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pb13 dir_pin = pb12 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pb10 dir_pin = pb2 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pb0 dir_pin = pc5 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

இந்த சோதனை கடைசியாக GCC பதிப்பு `ARM-NONE-EABI-GCC (ஃபெடோரா 10.2.0-4.FC34) 10.2.0` உடன்` 247 சிடி 753` இல் இயக்கப்பட்டது.

| STM32G0B1 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 58 |
| 3 ச்டெப்பர் | 243 |

### STM32G4 step rate benchmark

The following configuration sequence is used on the STM32G431:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA0 dir_pin=PB5 invert_step=-1 step_pulse_ticks=17
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=17
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=17
finalize_config crc=0
```

The test was last run on commit `cfa48fe3` with gcc version `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0`.

| stm32g431 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 47 |
| 3 ச்டெப்பர் | 208 |

### எல்பிசி 176 ஃச் படி வீத அளவுகோல்

பின்வரும் உள்ளமைவு வரிசை LPC176X இல் பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = p1.20 dir_pin = p1.18 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = p1.21 dir_pin = p1.18 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = p1.23 dir_pin = p1.18 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

இந்த சோதனை கடைசியாக GCC பதிப்பு `ARM-NONE-EABI-GCC (ஃபெடோரா 10.2.0-4.FC34) 10.2.0` உடன்` 59314D99` இல் இயக்கப்பட்டது. 120 மெகா எர்ட்ச் எல்பிசி 1769 முடிவுகள் எல்பிசி 1768 ஐ 120 மெகா எர்ட்ச் வரை ஓவர்லாக் செய்வதன் மூலம் பெறப்பட்டன.

| எல்பிசி 1768 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 52 |
| 3 ச்டெப்பர் | 222 |

| எல்பிசி 1769 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 51 |
| 3 ச்டெப்பர் | 222 |

### SAMD21 படி வீத அளவுகோல்

பின்வரும் உள்ளமைவு வரிசை SAMD21 இல் பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pa27 dir_pin = pa20 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pb3 dir_pin = pa21 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pa17 dir_pin = pa21 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

இந்த சோதனை கடைசியாக GCC பதிப்பு `ARM-NONE-EABI-GCC (ஃபெடோரா 10.2.0-4.FC34) 10.2.0` உடன் ஒரு SAMD21G18 மைக்ரோ-கான்ட்ரோலரில் கமிட்` 59314D99` இல் இயக்கப்பட்டது.

| SAMD21 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 70 |
| 3 ச்டெப்பர் | 306 |

### SAMD51 படி வீத அளவுகோல்

பின்வரும் உள்ளமைவு வரிசை SAMD51 இல் பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pa22 dir_pin = pa20 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pa22 dir_pin = pa21 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pa22 dir_pin = pa19 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

GCC பதிப்பு `ARM-NONE-EABI-GCC (ஃபெடோரா 10.2.0-4.FC34) 10.2.0` உடன் ஒரு SAMD51J19A மைக்ரோ-கான்ட்ரோலரில் 10.2.0` உடன் இந்த சோதனை கடைசியாக இயக்கப்பட்டது.

| SAMD51 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 39 |
| 3 ச்டெப்பர் | 191 |
| 1 ச்டெப்பர் (200 மெகா எர்ட்ச்) | 39 |
| 3 ச்டெப்பர் (200 மெகா எர்ட்ச்) | 181 |

### SAME70 step rate benchmark

The following configuration sequence is used on the SAME70:

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC18 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC16 dir_pin=PD10 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC28 dir_pin=PA4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

The test was last run on commit `34e9ea55` with gcc version `arm-none-eabi-gcc (NixOS 10.3-2021.10) 10.3.1` on a SAME70Q20B micro-controller.

| same70 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 45 |
| 3 ச்டெப்பர் | 190 |

### AR100 படி வீத அளவுகோல்

பின்வரும் உள்ளமைவு வரிசை AR100 சிபியு இல் பயன்படுத்தப்படுகிறது (ALLWINNER A64):

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = pl10 dir_pin = pe14 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = pl11 dir_pin = pe15 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = pl12 dir_pin = pe16 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

The test was last run on commit `b7978d37` with gcc version `or1k-linux-musl-gcc (GCC) 9.2.0` on an Allwinner A64-H micro-controller.

| AR100 R_PIO | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 85 |
| 3 ச்டெப்பர் | 359 |

### RPxxxx step rate benchmark

The following configuration sequence is used on the RP2040 and RP2350:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = gpio25 dir_pin = gpio3 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 1 step_pin = gpio26 dir_pin = gpio4 invert_step = -1 step_pules_ticks = 0
 config_stepper oid = 2 step_pin = gpio27 dir_pin = gpio5 invert_step = -1 step_pules_ticks = 0
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

The test was last run on commit `14c105b8` with gcc version `arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0` on Raspberry Pi Pico and Pico 2 boards.

| rp2040 (*) | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 3 |
| 3 ச்டெப்பர் | 14 |

| rp2350 | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 36 |
| 3 ச்டெப்பர் | 169 |

(*) Note that the reported rp2040 ticks are relative to a 12Mhz scheduling timer and do not correspond to its 200Mhz internal ARM processing rate. It is expected that 3 scheduling ticks corresponds to ~42 ARM core cycles and 14 scheduling ticks corresponds to ~225 ARM core cycles.

### லினக்ச் எம்.சி.யு படி வீத அளவுகோல்

ராச்பெர்ரி பையில் பின்வரும் உள்ளமைவு வரிசை பயன்படுத்தப்படுகிறது:

```
ஒதுக்கீடு_யிட்ச் எண்ணிக்கை = 3
 config_stepper oid = 0 step_pin = gpio2 dir_pin = gpio3 invert_step = 0 step_pules_ticks = 5
 config_stepper oid = 1 step_pin = gpio4 dir_pin = gpio5 invert_step = 0 step_pules_ticks = 5
 config_stepper oid = 2 step_pin = gpio6 dir_pin = gpio17 invert_step = 0 step_pules_ticks = 5
 இறுதி_கான்ஃபிக் சி.ஆர்.சி = 0
```

சி.சி.சி பதிப்பு `சி.சி.சி (ராச்பியன் 8.3.0-6+ஆர்.பி.ஐ 1) 8.3.0` உடன் ராச்பெர்ரி பை 3 (திருத்தம் A02082) உடன் இந்த சோதனை கடைசியாக இயக்கப்பட்டது. இந்த அளவுகோலில் நிலையான முடிவுகளைப் பெறுவது கடினம்.

| லினக்ச் (RPI3) | உண்ணி |
| --- | --- |
| 1 ச்டெப்பர் | 160 |
| 3 ச்டெப்பர் | 380 |

## கட்டளை அனுப்பும் அளவுகோல்

மைக்ரோ-கன்ட்ரோலர் செயலாக்கக்கூடிய எத்தனை "போலி" கட்டளையிடுகிறது என்பதை கட்டளை அனுப்பும் பெஞ்ச்மார்க் சோதிக்கிறது. இது முதன்மையாக வன்பொருள் தொடர்பு பொறிமுறையின் சோதனை. சோதனை Console.py கருவியைப் பயன்படுத்தி இயக்கப்படுகிறது (<பிழைத்திருத்தம். Md> இல் விவரிக்கப்பட்டுள்ளது). பின்வருபவை கன்சோல்.பி முனைய சாளரத்தில் வெட்டு மற்றும் ஒட்டுதல்:

```
நேரந்தவறுகை {கடிகாரம் + 2*ஃப்ரீக்} get_uptime
 வெள்ளம் 100000 0.0 பிழைத்திருத்தம்_நாப்
 get_uptime
```

சோதனை முடிந்ததும், இரண்டு "கூடுதல் நேரம்" மறுமொழி செய்திகளில் தெரிவிக்கப்பட்ட கடிகாரங்களுக்கிடையிலான வேறுபாட்டை தீர்மானிக்கவும். நொடிக்கு மொத்த கட்டளைகளின் எண்ணிக்கை பின்னர் `100000 * MCU_FREQUENCY / COCROM_DIFF`.

The USB tests may exceed the CPU capacity of a Raspberry Pi. If running on a Raspberry Pi, Beaglebone, or similar host computer then increase the delay (eg, `DELAY {clock + 20*freq} get_uptime`). Where applicable, the benchmarks below are with console.py running on a desktop class machine with the device connected via a super-speed hub.

The CAN bus tests may saturate the USB host controller of a Raspberry Pi (when testing via a standard gs_usb USB to CAN bus adapter). Where applicable, the CAN bus benchmarks below are with console.py running on a desktop class machine with a USB to CAN bus adapter connected via a super-speed USB hub.

| MCU | விகிதம் | உருவாக்கு | கம்பைலரை உருவாக்குங்கள் |
| --- | --- | --- | --- |
| Atmega2560 (சீரியல்) | பசி | B161A69E | ஏ.வி.ஆர்-சி.சி.சி (சி.சி.சி) 4.8.1 |
| sam3x8e (சீரியல்) | பசி | B161A69E | ARM-NONE-EABI-GCC (ஃபெடோரா 7.1.0-5.FC27) 7.1.0 |
| rp2350 (CAN) | 59K | 17b8ce4c | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| AT90USB1286 (USB) | உங்கள் கொள்ளை | 01D2183F | ஏ.வி.ஆர்-சி.சி.சி (சி.சி.சி) 5.4.0 |
| AR100 (சீரியல்) | 138 கே | 08D037C6 | OR1K-LINUX-MUSL-GCC 9.3.0 |
| SAMD21 (USB) | உங்கள் கீழே | 01D2183F | ARM-NONE-EABI-GCC (ஃபெடோரா 7.4.0-1.FC30) 7.4.0 |
| ப்ரூ (பகிரப்பட்ட நினைவகம்) | 260 கே | C5968A08 | ப்ரூ-சி.சி.சி (சி.சி.சி) 8.0.0 20170530 (சோதனை) |
| STM32F103 (USB) | உங்கள் | 01D2183F | ARM-NONE-EABI-GCC (ஃபெடோரா 7.4.0-1.FC30) 7.4.0 |
| SAM3X8E (USB) | 418 கே | 01D2183F | ARM-NONE-EABI-GCC (ஃபெடோரா 7.4.0-1.FC30) 7.4.0 |
| எல்பிசி 1768 (யூ.எச்.பி) | 534 கே | 01D2183F | ARM-NONE-EABI-GCC (ஃபெடோரா 7.4.0-1.FC30) 7.4.0 |
| எல்பிசி 1769 (யூ.எச்.பி) | 628 கே | 01D2183F | ARM-NONE-EABI-GCC (ஃபெடோரா 7.4.0-1.FC30) 7.4.0 |
| SAM4S8C (யூ.எச்.பி) | 650 கே | 8D4A5C16 | ARM-NONE-EABI-GCC (ஃபெடோரா 7.4.0-1.FC30) 7.4.0 |
| SAMD51 (USB) | 864 கே | 01D2183F | ARM-NONE-EABI-GCC (ஃபெடோரா 7.4.0-1.FC30) 7.4.0 |
| STM32F446 (USB) | 870 கே | 01D2183F | ARM-NONE-EABI-GCC (ஃபெடோரா 7.4.0-1.FC30) 7.4.0 |
| RP2040 (யூ.எச்.பி) | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |
| rp2350 (USB) | 885K | f6718291 | arm-none-eabi-gcc (Fedora 14.1.0-1.fc40) 14.1.0 |

## புரவலன் வரையறைகள்

"தொகுதி பயன்முறை" செயலாக்க பொறிமுறையைப் பயன்படுத்தி புரவலன் மென்பொருளில் நேர சோதனைகளை இயக்க முடியும் (<பிழைத்திருத்தத்தில் விவரிக்கப்பட்டுள்ளது). இது பொதுவாக ஒரு பெரிய மற்றும் சிக்கலான சி-குறியீட்டு கோப்பைத் தேர்ந்தெடுப்பதன் மூலமும், புரவலன் மென்பொருளை செயலாக்க எவ்வளவு நேரம் ஆகும் என்பதை நேரம் செய்வதன் மூலமும் செய்யப்படுகிறது. உதாரணமாக:

```
நேரம் ~/klippy -env/bin/python.
```
