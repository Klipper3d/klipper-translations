# Misurazione delle risonanze

Klipper ha il supporto integrato per l'accelerometro ADXL345, che può essere utilizzato per misurare le frequenze di risonanza della stampante per diversi assi, e per l'autotuning [input shapers](Resonance_Compensation.md) per compensare le risonanze. Si noti che l'utilizzo di ADXL345 richiede alcune operazioni di saldatura e crimpatura. ADXL345 può essere collegato direttamente a un Raspberry Pi o a un'interfaccia SPI di una scheda MCU (deve essere ragionevolmente veloce).

When sourcing ADXL345, be aware that there is a variety of different PCB board designs and different clones of them. Make sure that the board supports SPI mode (small number of boards appear to be hard-configured for I2C by pulling SDO to GND), and, if it is going to be connected to a 5V printer MCU, that it has a voltage regulator and a level shifter.

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

An alternative to the ADXL345 is the MPU-9250 (or MPU-6050). This accelerometer has been tested to work over I2C on the RPi at 400kbaud. Recommended connection scheme for I2C:

| MPU-9250 pin | RPi pin | Nome pin RPi |
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

Note that resonance measurements and shaper auto-calibration require additional software dependencies not installed by default. First, run on your Raspberry Pi the following commands:

```
sudo apt update
sudo apt install python3-numpy python3-matplotlib libatlas-base-dev
```

Next, in order to install NumPy in the Klipper environment, run the command:

```
~/klippy-env/bin/pip install -v numpy
```

Note that, depending on the performance of the CPU, it may take *a lot* of time, up to 10-20 minutes. Be patient and wait for the completion of the installation. On some occasions, if the board has too little RAM the installation may fail and you will need to enable swap.

Successivamente, controlla e segui le istruzioni nel [documento RPi Microcontroller](RPi_microcontroller.md) per configurare "linux mcu" sul Raspberry Pi.

Assicurati che il driver SPI di Linux sia abilitato eseguendo `sudo raspi-config` e abilitando SPI nel menu "Opzioni di interfaccia".

For the ADXL345, add the following to the printer.cfg file:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # an example
```

Si consiglia di iniziare con 1 punto sonda, al centro del piano di stampa, leggermente al di sopra di esso.

For the MPU-9250, make sure the Linux I2C driver is enabled and the baud rate is set to 400000 (see [Enabling I2C](RPi_microcontroller.md#optional-enabling-i2c) section for more details). Then, add the following to the printer.cfg:

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[mpu9250]
i2c_mcu: rpi
i2c_bus: i2c.1

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # an example
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
accel_per_hz: 50  # default is 75
probe_points: ...
```

Se funziona per l'asse X, esegui anche per l'asse Y:

```
TEST_RESONANCES AXIS=Y
```

This will generate 2 CSV files (`/tmp/resonances_x_*.csv` and `/tmp/resonances_y_*.csv`). These files can be processed with the stand-alone script on a Raspberry Pi. To do that, run the following commands:

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
max_accel: 3000  # should not exceed the estimated max_accel for X and Y axes
```

oppure puoi scegliere tu stesso un'altra configurazione in base ai grafici generati: i picchi nella densità spettrale di potenza sui grafici corrispondono alle frequenze di risonanza della stampante.

Nota che in alternativa puoi eseguire l'autocalibrazione dello input shaper da Klipper [direttamente](#input-shaper-auto-calibration), che può essere conveniente, ad esempio, per lo input shaper[ricalibrazione](#input-shaper-re-calibrazione).

### Stampanti con piatto scorrevole

Se la tua stampante ha un piatto scorrevole, dovrai cambiare la posizione dell'accelerometro tra le misurazioni per gli assi X e Y: misurare le risonanze dell'asse X con l'accelerometro collegato alla testa di stampa e le risonanze dell'asse Y - al piatto.

Tuttavia, puoi anche collegare due accelerometri contemporaneamente, sebbene debbano essere collegati a schede diverse (ad esempio, a una scheda RPi e MCU della stampante) o a due diverse interfacce SPI fisiche sulla stessa scheda (raramente disponibili). Quindi possono essere configurati nel modo seguente:

```
[adxl345 hotend]
# Assuming `hotend` chip is connected to an RPi
cs_pin: rpi:None

