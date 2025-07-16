# Maillage du Bed

Le module Bed Mesh peut être utilisé pour compenser les irrégularités de la surface du lit afin d'obtenir une meilleure première couche sur l'ensemble du lit. Il convient de noter que la correction basée sur un logiciel n'atteindra pas des résultats parfaits, elle ne peut qu'approximer la forme du lit. Bed Mesh ne peut pas non plus compenser les problèmes mécaniques et électriques. Si un axe est faussé ou si une sonde n'est pas précise, le module bed_mesh ne recevra pas de résultats précis du processus de sonde.

Avant de procéder à l'étalonnage du maillage, vous devez vous assurer que l'offset Z de votre sonde est réglé. Si vous utilisez une butée de fin de course pour la mise à l'origine en Z, elle doit également être réglée. Voir [Calibration de la sonde](Probe_Calibrate.md) et Z_ENDSTOP_CALIBRATE dans [Nivelage manuel](Manual_Level.md) pour plus d'informations.

## Configuration de base

### Lits rectangulaires

Cet exemple suppose une imprimante avec un lit rectangulaire de 250 mm x 220 mm et une sonde avec un décalage x de 24 mm et un décalage y de 5 mm.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `speed : 120` *Valeur par défaut : 50* La vitesse à laquelle l'outil se déplace entre les points palpés.
- `horizontal_move_z : 5` *Valeur par défaut : 5* La coordonnée Z à laquelle la sonde s'élève avant de se déplacer entre les points.
- `mesh_min : 35, 6` *Requis* La première coordonnée palpée, la plus proche de l'origine. Cette coordonnée est relative à l'emplacement de la sonde.
- `mesh_max: 240, 198` *Required* The probed coordinate farthest from the origin. This is not necessarily the last point probed, as the probing process occurs in a zig-zag fashion. As with `mesh_min`, this coordinate is relative to the probe's location.
- `probe_count : 5, 3` *Valeur par défaut : 3, 3* Le nombre de points à palper sur chaque axe, spécifié sous forme de valeurs entières X, Y. Dans cet exemple, 5 points seront palpés le long de l'axe X, avec 3 points le long de l'axe Y, pour un total de 15 points palpés. Notez que si vous voulez une grille carrée, par exemple 3x3, il est possible de n'utiliser qu'une seule valeur entière pour les deux axes, par exemple `probe_count : 3`. Notez qu'un maillage nécessite un nombre minimum de 3 points de sondage sur chaque axe.

L'illustration ci-dessous montre comment les options `mesh_min`, `mesh_max`, et `probe_count` sont utilisées pour générer des points de palpage. Les flèches indiquent la direction de la procédure de palpage, commençant en `mesh_min`. Pour référence, lorsque la sonde est à `mesh_min`, la buse sera à (11, 1), et lorsque la sonde est à `mesh_max`, la buse sera à (206, 193).

![bedmesh_rect_basic](img/bedmesh_rect_basic.svg)

### Lits circulaires

