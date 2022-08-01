# Domande frequenti

## Come posso donare al progetto?

Grazie per il vostro sostegno. Per informazioni, vedere la [Pagina degli sponsor](Sponsor.md).

## Come faccio a calcolare il parametro di configurazione rotation_distance?

Vedere il [rotation distance document](Rotation_Distance.md).

## Dov'è la mia porta seriale?

Il modo generico per trovare una porta seriale USB è eseguire `ls /dev/serial/by-id/*` da un terminale ssh sulla macchina host. Probabilmente produrrà un output simile al seguente:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Il nome trovato nel comando precedente è stabile ed è possibile utilizzarlo nel file di configurazione e durante il flashing del codice del microcontrollore. Ad esempio, un comando flash potrebbe essere simile a:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

e la configurazione aggiornata potrebbe essere simile a:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Assicurati di copiare e incollare il nome dal comando "ls" che hai eseguito sopra poiché il nome sarà diverso per ciascuna stampante.

Se stai usando più microcontrollori e non hanno ID univoci (comune sulle schede con un chip USB CH340), segui invece le indicazioni sopra usando il comando `ls /dev/serial/by-path/*`.

## Quando il microcontrollore si riavvia, il dispositivo cambia in /dev/ttyUSB1

egui le istruzioni nella sezione "[Where's my serial port?](#wheres-my-serial-port)" per evitare che ciò accada.

## Il comando "make flash" non funziona

Il codice tenta di eseguire il flashing del dispositivo utilizzando il metodo più comune per ciascuna piattaforma. Sfortunatamente, c'è molta variabilità nei metodi di flashing, quindi il comando "make flash" potrebbe non funzionare su tutte le schede.

