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

   Gli contributi di codice non devono contenere codice di debug eccessivo, opzioni di debug o registrazione del debug in fase di runtime.

   I commenti negli invii di codice dovrebbero concentrarsi sul miglioramento della manutenzione del codice. Gli invii non devono contenere "codice commentato" né commenti eccessivi che descrivono implementazioni passate. Non dovrebbero esserci commenti "todo" eccessivi.

   Gli aggiornamenti alla documentazione non devono dichiarare che si tratta di un "work in progress".

   1. Does the submission provide a "high impact" benefit to real-world users performing real-world tasks?Reviewers need to identify, at least in their own minds, roughly "who the target audience is", a rough scale of "the size of that audience", the "benefit" they will obtain, how the "benefit is measured", and the "results of those measurement tests". In most cases this will be obvious to both the submitter and the reviewer, and it is not explicitly stated during a review.

   Submissions to the master Klipper branch are expected to have a noteworthy target audience. As a general "rule of thumb", submissions should target a user base of at least a 100 real-world users.

   If a reviewer asks for details on the "benefit" of a submission, please don't consider it criticism. Being able to understand the real-world benefits of a change is a natural part of a review.

   When discussing benefits it is preferable to discuss "facts and measurements". In general, reviewers are not looking for responses of the form "someone may find option X useful", nor are they looking for responses of the form "this submission adds a feature that firmware X implements". Instead, it is generally preferable to discuss details on how the quality improvement was measured and what were the results of those measurements - for example, "tests on Acme X1000 printers show improved corners as seen in picture ...", or for example "print time of real-world object X on a Foomatic X900 printer went from 4 hours to 3.5 hours". It is understood that testing of this type can take significant time and effort. Some of Klipper's most notable features took months of discussion, rework, testing, and documentation prior to being merged into the master branch.

   All new modules, config options, commands, command parameters, and documents should have "high impact". We do not want to burden users with options that they can not reasonably configure nor do we want to burden them with options that don't provide a notable benefit.

   A reviewer may ask for clarification on how a user is to configure an option - an ideal response will contain details on the process - for example, "users of the MegaX500 are expected to set option X to 99.3 while users of the Elite100Y are expected to calibrate option X using procedure ...".

   If the goal of an option is to make the code more modular then prefer using code constants instead of user facing config options.

   New modules, new options, and new parameters should not provide similar functionality to existing modules - if the differences are arbitrary than it's preferable to utilize the existing system or refactor the existing code.

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


   1. I commit sono ben formati, affrontano un singolo argomento per commit e sono indipendenti?Commit messages should follow the [preferred format](#format-of-commit-messages).

   Commits must not have a merge conflict. New additions to the Klipper master branch are always done via a "rebase" or "squash and rebase". It is generally not necessary for submitters to re-merge their submission on every update to the Klipper master repository. However, if there is a merge conflict, then submitters are recommended to use `git rebase` to address the conflict.

   Each commit should address a single high-level change. Large changes should be broken up into multiple independent commits. Each commit should "stand on its own" so that tools like `git bisect` and `git revert` work reliably.

   Whitespace changes should not be mixed with functional changes. In general, gratuitous whitespace changes are not accepted unless they are from the established "owner" of the code being modified.

Klipper does not implement a strict "coding style guide", but modifications to existing code should follow the high-level code flow, code indentation style, and format of that existing code. Submissions of new modules and systems have more flexibility in coding style, but it is preferable for that new code to follow an internally consistent style and to generally follow industry wide coding norms.

It is not a goal of a review to discuss "better implementations". However, if a reviewer struggles to understand the implementation of a submission, then they may ask for changes to make the implementation more transparent. In particular, if reviewers can not convince themselves that a submission is free of defects then changes may be necessary.

As part of a review, a reviewer may create an alternate Pull Request for a topic. This may be done to avoid excessive "back and forth" on minor procedural items and thus streamline the submission process. It may also be done because the discussion inspires a reviewer to build an alternative implementation. Both situations are a normal result of a review and should not be considered criticism of the original submission.

### Helping with reviews

We appreciate help with reviews! It is not necessary to be a [listed reviewer](#reviewers) to perform a review. Submitters of GitHub Pull Requests are also encouraged to review their own submissions.

To help with a review, follow the steps outlined in [what to expect in a review](#what-to-expect-in-a-review) to verify the submission. After completing the review, add a comment to the GitHub Pull Request with your findings. If the submission passes the review then please state that explicitly in the comment - for example something like "I reviewed this change according to the steps in the CONTRIBUTING document and everything looks good to me". If unable to complete some steps in the review then please explicitly state which steps were reviewed and which steps were not reviewed - for example something like "I didn't check the code for defects, but I reviewed everything else in the CONTRIBUTING document and it looks good".

We also appreciate testing of submissions. If the code was tested then please add a comment to the GitHub Pull Request with the results of your test - success or failure. Please explicitly state that the code was tested and the results - for example something like "I tested this code on my Acme900Z printer with a vase print and the results were good".

### Reviewers

The Klipper "reviewers" are:

| Name | GitHub Id | Areas of interest |
| --- | --- | --- |
| Dmitry Butyugin | @dmbutyugin | Input shaping, resonance testing, kinematics |
| Eric Callahan | @Arksine | Bed leveling, MCU flashing |
| Kevin O'Connor | @KevinOConnor | Core motion system, Micro-controller code |
| Paul McGowan | @mental405 | Configuration files, documentation |

Please do not "ping" any of the reviewers and please do not direct submissions at them. All of the reviewers monitor the forums and PRs, and will take on reviews when they have time to.

The Klipper "maintainers" are:

| Name | GitHub name |
| --- | --- |
| Kevin O'Connor | @KevinOConnor |

## Format of commit messages

Each commit should have a commit message formatted similar to the following:

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

In the above example, `module` should be the name of a file or directory in the repository (without a file extension). For example, `clocksync: Fix typo in pause() call at connect time`. The purpose of specifying a module name in the commit message is to help provide context for the commit comments.

È importante avere una riga "Signed-off-by" su ogni commit - certifica che accetti il [developer certificate of origin](developer-certificate-of-origin). Deve contenere il tuo vero nome (mi dispiace, niente pseudonimi o contributi anonimi) e contenere un indirizzo email corrente.

## Contribuire a Traduzioni Klipper

[Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) is a project dedicated to translating Klipper to different languages. [Weblate](https://hosted.weblate.org/projects/klipper/) hosts all the Gettext strings for translating and reviewing. Locales can be displayed on [klipper3d.org](https://www.klipper3d.org) once they satisfy the following requirements:

- [ ] 75% Copertura totale
- [ ] All titles (H1) are translated
- [ ] An updated navigation hierarchy PR in klipper-translations.

Per ridurre la frustrazione di tradurre termini specifici del dominio e acquisire consapevolezza delle traduzioni in corso, puoi inviare un PR modificando il [Klipper-translations Project](https://github.com/Klipper3d/klipper-translations) `readme.md `. Una volta che una traduzione è pronta, è possibile apportare la modifica corrispondente al progetto Klipper.

Se una traduzione esiste già nel repository Klipper e non soddisfa più l'elenco di controllo di cui sopra, verrà contrassegnata come obsoleta dopo un mese senza aggiornamenti.

Once the requirements are met, you need to:

1. update klipper-tranlations repository [active_translations](https://github.com/Klipper3d/klipper-translations/blob/translations/active_translations)
1. Optional: add a manual-index.md file in klipper-translations repository's `docs\locals\<lang>` folder to replace the language specific index.md (generated index.md does not render correctly).

Known Issues:

1. Currently, there isn't a method for correctly translating pictures in the documentation
1. It is impossible to translate titles in mkdocs.yml.
