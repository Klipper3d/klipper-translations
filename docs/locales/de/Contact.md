# Kontakt

Dieses Dokument stellt Kontaktinformationen für Klipper zur Verfügung.

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Discord Chat

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

Dieser Server wird von einer Community aus Klipper-Enthusiasten für Diskussionen über Klipper betrieben. Hiermit wird Nutzern ermöglicht, mit anderen in Echtzeit zu chatten.

## Ich habe eine Frage über Klipper

Viele Fragen, die wir erhalten, sind bereits in der [Klipper Dokumentation](Overview.md) beantwortet. Bitte lies zuerst die Dokumentation und folge den Anweisungen in dieser.

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## Ich habe eine Feature-Anfrage

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## Hilfe! Es funktioniert nicht!

Wenn bei dir Probleme auftreten, empfehlen wir, dass du zunächst gründlich die [Klipper-Dokumentation](Overview.md) liest und prüfst, ob alle Schritte richtig befolgt wurden.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## I found a bug in the Klipper software

Klipper ist ein open-source Projekt und wir freuen uns sehr, wenn Mitbearbeiter Fehler in der Software diagnostizieren.

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

Wichtige Informationen werden benötigt, um einen Fehler zu beheben. Bitte befolge die folgenden Schritte:

1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you should reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting.
1. If possible, run an `M112` command immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. Besorgen Sie die Klipper-Protokolldatei des Ereignisses. Die Protokolldatei wurde entworfen, um häufige Fragen der Klipper-Entwickler über die Software und ihre Umgebung zu beantworten (Software Version, Hardware Typ, Konfiguration, Ereignis Timing und Hunderte von anderen Fragen).
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. Copy the log file to your desktop so that it can be attached to an issue report.
   1. Do not modify the log file in any way; do not provide a snippet of the log. Only the full unmodified log file provides the necessary information.
   1. It is a good idea to compress the log file with zip or gzip.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## I am making changes that I'd like to include in Klipper

Klipper is open-source software and we appreciate new contributions.

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
