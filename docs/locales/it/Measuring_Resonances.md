# Misurazione delle risonanze

Klipper ha il supporto integrato per l'accelerometro ADXL345, che può essere utilizzato per misurare le frequenze di risonanza della stampante per diversi assi, e per l'autotuning [input shapers](Resonance_Compensation.md) per compensare le risonanze. Si noti che l'utilizzo di ADXL345 richiede alcune operazioni di saldatura e crimpatura. ADXL345 può essere collegato direttamente a un Raspberry Pi o a un'interfaccia SPI di una scheda MCU (deve essere ragionevolmente veloce).

Quando acquisti ADXL345, tieni presente che esiste una varietà di diversi design di schede PCB e diversi cloni di essi. Assicurati che la scheda supporti la modalità SPI (un piccolo numero di schede sembra essere configurato in modo rigido per I2C trascinando SDO su GND) e, se deve essere collegato a un MCU per stampante da 5 V, che abbia un regolatore di tensione e un cambio di livello.

## Istruzioni per l'installazione

### Cablaggio

Devi connettere ADXL345 al tuo Raspberry Pi tramite SPI. Si noti che la connessione I2C, suggerita dalla documentazione di ADXL345, ha un throughput troppo basso e **non funzionerà**. Lo schema di connessione consigliato:

| ADXL345 pin | RPi pin | Nome pin RPi |
| :-: | :-: | :-: |
| 3V3 (or VCC) | 01 | 3.3v alimentazione DC |
| GND | 06 | Ground |
| CS | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

Un'alternativa all'ADXL345 è l'MPU-9250 (o MPU-6050). Questo accelerometro è stato testato per funzionare su I2C su RPi a 400kbaud. Schema di connessione consigliato per I2C:

| pin MPU-9250 | RPi pin | Nome pin RPi |
| :-: | :-: | :-: |
| 3V3 (or VCC) | 01 | 3.3v alimentazione DC |
| GND | 09 | Ground |
| SDA | 03 | GPIO02 (SDA1) |
| SCL | 05 | GPIO03 (SCL1) |

Schemi collegamenti Fritzing per alcune delle schede ADXL345:

![ADXL345-Rpi](img/adxl345-fritzing.png)

Ricontrolla il cablaggio prima di accendere il Raspberry Pi per evitare di danneggiare RPi o l'accelerometro.

### Montaggio dell'accelerometro

