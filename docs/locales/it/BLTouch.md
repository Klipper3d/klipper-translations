# BL-Touch

## Collegare BL-Touch

Attenzione **warning** prima di cominciare : Evita di toccare la punta del BL-Touch a mani nude, è molto sensibili al sebo delle dita. Se sei costretto usa dei guanti ed evita di spingerla o piegarla.

Collega il connettore "servo" BL-Touch a un `control_pin` secondo la documentazione BL-Touch o la documentazione MCU. Usando il cablaggio originale, il filo giallo del triplo è il `control_pin` e il filo bianco della coppia è il `sensor_pin`. È necessario configurare questi pin in base al cablaggio. La maggior parte dei dispositivi BL-Touch richiede un pullup sul pin del sensore (prefissare il nome del pin con "^"). Per esempio:

```
[bltouch]
sensor_pin: ^P1.24
control_pin: P1.26
```

Se il BL-Touch verrà utilizzato per l'home dell'asse Z, impostare `endstop_pin: probe:z_virtual_endstop` e rimuovere `position_endstop` nella sezione di configurazione `[stepper_z]`, quindi aggiungere una sezione di configurazione `[safe_z_home]` per aumentare il asse z, posiziona gli assi xy, spostati al centro del letto e posizionati sull'asse z. Per esempio:

```
[safe_z_home]
home_xy_position: 100, 100 # Cambiare le coordinate per il centro del tuo piatto
speed: 50
z_hop: 10                 # Move up 10mm
z_hop_speed: 5
```

È importante che il movimento z_hop in safe_z_home sia sufficientemente alto in mode che la sonda non colpisca nulla anche se il pin della sonda si trova nel suo stato più basso.

## Test iniziali

Prima di proseguire, verificare che il BL-Touch sia montato all'altezza corretta, il perno dovrebbe trovarsi a circa 2 mm sopra il nozzle quando è retratto

Quando si accende la stampante, la sonda BL-Touch dovrebbe eseguire un autotest e spostare il pin su e giù un paio di volte. Una volta completato l'autotest, il perno deve essere retratto e il LED rosso sulla sonda deve essere acceso. In caso di errori, ad esempio la sonda lampeggia in rosso o il pin è in basso anziché in alto, spegnere la stampante e controllare il cablaggio e la configurazione.

Se quanto sopra sembra buono, è il momento di verificare che il pin di controllo funzioni correttamente. Per prima cosa esegui `BLTOUCH_DEBUG COMMAND=pin_down` nel terminale della tua stampante. Verificare che il pin si abbassi e che il LED rosso sulla sonda si spenga. In caso contrario, controllare nuovamente il cablaggio e la configurazione. Quindi emettere un `BLTOUCH_DEBUG COMMAND=pin_up`, verificare che il pin si muova verso l'alto e che la luce rossa si accenda di nuovo. Se lampeggia allora c'è qualche problema.

