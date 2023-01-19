# Versions

Historique de versions de Klipper. Merci de vous référer a la ressource [installation](Installation.md) pour plus d'information sur l'installation de Klipper.

## Klipper 0.11.0

Disponible le 28/11/2022. Changements majeurs dans cette version :

* Optimisation du pilote de moteur pas à pas trinamic "pas sur les deux côtés" ("step on both edges").
* Prise en charge de Python3. Le code hôte Klipper fonctionnera avec Python2 ou Python3.
* Prise en charge améliorée du bus CAN. Prise en charge du bus CAN sur les puces rp2040, stm32g0, stm32h7, same51 et same54. Prise en charge du mode "pont USB vers bus CAN".
* Prise en charge du chargeur de démarrage CanBoot.
* Prise en charge des accéléromètres mpu9250 et mpu6050.
* Amélioration de la gestion des erreurs pour les capteurs de température max31856, max31855, max31865 et max6675.
* Il est désormais possible de configurer les LED pour qu'elles se mettent à jour pendant les longues commandes G-Code à l'aide de la prise en charge du "modèle" de LED.
* Plusieurs améliorations sur le microcontrôleur. Nouvelle prise en charge des puces stm32h743, stm32h750, stm32l412, stm32g0b1, same70, same51 et same54. Prise en charge des lectures i2c sur atsamd et stm32f0. Prise en charge pwm matérielle sur stm32. Envoi d'événements basé sur le signal Linux mcu. Nouveau support rp2040 pour "make flash", i2c et rp2040-e5 USB errata.
* Nouveaux modules ajoutés : angle, dac084S085, exclude_object, led, mpu9250, pca9632, smart_effector, z_thermal_adjust. Nouvelle cinématique "deltésienne" ajoutée. Nouvel outil dump_mcu ajouté.
* Plusieurs corrections de bogues et nettoyages de code.

## Klipper 0.10.0

Disponible le 29/09/2021. Changements majeurs dans cette version :

