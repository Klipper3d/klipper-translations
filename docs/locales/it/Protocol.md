# Protocollo

Il protocollo di messaggistica Klipper viene utilizzato per la comunicazione di basso livello tra il software host Klipper e il software microcontrollore Klipper. Ad alto livello il protocollo può essere pensato come una serie di stringhe di comando e risposta che vengono compresse, trasmesse e quindi elaborate sul lato ricevente. Una serie di esempio di comandi in formato non compresso leggibile dall'uomo potrebbe essere simile a:

```
set_digital_out pin=PA3 value=1
set_digital_out pin=PA7 value=1
schedule_digital_out oid=8 clock=4000000 value=0
queue_step oid=7 interval=7458 count=10 add=331
queue_step oid=7 interval=11717 count=4 add=1281
```

Vedere il documento [mcu commands](MCU_Commands.md) per informazioni sui comandi disponibili. Vedere il documento [debugging](Debugging.md) per informazioni su come tradurre un file G-Code nei corrispondenti comandi del microcontrollore leggibili dall'uomo.

Questa pagina fornisce una descrizione di alto livello del protocollo di messaggistica Klipper. Descrive come i messaggi sono dichiarati, codificati in formato binario (lo schema di "compressione") e trasmessi.

L'obiettivo del protocollo è abilitare un canale di comunicazione privo di errori tra l'host e il microcontrollore che sia a bassa latenza, bassa larghezza di banda e bassa complessità per il microcontrollore.

## Interfaccia microcontrollore

Il protocollo di trasmissione Klipper può essere pensato come un meccanismo [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call) tra microcontrollore e host. Il software del microcontrollore dichiara i comandi che l'host può richiamare insieme ai messaggi di risposta che può generare. L'host utilizza tali informazioni per comandare al microcontrollore di eseguire azioni e interpretare i risultati.

### Dichiarazione dei comandi

Il software del microcontrollore dichiara un "comando" utilizzando la macro DECL_COMMAND() nel codice C. Per esempio:

```
DECL_COMMAND(command_update_digital_out, "update_digital_out oid=%c value=%c");
```

Quanto sopra dichiara un comando denominato "update_digital_out". Ciò consente all'host di "richiamare" questo comando che causerebbe l'esecuzione della funzione C command_update_digital_out() nel microcontrollore. Quanto sopra indica anche che il comando accetta due parametri interi. Quando viene eseguito il codice C command_update_digital_out(), verrà passata una matrice contenente questi due numeri interi: il primo corrispondente all'"oid" e il secondo corrispondente al "valore".

