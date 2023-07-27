# Mesurer la résonance

Klipper has built-in support for the ADXL345 and MPU-9250 compatible accelerometers which can be used to measure resonance frequencies of the printer for different axes, and auto-tune [input shapers](Resonance_Compensation.md) to compensate for resonances. Note that using accelerometers requires some soldering and crimping. The ADXL345 can be connected to the SPI interface of a Raspberry Pi or MCU board (it needs to be reasonably fast). The MPU family can be connected to the I2C interface of a Raspberry Pi directly, or to an I2C interface of an MCU board that supports 400kbit/s *fast mode* in Klipper.

When sourcing accelerometers, be aware that there are a variety of different PCB board designs and different clones of them. If it is going to be connected to a 5V printer MCU ensure it has a voltage regulator and level shifters.

For ADXL345s, make sure that the board supports SPI mode (a small number of boards appear to be hard-configured for I2C by pulling SDO to GND).

For MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500s there are also a variety of board designs and clones with different I2C pull-up resistors which will need supplementing.

## MCUs with Klipper I2C *fast-mode* Support

| MCU Family | MCU(s) Tested | MCU(s) with Support |
| :-: | :-- | :-- |
| Raspberry Pi | 3B+, Pico | 3A, 3A+, 3B, 4 |
| AVR ATmega | ATmega328p | ATmega32u4, ATmega128, ATmega168, ATmega328, ATmega644p, ATmega1280, ATmega1284, ATmega2560 |
| AVR AT90 | - | AT90usb646, AT90usb1286 |

## Instructions d’installation

### Câblage

An ethernet cable with shielded twisted pairs (cat5e or better) is recommended for signal integrity over a long distance. If you still experience signal integrity issues (SPI/I2C errors):

- Double check the wiring with a digital multimeter for:
   - Correct connections when turned off (continuity)
   - Correct power and ground voltages
