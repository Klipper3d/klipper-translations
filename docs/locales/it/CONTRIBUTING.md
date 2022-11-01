# Contribuire a Klipper

Grazie per aver contribuito a Klipper! Questo documento descrive il processo per contribuire alle modifiche di Klipper.

Consulta la [contact page](Contact.md) per informazioni sulla segnalazione di un problema o per i dettagli su come contattare gli sviluppatori.

## Panoramica del processo di contribuzione

I contributi a Klipper seguono generalmente un processo di alto livello:

1. Inizia creando una [Richiesta pull GitHub](https://github.com/Klipper3d/klipper/pulls) quando un proposta è pronta per la diffusione.
1. Quando un [reviewer](#reviewers) è disponibile per [review](#what-to-expect-in-a-review) l'invio, si assegnerà la richiesta pull su GitHub. L'obiettivo della revisione è cercare i difetti e verificare che la proposta segua linee guida documentate.
1. Dopo una revisione riuscita, il revisore "approverà la revisione" su GitHub e un [maintainer](#reviewers) eseguirà il commit della modifica al ramo principale di Klipper.

Quando lavori sui miglioramenti, considera di iniziare (o contribuire a) un argomento su [Klipper Discourse](Contact.md). Una discussione in corso sul forum può migliorare la visibilità del lavoro di sviluppo e può attirare altri interessati a testare nuovi lavori.

## Cosa aspettarsi da una revisione

I contributi a Klipper vengono rivisti prima del merging. L'obiettivo principale del processo di revisione è verificare la presenza di difetti e verificare che la presentazione segua le linee guida specificate nella documentazione di Klipper.

Resta inteso che ci sono molti modi per portare a termine un compito; non è intenzione della revisione discutere la "migliore" implementazione. Ove possibile, sono preferibili discussioni di revisione incentrate su fatti e misurazioni.

La maggior parte degli invii otterrà in feedback da una recensione. Preparati a ottenere feedback, fornire ulteriori dettagli e aggiornare l'invio, se necessario.

Cose comuni che un revisore cercherà:


   1. L'invio è privo di difetti ed è pronto per essere diffuso?I realizzatori dei contributi sono tenuti a testare le loro modifiche prima dell'invio. I revisori cercano gli errori, ma in generale non testano gli invii. Un invio accettato viene spesso distribuito a migliaia di stampanti entro poche settimane dall'accettazione. La qualità degli invii è quindi considerata una priorità.

   Il repository GitHub principale [Klipper3d/klipper](https://github.com/Klipper3d/klipper) non accetta lavori sperimentali. I realizzatori di contributi devono eseguire la sperimentazione, il debug e il test nei propri repository. Il server [Klipper Discourse](Contact.md) è un buon posto per aumentare la consapevolezza del nuovo lavoro e per trovare utenti interessati a fornire feedback nel mondo reale.

   Gli invii devono superare tutti i [test di regressione](Debugging.md).

   Quando si corregge un difetto nel codice, i submitters dovrebbero avere una comprensione generale della causa principale di tale difetto e la correzione dovrebbe mirare a tale causa principale.

   Gli contributi di codice non devono contenere codice di debug eccessivo, opzioni di debug o registrazione del debug in fase di runtime.

   I commenti negli invii di codice dovrebbero concentrarsi sul miglioramento della manutenzione del codice. Gli invii non devono contenere "codice commentato" né commenti eccessivi che descrivono implementazioni passate. Non dovrebbero esserci commenti "todo" eccessivi.

   Gli aggiornamenti alla documentazione non devono dichiarare che si tratta di un "work in progress".

   1. L'invio fornisce un vantaggio "ad alto impatto" per gli utenti del mondo reale che svolgono attività nel mondo reale?I revisori devono identificare, almeno nella loro mente, approssimativamente "chi è il pubblico di destinazione", una scala approssimativa delle "dimensioni di quel pubblico", il "beneficio" che otterranno, come "il beneficio viene misurato" e i "risultati di tali prove di misurazione". Nella maggior parte dei casi questo sarà ovvio sia per il mittente che per il revisore e non è esplicitamente dichiarato durante una revisione.

   Le proposte al ramo principale di Klipper dovrebbero avere un pubblico di destinazione degno di nota. Come "regola pratica" generale, gli invii dovrebbero avere come target una base di utenti di almeno 100 utenti del mondo reale.

   Se un revisore chiede dettagli sul "beneficio" di un invio, non considerarlo una critica. Essere in grado di comprendere i vantaggi reali di un cambiamento è una parte naturale di una revisione.

   Quando si discute dei benefici è preferibile discutere di "fatti e misurazioni". In generale, i revisori non cercano risposte del modulo "qualcuno potrebbe trovare utile l'opzione X", né cercano risposte del modulo "questo invio aggiunge una funzionalità implementata dal firmware X". Invece, è generalmente preferibile discutere i dettagli su come è stato misurato il miglioramento della qualità e quali sono stati i risultati di tali misurazioni, ad esempio "i test sulle stampanti Acme X1000 mostrano angoli migliorati come si vede in figura...", o ad esempio " il tempo di stampa dell'oggetto reale X su una stampante Foomatic X900 è passato da 4 ore a 3,5 ore". Resta inteso che i test di questo tipo possono richiedere molto tempo e sforzi. Alcune delle caratteristiche più importanti di Klipper hanno richiesto mesi di discussioni, rielaborazioni, test e documentazione prima di essere fuse nel ramo principale.

   Tutti i nuovi moduli, opzioni di configurazione, comandi, parametri di comando e documenti dovrebbero avere un "impatto elevato". Non vogliamo appesantire gli utenti con opzioni che non possono configurare ragionevolmente né vogliamo appesantirli con opzioni che non forniscono un vantaggio notevole.

   Un revisore può chiedere chiarimenti su come un utente deve configurare un'opzione - una risposta ideale conterrà dettagli sul processo - ad esempio, "gli utenti del MegaX500 dovrebbero impostare l'opzione X su 99,3 mentre gli utenti dell'Elite100Y dovrebbero calibrare l'opzione X usando la procedura ...".

   Se l'obiettivo di un'opzione è rendere il codice più modulare, è preferibile utilizzare le costanti del codice invece delle opzioni di configurazione rivolte all'utente.

   Nuovi moduli, nuove opzioni e nuovi parametri non dovrebbero fornire funzionalità simili ai moduli esistenti: se le differenze sono arbitrarie, è preferibile utilizzare il sistema esistente o effettuare refactoring del codice esistente.

   1. Il copyright dell'invio è chiaro, non gratuito e compatibile?I nuovi file C e Python dovrebbero avere una dichiarazione di copyright univoca. Vedere i file esistenti per il formato preferito. È sconsigliato dichiarare un copyright su un file esistente quando si apportano modifiche minori a quel file.

   Il codice prelevato da fonti di terze parti deve essere compatibile con la licenza Klipper (GNU GPLv3). Grandi aggiunte di codice di terze parti dovrebbero essere aggiunte alla directory `lib/` (e seguire il formato descritto in [lib/README](../lib/README)).

   I mittenti devono fornire una [Signed-off-line](#format-of-commit-messages) utilizzando il loro vero nome completo. Indica che il mittente è d'accordo con il [developer certificate of origin](developer-certificate-of-origin).

   1. L'invio segue le linee guida specificate nella documentazione di Klipper?In particolare, il codice deve seguire le linee guida in <Code_Overview.md> e i file di configurazione devono seguire le linee guida in <Example_Configs.md>.

   1. La documentazione di Klipper è aggiornata per riflettere le nuove modifiche?Come minimo, la documentazione di riferimento deve essere aggiornata con le relative modifiche al codice:

   * Tutti i comandi e i relativi parametri devono essere documentati in <G-Codes.md>.
   * Tutti i moduli rivolti all'utente e i relativi parametri di configurazione devono essere documentati in <Config_Reference.md>.
   * Tutte le "variabili di stato" esportate devono essere documentate in <Status_Reference.md>.
   * Tutti i nuovi "webhook" e i relativi parametri devono essere documentati in <API_Server.md>.
   * Qualsiasi modifica che apporti una modifica non compatibile con le versioni precedenti a un comando o a un'impostazione del file di configurazione deve essere documentata in <Config_Changes.md>.

I nuovi documenti dovrebbero essere aggiunti a <Overview.md> e all'indice del sito web [docs/_klipper3d/mkdocs.yml](../docs/_klipper3d/mkdocs.yml).


   1. I commit sono ben formati, affrontano un singolo argomento per commit e sono indipendenti?I messaggi di commit devono seguire il [formato preferito](#format-of-commit-messages).

   I commit non devono avere un conflitto in fase di merge. Le nuove aggiunte al ramo principale di Klipper vengono sempre eseguite tramite un "rebase" o "squash and rebase". In genere non è necessario che i propositori uniscano nuovamente il loro invio ad ogni aggiornamento al repository principale di Klipper. Tuttavia, se c'è un conflitto in fase di merge, si consiglia ai mittenti di usare `git rebase` per risolvere il conflitto.

   Ogni commit dovrebbe affrontare una singola modifica di alto livello. Le modifiche di grandi dimensioni dovrebbero essere suddivise in più commit indipendenti. Ogni commit dovrebbe "stare in piedi da solo" in modo che strumenti come `git bisect` e `git revert` funzionino in modo affidabile.

   Le modifiche agli spazi bianchi non devono essere mescolate con le modifiche funzionali. In generale, le modifiche agli spazi bianchi gratuite non sono accettate a meno che non provengano dal "proprietario" stabilito del codice da modificare.

Klipper non implementa una rigida "guida allo stile di codifica", ma le modifiche al codice esistente dovrebbero seguire il flusso di codice di alto livello, lo stile di indentazione del codice e il formato di quel codice esistente. Gli invii di nuovi moduli e sistemi hanno una maggiore flessibilità nello stile di codifica, ma è preferibile che il nuovo codice segua uno stile internamente coerente e generalmente segua le norme di codifica.

Non è un obiettivo di una revisione discutere di "migliori implementazioni". Tuttavia, se un revisore ha difficoltà a comprendere l'implementazione di un invio, può richiedere modifiche per rendere l'implementazione più trasparente. In particolare, se i revisori non riescono a convincersi che un contributo è privo di difetti, potrebbero essere necessarie modifiche.

Come parte di una revisione, un revisore può creare una richiesta pull alternativa per un argomento. Questo può essere fatto per evitare eccessivi "avanti e indietro" su elementi procedurali minori e quindi snellire il processo di proposta. Può anche essere fatto perché la discussione ispira un revisore a costruire un'implementazione alternativa. Entrambe le situazioni sono il normale risultato di una revisione e non devono essere considerate critiche alla proposta originale.

### Aiutare con le revisioni

Apprezziamo l'aiuto con le recensioni! Non è necessario essere un [revisore elencato](#reviewers) per eseguire una revisione. I propositori di richieste pull di GitHub sono inoltre incoraggiati a rivedere i propri invii.

Per aiutare con una revisione, segui i passaggi descritti in [cosa aspettarsi in una revisione](#what-to-expect-in-a-review) per verificare l'invio. Dopo aver completato la revisione, aggiungi un commento alla richiesta pull di GitHub con i tuoi risultati. Se l'invio supera la revisione, si prega di dichiararlo esplicitamente nel commento, ad esempio qualcosa del tipo "Ho esaminato questa modifica in base ai passaggi del documento CONTRIBUTING e tutto mi sembra a posto". Se non è possibile completare alcuni passaggi della revisione, indicare esplicitamente quali passaggi sono stati rivisti e quali non sono stati rivisti, ad esempio qualcosa del tipo "Non ho verificato la presenza di difetti nel codice, ma ho rivisto tutto il resto nel documento CONTRIBUTING e sembra buono".

Apprezziamo anche il test degli invii. Se il codice è stato testato, aggiungi un commento alla richiesta pull di GitHub con i risultati del tuo test: successo o fallimento. Si prega di affermare esplicitamente che il codice è stato testato e i risultati, ad esempio qualcosa del tipo "Ho testato questo codice sulla mia stampante Acme900Z con una stampa a vaso e i risultati sono stati buoni".

### Revisori

I "revisori" di Klipper sono:

| Nome | GitHub Id | Aree di interesse |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | Input shaping, test di risonanza, cinematica |
| Eric Callahan | @Arksine | Livellamento del piatto, flashing MCU |
| Kevin O'Connor | @KevinOConnor | Core motion system, codice microcontrollore |
| Paul McGowan | @mental405 | File di configurazione, documentazione |

Si prega di non eseguire il "ping" di nessuno dei revisori e di non indirizzare gli invii a loro. Tutti i revisori controllano i forum e le PR e si occuperanno delle revisioni quando ne avranno il tempo.

I "manutentori" di Klipper sono:

| Nome | nome GitHub |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## Formato dei messaggi di commit

Ogni commit dovrebbe avere un messaggio di commit formattato in modo simile al seguente:

```
modulo: Riepilogo breve (50 caratteri o meno) in maiuscolo

Testo esplicativo più dettagliato, se necessario. Incolonna a circa
75 caratteri o giù di lì. In alcuni contesti, la prima riga è trattata 
come l'oggetto di un'e-mail e il resto del testo come corpo. La
riga vuota che separa il riassunto dal corpo è critica (a meno che
non si ometta del tutto il corpo); strumenti come rebase possono
confondersi se li metti due insieme.

Ulteriori paragrafi vengono dopo le righe vuote..

Firmato da: Il mio nome <myemail@example.org>
```

Nell'esempio sopra, `module` dovrebbe essere il nome di un file o di una directory nel repository (senza un'estensione di file). Ad esempio, `clocksync: fix di errore di battitura nella chiamata pause() al momento della connessione`. Lo scopo di specificare un nome di modulo nel messaggio di commit è di aiutare a fornire il contesto per i commenti di commit.

È importante avere una riga "Signed-off-by" su ogni commit - certifica che accetti il [developer certificate of origin](developer-certificate-of-origin). Deve contenere il tuo vero nome (mi dispiace, niente pseudonimi o contributi anonimi) e contenere un indirizzo email corrente.

## Contribuire a Traduzioni Klipper

[Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) è un progetto dedicato alla traduzione di Klipper in diverse lingue. [Weblate](https://hosted.weblate.org/projects/klipper/) ospita tutte le stringhe Gettext per la traduzione e la revisione. Le impostazioni locali possono essere visualizzate su [klipper3d.org](https://www.klipper3d.org) una volta che soddisfano i seguenti requisiti:

- [ ] 75% Copertura totale
- [ ] Tutti i titoli (H1) sono tradotti
- [ ] Una gerarchia di navigazione PR aggiornata nelle traduzioni klipper.

Per ridurre la frustrazione di tradurre termini specifici del dominio e acquisire consapevolezza delle traduzioni in corso, puoi inviare un PR modificando il [Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) `readme.md `. Una volta che una traduzione è pronta, è possibile apportare la modifica corrispondente al progetto Klipper.

Se una traduzione esiste già nel repository Klipper e non soddisfa più l'elenco di controllo di cui sopra, verrà contrassegnata come obsoleta dopo un mese senza aggiornamenti.

Una volta soddisfatti i requisiti, è necessario:

1. aggiorna il repository di klipper-translations [active_translations](https://github.com/Klipper3d/klipper-translations/blob/translations/active_translations)
1. Opzionale: aggiungi un file manual-index.md nella cartella `docs\locals\<lang>` del repository klipper-translations per sostituire index.md specifico della lingua (il file index.md generato non viene visualizzato correttamente).

Problemi noti:

1. Al momento, non esiste un metodo per tradurre correttamente le immagini nella documentazione
1. È impossibile tradurre i titoli in mkdocs.yml.
