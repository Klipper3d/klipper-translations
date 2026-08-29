# Zu Klipper beitragen

Vielen Dank, dass Sie zu Klipper beitragen! Dieses Dokument beschreibt den Ablauf für das Einbringen von Änderungen in Klipper.

Informationen zum Melden eines Problems sowie zur Kontaktaufnahme mit den Entwicklern finden Sie auf der [Kontaktseite](Contact.md).

## Überblick über den Beitragsprozess

Beiträge zu Klipper folgen im Allgemeinen einem anspruchsvollen Prozess:

1. Ein Einreicher beginnt damit, einen [GitHub Pull Request](https://github.com/Klipper3d/klipper/pulls) zu erstellen, sobald eine Einreichung für den breiten Einsatz bereit ist.
1. Sobald ein [Reviewer](#reviewers) für die [Prüfung](#what-to-expect-in-a-review) der Einreichung verfügbar ist, weist er sich den Pull Request auf GitHub selbst zu. Ziel der Prüfung ist es, nach Mängeln zu suchen und zu kontrollieren, ob die Einreichung den dokumentierten Richtlinien folgt.
1. Nach einer erfolgreichen Prüfung gibt der Reviewer die Prüfung auf GitHub frei ("approve the review") und ein [Maintainer](#reviewers) übernimmt die Änderung in den Master-Branch von Klipper.

Wenn Sie an Erweiterungen arbeiten, erwägen Sie, ein Thema im [Klipper Discourse](Contact.md) zu eröffnen (oder sich daran zu beteiligen). Eine laufende Diskussion im Forum kann die Sichtbarkeit der Entwicklungsarbeit erhöhen und weitere Interessierte für das Testen neuer Arbeiten gewinnen.

## Was Sie bei einer Überprüfung erwarten können

Beiträge zu Klipper werden vor dem Zusammenführen geprüft. Vorrangiges Ziel des Prüfprozesses ist es, nach Mängeln zu suchen und zu kontrollieren, ob die Einreichung den in der Klipper-Dokumentation festgelegten Richtlinien folgt.

Es ist bekannt, dass es viele Wege gibt, eine Aufgabe zu lösen; es ist nicht Absicht der Prüfung, über die "beste" Umsetzung zu diskutieren. Nach Möglichkeit sind Prüfdiskussionen vorzuziehen, die sich auf Fakten und Messwerte stützen.

Die meisten Einreichungen führen zu Rückmeldungen aus einer Prüfung. Seien Sie darauf vorbereitet, Rückmeldungen zu erhalten, weitere Einzelheiten beizusteuern und die Einreichung bei Bedarf zu überarbeiten.

Worauf ein Reviewer üblicherweise achtet:

1. Ist die Einreichung frei von Mängeln und bereit für den breiten Einsatz?

   Von Einreichern wird erwartet, dass sie ihre Änderungen vor der Einreichung testen. Die Reviewer achten auf Fehler, testen Einreichungen jedoch in der Regel nicht. Eine angenommene Einreichung wird häufig innerhalb weniger Wochen nach der Annahme auf Tausenden von Druckern eingesetzt. Die Qualität von Einreichungen hat daher Vorrang.

   Das Haupt-Repository [Klipper3d/klipper](https://github.com/Klipper3d/klipper) auf GitHub nimmt keine experimentellen Arbeiten auf. Einreicher sollten Experimente, Fehlersuche und Tests in ihren eigenen Repositories durchführen. Der [Klipper-Discourse](Contact.md)-Server ist ein guter Ort, um auf neue Arbeiten aufmerksam zu machen und Benutzer zu finden, die Rückmeldungen aus der Praxis geben.

   Einsendungen müssen alle [regression test cases](Debugging.md) bestehen.

   Beim Beheben eines Mangels im Code sollten Einreicher ein grundsätzliches Verständnis der eigentlichen Ursache dieses Mangels haben, und die Behebung sollte auf diese Ursache abzielen.

   Code-Einreichungen sollten keinen übermäßigen Debugging-Code, keine Debugging-Optionen und keine Debug-Protokollierung zur Laufzeit enthalten.

   Kommentare in Code-Einreichungen sollten die Wartbarkeit des Codes verbessern. Einreichungen sollten keinen "auskommentierten Code" und keine übermäßigen Kommentare zu früheren Umsetzungen enthalten. Es sollten keine übermäßig vielen "todo"-Kommentare enthalten sein.

   Aktualisierungen der Dokumentation sollten nicht darauf hinweisen, dass sie sich "in Arbeit" befinden.
1. Bringt die Einreichung einen "hohen Nutzen" für reale Anwender bei realen Aufgaben?

   Reviewer müssen zumindest für sich selbst grob bestimmen, "wer die Zielgruppe ist", wie groß diese Zielgruppe ungefähr ist, welchen "Nutzen" sie erhält, wie dieser "Nutzen gemessen wird" und welche "Ergebnisse diese Messungen liefern". In den meisten Fällen ist das sowohl für Einreicher als auch für Reviewer offensichtlich und wird während einer Prüfung nicht ausdrücklich erwähnt.

   Von Einreichungen in den Master-Branch von Klipper wird erwartet, dass sie eine nennenswerte Zielgruppe haben. Als grobe Faustregel gilt, dass Einreichungen auf eine Nutzerbasis von mindestens 100 realen Anwendern abzielen sollten.

   Wenn ein Reviewer nach Einzelheiten zum "Nutzen" einer Einreichung fragt, betrachten Sie das bitte nicht als Kritik. Den realen Nutzen einer Änderung nachvollziehen zu können, ist ein natürlicher Bestandteil einer Prüfung.

   Bei der Erörterung des Nutzens sind "Fakten und Messwerte" vorzuziehen. Reviewer suchen im Allgemeinen weder nach Antworten der Form "jemand könnte Option X nützlich finden" noch nach Antworten der Form "diese Einreichung ergänzt eine Funktion, die Firmware X umsetzt". Vorzuziehen ist stattdessen die Darlegung, wie die Qualitätsverbesserung gemessen wurde und welche Ergebnisse diese Messungen lieferten - zum Beispiel "Tests auf Acme-X1000-Druckern zeigen verbesserte Ecken, wie in Bild ... zu sehen" oder "die Druckzeit des realen Objekts X auf einem Foomatic X900 sank von 4 Stunden auf 3,5 Stunden". Es ist bekannt, dass Tests dieser Art erheblichen Zeit- und Arbeitsaufwand bedeuten können. Einige der bemerkenswertesten Funktionen von Klipper erforderten Monate an Diskussion, Überarbeitung, Tests und Dokumentation, bevor sie in den Master-Branch übernommen wurden.

   Alle neuen Module, Konfigurationsoptionen, Befehle, Befehlsparameter und Dokumente sollten einen "hohen Nutzen" haben. Wir wollen Benutzer weder mit Optionen belasten, die sie nicht sinnvoll konfigurieren können, noch mit Optionen, die keinen nennenswerten Nutzen bringen.

   Ein Reviewer kann um eine Erläuterung bitten, wie ein Benutzer eine Option konfigurieren soll - eine ideale Antwort enthält Einzelheiten zum Vorgehen, zum Beispiel: "Benutzer des MegaX500 sollen Option X auf 99.3 setzen, während Benutzer des Elite100Y Option X mit folgendem Verfahren kalibrieren sollen ...".

   Wenn eine Option lediglich dazu dient, den Code modularer zu machen, verwenden Sie besser Konstanten im Code statt für Benutzer sichtbarer Konfigurationsoptionen.

   Neue Module, neue Optionen und neue Parameter sollten keine Funktionalität bereitstellen, die bestehenden Modulen ähnelt - sind die Unterschiede willkürlich, ist es vorzuziehen, das bestehende System zu nutzen oder den vorhandenen Code umzustrukturieren.
1. Ist das Urheberrecht der Einreichung klar, angemessen und vereinbar?

   Neue C- und Python-Dateien sollten einen eindeutigen Urheberrechtsvermerk enthalten. Das bevorzugte Format finden Sie in den vorhandenen Dateien. Von einem Urheberrechtsvermerk in einer bestehenden Datei bei geringfügigen Änderungen an dieser Datei wird abgeraten.

   Aus Drittquellen übernommener Code muss mit der Klipper-Lizenz (GNU GPLv3) vereinbar sein. Umfangreiche Ergänzungen aus Drittcode sollten im Verzeichnis `lib/` abgelegt werden (und dem in [lib/README](../lib/README) beschriebenen Format folgen).

   Einreicher müssen eine [Signed-off-by-Zeile](#format-of-commit-messages) mit ihrem vollständigen bürgerlichen Namen angeben. Damit erklären sie ihr Einverständnis mit dem [Developer Certificate of Origin](developer-certificate-of-origin).
1. Folgt die Einreichung den in der Klipper-Dokumentation festgelegten Richtlinien?

   Insbesondere sollte Code den Richtlinien in <Code_Overview.md> folgen und Konfigurationsdateien sollten den Richtlinien in <Example_Configs.md> folgen.
1. Wurde die Klipper-Dokumentation an die neuen Änderungen angepasst?

   Mindestens die Referenzdokumentation muss entsprechend den Codeänderungen aktualisiert werden:

   * Alle Befehle und Befehlsparameter müssen in <G-Codes.md> dokumentiert werden.
   * Alle für Benutzer sichtbaren Module und ihre Konfigurationsparameter müssen in <Config_Reference.md> dokumentiert werden.
   * Alle exportierten "Statusvariablen" müssen in <Status_Reference.md> dokumentiert werden.
   * Alle neuen "Webhooks" und ihre Parameter müssen in <API_Server.md> dokumentiert werden.
   * Jede Änderung, die einen Befehl oder eine Konfigurationseinstellung nicht abwärtskompatibel verändert, muss in <Config_Changes.md> dokumentiert werden.

Neue Dokumente sollten in <Overview.md> aufgenommen und dem Website-Index [docs/_klipper3d/mkdocs.yml](../docs/_klipper3d/mkdocs.yml) hinzugefügt werden.

1. Sind die Commits sauber aufgebaut, behandeln sie jeweils ein einzelnes Thema und sind sie unabhängig voneinander?

   Commit-Nachrichten sollten dem [bevorzugten Format](#format-of-commit-messages) folgen.

   Commits dürfen keinen Merge-Konflikt aufweisen. Neue Ergänzungen des Klipper-Master-Branch erfolgen stets per "Rebase" oder "Squash and Rebase". In der Regel ist es nicht notwendig, dass Einreicher ihre Einreichung bei jeder Aktualisierung des Klipper-Master-Repositories neu mergen. Bei einem Merge-Konflikt wird Einreichern jedoch empfohlen, den Konflikt mit `git rebase` zu beheben.

   Jeder Commit sollte eine einzelne übergeordnete Änderung umfassen. Große Änderungen sollten in mehrere unabhängige Commits aufgeteilt werden. Jeder Commit sollte "für sich stehen", damit Werkzeuge wie `git bisect` und `git revert` zuverlässig funktionieren.

   Änderungen an Leerraum sollten nicht mit funktionalen Änderungen vermischt werden. Grundsätzlich werden überflüssige Leerraumänderungen nur akzeptiert, wenn sie vom etablierten "Eigentümer" des geänderten Codes stammen.

Klipper setzt keinen strengen "Coding Style Guide" um; Änderungen an vorhandenem Code sollten jedoch dem übergeordneten Codeablauf, dem Einrückungsstil und dem Format des jeweils vorhandenen Codes folgen. Bei Einreichungen neuer Module und Systeme besteht mehr Spielraum im Codierstil, es ist jedoch vorzuziehen, dass dieser neue Code einem in sich einheitlichen Stil folgt und sich grundsätzlich an branchenüblichen Konventionen orientiert.

Es ist nicht Ziel einer Prüfung, über "bessere Umsetzungen" zu diskutieren. Wenn ein Reviewer jedoch Mühe hat, die Umsetzung einer Einreichung nachzuvollziehen, kann er Änderungen verlangen, die die Umsetzung nachvollziehbarer machen. Insbesondere können Änderungen notwendig sein, wenn sich Reviewer nicht davon überzeugen können, dass eine Einreichung frei von Mängeln ist.

Im Rahmen einer Prüfung kann ein Reviewer einen alternativen Pull Request zum selben Thema erstellen. Das kann geschehen, um übermäßiges Hin und Her bei kleineren formalen Punkten zu vermeiden und den Einreichungsprozess zu straffen. Es kann auch geschehen, weil die Diskussion einen Reviewer zu einer alternativen Umsetzung anregt. Beides ist ein normales Ergebnis einer Prüfung und sollte nicht als Kritik an der ursprünglichen Einreichung verstanden werden.

### Bei der Überarbeitung helfen

Wir freuen uns über Hilfe bei Prüfungen! Man muss kein [gelisteter Reviewer](#reviewers) sein, um eine Prüfung durchzuführen. Auch Einreicher von GitHub Pull Requests sind eingeladen, ihre eigenen Einreichungen zu prüfen.

Um bei einer Prüfung zu helfen, folgen Sie den Schritten unter [Was Sie bei einer Prüfung erwartet](#what-to-expect-in-a-review), um die Einreichung zu überprüfen. Fügen Sie nach Abschluss der Prüfung dem GitHub Pull Request einen Kommentar mit Ihren Ergebnissen hinzu. Besteht die Einreichung die Prüfung, geben Sie das im Kommentar bitte ausdrücklich an - zum Beispiel: "I reviewed this change according to the steps in the CONTRIBUTING document and everything looks good to me". Können Sie einzelne Prüfschritte nicht abschließen, geben Sie bitte ausdrücklich an, welche Schritte geprüft wurden und welche nicht - zum Beispiel: "I didn't check the code for defects, but I reviewed everything else in the CONTRIBUTING document and it looks good".

Wir freuen uns außerdem über das Testen von Einreichungen. Wurde der Code getestet, fügen Sie dem GitHub Pull Request bitte einen Kommentar mit den Ergebnissen Ihres Tests hinzu - Erfolg oder Misserfolg. Geben Sie ausdrücklich an, dass der Code getestet wurde, und nennen Sie die Ergebnisse - zum Beispiel: "I tested this code on my Acme900Z printer with a vase print and the results were good".

### Reviewer

Die Klipper"Gutachter" sind:

| Name | GitHub Id | Bereiche von Interesse |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | Input Shaping, Resonanztests, Kinematik |
| Eric Callahan | @Arksine | Bettnivellierung, MCU-Flashen |
| James Hartley | @JamesH1978 | Konfigurationsdateien |
| Kevin O'Connor | @KevinOConnor | Kern-Bewegungssystem, Mikrocontroller-Code |

Bitte "pingen" Sie keinen der Reviewer an und richten Sie Einreichungen nicht gezielt an sie. Alle Reviewer beobachten die Foren und Pull Requests und übernehmen Prüfungen, sobald sie Zeit dafür haben.

Die Klipper"Betreuer" sind:

| Name | GitHub Name |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## Format der Commit Nachrichten

Jeder Commit sollte eine Commit-Nachricht haben, die etwa wie folgt aufgebaut ist:

```
module: Capitalized, short (50 chars or less) summary

More detailed explanatory text, if necessary.  Wrap it to about 75
characters or so.  In some contexts, the first line is treated as the
subject of an email and the rest of the text as the body.  The blank
line separating the summary from the body is critical (unless you omit
the body entirely); tools like rebase can get confused if you run the
two together.

Further paragraphs come after blank lines..

Signed-off-by: My Name <myemail@example.org>
```

Im obigen Beispiel sollte `module` der Name einer Datei oder eines Verzeichnisses im Repository sein (ohne Dateiendung). Zum Beispiel: `clocksync: Fix typo in pause() call at connect time`. Die Angabe eines Modulnamens in der Commit-Nachricht dient dazu, den Kommentaren des Commits Kontext zu geben.

Es ist wichtig, eine "Signed-off-by"-Zeile auf jedem Commit zu haben - sie bescheinigt, dass Sie mit dem [Entwickler-Ursprungszeugnis](developer-certificate-of-origin) einverstanden sind. Sie muss Ihren echten Namen (sorry, keine Pseudonyme oder anonyme Beiträge) und eine aktuelle E-Mail-Adresse enthalten.

## Beitrag zur Klipper Übersetzung

Das [Klipper-translations-Projekt](https://github.com/Klipper3d/klipper-translations) ist ein Projekt, das sich der Übersetzung von Klipper in verschiedene Sprachen widmet. [Weblate](https://hosted.weblate.org/projects/klipper/) hostet sämtliche Gettext-Strings zum Übersetzen und Prüfen. Sprachen können auf [klipper3d.org](https://www.klipper3d.org) angezeigt werden, sobald sie die folgenden Anforderungen erfüllen:

- [ ] 75 % Gesamtdeckung
- [ ] Alle Titel (H1) werden übersetzt
- [ ] Ein PR mit einer aktualisierten Navigationshierarchie in klipper-translations.

Um die Frustration bei der Übersetzung fachspezifischer Begriffe zu verringern und die laufenden Übersetzungen sichtbar zu machen, können Sie einen PR einreichen, der die `readme.md` des [Klipper-translations-Projekts](https://github.com/Klipper3d/klipper-translations) anpasst. Sobald eine Übersetzung fertig ist, kann die entsprechende Änderung am Klipper-Projekt vorgenommen werden.

Wenn eine Übersetzung bereits im Klipper-Repository vorhanden ist und die obige Checkliste nicht mehr erfüllt, wird sie nach einem Monat ohne Aktualisierung als veraltet markiert.

Sobald die Anforderungen erfüllt sind, müssen Sie:

1. Aktualisieren Sie die Datei [active_translations](https://github.com/Klipper3d/klipper-translations/blob/translations/active_translations) im Repository klipper-translations
1. Optional: Legen Sie im Ordner `docs\locals\<lang>` des Repositories klipper-translations eine Datei manual-index.md an, um die sprachspezifische index.md zu ersetzen (die generierte index.md wird nicht korrekt dargestellt).

Bekannte Probleme:

1. Derzeit gibt es keine Methode, um Bilder in der Dokumentation korrekt zu übersetzen
1. Es ist unmöglich, Titel in mkdocs.yml zu übersetzen.
