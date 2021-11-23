# Installation

Ces instructions supposent que le logiciel fonctionnera sur un ordinateur Raspberry Pi en conjonction avec OctoPrint. Il est recommandé d'utiliser un ordinateur Raspberry Pi 2, 3 ou 4 comme machine hôte (voir la [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) pour les autres machines).

Klipper currently supports a number of Atmel ATmega based micro-controllers, [ARM based micro-controllers](Features.md#step-benchmarks), and [Beaglebone PRU](Beaglebone.md) based printers.

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

Sélectionnez le microcontrôleur approprié et examinez les autres options proposées. Une fois configuré, exécutez :

```
make
```

Il est nécessaire de déterminer le port série connecté au micro-contrôleur. Pour les micro-contrôleurs qui se connectent via USB, exécutez ce qui suit :

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

The Klipper configuration is stored in a text file on the Raspberry Pi. Take a look at the example config files in the [config directory](../config/). The [Config Reference](Config_Reference.md) contains documentation on config parameters.

La façon la plus simple de mettre à jour le fichier de configuration de Klipper est d'utiliser un éditeur de bureau qui prend en charge l'édition de fichiers via les protocoles "scp" et/ou "sftp". Il existe des outils disponibles gratuitement qui prennent en charge cette fonction (par exemple, Notepad++, WinSCP et Cyberduck). Utilisez un des exemples de fichiers de configuration comme point de départ et sauvegardez-le dans un fichier nommé "printer.cfg" dans le répertoire personnel de l'utilisateur pi (par exemple, /home/pi/printer.cfg).

On peut aussi copier et éditer le fichier directement sur le Raspberry Pi via ssh - par exemple :

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Assurez-vous d'examiner et de mettre à jour chaque paramètre approprié au matériel.

Il est courant que chaque imprimante ait son propre nom unique pour le micro-contrôleur. Le nom peut changer après avoir flashé Klipper, donc relancez la commande `ls /dev/serial/by-id/*` et mettez à jour le fichier de configuration avec ce nom unique. Par exemple, mettez à jour la section `[mcu]` pour qu'elle ressemble à quelque chose comme :

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Après avoir créé et édité le fichier, il sera nécessaire de lancer la commande "restart" dans le terminal web OctoPrint pour charger la configuration. La commande "status" indiquera que l'imprimante est prête si le fichier de configuration Klipper est lu avec succès et si le micro-contrôleur est trouvé et configuré avec succès. Il n'est pas rare d'avoir des erreurs de configuration pendant la configuration initiale - mettez à jour le fichier de configuration de l'imprimante et relancez la commande "restart" jusqu'à ce que "status" indique que l'imprimante est prête.

Klipper rapporte les messages d'erreur via l'onglet du terminal OctoPrint. La commande "status" peut être utilisée pour rapporter à nouveau les messages d'erreur. Le script de démarrage par défaut de Klipper place également un journal dans **/tmp/klippy.log** qui fournit des informations plus détaillées.

En plus des commandes g-code courantes, Klipper prend en charge quelques commandes étendues - "status" et "restart" en sont des exemples. Utilisez la commande "help" pour obtenir la liste des autres commandes étendues.

Après que Klipper ait signalé que l'imprimante est prête, passez au [document de vérification de la configuration](Config_checks.md) pour effectuer quelques vérifications de base sur les définitions des broches dans le fichier de configuration.

## Contacter les développeurs

N'oubliez pas de consulter la [FAQ](FAQ.md) pour obtenir des réponses aux questions courantes. Consultez la page [contact](Contact.md) pour signaler un bogue ou contacter les développeurs.