Cet exemple suppose une imprimante équipée d'un lit circulaire de 100 mm de rayon. Nous utiliserons les mêmes décalages de sonde que dans l'exemple rectangulaire, 24 mm sur X et 5 mm sur Y.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius : 75` *Requis* Le rayon du maillage palpé en mm, par rapport à `mesh_origin`. Notez que les décalages de la sonde limitent la taille du rayon du maillage. Dans cet exemple, un rayon supérieur à 76 déplacerait la tête de l'outil en dehors des limites physiques de l'imprimante.
- `mesh_origin : 0, 0` *Valeur par défaut : 0, 0* Le point central du maillage. Cette coordonnée est relative à l'emplacement de la sonde. Bien que la valeur par défaut soit 0, 0, il peut être utile d'ajuster l'origine dans le but de sonder une plus grande partie du lit. Voir l'illustration ci-dessous.
- `round_probe_count : 5` *Valeur par défaut : 5* C'est une valeur entière définissant le nombre maximum de points palpés le long des axes X et Y. Par "maximum", nous entendons le nombre de points palpés le long de l'origine du maillage. Cette valeur doit être un nombre impair, car il est nécessaire que le centre du maillage soit palpé.

L'illustration ci-dessous montre comment les points palpés sont générés. Comme vous pouvez le voir, définir `mesh_origin` sur (-10, 0) nous permet de spécifier un rayon de maillage plus grand de 85.

![bedmesh_round_basic](img/bedmesh_round_basic.svg)

## Configuration avancée

Les options de configuration plus avancées sont expliquées en détail ci-dessous. Chaque exemple s'appuie sur la configuration de base du lit rectangulaire présentée ci-dessus. Chacune des options avancées s'applique de la même manière aux lits circulaires.

### Interpolation du maillage

Bien qu'il soit possible d'échantillonner directement la matrice sondée à l'aide d'une simple interpolation bilinéaire pour déterminer les valeurs Z entre les points sondés, il est souvent utile d'interpoler des points supplémentaires à l'aide d'algorithmes d'interpolation plus avancés pour augmenter la densité du maillage. Ces algorithmes ajoutent une courbure au maillage, tentant de simuler les propriétés matérielles du lit. Bed Mesh offre une interpolation lagrange et bicubique pour y parvenir.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
mesh_pps: 2, 3
algorithm: bicubic
bicubic_tension: 0.2
```

- `mesh_pps : 2, 3` *Valeur par défaut : 2, 2* L'option `mesh_pps` est l'abréviation de Mesh Points Per Segment. Cette option indique le nombre de points à interpoler pour chaque segment le long des axes X et Y. Un 'segment' est l'espace entre chaque point palpé. Comme pour `probe_count`, `mesh_pps` est spécifié en tant que paire de nombres entiers X, Y mais peut aussi être spécifié comme un seul nombre entier en ce cas appliqué aux deux axes. Dans cet exemple, il y a 4 segments le long de l'axe X et 2 segments le long de l'axe Y. Cela résulte en 8 points interpolés le long de l'axe X et 6 points interpolés le long de l'axe Y, ce qui donne un maillage de 13x8. Notez que si mesh_pps est défini à 0, l'interpolation de maillage est désactivée et la matrice sondée sera échantillonnée directement.
- `algorithm : lagrange` *Valeur par défaut : lagrange* L'algorithme utilisé pour interpoler le maillage. Peut être `lagrange` ou `bicubique`. L'interpolation de Lagrange est plafonnée à 6 points palpés car une oscillation tend à se produire avec un plus grand nombre d'échantillons. L'interpolation bicubique requiert un minimum de 4 points le long de chaque axe, si moins de 4 points sont spécifiés, l'échantillonnage de Lagrange est forcé. Si `mesh_pps` est défini à 0 alors cette valeur est ignorée car aucune interpolation de maille n'est faite.
- `bicubic_tension : 0.2` *Valeur par défaut : 0.2* Si l'option `algorithm` est définie sur bicubique, il est possible d'indiquer une valeur de tension. Plus la tension est élevée, plus la pente est interpolée. Soyez prudent lorsque vous ajustez cette valeur, car des valeurs plus élevées créent également plus de dépassement, ce qui entraînera des valeurs interpolées plus élevées ou plus basses que vos points palpés.

L'illustration ci-dessous montre comment les options ci-dessus sont utilisées pour générer un maillage interpolé.

![bedmesh_interpolated](img/bedmesh_interpolated.svg)

### Fractionnement des déplacements

