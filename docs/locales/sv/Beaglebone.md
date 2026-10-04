# Beaglebone

Detta dokument beskriver hur Klipper körs på en BeagleBone PRU.

## Bygga en operativsystemsavbildning

Börja med att installera avbildningen [Debian 11.7 2023-09-02 4GB microSD IoT](https://beagleboard.org/latest-images). Avbildningen kan köras från ett microSD-kort eller inbyggt eMMC-minne. Om eMMC används ska den installeras till eMMC nu enligt instruktionerna i länken ovan.

Anslut sedan med SSH till BeagleBone-maskinen (`ssh debian@beaglebone` – lösenordet är `temppwd`).

Innan Klipper installeras måste mer diskutrymme frigöras. Det finns tre sätt att göra det:

1. ta bort vissa BeagleBone-"demo"-resurser
1. om systemet startades från SD-kort och kortet är större än 4 GB kan filsystemet utökas till hela kortets utrymme
1. gör alternativ 1 och 2 tillsammans.

Kör följande kommandon för att ta bort vissa BeagleBone-"demo"-resurser

```
sudo apt remove bb-node-red-installer
sudo apt remove bb-code-server
```

Kör följande kommando för att utöka filsystemet till hela SD-kortets storlek; omstart krävs inte.

```
sudo growpart /dev/mmcblk0 1
sudo resize2fs /dev/mmcblk0p1
```

Installera Klipper genom att köra följande kommandon:

```
git clone https://github.com/Klipper3d/klipper.git
./klipper/scripts/install-beaglebone.sh
```

Efter installationen av Klipper måste du avgöra vilken typ av driftsättning som behövs. Observera att BeagleBone är maskinvara för 3,3 V och att stift i de flesta fall inte kan anslutas direkt till maskinvara för 5 V eller 12 V utan nivåomvandlingskort.

Eftersom Klipper har en flermodulsarkitektur på BeagleBone kan många olika användningsfall hanteras. De vanligaste är följande:

Användningsfall 1: Använd BeagleBone enbart som värdsystem för Klipper och ytterligare programvara som OctoPrint/Fluidd + Moonraker. Den här konfigurationen styr externa mikrokontroller via seriella anslutningar, USB eller CAN-buss.

Användningsfall 2: Använd BeagleBone med ett expansionskort (cape), exempelvis CRAMPS. I denna konfiguration är BeagleBone värd för Klipper och ytterligare programvara, och styr expansionskortet med BeagleBone PRU-kärnor – två ytterligare 200 MHz/32-bitarskärnor.

Användningsfall 3: Samma som användningsfall 1, men med behov av att styra BeagleBone-GPIO med hög hastighet genom att använda PRU-kärnorna för att avlasta huvudprocessorn.

## Installera OctoPrint

Du kan därefter installera OctoPrint, eller hoppa över detta avsnitt helt om annan programvara önskas:

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

Konfigurera sedan OctoPrint för att starta vid uppstart:

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

OctoPrints konfigurationsfil **/etc/default/octoprint** måste ändras. Ändra användaren `OCTOPRINT_USER` till `debian`, ändra `NICELEVEL` till `0`, avkommentera inställningarna `BASEDIR`, `CONFIGFILE` och `DAEMON` och ändra referenserna från `/home/pi/` till `/home/debian/`:

```
sudo nano /etc/default/octoprint
```

Starta sedan tjänsten OctoPrint:

```
sudo systemctl start octoprint
```

Vänta 1–2 minuter och kontrollera att OctoPrints webbserver är åtkomlig – den ska finnas på <http://beaglebone:5000/>.

## Bygga BeagleBone PRU-mikrokontrollerkoden (PRU-firmware)

Detta avsnitt krävs för "användningsfall 2" och "användningsfall 3" ovan, men ska hoppas över för "användningsfall 1".

Kontrollera att nödvändiga enheter finns

```
sudo beagle-version
```

Kontrollera att utdata visar att drivrutinerna `remoteproc` har lästs in och att PRU-kärnorna finns. I kärna 5.10 ska de vara `remoteproc1` och `remoteproc2` (4a334000.pru, 4a338000.pru). Kontrollera också att många GPIO:er har lästs in; de ser ut som `Allocated GPIO id=0 name='P8_03'`. Vanligen fungerar allt utan maskinvarukonfiguration. Om något saknas kan du prova alternativen för `uboot overlays` eller `cape-overlays`. Följande är endast ett exempel på utdata från en fungerande BeagleBone Black-konfiguration med CRAMPS-kort:

```
model:[TI_AM335x_BeagleBone_Black]
UBOOT: Booted Device-Tree:[am335x-boneblack-uboot-univ.dts]
UBOOT: Loaded Overlay:[BB-ADC-00A0.bb.org-overlays]
UBOOT: Loaded Overlay:[BB-BONE-eMMC1-01-00A0.bb.org-overlays]
kernel:[5.10.168-ti-r71]
/boot/uEnv.txt Settings:
uboot_overlay_options:[enable_uboot_overlays=1]
uboot_overlay_options:[disable_uboot_overlay_video=0]
uboot_overlay_options:[disable_uboot_overlay_audio=1]
uboot_overlay_options:[disable_uboot_overlay_wireless=1]
uboot_overlay_options:[enable_uboot_cape_universal=1]
pkg:[bb-cape-overlays]:[4.14.20210821.0-0~bullseye+20210821]
pkg:[bb-customizations]:[1.20230720.1-0~bullseye+20230720]
pkg:[bb-usb-gadgets]:[1.20230414.0-0~bullseye+20230414]
pkg:[bb-wl18xx-firmware]:[1.20230414.0-0~bullseye+20230414]
.............
.............
```

För att kompilera Klippers mikrokontrollerkod ska den först konfigureras för "Beaglebone PRU". För "BeagleBone Black" ska alternativen "Support GPIO Bit-banging devices" och "Support LCD devices" dessutom inaktiveras under "Optional features", eftersom de inte ryms i PRU-firmwareminnets 8 kB. Avsluta sedan och spara konfigurationen:

```
cd ~/klipper/
make menuconfig
```

Kör följande för att bygga och installera den nya PRU-mikrokontrollerkoden:

```
sudo service klipper stop
make flash
sudo service klipper start
```

När kommandona ovan har körts bör PRU-firmwaren vara klar och startad. Kör följande kommando för att kontrollera att allt gick bra:

```
dmesg
```

och jämför de sista meddelandena med exemplet som visar att allt startade korrekt:

```
[   71.105499] remoteproc remoteproc1: 4a334000.pru is available
[   71.157155] remoteproc remoteproc2: 4a338000.pru is available
[   73.256287] remoteproc remoteproc1: powering up 4a334000.pru
[   73.279246] remoteproc remoteproc1: Booting fw image am335x-pru0-fw, size 97112
[   73.285807]  remoteproc1#vdev0buffer: registered virtio0 (type 7)
[   73.285836] remoteproc remoteproc1: remote processor 4a334000.pru is now up
[   73.286322] remoteproc remoteproc2: powering up 4a338000.pru
[   73.313717] remoteproc remoteproc2: Booting fw image am335x-pru1-fw, size 188560
[   73.313753] remoteproc remoteproc2: header-less resource table
[   73.329964] remoteproc remoteproc2: header-less resource table
[   73.348321] remoteproc remoteproc2: remote processor 4a338000.pru is now up
[   73.443355] virtio_rpmsg_bus virtio0: creating channel rpmsg-pru addr 0x1e
[   73.443727] virtio_rpmsg_bus virtio0: msg received with no recipient
[   73.444352] virtio_rpmsg_bus virtio0: rpmsg host is online
[   73.540993] rpmsg_pru virtio0.rpmsg-pru.-1.30: new rpmsg_pru device: /dev/rpmsg_pru30
```

Observera "/dev/rpmsg_pru30" – den blir den seriella enheten för huvud-MCU:ns konfiguration. Enheten måste finnas; saknas den startade inte PRU-kärnorna korrekt.

## Bygga och installera mikrokontrollerkod för Linux-värd

Det här avsnittet krävs för "Användningsfall 2" och är valfritt för "Användningsfall 3" ovan.

Mikrokontrollerkoden för en Linux-värdprocess måste också kompileras och installeras. Konfigurera den en andra gång för en "Linux-process":

```
make menuconfig
```

Installera sedan även denna mikrokontrollerkod:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Observera "/tmp/klipper_host_mcu" – den blir den seriella enheten för "mcu host". Om filen saknas, se "scripts/klipper-mcu.service"; den installerades av tidigare kommandon och ansvarar för den.

För "Användningsfall 2": använd alltid temperatursensorer från "mcu host" när skrivarens konfiguration anges, eftersom standard-"mcu" (PRU-kärnorna) saknar ADC:er. Exempel på "sensor_pin" för extrudern och värmebädden finns i "generic-cramps.cfg". Andra GPIO:er kan refereras direkt från "mcu host", exempelvis "host:gpiochip1/gpio17", men undvik det eftersom det belastar huvudprocessorn extra och sannolikt inte kan användas för stegmotorstyrning.

## Återstående konfiguration

Slutför installationen genom att konfigurera Klipper enligt instruktionerna i huvuddokumentet [Installation](Installation.md#configuring-octoprint-to-use-klipper).

## Skriva ut med BeagleBone

BeagleBone-processorn kan tyvärr ibland ha svårt att köra OctoPrint väl. Vid komplexa utskrifter kan utskriften stanna (skrivaren kan röra sig snabbare än OctoPrint hinner skicka rörelsekommandon). Om det händer kan du överväga funktionen "virtual_sdcard" (se [Konfigurationsreferens](Config_Reference.md#virtual_sdcard) för detaljer) för att skriva ut direkt från Klipper och inaktivera alla DEBUG- eller VERBOSE-loggningsalternativ som du har aktiverat.

## Bygga AVR-mikrokontrollerkod

Den här miljön innehåller allt som behövs för att bygga nödvändig mikrokontrollerkod utom AVR. AVR-paketen togs bort eftersom de står i konflikt med PRU-paketen. Om du ändå vill bygga AVR-mikrokontrollerkod i denna miljö måste du ta bort PRU-paketen och installera AVR-paketen med följande kommandon.

```
sudo apt-get remove gcc-pru
sudo apt-get install avrdude gcc-avr binutils-avr avr-libc
```

Om du behöver återställa PRU-paketen ska du först ta bort AVR-paketen.

```
sudo apt-get remove avrdude gcc-avr binutils-avr avr-libc
sudo apt-get install gcc-pru
```

## Maskinvarustiftens tilldelning

BeagleBone är mycket flexibel när det gäller stifttilldelning. Samma stift kan konfigureras för olika funktioner, men varje stift kan bara ha en funktion och samma funktion kan inte finnas på flera stift. Exempel: P9_20 - i2c2_sda/can0_tx/spi1_cs0/gpio0_12/uart1_ctsn P9_19 - i2c2_scl/can0_rx/spi1_cs1/gpio0_13/uart1_rtsn P9_24 - i2c1_scl/can1_rx/gpio0_15/uart1_tx P9_26 - i2c1_sda/can1_tx/gpio0_14/uart1_rx

Stifttilldelningen anges med särskilda "overlays" som läses in vid Linux-start. De konfigureras genom att redigera filen /boot/uEnv.txt med utökade behörigheter.

```
sudo editor /boot/uEnv.txt
```

och ange vilken funktion som ska läsas in. För att exempelvis aktivera CAN1 måste du ange dess overlay.

```
uboot_overlay_addr4=/lib/firmware/BB-CAN1-00A0.dtbo
```

Denna overlay, BB-CAN1-00A0.dtbo, konfigurerar om alla stift som krävs för CAN1 och skapar en CAN-enhet i Linux. Alla ändringar av overlays kräver omstart för att tillämpas. Om du behöver veta vilka stift som ingår i en overlay kan du analysera källfilerna i /opt/sources/bb.org-overlays/src/arm/ eller söka information i BeagleBone-forum.

## Aktivera maskinvaru-SPI

BeagleBone har vanligen flera SPI-bussar i maskinvara; BeagleBone Black kan exempelvis ha två. De kan arbeta upp till 48 MHz, men begränsas normalt till 16 MHz av kärnans enhetsträd. På BeagleBone Black är vissa SPI1-stift som standard konfigurerade för HDMI-ljudutgång. För att aktivera fyrtråds-SPI1 helt måste du inaktivera HDMI-ljud och aktivera SPI1. Redigera /boot/uEnv.txt med utökade behörigheter.

```
sudo editor /boot/uEnv.txt
```

avkommentera variabeln

```
disable_uboot_overlay_audio=1
```

avkommentera sedan följande variabel och ange den så här

```
uboot_overlay_addr4=/lib/firmware/BB-SPIDEV1-00A0.dtbo
```

Spara ändringarna i /boot/uEnv.txt och starta om kortet. SPI1 är nu aktiverat; kör följande kommando för att bekräfta att det finns.

```
ls /dev/spidev1.*
```

Observera att BeagleBone vanligtvis använder 3,3 V-logik. För SPI-enheter med 5 V krävs en nivåomvandlare, exempelvis SN74CBTD3861, SN74LVC1G34 eller motsvarande. CRAMPS-kortet innehåller redan en nivåomvandlare; SPI1-stiften blir då tillgängliga på port P503 och kan användas med 5 V-maskinvara. Se CRAMPS-kortets kopplingsschema för stiftreferenser.

## Aktivera maskinvaru-I2C

BeagleBone har vanligtvis flera I2C-bussar i maskinvara; BeagleBone Black kan exempelvis ha tre. De stöder upp till 400 kbit/s i Fast mode. Två bussar (i2c-1 och i2c-2) är normalt redan konfigurerade och tillgängliga på P9; den tredje, i2c-0, är vanligen reserverad för internt bruk. Med CRAMPS-kortet finns i2c-2 på port P303 med 3,3 V-nivå. I2c-1 på CRAMPS kan nås via stiften Extruder1.Step och Extruder1.Dir, också med 3,3 V-nivå. Se CRAMPS-kortets kopplingsschema för stiftreferenser. Relaterade overlays, se [Maskinvarustiftens tilldelning](#hardware-pin-designation): I2C1 (100 kbit): BB-I2C1-00A0.dtbo; I2C1 (400 kbit): BB-I2C1-FAST-00A0.dtbo; I2C2 (100 kbit): BB-I2C2-00A0.dtbo; I2C2 (400 kbit): BB-I2C2-FAST-00A0.dtbo.

## Aktivera maskinvaru-UART (seriell)/CAN

BeagleBone har upp till sex UART-bussar (seriella, upp till 3 Mbit) och upp till två CAN-bussar (1 Mbit) i maskinvara. UART1 (RX, TX), CAN1 (TX, RX) och I2C2 (SDA, SCL) använder samma stift, så du måste välja vad de ska användas för. UART1 (CTSN, RTSN), CAN0 (TX, RX) och I2C1 (SDA, SCL) använder också samma stift. Alla UART/CAN-stift använder 3,3 V-logik, så du behöver sändar/mottagarkretsar eller kort som SN74LVC2G241DCUR (UART), SN65HVD230 (CAN), TTL-RS485 (RS-485) eller motsvarande för att omvandla 3,3 V-signaler till lämpliga nivåer.

Relaterade overlays, se [Maskinvarustiftens tilldelning](#hardware-pin-designation): CAN0: BB-CAN0-00A0.dtbo; CAN1: BB-CAN1-00A0.dtbo; UART0: används för konsolen; UART1 (RX, TX): BB-UART1-00A0.dtbo; UART1 (RTS, CTS): BB-UART1-RTSCTS-00A0.dtbo; UART2 (RX, TX): BB-UART2-00A0.dtbo; UART3 (RX, TX): BB-UART3-00A0.dtbo; UART4 (RS-485): BB-UART4-RS485-00A0.dtbo; UART5 (RX, TX): BB-UART5-00A0.dtbo.
