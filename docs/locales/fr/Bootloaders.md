# Chargeurs de démarrage

Ce document fournit des informations sur les "chargeurs de démarrage" ou "Bootloaders" courants trouvés sur les microcontrôleurs pris en charge par Klipper.

Le chargeur de démarrage est un logiciel tiers qui s'exécute sur le microcontrôleur lors de sa première mise sous tension. Il est généralement utilisé pour flasher une nouvelle application (par exemple, Klipper) sur le microcontrôleur sans nécessiter de matériel spécialisé. Malheureusement, il n'existe pas de norme à l'échelle de l'industrie pour flasher un microcontrôleur, ni de chargeur de démarrage standard qui fonctionne sur tous les microcontrôleurs. Pire encore, il est courant que chaque chargeur de démarrage nécessite un ensemble d'étapes différent pour flasher une application.

Si l'on peut flasher un chargeur de démarrage sur un microcontrôleur, on peut généralement également utiliser ce mécanisme pour flasher une application, mais il faut faire attention en faisant cela car on peut supprimer le chargeur de démarrage par inadvertance. En revanche, un chargeur de démarrage permettra généralement à un utilisateur de flasher une application. Il est donc recommandé d'utiliser le chargeur de démarrage pour flasher une application lorsque cela est possible.

Ce document tente de décrire les chargeurs de démarrage courants, les étapes nécessaires pour flasher un chargeur de démarrage et les étapes nécessaires pour flasher une application. Ce document n'est pas une référence faisant autorité ; il est conçu comme une collection d'informations utiles que les développeurs de Klipper ont accumulées.

## Micro-contrôleurs AVR

De manière générale, le projet Arduino est une bonne référence pour les chargeurs de démarrage et les procédures de flashage sur les microcontrôleurs Atmel Atmega 8 bits. En particulier, le fichier "boards.txt" : <https://github.com/arduino/Arduino/blob/1.8.5/hardware/arduino/avr/boards.txt> est une référence utile.

Pour flasher le chargeur de démarrage, les puces AVR nécessitent un outil de flashage matériel externe (qui communique avec la puce à l'aide de SPI). Cet outil peut être acheté (par exemple, effectuez une recherche sur le Web pour "avr isp", "arduino isp" ou "usb tiny isp"). Il est également possible d'utiliser un autre Arduino ou Raspberry Pi pour flasher un chargeur de démarrage AVR (par exemple, faites une recherche sur le Web pour "programmer un avr à l'aide de raspberry pi"). Les exemples ci-dessous sont écrits en supposant qu'un appareil de type "AVR ISP Mk2" est utilisé.

Le logiciel "avrdude" est l'outil le plus utilisé pour flasher les puces atmega (à la fois pour flasher le chargeur de démarrage et l'application).

### Atmega2560

Cette puce se trouve généralement dans les "Arduino Mega" qui sont très courante parmi les cartes d'imprimante 3d.

Pour flasher le chargeur de démarrage lui-même, utilisez quelque chose comme :

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/stk500v2/stk500boot_v2_mega2560.hex'

avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xD8:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U flash:w:stk500boot_v2_mega2560.hex
avrdude -cavrispv2 -patmega2560 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Pour flasher une application, utilisez quelque chose comme :

```
avrdude -cwiring -patmega2560 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1280

Cette puce se trouve généralement dans les anciennes versions de "l'Arduino Mega".

Pour flasher le chargeur de démarrage lui-même, utilisez quelque chose comme :

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega1280.hex'

avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xF5:m -U hfuse:w:0xDA:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U flash:w:ATmegaBOOT_168_atmega1280.hex
avrdude -cavrispv2 -patmega1280 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Pour flasher une application, utilisez quelque chose comme :

```
avrdude -carduino -patmega1280 -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### Atmega1284p

Cette puce se trouve couramment dans les cartes d'imprimante 3d de style "Melzi".

Pour flasher le chargeur de démarrage lui-même, utilisez quelque chose comme :