Le maillage du lit fonctionne en interceptant les commandes de déplacement du gcode et en appliquant une transformation à leur coordonnée Z. Les longs déplacements doivent être divisés en déplacements plus petits pour suivre correctement la forme du lit. Les options ci-dessous contrôlent le comportement du fractionnement.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
move_check_distance: 5
split_delta_z: .025
```

- `move_check_distance : 5` *Valeur par défaut : 5* La distance minimale de vérification de changement de Z souhaité avant d'effectuer un fractionnemeny. Dans cet exemple, un mouvement de plus de 5mm sera traversé par l'algorithme. Tous les 5 mm, une recherche de maille Z sera effectuée, en la comparant à la valeur Z du mouvement précédent. Si le delta atteint le seuil fixé par `split_delta_z`, le mouvement sera divisé et la traversée continuera. Ce processus se répète jusqu'à ce que la fin du déplacement soit atteinte, où un ajustement final sera appliqué. Les déplacements plus courts que la `move_check_distance` ont l'ajustement Z correct appliqué directement au déplacement sans traversée ou division.
- `split_delta_z : .025` *Valeur par défaut : .025* Comme mentionné ci-dessus, il s'agit de l'écart minimum requis pour déclencher un fractionnement du mouvement. Dans cet exemple, toute valeur Z avec un écart de +/- 0,025 mm déclenchera un fractionnement.

Généralement, les valeurs par défaut de ces options sont suffisantes, en fait la valeur par défaut de 5 mm pour la `move_check_distance` peut être exagérée. Cependant, un utilisateur avancé peut souhaiter expérimenter ces options afin d'obtenir une première couche optimale.

### Atténuation du maillage

Lorsque l'option "fondu" est activée, l'ajustement du Z est réduit progressivement sur une distance définie par la configuration. Ceci est réalisé en appliquant de petits ajustements à la hauteur de la couche, en augmentant ou en diminuant selon la forme du lit. Lorsque le fondu est terminé, l'ajustement Z n'est plus appliqué, ce qui permet au sommet de l'impression d'être plat plutôt que de refléter la forme du lit. Le fondu peut également présenter quelques caractéristiques indésirables, si le fondu est effectué trop rapidement, il peut entraîner des artefacts visibles sur l'impression. De plus, si votre lit est sensiblement déformé, le fondu peut rétrécir ou étirer la hauteur Z de l'impression. C'est pourquoi le fondu est désactivé par défaut.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
fade_start: 1
fade_end: 10
fade_target: 0
```

- `fade_start: 1` *Valeur par défaut : 1* La hauteur Z à laquelle il faut commencer l'atténuation progressive de l'ajustement. C'est une bonne idée d'avoir quelques couches déjà déposées avant de commencer le processus de fondu.
- `fade_end : 10` *Valeur par défaut : 0* La hauteur Z à laquelle le fondu doit s'arrêter. Si cette valeur est inférieure à `fade_start`, le fondu est désactivé. Cette valeur peut être ajustée en fonction de la déformation de la surface d'impression. Une surface fortement déformée devrait s'estomper sur une plus grande distance. Une surface presque plate peut être capable de réduire cette valeur pour s'estomper plus rapidement. 10mm est une valeur raisonnable pour commencer si vous utilisez la valeur par défaut de 1 pour `fade_start`.
- `fade_target : 0` *Valeur par défaut : la valeur Z moyenne du maillage* Le `fade_target` peut être considéré comme un décalage Z supplémentaire appliqué à l'ensemble du lit une fois l'interpolation terminée . L'idéal serait d'avoir cette valeur à 0, mais il y a des circonstances où elle ne peut pas l'être. Par exemple, supposons que votre position de référence sur le lit est une valeur aberrante, 0,2 mm inférieure à la hauteur moyenne sondée du lit. Si le `fade_target` est 0, le fondu réduira l'impression de 0,2 mm en moyenne sur le lit. En réglant `fade_target` sur 0,2, la zone référencée s'agrandira de 0,2 mm, cependant, le reste du lit sera dimensionné avec précision. Généralement, c'est une bonne idée de laisser `fade_target` hors de la configuration afin que la hauteur moyenne du maillage soit utilisée, cependant il peut être souhaitable d'ajuster manuellement cette valeur si l'on veut imprimer sur une partie spécifique du lit.

### Configuration de la position d'origine

