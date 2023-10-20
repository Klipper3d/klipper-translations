# Bootloader

Questo documento fornisce informazioni sui bootloader comuni scoperti sui microcontrollori che sono supportati da Klipper.

Il bootloader è un software di terze parti che viene eseguito sul microcontrollore quando viene acceso per la prima volta. Viene generalmente utilizzato per eseguire il flashing di una nuova applicazione (ad es. Klipper) sul microcontrollore senza richiedere hardware specializzato. Sfortunatamente, non esiste uno standard a livello di settore per il flashing di un microcontrollore, né esiste un bootloader standard che funzioni su tutti i microcontrollori. Peggio ancora, è comune che ogni bootloader richieda una serie di passaggi diversa per eseguire il flashing di un'applicazione.

Se si può eseguire il flashing di un bootloader su un microcontrollore, generalmente si può anche utilizzare quel meccanismo per eseguire il flashing di un'applicazione, ma è necessario prestare attenzione quando si esegue questa operazione poiché si potrebbe rimuovere inavvertitamente il bootloader. Al contrario, un bootloader generalmente consentirà solo a un utente di eseguire il flashing di un'applicazione. Si consiglia pertanto di utilizzare un bootloader per eseguire il flashing di un'applicazione, ove possibile.

Questo documento tenta di descrivere i bootloader comuni, i passaggi necessari per eseguire il flashing di un bootloader e i passaggi necessari per eseguire il flashing di un'applicazione. Questo documento non è un riferimento autorevole; è inteso come una raccolta di informazioni utili che gli sviluppatori di Klipper hanno accumulato.

## Microcontrollori AVR

In generale, il progetto Arduino è un buon riferimento per bootloader e procedure di flashing sui microcontrollori Atmel Atmega a 8 bit. In particolare, il file "boards.txt": <https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt> è un utile riferimento.

Per eseguire il flashing di un bootloader, i chip AVR richiedono uno strumento di flashing hardware esterno (che comunica con il chip tramite SPI). Questo strumento può essere acquistato (ad esempio, eseguire una ricerca sul Web per "avr isp", "arduino isp" o "usb tiny isp"). È anche possibile utilizzare un altro Arduino o Raspberry Pi per eseguire il flashing di un bootloader AVR (ad esempio, eseguire una ricerca sul Web per "programmare un avr utilizzando raspberry pi"). Gli esempi seguenti sono scritti presupponendo che sia in uso un dispositivo di tipo "AVR ISP Mk2".

