# CANBUS

Questo documento descrive il supporto del CAN bus di Klipper.

## Hardware del dispositivo

Klipper attualmente supporta CAN sui chip stm32 e rp2040. Inoltre, il chip del microcontrollore deve trovarsi su una scheda dotata di un ricetrasmettitore CAN.

Per compilare per CAN, eseguire `make menuconfig` e selezionare "CAN bus" come interfaccia di comunicazione. Infine, compila il codice del microcontrollore e flashalo sulla scheda di destinazione.

## Hardware Host

Per utilizzare un bus CAN, è necessario disporre di un adattatore sul host. Attualmente ci sono due opzioni comuni:

1. Usa un [Waveshare Raspberry Pi CAN](https://www.waveshare.com/rs485-can-hat.htm) o uno dei suoi tanti cloni.
1. Utilizzare un adattatore CAN USB (ad esempio <https://hacker-gadgets.com/product/cantact-usb-can-adapter/>). Sono disponibili molti adattatori diversi da USB a CAN: quando ne scegli uno, ti consigliamo di verificare che possa eseguire il [candlelight firmware](https://github.com/candle-usb/candleLight_fw). (Sfortunatamente, abbiamo riscontrato che alcuni adattatori USB eseguono firmware difettoso e sono bloccati, quindi verifica prima dell'acquisto.)

È inoltre necessario configurare il sistema operativo host per utilizzare l'adattatore. Questo viene in genere fatto creando un nuovo file chiamato `/etc/network/interfaces.d/can0` con il seguente contenuto:

```
auto can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```

Nota che il "Raspberry Pi CAN hat" richiede anche [modifiche a config.txt](https://www.waveshare.com/wiki/RS485_CAN_HAT).

## Resistori di terminazione

Un bus CAN dovrebbe avere due resistori da 120 ohm tra i cavi CANH e CANL. Idealmente, un resistore situato a ciascuna estremità del bus.

Si noti che alcuni dispositivi hanno un resistore integrato da 120 ohm (ad esempio, il "Waveshare Raspberry Pi CAN" ha un resistore saldato che non può essere rimosso facilmente). Alcuni dispositivi non includono affatto un resistore. Altri dispositivi hanno un meccanismo per selezionare il resistore (in genere collegando un "ponticello jumper"). Assicurati di controllare gli schemi di tutti i dispositivi sul bus CAN per verificare che ci siano due e solo due resistori da 120 Ohm sul bus.

Per verificare che i resistori siano corretti, è possibile rimuovere l'alimentazione alla stampante e utilizzare un multimetro per controllare la resistenza tra i cavi CNH e CANL: dovrebbe riportare ~60 ohm su un bus CAN cablato correttamente.

## Trovare canbus_uuid per nuovi microcontrollori

A ogni microcontrollore sul bus CAN viene assegnato un ID univoco basato sull'identificatore del chip di fabbrica codificato in ciascun microcontrollore. Per trovare l'ID di ciascun dispositivo del microcontrollore, assicurati che l'hardware sia alimentato e cablato correttamente, quindi esegui:

```
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

Se vengono rilevati dispositivi CAN non inizializzati, il comando precedente riporterà righe come le seguenti:

```
Found canbus_uuid=11aa22bb33cc, Application: Klipper
```

Ogni dispositivo avrà un identificatore univoco. Nell'esempio sopra, `11aa22bb33cc` è il "canbus_uuid" del microcontrollore.

Nota che lo strumento `canbus_query.py` riporterà solo i dispositivi non inizializzati - se Klipper (o uno strumento simile) configura il dispositivo, non apparirà più nell'elenco.

## Configurare Klipper

Aggiorna Klipper [configurazione mcu](Config_Reference.md#mcu) per utilizzare il bus CAN per comunicare con il dispositivo, ad esempio:

```
[mcu my_can_mcu]
canbus_uuid: 11aa22bb33cc
```

## Modalità bridge da USB a CAN bus

Alcuni microcontrollori supportano la selezione della modalità "USB to CAN bus bridge" durante "make menuconfig". Questa modalità può consentire di utilizzare un microcontrollore sia come "adattatore bus da USB a CAN" che come nodo Klipper.

Quando Klipper utilizza questa modalità, il microcontrollore appare come un "adattatore bus CAN USB" sotto Linux. Lo stesso "Klipper bridge mcu" apparirà come se fosse su questo bus CAN - può essere identificato tramite `canbus_query.py` e configurato come altri nodi Klipper del bus CAN. Apparirà insieme ad altri dispositivi che sono effettivamente sul bus CAN.

Alcune note importanti quando si utilizza questa modalità:

* Il "bridge mcu" non è effettivamente sul bus CAN. I messaggi in entrata e in uscita non consumano larghezza di banda sul bus CAN. L'mcu non può essere visto da altri adattatori che potrebbero essere sul bus CAN.
* È necessario configurare l'interfaccia `can0` (o simile) in Linux per comunicare con il bus. Tuttavia, Klipper ignora la velocità del bus CAN di Linux e le opzioni di temporizzazione del bus CAN. Attualmente, la frequenza del bus CAN viene specificata durante "make menuconfig" e la velocità del bus specificata in Linux viene ignorata.
* Ogni volta che il "bridge mcu" viene ripristinato, Linux disabiliterà l'interfaccia `can0` corrispondente. Per garantire una corretta gestione dei comandi FIRMWARE_RESTART e RESTART, si consiglia di sostituire `auto` con `allow-hotplug` nel file `/etc/network/interfaces.d/can0`. Per esempio:

```
allow-hotplug can0
iface can0 can static
    bitrate 500000
    up ifconfig $IFACE txqueuelen 128
```
