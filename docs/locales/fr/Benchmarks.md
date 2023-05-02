# Tests

Ce document décrit les benchmarks Klipper.

## Bancs d'essai des microcontrôleurs

Cette section décrit le mécanisme utilisé pour générer les bancs d'essais (benchmarks) de fréquence de pas du microcontrôleur Klipper.

L'objectif principal des bancs d'essais est de fournir un mécanisme cohérent pour mesurer l'impact des changements de codage dans le logiciel. Un objectif secondaire est de fournir des mesures de haut niveau pour comparer les performances entre puces et entre plateformes logicielles.

Le test de vitesse des moteurs pas à pas est conçu pour trouver la fréquence de pas maximale que le matériel et le logiciel peuvent atteindre. Ce taux de pas de référence n'est pas réalisable dans une utilisation "réelle" de Klipper car il doit effectuer d'autres tâches (par exemple, la communication microcontrôleur(s)/hôte, la lecture de la température, la vérification des fin de course).

En général, les broches pour les tests sont choisies pour faire clignoter des LED ou d'autres actions inoffensives. **Vérifiez toujours qu'il est sûr de commander les broches configurées avant d'exécuter un test.** Il n'est pas recommandé de piloter un moteur pas à pas lors d'un test.

### Test du taux de pas

Le test est effectué à l'aide de l'outil console.py (décrit dans <Debugging.md>). Le microcontrôleur est configuré pour la plate-forme matérielle (voir ci-dessous), puis ce qui suit est copié-collé dans la fenêtre du terminal console.py :

```
SET start_clock {clock+freq}
SET ticks 1000

reset_step_clock oid=0 clock={start_clock}
set_next_step_dir oid=0 dir=0
queue_step oid=0 interval={ticks} count=60000 add=0
set_next_step_dir oid=0 dir=1
queue_step oid=0 interval=3000 count=1 add=0

reset_step_clock oid=1 clock={start_clock}
set_next_step_dir oid=1 dir=0
queue_step oid=1 interval={ticks} count=60000 add=0
set_next_step_dir oid=1 dir=1
queue_step oid=1 interval=3000 count=1 add=0

reset_step_clock oid=2 clock={start_clock}
set_next_step_dir oid=2 dir=0
queue_step oid=2 interval={ticks} count=60000 add=0
set_next_step_dir oid=2 dir=1
queue_step oid=2 interval=3000 count=1 add=0
```

Ces tests simulent le déplacement de trois moteurs pas à pas simultanément. Si son exécution entraîne une erreur "Rescheduled timer in the past" or "Stepper too far in past", cela indique que le paramètre `ticks` est trop faible (il en résulte une vitesse de pas trop rapide) . L'objectif est de trouver le réglage le plus bas du paramètre ticks qui aboutit de manière fiable à la réussite du test. Il devrait être possible de rechercher par dichotomie le paramètre ticks jusqu'à ce qu'une valeur stable soit trouvée.

En cas d'échec, on peut copier-coller ce qui suit pour effacer l'erreur en vue du prochain test :

```
clear_shutdown
```

Pour obtenir les tests de moteurs pas à pas, la même séquence de configuration est utilisée, mais seul le premier bloc du test ci-dessus est copié-collé dans la fenêtre console.py.

Pour produire les tests trouvés dans le document [Fonctionnalités](Features.md), le nombre total de pas par seconde est calculé en multipliant le nombre de steppers actifs par la fréquence mcu nominale et en divisant par le paramètre final ticks. Les résultats sont arrondis au K le plus proche. Par exemple, avec trois steppers actifs :

```
ECHO Test result is: {"%.0fK" % (3. * freq / ticks / 1000.)}
```

Les tests sont exécutés avec des paramètres adaptés aux pilotes TMC. Pour les microcontrôleurs prenant en charge `STEPPER_BOTH_EDGE=1` (comme indiqué dans la ligne `MCU config` au premier démarrage de console.py), utilisez `step_pulse_duration=0` et ` invert_step=-1` pour permettre un pas optimisé sur les deux fronts de l'impulsion de pas. Pour les autres microcontrôleurs utiliser un `step_pulse_duration` correspondant à 100ns.

