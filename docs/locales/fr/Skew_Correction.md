# Correction de l'équerrage

La correction logicielle de l'équerrage peut aider à résoudre les inexactitudes dimensionnelles résultant d'un assemblage d'imprimante qui n'est pas parfaitement d'équerre. Notez que si votre imprimante est considérablement asymétrique, il est fortement recommandé d'utiliser d'abord des moyens mécaniques pour obtenir une imprimante le plus d'équerre possible avant d'appliquer la correction basée sur le logiciel.

## Impression d'un objet de calibrage

La première étape de la correction de l'équerrage consiste à imprimer un [objet d'étalonnage](https://www.thingiverse.com/thing:2563185/files) le long du plan que vous souhaitez corriger. Il existe également un [objet d'étalonnage](https://www.thingverse.com/thing:2972743) qui inclut tous les plans dans un seul modèle. Veuillez à orienter l'objet de sorte que le coin A soit vers l'origine du plan.

Assurez-vous qu'aucune correction d'équerrage n'est appliquée pendant cette impression. Vous pouvez le faire en supprimant le module `[skew_correction]` du fichier printer.cfg ou en tapant un gcode `SET_SKEW CLEAR=1`.

## Prenez vos mesures

Le module `[skew_correcton]` nécessite 3 mesures pour chaque plan que vous souhaitez corriger ; la longueur du coin A au coin C, la longueur du coin B au coin D et la longueur du coin A au coin D. Lors de la mesure de la longueur AD, n'incluez pas les plats sur les coins fournis par certains objets de test.

![skew_lengths](img/skew_lengths.png)

## Configurez votre équerrage

Assurez-vous que `[skew_correction]` est bien dans le fichier printer.cfg. Vous pouvez maintenant utiliser le gcode `SET_SKEW` pour configurer skew_correcton. Par exemple, si vos longueurs mesurées le long de XY sont les suivantes :

```
Length AC = 140.4
Length BD = 142.8
Length AD = 99.8
```

`SET_SKEW` peut être utilisé pour configurer la correction d'équerrage pour le plan XY.

```
SET_SKEW XY=140.4,142.8,99.8
```

Vous pouvez également ajouter des mesures pour XZ et YZ au gcode :

```
SET_SKEW XY=140.4,142.8,99.8 XZ=141.6,141.4,99.8 YZ=142.4,140.5,99.5
```

Le module `[skew_correction]` prend également en charge la gestion des profils d'une manière similaire à `[bed_mesh]`. Après avoir défini la correction d'équerrage à l'aide du gcode `SET_SKEW`, vous pouvez utiliser le gcode `SKEW_PROFILE` pour l'enregistrer :

```
SKEW_PROFILE SAVE=my_skew_profile
```

Après cette commande, vous serez invité à saisir un `SAVE_CONFIG` pour enregistrer le profil de manière permanente. Si aucun profil n'est nommé `my_skew_profile` alors un nouveau profil sera créé. Si le profil nommé existe, il sera écrasé.

Une fois que vous avez un profil enregistré, vous pouvez le charger :

```
SKEW_PROFILE LOAD=my_skew_profile
```

Il est également possible de supprimer un profil ancien ou obsolète :

```
SKEW_PROFILE REMOVE=my_skew_profile
```

Après avoir supprimé un profil, vous serez invité à saisir un `SAVE_CONFIG` pour que cette suppression soit sauvegardée.

## Vérification de votre correction

Une fois que skew_correction a été configuré, vous pouvez réimprimer l'objet de calibrage avec la correction activée. Utilisez le g-code suivant pour vérifier votre équerrage sur chaque plan. Les résultats devraient être inférieurs à ceux rapportés via `GET_CURRENT_SKEW`.

```
CALC_MEASURED_SKEW AC=<ac_length> BD=<bd_length> AD=<ad_length>
```

## Avertissements

En raison de la nature de la correction de l'équerrage, il est recommandé de configurer la correction dans votre gcode de démarrage, après la mise à l'origine et après tout type de mouvement qui se déplace près du bord de la zone d'impression, comme une purge ou un essuyage de buse. Vous pouvez utiliser les gcodes `SET_SKEW` ou `SKEW_PROFILE` pour le faire. Il est également recommandé d'émettre un `SET_SKEW CLEAR=1` dans votre gcode final.

Gardez à l'esprit qu'il est possible que `[skew_correction]` génère une correction qui déplace l'outil au-delà des limites de l'imprimante sur les axes X et/ou Y. Il est recommandé d'éloigner les pièces des bords lors de l'utilisation de `[skew_correction]`.
