# Nivellement du lit

Le nivellement du lit (parfois aussi appelé « tramage du lit ») est essentiel pour obtenir des impressions de haute qualité. Si un lit n'est pas correctement "nivelé", cela peut entraîner une mauvaise adhérence du lit, un "gauchissement" et des problèmes subtils tout au long de l'impression. Ce document sert de guide pour effectuer le nivellement du lit dans Klipper.

Il est important de comprendre l'objectif du nivellement du lit. Si l'imprimante doit aller à la position `X0 Y0 Z10` pendant une impression, alors l'objectif est que la buse de l'imprimante soit exactement à 10 mm du lit de l'imprimante. De plus, si l'imprimante doit ensuite aller à la position "X50 Z10", l'objectif est que la buse maintienne une distance exacte de 10 mm du lit pendant tout ce mouvement horizontal.

Afin d'obtenir des impressions de bonne qualité, l'imprimante doit être calibrée de sorte que les distances Z soient précises à environ 25 microns (0,025 mm). Il s'agit d'une petite distance - nettement inférieure à la largeur d'un cheveu humain. Cette échelle ne peut pas être mesurée "à l'œil". Des effets subtils (tels que la dilatation thermique) ont un impact sur les mesures à cette échelle. Le secret pour obtenir une grande précision est d'utiliser un processus reproductible et d'utiliser une méthode de mise à niveau qui tire parti de la haute précision du propre système de mouvement de l'imprimante.

## Choisissez le mécanisme d'étalonnage approprié

Différents types d'imprimantes utilisent différentes méthodes pour effectuer le nivellement du lit. A la fin toutes les méthodes dépendent du "test du papier" (décrit ci-dessous). Cependant, le processus pour un type particulier d'imprimante est décrit dans les autres documents.

Avant d'exécuter l'un de ces outils d'étalonnage, assurez-vous d'exécuter les vérifications décrites dans le [document de vérification de la configuration](Config_checks.md). Il est nécessaire de vérifier les mouvements de base de l'imprimante avant d'effectuer le nivellement du lit.

Pour les imprimantes avec une sonde Z automatique, assurez-vous de calibrer la sonde en suivant les instructions du document [Réglages de la sonde](Probe_Calibrate.md). Pour les imprimantes delta, consultez le document [Réglage des deltas](Delta_Calibrate.md). Pour les imprimantes avec un lit réglable par vis et des fin de course Z traditionnels, consultez le document [Nivellement manuel](Manual_Level.md).

Pendant le calibrage, il peut être nécessaire de définir la `position_min` du Z de l'imprimante sur un nombre négatif (par exemple, `position_min = -2`). L'imprimante effectue des vérifications des limites même pendant les routines d'étalonnage. La définition d'un nombre négatif permet à l'imprimante de se déplacer en dessous de la position nominale du lit, ce qui peut aider à déterminer la position réelle du lit.

## Le "Test du papier"

Le principal mécanisme d'étalonnage du lit est le "test du papier". Il s'agit de placer un morceau régulier de "papier pour photocopieuse" entre le lit et la buse de l'imprimante, puis de déplacer la buse à différentes hauteurs Z jusqu'à ce que l'on ressente une petite friction lorsque l'on pousse le papier d'avant en arrière.

Il est important de bien comprendre le "test papier" même si l'on dispose d'une "sonde Z automatique". La sonde elle-même doit souvent être calibrée pour obtenir de bons résultats. Cet étalonnage de la sonde est effectué à l'aide de ce "test papier".

Afin d'effectuer le test du papier, coupez un petit morceau de papier rectangulaire à l'aide d'une paire de ciseaux (par exemple, 5x3 cm). Le papier a généralement une épaisseur d'environ 100 microns (0,100 mm). (L'épaisseur exacte du papier n'est pas cruciale.)

La première étape du test du papier consiste à inspecter la buse et le lit de l'imprimante. Assurez-vous qu'il n'y a pas de plastique (ou d'autres débris) sur la buse ou le lit.