Se si verifica un errore intermittente o si dispone di una configurazione standard, ricontrolla che Klipper non sia in esecuzione durante il flashing (sudo service klipper stop), assicurati che OctoPrint non stia tentando di connettersi direttamente al dispositivo (apri il scheda Connessione nella pagina Web e fare clic su Disconnetti se la porta seriale è impostata sul dispositivo) e assicurarsi che FLASH_DEVICE sia impostato correttamente per la scheda (consultare la [question above](#wheres-my-serial-port).

Tuttavia, se "make flash" non funziona per la tua scheda, dovrai eseguire il flashing manualmente. Verificare se nella [config directory](../config) è presente un file di configurazione con istruzioni specifiche per il flashing del dispositivo. Inoltre, controlla la documentazione del produttore della scheda per vedere se descrive come eseguire il flashing del dispositivo. Infine, potrebbe essere possibile eseguire manualmente il flashing del dispositivo utilizzando strumenti come "avrdude" o "bossac" - vedere il [bootloader document](Bootloaders.md) per ulteriori informazioni.

## Come posso modificare la velocità di trasmissione seriale?

Il baud rate consigliato per Klipper è 250000. Questo baud rate funziona bene su tutte le schede di microcontrollore supportate da Klipper. Se hai trovato una guida online che consiglia una velocità di trasmissione diversa, ignora quella parte della guida e continua con il valore predefinito di 250000.

Se si desidera comunque modificare il baud rate, sarà necessario configurare la nuova velocità nel microcontrollore (durante **make menuconfig**) e il codice aggiornato dovrà essere compilato e flashato sul microcontrollore. Anche il file Klipper printer.cfg dovrà essere aggiornato in modo che corrisponda a tale velocità di trasmissione (consultare il [config reference](Config_Reference.md#mcu) per i dettagli). Per esempio:

```
[mcu]
baud: 250000
```

La velocità di trasmissione mostrata sulla pagina Web di OctoPrint non ha alcun impatto sulla velocità di trasmissione interna del microcontrollore Klipper. Impostare sempre la velocità di trasmissione OctoPrint su 250000 quando si utilizza Klipper.

La velocità in baud del microcontrollore Klipper non è correlata alla velocità in baud del bootloader del microcontrollore. Vedere il [bootloader document](Bootloaders.md) per ulteriori informazioni sui bootloader.

## Posso eseguire Klipper su qualcosa di diverso da un Raspberry Pi 3?

L'hardware consigliato è un Raspberry Pi 2, Raspberry Pi 3 o Raspberry Pi 4.

Klipper funzionerà su un Raspberry Pi 1 e su Raspberry Pi Zero, ma queste schede non hanno una potenza di elaborazione sufficiente per eseguire bene OctoPrint. È normale che si verifichino interruzioni di stampa su queste macchine più lente quando si stampa direttamente da OctoPrint. (La stampante potrebbe muoversi più velocemente di quanto OctoPrint possa inviare comandi di movimento.) Se desideri comunque eseguire su una di queste schede più lente, considera l'utilizzo della funzione "virtual_sdcard" durante la stampa (consulta [config reference](Config_Reference.md#virtual_sdcard) per dettagli).

Per l'esecuzione su Beaglebone, vedere le [Istruzioni di installazione specifiche di Beaglebone](Beaglebone.md).

Klipper è stato eseguito su altre macchine. Il software host Klipper richiede solo Python in esecuzione su un computer Linux (o simile). Tuttavia, se desideri eseguirlo su una macchina diversa, avrai bisogno della conoscenza dell'amministratore Linux per installare i prerequisiti di sistema per quella particolare macchina. Consulta lo script [install-octopi.sh](../scripts/install-octopi.sh) per ulteriori informazioni sui passaggi necessari.

Se stai cercando di eseguire il software host Klipper su un chip di fascia bassa, tieni presente che, come minimo, è necessaria una macchina con hardware a "virgola mobile a doppia precisione".

Se stai cercando di eseguire il software host Klipper su un desktop generico condiviso o una macchina di classe server, tieni presente che Klipper ha alcuni requisiti di scheduling in tempo reale. Se, durante una stampa, il computer host esegue anche un'intensa attività di elaborazione generica (come deframmentazione di un disco rigido, rendering 3D, scambi pesanti e così via), Klipper potrebbe segnalare errori di stampa.

Nota: se non stai utilizzando un'immagine OctoPi, tieni presente che diverse distribuzioni Linux abilitano un pacchetto "ModemManager" (o simile) che può interrompere la comunicazione seriale. (Il che può far sì che Klipper riporti errori apparentemente casuali "Comunicazione persa con MCU".) Se installi Klipper su una di queste distribuzioni potresti dover disabilitare quel pacchetto.

## Posso eseguire più istanze di Klipper sulla stessa macchina host?

È possibile eseguire più istanze del software host Klipper, ma per farlo è necessaria la conoscenza dell'amministratore Linux. Gli script di installazione di Klipper determinano l'esecuzione del seguente comando Unix:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer.cfg -l /tmp/klippy.log
```

È possibile eseguire più istanze del comando precedente purché ogni istanza abbia il proprio file di configurazione della stampante, il proprio file di registro e il proprio pseudo-tty. Per esempio:

```
~/klippy-env/bin/python ~/klipper/klippy/klippy.py ~/printer2.cfg -l /tmp/klippy2.log -I /tmp/printer2
```

Se scegli di farlo, dovrai implementare gli script di avvio, arresto e installazione necessari (se presenti). Lo script [install-octopi.sh](../scripts/install-octopi.sh) e lo script [klipper-start.sh](../scripts/klipper-start.sh) possono essere utili come esempi.

## Devo usare OctoPrint?

Il software Klipper non dipende da OctoPrint. È possibile utilizzare un software alternativo per inviare comandi a Klipper, ma ciò richiede la conoscenza dell'amministratore Linux.

Klipper crea una "porta seriale virtuale" tramite il file "/tmp/printer" ed emula una classica interfaccia seriale per stampante 3D tramite quel file. In generale, un software alternativo può funzionare con Klipper purché possa essere configurato per utilizzare "/tmp/printer" per la porta seriale della stampante.

## Perché non riesco a spostare lo stepper prima di riposizionare la stampante?

Il codice fa questo per ridurre la possibilità di comandare accidentalmente la testa nel piatto o altri limiti. Una volta che la stampante è stata localizzata, il software tenta di verificare che ogni mossa rientri nella posizione_min/max definita nel file di configurazione. Se i motori sono disabilitati (tramite un comando M84 o M18), i motori dovranno essere nuovamente riposizionati prima del movimento.

Se desideri spostare la testina dopo aver annullato una stampa tramite OctoPrint, considera di modificare la sequenza di annullamento di OctoPrint per farlo per te. È configurato in OctoPrint tramite un browser web in: Impostazioni-> Script GCODE | Settings->GCODE Scripts

Se desideri spostare la testina al termine di una stampa, considera di aggiungere il movimento desiderato alla sezione "G-code personalizzato" del tuo slicer.

Se la stampante richiede un movimento aggiuntivo come parte del processo stesso di homing (o fondamentalmente non ha un processo di homing), considera l'utilizzo di una sezione safe_z_home o homing_override nel file di configurazione. Se è necessario spostare uno stepper per scopi diagnostici o di debug, considerare l'aggiunta di una sezione force_move al file di configurazione. Vedere [config reference](Config_Reference.md#customized_homing) per ulteriori dettagli su queste opzioni.

## Perché Z position_endstop è impostato su 0.5 nelle configurazioni predefinite?

Per le stampanti cartesiane Z position_endstop specifica la distanza dell'ugello dal piatto quando si attiva ilfinecorsa. Se possibile, si consiglia di utilizzare un finecorsa Z-max e di tornare a casa lontano dal piatto (in quanto ciò riduce il rischio di collisioni con il piatto). Tuttavia, se ci si deve avvicinare al piatto, si consiglia di posizionare il finecorsa in modo che si attivi quando la bocchetta è ancora a una piccola distanza dal piatto. In questo modo, durante l'homing dell'asse, si fermerà prima che l'ugello tocchi il letto. Per ulteriori informazioni, vedere il [bed level document](Bed_Level.md).

## Ho convertito la mia configurazione da Marlin e gli assi X/Y funzionano bene, ma ottengo solo un rumore stridente durante homing dell'asse Z

Risposta breve: in primo luogo, assicurati di aver verificato la configurazione dello stepper come descritto nel [config check document](Config_checks.md). Se il problema persiste, provare a ridurre l'impostazione max_z_velocity nella configurazione della stampante.

Risposta lunga: in pratica Marlin può in genere fare solo un passo a una velocità di circa 10000 passi al secondo. Se gli viene richiesto di muoversi a una velocità che richiederebbe una velocità di passo più alta, Marlin generalmente farà un passo più veloce possibile. Klipper è in grado di raggiungere velocità di passo molto più elevate, ma il motore passo-passo potrebbe non avere una coppia sufficiente per muoversi a una velocità più elevata. Quindi, per un asse Z con un rapporto di trasmissione elevato o un'impostazione di micropassi elevata, l'effettiva velocità max_z_ottenibile potrebbe essere inferiore a quella configurata in Marlin.

## Il mio driver TMC del motore si spegne nel mezzo di una stampa

Se si utilizza il driver TMC2208 (o TMC2224) in "modalità standalone", assicurarsi di utilizzare l'[latest version of Klipper](#how-do-i-upgrade-to-the-latest-software). Una soluzione alternativa per un problema del driver "stealthchop" TMC2208 è stata aggiunta a Klipper a metà marzo del 2020.

## Continuo a ricevere errori casuali "Comunicazione persa con MCU" |"Lost communication with MCU"

Ciò è comunemente causato da errori hardware sulla connessione USB tra la macchina host e il microcontrollore. Cose da cercare:

- Utilizzare un cavo USB di buona qualità tra la macchina host e il microcontrollore. Assicurati che i connettori siano ben saldi.
- Se si utilizza un Raspberry Pi, utilizzare un [alimentatore di buona qualità](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply) per il Raspberry Pi e utilizzare un [cavo USB di buona qualità](https://forums.raspberrypi.com/viewtopic.php?p=589877#p589877) per collegare quell'alimentatore al Pi. Se ricevi avvisi di "sottotensione" da OctoPrint, questo è correlato all'alimentatore e deve essere risolto.
- Assicurarsi che l'alimentazione della stampante non sia sovraccarica. (Le fluttuazioni di alimentazione del chip USB del microcontrollore possono comportare il reset di quel chip.)
- Verificare che i cavi dello stepper, del riscaldatore e di altri cavi della stampante non siano arricciati o sfilacciati. (Il movimento della stampante può sollecitare un cavo difettoso causandone la perdita di contatto, un cortocircuito breve o la generazione di rumore eccessivo.)
- Sono stati segnalati rumori USB elevati quando sia l'alimentazione della stampante che l'alimentazione a 5 V dell'host sono mescolate. (Se si scopre che il microcontrollore si accende quando l'alimentazione della stampante è accesa o il cavo USB è collegato, significa che gli alimentatori da 5 V vengono mescolati.) Può essere utile configurare il microcontrollore da utilizzare alimentazione da una sola fonte. (In alternativa, se la scheda del microcontrollore non è in grado di configurare la sua fonte di alimentazione, è possibile modificare un cavo USB in modo che non trasmetta alimentazione a 5V tra l'host e il microcontrollore.)

## Il mio Raspberry Pi continua a riavviarsi durante le stampe

Questo è molto probabilmente dovuto alle fluttuazioni di tensione. Segui gli stessi passaggi per la risoluzione dei problemi per un errore ["Comunicazione persa con MCU"](#i-keep-getting-random-lost-communication-with-mcu-errors).

## Quando imposto `restart_method=command` il mio dispositivo AVR si blocca al riavvio

Alcune vecchie versioni del bootloader AVR hanno un bug noto nella gestione degli eventi di watchdog. Questo in genere si manifesta quando il file printer.cfg ha restart_method impostato su "command". Quando si verifica il bug, il dispositivo AVR non risponderà fino a quando l'alimentazione non viene rimossa e ricollegata al dispositivo (anche i LED di alimentazione o di stato potrebbero lampeggiare ripetutamente fino a quando l'alimentazione non viene rimossa).

La soluzione alternativa è utilizzare un restart_method diverso da "command" o eseguire il flashing di un bootloader aggiornato sul dispositivo AVR. Il flashing di un nuovo bootloader è un passaggio che in genere richiede un programmatore esterno: vedere [Bootloaders](Bootloaders.md) per ulteriori dettagli.

## I riscaldatori verranno lasciati accesi se il Raspberry Pi si arresta in modo anomalo?

Il software è stato progettato per impedirlo. Una volta che l'host abilita un riscaldatore, il software host deve confermare tale abilitazione ogni 5 secondi. Se il microcontrollore non riceve una conferma ogni 5 secondi, entra in uno stato di "spegnimento" progettato per spegnere tutti i riscaldatori e i motori passo-passo.

Per ulteriori dettagli, vedere il comando "config_digital_out" nel documento [Comandi MCU](MCU_Commands.md).

Inoltre, il software del microcontrollore è configurato con un intervallo di temperatura minimo e massimo per ciascun riscaldatore all'avvio (consultare i parametri min_temp e max_temp in [config reference](Config_Reference.md#extruder) per i dettagli). Se il microcontrollore rileva che la temperatura è al di fuori di tale intervallo, entrerà anche in uno stato di "spegnimento".

Separatamente, il software host implementa anche il codice per verificare che i riscaldatori e i sensori di temperatura funzionino correttamente. Vedere il [riferimento di configurazione](Config_Reference.md#verify_heater) per ulteriori dettagli.

## Come posso convertire un numero di pin Marlin in un nome pin di Klipper?

Risposta breve: una mappatura è disponibile nel file [sample-aliases.cfg](../config/sample-aliases.cfg). Usa quel file come guida per trovare i nomi effettivi dei pin del microcontrollorei. (È anche possibile copiare la relativa sezione di configurazione [board_pins](Config_Reference.md#board_pins) nel file di configurazione e utilizzare gli alias nella configurazione, ma è preferibile tradurre e utilizzare i nomi dei pin del microcontrollore effettivi.) Nota che il file sample-aliases.cfg usa nomi di pin che iniziano con il prefisso "ar" invece di "D" (ad esempio, il pin Arduino `D23` è alias Klipper `ar23`) e il prefisso "analog" invece di "A " (ad esempio, il pin Arduino `A14` è alias di Klipper `analog14`).

Risposta lunga: Klipper utilizza i nomi dei pin standard definiti dal microcontrollore. Sui chip Atmega questi pin hardware hanno nomi come `PA4`, `PC7` o `PD2`.

Tempo fa, il progetto Arduino ha deciso di evitare di utilizzare i nomi hardware standard a favore dei propri nomi pin basati su numeri incrementali: questi nomi Arduino generalmente assomigliano a "D23" o "A14". Questa è stata una scelta sfortunata che ha portato a una grande confusione. In particolare, i numeri dei pin di Arduino spesso non si traducono negli stessi nomi hardware. Ad esempio, `D21` è `PD0` su una comune scheda Arduino, ma è `PC7` su un'altra comune scheda Arduino.

Per evitare questa confusione, il codice di base di Klipper utilizza i nomi dei pin standard definiti dal microcontrollore.

## Devo collegare il mio dispositivo a un tipo specifico di pin del microcontrollore?

Dipende dal tipo di dispositivo e dal tipo di pin:

Pin ADC (o pin analogici): per termistori e sensori "analogici" simili, il dispositivo deve essere collegato a un pin compatibile con "analogico" o "ADC" sul microcontrollore. Se configuri Klipper per utilizzare un pin che non è compatibile con l'analogico, Klipper segnalerà un errore "Non un pin ADC valido".

Pin PWM (o pin Timer): Klipper non utilizza PWM hardware per impostazione predefinita per nessun dispositivo. Quindi, in generale, è possibile collegare riscaldatori, ventole e dispositivi simili a qualsiasi pin IO generico. Tuttavia, le ventole e i dispositivi output_pin possono essere opzionalmente configurati per utilizzare `hardware_pwm: True`, nel qual caso il microcontrollore deve supportare PWM hardware sul pin (altrimenti, Klipper segnalerà un errore "pin PWM non valido").

Pin IRQ (o pin di interrupt): Klipper non utilizza gli interrupt hardware sui pin IO, quindi non è mai necessario collegare un dispositivo a uno di questi pin del microcontrollore.

Pin SPI: quando si utilizza l'SPI hardware, è necessario collegare i pin ai pin SPI del microcontrollore. Tuttavia, la maggior parte dei dispositivi può essere configurata per utilizzare "SPI software", nel qual caso è possibile utilizzare qualsiasi pin IO generico.

Pin I2C: quando si utilizza I2C è necessario collegare i pin ai pin compatibili con I2C del microcontrollore.

Altri dispositivi possono essere collegati a qualsiasi pin IO generico. Ad esempio, stepper, riscaldatori, ventole, sonde Z, servocomandi, LED, comuni display LCD hd44780/st7920, la linea di controllo Trinamic UART può essere collegata a qualsiasi pin IO generico.

## Come posso annullare una richiesta di "attesa temperatura" M109/M190?

Passare alla scheda del terminale OctoPrint ed emettere un comando M112 nel terminale. Il comando M112 farà entrare Klipper in uno stato di "arresto" e causerà la disconnessione di OctoPrint da Klipper. Passare all'area di connessione di OctoPrint e fare clic su "Connetti" per fare in modo che OctoPrint si riconnetta. Torna alla scheda del terminale ed emetti un comando FIRMWARE_RESTART per cancellare lo stato di errore di Klipper. Dopo aver completato questa sequenza, la precedente richiesta di riscaldamento verrà annullata e potrebbe essere avviata una nuova stampa.

## Posso scoprire se la stampante ha perso dei passaggi?

In un certo senso sì. Avviare la stampante, emettere un comando `GET_POSITION`, eseguire la stampa, tornare a casa ed emettere un altro `GET_POSITION`. Quindi confronta i valori nella riga `mcu:`.

Questo potrebbe essere utile per regolare impostazioni come correnti, accelerazioni e velocità del motore passo-passo senza dover effettivamente stampare qualcosa e sprecare il filamento: basta eseguire alcuni movimenti ad alta velocità tra i comandi `GET_POSITION`.

Si noti che gli stessi interruttori di fine corsa tendono a attivarsi in posizioni leggermente diverse, quindi una differenza di un paio di micropassi è probabilmente il risultato di imprecisioni di fine corsa. Un motore passo-passo stesso può perdere passi solo con incrementi di 4 passi completi. (Quindi, se si utilizzano 16 micropassi, un passo perso sullo stepper comporterebbe lo spegnimento del contatore di passi "mcu:" di un multiplo di 64 micropassi.)

## Perché Klipper segnala errori? Ho perso la mia stampa!

Risposta breve: vogliamo sapere se le nostre stampanti rilevano un problema in modo che il problema sottostante possa essere risolto e possiamo ottenere stampe di ottima qualità. Non vogliamo assolutamente che le nostre stampanti producano in silenzio stampe di bassa qualità.

Risposta lunga: Klipper è stato progettato per risolvere automaticamente molti problemi transitori. Ad esempio, rileva automaticamente gli errori di comunicazione e li ritrasmette; pianifica le azioni in anticipo e bufferizza i comandi su più livelli per consentire tempi precisi anche con interferenze intermittenti. Tuttavia, se il software rileva un errore dal quale non può essere ripristinato, se gli viene ordinato di eseguire un'azione non valida o se rileva che è irrimediabilmente incapace di eseguire l'attività comandata, Klipper segnalerà un errore. In queste situazioni c'è un alto rischio di produrre una stampa di bassa qualità (o peggio). Si spera che avvisare gli utenti consentirà loro di risolvere il problema sottostante e migliorare la qualità complessiva delle loro stampe.

Ci sono alcune domande correlate: perché Klipper non mette invece in pausa la stampa? Segnalare invece un avviso? Verificare la presenza di errori prima della stampa? Ignorare gli errori nei comandi digitati dall'utente? eccetera? Attualmente Klipper legge i comandi utilizzando il protocollo G-Code e sfortunatamente il protocollo di comando G-Code non è sufficientemente flessibile per rendere pratiche queste alternative oggi. C'è l'interesse degli sviluppatori nel migliorare l'esperienza dell'utente durante eventi anomali, ma si prevede che ciò richiederà un notevole lavoro infrastrutturale (incluso un passaggio dal G-Code).

## Come si esegue l'aggiornamento al software più recente?

Il primo passaggio per l'aggiornamento del software consiste nell'esaminare l'ultimo documento [config changes](Config_Changes.md). A volte, vengono apportate modifiche al software che richiedono agli utenti di aggiornare le proprie impostazioni come parte di un aggiornamento del software. È una buona idea rivedere questo documento prima dell'aggiornamento.

Quando sei pronto per l'aggiornamento, il metodo generale è quello di entrare in Raspberry Pi ed eseguire:

```
cd ~/klipper
git pull
~/klipper/scripts/install-octopi.sh
```

Quindi si può ricompilare e flashare il codice del microcontrollore. Per esempio:

```
make menuconfig
make clean
make

sudo service klipper stop
make flash FLASH_DEVICE=/dev/ttyACM0
sudo service klipper start
```

Tuttavia, capita spesso che cambi solo il software host. In questo caso è possibile aggiornare e riavviare solo il software host con:

```
cd ~/klipper
git pull
sudo service klipper restart
```

Se dopo aver utilizzato questo collegamento il software avverte della necessità di eseguire il reflash del microcontrollore o si verifica qualche altro errore insolito, seguire i passaggi completi di aggiornamento descritti sopra.

Se gli errori persistono, ricontrolla il documento [config changes](Config_Changes.md), poiché potrebbe essere necessario modificare la configurazione della stampante.

Si noti che i comandi g-code RESTART e FIRMWARE_RESTART non caricano il nuovo software: i comandi "sudo service klipper restart" e "make flash" di cui sopra sono necessari affinché una modifica del software abbia effetto.

## Come faccio a disinstallare Klipper?

Dal alto del firmware, non deve succedere nulla di speciale. Basta seguire le indicazioni per il flashing del nuovo firmware.

Dal lato del raspberry pi, uno script di disinstallazione è disponibile in [scripts/klipper-uninstall.sh](../scripts/klipper-uninstall.sh). Per esempio:

```
sudo ~/klipper/scripts/klipper-uninstall.sh
rm -rf ~/klippy-env ~/klipper
```
