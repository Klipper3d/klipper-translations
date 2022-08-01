# Beaglebone

Questo documento descrive il processo di esecuzione di Klipper su una PRU Beaglebone.

## Creazione di un'immagine del sistema operativo

Inizia installando l'immagine [Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images). È possibile eseguire l'immagine da una scheda micro-SD o dall'eMMC integrato. Se si utilizza l'eMMC, installarlo ora nell'eMMC seguendo le istruzioni dal collegamento sopra.

Quindi loggati ssh nella macchina Beaglebone (`ssh debian@beaglebone` -- la password è `temppwd`) e installa Klipper eseguendo i seguenti comandi:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-beaglebone.sh
```

## Installare Octoprint

Si può quindi installare Octoprint:

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

E configura OctoPrint per l'avvio all'avvio:

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

È necessario modificare il file di configurazione **/etc/default/octoprint** di OctoPrint. Si deve cambiare l'utente `OCTOPRINT_USER` in `debian`, cambiare `NICELEVEL` in `0`, togliere il commento alle impostazioni di `BASEDIR`, `CONFIGFILE` e `DAEMON` e cambiare i riferimenti della home da `/home/pi/` a `/home/debian/`:

```
sudo nano /etc/default/octoprint
```

Quindi avvia il servizio Octoprint:

```
sudo systemctl start octoprint
```

Assicurati che il server web OctoPrint sia accessibile - dovrebbe trovarsi su: <http://beaglebone:5000/>

## Creazione del codice del microcontrollore

Per compilare il codice del microcontrollore Klipper, inizia configurandolo per il "Beaglebone PRU":

```
cd ~/klipper/
make menuconfig
```

Per compilare e installare il nuovo codice del microcontrollore, eseguire:

```
sudo service klipper stop
make flash
sudo service klipper start
```

È inoltre necessario compilare e installare il codice del microcontrollore per un processo host Linux. Configuralo per un "processo Linux":

```
make menuconfig
```

Quindi installa anche questo codice del microcontrollore:

```
sudo service klipper stop
make flash
sudo service klipper start
```

## Configurazione rimanente

Completare l'installazione configurando Klipper e Octoprint seguendo le istruzioni nel documento principale [Installation](Installation.md#configuring-klipper).

## Stampa sul Beaglebone

Sfortunatamente, il processore Beaglebone a volte può avere difficoltà a far funzionare bene OctoPrint. È noto che i blocchi di stampa si verificano su stampe complesse (la stampante potrebbe muoversi più velocemente di quanto OctoPrint possa inviare comandi di movimento). In questo caso, considera l'utilizzo della funzione "virtual_sdcard" (consulta [Config Reference](Config_Reference.md#virtual_sdcard) per i dettagli) per stampare direttamente da Klipper.
