# Compensation de la résonance

Klipper prend en charge l'Input Shaping, une technique qui peut être utilisée pour réduire le ringing (également appelé écho, ghosting ou rippling (ondulation)) dans les impressions. Le "ringing" est un défaut d'impression de surface lorsque des éléments tels que des bords se répètent sur une surface imprimée sous la forme d'un "écho" subtil :

|![Test de résonance](img/ringing-test.jpg)|![3D Benchy](img/ringing-3dbenchy.jpg)|

La résonance est causée par des vibrations mécaniques dans l'imprimante dues à des changements rapides de direction pendant l'impression. La résonance a généralement des origines mécaniques : cadre de l'imprimante insuffisamment rigide, courroies non tendues ou trop élastiques, problèmes d'alignement des pièces mécaniques, masse mobile importante, etc. Ces problèmes doivent être vérifiés et corrigés en premier lieu, si possible.

L' [input shaping](https://en.wikipedia.org/wiki/Input_shaping) est une technique de contrôle en boucle ouverte qui crée un signal de commande annulant ses propres vibrations. L'input shaping nécessite quelques réglages et mesures avant de pouvoir être activée. Outre la résonance, l'input shaping réduit aussi les vibrations et les secousses de l'imprimante en général, et peut également améliorer la fiabilité du mode stealthChop des pilotes Trinamic.

## Réglages

Le réglage de base nécessite de mesurer les fréquences de résonance de l'imprimante en imprimant un modèle de test.

Tranchez le modèle de test de résonance, qui se trouve dans [docs/prints/ringing_tower.stl](prints/ringing_tower.stl), avec votre trancheur :

* La hauteur de couche recommandée est de 0,2 ou 0,25 mm.
* Le remplissage et le nombre de couches supérieures peuvent être réglés sur 0.
* Utilisez 1 ou 2 parois, ou mieux encore le mode vase avec une base de 1 ou 2 mm.
* Utilisez une vitesse suffisamment élevée, entre 80 et 100 mm/s, pour les parois **externes**.
* Veillez à ce que le temps minimum par couche soit **au maximum** de 3 secondes.
* Assurez-vous que toutes les options de "contrôle d'accélération" soient bien désactivées dans le trancheur.
* Ne tournez pas le modèle. Le modèle comporte des marques X et Y à l'arrière du modèle. L'emplacement inhabituel des marques par rapport aux axes de l'imprimante n'est pas une erreur. Ces marques pourront être utilisées plus tard - comme référence - dans le processus de réglage, car elles indiquent à quel axe correspondent les mesures.

### Fréquence de résonance

En premier lieu, mesurez la **fréquence de résonance**.

