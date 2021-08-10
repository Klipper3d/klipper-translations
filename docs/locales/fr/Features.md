# Caractéristiques

Klipper propose plusieurs caractéristiques intéressantes :

* Mouvement pas à pas de haute précision. Klipper utilise un processeur d'application (comme un Raspberry Pi à bas prix) pour calculer les mouvements de l'imprimante. Le processeur d'application détermine le moment où il faut faire marcher chaque moteur pas à pas, il compresse ces événements, les transmet au microcontrôleur, puis le microcontrôleur exécute chaque événement au moment demandé. Chaque événement du moteur pas à pas est programmé avec une précision de 25 microsecondes ou mieux. Le logiciel n'utilise pas d'estimations cinématiques (telles que l'algorithme de Bresenham), mais calcule des temps de pas précis basés sur la physique de l'accélération et la physique de la cinématique de la machine. Un mouvement plus précis des pas se traduit par un fonctionnement plus silencieux et plus stable de l'imprimante.
* Meilleures performances de sa catégorie. Klipper est capable d'atteindre des taux de pas élevés sur les micro-contrôleurs nouveaux et anciens. Même les anciens microcontrôleurs 8 bits peuvent obtenir des taux supérieurs à 175 000 pas par seconde. Sur les micro-contrôleurs plus récents, des taux supérieurs à 500 000 pas par seconde sont possibles. Des taux de pas plus élevés permettent des vitesses d'impression plus importantes. La synchronisation des événements pas à pas reste précise même à des vitesses élevées, ce qui améliore la stabilité globale.
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
* Prise en charge du G-Code standard. Les commandes G-Code courantes qui sont produites par les "slicers" classiques sont prises en charge. On peut continuer à utiliser Slic3r, Cura, etc. avec Klipper.
* Prise en charge de l'extrusion multiple. Les extrudeurs avec réchauffeurs partagés et les extrudeurs sur chariots indépendants (IDEX) sont également prises en charge.
* Prise en charge des imprimantes de type cartésien, delta, corexy, corexz, rotatif delta, polaire et treuil à câble.
* Support du nivellement automatique du bed. Klipper peut être configuré pour une détection de base de l'inclinaison du bed ou pour une mise à niveau complète de celui-ci. Si le bed utilise plusieurs steppers Z, Klipper peut également le mettre à niveau en manipulant indépendamment les steppers Z. La plupart des capteurs de hauteur Z sont prises en charge, y compris les sondes BL-Touch et les sondes activées par servomoteur.
* Prise en charge du calibrage delta automatique. L'outil d'étalonnage peut effectuer un étalonnage de base de la hauteur ainsi qu'un avancé des dimensions X et Y. L'étalonnage peut être effectué avec un palpeur de l'axe Z ou manuellement.
* Prise en charge des capteurs de température courants (par exemple, les thermistances courantes, AD595, AD597, AD849x, PT100, PT1000, MAX6675, MAX31855, MAX31856, MAX31865, BME280, HTU21D et LM75). Des thermistances et des capteurs de température analogiques personnalisés peuvent également être configurés.
* Protection thermique basique de l'appareil activée par défaut.
* Prise en charge des ventilateurs standard, des ventilateurs de buses et des ventilateurs contrôlés par la température. Plus besoin de maintenir les ventilateurs en marche lorsque l'imprimante est inactive.
* Prise en charge de la configuration en temps réel des pilotes de moteurs pas à pas TMC2130, TMC2208/TMC2224, TMC2209, TMC2660 et TMC5160. Il existe également un support pour le contrôle du courant des pilotes pas à pas traditionnels via AD5206, MCP4451, MCP4728, MCP4018 et les broches PWM.
* Prise en charge des écrans LCD courants fixés directement à l'imprimante. Un menu par défaut est également disponible. Le contenu de l'écran et du menu peut être entièrement personnalisé via le fichier de configuration.
* Accélération constante et prise en charge du "look-ahead". Tous les mouvements de l'imprimante s'accélèrent progressivement de l'arrêt à la vitesse de croisière, puis décélèrent pour revenir à l'arrêt. Le flux entrant de commandes de mouvement en G-Code est mis en file d'attente et analysé - l'accélération entre les mouvements dans une direction similaire sera optimisée pour réduire les blocages d'impression et améliorer le temps d'impression global.
* Klipper met en œuvre un algorithme de "fin de phase pas à pas" qui peut améliorer la précision des interrupteurs de butée. Lorsqu'il est correctement réglé, il peut améliorer l'adhérence de la première couche d'une impression.
* Support pour la mesure et l'enregistrement de l'accélération en utilisant un accéléromètre adxl345.
* Prise en charge de la limitation de la vitesse maximale des mouvements courts en "zigzag" pour réduire les vibrations et le bruit de l'imprimante. Voir le document [Cinématiques](Kinematics.md) pour plus d'informations.
* Des exemples de fichiers de configuration sont disponibles pour de nombreuses imprimantes courantes. Consultez le [répertoire config](../config/) pour en obtenir la liste.

Pour commencer avec Klipper, lisez le guide d'[installation](Installation.md).

## Tests de performance du stepper

Ci-après les résultats des tests de performance du stepper. Les chiffres indiqués représentent le nombre total de pas par seconde sur le micro-contrôleur.

| Microcontrôleur | Taux de pas le plus rapide | 3 steppers actifs |
| --- | --- | --- |
| AVR 16Mhz | 154K | 102K |
| AVR 20Mhz | 192K | 127K |
| Arduino Zero (SAMD21) | 234K | 217K |
| "Blue Pill" (STM32F103) | 387K | 360K |
| Arduino Due (SAM3X8E) | 438K | 438K |
| Duet2 Maestro (SAM4S8C) | 564K | 564K |
| Smoothieboard (LPC1768) | 574K | 574K |
| Smoothieboard (LPC1769) | 661K | 661K |
| PRU Beaglebone | 680K | 680K |
| Duet2 Wifi/Eth (SAM4E8E) | 686K | 686K |
| Adafruit Metro M4 (SAMD51) | 761K | 692K |
| BigTreeTech SKR Pro (STM32F407) | 922K | 711K |

Sur les plates-formes AVR, le taux de pas le plus élevé est atteint avec un seul stepper. Sur les SAMD21 et STM32F103, le taux de pas le plus élevé est obtenu avec deux pas simultanés. Sur les SAM3X8E, SAM4S8C, SAM4E8E, LPC176x, et PRU, le taux de pas le plus élevé est obtenu avec trois pas simultanés. Sur les SAMD51 et STM32F4, la vitesse de pas la plus élevée est obtenue avec quatre steppers simultanés. (Plus de détails sur les benchmarks sont disponibles dans le document [Tests de performance](Benchmarks.md).
