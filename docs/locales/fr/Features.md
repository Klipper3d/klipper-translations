# Caractéristiques

Klipper propose plusieurs caractéristiques intéressantes :

* Mouvement pas à pas de haute précision. Klipper utilise un processeur d'application (comme un Raspberry Pi à bas prix) pour calculer les mouvements de l'imprimante. Le processeur d'application détermine le moment où il faut faire marcher chaque moteur pas à pas, il compresse ces événements, les transmet au microcontrôleur, puis le microcontrôleur exécute chaque événement au moment demandé. Chaque événement du moteur pas à pas est programmé avec une précision de 25 microsecondes ou mieux. Le logiciel n'utilise pas d'estimations cinématiques (telles que l'algorithme de Bresenham), mais calcule des temps de pas précis basés sur la physique de l'accélération et la physique de la cinématique de la machine. Un mouvement plus précis des pas se traduit par un fonctionnement plus silencieux et plus stable de l'imprimante.
* Best in class performance. Klipper is able to achieve high stepping rates on both new and old micro-controllers. Even old 8bit micro-controllers can obtain rates over 175K steps per second. On more recent micro-controllers, several million steps per second are possible. Higher stepper rates enable higher print velocities. The stepper event timing remains precise even at high speeds which improves overall stability.
* Klipper prend en charge les imprimantes dotées de plusieurs microcontrôleurs. Par exemple, un microcontrôleur peut être utilisé pour contrôler l'extrudeur, tandis qu'un autre contrôle les pièces chauffantes de l'imprimante, et un troisième s'occupe du reste de l'imprimante. Le logiciel Klipper met en œuvre la synchronisation de l'horloge pour tenir compte de la dérive entre les microcontrôleurs. Il n'y a pas besoin de code particulier pour activer plusieurs microcontrôleurs - il suffit de quelques lignes supplémentaires dans le fichier de configuration.
* Configuration grâce à un fichier de configuration unique. Il n'est pas nécessaire de reflasher le microcontrôleur pour modifier un paramètre. Toute la configuration de Klipper est stockée dans un fichier de configuration standard qui peut être facilement modifié. Cela facilite la configuration et la maintenance du matériel.
* Klipper prend en charge la fonction "Smooth Pressure Advance", un mécanisme permettant de prendre en compte les effets de la pression dans un extrudeur. Cela réduit le "suintement" de l'extrudeur et améliore la qualité des d'impression des coins. L'implémentation de Klipper n'introduit pas de changements instantanés de la vitesse de l'extrudeur, ce qui améliore la stabilité et la robustesse générales.
* Klipper prend en charge la fonction "Input Shaping" pour réduire l'impact des vibrations sur la qualité d'impression. Cela peut réduire ou éliminer le "ringing" (également appelé "ghosting", "echoing" ou "rippling") des impressions. Cela peut également permettre d'obtenir des vitesses d'impression plus rapides tout en maintenant une qualité d'impression élevée.
* Klipper utilise un "solveur itératif" pour calculer des temps de pas précis à partir d'équations cinématiques simples. Cela facilite le portage de Klipper sur de nouveaux types de robots et permet de conserver un timing précis même avec une cinématique complexe (aucune "segmentation de ligne" n'est nécessaire).
* Code portable. Klipper fonctionne sur les micro-contrôleurs basés sur ARM, AVR et PRU. Les imprimantes existantes de type "reprap" peuvent utiliser Klipper sans modification matérielle - il suffit d'ajouter un Raspberry Pi. La conception interne du code de Klipper facilite le support d'autres architectures de micro-contrôleurs.
* Un code plus simple. Klipper utilise un langage de très haut niveau (Python) pour la plupart du code. Les algorithmes cinématiques, l'analyse du code G, les algorithmes de chauffage et de thermistance, etc. sont tous écrits en Python. Il est donc plus facile de développer de nouvelles fonctionnalités.
* Macros programmables personnalisées. De nouvelles commandes G-Code peuvent être définies dans le fichier de configuration de l'imprimante (aucune modification du code n'est alors nécessaire). Ces commandes sont programmables - ce qui leur permet de produire différentes actions selon l'état de l'imprimante.
* Serveur d’API intégré. En plus de l’interface G-Code standard, Klipper prend en charge une interface d’application en JSON. Cela permet aux programmeurs de créer des applications externes avec un contrôle précis de l’imprimante.

## Caractéristiques supplémentaires

Klipper prend en charge de nombreuses fonctionnalités standard des imprimantes 3d :

