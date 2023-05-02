# Pilotes de moteur pas à pas TMC

Ce document fournit des informations sur l'utilisation des pilotes de moteur pas à pas Trinamic en mode SPI/UART sur Klipper.

Klipper peut également utiliser les pilotes Trinamic dans leur "mode autonome". Cependant, lorsque les pilotes sont dans ce mode, aucune configuration spéciale de Klipper n'est nécessaire et les fonctionnalités avancées de Klipper décrites dans ce document ne sont pas disponibles.

En plus de ce document, veillez à consulter la [référence de configuration du pilote TMC](Config_Reference.md#tmc-stepper-driver-configuration).

## Réglage du courant du moteur

Un courant de commande plus élevé augmente la précision de positionnement et le couple. Cependant, un courant plus élevé augmente également la chaleur produite par le moteur pas à pas et le pilote du moteur pas à pas. Si le pilote du moteur pas à pas devient trop chaud, il se désactivera et Klipper signalera une erreur. Si le moteur pas à pas devient trop chaud, il perd du couple et de la précision de positionnement. (S'il devient très chaud, il peut également faire fondre les pièces en plastique qui y sont attachées ou à proximité.)

Comme conseil de réglage général : préférez des valeurs de courant plus élevées tant que le moteur pas à pas ne chauffe pas trop et que le pilote du moteur pas à pas ne signale pas d'avertissements ou d'erreurs. En général, il est normal que le moteur pas à pas soit chaud, mais il ne doit pas devenir si chaud qu'il soit douloureux au toucher.

## Ne spécifiez pas de hold_current

Si l'on configure un `hold_current`, le pilote TMC peut réduire le courant vers le moteur pas à pas lorsqu'il détecte que le moteur pas à pas ne bouge pas. Cependant, la modification du courant du moteur peut elle-même introduire un mouvement du moteur. Cela peut se produire en raison de "forces de détente" dans le moteur pas à pas (l'aimant permanent du rotor tire vers les dents en fer du stator) ou en raison de forces externes sur le chariot d'axe.

La plupart des moteurs pas à pas ne fonctionneront pas mieux en réduisant le courant pendant les impressions normales, car peu de mouvements d'impression laisseront un moteur pas à pas inactif suffisamment longtemps pour activer la fonction `hold_current`. Et, il est peu probable que l'on veuille introduire des artefacts d'impression dans les quelques mouvements d'impression qui laissent un stepper inactif suffisamment longtemps.

Si l'on souhaite réduire le courant vers les moteurs pendant les routines de démarrage d'impression, envisagez d'émettre des commandes [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) dans une [MACRO START_PRINT](Slicers.md#klipper-gcode_macro) pour ajuster le courant avant et après les mouvements d'impression normaux.

Certaines imprimantes avec des moteurs Z dédiés qui sont inactifs pendant les mouvements d'impression normaux (pas de bed_mesh, pas de bed_tilt, pas de Z skew_correction, pas d'impressions en "mode vase", etc.) peuvent constater que les moteurs Z fonctionnent plus froid avec un `hold_current`. Si vous l'implémentez, assurez-vous de prendre en compte ce type de mouvement non commandé de l'axe Z pendant le nivellement du lit, le sondage du lit, l'étalonnage de la sonde, etc. Le `driver_TPOWERDOWN` et le `driver_IHOLDDELAY` doivent également être calibrés en conséquence. En cas de doute, préférez ne pas spécifier de `hold_current`.

## Réglage du mode "spreadCycle" vs "stealthChop"

Par défaut, Klipper place les pilotes TMC en mode "spreadCycle". Si le pilote prend en charge "stealthChop", il peut être activé en ajoutant `stealthchop_threshold : 999999` à la section de configuration TMC.

Le mode spreadCycle fournit un couple supérieur et une plus grande précision de positionnement que le mode stealthChop. Cependant, le mode StealthChop peut produire un bruit audible nettement plus faible sur certaines imprimantes.

Les tests comparant les modes ont montré un "décalage de position" accru d'environ 75 % d'un pas complet lors de mouvements à vitesse constante lors de l'utilisation du mode StealthChop (par exemple, sur une imprimante avec une distance de rotation de 40 mm et 200 pas_par_rotation, l'écart de position des mouvements à vitesse constante a augmenté de ~0,150 mm). Cependant, ce "retard dans l'obtention de la position demandée" peut ne pas se manifester par un défaut d'impression significatif et on peut préférer le comportement plus silencieux du mode StealthChop.

Il est recommandé de toujours utiliser le mode "spreadCycle" (en ne spécifiant pas `stealthchop_threshold`) ou de toujours utiliser le mode "stealthChop" (en réglant `stealthchop_threshold` sur 999999). Malheureusement, les pilotes produisent souvent des résultats médiocres et erronés si le mode est changé alors que le moteur tourne.

## Le réglage d'interpolation TMC introduit un petit écart de position

Le paramètre `interpolation` du pilote TMC peut réduire le bruit audible du mouvement de l'imprimante au prix de l'introduction d'une petite erreur de position systémique. Cette erreur de position systémique résulte du retard du conducteur à exécuter les "étapes" que Klipper lui envoie. Pendant les déplacements à vitesse constante, ce retard entraîne une erreur de position de près d'un demi-micropas configuré (plus précisément, l'erreur est d'une demi-distance de micropas moins un 512e de distance d'un pas complet). Par exemple, sur un axe avec une rotation_distance de 40 mm, 200 pas_par_rotation et 16 micropas, l'erreur systémique introduite lors des mouvements à vitesse constante est d'environ 0,006 mm.

Pour une meilleure précision de positionnement, envisagez d'utiliser le mode spreadCycle et désactivez l'interpolation (définissez `interpolate : False` dans la configuration du pilote TMC). Lorsqu'il est configuré de cette façon, on peut augmenter le paramètre `microstep` pour réduire le bruit audible pendant le mouvement pas à pas. En règle générale, un réglage de micropas de `64` ou `128` aura un bruit audible similaire à celui de l'interpolation, et ce, sans introduire d'erreur de position systémique.

Si vous utilisez le mode StealthChop, l'imprécision de position due à l'interpolation est faible par rapport à l'imprécision de position introduite à partir du mode StealthChop. Par conséquent, le réglage de l'interpolation n'est pas considérée comme utile en mode StealthChop, et on peut laisser l'interpolation dans son état par défaut.

## Mise à l'origine sans capteur(s)

La mise à l'origine ans capteur permet de référencer un axe sans avoir besoin d'une fin de course physique. Au lieu de cela, le chariot sur l'axe est déplacé dans la limite mécanique, ce qui fait perdre des pas au moteur pas à pas. Le pilote pas à pas détecte les pas perdus et l'indique au MCU de contrôle (Klipper) en basculant une broche. Cette information peut être utilisée par Klipper comme fin de course pour l'axe.

Ce guide couvre la configuration de la mise à l'origine sans capteur pour l'axe X de votre imprimante (cartésienne). Cependant, cela fonctionne de la même manière avec tous les autres axes (qui nécessitent une butée fin de course). Vous devez le configurer et le régler pour un seul axe à la fois.

### Limites

Assurez-vous que vos composants mécaniques sont capables de supporter la charge du chariot heurtant à plusieurs reprises la fin de course de l'axe. Les vis sans fin, en particulier, peuvent générer une force importante. La prise d'origine d'un axe Z en écrasant la buse dans la surface d'impression n'est peut-être pas une bonne idée. Pour de meilleurs résultats, vérifiez que le chariot de l'axe établit un contact franc lors de la mise à l'origine.

De plus, la mise à l'origine sans capteur peut ne pas être suffisamment précise pour votre imprimante. Bien que la mise à l'origine des axes X et Y sur une machine cartésienne puisse bien fonctionner, la prise d'origine de l'axe Z n'est généralement pas assez précise et peut entraîner une hauteur de première couche incohérente. Le référencement d'une imprimante delta sans capteur n'est pas conseillé en raison du manque de précision.

En outre, la détection de décrochage du pilote pas à pas dépend de la charge mécanique sur le moteur, du courant du moteur et de la température du moteur (résistance de la bobine).

La mise à l'origine sans capteur fonctionne mieux à des vitesses de moteur moyennes. Pour des vitesses très lentes (moins de 10 tr/min), le moteur ne génère pas de force contre-électromotrice significative et le TMC ne peut pas détecter de manière fiable les calages du moteur. A des vitesses très élevées, la force contre-électromotrice du moteur se rapproche de la tension d'alimentation du moteur, de sorte que le TMC ne peut plus détecter les calages. Il est conseillé de consulter la fiche technique de vos TMC spécifiques. Vous y trouverez également plus de détails sur les limites de cette configuration.

### Conditions préalables

Quelques prérequis sont nécessaires pour utiliser la mise à l'origine sans capteur :

1. Un pilote pas à pas TMC compatible stallGuard (tmc2130, tmc2209, tmc2660 ou tmc5160).
1. Interface SPI/UART du driver TMC câblé au micro-contrôleur (le mode autonome ne fonctionne pas).
1. La broche "DIAG" ou "SG_TST" appropriée du pilote TMC doit être connectée au microcontrôleur.
1. Les étapes du document [vérification de la configuration](Config_checks.md) doivent être exécutées pour confirmer que les moteurs pas à pas sont configurés et fonctionnent correctement.

### Réglages

La procédure décrite ici comporte six étapes principales :

1. Choisissez une vitesse de mise à l'origine.
1. Configurez le fichier `printer.cfg` pour activer la mise à l'origine sans capteur.
1. Trouvez le meilleur réglage anti-décrochage avec la sensibilité la plus élevée.
1. Trouvez le réglage anti-décrochage avec la sensibilité la plus faible qui fonctionne avec une seule touche en fin de course.
1. Mettez à jour le fichier `printer.cfg` avec le paramètre anti-décrochage souhaité.
1. Créez ou mettez à jour les macros dans `printer.cfg` pour une mise à l'origine répétable.

#### Choisir la vitesse de prise d'origine

La vitesse de mise à l'origine est importante lors de la réalisation d'une mise à l'origine sans capteur. Il est souhaitable d'utiliser une vitesse de prise d'origine lente afin que le chariot n'exerce pas de force excessive sur le châssis lorsqu'il entre en contact avec l'extrémité du rail. Cependant, les pilotes TMC ne peuvent pas détecter de manière fiable un décrochage à des vitesses très lentes.

Un bon point de départ pour la vitesse de prise d'origine est que le moteur pas à pas effectue une rotation complète toutes les deux secondes. Pour de nombreux axes, ce sera la distance `rotation_distance` divisée par deux. Par example :

```
[stepper_x]
rotation_distance: 40
homing_speed: 20
...
```

#### Configurer 'printer.cfg' pour une mise à l'origine sans capteur

Le paramètre `homing_retract_dist` doit être défini sur zéro dans la section de configuration `stepper_x` pour désactiver le deuxième mouvement de mise à l'origine. La deuxième tentative de mise à l'origine n'ajoute pas de valeur lors de l'utilisation d'une mise à l'origine sans capteur, elle ne fonctionnera pas de manière fiable et introduira des erreurs dans le processus de réglage.

Assurez-vous que le paramètre `hold_current` n’est pas spécifié dans la section Pilote TMC de la configuration. (Si un hold_current est réglé, le moteur s’arrête lorsque le chariot est appuyé contre l’extrémité du rail, et la réduction du courant dans cette position peut entraîner le déplacement du chariot - ce qui entraînera de mauvaises performances et perturbera le processus de réglage.)

Il est nécessaire de configurer les broches du TMC pour le mode sans capteur et de configurer les paramètres initiaux de « Stallguard ». Un exemple de configuration tmc2209 pour un axe X pourrait ressembler à :

```
[tmc2209 stepper_x]
diag_pin: ^PA1      # Définit pour le MCU, la broche TMC DIAG
driver_SGTHRS: 255  # 255 est la valeur la plus sensible, 0 la moins sensible
...

[stepper_x]
endstop_pin: tmc2209_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Un exemple de configuration de tmc2130 ou tmc5160 pourrait ressembler à :

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # Broche connectée à TMC DIAG1  (ou utilisez diag0_pin / DIAG0 pin)
driver_SGT: -64  # -64 est la valeur la plus sensible, 63 est moins sensible
...

[stepper_x]
endstop_pin: tmc2130_stepper_x:virtual_endstop
homing_retract_dist: 0
...
```

Un exemple de configuration de tmc2660 pourrait ressembler à :

```
[tmc2660 stepper_x]
driver_SGT: -64     # -64 est la valeur la plus sensible,, 63 est moins sensible
...

[stepper_x]
endstop_pin: ^PA1   # Broche connectée à TMC SG_TST
homing_retract_dist: 0
...
```

Les exemples ci-dessus ne montrent que les paramètres spécifiques à la mise à l'origine sans capteur. Voir la [référence de configuration](Config_Reference.md#tmc-stepper-driver-configuration) pour toutes les options disponibles.

#### Trouvez la sensibilité la plus élevée qui fonctionne avec succès

Placez le chariot près du centre du rail. Utilisez la commande SET_TMC_FIELD pour définir la sensibilité la plus élevée. Pour un tmc2209 :

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=SGTHRS VALUE=255
```

Pour un tmc2130, tmc5160 et tmc2660 :

```
SET_TMC_FIELD STEPPER=stepper_x FIELD=sgt VALUE=-64
```

Émettez ensuite une commande `G28 X0` et vérifiez que l'axe ne bouge pas du tout ou s'arrête rapidement. Si l'axe ne s'arrête pas, émettez un `M112` pour arrêter l'imprimante - quelque chose n'est pas correct avec le câblage ou la configuration de la broche diag/sg_tst et ce doit être corrigé avant de continuer.

Ensuite, diminuez continuellement la sensibilité du paramètre `VALUE` et exécutez à nouveau les commandes `SET_TMC_FIELD` `G28 X0` pour trouver la sensibilité la plus élevée qui permet au chariot de se déplacer et de s'arrêter en butée. (Pour les pilotes tmc2209, cela diminuera SGTHRS, pour les autres pilotes, cela augmentera sgt.). Il devrait être possible de trouver la sensibilité la plus élevée et fiable (les réglages avec une sensibilité plus élevée entraînant peu ou pas de mouvement). Notez la valeur trouvée comme *maximum_sensitivity*. (Si la sensibilité minimale possible (SGTHRS = 0 ou sgt = 63) est obtenue sans aucun mouvement du chariot, alors quelque chose ne fonctionne pas aun niveau câblage ou configuration de la broche diag/sg_tst et il faut corriger le problème avant de continuer.)

Lors de la recherche de maximum_sensitivity, il peut être pratique de passer à différents paramètres VALUE (travaillez le paramètre VALUE par dichotomie pour plus d'efficacité). Si vous procédez ainsi, préparez-vous à émettre une commande `M112` pour arrêter l'imprimante, car un réglage avec une sensibilité trop faible peut entraîner un "cognement" répété de l'axe contre l'extrémité du rail.

Assurez-vous d'attendre quelques secondes entre chaque tentative de prise d'origine. Une fois que le pilote TMC a détecté un décrochage, il peut lui falloir un peu de temps pour effacer son indicateur interne et être capable de détecter un autre décrochage.

Au cours de ces tests de réglage, si une commande `G28 X0` ne se déplace pas jusqu'à la limite d'axe, soyez prudent lorsque vous exécutez des commandes de mouvement 'normales' (par exemple, `G1`). Klipper ne sachant pas ou est le chariot, une commande de déplacement pourra entraîner des résultats indésirables.

#### Trouver la sensibilité la plus basse qui permette la mise à l'origine en une seule fois

Lors de la mise à l'origine avec la valeur *maximum_sensitivity*, l'axe doit se déplacer jusqu'à l'extrémité du rail et s'arrêter avec un « simple toucher » - c'est-à-dire qu'il ne doit pas y avoir de « clic » ou de « claquement ». (S'il y a un bruit de claquement ou de clic à la sensibilité maximale, la vitesse de mise à l'origine est peut-être trop faible, le courant du pilote peut être trop faible ou la mise à l'origine sans capteur n'est peut-être pas un bon choix pour cet axe.)

L'étape suivante consiste à nouveau à déplacer le chariot vers une position proche du centre du rail, à diminuer la sensibilité et à exécuter les commandes `SET_TMC_FIELD` `G28 X0` - l'objectif est maintenant de trouver la sensibilité la plus faible qui permette au chariot de se mettre à l'origine correctement avec une "simple touche". C'est-à-dire qu'il ne "cogne" pas ou ne "clique" pas lorsqu'il entre en contact avec l'extrémité du rail. Notez la valeur trouvée comme *minimum_sensitivity*.

#### Mettez à jour printer.cfg avec la valeur de sensibilité

Après avoir trouvé *maximum_sensitivity* et *minimum_sensitivity*, utilisez une calculatrice pour obtenir la sensibilité recommandée : *minimum_sensitivity + (maximum_sensitivity - minimum_sensitivity)/3*. La sensibilité recommandée doit être comprise entre le minimum et le maximum, mais légèrement plus proche du minimum. Arrondissez la valeur finale à la valeur entière la plus proche.

Pour un tmc2209, définissez-le dans la configuration en tant que `driver_SGTHRS`, pour les autres pilotes TMC, définissez-le dans la configuration en tant que `driver_SGT`.

Si la plage entre *maximum_sensitivity* et *minimum_sensitivity* est petite (par exemple, inférieure à 5), cela peut entraîner une mise à l'origine instable. Une vitesse de mise à l'origine plus rapide peut rendre l'opération plus stable.

Notez que si une modification est apportée au courant du pilote, à la vitesse de prise d'origine ou si une modification notable est apportée au matériel de l'imprimante, il sera alors nécessaire de refaire le processus de réglage.

#### Utilisation de macros lors de la mise à l'origine

Une fois la mise à l'origine sans capteur terminée, le chariot sera appuyé contre l'extrémité du rail et le stepper exercera une force sur le cadre tant que le chariot ne sera pas éloigné de la fin de course. Il est préférable de créer une macro pour positionner l'axe en butée et l'éloigner immédiatement de l'extrémité du rail.

Il est préférable, dans la macro, de faire une pause d'au moins 2 secondes avant de commencer la prise d'origine sans capteur (ou de s'assurer qu'il n'y a eu aucun mouvement sur le moteur pas à pas depuis au moins 2 secondes). Sans délai, il est possible que le drapeau de décrochage interne du pilote de moteur pas à pas soit toujours activé suite à un mouvement précédent.

Il peut également être utile que cette macro définisse le courant du pilote avant la prise d'origine et définisse un nouveau courant après que le chariot s'est éloigné.

Un exemple de macro pourrait ressembler à :

```
[gcode_macro SENSORLESS_HOME_X]
gcode:
    {% set HOME_CUR = 0.700 %}
    {% set driver_config = printer.configfile.settings['tmc2209 stepper_x'] %}
    {% set RUN_CUR = driver_config.run_current %}
    # Définir le courant pour la mise à l'origine sans capteur
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={HOME_CUR}
    # Petit pause pour attendre que le drapeau stall flag soit désactivé
    G4 P2000
    # mise à l'origine
    G28 X0
    # Déplacement 
    G90
    G1 X5 F1200
    # Remise du courant d'impression
    SET_TMC_CURRENT STEPPER=stepper_x CURRENT={RUN_CUR}
```

La macro peut être appelée depuis une [section de configuration homing_override](Config_Reference.md#homing_override) ou depuis une [macro START_PRINT](Slicers.md#klipper-gcode_macro).

Notez que si le courant du pilote pas à pas lors de la mise à l'origine est modifié, le processus de réglage doit être entièrement refait.

### Conseils pour la mise à l'origine sans capteur sur CoreXY

Il est possible d'utiliser la mise à l'origine sans capteur sur les chariots X et Y d'une imprimante CoreXY. Klipper utilise le stepper `[stepper_x]` pour détecter les décrochages lors de la mise à l'origine du chariot X et utilise le stepper `[stepper_y]` pour détecter les décrochages lors de la mise à l'origine du chariot Y.

Utilisez le guide de réglage décrit ci-dessus pour trouver la "sensibilité au décrochage" appropriée pour chaque chariot, mais soyez conscient des restrictions suivantes :

1. Lors de l'utilisation de la prise d'origine sans capteur sur CoreXY, assurez-vous qu'aucun `hold_current` n'est configuré pour l'un ou l'autre des moteurs pas à pas.
1. Pendant le réglage, assurez-vous que les chariots X et Y sont proches du centre de leurs rails avant chaque tentative de mise à l'origine.
1. Une fois les réglages terminés, lors de la prise d'origine de X et Y, utilisez des macros pour vous assurer qu'un axe est pris en charge en premier, puis éloignez ce chariot de la fin de course de l'axe, faites une pause d'au moins 2 secondes, puis démarrez la prise d'origine de l'autre axe. L'éloignement de l'axe évite le référencement d'un axe alors que l'autre est plaqué contre la fin de course (ce qui peut fausser la détection de décrochage). La pause est nécessaire pour s'assurer que le drapeau de décrochage du pilote pas à pas est effacé avant de se déplacer à nouveau.

Un exemple de macro de référencement CoreXY pourrait ressembler à :

```
[gcode_macro HOME]
gcode:
    G90
    # mise à l'origine Z
    G28 Z0
    G1 Z10 F1200
    # mise à l'origine Y
    G28 Y0
    G1 Y5 F1200
    # mise à l'origine X
    G4 P2000
    G28 X0
    G1 X5 F1200
```

## Interroger et diagnostiquer les informations du pilote pas à pas

La `[commande DUMP_TMC](G-Codes.md#dump_tmc) est un outil utile lors de la configuration et du diagnostic des pilotes. Il signalera tous les champs configurés par Klipper ainsi que tous les champs pouvant être interrogés à partir du pilote.

Tous les champs signalés sont définis dans la fiche technique de Trinamic pour chaque pilote. Ces fiches techniques sont disponibles sur le [site Internet de Trinamic](https://www.trinamic.com/). Obtenez et examinez la fiche technique de Trinamic du pilote pas à pas afin d'interpréter correctement les résultats d'un DUMP_TMC.

## Configuration des paramètres d'un 'driver_XXX'

Klipper prend en charge la configuration de nombreux paramètres de bas niveau pour les pilotes de moteurs pas à pas à l'aide des paramètres de la section `driver_XXX`. La [référence de configuration du pilote TMC](Config_Reference.md#tmc-stepper-driver-configuration) contient la liste complète des paramètres disponibles pour chaque type de pilote.

De plus, presque tous les champs peuvent être modifiés au moment de l'exécution à l'aide de la [commande SET_TMC_FIELD](G-Codes.md#set_tmc_field).

Chacun de ces paramètres est défini dans la fiche technique de Trinamic pour chaque pilote. Ces fiches techniques sont disponibles sur le [site Internet de Trinamic](https://www.trinamic.com/).

Les fiches techniques de Trinamic utilisent parfois une formulation qui peut confondre un paramètre de haut niveau (tel que "fin d'hystérésis") avec une valeur de paramètre de bas niveau (par exemple, "HEND"). Dans Klipper, `driver_XXX` et SET_TMC_FIELD définissent toujours la valeur de paramètres de bas niveau (celles qui sontt réellement écrite dans le pilote). Ainsi, par exemple, si la fiche technique Trinamic indique qu'une valeur de 3 doit être écrite dans le champ HEND pour obtenir une "fin d'hystérésis" de 0, alors définissez `driver_HEND=3` pour obtenir une valeur de haut niveau de 0.

## Questions courantes

### Puis-je utiliser le mode StealthChop sur une extrudeuse avec avance de pression ?

Beaucoup de gens utilisent avec succès le mode "stealthChop" avec l'avance de pression de Klipper. Klipper implémente [avance de pression "adoucie"](Kinematics.md#pressure-advance) qui n'introduit aucun changement de vitesse instantané.

Cependant, le mode "stealthChop" peut produire un couple moteur plus faible et/ou produire une chaleur moteur plus élevée. Il peut s'agir ou non d'un mode utilisable avec votre imprimante.

### J'ai des erreurs "Unable to read tmc uart 'stepper_x' register IFCNT" ?

Cela se produit lorsque Klipper est incapable de communiquer avec un pilote tmc2208 ou tmc2209.

Assurez-vous que l'alimentation du moteur est activée, car le pilote du moteur pas à pas a généralement besoin de l'alimentation du moteur avant de pouvoir communiquer avec le micro-contrôleur.

Si cette erreur se produit après avoir flashé Klipper pour la première fois, le pilote pas à pas peut avoir été précédemment programmé dans un état qui n'est pas compatible avec Klipper. Pour réinitialiser l'état, coupez toute alimentation de l'imprimante pendant plusieurs secondes (débranchez physiquement les prises USB et d'alimentation).

Sinon, cette erreur est souvent due à un câblage incorrect des broche UART ou d'une configuration incorrecte des paramètres de broche UART dans Klipper.

### J'ai des erreurs "Unable to write tmc spi 'stepper_x' register ..." ?

Cela se produit lorsque Klipper est incapable de communiquer avec un pilote tmc2130 ou tmc5160.

Assurez-vous que l'alimentation du moteur est activée, car le pilote du moteur pas à pas a généralement besoin de l'alimentation du moteur avant de pouvoir communiquer avec le micro-contrôleur.

Cette erreur est souvent due à un câblage SPI incorrect, à une configuration incorrecte des paramètres SPI de Klipper ou d'une configuration incomplète des périphériques sur un bus SPI.

Si le pilote se trouve sur un bus SPI partagé avec plusieurs périphériques, assurez-vous de configurer - dans Klipper - chaque périphérique sur ce bus SPI. Si un appareil sur un bus SPI partagé n'est pas configuré, il peut répondre de manière incorrecte à des commandes qui ne lui sont pas destinées et corrompre la communication avec l'appareil prévu. S'il y a un appareil sur un bus SPI partagé qui ne peut pas être configuré dans Klipper, utilisez la [section de configuration static_digital_output](Config_Reference.md#static_digital_output) pour régler la broche CS de l'appareil inutilisé à un niveau élevé (afin qu'il n'essaie pas d'utiliser le bus SPI). Le schéma de la carte est une référence utile (ndt et nécessaire) pour trouver les périphériques qui se trouvent sur un bus SPI et leurs broches associées.

### Pourquoi ai-je une erreur "TMC reports error : ..." ?

Ce type d'erreur indique que le pilote TMC a détecté un problème et s'est désactivé. C'est-à-dire que le pilote de moteur pas à pas a cessé de maintenir sa position et a ignoré les commandes de mouvement. Si Klipper détecte qu'un pilote actif s'est désactivé, il fera passer l'imprimante dans un état "arrêt".

Il est également possible qu'un arrêt **TMC reports error** se produise en raison d'erreurs SPI qui empêchent la communication avec le pilote (sur les tmc2130, tmc5160 ou tmc2660). Si cela se produit, il est fréquent que l'état du pilote indiqué affiche `00000000` ou `ffffffff` - par exemple : `TMC reports error : DRV_STATUS : ffffffff ...` OU [ X316X]TMC reports error : READRSP@RDSEL2 : 00000000 ...`. Une telle défaillance peut être due à un problème de câblage SPI ou à une réinitialisation automatique ou à une défaillance du pilote TMC.

Quelques erreurs courantes et conseils pour les diagnostiquer :

#### TMC signale une erreur : `... ot=1(OvertempError !)`

Cela indique que le pilote du moteur s'est désactivé car il est en surchauffe. Les solutions typiques consistent à diminuer le courant du pilote de moteur pas à pas, à augmenter le refroidissement du pilote du moteur pas à pas et/ou à augmenter le refroidissement du pilote du moteur pas à pas.

#### TMC signale une erreur : `... ShortToGND` OU `ShortToSupply`

Cela indique que le pilote s'est désactivé car il a détecté un courant très élevé le traversant. Cela peut indiquer un fil desserré ou court-circuité vers le moteur pas à pas ou dans le moteur pas à pas lui-même.

Cette erreur peut également se produire si vous utilisez le mode StealthChop et que le pilote TMC n'est pas en mesure de prédire avec précision la charge mécanique du moteur. (Si le pilote fait une mauvaise prédiction, il peut envoyer trop de courant à travers le moteur et déclencher sa propre détection de surintensité.) Pour tester cela, désactivez le mode StealthChop et vérifiez si les erreurs continuent de se produire.

#### TMC signale une erreur : `... reset=1(Reset)` OR `CS_ACTUAL=0(Reset ?)` OR `SE=0(Reset?)`

Cela indique que le pilote s'est réinitialisé en cours d'impression. Cela peut être dû à des problèmes de tension ou de câblage.

#### TMC signale une erreur : `... uv_cp=1(Sous-tension !)`

Cela indique que le pilote a détecté un événement de basse tension et s'est désactivé. Cela peut être dû à des problèmes de câblage ou d'alimentation.

### Comment régler spreadCycle/coolStep/etc. mode sur mes pilotes ?

Le [site Web de Trinamic](https://www.trinamic.com/) contient des guides sur la configuration des pilotes. Ces guides sont souvent techniques, de bas niveau et peuvent nécessiter du matériel spécialisé. Quoi qu'il en soit, ils sont la meilleure source d'information.
