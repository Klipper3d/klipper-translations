# Contatti

Questo documento fornisce informazioni di contatto per Klipper.

1. [Forum della comunità](#community-forum)
1. [Chat Discord](#discord-chat)
1. [Ho una domanda su Klipper](#i-have-a-question-about-klipper)
1. [Ho una richiesta per una funzionalità](#i-have-a-feature-request)
1. [Aiuto! Non funziona!](#help-it-doesnt-work)
1. [I found a bug in the Klipper software](#i-found-a-bug-in-the-klipper-software)
1. [Sto apportando modifiche che vorrei includere in Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)
1. [Klipper github](#klipper-github)

## Forum della Comunità

C'è un server [Klipper Community Discourse server](https://community.klipper3d.org) per discussioni su Klipper.

## Chat Discord

C'è un serve Discord dedicato a Klipper a: <https://discord.klipper3d.org>.

Questo server è gestito da una comunità di appassionati di Klipper dediti alle discussioni su Klipper. Consente agli utenti di chattare con altri utenti in tempo reale.

## Ho una domanda su Klipper

Molte domande che riceviamo hanno già una risposta nella [Klipper documentation](Overview.md). Per favore assicurati di leggere la documentazione e di seguire le indicazioni fornite.

È anche possibile cercare domande simili nel [Klipper Community Forum](#community-forum).

Se sei interessato a condividere le tue conoscenze ed esperienze con altri utenti di Klipper, puoi unirti al [Klipper Community Forum](#community-forum) o [Klipper Discord Chat](#discord-chat). Entrambe sono comunità in cui gli utenti di Klipper possono discutere di Klipper con altri utenti.

Molte domande che riceviamo sono domande generiche sulla stampa 3D che non sono specifiche di Klipper. Se hai una domanda generica o stai riscontrando problemi di stampa generici, probabilmente otterrai una risposta migliore chiedendo in un forum generale sulla stampa 3D o in un forum dedicato all'hardware della tua stampante.

## Ho una richiesta per una funzionalità

Tutte le nuove funzionalità richiedono qualcuno interessato e in grado di implementare tale funzionalità. Se sei interessato ad aiutare a implementare o testare una nuova funzionalità, puoi cercare gli sviluppi coinvolti nel [Klipper Community Forum](#community-forum). C'è anche [Klipper Discord Chat](#discord-chat) per le discussioni tra i collaboratori.

## Aiuto! Non funziona!

Sfortunatamente, riceviamo molte più richieste di aiuto di quante potremmo eventualmente rispondere. La maggior parte delle segnalazioni di problemi che vediamo vengono infine rintracciate in:

1. Piccoli nell'hardware, o
1. Non seguendo tutti i passaggi descritti nella documentazione di Klipper.

In caso di problemi, ti consigliamo di leggere attentamente la [Klipper documentation](Overview.md) e di verificare che tutti i passaggi siano stati seguiti.

Se si verifica un problema di stampa, si consiglia di ispezionare attentamente l'hardware della stampante (tutti i giunti, i cavi, le viti, ecc.) e verificare che non vi siano anomalie. Scopriamo che la maggior parte dei problemi di stampa non sono correlati al software Klipper. Se trovi un problema con l'hardware della stampante, probabilmente otterrai una risposta migliore cercando in un forum generale di stampa 3D o in un forum dedicato all'hardware della tua stampante.

È anche possibile cercare problemi simili in [Klipper Community Forum](#community-forum).

Se sei interessato a condividere le tue conoscenze ed esperienze con altri utenti di Klipper, puoi unirti al [Klipper Community Forum](#community-forum) o [Klipper Discord Chat](#discord-chat). Entrambe sono comunità in cui gli utenti di Klipper possono discutere di Klipper con altri utenti.

## I found a bug in the Klipper software

Klipper è un progetto open-source ed apprezziamo quando i collaboratori diagnosticano errori nel software.

Problems should be reported in the [Klipper Community Forum](#community-forum).

Ci sono informazioni importanti che saranno necessarie per correggere un bug. Per favore segui questi passaggi:

1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you should reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting.
1. If possible, run an `M112` command immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. Ottieni il log file di Klipper dell'evento. Il file di registro è stato progettato per rispondere alle domande più comuni degli sviluppatori di Klipper sul software e sul suo ambiente (versione del software, tipo di hardware, configurazione, tempistica degli eventi e centinaia di altre domande).
   1. Il log file di Klipper si trova in `/tmp/klippy.log` sul computer "host" di Klipper (il Raspberry Pi).
   1. Un comando o utility "scp" o "sftp" è necessario per copiare questo file di registro sul computer desktop. L'utilità "scp" viene fornita di serie con i desktop Linux e MacOS. Ci sono utilità scp disponibili gratuitamente per altri desktop (ad es. WinSCP). Se si utilizza un'interfaccia grafica scp che non può copiare direttamente `/tmp/klippy.log`, fare clic ripetutamente su `..` o `cartella principale` fino ad arrivare alla directory principale, fare clic sulla cartella `tmp`, quindi seleziona il file `klippy.log`.
   1. Copia il lof file sul desktop in modo che possa essere allegato a una segnalazione di problema.
   1. Non modificare in alcun modo il log file; non editare o ritagliare il log file. Solo il file di log completo non modificato fornisce le informazioni necessarie.
   1. It is a good idea to compress the log file with zip or gzip.
1. Open a new topic on the [Klipper Community Forum](#community-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## Sto apportando modifiche che vorrei includere in Klipper

Klipper è un software open-source e apprezziamo i nuovi contributi.

I nuovi contributi (sia per il codice che per la documentazione) vengono inviati tramite Github Pull Requests. Vedere [[CONTRIBUTING document](CONTRIBUTING.md) per informazioni importanti.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Community Forum](#community-forum) or on the [Klipper Community Discord](#discord-chat).

## Klipper github

Klipper github may be used by contributors to share the status of their work to improve Klipper. It is expected that the person opening a github ticket is actively working on the given task and will be the one performing all the work necessary to accomplish it. The Klipper github is not used for requests, nor to report bugs, nor to ask questions. Use the [Klipper Community Forum](#community-forum) or the [Klipper Community Discord](#discord-chat) instead.
