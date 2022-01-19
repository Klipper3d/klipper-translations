# Capteur de largeur de filament TSL1401CL

This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on TSL1401CL linear sensor array but it can work with any sensor array that has analog output. You can find designs at [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor).

To use a sensor array as a filament width sensor, read [Config Reference](Config_Reference.md#tsl1401cl_filament_width_sensor) and [G-Code documentation](G-Codes.md#Filament_Width_Sensor_Commands).

## Comment ça marche ?

Le capteur génère une sortie analogique basée sur la largeur calculée du filament. La tension de sortie est toujours égale à la largeur de filament détectée (ex. 1,65v, 1,70v, 3,0v). Le module hôte surveille les changements de tension et ajuste le multiplicateur d'extrusion.

## Note:

Les lectures du capteur sont effectuées par défaut avec des intervalles de 10 mm. Si nécessaire, vous pouvez modifier ce paramètre en modifiant le paramètre ***MEASUREMENT_INTERVAL_MM*** dans le fichier **filament_width_sensor.py**.
