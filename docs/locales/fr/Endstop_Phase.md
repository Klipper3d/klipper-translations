# Phase de fin de course

Ce document décrit le système de butée ajustée en phase pas à pas de Klipper. Cette fonctionnalité peut améliorer la précision des interrupteurs de fin de course traditionnels. Il est particulièrement utile lors de l'utilisation d'un pilote de moteur pas à pas Trinamic doté d'une configuration d'exécution.

Un interrupteur de fin de course standard a une précision d'environ 100 microns. (Chaque fois qu'un axe est mis à l'origine, le commutateur peut se déclencher légèrement plus tôt ou légèrement plus tard.) Bien qu'il s'agisse d'une erreur relativement faible, elle peut entraîner des artefacts indésirables. En particulier, cet écart de position peut être perceptible lors de l'impression de la première couche d'un objet. En revanche, les moteurs pas à pas standard peuvent obtenir une précision nettement supérieure.

Le mécanisme de fin de course à ajustement de phase peut utiliser la précision des moteurs pas à pas pour améliorer la précision des interrupteurs de fin de course. Un moteur pas à pas se déplace en suivant une série de phase jusqu'à ce qu'il effectue quatre "étapes complètes". Ainsi, un moteur pas à pas utilisant 16 micro-pas aura 64 phases et lorsqu'il se déplace dans le sens positif, il passera par phases : 0, 1, 2, ... 61, 62, 63, 0, 1, 2, etc. Il est important de noter que lorsque le moteur pas à pas se trouve à une position particulière sur un rail linéaire, il doit toujours être à la même phase. Ainsi, lorsqu'un chariot déclenche l'interrupteur de fin de course, le moteur pas à pas contrôlant ce chariot doit toujours être à la même phase du moteur pas à pas. Le système de fin de course à ajustement de phase de Klipper combine la phase du moteur pas à pas avec le déclencheur de fin de course pour améliorer la précision de la fin de course.