Many probes are susceptible to "drift", ie: inaccuracies in probing introduced by heat or interference. This can make calculating the probe's z-offset challenging, particularly at different bed temperatures. As such, some printers use an endstop for homing the Z axis and a probe for calibrating the mesh. In this configuration it is possible offset the mesh so that the (X, Y) `reference position` applies zero adjustment. The `reference postion` should be the location on the bed where a [Z_ENDSTOP_CALIBRATE](./Manual_Level.md#calibrating-a-z-endstop) paper test is performed. The bed_mesh module provides the `zero_reference_position` option for specifying this coordinate:

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
zero_reference_position: 125, 110
probe_count: 5, 3
```

- `zero_reference_position: ` *Default Value: None (disabled)* The `zero_reference_position` expects an (X, Y) coordinate matching that of the `reference position` described above. If the coordinate lies within the mesh then the mesh will be offset so the reference position applies zero adjustment. If the coordinate lies outside of the mesh then the coordinate will be probed after calibration, with the resulting z-value used as the z-offset. Note that this coordinate must NOT be in a location specified as a `faulty_region` if a probe is necessary.

#### The deprecated relative_reference_index

Existing configurations using the `relative_reference_index` option must be updated to use the `zero_reference_position`. The response to the [BED_MESH_OUTPUT PGP=1](#output) gcode command will include the (X, Y) coordinate associated with the index; this position may be used as the value for the `zero_reference_position`. The output will look similar to the following:

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (1.0, 1.0) | (24.0, 6.0)
// 1 | (36.7, 1.0) | (59.7, 6.0)
// 2 | (72.3, 1.0) | (95.3, 6.0)
// 3 | (108.0, 1.0) | (131.0, 6.0)
... (additional generated points)
// bed_mesh: relative_reference_index 24 is (131.5, 108.0)
```

*Note: The above output is also printed in `klippy.log` during initialization.*

Using the example above we see that the `relative_reference_index` is printed along with its coordinate. Thus the `zero_reference_position` is `131.5, 108`.

### Régions défectueuses

Il est possible que certaines zones d'un lit donnent des résultats inexacts lors du palpage en raison d'un "défaut" à des endroits particuliers. Le meilleur exemple de ce phénomène est celui des lits comportant une série d'aimants intégrés utilisés pour retenir les tôles d'acier amovibles. Le champ magnétique au niveau et autour de ces aimants peut faire qu'une sonde inductive se déclenche à une distance plus élevée ou plus basse qu'elle ne le ferait autrement, ce qui donne un maillage ne représentant pas précisément la surface à ces endroits. **Remarque : Il ne faut pas confondre ce phénomène avec le biais de l'emplacement de la sonde, qui produit des résultats inexacts sur l'ensemble du lit.**

Les options `faulty_region` peuvent être configurées pour compenser cet effet. Si un point généré se trouve dans une région défectueuse, le maillage du lit tentera de palper jusqu'à 4 points aux limites de cette région. Ces valeurs palpées seront moyennées et insérées dans le maillage comme valeur Z à la coordonnée (X, Y) générée.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
faulty_region_1_min: 130.0, 0.0
faulty_region_1_max: 145.0, 40.0
faulty_region_2_min: 225.0, 0.0
faulty_region_2_max: 250.0, 25.0
faulty_region_3_min: 165.0, 95.0
faulty_region_3_max: 205.0, 110.0
faulty_region_4_min: 30.0, 170.0
faulty_region_4_max: 45.0, 210.0
```

- `faulty_region_{1...99}_min` `faulty_region_{1..99}_max` *Valeur par défaut : None (désactivé)* Les régions défectueuses sont définies d'une manière similaire à celle du maillage lui-même, où les coordonnées minimum et maximum (X, Y) doivent être infiquées pour chaque région. Une région défectueuse peut s'étendre à l'extérieur d'un maillage, mais les points alternatifs générés seront toujours à l'intérieur des limites du maillage. Deux régions ne peuvent pas se chevaucher.

L'image ci-dessous illustre comment les points de remplacement sont générés lorsqu'un point généré se trouve dans une région défectueuse. Les régions représentées correspondent à celles de l'exemple de configuration ci-dessus. Les points de remplacement et leurs coordonnées sont identifiés en vert.

![bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

### Adaptive Meshes

Adaptive bed meshing is a way to speed up the bed mesh generation by only probing the area of the bed used by the objects being printed. When used, the method will automatically adjust the mesh parameters based on the area occupied by the defined print objects.

The adapted mesh area will be computed from the area defined by the boundaries of all the defined print objects so it covers every object, including any margins defined in the configuration. After the area is computed, the number of probe points will be scaled down based on the ratio of the default mesh area and the adapted mesh area. To illustrate this consider the following example:

For a 150mmx150mm bed with `mesh_min` set to `25,25` and `mesh_max` set to `125,125`, the default mesh area is a 100mmx100mm square. An adapted mesh area of `50,50` means a ratio of `0.5x0.5` between the adapted area and default mesh area.

If the `bed_mesh` configuration specified `probe_count` as `7x7`, the adapted bed mesh will use 4x4 probe points (7 * 0.5 rounded up).

![adaptive_bedmesh](img/adaptive_bed_mesh.svg)

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
adaptive_margin: 5
```

