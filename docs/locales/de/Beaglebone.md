# Beaglebone

Dieses Dokument beschreibt den Prozess der Ausführung von Klipper auf einer Beaglebone PRU.

## Erstellen eines Betriebssystem-Images

Beginnen Sie mit der Installation des Images [Debian 11.7 2023-09-02 4GB microSD IoT](https://beagleboard.org/latest-images). Sie können das Image entweder von einer microSD-Karte oder vom eingebauten eMMC ausführen. Wenn Sie den eMMC verwenden, installieren Sie es jetzt auf dem eMMC, indem Sie den Anweisungen unter dem obigen Link folgen.

Melden Sie sich anschließend per ssh auf dem Beaglebone-Rechner an (`ssh debian@beaglebone` -- das Passwort lautet `temppwd`).

Bevor Sie mit der Installation von Klipper beginnen, müssen Sie zusätzlichen Speicherplatz freigeben. Dafür gibt es 3 Möglichkeiten:

1. einige "Demo"-Ressourcen des BeagleBone entfernen
1. wenn Sie von einer SD-Karte gebootet haben und diese größer als 4 GB ist, können Sie das aktuelle Dateisystem auf den gesamten Speicherplatz der Karte erweitern
1. Option #1 und #2 zusammen ausführen.

Um einige "Demo"-Ressourcen des BeagleBone zu entfernen, führen Sie diese Befehle aus

```
sudo apt remove bb-node-red-installer
sudo apt remove bb-code-server
```

Um das Dateisystem auf die volle Größe Ihrer SD-Karte zu erweitern, führen Sie diesen Befehl aus; ein Neustart ist nicht erforderlich.

```
sudo growpart /dev/mmcblk0 1
sudo resize2fs /dev/mmcblk0p1
```

Installieren Sie Klipper, indem Sie die folgenden Befehle ausführen:

```
git clone https://github.com/Klipper3d/klipper.git
./klipper/scripts/install-beaglebone.sh
```

Nach der Installation von Klipper müssen Sie entscheiden, welche Art von Bereitstellung Sie benötigen. Beachten Sie dabei, dass der BeagleBone auf 3,3 V basierende Hardware ist und Sie die Pins in den meisten Fällen nicht ohne Wandlerplatinen direkt mit auf 5 V oder 12 V basierender Hardware verbinden können.

Da Klipper auf dem BeagleBone eine Multimodul-Architektur besitzt, können Sie viele verschiedene Anwendungsfälle umsetzen; die gängigsten sind die folgenden:

Anwendungsfall 1: Verwenden Sie den BeagleBone nur als Host-System, um Klipper und zusätzliche Software wie OctoPrint/Fluidd + Moonraker/... auszuführen. In dieser Konfiguration steuert er externe Mikrocontroller über serielle, USB- oder CAN-Bus-Verbindungen an.

Anwendungsfall 2: Verwenden Sie den BeagleBone mit einer Erweiterungsplatine (Cape) wie der CRAMPS-Platine. In dieser Konfiguration betreibt der BeagleBone Klipper plus zusätzliche Software und steuert die Erweiterungsplatine mit den PRU-Kernen des BeagleBone an (2 zusätzliche Kerne, 200 MHz, 32 Bit).

Anwendungsfall 3: Entspricht "Anwendungsfall 1", zusätzlich möchten Sie jedoch die GPIOs des BeagleBone mit hoher Geschwindigkeit ansteuern und dazu die PRU-Kerne nutzen, um die Haupt-CPU zu entlasten.

## Octoprint installieren

Anschließend können Sie Octoprint installieren oder diesen Abschnitt vollständig überspringen, wenn Sie andere Software bevorzugen:

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

Und richten Sie OctoPrint so ein, dass es beim Hochfahren startet:

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

Es ist notwendig, die Konfigurationsdatei **/etc/default/octoprint** von OctoPrint zu ändern. Man muss den Benutzer `OCTOPRINT_USER` auf `debian` ändern, `NICELEVEL` auf `0` setzen, die Einstellungen `BASEDIR`, `CONFIGFILE` und `DAEMON` auskommentieren (das Kommentarzeichen entfernen) und die Verweise von `/home/pi/` auf `/home/debian/` ändern:

```
sudo nano /etc/default/octoprint
```

Starten Sie dann den Octoprint-Dienst:

```
sudo systemctl start octoprint
```

Warten Sie 1-2 Minuten und stellen Sie sicher, dass der OctoPrint-Webserver erreichbar ist - er sollte unter <http://beaglebone:5000/> zu finden sein

## Den PRU-Mikrocontroller-Code des BeagleBone erstellen (PRU-Firmware)

Dieser Abschnitt ist für die oben genannten "Anwendungsfall 2" und "Anwendungsfall 3" erforderlich; für "Anwendungsfall 1" sollten Sie ihn überspringen.

Prüfen, ob die erforderlichen Geräte vorhanden sind

```
sudo beagle-version
```

Sie sollten prüfen, ob die Ausgabe das erfolgreiche Laden der "remoteproc"-Treiber sowie das Vorhandensein der PRU-Kerne enthält; in Kernel 5.10 sollten diese "remoteproc1" und "remoteproc2" heißen (4a334000.pru, 4a338000.pru). Prüfen Sie außerdem, ob viele GPIOs geladen wurden - sie sehen wie "Allocated GPIO id=0 name='P8_03'" aus. Normalerweise ist alles in Ordnung und es ist keine Hardware-Konfiguration erforderlich. Falls etwas fehlt, versuchen Sie es mit den Optionen "uboot overlays" oder mit den Cape-Overlays. Zur Orientierung hier einige Ausgaben einer funktionierenden BeagleBone-Black-Konfiguration mit CRAMPS-Platine:

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

Um den Mikrocontroller-Code von Klipper zu kompilieren, konfigurieren Sie ihn zunächst für die "Beaglebone PRU". Deaktivieren Sie für das "BeagleBone Black" zusätzlich die Optionen "Support GPIO Bit-banging devices" und "Support LCD devices" innerhalb der "Optional features", da diese nicht in die 8 KB große PRU-Firmware passen; beenden Sie dann die Konfiguration und speichern Sie sie:

```
cd ~/klipper/
make menuconfig
```

Um den neuen PRU-Mikrocontroller-Code zu erstellen und zu installieren, führen Sie aus:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Nach Ausführung der vorherigen Befehle sollte Ihre PRU-Firmware bereit und gestartet sein. Um zu prüfen, ob alles in Ordnung ist, können Sie folgenden Befehl ausführen

```
dmesg
```

und die letzten Meldungen mit einem Beispiel vergleichen, das anzeigt, dass alles korrekt gestartet wurde:

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

Merken Sie sich "/dev/rpmsg_pru30" - dies wird Ihr künftiges serielles Gerät für die Konfiguration des Haupt-MCU. Dieses Gerät muss vorhanden sein - fehlt es, sind Ihre PRU-Kerne nicht korrekt gestartet.

## Erstellen und Installieren des Linux-Host-Mikrocontroller-Codes

Dieser Abschnitt ist für "Anwendungsfall 2" erforderlich und für den oben genannten "Anwendungsfall 3" optional

Außerdem ist es notwendig, den Mikrocontroller-Code für einen Linux-Host-Prozess zu kompilieren und zu installieren. Konfigurieren Sie ihn ein zweites Mal für einen "Linux process":

```
make menuconfig
```

Installieren Sie anschließend auch diesen Mikrokontroller Code:

```
sudo service klipper stop
make flash
sudo service klipper start
```

Merken Sie sich "/tmp/klipper_host_mcu" - dies wird Ihr künftiges serielles Gerät für den "MCU Host". Existiert diese Datei nicht, prüfen Sie die Datei "scripts/klipper-mcu.service", die durch die vorherigen Befehle installiert wurde und dafür zuständig ist.

Für "Anwendungsfall 2" beachten Sie Folgendes: Bei der Definition der Druckerkonfiguration sollten Sie stets Temperatursensoren des "MCU Host" verwenden, da im Standard-"MCU" (PRU-Kerne) keine ADCs vorhanden sind. Eine Beispielkonfiguration von "sensor_pin" für Extruder und beheiztes Bett finden Sie in "generic-cramps.cfg". Sie können auch jeden anderen GPIO direkt vom "MCU Host" verwenden, indem Sie ihn auf diese Weise referenzieren: "host:gpiochip1/gpio17" - dies sollte jedoch vermieden werden, da dadurch zusätzliche Last auf der Haupt-CPU entsteht und Sie diese höchstwahrscheinlich nicht zur Schrittmotorsteuerung verwenden können.

## Restliche Konfiguration

Schließen Sie die Installation ab, indem Sie Klipper gemäß den Anweisungen im Hauptdokument [Installation](Installation.md#configuring-octoprint-to-use-klipper) konfigurieren.

## Drucken auf einem Beaglebone

Leider kann der Beaglebone-Prozessor manchmal Schwierigkeiten haben, OctoPrint zuverlässig auszuführen. Bei komplexen Drucken ist es bekannt, dass es zu Druckstockungen kommen kann (der Drucker bewegt sich unter Umständen schneller, als OctoPrint Bewegungsbefehle senden kann). Erwägen Sie in diesem Fall die Verwendung der Funktion "virtual_sdcard" (Details siehe [Konfigurationsreferenz](Config_Reference.md#virtual_sdcard)), um direkt von Klipper aus zu drucken, und deaktivieren Sie etwaige DEBUG- oder VERBOSE-Protokollierungsoptionen, falls diese aktiviert waren.

## Erstellen des AVR-Mikrocontroller-Codes

Diese Umgebung enthält alles, was zum Erstellen des notwendigen Mikrocontroller-Codes benötigt wird, mit Ausnahme von AVR - AVR-Pakete wurden aufgrund eines Konflikts mit PRU-Paketen entfernt. Wenn Sie in dieser Umgebung dennoch AVR-Mikrocontroller-Code erstellen möchten, müssen Sie die PRU-Pakete entfernen und die AVR-Pakete durch Ausführen folgender Befehle installieren

```
sudo apt-get remove gcc-pru
sudo apt-get install avrdude gcc-avr binutils-avr avr-libc
```

Falls Sie später die PRU-Pakete wiederherstellen müssen, entfernen Sie zuvor die AVR-Pakete

```
sudo apt-get remove avrdude gcc-avr binutils-avr avr-libc
sudo apt-get install gcc-pru
```

## Zuordnung der Hardware-Pins

BeagleBone ist bei der Pin-Zuordnung sehr flexibel; derselbe Pin kann für unterschiedliche Funktionen konfiguriert werden, jedoch immer nur eine Funktion pro Pin, während dieselbe Funktion auf verschiedenen Pins verfügbar sein kann. Sie können also nicht mehrere Funktionen auf einem einzelnen Pin oder dieselbe Funktion auf mehreren Pins gleichzeitig nutzen. Beispiel: P9_20 - i2c2_sda/can0_tx/spi1_cs0/gpio0_12/uart1_ctsn P9_19 - i2c2_scl/can0_rx/spi1_cs1/gpio0_13/uart1_rtsn P9_24 - i2c1_scl/can1_rx/gpio0_15/uart1_tx P9_26 - i2c1_sda/can1_tx/gpio0_14/uart1_rx

Die Pin-Zuordnung wird über spezielle "Overlays" festgelegt, die beim Linux-Boot geladen werden. Sie werden konfiguriert, indem die Datei /boot/uEnv.txt mit erhöhten Rechten bearbeitet wird

```
sudo editor /boot/uEnv.txt
```

und festgelegt wird, welche Funktionalität geladen werden soll - um beispielsweise CAN1 zu aktivieren, müssen Sie das entsprechende Overlay definieren

```
uboot_overlay_addr4=/lib/firmware/BB-CAN1-00A0.dtbo
```

Dieses Overlay BB-CAN1-00A0.dtbo konfiguriert alle benötigten Pins für CAN1 neu und erstellt das CAN-Gerät unter Linux. Jede Änderung an Overlays erfordert einen Systemneustart, damit sie wirksam wird. Wenn Sie herausfinden müssen, welche Pins in einem bestimmten Overlay verwendet werden, können Sie die Quelldateien unter /opt/sources/bb.org-overlays/src/arm/ analysieren oder in den BeagleBone-Foren nach Informationen suchen.

## Hardware-SPI aktivieren

BeagleBone verfügt üblicherweise über mehrere Hardware-SPI-Busse - BeagleBone Black kann zum Beispiel über 2 davon verfügen. Sie können mit bis zu 48 MHz arbeiten, sind jedoch üblicherweise durch den Kernel-Device-Tree auf 16 MHz begrenzt. Standardmäßig sind bei BeagleBone Black einige SPI1-Pins für die HDMI-Audio-Ausgabe konfiguriert. Um 4-Draht-SPI1 vollständig zu aktivieren, müssen Sie HDMI-Audio deaktivieren und SPI1 aktivieren. Bearbeiten Sie dazu die Datei /boot/uEnv.txt mit erhöhten Rechten

```
sudo editor /boot/uEnv.txt
```

Kommentieren Sie die Variable aus

```
disable_uboot_overlay_audio=1
```

kommentieren Sie als Nächstes die Variable aus und definieren Sie sie wie folgt

```
uboot_overlay_addr4=/lib/firmware/BB-SPIDEV1-00A0.dtbo
```

Speichern Sie die Änderungen in /boot/uEnv.txt und starten Sie die Platine neu. Nun ist SPI1 aktiviert; führen Sie zur Überprüfung folgenden Befehl aus

```
ls /dev/spidev1.*
```

Beachten Sie, dass BeagleBone üblicherweise auf 3,3V-Hardware basiert und Sie zur Verwendung von 5V-SPI-Geräten einen Pegelwandler-Chip benötigen, zum Beispiel SN74CBTD3861, SN74LVC1G34 oder ähnlich. Wenn Sie ein CRAMPS-Board verwenden, enthält dieses bereits einen Pegelwandler-Chip, und die SPI1-Pins stehen dann am P503-Anschluss zur Verfügung und akzeptieren 5V-Hardware - Pin-Referenzen finden Sie im Schaltplan des CRAMPS-Boards.

## Hardware-I2C aktivieren

BeagleBone verfügt üblicherweise über mehrere Hardware-I2C-Busse - BeagleBone Black kann zum Beispiel über 3 davon verfügen, die einen Fast-Mode mit bis zu 400 kbit unterstützen. Standardmäßig sind bei BeagleBone Black zwei davon (i2c-1 und i2c-2) üblicherweise bereits konfiguriert und an P9 verfügbar; das dritte, i2c-0, ist üblicherweise für den internen Gebrauch reserviert. Wenn Sie ein CRAMPS-Board verwenden, ist i2c-2 am P303-Anschluss mit 3,3V-Pegel verfügbar. Wenn Sie i2c-1 beim CRAMPS-Board nutzen möchten, finden Sie es an den Pins Extruder1.Step und Extruder1.Dir, die ebenfalls auf 3,3V basieren - Pin-Referenzen finden Sie im Schaltplan des CRAMPS-Boards. Zugehörige Overlays für die [Zuordnung der Hardware-Pins](#hardware-pin-designation): I2C1(100 kbit): BB-I2C1-00A0.dtbo I2C1(400 kbit): BB-I2C1-FAST-00A0.dtbo I2C2(100 kbit): BB-I2C2-00A0.dtbo I2C2(400 kbit): BB-I2C2-FAST-00A0.dtbo

## Hardware-UART (Seriell)/CAN aktivieren

BeagleBone verfügt über bis zu 6 Hardware-UART (Seriell)-Busse (bis zu 3 MBit) und bis zu 2 Hardware-CAN (1 MBit)-Busse. UART1(RX,TX) und CAN1(TX,RX) sowie I2C2(SDA,SCL) verwenden dieselben Pins - Sie müssen sich also entscheiden, welche Funktion genutzt wird. UART1(CTSN,RTSN), CAN0(TX,RX) und I2C1(SDA,SCL) verwenden ebenfalls dieselben Pins - auch hier müssen Sie sich entscheiden. Alle UART-/CAN-bezogenen Pins basieren auf 3,3V, daher benötigen Sie Transceiver-Chips/-Boards wie SN74LVC2G241DCUR (für UART), SN65HVD230 (für CAN), TTL-RS485 (für RS-485) oder Ähnliches, um 3,3V-Signale in die passenden Pegel umzuwandeln.

Zugehörige Overlays für die [Zuordnung der Hardware-Pins](#hardware-pin-designation) CAN0: BB-CAN0-00A0.dtbo CAN1: BB-CAN1-00A0.dtbo UART0: - wird für die Konsole verwendet UART1(RX,TX): BB-UART1-00A0.dtbo UART1(RTS,CTS): BB-UART1-RTSCTS-00A0.dtbo UART2(RX,TX): BB-UART2-00A0.dtbo UART3(RX,TX): BB-UART3-00A0.dtbo UART4(RS-485): BB-UART4-RS485-00A0.dtbo UART5(RX,TX): BB-UART5-00A0.dtbo
