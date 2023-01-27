# Détecteur de largeur de filament à effet hall

Ce document décrit le module hôte du capteur de largeur de filament. Le matériel utilisé pour développer ce module hôte est basé sur deux capteurs linéaires de type Hall (ss49e par exemple). Les capteurs dans le corps sont situés sur des côtés opposés. Principe de fonctionnement : deux capteurs Hall fonctionnent en mode différentiel, la dérive de température est la même pour tous les capteurs. Une compensation spéciale de la température n'est donc pas nécessaire.

Vous trouverez les modèles sur [Thingiverse](https://www.thingiverse.com/thing:4138933), une vidéo de montage est également disponible sur [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)

Pour utiliser le capteur de largeur de filament de Hall, consultez [Référence des configurations](Config_Reference.md#hall_filament_width_sensor) et [documentation G-Code](G-Codes.md#hall_filament_width_sensor).

## Comment cela fonctionne-t-il ?

Le capteur génère deux sorties analogiques basées sur la largeur calculée du filament. La somme des tensions de sortie est toujours égale à la largeur de filament détectée. Le module hôte surveille les changements de tension et ajuste le multiplicateur d'extrusion. J'utilise le connecteur aux2 sur les broches analogiques 11 et 12 d'une carte genre Ramps. Vous pouvez utiliser des broches différentes et des cartes différentes.

## Modèle pour les variables du menu

```
[menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
```

## Procédure d'étalonnage

Pour obtenir la valeur brute du capteur, vous pouvez utiliser le menu ou la commande **QUERY_RAW_FILAMENT_WIDTH** dans le terminal.

1. Insérer la première tige d'étalonnage (taille 1,5 mm) pour obtenir la première valeur brute du capteur
1. Insérer une deuxième tige d'étalonnage (taille 2,0 mm) pour obtenir la deuxième valeur brute du capteur
1. Enregistrer les valeurs brutes des capteurs dans les paramètres de configuration `Raw_dia1` et `Raw_dia2`

## Comment activer le capteur

Par défaut, le capteur est désactivé à la mise sous tension.

Pour activer le capteur, lancez la commande **ENABLE_FILAMENT_WIDTH_SENSOR** ou définissez le paramètre `enable` sur `true`.

## Journalisation

Par défaut, la journalisation du diamètre est désactivée à la mise sous tension.

Envoyez la commande **ENABLE_FILAMENT_WIDTH_LOG** pour démarrer la journalisation, envoyez la commande **DISABLE_FILAMENT_WIDTH_LOG** pour l'arrêter. Pour activer la journalisation à la mise sous tension, définissez le paramètre `logging` à `true`.

Le diamètre du filament est enregistré à chaque intervalle de mesure (10 mm par défaut).
