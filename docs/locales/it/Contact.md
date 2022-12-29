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

## Ho trovato un bug nel software Klipper

Klipper è un progetto open-source ed apprezziamo quando i collaboratori diagnosticano errori nel software.

I problemi devono essere segnalati nel [Klipper Community Forum](#community-forum).

Ci sono informazioni importanti che saranno necessarie per correggere un bug. Per favore segui questi passaggi:

1. Assicurati di eseguire codice non modificato da <https://github.com/Klipper3d/klipper>. Se il codice è stato modificato o è stato ottenuto da un'altra fonte, è necessario riprodurre il problema sul codice non modificato da <https://github.com/Klipper3d/klipper> prima della segnalazione.
1. Se possibile, eseguire un comando `M112` immediatamente dopo che si è verificato l'evento indesiderato. Ciò fa sì che Klipper entri in uno "shutdown state" e causerà la scrittura di ulteriori informazioni di debug nel file di registro.
1. Ottieni il log file di Klipper dell'evento. Il file di registro è stato progettato per rispondere alle domande più comuni degli sviluppatori di Klipper sul software e sul suo ambiente (versione del software, tipo di hardware, configurazione, tempistica degli eventi e centinaia di altre domande).
   1. Il log file di Klipper si trova in `/tmp/klippy.log` sul computer "host" di Klipper (il Raspberry Pi).
   1. Un comando o utility "scp" o "sftp" è necessario per copiare questo file di registro sul computer desktop. L'utilità "scp" viene fornita di serie con i desktop Linux e MacOS. Ci sono utilità scp disponibili gratuitamente per altri desktop (ad es. WinSCP). Se si utilizza un'interfaccia grafica scp che non può copiare direttamente `/tmp/klippy.log`, fare clic ripetutamente su `..` o `cartella principale` fino ad arrivare alla directory principale, fare clic sulla cartella `tmp`, quindi seleziona il file `klippy.log`.
   1. Copia il lof file sul desktop in modo che possa essere allegato a una segnalazione di problema.
   1. Non modificare in alcun modo il log file; non editare o ritagliare il log file. Solo il file di log completo non modificato fornisce le informazioni necessarie.
   1. È una buona idea comprimere il file di registro con zip o gzip.
1. Apri un nuovo topic sul [Klipper Community Forum](#community-forum) e fornisci una descrizione chiara del problema. Altri contributori di Klipper dovranno capire quali passi sono stati compiuti, quale era il risultato desiderato e quale risultato si è effettivamente verificato. Il file di registro compresso di Klipper dovrebbe essere allegato a quel topic.

## Sto apportando modifiche che vorrei includere in Klipper

Klipper è un software open-source e apprezziamo i nuovi contributi.

I nuovi contributi (sia per il codice che per la documentazione) vengono inviati tramite Github Pull Requests. Vedere [[CONTRIBUTING document](CONTRIBUTING.md) per informazioni importanti.

Ci sono diversi [documenti per sviluppatori](Overview.md#developer-documentation). Se hai domande sul codice, puoi anche chiedere nel [Klipper Community Forum](#community-forum) o nella [Klipper Community Discord](#discord-chat).

## Klipper github

Klipper github può essere utilizzato dai contributori per condividere lo stato del loro lavoro per migliorare Klipper. Ci si aspetta che la persona che apre un ticket github stia lavorando attivamente all'attività specificata e sarà quella che eseguirà tutto il lavoro necessario per realizzarla. Il github di Klipper non viene utilizzato per richieste, né per segnalare bug, né per porre domande. Usa invece il [Klipper Community Forum](#community-forum) o la [Klipper Community Discord](#discord-chat).