```
wget 'https://github.com/Lauszus/Sanguino/raw/1.0.2/bootloaders/optiboot/optiboot_atmega1284p.hex'

avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0xFD:m -U hfuse:w:0xDE:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega1284p.hex
avrdude -cavrispv2 -patmega1284p -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Pour flasher une application, utilisez quelque chose comme :

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

Notez qu'un certain nombre de cartes de style "Melzi" sont préinstallées avec un chargeur de démarrage qui utilise un débit de 57600 bauds. Dans ce cas, pour flasher une application, utilisez plutôt quelque chose comme ceci :

```
avrdude -carduino -patmega1284p -P/dev/ttyACM0 -b57600 -D -Uflash:w:out/klipper.elf.hex:i
```

### At90usb1286

Ce document ne couvre pas la méthode pour flasher un chargeur de démarrage sur l'At90usb1286 ni le flashage général des applications sur cet appareil.

L'appareil Teensy++ de pjrc.com est livré avec un chargeur de démarrage propriétaire. Il nécessite un outil de flash personnalisé de <https://github.com/PaulStoffregen/teensy_loader_cli>. On peut flasher une application avec en utilisant quelque chose comme :

```
teensy_loader_cli --mcu=at90usb1286 out/klipper.elf.hex -v
```

### Atmega168

L'atmega168 a un espace flash limité. Si vous utilisez un chargeur de démarrage, il est recommandé d'utiliser le chargeur de démarrage Optiboot. Pour flasher ce chargeur de démarrage, utilisez quelque chose comme :

```
wget 'https://github.com/arduino/Arduino/raw/1.8.5/hardware/arduino/avr/bootloaders/optiboot/optiboot_atmega168.hex'

avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -e -u -U lock:w:0x3F:m -U efuse:w:0x04:m -U hfuse:w:0xDD:m -U lfuse:w:0xFF:m
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U flash:w:optiboot_atmega168.hex
avrdude -cavrispv2 -patmega168 -P/dev/ttyACM0 -b115200 -U lock:w:0x0F:m
```

Pour flasher une application via le chargeur de démarrage Optiboot, utilisez quelque chose comme :

```
avrdude -carduino -patmega168 -P/dev/ttyACM0 -b115200 -D -Uflash:w:out/klipper.elf.hex:i
```

## Micro-contrôleurs SAM3 (Arduino Due)

Il n'est pas courant d'utiliser un chargeur de démarrage avec le mcu SAM3. La puce elle-même possède une ROM qui permet de programmer le flash à partir du port série 3,3 V ou de l'USB.

Pour activer la ROM, la broche "effacement" est maintenue haute pendant une réinitialisation, ce qui efface le contenu flash et provoque l'exécution de la ROM. Sur un Arduino Due, cette séquence peut être accomplie en définissant un débit en bauds de 1200 sur le "port usb de programmation" (le port USB le plus proche de l'alimentation).

Le code sur <https://github.com/shumatech/BOSSA> peut être utilisé pour programmer le SAM3. Il est recommandé d'utiliser la version 1.9 ou ultérieure.

Pour flasher une application, utilisez quelque chose comme :

```
bossac -U -p /dev/ttyACM0 -a -e -w out/klipper.bin -v -b
bossac -U -p /dev/ttyACM0 -R
```

## Micro-contrôleurs SAM4 (Duet Wifi)

Il n'est pas courant d'utiliser un bootloader avec le mcu SAM4. La puce elle-même possède une ROM qui permet de programmer le flash à partir du port série 3,3 V ou de l'USB.

Pour activer la ROM, la broche "effacement" est maintenue haute pendant une réinitialisation, ce qui efface le contenu flash et provoque l'exécution de la ROM.

Le code sur <https://github.com/shumatech/BOSSA> peut être utilisé pour programmer le SAM4. Il est nécessaire d'utiliser la version `1.8.0` ou supérieure.

Pour flasher une application, utilisez quelque chose comme :

```
bossac --port=/dev/ttyACM0 -b -U -e -w -v -R out/klipper.bin
```

## Micro-contrôleurs SAMD21 (Arduino Zero)

Le chargeur de démarrage SAMD21 est flashé via l'interface ARM Serial Wire Debug (SWD). Cela se fait généralement avec un dongle matériel SWD dédié. Alternativement, on peut utiliser un [Raspberry Pi avec OpenOCD](#running-openocd-on-the-raspberry-pi).

Pour flasher un chargeur de démarrage avec OpenOCD, utilisez la configuration de puce suivante :

```
source [find target/at91samdXX.cfg]
```

Procurez-vous un bootloader - par exemple :

```
wget 'https://github.com/arduino/ArduinoCore-samd/raw/1.8.3/bootloaders/zero/samd21_sam_ba.bin'
```

Flashez avec des commandes OpenOCD similaires à :

```
at91samd bootloader 0
program samd21_sam_ba.bin verify
```

Le chargeur de démarrage le plus courant sur le SAMD21 est celui que l'on trouve sur le "Arduino Zero". Il utilise un chargeur de démarrage de 8 Ko (l'application doit être compilée avec une adresse de démarrage de 8 Ko). On peut entrer dans ce chargeur de démarrage en double-cliquant sur le bouton de réinitialisation. Pour flasher une application, utilisez quelque chose comme :

```
bossac -U -p /dev/ttyACM0 --offset=0x2000 -w out/klipper.bin -v -b -R
```

En revanche, "l'Arduino M0" utilise un bootloader de 16KiB (l'application doit être compilée avec une adresse de démarrage de 16KiB). Pour flasher une application sur ce chargeur de démarrage, réinitialisez le microcontrôleur et exécutez la commande flash dans les premières secondes du démarrage - quelque chose comme :

```
avrdude -c stk500v2 -p atmega2560 -P /dev/ttyACM0 -u -Uflash:w:out/klipper.elf.hex:i
```

## Micro-contrôleurs SAMD51 (Adafruit Metro-M4 et similaires)

Comme le SAMD21, le chargeur de démarrage SAMD51 est flashé via l'interface ARM Serial Wire Debug (SWD). Pour flasher un chargeur de démarrage avec [OpenOCD sur un Raspberry Pi](#running-openocd-on-the-raspberry-pi) utilisez la configuration de puce suivante :

```
source [find target/atsame5x.cfg]
```

Obtenir un Chargeur de Démarrage - De nombreux Chargeurs de démarrage sont disponibles sur <https://github.com/adafruit/uf2-samdx1/releases/latest>. Par exemple :

```
wget 'https://github.com/adafruit/uf2-samdx1/releases/download/v3.7.0/bootloader-itsybitsy_m4-v3.7.0.bin'
```

Flashez avec des commandes OpenOCD similaires à :

```
at91samd bootloader 0
program bootloader-itsybitsy_m4-v3.7.0.bin verify
at91samd bootloader 16384
```

Le SAMD51 utilise un chargeur de démarrage de 16 Ko (l'application doit être compilée avec une adresse de démarrage de 16 Ko). Pour flasher une application, utilisez quelque chose comme :

```
bossac -U -p /dev/ttyACM0 --offset=0x4000 -w out/klipper.bin -v -b -R
```

## Microcontrôleurs STM32F103 (dispositifs Blue Pill)

Les appareils STM32F103 ont une ROM qui peut flasher un chargeur de démarrage ou une application via un port série 3,3 V. En règle générale, on câblerait les broches PA10 (MCU Rx) et PA9 (MCU Tx) à un adaptateur UART 3,3 V. Pour accéder à la ROM, il faut connecter la broche "boot 0" au niveau haut et la broche "boot 1" au niveau bas, puis réinitialiser l'appareil. Le package "stm32flash" peut ensuite être utilisé pour flasher l'appareil en utilisant quelque chose comme :

```
stm32flash -w out/klipper.bin -v -g 0 /dev/ttyAMA0
```

Notez que si l'on utilise un Raspberry Pi pour le port série 3.3V, le protocole stm32flash utilise un mode de parité série que le "mini UART" du Raspberry Pi ne prend pas en charge. Voir <https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts> pour plus de détails sur l'activation de l'uart complet sur les broches GPIO du Raspberry Pi.

Après avoir flashé, réglez à la fois "boot 0" et "boot 1" sur bas afin que les futures réinitialisations démarrent à partir du flash.

### STM32F103 avec chargeur de démarrage stm32duino

Le projet "stm32duino" a un chargeur de démarrage compatible USB - voir : <https://github.com/rogerclarkmelbourne/STM32duino-bootloader>

Ce chargeur de démarrage peut être flashé via un port série 3,3 V avec quelque chose comme :

```
wget 'https://github.com/rogerclarkmelbourne/STM32duino-bootloader/raw/master/binaries/generic_boot20_pc13.bin'