L'accelerometro deve essere collegato alla testa di stampa. È necessario progettare un supporto adeguato che si adatti alla propria stampante 3D. È meglio allineare gli assi dell'accelerometro con gli assi della stampante (ma se lo rende più comodo, gli assi possono essere scambiati - cioè non c'è bisogno di allineare l'asse X con X e così via - dovrebbe andare bene anche se l'asse Z di l'accelerometro è l'asse X della stampante, ecc.).

Un esempio di montaggio di ADXL345 su SmartEffect:

![ADXL345 on SmartEffector](img/adxl345-mount.jpg)

Si noti che su una stampante con piatto mobile è necessario progettare 2 supporti: uno per la testina e uno per il piatto, ed eseguire le misurazioni due volte. Per maggiori dettagli, vedere la [sezione](#bed-slinger-printers) corrispondente.

**Attenzione:** assicurati che l'accelerometro e le eventuali viti che lo tengono in posizione non tocchino parti metalliche della stampante. Fondamentalmente, il supporto deve essere progettato in modo tale da garantire l'isolamento elettrico dell'accelerometro dal telaio della stampante. Non riuscendo a garantire che può creare un loop di massa nel sistema che potrebbe danneggiare l'elettronica.

### Installazione software

Si noti che le misurazioni della risonanza e la calibrazione automatica dello shaper richiedono dipendenze software aggiuntive non installate per impostazione predefinita. Innanzitutto, esegui sul tuo Raspberry Pi i seguenti comandi:

```
sudo apt update
sudo apt install python3-numpy python3-matplotlib libatlas-base-dev
```

Quindi, per installare NumPy nell'ambiente Klipper, esegui il comando:

```
~/klippy-env/bin/pip install -v numpy
```

Nota che, a seconda delle prestazioni della CPU, potrebbe volerci *molto* tempo, fino a 10-20 minuti. Sii paziente e attendi il completamento dell'installazione. In alcune occasioni, se la scheda ha poca RAM, l'installazione potrebbe non riuscire e sarà necessario abilitare la swap.

Successivamente, controlla e segui le istruzioni nel [documento RPi Microcontroller](RPi_microcontroller.md) per configurare "linux mcu" sul Raspberry Pi.

Assicurati che il driver SPI di Linux sia abilitato eseguendo `sudo raspi-config` e abilitando SPI nel menu "Opzioni di interfaccia".

Per ADXL345, aggiungere quanto segue al file printer.cfg:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # un esempio
```

Si consiglia di iniziare con 1 punto sonda, al centro del piano di stampa, leggermente al di sopra di esso.

Per l'MPU-9250, assicurarsi che il driver Linux I2C sia abilitato e che la velocità di trasmissione sia impostata su 400000 (consultare la sezione [Abilitazione di I2C](RPi_microcontroller.md#optional-enbling-i2c) per maggiori dettagli). Quindi, aggiungi quanto segue a printer.cfg:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[mpu9250]
i2c_mcu: rpi
i2c_bus: i2c.1

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # un esempio
```

Riavvia Klipper tramite il comando `RESTART`.

## Misurare le risonanze

### Controllo della configurazione

Ora puoi testare una connessione.

- Per "per piatti non scorrevoli" (es. un accelerometro), in Octoprint, inserisci `ACCELEROMETER_QUERY`
- Per "piatti scorrevoli" (ad es. più di un accelerometro), immettere `ACCELEROMETER_QUERY CHIP=<chip>` dove `<chip>` è il nome del chip immesso, ad es. `CHIP=piatto` (vedi: [bed-slinger](#bed-slinger-printers)) per tutti i chip dell'accelerometro installati.

Dovresti vedere le misurazioni attuali dall'accelerometro, inclusa l'accelerazione di caduta libera, ad es.

```
Recv: // adxl345 values (x, y, z): 470.719200, 941.438400, 9728.196800
```

Se ricevi un errore come `Invalid adxl345 id (got xx vs e5)`, dove `xx` è un altro ID, è indicativo del problema di connessione con ADXL345 o del sensore difettoso. Ricontrolla l'alimentazione, il cablaggio (che corrisponda agli schemi, nessun filo è rotto o allentato, ecc.) e la qualità delle saldature.

Quindi, prova a eseguire `MEASURE_AXES_NOISE` in Octoprint, dovresti ottenere alcuni numeri di riferimento per il rumore dell'accelerometro sugli assi (dovrebbe essere compreso tra ~1-100). Un rumore degli assi troppo elevato (ad es. 1000 e più) può essere indicativo di problemi con il sensore, problemi con la sua alimentazione o ventole sbilanciate troppo rumorose su una stampante 3D.

### Misurare le risonanze

Ora puoi eseguire alcuni test realistici. Esegui il seguente comando:

```
TEST_RESONANCES AXIS=X
```

Nota che creerà vibrazioni sull'asse X. Disabiliterà anche l'input shaping se era stato abilitato in precedenza, poiché non è valido eseguire il test di risonanza con l'input shaper abilitato.

**Attenzione!** Assicurati di osservare la stampante per la prima volta, per assicurarti che le vibrazioni non diventino troppo violente (il comando `M112` può essere utilizzato per interrompere il test in caso di emergenza; si spera che non si verifichi questo però). Se le vibrazioni diventano troppo forti, puoi provare a specificare un valore inferiore al valore predefinito per il parametro `accel_per_hz` nella sezione `[resonance_tester]`, ad es.

```
[resonance_tester]
accel_chip: adxl345
accel_per_hz: 50  # default è 75
probe_points: ...
```

Se funziona per l'asse X, esegui anche per l'asse Y:

```
TEST_RESONANCES AXIS=Y
```

Questo genererà 2 file CSV (`/tmp/resonances_x_*.csv` e `/tmp/resonances_y_*.csv`). Questi file possono essere elaborati con lo script autonomo su un Raspberry Pi. Per farlo, esegui i seguenti comandi:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

Questo script genererà i grafici `/tmp/shaper_calibrate_x.png` e `/tmp/shaper_calibrate_y.png` con le risposte in frequenza. Riceverai anche le frequenze suggerite per ogni input shaper, nonché quale input shaper è consigliato per la tua configurazione. Per esempio:

![Resonances](img/calibrate-y.png)

```
Fitted shaper 'zv' frequency = 34.4 Hz (vibrations = 4.0%, smoothing ~= 0.132)
To avoid too much smoothing with 'zv', suggested max_accel <= 4500 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 0.0%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 41.4 Hz (vibrations = 0.0%, smoothing ~= 0.188)
To avoid too much smoothing with 'ei', suggested max_accel <= 3200 mm/sec^2
Fitted shaper '2hump_ei' frequency = 51.8 Hz (vibrations = 0.0%, smoothing ~= 0.201)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 61.8 Hz (vibrations = 0.0%, smoothing ~= 0.215)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2800 mm/sec^2
Recommended shaper is mzv @ 34.6 Hz
```

La configurazione suggerita può essere aggiunta alla sezione `[input_shaper]` di `printer.cfg`, ad esempio:

```
[input_shaper]
shaper_freq_x: ...
shaper_type_x: ...
shaper_freq_y: 34.6
shaper_type_y: mzv

[printer]
max_accel: 3000  # non dovrebbe superare il max_accel stimato per gli assi X e Y
```

oppure puoi scegliere tu stesso un'altra configurazione in base ai grafici generati: i picchi nella densità spettrale di potenza sui grafici corrispondono alle frequenze di risonanza della stampante.

Nota che in alternativa puoi eseguire l'autocalibrazione dello input shaper da Klipper [directly](#input-shaper-auto-calibration), che può essere conveniente, ad esempio, per lo input shaper[re-calibration](#input-shaper-re-calibrazione).

### Stampanti con piatto scorrevole

Se la tua stampante ha un piatto scorrevole, dovrai cambiare la posizione dell'accelerometro tra le misurazioni per gli assi X e Y: misurare le risonanze dell'asse X con l'accelerometro collegato alla testa di stampa e le risonanze dell'asse Y - al piatto.

Tuttavia, puoi anche collegare due accelerometri contemporaneamente, sebbene debbano essere collegati a schede diverse (ad esempio, a una scheda RPi e MCU della stampante) o a due diverse interfacce SPI fisiche sulla stessa scheda (raramente disponibili). Quindi possono essere configurati nel modo seguente:

```
[adxl345 hotend]
# Supponendo che il chip "hotend" sia collegato a un RPi
cs_pin: rpi:None

[adxl345 bed]
# Supponendo che il chip `bed` sia collegato a una scheda MCU della stampante
cs_pin: ...  # Pin di selezione chip SPI (CS) della scheda stampante

[resonance_tester]
# Assumendo la configurazione tipo della stampante con piatto scorrevole
accel_chip_x: adxl345 hotend
accel_chip_y: adxl345 bed
probe_points: ...
```

Quindi i comandi `TEST_RESONANCES AXIS=X` e `TEST_RESONANCES AXIS=Y` utilizzeranno l'accelerometro corretto per ciascun asse.

### Max smoothing

Keep in mind that the input shaper can create some smoothing in parts. Automatic tuning of the input shaper performed by `calibrate_shaper.py` script or `SHAPER_CALIBRATE` command tries not to exacerbate the smoothing, but at the same time they try to minimize the resulting vibrations. Sometimes they can make a sub-optimal choice of the shaper frequency, or maybe you simply prefer to have less smoothing in parts at the expense of a larger remaining vibrations. In these cases, you can request to limit the maximum smoothing from the input shaper.

Consideriamo i seguenti risultati della sintonizzazione automatica:

![Resonances](img/calibrate-x.png)

```
Fitted shaper 'zv' frequency = 57.8 Hz (vibrations = 20.3%, smoothing ~= 0.053)
To avoid too much smoothing with 'zv', suggested max_accel <= 13000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.8 Hz (vibrations = 3.6%, smoothing ~= 0.168)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3600 mm/sec^2
Fitted shaper 'ei' frequency = 48.8 Hz (vibrations = 4.9%, smoothing ~= 0.135)
To avoid too much smoothing with 'ei', suggested max_accel <= 4400 mm/sec^2
Fitted shaper '2hump_ei' frequency = 45.2 Hz (vibrations = 0.1%, smoothing ~= 0.264)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2200 mm/sec^2
Fitted shaper '3hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.356)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 1500 mm/sec^2
Recommended shaper is 2hump_ei @ 45.2 Hz
```

Note that the reported `smoothing` values are some abstract projected values. These values can be used to compare different configurations: the higher the value, the more smoothing a shaper will create. However, these smoothing scores do not represent any real measure of smoothing, because the actual smoothing depends on [`max_accel`](#selecting-max-accel) and `square_corner_velocity` parameters. Therefore, you should print some test prints to see how much smoothing exactly a chosen configuration creates.

In the example above the suggested shaper parameters are not bad, but what if you want to get less smoothing on the X axis? You can try to limit the maximum shaper smoothing using the following command:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```

which limits the smoothing to 0.2 score. Now you can get the following result:

![Resonances](img/calibrate-x-max-smoothing.png)

```
Fitted shaper 'zv' frequency = 55.4 Hz (vibrations = 19.7%, smoothing ~= 0.057)
To avoid too much smoothing with 'zv', suggested max_accel <= 12000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 3.6%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 48.2 Hz (vibrations = 4.8%, smoothing ~= 0.139)
To avoid too much smoothing with 'ei', suggested max_accel <= 4300 mm/sec^2
Fitted shaper '2hump_ei' frequency = 52.0 Hz (vibrations = 2.7%, smoothing ~= 0.200)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 72.6 Hz (vibrations = 1.4%, smoothing ~= 0.155)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 3900 mm/sec^2
Recommended shaper is 3hump_ei @ 72.6 Hz
```

If you compare to the previously suggested parameters, the vibrations are a bit larger, but the smoothing is significantly smaller than previously, allowing larger maximum acceleration.

When deciding which `max_smoothing` parameter to choose, you can use a trial-and-error approach. Try a few different values and see which results you get. Note that the actual smoothing produced by the input shaper depends, primarily, on the lowest resonance frequency of the printer: the higher the frequency of the lowest resonance - the smaller the smoothing. Therefore, if you request the script to find a configuration of the input shaper with the unrealistically small smoothing, it will be at the expense of increased ringing at the lowest resonance frequencies (which are, typically, also more prominently visible in prints). So, always double-check the projected remaining vibrations reported by the script and make sure they are not too high.

Nota che se hai scelto un buon valore `max_smoothing` per entrambi gli assi, puoi salvarlo in `printer.cfg` come

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # un esempio
```

Quindi, se [riesegui](#input-shaper-re-calibration) l'autotuning dello shaper di input usando il comando Klipper `SHAPER_CALIBRATE` in futuro, utilizzerà il valore `max_smoothing` memorizzato come riferimento.

### Seleziona max_accel

Since the input shaper can create some smoothing in parts, especially at high accelerations, you will still need to choose the `max_accel` value that does not create too much smoothing in the printed parts. A calibration script provides an estimate for `max_accel` parameter that should not create too much smoothing. Note that the `max_accel` as displayed by the calibration script is only a theoretical maximum at which the respective shaper is still able to work without producing too much smoothing. It is by no means a recommendation to set this acceleration for printing. The maximum acceleration your printer is able to sustain depends on its mechanical properties and the maximum torque of the used stepper motors. Therefore, it is suggested to set `max_accel` in `[printer]` section that does not exceed the estimated values for X and Y axes, likely with some conservative safety margin.

In alternativa, segui [questa](Resonance_Compensation.md#selecting-max_accel) parte della guida all'ottimizzazione dello input shaper e stampa il modello di test per scegliere sperimentalmente il parametro `max_accel`.

Lo stesso avviso vale per lo input shaper [auto-calibration](#input-shaper-auto-calibration) con il comando `SHAPER_CALIBRATE`: è comunque necessario scegliere il giusto valore di `max_accel` dopo l'auto-calibrazione, e il i limiti di accelerazione non verranno applicati automaticamente.

Se stai eseguendo una ricalibrazione dello shaper e lo smoothing riportato per la configurazione dello shaper suggerita è quasi lo stesso di quello ottenuto durante la calibrazione precedente, questo passaggio può essere saltato.

### Test di assi personalizzati

Il comando `TEST_RESONANCES` supporta assi personalizzati. Anche se questo non è molto utile per la calibrazione del input shaper, può essere utilizzato per studiare in profondità le risonanze della stampante e per controllare, ad esempio, la tensione della cinghia.

Per controllare la tensione della cinghia sulle stampanti CoreXY, eseguire

```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```

e usa `graph_accelerometer.py` per elaborare i file generati, ad es.

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

che genererà `/tmp/resonances.png` confrontando le risonanze.

Per le stampanti Delta con la posizione della torre predefinita (torre A ~= 210 gradi, B ~= 330 gradi e C ~= 90 gradi), eseguire

```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```

e quindi utilizzare lo stesso comando

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

per generare `/tmp/resonances.png` confrontando le risonanze.

## Calibrazione automatica Input Shaper

Oltre a scegliere manualmente i parametri appropriati per la funzione di input shaper, è anche possibile eseguire l'autotuning per l'input shaper direttamente da Klipper. Esegui il seguente comando tramite il terminale Octoprint:

```
SHAPER_CALIBRATE
```

Questo eseguirà il test completo per entrambi gli assi e genererà l'output csv (`/tmp/calibration_data_*.csv` per impostazione predefinita) per la risposta in frequenza e gli input shaper suggeriti. Riceverai anche le frequenze suggerite per ciascun input shaper, nonché quale input shaper è consigliato per la tua configurazione, sulla console Octoprint. Per esempio:

```
Calculating the best input shaper parameters for y axis
Fitted shaper 'zv' frequency = 39.0 Hz (vibrations = 13.2%, smoothing ~= 0.105)
To avoid too much smoothing with 'zv', suggested max_accel <= 5900 mm/sec^2
Fitted shaper 'mzv' frequency = 36.8 Hz (vibrations = 1.7%, smoothing ~= 0.150)
To avoid too much smoothing with 'mzv', suggested max_accel <= 4000 mm/sec^2
Fitted shaper 'ei' frequency = 36.6 Hz (vibrations = 2.2%, smoothing ~= 0.240)
To avoid too much smoothing with 'ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '2hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.234)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '3hump_ei' frequency = 59.0 Hz (vibrations = 0.0%, smoothing ~= 0.235)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2500 mm/sec^2
Recommended shaper_type_y = mzv, shaper_freq_y = 36.8 Hz
```

Se sei d'accordo con i parametri suggeriti, puoi eseguire ora `SAVE_CONFIG` per salvarli e riavviare Klipper. Nota che questo non aggiornerà il valore `max_accel` nella sezione `[printer]`. Dovresti aggiornarlo manualmente seguendo le considerazioni nella sezione [Selecting max_accel](#selecting-max_accel).

If your printer is a bed slinger printer, you can specify which axis to test, so that you can change the accelerometer mounting point between the tests (by default the test is performed for both axes):

```
SHAPER_CALIBRATE AXIS=Y
```

È possibile eseguire `SAVE_CONFIG` due volte, dopo aver calibrato ciascun asse.

Tuttavia, se hai collegato due accelerometri contemporaneamente, esegui semplicemente `SHAPER_CALIBRATE` senza specificare un asse per calibrare l' input shaper per entrambi gli assi in una volta sola.

### Input Shaper ricalibrazione

Il comando `SHAPER_CALIBRATE` può essere utilizzato anche per ricalibrare lo shaper di input in futuro, specialmente se vengono apportate alcune modifiche alla stampante che possono influire sulla sua cinematica. È possibile eseguire nuovamente la calibrazione completa utilizzando il comando `SHAPER_CALIBRATE`, o limitare l'autocalibrazione a un singolo asse fornendo il parametro `AXIS=`, come

```
SHAPER_CALIBRATE AXIS=X
```

**Attenzione!** Non è consigliabile eseguire l'autocalibrazione dello shaper molto frequentemente (ad es. prima di ogni stampa o ogni giorno). Per determinare le frequenze di risonanza, l'autocalibrazione crea intense vibrazioni su ciascuno degli assi. Generalmente, le stampanti 3D non sono progettate per resistere a un'esposizione prolungata a vibrazioni vicino alle frequenze di risonanza. Ciò potrebbe aumentare l'usura dei componenti della stampante e ridurne la durata. C'è anche un aumento del rischio che alcune parti si svitino o si allentino. Verificare sempre che tutte le parti della stampante (comprese quelle che normalmente potrebbero non muoversi) siano fissate saldamente in posizione dopo ogni autotuning.

Inoltre, a causa di un po' di rumore nelle misurazioni, è possibile che i risultati dell'ottimizzazione siano leggermente diversi da una calibrazione all'altra. Tuttavia, non ci si aspetta che il rumore influisca troppo sulla qualità di stampa. Tuttavia, si consiglia comunque di ricontrollare i parametri suggeriti e di stampare alcune stampe di prova prima di utilizzarli per confermare che siano corretti.

## Elaborazione offline dei dati dell'accelerometro

È possibile generare i dati grezzi dell'accelerometro ed elaborarli offline (ad esempio su una macchina host), ad esempio per trovare risonanze. Per fare ciò, esegui i seguenti comandi tramite il terminale Octoprint:

```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```

ignorando eventuali errori per il comando `SET_INPUT_SHAPER`. Per il comando `TEST_RESONANCES`, specificare l'asse di test desiderato. I dati grezzi verranno scritti nella directory `/tmp` sull'RPi.

I dati grezzi possono anche essere ottenuti eseguendo il comando `ACCELEROMETER_MEASURE` due volte durante una normale attività della stampante: prima per avviare le misurazioni, quindi per interromperle e scrivere il file di output. Fare riferimento a [G-Codes](G-Codes.md#adxl345) per maggiori dettagli.

I dati possono essere elaborati successivamente dai seguenti script: `scripts/graph_accelerometer.py` e `scripts/calibrate_shaper.py`. Entrambi accettano uno o più file CSV non elaborati come input a seconda della modalità. Lo script graph_accelerometer.py supporta diverse modalità operative:

* tracciando i dati grezzi dell'accelerometro (usa il parametro `-r`), è supportato solo 1 input;
* tracciando una risposta in frequenza (non sono richiesti parametri aggiuntivi), se sono specificati più ingressi, viene calcolata la risposta in frequenza media;
* confronto della risposta in frequenza tra più ingressi (usare il parametro `-c`); puoi inoltre specificare quale asse dell'accelerometro considerare tramite il parametro `-a x`, `-a y` o `-a z` (se non specificato, viene utilizzata la somma delle vibrazioni per tutti gli assi);
* tracciando lo spettrogramma (usare il parametro `-s`), è supportato solo 1 input; è inoltre possibile specificare quale asse dell'accelerometro considerare tramite il parametro `-a x`, `-a y` o `-a z` (se non specificato, viene utilizzata la somma delle vibrazioni per tutti gli assi).

Si noti che lo script graph_accelerometer.py supporta solo i file raw_data\*.csv e non i file resonances\*.csv o calibration_data\*.csv.

Per esempio,

```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```

traccerà il confronto di diversi file `/tmp/raw_data_x_*.csv` per l'asse Z con il file `/tmp/resonances_x.png`.

Lo script shaper_calibrate.py accetta 1 o più input e può eseguire l'ottimizzazione automatica dello shaper di input e suggerire i parametri migliori che funzionano bene per tutti gli input forniti. Stampa i parametri suggeriti sulla console e può inoltre generare il grafico se viene fornito il parametro `-o output.png`, o il file CSV se viene specificato il parametro `-c output.csv`.

Fornire diversi input allo script shaper_calibrate.py può essere utile se si esegue un'ottimizzazione avanzata degli shaper di input, ad esempio:

* Esecuzione di `TEST_RESONANCES AXIS=X OUTPUT=raw_data` (e asse `Y`) per un singolo asse due volte su una stampante con piatto scorrevole con l'accelerometro collegato alla testa di stampa la prima volta e l'accelerometro collegato al piatto la seconda volta in modo da rilevare le risonanze incrociate degli assi e tentare di cancellarle con gli input shaper.
* Esecuzione di `TEST_RESONANCES AXIS=Y OUTPUT=raw_data` due volte su un supporto da piatto con un piatto di vetro e una superficie magnetica (che è più leggera) per trovare i parametri dello shaper di input che funzionano bene per qualsiasi configurazione della superficie di stampa.
* Combinazione dei dati di risonanza da più punti di test.
* Combinando i dati di risonanza da 2 assi (ad es. su una stampante con piatto scorrevole per configurare input_shaper dell'asse X dalle risonanze degli assi X e Y per annullare le vibrazioni del *piatto* nel caso in cui l'ugello "cattura" una stampa quando si sposta nella direzione dell'asse X ).