[adxl345 bed]
# Assuming `bed` chip is connected to a printer MCU board
cs_pin: ...  # Printer board SPI chip select (CS) pin

[resonance_tester]
# Assuming the typical setup of the bed slinger printer
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

Note that if you chose a good `max_smoothing` value for both of your axes, you can store it in the `printer.cfg` as

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # an example
```

Then, if you [rerun](#input-shaper-re-calibration) the input shaper auto-tuning using `SHAPER_CALIBRATE` Klipper command in the future, it will use the stored `max_smoothing` value as a reference.

### Seleziona max_accel

Since the input shaper can create some smoothing in parts, especially at high accelerations, you will still need to choose the `max_accel` value that does not create too much smoothing in the printed parts. A calibration script provides an estimate for `max_accel` parameter that should not create too much smoothing. Note that the `max_accel` as displayed by the calibration script is only a theoretical maximum at which the respective shaper is still able to work without producing too much smoothing. It is by no means a recommendation to set this acceleration for printing. The maximum acceleration your printer is able to sustain depends on its mechanical properties and the maximum torque of the used stepper motors. Therefore, it is suggested to set `max_accel` in `[printer]` section that does not exceed the estimated values for X and Y axes, likely with some conservative safety margin.

In alternativa, segui [questa](Resonance_Compensation.md#selecting-max_accel) parte della guida all'ottimizzazione dello input shaper e stampa il modello di test per scegliere sperimentalmente il parametro `max_accel`.

Lo stesso avviso vale per lo input shaper [auto-calibration](#input-shaper-auto-calibration) con il comando `SHAPER_CALIBRATE`: è comunque necessario scegliere il giusto valore di `max_accel` dopo l'auto-calibrazione, e il i limiti di accelerazione non verranno applicati automaticamente.

Se stai eseguendo una ricalibrazione dello shaper e lo smoothing riportato per la configurazione dello shaper suggerita è quasi lo stesso di quello ottenuto durante la calibrazione precedente, questo passaggio può essere saltato.

### Testing custom axes

`TEST_RESONANCES` command supports custom axes. While this is not really useful for input shaper calibration, it can be used to study printer resonances in-depth and to check, for example, belt tension.

To check the belt tension on CoreXY printers, execute

```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```

and use `graph_accelerometer.py` to process the generated files, e.g.

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

which will generate `/tmp/resonances.png` comparing the resonances.

For Delta printers with the default tower placement (tower A ~= 210 degrees, B ~= 330 degrees, and C ~= 90 degrees), execute

```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```

and then use the same command

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

to generate `/tmp/resonances.png` comparing the resonances.

## Calibrazione automatica Input Shaper

Besides manually choosing the appropriate parameters for the input shaper feature, it is also possible to run the auto-tuning for the input shaper directly from Klipper. Run the following command via Octoprint terminal:

```
SHAPER_CALIBRATE
```

This will run the full test for both axes and generate the csv output (`/tmp/calibration_data_*.csv` by default) for the frequency response and the suggested input shapers. You will also get the suggested frequencies for each input shaper, as well as which input shaper is recommended for your setup, on Octoprint console. For example:

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

If you agree with the suggested parameters, you can execute `SAVE_CONFIG` now to save them and restart the Klipper. Note that this will not update `max_accel` value in `[printer]` section. You should update it manually following the considerations in [Selecting max_accel](#selecting-max_accel) section.

If your printer is a bed slinger printer, you can specify which axis to test, so that you can change the accelerometer mounting point between the tests (by default the test is performed for both axes):

```
SHAPER_CALIBRATE AXIS=Y
```

You can execute `SAVE_CONFIG` twice - after calibrating each axis.

However, if you connected two accelerometers simultaneously, you simply run `SHAPER_CALIBRATE` without specifying an axis to calibrate the input shaper for both axes in one go.

### Input Shaper re-calibration

`SHAPER_CALIBRATE` command can be also used to re-calibrate the input shaper in the future, especially if some changes to the printer that can affect its kinematics are made. One can either re-run the full calibration using `SHAPER_CALIBRATE` command, or restrict the auto-calibration to a single axis by supplying `AXIS=` parameter, like

```
SHAPER_CALIBRATE AXIS=X
```

**Warning!** It is not advisable to run the shaper autocalibration very frequently (e.g. before every print, or every day). In order to determine resonance frequencies, autocalibration creates intensive vibrations on each of the axes. Generally, 3D printers are not designed to withstand a prolonged exposure to vibrations near the resonance frequencies. Doing so may increase wear of the printer components and reduce their lifespan. There is also an increased risk of some parts unscrewing or becoming loose. Always check that all parts of the printer (including the ones that may normally not move) are securely fixed in place after each auto-tuning.

Also, due to some noise in measurements, it is possible that the tuning results will be slightly different from one calibration run to another one. Still, it is not expected that the noise will affect the print quality too much. However, it is still advised to double-check the suggested parameters, and print some test prints before using them to confirm they are good.

## Offline processing of the accelerometer data

It is possible to generate the raw accelerometer data and process it offline (e.g. on a host machine), for example to find resonances. In order to do so, run the following commands via Octoprint terminal:

```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```

ignoring any errors for `SET_INPUT_SHAPER` command. For `TEST_RESONANCES` command, specify the desired test axis. The raw data will be written into `/tmp` directory on the RPi.

The raw data can also be obtained by running the command `ACCELEROMETER_MEASURE` command twice during some normal printer activity - first to start the measurements, and then to stop them and write the output file. Refer to [G-Codes](G-Codes.md#adxl345) for more details.

The data can be processed later by the following scripts: `scripts/graph_accelerometer.py` and `scripts/calibrate_shaper.py`. Both of them accept one or several raw csv files as the input depending on the mode. The graph_accelerometer.py script supports several modes of operation:

* plotting raw accelerometer data (use `-r` parameter), only 1 input is supported;
* plotting a frequency response (no extra parameters required), if multiple inputs are specified, the average frequency response is computed;
* comparison of the frequency response between several inputs (use `-c` parameter); you can additionally specify which accelerometer axis to consider via `-a x`, `-a y` or `-a z` parameter (if none specified, the sum of vibrations for all axes is used);
* plotting the spectrogram (use `-s` parameter), only 1 input is supported; you can additionally specify which accelerometer axis to consider via `-a x`, `-a y` or `-a z` parameter (if none specified, the sum of vibrations for all axes is used).

Note that graph_accelerometer.py script supports only the raw_data\*.csv files and not resonances\*.csv or calibration_data\*.csv files.

For example,

```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```

will plot the comparison of several `/tmp/raw_data_x_*.csv` files for Z axis to `/tmp/resonances_x.png` file.

The shaper_calibrate.py script accepts 1 or several inputs and can run automatic tuning of the input shaper and suggest the best parameters that work well for all provided inputs. It prints the suggested parameters to the console, and can additionally generate the chart if `-o output.png` parameter is provided, or the CSV file if `-c output.csv` parameter is specified.

Providing several inputs to shaper_calibrate.py script can be useful if running some advanced tuning of the input shapers, for example:

* Running `TEST_RESONANCES AXIS=X OUTPUT=raw_data` (and `Y` axis) for a single axis twice on a bed slinger printer with the accelerometer attached to the toolhead the first time, and the accelerometer attached to the bed the second time in order to detect axes cross-resonances and attempt to cancel them with input shapers.
* Running `TEST_RESONANCES AXIS=Y OUTPUT=raw_data` twice on a bed slinger with a glass bed and a magnetic surfaces (which is lighter) to find the input shaper parameters that work well for any print surface configuration.
* Combining the resonance data from multiple test points.
* Combining the resonance data from 2 axis (e.g. on a bed slinger printer to configure X-axis input_shaper from both X and Y axes resonances to cancel vibrations of the *bed* in case the nozzle 'catches' a print when moving in X axis direction).