Il programma "avrdude" è lo strumento più comune utilizzato per eseguire il flashing dei chip atmega (sia flash del bootloader che flash dell'applicazione).

### Atmega2560

Questo chip si trova in genere nell'"Arduino Mega" ed è molto comune nelle schede per stampanti 3D.

Per eseguire il flashing del bootloader stesso usa qualcosa come:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Per eseguire il flashing di un'applicazione, utilizzare qualcosa come:

```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

Questo chip si trova in genere nelle prime versioni di "Arduino Mega".

Per eseguire il flashing del bootloader stesso usa qualcosa come:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Per eseguire il flashing di un'applicazione, utilizzare qualcosa come:

```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

Questo chip si trova comunemente nelle schede per stampanti 3D in stile "Melzi".

Per eseguire il flashing del bootloader stesso usa qualcosa come:

```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Per eseguire il flashing di un'applicazione, utilizzare qualcosa come:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

Si noti che un certo numero di schede in stile "Melzi" sono precaricate con un bootloader che utilizza una velocità di trasmissione di 57600 baud. In questo caso, per eseguire il flashing di un'applicazione utilizzare invece qualcosa di simile:

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

Questo documento non copre il metodo per eseguire il flashing di un bootloader su At90usb1286 né copre il flashing di applicazioni generali su questo dispositivo.

Il dispositivo Teensy++ di pjrc.com viene fornito con un bootloader proprietario. Richiede uno strumento di flashing personalizzato da <https://github.com/PaulStoffregen/teensy_loader_cli>. Si può eseguire il flashing di un'applicazione usando qualcosa come:

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

L'atmega168 ha uno spazio flash limitato. Se si utilizza un bootloader, si consiglia di utilizzare il bootloader Optiboot. Per eseguire il flashing di quel bootloader usa qualcosa come:

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Per eseguire il flashing di un'applicazione tramite il bootloader Optiboot, utilizzare qualcosa come:

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## Microcontrollori SAM3 (Arduino Due)

Non è comune utilizzare un bootloader con l'mcu SAM3. Il chip stesso ha una ROM che permette di programmare il flash da porta seriale 3.3V o da USB.

Per abilitare la ROM, il pin "erase" viene tenuto alto durante un reset, che cancella il contenuto della flash e fa funzionare la ROM. Su un Arduino Due, questa sequenza può essere realizzata impostando un baud rate di 1200 sulla "porta usb di programmazione" (la porta USB più vicina all'alimentatore).

Il codice in <https://github.com/shumatech/BOSSA> può essere utilizzato per programmare il SAM3. Si consiglia di utilizzare la versione 1.9 o successiva.

Per eseguire il flashing di un'applicazione, utilizzare qualcosa come:

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## Microcontrollori SAM4 (Duet Wifi)

Non è comune utilizzare un bootloader con l'mcu SAM4. Il chip stesso ha una ROM che permette di programmare la memoria flash da porta seriale 3.3V o da USB.

Per abilitare la ROM, il pin "erase" viene tenuto alto durante un reset, che cancella il contenuto della memoria flash e fa funzionare la ROM.

Il codice in <https://github.com/shumatech/BOSSA> può essere utilizzato per programmare il SAM4. È necessario utilizzare la versione `1.8.0` o successiva.

Per eseguire il flashing di un'applicazione, utilizzare qualcosa come:

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## SAMDC21 micro-controllers (Duet3D Toolboard 1LC)

The SAMC21 is flashed via the ARM Serial Wire Debug (SWD) interface. This is commonly done with a dedicated SWD hardware dongle. Alternatively, one can use a [Raspberry Pi with OpenOCD](#running-openocd-on-the-raspberry-pi).

When using OpenOCD with the SAMC21, extra steps must be taken to first put the chip into Cold Plugging mode if the board makes use of the SWD pins for other purposes. If using OpenOCD on a Rasberry Pi, this can be done by running the following commands before invoking OpenOCD.

```
SWCLK=25
SWDIO=24
SRST=18

echo "Exporting SWCLK and SRST pins."
echo $SWCLK > /sys/class/gpio/export
echo $SRST > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$SWCLK/direction
echo "out" > /sys/class/gpio/gpio$SRST/direction

echo "Setting SWCLK low and pulsing SRST."
echo "0" > /sys/class/gpio/gpio$SWCLK/value
echo "0" > /sys/class/gpio/gpio$SRST/value
echo "1" > /sys/class/gpio/gpio$SRST/value

echo "Unexporting SWCLK and SRST pins."
echo $SWCLK > /sys/class/gpio/unexport
echo $SRST > /sys/class/gpio/unexport
```

To flash a program with OpenOCD use the following chip config:

```
source [find target/at91samdXX.cfg]
```

Obtain a program; for instance, klipper can be built for this chip. Flash with OpenOCD commands similar to:

```
at91samd chip-erase
at91samd bootloader 0
program out/klipper.elf verify
```

## Microcontrollori SAMD21 (Arduino Zero)

Il bootloader SAMD21 viene caricato in memoria flashing tramite l'interfaccia ARM Serial Wire Debug (SWD). Questo viene fatto comunemente con un dongle hardware SWD dedicato. In alternativa, è possibile utilizzare un [Raspberry Pi con OpenOCD](#running-openocd-on-the-raspberry-pi).

Per eseguire il flashing di un bootloader con OpenOCD, utilizzare la seguente configurazione del chip:

```
source [find target/at91samdXX.cfg]
```

Ottieni un bootloader, ad esempio:

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

Carica la memoria Flash con comandi OpenOCD simili a:

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

Il bootloader più comune sul SAMD21 è quello che si trova sull' "Arduino Zero". Utilizza un bootloader da 8KiB (l'applicazione deve essere compilata con un indirizzo iniziale di 8KiB). Si può entrare in questo bootloader facendo doppio clic sul pulsante di ripristino. Per eseguire il flashing di un'applicazione, utilizzare qualcosa come:

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

Al contrario, "Arduino M0" utilizza un bootloader da 16 KiB (l'applicazione deve essere compilata con un indirizzo iniziale di 16 KiB). Per eseguire il flashing di un'applicazione su questo bootloader, ripristinare il microcontrollore ed eseguire il comando flash entro i primi secondi dall'avvio, qualcosa del tipo:

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## Microcontrollori SAMD51 (Adafruit Metro-M4 e simili)

Come il SAMD21, il bootloader SAMD51 viene eseguito il flashing tramite l'interfaccia ARM Serial Wire Debug (SWD). Per eseguire il flashing di un bootloader con [OpenOCD su un Raspberry Pi](#running-openocd-on-the-raspberry-pi) utilizzare la seguente configurazione del chip:

```
source [find target/atsame5x.cfg]
```

Ottieni un bootloader: diversi bootloader sono disponibili da <https://github.com/adafruit/uf2-samdx1/releases/latest>. Per esempio:

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

Carica la memoria Flash con comandi OpenOCD simili a:

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

Il SAMD51 utilizza un bootloader da 16 KiB (l'applicazione deve essere compilata con un indirizzo iniziale di 16 KiB). Per eseguire il flashing di un'applicazione, utilizzare qualcosa come:

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## Microcontrollori STM32F103 (dispositivi Blue Pill)

I dispositivi STM32F103 dispongono di una ROM che può eseguire il flashing di un bootloader o di un'applicazione tramite seriale a 3,3 V. In genere si collegano i pin PA10 (MCU Rx) e PA9 (MCU Tx) a un adattatore UART da 3,3 V. Per accedere alla ROM, è necessario collegare il pin "boot 0" in alto e il pin "boot 1" in basso, quindi ripristinare il dispositivo. Il pacchetto "stm32flash" può quindi essere utilizzato per eseguire il flashing del dispositivo utilizzando qualcosa come:

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

Si noti che se si utilizza un Raspberry Pi per la seriale da 3,3 V, il protocollo stm32flash utilizza una modalità di parità seriale che il "mini UART" di Raspberry Pi non supporta. Vedere <https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts> per i dettagli sull'abilitazione dell'uart completo sui pin GPIO di Raspberry Pi.

Dopo aver caricato la memoria flash, imposta "boot 0" e "boot 1" su basso in modo che in futuro ripristini l'avvio da flash.

### STM32F103 con bootloader stm32duino

Il progetto "stm32duino" ha un bootloader compatibile con USB - vedere: <https://github.com/rogerclarkmelbourne/STM32duino-bootloader>

Questo bootloader può essere flashato tramite seriale 3.3V con qualcosa come:

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

Questo bootloader utilizza 8KiB di spazio flash (l'applicazione deve essere compilata con un indirizzo iniziale di 8KiB). Caricare in memoria flash un'applicazione con qualcosa come:

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

Il bootloader in genere viene eseguito solo per un breve periodo dopo l'avvio. Potrebbe essere necessario sincronizzare il comando sopra in modo che venga eseguito mentre il bootloader è ancora attivo (il bootloader farà lampeggiare un led della scheda mentre è in esecuzione). In alternativa, imposta il pin "boot 0" su basso e il pin "boot 1" su alto per rimanere nel bootloader dopo un ripristino.

### STM32F103 con bootloader HID

Il [bootloader HID](https://github.com/Serasidis/STM32_HID_Bootloader) è un bootloader compatto e senza driver in grado di eseguire il flashing attraverso USB. È inoltre disponibile un [fork con build specifiche per SKR Mini E3 1.2](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

Per le schede STM32F103 generiche come la blue pill è possibile eseguire il flashing del bootloader tramite seriale da 3,3 V utilizzando stm32flash come indicato nella sezione stm32duino sopra, sostituendo il nome del file con il binario del bootloader hid desiderato (ad esempio: hid_generic_pc13.bin per la blue pill ).

Non è possibile utilizzare stm32flash per SKR Mini E3 poiché il pin boot0 è collegato direttamente a terra e non disponibile tramite pin header. Si consiglia di utilizzare un STLink V2 con STM32Cubeprogrammer per eseguire il flashing del bootloader. Se non hai accesso a un STLink è anche possibile utilizzare un [Raspberry Pi e OpenOCD](#running-openocd-on-the-raspberry-pi) con la seguente configurazione del chip:

```
source [find target/stm32f1x.cfg]
```

Se lo desideri puoi fare un backup della flash corrente con il seguente comando. Tieni presente che il completamento potrebbe richiedere del tempo:

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

infine, puoi eseguire il flashing con comandi simili a:

```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```

NOTE:

- L'esempio sopra cancella il chip, quindi programma il bootloader. Indipendentemente dal metodo scelto per eseguire il flashing, si consiglia di cancellare il chip prima del flashing.
- Prima di eseguire il flashing di SKR Mini E3 con questo bootloader, dovresti essere consapevole che non sarai più in grado di aggiornare il firmware tramite la sdcard.
- You may need to hold down the reset button on the board while launching OpenOCD. It should display something like:
   ```
   Open On-Chip Debugger 0.10.0+dev-01204-gc60252ac-dirty (2020-04-27-16:00)
Licensed under GNU GPL v2
For bug reports, read
        http://openocd.org/doc/doxygen/bugs.html
DEPRECATED! use 'adapter speed' not 'adapter_khz'
Info : BCM2835 GPIO JTAG/SWD bitbang driver
Info : JTAG and SWD modes enabled
Info : clock speed 40 kHz
Info : SWD DPIDR 0x1ba01477
Info : stm32f1x.cpu: hardware has 6 breakpoints, 4 watchpoints
Info : stm32f1x.cpu: external reset detected
Info : starting gdb server for stm32f1x.cpu on 3333
Info : Listening on port 3333 for gdb connections
   ```
Dopodiché puoi rilasciare il pulsante di reset.

Questo bootloader richiede 2KiB di spazio flash (l'applicazione deve essere compilata con un indirizzo iniziale di 2KiB).

Il programma hid-flash viene utilizzato per caricare un file binario sul bootloader. È possibile installare questo software con i seguenti comandi:

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

Se il bootloader è in esecuzione, puoi eseguire il flash con qualcosa del tipo:

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

in alternativa, puoi usare `make flash` per flashare klipper direttamente:

```
make flash FLASH_DEVICE=1209:BEBA
```

O se klipper è stato precedentemente flashato:

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

Potrebbe essere necessario accedere manualmente al bootloader, questo può essere fatto impostando "boot 0" basso e "boot 1" alto. Sull'SKR Mini E3 "Boot 1" non è disponibile, quindi può essere fatto impostando il pin PA2 basso se hai flashato "hid_btt_skr_mini_e3.bin". Questo pin è etichettato "TX0" sull'intestazione TFT nel documento "PIN" di SKR Mini E3. C'è un pin di terra accanto a PA2 che puoi utilizzare per abbassare PA2.

### STM32F103/STM32F072 con bootloader MSC

Il [bootloader MSC](https://github.com/Telekatz/MSC-stm32f103-bootloader) è un bootloader senza driver in grado di eseguire il flashing su USB.

È possibile eseguire il flashing del bootloader tramite seriale da 3,3 V utilizzando stm32flash come indicato nella sezione stm32duino sopra, sostituendo il nome del file con il binario del bootloader MSC desiderato (ad esempio: MSCboot-Bluepill.bin per la blue pill).

Per le schede STM32F072 è anche possibile eseguire il flashing del bootloader su USB (tramite DFU) con qualcosa del tipo:

```
 dfu-util -d 0483:df11 -a 0 -R -D MSCboot-STM32F072.bin -s0x08000000:leave
```

Questo bootloader utilizza 8KiB o 16KiB di spazio flash, vedere la descrizione del bootloader (l'applicazione deve essere compilata con l'indirizzo iniziale corrispondente).

Il bootloader può essere attivato premendo due volte il pulsante di reset della scheda. Non appena il bootloader viene attivato, la scheda appare come una chiavetta USB su cui è possibile copiare il file klipper.bin.

### STM32F103/STM32F0x2 con bootloader CanBoot

Il bootloader [CanBoot](https://github.com/Arksine/CanBoot) fornisce un'opzione per caricare il firmware Klipper su CANBUS. Il bootloader stesso è derivato dal codice sorgente di Klipper. Attualmente CanBoot supporta i modelli STM32F103, STM32F042 e STM32F072.

Si consiglia di utilizzare un programmatore ST-Link per eseguire il flashing di CanBoot, tuttavia dovrebbe essere possibile eseguire il flashing utilizzando `stm32flash` sui dispositivi STM32F103 e "dfu-util" sui dispositivi STM32F042/STM32F072. Consulta le sezioni precedenti di questo documento per istruzioni su questi metodi di flashing, sostituendo `canboot.bin` con il nome del file dove appropriato. Il repository CanBoot collegato sopra fornisce istruzioni per la creazione del bootloader.

La prima volta che CanBoot è stato flashato, dovrebbe rilevare che non è presente alcuna applicazione e accedere al bootloader. Se ciò non accade è possibile entrare nel bootloader premendo due volte di seguito il pulsante di reset.

L'utilità `flash_can.py` fornita nella cartella `lib/canboot` può essere utilizzata per caricare il firmware di Klipper. E' necessario l'UUID del dispositivo per eseguire il flashing. Se non si dispone di un UUID è possibile interrogare i nodi che attualmente eseguono il bootloader:

```
python3 flash_can.py -q
```

Ciò restituirà gli UUID per tutti i nodi collegati non attualmente assegnati a un UUID. Questo dovrebbe includere tutti i nodi attualmente nel bootloader.

Una volta che hai un UUID, puoi caricare il firmware con il seguente comando:

```
python3 flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u aabbccddeeff
```

Dove `aabbccddeeff` è sostituito dal tuo UUID. Nota che le opzioni `-i` e `-f` possono essere omesse, per impostazione predefinita sono rispettivamente `can0` e `~/klipper/out/klipper.bin`.

Quando crei Klipper per l'uso con CanBoot, seleziona l'opzione Bootloader da 8 KiB.

## Microcontrollori STM32F4 (SKR Pro 1.1)

I microcontrollori STM32F4 sono dotati di un bootloader di sistema integrato in grado di eseguire il flashing tramite USB (tramite DFU), seriale da 3,3 V e vari altri metodi (vedere il documento STM AN2606 per ulteriori informazioni). Alcune schede STM32F4, come SKR Pro 1.1, non sono in grado di accedere al bootloader DFU. Il bootloader HID è disponibile per le schede basate su STM32F405/407 nel caso in cui l'utente preferisca eseguire il flashing tramite USB anziché utilizzare la scheda SD. Tieni presente che potrebbe essere necessario configurare e creare una versione specifica per la tua scheda, una [build per SKR Pro 1.1 è disponibile qui](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

A meno che la tua scheda non sia compatibile con DFU, il metodo di flashing più accessibile è probabilmente tramite seriale da 3,3 V, che segue la stessa procedura di [flash di STM32F103 utilizzando stm32flash](#stm32f103-micro-controllers-blue-pill-devices). Per esempio:

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

Questo bootloader richiede 16Kib di spazio flash sull'STM32F4 (l'applicazione deve essere compilata con un indirizzo iniziale di 16KiB).

Come con l'STM32F1, l'STM32F4 utilizza lo strumento hid-flash per caricare i file binari nell'MCU. Consulta le istruzioni sopra per i dettagli su come creare e utilizzare hid-flash.

Potrebbe essere necessario inserire manualmente il bootloader, questo può essere fatto impostando "boot 0" basso, "boot 1" alto e collegando il dispositivo. Al termine della programmazione, scollegare il dispositivo e impostare "boot 1" su basso in modo che l'applicazione venga caricata.

## Microcontrollori LPC176x (Smoothieboards)

Questo documento non descrive il metodo per eseguire il flashing di un bootloader stesso - vedere: <http://smoothieware.org/flashing-the-bootloader> per ulteriori informazioni su questo argomento.

È comune che per le Smoothieboard venga fornito con un bootloader da: <https://github.com/triffid/LPC17xx-DFU-Bootloader>. Quando si utilizza questo bootloader, l'applicazione deve essere compilata con un indirizzo iniziale di 16 KiB. Il modo più semplice per eseguire il flashing di un'applicazione con questo bootloader è copiare il file dell'applicazione (ad es. `out/klipper.bin`) in un file denominato `firmware.bin` su una scheda SD, quindi riavviare il microcontrollore con quella scheda SD.

## Eseguire OpenOCD su Raspberry PI

OpenOCD è un pacchetto software in grado di eseguire il flashing e il debug di chip di basso livello. Può utilizzare i pin GPIO su un Raspberry Pi per comunicare con una varietà di chip ARM.

Questa sezione descrive come installare e avviare OpenOCD. È derivato dalle istruzioni su: <https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>

Inizia scaricando e compilando il software (ogni passaggio può richiedere diversi minuti e il passaggio "make" può richiedere più di 30 minuti):

```
sudo apt-get update
sudo apt-get install autoconf libtool telnet
mkdir ~/openocd
cd ~/openocd/
git clone http://openocd.zylin.com/openocd
cd openocd
./bootstrap
./configure --enable-sysfsgpio --enable-bcm2835gpio --prefix=/home/pi/openocd/install
make
make install
```

### Configurare OpenOCD

Crea un file di configurazione OpenOCD:

```
nano ~/openocd/openocd.cfg
```

Utilizzare una configurazione simile alla seguente:

```
# Uses RPi pins: GPIO25 for SWDCLK, GPIO24 for SWDIO, GPIO18 for nRST
source [find interface/raspberrypi2-native.cfg]
bcm2835gpio_swd_nums 25 24
bcm2835gpio_srst_num 18
transport select swd

# Use hardware reset wire for chip resets
reset_config srst_only
adapter_nsrst_delay 100
adapter_nsrst_assert_width 100

# Specify the chip type
source [find target/atsame5x.cfg]

# Set the adapter speed
adapter_khz 40

# Connect to chip
init
targets
reset halt
```

### Collega il Raspberry Pi al chip di destinazione

Spegni sia il Raspberry Pi che il chip di destinazione prima del cablaggio! Verificare che il chip di destinazione utilizzi 3,3 V prima di connettersi a un Raspberry Pi!

Collega GND, SWDCLK, SWDIO e RST sul chip di destinazione rispettivamente a GND, GPIO25, GPIO24 e GPIO18 sul Raspberry Pi.

Quindi accendi il Raspberry Pi e fornisci alimentazione al chip di destinazione.

### Eseguire OpenOCD

Esegui OpenOCD:

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

Quanto sopra dovrebbe far sì che OpenOCD emetta alcuni messaggi di testo e quindi attenda (non dovrebbe tornare immediatamente al prompt della shell Unix). Se OpenOCD termina da solo o se continua a emettere messaggi di testo, ricontrolla il cablaggio.

Una volta che OpenOCD è in esecuzione ed è stabile, è possibile inviargli comandi tramite telnet. Apri un'altra sessione ssh ed esegui quanto segue:

```
telnet 127.0.0.1 4444
```

(Si può uscire da telnet premendo ctrl+] e quindi eseguendo il comando "quit".)

### OpenOCD e gdb

È possibile utilizzare OpenOCD con gdb per eseguire il debug di Klipper. I seguenti comandi presuppongono che uno stia eseguendo gdb su una macchina di classe desktop.

Aggiungi quanto segue al file di configurazione di OpenOCD:

```
bindto 0.0.0.0
gdb_port 44444
```

Riavvia OpenOCD sul Raspberry Pi e quindi esegui il seguente comando Unix sul computer desktop:

```
cd /path/to/klipper/
gdb out/klipper.elf
```

All'interno di gdb esegui:

```
target remote octopi:44444
```

(Sostituisci "octopi" con il nome host del Raspberry Pi.) Una volta che gdb è in esecuzione, è possibile impostare punti di interruzione e ispezionare i registri.
