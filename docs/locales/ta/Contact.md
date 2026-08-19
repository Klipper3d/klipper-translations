# தொடர்பு

இந்த ஆவணம் கிளிப்பருக்கான தொடர்பு தகவல்களை வழங்குகிறது.

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## முரண்பாடு அரட்டை

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

இந்த சேவையகம் கிளிப்பர் பற்றிய விவாதங்களுக்கு அர்ப்பணிக்கப்பட்ட கிளிப்பர் ஆர்வலர்களின் சமூகத்தால் இயக்கப்படுகிறது. நிகழ்நேரத்தில் மற்ற பயனர்களுடன் அரட்டையடிக்க பயனர்களை இது அனுமதிக்கிறது.

## கிளிப்பர் பற்றி எனக்கு ஒரு கேள்வி உள்ளது

நாங்கள் பெறும் பல கேள்விகள் ஏற்கனவே [கிளிப்பர் ஆவணம்] (கண்ணோட்டம். எம்.டி) இல் பதிலளிக்கப்பட்டுள்ளன. தயவுசெய்து ஆவணங்களைப் படித்து, அங்கு வழங்கப்பட்ட திசைகளைப் பின்பற்றவும்.

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## எனக்கு ஒரு அம்ச கோரிக்கை உள்ளது

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## உதவி! இது வேலை செய்யாது!

நீங்கள் சிக்கல்களைச் சந்தித்தால், [கிளிப்பர் ஆவணம்] (கண்ணோட்டம். எம்.டி) கவனமாகப் படித்து, அனைத்து நடவடிக்கைகளும் பின்பற்றப்பட்டுள்ளதா என்பதை இருமுறை சரிபார்க்கவும்.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## கிளிப்பர் மென்பொருளில் ஒரு பிழையைக் கண்டேன்

கிளிப்பர் ஒரு திறந்த மூல திட்டமாகும், மேலும் ஒத்துழைப்பாளர்கள் மென்பொருளில் பிழைகள் கண்டறியும்போது நாங்கள் பாராட்டுகிறோம்.

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

பிழையை சரிசெய்ய முக்கியமான தகவல்கள் தேவைப்படும். தயவுசெய்து இந்த படிகளைப் பின்பற்றவும்:

1. <Https://github.com/klipper3d/klipper> இலிருந்து மாற்றப்படாத குறியீட்டை இயக்குகிறீர்கள் என்பதை உறுதிப்படுத்திக் கொள்ளுங்கள். குறியீடு மாற்றியமைக்கப்பட்டிருந்தால் அல்லது வேறொரு மூலத்திலிருந்து பெறப்பட்டிருந்தால், நீங்கள் <https://github.com/klipper3d/klipper> இலிருந்து மாற்றப்படாத குறியீட்டில் சிக்கலை மீண்டும் உருவாக்க வேண்டும்.
1. முடிந்தால், விரும்பத்தகாத நிகழ்வு ஏற்பட்ட உடனேயே `M112` கட்டளையை இயக்கவும். இது கிளிப்பர் ஒரு "பணிநிறுத்தம் நிலைக்கு" செல்ல காரணமாகிறது, மேலும் இது கூடுதல் பிழைத்திருத்த தகவல்களை பதிவு கோப்பில் எழுதும்.
1. நிகழ்விலிருந்து கிளிப்பர் பதிவு கோப்பைப் பெறுங்கள். மென்பொருள் மற்றும் அதன் சூழல் (மென்பொருள் பதிப்பு, வன்பொருள் வகை, உள்ளமைவு, நிகழ்வு நேரம் மற்றும் நூற்றுக்கணக்கான பிற கேள்விகள்) பற்றி கிளிப்பர் உருவாக்குபவர்கள் வைத்திருக்கும் பொதுவான கேள்விகளுக்கு பதிலளிக்க பதிவு கோப்பு வடிவமைக்கப்பட்டுள்ளது.
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. பதிவு கோப்பை உங்கள் டெச்க்டாப்பில் நகலெடுக்கவும், இதன் மூலம் அது வெளியீட்டு அறிக்கையுடன் இணைக்கப்படலாம்.
   1. பதிவு கோப்பை எந்த வகையிலும் மாற்ற வேண்டாம்; பதிவின் துணுக்கை வழங்க வேண்டாம். முழு மாற்றப்படாத பதிவு கோப்பு மட்டுமே தேவையான தகவல்களை வழங்குகிறது.
   1. பதிவு கோப்பை ZIP அல்லது GZIP உடன் சுருக்குவது நல்லது.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## நான் கிளிப்பரில் சேர்க்க விரும்பும் மாற்றங்களைச் செய்கிறேன்

கிளிப்பர் திறந்த மூல மென்பொருள் மற்றும் புதிய பங்களிப்புகளை நாங்கள் பாராட்டுகிறோம்.

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
