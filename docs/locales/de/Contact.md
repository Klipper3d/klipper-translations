# Kontakt

Dieses Dokument stellt Kontaktinformationen für Klipper zur Verfügung.

## Discourse-Forum

Es gibt einen [Klipper-Community-Discourse-Server](https://community.klipper3d.org) für Diskussionen im "Forum"-Stil rund um Klipper. Beachten Sie, dass Discourse nicht Discord ist.

## Discord Chat

Es gibt einen speziell für Klipper eingerichteten Discord-Server unter: <https://discord.klipper3d.org>. Beachten Sie, dass Discord nicht Discourse ist.

Dieser Server wird von einer Community aus Klipper-Enthusiasten für Diskussionen über Klipper betrieben. Hiermit wird Nutzern ermöglicht, mit anderen in Echtzeit zu chatten.

## Ich habe eine Frage über Klipper

Viele Fragen, die wir erhalten, sind bereits in der [Klipper Dokumentation](Overview.md) beantwortet. Bitte lies zuerst die Dokumentation und folge den Anweisungen in dieser.

Es ist auch möglich, im [Klipper-Discourse-Forum](#discourse-forum) nach ähnlichen Fragen zu suchen.

Wenn Sie Interesse daran haben, Ihr Wissen und Ihre Erfahrung mit anderen Klipper-Anwendern zu teilen, können Sie dem [Klipper-Discourse-Forum](#discourse-forum) oder dem [Klipper-Discord-Chat](#discord-chat) beitreten. Beides sind Communities, in denen Klipper-Anwender sich mit anderen Anwendern über Klipper austauschen können.

Haben Sie eine allgemeine Frage oder allgemeine Druckprobleme, ziehen Sie auch ein allgemeines 3D-Druck-Forum oder ein auf die jeweilige Druckerhardware spezialisiertes Forum in Betracht.

## Ich habe eine Feature-Anfrage

Für jede neue Funktion wird jemand benötigt, der daran interessiert und in der Lage ist, sie umzusetzen. Wenn Sie daran interessiert sind, bei der Implementierung oder dem Testen einer neuen Funktion zu helfen, können Sie im [Klipper-Discourse-Forum](#discourse-forum) nach laufenden Entwicklungen suchen. Für Diskussionen zwischen Mitwirkenden gibt es außerdem den [Klipper-Discord-Chat](#discord-chat).

## Hilfe! Es funktioniert nicht!

Wenn bei dir Probleme auftreten, empfehlen wir, dass du zunächst gründlich die [Klipper-Dokumentation](Overview.md) liest und prüfst, ob alle Schritte richtig befolgt wurden.

Falls Sie ein Druckproblem haben, empfehlen wir, die Druckerhardware sorgfältig zu überprüfen (alle Verbindungen, Kabel, Schrauben usw.) und sicherzustellen, dass nichts ungewöhnlich ist. Die meisten Druckprobleme stehen nach unserer Erfahrung nicht im Zusammenhang mit der Klipper-Software. Finden Sie ein Problem an der Druckerhardware, ziehen Sie in Betracht, allgemeine 3D-Druck-Foren oder auf die jeweilige Druckerhardware spezialisierte Foren zu durchsuchen.

Es ist auch möglich, im [Klipper-Discourse-Forum](#discourse-forum) nach ähnlichen Problemen zu suchen.

Wenn Sie Interesse daran haben, Ihr Wissen und Ihre Erfahrung mit anderen Klipper-Anwendern zu teilen, können Sie dem [Klipper-Discourse-Forum](#discourse-forum) oder dem [Klipper-Discord-Chat](#discord-chat) beitreten. Beides sind Communities, in denen Klipper-Anwender sich mit anderen Anwendern über Klipper austauschen können.

## Ich habe einen Fehler in der Klipper-Software gefunden

Klipper ist ein open-source Projekt und wir freuen uns sehr, wenn Mitbearbeiter Fehler in der Software diagnostizieren.

Probleme sollten im [Klipper-Discourse-Forum](#discourse-forum) gemeldet werden.

Wichtige Informationen werden benötigt, um einen Fehler zu beheben. Bitte befolge die folgenden Schritte:

1. Stellen Sie sicher, dass Sie unveränderten Code von <https://github.com/Klipper3d/klipper> verwenden. Wurde der Code verändert oder stammt er aus einer anderen Quelle, sollten Sie das Problem vor der Meldung mit dem unveränderten Code von <https://github.com/Klipper3d/klipper> reproduzieren.
1. Führen Sie nach Möglichkeit unmittelbar nach Auftreten des unerwünschten Ereignisses einen `M112`-Befehl aus. Dadurch wechselt Klipper in einen "Shutdown-Zustand", und es werden zusätzliche Debugging-Informationen in die Logdatei geschrieben.
1. Besorgen Sie die Klipper-Protokolldatei des Ereignisses. Die Protokolldatei wurde entworfen, um häufige Fragen der Klipper-Entwickler über die Software und ihre Umgebung zu beantworten (Software Version, Hardware Typ, Konfiguration, Ereignis Timing und Hunderte von anderen Fragen).
   1. Spezielle Klipper-Weboberflächen bieten die Möglichkeit, die Klipper-Logdatei direkt abzurufen. Dies ist der einfachste Weg, das Log zu erhalten, wenn eine dieser Oberflächen verwendet wird. Andernfalls wird ein "scp"- oder "sftp"-Werkzeug benötigt, um die Logdatei auf Ihren Desktop-Rechner zu kopieren. Das Werkzeug "scp" ist bei Linux- und macOS-Desktops standardmäßig vorhanden. Für andere Desktop-Systeme gibt es frei verfügbare scp-Werkzeuge (z. B. WinSCP). Die Logdatei befindet sich möglicherweise unter `~/printer_data/logs/klippy.log` (suchen Sie bei Verwendung eines grafischen scp-Werkzeugs nach dem Ordner "printer_data", darin nach dem Ordner "logs" und dann nach der Datei `klippy.log`). Alternativ kann sich die Logdatei unter `/tmp/klippy.log` befinden (kann Ihr grafisches scp-Werkzeug `/tmp/klippy.log` nicht direkt kopieren, klicken Sie wiederholt auf ".." bzw. "übergeordneter Ordner", bis Sie das Wurzelverzeichnis erreichen, klicken Sie auf den Ordner `tmp` und wählen Sie dann die Datei `klippy.log` aus).
   1. Kopieren Sie die Logdatei auf Ihren Desktop, damit sie einem Issue-Report beigefügt werden kann.
   1. Bearbeiten Sie die Logdatei in keiner Weise; stellen Sie keinen Ausschnitt des Logs bereit. Nur die vollständige, unveränderte Logdatei liefert die notwendigen Informationen.
   1. Es empfiehlt sich, die Logdatei mit zip oder gzip zu komprimieren.
1. Eröffnen Sie ein neues Thema im [Klipper-Discourse-Forum](#discourse-forum) und beschreiben Sie das Problem klar und deutlich. Andere Klipper-Mitwirkende müssen verstehen können, welche Schritte unternommen wurden, welches Ergebnis erwartet wurde und welches Ergebnis tatsächlich eingetreten ist. Die komprimierte Klipper-Logdatei sollte diesem Thema beigefügt werden.

## Ich nehme Änderungen vor, die ich gerne in Klipper aufnehmen lassen möchte

Klipper ist Open-Source-Software, und wir freuen uns über neue Beiträge.

Weitere Informationen finden Sie im [CONTRIBUTING-Dokument](CONTRIBUTING.md).

Es gibt mehrere [Dokumente für Entwickler](Overview.md#developer-documentation). Bei Fragen zum Code können Sie diese auch im [Klipper-Discourse-Forum](#discourse-forum) oder im [Klipper-Discord-Chat](#discord-chat) stellen.

## Professionelle Dienstleistungen

![](img/klipper-logo-small.png)

Individuelle Softwareentwicklung, Softwaresupport und Lösungen: <https://ko-fi.com/koconnor>