- `adaptive_margin`  *Default Value: 0*  Margin (in mm) to add around the area of the bed used by the defined objects. The diagram below shows the adapted bed mesh area with an `adaptive_margin` of 5mm. The adapted mesh area (area in green) is computed as the used bed area (area in blue) plus the defined margin.

   ![adaptive_bedmesh_margin](img/adaptive_bed_mesh_margin.svg)

By nature, adaptive bed meshes use the objects defined by the Gcode file being printed. Therefore, it is expected that each Gcode file will generate a mesh that probes a different area of the print bed. Therefore, adapted bed meshes should not be re-used. The expectation is that a new mesh will be generated for each print if adaptive meshing is used.

It is also important to consider that adaptive bed meshing is best used on machines that can normally probe the entire bed and achieve a maximum variance less than or equal to 1 layer height. Machines with mechanical issues that a full bed mesh normally compensates for may have undesirable results when attempting print moves **outside** of the probed area. If a full bed mesh has a variance greater than 1 layer height, caution must be taken when using adaptive bed meshes and attempting print moves outside of the meshed area.

## Surface Scans

Some probes, such as the [Eddy Current Probe](./Eddy_Probe.md), are capable of "scanning" the surface of the bed. That is, these probes can sample a mesh without lifting the tool between samples. To activate scanning mode, the `METHOD=scan` or `METHOD=rapid_scan` probe parameter should be passed in the `BED_MESH_CALIBRATE` gcode command.

### Scan Height

The scan height is set by the `horizontal_move_z` option in `[bed_mesh]`. In addition it can be supplied with the `BED_MESH_CALIBRATE` gcode command via the `HORIZONTAL_MOVE_Z` parameter.

The scan height must be sufficiently low to avoid scanning errors. Typically a height of 2mm (ie: `HORIZONTAL_MOVE_Z=2`) should work well, presuming that the probe is mounted correctly.

It should be noted that if the probe is more than 4mm above the surface then the results will be invalid. Thus, scanning is not possible on beds with severe surface deviation or beds with extreme tilt that hasn't been corrected.

### Rapid (Continuous) Scanning

When performing a `rapid_scan` one should keep in mind that the results will have some amount of error. This error should be low enough to be useful on large print areas with reasonably thick layer heights. Some probes may be more prone to error than others.

It is not recommended that rapid mode be used to scan a "dense" mesh. Some of the error introduced during a rapid scan may be gaussian noise from the sensor, and a dense mesh will reflect this noise (ie: there will be peaks and valleys).

Bed Mesh will attempt to optimize the travel path to provide the best possible result based on the configuration. This includes avoiding faulty regions when collecting samples and "overshooting" the mesh when changing direction. This overshoot improves sampling at the edges of a mesh, however it requires that the mesh be configured in a way that allows the tool to travel outside of the mesh.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5
scan_overshoot: 8
```

- `scan_overshoot` *Default Value: 0 (disabled)* The maximum amount of travel (in mm) available outside of the mesh. For rectangular beds this applies to travel on the X axis, and for round beds it applies to the entire radius. The tool must be able to travel the amount specified outside of the mesh. This value is used to optimize the travel path when performing a "rapid scan". The minimum value that may be specified is 1. The default is no overshoot.

If no scan overshoot is configured then travel path optimization will not be applied to changes in direction.

## Gcodes de maillage du lit

### Calibration

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic | scan | rapid_scan] \ [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] \ [ADAPTIVE_MARGIN=<value>]` *Default Profile: default* *Default Method: automatic if a probe is detected, otherwise manual*  *Default Adaptive: 0*  *Default Adaptive Margin: 0*

