# Підтримка

Цей документ містить контактну інформацію Klipper.

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Discord чат

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

Цим сервером керує спільнота ентузіастів Klipper, які займаються обговореннями щодо Klipper. Це дозволяє користувачам спілкуватися з іншими користувачами в режимі реального часу.

## У мене є запитання щодо Klipper

На багато запитань, які ми отримуємо, уже є відповіді в [документації Klipper](Overview.md). Обов’язково прочитайте документацію та дотримуйтесь наведених там вказівок.

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## У мене є запит на функцію

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## Допомога Не працює!

Якщо ви відчуваєте проблеми, ми рекомендуємо вам уважно ознайомитися з документацією [Кліппер](Overview.md) і подвійною перевіркою, яку слід дотримуватись всі кроки.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## Я знайшов помилку в програмі Klipper

Klipper - це відкритий проект і ми цінуємо, коли колеги діагностують помилки в програмному забезпеченні.

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

Важлива інформація, яка буде потрібна для виправлення помилки. Будь ласка, заповніть ці дії:

1. Переконайтеся, що ви працюєте з кодом <https://github.com/Klipper3d/klipper>. Якщо код був модифікований або отриманий з іншого джерела, то слід відтворити проблему на неможливому коді з <https://github.com/Klipper3d/klipper> до звітності.
1. Якщо це можливо, запустіть команду `M112` відразу після небажаної події. Це викликає Klipper, щоб перейти в "пошуковий стан" і це призведе до додаткового видалення інформації, яка буде записана до файлу журналу.
1. Зберігати файл журналу Klipper з заходу. Файл журналу було розроблено для відповіді на загальні питання розробникам Klipper про програмне забезпечення та його навколишнє середовище (версія програмного забезпечення, тип обладнання, конфігурація, термін дії та сотні інших питань).
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. Скопіюйте файл журналу на робочий стіл, щоб він був прикріплений до звіту про проблему.
   1. Не модифікувати файл журналу будь-яким чином; не надавати хіппе журналу. Тільки повністю неможливий файл журналу забезпечує необхідну інформацію.
   1. Це хороша ідея для стиснення файлу з zip або gzip.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## Я зроблю зміни, які я хотів би включати в Klipper

Klipper є відкритим програмним забезпеченням і ми цінуємо нові внески.

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
