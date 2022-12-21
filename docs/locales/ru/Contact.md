# контакт

В этом документе содержится контактная информация Klipper.

1. [Community Forum](#community-forum)
1. [Discord Chat](#discord-chat)
1. [У меня есть вопрос о Klipper](#i-have-a-question-about-klipper)
1. [У меня есть запрос на функцию](#i-have-a-feature-request)
1. [Помогите! Это не работает!](#help-it-doesnt-work)
1. [I found a bug in the Klipper software](#i-found-a-bug-in-the-klipper-software)
1. [Я вношу изменения, которые хотел бы включить в Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)
1. [Klipper github](#klipper-github)

## Community Forum

Существует [Klipper Community Discourse server](https://community.klipper3d.org) для обсуждения Клиппера.

## Discord Chat

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>.

Этот сервер управляется сообществом энтузиастов Клиппера, посвященным обсуждениям Клиппера. Он позволяет пользователям общаться с другими пользователями в режиме реального времени.

## У меня есть вопрос о Клиппере

Many questions we receive are already answered in the [Klipper documentation](Overview.md). Please be sure to to read the documentation and follow the directions provided there.

It is also possible to search for similar questions in the [Klipper Community Forum](#community-forum).

Если вы хотите поделиться своими знаниями и опытом с другими пользователями Klipper, то вы можете присоединиться к [Klipper Community Forum](#community-forum) или [Klipper Discord Chat](#discord-chat). Оба сообщества - это сообщества, где пользователи Klipper могут обсуждать Klipper с другими пользователями.

Многие вопросы, которые мы получаем, являются общими вопросами 3d-печати, не относящимися к Klipper. Если у вас есть общий вопрос или вы испытываете общие проблемы с печатью, то, скорее всего, вы получите лучший ответ, задав вопрос на общем форуме по 3d-печати или на форуме, посвященном оборудованию вашего принтера.

## У меня есть просьба о возможности

Для всех новых функций требуется кто-то заинтересованный и способный реализовать эту функцию. Если вы заинтересованы в помощи в реализации или тестировании новой функции, вы можете поискать текущие разработки на [Klipper Community Forum](#community-forum). Существует также [Klipper Discord Chat](#discord-chat) для обсуждений между участниками.

## Помогите! Не работает!

К сожалению, мы получаем гораздо больше запросов о помощи, чем можем ответить. Большинство сообщений о проблемах, которые мы видим, в конечном итоге сводятся к следующему:

1. Незначительные ошибки в оборудовании, или
1. Not following all the steps described in the Klipper documentation.

If you are experiencing problems we recommend you carefully read the [Klipper documentation](Overview.md) and double check that all steps were followed.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then you will likely get a better response by searching in a general 3d-printing forum or in a forum dedicated to your printer hardware.

It is also possible to search for similar issues in the [Klipper Community Forum](#community-forum).

Если вы хотите поделиться своими знаниями и опытом с другими пользователями Klipper, то вы можете присоединиться к [Klipper Community Forum](#community-forum) или [Klipper Discord Chat](#discord-chat). Оба сообщества - это сообщества, где пользователи Klipper могут обсуждать Klipper с другими пользователями.

## I found a bug in the Klipper software

Klipper - это проект с открытым исходным кодом, и мы ценим, когда соавторы диагностируют ошибки в программном обеспечении.

Problems should be reported in the [Klipper Community Forum](#community-forum).

There is important information that will be needed in order to fix a bug. Please follow these steps:

1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you should reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting.
1. If possible, run an `M112` command immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. Obtain the Klipper log file from the event. The log file has been engineered to answer common questions the Klipper developers have about the software and its environment (software version, hardware type, configuration, event timing, and hundreds of other questions).
   1. The Klipper log file is located in `/tmp/klippy.log` on the Klipper "host" computer (the Raspberry Pi).
   1. An "scp" or "sftp" utility is needed to copy this log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). If using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or `parent folder` until you get to the root directory, click on the `tmp` folder, and then select the `klippy.log` file.
   1. Copy the log file to your desktop so that it can be attached to an issue report.
   1. Do not modify the log file in any way; do not provide a snippet of the log. Only the full unmodified log file provides the necessary information.
   1. It is a good idea to compress the log file with zip or gzip.
1. Open a new topic on the [Klipper Community Forum](#community-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## I am making changes that I'd like to include in Klipper

Klipper is open-source software and we appreciate new contributions.

New contributions (for both code and documentation) are submitted via Github Pull Requests. See the [CONTRIBUTING document](CONTRIBUTING.md) for important information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Community Forum](#community-forum) or on the [Klipper Community Discord](#discord-chat).

## Klipper github

Klipper github may be used by contributors to share the status of their work to improve Klipper. It is expected that the person opening a github ticket is actively working on the given task and will be the one performing all the work necessary to accomplish it. The Klipper github is not used for requests, nor to report bugs, nor to ask questions. Use the [Klipper Community Forum](#community-forum) or the [Klipper Community Discord](#discord-chat) instead.