Pour utiliser cette fonctionnalité, il est nécessaire de pouvoir identifier la phase du moteur pas à pas. Si l'on utilise les pilotes Trinamic TMC2130, TMC2208, TMC2224 ou TMC2660 en mode de configuration d'exécution (c'est-à-dire pas en mode autonome - "standalone"), Klipper peut interroger la phase pas à pas du pilote. (Il est également possible d'utiliser ce système sur des pilotes pas à pas traditionnels si l'on peut réinitialiser de manière fiable ces pilotes pas à pas - voir ci-dessous pour plus de détails.)

## Étalonnage des phases de fin de course

Si vous utilisez des pilotes de moteurs pas à pas Trinamic avec configuration en temps réel, vous pouvez calibrer les phases de fin de course à l'aide de la commande ENDSTOP_PHASE_CALIBRATE. Commencez par ajouter les éléments suivants au fichier de configuration :

```
[endstop_phase]
```

Redémarrez ensuite l'imprimante et exécutez une commande `G28` suivie d'une commande `ENDSTOP_PHASE_CALIBRATE`. Déplacez ensuite la tête vers un nouvel emplacement et exécutez à nouveau `G28`. Essayez de déplacer la tête à plusieurs endroits différents et réexécutez `G28` à partir de chaque position. Exécutez au moins cinq commandes `G28`.

Après avoir effectué ce qui précède, la commande `ENDSTOP_PHASE_CALIBRATE` signalera souvent la même (ou presque la même) phase pour le moteur pas à pas. Cette phase peut être enregistrée dans le fichier de configuration afin que toutes les futures commandes G28 utilisent cette phase. (Ainsi, dans les futures opérations de prise d'origine, Klipper obtiendra la même position même si la butée de fin de course se déclenche un peu plus tôt ou un peu plus tard.)

Pour enregistrer la phase d'arrêt final d'un moteur pas à pas particulier, exécutez quelque chose comme ceci :

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Exécutez ce qui précède pour tous les steppers que vous souhaitez enregistrer. En règle générale, on l'utiliserait sur stepper_z pour les imprimantes cartésiennes et corexy, et pour stepper_a, stepper_b et stepper_c sur les imprimantes delta. Enfin, exécutez la commande suivante pour mettre à jour le fichier de configuration avec les données :

```
SAVE_CONFIG
```

### Notes complémentaires

* Cette fonctionnalité est particulièrement utile sur les imprimantes delta et sur la butée Z des imprimantes cartésiennes/corexy. Il est possible d'utiliser cette fonctionnalité sur les butées XY des imprimantes cartésiennes, mais cela n'est pas particulièrement utile car une erreur mineure dans la position de la butée X/Y n'aura probablement pas d'impact sur la qualité d'impression. Il n'est pas valide d'utiliser cette fonctionnalité sur les butées XY des imprimantes corexy (car la position XY n'est pas déterminée par un seul stepper sur la cinématique corexy). Il n'est pas valide d'utiliser cette fonctionnalité sur une imprimante utilisant une butée Z "probe:z_virtual_endstop" (car la phase pas à pas n'est stable que si la butée se trouve à un emplacement statique sur un rail).
* Après avoir calibré la phase de fin de course, si la fin de course est déplacée ou ajustée ultérieurement, il sera nécessaire de recalibrer la phase de fin de course. Supprimez les données d'étalonnage du fichier de configuration et réexécutez les étapes ci-dessus.
* Pour utiliser ce système, la butée doit être suffisamment précise pour identifier la position du stepper en deux "pas complets". Ainsi, par exemple, si un stepper utilise 16 micro-pas avec une distance de pas de 0,005 mm, la butée doit avoir une précision d'au moins 0,160 mm. Si l'on obtient des messages d'erreur de type "Endstop stepper_z incorrect phase", cela peut être dû à un endstop qui n'est pas suffisamment précis. Si le recalibrage n'aide pas, désactivez les ajustements de phase de butée en les supprimant du fichier de configuration.
* Si l'on utilise un axe Z traditionnel contrôlé par pas à pas (comme sur une imprimante cartésienne ou corexy) avec des vis de nivellement de lit traditionnelles, il est également possible d'utiliser ce système pour faire en sorte que chaque couche d'impression soit effectuée sur une limite "pas complet" . Pour activer cette fonctionnalité, assurez-vous que le slicer G-Code est configuré avec une hauteur de couche qui est un multiple d'un "pas complet", activez manuellement l'option endstop_align_zero dans la section de configuration endstop_phase (voir [reference de configuration](Config_Reference.md#endstop_phase) pour plus de détails), puis remettez à niveau les vis du lit.
* Il est possible d'utiliser ce système avec des pilotes de moteurs pas à pas traditionnels (non Trinamic). Cependant, cela nécessite de s'assurer que les pilotes du moteur pas à pas sont réinitialisés à chaque fois que le microcontrôleur est réinitialisé. (Si les deux sont toujours réinitialisés ensemble, Klipper peut déterminer la phase du moteur pas à pas en suivant le nombre total de pas qu'il a commandé au moteur pas à pas.) Actuellement, la seule façon de le faire de manière fiable est que le microcontrôleur et le moteur pas à pas les pilotes soient alimentés uniquement par USB et que l'alimentation USB soit fournie par un hôte fonctionnant sur un Raspberry Pi. Dans cette situation, on peut spécifier une configuration mcu avec "restart_method : rpi_usb" - cette option fera en sorte que le microcontrôleur soit toujours réinitialisé via une réinitialisation de l'alimentation USB, ce qui permettrait à la fois au microcontrôleur et aux pilotes de moteur pas à pas d'être réinitialiser ensemble. Si vous utilisez ce mécanisme, vous devrez alors configurer manuellement les sections de configuration "trigger_phase" (voir [config reference](Config_Reference.md#endstop_phase) pour les détails).
