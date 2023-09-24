# Misurazione delle risonanze

Klipper has built-in support for the ADXL345 and MPU-9250 compatible accelerometers which can be used to measure resonance frequencies of the printer for different axes, and auto-tune [input shapers](Resonance_Compensation.md) to compensate for resonances. Note that using accelerometers requires some soldering and crimping. The ADXL345 can be connected to the SPI interface of a Raspberry Pi or MCU board (it needs to be reasonably fast). The MPU family can be connected to the I2C interface of a Raspberry Pi directly, or to an I2C interface of an MCU board that supports 400kbit/s *fast mode* in Klipper.

When sourcing accelerometers, be aware that there are a variety of different PCB board designs and different clones of them. If it is going to be connected to a 5V printer MCU ensure it has a voltage regulator and level shifters.

For ADXL345s, make sure that the board supports SPI mode (a small number of boards appear to be hard-configured for I2C by pulling SDO to GND).

For MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500s there are also a variety of board designs and clones with different I2C pull-up resistors which will need supplementing.

## MCUs with Klipper I2C *fast-mode* Support

| MCU Family | MCU(s) Tested | MCU(s) with Support |
| :-: | :-- | :-- |
| Raspberry Pi | 3B+, Pico | 3A, 3A+, 3B, 4 |
| AVR ATmega | ATmega328p | ATmega32u4, ATmega128, ATmega168, ATmega328, ATmega644p, ATmega1280, ATmega1284, ATmega2560 |
| AVR AT90 | - | AT90usb646, AT90usb1286 |

## Istruzioni per l'installazione

### Cablaggio

An ethernet cable with shielded twisted pairs (cat5e or better) is recommended for signal integrity over a long distance. If you still experience signal integrity issues (SPI/I2C errors):

- Double check the wiring with a digital multimeter for:
   - Correct connections when turned off (continuity)
   - Correct power and ground voltages
