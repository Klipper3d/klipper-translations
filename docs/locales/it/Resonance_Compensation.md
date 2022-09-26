# Compensazione della risonanza

Klipper supporta Input Shaping, una tecnica che può essere utilizzata per ridurre il ringing (noti anche come echoing, ghosting o increspature) nelle stampe. Il ringing è un difetto di stampa della superficie quando, in genere, elementi come i bordi si ripetono su una superficie stampata come un sottile "eco":

|![Ringing test](img/ringing-test.jpg)|![3D Benchy](img/ringing-3dbenchy.jpg)|

I ringing sono causati da vibrazioni meccaniche nella stampante dovute a rapidi cambiamenti della direzione di stampa. Si noti che il ringing di solito ha origini meccaniche: telaio della stampante non sufficientemente rigido, cinghie non tese o troppo elastiche, problemi di allineamento delle parti meccaniche, massa in movimento pesante, ecc. Questi dovrebbero essere prima controllati e riparati, se possibile.

[Input shaping](https://en.wikipedia.org/wiki/Input_shaping) è una tecnica di controllo ad anello aperto che crea un segnale di comando che annulla le proprie vibrazioni. La modellatura dell'ingresso richiede alcune regolazioni e misurazioni prima di poter essere abilitata. Oltre al ringing, Input Shaping riduce in genere le vibrazioni e le vibrazioni della stampante in generale e può anche migliorare l'affidabilità della modalità StealthChop dei driver stepper Trinamic.

## Messa a punto

Basic tuning requires measuring the ringing frequencies of the printer by printing a test model.

Carica il modello di prova per il ringing, che può essere trovato in [docs/prints/ringing_tower.stl](prints/ringing_tower.stl), nello slicer:

* L'altezza dello strato (layer) consigliata è 0,2 o 0,25 mm.
* I livelli di riempimento e superiori possono essere impostati su 0.
* Usa 1-2 perimetri, o meglio ancora la modalità vaso liscio con base da 1-2 mm.
* Utilizzare velocità sufficientemente elevate, circa 80-100 mm/sec, per i perimetri **esterni**.
* Assicurati che il tempo minimo per lo strato sia **al massimo** 3 secondi.
* Assicurati che qualsiasi "controllo dinamico dell'accelerazione" sia disabilitato nello slicer.
* Non girare il modello. Il modello ha segni X e Y sul retro del modello. Nota la posizione insolita dei segni rispetto agli assi della stampante: non è un errore. I contrassegni possono essere utilizzati successivamente nel processo di ottimizzazione come riferimento, poiché mostrano a quale asse corrispondono le misurazioni.

### Frequenza di ringing

Innanzitutto, misura la **frequenza di ringing**.

1. If `square_corner_velocity` parameter was changed, revert it back to 5.0. It is not advised to increase it when using input shaper because it can cause more smoothing in parts - it is better to use higher acceleration value instead.
1. Aumenta `max_accel_to_decel` inserendo il seguente comando: `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. Disabilita la Pressure Advance: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Se hai già aggiunto la sezione `[input_shaper]` a printer.cfg, esegui il comando `SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0`. Se ricevi l'errore "Comando sconosciuto- Unknown command", puoi tranquillamente ignorarlo a questo punto e continuare con le misurazioni.
1. Execute the command: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5` Basically, we try to make ringing more pronounced by setting different large values for acceleration. This command will increase the acceleration every 5 mm starting from 1500 mm/sec^2: 1500 mm/sec^2, 2000 mm/sec^2, 2500 mm/sec^2 and so forth up until 7000 mm/sec^2 at the last band.
1. Stampa il modello di test sliced con i parametri suggeriti.
1. Puoi interrompere la stampa prima se il ringing è chiaramente visibile e vedi che l'accelerazione diventa troppo alta per la tua stampante (ad es. la stampante trema troppo o inizia a saltare i passaggi).

   1. Utilizzare i segni X e Y sul retro del modello come riferimento. Le misurazioni dal lato con il contrassegno X devono essere utilizzate per la *configurazione* dell'asse X e il contrassegno Y - per la configurazione dell'asse Y. Misurare la distanza *D* (in mm) tra più oscillazioni sulla parte con il segno X, in prossimità delle tacche, preferibilmente saltando la prima o due oscillazioni. Per misurare più facilmente la distanza tra le oscillazioni, contrassegnare prima le oscillazioni, quindi misurare la distanza tra i segni con un righello o un calibro:|![Mark ringing](img/ringing-mark.jpg)|![Measure ringing](img/ringing-measure.jpg)|
1. Contare a quante oscillazioni *N* corrisponde la distanza misurata *D*. Se non sei sicuro di come contare le oscillazioni, fai riferimento all'immagine sopra, che mostra *N* = 6 oscillazioni.
1. Calcola la frequenza di squillo dell'asse X come *V* &middot; *N* / *D* (Hz), dove *V* è la velocità per i perimetri esterni (mm/sec). Per l'esempio sopra, abbiamo contrassegnato 6 oscillazioni e il test è stato stampato a una velocità di 100 mm/sec, quindi la frequenza è 100 * 6 / 12,14 ≈ 49,4 Hz.
1. Do (8) - (10) for Y mark as well.

Si noti che il ringing sulla stampa di prova dovrebbe seguire lo schema delle tacche curve, come nell'immagine sopra. In caso contrario, questo difetto non è in realtà un ringing e ha un'origine diversa: un problema meccanico o dell'estrusore. Dovrebbe essere risolto prima di abilitare e regolare gli shaper di input.

Se le misurazioni non sono affidabili perché, ad esempio, la distanza tra le oscillazioni non è stabile, potrebbe significare che la stampante ha più frequenze di risonanza sullo stesso asse. Si può invece provare a seguire il processo di sintonizzazione descritto nella sezione [Misurazioni inaffidabili delle frequenze di ringing](#unreliable-measurements-of-ringing-frequencies) e ottenere comunque qualcosa dalla tecnica di input shaping .

La frequenza dei ringing può dipendere dalla posizione del modello all'interno della piastra di stampa e dall'altezza Z, *soprattutto sulle stampanti delta*; puoi controllare se vedi le differenze di frequenza in diverse posizioni lungo i lati del modello di prova e ad altezze diverse. È possibile calcolare le frequenze di squillo medie sugli assi X e Y, se questo è il caso.

Se la frequenza di ringing misurata è molto bassa (inferiore a circa 20-25 Hz), potrebbe essere una buona idea investire nell'irrigidire la stampante o nel diminuire la massa mobile, a seconda di ciò che è applicabile nel tuo caso, prima di procedere con l'ulteriore input shaping e rimisurare le frequenze in seguito. Per molti modelli di stampanti popolari spesso sono già disponibili alcune soluzioni.

Si noti che le frequenze di ringing possono cambiare se alla stampante vengono apportate modifiche che influiscono sulla massa in movimento o modificano la rigidità del sistema, ad esempio:

* Alcuni strumenti vengono installati, rimossi o sostituiti sulla testa di stampa che ne modificano la massa, ad es. viene installato un nuovo motore passo-passo (più pesante o più leggero) per estrusore diretto o viene installato un nuovo hotend, viene aggiunta una ventola pesante con un condotto, ecc.
* Le cinghie sono tese.
* Sono installati alcuni componenti aggiuntivi per aumentare la rigidità del telaio.
* Un piatto diverso è installato su una stampante a piatto mobile o aggiunto un vetro, ecc.

Se vengono apportate tali modifiche, è una buona idea misurare almeno le frequenze di ringing per vedere se sono cambiate.

### Configurazione del Input shaper

Dopo aver misurato le frequenze di ringing per gli assi X e Y, puoi aggiungere la seguente sezione al tuo `printer.cfg`:

```
[input_shaper]
shaper_freq_x: ...  # frequency for the X mark of the test model
shaper_freq_y: ...  # frequency for the Y mark of the test model
```

Per l'esempio sopra, otteniamo shaper_freq_x/y = 49.4.

### Scelta del input shaper

Klipper supporta diversi input shaper. Si differenziano per la loro sensibilità agli errori che determinano la frequenza di risonanza e quanto smussamento provocano nelle parti stampate. Inoltre, alcuni degli shaper come 2HUMP_EI e 3HUMP_EI di solito non dovrebbero essere usati con shaper_freq = frequenza di risonanza: sono configurati in base a diverse considerazioni per ridurre diverse risonanze contemporaneamente.

Per la maggior parte delle stampanti, possono essere consigliati shaper MZV o EI. Questa sezione descrive un processo di test per scegliere tra di loro e capire alcuni altri parametri correlati.

Print the ringing test model as follows:

1. Riavviare il firmware: `RESTART`
1. Prepararsi per il test: `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. Disabilita la Pressure Advance: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Eseguire: `SET_INPUT_SHAPER SHAPER_TYPE=MZV`
1. Eseguire il comando: `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`
1. Stampa il modello di test sliced con i parametri suggeriti.

Se a questo punto non si vede alcun ringing, è possibile consigliare l'uso dello shaper MZV.

Se vedi dei ringing, rimisura le frequenze usando i passaggi (8)-(10) descritti nella sezione [Frequenza ringing](#frequenza-ringing). Se le frequenze differiscono in modo significativo dai valori ottenuti in precedenza, è necessaria una configurazione dello shaper di input più complessa. Puoi fare riferimento ai dettagli tecnici della sezione [Input shapers](#input-shapers). In caso contrario, procedere al passaggio successivo.

Ora prova l'input shaper EI. Per provarlo, ripeti i passaggi (1)-(6) da sopra, ma eseguendo invece al passaggio 4 il seguente comando : `SET_INPUT_SHAPER SHAPER_TYPE=EI`.

Confronta due stampe con input shaper MZV e EI. Se EI mostra risultati notevolmente migliori rispetto a MZV, utilizzare EI shaper, altrimenti preferire MZV. Si noti che lo shaper EI causerà una maggiore levigatura 'smoothing' nelle parti stampate (vedere la sezione successiva per ulteriori dettagli). Aggiungi il parametro `shaper_type: mzv` (o ei) alla sezione [input_shaper], ad esempio:

```
[input_shaper]
shaper_freq_x: ...
shaper_freq_y: ...
shaper_type: mzv
```

Alcune note sulla scelta dello shaper:

* Lo shaper EI può essere più adatto per le stampanti a piatto mobile (se la frequenza di risonanza e il conseguente livellamento lo consentono): man mano che si deposita più filamento sul piatto mobile, la massa del piatto aumenta e la frequenza di risonanza diminuisce. Poiché lo shaper EI è più robusto alle variazioni della frequenza di risonanza, potrebbe funzionare meglio quando si stampano parti di grandi dimensioni.
* A causa della natura della cinematica delta, le frequenze di risonanza possono differire molto in diverse parti del volume di costruzione. Pertanto, lo shaper EI può adattarsi meglio alle stampanti delta piuttosto che a MZV o ZV e dovrebbe essere considerato per l'uso. Se la frequenza di risonanza è sufficientemente grande (più di 50-60 Hz), si può anche provare a testare lo shaper 2HUMP_EI (eseguendo il test suggerito sopra con `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI`), ma controllare le considerazioni nella [sezione sotto ](#selecting-max_accel) prima di abilitarlo.

### Seleziona max_accel

You should have a printed test for the shaper you chose from the previous step (if you don't, print the test model sliced with the [suggested parameters](#tuning) with the pressure advance disabled `SET_PRESSURE_ADVANCE ADVANCE=0` and with the tuning tower enabled as `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`). Note that at very high accelerations, depending on the resonance frequency and the input shaper you chose (e.g. EI shaper creates more smoothing than MZV), input shaping may cause too much smoothing and rounding of the parts. So, max_accel should be chosen such as to prevent that. Another parameter that can impact smoothing is `square_corner_velocity`, so it is not advisable to increase it above the default 5 mm/sec to prevent increased smoothing.

Per selezionare un valore max_accel adatto, ispezionare il modello per lo shaper di input scelto. Per prima cosa, prendi nota a quale accelerazione il ringing è ancora piccolo - che ti vada bene.

Quindi, controlla la levigatura - smoothing. Per aiutare in questo, il modello di prova ha un piccolo spazio nel muro (0,15 mm):

![Test gap](img/smoothing-test.png)

All'aumentare dell'accelerazione, aumenta anche la levigatura-smoothing e lo spazio effettivo nella stampa si allarga:

![Shaper smoothing](img/shaper-smoothing.jpg)

In questa immagine, l'accelerazione aumenta da sinistra a destra e il gap inizia a crescere a partire da 3500 mm/sec^2 (quinta banda da sinistra). Quindi il buon valore per max_accel = 3000 (mm/sec^2) in questo caso per evitare l'eccessivo smoothing.

Nota l'accelerazione quando lo spazio è ancora molto piccolo nella stampa di prova. Se vedi rigonfiamenti, ma nessun vuoto nel muro, anche ad alte accelerazioni, potrebbe essere dovuto all'avanzamento della pressione disabilitato, specialmente sugli estrusori Bowden. In tal caso, potrebbe essere necessario ripetere la stampa con il PA abilitato. Potrebbe anche essere il risultato di un flusso di filamento non calibrato (troppo alto), quindi è una buona idea controllare anche quello.

Choose the minimum out of the two acceleration values (from ringing and smoothing), and put it as `max_accel` into printer.cfg.

Come nota, può succedere, specialmente a basse frequenze di ringing, che lo shaper EI provochi un'eccessiva attenuazione anche a basse accelerazioni. In questo caso, MZV potrebbe essere una scelta migliore, perché potrebbe consentire valori di accelerazione più elevati.

A frequenze di ringing molto basse (~25 Hz e inferiori) anche lo shaper MZV può creare un effetto smussato eccessivo. In tal caso, puoi anche provare a ripetere i passaggi nella sezione [Scegliere input shaper](#choosing-input-shaper) con shaper ZV, usando invece il comando `SET_INPUT_SHAPER SHAPER_TYPE=ZV`. Lo shaper ZV dovrebbe mostrare un livellamento ancora inferiore rispetto a MZV, ma è più sensibile agli errori nella misurazione delle frequenze di ringing.

Un'altra considerazione è che se una frequenza di risonanza è troppo bassa (inferiore a 20-25 Hz), potrebbe essere una buona idea aumentare la rigidità della stampante o ridurre la massa in movimento. In caso contrario, l'accelerazione e la velocità di stampa potrebbero essere limitate a causa di un'eccessivo smoothing invece del ringing.

### Regolazione fine delle frequenze di risonanza

Si noti che la precisione delle misurazioni delle frequenze di risonanza utilizzando il modello di test di ringing è sufficiente per la maggior parte degli scopi, quindi si sconsiglia un'ulteriore messa a punto. Se vuoi ancora provare a ricontrollare i tuoi risultati (ad esempio se vedi ancora del ringing dopo aver stampato un modello di prova con un input shaper a tua scelta con le stesse frequenze che hai misurato in precedenza), puoi seguire i passaggi in questo sezione. Nota che se vedi ringing a frequenze diverse dopo aver abilitato [input_shaper], questa sezione non ti aiuterà.

Assuming that you have sliced the ringing model with suggested parameters, complete the following steps for each of the axes X and Y:

1. Prepararsi per il test: `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. Assicurati che Pressure Advance sia disabilitato: `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Eseguire: `SET_INPUT_SHAPER SHAPER_TYPE=ZV`
1. From the existing ringing test model with your chosen input shaper select the acceleration that shows ringing sufficiently well, and set it with: `SET_VELOCITY_LIMIT ACCEL=...`
1. Calcola i parametri necessari per il comando `TUNING_TOWER` per ottimizzare il parametro `shaper_freq_x` come segue: start = shaper_freq_x * 83 / 132 e factor = shaper_freq_x / 66, dove qui `shaper_freq_x` è il valore corrente in `printer.cfg`.
1. Eseguire il comando: `TUNING_TOWER COMMAND=SET_INPUT_SHAPER PARAMETER=SHAPER_FREQ_X START=start FACTOR=factor BAND=5` usando i valori `start` e `factor` calcolati al punto (5).
1. Stampa il modello di prova.
1. Reimposta il valore della frequenza originale: `SET_INPUT_SHAPER SHAPER_FREQ_X=...`.
1. Trova la fascia che mostra meno ringing e conta il suo numero dal basso partendo da 1.
1. Calcola il nuovo valore shaper_freq_x tramite il vecchio shaper_freq_x * (39 + 5 * #band-number) / 66.

Ripetere questi passaggi per l'asse Y allo stesso modo, sostituendo i riferimenti all'asse X con l'asse Y (ad es. sostituire `shaper_freq_x` con `shaper_freq_y` nelle formule e nel comando `TUNING_TOWER`).

Ad esempio, supponiamo di aver misurato la frequenza di ringing per uno degli assi pari a 45 Hz. Questo dà start = 45 * 83 / 132 = 28,30 e factor = 45 / 66 = 0,6818 valori per il comando `TUNING_TOWER`. Supponiamo ora che dopo aver stampato il modello di prova, la quarta fascia dal basso dia il minimo squillo. Questo dà lo shaper_freq_^ aggiornato al valore pari a 45 * (39 + 5 * 4) / 66 ≈ 40,23.

Dopo aver calcolato entrambi i nuovi parametri `shaper_freq_x` e `shaper_freq_y`, puoi aggiornare la sezione `[input_shaper]` in `printer.cfg` con i nuovi valori `shaper_freq_x` e `shaper_freq_y`.

### Pressure Advance

If you use Pressure Advance, it may need to be re-tuned. Follow the [instructions](Pressure_Advance.md#tuning-pressure-advance) to find the new value, if it differs from the previous one. Make sure to restart Klipper before tuning Pressure Advance.

### Misurazioni inaffidabili delle frequenze di ringing

Se non è possibile misurare le frequenze di ringing, ad es. se la distanza tra le oscillazioni non è stabile, potresti comunque essere in grado di sfruttare le tecniche di input shaping, ma i risultati potrebbero non essere buoni come con misurazioni corrette delle frequenze e richiederà un po' più di messa a punto e stampa del test modello. Si noti che un'altra possibilità è acquistare e installare un accelerometro e misurare le risonanze con esso (fare riferimento a [docs](Measuring_Resonances.md) che descrive l'hardware richiesto e il processo di installazione), ma questa opzione richiede un po' di crimpatura e saldatura.

For tuning, add empty `[input_shaper]` section to your `printer.cfg`. Then, assuming that you have sliced the ringing model with suggested parameters, print the test model 3 times as follows. First time, prior to printing, run

1. `RESTART`
1. `SET_VELOCITY_LIMIT ACCEL_TO_DECEL=7000`
1. `SET_PRESSURE_ADVANCE ADVANCE=0`
1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=60 SHAPER_FREQ_Y=60`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

e stampa il modello. Quindi stampare di nuovo il modello, ma prima di eseguire la stampa invece

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=50 SHAPER_FREQ_Y=50`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

Quindi stampa il modello per la terza volta, ma ora esegui

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=40 SHAPER_FREQ_Y=40`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

In sostanza, stiamo stampando il modello di prova di ringing con TUNING_TOWER utilizzando lo shaper 2HUMP_EI con shaper_freq = 60 Hz, 50 Hz e 40 Hz.

Se nessuno dei modelli mostra miglioramenti nel ringing, allora, sfortunatamente non sembra che le tecniche di modellazione dell'input possano aiutare con il tuo caso.

Altrimenti, è possibile che tutti i modelli non mostrino ringing, o alcuni mostrino ringing e altri non così tanto. Scegli il modello di test con la frequenza più alta che mostra comunque buoni miglioramenti nel ringing. Ad esempio, se i modelli a 40 Hz e 50 Hz non mostrano quasi nessuno ringing e il modello a 60 Hz mostra già un po' più di ringing, attenersi a 50 Hz.

Ora controlla se lo shaper EI sarebbe abbastanza buono nel tuo caso. Scegli la frequenza dello shaper EI in base alla frequenza dello shaper 2HUMP_EI che hai scelto:

* Per lo shaper 2HUMP_EI 60 Hz, utilizzare lo shaper EI con shaper_freq = 50 Hz.
* Per lo shaper 2HUMP_EI 50 Hz, utilizzare lo shaper EI con shaper_freq = 40 Hz.
* Per lo shaper 2HUMP_EI 40 Hz, utilizzare lo shaper EI con shaper_freq = 33 Hz.

Ora stampa il modello di prova ancora una volta, eseguendola

1. `SET_INPUT_SHAPER SHAPER_TYPE=EI SHAPER_FREQ_X=... SHAPER_FREQ_Y=...`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

fornendo shaper_freq_x=... e shaper_freq_y=... come determinato in precedenza.

Se lo shaper EI mostra buoni risultati comparabili con lo shaper 2HUMP_EI, attenersi con lo shaper EI e la frequenza determinata in precedenza, altrimenti utilizzare lo shaper 2HUMP_EI con la frequenza corrispondente. Aggiungi i risultati a `printer.cfg` come, ad es.

```
[input_shaper]
shaper_freq_x: 50
shaper_freq_y: 50
shaper_type: 2hump_ei
```

Continua l'ottimizzazione con la sezione [Selecting max_accel](#selecting-max_accel).

## Risoluzione dei problemi e domande frequenti

### Non riesco a ottenere misurazioni affidabili delle frequenze di risonanza

Innanzitutto, assicurati che non ci siano altri problemi con la stampante invece del ringing. Se le misurazioni non sono affidabili perché, ad esempio, la distanza tra le oscillazioni non è stabile, potrebbe significare che la stampante ha più frequenze di risonanza sullo stesso asse. Si può provare a seguire il processo di sintonizzazione descritto nella sezione [Misurazioni inaffidabili delle frequenze di ringing](#unreliable-measurements-of-ringing-frequencies) e ottenere comunque qualcosa dalla tecnica di modellatura dell'input. Un'altra possibilità è installare un accelerometro, [misurare](Measuring_Resonances.md) le risonanze con esso e regolare automaticamente lo shaper di input utilizzando i risultati di tali misurazioni.

### Dopo aver abilitato [input_shaper], ottengo parti stampate troppo levigate e i dettagli fini vengono persi

Controllare le considerazioni nella sezione [Selecting max_accel](#selecting-max_accel). Se la frequenza di risonanza è bassa, non si dovrebbero impostare max_accel troppo alti o aumentare i parametri square_corner_velocity. Potrebbe anche essere meglio scegliere gli shaper di input MZV o anche ZV su EI (o gli shaper 2HUMP_EI e 3HUMP_EI).

### Dopo aver stampato correttamente per un po' di tempo senza ringing, sembra tornare

È possibile che dopo qualche tempo le frequenze di risonanza siano cambiate. Per esempio. forse la tensione delle cinghie è cambiata (le cinghie si sono allentate di più), ecc. È una buona idea controllare e rimisurare le frequenze di ringing come descritto nella sezione [Frequenza di ringing](#ringing-frequency) e aggiornare il file di configurazione se necessario .

### Is dual carriage setup supported with input shapers?

There is no dedicated support for dual carriages with input shapers, but it does not mean this setup will not work. One should run the tuning twice for each of the carriages, and calculate the ringing frequencies for X and Y axes for each of the carriages independently. Then put the values for carriage 0 into [input_shaper] section, and change the values on the fly when changing carriages, e.g. as a part of some macro:

```
SET_DUAL_CARRIAGE CARRIAGE=1
SET_INPUT_SHAPER SHAPER_FREQ_X=... SHAPER_FREQ_Y=...
```

And similarly when switching back to carriage 0.

### Does input_shaper affect print time?

No, `input_shaper` feature has pretty much no impact on the print times by itself. However, the value of `max_accel` certainly does (tuning of this parameter described in [this section](#selecting-max_accel)).

## Technical details

### Input shapers

Input shapers used in Klipper are rather standard, and one can find more in-depth overview in the articles describing the corresponding shapers. This section contains a brief overview of some technical aspects of the supported input shapers. The table below shows some (usually approximate) parameters of each shaper.

| Input <br> shaper | Shaper <br> duration | Vibration reduction 20x <br> (5% vibration tolerance) | Vibration reduction 10x <br> (10% vibration tolerance) |
| :-: | :-: | :-: | :-: |
| ZV | 0.5 / shaper_freq | N/A | ± 5% shaper_freq |
| MZV | 0.75 / shaper_freq | ± 4% shaper_freq | -10%...+15% shaper_freq |
| ZVD | 1 / shaper_freq | ± 15% shaper_freq | ± 22% shaper_freq |
| EI | 1 / shaper_freq | ± 20% shaper_freq | ± 25% shaper_freq |
| 2HUMP_EI | 1.5 / shaper_freq | ± 35% shaper_freq | ± 40 shaper_freq |
| 3HUMP_EI | 2 / shaper_freq | -45...+50% shaper_freq | -50%...+55% shaper_freq |

A note on vibration reduction: the values in the table above are approximate. If the damping ratio of the printer is known for each axis, the shaper can be configured more precisely and it will then reduce the resonances in a bit wider range of frequencies. However, the damping ratio is usually unknown and is hard to estimate without a special equipment, so Klipper uses 0.1 value by default, which is a good all-round value. The frequency ranges in the table cover a number of different possible damping ratios around that value (approx. from 0.05 to 0.2).

Also note that EI, 2HUMP_EI, and 3HUMP_EI are tuned to reduce vibrations to 5%, so the values for 10% vibration tolerance are provided only for the reference.

**Come utilizzare questa tabella:**

* Shaper duration affects the smoothing in parts - the larger it is, the more smooth the parts are. This dependency is not linear, but can give a sense of which shapers 'smooth' more for the same frequency. The ordering by smoothing is like this: ZV < MZV < ZVD ≈ EI < 2HUMP_EI < 3HUMP_EI. Also, it is rarely practical to set shaper_freq = resonance freq for shapers 2HUMP_EI and 3HUMP_EI (they should be used to reduce vibrations for several frequencies).
* One can estimate a range of frequencies in which the shaper reduces vibrations. For example, MZV with shaper_freq = 35 Hz reduces vibrations to 5% for frequencies [33.6, 36.4] Hz. 3HUMP_EI with shaper_freq = 50 Hz reduces vibrations to 5% in range [27.5, 75] Hz.
* One can use this table to check which shaper they should be using if they need to reduce vibrations at several frequencies. For example, if one has resonances at 35 Hz and 60 Hz on the same axis: a) EI shaper needs to have shaper_freq = 35 / (1 - 0.2) = 43.75 Hz, and it will reduce resonances until 43.75 * (1 + 0.2) = 52.5 Hz, so it is not sufficient; b) 2HUMP_EI shaper needs to have shaper_freq = 35 / (1 - 0.35) = 53.85 Hz and will reduce vibrations until 53.85 * (1 + 0.35) = 72.7 Hz - so this is an acceptable configuration. Always try to use as high shaper_freq as possible for a given shaper (perhaps with some safety margin, so in this example shaper_freq ≈ 50-52 Hz would work best), and try to use a shaper with as small shaper duration as possible.
* If one needs to reduce vibrations at several very different frequencies (say, 30 Hz and 100 Hz), they may see that the table above does not provide enough information. In this case one may have more luck with [scripts/graph_shaper.py](../scripts/graph_shaper.py) script, which is more flexible.
