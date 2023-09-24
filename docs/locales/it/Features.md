# Caratteristiche

Klipper ha diverse caratteristiche interessanti:

* Movimento passo-passo di alta precisione. Klipper utilizza un processore applicativo (come un Raspberry Pi a basso costo) per calcolare i movimenti della stampante. Il processore dell'applicazione determina quando far avanzare ciascun motore passo-passo, comprime quegli eventi, li trasmette al microcontrollore e quindi il microcontrollore esegue ogni evento all'ora richiesta. Ogni evento stepper è programmato con una precisione di 25 microsecondi o superiore. Il software non utilizza stime cinematiche (come l'algoritmo di Bresenham), ma calcola tempi di passo precisi in base alla fisica dell'accelerazione e alla fisica della cinematica della macchina. Il movimento passo-passo più preciso garantisce un funzionamento della stampante più silenzioso e stabile.
* Le migliori prestazioni della categoria. Klipper è in grado di raggiungere velocità di passo elevate sia sui microcontrollori nuovi che su quelli vecchi. Anche i vecchi microcontrollori a 8 bit possono ottenere velocità superiori a 175.000 passi al secondo. Sui microcontrollori più recenti sono possibili diversi milioni di passi al secondo. Velocità di stepper più elevate consentono velocità di stampa più elevate. La temporizzazione degli eventi dello stepper rimane precisa anche a velocità elevate, migliorando la stabilità generale.
* Klipper supporta stampanti con più microcontrollori. Ad esempio, un microcontrollore potrebbe essere utilizzato per controllare un estrusore, mentre un altro controlla i riscaldatori della stampante, mentre un terzo controlla il resto della stampante. Il software host Klipper implementa la sincronizzazione dell'orologio per tenere conto della deriva dell'orologio tra i microcontrollori. Non è necessario alcun codice speciale per abilitare più microcontrollori: sono necessarie solo alcune righe in più nel file di configurazione.
* Configurazione tramite semplice file. Non è necessario eseguire il reflash del microcontrollore per modificare un'impostazione. Tutta la configurazione di Klipper è memorizzata in un file di configurazione standard che può essere facilmente modificato. Ciò semplifica la configurazione e la manutenzione dell'hardware.
* Klipper supporta "Smooth Pressure Advance", un meccanismo per tenere conto degli effetti della pressione all'interno di un estrusore. Ciò riduce la "melma" dell'estrusore e migliora la qualità degli angoli di stampa. L'implementazione di Klipper non introduce variazioni istantanee della velocità dell'estrusore, il che migliora la stabilità e la robustezza complessive.
* Klipper supporta "Input Shaping" per ridurre l'impatto delle vibrazioni sulla qualità di stampa. Ciò può ridurre o eliminare il "ringing" (noto anche come "ghosting", "eco" o "increspatura") nelle stampe. Può anche consentire di ottenere velocità di stampa più elevate pur mantenendo un'elevata qualità di stampa.
* Klipper utilizza un "risolutore iterativo" per calcolare sequenze temporali precisi da semplici equazioni cinematiche. Ciò semplifica il porting di Klipper su nuovi tipi di robot e mantiene i tempi precisi anche con cinematiche complesse (non è necessaria la "segmentazione della linea").
* Klipper è indipendente dall'hardware. Si dovrebbe ottenere la stessa tempistica precisa indipendentemente dall'hardware dell'elettronica di basso livello. Il codice del microcontrollore Klipper è progettato per seguire fedelmente la pianificazione fornita dal software host Klipper (o avvisare in modo evidente l'utente se non è in grado di farlo). Ciò semplifica l'utilizzo dell'hardware disponibile, l'aggiornamento al nuovo hardware e la fiducia nell'hardware.
* Codice portatile. Klipper funziona su microcontrollori basati su ARM, AVR e PRU. Le stampanti esistenti in stile "reprap" possono eseguire Klipper senza modifiche hardware: basta aggiungere un Raspberry Pi. Il layout del codice interno di Klipper semplifica il supporto anche di altre architetture di microcontrollori.
* Codice più semplice. Klipper utilizza un linguaggio di alto livello (Python) per la maggior parte del codice. Gli algoritmi cinematici, l'analisi del G-code, gli algoritmi di riscaldamento e termistore, ecc. sono tutti scritti in Python. Ciò semplifica lo sviluppo di nuove funzionalità.
* Macro programmabili personalizzate. È possibile definire nuovi comandi G-Code nel file di configurazione della stampante (non sono necessarie modifiche al codice). Questi comandi sono programmabili, consentendo loro di produrre azioni diverse a seconda dello stato della stampante.
* Server API integrato. Oltre all'interfaccia G-Code standard, Klipper supporta una ricca interfaccia applicativa basata su JSON. Ciò consente ai programmatori di creare applicazioni esterne con un controllo dettagliato della stampante.