Lance la procédure de palpage de l'étalonnage du maillage du lit.

The mesh will be immediately ready to use when the command completes and saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. The `METHOD` parameter takes one of the following values:

- `METHOD=manual`: enables manual probing using the nozzle and the paper test
- `METHOD=automatic`: Automatic (standard) probing. This is the default.
- `METHOD=scan`: Enables surface scanning. The tool will pause over each position to collect a sample.
- `METHOD=rapid_scan`: Enables continuous surface scanning.

XY positions are automatically adjusted to include the X and/or Y offsets when a probing method other than `manual` is selected.

Il est possible de spécifier des paramètres de maillage pour modifier la zone palpée. Les paramètres suivants sont disponibles :

- Lits rectangulaires (cartésiens) :
   - `MESH_MIN`
   - `MESH_MAX`
   - `PROBE_COUNT`
- Lits circulaires (delta) :
   - `MESH_RADIUS`
   - `MESH_ORIGIN`
   - `ROUND_PROBE_COUNT`
- Tous les lits :
   - `MESH_PPS`
   - `ALGORITHM`
   - `ADAPTIVE`
   - `ADAPTIVE_MARGIN`

Consultez la documentation de configuration ci-dessus pour plus de détails sur la façon dont chaque paramètre s'applique au maillage.

### Profils

`BED_MESH_PROFILE SAVE=<name> LOAD=<name> REMOVE=<name>`

Après avoir réalisé un BED_MESH_CALIBRATE, il est possible de sauvegarder l'état actuel du maillage dans un profil nommé. Cela permet de charger un maillage sans re-palper le lit. Après qu'un profil ait été enregistré en utilisant `BED_MESH_PROFILE SAVE=<name>`, le gcode `SAVE_CONFIG` peut être exécuté pour écrire le profil dans printer.cfg.

Les profils peuvent être chargés en exécutant `BED_MESH_PROFILE LOAD=<name>`.

Il convient de noter qu'à chaque fois qu'un BED_MESH_CALIBRATE se produit, l'état actuel est automatiquement enregistré dans le profil *default*. Le profil *default* peut être supprimé comme suit :

`BED_MESH_PROFILE REMOVE=default`

Tout autre profil enregistré peut être supprimé de la même manière, en remplaçant *default* par le nom du profil que vous souhaitez supprimer.

#### Chargement du profil par défaut

Les versions précédentes de `bed_mesh` chargeaient toujours le profil nommé *default* au démarrage s'il était présent. Ce comportement a été supprimé afin de permettre à l'utilisateur de déterminer quand un profil est chargé. Si un utilisateur souhaite charger le profil par défaut, il est recommandé d'ajouter `BED_MESH_PROFILE LOAD=default` à sa macro `START_PRINT` ou à la configuration "Start G-Code" de son trancheur, selon ce qui est applicable.

Note that this is not required if a new mesh is generated with `BED_MESH_CALIBRATE` in the `START_PRINT` macro or the slicer's "Start G-Code" and may produce unexpected results, especially with adaptive meshing.

Alternativement, l'ancien comportement de chargement d'un profil au démarrage peut être restauré avec un `[delayed_gcode]` :

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### Sortie

`BED_MESH_OUTPUT PGP=[0 | 1]`

Affiche l'état actuel du maillage dans le terminal. Notez que le maillage lui-même est affiché

