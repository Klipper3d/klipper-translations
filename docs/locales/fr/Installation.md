# Installation

These instructions assume the software will run on a Linux-based host running a Klipper-compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian-based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions, host relates to the Linux device and mcu relates to the printer board. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## Obtenir un fichier de configuration de Klipper

Most Klipper settings are determined by a "printer configuration file" printer.cfg, that will be stored on the host. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

S'il n'y a pas de fichier de configuration d'imprimante approprié dans le répertoire des configurations de Klipper, essayez de rechercher le site Web du fabricant de l'imprimante pour voir s'il y a un fichier de configuration Klipper approprié.

Si aucun fichier de configuration pour l'imprimante ne peut être trouvé, mais que le type de carte de contrôle de l'imprimante est connu, recherchez un [fichier de configuration](../config/) approprié commençant par un préfixe "generic-". Ces exemples de fichiers de carte d'imprimante devraient permettre de réaliser avec succès l'installation initiale, mais nécessiteront une personnalisation afin d'obtenir la fonctionnalité complète de l'imprimante.

Il est également possible de définir une nouvelle configuration d'imprimante en partant de zéro. Toutefois, cela nécessite des connaissances techniques importantes sur l'imprimante et son électronique. Il est recommandé à la plupart des utilisateurs de commencer par un fichier de configuration approprié. Si vous créez un nouveau fichier de configuration d'imprimante personnalisé, commencez par l'exemple d'un [fichier de configuration](../config/) proche et utilisez la [référence de configuration](Config_Reference.md) de Klipper pour plus d'informations.

## Interacting with Klipper

Klipper is a 3d printer firmware, so it needs some way for the user to interact with it.

Currently the best choices are front ends that retrieve information through the [Moonraker web API](https://moonraker.readthedocs.io/) and there is also the option to use [Octoprint](https://octoprint.org/) to control Klipper.

The choice is up to the user on what to use, but the underlying Klipper is the same in all cases. We encourage users to research the options available and make an informed decision.

## Obtaining an OS image for SBC's

There are many ways to obtain an OS image for Klipper for SBC use, most depend on what front end you wish to use. Some manufacturers of these SBC boards also provide their own Klipper-centric images.

The two main Moonraker-based front ends are [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/), the latter of which has a premade install image ["MainsailOS"](https://docs-os.mainsail.xyz/), this has the option for Raspberry Pi and some OrangePi variants.

Fluidd can be installed via KIAUH(Klipper Install And Update Helper), which is explained below and is a 3rd party installer for all things Klipper.

OctoPrint can be installed via the popular OctoPi image or via KIAUH, this process is explained in <OctoPrint.md>

## Installing via KIAUH

Normally you would start with a base image for your SBC, RPiOS Lite for example, or in the case of an x86 Linux device, Ubuntu Server. Please note that Desktop variants are not recommended due to certain helper programs that can stop some Klipper functions from working and even mask access to some printer boards.

KIAUH can be used to install Klipper and its associated programs on a variety of Linux-based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

## Compilation et flashage du micro-contrôleur

To compile the micro-controller code, start by running these commands on your host device:

```
cd ~/klipper/
make menuconfig
```

Les commentaires en haut du [fichier de configuration de l'imprimante](#obtain-a-klipper-configuration-file) devraient décrire les paramètres qui doivent être définis pendant le "make menuconfig". Ouvrez le fichier dans un navigateur Web ou un éditeur de texte et recherchez ces instructions en haut du fichier. Une fois que les paramètres appropriés de "menuconfig" ont été configurés, appuyez sur "Q" pour quitter, puis sur "Y" pour enregistrer. Ensuite, exécutez :

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board, then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Sinon, les étapes suivantes sont souvent utilisées pour le "flash" de la carte de contrôle de l'imprimante. D'abord, il est nécessaire de déterminer le port série connecté au micro-contrôleur. Lancez ceci :

```
ls /dev/serial/by-id/*
```

Il devrait retourner quelque chose de similaire à ce qui suit :

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

It's common for each printer to have its own unique serial port name. This unique name will be used when flashing the micro-controller. It's possible there may be multiple lines in the above output - if so, choose the line corresponding to the micro-controller. If many items are listed and the choice is ambiguous, unplug the board and run the command again, the missing item will be your print board(see the [FAQ](FAQ.md#wheres-my-serial-port) for more information).

For common micro-controllers with STM32 or clone chips, LPC chips and others, it is usual that these need an initial Klipper flash via SD card.

When flashing with this method, it is important to make sure that the print board is not connected with USB to the host, due to some boards being able to feed power back to the board and stopping a flash from occurring.

For common micro-controllers using Atmega chips, for example the 2560, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Veillez à mettre à jour le FLASH_DEVICE avec le nom unique du port série de l'imprimante.

For common micro-controllers using RP2040 chips, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

It is important to note that RP2040 chips may need to be put into Boot mode before this operation.

## Configuration de Klipper

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the host.

Arguably the easiest way to set the Klipper configuration file is using the built-in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Another option is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via SSH. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

C'est classique pour chaque imprimante d'avoir son propre nom pour le micro-contrôleur. Le nom peut changer après le flashing de Klipper, relancez donc ces étapes à nouveau même si elles ont déjà été faites lors du flashing. Lancez :

```
ls /dev/serial/by-id/*
```

Il devrait retourner quelque chose de similaire à ce qui suit :

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Puis mettez à jour le fichier de configuration avec un nom unique. Par exemple, mettez à jour la section `[mcu]` pour ressembler à quelque chose comme :

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file, it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report that the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

Lors de la personnalisation du fichier de configuration de l'imprimante, il n'est pas rare que Klipper signale une erreur de configuration. Si une erreur se produit, apportez les corrections nécessaires au fichier de configuration de l'imprimante et lancez "restart" jusqu'à ce que "status" indique que l'imprimante est prête.

Klipper reports error messages via the command console and pop-ups in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located at `~/printer_data/logs/klippy.log`.

Une fois que Klipper a signalé que l'imprimante est prête, passez au [document de vérification de la configuration](Config_checks.md) pour effectuer les vérifications de base sur les définitions du fichier de configuration. Pour plus d'informations, consultez la [référence de documentation ](Overview.md) principale pour plus d'informations.
