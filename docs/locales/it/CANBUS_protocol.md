# Protocollo CANBUS

Questo documento descrive il protocollo utilizzato da Klipper per comunicare su [CAN bus](https://en.wikipedia.org/wiki/CAN_bus). Vedere <CANBUS.md> per informazioni sulla configurazione di Klipper con CANBUS.

## Assegnazione dell'id del microcontrollore

Klipper utilizza solo pacchetti CAN bus di dimensioni standard CAN 2.0A, che sono limitati a 8 byte di dati e un identificatore bus CAN a 11 bit. Per supportare una comunicazione efficiente, a ogni microcontrollore viene assegnato in fase di esecuzione un ID nodo bus CAN univoco a 1 byte ("canbus_nodeid") per il traffico generale di comandi e risposte Klipper. I messaggi di comando di Klipper che vanno dall'host al microcontrollore utilizzano l'ID bus CAN di `canbus_nodeid * 2 + 256`, mentre i messaggi di risposta di Klipper dal microcontrollore all'host usano `canbus_nodeid * 2 + 256 + 1`.

Ogni microcontrollore ha un identificatore di chip univoco assegnato in fabbrica che viene utilizzato durante l'assegnazione dell'ID. Questo identificatore può superare la lunghezza di un pacchetto CAN, quindi una funzione hash viene utilizzata per generare un ID univoco a 6 byte (`canbus_uuid`) dall'ID di fabbrica.

## Messaggi dell'amministratore

I messaggi dell'amministratore vengono utilizzati per l'assegnazione dell'ID. I messaggi di amministrazione inviati dall'host al microcontrollore utilizzano l'ID bus CAN "0x3f0" e i messaggi inviati dal microcontrollore all'host utilizzano l'ID bus CAN "0x3f1". Tutti i microcontrollori ascoltano i messaggi sull'id `0x3f0`; quell'ID può essere considerato un "indirizzo di trasmissione".

### messaggio CMD_QUERY_UNASSIGNED

Questo comando interroga tutti i microcontrollori a cui non è stato ancora assegnato un `canbus_nodeid`. I microcontrollori non assegnati risponderanno con un messaggio di risposta RESP_NEED_NODEID.

Il formato del messaggio CMD_QUERY_UNASSIGNED è: `<1 byte message_id = 0x00>`

### CMD_SET_KLIPPER_NODEID messaggio

Questo comando assegna un `canbus_nodeid` al microcontrollore con un dato `canbus_uuid`.

Il formato del messaggio CMD_SET_KLIPPER_NODEID è: `<1-byte message_id = 0x01><6-byte canbus_uuid><1-byte canbus_nodeid>`

### Messaggio RESP_NEED_NODEID

Il formato del messaggio RESP_NEED_NODEID è: `<1-byte message_id = 0x20><6-byte canbus_uuid><1-byte set_klipper_nodeid = 0x01>`

## Pacchetti dati

Un microcontrollore a cui è stato assegnato un nodeid tramite il comando CMD_SET_KLIPPER_NODEID può inviare e ricevere pacchetti di dati.

I dati del pacchetto nei messaggi che utilizzano l'ID bus CAN di ricezione del nodo (`canbus_nodeid * 2 + 256`) vengono semplicemente aggiunti a un buffer e quando viene trovato un [mcu protocol message](Protocol.md) completo, il suo contenuto viene analizzato ed elaborato . I dati vengono trattati come un flusso di byte: non è necessario che l'inizio di un blocco di messaggi Klipper sia allineato con l'inizio di un pacchetto bus CAN.

Allo stesso modo, le risposte ai messaggi del protocollo mcu vengono inviate dal microcontrollore all'host copiando i dati del messaggio in uno o più pacchetti con l'ID del bus CAN di trasmissione del nodo (`canbus_nodeid * 2 + 256 + 1`).
