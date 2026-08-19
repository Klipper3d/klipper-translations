# контакт

В этом документе содержится контактная информация Klipper.

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Чат Discord

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

Этот сервер управляется сообществом энтузиастов Клиппера, посвященным обсуждениям Клиппера. Он позволяет пользователям общаться с другими пользователями в режиме реального времени.

## У меня есть вопрос о Клиппере

Ответы на многие вопросы, которые мы получаем, уже есть в [документации Klipper](Overview.md). Пожалуйста, обязательно прочитайте документацию и следуйте приведенным в ней указаниям.

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## У меня есть просьба о возможности

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## Помогите! Не работает!

Если у вас возникли проблемы, мы рекомендуем внимательно прочитать документацию [Klipper documentation](Overview.md) и еще раз проверить, все ли шаги были выполнены.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## Я нашел ошибку в программном обеспечении Klipper

Klipper - это проект с открытым исходным кодом, и мы ценим, когда соавторы диагностируют ошибки в программном обеспечении.

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

Для исправления ошибки потребуется важная информация. Пожалуйста, выполните следующие действия:

1. Убедитесь, что вы выполняете немодифицированный код из <https://github.com/Klipper3d/klipper>. Если код был модифицирован или получен из другого источника, то перед сообщением о проблеме следует воспроизвести ее на немодифицированном коде из <https://github.com/Klipper3d/klipper>.
1. Если есть возможность, сразу после наступления нежелательного события выполните команду `M112`. Это заставит Klipper перейти в "состояние выключения" и приведет к записи дополнительной отладочной информации в файл журнала.
1. Получите файл журнала Klipper по данному событию. В журнале содержатся ответы на часто задаваемые разработчиками Klipper вопросы о программе и ее окружении (версия программы, тип оборудования, конфигурация, время наступления события и сотни других вопросов).
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. Скопируйте файл журнала на рабочий стол, чтобы его можно было прикрепить к отчету о проблеме.
   1. Не модифицируйте файл журнала каким-либо образом; не предоставляйте фрагмент журнала. Только полный немодифицированный файл журнала содержит необходимую информацию.
   1. Неплохо сжать файл журнала с помощью zip или gzip.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## Я вношу изменения, которые хотел бы включить в Klipper

Klipper - это программное обеспечение с открытым исходным кодом, и мы ценим новые вклады.

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