Le paramètre PGP est l'abréviation de "Print Generated Points". Si `PGP=1` est défini, les points palpés générés seront affichés sur le terminal :

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (11.0, 1.0) | (35.0, 6.0)
// 1 | (62.2, 1.0) | (86.2, 6.0)
// 2 | (113.5, 1.0) | (137.5, 6.0)
// 3 | (164.8, 1.0) | (188.8, 6.0)
// 4 | (216.0, 1.0) | (240.0, 6.0)
// 5 | (216.0, 97.0) | (240.0, 102.0)
// 6 | (164.8, 97.0) | (188.8, 102.0)
// 7 | (113.5, 97.0) | (137.5, 102.0)
// 8 | (62.2, 97.0) | (86.2, 102.0)
// 9 | (11.0, 97.0) | (35.0, 102.0)
// 10 | (11.0, 193.0) | (35.0, 198.0)
// 11 | (62.2, 193.0) | (86.2, 198.0)
// 12 | (113.5, 193.0) | (137.5, 198.0)
// 13 | (164.8, 193.0) | (188.8, 198.0)
// 14 | (216.0, 193.0) | (240.0, 198.0)
```

Les points de la colonne "Tool Adjusted" font référence à l'emplacement de la buse, et les points de la colonne "Probe" font référence à l'emplacement du palpeur. Notez que lors d'un palpage manuel, les points "Probe" se réfèrent à la fois à l'emplacement de l'outil et de la buse.

### Effacer l'état du maillage

`BED_MESH_CLEAR`

Ce G-Code peut être utilisé pour effacer l'état interne du maillage.

### Appliquer les décalages X/Y

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value>]`

This is useful for printers with multiple independent extruders, as an offset is necessary to produce correct Z adjustment after a tool change. Offsets should be specified relative to the primary extruder. That is, a positive X offset should be specified if the secondary extruder is mounted to the right of the primary extruder, a positive Y offset should be specified if the secondary extruder is mounted "behind" the primary extruder, and a positive ZFADE offset should be specified if the secondary extruder's nozzle is above the primary extruder's.