### Test du taux de pas sur AVR

La séquence de configuration suivante est utilisée sur les puces AVR :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PA4 invert_step=0 step_pulse_ticks=32
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=0 step_pulse_ticks=32
config_stepper oid=2 step_pin=PC7 dir_pin=PC6 invert_step=0 step_pulse_ticks=32
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version gcc `avr-gcc (GCC) 5.4.0`. Les tests 16Mhz et 20Mhz ont été exécutés à l'aide d'un simulavr configuré pour un atmega644p (les tests précédents ont confirmé que les résultats du simulavr correspondent aux tests sur un 16Mhz at90usb et un 16Mhz atmega2560).

| avr | ticks |
| --- | --- |
| 1 moteur pas à pas | 102 |
| 3 moteurs pas à pas | 486 |

### Test du taux de pas sur Arduino Due

La séquence de configuration suivante est utilisée sur le Due :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB27 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB26 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA21 dir_pin=PC30 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version de gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam3x8e | ticks |
| --- | --- |
| 1 moteur pas à pas | 66 |
| 3 moteurs pas à pas | 257 |

### Test du taux de pas sur Duet Maestro

La séquence de configuration suivante est utilisée sur le Duet Maestro :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC26 dir_pin=PC18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PC26 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PC26 dir_pin=PB4 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version de gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| sam4s8c | ticks |
| --- | --- |
| 1 moteur pas à pas | 71 |
| 3 moteurs pas à pas | 260 |

### Test du taux de pas sur Duet Wifi

La séquence de configuration suivante est utilisée sur le Duet Wifi :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD6 dir_pin=PD11 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PD7 dir_pin=PD12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PD8 dir_pin=PD13 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur la validation `59314d99` avec la version gcc `gcc version 10.3.1 20210621 (version) (GNU Arm Embedded Toolchain 10.3-2021.07)`.

| sam4e8e | ticks |
| --- | --- |
| 1 moteur pas à pas | 48 |
| 3 moteurs pas à pas | 215 |

### Test du taux de pas sur Beaglebone PRU

La séquence de configuration suivante est utilisée sur le PRU :

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio0_23 dir_pin=gpio1_12 invert_step=0 step_pulse_ticks=20
config_stepper oid=1 step_pin=gpio1_15 dir_pin=gpio0_26 invert_step=0 step_pulse_ticks=20
config_stepper oid=2 step_pin=gpio0_22 dir_pin=gpio2_1 invert_step=0 step_pulse_ticks=20
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version de gcc `pru-gcc (GCC) 8.0.0 20170530 (expérimental)`.

| pru | ticks |
| --- | --- |
| 1 moteur pas à pas | 231 |
| 3 moteurs pas à pas | 847 |

### Test du taux de pas STM32F042

La séquence de configuration suivante est utilisée sur le STM32F042 :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA1 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA3 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB8 dir_pin=PA2 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version de gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f042 | ticks |
| --- | --- |
| 1 moteur pas à pas | 59 |
| 3 moteurs pas à pas | 249 |

### Test du taux de pas sur STM32F103

La séquence de configuration suivante est utilisée sur le STM32F103 :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PC13 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA4 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version de gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32f103 | ticks |
| --- | --- |
| 1 moteur pas à pas | 61 |
| 3 moteurs pas à pas | 264 |

### Test du taux de pas sur STM32F4

La séquence de configuration suivante est utilisée sur le STM32F4 :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA5 dir_pin=PB5 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB2 dir_pin=PB6 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB3 dir_pin=PB7 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version de gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. Les résultats STM32F407 ont été obtenus en exécutant un binaire STM32F407 sur un STM32F446 (et donc en utilisant une horloge de 168 MHz).

| stm32f446 | ticks |
| --- | --- |
| 1 moteur pas à pas | 46 |
| 3 moteurs pas à pas | 205 |