stm32flash -w generic_boot20_pc13.bin -v -g 0 /dev/ttyAMA0
```

Ce chargeur de démarrage utilise 8 Ko d'espace flash (l'application doit être compilée avec une adresse de démarrage de 8 Ko). Flashez une application avec quelque chose comme :

```
dfu-util -d 1eaf:0003 -a 2 -R -D out/klipper.bin
```

Le chargeur de démarrage ne s'exécute généralement que pendant une courte période après le démarrage. Il peut être nécessaire de chronométrer la commande ci-dessus pour qu'elle s'exécute pendant que le chargeur de démarrage est toujours actif (le chargeur de démarrage fait clignoter une LED de la carte pendant son exécution). Vous pouvez également définir la broche "boot 0" sur low et la broche "boot 1" sur high pour rester en mode chargeur de démarrage après une réinitialisation.

### STM32F103 avec chargeur de démarrage HID

Le [chargeur de démarrage HID](https://github.com/Serasidis/STM32_HID_Bootloader) est un chargeur de démarrage compact et sans pilote capable de flasher via USB. Un [fork avec des builds spécifiques au SKR Mini E3 1.2](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest) est également disponible.

Pour les cartes STM32F103 génériques telles que la blue pill, il est possible de flasher le chargeur de démarrage via un port série 3.3v en utilisant stm32flash comme indiqué dans la section stm32duino ci-dessus, en remplaçant le nom de fichier par le binaire du chargeur de démarrage souhaité (c'est-à-dire : hid_generic_pc13.bin pour la blue pill).

Il n'est pas possible d'utiliser stm32flash pour le SKR Mini E3 car la broche boot0 est directement liée à la terre et non connectée via des broches d'en-tête. Il est recommandé d'utiliser un STLink V2 avec le programmeur STM32Cube pour flasher le bootloader. Si vous n'avez pas accès à un STLink, il est également possible d'utiliser un [Raspberry Pi et OpenOCD](#running-openocd-on-the-raspberry-pi) avec la configuration de puce suivante :

```
source [find target/stm32f1x.cfg]
```

Si vous le souhaitez, vous pouvez faire une sauvegarde du flash actuel avec la commande suivante. Notez que cela peut prendre un certain temps :

```
flash read_bank 0 btt_skr_mini_e3_backup.bin
```

vous pouvez flasher avec des commandes similaires à :

```
stm32f1x mass_erase 0
program hid_btt_skr_mini_e3.bin verify 0x08000000
```

NOTES :

- L'exemple ci-dessus efface la puce puis programme le bootloader. Quelle que soit la méthode choisie pour flasher, il est recommandé d'effacer la puce avant de flasher.
- Avant de flasher le SKR Mini E3 avec ce chargeur de démarrage, vous devez savoir que vous ne pourrez plus mettre à jour le firmware via la carte SD.
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
Après quoi, vous pouvez relâcher le bouton de réinitialisation.

Ce chargeur de démarrage nécessite 2 Ko d'espace flash (l'application doit être compilée avec une adresse de démarrage de 2 Ko).

Le programme hid-flash est utilisé pour télécharger un binaire sur le bootloader. Vous pouvez installer ce logiciel avec les commandes suivantes :

```
sudo apt install libusb-1.0
cd ~/klipper/lib/hidflash
make
```

Si le chargeur de démarrage est en cours d'exécution, vous pouvez flasher avec quelque chose comme :

```
~/klipper/lib/hidflash/hid-flash ~/klipper/out/klipper.bin
```

Vous pouvez aussi utiliser `make flash` pour flasher directement klipper :

```
make flash FLASH_DEVICE=1209:BEBA
```

OU si klipper a déjà été flashé :

```
make flash FLASH_DEVICE=/dev/ttyACM0
```

Il peut être nécessaire d'entrer manuellement dans le chargeur de démarrage, cela peut être fait en définissant "boot 0" au niveau bas et "boot 1" au niveau haut. Sur le SKR Mini E3 "Boot 1" n'est pas disponible, vous pouvez donc le faire en mettant la broche PA2 au niveau bas si vous avez flashé "hid_btt_skr_mini_e3.bin". Cette broche est étiquetée "TX0" sur l'en-tête TFT dans le document "PIN" du SKR Mini E3. Il y a une broche de terre à côté de PA2 que vous pouvez utiliser pour mettre PA2 à 0.

### STM32F103/STM32F072 avec chargeur de démarrage MSC

Le [chargeur de démarrage MSC](https://github.com/Telekatz/MSC-stm32f103-bootloader) est un chargeur de démarrage sans pilote capable de flasher via USB.

Il est possible de flasher le chargeur de démarrage via un port série 3.3v en utilisant stm32flash comme indiqué dans la section stm32duino ci-dessus, en remplaçant le nom de fichier par le binaire du chargeur de démarrage MSC souhaité (c'est-à-dire : MSCboot-Bluepill.bin pour la blue pill).

Pour les cartes STM32F072, il est également possible de flasher le bootloader via USB (via DFU) avec quelque chose comme :

```
 dfu-util -d 0483:df11 -a 0 -R -D  MSCboot-STM32F072.bin -s0x08000000:leave
