# За контакт

Този документ предоставя информация за контакт с Klipper.

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Чат на Discord

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

Този сървър се управлява от общност от ентусиасти на Klipper, посветена на дискусии за Klipper. Той позволява на потребителите да разговарят с други потребители в реално време.

## Имам въпрос за Klipper

На много от въпросите, които получаваме, вече е отговорено в [документацията на Klipper](Overview.md). Моля, не забравяйте да прочетете документацията и да следвате указанията, дадени в нея.

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## Имам заявка за функция

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## Помощ! Не работи!

Ако имате проблеми, препоръчваме ви да прочетете внимателно [документацията на Klipper](Overview.md) и да проверите отново дали всички стъпки са спазени.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## Открих грешка в софтуера на Klipper

Klipper е проект с отворен код и ние оценяваме, когато сътрудниците ни диагностицират грешки в софтуера.

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

Има важна информация, която ще бъде необходима за отстраняването на дадена грешка. Моля, следвайте следните стъпки:

1. Уверете се, че изпълнявате немодифициран код от <https://github.com/Klipper3d/klipper>. Ако кодът е бил модифициран или е получен от друг източник, трябва да възпроизведете проблема на немодифицирания код от <https://github.com/Klipper3d/klipper>, преди да докладвате.
1. Ако е възможно, изпълнете командата `M112` веднага след настъпването на нежеланото събитие. Това кара Klipper да премине в "състояние на изключване" и ще доведе до запис на допълнителна информация за отстраняване на грешки в регистрационния файл.
1. Получаване на регистрационния файл на Klipper от събитието. Файлът на дневника е разработен така, че да отговаря на често срещани въпроси на разработчиците на Klipper относно софтуера и неговата среда (версия на софтуера, тип на хардуера, конфигурация, време на събитието и стотици други въпроси).
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. Копирайте регистрационния файл на работния си плот, за да може да бъде приложен към доклад за проблем.
   1. Не променяйте файла с дневника по никакъв начин; не предоставяйте откъс от дневника. Само пълният немодифициран регистрационен файл предоставя необходимата информация.
   1. Добре е да компресирате регистрационния файл с помощта на zip или gzip.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## Правя промени, които бих искал да включа в Klipper

Klipper е софтуер с отворен код и ние се радваме на нов принос.

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
