# நிறுவல்

These instructions assume the software will run on a Linux-based host running a Klipper-compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian-based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions, host relates to the Linux device and mcu relates to the printer board. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## கிளிப்பர் உள்ளமைவு கோப்பைப் பெறுங்கள்

பெரும்பாலான கிளிப்பர் அமைப்புகள் "அச்சுப்பொறி உள்ளமைவு கோப்பு" அச்சுப்பொறியால் தீர்மானிக்கப்படுகின்றன, அவை ஓச்டில் சேமிக்கப்படும். இலக்கு அச்சுப்பொறிக்கு ஒத்த "அச்சுப்பொறி" முன்னொட்டுடன் தொடங்கும் கோப்பிற்கான கிளிப்பர் [கட்டமைப்பு அடைவு] (../ கட்டமைப்பு/) இல் பார்ப்பதன் மூலம் பொருத்தமான உள்ளமைவு கோப்பைக் காணலாம். கிளிப்பர் உள்ளமைவு கோப்பில் நிறுவலின் போது தேவைப்படும் அச்சுப்பொறி பற்றிய தொழில்நுட்ப தகவல்கள் உள்ளன.

கிளிப்பர் கட்டமைப்பு கோப்பகத்தில் பொருத்தமான அச்சுப்பொறி உள்ளமைவு கோப்பு இல்லையென்றால், அச்சுப்பொறி உற்பத்தியாளரின் வலைத்தளத்தைத் தேட முயற்சிக்கவும், அவற்றில் பொருத்தமான கிளிப்பர் உள்ளமைவு கோப்பு இருக்கிறதா என்று பார்க்கவும்.

அச்சுப்பொறிக்கான உள்ளமைவு கோப்பைக் காண முடியாவிட்டால், ஆனால் அச்சுப்பொறி கட்டுப்பாட்டு பலகையின் வகை அறியப்பட்டால், "பொதுவான-" முன்னொட்டுடன் தொடங்கி பொருத்தமான [கட்டமைப்பு கோப்பு] (../ கட்டமைப்பு/) ஐத் தேடுங்கள். இந்த எடுத்துக்காட்டு அச்சுப்பொறி பலகை கோப்புகள் ஆரம்ப நிறுவலை வெற்றிகரமாக முடிக்க அனுமதிக்க வேண்டும், ஆனால் முழு அச்சுப்பொறி செயல்பாட்டைப் பெற சில தனிப்பயனாக்கம் தேவைப்படும்.

புதிதாக ஒரு புதிய அச்சுப்பொறி உள்ளமைவை வரையறுக்கவும் முடியும். இருப்பினும், இதற்கு அச்சுப்பொறி மற்றும் அதன் மின்னணுவியல் பற்றிய குறிப்பிடத்தக்க தொழில்நுட்ப அறிவு தேவைப்படுகிறது. பெரும்பாலான பயனர்கள் பொருத்தமான உள்ளமைவு கோப்புடன் தொடங்க பரிந்துரைக்கப்படுகிறது. புதிய தனிப்பயன் அச்சுப்பொறி உள்ளமைவு கோப்பை உருவாக்கினால், மிக நெருக்கமான எடுத்துக்காட்டு [கட்டமைப்பு கோப்பு] (../ config/) உடன் தொடங்கி மேலும் தகவலுக்கு கிளிப்பர் [கட்டமைப்பு குறிப்பு] (config_reference.md) ஐப் பயன்படுத்தவும்.

## கிளிப்பருடன் தொடர்புகொள்வது

கிளிப்பர் ஒரு 3D அச்சுப்பொறி ஃபார்ம்வேர், எனவே பயனருடன் தொடர்பு கொள்ள சில வழி தேவை.

