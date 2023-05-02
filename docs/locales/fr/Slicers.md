# Slicers

Ce document fournit certains conseils concernant la configuration d'une application "Slicer" pour une utilisation avec Klipper. Des slicers les plus courants utilisés avec Klipper sont Sli3r, Cura, Simplify3D, etc.

## Définissez le parfum g-code sur 'Marlin'

De nombreux trancheurs ont une option pour configurer le "Parfum G-Code". La valeur par défaut est souvent "Marlin" et cela fonctionne bien avec Klipper. La valeur "Smoothieware" fonctionne également bien avec Klipper.

## Les macros G-code de Klipper

Les trancheurs permettent souvent de configurer les séquences "Start G-Code" et "End G-Code". Il est souvent pratique de définir des macros personnalisées dans le fichier de configuration de Klipper - telles que : `[gcode_macro START_PRINT]` et `[gcode_macro END_PRINT]`. Ensuite, on peut simplement indiquer START_PRINT et END_PRINT dans la configuration du slicer. La définition de ces actions dans la configuration de Klipper peut faciliter la modification des étapes de début et de fin de l'imprimante, car les modifications ne nécessitent pas de nouveau découpage.

Voir [sample-macros.cfg](../config/sample-macros.cfg) par exemple les macros START_PRINT et END_PRINT.

Voir la [référence de configuration](Config_Reference.md#gcode_macro) pour plus de détails sur la définition de macros G-Code.

## Un réglage de rétraction important peut nécessiter un réglage de Klipper

La vitesse et l'accélération maximales des mouvements de rétraction sont contrôlés dans Klipper par les paramètres de configuration `max_extrude_only_velocity` et `max_extrude_only_accel`. Ces paramètres ont une valeur par défaut qui doit bien fonctionner sur de nombreuses imprimantes. Cependant, si l'on a configuré une grande rétraction dans le trancheur (par exemple, 5 mm ou plus), on peut constater qu'ils limitent la vitesse de rétraction souhaitée.

Si vous utilisez une grande distance rétraction, envisagez plutôt de régler le [Pressure advance](Pressure_Advance.md) de Klipper. Dans la cas ou l'on trouve que la tête semble "s'arrêter" pendant la rétraction et l'amorçage, définissez explicitement `max_extrude_only_velocity` et `max_extrude_only_accel` dans le fichier de configuration de Klipper.

## N'activez pas le mode "roue libre"

Le mode "roue libre" est susceptible d'entraîner des impressions de mauvaise qualité avec Klipper. Envisagez d'utiliser à la place le [pressure Advance](Pressure_Advance.md) de Klipper.

Plus précisément, si le slicer modifie considérablement le taux d'extrusion entre les mouvements, Klipper effectuera une décélération et une accélération entre les mouvements. Cela risque d'aggraver les bavures, pas de les améliorer.

En revanche, il est possible (et souvent utile) d'utiliser le réglage « rétracter », le réglage « essuyer » et/ou le réglage « essuyer lors de la rétractation » d'un trancheur.

## Ne pas utiliser la "distance de redémarrage supplémentaire" sur Simplify3d

Ce paramètre peut entraîner de gros changements dans le taux d'extrusion, ce qui peut déclencher la limite d'extrusion maximale de Klipper. Envisagez d'utiliser à la place le [pressure advance](Pressure_Advance.md) de Klipper (Pressure_Advance.md) ou le paramètre de rétractation standard de Simplify3d.

## Désactivez "PreloadVE" sur KISSlicer

Si vous utilisez le trancheur KISSlicer, réglez "PreloadVE" sur zéro. Envisagez d'utiliser à la place le [Pressure Advance](Pressure_Advance.md) de Klipper.

## Désactivez tous les paramètres de "pression d'extrusion avancée"

Certains trancheurs présentent une fonction de "pression d'extrudeuse avancée". Il est recommandé de garder ces options désactivées lors de l'utilisation de Klipper car elles risquent d'entraîner des impressions de mauvaise qualité. Envisagez d'utiliser à la place la [Pressure Advance](Pressure_Advance.md) de Klipper.

Ces paramètres de trancheur peuvent demander au micrologiciel d'apporter des modifications non contrôlées au taux d'extrusion dans l'espoir que le micrologiciel se rapprochera de ces demandes et que l'imprimante obtiendra approximativement une pression d'extrudeuse souhaitable. Klipper, utilise des calculs cinématiques et une synchronisation précise. Lorsque Klipper reçoit l'ordre d'apporter des modifications importantes au taux d'extrusion, il planifiera les modifications correspondantes de la vitesse, de l'accélération et du mouvement de l'extrudeuse - ce qui n'est pas prévu par le trancheur. Le trancheur peut même commander des taux d'extrusion excessifs au point de déclencher la limite d'extrusion maximale de Klipper.

En revanche, il est possible (et souvent utile) d'utiliser le réglage « rétracter », le réglage « essuyer » et/ou le réglage « essuyer lors de la rétractation » d'un trancheur.

## Macros START_PRINT

Lors de l'utilisation d'une macro START_PRINT ou similaire, il est parfois utile de passer les paramètres des variables du trancheur à la macro.

Dans Cura, pour passer les températures, le gcode de démarrage suivant serait utilisé :

```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

Dans slic3r et ses dérivés tels que PrusaSlicer et SuperSlicer, les éléments suivants seraient utilisés :

START_PRINT EXTRUDER_TEMP=[first_layer_temperature] BED_TEMP=[first_layer_bed_temperature]

Notez également que ces trancheurs insèrent leurs propres codes de chauffe lorsque certaines conditions ne sont pas remplies. Dans Cura, l'existence des variables `{material_bed_temperature_layer_0}` et `{material_print_temperature_layer_0}` suffit à supprimer ces code de chauffe. Dans les dérivés slic3r, vous utiliseriez :

```
M140 S0
M104 S0
```

avant l'appel de la macro. Notez également que SuperSlicer a une option de bouton "gcode personnalisé uniquement", qui permet d'obtenir le même résultat.

Un exemple de macro START_PRINT utilisant ces paramètres peut être trouvé dans config/sample-macros.cfg
