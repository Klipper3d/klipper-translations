# Esempi di configurazioni

Questo documento contiene le linee guida per contribuire a creare un esempio di configurazione di Klipper nella repository github di Klipper (situato nella [directory config](../config/)).

Nota che il [server Klipper Community Discourse](https://community.klipper3d.org) è anche una risorsa utile per trovare e condividere file di configurazione.

## Linee guida

1. Seleziona il prefisso del nome del file di configurazione appropriato:
   1. Il prefisso `printer` viene utilizzato per le stampanti stock vendute da un produttore tradizionale.
   1. Il prefisso `generic` viene utilizzato per una scheda per stampante 3d che può essere utilizzata in molti diversi tipi di stampanti.
   1. Il prefisso `kit` è per le stampanti 3d assemblate secondo una specifica ampiamente utilizzata. Queste stampanti "kit" sono generalmente distinte dalle normali "stampanti" in quanto non sono vendute da un produttore.
   1. Il prefisso `sample` viene utilizzato per i "ritagli" di configurazione che è possibile copiare e incollare nel file di configurazione principale.
   1. Il prefisso `example` viene utilizzato per descrivere la cinematica della stampante. Questo tipo di configurazione viene in genere aggiunto solo insieme al codice per un nuovo tipo di cinematica della stampante.
1. Tutti i file di configurazione devono terminare con un suffisso `.cfg`. I file di configurazione della `stampante` devono terminare con un anno seguito da `.cfg` (ad es. `-2019.cfg`). In questo caso, l'anno è un anno approssimativo in cui è stata venduta la stampante specificata.
1. Non utilizzare spazi o caratteri speciali nel nome del file di configurazione. Il nome del file deve contenere solo i caratteri `A-Z`, `a-z`, `0-9`, `-` e `.`.
1. Klipper deve essere in grado di avviare il file di configurazione di esempio `printer`, `generic` e `kit` senza errori. Questi file di configurazione devono essere aggiunti al test di regressione [test/klippy/printers.test](../test/klippy/printers.test). Aggiungi nuovi file di configurazione a quel test case nella sezione appropriata e in ordine alfabetico all'interno di quella sezione.
1. La configurazione di esempio dovrebbe essere per la configurazione "stock" della stampante. (Ci sono troppe configurazioni "personalizzate" da tenere traccia nel repository principale di Klipper.) Allo stesso modo, aggiungiamo solo file di configurazione di esempio per stampanti, kit e schede che hanno la popolarità principale (ad esempio, dovrebbero essercene almeno 100 in uso attivo). Prendi in considerazione l'utilizzo del [server Klipper Community Discourse](https://community.klipper3d.org) per altre configurazioni.
1. Only specify those devices present on the given printer or board. Do not specify settings specific to your particular setup.
   1. For `generic` config files, only those devices on the mainboard should be described. For example, it would not make sense to add a display config section to a "generic" config as there is no way to know if the board will be attached to that type of display. If the board has a specific hardware port to facilitate an optional peripheral (eg, a bltouch port) then one can add a "commented out" config section for the given device.
   1. Non specificare `pressure_advance` in una configurazione di esempio, poiché quel valore è specifico del filamento, non dell'hardware della stampante. Allo stesso modo, non specificare le impostazioni `max_extrude_only_velocity` né `max_extrude_only_accel`.
   1. Non specificare una sezione di configurazione contenente un percorso host o hardware host. Ad esempio, non specificare le sezioni di configurazione `[virtual_sdcard]` né `[temperature_host]`.
   1. Definire solo le macro che utilizzano funzionalità specifiche per la stampante specificata o per definire i G-code comunemente emessi dagli slicer configurati per la stampante specificata.
1. Where possible, it is best to use the same wording, phrasing, indentation, and section ordering as the existing config files.
   1. The top of each config file should list the type of micro-controller the user should select during "make menuconfig". It should also have a reference to "docs/Config_Reference.md".
   1. Non copiare la documentazione sul campo nei file di configurazione di esempio. (In questo modo si crea un onere di manutenzione poiché un aggiornamento della documentazione richiederebbe quindi la modifica in molti punti.)
   1. I file di configurazione di esempio non devono contenere una sezione "SAVE_CONFIG". Se necessario, copiare i campi rilevanti dalla sezione SAVE_CONFIG alla sezione appropriata nell'area di configurazione principale.
   1. Usa la sintassi `field: value` invece di `field=value`.
   1. Quando si aggiunge la `rotation_distance`a un estrusore è preferibile specificare un `gear_ratio` se l'estrusore ha un meccanismo di ingranaggi. Ci aspettiamo che la rotation_distance nelle configurazioni di esempio sia correlata alla circonferenza dell'ingranaggio nell'estrusore: normalmente è nell'intervallo da 20 a 35 mm. Quando si specifica un `gear_ratio` è preferibile specificare gli ingranaggi effettivi sul meccanismo (ad esempio, preferire `gear_ratio: 80:20` su `gear_ratio: 4:1`). Per ulteriori informazioni, vedere il [documento sulla distanza di rotazione](Rotation_Distance.md#using-a-gear_ratio).
   1. Evitare di definire valori di campo impostati sul valore predefinito. Ad esempio, non si dovrebbe specificare `min_extrude_temp: 170` poiché questo è già il valore predefinito.
   1. Ove possibile, le righe non devono superare le 80 colonne.
   1. Evita di aggiungere messaggi di attribuzione o revisione ai file di configurazione. (Ad esempio, evita di aggiungere righe come "questo file è stato creato da...".) Inserisci l'attribuzione e cambia la cronologia nel messaggio di commit git.
1. Non utilizzare alcuna funzionalità deprecata nel file di configurazione di esempio.
1. Non disabilitare un sistema di sicurezza predefinito in un file di configurazione di esempio. Ad esempio, una configurazione non dovrebbe specificare una `max_extrude_cross_section` personalizzata. Non abilitare le funzionalità di debug. Ad esempio, non dovrebbe esserci una sezione di configurazione `force_move`.
1. Tutte le schede note supportate da Klipper possono utilizzare la velocità di trasmissione seriale predefinita di 250000. Non consigliare una velocità di trasmissione diversa in un file di configurazione di esempio.

I file di configurazione di esempio vengono inviati creando una "richiesta pull" di github. Si prega di seguire anche le indicazioni nel [documento per contributi](CONTRIBUTING.md).