In generale, i parametri sono descritti con la sintassi di stile printf() (ad esempio, "%u"). La formattazione corrisponde direttamente alla visualizzazione leggibile dei comandi (ad es. "update_digital_out oid=7 value=1"). Nell'esempio precedente, "value=" è un nome di parametro e "%c" indica che il parametro è un numero intero. Internamente, il nome del parametro viene utilizzato solo come documentazione. In questo esempio, "%c" viene utilizzato anche come documentazione per indicare che l'intero previsto ha una dimensione di 1 byte (la dimensione intera dichiarata non influisce sull'analisi o sulla codifica).

La build del microcontrollore raccoglierà tutti i comandi dichiarati con DECL_COMMAND(), ne determinerà i parametri e farà in modo che siano richiamabili.

### Declaring responses

Per inviare informazioni dal microcontrollore all'host viene generata una "risposta". Questi sono sia dichiarati che trasmessi usando la macro C sendf(). Per esempio:

```
sendf("status clock=%u status=%c", sched_read_time(), sched_is_shutdown());
```

Quanto sopra trasmette un messaggio di risposta di "stato" che contiene due parametri interi ("clock" e "status"). La build del microcontrollore trova automaticamente tutte le chiamate sendf() e genera codificatori per esse. Il primo parametro della funzione sendf() descrive la risposta ed è nello stesso formato delle dichiarazioni di comando.

L'host può organizzare la registrazione di una funzione di richiamata per ogni risposta. Quindi, in effetti, i comandi consentono all'host di invocare le funzioni C nel microcontrollore e le risposte consentono al software del microcontrollore di richiamare il codice nell'host.

La macro sendf() deve essere invocata solo da gestori di comandi o attività e non deve essere invocata da interrupt o timer. Il codice non ha bisogno di emettere un sendf() in risposta a un comando ricevuto, non è limitato nel numero di volte in cui sendf() può essere invocato e può invocare sendf() in qualsiasi momento da un task handler.

#### Risposte in output

Per semplificare il debug, esiste anche una funzione C output(). Per esempio:

```
output("Il valore di%u è %s con dimensione %u.", x, buf, buf_len);
```

La funzione output() è simile nell'uso a printf() - è intesa per generare e formattare messaggi arbitrari per il 'consumo umano'.

### Dichiarazione di enumerazioni

Le enumerazioni consentono al codice host di utilizzare identificatori di stringa per i parametri che il microcontrollore gestisce come numeri interi. Sono dichiarati nel codice del microcontrollore, ad esempio:

```
DECL_ENUMERATION("spi_bus", "spi", 0);

DECL_ENUMERATION_RANGE("pin", "PC0", 16, 8);
```

Se il primo esempio, la macro DECL_ENUMERATION() definisce un'enumerazione per qualsiasi messaggio di comando/risposta con nome parametro "spi_bus" o nome parametro con suffisso "_spi_bus". Per quei parametri la stringa "spi" è un valore valido e verrà trasmessa con un valore intero pari a zero.

È anche possibile dichiarare un intervallo di enumerazione. Nel secondo esempio, un parametro "pin" (o qualsiasi parametro con suffisso "_pin") accetterebbe PC0, PC1, PC2, ..., PC7 come valori validi. Le stringhe verranno trasmesse con numeri interi 16, 17, 18, ..., 23.

### Dichiarazione di costanti

Le costanti possono anche essere esportate. Ad esempio, quanto segue:

```
DECL_CONSTANT("SERIAL_BAUD", 250000);
```

esporterebbe una costante denominata "SERIAL_BAUD" con un valore di 250000 dal microcontrollore all'host. È anche possibile dichiarare una costante che è una stringa, ad esempio:

```
DECL_CONSTANT_STR("MCU", "pru");
```

## Codifica dei messaggi di basso livello

Per realizzare il meccanismo RPC di cui sopra, ogni comando e risposta viene codificato in un formato binario per la trasmissione. Questa sezione descrive il sistema di trasmissione.

### Blocchi di messaggi

Tutti i dati inviati dall'host al microcontrollore e viceversa sono contenuti in "blocchi di messaggi". Un blocco di messaggi ha un'intestazione di due byte e un trailer di tre byte. Il formato di un blocco di messaggi è:

```
<1 byte lunghezza><1 byte sequenza><n-byte contenuto><2 byte crc><1 byte sync>
```

Il byte di lunghezza contiene il numero di byte nel blocco di messaggi inclusi i byte di intestazione e trailer (quindi la lunghezza minima del messaggio è 5 byte). La lunghezza massima del blocco di messaggi è attualmente di 64 byte. Il byte di sequenza contiene un numero di sequenza di 4 bit nei bit di ordine inferiore e i bit di ordine superiore contengono sempre 0x10 (i bit di ordine superiore sono riservati per un uso futuro). I byte di contenuto contengono dati arbitrari e il relativo formato è descritto nella sezione seguente. I byte crc contengono un CCITT [CRC](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) a 16 bit del blocco di messaggi inclusi i byte di intestazione ma esclusi i byte di trailer. Il byte di sincronizzazione è 0x7e.

Il formato del blocco di messaggi si ispira ai telegrammi [HDLC](https://en.wikipedia.org/wiki/High-Level_Data_Link_Control). Come in HDLC, il blocco di messaggi può contenere facoltativamente un carattere di sincronizzazione aggiuntivo all'inizio del blocco. A differenza di HDLC, un carattere di sincronizzazione non è esclusivo del framing e può essere presente nel contenuto del blocco di messaggi.

### Contenuto del blocco messaggi

Ogni blocco di messaggi inviato dall'host al microcontrollore contiene una serie di zero o più comandi di messaggi. Ogni comando inizia con un [Quantità a lunghezza variabile](#quantità-a-lunghezza-variabile) (VLQ) command-id seguito da zero o più parametri VLQ per il comando dato.

Ad esempio, i seguenti quattro comandi possono essere inseriti in un unico blocco di messaggi:

```
update_digital_out oid=6 value=1
update_digital_out oid=5 value=0
get_config
get_clock
```

e codificato nei seguenti otto interi VLQ:

```
<id_update_digital_out><6><1><id_update_digital_out><5><0><id_get_config><id_get_clock>
```

Per codificare e analizzare il contenuto del messaggio, sia l'host che il microcontrollore devono concordare gli ID comando e il numero di parametri di ciascun comando. Quindi, nell'esempio sopra, sia l'host che il microcontrollore saprebbero che "id_update_digital_out" è sempre seguito da due parametri e "id_get_config" e "id_get_clock" hanno zero parametri. L'host e il microcontrollore condividono un "dizionario dei dati" che mappa le descrizioni dei comandi (ad esempio, "update_digital_out oid=%c value=%c") ai loro ID di comando interi. Durante l'elaborazione dei dati, il parser saprà di aspettarsi un numero specifico di parametri codificati VLQ a seguito di un determinato ID comando.

Il contenuto del messaggio per i blocchi inviati dal microcontrollore all'host segue lo stesso formato. Gli identificatori in questi messaggi sono "ID di risposta", ma servono allo stesso scopo e seguono le stesse regole di codifica. In pratica, i blocchi di messaggi inviati dal microcontrollore all'host non contengono mai più di una risposta nel contenuto del blocco di messaggi.

#### Quantità di lunghezza variabile

Consulta l'[articolo di Wikipedia](https://en.wikipedia.org/wiki/Variable-length_quantity) per ulteriori informazioni sul formato generale degli interi codificati VLQ. Klipper utilizza uno schema di codifica che supporta numeri interi positivi e negativi. Gli interi prossimi allo zero utilizzano meno byte per codificare e gli interi positivi in genere codificano utilizzando meno byte degli interi negativi. La tabella seguente mostra il numero di byte che ogni intero impiega per codificare:

| Intero | Dimensione codificata |
| --- | --- |
| -32 .. 95 | 1 |
| -4096 .. 12287 | 2 |
| -524288 .. 1572863 | 3 |
| -67108864 .. 201326591 | 4 |
| -2147483648 .. 4294967295 | 5 |

#### Stringhe di lunghezza variabile

Come eccezione alle regole di codifica precedenti, se un parametro di un comando o di una risposta è una stringa dinamica, il parametro non viene codificato come un semplice intero VLQ. Invece viene codificato trasmettendo la lunghezza come intero codificato VLQ seguito dal contenuto stesso:

```
<VLQ encoded length><n-byte contents>
```

Le descrizioni dei comandi che si trovano nel dizionario dei dati consentono sia all'host che al microcontrollore di sapere quali parametri del comando utilizzano la semplice codifica VLQ e quali parametri utilizzano la codifica delle stringhe.

## Dizionario dati

Affinché vengano stabilite comunicazioni significative tra microcontrollore e host, entrambe le parti devono concordare un "dizionario dei dati". Questo dizionario di dati contiene gli identificatori interi per comandi e risposte insieme alle relative descrizioni.

La build del microcontrollore utilizza il contenuto delle macro DECL_COMMAND() e sendf() per generare il dizionario dei dati. La build assegna automaticamente identificatori univoci a ciascun comando e risposta. Questo sistema consente sia all'host che al codice del microcontrollore di utilizzare senza problemi nomi descrittivi leggibili dall'uomo pur utilizzando una larghezza di banda minima.

L'host interroga il dizionario dei dati quando si connette per la prima volta al microcontrollore. Una volta che l'host ha scaricato il dizionario dei dati dal microcontrollore, utilizza quel dizionario dei dati per codificare tutti i comandi e per analizzare tutte le risposte dal microcontrollore. L'host deve quindi gestire un dizionario di dati dinamico. Tuttavia, per mantenere semplice il software del microcontrollore, il microcontrollore utilizza sempre il suo dizionario dati statico (compilato).

Il dizionario dei dati viene interrogato inviando i comandi "identify" al microcontrollore. Il microcontrollore risponderà a ogni comando di identificazione con un messaggio "identify_response". Poiché questi due comandi sono necessari prima di ottenere il dizionario dei dati, i loro ID interi e tipi di parametri sono codificati sia nel microcontrollore che nell'host. L'ID della risposta "identify_response" è 0, l'ID del comando "identify" è 1. Oltre ad avere ID hardcoded, il comando di identificazione e la relativa risposta vengono dichiarati e trasmessi allo stesso modo degli altri comandi e risposte. Nessun altro comando o risposta è hardcoded.

Il formato del dizionario dei dati trasmessi stesso è una stringa JSON compressa zlib. Il processo di compilazione del microcontrollore genera la stringa, la comprime e la memorizza nella sezione di testo del flash del microcontrollore. Il dizionario dei dati può essere molto più grande della dimensione massima del blocco del messaggio: l'host lo scarica inviando più comandi di identificazione che richiedono blocchi progressivi del dizionario dei dati. Una volta ottenuti tutti i blocchi, l'host assemblerà i blocchi, decomprimerà i dati e analizzerà il contenuto.

Oltre alle informazioni sul protocollo di comunicazione, il dizionario dei dati contiene anche la versione del software, le enumerazioni (come definite da DECL_ENUMERATION) e le costanti (come definite da DECL_CONSTANT).

## Flusso di messaggi

I comandi dei messaggi inviati dall'host al microcontrollore sono concepiti per essere privi di errori. Il microcontrollore controllerà il CRC e i numeri di sequenza in ciascun blocco di messaggi per garantire che i comandi siano accurati e in ordine. Il microcontrollore elabora sempre i blocchi di messaggi in ordine - se riceve un blocco fuori ordine, lo scarterà e tutti gli altri blocchi fuori ordine fino a quando non riceve blocchi con la sequenza corretta.

Il codice host di basso livello implementa un sistema di ritrasmissione automatica per i blocchi di messaggi persi e corrotti inviati al microcontrollore. Per facilitare ciò, il microcontrollore trasmette un "ack message block" dopo ogni blocco di messaggio ricevuto con successo. L'host pianifica un timeout dopo l'invio di ogni blocco e lo ritrasmetterà se il timeout scade senza ricevere un corrispondente "ack". Inoltre, se il microcontrollore rileva un blocco corrotto o fuori servizio, può trasmettere un "nak message block" per facilitare una rapida ritrasmissione.

Un "ack" è un blocco di messaggi con contenuto vuoto (cioè un blocco di messaggi di 5 byte) e un numero di sequenza maggiore dell'ultimo numero di sequenza dell'host ricevuto. Un "nak" è un blocco di messaggi con contenuto vuoto e un numero di sequenza inferiore all'ultimo numero di sequenza host ricevuto.

Il protocollo facilita un sistema di trasmissione "finestra" in modo che l'host possa avere molti blocchi di messaggi in sospeso in viaggio alla volta. (Questo è in aggiunta ai molti comandi che possono essere presenti in un determinato blocco di messaggi.) Ciò consente il massimo utilizzo della larghezza di banda anche in caso di latenza di trasmissione. Il meccanismo di timeout, ritrasmissione, windowing e ack si ispira a meccanismi simili in [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol).

Nell'altra direzione, i blocchi di messaggi inviati dal microcontrollore all'host sono progettati per essere privi di errori, ma non hanno una trasmissione sicura. (Le risposte non dovrebbero essere danneggiate, ma potrebbero scomparire.) Questo viene fatto per mantenere semplice l'implementazione nel microcontrollore. Non esiste un sistema di ritrasmissione automatica delle risposte: ci si aspetta che il codice di alto livello sia in grado di gestire una risposta mancante occasionale (di solito richiedendo nuovamente il contenuto o impostando un programma ricorrente di trasmissione della risposta). Il campo del numero di sequenza nei blocchi di messaggi inviati all'host è sempre uno maggiore dell'ultimo numero di sequenza di blocchi di messaggi ricevuti dall'host. Non viene utilizzato per tenere traccia di sequenze di blocchi di messaggi di risposta.
