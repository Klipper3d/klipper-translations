# Détecteur de largeur de filament à effet hall

This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on two Hall linear sensors (ss49e for example). Sensors in the body are located on opposite sides. Principle of operation: two hall sensors work in differential mode, temperature drift same for sensor. Special temperature compensation not needed.

Vous trouverez les modèles sur [Thingiverse](https://www.thingiverse.com/thing:4138933), une vidéo de montage est également disponible sur [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4)

Pour utiliser le capteur de largeur de filament de Hall, consultez [Référence des configurations](Config_Reference.md#hall_filament_width_sensor) et [documentation G-Code](G-Codes.md#hall_filament_width_sensor).

## Comment cela fonctionne-t-il ?

Sensor generates two analog output based on calculated filament width. Sum of output voltage always equals to detected filament width. Host module monitors voltage changes and adjusts extrusion multiplier. I use the aux2 connector on a ramps-like board with the analog11 and analog12 pins. You can use different pins and different boards.

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
