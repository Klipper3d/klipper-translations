# Beaglebone

Ce document décrit le processus d'exécution de Klipper sur un Beaglebone PRU.

## Construire l'image de l'OS

Commencez par installer l'image [Debian 9.9 2019-08-03 4GB SD IoT](https://beagleboard.org/latest-images). Vous pouvez exécuter l'image à partir d'une carte micro-SD ou de la carte eMMC intégrée. Si vous utilisez l'eMMC, installez-la sur l'eMMC maintenant en suivant les instructions du lien ci-dessus.

Ensuite, connectez-vous à la machine Beaglebone (`ssh debian@beaglebone` -- le mot de passe est `temppwd`) et installez Klipper en exécutant les commandes suivantes :

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-beaglebone.sh
```

## Installer Octoprint

On peut ensuite installer Octoprint :

```
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint/
virtualenv venv
./venv/bin/python setup.py install
```

Et configurer OctoPrint pour qu'il démarre au démarrage :

```
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults
```

Il est nécessaire de modifier le fichier de configuration d'OctoPrint **/etc/default/octoprint**. Il faut changer l'utilisateur `OCTOPRINT_USER` en `debian`, changer `NICELEVEL` en `0`, décommenter les paramètres `BASEDIR`, `CONFIGFILE`, et `DAEMON` et changer les références de `/home/pi/` en `/home/debian/` :

```
sudo nano /etc/default/octoprint
```

Démarrez ensuite le service Octoprint :

```
sudo systemctl start octoprint
```

Assurez-vous que le serveur web OctoPrint est accessible - il devrait se trouver à l'adresse suivante : <http://beaglebone:5000/>

## Construire le code du microcontrôleur

Pour compiler le code du microcontrôleur Klipper, commencez par le configurer pour le "Beaglebone PRU" :

```
cd ~/klipper/
make menuconfig
```

Pour compiler et installer le nouveau code du microcontrôleur, exécutez :

```
sudo service klipper stop
make flash
sudo service klipper start
```

Il est également nécessaire de compiler et d'installer le code du microcontrôleur pour un processus hôte Linux. Configurez-le une seconde fois pour un "processus Linux" :

```
make menuconfig
```

Puis installez également ce code de micro-contrôleur :

```
sudo service klipper stop
make flash
sudo service klipper start
```

## Configuration restante

Terminez l'installation en configurant Klipper et Octoprint en suivant les instructions du document principal [Installation](Installation.md#configuration-klipper).

## Imprimer avec le Beaglebone

Malheureusement, le processeur du Beaglebone peut parfois avoir du mal à faire fonctionner OctoPrint correctement. Des blocages d'impression sont connus pour se produire sur des impressions complexes (l'imprimante peut se déplacer plus rapidement qu'OctoPrint ne peut envoyer de commandes de mouvement). Si cela se produit, envisagez d'utiliser la fonctionnalité "virtual_sdcard" (voir [Référence des configurations](Config_Reference.md#virtual_sdcard) pour plus de détails) pour imprimer directement depuis Klipper.
