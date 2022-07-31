# Installazione

Queste istruzioni partono dal presupposto che Klipper girerà su un Raspberry Pi con OctoPrint. È consigliato l'utilizzo di un Raspberry Pi 2, 3 o 4 (vedi la [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) per utilizzare un hardware diverso).

## Ottenere un file di configurazione di Klipper

La maggior parte delle impostazioni di Klipper sono determinate da un "file di configurazione della stampante" che verrà archiviato sul Raspberry Pi. Un file di configurazione appropriato può spesso essere trovato cercando in Klipper [directory config](../config/) un file che inizia con un prefisso "printer-" che corrisponde alla stampante di destinazione. Il file di configurazione di Klipper contiene informazioni tecniche sulla stampante che saranno necessarie durante l'installazione.

Se non c'è un file di configurazione della stampante appropriato nella directory di configurazione di Klipper, prova a cercare nel sito web del produttore della stampante per vedere se hanno un file di configurazione di Klipper appropriato.

Se non è possibile trovare alcun file di configurazione per la stampante, ma si conosce il tipo di scheda di controllo della stampante, cercare un [file di configurazione](../config/) appropriato che inizi con un prefisso "generico-". Questi file di esempio della scheda della stampante dovrebbero consentire di completare correttamente l'installazione iniziale, ma richiederanno alcune personalizzazioni per ottenere la funzionalità completa della stampante.

È anche possibile definire da zero una nuova configurazione della stampante. Tuttavia, ciò richiede una conoscenza tecnica significativa sulla stampante e la sua elettronica. Si consiglia alla maggior parte degli utenti di iniziare con un file di configurazione appropriato. Se si crea un nuovo file di configurazione della stampante personalizzato, iniziare con l'esempio più vicino [file di configurazione](../config/) e utilizzare Klipper [riferimento alla configurazione](Config_Reference.md) per ulteriori informazioni.

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

I commenti nella parte superiore del [file di configurazione della stampante](#obtain-a-klipper-configuration-file) dovrebbero descrivere le impostazioni che devono essere impostate durante "make menuconfig". Apri il file in un browser web o in un editor di testo e cerca queste istruzioni nella parte superiore del file. Una volta configurate le impostazioni "menuconfig" appropriate, premere "Q" per uscire, quindi "Y" per salvare. Quindi esegui:

```
make
```

Se i commenti nella parte superiore del [file di configurazione della stampante](#obtain-a-klipper-configuration-file) descrivono i passaggi personalizzati per il "flash" dell'immagine finale sulla scheda di controllo della stampante, segui questi passaggi e poi procedi con [configurazione OctoPrint](#configuring-octoprint-to-use-klipper).

In caso contrario, i seguenti passaggi vengono spesso utilizzati per eseguire il "flash" della scheda di controllo della stampante. Innanzitutto è necessario determinare la porta seriale collegata al microcontrollore. Esegui quanto segue:

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

Il passaggio successivo consiste nel copiare il [file di configurazione della stampante](#obtain-a-klipper-configuration-file) sul Raspberry Pi.

Probabilmente il modo più semplice per impostare il file di configurazione di Klipper è utilizzare un editor desktop che supporti la modifica dei file sui protocolli "scp" e/o "sftp". Ci sono strumenti disponibili gratuitamente che supportano questo (ad esempio, Notepad++, WinSCP e Cyberduck). Caricare il file di configurazione della stampante nell'editor e quindi salvarlo come file denominato "printer.cfg" nella directory home dell'utente pi (ad esempio, /home/pi/printer.cfg).

In alternativa, si può anche copiare e modificare il file direttamente sul Raspberry Pi tramite ssh. Potrebbe essere simile al seguente (assicurati di aggiornare il comando per utilizzare il nome file di configurazione della stampante appropriato):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

È comune che ogni stampante abbia il proprio nome univoco per il microcontrollore. Il nome potrebbe cambiare dopo aver eseguito il flashing di Klipper, quindi ripeti questi passaggi anche se erano già stati eseguiti durante il flashing. Eseguire:

```
ls /dev/serial/by-id/*
```

Dovrebbe venire riportato qualcosa di simile a questo:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Quindi aggiorna il file di configurazione con il nome univoco. Ad esempio, aggiorna la sezione `[mcu]` in modo che assomigli a qualcosa di simile a:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Dopo aver creato e modificato il file sarà necessario emettere un comando di "restart" nel terminale web di OctoPrint per caricare il file config. Un comando "status" segnalerà che la stampante è pronta se il file di configurazione di Klipper viene letto correttamente e il microcontrollore è stato trovato e configurato correttamente.

Quando si personalizza il file di configurazione della stampante, non è raro che Klipper segnali un errore di configurazione. Se si verifica un errore, apportare le correzioni necessarie al file di configurazione della stampante ed eseguire il "restart" finché "status" non segnala che la stampante è pronta.

Klipper riferisce i messaggi di errore tramite il terminale di OctoPrint. Il comando "status" può essere usato per visualizzare nuovamente eventuali messaggi di errore. Lo script di startup di default di Klipper genererà un log sotto **/tmp/klippy.log**, questo fornirà informazioni più dettagliate.

Dopo che Klipper ha segnalato che la stampante è pronta, vai al [config check document](Config_checks.md) per eseguire alcuni controlli di base sulle definizioni nel file di configurazione. Vedere i[documentation reference](Overview.md) per altre informazioni.
