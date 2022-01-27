# Installazione

Queste istruzioni partono dal presupposto che Klipper girerà su un Raspberry Pi con OctoPrint. È consigliato l'utilizzo di un Raspberry Pi 2, 3 o 4 (vedi la [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) per utilizzare un hardware diverso).

Klipper attualmente supporta un certo numero di microcontrollori basati su Atmel ATmega, [ARM based micro-controllers](Features.md#step-benchmarks), e stampanti basate su [Beaglebone PRU](Beaglebone.md).

## Preparazione dell'immagine del sistema operativo

Iniziate installando [OctoPi](https://github.com/guysoft/OctoPi) sul computer Raspberry Pi. Usa OctoPi v0.17.0 o successivo - vedi [OctoPi releases](https://github.com/guysoft/OctoPi/releases) per informazioni sulla versione. Si dovrebbe verificare che OctoPi si avvii e che il server web OctoPrint funzioni. Dopo essersi collegati alla pagina web OctoPrint, segui la richiesta di aggiornare OctoPrint alla v1.4.2 o successiva.

Dopo aver installato OctoPi ed aver aggiornato OctoPrint all'ultima versione sarà necessario loggarsi via ssh sul Raspberry (o altra macchina scelta per far girare klipper) per eseguire una manciata di comandi. Se stai utilizzando un sistema Linux o MacOS desktop, il programma "ssh" potrebbe già essere installato sul tuo sistema. Esistono vari client ssh disponibili (ad esempio [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Usa il programma ssh per connetterti al Raspberry Pi (ssh pi@octopi -- la password è "raspberry") ed esegui questi comandi:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

Questo scaricherà Klipper, installerà alcune dipendenze, imposterà Klipper per essere eseguito all'avvio del sistema e avvierò il programma host Klipper. Sarà necessario che il Raspberry abbia accesso ad internet e richederà alcuni minuti.

## Compilare il firmware e flashare il microcontrollore

Per compilare il firmware per il microcontrollore, iniziamo lanciando questi comandi sul Raspberry:

```
cd ~/klipper/
make menuconfig
```

Seleziona il microcontrollore dalla lista e verifica le opzioni possibili. Una volta impostato tutto, esegui:

```
make
```

Ora bisogna capire quale è la porta seriale collegata al microcontrollore. Se la tua scheda è connessa via USB, esegui questo comando:

```
ls /dev/serial/by-id/*
```

Dovrebbe venire riportato qualcosa di simile a questo:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

È abbastanza comune che ogni stampante 3D abbia il suo nome univoco elencato come porta seriale. Questo nome sarà utilizzato quando flasheremo il microcontrollore. È possibile che ci possano essere più righe nell'elenco sopraccitato, se è così seleziona la riga cosrrispondente al microcontrollore (vedi le [FAQ](FAQ.md#wheres-my-serial-port) per maggiori informazioni).

Per i microcontrollori più comuni, il firmware può essere flashato con comandi tipo:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Assicurati di mettere al posto di FLASH_DEVICE il nome della porta seriale associato alla stampante.

Quando flashi il firmware per la prima volta verifica che OctoPrint non sia connesso alla stampante (dall'interfaccia di OctoPrint, nella sezione "Connection", clicca "Disconnect").

## Configurare OctoPrint per usare Klipper

Il sistema OctoPrint deve essere configurato per comunicare con il sistema Klipper. Loggati su OctoPrint e confogura queste parti:

Naviga nella scheda Impostazioni (la chiave inglese in cima alla pagina). Dentro "Serial Connection", "Additional serial ports" aggiungi "/tmp/printer". Poi fai "Save".

Vai nella scheda Impostazioni e sotto "Serial Connection" cambia la "Serial Port" in "/tmp/printer".

Nella scheda Impostazioni, vai in "Behavior" e seleziona l'opzione "Cancel any ongoing prints but stay connected to the printer", poi "Save".

Dalla pagina principale, nella sezione "Connection" in alto a sinistra, verifica che il campo "Serial Port" sia "/tmp/printer" e clicca "Connect". Se l'opzione /tmp/printer non è visualizzata prova a ricaricare la pagina.

Una volta connesso, vai nella scheda "Terminal" e scrivi il comando "status" (senza virgolette) nella casella per i comandi e clicca "Send". La finestra del terminare probabilmente mostrerà un messaggio di errore sull'apertura del file config, questo significa che OctoPrint sta comunicando correttamente con Klipper. Possiamo proseguire.

## Configurare Klipper

La configurazione di Klipper è memorizzata in un file di testo su Raspberry Pi. Dai un'occhiata ai file di configurazione di esempio nella [directory config](../config/). Il [Config Reference](Config_Reference.md) contiene la documentazione sui parametri di configurazione.

Probabilmente il modo più semplice per modificare il file di configurazione di Klipper è usare un editor di testo che supportti l'apertura di file su protocollo "SCP" e/o "SFTP". Esistono molti tool gratuiti che hanno questa caratteristica (es. Notepad++, WinSCP, Cyberduck). Usa i file config di esempio come punto di partenza e salva il file con il nome "printer.cfg" nella cartella home dell'utente pi (solitamente /home/pi/printer.cfg).

In alternativa puoi copiare e modificare il file direttamente sul Raspberry Pi via SSH - per esempio:

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Controlla bene e modifica ogni settaggio appropriato per il tuo hardware.

È abbastanza comune che ogni stampante 3D abbia il suo nome univoco elencato come porta seriale, tale nome potrebbe cambiare dopo aver flashato Klipper quindi riesegui il comando `ls /dev/serial/by-id/*` e modifica il file config con il nome univoco. Ad esempio aggiorna la sezione `[mcu]` in modo che assomigli a:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Dopo aver creato e personalizzato il file config è necessario mandare il comando "restart" attraverso il terminale di OctoPrint per rendere effettiva la confogurazione. Il comando "status" mosterà che la stampante è pronta se il file config è stato letto correttamente, il mictrocontrollore è stato rilevato e configurato. Non è raro di ritrovarsi con errori di configurazione durante il setup iniziale, nel caso aggiorna il file config e invia il comando restart finché lo status non diventa ready.

Klipper riferisce i messaggi di errore tramite il terminale di OctoPrint. Il comando "status" può essere usato per visualizzare nuovamente eventuali messaggi di errore. Lo script di startup di default di Klipper genererà un log sotto **/tmp/klippy.log**, questo fornirà informazioni più dettagliate.

Oltre i comandi in stile g-code, Klipper supporta alcuni comandi aggiuntivi ("status" e "restart" sono alcuni esempi). Usa il comando "help" per avere una lista di altri comandi aggiuntivi.

Dopo che Klipper riporta che la stampante è pronta, vai al [config check document] (Config_checks.md) per eseguire alcuni controlli di base sulle definizioni dei pin nel file di configurazione.dei pin nel file di configurazione.

## Contattare gli svilluppatori

Assicurati di vedere le [FAQ](FAQ.md) per le risposte ad alcune domande comuni. Vedi la [contact page](Contact.md) per segnalare un bug o per contattare gli sviluppatori.
