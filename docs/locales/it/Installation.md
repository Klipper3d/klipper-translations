# Installazione

Queste istruzioni partono dal presupposto che Klipper girerà su un Raspberry Pi con OctoPrint. È consigliato l'utilizzo di un Raspberry Pi 2, 3 o 4 (vedi la [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) per utilizzare un hardware diverso).

## Obtain a Klipper Configuration File

Most Klipper settings are determined by a "printer configuration file" that will be stored on the Raspberry Pi. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

If there isn't an appropriate printer configuration file in the Klipper config directory then try searching the printer manufacturer's website to see if they have an appropriate Klipper configuration file.

If no configuration file for the printer can be found, but the type of printer control board is known, then look for an appropriate [config file](../config/) starting with a "generic-" prefix. These example printer board files should allow one to successfully complete the initial installation, but will require some customization to obtain full printer functionality.

It is also possible to define a new printer configuration from scratch. However, this requires significant technical knowledge about the printer and its electronics. It is recommended that most users start with an appropriate configuration file. If creating a new custom printer configuration file, then start with the closest example [config file](../config/) and use the Klipper [config reference](Config_Reference.md) for further information.

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

The comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) should describe the settings that need to be set during "make menuconfig". Open the file in a web browser or text editor and look for these instructions near the top of the file. Once the appropriate "menuconfig" settings have been configured, press "Q" to exit, and then "Y" to save. Then run:

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Otherwise, the following steps are often used to "flash" the printer control board. First, it is necessary to determine the serial port connected to the micro-controller. Run the following:

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

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the Raspberry Pi.

Arguably the easiest way to set the Klipper configuration file is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the Raspberry Pi via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

It's common for each printer to have its own unique name for the micro-controller. The name may change after flashing Klipper, so rerun these steps again even if they were already done when flashing. Run:

```
ls /dev/serial/by-id/*
```

Dovrebbe venire riportato qualcosa di simile a questo:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Then update the config file with the unique name. For example, update the `[mcu]` section to look something similar to:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the OctoPrint web terminal to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

When customizing the printer config file, it is not uncommon for Klipper to report a configuration error. If an error occurs, make any necessary corrections to the printer config file and issue "restart" until "status" reports the printer is ready.

Klipper riferisce i messaggi di errore tramite il terminale di OctoPrint. Il comando "status" può essere usato per visualizzare nuovamente eventuali messaggi di errore. Lo script di startup di default di Klipper genererà un log sotto **/tmp/klippy.log**, questo fornirà informazioni più dettagliate.

After Klipper reports that the printer is ready, proceed to the [config check document](Config_checks.md) to perform some basic checks on the definitions in the config file. See the main [documentation reference](Overview.md) for other information.