## Caratteristiche aggiuntive

Klipper supporta molte funzionalità standard della stampante 3D:

* Diverse interfacce web disponibili. Funziona con Randa, Fluidd, OctoPrint e altri. Ciò consente di controllare la stampante utilizzando un normale browser web. Lo stesso Raspberry Pi che esegue Klipper può anche eseguire l'interfaccia web.
* Supporto G-code standard. Sono supportati i comandi G-code comuni prodotti dai tipici "slicer" (SuperSlicer, Cura, PrusaSlicer, ecc.).
* Supporto per più estrusori. Sono supportati anche estrusori con riscaldatori condivisi ed estrusori su carrelli indipendenti (IDEX).
* Supporto per stampanti cartesiane, delta, corexy, corexz, hybrid-corexy, hybrid-corexz, deltesian, rotary delta, polar e cable winch.
* Supporto per il livellamento automatico del letto. Klipper può essere configurato per il rilevamento di base dell'inclinazione del piatto o per il livellamento del piatto a mesh completa. Se il piatto utilizza più stepper Z, Klipper può anche livellare manipolando in modo indipendente gli stepper Z. Sono supportate la maggior parte delle sonde di altezza Z, comprese le sonde BL-Touch e le sonde servoattivate.
* Supporto per la calibrazione delta automatica. Lo strumento di calibrazione può eseguire la calibrazione dell'altezza di base e una calibrazione avanzata delle dimensioni X e Y. La calibrazione può essere eseguita con una sonda di altezza Z o tramite tastatura manuale.
* Supporto "escludi oggetto" in fase di esecuzione. Se configurato, questo modulo può facilitare l'annullamento di un solo oggetto in una stampa multiparte.
* Supporto per sensori di temperatura comuni (ad es. termistori comuni, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20 e LM75). È inoltre possibile configurare termistori personalizzati e sensori di temperatura analogici personalizzati. È possibile monitorare il sensore di temperatura del microcontrollore interno e il sensore di temperatura interna di un Raspberry Pi.
* Protezione del riscaldatore termico di base abilitata di default.
* Supporto per ventole standard, ventole per ugelli e ventole a temperatura controllata. Non è necessario mantenere le ventole in funzione quando la stampante è inattiva. La velocità della ventola può essere monitorata su ventole dotate di contagiri.
* Supporto per la configurazione in fase di esecuzione dei driver per motori passo-passo TMC2130, TMC2208/TMC2224, TMC2209, TMC2660 e TMC5160. È inoltre disponibile il supporto per il controllo corrente dei tradizionali driver passo-passo tramite i pin AD5206, DAC084S085, MCP4451, MCP4728, MCP4018 e PWM.
* Supporto per comuni display LCD collegati direttamente alla stampante. È disponibile anche un menu predefinito. Il contenuto del display e del menu può essere completamente personalizzato tramite il file di configurazione.
* Accelerazione costante e supporto "look-ahead". Tutti i movimenti della stampante accelereranno gradualmente dall'arresto alla velocità di crociera, quindi decelereranno fino all'arresto. Il flusso in entrata dei comandi di movimento del G-code viene messo in coda e analizzato: l'accelerazione tra i movimenti in una direzione simile sarà ottimizzata per ridurre gli arresti di stampa e migliorare il tempo di stampa complessivo.
* Klipper implementa un algoritmo "stepper phase endstop" che può migliorare la precisione dei tipici interruttori endstop. Se regolato correttamente, può migliorare l'adesione del primo strato di stampa.
* Supporto per sensori di presenza del filamento, sensori di movimento del filamento e sensori di larghezza del filamento.
* Supporto per misurare e registrare l'accelerazione utilizzando gli accelerometri adxl345, mpu9250 e mpu6050.
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
| AR100 | 3529K | 2507K |
| STM32F407 | 3652K | 2459K |
| STM32F446 | 3913K | 2634K |
| STM32H743 | 9091K | 6061K |

Se non sei sicuro del microcontrollore su una particolare scheda, trova il [file di configurazione](../config/) appropriato e cerca il nome del microcontrollore nei commenti nella parte superiore di quel file.

Ulteriori dettagli sui benchmark sono disponibili nel [documento Benchmarks](Benchmarks.md).
