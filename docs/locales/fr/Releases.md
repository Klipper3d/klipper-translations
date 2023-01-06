# Versions

Historique de versions de Klipper. Merci de vous référer a la ressource [installation](Installation.md) pour plus d'information sur l'installation de Klipper.

## Klipper 0.11.0

Available on 20221128. Major changes in this release:

* Trinamic stepper motor driver "step on both edges" optimization.
* Support for Python3. The Klipper host code will run with either Python2 or Python3.
* Enhanced CAN bus support. Support for CAN bus on rp2040, stm32g0, stm32h7, same51, and same54 chips. Support for "USB to CAN bus bridge" mode.
* Support for CanBoot bootloader.
* Support for mpu9250 and mpu6050 accelerometers.
* Improved error handling for max31856, max31855, max31865, and max6675 temperature sensors.
* It is now possible to configure LEDs to update during long running G-Code commands using LED "template" support.
* Several micro-controller improvements. New support for stm32h743, stm32h750, stm32l412, stm32g0b1, same70, same51, and same54 chips. Support for i2c reads on atsamd and stm32f0. Hardware pwm support on stm32. Linux mcu signal based event dispatch. New rp2040 support for "make flash", i2c, and rp2040-e5 USB errata.
* New modules added: angle, dac084S085, exclude_object, led, mpu9250, pca9632, smart_effector, z_thermal_adjust. New deltesian kinematics added. New dump_mcu tool added.
* Plusieurs corrections de bogues et nettoyages de code.

## Klipper 0.10.0

Available on 20210929. Major changes in this release:

* Support for "Multi-MCU Homing". It is now possible for a stepper motor and its endstop to be wired to separate micro-controllers. This simplifies wiring of Z probes on "toolhead boards".
* Klipper now has a [Community Discord Server](https://discord.klipper3d.org) and a [Community Discourse Server](https://community.klipper3d.org).
* The [Klipper website](https://www.klipper3d.org) now uses the "mkdocs" infrastructure. There is also a [Klipper Translations](https://github.com/Klipper3d/klipper-translations) project.
* Automated support for flashing firmware via sdcard on many boards.
* New kinematic support for "Hybrid CoreXY" and "Hybrid CoreXZ" printers.
* Klipper now uses `rotation_distance` to configure stepper motor travel distances.
* The main Klipper host code can now directly communicate with micro-controllers using CAN bus.
* New "motion analysis" system. Klipper's internal motion updates and sensor results can be tracked and logged for analysis.
* Trinamic stepper motor drivers are now continuously monitored for error conditions.
* Support for the rp2040 micro-controller (Raspberry Pi Pico boards).
* The "make menuconfig" system now utilizes kconfiglib.
* Many additional modules added: ds18b20, duplicate_pin_override, filament_motion_sensor, palette2, motion_report, pca9533, pulse_counter, save_variables, sdcard_loop, temperature_host, temperature_mcu
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
   * Les premiers paramètres des broches de sortie peuvent être configurés dans le micro-contrôleur.
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
* Mises à jour de la documentation pour les chargeurs de démarrage, l'analyse comparative, le portage des micro-contrôleurs, les vérifications de configuration, le mappage des broches, les paramètres du trancheur, le packaging, etc... .
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.6.0

Disponible le 31/03/2018. Changements majeurs dans cette version :

* Enhanced heater and thermistor hardware failure checks
* Support for Z probes
* Initial support for automatic parameter calibration on deltas (via a new delta_calibrate command)
* Initial support for bed tilt compensation (via bed_tilt_calibrate command)
* Initial support for "safe homing" and homing overrides
* Initial support for displaying status on RepRapDiscount style 2004 and 12864 displays
* New multi-extruder improvements:
   * Support for shared heaters
   * Initial support for dual carriages
* Support for configuring multiple steppers per axis (eg, dual Z)
* Support for custom digital and pwm output pins (with a new SET_PIN command)
* Initial support for a "virtual sdcard" that allows printing directly from Klipper (helps on machines too slow to run OctoPrint well)
* Support for setting different arm lengths on each tower of a delta
* Support for G-Code M220/M221 commands (speed factor override / extrude factor override)
* Several documentation updates:
   * De nombreux nouveaux exemples de fichiers de configuration pour les imprimantes les plus courantes
   * New multiple MCU config example
   * New bltouch sensor config example
   * New FAQ, config check, and G-Code documents
* Initial support for continuous integration testing on all github commits
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.5.0

Available on 20171025. Major changes in this release:

* Support for printers with multiple extruders.
* Initial support for running on the Beaglebone PRU. Initial support for the Replicape board.
* Initial support for running the micro-controller code in a real-time Linux process.
* Support for multiple micro-controllers. (For example, one could control an extruder with one micro-controller and the rest of the printer with another.) Software clock synchronization is implemented to coordinate actions between micro-controllers.
* Stepper performance improvements (20Mhz AVRs up to 189K steps per second).
* Support for controlling servos and support for defining nozzle cooling fans.
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.4.0

Available on 20170503. Major changes in this release:

* Improved installation on Raspberry Pi machines. Most of the install is now scripted.
* Support for corexy kinematics
* Documentation updates: New Kinematics document, new Pressure Advance tuning guide, new example config files, and more
* Stepper performance improvements (20Mhz AVRs over 175K steps per second, Arduino Due over 460K)
* Support for automatic micro-controller resets. Support for resets via toggling USB power on Raspberry Pi.
* The pressure advance algorithm now works with look-ahead to reduce pressure changes during cornering.
* Support for limiting the top speed of short zigzag moves
* Support for AD595 sensors
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.3.0

Available on 20161223. Major changes in this release:

* Improved documentation
* Support for robots with delta kinematics
* Support for Arduino Due micro-controller (ARM cortex-M3)
* Support for USB based AVR micro-controllers
* Support for "pressure advance" algorithm - it reduces ooze during prints.
* New "stepper phased based endstop" feature - enables higher precision on endstop homing.
* Support for "extended g-code" commands such as "help", "restart", and "status".
* Support for reloading the Klipper config and restarting the host software by issuing a "restart" command from the terminal.
* Stepper performance improvements (20Mhz AVRs up to 158K steps per second).
* Improved error reporting. Most errors now shown via the terminal along with help on how to resolve.
* Plusieurs corrections de bogues et nettoyages de code

## Klipper 0.2.0

Initial release of Klipper. Available on 20160525. Major features available in the initial release include:

* Basic support for cartesian printers (steppers, extruder, heated bed, cooling fan).
* Support for common g-code commands. Support for interfacing with OctoPrint.
* Acceleration and lookahead handling
* Support for AVR micro-controllers via standard serial ports