** Inspectez la buse et le lit pour vous assurer qu'il n'y a pas de plastique ! **

Si l'on imprime toujours sur une bande adhésive ou une surface d'impression particulière, on peut alors effectuer le test papier avec cette bande/surface en place. Cependant, notez que le ruban lui-même a une épaisseur et que différents rubans (ou toute autre surface d'impression) auront un impact sur les mesures Z. Assurez-vous de relancer le test du papier pour mesurer chaque type de surface utilisé.

S'il y a du plastique sur la buse, chauffez la buse et utilisez une pince à épiler en métal pour retirer ce plastique. Attendez que la buse refroidisse complètement à température ambiante avant de continuer avec le test papier. Pendant que la buse refroidit, utilisez la pince à épiler en métal pour retirer tout plastique susceptible de suinter.

** Effectuez toujours le test du papier lorsque la buse et le lit sont à température ambiante ! **

Lorsque la buse est chauffée, sa position (par rapport au lit) change en raison de la dilatation thermique. Cette dilatation thermique est généralement d'environ 100 microns, ce qui correspond à peu près à la même épaisseur qu'un morceau de papier d'imprimante typique. La quantité exacte de dilatation thermique n'est pas cruciale, tout comme l'épaisseur exacte du papier n'est pas cruciale. Commencez par l'hypothèse que les deux sont égaux (voir ci-dessous pour une méthode de détermination de la différence entre les deux distances).

Il peut sembler étonnant de calibrer la distance à température ambiante alors que l'objectif est d'avoir une distance constante lorsqu'il est chauffé. Cependant, si l'on calibre lorsque la buse est chauffée, elle a tendance à laisser couler de petites quantités de plastique fondu sur le papier, ce qui modifie la quantité de frottement ressenti. Cela complique l'obtention d'un bon calibrage. Le calibrage alors que le lit/la buse est chaud augmente également considérablement le risque de se brûler. La dilatation thermique est stable, elle est donc facilement prise en compte plus tard dans le processus d'étalonnage.

**Utilisez un outil automatique pour déterminer des hauteurs Z précises !**

Klipper a de nombreux scripts d'aide disponibles (par exemple, MANUAL_PROBE, Z_ENDSTOP_CALIBRATE, PROBE_CALIBRATE, DELTA_CALIBRATE). Lisez les documents [décrits ci-dessus](#choose-the-appropriate-calibration-mechanism) pour en choisir un.

Exécutez la commande choisie dans la fenêtre du terminal OctoPrint. Le script demandera une action de l'utilisateur dans la sortie du terminal OctoPrint. Cela ressemblera à quelque chose comme :

```
Recv: // Starting manual Z probe. Use TESTZ to adjust position.
Recv: // Finish with ACCEPT or ABORT command.
Recv: // Z position: ?????? --> 5.000 <-- ??????
```

La hauteur actuelle de la buse (telle que l'imprimante la calcule) est indiquée entre "--> <--". Le nombre à droite est la hauteur du dernier essai de sondage juste supérieure à la hauteur actuelle, et à gauche c'est la hauteur du dernier essai de sondage inférieur à la hauteur actuelle (ou ?????? si aucune tentative n'a été effectuée).

Placez le papier entre la buse et le lit. Il peut être utile de plier un coin du papier pour qu'il soit plus facile à saisir. (Essayez de ne pas appuyer sur le lit lorsque vous déplacez le papier d'avant en arrière.)

![test du papier](img/paper-test.jpg)

Utilisez la commande TESTZ pour demander à la buse de se rapprocher du papier. Par exemple :

```
TESTZ Z=-0.1
```

La commande TESTZ déplacera la buse à une distance relative de la position actuelle de la buse. (Ainsi, `Z = -0.1` demande à la buse de se rapprocher du lit de 0,1 mm.) Une fois que la buse a cessé de bouger, poussez le papier d'avant en arrière pour vérifier si la buse est en contact avec le papier et pour sentir la quantité de frottement. Continuez à émettre des commandes TESTZ jusqu'à ce que vous ressentiez une légère friction lors du test avec le papier.

Si il y a trop de frottement, on peut utiliser une valeur Z positive pour déplacer la buse vers le haut. Il est également possible d'utiliser `TESTZ Z=+` ou `TESTZ Z=-` pour "dichotomiser" la dernière position - c'est-à-dire se déplacer vers une position à mi-chemin entre deux positions. Par exemple, si l'on reçoit l'invite suivante d'une commande TESTZ :

```
Recv: // Z position: 0.130 --> 0.230 <-- 0.280
```

Ensuite, un 'TESTZ Z=-' déplacerait la buse vers une position Z de 0,180 (à mi-chemin entre 0,130 et 0,230). On peut utiliser cette fonctionnalité pour aider à réduire rapidement à un frottement constant. Il est également possible d'utiliser `Z=++` et `Z=--` pour revenir directement à une mesure passée - par exemple, après l'invite ci-dessus, une commande `TESTZ Z=--` déplacerait la buse vers un Z position de 0,130.

Après réglé la légère force de friction, exécutez la commande ACCEPT :

```
ACCEPT
```

Cela validera la hauteur Z donnée et enregistrera la valeur d'étalonnage.

La force de friction ressentie n'est pas cruciale, tout comme la quantité de dilatation thermique et la largeur exacte du papier ne sont pas cruciales. Essayez simplement d'obtenir la même quantité de frottement à chaque fois que vous exécutez le test.

Si quelque chose ne va pas pendant le test, on peut utiliser la commande `ABORT` pour quitter l'outil d'étalonnage.

## Détermination de la dilatation thermique

Après avoir effectué le nivellement du lit, on peut continuer à calculer une valeur plus précise pour compenser «l'expansion thermique», «l'épaisseur du papier» et la «quantité de frottement ressentie pendant le test du papier».

Ce type de calcul n'est généralement pas nécessaire car la plupart des utilisateurs trouvent que le simple "test papier" donne de bons résultats.

La façon la plus simple de faire ce calcul est d'imprimer un objet de test qui a des parois droites de tous les côtés. Le grand carré creux trouvé dans [docs/prints/square.stl](prints/square.stl) peut être utilisé pour cela. Lors du découpage de l'objet, assurez-vous que le segment utilise la même hauteur de couche et la même largeur d'extrusion pour le premier niveau et pour toutes les couches suivantes. Utilisez une hauteur de couche grossière (la hauteur de couche doit être d'environ 75 % du diamètre de la buse) et n'utilisez pas de bordure ou de radeau.

Imprimez l'objet à tester, attendez qu'il refroidisse et retirez-le du lit. Inspectez la couche la plus basse de l'objet. (Il peut également être utile de passer un doigt ou un ongle le long du bord inférieur.) Si l'on constate que la couche inférieure est légèrement bombée le long de tous les côtés de l'objet, cela indique que la buse était légèrement plus proche du lit qu'elle ne l'aurait dû. On peut émettre une commande `SET_GCODE_OFFSET Z=+.010` pour augmenter la hauteur. Dans les impressions suivantes, on peut inspecter ce comportement et effectuer d'autres ajustements si nécessaire. Les ajustements de ce type se font généralement en dizaines de microns (0,010 mm).

Si la couche inférieure apparaît systématiquement plus étroite que les couches suivantes, vous pouvez utiliser la commande SET_GCODE_OFFSET pour effectuer un ajustement Z négatif. En cas de doute, on peut diminuer le réglage Z jusqu'à ce que la couche inférieure des impressions présente un petit renflement, puis reculer jusqu'à ce qu'il disparaisse.

Le moyen le plus simple d'appliquer l'ajustement Z souhaité consiste à créer une macro de g-code START_PRINT et à faire en sorte que le slicer appelle cette macro au début de chaque impression et à ajouter une commande SET_GCODE_OFFSET à cette macro. Voir le document [trancheurs](Slicers.md) pour plus de détails.
