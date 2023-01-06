# Cinématiques

Ce document donne un aperçu de la façon dont Klipper implémente le mouvement du robot (sa [cinématique](https://en.wikipedia.org/wiki/Kinematics)). Ce contenu peut intéresser aussi bien les développeurs travaillant sur le logiciel Klipper que les utilisateurs intéressés à mieux comprendre la mécanique de leurs machines.

## Accélération

Klipper met en œuvre un schéma d'accélération constante chaque fois que la tête d'impression change de vitesse - la vitesse est progressivement modifiée pour atteindre la nouvelle vitesse au lieu d'être brusquement atteinte. Klipper applique toujours l'accélération entre la tête de l'outil et l'impression. Le filament sortant de l'extrudeuse peut être assez fragile - des secousses rapides et/ou des changements de débit de l'extrudeuse entraînent une qualité médiocre et une mauvaise adhérence du lit. Même en l'absence d'extrusion, si la tête d'impression se trouve au même niveau que l'impression, des secousses rapides de la tête peuvent perturber le filament récemment déposé. Limiter les changements de vitesse de la tête d'impression (par rapport à l'impression) réduit les risques de perturbation de l'impression.

Il est également important de limiter l'accélération afin que les moteurs pas à pas ne perdent pas de pas et ne soumettent pas la machine à des contraintes excessives. Klipper limite le couple de chaque moteur pas à pas en limitant l'accélération de la tête d'impression. Le fait d'imposer une accélération à la tête d'impression limite naturellement aussi le couple des moteurs pas à pas qui déplacent la tête d'impression (l'inverse n'est pas toujours vrai).

Klipper met en œuvre une accélération constante. La formule clé de l'accélération constante est la suivante :

```
velocity(time) = start_velocity + accel*time
```

## Générateur de trapézoïdes

Klipper utilise un "générateur de trapèze" traditionnel pour modéliser le mouvement de chaque déplacement - chaque déplacement a une vitesse de départ, il accélère jusqu'à une vitesse de croisière à une accélération constante, il se déplace à une vitesse constante, puis décélère jusqu'à la vitesse finale en utilisant une décélération constante.

![trapezoid](img/trapezoid.svg.png)

On l'appelle "générateur de trapèze" parce que le diagramme de vitesse du mouvement ressemble à un trapèze.

La vitesse de croisière est toujours supérieure ou égale à la fois à la vitesse de départ et à la vitesse d'arrivée. La phase d'accélération peut être de durée nulle (si la vitesse de départ est égale à la vitesse de croisière), la phase de croisière peut être de durée nulle (si le mouvement commence immédiatement à décélérer après l'accélération), et/ou la phase de décélération peut être de durée nulle (si la vitesse finale est égale à la vitesse de croisière).

![trapezoids](img/trapezoids.svg.png)

## Projection

Le système de projection "look-ahead" est utilisé pour déterminer les vitesses lors des virages entre les mouvements.

Considérons les deux mouvements suivants contenus dans un plan XY :

![corner](img/corner.svg.png)

Dans la situation ci-dessus, il est possible de décélérer complètement après le premier mouvement et d'accélérer complètement au début du mouvement suivant, mais ce n'est pas idéal car toutes ces accélérations et décélérations augmenteraient considérablement le temps d'impression et les changements fréquents dans le flux de l'extrudeuse entraîneraient une mauvaise qualité d'impression.

Pour résoudre ce problème, le mécanisme de projection "look-ahead" met en file d'attente plusieurs mouvements entrants et analyse les angles entre les mouvements pour déterminer une vitesse raisonnable pouvant être obtenue pendant la "jonction" entre deux mouvements. Si le déplacement suivant est presque dans la même direction, la tête ne doit ralentir que légèrement (voire pas du tout).

![lookahead](img/lookahead.svg.png)

Toutefois, si le mouvement suivant forme un angle aigu (la tête va se déplacer dans une direction presque inverse lors du mouvement suivant), seule une petite vitesse de jonction est autorisée.

![lookahead](img/lookahead-slow.svg.png)

Les vitesses de jonction sont déterminées en utilisant "l'accélération centripète approximative". Best [décrit par l'auteur](https://onehossshay.wordpress.com/2011/09/24/improving_grbl_cornering_algorithm/). Cependant, dans Klipper, les vitesses de jonction sont configurées en spécifiant la vitesse souhaitée pour un angle de 90° (la "vitesse de l'angle carré"), et les vitesses de jonction des autres angles en sont dérivées.

Formule clé pour la projection :

```
end_velocity^2 = start_velocity^2 + 2*accel*move_distance
```

### Lissage de la projection

Klipper met également en œuvre un mécanisme permettant de lisser les mouvements de courts déplacements en "zigzag". Considérons les mouvements suivants :

![zigzag](img/zigzag.svg.png)

Dans l'exemple ci-dessus, les passages fréquents de l'accélération à la décélération peuvent faire vibrer la machine provoquant des contraintes sur la machine et augmentant le bruit. Pour réduire ce phénomène, Klipper suit à la fois l'accélération des mouvements réguliers et un taux virtuel "d'accélération à décélération". Grâce à ce système, la vitesse maximale de ces courts mouvements en "zigzag" est limitée pour lisser le mouvement de l'imprimante :

![smoothed](img/smoothed.svg.png)

Plus précisément, le code calcule ce que serait la vitesse de chaque mouvement s'il était limité à ce taux virtuel "d'accélération à décélération" (la moitié du taux d'accélération normal par défaut). Dans l'image ci-dessus, les lignes grises en pointillés représentent ce taux d'accélération virtuel pour le premier déplacement. Si un déplacement ne peut atteindre sa vitesse de croisière maximale en utilisant ce taux d'accélération virtuel, sa vitesse maximale est réduite à la vitesse maximale obtenu avec ce taux d'accélération virtuel. Pour la plupart des mouvements, la limite sera égale ou supérieure aux limites existantes du mouvement et aucun changement de comportement n'est induit. En revanche, pour les déplacements courts en zigzag, cette limite réduit la vitesse maximale. Notez que cela ne modifie pas l'accélération réelle du mouvement - le mouvement continue d'utiliser le schéma d'accélération normal jusqu'à sa vitesse maximale ajustée.

## Étapes de la génération

Une fois le processus d'anticipation terminé, le mouvement de la tête d'impression du mouvement donné est entièrement connu (temps, position de départ, position finale, vitesse à chaque point) et il est possible de générer les durées de pas du mouvement. Ce processus est effectué dans les "classes cinématiques" du code Klipper. En dehors de ces classes cinématiques, tout est suivi en millimètres, en secondes et dans un espace de coordonnées cartésiennes. C'est la tâche des classes cinématiques de convertir ce système de coordonnées générique aux spécificités matérielles de l'imprimante particulière.

Klipper utilise un [solveur itératif](https://en.wikipedia.org/wiki/Root-finding_algorithm) pour générer les durés de pas pour chaque moteur. Le code contient les formules permettant de calculer les coordonnées cartésiennes idéales de la tête à chaque instant, ainsi que les formules cinématiques permettant de calculer les positions idéales des moteurs à partir de ces coordonnées cartésiennes. Grâce à ces formules, Klipper peut déterminer le moment idéal où le moteur doit se trouver à chaque position de pas. Les étapes données sont alors programmées à ces moments calculés.

La formule clé déterminant la distance qu'un mouvement doit parcourir sous une accélération constante est la suivante :

```
move_distance = (start_velocity + .5 * accel * move_time) * move_time
```

et la formule clé d'un mouvement à vitesse constante est :

```
move_distance = cruise_velocity * move_time
```

Les formules clés permettant de déterminer la coordonnée cartésienne d'un déplacement en fonction de la distance du déplacement sont les suivantes :

```
cartesian_x_position = start_x + move_distance * total_x_movement / total_movement
cartesian_y_position = start_y + move_distance * total_y_movement / total_movement
cartesian_z_position = start_z + move_distance * total_z_movement / total_movement
```

### Robots cartésiens

La génération de pas des imprimantes cartésiennes est le cas le plus simple. Le mouvement sur chaque axe est directement lié au mouvement dans l'espace cartésien.

Formules clés :

```
stepper_x_position = cartesian_x_position
stepper_y_position = cartesian_y_position
stepper_z_position = cartesian_z_position
```

### Robots CoreXY

La génération de pas d'une machine CoreXY n'est qu'un peu plus complexe que les robots cartésiens de base. Les formules clés sont les suivantes :

```
stepper_a_position = cartesian_x_position + cartesian_y_position
stepper_b_position = cartesian_x_position - cartesian_y_position
stepper_z_position = cartesian_z_position
```

### Robots Delta

La génération de pas d'un robot delta est basée sur le théorème de Pythagore :

```
stepper_position = (sqrt(arm_length^2
                         - (cartesian_x_position - tower_x_position)^2
                         - (cartesian_y_position - tower_y_position)^2)
                    + cartesian_z_position)
```

### Limites d'accélération du moteur pas à pas

Avec la cinématique delta, il est possible qu'un mouvement accélèrant dans l'espace cartésien nécessite une accélération sur un moteur pas à pas particulier supérieure à l'accélération du mouvement. Cela peut se produire lorsque le bras d'un moteur pas à pas est plus horizontal que vertical et que la ligne de mouvement passe près de la tour de ce moteur pas à pas. Bien que ces mouvements puissent nécessiter une accélération du moteur pas à pas supérieure à l'accélération maximale du mouvement configuré de l'imprimante, la masse effective déplacée par ce moteur pas à pas serait plus faible. Ainsi, l'accélération plus élevée du moteur pas à pas n'entraîne pas un couple beaucoup plus élevé et est donc considérée comme inoffensive.

Cependant, afin d'éviter les cas extrêmes, Klipper applique un plafond maximal à l'accélération du moteur de trois fois l'accélération de déplacement maximale configurée de l'imprimante. (De même, la vitesse maximale du moteur est limitée à trois fois la vitesse de déplacement maximale). Afin de faire respecter cette limite, les mouvements situés à l'extrémité de l'enveloppe de construction (où le bras du stepper peut être presque horizontal) auront une accélération et une vitesse maximales inférieures.

### Cinématique de l'extrudeuse

Klipper implémente le mouvement de l'extrudeuse dans sa propre classe cinématique. Comme la durée et la vitesse de chaque mouvement de la tête d'impression sont entièrement connus pour chaque mouvement, il est possible de calculer les durées de pas de l'extrudeuse indépendamment des calculs de durées de pas du mouvement de la tête d'impression.

Le mouvement de base de l'extrudeuse est simple à calculer. La génération de durée de pas utilise les mêmes formules que celles utilisées par les robots cartésiens :

```
stepper_position = requested_e_position
```

### Avance à la pression

L'expérimentation a montré qu'il est possible d'améliorer la modélisation de l'extrudeuse au-delà de la formule de base de l'extrudeuse. Dans le cas idéal, au fur et à mesure qu'un mouvement d'extrusion progresse, le même volume de filament devrait être déposé à chaque point du mouvement et il ne devrait pas y avoir de volume extrudé après le mouvement. Malheureusement, il est courant de constater que les formules d'extrusion de base font que trop peu de filament sort de l'extrudeuse au début des mouvements d'extrusion et qu'un excès de filament est extrudé après la fin de l'extrusion. Ce phénomène est souvent appelé "suintement".

![suintement](img/ooze.svg.png)

Le système d'"avance à la pression" tente de tenir compte de ce phénomène en utilisant un modèle différent pour l'extrudeuse. Au lieu de croire naïvement que chaque mm^3 de filament introduit dans l'extrudeuse entraînera la sortie immédiate de cette quantité de mm^3, est utilisé un modèle basé sur la pression. La pression augmente lorsque le filament est poussé dans l'extrudeuse (comme dans la [loi de Hooke](https://en.wikipedia.org/wiki/Hooke%27s_law)) et la pression nécessaire pour extruder est dominée par le débit à travers l'orifice de la buse (comme dans la [loi de Poiseuille](https://en.wikipedia.org/wiki/Poiseuille_law)). L'idée principale est que la relation entre le filament, la pression et le débit peut être modélisée par un coefficient linéaire :

```
pa_position = nominal_position + pressure_advance_coefficient * nominal_velocity
```

Voir le document [avance à la pression](Pressure_Advance.md) pour savoir comment déterminer ce coefficient d'avance à la pression.

La formule de base de l'avance à la pression peut entraîner des changements brusques de la vitesse du moteur de l'extrudeuse. Klipper met en œuvre un "lissage" du mouvement de l'extrudeuse pour éviter cela.

![pressure-advance](img/pressure-velocity.png)

Le graphique ci-dessus montre un exemple de deux mouvements d'extrusion avec une vitesse de virage non nulle entre eux. Notez que le système d'avance à la pression fait que du filament supplémentaire est poussé dans l'extrudeuse pendant l'accélération. Plus le débit de filament souhaité est élevé, plus il faut pousser de filament dans l'extrudeuse pendant l'accélération pour tenir compte de la pression. Pendant la décélération de la tête, le filament supplémentaire est rétracté (l'extrudeuse aura une vitesse négative).

Le "lissage" est implémenté en utilisant une moyenne pondérée de la position de l'extrudeuse sur une très courte période de temps (comme spécifié par le paramètre de configuration `pressure_advance_smooth_time`). Cette moyenne peut s'étendre sur plusieurs mouvements du g-code. Notez comment le moteur de l'extrudeuse commencera à bouger avant le début nominal du premier mouvement d'extrusion et continuera à bouger après la fin nominale du dernier mouvement d'extrusion.

Formule clé pour "l'avance à la pression lissée" :

```
smooth_pa_position(t) =
    ( definitive_integral(pa_position(x) * (smooth_time/2 - abs(t - x)) * dx,
                          from=t-smooth_time/2, to=t+smooth_time/2)
     / (smooth_time/2)^2 )
```