```

Ce chargeur de démarrage utilise 8 Ko ou 16 Ko d'espace flash, voir la description du chargeur de démarrage (l'application doit être compilée avec l'adresse de démarrage correspondante).

Le chargeur de démarrage peut être activé en appuyant deux fois sur le bouton de réinitialisation de la carte. Dès que le chargeur de démarrage est activé, la carte apparaît comme une clé USB sur laquelle le fichier klipper.bin peut être copié.

### STM32F103/STM32F0x2 avec chargeur de démarrage CanBoot

Le chargeur de démarrage [CanBoot](https://github.com/Arksine/CanBoot) offre une option pour télécharger le micrologiciel Klipper via le CANBUS. Le chargeur de démarrage lui-même est dérivé du code source de Klipper. Actuellement, CanBoot prend en charge les modèles STM32F103, STM32F042 et STM32F072.

Il est recommandé d'utiliser un programmeur ST-Link pour flasher CanBoot, mais il devrait être possible de flasher en utilisant `stm32flash` sur les appareils STM32F103 et `dfu-util` sur les appareils STM32F042/STM32F072. Consultez les sections précédentes de ce document pour obtenir des instructions sur ces méthodes de flash, en remplaçant `canboot.bin` par le nom de fichier, le cas échéant. Le lien CanBoot ci-dessus fournit des instructions pour créer le chargeur de démarrage.

La première fois que CanBoot a été flashé, il devrait détecter qu'aucune application n'est présente et entrer dans le chargeur de démarrage. Si cela ne se produit pas, il est possible d'entrer dans le chargeur de démarrage en appuyant deux fois de suite sur le bouton de réinitialisation.

L'utilitaire `flash_can.py` fourni dans le dossier `lib/canboot` peut être utilisé pour télécharger le firmware Klipper. L'UUID de l'appareil doit clignoter. Si vous n'avez pas d'UUID, il est possible d'interroger les nœuds exécutant actuellement le chargeur de démarrage :

```
python3 flash_can.py -q
```

Cela renverra les UUID pour tous les nœuds connectés et qui n'avaient pas d'UUID attribué. Cela devrait inclure tous les nœuds actuellement dans le chargeur de démarrage.

Une fois que vous avez un UUID, vous pouvez télécharger le firmware avec la commande suivante :

```
python3 flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u aabbccddeeff
```

Où `aabbccddeeff` est remplacé par votre UUID. Notez que les options `-i` et `-f` peuvent être omises, elles sont par défaut sur `can0` et `~/klipper/out/klipper.bin`.

Lors de la création de Klipper pour une utilisation avec CanBoot, sélectionnez l'option 8 KiB Bootloader.

## Micro-contrôleurs STM32F4 (SKR Pro 1.1)

Les microcontrôleurs STM32F4 sont équipés d'un chargeur de démarrage système intégré capable de flasher via USB (via DFU), série 3,3 V et diverses autres méthodes (voir le document STM AN2606 pour plus d'informations). Certaines cartes STM32F4, telles que le SKR Pro 1.1, ne peuvent pas entrer dans le chargeur de démarrage DFU. Le chargeur de démarrage HID est disponible pour les cartes basées sur STM32F405/407 si l'utilisateur préfère flasher sur USB plutôt que d'utiliser la carte SD. Notez que vous devrez peut-être configurer et construire une version spécifique à votre carte, une [version pour le SKR Pro 1.1 est disponible ici](https://github.com/Arksine/STM32_HID_Bootloader/releases/latest).

À moins que votre carte ne soit compatible DFU, la méthode de flash la plus accessible est probablement via un port série 3.3v, qui suit la même procédure que [flasher le STM32F103 avec stm32flash](#stm32f103-micro-controllers-blue-pill-devices). Par exemple :

```
wget https://github.com/Arksine/STM32_HID_Bootloader/releases/download/v0.5-beta/hid_bootloader_SKR_PRO.bin

