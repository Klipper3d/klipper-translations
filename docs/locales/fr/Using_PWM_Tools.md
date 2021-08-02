# Using PWM tools

Ce document décrit comment configurer un laser ou une broche contrôlée par PWM en utilisant `output_pin` et quelques macros.

## Comment ça marche ?

En ré-utilisant la sortie pwm du ventilateur de la tête d'impression, vous pouvez contrôler des lasers ou des broches. Ceci est utile si vous utilisez des têtes d'impression commutables, par exemple le changeur d'outils E3D ou une solution DIY. Habituellement, les outils à came tels que LaserWeb peuvent être configurés pour utiliser les commandes `M3-M5`, qui correspondent à *vitesse de broche CW* (`M3 S[0-255]`), *vitesse de broche CCW* (`M4 S[0-255]`) et *arrêt de broche* (`M5`).

**Avertissement :** Lorsque vous pilotez un laser, prenez toutes les précautions de sécurité auxquelles vous pouvez penser ! Les lasers à diodes sont généralement inversés. Cela signifie que lorsque l'unité centrale redémarre, le laser sera *complètement allumé* pendant le temps nécessaire à l'unité centrale pour redémarrer. Pour faire bonne mesure, il est recommandé de *toujours* porter des lunettes laser appropriées de la bonne longueur d'onde si le laser est alimenté ; et de déconnecter le laser lorsqu'il n'est pas nécessaire. Vous devriez également configurer un délai de sécurité, de sorte que lorsque votre hôte ou votre MCU rencontre une erreur, l'outil s'arrête.

Pour un exemple de configuration, voir `config/sample-pwm-tool-cfg`.

## Limites actuelles

La fréquence des mises à jour PWM est limitée. Bien qu'elle soit très précise, une mise à jour PWM ne peut se produire que toutes les 0,1 seconde, ce qui la rend presque inutile pour la gravure tramée. Cependant, il existe une [branche expérimentale](https://github.com/Cirromulus/klipper/tree/laser_tool) avec ses propres compromis. A long terme, il est prévu d'ajouter cette fonctionnalité au klipper principal.

## Commandes

`M3/M4 S<valeur>` : Définit le cycle de travail PWM. Valeurs comprises entre 0 et 255. `M5` : Arrête la sortie PWM à la valeur d'arrêt.

## Configuration de Laserweb

Si vous utilisez Laserweb, une configuration fonctionnelle serait la suivante :

    GCODE START :
        M5 ; Désactiver le laser
        G21 ; Définir les unités en mm
        G90 ; Positionnement absolu
        G0 Z0 F7000 ; Régler la vitesse de non coupe
    GCODE END :
        M5 ; Désactiver le laser
        G91 ; relatif
        G0 Z+20 F4000 ;
        G90 ; absolu
    GCODE HOMING :
        M5 ; Désactiver le laser
        G28 ; Déplacement sur tous les axes
    TOOL ON :
        M3 $INTENSITÉ
    TOOL OFF :
        M5 ; Désactiver le laser
    INTENSITÉ DU LASER :
        S
