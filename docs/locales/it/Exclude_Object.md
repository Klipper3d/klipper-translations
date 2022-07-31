# Escludi oggetti

The `[exclude_object]` module allows Klipper to exclude objects while a print is in progress. To enable this feature include an [exclude_object config
section](Config_Reference.md#exclude_object) (also see the [command
reference](G-Codes.md#exclude-object) and [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.)

A differenza di altre opzioni del firmware della stampante 3D, una stampante che esegue Klipper utilizza una suite di componenti e gli utenti hanno molte opzioni tra cui scegliere. Pertanto, al fine di fornire un'esperienza utente coerente, il modulo `[exclude_object]` stabilirà un contratto o una sorta di API. Il contratto copre il contenuto del file gcode, come viene controllato lo stato interno del modulo e come tale stato viene fornito ai client.

## Panoramica del flusso di lavoro

Un tipico flusso di lavoro per la stampa di un file potrebbe essere simile a:

1. Lo slicing è completato e il file viene caricato per la stampa. Durante il caricamento, il file viene elaborato e gli indicatori `[exclude_object]` vengono aggiunti al file. In alternativa, i filtri dei dati possono essere configurati per preparare i marcatori di esclusione degli oggetti in modo nativo o nella propria fase di pre-elaborazione.
1. All'avvio della stampa, Klipper ripristinerà `[exclude_object]` [status](Status_Reference.md#exclude_object).
1. Quando Klipper elabora il blocco `EXCLUDE_OBJECT_DEFINE`, aggiornerà lo stato con gli oggetti conosciuti e lo passerà ai client.
1. Il client può utilizzare tali informazioni per presentare un'interfaccia all'utente in modo che sia possibile tenere traccia dei progressi. Klipper aggiornerà lo stato per includere l'oggetto attualmente in stampa che il client può utilizzare per scopi di visualizzazione.
1. Se l'utente richiede la cancellazione di un oggetto, il client invierà un comando `EXCLUDE_OBJECT NAME=<nome>` a Klipper.
1. Quando Klipper elabora il comando, aggiungerà l'oggetto all'elenco degli oggetti esclusi e aggiornerà lo stato per i client.
1. Il client riceverà lo stato aggiornato da Klipper e potrà utilizzare tali informazioni per aggiornare lo stato dell'oggetto nell'interfaccia utente.
1. Al termine della stampa, lo stato `[exclude_object]` continuerà a essere disponibile fino a quando un'altra azione non lo reimposta.

## Il file GCode

L'elaborazione specializzata del gcode necessaria per supportare l'esclusione di oggetti non rientra negli obiettivi di progettazione principali di Klipper. Pertanto, questo modulo richiede che il file venga elaborato prima di essere inviato a Klipper per la stampa. L'utilizzo di uno script di post-elaborazione nello slicer o il middleware che elabora il file durante il caricamento sono due possibilità per preparare il file per Klipper. Uno script di post-elaborazione di riferimento è disponibile sia come eseguibile che come libreria Python, vedere [cancelobject-preprocessor](https://github.com/kageurufu/cancelobject-preprocessor).

### Definizioni di oggetti

Il comando `EXCLUDE_OBJECT_DEFINE` viene utilizzato per fornire un riepilogo di ogni oggetto nel file gcode da stampare. Fornisce un riepilogo di un oggetto nel file. Gli oggetti non hanno bisogno di essere definiti per essere referenziati da altri comandi. Lo scopo principale di questo comando è fornire informazioni all'interfaccia utente senza dover analizzare l'intero file gcode.

Le definizioni degli oggetti sono denominate per consentire agli utenti di selezionare facilmente un oggetto da escludere e possono essere forniti metadati aggiuntivi per consentire la visualizzazione grafica dell'annullamento. I metadati attualmente definiti includono una coordinata X,Y "CENTRO" e un elenco "POLYGON" di punti X,Y che rappresentano un contorno minimo dell'oggetto. Potrebbe trattarsi di un semplice riquadro di delimitazione o di uno guscio complicato per mostrare visualizzazioni più dettagliate degli oggetti stampati. Soprattutto quando i file gcode includono più parti con regioni di delimitazione sovrapposte, i punti centrali diventano difficili da distinguere visivamente. `POLYGONS` deve essere un array compatibile con json di tuple punto `[X,Y]` senza spazi. Ulteriori parametri verranno salvati come stringhe nella definizione dell'oggetto e forniti negli aggiornamenti di stato.

`EXCLUDE_OBJECT_DEFINE NAME=calibration_pyramid CENTER=50,50 POLYGON=[[40,40],[50,60],[60,40]]`

All available G-Code commands are documented in the [G-Code
Reference](./G-Codes.md#excludeobject)

## Informazioni sullo stato

The state of this module is provided to clients by the [exclude_object
status](Status_Reference.md#exclude_object).

Lo stato viene ripristinato quando:

- Il firmware di Klipper viene riavviato.
- C'è un reset della `[virtual_sdcard]`. In particolare, questo viene ripristinato da Klipper all'inizio di una stampa.
- Quando viene emesso un comando `EXCLUDE_OBJECT_DEFINE RESET=1`.

L'elenco degli oggetti definiti è rappresentato nel campo di stato `exclude_object.objects`. In un file gcode ben definito, questo sarà fatto con i comandi `EXCLUDE_OBJECT_DEFINE` all'inizio del file. Ciò fornirà ai client i nomi e le coordinate degli oggetti in modo che l'interfaccia utente possa fornire una rappresentazione grafica degli oggetti, se lo si desidera.

Man mano che la stampa procede, il campo di stato `exclude_object.current_object` verrà aggiornato mentre Klipper elabora i comandi `EXCLUDE_OBJECT_START` e `EXCLUDE_OBJECT_END`. Il campo `oggetto_corrente` sarà impostato anche se l'oggetto è stato escluso. Gli oggetti non definiti contrassegnati con un `EXCLUDE_OBJECT_START` verranno aggiunti agli oggetti conosciuti per facilitare i suggerimenti dell'interfaccia utente, senza metadati aggiuntivi.

Quando vengono emessi i comandi `EXCLUDE_OBJECT`, l'elenco degli oggetti esclusi viene fornito nell'array `exclude_object.excluded_objects`. Poiché Klipper guarda avanti per elaborare il prossimo gcode, potrebbe esserci un ritardo tra l'emissione del comando e l'aggiornamento dello stato.
