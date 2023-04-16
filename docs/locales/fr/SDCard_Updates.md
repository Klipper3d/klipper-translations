# Mises à jour via la carte SD

La plupart des microcontrôleurs actuels sont livrés avec un programme d'amorçage capable de mettre à jour le micrologiciel via une carte SD. Bien que cela soit pratique dans de nombreux cas, ces programmes d'amorçage ne fournissent généralement aucun autre moyen de mettre à jour le micrologiciel. Cela peut s'avérer gênant si votre carte est installée dans un endroit difficile d'accès ou si vous avez besoin de mettre à jour le firmware régulièrement. Après avoir initialement flashé Klipper sur un microcontrôleur, il est possible de transférer le nouveau micrologiciel sur la carte SD et de lancer le processus de mise à jour via ssh.

## Procédure de mise à jour classique

La procédure pour mettre à jour le firmware du MCU en utilisant la carte SD est similaire à celle des autres méthodes. Au lieu d'utiliser `make flash`, il est nécessaire d'exécuter un script d'aide, `flash-sdcard.sh`. La mise à jour d'un BigTreeTech SKR 1.3 pourrait ressembler à ce qui suit :

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-skr-v1.3
sudo service klipper start
```

C'est à l'utilisateur de déterminer l'emplacement du périphérique et le nom de la carte. Si un utilisateur a besoin de flasher plusieurs cartes, `flash-sdcard.sh` (ou `make flash` si approprié) doit être exécuté pour chaque carte avant de redémarrer le service Klipper.

Les cartes supportées peuvent être listées avec la commande suivante :

```
./scripts/flash-sdcard.sh -l
```

Si vous ne voyez pas votre carte dans la liste, il peut être nécessaire d'ajouter une nouvelle définition de carte comme [décrit ci-dessous](#board-definitions).

## Utilisation avancée

Les commandes ci-dessus supposent que votre MCU se connecte à la vitesse de transmission par défaut de 250000 et que le firmware se trouve dans `~/klipper/out/klipper.bin`. Le script `flash-sdcard.sh` fournit des options pour changer ces valeurs par défaut. Toutes les options peuvent être visualisées par l'écran d'aide :

```
./scripts/flash-sdcard.sh -h
SD Card upload utility for Klipper

usage: flash_sdcard.sh [-h] [-l] [-c] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -c              run flash check/verify only (skip upload)
  -b <baud>       serial baud rate (default is 250000)
  -f <firmware>   path to klipper.bin