* Fonctionne avec Octoprint. Cela permet de contrôler l'imprimante à l'aide d'un navigateur web ordinaire. Le même Raspberry Pi qui fait tourner Klipper peut aussi faire tourner Octoprint.
* Standard G-Code support. Common g-code commands that are produced by typical "slicers" (SuperSlicer, Cura, PrusaSlicer, etc.) are supported.
* Prise en charge de l'extrusion multiple. Les extrudeurs avec réchauffeurs partagés et les extrudeurs sur chariots indépendants (IDEX) sont également prises en charge.
* Support for cartesian, delta, corexy, corexz, hybrid-corexy, hybrid-corexz, rotary delta, polar, and cable winch style printers.
* Support du nivellement automatique du bed. Klipper peut être configuré pour une détection de base de l'inclinaison du bed ou pour une mise à niveau complète de celui-ci. Si le bed utilise plusieurs steppers Z, Klipper peut également le mettre à niveau en manipulant indépendamment les steppers Z. La plupart des capteurs de hauteur Z sont prises en charge, y compris les sondes BL-Touch et les sondes activées par servomoteur.
* Prise en charge du calibrage delta automatique. L'outil d'étalonnage peut effectuer un étalonnage de base de la hauteur ainsi qu'un avancé des dimensions X et Y. L'étalonnage peut être effectué avec un palpeur de l'axe Z ou manuellement.
* Support for common temperature sensors (eg, common thermistors, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D, DS18B20, and LM75). Custom thermistors and custom analog temperature sensors can also be configured. One can monitor the internal micro-controller temperature sensor and the internal temperature sensor of a Raspberry Pi.
* Protection thermique basique de l'appareil activée par défaut.
* Support for standard fans, nozzle fans, and temperature controlled fans. No need to keep fans running when the printer is idle. Fan speed can be monitored on fans that have a tachometer.
* Prise en charge de la configuration en temps réel des pilotes de moteurs pas à pas TMC2130, TMC2208/TMC2224, TMC2209, TMC2660 et TMC5160. Il existe également un support pour le contrôle du courant des pilotes pas à pas traditionnels via AD5206, MCP4451, MCP4728, MCP4018 et les broches PWM.
* Prise en charge des écrans LCD courants fixés directement à l'imprimante. Un menu par défaut est également disponible. Le contenu de l'écran et du menu peut être entièrement personnalisé via le fichier de configuration.
* Accélération constante et prise en charge du "look-ahead". Tous les mouvements de l'imprimante s'accélèrent progressivement de l'arrêt à la vitesse de croisière, puis décélèrent pour revenir à l'arrêt. Le flux entrant de commandes de mouvement en G-Code est mis en file d'attente et analysé - l'accélération entre les mouvements dans une direction similaire sera optimisée pour réduire les blocages d'impression et améliorer le temps d'impression global.
* Klipper met en œuvre un algorithme de "fin de phase pas à pas" qui peut améliorer la précision des interrupteurs de butée. Lorsqu'il est correctement réglé, il peut améliorer l'adhérence de la première couche d'une impression.
* Support for filament presence sensors, filament motion sensors, and filament width sensors.
* Support pour la mesure et l'enregistrement de l'accélération en utilisant un accéléromètre adxl345.
* Prise en charge de la limitation de la vitesse maximale des mouvements courts en "zigzag" pour réduire les vibrations et le bruit de l'imprimante. Voir le document [Cinématiques](Kinematics.md) pour plus d'informations.
* Des exemples de fichiers de configuration sont disponibles pour de nombreuses imprimantes courantes. Consultez le [répertoire config](../config/) pour en obtenir la liste.

Pour commencer avec Klipper, lisez le guide d'[installation](Installation.md).

## Tests de performance du stepper

Ci-après les résultats des tests de performance du stepper. Les chiffres indiqués représentent le nombre total de pas par seconde sur le micro-contrôleur.

| Microcontrôleur | 1 stepper active | 3 steppers actifs |
| --- | --- | --- |
| AVR 16Mhz | 157K | 99K |
| AVR 20Mhz | 196K | 123K |
| Arduino Zero (SAMD21) | 686K | 471K |
| STM32F042 | 814K | 578K |
| PRU Beaglebone | 866K | 708K |
| "Blue Pill" (STM32F103) | 1180K | 818K |
| Arduino Due (SAM3X8E) | 1273K | 981K |
| Duet2 Maestro (SAM4S8C) | 1690K | 1385K |
| Smoothieboard (LPC1768) | 1923K | 1351K |
| Smoothieboard (LPC1769) | 2353K | 1622K |
| Raspberry Pi Pico (RP2040) | 2400K | 1636K |
| Duet2 Wifi/Eth (SAM4E8E) | 2500K | 1674K |
| Adafruit Metro M4 (SAMD51) | 3077K | 1885K |
| BigTreeTech SKR Pro (STM32F407) | 3652K | 2459K |
| Fysetc Spider (STM32F446) | 3913K | 2634K |

Further details on the benchmarks are available in the [Benchmarks document](Benchmarks.md).
