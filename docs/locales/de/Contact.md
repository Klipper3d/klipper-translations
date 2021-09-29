# Contact

Dieses Dokument stellt Kontaktinformationen für Klipper zur Verfügung.

1. [Community Forum](#community-forum)
1. [Discord Chat](#discord-chat)
1. [Ich habe eine Frage bzgl. Klipper](#i-have-a-question-about-klipper)
1. [Ich habe eine Feature-Anfrage](#i-have-a-feature-request)
1. [Hilfe! Es funktioniert nicht!](#help-it-doesnt-work)
1. [Ich habe einen Defekt in der Klipper-Software diagnostiziert](#i-have-diagnosed-a-defect-in-the-klipper-software)
1. [Ich mache Änderungen, die ich gerne in Klipper einbringen möchte](#i-am-making-changes-that-id-like-to-include-in-klipper)

## Community Forum

Es gibt einen [Klipper Community Diskurs-Server](https://community.klipper3d.org) für Diskussionen über Klipper.

## Discord Chat

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>.

Dieser Server wird von einer Community aus Klipper-Enthusiasten für Diskussionen über Klipper betrieben. Hiermit wird Nutzern ermöglicht, mit anderen in Echtzeit zu chatten.

## Ich habe eine Frage über Klipper

Viele Fragen, die wir erhalten, sind bereits in der [Klipper Dokumentation](Overview.md) beantwortet. Bitte lies zuerst die Dokumentation und folge den Anweisungen in dieser.

Es ist auch möglich, nach ähnlichen Fragen im [Klipper Community Forum](#community-forum) zu suchen.

Wenn du Interesse daran hast, dein Wissen und deine Erfahrung mit anderen Klipper-Nutzern zu teilen, kannst du dem [Klipper Community Forum](#community-forum) oder dem [Klipper Discord Chat](#discord-chat) beitreten. Beide sind Communities, wo Klipper-Nutzer mit anderen über Klipper diskutieren können.

Viele Fragen, die wir erhalten, sind generelle 3D-Druck-Fragen, die nicht Klipper-spezifisch sind. Wenn Du eine generelle Frage hast oder generelle Probleme auftreten, erhältst du wahrscheinlich eine bessere Antwort, indem du in generellen 3D-Druck-Foren oder einem Forum, welches auf deine Druckhardware spezifiziert ist, fragst.

Öffne kein Klipper-GitHub-Issue, um eine Frage zu stellen.

## Ich habe eine Feature-Anfrage

Alle neuen Features benötigen eine Person, die sich für dieses interessiert und implementiert. Wenn du Interesse daran hast, ein neues Feature zu implementieren oder zu testen, kannst du nach sich im Entwicklungsstadium befindenen Features im [Klipper Community Forum](#community-forum) erkundigen. Ebenfalls gibt es einen [Klipper Discord Chat](#discord-chat) für Diskussionen zwischen Mitbearbeitern.

Öffne kein Klipper-GitHub-Issue, um ein neues Feature anzufragen.

## Hilfe! Es funktioniert nicht!

Leider erhalten wir viel mehr Hilfeanfragen, als wir beantworten können. Die meisten gemeldeten Probleme führen auf folgende Ursachen hin:

1. Kleine Fehler in der Hardware, oder
1. Das Nichtbefolgen aller Schritte, wie sie in der Klipper-Dokumentation beschrieben sind.

Wenn bei dir Probleme auftreten, empfehlen wir, dass du zunächst gründlich die [Klipper-Dokumentation](Overview.md) liest und prüfst, ob alle Schritte richtig befolgt wurden.

Wenn bei dir Druckprobleme auftreten, empfehlen wir, dass du zunächst gründlich deine Druckerhardware (alle Verbindungen, Kabel, Schrauben, etc.) prüfst und sicherstellst, dass nichts abnormal ist. Die meisten Druckprobleme hängen nicht mit der Klipper-Software zusammen. Wenn du ein Problem mit der Druckerhardware finden solltest, kann dir höchstwahrscheinlich eine bessere Antwort geliefert werden, wenn du in einem generellen 3D-Druck-Forum oder in einem Forum, was auf deinen Drucker spezialisiert ist, fragst.

Es ist außerdem möglich, das [Klipper Community Forum](#community-forum) nach ähnlichen Fragen bzw. Problemen zu durchsuchen.

Wenn du Interesse daran hast, dein Wissen und deine Erfahrung mit anderen Klipper-Nutzern zu teilen, kannst du dem [Klipper Community Forum](#community-forum) oder dem [Klipper Discord Chat](#discord-chat) beitreten. Beide sind Communities, wo Klipper-Nutzer mit anderen über Klipper diskutieren können.

Öffne kein Klipper-GitHub-Issue um Hilfe anzufragen.

## Ich habe einen Defekt in der Klipper-Software diagnostiziert

Klipper ist ein open-source Projekt und wir freuen uns sehr, wenn Mitbearbeiter Fehler in der Software diagnostizieren.

Wichtige Informationen werden benötigt, um einen Fehler zu beheben. Bitte befolge die folgenden Schritte:

1. Stell sicher, dass der Fehler in der Klipper-Software liegt. Wenn du denkst "Ich kann nicht herausfinden, warum das so ist, also ist es ein Klipper-Fehler", dann **öffne kein** GitHub-Issue. In dem Fall sollte dir zunächst jemand interessiertes und fähiges dabei helfen, die Wurzel des Fehlers zu finden. Wenn du deinen Fortschritt bei der Forschung nach der Wurzel teilen willst oder prüfen willst, ob andere Benutzer ein ähnliches Problem haben, kannst du das [Klipper Community Forum](#community-forum) durschsuchen.
1. Make sure you are running unmodified code from <https://github.com/KevinOConnor/klipper>. If the code has been modified or is obtained from another source, then you will need to reproduce the problem on the unmodified code from <https://github.com/KevinOConnor/klipper> prior to reporting an issue.
1. Wenn möglich, setze einen `M112`-Befehl im OctoPrint-Terminalfenster direkt nach dem Auftreten des Fehlers ab. Dies setzt Klipper in einen heruntergefahrenen Status, welcher weitere Debugginginformationen in die Logdatei schreibt.
1. Obtain the Klipper log file from the event. The log file has been engineered to answer common questions the Klipper developers have about the software and its environment (software version, hardware type, configuration, event timing, and hundreds of other questions).
   1. The Klipper log file is located in `/tmp/klippy.log` on the Klipper "host" computer (the Raspberry Pi).
   1. An "scp" or "sftp" utility is needed to copy this log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). If using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or `parent folder` until you get to the root directory, click on the `tmp` folder, and then select the `klippy.log` file.
   1. Copy the log file to your desktop so that it can be attached to an issue report.
   1. Do not modify the log file in any way; do not provide a snippet of the log. Only the full unmodified log file provides the necessary information.
   1. If the log file is very large (eg, greater than 2MB) then one may need to compress the log with zip or gzip.

   1. Open a new github issue at <https://github.com/KevinOConnor/klipper/issues> and provide a clear description of the problem. The Klipper developers need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The Klipper log file **must be attached** to that ticket:![attach-issue](img/attach-issue.png)

## I am making changes that I'd like to include in Klipper

Klipper is open-source software and we appreciate new contributions.

New contributions (for both code and documentation) are submitted via Github Pull Requests. See the [CONTRIBUTING document](CONTRIBUTING.md) for important information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Community Forum](#community-forum) or on the [Klipper Community Discord](#discord-chat). If you would like to provide an update on your current progress then you can open a Github issue with the location of your code, an overview of the changes, and a description of its current status.
