# Rotation distance

I driver per motori passo-passo su Klipper richiedono un parametro `rotation_distance` in ciascuna [stepper config section](Config_Reference.md#stepper). La `distanza_rotazione` è la distanza percorsa dall'asse con un giro completo del motore passo-passo relativo. Questo documento descrive come configurare questo valore.

## Ottenere rotation_distance da steps_per_mm (o step_distance)

I progettisti della tua stampante 3d hanno originariamente calcolato `steps_per_mm` da una distanza di rotazione. Se conosci i passi_per_mm, è possibile utilizzare questa formula generale per ottenere la distanza di rotazione originale:

```
rotation_distance = <passi_completi_per_rotazione> * <micropassi> / <passi_per_mm>
```

Oppure, se hai una configurazione di Klipper precedente e conosci il parametro `step_distance` puoi usare questa formula:

```
rotation_distance = <passi_completi_per_rotazione> * <micropassi> * <distanza_passo>
```

L'impostazione `<full_steps_per_rotation>` è determinata dal tipo di motore passo-passo. La maggior parte dei motori passo-passo sono "passi passo a 1,8 gradi" e quindi hanno 200 passi completi per rotazione (360 diviso 1,8 fa 200). Alcuni motori passo passo sono "passo passo a 0,9 gradi" e quindi hanno 400 passi completi per rotazione. Altri motori passo-passo sono rari. In caso di dubbi, non impostare full_steps_per_rotation nel file di configurazione e utilizzare 200 nella formula sopra.

L'impostazione `<microsteps>` è determinata dal driver del motore passo-passo. La maggior parte dei driver utilizza 16 micropassi. Se non sei sicuro, imposta `microsteps: 16` nella configurazione e usa 16 nella formula sopra.

Quasi tutte le stampanti dovrebbero avere un numero intero per `rotation_distance` sugli assi di tipo X, Y e Z. Se la formula precedente risulta in una distanza_rotazione che è entro .01 da un numero intero, arrotonda il valore finale a quel numero_intero.

## Calibrazione rotation_distance sugli estrusori

Su un estrusore, la `rotation_distance` è la distanza percorsa dal filamento per una rotazione completa del motore passo-passo. Il modo migliore per ottenere un valore accurato per questa impostazione è utilizzare una procedura di "misura e ritaglio".

Innanzitutto inizia con un'ipotesi iniziale per la distanza di rotazione. Questo può essere ottenuto da [steps_per_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance) o [ispezionando l'hardware](#extruder).

Quindi utilizzare la seguente procedura per "misurare e tagliare":

1. Assicurati che l'estrusore contenga del filamento, che l'hotend sia riscaldato a una temperatura appropriata e che la stampante sia pronta per l'estrusione.
1. Utilizzare un pennarello per posizionare un segno sul filamento a circa 70 mm dall'ingresso del corpo dell'estrusore. Quindi usa un calibro digitale per misurare la distanza effettiva di quel segno nel modo più preciso possibile. Nota questo come `<initial_mark_distance>`.
1. Estrudere 50 mm di filamento con la seguente sequenza di comandi: `G91` seguito da `G1 E50 F60`. Nota 50 mm come `<distanza_estrusione_richiesta>`. Attendi che l'estrusore finisca il movimento (ci vorranno circa 50 secondi). È importante utilizzare la velocità di estrusione lenta per questo test poiché una velocità più elevata può causare una pressione elevata nell'estrusore che distorce i risultati. (Non utilizzare il "pulsante estrudi" sui front-end grafici per questo test poiché si estrudono a una velocità elevata.)
1. Utilizzare un calibro digitale per misurare la nuova distanza tra il corpo dell'estrusore e il segno sul filamento. Annota questa come `<subsequent_mark_distance>`. Quindi calcola: `actual_extrude_distance = <initial_mark_distance> - <subsequent_mark_distance>`
1. Calcola rotation_distance come: `rotation_distance = <rotation_distance_precedente> * <actual_extrude_distance> / <requested_extrude_distance>` Arrotonda la nuova rotation_distance a tre cifre decimali.

Se la distanza_di_estrusione effettiva differisce dalla distanza_di_estrusione richiesta di oltre 2 mm circa, è una buona idea eseguire i passaggi precedenti una seconda volta.

Nota: *non* utilizzare un metodo di tipo "misura e ritaglia" per calibrare gli assi di tipo x, y o z. Il metodo "misura e taglia" non è sufficientemente accurato per quegli assi e probabilmente porterà a una configurazione peggiore. Invece, se necessario, quegli assi possono essere determinati [measuring the belts, pulleys, and lead screw hardware](#obtaining-rotation_distance-by-inspecting-the-hardware).

## Ottenere la rotation_distance ispezionando l'hardware

E' possibile calcolare rotation_distance conoscendo i motori passo-passo e la cinematica della stampante. Questo può essere utile se i passi_per_mm non sono noti o se si sta progettando una nuova stampante.

### Assi con trasmissione a cinghia

È facile calcolare rotation_distance per un asse lineare che utilizza una cinghia e una puleggia.

Per prima cosa determinare il tipo di cinghia. La maggior parte delle stampanti utilizza un passo della cinghia di 2 mm (ovvero, ogni dente sulla cinghia è a 2 mm di distanza). Quindi contare il numero di denti sulla puleggia del motore passo-passo. La distanza_rotazione viene quindi calcolata come:

```
rotation_distance = <passo_cinghia> * <numero_di_denti_sulla_puleggia>
```

Ad esempio, se una stampante ha una cinghia da 2 mm e utilizza una puleggia con 20 denti, la distanza di rotazione è 40.

### Assi con vite di comando

È facile calcolare la rotation_distance per le comuni viti di trasmissione utilizzando la seguente formula:

```
rotation_distance = <passo_vite> * <numero_di_filetti_separati>
```

Ad esempio, la comune "madrevite T8" ha una rotation distance di 8 (ha un passo di 2 mm e ha 4 filetti separati).

Le stampanti più vecchie con "barre filettate" hanno un solo "filo" sulla vite di comando e quindi la rotation distance è il passo della vite. (Il passo della vite è la distanza tra ciascuna scanalatura sulla vite.) Quindi, ad esempio, un'asta metrica M6 ha una rotation distance di 1 e un'asta M8 ha una rotation distance di 1,25.

### Estrusore

È possibile ottenere una distanza di rotazione iniziale per gli estrusori misurando il diametro del "bullone dentato" che spinge il filamento e utilizzando la seguente formula: `rotation_distance = <diametro> * 3.14`

Se l'estrusore utilizza ingranaggi, sarà anche necessario [determinare e impostare gear_ratio](#using-a-gear_ratio) per l'estrusore.

La rotation distance effettiva su un estrusore varierà da stampante a stampante, perché la presa del "bullone dentato" che impegna il filamento può variare. Può anche variare tra le bobine di filamento. Dopo aver ottenuto una rotation distance iniziale, utilizzare la [procedura di misurazione e ritaglio](#calibrazione-distanza_rotazione-su-estrusori) per ottenere un'impostazione più accurata.

## Usando un gear_ratio

L'impostazione di un `gear_ratio` può semplificare la configurazione di `rotation_distance` su stepper a cui è collegato un gear box (o simile). La maggior parte degli stepper non ha un gear box - se non sei sicuro, non impostare `gear_ratio` nella configurazione.

Quando `gear_ratio` è impostato, `rotation_distance` rappresenta la distanza percorsa dall'asse con una rotazione completa dell'ingranaggio finale sulla scatola ingranaggi. Se, ad esempio, si utilizza un riduttore con un rapporto "5:1", è possibile calcolare la distanza_rotazione con [conoscenza dell'hardware](#obtaining-rotation_distance-by-inspecting-the-hardware) e quindi aggiungere ` gear_ratio: 5:1` alla configurazione.

Per gli ingranaggi realizzati con cinghie e pulegge, è possibile determinare il gear_ratio contando i denti sulle pulegge. Ad esempio, se uno stepper con una puleggia a 16 denti guida la puleggia successiva con 80 denti, si utilizzerà `gear_ratio: 80:16`. In effetti, si potrebbe aprire una comune "scatola del cambio" pronta all'uso e contare i denti al suo interno per confermare il suo rapporto di trasmissione.

Si noti che a volte un gear-box avrà un rapporto di trasmissione leggermente diverso da quello in cui è pubblicizzato. I comuni ingranaggi del motore dell'estrusore BMG ne sono un esempio: sono pubblicizzati come "3:1" ma in realtà utilizzano ingranaggi "50:17". (L'uso di numeri di denti senza un denominatore comune può migliorare l'usura complessiva degli ingranaggi poiché i denti non sempre ingranano allo stesso modo ad ogni giro.) Il comune "riduttore epicicloidale 5.18:1" è configurato in modo più accurato con `gear_ratio: 57:11 `.

Se su un asse vengono utilizzati più ingranaggi, è possibile fornire un elenco separato da virgole nel gear_ratio. Ad esempio, un cambio "5:1" che guida una puleggia da 16 a 80 denti potrebbe utilizzare `gear_ratio: 5:1, 80:16`.

Nella maggior parte dei casi, gear_ratio dovrebbe essere definito con numeri interi poiché ingranaggi e pulegge comuni hanno un numero intero di denti su di essi. Tuttavia, nei casi in cui una cinghia aziona una puleggia usando l'attrito invece dei denti, può avere senso utilizzare un numero in virgola mobile nel rapporto di trasmissione (ad esempio, `gear_ratio: 107.237:16`).
