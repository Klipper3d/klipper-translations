# Nivellement manuel

Ce document décrit les outils pour le réglage de la fin de course Z et pour effectuer les réglages sur les vis de mise à niveau du lit.

## Calibrer la fin de course Z

Une position précise de la butée Z est essentielle pour obtenir des impressions de haute qualité.

Notez que la précision de l'interrupteur de fin de course Z lui-même peut être un facteur limitant. Si vous utilisez des pilotes de moteurs pas à pas Trinamic, pensez à activer la détection [endstop phase](Endstop_Phase.md) pour améliorer la précision du commutateur.

Pour effectuer un étalonnage de la fin de course Z, placez l'imprimante à l'origine, déplacez la tête vers une position Z située à au moins cinq millimètres au-dessus du lit (si ce n'est déjà fait), déplacez ensuite la tête vers une position XY près du centre de le lit, puis accédez à l'aide du terminal exécutez :

```
Z_ENDSTOP_CALIBRATE
```

Suivez ensuite les étapes décrites dans ["le test du papier"](Bed_Level.md#the-paper-test) pour déterminer la distance réelle entre la buse et le lit à l'emplacement donné. Une fois ces étapes terminées, on peut taper `ACCEPT` pour valider la position et enregistrer les résultats dans le fichier de configuration avec :

```
SAVE_CONFIG
```

Il est préférable d'utiliser un interrupteur de fin de course Z à l'extrémité de l'axe Z opposée au lit (il est plus sécurisant d'effectuer le retour au point d'origine loin du lit). Cependant, si l'on doit se diriger vers le lit, il est recommandé de régler la butée de fin de course de manière à ce qu'elle se déclenche à une petite distance (par exemple, 0,5 mm) au-dessus du lit. Presque tous les interrupteurs de fin de course peuvent être enfoncés en toute sécurité à une petite distance au-delà de leur point de déclenchement. Lorsque cela est fait, on devrait constater que la commande `Z_ENDSTOP_CALIBRATE` rapporte une petite valeur positive (par exemple, 0,5 mm) pour la position Z_endstop. Déclencher la butée de fin de course alors qu'elle est encore à une certaine distance du lit réduit le risque d'écrasement involontaire de la buse sur le lit.

Certaines imprimantes laissent la possibilité d'ajuster manuellement l'emplacement de l'interrupteur de fin de course. Cependant, il est recommandé d'effectuer le positionnement de la butée Z dans le logiciel avec Klipper - une fois que la butée est bien positionné, on peut faire d'autres ajustements en exécutant Z_ENDSTOP_CALIBRATE ou en mettant à jour manuellement la position Z_endstop dans le fichier de configuration.

## Réglage des vis de mise à niveau du lit

Le secret pour obtenir un bon nivellement du lit avec les vis est d'utiliser le système de mouvement de haute précision de l'imprimante pendant le processus de nivellement du lit lui-même. Cela se fait en commandant la buse à une position proche de chaque vis de réglage du lit, puis en ajustant cette vis jusqu'à ce que le lit soit à une distance définie de la buse. Klipper a un outil pour vous aider. Pour utiliser l'outil, il est nécessaire de spécifier l'emplacement XY de chaque vis.

Cela se fait en créant une section de configuration `[bed_screws]`. Par exemple, cela pourrait ressembler à :

```
[bed_screws]
screw1: 100, 50
screw2: 100, 150
screw3: 150, 100
```

Si la vis de réglage se trouve sous le lit, spécifiez la position XY directement au-dessus de la vis. Si la vis est à l'extérieur du lit, spécifiez une position XY la plus proche de la vis tout en restant dans les limites du lit.

Une fois que le fichier de configuration est prêt, exécutez `RESTART` pour charger la nouvelle configuration, puis vous pouvez démarrer l'outil en exécutant :

```
BED_SCREWS_ADJUST
```

Cet outil va déplacer la buse de l'imprimante vers chaque emplacement XY de vis, puis déplacera la buse à une hauteur Z = 0. À ce stade, on peut utiliser le "test du papier" pour ajuster la vis de réglage directement sous la buse. Voir les informations décrites dans ["le test du papier"](Bed_Level.md#the-paper-test), mais ajustez la vis de réglage au lieu de déplacer la buse à différentes hauteurs. Ajustez la vis de réglage jusqu'à ce qu'il y ait une petite friction lorsque vous poussez le papier d'avant en arrière.

Une fois la vis ajustée de manière à ressentir une légère friction, exécutez la commande `ACCEPT` ou `ADJUSTED`. Utilisez la commande `ADJUSTED` si la vis du lit nécessitait un ajustement (généralement plus d'environ 1/8 de tour de vis). Utilisez la commande `ACCEPTER` si aucun ajustement significatif n'est nécessaire. Les deux commandes feront passer l'outil à la vis suivante. (Lorsqu'une commande `ADJUSTED` est utilisée, l'outil programme un cycle supplémentaire d'ajustements des vis ; l'outil se termine avec succès lorsque toutes les vis d'assise sont vérifiées pour ne pas nécessiter d'ajustements importants.) On peut utiliser la commande `ABORT` pour quitter l'outil plus tôt.

Ce système fonctionne mieux lorsque l'imprimante a une surface d'impression plate (telle que du verre) et des rails rectilignes. Une fois l'outil de nivellement du lit terminé avec succès, le lit est prêt pour l'impression.

### Réglages fin des vis de nivellement

Si l'imprimante utilise trois vis de réglages et que les trois vis sont sous le lit, il est alors être possible d'effectuer une deuxième étape de mise à niveau du lit de « haute précision ». Cela se fait en déplaçant la buse vers les endroits les plus éloignés des vis de réglages.

Par exemple, considérons un lit avec des vis aux emplacements A, B et C :

![vis de réglage](img/bed_screws.svg.png)

Pour chaque réglage effectué sur la vis du lit à l'emplacement C, le lit oscillera le long d'un axe défini par les deux vis du lit restantes (représentées ici par une ligne verte). Dans cette situation, chaque réglage de la vis du lit en C déplacera le lit en position D d'une plus grande distance que directement en C. Il est ainsi possible d'effectuer un réglage amélioré de la vis C lorsque la buse est en position D.

Pour activer cette fonctionnalité, il faudra déterminer les coordonnées supplémentaires de la buse et les ajouter au fichier de configuration. Par exemple, cela pourrait ressembler à :

```
[bed_screws]
screw1: 100, 50
screw1_fine_adjust: 0, 0
screw2: 100, 150
screw2_fine_adjust: 300, 300
screw3: 150, 100
screw3_fine_adjust: 0, 100
```

Lorsque cette fonctionnalité est activée, la commande `BED_SCREWS_ADJUST` demandera d'abord des ajustements grossiers directement au-dessus de chaque position de vis, et une fois ceux-ci acceptés, il demandera des ajustements fins aux emplacements supplémentaires. Continuez à utiliser `ACCEPT` et `ADJUSTED` à chaque position.

## Réglage des vis de mise à niveau du lit à l'aide de la sonde de lit

C'est une autre façon de calibrer le niveau du lit avec la sonde de lit. Pour l'utiliser, vous devez disposer d'une sonde Z (BL Touch, capteur inductif, etc.).

Pour activer cette fonctionnalité, il faut déterminer les coordonnées de la buse de sorte que la sonde Z soit au-dessus des vis, puis les ajouter au fichier de configuration. Par exemple, cela pourrait ressembler à :

```
[screws_tilt_adjust]
screw1: -5, 30
screw1_name: front left screw
screw2: 155, 30
screw2_name: front right screw
screw3: 155, 190
screw3_name: rear right screw
screw4: -5, 190
screw4_name: rear left screw
horizontal_move_z: 10.
speed: 50.
screw_thread: CW-M3
```

La vis1 est toujours le point de référence pour les autres, donc le système suppose que la vis1 est à la bonne hauteur. Exécutez toujours `G28` en premier, puis exécutez `SCREWS_TILT_CALCULATE` - cela devrait produire une sortie similaire à :

```
Send: G28
Recv: ok
Send: SCREWS_TILT_CALCULATE
Recv: // 01:20 means 1 full turn and 20 minutes, CW=clockwise, CCW=counter-clockwise
Recv: // front left screw (base) : x=-5.0, y=30.0, z=2.48750
Recv: // front right screw : x=155.0, y=30.0, z=2.36000 : adjust CW 01:15
Recv: // rear right screw : y=155.0, y=190.0, z=2.71500 : adjust CCW 00:50
Recv: // read left screw : x=-5.0, y=190.0, z=2.47250 : adjust CW 00:02
Recv: ok
```

Cela signifie que :

- la vis avant gauche est le point de référence vous ne devez pas la changer.
- la vis avant droite doit être tournée dans le sens des aiguilles d'une montre d'un tour complet et d'un quart de tour
- La vis arrière droite doit être tournée dans le sens inverse des aiguilles d’une montre d'environ 50 minutes
- la vis arrière gauche doit être tournée dans le sens des aiguilles d'une montre d'un angle de 2 minutes (pas besoin c'est ok)

Notez que "minutes" fait référence aux "minutes d'un cadran d'horloge". Ainsi, par exemple, 15 minutes correspondent à un quart de tour complet.

Répétez le processus plusieurs fois jusqu'à ce que vous obteniez un bon niveau de lit - normalement lorsque tous les ajustements sont inférieurs à une rotation de 6 minutes des vis de réglage.

Si vous utilisez une sonde montée sur le côté de la hotend (c'est-à-dire qu'elle a un décalage X ou Y), notez que le réglage de l'inclinaison du lit rendra caduc l'étalonnage de sonde précédemment effectué avec un lit incliné. Assurez-vous d'exécuter [étalonnage de la sonde](Probe_Calibrate.md) après avoir ajusté les vis du lit.

Le paramètre `MAX_DEVIATION` est utile lorsqu'un maillage de lit sauvegardé est utilisé, pour s'assurer que le niveau du lit n'a pas trop dérivé de l'endroit où il se trouvait lorsque le maillage a été créé. Par exemple, `SCREWS_TILT_CALCULATE MAX_DEVIATION=0.01` peut être ajouté au gcode de démarrage personnalisé du trancheur avant le chargement du maillage. Il interrompra l'impression si la limite configurée est dépassée (0,01 mm dans cet exemple), donnant à l'utilisateur une chance d'ajuster les vis et de redémarrer l'impression.

Le paramètre `DIRECTION` est utile si vous ne pouvez tourner les vis de réglage de votre lit que dans un seul sens. Par exemple, vous pourriez avoir des vis qui commencent à être serrées dans leur position la plus basse (ou la plus haute) possible, qui ne peuvent être tournées que dans une seule direction, pour élever (ou abaisser) le lit. Si vous ne pouvez tourner les vis que dans le sens des aiguilles d'une montre, exécutez `SCREWS_TILT_CALCULATE DIRECTION=CW`. Si vous ne pouvez les tourner que dans le sens antihoraire, exécutez `SCREWS_TILT_CALCULATE DIRECTION=CCW`. Un point de référence approprié sera choisi de sorte que le lit puisse être nivelé en tournant toutes les vis dans la direction donnée.