* Prise en charge de la mise à l'origine "Multi-MCU". Il est désormais possible de câbler un pilote de moteur pas à pas et sa fin de course sur des microcontrôleurs séparés. Cela simplifie le câblage des sondes Z sur les "cartes de tête d'outil".
* Klipper a maintenant un [Serveur Discord](https://discord.klipper3d.org) et un [Serveur Discourse](https://community.klipper3d.org).
* Le [site Web de Klipper](https://www.klipper3d.org) utilise désormais l'infrastructure "mkdocs". Il existe également un projet [Klipper Translations](https://github.com/Klipper3d/klipper-translations).
* Prise en charge automatisée du flash du micrologiciel via une carte SD sur de nombreuses cartes.
* Nouveau support cinématique pour les imprimantes "Hybrid CoreXY" et "Hybrid CoreXZ".
* Klipper utilise maintenant `rotation_distance` pour configurer les distances de déplacement du moteur pas à pas.
* Le code hôte principal de Klipper peut désormais communiquer directement avec les microcontrôleurs via le bus CAN.
* Nouveau système "d'analyse de mouvement". Les mises à jour des mouvements internes de Klipper et les résultats des capteurs peuvent être suivis et enregistrés pour analyse.
* Les pilotes de moteur pas à pas Trinamic sont désormais surveillés en permanence pour les conditions d'erreur.
* Prise en charge du microcontrôleur rp2040 (cartes Raspberry Pi Pico).
* Le système "make menuconfig" utilise maintenant kconfiglib.
* De nombreux modules supplémentaires ajoutés : ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu
* Plusieurs corrections de bogues et nettoyages de code.

## Klipper 0.9.0

Disponible le 20/10/2020. Changements majeurs dans cette version :

* Prise en charge de "Input Shaping" - un mécanisme pour contrer la résonance de l'imprimante. Il peut réduire ou éliminer les "ondulations" dans les impressions.
* Nouveau système "Smooth Pressure Advance". Cela implémente "Pressure Advance" sans introduire de changements de vitesse instantanés. Il est désormais possible de régler l'avance de pression à l'aide d'une méthode "Tour de réglage".
* Nouveau serveur API "webhooks". Fournit une interface JSON programmable à Klipper.
* L'écran LCD et le menu sont désormais configurables à l'aide du langage Jinja2.
* Les pilotes de moteur pas à pas TMC2208 peuvent désormais être utilisés en mode "standalone" avec Klipper.
* Prise en charge améliorée du BL-Touch v3.
* Identification USB améliorée. Klipper dispose désormais de son propre code d'identification USB et les micro-contrôleurs peuvent désormais signaler leurs numéros de série lors de l'identification USB.
* Nouveau support cinématique pour les imprimantes "Rotary Delta" et "CoreXZ".
* Améliorations du microcontrôleur : prise en charge de stm32f070, prise en charge de stm32f207, prise en charge des broches GPIO sur "Linux MCU", prise en charge du "chargeur de démarrage HID" stm32, prise en charge du chargeur de démarrage Chitu, prise en charge du chargeur de démarrage MKS Robin.
* Amélioration de la gestion des événements Python pour "garbage collection".
* Nombreux modules supplémentaires ajoutés : adc_scaled, adxl345, bme280, display_status, extruder_stepper, fan_generic, hall_filament_width_sensor, htu21d, homing_heaters, input_shaper, lm75, print_stats, resonance_tester, shaper_calibrate, query_adc, graph_accelerometer, graph_extruder, graph_motion, graph_shaper, graph_temp_sensor, whconsole
* Plusieurs corrections de bogues et nettoyages de code.

### Klipper 0.9.1

Disponible le 28/10/2020. Version contenant uniquement des corrections de bogues.

## Klipper 0.8.0

Disponible le 21/10/2019. Changements majeurs dans cette version :

* Prise en charge du nouveau modèle de commande G-Code. Le G-Code dans le fichier de configuration est maintenant évalué avec le langage Jinja2.
* Améliorations de la gestion des pilotes pas à pas Trinamic :
   * Nouvelle prise en charge pour les pilotes TMC2209 et TMC5160.
   * Commandes G-Code DUMP_TMC, SET_TMC_CURRENT et INIT_TMC améliorées.
   * Prise en charge améliorée de la gestion TMC UART avec un multiplexage analogique.
* Prise en charge améliorée de la mise à l'origine, du sondage et de la mise à niveau du lit :
   * Nouveaux modules manual_probe, bed_screws, screw_tilt_adjust, skew_correction, safe_z_home ajoutés.
   * Sondage multi-échantillons amélioré avec une logique de médiane, de moyenne et de nouvel essai.
   * Documentation améliorée pour le BL-Touch, l'étalonnage de la sonde, l'étalonnage de la fin de course, l'étalonnage des imprimantes delta, la mise à l'origine sans capteur et l'étalonnage de la phase de fin de course.
   * Prise en charge améliorée de la mise à l'origine sur un axe Z de grande taille.
* De nombreuses améliorations du micro-contrôleur Klipper :
   * Klipper porté sur : SAM3X8C, SAM4S8C, SAMD51, STM32F042, STM32F4
   * Nouvelles implémentations des pilotes USB CDC sur SAM3X, SAM4, STM32F4.
   * Prise en charge améliorée du flashage de Klipper via USB.
   * Prise en charge du SPI logiciel.
   * Filtrage de température grandement amélioré sur le capteur LPC176x.
   * Les paramètres de démarrage des broches de sortie peuvent être configurés dans le micro-contrôleur.
* Nouveau site web avec la documentation Klipper : http://klipper3d.org/
   * Klipper a maintenant un logo.
* Support expérimental pour la cinématique polaire et "treuil à câble".
* Le fichier de configuration peut maintenant inclure d'autres fichiers de configuration.
* De nombreux modules supplémentaires ajoutés : board_pins, controller_fan, delay_gcode, dotstar, filament_switch_sensor, firmware_retraction, gcode_arcs, gcode_button, heater_generic, manual_stepper, mcp4018, mcp4728, neopixel, pause_resume, respond, temperature_sensor tsl1401cl_filament_width_sensor, tuning_tower
* De nombreuses commandes supplémentaires ajoutées : RESTORE_GCODE_STATE, SAVE_GCODE_STATE, SET_GCODE_VARIABLE, SET_HEATER_TEMPERATURE, SET_IDLE_TIMEOUT, SET_TEMPERATURE_FAN_TARGET
* Plusieurs corrections de bogues et nettoyages de code.

## Klipper 0.7.0

Disponible le 20/12/2018. Changements majeurs dans cette version :

* Klipper prend désormais en charge le nivellement du lit par maillage
* Nouvel étalonnage des imprimantes delta "amélioré" (étalonne les dimensions d'impression x/y sur les imprimantes delta)
* Gestion de la configuration pendant l'exécution des pilotes de moteur pas à pas Trinamic (tmc2130, tmc2208, tmc2660)
* Prise en charge améliorée des capteurs de température : MAX6675, MAX31855, MAX31856, MAX31865, thermistances personnalisées, capteurs de style pt100
* Plusieurs nouveaux modules : temperature_fan, sx1509, force_move, mcp4451, z_tilt, quad_gantry_level, endstop_phase, bltouch
* Plusieurs nouvelles commandes ajoutées : SAVE_CONFIG, SET_PRESSURE_ADVANCE, SET_GCODE_OFFSET, SET_VELOCITY_LIMIT, STEPPER_BUZZ, TURN_OFF_HEATERS, M204, macros g-code personnalisées
* Prise en charge étendue de l'écran LCD :
   * Prise en charge des menus d'exécution
   * Nouvelles icônes d'affichage
   * Prise en charge des écrans "uc1701" et "ssd1306"
* Prise en charge de nouveaux micro-contrôleurs :
   * Klipper porté sur : LPC176x (Smoothieboards), SAM4E8E (Duet2), SAMD21 (Arduino Zero), STM32F103 (appareils "Blue pill"), atmega32u4
   * Nouveau pilote CDC USB générique implémenté sur AVR, LPC176x, SAMD21 et STM32F103
   * Améliorations des performances sur les processeurs ARM
* Le code cinématique a été réécrit pour utiliser un "solveur itératif"
* Nouveaux tests automatisés pour le logiciel hôte Klipper
* De nombreux nouveaux exemples de fichiers de configuration pour les imprimantes les plus courantes
* Mises à jour de la documentation pour les chargeurs de démarrage, l'analyse comparative, le portage des micro-contrôleurs, les vérifications de configuration, le mappage des broches, les paramètres du trancheur, le packaging, et plus
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.6.0

Disponible le 31/03/2018. Changements majeurs dans cette version :

* Vérifications améliorées des défaillances matérielles des éléments chauffants et des thermistances
* Prise en charge des sondes Z
* Première prise en charge de l'étalonnage automatique des paramètres sur les deltas (via une nouvelle commande delta_calibrate)
* Première prise en charge de la compensation d'inclinaison du lit (via la commande bed_tilt_calibrate)
* Première prise en charge de la « mise à l'origine 'sûre' » et des surcharges des mises à l'origine
* Prise en charge de l'affichage de l'état sur les écrans RepRapDiscount style 2004 et 12864
* Nouvelles améliorations pour la multi-extrusion :
   * Prise en charge des chauffages partagés
   * Prise en charge des chariots doubles (IDEX)
* Prise en charge de la configuration de plusieurs steppers par axe (par exemple, double Z)
* Prise en charge des broches de sortie numériques et pwm personnalisées (avec une nouvelle commande SET_PIN)
* Prise en charge d'une "carte SD virtuelle" qui permet d'imprimer directement depuis Klipper (aide sur les machines trop lentes pour bien exécuter OctoPrint)
* Prise en charge du réglage de différentes longueurs de bras sur chaque tour d'une delta
* Prise en charge des commandes G-Code M220/M221 (remplacement du facteur de vitesse/remplacement du facteur d'extrusion)
* Plusieurs mises à jour de la documentation :
   * De nombreux nouveaux exemples de fichiers de configuration pour les imprimantes les plus courantes
   * Nouvel exemple de configuration multi-MCU
   * Nouvel exemple de configuration du capteur bltouch
   * Nouveaux documents sur la FAQ, la vérification de la configuration et le G-Code
* Prise en charge des tests d'intégration continue sur tous les commits github
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.5.0

Disponible le 25/10/2017. Changements majeurs dans cette version :

* Prise en charge des imprimantes avec plusieurs extrudeuses.
* Prise en charge pour l'exécution sur le PRU Beaglebone. Prise en charge de la carte Replicape.
* Prise en charge de l'exécution du code du microcontrôleur dans un processus Linux en temps réel.
* Prise en charge de plusieurs microcontrôleurs. (Par exemple, on pourrait contrôler une extrudeuse avec un microcontrôleur et le reste de l'imprimante avec un autre.) Une synchronisation d'horloge logicielle est mise en œuvre pour coordonner les actions entre les microcontrôleurs.
* Améliorations des performances des moteurs pas à pas (AVR 20Mhz jusqu'à 189K pas par seconde).
* Prise en charge du contrôle des servos et prise en charge de la définition des ventilateurs de refroidissement des buses.
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.4.0

Disponible le 03/05/2017. Changements majeurs dans cette version :

* Installation améliorée sur les machines Raspberry Pi. La majeure partie de l'installation est maintenant scriptée.
* Prise en charge des imprimantes corexy
* Mises à jour de la documentation : nouveau document cinématique, nouveau guide de réglage Pressure Advance, nouveaux exemples de fichiers de configuration, et plus
* Améliorations des performances des moteurs pas à pas (AVR 20Mhz sur 175K pas par seconde, Arduino Due sur 460K)
* Prise en charge des réinitialisations automatiques du microcontrôleur. Prise en charge des réinitialisations via basculement de l'alimentation USB sur Raspberry Pi.
* L'algorithme d'avance de pression fonctionne désormais avec anticipation pour réduire les changements de pression dans les virages.
* Prise en charge de la limitation de la vitesse maximale des mouvements courts en zigzag
* Prise en charge des capteurs AD595
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.3.0

Disponible le 23/12/2016. Changements majeurs dans cette version :

* Documentation améliorée
* Prise en charge des imprimantes avec cinématique delta
* Prise en charge du microcontrôleur Arduino Due (ARM cortex-M3)
* Prise en charge des microcontrôleurs AVR basés sur USB
* Prise en charge de l'algorithme "d'avance de pression" - il réduit le suintement pendant les impressions.
* Nouvelle fonctionnalité "butée de fin de course basée sur la phase de moteurs pas à pas" - permet une plus grande précision sur la prise d'origine de la fin de course.
* Prise en charge des commandes "g-code étendu" telles que "help", "restart" et "status".
* Prise en charge du rechargement de la configuration Klipper et du redémarrage du logiciel hôte en émettant une commande "restart" depuis le terminal.
* Améliorations des performances des moteurs pas à pas (AVR 20Mhz jusqu'à 158K pas par seconde).
* Gestion des erreurs améliorée. La plupart des erreurs sont maintenant affichées via le terminal avec une aide sur la façon de les résoudre.
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.2.0

Première version de Klipper. Disponible le 25/05/2016. Les principales fonctionnalités disponibles dans la version initiale incluent :

* Prise en charge de base des imprimantes cartésiennes (moteurs pas à pas, extrudeur, lit chauffant, ventilateur de refroidissement).
* Prise en charge des commandes g-code de base. Prise en charge de l'interfaçage avec OctoPrint.
* Accélération et gestion de l'anticipation
* Prise en charge des microcontrôleurs AVR via des ports série standard