- I2C only:
   - Check the SCL and SDA lines' resistances to 3.3V are in the range of 900 ohms to 1.8K
   - For full technical details consult [chapter 7 of the I2C-bus specification and user manual UM10204](https://www.pololu.com/file/0J435/UM10204.pdf) for *fast-mode*
- Shorten the cable

Connect ethernet cable shielding only to the MCU board/Pi ground.

***Vérifiez votre câblage avant de mettre sous tension pour éviter d'endommager votre MCU/Raspberry Pi ou l'accéléromètre ou les deux.***

### Accéléromètres SPI

Suggested twisted pair order for three twisted pairs:

```
GND+MISO
3.3V+MOSI
SCLK+CS
```

Note that unlike a cable shield, GND must be connected at both ends.

#### ADXL345

##### Directement sur Raspberry Pi

**Note: Many MCUs will work with an ADXL345 in SPI mode (e.g. Pi Pico), wiring and configuration will vary according to your specific board and available pins.**

Vous devez connecter votre ADXL345 à votre Raspberry Pi via SPI. Notez que la connexion I2C, suggérée par la documentation ADXL345, possède un débit trop faible et ** ne fonctionnera pas**. Le schéma de connexion recommandé :

| Brochage de l'ADXL345 | Brochage du RPI | Nom des broches du RPI |
| :-: | :-: | :-: |
| 3,3 V (ou VCC) | 01 | Alimentation 3,3 V CC |
| GND | 06 | Terre |
| CS | 24 | GPIO08 (SPI0_CE0_N) |
| SDO | 21 | GPIO09 (SPI0_MISO) |
| SDA | 19 | GPIO10 (SPI0_MOSI) |
| SCL | 23 | GPIO11 (SPI0_SCLK) |

Schémas de câblage de Fritzing pour certaines des cartes ADXL345 :

![ADXL345-Rpi](img/adxl345-fritzing.png)

##### Utilisation d'un Raspberry Pi Pico

Vous pouvez connecter l'ADXL345 à votre Raspberry Pi Pico, puis connecter le Pico à votre Raspberry Pi via USB. Cela facilite la réutilisation de l'accéléromètre sur d'autres appareils Klipper, car vous pouvez vous connecter via USB au lieu de GPIO. Le Pico n'a pas beaucoup de puissance de traitement, alors assurez-vous qu'il n'exécute que l'accéléromètre et n'effectue aucune autre tâche.

Afin d'éviter d'endommager votre RPi, assurez-vous de connecter l'ADXL345 uniquement à 3,3 V. Selon la disposition de la carte, un décalage de niveau peut être présent, ce qui rend le 5V dangereux pour votre RPi.

| Brochage de l'ADXL345 | Broche pico | Nom de la broche Pico |
| :-: | :-: | :-: |
| 3,3 V (ou VCC) | 36 | Alimentation 3,3 V CC |
| GND | 38 | Terre |
| CS | 2 | GP1 (SPI0_CSn) |
| SDO | 1 | GP0 (SPI0_RX) |
| SDA | 5 | GP3 (SPI0_TX) |
| SCL | 4 | GP2 (SPI0_SCK) |

Schémas de câblage pour certaines des cartes ADXL345 :

![ADXL345-Pico](img/adxl345-pico.png)

### Accéléromètres I2C

Suggested twisted pair order for three pairs (preferred):

```
3.3V+GND
SDA+GND
SCL+GND
```

or for two pairs:

```
3.3V+SDA
GND+SCL
```

Note that unlike a cable shield, any GND(s) should be connected at both ends.

#### MPU-9250/MPU-9255/MPU-6515/MPU-6050/MPU-6500

These accelerometers have been tested to work over I2C on the RPi, RP2040 (Pico) and AVR at 400kbit/s (*fast mode*). Some MPU accelerometer modules include pull-ups, but some are too large at 10K and must be changed or supplemented by smaller parallel resistors.

Schéma de connexion recommandé pour I2C sur le Raspberry Pi :

| brochage du MPU-9250 | Brochage du RPI | Nom des broches du RPI |
| :-: | :-: | :-: |
| VCC | 01 | Alimentation 3.3v continu |
| GND | 09 | Terre |
| SDA | 03 | GPIO02 (SDA1) |
| SCL | 05 | GPIO03 (SCL1) |

The RPi has buit-in 1.8K pull-ups on both SCL and SDA.

![MPU-9250 connected to Pi](img/mpu9250-PI-fritzing.png)

Recommended connection scheme for I2C (i2c0a) on the RP2040:

| brochage du MPU-9250 | Broche du RP2040 | RP2040 pin name |
| :-: | :-: | :-: |
| VCC | 36 | 3v3 |
| GND | 38 | Terre |
| SDA | 01 | GP0 (I2C0 SDA) |
| SCL | 02 | GP1 (I2C0 SCL) |

The Pico does not include any built-in I2C pull-up resistors.

![MPU-9250 connected to Pico](img/mpu9250-PICO-fritzing.png)

##### Recommended connection scheme for I2C(TWI) on the AVR ATmega328P Arduino Nano:

| brochage du MPU-9250 | Atmega328P TQFP32 pin | Atmega328P pin name | Arduino Nano pin |
| :-: | :-: | :-: | :-: |
| VCC | 39 | - | - |
| GND | 38 | Terre | GND |
| SDA | 27 | SDA | A4 |
| SCL | 28 | SCL | A5 |

The Arduino Nano does not include any built-in pull-up resistors nor a 3.3V power pin.

### Montage de l’accéléromètre

L’accéléromètre doit être fixé sur la tête d'impression. Il faut concevoir un support approprié et adapté à l'imprimante 3D. Il est préférable d’aligner les axes de l’accéléromètre avec les axes de l’imprimante (mais ce n'est pas obligatoire - c’est-à-dire pas besoin d’aligner l’axe X avec X et ainsi de suite - cela devrait être correct même si l’axe Z de l’accéléromètre est l’axe X de l’imprimante, etc.).

Exemple de montage d’ADXL345 sur le SmartEffector :

![ADXL345 on SmartEffector](img/adxl345-mount.jpg)

Notez que sur une imprimante cartésienne, il faut concevoir 2 supports : un pour la tête et un pour le lit, et exécuter les mesures deux fois. Voir la [section](#bed-slinger-printers) correspondante pour plus de détails.

** Attention : assurez-vous que l’accéléromètre et les vis qui le maintiennent en place ne touchent aucune partie métallique de l’imprimante.** Fondamentalement, le support doit être conçu de manière à assurer l’isolation électrique de l’accéléromètre du châssis de l’imprimante. Ne pas s’assurer de cette isolation peut créer une boucle de masse dans le système conduisant à l'endommagement de l’électronique.

### Installation logicielle

Notez que les mesures de résonance et l’auto-étalonnage de l'input shaper nécessitent des dépendances logicielles supplémentaires non installées par défaut. Tout d’abord, exécutez sur votre Raspberry Pi les commandes suivantes :

```
sudo apt update
sudo apt install python3-numpy python3-matplotlib libatlas-base-dev
```

Ensuite, pour installer NumPy dans l’environnement Klipper, exécutez la commande :

```
~/klippy-env/bin/pip install -v numpy
```

Selon les performances du processeur, cette opération peut prendre jusqu’à 20 minutes. Soyez patient et attendez la fin de l’installation. Dans certains cas, si la carte a trop peu de mémoire, l’installation peut échouer et vous devrez activer le fichier d’échange.

#### Configurer l'ADXL345 avec le RPi

First, check and follow the instructions in the [RPi Microcontroller document](RPi_microcontroller.md) to setup the "linux mcu" on the Raspberry Pi. This will configure a second Klipper instance that runs on your Pi.

Assurez-vous que le pilote SPI Linux est activé en exécutant `sudo raspi-config` et en activant SPI dans le menu « Options d’interface ».

Ajoutez les lignes suivantes au fichier printer.cfg :

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[adxl345]
cs_pin: rpi:None

[resonance_tester]
accel_chip: adxl345
probe_points:
    100, 100, 20  # valeur exemple
```

Il est conseillé de commencer par 1 point de test, au milieu du lit d’impression, légèrement au-dessus.

#### Configurer ADXL345 avec Pi Pico

##### Flash micrologiciel du Pico

Sur votre Raspberry Pi, compilez le firmware du Pico.

```
cd ~/klipper
make clean
make menuconfig
```

![Pico menuconfig](IMG/klipper_pico_menuconfig.png)

Maintenant, tout en maintenant enfoncé le bouton `BOOTSEL` sur le Pico, connectez le Pico au Raspberry Pi via USB. Compilez et flashez le firmware.

```
make flash FLASH_DEVICE=first
```

Si cela échoue, on vous indiquera quel `FLASH_DEVICE` utiliser. Dans cet exemple, c'est `make flash FLASH_DEVICE=2e8a:0003`. ![Déterminer le périphérique flash](img/flash_rp2040_FLASH_DEVICE.png)

##### Configurer la connexion

Le Pico va maintenant redémarrer avec le nouveau micrologiciel et devrait apparaître comme un périphérique série. Trouvez le périphérique série pico avec `ls /dev/serial/by-id/*`. Vous pouvez maintenant ajouter un fichier `adxl.cfg` avec les paramètres suivants :

```
[mcu adxl]
# Changez <mySerial> par ce que vous aurez trouvé ci-dessus. Par exemple,
# usb-Klipper_rp2040_E661640843545B2E-if00
serial: /dev/serial/by-id/usb-Klipper_rp2040_<mySerial>

[adxl345]
cs_pin: adxl:gpio1
spi_bus: spi0a
axes_map: x,z,y

[resonance_tester]
accel_chip: adxl345
probe_points:
    # Approximativement au milieu du plateau
    147,154, 20

[output_pin power_mode] # Pour améliorer la stabilité de l'alimentation
pin: adxl:gpio23
```

Si vous mettez la configuration ADXL345 dans un fichier séparé, comme indiqué ci-dessus, vous devrez également modifier votre fichier `printer.cfg` pour inclure ceci :

```
[include adxl.cfg] # Commentez cette ligne lorsque vous déconnectez l'accéléromètre
```

Redémarrez Klipper avec la commande `RESTART`.

#### Configurer les séries MPU-6000/9000 avec le RPi

Assurez-vous que le pilote Linux I2C est activé et que le débit en bauds est défini sur 400 000 (voir la section [Activation d'I2C](RPi_microcontroller.md#optional-enabling-i2c) pour plus de détails). Ensuite, ajoutez ce qui suit au fichier printer.cfg :

```
[mcu rpi]
serial: /tmp/klipper_host_mcu

[mpu9250]
i2c_mcu: rpi
i2c_bus: i2c.1

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # valeurs exemple
```

#### Configure MPU-9520 Compatibles With Pico

Pico I2C is set to 400000 on default. Simply add the following to the printer.cfg:

```
[mcu pico]
serial: /dev/serial/by-id/<your Pico's serial ID>

[mpu9250]
i2c_mcu: pico
i2c_bus: i2c0a

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # an example

[static_digital_output pico_3V3pwm] # Improve power stability
pins: pico:gpio23
```

#### Configure MPU-9520 Compatibles with AVR

AVR I2C will be set to 400000 by the mpu9250 option. Simply add the following to the printer.cfg:

```
[mcu nano]
serial: /dev/serial/by-id/<your nano's serial ID>

[mpu9250]
i2c_mcu: nano

[resonance_tester]
accel_chip: mpu9250
probe_points:
    100, 100, 20  # an example
```

Redémarrez Klipper avec la commande `RESTART`.

## Mesurer les résonances

### Vérification de la configuration

Vous pouvez maintenant tester la connexion.

- Pour les imprimantes non cartésiennes (celles avec une seul accéléromètre), dans Octoprint, entrez `ACCELEROMETER_QUERY`
- Pour les imprimante cartésiennes (plus d’un accéléromètre), entrez `ACCELEROMETER_QUERY CHIP=<chip>` où `<chip>` est le nom de la puce tel qu’il a été entré, par exemple `CHIP=bed` (voir : [bed-slinger](#bed-slinger-printers)) faites-le pour tous les accéléromètre installés.

Vous devriez voir les mesures actuelles de l’accéléromètre, y compris l’accélération en chute libre.

```
Recv: // adxl345 values (x, y, z) : 470.719200, 941.438400, 9728.196800
```

Si vous obtenez une erreur comme `ID adxl345 non valide (got xx vs e5)`, où `xx` est un autre ID, réessayez immédiatement. Il y a un problème avec l'initialisation SPI. Si vous obtenez toujours une erreur, cela indique un problème de connexion avec ADXL345 ou le capteur défectueux. Vérifiez à nouveau l'alimentation, le câblage (qu'il corresponde aux schémas, qu'aucun fil n'est cassé ou desserré, etc.) et la qualité de la soudure.

**If you are using a MPU-9250 compatible accelerometer and it shows up as `mpu-unknown`, use with caution! They are probably refurbished chips!**

Ensuite, essayez d’exécuter `MEASURE_AXES_NOISE` dans Octoprint, vous devriez obtenir des chiffres de base pour le bruit de fond de l’accéléromètre sur les axes (devraient se situer entre 1 et 100). Un bruit de fond d’axe trop élevé (par exemple 1000 et plus) peut indiquer des problèmes de capteur, des problèmes de puissance ou des ventilateurs déséquilibrés entrainant trop de vibrations sur l'imprimante 3D.

### Mesurer les résonances

Vous pouvez maintenant exécuter les tests réels. Exécutez la commande suivante :

```
TEST_RESONANCES AXIS=X
```

Notez que cela créera des vibrations sur l’axe X. Ce test désactivera les valeurs du formateur d'entrée (aka input shapper) déjà paramétrées. Le test de résonance ne peut pas être fait avec le formateur d'entrée déjà activé.

** Attention ! ** Gardez un œil sur l’imprimante la première fois, pour vous assurer que les vibrations ne deviennent pas trop violentes (la commande `M112` peut être utilisée pour interrompre le test en cas d’urgence - en espérant ne pas avoir à l'utiliser). Si les vibrations deviennent trop fortes, vous pouvez spécifier une valeur inférieure à la valeur par défaut du paramètre `accel_per_hz` dans la section `[resonance_tester]`.

```
[resonance_tester]
accel_chip: adxl345
accel_per_hz: 50  # default is 75
probe_points: ...
```

Si cela fonctionne pour l’axe X, exécutez ensuite la commande pour l’axe Y :

```
TEST_RESONANCES AXIS=Y
```

Cela générera 2 fichiers CSV (`/tmp/resonances_x_*.csv` et `/tmp/resonances_y_*.csv`). Ces fichiers peuvent être traités avec le script autonome sur un Raspberry Pi. Pour ce faire, exécutez les commandes suivantes :

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png
```

Ce script générera les graphiques `/tmp/shaper_calibrate_x.png` et `/tmp/shaper_calibrate_y.png` avec les réponses en fréquence. Vous obtiendrez également les fréquences suggérées pour chaque mode du formateur d'entrée (input shapper), ainsi que la valeur recommandée pour votre configuration. Par exemple :

![Resonances](img/calibrate-y.png)

```
Fitted shaper 'zv' frequency = 34.4 Hz (vibrations = 4.0%, smoothing ~= 0.132)
To avoid too much smoothing with 'zv', suggested max_accel <= 4500 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 0.0%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 41.4 Hz (vibrations = 0.0%, smoothing ~= 0.188)
To avoid too much smoothing with 'ei', suggested max_accel <= 3200 mm/sec^2
Fitted shaper '2hump_ei' frequency = 51.8 Hz (vibrations = 0.0%, smoothing ~= 0.201)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 61.8 Hz (vibrations = 0.0%, smoothing ~= 0.215)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2800 mm/sec^2
Recommended shaper is mzv @ 34.6 Hz
```

La configuration suggérée peut être ajoutée à la section `[input_shaper]` de `printer.cfg`, par exemple :

```
[input_shaper]
shaper_freq_x: ...
shaper_type_x: ...
shaper_freq_y: 34.6
shaper_type_y: mzv

[printer]
max_accel: 3000  # Ne devrait pas dépasser les valeurs estimées d'accélération calculées pour les axes X et Y
```

Ou vous pouvez choisir vous-même une autre configuration en fonction des graphiques générés : les pics de densité spectrale de puissance sur les graphiques correspondent aux fréquences de résonance de l’imprimante.

Notez que vous pouvez également exécuter l'auto-calibration du shaper d'entrée à partir de Klipper [directement](#input-shaper-auto-calibration), ce qui peut être pratique, par exemple, pour le shaper d'entrée [re-calibration](#input-shaper-re-calibration).

### Imprimantes cartésiennes à lit mobile

Si votre imprimante est une imprimante cartésienne dont le plateau est mobile sur l'axe Y, vous devrez changer l’emplacement de l’accéléromètre entre les mesures des axes X et Y : mesurez les résonances de l’axe X avec l’accéléromètre fixé à la tête et les résonances de l’axe Y - au lit (la configuration habituelle des imprimantes cartésiennes).

However, you can also connect two accelerometers simultaneously, though the ADXL345 must be connected to different boards (say, to an RPi and printer MCU board), or to two different physical SPI interfaces on the same board (rarely available). Then they can be configured in the following manner:

```
[adxl345 hotend]
# En considérant que l'adxl de la tête connectée au RPI
cs_pin: rpi:None

[adxl345 bed]
# En considérant que l'adxl du lit est connecté au MCU
cs_pin: ...  # Printer board SPI chip select (CS) pin

[resonance_tester]
# En considérant un montage standard pour une imprimante cartésienne
accel_chip_x: adxl345 hotend
accel_chip_y: adxl345 bed
probe_points: ...
```

Two MPUs can share one I2C bus, but they **cannot** measure simultaneously as the 400kbit/s I2C bus is not fast enough. One must have its AD0 pin pulled-down to 0V (address 104) and the other its AD0 pin pulled-up to 3.3V (address 105):

```
[mpu9250 hotend]
i2c_mcu: rpi
i2c_bus: i2c.1
i2c_address: 104 # This MPU has pin AD0 pulled low

[mpu9250 bed]
i2c_mcu: rpi
i2c_bus: i2c.1
i2c_address: 105 # This MPU has pin AD0 pulled high

[resonance_tester]
# Assuming the typical setup of the bed slinger printer
accel_chip_x: mpu9250 hotend
accel_chip_y: mpu9250 bed
probe_points: ...
```

[Test with each MPU individually before connecting both to the bus for easy debugging.]

Ensuite, les commandes `TEST_RESONANCES AXIS=X` et `TEST_RESONANCES AXIS=Y` utiliseront le bon accéléromètre pour chaque axe.

### Lissage maximum

Gardez à l'esprit que le formateur d'entrée (input shapper) peut créer un lissage sur certaines parties de l'impression. Le réglage automatique du formateur d'entrée effectué par le script `calibrate_shaper.py` ou la commande `SHAPER_CALIBRATE` essaie de limiter le lissage, mais il essaie aussi de minimiser les vibrations résultantes. Cela peut conduire parfois, à un choix peu optimisé de la fréquence du formateur d'entrée ou peut-être préférez-vous simplement avoir moins de lissage dans certaines parties de l'impression au détriment des vibrations restantes. Dans ces cas, vous pouvez demander de limiter le lissage maximal à partir du formateur d'entrée.

Regardons les résultats suivants du réglage automatique :

![Resonances](img/calibrate-x.png)

```
Fitted shaper 'zv' frequency = 57.8 Hz (vibrations = 20.3%, smoothing ~= 0.053)
To avoid too much smoothing with 'zv', suggested max_accel <= 13000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.8 Hz (vibrations = 3.6%, smoothing ~= 0.168)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3600 mm/sec^2
Fitted shaper 'ei' frequency = 48.8 Hz (vibrations = 4.9%, smoothing ~= 0.135)
To avoid too much smoothing with 'ei', suggested max_accel <= 4400 mm/sec^2
Fitted shaper '2hump_ei' frequency = 45.2 Hz (vibrations = 0.1%, smoothing ~= 0.264)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2200 mm/sec^2
Fitted shaper '3hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.356)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 1500 mm/sec^2
Recommended shaper is 2hump_ei @ 45.2 Hz
```

Notez que les valeurs rapportées `smoothing` sont des valeurs projetées abstraites. Ces valeurs peuvent être utilisées pour comparer différentes configurations : plus la valeur est élevée, plus le formateur d'entrée créera de lissage. Cependant, ces scores de lissage ne représentent aucune mesure réelle du lissage, car le lissage réel dépend des paramètres [`max_accel`](#selecting-max-accel) et `square_corner_velocity`. Par conséquent, vous devrez faire des impressions de test pour voir exactement le lissage créé par la configuration choisie.

Dans l'exemple ci-dessus, les paramètres de mise en forme suggérés ne sont pas mauvais, mais que se passe-t-il si vous souhaitez obtenir moins de lissage sur l'axe X ? Vous pouvez essayer de limiter le lissage maximal du formateur d'entrée à l'aide de la commande suivante :

```
~/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png --max_smoothing=0.2
```

ce qui limite le lissage à un score de 0,2. Vous pouvez maintenant obtenir le résultat suivant :

![Resonances](img/calibrate-x-max-smoothing.png)

```
Fitted shaper 'zv' frequency = 55.4 Hz (vibrations = 19.7%, smoothing ~= 0.057)
To avoid too much smoothing with 'zv', suggested max_accel <= 12000 mm/sec^2
Fitted shaper 'mzv' frequency = 34.6 Hz (vibrations = 3.6%, smoothing ~= 0.170)
To avoid too much smoothing with 'mzv', suggested max_accel <= 3500 mm/sec^2
Fitted shaper 'ei' frequency = 48.2 Hz (vibrations = 4.8%, smoothing ~= 0.139)
To avoid too much smoothing with 'ei', suggested max_accel <= 4300 mm/sec^2
Fitted shaper '2hump_ei' frequency = 52.0 Hz (vibrations = 2.7%, smoothing ~= 0.200)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 3000 mm/sec^2
Fitted shaper '3hump_ei' frequency = 72.6 Hz (vibrations = 1.4%, smoothing ~= 0.155)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 3900 mm/sec^2
Recommended shaper is 3hump_ei @ 72.6 Hz
```

Si vous comparez avec les précédents paramètres suggérés, les vibrations sont un peu plus importantes, mais le lissage est nettement plus faible qu'auparavant, ce qui permet une accélération maximale plus importante.

Lorsque vous choisissez le paramètre `max_smoothing`, vous pouvez utiliser une approche par essais et erreurs. Essayez quelques valeurs différentes et voyez quels résultats vous obtenez. Notez que le lissage réel produit par le formateur d'entrée dépend principalement de la fréquence de résonance la plus basse de l'imprimante : plus la fréquence de résonance la plus basse est élevée, plus le lissage est faible. Par conséquent, si vous demandez au script de trouver une configuration du formateur d'entrée avec un lissage irréaliste, cela se fera au détriment d'une résonance accrue aux fréquences les plus basses (généralement, les plus visibles dans les impressions). Vérifiez donc toujours les vibrations restantes projetées signalées par le script et assurez-vous qu'elles ne sont pas trop élevées.

Notez que si vous avez trouvé une bonne valeur de `max_smoothing` pour vos deux axes, vous pouvez la stocker dans `printer.cfg` comme

```
[resonance_tester]
accel_chip: ...
probe_points: ...
max_smoothing: 0.25  # valeur exemple
```

Ensuite, si vous [réexécutez](#input-shaper-re-calibration) le réglage automatique du formateur d'entrée à l'aide de la commande `SHAPER_CALIBRATE`, c'est cette valeur stockée `max_smoothing` qui sera prise comme référence.

### Sélection de max_accel

Étant donné que le formateur d'entrée peut créer un certain lissage dans les pièces, en particulier avec des accélérations élevées, vous devrez toujours choisir une valeur `max_accel` ne créant pas trop de lissage dans les pièces imprimées. Un script d'étalonnage fournit une estimation du paramètre `max_accel` qui ne devrait pas créer trop de lissage. Notez que le `max_accel` tel qu'affiché par le script de calibrage n'est qu'un maximum théorique auquel le formateur d'entrée est encore capable de travailler sans produire trop de lissage. Il ne s'agit en aucun cas d'une recommandation pour définir cette accélération sur vos impressions. L'accélération maximale supportée par votre imprimante dépend de ses propriétés mécaniques et du couple maximal des moteurs pas à pas utilisés. Par conséquent, il est suggéré de définir un `max_accel` dans la section `[printer]` qui ne dépasse pas les valeurs estimées pour les axes X et Y, probablement avec une marge de sécurité.

Vous pouvez également suivre [cette partie](Resonance_Compensation.md#selecting-max_accel) du guide de réglage du formateur d'entrée et imprimer un modèle de test pour choisir le paramètre `max_accel` de manière expérimentale.

Même remarque pour l'[auto-calibration](#input-shaper-auto-calibration) du formateur d'entrée avec la commande `SHAPER_CALIBRATE` : il faut encore choisir la bonne valeur `max_accel` après l'auto-calibrage, notez que les limites d'accélérations suggérées ne sont pas appliquées automatiquement.

Si vous effectuez un ré-étalonnage du formateur d'entrée et que le lissage indiqué pour la configuration de formateur suggérée est pratiquement le même que celui obtenu lors du calibrage précédent, cette étape peut être ignorée.

### Test des axes personnalisés

la commande ` TEST_RESONANCES` prend en charge les axes personnalisés. Bien que cela ne soit pas vraiment utile pour l’étalonnage des input shaper, cela peut être utilisé pour étudier en profondeur les résonances de l’imprimante et vérifier, par exemple, la tension de la courroie.

Pour vérifier la tension de la courroie sur les imprimantes CoreXY, exécutez

```
TEST_RESONANCES AXIS=1,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=1,-1 OUTPUT=raw_data
```

et utilisez `graph_accelerometer.py` pour traiter les fichiers générés.

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

qui générera `/tmp/résonances.png` en comparant les résonances.

Pour les imprimantes Delta avec le placement des tours par défaut (tour A ~= 210 degrés, B ~= 330 degrés et C ~= 90 degrés), exécutez

```
TEST_RESONANCES AXIS=0,1 OUTPUT=raw_data
TEST_RESONANCES AXIS=-0.866025404,-0.5 OUTPUT=raw_data
TEST_RESONANCES AXIS=0.866025404,-0.5 OUTPUT=raw_data
```

puis utilisez la même commande

```
~/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/resonances.png
```

pour générer le fichier de comparaison des résonnances `/tmp/résonances.png`.

## Calibrage automatique du formateur d'entrée

En plus de choisir manuellement les paramètres appropriés pour la fonction de formateur d'entrée, il est également possible d'exécuter le réglage automatique du formateur d'entrée directement à partir de Klipper. Exécutez la commande suivante via le terminal Octoprint :

```
SHAPER_CALIBRATE
```

Cela exécutera le test complet pour les deux axes et générera la sortie csv (`/tmp/calibration_data_*.csv` par défaut) pour la réponse en fréquence et les formateurs d'entrée suggérés. Vous obtiendrez également les fréquences suggérées pour chaque formateur, ainsi que le modèle de formateur d'entrée recommandé pour votre configuration, sur la console Octoprint. Par exemple :

```
Calculating the best input shaper parameters for y axis
Fitted shaper 'zv' frequency = 39.0 Hz (vibrations = 13.2%, smoothing ~= 0.105)
To avoid too much smoothing with 'zv', suggested max_accel <= 5900 mm/sec^2
Fitted shaper 'mzv' frequency = 36.8 Hz (vibrations = 1.7%, smoothing ~= 0.150)
To avoid too much smoothing with 'mzv', suggested max_accel <= 4000 mm/sec^2
Fitted shaper 'ei' frequency = 36.6 Hz (vibrations = 2.2%, smoothing ~= 0.240)
To avoid too much smoothing with 'ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '2hump_ei' frequency = 48.0 Hz (vibrations = 0.0%, smoothing ~= 0.234)
To avoid too much smoothing with '2hump_ei', suggested max_accel <= 2500 mm/sec^2
Fitted shaper '3hump_ei' frequency = 59.0 Hz (vibrations = 0.0%, smoothing ~= 0.235)
To avoid too much smoothing with '3hump_ei', suggested max_accel <= 2500 mm/sec^2
Recommended shaper_type_y = mzv, shaper_freq_y = 36.8 Hz
```

Si vous êtes d'accord avec les paramètres suggérés, vous pouvez exécuter `SAVE_CONFIG` maintenant pour les enregistrer et redémarrer Klipper. Notez que cela ne mettra pas à jour la valeur `max_accel` dans la section `[printer]`. Vous devrez la mettre à jour manuellement en suivant les recommandations de la section [Choisir l'accélération maximale](#selecting-max_accel).

Si votre imprimante est une imprimante cartésienne, vous pouvez préciser l'axe à tester, afin de pouvoir modifier le point de montage de l'accéléromètre entre les tests (par défaut, le test est effectué pour les deux axes) :

```
SHAPER_CALIBRATE AXIS=Y
```

Vous pouvez exécuter `SAVE_CONFIG` deux fois - après avoir calibré chaque axe.

Cependant, si vous avez connecté deux accéléromètres simultanément, vous pouvez exécutez simplement `SHAPER_CALIBRATE` sans spécifier d'axe pour calibrer les formateurs d'entrée des deux axes en une seule fois.

### Ré-étalonnage du formateur d'entrée (aka input shapper)

La commande `SHAPER_CALIBRATE` peut également être utilisée pour recalibrer le formateur d'entrée ultérieurement, en particulier si des modifications de l'imprimante pouvant affecter sa cinématique sont apportées. On peut soit relancer l'étalonnage complet à l'aide de la commande `SHAPER_CALIBRATE`, soit restreindre l'auto-étalonnage à un seul axe en fournissant le paramètre `AXIS=`, comme

```
SHAPER_CALIBRATE AXIS=X
```

**Attention !** Il n'est pas conseillé d'exécuter l'auto-calibrage du shaper trop fréquemment (par exemple, avant chaque impression ou tous les jours). Afin de déterminer les fréquences de résonance, l'auto-calibrage crée des vibrations intenses sur chacun des axes. Généralement, les imprimantes 3D ne sont pas conçues pour résister à une exposition prolongée à des vibrations proches des fréquences de résonance. Cela pourrait augmenter l'usure des composants de l'imprimante et réduire leur durée de vie. Il existe également un risque accru que certaines pièces se dévissent ou se desserrent. Vérifiez toujours que toutes les pièces de l'imprimante (y compris celles qui ne peuvent normalement pas bouger) sont solidement fixées en place après chaque réglage automatique.

De plus, en raison d'un certain bruit dans les mesures, il est possible que les résultats de réglage soient légèrement différents d'un calibrage à l'autre. Ce bruit ne devrait pas trop affecter la qualité d'impression. Cependant, il est conseillé de revérifier les paramètres suggérés et d'imprimer des tests d'impression avant de les utiliser pour confirmer qu'ils sont corrects.

## Traitement hors ligne des données de l’accéléromètre

Il est possible de générer les données brutes de l’accéléromètre et de les traiter hors ligne (par exemple sur une machine hôte), par exemple pour trouver des résonances. Pour ce faire, exécutez les commandes suivantes via le terminal Octoprint :

```
SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0
TEST_RESONANCES AXIS=X OUTPUT=raw_data
```

ignorez toute erreur pour la commande `SET_INPUT_SHAPER`. Pour la commande `TEST_RESONANCES`, spécifiez l’axe de test souhaité. Les données brutes seront écrites dans le répertoire `/tmp` sur le RPi.

Les données brutes peuvent également être obtenues en exécutant la commande `ACCELEROMETER_MEASURE` deux fois - d’abord pour démarrer les mesures, puis pour les arrêter et écrire le fichier de sortie. Reportez-vous à [G-Codes](G-Codes.md#adxl345) pour plus de détails.

Les données peuvent être traitées ultérieurement avec les scripts suivants : `scripts/graph_accelerometer.py` et `scripts/calibrate_shaper.py`. Les deux acceptent un ou plusieurs fichiers csv bruts comme entrée en fonction du mode. Le script graph_accelerometer.py prend en charge plusieurs modes de fonctionnement :

* pour le traçage des données brutes de l’accéléromètre (utilisez le paramètre `-r`), seule 1 entrée est prise en charge ;
* tracer une réponse en fréquence (aucun paramètre supplémentaire n'est requis), si plusieurs entrées sont spécifiées, la réponse en fréquence moyenne est calculée ;
* comparaison de la réponse en fréquence entre plusieurs entrées (utiliser le paramètre `-c`) ; vous pouvez également spécifier l’axe de l’accéléromètre à prendre en compte via le paramètre `-a x`, `-a y` ou `-a z` (si aucun n’est spécifié, la somme des vibrations pour tous les axes est utilisée) ;
* traçage du spectrogramme (utiliser le paramètre `-s`), seule 1 entrée est prise en charge ; vous pouvez également spécifier l’axe de l’accéléromètre à prendre en compte via le paramètre `-a x`, `-a y` ou `-a z` (si aucun n’est spécifié, la somme des vibrations pour tous les axes est utilisée).

Notez que graph_accelerometer.py script ne prend en charge que les fichiers raw_data\*.csv et non les fichiers resonances\*.csv ou calibration_data\*.csv.

Par exemple,

```
~/klipper/scripts/graph_accelerometer.py /tmp/raw_data_x_*.csv -o /tmp/resonances_x.png -c -a z
```

tracera la comparaison de plusieurs fichiers `/tmp/raw_data_x_*.csv` pour l’axe Z dans le fichier `/tmp/resonances_x.png`.

Le script shaper_calibrate.py accepte 1 ou plusieurs entrées et peut exécuter le réglage automatique de l'input shaper et suggérer les meilleurs paramètres pour les entrées fournies. Il affiche les paramètres suggérés sur la console et peut en outre générer un graphique si le paramètre `-o output.png` est fourni, ou un fichier CSV si le paramètre `-c output.csv` est spécifié.

Fournir plusieurs entrées à shaper_calibrate.py script peut être utile si vous exécutez un réglage avancé de l'input shaper, par exemple :

* Exécutez `TEST_RESONANCES AXIS=X OUTPUT=raw_data` (et `Y` axe) pour un seul axe deux fois sur une imprimante cartésienne avec l’accéléromètre fixé à la tête d’outil la première fois, et l’accéléromètre fixé au lit la deuxième fois afin de détecter les résonances croisées des axes et de tenter de les annuler avec l'input shaper.
* Exécutez `TEST_RESONANCES AXIS=Y OUTPUT=raw_data` deux fois sur le lit avec un lit en verre et une surface magnétique (plus légère) pour trouver les paramètres d'input shaper qui fonctionnent bien pour n’importe quelle configuration de surface d’impression.
* Combinaison des données de résonance de plusieurs points de test.
* Combinaison des données de résonance à partir de 2 axes (par exemple, sur une imprimante cartésienne pour configurer les input_shaper de l’axe X à partir des résonances des axes X et Y pour annuler les vibrations du lit * * au cas où la buse « attraperait » une impression lors du déplacement dans la direction de l’axe X).