1. Si le paramètre `square_corner_velocity` a été modifié, remettez-le à 5.0. Il n'est pas conseillé de l'augmenter lors de l'utilisation de l'input shaper car cela peut provoquer plus de lissage dans les pièces - il est préférable d'utiliser une valeur d'accélération plus élevée à la place.
1. Disable the `minimum_cruise_ratio` feature by issuing the following command: `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. Désactivez l'avance de pression : `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Si vous avez déjà ajouté la section `[input_shaper]` au fichier printer.cfg, exécutez la commande `SET_INPUT_SHAPER SHAPER_FREQ_X=0 SHAPER_FREQ_Y=0`. Si vous obtenez l'erreur "Unknown command", vous pouvez l'ignorer - pour le moment - et continuer les mesures.
1. Exécutez la commande : `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5` Dans la pratique, nous essayons de rendre la résonance plus prononcée en définissant différentes valeurs élevées pour l'accélération. Cette commande augmentera l'accélération tous les 5 mm à partir de 1500 mm/sec² : 1500 mm/sec², 2000 mm/sec², 2500 mm/sec² et ainsi de suite jusqu'à 7000 mm/sec² pour la dernière bande.
1. Imprimez le modèle de test tranché avec les paramètres indiqués.
1. Vous pouvez arrêter l'impression avant la fin si la résonance est clairement visible et si vous constatez que l'accélération devient trop forte pour votre imprimante (par exemple, l'imprimante tremble trop ou commence à sauter des pas).
1. Utilisez les marques X et Y à l'arrière du modèle comme référence. Les mesures du côté avec la marque X doivent être utilisées pour la *configuration* de l'axe X, et les mesures du côté avec la marque Y pour la configuration de l'axe Y. Mesurez la distance *D* (en mm) entre plusieurs oscillations sur la partie de la pièce avec la marque X, près des encoches et en sautant de préférence la ou les deux premières oscillations. Pour mesurer plus facilement la distance entre les oscillations, marquez d'abord les oscillations, puis mesurez la distance entre les marques avec une règle ou un pied à coulisse :

   |![Marques de résonances](img/ringing-mark.jpg)|![Mesure de la résonance](img/ringing-measure.jpg)|
1. Comptez le nombre d'oscillations *N* correspondant à la distance mesurée *D*. Si vous ne savez pas comment compter les oscillations, reportez-vous à l'image ci-dessus, qui montre *N* = 6 oscillations.
1. Calculez la fréquence de résonance de l'axe X : *V* &middot; *N* / *D* (Hz), où *V* est la vitesse des périmètres extérieurs (mm/s). Pour l'exemple ci-dessus, nous avons marqué 6 oscillations (N) sur une distance de 12,14 mm (D), et le test a été imprimé à une vitesse de 100 mm/s (V), donc la fréquence est 100 * 6 / 12,14 ≈ 49,4 Hz.
1. Faites (8) - (10) pour la marque Y également.

Notez que la résonance sur l'impression de test devrait suivre les encoches courbées de la pièce, comme dans l'image ci-dessus. Si ce n'est pas le cas, alors ce défaut n'est pas vraiment une résonance et a probablement une origine différente - soit mécanique, soit un problème d'extrudeuse. Ce problème doit être résolu avant d'activer et de régler les input shapers.

Si les mesures ne sont pas fiables parce que, par exemple, la distance entre les oscillations n'est pas régulière, cela peut signifier que l'imprimante a plusieurs fréquences de résonance sur le même axe. On peut essayer de suivre le processus de réglage décrit dans la section [Mesures peu fiables des fréquences de résonance](#unreliable-measurements-of-ringing-frequencies) à la place et obtenir quand même une amélioration grâce à l'input shaping.

La fréquence de résonance peut dépendre de la position du modèle sur le plateau et de la hauteur Z, *surtout sur les imprimantes delta* ; vous pouvez vérifier si vous observez des différences de fréquences à différentes positions le long des côtés du modèle de test et à différentes hauteurs. Si c'est le cas, vous pouvez calculer les fréquences de résonance moyennes sur les axes X et Y.

Si la fréquence de résonance mesurée est très basse (inférieure à 20-25 Hz), il peut être judicieux de penser à rigidifier la structure de l'imprimante ou à réduire la masse mobile - dans la mesure du possible - avant de poursuivre le réglage de l'input shaping et de mesurer à nouveau les fréquences. Pour de nombreux modèles d'imprimantes populaires, il existe souvent des solutions déjà disponibles.

Les fréquences de résonance peuvent changer si des modifications sont apportées à l'imprimante qui affectent la masse en mouvement ou modifient la rigidité du système, par exemple :

* Si la tête d'impression est modifiée, par ex. changement de moteur pas à pas (plus lourd ou plus léger) pour une extrusion directe, remplacement de la tête de l'outil (plus ou moins lourde), ajout d'un ventilateur plus lourd, etc.
* La tension des courroies a été modifiée.
* Des pièces conçues pour augmenter la rigidité du cadre sont installées.
* Un plateau différent est installé sur une imprimante à lit mobile, ou une plaque de verre est ajoutée, etc.

Si de telles modifications sont apportées, Il est conseillé - au minimum - de mesurer les fréquences de résonance pour vérifier s'il elles ont changées (ou pas).

### Configuration de l'input shaper

Une fois les fréquences de résonance des axes X et Y mesurées, vous pouvez ajouter la section suivante à votre fichier `printer.cfg` :

```
[input_shaper]
shaper_freq_x: ...    # frequence pour la marque X sur le modèle de test
shaper_freq_y: ...    # frequence pour la marque Y sur le modèle de test
```

Pour l'exemple ci-dessus, nous obtenons shaper_freq_x/y = 49,4.

### Choix de l'input shaper

Klipper prend en charge plusieurs type d'"input shaper". Ils diffèrent par leur sensibilité aux erreurs déterminant la fréquence de résonance et le degré de lissage qu'ils provoquent dans les pièces imprimées. De plus, certains de ces "input shaper" comme 2HUMP_EI et 3HUMP_EI ne doivent généralement pas être utilisés avec shaper_freq = fréquence de résonance - ils sont configurés à partir de différentes considérations pour réduire plusieurs résonances à la fois (ndt : le 2HUMP_EI est à utiliser lorsque deux pics de résonance sont détectés, le 3HUMP_EI est à utiliser lorsque trois pics de résonance sont détectés).

Pour la plupart des imprimantes, les types MZV ou EI sont recommandés. Cette section décrit un processus de test pour choisir entre eux et déterminer quelques autres paramètres connexes.

Imprimez le modèle de test de résonance comme suit :

1. Redémarrez le micrologiciel : `RESTART`
1. Prepare for test: `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. Désactivez l'avance de pression : `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Exécutez : `SET_INPUT_SHAPER SHAPER_TYPE=MZV`
1. Exécutez la commande : `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`
1. Imprimez le modèle de test tranché avec les paramètres indiqués.

Si vous ne voyez pas de résonance à ce stade, l'utilisation du type MZV peut être recommandée.

Si vous voyez une résonance, mesurez à nouveau les fréquences en suivant les étapes (8) à (10) décrites dans la section [Fréquence de résonance](#ringing-frequency). Si les fréquences diffèrent considérablement des valeurs obtenues précédemment, une configuration d'input shaper plus complexe est nécessaire. Vous pouvez vous référer aux détails techniques de la section [Input shapers](#input-shapers). Sinon, passez à l'étape suivante.

Essayez l'input shaper EI. Pour l'essayer, répétez les étapes (1) à (6) ci-dessus, mais en exécutant à l'étape 4 la commande suivante à la place : `SET_INPUT_SHAPER SHAPER_TYPE=EI`.

Comparez deux impressions avec les types MZV et EI. Si EI montre des résultats sensiblement meilleurs que MZV, utilisez EI, sinon préférez MZV. Notez que le type EI provoquera plus de lissage dans les pièces imprimées (voir la section suivante pour plus de détails). Ajoutez le paramètre `shaper_type: mzv` (ou ei) à la section [input_shaper], par exemple :

```
[input_shaper]
shaper_freq_x: ...
shaper_freq_y: ...
shaper_type: mzv
```

Quelques notes sur le choix de l'input shaper :

* Le type EI peut être plus adapté aux imprimantes à lit mobile (si la fréquence de résonance et le lissage résultant le permettent) : plus le filament est déposé sur le lit en mouvement, plus la masse du lit augmente et la fréquence de résonance diminue. Étant donné que le type EI est plus robuste aux changements de fréquence de résonance, il peut être plus efficace lors de l'impression de grandes pièces.
* En raison de la nature de la cinématique delta, les fréquences de résonance peuvent différer considérablement dans différentes parties du volume de construction. Par conséquent, le type EI peut être mieux adapté aux imprimantes delta plutôt que MZV ou ZV. Si la fréquence de résonance est suffisamment grande (plus de 50-60 Hz), alors on peut même essayer de tester 2HUMP_EI (en exécutant le test suggéré ci-dessus avec `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI`), mais vérifiez les considérations dans la [section ci-dessous](#selecting-max_accel) avant de l'activer.

### Sélection de max_accel

Vous devriez obtenir le test imprimé avec l'input shaper choisi à l'étape précédente (si vous ne le faites pas, imprimez le modèle de test découpé avec les [paramètres suggérés](#tuning) avec l'avance de pression désactivée `SET_PRESSURE_ADVANCE ADVANCE=0` et avec la tour de réglage activée comme `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`). Notez qu'à des accélérations très élevées, selon la fréquence de résonance et l'input shaper choisi (par exemple, le shaper EI crée plus de lissage que MZV), cela peut provoquer trop de lissage et d'arrondi des pièces. Ainsi, max_accel doit être choisi de manière à l'éviter. Un autre paramètre ayant un impact sur le lissage est `square_corner_velocity`, il n'est donc pas conseillé de l'augmenter au-dessus de la valeur par défaut de 5 mm/s pour éviter un lissage accru.

Afin de sélectionner une valeur correcte pour max_accel, inspectez le modèle imprimé pour l'input shaper choisi. Tout d'abord, notez à quelle accélération la résonance reste imperceptible.

Ensuite, vérifiez le lissage. Pour vous aider, le modèle de test a un petit espace dans la paroi (0,15 mm) :

![Ecart de test](img/smoothing-test.png)

À mesure que l'accélération augmente, le lissage augmente également et l'espacement réel dans l'impression s'élargit :

![Lissage de l'input shaper](img/shaper-smoothing.jpg)

Sur cette image, l'accélération augmente de gauche à droite, et l'écart commence à croître à partir de 3500 mm/s² (5ème bande à partir de la gauche). Dans ce cas, la valeur pour max_accel = 3000 (mm/s²) permet d'éviter un lissage excessif.

Notez l'accélération lorsque l'écart est encore très faible dans votre test d'impression. Si vous voyez des renflements, mais aucun espace dans le mur, même à des accélérations élevées, cela peut être dû à une avance de pression (PA) désactivée, en particulier sur les extrudeurs de type Bowden. Si tel est le cas, vous devrez peut-être relancer l'impression avec le PA activé. Cela peut également être le résultat d'un extrudeur mal calibré (trop élevé), il faut donc vérifier cela aussi.

Choisissez la valeur minimale des deux valeurs d'accélération (de la résonance et du lissage) et affectez-là à `max_accel` dans printer.cfg.

Notez qu'il peut arriver - en particulier à des fréquences de résonance basses - que l'input shaper EI provoque trop de lissage, même à des accélérations faibles. Dans ce cas, MZV peut être un meilleur choix, car il peut permettre des valeurs d'accélération plus élevées.

À des fréquences de résonance très basses (~ 25 Hz et moins), même l'input shaper MZV peut créer trop de lissage. Si tel est le cas, vous pouvez également essayer de répéter les étapes de la section [Choix de l'input shaper](#choosing-input-shaper) avec l'input shaper ZV, en utilisant la commande `SET_INPUT_SHAPER SHAPER_TYPE=ZV` à la place. L'input shaper ZV devrait montrer encore moins de lissage que MZV, mais il est plus sensible aux erreurs de mesure des fréquences de résonance.

Si une fréquence de résonance est trop faible (inférieure à 20-25 Hz), il peut être judicieux d'augmenter la rigidité de l'imprimante ou de réduire la masse en mouvement. Sinon, l'accélération et la vitesse d'impression peuvent être limitées en raison d'un lissage trop important qui remplacera la résonance.

### Réglage fin des fréquences de résonance

Notez que la précision des mesures des fréquences de résonance à l'aide du modèle de test de résonance est suffisante dans la plupart des cas, donc un réglage supplémentaire n'est pas utile. Si vous voulez toujours essayer de revérifier vos résultats (par exemple, si vous voyez toujours une résonance après avoir imprimé un modèle de test avec un input shaper de votre choix avec les fréquences mesurées précédemment), vous pouvez suivre les étapes de cette section. Notez que si vous voyez une résonance à différentes fréquences après avoir activé [input_shaper], cette section ne vous aidera pas.

En considérant que vous avez tranché le modèle de résonance avec les paramètres suggérés, effectuez les étapes suivantes pour chacun des axes X et Y :

1. Prepare for test: `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. Assurez-vous que l'avance de pression est désactivée : `SET_PRESSURE_ADVANCE ADVANCE=0`
1. Exécutez : `SET_INPUT_SHAPER SHAPER_TYPE=ZV`
1. À partir du modèle de test de résonance imprimé avec l'input shaper choisi, sélectionnez l'accélération montrant suffisamment bien la résonance et définissez-la avec : `SET_VELOCITY_LIMIT ACCEL=...`
1. Calculez les paramètres nécessaires pour que la commande `TUNING_TOWER` règle le paramètre `shaper_freq_x` comme suit : start = shaper_freq_x * 83 / 132 et factor = shaper_freq_x / 66, où `shaper_freq_x` est la valeur indiquée dans `printer.cfg`.
1. Exécutez la commande : `TUNING_TOWER COMMAND=SET_INPUT_SHAPER PARAMETER=SHAPER_FREQ_X START=start FACTOR=factor BAND=5` en utilisant les valeurs `start` et `factor` calculées à l'étape (5).
1. Imprimez le modèle de test.
1. Remettez la valeur de fréquence d'origine : `SET_INPUT_SHAPER SHAPER_FREQ_X=...`.
1. Trouvez la bande résonnant le moins et comptez son numéro à partir du bas en commençant à 1.
1. Calculez la nouvelle valeur shaper_freq_x selon la formule : ancien shaper_freq_x * (39 + 5 * #band-number) / 66.

Répétez ces étapes pour l'axe Y de la même manière, en remplaçant les références à l'axe X par l'axe Y (par exemple, remplacez `shaper_freq_x` par `shaper_freq_y` dans les formules et dans la commande `TUNING_TOWER`).

A titre d'exemple, supposons que vous ayez mesuré la fréquence de résonance pour l'un des axes à 45 Hz. Cela donne les valeurs start = 45 * 83 / 132 = 28,30 et factor = 45 / 66 = 0,6818 pour la commande `TUNING_TOWER`. Supposons maintenant qu'après l'impression du modèle de test, la quatrième bande à partir du bas donne le moins de résonance. Cela donne le shaper_freq_ mis à jour égal à 45 * (39 + 5 * 4) / 66 ≈ 40,23.

Une fois les deux nouveaux paramètres `shaper_freq_x` et `shaper_freq_y` calculés, vous pouvez mettre à jour la section `[input_shaper]` dans `printer.cfg` avec le nouveau `shaper_freq_x` et `shaper_freq_y`.

### Avance de pression (PA)

Si vous utilisiez l'avance de pression, il pourra être nécessaire de la réajuster. Suivez les [instructions](Pressure_Advance.md#tuning-pressure-advance) pour trouver la nouvelle valeur, si elle diffère de la précédente. Assurez-vous de redémarrer Klipper avant de régler l'avance de pression.

### Mesures peu fiables des fréquences de résonance

Si vous ne parvenez pas à mesurer les fréquences de résonance, par ex. si la distance entre les oscillations n'est pas stable, vous pouvez toujours profiter des techniques de l'input shaper, mais les résultats peuvent ne pas être aussi bons qu'avec des mesures appropriées des fréquences, et nécessiteront un peu plus de réglages et d'impressions du modèle de test. Notez qu'une autre possibilité est d'acheter et d'installer un accéléromètre et de mesurer les résonances avec (reportez-vous à la [documentation](Measuring_Resonances.md) décrivant le matériel requis et le processus de configuration) - mais cette option nécessite quelques soudures et un peu de sertissage.

Pour le réglage, ajoutez une section `[input_shaper]` vide à votre `printer.cfg`. Ensuite, en supposant que vous avez tranché le modèle de résonance avec les paramètres suggérés, imprimez le modèle de test 3 fois comme suit. Première fois, avant l'impression, exécutez

1. `RESTART`
1. `SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0`
1. `SET_PRESSURE_ADVANCE ADVANCE=0`
1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=60 SHAPER_FREQ_Y=60`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

et imprimez le modèle. Ensuite, imprimez à nouveau le modèle, mais avant d'imprimer, exécutez à la place

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=50 SHAPER_FREQ_Y=50`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

Imprimez ensuite le modèle pour la 3ème fois, mais exécutez maintenant

1. `SET_INPUT_SHAPER SHAPER_TYPE=2HUMP_EI SHAPER_FREQ_X=40 SHAPER_FREQ_Y=40`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

Dans la pratique nous imprimons le modèle de test de résonance avec TUNING_TOWER en utilisant l'input shaper 2HUMP_EI avec shaper_freq = 60 Hz, 50 Hz et 40 Hz.

Si aucun des modèles ne démontre d'amélioration de la résonance, aucune des techniques d'input shaper ne pourra vous aider.

Sinon, il se peut que tous les modèles n'affichent aucune résonance, ou que certains affichent la résonance et d'autres pas trop. Choisissez le modèle de test avec la fréquence la plus élevée qui montre encore de bonnes améliorations dans la résonance. Par exemple, si les modèles 40 Hz et 50 Hz n'affichent presque aucune résonance et que le modèle 60 Hz affiche déjà un peu plus de résonance, restez à 50 Hz.

Vérifiez maintenant si l'input shaper EI peut fonctionner dans votre cas. Choisissez la fréquence de l'input shaper EI en fonction de la fréquence de l'input shaper 2HUMP_EI que vous avez choisie :

* Pour l'input shaper 2HUMP_EI 60 Hz, utilisez l'input shaper EI avec shaper_freq = 50 Hz.
* Pour l'input shaper 2HUMP_EI 50 Hz, utilisez l'input shaper EI avec shaper_freq = 40 Hz.
* Pour l'input shaper 2HUMP_EI à 40 Hz, utilisez l'input shaper EI avec shaper_freq = 33 Hz.

Imprimez le modèle de test une fois de plus, en exécutant

1. `SET_INPUT_SHAPER SHAPER_TYPE=EI SHAPER_FREQ_X=... SHAPER_FREQ_Y=...`
1. `TUNING_TOWER COMMAND=SET_VELOCITY_LIMIT PARAMETER=ACCEL START=1500 STEP_DELTA=500 STEP_HEIGHT=5`

en fournissant le shaper_freq_x=... et shaper_freq_y=... comme déterminé précédemment.

Si l'input shaper EI montre de bons résultats comparables à ceux de l'input shaper 2HUMP_EI, restez avec l'input shaper EI et la fréquence déterminée précédemment, sinon utilisez l'input shaper 2HUMP_EI avec la fréquence correspondante. Ajoutez les résultats à `printer.cfg` comme, par ex.

```
[input_shaper]
shaper_freq_x: 50
shaper_freq_y: 50
shaper_type: 2hump_ei
```

Continuez le réglage avec la section [Choix de l'accélération maximale](#selecting-max_accel).

## Dépannage et FAQ

### Je n'arrive pas à obtenir de mesures fiables des fréquences de résonance

En premier lieu, assurez-vous qu'il ne s'agit pas d'un autre problème avec l'imprimante plutôt que de la résonance. Si les mesures ne sont pas fiables parce que, par exemple, la distance entre les oscillations n'est pas stable, cela peut signifier que l'imprimante a plusieurs fréquences de résonance sur le même axe. On peut essayer de suivre le processus de réglage décrit dans la section [Mesures non fiables des fréquences de résonance](#unreliable-measurements-of-ringing-frequencies) et tirer encore quelque chose de la technique de l'input shaper. Une autre possibilité consiste à installer un accéléromètre, à [mesurer](Measuring_Resonances.md) les résonances avec celui-ci et à régler automatiquement l'input shaper en utilisant les résultats de ces mesures.

### Après avoir activé [input_shaper], j'obtiens des pièces imprimées trop lissées et les détails fins sont perdus

Vérifiez les informations dans la section [Choix de l'accélération maximale](#selecting-max_accel). Si la fréquence de résonance est faible, il ne faut pas définir une valeur trop élevée pour max_accel ou augmenter les paramètres square_corner_velocity. Il peut également être préférable de choisir un input shaper de type MZV ou même ZV plutôt que EI (ou des shapers 2HUMP_EI et 3HUMP_EI).

### Après avoir réussi à imprimer pendant un certain temps sans résonance, elle semble revenir

Il est possible qu'après un certain temps, les fréquences de résonance aient changé. Par exemple. peut-être que la tension des courroies a changé (les courroies sont devenues plus lâches), etc. Il est bon de vérifier et de mesurer à nouveau les fréquences de résonance comme décrit dans la section [Fréquence de résonance](#ringing-frequency) et de mettre à jour votre fichier de configuration si nécessaire .

### La configuration à double chariot est-elle prise en charge avec l'input shaper ?

Yes. In this case, one should measure the resonances twice for each carriage. For example, if the second (dual) carriage is installed on X axis, it is possible to set different input shapers for X axis for the primary and dual carriages. However, the input shaper for Y axis should be the same for both carriages (as ultimately this axis is driven by one or more stepper motors each commanded to perform exactly the same steps). One possibility to configure the input shaper for such setups is to keep `[input_shaper]` section empty and additionally define a `[delayed_gcode]` section in the `printer.cfg` as follows:

```
[input_shaper]
# Intentionally empty

[delayed_gcode init_shaper]
initial_duration: 0.1
gcode:
  SET_DUAL_CARRIAGE CARRIAGE=1
  SET_INPUT_SHAPER SHAPER_TYPE_X=<dual_carriage_shaper> SHAPER_FREQ_X=<dual_carriage_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
  SET_DUAL_CARRIAGE CARRIAGE=0
  SET_INPUT_SHAPER SHAPER_TYPE_X=<primary_carriage_shaper> SHAPER_FREQ_X=<primary_carriage_freq> SHAPER_TYPE_Y=<y_shaper> SHAPER_FREQ_Y=<y_freq>
```

However, users of `generic_cartesian` kinematics should specify carriage names in `CARRIAGE=` parameters of `SET_DUAL_CARRIAGE` instead of their numbers. Note that `SHAPER_TYPE_Y` and `SHAPER_FREQ_Y` should be the same in both commands. If you need to configure an input shaper for Z axis, include its parameters in both `SET_INPUT_SHAPER` commands.

Besides `delayed_gcode`, it is also possible to put a similar snippet into the start g-code in the slicer, however then the shaper will not be enabled until any print is started.

Note that the input shaper only needs to be configured once. Subsequent changes of the carriages or their modes via `SET_DUAL_CARRIAGE` command will preserve the configured input shaper parameters.

### input_shaper affecte-t-il le temps d'impression ?

Non, la fonctionnalité `input_shaper` n'a pratiquement aucun impact sur les temps d'impression. Cependant, la valeur de `max_accel` en a un (réglage de ce paramètre décrit dans [cette section](#selecting-max_accel)).

### Should I enable and tune input shaper for Z axis?

Most of the users are not likely to see improvements in the quality of the prints directly, much unlike X and Y shapers. However, users of delta printers, printers with flying gantry, or printers with heavy moving beds may be able to increase the `max_z_accel` and `max_z_velocity` kinematics limits and thus get faster Z movements. This can be especially useful e.g. for toolchangers, but also when Z-hops are enabled in slicer. And in general, after enabling Z input shaper many users will hear that Z axis operates more smoothly, which may increase the comfort of printer operation, and may somewhat extend lifespan of Z axis parts.

## Détails techniques

### Input shapers

This section contains a brief overview of some technical aspects of the supported input shapers. Input shapers used in Klipper are rather standard, with the exception of MZV, and one can find more in-depth overview in the articles describing the corresponding shapers.

MZV stands for a Modified-ZV input shaper. The classic definition of ZV shaper assumes two pulses and the total duration `t` equal to 1/2 of the damped period of oscillations `Td`. However, it is possible to construct a generalized form of ZV input shaper with `n >= 3` pulses and an arbitrary total duration `t >= 0.5 * Td` (with the maximum of `t` depending on `n` value), see for instance SNA-ZV and MIS-ZV input shapers, which can be seen as special cases of a more generalized implementation of MZV input shaper in Klipper. The default MZV parameters in Klipper are `n=3`, `t=0.75` (of `Td`), and this shaper was designed to serve as an intermediate shaper between ZV and ZVD, offering better vibrations suppression than ZV when the determined (measured) shaper parameters deviate from the ones actually required by the printer, and smaller smoothing than ZVD. Effectively, its specific duration `t=0.75`, exactly between ZV (with `t=0.5` of `Td`) and ZVD (`t=1` of `Td`), and it happens to work well for many real-life 3D printers. However, experienced users can modify the default parameters of the MZV input shaper and try other variations that may work better for their specific printers (with these non-default variations specified as, e.g. `mzv(n=3,t=0.8)` or `mzv(n=5,t=1.1)` in the `[input_shaper]` section or as a parameter to `SET_INPUT_SHAPER` command, as well as in a parameter to `~/klipper/scripts/calibrate_shaper.py` script, e.g. as `--shapers='2hump_ei,3hump_ei,mzv(n=6,t=1.0)'`. These custom parameters of the shapers are supported by `~/klipper/scripts/graph_shaper.py` scripts via e.g. `--shaper='mzv(n=3,t=0.6666666666)'` parameter.

The table below shows some (usually approximate) parameters of each shaper with their default parameters.

| Input <br> shaper | Durée de <br> l'input shaper | Réduction des vibrations 20x <br> (5 % de tolérance aux vibrations) | Réduction des vibrations 10x <br> (tolérance aux vibrations de 10 %) |
| :-: | :-: | :-: | :-: |
| ZV | 0,5 / shaper_freq | N/A | ± 5% shaper_freq |
| MZV | 0,75 / shaper_freq | ± 4% shaper_freq | -10%...+15% shaper_freq |
| ZVD | 1 / shaper_freq | ± 15% shaper_freq | ± 22% shaper_freq |
| EI | 1 / shaper_freq | ± 20% shaper_freq | ± 25% shaper_freq |
| 2HUMP_EI | 1,5 / shaper_freq | -40...+45% shaper_freq | -45..+50% shaper_freq |
| 3HUMP_EI | 2 / shaper_freq | -50...+60% shaper_freq | -55%...+65% shaper_freq |

A note on vibration reduction: the values in the table above are approximate. If the damping ratio of the printer is known for each axis, the shaper can be configured more precisely and it will then reduce the resonances in a bit wider range of frequencies. However, the damping ratio is usually unknown and is hard to estimate without a special equipment, so Klipper uses 0.1 value by default, which is a good all-round value. The frequency ranges in the table cover a number of different possible damping ratios around that value (approx. from 0.075 to 0.15).

Also note that EI, 2HUMP_EI, and 3HUMP_EI are tuned to reduce vibrations to 5%, so the values for 10% vibration tolerance are provided only for the reference. However, a user can force a desired vibration tolerance for EI input shaper in a manner similar to MZV input shaper as, e.g. `ei(v_tol=0.02)` or `ei(v_tol=0.1)`, in which case the vibration reduction range will be different.

**Comment utiliser ce tableau :**

* La durée de l'input shaper affecte le lissage des pièces - plus elle est grande, plus les pièces sont lisses. Cette dépendance n'est pas linéaire, mais peut donner une idée des input shapers qui "lissent" le plus pour une même fréquence. L'ordre par lissage est le suivant : ZV < MZV < ZVD ≈ EI < 2HUMP_EI < 3HUMP_EI. De plus, il est rarement pratique de régler shaper_freq = fréquence de résonance des types 2HUMP_EI et 3HUMP_EI (utilisés pour réduire les vibrations sur plusieurs fréquences).
* On peut estimer une gamme de fréquences pour laquelle l'input shaper réduit les vibrations. Par exemple, MZV avec shaper_freq = 35 Hz réduit les vibrations à 5 % pour les fréquences [33,6, 36,4] Hz. 3HUMP_EI avec shaper_freq = 50 Hz réduit les vibrations à 5 % dans la plage [27,5 - 75] Hz.
* One can use this table to check which shaper they should be using if they need to reduce vibrations at several frequencies. For example, if one has resonances at 35 Hz and 60 Hz on the same axis: a) EI shaper needs to have shaper_freq = 35 / (1 - 0.2) = 43.75 Hz, and it will reduce resonances until 43.75 * (1 + 0.2) = 52.5 Hz, so it is not sufficient; b) 2HUMP_EI shaper needs to have shaper_freq = 35 / (1 - 0.4) = 58.3 Hz and will reduce vibrations until 58.3 * (1 + 0.45) = 84.5 Hz - so this is an acceptable configuration. Always try to use as high shaper_freq as possible for a given shaper (perhaps with some safety margin, so in this example shaper_freq ≈ 55 Hz would work best), and try to use a shaper with as small shaper duration as possible.
* Si l'on a besoin de réduire les vibrations de plusieurs fréquences très différentes (par exemple, 30 Hz et 100 Hz), le tableau ci-dessus ne fournit pas suffisamment d'informations. Dans ce cas, on peut avoir plus de chance avec le script [scripts/graph_shaper.py](../scripts/graph_shaper.py), qui est plus flexible.
