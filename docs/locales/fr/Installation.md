# Installation

Ces instructions supposent que le logiciel fonctionnera sur un ordinateur Raspberry Pi en conjonction avec OctoPrint. Il est recommandé d'utiliser un ordinateur Raspberry Pi 2, 3 ou 4 comme machine hôte (voir la [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) pour les autres machines).

## Obtenir un fichier de configuration de Klipper

Most Klipper settings are determined by a "printer configuration file" that will be stored on the Raspberry Pi. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

If there isn't an appropriate printer configuration file in the Klipper config directory then try searching the printer manufacturer's website to see if they have an appropriate Klipper configuration file.

If no configuration file for the printer can be found, but the type of printer control board is known, then look for an appropriate [config file](../config/) starting with a "generic-" prefix. These example printer board files should allow one to successfully complete the initial installation, but will require some customization to obtain full printer functionality.

It is also possible to define a new printer configuration from scratch. However, this requires significant technical knowledge about the printer and its electronics. It is recommended that most users start with an appropriate configuration file. If creating a new custom printer configuration file, then start with the closest example [config file](../config/) and use the Klipper [config reference](Config_Reference.md) for further information.

## Préparation de l'image du système d'exploitation (OS)

Start by installing [OctoPi](https://github.com/guysoft/OctoPi) on the Raspberry Pi computer. Use OctoPi v0.17.0 or later - see the [OctoPi releases](https://github.com/guysoft/OctoPi/releases) for release information. One should verify that OctoPi boots and that the OctoPrint web server works. After connecting to the OctoPrint web page, follow the prompt to upgrade OctoPrint to v1.4.2 or later.

Après avoir installé OctoPi et mis à jour OctoPrint, il sera nécessaire de se connecter via ssh à la machine cible pour exécuter quelques commandes système. Si vous utilisez un bureau Linux ou MacOS, le logiciel "ssh" devrait déjà être installé sur le bureau. Il existe des clients ssh gratuits pour d'autres ordinateurs de bureau (par exemple, [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Utilisez l'utilitaire ssh pour vous connecter au Raspberry Pi (ssh pi@octopi -- le mot de passe par défaut est "raspberry") et exécutez les commandes suivantes :

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

L'opération ci-dessus permet de télécharger Klipper, d'installer certaines dépendances du système, de configurer Klipper pour qu'il soit exécuté au démarrage du système et de lancer le logiciel hôte Klipper. Une connexion Internet est nécessaire et l'opération peut prendre quelques minutes.

## Compilation et flashage du micro-contrôleur

Pour compiler le code du microcontrôleur, commencez par exécuter ces commandes sur le Raspberry Pi :

```
cd ~/klipper/
make menuconfig
```

The comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) should describe the settings that need to be set during "make menuconfig". Open the file in a web browser or text editor and look for these instructions near the top of the file. Once the appropriate "menuconfig" settings have been configured, press "Q" to exit, and then "Y" to save. Then run:

```
make
```

Si les commentaires au haut de [printer configuration file](#obtain-a-klipper-configuration-file) décrive des étapes pour le "flashing" de l'image finale sur la carte de contrôle de l'imprimante alors suivez ces étapes puis procédez à [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Sinon, les étapes suivantes sont souvent utilisées pour le "flash" de la carte de contrôle de l'imprimante. D'abord, il est nécessaire de déterminer le port série connecté au micro-contrôleur. Lancez ceci :

```
ls /dev/serial/by-id/*
```

Il devrait retourner quelque chose de similaire à ce qui suit :

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Il est courant que chaque imprimante ait son propre nom de port série unique. Ce nom unique sera utilisé lors du flashage du micro-contrôleur. Il est possible qu'il y ait plusieurs lignes dans la sortie ci-dessus - si c'est le cas, choisissez la ligne correspondant au micro-contrôleur (voir la [FAQ](FAQ.md#wheres-my-serial-port) pour plus d'informations).

Pour les micro-contrôleurs courants, le code peut être flashé avec quelque chose de similaire :

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Veillez à mettre à jour le FLASH_DEVICE avec le nom unique du port série de l'imprimante.

Lors du premier flashage, assurez-vous qu'OctoPrint n'est pas connecté directement à l'imprimante (à partir de la page web d'OctoPrint, sous la section "Connexion", cliquez sur "Déconnecter").

## Configuration d'OctoPrint pour utiliser Klipper

Le serveur web OctoPrint doit être configuré pour communiquer avec le logiciel hôte Klipper. À l'aide d'un navigateur Web, connectez-vous à la page Web d'OctoPrint, puis configurez les éléments suivants :

Naviguez vers l'onglet "Settings" (l'icône de la clé à molette en haut de la page). Sous "Serial Connection" dans "Additional serial ports" ajoutez "/tmp/printer". Cliquez ensuite sur "Save".

Entrez à nouveau dans l'onglet Paramètres et, sous "Connexion série", changez le paramètre "Port série" en "/tmp/printer".

Dans l'onglet "Paramètres", accédez au sous-onglet "Behavior" et sélectionnez l'option "Cancel any ongoing prints but stay connected to the printer". Cliquez sur "Enregistrer".

Sur la page principale, dans la section "Connection" (en haut à gauche de la page), assurez-vous que le "Serial Port" est réglé sur "/tmp/printer" et cliquez sur "Connect". (si "/tmp/printer" n'est pas une sélection disponible, essayez de recharger la page.)

Une fois connecté, naviguez vers l'onglet "Terminal" et tapez "status" (sans les guillemets) dans la boîte de saisie de la commande et cliquez sur "Send". La fenêtre du terminal indiquera probablement qu'il y a une erreur dans l'ouverture du fichier de configuration - cela signifie qu'OctoPrint communique avec succès avec Klipper. Passez à la section suivante.

## Configuration de Klipper

La prochaine étape est de copier le [printer configuration file](#obtain-a-klipper-configuration-file) dans le Raspberry Pi.

Arguably the easiest way to set the Klipper configuration file is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the Raspberry Pi via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

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

After creating and editing the file it will be necessary to issue a "restart" command in the OctoPrint web terminal to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

When customizing the printer config file, it is not uncommon for Klipper to report a configuration error. If an error occurs, make any necessary corrections to the printer config file and issue "restart" until "status" reports the printer is ready.

Klipper rapporte les messages d'erreur via l'onglet du terminal OctoPrint. La commande "status" peut être utilisée pour rapporter à nouveau les messages d'erreur. Le script de démarrage par défaut de Klipper place également un journal dans **/tmp/klippy.log** qui fournit des informations plus détaillées.

After Klipper reports that the printer is ready, proceed to the [config check document](Config_checks.md) to perform some basic checks on the definitions in the config file. See the main [documentation reference](Overview.md) for other information.