stm32flash -w hid_bootloader_SKR_PRO.bin -v -g 0 /dev/ttyAMA0
```

Ce chargeur de démarrage nécessite 16 Ko d'espace flash sur le STM32F4 (l'application doit être compilée avec une adresse de démarrage de 16 Ko).

Comme avec le STM32F1, le STM32F4 utilise l'outil hid-flash pour télécharger des fichiers binaires sur le MCU. Voir les instructions ci-dessus pour plus de détails sur la façon de construire et d'utiliser hid-flash.

Il peut être nécessaire d'entrer manuellement dans le chargeur de démarrage, cela peut être fait en définissant "boot 0" au niveau bas, "boot 1" au niveau haut et en branchant l'appareil. Une fois la programmation terminée, débranchez l'appareil et re-réglez "boot 1" au niveau bas pour que l'application soit chargée.

## Micro-contrôleurs LPC176x (Smoothieboards)

Ce document ne décrit pas la méthode pour flasher le Chargeur de démarrage lui-même - voir : <http://smoothieware.org/flashing-the-bootloader> pour plus d'informations sur ce sujet.

Il est courant que les Smoothieboards soient livrés avec un chargeur de démarrage de : <https://github.com/triffid/LPC17xx-DFU-Bootloader>. Lors de l'utilisation de ce chargeur de démarrage, l'application doit être compilée avec une adresse de démarrage de 16 Ko. Le moyen le plus simple de flasher une application avec ce chargeur de démarrage est de copier le fichier d'application (par exemple, `out/klipper.bin`) dans un fichier nommé `firmware.bin` sur une carte SD, et puis de redémarrer le microcontrôleur avec cette carte SD.

## Exécuter OpenOCD sur le Raspberry PI

OpenOCD est un logiciel qui peut effectuer un flashage et un débogage de puce de bas niveau. Il peut utiliser les broches GPIO d'un Raspberry Pi pour communiquer avec une variété de puces ARM.

Cette section décrit comment installer et lancer OpenOCD. Elle dérive des instructions disponibles sur : <https://learn.adafruit.com/programming-microcontrollers-using-openocd-on-raspberry-pi>

Commencez par télécharger et compiler le logiciel (chaque étape peut prendre plusieurs minutes et l'étape "make" peut prendre plus de 30 minutes) :

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

### Configurer OpenOCD

Créez un fichier de configuration OpenOCD :

```
nano ~/openocd/openocd.cfg
```

Utilisez une configuration similaire à la suivante :

```
# Utilise les pins du RPI: GPIO25 pour SWDCLK, GPIO24 pour SWDIO, GPIO18 pour nRST
source [find interface/raspberrypi2-native.cfg]
bcm2835gpio_swd_nums 25 24
bcm2835gpio_srst_num 18
transport select swd

# Utilise le reset câblé pour la raz de la puce
reset_config srst_only
adapter_nsrst_delay 100
adapter_nsrst_assert_width 100

# Specification du type de puce
source [find target/atsame5x.cfg]

# Définir la vitesse de l'adaptateur
adapter_khz 40

# Connexion à la puce
init
targets
reset halt
```

### Câblez le Raspberry Pi sur la puce cible

Éteignez à la fois le Raspberry Pi et la puce cible avant le câblage ! Vérifiez que la puce cible utilise bien du 3,3 V avant de la connecter au Raspberry Pi !

Connectez GND, SWDCLK, SWDIO et RST sur la puce cible à GND, GPIO25, GPIO24 et GPIO18 sur le Raspberry Pi.

Mettez ensuite le Raspberry Pi sous tension et alimentez la puce cible.

### Exécutez OpenOCD

Exécutez OpenOCD :

```
cd ~/openocd/
sudo ~/openocd/install/bin/openocd -f ~/openocd/openocd.cfg
```

Ce qui précède devrait amener OpenOCD à émettre des messages texte, puis à attendre (il ne doit pas immédiatement revenir à l'invite du shell). Si OpenOCD se ferme tout seul ou s'il continue à émettre des messages texte, vérifiez à nouveau le câblage.

Une fois OpenOCD en cours d'exécution et stable, on peut lui envoyer des commandes via telnet. Ouvrez une autre session SSH et exécutez ce qui suit :

```
telnet 127.0.0.1 4444
```

(Vous pouvez quitter telnet en appuyant sur ctrl+] puis en exécutant la commande "quit".)

### OpenOCD et gdb

Il est possible d'utiliser OpenOCD avec gdb pour déboguer Klipper. Les commandes suivantes supposent que l'on exécute gdb sur une machine de bureau.

Ajoutez ce qui suit au fichier de configuration OpenOCD :

```
bindto 0.0.0.0
gdb_port 44444
```

Redémarrez OpenOCD sur le Raspberry Pi, puis exécutez la commande Unix suivante sur la machine de bureau :

```
cd /path/to/klipper/
gdb out/klipper.elf
```

Dans gdb, exécutez :

```
target remote octopi:44444
```

(Remplacez "octopi" par le nom d'hôte du Raspberry Pi.) Une fois que gdb est en cours d'exécution, il est possible de définir des points d'arrêt et d'inspecter les registres.
