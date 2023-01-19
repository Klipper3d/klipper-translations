# Étalonnage Delta

Ce document décrit le système de calibration automatique de Klipper pour les imprimantes de type "delta".

L'étalonnage Delta consiste à trouver les positions pour les butées de tour, les angles de tour, le rayon Delta et les longueurs de bras Delta. Ces paramètres contrôlent le mouvement de l'imprimante sur une imprimante Delta. Chacun de ces paramètres a un impact non linéaire et il est difficile de les calibrer manuellement. En revanche, le code d'étalonnage logiciel peut fournir d'excellents résultats en quelques minutes seulement. Aucun matériel spécial n'est nécessaire.

L'étalonnage Delta dépend de la précision des interrupteurs de fin de course de chaque tour. Si l'on utilise des pilotes de moteur pas à pas Trinamic, envisagez d'activer la détection de [phase d'arrêt](Endstop_Phase.md) pour améliorer la précision de ces commutateurs.

## Sondage automatique vs manuel

Klipper prend en charge l'étalonnage des paramètres delta via une méthode de sondage manuelle ou via une sonde Z automatique.

Un certain nombre de kits d'imprimantes delta sont livrés avec des sondes Z automatiques qui ne sont pas suffisamment précises (en particulier, de petites différences de longueur de bras peuvent provoquer une inclinaison de l'effecteur qui peut fausser une sonde automatique). Si vous utilisez une sonde automatique, [étalonnez d'abord la sonde](Probe_Calibrate.md), puis recherchez un [le biais d'emplacement de la sonde](Probe_Calibrate.md#location-bias-check). Si la sonde automatique a un biais de plus de 25 microns (0,025 mm), utilisez plutôt une sonde manuelle. Le sondage manuel ne prend que quelques minutes et élimine les erreurs introduites par la sonde.

Si vous utilisez une sonde montée sur le côté de l'extrémité chaude (c'est-à-dire qu'elle a un décalage X ou Y), notez que l'exécution de l'étalonnage delta invalidera les résultats de l'étalonnage de la sonde. Ces types de sondes sont rarement adaptés à une utilisation sur une delta (car une inclinaison mineure de l'effecteur entraînera un biais de localisation de la sonde). Si vous utilisez quand même la sonde, assurez-vous de relancer l'étalonnage de la sonde après tout étalonnage delta.

## Étalonnage Delta de base

Klipper a une commande DELTA_CALIBRATE qui peut effectuer un étalonnage Delta de base. Cette commande sonde sept points différents sur le lit et calcule de nouvelles valeurs pour les angles de la tour, les butées de la tour et le rayon delta.

Afin d'effectuer cet étalonnage, les paramètres delta initiaux (longueurs de bras, rayon et positions de butée) doivent être fournis et ils doivent avoir une précision de quelques millimètres. La plupart des kits d'imprimante delta fournissent ces paramètres - configurez l'imprimante avec ces valeurs par défaut, puis exécutez la commande DELTA_CALIBRATE comme décrit ci-dessous. Si aucune valeur par défaut n'est disponible, recherchez en ligne un guide d'étalonnage delta qui peut fournir un point de départ de base.

Au cours du processus d'étalonnage Delta, il peut être nécessaire que l'imprimante sonde 'en dessous' de ce qui serait autrement considéré comme le plan du lit. Il est courant d'autoriser cela lors de l'étalonnage en mettant à jour la configuration de sorte que la position `minimum_z_position=-5` de l'imprimante. (Une fois l'étalonnage terminé, on peut supprimer ce paramètre de la configuration.)

Il existe deux façons d'effectuer le sondage : le sondage manuel (`DELTA_CALIBRATE METHOD=manual`) et le sondage automatique (`DELTA_CALIBRATE`). La méthode de sondage manuel déplacera la tête près du lit, puis attendra que l'utilisateur suive les étapes décrites dans ["the paper test"](Bed_Level.md#the-paper-test) pour déterminer la distance réelle entre la buse et lit à l'endroit indiqué.

Pour effectuer le sondage initial, assurez-vous que la configuration a une section [delta_calibrate] définie, puis exécutez l'outil :

```
G28
DELTA_CALIBRATE METHOD=manual
```

Après avoir sondé les sept points, de nouveaux paramètres Delta seront calculés. Enregistrez et appliquez ces paramètres en exécutant :

```
SAVE_CONFIG
```

L'étalonnage initial doit fournir des paramètres Delta suffisamment précis pour une impression. S'il s'agit d'une nouvelle imprimante, c'est le bon moment pour imprimer certains objets simples et vérifier son bon fonctionnement.

## Étalonnage Delta avancé

L'étalonnage Delta de base fait généralement un bon travail de calcul des paramètres delta de sorte que la buse soit à la bonne distance du lit. Cependant, il n'essaye pas de calibrer la précision dimensionnelle X et Y. L'étalonnage delta amélioré permet de vérifier la précision dimensionnelle.

Cette procédure d'étalonnage nécessite l'impression d'un objet de test et la mesure de parties de cet objet de test avec un pied à coulisse.

Avant d'exécuter un étalonnage delta avancé, il faut exécuter l'étalonnage delta de base (via la commande DELTA_CALIBRATE) et enregistrer les résultats (via la commande SAVE_CONFIG). Assurez-vous qu'il n'y a eu aucun changement notable dans la configuration de l'imprimante ni dans le matériel depuis le dernier étalonnage delta de base (en cas de doute, réexécutez l'[étalonnage delta de base](#basic-delta-calibration), y compris SAVE_CONFIG, juste avant l'impression l'objet de test décrit ci-dessous.)

Utilisez un trancheur pour générer le G-Code à partir du fichier [docs/prints/calibrate_size.stl](prints/calibrate_size.stl). Tranchez l'objet en utilisant une vitesse lente (par exemple, 40 mm/s). Si possible, utilisez un plastique rigide (comme le PLA) pour l'objet. L'objet a un diamètre de 140 mm. Si c'est trop grand pour l'imprimante, il est possible de le réduire (mais assurez-vous de mettre uniformément à l'échelle les axes X et Y). Si l'imprimante prend en charge des impressions beaucoup plus grandes, cet objet peut également être agrandi. Une taille plus grande peut améliorer la précision de la mesure, mais une bonne adhérence de l'impression est plus importante qu'une taille d'impression plus grande.

Imprimez l'objet à tester et attendez qu'il refroidisse complètement. Les commandes décrites ci-dessous doivent être exécutées avec les mêmes paramètres d'imprimante que ceux utilisés pour imprimer l'objet de calibrage (ne pas exécuter DELTA_CALIBRATE entre l'impression et la mesure, ou faire quelque chose d'autre qui changerait la configuration de l'imprimante).

Si possible, effectuez les mesures décrites ci-dessous pendant que l'objet est toujours attaché au lit d'impression, mais ne vous inquiétez pas si la pièce se détache du lit - essayez simplement d'éviter de tordre l'objet lors de l'exécution des mesures.

Commencez par mesurer la distance entre le pilier central et le pilier à côté de l'étiquette "A" (qui doit également pointer vers la tour "A").

![delta-a-distance](img/delta-a-distance.jpg)

Ensuite, allez dans le sens inverse des aiguilles d'une montre et mesurez les distances entre le pilier central et les autres piliers (distance du centre au pilier en face de l'étiquette C, distance du centre au pilier avec l'étiquette B, etc.).

![delta_cal_e_step1](img/delta_cal_e_step1.png)

Entrez ces paramètres dans Klipper avec une liste de nombres réels (/!\ utilisez le point comme séparateur décimal) séparés par des virgules :

```
DELTA_ANALYZE CENTER_DISTS=<a_dist>,<far_c_dist>,<b_dist>,<far_a_dist>,<c_dist>,<far_b_dist>
```

Fournissez les valeurs sans espaces entre chaque valeurs.

Mesurez ensuite la distance entre le pilier A et le pilier en face de l'étiquette C.

![delta-ab-distance](img/delta-outer-distance.jpg)

Ensuite, dans le sens antihoraire, mesurez la distance entre le pilier en face de C et le pilier B, la distance entre le pilier B et le pilier en face de A, et ainsi de suite.

![delta_cal_e_step2](img/delta_cal_e_step2.png)

Saisissez ces paramètres dans Klipper :

```
DELTA_ANALYZE OUTER_DISTS=<a_to_far_c>,<far_c_to_b>,<b_to_far_a>,<far_a_to_c>,<c_to_far_b>,<far_b_to_a>
```

À ce stade, vous pouvez retirer l'objet du lit. Les mesures finales concernent les piliers eux-mêmes. Mesurez la taille du pilier central le long du rayon A, puis du rayon B, puis du rayon C.

![delta-a-pillar](img/delta-a-pillar.jpg)

![delta_cal_e_step3](img/delta_cal_e_step3.png)

Saisissez-les dans Klipper :

```
DELTA_ANALYZE CENTER_PILLAR_WIDTHS=<a>,<b>,<c>
```

Les mesures finales concernent les piliers extérieurs. Commencez par mesurer la distance du pilier A le long de la ligne allant de A au pilier en face de C.

![delta-ab-pillar](img/delta-outer-pillar.jpg)

Ensuite, dans le sens antihoraire, mesurez les piliers extérieurs restants (pilier en face de C le long de la ligne vers B, pilier B le long de la ligne vers le pilier en face de A, etc.).

![delta_cal_e_step4](img/delta_cal_e_step4.png)

Et entrez-les dans Klipper :

```
DELTA_ANALYZE OUTER_PILLAR_WIDTHS=<a>,<far_c>,<b>,<far_a>,<c>,<far_b>
```

Si l'objet a été mis à l'échelle à une taille plus petite ou plus grande, indiquez le facteur d'échelle utilisé lors du découpage de l'objet :

```
DELTA_ANALYZE SCALE=1.0
```

(Une valeur d'échelle de 2,0 signifierait que l'objet est deux fois sa taille d'origine, 0,5 serait la moitié de sa taille d'origine.)

Enfin, effectuez l'étalonnage delta amélioré en exécutant :

```
DELTA_ANALYZE CALIBRATE=extended
```

Cette commande peut prendre plusieurs minutes. Une fois terminé, elle calculera les paramètres delta mis à jour (rayon delta, angles de tour, positions de butée et longueurs de bras). Utilisez la commande SAVE_CONFIG pour enregistrer et appliquer les paramètres :

```
SAVE_CONFIG
```

La commande SAVE_CONFIG enregistre à la fois les paramètres delta mis à jour et les informations des mesures de distance. Les futures commandes DELTA_CALIBRATE utiliseront également ces informations de distance. N'essayez pas de ressaisir les mesures de distance brutes après avoir exécuté SAVE_CONFIG, car cette commande modifie la configuration de l'imprimante et les mesures brutes ne s'appliquent plus.

### Notes complémentaires

* Si l'imprimante Delta a une bonne précision dimensionnelle, la distance entre deux piliers doit être d'environ 74 mm et la largeur de chaque pilier doit être d'environ 9 mm. (Plus précisément, l'objectif est que la distance entre deux piliers moins la largeur de l'un des piliers soit exactement de 65 mm.) S'il y a une inexactitude dimensionnelle dans la pièce, la routine DELTA_ANALYZE calculera de nouveaux paramètres delta en utilisant à la fois les mesures de distance et les mesures de hauteur précédentes de la dernière commande DELTA_CALIBRATE.
* DELTA_ANALYZE peut génerer des paramètres delta surprenants. Par exemple, il peut suggérer des longueurs de bras qui ne correspondent pas aux longueurs de bras réelles de l'imprimante. Malgré cela, les tests ont montré que DELTA_ANALYZE produit souvent de bons résultats. Les paramètres delta calculés sont capables de tenir compte de légères erreurs ailleurs dans le matériel. Par exemple, de petites différences de longueur de bras peuvent entraîner une inclinaison de l'effecteur et une partie de cette inclinaison peut être prise en compte en ajustant les paramètres de longueur de bras.

## Utilisation d'un maillage du lit sur une Delta

Il est possible d'utiliser le [maillage du lit](Bed_Mesh.md) sur une Delta. Cependant, il est important d'obtenir un bon étalonnage Delta avant d'activer un maillage du lit. L'exécution d'un maillage du lit avec un mauvais calibrage delta entraînera des résultats médiocres.

Notez que l'exécution de l'étalonnage delta invalidera tout maillage de lit précédemment obtenu. Après avoir effectué un nouvel étalonnage delta, assurez-vous de relancer BED_MESH_CALIBRATE.