தற்போது சிறந்த தேர்வுகள் [மூன்ராகேக்கர் வலை ஏபிஐ] (https://monraker.readthedocs.io/) மூலம் தகவல்களை மீட்டெடுக்கும் முன் முனைகள் மற்றும் [ஆக்டோப்ரின்ட்] (https://octoprint.org/) பயன்படுத்த விருப்பமும் உள்ளது கிளிப்பரைக் கட்டுப்படுத்த.

தேர்வு எதைப் பயன்படுத்த வேண்டும் என்பது பயனரின் தான், ஆனால் அடிப்படை கிளிப்பர் எல்லா நிகழ்வுகளிலும் ஒரே மாதிரியாக இருக்கும். கிடைக்கக்கூடிய விருப்பங்களை ஆராய்ச்சி செய்து தகவலறிந்த முடிவை எடுக்க பயனர்களை நாங்கள் ஊக்குவிக்கிறோம்.

## எச்.பி.சி.க்கு ஒரு OS படத்தைப் பெறுதல்

There are many ways to obtain an OS image for Klipper for SBC use, most depend on what front end you wish to use. Some manufacturers of these SBC boards also provide their own Klipper-centric images.

The two main Moonraker-based front ends are [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/), the latter of which has a premade install image ["MainsailOS"](https://docs-os.mainsail.xyz/), this has the option for Raspberry Pi and some OrangePi variants.

KIAUH (கிளிப்பர் நிறுவல் மற்றும் புதுப்பிப்பு உதவியாளர்) வழியாக FILIGDD ஐ நிறுவலாம், இது கீழே விளக்கப்பட்டுள்ளது மற்றும் எல்லாவற்றிற்கும் 3 வது தரப்பு நிறுவி கிளிப்பர் ஆகும்.

பிரபலமான ஆக்டோபி படம் வழியாக அல்லது கியாவ் வழியாக ஆக்டோப்ரிண்ட் நிறுவப்படலாம், இந்த செயல்முறை <octoprint.md> இல் விளக்கப்பட்டுள்ளது

## கியாவ் வழியாக நிறுவுகிறது

Normally you would start with a base image for your SBC, RPiOS Lite for example, or in the case of an x86 Linux device, Ubuntu Server. Please note that Desktop variants are not recommended due to certain helper programs that can stop some Klipper functions from working and even mask access to some printer boards.

KIAUH can be used to install Klipper and its associated programs on a variety of Linux-based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

## மைக்ரோ-கன்ட்ரோலரை உருவாக்கி ஒளிரச் செய்தல்

மைக்ரோ-கன்ட்ரோலர் குறியீட்டை தொகுக்க, உங்கள் புரவலன் சாதனத்தில் இந்த கட்டளைகளை இயக்குவதன் மூலம் தொடங்கவும்:

```
cd ~/klipper/
make menuconfig
```

[அச்சுப்பொறி உள்ளமைவு கோப்பின்] மேலே உள்ள கருத்துகள் (#A-KLIPPER-CONFIGURATION-FILE ஐப் பெறுங்கள்) "மெனுகான்ஃபிக் செய்யுங்கள்" போது அமைக்க வேண்டிய அமைப்புகளை விவரிக்க வேண்டும். ஒரு வலை உலாவி அல்லது உரை திருத்தியில் கோப்பைத் திறந்து, கோப்பின் மேற்புறத்தில் இந்த வழிமுறைகளைத் தேடுங்கள். பொருத்தமான "மெனுகான்ஃபிக்" அமைப்புகள் கட்டமைக்கப்பட்டவுடன், வெளியேற "Q" ஐ அழுத்தவும், பின்னர் சேமிக்க "ஒய்" ஐ அழுத்தவும். பின்னர் ஓடு:

```
உருவாக்கு
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board, then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

இல்லையெனில், அச்சுப்பொறி கட்டுப்பாட்டு பலகையை "ஃபிளாச்" செய்ய பின்வரும் படிகள் பெரும்பாலும் பயன்படுத்தப்படுகின்றன. முதலாவதாக, மைக்ரோ-கன்ட்ரோலருடன் இணைக்கப்பட்ட தொடர் துறைமுகத்தை தீர்மானிக்க வேண்டியது தேவை. பின்வருவனவற்றை இயக்கவும்:

```
ls/dev/serial/by-id/*
```

இது பின்வருவனவற்றைப் போன்ற ஒன்றைப் புகாரளிக்க வேண்டும்:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

ஒவ்வொரு அச்சுப்பொறியும் அதன் தனித்துவமான சீரியல் துறைமுகம் பெயரைக் கொண்டிருப்பது பொதுவானது. மைக்ரோ-கன்ட்ரோலரை ஒளிரும் போது இந்த தனித்துவமான பெயர் பயன்படுத்தப்படும். மேலே உள்ள வெளியீட்டில் பல கோடுகள் இருக்கலாம் - அப்படியானால், மைக்ரோ -கன்ட்ரோலருடன் தொடர்புடைய வரியைத் தேர்வுசெய்க. பல உருப்படிகள் பட்டியலிடப்பட்டு, தேர்வு தெளிவற்றதாக இருந்தால், பலகையை அவிழ்த்துவிட்டு மீண்டும் கட்டளையை இயக்கினால், காணாமல் போன உருப்படி உங்கள் அச்சு பலகையாக இருக்கும் (மேலும் தகவலுக்கு [கேள்விகள்] (கேள்விகள்) (கேள்விகள்) ).

For common micro-controllers with STM32 or clone chips, LPC chips and others, it is usual that these need an initial Klipper flash via SD card.

When flashing with this method, it is important to make sure that the print board is not connected with USB to the host, due to some boards being able to feed power back to the board and stopping a flash from occurring.

ATMEGA சில்லுகளைப் பயன்படுத்தி பொதுவான மைக்ரோ-கன்ட்ரோலர்களுக்கு, எடுத்துக்காட்டாக 2560, குறியீட்டை ஒத்த ஒன்றைக் கொண்டு ஒளிரச் செய்யலாம்:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

அச்சுப்பொறியின் தனித்துவமான சீரியல் துறைமுகம் பெயருடன் Flash_device ஐ புதுப்பிக்க மறக்காதீர்கள்.

RP2040 சில்லுகளைப் பயன்படுத்தும் பொதுவான மைக்ரோ-கன்ட்ரோலர்களுக்கு, குறியீட்டை ஒத்த ஒன்றைக் கொண்டு ஒளிரச் செய்யலாம்:

```
சூடோ பணி கிளிப்பர் நிறுத்தம்
 ஃப்ளாச் ஃப்ளாச்_டெவிச் = முதலில் செய்யுங்கள்
 சூடோ பணி கிளிப்பர் தொடக்க
```

இந்த செயல்பாட்டிற்கு முன் RP2040 சில்லுகள் துவக்க பயன்முறையில் வைக்கப்பட வேண்டும் என்பதை கவனத்தில் கொள்ள வேண்டும்.

## வெட்டுக்களை உள்ளமைக்கும்

அடுத்த கட்டம் [அச்சுப்பொறி உள்ளமைவு கோப்பை] (#a-klipper-configuration-file) ஓச்டுக்கு நகலெடுப்பது.

Arguably the easiest way to set the Klipper configuration file is using the built-in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

மற்றொரு விருப்பம் என்னவென்றால், "SCP" மற்றும்/அல்லது "SFTP" நெறிமுறைகளில் கோப்புகளைத் திருத்துவதை ஆதரிக்கும் டெச்க்டாப் எடிட்டரைப் பயன்படுத்துவது. இதை ஆதரிக்கும் இலவசமாக கிடைக்கக்கூடிய கருவிகள் உள்ளன (எ.கா., நோட்பேட் ++, வின்ச்கிபி மற்றும் சைபர்டக்). எடிட்டரில் அச்சுப்பொறி கட்டமைப்பு கோப்பை ஏற்றவும், பின்னர் அதை PI பயனரின் வீட்டு கோப்பகத்தில் (IE, /home/pi/printer.cfg) "அச்சுப்பொறி. CFG" என்ற கோப்பாக சேமிக்கவும்.

Alternatively, one can also copy and edit the file directly on the host via SSH. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printed.cfg
 நானோ ~/அச்சுப்பொறி
```

ஒவ்வொரு அச்சுப்பொறியும் மைக்ரோ-கன்ட்ரோலருக்கு அதன் தனித்துவமான பெயரைக் கொண்டிருப்பது பொதுவானது. கிளிப்பரை ஒளிரச் செய்தபின் பெயர் மாறக்கூடும், எனவே இந்த படிகள் ஒளிரும் போது அவை ஏற்கனவே செய்யப்பட்டிருந்தாலும் மீண்டும் மீண்டும் இயக்கவும். ரன்:

```
ls/dev/serial/by-id/*
```

இது பின்வருவனவற்றைப் போன்ற ஒன்றைப் புகாரளிக்க வேண்டும்:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

பின்னர் கட்டமைப்பு கோப்பை தனித்துவமான பெயருடன் புதுப்பிக்கவும். எடுத்துக்காட்டாக, இதேபோன்ற ஒன்றைக் காண `[MCU]` பகுதியைப் புதுப்பிக்கவும்:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file, it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report that the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

அச்சுப்பொறி கட்டமைப்பு கோப்பைத் தனிப்பயனாக்கும்போது, க்ளிப்பர் ஒரு உள்ளமைவு பிழையைப் புகாரளிப்பது வழக்கமல்ல. பிழை ஏற்பட்டால், அச்சுப்பொறி கட்டமைப்பு கோப்பில் தேவையான திருத்தங்களைச் செய்து, அச்சுப்பொறி தயாராக இருப்பதாக "நிலை" புகாரளிக்கும் வரை "மறுதொடக்கம்" ஐ வழங்கவும்.

Klipper reports error messages via the command console and pop-ups in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located at `~/printer_data/logs/klippy.log`.

அச்சுப்பொறி தயாராக இருப்பதாக கிளிப்பர் புகாரளித்த பிறகு, கட்டமைப்பு கோப்பில் உள்ள வரையறைகளில் சில அடிப்படை சோதனைகளைச் செய்ய [கட்டமைப்பு காசோலை ஆவணம்] (config_checks.md) க்குச் செல்லவும். பிற தகவல்களுக்கு முதன்மையான [ஆவணப்படுத்தல் குறிப்பு] (கண்ணோட்டம். எம்.டி) ஐப் பார்க்கவும்.
