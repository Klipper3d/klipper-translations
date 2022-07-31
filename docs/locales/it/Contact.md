# Contatti

Questo documento fornisce informazioni di contatto per Klipper.

1. [Forum della comunità](#community-forum)
1. [Chat Discord](#discord-chat)
1. [Ho una domanda su Klipper](#i-have-a-question-about-klipper)
1. [Ho una richiesta per una funzionalità](#i-have-a-feature-request)
1. [Aiuto! Non funziona!](#help-it-doesnt-work)
1. [Ho diagnosticato un difetto nel software Klipper](#i-have-diagnosed-a-defect-in-the-klipper-software)
1. [Sto apportando modifiche che vorrei includere in Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)

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

Non aprire un problema (issue) su Klipper github per porre una domanda.

## Ho una richiesta per una funzionalità

Tutte le nuove funzionalità richiedono qualcuno interessato e in grado di implementare tale funzionalità. Se sei interessato ad aiutare a implementare o testare una nuova funzionalità, puoi cercare gli sviluppi coinvolti nel [Klipper Community Forum](#community-forum). C'è anche [Klipper Discord Chat](#discord-chat) per le discussioni tra i collaboratori.

Non aprire un problema (issue) in Klipper github per richiedere una funzionalità.

## Aiuto! Non funziona!

Sfortunatamente, riceviamo molte più richieste di aiuto di quante potremmo eventualmente rispondere. La maggior parte delle segnalazioni di problemi che vediamo vengono infine rintracciate in:

1. Piccoli nell'hardware, o
1. Non seguendo tutti i passaggi descritti nella documentazione di Klipper.

In caso di problemi, ti consigliamo di leggere attentamente la [Klipper documentation](Overview.md) e di verificare che tutti i passaggi siano stati seguiti.

Se si verifica un problema di stampa, si consiglia di ispezionare attentamente l'hardware della stampante (tutti i giunti, i cavi, le viti, ecc.) e verificare che non vi siano anomalie. Scopriamo che la maggior parte dei problemi di stampa non sono correlati al software Klipper. Se trovi un problema con l'hardware della stampante, probabilmente otterrai una risposta migliore cercando in un forum generale di stampa 3D o in un forum dedicato all'hardware della tua stampante.

È anche possibile cercare problemi simili in [Klipper Community Forum](#community-forum).

Se sei interessato a condividere le tue conoscenze ed esperienze con altri utenti di Klipper, puoi unirti al [Klipper Community Forum](#community-forum) o [Klipper Discord Chat](#discord-chat). Entrambe sono comunità in cui gli utenti di Klipper possono discutere di Klipper con altri utenti.

Non aprire un problema (issue) in Klipper github per richiedere assistenza.

## Ho diagnosticato un difetto nel software Klipper

Klipper è un progetto open-source ed apprezziamo quando i collaboratori diagnosticano errori nel software.

Ci sono informazioni importanti che saranno necessarie per correggere un bug. Per favore segui questi passaggi:

1. Assicurati che il bug sia nel software Klipper. Se stai pensando "c'è un problema, non riesco a capire perché, e quindi è un bug di Klipper", allora **non** aprire un problema (issue) con github. Nel caso qualcuno interessato e capace dovrà prima ricercare e diagnosticare la causa origine del problema. Se desideri condividere i risultati della tua ricerca o verificare se altri utenti stanno riscontrando problemi simili, puoi cercare in [Klipper Community Forum](#community-forum).
1. Assicurati di eseguire il codice non modificato da <https://github.com/Klipper3d/klipper>. Se il codice è stato modificato o è stato ottenuto da un'altra fonte, dovrai riprodurre il problema sul codice non modificato da <https://github.com/Klipper3d/klipper> prima di segnalare un problema.
1. Se possibile, esegui un comando `M112` nella finestra del terminale di OctoPrint subito dopo che si è verificato l'evento indesiderato. Ciò fa sì che Klipper entri in uno "stato di arresto - shutdown state" e provocherà la scrittura di ulteriori informazioni di debug nel file di registro.
1. Ottieni il log file di Klipper dell'evento. Il file di registro è stato progettato per rispondere alle domande più comuni degli sviluppatori di Klipper sul software e sul suo ambiente (versione del software, tipo di hardware, configurazione, tempistica degli eventi e centinaia di altre domande).
   1. Il log file di Klipper si trova in `/tmp/klippy.log` sul computer "host" di Klipper (il Raspberry Pi).
   1. Un comando o utility "scp" o "sftp" è necessario per copiare questo file di registro sul computer desktop. L'utilità "scp" viene fornita di serie con i desktop Linux e MacOS. Ci sono utilità scp disponibili gratuitamente per altri desktop (ad es. WinSCP). Se si utilizza un'interfaccia grafica scp che non può copiare direttamente `/tmp/klippy.log`, fare clic ripetutamente su `..` o `cartella principale` fino ad arrivare alla directory principale, fare clic sulla cartella `tmp`, quindi seleziona il file `klippy.log`.
   1. Copia il lof file sul desktop in modo che possa essere allegato a una segnalazione di problema.
   1. Non modificare in alcun modo il log file; non editare o ritagliare il log file. Solo il file di log completo non modificato fornisce le informazioni necessarie.
   1. Se il file di registro è molto grande (ad esempio, maggiore di 2 MB), potrebbe essere necessario comprimerlo con zip o gzip.

   1. Apri un nuovo problema con github su <https://github.com/Klipper3d/klipper/issues> e fornisci una descrizione chiara del problema. Gli sviluppatori di Klipper devono capire quali passi sono stati intrapresi, quale era il risultato desiderato e quale risultato si è effettivamente verificato. Il file di registro di Klipper **deve essere allegato** al ticket:![attach-issue](img/attach-issue.png)

## Sto apportando modifiche che vorrei includere in Klipper

Klipper è un software open-source e apprezziamo i nuovi contributi.

I nuovi contributi (sia per il codice che per la documentazione) vengono inviati tramite Github Pull Requests. Vedere [[CONTRIBUTING document](CONTRIBUTING.md) per informazioni importanti.

Esistono diversi [documenti per sviluppatori](Overview.md#developer-documentation). Se hai domande sul codice, puoi anche chiedere nel [Klipper Community Forum](#community-forum) o nel [Klipper Community Discord](#discord-chat). Se desideri fornire un aggiornamento sui tuoi progressi attuali, puoi aprire un problema (issue) con Github con la posizione del tuo codice, una panoramica delle modifiche e una descrizione del suo stato attuale.
