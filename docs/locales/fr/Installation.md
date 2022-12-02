# Installation

Ces instructions supposent que le logiciel fonctionnera sur un ordinateur Raspberry Pi en conjonction avec OctoPrint. Il est recommandé d'utiliser un ordinateur Raspberry Pi 2, 3 ou 4 comme machine hôte (voir la [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) pour les autres machines).

## Obtenir un fichier de configuration de Klipper

La plupart des paramètres de Klipper sont déterminés par un "fichier de configuration d'imprimante" stocké sur le Raspberry Pi. Un fichier de configuration approprié peut souvent être trouvé en recherchant dans le [répertoire des configurations](../config/) de Klipper, un fichier commençant par un préfixe "printer-" correspondant à l'imprimante cible. Le fichier de configuration de Klipper contient des informations techniques sur l'imprimante nécessaires pendant l'installation.

S'il n'y a pas de fichier de configuration d'imprimante approprié dans le répertoire des configurations de Klipper, essayez de rechercher le site Web du fabricant de l'imprimante pour voir s'il y a un fichier de configuration Klipper approprié.

Si aucun fichier de configuration pour l'imprimante ne peut être trouvé, mais que le type de carte de contrôle de l'imprimante est connu, recherchez un [fichier de configuration](../config/) approprié commençant par un préfixe "generic-". Ces exemples de fichiers de carte d'imprimante devraient permettre de réaliser avec succès l'installation initiale, mais nécessiteront une personnalisation afin d'obtenir la fonctionnalité complète de l'imprimante.

Il est également possible de définir une nouvelle configuration d'imprimante en partant de zéro. Toutefois, cela nécessite des connaissances techniques importantes sur l'imprimante et son électronique. Il est recommandé à la plupart des utilisateurs de commencer par un fichier de configuration approprié. Si vous créez un nouveau fichier de configuration d'imprimante personnalisé, commencez par l'exemple d'un [fichier de configuration](../config/) proche et utilisez la [référence de configuration](Config_Reference.md) de Klipper pour plus d'informations.

## Préparation de l'image du système d'exploitation (OS)

Commencez par installer [OctoPi](https://github.com/guysoft/OctoPi) sur l'ordinateur Raspberry Pi. Utilisez OctoPi v0.17.0 ou plus récent - voir les [OctoPi releases](https://github.com/guysoft/OctoPi/releases) pour les informations de versions. Il faut vérifier que OctoPi démarre et que le serveur web OctoPrint fonctionne. Après s'être connecté à la page web d'OctoPrint, suivez les instructions pour mettre à jour OctoPrint à la version v1.4.2 ou ultérieure.

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

Les commentaires en haut du [fichier de configuration de l'imprimante](#obtain-a-klipper-configuration-file) devraient décrire les paramètres qui doivent être définis pendant le "make menuconfig". Ouvrez le fichier dans un navigateur Web ou un éditeur de texte et recherchez ces instructions en haut du fichier. Une fois que les paramètres appropriés de "menuconfig" ont été configurés, appuyez sur "Q" pour quitter, puis sur "Y" pour enregistrer. Ensuite, exécutez :

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

La façon la plus simple de définir le fichier de configuration de Klipper est d'utiliser un éditeur de bureau qui prend en charge l'édition de fichiers via les protocoles "scp" et/ou "sftp". Il existe des outils disponibles gratuitement qui prenant en charge cette fonction (par exemple, Notepad++, WinSCP et Cyberduck). Chargez le fichier de configuration de l'imprimante dans l'éditeur, puis sauvegardez-le dans un fichier nommé "printer.cfg" dans le répertoire personnel de l'utilisateur pi (par exemple, /home/pi/printer.cfg).

On peut également copier et modifier le fichier directement sur le Raspberry Pi via ssh. Cela peut ressembler à ce qui suit (veillez à mettre à jour la commande pour utiliser le nom de fichier de configuration de l'imprimante approprié) :

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

Après avoir créé et édité le fichier, il sera nécessaire de lancer une commande "restart" dans le terminal web OctoPrint pour charger la configuration. Une commande "status" indiquera que l'imprimante est prête si le fichier de configuration Klipper est lu avec succès et si le micro-contrôleur est trouvé et configuré avec succès.

Lors de la personnalisation du fichier de configuration de l'imprimante, il n'est pas rare que Klipper signale une erreur de configuration. Si une erreur se produit, apportez les corrections nécessaires au fichier de configuration de l'imprimante et lancez "restart" jusqu'à ce que "status" indique que l'imprimante est prête.

Klipper rapporte les messages d'erreur via l'onglet du terminal OctoPrint. La commande "status" peut être utilisée pour rapporter à nouveau les messages d'erreur. Le script de démarrage par défaut de Klipper place également un journal dans **/tmp/klippy.log** qui fournit des informations plus détaillées.

Une fois que Klipper a signalé que l'imprimante est prête, passez au [document de vérification de la configuration](Config_checks.md) pour effectuer les vérifications de base sur les définitions du fichier de configuration. Pour plus d'informations, consultez la [référence de documentation ](Overview.md) principale pour plus d'informations.
