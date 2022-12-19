# Distance de rotation

Les pilotes de moteur pas à pas avec Klipper nécessitent un paramètre `rotation_distance` dans chaque [section de configuration des pilotes pas à pas](Config_Reference.md#stepper). La `rotation_distance` est la distance parcourue par l'axe après un tour complet du moteur pas à pas. Ce document décrit comment configurer cette valeur.

## Obtention de la distance de rotation à partir de steps_per_mm (ou step_distance)

Les concepteurs de votre imprimante 3d ont calculé à l'origine les `pas_par_mm` à partir d'une distance de rotation. Si vous connaissez les pas_par_mm, il est possible d'utiliser cette formule générale pour obtenir cette distance de rotation originale :

```
rotation_distance = <full_steps_par_rotation> * <microsteps> / <steps_par_mm>
```

Ou, si vous avez une ancienne configuration Klipper et que vous connaissez le paramètre `step_distance`, vous pouvez utiliser cette formule :

```
rotation_distance = <full_steps_per_rotation> * <microsteps> * <step_distance>
```

Le paramètre `<full_steps_per_rotation>` est déterminé par le type du moteur pas à pas. La plupart des moteurs pas à pas sont des "pas à pas de 1,8 degré" et ont donc 200 pas complets par rotation (360 divisé par 1,8 est égal à 200). Certains moteurs pas à pas sont des "pas à pas de 0,9 degré" et ont donc 400 pas complets par rotation. D'autres type de moteurs pas à pas sont rares. En cas de doute, ne définissez pas full_steps_per_rotation dans le fichier de configuration et utilisez 200 dans la formule ci-dessus.

Le paramètre `<microsteps>` est déterminé par le pilote du moteur pas à pas. La plupart des pilotes utilisent 16 micro-pas. Si vous n'êtes pas sûr, définissez `microsteps : 16` dans la configuration et utilisez 16 dans la formule ci-dessus.

Presque toutes les imprimantes devraient utiliser un nombre entier pour la `distance de rotation` des axes de type X, Y, et Z. Si la formule ci-dessus donne une distance de rotation qui est à moins de 0,01 d'un nombre entier, arrondissez la valeur finale à ce nombre entier.

## Calibration de la distance de rotation des extrudeuses

Sur une extrudeuse, la `rotation_distance` est la distance que parcourt le filament durant une rotation complète du moteur pas à pas. La meilleure façon d'obtenir une valeur précise pour ce paramètre est d'utiliser une procédure de "mesure et ajustement".

Commencez par une estimation initiale de la distance de rotation. Elle peut être obtenue à partir de [pas_par_mm](#obtaining-rotation_distance-from-steps_per_mm-or-step_distance) ou en [inspectant le matériel](#extruder).

Utilisez ensuite la procédure suivante pour "mesurer et ajuster" :

1. Assurez-vous que l'extrudeuse contient du filament, que le bloc chauffant est à une température appropriée et que l'imprimante est prête à extruder.
1. Utilisez un marqueur pour placer une marque sur le filament à environ 70 mm de l'entrée du corps de l'extrudeuse. Utilisez ensuite un pied à coulisse numérique pour mesurer la distance réelle de cette marque aussi précisément que possible. Notez cette mesure comme `<initial_mark_distance>`.
1. Extrudez 50 mm de filament avec la séquence de commandes suivante : `G91` suivi de `G1 E50 F60`. Notez 50mm comme `<distance_extrudée_requise>`. Attendez que l'extrudeuse termine son mouvement (cela prendra environ 50 secondes). Il est important d'utiliser la vitesse d'extrusion lente pour ce test car une vitesse plus rapide peut provoquer une pression élevée dans l'extrudeuse qui fausserait les résultats. (N'utilisez pas le "bouton d'extrusion" des interfaces graphiques pour ce test car ils extrudent à une vitesse rapide.)
1. Utilisez le pied à coulisse numérique pour mesurer la nouvelle distance entre le corps de l'extrudeuse et la marque sur le filament. Notez cette distance comme `<distance_marque_suivante>`. Calculez ensuite : `Distance_extrudée_réelle = <distance_marque_initiale> - <distance_marque_suivante>`
1. Calculez la distance de rotation comme suit : `distance_rotation = <distance_rotation_précédente> * <distance_extrusion_réelle> / <distance_extrusion_demandée>` Arrondissez la nouvelle distance_rotation à trois décimales.

Si la distance_extrudée_réelle diffère de la distance_extrudée_requise de plus de 2 mm environ, il est bon d'effectuer les étapes ci-dessus une nouvelle fois.

Remarque : n'utilisez *pas* une méthode de type " mesurer et ajuster " pour calibrer les axes de type x, y ou z. La méthode " mesurer et ajuster " n'est pas assez précise pour ces axes et conduira probablement à une configuration moins bonne. Au lieu de cela, si nécessaire, ces axes peuvent être déterminés en [mesurant les courroies, les poulies et les vis-mère](#obtaining-rotation_distance-by-inspecting-the-hardware).

## Obtention de la distance de rotation par l'inspection du matériel

Il est possible de calculer la distance de rotation en connaissant les moteurs pas à pas et la cinématique de l'imprimante. Cela peut être utile si le nombre de pas par mm n'est pas connu ou si l'on conçoit une nouvelle imprimante.

### Axes entraînés par courroie

Il est facile de calculer la distance de rotation pour un axe linéaire utilisant une courroie et une poulie.

Déterminez d'abord le type de courroie. La plupart des imprimantes utilisent un pas de courroie de 2 mm (c'est-à-dire que chaque dent de la courroie est espacée de 2 mm). Comptez ensuite le nombre de dents sur la poulie du moteur pas à pas. La distance de rotation est alors calculée comme suit :

```
rotation_distance = <belt_pitch> * <number_of_teeth_on_pulley>
```

Par exemple, si une imprimante a une courroie dont le pas est de 2 mm et utilise une poulie à 20 dents, la distance de rotation est de 40.

### Axes avec vis-mère

Il est facile de calculer la distance de rotation pour les vis-mères communes à l'aide de la formule suivante :

```
rotation_distance = <screw_pitch> * <number_of_separate_threads>
```

Par exemple, la "vis-mère T8" courante a une distance de rotation de 8 (elle a un pas de 2 mm et comporte 4 filets séparés).

Les imprimantes plus anciennes équipées de "tiges filetées" n'ont qu'un seul "filetage" sur la vis-mère et la distance de rotation correspond donc au pas de la vis. (Le pas de la vis est la distance entre chaque rainure de la vis). Ainsi, par exemple, une tige métrique M6 a une distance de rotation de 1 et une tige M8 a une distance de rotation de 1,25.

### Extrudeuse

Il est possible d'obtenir une distance de rotation initiale pour les extrudeuses en mesurant le diamètre de la "roue dentée" entrainant le filament, en utilisant la formule suivante : `distance_de_rotation = <diamètre> * 3.14`

Si l'extrudeuse utilise des engrenages, il faudra également [déterminer et régler le rapport de démultiplication](#using-a-gear_ratio) pour celle-ci.

La distance de rotation réelle d'une extrudeuse varie d'une imprimante à l'autre, car la prise de la "roue crénelée" qui s'engage dans le filament peut varier. Elle peut même varier d'une bobine de filament à l'autre. Après avoir obtenu une distance de rotation initiale, utilisez la [procédure de mesure et d'ajustement](#calibrating-rotation_distance-on-extruders) pour obtenir un réglage plus précis.

## Utilisation d'un gear_ratio

Définir un `gear_ratio` peut faciliter la configuration de la `rotation_distance` des moteurs ayant une boîte de vitesse (ou similaire) attachée à eux. La plupart des moteurs n'ont pas de boîte de vitesse - si vous n'êtes pas sûr, n'utilisez pas de `gear_ratio` dans la configuration.

Lorsqu'un `gear_ratio` est défini, la `rotation_distance` représente la distance parcourue par l'axe lors d'une rotation complète du dernier engrenage de la boîte de vitesses. Si, par exemple, on utilise une boîte de vitesses avec un rapport "5:1", on peut calculer la distance de rotation avec [connaissance du matériel](#obtaining-rotation_distance-by-inspecting-the-hardware) et ensuite ajouter `gear_ratio : 5:1` à la configuration.

Pour des engrenages mis en œuvre avec des courroies et des poulies, il est possible de déterminer le rapport de démultiplication en comptant les dents des poulies. Par exemple, si une poulie de 16 dents entraîne la poulie suivante de 80 dents, on utilisera `gear_ratio : 80:16`. En effet, on peut ouvrir une "boîte de vitesse" courante et compter les dents pour confirmer le rapport d'engrenage.

Notez que parfois, une boîte de vitesses aura un rapport de transmission légèrement différent de celui qui est annoncé. Les engrenages courants du moteur d'extrudeuse BMG en sont un exemple - ils sont annoncés comme étant de "3:1" mais utilisent en réalité un engrenage de "50:17". (L'utilisation de nombres de dents sans dénominateur commun peut améliorer l'usure globale de l'engrenage car les dents ne s'engrènent pas toujours de la même manière à chaque tour). La "boite de vitesses planétaire 5.18:1" commune, est plus précisément configurée avec un `gear_ratio : 57:11`.

Si plusieurs engrenages sont utilisés sur un axe, il est possible de fournir une liste séparée par des virgules au paramètre gear_ratio. Par exemple, une boîte de vitesse "5:1" entraînant une poulie de 16 à 80 dents pourrait utiliser `gear_ratio : 5:1, 80:16`.

Dans la plupart des cas, le paramètre gear_ratio doit être défini avec des nombres entiers, car les engrenages et les poulies les plus courants ont un nombre entier de dents. Cependant, dans les cas où une courroie entraîne une poulie en utilisant la friction au lieu des dents, il peut être utile d'utiliser un nombre à virgule flottante dans le rapport de vitesse (par exemple, `gear_ratio : 107.237:16`).
