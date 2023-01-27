# Capteur de largeur de filament TSL1401CL

Ce document décrit le module hôte du capteur de largeur de filament. Le matériel utilisé pour développer ce module hôte est basé sur le réseau de capteurs linéaires TSL1401CL, mais il peut fonctionner avec tout réseau de capteurs ayant une sortie analogique. Vous pouvez trouver les conceptions sur [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

Pour utiliser un réseau de capteurs comme capteur de largeur de filament, consultez [Config Reference](Config_Reference.md#tsl1401cl_filament_width_sensor) et [documentation G-Code](G-Codes.md#hall_filament_width_sensor).

## Comment cela fonctionne-t-il ?

Le capteur génère une sortie analogique basée sur la largeur calculée du filament. La tension de sortie est toujours égale à la largeur de filament détectée (ex. 1,65v, 1,70v, 3,0v). Le module hôte surveille les changements de tension et ajuste le multiplicateur d'extrusion.

## Note :

Les lectures du capteur sont effectuées par défaut avec des intervalles de 10 mm. Si nécessaire, vous pouvez modifier ce paramètre en modifiant le paramètre ***MEASUREMENT_INTERVAL_MM*** dans le fichier **filament_width_sensor.py**.
