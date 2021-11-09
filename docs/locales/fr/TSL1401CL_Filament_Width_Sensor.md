# Capteur de largeur de filament TSL1401CL

Ce document décrit le module hôte du capteur de largeur de filament. Le matériel utilisé pour développer ce module hôte est basé sur le réseau de capteurs linéaires TSL1401CL, mais il peut fonctionner avec n'importe quel réseau de capteurs ayant une sortie analogique. Vous pouvez trouver les conceptions sur [thingiverse.com](https://www.thingiverse.com/search?q=filament%20width%20sensor)

## Comment ça marche ?

Le capteur génère une sortie analogique basée sur la largeur calculée du filament. La tension de sortie est toujours égale à la largeur de filament détectée (ex. 1,65v, 1,70v, 3,0v). Le module hôte surveille les changements de tension et ajuste le multiplicateur d'extrusion.

## Configuration

    [tsl1401cl_filament_width_sensor]
    pin : analog5
    # Broche d'entrée analogique pour la sortie du capteur sur la carte Ramps.
    
    default_nominal_filament_diameter : 1.75
    # Ce paramètre est exprimé en millimètres (mm).
    
    max_différence : 0.2
    # Différence maximale autorisée du diamètre du filament en millimètres (mm).
    # Si la différence entre le diamètre nominal du filament et la sortie du capteur est supérieure à +- max_difference, le multiplicateur d'extrusion est remis à zéro.
    # que +- max_différence, le multiplicateur d'extrusion est ramené à %100.
    
    measurement_delay 100
    # La distance entre le capteur et la chambre de fusion/le bout chaud en millimètres (mm).
    # Le filament entre le capteur et le bout chaud sera traité comme le diamètre du filament nominal par défaut.
    # Le module hôte fonctionne avec une logique FIFO. Il conserve chaque valeur et position du capteur dans
    # un tableau et les remet dans la bonne position.

Les lectures du capteur sont effectuées par défaut avec des intervalles de 10 mm. Si nécessaire, vous pouvez modifier ce paramètre en modifiant le paramètre ***MEASUREMENT_INTERVAL_MM*** dans le fichier **filament_width_sensor.py**.

## Commandes

**QUERY_FILAMENT_WIDTH** - Retourne la largeur du filament mesurée actuellement comme résultat **RESET_FILAMENT_WIDTH_SENSOR** - Efface toutes les lectures du capteur. Peut être utilisé après un changement de filament. **DISABLE_FILAMENT_WIDTH_SENSOR** - Désactive le capteur de largeur de filament et arrête de l'utiliser pour le contrôle du flux **ENABLE_FILAMENT_WIDTH_SENSOR** - Active le capteur de largeur de filament et commence à l'utiliser pour le contrôle du flux.