- I2C only:
   - Check the SCL and SDA lines' resistances to 3.3V are in the range of 900 ohms to 1.8K
   - For full technical details consult [chapter 7 of the I2C-bus specification and user manual UM10204](https://www.pololu.com/file/0J435/UM10204.pdf) for *fast-mode*
- Shorten the cable

Connect ethernet cable shielding only to the MCU board/Pi ground.

***Ricontrolla il cablaggio prima di accendere per evitare di danneggiare il tuo MCU/Raspberry Pi o l'accelerometro.***

### Accelerometri SPI

Suggested twisted pair order for three twisted pairs:

```
GND+MISO
3.3V+MOSI
SCLK+CS
```

Note that unlike a cable shield, GND must be connected at both ends.

#### ADXL345

##### Diretto a Raspberry Pi

**Note: Many MCUs will work with an ADXL345 in SPI mode (e.g. Pi Pico), wiring and configuration will vary according to your specific board and available pins.**

Devi connettere ADXL345 al tuo Raspberry Pi tramite SPI. Si noti che la connessione I2C, suggerita dalla documentazione di ADXL345, ha un throughput troppo basso e **non funzionerà**. Lo schema di connessione consigliato:

| ADXL345 pin | RPi pin | Nome pin RPi |
| :-: | :-: | :-: |
| 3V3 (or VCC) | 01 | 3.3V DC power |
| GND | 06 | Ground |
| CS | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

Schemi collegamenti Fritzing per alcune delle schede ADXL345:

![ADXL345-Rpi](img/adxl345-fritzing.png)

##### Utilizzo di Raspberry Pi Pico

Puoi collegare ADXL345 al tuo Raspberry Pi Pico e quindi collegare Pico al tuo Raspberry Pi tramite USB. Ciò semplifica il riutilizzo dell'accelerometro su altri dispositivi Klipper, poiché puoi connetterti tramite USB anziché GPIO. Il Pico non ha molta potenza di elaborazione, quindi assicurati che stia solo eseguendo l'accelerometro e non svolga altre funzioni.

Per evitare danni al tuo RPi assicurati di collegare l'ADXL345 solo a 3,3 V. A seconda del layout della scheda, potrebbe essere presente un cambio di livello, che rende i 5 V pericolosi per il tuo RPi.

| ADXL345 pin | pin Pico | Nome pin Pico |
| :-: | :-: | :-: |
| 3V3 (or VCC) | 36 | 3.3V DC power |
| GND | 38 | Ground |
| CS | 2 | GP1 (SPI0_CSn) |
| SDO | 1 | GP0 (SPI0_RX) |
| SDA | 5 | GP3 (SPI0_TX) |
| SCL | 4 | GP2 (SPI0_SCK) |

Schemi di collegamento per alcune schede ADXL345:

![ADXL345-Pico](img/adxl345-pico.png)

### Accelerometri I2C

Suggested twisted pair order for three pairs (preferred):

```
3.3V+GND
SDA+GND
SCL+GND
```

or for two pairs:

```
3.3V+SDA
GND+SCL
```

Note that unlike a cable shield, any GND(s) should be connected at both ends.

#### MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500

These accelerometers have been tested to work over I2C on the RPi, RP2040 (Pico) and AVR at 400kbit/s (*fast mode*). Some MPU accelerometer modules include pull-ups, but some are too large at 10K and must be changed or supplemented by smaller parallel resistors.

Schema di connessione consigliato per I2C su Raspberry Pi:

| pin MPU-9250 | RPi pin | Nome pin RPi |
| :-: | :-: | :-: |
| VCC | 01 | 3.3v alimentazione DC |
| GND | 09 | Ground |
| SDA | 03 | GPIO02 (SDA1) |
| SCL | 05 | GPIO03 (SCL1) |

The RPi has buit-in 1.8K pull-ups on both SCL and SDA.

![MPU-9250 connected to Pi](img/mpu9250-PI-fritzing.png)

Recommended connection scheme for I2C (i2c0a) on the RP2040:

| pin MPU-9250 | pin RP2040 | RP2040 pin name |
| :-: | :-: | :-: |
| VCC | 36 | 3v3 |
| GND | 38 | Ground |
| SDA | 01 | GP0 (I2C0 SDA) |
| SCL | 02 | GP1 (I2C0 SCL) |

The Pico does not include any built-in I2C pull-up resistors.

![MPU-9250 connected to Pico](img/mpu9250-PICO-fritzing.png)

##### Recommended connection scheme for I2C(TWI) on the AVR ATmega328P Arduino Nano:

| pin MPU-9250 | Atmega328P TQFP32 pin | Atmega328P pin name | Arduino Nano pin |
| :-: | :-: | :-: | :-: |
| VCC | 39 | - | - |
| GND | 38 | Ground | GND |
| SDA | 27 | SDA | A4 |
| SCL | 28 | SCL | A5 |

The Arduino Nano does not include any built-in pull-up resistors nor a 3.3V power pin.

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

#### Configura ADXL345 con RPi

First, check and follow the instructions in the [RPi Microcontroller document](RPi_microcontroller.md) to setup the "linux mcu" on the Raspberry Pi. This will configure a second Klipper instance that runs on your Pi.

Assicurati che il driver SPI di Linux sia abilitato eseguendo `sudo raspi-config` e abilitando SPI nel menu "Opzioni di interfaccia".

Aggiungere quanto segue al file printer.cfg:

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

#### Configura ADXL345 con Pi Pico

##### Aggiorna il firmware Pico

Sul tuo Raspberry Pi, compila il firmware per Pico.

```
cd ~/klipper
make clean
make menuconfig
```

![Pico menuconfig](img/klipper_pico_menuconfig.png)

Ora, tenendo premuto il pulsante `BOOTSEL` sul Pico, collega il Pico al Raspberry Pi tramite USB. Compilare e eseguire il flashing del firmware.

```
make flash FLASH_DEVICE=first
```

Se fallisce, ti verrà detto quale `FLASH_DEVICE` utilizzare. In questo esempio si tratta di `make flash FLASH_DEVICE=2e8a:0003`. ![Determina dispositivo flash](img/flash_rp2040_FLASH_DEVICE.png)

##### Configura la connessione

Il Pico ora si riavvierà con il nuovo firmware e dovrebbe apparire come dispositivo seriale. Trova il dispositivo pico seriale con `ls /dev/serial/by-id/*`. Ora puoi aggiungere un file `adxl.cfg` con le seguenti impostazioni:

```
[mcu adxl]
# Cambia <mySerial> con quello che hai trovato sopra. Per esempio,
# usb-Klipper_rp2040_E661640843545B2E-if00
serial: /dev/serial/by-id/usb-Klipper_rp2040_<mySerial>

[adxl345]
cs_pin: adxl:gpio1
spi_bus: spi0a
axes_map: x,z,y

[resonance_tester]
accel_chip: adxl345
probe_points:
    # Da qualche parte leggermente sopra la metà del piano di stampa
    147,154, 20

[output_pin power_mode] #Migliora la stabilità dell' alimentazione
pin: adxl:gpio23
```

Se imposti la configurazione di ADXL345 in un file separato, come mostrato sopra, ti consigliamo di modificare anche il file `printer.cfg` per includere questo:

```
[include adxl.cfg] # Commenta questo quando scolleghi l'accelerometro
```

Riavvia Klipper tramite il comando `RESTART`.

#### Configura la serie MPU-6000/9000 con RPi

Assicurati che il driver Linux I2C sia abilitato e che la velocità di trasmissione sia impostata su 400000 (consulta la sezione [Abilitazione di I2C](RPi_microcontroller.md#optional-enabling-i2c) per ulteriori dettagli). Quindi, aggiungi quanto segue a printer.cfg:

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

#### Configure MPU-9520 Compatibles With Pico

Pico I2C is set to 400000 on default. Simply add the following to the printer.cfg:

```
[mcu pico]
serial: /dev/serial/by-id/<your Pico's serial ID>

[mpu9250]
i2c_mcu: pico
i2c_bus: i2c0a

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # an example

[static_digital_output pico_3V3pwm] # Improve power stability
pins: pico:gpio23
```

#### Configure MPU-9520 Compatibles with AVR

AVR I2C will be set to 400000 by the mpu9250 option. Simply add the following to the printer.cfg:

```
[mcu nano]
serial: /dev/serial/by-id/<your nano's serial ID>

[mpu9250]
i2c_mcu: nano

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

Se ricevi un errore del tipo `ID adxl345 non valido (ottenuto xx vs e5)`, dove `xx` è un altro ID, riprova immediatamente. Si è verificato un problema con l'inizializzazione SPI. Se ricevi ancora un errore, è indicativo del problema di connessione con ADXL345 o del sensore difettoso. Ricontrolla l'alimentazione, il cablaggio (che corrisponda agli schemi, nessun filo sia rotto o allentato, ecc.) e la qualità della saldatura.

**If you are using a MPU-9250 compatible accelerometer and it shows up as `mpu-unknown`, use with caution! They are probably refurbished chips!**

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

Nota che in alternativa puoi eseguire la calibrazione automatica dell input shaper da Klipper [directly](#input-shaper-auto-calibration), che può essere conveniente, ad esempio, per la [re-calibration](#input-shaper-re-calibration).

### Stampanti con piatto scorrevole

Se la tua stampante ha un piatto scorrevole, dovrai cambiare la posizione dell'accelerometro tra le misurazioni per gli assi X e Y: misurare le risonanze dell'asse X con l'accelerometro collegato alla testa di stampa e le risonanze dell'asse Y - al piatto.

However, you can also connect two accelerometers simultaneously, though the ADXL345 must be connected to different boards (say, to an RPi and printer MCU board), or to two different physical SPI interfaces on the same board (rarely available). Then they can be configured in the following manner:

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

Two MPUs can share one I2C bus, but they **cannot** measure simultaneously as the 400kbit/s I2C bus is not fast enough. One must have its AD0 pin pulled-down to 0V (address 104) and the other its AD0 pin pulled-up to 3.3V (address 105):

```
[mpu9250 hotend]
i2c_mcu: rpi
i2c_bus: i2c.1
i2c_address: 104 # This MPU has pin AD0 pulled low

[mpu9250 bed]
i2c_mcu: rpi
i2c_bus: i2c.1
i2c_address: 105 # This MPU has pin AD0 pulled high

[resonance_tester]
# Assuming the typical setup of the bed slinger printer
accel_chip_x: mpu9250 hotend
accel_chip_y: mpu9250 bed
probe_points: ...
```

[Test with each MPU individually before connecting both to the bus for easy debugging.]

Quindi i comandi `TEST_RESONANCES AXIS=X` e `TEST_RESONANCES AXIS=Y` utilizzeranno l'accelerometro corretto per ciascun asse.

### Max smoothing

Tieni presente che lo input shaper può creare un po' di smoothing nelle parti. La regolazione automatica del input shaper eseguita dallo script `calibrate_shaper.py` o dal comando `SHAPER_CALIBRATE` cercano di non esacerbare lo smoothing, ma allo stesso tempo cercano di ridurre al minimo le vibrazioni risultanti. A volte possono fare una scelta non ottimale della frequenza dello shaper, o forse semplicemente preferisci avere meno smoothing in alcune parti a scapito di maggiori vibrazioni residue. In questi casi è possibile richiedere di limitare lo smoothing massimo dal input shaper.

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

Si noti che i valori di `smoothing` riportati sono alcuni valori proiettati. Questi valori possono essere utilizzati per confrontare diverse configurazioni: maggiore è il valore, maggiore sarà la levigatura creata da uno shaper. Tuttavia, questi punteggi di smoothing non rappresentano alcuna misura reale dello smoothing, perché lo smoothing effettivo dipende dai parametri [`max_accel`](#selecting-max-accel) e `square_corner_velocity`. Pertanto, è necessario eseguire alcune stampe di prova per vedere quanta smoothing crea esattamente una configurazione scelta.

Nell'esempio sopra i parametri dello shaper suggeriti non sono male, ma cosa succede se si desidera ottenere meno smooting sull'asse X? Puoi provare a limitare lo smoothing massimo dello shaper usando il seguente comando:

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```

che limita lo smoothing a un punteggio di 0.2. Ora puoi ottenere il seguente risultato:

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

Se si confronta con i parametri suggeriti in precedenza, le vibrazioni sono un po' maggiori, ma lo smoothing è notevolmente inferiore rispetto a prima, consentendo un'accelerazione massima maggiore.

Quando si decide quale parametro `max_smoothing` scegliere, è possibile utilizzare un approccio per tentativi. Prova alcuni valori diversi e guarda quali risultati ottieni. Si noti che lo smoothing effettivo prodotto dall'input shaper dipende principalmente dalla frequenza di risonanza più bassa della stampante: maggiore è la frequenza della risonanza più bassa, minore è lo smoothing. Pertanto, se si richiede allo script di trovare una configurazione dell'input shaper con lo smoothing irrealisticamente piccolo, sarà a scapito di un aumento del ringing alle frequenze di risonanza più basse (che sono, in genere, anche più visibili nelle stampe). Quindi, ricontrolla sempre le vibrazioni rimanenti previste riportate dallo script e assicurati che non siano troppo alte.

Nota che se hai scelto un buon valore `max_smoothing` per entrambi gli assi, puoi salvarlo in `printer.cfg` come

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # un esempio
```

Quindi, se [riesegui](#input-shaper-re-calibration) l'autotuning dello shaper di input usando il comando Klipper `SHAPER_CALIBRATE` in futuro, utilizzerà il valore `max_smoothing` memorizzato come riferimento.

### Seleziona max_accel

Poiché l'input shaper può creare un po' di smussamento nelle parti, specialmente ad accelerazioni elevate, sarà comunque necessario scegliere il valore `max_accel` che non crei troppo smussamento "smoothing" nelle parti stampate. Uno script di calibrazione fornisce una stima per il parametro `max_accel` che non dovrebbe creare un smoothing eccessivo. Si noti che il `max_accel` visualizzato dallo script di calibrazione è solo un massimo teorico al quale il rispettivo shaper è ancora in grado di lavorare senza produrre troppo smoothing. Non è affatto una raccomandazione impostare questa accelerazione per la stampa. L'accelerazione massima che la stampante è in grado di sostenere dipende dalle sue proprietà meccaniche e dalla coppia massima dei motori passo-passo utilizzati. Pertanto, si suggerisce di impostare `max_accel` nella sezione `[printer]` che non superi i valori stimati per gli assi X e Y, probabilmente con un margine di sicurezza conservativo.

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

Se la tua stampante è una stampante a piatto mobile, puoi specificare quale asse testare, in modo da poter cambiare il punto di montaggio dell'accelerometro tra i test (per impostazione predefinita, il test viene eseguito per entrambi gli assi):

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

**Attenzione!** Non è consigliabile eseguire la calibrazione automatica del modellatore molto frequentemente (ad esempio prima di ogni stampa o ogni giorno). Per determinare le frequenze di risonanza, l'autocalibrazione crea vibrazioni intense su ciascuno degli assi. Generalmente le stampanti 3D non sono progettate per resistere ad un’esposizione prolungata a vibrazioni vicine alle frequenze di risonanza. Ciò potrebbe aumentare l'usura dei componenti della stampante e ridurne la durata. Esiste anche un rischio maggiore che alcune parti si svitino o si allentino. Controllare sempre che tutte le parti della stampante (comprese quelle che normalmente potrebbero non muoversi) siano fissate saldamente in posizione dopo ogni regolazione automatica.

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