| stm32f407 | ticks |
| --- | --- |
| 1 moteur pas à pas | 46 |
| 3 moteurs pas à pas | 205 |

### Test du taux de pas sur STM32H7

La séquence de configuration suivante est utilisée sur un STM32H743VIT6 :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PD4 dir_pin=PD3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA15 dir_pin=PA8 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PE2 dir_pin=PE3 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `00191b5c` avec la version de gcc `arm-none-eabi-gcc (15:8-2019-q3-1+b1) 8.3.1 20190703 (release) [gcc- 8 branches révision 273027]`.

| stm32h7 | ticks |
| --- | --- |
| 1 moteur pas à pas | 44 |
| 3 moteurs pas à pas | 198 |

### Test du taux de pas sur STM32G0B1

La séquence de configuration suivante est utilisée sur le STM32G0B1 :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PB13 dir_pin=PB12 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB10 dir_pin=PB2 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PB0 dir_pin=PC5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `247cd753` avec la version gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`.

| stm32g0b1 | ticks |
| --- | --- |
| 1 moteur pas à pas | 58 |
| 3 moteurs pas à pas | 243 |

### Test du taux de pas sur LPC176x

La séquence de configuration suivante est utilisée sur le LPC176x :

```
allocate_oids count=3
config_stepper oid=0 step_pin=P1.20 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=P1.21 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=P1.23 dir_pin=P1.18 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version de gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0`. Les résultats du LPC1769 à 120Mhz ont été obtenus en overclockant un LPC1768 à 120Mhz.

| lpc1768 | ticks |
| --- | --- |
| 1 moteur pas à pas | 52 |
| 3 moteurs pas à pas | 222 |

| lpc1769 | ticks |
| --- | --- |
| 1 moteur pas à pas | 51 |
| 3 moteurs pas à pas | 222 |

### Test du taux de pas sur SAMD21

La séquence de configuration suivante est utilisée sur le SAMD21 :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA27 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PB3 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA17 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version de gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` sur un microcontrôleur SAMD21G18.

| samd21 | ticks |
| --- | --- |
| 1 moteur pas à pas | 70 |
| 3 moteurs pas à pas | 306 |

### Test du taux de pas sur SAMD51

La séquence de configuration suivante est utilisée sur le SAMD51 :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PA22 dir_pin=PA20 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PA22 dir_pin=PA21 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PA22 dir_pin=PA19 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` sur un microcontrôleur SAMD51J19A.

| samd51 | ticks |
| --- | --- |
| 1 moteur pas à pas | 39 |
| 3 moteurs pas à pas | 191 |
| 1 moteur pas à pas (200Mhz) | 39 |
| 3 moteurs pas à pas (200Mhz) | 181 |

### Test du taux de pas de l'AR100

La séquence de configuration suivante est utilisée sur le processeur AR100 (Allwinner A64) :

```
allocate_oids count=3
config_stepper oid=0 step_pin=PL10 dir_pin=PE14 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=PL11 dir_pin=PE15 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=PL12 dir_pin=PE16 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `08d037c6` avec la version de gcc `or1k-linux-musl-gcc (GCC) 9.2.0` sur un microcontrôleur Allwinner A64-H.

| AR100 R_PIO | ticks |
| --- | --- |
| 1 moteur pas à pas | 85 |
| 3 moteurs pas à pas | 359 |

### Test du taux de pas sur RP2040

La séquence de configuration suivante est utilisée sur le RP2040 :

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio25 dir_pin=gpio3 invert_step=-1 step_pulse_ticks=0
config_stepper oid=1 step_pin=gpio26 dir_pin=gpio4 invert_step=-1 step_pulse_ticks=0
config_stepper oid=2 step_pin=gpio27 dir_pin=gpio5 invert_step=-1 step_pulse_ticks=0
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version gcc `arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0` sur une carte Raspberry Pi Pico.

| rp2040 | ticks |
| --- | --- |
| 1 moteur pas à pas | 5 |
| 3 moteurs pas à pas | 22 |

### Test du taux de pas pour le MCU Linux