Il passaggio successivo è confermare che il pin del sensore funzioni correttamente. Esegui `BLTOUCH_DEBUG COMMAND=pin_down`, verifica che il pin si sposti verso il basso, esegui `BLTOUCH_DEBUG COMMAND=touch_mode`, esegui `QUERY_PROBE` e verifica che il comando riporti "probe: open". Quindi, spingendo leggermente verso l'alto il perno con l'unghia del dito, eseguire nuovamente `QUERY_PROBE`. Verificare che il comando riporti "probe: TRIGGERED". Se una delle query non riporta il messaggio corretto, di solito indica un cablaggio o una configurazione errati (sebbene alcuni [clones](#bl-touch-clones) potrebbero richiedere una gestione speciale). Al completamento di questo test, eseguire `BLTOUCH_DEBUG COMMAND=pin_up` e verificare che il pin si muova verso l'alto.

Dopo aver completato i test del pin di controllo BL-Touch e del pin del sensore, è ora il momento di testare il rilevamento, ma con una svolta. Invece di lasciare che il perno della sonda tocchi il piano di stampa, lascia che tocchi l'unghia del dito. Posizionare la testina lontano dal letto, emettere un `G28` (o `PROBE` se non si utilizza probe:z_virtual_endstop), attendere che la testina inizi a muoversi verso il basso e interrompere il movimento toccando molto delicatamente il perno con l'unghia. Potrebbe essere necessario farlo due volte, poiché la configurazione di homing predefinita esegue due sonde. Preparati a spegnere la stampante se non si ferma quando tocchi il perno.

Se ha avuto successo, esegui un altro `G28` (o `PROBE`) ma questa volta lascia che tocchi il letto come dovrebbe.

## BL-Touch andato male

Una volta che il BL-Touch è in uno stato incoerente, inizia a lampeggiare in rosso. Puoi forzarlo a lasciare quello stato emettendo:

BLTOUCH_DEBUG COMMAND=reset

Ciò può accadere se la sua calibrazione viene interrotta dal blocco dell'estrazione della sonda.

Tuttavia, anche il BL-Touch potrebbe non essere più in grado di calibrarsi. Ciò accade se la vite sulla sua sommità è nella posizione sbagliata o se il nucleo magnetico all'interno del perno della sonda si è spostato. Se si è alzato in modo che si attacchi alla vite, potrebbe non essere più in grado di abbassare il perno. Con questo comportamento è necessario aprire la vite e utilizzare una penna a sfera per spingerla delicatamente in posizione. Reinserire il perno nel BL-Touch in modo che cada nella posizione estratta. Riposizionare con cura la vite senza testa in posizione. È necessario trovare la posizione giusta in modo che sia in grado di abbassare e alzare il perno e la luce rossa si accende e si spegne. Usa i comandi `reset`, `pin_up` e `pin_down` per raggiungere questo obiettivo.

## BL-Touch "cloni"

Molti dispositivi "clone" BL-Touch funzionano correttamente con Klipper utilizzando la configurazione predefinita. Tuttavia, alcuni dispositivi "clone" potrebbero non supportare il comando `QUERY_PROBE` e alcuni dispositivi "clone" potrebbero richiedere la configurazione di `pin_up_reports_not_triggered` o `pin_up_touch_mode_reports_triggered`.

Importante! Non configurare `pin_up_reports_not_triggered` o `pin_up_touch_mode_reports_triggered` su False senza prima seguire queste indicazioni. Non configurare nessuno di questi su False su un BL-Touch originale. Un'impostazione errata di questi valori su False può aumentare il tempo di ispezione e può aumentare il rischio di danneggiare la stampante.

Alcuni dispositivi "clone" non supportano `touch_mode` e di conseguenza il comando `QUERY_PROBE` non funziona. Nonostante ciò, potrebbe essere ancora possibile eseguire il rilevamento e l'homing con questi dispositivi. Su questi dispositivi il comando `QUERY_PROBE` durante i [initial tests](#initial-tests) non avrà esito positivo, tuttavia il successivo test `G28` (o `PROBE`) riesce. Potrebbe essere possibile utilizzare questi dispositivi "clone" con Klipper se non si utilizza il comando `QUERY_PROBE` e se non si abilita la funzione `probe_with_touch_mode`.

Alcuni dispositivi "clone" non sono in grado di eseguire il test di verifica del sensore interno di Klipper. Su questi dispositivi, i tentativi di home o probe possono far sì che Klipper riporti un errore "BLTouch non è riuscito a verificare lo stato del sensore". In tal caso, eseguire manualmente i passaggi per verificare che il pin del sensore funzioni come descritto nella [initial tests section](#initial-tests). Se i comandi `QUERY_PROBE` in quel test producono sempre i risultati attesi e si verificano ancora gli errori "BLTouch non è riuscito a verificare lo stato del sensore", potrebbe essere necessario impostare `pin_up_touch_mode_reports_triggered` su False nel file di configurazione di Klipper.

Un raro numero di vecchi dispositivi "clone" non è in grado di segnalare quando hanno sollevato con successo la sonda. Su questi dispositivi Klipper segnalerà un errore "BLTouch non è riuscito a sollevare la sonda" dopo ogni tentativo di home o probe. Si può testare questi dispositivi: spostare la testa lontano dal letto, eseguire `BLTOUCH_DEBUG COMMAND=pin_down`, verificare che il pin si sia spostato verso il basso, eseguire `QUERY_PROBE`, verificare che il comando riporti "probe: open", eseguire `BLTOUCH_DEBUG COMMAND= pin_up`, verifica che il pin sia stato spostato in alto ed esegui `QUERY_PROBE`. Se il pin rimane attivo, il dispositivo non entra in uno stato di errore e la prima query riporta "probe: open" mentre la seconda query riporta "probe: TRIGGERED", quindi indica che `pin_up_reports_not_triggered` dovrebbe essere impostato su False in Klipper file di configurazione.

## BL-Touch v3

Alcuni dispositivi BL-Touch v3.0 e BL-Touch 3.1 potrebbero richiedere la configurazione di `probe_with_touch_mode` nel file di configurazione della stampante.

Se il BL-Touch v3.0 ha il cavo del segnale collegato a un pin endstop (con un condensatore di filtraggio del rumore), il BL-Touch v3.0 potrebbe non essere in grado di inviare un segnale in modo coerente durante l'homing e il probe. Se i comandi `QUERY_PROBE` nella [initial tests section](#initial-tests) producono sempre i risultati attesi, ma il toolhead non si ferma sempre durante i comandi G28/PROBE, allora è indicativo di questo problema. Una soluzione alternativa consiste nell'impostare `probe_with_touch_mode: True` nel file di configurazione.

Il BL-Touch v3.1 potrebbe entrare erroneamente in uno stato di errore dopo un tentativo di probe riuscito. I sintomi sono una luce lampeggiante occasionale sul BL-Touch v3.1 che dura per un paio di secondi dopo che è entrato in contatto con successo con il letto. Klipper dovrebbe cancellare questo errore automaticamente ed è generalmente innocuo. Tuttavia, è possibile impostare `probe_with_touch_mode` nel file di configurazione per evitare questo problema.

Importante! Alcuni dispositivi "clone" e BL-Touch v2.0 (e precedenti) potrebbero avere una precisione ridotta quando `probe_with_touch_mode` è impostato su True. L'impostazione su True aumenta anche il tempo necessario per distribuire la sonda. Se si configura questo valore su un dispositivo BL-Touch "clone" o precedente, assicurarsi di testare l'accuratezza della sonda prima e dopo aver impostato questo valore (utilizzare il comando `PROBE_ACCURACY` per eseguire il test).

## Multi-sondaggio senza riporre

Per impostazione predefinita, Klipper rilascia la sonda all'inizio di ogni tentativo di sonda e poi riporrà la sonda in seguito. Questo dispiegamento e stivaggio ripetitivo della sonda può aumentare il tempo totale delle sequenze di calibrazione che coinvolgono molte misurazioni della sonda. Klipper consente di lasciare la sonda dispiegata tra test consecutivi, il che può ridurre il tempo totale di rilevamento. Questa modalità è abilitata configurando `stow_on_each_sample` su False nel file di configurazione.

Importante! L'impostazione di `stow_on_each_sample` su False può portare Klipper a fare movimenti orizzontali della testa utensile mentre la sonda è estesa. Assicurarsi di verificare che tutte le operazioni con la probe abbiano un gioco Z sufficiente prima di impostare questo valore su False. Se lo spazio libero è insufficiente, uno spostamento orizzontale può causare l'intrappolamento del perno in un'ostruzione e causare danni alla stampante.

Importante! Si consiglia di utilizzare `probe_with_touch_mode` configurato su True quando si utilizza `stow_on_each_sample` configurato su False. Alcuni dispositivi "clone" potrebbero non rilevare un successivo contatto con il piatto se `probe_with_touch_mode` non è impostato. Su tutti i dispositivi, l'utilizzo della combinazione di queste due impostazioni semplifica la segnalazione del dispositivo, che può migliorare la stabilità generale.

Si noti, tuttavia, che alcuni dispositivi "clone" e BL-Touch v2.0 (e precedenti) potrebbero avere una precisione ridotta quando `probe_with_touch_mode` è impostato su True. Su questi dispositivi è una buona idea testare l'accuratezza della sonda prima e dopo aver impostato `probe_with_touch_mode` (usare il comando di test `PROBE_ACCURACY`).

## Calibrazione degli offset BL-Touch

Seguire le istruzioni nella guida [Probe Calibrate](Probe_Calibrate.md) per impostare i parametri di configurazione x_offset, y_offset e z_offset.

È una buona idea verificare che l'offset Z sia vicino a 1 mm. In caso contrario, probabilmente vorrai spostare la sonda su o giù per risolvere il problema. Si desidera che si attivi ben prima che l'ugello colpisca il piatto, in modo che un possibile filamento bloccato o un piatto deformato non influisca sull'azione della sonda. Ma allo stesso tempo, si desidera che la posizione retratta sia il più possibile al di sopra dell'ugello per evitare che tocchi le parti stampate. Se viene effettuata una regolazione della posizione della sonda, eseguire nuovamente i passaggi di calibrazione della sonda.

## Modalità di output BL-Touch


   * Un BL-Touch V3.0 supporta l'impostazione di una modalità di uscita 5V o OPEN-DRAIN, un BL-Touch V3.1 supporta anche questo, ma può anche memorizzarlo nella sua EEPROM interna. Se la tua scheda controller ha bisogno del livello logico alto 5V fisso della modalità 5V, puoi impostare il parametro 'set_output_mode' nella sezione [bltouch] del file di configurazione della stampante su "5V".*** Utilizzare la modalità 5V solo se la linea di ingresso della scheda controller è tollerante a 5V. Ecco perché la configurazione di default di queste versioni BL-Touch è la modalità OPEN-DRAIN. Potresti potenzialmente danneggiare la CPU delle tue schede di controllo ***

   Quindi: se una scheda controller HA BISOGNO della modalità 5V ED è tollerante a 5V sulla sua linea del segnale di ingresso E se

   - si dispone di un BL-Touch Smart V3.0, è necessario utilizzare il parametro 'set_output_mode: 5V' per garantire questa impostazione ad ogni avvio, poiché la sonda non ricorda l'impostazione necessaria.
   - hai un BL-Touch Smart V3.1, puoi scegliere di usare 'set_output_mode: 5V' o memorizzare la modalità una volta usando un comando 'BLTOUCH_STORE MODE=5V' manualmente e NON usando il parametro 'set_output_mode:'.
   - hai qualche altra sonda: alcune sonde hanno una traccia sul circuito stampato da tagliare o un ponticello da impostare per impostare (permanentemente) la modalità di uscita. In tal caso, omettere completamente il parametro 'set_output_mode'.
Se hai una V3.1, non automatizzare o ripetere la memorizzazione della modalità di output per evitare di consumare la EEPROM della sonda. La BLTouch EEPROM è valida per circa 100.000 aggiornamenti. 100 memorizzazioni al giorno aggiungerebbero fino a circa 3 anni di attività prima di logorarlo. Pertanto, la memorizzazione della modalità di output in una V3.1 è progettata dal fornitore per essere un'operazione complicata (l'impostazione predefinita di fabbrica è una modalità OPEN DRAIN sicura) e non è adatta per essere emessa ripetutamente da qualsiasi slicer, macro o altro, esso è preferibilmente da utilizzare solo quando si integra per la prima volta la sonda nell'elettronica di una stampante.
