# Caratteristiche

Klipper ha diverse caratteristiche interessanti:

* High precision stepper movement. Klipper utilizes an application processor (such as a low-cost Raspberry Pi) when calculating printer movements. The application processor determines when to step each stepper motor, it compresses those events, transmits them to the micro-controller, and then the micro-controller executes each event at the requested time. Each stepper event is scheduled with a precision of 25 micro-seconds or better. The software does not use kinematic estimations (such as the Bresenham algorithm) - instead it calculates precise step times based on the physics of acceleration and the physics of the machine kinematics. More precise stepper movement provides quieter and more stable printer operation.
* Le migliori prestazioni della classe. Klipper è in grado di raggiungere elevate velocità di stepping su microcontrollori nuovi e vecchi. Anche i vecchi microcontrollori a 8 bit possono ottenere velocità di oltre 175.000 passi al secondo. Sui microcontrollori più recenti sono possibili diversi milioni di passi al secondo. Velocità stepper più elevate consentono velocità di stampa più elevate. Il timing dell'evento stepper rimane preciso anche a velocità elevate, migliorando la stabilità generale.
* Klipper supporta stampanti con più microcontrollori. Ad esempio, un microcontrollore potrebbe essere utilizzato per controllare un estrusore, mentre un altro controlla i riscaldatori della stampante, mentre un terzo controlla il resto della stampante. Il software host Klipper implementa la sincronizzazione dell'orologio per tenere conto della deriva dell'orologio tra i microcontrollori. Non è necessario alcun codice speciale per abilitare più microcontrollori: sono necessarie solo alcune righe in più nel file di configurazione.
* Configurazione tramite semplice file. Non è necessario eseguire il reflash del microcontrollore per modificare un'impostazione. Tutta la configurazione di Klipper è memorizzata in un file di configurazione standard che può essere facilmente modificato. Ciò semplifica la configurazione e la manutenzione dell'hardware.
* Klipper supporta "Smooth Pressure Advance", un meccanismo per tenere conto degli effetti della pressione all'interno di un estrusore. Ciò riduce la "melma" dell'estrusore e migliora la qualità degli angoli di stampa. L'implementazione di Klipper non introduce variazioni istantanee della velocità dell'estrusore, il che migliora la stabilità e la robustezza complessive.
* Klipper supporta "Input Shaping" per ridurre l'impatto delle vibrazioni sulla qualità di stampa. Ciò può ridurre o eliminare il "ringing" (noto anche come "ghosting", "eco" o "increspatura") nelle stampe. Può anche consentire di ottenere velocità di stampa più elevate pur mantenendo un'elevata qualità di stampa.
* Klipper utilizza un "risolutore iterativo" per calcolare sequenze temporali precisi da semplici equazioni cinematiche. Ciò semplifica il porting di Klipper su nuovi tipi di robot e mantiene i tempi precisi anche con cinematiche complesse (non è necessaria la "segmentazione della linea").
* Klipper is hardware agnostic. One should get the same precise timing independent of the low-level electronics hardware. The Klipper micro-controller code is designed to faithfully follow the schedule provided by the Klipper host software (or prominently alert the user if it is unable to). This makes it easier to use available hardware, to upgrade to new hardware, and to have confidence in the hardware.
* Codice portatile. Klipper funziona su microcontrollori basati su ARM, AVR e PRU. Le stampanti esistenti in stile "reprap" possono eseguire Klipper senza modifiche hardware: basta aggiungere un Raspberry Pi. Il layout del codice interno di Klipper semplifica il supporto anche di altre architetture di microcontrollori.
* Codice più semplice. Klipper utilizza un linguaggio di alto livello (Python) per la maggior parte del codice. Gli algoritmi cinematici, l'analisi del G-code, gli algoritmi di riscaldamento e termistore, ecc. sono tutti scritti in Python. Ciò semplifica lo sviluppo di nuove funzionalità.
* Macro programmabili personalizzate. È possibile definire nuovi comandi G-Code nel file di configurazione della stampante (non sono necessarie modifiche al codice). Questi comandi sono programmabili, consentendo loro di produrre azioni diverse a seconda dello stato della stampante.
* Server API integrato. Oltre all'interfaccia G-Code standard, Klipper supporta una ricca interfaccia applicativa basata su JSON. Ciò consente ai programmatori di creare applicazioni esterne con un controllo dettagliato della stampante.

## Caratteristiche aggiuntive

Klipper supporta molte funzionalità standard della stampante 3D:

* Several web interfaces available. Works with Mainsail, Fluidd, OctoPrint and others. This allows the printer to be controlled using a regular web-browser. The same Raspberry Pi that runs Klipper can also run the web interface.
* Supporto G-code standard. Sono supportati i comandi G-code comuni prodotti dai tipici "slicer" (SuperSlicer, Cura, PrusaSlicer, ecc.).
* Supporto per più estrusori. Sono supportati anche estrusori con riscaldatori condivisi ed estrusori su carrelli indipendenti (IDEX).
* Support for cartesian, delta, corexy, corexz, hybrid-corexy, hybrid-corexz, deltesian, rotary delta, polar, and cable winch style printers.
* Supporto per il livellamento automatico del letto. Klipper può essere configurato per il rilevamento di base dell'inclinazione del piatto o per il livellamento del piatto a mesh completa. Se il piatto utilizza più stepper Z, Klipper può anche livellare manipolando in modo indipendente gli stepper Z. Sono supportate la maggior parte delle sonde di altezza Z, comprese le sonde BL-Touch e le sonde servoattivate.
* Supporto per la calibrazione delta automatica. Lo strumento di calibrazione può eseguire la calibrazione dell'altezza di base e una calibrazione avanzata delle dimensioni X e Y. La calibrazione può essere eseguita con una sonda di altezza Z o tramite tastatura manuale.
* Run-time "exclude object" support. When configured, this module may facilitate canceling of just one object in a multi-part print.
* Supporto per sensori di temperatura comuni (ad es. termistori comuni, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20 e LM75). È inoltre possibile configurare termistori personalizzati e sensori di temperatura analogici personalizzati. È possibile monitorare il sensore di temperatura del microcontrollore interno e il sensore di temperatura interna di un Raspberry Pi.
* Protezione del riscaldatore termico di base abilitata di default.
* Supporto per ventole standard, ventole per ugelli e ventole a temperatura controllata. Non è necessario mantenere le ventole in funzione quando la stampante è inattiva. La velocità della ventola può essere monitorata su ventole dotate di contagiri.
* Support for run-time configuration of TMC2130, TMC2208/TMC2224, TMC2209, TMC2660, and TMC5160 stepper motor drivers. There is also support for current control of traditional stepper drivers via AD5206, DAC084S085, MCP4451, MCP4728, MCP4018, and PWM pins.
* Supporto per comuni display LCD collegati direttamente alla stampante. È disponibile anche un menu predefinito. Il contenuto del display e del menu può essere completamente personalizzato tramite il file di configurazione.
* Accelerazione costante e supporto "look-ahead". Tutti i movimenti della stampante accelereranno gradualmente dall'arresto alla velocità di crociera, quindi decelereranno fino all'arresto. Il flusso in entrata dei comandi di movimento del G-code viene messo in coda e analizzato: l'accelerazione tra i movimenti in una direzione simile sarà ottimizzata per ridurre gli arresti di stampa e migliorare il tempo di stampa complessivo.
* Klipper implementa un algoritmo "stepper phase endstop" che può migliorare la precisione dei tipici interruttori endstop. Se regolato correttamente, può migliorare l'adesione del primo strato di stampa.
* Supporto per sensori di presenza del filamento, sensori di movimento del filamento e sensori di larghezza del filamento.
* Support for measuring and recording acceleration using an adxl345, mpu9250, and mpu6050 accelerometers.
* Supporto per limitare la velocità massima di brevi spostamenti a "zigzag" per ridurre le vibrazioni e il rumore della stampante. Per ulteriori informazioni, vedere il documento [cinematica](Kinematics.md).
* Sono disponibili file di configurazione di esempio per molte stampanti comuni. Controllare la [directory di configurazione](../config/) per un elenco.

Per iniziare con Klipper, leggi la guida [installazione](Installation.md).

## Benchmark dei passi

Di seguito sono riportati i risultati dei test delle prestazioni degli stepper. I numeri visualizzati rappresentano il numero totale di passi al secondo sul microcontrollore.

| Microcontrollore | 1 stepper attivo | 3 stepper attivi |
| --- | --- | --- |
| 16Mhz AVR | 157K | 99K |
| 20Mhz AVR | 196K | 123K |
| SAMD21 | 686K | 471K |
| STM32F042 | 814K | 578K |
| Beaglebone PRU | 866K | 708K |
| STM32G0B1 | 1103K | 790K |
| STM32F103 | 1180K | 818K |
| SAM3X8E | 1273K | 981K |
| SAM4S8C | 1690K | 1385K |
| LPC1768 | 1923K | 1351K |
| LPC1769 | 2353K | 1622K |
| RP2040 | 2400K | 1636K |
| SAM4E8E | 2500K | 1674K |
| SAMD51 | 3077K | 1885K |
| STM32F407 | 3652K | 2459K |
| STM32F446 | 3913K | 2634K |
| STM32H743 | 9091K | 6061K |

Se non sei sicuro del microcontrollore su una particolare scheda, trova il [file di configurazione](../config/) appropriato e cerca il nome del microcontrollore nei commenti nella parte superiore di quel file.

Ulteriori dettagli sui benchmark sono disponibili nel [documento Benchmarks](Benchmarks.md).