Note that a ZFADE offset does *NOT* directly apply additional adjustment. It is intended to compensate for a `gcode offset` when [mesh fade](#mesh-fade) is enabled. For example, if a secondary extruder is higher than the primary and needs a negative gcode offset, ie: `SET_GCODE_OFFSET Z=-.2`, it can be accounted for in `bed_mesh` with `BED_MESH_OFFSET ZFADE=.2`.

## Bed Mesh Webhooks APIs

### Dumping mesh data

`{"id": 123, "method": "bed_mesh/dump_mesh"}`

Dumps the configuration and state for the current mesh and all saved profiles.

The `dump_mesh` endpoint takes one optional parameter, `mesh_args`. This parameter must be an object, where the keys and values are parameters available to [BED_MESH_CALIBRATE](#bed_mesh_calibrate). This will update the mesh configuration and probe points using the supplied parameters prior to returning the result. It is recommended to omit mesh parameters unless it is desired to visualize the probe points and/or travel path before performing `BED_MESH_CALIBRATE`.

## Visualization and analysis

Most users will likely find that the visualizers included with applications such as Mainsail, Fluidd, and Octoprint are sufficient for basic analysis. However, Klipper's `scripts` folder contains the `graph_mesh.py` script that may be used to perform additional visualizations and more detailed analysis, particularly useful for debugging hardware or the results produced by `bed_mesh`:

```
usage: graph_mesh.py [-h] {list,plot,analyze,dump} ...

Graph Bed Mesh Data

positional arguments:
  {list,plot,analyze,dump}
    list                List available plot types
    plot                Plot a specified type
    analyze             Perform analysis on mesh data
    dump                Dump API response to json file

options:
  -h, --help            show this help message and exit
```

### Pre-requisites

Like most graphing tools provided by Klipper, `graph_mesh.py` requires the `matplotlib` and `numpy` python dependencies. In addition, connecting to Klipper via Moonraker's websocket requires the `websockets` python dependency. While all visualizations can be output to an `svg` file, most of the visualizations offered by `graph_mesh.py` are better viewed in live preview mode on a desktop class PC. For example, the 3D visualizations may be rotated and zoomed in preview mode, and the path visualizations can optionally be animated in preview mode.

### Plotting Mesh data

The `graph_mesh.py` tool can plot several types of visualizations. Available types can be shown by running `graph_mesh.py list`:

```
graph_mesh.py list
points    Plot original generated points
path      Plot probe travel path
rapid     Plot rapid scan travel path
probedz   Plot probed Z values
meshz     Plot mesh Z values
overlay   Plots the current probed mesh overlaid with a profile
delta     Plots the delta between current probed mesh and a profile
```

Several options are available when plotting visualizations:

```
usage: graph_mesh.py plot [-h] [-a] [-s] [-p PROFILE_NAME] [-o OUTPUT] <plot type> <input>

positional arguments:
  <plot type>           Type of data to graph
  <input>               Path/url to Klipper Socket or path to json file

options:
  -h, --help            show this help message and exit
  -a, --animate         Animate paths in live preview
  -s, --scale-plot      Use axis limits reported by Klipper to scale plot X/Y
  -p PROFILE_NAME, --profile-name PROFILE_NAME
                        Optional name of a profile to plot for 'probedz'
  -o OUTPUT, --output OUTPUT
                        Output file path
```

Below is a description of each argument:

- `plot type`: A required positional argument designating the type of visualization to generate. Must be one of the types output by the `graph_mesh.py list` command.
- `input`: A required positional argument containing a path or url to the input source. This must be one of the following:
   - A path to Klipper's Unix Domain Socket
   - A url to an instance of Moonraker
   - A path to a json file produced by `graph_mesh.py dump <input>`
- `-a`: Optional animation for the `path` and `rapid` visualization types. Animations only apply to a live preview.
- `-s`: Optionally scales a plot using the `axis_minimum` and `axis_maximum` values reported by Klipper's `toolhead` object when the dump file was generated.
- `-p`: A profile name that may be specified when generating the `probedz` 3D mesh visualization. When generating an `overlay` or `delta` visualization this argument must be provided.
- `-o`: An optional file path indicating that the script should save the visualization to this location rather than run in preview mode. Images are saved in `svg` format.

For example, to plot an animated rapid path, connecting via Klipper's unix socket:

```
graph_mesh.py plot -a rapid ~/printer_data/comms/klippy.sock
```

Or to plot a 3d visualization of the mesh, connecting via Moonraker:

```
graph_mesh.py plot meshz http://my-printer.local
```

### Bed Mesh Analysis

The `graph_mesh.py` tool may also be used to perform an analysis on the data provided by the [bed_mesh/dump_mesh](#dumping-mesh-data) API:

```
graph_mesh.py analyze <input>
```

As with the `plot` command, the `<input>` must be a path to Klipper's unix socket, a URL to an instance of Moonraker, or a path to a json file generated by the dump command.

To begin, the analysis will perform various checks on the points and probe paths generated by `bed_mesh` at the time of the dump. This includes the following:

- The number of probe points generated, without any additions
- The number of probe points generated including any points generated as the result faulty regions and/or a configured zero reference position.
- The number of probe points generated when performing a rapid scan.
- The total number of moves generated for a rapid scan.
- A validation that the probe points generated for a rapid scan are identical to the probe points generated for a standard probing procedure.
- A "backtracking" check for both the standard probe path and a rapid scan path. Backtracking can be defined as moving to the same position more than once during the probing procedure. Backtracking should never occur during a standard probe. Faulty regions *can* result in backtracking during a rapid scan in an attempt to avoid entering a faulty region when approaching or leaving a probe location, however should never occur otherwise.

Next each probed mesh present in the dump will by analyzed, beginning with the mesh loaded at the time of the dump (if present) and followed by any saved profiles. The following data is extracted:

- Mesh shape (Min X,Y, Max X,Y Probe Count)
- Mesh Z range, (Minimum Z, Maximum Z)
- Mean Z value in the mesh
- Standard Deviation of the Z values in the Mesh

In addition to the above, a delta analysis is performed between meshes with the same shape, reporting the following:

- The range of the delta between to meshes (Minimum and Maximum)
- The mean delta
- Standard Deviation of the delta
- The absolute maximum difference
- The absolute mean

### Save mesh data to a file

The `dump` command may be used to save the response to a file which can be shared for analysis when troubleshooting:

```
graph_mesh.py dump -o <output file name> <input>
```

The `<input>` should be a path to Klipper's unix socket or a URL to an instance of Moonraker. The `-o` option may be used to specify the path to the output file. If omitted, the file will be saved in the working directory, with a file name in the following format:

`klipper-bedmesh-{year}{month}{day}{hour}{minute}{second}.json`
