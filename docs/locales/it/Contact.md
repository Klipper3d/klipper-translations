# Contatti

Questo documento fornisce informazioni di contatto per Klipper.

## Discourse Forum

There is a [Klipper Community Discourse server](https://community.klipper3d.org) for "forum" style discussions on Klipper. Note that Discourse is not Discord.

## Chat Discord

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>. Note that Discord is not Discourse.

Questo server è gestito da una comunità di appassionati di Klipper dediti alle discussioni su Klipper. Consente agli utenti di chattare con altri utenti in tempo reale.

## Ho una domanda su Klipper

Molte domande che riceviamo hanno già una risposta nella [Klipper documentation](Overview.md). Per favore assicurati di leggere la documentazione e di seguire le indicazioni fornite.

It is also possible to search for similar questions in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

If you have a general question or are experiencing general printing problems, then also consider a general 3d-printing forum or a forum dedicated to the printer hardware.

## Ho una richiesta per una funzionalità

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Discourse Forum](#discourse-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## Aiuto! Non funziona!

In caso di problemi, ti consigliamo di leggere attentamente la [Klipper documentation](Overview.md) e di verificare che tutti i passaggi siano stati seguiti.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then consider searching general 3d-printing forums or forums dedicated to the printer hardware.

It is also possible to search for similar issues in the [Klipper Discourse Forum](#discourse-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Discourse Forum](#discourse-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

## Ho trovato un bug nel software Klipper

Klipper è un progetto open-source ed apprezziamo quando i collaboratori diagnosticano errori nel software.

Problems should be reported in the [Klipper Discourse Forum](#discourse-forum).

Ci sono informazioni importanti che saranno necessarie per correggere un bug. Per favore segui questi passaggi:

1. Assicurati di eseguire codice non modificato da <https://github.com/Klipper3d/klipper>. Se il codice è stato modificato o è stato ottenuto da un'altra fonte, è necessario riprodurre il problema sul codice non modificato da <https://github.com/Klipper3d/klipper> prima della segnalazione.
1. Se possibile, eseguire un comando `M112` immediatamente dopo che si è verificato l'evento indesiderato. Ciò fa sì che Klipper entri in uno "shutdown state" e causerà la scrittura di ulteriori informazioni di debug nel file di registro.
1. Ottieni il log file di Klipper dell'evento. Il file di registro è stato progettato per rispondere alle domande più comuni degli sviluppatori di Klipper sul software e sul suo ambiente (versione del software, tipo di hardware, configurazione, tempistica degli eventi e centinaia di altre domande).
   1. Dedicated Klipper web interfaces have the ability to directly obtain the Klipper log file. It's the easiest way to obtain the log when using one of these interfaces. Otherwise, an "scp" or "sftp" utility is needed to copy the log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). The log file may be located in the `~/printer_data/logs/klippy.log` file (if using a graphical scp utility, look for the "printer_data" folder, then the "logs" folder under that, then the `klippy.log` file). The log file may alternatively be located in the `/tmp/klippy.log` file (if using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or "parent folder" until reaching the root directory, click on the `tmp` folder, and then select the `klippy.log` file).
   1. Copia il lof file sul desktop in modo che possa essere allegato a una segnalazione di problema.
   1. Non modificare in alcun modo il log file; non editare o ritagliare il log file. Solo il file di log completo non modificato fornisce le informazioni necessarie.
   1. È una buona idea comprimere il file di registro con zip o gzip.
1. Open a new topic on the [Klipper Discourse Forum](#discourse-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## Sto apportando modifiche che vorrei includere in Klipper

Klipper è un software open-source e apprezziamo i nuovi contributi.

See the [CONTRIBUTING document](CONTRIBUTING.md) for information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Discourse Forum](#discourse-forum) or on the [Klipper Discord Chat](#discord-chat).

## Professional Services

![](img/klipper-logo-small.png)

Custom software development, software support, and solutions: <https://ko-fi.com/koconnor>