La séquence de configuration suivante est utilisée sur un Raspberry Pi :

```
allocate_oids count=3
config_stepper oid=0 step_pin=gpio2 dir_pin=gpio3 invert_step=0 step_pulse_ticks=5
config_stepper oid=1 step_pin=gpio4 dir_pin=gpio5 invert_step=0 step_pulse_ticks=5
config_stepper oid=2 step_pin=gpio6 dir_pin=gpio17 invert_step=0 step_pulse_ticks=5
finalize_config crc=0
```

Le test a été exécuté pour la dernière fois sur le commit `59314d99` avec la version gcc `gcc (Raspbian 8.3.0-6+rpi1) 8.3.0` sur un Raspberry Pi 3 (révision a02082). Il était difficile d'obtenir des résultats stables dans ce benchmark.

| Linux (RPi3) | ticks |
| --- | --- |
| 1 moteur pas à pas | 160 |
| 3 moteurs pas à pas | 380 |

## Test de répartition des commandes

Le test de répartition des commandes teste le nombre de commandes "factices" que le microcontrôleur peut traiter. Il s'agit principalement d'un test du mécanisme de communication matériel. Le test est exécuté à l'aide de l'outil console.py (décrit dans <Debugging.md>). Ce qui suit est copié-collé dans la fenêtre du terminal console.py :

```
DELAY {clock + 2*freq} get_uptime
FLOOD 100000 0.0 debug_nop
get_uptime
```

Une fois le test terminé, déterminez la différence entre les horloges signalées dans les deux messages de réponse "uptime". Le nombre total de commandes par seconde est alors `100000 * mcu_frequency / clock_diff`.

Notez que ce test peut saturer la capacité USB/CPU d'un Raspberry Pi. En cas d'exécution sur un Raspberry Pi, Beaglebone ou un ordinateur hôte similaire, augmentez le délai (par exemple, `DELAY {clock + 20*freq} get_uptime`). Le cas échéant, les tests de performances ci-dessous concernent console.py exécuté sur une machine de bureau avec l'appareil connecté via un concentrateur à haut débit.

| MCU | Fréquence | Version | Compilateur |
| --- | --- | --- | --- |
| stm32f042 (CAN) | 18K | c105adc8 | arm-none-eabi-gcc (GNU Tools 7-2018-q3-update) 7.3.1 |
| atmega2560 (serial) | 23K | b161a69e | avr-gcc (GCC) 4.8.1 |
| sam3x8e (serial) | 23K | b161a69e | arm-none-eabi-gcc (Fedora 7.1.0-5.fc27) 7.1.0 |
| at90usb1286 (USB) | 75K | 01d2183f | avr-gcc (GCC) 5.4.0 |
| ar100 (série) | 138K | 08d037c6 | or1k-linux-musl-gcc 9.3.0 |
| samd21 (USB) | 223K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| pru (mémoire partagée) | 260K | c5968a08 | pru-gcc (GCC) 8.0.0 20170530 (expérimental) |
| stm32f103 (USB) | 355K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam3x8e (USB) | 418K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1768 (USB) | 534K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| lpc1769 (USB) | 628K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| sam4s8c (USB) | 650K | 8d4a5c16 | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| samd51 (USB) | 864K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| stm32f446 (USB) | 870K | 01d2183f | arm-none-eabi-gcc (Fedora 7.4.0-1.fc30) 7.4.0 |
| rp2040 (USB) | 873K | c5667193 | arm-none-eabi-gcc (Fedora 10.2.0-4.fc34) 10.2.0 |

## Tests de l'hôte

Il est possible d'exécuter des tests de temporisation sur le logiciel hôte en utilisant le mécanisme de traitement "mode batch" (décrit dans <Debugging.md>). Cela se fait généralement en choisissant un fichier G-Code volumineux et complexe et en chronométrant le temps nécessaire au logiciel hôte pour le traiter. Par example :

```
time ~/klippy-env/bin/python ./klippy/klippy.py config/example-cartesian.cfg -i something_complex.gcode -o /dev/null -d out/klipper.dict
```