```

Si votre carte est flashée avec un firmware qui se connecte à un taux de baud personnalisé, il est possible de mettre à jour en spécifiant l'option `-b` :

```
./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
```

Si vous souhaitez flasher une version de Klipper située ailleurs que dans l'emplacement par défaut, vous pouvez le faire en spécifiant l'option `-f` :

```
./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
```

Notez que lors de la mise à jour d'un MKS Robin E3, il n'est pas nécessaire d'exécuter manuellement `update_mks_robin.py` et de fournir le binaire résultant à `flash-sdcard.sh`. Cette procédure est automatisée pendant le processus de téléchargement.

L'option `-c` est utilisée pour effectuer une opération de contrôle ou de vérification uniquement pour tester si la carte exécute correctement le firmware spécifié. Cette option est principalement destinée aux cas où un cycle d'alimentation manuel est nécessaire pour compléter la procédure de flashage, comme avec des chargeurs de démarrage utilisant le mode SDIO au lieu de SPI pour accéder à leurs cartes SD. (Voir Caveats ci-dessous) Mais, elle peut également être utilisée à tout moment pour vérifier si le code flashé dans la carte correspond à la version dans votre dossier de construction sur toute carte supportée.

## Avertissements

- Comme mentionné dans l'introduction, cette méthode ne fonctionne que pour la mise à jour du firmware. La procédure de flashage initial doit être effectuée manuellement selon les instructions qui s'appliquent à votre carte contrôleur.
- Bien qu'il soit possible de flasher un build qui change le Baud série ou l'interface de connexion (par exemple, de USB à UART), la vérification échouera toujours car le script ne pourra pas se reconnecter au MCU pour vérifier la version actuelle.
- Seules les cartes utilisant SPI pour la communication avec la carte SD sont supportées. Les cartes utiliaent SDIO, comme la Flymaker Flyboard et la MKS Robin Nano V1/V2, ne fonctionneront pas en mode SDIO. Cependant, il est généralement possible de flasher ces cartes en utilisant le mode SPI logiciel. Mais si le chargeur d'amorçage de la carte n'utilise que le mode SDIO pour accéder à la carte SD, un cycle d'alimentation de la carte et de la carte SD sera nécessaire pour que le mode puisse passer de SPI à SDIO pour terminer le flashage. De telles cartes devraient être définies avec `skip_verify` activé pour sauter l'étape de vérification immédiatement après le flashage. Ensuite, après le power-cycle manuel, vous pouvez ré-exécuter exactement la même commande `./scripts/flash-sdcard.sh`, mais ajouter l'option `-c` pour compléter l'opération de vérification. Voir [Flasher des cartes utilisant SDIO](#flashing-boards-that-use-sdio) pour des exemples.

## Définitions des cartes

La plupart des cartes courantes devraient être disponibles, mais il est possible d'ajouter une nouvelle définition de carte si nécessaire. Les définitions des cartes sont situées dans `~/klipper/scripts/spi_flash/board_defs.py`. Les définitions sont stockées dans un dictionnaire, par exemple :

```python
BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<further definitions>
}
```

Les champs suivants peuvent être précisés :

- `mcu`: The mcu type. This can be retrieved after configuring the build via `make menuconfig` by running `cat .config | grep CONFIG_MCU`. This field is required.
- `spi_bus`: The SPI bus connected to the SD Card. This should be retrieved from the board's schematic. This field is required.
- `cs_pin`: The Chip Select Pin connected to the SD Card. This should be retrieved from the board schematic. This field is required.
- `firmware_path` : Le chemin sur la carte SD où le firmware doit être transféré. La valeur par défaut est `firmware.bin`.
- `current_firmware_path` : Le chemin sur la carte SD où le fichier du firmware renommé est situé après un flash réussi. La valeur par défaut est `firmware.cur`.
- `skip_verify` : définit une valeur booléenne indiquant aux scripts d'ignorer l'étape de vérification du firmware pendant le processus de flashage. La valeur par défaut est `False`. Peut être défini à `True` pour les cartes nécessitant un cycle d'alimentation manuel pour terminer le flashage. Pour vérifier le firmware par la suite, exécutez à nouveau le script avec l'option `-c` pour effectuer l'étape de vérification. [Voir les avertissements avec les cartes SDIO](#caveats)

Si le SPI logiciel est requis, le champ `spi_bus` doit être réglé sur `swspi` et le champ supplémentaire suivant doit être spécifié :

- `spi_pins` : Ceci devrait être 3 broches séparées par des virgules qui sont connectées à la carte SD dans le format de `miso,mosi,sclk`.

Il devrait être extrêmement rare que le SPI logiciel soit nécessaire, typiquement seules les cartes avec des erreurs de conception ou les cartes ne supportant que le mode SDIO pour leur carte SD en auront besoin. La définition de la carte `btt-skr-pro` fournit un exemple du premier cas, et la définition de la carte `btt-octopus-f446-v1` fournit un exemple du second.

Avant de créer une nouvelle définition de carte, il faut vérifier si la définition d'une carte existante répond aux critères nécessaires pour la nouvelle carte. Si c'est le cas, un `BOARD_ALIAS` peut être utilisé. Par exemple, l'alias suivant peut être ajouté pour spécifier `my-new-board` comme alias de `generic-lpc1768` :

```python
BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
```

Si vous avez besoin d'une nouvelle définition de carte et que vous n'êtes pas à l'aise avec la procédure décrite ci-dessus, il est recommandé d'en demander une sur le [Discord de la communauté Klipper](Contact.md#discord).

## Flashage des cartes utilisant SDIO

Comme mentionné dans les [Caveats](#caveats), les cartes dont le chargeur de démarrage utilise le mode SDIO pour l'accès à leur carte SD nécessitent un power-cycle de la carte, et plus particulièrement de la carte SD elle-même, afin de passer du mode SPI utilisé lors de l'écriture du fichier sur la carte SD au mode SDIO pour que le chargeur de démarrage puisse le flasher sur la carte. Ces définitions de cartes utiliseront le drapeau `skip_verify`, qui indique à l'outil de flashage de s'arrêter après l'écriture du firmware sur la carte SD afin que la carte puisse être mise sous tension manuellement et que l'étape de vérification soit reportée jusqu'à ce qu'elle soit terminée.

Il y a deux scénarios : l'un avec l'hôte RPi fonctionnant sur une alimentation séparée et l'autre lorsque l'hôte RPi fonctionne sur la même alimentation que la carte principale à flasher. La différence est de savoir s'il est nécessaire ou non d'éteindre le RPi et ensuite `ssh` de nouveau après que le flashage soit terminé afin de faire l'étape de vérification, ou si la vérification peut être faite immédiatement. Voici des exemples des deux scénarios :

### Programmation SDIO avec RPi sur alimentation séparée

Une session typique avec le RPi sur une alimentation séparée ressemble à ce qui suit. Vous devrez, bien sûr, utiliser le chemin du périphérique et le nom de la carte :

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
[[[éteindre-allumer manuellement la carte de l'imprimante quand vous y êtes invité]]]
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

### Programmation SDIO avec RPi sur la même alimentation électrique

Une session typique avec le RPi sur la même alimentation ressemble à ce qui suit. Vous devrez, bien sûr, utiliser le chemin du périphérique et le nom de la carte :

```
sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1
sudo shutdown -h now
[[[attendre que le RPi s'arrête, puis éteindre-allumer et ssh à nouveau sur le RPi quand il a redémarré]]]
sudo service klipper stop
cd ~/klipper
./scripts/flash-sdcard.sh -c /dev/ttyACM0 btt-octopus-f446-v1
sudo service klipper start
```

Dans ce cas, puisque l'hôte RPi est en train d'être redémarré, ce qui va redémarrer le service `klipper`, il est nécessaire d'arrêter le service `klipper` avant de faire l'étape de vérification et de le redémarrer une fois la vérification terminée.

### Mappage des broches SDIO vers SPI

Si le schéma de votre carte utilise SDIO pour sa carte SD, vous pouvez mapper les broches comme décrit dans le tableau ci-dessous pour déterminer les broches SPI logicielles compatibles à assigner dans le fichier `board_defs.py` :

| Broche de la carte SD | Broche pour carte micro SD | Nom de la broche SDIO | Nom de la broche SPI |
| :-: | :-: | :-: | :-: |
| 9 | 1 | DATA2 | None (PU)* |
| 1 | 2 | CD/DATA3 | CS |
| 2 | 3 | CMD | MOSI |
| 4 | 4 | +3.3V (VDD) | +3.3V (VDD) |
| 5 | 5 | CLK | SCLK |
| 3 | 6 | GND (VSS) | GND (VSS) |
| 7 | 7 | DATA0 | MISO |
| 8 | 8 | DATA1 | None (PU)* |
| N/A | 9 | Card Detect (CD) | Card Detect (CD) |
| 6 | 10 | GND | GND |

\* None (PU) indique une broche inutilisée avec une résistance de tirage haut
