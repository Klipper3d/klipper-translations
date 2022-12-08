# Pressure Advance

Ce document fournit des informations sur les réglages de la variable "pressure advance" pour une buse et un filament donné. La fonctionnalité pressure advance peut aider à réduire le suintement. Pour plus d'informations sur l'implémentation du pressure advance, vous pouvez lire le document [kinematics](Kinematics.md).

## Réglage du pressure advance

Pressure advance permet deux choses importantes - réduire le suintement pendant les déplacements sans extrusion et réduire les bavures dans les coins. Ce guide utilise la réduction des bavures dans les angles comme base de réglage.

Pour régler le pressure advance, l'imprimante doit être configurée et en état de marche le test nécessitant une impression et une inspection de l'objet imprimé. Il est conseillé de lire ce document en intégralité avant de lancer les tests.

Utilisez un trancheur pour générer le g-code du grand carré creux disponible dans [docs/prints/square_tower.stl](prints/square_tower.stl). Utilisez un vitesse rapide (ex 100mm/s), pas de remplissage et une hauteur de couche grossière (la hauteur de couche devrait être dans les 75% du diamètre de la buse). Pensez à désactiver toutes les contrôle d'"accélération dynamique" dans le trancheur.

Préparez le test en exécutant la commande G-Code suivante :

```
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
```

Cette commande ralentit le déplacement de la buse dans les angles pour maximiser les effets de la pression de l'extrudeur. Pour les imprimantes munies de direct drive exécutez cette commande :

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

Pour les longs extrudeurs bowden , utilisez :

```
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020
```

Puis imprimez la pièce. Une fois l'impression terminée, l'objet ressemble à :

![tour de réglage](img/tuning_tower.jpg)

La commande TUNING_TOWER ci-dessus demande à Klipper de modifier le paramètre pressure_advance après chaque couche de l'impression. Les couches supérieures de l'impression auront une valeur de pressure_advance plus élevée. Les couches en dessous du réglage de pressure_advance optimal auront des bavures dans les angles et celles au-dessus du réglage idéale pourront avoir des coins arrondis ou une mauvaise extrusion dans les angles.

Vous pouvez arrêter l'impression si vous observez que les angles ne s'impriment plus correctement. (cela permet d'éviter d'imprimer les couches qui sont au-dessus de la valeur idéale pour le pressure_advance).

Inspectez l'impression et utilisez un pied à coulisse digital pour trouver la hauteur à laquelle les angles sont de bonne qualité. En cas de doute, choisissez une hauteur inférieure.

![réglage pa](img/tune_pa.jpg)

La valeur du pressure_advance peut être calculée de la manière suivante `pressure_advance = <début> + <hauteur_mesurée> * <facteur>`. (Par exemple, `0 + 12.90 *0 .020` donnera `0.258`.)

Il est possible de choisir des valeurs personnalisées pour START et FACTOR si cela permet d'identifier le meilleur réglage de pressure advance. Si vous utilisez des valeurs personnalisées, assurez-vous d'envoyer la commande TUNING_TOWER au début de chaque impression.

Les valeurs d’avance de pression moyennes se situent entre 0,050 et 1,000 (le haut de la fourchette est généralement pour les extrudeurs Bowden). S’il n’y a pas d’amélioration significative avec une avance de pression jusqu’à 1.000, il est peu probable que l’avance de pression améliore la qualité des impressions. Revenez à une configuration par défaut avec l’avance de pression désactivée.

Bien que cet exercice de réglage améliore directement la qualité des coins, il convient de rappeler qu’une bonne configuration d’avance de pression réduit également le suintement tout au long de l’impression.

À la fin de ce test, définissez `pressure_advance = <calculated_value> dans la section `[extruder]` du fichier de configuration et exécutez une commande RESTART. La commande RESTART effacera l’état de test et rétablira les paramètres de vitesse à leur valeurs normales.

## Informations importantes

* La valeur d’avance de pression dépend de l’extrudeur, de la buse et du filament. Il est courant que les filaments de différents fabricants ou avec différents pigments nécessitent des valeurs d’avance de pression significativement différentes. Par conséquent, il faut calibrer l’avance de pression sur chaque imprimante et avec chaque bobine de filament.
* La température d’impression et les taux d’extrusion peuvent avoir un impact sur l’avancement de la pression. Assurez-vous de régler la [rotation_distance de l'extrudeur](Rotation_Distance.md#calibrating-rotation_distance-on-extrudeuses) et [température de la buse](http://reprap.org/wiki/Triffid_Hunter%27s_Calibration_Guide#Nozzle_Temperature) avant de régler l'avance de pression.
* L’impression de test est conçue pour fonctionner avec un débit d’extrudeur élevé, mais avec des réglages de trancheur « normaux ». Un débit élevé est obtenu en utilisant une vitesse d’impression élevée (par exemple, 100 mm/s) et une hauteur de couche grossière (généralement 75% du diamètre de la buse). Les autres paramètres du segment doivent être similaires à leurs valeurs par défaut (par exemple, périmètres de 2 ou 3 lignes, distance de rétraction normale). Il peut être utile de définir la vitesse du périmètre externe pour qu’elle soit la même que le reste de l’impression, mais ce n’est pas une exigence.
* Il est fréquent que l’impression de test montre un comportement différent à chaque coin. Souvent, le trancheur s’arrange pour changer les couches dans un coin, ce qui peut entraîner une différence significative entre ce coin et les trois coins restants. Si cela se produit, ignorez ce coin et réglez l’avance de pression en utilisant les trois autres coins. Il est également courant que les coins restants varient légèrement. (Cela peut se produire en raison de petites différences dans la façon dont le cadre de l’imprimante réagit aux virages dans certaines directions.) Essayez de choisir une valeur qui fonctionne bien pour tous les coins restants. En cas de doute, préférez une valeur d’avance de pression inférieure.
* Si une valeur d'avance de pression élevée (par exemple supérieure à 0,200) est utilisée, il est possible que l'extrudeur saute lors du retour à l'accélération normale de l'imprimante. Le système d'avance de pression tient compte de la pression en poussant un peu plus de filament pendant l'accélération et en rétractant ce filament pendant la décélération. Avec une accélération élevée et une avance à haute pression, l'extrudeur peut ne pas avoir assez de couple pour pousser la quantité de filament requise. Si cela se produit, utilisez une valeur d'accélération inférieure ou désactivez l'avance de pression.
* Une fois que l'avance de pression est réglée dans Klipper, il peut toujours être utile de configurer une petite valeur de rétraction dans le trancheur (par exemple, 0,75 mm) et d'utiliser l'option "essuyer lors de la rétraction" du trancheur si elle est disponible. Ces réglages du trancheur peuvent aider à contrecarrer le suintement causé par la cohésion du filament (filament retiré de la buse en raison de l'adhérence du plastique). Il est recommandé de désactiver l'option "relever le Z lors de la rétraction" du trancheur.
* Le système d'avance de pression ne modifie pas la synchronisation ou la trajectoire de la tête. Une impression avec l'avance de pression activée prendra le même temps qu'une impression sans avance de pression. L'avance de pression ne modifie pas non plus la quantité totale de filament extrudé lors d'une impression. L'avance de pression entraîne un mouvement supplémentaire de l'extrudeur pendant l'accélération et la décélération du mouvement. Un réglage d'avance de pression très élevé entraînera une très grande quantité de mouvement de l'extrudeur pendant l'accélération et la décélération, et aucun réglage de configuration ne limite la quantité de ce mouvement.
